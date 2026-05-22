// SPDX-License-Identifier: Apache-2.0
// CLI fuer binary_to_csv: liest .bin → schreibt .csv

#include "binary_to_csv.hpp"

#include <iostream>
#include <vector>

namespace btc = comdare::da::binary_to_csv;

int main(int argc, char* argv[]) {
    if (argc < 3) {
        std::cerr << "Usage: binary-to-csv <input.bin> <output.csv>\n";
        return 1;
    }
    std::vector<btc::LabeledRecord> records;
    int rc = btc::read_binary(argv[1], records);
    if (rc != 0) {
        std::cerr << "binary-to-csv: read_binary failed (status=" << rc << ")\n";
        return rc;
    }
    rc = btc::write_csv(argv[2], records);
    if (rc != 0) {
        std::cerr << "binary-to-csv: write_csv failed (status=" << rc << ")\n";
        return rc;
    }
    std::cout << "binary-to-csv: " << records.size() << " records -> " << argv[2] << "\n";
    return 0;
}
