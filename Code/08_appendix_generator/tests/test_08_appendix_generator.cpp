// Increment 1 (2026-07) — Regressions-Test Pipeline-Stufe 08 (appendix_generator).
//
// BEWEIS: der In-Process-Orchestrator generate_wide_appendix() ersetzt die 8 .exe-
// Spawns des PowerShell-Behelfswegs generate_wide_appendix.ps1 EXAKT. Dazu:
//   Pfad A: generate_wide_appendix(cfg)                         -> temp-outdir A
//   Pfad B: die äquivalenten Einzel-Writer, in-process nachgestellt (= die früheren
//           csv-to-latex.exe / diagram-generator.exe-Aufrufe) -> temp-outdir B
// und assertet, dass JEDE erzeugte .tex byte-identisch zwischen A und B ist.

#include "appendix_generator.hpp"
#include "csv_to_latex.hpp"
#include "diagram_generator.hpp"

#include <gtest/gtest.h>

#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <string>
#include <unistd.h>
#include <vector>

namespace ag  = comdare::da::appendix_generator;
namespace c2l = comdare::da::csv_to_latex;
namespace dg  = comdare::da::diagram_generator;
namespace fs  = std::filesystem;

namespace {

// Benutzer-eindeutige tmp-Basis (prod1: /tmp host-weit geteilt zwischen comdare/gitlab-runner).
fs::path comdare_user_tmp() {
    auto p = fs::temp_directory_path() / ("comdare_test_" + std::to_string(::getuid()));
    fs::create_directories(p);
    return p;
}

fs::path fixtures_dir() {
    if (auto* env = std::getenv("COMDARE_FIXTURES_DIR_08"); env != nullptr) { return fs::path(env); }
#ifdef COMDARE_FIXTURES_DIR_08_FALLBACK
    return fs::path(COMDARE_FIXTURES_DIR_08_FALLBACK);
#else
    return fs::current_path() / "fixtures" / "cached";
#endif
}

// M-4 (2026-07-19): die seg_*_ns-Spaltennamen kommen aus dg::kSegmentColumns (Header-Konstante, ihrerseits
// compile-time aus der CE-Single-Source kCompositionAxisNames gepraegt) — hier KEINE Literal-Liste mehr
// (war 20er-Drift inkl. seg_telemetry_ns/seg_isa_ns, B16). Reihenfolge = 17 Organ-Achsen + seg_framework_ns.
constexpr std::size_t kSegN = dg::WideMeasurementRow::kSegmentCount; // 17 Organ + framework = 18
// Summe 1+2+...+kSegN fuer die seg_run_total_ns-Bildung (kSegN=18 -> 171).
constexpr long kSegTriangleSum = static_cast<long>(kSegN) * static_cast<long>(kSegN + 1) / 2;

std::string seg_header() {
    std::string h;
    for (auto const col : dg::kSegmentColumns) {
        if (!h.empty()) h += ';';
        h += std::string{col};
    }
    return h;
}

// kSegN deterministische seg-Werte seg_mult*(i+1) → ';'-Block. Σ_{i=1}^{kSegN} i = kSegTriangleSum → Σ ==
// seg_mult*kSegTriangleSum == seg_run_total_ns (seg_coverage=1.0 → kommensurabel; die Segment-Attribution
// stapelt gegen das 100%-Ganze).
std::string seg_values(int seg_mult) {
    std::string s;
    for (std::size_t i = 0; i < kSegN; ++i) {
        if (i) s += ';';
        s += std::to_string(seg_mult * static_cast<long>(i + 1)) + ".0";
    }
    return s;
}

// Selbstheilende Regeneration der WIDE-Fixture (schema-treu zu allen drei Parsern:
// 04::parse_wide_csv [bias], 05::parse_wide_csv [surface], 04::parse_wide_csv_full
// [exchange]) UND — Inc-2a — zu den 4 additiven Darstellungs-Writern: die 5 op_*_p99_ns
// (Latenz-Range/-ECDF) + die kSegN seg_*_ns + seg_run_total_ns + seg_coverage (Segment-
// Attribution) sind additiv/header-getrieben angehängt. Werte gewählt, dass KEIN neuer
// Writer honest-empty ist (sonst würde der Byte-Identitäts-Test die 4 neuen .tex nicht
// prüfen). Nur schreiben, wenn die committete Datei fehlt (sonst = committed).
// M-4 (2026-07-19): committete Fixture auf das 17-Achsen-Schema regeneriert (seg_telemetry_ns/seg_isa_ns raus).
void ensure_fixture(fs::path const& p) {
    if (fs::exists(p)) return;
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    // Header: 12 Basis-Spalten (alle 3 Parser) + 5 op_*_p99_ns + kSegN seg_*_ns + seg_run_total_ns + seg_coverage.
    f << "binary_id;repetition;n_ops;total_ns;ns_per_op;workload;two_phase_valid;"
      << "op_insert_p50_ns;op_lookup_p50_ns;op_erase_p50_ns;op_scan_p50_ns;op_rmw_p50_ns;"
      << "op_insert_p99_ns;op_lookup_p99_ns;op_erase_p99_ns;op_scan_p99_ns;op_rmw_p99_ns;" << seg_header()
      << ";seg_run_total_ns;seg_coverage\n";
    // Eine Datenzeile: <binary_id>;<rep>;1000;<total_ns>;<ns_per_op>;<wl>;<two_phase>;<5 p50>;<5 p99>;<kSegN seg>;<run_total>;1.0
    // p99 = 2*p50 (monoton, keine p99<p50-Inversion). p50/ns_per_op/binary_id/workload/two_phase UNVERÄNDERT
    // gegenüber der Vor-Inc-2a-Fixture ⇒ bias/surface/exchange-Outputs bleiben byte-identisch.
    auto row = [&](std::string const& bid, int rep, long total_ns, std::string const& ns_per_op, std::string const& wl,
                   int two_phase, std::string const& p50_p99, int seg_mult) {
        f << bid << ';' << rep << ";1000;" << total_ns << ';' << ns_per_op << ';' << wl << ';' << two_phase << ';'
          << p50_p99 << ';' << seg_values(seg_mult) << ';' << (seg_mult * kSegTriangleSum) << ".0;1.0\n";
    };
    // seg_mult: k_ary=10 (Σ=1710), eytzinger=15 (Σ=2565) → 2 distinkte Balken der Segment-Attribution.
    row("search_algo=k_ary/node_type=node4/memory_layout=aos/prefetch=off", 0, 100000, "100.0", "ycsb_c", 1,
        "30.0;25.0;28.0;500.0;40.0;60.0;50.0;56.0;1000.0;80.0", 10);
    row("search_algo=k_ary/node_type=node4/memory_layout=aos/prefetch=off", 1, 110000, "110.0", "ycsb_c", 1,
        "31.0;26.0;29.0;510.0;41.0;62.0;52.0;58.0;1020.0;82.0", 10);
    row("search_algo=k_ary/node_type=node4/memory_layout=aos/prefetch=off", 2, 120000, "120.0", "ycsb_c", 1,
        "32.0;27.0;30.0;520.0;42.0;64.0;54.0;60.0;1040.0;84.0", 10);
    row("search_algo=k_ary/node_type=node4/memory_layout=aos/prefetch=off", 0, 200000, "200.0", "ycsb_a", 1,
        "60.0;50.0;55.0;900.0;70.0;120.0;100.0;110.0;1800.0;140.0", 10);
    row("search_algo=eytzinger/node_type=node4/memory_layout=aos/prefetch=off", 0, 150000, "150.0", "ycsb_c", 1,
        "35.0;20.0;31.0;600.0;45.0;70.0;40.0;62.0;1200.0;90.0", 15);
    // two_phase=0 → von ALLEN Aggregaten verworfen (Mess-Ungültigkeit); seg-Werte nur zur Spaltenbreiten-Treue.
    row("search_algo=eytzinger/node_type=node4/memory_layout=aos/prefetch=off", 1, 9999000, "9999.0", "ycsb_c", 0,
        "1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0", 10);
    row("search_algo=k_ary/node_type=node16/memory_layout=aos/prefetch=off", 0, 130000, "130.0", "ycsb_c", 1,
        "33.0;28.0;32.0;530.0;43.0;66.0;56.0;64.0;1060.0;86.0", 10);
    row("search_algo=k_ary/node_type=node4/memory_layout=soa/prefetch=off", 0, 90000, "90.0", "ycsb_c", 1,
        "28.0;22.0;25.0;480.0;38.0;56.0;44.0;50.0;960.0;76.0", 10);
    row("search_algo=k_ary/node_type=node4/memory_layout=aos/prefetch=on", 0, 95000, "95.0", "ycsb_c", 1,
        "29.0;23.0;26.0;490.0;39.0;58.0;46.0;52.0;980.0;78.0", 10);
}

std::string read_all(fs::path const& p) {
    std::ifstream in(p, std::ios::binary);
    return std::string((std::istreambuf_iterator<char>(in)), {});
}

// Referenz-Pfad B: die äquivalenten Einzel-Writer (= die früheren .exe-Spawns des
// .ps1), unabhängig vom Orchestrator nachgestellt — dieselbe Writer-Sequenz, die
// generate_wide_appendix intern kapselt. 0 = ok.
int run_individual_writers(fs::path const& csv, fs::path const& out_root, std::vector<std::string> const& langs,
                           std::string const& label) {
    std::vector<c2l::WideMeasurementRow> bias_rows;
    if (c2l::parse_wide_csv(csv, bias_rows) != c2l::status_ok) return 1;
    auto const bias_aggs = c2l::aggregate_tier_workload(bias_rows);

    std::vector<dg::WideMeasurementRow> surf_rows;
    if (dg::parse_wide_csv(csv, surf_rows) != dg::status_ok) return 1;

    std::vector<c2l::WideFullRow> full_rows;
    if (c2l::parse_wide_csv_full(csv, full_rows) != c2l::status_ok) return 1;
    std::vector<c2l::SiblingPairCount> counts;
    auto const                         exch_aggs = c2l::aggregate_exchange(full_rows, counts);

    for (auto const& lang : langs) {
        fs::path const out_dir = out_root / lang / "tabellen";
        fs::create_directories(out_dir);
        // (1) bias
        if (c2l::write_bias_matrix_latex(out_dir / "bias_matrix_table.tex", bias_aggs, ag::default_bias_caption(lang),
                                         label, lang) != c2l::status_ok)
            return 2;
        // (2) 6× surface
        for (auto const z_sv : ag::kSurfaceFields) {
            std::string const z{z_sv};
            if (dg::write_surface_search_algo_x_workload(out_dir / ("lc_surface_" + z + ".tex"), surf_rows, z, lang) !=
                dg::status_ok)
                return 3;
        }
        // (3) 4× exchange (Writer benennt ld_exchange_*.tex selbst)
        if (c2l::write_exchange_longtables(out_dir, exch_aggs, counts, lang) != c2l::status_ok) return 4;
        // (4) limitierung
        if (c2l::write_limitations_longtable(out_dir / "le_limitierung.tex", lang) != c2l::status_ok) return 5;
        // (5) ADDITIV (Inc-2a): 4 Darstellungs-Writer aus DENSELBEN geparsten Rows/Aggregaten (kein Doppel-Parsen).
        //     honest-empty (status_empty_input: dg=11 / c2l=12) = ok — dieselbe Toleranz-Semantik wie die Facade.
        auto const dg_ok  = [](int rc) { return rc == dg::status_ok || rc == dg::status_empty_input; };
        auto const c2l_ok = [](int rc) { return rc == c2l::status_ok || rc == c2l::status_empty_input; };
        if (!dg_ok(dg::write_segment_attribution_stacked_bar(out_dir / "seg_attribution.tex", surf_rows, lang)))
            return 6;
        if (!dg_ok(dg::write_latency_range_bar(out_dir / "latency_range.tex", surf_rows, lang))) return 7;
        if (!dg_ok(dg::write_latency_ecdf(out_dir / "latency_ecdf.tex", surf_rows, lang))) return 8;
        if (!c2l_ok(c2l::write_exchange_forest_plot(out_dir / "exchange_forest.tex", exch_aggs, counts, lang)))
            return 9;
    }
    return 0;
}

// Die 12 Kern-Dateinamen je Sprache (bias 1 + surface 6 + exchange 4 + limitierung 1).
std::vector<std::string> expected_files() {
    std::vector<std::string> names;
    names.push_back("bias_matrix_table.tex");
    for (auto const z : ag::kSurfaceFields) names.push_back("lc_surface_" + std::string{z} + ".tex");
    for (auto const ax : c2l::kVariableAxes) names.push_back("ld_exchange_" + std::string{ax} + ".tex");
    names.push_back("le_limitierung.tex");
    return names;
}

// Die 4 additiven Darstellungs-Dateinamen (Inc-2a). Die enriched Fixture ist so gewählt, dass KEINER
// honest-empty ist → alle 4 werden geschrieben und byte-identisch geprüft (16 .tex/Sprache insgesamt).
std::vector<std::string> expected_extra_files() {
    return {"seg_attribution.tex", "latency_range.tex", "latency_ecdf.tex", "exchange_forest.tex"};
}

} // namespace

TEST(Stufe08Appendix, FixtureIsFullWideSchema) {
    auto const fixture = fixtures_dir() / "tier_wide_appendix.csv";
    ensure_fixture(fixture);
    ASSERT_TRUE(fs::exists(fixture));
    // Alle drei Parser müssen die Fixture akzeptieren.
    std::vector<c2l::WideMeasurementRow> a;
    EXPECT_EQ(c2l::parse_wide_csv(fixture, a), c2l::status_ok);
    std::vector<dg::WideMeasurementRow> b;
    EXPECT_EQ(dg::parse_wide_csv(fixture, b), dg::status_ok);
    std::vector<c2l::WideFullRow> c;
    EXPECT_EQ(c2l::parse_wide_csv_full(fixture, c), c2l::status_ok);
    EXPECT_GT(a.size(), 0u);
}

// Inc-2a-Beleg: die enriched Fixture speist die 4 neuen Writer mit ECHTEN Daten (NICHT honest-empty) —
// sonst wäre die Byte-Identität über die 4 Darstellungs-.tex ein Nulltest. status_ok (nicht status_empty_input).
TEST(Stufe08Appendix, EnrichedFixtureFeedsAllFourNewWriters) {
    auto const fixture = fixtures_dir() / "tier_wide_appendix.csv";
    ensure_fixture(fixture);

    std::vector<dg::WideMeasurementRow> surf;
    ASSERT_EQ(dg::parse_wide_csv(fixture, surf), dg::status_ok);
    std::vector<c2l::WideFullRow> full;
    ASSERT_EQ(c2l::parse_wide_csv_full(fixture, full), c2l::status_ok);
    std::vector<c2l::SiblingPairCount> counts;
    auto const                         aggs = c2l::aggregate_exchange(full, counts);

    // Aggregate müssen befüllt sein (sonst honest-empty).
    EXPECT_GT(dg::aggregate_segment_attribution(surf).groups.size(), 0u);
    EXPECT_GT(dg::aggregate_latency_range(surf).algos.size(), 0u);
    EXPECT_GT(dg::aggregate_latency_ecdf(surf).size(), 0u);

    auto const      base = comdare_user_tmp() / "appendix_new_writers";
    std::error_code ec;
    fs::remove_all(base, ec);
    fs::create_directories(base);
    // Alle 4 liefern status_ok (schreiben real) — nicht status_empty_input.
    EXPECT_EQ(dg::write_segment_attribution_stacked_bar(base / "seg_attribution.tex", surf, "de"), dg::status_ok);
    EXPECT_EQ(dg::write_latency_range_bar(base / "latency_range.tex", surf, "de"), dg::status_ok);
    EXPECT_EQ(dg::write_latency_ecdf(base / "latency_ecdf.tex", surf, "de"), dg::status_ok);
    EXPECT_EQ(c2l::write_exchange_forest_plot(base / "exchange_forest.tex", aggs, counts, "de"), c2l::status_ok);
    for (auto const& n : {"seg_attribution.tex", "latency_range.tex", "latency_ecdf.tex", "exchange_forest.tex"})
        EXPECT_GT(fs::file_size(base / n), 0u) << n;
    fs::remove_all(base, ec);
}

// Kern-Beweis: In-Process-Orchestrator ≡ Einzel-Writer (byte-identisch).
TEST(Stufe08Appendix, InProcessOrchestratorByteIdenticalToIndividualWriters) {
    auto const fixture = fixtures_dir() / "tier_wide_appendix.csv";
    ensure_fixture(fixture);

    std::vector<std::string> const langs = {"de", "en"};
    std::string const              label = "tab:bias:search-algo-workload";

    auto const      base     = comdare_user_tmp();
    auto const      dir_orch = base / "appendix_orch";
    auto const      dir_ref  = base / "appendix_ref";
    std::error_code ec;
    fs::remove_all(dir_orch, ec);
    fs::remove_all(dir_ref, ec);

    // Pfad A — die zu prüfende App (In-Process-Orchestrator).
    ag::AppendixConfig cfg;
    cfg.csv        = fixture;
    cfg.out_root   = dir_orch;
    cfg.langs      = langs;
    cfg.bias_label = label;
    ASSERT_EQ(ag::generate_wide_appendix(cfg), ag::status_ok);

    // Pfad B — die äquivalenten Einzel-Writer (= die früheren .exe-Spawns).
    ASSERT_EQ(run_individual_writers(fixture, dir_ref, langs, label), 0);

    // Beweis: jede erzeugte .tex byte-identisch — 12 Kern-.tex + 4 Darstellungs-.tex (Inc-2a) = 16/Sprache.
    auto all_expected = expected_files();
    for (auto const& n : expected_extra_files()) all_expected.push_back(n);
    ASSERT_EQ(all_expected.size(), 16u);
    for (auto const& lang : langs) {
        auto const a = dir_orch / lang / "tabellen";
        auto const b = dir_ref / lang / "tabellen";
        for (auto const& name : all_expected) {
            auto const fa = a / name;
            auto const fb = b / name;
            ASSERT_TRUE(fs::exists(fa)) << "orchestrator fehlt: " << fa;
            ASSERT_TRUE(fs::exists(fb)) << "referenz fehlt: " << fb;
            EXPECT_GT(fs::file_size(fa), 0u) << fa;
            EXPECT_EQ(read_all(fa), read_all(fb)) << "byte-diff in " << name << " (" << lang << ")";
        }
    }

    std::error_code cleanup;
    fs::remove_all(dir_orch, cleanup);
    fs::remove_all(dir_ref, cleanup);
}
