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
// damit <regex> & co. nicht durch Windows-Makros gestoert werden.
#include <array>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <regex>
#include <sstream>
#include <string>
#include <string_view>
#include <vector>

#include "experiment_driver/experiment_driver.hpp"
#include "xml_config_parser/xml_config_parser.hpp"
#include "permutations_runtime_check.hpp"  // V36.D
#include "measurement_writer.hpp"          // V41.B1

#include <comdare/workload_generator/workload_generator.hpp>

// V38.C - bringt windows.h auf Win32 (LEAN_AND_MEAN + NOMINMAX gesetzt).
// MUSS am Ende stehen, sonst clash mit STL via Windows-Makros.
// V38.C.2 Workaround: windows.h definiert auf manchen SDK-Versionen Macros
// die das raw-string-Parsing in main.cpp stoeren. #undef vor Includes setzen.
#include "plugin_loader.hpp"               // V38.C
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

enum class MessreiheKind : std::uint8_t {
    A_PrtArtVsSota    = 0,
    B_CacheEnginePerm = 1,
    C_MergeAltNeu     = 2,
};

[[nodiscard]] std::string_view messreihe_name(MessreiheKind k) noexcept {
    switch (k) {
        case MessreiheKind::A_PrtArtVsSota:    return "A_PRT_ART_vs_SOTA";
        case MessreiheKind::B_CacheEnginePerm: return "B_CacheEngine_Perms";
        case MessreiheKind::C_MergeAltNeu:     return "C_Merge_Alt_Neu";
    }
    return "Unknown";
}

[[nodiscard]] std::filesystem::path subdir_for(MessreiheKind k) {
    return std::string{messreihe_name(k)};
}

[[nodiscard]] cb::WorkloadOptions default_workload_for(MessreiheKind k) {
    cb::WorkloadOptions w;
    w.config.random_seed    = 42;
    w.config.key_size_bytes = 16;
    w.config.value_size_bytes = 64;
    w.config.zipfian_theta  = 0.99;

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
        << "Erwartete Files in <config_dir>:\n"
        << "  cache_engine_permutations.xml\n"
        << "  search_algorithm_permutations.xml\n"
        << "  allocator_permutations.xml\n"
        << "  test_data_sets.xml\n"
        << "  (optional, V9.6) messreihen.xml — defined/full Mode pro Reihe\n\n"
        << "Output (separat pro Messreihe A/B/C):\n"
        << "  <output_dir>/A_PRT_ART_vs_SOTA/measurements.{csv,json}\n"
        << "  <output_dir>/B_CacheEngine_Perms/measurements.{csv,json}\n"
        << "  <output_dir>/C_Merge_Alt_Neu/measurements.{csv,json}\n";
}

// REV 7.6 V9.6 — minimaler XML-Reader fuer messreihe-Tags (defined/full Mode)
struct MessreihenSpec {
    std::string id;
    std::string mode;           // "defined" oder "full"
    std::vector<std::string> sota_profiles;
};

[[nodiscard]] std::vector<MessreihenSpec> load_messreihen(std::filesystem::path const& xml_path) {
    std::vector<MessreihenSpec> result;
    if (!std::filesystem::exists(xml_path)) return result;

    std::ifstream in{xml_path};
    std::ostringstream ss;
    ss << in.rdbuf();
    auto content = ss.str();

    std::regex reihe_re{"<messreihe\\s+id\\s*=\\s*\"([^\"]+)\"[^>]*>([\\s\\S]*?)</messreihe>"};
    auto it = std::sregex_iterator(content.begin(), content.end(), reihe_re);
    auto end = std::sregex_iterator();
    for (; it != end; ++it) {
        MessreihenSpec spec;
        spec.id = (*it)[1].str();
        std::string inner = (*it)[2].str();

        std::regex mode_re{"<mode>(\\w+)</mode>"};
        std::smatch mm;
        if (std::regex_search(inner, mm, mode_re)) spec.mode = mm[1].str();
        else                                        spec.mode = "defined";

        std::regex prof_re{"<profile>([^<]+)</profile>"};
        auto pit = std::sregex_iterator(inner.begin(), inner.end(), prof_re);
        auto pend = std::sregex_iterator();
        for (; pit != pend; ++pit) {
            spec.sota_profiles.push_back((*pit)[1].str());
        }
        result.push_back(std::move(spec));
    }
    return result;
}

}  // anonymous

int main(int argc, char* argv[]) {
    if (argc < 3) { print_usage(); return 1; }

    // V36.D: Pre-Build-Permutationen-Check. Wenn KEINE Permutationen
    // vorhanden sind, hat das Experiment keinen Sinn -> Fatal mit Exit 2.
    if (int rc = comdare::messung_driver::assert_permutations_available_or_die(); rc != 0) {
        return rc;
    }

    // V37.C (2026-05-23): Manifest-Iteration — pro Permutation ein Eintrag.
    {
        auto perms = comdare::messung_driver::load_all_permutations();
        std::cout << "[V37.C] Permutations-Inventar: " << perms.size() << " Eintraege\n";
        std::size_t i {0};
        for (auto const& p : perms) {
            std::cout << "  [" << (++i) << "/" << perms.size() << "] "
                      << p.subsystem << " :: " << p.id << "\n";
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
            exe_dir = exe_dir.parent_path();
            perm_root = exe_dir / "perm";
        }
        if (!std::filesystem::exists(perm_root)) {
            std::cerr << "[V38.C] perm-Root nicht gefunden, ueberspringe Plugin-Mikrobenchmark\n";
        } else {
            std::cout << "[V38.C] lade Plugins aus: " << perm_root.string() << "\n";
            auto plugins = comdare::messung_driver::load_all_perm_plugins(perm_root);
            constexpr unsigned long kRunOps = 1000;
            std::cout << "[V38.C] " << plugins.size() << " Plugins geladen, fuehre Mikrobenchmark aus (N=" << kRunOps << ")\n";

            // V41.B1: ein Aggregat-File fuer alle Permutationen
            std::filesystem::path const v41_out_dir = std::filesystem::path{argv[2]} / "measurements";
            std::filesystem::create_directories(v41_out_dir);
            comdare::messung_driver::MeasurementWriter writer{v41_out_dir / "all_permutations.bin"};
            if (!writer.ok()) {
                std::cerr << "[V41.B1] WARN: konnte " << (v41_out_dir / "all_permutations.bin").string()
                          << " nicht oeffnen, ueberspringe binary records\n";
            }

            for (auto const& p : plugins) {
                double micros = 0.0;
                int rc = p.desc->run(kRunOps, &micros);
                bool const succeeded = (rc == 0);
                if (succeeded) {
                    std::cout << "  [OK] " << p.desc->id
                              << "  v" << p.desc->version
                              << "  axes={" << p.desc->axes << "}"
                              << "  " << micros << " us/op\n";
                } else {
                    std::cout << "  [ERR rc=" << rc << "] " << p.desc->id << "\n";
                }
                if (writer.ok()) {
                    auto rec = comdare::messung_driver::make_record_from_run(
                        static_cast<std::uint64_t>(kRunOps), micros);
                    auto fp = comdare::messung_driver::fingerprint_of(p.desc->id);
                    writer.add(p.desc->id, fp, succeeded, rec);
                }
            }
            writer.finalize();
            if (writer.ok() || writer.count() > 0) {
                std::cout << "[V41.B1] " << writer.count() << " binary records geschrieben: "
                          << writer.path().string() << "\n";
            }
            comdare::messung_driver::unload_all(plugins);
        }
    }

    std::filesystem::path config_dir{argv[1]};
    std::filesystem::path output_dir{argv[2]};
    std::filesystem::path comdare_root = std::filesystem::current_path();
    std::filesystem::path messreihen_xml;  // V9.6: optional

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
    // Beim Sub-Build der Permutations-Module muss das Flag explizit ON sein,
    // damit ResultAggregator + Mess-Hooks in der ExecutionEngine kompiliert werden.
#ifndef COMDARE_EXPERIMENT_MODE_ON
    std::cerr << "[V8.12] WARNING: COMDARE_EXPERIMENT_MODE_ON ist NICHT definiert.\n"
              << "         Der messung_driver wurde ohne Mess-Hooks gebaut.\n"
              << "         Build mit: cmake -DCOMDARE_EXPERIMENT_MODE=ON\n";
#else
    std::cout << "Experiment-Mode: ON (ResultAggregator in ExecutionEngine aktiv)\n";
#endif
    std::cout << "\n";

    std::filesystem::create_directories(output_dir);

    // REV 7.6 V9.6 — Externe Messreihen-Spec (defined/full Mode)
    auto external_specs = load_messreihen(messreihen_xml);
    if (!external_specs.empty()) {
        std::cout << "[V9.6] Geladen aus " << messreihen_xml.string()
                  << ": " << external_specs.size() << " Messreihe(n).\n";
        for (auto const& s : external_specs) {
            std::cout << "  - " << s.id << " (mode=" << s.mode
                      << ", profiles=" << s.sota_profiles.size() << ")\n";
        }

        // REV 7.6 V11.3 — Pro Messreihen-Spec einen ExperimentDriver-Lauf
        int spec_overall_rc = 0;
        for (auto const& spec : external_specs) {
            std::cout << "─────────────────────────────────────────────\n";
            std::cout << "[V11.3] Messreihe " << spec.id << " (mode=" << spec.mode << ")\n";
            std::cout << "─────────────────────────────────────────────\n";

            cb::ExperimentDriverOptions opts;
            opts.config_dir   = config_dir;
            opts.output_dir   = output_dir / spec.id;
            opts.comdare_root = comdare_root;
            opts.messreihen_mode = (spec.mode == "full")
                ? cb::ExperimentDriverOptions::MessreihenMode::Full
                : cb::ExperimentDriverOptions::MessreihenMode::Defined;
            opts.sota_profile_filter = spec.sota_profiles;

            cb::ExperimentDriver  driver{opts};
            cb::WorkloadOptions   w;  // Default-Workload (V11.2 routet pro Profil)
            w.config.random_seed     = 42;
            w.config.key_size_bytes  = 16;
            w.config.value_size_bytes = 64;
            w.config.num_keys        = 1000000;
            w.config.num_operations  = 5000000;
            w.config.zipfian_theta   = 0.99;
            w.workload               = wg::YcsbWorkload::C;

            int rc = driver.run_pipeline_full(w);
            if (rc != cb::status_ok) {
                std::cerr << "[V11.3] Spec " << spec.id << " FAILED (status=" << rc << ")\n";
                spec_overall_rc = rc;
            } else {
                std::cout << "[V11.3] Spec " << spec.id << " OK -> "
                          << opts.output_dir.string() << "\n\n";
            }
        }

        std::cout << "==== V11.3 Spec-Lauf ";
        std::cout << (spec_overall_rc == 0 ? "(OK)" : "(MIT FEHLERN)");
        std::cout << " ====\n";
        return spec_overall_rc;  // Bei Spec-Mode beenden wir hier (kein 3-Reihen-Fallback)
    }

    constexpr std::array<MessreiheKind, 3> kinds{
        MessreiheKind::A_PrtArtVsSota,
        MessreiheKind::B_CacheEnginePerm,
        MessreiheKind::C_MergeAltNeu};

    int overall_rc = 0;
    for (auto kind : kinds) {
        std::cout << "─────────────────────────────────────────────\n";
        std::cout << "Messreihe " << messreihe_name(kind) << "\n";
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
            std::cerr << "Messreihe " << messreihe_name(kind)
                      << " FAILED (status=" << rc << ")\n";
            overall_rc = rc;
            continue;
        }
        std::cout << "Messreihe " << messreihe_name(kind) << " OK -> "
                  << (reihe_output / "measurements.csv").string() << "\n\n";
    }

    std::cout << "==== Messung-Driver komplett ";
    std::cout << (overall_rc == 0 ? "(OK)" : "(MIT FEHLERN)");
    std::cout << " ====\n";
    std::cout << "[NAECHSTER SCHRITT] binary_to_csv -> csv_to_latex -> diagram_generator -> latex_to_pdf\n";
    return overall_rc;
}
