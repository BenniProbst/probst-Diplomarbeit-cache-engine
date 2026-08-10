// test_ci_wache_mutations_katalog.cpp -- der Katalog gegen den ECHTEN Baum. (2026-08-10)
// =============================================================================
// WARUM DIESE FAELLE IN EINEM EIGENEN ZIEL LIEGEN -- und nicht bei den uebrigen
// Harness-Tests: SIE LESEN DIE PRODUKTIONSDATEIEN VON DER PLATTE. Sobald der Harness
// einen Mutanten eingebaut hat, sind sie ROT -- bei JEDEM Mutanten, unabhaengig davon,
// ob die Suite den Fehler wirklich faengt.
//
// AM OBJEKT GEMESSEN, erster Lauf 2026-08-10: alle fuenf Mutanten meldeten
// "VOM-TEST-GETOETET", aber bei M4-wide-nenner-riegel und M5-yml-tabulator waren die
// EINZIGEN roten Tests genau diese beiden hier. Die vorhergesagten Deckungstests
// (WideFall.DerNennerIstEineIdentitaetKeineSchaetzung,
// CiYmlScanner.BlockEndetAnSpalteNullEinschliesslichKommentaren) blieben GRUEN. Die
// gemeldete Ueberlebensrate 0 von 5 war also eine KONSTANTE des Aufbaus, keine Messung
// -- das selbstreferenzielle Orakel, das der Designplan V7 unter K5 fuehrt.
//
// DIE TRENNUNG IST DER MECHANISMUS, nicht die Absicht: dieses Ziel traegt das
// ZUSATZ-LABEL mut_selbstbezug (Code/tests/CMakeLists.txt). Der Harness waehlt die
// Suite mit `-LE mut_selbstbezug` ab UND prueft die tatsaechliche Auswahl per
// `ctest -N` gegen das Praefix "MutationsKatalog." -- faellt die Abwahl aus, ist das
// ABBRUCH und kein stilles Weiterlaufen (LaufAbbruchGrund::SelbstbezugInDerSuite).
//
// DIE FAELLE SELBST BLEIBEN SCHARF und laufen in test:unit wie in test:unit:debug: sie
// sind die lebende Wache ueber den Katalog. Formatiert jemand eine der vier
// Produktionsdateien um, wird DIESES Ziel rot -- statt dass der Harness spaeter still
// ins Leere mutiert und "alle Mutanten getoetet" meldet.
//
// ASCII-only, Zeilen <= 120 Byte.
// =============================================================================

#include <algorithm>
#include <filesystem>
#include <string>
#include <vector>

#include <gmock/gmock.h>
#include <gtest/gtest.h>

#include "comdare/ci_wachen/mutations_lauf.hpp"

using comdare::ci_wachen::alle_testklassen;
using comdare::ci_wachen::ersetze_genau;
using comdare::ci_wachen::ErsetzErgebnis;
using comdare::ci_wachen::katalog;
using comdare::ci_wachen::KATALOG_SOLL;
using comdare::ci_wachen::lies_datei_ganz;
using comdare::ci_wachen::Mutant;
using comdare::ci_wachen::SELBSTBEZUG_LABEL;
using comdare::ci_wachen::SELBSTBEZUG_PRAEFIX;
using comdare::ci_wachen::Testklasse;
using comdare::ci_wachen::zaehle_vorkommen;

namespace {
std::filesystem::path repo_wurzel() { return std::filesystem::path(COMDARE_REPO_WURZEL_MUT); }
} // namespace

// =============================================================================
// 1. DER KATALOG GEGEN DIE ECHTEN PRODUKTIONSDATEIEN
// =============================================================================

TEST(MutationsKatalog, NennerIstFUENFUndJedeIdKommtGENAUEinmalVor) {
    // T-3: der Nenner steht als eingefrorene Konstante NEBEN dem Katalog, nicht in ihm,
    // und die Zusicherung steht VOR der Schleife.
    ASSERT_EQ(katalog().size(), KATALOG_SOLL) << "Der Katalog ist gewachsen/geschrumpft.";
    ASSERT_EQ(KATALOG_SOLL, 5u) << "Der Auftrag verlangt FUENF Mutanten.";

    std::vector<std::string> ids;
    for (const Mutant& m : katalog()) ids.emplace_back(m.id);
    std::vector<std::string> sortiert = ids;
    std::sort(sortiert.begin(), sortiert.end());
    ASSERT_EQ(std::unique(sortiert.begin(), sortiert.end()) - sortiert.begin(), static_cast<long>(ids.size()))
        << "Doppelte Mutanten-ID -- die Ergebnisse waeren nicht mehr zuzuordnen.";
}

TEST(MutationsKatalog, JederAnkerStehtGENAUSooftInDerECHTENProduktionsdatei) {
    // DAS IST DIE LEBENDE WACHE. Formatiert jemand eine der vier Produktionsdateien um,
    // wird dieser Test rot -- statt dass der Harness spaeter still ins Leere mutiert und
    // "alle Mutanten getoetet" meldet.
    ASSERT_EQ(katalog().size(), KATALOG_SOLL);
    std::size_t geprueft = 0;
    for (const Mutant& m : katalog()) {
        const std::filesystem::path datei  = repo_wurzel() / std::string(m.datei);
        const auto                  inhalt = lies_datei_ganz(datei);
        ASSERT_TRUE(inhalt.has_value()) << "Produktionsdatei nicht lesbar: " << datei.string();
        EXPECT_EQ(zaehle_vorkommen(*inhalt, m.suchen), m.erwartete_treffer)
            << "Mutant " << m.id << ": der Anker passt nicht mehr auf " << m.datei;
        ++geprueft;
    }
    EXPECT_EQ(geprueft, KATALOG_SOLL) << "NENNER: es wurden nicht alle Katalog-Anker geprueft.";
}

TEST(MutationsKatalog, JederMutantVERAENDERTDieDateiWIRKLICH) {
    // Anwesenheit des Ankers genuegt nicht (T-2). Die Ersetzung muss einen ANDEREN
    // Dateiinhalt ergeben -- sonst waere der Mutant per Konstruktion ueberlebensfaehig.
    ASSERT_EQ(katalog().size(), KATALOG_SOLL);
    for (const Mutant& m : katalog()) {
        const auto inhalt = lies_datei_ganz(repo_wurzel() / std::string(m.datei));
        ASSERT_TRUE(inhalt.has_value()) << m.id;
        const ErsetzErgebnis e = ersetze_genau(*inhalt, m.suchen, m.ersetzen, m.erwartete_treffer);
        ASSERT_TRUE(e.ok) << m.id << ": " << e.diagnose;
        EXPECT_NE(e.inhalt, *inhalt) << "Mutant " << m.id << " aendert die Datei NICHT.";
    }
}

TEST(MutationsKatalog, JedeGefuehrteTestklasseKommtImKatalogVor) {
    // Vollstaendigkeits-Tabelle: waechst Testklasse, faellt zuerst der static_assert im
    // Header, dann dieser Fall. Der Auftrag nennt beide Klassen ausdruecklich.
    ASSERT_EQ(sizeof(alle_testklassen) / sizeof(alle_testklassen[0]), 2u);
    for (const Testklasse klasse : alle_testklassen) {
        const bool vorhanden =
            std::any_of(katalog().begin(), katalog().end(), [&](const Mutant& m) { return m.klasse == klasse; });
        EXPECT_TRUE(vorhanden) << "Keine Mutante der Klasse " << klasse << " im Katalog.";
    }
}

TEST(MutationsKatalog, JederMutantNenntEineAussageUndMindestensEineVorhersage) {
    ASSERT_EQ(katalog().size(), KATALOG_SOLL);
    for (const Mutant& m : katalog()) {
        EXPECT_FALSE(m.aussage.empty()) << m.id << ": ohne benannte Aussage ist ein Mutant nur Rauschen.";
        EXPECT_FALSE(m.erwartet_rot[0].empty()) << m.id << ": ohne Vorhersage ist das Ergebnis nicht pruefbar.";
    }
}

// =============================================================================
// DIE ABWAHL IST EIN MECHANISMUS -- diese zwei Faelle halten ihn fest
// =============================================================================

TEST(MutationsKatalog, DasPRAEFIXIstDerECHTESuiteNameDIESERDatei) {
    // Der Harness filtert die Suite ueber SELBSTBEZUG_PRAEFIX. Wuerde jemand die
    // Testsuite hier umbenennen, liefe der Filter ins Leere -- und der Selbstbezug
    // waere lautlos zurueck. gtest nennt seinen eigenen Suite-Namen; das ist die
    // FREMDE Quelle, nicht ein zweites Literal (T-3/T-5).
    const std::string suite = ::testing::UnitTest::GetInstance()->current_test_info()->test_suite_name();
    ASSERT_FALSE(suite.empty());
    EXPECT_EQ(std::string(SELBSTBEZUG_PRAEFIX), suite + ".")
        << "Der Praefix-Filter des Harness passt nicht mehr auf diese Testsuite.";
}

TEST(MutationsKatalog, DIE_ABWAHL_StehtPOSITIONSGEBUNDENInDerCMakeDatei) {
    // Anwesenheit genuegt nicht (T-2): das Label muss GENAU im Block DIESES Ziels
    // stehen. Sonst koennte es an einem beliebigen anderen Ziel haengen und die Abwahl
    // waere trotzdem "nachgewiesen".
    const auto cmake = lies_datei_ganz(repo_wurzel() / "Code" / "tests" / "CMakeLists.txt");
    ASSERT_TRUE(cmake.has_value()) << "Code/tests/CMakeLists.txt nicht lesbar";

    const std::string ziel      = "comdare_da_add_test(test_ci_wache_mutations_katalog";
    const std::string label     = "LABELS ci_wachen " + std::string(SELBSTBEZUG_LABEL);
    const std::string naechstes = "comdare_da_add_test(";

    ASSERT_EQ(zaehle_vorkommen(*cmake, ziel), 1u) << "Das Ziel steht nicht genau einmal in der CMake-Datei.";
    const std::size_t start = cmake->find(ziel);
    ASSERT_NE(start, std::string::npos);
    const std::size_t ende    = cmake->find(naechstes, start + ziel.size());
    const std::size_t treffer = cmake->find(label, start);
    ASSERT_NE(treffer, std::string::npos) << "Kein '" << label << "' nach dem Ziel gefunden.";
    EXPECT_LT(treffer, ende) << "Das Label haengt an einem ANDEREN Ziel, nicht an diesem.";

    // GEGENPROBE zur Nichtfund-Klasse: derselbe Zaehler findet den Ziel-Namen sehr wohl,
    // ein erfundener Nachbar aber nicht -- die Suche ist also nicht generell blind.
    EXPECT_EQ(zaehle_vorkommen(*cmake, "comdare_da_add_test(test_ci_wache_gibtsnicht"), 0u);
}
