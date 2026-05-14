// SPDX-License-Identifier: Apache-2.0
// test_messung_driver.cpp — GoogleTest-Suite fuer den Diplomarbeits-
// Mess-Driver (Diplomarbeit/Code/messung_driver/).
//
// Strategie (REV 7.6):
//   - Die messung_driver-Logik delegiert vollstaendig an die cache-engine
//     Library `comdare::builder::ExperimentDriver`. Wir testen also die
//     drei Verantwortlichkeiten der Diplomarbeits-Schicht:
//        1. Konfiguration der drei Messreihen (Workload-Optionen pro Reihe)
//        2. Korrektes Sub-Verzeichnis pro Messreihe
//        3. Korrekter Pipeline-Aufruf an ExperimentDriver (Phase 1-7)
//   - Schwergewichtige Phasen (3 compile, 4 load) werden bewusst NICHT in
//     der Default-Suite ausgefuehrt — sie sind getrennt unter
//     INTEGRATION_TESTS_HEAVY gestellt. Default-CI laeuft schnell.
//
// Mock-Strategie:
//   - Synthetische XML-Configs (kleinst-moegliche 1×1×1=1 Permutation)
//   - --enumerate-only und --skip-build Modes als saubere Unit-Tests
//   - Phase 7 export via direkt konstruiertem ResultAggregator
//
// Wenn der Mess-Driver-Helper-Layer (MessreiheKind, default_workload_for)
// als Library exponiert wird, ergaenzen wir entsprechende Helper-Unit-Tests.

#include <gtest/gtest.h>

#include "experiment_driver/experiment_driver.hpp"

#include <comdare/experiment/result_aggregator.hpp>
#include <comdare/workload_generator/workload_generator.hpp>

#include <cstdint>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <string>
#include <vector>

namespace fs  = std::filesystem;
namespace cb  = comdare::builder;
namespace wg  = comdare::workload_generator;
namespace cex = comdare::experiment;

namespace {

// Hilfs-Klasse: tmp-Verzeichnis pro Test, raeumt im Destructor auf.
struct ScopedTempDir {
    fs::path path;
    explicit ScopedTempDir(std::string_view name_hint) {
        auto base = fs::temp_directory_path() / "comdare_test";
        fs::create_directories(base);
        path = base / (std::string{name_hint} + "_"
                       + std::to_string(::getpid()) + "_"
                       + std::to_string(reinterpret_cast<std::uintptr_t>(this)));
        fs::create_directories(path);
    }
    ~ScopedTempDir() {
        std::error_code ec;
        fs::remove_all(path, ec);
    }
    ScopedTempDir(ScopedTempDir const&)            = delete;
    ScopedTempDir& operator=(ScopedTempDir const&) = delete;
};

// Schreibt minimale gueltige XML-Configs in das angegebene Verzeichnis.
// Erzeugt genau 1 Permutation (1×1×1) damit Phase 1+2 deterministisch
// durchlaufen.
void write_minimal_xml_configs(fs::path const& config_dir) {
    fs::create_directories(config_dir);

    {
        std::ofstream f(config_dir / "cache_engine_permutations.xml");
        f << R"(<?xml version="1.0" encoding="UTF-8"?>
<cache_engine_permutations>
  <permutation id="ce_minimal">
    <concurrency>single_writer_multi_reader</concurrency>
    <prefetch>none</prefetch>
    <telemetry>off</telemetry>
  </permutation>
</cache_engine_permutations>
)";
    }
    {
        std::ofstream f(config_dir / "search_algorithm_permutations.xml");
        f << R"(<?xml version="1.0" encoding="UTF-8"?>
<search_algorithm_permutations>
  <permutation id="prt_art_v1"/>
</search_algorithm_permutations>
)";
    }
    {
        std::ofstream f(config_dir / "allocator_permutations.xml");
        f << R"(<?xml version="1.0" encoding="UTF-8"?>
<allocator_permutations>
  <permutation id="a20_dlmalloc"/>
</allocator_permutations>
)";
    }
    {
        std::ofstream f(config_dir / "test_data_sets.xml");
        f << R"(<?xml version="1.0" encoding="UTF-8"?>
<test_data_sets>
  <data_set id="ycsb_c_small">
    <num_keys>1000</num_keys>
    <num_operations>5000</num_operations>
  </data_set>
</test_data_sets>
)";
    }
}

cb::WorkloadOptions make_small_workload() {
    cb::WorkloadOptions w;
    w.config.random_seed    = 42;
    w.config.key_size_bytes = 16;
    w.config.value_size_bytes = 64;
    w.config.num_keys       = 1000;
    w.config.num_operations = 5000;
    w.config.zipfian_theta  = 0.99;
    w.workload              = wg::YcsbWorkload::C;
    return w;
}

}  // anonymous

// ─────────────────────────────────────────────────────────────────────────────
// Test-Group 1: ExperimentDriver Konstruktion + Lifetime
// ─────────────────────────────────────────────────────────────────────────────

TEST(MessungDriver_Construction, DefaultOptionsAreSane) {
    cb::ExperimentDriverOptions opts;
    EXPECT_TRUE(opts.verbose);
    EXPECT_FALSE(opts.enumerate_only);
    EXPECT_FALSE(opts.skip_build);
}

TEST(MessungDriver_Construction, ConstructWithOptions) {
    ScopedTempDir tmp("ctor");
    cb::ExperimentDriverOptions opts;
    opts.config_dir   = tmp.path / "configs";
    opts.output_dir   = tmp.path / "out";
    opts.comdare_root = fs::current_path();
    opts.verbose      = false;

    ASSERT_NO_THROW({
        cb::ExperimentDriver driver{opts};
        (void)driver;
    });
}

// ─────────────────────────────────────────────────────────────────────────────
// Test-Group 2: Phase 1 — Enumeration
// ─────────────────────────────────────────────────────────────────────────────

TEST(MessungDriver_Phase1, EnumerateValidConfigYieldsOnePermutation) {
    ScopedTempDir tmp("phase1");
    auto cfg = tmp.path / "configs";
    write_minimal_xml_configs(cfg);

    cb::ExperimentDriverOptions opts;
    opts.config_dir   = cfg;
    opts.output_dir   = tmp.path / "out";
    opts.comdare_root = fs::current_path();
    opts.verbose      = false;

    cb::ExperimentDriver driver{opts};
    std::vector<cb::loop::PermutationDescriptor> descs;
    int rc = driver.phase1_enumerate(descs);

    EXPECT_EQ(rc, cb::status_ok);
    EXPECT_FALSE(descs.empty());
    if (!descs.empty()) {
        EXPECT_NE(descs.front().fingerprint, 0u);
    }
}

TEST(MessungDriver_Phase1, MissingConfigDirYieldsError) {
    ScopedTempDir tmp("phase1_missing");
    cb::ExperimentDriverOptions opts;
    opts.config_dir   = tmp.path / "nonexistent";
    opts.output_dir   = tmp.path / "out";
    opts.comdare_root = fs::current_path();
    opts.verbose      = false;

    cb::ExperimentDriver driver{opts};
    std::vector<cb::loop::PermutationDescriptor> descs;
    int rc = driver.phase1_enumerate(descs);

    EXPECT_NE(rc, cb::status_ok);
    EXPECT_EQ(rc, cb::status_xml_parse_failed);
}

// ─────────────────────────────────────────────────────────────────────────────
// Test-Group 3: Phase 2 — Codegen
// ─────────────────────────────────────────────────────────────────────────────

TEST(MessungDriver_Phase2, GenerateProducesAggregatorCMake) {
    ScopedTempDir tmp("phase2");
    auto cfg = tmp.path / "configs";
    auto out = tmp.path / "out";
    write_minimal_xml_configs(cfg);

    cb::ExperimentDriverOptions opts;
    opts.config_dir   = cfg;
    opts.output_dir   = out;
    opts.comdare_root = fs::current_path();
    opts.verbose      = false;

    cb::ExperimentDriver driver{opts};
    std::vector<cb::loop::PermutationDescriptor> descs;
    ASSERT_EQ(driver.phase1_enumerate(descs), cb::status_ok);
    ASSERT_FALSE(descs.empty());

    int rc = driver.phase2_generate(descs);
    EXPECT_EQ(rc, cb::status_ok);

    auto aggregator = out / "generated" / "CMakeLists.txt";
    EXPECT_TRUE(fs::exists(aggregator))
        << "Erwartet: Aggregator-CMakeLists in " << aggregator.string();
}

// ─────────────────────────────────────────────────────────────────────────────
// Test-Group 4: --enumerate-only Mode (Phase 1 only, no codegen)
// ─────────────────────────────────────────────────────────────────────────────

TEST(MessungDriver_EnumerateOnly, FullPipelineWithEnumerateOnlyDoesNotCodegen) {
    ScopedTempDir tmp("enum_only");
    auto cfg = tmp.path / "configs";
    auto out = tmp.path / "out";
    write_minimal_xml_configs(cfg);

    cb::ExperimentDriverOptions opts;
    opts.config_dir     = cfg;
    opts.output_dir     = out;
    opts.comdare_root   = fs::current_path();
    opts.verbose        = false;
    opts.enumerate_only = true;

    cb::ExperimentDriver driver{opts};
    int rc = driver.run_pipeline_full(make_small_workload());
    EXPECT_EQ(rc, cb::status_ok);

    // Codegen-Output sollte NICHT existieren.
    EXPECT_FALSE(fs::exists(out / "generated" / "CMakeLists.txt"));
}

// ─────────────────────────────────────────────────────────────────────────────
// Test-Group 5: --skip-build Mode (Phase 1+2, kein cmake/compile/load)
// ─────────────────────────────────────────────────────────────────────────────

TEST(MessungDriver_SkipBuild, GeneratesCodeButDoesNotInvokeCMake) {
    ScopedTempDir tmp("skip_build");
    auto cfg = tmp.path / "configs";
    auto out = tmp.path / "out";
    write_minimal_xml_configs(cfg);

    cb::ExperimentDriverOptions opts;
    opts.config_dir   = cfg;
    opts.output_dir   = out;
    opts.comdare_root = fs::current_path();
    opts.verbose      = false;
    opts.skip_build   = true;

    cb::ExperimentDriver driver{opts};
    int rc = driver.run_pipeline_full(make_small_workload());
    EXPECT_EQ(rc, cb::status_ok);

    EXPECT_TRUE(fs::exists(out / "generated" / "CMakeLists.txt"))
        << "Codegen-Output muss existieren bei --skip-build.";
    EXPECT_FALSE(fs::exists(out / "build-perms"))
        << "build-perms darf NICHT existieren bei --skip-build.";
}

// ─────────────────────────────────────────────────────────────────────────────
// Test-Group 6: Phase 7 — Export via ResultAggregator
// ─────────────────────────────────────────────────────────────────────────────

TEST(MessungDriver_Phase7, ExportCsvAndJsonFiles) {
    ScopedTempDir tmp("phase7");
    auto out = tmp.path / "out";
    fs::create_directories(out);

    cb::ExperimentDriverOptions opts;
    opts.config_dir   = tmp.path / "configs";
    opts.output_dir   = out;
    opts.comdare_root = fs::current_path();
    opts.verbose      = false;

    cb::ExperimentDriver driver{opts};

    // Synthetische Aggregator-Daten ohne echte Modul-Loads.
    cex::ResultAggregator agg;
    cex::PermutationResult pr;
    pr.permutation_id = "synthetic_perm_0";
    pr.fingerprint    = 0xDEADBEEFu;
    pr.succeeded      = true;
    pr.record         = comdare_measurement_record_v1{};
    agg.add(std::move(pr));

    int rc = driver.phase7_export(agg);
    EXPECT_EQ(rc, cb::status_ok);
    EXPECT_TRUE(fs::exists(out / "measurements.csv"));
    EXPECT_TRUE(fs::exists(out / "measurements.json"));
}

// ─────────────────────────────────────────────────────────────────────────────
// Test-Group 7: Drei-Messreihen-Output-Layout (analog messung_driver/main.cpp)
// ─────────────────────────────────────────────────────────────────────────────

TEST(MessungDriver_DreiMessreihen, ProducesPerReiheSubdirectories) {
    ScopedTempDir tmp("drei_reihen");
    auto cfg = tmp.path / "configs";
    auto out = tmp.path / "out";
    write_minimal_xml_configs(cfg);

    constexpr std::array<std::string_view, 3> reihen{
        "A_PRT_ART_vs_SOTA", "B_CacheEngine_Perms", "C_Merge_Alt_Neu"};

    for (auto reihe : reihen) {
        auto reihe_out = out / std::string{reihe};
        cb::ExperimentDriverOptions opts;
        opts.config_dir     = cfg;
        opts.output_dir     = reihe_out;
        opts.comdare_root   = fs::current_path();
        opts.verbose        = false;
        opts.enumerate_only = true;  // wir testen nur das Layout

        cb::ExperimentDriver driver{opts};
        int rc = driver.run_pipeline_full(make_small_workload());
        EXPECT_EQ(rc, cb::status_ok) << "Messreihe " << reihe << " failed";
        EXPECT_TRUE(fs::exists(reihe_out));
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// Test-Group 8: Status-Code-Konstanten Sanity
// ─────────────────────────────────────────────────────────────────────────────

TEST(MessungDriver_StatusCodes, AllErrorCodesAreDistinct) {
    std::array<int, 7> codes{
        cb::status_ok,
        cb::status_xml_parse_failed,
        cb::status_codegen_failed,
        cb::status_cmake_configure_failed,
        cb::status_cmake_build_failed,
        cb::status_no_modules_loaded,
        cb::status_export_failed};

    for (std::size_t i = 0; i < codes.size(); ++i) {
        for (std::size_t j = i + 1; j < codes.size(); ++j) {
            EXPECT_NE(codes[i], codes[j])
                << "Status-Codes ueberlappen: idx " << i << " == idx " << j;
        }
    }
    EXPECT_EQ(cb::status_ok, 0)
        << "Konvention: status_ok muss 0 sein (errno-style).";
}

// ─────────────────────────────────────────────────────────────────────────────
// Test-Group 9: Workload-Options Diplomarbeits-Defaults
// (Sanity-Check der Werte aus messung_driver/main.cpp default_workload_for)
// ─────────────────────────────────────────────────────────────────────────────

TEST(MessungDriver_WorkloadDefaults, SmallWorkloadIsSane) {
    auto w = make_small_workload();
    EXPECT_EQ(w.config.random_seed, 42u);
    EXPECT_GT(w.config.num_keys, 0u);
    EXPECT_GT(w.config.num_operations, 0u);
    EXPECT_GT(w.config.value_size_bytes, 0u);
    EXPECT_GT(w.config.key_size_bytes, 0u);
    EXPECT_LE(w.config.zipfian_theta, 1.0);
    EXPECT_GE(w.config.zipfian_theta, 0.0);
}

// ─────────────────────────────────────────────────────────────────────────────
// Test-Group 10b (REV 7.6 V11.6): MessreihenMode in ExperimentDriverOptions
// ─────────────────────────────────────────────────────────────────────────────

TEST(MessungDriver_MessreihenMode, DefaultIsFullMode) {
    cb::ExperimentDriverOptions opts;
    EXPECT_EQ(opts.messreihen_mode, cb::ExperimentDriverOptions::MessreihenMode::Full);
    EXPECT_TRUE(opts.sota_profile_filter.empty());
}

TEST(MessungDriver_MessreihenMode, DefinedModeFilterIsSettable) {
    cb::ExperimentDriverOptions opts;
    opts.messreihen_mode = cb::ExperimentDriverOptions::MessreihenMode::Defined;
    opts.sota_profile_filter = {"art", "hot", "masstree"};
    EXPECT_EQ(opts.messreihen_mode, cb::ExperimentDriverOptions::MessreihenMode::Defined);
    EXPECT_EQ(opts.sota_profile_filter.size(), 3u);
    EXPECT_EQ(opts.sota_profile_filter[0], "art");
}

TEST(MessungDriver_MessreihenMode, RuntimeCodegenAndFunctionalTestsAreOptIn) {
    // V8.7 Options sind Default OFF
    cb::ExperimentDriverOptions opts;
    EXPECT_FALSE(opts.enable_runtime_codegen);
    EXPECT_FALSE(opts.enable_functional_tests);
}

// ─────────────────────────────────────────────────────────────────────────────
// Test-Group 10: Reproduzierbarkeit — gleicher Seed → gleiche Fingerprints
// ─────────────────────────────────────────────────────────────────────────────

TEST(MessungDriver_Reproducibility, SameConfigYieldsSameFingerprints) {
    ScopedTempDir tmp("reproduce");
    auto cfg = tmp.path / "configs";
    write_minimal_xml_configs(cfg);

    std::vector<std::uint64_t> fps_run1, fps_run2;
    for (int run = 0; run < 2; ++run) {
        cb::ExperimentDriverOptions opts;
        opts.config_dir   = cfg;
        opts.output_dir   = tmp.path / ("out_" + std::to_string(run));
        opts.comdare_root = fs::current_path();
        opts.verbose      = false;

        cb::ExperimentDriver driver{opts};
        std::vector<cb::loop::PermutationDescriptor> descs;
        ASSERT_EQ(driver.phase1_enumerate(descs), cb::status_ok);

        auto& tgt = (run == 0) ? fps_run1 : fps_run2;
        for (auto const& d : descs) tgt.push_back(d.fingerprint);
    }

    ASSERT_EQ(fps_run1.size(), fps_run2.size());
    for (std::size_t i = 0; i < fps_run1.size(); ++i) {
        EXPECT_EQ(fps_run1[i], fps_run2[i])
            << "Fingerprint divergiert in run 2 bei idx " << i;
    }
}
