// REV 7.6 V21.3 — Sample-Mess-Daten-Generator
//
// Erzeugt eine V20-konforme Sample-CSV mit 10 Permutationen, damit
// die Diagramm-Pipeline (V21.4) und Auswertung (V21.3) bereits jetzt
// getestet werden koennen, OHNE auf reale Hardware-Mess-Daten zu warten.
//
// Reale Mess-Daten ersetzen diesen Output nach V21.2 (HW-E2E).
//
// CLI: sample_data_generator <output_csv_path>

#include <cstdint>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <random>
#include <string>
#include <string_view>
#include <vector>

namespace {

struct SampleProfile {
    std::string   id;
    std::string   workload_used;   // V20.1: YCSB_A..F
    std::uint64_t base_throughput; // ops/sec
    std::uint64_t base_cache_misses_l1;
    std::uint64_t base_bytes_in_use_peak;
};

[[nodiscard]] std::vector<SampleProfile> sample_profiles() {
    return {
        {"art_p01", "YCSB_C", 12'000'000ULL, 1'200'000ULL, 256'000'000ULL},
        {"hot_p02", "YCSB_C", 14'500'000ULL, 980'000ULL, 220'000'000ULL},
        {"masstree_p03", "YCSB_A", 9'200'000ULL, 1'400'000ULL, 310'000'000ULL},
        {"coco_trie_p04", "YCSB_C", 16'800'000ULL, 750'000ULL, 180'000'000ULL},
        {"start_p05", "YCSB_C", 11'400'000ULL, 1'050'000ULL, 240'000'000ULL},
        {"b2tree_p06", "YCSB_C", 10'800'000ULL, 1'150'000ULL, 270'000'000ULL},
        {"wormhole_p07", "YCSB_E", 8'500'000ULL, 1'650'000ULL, 340'000'000ULL},
        {"surf_p10", "YCSB_A", 11'200'000ULL, 1'080'000ULL, 195'000'000ULL},
        {"btreesareback_p20", "YCSB_E", 9'800'000ULL, 1'320'000ULL, 290'000'000ULL},
        {"prtart_baseline", "YCSB_F", 10'500'000ULL, 1'200'000ULL, 245'000'000ULL},
    };
}

} // namespace

int main(int argc, char** argv) {
    if (argc < 2) {
        std::cerr << "Usage: sample_data_generator <output_csv_path>\n";
        return EXIT_FAILURE;
    }

    std::ofstream out{argv[1]};
    if (!out) {
        std::cerr << "Cannot open output: " << argv[1] << "\n";
        return EXIT_FAILURE;
    }

    // V20.3 — CSV-Header (4. Spalte workload_used)
    out << "permutation_id,fingerprint,succeeded,workload_used,op_count,total_cycles,"
        << "cache_misses_l1,cache_misses_l2,cache_misses_l3,dtlb_misses,"
        << "coherence_invalidations,energy_micro_joules,"
        << "bytes_allocated,bytes_in_use_peak,external_frag,internal_frag\n";

    std::mt19937_64                        rng{42ULL}; // deterministisch fuer Reproduzierbarkeit
    std::uniform_real_distribution<double> jitter{0.85, 1.15};

    auto const    profiles   = sample_profiles();
    std::uint64_t fp_counter = 0xC0FFEE0000000000ULL;
    for (auto const& p : profiles) {
        std::uint64_t const op_count      = 1'000'000ULL;
        double const        tput_jitter   = jitter(rng);
        double const        cycles_per_op = 1e9 / (p.base_throughput * tput_jitter);
        std::uint64_t const total_cyc     = static_cast<std::uint64_t>(op_count * cycles_per_op);
        std::uint64_t const l1_misses     = static_cast<std::uint64_t>(p.base_cache_misses_l1 * jitter(rng));
        std::uint64_t const l2_misses     = l1_misses / 7;
        std::uint64_t const l3_misses     = l2_misses / 5;
        std::uint64_t const dtlb          = l1_misses / 12;
        std::uint64_t const coherence     = l1_misses / 25;
        std::uint64_t const energy_uj     = static_cast<std::uint64_t>(total_cyc * 0.0035);
        std::uint64_t const bytes_alc     = static_cast<std::uint64_t>(p.base_bytes_in_use_peak * 1.20 * jitter(rng));
        std::uint64_t const bytes_use     = static_cast<std::uint64_t>(p.base_bytes_in_use_peak * jitter(rng));
        double const        ext_frag      = 0.05 + 0.05 * jitter(rng);
        double const        int_frag      = 0.02 + 0.02 * jitter(rng);

        out << p.id << ',' << (fp_counter++) << ",1," << p.workload_used << ',' << op_count << ',' << total_cyc << ','
            << l1_misses << ',' << l2_misses << ',' << l3_misses << ',' << dtlb << ',' << coherence << ',' << energy_uj
            << ',' << bytes_alc << ',' << bytes_use << ',' << ext_frag << ',' << int_frag << '\n';
    }

    std::cout << "[V21.3] Sample-Mess-CSV geschrieben: " << argv[1] << " (" << profiles.size() << " Permutationen)\n";
    std::cout << "        Reale Mess-Daten ersetzen dies nach V21.2 (HW-E2E)\n";
    return EXIT_SUCCESS;
}
