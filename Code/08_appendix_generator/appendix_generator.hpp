#pragma once
// appendix_generator — Diplomarbeit/Code Module (Pipeline-Stufe 08)
// =============================================================================
// In-Process-Orchestrator ("Facade") für den kompletten WIDE-Mess-Appendix:
// erzeugt je Sprache {de,en} die 11 kanonischen .tex (Bias-Bruch-Matrix +
// 6× Surface-Heatmap + 4× Achsen-Austauschbarkeit + Limitierung) aus EINER
// WIDE-Matrix — cross-platform, ohne .exe-Subprozess-Spawn.
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
#include <filesystem>
#include <map>
#include <string>
#include <string_view>
#include <vector>

namespace comdare::da::appendix_generator {

inline constexpr int status_ok          = 0;
inline constexpr int status_io_error    = 10;
inline constexpr int status_parse_error = 11;

// Die 6 Surface-z-Felder → Datei lc_surface_<z>.tex (Heatmap, full figure; die
// Generator-Funktion schreibt figure+caption selbst). Reihenfolge = Ausgabe-
// Reihenfolge, EXAKT wie generate_wide_appendix.ps1:69-72.
inline constexpr std::array<std::string_view, 6> kSurfaceFields = {
    "ns_per_op", "op_insert_p50_ns", "op_lookup_p50_ns", "op_erase_p50_ns", "op_scan_p50_ns", "op_rmw_p50_ns"};

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
};

// Eingebaute Default-Bias-Caption je Sprache (= generate_wide_appendix.ps1:61-64).
[[nodiscard]] std::string default_bias_caption(std::string const& lang);

// FACADE: parst die WIDE-Matrix EINMAL und schreibt je Sprache nach
// <out_root>/<lang>/tabellen/ die 12 Appendix-.tex (1+6+4+1):
//   bias_matrix_table.tex · lc_surface_<z>.tex (6×) ·
//   ld_exchange_<achse>.tex (4×, Writer benennt selbst) · le_limitierung.tex
// Byte-identisch zu den bisherigen .exe-Spawns des .ps1-Orchestrators (dieselben
// Lib-Writer, dieselben Argumente). Rückgabe: status_ok | status_parse_error |
// status_io_error.
[[nodiscard]] int generate_wide_appendix(AppendixConfig const& cfg);

} // namespace comdare::da::appendix_generator
