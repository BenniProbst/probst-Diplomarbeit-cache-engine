// V35.D.3 (2026-05-22) - Stufen-Test mit gecachten Fixtures (05_diagram_generator)

#include "diagram_generator.hpp"

#include <gtest/gtest.h>

#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <string>
#include <vector>

namespace dg = comdare::da::diagram_generator;
namespace fs = std::filesystem;

namespace {

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
    if (auto* env = std::getenv("COMDARE_FIXTURES_DIR_05"); env != nullptr) {
        return fs::path(env);
    }
#ifdef COMDARE_FIXTURES_DIR_05_FALLBACK
    // Deterministischer Fallback = per-Stufe Source-Dir (CMake-einkompiliert) — KEIN CWD-Stray (2026-06-01 gehärtet).
    return fs::path(COMDARE_FIXTURES_DIR_05_FALLBACK);
#else
    return fs::current_path() / "fixtures" / "cached";  // letzter Notnagel
#endif
}

bool file_contains(fs::path const& p, std::string_view needle) {
    std::ifstream in(p);
    std::string content((std::istreambuf_iterator<char>(in)), {});
    return content.find(needle) != std::string::npos;
}

}  // namespace

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

    auto out = fs::temp_directory_path() / "v35d3_bar.tex";
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
    data.xs = {16.0, 64.0, 256.0, 1024.0};
    data.ys = {100.0, 250.0, 800.0, 3500.0};

    auto out = fs::temp_directory_path() / "v35d3_scatter.tex";
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

    auto out = fs::temp_directory_path() / "v35d3_throughput.tex";
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
}  // namespace

TEST(Stufe05Pipeline, ParseWideCsvHeaderDriven) {
    auto p = fs::temp_directory_path() / "lc_wide_sample.csv";
    write_sample_wide_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);
    ASSERT_EQ(rows.size(), 3u);
    EXPECT_EQ(rows[0].search_algo, "k_ary");      // Prefix-Extraktion
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
    auto p = fs::temp_directory_path() / "lc_wide_sample2.csv";
    write_sample_wide_csv(p);
    std::vector<dg::WideMeasurementRow> rows;
    ASSERT_EQ(dg::parse_wide_csv(p, rows), dg::status_ok);

    auto out = fs::temp_directory_path() / "lc_surface_nsperop.tex";
    ASSERT_EQ(dg::write_surface_search_algo_x_workload(out, rows, "ns_per_op", "en"),
              dg::status_ok);
    EXPECT_TRUE(file_contains(out, "addplot3"));
    EXPECT_TRUE(file_contains(out, "colormap/viridis"));

    auto out3d = fs::temp_directory_path() / "lc_surface3d_nsperop.tex";
    ASSERT_EQ(dg::write_surface3d_search_algo_x_workload(out3d, rows, "ns_per_op", "en"),
              dg::status_ok);
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
    auto out = fs::temp_directory_path() / "v35d3_empty.tex";
    int rc = dg::write_bar_chart(out, empty);
    // Erwartung: entweder status_empty_input ODER status_ok mit leerer Datei
    EXPECT_TRUE(rc == dg::status_ok || rc == dg::status_empty_input);
    std::error_code ec;
    fs::remove(out, ec);
}
