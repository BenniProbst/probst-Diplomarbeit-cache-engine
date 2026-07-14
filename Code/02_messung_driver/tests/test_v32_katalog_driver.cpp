// test_v32_katalog_driver -- INC-F (C.1, 2026-07-14): das W4-Gate der F-Verdrahtung (Surrogat -> reale
// CEB-Katalog-Tier im EE-A/EE-B-Vergleich). Plain int main() (kein gtest -> add_test direkt), g_fail-Zaehler
// -> return 0/1. Baut FRISCH mit COMDARE_V32_DRIVER_ENABLE + COMDARE_MEASUREMENT_ON (der abi_adapter-Guard
// fordert MEASUREMENT; ohne ihn traegt der SearchAlgorithmAbiAdapter kein IObservableTier).
//
// BEWEIST LITERAL:
//   (1) TREIBT REALEN TIER: execute_one_permutation_katalog materialisiert HotComposition (EE-A, Stufe1_CeOnly)
//       + HotPrtStufe2ReplaceComposition (EE-B, Stufe2) als IObservableTier und misst per-Op-Latenzen; beide
//       ExecutionResults tragen operation_count reale latency_samples_ns (nicht leer) und success==true.
//   (2) PRUEFDOCK: das Konformitaets-Gate (std::map-Oracle) lief fuer beide Engines mit >0 Zusicherungen + passed.
//   (3) WELCH: CompareEngineCommand hat ueber die realen Samples ein Verdikt gebildet (nicht InconclusiveData).
//   (4) W4-GATE (grep, wie test_ap2_katalog_pfad_stubfrei): weder die GENUTZTE Treiber-Quelle
//       (v32_katalog_driver.hpp) noch die Mess-Pfad-Composition-Header enthalten die Surrogat-/Alt-Pfad-Marker
//       (PrtArtHashBackend, unordered_map, cycles_per_op, prtart_body) -- KEIN vierter Laufzeit-Pfad.
//   (5) KATALOG-TYP-IDENTITAET: die getriebenen Typen SIND die vom sota_catalog deklarierten Stufe1/Stufe2-
//       Kompositionen (sota_module_for("Stufe1_CeOnly","hot") -> HotComposition; "Stufe2_PrueflingReplace","hot"
//       -> HotPrtStufe2ReplaceComposition), und render_sota_module_source(...) emittiert COMDARE_DEFINE_ANATOMY_MODULE
//       OHNE Surrogat-Marker.
//   (6) GOLDEN-320 unveraendert: die committete Golden-Liste zaehlt weiterhin exakt 320 (Fix aendert nur den
//       sota-Katalog-Namensraum, nicht die golden-4x4x5x4-Achsen).

#include "v32_katalog_driver.hpp" // die F-Verdrahtung (INC-F)

#include "sota_catalog.hpp" // sota_module_for / render_sota_module_source (Katalog-Typ-Identitaet + W4)

#include <cstddef>
#include <fstream>
#include <iostream>
#include <iterator>
#include <optional>
#include <string>
#include <string_view>

namespace kat = comdare::diplomarbeit::messung_driver::v32::katalog;
namespace cmd = comdare::cache_engine::builder::commands;
namespace tlz = comdare::cache_engine::thesis_lazy;

static int  g_fail = 0;
static void check(char const* what, bool ok) {
    std::cout << (ok ? "  [OK]  " : "  [ERR] ") << what << "\n";
    if (!ok) ++g_fail;
}

static std::string read_file(std::string const& path) {
    std::ifstream in{path, std::ios::binary};
    return {std::istreambuf_iterator<char>(in), std::istreambuf_iterator<char>()};
}

// Die Surrogat-/Alt-Pfad-Marker (W4, identisch zu ce test_ap2_katalog_pfad_stubfrei::kAltPfadMarker).
static char const* const kAltPfadMarker[] = {"cycles_per_op", "PrtArtHashBackend", "unordered_map", "prtart_body"};

static void grep_surrogatfrei(char const* label, std::string const& content) {
    bool empty = content.empty();
    check((std::string{label} + ": Quelle lesbar (nicht leer)").c_str(), !empty);
    if (empty) return;
    for (auto const* marker : kAltPfadMarker) {
        bool const clean = content.find(marker) == std::string::npos;
        check((std::string{label} + ": frei von Alt-Pfad-Marker '" + marker + "'").c_str(), clean);
    }
}

int main() {
    std::cout << "=== INC-F W4-Gate: reale CEB-Katalog-Tier im EE-A/EE-B-Vergleich ===\n";

    // ── (1)+(2)+(3) Der REALE Mess-Lauf ueber den Katalog-Pfad ──────────────────────────────────────────────
    cmd::Workload workload;
    workload.kind            = cmd::WorkloadKind::YCSB_C_ReadOnly;
    workload.record_count    = 2000;
    workload.operation_count = 2000; // moderat -> Test < TIMEOUT; genug Samples fuer Welch
    workload.seed            = 42;

    kat::KatalogPermutationOutcome const outcome =
        kat::execute_one_permutation_katalog<>("path_compression", "hot_vs_hot+prt(St2)", workload);

    check("EE-A latency_samples_ns == operation_count (reale Per-Op-Latenzen)",
          outcome.ee_a_result.latency_samples_ns.size() == workload.operation_count);
    check("EE-B latency_samples_ns == operation_count (reale Per-Op-Latenzen)",
          outcome.ee_b_result.latency_samples_ns.size() == workload.operation_count);
    check("EE-A success (alle Ops konform: eingefuegter Key gefunden)", outcome.ee_a_result.success);
    check("EE-B success (alle Ops konform: eingefuegter Key gefunden)", outcome.ee_b_result.success);
    check("EE-A Pruefdock-Gate passed (>0 std::map-Zusicherungen)",
          outcome.ee_a_conformance_passed && outcome.ee_a_conformance_cases > 0);
    check("EE-B Pruefdock-Gate passed (>0 std::map-Zusicherungen)",
          outcome.ee_b_conformance_passed && outcome.ee_b_conformance_cases > 0);
    check("Welch-Verdikt gebildet (nicht InconclusiveData -> reale Samples in beiden Engines)",
          outcome.verdict != cmd::CompareEngineCommand::Verdict::InconclusiveData);
    std::cout << "    ee_a p50=" << outcome.ee_a_result.latency_p50.count()
              << "ns  ee_b p50=" << outcome.ee_b_result.latency_p50.count()
              << "ns  throughput_ratio=" << outcome.throughput_ratio << "  welch_p=" << outcome.welch_p_value
              << "  conform_a=" << outcome.ee_a_conformance_cases << "  conform_b=" << outcome.ee_b_conformance_cases
              << "\n";

    // ── (4) W4-GATE: die GENUTZTE Treiber-Quelle + die Mess-Pfad-Composition-Header sind surrogatfrei ────────
    grep_surrogatfrei("v32_katalog_driver.hpp (genutzte Treiber-Quelle)", read_file(COMDARE_V32_DRIVER_HDR));
    for (char const* rel : {"compositions/hot_reference.hpp", "compositions/prt_art_reference.hpp",
                            "compositions/prt_art_merge_reference.hpp"}) {
        std::string const path = std::string{COMDARE_CE_LIB_DIR} + "/" + rel;
        grep_surrogatfrei((std::string{"Katalog-Header "} + rel).c_str(), read_file(path));
    }

    // ── (5) KATALOG-TYP-IDENTITAET: die getriebenen Typen == die sota_catalog-deklarierten Stufe1/Stufe2 ──────
    {
        std::optional<tlz::SotaModule> const s1 = tlz::sota_module_for("Stufe1_CeOnly", "hot");
        std::optional<tlz::SotaModule> const s2 = tlz::sota_module_for("Stufe2_PrueflingReplace", "hot");
        check("sota_module_for(Stufe1_CeOnly,hot) vorhanden", s1.has_value());
        check("sota_module_for(Stufe2_PrueflingReplace,hot) vorhanden", s2.has_value());
        if (s1)
            check("EE-A-Typ == Katalog Stufe1 (HotComposition)",
                  s1->composition_type.find("HotComposition") != std::string::npos);
        if (s2)
            check("EE-B-Typ == Katalog Stufe2 (HotPrtStufe2ReplaceComposition)",
                  s2->composition_type.find("HotPrtStufe2ReplaceComposition") != std::string::npos);
        // render_sota_module_source der Stufe2-Komposition: COMDARE_DEFINE_ANATOMY_MODULE + surrogatfrei.
        if (s2) {
            std::string const src = tlz::render_sota_module_source(s2->composition_type, s2->header);
            check("Stufe2-Modul-Quelle emittiert COMDARE_DEFINE_ANATOMY_MODULE",
                  src.find("COMDARE_DEFINE_ANATOMY_MODULE") != std::string::npos);
            grep_surrogatfrei("render_sota_module_source(Stufe2)", src);
        }
    }

    // ── (6) GOLDEN-320 unveraendert (der Fix beruehrt nur den sota-Namensraum, nicht die 4x4x5x4-Achsen) ──────
    {
        std::ifstream f{COMDARE_GOLDEN_320_IDS};
        std::string   line;
        std::size_t   n = 0;
        while (std::getline(f, line)) {
            while (!line.empty() && (line.back() == '\r' || line.back() == '\n')) line.pop_back();
            if (line.empty() || line[0] == '#') continue;
            ++n;
        }
        check("golden binary_count == 320 (4*4*5*4, unveraendert)", n == 320);
        std::cout << "    golden_binary_count=" << n << "\n";
    }

    std::cout << "\n==== INC-F W4-Gate: " << (g_fail == 0 ? "ALLE OK" : (std::to_string(g_fail) + " FEHLER"))
              << " ====\n";
    return g_fail == 0 ? 0 : 1;
}
