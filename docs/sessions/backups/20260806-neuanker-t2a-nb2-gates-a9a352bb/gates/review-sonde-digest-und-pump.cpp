// Opus-Zweit-Review T2-A-Serie: eigene Nachmessungen, unabhaengig vom Bau-Bericht.
#include <builder/artifact_transport/async_push_pump.hpp>
#include <builder/bestandslog/planer_driven_build.hpp>

#include <atomic>
#include <chrono>
#include <cstdio>
#include <stdexcept>
#include <string>
#include <thread>
#include <vector>

namespace bl = ::comdare::cache_engine::builder::bestandslog;
namespace at = ::comdare::cache_engine::builder::artifact_transport;

int fehler = 0;
static void pruefe(char const* was, bool ok) {
    std::printf("  [%s] %s\n", ok ? "OK " : "ERR", was);
    if (!ok) ++fehler;
}

int main() {
    std::vector<std::size_t> const idx{0, 1, 2, 3, 4, 5, 6, 7};

    // =====================================================================================
    // (A) DIE KERNFRAGE 2(c): bindet |bau= wirklich die Bau-Identitaet -- und was tut es OHNE Anker?
    // =====================================================================================
    std::puts("\n-- (A) plan_bau_digest: Bindung und Kollisions-Eimer --");
    auto const fpA = bl::PlanIdentitaetFn{[](std::size_t i) { return std::string(128, 'a') + std::to_string(i); }};
    auto const fpB = bl::PlanIdentitaetFn{[](std::size_t i) { return std::string(128, 'b') + std::to_string(i); }};
    // EIN einziger Index anders gestempelt -- reicht das?
    auto const fpA1 = bl::PlanIdentitaetFn{[](std::size_t i) {
        return (i == 3) ? std::string(128, 'z') : std::string(128, 'a') + std::to_string(i);
    }};

    std::string const s_A  = bl::slice_plan_stamp(idx, 4, fpA);
    std::string const s_B  = bl::slice_plan_stamp(idx, 4, fpB);
    std::string const s_A1 = bl::slice_plan_stamp(idx, 4, fpA1);
    std::string const s_o1 = bl::slice_plan_stamp(idx, 4, {});
    std::string const s_o2 = bl::slice_plan_stamp(idx, 4, bl::PlanIdentitaetFn{});

    pruefe("zwei verschiedene Bau-Staende -> verschiedene Stempel", s_A != s_B);
    pruefe("EIN einziger abweichender Fingerprint reicht", s_A != s_A1);
    pruefe("derselbe Bau-Stand -> gleicher Stempel", s_A == bl::slice_plan_stamp(idx, 4, fpA));
    pruefe("MIT Anker != OHNE Anker (die zwei Welten trennen)", s_A != s_o1);
    std::printf("  OHNE-ANKER-Stempel: %s\n", s_o1.c_str());
    // DER KRITISCHE PUNKT: zwei VERSCHIEDENE Bau-Staende, beide ohne Provider.
    pruefe("!! OHNE Anker sind ZWEI VERSCHIEDENE Bau-Staende stempel-GLEICH (Kollisions-Eimer)", s_o1 == s_o2);
    pruefe("Glied |bau=ohne-anker literal im Stempel", s_o1.find("|bau=ohne-anker") != std::string::npos);

    // Der Zaehler-Leser akzeptiert damit einen Alt-Zaehler aus dem anderen Bau-Stand:
    std::vector<bl::PlanFach> const faecher{{0, 4, 4}, {4, 4, 4}};
    std::string const               rows = "|rows=";
    std::string const alt = bl::render_phasen_zaehler(s_o1, bl::PhasenZaehler{8, 0}, faecher.size(), rows);
    auto const        gelesen = bl::parse_phasen_zaehler(alt, s_o2, faecher, rows);
    pruefe("!! und der Zaehler-Leser NIMMT ihn an (Resume ueber fremden Bau-Stand)", gelesen.has_value());
    if (gelesen) std::printf("  -> kompiliert=%llu, plan_resume_faecher=%zu von %zu\n",
                             static_cast<unsigned long long>(gelesen->kompiliert),
                             bl::plan_resume_faecher(faecher, gelesen->kompiliert), faecher.size());
    // Gegenprobe MIT Anker: derselbe Aufbau wird abgelehnt.
    std::string const alt_A = bl::render_phasen_zaehler(s_A, bl::PhasenZaehler{8, 0}, faecher.size(), rows);
    pruefe("Gegenprobe MIT Anker: Zaehler aus Bau-Stand A gilt fuer B NICHT",
           !bl::parse_phasen_zaehler(alt_A, s_B, faecher, rows).has_value());

    // =====================================================================================
    // (B) GLIED-GRENZE des Plan-Stempels selbst (Analogie zur Versions-Marke des Lesers)
    // =====================================================================================
    std::puts("\n-- (B) Glied-Grenze des Plan-Stempels --");
    // Ein laengerer Stempel darf nicht als der kuerzere durchgehen (Praefix-Falle).
    std::string const s_korn4  = bl::slice_plan_stamp(idx, 4, fpA);
    std::string const s_korn40 = bl::slice_plan_stamp(idx, 40, fpA);
    std::string const doc4     = bl::render_phasen_zaehler(s_korn40, bl::PhasenZaehler{8, 0}, faecher.size(), rows);
    pruefe("Zaehler mit korn=40 gilt NICHT fuer korn=4 (Feld-Ordnung faengt es)",
           !bl::parse_phasen_zaehler(doc4, s_korn4, faecher, rows).has_value());

    // =====================================================================================
    // (C) NEBENLAEUFIGKEIT: AsyncPushPump::drain
    // =====================================================================================
    std::puts("\n-- (C) AsyncPushPump::drain -- Barriere, Doppel-drain, drain nach close --");
    {
        std::atomic<bool>        halt{true};
        std::atomic<int>         gesehen{0};
        at::AsyncPushPump        pump{[&](std::filesystem::path const&, std::string const&) {
                                   ++gesehen;
                                   while (halt.load()) std::this_thread::yield();
                                   throw std::runtime_error("push wirft");
                               },
                               "bv"};
        pump.enqueue("a");
        while (gesehen.load() == 0) std::this_thread::yield(); // der Push LAEUFT
        pruefe("waehrend der Push laeuft ist NICHTS gebucht", pump.failed_count() == 0 && pump.pushed_count() == 0);
        halt.store(false);
        pump.drain();
        pruefe("nach drain() ist der Fehl-Push gebucht", pump.failed_count() == 1);
        pruefe("Doppel-drain kehrt zurueck (kein Haenger)", (pump.drain(), true));
        // der Pump lebt weiter
        halt.store(true);
        gesehen.store(0);
        pump.enqueue("b");
        while (gesehen.load() == 0) std::this_thread::yield();
        halt.store(false);
        pump.drain();
        pruefe("der Pump lebt nach der Barriere weiter (zweiter Eintrag)", pump.failed_count() == 2);
        pump.close();
        pruefe("drain() NACH close() haengt nicht", (pump.drain(), true));
        pruefe("close() ist idempotent", (pump.close(), true));
    }
    // (C2) drain WAEHREND close aus einem FREMDEN Thread -- der Kontrakt verbietet es; haengt es trotzdem?
    {
        std::atomic<bool>  halt{true};
        std::atomic<int>   gesehen{0};
        at::AsyncPushPump  pump{[&](std::filesystem::path const&, std::string const&) {
                                   ++gesehen;
                                   while (halt.load()) std::this_thread::yield();
                               },
                               "bv"};
        pump.enqueue("a");
        pump.enqueue("b");
        while (gesehen.load() == 0) std::this_thread::yield();
        std::atomic<bool> drain_fertig{false};
        std::thread       t{[&] {
            pump.drain();
            drain_fertig.store(true);
        }};
        std::this_thread::sleep_for(std::chrono::milliseconds(20));
        halt.store(false);
        pump.close(); // parallele Schliessung waehrend eines Wartens
        for (int i = 0; i < 2000 && !drain_fertig.load(); ++i)
            std::this_thread::sleep_for(std::chrono::milliseconds(1));
        pruefe("drain aus FREMDEM Thread haengt auch bei paralleler Schliessung nicht", drain_fertig.load());
        t.join();
        pruefe("beide Eintraege sind abgearbeitet", pump.pushed_count() == 2);
    }
    // (C3) Stress: viele enqueue/drain-Runden -- Weckruf-Verlust wuerde hier haengen
    {
        std::atomic<int>  n{0};
        at::AsyncPushPump pump{[&](std::filesystem::path const&, std::string const&) { ++n; }, "bv"};
        for (int r = 0; r < 200; ++r) {
            for (int k = 0; k < 8; ++k) pump.enqueue("x");
            pump.drain();
            if (n.load() != (r + 1) * 8) {
                pruefe("Barriere haelt in jeder Runde", false);
                break;
            }
        }
        pruefe("200 Runden x 8 Pushes: nach jedem drain ist alles gebucht", n.load() == 1600);
    }

    std::printf("\n== FEHLER: %d ==\n", fehler);
    return fehler == 0 ? 0 : 1;
}
