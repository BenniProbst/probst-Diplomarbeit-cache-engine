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
// (war 20er-Drift inkl. seg_telemetry_ns/seg_isa_ns, B16). Reihenfolge = Organ-Achsen + seg_framework_ns.
constexpr std::size_t kSegN = dg::WideMeasurementRow::kSegmentCount; // Organ-Achsen + framework (ORG-18: 19)
// Summe 1+2+...+kSegN fuer die seg_run_total_ns-Bildung (ORG-18: kSegN=19 -> 190).
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
// A-B2 (2026-07-27): committete Fixture auf das 18+1-Schema regeneriert (STRUKT-R ORG-18 persistence_target,
// ce 774a5d5f) -- die 17+1-Fixture liess has_seg_ns ueberall false werden (Attribution 0 Gruppen, Status 11).
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
        // (6) GRAPH-UMBAU 2D/3D (2026-08-06): dieselbe Writer-Sequenz wie die Facade -- P1a 3D-Flaechen,
        //     P1b Sweep-Kurven. Ohne diese Spiegelung deckt der Byte-Identitaets-Beweis die neuen
        //     Dateien NICHT ab (stiller Luecken-Test).
        for (auto const z_sv : ag::kSurfaceFields) {
            std::string const z{z_sv};
            if (!dg_ok(dg::write_surface3d_search_algo_x_workload(out_dir / ("lc_surface3d_" + z + ".tex"), surf_rows,
                                                                  z, lang)))
                return 10;
        }
        for (auto const z_sv : ag::kSweepFields) {
            std::string const z{z_sv};
            if (!dg_ok(dg::write_working_set_sweep_curve(out_dir / ("ld_sweep_" + z + ".tex"), surf_rows, z, lang)))
                return 11;
        }
        // (7) P1c: Forest-Plot gegen die feste Referenz-Achsenauspraegung (Default der Facade).
        ag::AppendixConfig const defaults{};
        auto const               ref_aggs =
            c2l::select_exchange_vs_reference(exch_aggs, defaults.reference_axis, defaults.reference_value);
        if (!c2l_ok(c2l::write_exchange_forest_plot(out_dir / "exchange_forest_vs_reference.tex", ref_aggs, counts,
                                                    lang, false, c2l::kExchangeForestSmallSampleThreshold,
                                                    defaults.reference_value)))
            return 12;
        // (8) P2: baseline-relative Verhaeltnis-Matrix je z-Feld.
        for (auto const z_sv : ag::kSurfaceFields) {
            std::string const z{z_sv};
            if (!dg_ok(dg::write_surface_ratio_vs_reference(out_dir / ("lc_surface_ratio_" + z + ".tex"), surf_rows, z,
                                                            defaults.reference_value, lang)))
                return 13;
        }
        // (9) P3a: baseline-normalisierte Balken je z-Feld.
        for (auto const z_sv : ag::kSurfaceFields) {
            std::string const z{z_sv};
            if (!dg_ok(dg::write_normalized_bar_vs_reference(out_dir / ("lc_normbar_" + z + ".tex"), surf_rows, z,
                                                             defaults.reference_value, lang)))
                return 14;
        }
        // (10) P3b: Pareto-/Tradeoff-Streuung p50 gegen p99.
        if (!dg_ok(dg::write_latency_tradeoff_scatter(out_dir / "latency_tradeoff.tex", surf_rows, lang))) return 15;
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

// Die additiven Darstellungs-Dateinamen. Inc-2a: die 4 urspruenglichen (die enriched Fixture ist so
// gewaehlt, dass KEINER honest-empty ist). GRAPH-UMBAU P1a (2026-08-06): + die 6 3D-Flaechen -- sie
// entstehen IMMER, sobald die (search_algo x workload)-Achsen besetzt sind (bei datenloser Metrik als
// ehrlicher Platzhalter, ebenfalls eine Datei), also gehoeren sie in den Byte-Identitaets-Beweis.
// AUSDRUECKLICH NICHT hier: ld_sweep_<z>.tex (P1b) -- die Fixture traegt KEINE working_set_n-Spalte,
// der Writer ist also honest-empty und legt keine Datei an. Genau das prueft
// Stufe08Appendix.SweepCurvesAreHonestEmptyOnFixtureWithoutWorkingSetColumn.
std::vector<std::string> expected_extra_files() {
    std::vector<std::string> names = {"seg_attribution.tex", "latency_range.tex", "latency_ecdf.tex",
                                      "exchange_forest.tex"};
    for (auto const z : ag::kSurfaceFields) names.push_back("lc_surface3d_" + std::string{z} + ".tex");
    // GRAPH-UMBAU P2: die 6 Verhaeltnis-Matrizen entstehen ebenfalls IMMER (bei fehlender Referenz als
    // ehrlicher Platzhalter -- die Fixture kennt kein linear_scan, also genau dieser Fall). Auch der
    // Platzhalter ist eine Datei und muss byte-identisch zwischen Facade und Einzel-Writern sein.
    for (auto const z : ag::kSurfaceFields) names.push_back("lc_surface_ratio_" + std::string{z} + ".tex");
    // GRAPH-UMBAU P3b: die Pareto-Streuung entsteht, sobald p99-Spalten da sind -- die Fixture traegt
    // sie (Inc-2a hat sie fuer den Latenz-Range angehaengt). AUSDRUECKLICH NICHT hier: lc_normbar_<z>
    // (P3a) -- die Fixture kennt die Default-Referenz linear_scan nicht, der Writer ist also
    // honest-empty und legt keine Datei an (geprueft in
    // Stufe08Appendix.ReferenceForestIsHonestEmptyForAbsentReferenceAndAppearsForPresentOne-Nachbarschaft).
    names.push_back("latency_tradeoff.tex");
    return names;
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

    // Beweis: jede erzeugte .tex byte-identisch -- 12 Kern-.tex + 4 Darstellungs-.tex (Inc-2a)
    // + 6 3D-Flaechen (P1a) + 6 Verhaeltnis-Matrizen (P2) + Pareto-Streuung (P3b) = 29/Sprache.
    auto all_expected = expected_files();
    for (auto const& n : expected_extra_files()) all_expected.push_back(n);
    ASSERT_EQ(all_expected.size(), 29u);
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

// GRAPH-UMBAU 2D/3D, P1a (2026-08-06): die 3D-Flaeche ist ab jetzt VERDRAHTET -- je z-Feld entsteht
// neben der 2D-Heatmap eine lc_surface3d_<z>.tex. Der Test haelt beide Zusagen fest: (a) die Datei
// existiert und traegt die echte 3D-Mechanik (addplot3[surf] + view), (b) die 2D-Datei bleibt
// unveraendert daneben stehen (KEIN Ersatz -- Plan §4 "nichts faellt weg").
TEST(Stufe08Appendix, Surface3dIsWiredNextToTheExistingHeatmap) {
    auto const fixture = fixtures_dir() / "tier_wide_appendix.csv";
    ensure_fixture(fixture);

    auto const      dir = comdare_user_tmp() / "appendix_3d_wiring";
    std::error_code ec;
    fs::remove_all(dir, ec);

    ag::AppendixConfig cfg;
    cfg.csv      = fixture;
    cfg.out_root = dir;
    cfg.langs    = {"de"};
    ASSERT_EQ(ag::generate_wide_appendix(cfg), ag::status_ok);

    auto const tab = dir / "de" / "tabellen";
    for (auto const z_sv : ag::kSurfaceFields) {
        std::string const z{z_sv};
        auto const        f2d = tab / ("lc_surface_" + z + ".tex");
        auto const        f3d = tab / ("lc_surface3d_" + z + ".tex");
        ASSERT_TRUE(fs::exists(f2d)) << f2d; // Bestand bleibt
        ASSERT_TRUE(fs::exists(f3d)) << f3d; // neu
        EXPECT_GT(fs::file_size(f3d), 0u) << f3d;
    }
    // ns_per_op ist in der Fixture durchgaengig besetzt -> echte Figur, kein Platzhalter.
    auto const body = read_all(tab / "lc_surface3d_ns_per_op.tex");
    EXPECT_NE(body.find("addplot3[surf]"), std::string::npos);
    EXPECT_NE(body.find("view={45}{30}"), std::string::npos);
    // P1a-Rollen-Benennung: "Rohdaten-Ansicht", NICHT Ergebnis-Abbildung (zwei nominale Achsen).
    EXPECT_NE(body.find("3D-Rohdaten-Ansicht"), std::string::npos);
    // Die Caption ist NICHT leer (vor P1a blieb data.title ungesetzt -> "\caption{}").
    EXPECT_EQ(body.find("\\caption{}"), std::string::npos);

    fs::remove_all(dir, ec);
}

// GRAPH-UMBAU 2D/3D, P1b (2026-08-06): das Sweep-Wiring ist auf einem Korpus OHNE working_set_n-Spalte
// ein reines No-Op. Der Writer ist header-getrieben und liefert status_empty_input -> KEINE Datei, und
// die Facade bleibt gruen. Das ist der Risikofreiheits-Beleg fuer das Wiring (Plan §3/P1b).
TEST(Stufe08Appendix, SweepCurvesAreHonestEmptyOnFixtureWithoutWorkingSetColumn) {
    auto const fixture = fixtures_dir() / "tier_wide_appendix.csv";
    ensure_fixture(fixture);

    // Vorbedingung literal: die Fixture traegt KEINE working_set_n-Spalte.
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(fixture, rows), dg::status_ok);
    ASSERT_GT(rows.size(), 0u);
    for (auto const& r : rows) EXPECT_FALSE(r.has_working_set_n);

    auto const      dir = comdare_user_tmp() / "appendix_sweep_empty";
    std::error_code ec;
    fs::remove_all(dir, ec);

    ag::AppendixConfig cfg;
    cfg.csv      = fixture;
    cfg.out_root = dir;
    cfg.langs    = {"en"};
    ASSERT_EQ(ag::generate_wide_appendix(cfg), ag::status_ok); // Facade bleibt gruen

    auto const tab = dir / "en" / "tabellen";
    for (auto const z_sv : ag::kSweepFields) {
        std::string const z{z_sv};
        EXPECT_FALSE(fs::exists(tab / ("ld_sweep_" + z + ".tex"))) // honest-empty: KEINE Datei
            << "ld_sweep_" << z << ".tex haette nicht entstehen duerfen";
    }
    // Gegenprobe: die Kern-Dateien sind trotzdem da (honest-empty ist kein Facade-Fehler).
    EXPECT_TRUE(fs::exists(tab / "bias_matrix_table.tex"));

    fs::remove_all(dir, ec);
}

// GRAPH-UMBAU 2D/3D, P1c (2026-08-06): die Referenz ist eine ACHSENAUSPRAEGUNG des Korpus. Die Fixture
// kennt nur search_algo in {k_ary, eytzinger} -- die Default-Referenz "linear_scan" kommt darin NICHT
// vor. Dann darf die referenz-bezogene Figur nicht entstehen (honest-empty), und die Facade bleibt
// gruen. Mit einer im Korpus VORHANDENEN Referenz entsteht sie sehr wohl -- beides wird hier geprueft,
// damit "keine Datei" nicht mit "Writer kaputt" verwechselt werden kann.
TEST(Stufe08Appendix, ReferenceForestIsHonestEmptyForAbsentReferenceAndAppearsForPresentOne) {
    auto const fixture = fixtures_dir() / "tier_wide_appendix.csv";
    ensure_fixture(fixture);
    std::error_code ec;

    // (a) Default-Referenz linear_scan -- im Korpus NICHT vorhanden.
    auto const dir_absent = comdare_user_tmp() / "appendix_ref_absent";
    fs::remove_all(dir_absent, ec);
    ag::AppendixConfig cfg_absent;
    cfg_absent.csv      = fixture;
    cfg_absent.out_root = dir_absent;
    cfg_absent.langs    = {"en"};
    ASSERT_EQ(cfg_absent.reference_value, "linear_scan"); // Default literal festgehalten
    ASSERT_EQ(ag::generate_wide_appendix(cfg_absent), ag::status_ok);
    EXPECT_FALSE(fs::exists(dir_absent / "en" / "tabellen" / "exchange_forest_vs_reference.tex"));
    // Die Bestands-Figur (Geschwister-Paare untereinander) bleibt davon voellig unberuehrt.
    EXPECT_TRUE(fs::exists(dir_absent / "en" / "tabellen" / "exchange_forest.tex"));

    // (b) Referenz eytzinger -- im Korpus vorhanden.
    auto const dir_present = comdare_user_tmp() / "appendix_ref_present";
    fs::remove_all(dir_present, ec);
    ag::AppendixConfig cfg_present;
    cfg_present.csv             = fixture;
    cfg_present.out_root        = dir_present;
    cfg_present.langs           = {"en"};
    cfg_present.reference_value = "eytzinger";
    ASSERT_EQ(ag::generate_wide_appendix(cfg_present), ag::status_ok);
    auto const f = dir_present / "en" / "tabellen" / "exchange_forest_vs_reference.tex";
    ASSERT_TRUE(fs::exists(f));
    auto const c = read_all(f);
    EXPECT_NE(c.find("reference \\texttt{eytzinger}"), std::string::npos);
    // Eigenes \label -- sonst kollidiert sie im Dokument mit der Bestands-Figur.
    EXPECT_NE(c.find("\\label{fig:ld:exchange:forest:ref}"), std::string::npos);

    fs::remove_all(dir_absent, ec);
    fs::remove_all(dir_present, ec);
}

// ── Achsen-Inventar (2026-08-03) ──────────────────────────────────────────────
// Die Fixtures sind MINIATUREN der drei generierten Registry-XML: dieselbe Gestalt
// (Tag-Namen, Attribute, Kommentare, Verschachtelung), aber nur so viele Eintraege,
// wie der Beweis braucht. Sie sind ausdruecklich KEINE zweite Achsen-Liste: der
// Test prueft die PARSER-Zusagen, nicht den Inhalt der echten Registries (die sind
// generiert und duerfen sich aendern, ohne diesen Test rot zu faerben).
namespace {

void write_text(fs::path const& p, std::string const& text) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p, std::ios::binary);
    f << text;
}

fs::path make_registry_fixtures(fs::path const& dir) {
    // Organ: zwei Slots, Kommentar mit einem Pseudo-Tag (darf NICHT als Achse zaehlen).
    write_text(dir / "organ.xml", R"(<comdare_axis_registry engine="cache_engine" schema="1">
  <!-- GENERIERT. NICHT von Hand editieren. Ein <axis id="phantom"/> im Kommentar zaehlt nicht. -->
  <axis id="search_algo" slot="T00" category="composition" baustein_count="4">
    <baustein name="k_ary"/>
  </axis>
  <axis id="persistence_target" slot="T17" category="composition" baustein_count="1">
    <baustein name="memory_only"/>
  </axis>
</comdare_axis_registry>
)");
    // System: eine Haupt-Achse mit Unter-Achsen + die Komplex-Klammer mit Unter-Achsen-GRUPPE.
    write_text(dir / "system.xml", R"(<comdare_axis_registry engine="cache_engine_system" schema="1">
  <axis id="target_isa" category="system_config" binary_id="never" stage="ct" baustein_count="2">
    <baustein name="x86_64" enabled="true"/>
    <sub_axis id="numa_node" parent="target_isa" stage="runtime" value_type="token" option_source="machine_resolved"/>
    <sub_axis id="page" parent="target_isa" stage="runtime" value_type="token" option_source="machine_resolved"/>
  </axis>
  <system_complex_axis id="build_target_complex" category="system_config" binary_id="never" stage="ct" member_count="3">
    <member axis="target_isa"/>
    <sub_axis_group id="build_toolchain" sub_axis_count="3">
      <sub_axis id="compiler" parent="build_target_complex" stage="ct" baustein_count="2"/>
    </sub_axis_group>
  </system_complex_axis>
</comdare_axis_registry>
)");
    // Messen: eine Achse + die dynamic_dims (haengen an KEINER Achse).
    write_text(dir / "measurement.xml", R"(<comdare_axis_registry engine="cache_engine_measurement" schema="1">
  <axis id="load_framework" category="measurement_meta_meta" binary_id="never" stage="ct" baustein_count="1">
    <baustein name="ycsb" sub_axis_label="workload" enabled="true"/>
  </axis>
  <dynamic_dims resource_control_version="1">
    <dim id="workload" stage="runtime" source="measurement:load_framework" value_type="token"/>
    <dim id="thread_count" stage="runtime" source="resource_control_pod" value_type="uint"/>
  </dynamic_dims>
</comdare_axis_registry>
)");
    return dir;
}

} // namespace

// Parser-Zusage 1: Tag-Namen werden EXAKT unterschieden (sub_axis vs. sub_axis_group),
// Kommentare zaehlen nicht, Slots und Zaehlungen kommen aus den Attributen.
TEST(Stufe08Appendix, RegistryParserReadsAllThreeRealms) {
    auto const      dir = comdare_user_tmp() / "appendix_registry_fixtures";
    std::error_code ec;
    fs::remove_all(dir, ec);
    make_registry_fixtures(dir);

    ag::AxisRegistry organ;
    ASSERT_EQ(ag::parse_axis_registry(dir / "organ.xml", ag::AxisRealm::organ, organ), ag::status_ok);
    ASSERT_EQ(organ.axes.size(), 2u); // der Kommentar-<axis> zaehlt NICHT
    EXPECT_EQ(organ.axes[0].id, "search_algo");
    EXPECT_EQ(organ.axes[0].slot, "T00");
    EXPECT_TRUE(organ.axes[0].has_baustein_count);
    EXPECT_EQ(organ.axes[0].baustein_count, 4u);
    EXPECT_EQ(organ.axes[1].id, "persistence_target");
    EXPECT_EQ(organ.axes[1].slot, "T17");

    ag::AxisRegistry system;
    ASSERT_EQ(ag::parse_axis_registry(dir / "system.xml", ag::AxisRealm::system, system), ag::status_ok);
    ASSERT_EQ(system.axes.size(), 2u);
    EXPECT_EQ(system.axes[0].id, "target_isa");
    EXPECT_FALSE(system.axes[0].is_complex_bracket);
    ASSERT_EQ(system.axes[0].sub_axes.size(), 2u);
    EXPECT_EQ(system.axes[0].sub_axes[0].id, "numa_node");
    EXPECT_EQ(system.axes[0].sub_axes[0].option_source, "machine_resolved");
    EXPECT_EQ(system.axes[0].sub_axes[1].id, "page");
    // Die aeussere Klammer ist als Klammer markiert und KEINE vierte Haupt-Achse.
    EXPECT_EQ(system.axes[1].id, "build_target_complex");
    EXPECT_TRUE(system.axes[1].is_complex_bracket);
    ASSERT_EQ(system.axes[1].sub_axes.size(), 2u);
    EXPECT_TRUE(system.axes[1].sub_axes[0].is_group); // sub_axis_group != sub_axis
    EXPECT_EQ(system.axes[1].sub_axes[0].id, "build_toolchain");
    EXPECT_FALSE(system.axes[1].sub_axes[1].is_group);
    EXPECT_EQ(system.axes[1].sub_axes[1].id, "compiler");

    ag::AxisRegistry meas;
    ASSERT_EQ(ag::parse_axis_registry(dir / "measurement.xml", ag::AxisRealm::measurement, meas), ag::status_ok);
    ASSERT_EQ(meas.axes.size(), 1u);
    EXPECT_EQ(meas.axes[0].id, "load_framework");
    EXPECT_EQ(meas.axes[0].category, "measurement_meta_meta");
    EXPECT_EQ(meas.axes[0].binary_id, "never");
    ASSERT_EQ(meas.dynamic_dims.size(), 2u);
    EXPECT_EQ(meas.dynamic_dims[0].id, "workload");
    EXPECT_EQ(meas.dynamic_dims[1].id, "thread_count");

    fs::remove_all(dir, ec);
}

// Parser-Zusage 2: eine fehlende Datei ist ein I/O-Fehler, keine stille Leer-Antwort.
TEST(Stufe08Appendix, RegistryParserFailsHonestlyOnMissingFile) {
    ag::AxisRegistry reg;
    EXPECT_EQ(ag::parse_axis_registry(comdare_user_tmp() / "gibt_es_nicht.xml", ag::AxisRealm::organ, reg),
              ag::status_io_error);
    EXPECT_TRUE(reg.axes.empty());
    EXPECT_EQ(ag::parse_axis_registry(fs::path{}, ag::AxisRealm::organ, reg), ag::status_io_error);
}

// Writer-Zusage: ohne Registry KEINE Datei (honest-empty); mit Registry ein
// vollstaendiges longtable-Fragment, das jede Achse genau einmal nennt.
TEST(Stufe08Appendix, AxisInventoryWriterIsHonestEmptyAndComplete) {
    auto const      dir = comdare_user_tmp() / "appendix_inventory";
    std::error_code ec;
    fs::remove_all(dir, ec);
    fs::create_directories(dir);

    // (a) honest-empty: leere Registry-Liste ⇒ status_empty_input, keine Datei.
    auto const empty_out = dir / "axis_inventory_empty.tex";
    EXPECT_EQ(ag::write_axis_inventory_table(empty_out, {}, "de"), ag::status_empty_input);
    EXPECT_FALSE(fs::exists(empty_out));

    // (b) vollstaendig: alle drei Realms in EINER Tabelle.
    auto const fx = comdare_user_tmp() / "appendix_registry_fixtures_w";
    fs::remove_all(fx, ec);
    make_registry_fixtures(fx);
    std::vector<ag::AxisRegistry> regs(3);
    ASSERT_EQ(ag::parse_axis_registry(fx / "organ.xml", ag::AxisRealm::organ, regs[0]), ag::status_ok);
    ASSERT_EQ(ag::parse_axis_registry(fx / "system.xml", ag::AxisRealm::system, regs[1]), ag::status_ok);
    ASSERT_EQ(ag::parse_axis_registry(fx / "measurement.xml", ag::AxisRealm::measurement, regs[2]), ag::status_ok);

    for (auto const& lang : {"de", "en"}) {
        auto const out = dir / ("axis_inventory_" + std::string{lang} + ".tex");
        ASSERT_EQ(ag::write_axis_inventory_table(out, regs, lang), ag::status_ok);
        auto const text = read_all(out);
        EXPECT_GT(text.size(), 0u);
        EXPECT_NE(text.find("\\begin{longtable}"), std::string::npos);
        EXPECT_NE(text.find("\\end{longtable}"), std::string::npos);
        // Jede Achse steht drin (Unterstriche als \_ maskiert + Umbruchpunkt).
        std::vector<std::string> const wanted = {
            "search\\_\\allowbreak{}algo", "persistence\\_\\allowbreak{}target", "target\\_\\allowbreak{}isa",
            "build\\_\\allowbreak{}target\\_\\allowbreak{}complex", "load\\_\\allowbreak{}framework"};
        for (auto const& id : wanted) EXPECT_NE(text.find(id), std::string::npos) << id << " fehlt (" << lang << ")";
        // Die Sweep-Dimensionen stehen als Legende UNTER dem Float.
        auto const table_end = text.find("\\end{longtable}");
        auto const dims_pos  = text.find("thread\\_\\allowbreak{}count");
        ASSERT_NE(dims_pos, std::string::npos);
        EXPECT_GT(dims_pos, table_end);
        // Kein roher Unterstrich ausserhalb der Maskierung (sonst bricht der LaTeX-Lauf).
        for (std::size_t i = 0; i < text.size(); ++i)
            if (text[i] == '_') ASSERT_GT(i, 0u) << "roher Unterstrich am Textanfang";
    }

    fs::remove_all(dir, ec);
    fs::remove_all(fx, ec);
}

// Facade-Zusage: OHNE Registry-Pfade bleibt der Lauf byte-gleich zu vorher (keine
// axis_inventory.tex), MIT Pfaden entsteht sie zusaetzlich — die 16 Kern-/Darstellungs-
// .tex bleiben unberuehrt.
TEST(Stufe08Appendix, FacadeWritesAxisInventoryOnlyWhenRegistriesGiven) {
    auto const fixture = fixtures_dir() / "tier_wide_appendix.csv";
    ensure_fixture(fixture);
    auto const      fx = comdare_user_tmp() / "appendix_registry_fixtures_f";
    std::error_code ec;
    fs::remove_all(fx, ec);
    make_registry_fixtures(fx);

    auto const base    = comdare_user_tmp();
    auto const dir_off = base / "appendix_inv_off";
    auto const dir_on  = base / "appendix_inv_on";
    fs::remove_all(dir_off, ec);
    fs::remove_all(dir_on, ec);

    ag::AppendixConfig off;
    off.csv      = fixture;
    off.out_root = dir_off;
    off.langs    = {"de"};
    ASSERT_EQ(ag::generate_wide_appendix(off), ag::status_ok);
    EXPECT_FALSE(fs::exists(dir_off / "de" / "tabellen" / "axis_inventory.tex"));

    ag::AppendixConfig on        = off;
    on.out_root                  = dir_on;
    on.organ_axis_registry       = fx / "organ.xml";
    on.system_axis_registry      = fx / "system.xml";
    on.measurement_axis_registry = fx / "measurement.xml";
    ASSERT_EQ(ag::generate_wide_appendix(on), ag::status_ok);
    auto const inv = dir_on / "de" / "tabellen" / "axis_inventory.tex";
    ASSERT_TRUE(fs::exists(inv));
    EXPECT_GT(fs::file_size(inv), 0u);

    // Die 16 bestehenden .tex sind zwischen beiden Laeufen byte-identisch geblieben.
    auto all_expected = expected_files();
    for (auto const& n : expected_extra_files()) all_expected.push_back(n);
    for (auto const& name : all_expected) {
        auto const a = dir_off / "de" / "tabellen" / name;
        auto const b = dir_on / "de" / "tabellen" / name;
        ASSERT_TRUE(fs::exists(a)) << a;
        ASSERT_TRUE(fs::exists(b)) << b;
        EXPECT_EQ(read_all(a), read_all(b)) << "byte-diff in " << name;
    }

    // Gesetzter, aber kaputter Pfad = ECHTER Fehler (kein stilles Degradieren auf 4 Achsen).
    ag::AppendixConfig broken  = off;
    broken.out_root            = base / "appendix_inv_broken";
    broken.organ_axis_registry = fx / "gibt_es_nicht.xml";
    fs::remove_all(broken.out_root, ec);
    EXPECT_EQ(ag::generate_wide_appendix(broken), ag::status_parse_error);

    fs::remove_all(dir_off, ec);
    fs::remove_all(dir_on, ec);
    fs::remove_all(broken.out_root, ec);
    fs::remove_all(fx, ec);
}
