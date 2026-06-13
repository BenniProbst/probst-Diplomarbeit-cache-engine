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
    // C1 (2026-06-01): nur den tikzpicture-Rumpf emittieren (ohne figure/centering/
    // caption-Mantel), damit das einbindende Dokument Float, Caption und Label selbst
    // steuert (z. B. spec-spezifische Anhang-Caption + referenzierbares \label).
    bool   body_only           = false;
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
// L2 (2026-06-13) — 3D-pgfplots-Surface je Interface-Funktion (wide3d-Modus)
// ─────────────────────────────────────────────────────────────────────────────
//
// Aufgabe L2: aus dem L1-Aggregat (Stufe 04, csv_to_latex::aggregate_tier_workload_per_op)
// je Interface-Funktion (insert/lookup/erase/clear/scan/rmw) GENAU EIN standalone
// `\addplot3`-Surface (surf) erzeugen. Achsen-Belegung:
//   x = Testdaten-Konfig  = Workload-Index  (stabile, lexikografisch sortierte workload-id-Ordnung;
//                           workload→x als Achsenbeschriftung/Kommentar dokumentiert)
//   y = Tier-Index        = Index über binary_ids (stabil sortiert nach Achsen-Lexikografie des 19-Tupels)
//   z = median_p50_ns_per_op[op]  (Verarbeitungsdauer je Testdatensatz-Operation, aus L1)
//
// Patterns (Lehrbuch, benannt):
//   • Builder           — Surface3dModelBuilder baut das Surface-Gitter (workload→x, tier→y, z-Matrix)
//                         deterministisch aus den L1-Aggregaten auf (Trennung Konstruktion ↔ Repräsentation).
//   • Strategy/Template  — write_op_surface emittiert je nach PageConstraints.body_only die standalone-
//                         oder die einbettbare (axis-only) Variante über EINEN gemeinsamen Emissions-Pfad.
//   • Single-Source      — Op-Reihenfolge stammt AUSSCHLIESSLICH aus csv_to_latex::kOpKindNames (kein Re-Def).
//
// Ehrlichkeit: fehlende/0-Zellen (Op nicht ausgeführt) werden als `nan` emittiert (echte Lücke), NIE als 0.
// Scan-Profile (ycsb_e, lp_range_scan) sind bis A1a/M3 invalide → standardmäßig aus den Surfaces
// AUSGESCHLOSSEN (als Limitierung kommentiert). Alle Pfade RELATIV (CLI-Args), keine absoluten Pfade.

// Eine Surface-Zelle des Gitters (x=workload-idx, y=tier-idx, z=Median-p50-ns; has_value=false → nan-Lücke).
struct Surface3dCell {
    std::size_t x_workload_index = 0;
    std::size_t y_tier_index     = 0;
    double      z_median_p50_ns  = 0.0;
    bool        has_value        = false;   // false → ehrliche Lücke (nan), NICHT 0
};

// Modell EINER Op-Art-Surface: vollständiges, lückenfüllendes (x,y)-Gitter + stabile Achsen-Legenden.
struct Surface3dModel {
    std::string                op_name;        // Interface-Funktion (= kOpKindNames[op_index])
    std::size_t                op_index = 0;   // Index in kOpKindNames (Single-Source)
    std::vector<std::string>   workload_ids;   // x-Legende: stabil lexikografisch sortiert (Index = x)
    std::vector<std::string>   tier_ids;       // y-Legende: stabil nach 19-Tupel-Lexikografie (Index = y)
    std::vector<Surface3dCell> cells;          // dichtes Gitter, Zeilen-major (y außen, x innen)
    std::size_t                real_cell_count = 0;  // Zahl echter (nicht-nan) z-Zellen
};

// Builder (Lehrbuch-Pattern): baut die 6 Op-Art-Modelle deterministisch aus den L1-Aggregaten auf.
// `excluded_workloads` = aus den Surfaces auszuschließende Lastprofile (Default: ycsb_e + lp_range_scan).
class Surface3dModelBuilder {
public:
    // Span auf L1-Aggregate (csv_to_latex::TierWorkloadOpAggregate); ungültige/leere Aggregate → leeres Modell.
    template <class AggregateSpan>
    [[nodiscard]] std::array<Surface3dModel, 6>
    build(AggregateSpan const& aggregates,
          std::span<std::string const> excluded_workloads) const;
};

// Default-Ausschlussliste der Scan-Profile (bis A1a/M3 invalide) — als freie Funktion für CLI + Tests.
[[nodiscard]] std::vector<std::string> default_excluded_scan_workloads();

// Emittiert EINE Op-Art-Surface als .tex. body_only steuert standalone vs. einbettbar (axis-only, L4-Anhang):
//   • cnst.body_only == false → \documentclass{standalone} + pgfplots-Präambel + tikzpicture + axis.
//   • cnst.body_only == true  → nur \begin{axis}…\end{axis} (ohne Präambel/tikzpicture) für L4-Appendix.
[[nodiscard]] int write_op_surface(std::filesystem::path const& out,
                                   Surface3dModel const& model,
                                   PageConstraints const& cnst = {});

// Orchestriert den gesamten wide3d-Modus: parst (über L1) → baut Modelle → schreibt je Op-Art
// EINE standalone-.tex UND EINE body-only-.tex in `out_dir` (relative Dateinamen). Liefert die
// erzeugten Modelle in `out_models` (für Verifikation/Reporting: Surface-Zahl, echte z-Zellen je Surface).
[[nodiscard]] int generate_wide3d_surfaces(std::filesystem::path const& csv_path,
                                           std::filesystem::path const& out_dir,
                                           std::vector<Surface3dModel>& out_models,
                                           std::span<std::string const> excluded_workloads = {});

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
