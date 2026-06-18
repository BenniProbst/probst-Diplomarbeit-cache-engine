// SPDX-License-Identifier: Apache-2.0
// CLI fuer diagram_generator: liest CSV → erzeugt TikZ Bar-Chart-Demo.
// Echter Pipeline-Aufruf erfolgt aus messung_driver.

#include "diagram_generator.hpp"

#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

namespace dg = comdare::da::diagram_generator;

int main(int argc, char* argv[]) {
    // L-c (2026-06-18) — Surface/Heatmap je Interface-Funktion aus der WIDE-Matrix.
    //   diagram-generator --surface=<z_field> <wide.csv> <out.tex> [--lang=de|en]
    //                     [--3d] [--body-only]
    //   z_field ∈ {ns_per_op, op_insert_p50_ns, op_lookup_p50_ns, op_erase_p50_ns,
    //              op_scan_p50_ns, op_rmw_p50_ns}.
    // --3d → echte 3D-Surface (view={45}{30}, z log-skaliert); sonst 2D-Heatmap (viridis).
    if (argc >= 4 && std::string{argv[1]}.rfind("--surface=", 0) == 0) {
        std::string const z_field = std::string{argv[1]}.substr(10);
        char const* in_csv  = argv[2];
        char const* out_tex = argv[3];
        std::string lang = "en";
        bool want_3d = false;
        dg::PageConstraints cnst;
        for (int i = 4; i < argc; ++i) {
            std::string a{argv[i]};
            if (a.rfind("--lang=", 0) == 0) lang = a.substr(7);
            else if (a == "--3d") want_3d = true;
            else if (a == "--body-only") cnst.body_only = true;
        }

        std::vector<dg::WideMeasurementRow> rows;
        int const prc = dg::parse_wide_csv(in_csv, rows);
        if (prc != 0) {
            std::cerr << "parse_wide_csv failed: " << prc << " (10=io,11=empty/header/parse)\n";
            return prc;
        }
        if (rows.empty()) { std::cerr << "parse_wide_csv: 0 rows\n"; return 11; }

        int const rc = want_3d
            ? dg::write_surface3d_search_algo_x_workload(out_tex, rows, z_field, lang, cnst)
            : dg::write_surface_search_algo_x_workload(out_tex, rows, z_field, lang, cnst);
        if (rc != 0) {
            std::cerr << "write_surface failed: " << rc << "\n";
            return rc;
        }
        std::cout << "diagram-generator: surface z=" << z_field
                  << (want_3d ? " [3d]" : " [heatmap]")
                  << " from " << rows.size() << " wide rows -> " << out_tex << "\n";
        return 0;
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
                  << "  oder: diagram-generator --surface=<z_field> <wide.csv> <output.tex> [--lang=de|en] [--3d] [--body-only]\n"
                  << "       (L-c: WIDE-Matrix → Surface/Heatmap je Interface-Funktion;\n"
                  << "        z_field: ns_per_op|op_insert_p50_ns|op_lookup_p50_ns|op_erase_p50_ns|op_scan_p50_ns|op_rmw_p50_ns)\n";
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
