// V35.D.3 (2026-05-22) - Stufen-Test mit gecachten Fixtures (05_diagram_generator)

#include "diagram_generator.hpp"

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

namespace dg = comdare::da::diagram_generator;
namespace fs = std::filesystem;

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

constexpr int kSegN = 20; // 19 Organ-Achsen + framework

std::string seg_header() {
    return "seg_search_algo_ns;seg_cache_traversal_ns;seg_mapping_ns;seg_path_compression_ns;"
           "seg_node_type_ns;seg_memory_layout_ns;seg_allocator_ns;seg_prefetch_ns;"
           "seg_concurrency_ns;seg_serialization_ns;seg_telemetry_ns;seg_value_handle_ns;"
           "seg_isa_ns;seg_index_organization_ns;seg_io_dispatch_ns;seg_migration_policy_ns;"
           "seg_filter_ns;seg_queuing_q1_ns;seg_queuing_q2_ns;seg_framework_ns";
}

// Eine schema-treue WIDE-Datenzeile. seg_mult>0 → 20 seg_*_ns = seg_mult*(i+1), seg_run_total_ns = seg_mult*210
// (== Σ der 20 Segmente, seg_coverage=coverage). na_first=true → seg_search_algo_ns="n/a" (Guard-Test).
// total_ns wird BEWUSST sehr verschieden von seg_run_total_ns gesetzt (Inkommensurabilitaets-Beleg).
std::string seg_row(std::string const& algo, long total_ns, int seg_mult, double coverage, bool two_phase,
                    bool na_first) {
    std::ostringstream r;
    r << "search_algo=" << algo << "/mapping=direct;" // binary_id
      << "42.0;30;25;28;500;40;"                      // ns_per_op + 5 op_*_p50_ns
      << total_ns << ";";                             // total_ns (DARF NIE Stapel-Ganzes sein)
    long sum = 0;
    for (int i = 0; i < kSegN; ++i) {
        if (i > 0) r << ";";
        if (i == 0 && na_first) {
            r << "n/a";
        } else {
            long const v = static_cast<long>(seg_mult) * (i + 1);
            r << v;
            sum += v;
        }
    }
    long const run_total = na_first ? sum : static_cast<long>(seg_mult) * 210;
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
    f << seg_row("k_ary", 999999, 10, 1.0, true, false) << "\n";        // gueltig  Σ=2100
    f << seg_row("k_ary", 999999, 10, 1.0, true, false) << "\n";        // gueltig  Σ=2100 (Mittel bleibt 2100)
    f << seg_row("interpolation", 888888, 5, 1.0, true, false) << "\n"; // gueltig  Σ=1050
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
    // 1. gueltige k_ary-Zeile: alle 20 seg vorhanden, seg_run_total_ns=2100, coverage vorhanden.
    EXPECT_TRUE(rows[0].has_seg_ns);
    EXPECT_TRUE(rows[0].has_seg_run_total);
    EXPECT_TRUE(rows[0].has_seg_coverage);
    EXPECT_DOUBLE_EQ(rows[0].seg_run_total_ns, 2100.0);
    EXPECT_DOUBLE_EQ(rows[0].seg_ns[0], 10.0);   // seg_search_algo_ns
    EXPECT_DOUBLE_EQ(rows[0].seg_ns[19], 200.0); // seg_framework_ns
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
    ASSERT_EQ(agg.segment_labels.size(), 20u);
    EXPECT_EQ(agg.segment_labels[0], "search_algo");
    EXPECT_EQ(agg.segment_labels[19], "framework");
    ASSERT_EQ(agg.means.size(), 20u);

    // (a) Die 20 Segmente stapeln je Gruppe zu seg_run_total_ns (Coverage≈1) — NICHT zu total_ns.
    for (std::size_t g = 0; g < agg.groups.size(); ++g) {
        double stack = 0.0;
        for (std::size_t s = 0; s < 20u; ++s) stack += agg.means[s][g];
        EXPECT_NEAR(stack, agg.group_totals[g], 1e-6);
        EXPECT_NEAR(stack, agg.run_total_means[g], 1e-6); // == Mittel seg_run_total_ns (kommensurabel)
        EXPECT_NEAR(agg.coverage_means[g], 1.0, 1e-6);
    }
    // k_ary: zwei gueltige Zeilen (Σ=2100 je), n/a- + two_phase=0-Zeile VERWORFEN → Mittel bleibt 2100 (nicht verwaessert).
    EXPECT_NEAR(agg.group_totals[1], 2100.0, 1e-6);
    EXPECT_NEAR(agg.group_totals[0], 1050.0, 1e-6); // interpolation

    // (b) total_ns (999999 / 888888) taucht NICHT als Stapel-Ganzes auf.
    EXPECT_NE(agg.group_totals[1], 999999.0);
    EXPECT_NE(agg.group_totals[0], 888888.0);
    std::error_code ec;
    fs::remove(p, ec);
}

TEST(Stufe05Pipeline, SegAttributionStackedBarEmitsTwentyAddplots) {
    auto p = comdare_user_tmp() / "p4_wide_seg_writer.csv";
    write_sample_wide_seg_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto out = comdare_user_tmp() / "p4_seg_attribution.tex";
    ASSERT_EQ(dg::write_segment_attribution_stacked_bar(out, rows, "de"), dg::status_ok);
    // (c) valides pgfplots: ybar stacked, exakt 20 \addplot + 20 \addlegendentry.
    EXPECT_TRUE(file_contains(out, "ybar stacked"));
    EXPECT_EQ(count_occurrences(out, "\\addplot"), 20u);
    EXPECT_EQ(count_occurrences(out, "\\addlegendentry"), 20u);
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
    for (std::size_t oi = 0; oi < agg.ops.size(); ++oi)
        for (std::size_t ai = 0; ai < agg.algos.size(); ++ai)
            if (agg.present[oi][ai]) EXPECT_GE(agg.p99_median[oi][ai], agg.p50_median[oi][ai]);

    // scan nur fuer k_ary (Index 1) vorhanden, NICHT fuer eytzinger; No-Op ycsb_e (1/2) ausgeschlossen →
    // Median bleibt 500/700 (nicht durch 1/2 verwaessert).
    EXPECT_FALSE(agg.present[2][0]); // scan × eytzinger
    ASSERT_TRUE(agg.present[2][1]);  // scan × k_ary
    EXPECT_DOUBLE_EQ(agg.p50_median[2][1], 500.0);
    EXPECT_DOUBLE_EQ(agg.p99_median[2][1], 700.0);
    // k_ary insert nearest-rank-Median [100,120] → 120 (obere), p99 [200,240] → 240.
    EXPECT_DOUBLE_EQ(agg.p50_median[0][1], 120.0);
    EXPECT_DOUBLE_EQ(agg.p99_median[0][1], 240.0);
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
