// SPDX-License-Identifier: Apache-2.0
// Tests fuer diagram_generator

#include "diagram_generator.hpp"

#include <gtest/gtest.h>

#include <filesystem>
#include <fstream>
#include <sstream>
#include <unistd.h>

namespace dg = comdare::da::diagram_generator;

namespace {

// Benutzer-eindeutige tmp-Basis: /tmp ist host-weit geteilt (prod1: lokale Läufe als comdare, CI als
// gitlab-runner) — feste Namen gehören dem Erst-Ersteller und blocken den jeweils anderen (8081/213626).
std::filesystem::path comdare_user_tmp() {
    auto p = std::filesystem::temp_directory_path() / ("comdare_test_" + std::to_string(::getuid()));
    std::filesystem::create_directories(p);
    return p;
}

[[nodiscard]] std::string read_file(std::filesystem::path const& p) {
    std::ifstream     in{p};
    std::stringstream ss;
    ss << in.rdbuf();
    return ss.str();
}
} // namespace

TEST(DiagramGenerator, EscapesUnderscoresInLabel) { EXPECT_EQ(dg::escape_latex("ce_lockfree"), "ce\\_lockfree"); }

TEST(DiagramGenerator, BarChartProducesValidTikz) {
    auto             tmp = comdare_user_tmp() / "da_dg_bar.tex";
    dg::BarChartData data;
    data.title   = "Test";
    data.x_label = "Perm";
    data.y_label = "Cycles";
    data.labels  = {"A", "B", "C"};
    data.values  = {1.0, 2.0, 3.0};

    EXPECT_EQ(dg::write_bar_chart(tmp, data), dg::status_ok);
    auto content = read_file(tmp);
    EXPECT_NE(content.find("\\begin{tikzpicture}"), std::string::npos);
    EXPECT_NE(content.find("\\begin{axis}"), std::string::npos);
    EXPECT_NE(content.find("ybar"), std::string::npos);
    EXPECT_NE(content.find("symbolic x coords={A,B,C}"), std::string::npos);
    std::filesystem::remove(tmp);
}

TEST(DiagramGenerator, BarChartEmptyReturnsError) {
    auto             tmp = comdare_user_tmp() / "da_dg_empty.tex";
    dg::BarChartData data;
    EXPECT_EQ(dg::write_bar_chart(tmp, data), dg::status_empty_input);
}

TEST(DiagramGenerator, A4ConstraintsAppliedCorrectly) {
    auto             tmp = comdare_user_tmp() / "da_dg_a4.tex";
    dg::BarChartData data;
    data.title  = "A4 Test";
    data.labels = {"X"};
    data.values = {1.0};
    dg::PageConstraints cnst;
    cnst.width_fraction  = 0.95;
    cnst.height_fraction = 0.40;
    EXPECT_EQ(dg::write_bar_chart(tmp, data, cnst), dg::status_ok);

    auto content = read_file(tmp);
    EXPECT_NE(content.find("0.9500\\textwidth"), std::string::npos);
    EXPECT_NE(content.find("0.4000\\textheight"), std::string::npos);
    std::filesystem::remove(tmp);
}

TEST(DiagramGenerator, ScatterPlotProducesValidTikz) {
    auto            tmp = comdare_user_tmp() / "da_dg_scatter.tex";
    dg::ScatterData data;
    data.title = "Scatter Test";
    data.xs    = {1.0, 2.0, 3.0};
    data.ys    = {1.5, 2.5, 3.5};
    EXPECT_EQ(dg::write_scatter_plot(tmp, data), dg::status_ok);

    auto content = read_file(tmp);
    EXPECT_NE(content.find("only marks"), std::string::npos);
    EXPECT_NE(content.find("(1.0000,1.5000)"), std::string::npos);
    std::filesystem::remove(tmp);
}

TEST(DiagramGenerator, HeatmapProducesValidTikz) {
    auto            tmp = comdare_user_tmp() / "da_dg_heatmap.tex";
    dg::HeatmapData data;
    data.title    = "Heatmap Test";
    data.x_labels = {"X1", "X2"};
    data.y_labels = {"Y1", "Y2"};
    data.matrix   = {{1.0, 2.0}, {3.0, 4.0}};
    EXPECT_EQ(dg::write_heatmap(tmp, data), dg::status_ok);

    auto content = read_file(tmp);
    EXPECT_NE(content.find("matrix plot"), std::string::npos);
    EXPECT_NE(content.find("colormap/viridis"), std::string::npos);
    EXPECT_NE(content.find("X1"), std::string::npos);
    std::filesystem::remove(tmp);
}
