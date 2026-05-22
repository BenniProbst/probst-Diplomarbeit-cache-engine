// SPDX-License-Identifier: Apache-2.0
#include "binary_to_csv.hpp"

#include <fstream>

namespace comdare::da::binary_to_csv {

int read_binary(std::filesystem::path const& in,
                std::vector<LabeledRecord>& out_records) {
    std::ifstream f{in, std::ios::binary};
    if (!f) return status_io_error;

    std::uint32_t magic   = 0;
    std::uint32_t version = 0;
    std::uint64_t n       = 0;
    f.read(reinterpret_cast<char*>(&magic),   sizeof(magic));
    f.read(reinterpret_cast<char*>(&version), sizeof(version));
    f.read(reinterpret_cast<char*>(&n),       sizeof(n));
    if (magic != kBinaryMagic)     return status_invalid_format;
    if (version != kBinaryVersion) return status_invalid_format;

    out_records.clear();
    out_records.reserve(static_cast<std::size_t>(n));

    for (std::uint64_t i = 0; i < n; ++i) {
        LabeledRecord r;
        std::uint32_t id_len = 0;
        f.read(reinterpret_cast<char*>(&id_len), sizeof(id_len));
        r.permutation_id.resize(id_len);
        f.read(r.permutation_id.data(), id_len);
        f.read(reinterpret_cast<char*>(&r.fingerprint), sizeof(r.fingerprint));
        std::uint8_t succ = 0;
        f.read(reinterpret_cast<char*>(&succ), sizeof(succ));
        r.succeeded = (succ != 0);
        f.read(reinterpret_cast<char*>(&r.record), sizeof(r.record));
        if (!f) return status_invalid_format;
        out_records.push_back(std::move(r));
    }
    return status_ok;
}

int write_csv(std::filesystem::path const& out,
              std::span<LabeledRecord const> records) {
    std::ofstream f{out};
    if (!f) return status_io_error;

    f << "permutation_id,fingerprint,succeeded,op_count,total_cycles,"
      << "cache_misses_l1,cache_misses_l2,cache_misses_l3,dtlb_misses,"
      << "coherence_invalidations,energy_micro_joules,"
      << "bytes_allocated,bytes_in_use_peak,external_frag,internal_frag\n";

    for (auto const& r : records) {
        auto const& m = r.record;
        f << r.permutation_id << ','
          << r.fingerprint << ','
          << (r.succeeded ? 1 : 0) << ','
          << m.op_count << ','
          << m.total_cycles << ','
          << m.cache_misses_l1 << ','
          << m.cache_misses_l2 << ','
          << m.cache_misses_l3 << ','
          << m.dtlb_misses << ','
          << m.coherence_invalidations << ','
          << m.energy_micro_joules << ','
          << m.bytes_allocated << ','
          << m.bytes_in_use_peak << ','
          << m.external_fragmentation << ','
          << m.internal_fragmentation << '\n';
    }
    return f.good() ? status_ok : status_io_error;
}

}  // namespace comdare::da::binary_to_csv
