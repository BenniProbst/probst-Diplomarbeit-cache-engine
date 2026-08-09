// V32.II.3 (2026-05-18) + V33.C.2 (2026-05-21) - V32Orchestrator Tests
//
// @subsystem MessungDriver (Subsystem 1)
//
// Skelett-Tests fuer Konstruktion + Submit + execute_messreihe (V32),
// plus V33.C.2 Default-Lookup-Messreihe + Einzel-Permutation.

#include "../../02_messung_driver/v32_orchestrator.hpp"

#include <gtest/gtest.h>

#include <type_traits>

namespace v32 = comdare::diplomarbeit::messung_driver::v32;
namespace cmd = comdare::cache_engine::builder::commands;

// -Wdeprecated-declarations (8 Stellen in DIESER Datei, clang-Review 09.08.2026) ist hier
// UNTERDRUECKT, und das ist die begruendete Ausnahme, nicht der Regelfall:
// V32Orchestrator ist mit [[deprecated]] markiert ("W4: Surrogat -- nie im Mess-Pfad"), hat aber
// noch echte Konsumenten im Produktivcode (messreihe_report_exporter.hpp, experiment_phase_strategy.hpp,
// op_type_filter.hpp, v32_messreihe_antrieb.hpp, v32_katalog_driver.hpp). Solange die Klasse lebt,
// MUSS sie bewacht bleiben. Die Deprecation-Warnung richtet sich an NEUE Aufrufer; dieser Test IST
// die Wache des Bestands und kann seinen Gegenstand nicht benutzen, ohne ihn zu benennen.
// Der Geltungsbereich ist bewusst diese eine Datei -- keine Klasse global abgeschaltet. Faellt der
// letzte Produktiv-Aufrufer weg, gehoert Klasse UND Test geloescht, nicht diese Unterdrueckung erweitert.
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

// BasicConstruction hielt bis 09.08.2026 eine Variable, die NIE benutzt wurde (-Wunused-variable):
//     v32::V32Orchestrator orchestrator;  SUCCEED();
// clang meldet das nur, wenn Konstruktor UND Destruktor trivial sind -- die Konstruktion hatte also
// zur Laufzeit keinerlei beobachtbare Wirkung, und SUCCEED() sicherte nichts zu. Die einzige echte
// Aussage des Tests war "der Typ ist default-konstruierbar", und das ist eine UEBERSETZUNGSZEIT-
// Aussage: als static_assert ist sie strenger als das weggefallene Laufzeit-Objekt (sie bricht den
// Bau statt einen Test rot zu faerben) und laesst nichts Ungeprueftes zurueck.
// Der TEST-Name bleibt bestehen (die Registrierungs-Wache zaehlt Testfaelle; ein still
// verschwundener Fall waere selbst eine Regression).
TEST(V32Orchestrator, BasicConstruction) {
    static_assert(std::is_default_constructible_v<v32::V32Orchestrator>,
                  "V32Orchestrator muss default-konstruierbar bleiben (Bestands-Zusicherung V32.II.3)");
    static_assert(std::is_nothrow_destructible_v<v32::V32Orchestrator>,
                  "V32Orchestrator muss nothrow-zerstoerbar bleiben (Bestands-Zusicherung V32.II.3)");
    SUCCEED() << "Konstruierbarkeit ist zur Uebersetzungszeit zugesichert (static_assert oben)";
}

TEST(V32Orchestrator, SubmitToBuilder) {
    v32::V32Orchestrator orchestrator;
    orchestrator.submit_to_builder();
    SUCCEED();
}

TEST(V32Orchestrator, ExecuteMessreiheDefined) {
    v32::V32Orchestrator orchestrator;
    int rc = orchestrator.execute_messreihe("test_data_xml/messreihe_v32_schema_example.xml", "defined");
    EXPECT_EQ(rc, 0);
}

TEST(V32Orchestrator, ExecuteMessreiheFull) {
    v32::V32Orchestrator orchestrator;
    int                  rc = orchestrator.execute_messreihe("test_data_xml/messreihe_v32_schema_example.xml", "full");
    EXPECT_EQ(rc, 0);
}

TEST(V32Orchestrator, ExecuteMessreiheFullSampled) {
    v32::V32Orchestrator orchestrator;
    int rc = orchestrator.execute_messreihe("test_data_xml/messreihe_v32_schema_example.xml", "full_sampled");
    EXPECT_EQ(rc, 0);
}

TEST(V32Orchestrator, ExecuteOnePermutationParallelEEs) {
    v32::V32Orchestrator orchestrator;
    cmd::Workload        w{};
    w.kind            = cmd::WorkloadKind::YCSB_C_ReadOnly;
    w.record_count    = 100;
    w.operation_count = 20;
    w.name            = "v33-c2-smoke";

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
    cmd::Workload        w{};
    w.kind            = cmd::WorkloadKind::YCSB_C_ReadOnly;
    w.record_count    = 50;
    w.operation_count = 10; // klein, sonst dauert der Test zu lange
    w.name            = "v33-c2-default-lookup";

    auto report = orchestrator.run_default_lookup_messreihe(w);
    // 9 default-lookup-Achsen aus DefaultLookupRegistry
    EXPECT_EQ(report.total_axes, 9u);
    // Jede Achse hat min. 3 Variants
    EXPECT_GE(report.total_variants, 9u * 3u);
    // Wins + Ties summieren auf total_variants (oder weniger bei InconclusiveData)
    EXPECT_LE(report.ee_a_wins + report.ee_b_wins + report.ties, report.total_variants);
    EXPECT_GT(report.total_elapsed.count(), 0);
}

#pragma GCC diagnostic pop // Ende der begruendeten -Wdeprecated-declarations-Ausnahme (s. Kopf)
