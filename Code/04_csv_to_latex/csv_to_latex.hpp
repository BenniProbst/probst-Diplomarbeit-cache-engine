#pragma once
// csv_to_latex — Diplomarbeit/Code Module
// Konvertiert measurements.csv → LaTeX-booktabs-Tabelle + automatisierte
// Algorithmus-Baustein-Beschreibung.
//
// REV 7.6: zog aus cache-engine/tools/latex_anhang um. Erweitert um Funktion
// `generate_baustein_description`, die pro Permutations-ID einen kurzen
// Baustein-Steckbrief (Allokator + Concurrency + Prefetch + Telemetry)
// generiert.

#include <array>
#include <cstdint>
#include <filesystem>
#include <map>
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

// ── L-d / L-e (Phase L, 2026-06-18) ─────────────────────────────────────────────────────────────────────
// L-d Achsen-Austauschbarkeit (Geschwister-Paar-Diffs) + L-e ehrliche Limitierungs-longtable.
// Beide konsumieren das WIDE-Schema (parse_wide_csv_full → volle 19-Achsen-Tupel + op_<art>_p50-Spalten).

// Volle WIDE-Zeile inkl. der 5 Interface-Funktions-p50-Spalten (op_<art>_p50_ns) und des kompletten
// 19-Achsen-Tupels (achse→wert), header-getrieben aufgelöst. NUR die für L-d/L-e relevanten Felder.
struct WideFullRow {
    std::string binary_id;
    std::string workload;
    bool        two_phase_valid = false;
    double      ns_per_op       = 0.0;
    // Interface-Funktions-Mediane (op_<art>_p50_ns); 0 = von diesem Lastprofil nicht ausgeübt.
    double      op_insert_p50   = 0.0;
    double      op_lookup_p50   = 0.0;
    double      op_erase_p50    = 0.0;
    double      op_scan_p50     = 0.0;
    double      op_rmw_p50      = 0.0;
    // 19-Achsen-Tupel als (achse→wert)-Map, aus binary_id geparst (achse=wert/achse=wert/...).
    std::map<std::string, std::string> axes;
};

[[nodiscard]] int parse_wide_csv_full(std::filesystem::path const& in,
                                      std::vector<WideFullRow>& out_rows);

// Die 4 VARIABLEN Achsen (alle übrigen 15 sind gepinnt → 1 Wert). Reihenfolge = Ausgabe-Reihenfolge.
inline constexpr std::array<std::string_view, 4> kVariableAxes = {
    "search_algo", "node_type", "memory_layout", "prefetch"};

// Die 5 Interface-Funktionen (std::map-API) + ns_per_op als Gesamt-Maß.
inline constexpr std::array<std::string_view, 5> kInterfaceFns = {
    "insert", "lookup", "erase", "scan", "rmw"};

// Aggregat eines (Achse, Wertepaar v→v', Interface-Funktion)-Tripels: Median + IQR (p25/p75, nearest-rank)
// des relativen Delta (Δns/op bezogen auf v) über alle Geschwister-Paare × valide Lastprofile.
struct ExchangeAggregate {
    std::string axis;
    std::string value_from;
    std::string value_to;
    std::string interface_fn;     // "insert"|"lookup"|"erase"|"scan"|"rmw"|"ns_per_op"
    std::size_t pair_workload_samples = 0;   // Zahl der (Paar × Lastprofil)-Diffs mit definiertem rel-Delta
    double      median_abs_delta_ns   = 0.0;  // Median des absoluten Δ (ns)
    double      median_rel_delta      = 0.0;  // Median des relativen Δ (dimensionslos, bezogen auf v)
    double      iqr_rel_delta         = 0.0;  // p75-p25 des relativen Δ
};

// Geschwister-Paar-Zählung je VARIABLER Achse (L-d.1-Verifikation). Erwartung (literal):
// search_algo=480, node_type=480, prefetch=480, memory_layout=640.
struct SiblingPairCount {
    std::string axis;
    std::size_t pairs = 0;   // Zahl distinkter Lebewesen-Paare, die sich NUR in dieser Achse unterscheiden
};

// L-d.1: bildet Geschwister-Paare + aggregiert je (Achse × Wertepaar × Interface-Fn). Füllt out_counts
// mit der Paar-Zahl je Achse (für die literal-Verifikation). Scan-Diffs schließen die 2 No-Op-Scan-Profile
// (ycsb_e, lp_range_scan) aus. Zero-Baseline-Zellen (v-Median=0) liefern KEIN rel-Delta (ausgeschlossen).
[[nodiscard]] std::vector<ExchangeAggregate>
aggregate_exchange(std::span<WideFullRow const> rows, std::vector<SiblingPairCount>& out_counts);

// L-d.2: schreibt je VARIABLER Achse eine Sammel-longtable (eine Zeile je Wertepaar × Interface-Fn).
// node_type+memory_layout erhalten einen Vorbehalt-Marker (Q2-Schritt-4-Beschattung), search_algo+prefetch
// werden als „am wenigsten konfundiert" gekennzeichnet. Diagnose-Flag = nachweislich verschiedener
// Organ-Pfad (verschiedene binary_id). Ausgabe: anhang/<lang>/tabellen/ld_exchange_<achse>.tex.
[[nodiscard]] int write_exchange_longtables(std::filesystem::path const& out_dir,
                                            std::span<ExchangeAggregate const> aggs,
                                            std::span<SiblingPairCount const> counts,
                                            std::string const& lang = "en");

// L-e.1: schreibt die EINE ehrliche Limitierungs-longtable (anhang/<lang>/tabellen/le_limitierung.tex).
// Zeile 1 (Spitzenplatz) = Cache-Misses/PMC = 0/nicht-erhoben (Kernmetrik). Inhalt ist statisch (die
// nicht-gefixten Vorbehalte); KEINE CSV nötig. lang = "de" | "en".
[[nodiscard]] int write_limitations_longtable(std::filesystem::path const& out,
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
