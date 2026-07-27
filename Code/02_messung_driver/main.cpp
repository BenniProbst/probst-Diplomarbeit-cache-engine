// SPDX-License-Identifier: Apache-2.0
// Diplomarbeit/Code/messung_driver/main.cpp (REV 7.6)
//
// Master-Orchestrator fuer die 3 Pflicht-Messreihen:
//   A — PRT-ART vs Stand-der-Technik
//   B — Cache-Engine Permutationen (SOTA-only)
//   C — Merge alt/neu (PRT-ART-Bausteine in cache-engine-Stack)
//
// Architektur: konsumiert comdare::builder::ExperimentDriver (Library aus
// cache-engine, REV 7.6 Q4) + workload_generator. Schreibt binary
// measurement-records pro Messreihe in separate Unterordner.

// V38.C: STL-Header zuerst (windows.h via plugin_loader.hpp am Ende),
// damit die STL-Header (frueher u.a. <regex>, Phase 7 entfernt) nicht durch Windows-Makros gestoert werden.
#include <array>
#include <atomic> // S1 (§62-B Log-Flush): zeit-gatete progress_sink-Drossel
#include <cerrno>
#include <charconv>
#include <chrono> // S1 (§62-B Log-Flush): steady_clock fuer die zeit-basierte progress-Drossel
#include <cctype>
#include <cstdint>
#include <cstdlib>
#include <exception>
#include <filesystem>
#include <fstream>
#include <functional>
#include <iostream>
#include <limits>
#include <map>
#include <memory>
#include <optional>
#include <sstream>
#include <stdexcept>
#include <string>
#include <string_view>
#include <system_error>
#include <vector>

#include "experiment_driver/experiment_driver.hpp"
#include "xml_config_parser/xml_config_parser.hpp"
#include "xml_config_parser/xml_reader.hpp" // Bruecke-I2: Root-Tag-Sniff des --validate-Profils (common-DOM)
#include "messreihen_workload.hpp"          // #31: E4-XML Workload-Drive (<workload> via ce-DOM, kein Submodul-Bump)
#include "permutations_runtime_check.hpp"   // V36.D
#include "lane_vendor_guard.hpp"            // Scheibe 2a (Ledger 61/62): Lane-Fehlrouting-Wache (Runtime-CPUID)
#include "measurement_writer.hpp"           // V41.B1
#include "stats_aggregator.hpp"             // V41.B3

#include <comdare/workload_generator/workload_generator.hpp>

#ifdef COMDARE_MESSUNG_HAVE_E4_FACADE
#include <profile_facade/profile_run_facade.hpp>
#include <builder/artifact_transport/artifact_cache.hpp> // Storage #51: ArtifactCache::from_env (No-Op-Default)
// G4b-1 (d1): make_fingerprint_key_fn (.fingerprint-Sidecar). LEICHT -- zieht nur fingerprint_sidecar.hpp + stdlib.
// Bewusst NICHT artifact_cache_transport.hpp: das zoege bestandslog_document.hpp und damit den ce-XML-DOM
// (<serialization/xml_config_parser/xml_reader.hpp>) in diese TU, und libs/common liegt nicht im Include-Satz des
// messung_driver-Targets. Den BestandTransport bindet deshalb die Fassaden-TU aus dem hier uebergebenen Cache.
#include <builder/bestandslog/fingerprint_key_source.hpp>
#endif

// INC-G+H (C.2+C.3, 2026-07-14): INERT-Andock der execute_messreihe-Verdrahtung (v32_messreihe_antrieb.hpp).
// DOPPELT gegatet — COMDARE_V32_DRIVER_ENABLE (Build-Option, Default OFF) UND COMDARE_MEASUREMENT_ON (der
// abi_adapter-/Katalog-Treiber fordert MEASUREMENT, sonst traegt der SearchAlgorithmAbiAdapter kein
// IObservableTier). Der messung_driver-Default-Build setzt KEINES von beiden -> der Block wird vom Praeprozessor
// vollstaendig entfernt (main.cpp byte-identisch, golden-320 unveraendert). Der eigentliche Antriebs-/Export-
// Beweis laeuft ueber das FRISCH gebaute Test-Target test_v32_messreihe_antrieb (beide Makros gesetzt) — der
// volle messung_driver-Binary-Link bricht vorbestehend an ext/allocator/A07-snmalloc (unabhaengig, INERT-Andock).
#if defined(COMDARE_V32_DRIVER_ENABLE) && defined(COMDARE_MEASUREMENT_ON)
#include "v32_messreihe_antrieb.hpp"
#endif

// V38.C - bringt windows.h auf Win32 (LEAN_AND_MEAN + NOMINMAX gesetzt).
// MUSS am Ende stehen, sonst clash mit STL via Windows-Makros.
// V38.C.2 Workaround: windows.h definiert auf manchen SDK-Versionen Macros
// die das raw-string-Parsing in main.cpp stoeren. #undef vor Includes setzen.
#include "plugin_loader.hpp" // V38.C
// Defensiv: einige potentielle Macro-Konflikte zwischen Win32-SDK + C++ Source
#ifdef R
#undef R
#endif
#ifdef S
#undef S
#endif

namespace cb = comdare::builder;
namespace wg = comdare::workload_generator;

namespace {

// ─────────────────────────────────────────────────────────────────────────────
// Ladebalken (2026-06-01): ASCII-Fortschrittsbalken ueber ALLE kartesischen
// Produkte (alle geladenen Plugins, CE + prt-art gemeinsam). Bewusst NUR ASCII
// (kein Unicode) wegen NAS/bash + Windows-Konsole. Rendert in-place via '\r' auf
// std::cerr; stdout bleibt fuer Mess-/Record-Ausgaben frei. Lange Permutations-IDs
// werden gekuerzt, damit die Zeile nicht umbricht; Rest-Zeichen werden geloescht.
// ─────────────────────────────────────────────────────────────────────────────
class ProgressBar {
public:
    ProgressBar(std::string_view title, std::size_t total) : title_{title}, total_{total} {
        std::cerr << title_ << " (" << total_ << " Permutationen):\n";
        render("");
    }
    void tick(std::string_view label) {
        if (cur_ < total_) ++cur_;
        render(label);
    }
    // Meldung oberhalb des Balkens ausgeben, ohne ihn zu zerstoeren.
    void note(std::string const& msg) {
        std::cerr << '\r' << std::string(line_len_, ' ') << '\r' << msg << '\n';
        line_len_ = 0;
        render(last_label_);
    }
    void finish() { std::cerr << '\n'; }

private:
    void render(std::string_view label) {
        last_label_         = std::string{label};
        double const frac   = total_ ? static_cast<double>(cur_) / static_cast<double>(total_) : 1.0;
        int          filled = static_cast<int>(frac * kWidth);
        if (filled > kWidth) filled = kWidth;
        std::string bar;
        bar.reserve(static_cast<std::size_t>(kWidth));
        for (int i = 0; i < kWidth; ++i) bar += (i < filled) ? '=' : ' ';
        if (filled > 0 && filled < kWidth) bar[static_cast<std::size_t>(filled) - 1] = '>';
        std::string lbl{label};
        if (lbl.size() > 48) lbl = lbl.substr(0, 45) + "...";
        std::ostringstream os;
        os << '\r' << '[' << bar << "] " << cur_ << '/' << total_ << " (" << static_cast<int>(frac * 100.0) << "%) "
           << lbl;
        std::string out = os.str();
        if (out.size() < line_len_) out += std::string(line_len_ - out.size(), ' ');
        line_len_ = os.str().size();
        std::cerr << out << std::flush;
    }
    static constexpr int kWidth = 40;
    std::string          title_;
    std::size_t          total_;
    std::size_t          cur_      = 0;
    std::size_t          line_len_ = 0;
    std::string          last_label_;
};

enum class MessreiheKind : std::uint8_t {
    A_PrtArtVsSota    = 0,
    B_CacheEnginePerm = 1,
    C_MergeAltNeu     = 2,
};

[[nodiscard]] std::string_view messreihe_name(MessreiheKind k) noexcept {
    switch (k) {
        case MessreiheKind::A_PrtArtVsSota: return "A_PRT_ART_vs_SOTA";
        case MessreiheKind::B_CacheEnginePerm: return "B_CacheEngine_Perms";
        case MessreiheKind::C_MergeAltNeu: return "C_Merge_Alt_Neu";
    }
    return "Unknown";
}

[[nodiscard]] std::filesystem::path subdir_for(MessreiheKind k) { return std::string{messreihe_name(k)}; }

[[nodiscard]] cb::WorkloadOptions default_workload_for(MessreiheKind k) {
    cb::WorkloadOptions w;
    w.config.random_seed      = 42;
    w.config.key_size_bytes   = 16;
    w.config.value_size_bytes = 64;
    w.config.zipfian_theta    = 0.99;

    switch (k) {
        case MessreiheKind::A_PrtArtVsSota:
            w.config.num_keys       = 1000000;
            w.config.num_operations = 5000000;
            w.workload              = wg::YcsbWorkload::C;
            break;
        case MessreiheKind::B_CacheEnginePerm:
            w.config.num_keys       = 500000;
            w.config.num_operations = 2500000;
            w.workload              = wg::YcsbWorkload::C;
            break;
        case MessreiheKind::C_MergeAltNeu:
            w.config.num_keys       = 1000000;
            w.config.num_operations = 5000000;
            w.workload              = wg::YcsbWorkload::A;
            break;
    }
    return w;
}

void print_usage() {
    std::cerr
        << "Usage: comdare-messung-driver <config_dir> <output_dir> [--comdare-root=DIR] [--messreihen-xml=FILE]\n\n"
        << "Erwartete Files in <config_dir> (Legacy-4-Datei-Schema; heutige Konfigs:\n"
        << "config_a/b/c_*.xml + messreihen.xml — fehlende Dateien werden diagnostiziert):\n"
        << "  cache_engine_permutations.xml\n"
        << "  search_algorithm_permutations.xml\n"
        << "  allocator_permutations.xml\n"
        << "  test_data_sets.xml  [DEPRECATED-Slot, GO-5 Fork 2/R2 2026-07-12: existiert nirgends;\n"
        << "                       Wahrheitsquelle sind die Code/test_data_xml/*.test_data.xml-Akten,\n"
        << "                       die der E4-Weg via <datasets> im comdare_thesis_profile referenziert]\n"
        << "  (optional, V9.6) messreihen.xml — defined/full Mode pro Reihe\n\n"
        << "Output (separat pro Messreihe A/B/C):\n"
        << "  <output_dir>/A_PRT_ART_vs_SOTA/measurements.{csv,json}\n"
        << "  <output_dir>/B_CacheEngine_Perms/measurements.{csv,json}\n"
        << "  <output_dir>/C_Merge_Alt_Neu/measurements.{csv,json}\n";
}

// REV 7.6 V9.6 — minimaler XML-Reader fuer messreihe-Tags (defined/full Mode)
struct MessreihenSpec {
    std::string                     id;
    std::string                     mode; // "defined" oder "full"
    std::vector<std::string>        sota_profiles;
    std::optional<wg::YcsbWorkload> workload; // #31: aus <workload> (E4-XML); nullopt = Fallback-Default
};

// Phase 7 (2026-07-10, Parser-Konsolidierung): der lokale Regex-Reader ist entfernt —
// die Bibliothek (XmlConfigParser::load_messreihen, KF-1-DOM) ist die EINE Wahrheitsquelle.
// MessreihenSpec bleibt die treiberlokale Sicht (string-mode fuer die bestehende Verzweigung).
[[nodiscard]] std::vector<MessreihenSpec> load_messreihen(std::filesystem::path const& xml_path) {
    std::vector<MessreihenSpec>            result;
    comdare::builder::xml::XmlConfigParser parser;
    // #31 (submodul-CI-konform): das Zusatz-Tag <workload> ueber den ce-DOM-Reader ergaenzen — der typisierte
    // XmlConfigParser::load_messreihen bleibt die EINE Quelle fuer id/mode/sota (Phase-7-Konsolidierung); er
    // exponiert <workload> nicht, und ein neues ce-Parser-Feld wuerde einen nicht-fetchbaren Submodul-Bump brauchen.
    auto const wl_map = comdare::messung::parse_messreihe_workloads(xml_path);
    for (auto const& r : parser.load_messreihen(xml_path)) {
        MessreihenSpec spec;
        spec.id            = r.id;
        spec.mode          = std::string{comdare::builder::xml::mode_to_string(r.mode)};
        spec.sota_profiles = r.sota_profile_refs;
        if (auto it = wl_map.find(r.id); it != wl_map.end()) spec.workload = it->second;
        result.push_back(std::move(spec));
    }
    return result;
}

[[nodiscard]] std::string trim_copy(std::string_view s) {
    while (!s.empty() && std::isspace(static_cast<unsigned char>(s.front())) != 0) s.remove_prefix(1);
    while (!s.empty() && std::isspace(static_cast<unsigned char>(s.back())) != 0) s.remove_suffix(1);
    return std::string{s};
}

[[nodiscard]] std::string env_trimmed(char const* name) {
    if (char const* e = std::getenv(name); e != nullptr) return trim_copy(e);
    return {};
}

[[nodiscard]] std::string compile_time_platform_tag() {
#if defined(__linux__) && (defined(__x86_64__) || defined(_M_X64))
    return "linux-x86_64";
#elif defined(__linux__) && (defined(__aarch64__) || defined(_M_ARM64))
    return "linux-arm64";
#elif defined(_WIN32) && (defined(_M_X64) || defined(__x86_64__))
    return "win-x86_64";
#elif defined(_WIN32) && defined(_M_ARM64)
    return "win-arm64";
#elif defined(__APPLE__) && defined(__aarch64__)
    return "macos-arm64";
#elif defined(__APPLE__) && defined(__x86_64__)
    return "macos-x86_64";
#elif defined(__linux__) && defined(__riscv) && (__riscv_xlen == 64)
    return "linux-riscv64";
#else
    return "unknown-platform";
#endif
}

[[nodiscard]] double parse_min_free_gb_from_env() {
    std::string const s = env_trimmed("COMDARE_MIN_FREE_GB");
    if (s.empty()) return 0.0;

    errno      = 0;
    char*  end = nullptr;
    double v   = std::strtod(s.c_str(), &end);
    if (end == s.c_str() || *end != '\0' || errno == ERANGE || v < 0.0) {
        // Fail-loud statt 0.0: ein Tippfehler ("4,5"/"4gb") wuerde sonst die RAM-Admission
        // still deaktivieren (B3-Klasse) -- der Abbruch landet im try/catch des E4-Blocks.
        throw std::runtime_error("COMDARE_MIN_FREE_GB ungueltig: '" + s + "'");
    }
    return v;
}

[[nodiscard]] std::optional<std::size_t> parse_size_env_strict(char const* name) {
    std::string const s = env_trimmed(name);
    if (s.empty()) return std::nullopt;

    std::uint64_t value  = 0;
    auto const [ptr, ec] = std::from_chars(s.data(), s.data() + s.size(), value, 10);
    if (ec != std::errc{} || ptr != s.data() + s.size() ||
        value > static_cast<std::uint64_t>((std::numeric_limits<std::size_t>::max)())) {
        throw std::runtime_error(std::string{name} + " ungueltig: '" + s + "'");
    }
    return static_cast<std::size_t>(value);
}

// ---------------------------------------------------------------------------------------------------------------
// G4b-2 (d2) / #46b I1b: das GATE des planer_block fuer die beiden CEB-Compile-Strecken (--dump-ci/--dump-cmake).
//
// Der planer_block meldet dem Lager, dass DIESER Planer gleich eine CEB-Compile-Strecke anstoesst, damit ein
// zweiter Planer auf einer anderen Maschine dieselbe Strecke nicht doppelt reserviert. Ausgefuehrt wird der
// Lebenszyklus in der Fassaden-TU (profile_run_facade.cpp) -- hier entsteht nur der Kontext, denn der gelockte
// Schreibweg zieht ueber bestandslog_document.hpp den ce-XML-DOM, und libs/common liegt nicht im Include-Satz
// dieses Targets. Derselbe Schnitt wie bei bestand_cache in (d1).
//
// GATE-FORMEL identisch zu (d1): COMDARE_BESTANDSLOG=="true" UND minio_enabled() UND die drei Pflicht-Variablen.
// minio_enabled() und NICHT !inert(), weil die vier Objekt-Verben ausnahmslos auf Ebene B gaten
// (artifact_cache.hpp:487/507/535) -- eine Nur-measure-drop-Konfiguration wuerde sonst einen toten Transport binden.
// Gate an + Pflicht-Var leer => harter Abbruch (der Aufrufer liefert exit 6). Gate an + kein minio => EINE
// WARNUNG, kein Binden. Gate aus => vollstaendig stumm (Byte-Neutralitaet des Vor-Zustands).
//
// BUDGET (2.4-(5)): der Emissions-Cache ist knapp budgetiert -- with_object_budget(1, 10), also EIN Versuch mit
// 10 s Deckel statt der 12 Versuche des Defaults. Ein unerreichbarer Store darf eine CI-Emission nicht minutenlang
// aufhalten; die Buchhaltung ist nachrangig gegenueber der Emission.
//
// id (E2): owner_uuid + "/planer" -- EINE Sperre je Lauf, nicht je Sequenz. Die Eindeutigkeit tragt der
// lauf-eindeutige owner, nicht ein Zaehler; ein neuer Lauf hat einen neuen owner und damit eine neue id, weshalb
// die Merge-Monotonie kein Re-Open braucht. owner_uuid bleibt ein EIGENES Feld neben der id.
struct PlanerBlockGate {
    comdare::cache_engine::builder::profile_facade::PlanerBlockContext ctx;             // leer = inert
    bool                                                               abbruch = false; // true => exit 6
};

[[nodiscard]] PlanerBlockGate make_planer_block_gate() {
    namespace atp = comdare::cache_engine::builder::artifact_transport;
    namespace pf  = comdare::cache_engine::builder::profile_facade;

    PlanerBlockGate g;
    if (env_trimmed("COMDARE_BESTANDSLOG") != "true") return g; // stumm inert

    // Der Emissions-Cache ist eine EIGENE, benannte Instanz (Praezedenz main.cpp:784) -- die E4-Block-Instanz
    // entsteht erst viel spaeter, und die Emissionszweige returnen lange davor.
    auto const emit_ac = std::make_shared<atp::ArtifactCache const>(atp::ArtifactCache::from_env().with_object_budget(
        /*tries=*/1, /*timeout_s=*/10));
    if (!emit_ac->minio_enabled()) {
        std::cerr << "[bestandslog] WARNUNG fehlerklasse=lager_ebene_fehlt: COMDARE_BESTANDSLOG=true, aber Ebene B "
                  << "(minio) ist nicht konfiguriert (measure-drop=" << (emit_ac->drop_enabled() ? "1" : "0")
                  << ") -- planer_block bleibt AUS, Emission unveraendert.\n";
        return g;
    }

    std::string const doc_key      = env_trimmed("COMDARE_BESTANDSLOG_DOC_KEY");
    std::string const owner_uuid   = env_trimmed("COMDARE_BESTANDSLOG_OWNER_UUID");
    std::string const maschine     = env_trimmed("COMDARE_BESTANDSLOG_MASCHINE");
    char const*       fehlende_var = nullptr;
    if (doc_key.empty())
        fehlende_var = "COMDARE_BESTANDSLOG_DOC_KEY";
    else if (owner_uuid.empty())
        fehlende_var = "COMDARE_BESTANDSLOG_OWNER_UUID";
    else if (maschine.empty())
        fehlende_var = "COMDARE_BESTANDSLOG_MASCHINE";
    if (fehlende_var != nullptr) {
        std::cerr << "[bestandslog] FEHLER fehlerklasse=konfiguration_unvollstaendig: "
                  << "COMDARE_BESTANDSLOG=true, aber " << fehlende_var << " ist leer -- Abbruch.\n";
        g.abbruch = true;
        return g;
    }

    g.ctx.cache      = emit_ac;
    g.ctx.doc_key    = doc_key;
    g.ctx.id         = owner_uuid + "/planer"; // E2: EINE Sperre je Lauf
    g.ctx.owner_uuid = owner_uuid;
    g.ctx.maschine   = maschine;
    // Thread-Budget nur, wenn es ueberhaupt erklaert ist (0 = nicht gemeldet, keine erfundene Zahl).
    if (auto const bp = parse_size_env_strict("COMDARE_BUILD_PARALLEL")) g.ctx.threads = static_cast<unsigned>(*bp);
    std::cerr << "[bestandslog] planer_block aktiv: doc_key=" << g.ctx.doc_key << " id=" << g.ctx.id
              << " maschine=" << g.ctx.maschine << "\n";
    return g;
}

// G4b-2/2.4-(3): der Ausnahme-Mantel fuer ALLE VIER Emissionszweige. Sie lagen bisher in keinem try (die einzigen
// im File sind der --validate- und der E4-Block) -- eine Ausnahme aus main haette std::terminate OHNE Unwinding
// ausgeloest, der PromiseGuard des planer_block waere nie gefeuert und die Reservierung 30 Minuten haengen
// geblieben. Rueckgabe 1, NICHT 6: exit 6 bleibt exklusiv fuer fehlerklasse=konfiguration_unvollstaendig.
//
// A-B1 (cppcheck 2.21 throwInEntryPoint, CI Job 333638): die vier Zweige leben als BENANNTE freie Handler
// AUSSERHALB von main -- cppcheck wertet Lambda-Koerper LEXIKALISCH im Kontext der umgebenden Funktion (auch
// in main; der fruehere In-main-Lambda-Umbau 8064f3ff blieb deshalb wirkungslos) und versteht ein try, das erst
// im Aufgerufenen um den Thunk liegt, NICHT (das fruehere guarded_emission-Template fiel genau daran). Deshalb
// steht der try/catch-Mantel ausgeschrieben IN jedem Handler (etabliertes Muster --chunk-organ-fingerprint);
// nur die Fehler-Meldung ist zentral (emission_abgebrochen). noexcept ist damit wahr UND lexikalisch belegbar.
// main ruft die Handler direkt, ohne Lambda, und ist lexikalisch frei von werfendem Code. Zugleich sind das
// die kanonischen Handler der V-6-Subcommand-Linie (Bauplan TEIL V, V-6vi).
[[nodiscard]] int emission_abgebrochen(char const* was, char const* detail) noexcept {
    std::cerr << "[bestandslog] FEHLER fehlerklasse=emission_abgebrochen: " << was << " -- " << detail << "\n";
    return 1;
}

[[nodiscard]] int run_dump_ci_guarded(std::string const& prof) noexcept {
    namespace pf = comdare::cache_engine::builder::profile_facade;
    // G4b-2/E1: eine der beiden CEB-Compile-Strecken -> planer_block haengt hier. Gate-Erzeugung IM Mantel:
    // make_planer_block_gate() macht Bestandslog-IO und kann werfen -- nur im Mantel ist das Unwinding
    // (PromiseGuard) garantiert; exit 6 bleibt dem Gate-Abbruch vorbehalten.
    try {
        auto const gate = make_planer_block_gate();
        if (gate.abbruch) return 6;
        return pf::dump_experiment_ci_facade(prof, std::cout, gate.ctx);
    } catch (std::exception const& e) { return emission_abgebrochen("--dump-ci", e.what()); } catch (...) {
        return emission_abgebrochen("--dump-ci", "unbekannte Ausnahme");
    }
}

[[nodiscard]] int run_dump_cmake_guarded(std::string const& prof) noexcept {
    namespace pf = comdare::cache_engine::builder::profile_facade;
    // G4b-2/E1: die zweite CEB-Compile-Strecke -- derselbe planer_block wie bei --dump-ci.
    try {
        auto const gate = make_planer_block_gate();
        if (gate.abbruch) return 6;
        return pf::dump_experiment_cmake_facade(prof, std::cout, gate.ctx);
    } catch (std::exception const& e) { return emission_abgebrochen("--dump-cmake", e.what()); } catch (...) {
        return emission_abgebrochen("--dump-cmake", "unbekannte Ausnahme");
    }
}

[[nodiscard]] int run_emit_tier_ci_guarded(std::string const& prof, std::string const& combo_sel) noexcept {
    namespace pf = comdare::cache_engine::builder::profile_facade;
    // G4b-2/E1: KEIN planer_block -- --emit-tier-* ist die CEB-Rolle (Tier-Jobs), nicht die CEB-Compile-
    // Strecke; die Tier-Ebene hat ihre eigene Reservierung im Iterator. Der Ausnahme-Mantel gilt trotzdem
    // (2.4-(3) verlangt ihn fuer ALLE vier Zweige).
    try {
        return pf::emit_tier_ci_facade(prof, std::cout, combo_sel);
    } catch (std::exception const& e) { return emission_abgebrochen("--emit-tier-ci", e.what()); } catch (...) {
        return emission_abgebrochen("--emit-tier-ci", "unbekannte Ausnahme");
    }
}

[[nodiscard]] int run_emit_tier_cmake_guarded(std::string const& prof, std::string const& combo_sel) noexcept {
    namespace pf = comdare::cache_engine::builder::profile_facade;
    // G4b-2/E1: wie --emit-tier-ci -- kein planer_block, aber der Ausnahme-Mantel (2.4-(3)).
    try {
        return pf::emit_tier_cmake_facade(prof, std::cout, combo_sel);
    } catch (std::exception const& e) { return emission_abgebrochen("--emit-tier-cmake", e.what()); } catch (...) {
        return emission_abgebrochen("--emit-tier-cmake", "unbekannte Ausnahme");
    }
}
// ---------------------------------------------------------------------------------------------------------------

// INC-G6 (Ledger 33/34, 2026-07-19): das golden-N Chunk-Fenster. COMDARE_GOLDEN_N_RANGE="start:count" ->
// {start, count}. Leer/ungesetzt = nullopt (kein Fenster, Ist-Verhalten). Fail-loud bei Fehlform (ein Tippfehler
// wuerde sonst still den ganzen 2^17-Bau statt eines Chunks starten) -- der Abbruch landet im try/catch des
// E4-Blocks. count==0 ist syntaktisch gueltig (deaktiviert das Fenster). Muster wie parse_size_env_strict.
struct GoldenRange {
    std::size_t start = 0;
    std::size_t count = 0;
};
[[nodiscard]] std::optional<GoldenRange> parse_golden_range_env() {
    std::string const s = env_trimmed("COMDARE_GOLDEN_N_RANGE");
    if (s.empty()) return std::nullopt;
    std::size_t const colon = s.find(':');
    if (colon == std::string::npos)
        throw std::runtime_error("COMDARE_GOLDEN_N_RANGE erwartet 'start:count': '" + s + "'");
    auto const parse_u = [&s](std::string_view part) -> std::size_t {
        std::uint64_t v      = 0;
        auto const [ptr, ec] = std::from_chars(part.data(), part.data() + part.size(), v, 10);
        if (part.empty() || ec != std::errc{} || ptr != part.data() + part.size() ||
            v > static_cast<std::uint64_t>((std::numeric_limits<std::size_t>::max)()))
            throw std::runtime_error("COMDARE_GOLDEN_N_RANGE ungueltig: '" + s + "'");
        return static_cast<std::size_t>(v);
    };
    std::string_view const sv{s};
    return GoldenRange{parse_u(sv.substr(0, colon)), parse_u(sv.substr(colon + 1))};
}

} // namespace

int main(int argc, char* argv[]) {
    // --validate [<profil>]: rein-lesende Pre-Flight-Pruefung des Thesis-Profils gegen die realen
    // EnabledStrategies (P5, migriert von run_lazy_150) — baut KEINE DLL, misst NICHT. Braucht KEINE
    // (run_lazy_150 geloescht 2026-07-11)
    // <config>/<output>-Argumente; ohne Pfad gilt COMDARE_THESIS_PROFILE bzw. das gebackene Default-Profil.
    for (int i = 1; i < argc; ++i) {
        std::string const flag{argv[i]};
        if (flag == "--validate" || flag == "--check") {
            std::string prof = (i + 1 < argc && argv[i + 1][0] != '-') ? std::string{argv[i + 1]}
                                                                       : env_trimmed("COMDARE_THESIS_PROFILE");
            if (prof.empty()) prof = COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE;

            // Bruecke-I2 (2026-07-16): der --validate-Zweig deckt BEIDE offiziellen Profil-Wurzeln ab. Ein
            // Root-Tag-Sniff (rein-lesend ueber den common-DOM) entscheidet: <comdare_thesis_profile> -> das
            // Achsen-/Werte-Gate (validate_profile_facade, wie bisher); <comdare_experiment> -> das 3-Phasen-
            // Gate (validate_experiment_profile_facade) mit den per CMake einkompilierten STATISCHEN ce+prt-
            // Registry-Pfaden (2-Registry-Kanon; der Host reicht sie herein, die ce-Fassade haelt keinen prt-
            // art-Pfad hart vor — Baseline-Layering). Beide Parser liefern nullopt bei Fremd-Tag, daher ist der
            // reine Root-Tag-Read gefahrlos; eine unbekannte/unlesbare Wurzel -> rc 5 (kein Bau).
            std::string root_tag;
            if (std::ifstream in{prof, std::ios::binary}; in) {
                std::ostringstream ss;
                ss << in.rdbuf();
                if (auto const root = comdare::common::xml::parse_document(ss.str())) root_tag = root->tag;
            }
            namespace pf = comdare::cache_engine::builder::profile_facade;
            if (root_tag == "comdare_thesis_profile") { return pf::validate_profile_facade(prof, std::cout); }
            if (root_tag == "comdare_experiment") {
#if defined(COMDARE_CE_AXIS_REGISTRY_PATH) && defined(COMDARE_PRT_AXIS_REGISTRY_PATH)
                return pf::validate_experiment_profile_facade(prof, COMDARE_CE_AXIS_REGISTRY_PATH,
                                                              COMDARE_PRT_AXIS_REGISTRY_PATH, std::cout);
#else
                std::cerr << "[validate] '" << prof
                          << "': comdare_experiment erkannt, aber die statischen Registry-Pfade wurden nicht "
                             "einkompiliert (COMDARE_CE/PRT_AXIS_REGISTRY_PATH) -- ce-Klon/CMake nicht synchron?\n";
                return 5;
#endif
            }
            std::cerr << "[validate] '" << prof << "': unbekannte/unlesbare Wurzel"
                      << (root_tag.empty() ? "" : " '" + root_tag + "'")
                      << " -- weder <comdare_thesis_profile> noch <comdare_experiment>. KEIN Bau ausgefuehrt.\n";
            return 5;
        }
        // --dump-plan [<profil>] (PAKET W5-B, 2026-07-19): rein-lesende Emission des deterministischen
        // ExperimentPlanDirector-Walks (GoF Director + PlanTextBuilder) -- baut KEINE DLL, misst NICHT. Der
        // Root-Tag-Sniff (comdare_thesis_profile vs comdare_experiment) sitzt IN der Fassade (der katalog-
        // schwere Planer-Header gehoert dorthin, nicht in diesen Treiber). Wie --validate: ohne Pfad gilt
        // COMDARE_THESIS_PROFILE bzw. das gebackene Default-Profil. Text -> stdout, exit 0.
        if (flag == "--dump-plan") {
            std::string prof = (i + 1 < argc && argv[i + 1][0] != '-') ? std::string{argv[i + 1]}
                                                                       : env_trimmed("COMDARE_THESIS_PROFILE");
            if (prof.empty()) prof = COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE;
            namespace pf = comdare::cache_engine::builder::profile_facade;
            return pf::dump_experiment_plan_facade(prof, std::cout);
        }
        // --chunk-organ-fingerprint [<profil>] (Cache-Resthygiene-2, 2026-07-21): druckt das Chunk-Organ-Fingerprint-
        // PRE-IMAGE (perm.dll.algos-Inhalte der Range-Binaries, stem-sortiert konkateniert) nach stdout -- rein aus dem
        // Katalog, KEIN DLL-Bau. Die CI pipet es durch `sha256sum` -> COMDARE_GN_ALGO_SIG (== S1-F1-Marker-algo_sig ->
        // Marker-Wache scharf). Range aus COMDARE_GOLDEN_N_RANGE="start:count" (leer/ungesetzt => ganze View).
        if (flag == "--chunk-organ-fingerprint") {
            std::string prof = (i + 1 < argc && argv[i + 1][0] != '-') ? std::string{argv[i + 1]}
                                                                       : env_trimmed("COMDARE_THESIS_PROFILE");
            if (prof.empty()) prof = COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE;
            std::size_t rstart = 0, rcount = 0;
            try {
                if (auto const r = parse_golden_range_env()) {
                    rstart = r->start;
                    rcount = r->count;
                }
                namespace pf = comdare::cache_engine::builder::profile_facade;
                return pf::chunk_organ_fingerprint_facade(prof, rstart, rcount, std::cout);
            } catch (std::exception const& e) {
                // Fehlerklassen-Doktrin: kaputtes COMDARE_GOLDEN_N_RANGE/Profil ist ein KONFIG-Fehler --
                // klar melden statt unhandled throw (cppcheck throwInEntryPoint); nie stillschweigend Voll-View.
                std::cerr << "[Konfig-Fehler: chunk-organ-fingerprint] " << e.what() << "\n";
                return 2;
            }
        }
        // R8 (Nacht-Audit 2026-07-22): --print-cache-key -- druckt den VOLLEN ce-Objekt-Cache-Key-Praefix fuer die per
        // Env (COMDARE_GN_OPT/COMDARE_GN_SIMD/COMDARE_CXX/COMDARE_BUILD_TYPE/COMDARE_MEASUREMENT_COMBO) gepinnte
        // GN-Zelle nach stdout (EINE Zeile). Die CI (.golden_n_build) konsumiert ihn LITERAL als PULL-Quelle/
        // MARK_PREFIX -> kein bash-Key-Drift (+bt/+ceb/+mtool/+mrg Single-Source aus dem Treiber). base = "m3v2"
        // (dieselbe Mess-Lauf-build_version wie die run-Pfade unten). Baut KEINE DLL, liest keinen Katalog.
        if (flag == "--print-cache-key") {
            namespace pf = comdare::cache_engine::builder::profile_facade;
            return pf::print_cache_key_facade("m3v2", std::cout);
        }
        // K7b-4 (§62-B, G1/B6-Auflage 2026-07-22): --version -- druckt den Je-Binary-Selbst-Stempel DIESES
        // Treiber-Binary (Planer- + CEB-Rolle in EINEM Binary) nach stdout: vier gelabelte non-empty Zeilen
        // (planner-Selbst-Stempel / ceb-contract / build-type / build-version = system_axes_version_suffix). Ordnet
        // das Binary per Versionierung dem gebauten Cache-Artefakt zu (ccache-Beschleunigung ist durch K7b gated).
        // Rein-lesend: baut KEINE DLL, liest keinen Katalog.
        if (flag == "--version") {
            namespace pf = comdare::cache_engine::builder::profile_facade;
            return pf::print_version_facade(std::cout);
        }
        // --dump-ci [<profil>] (PAKET W7-A, 2026-07-19, §40.b): rein-lesende Emission der deterministischen
        // GitLab-Child-Pipeline-YAML (CiYamlBuilder am SELBEN Director-Walk wie --dump-plan). Die dynamische,
        // Planer-gesteuerte Folge-CI (Pilot->Serie). Wie --dump-plan: baut KEINE DLL, misst NICHT; Root-Tag-Sniff
        // in der Fassade; ohne Pfad gilt COMDARE_THESIS_PROFILE bzw. das gebackene Default-Profil. YAML -> stdout.
        if (flag == "--dump-ci") {
            std::string prof = (i + 1 < argc && argv[i + 1][0] != '-') ? std::string{argv[i + 1]}
                                                                       : env_trimmed("COMDARE_THESIS_PROFILE");
            if (prof.empty()) prof = COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE;
            // A-B1: Mantel + planer_block-Gate leben im benannten Handler ausserhalb von main (throwInEntryPoint).
            int const rc = run_dump_ci_guarded(prof);
            return rc; // 2.4-(2): LOKALE Variable, kein return-im-Ausdruck
        }
        // --dump-cmake [<profil>] (PAKET W7-B, 2026-07-19, §40.c): rein-lesende Emission des scharfen
        // experiment_plan.cmake (CMakeGraphBuilder am SELBEN Director-Walk). Der Bare-Metal-Bauplan: echte
        // provision-only-build:-Kommandos je Zelle + GN-11-gegatetes measure:-Skelett. Wie --dump-plan: baut
        // KEINE DLL, misst NICHT. Text -> stdout (Umleitung nach out.cmake -> cmake-Aufruf = Bare-Metal-Lauf).
        if (flag == "--dump-cmake") {
            std::string prof = (i + 1 < argc && argv[i + 1][0] != '-') ? std::string{argv[i + 1]}
                                                                       : env_trimmed("COMDARE_THESIS_PROFILE");
            if (prof.empty()) prof = COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE;
            // A-B1: Mantel + planer_block-Gate im benannten Handler ausserhalb von main (siehe --dump-ci).
            int const rc = run_dump_cmake_guarded(prof);
            return rc; // 2.4-(2): LOKALE Variable
        }
        // --emit-tier-ci [<profil>] (PAKET W10-A, 2026-07-19, §42/§42.b): die CEB-ROLLEN-Emission (Stufe 2). Wie
        // --dump-ci, aber emittiert NUR die Stufe-2-Sicht des freigegebenen CEB-Raums (System-Perms + Tier-Chunk-
        // Jobs "tier:build:[d,e,f][g,h,i]:chunk<k>" = System x Organ, Mess-Achse [a,b,c] baut nur die CEB, siehe
        // §56/§57 + GN-11/320er-gegatete Mess-Jobs). CEB-Hoheit (§40.b): der
        // Planer steuert die CEB-Jobs (--dump-ci), die CEB steuert die Tier-Jobs (--emit-tier-ci). Heute EINE
        // Binary in zwei Rollen. Baut KEINE DLL, misst NICHT; Root-Tag-Sniff in der Fassade. YAML -> stdout.
        if (flag == "--emit-tier-ci") {
            std::string prof = (i + 1 < argc && argv[i + 1][0] != '-') ? std::string{argv[i + 1]}
                                                                       : env_trimmed("COMDARE_THESIS_PROFILE");
            if (prof.empty()) prof = COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE;
            // A5 (§56-T2-FANOUT D4): optionaler --measurement-combo=<cmake_slug>-Selektor. Er beginnt mit '-' und
            // wird daher NIE als Profil-Positional verschluckt (der argv[i+1][0]!='-'-Test oben ueberspringt ihn).
            // Ohne Flag -> leer -> emit_tier_ci_facade laeuft byte-identisch zu vor A5 (Identitaet, 1 Voll-Konfig).
            std::string combo_sel;
            for (int j = 1; j < argc; ++j) {
                if (std::string const a{argv[j]}; a.rfind("--measurement-combo=", 0) == 0) combo_sel = a.substr(20);
            }
            // A-B1: Mantel im benannten Handler ausserhalb von main (Rollen-Kommentar dort).
            int const rc = run_emit_tier_ci_guarded(prof, combo_sel);
            return rc; // 2.4-(2): LOKALE Variable
        }
        // --emit-tier-cmake [<profil>] (PAKET W10-A, 2026-07-19, §42/§42.b): der Bare-Metal-Gegenpart zu
        // --emit-tier-ci (Stufe 2, CEB-Rolle). Emittiert das tier_plan.cmake (reale provision-only-Tier-Chunk-
        // Bau-Targets + GN-11/320er-gegatetes measure:-Skelett) -- der Ort des Tier-Baus in der dreistufigen
        // Bare-Metal-Kette (--dump-cmake -> CEB -> --emit-tier-cmake -> Tier-Bau). Baut KEINE DLL, misst NICHT.
        if (flag == "--emit-tier-cmake") {
            std::string prof = (i + 1 < argc && argv[i + 1][0] != '-') ? std::string{argv[i + 1]}
                                                                       : env_trimmed("COMDARE_THESIS_PROFILE");
            if (prof.empty()) prof = COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE;
            // A8(a)-Symmetrie (§56-T2-FANOUT D4): optionaler --measurement-combo=<cmake_slug>-Selektor, EXAKT wie im
            // --emit-tier-ci-Zweig gespiegelt (er beginnt mit '-' und wird daher NIE als Profil-Positional
            // verschluckt). Ohne Flag -> leer -> emit_tier_cmake_facade laeuft byte-identisch (Identitaet, 1 Voll-Konfig).
            std::string combo_sel;
            for (int j = 1; j < argc; ++j) {
                if (std::string const a{argv[j]}; a.rfind("--measurement-combo=", 0) == 0) combo_sel = a.substr(20);
            }
            // A-B1: Mantel im benannten Handler ausserhalb von main (Rollen-Kommentar dort).
            int const rc = run_emit_tier_cmake_guarded(prof, combo_sel);
            return rc; // 2.4-(2): LOKALE Variable
        }
    }

    // Scheibe 2a (Ledger 61/62): Lane-Fehlrouting-Wache. Die Pre-Flight-Zweige oben (--validate/--dump/--emit)
    // sind bereits raus (jeder return-t); AB HIER misst der Treiber (v32/legacy/v41/E4/Thesis). Traegt
    // COMDARE_PLATFORM die emittierte Lane-Form "amd@<host>"/"intel@<host>" (ce emit_measure_job), MUSS die reale
    // CPU (Laufzeit-CPUID) dazu passen -- sonst HARTER Abbruch VOR der Messung, damit kein Lauf stundenlang Daten
    // unter falscher Hardware-Provenienz schreibt (CI wird rot statt still falsch zu messen). Kein Lane-Praefix
    // oder Vendor unbekannt (non-x86/bare-metal) => Wache inaktiv (Notausgang). Die platform-CSV-Spalte bleibt
    // unveraendert lane@host; der detektierte Vendor geht NUR zusaetzlich ins Log. Bruecke #49/#46 (feine
    // Identitaet + Cache-Log loesen die Lane-Form spaeter ab; Lanes = Interim, Ledger 62).
    {
        namespace md                     = comdare::diplomarbeit::messung_driver;
        std::string const guard_platform = env_trimmed("COMDARE_PLATFORM");
        std::string const cpu_vendor     = md::detect_cpu_vendor();
        switch (md::check_lane_vendor(guard_platform, cpu_vendor)) {
            case md::LaneVendorCheck::kMismatch:
                std::cerr << "[Betriebs-Fehler: Lane-Fehlrouting] COMDARE_PLATFORM='" << guard_platform
                          << "' verlangt CPU-Vendor '" << md::lane_expected_vendor(guard_platform)
                          << "', die reale CPU meldet '" << cpu_vendor
                          << "' (Laufzeit-CPUID). Abbruch VOR der Messung -- keine Daten unter falscher "
                             "Hardware-Provenienz. (Ledger 61/62 Lane-Wache; feine Identitaet folgt #49/#46.)\n";
                return 7;
            case md::LaneVendorCheck::kMatch:
                std::cout << "[Lane-Wache] COMDARE_PLATFORM='" << guard_platform << "' passt zu CPU-Vendor '"
                          << cpu_vendor << "' (Laufzeit-CPUID).\n";
                break;
            case md::LaneVendorCheck::kSkipped:
                if (!cpu_vendor.empty() && cpu_vendor != "unknown")
                    std::cout << "[Lane-Wache] inaktiv (kein amd@/intel@-Lane-Praefix); CPU-Vendor='" << cpu_vendor
                              << "' (nur informativ).\n";
                break;
        }
    }

    // INC-G+H (C.2+C.3): der OFFIZIELLE XML-getriebene execute_messreihe-Weg NUR bei explizitem Opt-in (Muster
    // COMDARE_RUN_E4_XML). COMDARE_RUN_V32_EXPERIMENT = Pfad der comdare_experiment-XML. PL-4 (L6, 2026-07-19):
    // die Mode-Quelle ist die XML SELBST (<metadata><mode> = defined|full|full_sampled, single-XML-Doktrin);
    // COMDARE_V32_EXPERIMENT_MODE ist NUR noch expliziter Debug-Override und wird beim abweichenden Greifen in
    // der Antriebs-Schicht LAUT geloggt (vorher ersetzte der env die XML still = L6-Bruch). Doppelt gegatet (s.
    // Include oben) -> im messung_driver-Default-Build praeprozessor-entfernt (byte-identisch, kein neuer Mess-Pfad).
#if defined(COMDARE_V32_DRIVER_ENABLE) && defined(COMDARE_MEASUREMENT_ON)
    if (std::string const xp = env_trimmed("COMDARE_RUN_V32_EXPERIMENT"); !xp.empty()) {
        // Leerer Override -> <metadata><mode> der XML gilt (leer/unbekannt faellt im Antrieb sicher auf Defined).
        return comdare::diplomarbeit::messung_driver::v32::antrieb::execute_messreihe(
            xp, env_trimmed("COMDARE_V32_EXPERIMENT_MODE"));
    }
#endif

    if (argc < 3) {
        print_usage();
        return 1;
    }

    // V-2/2a (Bauplan TEIL V, M3-Ersatz-Gate, 2026-07-27): Start-Gate am PLANER-PLAN statt am
    // Configure-Zeit-Manifest. Bis hierher stand hier assert_permutations_available_or_die() aus
    // permutations_runtime_check.hpp -- das zaehlte die Perm-DLL-Menge des V36.B-Alt-Kanals aus
    // generated/permutations_manifest.txt und sagte damit NICHTS darueber, ob DIESER Lauf etwas zu tun
    // hat. Das Gate fragt jetzt denselben deterministischen Director-Walk, den der Lauf ohnehin nimmt.
    // Der Exit-Code 2 bleibt (etablierte Semantik "kein Experiment moeglich"); die Fassade meldet Profil,
    // Perm- und Schritt-Zahl. Profil-Aufloesung identisch zu --validate/--dump-plan: argv-Profil, sonst
    // COMDARE_THESIS_PROFILE, sonst das gebackene Default-Profil.
    {
        std::string gate_profile = env_trimmed("COMDARE_THESIS_PROFILE");
        if (gate_profile.empty()) gate_profile = COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE;
        namespace pf = comdare::cache_engine::builder::profile_facade;
        if (int const rc = pf::assert_plan_nonempty_facade(gate_profile, std::cout); rc != 0) { return rc; }
    }

    // V37.C (2026-05-23): Manifest-Iteration — pro Permutation ein Eintrag.
    // GO-V4 G2 (2026-07-13): hinter die bereits bestehende Legacy-Huerde (COMDARE_LEGACY_MESSREIHEN==1,
    // identischer env-Check wie :595) gezogen. Dieser Kopf-Diagnose-Block war ein zweiter, ungegateter
    // Mess-/Diagnose-Pfad NEBEN dem offiziellen E4-XML-Weg und verletzte "EIN offizieller XML-getriebener
    // Programmweg". BEWUSST NUR gegatet, NICHT entfernt: die Voll-Entfernung ist data-gated — die
    // golden-320-Subsumtion des Legacy-Pfads (E4-XML deckt V37.C/V38.C ab) ist noch nicht bestaetigt;
    // eine Entfernung jetzt zerstoerte die bewusst gehaltene Vergleichsfaehigkeit. Ohne den env faellt
    // der Treiber direkt in den regulaeren E4-XML-Pfad.
    if (env_trimmed("COMDARE_LEGACY_MESSREIHEN") == "1") {
        auto perms = comdare::messung_driver::load_all_permutations();
        std::cout << "[V37.C] Permutations-Inventar: " << perms.size() << " Eintraege\n";
        std::size_t i{0};
        for (auto const& p : perms) {
            std::cout << "  [" << (++i) << "/" << perms.size() << "] " << p.subsystem << " :: " << p.id << "\n";
        }
    }

    // V38.C (2026-05-24): Plugin-Loader — laedt alle .dll/.so/.dylib aus
    // dem perm-Baum, ruft pro Plugin perm_<id>_run(N, &micros) auf.
    // V41.B1 (2026-05-24): jeder Plugin-Aufruf wird als binary measurement-record
    // in <output_dir>/measurements/<perm_id>.bin geschrieben (Stage-03-kompatibel).
    // GO-V4 G2 (2026-07-13): identische Legacy-Huerde wie der V37.C-Block oben
    // (COMDARE_LEGACY_MESSREIHEN==1) — gegatet statt entfernt (data-gated, Begruendung s.o.), damit der
    // offizielle E4-XML-Weg ohne env der Alleinweg bleibt und dieser Plugin-Mikrobench nicht als
    // paralleler Mess-Pfad mitlaeuft.
    if (env_trimmed("COMDARE_LEGACY_MESSREIHEN") == "1") {
        // Annahme: messung_driver-Binary liegt in build/<preset>/<config>/.
        // perm-Root liegt unter build/<preset>/perm/.
        auto exe_dir = std::filesystem::current_path();
        // heuristische Suche nach perm/-Wurzel
        auto perm_root = exe_dir / "perm";
        for (int up = 0; up < 4 && !std::filesystem::exists(perm_root); ++up) {
            exe_dir   = exe_dir.parent_path();
            perm_root = exe_dir / "perm";
        }
        if (!std::filesystem::exists(perm_root)) {
            std::cerr << "[V38.C] perm-Root nicht gefunden, ueberspringe Plugin-Mikrobenchmark\n";
        } else {
            std::cout << "[V38.C] lade Plugins aus: " << perm_root.string() << "\n";
            auto                    plugins = comdare::messung_driver::load_all_perm_plugins(perm_root);
            constexpr unsigned long kRunOps = 1000;
            std::cout << "[V38.C] " << plugins.size() << " Plugins geladen, fuehre Mikrobenchmark aus (N=" << kRunOps
                      << ")\n";

            // V41.B1: ein Aggregat-File fuer alle Permutationen
            std::filesystem::path const v41_out_dir = std::filesystem::path{argv[2]} / "measurements";
            std::filesystem::create_directories(v41_out_dir);
            comdare::messung_driver::MeasurementWriter writer{v41_out_dir / "all_permutations.bin"};
            if (!writer.ok()) {
                std::cerr << "[V41.B1] WARN: konnte " << (v41_out_dir / "all_permutations.bin").string()
                          << " nicht oeffnen, ueberspringe binary records\n";
            }

            // V41.B3: pro Plugin N_REPS Runs sammeln (statt 1) fuer Statistik
            constexpr std::size_t                           kReps = 10;
            std::vector<comdare::messung_driver::PermStats> all_stats;
            all_stats.reserve(plugins.size());

            // Ladebalken ueber ALLE kartesischen Produkte (CE + prt-art gemeinsam).
            ProgressBar bar{"[Mikrobench] Kartesische Achsen-Permutationen", plugins.size()};
            for (auto const& p : plugins) {
                std::vector<double> samples_us;
                samples_us.reserve(kReps);
                bool all_ok = true;
                for (std::size_t rep = 0; rep < kReps; ++rep) {
                    double micros = 0.0;
                    int    rc     = p.desc->run(kRunOps, &micros);
                    if (rc == 0) {
                        samples_us.push_back(micros);
                    } else {
                        all_ok = false;
                    }
                }
                std::string subsystem = (std::string{p.desc->id}.rfind("pa_", 0) == 0) ? "prt_art" : "cache_engine";
                auto        stats     = comdare::messung_driver::compute_stats(p.desc->id, subsystem, p.desc->axes,
                                                                               p.desc->version, samples_us);
                all_stats.push_back(stats);

                bar.tick(stats.permutation_id);
                if (!(all_ok && !samples_us.empty())) {
                    bar.note(std::string{"[ERR] "} + std::string{p.desc->id} +
                             "  ok-samples=" + std::to_string(samples_us.size()));
                }

                // V41.B1: pro Plugin EIN aggregate binary record (mean us/op)
                // V41.P1: workload_used = "micro" (der eingebaute Plugin-Mikrobenchmark; echte
                // YCSB-Reihen setzen hier spaeter das Config-Workload-Label).
                if (writer.ok() && !samples_us.empty()) {
                    auto rec = comdare::messung_driver::make_record_from_run(static_cast<std::uint64_t>(kRunOps),
                                                                             stats.mean_us);
                    auto fp  = comdare::messung_driver::fingerprint_of(p.desc->id);
                    writer.add(p.desc->id, fp, all_ok, "micro", rec);
                }
            }
            bar.finish();
            writer.finalize();
            if (writer.ok() || writer.count() > 0) {
                std::cout << "[V41.B1] " << writer.count() << " binary records geschrieben: " << writer.path().string()
                          << "\n";
            }

            // V41.B3: Stats-CSV + paarweise Welch-Vergleiche
            std::filesystem::path stats_csv = v41_out_dir / "permutation_stats.csv";
            comdare::messung_driver::write_stats_csv(stats_csv, all_stats);
            std::cout << "[V41.B3] " << all_stats.size() << " Stats-Eintraege: " << stats_csv.string() << "\n";

            // ─── V41.G.1: Hierarchische Achsen-Iteration + Auswertung ───
            namespace md = comdare::messung_driver;
            // Item 1: aus (id, axes) jeder Permutation den Achsen-Baum bauen.
            std::vector<md::AxisItem> axis_items;
            axis_items.reserve(all_stats.size());
            for (auto const& s : all_stats) { axis_items.push_back(md::make_axis_item(s.permutation_id, s.axes)); }
            auto const axis_keys = md::collect_axis_keys(axis_items);
            auto const tree      = md::build_axis_tree(axis_items, axis_keys);

            // Item 2: hierarchische Ausgabe — Gruppen-Header je Achsen-Ebene "== key=value ==".
            std::cout << "[V41.G.1] Achsen-Baum (" << axis_keys.size() << " Achsen:";
            for (auto const& k : axis_keys) std::cout << ' ' << k;
            std::cout << "):\n";
            std::function<void(md::AxisTreeNode const&, int)> print_node = [&](md::AxisTreeNode const& n, int depth) {
                std::string const indent(static_cast<std::size_t>(depth) * 2, ' ');
                if (!n.axis_key.empty()) {
                    std::cout << indent << "== " << n.axis_key << '=' << n.axis_value << " == ("
                              << md::count_leaf_items(n) << " Perm.)\n";
                }
                for (auto const& c : n.children) print_node(c, depth + 1);
                for (auto idx : n.item_indices) {
                    std::cout << indent << "  - " << all_stats[idx].permutation_id << "  " << all_stats[idx].mean_us
                              << " us/op\n";
                }
            };
            print_node(tree, 0);

            // Item 3: per-Achsen-Spalten-CSV (eine Spalte je Achsen-Schlüssel).
            std::filesystem::path const per_axis_csv = v41_out_dir / "permutation_stats_per_axis.csv";
            md::write_stats_csv_per_axis(per_axis_csv, all_stats, axis_keys);
            std::cout << "[V41.G.1] per-Achsen-CSV (" << axis_keys.size()
                      << " Achsen-Spalten): " << per_axis_csv.string() << "\n";

            // Samples je id für Welch sammeln.
            std::map<std::string, std::vector<double>> samples_by_id;
            ProgressBar welch_bar{"[Welch-Sampling] Kartesische Achsen-Permutationen", plugins.size()};
            for (auto const& p : plugins) {
                std::vector<double> samples;
                for (std::size_t rep = 0; rep < kReps; ++rep) {
                    double micros = 0.0;
                    if (p.desc->run(kRunOps, &micros) == 0) samples.push_back(micros);
                }
                welch_bar.tick(p.desc->id);
                samples_by_id[std::string{p.desc->id}] = std::move(samples);
            }
            welch_bar.finish();

            // Item 4: Welch RESTRINGIERT auf Achsen-Subtrees — je variierender Achse nur Items, die in
            // ALLEN anderen Achsen übereinstimmen (z.B. gleiche simd+layout, vergleiche Allokator-Varianten).
            std::vector<md::PairwiseRow> pairs;
            for (auto const& varying : axis_keys) {
                auto const groups = md::subtree_groups_varying(axis_items, axis_keys, varying);
                for (auto const& g : groups) {
                    std::string fixed;
                    for (auto const& k : axis_keys) {
                        if (k == varying) continue;
                        fixed += (fixed.empty() ? "" : ";") + k + "=" +
                                 md::axis_value(axis_items[g.front()].axes, k).value_or("<none>");
                    }
                    for (std::size_t i = 0; i < g.size(); ++i) {
                        for (std::size_t j = i + 1; j < g.size(); ++j) {
                            auto const& a  = axis_items[g[i]].id;
                            auto const& b  = axis_items[g[j]].id;
                            auto const& sa = samples_by_id[a];
                            auto const& sb = samples_by_id[b];
                            if (sa.size() < 2 || sb.size() < 2) continue;
                            auto w = md::welch_us(sa, sb);
                            if (!w.valid) continue;
                            md::PairwiseRow row{};
                            row.a               = a;
                            row.b               = b;
                            row.mean_a          = w.mean_a / 1000.0; // ns->us
                            row.mean_b          = w.mean_b / 1000.0;
                            row.delta           = row.mean_a - row.mean_b;
                            row.t_stat          = w.t_statistic;
                            row.df              = w.degrees_of_freedom;
                            row.p_value         = w.p_value;
                            row.significant_5pc = (w.p_value < 0.05);
                            row.varying_axis    = varying;
                            row.fixed_context   = fixed;
                            pairs.push_back(row);
                        }
                    }
                }
            }
            std::filesystem::path const pairs_csv = v41_out_dir / "welch_pairwise.csv";
            md::write_pairwise_csv(pairs_csv, pairs);
            std::size_t sig = 0;
            for (auto const& r : pairs)
                if (r.significant_5pc) ++sig;
            std::cout << "[V41.G.1] " << pairs.size() << " subtree-restringierte Welch-Tests, " << sig
                      << " signifikant (p<0.05): " << pairs_csv.string() << "\n";

            comdare::messung_driver::unload_all(plugins);
        }
    }

    std::filesystem::path config_dir{argv[1]};
    std::filesystem::path output_dir{argv[2]};
    std::filesystem::path comdare_root = std::filesystem::current_path();
    std::filesystem::path messreihen_xml; // V9.6: optional

    for (int i = 3; i < argc; ++i) {
        std::string a{argv[i]};
        if (a.rfind("--comdare-root=", 0) == 0) {
            comdare_root = std::filesystem::path{a.substr(15)};
        } else if (a.rfind("--messreihen-xml=", 0) == 0) {
            messreihen_xml = std::filesystem::path{a.substr(17)};
        } else {
            std::cerr << "Unknown arg: " << a << "\n";
            print_usage();
            return 1;
        }
    }

    std::cout << "==== Comdare Messung-Driver (REV 7.6 V8.12) ====\n";
    std::cout << "Config-Dir   : " << config_dir.string() << "\n";
    std::cout << "Output-Dir   : " << output_dir.string() << "\n";
    std::cout << "Comdare-Root : " << comdare_root.string() << "\n";
    std::cout << "Messreihen   : 3 (A=PRT-ART vs SOTA, B=Cache-Engine, C=Merge)\n";

    // REV 7.6 V8.12 — Aktivierung des EXPERIMENT_MODE im Sub-Build (User-Direktive
    // 2026-05-13/14). Default in cache-engine ist OFF (Production-Pfad).
    // Phase 7 (Review wf_8508f98c): der fruehere #ifndef-Warnblock war ein Fehlalarm in JEDEM
    // super-Build — der Treiber-HOST erhaelt das Define nie (directory-scoped im ce-Baum,
    // Facade-Defines PRIVATE) und braucht es nicht: Mess-Hooks leben in den Tier-DLL-Kompilaten
    // (COMDARE_MEASUREMENT_ON via Facade-Weitergabe); die Invariante Experiment=>Messung
    // erzwingt der compile-time-Guard in abi_adapter.hpp je Tier-Kompilat.
    std::cout << "Mess-Hooks: in den Tier-DLL-Kompilaten aktiv (COMDARE_MEASUREMENT_ON via "
                 "Facade-Defines; Host-Define irrelevant)\n";
    std::cout << "\n";

    std::filesystem::create_directories(output_dir);

    // G5 (P-B, Ledger Section 65/66): COMDARE_PRUNE_ONLY=="true" -> STANDALONE-Prune-Modus (Spiegel des PRUEF_ONLY-
    // Modus, aber NICHT ueber die run_profile-Fassade -- direkter Bibliotheks-Aufruf, der Iterator/Facade bleiben
    // unberuehrt): iteriert die bereits gebauten Tier-Binaries unter output_dir/e4_xml/dll/<stem>/ und ruft je Stem
    // ArtifactCache::verify_remote_then_prune -> loescht die lokale Binary + ihre 2 Sidecars NUR nach beweisbarem
    // Remote-Spiegel (remote .version == lokale + Groesse == lokale); NIEMALS Messdaten. Baut/misst NICHT. Inert
    // ohne minio (from_env INERT => nie loeschen). Kein throw; [PRUNE-TESTAT]-Aggregat + je-Stem-Log (perm.prune.log).
    if (env_trimmed("COMDARE_PRUNE_ONLY") == "true") {
        namespace atp                       = comdare::cache_engine::builder::artifact_transport;
        std::filesystem::path const dll_dir = output_dir / "e4_xml" / "dll";
        std::string                 bv      = env_trimmed("COMDARE_BUILD_VERSION");
        if (bv.empty()) bv = "m3v2";
        auto const      ac       = atp::ArtifactCache::from_env();
        std::size_t     verified = 0, pruned = 0, behalten = 0, skipped = 0;
        std::error_code pec;
        std::cout << "[E4] G5 prune-only: verify-then-prune je Stem unter " << dll_dir.string()
                  << " (build_version=" << bv << "; " << (ac.minio_enabled() ? "minio aktiv" : "INERT -> nie loeschen")
                  << ")\n";
        if (std::filesystem::is_directory(dll_dir, pec)) {
            for (auto const& entry : std::filesystem::directory_iterator(dll_dir, pec)) {
                if (!entry.is_directory()) continue;
                atp::PruneOutcome const oc = ac.verify_remote_then_prune(entry.path(), bv);
                switch (oc.state) {
                    case atp::PruneState::pruned:
                        ++pruned;
                        ++verified;
                        break;
                    case atp::PruneState::kept:
                        ++behalten;
                        ++verified;
                        break;
                    case atp::PruneState::skipped: ++skipped; break;
                }
            }
        }
        std::cout << "[PRUNE-TESTAT] verified=" << verified << " pruned=" << pruned << " behalten=" << behalten
                  << " skipped=" << skipped << " dll_dir=" << dll_dir.string() << "\n";
        return 0;
    }

    int e4_overall_rc = 0;

#ifdef COMDARE_MESSUNG_HAVE_E4_FACADE
    {
        namespace pf = comdare::cache_engine::builder::profile_facade;

        try {
            std::string thesis_profile = env_trimmed("COMDARE_THESIS_PROFILE");
#ifdef COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE
            if (thesis_profile.empty()) thesis_profile = COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE;
#endif

            // P6/#229: E4-XML ist der DEFAULT-/ALLEINWEG. Kein Opt-in mehr — der messung_driver orchestriert den
            // Gesamtablauf AUSSCHLIESSLICH ueber die Profil-XML. Der Legacy-ExperimentDriver-Pfad (3 Messreihen)
            // laeuft nur noch bei explizitem COMDARE_LEGACY_MESSREIHEN=1 (Subsumtions-Vergleich waehrend des
            // golden-320-Voll-Laufs; danach entfaellt er ganz).
            if (thesis_profile.empty() || !std::filesystem::exists(thesis_profile)) {
                std::cerr << "[E4] thesis_profile fehlt oder existiert nicht: "
                          << (thesis_profile.empty() ? std::string{"<leer>"} : thesis_profile) << ".\n";
                e4_overall_rc = 5;
            } else {
                std::filesystem::path const e4_dir = output_dir / "e4_xml";
                std::error_code             ec;
                std::filesystem::create_directories(e4_dir, ec);
                if (ec) throw std::runtime_error("create_directories(" + e4_dir.string() + "): " + ec.message());

                // Storage #51 (No-Op-Default => byte-neutral): der EINE Transport-Client aus der Umgebung. Ist weder
                // COMDARE_MINIO_ENDPOINT/_BUCKET (Ebene B, mc-Push) noch COMDARE_MEASUREMENT_DROP_URL (Ebene C, measure-
                // drop-HTTPS-PUT) gesetzt, ist er INERT -> die Naht-Funktionen bleiben LEER -> der Iterator ruft sie nie
                // -> golden/CI byte-identisch. EINE Instanz (ein datierter Lauf-Baum) fuer BEIDE Profil-Wurzeln (xa/pa).
                // Credentials NIE hier (mc/MC_HOST_<alias>, measure-drop-Token nur ueber 0600-curl-Config), NIE geloggt.
                // SYNCHRON an der per-Binary-/whole-run-Naht — kein async/detached.
                namespace at                   = comdare::cache_engine::builder::artifact_transport;
                auto const      artifact_cache = std::make_shared<at::ArtifactCache>(at::ArtifactCache::from_env());
                at::CachePushFn cache_push;
                at::CachePullFn cache_pull; // S2 (#46a): BATCH-Warm-Cache-Hydrierung VOR dem Bau (No-Op-Default)
                at::MeasurementSinkFn measurement_sink;
                // W11 (Ledger §43.c): der BAU-Modus Teil-Marker-Sink + Intervall. Nach je COMDARE_GN_PART_SIZE (Default
                // 1024) gepushten DLLs legt der async Push-Pump einen Teil-Marker <build_version>/_gn_chunk_markers/
                // <range>.part<k>.done in den Store (Cluster-Resume bei Job-Abbruch). Der range = COMDARE_GOLDEN_N_RANGE
                // (byte-exakt zur YAML-Marke ${GN_RANGE//:/-}, im ArtifactCache ':' -> '-'). Leer/inert => No-Op.
                at::PartialMarkerFn partial_marker_sink;
                std::size_t         chunk_part_size = 1024; // Default; COMDARE_GN_PART_SIZE ueberschreibt
                if (auto ps = parse_size_env_strict("COMDARE_GN_PART_SIZE")) chunk_part_size = *ps;
                std::string const gn_range_raw = env_trimmed("COMDARE_GOLDEN_N_RANGE");
                if (!artifact_cache->inert()) {
                    cache_push = [artifact_cache](std::filesystem::path const& bin_dir, std::string const& bv) {
                        artifact_cache->push_tier_binary(bin_dir, bv);
                    };
                    // S2 (#46a): BATCH-Warm-Cache-Hydrierung VOR dem Bau. Der Iterator ruft sie EINMAL (Phase A) und
                    // zieht den ganzen Perm-Praefix rekursiv ins output_dir -> dll_is_current ueberspringt die gepullten
                    // (bauen nur die fehlenden). pull_tier_prefix ist selbst No-Op ohne Ebene B (minio) => byte-neutral.
                    cache_pull = [artifact_cache](std::filesystem::path const& dest, std::string const& bv) {
                        artifact_cache->pull_tier_prefix(bv, dest);
                    };
                    measurement_sink = [artifact_cache](std::filesystem::path const& file, std::string const& dest) {
                        artifact_cache->sink_measurement(file, dest);
                    };
                    // Teil-Marker nur, wenn ein Chunk-Fenster gesetzt ist (golden-N-Bau) -- sonst waere der range-Key
                    // sinnlos. Die range wird in der Closure gekapselt (Sink-Signatur = (build_version, part_index)).
                    if (!gn_range_raw.empty())
                        partial_marker_sink = [artifact_cache, gn_range_raw](std::string const& bv, std::size_t part) {
                            artifact_cache->push_chunk_partial_marker(bv, gn_range_raw, part);
                        };
                    std::cout << "[E4] Storage #51 aktiv: minio=" << (artifact_cache->minio_enabled() ? "1" : "0")
                              << " measure-drop=" << (artifact_cache->drop_enabled() ? "1" : "0")
                              << " lauf-baum=" << artifact_cache->run_stamp()
                              << " teil-marker=" << (partial_marker_sink ? "an" : "aus")
                              << " part_size=" << chunk_part_size << " (W11 §43.c)\n";
                }

                // ---------------------------------------------------------------------------------------------------
                // G4b-1 (d1) / #46b I1 -- BESTANDSLOG-HOST-VERDRAHTUNG mit HARTEM DOPPEL-GATE (AUF-B3/B4/B5/B6).
                //
                // Bis zu dieser Scheibe existierte die Host-Seite des Bestandslogs NICHT: bestandslog_active
                // (cache_engine_builder_iterator.hpp:927-929) war in Produktion IMMER false, weil niemand die vier
                // Traeger belegte. Hier werden sie belegt -- aber nur unter drei gleichzeitig erfuellten Bedingungen.
                //
                // WARUM DREI GATES UND NICHT NUR EINES: make_bestand_transport belegt alle vier Verben
                // BEDINGUNGSLOS, auch auf einem inerten Cache, und bestandslog_active prueft nur, DASS sie belegt
                // sind. Ohne Doppel-Gate haengt der Umschalt von provision_all auf run_planer_driven_provision
                // (iterator:979-982) allein an einem nicht-leeren Doc-Key -- ein anderer BAU-TREIBER, ausgeloest
                // durch eine gesetzte Umgebungsvariable. Das Gate gehoert deshalb hierher, an die Injektionsstelle.
                //
                // WARUM minio_enabled() UND NICHT !inert() (AUF-B3, korrigiert 2026-07-26): inert() ist
                // !minio_enabled() && !drop_enabled() -- es ist also schon dann false, wenn NUR Ebene C
                // (COMDARE_MEASUREMENT_DROP_URL, der Mess-CSV-Kanal) konfiguriert ist. Die vier Objekt-Verben, aus
                // denen der BestandTransport besteht, gaten aber ausnahmslos auf Ebene B: object_fetch
                // (artifact_cache.hpp:487), object_store (:507), object_remove (:535) geben ohne minio_enabled()
                // nullopt bzw. false zurueck. Unter !inert() wuerde bei einer Nur-drop-Konfiguration also ein
                // vollstaendig belegter, aber TOTER Transport gebunden: bestandslog_active waere true, der Bau
                // schaltete auf den Planer-Treiber, das Lager blieb dauerhaft leer und jeder flush scheiterte.
                // minio_enabled() ist die praezise Bedingung und impliziert !inert().
                //
                // LEBENSDAUER (AUF-B5): make_bestand_transport haelt ArtifactCache CONST& (Kopf Z.20-24 von
                // artifact_cache_transport.hpp). Weitergereicht wird deshalb DERSELBE shared_ptr von oben (:840),
                // den auch cache_push/cache_pull kapseln -- die Fassaden-TU bindet den Transport daraus und benutzt
                // ihn nur innerhalb des run_profile-Aufrufs. Ein Binden an eine temporaere from_env()-Instanz
                // (vier dangling Lambdas) ist so strukturell ausgeschlossen. Warum die Fassade bindet und nicht
                // dieser Host: artifact_cache_transport.hpp zieht den ce-XML-DOM nach, der im Include-Satz dieses
                // Targets fehlt -- und profile_run_facade.hpp ist ausdruecklich die umbrella-FREIE POD-Signatur.
                //
                // LOG-KANAL (AUF-B6): ALLE [bestandslog]-Zeilen gehen auf cerr, NIE auf cout. cout ist im
                // Emissions-Pfad der YAML-Kanal (profile_run_facade.cpp Umleitung ueber den Director) -- eine
                // Fremdzeile dort ist ein GitLab config_error. Die [E4]-Zeile oben schreibt auf cout und verleitet
                // dazu; hier wird bewusst abgewichen.
                //
                // FEHLERKLASSE konfiguration_unvollstaendig (AUF-B4): die BEIDEN Gate-Bedingungen
                // COMDARE_BESTANDSLOG=="true" UND minio_enabled() erfuellt, aber eine der drei Pflicht-Variablen
                // leer => HARTER ABBRUCH mit exit_code 6, EINE Zeile mit stabilem Etikett. Der Halb-Zustand (Log an,
                // aber anonym oder ohne Ziel-Dokument) ist der teuerste denkbare: er produziert zwei Tage lang
                // unbrauchbare Zeilen, und den Lauf wiederholt man nicht.
                //
                // FEHLERKLASSE lager_ebene_fehlt: Opt-in gesetzt, aber Ebene B (minio) fehlt -- EINE WARNUNG auf cerr,
                // KEIN Abbruch, KEIN Binden. Das deckt beide Ausbaustufen des Falls: gar keine Ebene (voll inert) und
                // nur Ebene C (measure-drop ohne Objekt-Store). Begruendung fuer die Sichtbarkeit: beim Voll-Bau mit
                // COMDARE_BESTANDSLOG=true ist ein STILL leeres Lager der teuerste Fehlermodus -- er faellt erst nach
                // Stunden auf, und den Lauf wiederholt man nicht. Kein Abbruch, weil die Konfiguration als solche
                // gueltig ist (ein Mess-Lauf mit Ergebnis-Drop ohne Objekt-Store ist legitim) und ein exit hier einen
                // laufenden Bau kosten wuerde. Die Pflicht-Variablen werden in diesem Zweig NICHT geprueft: ohne
                // Ebene B gibt es nichts zu reservieren, also auch nichts unvollstaendig zu konfigurieren.
                //
                // STUMM INERT bleibt genau EIN Fall: COMDARE_BESTANDSLOG ungesetzt/!="true". Dann faellt keine
                // einzige Zeile -- das ist die Byte-Neutralitaet des Vor-Zustands, und nur an ihr haengt der
                // env-freie 0-Byte-Nachweis. Beide Zeilen oben koennen ausschliesslich bei gesetztem Opt-in feuern.
                // ---------------------------------------------------------------------------------------------------
                namespace bl = comdare::cache_engine::builder::bestandslog;
                std::shared_ptr<at::ArtifactCache const>                                bestand_cache;
                std::function<std::optional<std::string>(std::filesystem::path const&)> bestand_key_of;
                std::string                                                             bestand_doc_key;
                std::string                                                             bestand_owner_uuid;
                std::string                                                             bestand_maschine;
                // Das Opt-in EINMAL lesen -- es entscheidet ueber beide Zweige: erfuellt zusammen mit minio_enabled()
                // das Gate, und traegt allein die Sichtbarkeits-Warnung. Die zweite Gate-Bedingung ist
                // minio_enabled(), NICHT !inert() (s.o.).
                bool const bestandslog_opt_in = env_trimmed("COMDARE_BESTANDSLOG") == "true";
                if (bestandslog_opt_in && artifact_cache->minio_enabled()) {
                    std::string const doc_key    = env_trimmed("COMDARE_BESTANDSLOG_DOC_KEY");
                    std::string const owner_uuid = env_trimmed("COMDARE_BESTANDSLOG_OWNER_UUID");
                    std::string const maschine   = env_trimmed("COMDARE_BESTANDSLOG_MASCHINE");
                    // Fail-loud: erste fehlende Variable in FESTER Reihenfolge -> genau EINE Zeile, deterministisch.
                    char const* fehlende_var = nullptr;
                    if (doc_key.empty())
                        fehlende_var = "COMDARE_BESTANDSLOG_DOC_KEY";
                    else if (owner_uuid.empty())
                        fehlende_var = "COMDARE_BESTANDSLOG_OWNER_UUID";
                    else if (maschine.empty())
                        fehlende_var = "COMDARE_BESTANDSLOG_MASCHINE";
                    if (fehlende_var != nullptr) {
                        std::cerr << "[bestandslog] FEHLER fehlerklasse=konfiguration_unvollstaendig: "
                                  << "COMDARE_BESTANDSLOG=true, aber " << fehlende_var << " ist leer -- Abbruch.\n";
                        return 6;
                    }
                    bestand_cache      = artifact_cache; // derselbe Zeiger wie cache_push/cache_pull (AUF-B5)
                    bestand_key_of     = bl::make_fingerprint_key_fn();
                    bestand_doc_key    = doc_key;
                    bestand_owner_uuid = owner_uuid;
                    bestand_maschine   = maschine;
                    std::cerr << "[bestandslog] aktiv: doc_key=" << bestand_doc_key << " maschine=" << bestand_maschine
                              << " key_of=.fingerprint-Sidecar (#46b I1/I2)\n";
                } else if (bestandslog_opt_in) {
                    // Opt-in gesetzt, Ebene B fehlt: die Absicht ist da, das Lager kann sie nicht erfuellen. Genau
                    // EINE Zeile, damit ein still leeres Lager nicht erst nach Stunden auffaellt. drop_enabled wird
                    // mitgemeldet, weil es die beiden Ausbaustufen unterscheidet (voll inert vs. nur Ebene C) --
                    // dieselbe Information, die die [E4]-Storage-Zeile auf cout traegt, hier auf dem Bestandslog-Kanal.
                    std::cerr << "[bestandslog] WARNUNG fehlerklasse=lager_ebene_fehlt: COMDARE_BESTANDSLOG=true, aber "
                              << "Ebene B (minio) ist nicht konfiguriert (measure-drop="
                              << (artifact_cache->drop_enabled() ? "1" : "0")
                              << ") -- Bestandslog bleibt AUS, Bau unveraendert.\n";
                }

                // Welle 5 (E-W5-2, §38-Fortschritts-Rueck-Kanal, 2026-07-20): der EINE konkrete Progress-Konsument des
                // Treibers. run_profile/run_experiment feuern je bereitgestellte/gemessene Binary GENAU EIN ProgressDelta
                // (fenster-relativer Perm-Cursor + mixed-radix-Achsen-Delta) und am Fensterende GENAU EIN done=true.
                // REINER BEOBACHTER: schreibt NUR nach stderr (gedrosselt) + additiv in <output_dir>/progress.cursor --
                // NIE in die Mess-CSV/binary_id => golden-neutral (der No-Op-Default der Fassade bleibt fuer alle
                // Nicht-Treiber-Konsumenten byte-identisch). Die Mess-Sequenzierung leistet bereits die aktive
                // CI-resource_group ceb-measurement-exclusive -- der Sink beobachtet den Cursor, er steuert nichts.
                namespace ex                                        = comdare::cache_engine::builder::experiment;
                std::filesystem::path const progress_cursor_path    = output_dir / "progress.cursor";
                bool const                  progress_cursor_enabled = std::filesystem::exists(output_dir);
                // S1 (§62-B Log-Flush, 2026-07-22, Befund 6h-stumm): die Drossel ist ZEIT- statt zaehl-basiert (frueher
                // kProgressStride=10) und die stderr-Zeile wird GEFLUSHT -> auch in langen, sonst stillen Fenstern
                // kommt regelmaessig ein geflushtes Lebenszeichen. Rein beobachtend (stderr + progress.cursor), NIE in
                // Mess-CSV/binary_id -> golden-neutral (No-Op-Default der Fassade unveraendert).
                constexpr std::int64_t kProgressIntervalS =
                    30; // hoechstens alle 30 s eine progress-Zeile (+ immer done)
                auto const progress_last_emit_s =
                    std::make_shared<std::atomic<std::int64_t>>(std::chrono::duration_cast<std::chrono::seconds>(
                                                                    std::chrono::steady_clock::now().time_since_epoch())
                                                                    .count());
                ex::ProgressSinkFn const progress_sink = [progress_cursor_path, progress_cursor_enabled,
                                                          progress_last_emit_s](ex::ProgressDelta const& d) {
                    std::int64_t const now_s = std::chrono::duration_cast<std::chrono::seconds>(
                                                   std::chrono::steady_clock::now().time_since_epoch())
                                                   .count();
                    if (!d.done) { // done immer; sonst zeit-gated (thread-sicher via CAS -> genau ein Emitter je Intervall)
                        std::int64_t last = progress_last_emit_s->load(std::memory_order_relaxed);
                        if (now_s - last < kProgressIntervalS) return;
                        if (!progress_last_emit_s->compare_exchange_strong(last, now_s)) return;
                    }
                    std::ostringstream line;
                    if (d.done) {
                        line << "[progress] done perm=" << d.cursor << " window-complete";
                    } else {
                        line << "[progress] perm=" << d.cursor << " axes_changed=" << d.changed.size();
                        for (auto const& c : d.changed) line << " " << c.axis_index << "->" << c.variant_index;
                    }
                    std::cerr << line.str() << "\n" << std::flush;
                    if (progress_cursor_enabled)
                        if (std::ofstream cur{progress_cursor_path, std::ios::app}; cur) cur << line.str() << "\n";
                };

                // Bruecke-I4 (2026-07-16): der E4-Run-Block deckt — wie der --validate-Zweig (S0/FORK-4) — BEIDE
                // offiziellen Profil-Wurzeln ab. Ein Root-Tag-Sniff (rein-lesend ueber den common-DOM) entscheidet:
                // <comdare_thesis_profile> -> run_profile_facade (UNVERAENDERT, Thesis-Weg); <comdare_experiment> ->
                // run_experiment_profile_facade (die duenne 3-Phasen-Bruecke ueber DEMSELBEN E4-Unterbau, echte DLLs,
                // DIE EINE offizielle CSV e4_xml/measurements.csv, E8). Beide Parser liefern nullopt bei Fremd-Tag,
                // daher ist der reine Root-Tag-Read gefahrlos. COMDARE_RUN_V32_EXPERIMENT/COMDARE_V32_DRIVER_ENABLE
                // werden NICHT benutzt — die Bruecke ERSETZT die untersagte Parallelstrecke (kein neuer Mess-Pfad).
                std::string root_tag;
                if (std::ifstream in{thesis_profile, std::ios::binary}; in) {
                    std::ostringstream ss;
                    ss << in.rdbuf();
                    if (auto const root = comdare::common::xml::parse_document(ss.str())) root_tag = root->tag;
                }

                if (root_tag == "comdare_experiment") {
#if defined(COMDARE_CE_AXIS_REGISTRY_PATH) && defined(COMDARE_PRT_AXIS_REGISTRY_PATH)
                    pf::ExperimentRunArgs xa;
                    xa.profile_path     = thesis_profile;
                    xa.out_csv          = e4_dir / "measurements.csv"; // E8: DIE EINE offizielle CSV (wie Thesis-Weg)
                    xa.src_dir          = e4_dir / "src";
                    xa.dll_dir          = e4_dir / "dll";
                    xa.ce_registry_path = COMDARE_CE_AXIS_REGISTRY_PATH; // 2-Registry-Kanon (Validat, I2)
                    xa.prt_registry_path =
                        COMDARE_PRT_AXIS_REGISTRY_PATH; // Host reicht beide herein (Baseline-Layering)
                    xa.build_version     = "m3v2";
                    xa.min_free_gb       = parse_min_free_gb_from_env();
                    xa.platform_override = env_trimmed("COMDARE_PLATFORM");
                    if (xa.platform_override.empty()) xa.platform_override = compile_time_platform_tag();
                    xa.load_profile_dir = env_trimmed("COMDARE_LOAD_PROFILE_DIR");
                    if (auto cap = parse_size_env_strict("COMDARE_E4_CAP")) xa.max_binaries = *cap;
                    if (auto ws = parse_size_env_strict("COMDARE_WORKLOAD_RECORDS"))
                        xa.working_set_override = static_cast<std::uint64_t>(*ws);
                    if (std::string const build_tag = env_trimmed("COMDARE_BUILD_VERSION"); !build_tag.empty())
                        xa.build_version_tag_override = build_tag;
                    // W6 (Ledger §32-F7): paralleler Bau-Pool. COMDARE_BUILD_PARALLEL = harte Compile-Worker-Zahl
                    // (KOMPILATION parallel, MESSEN bleibt 1-Thread). Ungesetzt => parallel_jobs()-Heuristik = Ist
                    // (byte-neutral). Muster wie COMDARE_E4_CAP (parse_size_env_strict: fail-fast bei Muell).
                    if (auto bp = parse_size_env_strict("COMDARE_BUILD_PARALLEL")) {
                        xa.build_parallelism = *bp;
                        std::cout << "[E4] W6 Bau-Pool: COMDARE_BUILD_PARALLEL=" << *bp
                                  << " parallele Compile-Worker (Messen bleibt 1-Thread)\n";
                    }
                    xa.cache_push          = cache_push;       // Storage #51 (No-Op-Default => byte-neutral)
                    xa.cache_pull          = cache_pull;       // S2 (#46a): BATCH-Warm-Cache-Hydrierung (No-Op-Default)
                    xa.measurement_sink    = measurement_sink; // Storage #51 (No-Op-Default => byte-neutral)
                    xa.partial_marker_sink = partial_marker_sink; // W11 (§43.c): BAU-Modus Teil-Marker (No-Op-Default)
                    xa.chunk_part_size     = chunk_part_size;     // W11 (§43.c): Teil-Marker-Intervall N
                    xa.progress_sink =
                        progress_sink; // Welle 5 (E-W5-2): §38-Fortschritts-Rueck-Kanal (Treiber-Konsument)
                    // W5-C+ (§36.1 Zellen-Locking): GN-Zellen-Filter — SPIEGEL zum run_profile-Zweig. Leer = kein
                    // Filter = Ist-Verhalten (byte-neutral). Wirkt am opt×simd-Walk in run_experiment_profile.
                    xa.gn_cell_opt  = env_trimmed("COMDARE_GN_OPT");
                    xa.gn_cell_simd = env_trimmed("COMDARE_GN_SIMD");
                    if (!xa.gn_cell_opt.empty() || !xa.gn_cell_simd.empty())
                        std::cout << "[E4] W5-C+ GN-Zellen-Filter aktiv: opt='" << xa.gn_cell_opt << "' simd='"
                                  << xa.gn_cell_simd << "' (§36.1: eine System-Perm je Cluster-Zelle)\n";

                    std::cout << "[E4] comdare_experiment-Bruecke via run_experiment_profile-Fassade: profile="
                              << thesis_profile << " -> " << xa.out_csv.string() << "\n";
                    pf::ExperimentRunResult const xr = pf::run_experiment_profile_facade(xa);
                    std::cout << "[E4] fertig (experiment): exit=" << xr.exit_code << " phasen=" << xr.phases
                              << " sota_rows=" << xr.sota_rows << " sota_ids=" << xr.sota_binary_ids
                              << " measured=" << xr.measured << " resumed=" << xr.resumed << "\n";
                    if (xr.exit_code != 0) {
                        e4_overall_rc = xr.exit_code;
                        std::cerr << "[E4] WARN: comdare_experiment-Lauf exit=" << xr.exit_code << ".\n";
                    }
#else
                    std::cerr << "[E4] '" << thesis_profile
                              << "': comdare_experiment erkannt, aber die statischen Registry-Pfade wurden nicht "
                                 "einkompiliert (COMDARE_CE/PRT_AXIS_REGISTRY_PATH) -- ce-Klon/CMake nicht synchron?\n";
                    e4_overall_rc = 5;
#endif
                } else {
                    pf::ProfileRunArgs pa;
                    pa.profile_path      = thesis_profile;
                    pa.out_csv           = e4_dir / "measurements.csv";
                    pa.src_dir           = e4_dir / "src";
                    pa.dll_dir           = e4_dir / "dll";
                    pa.build_version     = "m3v2";
                    pa.min_free_gb       = parse_min_free_gb_from_env();
                    pa.platform_override = env_trimmed("COMDARE_PLATFORM");
                    if (pa.platform_override.empty()) pa.platform_override = compile_time_platform_tag();

                    // Achse-2-Lastprofile: leer ist OK — die run_profile-Fassade defaultet auf die zum Profil
                    // co-lokalisierten Lastprofile (algorithm_profiles/load_profiles/), sodass die XML selbst-
                    // suffizient ist (G1/#229). COMDARE_LOAD_PROFILE_DIR bleibt reiner Override; findet die
                    // Fassade 0 gueltige Profile, bricht SIE mit exit 4 ab (Achse 2 nie still leer =
                    // two_phase_valid=0-Schutz bleibt gewahrt, nur in die WIE-Schicht verlagert).
                    pa.load_profile_dir = env_trimmed("COMDARE_LOAD_PROFILE_DIR");
                    if (auto cap = parse_size_env_strict("COMDARE_E4_CAP")) pa.max_binaries = *cap;
                    if (auto ws = parse_size_env_strict("COMDARE_WORKLOAD_RECORDS"))
                        pa.working_set_override = static_cast<std::uint64_t>(*ws);
                    // INC-G6 (33/34): golden-N Chunk-Fenster + provision-only. Inert ohne die Env-Vars
                    // (byte-identisch zum Ist-Lauf). COMDARE_GOLDEN_N_RANGE="start:count" fenstert den 2^17-
                    // Indexraum; COMDARE_GOLDEN_N_PROVISION_ONLY=="true" baut NUR DLLs (misst nicht).
                    if (auto range = parse_golden_range_env()) {
                        pa.golden_range_start = range->start;
                        pa.golden_range_count = range->count;
                        std::cout << "[E4] INC-G6 golden-N Chunk-Fenster: start=" << range->start
                                  << " count=" << range->count << "\n";
                    }
                    if (env_trimmed("COMDARE_GOLDEN_N_PROVISION_ONLY") == "true") {
                        pa.provision_only = true;
                        std::cout << "[E4] INC-G6 provision-only: baut DLLs, misst NICHT.\n";
                    }
                    // S3 (§62-B, 2026-07-22): COMDARE_PRUEF_ONLY=="true" faehrt NUR das Konformitaets-Gate je bereits
                    // gebauter .so im dll_dir (ueber das COMDARE_GOLDEN_N_RANGE-Fenster der COMDARE_GN_OPT/SIMD-Perm) --
                    // KEINE Messung, KEIN Neubau; exit!=0 bei Gate-Fail. Ablauf-Selektor wie provision-only (kein
                    // Methodik-WERT). Inert ohne die Var (byte-identisch).
                    if (env_trimmed("COMDARE_PRUEF_ONLY") == "true") {
                        pa.pruef_only = true;
                        std::cout << "[E4] S3 pruef-only: laedt gebaute .so + faehrt NUR das Konformitaets-Gate "
                                     "(misst/baut NICHT).\n";
                    }
                    // W5-C+ (§36.1 Zellen-Locking): der GN-Zellen-Filter. Die CI-Matrix exportiert je Cluster-Zelle
                    // COMDARE_GN_OPT/COMDARE_GN_SIMD (z.B. O2 + no_extension). Gesetzt => run_profile baut in dieser
                    // Zelle NUR die matchende (opt,simd)-Perm statt aller Profil-Perms (Befund Pipeline 11453:
                    // 4-fach-redundanter Bau). Leer/ungesetzt = kein Filter = Ist-Verhalten (byte-neutral).
                    pa.gn_cell_opt  = env_trimmed("COMDARE_GN_OPT");
                    pa.gn_cell_simd = env_trimmed("COMDARE_GN_SIMD");
                    if (!pa.gn_cell_opt.empty() || !pa.gn_cell_simd.empty())
                        std::cout << "[E4] W5-C+ GN-Zellen-Filter aktiv: opt='" << pa.gn_cell_opt << "' simd='"
                                  << pa.gn_cell_simd << "' (§36.1: eine System-Perm je Cluster-Zelle)\n";

                    if (std::string const build_tag = env_trimmed("COMDARE_BUILD_VERSION"); !build_tag.empty())
                        pa.build_version_tag_override = build_tag;
                    if (env_trimmed("COMDARE_RUN_SOTA") == "0") pa.run_sota_series = false;
                    // W6 (Ledger §32-F7): paralleler Bau-Pool. COMDARE_BUILD_PARALLEL = harte Compile-Worker-Zahl
                    // (KOMPILATION parallel, MESSEN bleibt 1-Thread). Ungesetzt => parallel_jobs()-Heuristik = Ist
                    // (byte-neutral). Muster wie COMDARE_E4_CAP (parse_size_env_strict: fail-fast bei Muell).
                    if (auto bp = parse_size_env_strict("COMDARE_BUILD_PARALLEL")) {
                        pa.build_parallelism = *bp;
                        std::cout << "[E4] W6 Bau-Pool: COMDARE_BUILD_PARALLEL=" << *bp
                                  << " parallele Compile-Worker (Messen bleibt 1-Thread)\n";
                    }
                    pa.cache_push       = cache_push;       // Storage #51 (No-Op-Default => byte-neutral)
                    pa.cache_pull       = cache_pull;       // S2 (#46a): BATCH-Warm-Cache-Hydrierung (No-Op-Default)
                    pa.measurement_sink = measurement_sink; // Storage #51 (No-Op-Default => byte-neutral)
                    // G4b-1 (d1): die fuenf Bestandslog-Traeger. Bereits GEGATET (Doppel-Gate oben) -- ist das Gate
                    // aus, sind alle fuenf leer und bestandslog_active bleibt false => byte-neutral. NUR pa: der
                    // xa-Pfad (:962-964, comdare_experiment) bleibt in dieser Scheibe INERT (AUF-B2).
                    pa.bestand_cache       = bestand_cache;
                    pa.bestand_key_of      = bestand_key_of;
                    pa.bestand_doc_key     = bestand_doc_key;
                    pa.bestand_owner_uuid  = bestand_owner_uuid;
                    pa.bestand_maschine    = bestand_maschine;
                    pa.partial_marker_sink = partial_marker_sink; // W11 (§43.c): BAU-Modus Teil-Marker (No-Op-Default)
                    pa.chunk_part_size     = chunk_part_size;     // W11 (§43.c): Teil-Marker-Intervall N
                    pa.progress_sink =
                        progress_sink; // Welle 5 (E-W5-2): §38-Fortschritts-Rueck-Kanal (Treiber-Konsument)

                    std::cout << "[E4] XML-Lauf via run_profile-Fassade: profile=" << thesis_profile << " -> "
                              << pa.out_csv.string() << "\n";
                    pf::ProfileRunResult const rr = pf::run_profile_facade(pa);
                    std::cout << "[E4] fertig: exit=" << rr.exit_code << " basis_rows=" << rr.basis_rows
                              << " sota_rows=" << rr.sota_rows << " basis_ids=" << rr.basis_binary_ids
                              << " sota_ids=" << rr.sota_binary_ids << " measured=" << rr.measured
                              << " resumed=" << rr.resumed << "\n";
                    if (rr.exit_code != 0) {
                        e4_overall_rc = rr.exit_code;
                        std::cerr << "[E4] WARN: E4-XML-Lauf exit=" << rr.exit_code << ".\n";
                    }
                }
            }
        } catch (std::exception const& e) {
            std::cerr << "[E4] Fehler im E4-XML-Block: " << e.what() << ".\n";
            if (e4_overall_rc == 0) e4_overall_rc = 1;
        }
    }

    // P6/#229: E4-XML ist der Alleinweg — nach dem XML-Lauf ist der Gesamtablauf fertig. Der Legacy-
    // ExperimentDriver-Pfad (3 Messreihen via config_a/b/c) laeuft NUR bei explizitem Opt-in
    // (COMDARE_LEGACY_MESSREIHEN=1), solange die E4-XML-Subsumtion der 3 Messreihen im golden-320-Voll-Lauf
    // noch nicht bestaetigt ist. Default: E4-XML allein.
    if (env_trimmed("COMDARE_LEGACY_MESSREIHEN") != "1") return e4_overall_rc;
#endif

    // REV 7.6 V9.6 — Externe Messreihen-Spec (defined/full Mode)
    auto external_specs = load_messreihen(messreihen_xml);
    if (!external_specs.empty()) {
        std::cout << "[V9.6] Geladen aus " << messreihen_xml.string() << ": " << external_specs.size()
                  << " Messreihe(n).\n";
        for (auto const& s : external_specs) {
            std::cout << "  - " << s.id << " (mode=" << s.mode << ", profiles=" << s.sota_profiles.size() << ")\n";
        }

        // REV 7.6 V11.3 — Pro Messreihen-Spec einen ExperimentDriver-Lauf
        int         spec_overall_rc = 0;
        std::size_t spec_idx        = 0;
        for (auto const& spec : external_specs) {
            std::cout << "─────────────────────────────────────────────\n";
            std::cout << "[Reihe " << (++spec_idx) << "/" << external_specs.size() << "] [V11.3] Messreihe " << spec.id
                      << " (mode=" << spec.mode << ")\n";
            std::cout << "─────────────────────────────────────────────\n";

            cb::ExperimentDriverOptions opts;
            opts.config_dir          = config_dir;
            opts.output_dir          = output_dir / spec.id;
            opts.comdare_root        = comdare_root;
            opts.messreihen_mode     = (spec.mode == "full") ? cb::ExperimentDriverOptions::MessreihenMode::Full
                                                             : cb::ExperimentDriverOptions::MessreihenMode::Defined;
            opts.sota_profile_filter = spec.sota_profiles;

            cb::ExperimentDriver driver{opts};
            cb::WorkloadOptions  w; // Default-Workload (V11.2 routet pro Profil)
            w.config.random_seed      = 42;
            w.config.key_size_bytes   = 16;
            w.config.value_size_bytes = 64;
            w.config.num_keys         = 1000000;
            w.config.num_operations   = 5000000;
            w.config.zipfian_theta    = 0.99;
            // #31: Workload aus <workload> je <messreihe> (E4-XML); fehlt das Tag -> heutiger Default (C).
            w.workload = spec.workload.value_or(wg::YcsbWorkload::C);
            if (spec.workload) {
                std::cout << "[V11.3] Spec " << spec.id << " workload aus XML: YCSB_"
                          << static_cast<char>('A' + static_cast<int>(*spec.workload)) << "\n";
            }

            int rc = driver.run_pipeline_full(w);
            if (rc != cb::status_ok) {
                std::cerr << "[V11.3] Spec " << spec.id << " FAILED (status=" << rc << ")\n";
                spec_overall_rc = rc;
            } else {
                std::cout << "[V11.3] Spec " << spec.id << " OK -> " << opts.output_dir.string() << "\n\n";
            }
        }

        std::cout << "==== V11.3 Spec-Lauf ";
        std::cout << (spec_overall_rc == 0 ? "(OK)" : "(MIT FEHLERN)");
        std::cout << " ====\n";
        return spec_overall_rc != 0 ? spec_overall_rc : e4_overall_rc; // Bei Spec-Mode kein 3-Reihen-Fallback
    }

    constexpr std::array<MessreiheKind, 3> kinds{MessreiheKind::A_PrtArtVsSota, MessreiheKind::B_CacheEnginePerm,
                                                 MessreiheKind::C_MergeAltNeu};

    int         overall_rc = 0;
    std::size_t reihe_idx  = 0;
    for (auto kind : kinds) {
        std::cout << "─────────────────────────────────────────────\n";
        std::cout << "[Reihe " << (++reihe_idx) << "/" << kinds.size() << "] Messreihe " << messreihe_name(kind)
                  << "\n";
        std::cout << "─────────────────────────────────────────────\n";

        auto const reihe_output = output_dir / subdir_for(kind);

        cb::ExperimentDriverOptions opts;
        opts.config_dir   = config_dir;
        opts.output_dir   = reihe_output;
        opts.comdare_root = comdare_root;

        cb::ExperimentDriver driver{opts};
        cb::WorkloadOptions  w = default_workload_for(kind);

        int rc = driver.run_pipeline_full(w);
        if (rc != cb::status_ok) {
            std::cerr << "Messreihe " << messreihe_name(kind) << " FAILED (status=" << rc << ")\n";
            overall_rc = rc;
            continue;
        }
        std::cout << "Messreihe " << messreihe_name(kind) << " OK -> " << (reihe_output / "measurements.csv").string()
                  << "\n\n";
    }

    std::cout << "==== Messung-Driver komplett ";
    std::cout << (overall_rc == 0 ? "(OK)" : "(MIT FEHLERN)");
    std::cout << " ====\n";
    std::cout << "[NAECHSTER SCHRITT] binary_to_csv -> csv_to_latex -> diagram_generator -> latex_to_pdf\n";
    return overall_rc != 0 ? overall_rc : e4_overall_rc;
}
