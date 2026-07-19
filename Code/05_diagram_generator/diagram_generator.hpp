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

#include "csv_to_latex.hpp" // INC-4: c2l::WideFullRow (trägt den durchgereichten stat_<achse>_<feld>-Block)

// M-4/B16 (2026-07-19): CE-Single-Source der Achsen-Zaehlung und -Namen (17 Organ-Achsen, ABI-6/INC-2d).
// KEINE eigenen Zaehl-Literale mehr: das fruehere kSegmentCount=20 (19 Organ + framework, inkl. der nach
// INC-2c/INC-2d ausgezogenen seg_telemetry_ns/seg_isa_ns) liess has_seg_ns gegen die 17-Achsen-WIDE-CSV
// dauerhaft false werden -> seg_attribution.tex wurde NIE erzeugt.
#include "anatomy/observable_tier.hpp"                         // kV3AxisCount = 17 (die EINE Zaehl-Quelle)
#include "builder/experiment_tree/axis_path_serialization.hpp" // kCompositionAxisNames (Namen + Reihenfolge)

#include <array>
#include <cstddef>
#include <cstdint>
#include <filesystem>
#include <span>
#include <string>
#include <string_view>
#include <utility>
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
// (run_lazy_150 geloescht 2026-07-11; Emitter heute Code/02_messung_driver, WIDE-Schema)
// ';'-getrennte WIDE-Schema (Spaltenzahl header-getrieben, nicht fixiert). Der Parser ist
// HEADER-GETRIEBEN (Spalten per Name aufgelöst, Reihenfolge-/Breite-agnostisch → robust gegen
// additive Schema-Erweiterungen); 1:1 portiert aus 04_csv_to_latex/csv_to_latex.cpp:158-201.
// Extrahiert werden nur die L-c-auswertungs-relevanten Felder (ns_per_op-Gesamt +
// die 5 Interface-Funktions-p50: insert/lookup/erase/scan/rmw).

struct WideMeasurementRow {
    std::string binary_id;              // volle statische Rekombination (17 Achsen-Belegungen)
    std::string search_algo;            // aus binary_id extrahiert (führendes "search_algo=<wert>/")
    std::string workload;               // Lastprofil-id (eigene Spalte "workload")
    double      ns_per_op        = 0.0; // Gesamt-Latenz (alle Operationen gemischt)
    double      op_insert_p50_ns = 0.0; // Interface-Funktions-Latenzen (p50, nearest-rank)
    double      op_lookup_p50_ns = 0.0;
    double      op_erase_p50_ns  = 0.0;
    double      op_scan_p50_ns   = 0.0;
    double      op_rmw_p50_ns    = 0.0;
    // P3 (2026-07-12) — die 5 Interface-Funktions-p99 (spiegeln EXAKT die 5 op_*_p50_ns; nearest-rank, ns).
    // OPTIONAL/header-getrieben aufgelöst (NICHT Pflichtspalte): fehlt EINE der 5 op_*_p99_ns-Spalten ODER ist
    // EINE Zelle leer/"n/a"/nicht-numerisch, bleibt has_op_p99=false (cowfix-v1 ohne p99 bricht NICHT). Das
    // WIDE-Schema trägt NUR diese Aggregat-Perzentile (p50/p99), NICHT die rohen Einzel-Op-Latenzen → die
    // Latenz-Verteilung ist ehrlich nur als p50–p99-Spanne (Range) bzw. Config-Streuung (ECDF) darstellbar.
    double op_insert_p99_ns = 0.0;
    double op_lookup_p99_ns = 0.0;
    double op_erase_p99_ns  = 0.0;
    double op_scan_p99_ns   = 0.0;
    double op_rmw_p99_ns    = 0.0;
    bool   has_op_p99       = false; // true ⇔ alle 5 op_*_p99_ns-Spalten vorhanden UND numerisch
    bool   two_phase_valid  = false; // Mess-GÜLTIGKEIT (Zwei-Phasen-Cache-Warmup exakt)
    // M3v2-Tag-Spalten (Task #156, ans Schema-Ende gehängt). OPTIONAL/header-getrieben aufgelöst:
    // fehlt die Spalte (cowfix-v1-Schema), bleibt das Feld leer/0 — KEIN Parse-Fehler (n/a).
    std::string   series;                    // SOTA-Reihe (A/B/C/-); leer falls Spalte fehlt
    std::string   sweep_axis;                // gesweepte Achse (z.B. migration_policy); leer falls Spalte fehlt
    std::uint64_t working_set_n     = 0;     // Arbeitsmengen-Größe (0 = Spalte fehlt / nicht gesetzt)
    bool          has_working_set_n = false; // true ⇔ working_set_n-Spalte vorhanden und nicht-leer
    double        seg_coverage      = 0.0;   // Σseg_ns/run_total (Mess-Validität); 0 falls Spalte fehlt
    bool          has_seg_coverage  = false;
    // P4 (2026-07-12) — die Stapel-Segmente der Per-Achsen-Latenz-Attribution: die kV3AxisCount (=17,
    // ABI-6/INC-2d) Organ-Achsen (Reihenfolge = kCompositionAxisNames: search_algo..queuing_q2) +
    // seg_framework_ns als LETZTES Segment (Index kSegmentCount-1). Kommensurabel mit seg_run_total_ns
    // (dem eigenen Wall-Clock des Segment-Laufs run_workload_segmented), NICHT mit total_ns (Real-Workload
    // → 3–29× daneben). Beleg: cache_engine_builder_iterator.hpp:248-257,395-401 (Σ Organ-Segmente +
    // framework = seg_run_total_ns EXAKT). OPTIONAL/header-getrieben/n-a-tolerant: fehlt EINE der
    // seg_*_ns-Spalten ODER ist EINE "n/a" (Nicht-Mess-DLL), bleibt has_seg_ns=false → die Zeile wird bei
    // der Attribution honest ÜBERSPRUNGEN (NICHT 0-gestapelt).
    // M-4/B16 (2026-07-19): Zaehlung aus der CE-Single-Source kV3AxisCount statt Literal — das fruehere
    // hartkodierte 20 (inkl. seg_telemetry_ns/seg_isa_ns) passte nicht mehr zur 17-Achsen-WIDE-CSV.
    static constexpr std::size_t      kSegmentCount = ::comdare::cache_engine::anatomy::kV3AxisCount + 1;
    std::array<double, kSegmentCount> seg_ns{};                  // 17 Organ-Achsen + framework (ns)
    bool                              has_seg_ns        = false; // true ⇔ alle seg_*_ns vorhanden UND numerisch
    double                            seg_run_total_ns  = 0.0;   // äußere Wall-Clock des Segment-Laufs (100%-Ganzes)
    bool                              has_seg_run_total = false;
};

// ─────────────────────────────────────────────────────────────────────────────
// M-4 (2026-07-19) — Segment-Spaltennamen aus der CE-Single-Source abgeleitet
// ─────────────────────────────────────────────────────────────────────────────
//
// "seg_<achse>_ns" wird zur UEBERSETZUNGSZEIT aus kCompositionAxisNames gepraegt (constexpr-Join per
// IIFE + index_sequence — Template-Metaprogramm ohne Laufzeit-Anteil, compile-time-Doktrin). Es gibt
// KEINE zweite Namensliste mehr: Schreiber (CE lazy_csv_header, Schleife ueber kCompositionAxisNames,
// cache_engine_builder_iterator.hpp:248-257) und Leser (parse_wide_csv) ziehen aus derselben Quelle.

namespace segment_columns_detail {

// Compile-time-Speicher fuer EINEN gejointen Spaltennamen "seg_" + kCompositionAxisNames[I] + "_ns".
template <std::size_t I>
struct SegColumnName {
    static constexpr std::string_view kAxis   = ::comdare::cache_engine::builder::experiment::kCompositionAxisNames[I];
    static constexpr auto             kJoined = [] {
        constexpr std::string_view                                     prefix = "seg_";
        constexpr std::string_view                                     suffix = "_ns";
        std::array<char, prefix.size() + kAxis.size() + suffix.size()> b{};
        std::size_t                                                    p = 0;
        for (char c : prefix) b[p++] = c;
        for (char c : kAxis) b[p++] = c;
        for (char c : suffix) b[p++] = c;
        return b;
    }();
    static constexpr std::string_view value{kJoined.data(), kJoined.size()};
};

} // namespace segment_columns_detail

// Entkopplungs-Wache: beide CE-Quellen (POD-Zaehlung + Namensliste) muessen dieselbe Achsen-Zahl tragen —
// zieht CE eine Achse um (wie INC-2c telemetry / INC-2d isa), bricht der Bau hier LAUT statt still leer.
static_assert(::comdare::cache_engine::builder::experiment::kCompositionAxisNames.size() ==
                  ::comdare::cache_engine::anatomy::kV3AxisCount,
              "CE-Drift: kCompositionAxisNames vs kV3AxisCount — Segment-Schema der Stufe 05 neu abgleichen");

/// Die kSegmentCount Stapel-Segment-Spaltennamen in EXAKTER Header-/Stapel-Reihenfolge: die kV3AxisCount
/// Organ-Achsen (Single-Source kCompositionAxisNames) + "seg_framework_ns" als letztes Segment.
inline constexpr std::array<std::string_view, WideMeasurementRow::kSegmentCount> kSegmentColumns =
    []<std::size_t... I>(std::index_sequence<I...>) {
        return std::array<std::string_view, sizeof...(I) + 1>{segment_columns_detail::SegColumnName<I>::value...,
                                                              std::string_view{"seg_framework_ns"}};
    }(std::make_index_sequence<::comdare::cache_engine::anatomy::kV3AxisCount>{});

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
// Der bisher unvisualisierte Kern-Beitrag: WELCHE der 17 Organ-Achsen (+ Framework-Overhead) wie viel
// Latenz beiträgt. Ein Balken je search_algo; das 100%-Ganze je Balken ist seg_run_total_ns (der eigene
// Wall-Clock des Segment-Laufs), NICHT total_ns (Real-Workload → inkommensurabel). Aggregation: Mittel
// je Segment über die GÜLTIGEN Segment-Zeilen (two_phase_valid ∧ has_seg_ns ∧ seg_run_total_ns>0 ∧
// seg_coverage vorhanden). Σ der kSegmentCount Segment-Mittel == Mittel seg_run_total_ns (Coverage≈1 →
// kommensurabel).

// Numerisch prüfbares Aggregat (deterministisch nach search_algo sortiert). means[segment][group] = Mittel ns;
// Σ_segment means[s][g] == group_totals[g] == run_total_means[g]. groups leer ⇔ keine gültige Segment-Zeile.
struct SegmentAttribution {
    std::vector<std::string>         groups;          // search_algo, aufsteigend sortiert (Balken-x)
    std::vector<std::string>         segment_labels;  // kSegmentCount Segment-Namen (Legende, Stapel-Reihenfolge)
    std::vector<std::vector<double>> means;           // means[segment][group] = Mittel des Segments (ns)
    std::vector<double>              group_totals;    // Σ_segment means je Gruppe (== Mittel seg_run_total_ns)
    std::vector<double>              run_total_means; // Mittel seg_run_total_ns je Gruppe (Kommensurabilitäts-Beleg)
    std::vector<double>              coverage_means;  // Mittel seg_coverage je Gruppe (~1.0)
};

// Aggregiert die (search_algo)-Gruppen zu Segment-Mitteln. Header-getrieben/n-a-tolerant: Zeilen ohne
// vollständige seg-Belegung / mit seg_run_total_ns<=0 / mit fehlender seg_coverage werden HONEST übersprungen
// (NICHT 0-gestapelt). Rückgabe mit leerem `groups`, wenn KEINE gültige Segment-Zeile existiert.
[[nodiscard]] SegmentAttribution aggregate_segment_attribution(std::span<WideMeasurementRow const> rows);

// Emittiert den pgfplots `ybar stacked` (ein Balken je search_algo, kSegmentCount `\addplot`-Segmente,
// Legende = Achsennamen, lineare y-Achse in ns, deterministische HSV-Kategorienfarben). Guard: keine gültige
// Segment-Zeile → status_empty_input (ehrlich leer, KEIN leerer Balken). Breiten-sicher (resizebox_wrap).
[[nodiscard]] int write_segment_attribution_stacked_bar(std::filesystem::path const&        out,
                                                        std::span<WideMeasurementRow const> rows,
                                                        std::string const&                  lang = "en",
                                                        PageConstraints const&              cnst = {});

// ─────────────────────────────────────────────────────────────────────────────
// P3 (2026-07-12) — Latenz-VERTEILUNG statt Mittelwert
// ─────────────────────────────────────────────────────────────────────────────
//
// EHRLICHKEITS-GRUNDLAGE (zwingend): das WIDE-Schema trägt je Permutation NUR aggregierte Perzentile
// (op_<art>_p50_ns / op_<art>_p99_ns), NICHT die rohen Einzel-Op-Latenzen. Daher gibt es exakt ZWEI ehrliche
// Verteilungs-Darstellungen:
//   (1) Range: Punkt=p50, Whisker→p99 je (search_algo × op-Art). NUR 2 Perzentile existieren → KEIN Box-Plot
//       mit erfundenen Quartilen (das wäre Phantom).
//   (2) ECDF: die einzige ehrliche CDF-Population ist die Verteilung ÜBER die Konfigurationen (jede gültige
//       Permutation = 1 Datenpunkt ihres ns_per_op). Das ist eine "Config-Streuung"-ECDF (Anteil der Configs
//       mit Latenz ≤ x), NICHT eine Per-Operation-Latenz-CDF. Titel/xlabel weisen das EXPLIZIT aus.

// Range-Aggregat: je op-Art (Zeilen) × search_algo (Spalten) der nearest-rank-Median der p50- bzw. p99-Werte
// über die GÜLTIGEN Zeilen (two_phase_valid ∧ has_op_p99 ∧ op ausgeführt (p50>0)). scan schließt die No-Op-
// Scan-Profile "ycsb_e"/"lp_range_scan" aus (wie der Surface-Pfad). present[op][algo] ⇔ ≥1 Stichprobe.
// Für wohlgeformte Daten gilt p99_median[op][algo] ≥ p50_median[op][algo] (Monotonie); p99<p50 = Datenqualität.
struct LatencyRangeAggregate {
    std::vector<std::string>         algos;        // search_algo, aufsteigend sortiert (x-Achse)
    std::vector<std::string>         ops;          // op-Arten MIT Daten, feste Reihenfolge insert..rmw (Legende)
    std::vector<std::vector<double>> p50_median;   // [op][algo] = nearest-rank-Median der p50-Werte (Punkt, ns)
    std::vector<std::vector<double>> p99_median;   // [op][algo] = nearest-rank-Median der p99-Werte (Whisker-Top, ns)
    std::vector<std::vector<std::size_t>> counts;  // [op][algo] = Stichprobenzahl je Zelle
    std::vector<std::vector<bool>>        present; // [op][algo] = Zelle hat ≥1 gültige Stichprobe
};

// Aggregiert die (op-Art × search_algo)-Latenz-Spanne. Header-getrieben/n-a-tolerant. Rückgabe mit leerem
// `algos`, wenn KEINE gültige Zeile existiert (keine p99 / keine ausgeführte Op).
[[nodiscard]] LatencyRangeAggregate aggregate_latency_range(std::span<WideMeasurementRow const> rows);

// Emittiert einen pgfplots-Punkt-und-Whisker-Plot (only marks + `error bars/y dir=plus, y explicit`): je Gruppe
// (search_algo × op-Art) ein Punkt bei p50, plus-Whisker hoch bis p99. y LOG (Latenz spannt Dekaden). 1 addplot
// je op-Art (Farbe+Legende). Guard: keine gültige Zeile → status_empty_input (ehrlich leer). KEIN Box/Quartil.
// Breiten-sicher (resizebox_wrap). Titel/ylabel beschriften ehrlich "p50–p99-Spanne".
[[nodiscard]] int write_latency_range_bar(std::filesystem::path const& out, std::span<WideMeasurementRow const> rows,
                                          std::string const& lang = "en", PageConstraints const& cnst = {});

// ECDF-Serie je search_algo: die aufsteigend sortierten ns_per_op-Werte der GÜLTIGEN Konfigurationen
// (two_phase_valid). Population = Anzahl Konfigurationen (Permutationen), NICHT Einzel-Operationen.
struct LatencyEcdfSeries {
    std::string         algo;
    std::vector<double> sorted_ns_per_op; // aufsteigend, ein Wert je gültiger Konfiguration
};

// Baut je search_algo eine ECDF-Serie über die ns_per_op-Werte der gültigen Konfigurationen. Leer ⇔ keine
// gültige Zeile.
[[nodiscard]] std::vector<LatencyEcdfSeries> aggregate_latency_ecdf(std::span<WideMeasurementRow const> rows);

// Emittiert die ECDF (`const plot`-Treppe) der ns_per_op-Werte ÜBER die Konfigurationen, 1 Kurve je search_algo,
// y = Rang/N ∈ [0,1], x = ns (LOG wegen der Dekaden). Titel/xlabel weisen EXPLIZIT "Verteilung über
// Konfigurationen" (Config-Streuung) aus — NICHT Per-Operation. Guard: keine gültige Zeile → status_empty_input.
[[nodiscard]] int write_latency_ecdf(std::filesystem::path const& out, std::span<WideMeasurementRow const> rows,
                                     std::string const& lang = "en", PageConstraints const& cnst = {});

// ─────────────────────────────────────────────────────────────────────────────
// INC-4 (2026-07-13) — Modus-2 Per-Achsen-Observer-Detail-Tabelle (stat_<achse>_<feld>)
// ─────────────────────────────────────────────────────────────────────────────
//
// Schreibt den vollen Per-Achsen-Observer-Block als longtable: je (Tier-Binary × Achse × Observer-Feld) EINE
// Zeile mit dem ECHT gemessenen uint64-Zählwert. Die Spaltennamen stat_<achse>_<feld> werden HEADER-GETRIEBEN
// aus der WIDE-CSV gelesen (c2l::WideFullRow::stat, parse_wide_csv_full) — NIE hartkodiert: die DLL-seitige
// kV3AxisSchema[17][8] ist die Single-Source und emittiert die Spaltennamen. Achse/Feld werden aus dem
// Spaltennamen mit dem Achsen-Vokabular des binary_id-Tupels (r.axes-Keys = dieselben kCompositionAxisNames-
// Namen, exakt die stat_<achse>_-Präfixe) per LÄNGSTEM-Präfix zerlegt — nötig, weil BEIDE (Achsen- und
// Feldnamen) Unterstriche tragen (naives Splitten wäre falsch).
//
// HONEST-EMPTY (exakt das write_segment_attribution_stacked_bar-Muster): existiert KEINE Zeile mit mindestens
// EINEM echt gemessenen stat_-Wert (alle Spalten "n/a"/leer ODER der stat_-Block fehlt) → status_empty_input
// VOR dem ofstream (KEINE Datei, KEIN erfundener 0-Wert). Innerhalb einer Zeile werden n/a-/leere Felder
// übersprungen (nie 0-erfunden). Breiten-sicher via longtable + \scriptsize (mehrseiten-fähig; KEIN resizebox,
// da longtable nicht in eine \resizebox darf).
[[nodiscard]] int write_axis_observer_detail_table(std::filesystem::path const&                            out,
                                                   std::span<comdare::da::csv_to_latex::WideFullRow const> rows,
                                                   std::string const&                                      lang = "en");

} // namespace comdare::da::diagram_generator
