// SPDX-License-Identifier: Apache-2.0
// V36.D (2026-05-23) - Runtime-Check fuer Pre-Build-Permutationen
//
// User-Direktive Sonderfall: "Keine Prebuilds vorhanden und bauen ist aus,
// dann Error: Kein Experiment möglich"
//
// Triggert FATAL wenn beide Manifeste leer/missing — dann hat kein Experiment
// einen Sinn, weil keine Permutationen zum durchlaufen verfuegbar sind.

#pragma once

#include <cstdint>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <string>

#ifndef COMDARE_PERMUTATIONS_MANIFEST_CE
#define COMDARE_PERMUTATIONS_MANIFEST_CE ""
#endif
#ifndef COMDARE_PERMUTATIONS_MANIFEST_PA
#define COMDARE_PERMUTATIONS_MANIFEST_PA ""
#endif

namespace comdare::messung_driver {

struct PermutationsAvailability {
    std::size_t cache_engine_count {0};
    std::size_t prt_art_count {0};
    bool ce_manifest_found {false};
    bool pa_manifest_found {false};
};

inline std::size_t count_manifest_entries(std::filesystem::path const& p) {
    if (!std::filesystem::exists(p)) {
        return 0;
    }
    std::ifstream in(p);
    if (!in) {
        return 0;
    }
    std::size_t count {0};
    for (std::string line; std::getline(in, line);) {
        if (line.empty() || line.front() == '#') {
            continue;
        }
        ++count;
    }
    return count;
}

inline PermutationsAvailability probe_permutations() {
    PermutationsAvailability a;
    std::filesystem::path ce {COMDARE_PERMUTATIONS_MANIFEST_CE};
    std::filesystem::path pa {COMDARE_PERMUTATIONS_MANIFEST_PA};
    a.ce_manifest_found  = std::filesystem::exists(ce);
    a.pa_manifest_found  = std::filesystem::exists(pa);
    a.cache_engine_count = count_manifest_entries(ce);
    a.prt_art_count      = count_manifest_entries(pa);
    return a;
}

// Return: 0 = ok, 2 = no permutations available (fatal)
[[nodiscard]] inline int assert_permutations_available_or_die() {
    auto a = probe_permutations();
    if (a.cache_engine_count == 0 && a.prt_art_count == 0) {
        std::cerr << "FATAL [V36.D]: Kein Experiment moeglich.\n"
                  << "  cache-engine Permutationen: " << a.cache_engine_count
                  << " (manifest=" << COMDARE_PERMUTATIONS_MANIFEST_CE
                  << ", found=" << a.ce_manifest_found << ")\n"
                  << "  prt-art Pruefling-Permutationen: " << a.prt_art_count
                  << " (manifest=" << COMDARE_PERMUTATIONS_MANIFEST_PA
                  << ", found=" << a.pa_manifest_found << ")\n"
                  << "  Loesung: cmake -DCOMDARE_PERMUTATION_MODE=on_build_on_demand "
                  << "und cmake --build <preset> --target comdare_perms_all\n";
        return 2;
    }
    std::cout << "[V36.D] Permutationen: cache-engine=" << a.cache_engine_count
              << "  prt-art=" << a.prt_art_count << "\n";
    return 0;
}

}  // namespace comdare::messung_driver
