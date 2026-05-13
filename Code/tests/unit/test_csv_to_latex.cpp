// SPDX-License-Identifier: Apache-2.0
// Tests fuer csv_to_latex

#include "csv_to_latex.hpp"

#include <gtest/gtest.h>

#include <filesystem>
#include <fstream>
#include <sstream>

namespace c2l = comdare::da::csv_to_latex;

namespace {
[[nodiscard]] std::string read_file(std::filesystem::path const& p) {
    std::ifstream in{p};
    std::stringstream ss; ss << in.rdbuf();
    return ss.str();
}
}

TEST(CsvToLatex, EscapesSpecialCharacters) {
    EXPECT_EQ(c2l::escape_latex("a_b"), "a\\_b");
    EXPECT_EQ(c2l::escape_latex("100%"), "100\\%");
    EXPECT_EQ(c2l::escape_latex("$100"), "\\$100");
}

TEST(CsvToLatex, GenerateBausteinDescriptionParsesColons) {
    auto descr = c2l::generate_baustein_description("ce_lockfree:art:tcmalloc:ycsb_c");
    EXPECT_NE(descr.find("ce\\_lockfree"), std::string::npos);
    EXPECT_NE(descr.find("art"), std::string::npos);
    EXPECT_NE(descr.find("tcmalloc"), std::string::npos);
    EXPECT_NE(descr.find("ycsb\\_c"), std::string::npos);
}

TEST(CsvToLatex, BausteinDescriptionHasFourLabels) {
    auto descr = c2l::generate_baustein_description("a:b:c:d");
    EXPECT_NE(descr.find("Cache-Engine"), std::string::npos);
    EXPECT_NE(descr.find("Search-Algorithm"), std::string::npos);
    EXPECT_NE(descr.find("Allocator"), std::string::npos);
    EXPECT_NE(descr.find("Test-Data-Set"), std::string::npos);
}

TEST(CsvToLatex, ParseCsvOnNonExistentFails) {
    std::vector<c2l::CsvRow> rows;
    EXPECT_NE(c2l::parse_csv("/no/such/file.csv", rows), c2l::status_ok);
}

TEST(CsvToLatex, WriteLatexHasBooktabsStructure) {
    auto tmp = std::filesystem::temp_directory_path()
             / ("da_c2l_test_" + std::to_string(rand()) + ".tex");
    std::vector<c2l::CsvRow> rows;
    rows.push_back({"perm_test", 0xA, true, 100, 200, 30, 0, 0, 0, 0, 0, 0, 0, 0.0, 0.0});
    EXPECT_EQ(c2l::write_latex(tmp.string(), rows, "Test", "tab:test"), c2l::status_ok);
    auto content = read_file(tmp);
    EXPECT_NE(content.find("\\begin{table}"), std::string::npos);
    EXPECT_NE(content.find("\\toprule"), std::string::npos);
    EXPECT_NE(content.find("perm\\_test"), std::string::npos);
    std::filesystem::remove(tmp);
}
