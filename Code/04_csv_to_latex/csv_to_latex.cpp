// SPDX-License-Identifier: Apache-2.0
#include "csv_to_latex.hpp"

#include <algorithm>
#include <cstdint>
#include <cstdio>
#include <fstream>
#include <map>
#include <set>
#include <sstream>
#include <tuple>
#include <unordered_map>

namespace comdare::da::csv_to_latex {

namespace {

[[nodiscard]] std::vector<std::string> split_line(std::string const& line) {
    std::vector<std::string> out;
    std::string              cur;
    for (char c : line) {
        if (c == ',') {
            out.push_back(std::move(cur));
            cur.clear();
        } else
            cur.push_back(c);
    }
    out.push_back(std::move(cur));
    return out;
}

// WIDE-Schema (';'-getrennt). CR am Zeilenende (CRLF-Quellen) wird getrimmt.
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
    std::size_t                   start = 0;
    for (std::size_t i = 0; i < s.size(); ++i) {
        if (s[i] == ':') {
            out.push_back(s.substr(start, i - start));
            start = i + 1;
        }
    }
    out.push_back(s.substr(start));
    return out;
}

} // anonymous namespace

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
            r.permutation_id          = cols[0];
            r.fingerprint             = std::stoull(cols[1]);
            r.succeeded               = (cols[2] == "1");
            r.workload_used           = cols[3];
            r.op_count                = std::stoull(cols[4]);
            r.total_cycles            = std::stoull(cols[5]);
            r.cache_misses_l1         = std::stoull(cols[6]);
            r.cache_misses_l2         = std::stoull(cols[7]);
            r.cache_misses_l3         = std::stoull(cols[8]);
            r.dtlb_misses             = std::stoull(cols[9]);
            r.coherence_invalidations = std::stoull(cols[10]);
            r.energy_micro_joules     = std::stoull(cols[11]);
            r.bytes_allocated         = std::stoull(cols[12]);
            r.bytes_in_use_peak       = std::stoull(cols[13]);
            r.external_frag           = std::stod(cols[14]);
            r.internal_frag           = std::stod(cols[15]);
            out_rows.push_back(std::move(r));
        } catch (std::exception const&) { return status_parse_error; }
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
            default: out += c;
        }
    }
    return out;
}

int write_latex(std::filesystem::path const& out, std::span<CsvRow const> rows, std::string const& caption,
                std::string const& label, std::string const& lang) {
    std::ofstream f{out};
    if (!f) return status_io_error;

    // C2 (2026-06-01): bilinguale Spaltenkopf-Zeile. de = Diplomarbeit-Deutsch, sonst Englisch.
    std::string const header = (lang == "de") ? "Permutation & Ops & Zyklen & L1 & L2 & L3 \\\\\n"
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
        f << escape_latex(r.permutation_id) << " & " << r.op_count << " & " << r.total_cycles << " & "
          << r.cache_misses_l1 << " & " << r.cache_misses_l2 << " & " << r.cache_misses_l3 << " \\\\\n";
    }
    f << "\\bottomrule\n";
    f << "\\end{tabular}\n";
    f << "\\caption{" << escape_latex(caption) << "}%\n";
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
    auto const                                   header = split_semicolons(header_line);
    std::unordered_map<std::string, std::size_t> col;
    for (std::size_t i = 0; i < header.size(); ++i) col.emplace(header[i], i);
    char const* required[] = {"binary_id", "repetition", "n_ops",          "total_ns",
                              "ns_per_op", "workload",   "two_phase_valid"};
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
                r.search_algo         = r.binary_id.substr(
                    kPrefix.size(), (end == std::string::npos ? r.binary_id.size() : end) - kPrefix.size());
            }
            out_rows.push_back(std::move(r));
        } catch (std::exception const&) { return status_parse_error; }
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
                            std::string const& caption, std::string const& label, std::string const& lang) {
    std::ofstream f{out};
    if (!f) return status_io_error;

    std::set<std::string>                                 algos, workloads;
    std::map<std::pair<std::string, std::string>, double> cell;
    for (auto const& a : aggs) {
        algos.insert(a.search_algo);
        workloads.insert(a.workload);
        cell[{a.search_algo, a.workload}] = a.median_ns_per_op;
    }

    std::string const corner = (lang == "de") ? "Suchverfahren" : "Search method";
    f << "% AUTO-GENERATED durch csv_to_latex::write_bias_matrix_latex (tier×workload WIDE-Schema; lang=" << lang
      << ")\n";
    f << "% Zelle = Median ns/op (nearest-rank) über alle dyn-Settings × Wiederholungen, NUR two_phase_valid.\n";
    f << "\\begin{table}[!htbp]\n\\centering\n\\small\n";
    f << "\\resizebox{\\textwidth}{!}{%\n"; // 21 Lastprofil-Spalten → auf Textbreite skalieren
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
            if (it == cell.end())
                f << " & --";
            else
                f << " & " << static_cast<std::uint64_t>(it->second + 0.5);
        }
        f << " \\\\\n";
    }
    f << "\\bottomrule\n\\end{tabular}%\n}\n";
    f << "\\caption{" << escape_latex(caption) << "}%\n";
    f << "\\label{" << label << "}\n";
    f << "\\end{table}\n";
    return f.good() ? status_ok : status_io_error;
}

// ── L-d / L-e Implementierung (Phase L, 2026-06-18) ──────────────────────────────────────────────────────

namespace {

// Parst die binary_id (achse=wert/achse=wert/...) in eine (achse→wert)-Map. Wert = alles zwischen '=' und
// dem nächsten '/'. Wert-Präfixe (z.B. memory_layout=memory_layout_soa) bleiben unangetastet — verglichen
// wird die volle Wert-Zeichenkette, sodass Geschwister-Identität exakt ist.
[[nodiscard]] std::map<std::string, std::string> parse_axis_tuple(std::string const& binary_id) {
    std::map<std::string, std::string> axes;
    std::size_t                        pos = 0;
    while (pos < binary_id.size()) {
        std::size_t const slash = binary_id.find('/', pos);
        std::size_t const end   = (slash == std::string::npos) ? binary_id.size() : slash;
        std::string_view  token{binary_id.data() + pos, end - pos};
        std::size_t const eq = token.find('=');
        if (eq != std::string_view::npos) {
            axes.emplace(std::string{token.substr(0, eq)}, std::string{token.substr(eq + 1)});
        }
        if (slash == std::string::npos) break;
        pos = slash + 1;
    }
    return axes;
}

// p25/median/p75 (nearest-rank, konsistent zu nearest_rank_median) auf einer Kopie der Stichprobe.
struct Quartiles {
    double p25 = 0.0, p50 = 0.0, p75 = 0.0;
};
[[nodiscard]] Quartiles nearest_rank_quartiles(std::vector<double> v) {
    Quartiles q;
    if (v.empty()) return q;
    std::sort(v.begin(), v.end());
    auto pick = [&v](double p) {
        std::size_t rank = static_cast<std::size_t>(p * static_cast<double>(v.size() - 1) + 0.5);
        if (rank >= v.size()) rank = v.size() - 1;
        return v[rank];
    };
    q.p25 = pick(0.25);
    q.p50 = pick(0.50);
    q.p75 = pick(0.75);
    return q;
}

// 2 No-Op-Scan-Profile: bei scan-bezogenen Diffs auszuschließen (19 valide Workloads).
[[nodiscard]] bool is_noop_scan_workload(std::string const& w) { return w == "ycsb_e" || w == "lp_range_scan"; }

// Auswahl der Interface-Funktions-p50-Spalte einer Zeile (oder ns_per_op).
[[nodiscard]] double interface_value(WideFullRow const& r, std::string_view fn) {
    if (fn == "insert") return r.op_insert_p50;
    if (fn == "lookup") return r.op_lookup_p50;
    if (fn == "erase") return r.op_erase_p50;
    if (fn == "scan") return r.op_scan_p50;
    if (fn == "rmw") return r.op_rmw_p50;
    return r.ns_per_op; // "ns_per_op"
}

} // anonymous namespace

int parse_wide_csv_full(std::filesystem::path const& in, std::vector<WideFullRow>& out_rows) {
    std::ifstream f{in};
    if (!f) return status_io_error;
    std::string header_line;
    if (!std::getline(f, header_line)) return status_parse_error;

    // HEADER-GETRIEBEN (wie parse_wide_csv): Spalten per NAME auflösen → robust gegen Schema-Breite/-Ordnung.
    auto const                                   header = split_semicolons(header_line);
    std::unordered_map<std::string, std::size_t> col;
    for (std::size_t i = 0; i < header.size(); ++i) col.emplace(header[i], i);
    char const* required[] = {"binary_id",       "ns_per_op",        "workload",
                              "two_phase_valid", "op_insert_p50_ns", "op_lookup_p50_ns",
                              "op_erase_p50_ns", "op_scan_p50_ns",   "op_rmw_p50_ns"};
    for (char const* name : required)
        if (col.find(name) == col.end()) return status_parse_error;

    // INC-4: HEADER-GETRIEBEN ALLE stat_<achse>_<feld>-Spalten sammeln (Positions-agnostisch, Reihenfolge = Header).
    // NIE hartkodiert — die Namen kommen aus der WIDE-CSV, die die DLL aus der Single-Source kV3AxisSchema[17][8]
    // (M-4: 17 = kV3AxisCount, ABI-6/INC-2d)
    // emittiert. Fehlt der Block (altes 154-Spalten-Schema), bleibt stat_cols leer → r.stat leer (honest n/a).
    std::vector<std::pair<std::string, std::size_t>> stat_cols;
    for (std::size_t i = 0; i < header.size(); ++i)
        if (header[i].rfind("stat_", 0) == 0) stat_cols.emplace_back(header[i], i);

    std::string line;
    while (std::getline(f, line)) {
        if (line.empty() || line == "\r") continue;
        auto cols = split_semicolons(line);
        if (cols.size() != header.size()) return status_parse_error;
        try {
            WideFullRow r;
            r.binary_id       = cols[col["binary_id"]];
            r.workload        = cols[col["workload"]];
            r.two_phase_valid = (cols[col["two_phase_valid"]] == "1");
            r.ns_per_op       = std::stod(cols[col["ns_per_op"]]);
            r.op_insert_p50   = std::stod(cols[col["op_insert_p50_ns"]]);
            r.op_lookup_p50   = std::stod(cols[col["op_lookup_p50_ns"]]);
            r.op_erase_p50    = std::stod(cols[col["op_erase_p50_ns"]]);
            r.op_scan_p50     = std::stod(cols[col["op_scan_p50_ns"]]);
            r.op_rmw_p50      = std::stod(cols[col["op_rmw_p50_ns"]]);
            r.axes            = parse_axis_tuple(r.binary_id);
            // M3v2-Tag-Spalten OPTIONAL/header-getrieben (NIE in required[] → cowfix-v1 bricht nicht):
            // fehlt die Spalte (154-Spalten-cowfix), bleibt das Feld leer/0 (n/a). col.find() schützt
            // gegen Out-of-range — KEIN status_parse_error für fehlende m3v2-Spalten.
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
            // INC-4: die stat_<achse>_<feld>-Roh-Zellen durchreichen (Wert bleibt String — "n/a" ODER uint64; die
            // Ehrlichkeits-/Zerlegungs-Logik liegt beim Konsumenten write_axis_observer_detail_table).
            for (auto const& [name, idx] : stat_cols) r.stat.emplace(name, cols[idx]);
            out_rows.push_back(std::move(r));
        } catch (std::exception const&) { return status_parse_error; }
    }
    return status_ok;
}

std::vector<ExchangeAggregate> aggregate_exchange(std::span<WideFullRow const>   rows,
                                                  std::vector<SiblingPairCount>& out_counts) {
    out_counts.clear();

    // 1) Pro (binary_id × workload) den Median je Interface-Funktion + ns_per_op über alle Repetitionen
    //    bilden — NUR two_phase_valid. Erst danach Geschwister-Paare bilden (Paar = 2 Lebewesen, 1 Workload).
    //    Schlüssel: binary_id → (workload → (fn → Median)).
    std::map<std::string, std::map<std::string, std::map<std::string, double>>> cell;
    {
        std::map<std::tuple<std::string, std::string, std::string>, std::vector<double>> acc;
        // Achsen-Tupel je binary_id einmalig cachen.
        for (auto const& r : rows) {
            if (!r.two_phase_valid) continue;
            for (auto fn : kInterfaceFns)
                acc[{r.binary_id, r.workload, std::string{fn}}].push_back(interface_value(r, fn));
            acc[{r.binary_id, r.workload, "ns_per_op"}].push_back(r.ns_per_op);
        }
        for (auto& [key, samples] : acc) {
            auto const& [bid, wl, fn] = key;
            cell[bid][wl][fn]         = nearest_rank_median(std::move(samples));
        }
    }

    // binary_id → Achsen-Tupel (genau ein Tupel je distinkter binary_id).
    std::map<std::string, std::map<std::string, std::string>> tuple_of;
    for (auto const& r : rows) tuple_of.emplace(r.binary_id, r.axes);

    // 2) Je VARIABLER Achse a: alle binary_id-Paare finden, deren Tupel sich NUR in a unterscheiden.
    //    Aggregat-Schlüssel: (axis, v_from, v_to, fn) → Liste rel-Deltas + Liste abs-Deltas (über Paare×WL).
    //    v_from/v_to lexikographisch geordnet (kanonische Richtung → ein Eintrag je ungeordnetem Paar).
    struct Acc {
        std::vector<double> rel;
        std::vector<double> abs_;
    };
    std::map<std::tuple<std::string, std::string, std::string, std::string>, Acc> agg;

    std::vector<std::string> ids;
    ids.reserve(tuple_of.size());
    for (auto const& [bid, _] : tuple_of) ids.push_back(bid);

    for (auto axis_sv : kVariableAxes) {
        std::string const axis{axis_sv};
        std::size_t       pair_count = 0;
        for (std::size_t i = 0; i < ids.size(); ++i) {
            for (std::size_t j = i + 1; j < ids.size(); ++j) {
                auto const& ta = tuple_of[ids[i]];
                auto const& tb = tuple_of[ids[j]];
                // Geschwister-Test: identisch in ALLEN Achsen außer genau a (und a verschieden).
                bool sibling = true;
                for (auto const& [k, va] : ta) {
                    auto const it = tb.find(k);
                    if (it == tb.end()) {
                        sibling = false;
                        break;
                    }
                    if (k == axis) {
                        if (va == it->second) {
                            sibling = false;
                            break;
                        }
                    } else {
                        if (va != it->second) {
                            sibling = false;
                            break;
                        }
                    }
                }
                if (!sibling) continue;
                ++pair_count;

                std::string vf = ta.at(axis), vt = tb.at(axis);
                bool        swap_dir = (vf > vt);
                if (swap_dir) std::swap(vf, vt);
                std::string const& id_from = swap_dir ? ids[j] : ids[i];
                std::string const& id_to   = swap_dir ? ids[i] : ids[j];

                // Diff je Workload × Interface-Fn (+ ns_per_op). v_from = Bezugswert des rel-Deltas.
                auto const& cf = cell[id_from];
                auto const& ct = cell[id_to];
                for (auto const& [wl, fns_from] : cf) {
                    auto const wit = ct.find(wl);
                    if (wit == ct.end()) continue;
                    auto const& fns_to    = wit->second;
                    bool const  noop_scan = is_noop_scan_workload(wl);
                    auto        consider  = [&](std::string const& fn) {
                        // scan-bezogene Diffs in den 2 No-Op-Scan-Profilen ausschließen.
                        if (noop_scan && fn == "scan") return;
                        auto const a_it = fns_from.find(fn);
                        auto const b_it = fns_to.find(fn);
                        if (a_it == fns_from.end() || b_it == fns_to.end()) return;
                        double const base = a_it->second, other = b_it->second;
                        double const d = other - base;
                        // Anti-Phantom (M-SU-03): abs_ und rel zaehlen dieselbe (ausgeuebte) Population. Eine
                        // nicht-ausgeuebte Interface-Fn (base = 0 = „nicht ausgeuebt", Header) darf weder einen
                        // 0-0-Pseudo-Diff in abs_ druecken (sonst verwaessert median_abs_delta_ns gegenueber der
                        // ausgewiesenen n = pair_workload_samples = rel-Samples) noch eine leere Aggregat-Zelle
                        // anlegen. Zero-Baseline → kein rel-Delta, kein Eintrag.
                        if (base > 0.0) {
                            auto& slot = agg[{axis, vf, vt, fn}];
                            slot.abs_.push_back(d);
                            slot.rel.push_back(d / base);
                        }
                    };
                    for (auto fn : kInterfaceFns) consider(std::string{fn});
                    consider("ns_per_op");
                }
            }
        }
        out_counts.push_back({axis, pair_count});
    }

    std::vector<ExchangeAggregate> out;
    out.reserve(agg.size());
    for (auto& [key, a] : agg) {
        auto const& [axis, vf, vt, fn] = key;
        ExchangeAggregate e;
        e.axis                  = axis;
        e.value_from            = vf;
        e.value_to              = vt;
        e.interface_fn          = fn;
        e.pair_workload_samples = a.rel.size();
        e.median_abs_delta_ns   = nearest_rank_median(a.abs_);
        auto const q            = nearest_rank_quartiles(a.rel);
        e.median_rel_delta      = q.p50;
        e.iqr_rel_delta         = q.p75 - q.p25;
        out.push_back(std::move(e));
    }
    return out;
}

namespace {

// P1c (2026-08-06) -- exakte Richtungs-Umkehr des RELATIVEN Deltas.
// d = (m_to - m_from)/m_from, gesucht ist d' = (m_from - m_to)/m_to. Aus m_to/m_from = 1+d folgt
// d' = 1/(1+d) - 1 = -d/(1+d). Streng monoton fallend auf d > -1 -> bildet Median auf Median ab.
// Blosse Vorzeichen-Umkehr waere falsch (bei d=+1.0 lieferte sie -1.0 statt der korrekten -0.5).
[[nodiscard]] double flip_rel_delta(double d) { return -d / (1.0 + d); }

} // namespace

std::vector<ExchangeAggregate> select_exchange_vs_reference(std::span<ExchangeAggregate const> aggs,
                                                            std::string_view axis, std::string_view reference_value) {
    std::vector<ExchangeAggregate> out;
    for (auto const& a : aggs) {
        if (a.axis != axis) continue;
        bool const ref_is_from = (a.value_from == reference_value);
        bool const ref_is_to   = (a.value_to == reference_value);
        if (!ref_is_from && !ref_is_to) continue; // Paar beruehrt die Referenz nicht
        if (ref_is_from && ref_is_to) continue;   // entartetes Paar (kann aggregate_exchange nicht bilden)

        if (ref_is_from) { // kanonische Richtung passt bereits: Referenz steht links
            out.push_back(a);
            continue;
        }

        // Referenz steht rechts -> Paar drehen, damit sie IMMER value_from ist.
        // Die drei umzurechnenden Punkte sind der Median und die beiden Whisker-Endpunkte, die der
        // Forest-Plot ohnehin zeichnet (Median +- IQR/2). Alle drei muessen > -1 liegen (bei positiven
        // Latenz-Medianen immer erfuellt); sonst ist die Umrechnung undefiniert und das Paar wird HONEST
        // AUSGELASSEN statt mit einem erfundenen Wert gefuehrt.
        double const med = a.median_rel_delta;
        double const lo  = med - a.iqr_rel_delta / 2.0;
        double const hi  = med + a.iqr_rel_delta / 2.0;
        if (!(med > -1.0) || !(lo > -1.0) || !(hi > -1.0)) continue;

        ExchangeAggregate e   = a;
        e.value_from          = a.value_to; // = die Referenz
        e.value_to            = a.value_from;
        e.median_abs_delta_ns = -a.median_abs_delta_ns; // exakte Negation
        e.median_rel_delta    = flip_rel_delta(med);
        // f ist fallend -> f(hi) ist die neue untere, f(lo) die neue obere Grenze; die Breite ist ihr Abstand.
        e.iqr_rel_delta = std::abs(flip_rel_delta(lo) - flip_rel_delta(hi));
        out.push_back(std::move(e));
    }
    return out;
}

namespace {

// Vorbehalt-Klassifikation der 4 variablen Achsen (Plan-Default-Auflösung L-d.2).
[[nodiscard]] bool axis_has_q2_caveat(std::string const& axis) {
    return axis == "node_type" || axis == "memory_layout"; // Q2-Schritt-4-Beschattung möglich
}

// Anzeige-Reihenfolge der Interface-Funktionen in der Tabelle.
inline constexpr std::array<std::string_view, 6> kFnOrder = {"ns_per_op", "insert", "lookup", "erase", "scan", "rmw"};

[[nodiscard]] int fn_rank(std::string const& fn) {
    for (std::size_t i = 0; i < kFnOrder.size(); ++i)
        if (kFnOrder[i] == fn) return static_cast<int>(i);
    return 99;
}

// TODO-4/#154 L-i (2026-06-20): Breiten-sicherer Identifier in einer SCHMALEN p{}-Spalte. Die langen
// Achsen-Werte (z.B. memory_layout_aos_strict, ~24 Zeichen) haben in TeX an "\_" KEINEN Umbruchpunkt →
// 21pt-Overfull im p{2.2cm}-$v$/$v'$-Feld. Fix (kein neues Paket, NICHT die Vorlage anfassen): nach jedem
// escapeten "\_" ein "\allowbreak" injizieren → der Wert darf am Unterstrich umbrechen, kein Datenverlust.
[[nodiscard]] std::string breakable_identifier(std::string_view s) {
    std::string out = escape_latex(s);
    std::string res;
    res.reserve(out.size() + 16);
    for (std::size_t i = 0; i < out.size(); ++i) {
        res += out[i];
        if (i + 1 < out.size() && out[i] == '\\' && out[i + 1] == '_') {
            res += "_\\allowbreak{}"; // "\_" -> "\_\allowbreak{}"
            ++i;                      // das '_' bereits konsumiert
        }
    }
    return res;
}

} // anonymous namespace

int write_exchange_longtables(std::filesystem::path const& out_dir, std::span<ExchangeAggregate const> aggs,
                              std::span<SiblingPairCount const> counts, std::string const& lang) {
    bool const de = (lang == "de");

    // Paar-Zahl je Achse für die Fußnote nachschlagen.
    std::map<std::string, std::size_t> pairs_by_axis;
    for (auto const& c : counts) pairs_by_axis[c.axis] = c.pairs;

    for (auto axis_sv : kVariableAxes) {
        std::string const           axis{axis_sv};
        std::filesystem::path const out = out_dir / ("ld_exchange_" + axis + ".tex");
        std::ofstream               f{out};
        if (!f) return status_io_error;

        // Zeilen dieser Achse sammeln + sortieren (v_from, v_to, fn-Reihenfolge).
        std::vector<ExchangeAggregate> rows;
        for (auto const& a : aggs)
            if (a.axis == axis) rows.push_back(a);
        std::sort(rows.begin(), rows.end(), [](ExchangeAggregate const& x, ExchangeAggregate const& y) {
            if (x.value_from != y.value_from) return x.value_from < y.value_from;
            if (x.value_to != y.value_to) return x.value_to < y.value_to;
            return fn_rank(x.interface_fn) < fn_rank(y.interface_fn);
        });

        bool const        caveat = axis_has_q2_caveat(axis);
        std::string const conf =
            caveat ? (de ? "Vorbehalt" : "caveat") : (de ? "am wenigsten konfundiert" : "least confounded");

        f << "% AUTO-GENERATED durch csv_to_latex::write_exchange_longtables (L-d Achsen-Austauschbarkeit; "
          << "achse=" << axis << "; lang=" << lang << ")\n";
        f << "% Zeile = (Wertepaar v->v', Interface-Funktion); Delta = Median(rel. Delta ns/op bzgl. v) "
          << "ueber Geschwister-Paare x valide Lastprofile; nur two_phase_valid.\n";
        if (caveat)
            f << "% VORBEHALT-ACHSE: Q2-Schritt-4 search_organ_-Beschattung -> Apparat-Artefakt moeglich "
              << "(Plan-Default, NICHT entfernen).\n";
        else
            f << "% Diese Achse ist am wenigsten konfundiert (search_algo/prefetch).\n";

        std::string const cap =
            de ? ("Achsen-Austauschbarkeit: " + escape_latex(axis) +
                  " (Geschwister-Paar-Diffs, Median rel.\\ $\\Delta$ ns/op bzgl.\\ $v$; " +
                  std::to_string(pairs_by_axis[axis]) + " Geschwister-Paare; Konfundierung: " + conf + ")")
               : ("Axis exchangeability: " + escape_latex(axis) +
                  " (sibling-pair diffs, median rel.\\ $\\Delta$ ns/op w.r.t.\\ $v$; " +
                  std::to_string(pairs_by_axis[axis]) + " sibling pairs; confounding: " + conf + ")");

        std::string const colhead =
            de ? "$v$ & $v'$ & Funktion & Median abs.\\ $\\Delta$ (ns) & Median rel.\\ $\\Delta$ & IQR rel. & "
                 "$n$ & Diagnose \\\\"
               : "$v$ & $v'$ & function & median abs.\\ $\\Delta$ (ns) & median rel.\\ $\\Delta$ & IQR rel. & "
                 "$n$ & diagnostic \\\\";

        // Diagnose-Flag: verschiedene binary_id = nachweislich verschiedener Organ-Pfad (Audit-Meta-Lehre 3).
        std::string const diag_distinct = de ? "verschiedener Organ-Pfad" : "distinct organ path";
        std::string const diag_caveat =
            de ? "Vorbehalt: Q2-Schritt-4 search\\_organ\\_-Beschattung, Apparat-Artefakt moeglich"
               : "caveat: Q2 step-4 search\\_organ\\_ shadowing, apparatus artefact possible";

        f << "\\begin{scriptsize}\n";
        // TODO-4/#173 + #154 L-i (2026-06-20): breiten-sicher. Die 8-Spalten-longtable (2x p{2.2cm}
        // + 4 r + Diagnose-p{3.4cm}) lief 34.8pt ueber \textwidth (der Diagnose-Text + 6 inter-column
        // tabcolsep). Fix (gleicher \setlength-Decorator wie write_sweep_axis_longtable/seg_coverage):
        // tabcolsep 6pt->2pt (spart ~7*2*2pt) + Diagnose-Spalte 3.4cm->3.0cm. -> 0 Overfull.
        f << "\\setlength{\\tabcolsep}{2pt}\n";
        f << "\\begin{longtable}{@{}>{\\raggedright\\arraybackslash}p{2.2cm} "
          << ">{\\raggedright\\arraybackslash}p{2.2cm} l r r r r "
          << ">{\\raggedright\\arraybackslash}p{3.0cm}@{}}\n";
        f << "\\caption{" << cap << "}\\label{tab:ld:exchange:" << axis << "}\\\\\n";
        f << "\\toprule\n" << colhead << "\n\\midrule\n\\endfirsthead\n";
        f << "\\multicolumn{8}{c}{\\tablename\\ \\thetable{} -- " << (de ? "Fortsetzung" : "continued") << "}\\\\\n";
        f << "\\toprule\n" << colhead << "\n\\midrule\n\\endhead\n";
        f << "\\midrule\n\\multicolumn{8}{r}{" << (de ? "Fortsetzung n\\\"achste Seite" : "continued on next page")
          << "}\\\\\n\\endfoot\n";
        f << "\\bottomrule\n\\endlastfoot\n";

        for (auto const& a : rows) {
            // n=0 (kein definiertes rel-Delta, z.B. scan-only-Zellen mit durchweg 0-Baseline) NICHT als
            // „+0.000"-Zeile zeigen — das wäre irreführend (suggeriert „kein Unterschied"). Der scan-Vorbehalt
            // ist in der L-e-Limitierungs-Tabelle ehrlich dokumentiert (kein Befund verfällt still).
            if (a.pair_workload_samples == 0) continue;
            // Diagnose-Spalte: immer „verschiedener Organ-Pfad" + bei Vorbehalt-Achsen zusätzlich Marker.
            std::string diag = diag_distinct;
            if (caveat) diag += "; " + diag_caveat;
            f << breakable_identifier(a.value_from) << " & " << breakable_identifier(a.value_to) << " & "
              << escape_latex(a.interface_fn) << " & "
              << static_cast<std::int64_t>(a.median_abs_delta_ns >= 0 ? a.median_abs_delta_ns + 0.5
                                                                      : a.median_abs_delta_ns - 0.5);
            // rel-Delta + IQR mit fester Genauigkeit (Dezimalpunkt; sprachneutral belassen).
            char buf[64];
            std::snprintf(buf, sizeof(buf), "%+.3f", a.median_rel_delta);
            f << " & " << buf;
            std::snprintf(buf, sizeof(buf), "%.3f", a.iqr_rel_delta);
            f << " & " << buf << " & " << a.pair_workload_samples << " & " << diag << " \\\\\n";
        }

        f << "\\end{longtable}\n\\end{scriptsize}\n";
        if (!f.good()) return status_io_error;
    }
    return status_ok;
}

namespace {

// P5: 4-Nachkomma-Formatierung (Dezimalpunkt, sprachneutral wie fmt_double in 05).
[[nodiscard]] std::string fmt4(double d) {
    char buf[64];
    std::snprintf(buf, sizeof(buf), "%.4f", d);
    return buf;
}

// P5: Forest-Zeile = EIN (Achse × Wertepaar v→v')-Aggregat der ns_per_op-Headline.
struct ForestRow {
    std::string axis;
    std::string value_from;
    std::string value_to;
    double      median_rel_delta = 0.0; // Punkt-x (real, aus ExchangeAggregate)
    double      iqr_rel_delta    = 0.0; // Whisker-Breite (p75-p25, real)
    std::size_t n                = 0;   // pair_workload_samples
    bool        small_n          = false;
};

} // anonymous namespace

int write_exchange_forest_plot(std::filesystem::path const& out, std::span<ExchangeAggregate const> aggs,
                               std::span<SiblingPairCount const> counts, std::string const& lang, bool body_only,
                               std::size_t small_n_threshold, std::string_view reference_value) {
    bool const de = (lang == "de");
    // P1c: leer = Bestandsverhalten (Geschwister-Paare untereinander). Gesetzt = alle Zeilen sind bereits
    // auf DIESE Referenz-Achsenauspraegung gedreht (select_exchange_vs_reference), die Beschriftung muss
    // das sagen -- sonst stuenden zwei optisch gleiche Figuren mit verschiedener Aussage im Anhang.
    bool const        vs_ref  = !reference_value.empty();
    std::string const ref_tex = vs_ref ? escape_latex(std::string{reference_value}) : std::string{};

    // 1) NUR die ns_per_op-Headline; je Achse (kVariableAxes-Reihenfolge) die Wertepaare sortiert. n=0-Aggregate
    //    (kein definiertes rel-Delta, z.B. durchweg Zero-Baseline) werden NIE als „+0"-Zeile aufgenommen (Phantom).
    std::vector<ForestRow> rows;
    for (auto axis_sv : kVariableAxes) {
        std::string const      axis{axis_sv};
        std::vector<ForestRow> per_axis;
        for (auto const& a : aggs) {
            if (a.axis != axis) continue;
            if (a.interface_fn != "ns_per_op") continue;
            if (a.pair_workload_samples == 0) continue; // kein Befund → keine Phantom-Zeile
            per_axis.push_back({axis, a.value_from, a.value_to, a.median_rel_delta, a.iqr_rel_delta,
                                a.pair_workload_samples, a.pair_workload_samples < small_n_threshold});
        }
        std::sort(per_axis.begin(), per_axis.end(), [](ForestRow const& x, ForestRow const& y) {
            if (x.value_from != y.value_from) return x.value_from < y.value_from;
            return x.value_to < y.value_to;
        });
        for (auto& r : per_axis) rows.push_back(std::move(r));
    }
    if (rows.empty()) return status_empty_input; // ehrlich leer, KEIN leerer Plot (Datei wird nicht angelegt)

    std::size_t const N = rows.size();

    // 2) x-Skala aus den VALIDEN (nicht-kleine-n) Zeilen ableiten, 0 stets einschliessen. So bestimmen die
    //    Division-durch-~0-Ausreisser kleiner n NICHT die Skala (sie werden ausgegraut + ggf. am Rand geklemmt).
    double lo = 0.0, hi = 0.0;
    bool   init   = false;
    auto   extend = [&](ForestRow const& r) {
        double const a = r.median_rel_delta - r.iqr_rel_delta / 2.0;
        double const b = r.median_rel_delta + r.iqr_rel_delta / 2.0;
        if (!init) {
            lo   = a;
            hi   = b;
            init = true;
        } else {
            lo = std::min(lo, a);
            hi = std::max(hi, b);
        }
    };
    bool any_valid = false;
    for (auto const& r : rows)
        if (!r.small_n) {
            extend(r);
            any_valid = true;
        }
    if (!any_valid) // nur kleine-n-Zeilen: dann deren Spanne nehmen (sonst leere Skala)
        for (auto const& r : rows) extend(r);
    lo          = std::min(lo, 0.0); // 0-Referenzlinie MUSS im Sichtfenster liegen (sonst geklemmt)
    hi          = std::max(hi, 0.0);
    double span = hi - lo;
    if (span <= 0.0) span = 1.0;
    double const pad  = 0.08 * span;
    double const xmin = lo - pad;
    double const xmax = hi + pad;

    // y-Layout: erste Zeile oben (y = N-1), letzte unten (y = 0).
    auto y_of = [N](std::size_t display_index) { return static_cast<double>(N - 1 - display_index); };

    std::size_t n_small = 0;
    for (auto const& r : rows)
        if (r.small_n) ++n_small;

    std::ofstream f{out};
    if (!f) return status_io_error;

    f << "% AUTO-GENERATED durch csv_to_latex::write_exchange_forest_plot (P5 Achsen-Austauschbarkeit; "
      << "ns_per_op-Headline; lang=" << lang << ")\n";
    f << "% Punkt = Median rel. Delta ns/op (bzgl. v); Whisker = IQR (p75-p25) symmetrisch um den Median (das\n";
    f << "% Aggregat traegt NUR die IQR-Breite, nicht p25/p75 → Balken konstruktionsbedingt symmetrisch). Nur\n";
    f << "% reale Aggregat-Werte (aggregate_exchange); kleine n (< " << small_n_threshold
      << ") ausgegraut. n=0 nicht gezeigt.\n";
    f << "% Zeilen=" << N << "; davon kleine-n=" << n_small << ". 0-Linie = keine Aenderung.\n";

    if (!body_only) { f << "\\begin{figure}[!htbp]\n\\centering\n"; }
    // Breiten-sicher wie die 05-pgfplots-Emitter (resizebox-Decorator um das tikzpicture).
    f << "\\resizebox{\\textwidth}{!}{%\n";
    f << "\\begin{tikzpicture}\n";
    // Farb-Klassen (ColorBrewer-nah, CVD-tauglich; Vorzeichen zusaetzlich durch Position rechts/links der
    // 0-Linie kodiert → nicht farb-only). Marker-Form kodiert Validitaet redundant (voll * vs. offen o).
    f << "\\definecolor{fpimprove}{RGB}{27,158,119}\n"; // Verbesserung (Delta<0)
    f << "\\definecolor{fpregress}{RGB}{215,48,39}\n";  // Regression (Delta>=0)
    f << "\\definecolor{fpsmalln}{RGB}{150,150,150}\n"; // kleine n (unzuverlaessig)
    f << "\\definecolor{fpzero}{RGB}{120,120,120}\n";   // 0-Referenzlinie
    f << "\\begin{axis}[\n";
    f << "    width=0.86\\textwidth,\n";
    f << "    height=" << fmt4(1.8 + 0.55 * static_cast<double>(N)) << "cm,\n";
    f << "    xmin=" << fmt4(xmin) << ", xmax=" << fmt4(xmax) << ",\n";
    f << "    ymin=-0.7, ymax=" << fmt4(static_cast<double>(N - 1) + 0.7) << ",\n";
    f << "    ytick={";
    for (std::size_t t = 0; t < N; ++t) {
        if (t > 0) f << ",";
        f << t;
    }
    f << "},\n";
    // yticklabels aufsteigend (y=0..N-1): bei y=t steht die Anzeige-Zeile display_index = N-1-t.
    f << "    yticklabels={";
    for (std::size_t t = 0; t < N; ++t) {
        std::size_t const di = N - 1 - t;
        auto const&       r  = rows[di];
        if (t > 0) f << ",";
        f << "{" << escape_latex(r.axis) << ": " << breakable_identifier(r.value_from) << " $\\rightarrow$ "
          << breakable_identifier(r.value_to) << "}";
    }
    f << "},\n";
    f << "    y tick label style={font=\\tiny},\n";
    f << "    x tick label style={font=\\tiny},\n";
    f << "    xlabel={"
      << (vs_ref
              ? (de ? ("Median rel.\\ $\\Delta$ ns/op (bzgl.\\ Referenz \\texttt{" + ref_tex + "}; $<0$ = schneller)")
                    : ("median rel.\\ $\\Delta$ ns/op (w.r.t.\\ reference \\texttt{" + ref_tex + "}; $<0$ = faster)"))
              : std::string{de ? "Median rel.\\ $\\Delta$ ns/op (bzgl.\\ $v$; $<0$ = schneller)"
                               : "median rel.\\ $\\Delta$ ns/op (w.r.t.\\ $v$; $<0$ = faster)"})
      << "},\n";
    f << "    xlabel style={font=\\footnotesize},\n";
    f << "    title={"
      << (vs_ref ? (de ? ("Vergleich gegen Referenz \\texttt{" + ref_tex + "} (Forest-Plot, ns/op-Headline)")
                       : ("Comparison against reference \\texttt{" + ref_tex + "} (forest plot, ns/op headline)"))
                 : std::string{de ? "Achsen-Austauschbarkeit (Forest-Plot, ns/op-Headline)"
                                  : "Axis exchangeability (forest plot, ns/op headline)"})
      << "},\n";
    f << "    title style={font=\\footnotesize},\n";
    f << "    xmajorgrids=true,\n";
    f << "    major grid style={gray!25},\n";
    f << "    tick align=outside,\n";
    f << "    mark size=2.2pt,\n";
    f << "    legend style={font=\\tiny, at={(0.99,0.02)}, anchor=south east, legend cell align=left},\n";
    f << "    clip=true,\n";
    f << "]\n";

    // 0-Referenzlinie (keine Aenderung). Numerische x/y → robust; MUSS im Sichtfenster liegen (xmin<=0<=xmax).
    f << "% P5-0-REFERENZLINIE (keine Aenderung, Delta=0)\n";
    f << "\\draw[color=fpzero, dashed, line width=0.8pt] (axis cs:0," << fmt4(-0.7) << ") -- (axis cs:0,"
      << fmt4(static_cast<double>(N - 1) + 0.7) << ");\n";

    // Drei Vorzeichen-/Validitaets-Klassen als getrennte \addplot (klare Farbe + Marker + eigene Whisker-Stile).
    // Reihenfolge fix: improvement, regression, small-n (Test-stabil ueber die % P5-CLASS-Marker).
    auto emit_class = [&](char const* tag, char const* color, char const* mark, char const* extra,
                          auto pred) -> std::size_t {
        std::vector<ForestRow const*> sel;
        for (std::size_t di = 0; di < N; ++di)
            if (pred(rows[di])) sel.push_back(&rows[di]);
        if (sel.empty()) return 0;
        f << "% P5-CLASS " << tag << "\n";
        f << "\\addplot[only marks, mark=" << mark << ", color=" << color << ", " << extra << ",\n";
        f << "    error bars/.cd, x dir=both, x explicit, error bar style={line width=0.6pt, color=" << color << "}]\n";
        f << "coordinates {\n";
        for (auto const* rp : sel) {
            // display_index rekonstruieren (Pointer-Distanz in rows) → korrekte y-Koordinate.
            std::size_t const di   = static_cast<std::size_t>(rp - &rows[0]);
            double const      yv   = y_of(di);
            double const      half = rp->iqr_rel_delta / 2.0; // Whisker = IQR, symmetrisch um den Median
            f << "    (" << fmt4(rp->median_rel_delta) << "," << fmt4(yv) << ") +- (" << fmt4(half) << ",0)\n";
        }
        f << "};\n";
        return sel.size();
    };

    std::size_t const n_imp = emit_class("improvement", "fpimprove", "*", "fill=fpimprove",
                                         [](ForestRow const& r) { return !r.small_n && r.median_rel_delta < 0.0; });
    std::size_t const n_reg = emit_class("regression", "fpregress", "*", "fill=fpregress",
                                         [](ForestRow const& r) { return !r.small_n && r.median_rel_delta >= 0.0; });
    std::size_t const n_sml =
        emit_class("smalln", "fpsmalln", "o", "densely dotted", [](ForestRow const& r) { return r.small_n; });

    // Legende NUR fuer real vorhandene Klassen (kein Phantom-Eintrag).
    if (n_imp > 0)
        f << "\\addlegendentry{" << (de ? "Verbesserung ($\\Delta<0$)" : "improvement ($\\Delta<0$)") << "}\n";
    if (n_reg > 0)
        f << "\\addlegendentry{" << (de ? "Regression ($\\Delta\\ge 0$)" : "regression ($\\Delta\\ge 0$)") << "}\n";
    if (n_sml > 0)
        f << "\\addlegendentry{" << (de ? "kleine $n$ (unzuverl\\\"assig)" : "small $n$ (unreliable)") << "}\n";

    f << "\\end{axis}\n\\end{tikzpicture}\n";
    f << "}%\n"; // resizebox

    if (!body_only) {
        std::string const cap =
            de ? ("Achsen-Austauschbarkeit als Forest-Plot (ns/op-Headline): Punkt = Median rel.\\ $\\Delta$ ns/op "
                  "je Geschwister-Wertepaar $v\\rightarrow v'$ (bzgl.\\ $v$), Whisker = IQR (p75-p25, symmetrisch "
                  "um den Median). Vertikale Linie = Referenz (kein Effekt, $\\Delta=0$); links = schneller "
                  "(Verbesserung), rechts = langsamer (Regression). Ausgegraut = kleine Stichprobe "
                  "($n<" +
                  std::to_string(small_n_threshold) +
                  "$ Paar-Lastprofil-Diffs, Division-durch-$\\approx$0-"
                  "instabil). Nur reale Aggregat-Werte; visuelle Erg\\\"anzung zu den ld\\_exchange-Longtables.")
               : ("Axis exchangeability as forest plot (ns/op headline): point = median rel.\\ $\\Delta$ ns/op "
                  "per sibling value pair $v\\rightarrow v'$ (w.r.t.\\ $v$), whisker = IQR (p75-p25, symmetric "
                  "about the median). Vertical line = reference (no effect, $\\Delta=0$); left = faster "
                  "(improvement), right = slower (regression). Greyed = small sample "
                  "($n<" +
                  std::to_string(small_n_threshold) +
                  "$ pair-workload diffs, division-by-$\\approx$0 "
                  "unstable). Only real aggregate values; visual complement to the ld\\_exchange longtables.");
        // P1c: die referenz-bezogene Variante bekommt einen eigenen Caption-Zusatz UND ein eigenes \label.
        // Der Zusatz benennt die Referenz als ACHSENAUSPRAEGUNG -- im Korpus existiert KEINE std::map-
        // Leistungsserie (jedes std::map dort ist das Konformitaets-Oracle des Pruefdocks), eine
        // "gegen std::map"-Behauptung waere also frei erfunden.
        std::string const cap_full =
            vs_ref ? (cap + (de ? (" ALLE Zeilen sind auf die Referenz-Achsenauspraegung \\texttt{" + ref_tex +
                                   "} gedreht: $v$ ist durchweg die Referenz, $v'$ die verglichene "
                                   "Auspraegung. Die Referenz ist eine gemessene Achsenauspraegung, "
                                   "KEINE externe Bibliotheks-Baseline.")
                                : (" All rows are oriented towards the reference axis value \\texttt{" + ref_tex +
                                   "}: $v$ is always the reference, $v'$ the compared value. The reference is a "
                                   "measured axis value, NOT an external library baseline.")))
                   : cap;
        f << "\\caption{" << cap_full << "}\\label{fig:ld:exchange:forest" << (vs_ref ? ":ref" : "")
          << "}\n\\end{figure}\n";
    }

    return f.good() ? status_ok : status_io_error;
}

int write_limitations_longtable(std::filesystem::path const& out, std::string const& lang) {
    std::ofstream f{out};
    if (!f) return status_io_error;
    bool const de = (lang == "de");

    f << "% AUTO-GENERATED durch csv_to_latex::write_limitations_longtable (L-e ehrliche Limitierung; lang=" << lang
      << ")\n";
    f << "% EINE longtable, je Zeile EIN nicht-gefixter Vorbehalt. Zeile 1 = Cache-Misses/PMC (Kernmetrik).\n";

    std::string const cap = de ? "Ehrliche Limitierungen: nicht-gefixte Vorbehalte (kein Befund verf\\\"allt still)"
                               : "Honest limitations: unresolved caveats (no finding silently lapses)";
    std::string const colhead =
        de ? "\\# & Vorbehalt & Status / Konsequenz \\\\" : "\\# & Caveat & Status / consequence \\\\";

    f << "\\begin{scriptsize}\n";
    f << "\\begin{longtable}{@{}r >{\\raggedright\\arraybackslash}p{5.0cm} "
      << ">{\\raggedright\\arraybackslash}p{8.0cm}@{}}\n";
    f << "\\caption{" << cap << "}\\label{tab:le:limitierung}\\\\\n";
    f << "\\toprule\n" << colhead << "\n\\midrule\n\\endfirsthead\n";
    f << "\\multicolumn{3}{c}{\\tablename\\ \\thetable{} -- " << (de ? "Fortsetzung" : "continued")
      << "}\\\\\n\\toprule\n"
      << colhead << "\n\\midrule\n\\endhead\n";
    f << "\\midrule\n\\multicolumn{3}{r}{" << (de ? "Fortsetzung n\\\"achste Seite" : "continued on next page")
      << "}\\\\\n\\endfoot\n\\bottomrule\n\\endlastfoot\n";

    // Zeilen als (Vorbehalt, Status)-Paare. Reihenfolge bindend: Zeile 1 = Cache-Misses/PMC.
    // trailer: optionaler Kommentar HINTER dem LaTeX-Zeilenende. Er traegt die chktex-Inline-
    // Ausnahmen, die einzelne Zeilen brauchen (projekteigener Weg, s. 17 .tex-Dateien im Bestand).
    // OHNE ihn verliert ein Generatorlauf die Suppression und lint:latex geht rot -- genau die
    // Rueckdreh-Falle, wegen der dieser Generator am 07.08.2026 nachgezogen wurde.
    struct Row {
        std::string caveat;
        std::string status;
        std::string trailer;
    };
    std::vector<Row> rows;

    if (de) {
        rows.push_back(
            {"\\textbf{Cache-Misses (Kernmetrik):} L2 + Coherence strukturell 0; L1/L3/dTLB nur mit gesetztem "
             "PMC-Schalter erhoben; Energy best-effort",
             "Ohne \\texttt{COMDARE\\_ENABLE\\_PMC} (Build-Default OFF, damit \\texttt{test:unit} ohne "
             "HW-Zugriff baut) liefert \\texttt{NullPmcSource} available=false, und alle HW-Spalten bleiben 0 "
             "-- so entstanden die tabellierten Nullen. Mit dem Schalter erhebt \\texttt{LinuxPerfPmcSource} "
             "L1-, L3- (Last-Level) und dTLB-Misses real \\\"uber \\texttt{perf\\_event\\_open}(2) "
             "(Kernel-Syscall, keine Vendor-Lib, kein PAPI n\\\"otig -- PAPI bleibt optionaler "
             "Sekund\\\"arpfad). L2 und Coherence-Invalidierungen bleiben mangels portablem generischem "
             "Z\\\"ahler auch dann strukturell 0; L3 kann auf einzelnen AMD-Plattformen zus\\\"atzlich beim "
             "\\\"Offnen des Z\\\"ahlers scheitern; Energie l\\\"auft best-effort \\\"uber RAPL-sysfs und "
             "bleibt ohne Zonen-Leserecht leer. Der Intel-PCM-Windows-Treiber steht f\\\"ur die Windows-Lane "
             "weiterhin aus (\\#26/P4). Die verbleibende L2/Coherence-L\\\"ucke ist nur indirekt \\\"uber den "
             "Wall-Clock-Proxy (seg\\_memory\\_layout\\_ns/ns\\_per\\_op) beobachtbar."});
        rows.push_back({"14 gepinnte Achsen = 0 Austauschbarkeits-Belege",
                        "Nur 4 der 18 Kompositions-Achsen variieren (search\\_algo, node\\_type, memory\\_layout, "
                        "prefetch). Gepinnt (je 1 Wert): cache\\_traversal, mapping, path\\_compression, allocator, "
                        "concurrency, serialization, value\\_handle, index\\_organization, io\\_dispatch, "
                        "migration\\_policy, filter, queuing\\_q1, queuing\\_q2, persistence\\_target. (isa ist seit "
                        "INC-2d die System-Achse \\texttt{target\\_isa} und telemetry seit INC-2c keine "
                        "binary\\_id-Kompositions-Achse mehr -- beide z\\\"ahlen daher nicht mehr als gepinnte "
                        "Organ-Achsen.)",
                        "% chktex 12 (Satzende vor Klammer -- kein Abkuerzungspunkt)"});
        rows.push_back(
            {"Observer-Proben-Z\\\"ahler ($\\ast$\\_find/$\\ast$\\_probe/$\\ast$\\_get) by-design $\\approx 1$",
             "Erwartetes Verhalten, kein Phantom: je Lookup eine Probe. Keine Aussage \\\"uber interne Iterationen."});
        rows.push_back({"Honest-0 inaktiver Sub-Features gepinnter Strategien",
                        "concurrency/migration/io/value\\_handle melden 0 (Feature inaktiv), nicht Mess-Fehler."});
        rows.push_back(
            {"Wall-Clock nicht bit-reproduzierbar",
             "Seed steuert Keys (deterministisch), NICHT das CPU-Timing; Wall-Clock variiert lauf-zu-lauf."});
        rows.push_back(
            {"RC-Dimension nur nominal",
             "K1: $\\times 18 \\to \\times 3$ degeneriert; RC-Achse liefert keine volle Auspr\\\"agungs-Breite."});
        rows.push_back(
            {"2/21 Scan-Profile = No-Op (ausgeschlossen)",
             "ycsb\\_e und lp\\_range\\_scan f\\\"uhren keinen echten Scan aus; bei scan-Diffs ausgeschlossen "
             "(19 valide Lastprofile)."});
        rows.push_back(
            {"Insert-Profile messen Upserts; stat\\_$\\ast$-Spalten enthalten Load-Phase",
             "Insert-Pfad ist faktisch Upsert; die stat\\_$\\ast$-Z\\\"ahler akkumulieren die Lade-Phase mit."});
        rows.push_back(
            {"prefetch misst Key-Werte als Pseudo-Adressen (K9)",
             "Prefetch-Achse interpretiert Schl\\\"ussel-Werte als Adressen; kein echter Speicher-Prefetch."});
        rows.push_back(
            {"node\\_type + memory\\_layout: Q2-Schritt-4-Beschattung",
             "Apparat-Artefakt m\\\"oglich (search\\_organ\\_-Beschattung); search\\_algo + prefetch sind am "
             "wenigsten konfundiert."});
        // #226 (2026-06-28): #211 container_-Spiegel-Rebuild — in cowfix-v1 (Weg-B) wirksam, bis-M3 ungefixt.
        // Distinkt von der Q2-Beschattung (Observer-Slot) oben: dies betrifft die ns_per_op-Ueberhoehung.
        // Codex-praezisiert: nur NEU-Inserts + erfolgreiche Erases bauen um; Ausschluss = der ZUSATZ-Spiegel
        // (Weg-A nutzt denselben O(n)-Rebuild als ECHTEN Struktur-Kosten, nicht als Artefakt).
        rows.push_back(
            {"container\\_-Spiegel (Weg-B): O(n)-Flatten+Rebuild als Zusatz-Apparat",
             "Weg-B-Lebewesen (SOTA-B\\\"aume/Tries/Hash) halten neben dem echten Such-Organ einen sortierten "
             "container\\_-Spiegel; dessen O(n)-Flatten+Rebuild (bei NEU-Inserts + erfolgreichen Erases; \\#211, "
             "bis-M3 ungefixt) ist ZUS\\\"ATZLICHER Apparat-Aufwand, den die echte Baumstruktur nicht hat $\\to$ die "
             "gemessene ns\\_per\\_op der Weg-B-Tiere ist um diesen Spiegel-Anteil \\\"uberh\\\"oht. (Bei der Weg-A-"
             "Array-Familie ist derselbe O(n)-Rebuild der ECHTE Struktur-Kostenanteil, kein Zusatz-Artefakt.) "
             "Behebung mit \\#188/\\#211 + Nachfolge-Neubau (\\#215)."});
        rows.push_back({"memory\\_layout-Effekt teils sub-noise",
                        "Teil der Layout-Differenzen liegt unter dem Mess-Rauschen $\\to$ PMC extern-gated (\\#26)."});
        // Audit A1 / MINOR-MESS-04+09 (uint16-Saturierung): die SEKUNDAEREN, gepinnten Indirektions-Organe
        // (cache\_traversal/mapping) tragen schmalere key\_type/slot\_index\_type als der uint64-Primaerschluessel;
        // im tier\_insert wird der uint64-Key per static\_cast dorthin verengt → bei records > Typbreite kollidieren
        // ihre Beobachter-Eintraege (low-bits). Ehrlich, weil diese Achsen gepinnt + Observer-only sind (s. Zeile 2/4).
        rows.push_back(
            {"Sekund\\\"are Indirektions-Organe (cache\\_traversal/mapping): uint16-Schl\\\"ussel-S\\\"attigung",
             "Der uint64-Prim\\\"arschl\\\"ussel wird beim Auto-Koppeln in die schmaleren "
             "slot\\_index/key\\_type-Felder "
             "der GEPINNTEN cache\\_traversal-/mapping-Organe verengt (low-bits); bei records $>$ Typbreite "
             "kollidieren "
             "deren Observer-Eintr\\\"age. Betrifft NICHT den Prim\\\"ar-Lookup (uint64); reine Observer-Limitierung "
             "gepinnter Achsen (vgl. Zeile 2/4)."});
        // Audit A1 / MINOR-MESS-02-Rest: nach aussen propagiertes OOM wird jetzt two\_phase\_valid=false (gefixt);
        // ein vom Tier INTERN via catch(...) verschluckter OOM bleibt als ehrliche Restlimitierung.
        rows.push_back(
            {"Kapsel-internes (verschlucktes) OOM in einer Mess-Op",
             "Nach aussen geworfenes OOM entwertet die Messung jetzt hart (two\\_phase\\_valid=false). Ein vom "
             "Tier-Code INTERN per catch(...) gefangenes OOM (z.B. defensiver Memento-Verzicht) ist von aussen nicht "
             "beobachtbar → konservativ als Restvorbehalt dokumentiert, nicht erzwungen."});
        // G5-Audit (w289llo0o): de
        rows.push_back(
            {"Timer-Overhead (\\texttt{clock::now()}) nicht kalibriert",
             "Die Wall-Clock-Segmentzeiten enthalten den nicht subtrahierten Eigen-Overhead der "
             "\\texttt{std::chrono::steady\\_clock::now()}-Aufrufe (eine additive, lauf-stabile ns-Komponente je "
             "gemessenem Segment). Es findet KEINE Leer-Schleifen-Kalibrierung statt $\\to$ dokumentierter Vorbehalt; "
             "betrifft den absoluten ns-Nullpunkt, nicht die relativen Achsen-Vergleiche (G5-Audit, MESS-MINOR-7)."});
        rows.push_back({"Entwurfs-Etiketten = Namenskonvention, kein Mess-Einfluss",
                        "Einzelne Pattern-Etiketten im Code/Doku sind Benennungs-/Entwurfsvorbehalte ohne "
                        "Mess-Wirkung: „hybrider Visitor\" (real ein Memento, kein \\texttt{accept()}/Host-Besuch), "
                        "sowie Interpreter-/Template-/Decorator-Etiketten und \\texttt{reserve}-/\\texttt{if "
                        "constexpr}-Hygiene. Reine Naming-Konvention $\\to$ als Vorbehalt dokumentiert, kein Einfluss "
                        "auf Messwerte (G5-Audit, PATTERN-MINOR-1..7)."});
    } else {
        rows.push_back(
            {"\\textbf{Cache misses (core metric):} L2 + coherence structurally 0; L1/L3/dTLB only collected "
             "with the PMC switch set; energy best-effort",
             "Without \\texttt{COMDARE\\_ENABLE\\_PMC} (build default OFF, so that \\texttt{test:unit} builds "
             "without HW access) \\texttt{NullPmcSource} reports available=false and all HW columns stay 0 --- "
             "that is how the tabulated zeros arose. With the switch, \\texttt{LinuxPerfPmcSource} collects "
             "L1, L3 (last-level) and dTLB misses for real via \\texttt{perf\\_event\\_open}(2) (kernel "
             "syscall, no vendor library, no PAPI required --- PAPI remains an optional secondary path). L2 "
             "and coherence invalidations stay structurally 0 even then, for lack of a portable generic "
             "counter; L3 can additionally fail to open on individual AMD platforms; energy runs best-effort "
             "via RAPL sysfs and stays empty without read access to the zone. The Intel PCM Windows driver is "
             "still pending for the Windows lane (\\#26/P4). The remaining L2/coherence gap is observable only "
             "indirectly via the wall-clock proxy (seg\\_memory\\_layout\\_ns/ns\\_per\\_op)."});
        rows.push_back(
            {"14 pinned axes = 0 exchangeability evidence",
             "Only 4 of the 18 composition axes vary (search\\_algo, node\\_type, memory\\_layout, prefetch). "
             "Pinned (1 value each): cache\\_traversal, mapping, path\\_compression, allocator, concurrency, "
             "serialization, value\\_handle, index\\_organization, io\\_dispatch, migration\\_policy, filter, "
             "queuing\\_q1, queuing\\_q2, persistence\\_target. (Since INC-2d, isa is the system axis "
             "\\texttt{target\\_isa}, and since INC-2c telemetry is no longer a binary\\_id composition axis "
             "--- neither therefore counts as a pinned organ axis any more.)"});
        rows.push_back(
            {"Observer probe counters ($\\ast$\\_find/$\\ast$\\_probe/$\\ast$\\_get) by design $\\approx 1$",
             "Expected behaviour, no phantom: one probe per lookup. Says nothing about internal iterations."});
        rows.push_back(
            {"Honest-0 of inactive sub-features of pinned strategies",
             "concurrency/migration/io/value\\_handle report 0 (feature inactive), not a measurement error."});
        rows.push_back({"Wall-clock not bit-reproducible",
                        "Seed drives keys (deterministic), NOT CPU timing; wall-clock varies run-to-run."});
        rows.push_back({"RC dimension only nominal",
                        "K1: $\\times 18 \\to \\times 3$ degenerated; RC axis does not provide full value breadth."});
        rows.push_back(
            {"2/21 scan profiles = no-op (excluded)",
             "ycsb\\_e and lp\\_range\\_scan perform no real scan; excluded for scan diffs (19 valid workloads)."});
        rows.push_back(
            {"Insert profiles measure upserts; stat\\_$\\ast$ columns include load phase",
             "The insert path is effectively an upsert; the stat\\_$\\ast$ counters also accumulate the load phase."});
        rows.push_back({"prefetch measures key values as pseudo-addresses (K9)",
                        "The prefetch axis interprets key values as addresses; no real memory prefetch."});
        rows.push_back({"node\\_type + memory\\_layout: Q2 step-4 shadowing",
                        "Apparatus artefact possible (search\\_organ\\_ shadowing); search\\_algo + prefetch are the "
                        "least confounded."});
        // #226 (2026-06-28): #211 container_ mirror rebuild — present in cowfix-v1 (path B), unresolved as of M3.
        rows.push_back(
            {"container\\_ mirror (path B): O(n) flatten+rebuild as extra apparatus",
             "Path-B creatures (SOTA trees/tries/hash) keep a sorted container\\_ mirror alongside the real search "
             "organ; its O(n) flatten+rebuild (on new inserts + successful erases; \\#211, unresolved as of M3) is "
             "EXTRA apparatus work the real tree does not incur $\\to$ the measured ns\\_per\\_op of path-B tiers is "
             "inflated by this mirror share. (For the path-A array family the same O(n) rebuild is the GENUINE "
             "structural cost, not an extra artefact.) Resolved with \\#188/\\#211 + successor rebuild (\\#215)."});
        rows.push_back(
            {"memory\\_layout effect partly sub-noise",
             "Part of the layout differences lies below the measurement noise $\\to$ PMC externally gated (\\#26)."});
        // Audit A1 / MINOR-MESS-04+09 (EN pendant of the uint16 saturation caveat).
        rows.push_back(
            {"Secondary indirection organs (cache\\_traversal/mapping): uint16 key saturation",
             "The uint64 PRIMARY key is narrowed (static\\_cast) into the smaller slot\\_index/key\\_type fields of "
             "the "
             "PINNED cache\\_traversal/mapping organs when auto-coupling (low bits); for records $>$ type width their "
             "observer entries collide. Does NOT affect the primary lookup (uint64); observer-only limitation of "
             "pinned axes (cf. rows 2/4)."});
        // Audit A1 / MINOR-MESS-02 residual (EN pendant).
        rows.push_back({"Capsule-internal (swallowed) OOM in a measured op",
                        "An OOM propagated outward now hard-invalidates the measurement (two\\_phase\\_valid=false). "
                        "An OOM caught "
                        "INTERNALLY by tier code via catch(...) (e.g. defensive memento skip) is not observable from "
                        "outside $\\to$ "
                        "documented as a conservative residual caveat, not forced."});
        // G5-Audit (w289llo0o): en
        rows.push_back({"Timer overhead (\\texttt{clock::now()}) not calibrated",
                        "The wall-clock segment timings include the non-subtracted intrinsic overhead of the "
                        "\\texttt{std::chrono::steady\\_clock::now()} calls (an additive, run-stable ns component per "
                        "measured segment). NO empty-loop calibration is performed $\\to$ documented caveat; affects "
                        "the absolute ns origin, not the relative per-axis comparisons (G5 audit, MESS-MINOR-7)."});
        rows.push_back(
            {"Design labels = naming convention, no measurement effect",
             "A few pattern labels in code/docs are naming/design caveats with no measurement effect: ``hybrid "
             "visitor'' (in reality a memento, no \\texttt{accept()}/host visit), plus interpreter/template/decorator "
             "labels and \\texttt{reserve}/\\texttt{if constexpr} hygiene. Pure naming convention $\\to$ documented as "
             "a caveat, no influence on measured values (G5 audit, PATTERN-MINOR-1..7)."});
    }

    int n = 1;
    for (auto const& r : rows) {
        f << n++ << " & " << r.caveat << " & " << r.status << " \\\\";
        if (!r.trailer.empty()) f << " " << r.trailer;
        f << "\n";
    }

    f << "\\end{longtable}\n\\end{scriptsize}\n";
    return f.good() ? status_ok : status_io_error;
}

// ── A1 / A3 / A4 (m3v2-Outputs, Phase L L2/L3/L4, 2026-06-20) ────────────────────────────────────────────
// Alle drei header-getrieben (lesen die OPTIONALEN m3v2-Felder series/sweep_axis/working_set_n/seg_coverage
// aus WideFullRow; fehlt das Feld → leer/übersprungen, NIE Crash). Alle Ausgaben breiten-sicher:
// \resizebox{\textwidth}{!}{...} + \scriptsize + \setlength{\tabcolsep}{2pt} (Aufgabe-B-Konformität).

namespace {

// Lesbarer „Lebewesen-Name" aus der binary_id: bei SOTA-Reihen-Tieren das letzte ::-Segment von
// "sota_tier=sota::A::PrtArtComposition", sonst der search_algo-Wert, sonst die volle binary_id.
[[nodiscard]] std::string living_being_name(std::string const& binary_id) {
    constexpr std::string_view kSota = "sota_tier=";
    if (binary_id.rfind(kSota, 0) == 0) {
        std::string       v    = binary_id.substr(kSota.size());
        std::size_t const last = v.rfind("::");
        return (last == std::string::npos) ? v : v.substr(last + 2);
    }
    constexpr std::string_view kSa = "search_algo=";
    if (binary_id.rfind(kSa, 0) == 0) {
        std::size_t const end = binary_id.find('/', kSa.size());
        return binary_id.substr(kSa.size(), (end == std::string::npos ? binary_id.size() : end) - kSa.size());
    }
    return binary_id;
}

// Median je (binary_id × Interface-Fn) über alle two_phase_valid-Zeilen (nearest-rank), gefiltert
// nach einem Prädikat (z.B. series==X). Liefert auch die Probenzahl je binary_id.
struct BeingFnMedians {
    std::string                   series;
    std::string                   binary_id;
    std::string                   name;
    std::size_t                   samples = 0;
    std::map<std::string, double> fn_median; // "insert"|"lookup"|... → Median ns
};

} // anonymous namespace

int write_sota_series_table(std::filesystem::path const& out, std::span<WideFullRow const> rows,
                            std::string const& caption, std::string const& label, std::string const& lang) {
    std::ofstream f{out};
    if (!f) return status_io_error;
    bool const de = (lang == "de");

    // Pro (series, binary_id) Mediane je Interface-Fn + ns_per_op bilden. NUR two_phase_valid.
    // Fehlt die series-Spalte (cowfix-v1), bleibt series leer → alle Zeilen landen in der Reihe "".
    std::map<std::pair<std::string, std::string>, std::map<std::string, std::vector<double>>> acc;
    for (auto const& r : rows) {
        if (!r.two_phase_valid) continue;
        auto& slot = acc[{r.series, r.binary_id}];
        slot["insert"].push_back(r.op_insert_p50);
        slot["lookup"].push_back(r.op_lookup_p50);
        slot["erase"].push_back(r.op_erase_p50);
        slot["scan"].push_back(r.op_scan_p50);
        slot["rmw"].push_back(r.op_rmw_p50);
        slot["ns_per_op"].push_back(r.ns_per_op);
    }
    if (acc.empty()) { // ehrlich leer (keine gültigen Zeilen) → leere Tabelle, KEIN Crash
        f << "% (keine two_phase_valid-Zeilen — SOTA-Reihen-Tabelle leer)\n";
        return f.good() ? status_ok : status_io_error;
    }

    std::vector<BeingFnMedians> beings;
    for (auto& [key, fns] : acc) {
        BeingFnMedians b;
        b.series    = key.first;
        b.binary_id = key.second;
        b.name      = living_being_name(key.second);
        for (auto& [fn, samples] : fns) {
            if (fn == "ns_per_op") b.samples = samples.size();
            b.fn_median[fn] = nearest_rank_median(std::move(samples));
        }
        beings.push_back(std::move(b));
    }

    // Anzeige-Reihenfolge der Spalten = kFnOrder (ns_per_op zuerst, dann insert/lookup/erase/scan/rmw).
    static constexpr std::array<std::string_view, 6> kCol = {"ns_per_op", "insert", "lookup", "erase", "scan", "rmw"};

    std::string const series_h = de ? "Reihe" : "series";
    std::string const being_h  = de ? "Lebewesen" : "living being";
    std::string const n_h      = de ? "$n$" : "$n$";

    f << "% AUTO-GENERATED durch csv_to_latex::write_sota_series_table (A1 SOTA-Reihen A/B/C; lang=" << lang << ")\n";
    f << "% Zeile = (Reihe × Lebewesen); Spalte = Median ns/op je Interface-Funktion (nearest-rank, nur\n";
    f << "% two_phase_valid). Reihen A/B/C tragen die 3 Kompositionalen Joins (PRT-ART vs SOTA je Reihe).\n";
    f << "\\begin{table}[!htbp]\n\\centering\n";
    f << "\\scriptsize\n\\setlength{\\tabcolsep}{2pt}\n"; // Aufgabe-B: WIDE-Tabelle breiten-sicher
    f << "\\resizebox{\\textwidth}{!}{%\n";               // + harte \textwidth-Kapsel
    f << "\\begin{tabular}{ll";
    for (std::size_t i = 0; i < kCol.size(); ++i) f << "r";
    f << "r}\n\\toprule\n";
    f << series_h << " & " << being_h;
    for (auto c : kCol) f << " & " << escape_latex(std::string{c});
    f << " & " << n_h << " \\\\\n\\midrule\n";

    // Stabil sortiert: nach series, dann nach name.
    std::sort(beings.begin(), beings.end(), [](BeingFnMedians const& a, BeingFnMedians const& b) {
        if (a.series != b.series) return a.series < b.series;
        return a.name < b.name;
    });
    std::string prev_series = "\x01"; // unmöglicher Initialwert → erster Block druckt series
    for (auto const& b : beings) {
        std::string const ser_disp = b.series.empty() ? (de ? "(ohne)" : "(none)") : b.series;
        f << (b.series == prev_series ? std::string{} : escape_latex(ser_disp));
        prev_series = b.series;
        f << " & " << escape_latex(b.name);
        for (auto c : kCol) {
            auto const it = b.fn_median.find(std::string{c});
            if (it == b.fn_median.end())
                f << " & --"; // fehlende Spalte → ehrlich "--"
            else
                f << " & " << static_cast<std::uint64_t>(it->second + 0.5);
        }
        f << " & " << b.samples << " \\\\\n";
    }
    f << "\\bottomrule\n\\end{tabular}%\n}\n";
    f << "\\caption{" << escape_latex(caption) << "}\n\\label{" << label << "}\n\\end{table}\n";
    return f.good() ? status_ok : status_io_error;
}

int write_sweep_axis_longtable(std::filesystem::path const& out, std::span<WideFullRow const> rows,
                               std::string const& caption_prefix, std::string const& lang) {
    std::ofstream f{out};
    if (!f) return status_io_error;
    bool const de = (lang == "de");

    // Die gesweepte Achse bestimmen (erster nicht-leerer sweep_axis-Wert ≠ "-"). Fehlt sie → leere Tabelle.
    std::string sweep_axis;
    for (auto const& r : rows)
        if (!r.sweep_axis.empty() && r.sweep_axis != "-") {
            sweep_axis = r.sweep_axis;
            break;
        }
    if (sweep_axis.empty()) {
        f << "% (keine sweep_axis-Spalte/-Werte — 9-Achsen-Austauschbarkeits-Tabelle n/a)\n";
        return f.good() ? status_ok : status_io_error;
    }

    // Je Ausprägung der gesweepten Achse (Wert in binary_id) Median je Interface-Fn + ns_per_op bilden,
    // NUR two_phase_valid. Diff-Beleg: distinkte binary_id = nachweislich verschiedener Organ-Pfad.
    std::map<std::string, std::map<std::string, std::vector<double>>> by_value;     // wert → fn → samples
    std::map<std::string, std::set<std::string>>                      ids_by_value; // wert → distinkte binary_ids
    std::string const                                                 needle = sweep_axis + "=";
    for (auto const& r : rows) {
        if (!r.two_phase_valid) continue;
        auto const it = r.axes.find(sweep_axis);
        if (it == r.axes.end()) continue;
        std::string const& v    = it->second;
        auto&              slot = by_value[v];
        slot["insert"].push_back(r.op_insert_p50);
        slot["lookup"].push_back(r.op_lookup_p50);
        slot["erase"].push_back(r.op_erase_p50);
        slot["scan"].push_back(r.op_scan_p50);
        slot["rmw"].push_back(r.op_rmw_p50);
        slot["ns_per_op"].push_back(r.ns_per_op);
        ids_by_value[v].insert(r.binary_id);
    }

    static constexpr std::array<std::string_view, 6> kCol = {"ns_per_op", "insert", "lookup", "erase", "scan", "rmw"};

    std::string const cap = (de ? (caption_prefix + ": Achsen-Austauschbarkeit \\texttt{" + escape_latex(sweep_axis) +
                                   "} (je Auspr\\\"agung Median ns/op je Interface-Funktion, nur two\\_phase\\_valid; "
                                   "Diff-Beleg = distinkter Organ-Pfad)")
                                : (caption_prefix + ": axis exchangeability \\texttt{" + escape_latex(sweep_axis) +
                                   "} (per value median ns/op per interface function, only two\\_phase\\_valid; "
                                   "diff evidence = distinct organ path)"));
    std::string const colhead =
        de ? "Auspr\\\"agung & ns/op & insert & lookup & erase & scan & rmw & Pfade & Diagnose \\\\"
           : "value & ns/op & insert & lookup & erase & scan & rmw & paths & diagnostic \\\\";
    std::string const diag = de ? "verschiedener Organ-Pfad" : "distinct organ path";

    f << "% AUTO-GENERATED durch csv_to_latex::write_sweep_axis_longtable (A3 9-Achsen-Austauschbarkeit;\n";
    f << "% sweep_axis=" << sweep_axis << "; lang=" << lang << ")\n";
    f << "\\begin{scriptsize}\n\\setlength{\\tabcolsep}{2pt}\n"; // Aufgabe-B: breiten-sicher
    f << "\\begin{longtable}{@{}>{\\raggedright\\arraybackslash}p{2.6cm} r r r r r r r "
      << ">{\\raggedright\\arraybackslash}p{3.0cm}@{}}\n";
    f << "\\caption{" << cap << "}\\label{tab:m3v2:sweep:" << sweep_axis << "}\\\\\n";
    f << "\\toprule\n" << colhead << "\n\\midrule\n\\endfirsthead\n";
    f << "\\multicolumn{9}{c}{\\tablename\\ \\thetable{} -- " << (de ? "Fortsetzung" : "continued")
      << "}\\\\\n\\toprule\n"
      << colhead << "\n\\midrule\n\\endhead\n";
    f << "\\midrule\n\\multicolumn{9}{r}{" << (de ? "Fortsetzung n\\\"achste Seite" : "continued on next page")
      << "}\\\\\n\\endfoot\n\\bottomrule\n\\endlastfoot\n";

    for (auto& [v, fns] : by_value) {
        f << escape_latex(v);
        for (auto c : kCol) {
            auto const it = fns.find(std::string{c});
            if (it == fns.end()) {
                f << " & --";
                continue;
            }
            f << " & " << static_cast<std::uint64_t>(nearest_rank_median(it->second) + 0.5);
        }
        f << " & " << ids_by_value[v].size() << " & " << diag << " \\\\\n";
    }
    f << "\\end{longtable}\n\\end{scriptsize}\n";
    return f.good() ? status_ok : status_io_error;
}

int write_seg_coverage_appendix(std::filesystem::path const& out, std::span<WideFullRow const> rows,
                                std::string const& caption, std::string const& label, std::string const& lang) {
    std::ofstream f{out};
    if (!f) return status_io_error;
    bool const de = (lang == "de");

    // Je Lebewesen (binary_id) seg_coverage aggregieren (min/median/max), NUR Zeilen MIT seg_coverage.
    // Fehlt die Spalte komplett (cowfix-v1), bleibt die Tabelle ehrlich leer (n/a, KEIN Crash).
    std::map<std::string, std::vector<double>> cov;
    for (auto const& r : rows) {
        if (!r.has_seg_coverage) continue;
        cov[r.binary_id].push_back(r.seg_coverage);
    }
    if (cov.empty()) {
        f << "% (keine seg_coverage-Spalte — Mess-Validitaets-Tabelle n/a)\n";
        return f.good() ? status_ok : status_io_error;
    }

    std::string const being_h = de ? "Lebewesen" : "living being";
    std::string const cols_h  = de ? "min & Median & max & $n$" : "min & median & max & $n$";

    f << "% AUTO-GENERATED durch csv_to_latex::write_seg_coverage_appendix (A4 seg_coverage Mess-Validitaet;\n";
    f << "% lang=" << lang << "). seg_coverage = Sum(seg_ns)/seg_run_total_ns (Pfad-B-Abdeckung; ~1.0 = gut).\n";
    f << "\\begin{scriptsize}\n\\setlength{\\tabcolsep}{2pt}\n";
    f << "\\begin{longtable}{@{}>{\\raggedright\\arraybackslash}p{8.5cm} r r r r@{}}\n";
    f << "\\caption{" << escape_latex(caption) << "}\\label{" << label << "}\\\\\n";
    std::string const colhead = being_h + " & " + cols_h + " \\\\";
    f << "\\toprule\n" << colhead << "\n\\midrule\n\\endfirsthead\n";
    f << "\\multicolumn{5}{c}{\\tablename\\ \\thetable{} -- " << (de ? "Fortsetzung" : "continued")
      << "}\\\\\n\\toprule\n"
      << colhead << "\n\\midrule\n\\endhead\n";
    f << "\\midrule\n\\multicolumn{5}{r}{" << (de ? "Fortsetzung n\\\"achste Seite" : "continued on next page")
      << "}\\\\\n\\endfoot\n\\bottomrule\n\\endlastfoot\n";

    char buf[64];
    for (auto& [bid, samples] : cov) {
        std::sort(samples.begin(), samples.end());
        double const mn = samples.front();
        double const mx = samples.back();
        double const md = nearest_rank_median(samples);
        f << escape_latex(living_being_name(bid));
        std::snprintf(buf, sizeof(buf), "%.4f", mn);
        f << " & " << buf;
        std::snprintf(buf, sizeof(buf), "%.4f", md);
        f << " & " << buf;
        std::snprintf(buf, sizeof(buf), "%.4f", mx);
        f << " & " << buf;
        f << " & " << samples.size() << " \\\\\n";
    }
    f << "\\end{longtable}\n\\end{scriptsize}\n";
    return f.good() ? status_ok : status_io_error;
}

std::string generate_baustein_description(std::string_view permutation_id) {
    // permutation_id format: ce_<x>:search_algo_<y>:alloc_<z>:dataset_<w>
    auto               tokens = split_colons(permutation_id);
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

} // namespace comdare::da::csv_to_latex
