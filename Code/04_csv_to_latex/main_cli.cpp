// SPDX-License-Identifier: Apache-2.0
#include "csv_to_latex.hpp"

#include <iostream>
#include <vector>

namespace c2l = comdare::da::csv_to_latex;

int main(int argc, char* argv[]) {
    if (argc < 3) {
        std::cerr
            << "Usage: csv-to-latex <input.csv> <output.tex> "
            << "[--caption=<text>] [--label=<text>]\n";
        return 1;
    }
    std::string caption = "Comdare Permutations";
    std::string label   = "tab:comdare:perms";
    for (int i = 3; i < argc; ++i) {
        std::string a{argv[i]};
        if (a.rfind("--caption=", 0) == 0) caption = a.substr(10);
        else if (a.rfind("--label=", 0) == 0) label = a.substr(8);
    }

    std::vector<c2l::CsvRow> rows;
    int rc = c2l::parse_csv(argv[1], rows);
    if (rc != 0) { std::cerr << "csv-to-latex: parse_csv failed " << rc << "\n"; return rc; }
    rc = c2l::write_latex(argv[2], rows, caption, label);
    if (rc != 0) { std::cerr << "csv-to-latex: write_latex failed " << rc << "\n"; return rc; }
    std::cout << "csv-to-latex: " << rows.size() << " rows -> " << argv[2] << "\n";
    return 0;
}
