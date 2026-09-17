// SPDX-License-Identifier: Apache-2.0
#include "diagram_generator.hpp"

// D5-2: EIN geteilter Zugang zum Perzentil-KANON der ce (kein zweiter Rang-Rechner in super).
#include "percentile_canon.hpp"

#include <algorithm>
#include <charconv>
#include <cmath>
#include <fstream>
#include <iomanip>
#include <iostream> // E-2a: stderr-Log-Zeile der HONEST-EMPTY-Wache (Diagnose-Ebene wie 08/main_cli)
#include <limits>   // E-2a: quiet_NaN als "nicht gemessen"-Sentinel der Flaechen-Matrix
#include <map>
#include <set>
#include <sstream>
#include <string_view>
#include <unordered_map>

namespace comdare::da::diagram_generator {

namespace {

[[nodiscard]] std::string fmt_double(double d) {
    std::ostringstream s;
    s << std::fixed << std::setprecision(4) << d;
    return s.str();
}

// P4 (2026-07-12) / M-4 (2026-07-19): die Stapel-Segment-Spaltennamen kommen aus dem Header
// (kSegmentColumns, diagram_generator.hpp) — dort zur Uebersetzungszeit aus der CE-Single-Source
// kCompositionAxisNames gepraegt. Die fruehere lokale 20er-Literal-Liste (inkl. seg_telemetry_ns/
// seg_isa_ns) ist getilgt: sie driftete gegen die 17-Achsen-WIDE-CSV (B16, seg_attribution nie erzeugt).

// Anzeigename eines Segments = Spaltenname ohne "seg_"-Präfix und "_ns"-Suffix (deterministisch, ein Ort).
[[nodiscard]] std::string segment_label(std::string_view column) {
    std::string s{column};
    if (s.rfind("seg_", 0) == 0) s.erase(0, 4);
    if (s.size() > 3 && s.compare(s.size() - 3, 3, "_ns") == 0) s.erase(s.size() - 3);
    return s;
}

// P3 (2026-07-12): die 5 Interface-Funktions-Op-Arten (Teilmenge kOpKindNames = insert/lookup/erase/scan/rmw,
// spiegelt die 5 in WideMeasurementRow getragenen p50/p99). SINGLE-SOURCE für (a) den p99-Parse (Spaltenname +
// Ziel-Member per Pointer-to-Member) und (b) die Range-Aggregation (p50/p99-Accessor je Op). Reihenfolge =
// feste Stapel-/Legenden-/x-Reihenfolge. p99_col fehlt für den Parse; die Aggregation nutzt nur die Member.
// E-2a (2026-08-06): zusaetzlich n_col/n_mem -- der AUSFUEHRUNGS-ZAEHLER op_<art>_n je Op-Art. Damit traegt
// dieselbe Single-Source jetzt (a) Parse-Spalte + Ziel-Member fuer p99 UND n, (b) die Range-Aggregation und
// (c) die Ausgefuehrt-Wache des Flaechen-Aggregats (z_field_executed).
struct OpRangeSpec {
    std::string_view display;                            // Anzeigename (insert/lookup/erase/scan/rmw)
    std::string_view p50_col;                            // WIDE-Spaltenname der p50
    std::string_view p99_col;                            // WIDE-Spaltenname der p99
    std::string_view n_col;                              // WIDE-Spaltenname des Ausfuehrungs-Zaehlers op_<art>_n
    double WideMeasurementRow::* p50_mem      = nullptr; // Ziel-Member p50 (cppcheck uninitMemberVarNoCtor)
    double WideMeasurementRow::* p99_mem      = nullptr; // Ziel-Member p99 (dito; kRangeOps initialisiert beide)
    std::uint64_t WideMeasurementRow::* n_mem = nullptr; // Ziel-Member des Zaehlers (dito)
};
constexpr std::array<OpRangeSpec, 5> kRangeOps = {{
    {"insert", "op_insert_p50_ns", "op_insert_p99_ns", "op_insert_n", &WideMeasurementRow::op_insert_p50_ns,
     &WideMeasurementRow::op_insert_p99_ns, &WideMeasurementRow::op_insert_n},
    {"lookup", "op_lookup_p50_ns", "op_lookup_p99_ns", "op_lookup_n", &WideMeasurementRow::op_lookup_p50_ns,
     &WideMeasurementRow::op_lookup_p99_ns, &WideMeasurementRow::op_lookup_n},
    {"erase", "op_erase_p50_ns", "op_erase_p99_ns", "op_erase_n", &WideMeasurementRow::op_erase_p50_ns,
     &WideMeasurementRow::op_erase_p99_ns, &WideMeasurementRow::op_erase_n},
    {"scan", "op_scan_p50_ns", "op_scan_p99_ns", "op_scan_n", &WideMeasurementRow::op_scan_p50_ns,
     &WideMeasurementRow::op_scan_p99_ns, &WideMeasurementRow::op_scan_n},
    {"rmw", "op_rmw_p50_ns", "op_rmw_p99_ns", "op_rmw_n", &WideMeasurementRow::op_rmw_p50_ns,
     &WideMeasurementRow::op_rmw_p99_ns, &WideMeasurementRow::op_rmw_n},
}};

void write_pgfplots_axis_options(std::ostream& out, PageConstraints const& cnst, std::string const& title,
                                 std::string const& x_label, std::string const& y_label) {
    out << "    width=" << fmt_double(cnst.width_fraction) << "\\textwidth,\n";
    out << "    height=" << fmt_double(cnst.height_fraction) << "\\textheight,\n";
    if (cnst.keep_aspect_ratio) { out << "    scale only axis,\n"; }
    out << "    title={" << escape_latex(title) << "},\n";
    out << "    xlabel={" << escape_latex(x_label) << "},\n";
    out << "    ylabel={" << escape_latex(y_label) << "},\n";
    out << "    grid=both,\n";
    out << "    enlargelimits=0.05,\n";
}

// TODO-4/#173 (2026-06-20): Breiten-Decorator. Oeffnet/schliesst die \resizebox{\textwidth}{!}{...}-
// Kapsel um das tikzpicture, WENN cnst.resizebox_wrap. Das erzwingt die Gesamtbreite (inkl. Colorbar,
// Title, Y-Label, rotierte Tick-Labels) hart auf \textwidth → eliminiert die scale-only-axis-Overfull-
// Boxen an der Wurzel, ohne die einzelnen Plot-Funktionen zu duplizieren (eine zentrale Stelle).
void open_resizebox(std::ostream& out, PageConstraints const& cnst) {
    if (cnst.resizebox_wrap) out << "\\resizebox{\\textwidth}{!}{%\n";
}
void close_resizebox(std::ostream& out, PageConstraints const& cnst) {
    if (cnst.resizebox_wrap) out << "}%\n";
}

// S-1 (2026-09-16) -- MATHE-FRAGMENTE IM VERMERK, EINGESETZT NACH escape_latex.
// BEFUND (Lens r1, chktex -q -n36 -n17 ueber das Regenerat): der GROESSEN-Vermerk schrieb
// "1x1-Matrix ... (Suchalgorithmen x Workloads) ... mindestens 2x2"; der Bestand der Thesis traegt
// seit dem Hand-Fix 26f88a0 ("fix(lint): chktex-Reinheit Ganzbaum", 2026-08-15) dagegen
// "$1{\times}1$-Matrix ... (Suchalgorithmen $\times$ Workloads) ... mindestens $2{\times}2$".
// Ein Regeneratlauf drehte die Hand-Korrektur also zurueck und erzeugte je Sprache vier
// chktex-W29 ("$\times$ may look prettier here") in zwei Dateien, die anhang/{de,en}/A_measurements.tex
// HART per \input einbindet -- der naechste anhang:forward-Lauf haette lint:latex rot gefaerbt
// (chktex rc=2, von xargs als 123 propagiert).
// WARUM MARKEN: der Vermerk laeuft durch escape_latex, das '$', '{', '}' und '\' maskiert; ein direkt
// eingesetztes $\times$ kaeme als \$\textbackslash{}times\$ heraus. Deshalb exakt das F-5-Muster
// (with_breaks, s. write_axis_observer_detail_table): der Vermerk traegt reine ASCII-MARKEN, die
// escape_latex unveraendert passieren (keine der zehn Sonderzeichen), und die Mathe-Form wird HIER --
// nach dem Maskieren -- eingesetzt.
// RUECKWIRKUNGSFREI: ein Vermerk OHNE Marken bleibt byte-identisch. Kein Bestands-Platzhalter des
// 64er-Sets traegt ein '@' (nachgemessen 2026-09-16 ueber anhang/{de,en}/tabellen/).
constexpr char kMarkDollar[] = "@MATH@";   // -> "$"
constexpr char kMarkBTimes[] = "@BTIMES@"; // -> "{\times}"  (geklammert, zwischen zwei Zahlen)
constexpr char kMarkTimes[]  = "@TIMES@";  // -> "\times"     (blank, allein zwischen zwei Woertern)

[[nodiscard]] std::string replace_all(std::string s, std::string_view from, std::string_view to) {
    if (from.empty()) return s;
    for (std::size_t pos = s.find(from); pos != std::string::npos; pos = s.find(from, pos + to.size()))
        s.replace(pos, from.size(), to);
    return s;
}

[[nodiscard]] std::string with_math_marks(std::string s) {
    s = replace_all(std::move(s), kMarkBTimes, "{\\times}");
    s = replace_all(std::move(s), kMarkTimes, "\\times");
    return replace_all(std::move(s), kMarkDollar, "$");
}

// E-2a/HONEST-EMPTY (2026-08-06) -- der EINE Ort, an dem ein datenloser Flaechen-Writer statt einer
// entarteten pgfplots-Figur einen ehrlichen Vermerk schreibt. Bewusst OHNE pgfplots/tikz: der Vermerk
// muss auch dann kompilieren, wenn die Farbskala mangels positiver Zelle gar nicht bestimmbar waere
// (Fixture-Beleg D-03: alle 8 Zellen 0.0000 -> "I got too few coordinates" -> Fatal, kein PDF).
// Der Writer liefert danach status_ok, weil die Datei EXISTIEREN muss: die 6 lc_surface_<z>.tex haengen
// in A_measurements.tex an blankem \input (kein \InputIfFileExists) -- eine ausgelassene Datei waere nur
// ein zweiter, ebenso fataler LaTeX-Fehler. Deshalb hier Platzhalter statt status_empty_input.
// ASCII-only (Doktrin), Text kommt escape_latex-durchgereicht aus dem Aufrufer.
// REV 7.7/F1 (2026-08-13): optionaler head_comment -- der GROESSEN-Fall (gemessene Matrix unter dem
// 2x2-Minimum) uebergibt einen EIGENEN ehrlichen Kommentarblock, denn der Default-Kopf behauptet
// "KEINE Zelle ... traegt einen ausgefuehrten Messwert" und waere dort falsch (die Zelle IST gemessen).
// Leer -> die vier Bestandszeilen BYTE-IDENTISCH (28 Bestands-Platzhalter des 64er-Sets bleiben gleich).
[[nodiscard]] int write_honest_empty_placeholder(std::filesystem::path const& out_path, std::string const& title,
                                                 std::string const& note, PageConstraints const& cnst,
                                                 std::string const& head_comment = std::string{}) {
    std::ofstream f{out_path};
    if (!f) return status_io_error;
    if (head_comment.empty()) {
        f << "% AUTO-GENERATED durch diagram_generator (E-2a HONEST-EMPTY: Metrik ohne Messwerte)\n";
        f << "% KEINE Zelle dieser (search_algo x workload)-Flaeche traegt einen ausgefuehrten Messwert.\n";
        f << "% Eine Heatmap daraus waere eine erfundene 0-ns-Flaeche (und bricht pgfplots fatal, weil die\n";
        f << "% Farbskala auf eine entartete [0.0:0.0]-Domaene faellt). Daher: ehrlicher Vermerk statt Figur.\n";
    } else {
        f << head_comment;
    }
    if (!cnst.body_only) { f << "\\begin{figure}[" << cnst.position_hint << "]\n\\centering\n"; }
    // S-1: Marken NACH escape_latex aufloesen (F-5-Muster); markenlose Vermerke bleiben gleich.
    f << "\\emph{" << with_math_marks(escape_latex(note)) << "}\n";
    if (!cnst.body_only) { f << "\\caption{" << escape_latex(title) << "}\n\\end{figure}\n"; }
    return f.good() ? status_ok : status_io_error;
}

// E-2b (2026-08-06) -- der EINE Ort fuer die Frage "traegt diese Zelle einen DARSTELLBAREN Messwert?".
// 2D-Heatmap und 3D-Surface MUESSEN dieselbe Antwort geben: dass der 3D-Pfad frueher eigenstaendig nach
// "z > 0" urteilte (und alles andere auf einen Phantom-Vertex hob), waehrend 2D auslies, war genau der
// Divergenz-Befund. Wahrheitsquelle ist HeatmapData::executed (die durchgereichte z_field_executed-
// Klassifikation); fehlt die Maske, gilt exakt die alte Heuristik = BESTANDSVERHALTEN.
[[nodiscard]] bool heatmap_mask_matches(HeatmapData const& d) {
    if (d.executed.size() != d.matrix.size()) return false;
    for (std::size_t y = 0; y < d.matrix.size(); ++y)
        if (d.executed[y].size() != d.matrix[y].size()) return false;
    return true;
}

// have_mask = Ergebnis von heatmap_mask_matches (einmal je Writer bestimmt, nicht je Zelle).
// Eine ausgefuehrte 0 ist DARSTELLBAR; NaN (keine Stichprobe) und negative Werte (keine Latenz) nie.
[[nodiscard]] bool cell_displayable(HeatmapData const& d, bool have_mask, std::size_t y, std::size_t x) {
    double const v = d.matrix[y][x];
    if (!std::isfinite(v) || v < 0.0) return false;
    return have_mask ? static_cast<bool>(d.executed[y][x]) : (v > 0.0);
}

// Neutraler ASCII-Default-Vermerk, falls der Aufrufer HeatmapData::empty_note leer laesst.
[[nodiscard]] std::string default_empty_note() {
    return "(No measured values: this metric was never executed in the present corpus -- the surface is "
           "honestly omitted instead of showing invented zeros.)";
}

// REV 7.7/F1 (2026-08-13): neutraler ASCII-Default fuer den GROESSEN-Fall, falls der Aufrufer
// HeatmapData::degenerate_size_note leer laesst. Bewusst OHNE "never executed"/"nie ausgefuehrt":
// die Matrix IST gemessen, nur als Flaeche nicht darstellbar.
[[nodiscard]] std::string default_degenerate_size_note(std::size_t ny, std::size_t nx) {
    return "(Measured, but not drawable as a surface: the corpus spans only " + std::to_string(ny) +
           " row(s) @MATH@@TIMES@@MATH@ " + std::to_string(nx) +
           " column(s); pgfplots matrix plot requires at least 2 rows and 2 columns. The measured "
           "value(s) are present in the corpus; the surface is omitted honestly instead of failing "
           "the build.)";
}

} // anonymous namespace

std::string escape_latex(std::string_view s) {
    std::string out;
    out.reserve(s.size() + 8);
    for (char c : s) {
        switch (c) {
            case '_': out += "\\_"; break;
            case '&': out += "\\&"; break;
            case '%': out += "\\%"; break;
            case '$': out += "\\$"; break;
            case '#': out += "\\#"; break;
            case '{': out += "\\{"; break;
            case '}': out += "\\}"; break;
            case '~': out += "\\textasciitilde{}"; break;
            case '^': out += "\\textasciicircum{}"; break;
            case '\\': out += "\\textbackslash{}"; break;
            default: out += c;
        }
    }
    return out;
}

int write_bar_chart(std::filesystem::path const& out_path, BarChartData const& data, PageConstraints const& cnst) {
    if (data.values.empty()) return status_empty_input;
    if (data.labels.size() != data.values.size()) return status_empty_input;

    std::ofstream f{out_path};
    if (!f) return status_io_error;

    f << "% AUTO-GENERATED durch diagram_generator (REV 7.6, TikZ-Bar-Chart)\n";
    if (!cnst.body_only) {
        f << "\\begin{figure}[" << cnst.position_hint << "]\n";
        f << "\\centering\n";
    }
    open_resizebox(f, cnst);
    f << "\\begin{tikzpicture}\n";
    f << "\\begin{axis}[\n";
    f << "    ybar,\n";
    f << "    bar width=10pt,\n";
    write_pgfplots_axis_options(f, cnst, data.title, data.x_label, data.y_label);
    f << "    symbolic x coords={";
    for (std::size_t i = 0; i < data.labels.size(); ++i) {
        if (i > 0) f << ",";
        f << escape_latex(data.labels[i]);
    }
    f << "},\n";
    f << "    xtick=data,\n";
    f << "    x tick label style={rotate=45,anchor=east,font=\\tiny},\n";
    f << "]\n";
    f << "\\addplot coordinates {\n";
    for (std::size_t i = 0; i < data.labels.size(); ++i) {
        f << "    (" << escape_latex(data.labels[i]) << "," << fmt_double(data.values[i]) << ")\n";
    }
    f << "};\n";
    f << "\\end{axis}\n";
    f << "\\end{tikzpicture}\n";
    close_resizebox(f, cnst);
    if (!cnst.body_only) {
        f << "\\caption{" << escape_latex(data.title) << "}\n";
        f << "\\end{figure}\n";
    }
    return f.good() ? status_ok : status_io_error;
}

int write_scatter_plot(std::filesystem::path const& out_path, ScatterData const& data, PageConstraints const& cnst) {
    if (data.xs.empty() || data.xs.size() != data.ys.size()) { return status_empty_input; }

    std::ofstream f{out_path};
    if (!f) return status_io_error;

    f << "% AUTO-GENERATED durch diagram_generator (REV 7.6, TikZ-Scatter)\n";
    if (!cnst.body_only) {
        f << "\\begin{figure}[" << cnst.position_hint << "]\n";
        f << "\\centering\n";
    }
    open_resizebox(f, cnst);
    f << "\\begin{tikzpicture}\n";
    f << "\\begin{axis}[\n";
    write_pgfplots_axis_options(f, cnst, data.title, data.x_label, data.y_label);
    f << "]\n";
    f << "\\addplot[only marks, mark=+, mark size=2pt] coordinates {\n";
    for (std::size_t i = 0; i < data.xs.size(); ++i) {
        f << "    (" << fmt_double(data.xs[i]) << "," << fmt_double(data.ys[i]) << ")\n";
    }
    f << "};\n";
    f << "\\end{axis}\n";
    f << "\\end{tikzpicture}\n";
    close_resizebox(f, cnst);
    if (!cnst.body_only) {
        f << "\\caption{" << escape_latex(data.title) << "}\n";
        f << "\\end{figure}\n";
    }
    return f.good() ? status_ok : status_io_error;
}

int write_heatmap(std::filesystem::path const& out_path, HeatmapData const& data, PageConstraints const& cnst) {
    if (data.matrix.empty() || data.matrix[0].empty()) return status_empty_input;

    std::size_t const nx = data.matrix[0].size();
    std::size_t const ny = data.matrix.size();

    // P6 (2026-07-12): LOGARITHMISCHE Farbskala. Die Latenz-Zellen spannen ~4 Dekaden
    // (z.B. 33..235805 ns) → eine LINEARE point-meta-Skala saettigt am unteren Ende und
    // verschluckt die eigentlichen Verfahrens-Unterschiede. Fix: point meta = log10(z),
    // Colorbar-Ticks als echte ns-Dekaden (10^k) relabelt. Konsistent mit dem 3D-Pfad
    // (write_surface3d_..., zmode=log). Farb-Domaene = tatsaechliche Log-Spanne der
    // positiven Zellen (maximaler Kontrast). Fehlende Zelle -> point meta = nan
    // (NICHT log10(0)=-inf): pgfplots zeichnet die Zelle, ohne sie in die Skala zu ziehen.
    // E-2b (2026-08-06): die DARSTELLBAR-Wache liest jetzt die AUSGEFUEHRT-Maske (HeatmapData::executed)
    // statt das Vorzeichen. Vorher galt "nur Wert > 0 ist Datum" -- damit fiel eine ECHT GEMESSENE 0
    // (op_<art>_n > 0 bei p50 == 0) faelschlich unter "nicht ausgefuehrt" und eine Flaeche aus lauter
    // echten Nullen erhielt sogar den "never executed"-Platzhalter. Fehlt die Maske (Direkt-Aufrufer
    // ohne Ausfuehrungs-Wissen), bleibt exakt die alte Heuristik "endlich und > 0" = BESTANDSVERHALTEN.
    bool const have_mask = heatmap_mask_matches(data);

    // Zwei getrennte Wachen: have_pos traegt die LOG-Farbdomaene (nur > 0 ist log-faehig), have_zero die
    // ECHT GEMESSENEN Nullen. Datenlos ist die Flaeche erst, wenn WEDER noch -- eine 0 ist ein Messwert.
    double pos_min   = 0.0;
    double pos_max   = 0.0;
    bool   have_pos  = false;
    bool   have_zero = false;
    for (std::size_t y = 0; y < ny; ++y) {
        for (std::size_t x = 0; x < data.matrix[y].size(); ++x) {
            if (!cell_displayable(data, have_mask, y, x)) continue;
            double const v = data.matrix[y][x];
            if (v == 0.0) {
                have_zero = true;
                continue;
            }
            if (!have_pos) {
                pos_min  = v;
                pos_max  = v;
                have_pos = true;
            } else {
                pos_min = std::min(pos_min, v);
                pos_max = std::max(pos_max, v);
            }
        }
    }

    // -- E-2a/HONEST-EMPTY (VOR dem ofstream, Muster wie write_axis_observer_detail_table): keine einzige
    //    darstellbare Zelle -> KEINE entartete Heatmap (pgfplots-Fatal), sondern ein ehrlicher Vermerk.
    //    E-2b: NUR wenn auch keine echte 0 vorliegt -- eine Flaeche aus lauter gemessenen Nullen ist
    //    gemessen und wird gezeichnet (sie ist gerade das interessante Ergebnis "0 ns gemessen").
    //    Log-Zeile auf stderr (dieselbe Diagnose-Ebene, die appendix_generator/main_cli bereits nutzen).
    if (!have_pos && !have_zero) {
        std::cerr << "diagram-generator: HONEST-EMPTY -- keine ausgefuehrte Messung in der " << ny << "x" << nx
                  << "-Flaeche \"" << data.title << "\" -> Platzhalter-Vermerk statt Heatmap: " << out_path.string()
                  << "\n";
        return write_honest_empty_placeholder(out_path, data.title,
                                              data.empty_note.empty() ? default_empty_note() : data.empty_note, cnst);
    }

    // -- REV 7.7/F1 GROESSEN-WACHE (2026-08-13), NACH der Datenlos-Wache (deren "nie ausgefuehrt"-Text
    //    ist fuer eine DATENLOSE 1x1 der wahrere), VOR dem ofstream. pgfplots' matrix input=image
    //    verlangt >= 2 Zeilen UND >= 2 Spalten; darunter bricht pdflatex kompilier-fatal ab:
    //    "'matrix input=image' is unsupported for line plots (or matrix plots with just 1 row or 1
    //    column)". Proben 13.08.2026 (texlive 2026, compat=1.18, /tmp/f1_probe_1x1): matrix plot*
    //    1x1 rc=1, 1x2 rc=1, 2x2 rc=0; \addplot3[surf] 1x1 rc=0. Der F1-Smoke-Korpus (Job 376333:
    //    1 Algo x 1 Workload, ns_per_op=1199.047) ist GENAU dieser Fall: GEMESSEN, aber unter dem
    //    Minimum -- die E-2a-Wache deckte nur Datenlosigkeit, nicht die GROESSE.
    // SELBSTCHECK
    //   ZUSICHERT: jede lc_surface_/lc_surface_ratio_-Datei kompiliert auch bei 1x1/1xN/Nx1-Korpora
    //              (Platzhalter statt matrix plot*; Rueckgabe status_ok, die Datei existiert).
    //   ZUSICHERT NICHT: nichts ueber den 3D-surf-Pfad (write_surface3d_*: \addplot3[surf] kompiliert
    //              bei 1x1, Probe 13.08.) und nichts ueber Nicht-Matrix-Writer (Bar/Scatter/Sweep/...).
    if (ny < 2 || nx < 2) {
        std::cerr << "diagram-generator: HONEST-EMPTY (Groesse) -- gemessene " << ny << "x" << nx
                  << "-Flaeche unter dem 2x2-Minimum von matrix input=image \"" << data.title
                  << "\" -> Platzhalter-Vermerk statt Heatmap: " << out_path.string() << "\n";
        std::string head;
        head += "% AUTO-GENERATED durch diagram_generator (HONEST-EMPTY (Groesse): Flaeche unter 2x2)\n";
        head += "% Zelle(n) GEMESSEN, aber die Flaeche liegt unter dem 2x2-Minimum von matrix input=image\n";
        head += "% (pgfplots bricht bei 1 Zeile ODER 1 Spalte kompilier-fatal ab). Der Vermerk behauptet\n";
        head += "% ausdruecklich KEINE Datenlosigkeit: der Messwert steht im Korpus.\n";
        return write_honest_empty_placeholder(out_path, data.title,
                                              data.degenerate_size_note.empty() ? default_degenerate_size_note(ny, nx)
                                                                                : data.degenerate_size_note,
                                              cnst, head);
    }

    std::ofstream f{out_path};
    if (!f) return status_io_error;

    // E-2b/META-SKALA. log10(0) existiert nicht -- eine ausgefuehrte 0 braucht daher eine EIGENE, ehrlich
    // beschriftete Farbklasse statt eines erfundenen Ersatzwertes:
    //   (a) positive Werte vorhanden -> Domaene = Log-Spanne der positiven Zellen; liegt zusaetzlich eine
    //       echte 0 vor, wird die Domaene um GENAU EINE Dekade nach unten erweitert und dieser unterste
    //       Colorbar-Tick literal mit "$0$" beschriftet (die 0 sitzt exakt auf ihm). Damit ist die 0
    //       sichtbar UND von der kleinsten positiven Messung unterscheidbar (symlog-Muster).
    //   (b) NUR echte Nullen -> es gibt keine Log-Spanne. Domaene [0:1] (nicht entartet, sonst pgfplots-
    //       Fatal "too few coordinates"), Colorbar traegt genau EINEN Tick "$0$".
    // pdflatex-Proben 2026-08-06 (texlive 2026, pgfplots compat=1.18): (a) RC=0 / 0 Warnungen;
    // (b) RC=0 erst MIT explizitem zmin/zmax -- der blanke Mesh-Traeger waere sonst eine entartete
    // z-Domaene ("Axis range for axis z is approximately empty"); (b) ohne point meta min/max: Fatal.
    // P2: point meta der Verhaeltnis-0-Klasse (divergenter Modus). Wird im Achsen-Options-Block gesetzt
    // und im Koordinaten-Block gelesen -- deshalb hier deklariert.
    double     div_zero_meta = 0.0;
    bool const log_scale     = have_pos;
    double     log_min       = 0.0;
    double     log_max       = 1.0;
    double     zero_meta     = 0.0; // point meta einer ECHT GEMESSENEN 0
    int        k_lo          = 0;
    int        k_hi          = 1;
    if (log_scale) {
        log_min = std::log10(pos_min);
        log_max = std::log10(pos_max);
        if (!(log_max > log_min)) log_max = log_min + 1.0; // entartete Ein-Wert-Matrix aufweiten
        k_lo = static_cast<int>(std::floor(log_min));
        k_hi = static_cast<int>(std::ceil(log_max));
        if (have_zero) {
            --k_lo;                                // eine volle Dekade Luft fuer die 0-Klasse
            zero_meta = static_cast<double>(k_lo); // die 0 sitzt exakt auf dem untersten Tick
            log_min   = zero_meta;                 // Domaenen-Untergrenze = 0-Klasse
        }
    }

    f << "% AUTO-GENERATED durch diagram_generator (REV 7.6, TikZ-Heatmap, P6 log-Farbskala)\n";
    if (!cnst.body_only) {
        f << "\\begin{figure}[" << cnst.position_hint << "]\n";
        f << "\\centering\n";
    }
    open_resizebox(f, cnst);
    f << "\\begin{tikzpicture}\n";
    f << "\\begin{axis}[\n";
    write_pgfplots_axis_options(f, cnst, data.title, data.x_label, data.y_label);
    f << "    view={0}{90},\n";
    f << "    colorbar,\n";
    if (data.divergent) {
        // P2: 3-Stuetzstellen-Colormap blau -> weiss -> rot. pgfplots verteilt die Stuetzstellen
        // GLEICHMAESSIG ueber die Farb-Domaene; weil die Domaene unten symmetrisch um divergent_center
        // gelegt wird, sitzt Weiss damit exakt auf der Mitte (Gleichheit mit der Referenz). Keine
        // Fremd-Colormap, kein zusaetzliches LaTeX-Paket.
        f << "    colormap={comdarediv}{rgb=(0,0,1) rgb=(1,1,1) rgb=(1,0,0)},\n";
    } else {
        f << "    colormap/viridis,\n";
    }
    // P6: Farb-Domaene in log10(ns). point meta min/max = tatsaechliche Log-Spanne (max. Kontrast).
    // E-2a: ab hier IMMER gesetzt -- die datenlose Matrix ist oben schon als Platzhalter abgegangen,
    // die frueher moegliche entartete [0.0:0.0]-Domaene kann hier nicht mehr entstehen.
    if (data.divergent) {
        // P2/SYMMETRISCHE DOMAENE IM LOG-VERHAELTNIS. Zwei Zusagen zugleich:
        //  (a) Die Mitte MUSS die Mitte bleiben, sonst luegt die Farbe: waere die Domaene einfach
        //      [min:max], laege Weiss irgendwo und "gleich schnell wie die Referenz" saehe je nach
        //      Datenlage mal blau, mal rot aus.
        //  (b) Die Farb-Groesse ist log10(z/center), NICHT z-center. Ein Verhaeltnis ist multiplikativ:
        //      "doppelt so schnell" (0.5) und "doppelt so langsam" (2.0) sind gleich weit von der Mitte
        //      entfernt -- linear waeren sie es NICHT (0.5 Abstand gegen 1.0 Abstand). Beleg am realen
        //      d03-Korpus: die Verhaeltnisse spannen 0.44 bis 9.22; auf einer linearen, um 1 zentrierten
        //      Domaene [-7.2:9.2] laegen ALLE Zellen unter 1 zwischen 46.6% und 50% der Skala -- ein
        //      2.3-fach schnellerer Algorithmus waere von "gleich schnell" farblich nicht zu
        //      unterscheiden. Das waere eine systematische Untertreibung genau der Unterschiede, die
        //      diese Figur zeigen soll.
        double half            = 0.0;
        bool   have_ratio_zero = false;
        for (std::size_t y = 0; y < ny; ++y)
            for (std::size_t x = 0; x < data.matrix[y].size(); ++x) {
                if (!cell_displayable(data, have_mask, y, x)) continue;
                double const v = data.matrix[y][x];
                if (v == 0.0) { // Verhaeltnis 0: Zaehler echt 0 gemessen -> hat keinen Logarithmus
                    have_ratio_zero = true;
                    continue;
                }
                half = std::max(half, std::abs(std::log10(v / data.divergent_center)));
            }
        // Entartungs-Wache (Praezedenz 3D-Pfad): traegt die Flaeche nur EINEN Wert -- insbesondere lauter
        // exakte 1.0, wenn ausser der Referenz-Zeile nichts vergleichbar ist --, waere die Farb-Domaene
        // [0:0] und pgfplots braeche fatal ab. Dann wird ausschliesslich die ACHSE geweitet (eine Dekade).
        if (!(half > 0.0)) half = 1.0;
        // Ein Verhaeltnis 0 bekommt -- wortgleich zum log-Modus der Roh-Heatmap -- eine EIGENE Farbklasse
        // eine Dekade unterhalb. Damit die Mitte die Mitte bleibt, waechst die Domaene SYMMETRISCH um
        // diese Dekade; die dadurch oben ungenutzte Dekade ist folgenlos.
        div_zero_meta = -(half + 1.0);
        if (have_ratio_zero) half += 1.0;
        f << "    point meta min=" << fmt_double(-half) << ",\n";
        f << "    point meta max=" << fmt_double(half) << ",\n";
        // Colorbar-Ticks auf ganzzahlige log-Dekaden, beschriftet als VERHAELTNIS (1 = wie die Referenz).
        // Der Leser sieht damit Faktoren, nicht Logarithmen.
        {
            int const k_lo_r = static_cast<int>(std::ceil(-half));
            int const k_hi_r = static_cast<int>(std::floor(half));
            f << "    colorbar style={ytick={";
            bool first = true;
            if (have_ratio_zero) {
                f << fmt_double(div_zero_meta);
                first = false;
            }
            for (int k = k_lo_r; k <= k_hi_r; ++k) {
                if (!first) f << ",";
                f << k;
                first = false;
            }
            f << "}, yticklabels={";
            first = true;
            if (have_ratio_zero) {
                f << "$0$";
                first = false;
            }
            for (int k = k_lo_r; k <= k_hi_r; ++k) {
                if (!first) f << ",";
                if (k == 0) {
                    f << "$1$"; // Gleichheit mit der Referenz
                } else {
                    f << "$10^{" << k << "}$";
                }
                first = false;
            }
            f << "}},\n";
        }
        // z ist bei view={0}{90} nur der Mesh-Traeger; traegt er (nach dem Auslass-0-Traeger) nur einen
        // einzigen Wert, ist auch seine Domaene entartet -> ebenfalls explizit weiten.
        double zc_min = 0.0;
        double zc_max = 0.0;
        for (std::size_t y = 0; y < ny; ++y)
            for (std::size_t x = 0; x < data.matrix[y].size(); ++x) {
                double const carrier = cell_displayable(data, have_mask, y, x) ? data.matrix[y][x] : 0.0;
                zc_min               = (y == 0 && x == 0) ? carrier : std::min(zc_min, carrier);
                zc_max               = (y == 0 && x == 0) ? carrier : std::max(zc_max, carrier);
            }
        if (!(zc_max > zc_min))
            f << "    zmin=" << fmt_double(zc_min) << ", zmax=" << fmt_double(zc_min + 1.0) << ",\n";
    } else {
        f << "    point meta min=" << fmt_double(log_min) << ",\n";
        f << "    point meta max=" << fmt_double(log_max) << ",\n";
        if (log_scale) {
            // Colorbar-Ticks auf ganzzahlige ns-Dekaden relabeln (10^k). Randticks ausserhalb
            // [min,max] clippt pgfplots automatisch -> Achse zeigt echte ns-Werte statt log-Zahlen.
            // E-2b: liegt eine ECHT GEMESSENE 0 vor, ist der unterste Tick (k_lo, die zusaetzliche Dekade)
            // ihre eigene Klasse und wird literal "$0$" beschriftet -- KEINE erfundene 10^k-Behauptung.
            f << "    colorbar style={ytick={";
            for (int k = k_lo; k <= k_hi; ++k) {
                if (k > k_lo) f << ",";
                f << k;
            }
            f << "}, yticklabels={";
            for (int k = k_lo; k <= k_hi; ++k) {
                if (k > k_lo) f << ",";
                if (have_zero && k == k_lo) {
                    f << "$0$";
                } else {
                    f << "$10^{" << k << "}$";
                }
            }
            f << "}},\n";
        } else {
            // E-2b: NUR echte Nullen -> genau EINE Farbklasse, ehrlich mit "$0$" beschriftet. zmin/zmax
            // haelt zusaetzlich die z-Domaene des blanken Mesh-Traegers nicht-entartet (pdflatex-Probe:
            // ohne sie "Axis range for axis z is approximately empty"; z ist bei view={0}{90} kein Datum).
            f << "    colorbar style={ytick={0}, yticklabels={$0$}},\n";
            f << "    zmin=0, zmax=1,\n";
        }
    } // Ende des NICHT-divergenten Zweiges (P2)
    f << "    mesh/cols=" << nx << ",\n"; // PFLICHT fuer matrix plot* (sonst 'matrix input=image' unsupported)
    f << "    xtick={0,1,...," << (nx - 1) << "},\n";
    f << "    ytick={0,1,...," << (ny - 1) << "},\n";
    if (!data.x_labels.empty()) {
        f << "    xticklabels={";
        for (std::size_t i = 0; i < data.x_labels.size(); ++i) {
            if (i > 0) f << ",";
            f << escape_latex(data.x_labels[i]);
        }
        f << "},\n";
        f << "    x tick label style={rotate=45,anchor=east,font=\\tiny},\n";
    }
    if (!data.y_labels.empty()) {
        f << "    yticklabels={";
        for (std::size_t i = 0; i < data.y_labels.size(); ++i) {
            if (i > 0) f << ",";
            f << escape_latex(data.y_labels[i]);
        }
        f << "},\n";
        f << "    y tick label style={font=\\tiny},\n";
    }
    f << "]\n";
    // -- E-2a/AUSLASS-STRATEGIE der Heatmap (empirisch festgelegt, pdflatex+pgfplots-Proben 2026-08-06) --
    // Eine Zelle OHNE Messwert (nicht ausgefuehrt laut Maske bzw. NaN aus aggregate_surface_matrix) wird
    // ueber den EINEN Kanal ausgelassen, den pgfplots' matrix plot dafuer hergibt: point meta = nan.
    // Die Zelle zieht dann die Farbskala NICHT und erscheint als Leerstelle (kein log10(0) = -inf).
    // Die dritte Koordinate ist bei view={0}{90} KEIN Datum, sondern nur der Mesh-Traeger; sie MUSS
    // endlich und lueckenlos sein: matrix plot erlaubt keine Loecher. Belegt durch 3 Proben:
    //   z=nan (Default unbounded coords=discard) -> "coordinate ... has been dropped", Mesh verkuerzt
    //     sich still und mesh/cols interpretiert die Restpunkte falsch (stille Fehl-Darstellung);
    //   z=nan + unbounded coords=jump           -> "Sorry, 'matrix plot' supports no holes (jumps)", Fatal;
    //   addplot3 mit reinen (x,y)-Paaren        -> Fatal (addplot3 verlangt 3 Koordinaten).
    // Deshalb traegt eine nicht gemessene Zelle die blanke 0 OHNE Nachkommastellen: sie ist damit vom
    // %.4f-Format ECHTER Messwerte unterscheidbar und behauptet gerade NICHT den frueheren Literal-Wert
    // "0.0000" (= eine erfundene 0-ns-Messung, Phantom-Falle; vgl. aggregate_latency_range).
    // E-2b: GENAU DREI Zell-Klassen, sauber getrennt (vorher fielen die letzten beiden zusammen):
    //   (1) ausgefuehrt, Wert > 0  -> z="%.4f", meta=log10(z)      (Bestand)
    //   (2) ausgefuehrt, Wert == 0 -> z="0.0000", meta=zero_meta   (DARSTELLBAR: eigene 0-Farbklasse;
    //                                 die 4 Nachkommastellen weisen sie als ECHTE Messung aus)
    //   (3) nicht ausgefuehrt      -> z="0" (blanker Mesh-Traeger), meta=nan (Auslass)
    f << "% HONEST-EMPTY: point meta nan = Zelle NICHT gemessen (Operation nicht ausgefuehrt). Deren\n";
    f << "% dritte Koordinate ist eine blanke 0 = reiner Mesh-Traeger (matrix plot duldet keine Loecher),\n";
    f << "% KEIN Messwert. Echte Messwerte stehen immer mit 4 Nachkommastellen -- auch die gemessene\n";
    f << "% 0.0000, die ihre eigene unterste Farbklasse traegt (Colorbar-Tick literal 0).\n";
    f << "\\addplot3[matrix plot*, point meta=explicit] coordinates {\n";
    for (std::size_t y = 0; y < ny; ++y) {
        for (std::size_t x = 0; x < data.matrix[y].size(); ++x) {
            double const      z   = data.matrix[y][x];
            bool const        has = cell_displayable(data, have_mask, y, x);
            std::string const zs  = has ? fmt_double(z) : std::string{"0"};
            // P2: im divergenten Modus ist die Farb-Groesse log10(z/center) -- ein Verhaeltnis ist
            // multiplikativ, "halb so lang" und "doppelt so lang" muessen gleich weit von der Mitte
            // liegen. Ein Verhaeltnis 0 (Zaehler echt 0 gemessen) hat keinen Logarithmus und traegt
            // deshalb -- wortgleich zum log-Modus -- seine eigene Klasse eine Dekade unterhalb.
            std::string const meta =
                has ? (data.divergent ? fmt_double(z > 0.0 ? std::log10(z / data.divergent_center) : div_zero_meta)
                                      : fmt_double(z > 0.0 ? std::log10(z) : zero_meta))
                    : std::string{"nan"};
            f << "    (" << x << "," << y << "," << zs << ") [" << meta << "]\n";
        }
    }
    f << "};\n";
    f << "\\end{axis}\n";
    f << "\\end{tikzpicture}\n";
    close_resizebox(f, cnst);
    if (!cnst.body_only) {
        f << "\\caption{" << escape_latex(data.title) << "}\n";
        f << "\\end{figure}\n";
    }
    return f.good() ? status_ok : status_io_error;
}

// ─────────────────────────────────────────────────────────────────────────────
// REV 7.6 V22.1 — Sample-CSV-Loader + workload-Gruppen-Plot
// ─────────────────────────────────────────────────────────────────────────────

namespace {

[[nodiscard]] std::vector<std::string> split_csv_line(std::string const& line) {
    std::vector<std::string> fields;
    fields.reserve(16);
    std::string cur;
    cur.reserve(64);
    for (char c : line) {
        if (c == ',') {
            fields.push_back(std::move(cur));
            cur.clear();
        } else {
            cur.push_back(c);
        }
    }
    fields.push_back(std::move(cur));
    return fields;
}

[[nodiscard]] std::uint64_t parse_u64(std::string const& s) noexcept {
    std::uint64_t v     = 0;
    auto const*   first = s.data();
    auto const*   last  = s.data() + s.size();
    auto [_, ec]        = std::from_chars(first, last, v);
    return (ec == std::errc{}) ? v : 0;
}

} // anonymous namespace

std::vector<CsvRow> load_csv_with_workload_used(std::filesystem::path const& csv_path) {
    std::vector<CsvRow> rows;
    std::ifstream       f{csv_path};
    if (!f) return rows;

    std::string line;
    bool        is_header = true;
    while (std::getline(f, line)) {
        if (is_header) {
            is_header = false;
            continue;
        } // skip CSV header
        if (line.empty()) continue;

        auto const fields = split_csv_line(line);
        if (fields.size() < 14) continue; // V20.3 hat 16 Spalten

        CsvRow r;
        r.permutation_id = fields[0];
        // fields[1] = fingerprint, fields[2] = succeeded — nicht benoetigt
        r.workload_used     = fields[3];
        r.op_count          = parse_u64(fields[4]);
        r.total_cycles      = parse_u64(fields[5]);
        r.cache_misses_l1   = parse_u64(fields[6]);
        r.bytes_in_use_peak = parse_u64(fields[13]);
        rows.push_back(std::move(r));
    }
    return rows;
}

int write_throughput_by_workload(std::filesystem::path const& out_tikz, std::span<CsvRow const> rows,
                                 PageConstraints const& cnst) {
    if (rows.empty()) return status_empty_input;

    // Stabile Sortierung nach workload_used (gruppiert), Sekundaer-Schluessel id.
    std::vector<CsvRow> sorted{rows.begin(), rows.end()};
    std::sort(sorted.begin(), sorted.end(), [](CsvRow const& a, CsvRow const& b) {
        if (a.workload_used != b.workload_used) { return a.workload_used < b.workload_used; }
        return a.permutation_id < b.permutation_id;
    });

    BarChartData bar;
    bar.title   = "Throughput pro Permutation, gruppiert nach Workload";
    bar.x_label = "Permutation (gruppiert nach YCSB-Workload)";
    bar.y_label = "Throughput (Mio.\\ Operationen/s)";
    bar.labels.reserve(sorted.size());
    bar.values.reserve(sorted.size());
    for (auto const& r : sorted) {
        // throughput = op_count * 1e9 / total_cycles  (cycles ~ ns in V21.3 Sample)
        double const tput_ops_per_sec =
            (r.total_cycles > 0) ? (static_cast<double>(r.op_count) * 1.0e9 / static_cast<double>(r.total_cycles))
                                 : 0.0;
        // Label-Konvention: "<id> [<workload>]"
        bar.labels.push_back(r.permutation_id + " [" + r.workload_used + "]");
        bar.values.push_back(tput_ops_per_sec / 1.0e6); // in Millionen
    }
    return write_bar_chart(out_tikz, bar, cnst);
}

// ─────────────────────────────────────────────────────────────────────────────
// L-c (2026-06-18) — WIDE-Schema-Reader + Surface/Heatmap je Interface-Funktion
// ─────────────────────────────────────────────────────────────────────────────

namespace {

// WIDE-Schema (';'-getrennt). CR am Zeilenende (CRLF-Quellen) wird getrimmt.
// 1:1 portiert aus 04_csv_to_latex/csv_to_latex.cpp:split_semicolons.
[[nodiscard]] std::vector<std::string> split_semicolons(std::string const& line) {
    std::vector<std::string> out;
    std::string              cur;
    for (char c : line) {
        if (c == ';') {
            out.push_back(std::move(cur));
            cur.clear();
        } else if (c != '\r')
            cur.push_back(c);
    }
    out.push_back(std::move(cur));
    return out;
}

// D5-2 (2026-08-09): der Median kommt jetzt aus dem KANON, nicht mehr aus einer Abschrift.
// Hier stand eine Abschrift DER ABSCHRIFT: der Kommentar verwies auf csv_to_latex.cpp, das
// seinerseits auf ce nearest_rank_p verwies -- eine Funktion, die in der ce als zu Unrecht
// "Nearest-Rank" benannt ersatzlos geloescht wurde. Der Rumpf rechnete round(0.5*(n-1)) und
// traf damit auf GERADER Laenge die OBERE Mitte statt der kanonischen UNTEREN.
// ACHTUNG Geltungsbereich: die Aufrufer bei 1205/1783/1784 mitteln ueber KONFIGURATIONEN
// (bereits aggregierte p50/p99), nicht ueber Messproben. Dass der Kanon auch dort gilt, ist
// eine begruendete Entscheidung -- siehe den Block in Code/common/percentile_canon.hpp.
using comdare::da::stats::nearest_rank_median;

// Wählt das z-Feld einer Zeile per Feld-Name. Unbekannter Name → ns_per_op (Gesamt).
[[nodiscard]] double pick_z_field(WideMeasurementRow const& r, std::string const& z_field) {
    if (z_field == "op_insert_p50_ns") return r.op_insert_p50_ns;
    if (z_field == "op_lookup_p50_ns") return r.op_lookup_p50_ns;
    if (z_field == "op_erase_p50_ns") return r.op_erase_p50_ns;
    if (z_field == "op_scan_p50_ns") return r.op_scan_p50_ns;
    if (z_field == "op_rmw_p50_ns") return r.op_rmw_p50_ns;
    return r.ns_per_op; // "ns_per_op" + Default
}

// E-2a/PHANTOM-FALLE (2026-08-06) -- "wurde die Operation dieser Zeile fuer das gewaehlte z-Feld ueberhaupt
// AUSGEFUEHRT?". Exakt das bereits im Modul etablierte und dokumentierte Muster aus aggregate_latency_range
// ("nicht gelaufen" != "0 ns"), hier aber mit der PRIMAERQUELLE statt der Heuristik:
//   1. op_<art>_n (Ausfuehrungs-Zaehler) -- das echte Signal, sobald der Parser es hat (has_op_n).
//   2. sonst p50 > 0 -- die im Bestand etablierte Heuristik (cowfix-v1-CSV ohne die Zaehler-Spalten);
//      damit bleibt das Verhalten fuer alte Korpora unveraendert (BESTANDSVERHALTEN).
// "ns_per_op" (Gesamt-Latenz ueber alle Operationen) kennt keinen eigenen Zaehler -> gemessen <=> > 0.
[[nodiscard]] bool z_field_executed(WideMeasurementRow const& r, std::string const& z_field) {
    for (auto const& spec : kRangeOps)
        if (z_field == spec.p50_col) return r.has_op_n ? (r.*(spec.n_mem) > 0U) : (r.*(spec.p50_mem) > 0.0);
    return r.ns_per_op > 0.0;
}

// E-2a: Ergebnis der Flaechen-Aggregation. axes_present trennt "gar keine gueltige Zeile" (Bestandsfall,
// Aufrufer: status_empty_input OHNE Datei) von any_data ("Achsen da, aber KEINE Zelle traegt einen
// darstellbaren Messwert" -> HONEST-EMPTY-Platzhalter). Frueher waren beide Faelle ununterscheidbar.
struct SurfaceAggregate {
    bool axes_present = false;
    bool any_data     = false;
};

// Gemeinsame Aggregation für 2D-Heatmap und echte 3D-Surface: füllt die
// (search_algo × workload)-Matrix mit nearest-rank-Median des z-Feldes, NUR über
// two_phase_valid==true. Beim scan-Surface werden die No-Op-Scan-Profile
// "ycsb_e"/"lp_range_scan" ausgeschlossen.
// E-2a: Die ACHSEN entstehen weiterhin aus ALLEN gueltigen Zeilen (unveraendert) -- sie duerfen NICHT auf
// die Zellen mit Daten schrumpfen, weil eine 1-spaltige/1-zeilige Matrix fuer pgfplots' matrix plot* selbst
// fatal ist ("'matrix input=image' is unsupported for line plots", Probe 2026-08-06). Nur die ZELLWERTE
// unterscheiden jetzt: nicht ausgefuehrt -> NaN (nicht 0.0), damit die .tex keine 0-ns-Messung erfindet.
[[nodiscard]] SurfaceAggregate aggregate_surface_matrix(std::span<WideMeasurementRow const> rows,
                                                        std::string const& z_field, HeatmapData& data) {
    bool const is_scan = (z_field == "op_scan_p50_ns");
    // std::map → deterministisch sortierte Achsen-Ordnung (Zeilen y, Spalten x).
    std::map<std::pair<std::string, std::string>, std::vector<double>> groups;
    std::set<std::string>                                              algos;
    std::set<std::string>                                              workloads;
    for (auto const& r : rows) {
        if (!r.two_phase_valid) continue;
        if (r.search_algo.empty()) continue;
        if (is_scan && (r.workload == "ycsb_e" || r.workload == "lp_range_scan")) continue;
        algos.insert(r.search_algo);
        workloads.insert(r.workload);
        // Nur AUSGEFUEHRTE Operationen sind eine Stichprobe. Eine nicht ausgefuehrte Zeile traegt gar
        // nichts bei (statt eine 0 in den Median zu ziehen) -- Muster aggregate_latency_range.
        if (!z_field_executed(r, z_field)) continue;
        groups[{r.search_algo, r.workload}].push_back(pick_z_field(r, z_field));
    }
    SurfaceAggregate agg;
    if (algos.empty() || workloads.empty()) return agg; // axes_present bleibt false (Bestandsverhalten)
    agg.axes_present = true;

    data.y_labels.assign(algos.begin(), algos.end());         // Zeilen = search_algo
    data.x_labels.assign(workloads.begin(), workloads.end()); // Spalten = workload
    // Default JETZT NaN statt 0.0: eine Zelle ohne Stichprobe ist "nicht gemessen", nicht "0 ns gemessen".
    data.matrix.assign(data.y_labels.size(),
                       std::vector<double>(data.x_labels.size(), std::numeric_limits<double>::quiet_NaN()));
    // E-2b: die AUSGEFUEHRT-Maske wird hier gefuellt und bis in die Writer durchgereicht. Nur HIER ist die
    // Ausfuehrungs-Wahrheit bekannt (z_field_executed ueber op_<art>_n); der Writer darf sie NICHT aus dem
    // Wert zurueckraten -- genau daran scheiterte die echt gemessene 0.
    data.executed.assign(data.y_labels.size(), std::vector<bool>(data.x_labels.size(), false));
    for (std::size_t y = 0; y < data.y_labels.size(); ++y) {
        for (std::size_t x = 0; x < data.x_labels.size(); ++x) {
            auto it = groups.find({data.y_labels[y], data.x_labels[x]});
            if (it == groups.end()) continue; // kein Treffer -> Zelle bleibt NaN (ehrlich ausgelassen)
            double const med  = nearest_rank_median(std::move(it->second));
            data.matrix[y][x] = med;
            // Eine Gruppe existiert NUR aus ausgefuehrten Stichproben (z_field_executed-Filter oben) ->
            // die Zelle ist gemessen, AUCH wenn der Median 0 ist. any_data == "mindestens eine
            // DARSTELLBARE Zelle" -- deckungsgleich mit der displayable-Wache in write_heatmap, damit
            // Aggregat und Writer nie widerspruechlich urteilen (der Negativ-Zweig ist reine Abwehr:
            // ein negativer/nicht-endlicher Median waere keine Latenz und bleibt ausgelassen).
            if (std::isfinite(med) && med >= 0.0) {
                data.executed[y][x] = true;
                agg.any_data        = true;
            }
        }
    }
    return agg;
}

// Lokalisierte Titel/Achsen-Beschriftung je z-Feld.
[[nodiscard]] std::string z_field_human(std::string const& z_field, std::string const& lang) {
    bool const de = (lang == "de");
    if (z_field == "op_insert_p50_ns") return de ? "Insert-Latenz p50 (ns/op)" : "insert latency p50 (ns/op)";
    if (z_field == "op_lookup_p50_ns") return de ? "Lookup-Latenz p50 (ns/op)" : "lookup latency p50 (ns/op)";
    if (z_field == "op_erase_p50_ns") return de ? "Erase-Latenz p50 (ns/op)" : "erase latency p50 (ns/op)";
    if (z_field == "op_scan_p50_ns") return de ? "Scan-Latenz p50 (ns/op)" : "scan latency p50 (ns/op)";
    if (z_field == "op_rmw_p50_ns") return de ? "RMW-Latenz p50 (ns/op)" : "rmw latency p50 (ns/op)";
    return de ? "Gesamt-Latenz (ns/op)" : "overall latency (ns/op)";
}

// P2 (2026-08-06) -- BASELINE-RELATIVE VERHAELTNIS-MATRIX.
// Baut AUF aggregate_surface_matrix auf (kein zweiter Aggregations-Pfad, keine zweite Ausfuehrungs-
// Wahrheit): erst die gewohnte Roh-Median-Matrix samt AUSGEFUEHRT-Maske, dann zellweise die Division
// durch die Referenz-Zeile DERSELBEN Spalte. Damit gilt die Ausfuehrungs-Regel der Verhaeltnis-Zelle
// zwangslaeufig ueber BEIDE Operanden -- genau das ist die honest-empty-Kernwache dieser Form.
[[nodiscard]] SurfaceAggregate aggregate_surface_ratio_matrix(std::span<WideMeasurementRow const> rows,
                                                              std::string const&                  z_field,
                                                              std::string const& reference_algo, HeatmapData& data) {
    SurfaceAggregate agg = aggregate_surface_matrix(rows, z_field, data);
    if (!agg.axes_present) return agg; // keine Achsen -> Bestandsverhalten (Aufrufer: status_empty_input)

    // Referenz-ZEILE suchen. Fehlt sie, bleibt jede Zelle ohne Nenner -> any_data faellt auf false und der
    // Writer schreibt den ehrlichen Platzhalter. KEINE Ersatz-Baseline (z.B. Spalten-Minimum): das waere
    // eine erfundene Referenz und genau die Phantom-Klasse, die E-2a/E-2b ausgeraeumt haben.
    bool        have_ref = false;
    std::size_t ref_y    = 0;
    for (std::size_t y = 0; y < data.y_labels.size(); ++y) {
        if (data.y_labels[y] == reference_algo) {
            ref_y    = y;
            have_ref = true;
            break;
        }
    }

    bool const have_mask = heatmap_mask_matches(data);
    // NEUE Puffer: die Quell-Matrix darf waehrend der Division nicht veraendert werden (die Referenz-Zeile
    // wird von JEDER Zeile gelesen, auch von sich selbst).
    std::vector<std::vector<double>> ratio(data.matrix.size());
    std::vector<std::vector<bool>>   exec(data.matrix.size());
    agg.any_data = false;
    for (std::size_t y = 0; y < data.matrix.size(); ++y) {
        ratio[y].assign(data.matrix[y].size(), std::numeric_limits<double>::quiet_NaN());
        exec[y].assign(data.matrix[y].size(), false);
        for (std::size_t x = 0; x < data.matrix[y].size(); ++x) {
            if (!have_ref) continue;
            // (a) Zaehler-Zelle muss ausgefuehrt und darstellbar sein.
            if (!cell_displayable(data, have_mask, y, x)) continue;
            // (b) Nenner-Zelle DERSELBEN Spalte ebenso -- fehlt der Referenz-Lauf fuer dieses Lastprofil,
            //     bleibt die ganze Spalte leer. NIE gegen eine fehlende Baseline rechnen.
            if (x >= data.matrix[ref_y].size()) continue;
            if (!cell_displayable(data, have_mask, ref_y, x)) continue;
            double const den = data.matrix[ref_y][x];
            // (c) Ein Nenner von ECHT GEMESSENEN 0 ns macht das Verhaeltnis undefiniert (nicht unendlich).
            //     Ehrlich ausgelassen statt als Unendlich/Ersatzwert behauptet.
            if (!(den > 0.0)) continue;
            ratio[y][x]  = data.matrix[y][x] / den; // Zaehler darf 0 sein -> Verhaeltnis 0 ist gueltig
            exec[y][x]   = true;
            agg.any_data = true;
        }
    }
    data.matrix   = std::move(ratio);
    data.executed = std::move(exec);
    return agg;
}

// P1a (2026-08-06) -- ROLLEN-BENENNUNG der 3D-Flaeche, EIN Ort fuer Achsen-Titel UND Caption.
// Beide Flaechen-Achsen (search_algo x workload) sind NOMINAL: zwischen zwei Suchalgorithmen liegt
// nichts, was man interpolieren koennte. Die von "surf" aufgespannte Flaeche ist daher eine
// Ablese-Hilfe ueber den gemessenen Stuetzstellen, KEIN Modell und keine Trendaussage. Die Figur heisst
// deshalb ausdruecklich "Rohdaten-Ansicht" (Diagnose/QA-Rolle); die analysierenden Aussagen tragen die
// referenz-bezogenen Formen. Zweiter, ebenso wichtiger Zweck dieser Funktion: data.title wird jetzt
// ueberhaupt gesetzt -- aggregate_surface_matrix fuellt nur Labels/Matrix/Maske, sodass die Caption des
// (bis P1a nirgends verdrahteten) 3D-Writers bisher LEER blieb.
[[nodiscard]] std::string surface3d_title(std::string const& metric, bool de) {
    return (de ? "3D-Rohdaten-Ansicht: " : "3D raw-data view: ") + metric +
           (de ? " (Suchalgorithmus x Workload)" : " (search algorithm x workload)");
}

} // anonymous namespace

int parse_wide_csv(std::filesystem::path const& in, std::vector<WideMeasurementRow>& out_rows) {
    std::ifstream f{in};
    if (!f) return status_io_error;
    std::string header_line;
    if (!std::getline(f, header_line)) return status_empty_input;

    // HEADER-GETRIEBEN: Spalten per Name auflösen (Reihenfolge-/Breite-agnostisch → robust gegen
    // additive Schema-Erweiterungen des Mess-Systems). 1:1 aus csv_to_latex.cpp:158-201 portiert,
    // erweitert um die 5 Interface-Funktions-p50-Pflichtspalten.
    auto const                                   header = split_semicolons(header_line);
    std::unordered_map<std::string, std::size_t> col;
    for (std::size_t i = 0; i < header.size(); ++i) col.emplace(header[i], i);
    char const* required[] = {"binary_id",       "ns_per_op",        "workload",
                              "two_phase_valid", "op_insert_p50_ns", "op_lookup_p50_ns",
                              "op_erase_p50_ns", "op_scan_p50_ns",   "op_rmw_p50_ns"};
    for (char const* name : required)
        if (col.find(name) == col.end()) return status_empty_input;

    std::string line;
    while (std::getline(f, line)) {
        if (line.empty() || line == "\r") continue;
        auto cols = split_semicolons(line);
        if (cols.size() != header.size()) return status_empty_input; // gleiche-Breite-Prüfung
        try {
            WideMeasurementRow r;
            r.binary_id        = cols[col["binary_id"]];
            r.workload         = cols[col["workload"]];
            r.ns_per_op        = std::stod(cols[col["ns_per_op"]]);
            r.op_insert_p50_ns = std::stod(cols[col["op_insert_p50_ns"]]);
            r.op_lookup_p50_ns = std::stod(cols[col["op_lookup_p50_ns"]]);
            r.op_erase_p50_ns  = std::stod(cols[col["op_erase_p50_ns"]]);
            r.op_scan_p50_ns   = std::stod(cols[col["op_scan_p50_ns"]]);
            r.op_rmw_p50_ns    = std::stod(cols[col["op_rmw_p50_ns"]]);
            r.two_phase_valid  = (cols[col["two_phase_valid"]] == "1");
            // search_algo aus der binary_id: führendes "search_algo=<wert>/".
            constexpr std::string_view kPrefix = "search_algo=";
            if (r.binary_id.rfind(kPrefix, 0) == 0) {
                std::size_t const end = r.binary_id.find('/', kPrefix.size());
                r.search_algo         = r.binary_id.substr(
                    kPrefix.size(), (end == std::string::npos ? r.binary_id.size() : end) - kPrefix.size());
            }
            // M3v2-Tag-Spalten OPTIONAL/header-getrieben (NICHT in required[] → cowfix-v1 bricht nicht):
            // fehlt die Spalte, bleibt das Feld leer/0 (n/a). col.find() schützt vor Out-of-range.
            if (auto it = col.find("series"); it != col.end()) r.series = cols[it->second];
            if (auto it = col.find("sweep_axis"); it != col.end()) r.sweep_axis = cols[it->second];
            if (auto it = col.find("working_set_n"); it != col.end() && !cols[it->second].empty()) {
                try {
                    r.working_set_n     = std::stoull(cols[it->second]);
                    r.has_working_set_n = true;
                } catch (std::exception const&) { /* leere/ungültige Zelle = n/a, kein Crash */
                }
            }
            if (auto it = col.find("seg_coverage"); it != col.end() && !cols[it->second].empty()) {
                try {
                    r.seg_coverage     = std::stod(cols[it->second]);
                    r.has_seg_coverage = true;
                } catch (std::exception const&) { /* n/a */
                }
            }
            // P4 (2026-07-12): die kSegmentCount Stapel-Segmente (Organ-Achsen kCompositionAxisNames +
            // seg_framework_ns) + seg_run_total_ns. OPTIONAL/header-getrieben (NICHT in required[] → cowfix-v1 bricht
            // nicht). n-a-tolerant: fehlt EINE Spalte ODER ist EINE Zelle leer/"n/a"/nicht-numerisch → has_seg_ns bleibt false (Zeile
            // wird bei der Attribution honest übersprungen, NICHT 0-gestapelt). Der stod-Wurf wird LOKAL geschluckt
            // (NICHT an die äußere catch weitergereicht), damit eine n/a-Zelle keinen ganzen Parse-Fehler auslöst.
            {
                bool all_present = true;
                for (std::size_t s = 0; s < WideMeasurementRow::kSegmentCount; ++s) {
                    auto sit = col.find(std::string{kSegmentColumns[s]});
                    if (sit == col.end()) {
                        all_present = false;
                        break;
                    }
                    std::string const& cell = cols[sit->second];
                    if (cell.empty() || cell == "n/a") {
                        all_present = false;
                        break;
                    }
                    try {
                        r.seg_ns[s] = std::stod(cell);
                    } catch (std::exception const&) {
                        all_present = false;
                        break;
                    }
                }
                r.has_seg_ns = all_present;
            }
            if (auto it = col.find("seg_run_total_ns");
                it != col.end() && !cols[it->second].empty() && cols[it->second] != "n/a") {
                try {
                    r.seg_run_total_ns  = std::stod(cols[it->second]);
                    r.has_seg_run_total = true;
                } catch (std::exception const&) { /* n/a */
                }
            }
            // P3 (2026-07-12): die 5 op_<art>_p99_ns (spiegeln die 5 op_*_p50_ns). OPTIONAL/header-getrieben
            // (NICHT in required[] → cowfix-v1 ohne p99 bricht nicht). n-a-tolerant: fehlt EINE der 5 Spalten
            // ODER ist EINE Zelle leer/"n/a"/nicht-numerisch → has_op_p99 bleibt false (Zeile trägt zur Range-
            // Aggregation nichts bei, wird NICHT als 0 gewhiskert). Der stod-Wurf wird LOKAL geschluckt.
            {
                bool all_present = true;
                for (auto const& spec : kRangeOps) {
                    auto oit = col.find(std::string{spec.p99_col});
                    if (oit == col.end()) {
                        all_present = false;
                        break;
                    }
                    std::string const& cell = cols[oit->second];
                    if (cell.empty() || cell == "n/a") {
                        all_present = false;
                        break;
                    }
                    try {
                        r.*(spec.p99_mem) = std::stod(cell);
                    } catch (std::exception const&) {
                        all_present = false;
                        break;
                    }
                }
                r.has_op_p99 = all_present;
            }
            // E-2a/HONEST-EMPTY (2026-08-06): die 5 AUSFUEHRUNGS-ZAEHLER op_<art>_n. Sie sind das direkte
            // Signal "Operation nicht ausgefuehrt" (n==0) und trennen es von "echt 0 ns" -- bisher wurde das
            // Signal aus der WIDE-CSV schlicht verworfen. Gleiches Muster wie der p99-Block darueber:
            // OPTIONAL/header-getrieben (NICHT in required[]), n-a-tolerant, stoull-Wurf LOKAL geschluckt.
            // Fehlt EINE der 5 Spalten ODER ist EINE Zelle leer/"n/a"/nicht-numerisch -> has_op_n bleibt
            // false und die Auswertung faellt auf die p50>0-Heuristik zurueck = BESTANDSVERHALTEN.
            {
                bool all_present = true;
                for (auto const& spec : kRangeOps) {
                    auto nit = col.find(std::string{spec.n_col});
                    if (nit == col.end()) {
                        all_present = false;
                        break;
                    }
                    std::string const& cell = cols[nit->second];
                    if (cell.empty() || cell == "n/a") {
                        all_present = false;
                        break;
                    }
                    try {
                        r.*(spec.n_mem) = std::stoull(cell);
                    } catch (std::exception const&) {
                        all_present = false;
                        break;
                    }
                }
                r.has_op_n = all_present;
            }
            out_rows.push_back(std::move(r));
        } catch (std::exception const&) { return status_empty_input; }
    }
    return status_ok;
}

int write_surface_search_algo_x_workload(std::filesystem::path const& out, std::span<WideMeasurementRow const> rows,
                                         std::string const& z_field, std::string const& lang,
                                         PageConstraints const& cnst) {
    if (rows.empty()) return status_empty_input;
    HeatmapData data;
    if (!aggregate_surface_matrix(rows, z_field, data).axes_present) return status_empty_input;

    bool const        de     = (lang == "de");
    std::string const metric = z_field_human(z_field, lang);
    data.title               = (de ? "Heatmap: " : "Heatmap: ") + metric +
                               (de ? " (Suchalgorithmus x Workload)" : " (search algorithm x workload)");
    data.x_label             = de ? "Workload" : "workload";
    data.y_label             = de ? "Suchalgorithmus" : "search algorithm";
    // E-2a: sprach-lokalisierter HONEST-EMPTY-Vermerk. write_heatmap nutzt ihn NUR, wenn keine einzige
    // Zelle einen darstellbaren Messwert traegt (dann Platzhalter statt entarteter Heatmap).
    // Reiner Text (escape_latex-durchgereicht) -- kein Mathe-Modus, keine Nicht-ASCII-Zeichen.
    data.empty_note = de ? ("(Keine Messwerte: " + metric +
                            " wurde im vorliegenden Korpus nie ausgefuehrt. Diese Flaeche wird ehrlich ausgelassen, "
                            "statt eine 0-ns-Messung zu behaupten.)")
                         : ("(No measured values: " + metric +
                            " was never executed in the present corpus. This surface is honestly omitted instead of "
                            "claiming a 0 ns measurement.)");
    // REV 7.7/F1 (2026-08-13): sprach-lokalisierter GROESSEN-Vermerk (Matrix GEMESSEN, aber unter dem
    // 2x2-Minimum von matrix input=image -- 1x1/1xN/Nx1 kompilier-fatal). Er darf ausdruecklich NICHT
    // "nie ausgefuehrt" behaupten: der Messwert ist im Korpus VORHANDEN (F1-Beleg Job 376333, 1x1-Smoke,
    // ns_per_op=1199.047). Wortlaut nennt Metrik + Groesse + Vorhandensein.
    {
        // S-1: Marken statt "AxB" -- with_math_marks setzt daraus "$A{\\times}B$" (Bestandsform 26f88a0).
        std::string const size_txt = "@MATH@" + std::to_string(data.y_labels.size()) + "@BTIMES@" +
                                     std::to_string(data.x_labels.size()) + "@MATH@";
        // F1-FIX (2026-08-13, Lens-Fund e-ii): Numerus nach der ZAHL DER MESSWERTE, nicht pauschal
        // Singular -- eine gemessene 1x3-Matrix traegt drei Messwerte, "Der Messwert selbst ist" war
        // dort sachlich falsch. Gezaehlt wird mit exakt der Zellen-Logik des Writers (Masken-Wache +
        // cell_displayable), nicht ueber ny*nx: nicht ausgefuehrte Zellen sind keine Messwerte. Der
        // ratio-Pfad unten bleibt zu Recht IMMER Plural (jede Verhaeltnis-Zelle = Zaehler UND Nenner).
        bool const  note_mask = heatmap_mask_matches(data);
        std::size_t n_meas    = 0;
        for (std::size_t y = 0; y < data.matrix.size(); ++y)
            for (std::size_t x = 0; x < data.matrix[y].size(); ++x)
                if (cell_displayable(data, note_mask, y, x)) ++n_meas;
        bool const one = (n_meas == 1);
        data.degenerate_size_note =
            de ? ("(Gemessen, aber nicht als Flaeche darstellbar: " + metric +
                  " liegt im vorliegenden Korpus nur als " + size_txt +
                  "-Matrix vor (Suchalgorithmen @MATH@@TIMES@@MATH@ Workloads); die pgfplots-Flaechenform "
                  "verlangt mindestens @MATH@2@BTIMES@2@MATH@. " +
                  (one ? "Der Messwert selbst ist" : "Die Messwerte selbst sind") +
                  " im Korpus vorhanden; die Flaeche wird ehrlich ausgelassen, "
                  "statt den Bau zu brechen.)")
               : ("(Measured, but not drawable as a surface: " + metric + " spans only a " + size_txt +
                  " matrix (search algorithms @MATH@@TIMES@@MATH@ workloads) in the present corpus; the "
                  "pgfplots surface form requires at least @MATH@2@BTIMES@2@MATH@. " +
                  (one ? "The measured value itself is" : "The measured values themselves are") +
                  " present in the corpus; the surface is "
                  "omitted honestly instead of failing the build.)");
    }
    // write_heatmap WIEDERVERWENDEN (view={0}{90} matrix plot + colormap/viridis).
    return write_heatmap(out, data, cnst);
}

int write_surface_ratio_vs_reference(std::filesystem::path const& out, std::span<WideMeasurementRow const> rows,
                                     std::string const& z_field, std::string const& reference_algo,
                                     std::string const& lang, PageConstraints const& cnst) {
    if (rows.empty()) return status_empty_input;
    HeatmapData data;
    if (!aggregate_surface_ratio_matrix(rows, z_field, reference_algo, data).axes_present) return status_empty_input;

    bool const        de     = (lang == "de");
    std::string const metric = z_field_human(z_field, lang);
    // P2: die divergente Skala ist der ganze Punkt dieser Form -- ohne sie waere das Verhaeltnis nur eine
    // weitere sequentielle Flaeche und die Gleichheit mit der Referenz optisch nicht auffindbar.
    data.divergent        = true;
    data.divergent_center = 1.0;
    data.title   = (de ? "Verhaeltnis zur Referenz " : "Ratio to reference ") + reference_algo + ": " + metric +
                   (de ? " (1 = wie die Referenz)" : " (1 = same as reference)");
    data.x_label = de ? "Workload" : "workload";
    data.y_label = de ? "Suchalgorithmus" : "search algorithm";
    // HONEST-EMPTY-Vermerk. Er nennt die Referenz beim Namen: "keine Daten" hat hier zwei ganz
    // verschiedene Ursachen (Metrik nie ausgefuehrt ODER Referenz nicht gemessen), und der Leser muss
    // beide unterscheiden koennen.
    data.empty_note =
        de ? ("(Keine vergleichbaren Messwerte: " + metric + " liegt im vorliegenden Korpus fuer " + reference_algo +
              " nicht als Referenz vor (oder wurde nie ausgefuehrt). Diese Flaeche wird ehrlich "
              "ausgelassen, statt ein Verhaeltnis gegen eine fehlende Referenz zu behaupten.)")
           : ("(No comparable measurements: " + metric + " has no reference series for " + reference_algo +
              " in the present corpus (or was never executed). This surface is honestly omitted "
              "instead of claiming a ratio against a missing reference.)");
    // REV 7.7/F1 (2026-08-13): GROESSEN-Vermerk des ratio-Pfades -- die Verhaeltnis-Matrix traegt Daten
    // (Referenz IM Korpus), ist aber unter dem 2x2-Minimum. KEINE "nie ausgefuehrt"-Behauptung; der
    // Wortlaut nennt Metrik, Referenz, Groesse und dass die Messwerte im Korpus VORHANDEN sind.
    {
        // S-1: dieselbe Marken-Form wie im Heatmap-Pfad (derselbe chktex-W29-Gegenstand).
        std::string const size_txt = "@MATH@" + std::to_string(data.y_labels.size()) + "@BTIMES@" +
                                     std::to_string(data.x_labels.size()) + "@MATH@";
        data.degenerate_size_note =
            de ? ("(Gemessen, aber nicht als Flaeche darstellbar: das Verhaeltnis " + metric + " zur Referenz " +
                  reference_algo + " liegt im vorliegenden Korpus nur als " + size_txt +
                  "-Matrix vor (Suchalgorithmen @MATH@@TIMES@@MATH@ Workloads); die pgfplots-Flaechenform "
                  "verlangt mindestens @MATH@2@BTIMES@2@MATH@. Die Messwerte selbst sind im Korpus vorhanden; "
                  "die Flaeche wird ehrlich ausgelassen, statt den Bau zu brechen.)")
               : ("(Measured, but not drawable as a surface: the ratio of " + metric + " to reference " +
                  reference_algo + " spans only a " + size_txt +
                  " matrix (search algorithms @MATH@@TIMES@@MATH@ workloads) in the present corpus; the "
                  "pgfplots surface form requires at least @MATH@2@BTIMES@2@MATH@. The measured values "
                  "themselves are present in the corpus; the surface is omitted honestly instead of failing "
                  "the build.)");
    }
    return write_heatmap(out, data, cnst);
}

namespace {
// Vorwaerts-Deklaration: die Kategorienfarben-Hilfe steht weiter unten in DERSELBEN anonymen
// Namensraum-Gruppe (bei der Segment-Attribution, die sie zuerst gebraucht hat). Der Tradeoff-Plot
// nutzt sie fuer seine Serienfarben -- eine zweite Farbfunktion waere die naechste Drift-Klasse.
void hsv_to_rgb(double h, double s, double v, int& r_out, int& g_out, int& b_out);
} // namespace

std::vector<LatencyTradeoffPoint> aggregate_latency_tradeoff(std::span<WideMeasurementRow const> rows) {
    std::vector<LatencyTradeoffPoint> out;
    for (auto const& r : rows) {
        if (!r.two_phase_valid) continue;
        if (r.search_algo.empty()) continue;
        // Ohne p99 gibt es kein Kostenpaar -> Zeile HONEST ausgelassen. Ausdruecklich NICHT p99:=p50
        // setzen: das behauptete "kein Tail-Aufschlag", also einen Befund, den die Daten nicht tragen.
        if (!r.has_op_p99) continue;
        for (auto const& spec : kRangeOps) {
            // scan-No-Op-Profile wie im Flaechen-/Range-Pfad ausschliessen (fuer Scan invalide).
            if (spec.display == "scan" && (r.workload == "ycsb_e" || r.workload == "lp_range_scan")) continue;
            // AUSGEFUEHRT? Zaehler zuerst, sonst die p50>0-Heuristik -- wortgleich zu z_field_executed.
            bool const executed = r.has_op_n ? (r.*(spec.n_mem) > 0U) : (r.*(spec.p50_mem) > 0.0);
            if (!executed) continue;
            double const p50 = r.*(spec.p50_mem);
            double const p99 = r.*(spec.p99_mem);
            // Negative/nicht-endliche Werte sind keine Latenzen (reine Abwehr). Eine ECHT GEMESSENE 0
            // ist dagegen ein gueltiger Punkt (E-2b-Doktrin), KEIN Ausschlussgrund.
            if (!std::isfinite(p50) || !std::isfinite(p99) || p50 < 0.0 || p99 < 0.0) continue;
            out.push_back({r.search_algo, std::string{spec.display}, r.workload, p50, p99});
        }
    }
    // Deterministische Ordnung (Serie, dann Op, dann Lastprofil) -- reproduzierbare .tex.
    std::sort(out.begin(), out.end(), [](LatencyTradeoffPoint const& a, LatencyTradeoffPoint const& b) {
        if (a.algo != b.algo) return a.algo < b.algo;
        if (a.op != b.op) return a.op < b.op;
        if (a.workload != b.workload) return a.workload < b.workload;
        if (a.p50_ns != b.p50_ns) return a.p50_ns < b.p50_ns;
        return a.p99_ns < b.p99_ns;
    });
    return out;
}

int write_latency_tradeoff_scatter(std::filesystem::path const& out, std::span<WideMeasurementRow const> rows,
                                   std::string const& lang, PageConstraints const& cnst) {
    auto const points = aggregate_latency_tradeoff(rows);
    if (points.empty()) return status_empty_input; // honest leer, KEINE Datei

    bool const de = (lang == "de");

    // Serien = search_algo (deterministisch sortiert, weil aggregate_latency_tradeoff sortiert liefert).
    std::vector<std::string> algos;
    for (auto const& p : points)
        if (algos.empty() || algos.back() != p.algo) algos.push_back(p.algo);

    // E-2b-Praezedenz (wortgleich zum 3D-Pfad): beide Achsen LOG, weil die Latenz Dekaden spannt --
    // faellt aber EIN darzustellender Wert auf exakt 0 (echt gemessene 0), fallen BEIDE Achsen auf
    // LINEAR zurueck. Eine log-Achse verschluckt die 0 lautlos als unbounded coordinate; das waere ein
    // verschwiegener Messwert.
    bool   have_zero = false;
    double lo = 0.0, hi = 0.0;
    bool   have_val = false;
    for (auto const& p : points) {
        if (p.p50_ns == 0.0 || p.p99_ns == 0.0) have_zero = true;
        for (double const v : {p.p50_ns, p.p99_ns}) {
            if (!have_val) {
                lo       = v;
                hi       = v;
                have_val = true;
            } else {
                lo = std::min(lo, v);
                hi = std::max(hi, v);
            }
        }
    }
    bool const log_axes = !have_zero;

    std::ofstream f{out};
    if (!f) return status_io_error;
    f << "% AUTO-GENERATED durch diagram_generator (E-2c, Pareto-/Tradeoff-Streuung p50 vs p99; lang=" << lang << ")\n";
    f << "% Ein Punkt je (Konfiguration x Op-Art): x = Median-Latenz, y = Tail-Latenz (p99). Beide Groessen\n";
    f << "% stehen SO im WIDE-Schema -- nichts ist erfunden, nichts aggregiert. Diagonale y=x = kein\n";
    f << "% Tail-Aufschlag; je weiter ein Punkt darueber liegt, desto teurer sein Ausreisser-Verhalten.\n";
    f << "% Achsen " << (log_axes ? "LOG" : "LINEAR -- echte 0 gemessen, log kann 0 nicht tragen") << ".\n";
    if (!cnst.body_only) { f << "\\begin{figure}[" << cnst.position_hint << "]\n\\centering\n"; }
    open_resizebox(f, cnst);
    f << "\\begin{tikzpicture}\n";
    for (std::size_t i = 0; i < algos.size(); ++i) {
        double const hue =
            (algos.size() <= 1) ? 0.0 : (360.0 * static_cast<double>(i) / static_cast<double>(algos.size()));
        int r = 0, g = 0, b = 0;
        hsv_to_rgb(hue, 0.65, 0.85, r, g, b);
        f << "\\definecolor{tradeoff" << i << "}{RGB}{" << r << "," << g << "," << b << "}\n";
    }
    f << "\\definecolor{tradeoffdiag}{RGB}{120,120,120}\n";
    f << "\\begin{axis}[\n";
    write_pgfplots_axis_options(
        f, cnst, de ? "Pareto-Streuung: Median- gegen Tail-Latenz" : "Pareto scatter: median vs tail latency",
        de ? "Median-Latenz p50 (ns/op)" : "median latency p50 (ns/op)",
        de ? "Tail-Latenz p99 (ns/op)" : "tail latency p99 (ns/op)");
    if (log_axes) f << "    xmode=log,\n    ymode=log,\n";
    f << "    legend style={at={(1.03,1)},anchor=north west,font=\\tiny,legend cell align=left},\n";
    f << "    mark size=1.6pt,\n";
    f << "]\n";
    // Diagonale y=x ZUERST (liegt damit unter den Punkten). Sie spannt die tatsaechliche Wertespanne;
    // bei entarteter Spanne (ein einziger Wert) wird sie eine Dekade bzw. eine Einheit geweitet -- das
    // weitet NUR die Linie, kein Datenpunkt aendert sich.
    {
        double d_lo = lo;
        double d_hi = hi;
        if (!(d_hi > d_lo)) {
            if (log_axes && d_lo > 0.0) {
                d_hi = d_lo * 10.0;
            } else {
                d_hi = d_lo + 1.0;
            }
        }
        f << "% E-2c-DIAGONALE y=x: Referenz \"kein Tail-Aufschlag\". Punkte darueber zahlen Aufschlag.\n";
        f << "\\addplot[sharp plot,no marks,dashed,tradeoffdiag,forget plot] coordinates {(" << fmt_double(d_lo) << ","
          << fmt_double(d_lo) << ") (" << fmt_double(d_hi) << "," << fmt_double(d_hi) << ")};\n";
    }
    for (std::size_t i = 0; i < algos.size(); ++i) {
        f << "\\addplot[only marks,mark=*,color=tradeoff" << i << "] coordinates {";
        for (auto const& p : points) {
            if (p.algo != algos[i]) continue;
            f << "(" << fmt_double(p.p50_ns) << "," << fmt_double(p.p99_ns) << ")";
        }
        f << "};\n";
        f << "\\addlegendentry{" << escape_latex(algos[i]) << "}\n";
    }
    f << "\\end{axis}\n\\end{tikzpicture}\n";
    close_resizebox(f, cnst);
    if (!cnst.body_only) {
        f << "\\caption{"
          << escape_latex(de ? "Pareto-Streuung: Median- gegen Tail-Latenz (ein Punkt je Konfiguration und "
                               "Op-Art; Diagonale = kein Tail-Aufschlag)"
                             : "Pareto scatter: median vs tail latency (one point per configuration and "
                               "operation kind; diagonal = no tail surcharge)")
          << "}\n\\end{figure}\n";
    }
    return f.good() ? status_ok : status_io_error;
}

int write_normalized_bar_vs_reference(std::filesystem::path const& out, std::span<WideMeasurementRow const> rows,
                                      std::string const& z_field, std::string const& reference_algo,
                                      std::string const& lang, PageConstraints const& cnst) {
    if (rows.empty()) return status_empty_input;
    HeatmapData data;
    // WIEDERVERWENDUNG der P2-Aggregation: dieselbe Zwei-Operanden-Regel, dieselbe Ausfuehrungs-Wahrheit.
    // Es gibt bewusst KEINEN zweiten Rechenweg zum Verhaeltnis.
    if (!aggregate_surface_ratio_matrix(rows, z_field, reference_algo, data).axes_present) return status_empty_input;

    bool const have_mask = heatmap_mask_matches(data);
    // Je Zeile (search_algo) der Median ueber die GUELTIGEN lastprofil-weisen Verhaeltnisse. Eine Zeile
    // ohne einen einzigen gueltigen Wert wird AUSGELASSEN -- nicht auf 1.0 gesetzt (das behauptete
    // "genauso schnell wie die Referenz", also einen Befund, den es nicht gibt).
    std::vector<std::string> labels;
    std::vector<double>      values;
    for (std::size_t y = 0; y < data.matrix.size(); ++y) {
        std::vector<double> samples;
        for (std::size_t x = 0; x < data.matrix[y].size(); ++x) {
            if (!cell_displayable(data, have_mask, y, x)) continue;
            samples.push_back(data.matrix[y][x]);
        }
        if (samples.empty()) continue; // honest ausgelassen
        labels.push_back(data.y_labels[y]);
        values.push_back(nearest_rank_median(std::move(samples)));
    }
    if (labels.empty()) return status_empty_input; // ehrlich leer, KEINE Datei

    bool const        de     = (lang == "de");
    std::string const metric = z_field_human(z_field, lang);
    std::string const title = (de ? "Normalisiert zur Referenz " : "Normalised to reference ") + reference_algo + ": " +
                              metric + (de ? " (1 = wie die Referenz)" : " (1 = same as reference)");

    // E-2b-Praezedenz: ein Balken auf exakt 0 (Zaehler echt 0 gemessen) kann auf einer log-Achse weder
    // gezeigt noch ehrlich ersetzt werden -> dann LINEAR. Sonst log (Verhaeltnisse spannen Dekaden).
    bool have_zero_bar = false;
    for (double const v : values)
        if (v == 0.0) have_zero_bar = true;
    bool const y_log = !have_zero_bar;

    std::ofstream f{out};
    if (!f) return status_io_error;
    f << "% AUTO-GENERATED durch diagram_generator (P3a, baseline-normalisierte Balken; z=" << z_field
      << "; Referenz=" << reference_algo << "; lang=" << lang << ")\n";
    f << "% Balken = nearest-rank-Median der lastprofil-weisen Verhaeltnisse zur Referenz (NICHT das\n";
    f << "% Verhaeltnis zweier Roh-Mediane -- so zaehlt jedes Lastprofil gleich). Gruppen ohne ein\n";
    f << "% einziges gueltiges Verhaeltnis sind AUSGELASSEN, nicht auf 1.0 gesetzt.\n";
    if (!cnst.body_only) { f << "\\begin{figure}[" << cnst.position_hint << "]\n\\centering\n"; }
    open_resizebox(f, cnst);
    f << "\\begin{tikzpicture}\n";
    f << "\\definecolor{nbfaster}{RGB}{27,158,119}\n"; // unter 1 = schneller als die Referenz
    f << "\\definecolor{nbslower}{RGB}{215,48,39}\n";  // ueber 1 = langsamer als die Referenz
    f << "\\definecolor{nbref}{RGB}{120,120,120}\n";   // die Referenzlinie bei 1
    f << "\\begin{axis}[\n";
    f << "    ybar,\n";
    f << "    bar width=18pt,\n";
    write_pgfplots_axis_options(f, cnst, title, (de ? "Suchalgorithmus" : "search algorithm"),
                                (de ? "Verhaeltnis zur Referenz" : "ratio to reference"));
    if (y_log) f << "    ymode=log,\n";
    // RELATIVE Form zwingend: die abs-Form bricht auf symbolischen Achsen fatal ab (siehe die
    // ausfuehrliche Begruendung bei write_segment_attribution_stacked_bar).
    f << "    enlarge x limits=0.25,\n";
    f << "    symbolic x coords={";
    for (std::size_t i = 0; i < labels.size(); ++i) {
        if (i > 0) f << ",";
        f << escape_latex(labels[i]);
    }
    f << "},\n";
    f << "    xtick=data,\n";
    f << "    x tick label style={font=\\small},\n";
    f << "    legend style={at={(1.03,1)},anchor=north west,font=\\tiny,legend cell align=left},\n";
    f << "]\n";
    // ZWEI Serien (schneller / langsamer) auf DENSELBEN x-Positionen: bar shift=0pt verhindert das
    // sonst uebliche Nebeneinanderstellen. Jede Gruppe erscheint dadurch genau EINMAL, in der Farbe
    // ihrer Seite. Balken exakt auf 1 zaehlen zur "nicht langsamer"-Seite (Gleichheit ist keine
    // Regression) -- die Referenzlinie darunter macht den Fall ohnehin ablesbar.
    for (int side = 0; side < 2; ++side) {
        bool const slower = (side == 1);
        // Eine Seite OHNE Balken wird gar nicht erst emittiert. Ein leerer \addplot erzeugt sonst die
        // pgfplots-Warnung "the current plot has no coordinates" (pdflatex-Probe 2026-08-06) und die
        // Legende behauptete eine Klasse, die die Daten nicht tragen. Die Farbzuordnung leidet nicht
        // darunter, weil beide Serien ihre Farbe EXPLIZIT setzen (fill=nbfaster/nbslower).
        bool any = false;
        for (std::size_t i = 0; i < labels.size(); ++i)
            if ((values[i] > 1.0) == slower) any = true;
        if (!any) continue;
        f << "\\addplot[ybar, bar shift=0pt, fill=" << (slower ? "nbslower" : "nbfaster")
          << ", draw=black!45, very thin] coordinates {";
        for (std::size_t i = 0; i < labels.size(); ++i) {
            if ((values[i] > 1.0) != slower) continue;
            f << "(" << escape_latex(labels[i]) << "," << fmt_double(values[i]) << ")";
        }
        f << "};\n";
        f << "\\addlegendentry{"
          << (slower ? (de ? "langsamer als die Referenz" : "slower than reference")
                     : (de ? "schneller/gleich" : "faster or equal"))
          << "}\n";
    }
    // Referenzlinie bei 1 ueber die volle Breite der symbolischen Achse.
    // MECHANIK (pdflatex-Probe 2026-08-06): ein \draw mit dem |--Operator ist hier NICHT moeglich --
    // pgfplots bricht auf einer symbolischen Achse fatal ab ("coord trafo unsupported" +
    // "the input coordinate \pgfmathresult has not been defined with symbolic x coords"), weil |- eine
    // Koordinaten-Transformation erzwingt, die symbolische Achsen nicht anbieten. Der tragfaehige Weg
    // ist ein \addplot mit den beiden aeusseren SYMBOLISCHEN x-Werten. sharp plot hebt das
    // axis-weite ybar fuer genau diese Linie auf, forget plot haelt sie aus der Legende.
    f << "% P3a-REFERENZLINIE: y=1 ist die Referenz selbst (Verhaeltnis 1 = gleich schnell).\n";
    f << "\\addplot[sharp plot,no marks,dashed,nbref,thick,forget plot] coordinates {(" << escape_latex(labels.front())
      << ",1) (" << escape_latex(labels.back()) << ",1)};\n";
    f << "\\end{axis}\n\\end{tikzpicture}\n";
    close_resizebox(f, cnst);
    if (!cnst.body_only) { f << "\\caption{" << escape_latex(title) << "}\n\\end{figure}\n"; }
    return f.good() ? status_ok : status_io_error;
}

int write_surface3d_search_algo_x_workload(std::filesystem::path const& out, std::span<WideMeasurementRow const> rows,
                                           std::string const& z_field, std::string const& lang,
                                           PageConstraints const& cnst) {
    if (rows.empty()) return status_empty_input;
    HeatmapData data;
    auto const  agg = aggregate_surface_matrix(rows, z_field, data);
    if (!agg.axes_present) return status_empty_input;

    bool const        de     = (lang == "de");
    std::string const metric = z_field_human(z_field, lang);
    // P1a: EIN Titel fuer Achsen-Beschriftung, Platzhalter und Caption (vorher blieb data.title leer ->
    // leere \caption{}; fiel nicht auf, weil der Writer bis P1a nicht in der Facade verdrahtet war).
    data.title = surface3d_title(metric, de);

    // E-2a/HONEST-EMPTY: dieselbe Wache wie im 2D-Pfad -- keine einzige ausgefuehrte Zelle -> ehrlicher
    // Platzhalter statt Figur. E-2b: any_data zaehlt jetzt AUCH ausgefuehrte Nullen als Daten, der
    // Platzhalter greift also nur noch bei wirklich nie ausgefuehrter Metrik (ein Ort, ein Muster wie 2D).
    if (!agg.any_data) {
        std::cerr << "diagram-generator: HONEST-EMPTY -- keine ausgefuehrte Messung fuer z=" << z_field
                  << " -> Platzhalter-Vermerk statt 3D-Surface: " << out.string() << "\n";
        return write_honest_empty_placeholder(
            out, data.title,
            de ? ("(Keine Messwerte: " + metric +
                  " wurde im vorliegenden Korpus nie ausgefuehrt. Diese Flaeche wird ehrlich ausgelassen.)")
               : ("(No measured values: " + metric +
                  " was never executed in the present corpus. This surface is honestly omitted.)"),
            cnst);
    }

    std::ofstream f{out};
    if (!f) return status_io_error;

    std::size_t const nx = data.matrix[0].size();
    std::size_t const ny = data.matrix.size();

    // E-2b/DARSTELLBAR-Wache des 3D-Pfades -- WORTGLEICH zur 2D-Wache (die Maske kommt aus derselben
    // Aggregation). Vorher urteilte der 3D-Pfad allein ueber "z > 0" und hob JEDE andere Zelle auf einen
    // Phantom-Vertex 1.0e-3, sobald irgendeine Zelle positiv war -- inkonsistent zu 2D und still erfunden.
    bool const have_mask = heatmap_mask_matches(data);
    double     val_min   = 0.0;
    double     val_max   = 0.0;
    bool       have_val  = false;
    bool       have_zero = false;
    for (std::size_t y = 0; y < ny; ++y) {
        for (std::size_t x = 0; x < data.matrix[y].size(); ++x) {
            if (!cell_displayable(data, have_mask, y, x)) continue;
            double const v = data.matrix[y][x];
            if (v == 0.0) have_zero = true;
            if (!have_val) {
                val_min  = v;
                val_max  = v;
                have_val = true;
            } else {
                val_min = std::min(val_min, v);
                val_max = std::max(val_max, v);
            }
        }
    }
    // E-2b/Z-ACHSEN-MODUS. Der log-z-Boden ist der Grund, warum hier frueher ein Phantom entstand: eine
    // log-Achse kann WEDER ein Loch NOCH die 0 tragen. Die dokumentierte kleinste ehrliche Alternative:
    //   - ohne echte 0  -> zmode=log (Bestand; die ~14000x-Workload-Spanne braucht die Log-Hoehe),
    //   - mit echter 0  -> LINEARE z-Achse. Nur so ist die gemessene 0 ein ECHTER Vertex bei z=0 statt
    //                      erfunden (1.0e-3) oder verschwiegen (auf der Log-Achse wird sie zum Loch).
    // pdflatex-Probe 2026-08-06: linear + 0.0000 + nan-Loch -> RC=0, 0 Warnungen; log + 0.0000 -> die 0
    // faellt still als unbounded coordinate heraus (waere ein verschwiegener Messwert).
    bool const z_log = !have_zero;
    f << "% AUTO-GENERATED durch diagram_generator (L-c, echte-3D-Surface, z "
      << (z_log ? "log-skaliert" : "LINEAR -- echte 0 gemessen, log kann 0 nicht tragen") << ")\n";
    if (!cnst.body_only) {
        f << "\\begin{figure}[" << cnst.position_hint << "]\n";
        f << "\\centering\n";
    }
    open_resizebox(f, cnst);
    f << "\\begin{tikzpicture}\n";
    f << "\\begin{axis}[\n";
    write_pgfplots_axis_options(f, cnst, data.title, (de ? "Workload" : "workload"),
                                (de ? "Suchalgorithmus" : "search algorithm"));
    // Echte 3D-Projektion + surf-Plot. z LOG-skaliert: Workload-Spanne ~14000×,
    // sonst dominiert eine Zelle die Höhen-Achse vollständig.
    f << "    view={45}{30},\n";
    if (z_log) f << "    zmode=log,\n"; // E-2b: entfaellt genau dann, wenn eine echte 0 zu tragen ist
    // E-2b/AUSLASS-STRATEGIE des 3D-Pfades. "unbounded coords=jump" ist der EINE Kanal, mit dem surf ein
    // Loch traegt (Gegenprobe 2026-08-06: ohne die Option wird die nan-Koordinate VERWORFEN -- "has been
    // dropped" -- und pgfplots bricht anschliessend fatal im z-buffer-Reordering ab, RC=1, kein PDF).
    // Mit ihr: RC=0, 0 Warnungen, die Nachbar-Patches der Luecke entfallen ehrlich. Damit gilt jetzt in
    // 2D UND 3D dieselbe Regel: nicht ausgefuehrt = ausgelassen, NIE ein stiller Ersatzwert.
    f << "    unbounded coords=jump,\n";
    f << "    colorbar,\n";
    f << "    colormap/viridis,\n";
    f << "    zlabel={" << escape_latex(metric) << "},\n";
    f << "    xtick={0,1,...," << (nx - 1) << "},\n";
    f << "    ytick={0,1,...," << (ny - 1) << "},\n";
    if (!data.x_labels.empty()) {
        f << "    xticklabels={";
        for (std::size_t i = 0; i < data.x_labels.size(); ++i) {
            if (i > 0) f << ",";
            f << escape_latex(data.x_labels[i]);
        }
        f << "},\n";
        f << "    x tick label style={rotate=45,anchor=east,font=\\tiny},\n";
    }
    if (!data.y_labels.empty()) {
        f << "    yticklabels={";
        for (std::size_t i = 0; i < data.y_labels.size(); ++i) {
            if (i > 0) f << ",";
            f << escape_latex(data.y_labels[i]);
        }
        f << "},\n";
        f << "    y tick label style={font=\\tiny},\n";
    }
    f << "    mesh/cols=" << nx << ",\n";
    // E-2b: x/y-Grenzen explizit auf das VOLLE Index-Gitter. Loecher zaehlen fuer pgfplots nicht mehr zur
    // Datenspanne -- faellt eine ganze Rand-Spalte/-Zeile aus (realer Fall: eine Op laeuft nur in einem
    // Workload), schrumpfte die Achse sonst auf die Rest-Punkte und die Tick-Beschriftung stuende an der
    // falschen Stelle (Probe: "Axis range for axis x is approximately empty"). +-0.5 = die Zell-Ausdehnung
    // des Index-Gitters, also genau die Flaeche, die die Labels beschriften.
    f << "    xmin=" << fmt_double(-0.5) << ", xmax=" << fmt_double(static_cast<double>(nx) - 0.5) << ",\n";
    f << "    ymin=" << fmt_double(-0.5) << ", ymax=" << fmt_double(static_cast<double>(ny) - 0.5) << ",\n";
    // E-2b/ENTARTUNGS-WACHE: traegt die Flaeche nur EINEN verschiedenen Wert (Ein-Zell-Matrix oder lauter
    // gleiche Werte -- insbesondere lauter echte Nullen), kollabieren z- UND Farb-Domaene. Gegenprobe
    // 2026-08-06: pgfplots bricht dann fatal ab ("Error using 'plot graphics': I got too few
    // coordinates"), exakt die D-03-Wurzel. Deshalb hier eine EXPLIZITE, aufgeweitete Domaene:
    // log -> eine Dekade ueber dem Wert; linear (nur bei echter 0, also Wert==0) -> [0:1]. Das weitet
    // ausschliesslich die ACHSE, kein Datum wird veraendert oder erfunden. have_val ist hier immer wahr
    // (die voll datenlose Flaeche ist oben als Platzhalter abgegangen) -- die Bedingung haelt die Wache
    // trotzdem praezise: ohne einen einzigen Wert gibt es nichts aufzuweiten.
    if (have_val && !(val_max > val_min)) {
        double const lo = z_log ? val_min : 0.0;
        double const hi = z_log ? val_min * 10.0 : 1.0;
        f << "    point meta min=" << fmt_double(lo) << ", point meta max=" << fmt_double(hi) << ",\n";
        f << "    zmin=" << fmt_double(lo) << ", zmax=" << fmt_double(hi) << ",\n";
    }
    f << "]\n";
    // E-2b: GENAU ZWEI Vertex-Klassen (der Phantom-Boden 1.0e-3 ist getilgt):
    //   ausgefuehrt      -> "%.4f" des Messwertes (auch die echte 0 als "0.0000", lineare z-Achse),
    //   nicht ausgefuehrt-> "nan" = Loch (unbounded coords=jump), KEIN Ersatzwert.
    f << "% HONEST-EMPTY: z=nan = Zelle NICHT gemessen -> Loch im Mesh (unbounded coords=jump), KEIN\n";
    f << "% Ersatzwert. Echte Messwerte stehen mit 4 Nachkommastellen -- auch die gemessene 0.0000.\n";
    f << "\\addplot3[surf] coordinates {\n";
    for (std::size_t y = 0; y < ny; ++y) {
        for (std::size_t x = 0; x < nx; ++x) {
            bool const has = cell_displayable(data, have_mask, y, x);
            f << "    (" << x << "," << y << "," << (has ? fmt_double(data.matrix[y][x]) : std::string{"nan"}) << ")\n";
        }
        f << "\n"; // Leerzeile → neue mesh-Zeile (pgfplots surf-Konvention).
    }
    f << "};\n";
    f << "\\end{axis}\n";
    f << "\\end{tikzpicture}\n";
    close_resizebox(f, cnst);
    if (!cnst.body_only) {
        f << "\\caption{" << escape_latex(data.title) << "}\n";
        f << "\\end{figure}\n";
    }
    return f.good() ? status_ok : status_io_error;
}

// ─────────────────────────────────────────────────────────────────────────────
// A2 / m3v2 (2026-06-20) — Working-Set-Sweep-Kurve (Metrik über working_set_n)
// ─────────────────────────────────────────────────────────────────────────────
//
// Aufgabe-A2-Mapping (GOAL Phase L L3): eine Kurve je Reihe = Metrik (z-Feld) aufgetragen über
// working_set_n. Reihen-Schlüssel = die gesweepte Achsen-Ausprägung, header-getrieben gewählt:
//   sweep_axis != "-"  → Reihe = der Achsenwert dieser Achse in der binary_id (z.B. migration_none).
//   sonst              → Reihe = search_algo (oder binary_id-Kopf), eine Kurve je Lebewesen.
// HEADER-GETRIEBEN/n/a-tolerant: hat die CSV keine working_set_n-Spalte (cowfix-v1), gibt es keine
// Punkte → status_empty_input (ehrlich leer, KEIN Crash). Hat der Pilot nur EINEN working_set_n-Wert,
// entsteht eine 1-Punkt-Kurve (mark-only) — das ist der ehrliche Mess-Stand, nicht erzwungen.

namespace {

// Die gesweepte Achse aus der binary_id extrahieren (token "sweep_axis=wert" via parse), sonst search_algo.
[[nodiscard]] std::string sweep_series_key(WideMeasurementRow const& r) {
    if (!r.sweep_axis.empty() && r.sweep_axis != "-") {
        // Achsenwert dieser Achse in der binary_id suchen: "<sweep_axis>=<wert>/".
        std::string const needle = r.sweep_axis + "=";
        std::size_t const p      = r.binary_id.find(needle);
        if (p != std::string::npos) {
            std::size_t const start = p + needle.size();
            std::size_t const slash = r.binary_id.find('/', start);
            return r.binary_id.substr(start, (slash == std::string::npos ? r.binary_id.size() : slash) - start);
        }
    }
    if (!r.search_algo.empty()) return r.search_algo;
    return r.binary_id;
}

} // anonymous namespace

int write_working_set_sweep_curve(std::filesystem::path const& out, std::span<WideMeasurementRow const> rows,
                                  std::string const& z_field, std::string const& lang, PageConstraints const& cnst) {
    if (rows.empty()) return status_empty_input;
    bool const de      = (lang == "de");
    bool const is_scan = (z_field == "op_scan_p50_ns");

    // (Reihe → (working_set_n → Stichprobe des z-Feldes)); NUR two_phase_valid + working_set_n vorhanden.
    std::map<std::string, std::map<std::uint64_t, std::vector<double>>> series;
    bool                                                                any_ws_row = false; // s. F-4/D
    for (auto const& r : rows) {
        if (!r.two_phase_valid) continue;
        if (!r.has_working_set_n) continue; // header-getrieben: fehlt die Spalte → kein Punkt (n/a)
        if (is_scan && (r.workload == "ycsb_e" || r.workload == "lp_range_scan")) continue;
        any_ws_row = true;
        // F-4/D (2026-09-16) -- PHANTOM-WACHE. Eine Zeile darf nur dann einen Stuetzpunkt stellen, wenn die
        // Operation des z-Feldes in dieser Konfiguration UEBERHAUPT AUSGEFUEHRT wurde. Das Muster ist im
        // Modul seit E-2a etabliert (z_field_executed, "nicht gelaufen" != "0 ns") und wird in
        // aggregate_surface_matrix bereits benutzt -- HIER fehlte es. Folge am Objekt (Owner-Log 13.09.,
        // anhang/de/tabellen/ld_sweep_op_insert_p50_ns.tex): der ycsb_c-Korpus fuehrt op_insert_n=0, die
        // Kurve zeigte trotzdem (4096, 0.0000) und die y-Achse meldete "[0.0:0.0] approximately empty".
        // Das war nicht bloss eine leere Achse, sondern eine ERFUNDENE 0-ns-Messung in der Diplomarbeit.
        if (!z_field_executed(r, z_field)) continue;
        series[sweep_series_key(r)][r.working_set_n].push_back(pick_z_field(r, z_field));
    }
    std::string const metric = z_field_human(z_field, lang);

    if (series.empty()) {
        // BESTANDSFALL (P1b-t1): gar keine Zeile mit working_set_n -> ehrlich leer, KEINE Datei. Der
        // Anhang haengt an \InputIfFileExists und druckt dort seinen eigenen, zutreffenden Vermerk
        // ("wartet auf eine Messreihe mit working_set_n-Spalte").
        if (!any_ws_row) return status_empty_input;
        // F-4/D: working_set_n IST da, aber die Operation des z-Feldes wurde in KEINER gueltigen
        // Konfiguration ausgefuehrt. Hier waere "keine Datei" IRREFUEHREND -- der Anhang-Fallback nennt
        // dann die fehlende Spalte als Grund, und die ist vorhanden. Deshalb der ehrliche Vermerk statt
        // einer Figur: exakt das E-2a-HONEST-EMPTY-Muster der Flaechen-Writer.
        std::cerr << "diagram-generator: HONEST-EMPTY -- z=" << z_field
                  << " nie ausgefuehrt, Sweep-Kurve ausgelassen (lang=" << lang << ")\n";
        std::string head;
        head += "% AUTO-GENERATED durch diagram_generator (HONEST-EMPTY: Sweep-Metrik nie ausgefuehrt)\n";
        head += "% Die Arbeitsmengen-Spalte working_set_n IST vorhanden, aber die Operation dieses\n";
        head += "% z-Feldes wurde in KEINER gueltigen Konfiguration ausgefuehrt (op_<art>_n == 0). Eine\n";
        head += "% Kurve daraus waere eine erfundene 0-ns-Messung -- daher ehrlicher Vermerk statt Figur.\n";
        return write_honest_empty_placeholder(
            out, (de ? "Working-Set-Sweep: " : "working-set sweep: ") + metric,
            (de ? "(Keine Messwerte: die Operation dieser Metrik wurde im vorliegenden Korpus nie "
                  "ausgefuehrt. Die Kurve wird ehrlich ausgelassen, statt eine 0-ns-Messung zu zeigen.)"
                : "(No measured values: the operation of this metric was never executed in the present "
                  "corpus. The curve is honestly omitted instead of showing an invented zero.)"),
            cnst, head);
    }

    // P1b (2026-08-06) -- ENTARTUNGS-WACHE der x-Achse, aufgedeckt erst durch die Verdrahtung in die
    // Facade. Der d03-Korpus sweept working_set_n gar nicht: ALLE Zeilen tragen denselben Wert (4096),
    // die Kurve ist also ehrlich EIN Punkt je Reihe. pgfplots-Probe 2026-08-06 an genau dieser .tex:
    // "Package pgfplots Warning: Axis range for axis x is approximately empty; enlargi[ng]" -- die
    // Log-Achse bekommt xmin==xmax und weitet selbst auf einen willkuerlichen Bereich auf.
    // Kleinste ehrliche Gegenmassnahme (Praezedenz: die z-/Farb-Domaenen-Aufweitung im 3D-Pfad, E-2b):
    // NUR die ACHSE explizit auf eine Oktave um den einen Wert setzen -- log basis 2, also [v/2 : 2v].
    // Es wird KEIN Punkt erfunden und kein Wert veraendert; die Kurve bleibt sichtbar der eine
    // gemessene Stuetzpunkt. Erst ein echter Sweep-Korpus (mehrere working_set_n) fuellt sie.
    std::set<std::uint64_t> distinct_x;
    for (auto const& [key, points] : series)
        for (auto const& [wsn, samples] : points) distinct_x.insert(wsn);
    bool const          degenerate_x = (distinct_x.size() == 1 && *distinct_x.begin() > 0);
    std::uint64_t const only_x       = degenerate_x ? *distinct_x.begin() : 0;

    // F-4/A (2026-09-16) -- die SCHWESTER-WACHE zu P1b, diesmal fuer y. P1b heilte 2026-08-06 NUR die
    // x-Achse; der Owner-Log vom 13.09. zeigt dieselbe Meldung auf y: "Axis range for axis y is
    // approximately empty" in ld_sweep_ns_per_op ([671.532:671.532]) und ld_sweep_op_lookup_p50_ns
    // ([750.0:750.0]). Ursache ist dieselbe wie bei x: bei EINEM Messpunkt ist ymin==ymax, und das von
    // write_pgfplots_axis_options gesetzte enlargelimits=0.05 ist RELATIV (0.05 * 0 == 0), weitet also
    // nichts. Gegenmassnahme wie bei P1b: NUR die ACHSE explizit setzen, KEIN Punkt erfunden. y ist hier
    // linear (kein ymode=log), darum nullpunktverankert [0 : 2*y] statt der x-Oktave [v/2 : 2v].
    // Die Mediane werden EINMAL hier berechnet und unten wiederverwendet (kein zweiter Durchlauf).
    std::map<std::string, std::map<std::uint64_t, double>> medians;
    std::set<double>                                       distinct_y;
    for (auto const& [key, points] : series)
        for (auto const& [wsn, samples] : points) {
            double const med  = nearest_rank_median(samples);
            medians[key][wsn] = med;
            distinct_y.insert(med);
        }
    bool const   degenerate_y = (distinct_y.size() == 1);
    double const only_y       = degenerate_y ? *distinct_y.begin() : 0.0;

    std::ofstream f{out};
    if (!f) return status_io_error;
    f << "% AUTO-GENERATED durch diagram_generator (A2/m3v2, Working-Set-Sweep-Kurve; z=" << z_field
      << "; lang=" << lang << ")\n";
    f << "% Eine Kurve je gesweepter Achsen-Auspraegung; X=working_set_n (log2), Y=" << z_field
      << " (nearest-rank-Median, nur two_phase_valid).\n";
    if (!cnst.body_only) { f << "\\begin{figure}[" << cnst.position_hint << "]\n\\centering\n"; }
    open_resizebox(f, cnst);
    f << "\\begin{tikzpicture}\n\\begin{axis}[\n";
    // P1b (2026-08-06)/BESCHRIFTUNGS-FIX, ebenfalls erst durch die Verdrahtung sichtbar geworden:
    // write_pgfplots_axis_options schickt JEDE Beschriftung durch escape_latex. Die bisherigen Labels
    // enthielten Mathe-Modus und eine LaTeX-Umlaut-Sequenz und wurden dadurch buchstaeblich zerlegt --
    // pdflatex-Probe an der erzeugten .tex: "xlabel={Arbeitsmenge \$n\$ (Schl\textbackslash{}"ussel)}",
    // also literal sichtbare Dollarzeichen und ein sichtbares \"ussel statt eines Umlauts. Beschriftungen
    // muessen hier deshalb REINER ASCII-TEXT ohne LaTeX-Syntax sein (Doktrin ASCII-only); die
    // Escape-Verantwortung liegt allein bei write_pgfplots_axis_options.
    write_pgfplots_axis_options(f, cnst, (de ? "Working-Set-Sweep: " : "working-set sweep: ") + metric,
                                (de ? "Arbeitsmenge n (Schluessel)" : "working set n (keys)"), metric);
    f << "    xmode=log,\n    log basis x=2,\n";
    if (degenerate_x) {
        f << "    % P1b: nur EIN gemessener working_set_n -> Achse explizit auf eine Oktave geweitet\n";
        f << "    % (sonst xmin==xmax -> \"Axis range for axis x is approximately empty\"). Nur die ACHSE.\n";
        f << "    xmin=" << fmt_double(static_cast<double>(only_x) / 2.0)
          << ", xmax=" << fmt_double(static_cast<double>(only_x) * 2.0) << ",\n";
    }
    if (degenerate_y) {
        f << "    % F-4: nur EIN gemessener Stuetzpunkt dieser Metrik -> y-Achse explizit gesetzt\n";
        f << "    % (sonst ymin==ymax -> \"Axis range for axis y is approximately empty\"). Nur die ACHSE.\n";
        // y0 == 0 waere eine ECHT gemessene Null (der Nicht-Ausfuehrungs-Fall ist oben schon weg); auch
        // dann braucht die Achse ein nicht-entartetes Fenster, darum [0 : 1] statt [0 : 0].
        f << "    ymin=0, ymax=" << fmt_double(only_y > 0.0 ? only_y * 2.0 : 1.0) << ",\n";
    }
    f << "    legend pos=north west,\n    legend style={font=\\tiny},\n";
    f << "    mark size=2pt,\n";
    f << "]\n";
    for (auto const& [key, points] : medians) {
        f << "\\addplot+[mark=*] coordinates {\n";
        for (auto const& [wsn, med] : points) { f << "    (" << wsn << "," << fmt_double(med) << ")\n"; }
        f << "};\n";
        // F-4: Hinweis NUR im entarteten Fall (genau EIN Stuetzpunkt). Der Leser sieht sonst einen
        // einzelnen Punkt und haelt ihn fuer eine Kurve.
        // M-1 (2026-09-16, Lens r1): der Hinweis darf das Symbol n NICHT benutzen. Diese Figur traegt
        // "Arbeitsmenge n (Schluessel)" / "working set n (keys)" als x-Achse, und der einzige Punkt liegt
        // bei n=4096 -- ein Legenden-Zusatz "(n=1)" liest sich dort als Arbeitsmenge 1 und behauptet damit
        // eine Messung, die es nicht gibt. (Die Form stammte aus write_latency_ecdf "(N=...)"; dort gibt es
        // keine n-Achse, weshalb sie DORT eindeutig bleibt und unveraendert steht.) Stattdessen benennt der
        // Zusatz die Stichprobenzahl in Worten, sprachabhaengig.
        std::string const single_point_hint = de ? " (1 Messpunkt)" : " (1 sample)";
        f << "\\addlegendentry{" << escape_latex(key) << (points.size() == 1 ? single_point_hint : std::string{})
          << "}\n";
    }
    f << "\\end{axis}\n\\end{tikzpicture}\n";
    close_resizebox(f, cnst);
    if (!cnst.body_only) {
        f << "\\caption{" << escape_latex((de ? "Working-Set-Sweep: " : "working-set sweep: ") + metric)
          << "}\n\\end{figure}\n";
    }
    return f.good() ? status_ok : status_io_error;
}

// ─────────────────────────────────────────────────────────────────────────────
// P4 (2026-07-12) — Per-Achsen-Latenz-Attribution als GESTAPELTE Balken
// ─────────────────────────────────────────────────────────────────────────────
//
// KERN-SEMANTIK (erforscht+an echten Daten verifiziert): die kSegmentCount Stapel-Segmente sind kommensurabel
// mit seg_run_total_ns (dem eigenen Wall-Clock des Segment-Laufs run_workload_segmented), NICHT mit total_ns
// (Real-Workload → 3–29× daneben). Beleg cache_engine_builder_iterator.hpp:248-257,395-401:
// Summe(Organ-seg + seg_framework_ns) == seg_run_total_ns EXAKT (seg_coverage ~ 1.0). Daher ist das
// 100%-Ganze je Balken = seg_run_total_ns; gegen total_ns zu stapeln wäre PHANTOM (verboten).

SegmentAttribution aggregate_segment_attribution(std::span<WideMeasurementRow const> rows) {
    SegmentAttribution agg;
    agg.segment_labels.reserve(WideMeasurementRow::kSegmentCount);
    for (auto const col : kSegmentColumns) agg.segment_labels.push_back(segment_label(col));

    // Akkumulator je search_algo. std::map → deterministisch sortierte Balken-Reihenfolge.
    struct Acc {
        std::array<double, WideMeasurementRow::kSegmentCount> sum{};
        double                                                run_total_sum = 0.0;
        double                                                cov_sum       = 0.0;
        std::size_t                                           n             = 0;
    };
    std::map<std::string, Acc> groups;
    for (auto const& r : rows) {
        // Guard/Filter (honest überspringen, NICHT 0-stapeln):
        if (!r.two_phase_valid) continue;                                  // Mess-Gültigkeit
        if (r.search_algo.empty()) continue;                               // ohne Gruppen-Schlüssel nicht zuordenbar
        if (!r.has_seg_ns) continue;                                       // eine seg_*_ns-Spalte n/a → Zeile invalide
        if (!r.has_seg_run_total || !(r.seg_run_total_ns > 0.0)) continue; // seg_run_total_ns<=0/n/a → Guard
        if (!r.has_seg_coverage) continue;                                 // seg_coverage n/a → Guard
        auto& a = groups[r.search_algo];
        for (std::size_t s = 0; s < WideMeasurementRow::kSegmentCount; ++s) a.sum[s] += r.seg_ns[s];
        a.run_total_sum += r.seg_run_total_ns;
        a.cov_sum += r.seg_coverage;
        ++a.n;
    }
    if (groups.empty()) return agg; // keine gültige Segment-Zeile → groups leer (Aufrufer: status_empty_input)

    agg.means.assign(WideMeasurementRow::kSegmentCount, {});
    for (auto& seg : agg.means) seg.reserve(groups.size());
    agg.groups.reserve(groups.size());
    agg.group_totals.reserve(groups.size());
    agg.run_total_means.reserve(groups.size());
    agg.coverage_means.reserve(groups.size());
    for (auto const& [key, a] : groups) {
        agg.groups.push_back(key);
        double const inv   = 1.0 / static_cast<double>(a.n);
        double       total = 0.0;
        for (std::size_t s = 0; s < WideMeasurementRow::kSegmentCount; ++s) {
            double const m = a.sum[s] * inv;
            agg.means[s].push_back(m);
            total += m;
        }
        agg.group_totals.push_back(total); // == Mittel seg_run_total_ns (Σ aller seg je Zeile = seg_run_total)
        agg.run_total_means.push_back(a.run_total_sum * inv);
        agg.coverage_means.push_back(a.cov_sum * inv);
    }
    return agg;
}

namespace {

// Deterministische kategoriale Palette: kSegmentCount Farben aus dem HSV-Farbkreis (gleichmäßig verteilter Hue,
// S=0.62). Selbst-enthaltend (KEIN colorbrewer-/xcolor-Zusatzpaket → F-EXTRA-5-konform). Der Wert V
// alterniert 0.90/0.70 je Index → benachbarte Stapel-Schichten trennen sich zusätzlich in der Helligkeit
// (kleine Segmente bleiben lesbar; zusätzlich zeichnet jeder Balken einen dünnen Rand).
void hsv_to_rgb(double h, double s, double v, int& r_out, int& g_out, int& b_out) {
    double const c  = v * s;
    double const hp = h / 60.0;
    double const x  = c * (1.0 - std::fabs(std::fmod(hp, 2.0) - 1.0));
    double       r = 0.0, g = 0.0, b = 0.0;
    if (hp < 1.0) {
        r = c;
        g = x;
    } else if (hp < 2.0) {
        r = x;
        g = c;
    } else if (hp < 3.0) {
        g = c;
        b = x;
    } else if (hp < 4.0) {
        g = x;
        b = c;
    } else if (hp < 5.0) {
        r = x;
        b = c;
    } else {
        r = c;
        b = x;
    }
    double const m = v - c;
    r_out          = static_cast<int>(std::lround((r + m) * 255.0));
    g_out          = static_cast<int>(std::lround((g + m) * 255.0));
    b_out          = static_cast<int>(std::lround((b + m) * 255.0));
}

} // anonymous namespace

int write_segment_attribution_stacked_bar(std::filesystem::path const& out, std::span<WideMeasurementRow const> rows,
                                          std::string const& lang, PageConstraints const& cnst) {
    if (rows.empty()) return status_empty_input;
    SegmentAttribution const agg = aggregate_segment_attribution(rows);
    if (agg.groups.empty()) return status_empty_input; // keine gültige Segment-Zeile → ehrlich leer, KEIN leerer Balken

    bool const de = (lang == "de");

    std::ofstream f{out};
    if (!f) return status_io_error;

    std::string const title = de ? "Gestapelte Per-Achsen-Latenz-Attribution" : "stacked per-axis latency attribution";
    std::string const xlab  = de ? "Suchalgorithmus" : "search algorithm";
    std::string const ylab  = de ? "Latenz-Attribution je Achse (ns, Segment-Lauf-Wall-Clock)"
                                 : "per-axis latency attribution (ns, segment run)";

    f << "% AUTO-GENERATED durch diagram_generator (P4, Per-Achsen-Latenz-Attribution, ybar stacked)\n";
    f << "% Ganzes je Balken = seg_run_total_ns (Wall-Clock des Segment-Laufs), NICHT total_ns (inkommensurabel,\n";
    f << "% 3-29x daneben). Σ der " << WideMeasurementRow::kSegmentCount
      << " Segmente == seg_run_total_ns (seg_coverage~1). " << (WideMeasurementRow::kSegmentCount - 1)
      << " Organ-Achsen + framework.\n";
    if (!cnst.body_only) { f << "\\begin{figure}[" << cnst.position_hint << "]\n\\centering\n"; }
    open_resizebox(f, cnst);
    f << "\\begin{tikzpicture}\n";
    // kSegmentCount deterministische Kategorienfarben je Segment definieren (Stapel-Reihenfolge = kSegmentColumns).
    for (std::size_t s = 0; s < WideMeasurementRow::kSegmentCount; ++s) {
        double const hue = 360.0 * static_cast<double>(s) / static_cast<double>(WideMeasurementRow::kSegmentCount);
        double const val = (s % 2 == 0) ? 0.90 : 0.70;
        int          r = 0, g = 0, b = 0;
        hsv_to_rgb(hue, 0.62, val, r, g, b);
        f << "\\definecolor{segattr" << s << "}{RGB}{" << r << "," << g << "," << b << "}\n";
    }
    f << "\\begin{axis}[\n";
    f << "    ybar stacked,\n";
    f << "    bar width=22pt,\n";
    write_pgfplots_axis_options(f, cnst, title, xlab, ylab);
    f << "    ymin=0,\n";
    // P3a-BEIFANG (2026-08-06) -- BESTANDSFEHLER, gefunden durch die pdflatex-Probe des neuen
    // Balken-Writers: `enlarge x limits={abs=0.75}` bricht auf einer SYMBOLISCHEN x-Achse FATAL ab
    // ("Sorry, the input coordinate \pgfmathresult has not been defined with 'symbolic x coords'",
    // kein PDF -- reproduziert mit texlive 2026/pgfplots unter compat 1.16, 1.18 UND newest). Die
    // abs-Form verlangt eine numerische Achse; symbolische Achsen kennen nur die relative Form.
    // Diese Figur war damit seit ihrer Landung nicht kompilierbar -- unbemerkt, weil sie am
    // \InputIfFileExists haengt und der d03-Korpus sie erst jetzt mit Daten fuellt.
    // Die relative Form leistet dasselbe (Rand fuer wenige breite Balken) und ist symbolisch gueltig.
    // F-4/B (2026-09-16) -- ENTARTUNGS-WACHE der symbolischen x-Achse. pgfplots bildet symbolische
    // Koordinaten intern auf die Indizes 0,1,2,... ab; bei GENAU EINER Kategorie ist xmin==xmax==0, und
    // die relative Aufweitung enlarge x limits=0.25 bleibt wirkungslos (0.25 * 0 == 0) -> "Axis range
    // for axis x is approximately empty" (Owner-Log 13.09., seg_attribution.tex, [0.0:0.0], Zeile 86).
    // Die naheliegende abs-Form ist hier VERBOTEN -- sie bricht auf symbolischen Achsen FATAL ab (der
    // P3a-BEIFANG-Block direkt darueber; 2026-09-16 an TeX Live 2026 erneut nachgemessen). Deshalb im
    // EINER-Fall eine numerische Achse mit xtick/xticklabels und explizitem Fenster; ab zwei Kategorien
    // bleibt die symbolische Form und die Emission BYTE-IDENTISCH zum Bestand.
    bool const single_group = (agg.groups.size() == 1);
    if (single_group) {
        f << "    % F-4/B: EINE Kategorie -> numerischer Index statt symbolic x coords, Fenster explizit\n";
        f << "    xmin=-0.5, xmax=0.5,\n";
        f << "    xtick={0},\n";
        f << "    xticklabels={" << escape_latex(agg.groups[0]) << "},\n";
    } else {
        f << "    enlarge x limits=0.25,\n"; // symbolische x-Achse: Rand fuer wenige breite Balken
        f << "    symbolic x coords={";
        for (std::size_t i = 0; i < agg.groups.size(); ++i) {
            if (i > 0) f << ",";
            f << escape_latex(agg.groups[i]);
        }
        f << "},\n";
        f << "    xtick=data,\n";
    }
    f << "    x tick label style={font=\\small},\n";
    // Per-Segment-Legende (kSegmentCount Eintraege) AUSSERHALB rechts (tiny), damit sie den Plot nicht ueberdeckt.
    f << "    legend style={at={(1.03,1)},anchor=north west,font=\\tiny,legend cell align=left},\n";
    f << "    reverse legend,\n"; // Legende von oben (letztes Stapel-Segment) nach unten lesbar zum Balken passend
    f << "]\n";
    for (std::size_t s = 0; s < WideMeasurementRow::kSegmentCount; ++s) {
        f << "\\addplot[fill=segattr" << s << ",draw=black!45,very thin] coordinates {";
        for (std::size_t g = 0; g < agg.groups.size(); ++g) {
            // F-4/B: im Einer-Fall traegt die x-Achse numerische Indizes (s. oben), sonst die Symbole.
            f << "(" << (single_group ? std::to_string(g) : escape_latex(agg.groups[g])) << ","
              << fmt_double(agg.means[s][g]) << ")";
            if (g + 1 < agg.groups.size()) f << " ";
        }
        f << "};\n";
        f << "\\addlegendentry{" << escape_latex(agg.segment_labels[s]) << "}\n";
    }
    f << "\\end{axis}\n\\end{tikzpicture}\n";
    close_resizebox(f, cnst);
    if (!cnst.body_only) { f << "\\caption{" << escape_latex(title) << "}\n\\end{figure}\n"; }
    return f.good() ? status_ok : status_io_error;
}

// ─────────────────────────────────────────────────────────────────────────────
// P3 (2026-07-12) — Latenz-VERTEILUNG statt Mittelwert (Range-Balken + Config-ECDF)
// ─────────────────────────────────────────────────────────────────────────────
//
// EHRLICHKEIT (zwingend): das WIDE-Schema trägt je Permutation NUR aggregierte Perzentile (op_<art>_p50_ns /
// op_<art>_p99_ns), NICHT die rohen Einzel-Op-Latenzen. Daher NUR zwei ehrliche Verteilungs-Sichten:
//   (1) Range: Punkt=p50, Whisker→p99 (2 Perzentile → KEIN Box-Plot mit erfundenen Quartilen = Phantom).
//   (2) ECDF: Verteilung ÜBER die Konfigurationen (jede gültige Permutation = 1 ns_per_op-Punkt) — Config-
//       Streuung (Anteil der Configs mit Latenz ≤ x), NICHT eine Per-Operation-Latenz-CDF.

LatencyRangeAggregate aggregate_latency_range(std::span<WideMeasurementRow const> rows) {
    LatencyRangeAggregate agg;

    // Stichproben je (op-Index × search_algo): p50- und p99-Werte getrennt gesammelt.
    std::array<std::map<std::string, std::pair<std::vector<double>, std::vector<double>>>, kRangeOps.size()> per_op;
    std::set<std::string>                                                                                    algo_set;
    for (auto const& r : rows) {
        if (!r.two_phase_valid) continue;    // Mess-Gültigkeit
        if (r.search_algo.empty()) continue; // ohne Gruppen-Schlüssel nicht zuordenbar
        if (!r.has_op_p99) continue;         // Range braucht p99 (fehlt → Zeile honest ausgelassen, NICHT 0-Whisker)
        for (std::size_t oi = 0; oi < kRangeOps.size(); ++oi) {
            bool const is_scan = (kRangeOps[oi].display == "scan");
            // scan-No-Op-Ausschluss (ycsb_e / lp_range_scan) — konsistent zum Surface-Pfad.
            if (is_scan && (r.workload == "ycsb_e" || r.workload == "lp_range_scan")) continue;
            double const p50 = r.*(kRangeOps[oi].p50_mem);
            double const p99 = r.*(kRangeOps[oi].p99_mem);
            // 0 ns = Operation in dieser Config NICHT ausgeführt (keine Stichprobe) → NICHT als reale 0-Latenz
            // mitteln (Phantom-Falle: "nicht gelaufen" ≠ "0 ns"). Nur ausgeführte Ops (p50>0) zählen.
            if (!(p50 > 0.0)) continue;
            auto& cell = per_op[oi][r.search_algo];
            cell.first.push_back(p50);
            cell.second.push_back(p99);
            algo_set.insert(r.search_algo);
        }
    }
    if (algo_set.empty()) return agg; // keine gültige Zeile → algos leer (Aufrufer: status_empty_input)

    agg.algos.assign(algo_set.begin(), algo_set.end());
    // Nur op-Arten MIT Daten aufnehmen (feste Reihenfolge insert..rmw). Ehrlich: eine komplett ausgeschlossene
    // op-Art (z.B. scan, wenn nur No-Op-Profile vorliegen) erscheint NICHT als leere Zeile.
    for (std::size_t oi = 0; oi < kRangeOps.size(); ++oi) {
        if (per_op[oi].empty()) continue;
        agg.ops.emplace_back(kRangeOps[oi].display);
        std::vector<double>      p50_row(agg.algos.size(), 0.0);
        std::vector<double>      p99_row(agg.algos.size(), 0.0);
        std::vector<std::size_t> cnt_row(agg.algos.size(), 0);
        std::vector<bool>        pres_row(agg.algos.size(), false);
        for (std::size_t ai = 0; ai < agg.algos.size(); ++ai) {
            auto it = per_op[oi].find(agg.algos[ai]);
            if (it == per_op[oi].end()) continue;
            p50_row[ai]  = nearest_rank_median(it->second.first);
            p99_row[ai]  = nearest_rank_median(it->second.second);
            cnt_row[ai]  = it->second.first.size();
            pres_row[ai] = true;
        }
        agg.p50_median.push_back(std::move(p50_row));
        agg.p99_median.push_back(std::move(p99_row));
        agg.counts.push_back(std::move(cnt_row));
        agg.present.push_back(std::move(pres_row));
    }
    return agg;
}

int write_latency_range_bar(std::filesystem::path const& out, std::span<WideMeasurementRow const> rows,
                            std::string const& lang, PageConstraints const& cnst) {
    if (rows.empty()) return status_empty_input;
    LatencyRangeAggregate const agg = aggregate_latency_range(rows);
    if (agg.algos.empty() || agg.ops.empty()) return status_empty_input; // ehrlich leer, KEIN leerer Plot

    bool const de = (lang == "de");

    std::ofstream f{out};
    if (!f) return status_io_error;

    // WICHTIG: write_pgfplots_axis_options schickt title/xlabel/ylabel durch escape_latex → NUR reiner Text
    // (kein $...$, kein \times/\leq), sonst wird die Mathe literal escaped und als Text gerendert.
    std::string const title = de ? "Latenz-Spanne p50-p99 je Suchalgorithmus x Operation"
                                 : "latency spread p50-p99 per search algorithm x operation";
    std::string const xlab  = de ? "Suchalgorithmus x Operation" : "search algorithm x operation";
    std::string const ylab =
        de ? "Latenz (ns, log; Punkt=p50, Whisker bis p99)" : "latency (ns, log; point=p50, whisker to p99)";

    // Symbolische x-Koordinaten = die vorhandenen (algo/op)-Kombis, sortiert algo-primär, op-sekundär (feste
    // op-Reihenfolge). Kombi-Label "<algo>/<op>". Jede Kombi gehört zu genau EINER op-Art → keine Überlappung.
    std::vector<std::string> combos;
    for (std::size_t ai = 0; ai < agg.algos.size(); ++ai) {
        for (std::size_t oi = 0; oi < agg.ops.size(); ++oi) {
            if (agg.present[oi][ai]) combos.push_back(agg.algos[ai] + "/" + agg.ops[oi]);
        }
    }

    // Datenqualitäts-Zählung: p99<p50 (Whisker würde nach unten zeigen). Wird NICHT gecrasht, sondern der
    // plus-Whisker auf 0 geklemmt (Punkt sichtbar, keine negative Fehlerbalken-Länge) und hier gezählt/geloggt.
    bool const  single_combo = (combos.size() == 1); // F-4/B, s. Achsen-Block unten
    std::size_t inversions   = 0;
    for (std::size_t oi = 0; oi < agg.ops.size(); ++oi)
        for (std::size_t ai = 0; ai < agg.algos.size(); ++ai)
            if (agg.present[oi][ai] && agg.p99_median[oi][ai] < agg.p50_median[oi][ai]) ++inversions;

    f << "% AUTO-GENERATED durch diagram_generator (P3, Latenz-Verteilung: p50--p99-Spanne, Punkt+Whisker)\n";
    f << "% EHRLICH: das WIDE-Schema traegt NUR p50/p99 je Permutation, NICHT die rohen Einzel-Op-Latenzen.\n";
    f << "% Punkt = nearest-rank-Median der p50-Werte; plus-Whisker hoch bis Median der p99-Werte. KEIN Box-Plot\n";
    f << "% (nur 2 Perzentile -> Quartile waeren erfunden = Phantom). 1 addplot je op-Art (Farbe+Legende).\n";
    if (inversions > 0)
        f << "% DATENQUALITAET: " << inversions
          << " Zelle(n) mit p99<p50 (plus-Whisker auf 0 geklemmt, nicht gecrasht).\n";
    if (!cnst.body_only) { f << "\\begin{figure}[" << cnst.position_hint << "]\n\\centering\n"; }
    open_resizebox(f, cnst);
    f << "\\begin{tikzpicture}\n";
    // Deterministische Kategorienfarben je op-Art (bis zu 5), selbst-enthaltend (kein xcolor-Zusatzpaket).
    for (std::size_t oi = 0; oi < agg.ops.size(); ++oi) {
        double const hue = 360.0 * static_cast<double>(oi) / static_cast<double>(agg.ops.size());
        int          r = 0, g = 0, b = 0;
        hsv_to_rgb(hue, 0.62, 0.85, r, g, b);
        f << "\\definecolor{rangeop" << oi << "}{RGB}{" << r << "," << g << "," << b << "}\n";
    }
    f << "\\begin{axis}[\n";
    write_pgfplots_axis_options(f, cnst, title, xlab, ylab);
    f << "    ymode=log,\n"; // Latenz spannt Dekaden -> log-y (alle Werte >0)
    // F-4/B (2026-09-16) -- dieselbe Entartung wie in write_segment_attribution_stacked_bar: EINE
    // symbolische Kategorie -> xmin==xmax==0 -> "Axis range for axis x is approximately empty"
    // (Owner-Log 13.09., latency_range.tex, [0.0:0.0], Zeile 35). Hier gibt es nicht einmal eine
    // relative Aufweitung. abs= ist auf symbolischen Achsen FATAL -> numerischer Index im Einer-Fall.
    if (single_combo) {
        f << "    % F-4/B: EINE Kombination -> numerischer Index statt symbolic x coords, Fenster explizit\n";
        f << "    xmin=-0.5, xmax=0.5,\n";
        f << "    xtick={0},\n";
        f << "    xticklabels={" << escape_latex(combos[0]) << "},\n";
    } else {
        f << "    symbolic x coords={";
        for (std::size_t i = 0; i < combos.size(); ++i) {
            if (i > 0) f << ",";
            f << escape_latex(combos[i]);
        }
        f << "},\n";
        f << "    xtick=data,\n";
    }
    f << "    x tick label style={rotate=60,anchor=east,font=\\tiny},\n";
    f << "    legend pos=north west,\n    legend style={font=\\tiny,legend cell align=left},\n";
    f << "    mark size=2.4pt,\n";
    f << "]\n";
    for (std::size_t oi = 0; oi < agg.ops.size(); ++oi) {
        f << "\\addplot[only marks,mark=*,color=rangeop" << oi << ",\n";
        f << "    error bars/.cd, y dir=plus, y explicit, error bar style={line width=0.7pt,color=rangeop" << oi
          << "}]\n";
        f << "coordinates {\n";
        for (std::size_t ai = 0; ai < agg.algos.size(); ++ai) {
            if (!agg.present[oi][ai]) continue;
            double const p50  = agg.p50_median[oi][ai];
            double const p99  = agg.p99_median[oi][ai];
            double const plus = (p99 > p50) ? (p99 - p50) : 0.0; // Datenqualitaet: p99<p50 -> 0 (kein Neg-Whisker)
            // F-4/B: im Einer-Fall numerischer Index 0 (die Achse traegt dann xtick/xticklabels).
            std::string const x_key = single_combo ? std::string{"0"} : escape_latex(agg.algos[ai] + "/" + agg.ops[oi]);
            f << "    (" << x_key << "," << fmt_double(p50) << ") +- (0," << fmt_double(plus) << ")\n";
        }
        f << "};\n";
        f << "\\addlegendentry{" << escape_latex(agg.ops[oi]) << "}\n";
    }
    f << "\\end{axis}\n\\end{tikzpicture}\n";
    close_resizebox(f, cnst);
    if (!cnst.body_only) {
        f << "\\caption{"
          << escape_latex(de ? "Latenz-Spanne p50-p99 je Suchalgorithmus x "
                               "Operation; Punkt=p50, Whisker=p99."
                             : "latency spread p50-p99 per search algorithm x "
                               "operation; point=p50, whisker=p99.")
          << "}\n\\end{figure}\n";
    }
    return f.good() ? status_ok : status_io_error;
}

std::vector<LatencyEcdfSeries> aggregate_latency_ecdf(std::span<WideMeasurementRow const> rows) {
    std::map<std::string, std::vector<double>> by_algo;
    for (auto const& r : rows) {
        if (!r.two_phase_valid) continue;
        if (r.search_algo.empty()) continue;
        if (!(r.ns_per_op > 0.0)) continue; // ns_per_op<=0 = keine gültige Config-Latenz
        by_algo[r.search_algo].push_back(r.ns_per_op);
    }
    std::vector<LatencyEcdfSeries> out;
    out.reserve(by_algo.size());
    for (auto& [algo, vals] : by_algo) {
        std::sort(vals.begin(), vals.end());
        out.push_back(LatencyEcdfSeries{algo, std::move(vals)});
    }
    return out;
}

int write_latency_ecdf(std::filesystem::path const& out, std::span<WideMeasurementRow const> rows,
                       std::string const& lang, PageConstraints const& cnst) {
    if (rows.empty()) return status_empty_input;
    std::vector<LatencyEcdfSeries> const series = aggregate_latency_ecdf(rows);
    if (series.empty()) return status_empty_input; // ehrlich leer, KEINE erfundene Kurve

    bool const de = (lang == "de");

    std::ofstream f{out};
    if (!f) return status_io_error;

    // Titel/xlabel MÜSSEN "Verteilung über Konfigurationen" ausweisen (Config-Streuung, NICHT Per-Operation).
    // NUR reiner Text (escape_latex-durchgereicht); "ns_per_op" wird korrekt zu ns\_per\_op escaped.
    std::string const title = de ? "ECDF der Gesamt-Latenz - Verteilung ueber Konfigurationen"
                                 : "ECDF of overall latency - distribution over configurations";
    std::string const xlab  = de ? "Gesamt-Latenz je Konfiguration ns_per_op (ns, log)"
                                 : "overall latency per configuration ns_per_op (ns, log)";
    std::string const ylab =
        de ? "Anteil der Konfigurationen mit Latenz <= x" : "share of configurations with latency <= x";
    // P-F (2026-09-16) -- chktex-RUECKFALL geschlossen. Der Owner hat die CAPTION am 15.08. von Hand auf
    // den Halbgeviertstrich gesetzt (26f88a0); der Emitter schrieb weiter den einfachen Bindestrich und
    // haette lint:latex auf 289 beim naechsten Writeback wieder rot gefaerbt (chktex Warning 8 "Wrong
    // length of dash", selbst nachgemessen am VORHER-Regenerat: genau 1 Treffer, genau die Caption-Zeile
    // -- die title-Zeile beisst NICHT). Deshalb NUR die Caption, damit der Bestand byte-gleich bleibt.
    std::string const ecdf_caption = de ? "ECDF der Gesamt-Latenz -- Verteilung ueber Konfigurationen"
                                        : "ECDF of overall latency -- distribution over configurations";

    f << "% AUTO-GENERATED durch diagram_generator (P3, Config-Streuungs-ECDF; lang=" << lang << ")\n";
    f << "% EHRLICH: Population = die KONFIGURATIONEN (Permutationen), jede = 1 ns_per_op-Punkt. Das ist die\n";
    f << "% Verteilung UEBER die Konfigurationen (Anteil der Configs mit Latenz <= x), NICHT eine Per-Operation-\n";
    f << "% Latenz-CDF (die rohen Einzel-Op-Latenzen traegt das WIDE-Schema nicht). 1 Treppe je search_algo.\n";
    // F-4/C (2026-09-16) -- Entartung der LOG-x-Achse. Bei N=1 Konfiguration je Reihe tragen beide
    // Treppenpunkte denselben x-Wert; die Achse meldete "[6.50946:6.50946] approximately empty"
    // (Owner-Log 13.09., latency_ecdf.tex, Zeile 30 -- 6.50946 == ln(671.532), die interne
    // Log-Koordinate). ymin/ymax sind gesetzt, xmin/xmax waren es nicht. aggregate_latency_ecdf
    // filtert bereits ns_per_op > 0, die Oktave ist also immer wohldefiniert.
    std::set<double> ecdf_distinct_x;
    for (auto const& s : series)
        for (double const v : s.sorted_ns_per_op) ecdf_distinct_x.insert(v);
    bool const   ecdf_degenerate_x = (ecdf_distinct_x.size() == 1 && *ecdf_distinct_x.begin() > 0.0);
    double const ecdf_only_x       = ecdf_degenerate_x ? *ecdf_distinct_x.begin() : 0.0;
    if (!cnst.body_only) { f << "\\begin{figure}[" << cnst.position_hint << "]\n\\centering\n"; }
    open_resizebox(f, cnst);
    f << "\\begin{tikzpicture}\n\\begin{axis}[\n";
    write_pgfplots_axis_options(f, cnst, title, xlab, ylab);
    f << "    xmode=log,\n";
    if (ecdf_degenerate_x) {
        f << "    % F-4/C: nur EINE distinkte Gesamt-Latenz im Korpus (n=1) -> x-Achse explizit auf eine\n";
        f << "    % Oktave geweitet (sonst xmin==xmax -> \"Axis range for axis x is approximately empty\").\n";
        f << "    % Log-Achse, darum [v/2 : 2v] wie in der P1b-Wache -- NUR die ACHSE, kein Punkt erfunden.\n";
        f << "    xmin=" << fmt_double(ecdf_only_x / 2.0) << ", xmax=" << fmt_double(ecdf_only_x * 2.0) << ",\n";
    }
    f << "    ymin=0, ymax=1,\n";
    f << "    legend pos=south east,\n    legend style={font=\\tiny,legend cell align=left},\n";
    f << "]\n";
    for (auto const& s : series) {
        std::size_t const n = s.sorted_ns_per_op.size();
        f << "\\addplot+[const plot,mark=none,thick] coordinates {\n";
        // Startpunkt auf Baseline y=0 beim kleinsten Wert (die Treppe steigt von 0 nach 1).
        f << "    (" << fmt_double(s.sorted_ns_per_op.front()) << ",0)\n";
        for (std::size_t i = 0; i < n; ++i) {
            double const y = static_cast<double>(i + 1) / static_cast<double>(n); // Rang/N ∈ (0,1]
            f << "    (" << fmt_double(s.sorted_ns_per_op[i]) << "," << fmt_double(y) << ")\n";
        }
        f << "};\n";
        f << "\\addlegendentry{" << escape_latex(s.algo) << " (N=" << n << ")}\n";
    }
    f << "\\end{axis}\n\\end{tikzpicture}\n";
    close_resizebox(f, cnst);
    if (!cnst.body_only) { f << "\\caption{" << escape_latex(ecdf_caption) << "}\n\\end{figure}\n"; }
    return f.good() ? status_ok : status_io_error;
}

// ─────────────────────────────────────────────────────────────────────────────
// INC-4 (2026-07-13) — Modus-2 Per-Achsen-Observer-Detail-Tabelle (stat_<achse>_<feld>)
// ─────────────────────────────────────────────────────────────────────────────
int write_axis_observer_detail_table(std::filesystem::path const&                            out,
                                     std::span<comdare::da::csv_to_latex::WideFullRow const> rows,
                                     std::string const&                                      lang) {
    // "echt gemessen" = Spalte vorhanden UND Wert weder leer noch "n/a" (Nicht-Mess-DLL schreibt ehrlich "n/a",
    // NICHT 0). Der Konsument erfindet NIE einen 0-Wert für einen fehlenden Zähler.
    auto const is_real = [](std::string const& v) { return !v.empty() && v != "n/a"; };

    // F-5 (2026-09-16) -- Umbruchstellen in das Achsen-Tupel der Block-Kopfzeile. Wird NACH escape_latex
    // angewandt, damit das eingefuegte \allowbreak nicht selbst escaped wird. Das '/' bleibt erhalten;
    // es wird NUR eine Umbruch-ERLAUBNIS angehaengt -- rein typografisch, kein Zeichen geht verloren.
    auto const with_breaks = [](std::string const& s) {
        std::string out;
        out.reserve(s.size() + 64);
        for (char const c : s) {
            out += c;
            if (c == '/') out += "\\allowbreak{}";
        }
        return out;
    };

    // ── HONEST-EMPTY (VOR dem ofstream, exakt das write_segment_attribution_stacked_bar-Muster): existiert KEINE
    //    Zeile mit mind. EINEM echt gemessenen stat_-Wert (alle "n/a"/leer ODER der stat_-Block fehlt ganz) →
    //    status_empty_input → KEINE Datei, KEIN erfundener Wert.
    bool any_real = false;
    for (auto const& r : rows) {
        for (auto const& [name, val] : r.stat)
            if (is_real(val)) {
                any_real = true;
                break;
            }
        if (any_real) break;
    }
    if (!any_real) return status_empty_input;

    // ── Achsen-Vokabular DATEN-GETRIEBEN aus den binary_id-Tupeln (r.axes-Keys = kCompositionAxisNames-Namen,
    //    exakt die stat_<achse>_-Präfixe; NIE hartkodiert). Längster Treffer trennt Achse/Feld eindeutig, weil
    //    BEIDE Unterstriche tragen (z.B. stat_cache_traversal_resolve_hit → Achse=cache_traversal, Feld=resolve_hit).
    std::set<std::string> axis_vocab;
    for (auto const& r : rows)
        for (auto const& [axis, value] : r.axes) axis_vocab.insert(axis);

    auto const decompose = [&axis_vocab](std::string const& col) -> std::pair<std::string, std::string> {
        std::string_view rest{col};
        rest.remove_prefix(std::string_view{"stat_"}.size());
        std::string best_axis; // längster passender Achsen-Präfix
        for (auto const& a : axis_vocab)
            if (rest.size() > a.size() + 1 && rest.substr(0, a.size()) == a && rest[a.size()] == '_' &&
                a.size() > best_axis.size())
                best_axis = a;
        if (!best_axis.empty()) return {best_axis, std::string{rest.substr(best_axis.size() + 1)}};
        // Defensiver Fallback (Achse nicht im binary_id-Tupel — bei vollständigem 17-Achsen-binary_id nie): am
        // letzten '_' trennen, damit die Zeile ehrlich mit ihrem Roh-Namen erscheint statt verloren zu gehen.
        auto const last = rest.rfind('_');
        if (last == std::string_view::npos) return {std::string{rest}, std::string{}};
        return {std::string{rest.substr(0, last)}, std::string{rest.substr(last + 1)}};
    };

    bool const de = (lang == "de");

    std::ofstream f{out};
    if (!f) return status_io_error;

    std::string const caption = de ? "Per-Achsen-Observer-Detailwerte je Tier-Binary (nur echt gemessene Zaehler)"
                                   : "Per-axis observer detail values per tier binary (measured counters only)";
    std::string const label   = "tab:appendix:observer-detail";
    std::string const c_axis  = de ? "Achse" : "axis";
    std::string const c_field = de ? "Observer-Feld" : "observer field";
    std::string const c_value = de ? "Wert" : "value";
    std::string const colhead =
        escape_latex(c_axis) + " & " + escape_latex(c_field) + " & " + escape_latex(c_value) + " \\\\";

    f << "% AUTO-GENERATED durch diagram_generator (INC-4, Modus-2 Per-Achsen-Observer-Detail): stat_<achse>_<feld>\n";
    f << "% aus kV3AxisSchema[19][8] (single-source, DLL-seitig) — header-getrieben gelesen, honest-empty. lang="
      << lang << "\n";
    f << "\\begin{scriptsize}\n\\setlength{\\tabcolsep}{3pt}\n";
    f << "\\begin{longtable}{@{}>{\\raggedright\\arraybackslash}p{4.6cm} "
         ">{\\raggedright\\arraybackslash}p{4.6cm} r@{}}\n";
    f << "\\caption{" << escape_latex(caption) << "}\\label{" << label << "}\\\\\n";
    // P-F (2026-09-16) -- chktex-RUECKFALL geschlossen. Der Owner hat die vier longtable-Marken am
    // 15.08. von Hand um das abschliessende '%' ergaenzt (Commit 26f88a0, "chktex-Reinheit Ganzbaum");
    // der Emitter erzeugte die Vorform weiter -- der naechste Writeback haette lint:latex auf 289
    // wieder rot gefaerbt (chktex Warning 1 "Command terminated with space", 4 Treffer, selbst
    // nachgemessen am VORHER-Regenerat). Das '%' frisst das Zeilenende-Leerzeichen.
    f << "\\toprule\n" << colhead << "\n\\midrule\n\\endfirsthead%\n";
    f << "\\multicolumn{3}{c}{\\tablename\\ \\thetable{} -- " << (de ? "Fortsetzung" : "continued")
      << "}\\\\\n\\toprule\n"
      << colhead << "\n\\midrule\n\\endhead%\n";
    f << "\\midrule\n\\multicolumn{3}{r}{" << (de ? "Fortsetzung n\\\"achste Seite" : "continued on next page")
      << "}\\\\\n\\endfoot%\n\\bottomrule\n\\endlastfoot%\n";

    // Je WIDE-Zeile (= je Tier-Binary/Messung) EIN Block: Kopfzeile binary_id[+workload] + je Achse/Feld die
    // echten Werte. Reihenfolge deterministisch: r.stat ist std::map (nach vollem Spaltennamen sortiert → nach
    // Achse, dann Feld). Zeilen ohne EINEN echten Wert (reine n/a-DLL) werden ehrlich ganz übersprungen.
    for (auto const& r : rows) {
        bool row_has_real = false;
        for (auto const& [name, val] : r.stat)
            if (is_real(val)) {
                row_has_real = true;
                break;
            }
        if (!row_has_real) continue;

        std::string being = r.binary_id;
        if (!r.workload.empty()) being += "  [" + r.workload + "]";
        // F-5 (2026-09-16) -- die Konfigurations-Kopfzeile ist der volle Achsen-binary_id (im Korpus
        // 606 Zeichen). In einer l-Spalte ist sie EINE Zeile ohne jede Umbruchstelle; ihre natuerliche
        // Breite sprengt die longtable und erzeugt in JEDEM der fuenf longtable-Chunks denselben
        // "Overfull \hbox (1515.18507pt too wide) in alignment" (Owner-Log 13.09., 5 Ereignisse; die
        // fuenf Chunks sind \endfirsthead/\endhead/\endfoot/\endlastfoot/Rumpf, alle mit derselben
        // Endbreite). Gemessene Heilung (Mutationsproben M1/M2/M3 an TeX Live 2026): es braucht BEIDES
        // -- (1) eine UMBRECHENDE p-Spalte statt l, mit \dimexpr-Abzug der beiden \tabcolsep (ohne
        // den Abzug bleiben 3.0pt Rest), und (2) Umbruchstellen IM Tupel (with_breaks oben; weder '/'
        // noch '\_' sind von sich aus Umbruchstellen). Keine Warnung wird unterdrueckt, \hfuzz bleibt
        // unberuehrt, und es geht kein Zeichen der binary_id verloren.
        f << "\\multicolumn{3}{@{}>{\\raggedright\\arraybackslash}p{\\dimexpr\\linewidth-2\\tabcolsep\\relax}}"
          << "{\\textbf{" << with_breaks(escape_latex(being)) << "}}\\\\\n";

        std::string last_axis;
        for (auto const& [name, val] : r.stat) {
            if (!is_real(val)) continue; // n/a/leer → NIE 0-erfunden, Feld weggelassen
            auto const [axis, field] = decompose(name);
            // Achsen-Label nur beim Wechsel drucken (Lesbarkeit); Feld+Wert immer.
            std::string const axis_cell = (axis == last_axis) ? std::string{} : escape_latex(axis);
            last_axis                   = axis;
            f << axis_cell << " & " << escape_latex(field) << " & " << escape_latex(val) << " \\\\\n";
        }
        f << "\\midrule\n";
    }
    f << "\\end{longtable}\n\\end{scriptsize}\n";
    return f.good() ? status_ok : status_io_error;
}

} // namespace comdare::da::diagram_generator
