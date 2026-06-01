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
