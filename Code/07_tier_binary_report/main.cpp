// SPDX-License-Identifier: Apache-2.0
// tier_binary_report CLI (#279-a, 2026-07-07)
//
// Zwei Modi (nachgelagerte Ueberwachungs-Stufe der Mess-Pipeline):
//   --visibility <plan_dump> <perm_root> [--builder-exe=<p>] [--out=<f>]
//       Dynamische Build-Sichtbarkeit: geplante vs. gebaute vs. offene
//       Tier-Binary-Rekombinationen + CacheEngineBuilder-Status (#279(3)).
//       <plan_dump> = Rohausgabe von "comdare-messung-driver plan dump"
//       (Format v1.1). 2c/OP-8 (27.07.): EIN Format fuer dieses Werkzeug UND
//       den CI-Job visibility:tier-binaries (Ledger 73.1) -- die frueher
//       gelesene permutations_manifest.txt ist damit endgueltig abgeloest.
//       Exit 1, wenn die Quelle keine plan-dump-Ausgabe ist (kein falsches 0/0).
//   --interface-check <perm_root> [--out=<f>]
//       Laedt jedes gebaute Tier-Binary und rostert den generischen
//       Interface-Vertrag (comdare_perm_descriptor + run) je Binary
//       PASS/FAIL (#279(4)). REPORT, KEIN Gate -> Exit 0 auch bei FAILs.
//
// Die Sichtbarkeits-Logik ist reine std (tier_binary_report.hpp, unit-getestet).
// Der Plugin-Load fuer --interface-check nutzt den bestehenden Loader
// Code/02_messung_driver/plugin_loader.hpp (keine dlopen-Duplikation).

// V38.C-Disziplin: STL zuerst, plugin_loader.hpp (bringt windows.h auf Win32)
// zuletzt.
#include <cstddef>
#include <exception>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <string>
#include <string_view>
#include <vector>

#include "tier_binary_report.hpp"

#include "plugin_loader.hpp" // zuletzt: windows.h/dlfcn

namespace tbr = comdare::tier_binary_report;
namespace fs  = std::filesystem;

namespace {

void print_usage() {
    std::cerr << "Usage:\n"
              << "  tier-binary-report --visibility <plan_dump> <perm_root> [--builder-exe=<path>] [--out=<file>]\n"
              << "  tier-binary-report --interface-check <perm_root> [--out=<file>]\n"
              << "\n"
              << "  <plan_dump> = Rohausgabe von \"comdare-messung-driver plan dump\" (v1.1),\n"
              << "                z.B.: comdare-messung-driver plan dump > dump_plan.txt\n";
}

// Schreibt Text nach <out> (best-effort) und meldet den Pfad; leerer Pfad = kein Write.
void write_report(fs::path const& out, std::string const& text) {
    if (out.empty()) return;
    std::error_code ec;
    if (out.has_parent_path()) fs::create_directories(out.parent_path(), ec);
    std::ofstream os{out};
    if (os) {
        os << text;
        std::cout << "[#279] Report geschrieben: " << out.string() << "\n";
    } else {
        std::cerr << "[#279] WARN: konnte Report nicht schreiben: " << out.string() << "\n";
    }
}

[[nodiscard]] std::string opt_value(std::string_view arg, std::string_view key) {
    if (arg.rfind(key, 0) == 0) return std::string{arg.substr(key.size())};
    return {};
}

int run_visibility(std::vector<std::string> const& pos, fs::path const& out_override, fs::path const& builder_exe) {
    if (pos.size() < 2) {
        print_usage();
        return 2;
    }
    fs::path const plan_dump = pos[0];
    fs::path const perm_root = pos[1];

    tbr::PlannedSet const       planned       = tbr::parse_plan_dump(plan_dump);
    tbr::BuiltSet const         built         = tbr::scan_built(perm_root);
    bool const                  builder_built = !builder_exe.empty() && fs::exists(builder_exe);
    tbr::VisibilityReport const report        = tbr::compute_visibility(planned, built, builder_built);

    std::string const text = tbr::format_visibility(report);
    std::cout << text;

    fs::path const out = out_override.empty() ? (perm_root / "BUILD_VISIBILITY.txt") : out_override;
    write_report(out, text);

    // Formatwache (2c): eine fehlende/fremde Quelle wuerde sonst als gueltiges "0/0 gebaut"
    // durchgehen -- genau das falsche Gruen. Der Report ist geschrieben, der Exit ist hart.
    if (!planned.format_ok) {
        std::cerr << "[#279] FEHLER: " << plan_dump.string() << " ist keine plan-dump-Ausgabe v1.1 (Kopf-Anker fehlt). "
                  << "Erwartet wird die Rohausgabe von: comdare-messung-driver plan dump\n";
        return 1;
    }
    return 0;
}

int run_interface_check(std::vector<std::string> const& pos, fs::path const& out_override) {
    if (pos.size() < 1) {
        print_usage();
        return 2;
    }
    fs::path const perm_root = pos[0];

    namespace md = comdare::messung_driver;
    std::vector<tbr::InterfaceCheck> roster;

    // Report-Vertrag: NIE crashen. discover_plugin_paths (02_messung_driver) nutzt
    // den werfenden recursive_directory_iterator -> je Subsystem abfangen, damit ein
    // Rechte-Fehler unter perm_root den Roster nicht abbricht (weiter mit exit 0).
    for (char const* sub : {"cache_engine", "prt_art"}) {
        try {
            auto const paths = md::discover_plugin_paths(perm_root / sub);
            for (auto const& p : paths) {
                tbr::InterfaceCheck c;
                md::LoadedPlugin    lp = md::load_perm_plugin(p);
                c.loaded               = (lp.handle != nullptr);
                c.descriptor_ok        = (lp.desc != nullptr);
                if (c.descriptor_ok) {
                    c.id          = (lp.desc->id != nullptr) ? std::string{lp.desc->id} : p.stem().string();
                    double micros = 0.0;
                    c.run_ok      = (lp.desc->run != nullptr) && (lp.desc->run(16UL, &micros) == 0);
                } else {
                    c.id = p.stem().string();
                }
                if (lp.handle != nullptr) md::plugin_close(lp.handle);
                roster.push_back(std::move(c));
            }
        } catch (std::exception const& e) {
            std::cerr << "[#279] WARN: Subsystem '" << sub << "' unter " << perm_root.string()
                      << " nicht vollstaendig scanbar: " << e.what() << "\n";
        }
    }

    std::string const text = tbr::format_interface_roster(roster);
    std::cout << text;

    fs::path const out = out_override.empty() ? (perm_root / "INTERFACE_TEST_REPORT.txt") : out_override;
    write_report(out, text);
    return 0; // Report, kein Gate
}

} // namespace

int main(int argc, char* argv[]) {
    if (argc < 2) {
        print_usage();
        return 2;
    }

    std::string const        mode = argv[1];
    std::vector<std::string> positional;
    fs::path                 out_override;
    fs::path                 builder_exe;

    for (int i = 2; i < argc; ++i) {
        std::string const a{argv[i]};
        // Eigene Namen je Zweig (v_out/v_builder) statt zweimal 'v': der else-Zweig liegt IM Scope des
        // ersten if-init, das zweite 'v' verdeckte also das erste (-Wshadow). Hier harmlos -- im else-Zweig
        // ist das aeussere 'v' per Konstruktion leer --, aber die Verdeckung ist genau das Muster, unter dem
        // eine spaetere Zeile still den falschen Wert liest. Getrennte Namen machen das strukturell unmoeglich.
        if (std::string const v_out = opt_value(a, "--out="); !v_out.empty()) {
            out_override = v_out;
        } else if (std::string const v_builder = opt_value(a, "--builder-exe="); !v_builder.empty()) {
            builder_exe = v_builder;
        } else if (a.rfind("--", 0) == 0) {
            std::cerr << "Unbekannte Option: " << a << "\n";
            print_usage();
            return 2;
        } else {
            positional.push_back(a);
        }
    }

    if (mode == "--visibility") return run_visibility(positional, out_override, builder_exe);
    if (mode == "--interface-check") return run_interface_check(positional, out_override);

    std::cerr << "Unbekannter Modus: " << mode << "\n";
    print_usage();
    return 2;
}
