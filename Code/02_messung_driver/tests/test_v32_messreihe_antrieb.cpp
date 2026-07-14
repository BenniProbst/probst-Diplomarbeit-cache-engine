// test_v32_messreihe_antrieb -- INC-G (C.2) + INC-H (C.3), 2026-07-14: das Flag-ON-Gate der
// execute_messreihe-Verdrahtung (parse -> validate -> Phasen-Strategy -> INC-F-Katalog-Treiber -> Report ->
// Export). Plain int main() (kein gtest -> add_test direkt), g_fail-Zaehler -> return 0/1. Baut FRISCH mit
// COMDARE_V32_DRIVER_ENABLE + COMDARE_MEASUREMENT_ON (der abi_adapter-Guard fordert MEASUREMENT, sonst traegt
// der SearchAlgorithmAbiAdapter kein IObservableTier).
//
// BEWEIST LITERAL:
//   (1) ANTRIEB: run_experiment_profile(experiment_golden.xml, defined) treibt je der 3 Golden-Phasen den
//       REALEN Katalog-Tier (Stufe1_CeOnly / Stufe2_PrueflingReplace / Stufe3_FullJoin) -> MessreiheReport mit
//       genau 3 Permutationen (defined = 1 OP-Typ je Phase), jede mit realen Per-Op-Latenzen (== operation_count),
//       success und einem gebildeten Welch-Verdikt (nicht InconclusiveData).
//   (2) EXPORT: execute_messreihe(experiment_golden.xml, defined) == 0 und erzeugt CSV + TikZ nach den
//       <output>-Pfaden der Experiment-XML; die CSV traegt den 12-Spalten-Header, die TikZ-Datei die
//       tikzpicture-Umgebung.
//   (3) W4-GATE (grep): die GENUTZTE Antriebs-Quelle (v32_messreihe_antrieb.hpp) und die INC-F-Treiber-Quelle
//       (v32_katalog_driver.hpp) enthalten KEINEN der vier Alt-Pfad-Marker (cycles_per_op / PrtArtHashBackend /
//       unordered_map / prtart_body) -> kein Surrogat im Mess-Pfad.
//   (4) GOLDEN-320 unveraendert: die committete Golden-Liste zaehlt weiterhin exakt 320.

#include "v32_messreihe_antrieb.hpp" // die INC-G+H-Verdrahtung

#include <chrono>
#include <cstddef>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <iterator>
#include <optional>
#include <string>
#include <string_view>

namespace ant = comdare::diplomarbeit::messung_driver::v32::antrieb;
namespace v32 = comdare::diplomarbeit::messung_driver::v32;
namespace cmd = comdare::cache_engine::builder::commands;
namespace cx  = comdare::builder::xml;
namespace fs  = std::filesystem;

static int  g_fail = 0;
static void check(char const* what, bool ok) {
    std::cout << (ok ? "  [OK]  " : "  [ERR] ") << what << "\n";
    if (!ok) { ++g_fail; }
}

static std::string read_file(std::string const& path) {
    std::ifstream in{path, std::ios::binary};
    return {std::istreambuf_iterator<char>(in), std::istreambuf_iterator<char>()};
}

// Die vier Surrogat-/Alt-Pfad-Marker (W4, identisch zu test_v32_katalog_driver::kAltPfadMarker).
static char const* const kAltPfadMarker[] = {"cycles_per_op", "PrtArtHashBackend", "unordered_map", "prtart_body"};

static void grep_surrogatfrei(char const* label, std::string const& content) {
    bool const empty = content.empty();
    check((std::string{label} + ": Quelle lesbar (nicht leer)").c_str(), !empty);
    if (empty) { return; }
    for (auto const* marker : kAltPfadMarker) {
        bool const clean = content.find(marker) == std::string::npos;
        check((std::string{label} + ": frei von Alt-Pfad-Marker '" + marker + "'").c_str(), clean);
    }
}

// Rekursive Suche nach einer Datei mit dem gegebenen Basename unterhalb von root (fuer den ${date}-Pfad).
static std::optional<fs::path> find_under(fs::path const& root, std::string const& basename) {
    if (!fs::exists(root)) { return std::nullopt; }
    for (auto const& e : fs::recursive_directory_iterator(root)) {
        if (e.is_regular_file() && e.path().filename() == basename) { return e.path(); }
    }
    return std::nullopt;
}

int main() {
    std::cout << "=== INC-G+H Flag-ON: execute_messreihe-Antrieb + Export (W4-Gate) ===\n";

    std::string const golden_xml = COMDARE_V32_EXPERIMENT_GOLDEN_XML;

    // ── (1) ANTRIEB: parse -> run_experiment_profile(defined) treibt die 3 realen Phasen ────────────────────
    cx::XmlConfigParser const parser;
    auto const                profile = parser.parse_experiment_profile(fs::path{golden_xml});
    check("experiment_golden.xml parst in ExperimentProfile", profile.has_value());
    if (profile) {
        v32::MessreiheReport const report = ant::run_experiment_profile(*profile, ant::EnumerationMode::Defined);
        check("defined-Mode: genau 3 Permutationen (1 OP-Typ je der 3 Golden-Phasen)", report.outcomes.size() == 3);
        check("total_axes == 3 (3 Phasen)", report.total_axes == 3);

        // Je erwartete Phase (== merge-Name) genau 1 Outcome mit realem Tier-Antrieb + gebildetem Verdikt.
        for (char const* merge : {"Stufe1_CeOnly", "Stufe2_PrueflingReplace", "Stufe3_FullJoin"}) {
            v32::PermutationOutcome const* found = nullptr;
            for (auto const& o : report.outcomes) {
                if (o.axis_id == merge) { found = &o; }
            }
            check((std::string{"Phase '"} + merge + "' im Report vorhanden").c_str(), found != nullptr);
            if (!found) { continue; }
            check((std::string{merge} + ": EE-A reale Per-Op-Latenzen (== operation_count 2000)").c_str(),
                  found->ee_a_result.latency_samples_ns.size() == 2000);
            check((std::string{merge} + ": EE-B reale Per-Op-Latenzen (== operation_count 2000)").c_str(),
                  found->ee_b_result.latency_samples_ns.size() == 2000);
            check((std::string{merge} + ": EE-A success (alle Ops konform)").c_str(), found->ee_a_result.success);
            check((std::string{merge} + ": EE-B success (alle Ops konform)").c_str(), found->ee_b_result.success);
            check((std::string{merge} + ": Welch-Verdikt gebildet (nicht InconclusiveData)").c_str(),
                  found->verdict != cmd::CompareEngineCommand::Verdict::InconclusiveData);
            std::cout << "    " << merge << ": ee_a_p50=" << found->ee_a_result.latency_p50.count()
                      << "ns ee_b_p50=" << found->ee_b_result.latency_p50.count()
                      << "ns throughput_ratio=" << found->throughput_ratio << " welch_p=" << found->welch_p_value
                      << " variant=" << found->variant_name << "\n";
        }
    }

    // ── (2) EXPORT: execute_messreihe treibt + exportiert CSV + TikZ nach den <output>-Pfaden ────────────────
    {
        fs::path const  orig_cwd = fs::current_path();
        std::error_code ec;
        auto const uniq = static_cast<unsigned long long>(std::chrono::steady_clock::now().time_since_epoch().count());
        fs::path const tmp = fs::temp_directory_path() / ("inc_gh_export_" + std::to_string(uniq));
        fs::remove_all(tmp, ec);
        fs::create_directories(tmp, ec);
        fs::current_path(tmp, ec); // die Golden-<output>-Pfade sind relativ (_runs/${date}/...) -> unter tmp

        int const rc = ant::execute_messreihe(golden_xml, "defined");
        check("execute_messreihe(golden, defined) == 0", rc == 0);

        auto const csv = find_under(tmp, "results.csv");
        auto const tex = find_under(tmp, "results.tex");
        check("CSV-Datei erzeugt (results.csv unter <output>)", csv.has_value());
        check("TikZ-Datei erzeugt (results.tex unter <output>)", tex.has_value());
        if (csv) {
            std::ifstream in{*csv};
            std::string   header;
            std::getline(in, header);
            check("CSV 12-Spalten-Header korrekt", header ==
                                                       "axis_id,variant_name,verdict,welch_p_value,throughput_ratio,"
                                                       "ee_a_engine,ee_a_throughput,ee_a_p99_ns,ee_a_cache_misses,"
                                                       "ee_b_engine,ee_b_throughput,ee_b_p99_ns");
            std::size_t rows = 0;
            for (std::string line; std::getline(in, line);) {
                if (!line.empty()) { ++rows; }
            }
            check("CSV traegt 3 Daten-Zeilen (1 je Phase)", rows == 3);
        }
        if (tex) {
            std::string const t = read_file(tex->string());
            check("TikZ traegt \\begin{tikzpicture}", t.find("\\begin{tikzpicture}") != std::string::npos);
        }

        fs::current_path(orig_cwd, ec);
        fs::remove_all(tmp, ec);
    }

    // ── (3) W4-GATE (grep): die Antriebs- + Treiber-Quelle sind surrogatfrei ─────────────────────────────────
    grep_surrogatfrei("v32_messreihe_antrieb.hpp (genutzte Antriebs-Quelle)", read_file(COMDARE_V32_ANTRIEB_HDR));
    grep_surrogatfrei("v32_katalog_driver.hpp (INC-F-Treiber-Quelle)", read_file(COMDARE_V32_DRIVER_HDR));

    // ── (4) GOLDEN-320 unveraendert ─────────────────────────────────────────────────────────────────────────
    {
        std::ifstream f{COMDARE_GOLDEN_320_IDS};
        std::string   line;
        std::size_t   n = 0;
        while (std::getline(f, line)) {
            while (!line.empty() && (line.back() == '\r' || line.back() == '\n')) { line.pop_back(); }
            if (line.empty() || line[0] == '#') { continue; }
            ++n;
        }
        check("golden binary_count == 320 (unveraendert, Flag-ON)", n == 320);
        std::cout << "    golden_binary_count=" << n << "\n";
    }

    std::cout << "\n==== INC-G+H Flag-ON: " << (g_fail == 0 ? "ALLE OK" : (std::to_string(g_fail) + " FEHLER"))
              << " ====\n";
    return g_fail == 0 ? 0 : 1;
}
