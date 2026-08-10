// test_ci_wache_mutations_lauf.cpp -- der Harness selbst unter Test.       (2026-08-10)
// =============================================================================
// WAS HIER GEPRUEFT WIRD -- und was NICHT.
//
// GEPRUEFT: der Harness. Seine Anker gegen die ECHTEN Produktionsdateien, seine
// Fail-Closed-Kanten, sein ctest-Leser, seine Ruecknahme (byte-weise) und jeder seiner
// vier Ausgaenge. Alles in Debug UND Release, weil das Ziel im Sammel-Bau haengt
// (Owner-KERN 09.08.: "in Release zu wiederholen aufgrund von compile regressionen").
//
// NICHT GEPRUEFT (ausdruecklich, damit niemand mehr hineinliest als drinsteht): der
// echte cmake-/ctest-/git-Aufruf. Die drei stecken in EchteLaufNaht; sie werden hier
// durch eine Fake-Naht ersetzt -- genau wie FakeGitQuelle und FakeXmlParser in den
// Nachbardateien. Der Beleg, dass EchteLaufNaht wirklich baut und faehrt, ist der
// PROTOKOLLIERTE LAUF des Binaries, nicht dieser Test.
//
// DIE FRAGE NACH V-8 ("was waere der Zustand, in dem diese Ausgabe erscheint und die
// Sache trotzdem nicht existiert?") hat hier eine sehr konkrete Antwort: der Harness
// meldet "5 Mutanten gefahren, 5 getoetet", ohne je eine Datei veraendert zu haben --
// weil der Anker nicht mehr passt und die Ersetzung ins Leere lief. Genau dagegen
// stehen zwei Faelle: AnkerStehtGENAUSooftInDerEchtenProduktionsdatei (der Anker wird
// gegen die Datei auf der Platte gehalten) und ErsetzeGenau.VierGegeneingaenge (eine
// verfehlte Trefferzahl ist ABBRUCH, nie eine stille Ersetzung).
//
// ASCII-only, Zeilen <= 120 Byte.
// =============================================================================

#include <algorithm>
#include <array>
#include <atomic>
#include <filesystem>
#include <random>
#include <span>
#include <string>
#include <vector>

#include <gmock/gmock.h>
#include <gtest/gtest.h>

#include "comdare/ci_wachen/mutations_lauf.hpp"
#include "comdare/ci_wachen/werkbank.hpp"

using comdare::ci_wachen::alle_mutant_ausgaenge;
using comdare::ci_wachen::alle_testklassen;
using comdare::ci_wachen::CtestBefund;
using comdare::ci_wachen::ersetze_genau;
using comdare::ci_wachen::ErsetzErgebnis;
using comdare::ci_wachen::fahre_mutationslauf;
using comdare::ci_wachen::katalog;
using comdare::ci_wachen::KATALOG_SOLL;
using comdare::ci_wachen::LaufAbbruchGrund;
using comdare::ci_wachen::LaufNaht;
using comdare::ci_wachen::lies_ctest_befund;
using comdare::ci_wachen::lies_datei_ganz;
using comdare::ci_wachen::Mutant;
using comdare::ci_wachen::MutantAusgang;
using comdare::ci_wachen::MutationsLaufErgebnis;
using comdare::ci_wachen::schreibe_datei_ganz;
using comdare::ci_wachen::Testklasse;
using comdare::ci_wachen::WacheStatus;
using comdare::ci_wachen::zaehle_vorkommen;
using comdare::ci_wachen::werkbank::Wuerfel;

namespace {

std::filesystem::path repo_wurzel() { return std::filesystem::path(COMDARE_REPO_WURZEL_MUT); }

// Ein Wegwerf-Verzeichnis. Kein git noetig: der Arbeitsbaum-Status kommt in diesen
// Faellen aus der Fake-Naht, nicht aus git.
class TempBaum {
public:
    TempBaum() {
        static std::atomic<unsigned> zaehler{0};
        std::random_device           geraet;
        std::string                  name = "comdare_mutlauf_";
        name += std::to_string(static_cast<unsigned long long>(geraet()));
        name += "_" + std::to_string(zaehler.fetch_add(1));
        pfad_ = std::filesystem::temp_directory_path() / name;
        std::filesystem::create_directories(pfad_ / "unterordner");
    }
    ~TempBaum() {
        std::error_code fehler;
        std::filesystem::remove_all(pfad_, fehler);
    }
    TempBaum(const TempBaum&)            = delete;
    TempBaum& operator=(const TempBaum&) = delete;

    const std::filesystem::path& pfad() const { return pfad_; }

private:
    std::filesystem::path pfad_;
};

// Die Fake-Naht. Sie beantwortet Bau, Suite und Arbeitsbaum-Status aus vorgegebenen
// Listen -- damit ist JEDER der vier Ausgaenge erreichbar, ohne cmake zu starten.
class FakeLaufNaht final : public LaufNaht {
public:
    std::vector<bool>        bau_antworten;
    std::vector<std::string> suite_antworten;
    std::string              status_vorher;
    std::string              status_nachher;
    int                      bau_aufrufe    = 0;
    int                      suite_aufrufe  = 0;
    int                      status_aufrufe = 0;

    bool baue() override {
        const std::size_t i = static_cast<std::size_t>(bau_aufrufe++);
        if (bau_antworten.empty()) return true;
        return bau_antworten[std::min(i, bau_antworten.size() - 1)];
    }
    std::string fahre_suite() override {
        const std::size_t i = static_cast<std::size_t>(suite_aufrufe++);
        if (suite_antworten.empty()) return {};
        return suite_antworten[std::min(i, suite_antworten.size() - 1)];
    }
    std::string arbeitsbaum_status() override { return (status_aufrufe++ == 0) ? status_vorher : status_nachher; }
    std::string bezeichnung() const override { return "FakeLaufNaht"; }
};

// Erzeugt eine ctest-Ausgabe in der ECHTEN Form. Die Form ist einmalig am Objekt
// erhoben und hier eingefroren (T-5: das Orakel stammt nicht aus dem Pruefling) --
// gemessen 2026-08-10 an ctest 3.28 im Bauverzeichnis Code/build/mut.
std::string ctest_ausgabe(int gefallen, int gesamt, const std::vector<std::string>& rote) {
    const int   bestanden = gesamt - gefallen;
    const int   prozent   = (gesamt > 0) ? (bestanden * 100 / gesamt) : 0;
    std::string text;
    text += std::to_string(prozent) + "% tests passed, " + std::to_string(gefallen) + " tests failed out of " +
            std::to_string(gesamt) + "\n";
    text += "\nTotal Test time (real) =   0.43 sec\n";
    if (!rote.empty()) {
        text += "\nThe following tests FAILED:\n";
        int nummer = 100;
        for (const std::string& name : rote) { text += "\t" + std::to_string(nummer++) + " - " + name + " (Failed)\n"; }
        text += "Errors while running CTest\n";
    }
    return text;
}

// Ein Wegwerf-Mutant auf eine Datei, die der Fall selbst anlegt. Die Zeichenketten
// leben im Aufrufer -- Mutant haelt nur string_view.
struct MutantHalter {
    std::string                id;
    std::string                datei;
    std::string                aussage;
    std::string                suchen;
    std::string                ersetzen;
    std::array<std::string, 2> erwartet_rot;

    Mutant mutant(std::size_t treffer = 1, Testklasse klasse = Testklasse::KeineNegativprobe) const {
        return Mutant{id,     datei,    klasse,  aussage,
                      suchen, ersetzen, treffer, std::array<std::string_view, 2>{{erwartet_rot[0], erwartet_rot[1]}}};
    }
};

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
// 2. ersetze_genau -- die Fail-Closed-Kante
// =============================================================================

TEST(ErsetzeGenau, VIER_GEGENEINGAENGE_SindABBRUCHUndKeineStilleErsetzung) {
    // T-4: zu jeder Zusicherung ein Eingang, bei dem sie NICHT gilt.
    const std::string text = "alpha beta alpha";

    const ErsetzErgebnis leer = ersetze_genau(text, "", "x", 1);
    EXPECT_FALSE(leer.ok);
    EXPECT_THAT(leer.diagnose, testing::HasSubstr("leerer Anker"));

    const ErsetzErgebnis null_erwartet = ersetze_genau(text, "alpha", "x", 0);
    EXPECT_FALSE(null_erwartet.ok);
    EXPECT_THAT(null_erwartet.diagnose, testing::HasSubstr("erwartete_treffer == 0"));

    const ErsetzErgebnis daneben = ersetze_genau(text, "alpha", "x", 1);
    EXPECT_FALSE(daneben.ok) << "zwei Treffer bei erwartet 1 MUSS abbrechen";
    EXPECT_EQ(daneben.gefunden, 2u);
    EXPECT_THAT(daneben.diagnose, testing::HasSubstr("FAIL-CLOSED"));

    const ErsetzErgebnis identisch = ersetze_genau(text, "beta", "beta", 1);
    EXPECT_FALSE(identisch.ok) << "eine Mutation, die nichts aendert, ist keine Mutation";
    EXPECT_THAT(identisch.diagnose, testing::HasSubstr("suchen == ersetzen"));
}

TEST(ErsetzeGenau, AlleTrefferWerdenErsetztUndDerRestBLEIBTBYTEGLEICH) {
    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));
    const std::string koeder = wuerfel.token(16);
    const std::string rest_a = wuerfel.token(24);
    const std::string rest_b = wuerfel.token(24);

    const std::string    text = rest_a + koeder + rest_b + koeder + "\n";
    const ErsetzErgebnis e    = ersetze_genau(text, koeder, "ERSETZT", 2);
    ASSERT_TRUE(e.ok) << e.diagnose;
    EXPECT_EQ(e.gefunden, 2u);
    EXPECT_EQ(e.inhalt, rest_a + "ERSETZT" + rest_b + "ERSETZT" + "\n");
    EXPECT_EQ(zaehle_vorkommen(e.inhalt, koeder), 0u) << "ein Vorkommen ist stehengeblieben";
}

TEST(ErsetzeGenau, ZaehlenUeberlappungsFREI) {
    // Gegenprobe zur Nichtfund-Aussage: derselbe Zaehler liefert an einem konstruierten
    // Fall eine BENANNTE Trefferzahl, nicht nur "keine Ueberraschung".
    EXPECT_EQ(zaehle_vorkommen("aaaa", "aa"), 2u);
    EXPECT_EQ(zaehle_vorkommen("aaaa", "aaa"), 1u);
    EXPECT_EQ(zaehle_vorkommen("abc", ""), 0u) << "leere Nadel darf nie Treffer melden";
}

// =============================================================================
// 3. Der ctest-Leser -- Aussage statt Anwesenheit
// =============================================================================

TEST(CtestBefund, ZusammenfassungWirdGELESENUndDieNamenAuch) {
    const std::string ausgabe = ctest_ausgabe(2, 310, {"Alpha.Beta", "Gamma/Delta.Epsilon/case_1"});
    const CtestBefund befund  = lies_ctest_befund(ausgabe);
    ASSERT_TRUE(befund.zusammenfassung_gelesen);
    EXPECT_EQ(befund.gefallen, 2);
    EXPECT_EQ(befund.gesamt, 310);
    ASSERT_EQ(befund.rote_tests.size(), 2u);
    EXPECT_EQ(befund.rote_tests[0], "Alpha.Beta");
    EXPECT_EQ(befund.rote_tests[1], "Gamma/Delta.Epsilon/case_1");
}

TEST(CtestBefund, OHNE_ZusammenfassungIstNICHTGelesenUndDamitKEINGruen) {
    // FAIL-CLOSED: eine Ausgabe ohne Zusammenfassung ist keine Aussage ueber die Suite.
    const CtestBefund befund = lies_ctest_befund("Errors while running CTest\nUnable to find executable\n");
    EXPECT_FALSE(befund.zusammenfassung_gelesen);
    EXPECT_EQ(befund.gefallen, 0) << "0 darf hier NICHT als 'nichts kaputt' gelesen werden";
    EXPECT_TRUE(befund.rote_tests.empty());
}

TEST(CtestBefund, DasWORT_FAILED_AlleinIstKEINEAussage) {
    // T-2: ein Test, der zufaellig "FAILED" im NAMEN traegt, macht die Suite nicht rot.
    const std::string ausgabe = ctest_ausgabe(0, 7, {}) + "\nTest #3: Wache.MeldetFAILEDImNamen ... Passed\n";
    const CtestBefund befund  = lies_ctest_befund(ausgabe);
    ASSERT_TRUE(befund.zusammenfassung_gelesen);
    EXPECT_EQ(befund.gefallen, 0);
    EXPECT_TRUE(befund.rote_tests.empty());
}

TEST(CtestBefund, NachDerListeWirdNichtWeitergeraten) {
    const std::string ausgabe = ctest_ausgabe(1, 5, {"Nur.Einer"});
    const CtestBefund befund  = lies_ctest_befund(ausgabe);
    ASSERT_EQ(befund.rote_tests.size(), 1u) << "'Errors while running CTest' darf kein Testname werden";
    EXPECT_EQ(befund.rote_tests[0], "Nur.Einer");
}

// =============================================================================
// 4. Der Lauf -- Ruecknahme, vier Ausgaenge, Fail-Closed-Kanten
// =============================================================================

namespace {

// Legt eine Wegwerf-"Produktionsdatei" mit gewuerfeltem Inhalt an, in dem der Anker
// GENAU einmal steht. Der Inhalt traegt absichtlich ein NUL-Byte, ein CR und KEIN
// abschliessendes Zeilenende -- drei Dinge, an denen eine schlampige Ruecknahme
// auffliegt und eine zeilenweise gar nicht erst bestuende.
struct Fixture {
    TempBaum     baum;
    MutantHalter halter;
    std::string  original;

    Fixture(Wuerfel& wuerfel, const std::string& anker) {
        halter.id           = "T-" + wuerfel.token(6);
        halter.datei        = "unterordner/pruefling.cpp";
        halter.aussage      = "Wegwerf-Zusicherung";
        halter.suchen       = anker;
        halter.ersetzen     = "MUTIERT_" + wuerfel.token(6);
        halter.erwartet_rot = {"Vorhergesagt.Rot", ""};
        original            = wuerfel.token(20);
        original.push_back('\0');
        original += "\r\n" + anker + "\n" + wuerfel.token(20) + "\r";
        EXPECT_TRUE(schreibe_datei_ganz(baum.pfad() / halter.datei, original));
    }

    std::filesystem::path datei() const { return baum.pfad() / halter.datei; }
};

} // namespace

TEST(MutationsLauf, RUECKNAHME_StelltDieDateiBYTEGLEICHHerUndDerLaufSagtEsAuch) {
    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));
    Fixture      fix(wuerfel, "ANKER_" + wuerfel.token(8));
    const Mutant m = fix.halter.mutant();

    FakeLaufNaht naht;
    naht.suite_antworten = {ctest_ausgabe(0, 310, {}), ctest_ausgabe(1, 310, {"Vorhergesagt.Rot"})};

    const MutationsLaufErgebnis e = fahre_mutationslauf(fix.baum.pfad(), naht, std::span<const Mutant>(&m, 1));

    ASSERT_EQ(e.je_mutant.size(), 1u);
    EXPECT_TRUE(e.je_mutant[0].byte_gleich_zurueckgenommen);
    EXPECT_EQ(e.status, WacheStatus::Gruen);

    // Die eigentliche Zusicherung: die Bytes auf der Platte, nicht die Behauptung des
    // Harness ueber sich selbst (V-8: zwei Quellen, nicht eine).
    const auto nachher = lies_datei_ganz(fix.datei());
    ASSERT_TRUE(nachher.has_value());
    EXPECT_EQ(*nachher, fix.original) << "Der Harness hat den Baum veraendert zurueckgelassen.";
    EXPECT_EQ(nachher->size(), fix.original.size());
}

TEST(MutationsLauf, WAEHREND_DesLaufsIstDieDateiWIRKLICHMutiert) {
    // Gegenprobe zum vorigen Fall: er allein waere auch dann gruen, wenn NIE mutiert
    // wuerde. Hier sieht die Naht die Datei IM mutierten Zustand und protokolliert es.
    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));
    Fixture      fix(wuerfel, "ANKER_" + wuerfel.token(8));
    const Mutant m = fix.halter.mutant();

    class SpaehendeNaht final : public LaufNaht {
    public:
        std::filesystem::path datei;
        std::string           gesehen_beim_zweiten_bau;
        int                   bau_aufrufe   = 0;
        int                   suite_aufrufe = 0;

        bool baue() override {
            if (++bau_aufrufe == 2) {
                const auto inhalt        = lies_datei_ganz(datei);
                gesehen_beim_zweiten_bau = inhalt.value_or(std::string());
            }
            return true;
        }
        // Der ERSTE Aufruf ist der Grundlauf und MUSS gruen sein (K13-Gegenkoeder im
        // Harness); erst der zweite laeuft unter dem Mutanten.
        std::string fahre_suite() override {
            return (++suite_aufrufe == 1) ? ctest_ausgabe(0, 310, {}) : ctest_ausgabe(1, 310, {"Vorhergesagt.Rot"});
        }
        std::string arbeitsbaum_status() override { return {}; }
        std::string bezeichnung() const override { return "SpaehendeNaht"; }
    } naht;
    naht.datei = fix.datei();

    const MutationsLaufErgebnis e = fahre_mutationslauf(fix.baum.pfad(), naht, std::span<const Mutant>(&m, 1));
    EXPECT_EQ(e.status, WacheStatus::Gruen);
    EXPECT_NE(naht.gesehen_beim_zweiten_bau, fix.original) << "Es wurde nie mutiert -- der Lauf misst nichts.";
    EXPECT_NE(naht.gesehen_beim_zweiten_bau.find(fix.halter.ersetzen), std::string::npos)
        << "Der Ersatztext stand waehrend des Baus nicht in der Datei.";
}

TEST(MutationsLauf, JEDER_DER_VIER_AUSGAENGE_WirdErreicht) {
    // T-4 ueber die ganze Ausgangs-Tabelle. Der Nenner steht vor der Schleife.
    ASSERT_EQ(sizeof(alle_mutant_ausgaenge) / sizeof(alle_mutant_ausgaenge[0]), 4u);
    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));

    // (a) VomTestGetoetet
    {
        Fixture      fix(wuerfel, "ANKER_" + wuerfel.token(8));
        const Mutant m = fix.halter.mutant();
        FakeLaufNaht naht;
        naht.suite_antworten = {ctest_ausgabe(0, 12, {}), ctest_ausgabe(1, 12, {"Vorhergesagt.Rot"})};
        const auto e         = fahre_mutationslauf(fix.baum.pfad(), naht, std::span<const Mutant>(&m, 1));
        ASSERT_EQ(e.je_mutant.size(), 1u);
        EXPECT_EQ(e.je_mutant[0].ausgang, MutantAusgang::VomTestGetoetet);
        EXPECT_EQ(e.vom_test_getoetet, 1u);
        EXPECT_EQ(e.status, WacheStatus::Gruen);
    }
    // (b) Ueberlebend -- und der Lauf ist RISS, nicht gruen
    {
        Fixture      fix(wuerfel, "ANKER_" + wuerfel.token(8));
        const Mutant m = fix.halter.mutant();
        FakeLaufNaht naht;
        naht.suite_antworten = {ctest_ausgabe(0, 12, {})};
        const auto e         = fahre_mutationslauf(fix.baum.pfad(), naht, std::span<const Mutant>(&m, 1));
        ASSERT_EQ(e.je_mutant.size(), 1u);
        EXPECT_EQ(e.je_mutant[0].ausgang, MutantAusgang::Ueberlebend);
        EXPECT_EQ(e.ueberlebend, 1u);
        EXPECT_EQ(e.status, WacheStatus::Riss) << "ein Ueberlebender ist ein BEFUND, kein Gruen";
        EXPECT_THAT(e.protokoll(), testing::HasSubstr("UEBERLEBENSRATE: 1 von 1"));
    }
    // (c) VomBauGetoetet -- die Suite kam nie zum Zug
    {
        Fixture      fix(wuerfel, "ANKER_" + wuerfel.token(8));
        const Mutant m = fix.halter.mutant();
        FakeLaufNaht naht;
        naht.bau_antworten   = {true, false, true};
        naht.suite_antworten = {ctest_ausgabe(0, 12, {})};
        const auto e         = fahre_mutationslauf(fix.baum.pfad(), naht, std::span<const Mutant>(&m, 1));
        ASSERT_EQ(e.je_mutant.size(), 1u);
        EXPECT_EQ(e.je_mutant[0].ausgang, MutantAusgang::VomBauGetoetet);
        EXPECT_EQ(e.vom_bau_getoetet, 1u);
        EXPECT_EQ(e.vom_test_getoetet, 0u) << "ein Bau-Tod darf NIE als Test-Deckung gezaehlt werden";
        EXPECT_EQ(naht.suite_aufrufe, 1) << "die Suite darf unter dem Bau-Toten nicht gefahren worden sein";
    }
    // (d) HarnessAbbruch -- der Anker passt nicht
    {
        Fixture      fix(wuerfel, "ANKER_" + wuerfel.token(8));
        MutantHalter kaputt = fix.halter;
        kaputt.suchen       = "DIESEN_TEXT_GIBT_ES_NICHT_" + wuerfel.token(8);
        const Mutant m      = kaputt.mutant();
        FakeLaufNaht naht;
        naht.suite_antworten = {ctest_ausgabe(0, 12, {})};
        const auto e         = fahre_mutationslauf(fix.baum.pfad(), naht, std::span<const Mutant>(&m, 1));
        ASSERT_EQ(e.je_mutant.size(), 1u);
        EXPECT_EQ(e.je_mutant[0].ausgang, MutantAusgang::HarnessAbbruch);
        EXPECT_EQ(e.harness_abbruch, 1u);
        EXPECT_EQ(e.status, WacheStatus::Abbruch) << "ein Harness, der nicht messen konnte, meldet NIE gruen";
        // Und die Datei ist unangetastet geblieben.
        const auto nachher = lies_datei_ganz(fix.datei());
        ASSERT_TRUE(nachher.has_value());
        EXPECT_EQ(*nachher, fix.original);
    }
}

TEST(MutationsLauf, SCHMUTZIGER_BAUM_IstAbbruchVorDemErstenMutanten) {
    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));
    Fixture      fix(wuerfel, "ANKER_" + wuerfel.token(8));
    const Mutant m = fix.halter.mutant();

    FakeLaufNaht naht;
    naht.status_vorher   = " M Code/irgendwas.cpp\n";
    naht.suite_antworten = {ctest_ausgabe(0, 12, {})};

    const auto e = fahre_mutationslauf(fix.baum.pfad(), naht, std::span<const Mutant>(&m, 1));
    ASSERT_TRUE(e.abbruch.has_value());
    EXPECT_EQ(*e.abbruch, LaufAbbruchGrund::BaumSchmutzigVorher);
    EXPECT_EQ(e.gefahren, 0u);
    EXPECT_EQ(naht.bau_aufrufe, 0) << "es darf nicht einmal gebaut worden sein";
    EXPECT_THAT(e.protokoll(), testing::HasSubstr("MUTATIONS-NENNER: 1 Mutanten im Katalog, 0 gefahren"));
}

TEST(MutationsLauf, GRUNDLAUF_ROT_IstAbbruch_K13_Gegenkoeder) {
    // K13 verlangt beide Seiten: der unmanipulierte Lauf MUSS gruen sein. Ist er es
    // nicht, waere kein einziger Mutant zurechenbar -- also wird gar nicht erst mutiert.
    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));
    Fixture      fix(wuerfel, "ANKER_" + wuerfel.token(8));
    const Mutant m = fix.halter.mutant();

    FakeLaufNaht naht;
    naht.suite_antworten = {ctest_ausgabe(3, 310, {"Schon.Rot"})};

    const auto e = fahre_mutationslauf(fix.baum.pfad(), naht, std::span<const Mutant>(&m, 1));
    ASSERT_TRUE(e.abbruch.has_value());
    EXPECT_EQ(*e.abbruch, LaufAbbruchGrund::GrundlaufSuiteRot);
    EXPECT_EQ(e.gefahren, 0u);
    const auto nachher = lies_datei_ganz(fix.datei());
    ASSERT_TRUE(nachher.has_value());
    EXPECT_EQ(*nachher, fix.original);
}

TEST(MutationsLauf, LEERE_SUITE_IstAbbruchUndNichtEinBestandenerLauf) {
    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));
    Fixture      fix(wuerfel, "ANKER_" + wuerfel.token(8));
    const Mutant m = fix.halter.mutant();

    FakeLaufNaht naht;
    naht.suite_antworten = {"0% tests passed, 0 tests failed out of 0\n"};

    const auto e = fahre_mutationslauf(fix.baum.pfad(), naht, std::span<const Mutant>(&m, 1));
    ASSERT_TRUE(e.abbruch.has_value());
    EXPECT_EQ(*e.abbruch, LaufAbbruchGrund::GrundlaufLeererNenner);
}

TEST(MutationsLauf, UNLESBARE_CTEST_AUSGABE_IstAbbruchNichtNullFehler) {
    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));
    Fixture      fix(wuerfel, "ANKER_" + wuerfel.token(8));
    const Mutant m = fix.halter.mutant();

    FakeLaufNaht naht;
    naht.suite_antworten = {"ctest: command not found\n"};

    const auto e = fahre_mutationslauf(fix.baum.pfad(), naht, std::span<const Mutant>(&m, 1));
    ASSERT_TRUE(e.abbruch.has_value());
    EXPECT_EQ(*e.abbruch, LaufAbbruchGrund::GrundlaufSuiteUnlesbar);
}

TEST(MutationsLauf, BAUM_NACH_DEM_LAUF_SCHMUTZIG_IstAbbruch) {
    // Die FREMDE Gegenprobe (T-3): nicht der Harness urteilt ueber den Baum, sondern git.
    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));
    Fixture      fix(wuerfel, "ANKER_" + wuerfel.token(8));
    const Mutant m = fix.halter.mutant();

    FakeLaufNaht naht;
    naht.status_nachher  = "?? uebriggebliebene_datei\n";
    naht.suite_antworten = {ctest_ausgabe(0, 12, {}), ctest_ausgabe(1, 12, {"Vorhergesagt.Rot"})};

    const auto e = fahre_mutationslauf(fix.baum.pfad(), naht, std::span<const Mutant>(&m, 1));
    ASSERT_TRUE(e.abbruch.has_value());
    EXPECT_EQ(*e.abbruch, LaufAbbruchGrund::BaumSchmutzigNachher);
    EXPECT_NE(e.status, WacheStatus::Gruen);
}

TEST(MutationsLauf, VORHERSAGE_VERFEHLT_WirdBENANNT) {
    // Ein Mutant kann getoetet werden und die Vorhersage TROTZDEM verfehlen -- dann biss
    // ein anderer Test als der, der die Stelle decken sollte. Das ist ein eigener Befund.
    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));
    Fixture      fix(wuerfel, "ANKER_" + wuerfel.token(8));
    const Mutant m = fix.halter.mutant(); // erwartet_rot[0] == "Vorhergesagt.Rot"

    FakeLaufNaht naht;
    naht.suite_antworten = {ctest_ausgabe(0, 12, {}), ctest_ausgabe(1, 12, {"EinGanzAnderer.Test"})};

    const auto e = fahre_mutationslauf(fix.baum.pfad(), naht, std::span<const Mutant>(&m, 1));
    ASSERT_EQ(e.je_mutant.size(), 1u);
    EXPECT_EQ(e.je_mutant[0].ausgang, MutantAusgang::VomTestGetoetet);
    ASSERT_EQ(e.je_mutant[0].vorhergesagt_aber_gruen.size(), 1u);
    EXPECT_EQ(e.je_mutant[0].vorhergesagt_aber_gruen[0], "Vorhergesagt.Rot");
    EXPECT_THAT(e.protokoll(), testing::HasSubstr("VORHERSAGE VERFEHLT"));
}

TEST(MutationsLauf, DER_NENNER_IST_EINE_IDENTITAET_UndStehtInDerAUSGABE) {
    // V-1: der Nenner gehoert in die AUSGABE des Werkzeugs, nicht in den Bericht.
    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));
    Fixture fix_a(wuerfel, "ANKER_A_" + wuerfel.token(8));
    Fixture fix_b(wuerfel, "ANKER_B_" + wuerfel.token(8));
    // Beide Mutanten muessen in DENSELBEN Baum zeigen -- also legt fix_a beide Dateien an.
    MutantHalter zweiter = fix_b.halter;
    zweiter.datei        = "unterordner/zweiter.cpp";
    zweiter.id           = "T2-" + wuerfel.token(6);
    ASSERT_TRUE(schreibe_datei_ganz(fix_a.baum.pfad() / zweiter.datei, fix_b.original));

    const std::vector<Mutant> mutanten = {fix_a.halter.mutant(), zweiter.mutant()};

    FakeLaufNaht naht;
    naht.suite_antworten = {ctest_ausgabe(0, 310, {}), ctest_ausgabe(1, 310, {"Vorhergesagt.Rot"}),
                            ctest_ausgabe(0, 310, {})};

    const auto e = fahre_mutationslauf(fix_a.baum.pfad(), naht, std::span<const Mutant>(mutanten));
    EXPECT_TRUE(e.nenner_haelt()) << "gefahren != Summe der Ausgaenge";
    EXPECT_EQ(e.gefahren, 2u);
    EXPECT_EQ(e.katalog_gesamt, 2u);
    EXPECT_EQ(e.basis_tests, 310);

    const std::string text = e.protokoll();
    EXPECT_THAT(text, testing::HasSubstr("2 Mutanten im Katalog, 2 gefahren"));
    EXPECT_THAT(text, testing::HasSubstr("Suite-Nenner: 310 Tests je Lauf"));
    EXPECT_THAT(text, testing::HasSubstr("UEBERLEBENSRATE: 1 von 2"));
}
