// Increment 1 (2026-07) — Regressions-Test Pipeline-Stufe 08 (appendix_generator).
//
// BEWEIS: der In-Process-Orchestrator generate_wide_appendix() ersetzt die 8 .exe-
// Spawns des PowerShell-Behelfswegs generate_wide_appendix.ps1 EXAKT. Dazu:
//   Pfad A: generate_wide_appendix(cfg)                         -> temp-outdir A
//   Pfad B: die äquivalenten Einzel-Writer, in-process nachgestellt (= die früheren
//           csv-to-latex.exe / diagram-generator.exe-Aufrufe) -> temp-outdir B
// und assertet, dass JEDE erzeugte .tex byte-identisch zwischen A und B ist.

#include "appendix_generator.hpp"
#include "csv_to_latex.hpp"
#include "diagram_generator.hpp"

#include <gtest/gtest.h>

#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <string>
#include <unistd.h>
#include <vector>

namespace ag  = comdare::da::appendix_generator;
namespace c2l = comdare::da::csv_to_latex;
namespace dg  = comdare::da::diagram_generator;
namespace fs  = std::filesystem;

namespace {

// Benutzer-eindeutige tmp-Basis (prod1: /tmp host-weit geteilt zwischen comdare/gitlab-runner).
fs::path comdare_user_tmp() {
    auto p = fs::temp_directory_path() / ("comdare_test_" + std::to_string(::getuid()));
    fs::create_directories(p);
    return p;
}

fs::path fixtures_dir() {
    if (auto* env = std::getenv("COMDARE_FIXTURES_DIR_08"); env != nullptr) { return fs::path(env); }
#ifdef COMDARE_FIXTURES_DIR_08_FALLBACK
    return fs::path(COMDARE_FIXTURES_DIR_08_FALLBACK);
#else
    return fs::current_path() / "fixtures" / "cached";
#endif
}

// Selbstheilende Regeneration der WIDE-Fixture (schema-treu zu allen drei Parsern:
// 04::parse_wide_csv [bias], 05::parse_wide_csv [surface], 04::parse_wide_csv_full
// [exchange]). Nur schreiben, wenn die committete Datei fehlt (sonst = committed).
void ensure_fixture(fs::path const& p) {
    if (fs::exists(p)) return;
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    f << "binary_id;repetition;n_ops;total_ns;ns_per_op;workload;two_phase_valid;"
      << "op_insert_p50_ns;op_lookup_p50_ns;op_erase_p50_ns;op_scan_p50_ns;op_rmw_p50_ns\n";
    f << "search_algo=k_ary/node_type=node4/memory_layout=aos/"
         "prefetch=off;0;1000;100000;100.0;ycsb_c;1;30.0;25.0;28.0;500.0;40.0\n";
    f << "search_algo=k_ary/node_type=node4/memory_layout=aos/"
         "prefetch=off;1;1000;110000;110.0;ycsb_c;1;31.0;26.0;29.0;510.0;41.0\n";
    f << "search_algo=k_ary/node_type=node4/memory_layout=aos/"
         "prefetch=off;2;1000;120000;120.0;ycsb_c;1;32.0;27.0;30.0;520.0;42.0\n";
    f << "search_algo=k_ary/node_type=node4/memory_layout=aos/"
         "prefetch=off;0;1000;200000;200.0;ycsb_a;1;60.0;50.0;55.0;900.0;70.0\n";
    f << "search_algo=eytzinger/node_type=node4/memory_layout=aos/"
         "prefetch=off;0;1000;150000;150.0;ycsb_c;1;35.0;20.0;31.0;600.0;45.0\n";
    f << "search_algo=eytzinger/node_type=node4/memory_layout=aos/"
         "prefetch=off;1;1000;9999000;9999.0;ycsb_c;0;1.0;1.0;1.0;1.0;1.0\n";
    f << "search_algo=k_ary/node_type=node16/memory_layout=aos/"
         "prefetch=off;0;1000;130000;130.0;ycsb_c;1;33.0;28.0;32.0;530.0;43.0\n";
    f << "search_algo=k_ary/node_type=node4/memory_layout=soa/"
         "prefetch=off;0;1000;90000;90.0;ycsb_c;1;28.0;22.0;25.0;480.0;38.0\n";
    f << "search_algo=k_ary/node_type=node4/memory_layout=aos/"
         "prefetch=on;0;1000;95000;95.0;ycsb_c;1;29.0;23.0;26.0;490.0;39.0\n";
}

std::string read_all(fs::path const& p) {
    std::ifstream in(p, std::ios::binary);
    return std::string((std::istreambuf_iterator<char>(in)), {});
}

// Referenz-Pfad B: die äquivalenten Einzel-Writer (= die früheren .exe-Spawns des
// .ps1), unabhängig vom Orchestrator nachgestellt — dieselbe Writer-Sequenz, die
// generate_wide_appendix intern kapselt. 0 = ok.
int run_individual_writers(fs::path const& csv, fs::path const& out_root, std::vector<std::string> const& langs,
                           std::string const& label) {
    std::vector<c2l::WideMeasurementRow> bias_rows;
    if (c2l::parse_wide_csv(csv, bias_rows) != c2l::status_ok) return 1;
    auto const bias_aggs = c2l::aggregate_tier_workload(bias_rows);

    std::vector<dg::WideMeasurementRow> surf_rows;
    if (dg::parse_wide_csv(csv, surf_rows) != dg::status_ok) return 1;

    std::vector<c2l::WideFullRow> full_rows;
    if (c2l::parse_wide_csv_full(csv, full_rows) != c2l::status_ok) return 1;
    std::vector<c2l::SiblingPairCount> counts;
    auto const                         exch_aggs = c2l::aggregate_exchange(full_rows, counts);

    for (auto const& lang : langs) {
        fs::path const out_dir = out_root / lang / "tabellen";
        fs::create_directories(out_dir);
        // (1) bias
        if (c2l::write_bias_matrix_latex(out_dir / "bias_matrix_table.tex", bias_aggs, ag::default_bias_caption(lang),
                                         label, lang) != c2l::status_ok)
            return 2;
        // (2) 6× surface
        for (auto const z_sv : ag::kSurfaceFields) {
            std::string const z{z_sv};
            if (dg::write_surface_search_algo_x_workload(out_dir / ("lc_surface_" + z + ".tex"), surf_rows, z, lang) !=
                dg::status_ok)
                return 3;
        }
        // (3) 4× exchange (Writer benennt ld_exchange_*.tex selbst)
        if (c2l::write_exchange_longtables(out_dir, exch_aggs, counts, lang) != c2l::status_ok) return 4;
        // (4) limitierung
        if (c2l::write_limitations_longtable(out_dir / "le_limitierung.tex", lang) != c2l::status_ok) return 5;
    }
    return 0;
}

// Die 12 erwarteten Dateinamen je Sprache (bias 1 + surface 6 + exchange 4 + limitierung 1).
std::vector<std::string> expected_files() {
    std::vector<std::string> names;
    names.push_back("bias_matrix_table.tex");
    for (auto const z : ag::kSurfaceFields) names.push_back("lc_surface_" + std::string{z} + ".tex");
    for (auto const ax : c2l::kVariableAxes) names.push_back("ld_exchange_" + std::string{ax} + ".tex");
    names.push_back("le_limitierung.tex");
    return names;
}

} // namespace

TEST(Stufe08Appendix, FixtureIsFullWideSchema) {
    auto const fixture = fixtures_dir() / "tier_wide_appendix.csv";
    ensure_fixture(fixture);
    ASSERT_TRUE(fs::exists(fixture));
    // Alle drei Parser müssen die Fixture akzeptieren.
    std::vector<c2l::WideMeasurementRow> a;
    EXPECT_EQ(c2l::parse_wide_csv(fixture, a), c2l::status_ok);
    std::vector<dg::WideMeasurementRow> b;
    EXPECT_EQ(dg::parse_wide_csv(fixture, b), dg::status_ok);
    std::vector<c2l::WideFullRow> c;
    EXPECT_EQ(c2l::parse_wide_csv_full(fixture, c), c2l::status_ok);
    EXPECT_GT(a.size(), 0u);
}

// Kern-Beweis: In-Process-Orchestrator ≡ Einzel-Writer (byte-identisch).
TEST(Stufe08Appendix, InProcessOrchestratorByteIdenticalToIndividualWriters) {
    auto const fixture = fixtures_dir() / "tier_wide_appendix.csv";
    ensure_fixture(fixture);

    std::vector<std::string> const langs = {"de", "en"};
    std::string const              label = "tab:bias:search-algo-workload";

    auto const      base     = comdare_user_tmp();
    auto const      dir_orch = base / "appendix_orch";
    auto const      dir_ref  = base / "appendix_ref";
    std::error_code ec;
    fs::remove_all(dir_orch, ec);
    fs::remove_all(dir_ref, ec);

    // Pfad A — die zu prüfende App (In-Process-Orchestrator).
    ag::AppendixConfig cfg;
    cfg.csv        = fixture;
    cfg.out_root   = dir_orch;
    cfg.langs      = langs;
    cfg.bias_label = label;
    ASSERT_EQ(ag::generate_wide_appendix(cfg), ag::status_ok);

    // Pfad B — die äquivalenten Einzel-Writer (= die früheren .exe-Spawns).
    ASSERT_EQ(run_individual_writers(fixture, dir_ref, langs, label), 0);

    // Beweis: jede erzeugte .tex byte-identisch.
    for (auto const& lang : langs) {
        auto const a = dir_orch / lang / "tabellen";
        auto const b = dir_ref / lang / "tabellen";
        for (auto const& name : expected_files()) {
            auto const fa = a / name;
            auto const fb = b / name;
            ASSERT_TRUE(fs::exists(fa)) << "orchestrator fehlt: " << fa;
            ASSERT_TRUE(fs::exists(fb)) << "referenz fehlt: " << fb;
            EXPECT_GT(fs::file_size(fa), 0u) << fa;
            EXPECT_EQ(read_all(fa), read_all(fb)) << "byte-diff in " << name << " (" << lang << ")";
        }
    }

    std::error_code cleanup;
    fs::remove_all(dir_orch, cleanup);
    fs::remove_all(dir_ref, cleanup);
}
