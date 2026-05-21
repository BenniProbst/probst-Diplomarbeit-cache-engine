// V32.II.3 (2026-05-18) + V33.C.2 (2026-05-21) - V32Orchestrator Tests
//
// @subsystem MessungDriver (Subsystem 1)
//
// Skelett-Tests fuer Konstruktion + Submit + execute_messreihe (V32),
// plus V33.C.2 Default-Lookup-Messreihe + Einzel-Permutation.

#include "../../messung_driver/v32_orchestrator.hpp"

#include <gtest/gtest.h>

namespace v32 = comdare::diplomarbeit::messung_driver::v32;
namespace cmd = comdare::cache_engine::builder::commands;

TEST(V32Orchestrator, BasicConstruction) {
    v32::V32Orchestrator orchestrator;
    SUCCEED();
}

TEST(V32Orchestrator, SubmitToBuilder) {
    v32::V32Orchestrator orchestrator;
    orchestrator.submit_to_builder();
    SUCCEED();
}

TEST(V32Orchestrator, ExecuteMessreiheDefined) {
    v32::V32Orchestrator orchestrator;
    int rc = orchestrator.execute_messreihe(
        "test_data_xml/messreihe_v32_schema_example.xml", "defined");
    EXPECT_EQ(rc, 0);
}

TEST(V32Orchestrator, ExecuteMessreiheFull) {
    v32::V32Orchestrator orchestrator;
    int rc = orchestrator.execute_messreihe(
        "test_data_xml/messreihe_v32_schema_example.xml", "full");
    EXPECT_EQ(rc, 0);
}

TEST(V32Orchestrator, ExecuteMessreiheFullSampled) {
    v32::V32Orchestrator orchestrator;
    int rc = orchestrator.execute_messreihe(
        "test_data_xml/messreihe_v32_schema_example.xml", "full_sampled");
    EXPECT_EQ(rc, 0);
}

TEST(V32Orchestrator, ExecuteOnePermutationParallelEEs) {
    v32::V32Orchestrator orchestrator;
    cmd::Workload w {};
    w.kind = cmd::WorkloadKind::YCSB_C_ReadOnly;
    w.record_count = 100;
    w.operation_count = 20;
    w.name = "v33-c2-smoke";

    auto outcome = orchestrator.execute_one_permutation("11", "LeafOnlyCounter", w);
    EXPECT_EQ(outcome.axis_id, "11");
    EXPECT_EQ(outcome.variant_name, "LeafOnlyCounter");
    EXPECT_TRUE(outcome.ee_a_result.success);
    EXPECT_TRUE(outcome.ee_b_result.success);
    EXPECT_EQ(outcome.ee_a_result.engine_name, "CacheEngine-EE-A");
    EXPECT_EQ(outcome.ee_b_result.engine_name, "PrtArt-EE-B");
    // Verdict ist InconclusiveData NICHT mehr nach execute (verdict gesetzt)
    EXPECT_NE(outcome.verdict, cmd::CompareEngineCommand::Verdict::InconclusiveData);
}

TEST(V32Orchestrator, RunDefaultLookupMessreihe) {
    v32::V32Orchestrator orchestrator;
    cmd::Workload w {};
    w.kind = cmd::WorkloadKind::YCSB_C_ReadOnly;
    w.record_count = 50;
    w.operation_count = 10;  // klein, sonst dauert der Test zu lange
    w.name = "v33-c2-default-lookup";

    auto report = orchestrator.run_default_lookup_messreihe(w);
    // 9 default-lookup-Achsen aus DefaultLookupRegistry
    EXPECT_EQ(report.total_axes, 9u);
    // Jede Achse hat min. 3 Variants
    EXPECT_GE(report.total_variants, 9u * 3u);
    // Wins + Ties summieren auf total_variants (oder weniger bei InconclusiveData)
    EXPECT_LE(report.ee_a_wins + report.ee_b_wins + report.ties, report.total_variants);
    EXPECT_GT(report.total_elapsed.count(), 0);
}
