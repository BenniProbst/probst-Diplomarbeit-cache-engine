// SPDX-License-Identifier: Apache-2.0
#include "csv_to_latex.hpp"

#include <iostream>
#include <vector>

namespace c2l = comdare::da::csv_to_latex;

int main(int argc, char* argv[]) {
    // L-d / L-e Sondermodi (Phase L, 2026-06-18) — VOR der allgemeinen Argument-Pruefung, da eigene Arity.
    //   --exchange=<csv> <outdir> [--lang=de|en]   → ld_exchange_<achse>.tex je variabler Achse.
    //   --limitierung <out.tex> [--lang=de|en]     → le_limitierung.tex (statisch, keine CSV).
    {
        std::string lang_ld = "en";
        for (int i = 1; i < argc; ++i) {
            std::string a{argv[i]};
            if (a.rfind("--lang=", 0) == 0) lang_ld = a.substr(7);
        }
        for (int i = 1; i < argc; ++i) {
            std::string a{argv[i]};
            if (a.rfind("--exchange=", 0) == 0) {
                std::string const csv = a.substr(11);
                std::string       outdir;
                for (int j = 1; j < argc; ++j) {
                    std::string b{argv[j]};
                    if (j != i && b.rfind("--", 0) != 0) {
                        outdir = b;
                        break;
                    }
                }
                if (outdir.empty()) {
                    std::cerr << "csv-to-latex --exchange: <outdir> fehlt\n";
                    return 1;
                }
                std::vector<c2l::WideFullRow> rows;
                int                           rc = c2l::parse_wide_csv_full(csv, rows);
                if (rc != 0) {
                    std::cerr << "csv-to-latex: parse_wide_csv_full failed " << rc << "\n";
                    return rc;
                }
                std::vector<c2l::SiblingPairCount> counts;
                auto const                         aggs = c2l::aggregate_exchange(rows, counts);
                rc                                      = c2l::write_exchange_longtables(outdir, aggs, counts, lang_ld);
                if (rc != 0) {
                    std::cerr << "csv-to-latex: write_exchange_longtables failed " << rc << "\n";
                    return rc;
                }
                std::cout << "csv-to-latex (exchange,lang=" << lang_ld << "): " << rows.size() << " rows -> "
                          << aggs.size() << " (axis x value-pair x fn)-aggregates -> " << outdir << "\n";
                for (auto const& c : counts) std::cout << "  sibling-pairs " << c.axis << "=" << c.pairs << "\n";
                return 0;
            }
            if (a == "--limitierung") {
                if (i + 1 >= argc) {
                    std::cerr << "csv-to-latex --limitierung: <out.tex> fehlt\n";
                    return 1;
                }
                std::string const out = argv[i + 1];
                int               rc  = c2l::write_limitations_longtable(out, lang_ld);
                if (rc != 0) {
                    std::cerr << "csv-to-latex: write_limitations_longtable failed " << rc << "\n";
                    return rc;
                }
                std::cout << "csv-to-latex (limitierung,lang=" << lang_ld << "): -> " << out << "\n";
                return 0;
            }
            // ── A1 / A3 / A4 (m3v2-Outputs, 2026-06-20) — alle drei: <csv> <out.tex> [--lang]. ─────────
            //   --sota-series=<csv> <out.tex>   → A1 SOTA-Reihen A/B/C (series-getrieben).
            //   --sweep-axis=<csv>  <out.tex>   → A3 9-Achsen-Austauschbarkeit (sweep_axis-getrieben).
            //   --seg-coverage=<csv> <out.tex>  → A4 seg_coverage Mess-Validitäts-Appendix.
            auto find_outpath = [&](int self) -> std::string {
                for (int j = 1; j < argc; ++j) {
                    std::string b{argv[j]};
                    if (j != self && b.rfind("--", 0) != 0) return b;
                }
                return {};
            };
            if (a.rfind("--sota-series=", 0) == 0 || a.rfind("--sweep-axis=", 0) == 0 ||
                a.rfind("--seg-coverage=", 0) == 0) {
                std::size_t const eq   = a.find('=');
                std::string const mode = a.substr(2, eq - 2);
                std::string const csv  = a.substr(eq + 1);
                std::string const out  = find_outpath(i);
                if (out.empty()) {
                    std::cerr << "csv-to-latex --" << mode << ": <out.tex> fehlt\n";
                    return 1;
                }
                std::vector<c2l::WideFullRow> rows;
                int                           rc = c2l::parse_wide_csv_full(csv, rows);
                if (rc != 0) {
                    std::cerr << "csv-to-latex: parse_wide_csv_full failed " << rc << "\n";
                    return rc;
                }
                bool const de = (lang_ld == "de");
                if (mode == "sota-series") {
                    std::string const cap = de ? "SOTA-Reihen-Vergleich A/B/C: Median ns/op je Interface-Funktion "
                                                 "(PRT-ART vs SOTA je Reihe)"
                                               : "SOTA series comparison A/B/C: median ns/op per interface function "
                                                 "(PRT-ART vs SOTA per series)";
                    rc = c2l::write_sota_series_table(out, rows, cap, "tab:m3v2:sota:series", lang_ld);
                } else if (mode == "sweep-axis") {
                    rc = c2l::write_sweep_axis_longtable(out, rows, de ? "Sweep" : "Sweep", lang_ld);
                } else {
                    // Plain-Text-Caption (escape_latex im Writer kümmert sich um _, ", etc. → kein Doppel-Escape).
                    std::string const cap =
                        de ? "Mess-Validitaet: seg_coverage je Lebewesen (Pfad-B-Abdeckung Sum(seg)/run_total)"
                           : "Measurement validity: seg_coverage per living being (path-B coverage Sum(seg)/run_total)";
                    rc = c2l::write_seg_coverage_appendix(out, rows, cap, "tab:m3v2:seg:coverage", lang_ld);
                }
                if (rc != 0) {
                    std::cerr << "csv-to-latex --" << mode << ": write failed " << rc << "\n";
                    return rc;
                }
                std::cout << "csv-to-latex (" << mode << ",lang=" << lang_ld << "): " << rows.size() << " rows -> "
                          << out << "\n";
                return 0;
            }
        }
    }

    if (argc < 3) {
        std::cerr << "Usage: csv-to-latex <input.csv> <output.tex> "
                  << "[--caption=<text>] [--label=<text>] [--lang=de|en] [--schema=legacy|wide]\n"
                  << "  --schema=wide: tier×workload-WIDE-Schema (';'-getrennt, header-getrieben) →\n"
                  << "                 Bias-Bruch-Matrix (Zeilen=search_algo, Spalten=Lastprofile,\n"
                  << "                 Zelle=Median ns/op, nur two_phase_valid).\n"
                  << "  --exchange=<csv> <outdir> [--lang]: L-d Achsen-Austauschbarkeits-longtables.\n"
                  << "  --limitierung <out.tex> [--lang]:   L-e ehrliche Limitierungs-longtable.\n";
        return 1;
    }
    std::string caption = "Comdare Permutations";
    std::string label   = "tab:comdare:perms";
    std::string lang    = "en";     // C2 (2026-06-01): bilingualer Compile-Schalter (de|en)
    std::string schema  = "legacy"; // 2026-06-11: "wide" = tier×workload-Schema des Mess-Voll-Laufs
    for (int i = 3; i < argc; ++i) {
        std::string a{argv[i]};
        if (a.rfind("--caption=", 0) == 0)
            caption = a.substr(10);
        else if (a.rfind("--label=", 0) == 0)
            label = a.substr(8);
        else if (a.rfind("--lang=", 0) == 0)
            lang = a.substr(7);
        else if (a.rfind("--schema=", 0) == 0)
            schema = a.substr(9);
    }

    if (schema == "wide") {
        std::vector<c2l::WideMeasurementRow> rows;
        int                                  rc = c2l::parse_wide_csv(argv[1], rows);
        if (rc != 0) {
            std::cerr << "csv-to-latex: parse_wide_csv failed " << rc << "\n";
            return rc;
        }
        auto const aggs = c2l::aggregate_tier_workload(rows);
        rc              = c2l::write_bias_matrix_latex(argv[2], aggs, caption, label, lang);
        if (rc != 0) {
            std::cerr << "csv-to-latex: write_bias_matrix_latex failed " << rc << "\n";
            return rc;
        }
        std::cout << "csv-to-latex (wide): " << rows.size() << " rows -> " << aggs.size()
                  << " (search_algo×workload)-Zellen -> " << argv[2] << "\n";
        return 0;
    }

    std::vector<c2l::CsvRow> rows;
    int                      rc = c2l::parse_csv(argv[1], rows);
    if (rc != 0) {
        std::cerr << "csv-to-latex: parse_csv failed " << rc << "\n";
        return rc;
    }
    rc = c2l::write_latex(argv[2], rows, caption, label, lang);
    if (rc != 0) {
        std::cerr << "csv-to-latex: write_latex failed " << rc << "\n";
        return rc;
    }
    std::cout << "csv-to-latex: " << rows.size() << " rows -> " << argv[2] << "\n";
    return 0;
}
