// SPDX-License-Identifier: Apache-2.0
// CLI fuer diagram_generator: liest CSV → erzeugt TikZ Bar-Chart-Demo.
// Echter Pipeline-Aufruf erfolgt aus messung_driver.

#include "diagram_generator.hpp"

#include <fstream>
#include <iostream>
#include <sstream>
#include <string>

namespace dg = comdare::da::diagram_generator;

int main(int argc, char* argv[]) {
    // V22.1 — neuer Subcommand --by-workload erzeugt gruppierten Bar-Chart aus
    // V20.3-konformer measurements.csv (16 Spalten inkl. workload_used).
    if (argc >= 4 && std::string{argv[1]} == "--by-workload") {
        auto rows = dg::load_csv_with_workload_used(argv[2]);
        if (rows.empty()) {
            std::cerr << "load_csv_with_workload_used: 0 rows\n";
            return 11;
        }
        int const rc = dg::write_throughput_by_workload(argv[3], rows);
        if (rc != 0) {
            std::cerr << "write_throughput_by_workload failed: " << rc << "\n";
            return rc;
        }
        std::cout << "diagram-generator: " << rows.size()
                  << " rows by workload -> " << argv[3] << "\n";
        return 0;
    }

    if (argc < 3) {
        std::cerr << "Usage: diagram-generator <input.csv> <output.tex>\n"
                  << "       (Demo: liest 1. Spalte = label, 2. Spalte = value)\n"
                  << "  oder: diagram-generator --by-workload <input.csv> <output.tex>\n"
                  << "       (V22.1: V20.3-CSV gruppiert nach workload_used)\n";
        return 1;
    }
    std::ifstream f{argv[1]};
    if (!f) { std::cerr << "Input not readable\n"; return 10; }

    dg::BarChartData bar;
    bar.title   = "Comdare Measurement Comparison";
    bar.x_label = "Permutation";
    bar.y_label = "Cycles";

    std::string line;
    std::getline(f, line);  // skip header
    while (std::getline(f, line)) {
        if (line.empty()) continue;
        auto comma = line.find(',');
        if (comma == std::string::npos) continue;
        bar.labels.push_back(line.substr(0, comma));
        auto next_comma = line.find(',', comma + 1);
        // op_count + total_cycles als value (Spalte 4 nach Schema)
        std::istringstream iss{line.substr(comma + 1)};
        std::string token;
        int idx = 0;
        double val = 0.0;
        while (std::getline(iss, token, ',')) {
            if (idx == 3) {  // total_cycles
                try { val = std::stod(token); } catch (...) {}
                break;
            }
            ++idx;
        }
        bar.values.push_back(val);
    }

    int rc = dg::write_bar_chart(argv[2], bar);
    if (rc != 0) {
        std::cerr << "write_bar_chart failed: " << rc << "\n";
        return rc;
    }
    std::cout << "diagram-generator: " << bar.labels.size()
              << " bars -> " << argv[2] << "\n";
    return 0;
}
