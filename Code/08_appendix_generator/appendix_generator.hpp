#pragma once
// appendix_generator — Diplomarbeit/Code Module (Pipeline-Stufe 08)
// =============================================================================
// In-Process-Orchestrator ("Facade") für den kompletten WIDE-Mess-Appendix:
// erzeugt je Sprache {de,en} die 12 Kern-.tex (Bias-Bruch-Matrix + 6× Surface-
// Heatmap + 4× Achsen-Austauschbarkeit + Limitierung) PLUS additiv (Inc-2a) 4
// Darstellungs-.tex (Segment-Attribution + Latenz-Range + Latenz-ECDF + Forest-
// Plot) aus EINER WIDE-Matrix — cross-platform, ohne .exe-Subprozess-Spawn.
//
// Ersetzt den Windows-only PowerShell-Behelfsweg
//   thesis/diplomarbeit/generate_wide_appendix.ps1
// verlustfrei: statt 8×|langs| Aufrufe von csv-to-latex.exe / diagram-generator.exe
// linkt dieses Modul die beiden Bibliotheken comdare::csv_to_latex +
// comdare::diagram_generator direkt und ruft DIESELBEN Writer-Funktionen
// IN-PROCESS. Die WIDE-Matrix wird EINMAL geparst (drei row-Typen, je genau
// einmal) und über alle Sprachen wiederverwendet — kein wiederholtes Re-Parsen
// je Sprache/Surface wie beim exe-Spawn-Weg.
//
// Design-Pattern (wie 04/05): FACADE. generate_wide_appendix() ist die EINE
// Fassade über die zwei Subsystem-Bibliotheken; Aufrufer (CLI/Test) koordinieren
// nur noch die Fassade statt der einzelnen Writer/Spawns. Die 8 Invocation-Typen
// des .ps1 (bias · 6× surface · exchange · limitierung) bilden 1:1 die Fassaden-
// Schritte ab; die m3v2-Sektionen (sota-series/sweep-axis/seg-coverage/sweep-curve)
// bleiben — wie im .ps1 — PARAMETRISCH übersprungen (cowfix-v1 ohne die Spalten).

#include <array>
#include <cstddef>
#include <cstdint>
#include <filesystem>
#include <map>
#include <span>
#include <string>
#include <string_view>
#include <vector>

namespace comdare::da::appendix_generator {

inline constexpr int status_ok          = 0;
inline constexpr int status_io_error    = 10;
inline constexpr int status_parse_error = 11;
// HONEST-EMPTY (wie dg=11 / c2l=12 in den Subsystem-Bibliotheken): der Aufrufer hat nichts
// zu schreiben gegeben bzw. die Quelle traegt keine Eintraege — KEINE Datei, KEIN Fehler.
inline constexpr int status_empty_input = 12;

// Die 6 Surface-z-Felder → Datei lc_surface_<z>.tex (Heatmap, full figure; die
// Generator-Funktion schreibt figure+caption selbst). Reihenfolge = Ausgabe-
// Reihenfolge, EXAKT wie generate_wide_appendix.ps1:69-72.
inline constexpr std::array<std::string_view, 6> kSurfaceFields = {
    "ns_per_op", "op_insert_p50_ns", "op_lookup_p50_ns", "op_erase_p50_ns", "op_scan_p50_ns", "op_rmw_p50_ns"};

// P1b (2026-08-06): die z-Felder der Working-Set-Sweep-Kurve -> ld_sweep_<z>.tex. Bewusst eine
// MINIMALAUSWAHL statt aller 6: die Kurve traegt die Metrik ueber die Arbeitsmengen-Groesse
// (working_set_n), und nur diese drei sind im Sweep-Korpus durchgaengig besetzt. Die Auswahl ist rein
// additiv erweiterbar. HEADER-GETRIEBEN/n-a-tolerant: fehlt die working_set_n-Spalte (cowfix-v1-Korpus),
// liefert write_working_set_sweep_curve status_empty_input -> KEINE Datei, KEIN Fehler.
inline constexpr std::array<std::string_view, 3> kSweepFields = {"ns_per_op", "op_insert_p50_ns",
                                                                 "op_lookup_p50_ns"};

// ── ACHSEN-INVENTAR (2026-08-03) ──────────────────────────────────────────────
// DIE LUECKE: bis hierher kannte diese Stufe NUR die VIER variablen Mess-Achsen
// (c2l::kVariableAxes: search_algo, node_type, memory_layout, prefetch) — exakt
// dieselbe Achsen-Luecke, die auch die abgeloesten .ps1-Orchestratoren hatten
// (thesis/diplomarbeit/generate_{measurement,wide}_appendix.ps1, beide DEPRECATED).
// Der Anhang braucht aber das VOLLE Inventar: 18 Organ-Slots T00-T17, die drei
// System-Haupt-Achsen samt aeusserer Komplex-Klammer und die Mess-Achsen.
//
// QUELL-WAHRHEIT sind die DREI GENERIERTEN Registry-XML des Codes:
//   cache_engine_axis_registry.xml   (Organ-Realm, 18 axis-Eintraege T00-T17)
//   system_axis_registry.xml         (System-Realm, 3 Haupt-Achsen + Komplex-Klammer)
//   measurement_axis_registry.xml    (Mess-Realm, 3 Achsen + dynamic_dims)
// Sie entstehen per compile-time-Reflektion der realen Achsen-Typen und sind
// ausdruecklich NICHT von Hand zu pflegen. Deshalb steht hier KEINE Achsen-Liste
// im Quelltext: eine zweite, handgepflegte Liste waere die naechste Drift-Klasse
// (genau die Klasse, aus der die 4-Achsen-Luecke entstanden ist).
enum class AxisRealm : std::uint8_t { organ = 0, system = 1, measurement = 2 };

// Eine Unter-Achse (bzw. Unter-Achsen-GRUPPE) so, wie die Registry sie fuehrt.
struct RegistrySubAxis {
    std::string id;
    std::string parent;           // Eltern-Achse laut Registry-Attribut; leer = nicht deklariert
    std::string stage;            // "ct" | "runtime"; leer = nicht deklariert
    std::string value_type;       // "token" | "uint"; leer = nicht deklariert
    std::string option_source;    // z.B. "machine_resolved"; leer = nicht deklariert
    bool        is_group = false; // <sub_axis_group> statt <sub_axis>
};

// Ein Achsen-Eintrag der Registry (Haupt-Achse oder aeussere Komplex-Klammer).
struct RegistryAxis {
    AxisRealm   realm = AxisRealm::organ;
    std::string id;
    std::string slot; // "T00".."T17" (Organ-Realm); leer bei System-/Mess-Achsen
    std::string category;
    std::string stage;     // "ct" | "runtime"; leer = nicht deklariert
    std::string binary_id; // "never"; leer = nicht deklariert
    std::size_t baustein_count     = 0;
    bool        has_baustein_count = false;
    // <system_complex_axis>: die aeussere Klammer ist AUSDRUECKLICH KEINE vierte
    // Haupt-Achse — die kanonische System-Achsen-Ordnung bleibt bei dreien.
    bool                         is_complex_bracket = false;
    std::vector<RegistrySubAxis> sub_axes;
};

// Das Ergebnis EINER Registry-Datei. dynamic_dims ist nur im Mess-Realm belegt
// (<dynamic_dims>): Sweep-Dimensionen, die an keiner Achse haengen.
struct AxisRegistry {
    AxisRealm                    realm = AxisRealm::organ;
    std::vector<RegistryAxis>    axes;
    std::vector<RegistrySubAxis> dynamic_dims;
};

// Liest EINE Registry-XML. Hermetisch (kein XML-Fremdcode): die Dateien sind
// generiert und tragen eine feste, attribut-getriebene Gestalt; der Scanner liest
// Tag-Namen + Attribute und ueberspringt Kommentare/Deklarationen.
// status_ok | status_io_error (Datei fehlt/unlesbar) | status_parse_error.
[[nodiscard]] int parse_axis_registry(std::filesystem::path const& xml, AxisRealm realm, AxisRegistry& out);

// Schreibt das Achsen-Inventar als longtable-Fragment (Sprache de|en). Leeres
// Inventar ⇒ status_empty_input und KEINE Datei (honest-empty, kein Phantom).
[[nodiscard]] int write_axis_inventory_table(std::filesystem::path const& out, std::span<AxisRegistry const> registries,
                                             std::string const& lang);

// Konfiguration eines Appendix-Laufs. csv wird NUR gelesen; geschrieben wird je
// Sprache nach <out_root>/<lang>/tabellen/ (Verzeichnisse werden angelegt).
struct AppendixConfig {
    std::filesystem::path    csv;      // WIDE-Matrix (NUR LESEN)
    std::filesystem::path    out_root; // schreibt <out_root>/<lang>/tabellen/
    std::vector<std::string> langs = {"de", "en"};
    // Bias-Matrix Caption/Label — exakt wie in den committeten .tex (s. .ps1:61-65).
    std::string bias_label = "tab:bias:search-algo-workload";
    // Caption je Sprache; fehlt ein lang-Key → eingebauter de/en-Default (= .ps1).
    std::map<std::string, std::string> bias_caption_by_lang = {};
    // ── Achsen-Inventar (additiv) ──────────────────────────────────────────────
    // Die drei generierten Registry-XML. LEER ODER FEHLEND = der Inventar-Block wird
    // ausgelassen (honest-empty): die 12 Kern- und 5 Darstellungs-.tex bleiben davon
    // vollstaendig unberuehrt und byte-identisch.
    std::filesystem::path organ_axis_registry;
    std::filesystem::path system_axis_registry;
    std::filesystem::path measurement_axis_registry;
    // -- GRAPH-UMBAU 2D/3D, P1c (2026-08-06): Referenz fuer die baseline-bezogenen Formen --------------
    // Die Referenz ist eine ACHSENAUSPRAEGUNG des Korpus, KEINE externe Bibliothek: eine gemessene
    // std::map-Serie existiert nicht (jedes std::map im Korpus ist das Konformitaets-Oracle des
    // Pruefdocks, ein Korrektheits- und kein Leistungs-Datenpunkt). Default linear_scan = das
    // unspezialisierte Suchverfahren, die naechstliegende ehrliche Naeherung an einen gemeinsamen Nenner.
    // Kommt der Wert im Korpus nicht vor, sind die referenz-bezogenen Formen honest-empty.
    std::string reference_axis  = "search_algo";
    std::string reference_value = "linear_scan";
};

// Eingebaute Default-Bias-Caption je Sprache (= generate_wide_appendix.ps1:61-64).
[[nodiscard]] std::string default_bias_caption(std::string const& lang);

// FACADE: parst die WIDE-Matrix EINMAL und schreibt je Sprache nach
// <out_root>/<lang>/tabellen/ die 12 Kern-.tex (1+6+4+1):
//   bias_matrix_table.tex · lc_surface_<z>.tex (6×) ·
//   ld_exchange_<achse>.tex (4×, Writer benennt selbst) · le_limitierung.tex
// PLUS additiv (Inc-2a) 4 Darstellungs-.tex aus DENSELBEN geparsten Rows/Aggregaten
// (kein Doppel-Parsen):
//   seg_attribution.tex (05, gestapelte Segment-Attribution, aus surf_rows) ·
//   latency_range.tex   (05, p50→p99-Spanne, aus surf_rows) ·
//   latency_ecdf.tex    (05, Config-Streuung-ECDF, aus surf_rows) ·
//   exchange_forest.tex (04, Forest-Plot der Austauschbarkeit, aus exch_aggs/counts) ·
//   observer_detail.tex (05, INC-4 Per-Achsen-Observer-Detail stat_<achse>_<feld>, aus full_rows)
// PLUS additiv (2026-08-03) das VOLLE Achsen-Inventar aus den drei generierten
// Registry-XML, sofern die Pfade gesetzt sind:
//   axis_inventory.tex  (Organ-Slots T00-T17 + System-Realm + Mess-Realm)
// PLUS additiv (GRAPH-UMBAU 2D/3D, 2026-08-06) die 2D-/3D-Graph-Formen aus DENSELBEN
// surf_rows (kein Doppel-Parsen); beide Writer existierten laengst, waren aber nie
// verdrahtet:
//   lc_surface3d_<z>.tex (6x, P1a: echte 3D-Flaeche je z-Feld, Rohdaten-/QA-Rolle)
//   ld_sweep_<z>.tex     (3x, P1b: Metrik ueber working_set_n, eine Kurve je
//                         gesweepter Achsen-Auspraegung; ohne die Spalte honest-empty)
// HONEST-EMPTY: liefert ein Darstellungs-Writer status_empty_input (n/a-Daten), wird
// die betreffende Datei bewusst NICHT geschrieben — das ist KEIN Facade-Fehler (die 12
// Kern-.tex bleiben unberührt). Die 12 Kern-.tex sind byte-identisch zu den bisherigen
// .exe-Spawns des .ps1-Orchestrators (dieselben Lib-Writer, dieselben Argumente).
// Rückgabe: status_ok | status_parse_error | status_io_error.
[[nodiscard]] int generate_wide_appendix(AppendixConfig const& cfg);

} // namespace comdare::da::appendix_generator
