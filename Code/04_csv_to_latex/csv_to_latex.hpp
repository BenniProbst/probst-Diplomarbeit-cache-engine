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
#include <span>
#include <string>
#include <string_view>
#include <utility>
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

// ── L1: Datenmodell "Ausgabe = Testdaten-Konfig × Tier" (2026-06-13) ───────────────────────────────────
// Die WIDE-CSV trägt zwei orthogonale Identitäts-Achsen, die hier explizit GETRENNT werden (Kern von L1):
//   • TIER   = die volle statische Rekombination (19 Achsen-Belegungen in `binary_id`); s. AxisAssignment.
//   • KONFIG = die dynamischen Testdaten-Dimensionen (`setting` + n_ops/records-Spalten); s. TestdataConfig.
// Zusätzlich werden die per-Interface-Funktions-Latenzen (18 `op_<art>_{n,p50_ns,p99_ns}`-Spalten) als
// std::array<OpLatency,6> eingelesen. Single-Source der Op-Reihenfolge: kOpKindNames (Composite-/Iterator-
// Idiom — feste Reihenfolge, ein einziger Namens-Array bestimmt Indizes konsistent über Parser+Aggregat).

// Interface-Funktions-Arten (feste Reihenfolge; Index = Position in kOpKindNames). Single-Source.
enum class OpKind : std::size_t {
    insert = 0, lookup = 1, erase = 2, clear = 3, scan = 4, rmw = 5
};
inline constexpr std::size_t kOpKindCount = 6;
inline constexpr std::array<std::string_view, kOpKindCount> kOpKindNames{
    "insert", "lookup", "erase", "clear", "scan", "rmw"};

// Per-Interface-Funktions-Latenz (aus op_<art>_{n,p50_ns,p99_ns}); fehlende Spalten → Default (n=0).
struct OpLatency {
    std::uint64_t n      = 0;
    std::int64_t  p50_ns = 0;
    std::int64_t  p99_ns = 0;
};

// Eine Achsen-Belegung der Tier-Identität (geordnetes, stabiles 19-Tupel; Reihenfolge = `binary_id`-Reihenfolge).
struct AxisAssignment {
    std::string axis;    // z.B. "search_algo", "cache_traversal", …
    std::string value;   // z.B. "k_ary", "linear_fanout", …
};

// KONFIG-Tupel: die dynamischen Testdaten-Dimensionen, vom Tier getrennt. Aus `setting` (Form
// "<gruppe>.<key>=<wert>/…", per Suffix-Key aufgelöst → robust gegen Gruppen-Präfix-Änderungen) plus den
// eigenen Spalten n_ops/records. records ist optional ("falls vorhanden"); has_records signalisiert Präsenz.
struct TestdataConfig {
    std::uint64_t thread_count       = 0;
    std::uint64_t prefetch_distance  = 0;
    std::uint64_t repetition_index   = 0;
    std::string   workload_id;        // aus setting (workload.workload_id); = Spalte "workload"
    std::uint64_t n_ops              = 0;
    std::uint64_t records            = 0;
    bool          has_records        = false;
};

struct WideMeasurementRow {
    std::string  binary_id;          // volle statische Rekombination (19 Achsen-Belegungen)
    std::string  search_algo;        // aus binary_id extrahiert (führendes "search_algo=<wert>/")
    std::string  workload;           // Lastprofil-id (Achse 2; eigene Spalte "workload")
    std::uint64_t repetition = 0;
    std::uint64_t n_ops      = 0;
    std::uint64_t total_ns   = 0;
    double        ns_per_op  = 0.0;
    bool          two_phase_valid = false;   // Mess-GÜLTIGKEIT (Zwei-Phasen-Cache-Warmup exakt)

    // L1: getrennte Identitäts-Achsen + per-Interface-Funktions-Latenzen.
    std::vector<AxisAssignment>           axes;       // TIER: geordnetes 19-Achsen-Tupel (binary_id)
    TestdataConfig                        config;     // KONFIG: dyn-Dims (vom Tier getrennt)
    std::array<OpLatency, kOpKindCount>   op_latency; // je OpKind {n,p50_ns,p99_ns}

    // Bequemer Direkt-Accessor je Achse (lineare Suche im 19-Tupel; "" falls Achse fehlt).
    [[nodiscard]] std::string_view axis_value(std::string_view axis) const {
        for (auto const& a : axes)
            if (a.axis == axis) return a.value;
        return {};
    }
};

[[nodiscard]] int parse_wide_csv(std::filesystem::path const& in,
                                 std::vector<WideMeasurementRow>& out_rows);

// L1: parst eine "<achse>=<wert>/<achse>=<wert>/…"-Kette (binary_id) in ein geordnetes, stabiles Tupel.
[[nodiscard]] std::vector<AxisAssignment> parse_axis_tuple(std::string_view binary_id);

// L1: parst die Konfig (dyn-Dims aus `setting` + n_ops/records-Spalten) — Tier-getrennt.
[[nodiscard]] TestdataConfig parse_testdata_config(std::string_view setting,
                                                   std::uint64_t n_ops,
                                                   bool has_records,
                                                   std::uint64_t records);

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

/// L1: per-Interface-Funktions-Aggregat einer (binary_id × workload)-Zelle. Je Op-Art der Median
/// (nearest-rank) von p50_ns über NUR two_phase_valid-Zeilen (dyn-Settings × Repetitionen zusammengefasst).
/// Gruppiert über binary_id (das volle TIER), NICHT nur search_algo — feinere Granularität als
/// TierWorkloadAggregate. Op-Index = OpKind/kOpKindNames (Single-Source-Reihenfolge).
struct TierWorkloadOpAggregate {
    std::string                       binary_id;
    std::string                       workload;
    std::size_t                       samples = 0;
    std::array<double, kOpKindCount>  median_p50_ns_per_op{};   // je OpKind; 0 falls keine Stichprobe
};

[[nodiscard]] std::vector<TierWorkloadOpAggregate>
aggregate_tier_workload_per_op(std::span<WideMeasurementRow const> rows);

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
