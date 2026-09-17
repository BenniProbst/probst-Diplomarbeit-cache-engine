// V35.D.3 (2026-05-22) - Stufen-Test mit gecachten Fixtures (05_diagram_generator)

#include "diagram_generator.hpp"

#include "csv_to_latex.hpp" // INC-4: c2l::WideFullRow + parse_wide_csv_full (stat_<achse>_<feld>-Durchreichung)

#include <gtest/gtest.h>

#include <algorithm>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <sstream>
#include <string>
#include <string_view>
#include <unistd.h>
#include <vector>

namespace dg  = comdare::da::diagram_generator;
namespace c2l = comdare::da::csv_to_latex;
namespace fs  = std::filesystem;

namespace {

// M-SU-04: Benutzer-eindeutige tmp-Basis (identisch zum 04-Test). /tmp ist host-weit geteilt (prod1: lokale
// Läufe als comdare, CI als gitlab-runner) — feste Namen gehören dem Erst-Ersteller und blocken den jeweils
// anderen (Incident 8081/213626). Der ::getuid()-Suffix trennt die Läufe kollisionsfrei.
std::filesystem::path comdare_user_tmp() {
    auto p = std::filesystem::temp_directory_path() / ("comdare_test_" + std::to_string(::getuid()));
    std::filesystem::create_directories(p);
    return p;
}

void write_sample_csv_with_workload(fs::path const& p) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    f << "permutation_id,fingerprint,succeeded,workload_used,op_count,total_cycles,"
      << "cache_misses_l1,cache_misses_l2,cache_misses_l3,dtlb_misses,"
      << "coherence_invalidations,energy_micro_joules,"
      << "bytes_allocated,bytes_in_use_peak,external_frag,internal_frag\n";
    f << "ce_art,1,1,YCSB_C,1000,500000,50,10,2,0,0,12345,4096,3072,0.0,0.0\n";
    f << "pa_art,2,1,YCSB_C,1500,400000,30,8,1,0,0,15000,5120,4096,0.0,0.0\n";
    f << "ce_hot,3,1,YCSB_A,2000,800000,150,30,5,0,0,25000,8192,6144,0.0,0.0\n";
    f << "pa_hot,4,1,YCSB_A,2200,750000,120,25,4,0,0,27000,8192,6144,0.0,0.0\n";
}

void ensure_cached_csv(fs::path const& p) {
    if (!fs::exists(p)) write_sample_csv_with_workload(p);
}

fs::path fixtures_dir() {
    if (auto* env = std::getenv("COMDARE_FIXTURES_DIR_05"); env != nullptr) { return fs::path(env); }
#ifdef COMDARE_FIXTURES_DIR_05_FALLBACK
    // Deterministischer Fallback = per-Stufe Source-Dir (CMake-einkompiliert) — KEIN CWD-Stray (2026-06-01 gehärtet).
    return fs::path(COMDARE_FIXTURES_DIR_05_FALLBACK);
#else
    return fs::current_path() / "fixtures" / "cached"; // letzter Notnagel
#endif
}

bool file_contains(fs::path const& p, std::string_view needle) {
    std::ifstream in(p);
    std::string   content((std::istreambuf_iterator<char>(in)), {});
    return content.find(needle) != std::string::npos;
}

} // namespace

TEST(Stufe05Pipeline, CachedCsvFixtureExistsOrIsGenerated) {
    auto dir = fixtures_dir();
    ensure_cached_csv(dir / "sample_workload_groups.csv");
    EXPECT_TRUE(fs::exists(dir / "sample_workload_groups.csv"));
    EXPECT_GT(fs::file_size(dir / "sample_workload_groups.csv"), 100u);
}

TEST(Stufe05Pipeline, LoadCsvWithWorkloadUsed) {
    auto dir = fixtures_dir();
    ensure_cached_csv(dir / "sample_workload_groups.csv");
    auto rows = dg::load_csv_with_workload_used(dir / "sample_workload_groups.csv");
    ASSERT_EQ(rows.size(), 4u);
    EXPECT_EQ(rows[0].permutation_id, "ce_art");
    EXPECT_EQ(rows[0].workload_used, "YCSB_C");
    EXPECT_EQ(rows[0].op_count, 1000u);
    EXPECT_EQ(rows[3].workload_used, "YCSB_A");
}

TEST(Stufe05Pipeline, WriteBarChartFromCachedFixture) {
    dg::BarChartData data;
    data.title   = "Stufe05Pipeline Sample";
    data.x_label = "permutation";
    data.y_label = "throughput";
    data.labels  = {"ce_art", "pa_art", "ce_hot", "pa_hot"};
    data.values  = {1000.0, 1500.0, 2000.0, 2200.0};

    auto out = comdare_user_tmp() / "v35d3_bar.tex";
    ASSERT_EQ(dg::write_bar_chart(out, data), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "tikzpicture"));
    // Underscores werden im TikZ escaped, daher nur Praefix pruefen
    EXPECT_TRUE(file_contains(out, "ce"));
    EXPECT_TRUE(file_contains(out, "Stufe05Pipeline Sample"));

    std::error_code ec;
    fs::remove(out, ec);
}

TEST(Stufe05Pipeline, WriteScatterPlot) {
    dg::ScatterData data;
    data.title   = "v35d3 Scatter";
    data.x_label = "alloc_size";
    data.y_label = "latency";
    data.xs      = {16.0, 64.0, 256.0, 1024.0};
    data.ys      = {100.0, 250.0, 800.0, 3500.0};

    auto out = comdare_user_tmp() / "v35d3_scatter.tex";
    ASSERT_EQ(dg::write_scatter_plot(out, data), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "tikzpicture"));

    std::error_code ec;
    fs::remove(out, ec);
}

TEST(Stufe05Pipeline, WriteThroughputByWorkloadFromCachedCsv) {
    auto dir = fixtures_dir();
    ensure_cached_csv(dir / "sample_workload_groups.csv");
    auto rows = dg::load_csv_with_workload_used(dir / "sample_workload_groups.csv");
    ASSERT_EQ(rows.size(), 4u);

    auto out = comdare_user_tmp() / "v35d3_throughput.tex";
    ASSERT_EQ(dg::write_throughput_by_workload(out, rows), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "tikzpicture"));

    std::error_code ec;
    fs::remove(out, ec);
}

// L-c (2026-06-18) — WIDE-Schema (';') header-getriebener Parser + Surface-Emitter.
namespace {
void write_sample_wide_csv(fs::path const& p) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    // Minimal-Header mit allen Pflichtspalten + 1 Füll-Spalte (Reihenfolge-agnostisch testen).
    f << "binary_id;ns_per_op;op_insert_p50_ns;op_lookup_p50_ns;op_erase_p50_ns;"
      << "op_scan_p50_ns;op_rmw_p50_ns;filler;workload;two_phase_valid\n";
    f << "search_algo=k_ary/mapping=direct;42.5;30.0;25.0;28.0;500.0;40.0;x;ycsb_c;1\n";
    f << "search_algo=eytzinger/mapping=direct;55.0;33.0;20.0;31.0;600.0;45.0;x;ycsb_a;1\n";
    // two_phase_valid=0 → muss von der Aggregation ignoriert werden.
    f << "search_algo=k_ary/mapping=direct;9999.0;1.0;1.0;1.0;1.0;1.0;x;ycsb_c;0\n";
}
} // namespace

TEST(Stufe05Pipeline, ParseWideCsvHeaderDriven) {
    auto p = comdare_user_tmp() / "lc_wide_sample.csv";
    write_sample_wide_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);
    ASSERT_EQ(rows.size(), 3u);
    EXPECT_EQ(rows[0].search_algo, "k_ary"); // Prefix-Extraktion
    EXPECT_EQ(rows[1].search_algo, "eytzinger");
    EXPECT_FALSE(rows[0].search_algo.empty());
    EXPECT_GT(rows[0].ns_per_op, 0.0);
    EXPECT_DOUBLE_EQ(rows[0].op_scan_p50_ns, 500.0);
    EXPECT_TRUE(rows[0].two_phase_valid);
    EXPECT_FALSE(rows[2].two_phase_valid);
    std::error_code ec;
    fs::remove(p, ec);
}

TEST(Stufe05Pipeline, WriteSurfaceHeatmapFromWide) {
    auto p = comdare_user_tmp() / "lc_wide_sample2.csv";
    write_sample_wide_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto out = comdare_user_tmp() / "lc_surface_nsperop.tex";
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out, rows, "ns_per_op", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "addplot3"));
    EXPECT_TRUE(file_contains(out, "colormap/viridis"));

    auto out3d = comdare_user_tmp() / "lc_surface3d_nsperop.tex";
    ASSERT_EQ(dg::write_surface3d_search_algo_x_workload(out3d, rows, "ns_per_op", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out3d, "addplot3[surf]"));
    EXPECT_TRUE(file_contains(out3d, "zmode=log"));

    std::error_code ec;
    fs::remove(out, ec);
    fs::remove(out3d, ec);
    fs::remove(p, ec);
}

// GRAPH-UMBAU 2D/3D, P1a (2026-08-06): der 3D-Writer traegt Titel UND Caption aus EINER Quelle.
// Bis P1a fuellte niemand data.title (aggregate_surface_matrix setzt nur Labels/Matrix/Maske), sodass
// die Figur ein leeres "\caption{}" bekam -- unbemerkt, weil der Writer nirgends verdrahtet war.
// Zusaetzlich haelt der Test die ROLLEN-Benennung fest: "Rohdaten-Ansicht"/"raw-data view", NICHT
// "Ergebnis" -- beide Flaechen-Achsen sind nominal und tragen keine Interpolationsaussage.
TEST(Stufe05Pipeline, Surface3dCarriesRawDataViewTitleAndNonEmptyCaption) {
    auto p = comdare_user_tmp() / "p1a_wide_sample.csv";
    write_sample_wide_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    std::error_code ec;

    // -- en --
    auto out_en = comdare_user_tmp() / "p1a_surface3d_en.tex";
    fs::remove(out_en, ec);
    ASSERT_EQ(dg::write_surface3d_search_algo_x_workload(out_en, rows, "ns_per_op", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out_en, "3D raw-data view: overall latency (ns/op)"));
    EXPECT_FALSE(file_contains(out_en, "\\caption{}")); // Caption ist NICHT mehr leer
    // Titel steht an BEIDEN Orten -- Achsen-title UND caption speisen sich aus derselben Quelle.
    EXPECT_TRUE(file_contains(out_en, "title={3D raw-data view"));
    EXPECT_TRUE(file_contains(out_en, "\\caption{3D raw-data view"));

    // -- de --
    auto out_de = comdare_user_tmp() / "p1a_surface3d_de.tex";
    fs::remove(out_de, ec);
    ASSERT_EQ(dg::write_surface3d_search_algo_x_workload(out_de, rows, "ns_per_op", "de"), dg::status_ok);
    EXPECT_TRUE(file_contains(out_de, "3D-Rohdaten-Ansicht"));
    EXPECT_FALSE(file_contains(out_de, "\\caption{}"));
    // KEINE "Ergebnis"-Behauptung und kein Rest der alten Benennung.
    EXPECT_FALSE(file_contains(out_de, "3D-Surface:"));

    fs::remove(out_en, ec);
    fs::remove(out_de, ec);
    fs::remove(p, ec);
}

TEST(Stufe05Pipeline, EmptyInputReturnsEmpty) {
    dg::BarChartData empty;
    empty.title = "empty";
    auto out    = comdare_user_tmp() / "v35d3_empty.tex";
    int  rc     = dg::write_bar_chart(out, empty);
    // Erwartung: entweder status_empty_input ODER status_ok mit leerer Datei
    EXPECT_TRUE(rc == dg::status_ok || rc == dg::status_empty_input);
    std::error_code ec;
    fs::remove(out, ec);
}

// ─────────────────────────────────────────────────────────────────────────────
// P4 (2026-07-12) — Per-Achsen-Latenz-Attribution (gestapelte Balken)
// ─────────────────────────────────────────────────────────────────────────────
namespace {

// M-4 (2026-07-19): Zaehlung + Namen aus der Produktions-Konstante (die ihrerseits CE-Single-Source ist:
// kV3AxisCount + kCompositionAxisNames) — hier KEINE eigene Literal-Liste mehr (war 20er-Drift, B16).
constexpr std::size_t kSegN = dg::WideMeasurementRow::kSegmentCount; // Organ-Achsen + framework (ORG-18: 19)
// Summe 1+2+...+kSegN fuer die seg_run_total_ns-Bildung der synthetischen Zeilen (kSegN=18 -> 171).
constexpr long kSegTriangleSum = static_cast<long>(kSegN) * static_cast<long>(kSegN + 1) / 2;

std::string seg_header() {
    std::string h;
    for (auto const col : dg::kSegmentColumns) {
        if (!h.empty()) h += ';';
        h += std::string{col};
    }
    return h;
}

// Eine schema-treue WIDE-Datenzeile. seg_mult>0 → kSegN seg_*_ns = seg_mult*(i+1), seg_run_total_ns =
// seg_mult*kSegTriangleSum (== Σ der kSegN Segmente, seg_coverage=coverage). na_first=true →
// seg_search_algo_ns="n/a" (Guard-Test).
// total_ns wird BEWUSST sehr verschieden von seg_run_total_ns gesetzt (Inkommensurabilitaets-Beleg).
std::string seg_row(std::string const& algo, long total_ns, int seg_mult, double coverage, bool two_phase,
                    bool na_first) {
    std::ostringstream r;
    r << "search_algo=" << algo << "/mapping=direct;" // binary_id
      << "42.0;30;25;28;500;40;"                      // ns_per_op + 5 op_*_p50_ns
      << total_ns << ";";                             // total_ns (DARF NIE Stapel-Ganzes sein)
    long sum = 0;
    for (std::size_t i = 0; i < kSegN; ++i) {
        if (i > 0) r << ";";
        if (i == 0 && na_first) {
            r << "n/a";
        } else {
            long const v = static_cast<long>(seg_mult) * static_cast<long>(i + 1);
            r << v;
            sum += v;
        }
    }
    long const run_total = na_first ? sum : static_cast<long>(seg_mult) * kSegTriangleSum;
    r << ";" << run_total << ";";
    r << std::fixed << std::setprecision(6) << coverage << ";";
    r << "ycsb_c;" << (two_phase ? "1" : "0");
    return r.str();
}

void write_sample_wide_seg_csv(fs::path const& p) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    f << "binary_id;ns_per_op;op_insert_p50_ns;op_lookup_p50_ns;op_erase_p50_ns;op_scan_p50_ns;op_rmw_p50_ns;"
      << "total_ns;" << seg_header() << ";seg_run_total_ns;seg_coverage;workload;two_phase_valid\n";
    f << seg_row("k_ary", 999999, 10, 1.0, true, false) << "\n";        // gueltig  Σ=1710
    f << seg_row("k_ary", 999999, 10, 1.0, true, false) << "\n";        // gueltig  Σ=1710 (Mittel bleibt 1710)
    f << seg_row("interpolation", 888888, 5, 1.0, true, false) << "\n"; // gueltig  Σ=855
    f << seg_row("k_ary", 777777, 100, 1.0, false, false) << "\n";      // two_phase=0 → verworfen (nicht 0-gestapelt)
    f << seg_row("k_ary", 666666, 10, 1.0, true, true) << "\n";         // seg_search_algo_ns=n/a → verworfen (Guard d)
}

// Nur ungueltige Segment-Zeilen (alle seg n/a bzw. two_phase=0) → aggregate liefert leere Gruppen.
void write_all_invalid_wide_seg_csv(fs::path const& p) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    f << "binary_id;ns_per_op;op_insert_p50_ns;op_lookup_p50_ns;op_erase_p50_ns;op_scan_p50_ns;op_rmw_p50_ns;"
      << "total_ns;" << seg_header() << ";seg_run_total_ns;seg_coverage;workload;two_phase_valid\n";
    f << seg_row("k_ary", 999999, 10, 1.0, true, true) << "\n";          // seg n/a
    f << seg_row("interpolation", 888888, 5, 1.0, false, false) << "\n"; // two_phase=0
}

std::size_t count_occurrences(fs::path const& p, std::string_view needle) {
    std::ifstream in(p);
    std::string   content((std::istreambuf_iterator<char>(in)), {});
    std::size_t   n = 0, pos = 0;
    while ((pos = content.find(needle, pos)) != std::string::npos) {
        ++n;
        pos += needle.size();
    }
    return n;
}

} // namespace

TEST(Stufe05Pipeline, ParseWideCsvSegColumns) {
    auto p = comdare_user_tmp() / "p4_wide_seg_parse.csv";
    write_sample_wide_seg_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);
    ASSERT_EQ(rows.size(), 5u);
    // 1. gueltige k_ary-Zeile: alle kSegN seg vorhanden, seg_run_total_ns=1710, coverage vorhanden.
    EXPECT_TRUE(rows[0].has_seg_ns);
    EXPECT_TRUE(rows[0].has_seg_run_total);
    EXPECT_TRUE(rows[0].has_seg_coverage);
    EXPECT_DOUBLE_EQ(rows[0].seg_run_total_ns, static_cast<double>(10 * kSegTriangleSum));
    EXPECT_DOUBLE_EQ(rows[0].seg_ns[0], 10.0);                                    // seg_search_algo_ns
    EXPECT_DOUBLE_EQ(rows[0].seg_ns[kSegN - 1], static_cast<double>(10 * kSegN)); // seg_framework_ns
    // n/a-Zeile (letzte): seg_search_algo_ns="n/a" → has_seg_ns=false (n-a-tolerant, KEIN Parse-Fehler).
    EXPECT_FALSE(rows[4].has_seg_ns);
    std::error_code ec;
    fs::remove(p, ec);
}

TEST(Stufe05Pipeline, SegAttributionAggregateSumsToRunTotalNotTotalNs) {
    auto p = comdare_user_tmp() / "p4_wide_seg_agg.csv";
    write_sample_wide_seg_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto const agg = dg::aggregate_segment_attribution(rows);
    // Deterministisch sortiert: interpolation < k_ary.
    ASSERT_EQ(agg.groups.size(), 2u);
    EXPECT_EQ(agg.groups[0], "interpolation");
    EXPECT_EQ(agg.groups[1], "k_ary");
    ASSERT_EQ(agg.segment_labels.size(), kSegN);
    EXPECT_EQ(agg.segment_labels[0], "search_algo");
    EXPECT_EQ(agg.segment_labels[kSegN - 1], "framework");
    ASSERT_EQ(agg.means.size(), kSegN);

    // (a) Die kSegN Segmente stapeln je Gruppe zu seg_run_total_ns (Coverage≈1) — NICHT zu total_ns.
    for (std::size_t g = 0; g < agg.groups.size(); ++g) {
        double stack = 0.0;
        for (std::size_t s = 0; s < kSegN; ++s) stack += agg.means[s][g];
        EXPECT_NEAR(stack, agg.group_totals[g], 1e-6);
        EXPECT_NEAR(stack, agg.run_total_means[g], 1e-6); // == Mittel seg_run_total_ns (kommensurabel)
        EXPECT_NEAR(agg.coverage_means[g], 1.0, 1e-6);
    }
    // k_ary: zwei gueltige Zeilen (Σ=1710 je), n/a- + two_phase=0-Zeile VERWORFEN → Mittel bleibt 1710 (nicht verwaessert).
    EXPECT_NEAR(agg.group_totals[1], static_cast<double>(10 * kSegTriangleSum), 1e-6);
    EXPECT_NEAR(agg.group_totals[0], static_cast<double>(5 * kSegTriangleSum), 1e-6); // interpolation

    // (b) total_ns (999999 / 888888) taucht NICHT als Stapel-Ganzes auf.
    EXPECT_NE(agg.group_totals[1], 999999.0);
    EXPECT_NE(agg.group_totals[0], 888888.0);
    std::error_code ec;
    fs::remove(p, ec);
}

TEST(Stufe05Pipeline, SegAttributionStackedBarEmitsPerSegmentAddplots) {
    auto p = comdare_user_tmp() / "p4_wide_seg_writer.csv";
    write_sample_wide_seg_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto out = comdare_user_tmp() / "p4_seg_attribution.tex";
    ASSERT_EQ(dg::write_segment_attribution_stacked_bar(out, rows, "de"), dg::status_ok);
    // (c) valides pgfplots: ybar stacked, exakt kSegN \addplot + kSegN \addlegendentry.
    EXPECT_TRUE(file_contains(out, "ybar stacked"));
    EXPECT_EQ(count_occurrences(out, "\\addplot"), kSegN);
    EXPECT_EQ(count_occurrences(out, "\\addlegendentry"), kSegN);
    EXPECT_TRUE(file_contains(out, "framework")); // letztes Segment als Legende
    // (b) total_ns darf NICHT im Output stehen (weder als Ganzes noch als Koordinate).
    EXPECT_FALSE(file_contains(out, "999999"));
    EXPECT_FALSE(file_contains(out, "888888"));
    std::error_code ec;
    fs::remove(out, ec);
    fs::remove(p, ec);
}

TEST(Stufe05Pipeline, SegAttributionGuardHonestEmptyOnAllNa) {
    // (d) Guard: keine gueltige Segment-Zeile (alle seg n/a bzw. two_phase=0) → status_empty_input, KEIN leerer Balken.
    auto p = comdare_user_tmp() / "p4_wide_seg_allna.csv";
    write_all_invalid_wide_seg_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto const agg = dg::aggregate_segment_attribution(rows);
    EXPECT_TRUE(agg.groups.empty());

    auto out = comdare_user_tmp() / "p4_seg_attribution_empty.tex";
    EXPECT_EQ(dg::write_segment_attribution_stacked_bar(out, rows, "en"), dg::status_empty_input);
    std::error_code ec;
    fs::remove(out, ec);
    fs::remove(p, ec);
}

// ─────────────────────────────────────────────────────────────────────────────
// P3 (2026-07-12) — Latenz-VERTEILUNG statt Mittelwert (Range-Spanne + Config-ECDF)
// ─────────────────────────────────────────────────────────────────────────────
namespace {

// 14-Spalten-WIDE-Zeilen mit p50 UND p99 je op-Art. 0-Werte = Op nicht ausgefuehrt (muss von der Range-
// Aggregation ausgeschlossen werden, KEIN Phantom-0). scan-Zeile mit workload=ycsb_e ist ein No-Op-Scan
// (muss von der scan-Aggregation ausgeschlossen werden), zaehlt aber als gueltige Config fuer die ECDF.
void write_sample_wide_p99_csv(fs::path const& p) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    f << "binary_id;ns_per_op;op_insert_p50_ns;op_insert_p99_ns;op_lookup_p50_ns;op_lookup_p99_ns;"
      << "op_erase_p50_ns;op_erase_p99_ns;op_scan_p50_ns;op_scan_p99_ns;op_rmw_p50_ns;op_rmw_p99_ns;"
      << "workload;two_phase_valid\n";
    // A,B: k_ary ycsb_c (insert+lookup ausgefuehrt, p99>p50). C: k_ary scan_wl (scan p50=500,p99=700).
    f << "search_algo=k_ary/mapping=direct;1000;100;200;50;90;0;0;0;0;0;0;ycsb_c;1\n";
    f << "search_algo=k_ary/mapping=direct;1100;120;240;60;100;0;0;0;0;0;0;ycsb_c;1\n";
    f << "search_algo=k_ary/mapping=direct;5000;0;0;0;0;0;0;500;700;0;0;scan_wl;1\n";
    // D: k_ary ycsb_e (No-Op-Scan 1/2 → aus scan-Agg ausgeschlossen; ns_per_op=900 zaehlt fuer ECDF).
    f << "search_algo=k_ary/mapping=direct;900;0;0;0;0;0;0;1;2;0;0;ycsb_e;1\n";
    // E: eytzinger ycsb_c (insert+lookup). F: eytzinger two_phase_valid=0 → komplett verworfen.
    f << "search_algo=eytzinger/mapping=direct;2000;200;300;80;120;0;0;0;0;0;0;ycsb_c;1\n";
    f << "search_algo=eytzinger/mapping=direct;9999;1;1;1;1;1;1;1;1;1;1;ycsb_c;0\n";
}

std::size_t p3_count(fs::path const& p, std::string_view needle) {
    std::ifstream in(p);
    std::string   content((std::istreambuf_iterator<char>(in)), {});
    std::size_t   n = 0, pos = 0;
    while ((pos = content.find(needle, pos)) != std::string::npos) {
        ++n;
        pos += needle.size();
    }
    return n;
}

} // namespace

// (a) p99-Parse: header-getrieben, n-a-tolerant. Alle 5 op_*_p99_ns numerisch → has_op_p99; EINE "n/a" → false.
TEST(Stufe05Pipeline, ParseWideCsvOpP99Columns) {
    auto p = comdare_user_tmp() / "p3_p99_parse.csv";
    fs::create_directories(p.parent_path());
    {
        std::ofstream f(p);
        f << "binary_id;ns_per_op;op_insert_p50_ns;op_insert_p99_ns;op_lookup_p50_ns;op_lookup_p99_ns;"
          << "op_erase_p50_ns;op_erase_p99_ns;op_scan_p50_ns;op_scan_p99_ns;op_rmw_p50_ns;op_rmw_p99_ns;"
          << "workload;two_phase_valid\n";
        f << "search_algo=k_ary/mapping=direct;1000;100;200;50;90;10;20;0;0;5;9;ycsb_c;1\n";
        // op_scan_p99_ns = n/a → has_op_p99=false, KEIN Parse-Gesamtfehler (n-a-tolerant).
        f << "search_algo=eytzinger/mapping=direct;1200;110;210;55;95;12;22;0;n/a;6;10;ycsb_c;1\n";
    }
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);
    ASSERT_EQ(rows.size(), 2u);
    EXPECT_TRUE(rows[0].has_op_p99);
    EXPECT_DOUBLE_EQ(rows[0].op_insert_p99_ns, 200.0);
    EXPECT_DOUBLE_EQ(rows[0].op_rmw_p99_ns, 9.0);
    EXPECT_FALSE(rows[1].has_op_p99); // eine n/a-Zelle → Zeile ohne p99 (honest)
    std::error_code ec;
    fs::remove(p, ec);
}

// (b) Range-Aggregat: Whisker-Top (Median p99) >= Punkt (Median p50) je Zelle (Monotonie); scan-No-Op- und
// 0-Op-Ausschluss; op-Arten ohne Daten (erase/rmw) fehlen; nearest-rank-Median deterministisch.
TEST(Stufe05Pipeline, LatencyRangeAggregateMonotoneAndExclusions) {
    auto p = comdare_user_tmp() / "p3_range_agg.csv";
    write_sample_wide_p99_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto const agg = dg::aggregate_latency_range(rows);
    ASSERT_EQ(agg.algos.size(), 2u);
    EXPECT_EQ(agg.algos[0], "eytzinger");
    EXPECT_EQ(agg.algos[1], "k_ary");
    // erase/rmw nie ausgefuehrt (p50=0) → NICHT als op-Zeile; scan nur via scan_wl (ycsb_e ausgeschlossen).
    ASSERT_EQ(agg.ops.size(), 3u);
    EXPECT_EQ(agg.ops[0], "insert");
    EXPECT_EQ(agg.ops[1], "lookup");
    EXPECT_EQ(agg.ops[2], "scan");

    // Monotonie: fuer JEDE vorhandene Zelle gilt Median-p99 >= Median-p50 (Whisker zeigt nach OBEN).
    // Geschweifte Klammern gegen -Wdangling-else (GCC meldet die klammerlose Fassung, clang nicht):
    // ein gtest-Makro traegt intern ein if/else, das ohne Klammern mehrdeutig an ein spaeter
    // hinzugefuegtes else binden koennte. Zusaetzlich der NENNER: ohne ihn wuerde ein Aggregat, in dem
    // keine einzige Zelle present ist, still null Zusicherungen ausfuehren und trotzdem gruen melden.
    std::size_t monotone_cells_checked = 0;
    for (std::size_t oi = 0; oi < agg.ops.size(); ++oi) {
        for (std::size_t ai = 0; ai < agg.algos.size(); ++ai) {
            if (!agg.present[oi][ai]) continue;
            ++monotone_cells_checked;
            EXPECT_GE(agg.p99_median[oi][ai], agg.p50_median[oi][ai])
                << "Zelle op=" << agg.ops[oi] << " algo=" << agg.algos[ai];
        }
    }
    RecordProperty("monotone_cells_checked", static_cast<int>(monotone_cells_checked));
    EXPECT_GT(monotone_cells_checked, 0u) << "keine einzige present-Zelle -- die Monotonie-Wache lief leer";

    // scan nur fuer k_ary (Index 1) vorhanden, NICHT fuer eytzinger; No-Op ycsb_e (1/2) ausgeschlossen →
    // Median bleibt 500/700 (nicht durch 1/2 verwaessert).
    EXPECT_FALSE(agg.present[2][0]); // scan × eytzinger
    ASSERT_TRUE(agg.present[2][1]);  // scan × k_ary
    EXPECT_DOUBLE_EQ(agg.p50_median[2][1], 500.0);
    EXPECT_DOUBLE_EQ(agg.p99_median[2][1], 700.0);
    // D5-2 KANON (2026-08-09), von Hand: k_ary insert p50 [100,120], n=2 (GERADE)
    //   k = ceil(0.5*2)-1 = 0 -> 100 (UNTERE Mitte); p99 [200,240] ebenso -> 200.
    // Vorher standen hier 120/240 -- die OBERE Mitte der verworfenen Formel round(q*(n-1)).
    // ACHTUNG: das ist ein Median ueber KONFIGURATIONEN (bereits aggregierte p50/p99 je
    // Algorithmus x Op-Art), nicht ueber Messproben. Dass der Kanon auch hier gilt, ist
    // begruendet entschieden -- siehe Code/common/percentile_canon.hpp, Abschnitt
    // GELTUNGSBEREICH. Die Monotonie-Zusicherung oben (p99 >= p50) bleibt erfuellt: 200 >= 100.
    EXPECT_DOUBLE_EQ(agg.p50_median[0][1], 100.0);
    EXPECT_DOUBLE_EQ(agg.p99_median[0][1], 200.0);
    std::error_code ec;
    fs::remove(p, ec);
}

// (c) Writer: valides pgfplots (Punkt+plus-Whisker, log-y), 1 addplot je op-Art, KEIN Box/Quartil-Artefakt.
TEST(Stufe05Pipeline, LatencyRangeBarEmitsWhiskersNoBoxplot) {
    auto p = comdare_user_tmp() / "p3_range_writer.csv";
    write_sample_wide_p99_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto out = comdare_user_tmp() / "p3_latency_range.tex";
    ASSERT_EQ(dg::write_latency_range_bar(out, rows, "de"), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "error bars"));
    EXPECT_TRUE(file_contains(out, "y dir=plus"));
    EXPECT_TRUE(file_contains(out, "ymode=log"));
    EXPECT_TRUE(file_contains(out, "+- (0,")); // plus-Whisker-Syntax
    EXPECT_EQ(p3_count(out, "\\addplot"), 3u); // insert/lookup/scan
    // (c) KEIN Box-Plot / erfundene Quartile.
    EXPECT_FALSE(file_contains(out, "boxplot"));
    EXPECT_FALSE(file_contains(out, "box plot"));
    EXPECT_FALSE(file_contains(out, "quartile"));
    EXPECT_FALSE(file_contains(out, "lower whisker"));
    std::error_code ec;
    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (d) ECDF: Population = ANZAHL KONFIGURATIONEN (nicht Einzel-Ops), sortiert; Treppe y∈[0,1]; Config-Streuung.
TEST(Stufe05Pipeline, LatencyEcdfConfigPopulationMonotone) {
    auto p = comdare_user_tmp() / "p3_ecdf.csv";
    write_sample_wide_p99_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto const series = dg::aggregate_latency_ecdf(rows);
    ASSERT_EQ(series.size(), 2u);
    EXPECT_EQ(series[0].algo, "eytzinger");
    EXPECT_EQ(series[1].algo, "k_ary");
    // k_ary: 4 gueltige Configs (A,B,C,D; ns_per_op 1000,1100,5000,900) — Population = Config-Anzahl.
    ASSERT_EQ(series[1].sorted_ns_per_op.size(), 4u);
    EXPECT_DOUBLE_EQ(series[1].sorted_ns_per_op.front(), 900.0); // aufsteigend sortiert
    EXPECT_DOUBLE_EQ(series[1].sorted_ns_per_op.back(), 5000.0);
    EXPECT_TRUE(std::is_sorted(series[1].sorted_ns_per_op.begin(), series[1].sorted_ns_per_op.end()));
    // eytzinger: nur E (F ist two_phase_valid=0 → verworfen).
    EXPECT_EQ(series[0].sorted_ns_per_op.size(), 1u);

    auto out = comdare_user_tmp() / "p3_latency_ecdf.tex";
    ASSERT_EQ(dg::write_latency_ecdf(out, rows, "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "const plot"));
    EXPECT_TRUE(file_contains(out, "ymin=0, ymax=1"));
    EXPECT_TRUE(file_contains(out, "xmode=log"));
    // Titel/xlabel weisen EXPLIZIT die Config-Streuung aus (NICHT Per-Operation).
    EXPECT_TRUE(file_contains(out, "distribution over configurations"));
    EXPECT_TRUE(file_contains(out, "1.0000")); // Treppe erreicht y=1
    EXPECT_EQ(p3_count(out, "\\addplot"), 2u);
    std::error_code ec;
    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (e) Guard: keine p99 (altes cowfix-v1-Schema ohne op_*_p99_ns) → Range honest leer. ECDF auf leerer Eingabe leer.
TEST(Stufe05Pipeline, LatencyDistributionGuardsHonestEmpty) {
    // Range: die bestehende p50-only-Fixture (kein p99) → has_op_p99=false → keine gueltige Zeile.
    auto p = comdare_user_tmp() / "p3_no_p99.csv";
    write_sample_wide_csv(p); // p50-only-Header (L-c), KEINE op_*_p99_ns-Spalten
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);
    for (auto const& r : rows) EXPECT_FALSE(r.has_op_p99);
    auto const agg = dg::aggregate_latency_range(rows);
    EXPECT_TRUE(agg.algos.empty());
    auto out = comdare_user_tmp() / "p3_range_empty.tex";
    EXPECT_EQ(dg::write_latency_range_bar(out, rows, "en"), dg::status_empty_input);

    // ECDF: leere Eingabe → honest leer.
    std::vector<dg::WideMeasurementRow> none;
    auto                                out2 = comdare_user_tmp() / "p3_ecdf_empty.tex";
    EXPECT_EQ(dg::write_latency_ecdf(out2, none, "en"), dg::status_empty_input);
    EXPECT_TRUE(dg::aggregate_latency_ecdf(none).empty());

    std::error_code ec;
    fs::remove(out, ec);
    fs::remove(out2, ec);
    fs::remove(p, ec);
}

// ─────────────────────────────────────────────────────────────────────────────
// INC-4 (2026-07-13) — Modus-2 Per-Achsen-Observer-Detail-Tabelle (stat_<achse>_<feld>)
// ─────────────────────────────────────────────────────────────────────────────
namespace {

// WIDE-full-Zeilen mit den c2l::parse_wide_csv_full-Pflichtspalten PLUS ausgewählten stat_<achse>_<feld>-Spalten.
// binary_id trägt BEIDE getesteten Achsen (search_algo + cache_traversal) → die Achse/Feld-Zerlegung des Writers
// nutzt das binary_id-Achsen-Vokabular (der reale Pfad), nicht den Fallback. all_na=true → alle stat_ = "n/a".
void write_observer_detail_wide_csv(fs::path const& p, bool all_na) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    f << "binary_id;ns_per_op;op_insert_p50_ns;op_lookup_p50_ns;op_erase_p50_ns;op_scan_p50_ns;op_rmw_p50_ns;"
      << "stat_search_algo_lookup;stat_search_algo_hit;stat_search_algo_miss;stat_cache_traversal_resolve_hit;"
      << "workload;two_phase_valid\n";
    // Spalten-Reihenfolge der stat_-Werte: lookup;hit;miss;resolve_hit. miss=n/a testet die honest-Auslassung
    // (NIE 0-erfunden). resolve_hit ist ein MEHR-Wort-Feld → beweist die Längster-Präfix-Zerlegung (cache_traversal
    // vs cache_traversal_resolve wäre falsch).
    if (all_na)
        f << "search_algo=k_ary/cache_traversal=direct;42.0;30;25;28;500;40;n/a;n/a;n/a;n/a;ycsb_c;1\n";
    else
        f << "search_algo=k_ary/cache_traversal=direct;42.0;30;25;28;500;40;12345;6789;n/a;4242;ycsb_c;1\n";
}

} // namespace

// (Phase 2.2) Parser durchreicht die stat_<achse>_<feld>-Spalten HEADER-GETRIEBEN (Roh-Wert als String, "n/a"
// unverändert) — keine Positions-Hartkodierung, kein Parse-Fehler durch die Zusatzspalten.
TEST(Stufe05Pipeline, ObserverDetailParserCarriesStatColumns) {
    auto p = comdare_user_tmp() / "inc4_stat_parse.csv";
    write_observer_detail_wide_csv(p, /*all_na=*/false);
    std::vector<c2l::WideFullRow> rows;
    ASSERT_EQ(c2l::parse_wide_csv_full(p, rows), c2l::status_ok);
    ASSERT_EQ(rows.size(), 1u);
    ASSERT_EQ(rows[0].stat.size(), 4u); // alle 4 stat_-Spalten mitgenommen (inkl. der n/a-Spalte)
    EXPECT_EQ(rows[0].stat.at("stat_search_algo_lookup"), "12345");
    EXPECT_EQ(rows[0].stat.at("stat_search_algo_hit"), "6789");
    EXPECT_EQ(rows[0].stat.at("stat_search_algo_miss"), "n/a"); // ehrlich n/a durchgereicht (NICHT 0)
    EXPECT_EQ(rows[0].stat.at("stat_cache_traversal_resolve_hit"), "4242");
    std::error_code ec;
    fs::remove(p, ec);
}

// (Phase 2, Test b) With-Fixture: Zeilen mit echten stat_-Werten → longtable mit EXAKT diesen gemessenen Werten.
// n/a-Feld (miss) wird ehrlich ausgelassen (kein 0), Mehr-Wort-Feld korrekt zerlegt (Achse cache_traversal).
TEST(Stufe05Pipeline, ObserverDetailTableWithFixtureRealValues) {
    auto p = comdare_user_tmp() / "inc4_stat_fixture.csv";
    write_observer_detail_wide_csv(p, /*all_na=*/false);
    std::vector<c2l::WideFullRow> rows;
    ASSERT_EQ(c2l::parse_wide_csv_full(p, rows), c2l::status_ok);

    auto            out = comdare_user_tmp() / "inc4_observer_detail.tex";
    std::error_code ec0;
    fs::remove(out, ec0);
    ASSERT_EQ(dg::write_axis_observer_detail_table(out, rows, "de"), dg::status_ok);
    ASSERT_TRUE(fs::exists(out));
    EXPECT_TRUE(file_contains(out, "longtable"));
    // Die drei ECHT gemessenen Werte stehen VERBATIM in der Tabelle.
    EXPECT_TRUE(file_contains(out, "12345"));
    EXPECT_TRUE(file_contains(out, "6789"));
    EXPECT_TRUE(file_contains(out, "4242"));
    // Achse/Feld-Zerlegung (escape_latex: '_' → "\\_").
    EXPECT_TRUE(file_contains(out, "search\\_algo"));
    EXPECT_TRUE(file_contains(out, "cache\\_traversal"));
    EXPECT_TRUE(file_contains(out, "resolve\\_hit")); // Mehr-Wort-Feld korrekt (nicht am ersten '_' gesplittet)
    // honest: das n/a-Feld (miss) erscheint NICHT (weder "n/a" noch der Feldname "miss") — kein 0-erfundener Wert.
    EXPECT_FALSE(file_contains(out, "n/a"));
    EXPECT_FALSE(file_contains(out, "miss"));
    fs::remove(out, ec0);
    fs::remove(p, ec0);
}

// (Phase 2, Test a) Honest-empty: (i) leere rows sowie (ii) rows mit ausschließlich n/a-stat_-Werten → der Writer
// legt KEINE Datei an (status_empty_input VOR dem ofstream, kein erfundener 0-Wert).
TEST(Stufe05Pipeline, ObserverDetailHonestEmptyNoFile) {
    // (i) leere Eingabe.
    std::vector<c2l::WideFullRow> none;
    auto                          out_none = comdare_user_tmp() / "inc4_observer_empty_none.tex";
    std::error_code               ec;
    fs::remove(out_none, ec);
    EXPECT_EQ(dg::write_axis_observer_detail_table(out_none, none, "en"), dg::status_empty_input);
    EXPECT_FALSE(fs::exists(out_none)); // KEINE Datei angelegt

    // (ii) rows vorhanden, aber ALLE stat_ = "n/a" (Nicht-Mess-DLL) → ebenfalls honest leer, keine Datei.
    auto p = comdare_user_tmp() / "inc4_stat_allna.csv";
    write_observer_detail_wide_csv(p, /*all_na=*/true);
    std::vector<c2l::WideFullRow> rows;
    ASSERT_EQ(c2l::parse_wide_csv_full(p, rows), c2l::status_ok);
    ASSERT_EQ(rows.size(), 1u);
    auto out_na = comdare_user_tmp() / "inc4_observer_empty_na.tex";
    fs::remove(out_na, ec);
    EXPECT_EQ(dg::write_axis_observer_detail_table(out_na, rows, "en"), dg::status_empty_input);
    EXPECT_FALSE(fs::exists(out_na)); // KEINE Datei angelegt

    fs::remove(p, ec);
}

// -----------------------------------------------------------------------------
// E-2a (2026-08-06) -- HONEST-EMPTY im Flaechen-Writer: op_<art>_n-Zaehler, Teil-/Voll-Datenlosigkeit
// -----------------------------------------------------------------------------
namespace {

// WIDE-Fixture MIT den Ausfuehrungs-Zaehlern op_<art>_n (Schema-treu zum realen Korpus, Beleg
// measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv). Aufbau bewusst wie D-03:
//   ns_per_op     -> VOLL-DATEN   (alle 4 Zellen ausgefuehrt)
//   op_lookup_*   -> VOLL-DATEN   (lookup laeuft in beiden Workloads)
//   op_insert_*   -> TEIL-DATENLOS(insert nur in ycsb_a; ycsb_c-Spalte nie ausgefuehrt)
//   op_erase_*    -> VOLL-DATENLOS(erase nie ausgefuehrt -> honest-empty-Platzhalter)
//   op_rmw_*      -> WIDERSPRUCH  (n==0, aber p50>0): der Zaehler gewinnt -> voll-datenlos.
void write_wide_csv_with_op_counts(fs::path const& p) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    f << "binary_id;ns_per_op;op_insert_n;op_insert_p50_ns;op_lookup_n;op_lookup_p50_ns;"
      << "op_erase_n;op_erase_p50_ns;op_scan_n;op_scan_p50_ns;op_rmw_n;op_rmw_p50_ns;"
      << "workload;two_phase_valid\n";
    f << "search_algo=k_ary/mapping=direct;1000;1000;100;2000;50;0;0;0;0;0;777;ycsb_a;1\n";
    f << "search_algo=k_ary/mapping=direct;1100;0;0;2000;60;0;0;0;0;0;777;ycsb_c;1\n";
    f << "search_algo=eytzinger/mapping=direct;1200;1500;120;2000;70;0;0;0;0;0;777;ycsb_a;1\n";
    f << "search_algo=eytzinger/mapping=direct;1300;0;0;2000;80;0;0;0;0;0;777;ycsb_c;1\n";
}

// Zaehlt die Koordinaten-Zeilen einer Heatmap, die ehrlich ausgelassen sind: Mesh-Traeger ",0)" + [nan].
std::size_t count_omitted_cells(fs::path const& p) { return count_occurrences(p, ",0) [nan]"); }

// REV 7.7/F1 (2026-08-13): 1x1-Smoke-Fixture, spiegelt Job 376333 (measure_out_smoke/e4_xml/
// measurements.csv): n_ops=10000, total_ns=11990468 -> ns_per_op=1199.047; op_lookup_n=10000,
// op_lookup_p50_ns=1310. Header schema-treu MIT allen 5 op_<art>_p50_ns-Pflichtspalten (parse_wide_csv
// required[]) und allen 5 op_<art>_n-Zaehlern (Zaehler = Primaerquelle der Ausgefuehrt-Klassifikation).
void write_wide_csv_smoke_1x1(fs::path const& p) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    f << "binary_id;ns_per_op;op_insert_n;op_insert_p50_ns;op_lookup_n;op_lookup_p50_ns;"
      << "op_erase_n;op_erase_p50_ns;op_scan_n;op_scan_p50_ns;op_rmw_n;op_rmw_p50_ns;"
      << "workload;two_phase_valid\n";
    f << "search_algo=k_ary/mapping=direct;1199.047;0;0;10000;1310;0;0;0;0;0;0;ycsb_c;1\n";
}

// REV 7.7/F1: 1xN/Nx1-Korpora -- two_workloads=true: 1 Algo x 2 Workloads (ny=1, nx=2);
// two_workloads=false: 2 Algos x 1 Workload (ny=2, nx=1). Beide GEMESSEN, beide unter dem 2x2-Minimum.
void write_wide_csv_smoke_degenerate(fs::path const& p, bool two_workloads) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    f << "binary_id;ns_per_op;op_insert_n;op_insert_p50_ns;op_lookup_n;op_lookup_p50_ns;"
      << "op_erase_n;op_erase_p50_ns;op_scan_n;op_scan_p50_ns;op_rmw_n;op_rmw_p50_ns;"
      << "workload;two_phase_valid\n";
    f << "search_algo=k_ary/mapping=direct;1199.047;0;0;10000;1310;0;0;0;0;0;0;ycsb_c;1\n";
    if (two_workloads) {
        f << "search_algo=k_ary/mapping=direct;1250.500;0;0;10000;1400;0;0;0;0;0;0;ycsb_a;1\n";
    } else {
        f << "search_algo=eytzinger/mapping=direct;1250.500;0;0;10000;1400;0;0;0;0;0;0;ycsb_c;1\n";
    }
}

} // namespace

// (a) Parser: die 5 op_<art>_n werden HEADER-GETRIEBEN mitgelesen; fehlt die Spaltengruppe (p50-only-
//     Bestandsschema), bleibt has_op_n=false -> BESTANDSVERHALTEN (p50>0-Heuristik).
TEST(Stufe05Pipeline, ParseWideCsvOpExecutionCounts) {
    auto p = comdare_user_tmp() / "e2a_op_counts_parse.csv";
    write_wide_csv_with_op_counts(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);
    ASSERT_EQ(rows.size(), 4u);
    EXPECT_TRUE(rows[0].has_op_n);
    EXPECT_EQ(rows[0].op_insert_n, 1000u);
    EXPECT_EQ(rows[0].op_lookup_n, 2000u);
    EXPECT_EQ(rows[0].op_erase_n, 0u);  // erase nie ausgefuehrt -> das Signal, das frueher verworfen wurde
    EXPECT_EQ(rows[1].op_insert_n, 0u); // ycsb_c ohne insert
    EXPECT_EQ(rows[0].op_rmw_n, 0u);    // Widerspruchs-Zeile: Zaehler 0 trotz p50=777
    EXPECT_DOUBLE_EQ(rows[0].op_rmw_p50_ns, 777.0);

    // Bestandsschema OHNE op_<art>_n-Spalten -> has_op_n=false, KEIN Parse-Fehler.
    auto p_old = comdare_user_tmp() / "e2a_op_counts_absent.csv";
    write_sample_wide_csv(p_old);
    std::vector<dg::WideMeasurementRow> old_rows;
    ASSERT_EQ(dg::parse_wide_csv(p_old, old_rows), dg::status_ok);
    ASSERT_FALSE(old_rows.empty());
    for (auto const& r : old_rows) EXPECT_FALSE(r.has_op_n);

    std::error_code ec;
    fs::remove(p, ec);
    fs::remove(p_old, ec);
}

// (b) VOLL-DATEN: jede Zelle ist ausgefuehrt -> echte Heatmap, KEINE ausgelassene Zelle, alle Messwerte
//     stehen verbatim in der .tex (Regressions-Wache: der honest-empty-Umbau darf echte Daten nicht fressen).
TEST(Stufe05Pipeline, SurfaceHeatmapFullDataHasNoOmittedCells) {
    auto p = comdare_user_tmp() / "e2a_surface_full.csv";
    write_wide_csv_with_op_counts(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto out = comdare_user_tmp() / "e2a_surface_lookup.tex";
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out, rows, "op_lookup_p50_ns", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "addplot3"));
    EXPECT_TRUE(file_contains(out, "colormap/viridis"));
    EXPECT_EQ(count_occurrences(out, "[nan]"), 0u); // 2x2 voll besetzt
    EXPECT_EQ(count_omitted_cells(out), 0u);
    // Die 4 nearest-rank-Mediane (je 1 Stichprobe) stehen als echte Koordinaten in der Datei.
    EXPECT_TRUE(file_contains(out, "50.0000"));
    EXPECT_TRUE(file_contains(out, "60.0000"));
    EXPECT_TRUE(file_contains(out, "70.0000"));
    EXPECT_TRUE(file_contains(out, "80.0000"));

    std::error_code ec;
    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (c) TEIL-DATENLOS: insert laeuft nur in ycsb_a. Die ycsb_c-Zellen sind NICHT gemessen und duerfen NICHT
//     als "0.0000" (erfundene 0-ns-Messung) erscheinen; sie werden ueber point meta = nan ausgelassen.
//     Die Achsen bleiben vollstaendig (2 Spalten) -- eine 1-spaltige matrix plot* waere pgfplots-fatal.
TEST(Stufe05Pipeline, SurfaceHeatmapPartialDataOmitsUnexecutedCells) {
    auto p = comdare_user_tmp() / "e2a_surface_partial.csv";
    write_wide_csv_with_op_counts(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto out = comdare_user_tmp() / "e2a_surface_insert.tex";
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out, rows, "op_insert_p50_ns", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "addplot3")); // echte Heatmap (Teil-Daten sind Daten)
    // Die 2 gemessenen Zellen (ycsb_a) stehen echt drin ...
    EXPECT_TRUE(file_contains(out, "100.0000"));
    EXPECT_TRUE(file_contains(out, "120.0000"));
    // ... die 2 nicht ausgefuehrten (ycsb_c) sind ehrlich ausgelassen, NICHT 0.0000-erfunden.
    EXPECT_EQ(count_omitted_cells(out), 2u);
    EXPECT_EQ(count_occurrences(out, "[nan]"), 2u);
    EXPECT_FALSE(file_contains(out, ",0.0000)"));
    // Beide Workload-Spalten bleiben erhalten (Achsen schrumpfen NICHT auf die Daten-Teilmenge).
    EXPECT_TRUE(file_contains(out, "ycsb\\_a"));
    EXPECT_TRUE(file_contains(out, "ycsb\\_c"));
    EXPECT_TRUE(file_contains(out, "mesh/cols=2"));

    std::error_code ec;
    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (d) VOLL-DATENLOS: erase wurde nie ausgefuehrt. Statt einer entarteten 0.0000-Heatmap (pgfplots-Fatal
//     "I got too few coordinates", Fixture-Beleg D-03) schreibt der Writer einen ehrlichen, kompilier-
//     faehigen Platzhalter-Vermerk -- Datei EXISTIERT (blankes \input in A_measurements.tex), status_ok.
TEST(Stufe05Pipeline, SurfaceHonestEmptyPlaceholderOnMetricWithoutData) {
    auto p = comdare_user_tmp() / "e2a_surface_empty.csv";
    write_wide_csv_with_op_counts(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "e2a_surface_erase.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out, rows, "op_erase_p50_ns", "de"), dg::status_ok);
    ASSERT_TRUE(fs::exists(out)); // Datei MUSS existieren (Kern-.tex haengt an blankem \input)
    // KEINE Figur, KEINE Koordinaten, KEINE erfundene Null.
    EXPECT_FALSE(file_contains(out, "addplot3"));
    EXPECT_FALSE(file_contains(out, "tikzpicture"));
    EXPECT_FALSE(file_contains(out, "colorbar"));
    EXPECT_FALSE(file_contains(out, "0.0000)"));
    // Ehrlicher Vermerk + Float-Mantel (kompilierfaehig).
    EXPECT_TRUE(file_contains(out, "HONEST-EMPTY"));
    EXPECT_TRUE(file_contains(out, "Keine Messwerte"));
    EXPECT_TRUE(file_contains(out, "\\begin{figure}"));
    EXPECT_TRUE(file_contains(out, "\\caption{"));

    // Der 3D-Pfad teilt dieselbe Aggregation und denselben Platzhalter (kein erfundener 1e-3-Boden).
    auto out3d = comdare_user_tmp() / "e2a_surface3d_erase.tex";
    fs::remove(out3d, ec);
    ASSERT_EQ(dg::write_surface3d_search_algo_x_workload(out3d, rows, "op_erase_p50_ns", "en"), dg::status_ok);
    ASSERT_TRUE(fs::exists(out3d));
    EXPECT_FALSE(file_contains(out3d, "addplot3[surf]"));
    EXPECT_FALSE(file_contains(out3d, "0.0010")); // der 1.0e-3-Darstellungsboden taucht NICHT auf
    EXPECT_TRUE(file_contains(out3d, "No measured values"));

    fs::remove(out, ec);
    fs::remove(out3d, ec);
    fs::remove(p, ec);
}

// (e) Der ZAEHLER ist die Primaerquelle: op_rmw_n==0 bei op_rmw_p50_ns==777 (widerspruechliche Zeile) gilt
//     als NICHT ausgefuehrt -> voll-datenlos. Ohne den Zaehler (Bestandsschema) greift weiter p50>0.
TEST(Stufe05Pipeline, SurfaceExecutionCounterOverridesP50Heuristic) {
    auto p = comdare_user_tmp() / "e2a_counter_wins.csv";
    write_wide_csv_with_op_counts(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "e2a_surface_rmw.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out, rows, "op_rmw_p50_ns", "en"), dg::status_ok);
    EXPECT_FALSE(file_contains(out, "addplot3")); // Zaehler gewinnt -> Platzhalter statt Heatmap
    EXPECT_FALSE(file_contains(out, "777.0000")); // die widerspruechliche p50 wird NICHT geplottet
    EXPECT_TRUE(file_contains(out, "HONEST-EMPTY"));

    // Bestandsverhalten: dieselbe Metrik-Klasse OHNE op_<art>_n-Spalten -> p50>0-Heuristik -> echte Heatmap.
    auto p_old = comdare_user_tmp() / "e2a_counter_absent.csv";
    write_sample_wide_csv(p_old); // p50-only-Schema, op_scan_p50_ns = 500/600 > 0
    std::vector<dg::WideMeasurementRow> old_rows;
    ASSERT_EQ(dg::parse_wide_csv(p_old, old_rows), dg::status_ok);
    auto out_old = comdare_user_tmp() / "e2a_surface_scan_legacy.tex";
    fs::remove(out_old, ec);
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out_old, old_rows, "op_scan_p50_ns", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out_old, "addplot3"));
    EXPECT_TRUE(file_contains(out_old, "500.0000"));

    fs::remove(out, ec);
    fs::remove(out_old, ec);
    fs::remove(p, ec);
    fs::remove(p_old, ec);
}

// -----------------------------------------------------------------------------
// REV 7.7/F1 (2026-08-13) -- GROESSEN-WACHE: eine GEMESSENE Matrix unter dem 2x2-Minimum von
// pgfplots' matrix input=image (1x1/1xN/Nx1) ist kompilier-fatal ("'matrix input=image' is
// unsupported for line plots (or matrix plots with just 1 row or 1 column)"; Proben 13.08.2026,
// texlive 2026, compat=1.18: 1x1 rc=1, 1x2 rc=1, 2x2 rc=0). Der F1-Smoke-Korpus (Job 376333) ist
// GENAU dieser Fall: 1 Suchalgorithmus x 1 Workload, ns_per_op=1199.047. Die Datenlos-Wache (E-2a)
// greift dort NICHT, denn die Zelle IST gemessen -> eigener GROESSEN-Platzhalter, der ausdruecklich
// NICHT "nie ausgefuehrt" behauptet.
// -----------------------------------------------------------------------------

// (f1-a) 1x1 GEMESSEN -> ehrlicher GROESSEN-Platzhalter: status_ok, Datei existiert (blankes \input in
//        A_measurements.tex), KEIN matrix plot, KEIN addplot3 -- und der Vermerk nennt Groesse (1x1)
//        und Minimum (2x2) statt der falschen Datenlos-Behauptung.
TEST(Stufe05Pipeline, Surface1x1IsHonestSizePlaceholder) {
    auto p = comdare_user_tmp() / "f1_smoke_1x1.csv";
    write_wide_csv_smoke_1x1(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);
    ASSERT_EQ(rows.size(), 1u);

    std::error_code ec;

    // -- de, ns_per_op (die F1-PDF-Tabellenzeile haengt an genau dieser Flaeche) --
    auto out_de = comdare_user_tmp() / "f1_surface_1x1_de.tex";
    fs::remove(out_de, ec);
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out_de, rows, "ns_per_op", "de"), dg::status_ok);
    ASSERT_TRUE(fs::exists(out_de));
    EXPECT_FALSE(file_contains(out_de, "matrix plot"));
    EXPECT_FALSE(file_contains(out_de, "addplot3"));
    EXPECT_TRUE(file_contains(out_de, "HONEST-EMPTY"));
    EXPECT_TRUE(file_contains(out_de, "\\begin{figure}"));
    // EHRLICHKEIT: die Zelle IST gemessen -- der Vermerk darf die Datenlos-Behauptung NICHT tragen ...
    EXPECT_FALSE(file_contains(out_de, "nie ausgefuehrt"));
    EXPECT_FALSE(file_contains(out_de, "never executed"));
    // ... sondern nennt die Groesse und das Minimum. S-1 (2026-09-16): in der MATHE-Form des
    // Bestands (Hand-Fix 26f88a0) -- "1x1"/"2x2" sind chktex-W29 (am Objekt gemessen: Ziffer-x-Ziffer
    // beisst, Wort-x-Wort nicht), und der Emitter drehte die Hand-Korrektur bei jedem Lauf zurueck.
    EXPECT_TRUE(file_contains(out_de, "nur als $1{\\times}1$-Matrix vor (Suchalgorithmen $\\times$ Workloads)"));
    EXPECT_TRUE(file_contains(out_de, "verlangt mindestens $2{\\times}2$."));
    EXPECT_FALSE(file_contains(out_de, "1x1-Matrix")); // die chktex-rote Vorform darf NICHT zurueckkehren
    // F1-FIX (2026-08-13, Lens-Fund e-ii): 1x1 traegt GENAU EINEN Messwert -> Singular ist hier richtig.
    EXPECT_TRUE(file_contains(out_de, "Der Messwert selbst ist"));
    EXPECT_FALSE(file_contains(out_de, "Die Messwerte selbst sind"));

    // -- en, op_lookup_p50_ns (zweite fatale Flaeche des 64er-Sets) --
    auto out_en = comdare_user_tmp() / "f1_surface_1x1_en.tex";
    fs::remove(out_en, ec);
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out_en, rows, "op_lookup_p50_ns", "en"), dg::status_ok);
    ASSERT_TRUE(fs::exists(out_en));
    EXPECT_FALSE(file_contains(out_en, "matrix plot"));
    EXPECT_FALSE(file_contains(out_en, "addplot3"));
    EXPECT_TRUE(file_contains(out_en, "HONEST-EMPTY"));
    EXPECT_TRUE(file_contains(out_en, "\\begin{figure}"));
    EXPECT_FALSE(file_contains(out_en, "never executed"));
    EXPECT_FALSE(file_contains(out_en, "nie ausgefuehrt"));
    EXPECT_TRUE(file_contains(out_en, "spans only a $1{\\times}1$ matrix (search algorithms $\\times$ workloads)"));
    EXPECT_TRUE(file_contains(out_en, "requires at least $2{\\times}2$."));
    EXPECT_FALSE(file_contains(out_en, "1x1 matrix"));
    // F1-FIX (Lens-Fund e-ii): Singular auch in der en-Fassung -- genau ein Messwert im 1x1-Korpus.
    EXPECT_TRUE(file_contains(out_en, "The measured value itself is"));
    EXPECT_FALSE(file_contains(out_en, "The measured values themselves are"));

    fs::remove(out_de, ec);
    fs::remove(out_en, ec);
    fs::remove(p, ec);
}

// (f1-b) 1xN und Nx1: auch mit ZWEI gemessenen Zellen bleibt die Matrix unter dem 2x2-Minimum
//        (Probe 13.08.: 1 Zeile x 2 Spalten rc=1) -> Platzhalter, status_ok, Groesse im Vermerk.
TEST(Stufe05Pipeline, Surface1xNAndNx1ArePlaceholders) {
    std::error_code ec;

    // ny=1, nx=2 (1 Algo x 2 Workloads)
    auto p_row = comdare_user_tmp() / "f1_smoke_1x2.csv";
    write_wide_csv_smoke_degenerate(p_row, /*two_workloads=*/true);
    std::vector<dg::WideMeasurementRow> rows_row;
    ASSERT_EQ(dg::parse_wide_csv(p_row, rows_row), dg::status_ok);
    auto out_row = comdare_user_tmp() / "f1_surface_1x2.tex";
    fs::remove(out_row, ec);
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out_row, rows_row, "ns_per_op", "en"), dg::status_ok);
    ASSERT_TRUE(fs::exists(out_row));
    EXPECT_FALSE(file_contains(out_row, "matrix plot"));
    EXPECT_FALSE(file_contains(out_row, "addplot3"));
    EXPECT_TRUE(file_contains(out_row, "HONEST-EMPTY"));
    EXPECT_FALSE(file_contains(out_row, "never executed"));
    EXPECT_TRUE(file_contains(out_row, "spans only a $1{\\times}2$ matrix"));
    EXPECT_FALSE(file_contains(out_row, "1x2 matrix"));
    // F1-FIX (2026-08-13, Lens-Fund e-ii): ZWEI gemessene Zellen -> der Vermerk muss den Plural tragen.
    // Der fruehere Pauschal-Singular ("The measured value itself is") behauptete EINEN Messwert, wo zwei
    // im Korpus stehen -- dieselbe Ehrlichkeitsklasse wie die nie-ausgefuehrt-Wache, nur im Numerus.
    EXPECT_TRUE(file_contains(out_row, "The measured values themselves are"));
    EXPECT_FALSE(file_contains(out_row, "The measured value itself is"));

    // ny=2, nx=1 (2 Algos x 1 Workload)
    auto p_col = comdare_user_tmp() / "f1_smoke_2x1.csv";
    write_wide_csv_smoke_degenerate(p_col, /*two_workloads=*/false);
    std::vector<dg::WideMeasurementRow> rows_col;
    ASSERT_EQ(dg::parse_wide_csv(p_col, rows_col), dg::status_ok);
    auto out_col = comdare_user_tmp() / "f1_surface_2x1.tex";
    fs::remove(out_col, ec);
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out_col, rows_col, "ns_per_op", "de"), dg::status_ok);
    ASSERT_TRUE(fs::exists(out_col));
    EXPECT_FALSE(file_contains(out_col, "matrix plot"));
    EXPECT_FALSE(file_contains(out_col, "addplot3"));
    EXPECT_TRUE(file_contains(out_col, "HONEST-EMPTY"));
    EXPECT_FALSE(file_contains(out_col, "nie ausgefuehrt"));
    EXPECT_TRUE(file_contains(out_col, "nur als $2{\\times}1$-Matrix vor"));
    EXPECT_FALSE(file_contains(out_col, "2x1-Matrix"));
    // F1-FIX (Lens-Fund e-ii): auch die de-Fassung zaehlt -- zwei Messwerte, also Plural.
    EXPECT_TRUE(file_contains(out_col, "Die Messwerte selbst sind"));
    EXPECT_FALSE(file_contains(out_col, "Der Messwert selbst ist"));

    fs::remove(out_row, ec);
    fs::remove(out_col, ec);
    fs::remove(p_row, ec);
    fs::remove(p_col, ec);
}

// (f1-c) ratio-Pfad mit Referenz IM Korpus: die 1x1-Verhaeltnis-Matrix (k_ary/k_ary = 1.0) traegt ein
//        Datum, faellt also NICHT unter die Datenlos-Wache -> auch hier GROESSEN-Platzhalter.
//        (Der reale Smoke-Lauf nahm Referenz linear_scan -> have_ref=false -> Datenlos-Platzhalter;
//        Referenz k_ary trifft gezielt den 1x1-MIT-DATEN-Pfad.)
TEST(Stufe05Pipeline, Ratio1x1IsHonestSizePlaceholder) {
    auto p = comdare_user_tmp() / "f1_smoke_ratio_1x1.csv";
    write_wide_csv_smoke_1x1(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "f1_surface_ratio_1x1.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_surface_ratio_vs_reference(out, rows, "ns_per_op", "k_ary", "de"), dg::status_ok);
    ASSERT_TRUE(fs::exists(out));
    EXPECT_FALSE(file_contains(out, "matrix plot"));
    EXPECT_FALSE(file_contains(out, "addplot3"));
    EXPECT_TRUE(file_contains(out, "HONEST-EMPTY"));
    EXPECT_TRUE(file_contains(out, "\\begin{figure}"));
    EXPECT_FALSE(file_contains(out, "nie ausgefuehrt"));
    EXPECT_FALSE(file_contains(out, "never executed"));
    // S-1: auch der ratio-Pfad traegt die Mathe-Form des Bestands, nicht "1x1".
    EXPECT_TRUE(file_contains(out, "nur als $1{\\times}1$-Matrix vor (Suchalgorithmen $\\times$ Workloads)"));
    EXPECT_TRUE(file_contains(out, "verlangt mindestens $2{\\times}2$."));
    EXPECT_FALSE(file_contains(out, "1x1-Matrix"));

    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (f1-d) GEGENKOEDER gegen Ueberblocken: ein 2x2-Korpus bleibt eine ECHTE Figur (matrix plot*),
//        kein Groessen-Platzhalter. (Bestandstest WriteSurfaceHeatmapFromWide deckt 2x2 zusaetzlich.)
TEST(Stufe05Pipeline, Surface2x2StaysRealFigure) {
    auto p = comdare_user_tmp() / "f1_smoke_2x2.csv";
    write_wide_csv_with_op_counts(p); // Bestands-Fixture: 2 Algos x 2 Workloads
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "f1_surface_2x2.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out, rows, "ns_per_op", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "matrix plot*"));
    EXPECT_TRUE(file_contains(out, "addplot3"));
    EXPECT_FALSE(file_contains(out, "HONEST-EMPTY (Groesse)"));

    fs::remove(out, ec);
    fs::remove(p, ec);
}

// -----------------------------------------------------------------------------
// E-2b (2026-08-06) -- GRENZFALL "ECHT GEMESSENE 0": op_<art>_n > 0 UND p50 == 0.
// Die Operation LIEF, ihr Median ist nur exakt 0 ns. Das ist ein MESSWERT und muss dargestellt werden --
// vorher galt allein "Wert > 0" als Datum, also fiel die echte 0 unter "nie ausgefuehrt" (Auslass) und
// eine Flaeche aus lauter echten Nullen bekam sogar den "never executed"-Platzhalter.
// -----------------------------------------------------------------------------
namespace {

// counter_mode: 0 = alle 5 op_<art>_n vorhanden (Ausfuehrungs-Wahrheit steht in der CSV),
//               1 = GENAU EINE Zaehler-Spalte fehlt (op_scan_n)  -> has_op_n=false fuer ALLE Zeilen,
//               2 = alle Spalten da, GENAU EINE ZELLE "n/a" (op_scan_n der 1. Zeile) -> has_op_n faellt
//                   NUR fuer diese eine Zeile (Zeilen-genaue n-a-Toleranz).
// Achsen-Sortierung des Aggregats: y = {eytzinger=0, k_ary=1}, x = {ycsb_a=0, ycsb_c=1}.
//   op_insert_* -> GEMISCHT   : (0,1)=echte 0 [k_ary/ycsb_a], sonst 100/200/300 ns.
//   op_lookup_* -> NUR NULLEN : alle 4 Zellen ausgefuehrt (n=2000) mit p50 == 0.
//   op_erase_*  -> NIE AUSGEFUEHRT (n==0) -- Kontrast-Kontrolle, muss Platzhalter bleiben.
void write_wide_csv_with_true_zeros(fs::path const& p, int counter_mode) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    bool const    drop_scan_n = (counter_mode == 1);
    f << "binary_id;ns_per_op;op_insert_n;op_insert_p50_ns;op_lookup_n;op_lookup_p50_ns;"
      << "op_erase_n;op_erase_p50_ns;";
    if (!drop_scan_n) f << "op_scan_n;";
    f << "op_scan_p50_ns;op_rmw_n;op_rmw_p50_ns;workload;two_phase_valid\n";

    // (algo, workload, ns_per_op, op_insert_n, op_insert_p50_ns) -- lookup ist ueberall n=2000/p50=0.
    struct RowSpec {
        char const* algo;
        char const* workload;
        int         ns_per_op;
        int         insert_n;
        int         insert_p50;
    };
    RowSpec const specs[] = {
        {"k_ary", "ycsb_a", 1000, 1000, 0}, // <- die ECHT GEMESSENE 0 (Zaehler 1000, Median 0 ns)
        {"k_ary", "ycsb_c", 1100, 1000, 100},
        {"eytzinger", "ycsb_a", 1200, 1500, 200},
        {"eytzinger", "ycsb_c", 1300, 1500, 300},
    };
    std::size_t i = 0;
    for (auto const& s : specs) {
        f << "search_algo=" << s.algo << "/mapping=direct;" << s.ns_per_op << ";"    //
          << s.insert_n << ";" << s.insert_p50 << ";"                                // insert
          << "2000;0;"                                                               // lookup: ausgefuehrt, echt 0
          << "0;0;";                                                                 // erase: nie ausgefuehrt
        if (!drop_scan_n) f << ((counter_mode == 2 && i == 0) ? "n/a" : "0") << ";"; // scan-Zaehler
        f << "0;"                                                                    // op_scan_p50_ns
          << "0;0;"                                                                  // rmw: nie ausgefuehrt
          << s.workload << ";1\n";
        ++i;
    }
}

} // namespace

// (t1) Eine ECHT GEMESSENE 0 ist ein DARSTELLBARER Wert -- weder Auslass noch Platzhalter, in 2D UND 3D.
TEST(Stufe05Pipeline, SurfaceTrueZeroCellIsPlottedNotOmitted) {
    auto p = comdare_user_tmp() / "e2b_true_zero_mixed.csv";
    write_wide_csv_with_true_zeros(p, /*counter_mode=*/0);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);
    ASSERT_EQ(rows.size(), 4u);
    ASSERT_TRUE(rows[0].has_op_n);
    EXPECT_EQ(rows[0].op_insert_n, 1000u);           // ausgefuehrt ...
    EXPECT_DOUBLE_EQ(rows[0].op_insert_p50_ns, 0.0); // ... und exakt 0 ns gemessen

    // -- 2D --
    auto            out = comdare_user_tmp() / "e2b_surface_insert.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out, rows, "op_insert_p50_ns", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "matrix plot*"));           // echte Figur ...
    EXPECT_FALSE(file_contains(out, "Metrik ohne Messwerte")); // ... KEIN Platzhalter
    EXPECT_EQ(count_occurrences(out, "[nan]"), 0u);            // und KEINE ausgelassene Zelle
    // Die 0 steht als ECHTER Wert (4 Nachkommastellen) mit ehrlichem Meta = eigene 0-Klasse eine Dekade
    // unter der kleinsten gemessenen Dekade (kleinster positiver Wert 100 -> floor(log10)=2 -> Klasse 1).
    EXPECT_TRUE(file_contains(out, "(0,1,0.0000) [1.0000]"));
    EXPECT_TRUE(file_contains(out, "point meta min=1.0000"));
    // Der unterste Colorbar-Tick ist literal "0" -- keine erfundene 10^k-Behauptung fuer die 0-Klasse.
    EXPECT_TRUE(file_contains(out, "yticklabels={$0$,$10^{2}$,$10^{3}$}"));
    // Die positiven Nachbarzellen bleiben unveraendert.
    EXPECT_TRUE(file_contains(out, "100.0000"));
    EXPECT_TRUE(file_contains(out, "200.0000"));
    EXPECT_TRUE(file_contains(out, "300.0000"));

    // -- 3D --
    auto out3d = comdare_user_tmp() / "e2b_surface3d_insert.tex";
    fs::remove(out3d, ec);
    ASSERT_EQ(dg::write_surface3d_search_algo_x_workload(out3d, rows, "op_insert_p50_ns", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out3d, "addplot3[surf]"));
    EXPECT_TRUE(file_contains(out3d, "(0,1,0.0000)")); // die 0 ist ein ECHTER Vertex ...
    EXPECT_FALSE(file_contains(out3d, "0.0010"));      // ... und kein Phantom-Boden
    EXPECT_EQ(count_occurrences(out3d, "nan)"), 0u);   // keine Zelle ausgelassen (alle 4 ausgefuehrt)
    // z-Achse faellt auf LINEAR: eine log-Achse koennte die gemessene 0 weder zeigen noch ehrlich ersetzen.
    EXPECT_FALSE(file_contains(out3d, "zmode=log"));
    EXPECT_TRUE(file_contains(out3d, "unbounded coords=jump"));

    // Kontrast-Kontrolle: erase (n==0 in allen Zeilen) bleibt der ehrliche Platzhalter.
    auto out_erase = comdare_user_tmp() / "e2b_surface_erase.tex";
    fs::remove(out_erase, ec);
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out_erase, rows, "op_erase_p50_ns", "en"), dg::status_ok);
    EXPECT_FALSE(file_contains(out_erase, "matrix plot*"));
    EXPECT_TRUE(file_contains(out_erase, "Metrik ohne Messwerte"));

    fs::remove(out, ec);
    fs::remove(out3d, ec);
    fs::remove(out_erase, ec);
    fs::remove(p, ec);
}

// (t2) Eine Matrix NUR aus echten Nullen ist GEMESSEN -> KEIN Platzhalter, sondern eine Flaeche mit genau
//      einer ehrlich beschrifteten 0-Farbklasse (2D + 3D). Vorher: "never executed"-Platzhalter (falsch).
TEST(Stufe05Pipeline, SurfaceAllTrueZeroMatrixIsNoPlaceholder) {
    auto p = comdare_user_tmp() / "e2b_true_zero_all.csv";
    write_wide_csv_with_true_zeros(p, /*counter_mode=*/0);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    // -- 2D: alle 4 Zellen sind ausgefuehrte Nullen --
    auto            out = comdare_user_tmp() / "e2b_surface_lookup.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out, rows, "op_lookup_p50_ns", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "matrix plot*"));
    EXPECT_FALSE(file_contains(out, "Metrik ohne Messwerte"));  // KEIN Platzhalter
    EXPECT_EQ(count_occurrences(out, "[nan]"), 0u);             // KEIN Auslass
    EXPECT_EQ(count_occurrences(out, ",0.0000) [0.0000]"), 4u); // 4 echte Nullen in der 0-Klasse
    // Nicht-entartete Farb-Domaene + Ein-Klassen-Colorbar (die [0.0:0.0]-Domaene war der pgfplots-Fatal).
    EXPECT_TRUE(file_contains(out, "point meta min=0.0000"));
    EXPECT_TRUE(file_contains(out, "point meta max=1.0000"));
    EXPECT_TRUE(file_contains(out, "colorbar style={ytick={0}, yticklabels={$0$}}"));
    EXPECT_TRUE(file_contains(out, "zmin=0, zmax=1"));

    // -- 3D: dieselbe Flaeche, lineare z-Achse, aufgeweitete (nicht entartete) Domaene --
    auto out3d = comdare_user_tmp() / "e2b_surface3d_lookup.tex";
    fs::remove(out3d, ec);
    ASSERT_EQ(dg::write_surface3d_search_algo_x_workload(out3d, rows, "op_lookup_p50_ns", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out3d, "addplot3[surf]"));
    EXPECT_FALSE(file_contains(out3d, "zmode=log"));
    EXPECT_FALSE(file_contains(out3d, "0.0010"));
    EXPECT_EQ(count_occurrences(out3d, ",0.0000)"), 4u);
    EXPECT_TRUE(file_contains(out3d, "point meta min=0.0000, point meta max=1.0000"));
    EXPECT_TRUE(file_contains(out3d, "zmin=0.0000, zmax=1.0000"));

    fs::remove(out, ec);
    fs::remove(out3d, ec);
    fs::remove(p, ec);
}

// (t3) GENAU EINE fehlende bzw. "n/a" Zaehler-Spalte -> dokumentiertes Fallback: has_op_n faellt (fehlende
//      Spalte: fuer ALLE Zeilen; einzelne n-a-Zelle: NUR fuer diese Zeile) und die betroffene Zeile wird
//      wieder nach der p50>0-Heuristik beurteilt = BESTANDSVERHALTEN. Die echte 0 ist dann nicht mehr von
//      "nicht ausgefuehrt" unterscheidbar und wird ausgelassen -- ehrlich, weil die Wahrheit fehlt.
TEST(Stufe05Pipeline, SurfaceOneMissingCounterColumnFallsBackToP50Heuristic) {
    std::error_code ec;

    // (i) GENAU EINE Spalte fehlt (op_scan_n) -> has_op_n=false fuer ALLE Zeilen.
    auto p_missing = comdare_user_tmp() / "e2b_counter_col_missing.csv";
    write_wide_csv_with_true_zeros(p_missing, /*counter_mode=*/1);
    std::vector<dg::WideMeasurementRow> rows_missing;
    ASSERT_EQ(dg::parse_wide_csv(p_missing, rows_missing), dg::status_ok); // KEIN Parse-Fehler
    ASSERT_EQ(rows_missing.size(), 4u);
    for (auto const& r : rows_missing) EXPECT_FALSE(r.has_op_n);

    // insert: die echte 0 faellt unter die Heuristik -> genau EINE ausgelassene Zelle, 3 echte Werte.
    auto out_ins = comdare_user_tmp() / "e2b_fallback_insert.tex";
    fs::remove(out_ins, ec);
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out_ins, rows_missing, "op_insert_p50_ns", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out_ins, "matrix plot*"));
    EXPECT_EQ(count_occurrences(out_ins, ",0) [nan]"), 1u);
    EXPECT_FALSE(file_contains(out_ins, ",0.0000)")); // keine erfundene 0-ns-Messung
    EXPECT_TRUE(file_contains(out_ins, "100.0000"));

    // lookup (nur echte Nullen): ohne Zaehler sieht die Heuristik NICHTS -> Platzhalter (Bestandsverhalten).
    auto out_lookup = comdare_user_tmp() / "e2b_fallback_lookup.tex";
    fs::remove(out_lookup, ec);
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out_lookup, rows_missing, "op_lookup_p50_ns", "en"),
              dg::status_ok);
    ASSERT_TRUE(fs::exists(out_lookup)); // Datei MUSS existieren (blankes \input)
    EXPECT_FALSE(file_contains(out_lookup, "matrix plot*"));
    EXPECT_TRUE(file_contains(out_lookup, "Metrik ohne Messwerte"));

    // (ii) alle Spalten da, GENAU EINE ZELLE "n/a" -> has_op_n faellt NUR fuer diese Zeile.
    auto p_na = comdare_user_tmp() / "e2b_counter_cell_na.csv";
    write_wide_csv_with_true_zeros(p_na, /*counter_mode=*/2);
    std::vector<dg::WideMeasurementRow> rows_na;
    ASSERT_EQ(dg::parse_wide_csv(p_na, rows_na), dg::status_ok);
    ASSERT_EQ(rows_na.size(), 4u);
    EXPECT_FALSE(rows_na[0].has_op_n); // nur die n-a-Zeile verliert die Wahrheit ...
    EXPECT_TRUE(rows_na[1].has_op_n);  // ... die uebrigen behalten sie
    EXPECT_TRUE(rows_na[2].has_op_n);
    EXPECT_TRUE(rows_na[3].has_op_n);

    // lookup: 3 Zeilen mit Zaehler -> 3 dargestellte echte Nullen; die n-a-Zeile faellt auf die Heuristik
    // zurueck und wird als einzige ausgelassen. KEIN Platzhalter (die Flaeche traegt Messwerte).
    auto out_na = comdare_user_tmp() / "e2b_fallback_cell_na_lookup.tex";
    fs::remove(out_na, ec);
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out_na, rows_na, "op_lookup_p50_ns", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out_na, "matrix plot*"));
    EXPECT_FALSE(file_contains(out_na, "Metrik ohne Messwerte"));
    EXPECT_EQ(count_occurrences(out_na, ",0.0000) [0.0000]"), 3u);
    EXPECT_EQ(count_occurrences(out_na, ",0) [nan]"), 1u);

    fs::remove(out_ins, ec);
    fs::remove(out_lookup, ec);
    fs::remove(out_na, ec);
    fs::remove(p_missing, ec);
    fs::remove(p_na, ec);
}

// -----------------------------------------------------------------------------
// GRAPH-UMBAU 2D/3D, P1b (2026-08-06) -- Working-Set-Sweep-Kurve.
// Die Form war seit A2 gebaut, aber NIRGENDS verdrahtet; erst die Verdrahtung in die Anhang-Facade hat
// zwei Fehler sichtbar gemacht, die diese Tests festhalten:
//   (a) Beschriftungs-Zerlegung: write_pgfplots_axis_options escaped JEDE Beschriftung -- die frueheren
//       Labels trugen Mathe-Modus und eine LaTeX-Umlaut-Sequenz und erschienen literal als "\$n\$" und
//       "Schl\textbackslash{}"ussel" im PDF.
//   (b) entartete x-Achse: traegt der Korpus nur EINEN working_set_n (d03: durchgaengig 4096), gilt
//       xmin==xmax -> pgfplots-Warnung "Axis range for axis x is approximately empty".
// -----------------------------------------------------------------------------
namespace {

// working_set_n-Spalte optional (has_ws=false spiegelt den cowfix-v1-Korpus OHNE die Spalte).
// single_ws=true -> ALLE Zeilen tragen denselben working_set_n (der d03-Fall, entartete Achse).
void write_wide_csv_with_working_set(fs::path const& p, bool has_ws, bool single_ws) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    f << "binary_id;ns_per_op;op_insert_p50_ns;op_lookup_p50_ns;op_erase_p50_ns;"
      << "op_scan_p50_ns;op_rmw_p50_ns;";
    if (has_ws) f << "working_set_n;";
    f << "workload;two_phase_valid\n";

    struct RowSpec {
        char const*   algo;
        std::uint64_t ws;
        double        ns;
    };
    // 2 Reihen (k_ary, eytzinger) x 2 Arbeitsmengen -- bei single_ws kollabieren beide auf 4096.
    RowSpec const specs[] = {
        {"k_ary", 4096, 100.0}, {"k_ary", 8192, 180.0}, {"eytzinger", 4096, 90.0}, {"eytzinger", 8192, 150.0}};
    for (auto const& s : specs) {
        f << "search_algo=" << s.algo << "/mapping=direct;" << s.ns << ";10.0;20.0;30.0;40.0;50.0;";
        if (has_ws) f << (single_ws ? 4096U : s.ws) << ";";
        f << "ycsb_c;1\n";
    }
}

} // namespace

// (P1b-t1) BESTANDSVERHALTEN: ohne working_set_n-Spalte gibt es keine Punkte -> honest-empty.
// KEINE Datei, KEIN Crash -- das ist der Grund, warum das Wiring auf cowfix-v1-Korpora risikofrei ist.
TEST(Stufe05Pipeline, SweepCurveHonestEmptyWithoutWorkingSetColumn) {
    auto p = comdare_user_tmp() / "p1b_no_ws.csv";
    write_wide_csv_with_working_set(p, /*has_ws=*/false, /*single_ws=*/false);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);
    ASSERT_EQ(rows.size(), 4u);
    for (auto const& r : rows) EXPECT_FALSE(r.has_working_set_n);

    auto            out = comdare_user_tmp() / "p1b_sweep_empty.tex";
    std::error_code ec;
    fs::remove(out, ec);
    EXPECT_EQ(dg::write_working_set_sweep_curve(out, rows, "ns_per_op", "en"), dg::status_empty_input);
    EXPECT_FALSE(fs::exists(out)); // honest-empty: KEINE Datei

    fs::remove(p, ec);
}

// (P1b-t2) Mit echtem Sweep: eine Kurve je Reihe, die Punkte sind die gemessenen Stuetzstellen.
// Die Achse wird NICHT aufgeweitet (zwei verschiedene working_set_n -> Spanne ist echt).
TEST(Stufe05Pipeline, SweepCurveEmitsOneCurvePerSeriesAndKeepsRealAxisRange) {
    auto p = comdare_user_tmp() / "p1b_real_sweep.csv";
    write_wide_csv_with_working_set(p, /*has_ws=*/true, /*single_ws=*/false);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);
    for (auto const& r : rows) EXPECT_TRUE(r.has_working_set_n);

    auto            out = comdare_user_tmp() / "p1b_sweep_real.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_working_set_sweep_curve(out, rows, "ns_per_op", "en"), dg::status_ok);
    // 2 Reihen -> 2 Kurven + 2 Legenden-Eintraege.
    EXPECT_EQ(count_occurrences(out, "\\addplot+[mark=*]"), 2u);
    EXPECT_EQ(count_occurrences(out, "\\addlegendentry"), 2u);
    // Die gemessenen Stuetzstellen stehen literal drin.
    EXPECT_TRUE(file_contains(out, "(4096,"));
    EXPECT_TRUE(file_contains(out, "(8192,"));
    // ECHTE Spanne -> KEINE Achsen-Aufweitung (die greift nur im entarteten Fall).
    EXPECT_FALSE(file_contains(out, "xmin="));

    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (P1b-t3) Der d03-Fall: nur EIN working_set_n. Die Kurve ist ehrlich ein Punkt je Reihe; NUR die ACHSE
// wird auf eine Oktave geweitet, damit pgfplots nicht "approximately empty" warnt und selbst willkuerlich
// aufweitet. Es entsteht KEIN zusaetzlicher Datenpunkt.
TEST(Stufe05Pipeline, SweepCurveSingleWorkingSetWidensOnlyTheAxisNotTheData) {
    auto p = comdare_user_tmp() / "p1b_single_ws.csv";
    write_wide_csv_with_working_set(p, /*has_ws=*/true, /*single_ws=*/true);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "p1b_sweep_single.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_working_set_sweep_curve(out, rows, "ns_per_op", "en"), dg::status_ok);
    // Achse explizit eine Oktave um den einen Wert (4096) -> [2048 : 8192], log basis 2.
    EXPECT_TRUE(file_contains(out, "xmin=2048.0000, xmax=8192.0000"));
    // ... aber NUR die Achse: es gibt weiterhin genau EINEN Punkt je Reihe (2 Reihen -> 2 Koordinaten).
    EXPECT_EQ(count_occurrences(out, "(4096,"), 2u);
    EXPECT_EQ(count_occurrences(out, "(8192,"), 0u); // kein erfundener zweiter Stuetzpunkt
    EXPECT_EQ(count_occurrences(out, "\\addplot+[mark=*]"), 2u);

    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (P1b-t4) Die Achsen-Beschriftungen sind REINER ASCII-TEXT ohne LaTeX-Syntax: write_pgfplots_axis_options
// escaped sie, also wuerde jedes $ / \ literal im PDF erscheinen. Genau das war der Fehler vor P1b.
TEST(Stufe05Pipeline, SweepCurveLabelsSurviveTheLatexEscape) {
    auto p = comdare_user_tmp() / "p1b_labels.csv";
    write_wide_csv_with_working_set(p, /*has_ws=*/true, /*single_ws=*/false);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    std::error_code ec;
    auto            out_en = comdare_user_tmp() / "p1b_labels_en.tex";
    fs::remove(out_en, ec);
    ASSERT_EQ(dg::write_working_set_sweep_curve(out_en, rows, "ns_per_op", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out_en, "xlabel={working set n (keys)}"));
    EXPECT_FALSE(file_contains(out_en, "\\$")); // KEIN literal sichtbares Dollarzeichen

    auto out_de = comdare_user_tmp() / "p1b_labels_de.tex";
    fs::remove(out_de, ec);
    ASSERT_EQ(dg::write_working_set_sweep_curve(out_de, rows, "ns_per_op", "de"), dg::status_ok);
    EXPECT_TRUE(file_contains(out_de, "xlabel={Arbeitsmenge n (Schluessel)}"));
    EXPECT_FALSE(file_contains(out_de, "\\$"));
    EXPECT_FALSE(file_contains(out_de, "textbackslash")); // KEIN zerlegter Umlaut-Befehl mehr

    fs::remove(out_en, ec);
    fs::remove(out_de, ec);
    fs::remove(p, ec);
}

// -----------------------------------------------------------------------------
// GRAPH-UMBAU 2D/3D, P2 (2026-08-06) -- baseline-relative Verhaeltnis-Matrix.
// Zellwert = median(algo, workload) / median(reference, workload). Die honest-empty-Kernwache dieser
// Form ist die ZWEI-OPERANDEN-Regel: eine Verhaeltnis-Zelle existiert nur, wenn Zaehler UND Nenner
// einzeln ausgefuehrt und darstellbar sind. Fehlt die Referenz fuer eine Spalte, bleibt die GANZE Spalte
// leer -- nie eine Ratio gegen eine fehlende Baseline.
// -----------------------------------------------------------------------------
namespace {

// Zeilen: (algo, workload, ns_per_op). ns_per_op ist die Metrik; op_*_p50 werden mitgeschrieben, damit
// der Parser zufrieden ist. two_phase_valid=1 fuer alle.
struct RatioRow {
    char const* algo;
    char const* workload;
    double      ns; // ns_per_op UND op_insert_p50_ns dieser Zeile
};

// Schreibt zusaetzlich den Ausfuehrungs-Zaehler op_insert_n (>0). Das ist noetig, um eine ECHT GEMESSENE
// 0 pruefen zu koennen: "ns_per_op" traegt KEINEN eigenen Zaehler, dort gilt dokumentiert
// "gemessen <=> > 0" -- eine 0 ist dort also per Definition "nicht ausgefuehrt" und NICHT der Grenzfall.
// Nur ueber op_<art>_n ist "ausgefuehrt UND 0 ns" ueberhaupt ausdrueckbar (E-2b).
void write_wide_csv_for_ratio(fs::path const& p, std::vector<RatioRow> const& rows) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    f << "binary_id;ns_per_op;op_insert_n;op_insert_p50_ns;op_lookup_n;op_lookup_p50_ns;op_erase_n;"
      << "op_erase_p50_ns;op_scan_n;op_scan_p50_ns;op_rmw_n;op_rmw_p50_ns;workload;two_phase_valid\n";
    for (auto const& r : rows) {
        f << "search_algo=" << r.algo << "/mapping=direct;" << r.ns << ";"
          << "1000;" << r.ns << ";" // insert: AUSGEFUEHRT (n=1000), Median = r.ns (darf 0 sein)
          << "1000;10.0;1000;20.0;1000;30.0;1000;40.0;" << r.workload << ";1\n";
    }
}

} // namespace

// (P2-t1) Fehlt die Referenz-Zeile fuer EINE Workload-Spalte, bleibt genau diese Spalte komplett leer --
// die uebrigen Spalten rechnen normal weiter. Das ist die Kernwache: nie gegen eine fehlende Baseline.
TEST(Stufe05Pipeline, RatioMatrixOmitsWholeColumnWhenReferenceMissingThere) {
    auto p = comdare_user_tmp() / "p2_ref_missing_column.csv";
    // linear_scan (Referenz) laeuft NUR in ycsb_a, nicht in ycsb_c.
    write_wide_csv_for_ratio(p, {{"linear_scan", "ycsb_a", 100.0},
                                 {"k_ary", "ycsb_a", 50.0},
                                 {"k_ary", "ycsb_c", 70.0},
                                 {"eytzinger", "ycsb_c", 35.0}});
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "p2_ratio_col.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_surface_ratio_vs_reference(out, rows, "ns_per_op", "linear_scan", "en"), dg::status_ok);

    // Achsen: y = {eytzinger, k_ary, linear_scan}, x = {ycsb_a, ycsb_c}.
    // Spalte ycsb_a (x=0): k_ary 50/100 = 0.5, linear_scan 100/100 = 1.0, eytzinger fehlt -> nan.
    EXPECT_TRUE(file_contains(out, "(0,1,0.5000) [-0.3010]")); // k_ary vs Referenz: Verhaeltnis 0.5, log -0.3010
    EXPECT_TRUE(file_contains(out, "(0,2,1.0000) [0.0000]"));  // Referenz gegen sich selbst = 1, log 0
    // Spalte ycsb_c (x=1): KEIN Referenz-Lauf -> ALLE drei Zellen ausgelassen, obwohl k_ary/eytzinger
    // dort gemessen haben. Genau das ist die Regel.
    EXPECT_TRUE(file_contains(out, "(1,0,0) [nan]"));
    EXPECT_TRUE(file_contains(out, "(1,1,0) [nan]"));
    EXPECT_TRUE(file_contains(out, "(1,2,0) [nan]"));
    // Die Rohwerte der ausgelassenen Zellen tauchen NIRGENDS als Ratio auf.
    EXPECT_FALSE(file_contains(out, "70.0000"));
    EXPECT_FALSE(file_contains(out, "35.0000"));

    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (P2-t2) Zaehler = echt gemessene 0 -> Verhaeltnis 0 ist ein GUELTIGER, darstellbarer Punkt
// (Spiegel von SurfaceTrueZeroCellIsPlottedNotOmitted). Nenner = echt 0 dagegen macht das Verhaeltnis
// undefiniert -> die Zelle wird ausgelassen, KEIN Unendlich, KEIN Ersatzwert.
TEST(Stufe05Pipeline, RatioMatrixTrueZeroNumeratorIsDisplayableButZeroDenominatorIsOmitted) {
    std::error_code ec;

    // (a) Zaehler 0, Nenner 100 -> Ratio 0, darstellbar. z_field = op_insert_p50_ns, weil nur dort der
    //     Ausfuehrungs-Zaehler op_insert_n die 0 als GEMESSEN ausweisen kann (bei ns_per_op ist eine 0
    //     dokumentiert "nicht ausgefuehrt").
    // REV 7.7 (2026-08-13): Korpus auf ZWEI Workload-Spalten erweitert. Der alte 2x1-Korpus (1 Spalte)
    // liess den Writer genau die Flaechen-Klasse emittieren, die pgfplots kompilier-fatal ablehnt
    // (Proben 13.08.: 1x2 rc=1, 2x1 rc=1 (Nachprobe), 2x2 rc=0) -- seit der Groessen-Wache entsteht
    // dafuer ehrlich ein Platzhalter. Die hier gepruefte SEMANTIK (Verhaeltnis 0 ist darstellbar,
    // eigene Farbklasse unter der Mitte) braucht eine echte Figur, also ein 2x2-Korpus.
    auto p_num = comdare_user_tmp() / "p2_zero_numerator.csv";
    write_wide_csv_for_ratio(p_num, {{"linear_scan", "ycsb_a", 100.0},
                                     {"k_ary", "ycsb_a", 0.0},
                                     {"linear_scan", "ycsb_c", 100.0},
                                     {"k_ary", "ycsb_c", 50.0}});
    std::vector<dg::WideMeasurementRow> rows_num;
    ASSERT_EQ(dg::parse_wide_csv(p_num, rows_num), dg::status_ok);
    ASSERT_TRUE(rows_num[0].has_op_n); // die Ausfuehrungs-Wahrheit steht wirklich in der CSV
    auto out_num = comdare_user_tmp() / "p2_ratio_zero_num.tex";
    fs::remove(out_num, ec);
    ASSERT_EQ(dg::write_surface_ratio_vs_reference(out_num, rows_num, "op_insert_p50_ns", "linear_scan", "en"),
              dg::status_ok);
    EXPECT_TRUE(file_contains(out_num, "matrix plot*"));           // echte Figur
    EXPECT_FALSE(file_contains(out_num, "Metrik ohne Messwerte")); // KEIN Platzhalter
    // Verhaeltnis 0 ist DARGESTELLT -- Wert 0.0000 mit eigener Farbklasse eine Dekade unter der halben
    // Breite (log10(0) existiert nicht). Halbe Breite ist hier |log10(0.5)| = 0.3010 (Zellen 0.5 und
    // 1.0), die 0-Klasse sitzt also bei -(0.3010+1) = -1.3010; die Domaene waechst SYMMETRISCH mit.
    EXPECT_TRUE(file_contains(out_num, "(0,0,0.0000) [-1.3010]"));
    EXPECT_TRUE(file_contains(out_num, "(0,1,1.0000) [0.0000]"));  // Referenz gegen sich selbst: log(1)=0
    EXPECT_TRUE(file_contains(out_num, "(1,0,0.5000) [-0.3010]")); // zweite Spalte rechnet normal weiter
    EXPECT_TRUE(file_contains(out_num, "point meta min=-1.3010"));
    EXPECT_TRUE(file_contains(out_num, "point meta max=1.3010"));
    // Die 0-Klasse ist ehrlich als "0" beschriftet, die Mitte als "1" (= wie die Referenz).
    EXPECT_TRUE(file_contains(out_num, "yticklabels={$0$,"));
    EXPECT_TRUE(file_contains(out_num, "$1$"));

    // (b) Nenner 0 (die Referenz misst echt 0) -> undefiniert -> Zelle ausgelassen. Da die Referenz-Zeile
    //     dann auch gegen sich selbst kein Verhaeltnis hat, traegt die Flaeche gar keine Zelle mehr ->
    //     ehrlicher Platzhalter statt einer Figur aus lauter Unendlichkeiten.
    auto p_den = comdare_user_tmp() / "p2_zero_denominator.csv";
    write_wide_csv_for_ratio(p_den, {{"linear_scan", "ycsb_a", 0.0}, {"k_ary", "ycsb_a", 50.0}});
    std::vector<dg::WideMeasurementRow> rows_den;
    ASSERT_EQ(dg::parse_wide_csv(p_den, rows_den), dg::status_ok);
    auto out_den = comdare_user_tmp() / "p2_ratio_zero_den.tex";
    fs::remove(out_den, ec);
    ASSERT_EQ(dg::write_surface_ratio_vs_reference(out_den, rows_den, "op_insert_p50_ns", "linear_scan", "en"),
              dg::status_ok);
    EXPECT_FALSE(file_contains(out_den, "matrix plot*"));         // KEINE Figur
    EXPECT_TRUE(file_contains(out_den, "Metrik ohne Messwerte")); // ehrlicher Platzhalter
    EXPECT_FALSE(file_contains(out_den, "inf"));                  // nichts Unendliches behauptet

    fs::remove(out_num, ec);
    fs::remove(out_den, ec);
    fs::remove(p_num, ec);
    fs::remove(p_den, ec);
}

// (P2-t3) Fehlt die Referenz-Serie im GESAMTEN Korpus, traegt keine Zelle Daten -> ehrlicher
// Platzhalter-Vermerk, KEIN pgfplots-Fatal. Der Vermerk nennt die Referenz beim Namen, damit
// "Metrik nie ausgefuehrt" von "Referenz nicht gemessen" unterscheidbar bleibt.
TEST(Stufe05Pipeline, RatioMatrixAllReferenceMissingIsHonestEmptyPlaceholder) {
    auto p = comdare_user_tmp() / "p2_ref_absent.csv";
    write_wide_csv_for_ratio(p, {{"k_ary", "ycsb_a", 50.0}, {"eytzinger", "ycsb_a", 35.0}});
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "p2_ratio_absent.tex";
    std::error_code ec;
    fs::remove(out, ec);
    // status_ok, weil die Datei existieren MUSS (kompilierfaehiger Vermerk) -- Muster write_heatmap.
    ASSERT_EQ(dg::write_surface_ratio_vs_reference(out, rows, "ns_per_op", "linear_scan", "en"), dg::status_ok);
    EXPECT_TRUE(fs::exists(out));
    EXPECT_FALSE(file_contains(out, "matrix plot*"));
    // escape_latex maskiert den Unterstrich -- der Vermerk traegt "linear\\_scan".
    EXPECT_TRUE(file_contains(out, "no reference series for linear\\_scan"));

    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (P2-t4) Die divergente Skala ist um die Gleichheit (Verhaeltnis 1) zentriert und MULTIPLIKATIV
// (log10 des Verhaeltnisses). Ein Verhaeltnis ist multiplikativ: "doppelt so schnell" (0.5) und "doppelt
// so langsam" (2.0) MUESSEN gleich weit von der Mitte liegen. Linear waeren sie es nicht (Abstand 0.5
// gegen 1.0) -- die schnellere Haelfte der Skala wuerde systematisch zusammengedrueckt.
TEST(Stufe05Pipeline, RatioMatrixDivergentScaleIsLogSymmetricAroundEquality) {
    auto p = comdare_user_tmp() / "p2_divergent.csv";
    // Referenz 100; k_ary 200 -> Verhaeltnis 2.0; eytzinger 50 -> Verhaeltnis 0.5.
    // Genau der Prueffall: beide sind "Faktor 2" von der Referenz entfernt, nur in andere Richtung.
    // REV 7.7 (2026-08-13): zweite Workload-Spalte ergaenzt (der alte 3x1-Korpus ist seit der
    // Groessen-Wache ehrlich ein Platzhalter; Nx1 ist pgfplots-fatal, Nachprobe 2x1 rc=1). Die Werte
    // je Spalte sind identisch -> die geprueften Log-Symmetrie-Zahlen bleiben exakt dieselben.
    write_wide_csv_for_ratio(p, {{"linear_scan", "ycsb_a", 100.0},
                                 {"k_ary", "ycsb_a", 200.0},
                                 {"eytzinger", "ycsb_a", 50.0},
                                 {"linear_scan", "ycsb_c", 100.0},
                                 {"k_ary", "ycsb_c", 200.0},
                                 {"eytzinger", "ycsb_c", 50.0}});
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "p2_ratio_div.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_surface_ratio_vs_reference(out, rows, "ns_per_op", "linear_scan", "en"), dg::status_ok);

    // log10(2) = 0.3010, log10(0.5) = -0.3010 -> exakt symmetrisch um 0 (= Verhaeltnis 1).
    EXPECT_TRUE(file_contains(out, "point meta min=-0.3010"));
    EXPECT_TRUE(file_contains(out, "point meta max=0.3010"));
    // Divergente 3-Stuetzstellen-Colormap statt viridis; KEIN externes Paket.
    EXPECT_TRUE(file_contains(out, "colormap={comdarediv}{rgb=(0,0,1) rgb=(1,1,1) rgb=(1,0,0)}"));
    EXPECT_FALSE(file_contains(out, "colormap/viridis"));
    // Zellwert bleibt das ECHTE Verhaeltnis; nur die Farb-Groesse ist logarithmisch -- und die beiden
    // Faktor-2-Zellen liegen betragsgleich auf beiden Seiten der Mitte.
    EXPECT_TRUE(file_contains(out, "(0,1,2.0000) [0.3010]"));
    EXPECT_TRUE(file_contains(out, "(0,0,0.5000) [-0.3010]"));
    EXPECT_TRUE(file_contains(out, "(0,2,1.0000) [0.0000]")); // die Referenz sitzt exakt auf der Mitte
    // Die Colorbar-Mitte ist als VERHAELTNIS beschriftet ("1"), nicht als Logarithmus "0".
    EXPECT_TRUE(file_contains(out, "yticklabels={$1$}"));

    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (P2-t5) ENTARTUNG: ist ausser der Referenz nichts vergleichbar, sind ALLE Zellen exakt 1.0 -- Farb- UND
// z-Domaene kollabieren. pgfplots braeche daran fatal ab ("too few coordinates", die D-03-Wurzel).
// Geweitet wird ausschliesslich die ACHSE, kein Datum wird veraendert.
TEST(Stufe05Pipeline, RatioMatrixDegenerateAllOnesWidensOnlyTheAxis) {
    auto p = comdare_user_tmp() / "p2_degenerate.csv";
    // REV 7.7 (2026-08-13): 1x1 -> 2x2-Korpus. Die 1x1-Flaeche ist seit der Groessen-Wache ehrlich ein
    // Platzhalter (matrix input=image verlangt >= 2x2, Proben 13.08.); dieser Test prueft aber die
    // ENTARTUNG DER DOMAENEN bei lauter exakt gleichen Verhaeltnissen, und die braucht eine echte
    // Figur. Alle vier Zellen tragen dasselbe Verhaeltnis 1.0 -> Farb- und z-Domaene kollabieren.
    write_wide_csv_for_ratio(p, {{"linear_scan", "ycsb_a", 100.0},
                                 {"k_ary", "ycsb_a", 100.0},
                                 {"linear_scan", "ycsb_c", 100.0},
                                 {"k_ary", "ycsb_c", 100.0}});
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "p2_ratio_degen.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_surface_ratio_vs_reference(out, rows, "ns_per_op", "linear_scan", "en"), dg::status_ok);
    // Einzige Zelle traegt das echte Verhaeltnis 1.0, ihre Farb-Groesse ist log10(1) = 0 ...
    EXPECT_TRUE(file_contains(out, "(0,0,1.0000) [0.0000]"));
    // ... und die Domaenen sind auf eine Dekade aufgeweitet statt entartet ([0:0] waere der pgfplots-Fatal).
    EXPECT_TRUE(file_contains(out, "point meta min=-1.0000"));
    EXPECT_TRUE(file_contains(out, "point meta max=1.0000"));
    EXPECT_TRUE(file_contains(out, "zmin=1.0000, zmax=2.0000"));

    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (P2-t5b) INTERAKTION Entartungs-Wache x 0-Klasse (F1-FIX 2026-08-13, Lens-Fund a/HINWEIS): vor
// REV 7.7 deckte P2-t2 die Kombination "alle positiven Verhaeltnisse exakt 1.0 UND eine echte 0" in
// EINEM 2x1-Korpus; der 2x2-Umbau hat sie in zwei Tests getrennt. Hier steht sie wieder in EINEM
// Test, jetzt ueber der Groessen-Wache (2x2): ERST weitet die Entartungs-Wache die halbe Breite
// (0 -> 1 Dekade), DANN setzt die 0-Klasse eine Dekade DARUNTER an (-2) und die Domaene waechst
// symmetrisch mit -- exakt die Zahlen des alten 2x1-Korpus. Ein Tausch dieser Reihenfolge (0-Klasse
// aus der UNGEWEITETEN Breite) faellt NUR hier auf: beide Nachbar-Tests sind gegen ihn blind
// (P2-t2 hat half>0, P2-t5 hat keine 0).
TEST(Stufe05Pipeline, RatioMatrixTrueZeroOnAllOnesWidensAxisThenPlacesZeroClassBelow) {
    auto p = comdare_user_tmp() / "p2_zero_on_all_ones.csv";
    write_wide_csv_for_ratio(p, {{"linear_scan", "ycsb_a", 100.0},
                                 {"k_ary", "ycsb_a", 0.0},
                                 {"linear_scan", "ycsb_c", 100.0},
                                 {"k_ary", "ycsb_c", 100.0}});
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "p2_ratio_zero_all_ones.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_surface_ratio_vs_reference(out, rows, "op_insert_p50_ns", "linear_scan", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "matrix plot*")); // echte Figur, kein Groessen-Platzhalter
    // Alle positiven Verhaeltnisse exakt 1.0 -> halbe Breite 0 -> Entartungs-Wache weitet auf 1 Dekade;
    // die 0-Klasse sitzt eine weitere Dekade darunter (-2), die Domaene waechst symmetrisch (+-2).
    EXPECT_TRUE(file_contains(out, "(0,0,0.0000) [-2.0000]")); // k_ary/ycsb_a: echte 0 (n=1000, p50=0)
    EXPECT_TRUE(file_contains(out, "(1,0,1.0000) [0.0000]"));  // k_ary/ycsb_c: exakt wie die Referenz
    EXPECT_TRUE(file_contains(out, "(0,1,1.0000) [0.0000]"));  // Referenz gegen sich selbst
    EXPECT_TRUE(file_contains(out, "point meta min=-2.0000"));
    EXPECT_TRUE(file_contains(out, "point meta max=2.0000"));
    // VERMERKT (Bestandsverhalten seit P2; schon der alte 2x1-Korpus emittierte exakt diese Liste):
    // der 0-Klassen-Tick -2.0000 faellt hier mit dem Dekaden-Tick -2 zusammen ("$0$" neben "$10^{-2}$").
    // Ausser der 0 liegt dort kein Datum; bewusst festgeschrieben, nicht Gegenstand des F1-Fixes.
    EXPECT_TRUE(file_contains(out, "ytick={-2.0000,-2,-1,0,1,2}"));
    EXPECT_TRUE(file_contains(out, "yticklabels={$0$,$10^{-2}$,$10^{-1}$,$1$,$10^{1}$,$10^{2}$}"));
    // Der z-Traeger {0.0, 1.0} ist NICHT entartet -> KEIN explizites zmin/zmax (anders als P2-t5).
    EXPECT_FALSE(file_contains(out, "zmin="));

    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (f1-e) GEGENKOEDER Spaltenbreite > 2 im NICHT-ratio-Pfad (F1-FIX 2026-08-13, Lens-Nebenfund a):
// committet waren nur 2x2 (f1-d) und indirekt 3x2 ueber den ratio-Pfad (P2-t4) -- eine kuenftige
// Fehl-Wache der Form "genau 2 Spalten" (nx != 2 statt nx < 2) traefe 2x3 unbemerkt: alle
// 1xN/Nx1-Tests blieben Platzhalter (korrekt), alle 2x2-Tests echte Figuren (korrekt). Dieser Test
// nagelt die Klasse "echte Figur auch BREITER als 2 Spalten" im Roh-Pfad dauerhaft fest.
TEST(Stufe05Pipeline, Surface2x3StaysRealFigure) {
    auto p = comdare_user_tmp() / "f1_surface_2x3.csv";
    // 2 Algos x 3 Workloads, alle sechs Zellen gemessen (ns_per_op > 0).
    write_wide_csv_for_ratio(p, {{"k_ary", "ycsb_a", 100.0},
                                 {"k_ary", "ycsb_b", 200.0},
                                 {"k_ary", "ycsb_c", 300.0},
                                 {"eytzinger", "ycsb_a", 400.0},
                                 {"eytzinger", "ycsb_b", 500.0},
                                 {"eytzinger", "ycsb_c", 600.0}});
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "f1_surface_2x3.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out, rows, "ns_per_op", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "matrix plot*"));
    EXPECT_TRUE(file_contains(out, "mesh/cols=3,")); // PFLICHT-Traeger der dritten Spalte
    EXPECT_FALSE(file_contains(out, "HONEST-EMPTY (Groesse)"));
    // Achsen: y = {eytzinger=0, k_ary=1}, x = {ycsb_a=0, ycsb_b=1, ycsb_c=2}. Eckzellen verbatim:
    EXPECT_TRUE(file_contains(out, "(0,1,100.0000) [2.0000]")); // k_ary/ycsb_a, log10(100) = 2
    EXPECT_TRUE(file_contains(out, "(2,0,600.0000) [2.7782]")); // eytzinger/ycsb_c, log10(600)

    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (P2-t6) BESTANDSSCHUTZ: die rohe Latenz-Heatmap ist von P2 voellig unberuehrt -- weiterhin viridis,
// log-Dekaden-Colorbar, KEINE divergente Colormap. P2 ist additiv, kein Ersatz.
TEST(Stufe05Pipeline, RatioModeDoesNotLeakIntoThePlainLatencyHeatmap) {
    auto p = comdare_user_tmp() / "p2_bestandsschutz.csv";
    // REV 7.7 (2026-08-13): zweite Workload-Spalte ergaenzt (der alte 2x1-Korpus ist seit der
    // Groessen-Wache ehrlich ein Platzhalter; Nachprobe 2x1 rc=1) -- der Bestandsschutz "keine
    // divergente Colormap im Roh-Pfad" braucht eine echte Figur.
    write_wide_csv_for_ratio(p, {{"linear_scan", "ycsb_a", 100.0},
                                 {"k_ary", "ycsb_a", 300.0},
                                 {"linear_scan", "ycsb_c", 100.0},
                                 {"k_ary", "ycsb_c", 300.0}});
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "p2_plain_heatmap.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out, rows, "ns_per_op", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "colormap/viridis"));
    EXPECT_FALSE(file_contains(out, "comdarediv"));
    EXPECT_TRUE(file_contains(out, "$10^{")); // log-Dekaden-Colorbar wie bisher
    // Rohwerte, KEINE Verhaeltnisse.
    EXPECT_TRUE(file_contains(out, "300.0000"));

    fs::remove(out, ec);
    fs::remove(p, ec);
}

// -----------------------------------------------------------------------------
// GRAPH-UMBAU 2D/3D, P3a (2026-08-06) -- baseline-normalisierte Balken.
// Verdichtet die Verhaeltnis-Matrix ueber die Lastprofile zu EINEM Balken je search_algo.
// -----------------------------------------------------------------------------

// (P3a-t1) HYPOTHESEN-TRENNUNG: der Balken ist der Median der lastprofil-weisen VERHAELTNISSE
// (Hypothese A), NICHT das Verhaeltnis der Roh-Mediane (Hypothese B).
//
// WARUM DIESER EINGANG NEU IST -- Posten #42, 2026-08-10. Bis heute stand hier Referenz 100/1000
// gegen k_ary 50/2000 ueber ZWEI Lastprofile. Dieser Eingang TRENNT DIE BEIDEN HYPOTHESEN NICHT:
// bei n=2 ist der Kanon-Median die UNTERE Mitte, also das Minimum, und beide Seiten haben ihr
// Minimum im selben Lastprofil (ycsb_a). A liefert median(0.5, 2.0) = 0.5; B liefert
// median(50,2000)/median(100,1000) = 50/100 = 0.5. Exakt dieselbe Zahl. Der Test trug den
// Hypothesen-Namen und mass die Hypothese nicht. Belegt mit einer WEGWERF-MUTATION, die Hypothese B
// in den Pruefling einbaute -- Spaltenauswahl und Auslass-Regel buchstabengleich, NUR Median und
// Division vertauscht: alle 46 Tests dieser Datei blieben gruen.
//
// EIN TRENNENDER EINGANG BRAUCHT ZWEIERLEI: (a) UNGERADES n, damit der Median die echte Mitte ist
// und nicht das Minimum, und (b) eine Referenz, die NICHT gleichsinnig mit dem Herausforderer ueber
// die Lastprofile laeuft. Fehlt (b), ist die Gleichheit sogar ein Satz und kein Zufall: der Median
// vertauscht mit jeder streng monotonen Transformation.
//
// ORAKEL (T-3, FREMDE QUELLE): die Erwartungswerte sind von Hand gegen den PERZENTIL-KANON der
// cache-engine gerechnet -- ce_canon::nearest_rank_index, erreichbar ueber
// Code/common/percentile_canon.hpp -- und NICHT aus dem Pruefling abgelesen. Fuer n=3 gilt
// k(0.5,3) = ceil(1.5)-1 = 1, also die echte Mitte des aufsteigend sortierten Feldes.
//
// BEIDE RICHTUNGEN (T-4, K13): Fall 1 hat A > B, Fall 2 hat A < B. Ein Pruefling, der immer die
// kleinere oder immer die groessere der beiden Zahlen liefert, faellt dadurch in genau einem der
// beiden Faelle auf. Eine einzige Richtung waere ein Koeder, an dem man vorbeikommt.
TEST(Stufe05Pipeline, NormalizedBarAggregatesRatiosNotRawMedians) {
    std::error_code ec;

    // FALL 1 -- Hypothese A LIEGT UEBER Hypothese B.
    //   Verhaeltnisse: 50/100 = 0.5, 50/300 = 0.1667, 4000/500 = 8.0
    //   A: sortiert [0.1667, 0.5, 8.0], n=3, Index 1                     -> 0.5000
    //   B: Roh-Median k_ary [50,50,4000] = 50, linear_scan [100,300,500] = 300 -> 0.1667
    auto p1 = comdare_user_tmp() / "p3a_ratio_of_ratios_a_ueber_b.csv";
    write_wide_csv_for_ratio(p1, {{"linear_scan", "ycsb_a", 100.0},
                                  {"linear_scan", "ycsb_b", 300.0},
                                  {"linear_scan", "ycsb_c", 500.0},
                                  {"k_ary", "ycsb_a", 50.0},
                                  {"k_ary", "ycsb_b", 50.0},
                                  {"k_ary", "ycsb_c", 4000.0}});
    std::vector<dg::WideMeasurementRow> rows1;
    ASSERT_EQ(dg::parse_wide_csv(p1, rows1), dg::status_ok);

    auto out1 = comdare_user_tmp() / "p3a_bar_a_ueber_b.tex";
    fs::remove(out1, ec);
    ASSERT_EQ(dg::write_normalized_bar_vs_reference(out1, rows1, "ns_per_op", "linear_scan", "en"), dg::status_ok);
    // Die beiden Zusicherungen sind ein PAAR: das EXPECT_TRUE allein liesse sich durch eine leere
    // Datei nicht erfuellen, das EXPECT_FALSE allein von einer leeren Datei trivial bestehen.
    EXPECT_TRUE(file_contains(out1, "(k\\_ary,0.5000)"));  // Hypothese A -- muss dastehen
    EXPECT_FALSE(file_contains(out1, "(k\\_ary,0.1667)")); // Hypothese B -- darf NICHT dastehen
    EXPECT_TRUE(file_contains(out1, "(linear\\_scan,1.0000)"));

    // FALL 2 -- GEGENRICHTUNG, Hypothese A LIEGT UNTER Hypothese B.
    //   Verhaeltnisse: 900/100 = 9.0, 100/300 = 0.3333, 200/500 = 0.4
    //   A: sortiert [0.3333, 0.4, 9.0], n=3, Index 1                      -> 0.4000
    //   B: Roh-Median k_ary [900,100,200] = 200, linear_scan = 300         -> 0.6667
    auto p2 = comdare_user_tmp() / "p3a_ratio_of_ratios_a_unter_b.csv";
    write_wide_csv_for_ratio(p2, {{"linear_scan", "ycsb_a", 100.0},
                                  {"linear_scan", "ycsb_b", 300.0},
                                  {"linear_scan", "ycsb_c", 500.0},
                                  {"k_ary", "ycsb_a", 900.0},
                                  {"k_ary", "ycsb_b", 100.0},
                                  {"k_ary", "ycsb_c", 200.0}});
    std::vector<dg::WideMeasurementRow> rows2;
    ASSERT_EQ(dg::parse_wide_csv(p2, rows2), dg::status_ok);

    auto out2 = comdare_user_tmp() / "p3a_bar_a_unter_b.tex";
    fs::remove(out2, ec);
    ASSERT_EQ(dg::write_normalized_bar_vs_reference(out2, rows2, "ns_per_op", "linear_scan", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out2, "(k\\_ary,0.4000)"));  // Hypothese A -- muss dastehen
    EXPECT_FALSE(file_contains(out2, "(k\\_ary,0.6667)")); // Hypothese B -- darf NICHT dastehen
    EXPECT_TRUE(file_contains(out2, "(linear\\_scan,1.0000)"));

    fs::remove(out1, ec);
    fs::remove(out2, ec);
    fs::remove(p1, ec);
    fs::remove(p2, ec);
}

// (P3a-t1b) KANON-WACHE ueber demselben Writer -- und AUSDRUECKLICH NICHT die Hypothesen-Wache.
// Bei GERADEM n liefert der Perzentil-Kanon die UNTERE Mitte: Verhaeltnisse [0.5, 2.0], n=2,
// k = ceil(0.5*2)-1 = 0 -> 0.5. Die am 2026-08-09 verworfene Formel round(q*(n-1)) haette hier 2.0
// geliefert; genau diese Regression faengt dieser Eingang. Er traegt zusaetzlich die
// LaTeX-Formwachen des Writers (Referenzlinie, log-Achse, relative enlarge-x-limits-Form).
//
// ZUSICHERT NICHT: nichts ueber die Aggregations-REIHENFOLGE. Dieser Eingang liefert fuer BEIDE
// Hypothesen 0.5000 und ist fuer die Frage "Median der Verhaeltnisse oder Verhaeltnis der
// Roh-Mediane" nachweislich blind (Posten #42). Diese Frage traegt allein (P3a-t1) darueber.
TEST(Stufe05Pipeline, NormalizedBarMedianUsesLowerMiddleOnEvenN) {
    auto p = comdare_user_tmp() / "p3a_ratio_of_ratios.csv";
    write_wide_csv_for_ratio(p, {{"linear_scan", "ycsb_a", 100.0},
                                 {"linear_scan", "ycsb_c", 1000.0},
                                 {"k_ary", "ycsb_a", 50.0},
                                 {"k_ary", "ycsb_c", 2000.0}});
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "p3a_bar.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_normalized_bar_vs_reference(out, rows, "ns_per_op", "linear_scan", "en"), dg::status_ok);
    // D5-2 KANON, von Hand: Verhaeltnisse sortiert [0.5, 2.0], n=2 (GERADE)
    //   k = ceil(0.5*2)-1 = 0 -> 0.5 (UNTERE Mitte). Vorher stand hier 2.0 -- die obere Mitte
    //   der verworfenen Formel round(q*(n-1)). linear_scan gegen sich selbst bleibt 1.0.
    EXPECT_TRUE(file_contains(out, "(k\\_ary,0.5000)"));
    EXPECT_FALSE(file_contains(out, "(k\\_ary,2.0000)")); // die verworfene OBERE Mitte
    EXPECT_TRUE(file_contains(out, "(linear\\_scan,1.0000)"));
    // Referenzlinie bei 1 vorhanden -- und als \addplot, NICHT als \draw mit |- (das bricht auf
    // symbolischen Achsen fatal ab, pdflatex-Probe 2026-08-06).
    EXPECT_TRUE(file_contains(out, "P3a-REFERENZLINIE"));
    EXPECT_TRUE(file_contains(out, "sharp plot,no marks,dashed,nbref"));
    EXPECT_FALSE(file_contains(out, "|-"));
    // Die abs-Form von enlarge x limits ist auf symbolischen Achsen fatal -> relative Form.
    EXPECT_TRUE(file_contains(out, "enlarge x limits=0.25"));
    EXPECT_FALSE(file_contains(out, "enlarge x limits={abs="));
    // Verhaeltnisse spannen Dekaden -> log-y (keine echte 0 im Spiel).
    EXPECT_TRUE(file_contains(out, "ymode=log"));

    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (P3a-t2) Eine Gruppe ohne ein einziges gueltiges Verhaeltnis wird AUSGELASSEN -- niemals auf 1.0
// gesetzt. 1.0 hiesse "genauso schnell wie die Referenz", also ein Befund, den es nicht gibt.
TEST(Stufe05Pipeline, NormalizedBarOmitsGroupsWithoutAnyValidRatio) {
    auto p = comdare_user_tmp() / "p3a_group_without_ref.csv";
    // Referenz laeuft NUR in ycsb_a. eytzinger laeuft NUR in ycsb_c -> hat nie einen Nenner.
    write_wide_csv_for_ratio(
        p, {{"linear_scan", "ycsb_a", 100.0}, {"k_ary", "ycsb_a", 50.0}, {"eytzinger", "ycsb_c", 35.0}});
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "p3a_omit.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_normalized_bar_vs_reference(out, rows, "ns_per_op", "linear_scan", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "(k\\_ary,0.5000)"));
    EXPECT_TRUE(file_contains(out, "(linear\\_scan,1.0000)"));
    // eytzinger taucht NIRGENDS auf -- weder als Balken noch als Achsen-Kategorie.
    EXPECT_FALSE(file_contains(out, "eytzinger"));

    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (P3a-t3) HONEST-EMPTY: fehlt die Referenz im ganzen Korpus, traegt keine Gruppe ein Verhaeltnis ->
// status_empty_input und KEINE Datei (Muster der Darstellungs-Writer, nicht der Platzhalter-Weg der
// Flaechen-Writer -- diese Datei haengt am \InputIfFileExists).
TEST(Stufe05Pipeline, NormalizedBarHonestEmptyWhenReferenceAbsent) {
    auto p = comdare_user_tmp() / "p3a_no_ref.csv";
    write_wide_csv_for_ratio(p, {{"k_ary", "ycsb_a", 50.0}, {"eytzinger", "ycsb_a", 35.0}});
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "p3a_empty.tex";
    std::error_code ec;
    fs::remove(out, ec);
    EXPECT_EQ(dg::write_normalized_bar_vs_reference(out, rows, "ns_per_op", "linear_scan", "en"),
              dg::status_empty_input);
    EXPECT_FALSE(fs::exists(out)); // KEINE Datei

    fs::remove(p, ec);
}

// (P3a-t4) E-2b-Praezedenz: faellt ein Balken auf exakt 0 (Zaehler echt 0 gemessen), faellt die y-Achse
// auf LINEAR zurueck -- eine log-Achse koennte die 0 weder zeigen noch ehrlich ersetzen (sie verschluckt
// sie lautlos als unbounded coordinate = verschwiegener Messwert).
TEST(Stufe05Pipeline, NormalizedBarFallsBackToLinearWhenABarIsTrueZero) {
    auto p = comdare_user_tmp() / "p3a_zero_bar.csv";
    write_wide_csv_for_ratio(p, {{"linear_scan", "ycsb_a", 100.0}, {"k_ary", "ycsb_a", 0.0}});
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "p3a_zero.tex";
    std::error_code ec;
    fs::remove(out, ec);
    // op_insert_p50_ns, weil nur dort der Zaehler op_insert_n die 0 als GEMESSEN ausweisen kann.
    ASSERT_EQ(dg::write_normalized_bar_vs_reference(out, rows, "op_insert_p50_ns", "linear_scan", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "(k\\_ary,0.0000)")); // die 0 ist ein echter Balken
    EXPECT_FALSE(file_contains(out, "ymode=log"));       // ... und die Achse ist linear

    fs::remove(out, ec);
    fs::remove(p, ec);
}

// -----------------------------------------------------------------------------
// GRAPH-UMBAU 2D/3D, P3b / E-2c (2026-08-06) -- Pareto-/Tradeoff-Streuung p50 gegen p99.
// Die einzige Form mit ZWEI KONKURRIERENDEN Kostenachsen. Ein echter Idreos-Pareto (Lese- gegen
// Speicherkosten) ist NICHT moeglich -- das WIDE-Schema traegt keine Speicher-/Byte-Spalte. p50 gegen
// p99 (typischer Fall gegen Dienstguete-Fall) ist das Kostenpaar, das die Daten wirklich hergeben.
// -----------------------------------------------------------------------------
namespace {

// p99-Spalten optional: has_p99=false spiegelt den cowfix-v1-Korpus OHNE p99 (dann honest-empty).
// insert_p50/p99 je Zeile frei setzbar; die uebrigen Op-Arten sind nie ausgefuehrt (n=0).
struct TradeoffRow {
    char const* algo;
    char const* workload;
    double      p50;
    double      p99;
};

void write_wide_csv_for_tradeoff(fs::path const& p, std::vector<TradeoffRow> const& rows, bool has_p99) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    f << "binary_id;ns_per_op;op_insert_n;op_insert_p50_ns;op_lookup_n;op_lookup_p50_ns;op_erase_n;"
      << "op_erase_p50_ns;op_scan_n;op_scan_p50_ns;op_rmw_n;op_rmw_p50_ns;";
    if (has_p99) f << "op_insert_p99_ns;op_lookup_p99_ns;op_erase_p99_ns;op_scan_p99_ns;op_rmw_p99_ns;";
    f << "workload;two_phase_valid\n";
    for (auto const& r : rows) {
        f << "search_algo=" << r.algo << "/mapping=direct;" << r.p50 << ";"
          << "1000;" << r.p50 << ";" // insert AUSGEFUEHRT
          << "0;0;0;0;0;0;0;0;";     // lookup/erase/scan/rmw: nie ausgefuehrt
        if (has_p99) f << r.p99 << ";0;0;0;0;";
        f << r.workload << ";1\n";
    }
}

} // namespace

// (P3b-t1) Je gueltiger (Zeile x ausgefuehrter Op-Art) genau EIN Punkt -- keine Aggregation. Die
// Punktwolke IST die Aussage. Serien = search_algo, plus die Diagonale y=x als Referenz.
TEST(Stufe05Pipeline, LatencyTradeoffEmitsOnePointPerExecutedOpAndTheDiagonal) {
    auto p = comdare_user_tmp() / "p3b_points.csv";
    write_wide_csv_for_tradeoff(
        p, {{"k_ary", "ycsb_a", 100.0, 400.0}, {"k_ary", "ycsb_c", 120.0, 500.0}, {"eytzinger", "ycsb_a", 80.0, 90.0}},
        /*has_p99=*/true);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);
    ASSERT_TRUE(rows[0].has_op_p99);

    // Nur insert ist ausgefuehrt -> genau 3 Punkte (nicht 15).
    auto const pts = dg::aggregate_latency_tradeoff(rows);
    ASSERT_EQ(pts.size(), 3u);
    for (auto const& q : pts) EXPECT_EQ(q.op, "insert");

    auto            out = comdare_user_tmp() / "p3b_scatter.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_latency_tradeoff_scatter(out, rows, "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "only marks"));
    EXPECT_TRUE(file_contains(out, "(100.0000,400.0000)"));
    EXPECT_TRUE(file_contains(out, "(120.0000,500.0000)"));
    EXPECT_TRUE(file_contains(out, "(80.0000,90.0000)"));
    // 2 Serien (eytzinger, k_ary) + Diagonale.
    EXPECT_EQ(count_occurrences(out, "\\addlegendentry"), 2u);
    EXPECT_TRUE(file_contains(out, "E-2c-DIAGONALE"));
    // Latenz spannt Dekaden -> log-Achsen (keine echte 0 im Spiel).
    EXPECT_TRUE(file_contains(out, "xmode=log"));
    EXPECT_TRUE(file_contains(out, "ymode=log"));

    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (P3b-t2) HONEST-EMPTY ohne p99: ohne die zweite Kostenachse gibt es kein Kostenpaar. Die Zeile wird
// AUSGELASSEN -- ausdruecklich NICHT p99:=p50 gesetzt (das behauptete "kein Tail-Aufschlag").
TEST(Stufe05Pipeline, LatencyTradeoffHonestEmptyWithoutP99Columns) {
    auto p = comdare_user_tmp() / "p3b_no_p99.csv";
    write_wide_csv_for_tradeoff(p, {{"k_ary", "ycsb_a", 100.0, 0.0}}, /*has_p99=*/false);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);
    for (auto const& r : rows) EXPECT_FALSE(r.has_op_p99);

    EXPECT_TRUE(dg::aggregate_latency_tradeoff(rows).empty());

    auto            out = comdare_user_tmp() / "p3b_empty.tex";
    std::error_code ec;
    fs::remove(out, ec);
    EXPECT_EQ(dg::write_latency_tradeoff_scatter(out, rows, "en"), dg::status_empty_input);
    EXPECT_FALSE(fs::exists(out)); // KEINE Datei

    fs::remove(p, ec);
}

// (P3b-t3) E-2b-Praezedenz: eine ECHT GEMESSENE 0 ist ein gueltiger Punkt -- und zwingt BEIDE Achsen auf
// LINEAR, weil eine log-Achse die 0 lautlos als unbounded coordinate verschlucken wuerde (verschwiegener
// Messwert).
TEST(Stufe05Pipeline, LatencyTradeoffTrueZeroKeepsThePointAndForcesLinearAxes) {
    auto p = comdare_user_tmp() / "p3b_zero.csv";
    write_wide_csv_for_tradeoff(p, {{"k_ary", "ycsb_a", 0.0, 0.0}, {"eytzinger", "ycsb_a", 50.0, 70.0}},
                                /*has_p99=*/true);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    // Der Zaehler op_insert_n=1000 weist die 0 als GEMESSEN aus -> der Punkt bleibt.
    auto const pts = dg::aggregate_latency_tradeoff(rows);
    ASSERT_EQ(pts.size(), 2u);

    auto            out = comdare_user_tmp() / "p3b_zero.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_latency_tradeoff_scatter(out, rows, "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "(0.0000,0.0000)")); // die 0 ist ein echter Punkt
    EXPECT_FALSE(file_contains(out, "xmode=log"));      // ... und die Achsen sind linear
    EXPECT_FALSE(file_contains(out, "ymode=log"));

    fs::remove(out, ec);
    fs::remove(p, ec);
}

// -----------------------------------------------------------------------------
// F-4 / F-5 (2026-09-16), Posten #234 -- ENTARTUNGS-WACHEN gegen die pgfplots-Meldung
// "Axis range for axis <a> is approximately empty" und gegen den 1515.18507pt-Overfull
// der observer_detail-Kopfzeile. Alle vier Klassen stammen aus dem Owner-Log 13.09.:
//   A  ld_sweep_<z>      : y-Achse entartet (P1b heilte 2026-08-06 NUR x)
//   B  seg_attribution / latency_range : symbolische x-Achse mit EINER Kategorie
//   C  latency_ecdf      : log-x mit EINER distinkten Stuetzstelle
//   D  ld_sweep_op_insert: 0-ns-PHANTOM einer nie ausgefuehrten Operation
//   F-5 observer_detail  : unbrechbare Konfigurations-Kopfzeile in einer l-Spalte
// -----------------------------------------------------------------------------
namespace {

// EIN Messpunkt, EINE Reihe -- der d03-/ycsb_c-Fall des Owner-Logs. op_<art>_n ist gesetzt, damit
// z_field_executed die PRIMAERQUELLE benutzt (insert nie ausgefuehrt, lookup 10000 Operationen).
void write_f4_single_point_csv(fs::path const& p) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    f << "binary_id;ns_per_op;op_insert_p50_ns;op_lookup_p50_ns;op_erase_p50_ns;op_scan_p50_ns;"
      << "op_rmw_p50_ns;op_insert_n;op_lookup_n;op_erase_n;op_scan_n;op_rmw_n;working_set_n;"
      << "workload;two_phase_valid\n";
    f << "search_algo=k_ary/mapping=direct;671.532;0;750;0;0;0;0;10000;0;0;0;4096;ycsb_c;1\n";
}

// Genau EINE Balken-Kategorie (nur k_ary) -- der Einer-Fall der symbolischen x-Achse.
void write_f4_single_group_seg_csv(fs::path const& p) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    f << "binary_id;ns_per_op;op_insert_p50_ns;op_lookup_p50_ns;op_erase_p50_ns;op_scan_p50_ns;op_rmw_p50_ns;"
      << "total_ns;" << seg_header() << ";seg_run_total_ns;seg_coverage;workload;two_phase_valid\n";
    f << seg_row("k_ary", 999999, 10, 1.0, true, false) << "\n";
}

// Genau EINE (algo/op)-Kombination fuer die Range-Balken und EINE distinkte ns_per_op fuer die ECDF.
void write_f4_single_combo_p99_csv(fs::path const& p) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    f << "binary_id;ns_per_op;op_insert_p50_ns;op_insert_p99_ns;op_lookup_p50_ns;op_lookup_p99_ns;"
      << "op_erase_p50_ns;op_erase_p99_ns;op_scan_p50_ns;op_scan_p99_ns;op_rmw_p50_ns;op_rmw_p99_ns;"
      << "workload;two_phase_valid\n";
    f << "search_algo=k_ary/mapping=direct;671.532;0;0;750;1170;0;0;0;0;0;0;ycsb_c;1\n";
}

} // namespace

// (F-4/A) Ein einziger gemessener y-Wert -> NUR die y-Achse wird gesetzt, der Punkt bleibt EINER,
// und die Legende weist die Stichprobenzahl aus. Owner-Log: [671.532:671.532].
// M-1 (2026-09-16, Lens r1): der Zusatz darf NICHT "(n=1)" heissen -- die x-Achse dieser Figur heisst
// "Arbeitsmenge n (Schluessel)" / "working set n (keys)" und der einzige Punkt liegt bei n=4096; "(n=1)"
// laese sich dort als Arbeitsmenge 1. Der Test haelt daher BEIDE Sprachformen fest UND die Abwesenheit
// des alten Symbol-Zusatzes.
TEST(Stufe05Pipeline, SweepCurveSingleValueWidensOnlyTheYAxisAndNamesTheSampleCount) {
    auto p = comdare_user_tmp() / "f4a_single.csv";
    write_f4_single_point_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);
    ASSERT_EQ(rows.size(), 1u);
    ASSERT_TRUE(rows[0].has_op_n);

    auto            out = comdare_user_tmp() / "f4a_single.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_working_set_sweep_curve(out, rows, "ns_per_op", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "ymin=0, ymax=1343.0640")); // 2 * 671.532, nullpunktverankert
    EXPECT_TRUE(file_contains(out, "(1 sample)"));             // sichtbarer Hinweis in der Legende (en)
    EXPECT_FALSE(file_contains(out, "(n=1)"));                 // M-1: nie das Symbol der x-Achse
    EXPECT_EQ(count_occurrences(out, "(4096,"), 1u);           // KEIN erfundener zweiter Stuetzpunkt
    fs::remove(out, ec);

    // M-1: dieselbe Lage auf Deutsch -- der Zusatz ist sprachabhaengig, nicht durchgereichtes Englisch.
    auto out_de = comdare_user_tmp() / "f4a_single_de.tex";
    fs::remove(out_de, ec);
    ASSERT_EQ(dg::write_working_set_sweep_curve(out_de, rows, "ns_per_op", "de"), dg::status_ok);
    EXPECT_TRUE(file_contains(out_de, "(1 Messpunkt)"));
    EXPECT_FALSE(file_contains(out_de, "(n=1)"));
    EXPECT_EQ(count_occurrences(out_de, "(4096,"), 1u);
    fs::remove(out_de, ec);
    fs::remove(p, ec);
}

// (F-4/A, Gegenprobe) Mehrere distinkte y-Werte -> die y-Wache greift NICHT, die Emission bleibt
// byte-gleich zum Bestand (kein ymin=, kein Stichprobenzahl-Zusatz).
TEST(Stufe05Pipeline, SweepCurveSeveralValuesKeepTheAutomaticYAxis) {
    auto p = comdare_user_tmp() / "f4a_multi.csv";
    write_wide_csv_with_working_set(p, /*has_ws=*/true, /*single_ws=*/false);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "f4a_multi.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_working_set_sweep_curve(out, rows, "ns_per_op", "en"), dg::status_ok);
    EXPECT_FALSE(file_contains(out, "ymin="));
    EXPECT_FALSE(file_contains(out, "(1 sample)"));
    EXPECT_FALSE(file_contains(out, "(n=1)"));
    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (F-4/D) Die Operation wurde NIE ausgefuehrt (op_insert_n=0) -> KEINE 0-ns-Kurve, sondern der
// ehrliche Vermerk. Die Datei MUSS entstehen: der Anhang-Fallback wuerde sonst die fehlende
// working_set_n-Spalte als Grund nennen -- und die ist vorhanden.
TEST(Stufe05Pipeline, SweepCurveNeverExecutedOperationYieldsHonestNoteNotAZeroCurve) {
    auto p = comdare_user_tmp() / "f4d_phantom.csv";
    write_f4_single_point_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "f4d_phantom.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_working_set_sweep_curve(out, rows, "op_insert_p50_ns", "en"), dg::status_ok);
    ASSERT_TRUE(fs::exists(out));
    EXPECT_TRUE(file_contains(out, "HONEST-EMPTY"));
    EXPECT_TRUE(file_contains(out, "never executed"));
    EXPECT_FALSE(file_contains(out, "tikzpicture")); // keine Figur
    EXPECT_FALSE(file_contains(out, "addplot"));     // und erst recht kein (4096,0.0000)
    EXPECT_FALSE(file_contains(out, "0.0000)"));
    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (F-4/B) EINE Balken-Kategorie -> numerischer Index + xtick/xticklabels statt symbolic x coords,
// mit explizitem Fenster. Owner-Log seg_attribution: [0.0:0.0].
TEST(Stufe05Pipeline, SegmentAttributionSingleCategoryUsesNumericAxis) {
    auto p = comdare_user_tmp() / "f4b_seg_single.csv";
    write_f4_single_group_seg_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "f4b_seg_single.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_segment_attribution_stacked_bar(out, rows, "en"), dg::status_ok);
    // Auf die OPTION pruefen (mit "={"), nicht auf das Wort: der erklaerende Kommentar der Wache
    // nennt "symbolic x coords" im Fliesstext und wuerde eine Wort-Probe faelschlich reissen lassen.
    EXPECT_FALSE(file_contains(out, "symbolic x coords={"));
    EXPECT_FALSE(file_contains(out, "enlarge x limits=0.25"));
    EXPECT_TRUE(file_contains(out, "xmin=-0.5, xmax=0.5"));
    EXPECT_TRUE(file_contains(out, "xtick={0}"));
    EXPECT_TRUE(file_contains(out, "xticklabels={k\\_ary}"));
    EXPECT_TRUE(file_contains(out, "coordinates {(0,"));
    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (F-4/B, Gegenprobe) Zwei Kategorien -> symbolische Achse unveraendert (Bestandsverhalten).
TEST(Stufe05Pipeline, SegmentAttributionTwoCategoriesKeepTheSymbolicAxis) {
    auto p = comdare_user_tmp() / "f4b_seg_multi.csv";
    write_sample_wide_seg_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "f4b_seg_multi.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_segment_attribution_stacked_bar(out, rows, "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "symbolic x coords={"));
    EXPECT_TRUE(file_contains(out, "enlarge x limits=0.25"));
    EXPECT_FALSE(file_contains(out, "xticklabels="));
    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (F-4/B) Dieselbe Entartung im Range-Balken: EINE (algo/op)-Kombination. Owner-Log latency_range: [0.0:0.0].
TEST(Stufe05Pipeline, LatencyRangeSingleComboUsesNumericAxis) {
    auto p = comdare_user_tmp() / "f4b_range_single.csv";
    write_f4_single_combo_p99_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "f4b_range_single.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_latency_range_bar(out, rows, "en"), dg::status_ok);
    EXPECT_FALSE(file_contains(out, "symbolic x coords={")); // s. Hinweis im Seg-Test oben
    EXPECT_TRUE(file_contains(out, "xmin=-0.5, xmax=0.5"));
    EXPECT_TRUE(file_contains(out, "xticklabels={k\\_ary/lookup}"));
    EXPECT_TRUE(file_contains(out, "    (0,750.0000) +- (0,420.0000)"));
    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (F-4/B, Gegenprobe) Mehrere Kombinationen -> symbolische Achse unveraendert.
TEST(Stufe05Pipeline, LatencyRangeSeveralCombosKeepTheSymbolicAxis) {
    auto p = comdare_user_tmp() / "f4b_range_multi.csv";
    write_sample_wide_p99_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "f4b_range_multi.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_latency_range_bar(out, rows, "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "symbolic x coords={"));
    EXPECT_FALSE(file_contains(out, "xticklabels="));
    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (F-4/C) EINE distinkte Gesamt-Latenz -> Log-Oktave auf x. Owner-Log latency_ecdf: [6.50946:6.50946]
// (= ln(671.532), die interne Log-Koordinate).
TEST(Stufe05Pipeline, LatencyEcdfSingleSupportPointWidensTheLogXAxis) {
    auto p = comdare_user_tmp() / "f4c_ecdf_single.csv";
    write_f4_single_combo_p99_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "f4c_ecdf_single.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_latency_ecdf(out, rows, "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "xmin=335.7660, xmax=1343.0640")); // [v/2 : 2v]
    EXPECT_EQ(count_occurrences(out, "671.5320"), 2u);                // weiterhin NUR die 2 Treppenpunkte
    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (F-4/C, Gegenprobe) Mehrere distinkte Latenzen -> keine Achsen-Setzung (Bestandsverhalten).
TEST(Stufe05Pipeline, LatencyEcdfSeveralSupportPointsKeepTheAutomaticXAxis) {
    auto p = comdare_user_tmp() / "f4c_ecdf_multi.csv";
    write_sample_wide_p99_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto            out = comdare_user_tmp() / "f4c_ecdf_multi.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_latency_ecdf(out, rows, "en"), dg::status_ok);
    EXPECT_FALSE(file_contains(out, "xmin="));
    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (F-5) Die Konfigurations-Kopfzeile steht in einer UMBRECHENDEN p-Spalte und das Achsen-Tupel traegt
// nach jedem '/' eine Umbruch-Erlaubnis. Beides zusammen beseitigt den 1515.18507pt-Overfull
// (Mutationsproben M1/M2/M3, TeX Live 2026); es geht KEIN Zeichen der binary_id verloren.
TEST(Stufe05Pipeline, ObserverDetailHeaderRowBreaksInsteadOfOverflowing) {
    auto p = comdare_user_tmp() / "f5_observer_break.csv";
    write_observer_detail_wide_csv(p, /*all_na=*/false);
    std::vector<c2l::WideFullRow> rows;
    ASSERT_EQ(c2l::parse_wide_csv_full(p, rows), c2l::status_ok);

    auto            out = comdare_user_tmp() / "f5_observer_break.tex";
    std::error_code ec;
    fs::remove(out, ec);
    ASSERT_EQ(dg::write_axis_observer_detail_table(out, rows, "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out, "p{\\dimexpr\\linewidth-2\\tabcolsep\\relax}"));
    EXPECT_FALSE(file_contains(out, "\\multicolumn{3}{@{}l}{\\textbf{")); // die alte l-Spalte ist weg
    // binary_id "search_algo=k_ary/cache_traversal=direct" traegt genau EIN '/' -> genau EIN allowbreak.
    EXPECT_EQ(count_occurrences(out, "\\allowbreak{}"), 1u);
    EXPECT_TRUE(file_contains(out, "search\\_algo=k\\_ary/\\allowbreak{}cache\\_traversal=direct"));
    fs::remove(out, ec);
    fs::remove(p, ec);
}

// (P-F) chktex-RUECKFALL: die vier longtable-Marken tragen das abschliessende '%' (Warning 1), und die
// ECDF-CAPTION den Halbgeviertstrich (Warning 8). Der Owner hatte beides am 15.08. von Hand gesetzt
// (26f88a0); der Emitter erzeugte die Vorform weiter und haette lint:latex auf 289 wieder rot gefaerbt.
TEST(Stufe05Pipeline, EmittersKeepTheChktexCleanFormsOfCommit26f88a0) {
    std::error_code ec;

    auto p1 = comdare_user_tmp() / "pf_observer.csv";
    write_observer_detail_wide_csv(p1, /*all_na=*/false);
    std::vector<c2l::WideFullRow> frows;
    ASSERT_EQ(c2l::parse_wide_csv_full(p1, frows), c2l::status_ok);
    auto out1 = comdare_user_tmp() / "pf_observer.tex";
    fs::remove(out1, ec);
    ASSERT_EQ(dg::write_axis_observer_detail_table(out1, frows, "de"), dg::status_ok);
    EXPECT_TRUE(file_contains(out1, "\\endfirsthead%"));
    EXPECT_TRUE(file_contains(out1, "\\endhead%"));
    EXPECT_TRUE(file_contains(out1, "\\endfoot%"));
    EXPECT_TRUE(file_contains(out1, "\\endlastfoot%"));

    auto p2 = comdare_user_tmp() / "pf_ecdf.csv";
    write_sample_wide_p99_csv(p2);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p2, rows), dg::status_ok);
    auto out2 = comdare_user_tmp() / "pf_ecdf.tex";
    fs::remove(out2, ec);
    ASSERT_EQ(dg::write_latency_ecdf(out2, rows, "de"), dg::status_ok);
    // CAPTION mit '--' (chktex W8 biss genau hier), TITLE unveraendert mit '-' (Bestand 26f88a0).
    EXPECT_TRUE(file_contains(out2, "\\caption{ECDF der Gesamt-Latenz -- Verteilung ueber Konfigurationen}"));
    EXPECT_TRUE(file_contains(out2, "title={ECDF der Gesamt-Latenz - Verteilung ueber Konfigurationen}"));

    fs::remove(out1, ec);
    fs::remove(out2, ec);
    fs::remove(p1, ec);
    fs::remove(p2, ec);
}

// (S-1, 2026-09-16) chktex-REINHEIT DER HONEST-EMPTY(GROESSE)-VERMERKE -- zweite Haelfte der
// P-F-Klasse, Schwester von EmittersKeepTheChktexCleanFormsOfCommit26f88a0.
// BEFUND (Lens r1): die Groessen-Vermerke schrieben "1x1"/"2x2"; chktex-W29 ("$\times$ may look
// prettier here") beisst bei ZIFFER-x-ZIFFER (am Objekt gemessen; Wort-x-Wort wie
// "(Suchalgorithmus x Workload)" in der Caption beisst NICHT). Der Thesis-Bestand traegt seit dem
// Hand-Fix 26f88a0 die Mathe-Form -- ein Regeneratlauf haette sie zurueckgedreht und lint:latex auf
// 289 rot gefaerbt (die Dateien sind in anhang/{de,en}/A_measurements.tex HART per \input gebunden).
// Traeger der Heilung sind die ASCII-MARKEN (@MATH@/@BTIMES@/@TIMES@), die escape_latex unveraendert
// passieren und erst DANACH zur Mathe-Form werden (dasselbe Muster wie with_breaks bei F-5).
TEST(Stufe05Pipeline, HonestEmptySizeNotesKeepTheMathTimesFormsOfCommit26f88a0) {
    std::error_code ec;

    auto p = comdare_user_tmp() / "s1_size_note.csv";
    write_wide_csv_smoke_1x1(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    // (a) Heatmap-Pfad de: Groesse, Achsenpaar und Minimum alle in Mathe-Form.
    auto out_de = comdare_user_tmp() / "s1_size_note_de.tex";
    fs::remove(out_de, ec);
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out_de, rows, "ns_per_op", "de"), dg::status_ok);
    EXPECT_TRUE(file_contains(out_de, "$1{\\times}1$-Matrix"));
    EXPECT_TRUE(file_contains(out_de, "(Suchalgorithmen $\\times$ Workloads)"));
    EXPECT_TRUE(file_contains(out_de, "mindestens $2{\\times}2$."));
    // GEGENKOEDER: keine Marke darf in der Ausgabe stehenbleiben.
    EXPECT_FALSE(file_contains(out_de, "@MATH@"));
    EXPECT_FALSE(file_contains(out_de, "@BTIMES@"));
    EXPECT_FALSE(file_contains(out_de, "@TIMES@"));
    // Die CAPTION bleibt Bestand ("Suchalgorithmus x Workload") -- dort beisst chktex nicht.
    EXPECT_TRUE(file_contains(out_de, "(Suchalgorithmus x Workload)"));

    // (b) Heatmap-Pfad en.
    auto out_en = comdare_user_tmp() / "s1_size_note_en.tex";
    fs::remove(out_en, ec);
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out_en, rows, "ns_per_op", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out_en, "$1{\\times}1$ matrix"));
    EXPECT_TRUE(file_contains(out_en, "(search algorithms $\\times$ workloads)"));
    EXPECT_TRUE(file_contains(out_en, "at least $2{\\times}2$."));
    EXPECT_FALSE(file_contains(out_en, "@MATH@"));

    // (c) ratio-Pfad: derselbe Gegenstand, eigener Wortlaut -- eigener Nachweis.
    auto out_ratio = comdare_user_tmp() / "s1_size_note_ratio.tex";
    fs::remove(out_ratio, ec);
    ASSERT_EQ(dg::write_surface_ratio_vs_reference(out_ratio, rows, "ns_per_op", "k_ary", "en"), dg::status_ok);
    EXPECT_TRUE(file_contains(out_ratio, "$1{\\times}1$ matrix"));
    EXPECT_TRUE(file_contains(out_ratio, "at least $2{\\times}2$."));
    EXPECT_FALSE(file_contains(out_ratio, "@MATH@"));

    // (d) der NEUTRALE Default-Vermerk (HeatmapData::degenerate_size_note leer) traegt dieselbe Form.
    dg::HeatmapData d;
    d.title          = "neutral";
    d.x_label        = "workload";
    d.y_label        = "search algorithm";
    d.y_labels       = {"k_ary"};
    d.x_labels       = {"ycsb_c"};
    d.matrix         = {{1.0}};
    d.executed       = {{true}};
    auto out_neutral = comdare_user_tmp() / "s1_size_note_neutral.tex";
    fs::remove(out_neutral, ec);
    ASSERT_EQ(dg::write_heatmap(out_neutral, d), dg::status_ok);
    EXPECT_TRUE(file_contains(out_neutral, "1 row(s) $\\times$ 1 column(s)"));
    EXPECT_FALSE(file_contains(out_neutral, "@TIMES@"));

    fs::remove(out_de, ec);
    fs::remove(out_en, ec);
    fs::remove(out_ratio, ec);
    fs::remove(out_neutral, ec);
    fs::remove(p, ec);
}
