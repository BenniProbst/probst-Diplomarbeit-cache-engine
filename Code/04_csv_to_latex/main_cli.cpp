// SPDX-License-Identifier: Apache-2.0
#include "csv_to_latex.hpp"

#include <iostream>
#include <vector>

namespace c2l = comdare::da::csv_to_latex;

int main(int argc, char* argv[]) {
    if (argc < 3) {
        std::cerr
            << "Usage: csv-to-latex <input.csv> <output.tex> "
            << "[--caption=<text>] [--label=<text>] [--lang=de|en] [--schema=legacy|wide]\n"
            << "  --schema=wide: tier×workload-WIDE-Schema (';'-getrennt, header-getrieben) →\n"
            << "                 Bias-Bruch-Matrix (Zeilen=search_algo, Spalten=Lastprofile,\n"
            << "                 Zelle=Median ns/op, nur two_phase_valid).\n";
        return 1;
    }
    std::string caption = "Comdare Permutations";
    std::string label   = "tab:comdare:perms";
    std::string lang    = "en";   // C2 (2026-06-01): bilingualer Compile-Schalter (de|en)
    std::string schema  = "legacy";   // 2026-06-11: "wide" = tier×workload-Schema des Mess-Voll-Laufs
    for (int i = 3; i < argc; ++i) {
        std::string a{argv[i]};
        if (a.rfind("--caption=", 0) == 0) caption = a.substr(10);
        else if (a.rfind("--label=", 0) == 0) label = a.substr(8);
        else if (a.rfind("--lang=", 0) == 0) lang = a.substr(7);
        else if (a.rfind("--schema=", 0) == 0) schema = a.substr(9);
    }

    if (schema == "wide") {
        std::vector<c2l::WideMeasurementRow> rows;
        int rc = c2l::parse_wide_csv(argv[1], rows);
        if (rc != 0) { std::cerr << "csv-to-latex: parse_wide_csv failed " << rc << "\n"; return rc; }
        auto const aggs = c2l::aggregate_tier_workload(rows);
        rc = c2l::write_bias_matrix_latex(argv[2], aggs, caption, label, lang);
        if (rc != 0) { std::cerr << "csv-to-latex: write_bias_matrix_latex failed " << rc << "\n"; return rc; }
        std::cout << "csv-to-latex (wide): " << rows.size() << " rows -> " << aggs.size()
                  << " (search_algo×workload)-Zellen -> " << argv[2] << "\n";
        return 0;
    }

    std::vector<c2l::CsvRow> rows;
    int rc = c2l::parse_csv(argv[1], rows);
    if (rc != 0) { std::cerr << "csv-to-latex: parse_csv failed " << rc << "\n"; return rc; }
    rc = c2l::write_latex(argv[2], rows, caption, label, lang);
    if (rc != 0) { std::cerr << "csv-to-latex: write_latex failed " << rc << "\n"; return rc; }
    std::cout << "csv-to-latex: " << rows.size() << " rows -> " << argv[2] << "\n";
    return 0;
}
