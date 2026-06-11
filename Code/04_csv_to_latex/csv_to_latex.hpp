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
    std::string  workload_used           = "n/a";  // V41.P1: 16-Spalten-Schema (4. Spalte)
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

// ── WIDE-Schema (tier×workload, 2026-06-11) ────────────────────────────────────────────────────────────
// Das Mess-System (cache-engine run_lazy_150 / lazy_csv_header) emittiert das ';'-getrennte WIDE-Schema:
// binary_id;setting;repetition;n_ops;total_ns;ns_per_op;19×seg_*_ns;13 Counter;…;119 stat_*;…;workload;
// two_phase_valid. Der Parser ist HEADER-GETRIEBEN (Spalten per Name aufgelöst, Reihenfolge/Breite-agnostisch
// → robust gegen additive Schema-Erweiterungen); extrahiert werden nur die auswertungs-relevanten Felder.

struct WideMeasurementRow {
    std::string  binary_id;          // volle statische Rekombination (19 Achsen-Belegungen)
    std::string  search_algo;        // aus binary_id extrahiert (führendes "search_algo=<wert>/")
    std::string  workload;           // Lastprofil-id (Achse 2; eigene Spalte "workload")
    std::uint64_t repetition = 0;
    std::uint64_t n_ops      = 0;
    std::uint64_t total_ns   = 0;
    double        ns_per_op  = 0.0;
    bool          two_phase_valid = false;   // Mess-GÜLTIGKEIT (Zwei-Phasen-Cache-Warmup exakt)
};

[[nodiscard]] int parse_wide_csv(std::filesystem::path const& in,
                                 std::vector<WideMeasurementRow>& out_rows);

/// Aggregat einer (search_algo × workload)-Zelle der Bias-Bruch-Matrix: Median (nearest-rank) der
/// ns_per_op über alle dyn-Settings × Repetitionen — NUR über two_phase_valid-Zeilen (ungültige
/// Messungen fließen NIE in Thesis-Tabellen).
struct TierWorkloadAggregate {
    std::string  search_algo;
    std::string  workload;
    std::size_t  samples          = 0;
    double       median_ns_per_op = 0.0;
};

[[nodiscard]] std::vector<TierWorkloadAggregate>
aggregate_tier_workload(std::span<WideMeasurementRow const> rows);

// Bias-Bruch-Matrix als booktabs-Tabelle: Zeilen = search_algo, Spalten = Lastprofile, Zelle = Median-
// ns/op (resizebox-skaliert; leere Zellen = "--"). lang = "de" | "en" (Spaltenkopf-Lokalisierung).
[[nodiscard]] int write_bias_matrix_latex(std::filesystem::path const& out,
                                          std::span<TierWorkloadAggregate const> aggs,
                                          std::string const& caption,
                                          std::string const& label,
                                          std::string const& lang = "en");

[[nodiscard]] std::string escape_latex(std::string_view s);

// Generiert booktabs-Tabelle mit 6 Hauptspalten.
// lang = "de" | "en" (C2, 2026-06-01): lokalisiert die Spaltenkopf-Zeile (+ Dezimalkomma für künftige
// Double-Spalten). Default "en" = rückwärtskompatibel. Die Caption liefert der Aufrufer sprachgerecht.
[[nodiscard]] int write_latex(std::filesystem::path const& out,
                              std::span<CsvRow const> rows,
                              std::string const& caption,
                              std::string const& label,
                              std::string const& lang = "en");

// Generiert Steckbrief pro Permutation-ID (parsed `ce_lockfree:art:tcmalloc:..`)
// → LaTeX-Beschreibungstabelle pro Baustein.
[[nodiscard]] std::string generate_baustein_description(std::string_view permutation_id);

}  // namespace comdare::da::csv_to_latex
