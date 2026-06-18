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

void write_pgfplots_axis_options(std::ostream& out,
                                  PageConstraints const& cnst,
                                  std::string const& title,
                                  std::string const& x_label,
                                  std::string const& y_label) {
    out << "    width=" << fmt_double(cnst.width_fraction) << "\\textwidth,\n";
    out << "    height=" << fmt_double(cnst.height_fraction) << "\\textheight,\n";
    if (cnst.keep_aspect_ratio) {
        out << "    scale only axis,\n";
    }
    out << "    title={" << escape_latex(title) << "},\n";
    out << "    xlabel={" << escape_latex(x_label) << "},\n";
    out << "    ylabel={" << escape_latex(y_label) << "},\n";
    out << "    grid=both,\n";
    out << "    enlargelimits=0.05,\n";
}

}  // anonymous namespace

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
            default:  out += c;
        }
    }
    return out;
}

int write_bar_chart(std::filesystem::path const& out_path,
                    BarChartData const& data,
                    PageConstraints const& cnst) {
    if (data.values.empty()) return status_empty_input;
    if (data.labels.size() != data.values.size()) return status_empty_input;

    std::ofstream f{out_path};
    if (!f) return status_io_error;

    f << "% AUTO-GENERATED durch diagram_generator (REV 7.6, TikZ-Bar-Chart)\n";
    if (!cnst.body_only) {
        f << "\\begin{figure}[" << cnst.position_hint << "]\n";
        f << "\\centering\n";
    }
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
    if (!cnst.body_only) {
        f << "\\caption{" << escape_latex(data.title) << "}\n";
        f << "\\end{figure}\n";
    }
    return f.good() ? status_ok : status_io_error;
}

int write_scatter_plot(std::filesystem::path const& out_path,
                       ScatterData const& data,
                       PageConstraints const& cnst) {
    if (data.xs.empty() || data.xs.size() != data.ys.size()) {
        return status_empty_input;
    }

    std::ofstream f{out_path};
    if (!f) return status_io_error;

    f << "% AUTO-GENERATED durch diagram_generator (REV 7.6, TikZ-Scatter)\n";
    if (!cnst.body_only) {
        f << "\\begin{figure}[" << cnst.position_hint << "]\n";
        f << "\\centering\n";
    }
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
    if (!cnst.body_only) {
        f << "\\caption{" << escape_latex(data.title) << "}\n";
        f << "\\end{figure}\n";
    }
    return f.good() ? status_ok : status_io_error;
}

int write_heatmap(std::filesystem::path const& out_path,
                  HeatmapData const& data,
                  PageConstraints const& cnst) {
    if (data.matrix.empty() || data.matrix[0].empty()) return status_empty_input;

    std::ofstream f{out_path};
    if (!f) return status_io_error;

    std::size_t const nx = data.matrix[0].size();
    std::size_t const ny = data.matrix.size();

    f << "% AUTO-GENERATED durch diagram_generator (REV 7.6, TikZ-Heatmap)\n";
    if (!cnst.body_only) {
        f << "\\begin{figure}[" << cnst.position_hint << "]\n";
        f << "\\centering\n";
    }
    f << "\\begin{tikzpicture}\n";
    f << "\\begin{axis}[\n";
    write_pgfplots_axis_options(f, cnst, data.title, data.x_label, data.y_label);
    f << "    view={0}{90},\n";
    f << "    colorbar,\n";
    f << "    colormap/viridis,\n";
    f << "    mesh/cols=" << nx << ",\n";   // PFLICHT fuer matrix plot* (sonst 'matrix input=image' unsupported)
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
            f << "    (" << x << "," << y << "," << fmt_double(data.matrix[y][x]) << ") [" << fmt_double(data.matrix[y][x]) << "]\n";
        }
    }
    f << "};\n";
    f << "\\end{axis}\n";
    f << "\\end{tikzpicture}\n";
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
    std::uint64_t v = 0;
    auto const* first = s.data();
    auto const* last  = s.data() + s.size();
    auto [_, ec] = std::from_chars(first, last, v);
    return (ec == std::errc{}) ? v : 0;
}

}  // anonymous namespace

std::vector<CsvRow>
load_csv_with_workload_used(std::filesystem::path const& csv_path) {
    std::vector<CsvRow> rows;
    std::ifstream f{csv_path};
    if (!f) return rows;

    std::string line;
    bool        is_header = true;
    while (std::getline(f, line)) {
        if (is_header) { is_header = false; continue; }  // skip CSV header
        if (line.empty()) continue;

        auto const fields = split_csv_line(line);
        if (fields.size() < 14) continue;  // V20.3 hat 16 Spalten

        CsvRow r;
        r.permutation_id    = fields[0];
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

int write_throughput_by_workload(std::filesystem::path const& out_tikz,
                                  std::span<CsvRow const> rows,
                                  PageConstraints const& cnst)
{
    if (rows.empty()) return status_empty_input;

    // Stabile Sortierung nach workload_used (gruppiert), Sekundaer-Schluessel id.
    std::vector<CsvRow> sorted{rows.begin(), rows.end()};
    std::sort(sorted.begin(), sorted.end(),
        [](CsvRow const& a, CsvRow const& b) {
            if (a.workload_used != b.workload_used) {
                return a.workload_used < b.workload_used;
            }
            return a.permutation_id < b.permutation_id;
        });

    BarChartData bar;
    bar.title    = "Throughput pro Permutation, gruppiert nach Workload";
    bar.x_label  = "Permutation (gruppiert nach YCSB-Workload)";
    bar.y_label  = "Throughput (Mio.\\ Operationen/s)";
    bar.labels.reserve(sorted.size());
    bar.values.reserve(sorted.size());
    for (auto const& r : sorted) {
        // throughput = op_count * 1e9 / total_cycles  (cycles ~ ns in V21.3 Sample)
        double const tput_ops_per_sec =
            (r.total_cycles > 0)
                ? (static_cast<double>(r.op_count) * 1.0e9 / static_cast<double>(r.total_cycles))
                : 0.0;
        // Label-Konvention: "<id> [<workload>]"
        bar.labels.push_back(r.permutation_id + " [" + r.workload_used + "]");
        bar.values.push_back(tput_ops_per_sec / 1.0e6);  // in Millionen
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
    std::string cur;
    for (char c : line) {
        if (c == ';') { out.push_back(std::move(cur)); cur.clear(); }
        else if (c != '\r') cur.push_back(c);
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
    if (z_field == "op_erase_p50_ns")  return r.op_erase_p50_ns;
    if (z_field == "op_scan_p50_ns")   return r.op_scan_p50_ns;
    if (z_field == "op_rmw_p50_ns")    return r.op_rmw_p50_ns;
    return r.ns_per_op;  // "ns_per_op" + Default
}

// Gemeinsame Aggregation für 2D-Heatmap und echte 3D-Surface: füllt die
// (search_algo × workload)-Matrix mit nearest-rank-Median des z-Feldes, NUR über
// two_phase_valid==true. Beim scan-Surface werden die No-Op-Scan-Profile
// "ycsb_e"/"lp_range_scan" ausgeschlossen. Liefert false bei leerer Matrix.
[[nodiscard]] bool aggregate_surface_matrix(std::span<WideMeasurementRow const> rows,
                                            std::string const& z_field,
                                            HeatmapData& data) {
    bool const is_scan = (z_field == "op_scan_p50_ns");
    // std::map → deterministisch sortierte Achsen-Ordnung (Zeilen y, Spalten x).
    std::map<std::pair<std::string, std::string>, std::vector<double>> groups;
    std::set<std::string> algos;
    std::set<std::string> workloads;
    for (auto const& r : rows) {
        if (!r.two_phase_valid) continue;
        if (r.search_algo.empty()) continue;
        if (is_scan && (r.workload == "ycsb_e" || r.workload == "lp_range_scan")) continue;
        groups[{r.search_algo, r.workload}].push_back(pick_z_field(r, z_field));
        algos.insert(r.search_algo);
        workloads.insert(r.workload);
    }
    if (algos.empty() || workloads.empty()) return false;

    data.y_labels.assign(algos.begin(), algos.end());      // Zeilen = search_algo
    data.x_labels.assign(workloads.begin(), workloads.end());  // Spalten = workload
    data.matrix.assign(data.y_labels.size(),
                       std::vector<double>(data.x_labels.size(), 0.0));
    for (std::size_t y = 0; y < data.y_labels.size(); ++y) {
        for (std::size_t x = 0; x < data.x_labels.size(); ++x) {
            auto it = groups.find({data.y_labels[y], data.x_labels[x]});
            if (it != groups.end()) {
                data.matrix[y][x] = nearest_rank_median(std::move(it->second));
            }
        }
    }
    return true;
}

// Lokalisierte Titel/Achsen-Beschriftung je z-Feld.
[[nodiscard]] std::string z_field_human(std::string const& z_field, std::string const& lang) {
    bool const de = (lang == "de");
    if (z_field == "op_insert_p50_ns") return de ? "Insert-Latenz p50 (ns/op)"  : "insert latency p50 (ns/op)";
    if (z_field == "op_lookup_p50_ns") return de ? "Lookup-Latenz p50 (ns/op)"  : "lookup latency p50 (ns/op)";
    if (z_field == "op_erase_p50_ns")  return de ? "Erase-Latenz p50 (ns/op)"   : "erase latency p50 (ns/op)";
    if (z_field == "op_scan_p50_ns")   return de ? "Scan-Latenz p50 (ns/op)"    : "scan latency p50 (ns/op)";
    if (z_field == "op_rmw_p50_ns")    return de ? "RMW-Latenz p50 (ns/op)"     : "rmw latency p50 (ns/op)";
    return de ? "Gesamt-Latenz (ns/op)" : "overall latency (ns/op)";
}

}  // anonymous namespace

int parse_wide_csv(std::filesystem::path const& in, std::vector<WideMeasurementRow>& out_rows) {
    std::ifstream f{in};
    if (!f) return status_io_error;
    std::string header_line;
    if (!std::getline(f, header_line)) return status_empty_input;

    // HEADER-GETRIEBEN: Spalten per Name auflösen (Reihenfolge-/Breite-agnostisch → robust gegen
    // additive Schema-Erweiterungen des Mess-Systems). 1:1 aus csv_to_latex.cpp:158-201 portiert,
    // erweitert um die 5 Interface-Funktions-p50-Pflichtspalten.
    auto const header = split_semicolons(header_line);
    std::unordered_map<std::string, std::size_t> col;
    for (std::size_t i = 0; i < header.size(); ++i) col.emplace(header[i], i);
    char const* required[] = {"binary_id", "ns_per_op", "workload", "two_phase_valid",
                              "op_insert_p50_ns", "op_lookup_p50_ns", "op_erase_p50_ns",
                              "op_scan_p50_ns", "op_rmw_p50_ns"};
    for (char const* name : required)
        if (col.find(name) == col.end()) return status_empty_input;

    std::string line;
    while (std::getline(f, line)) {
        if (line.empty() || line == "\r") continue;
        auto cols = split_semicolons(line);
        if (cols.size() != header.size()) return status_empty_input;  // gleiche-Breite-Prüfung
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
                r.search_algo = r.binary_id.substr(kPrefix.size(),
                    (end == std::string::npos ? r.binary_id.size() : end) - kPrefix.size());
            }
            out_rows.push_back(std::move(r));
        } catch (std::exception const&) {
            return status_empty_input;
        }
    }
    return status_ok;
}

int write_surface_search_algo_x_workload(std::filesystem::path const& out,
                                         std::span<WideMeasurementRow const> rows,
                                         std::string const& z_field,
                                         std::string const& lang,
                                         PageConstraints const& cnst) {
    if (rows.empty()) return status_empty_input;
    HeatmapData data;
    if (!aggregate_surface_matrix(rows, z_field, data)) return status_empty_input;

    bool const de = (lang == "de");
    std::string const metric = z_field_human(z_field, lang);
    data.title   = (de ? "Heatmap: " : "Heatmap: ") + metric
                 + (de ? " (Suchalgorithmus x Workload)" : " (search algorithm x workload)");
    data.x_label = de ? "Workload" : "workload";
    data.y_label = de ? "Suchalgorithmus" : "search algorithm";
    // write_heatmap WIEDERVERWENDEN (view={0}{90} matrix plot + colormap/viridis).
    return write_heatmap(out, data, cnst);
}

int write_surface3d_search_algo_x_workload(std::filesystem::path const& out,
                                           std::span<WideMeasurementRow const> rows,
                                           std::string const& z_field,
                                           std::string const& lang,
                                           PageConstraints const& cnst) {
    if (rows.empty()) return status_empty_input;
    HeatmapData data;
    if (!aggregate_surface_matrix(rows, z_field, data)) return status_empty_input;

    std::ofstream f{out};
    if (!f) return status_io_error;

    std::size_t const nx = data.matrix[0].size();
    std::size_t const ny = data.matrix.size();
    bool const de = (lang == "de");
    std::string const metric = z_field_human(z_field, lang);

    f << "% AUTO-GENERATED durch diagram_generator (L-c, echte-3D-Surface, z log-skaliert)\n";
    if (!cnst.body_only) {
        f << "\\begin{figure}[" << cnst.position_hint << "]\n";
        f << "\\centering\n";
    }
    f << "\\begin{tikzpicture}\n";
    f << "\\begin{axis}[\n";
    write_pgfplots_axis_options(f, cnst,
        (de ? "3D-Surface: " : "3D surface: ") + metric,
        (de ? "Workload" : "workload"),
        (de ? "Suchalgorithmus" : "search algorithm"));
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
        f << "\n";  // Leerzeile → neue mesh-Zeile (pgfplots surf-Konvention).
    }
    f << "};\n";
    f << "\\end{axis}\n";
    f << "\\end{tikzpicture}\n";
    if (!cnst.body_only) {
        f << "\\caption{" << escape_latex(data.title) << "}\n";
        f << "\\end{figure}\n";
    }
    return f.good() ? status_ok : status_io_error;
}

}  // namespace comdare::da::diagram_generator
