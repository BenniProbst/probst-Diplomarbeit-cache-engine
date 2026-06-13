// SPDX-License-Identifier: Apache-2.0
#include "csv_to_latex.hpp"

#include <algorithm>
#include <fstream>
#include <map>
#include <set>
#include <sstream>
#include <unordered_map>

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

// WIDE-Schema (';'-getrennt). CR am Zeilenende (CRLF-Quellen) wird getrimmt.
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

// Nearest-Rank-Median (konsistent zur Mess-Seite, nearest_rank_p(0.5)); leere Stichprobe → 0.
[[nodiscard]] double nearest_rank_median(std::vector<double> v) {
    if (v.empty()) return 0.0;
    std::sort(v.begin(), v.end());
    std::size_t rank = static_cast<std::size_t>(0.5 * static_cast<double>(v.size() - 1) + 0.5);
    if (rank >= v.size()) rank = v.size() - 1;
    return v[rank];
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

int parse_wide_csv(std::filesystem::path const& in, std::vector<WideMeasurementRow>& out_rows) {
    std::ifstream f{in};
    if (!f) return status_io_error;
    std::string header_line;
    if (!std::getline(f, header_line)) return status_parse_error;

    // HEADER-GETRIEBEN: Spalten per Name auflösen (Reihenfolge-/Breite-agnostisch → robust gegen
    // additive Schema-Erweiterungen des Mess-Systems; Schema-Single-Source bleibt lazy_csv_header).
    auto const header = split_semicolons(header_line);
    std::unordered_map<std::string, std::size_t> col;
    for (std::size_t i = 0; i < header.size(); ++i) col.emplace(header[i], i);
    char const* required[] = {"binary_id", "repetition", "n_ops", "total_ns",
                              "ns_per_op", "workload", "two_phase_valid"};
    for (char const* name : required)
        if (col.find(name) == col.end()) return status_parse_error;

    std::string line;
    while (std::getline(f, line)) {
        if (line.empty() || line == "\r") continue;
        auto cols = split_semicolons(line);
        if (cols.size() != header.size()) return status_parse_error;
        try {
            WideMeasurementRow r;
            r.binary_id       = cols[col["binary_id"]];
            r.workload        = cols[col["workload"]];
            r.repetition      = std::stoull(cols[col["repetition"]]);
            r.n_ops           = std::stoull(cols[col["n_ops"]]);
            r.total_ns        = std::stoull(cols[col["total_ns"]]);
            r.ns_per_op       = std::stod(cols[col["ns_per_op"]]);
            r.two_phase_valid = (cols[col["two_phase_valid"]] == "1");
            // search_algo aus der binary_id: führendes "search_algo=<wert>/".
            constexpr std::string_view kPrefix = "search_algo=";
            if (r.binary_id.rfind(kPrefix, 0) == 0) {
                std::size_t const end = r.binary_id.find('/', kPrefix.size());
                r.search_algo = r.binary_id.substr(kPrefix.size(),
                    (end == std::string::npos ? r.binary_id.size() : end) - kPrefix.size());
            }
            out_rows.push_back(std::move(r));
        } catch (std::exception const&) {
            return status_parse_error;
        }
    }
    return status_ok;
}

std::vector<TierWorkloadAggregate> aggregate_tier_workload(std::span<WideMeasurementRow const> rows) {
    // Gruppieren über (search_algo × workload); NUR two_phase_valid-Zeilen (Mess-Gültigkeits-Filter —
    // ungültige Messungen fließen NIE in Thesis-Tabellen). std::map → deterministisch sortierte Ausgabe.
    std::map<std::pair<std::string, std::string>, std::vector<double>> groups;
    for (auto const& r : rows) {
        if (!r.two_phase_valid) continue;
        groups[{r.search_algo, r.workload}].push_back(r.ns_per_op);
    }
    std::vector<TierWorkloadAggregate> out;
    out.reserve(groups.size());
    for (auto& [key, samples] : groups) {
        TierWorkloadAggregate a;
        a.search_algo      = key.first;
        a.workload         = key.second;
        a.samples          = samples.size();
        a.median_ns_per_op = nearest_rank_median(std::move(samples));
        out.push_back(std::move(a));
    }
    return out;
}

int write_bias_matrix_latex(std::filesystem::path const& out, std::span<TierWorkloadAggregate const> aggs,
                            std::string const& caption, std::string const& label,
                            std::string const& lang) {
    std::ofstream f{out};
    if (!f) return status_io_error;

    std::set<std::string> algos, workloads;
    std::map<std::pair<std::string, std::string>, double> cell;
    for (auto const& a : aggs) {
        algos.insert(a.search_algo);
        workloads.insert(a.workload);
        cell[{a.search_algo, a.workload}] = a.median_ns_per_op;
    }

    std::string const corner = (lang == "de") ? "Suchverfahren" : "Search method";
    f << "% AUTO-GENERATED durch csv_to_latex::write_bias_matrix_latex (tier×workload WIDE-Schema; lang="
      << lang << ")\n";
    f << "% Zelle = Median ns/op (nearest-rank) über alle dyn-Settings × Wiederholungen, NUR two_phase_valid.\n";
    f << "\\begin{table}[!htbp]\n\\centering\n\\small\n";
    f << "\\resizebox{\\textwidth}{!}{%\n";   // 21 Lastprofil-Spalten → auf Textbreite skalieren
    f << "\\begin{tabular}{l";
    for (std::size_t i = 0; i < workloads.size(); ++i) f << "r";
    f << "}\n\\toprule\n";
    f << corner;
    for (auto const& w : workloads) f << " & \\rotatebox{60}{" << escape_latex(w) << "}";
    f << " \\\\\n\\midrule\n";
    for (auto const& algo : algos) {
        f << escape_latex(algo);
        for (auto const& w : workloads) {
            auto const it = cell.find({algo, w});
            if (it == cell.end()) f << " & --";
            else f << " & " << static_cast<std::uint64_t>(it->second + 0.5);
        }
        f << " \\\\\n";
    }
    f << "\\bottomrule\n\\end{tabular}%\n}\n";
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
