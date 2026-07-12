// V35.D.2 (2026-05-22) - Stufen-Test mit gecachten Fixtures (04_csv_to_latex)

#include "csv_to_latex.hpp"

#include <gtest/gtest.h>

#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <string>
#include <unistd.h>

namespace c2l = comdare::da::csv_to_latex;
namespace fs  = std::filesystem;

namespace {

// Benutzer-eindeutige tmp-Basis: /tmp ist host-weit geteilt (prod1: lokale Läufe als comdare, CI als
// gitlab-runner) — feste Namen gehören dem Erst-Ersteller und blocken den jeweils anderen (8081/213626).
std::filesystem::path comdare_user_tmp() {
    auto p = std::filesystem::temp_directory_path() / ("comdare_test_" + std::to_string(::getuid()));
    std::filesystem::create_directories(p);
    return p;
}

void write_sample_csv(fs::path const& p) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    // V41.P1-KANONISCH: 16 Spalten, workload_used als 4. Spalte (parse_csv verlangt cols>=16 —
    // Fix 2026-07-06: der alte 15-Spalten-Writer erzeugte status_parse_error).
    f << "permutation_id,fingerprint,succeeded,workload_used,op_count,total_cycles,"
      << "cache_misses_l1,cache_misses_l2,cache_misses_l3,dtlb_misses,"
      << "coherence_invalidations,energy_micro_joules,"
      << "bytes_allocated,bytes_in_use_peak,external_frag,internal_frag\n";
    f << "ce_lockfree:art:tcmalloc:none,3405691582,1,ycsb_a,1000,25000,50,10,2,1,0,12345,4096,3072,0.05,0.02\n";
    f << "pa_olc:hot:mimalloc:zipf,3405691583,1,ycsb_b,2000,48000,100,20,5,2,0,23456,8192,6144,0.04,0.03\n";
    f << "ce_lockfree:masstree:jemalloc:none,3405691584,0,ycsb_a,500,12000,0,0,0,0,0,0,0,0,0.0,0.0\n";
}

void ensure_cached_csv(fs::path const& p) {
    // IMMER schreiben (selbstheilend gegen Schema-Drift alter gecachter Dateien);
    // die Datei bleibt danach als inspizierbares Fixture liegen (Habich-Doktrin).
    write_sample_csv(p);
}

fs::path fixtures_dir() {
    if (auto* env = std::getenv("COMDARE_FIXTURES_DIR_04"); env != nullptr) { return fs::path(env); }
#ifdef COMDARE_FIXTURES_DIR_04_FALLBACK
    // Deterministischer Fallback = per-Stufe Source-Dir (CMake-einkompiliert) — KEIN CWD-Stray (2026-06-01 gehärtet).
    return fs::path(COMDARE_FIXTURES_DIR_04_FALLBACK);
#else
    return fs::current_path() / "fixtures" / "cached"; // letzter Notnagel
#endif
}

} // namespace

TEST(Stufe04Pipeline, CachedCsvFixtureExistsOrIsGenerated) {
    auto dir = fixtures_dir();
    ensure_cached_csv(dir / "sample_3_rows.csv");
    EXPECT_TRUE(fs::exists(dir / "sample_3_rows.csv"));
    EXPECT_GT(fs::file_size(dir / "sample_3_rows.csv"), 100u);
}

TEST(Stufe04Pipeline, ParseCachedCsv) {
    auto dir = fixtures_dir();
    ensure_cached_csv(dir / "sample_3_rows.csv");
    std::vector<c2l::CsvRow> rows;
    ASSERT_EQ(c2l::parse_csv(dir / "sample_3_rows.csv", rows), c2l::status_ok);
    ASSERT_EQ(rows.size(), 3u);
    EXPECT_EQ(rows[0].permutation_id, "ce_lockfree:art:tcmalloc:none");
    EXPECT_EQ(rows[0].op_count, 1000u);
    EXPECT_TRUE(rows[0].succeeded);
    EXPECT_FALSE(rows[2].succeeded);
}

TEST(Stufe04Pipeline, WriteLatexFromCachedFixture) {
    auto dir = fixtures_dir();
    ensure_cached_csv(dir / "sample_3_rows.csv");
    std::vector<c2l::CsvRow> rows;
    ASSERT_EQ(c2l::parse_csv(dir / "sample_3_rows.csv", rows), c2l::status_ok);

    auto out = comdare_user_tmp() / "v35d2_table.tex";
    ASSERT_EQ(c2l::write_latex(out, rows, "Pipeline-Stage-04 Test", "tab:v35d2"), c2l::status_ok);

    std::string content;
    {
        std::ifstream in(out);
        content.assign((std::istreambuf_iterator<char>(in)), {});
    }
    EXPECT_NE(content.find("\\begin{tabular}"), std::string::npos);
    EXPECT_NE(content.find("\\caption{Pipeline-Stage-04 Test}"), std::string::npos);
    EXPECT_NE(content.find("\\label{tab:v35d2}"), std::string::npos);

    std::error_code ec;
    fs::remove(out, ec);
}

TEST(Stufe04Pipeline, BausteinDescriptionFromPermutationId) {
    auto desc = c2l::generate_baustein_description("ce_lockfree:art:tcmalloc:leaf_only_counter");
    EXPECT_FALSE(desc.empty());
    // Steckbrief sollte ART und tcmalloc nennen
    bool mentions_art      = desc.find("art") != std::string::npos || desc.find("ART") != std::string::npos;
    bool mentions_tcmalloc = desc.find("tcmalloc") != std::string::npos;
    EXPECT_TRUE(mentions_art || mentions_tcmalloc); // mindestens einer
}

TEST(Stufe04Pipeline, EscapeLatexHandlesSpecialChars) {
    EXPECT_EQ(c2l::escape_latex("plain text"), "plain text");
    auto escaped = c2l::escape_latex("100% done & ok");
    EXPECT_NE(escaped.find("\\%"), std::string::npos);
    EXPECT_NE(escaped.find("\\&"), std::string::npos);
}

// ── WIDE-Schema (tier×workload, 2026-06-11) ──────────────────────────────────────────────────────────
// Fixture = schema-treue Mini-Variante des Mess-CSVs (';'-getrennt; der Parser ist HEADER-getrieben →
// das Fixture braucht nur die benannten Spalten + beliebige weitere [hier: 2 stat-Dummies], in beliebiger
// Reihenfolge — exakt die Robustheits-Eigenschaft, die gegen das echte 136-Spalten-Schema trägt).
namespace {

void write_wide_sample_csv(fs::path const& p) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    f << "binary_id;setting;repetition;n_ops;total_ns;ns_per_op;stat_search_algo_lookup;"
      << "stat_allocator_bytes_alloc;workload;two_phase_valid\n";
    // k_ary × ycsb_c: 3 Samples (Mediane prüfbar: 100,200,300 → nearest-rank-Median 200)
    f << "search_algo=k_ary/node_type=node4;s=1/rep=0;0;1000;100000;100.0;1000;64000;ycsb_c;1\n";
    f << "search_algo=k_ary/node_type=node4;s=1/rep=1;1;1000;200000;200.0;1000;64000;ycsb_c;1\n";
    f << "search_algo=k_ary/node_type=node4;s=1/rep=2;2;1000;300000;300.0;1000;64000;ycsb_c;1\n";
    // k_ary × ih: 1 Sample
    f << "search_algo=k_ary/node_type=node4;s=1/rep=0;0;1000;500000;500.0;1000;64000;ih;1\n";
    // eytzinger × ycsb_c: 1 gültiges + 1 UNGÜLTIGES Sample (two_phase_valid=0 → MUSS ausgefiltert werden)
    f << "search_algo=eytzinger/node_type=node4;s=1/rep=0;0;1000;150000;150.0;1000;64000;ycsb_c;1\n";
    f << "search_algo=eytzinger/node_type=node4;s=1/rep=1;1;1000;90000;90.0;1000;64000;ycsb_c;0\n";
}

} // anonymous namespace

TEST(Stufe04Pipeline, ParseWideCsvHeaderDriven) {
    auto dir = fixtures_dir();
    write_wide_sample_csv(dir / "sample_wide_rows.csv");
    std::vector<c2l::WideMeasurementRow> rows;
    ASSERT_EQ(c2l::parse_wide_csv(dir / "sample_wide_rows.csv", rows), c2l::status_ok);
    ASSERT_EQ(rows.size(), 6u);
    EXPECT_EQ(rows[0].search_algo, "k_ary");
    EXPECT_EQ(rows[0].workload, "ycsb_c");
    EXPECT_DOUBLE_EQ(rows[0].ns_per_op, 100.0);
    EXPECT_TRUE(rows[0].two_phase_valid);
    EXPECT_EQ(rows[4].search_algo, "eytzinger");
    EXPECT_FALSE(rows[5].two_phase_valid);
}

TEST(Stufe04Pipeline, AggregateTierWorkloadMedianAndValidityFilter) {
    auto dir = fixtures_dir();
    write_wide_sample_csv(dir / "sample_wide_rows.csv");
    std::vector<c2l::WideMeasurementRow> rows;
    ASSERT_EQ(c2l::parse_wide_csv(dir / "sample_wide_rows.csv", rows), c2l::status_ok);
    auto const aggs = c2l::aggregate_tier_workload(rows);
    ASSERT_EQ(aggs.size(), 3u); // (eytzinger,ycsb_c) (k_ary,ih) (k_ary,ycsb_c) — map-sortiert
    EXPECT_EQ(aggs[0].search_algo, "eytzinger");
    EXPECT_EQ(aggs[0].samples, 1u); // das two_phase_valid=0-Sample ist GEFILTERT
    EXPECT_DOUBLE_EQ(aggs[0].median_ns_per_op, 150.0);
    EXPECT_EQ(aggs[2].search_algo, "k_ary");
    EXPECT_EQ(aggs[2].workload, "ycsb_c");
    EXPECT_EQ(aggs[2].samples, 3u);
    EXPECT_DOUBLE_EQ(aggs[2].median_ns_per_op, 200.0); // nearest-rank-Median von {100,200,300}
}

TEST(Stufe04Pipeline, WriteBiasMatrixLatex) {
    auto dir = fixtures_dir();
    write_wide_sample_csv(dir / "sample_wide_rows.csv");
    std::vector<c2l::WideMeasurementRow> rows;
    ASSERT_EQ(c2l::parse_wide_csv(dir / "sample_wide_rows.csv", rows), c2l::status_ok);
    auto const aggs = c2l::aggregate_tier_workload(rows);

    auto out = comdare_user_tmp() / "wide_bias_matrix.tex";
    ASSERT_EQ(c2l::write_bias_matrix_latex(out, aggs, "Bias-Bruch-Matrix Test", "tab:biasmatrix", "de"),
              c2l::status_ok);
    std::string content;
    {
        std::ifstream in(out);
        content.assign((std::istreambuf_iterator<char>(in)), {});
    }
    EXPECT_NE(content.find("\\begin{tabular}{lrr}"), std::string::npos); // 2 Workload-Spalten (ih, ycsb_c)
    EXPECT_NE(content.find("Suchverfahren"), std::string::npos);         // lang=de
    EXPECT_NE(content.find("k\\_ary"), std::string::npos);
    EXPECT_NE(content.find("& 200"), std::string::npos); // Median-Zelle k_ary×ycsb_c
    EXPECT_NE(content.find("& --"), std::string::npos);  // leere Zelle eytzinger×ih
    std::error_code ec;
    fs::remove(out, ec);
}

// ── P5 (2026-07-12): Forest-/Dot-Plot der Achsen-Austauschbarkeit (write_exchange_forest_plot) ──────────
// Fixture = schema-treue WIDE-FULL-Mini-CSV (parse_wide_csv_full: benoetigt op_<art>_p50_ns + binary_id-
// Achsen-Tupel). 4 Lebewesen erzeugen deterministisch: 1 valide Verbesserung (search_algo alpha->beta,
// Median rel. -0.2, IQR 0.1, n=4), 1 valide Regression (node_type n4->n8, +0.3, n=4) und 2 kleine-n-Zeilen
// (gamma nur in w1 → n=1). Threshold ist Test-Parameter (klein statt 30 → kleine-n greift bei diesem Fixture).
namespace {

void write_forest_full_csv(fs::path const& p) {
    fs::create_directories(p.parent_path());
    std::ofstream f(p);
    // 9 benoetigte Spalten (parse_wide_csv_full liest genau diese header-getrieben).
    f << "binary_id;workload;two_phase_valid;ns_per_op;op_insert_p50_ns;op_lookup_p50_ns;op_erase_p50_ns;"
      << "op_scan_p50_ns;op_rmw_p50_ns\n";
    auto row = [&](std::string const& bid, std::string const& wl, double ns) {
        f << bid << ";" << wl << ";1;" << ns << ";" << ns << ";" << ns << ";" << ns << ";" << ns << ";" << ns << "\n";
    };
    std::string const A  = "search_algo=alpha/node_type=n4/memory_layout=aos/prefetch=off";
    std::string const B  = "search_algo=beta/node_type=n4/memory_layout=aos/prefetch=off";
    std::string const G  = "search_algo=gamma/node_type=n4/memory_layout=aos/prefetch=off";
    std::string const A8 = "search_algo=alpha/node_type=n8/memory_layout=aos/prefetch=off";
    // alpha: ns_per_op=100 in allen 4 Lastprofilen.
    for (auto const* wl : {"w1", "w2", "w3", "w4"}) row(A, wl, 100.0);
    // beta: 70,80,90,100 → rel-Deltas ggü. alpha = -0.3,-0.2,-0.1,0.0 (nearest-rank auf 4 Werten: p25=idx1=-0.2,
    // p50=idx2=-0.1, p75=idx2=-0.1 → Median -0.1, IQR 0.1 → echter Whisker >0).
    row(B, "w1", 70.0);
    row(B, "w2", 80.0);
    row(B, "w3", 90.0);
    row(B, "w4", 100.0);
    // gamma: nur w1 (=100) → mit alpha/beta nur 1 gemeinsames Lastprofil → n=1 (kleine-n-Zeilen).
    row(G, "w1", 100.0);
    // alpha@node_type=n8: 130 in allen 4 → node_type-Geschwister-Paar n4->n8, rel +0.30, n=4 (Regression).
    for (auto const* wl : {"w1", "w2", "w3", "w4"}) row(A8, wl, 130.0);
}

std::string read_all(fs::path const& p) {
    std::ifstream in(p);
    return std::string((std::istreambuf_iterator<char>(in)), {});
}

std::size_t count_occ(std::string const& hay, std::string const& needle) {
    std::size_t n = 0, pos = 0;
    while ((pos = hay.find(needle, pos)) != std::string::npos) {
        ++n;
        pos += needle.size();
    }
    return n;
}

// Extrahiert den Rumpf eines "% P5-CLASS <tag>"-Blocks bis zum naechsten "% P5-CLASS" bzw. "\\end{axis}".
std::string class_block(std::string const& content, std::string const& tag) {
    auto const start = content.find("% P5-CLASS " + tag);
    if (start == std::string::npos) return {};
    auto const from = start + tag.size();
    auto       end  = content.find("% P5-CLASS ", from);
    auto const axe  = content.find("\\end{axis}", from);
    if (axe != std::string::npos && (end == std::string::npos || axe < end)) end = axe;
    return content.substr(start, (end == std::string::npos ? content.size() : end) - start);
}

std::vector<c2l::ExchangeAggregate> forest_aggs(fs::path const& dir, std::vector<c2l::SiblingPairCount>& counts) {
    write_forest_full_csv(dir / "sample_forest_full.csv");
    std::vector<c2l::WideFullRow> rows;
    EXPECT_EQ(c2l::parse_wide_csv_full(dir / "sample_forest_full.csv", rows), c2l::status_ok);
    return c2l::aggregate_exchange(rows, counts);
}

} // anonymous namespace

// (e) Reale Aggregat-Werte: aggregate_exchange liefert die erwarteten ns_per_op-Mediane (kein erfundener Wert).
TEST(Stufe04Pipeline, ForestAggregatesAreRealNsPerOpMedians) {
    auto                               dir = fixtures_dir();
    std::vector<c2l::SiblingPairCount> counts;
    auto const                         aggs = forest_aggs(dir, counts);
    auto find_agg = [&](std::string const& axis, std::string const& vf, std::string const& vt) {
        for (auto const& a : aggs)
            if (a.axis == axis && a.interface_fn == "ns_per_op" && a.value_from == vf && a.value_to == vt) return &a;
        return static_cast<c2l::ExchangeAggregate const*>(nullptr);
    };
    auto const* imp = find_agg("search_algo", "alpha", "beta");
    ASSERT_NE(imp, nullptr);
    EXPECT_EQ(imp->pair_workload_samples, 4u);
    EXPECT_NEAR(imp->median_rel_delta, -0.1, 1e-9);
    EXPECT_NEAR(imp->iqr_rel_delta, 0.1, 1e-9);
    auto const* reg = find_agg("node_type", "n4", "n8");
    ASSERT_NE(reg, nullptr);
    EXPECT_EQ(reg->pair_workload_samples, 4u);
    EXPECT_NEAR(reg->median_rel_delta, 0.3, 1e-9);
    auto const* sml = find_agg("search_algo", "beta", "gamma");
    ASSERT_NE(sml, nullptr);
    EXPECT_EQ(sml->pair_workload_samples, 1u); // kleine n
}

// (a) Forest-Struktur: 1 Zeile je Paar (4 Datenpunkte), 0-Linie present, Whisker nur/da Streuungsfeld existiert.
TEST(Stufe04Pipeline, ForestPlotStructureZeroLineAndWhisker) {
    auto                               dir = fixtures_dir();
    std::vector<c2l::SiblingPairCount> counts;
    auto const                         aggs = forest_aggs(dir, counts);

    auto out = comdare_user_tmp() / "p5_forest.tex";
    ASSERT_EQ(c2l::write_exchange_forest_plot(out, aggs, counts, "de", /*body_only=*/false, /*threshold=*/3),
              c2l::status_ok);
    auto const c = read_all(out);

    EXPECT_NE(c.find("\\begin{tikzpicture}"), std::string::npos);
    EXPECT_NE(c.find("\\begin{axis}"), std::string::npos);
    EXPECT_NE(c.find("\\end{axis}"), std::string::npos);
    EXPECT_NE(c.find("\\resizebox{\\textwidth}{!}"), std::string::npos); // breiten-sicher
    // 0-Referenzlinie present (numerisch bei x=0).
    EXPECT_NE(c.find("% P5-0-REFERENZLINIE"), std::string::npos);
    EXPECT_NE(c.find("(axis cs:0,"), std::string::npos);
    // pgfplots-Fehlerbalken-Idiom (horizontal, beide Richtungen).
    EXPECT_NE(c.find("error bars"), std::string::npos);
    EXPECT_NE(c.find("x dir=both"), std::string::npos);
    // 4 reale Datenpunkte (== Zahl der ns_per_op-Aggregate mit n>0), nichts erfunden/verloren.
    EXPECT_EQ(count_occ(c, "+- ("), 4u);
    EXPECT_NE(c.find("ytick={0,1,2,3}"), std::string::npos);
    // Whisker existiert real (IQR=0.1 → Halb-Whisker 0.05) — kein erfundener Balken, aber vorhandene Streuung.
    EXPECT_NE(c.find("+- (0.0500,0)"), std::string::npos);

    std::error_code ec;
    fs::remove(out, ec);
}

// (b) Kleine-n-Kennzeichnung greift (threshold-getrieben, nicht hartkodiert): threshold=3 → 2 kleine-n-Punkte
//     mit fpsmalln/offenem Marker; threshold=0 → KEINE kleine-n-Klasse (alle valide).
TEST(Stufe04Pipeline, ForestPlotSmallNMarkingIsThresholdDriven) {
    auto                               dir = fixtures_dir();
    std::vector<c2l::SiblingPairCount> counts;
    auto const                         aggs = forest_aggs(dir, counts);

    auto out3 = comdare_user_tmp() / "p5_forest_t3.tex";
    ASSERT_EQ(c2l::write_exchange_forest_plot(out3, aggs, counts, "de", false, 3), c2l::status_ok);
    auto const c3 = read_all(out3);
    EXPECT_NE(c3.find("% P5-CLASS smalln"), std::string::npos);
    EXPECT_NE(c3.find("\\definecolor{fpsmalln}"), std::string::npos);
    // kleine-n-Marker = offener Kreis (mark=o) + fpsmalln-Farbe im smalln-Block.
    auto const sblk = class_block(c3, "smalln");
    EXPECT_NE(sblk.find("mark=o"), std::string::npos);
    EXPECT_NE(sblk.find("color=fpsmalln"), std::string::npos);
    EXPECT_EQ(count_occ(sblk, "+- ("), 2u); // (alpha,gamma) + (beta,gamma)

    auto out0 = comdare_user_tmp() / "p5_forest_t0.tex";
    ASSERT_EQ(c2l::write_exchange_forest_plot(out0, aggs, counts, "de", false, 0), c2l::status_ok);
    auto const c0 = read_all(out0);
    EXPECT_EQ(c0.find("% P5-CLASS smalln"), std::string::npos); // threshold=0 → keine kleine-n-Zeile
    // Dann sind alle 3 nicht-negativen Zeilen Regression (0.0, 0.25, 0.30).
    EXPECT_EQ(count_occ(class_block(c0, "regression"), "+- ("), 3u);

    std::error_code ec;
    fs::remove(out3, ec);
    fs::remove(out0, ec);
}

// (c) Vorzeichen-Faerbung korrekt: Verbesserung (median<0) → fpimprove-Block mit -0.2000 (nicht 0.3000);
//     Regression (median>=0) → fpregress-Block mit 0.3000 (nicht -0.2000).
TEST(Stufe04Pipeline, ForestPlotSignColoring) {
    auto                               dir = fixtures_dir();
    std::vector<c2l::SiblingPairCount> counts;
    auto const                         aggs = forest_aggs(dir, counts);

    auto out = comdare_user_tmp() / "p5_forest_sign.tex";
    ASSERT_EQ(c2l::write_exchange_forest_plot(out, aggs, counts, "en", false, 3), c2l::status_ok);
    auto const c = read_all(out);

    auto const imp = class_block(c, "improvement");
    ASSERT_FALSE(imp.empty());
    EXPECT_NE(imp.find("color=fpimprove"), std::string::npos);
    EXPECT_NE(imp.find("(-0.1000,"), std::string::npos);
    EXPECT_EQ(imp.find("0.3000"), std::string::npos); // Regressionswert NICHT im Verbesserungs-Block

    auto const reg = class_block(c, "regression");
    ASSERT_FALSE(reg.empty());
    EXPECT_NE(reg.find("color=fpregress"), std::string::npos);
    EXPECT_NE(reg.find("(0.3000,"), std::string::npos);
    EXPECT_EQ(reg.find("-0.1000"), std::string::npos); // Verbesserungswert NICHT im Regressions-Block

    std::error_code ec;
    fs::remove(out, ec);
}

// (d) Honest-empty-Guard: keine gueltige ns_per_op-Zeile → status_empty_input + KEINE Datei.
TEST(Stufe04Pipeline, ForestPlotHonestEmptyGuard) {
    auto            out = comdare_user_tmp() / "p5_forest_empty.tex";
    std::error_code ec;
    fs::remove(out, ec);

    // (i) leere Aggregat-Liste.
    std::vector<c2l::ExchangeAggregate> none;
    std::vector<c2l::SiblingPairCount>  counts;
    EXPECT_EQ(c2l::write_exchange_forest_plot(out, none, counts, "de", false, 3), c2l::status_empty_input);
    EXPECT_FALSE(fs::exists(out));

    // (ii) Aggregate ohne ns_per_op-Zeile (nur andere Interface-Fn) → ebenfalls honest-leer.
    std::vector<c2l::ExchangeAggregate> only_lookup;
    c2l::ExchangeAggregate              a;
    a.axis                  = "search_algo";
    a.value_from            = "alpha";
    a.value_to              = "beta";
    a.interface_fn          = "lookup";
    a.pair_workload_samples = 4;
    a.median_rel_delta      = -0.2;
    only_lookup.push_back(a);
    EXPECT_EQ(c2l::write_exchange_forest_plot(out, only_lookup, counts, "de", false, 3), c2l::status_empty_input);
    EXPECT_FALSE(fs::exists(out));
}
