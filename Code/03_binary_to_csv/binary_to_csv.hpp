#pragma once
// binary_to_csv — Diplomarbeit/Code Module
// Deserialisiert measurement_record_v1 binary → CSV (16 Spalten, V41.P1 kanonisch inkl. workload_used).

#include <cache_engine/abi/module_abi_v1.hpp>

#include <cstdint>
#include <filesystem>
#include <span>
#include <string>
#include <vector>

namespace comdare::da::binary_to_csv {

inline constexpr int status_ok             = 0;
inline constexpr int status_io_error       = 10;
inline constexpr int status_invalid_format = 11;

struct LabeledRecord {
    std::string                   permutation_id;
    std::uint64_t                 fingerprint   = 0;
    bool                          succeeded     = true;
    std::string                   workload_used = "n/a"; // V41.P1: aus Container-v2; "n/a" bei v1
    comdare_measurement_record_v1 record{};
};

// Liest binary-File mit folgendem Layout:
//   uint32 magic = 0xC0FFEE02
//   uint32 version
//   uint64 num_records
//   foreach record:
//     uint32 perm_id_len + char[perm_id_len]
//     uint64 fingerprint
//     uint8  succeeded
//     [v2+] uint32 workload_len + char[workload_len]   (V41.P1)
//     comdare_measurement_record_v1 record  (fixed-size)
[[nodiscard]] int read_binary(std::filesystem::path const& in, std::vector<LabeledRecord>& out_records);

// Schreibt CSV mit 16 Spalten (V41.P1 kanonisch: workload_used als 4. Spalte; kompatibel zu
// Stufe 01/04/05 + ResultAggregator).
[[nodiscard]] int write_csv(std::filesystem::path const& out, std::span<LabeledRecord const> records);

inline constexpr std::uint32_t kBinaryMagic     = 0xC0FFEE02u;
inline constexpr std::uint32_t kBinaryVersion   = 2u; // V41.P1: aktuelles Schreib-/Lese-Format
inline constexpr std::uint32_t kBinaryVersionV1 = 1u; // legacy (ohne workload_used) weiter lesbar

} // namespace comdare::da::binary_to_csv
