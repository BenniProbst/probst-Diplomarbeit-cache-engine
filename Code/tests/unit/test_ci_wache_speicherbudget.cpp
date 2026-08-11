// test_ci_wache_speicherbudget.cpp -- haelt das Bau-Parallelitaets-Budget?   (2026-08-10)
// =============================================================================
// OWNER-AUFTRAG 10.08.2026, woertlich: "sie vertraegt nur eine Pipeline zu einer Zeit,
// sonst OOM bei RAM. Lass es so, aber ab sofort sequentielle pipelines und mal schauen,
// ob nicht dort speicher eingespart sein kann."
//
// WAS DIESE WACHE PRUEFT -- und warum es sie vorher nicht gab:
// `.gitlab-ci.yml` setzt CMAKE_BUILD_PARALLEL_LEVEL GLOBAL. Der Wert wirkt damit in
// JEDEM Bau-Job. Wieviel Speicher das im schlimmsten Fall zieht, ergibt sich erst aus
// drei Zahlen, die in DREI VERSCHIEDENEN Systemen stehen und nirgends gegeneinander
// gerechnet wurden:
//     (a) Jobs gleichzeitig je Maschine  -> Runner-Konfiguration (INFRA, nicht im Repo)
//     (b) Uebersetzer gleichzeitig je Job -> CMAKE_BUILD_PARALLEL_LEVEL (diese Datei)
//     (c) Speicher je Uebersetzer-Prozess -> Eigenschaft des Baums, nur messbar
// Das Produkt a*b*c ist der Spitzenbedarf. Es wurde nie gebildet.
//
// DER BEFUND, DER DIESE WACHE AUSGELOEST HAT (10.08.2026, am Objekt gemessen):
// Der Kommentar an `.gitlab-ci.yml:68` begruendet den Wert 6 mit "2x6 Kerne bei
// concurrent=2". Die Praemisse ist FALSCH. `/usr/local/sbin/runner-mode.sh:43` setzt im
// Normalbetrieb NORMAL_CC=4 fuer prod1 UND prod2 -- also VIER Jobs gleichzeitig, nicht
// zwei. Der Budget-Ansatz war damit seit der Umstellung um den Faktor 2 zu klein
// gerechnet, ohne dass irgendetwas rot wurde.
//
// DIE MESSUNG (10.08.2026, prod1, GCC 15.3.0, Release-Flags aus compile_commands.json
// des Baums build-warn-rel; MaxRSS ueber /usr/bin/time -v):
//     Stichprobe 26 TUs aus 635 (18 Nicht-Permutation + 8 Permutation)
//     Permutations-TUs   Median 580,5 MB   Max 582,6 MB   (61 TUs, nicht 53)
//     uebrige TUs        Median 292,0 MB   Max 660,3 MB   (apps/adhoc_emitter/main.cpp)
//     GROESSTE GEMESSENE TU = 660,3 MB -> als kMaxRssMbProTu konservativ 660 gesetzt
//
// WARUM DER WERT NICHT AN DEN FLAGS ZU SENKEN IST (ebenfalls gemessen, dieselbe TU):
//     -fsyntax-only (nur Front-End)  529,3 MB      <- 91 % des Bedarfs
//     -O0 -g0                        529,1 MB
//     -O0 -g3                        562,2 MB      <- Debug-Symbole  +33 MB
//     -O1                            575,9 MB
//     -O2                            580,6 MB
//     -O3 (Bestand)                  581,6 MB      <- Optimierer     +52 MB
// Neun Zehntel des Speichers gehen in die Template-Instanziierung im Front-End. Ein
// Absenken der Optimierungsstufe kaufte 9 % und kostete die gesamte Laufzeit-Aussage der
// Messung; Debug-Symbole kosten in der CI NICHTS, weil der Release-Bau gar kein -g
// traegt (nachgesehen in compile_commands.json). Der einzige wirksame Hebel ist also
// NICHT c, sondern das Produkt a*b -- und genau das haelt diese Wache fest.
//
// WAS SIE NICHT KANN, AUSDRUECKLICH BENANNT (V-8): sie liest die LEBENDE
// Runner-Konfiguration nicht. `/etc/gitlab-runner/config.toml` ist fuer den CI-Benutzer
// nicht lesbar (Permission denied, gegengeprueft 10.08.) und waere auch in einem
// Job nicht verlaesslich vorhanden. kRunnerGleichzeitigeJobs ist deshalb eine
// DEKLARATION im Repo, keine Messung. Sie ist damit die Stelle, die bei einer
// Runner-Umstellung nachgezogen werden MUSS -- und der Kommentar, der das bisher
// leistete, konnte nicht rot werden. Diese Wache kann es.
//
// TESTKRITIK (T-9): strenger Zeilen-Scanner, kein YAML-Parser -- wie die
// Schwester-Wache in test_ci_wache_registrierung.cpp. YAML-Anker, `extends` und
// `include` sieht er nicht. Ein Job, der CMAKE_BUILD_PARALLEL_LEVEL lokal
// UEBERSCHREIBT, ist damit nicht erfasst; die Gegenprobe dazu steht als eigener Fall.
//
// ASCII-only, Zeilen <= 120 Byte.
// =============================================================================

#include <cstddef>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <optional>
#include <string>
#include <string_view>
#include <vector>

#include <gmock/gmock.h>
#include <gtest/gtest.h>

#include "comdare/ci_wachen/ci_yml_scanner.hpp"

namespace {

using comdare::ci_wachen::ist_kommentarzeile;
using comdare::ci_wachen::lies_zeilen;

// ---------------------------------------------------------------------------
// DIE DREI DEKLARIERTEN ZAHLEN. Jede traegt ihre Herkunft, damit ein spaeterer
// Leser sie nachmessen kann statt sie zu glauben.
// ---------------------------------------------------------------------------

// Quelle: /usr/local/sbin/runner-mode.sh:43 -- "prod1) NORMAL_CC=4; NORMAL_J=4; ..."
// gelesen am 10.08.2026. Gilt laut Zeile 44 fuer prod2 gleichlautend.
constexpr std::size_t kRunnerGleichzeitigeJobs = 4;

// Quelle: eigene MaxRSS-Messung 10.08.2026 (siehe Kopf). Groesste von 26 gemessenen TUs.
constexpr std::size_t kMaxRssMbProTu = 660;

// DIE OBERGRENZE. Herleitung, damit sie nicht geraten wirkt:
//   prod1 Gesamtspeicher                                  61554 MB  (free -m, 10.08.)
//   davon dauerhaft in 5 QEMU-Gaesten                    -15800 MB  (ps, 10.08.)
//   Reserve fuer Binder, ccache, Seiten-Cache, Agenten   -21000 MB
//   ------------------------------------------------------------
//   fuer gleichzeitige Uebersetzer                        24754 MB  -> gerundet 24576
// Die Reserve ist bewusst gross: der Binder ist die eigentliche Spitze eines Bau-Jobs
// und steht in dieser Rechnung NICHT (er laeuft nach den Uebersetzern, nicht neben
// ihnen). Wer die Grenze anhebt, hebt sie hier an -- sichtbar und begruendet.
constexpr std::size_t kBudgetObergrenzeMb = 24576;

// ---------------------------------------------------------------------------
// DIE REINE FUNKTION. Sie ist der Pruefling; alle Faelle unten fahren SIE, nicht
// eine Nebenimplementierung -- sonst prueft der Test ein anderes Programm.
// ---------------------------------------------------------------------------

// Liest den GLOBAL gesetzten CMAKE_BUILD_PARALLEL_LEVEL.
// nullopt = nicht gefunden oder nicht als Zahl lesbar. FAIL-CLOSED: "fehlt" und
// "steht auf 0" duerfen nie denselben Wert liefern.
std::optional<std::size_t> lies_parallel_level(const std::vector<std::string>& zeilen) {
    constexpr std::string_view kSchluessel = "CMAKE_BUILD_PARALLEL_LEVEL:";
    for (const auto& zeile : zeilen) {
        if (ist_kommentarzeile(zeile)) {
            continue; // ein auskommentierter Wert ist KEIN gesetzter Wert
        }
        const auto pos = zeile.find(kSchluessel);
        if (pos == std::string::npos) { continue; }
        std::string rest = zeile.substr(pos + kSchluessel.size());
        // Zeilenendkommentar abschneiden -- ".gitlab-ci.yml:68" traegt einen.
        const auto raute = rest.find('#');
        if (raute != std::string::npos) { rest = rest.substr(0, raute); }
        std::string ziffern;
        for (const char c : rest) {
            if (c >= '0' && c <= '9') {
                ziffern.push_back(c);
            } else if (!ziffern.empty()) {
                break; // Ziffernblock zu Ende
            }
        }
        if (ziffern.empty()) { return std::nullopt; }
        return static_cast<std::size_t>(std::stoull(ziffern));
    }
    return std::nullopt;
}

std::size_t spitzenbedarf_mb(std::size_t jobs, std::size_t parallel, std::size_t mb_pro_tu) {
    return jobs * parallel * mb_pro_tu;
}

bool budget_haelt(std::size_t parallel) {
    return spitzenbedarf_mb(kRunnerGleichzeitigeJobs, parallel, kMaxRssMbProTu) <= kBudgetObergrenzeMb;
}

// Wuerfelt aus /dev/urandom. Ein Literal waere fuer den Uebersetzer vorhersagbar und
// koennte -- wie am 09.08. bei test_ms1 belegt -- wegoptimiert werden.
std::size_t wuerfle(std::size_t min_wert, std::size_t max_wert) {
    std::ifstream urandom("/dev/urandom", std::ios::binary);
    unsigned char roh[4] = {0, 0, 0, 0};
    urandom.read(reinterpret_cast<char*>(roh), sizeof(roh));
    const std::size_t wert = (static_cast<std::size_t>(roh[0]) << 24) | (static_cast<std::size_t>(roh[1]) << 16) |
                             (static_cast<std::size_t>(roh[2]) << 8) | static_cast<std::size_t>(roh[3]);
    return min_wert + (wert % (max_wert - min_wert + 1));
}

std::vector<std::string> super_yml() {
    auto zeilen = lies_zeilen(std::filesystem::path(COMDARE_CI_YML_PFAD));
    EXPECT_TRUE(zeilen.has_value()) << "FAIL-CLOSED: " << COMDARE_CI_YML_PFAD << " nicht lesbar";
    return zeilen.value_or(std::vector<std::string>{});
}

// ---------------------------------------------------------------------------
// (1) DER WERT EXISTIERT UEBERHAUPT. Ohne diesen Fall waere jede Zahl unten die
//     Zahl eines Standardwerts, nicht die der Datei.
// ---------------------------------------------------------------------------
TEST(CiSpeicherbudget, SuperYmlDeklariertDieBauParallelitaet) {
    const auto zeilen = super_yml();
    ASSERT_FALSE(zeilen.empty()) << "FAIL-CLOSED: keine Zeilen gelesen";

    const auto j = lies_parallel_level(zeilen);
    ASSERT_TRUE(j.has_value()) << "CMAKE_BUILD_PARALLEL_LEVEL steht in keiner WIRKSAMEN Zeile von "
                               << COMDARE_CI_YML_PFAD;
    EXPECT_GT(*j, 0U) << "Ein Wert 0 waere ein unbegrenztes -j und damit das Gegenteil eines Deckels";

    std::printf("[ NENNER   ] Datei=%s  Zeilen=%zu  CMAKE_BUILD_PARALLEL_LEVEL=%zu\n", COMDARE_CI_YML_PFAD,
                zeilen.size(), *j);
}

// ---------------------------------------------------------------------------
// (2) DIE ZUSICHERUNG. Nicht "die Variable ist da", sondern: das Produkt passt.
// ---------------------------------------------------------------------------
TEST(CiSpeicherbudget, SpitzenbedarfBleibtUnterDerObergrenze) {
    const auto zeilen = super_yml();
    const auto j      = lies_parallel_level(zeilen);
    ASSERT_TRUE(j.has_value()) << "FAIL-CLOSED: ohne gelesenen Wert wird hier NICHT gruen gemeldet";

    const std::size_t bedarf = spitzenbedarf_mb(kRunnerGleichzeitigeJobs, *j, kMaxRssMbProTu);

    std::printf("[ NENNER   ] Jobs=%zu x parallel=%zu x %zu MB/TU = %zu MB  Obergrenze=%zu MB\n",
                kRunnerGleichzeitigeJobs, *j, kMaxRssMbProTu, bedarf, kBudgetObergrenzeMb);

    EXPECT_LE(bedarf, kBudgetObergrenzeMb)
        << "Das Bau-Budget ueberschreitet den Speicher, den prod1 dafuer uebrig hat.\n"
        << "Entweder CMAKE_BUILD_PARALLEL_LEVEL senken, oder -- wenn der Runner umgestellt\n"
        << "wurde -- kRunnerGleichzeitigeJobs hier nachziehen und die Grenze neu herleiten.";
}

// ---------------------------------------------------------------------------
// (3) FREMDER NENNER (T-3/V-7): der zweite Wert kommt aus einer ANDEREN Datei in
//     einem ANDEREN Repository. Beide Pipelines teilen sich denselben Runner --
//     driften die Werte auseinander, stimmt die Budget-Rechnung fuer eine von
//     beiden nicht mehr, und niemand merkt es.
// ---------------------------------------------------------------------------
TEST(CiSpeicherbudget, CeUndSuperDeklarierenDenselbenWert) {
    const auto super_zeilen = super_yml();
    const auto super_j      = lies_parallel_level(super_zeilen);
    ASSERT_TRUE(super_j.has_value());

    const std::filesystem::path ce_yml =
        std::filesystem::path(COMDARE_REPO_WURZEL) / "Code/external/comdare-cache-engine/.gitlab-ci.yml";
    const auto ce_zeilen = lies_zeilen(ce_yml);
    ASSERT_TRUE(ce_zeilen.has_value()) << "FAIL-CLOSED: ce-.gitlab-ci.yml nicht lesbar unter " << ce_yml.string()
                                       << " -- ist das Submodul ausgecheckt?";
    const auto ce_j = lies_parallel_level(*ce_zeilen);
    ASSERT_TRUE(ce_j.has_value()) << "ce deklariert CMAKE_BUILD_PARALLEL_LEVEL nicht wirksam";

    std::printf("[ NENNER   ] super=%zu (%zu Zeilen)   ce=%zu (%zu Zeilen)\n", *super_j, super_zeilen.size(), *ce_j,
                ce_zeilen->size());

    EXPECT_EQ(*super_j, *ce_j) << "super und ce bauen auf DEMSELBEN Runner. Zwei verschiedene Deckel\n"
                               << "bedeuten, dass die Budget-Rechnung fuer mindestens eines der beiden\n"
                               << "Repositories nicht mehr gilt.";
}

// ---------------------------------------------------------------------------
// (4) GEGENEINGANG (T-4) + KOEDER (K13): ein Eingang, bei dem die Zusage NICHT
//     gilt. Der Wert wird gewuerfelt, nicht abgeschrieben.
// ---------------------------------------------------------------------------
TEST(CiSpeicherbudget, GegeneingangUeberbuchungWirdAbgelehnt) {
    // Kleinster Wert, der ueberbucht: Obergrenze / (Jobs * MB) aufgerundet.
    const std::size_t erste_ueberbuchung = (kBudgetObergrenzeMb / (kRunnerGleichzeitigeJobs * kMaxRssMbProTu)) + 1;
    const std::size_t koeder             = wuerfle(erste_ueberbuchung, erste_ueberbuchung + 40);

    std::printf("[ KOEDER   ] gewuerfelt=%zu (erste Ueberbuchung ab %zu)  Bedarf=%zu MB > %zu MB\n", koeder,
                erste_ueberbuchung, spitzenbedarf_mb(kRunnerGleichzeitigeJobs, koeder, kMaxRssMbProTu),
                kBudgetObergrenzeMb);

    EXPECT_FALSE(budget_haelt(koeder)) << "Der Koeder haette beissen muessen -- die Wache ist blind.";

    // Und derselbe Weg mit einer gewuerfelten Zeile durch den ECHTEN Parser, damit
    // nicht nur die Arithmetik, sondern auch das Lesen geprueft ist.
    const std::vector<std::string> gefaelscht = {"variables:",
                                                 "  CMAKE_BUILD_PARALLEL_LEVEL: \"" + std::to_string(koeder) + "\""};
    const auto                     gelesen    = lies_parallel_level(gefaelscht);
    ASSERT_TRUE(gelesen.has_value());
    EXPECT_EQ(*gelesen, koeder);
    EXPECT_FALSE(budget_haelt(*gelesen));
}

// ---------------------------------------------------------------------------
// (5) GEGENKOEDER: der unmanipulierte Wert muss GRUEN bleiben. Eine Wache, die
//     immer rot ist, ist so wertlos wie eine, die nie rot wird.
// ---------------------------------------------------------------------------
TEST(CiSpeicherbudget, GegenkoederBestandswertBleibtGruen) {
    const auto zeilen = super_yml();
    const auto j      = lies_parallel_level(zeilen);
    ASSERT_TRUE(j.has_value());
    EXPECT_TRUE(budget_haelt(*j)) << "Daueralarm: der Bestand selbst faellt durch die eigene Wache.";
}

// ---------------------------------------------------------------------------
// (6) FAIL-CLOSED: eine fehlende Datei ist ROT, nie gruen.
// ---------------------------------------------------------------------------
TEST(CiSpeicherbudget, FehlendeDateiLiefertNulloptNichtLeer) {
    const auto weg = lies_zeilen(std::filesystem::path("/nicht/vorhanden/.gitlab-ci.yml"));
    EXPECT_FALSE(weg.has_value()) << "Eine unlesbare Datei darf nicht wie eine leere aussehen";

    // Und: leere Datei -> kein Wert, nicht etwa 0.
    EXPECT_FALSE(lies_parallel_level({}).has_value());
}

// ---------------------------------------------------------------------------
// (7) DIE KOMMENTAR-FALLE, die die Schwester-Wache am 09.08. am Objekt fand:
//     ein auskommentierter Wert ist kein gesetzter Wert. Ohne diesen Fall haette
//     ein `# CMAKE_BUILD_PARALLEL_LEVEL: "6"` die Wache gruen gehalten, waehrend
//     in der Pipeline der Standardwert 4 aus dem Makefile-Zweig gilt.
// ---------------------------------------------------------------------------
TEST(CiSpeicherbudget, AuskommentierterWertZaehltNicht) {
    const std::vector<std::string> nur_kommentar = {"variables:", "  # CMAKE_BUILD_PARALLEL_LEVEL: \"6\""};
    EXPECT_FALSE(lies_parallel_level(nur_kommentar).has_value()) << "Ein Kommentar ist keine Zuweisung";

    // GEGENPROBE zum Nichtfund: dieselbe Funktion FINDET die wirksame Zeile.
    const std::vector<std::string> wirksam = {"variables:", "  # CMAKE_BUILD_PARALLEL_LEVEL: \"99\"",
                                              "  CMAKE_BUILD_PARALLEL_LEVEL: \"6\"   # Kommentar am Zeilenende"};
    const auto                     gelesen = lies_parallel_level(wirksam);
    ASSERT_TRUE(gelesen.has_value()) << "Gegenprobe fehlgeschlagen -- der Scanner findet gar nichts";
    EXPECT_EQ(*gelesen, 6U) << "Der Zeilenendkommentar darf den Wert nicht verfaelschen";
}

} // namespace
