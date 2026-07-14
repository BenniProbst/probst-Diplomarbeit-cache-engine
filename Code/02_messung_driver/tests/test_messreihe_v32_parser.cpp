// INC-V32-C.parser (2026-07-14) — Unit-Test der typisierten XML->Struct-Parse-Schicht fuer das
// allgemeine Experiment-Interface `<messreihe version="32">`. Gate-frei: reine Host-Logik ueber den
// ce-DOM-Reader auf der gelieferten Beispiel-Instanz (kein Treiber-Lauf, kein #156-Messdaten).
//
// Beweist, dass der Parser Attribut- UND verschachtelte Element-WERTE liest (der Praesenz-Validator
// liest heute keines) — wortwoertlich gegen messreihe_v32_schema_example.xml.

#include "messreihe_v32_parser.hpp"
#include "messreihe_v32_validator.hpp"

#include <cstdio>
#include <filesystem>
#include <optional>
#include <string>

namespace v32 = comdare::diplomarbeit::messung_driver::v32;

static int  g_fail = 0;
static void check(bool ok, char const* msg) {
    std::printf("  [%s] %s\n", ok ? "OK" : "FAIL", msg);
    if (!ok) ++g_fail;
}

int main() {
    // Beispiel-XML lokalisieren: erst relativer Pfad (manueller Start im Code/-Root), dann
    // deterministischer Source-Dir-Fallback (CMake-einkompiliert) — Muster wie test_messreihe_v32_validator.
    std::string xml_path = "test_data_xml/messreihe_v32_schema_example.xml";
    if (!std::filesystem::exists(xml_path)) {
#ifdef COMDARE_V32_EXAMPLE_XML
        xml_path = COMDARE_V32_EXAMPLE_XML;
#endif
    }
    check(std::filesystem::exists(xml_path), "Beispiel-XML gefunden");

    std::string err;
    auto        parsed = v32::parse_messreihe_v32(xml_path, &err);
    check(parsed.has_value(), "parse_messreihe_v32 ok (ce-DOM-Reader)");
    if (!parsed) {
        std::printf("  parse error: %s\n", err.c_str());
        std::printf("INC-V32-C.parser: %d FAIL\n", g_fail == 0 ? 1 : g_fail);
        return 1;
    }
    auto const& m = *parsed;

    // ── Wurzel + Metadata ──
    check(m.version == "32", "version == '32'");
    check(m.metadata.name == "example_messreihe_v32", "metadata.name wortwoertlich");
    check(m.metadata.mode == "defined", "metadata.mode == 'defined'");
    check(!m.metadata.description.empty(), "metadata.description gelesen (nicht leer)");

    // ── ExecutionEngines: genau 2, EE-A/EE-B mit Namen ──
    check(m.engines.size() == 2, "genau 2 <engine>");
    if (m.engines.size() == 2) {
        check(m.engines[0].id == "ee_a", "engines[0].id == 'ee_a'");
        check(m.engines[0].type == "CacheEngineExecutionEngineAdapter", "engines[0].type wortwoertlich");
        check(m.engines[0].name == "CE-Pure-SOTA-Baseline", "engines[0].name wortwoertlich");
        check(m.engines[1].id == "ee_b", "engines[1].id == 'ee_b'");
        check(m.engines[1].type == "PrtArtExecutionEngineAdapter", "engines[1].type wortwoertlich");
        check(m.engines[1].name == "PrtArt-mit-Innovationen", "engines[1].name wortwoertlich");
    }

    // ── axes_default_lookup: enabled + allowed_variants-Liste ──
    check(m.default_lookup.present, "axes_default_lookup vorhanden");
    check(m.default_lookup.enabled, "axes_default_lookup enabled == true");
    check(m.default_lookup.axes.size() == 2, "2 default-lookup <axis>");
    if (m.default_lookup.axes.size() == 2) {
        check(m.default_lookup.axes[0].id == "12.1", "default axis[0].id == '12.1'");
        check(m.default_lookup.axes[0].allowed_variants == "AVX2,scalar", "default axis[0].allowed_variants roh");
        check(m.default_lookup.axes[1].id == "12.2", "default axis[1].id == '12.2'");
        check(m.default_lookup.axes[1].allowed_variants == "L1Aware,L2Aware", "default axis[1].allowed_variants roh");
    }

    // ── Tupel: >=1, workload + op_type + geschachtelte Werte + axes[] ──
    check(m.tupel.size() == 3, "3 <tupel> (t01/t02/t03_scan)");
    if (m.tupel.size() == 3) {
        auto const& t01 = m.tupel[0];
        check(t01.id == "t01", "tupel[0].id == 't01'");
        check(t01.has_workload, "tupel[0] hat <workload>");
        check(t01.workload.kind == "YCSB_C_ReadOnly", "t01 workload.kind wortwoertlich");
        check(t01.workload.record_count == 1000000ULL, "t01 workload.record_count == 1000000 (typisiert)");
        check(t01.workload.operation_count == 100000ULL, "t01 workload.operation_count == 100000 (typisiert)");
        check(t01.workload.seed == 42ULL, "t01 workload.seed == 42 (typisiert)");
        check(t01.op_type == "OP-1", "t01 op_type == 'OP-1'");
        check(t01.hardware_strategy.has_value(), "t01 hardware_strategy vorhanden");
        if (t01.hardware_strategy) {
            check(t01.hardware_strategy->simd == "AVX2", "t01 hardware.simd == 'AVX2' (geschachteltes Element)");
            check(t01.hardware_strategy->cache_level == "L1Aware", "t01 hardware.cache_level == 'L1Aware'");
            check(t01.hardware_strategy->numa == "Local", "t01 hardware.numa == 'Local'");
        }
        check(t01.scheduling_strategy.has_value(), "t01 scheduling_strategy vorhanden");
        if (t01.scheduling_strategy) {
            check(t01.scheduling_strategy->worker_pool == "ThreadPerCore", "t01 scheduling.worker_pool wortwoertlich");
            check(t01.scheduling_strategy->simd_workers == "2", "t01 scheduling.simd_workers == '2'");
            check(t01.scheduling_strategy->heterogeneous_awareness == "HybridAware",
                  "t01 scheduling.hetero wortwoertlich");
        }
        check(t01.axes.size() == 2, "t01 hat 2 <axis>");
        if (t01.axes.size() == 2) {
            check(t01.axes[0].id == "1" && t01.axes[0].baustein == "PAGE_PRTART_DENSEBYTE",
                  "t01 axes[0] id=1 baustein=PAGE_PRTART_DENSEBYTE");
            check(t01.axes[1].id == "7" && t01.axes[1].baustein == "DISTANCE_ESTIMATOR_PREFETCH",
                  "t01 axes[1] id=7 baustein=DISTANCE_ESTIMATOR_PREFETCH");
        }

        // t02: nur workload + op_type, KEIN hardware/scheduling/axes (Default-Lookup-Pfad)
        auto const& t02 = m.tupel[1];
        check(t02.id == "t02", "tupel[1].id == 't02'");
        check(t02.op_type == "OP-3", "t02 op_type == 'OP-3'");
        check(!t02.hardware_strategy.has_value(), "t02 hat KEINE hardware_strategy (optional -> nullopt)");
        check(t02.axes.empty(), "t02 hat KEINE expliziten axes");

        // t03_scan: compiler_strategy (Achse 15) geschachtelt
        auto const& t03 = m.tupel[2];
        check(t03.id == "t03_scan", "tupel[2].id == 't03_scan'");
        check(t03.compiler_strategy.has_value(), "t03 compiler_strategy vorhanden");
        if (t03.compiler_strategy) {
            check(t03.compiler_strategy->family == "Clang", "t03 compiler.family == 'Clang'");
            check(t03.compiler_strategy->opt_level == "O3", "t03 compiler.opt_level == 'O3'");
            check(t03.compiler_strategy->lto == "ThinLTO", "t03 compiler.lto == 'ThinLTO'");
            check(t03.compiler_strategy->target_arch == "x86-64-v4", "t03 compiler.target_arch wortwoertlich");
        }
    }

    // ── Output: comparison_metrics gelesen == true ──
    check(m.output.binary_path.find("results.bin") != std::string::npos, "output.binary_path gelesen");
    check(m.output.has_comparison_metrics, "output.comparison_metrics vorhanden (gelesen)");
    check(m.output.comparison_metrics == true, "output.comparison_metrics == true");

    // ── Validator-Wiring: typisierte Validierung ueber die geparsten Felder ──
    auto report = v32::MessreiheV32Validator::validate_parsed(m);
    check(report.valid, "MessreiheV32Validator::validate_parsed(m) -> valid");
    check(!report.has_errors(), "validate_parsed: keine Errors");

    // Negativ: kaputtes op_type wird vom typisierten Validator (nicht vom string-find) gefangen.
    {
        auto bad             = m;
        bad.tupel[0].op_type = "OP-9"; // nicht in OP-1..OP-6
        auto rep2            = v32::MessreiheV32Validator::validate_parsed(bad);
        check(!rep2.valid, "validate_parsed faengt ungueltiges op_type 'OP-9'");
    }

    std::printf(g_fail == 0 ? "INC-V32-C.parser: ALLE OK\n" : "INC-V32-C.parser: %d FAIL\n", g_fail);
    return g_fail == 0 ? 0 : 1;
}
