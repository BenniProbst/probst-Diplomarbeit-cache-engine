// SPDX-License-Identifier: Apache-2.0
// Ad-hoc MSVC-Verifikationstreiber für L1 ("Ausgabe = Testdaten-Konfig × Tier").
// KEIN gtest-Target (deren _deps-Toolchain ist vorbestehend defekt) — eigenständiger main(), der
// csv_to_latex.cpp mit-kompiliert. CSV-Pfad als CLI-Argument (KEINE absoluten Pfade im Code).
//
// Bau (vcvars64): cl /std:c++latest /EHsc /Od adhoc_l1_driver.cpp csv_to_latex.cpp
// Lauf:           adhoc_l1_driver.exe <partial_snapshot.csv>

#include "csv_to_latex.hpp"

#include <cstdio>
#include <span>
#include <string>
#include <vector>

using namespace comdare::da::csv_to_latex;

int main(int argc, char** argv) {
    if (argc < 2) {
        std::fprintf(stderr, "usage: %s <wide_csv_path>\n", argv[0]);
        return 2;
    }

    std::vector<WideMeasurementRow> rows;
    int const rc = parse_wide_csv(argv[1], rows);
    if (rc != status_ok) {
        std::fprintf(stderr, "parse_wide_csv failed: status=%d\n", rc);
        return rc;
    }

    // (a) Anzahl geparster Zeilen + two_phase_valid-Anteil.
    std::size_t valid = 0;
    for (auto const& r : rows) if (r.two_phase_valid) ++valid;
    std::printf("== (a) parse summary ==\n");
    std::printf("rows parsed       : %zu\n", rows.size());
    std::printf("two_phase_valid   : %zu (%.1f%%)\n",
                valid, rows.empty() ? 0.0 : 100.0 * double(valid) / double(rows.size()));

    if (rows.empty()) return 0;

    // (b) Erste Zeile: KONFIG-Tupel, 19-Achsen-TIER-Tupel, {op_art -> p50_ns}.
    auto const& r0 = rows.front();
    std::printf("\n== (b) first row ==\n");
    std::printf("[KONFIG] thread_count=%llu prefetch_distance=%llu repetition_index=%llu\n",
                (unsigned long long)r0.config.thread_count,
                (unsigned long long)r0.config.prefetch_distance,
                (unsigned long long)r0.config.repetition_index);
    std::printf("[KONFIG] workload_id=%s n_ops=%llu records=%s\n",
                r0.config.workload_id.c_str(),
                (unsigned long long)r0.config.n_ops,
                r0.config.has_records ? std::to_string(r0.config.records).c_str() : "<absent>");
    std::printf("[TIER]   %zu axes (binary_id):\n", r0.axes.size());
    for (auto const& a : r0.axes)
        std::printf("           %-20s = %s\n", a.axis.c_str(), a.value.c_str());
    std::printf("[TIER]   axis_value(search_algo) accessor = %.*s\n",
                int(r0.axis_value("search_algo").size()), r0.axis_value("search_algo").data());
    std::printf("[OPLAT]  {op_art -> n / p50_ns / p99_ns}:\n");
    for (std::size_t k = 0; k < kOpKindCount; ++k)
        std::printf("           %-7.*s n=%llu p50=%lld p99=%lld\n",
                    int(kOpKindNames[k].size()), kOpKindNames[k].data(),
                    (unsigned long long)r0.op_latency[k].n,
                    (long long)r0.op_latency[k].p50_ns,
                    (long long)r0.op_latency[k].p99_ns);

    // (c) Per-Op-Art-Aggregat einer (binary_id x workload)-Zelle.
    auto const per_op = aggregate_tier_workload_per_op(rows);
    std::printf("\n== (c) aggregate_tier_workload_per_op ==\n");
    std::printf("cells: %zu (binary_id x workload)\n", per_op.size());
    if (!per_op.empty()) {
        // Erste Zelle exemplarisch (deterministisch sortiert via std::map).
        auto const& c0 = per_op.front();
        std::string short_bin = c0.binary_id.substr(0, 40);
        std::printf("example cell: workload=%s samples=%zu\n", c0.workload.c_str(), c0.samples);
        std::printf("  binary_id[0..40]=%s...\n", short_bin.c_str());
        std::printf("  median p50_ns per op:\n");
        for (std::size_t k = 0; k < kOpKindCount; ++k)
            std::printf("    %-7.*s = %.1f\n",
                        int(kOpKindNames[k].size()), kOpKindNames[k].data(),
                        c0.median_p50_ns_per_op[k]);
    }
    return 0;
}
