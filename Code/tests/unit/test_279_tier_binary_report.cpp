// SPDX-License-Identifier: Apache-2.0
// test_279_tier_binary_report.cpp (#279-a, 2026-07-07)
//
// Deterministische Unit-Tests der reinen Sichtbarkeits-/Roster-Logik
// (tier_binary_report.hpp) — KEIN dlopen, nur std + Fixtures. Der
// dlopen-Pfad (--interface-check) wird von der CLI abgedeckt; hier wird das
// Datenmodell + die Formatierung deterministisch verifiziert.

#include "tier_binary_report.hpp"

#include <algorithm>
#include <filesystem>
#include <string>
#include <vector>

#include <gtest/gtest.h>

namespace {

namespace tbr = comdare::tier_binary_report;
namespace fs  = std::filesystem;

// Manifest-Fixtures (committet) via CMake-compile-define (Source-Dir, kein CWD-Stray).
[[nodiscard]] fs::path fixture_dir() {
#ifdef COMDARE_FIXTURE_DIR_279
    return fs::path{COMDARE_FIXTURE_DIR_279};
#else
    return fs::current_path();
#endif
}

// "Gebaute" Tier-Binary-Dateien (.so) — Build-Artefakte, von CMake synthetisch im
// Build-Baum erzeugt (nicht committet, da .gitignore *.so ausschliesst).
[[nodiscard]] fs::path perm_dir() {
#ifdef COMDARE_FIXTURE_PERM_DIR_279
    return fs::path{COMDARE_FIXTURE_PERM_DIR_279};
#else
    return fixture_dir() / "perm_dir";
#endif
}

TEST(TierBinaryReport, ParseManifestSkipsCommentsAndReadsProfileAndIds) {
    tbr::PlannedSet const p = tbr::parse_manifest(fixture_dir() / "manifest_smoke.txt");
    EXPECT_EQ(p.profile, "smoke");
    ASSERT_EQ(p.ids.size(), 3U);
    EXPECT_EQ(p.ids[0], "aaa");
    EXPECT_EQ(p.ids[1], "bbb");
    EXPECT_EQ(p.ids[2], "ccc");
}

TEST(TierBinaryReport, ParseManifestMissingFileYieldsEmpty) {
    tbr::PlannedSet const p = tbr::parse_manifest(fixture_dir() / "does_not_exist.txt");
    EXPECT_TRUE(p.ids.empty());
    EXPECT_TRUE(p.profile.empty());
}

TEST(TierBinaryReport, ParseManifestRealFormReadsCommentProfileAndStripsPermPrefix) {
    // Reale ce-Codegen-Form: Profil im '# Profile=..'-Kommentar, ids mit "perm_"-Praefix.
    // parse_manifest muss das Profil aus dem Kommentar lesen und die ids kanonisieren
    // (perm_aaa -> aaa), damit sie im selben Id-Raum wie scan_built liegen.
    tbr::PlannedSet const p = tbr::parse_manifest(fixture_dir() / "manifest_real_form.txt");
    EXPECT_EQ(p.profile, "smoke");
    ASSERT_EQ(p.ids.size(), 3U);
    EXPECT_EQ(p.ids[0], "aaa");
    EXPECT_EQ(p.ids[1], "bbb");
    EXPECT_EQ(p.ids[2], "ccc");
}

TEST(TierBinaryReport, ComputeVisibilityMatchesAcrossPermPrefix) {
    // End-to-end: reale-Form-Manifest (perm_-praefigiert) gegen den perm_dir
    // (perm_aaa.so + perm_bbb.so gebaut) -> 2 gebaut, ccc offen. Beweist, dass die
    // Kanonisierung geplante und gebaute Menge korrekt zusammenfuehrt.
    tbr::PlannedSet const       p = tbr::parse_manifest(fixture_dir() / "manifest_real_form.txt");
    tbr::BuiltSet const         b = tbr::scan_built(perm_dir());
    tbr::VisibilityReport const r = tbr::compute_visibility(p, b, /*builder_built=*/false);
    EXPECT_EQ(r.planned, 3U);
    EXPECT_EQ(r.built, 2U);
    ASSERT_EQ(r.open_ids.size(), 1U);
    EXPECT_EQ(r.open_ids[0], "ccc");
}

TEST(TierBinaryReport, ScanBuiltFindsOnlyPermPrefixedLibs) {
    tbr::BuiltSet const b = tbr::scan_built(perm_dir());
    ASSERT_EQ(b.ids.size(), 2U);
    // notperm.so muss ignoriert sein; aaa/bbb vorhanden (Reihenfolge egal -> sortiert pruefen).
    std::vector<std::string> ids = b.ids;
    std::sort(ids.begin(), ids.end());
    EXPECT_EQ(ids[0], "aaa");
    EXPECT_EQ(ids[1], "bbb");
}

TEST(TierBinaryReport, ComputeVisibilityCountsPlannedBuiltOpen) {
    tbr::PlannedSet const p = tbr::parse_manifest(fixture_dir() / "manifest_smoke.txt");
    tbr::BuiltSet const   b = tbr::scan_built(perm_dir());

    tbr::VisibilityReport const r = tbr::compute_visibility(p, b, /*builder_built=*/true);
    EXPECT_EQ(r.planned, 3U);
    EXPECT_EQ(r.built, 2U);
    EXPECT_EQ(r.open, 1U);
    ASSERT_EQ(r.open_ids.size(), 1U);
    EXPECT_EQ(r.open_ids[0], "ccc"); // aaa+bbb gebaut, ccc offen
    EXPECT_TRUE(r.builder_built);
    EXPECT_EQ(r.profile, "smoke");
}

TEST(TierBinaryReport, FormatVisibilityMentionsBuilderAndCounts) {
    tbr::VisibilityReport r;
    r.builder_built = false;
    r.profile       = "smoke";
    r.planned       = 3;
    r.built         = 2;
    r.open          = 1;
    r.open_ids      = {"ccc"};

    std::string const s = tbr::format_visibility(r);
    EXPECT_NE(s.find("CacheEngineBuilder: fehlt"), std::string::npos);
    EXPECT_NE(s.find("2/3 gebaut, 1 offen (Profil smoke)"), std::string::npos);
    EXPECT_NE(s.find("ccc"), std::string::npos);
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
