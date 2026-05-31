// SPDX-License-Identifier: Apache-2.0
// V41.P1 — Cross-Stage-Test: beweist die 16-Spalten-Schema-Kohärenz Stufe 03 → 04 UND 03 → 05.
//
// Genau dieser Test fehlte (Audit w9iy2dhrc, Gap G2) → der CSV-Schema-Bruch (15 vs 16 Spalten) blieb
// unentdeckt, weil jede Stufe nur ihr eigenes, stufenübergreifend inkompatibles Fixture testete.
// Hier wird der ECHTE Stufe-03-Output durch Stufe 04 UND Stufe 05 getrieben.

#include "binary_to_csv.hpp"
#include "csv_to_latex.hpp"
#include "diagram_generator.hpp"

#include <gtest/gtest.h>

#include <filesystem>
#include <fstream>
#include <string>
#include <vector>

namespace btc = comdare::da::binary_to_csv;
namespace c2l = comdare::da::csv_to_latex;
namespace dg  = comdare::da::diagram_generator;

TEST(PipelineCrossStage, Stage03OutputFlowsInto04And05) {
    auto dir = std::filesystem::temp_directory_path() / "da_xstage_test";
    std::filesystem::create_directories(dir);
    auto const csv = dir / "stage03_out.csv";

    // --- Stufe 03: zwei Records mit UNTERSCHIEDLICHEM workload_used → 16-Spalten-CSV ---
    std::vector<btc::LabeledRecord> recs(2);
    recs[0].permutation_id = "ce:art:tcmalloc:none";
    recs[0].fingerprint = 1; recs[0].succeeded = true; recs[0].workload_used = "YCSB_A";
    recs[0].record.op_count = 1000; recs[0].record.total_cycles = 25000;
    recs[1].permutation_id = "pa:hot:mimalloc:zipf";
    recs[1].fingerprint = 2; recs[1].succeeded = true; recs[1].workload_used = "YCSB_C";
    recs[1].record.op_count = 2000; recs[1].record.total_cycles = 48000;
    ASSERT_EQ(btc::write_csv(csv, recs), btc::status_ok);

    // Stufe-03-Output MUSS 16 Spalten haben (workload_used an Index 3).
    std::ifstream in{csv};
    std::string header;
    std::getline(in, header);
    int ncols = 1;
    for (char c : header) if (c == ',') ++ncols;
    EXPECT_EQ(ncols, 16);
    EXPECT_NE(header.find("workload_used"), std::string::npos);

    // --- Stufe 04: liest die 16-Spalten-CSV OHNE Parse-Fehler (vorher: std::stoull("YCSB_A") Wurf) ---
    std::vector<c2l::CsvRow> latex_rows;
    ASSERT_EQ(c2l::parse_csv(csv.string(), latex_rows), c2l::status_ok);
    ASSERT_EQ(latex_rows.size(), 2u);
    EXPECT_EQ(latex_rows[0].workload_used, "YCSB_A");
    EXPECT_EQ(latex_rows[0].op_count, 1000u);  // op_count an der korrekt verschobenen Spalte (Index 4)
    EXPECT_EQ(latex_rows[1].workload_used, "YCSB_C");
    EXPECT_EQ(latex_rows[1].op_count, 2000u);

    // --- Stufe 05: lädt die 16-Spalten-CSV mit workload_used (Gruppierungs-Schlüssel) ---
    auto const diag_rows = dg::load_csv_with_workload_used(csv);
    ASSERT_EQ(diag_rows.size(), 2u);
    EXPECT_EQ(diag_rows[0].workload_used, "YCSB_A");
    EXPECT_EQ(diag_rows[0].op_count, 1000u);
    EXPECT_EQ(diag_rows[1].workload_used, "YCSB_C");

    std::error_code ec;
    std::filesystem::remove_all(dir, ec);
}
