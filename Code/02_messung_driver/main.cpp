// SPDX-License-Identifier: Apache-2.0
// Diplomarbeit/Code/messung_driver/main.cpp (REV 7.6)
//
// Master-Orchestrator fuer die 3 Pflicht-Messreihen:
//   A — PRT-ART vs Stand-der-Technik
//   B — Cache-Engine Permutationen (SOTA-only)
//   C — Merge alt/neu (PRT-ART-Bausteine in cache-engine-Stack)
//
// Architektur: konsumiert comdare::builder::ExperimentDriver (Library aus
// cache-engine, REV 7.6 Q4) + workload_generator. Schreibt binary
// measurement-records pro Messreihe in separate Unterordner.

// V38.C: STL-Header zuerst (windows.h via plugin_loader.hpp am Ende),
// damit die STL-Header (frueher u.a. <regex>, Phase 7 entfernt) nicht durch Windows-Makros gestoert werden.
#include <array>
#include <cerrno>
#include <charconv>
#include <cctype>
#include <cstdint>
#include <cstdlib>
#include <exception>
#include <filesystem>
#include <fstream>
#include <functional>
#include <iostream>
#include <limits>
#include <map>
#include <optional>
#include <sstream>
#include <stdexcept>
#include <string>
#include <string_view>
#include <system_error>
#include <vector>

#include "experiment_driver/experiment_driver.hpp"
#include "xml_config_parser/xml_config_parser.hpp"
#include "messreihen_workload.hpp"        // #31: E4-XML Workload-Drive (<workload> via ce-DOM, kein Submodul-Bump)
#include "permutations_runtime_check.hpp" // V36.D
#include "measurement_writer.hpp"         // V41.B1
#include "stats_aggregator.hpp"           // V41.B3

#include <comdare/workload_generator/workload_generator.hpp>

#ifdef COMDARE_MESSUNG_HAVE_E4_FACADE
#include <profile_facade/profile_run_facade.hpp>
#endif

// V38.C - bringt windows.h auf Win32 (LEAN_AND_MEAN + NOMINMAX gesetzt).
// MUSS am Ende stehen, sonst clash mit STL via Windows-Makros.
// V38.C.2 Workaround: windows.h definiert auf manchen SDK-Versionen Macros
// die das raw-string-Parsing in main.cpp stoeren. #undef vor Includes setzen.
#include "plugin_loader.hpp" // V38.C
// Defensiv: einige potentielle Macro-Konflikte zwischen Win32-SDK + C++ Source
#ifdef R
#undef R
#endif
#ifdef S
#undef S
#endif

namespace cb = comdare::builder;
namespace wg = comdare::workload_generator;

namespace {

// ─────────────────────────────────────────────────────────────────────────────
// Ladebalken (2026-06-01): ASCII-Fortschrittsbalken ueber ALLE kartesischen
// Produkte (alle geladenen Plugins, CE + prt-art gemeinsam). Bewusst NUR ASCII
// (kein Unicode) wegen NAS/bash + Windows-Konsole. Rendert in-place via '\r' auf
// std::cerr; stdout bleibt fuer Mess-/Record-Ausgaben frei. Lange Permutations-IDs
// werden gekuerzt, damit die Zeile nicht umbricht; Rest-Zeichen werden geloescht.
// ─────────────────────────────────────────────────────────────────────────────
class ProgressBar {
public:
    ProgressBar(std::string_view title, std::size_t total) : title_{title}, total_{total} {
        std::cerr << title_ << " (" << total_ << " Permutationen):\n";
        render("");
    }
    void tick(std::string_view label) {
        if (cur_ < total_) ++cur_;
        render(label);
    }
    // Meldung oberhalb des Balkens ausgeben, ohne ihn zu zerstoeren.
    void note(std::string const& msg) {
        std::cerr << '\r' << std::string(line_len_, ' ') << '\r' << msg << '\n';
        line_len_ = 0;
        render(last_label_);
    }
    void finish() { std::cerr << '\n'; }

private:
    void render(std::string_view label) {
        last_label_         = std::string{label};
        double const frac   = total_ ? static_cast<double>(cur_) / static_cast<double>(total_) : 1.0;
        int          filled = static_cast<int>(frac * kWidth);
        if (filled > kWidth) filled = kWidth;
        std::string bar;
        bar.reserve(static_cast<std::size_t>(kWidth));
        for (int i = 0; i < kWidth; ++i) bar += (i < filled) ? '=' : ' ';
        if (filled > 0 && filled < kWidth) bar[static_cast<std::size_t>(filled) - 1] = '>';
        std::string lbl{label};
        if (lbl.size() > 48) lbl = lbl.substr(0, 45) + "...";
        std::ostringstream os;
        os << '\r' << '[' << bar << "] " << cur_ << '/' << total_ << " (" << static_cast<int>(frac * 100.0) << "%) "
           << lbl;
        std::string out = os.str();
        if (out.size() < line_len_) out += std::string(line_len_ - out.size(), ' ');
        line_len_ = os.str().size();
        std::cerr << out << std::flush;
    }
    static constexpr int kWidth = 40;
    std::string          title_;
    std::size_t          total_;
    std::size_t          cur_      = 0;
    std::size_t          line_len_ = 0;
    std::string          last_label_;
};

enum class MessreiheKind : std::uint8_t {
    A_PrtArtVsSota    = 0,
    B_CacheEnginePerm = 1,
    C_MergeAltNeu     = 2,
};

[[nodiscard]] std::string_view messreihe_name(MessreiheKind k) noexcept {
    switch (k) {
        case MessreiheKind::A_PrtArtVsSota: return "A_PRT_ART_vs_SOTA";
        case MessreiheKind::B_CacheEnginePerm: return "B_CacheEngine_Perms";
        case MessreiheKind::C_MergeAltNeu: return "C_Merge_Alt_Neu";
    }
    return "Unknown";
}

[[nodiscard]] std::filesystem::path subdir_for(MessreiheKind k) { return std::string{messreihe_name(k)}; }

[[nodiscard]] cb::WorkloadOptions default_workload_for(MessreiheKind k) {
    cb::WorkloadOptions w;
    w.config.random_seed      = 42;
    w.config.key_size_bytes   = 16;
    w.config.value_size_bytes = 64;
    w.config.zipfian_theta    = 0.99;

    switch (k) {
        case MessreiheKind::A_PrtArtVsSota:
            w.config.num_keys       = 1000000;
            w.config.num_operations = 5000000;
            w.workload              = wg::YcsbWorkload::C;
            break;
        case MessreiheKind::B_CacheEnginePerm:
            w.config.num_keys       = 500000;
            w.config.num_operations = 2500000;
            w.workload              = wg::YcsbWorkload::C;
            break;
        case MessreiheKind::C_MergeAltNeu:
            w.config.num_keys       = 1000000;
            w.config.num_operations = 5000000;
            w.workload              = wg::YcsbWorkload::A;
            break;
    }
    return w;
}

void print_usage() {
    std::cerr
        << "Usage: comdare-messung-driver <config_dir> <output_dir> [--comdare-root=DIR] [--messreihen-xml=FILE]\n\n"
        << "Erwartete Files in <config_dir> (Legacy-4-Datei-Schema; heutige Konfigs:\n"
        << "config_a/b/c_*.xml + messreihen.xml — fehlende Dateien werden diagnostiziert):\n"
        << "  cache_engine_permutations.xml\n"
        << "  search_algorithm_permutations.xml\n"
        << "  allocator_permutations.xml\n"
        << "  test_data_sets.xml  [DEPRECATED-Slot, GO-5 Fork 2/R2 2026-07-12: existiert nirgends;\n"
        << "                       Wahrheitsquelle sind die Code/test_data_xml/*.test_data.xml-Akten,\n"
        << "                       die der E4-Weg via <datasets> im comdare_thesis_profile referenziert]\n"
        << "  (optional, V9.6) messreihen.xml — defined/full Mode pro Reihe\n\n"
        << "Output (separat pro Messreihe A/B/C):\n"
        << "  <output_dir>/A_PRT_ART_vs_SOTA/measurements.{csv,json}\n"
        << "  <output_dir>/B_CacheEngine_Perms/measurements.{csv,json}\n"
        << "  <output_dir>/C_Merge_Alt_Neu/measurements.{csv,json}\n";
}

// REV 7.6 V9.6 — minimaler XML-Reader fuer messreihe-Tags (defined/full Mode)
struct MessreihenSpec {
    std::string                     id;
    std::string                     mode; // "defined" oder "full"
    std::vector<std::string>        sota_profiles;
    std::optional<wg::YcsbWorkload> workload; // #31: aus <workload> (E4-XML); nullopt = Fallback-Default
};

// Phase 7 (2026-07-10, Parser-Konsolidierung): der lokale Regex-Reader ist entfernt —
// die Bibliothek (XmlConfigParser::load_messreihen, KF-1-DOM) ist die EINE Wahrheitsquelle.
// MessreihenSpec bleibt die treiberlokale Sicht (string-mode fuer die bestehende Verzweigung).
[[nodiscard]] std::vector<MessreihenSpec> load_messreihen(std::filesystem::path const& xml_path) {
    std::vector<MessreihenSpec>            result;
    comdare::builder::xml::XmlConfigParser parser;
    // #31 (submodul-CI-konform): das Zusatz-Tag <workload> ueber den ce-DOM-Reader ergaenzen — der typisierte
    // XmlConfigParser::load_messreihen bleibt die EINE Quelle fuer id/mode/sota (Phase-7-Konsolidierung); er
    // exponiert <workload> nicht, und ein neues ce-Parser-Feld wuerde einen nicht-fetchbaren Submodul-Bump brauchen.
    auto const wl_map = comdare::messung::parse_messreihe_workloads(xml_path);
    for (auto const& r : parser.load_messreihen(xml_path)) {
        MessreihenSpec spec;
        spec.id            = r.id;
        spec.mode          = std::string{comdare::builder::xml::mode_to_string(r.mode)};
        spec.sota_profiles = r.sota_profile_refs;
        if (auto it = wl_map.find(r.id); it != wl_map.end()) spec.workload = it->second;
        result.push_back(std::move(spec));
    }
    return result;
}

[[nodiscard]] std::string trim_copy(std::string_view s) {
    while (!s.empty() && std::isspace(static_cast<unsigned char>(s.front())) != 0) s.remove_prefix(1);
    while (!s.empty() && std::isspace(static_cast<unsigned char>(s.back())) != 0) s.remove_suffix(1);
    return std::string{s};
}

[[nodiscard]] std::string env_trimmed(char const* name) {
    if (char const* e = std::getenv(name); e != nullptr) return trim_copy(e);
    return {};
}

[[nodiscard]] std::string compile_time_platform_tag() {
#if defined(__linux__) && (defined(__x86_64__) || defined(_M_X64))
    return "linux-x86_64";
#elif defined(__linux__) && (defined(__aarch64__) || defined(_M_ARM64))
    return "linux-arm64";
#elif defined(_WIN32) && (defined(_M_X64) || defined(__x86_64__))
    return "win-x86_64";
#elif defined(_WIN32) && defined(_M_ARM64)
    return "win-arm64";
#elif defined(__APPLE__) && defined(__aarch64__)
    return "macos-arm64";
#elif defined(__APPLE__) && defined(__x86_64__)
    return "macos-x86_64";
#elif defined(__linux__) && defined(__riscv) && (__riscv_xlen == 64)
    return "linux-riscv64";
#else
    return "unknown-platform";
#endif
}

[[nodiscard]] double parse_min_free_gb_from_env() {
    std::string const s = env_trimmed("COMDARE_MIN_FREE_GB");
    if (s.empty()) return 0.0;

    errno      = 0;
    char*  end = nullptr;
    double v   = std::strtod(s.c_str(), &end);
    if (end == s.c_str() || *end != '\0' || errno == ERANGE || v < 0.0) {
        // Fail-loud statt 0.0: ein Tippfehler ("4,5"/"4gb") wuerde sonst die RAM-Admission
        // still deaktivieren (B3-Klasse) -- der Abbruch landet im try/catch des E4-Blocks.
        throw std::runtime_error("COMDARE_MIN_FREE_GB ungueltig: '" + s + "'");
    }
    return v;
}

[[nodiscard]] std::optional<std::size_t> parse_size_env_strict(char const* name) {
    std::string const s = env_trimmed(name);
    if (s.empty()) return std::nullopt;

    std::uint64_t value  = 0;
    auto const [ptr, ec] = std::from_chars(s.data(), s.data() + s.size(), value, 10);
    if (ec != std::errc{} || ptr != s.data() + s.size() ||
        value > static_cast<std::uint64_t>((std::numeric_limits<std::size_t>::max)())) {
        throw std::runtime_error(std::string{name} + " ungueltig: '" + s + "'");
    }
    return static_cast<std::size_t>(value);
}

} // namespace

int main(int argc, char* argv[]) {
    // --validate [<profil>]: rein-lesende Pre-Flight-Pruefung des Thesis-Profils gegen die realen
    // EnabledStrategies (P5, migriert von run_lazy_150) — baut KEINE DLL, misst NICHT. Braucht KEINE
    // <config>/<output>-Argumente; ohne Pfad gilt COMDARE_THESIS_PROFILE bzw. das gebackene Default-Profil.
    for (int i = 1; i < argc; ++i) {
        std::string const flag{argv[i]};
        if (flag == "--validate" || flag == "--check") {
            std::string prof = (i + 1 < argc && argv[i + 1][0] != '-') ? std::string{argv[i + 1]}
                                                                       : env_trimmed("COMDARE_THESIS_PROFILE");
            if (prof.empty()) prof = COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE;
            return comdare::cache_engine::builder::profile_facade::validate_profile_facade(prof, std::cout);
        }
    }
    if (argc < 3) {
        print_usage();
        return 1;
    }

    // V36.D: Pre-Build-Permutationen-Check. Wenn KEINE Permutationen
    // vorhanden sind, hat das Experiment keinen Sinn -> Fatal mit Exit 2.
    if (int rc = comdare::messung_driver::assert_permutations_available_or_die(); rc != 0) { return rc; }

    // V37.C (2026-05-23): Manifest-Iteration — pro Permutation ein Eintrag.
    {
        auto perms = comdare::messung_driver::load_all_permutations();
        std::cout << "[V37.C] Permutations-Inventar: " << perms.size() << " Eintraege\n";
        std::size_t i{0};
        for (auto const& p : perms) {
            std::cout << "  [" << (++i) << "/" << perms.size() << "] " << p.subsystem << " :: " << p.id << "\n";
        }
    }

    // V38.C (2026-05-24): Plugin-Loader — laedt alle .dll/.so/.dylib aus
    // dem perm-Baum, ruft pro Plugin perm_<id>_run(N, &micros) auf.
    // V41.B1 (2026-05-24): jeder Plugin-Aufruf wird als binary measurement-record
    // in <output_dir>/measurements/<perm_id>.bin geschrieben (Stage-03-kompatibel).
    {
        // Annahme: messung_driver-Binary liegt in build/<preset>/<config>/.
        // perm-Root liegt unter build/<preset>/perm/.
        auto exe_dir = std::filesystem::current_path();
        // heuristische Suche nach perm/-Wurzel
        auto perm_root = exe_dir / "perm";
        for (int up = 0; up < 4 && !std::filesystem::exists(perm_root); ++up) {
            exe_dir   = exe_dir.parent_path();
            perm_root = exe_dir / "perm";
        }
        if (!std::filesystem::exists(perm_root)) {
            std::cerr << "[V38.C] perm-Root nicht gefunden, ueberspringe Plugin-Mikrobenchmark\n";
        } else {
            std::cout << "[V38.C] lade Plugins aus: " << perm_root.string() << "\n";
            auto                    plugins = comdare::messung_driver::load_all_perm_plugins(perm_root);
            constexpr unsigned long kRunOps = 1000;
            std::cout << "[V38.C] " << plugins.size() << " Plugins geladen, fuehre Mikrobenchmark aus (N=" << kRunOps
                      << ")\n";

            // V41.B1: ein Aggregat-File fuer alle Permutationen
            std::filesystem::path const v41_out_dir = std::filesystem::path{argv[2]} / "measurements";
            std::filesystem::create_directories(v41_out_dir);
            comdare::messung_driver::MeasurementWriter writer{v41_out_dir / "all_permutations.bin"};
            if (!writer.ok()) {
                std::cerr << "[V41.B1] WARN: konnte " << (v41_out_dir / "all_permutations.bin").string()
                          << " nicht oeffnen, ueberspringe binary records\n";
            }

            // V41.B3: pro Plugin N_REPS Runs sammeln (statt 1) fuer Statistik
            constexpr std::size_t                           kReps = 10;
            std::vector<comdare::messung_driver::PermStats> all_stats;
            all_stats.reserve(plugins.size());

            // Ladebalken ueber ALLE kartesischen Produkte (CE + prt-art gemeinsam).
            ProgressBar bar{"[Mikrobench] Kartesische Achsen-Permutationen", plugins.size()};
            for (auto const& p : plugins) {
                std::vector<double> samples_us;
                samples_us.reserve(kReps);
                bool all_ok = true;
                for (std::size_t rep = 0; rep < kReps; ++rep) {
                    double micros = 0.0;
                    int    rc     = p.desc->run(kRunOps, &micros);
                    if (rc == 0) {
                        samples_us.push_back(micros);
                    } else {
                        all_ok = false;
                    }
                }
                std::string subsystem = (std::string{p.desc->id}.rfind("pa_", 0) == 0) ? "prt_art" : "cache_engine";
                auto        stats     = comdare::messung_driver::compute_stats(p.desc->id, subsystem, p.desc->axes,
                                                                               p.desc->version, samples_us);
                all_stats.push_back(stats);

                bar.tick(stats.permutation_id);
                if (!(all_ok && !samples_us.empty())) {
                    bar.note(std::string{"[ERR] "} + std::string{p.desc->id} +
                             "  ok-samples=" + std::to_string(samples_us.size()));
                }

                // V41.B1: pro Plugin EIN aggregate binary record (mean us/op)
                // V41.P1: workload_used = "micro" (der eingebaute Plugin-Mikrobenchmark; echte
                // YCSB-Reihen setzen hier spaeter das Config-Workload-Label).
                if (writer.ok() && !samples_us.empty()) {
                    auto rec = comdare::messung_driver::make_record_from_run(static_cast<std::uint64_t>(kRunOps),
                                                                             stats.mean_us);
                    auto fp  = comdare::messung_driver::fingerprint_of(p.desc->id);
                    writer.add(p.desc->id, fp, all_ok, "micro", rec);
                }
            }
            bar.finish();
            writer.finalize();
            if (writer.ok() || writer.count() > 0) {
                std::cout << "[V41.B1] " << writer.count() << " binary records geschrieben: " << writer.path().string()
                          << "\n";
            }

            // V41.B3: Stats-CSV + paarweise Welch-Vergleiche
            std::filesystem::path stats_csv = v41_out_dir / "permutation_stats.csv";
            comdare::messung_driver::write_stats_csv(stats_csv, all_stats);
            std::cout << "[V41.B3] " << all_stats.size() << " Stats-Eintraege: " << stats_csv.string() << "\n";

            // ─── V41.G.1: Hierarchische Achsen-Iteration + Auswertung ───
            namespace md = comdare::messung_driver;
            // Item 1: aus (id, axes) jeder Permutation den Achsen-Baum bauen.
            std::vector<md::AxisItem> axis_items;
            axis_items.reserve(all_stats.size());
            for (auto const& s : all_stats) { axis_items.push_back(md::make_axis_item(s.permutation_id, s.axes)); }
            auto const axis_keys = md::collect_axis_keys(axis_items);
            auto const tree      = md::build_axis_tree(axis_items, axis_keys);

            // Item 2: hierarchische Ausgabe — Gruppen-Header je Achsen-Ebene "== key=value ==".
            std::cout << "[V41.G.1] Achsen-Baum (" << axis_keys.size() << " Achsen:";
            for (auto const& k : axis_keys) std::cout << ' ' << k;
            std::cout << "):\n";
            std::function<void(md::AxisTreeNode const&, int)> print_node = [&](md::AxisTreeNode const& n, int depth) {
                std::string const indent(static_cast<std::size_t>(depth) * 2, ' ');
                if (!n.axis_key.empty()) {
                    std::cout << indent << "== " << n.axis_key << '=' << n.axis_value << " == ("
                              << md::count_leaf_items(n) << " Perm.)\n";
                }
                for (auto const& c : n.children) print_node(c, depth + 1);
                for (auto idx : n.item_indices) {
                    std::cout << indent << "  - " << all_stats[idx].permutation_id << "  " << all_stats[idx].mean_us
                              << " us/op\n";
                }
            };
            print_node(tree, 0);

            // Item 3: per-Achsen-Spalten-CSV (eine Spalte je Achsen-Schlüssel).
            std::filesystem::path const per_axis_csv = v41_out_dir / "permutation_stats_per_axis.csv";
            md::write_stats_csv_per_axis(per_axis_csv, all_stats, axis_keys);
            std::cout << "[V41.G.1] per-Achsen-CSV (" << axis_keys.size()
                      << " Achsen-Spalten): " << per_axis_csv.string() << "\n";

            // Samples je id für Welch sammeln.
            std::map<std::string, std::vector<double>> samples_by_id;
            ProgressBar welch_bar{"[Welch-Sampling] Kartesische Achsen-Permutationen", plugins.size()};
            for (auto const& p : plugins) {
                std::vector<double> samples;
                for (std::size_t rep = 0; rep < kReps; ++rep) {
                    double micros = 0.0;
                    if (p.desc->run(kRunOps, &micros) == 0) samples.push_back(micros);
                }
                welch_bar.tick(p.desc->id);
                samples_by_id[std::string{p.desc->id}] = std::move(samples);
            }
            welch_bar.finish();

            // Item 4: Welch RESTRINGIERT auf Achsen-Subtrees — je variierender Achse nur Items, die in
            // ALLEN anderen Achsen übereinstimmen (z.B. gleiche simd+layout, vergleiche Allokator-Varianten).
            std::vector<md::PairwiseRow> pairs;
            for (auto const& varying : axis_keys) {
                auto const groups = md::subtree_groups_varying(axis_items, axis_keys, varying);
                for (auto const& g : groups) {
                    std::string fixed;
                    for (auto const& k : axis_keys) {
                        if (k == varying) continue;
                        fixed += (fixed.empty() ? "" : ";") + k + "=" +
                                 md::axis_value(axis_items[g.front()].axes, k).value_or("<none>");
                    }
                    for (std::size_t i = 0; i < g.size(); ++i) {
                        for (std::size_t j = i + 1; j < g.size(); ++j) {
                            auto const& a  = axis_items[g[i]].id;
                            auto const& b  = axis_items[g[j]].id;
                            auto const& sa = samples_by_id[a];
                            auto const& sb = samples_by_id[b];
                            if (sa.size() < 2 || sb.size() < 2) continue;
                            auto w = md::welch_us(sa, sb);
                            if (!w.valid) continue;
                            md::PairwiseRow row{};
                            row.a               = a;
                            row.b               = b;
                            row.mean_a          = w.mean_a / 1000.0; // ns->us
                            row.mean_b          = w.mean_b / 1000.0;
                            row.delta           = row.mean_a - row.mean_b;
                            row.t_stat          = w.t_statistic;
                            row.df              = w.degrees_of_freedom;
                            row.p_value         = w.p_value;
                            row.significant_5pc = (w.p_value < 0.05);
                            row.varying_axis    = varying;
                            row.fixed_context   = fixed;
                            pairs.push_back(row);
                        }
                    }
                }
            }
            std::filesystem::path const pairs_csv = v41_out_dir / "welch_pairwise.csv";
            md::write_pairwise_csv(pairs_csv, pairs);
            std::size_t sig = 0;
            for (auto const& r : pairs)
                if (r.significant_5pc) ++sig;
            std::cout << "[V41.G.1] " << pairs.size() << " subtree-restringierte Welch-Tests, " << sig
                      << " signifikant (p<0.05): " << pairs_csv.string() << "\n";

            comdare::messung_driver::unload_all(plugins);
        }
    }

    std::filesystem::path config_dir{argv[1]};
    std::filesystem::path output_dir{argv[2]};
    std::filesystem::path comdare_root = std::filesystem::current_path();
    std::filesystem::path messreihen_xml; // V9.6: optional

    for (int i = 3; i < argc; ++i) {
        std::string a{argv[i]};
        if (a.rfind("--comdare-root=", 0) == 0) {
            comdare_root = std::filesystem::path{a.substr(15)};
        } else if (a.rfind("--messreihen-xml=", 0) == 0) {
            messreihen_xml = std::filesystem::path{a.substr(17)};
        } else {
            std::cerr << "Unknown arg: " << a << "\n";
            print_usage();
            return 1;
        }
    }

    std::cout << "==== Comdare Messung-Driver (REV 7.6 V8.12) ====\n";
    std::cout << "Config-Dir   : " << config_dir.string() << "\n";
    std::cout << "Output-Dir   : " << output_dir.string() << "\n";
    std::cout << "Comdare-Root : " << comdare_root.string() << "\n";
    std::cout << "Messreihen   : 3 (A=PRT-ART vs SOTA, B=Cache-Engine, C=Merge)\n";

    // REV 7.6 V8.12 — Aktivierung des EXPERIMENT_MODE im Sub-Build (User-Direktive
    // 2026-05-13/14). Default in cache-engine ist OFF (Production-Pfad).
    // Phase 7 (Review wf_8508f98c): der fruehere #ifndef-Warnblock war ein Fehlalarm in JEDEM
    // super-Build — der Treiber-HOST erhaelt das Define nie (directory-scoped im ce-Baum,
    // Facade-Defines PRIVATE) und braucht es nicht: Mess-Hooks leben in den Tier-DLL-Kompilaten
    // (COMDARE_MEASUREMENT_ON via Facade-Weitergabe); die Invariante Experiment=>Messung
    // erzwingt der compile-time-Guard in abi_adapter.hpp je Tier-Kompilat.
    std::cout << "Mess-Hooks: in den Tier-DLL-Kompilaten aktiv (COMDARE_MEASUREMENT_ON via "
                 "Facade-Defines; Host-Define irrelevant)\n";
    std::cout << "\n";

    std::filesystem::create_directories(output_dir);

    int e4_overall_rc = 0;

#ifdef COMDARE_MESSUNG_HAVE_E4_FACADE
    {
        namespace pf = comdare::cache_engine::builder::profile_facade;

        try {
            std::string thesis_profile = env_trimmed("COMDARE_THESIS_PROFILE");
#ifdef COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE
            if (thesis_profile.empty()) thesis_profile = COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE;
#endif

            // P6/#229: E4-XML ist der DEFAULT-/ALLEINWEG. Kein Opt-in mehr — der messung_driver orchestriert den
            // Gesamtablauf AUSSCHLIESSLICH ueber die Profil-XML. Der Legacy-ExperimentDriver-Pfad (3 Messreihen)
            // laeuft nur noch bei explizitem COMDARE_LEGACY_MESSREIHEN=1 (Subsumtions-Vergleich waehrend des
            // golden-320-Voll-Laufs; danach entfaellt er ganz).
            if (thesis_profile.empty() || !std::filesystem::exists(thesis_profile)) {
                std::cerr << "[E4] thesis_profile fehlt oder existiert nicht: "
                          << (thesis_profile.empty() ? std::string{"<leer>"} : thesis_profile) << ".\n";
                e4_overall_rc = 5;
            } else {
                std::filesystem::path const e4_dir = output_dir / "e4_xml";
                std::error_code             ec;
                std::filesystem::create_directories(e4_dir, ec);
                if (ec) throw std::runtime_error("create_directories(" + e4_dir.string() + "): " + ec.message());

                pf::ProfileRunArgs pa;
                pa.profile_path      = thesis_profile;
                pa.out_csv           = e4_dir / "measurements.csv";
                pa.src_dir           = e4_dir / "src";
                pa.dll_dir           = e4_dir / "dll";
                pa.build_version     = "m3v2";
                pa.min_free_gb       = parse_min_free_gb_from_env();
                pa.platform_override = env_trimmed("COMDARE_PLATFORM");
                if (pa.platform_override.empty()) pa.platform_override = compile_time_platform_tag();

                // Achse-2-Lastprofile: leer ist OK — die run_profile-Fassade defaultet auf die zum Profil
                // co-lokalisierten Lastprofile (algorithm_profiles/load_profiles/), sodass die XML selbst-
                // suffizient ist (G1/#229). COMDARE_LOAD_PROFILE_DIR bleibt reiner Override; findet die
                // Fassade 0 gueltige Profile, bricht SIE mit exit 4 ab (Achse 2 nie still leer =
                // two_phase_valid=0-Schutz bleibt gewahrt, nur in die WIE-Schicht verlagert).
                pa.load_profile_dir = env_trimmed("COMDARE_LOAD_PROFILE_DIR");
                if (auto cap = parse_size_env_strict("COMDARE_E4_CAP")) pa.max_binaries = *cap;
                if (auto ws = parse_size_env_strict("COMDARE_WORKLOAD_RECORDS"))
                    pa.working_set_override = static_cast<std::uint64_t>(*ws);

                if (std::string const build_tag = env_trimmed("COMDARE_BUILD_VERSION"); !build_tag.empty())
                    pa.build_version_tag_override = build_tag;
                if (env_trimmed("COMDARE_RUN_SOTA") == "0") pa.run_sota_series = false;

                std::cout << "[E4] XML-Lauf via run_profile-Fassade: profile=" << thesis_profile << " -> "
                          << pa.out_csv.string() << "\n";
                pf::ProfileRunResult const rr = pf::run_profile_facade(pa);
                std::cout << "[E4] fertig: exit=" << rr.exit_code << " basis_rows=" << rr.basis_rows
                          << " sota_rows=" << rr.sota_rows << " basis_ids=" << rr.basis_binary_ids
                          << " sota_ids=" << rr.sota_binary_ids << " measured=" << rr.measured
                          << " resumed=" << rr.resumed << "\n";
                if (rr.exit_code != 0) {
                    e4_overall_rc = rr.exit_code;
                    std::cerr << "[E4] WARN: E4-XML-Lauf exit=" << rr.exit_code << ".\n";
                }
            }
        } catch (std::exception const& e) {
            std::cerr << "[E4] Fehler im E4-XML-Block: " << e.what() << ".\n";
            if (e4_overall_rc == 0) e4_overall_rc = 1;
        }
    }

    // P6/#229: E4-XML ist der Alleinweg — nach dem XML-Lauf ist der Gesamtablauf fertig. Der Legacy-
    // ExperimentDriver-Pfad (3 Messreihen via config_a/b/c) laeuft NUR bei explizitem Opt-in
    // (COMDARE_LEGACY_MESSREIHEN=1), solange die E4-XML-Subsumtion der 3 Messreihen im golden-320-Voll-Lauf
    // noch nicht bestaetigt ist. Default: E4-XML allein.
    if (env_trimmed("COMDARE_LEGACY_MESSREIHEN") != "1") return e4_overall_rc;
#endif

    // REV 7.6 V9.6 — Externe Messreihen-Spec (defined/full Mode)
    auto external_specs = load_messreihen(messreihen_xml);
    if (!external_specs.empty()) {
        std::cout << "[V9.6] Geladen aus " << messreihen_xml.string() << ": " << external_specs.size()
                  << " Messreihe(n).\n";
        for (auto const& s : external_specs) {
            std::cout << "  - " << s.id << " (mode=" << s.mode << ", profiles=" << s.sota_profiles.size() << ")\n";
        }

        // REV 7.6 V11.3 — Pro Messreihen-Spec einen ExperimentDriver-Lauf
        int         spec_overall_rc = 0;
        std::size_t spec_idx        = 0;
        for (auto const& spec : external_specs) {
            std::cout << "─────────────────────────────────────────────\n";
            std::cout << "[Reihe " << (++spec_idx) << "/" << external_specs.size() << "] [V11.3] Messreihe " << spec.id
                      << " (mode=" << spec.mode << ")\n";
            std::cout << "─────────────────────────────────────────────\n";

            cb::ExperimentDriverOptions opts;
            opts.config_dir          = config_dir;
            opts.output_dir          = output_dir / spec.id;
            opts.comdare_root        = comdare_root;
            opts.messreihen_mode     = (spec.mode == "full") ? cb::ExperimentDriverOptions::MessreihenMode::Full
                                                             : cb::ExperimentDriverOptions::MessreihenMode::Defined;
            opts.sota_profile_filter = spec.sota_profiles;

            cb::ExperimentDriver driver{opts};
            cb::WorkloadOptions  w; // Default-Workload (V11.2 routet pro Profil)
            w.config.random_seed      = 42;
            w.config.key_size_bytes   = 16;
            w.config.value_size_bytes = 64;
            w.config.num_keys         = 1000000;
            w.config.num_operations   = 5000000;
            w.config.zipfian_theta    = 0.99;
            // #31: Workload aus <workload> je <messreihe> (E4-XML); fehlt das Tag -> heutiger Default (C).
            w.workload = spec.workload.value_or(wg::YcsbWorkload::C);
            if (spec.workload) {
                std::cout << "[V11.3] Spec " << spec.id << " workload aus XML: YCSB_"
                          << static_cast<char>('A' + static_cast<int>(*spec.workload)) << "\n";
            }

            int rc = driver.run_pipeline_full(w);
            if (rc != cb::status_ok) {
                std::cerr << "[V11.3] Spec " << spec.id << " FAILED (status=" << rc << ")\n";
                spec_overall_rc = rc;
            } else {
                std::cout << "[V11.3] Spec " << spec.id << " OK -> " << opts.output_dir.string() << "\n\n";
            }
        }

        std::cout << "==== V11.3 Spec-Lauf ";
        std::cout << (spec_overall_rc == 0 ? "(OK)" : "(MIT FEHLERN)");
        std::cout << " ====\n";
        return spec_overall_rc != 0 ? spec_overall_rc : e4_overall_rc; // Bei Spec-Mode kein 3-Reihen-Fallback
    }

    constexpr std::array<MessreiheKind, 3> kinds{MessreiheKind::A_PrtArtVsSota, MessreiheKind::B_CacheEnginePerm,
                                                 MessreiheKind::C_MergeAltNeu};

    int         overall_rc = 0;
    std::size_t reihe_idx  = 0;
    for (auto kind : kinds) {
        std::cout << "─────────────────────────────────────────────\n";
        std::cout << "[Reihe " << (++reihe_idx) << "/" << kinds.size() << "] Messreihe " << messreihe_name(kind)
                  << "\n";
        std::cout << "─────────────────────────────────────────────\n";

        auto const reihe_output = output_dir / subdir_for(kind);

        cb::ExperimentDriverOptions opts;
        opts.config_dir   = config_dir;
        opts.output_dir   = reihe_output;
        opts.comdare_root = comdare_root;

        cb::ExperimentDriver driver{opts};
        cb::WorkloadOptions  w = default_workload_for(kind);

        int rc = driver.run_pipeline_full(w);
        if (rc != cb::status_ok) {
            std::cerr << "Messreihe " << messreihe_name(kind) << " FAILED (status=" << rc << ")\n";
            overall_rc = rc;
            continue;
        }
        std::cout << "Messreihe " << messreihe_name(kind) << " OK -> " << (reihe_output / "measurements.csv").string()
                  << "\n\n";
    }

    std::cout << "==== Messung-Driver komplett ";
    std::cout << (overall_rc == 0 ? "(OK)" : "(MIT FEHLERN)");
    std::cout << " ====\n";
    std::cout << "[NAECHSTER SCHRITT] binary_to_csv -> csv_to_latex -> diagram_generator -> latex_to_pdf\n";
    return overall_rc != 0 ? overall_rc : e4_overall_rc;
}
