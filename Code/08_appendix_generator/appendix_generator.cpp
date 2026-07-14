// SPDX-License-Identifier: Apache-2.0
#include "appendix_generator.hpp"

#include "csv_to_latex.hpp"
#include "diagram_generator.hpp"

#include <iostream>
#include <system_error>

namespace comdare::da::appendix_generator {

namespace c2l = comdare::da::csv_to_latex;
namespace dg  = comdare::da::diagram_generator;

std::string default_bias_caption(std::string const& lang) {
    // Wortgleich zu generate_wide_appendix.ps1:61-64 (die Caption wird ROH übergeben;
    // write_bias_matrix_latex escaped selbst → hier KEIN Doppel-Escape).
    if (lang == "de") return "Bias-Bruch-Matrix (Median ns/op, Suchverfahren x Lastprofil)";
    return "Bias-break matrix (median ns/op, search method x load profile)";
}

int generate_wide_appendix(AppendixConfig const& cfg) {
    // ── Parse EINMAL: drei row-Typen, je genau einmal, über alle Sprachen wiederverwendet ──
    // (Der exe-Spawn-Weg parste je Sprache × Sub-Kommando neu; in-process fällt das weg.)

    // (1) Bias — WIDE (tier×workload): parse_wide_csv → aggregate_tier_workload (lang-unabhängig).
    std::vector<c2l::WideMeasurementRow> bias_rows;
    if (int const rc = c2l::parse_wide_csv(cfg.csv, bias_rows); rc != c2l::status_ok) {
        std::cerr << "appendix-generator: parse_wide_csv (bias) failed " << rc << "\n";
        return status_parse_error;
    }
    auto const bias_aggs = c2l::aggregate_tier_workload(bias_rows);

    // (2) Surface — WIDE + op_*_p50 (05er Parser/Row-Typ): dg::parse_wide_csv.
    std::vector<dg::WideMeasurementRow> surf_rows;
    if (int const rc = dg::parse_wide_csv(cfg.csv, surf_rows); rc != dg::status_ok) {
        std::cerr << "appendix-generator: dg::parse_wide_csv (surface) failed " << rc << "\n";
        return status_parse_error;
    }

    // (3) Exchange — volle 19-Achsen-Tupel: parse_wide_csv_full → aggregate_exchange (lang-unabhängig).
    std::vector<c2l::WideFullRow> full_rows;
    if (int const rc = c2l::parse_wide_csv_full(cfg.csv, full_rows); rc != c2l::status_ok) {
        std::cerr << "appendix-generator: parse_wide_csv_full (exchange) failed " << rc << "\n";
        return status_parse_error;
    }
    std::vector<c2l::SiblingPairCount> exch_counts;
    auto const                         exch_aggs = c2l::aggregate_exchange(full_rows, exch_counts);

    // ── Je Sprache: 12 .tex nach <out_root>/<lang>/tabellen/ (bias 1 + surface 6 + exchange 4 + limitierung 1) ──
    for (auto const& lang : cfg.langs) {
        std::filesystem::path const out_dir = cfg.out_root / lang / "tabellen";
        std::error_code             ec;
        std::filesystem::create_directories(out_dir, ec);
        if (ec) {
            std::cerr << "appendix-generator: create_directories(" << out_dir << ") failed: " << ec.message() << "\n";
            return status_io_error;
        }

        // (1) Bias-Bruch-Matrix (WIDE) — bias_matrix_table.tex.
        auto const        it      = cfg.bias_caption_by_lang.find(lang);
        std::string const caption = (it != cfg.bias_caption_by_lang.end()) ? it->second : default_bias_caption(lang);
        if (int const rc = c2l::write_bias_matrix_latex(out_dir / "bias_matrix_table.tex", bias_aggs, caption,
                                                        cfg.bias_label, lang);
            rc != c2l::status_ok) {
            std::cerr << "appendix-generator: write_bias_matrix_latex (" << lang << ") failed " << rc << "\n";
            return status_io_error;
        }

        // (2) 6× lc_surface_<z> (Heatmap je Interface-Funktion; Default-PageConstraints wie das .ps1).
        for (auto const z_sv : kSurfaceFields) {
            std::string const z{z_sv};
            if (int const rc = dg::write_surface_search_algo_x_workload(out_dir / ("lc_surface_" + z + ".tex"),
                                                                        surf_rows, z, lang);
                rc != dg::status_ok) {
                std::cerr << "appendix-generator: write_surface (" << z << "," << lang << ") failed " << rc << "\n";
                return status_io_error;
            }
        }

        // (3) 4× ld_exchange_<achse> (Writer benennt ld_exchange_*.tex selbst je variabler Achse).
        if (int const rc = c2l::write_exchange_longtables(out_dir, exch_aggs, exch_counts, lang);
            rc != c2l::status_ok) {
            std::cerr << "appendix-generator: write_exchange_longtables (" << lang << ") failed " << rc << "\n";
            return status_io_error;
        }

        // (4) le_limitierung (statisch, keine CSV). In-Process gibt es KEINE Stale-Binary-Gefahr →
        //     der .ps1-Schutz (temp-Datei + Vorbehalts-Zeilen-Zählung) entfällt ersatzlos: der Writer
        //     ist immer die frisch gelinkte Lib, kann also nie eine ältere/kürzere Tabelle emittieren.
        if (int const rc = c2l::write_limitations_longtable(out_dir / "le_limitierung.tex", lang);
            rc != c2l::status_ok) {
            std::cerr << "appendix-generator: write_limitations_longtable (" << lang << ") failed " << rc << "\n";
            return status_io_error;
        }

        // ── (5) ADDITIV (Inc-2a): 4 neue Darstellungs-Writer aus den BEREITS geparsten Rows/Aggregaten ──
        // KEIN Doppel-Parsen: die 3 05er-Writer speisen sich aus surf_rows (dg::WideMeasurementRow trägt nach
        // P4/P3 die seg_*_ns + op_*_p99_ns), der Forest-Plot aus DENSELBEN exch_aggs/exch_counts wie die Longtables.
        // HONEST-EMPTY-SEMANTIK: liefert ein Writer status_empty_input (dg=11 / c2l=12) — z.B. seg n/a (Nicht-Mess-
        // DLL), keine op_*_p99-Spalten, oder keine gültige Austausch-Zeile — legt der Writer bewusst KEINE Datei an.
        // Das ist KEIN Fehler der Gesamt-Facade (die 12 Kern-.tex sind bereits vollständig geschrieben); nur ein
        // echter status_io_error wird als status_io_error propagiert.
        auto const dg_ok  = [](int rc) { return rc == dg::status_ok || rc == dg::status_empty_input; };
        auto const c2l_ok = [](int rc) { return rc == c2l::status_ok || rc == c2l::status_empty_input; };

        // (5a) Segment-Attribution (gestapelte Balken) — surf_rows (dg::WideMeasurementRow, trägt seg_*_ns).
        if (int const rc = dg::write_segment_attribution_stacked_bar(out_dir / "seg_attribution.tex", surf_rows, lang);
            !dg_ok(rc)) {
            std::cerr << "appendix-generator: write_segment_attribution_stacked_bar (" << lang << ") failed " << rc
                      << "\n";
            return status_io_error;
        }

        // (5b) Latenz-Range (Punkt=p50, Whisker→p99) — surf_rows (trägt op_*_p99_ns).
        if (int const rc = dg::write_latency_range_bar(out_dir / "latency_range.tex", surf_rows, lang); !dg_ok(rc)) {
            std::cerr << "appendix-generator: write_latency_range_bar (" << lang << ") failed " << rc << "\n";
            return status_io_error;
        }

        // (5c) Latenz-ECDF (Config-Streuung über die Permutationen) — surf_rows.
        if (int const rc = dg::write_latency_ecdf(out_dir / "latency_ecdf.tex", surf_rows, lang); !dg_ok(rc)) {
            std::cerr << "appendix-generator: write_latency_ecdf (" << lang << ") failed " << rc << "\n";
            return status_io_error;
        }

        // (5d) Forest-Plot der Achsen-Austauschbarkeit — DIESELBEN exch_aggs/exch_counts (ns/op-Headline).
        if (int const rc =
                c2l::write_exchange_forest_plot(out_dir / "exchange_forest.tex", exch_aggs, exch_counts, lang);
            !c2l_ok(rc)) {
            std::cerr << "appendix-generator: write_exchange_forest_plot (" << lang << ") failed " << rc << "\n";
            return status_io_error;
        }

        // (5e) INC-4 (xml→pdf-Konsolidierung): Per-Achsen-Observer-Detail-Tabelle (stat_<achse>_<feld> aus
        // kV3AxisSchema[19][8], single-source). Speist sich aus DENSELBEN geparsten full_rows (c2l::WideFullRow
        // trägt seit INC-4 den durchgereichten stat_-Block) — KEIN Doppel-Parsen. HONEST-EMPTY (dg_ok): fehlt der
        // stat_-Block bzw. sind alle Zähler "n/a" (Nicht-Mess-DLL/altes Schema), liefert der Writer
        // status_empty_input → KEINE observer_detail.tex, KEIN Facade-Fehler. Thesis-\input erst INC-7 (Overleaf).
        if (int const rc = dg::write_axis_observer_detail_table(out_dir / "observer_detail.tex", full_rows, lang);
            !dg_ok(rc)) {
            std::cerr << "appendix-generator: write_axis_observer_detail_table (" << lang << ") failed " << rc << "\n";
            return status_io_error;
        }

        std::cout << "appendix-generator [" << lang
                  << "]: 12 Kern- + 5 Darstellungs-.tex (honest-empty ⇒ ggf. ausgelassen) -> " << out_dir << "\n";
    }
    return status_ok;
}

} // namespace comdare::da::appendix_generator
