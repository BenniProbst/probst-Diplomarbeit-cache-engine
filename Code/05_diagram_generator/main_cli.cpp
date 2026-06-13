// SPDX-License-Identifier: Apache-2.0
// CLI fuer diagram_generator: liest CSV → erzeugt TikZ Bar-Chart-Demo.
// Echter Pipeline-Aufruf erfolgt aus messung_driver.

#include "diagram_generator.hpp"

#include <fstream>
#include <iostream>
#include <span>
#include <sstream>
#include <string>
#include <vector>

namespace dg = comdare::da::diagram_generator;

// L2 (2026-06-13) — wide3d-Modus: aus der WIDE-CSV (Stufe 04 / L1) je Interface-Funktion EIN
// 3D-pgfplots-Surface erzeugen. CLI: diagram-generator --mode=wide3d --csv <pfad> --out <dir>
// [--exclude=<wl1,wl2,...>]. Bricht die bestehenden Modi NICHT (separater, früher Pfad).
namespace {
[[nodiscard]] std::vector<std::string> split_comma(std::string const& s) {
    std::vector<std::string> out;
    std::string cur;
    for (char c : s) { if (c == ',') { if (!cur.empty()) out.push_back(cur); cur.clear(); } else cur.push_back(c); }
    if (!cur.empty()) out.push_back(cur);
    return out;
}

[[nodiscard]] int run_wide3d(int argc, char* argv[]) {
    std::string csv_path, out_dir;
    std::vector<std::string> excluded;
    for (int i = 2; i < argc; ++i) {
        std::string a{argv[i]};
        if (a.rfind("--csv=", 0) == 0)          csv_path = a.substr(6);
        else if (a == "--csv" && i + 1 < argc)  csv_path = argv[++i];
        else if (a.rfind("--out=", 0) == 0)     out_dir  = a.substr(6);
        else if (a == "--out" && i + 1 < argc)  out_dir  = argv[++i];
        else if (a.rfind("--exclude=", 0) == 0) excluded = split_comma(a.substr(10));
    }
    if (csv_path.empty() || out_dir.empty()) {
        std::cerr << "Usage: diagram-generator --mode=wide3d --csv <wide.csv> --out <dir> "
                     "[--exclude=ycsb_e,lp_range_scan]\n";
        return 1;
    }
    std::vector<dg::Surface3dModel> models;
    std::span<std::string const> exc = excluded.empty()
        ? std::span<std::string const>{}    // Builder nimmt Default-Scan-Ausschluss
        : std::span<std::string const>{excluded};
    int const rc = dg::generate_wide3d_surfaces(csv_path, out_dir, models, exc);
    if (rc != 0) {
        std::cerr << "generate_wide3d_surfaces failed: " << rc << "\n";
        return rc;
    }
    std::size_t total_real = 0;
    for (auto const& m : models) {
        std::cout << "  surface[" << m.op_name << "] : "
                  << m.real_cell_count << " echte z-Zellen ("
                  << m.tier_ids.size() << " tiers x " << m.workload_ids.size() << " workloads)\n";
        total_real += m.real_cell_count;
    }
    std::cout << "diagram-generator wide3d: " << models.size() << " surfaces, "
              << total_real << " echte z-Zellen gesamt -> " << out_dir << "\n";
    return 0;
}
}  // anonymous namespace

int main(int argc, char* argv[]) {
    // L2 — wide3d-Modus (3D-Surfaces je Interface-Funktion); separater, früher Pfad.
    if (argc >= 2 && std::string{argv[1]} == "--mode=wide3d") {
        return run_wide3d(argc, argv);
    }

    // V22.1 — neuer Subcommand --by-workload erzeugt gruppierten Bar-Chart aus
    // V20.3-konformer measurements.csv (16 Spalten inkl. workload_used).
    if (argc >= 4 && std::string{argv[1]} == "--by-workload") {
        auto rows = dg::load_csv_with_workload_used(argv[2]);
        if (rows.empty()) {
            std::cerr << "load_csv_with_workload_used: 0 rows\n";
            return 11;
        }
        int const rc = dg::write_throughput_by_workload(argv[3], rows);
        if (rc != 0) {
            std::cerr << "write_throughput_by_workload failed: " << rc << "\n";
            return rc;
        }
        std::cout << "diagram-generator: " << rows.size()
                  << " rows by workload -> " << argv[3] << "\n";
        return 0;
    }

    if (argc < 3) {
        std::cerr << "Usage: diagram-generator <input.csv> <output.tex> [--lang=de|en] [--body-only]\n"
                  << "       (Demo: liest 1. Spalte = label, total_cycles = value)\n"
                  << "       (--body-only: nur tikzpicture, ohne figure/caption — Caller wrappt)\n"
                  << "  oder: diagram-generator --by-workload <input.csv> <output.tex>\n"
                  << "       (V22.1: V20.3-CSV gruppiert nach workload_used)\n"
                  << "  oder: diagram-generator --mode=wide3d --csv <wide.csv> --out <dir> [--exclude=wl1,wl2]\n"
                  << "       (L2: 3D-Surface je Interface-Funktion; Scan-Profile ycsb_e/lp_range_scan ausgeschlossen)\n";
        return 1;
    }
    std::ifstream f{argv[1]};
    if (!f) { std::cerr << "Input not readable\n"; return 10; }

    // C2 (2026-06-01): bilingualer Compile-Schalter --lang=de|en (lokalisiert Titel + Achsen).
    // C1 (2026-06-01): --body-only emittiert nur den tikzpicture-Rumpf (figure/caption
    //                  steuert das einbindende Dokument → spec-Caption + \label).
    std::string lang = "en";
    dg::PageConstraints cnst;
    for (int i = 3; i < argc; ++i) {
        std::string a{argv[i]};
        if (a.rfind("--lang=", 0) == 0) lang = a.substr(7);
        else if (a == "--body-only") cnst.body_only = true;
    }
    dg::BarChartData bar;
    if (lang == "de") {
        bar.title   = "Comdare-Messvergleich";
        bar.x_label = "Permutation";
        bar.y_label = "Zyklen";
    } else {
        bar.title   = "Comdare Measurement Comparison";
        bar.x_label = "Permutation";
        bar.y_label = "Cycles";
    }

    std::string line;
    std::getline(f, line);  // skip header
    while (std::getline(f, line)) {
        if (line.empty()) continue;
        auto comma = line.find(',');
        if (comma == std::string::npos) continue;
        bar.labels.push_back(line.substr(0, comma));
        auto next_comma = line.find(',', comma + 1);
        // op_count + total_cycles als value (Spalte 4 nach Schema)
        // iss beginnt NACH dem ersten Komma: idx0=fingerprint, idx1=succeeded,
        // idx2=workload_used, idx3=op_count, idx4=total_cycles. Die Y-Achse heißt
        // "Zyklen/Cycles" (s.o.) → es MUSS total_cycles (idx 4) geplottet werden,
        // nicht op_count (Korrektheits-Fix 2026-06-01, C1: Achse ↔ Wert konsistent).
        std::istringstream iss{line.substr(comma + 1)};
        std::string token;
        int idx = 0;
        double val = 0.0;
        while (std::getline(iss, token, ',')) {
            if (idx == 4) {  // total_cycles
                try { val = std::stod(token); } catch (...) {}
                break;
            }
            ++idx;
        }
        bar.values.push_back(val);
    }

    int rc = dg::write_bar_chart(argv[2], bar, cnst);
    if (rc != 0) {
        std::cerr << "write_bar_chart failed: " << rc << "\n";
        return rc;
    }
    std::cout << "diagram-generator: " << bar.labels.size()
              << " bars -> " << argv[2] << "\n";
    return 0;
}
