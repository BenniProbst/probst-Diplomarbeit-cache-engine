// SPDX-License-Identifier: Apache-2.0
// V41.B1 (2026-05-24) - Binary Measurement-Records pro Permutation
//
// Schreibt binary-File im Format das Stage 03 (binary_to_csv) erwartet:
//   uint32 magic = 0xC0FFEE02
//   uint32 version = 2   (V41.P1: v2 fuegt workload_used hinzu; v1 = ohne)
//   uint64 num_records
//   foreach record:
//     uint32 perm_id_len + char[perm_id_len]
//     uint64 fingerprint
//     uint8  succeeded
//     [v2+] uint32 workload_len + char[workload_len]   (workload_used, z.B. "micro"/"YCSB_A")
//     comdare_measurement_record_v1 (fixed-size POD)

#pragma once

#include <cache_engine/abi/module_abi_v1.hpp>

#include <cstdint>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <string>
#include <string_view>
#include <vector>

namespace comdare::messung_driver {

inline constexpr std::uint32_t kMeasurementMagic   = 0xC0FFEE02u;
inline constexpr std::uint32_t kMeasurementVersion = 2u; // V41.P1: v2 = + workload_used pro Record

class MeasurementWriter {
public:
    explicit MeasurementWriter(std::filesystem::path const& path) : path_{path} {
        std::filesystem::create_directories(path.parent_path());
        ofs_.open(path, std::ios::binary | std::ios::trunc);
        if (!ofs_) { return; }
        // Header schreiben (num_records vorerst 0, am Ende ueberschrieben)
        ofs_.write(reinterpret_cast<char const*>(&kMeasurementMagic), sizeof(std::uint32_t));
        ofs_.write(reinterpret_cast<char const*>(&kMeasurementVersion), sizeof(std::uint32_t));
        std::uint64_t zero{0};
        ofs_.write(reinterpret_cast<char const*>(&zero), sizeof(std::uint64_t));
    }

    [[nodiscard]] bool ok() const { return ofs_.is_open() && !ofs_.fail(); }

    // V41.P1: workload_used (z.B. "micro" fuer den Plugin-Mikrobench, "YCSB_A".. fuer echte Reihen)
    // wird als laengen-praefixierter String VOR dem POD-Record geschrieben (Container-v2).
    void add(std::string_view perm_id, std::uint64_t fingerprint, bool succeeded, std::string_view workload_used,
             comdare_measurement_record_v1 const& rec) {
        if (!ofs_) return;
        std::uint32_t const id_len = static_cast<std::uint32_t>(perm_id.size());
        ofs_.write(reinterpret_cast<char const*>(&id_len), sizeof(std::uint32_t));
        ofs_.write(perm_id.data(), static_cast<std::streamsize>(id_len));
        ofs_.write(reinterpret_cast<char const*>(&fingerprint), sizeof(std::uint64_t));
        std::uint8_t const succ_byte = succeeded ? 1u : 0u;
        ofs_.write(reinterpret_cast<char const*>(&succ_byte), sizeof(std::uint8_t));
        std::uint32_t const wl_len = static_cast<std::uint32_t>(workload_used.size());
        ofs_.write(reinterpret_cast<char const*>(&wl_len), sizeof(std::uint32_t));
        ofs_.write(workload_used.data(), static_cast<std::streamsize>(wl_len));
        ofs_.write(reinterpret_cast<char const*>(&rec), sizeof(comdare_measurement_record_v1));
        ++num_records_;
    }

    // Finalisiert die Datei: aktualisiert num_records im Header.
    void finalize() {
        if (!ofs_) return;
        ofs_.flush();
        // num_records steht an Offset 8 (nach magic + version)
        ofs_.seekp(static_cast<std::streamoff>(2 * sizeof(std::uint32_t)));
        ofs_.write(reinterpret_cast<char const*>(&num_records_), sizeof(std::uint64_t));
        ofs_.flush();
        ofs_.close();
    }

    ~MeasurementWriter() { finalize(); }

    [[nodiscard]] std::uint64_t                count() const { return num_records_; }
    [[nodiscard]] std::filesystem::path const& path() const { return path_; }

private:
    std::filesystem::path path_;
    std::ofstream         ofs_;
    std::uint64_t         num_records_{0};
};

// Helper: us/op + Achsen-Info -> measurement_record_v1
// Anti-Phantom (Ledger §0, "honest-0 statt Schaetzung"): total_cycles und bytes_* werden NICHT aus
// us/op oder op_count fabriziert. Ohne realen PMU-/Allocator-Zaehler bleiben sie honest-0 -- exakt wie
// die Cache-Miss-Felder unten. Die reale Zeit-Messung (micros_per_op) wird separat in der Stats-CSV
// (compute_stats) gefuehrt; dieser Binary-Record erfindet keinen Zyklen-/Byte-Wert aus einer fixen
// Takt-/Bucket-Konstante (frueher: total_us*3000 @ 3 GHz bzw. n_ops*64). Phase 6+: echten PMU-Counter ablesen.
inline comdare_measurement_record_v1 make_record_from_run(std::uint64_t n_ops, [[maybe_unused]] double micros_per_op) {
    comdare_measurement_record_v1 r{};
    r.version                 = kMeasurementVersion;
    r.op_count                = n_ops;
    r.total_cycles            = 0; // honest-0: kein realer Zyklen-Counter in diesem Pfad (Phase 6+: PMU)
    r.cache_misses_l1         = 0; // Phase 6+: PMU-Counter
    r.cache_misses_l2         = 0;
    r.cache_misses_l3         = 0;
    r.dtlb_misses             = 0;
    r.coherence_invalidations = 0;
    r.energy_micro_joules     = 0;
    r.bytes_allocated         = 0; // honest-0: kein realer Allocator-Zaehler in diesem Pfad (Phase 6+)
    r.bytes_in_use_peak       = 0; // honest-0
    r.external_fragmentation  = 0.0;
    r.internal_fragmentation  = 0.0;
    return r;
}

// Stable Hash fuer perm_id -> Fingerprint (FNV-1a 64-bit)
inline std::uint64_t fingerprint_of(std::string_view s) {
    std::uint64_t h = 14695981039346656037ULL;
    for (char c : s) {
        h ^= static_cast<std::uint64_t>(static_cast<unsigned char>(c));
        h *= 1099511628211ULL;
    }
    return h;
}

} // namespace comdare::messung_driver
