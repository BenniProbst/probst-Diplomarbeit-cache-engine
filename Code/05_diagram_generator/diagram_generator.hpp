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

#include <array>
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
    // TODO-4/#173 (2026-06-20): width_fraction von 0.95 → 0.78 gesenkt. Wurzel des Overfull-Bugs
    // (184 Boxen, 134 > 10pt): bei `scale only axis` gilt width= NUR fuer die Achsenflaeche; Titel,
    // Y-Label, Colorbar und rotierte Tick-Labels kommen ZUSAETZLICH dazu → Gesamtbox > \textwidth.
    // 0.78 laesst Platz fuer Colorbar + Y-Label. Zusaetzlich kapselt resizebox_wrap (s.u.) das gesamte
    // tikzpicture hart auf \textwidth (robust gegen verbleibende Zusatzbreite) — Decorator-Pattern.
    double      width_fraction    = 0.78; // * \textwidth  (war 0.95; #173-Breiten-Fix)
    double      height_fraction   = 0.40; // * \textheight
    bool        keep_aspect_ratio = true;
    std::string position_hint     = "!htbp"; // LaTeX-Float-Position
    // C1 (2026-06-01): nur den tikzpicture-Rumpf emittieren (ohne figure/centering/
    // caption-Mantel), damit das einbindende Dokument Float, Caption und Label selbst
    // steuert (z. B. spec-spezifische Anhang-Caption + referenzierbares \label).
    bool body_only = false;
    // TODO-4/#173 (2026-06-20): kapselt das gesamte \begin{tikzpicture}...\end{tikzpicture} in
    // \resizebox{\textwidth}{!}{...} (Decorator-Pattern um den Plot-Rumpf). Erzwingt die Gesamt-
    // breite hart auf \textwidth UNABHAENGIG von Colorbar/Title/Label-Zusatzbreite → 0 Overfull.
    // Default true (alle pgfplots-Figuren breiten-sicher). Auf false setzbar, falls ein Aufrufer
    // die Skalierung selbst steuert.
    bool resizebox_wrap = true;
};

// ─────────────────────────────────────────────────────────────────────────────
// Bar-Chart
// ─────────────────────────────────────────────────────────────────────────────
struct BarChartData {
    std::string              title;
    std::string              x_label;
    std::string              y_label;
    std::vector<std::string> labels; // X-Achsen-Beschriftung
    std::vector<double>      values; // Y-Werte (gleicher Index wie labels)
};

[[nodiscard]] int write_bar_chart(std::filesystem::path const& out, BarChartData const& data,
                                  PageConstraints const& cnst = {});

// ─────────────────────────────────────────────────────────────────────────────
// Scatter-Plot
// ─────────────────────────────────────────────────────────────────────────────
struct ScatterData {
    std::string         title;
    std::string         x_label;
    std::string         y_label;
    std::vector<double> xs;
    std::vector<double> ys;
};

[[nodiscard]] int write_scatter_plot(std::filesystem::path const& out, ScatterData const& data,
                                     PageConstraints const& cnst = {});

// ─────────────────────────────────────────────────────────────────────────────
// Heatmap (2D-Matrix)
// ─────────────────────────────────────────────────────────────────────────────
struct HeatmapData {
    std::string                      title;
    std::string                      x_label;
    std::string                      y_label;
    std::vector<std::string>         x_labels;
    std::vector<std::string>         y_labels;
    std::vector<std::vector<double>> matrix; // matrix[y][x]
};

[[nodiscard]] int write_heatmap(std::filesystem::path const& out, HeatmapData const& data,
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
    std::string   workload_used; // YCSB_A..F (V20.1)
    std::uint64_t op_count{};
    std::uint64_t total_cycles{};
    std::uint64_t cache_misses_l1{};
    std::uint64_t bytes_in_use_peak{};
};

[[nodiscard]] std::vector<CsvRow> load_csv_with_workload_used(std::filesystem::path const& csv_path);

// Gruppiert nach workload_used + plottet Bar-Chart mit Throughput pro Permutation.
// Permutationen werden nach workload_used sortiert (gruppiert dargestellt).
[[nodiscard]] int write_throughput_by_workload(std::filesystem::path const& out_tikz, std::span<CsvRow const> rows,
                                               PageConstraints const& cnst = {});

// ─────────────────────────────────────────────────────────────────────────────
// L-c (2026-06-18) — WIDE-Schema-Reader + Surface/Heatmap je Interface-Funktion
// ─────────────────────────────────────────────────────────────────────────────
//
// Das Mess-System (cache-engine run_lazy_150 / lazy_csv_header) emittiert das
// ';'-getrennte WIDE-Schema (154 Spalten). Der Parser ist HEADER-GETRIEBEN (Spalten
// per Name aufgelöst, Reihenfolge-/Breite-agnostisch → robust gegen additive
// Schema-Erweiterungen); 1:1 portiert aus 04_csv_to_latex/csv_to_latex.cpp:158-201.
// Extrahiert werden nur die L-c-auswertungs-relevanten Felder (ns_per_op-Gesamt +
// die 5 Interface-Funktions-p50: insert/lookup/erase/scan/rmw).

struct WideMeasurementRow {
    std::string binary_id;              // volle statische Rekombination (19 Achsen-Belegungen)
    std::string search_algo;            // aus binary_id extrahiert (führendes "search_algo=<wert>/")
    std::string workload;               // Lastprofil-id (eigene Spalte "workload")
    double      ns_per_op        = 0.0; // Gesamt-Latenz (alle Operationen gemischt)
    double      op_insert_p50_ns = 0.0; // Interface-Funktions-Latenzen (p50, nearest-rank)
    double      op_lookup_p50_ns = 0.0;
    double      op_erase_p50_ns  = 0.0;
    double      op_scan_p50_ns   = 0.0;
    double      op_rmw_p50_ns    = 0.0;
    bool        two_phase_valid  = false; // Mess-GÜLTIGKEIT (Zwei-Phasen-Cache-Warmup exakt)
    // M3v2-Tag-Spalten (Task #156, ans Schema-Ende gehängt). OPTIONAL/header-getrieben aufgelöst:
    // fehlt die Spalte (cowfix-v1-Schema), bleibt das Feld leer/0 — KEIN Parse-Fehler (n/a).
    std::string   series;                    // SOTA-Reihe (A/B/C/-); leer falls Spalte fehlt
    std::string   sweep_axis;                // gesweepte Achse (z.B. migration_policy); leer falls Spalte fehlt
    std::uint64_t working_set_n     = 0;     // Arbeitsmengen-Größe (0 = Spalte fehlt / nicht gesetzt)
    bool          has_working_set_n = false; // true ⇔ working_set_n-Spalte vorhanden und nicht-leer
    double        seg_coverage      = 0.0;   // Σseg_ns/run_total (Mess-Validität); 0 falls Spalte fehlt
    bool          has_seg_coverage  = false;
    // P4 (2026-07-12) — die 20 Stapel-Segmente der Per-Achsen-Latenz-Attribution: 19 Organ-Achsen
    // (Reihenfolge = kCompositionAxisNames: search_algo..queuing_q2) + seg_framework_ns an Index 19.
    // Kommensurabel mit seg_run_total_ns (dem eigenen Wall-Clock des 19-Segment-Laufs run_workload_segmented),
    // NICHT mit total_ns (Real-Workload → 3–29× daneben). Beleg: cache_engine_builder_iterator.hpp:205-214,327-329
    // (Σ 19 Organ + framework = seg_run_total_ns EXAKT). OPTIONAL/header-getrieben/n-a-tolerant: fehlt EINE der
    // 20 seg_*_ns-Spalten ODER ist EINE "n/a" (Nicht-Mess-DLL), bleibt has_seg_ns=false → die Zeile wird bei der
    // Attribution honest ÜBERSPRUNGEN (NICHT 0-gestapelt).
    static constexpr std::size_t      kSegmentCount = 20;
    std::array<double, kSegmentCount> seg_ns{};                  // 19 Organ-Achsen + framework (ns)
    bool                              has_seg_ns        = false; // true ⇔ alle 20 seg_*_ns vorhanden UND numerisch
    double                            seg_run_total_ns  = 0.0;   // äußere Wall-Clock des Segment-Laufs (100%-Ganzes)
    bool                              has_seg_run_total = false;
};

// HEADER-GETRIEBENER ';'-Parser (Spalten per Name → Index-Map). Pflichtspalten:
// binary_id, ns_per_op, workload, two_phase_valid + die 5 op_*_p50_ns.
// Rückgabe: status_ok | status_io_error | status_empty_input (Header/Parse-Fehler).
[[nodiscard]] int parse_wide_csv(std::filesystem::path const& in, std::vector<WideMeasurementRow>& out_rows);

// Aggregiert die (search_algo × workload)-WIDE-Matrix zu einer Heatmap/Surface des
// gewählten z-Feldes (nearest-rank-Median je Zelle, NUR two_phase_valid==true). Zeilen
// (y) = distinct search_algo (sortiert), Spalten (x) = distinct workload (sortiert).
//   z_field ∈ {"ns_per_op", "op_insert_p50_ns", "op_lookup_p50_ns", "op_erase_p50_ns",
//              "op_scan_p50_ns", "op_rmw_p50_ns"}.
// Beim scan-Surface (z_field=="op_scan_p50_ns") werden die No-Op-Scan-Profile
// "ycsb_e" und "lp_range_scan" ausgeschlossen (für Scan invalide).
// Befüllt HeatmapData und ruft das vorhandene write_heatmap (view={0}{90}, viridis).
[[nodiscard]] int write_surface_search_algo_x_workload(std::filesystem::path const&        out,
                                                       std::span<WideMeasurementRow const> rows,
                                                       std::string const& z_field, std::string const& lang = "en",
                                                       PageConstraints const& cnst = {});

// Additive echte-3D-Variante (view={45}{30}, \addplot3[surf], z LOG-skaliert wegen
// ~14000× Workload-Spanne). Gleiche Aggregation wie write_surface_search_algo_x_workload,
// nur andere pgfplots-Projektion. Bricht write_heatmap NICHT.
[[nodiscard]] int write_surface3d_search_algo_x_workload(std::filesystem::path const&        out,
                                                         std::span<WideMeasurementRow const> rows,
                                                         std::string const& z_field, std::string const& lang = "en",
                                                         PageConstraints const& cnst = {});

// ─────────────────────────────────────────────────────────────────────────────
// A2 / m3v2 (2026-06-20) — Working-Set-Sweep-Kurve (Metrik über working_set_n)
// ─────────────────────────────────────────────────────────────────────────────
// Trägt das z-Feld (nearest-rank-Median, nur two_phase_valid) über working_set_n auf, eine Kurve je
// gesweepter Achsen-Ausprägung (sweep_axis-getrieben; sonst search_algo). HEADER-GETRIEBEN/n/a-tolerant:
// fehlt die working_set_n-Spalte (cowfix-v1), liefert die Funktion status_empty_input (ehrlich leer,
// KEIN Crash). Breiten-sicher via PageConstraints (resizebox_wrap default an).
[[nodiscard]] int write_working_set_sweep_curve(std::filesystem::path const&        out,
                                                std::span<WideMeasurementRow const> rows, std::string const& z_field,
                                                std::string const& lang = "en", PageConstraints const& cnst = {});

// ─────────────────────────────────────────────────────────────────────────────
// P4 (2026-07-12) — Per-Achsen-Latenz-Attribution als GESTAPELTE Balken
// ─────────────────────────────────────────────────────────────────────────────
//
// Der bisher unvisualisierte Kern-Beitrag: WELCHE der 19 Organ-Achsen (+ Framework-Overhead) wie viel
// Latenz beiträgt. Ein Balken je search_algo; das 100%-Ganze je Balken ist seg_run_total_ns (der eigene
// Wall-Clock des 19-Segment-Laufs), NICHT total_ns (Real-Workload → inkommensurabel). Aggregation: Mittel
// je Segment über die GÜLTIGEN Segment-Zeilen (two_phase_valid ∧ has_seg_ns ∧ seg_run_total_ns>0 ∧
// seg_coverage vorhanden). Σ der 20 Segment-Mittel == Mittel seg_run_total_ns (Coverage≈1 → kommensurabel).

// Numerisch prüfbares Aggregat (deterministisch nach search_algo sortiert). means[segment][group] = Mittel ns;
// Σ_segment means[s][g] == group_totals[g] == run_total_means[g]. groups leer ⇔ keine gültige Segment-Zeile.
struct SegmentAttribution {
    std::vector<std::string>         groups;          // search_algo, aufsteigend sortiert (Balken-x)
    std::vector<std::string>         segment_labels;  // 20 Segment-Namen (Legende, Stapel-Reihenfolge)
    std::vector<std::vector<double>> means;           // means[segment][group] = Mittel des Segments (ns)
    std::vector<double>              group_totals;    // Σ_segment means je Gruppe (== Mittel seg_run_total_ns)
    std::vector<double>              run_total_means; // Mittel seg_run_total_ns je Gruppe (Kommensurabilitäts-Beleg)
    std::vector<double>              coverage_means;  // Mittel seg_coverage je Gruppe (~1.0)
};

// Aggregiert die (search_algo)-Gruppen zu Segment-Mitteln. Header-getrieben/n-a-tolerant: Zeilen ohne
// vollständige seg-Belegung / mit seg_run_total_ns<=0 / mit fehlender seg_coverage werden HONEST übersprungen
// (NICHT 0-gestapelt). Rückgabe mit leerem `groups`, wenn KEINE gültige Segment-Zeile existiert.
[[nodiscard]] SegmentAttribution aggregate_segment_attribution(std::span<WideMeasurementRow const> rows);

// Emittiert den pgfplots `ybar stacked` (ein Balken je search_algo, 20 `\addplot`-Segmente, Legende =
// Achsennamen, lineare y-Achse in ns, deterministische HSV-Kategorienfarben). Guard: keine gültige
// Segment-Zeile → status_empty_input (ehrlich leer, KEIN leerer Balken). Breiten-sicher (resizebox_wrap).
[[nodiscard]] int write_segment_attribution_stacked_bar(std::filesystem::path const&        out,
                                                        std::span<WideMeasurementRow const> rows,
                                                        std::string const&                  lang = "en",
                                                        PageConstraints const&              cnst = {});

} // namespace comdare::da::diagram_generator
