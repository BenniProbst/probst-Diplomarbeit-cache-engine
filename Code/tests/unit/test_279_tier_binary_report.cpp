// SPDX-License-Identifier: Apache-2.0
// test_279_tier_binary_report.cpp (#279-a, 2026-07-07; 2c/OP-8-Migration 2026-07-27)
//
// Deterministische Unit-Tests der reinen Sichtbarkeits-/Roster-Logik
// (tier_binary_report.hpp) — KEIN dlopen, nur std + Fixtures. Der
// dlopen-Pfad (--interface-check) wird von der CLI abgedeckt; hier wird das
// Datenmodell + die Formatierung deterministisch verifiziert.
//
// 2c: die geplante Menge kommt aus der plan-dump-Ausgabe v1.1. Beide .txt-Fixtures
// sind BYTE-REALE Treiber-Ausgaben (nicht nachgebaut), erzeugt am 27.07. mit
//   comdare-messung-driver plan dump                       -> plan_dump_thesis.txt
//   comdare-messung-driver plan dump <experiment_golden_kern.xml>
//                                                          -> plan_dump_experiment.txt
// Sie decken die BEIDEN Kanaele ab: THESIS emittiert durchgaengig binary_id=- (keine
// geplanten Tier-Binaries), EXPERIMENT traegt echte ids in JEDEM der 4 perm-Bloecke.

#include "tier_binary_report.hpp"

#include <algorithm>
#include <filesystem>
#include <string>
#include <vector>

#include <gtest/gtest.h>

namespace {

namespace tbr = comdare::tier_binary_report;
namespace fs  = std::filesystem;

// plan-dump-Fixtures (committet) via CMake-compile-define (Source-Dir, kein CWD-Stray).
[[nodiscard]] fs::path fixture_dir() {
#ifdef COMDARE_FIXTURE_DIR_279
    return fs::path{COMDARE_FIXTURE_DIR_279};
#else
    return fs::current_path();
#endif
}

// "Gebaute" Tier-Binary-Dateien (.so) — Build-Artefakte, von CMake synthetisch im
// Build-Baum erzeugt (nicht committet, da .gitignore *.so ausschliesst). Ihre Stems
// sind die REAL sanitisierten binary_ids der Experiment-Fixture (ce orch_sanitize).
[[nodiscard]] fs::path perm_dir() {
#ifdef COMDARE_FIXTURE_PERM_DIR_279
    return fs::path{COMDARE_FIXTURE_PERM_DIR_279};
#else
    return fixture_dir() / "perm_dir";
#endif
}

// Die 7 geplanten Stems der Experiment-Fixture in Plan-Reihenfolge (sanitisiert:
// 'sota_tier=sota::A::ArtComposition' -> 'sota_tier_sota__A__ArtComposition').
constexpr char const* kPlannedStems[] = {
    "sota_tier_sota__A__PrtArtComposition",
    "sota_tier_sota__A__ArtComposition",
    "sota_tier_sota__A__HotComposition",
    "sota_tier_sota__A__ArtPrtStufe2ReplaceComposition",
    "sota_tier_sota__A__HotPrtStufe2ReplaceComposition",
    "sota_tier_sota__B__ArtPrtStufe3FullJoinComposition",
    "sota_tier_sota__B__HotPrtStufe3FullJoinComposition",
};

TEST(TierBinaryReport, ParsePlanDumpExperimentReadsHeadAndDedupesBinaryIds) {
    // 4 perm-Bloecke x 7 Schritte = 28 step-Zeilen, aber nur 7 VERSCHIEDENE binary_ids:
    // der Plan wiederholt jede id je perm. Die geplante Menge ist der deduplizierte
    // Stem-Raum -- sonst waere sie mit der (ebenfalls deduplizierenden) gebauten Menge
    // nicht vergleichbar.
    tbr::PlannedSet const p = tbr::parse_plan_dump(fixture_dir() / "plan_dump_experiment.txt");
    EXPECT_TRUE(p.format_ok);
    EXPECT_EQ(p.profile, "diplomarbeit_golden_kern_fixture");
    EXPECT_EQ(p.source_kind, "experiment");
    EXPECT_EQ(p.perm_blocks, 4U);
    EXPECT_EQ(p.steps, 28U);
    EXPECT_EQ(p.steps_without_binary, 0U);
    EXPECT_EQ(p.ids_beyond_stem_cap, 0U);
    ASSERT_EQ(p.ids.size(), 7U);
    for (std::size_t i = 0; i < p.ids.size(); ++i) EXPECT_EQ(p.ids[i], kPlannedStems[i]);
}

TEST(TierBinaryReport, ParsePlanDumpThesisHasNoBinaryIdsButCountsSteps) {
    // THESIS-Profile emittieren binary_id=- durchgaengig (nur EXPERIMENT-Profile tragen
    // echte ids). "0 geplant" ist hier der KORREKTE Befund -- er muss aber an den
    // step-Zaehlern erkennbar bleiben und darf nicht wie ein Datenverlust aussehen.
    tbr::PlannedSet const p = tbr::parse_plan_dump(fixture_dir() / "plan_dump_thesis.txt");
    EXPECT_TRUE(p.format_ok);
    EXPECT_EQ(p.profile, "m3v2_study");
    EXPECT_EQ(p.source_kind, "thesis");
    EXPECT_EQ(p.perm_blocks, 1U);
    EXPECT_EQ(p.steps, 9U);
    EXPECT_EQ(p.steps_without_binary, 9U);
    EXPECT_TRUE(p.ids.empty());
}

TEST(TierBinaryReport, ParsePlanDumpMissingFileIsFormatBreak) {
    tbr::PlannedSet const p = tbr::parse_plan_dump(fixture_dir() / "does_not_exist.txt");
    EXPECT_FALSE(p.format_ok);
    EXPECT_TRUE(p.ids.empty());
    EXPECT_TRUE(p.profile.empty());
    EXPECT_EQ(p.steps, 0U);
}

TEST(TierBinaryReport, ParsePlanDumpForeignFileIsFormatBreak) {
    // Vorhandene, aber fremde Datei: ohne Kopf-Anker darf sie NICHT als leerer,
    // gueltiger Plan durchgehen (sonst falsches "0/0 gebaut").
    tbr::PlannedSet const p = tbr::parse_plan_dump(perm_dir() / "not_a_plan_dump.txt");
    EXPECT_FALSE(p.format_ok);
    EXPECT_TRUE(p.ids.empty());
}

TEST(TierBinaryReport, ScanBuiltFindsOnlyPermPrefixedLibs) {
    tbr::BuiltSet const b = tbr::scan_built(perm_dir());
    ASSERT_EQ(b.ids.size(), 2U);
    // notperm.so muss ignoriert sein (Reihenfolge egal -> sortiert pruefen).
    std::vector<std::string> ids = b.ids;
    std::sort(ids.begin(), ids.end());
    EXPECT_EQ(ids[0], "sota_tier_sota__A__ArtComposition");
    EXPECT_EQ(ids[1], "sota_tier_sota__A__PrtArtComposition");
}

TEST(TierBinaryReport, ComputeVisibilityBridgesBinaryIdIntoBuiltStemSpace) {
    // End-to-end: geplante binary_ids (plan dump) gegen die gebauten Datei-Stems
    // (perm_<sanitisiert>.so). Beweist die Id-Raum-Bruecke: die Sanitisierung der
    // geplanten Seite trifft exakt den Stem der gebauten Seite.
    tbr::PlannedSet const       p = tbr::parse_plan_dump(fixture_dir() / "plan_dump_experiment.txt");
    tbr::BuiltSet const         b = tbr::scan_built(perm_dir());
    tbr::VisibilityReport const r = tbr::compute_visibility(p, b, /*builder_built=*/false);
    EXPECT_TRUE(r.format_ok);
    EXPECT_EQ(r.planned, 7U);
    EXPECT_EQ(r.built, 2U);
    EXPECT_EQ(r.open, 5U);
    ASSERT_EQ(r.open_ids.size(), 5U);
    EXPECT_EQ(r.open_ids[0], "sota_tier_sota__A__HotComposition"); // Plan-Reihenfolge bleibt
    EXPECT_EQ(r.perm_blocks, 4U);
    EXPECT_EQ(r.steps, 28U);
}

TEST(TierBinaryReport, ComputeVisibilityThesisPlanIsEmptyButNotBroken) {
    tbr::PlannedSet const       p = tbr::parse_plan_dump(fixture_dir() / "plan_dump_thesis.txt");
    tbr::BuiltSet const         b = tbr::scan_built(perm_dir());
    tbr::VisibilityReport const r = tbr::compute_visibility(p, b, /*builder_built=*/true);
    EXPECT_TRUE(r.format_ok);
    EXPECT_EQ(r.planned, 0U);
    EXPECT_EQ(r.built, 0U); // gebaute Binaries ausserhalb des Plans zaehlen NICHT als geplant
    EXPECT_EQ(r.open, 0U);
    EXPECT_EQ(r.steps_without_binary, 9U);
    EXPECT_TRUE(r.builder_built);
    EXPECT_EQ(r.profile, "m3v2_study");
}

TEST(TierBinaryReport, FormatVisibilityMentionsPlanSourceBuilderAndCounts) {
    tbr::VisibilityReport r;
    r.format_ok            = true;
    r.builder_built        = false;
    r.profile              = "diplomarbeit_golden_kern_fixture";
    r.source_kind          = "experiment";
    r.perm_blocks          = 4;
    r.steps                = 28;
    r.steps_without_binary = 0;
    r.planned              = 7;
    r.built                = 2;
    r.open                 = 5;
    r.open_ids             = {"sota_tier_sota__A__HotComposition"};

    std::string const s = tbr::format_visibility(r);
    EXPECT_NE(s.find("Plan-Quelle: plan dump v1.1"), std::string::npos);
    EXPECT_NE(s.find("source_kind experiment"), std::string::npos);
    EXPECT_NE(s.find("4 perm-Block(e), 28 step-Zeile(n), davon 0 ohne binary_id"), std::string::npos);
    EXPECT_NE(s.find("CacheEngineBuilder: fehlt"), std::string::npos);
    EXPECT_NE(s.find("2/7 gebaut, 5 offen (Profil diplomarbeit_golden_kern_fixture)"), std::string::npos);
    EXPECT_NE(s.find("sota_tier_sota__A__HotComposition"), std::string::npos);
}

TEST(TierBinaryReport, FormatVisibilityFlagsFormatBreakInsteadOfEmptyPlan) {
    tbr::VisibilityReport const r; // format_ok=false (Default)
    std::string const           s = tbr::format_visibility(r);
    EXPECT_NE(s.find("PLAN-QUELLE UNGUELTIG"), std::string::npos);
    EXPECT_EQ(s.find("Tier-Binaries:"), std::string::npos); // keine Zahlen aus ungueltiger Quelle
}

TEST(TierBinaryReport, FormatVisibilityNamesStemCapGap) {
    tbr::VisibilityReport r;
    r.format_ok           = true;
    r.planned             = 2;
    r.ids_beyond_stem_cap = 2;
    std::string const s   = tbr::format_visibility(r);
    EXPECT_NE(s.find("ueberschreiten den ce-Stem-Deckel"), std::string::npos);
}

TEST(TierBinaryReport, FormatInterfaceRosterEmpty) {
    std::vector<tbr::InterfaceCheck> const roster;
    std::string const                      s = tbr::format_interface_roster(roster);
    EXPECT_NE(s.find("0/0 PASS"), std::string::npos);
    EXPECT_NE(s.find("nichts zu pruefen"), std::string::npos);
}

TEST(TierBinaryReport, FormatInterfaceRosterMixedPassFail) {
    std::vector<tbr::InterfaceCheck> roster;
    roster.push_back(tbr::InterfaceCheck{"good", true, true, true});
    roster.push_back(tbr::InterfaceCheck{"bad", true, true, false});

    ASSERT_TRUE(roster[0].passed());
    ASSERT_FALSE(roster[1].passed());

    std::string const s = tbr::format_interface_roster(roster);
    EXPECT_NE(s.find("[PASS] good"), std::string::npos);
    EXPECT_NE(s.find("[FAIL] bad"), std::string::npos);
    EXPECT_NE(s.find("1/2 PASS"), std::string::npos);
}

} // namespace
