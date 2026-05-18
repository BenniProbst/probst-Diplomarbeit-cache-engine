// V32.II.3 (2026-05-18 spaet) - V32Orchestrator E2E-Smoke-Test
//
// @subsystem MessungDriver (Subsystem 1)
//
// Skelett-Test fuer V32Orchestrator-Klasse aus messung_driver/v32_orchestrator.hpp.
// Pruefte: Konstruktion + submit + execute_messreihe-API.

#include "../../messung_driver/v32_orchestrator.hpp"

#include <gtest/gtest.h>

namespace v32 = comdare::diplomarbeit::messung_driver::v32;

TEST(V32Orchestrator, BasicConstruction) {
    v32::V32Orchestrator orchestrator;
    // V32.II.3 Smoke: Default-Konstruktion ohne Crash
    SUCCEED();
}

TEST(V32Orchestrator, SubmitToBuilder) {
    v32::V32Orchestrator orchestrator;
    // V32.II.3 Smoke: submit_to_builder() ohne Argumente (Skelett)
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
