// SPDX-License-Identifier: Apache-2.0
#include "diagram_generator.hpp"

#include <algorithm>
#include <charconv>
#include <cmath>
#include <fstream>
#include <iomanip>
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

// P4 (2026-07-12): die 20 Stapel-Segment-Spaltennamen in EXAKTER Stapel-/Header-Reihenfolge — 19 Organ-Achsen
// (single-source = kCompositionAxisNames aus axis_path_serialization.hpp:30-34) + seg_framework_ns an Index 19.
// Die Legende leitet die Anzeigenamen deterministisch durch Strippen von "seg_"/"_ns" ab (keine zweite Liste → keine Drift).
constexpr std::array<std::string_view, WideMeasurementRow::kSegmentCount> kSegmentColumns = {
    "seg_search_algo_ns", "seg_cache_traversal_ns",    "seg_mapping_ns",     "seg_path_compression_ns",
    "seg_node_type_ns",   "seg_memory_layout_ns",      "seg_allocator_ns",   "seg_prefetch_ns",
    "seg_concurrency_ns", "seg_serialization_ns",      "seg_telemetry_ns",   "seg_value_handle_ns",
    "seg_isa_ns",         "seg_index_organization_ns", "seg_io_dispatch_ns", "seg_migration_policy_ns",
    "seg_filter_ns",      "seg_queuing_q1_ns",         "seg_queuing_q2_ns",  "seg_framework_ns"};

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
struct OpRangeSpec {
    std::string_view display;             // Anzeigename (insert/lookup/erase/scan/rmw)
    std::string_view p50_col;             // WIDE-Spaltenname der p50
    std::string_view p99_col;             // WIDE-Spaltenname der p99
    double WideMeasurementRow::* p50_mem; // Ziel-Member p50
    double WideMeasurementRow::* p99_mem; // Ziel-Member p99
};
constexpr std::array<OpRangeSpec, 5> kRangeOps = {{
    {"insert", "op_insert_p50_ns", "op_insert_p99_ns", &WideMeasurementRow::op_insert_p50_ns,
     &WideMeasurementRow::op_insert_p99_ns},
    {"lookup", "op_lookup_p50_ns", "op_lookup_p99_ns", &WideMeasurementRow::op_lookup_p50_ns,
     &WideMeasurementRow::op_lookup_p99_ns},
    {"erase", "op_erase_p50_ns", "op_erase_p99_ns", &WideMeasurementRow::op_erase_p50_ns,
     &WideMeasurementRow::op_erase_p99_ns},
    {"scan", "op_scan_p50_ns", "op_scan_p99_ns", &WideMeasurementRow::op_scan_p50_ns,
     &WideMeasurementRow::op_scan_p99_ns},
    {"rmw", "op_rmw_p50_ns", "op_rmw_p99_ns", &WideMeasurementRow::op_rmw_p50_ns, &WideMeasurementRow::op_rmw_p99_ns},
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

    std::ofstream f{out_path};
    if (!f) return status_io_error;

    std::size_t const nx = data.matrix[0].size();
    std::size_t const ny = data.matrix.size();

    // P6 (2026-07-12): LOGARITHMISCHE Farbskala. Die Latenz-Zellen spannen ~4 Dekaden
    // (z.B. 33..235805 ns) → eine LINEARE point-meta-Skala saettigt am unteren Ende und
    // verschluckt die eigentlichen Verfahrens-Unterschiede. Fix: point meta = log10(z),
    // Colorbar-Ticks als echte ns-Dekaden (10^k) relabelt. Konsistent mit dem 3D-Pfad
    // (write_surface3d_..., zmode=log). Farb-Domaene = tatsaechliche Log-Spanne der
    // positiven Zellen (maximaler Kontrast). z<=0 / fehlende Zelle → point meta = nan
    // (NICHT log10(0)=-inf): pgfplots zeichnet die Zelle, ohne sie in die Skala zu ziehen.
    double pos_min  = 0.0;
    double pos_max  = 0.0;
    bool   have_pos = false;
    for (auto const& row : data.matrix) {
        for (double v : row) {
            if (!(v > 0.0)) continue;
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
    double log_min = have_pos ? std::log10(pos_min) : 0.0;
    double log_max = have_pos ? std::log10(pos_max) : 0.0;
    if (have_pos && !(log_max > log_min)) log_max = log_min + 1.0; // entartete Ein-Wert-Matrix aufweiten

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
    f << "    colormap/viridis,\n";
    if (have_pos) {
        // P6: Farb-Domaene in log10(ns). point meta min/max = tatsaechliche Log-Spanne (max. Kontrast).
        f << "    point meta min=" << fmt_double(log_min) << ",\n";
        f << "    point meta max=" << fmt_double(log_max) << ",\n";
        // Colorbar-Ticks auf ganzzahlige ns-Dekaden relabeln (10^k). Randticks ausserhalb
        // [min,max] clippt pgfplots automatisch → Achse zeigt echte ns-Werte statt log-Zahlen.
        int const k_lo = static_cast<int>(std::floor(log_min));
        int const k_hi = static_cast<int>(std::ceil(log_max));
        f << "    colorbar style={ytick={";
        for (int k = k_lo; k <= k_hi; ++k) {
            if (k > k_lo) f << ",";
            f << k;
        }
        f << "}, yticklabels={";
        for (int k = k_lo; k <= k_hi; ++k) {
            if (k > k_lo) f << ",";
            f << "$10^{" << k << "}$";
        }
        f << "}},\n";
    }
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
    f << "\\addplot3[matrix plot*, point meta=explicit] coordinates {\n";
    for (std::size_t y = 0; y < ny; ++y) {
        for (std::size_t x = 0; x < data.matrix[y].size(); ++x) {
            double const z = data.matrix[y][x];
            // Koordinaten-z bleibt der Roh-ns-Wert (bei view={0}{90} flach → nur Position).
            // FARBE (point meta) = log10(z); z<=0/fehlend → nan (nicht log10(0)=-inf).
            // have_pos==false (unmoegliche rein-nicht-positive Matrix) → linear wie zuvor.
            std::string const meta =
                have_pos ? (z > 0.0 ? fmt_double(std::log10(z)) : std::string{"nan"}) : fmt_double(z);
            f << "    (" << x << "," << y << "," << fmt_double(z) << ") [" << meta << "]\n";
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

// Nearest-Rank-Median (konsistent zur Mess-Seite, csv_to_latex.cpp:39-45,
// nearest_rank_p(0.5)); leere Stichprobe → 0.
[[nodiscard]] double nearest_rank_median(std::vector<double> v) {
    if (v.empty()) return 0.0;
    std::sort(v.begin(), v.end());
    std::size_t rank = static_cast<std::size_t>(0.5 * static_cast<double>(v.size() - 1) + 0.5);
    if (rank >= v.size()) rank = v.size() - 1;
    return v[rank];
}

// Wählt das z-Feld einer Zeile per Feld-Name. Unbekannter Name → ns_per_op (Gesamt).
[[nodiscard]] double pick_z_field(WideMeasurementRow const& r, std::string const& z_field) {
    if (z_field == "op_insert_p50_ns") return r.op_insert_p50_ns;
    if (z_field == "op_lookup_p50_ns") return r.op_lookup_p50_ns;
    if (z_field == "op_erase_p50_ns") return r.op_erase_p50_ns;
    if (z_field == "op_scan_p50_ns") return r.op_scan_p50_ns;
    if (z_field == "op_rmw_p50_ns") return r.op_rmw_p50_ns;
    return r.ns_per_op; // "ns_per_op" + Default
}

// Gemeinsame Aggregation für 2D-Heatmap und echte 3D-Surface: füllt die
// (search_algo × workload)-Matrix mit nearest-rank-Median des z-Feldes, NUR über
// two_phase_valid==true. Beim scan-Surface werden die No-Op-Scan-Profile
// "ycsb_e"/"lp_range_scan" ausgeschlossen. Liefert false bei leerer Matrix.
[[nodiscard]] bool aggregate_surface_matrix(std::span<WideMeasurementRow const> rows, std::string const& z_field,
                                            HeatmapData& data) {
    bool const is_scan = (z_field == "op_scan_p50_ns");
    // std::map → deterministisch sortierte Achsen-Ordnung (Zeilen y, Spalten x).
    std::map<std::pair<std::string, std::string>, std::vector<double>> groups;
    std::set<std::string>                                              algos;
    std::set<std::string>                                              workloads;
    for (auto const& r : rows) {
        if (!r.two_phase_valid) continue;
        if (r.search_algo.empty()) continue;
        if (is_scan && (r.workload == "ycsb_e" || r.workload == "lp_range_scan")) continue;
        groups[{r.search_algo, r.workload}].push_back(pick_z_field(r, z_field));
        algos.insert(r.search_algo);
        workloads.insert(r.workload);
    }
    if (algos.empty() || workloads.empty()) return false;

    data.y_labels.assign(algos.begin(), algos.end());         // Zeilen = search_algo
    data.x_labels.assign(workloads.begin(), workloads.end()); // Spalten = workload
    data.matrix.assign(data.y_labels.size(), std::vector<double>(data.x_labels.size(), 0.0));
    for (std::size_t y = 0; y < data.y_labels.size(); ++y) {
        for (std::size_t x = 0; x < data.x_labels.size(); ++x) {
            auto it = groups.find({data.y_labels[y], data.x_labels[x]});
            if (it != groups.end()) { data.matrix[y][x] = nearest_rank_median(std::move(it->second)); }
        }
    }
    return true;
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
            // P4 (2026-07-12): die 20 Stapel-Segmente (19 Organ-Achsen kCompositionAxisNames + seg_framework_ns) +
            // seg_run_total_ns. OPTIONAL/header-getrieben (NICHT in required[] → cowfix-v1 bricht nicht). n-a-tolerant:
            // fehlt EINE der 20 Spalten ODER ist EINE Zelle leer/"n/a"/nicht-numerisch → has_seg_ns bleibt false (Zeile
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
    if (!aggregate_surface_matrix(rows, z_field, data)) return status_empty_input;

    bool const        de     = (lang == "de");
    std::string const metric = z_field_human(z_field, lang);
    data.title               = (de ? "Heatmap: " : "Heatmap: ") + metric +
                               (de ? " (Suchalgorithmus x Workload)" : " (search algorithm x workload)");
    data.x_label             = de ? "Workload" : "workload";
    data.y_label             = de ? "Suchalgorithmus" : "search algorithm";
    // write_heatmap WIEDERVERWENDEN (view={0}{90} matrix plot + colormap/viridis).
    return write_heatmap(out, data, cnst);
}

int write_surface3d_search_algo_x_workload(std::filesystem::path const& out, std::span<WideMeasurementRow const> rows,
                                           std::string const& z_field, std::string const& lang,
                                           PageConstraints const& cnst) {
    if (rows.empty()) return status_empty_input;
    HeatmapData data;
    if (!aggregate_surface_matrix(rows, z_field, data)) return status_empty_input;

    std::ofstream f{out};
    if (!f) return status_io_error;

    std::size_t const nx     = data.matrix[0].size();
    std::size_t const ny     = data.matrix.size();
    bool const        de     = (lang == "de");
    std::string const metric = z_field_human(z_field, lang);

    f << "% AUTO-GENERATED durch diagram_generator (L-c, echte-3D-Surface, z log-skaliert)\n";
    if (!cnst.body_only) {
        f << "\\begin{figure}[" << cnst.position_hint << "]\n";
        f << "\\centering\n";
    }
    open_resizebox(f, cnst);
    f << "\\begin{tikzpicture}\n";
    f << "\\begin{axis}[\n";
    write_pgfplots_axis_options(f, cnst, (de ? "3D-Surface: " : "3D surface: ") + metric,
                                (de ? "Workload" : "workload"), (de ? "Suchalgorithmus" : "search algorithm"));
    // Echte 3D-Projektion + surf-Plot. z LOG-skaliert: Workload-Spanne ~14000×,
    // sonst dominiert eine Zelle die Höhen-Achse vollständig.
    f << "    view={45}{30},\n";
    f << "    zmode=log,\n";
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
    f << "]\n";
    f << "\\addplot3[surf] coordinates {\n";
    for (std::size_t y = 0; y < ny; ++y) {
        for (std::size_t x = 0; x < nx; ++x) {
            // z log-skaliert → 0/negative Werte auf kleinen Positiv-Floor heben,
            // damit pgfplots' log-Achse nicht auf log(0) läuft.
            double z = data.matrix[y][x];
            if (!(z > 0.0)) z = 1.0e-3;
            f << "    (" << x << "," << y << "," << fmt_double(z) << ")\n";
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
    for (auto const& r : rows) {
        if (!r.two_phase_valid) continue;
        if (!r.has_working_set_n) continue; // header-getrieben: fehlt die Spalte → kein Punkt (n/a)
        if (is_scan && (r.workload == "ycsb_e" || r.workload == "lp_range_scan")) continue;
        series[sweep_series_key(r)][r.working_set_n].push_back(pick_z_field(r, z_field));
    }
    if (series.empty()) return status_empty_input; // keine working_set_n-Daten → ehrlich leer

    std::string const metric = z_field_human(z_field, lang);

    std::ofstream f{out};
    if (!f) return status_io_error;
    f << "% AUTO-GENERATED durch diagram_generator (A2/m3v2, Working-Set-Sweep-Kurve; z=" << z_field
      << "; lang=" << lang << ")\n";
    f << "% Eine Kurve je gesweepter Achsen-Auspraegung; X=working_set_n (log2), Y=" << z_field
      << " (nearest-rank-Median, nur two_phase_valid).\n";
    if (!cnst.body_only) { f << "\\begin{figure}[" << cnst.position_hint << "]\n\\centering\n"; }
    open_resizebox(f, cnst);
    f << "\\begin{tikzpicture}\n\\begin{axis}[\n";
    write_pgfplots_axis_options(f, cnst, (de ? "Working-Set-Sweep: " : "working-set sweep: ") + metric,
                                (de ? "Arbeitsmenge $n$ (Schl\\\"ussel)" : "working set $n$ (keys)"), metric);
    f << "    xmode=log,\n    log basis x=2,\n";
    f << "    legend pos=north west,\n    legend style={font=\\tiny},\n";
    f << "    mark size=2pt,\n";
    f << "]\n";
    for (auto const& [key, points] : series) {
        f << "\\addplot+[mark=*] coordinates {\n";
        for (auto const& [wsn, samples] : points) {
            f << "    (" << wsn << "," << fmt_double(nearest_rank_median(samples)) << ")\n";
        }
        f << "};\n";
        f << "\\addlegendentry{" << escape_latex(key) << "}\n";
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
// KERN-SEMANTIK (erforscht+an echten Daten verifiziert): die 20 Stapel-Segmente sind kommensurabel mit
// seg_run_total_ns (dem eigenen Wall-Clock des 19-Segment-Laufs run_workload_segmented), NICHT mit total_ns
// (Real-Workload → 3–29× daneben). Beleg cache_engine_builder_iterator.hpp:205-214,327-329:
// Σ(19 Organ-seg + seg_framework_ns) == seg_run_total_ns EXAKT (seg_coverage ≈ 1.0). Daher ist das
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
        agg.group_totals.push_back(total); // == Mittel seg_run_total_ns (Σ 20 seg je Zeile = seg_run_total)
        agg.run_total_means.push_back(a.run_total_sum * inv);
        agg.coverage_means.push_back(a.cov_sum * inv);
    }
    return agg;
}

namespace {

// Deterministische kategoriale Palette: 20 Farben aus dem HSV-Farbkreis (gleichmäßig verteilter Hue,
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
    f << "% Ganzes je Balken = seg_run_total_ns (Wall-Clock des 19-Segment-Laufs), NICHT total_ns (inkommensurabel,\n";
    f << "% 3-29x daneben). Σ der 20 Segmente == seg_run_total_ns (seg_coverage~1). 19 Organ-Achsen + framework.\n";
    if (!cnst.body_only) { f << "\\begin{figure}[" << cnst.position_hint << "]\n\\centering\n"; }
    open_resizebox(f, cnst);
    f << "\\begin{tikzpicture}\n";
    // 20 deterministische Kategorienfarben je Segment definieren (Stapel-Reihenfolge = kSegmentColumns).
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
    f << "    enlarge x limits={abs=0.75},\n"; // symbolische x-Achse: Rand fuer wenige breite Balken
    f << "    symbolic x coords={";
    for (std::size_t i = 0; i < agg.groups.size(); ++i) {
        if (i > 0) f << ",";
        f << escape_latex(agg.groups[i]);
    }
    f << "},\n";
    f << "    xtick=data,\n";
    f << "    x tick label style={font=\\small},\n";
    // 20-Eintrags-Legende AUSSERHALB rechts (tiny), damit sie den Plot nicht ueberdeckt.
    f << "    legend style={at={(1.03,1)},anchor=north west,font=\\tiny,legend cell align=left},\n";
    f << "    reverse legend,\n"; // Legende von oben (letztes Stapel-Segment) nach unten lesbar zum Balken passend
    f << "]\n";
    for (std::size_t s = 0; s < WideMeasurementRow::kSegmentCount; ++s) {
        f << "\\addplot[fill=segattr" << s << ",draw=black!45,very thin] coordinates {";
        for (std::size_t g = 0; g < agg.groups.size(); ++g) {
            f << "(" << escape_latex(agg.groups[g]) << "," << fmt_double(agg.means[s][g]) << ")";
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
    std::size_t inversions = 0;
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
    f << "    symbolic x coords={";
    for (std::size_t i = 0; i < combos.size(); ++i) {
        if (i > 0) f << ",";
        f << escape_latex(combos[i]);
    }
    f << "},\n";
    f << "    xtick=data,\n";
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
            f << "    (" << escape_latex(agg.algos[ai] + "/" + agg.ops[oi]) << "," << fmt_double(p50) << ") +- (0,"
              << fmt_double(plus) << ")\n";
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

    f << "% AUTO-GENERATED durch diagram_generator (P3, Config-Streuungs-ECDF; lang=" << lang << ")\n";
    f << "% EHRLICH: Population = die KONFIGURATIONEN (Permutationen), jede = 1 ns_per_op-Punkt. Das ist die\n";
    f << "% Verteilung UEBER die Konfigurationen (Anteil der Configs mit Latenz <= x), NICHT eine Per-Operation-\n";
    f << "% Latenz-CDF (die rohen Einzel-Op-Latenzen traegt das WIDE-Schema nicht). 1 Treppe je search_algo.\n";
    if (!cnst.body_only) { f << "\\begin{figure}[" << cnst.position_hint << "]\n\\centering\n"; }
    open_resizebox(f, cnst);
    f << "\\begin{tikzpicture}\n\\begin{axis}[\n";
    write_pgfplots_axis_options(f, cnst, title, xlab, ylab);
    f << "    xmode=log,\n";
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
    if (!cnst.body_only) { f << "\\caption{" << escape_latex(title) << "}\n\\end{figure}\n"; }
    return f.good() ? status_ok : status_io_error;
}

} // namespace comdare::da::diagram_generator
