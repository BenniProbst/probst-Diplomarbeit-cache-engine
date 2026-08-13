#pragma once
// diagram_generator — Diplomarbeit/Code Module
// C++ Bildgenerator: erzeugt TikZ-Code (kein Python, F-EXTRA-5 konform).
//
// REV 7.6 Q3: User-Entscheidung "TikZ-Code generieren" — kein Python,
// A4-Awareness durch direkten LaTeX-Output, Diagramme kommen automatisch
// im LaTeX-Layout mit korrekter Seitenpositionierung.
//
// REV 7.7 (2026-08-13): Groessen-Wache 1x1/1xN/Nx1 -> HONEST-EMPTY (pgfplots matrix input=image
// verlangt >=2x2; Fehlerklasse der E-2a-Landung 05./06.08., Kern-Commits ba5e48eb/838612f3, deckte
// nur Datenlosigkeit, nicht die Matrix-GROESSE). Beleg F1-Smoke Job 376333: 1 Algo x 1 Workload,
// ns_per_op=1199.047 GEMESSEN -> matrix plot* mit genau einer Koordinate war kompilier-fatal.
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

// M-4/B16 (2026-07-19): CE-Single-Source der Achsen-Zaehlung und -Namen (Organ-Achsen, ABI-6/INC-2d;
// die Zahl traegt kV3AxisCount -- KEIN Zaehl-Literal, A-B2/ORG-18).
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
    std::string              title;
    std::string              x_label;
    std::string              y_label;
    std::vector<std::string> x_labels;
    std::vector<std::string> y_labels;
    // matrix[y][x]. NaN (quiet_NaN) = Zelle OHNE Messwert ("nicht ausgefuehrt"), ausdruecklich NICHT 0.0
    // -- write_heatmap laesst solche Zellen ueber point meta = nan aus und schreibt als dritte Koordinate
    // nur den blanken Mesh-Traeger 0 (kein "0.0000"), damit die .tex keine 0-ns-Messung behauptet.
    // Details + die drei pgfplots-Proben, die diese Auslass-Strategie erzwingen: siehe write_heatmap.
    std::vector<std::vector<double>> matrix;
    // E-2b/AUSGEFUEHRT-MASKE (2026-08-06) -- executed[y][x] parallel zu matrix[y][x]. Sie traegt die
    // AUSFUEHRUNGS-Klassifikation (z_field_executed: Zaehler op_<art>_n zuerst, sonst p50>0-Heuristik) bis
    // in den Writer. Ohne sie musste write_heatmap "gemessen" aus dem Wert selbst raten (v>0) -- und eine
    // ECHT GEMESSENE 0 (op_<art>_n>0 bei p50==0) fiel faelschlich unter "nicht ausgefuehrt".
    //   executed[y][x] == true  -> die Zelle traegt einen ECHTEN Messwert. Auch die 0 ist dann ein
    //                              DARSTELLBARER Wert (Zelle mit Wert 0 und ehrlichem point meta, NICHT nan,
    //                              NICHT Auslass, NICHT Platzhalter-Grund).
    //   executed[y][x] == false -> nicht ausgefuehrt/keine Stichprobe -> Auslass ueber point meta = nan.
    // LEER (oder dimensions-abweichend) -> BESTANDSVERHALTEN: der Writer faellt auf die alte Heuristik
    // "endlich und > 0" zurueck. Direkt-Aufrufer ohne Ausfuehrungs-Wissen (Alt-Tests, Fremdmodule) bleiben
    // damit unveraendert; nur wer die Wahrheit KENNT (aggregate_surface_matrix), reicht sie hier durch.
    std::vector<std::vector<bool>> executed;
    // E-2a/HONEST-EMPTY (2026-08-06): Vermerk-Text, den write_heatmap ANSTELLE einer datenlosen Heatmap
    // emittiert (reiner Text, wird escape_latex-durchgereicht). Leer -> neutraler ASCII-Default. Der
    // Aufrufer (write_surface_search_algo_x_workload) fuellt ihn sprach-lokalisiert.
    std::string empty_note;
    // REV 7.7/F1 (2026-08-13): Vermerk-Text fuer eine GEMESSENE Matrix unter dem pgfplots-Minimum --
    // matrix input=image verlangt >= 2 Zeilen UND >= 2 Spalten, 1x1/1xN/Nx1 ist kompilier-fatal
    // (Proben 13.08.2026, texlive 2026, compat=1.18: 1x1 rc=1, 1x2 rc=1, 2x2 rc=0). Der Text darf
    // NICHT "nie ausgefuehrt" behaupten: die Zelle(n) SIND gemessen, nur die Flaeche ist nicht
    // darstellbar. Leer -> neutraler ASCII-Default (default_degenerate_size_note). Reiner Text,
    // wird escape_latex-durchgereicht; die Aufrufer fuellen ihn sprach-lokalisiert.
    std::string degenerate_size_note;
    // P2/DIVERGENTE FARBSKALA (2026-08-06) -- additiv, Default false = exakt das Bestandsverhalten
    // (log10-viridis). Die Matrix traegt dann keine Latenzen in ns, sondern VERHAELTNISSE zu einer
    // Referenz; deren aussagekraeftiger Punkt ist nicht das Minimum, sondern die Gleichheit
    // (divergent_center, Default 1.0 = "so schnell wie die Referenz"). Eine sequentielle Skala kann das
    // nicht zeigen: sie faerbt "20% schneller" und "20% langsamer" verschieden weit vom Rand, aber nie
    // erkennbar als die zwei Seiten derselben Mitte.
    //   divergent == true  -> point meta = log10(z / divergent_center), Farb-Domaene SYMMETRISCH um 0,
    //                         3-Stuetzstellen-Colormap blau/weiss/rot (weiss sitzt damit exakt auf der
    //                         Mitte, also auf der Gleichheit). KEIN externes Paket noetig.
    //                         WARUM logarithmisch und nicht z-center: ein Verhaeltnis ist MULTIPLIKATIV --
    //                         "doppelt so schnell" (0.5) und "doppelt so langsam" (2.0) muessen gleich
    //                         weit von der Mitte liegen. Linear waeren sie es nicht (Abstand 0.5 gegen
    //                         1.0), die schnellere Haelfte wuerde also systematisch zusammengedrueckt.
    //                         Beleg am d03-Korpus: Verhaeltnisse 0.44..9.22 -> auf einer linearen, um 1
    //                         zentrierten Domaene [-7.2:9.2] laegen ALLE Zellen unter 1 zwischen 46.6%
    //                         und 50% der Skala, ein 2.3-fach schnellerer Algorithmus waere von "gleich
    //                         schnell" farblich nicht zu unterscheiden.
    //                         Ein Verhaeltnis 0 (Zaehler echt 0 gemessen) hat keinen Logarithmus und
    //                         bekommt -- wortgleich zum log-Modus -- eine eigene Klasse eine Dekade
    //                         unterhalb; die Domaene waechst dafuer SYMMETRISCH, damit die Mitte die
    //                         Mitte bleibt.
    //   divergent == false -> Bestand: point meta = log10(z), viridis, eigene 0-Farbklasse.
    // Die drei Zell-Klassen (Wert > 0 / echte 0 / nicht ausgefuehrt) bleiben in BEIDEN Modi unveraendert;
    // nur die Meta-Berechnung und die Colorbar-Beschriftung wechseln.
    bool   divergent        = false;
    double divergent_center = 1.0;
};

// Emittiert die 2D-Heatmap (matrix plot*, view={0}{90}, viridis, log-Farbskala).
// HONEST-EMPTY (E-2a): traegt KEINE Zelle einen darstellbaren Messwert, wird KEINE entartete Heatmap
// geschrieben (pgfplots-Fatal "too few coordinates" bei [0.0:0.0]-Farbdomaene), sondern ein ehrlicher,
// kompilierfaehiger LaTeX-Platzhalter-Vermerk -- Rueckgabe status_ok, weil die Datei existieren MUSS
// (die 6 lc_surface_<z>.tex haengen an blankem \input, kein \InputIfFileExists).
// E-2b: "darstellbar" richtet sich nach HeatmapData::executed (falls gesetzt), NICHT nach dem Vorzeichen:
// eine ausgefuehrte 0 wird DARGESTELLT (eigene 0-Farbklasse eine Dekade unter der kleinsten gemessenen
// Dekade; besteht die Flaeche NUR aus echten Nullen, traegt die Colorbar genau diese eine 0-Klasse).
// Strukturell leere Matrix (0 Zeilen/Spalten) bleibt status_empty_input OHNE Datei (Bestandsverhalten).
// REV 7.7: eine GEMESSENE Matrix unter dem 2x2-Minimum von matrix input=image (1x1/1xN/Nx1) bekommt
// den GROESSEN-Platzhalter (degenerate_size_note), ebenfalls status_ok -- die Datei muss existieren.
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
    // E-2a/HONEST-EMPTY (2026-08-06) -- die 5 AUSFUEHRUNGS-ZAEHLER op_<art>_n (Stueckzahl der in diesem Lauf
    // tatsaechlich ausgefuehrten Operationen dieser Art). Sie sind das EINZIGE direkte Signal fuer
    // "Operation nicht ausgefuehrt" (op_<art>_n == 0) und trennen es von "echt 0 ns gemessen"; ohne sie
    // muss die Auswertung auf die p50>0-Heuristik zurueckfallen (Phantom-Falle, siehe
    // aggregate_latency_range im .cpp). Beleg fuer die Spalten-Existenz im realen WIDE-Schema:
    // measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv (Spalten 7/10/13/19/22).
    // OPTIONAL/header-getrieben (NICHT Pflichtspalte, NICHT in required[]): fehlt EINE der 5 Spalten ODER
    // ist EINE Zelle leer/"n/a"/nicht-numerisch, bleibt has_op_n=false -> BESTANDSVERHALTEN (p50>0-Heuristik).
    std::uint64_t op_insert_n     = 0;
    std::uint64_t op_lookup_n     = 0;
    std::uint64_t op_erase_n      = 0;
    std::uint64_t op_scan_n       = 0;
    std::uint64_t op_rmw_n        = 0;
    bool          has_op_n        = false; // true <=> alle 5 op_<art>_n-Spalten vorhanden UND numerisch
    bool          two_phase_valid = false; // Mess-GUELTIGKEIT (Zwei-Phasen-Cache-Warmup exakt)
    // M3v2-Tag-Spalten (Task #156, ans Schema-Ende gehängt). OPTIONAL/header-getrieben aufgelöst:
    // fehlt die Spalte (cowfix-v1-Schema), bleibt das Feld leer/0 — KEIN Parse-Fehler (n/a).
    std::string   series;                    // SOTA-Reihe (A/B/C/-); leer falls Spalte fehlt
    std::string   sweep_axis;                // gesweepte Achse (z.B. migration_policy); leer falls Spalte fehlt
    std::uint64_t working_set_n     = 0;     // Arbeitsmengen-Größe (0 = Spalte fehlt / nicht gesetzt)
    bool          has_working_set_n = false; // true ⇔ working_set_n-Spalte vorhanden und nicht-leer
    double        seg_coverage      = 0.0;   // Σseg_ns/run_total (Mess-Validität); 0 falls Spalte fehlt
    bool          has_seg_coverage  = false;
    // P4 (2026-07-12): die Stapel-Segmente der Per-Achsen-Latenz-Attribution: die kV3AxisCount
    // (ABI-6/INC-2d) Organ-Achsen (Reihenfolge = kCompositionAxisNames: search_algo..persistence_target) +
    // seg_framework_ns als LETZTES Segment (Index kSegmentCount-1). Kommensurabel mit seg_run_total_ns
    // (dem eigenen Wall-Clock des Segment-Laufs run_workload_segmented), NICHT mit total_ns (Real-Workload
    // → 3–29× daneben). Beleg: cache_engine_builder_iterator.hpp:248-257,395-401 (Σ Organ-Segmente +
    // framework = seg_run_total_ns EXAKT). OPTIONAL/header-getrieben/n-a-tolerant: fehlt EINE der
    // seg_*_ns-Spalten ODER ist EINE "n/a" (Nicht-Mess-DLL), bleibt has_seg_ns=false → die Zeile wird bei
    // der Attribution honest ÜBERSPRUNGEN (NICHT 0-gestapelt).
    // M-4/B16 (2026-07-19): Zaehlung aus der CE-Single-Source kV3AxisCount statt Literal — das fruehere
    // hartkodierte 20 (inkl. seg_telemetry_ns/seg_isa_ns) passte nicht mehr zur 17-Achsen-WIDE-CSV.
    static constexpr std::size_t      kSegmentCount = ::comdare::cache_engine::anatomy::kV3AxisCount + 1;
    std::array<double, kSegmentCount> seg_ns{};                  // Organ-Achsen + framework (ns)
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
// E-2b: nicht ausgefuehrte Zellen sind Loecher (z=nan + unbounded coords=jump), NIE ein Ersatzwert.
// Traegt die Flaeche eine ECHT GEMESSENE 0, faellt die z-Achse auf LINEAR zurueck -- eine log-Achse
// kann die 0 weder zeigen noch ehrlich ersetzen (Begruendung + Proben im .cpp).
// P1a (2026-08-06): ROLLE = "3D-Rohdaten-Ansicht" (Diagnose/QA), NICHT Ergebnis-Abbildung. Beide
// Flaechen-Achsen sind NOMINAL -- die aufgespannte Flaeche traegt keine Interpolations-/Trendaussage.
// Titel UND Caption kommen ab P1a aus EINER Quelle (surface3d_title im .cpp); vorher blieb die Caption
// leer, weil aggregate_surface_matrix nur Labels/Matrix/Maske fuellt und niemand data.title setzte.
[[nodiscard]] int write_surface3d_search_algo_x_workload(std::filesystem::path const&        out,
                                                         std::span<WideMeasurementRow const> rows,
                                                         std::string const& z_field, std::string const& lang = "en",
                                                         PageConstraints const& cnst = {});

// GRAPH-UMBAU 2D/3D, P2 (2026-08-06) -- BASELINE-RELATIVE VERHAELTNIS-MATRIX
// -----------------------------------------------------------------------------
// Die Abloesung der Heatmap als ANALYSE-Figur (die rohe Latenz-Heatmap bleibt als Rohdaten-/QA-Ansicht
// bestehen). Zellwert ist nicht mehr der Rohmedian, sondern
//     median(algo, workload) / median(reference_algo, workload)
// also "wie viel langsamer/schneller als die Referenz in genau diesem Lastprofil". Erst dadurch traegt
// die Flaeche einen Bezugspunkt (1.0) und damit ueberhaupt eine Aussage; zwei nominale Achsen ohne
// Referenz sind methodisch schwach. reference_algo ist eine ACHSENAUSPRAEGUNG (z.B. "linear_scan"),
// KEINE externe Bibliothek -- eine gemessene std::map-Serie existiert im Korpus nicht.
//
// AUSFUEHRUNGS-REGEL (die honest-empty-Kernwache dieser Form): eine Verhaeltnis-Zelle ist NUR dann
// executed, wenn ZAEHLER UND NENNER EINZELN ausgefuehrt und darstellbar sind. Fehlt die Referenz fuer
// eine Workload-Spalte (kein Referenz-Lauf in diesem Lastprofil), bleibt die GANZE Spalte
// nicht-ausgefuehrt -- NIEMALS eine Ratio gegen eine fehlende Baseline. Zusaetzlich gilt: ein Nenner von
// ECHT GEMESSENEN 0 ns macht das Verhaeltnis mathematisch undefiniert (nicht unendlich) -> die Zelle
// wird ausgelassen. Ein ZAEHLER von echt 0 ist dagegen ein gueltiges Verhaeltnis 0 und wird DARGESTELLT
// (E-2b-Doktrin: die gemessene 0 ist ein Messwert).
//
// Fehlt die Referenz-Zeile im gesamten Korpus, traegt KEINE Zelle Daten -> write_heatmap schreibt seinen
// ehrlichen Platzhalter-Vermerk (kein pgfplots-Fatal, kompilierfaehige Datei).
[[nodiscard]] int write_surface_ratio_vs_reference(std::filesystem::path const&        out,
                                                   std::span<WideMeasurementRow const> rows, std::string const& z_field,
                                                   std::string const& reference_algo, std::string const& lang = "en",
                                                   PageConstraints const& cnst = {});

// GRAPH-UMBAU 2D/3D, P3a (2026-08-06) -- BASELINE-NORMALISIERTES BALKENDIAGRAMM
// -----------------------------------------------------------------------------
// Dieselbe Aussage wie die Verhaeltnis-Matrix (P2), aber ueber die Lastprofile ZUSAMMENGEFASST: EIN
// Balken je search_algo, Hoehe = nearest-rank-Median der lastprofil-weisen Verhaeltnisse zur Referenz.
// Waagerechte Referenzlinie bei 1. Faerbung nach Seite (unter 1 = schneller, ueber 1 = langsamer).
// Die Matrix zeigt, WO ein Unterschied herkommt; der Balken zeigt, OB er ueber die Lastprofile traegt.
//
// AGGREGATION UEBER VERHAELTNISSE, NICHT UEBER ROHWERTEN: der Median wird ueber die je Lastprofil
// gebildeten Verhaeltnisse genommen, nicht als Verhaeltnis zweier Roh-Mediane. Nur so zaehlt jedes
// Lastprofil gleich; sonst dominierte das langsamste Lastprofil die Aussage allein durch seine
// absolute Groesse.
//
// HONEST-EMPTY: Gruppen ohne ein einziges gueltiges Verhaeltnis (keine Referenz in ihren Lastprofilen)
// werden AUSGELASSEN -- niemals auf 1.0 ("wie die Referenz") oder 0 gesetzt. Traegt KEINE Gruppe ein
// gueltiges Verhaeltnis -> status_empty_input, KEINE Datei (Muster der Darstellungs-Writer 5a-5e).
// y-ACHSEN-MODUS (E-2b-Praezedenz): LOG, weil Verhaeltnisse Dekaden spannen -- faellt aber ein Balken
// auf exakt 0 (Zaehler echt 0 gemessen), fallen alle auf LINEAR zurueck: eine log-Achse kann die 0
// weder zeigen noch ehrlich ersetzen.
[[nodiscard]] int write_normalized_bar_vs_reference(std::filesystem::path const&        out,
                                                    std::span<WideMeasurementRow const> rows,
                                                    std::string const& z_field, std::string const& reference_algo,
                                                    std::string const& lang = "en", PageConstraints const& cnst = {});

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
// Der bisher unvisualisierte Kern-Beitrag: WELCHE der Organ-Achsen (+ Framework-Overhead) wie viel
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

// -----------------------------------------------------------------------------
// E-2c (2026-08-06) -- Pareto-/Tradeoff-Streuung Median-Latenz vs. Tail-Latenz
// -----------------------------------------------------------------------------
//
// OWNER-KERN E-2 ("eine Heatmap ist vielleicht nicht die geeignete Form, wie machen das die anderen Paper?
// Orientiere dich daran und verwende 2D und 3D Graphen."). Der SOTA-Katalog der Planungs-Welle
// (docs/sessions/backups/20260806-e2a-planungs-welle/, Katalog-Position #7) benennt den Scatter-/Pareto-
// Tradeoff-Plot als eine der Kernformen der einschlaegigen Paper-Familie (Idreos/Dayan "Learning Key-Value
// Store Design" Fig. 8; Monkey/Dostoevsky Pareto-Fronten) -- zwei KONKURRIERENDE Kostenachsen, je
// Konfiguration ein Punkt, statt zweier nominaler Kategorien in einer Farbskala.
//
// EHRLICHKEITS-GRUNDLAGE (dieselbe wie P3): das WIDE-Schema traegt je Permutation NUR p50/p99, NICHT die
// rohen Einzel-Op-Latenzen. Genau diese zwei Perzentile SIND aber ein echtes Kostenpaar: Median-Latenz
// (typischer Fall) gegen Tail-Latenz (p99, Dienstguete-Fall). Der Plot erfindet also nichts, sondern traegt
// exakt die beiden vorhandenen Groessen gegeneinander auf. KEINE Aggregation ueber Konfigurationen: jede
// gueltige (Zeile x Op-Art) ist EIN Punkt -- die Punktwolke IST die Aussage (Streuung der Konfigurationen).
struct LatencyTradeoffPoint {
    std::string algo;     // search_algo (Serie/Farbe)
    std::string op;       // Op-Art (insert/lookup/erase/scan/rmw)
    std::string workload; // Lastprofil der Zeile (Diagnose; nicht plot-tragend)
    double      p50_ns = 0.0;
    double      p99_ns = 0.0;
};

// Sammelt die Tradeoff-Punkte. AUFNAHME-REGELN (alle bereits im Modul etabliert, hier nur wiederverwendet):
// two_phase_valid UND search_algo nicht leer UND has_op_p99 (ohne p99 gibt es kein Kostenpaar -> Zeile honest
// ausgelassen, NICHT p99:=p50 gesetzt) UND Op AUSGEFUEHRT (Zaehler op_<art>_n zuerst, sonst p50>0-Heuristik --
// wortgleich zu z_field_executed) UND scan-No-Op-Profile "ycsb_e"/"lp_range_scan" ausgeschlossen. Eine ECHT
// GEMESSENE 0 ist ein gueltiger Punkt (E-2b-Doktrin), KEIN Ausschlussgrund. Leer <=> keine gueltige Zeile.
[[nodiscard]] std::vector<LatencyTradeoffPoint> aggregate_latency_tradeoff(std::span<WideMeasurementRow const> rows);

// Emittiert die Pareto-/Tradeoff-Streuung (x = p50, y = p99, `only marks`, 1 Serie je search_algo mit eigener
// Farbe+Marke, plus die Diagonale y=x als Referenz "kein Tail-Aufschlag"; Punkte oberhalb der Diagonale
// zahlen Tail-Aufschlag, das ist die Lese-Anweisung im Titel).
// ACHSEN-MODUS (E-2b-Praezedenz des 3D-Pfades, wortgleich uebernommen): beide Achsen LOG, weil die Latenz
// Dekaden spannt -- ABER faellt EIN darzustellender Wert auf exakt 0 (echt gemessene 0), fallen BEIDE Achsen
// auf LINEAR zurueck: eine log-Achse kann die 0 weder zeigen noch ehrlich ersetzen (sie verschluckt sie
// lautlos als unbounded coordinate = verschwiegener Messwert).
// HONEST-EMPTY: kein einziger gueltiger Punkt -> status_empty_input (KEINE Datei, kein leerer Plot) -- exakt
// das write_latency_range_bar/write_segment_attribution_stacked_bar-Muster. Breiten-sicher (resizebox_wrap).
[[nodiscard]] int write_latency_tradeoff_scatter(std::filesystem::path const&        out,
                                                 std::span<WideMeasurementRow const> rows,
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
