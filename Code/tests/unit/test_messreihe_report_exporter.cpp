// V34.B.2 (2026-05-21) - MessreiheReportExporter Tests

#include "../../02_messung_driver/messreihe_report_exporter.hpp"

#include <gtest/gtest.h>

#include <algorithm>
#include <filesystem>
#include <fstream>
#include <sstream>
#include <string>

namespace v32 = comdare::diplomarbeit::messung_driver::v32;
namespace cmd = comdare::cache_engine::builder::commands;

namespace {

v32::MessreiheReport make_sample_report() {
    v32::MessreiheReport rep;
    rep.total_axes = 2;
    rep.total_variants = 4;

    auto make_outcome = [](std::string axis, std::string variant,
                            cmd::CompareEngineCommand::Verdict verdict) {
        v32::PermutationOutcome o;
        o.axis_id = std::move(axis);
        o.variant_name = std::move(variant);
        o.verdict = verdict;
        o.ee_a_result.engine_name = "CacheEngine-EE-A";
        o.ee_a_result.throughput_ops_per_sec = 1000.0;
        o.ee_a_result.latency_p99 = std::chrono::nanoseconds(500);
        o.ee_a_result.total_cache_misses = 10;
        o.ee_b_result.engine_name = "PrtArt-EE-B";
        o.ee_b_result.throughput_ops_per_sec = 1200.0;
        o.ee_b_result.latency_p99 = std::chrono::nanoseconds(400);
        o.ee_b_result.total_cache_misses = 8;
        o.welch_p_value = 0.03;
        o.throughput_ratio = 0.833;
        return o;
    };

    rep.outcomes.push_back(make_outcome("11", "LeafOnlyCounter",
        cmd::CompareEngineCommand::Verdict::EE_B_Wins));
    rep.outcomes.push_back(make_outcome("11", "Sampled",
        cmd::CompareEngineCommand::Verdict::Tie));
    rep.outcomes.push_back(make_outcome("12.1", "AVX2",
        cmd::CompareEngineCommand::Verdict::EE_A_Wins));
    rep.outcomes.push_back(make_outcome("12.1", "AVX512",
        cmd::CompareEngineCommand::Verdict::EE_B_Wins));

    rep.ee_a_wins = 1;
    rep.ee_b_wins = 2;
    rep.ties = 1;
    rep.total_elapsed = std::chrono::nanoseconds(42'000'000);
    return rep;
}

std::string read_all(const std::filesystem::path& p) {
    std::ifstream f(p);
    std::stringstream ss;
    ss << f.rdbuf();
    return ss.str();
}

}  // namespace

TEST(MessreiheReportExporter, WriteCsvHappyPath) {
    v32::MessreiheReportExporter exporter;
    auto report = make_sample_report();
    auto path = std::filesystem::temp_directory_path() / "v34_b_report.csv";
    auto status = exporter.write_csv(report, path);
    EXPECT_TRUE(status.ok()) << status.message;

    auto content = read_all(path);
    EXPECT_NE(content.find("axis_id,variant_name,verdict"), std::string::npos);
    EXPECT_NE(content.find("11,LeafOnlyCounter,EE_B_Wins"), std::string::npos);
    EXPECT_NE(content.find("12.1,AVX2,EE_A_Wins"), std::string::npos);
    EXPECT_NE(content.find("CacheEngine-EE-A"), std::string::npos);
    EXPECT_NE(content.find("PrtArt-EE-B"), std::string::npos);
}

TEST(MessreiheReportExporter, WriteTikzSummary) {
    v32::MessreiheReportExporter exporter;
    auto report = make_sample_report();
    auto path = std::filesystem::temp_directory_path() / "v34_b_summary.tex";
    auto status = exporter.write_tikz_summary(report, path);
    EXPECT_TRUE(status.ok()) << status.message;

    auto content = read_all(path);
    EXPECT_NE(content.find("\\begin{tikzpicture}"), std::string::npos);
    EXPECT_NE(content.find("ybar stacked"), std::string::npos);
    EXPECT_NE(content.find("symbolic x coords={11,12.1}"), std::string::npos);
    EXPECT_NE(content.find("\\legend{EE-A wins"), std::string::npos);
    EXPECT_NE(content.find("Total: axes=2 variants=4"), std::string::npos);
}

TEST(MessreiheReportExporter, EmptyReportFails) {
    v32::MessreiheReportExporter exporter;
    v32::MessreiheReport empty;
    auto status = exporter.write_csv(empty, std::filesystem::temp_directory_path() / "empty.csv");
    EXPECT_FALSE(status.ok());
    EXPECT_EQ(status.code, v32::ExportStatus::Code::EmptyReport);
}

TEST(MessreiheReportExporter, IoErrorOnInvalidPath) {
    v32::MessreiheReportExporter exporter;
    auto report = make_sample_report();
    auto status = exporter.write_csv(report, "/nonexistent_dir_xyz/output.csv");
    EXPECT_FALSE(status.ok());
    EXPECT_EQ(status.code, v32::ExportStatus::Code::IoError);
}

TEST(MessreiheReportExporter, CsvRowsMatchOutcomeCount) {
    v32::MessreiheReportExporter exporter;
    auto report = make_sample_report();
    auto path = std::filesystem::temp_directory_path() / "v34_b_rowcount.csv";
    exporter.write_csv(report, path);
    auto content = read_all(path);
    // 1 header + 4 outcomes = 5 newlines
    std::size_t newlines = std::count(content.begin(), content.end(), '\n');
    EXPECT_EQ(newlines, 5u);
}
