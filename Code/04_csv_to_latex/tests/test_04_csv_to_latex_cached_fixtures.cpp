// V35.D.2 (2026-05-22) - Stufen-Test mit gecachten Fixtures (04_csv_to_latex)

#include "csv_to_latex.hpp"

#include <gtest/gtest.h>

#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <string>

namespace c2l = comdare::da::csv_to_latex;
namespace fs  = std::filesystem;

namespace {

void write_sample_csv(fs::path const& p) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    f << "permutation_id,fingerprint,succeeded,op_count,total_cycles,"
      << "cache_misses_l1,cache_misses_l2,cache_misses_l3,dtlb_misses,"
      << "coherence_invalidations,energy_micro_joules,"
      << "bytes_allocated,bytes_in_use_peak,external_frag,internal_frag\n";
    f << "ce_lockfree:art:tcmalloc:none,3405691582,1,1000,25000,50,10,2,1,0,12345,4096,3072,0.05,0.02\n";
    f << "pa_olc:hot:mimalloc:zipf,3405691583,1,2000,48000,100,20,5,2,0,23456,8192,6144,0.04,0.03\n";
    f << "ce_lockfree:masstree:jemalloc:none,3405691584,0,500,12000,0,0,0,0,0,0,0,0,0.0,0.0\n";
}

void ensure_cached_csv(fs::path const& p) {
    if (!fs::exists(p)) write_sample_csv(p);
}

fs::path fixtures_dir() {
    if (auto* env = std::getenv("COMDARE_FIXTURES_DIR_04"); env != nullptr) {
        return fs::path(env);
    }
#ifdef COMDARE_FIXTURES_DIR_04_FALLBACK
    // Deterministischer Fallback = per-Stufe Source-Dir (CMake-einkompiliert) — KEIN CWD-Stray (2026-06-01 gehärtet).
    return fs::path(COMDARE_FIXTURES_DIR_04_FALLBACK);
#else
    return fs::current_path() / "fixtures" / "cached";  // letzter Notnagel
#endif
}

}  // namespace

TEST(Stufe04Pipeline, CachedCsvFixtureExistsOrIsGenerated) {
    auto dir = fixtures_dir();
    ensure_cached_csv(dir / "sample_3_rows.csv");
    EXPECT_TRUE(fs::exists(dir / "sample_3_rows.csv"));
    EXPECT_GT(fs::file_size(dir / "sample_3_rows.csv"), 100u);
}

TEST(Stufe04Pipeline, ParseCachedCsv) {
    auto dir = fixtures_dir();
    ensure_cached_csv(dir / "sample_3_rows.csv");
    std::vector<c2l::CsvRow> rows;
    ASSERT_EQ(c2l::parse_csv(dir / "sample_3_rows.csv", rows), c2l::status_ok);
    ASSERT_EQ(rows.size(), 3u);
    EXPECT_EQ(rows[0].permutation_id, "ce_lockfree:art:tcmalloc:none");
    EXPECT_EQ(rows[0].op_count, 1000u);
    EXPECT_TRUE(rows[0].succeeded);
    EXPECT_FALSE(rows[2].succeeded);
}

TEST(Stufe04Pipeline, WriteLatexFromCachedFixture) {
    auto dir = fixtures_dir();
    ensure_cached_csv(dir / "sample_3_rows.csv");
    std::vector<c2l::CsvRow> rows;
    ASSERT_EQ(c2l::parse_csv(dir / "sample_3_rows.csv", rows), c2l::status_ok);

    auto out = fs::temp_directory_path() / "v35d2_table.tex";
    ASSERT_EQ(c2l::write_latex(out, rows, "Pipeline-Stage-04 Test", "tab:v35d2"), c2l::status_ok);

    std::string content;
    {
        std::ifstream in(out);
        content.assign((std::istreambuf_iterator<char>(in)), {});
    }
    EXPECT_NE(content.find("\\begin{tabular}"), std::string::npos);
    EXPECT_NE(content.find("\\caption{Pipeline-Stage-04 Test}"), std::string::npos);
    EXPECT_NE(content.find("\\label{tab:v35d2}"), std::string::npos);

    std::error_code ec;
    fs::remove(out, ec);
}

TEST(Stufe04Pipeline, BausteinDescriptionFromPermutationId) {
    auto desc = c2l::generate_baustein_description("ce_lockfree:art:tcmalloc:leaf_only_counter");
    EXPECT_FALSE(desc.empty());
    // Steckbrief sollte ART und tcmalloc nennen
    bool mentions_art = desc.find("art") != std::string::npos
                     || desc.find("ART") != std::string::npos;
    bool mentions_tcmalloc = desc.find("tcmalloc") != std::string::npos;
    EXPECT_TRUE(mentions_art || mentions_tcmalloc);  // mindestens einer
}

TEST(Stufe04Pipeline, EscapeLatexHandlesSpecialChars) {
    EXPECT_EQ(c2l::escape_latex("plain text"), "plain text");
    auto escaped = c2l::escape_latex("100% done & ok");
    EXPECT_NE(escaped.find("\\%"), std::string::npos);
    EXPECT_NE(escaped.find("\\&"), std::string::npos);
}

// ── WIDE-Schema (tier×workload, 2026-06-11) ──────────────────────────────────────────────────────────
// Fixture = schema-treue Mini-Variante des Mess-CSVs (';'-getrennt; der Parser ist HEADER-getrieben →
// das Fixture braucht nur die benannten Spalten + beliebige weitere [hier: 2 stat-Dummies], in beliebiger
// Reihenfolge — exakt die Robustheits-Eigenschaft, die gegen das echte 136-Spalten-Schema trägt).
namespace {

void write_wide_sample_csv(fs::path const& p) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    f << "binary_id;setting;repetition;n_ops;total_ns;ns_per_op;stat_search_algo_lookup;"
      << "stat_allocator_bytes_alloc;workload;two_phase_valid\n";
    // k_ary × ycsb_c: 3 Samples (Mediane prüfbar: 100,200,300 → nearest-rank-Median 200)
    f << "search_algo=k_ary/node_type=node4;s=1/rep=0;0;1000;100000;100.0;1000;64000;ycsb_c;1\n";
    f << "search_algo=k_ary/node_type=node4;s=1/rep=1;1;1000;200000;200.0;1000;64000;ycsb_c;1\n";
    f << "search_algo=k_ary/node_type=node4;s=1/rep=2;2;1000;300000;300.0;1000;64000;ycsb_c;1\n";
    // k_ary × ih: 1 Sample
    f << "search_algo=k_ary/node_type=node4;s=1/rep=0;0;1000;500000;500.0;1000;64000;ih;1\n";
    // eytzinger × ycsb_c: 1 gültiges + 1 UNGÜLTIGES Sample (two_phase_valid=0 → MUSS ausgefiltert werden)
    f << "search_algo=eytzinger/node_type=node4;s=1/rep=0;0;1000;150000;150.0;1000;64000;ycsb_c;1\n";
    f << "search_algo=eytzinger/node_type=node4;s=1/rep=1;1;1000;90000;90.0;1000;64000;ycsb_c;0\n";
}

}  // anonymous namespace

TEST(Stufe04Pipeline, ParseWideCsvHeaderDriven) {
    auto dir = fixtures_dir();
    write_wide_sample_csv(dir / "sample_wide_rows.csv");
    std::vector<c2l::WideMeasurementRow> rows;
    ASSERT_EQ(c2l::parse_wide_csv(dir / "sample_wide_rows.csv", rows), c2l::status_ok);
    ASSERT_EQ(rows.size(), 6u);
    EXPECT_EQ(rows[0].search_algo, "k_ary");
    EXPECT_EQ(rows[0].workload, "ycsb_c");
    EXPECT_DOUBLE_EQ(rows[0].ns_per_op, 100.0);
    EXPECT_TRUE(rows[0].two_phase_valid);
    EXPECT_EQ(rows[4].search_algo, "eytzinger");
    EXPECT_FALSE(rows[5].two_phase_valid);
}

TEST(Stufe04Pipeline, AggregateTierWorkloadMedianAndValidityFilter) {
    auto dir = fixtures_dir();
    write_wide_sample_csv(dir / "sample_wide_rows.csv");
    std::vector<c2l::WideMeasurementRow> rows;
    ASSERT_EQ(c2l::parse_wide_csv(dir / "sample_wide_rows.csv", rows), c2l::status_ok);
    auto const aggs = c2l::aggregate_tier_workload(rows);
    ASSERT_EQ(aggs.size(), 3u);   // (eytzinger,ycsb_c) (k_ary,ih) (k_ary,ycsb_c) — map-sortiert
    EXPECT_EQ(aggs[0].search_algo, "eytzinger");
    EXPECT_EQ(aggs[0].samples, 1u);                       // das two_phase_valid=0-Sample ist GEFILTERT
    EXPECT_DOUBLE_EQ(aggs[0].median_ns_per_op, 150.0);
    EXPECT_EQ(aggs[2].search_algo, "k_ary");
    EXPECT_EQ(aggs[2].workload, "ycsb_c");
    EXPECT_EQ(aggs[2].samples, 3u);
    EXPECT_DOUBLE_EQ(aggs[2].median_ns_per_op, 200.0);    // nearest-rank-Median von {100,200,300}
}

TEST(Stufe04Pipeline, WriteBiasMatrixLatex) {
    auto dir = fixtures_dir();
    write_wide_sample_csv(dir / "sample_wide_rows.csv");
    std::vector<c2l::WideMeasurementRow> rows;
    ASSERT_EQ(c2l::parse_wide_csv(dir / "sample_wide_rows.csv", rows), c2l::status_ok);
    auto const aggs = c2l::aggregate_tier_workload(rows);

    auto out = fs::temp_directory_path() / "wide_bias_matrix.tex";
    ASSERT_EQ(c2l::write_bias_matrix_latex(out, aggs, "Bias-Bruch-Matrix Test", "tab:biasmatrix", "de"),
              c2l::status_ok);
    std::string content;
    {
        std::ifstream in(out);
        content.assign((std::istreambuf_iterator<char>(in)), {});
    }
    EXPECT_NE(content.find("\\begin{tabular}{lrr}"), std::string::npos);   // 2 Workload-Spalten (ih, ycsb_c)
    EXPECT_NE(content.find("Suchverfahren"), std::string::npos);           // lang=de
    EXPECT_NE(content.find("k\\_ary"), std::string::npos);
    EXPECT_NE(content.find("& 200"), std::string::npos);                   // Median-Zelle k_ary×ycsb_c
    EXPECT_NE(content.find("& --"), std::string::npos);                    // leere Zelle eytzinger×ih
    std::error_code ec;
    fs::remove(out, ec);
}
