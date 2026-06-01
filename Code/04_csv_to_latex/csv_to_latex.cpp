// SPDX-License-Identifier: Apache-2.0
#include "csv_to_latex.hpp"

#include <fstream>
#include <sstream>

namespace comdare::da::csv_to_latex {

namespace {

[[nodiscard]] std::vector<std::string> split_line(std::string const& line) {
    std::vector<std::string> out;
    std::string cur;
    for (char c : line) {
        if (c == ',') { out.push_back(std::move(cur)); cur.clear(); }
        else cur.push_back(c);
    }
    out.push_back(std::move(cur));
    return out;
}

[[nodiscard]] std::vector<std::string_view> split_colons(std::string_view s) {
    std::vector<std::string_view> out;
    std::size_t start = 0;
    for (std::size_t i = 0; i < s.size(); ++i) {
        if (s[i] == ':') {
            out.push_back(s.substr(start, i - start));
            start = i + 1;
        }
    }
    out.push_back(s.substr(start));
    return out;
}

}  // anonymous namespace

int parse_csv(std::filesystem::path const& in, std::vector<CsvRow>& out_rows) {
    std::ifstream f{in};
    if (!f) return status_io_error;
    std::string header;
    if (!std::getline(f, header)) return status_parse_error;

    std::string line;
    while (std::getline(f, line)) {
        if (line.empty()) continue;
        auto cols = split_line(line);
        // V41.P1: 16-Spalten-Schema kanonisch (workload_used als 4. Spalte, Index 3).
        if (cols.size() < 16) return status_parse_error;
        try {
            CsvRow r;
            r.permutation_id           = cols[0];
            r.fingerprint              = std::stoull(cols[1]);
            r.succeeded                = (cols[2] == "1");
            r.workload_used            = cols[3];
            r.op_count                 = std::stoull(cols[4]);
            r.total_cycles             = std::stoull(cols[5]);
            r.cache_misses_l1          = std::stoull(cols[6]);
            r.cache_misses_l2          = std::stoull(cols[7]);
            r.cache_misses_l3          = std::stoull(cols[8]);
            r.dtlb_misses              = std::stoull(cols[9]);
            r.coherence_invalidations  = std::stoull(cols[10]);
            r.energy_micro_joules      = std::stoull(cols[11]);
            r.bytes_allocated          = std::stoull(cols[12]);
            r.bytes_in_use_peak        = std::stoull(cols[13]);
            r.external_frag            = std::stod(cols[14]);
            r.internal_frag            = std::stod(cols[15]);
            out_rows.push_back(std::move(r));
        } catch (std::exception const&) {
            return status_parse_error;
        }
    }
    return status_ok;
}

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

int write_latex(std::filesystem::path const& out, std::span<CsvRow const> rows,
                std::string const& caption, std::string const& label,
                std::string const& lang) {
    std::ofstream f{out};
    if (!f) return status_io_error;

    // C2 (2026-06-01): bilinguale Spaltenkopf-Zeile. de = Diplomarbeit-Deutsch, sonst Englisch.
    std::string const header = (lang == "de")
        ? "Permutation & Ops & Zyklen & L1 & L2 & L3 \\\\\n"
        : "Permutation & ops & cycles & L1 & L2 & L3 \\\\\n";

    f << "% AUTO-GENERATED durch csv_to_latex (Diplomarbeit/Code REV 7.6; lang=" << lang << ")\n";
    f << "\\begin{table}[!htbp]\n";
    f << "\\centering\n";
    f << "\\small\n";
    f << "\\begin{tabular}{lrrrrr}\n";
    f << "\\toprule\n";
    f << header;
    f << "\\midrule\n";
    for (auto const& r : rows) {
        if (!r.succeeded) continue;
        f << escape_latex(r.permutation_id)
          << " & " << r.op_count
          << " & " << r.total_cycles
          << " & " << r.cache_misses_l1
          << " & " << r.cache_misses_l2
          << " & " << r.cache_misses_l3
          << " \\\\\n";
    }
    f << "\\bottomrule\n";
    f << "\\end{tabular}\n";
    f << "\\caption{" << escape_latex(caption) << "}\n";
    f << "\\label{" << label << "}\n";
    f << "\\end{table}\n";
    return f.good() ? status_ok : status_io_error;
}

std::string generate_baustein_description(std::string_view permutation_id) {
    // permutation_id format: ce_<x>:search_algo_<y>:alloc_<z>:dataset_<w>
    auto tokens = split_colons(permutation_id);
    std::ostringstream out;
    out << "% Baustein-Steckbrief fuer " << permutation_id << "\n";
    out << "\\begin{description}\n";
    char const* labels[] = {"Cache-Engine", "Search-Algorithm", "Allocator", "Test-Data-Set"};
    for (std::size_t i = 0; i < tokens.size() && i < 4; ++i) {
        out << "  \\item[" << labels[i] << "] " << escape_latex(tokens[i]) << "\n";
    }
    out << "\\end{description}\n";
    return out.str();
}

}  // namespace comdare::da::csv_to_latex
