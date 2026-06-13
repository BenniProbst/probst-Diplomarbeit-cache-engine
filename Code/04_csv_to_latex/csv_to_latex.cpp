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

// L1: zerlegt eine "<a>/<b>/<c>"-Kette in Segmente (string_view, kein Heap je Segment).
[[nodiscard]] std::vector<std::string_view> split_slashes(std::string_view s) {
    std::vector<std::string_view> out;
    std::size_t start = 0;
    for (std::size_t i = 0; i < s.size(); ++i) {
        if (s[i] == '/') {
            out.push_back(s.substr(start, i - start));
            start = i + 1;
        }
    }
    out.push_back(s.substr(start));
    return out;
}

// L1: spaltet "<key>=<value>" am ERSTEN '='; fehlt '=', ist value leer. Idiom für binary_id- und
// setting-Segmente (value darf weitere '='/'.' enthalten → nur am ersten '=' trennen).
[[nodiscard]] std::pair<std::string_view, std::string_view> split_key_value(std::string_view seg) {
    std::size_t const eq = seg.find('=');
    if (eq == std::string_view::npos) return {seg, std::string_view{}};
    return {seg.substr(0, eq), seg.substr(eq + 1)};
}

// L1: letzter '.'-getrennter Bestandteil eines dyn-Dim-Keys ("concurrency.thread_count" → "thread_count").
// Robust gegen Wechsel des Gruppen-Präfixes; ohne '.' bleibt der Key unverändert.
[[nodiscard]] std::string_view dim_suffix_key(std::string_view key) {
    std::size_t const dot = key.rfind('.');
    return (dot == std::string_view::npos) ? key : key.substr(dot + 1);
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

std::vector<AxisAssignment> parse_axis_tuple(std::string_view binary_id) {
    // TIER-Identität: "<achse>=<wert>/<achse>=<wert>/…" → geordnetes, stabiles Tupel (binary_id-Reihenfolge).
    std::vector<AxisAssignment> out;
    if (binary_id.empty()) return out;
    auto const segments = split_slashes(binary_id);
    out.reserve(segments.size());
    for (auto seg : segments) {
        if (seg.empty()) continue;
        auto const [k, v] = split_key_value(seg);
        out.push_back(AxisAssignment{std::string{k}, std::string{v}});
    }
    return out;
}

TestdataConfig parse_testdata_config(std::string_view setting, std::uint64_t n_ops,
                                     bool has_records, std::uint64_t records) {
    // KONFIG-Tupel (vom Tier getrennt): dyn-Dims aus `setting` per Suffix-Key + eigene Spalten n_ops/records.
    TestdataConfig cfg;
    cfg.n_ops       = n_ops;
    cfg.has_records = has_records;
    cfg.records     = records;
    for (auto seg : split_slashes(setting)) {
        if (seg.empty()) continue;
        auto const [key, value] = split_key_value(seg);
        std::string_view const sk = dim_suffix_key(key);
        try {
            if (sk == "thread_count")           cfg.thread_count      = std::stoull(std::string{value});
            else if (sk == "prefetch_distance") cfg.prefetch_distance = std::stoull(std::string{value});
            else if (sk == "repetition_index")  cfg.repetition_index  = std::stoull(std::string{value});
            else if (sk == "workload_id")       cfg.workload_id       = std::string{value};
        } catch (std::exception const&) {
            // Unparsbarer dyn-Dim-Wert → Feld bleibt Default; KONFIG-Trennung bleibt intakt.
        }
    }
    return cfg;
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

    // L1: optionale Spalten EINMALIG auflösen (header-getrieben; npos = nicht vorhanden → Default).
    constexpr std::size_t kAbsent = static_cast<std::size_t>(-1);
    auto opt_col = [&](std::string_view name) -> std::size_t {
        auto const it = col.find(std::string{name});
        return it == col.end() ? kAbsent : it->second;
    };
    std::size_t const col_setting = opt_col("setting");
    std::size_t const col_records = opt_col("records");  // "falls vorhanden"
    // Op-Latenz-Spalten (op_<art>_{n,p50_ns,p99_ns}) je OpKind in fester Reihenfolge (kOpKindNames).
    std::array<std::array<std::size_t, 3>, kOpKindCount> op_col{};
    for (std::size_t k = 0; k < kOpKindCount; ++k) {
        std::string const base = "op_" + std::string{kOpKindNames[k]};
        op_col[k][0] = opt_col(base + "_n");
        op_col[k][1] = opt_col(base + "_p50_ns");
        op_col[k][2] = opt_col(base + "_p99_ns");
    }

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
            // L1: TIER-Tupel (19 Achsen) aus binary_id; search_algo bleibt bequemer Direkt-Accessor.
            r.axes        = parse_axis_tuple(r.binary_id);
            r.search_algo = std::string{r.axis_value("search_algo")};

            // L1: KONFIG-Tupel (dyn-Dims), strikt vom Tier getrennt. records optional ("falls vorhanden").
            std::string_view const setting =
                (col_setting != kAbsent) ? std::string_view{cols[col_setting]} : std::string_view{};
            bool const has_records = (col_records != kAbsent);
            std::uint64_t const records =
                has_records ? std::stoull(cols[col_records]) : 0ull;
            r.config = parse_testdata_config(setting, r.n_ops, has_records, records);

            // L1: per-Interface-Funktions-Latenzen (op_<art>_{n,p50_ns,p99_ns}); fehlende Spalte → Default.
            for (std::size_t k = 0; k < kOpKindCount; ++k) {
                OpLatency lat;
                if (op_col[k][0] != kAbsent) lat.n      = std::stoull(cols[op_col[k][0]]);
                if (op_col[k][1] != kAbsent) lat.p50_ns = std::stoll (cols[op_col[k][1]]);
                if (op_col[k][2] != kAbsent) lat.p99_ns = std::stoll (cols[op_col[k][2]]);
                r.op_latency[k] = lat;
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

std::vector<TierWorkloadOpAggregate>
aggregate_tier_workload_per_op(std::span<WideMeasurementRow const> rows) {
    // L1: je (binary_id × workload) und je Op-Art der nearest-rank-Median von p50_ns über NUR
    // two_phase_valid-Zeilen (dyn-Settings × Repetitionen zusammengefasst). std::map → deterministisch
    // sortierte Ausgabe. Op-Index = OpKind/kOpKindNames (Single-Source-Reihenfolge, konsistent zum Parser).
    // Sammler-Strategie: je Zelle ein Bucket pro Op-Art (Stichproben werden separat aggregiert).
    struct Bucket { std::array<std::vector<double>, kOpKindCount> p50; std::size_t samples = 0; };
    std::map<std::pair<std::string, std::string>, Bucket> groups;
    for (auto const& r : rows) {
        if (!r.two_phase_valid) continue;
        auto& b = groups[{r.binary_id, r.workload}];
        ++b.samples;
        for (std::size_t k = 0; k < kOpKindCount; ++k)
            if (r.op_latency[k].n != 0)  // nur ausgeführte Op-Arten fließen in den Median ein
                b.p50[k].push_back(static_cast<double>(r.op_latency[k].p50_ns));
    }
    std::vector<TierWorkloadOpAggregate> out;
    out.reserve(groups.size());
    for (auto& [key, bucket] : groups) {
        TierWorkloadOpAggregate a;
        a.binary_id = key.first;
        a.workload  = key.second;
        a.samples   = bucket.samples;
        for (std::size_t k = 0; k < kOpKindCount; ++k)
            a.median_p50_ns_per_op[k] = nearest_rank_median(std::move(bucket.p50[k]));
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
