// SPDX-License-Identifier: Apache-2.0
#include "diagram_generator.hpp"

#include <fstream>
#include <iomanip>
#include <sstream>

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
    f << "\\begin{figure}[" << cnst.position_hint << "]\n";
    f << "\\centering\n";
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
    f << "\\caption{" << escape_latex(data.title) << "}\n";
    f << "\\end{figure}\n";
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
    f << "\\begin{figure}[" << cnst.position_hint << "]\n";
    f << "\\centering\n";
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
    f << "\\caption{" << escape_latex(data.title) << "}\n";
    f << "\\end{figure}\n";
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
    f << "\\begin{figure}[" << cnst.position_hint << "]\n";
    f << "\\centering\n";
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
    f << "\\caption{" << escape_latex(data.title) << "}\n";
    f << "\\end{figure}\n";
    return f.good() ? status_ok : status_io_error;
}

}  // namespace comdare::da::diagram_generator
