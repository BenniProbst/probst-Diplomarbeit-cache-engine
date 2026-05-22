#pragma once
// csv_to_latex — Diplomarbeit/Code Module
// Konvertiert measurements.csv → LaTeX-booktabs-Tabelle + automatisierte
// Algorithmus-Baustein-Beschreibung.
//
// REV 7.6: zog aus cache-engine/tools/latex_anhang um. Erweitert um Funktion
// `generate_baustein_description`, die pro Permutations-ID einen kurzen
// Baustein-Steckbrief (Allokator + Concurrency + Prefetch + Telemetry)
// generiert.

#include <cstdint>
#include <filesystem>
#include <span>
#include <string>
#include <string_view>
#include <vector>

namespace comdare::da::csv_to_latex {

inline constexpr int status_ok           = 0;
inline constexpr int status_io_error     = 10;
inline constexpr int status_parse_error  = 11;

struct CsvRow {
    std::string permutation_id;
    std::uint64_t fingerprint            = 0;
    bool         succeeded               = false;
    std::uint64_t op_count               = 0;
    std::uint64_t total_cycles           = 0;
    std::uint64_t cache_misses_l1        = 0;
    std::uint64_t cache_misses_l2        = 0;
    std::uint64_t cache_misses_l3        = 0;
    std::uint64_t dtlb_misses            = 0;
    std::uint64_t coherence_invalidations = 0;
    std::uint64_t energy_micro_joules    = 0;
    std::uint64_t bytes_allocated        = 0;
    std::uint64_t bytes_in_use_peak      = 0;
    double        external_frag          = 0.0;
    double        internal_frag          = 0.0;
};

[[nodiscard]] int parse_csv(std::filesystem::path const& in,
                            std::vector<CsvRow>& out_rows);

[[nodiscard]] std::string escape_latex(std::string_view s);

// Generiert booktabs-Tabelle mit 6 Hauptspalten.
[[nodiscard]] int write_latex(std::filesystem::path const& out,
                              std::span<CsvRow const> rows,
                              std::string const& caption,
                              std::string const& label);

// Generiert Steckbrief pro Permutation-ID (parsed `ce_lockfree:art:tcmalloc:..`)
// → LaTeX-Beschreibungstabelle pro Baustein.
[[nodiscard]] std::string generate_baustein_description(std::string_view permutation_id);

}  // namespace comdare::da::csv_to_latex
