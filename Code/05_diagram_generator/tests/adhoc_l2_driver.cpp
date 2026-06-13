// SPDX-License-Identifier: Apache-2.0
// AD-HOC L2-Verifikationstreiber (NICHT Teil des CMake-Builds; gtest-Targets sind durch _deps blockiert).
// Kompiliert csv_to_latex.cpp + diagram_generator.cpp mit, parst eine Teil-CSV (nur lesend) und erzeugt
// die 3D-Surfaces. Ausgabe: Surface-Zahl + echte z-Zellen je Surface.
#include "../diagram_generator.hpp"

#include <iostream>
#include <string>
#include <vector>

namespace dg = comdare::da::diagram_generator;

int main(int argc, char* argv[]) {
    if (argc < 3) {
        std::cerr << "Usage: adhoc_l2_driver <wide.csv> <out_dir>\n";
        return 2;
    }
    std::vector<dg::Surface3dModel> models;
    int const rc = dg::generate_wide3d_surfaces(argv[1], argv[2], models, {});
    if (rc != 0) {
        std::cerr << "generate_wide3d_surfaces rc=" << rc << "\n";
        return rc;
    }
    std::cout << "L2-ADHOC: " << models.size() << " surfaces erzeugt\n";
    std::size_t total = 0;
    for (auto const& m : models) {
        std::cout << "  surface[" << m.op_name << "] real_z_cells=" << m.real_cell_count
                  << " grid=" << m.tier_ids.size() << "x" << m.workload_ids.size() << "\n";
        total += m.real_cell_count;
    }
    std::cout << "L2-ADHOC: gesamt echte z-Zellen=" << total << "\n";
    return 0;
}
