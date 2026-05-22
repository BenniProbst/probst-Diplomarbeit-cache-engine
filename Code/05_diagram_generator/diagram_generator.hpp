#pragma once
// diagram_generator — Diplomarbeit/Code Module
// C++ Bildgenerator: erzeugt TikZ-Code (kein Python, F-EXTRA-5 konform).
//
// REV 7.6 Q3: User-Entscheidung "TikZ-Code generieren" — kein Python,
// A4-Awareness durch direkten LaTeX-Output, Diagramme kommen automatisch
// im LaTeX-Layout mit korrekter Seitenpositionierung.
//
// 3 Plot-Typen:
//   Bar      — Vergleich diskreter Permutationen
//   Scatter  — XY-Korrelation (z. B. allocation_size vs. latency)
//   Heatmap  — 2D-Matrix (z. B. workload × permutation)
//
// A4-Seitenformat-Constraints:
//   width  = 0.95 * \textwidth   (etwas Rand fuer caption/numbering)
//   height = 0.40 * \textheight  (max 40% Seitenhoehe, damit 2 Diagramme
//                                 + Text auf eine Seite passen)

#include <cstdint>
#include <filesystem>
#include <span>
#include <string>
#include <string_view>
#include <vector>

namespace comdare::da::diagram_generator {

inline constexpr int status_ok          = 0;
inline constexpr int status_io_error    = 10;
inline constexpr int status_empty_input = 11;

// A4-Seitenformat-Constraints
struct PageConstraints {
    double width_fraction      = 0.95;    // * \textwidth
    double height_fraction     = 0.40;    // * \textheight
    bool   keep_aspect_ratio   = true;
    std::string position_hint  = "!htbp"; // LaTeX-Float-Position
};

// ─────────────────────────────────────────────────────────────────────────────
// Bar-Chart
// ─────────────────────────────────────────────────────────────────────────────
struct BarChartData {
    std::string title;
    std::string x_label;
    std::string y_label;
    std::vector<std::string>  labels;   // X-Achsen-Beschriftung
    std::vector<double>       values;   // Y-Werte (gleicher Index wie labels)
};

[[nodiscard]] int write_bar_chart(std::filesystem::path const& out,
                                   BarChartData const& data,
                                   PageConstraints const& cnst = {});

// ─────────────────────────────────────────────────────────────────────────────
// Scatter-Plot
// ─────────────────────────────────────────────────────────────────────────────
struct ScatterData {
    std::string title;
    std::string x_label;
    std::string y_label;
    std::vector<double> xs;
    std::vector<double> ys;
};

[[nodiscard]] int write_scatter_plot(std::filesystem::path const& out,
                                      ScatterData const& data,
                                      PageConstraints const& cnst = {});

// ─────────────────────────────────────────────────────────────────────────────
// Heatmap (2D-Matrix)
// ─────────────────────────────────────────────────────────────────────────────
struct HeatmapData {
    std::string title;
    std::string x_label;
    std::string y_label;
    std::vector<std::string> x_labels;
    std::vector<std::string> y_labels;
    std::vector<std::vector<double>> matrix;  // matrix[y][x]
};

[[nodiscard]] int write_heatmap(std::filesystem::path const& out,
                                 HeatmapData const& data,
                                 PageConstraints const& cnst = {});

// LaTeX-Escape (lokal, NICHT abhaengig von csv_to_latex)
[[nodiscard]] std::string escape_latex(std::string_view s);

// ─────────────────────────────────────────────────────────────────────────────
// REV 7.6 V22.1 — Sample-CSV-Loader + workload-Gruppen-Plot
// ─────────────────────────────────────────────────────────────────────────────
//
// Liest eine V20.3-konforme measurements.csv (16 Spalten):
//   permutation_id, fingerprint, succeeded, workload_used, op_count,
//   total_cycles, cache_misses_l1..l3, dtlb_misses, coherence_invalidations,
//   energy_micro_joules, bytes_allocated, bytes_in_use_peak,
//   external_frag, internal_frag
//
// Berechnet pro Zeile throughput_ops_per_sec = op_count * 1e9 / total_cycles
// (cycles als Nanosekunden interpretiert, V21.3 Sample-Daten-Konvention).

struct CsvRow {
    std::string   permutation_id;
    std::string   workload_used;     // YCSB_A..F (V20.1)
    std::uint64_t op_count;
    std::uint64_t total_cycles;
    std::uint64_t cache_misses_l1;
    std::uint64_t bytes_in_use_peak;
};

[[nodiscard]] std::vector<CsvRow>
load_csv_with_workload_used(std::filesystem::path const& csv_path);

// Gruppiert nach workload_used + plottet Bar-Chart mit Throughput pro Permutation.
// Permutationen werden nach workload_used sortiert (gruppiert dargestellt).
[[nodiscard]] int write_throughput_by_workload(
    std::filesystem::path const& out_tikz,
    std::span<CsvRow const> rows,
    PageConstraints const& cnst = {});

}  // namespace comdare::da::diagram_generator
