// SPDX-License-Identifier: Apache-2.0
#include "diagram_generator.hpp"

// L2 (2026-06-13): die 3D-Surfaces verzehren das L1-Aggregat aus Stufe 04. Diese .cpp ist die EINZIGE
// Übersetzungseinheit, die csv_to_latex einbindet — der diagram_generator-Header bleibt frei von dieser
// Abhängigkeit (Surface3dModelBuilder::build ist bewusst ein Template, hier explizit instanziiert).
#include "../04_csv_to_latex/csv_to_latex.hpp"

#include <algorithm>
#include <charconv>
#include <fstream>
#include <iomanip>
#include <map>
#include <set>
#include <sstream>
#include <string_view>

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
// L2 (2026-06-13) — 3D-pgfplots-Surface je Interface-Funktion (wide3d-Modus)
// ─────────────────────────────────────────────────────────────────────────────

namespace csv = comdare::da::csv_to_latex;

namespace {

// Stabile y-Ordnung: 19-Tupel-Achsen-Lexikografie. Vergleicht binary_ids über ihr geparstes Achsen-Tupel
// (NICHT die rohe Zeichenkette), damit die Tier-Reihenfolge der Achsen-Semantik folgt (L2-Spec: "stabil
// sortiert nach Achsen-Lexikografie des 19-Tupels"). Bei identischem Tupel-Präfix entscheidet die Länge.
[[nodiscard]] bool axis_tuple_less(std::string const& lhs_binary, std::string const& rhs_binary) {
    auto const a = csv::parse_axis_tuple(lhs_binary);
    auto const b = csv::parse_axis_tuple(rhs_binary);
    std::size_t const n = std::min(a.size(), b.size());
    for (std::size_t i = 0; i < n; ++i) {
        if (a[i].axis  != b[i].axis)  return a[i].axis  < b[i].axis;
        if (a[i].value != b[i].value) return a[i].value < b[i].value;
    }
    if (a.size() != b.size()) return a.size() < b.size();
    return lhs_binary < rhs_binary;  // totale Ordnung (Determinismus auch bei gleichem Tupel)
}

[[nodiscard]] std::string fmt_z(double d) {
    std::ostringstream s;
    s << std::fixed << std::setprecision(2) << d;
    return s.str();
}

}  // anonymous namespace

std::vector<std::string> default_excluded_scan_workloads() {
    // Scan-Profile sind bis A1a/M3 invalide (s. L2-Limitierung) → standardmäßig aus den Surfaces raus.
    return {"ycsb_e", "lp_range_scan"};
}

// Builder (Lehrbuch-Pattern): baut die 6 Op-Art-Surface-Modelle deterministisch aus den L1-Aggregaten.
// Template über den Aggregat-Span, damit der Header frei von csv_to_latex bleibt; unten explizit instanziiert.
template <class AggregateSpan>
std::array<Surface3dModel, 6>
Surface3dModelBuilder::build(AggregateSpan const& aggregates,
                             std::span<std::string const> excluded_workloads) const {
    std::set<std::string> excluded{excluded_workloads.begin(), excluded_workloads.end()};

    // 1) Stabile Achsen-Legenden sammeln: workloads lexikografisch (x), tiers per 19-Tupel-Lexikografie (y).
    std::set<std::string> workload_set;          // lexikografisch sortiert → x-Index
    std::set<std::string> tier_set_raw;
    for (auto const& agg : aggregates) {
        if (excluded.contains(agg.workload)) continue;
        workload_set.insert(agg.workload);
        tier_set_raw.insert(agg.binary_id);
    }
    std::vector<std::string> workloads{workload_set.begin(), workload_set.end()};
    std::vector<std::string> tiers{tier_set_raw.begin(), tier_set_raw.end()};
    std::sort(tiers.begin(), tiers.end(), axis_tuple_less);

    // Index-Maps (Flyweight-artige Legenden-Wiederverwendung: jede Surface teilt dieselbe x/y-Ordnung).
    std::map<std::string, std::size_t> workload_x;
    for (std::size_t i = 0; i < workloads.size(); ++i) workload_x[workloads[i]] = i;
    std::map<std::string, std::size_t> tier_y;
    for (std::size_t i = 0; i < tiers.size(); ++i) tier_y[tiers[i]] = i;

    // 2) z-Werte je Op-Art in (tier_y, workload_x)-Zellen ablegen. has_value entscheidet echte Zelle ↔ nan-Lücke.
    //    csv::kOpKindNames ist die Single-Source der Op-Reihenfolge (kein Re-Def in diesem Modul).
    std::array<Surface3dModel, 6> models{};
    for (std::size_t op = 0; op < csv::kOpKindCount; ++op) {
        Surface3dModel& m = models[op];
        m.op_name      = std::string{csv::kOpKindNames[op]};
        m.op_index     = op;
        m.workload_ids = workloads;
        m.tier_ids     = tiers;
        // Dichtes Gitter (y außen, x innen), Default = Lücke (nan).
        m.cells.resize(tiers.size() * workloads.size());
        for (std::size_t y = 0; y < tiers.size(); ++y)
            for (std::size_t x = 0; x < workloads.size(); ++x) {
                Surface3dCell& c = m.cells[y * workloads.size() + x];
                c.x_workload_index = x;
                c.y_tier_index     = y;
                c.has_value        = false;
            }
    }
    for (auto const& agg : aggregates) {
        if (excluded.contains(agg.workload)) continue;
        auto const wx = workload_x.find(agg.workload);
        auto const ty = tier_y.find(agg.binary_id);
        if (wx == workload_x.end() || ty == tier_y.end()) continue;
        std::size_t const x = wx->second, y = ty->second;
        for (std::size_t op = 0; op < csv::kOpKindCount; ++op) {
            double const z = agg.median_p50_ns_per_op[op];
            // Ehrlich: z<=0 = Op nicht ausgeführt (z.B. scan in Lookup-Profilen) → Lücke (nan), NIE 0 faken.
            if (z <= 0.0) continue;
            Surface3dCell& c = models[op].cells[y * workloads.size() + x];
            if (!c.has_value) ++models[op].real_cell_count;
            c.z_median_p50_ns = z;
            c.has_value       = true;
        }
    }
    return models;
}

// Explizite Instanziierung für den konkreten L1-Aggregat-Span (hält den Header csv_to_latex-frei).
template std::array<Surface3dModel, 6>
Surface3dModelBuilder::build<std::span<csv::TierWorkloadOpAggregate const>>(
    std::span<csv::TierWorkloadOpAggregate const> const&, std::span<std::string const>) const;

namespace {

// Template-Method-Kern: emittiert den \begin{axis}…\end{axis}-Rumpf EINER Surface (von beiden Varianten geteilt).
// Lücken-Zeilen werden ehrlich als `nan` geschrieben; pgfplots/surf interpoliert sie als Loch (unmeshed=false).
void write_surface_axis_body(std::ostream& f, Surface3dModel const& model) {
    std::size_t const nx = model.workload_ids.size();
    std::size_t const ny = model.tier_ids.size();

    // workload→x-Map als Achsenbeschriftung/Kommentar dokumentieren (L2-Pflicht).
    f << "  % x = Testdaten-Konfig (Workload-Index). workload->x-Map (stabil, lexikografisch):\n";
    for (std::size_t x = 0; x < nx; ++x)
        f << "  %   x=" << x << " : " << model.workload_ids[x] << "\n";
    f << "  % y = Tier-Index (stabil nach 19-Tupel-Achsen-Lexikografie der binary_ids):\n";
    for (std::size_t y = 0; y < ny; ++y)
        f << "  %   y=" << y << " : " << model.tier_ids[y] << "\n";
    f << "  % z = median_p50_ns je Operation '" << model.op_name << "' (nan = Op nicht ausgefuehrt).\n";

    f << "\\begin{axis}[\n";
    f << "    width=0.95\\textwidth,\n";
    f << "    height=0.45\\textwidth,\n";
    f << "    title={Surface: median p50 ns/op -- " << escape_latex(model.op_name) << "},\n";
    f << "    xlabel={Testdaten-Konfig (workload index)},\n";
    f << "    ylabel={Tier index},\n";
    f << "    zlabel={median p50 (ns/op)},\n";
    f << "    grid=both,\n";
    f << "    colormap/viridis,\n";
    f << "    colorbar,\n";
    f << "    view={45}{30},\n";
    f << "    mesh/ordering=y varies,\n";  // Datenpunkte: y außen, x innen (matcht unsere Zeilen-major-Ordnung)
    f << "]\n";
    // surf-Plot mit Gitter-Ausdehnung; nan-Zellen bleiben Löcher (ehrliche Lücke).
    f << "\\addplot3[surf, shader=interp, mesh/rows=" << ny << ", mesh/cols=" << nx << "] coordinates {\n";
    for (std::size_t y = 0; y < ny; ++y) {
        for (std::size_t x = 0; x < nx; ++x) {
            Surface3dCell const& c = model.cells[y * nx + x];
            f << "    (" << x << "," << y << ",";
            if (c.has_value) f << fmt_z(c.z_median_p50_ns);
            else             f << "nan";
            f << ")\n";
        }
        f << "\n";  // Leerzeile = Gitter-Zeilen-Trenner für surf
    }
    f << "};\n";
    f << "\\end{axis}\n";
}

}  // anonymous namespace

int write_op_surface(std::filesystem::path const& out_path,
                     Surface3dModel const& model,
                     PageConstraints const& cnst) {
    if (model.workload_ids.empty() || model.tier_ids.empty()) return status_empty_input;

    std::ofstream f{out_path};
    if (!f) return status_io_error;

    f << "% AUTO-GENERATED durch diagram_generator (L2, 3D-Surface je Interface-Funktion)\n";
    f << "% Op-Art = " << model.op_name << " | echte z-Zellen = " << model.real_cell_count
      << " von " << (model.workload_ids.size() * model.tier_ids.size()) << "\n";
    f << "% LIMITIERUNG: Scan-Profile (ycsb_e, lp_range_scan) sind bis A1a/M3 invalide und hier ausgeschlossen.\n";
    if (!cnst.body_only) {
        // Strategy A: standalone — eigene Präambel, separat zu PDF kompilierbar.
        f << "\\documentclass[border=2mm]{standalone}\n";
        f << "\\usepackage{pgfplots}\n";
        f << "\\pgfplotsset{compat=1.18}\n";
        f << "\\begin{document}\n";
        f << "\\begin{tikzpicture}\n";
        write_surface_axis_body(f, model);
        f << "\\end{tikzpicture}\n";
        f << "\\end{document}\n";
    } else {
        // Strategy B: body-only — nur \begin{axis}…\end{axis} (L4-Appendix wrappt tikzpicture/figure selbst).
        write_surface_axis_body(f, model);
    }
    return f.good() ? status_ok : status_io_error;
}

int generate_wide3d_surfaces(std::filesystem::path const& csv_path,
                             std::filesystem::path const& out_dir,
                             std::vector<Surface3dModel>& out_models,
                             std::span<std::string const> excluded_workloads) {
    // 1) L1-Parsen (KEINE Parallel-Implementierung des Parsers — Stufe 04 ist Single-Source).
    std::vector<csv::WideMeasurementRow> rows;
    if (csv::parse_wide_csv(csv_path, rows) != csv::status_ok) return status_io_error;
    if (rows.empty()) return status_empty_input;

    // 2) L1-Aggregat je (binary_id × workload) × Op-Art (nearest-rank-Median p50, nur two_phase_valid).
    auto const aggregates = csv::aggregate_tier_workload_per_op(rows);
    if (aggregates.empty()) return status_empty_input;

    // 3) Ausschlussliste: explizit übergeben ODER Default-Scan-Profile.
    std::vector<std::string> excluded_store;
    std::span<std::string const> excluded = excluded_workloads;
    if (excluded.empty()) {
        excluded_store = default_excluded_scan_workloads();
        excluded = excluded_store;
    }

    // 4) Builder → 6 Surface-Modelle.
    Surface3dModelBuilder builder;
    auto const models = builder.build(std::span<csv::TierWorkloadOpAggregate const>{aggregates}, excluded);

    // 5) Je Op-Art zwei Dateien: standalone (<op>.tex) + body-only (<op>_body.tex). RELATIVE Dateinamen.
    std::error_code ec;
    std::filesystem::create_directories(out_dir, ec);  // best-effort; Fehler fällt unten via ofstream auf
    out_models.clear();
    out_models.reserve(6);
    int first_error = status_ok;
    for (auto const& m : models) {
        out_models.push_back(m);
        PageConstraints standalone_cnst;  // body_only = false → standalone
        PageConstraints body_cnst;
        body_cnst.body_only = true;
        std::filesystem::path const standalone_file = out_dir / (m.op_name + ".tex");
        std::filesystem::path const body_file       = out_dir / (m.op_name + "_body.tex");
        int const rc_a = write_op_surface(standalone_file, m, standalone_cnst);
        int const rc_b = write_op_surface(body_file, m, body_cnst);
        if (first_error == status_ok && rc_a != status_ok) first_error = rc_a;
        if (first_error == status_ok && rc_b != status_ok) first_error = rc_b;
    }
    return first_error;
}

}  // namespace comdare::da::diagram_generator
