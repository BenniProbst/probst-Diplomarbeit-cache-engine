// test_ci_wache_registrierung.cpp -- T-7: laufen die Wachen ueberhaupt?    (2026-08-09)
// =============================================================================
// LOEST AB: F11/F12 der xml-Probe und F13 der Paritaets-Probe.
//
// WAS ctest SELBST SCHON BEWEIST -- und was hier deshalb NICHT mehr steht:
// Die EXISTENZ der Tests beweist `ctest -N`. gtest_discover_tests laeuft POST_BUILD:
// ein Test-Binary, das sich nicht aufzaehlen laesst, BRICHT DEN BAU. Ein verschwundener
// Test ist damit ein roter Build und kein stilles Loch -- T-7 ist zur Bauzeit
// fail-closed, ohne dass irgendjemand eine Zahl zaehlen muss.
//
// WAS ctest NICHT BEWEIST -- und nur deshalb gibt es diese Datei:
// dass die WACHEN in der Pipeline gerufen werden, mit den RICHTIGEN Argumenten, und
// dass ihre Jobs kein allow_failure tragen.
//
// DIE ZWEI DEFEKTE DER ABGELOESTEN PRUEFUNGEN, BEIDE AM OBJEKT GEMESSEN (09.08.):
//
//  (1) SIE MASS TEXT STATT AUSFUEHRUNG.
//      `grep -cF -- 'sh scripts/ci_xml_wellformed_guard.sh' .gitlab-ci.yml` zaehlt jedes
//      Vorkommen der Zeichenfolge -- auch in einem KOMMENTAR. Ein auskommentierter
//      Aufruf haette die Zusage erfuellt, obwohl die Wache in keinem Job mehr laeuft.
//      Hier zaehlt nur, was in einem Job-Block steht und keine Kommentarzeile ist; die
//      Rohzahl wird als GEGENPROBE danebengestellt.
//
//  (2) DIE allow_failure-WACHE SAH NUR DIE PROBEN-JOBS.
//      Gegengeprueft in beiden Probendateien: der awk-Blockscanner lief ausschliesslich
//      ueber JOB='test:xml-wellformed-probe:' (xml_wellformed_probe.sh:570) und
//      JOB='test:thesis-gitlink-probe:' (thesis_gitlink_parity_probe.sh:534). Die
//      Bloecke, in denen die WACHEN wirklich gerufen werden -- lint:xml-wellformed,
//      verify:submodules, anhang:forward -- wurden NIE geprueft. Ein allow_failure an
//      einem von ihnen haette die scharfe Wache advisory gemacht, ohne dass irgendetwas
//      rot geworden waere. (Verboten seit 06.07.: ZELLE = Warnung, JOB = hart rot.)
//
// DER KOEDER-ZIRKUS ENTFAELLT MIT BEGRUENDUNG. Die abgeloeste Probe schrieb eine
// gewuerfelte Koeder-Datei und zaehlte sie mit demselben grep gegen, weil /usr/bin/grep
// auf dieser Maschine ugrep ist und auf manchen Mustern eine STILLE NULL liefert. Der
// Scanner hier ist eine reine Funktion, die in ihren eigenen Tests mit In-Memory-
// Dokumenten gefahren wird -- die Werkzeug-Ausfallklasse, gegen die der Koeder schuetzte,
// existiert nicht mehr. Was bleibt, ist die GEGENPROBE: jede Nichtfund-Aussage wird von
// einem Fund derselben Funktion begleitet.
//
// TESTKRITIK (T-9): das ist ein strenger Zeilen-Scanner, kein YAML-Parser. YAML-Anker,
// `extends` auf ein verstecktes Template und `include`-Dateien sieht er nicht -- die
// abgeloesten awk-Bloecke sahen sie ebenfalls nicht. Kein Rueckschritt, aber benannt.
//
// ASCII-only, Zeilen <= 120 Byte.
// =============================================================================

#include <algorithm>
#include <filesystem>
#include <optional>
#include <string>
#include <vector>

#include <gmock/gmock.h>
#include <gtest/gtest.h>

#include "comdare/ci_wachen/ci_yml_scanner.hpp"

using comdare::ci_wachen::finde_job_block;
using comdare::ci_wachen::ist_kommentarzeile;
using comdare::ci_wachen::JobBlock;
using comdare::ci_wachen::lies_zeilen;
using comdare::ci_wachen::zaehle_roh;
using comdare::ci_wachen::zaehle_wirksam;
using testing::HasSubstr;

namespace {

// =============================================================================
// TEIL 1 -- DER SCANNER SELBST, an In-Memory-Dokumenten. Kein Werkzeug, keine Datei.
// =============================================================================
std::vector<std::string> doku() {
    return {
        "# Kommentarkopf des ersten Jobs",
        "lint:xml-wellformed:",
        "  stage: lint",
        "  script:",
        "    - ci-xml-wellformed-wache",
        "",
        "# Kommentarkopf des ZWEITEN Jobs -- er traegt ein allow_failure: true im TEXT",
        "test:etwas-anderes:",
        "  allow_failure: true",
        "  script:",
        "    - echo hallo",
    };
}

TEST(CiYmlScanner, BlockEndetAnSpalteNullEinschliesslichKommentaren) {
    // DIESE ZUSICHERUNG WIRD EINGEFROREN: nimmt jemand '#' vom Blockende aus, laeuft der
    // Block in den Kommentarkopf des NAECHSTEN Jobs und meldet dort ein allow_failure,
    // das es im Job nie gab.
    const std::optional<JobBlock> block = finde_job_block(doku(), "lint:xml-wellformed:");
    ASSERT_TRUE(block.has_value());
    EXPECT_EQ(block->erste_zeile, 2u);
    EXPECT_EQ(block->zeilen.size(), 5u) << "Der Block endet an der Leerzeile davor.";
    EXPECT_EQ(zaehle_wirksam(block->zeilen, "allow_failure"), 0u)
        << "Der Block hat das allow_failure des NAECHSTEN Jobs eingesammelt.";
}

TEST(CiYmlScanner, AngehaengtesAllowFailureWirdGEFUNDEN) {
    // Die Gegenrichtung derselben Zusicherung: wird allow_failure IN den Block gehaengt,
    // muss der Scanner es sehen. Ohne diesen Fall waere die Zusicherung oben mit einem
    // Scanner erfuellbar, der schlicht nie etwas findet.
    std::vector<std::string> zeilen = doku();
    zeilen.insert(zeilen.begin() + 5, "  allow_failure: true");
    const std::optional<JobBlock> block = finde_job_block(zeilen, "lint:xml-wellformed:");
    ASSERT_TRUE(block.has_value());
    EXPECT_EQ(zaehle_wirksam(block->zeilen, "allow_failure"), 1u);
}

TEST(CiYmlScanner, AuskommentierterAufrufZAEHLTNICHT) {
    // GENAU DER DEFEKT (1). Der rohe Zaehler findet ihn, der wirksame nicht -- und die
    // Wache haengt am wirksamen.
    const std::vector<std::string> zeilen = {
        "lint:xml-wellformed:",
        "  script:",
        "    # - ci-xml-wellformed-wache   (voruebergehend abgeschaltet)",
    };
    const std::optional<JobBlock> block = finde_job_block(zeilen, "lint:xml-wellformed:");
    ASSERT_TRUE(block.has_value());
    EXPECT_EQ(zaehle_roh(block->zeilen, "ci-xml-wellformed-wache"), 1u) << "Gegenprobe: der Text ist da.";
    EXPECT_EQ(zaehle_wirksam(block->zeilen, "ci-xml-wellformed-wache"), 0u)
        << "Ein auskommentierter Aufruf ist keine Ausfuehrung.";
}

TEST(CiYmlScanner, FehlenderJobIstNulloptNichtEinLeererBlock) {
    // FAIL-CLOSED: "Job weg" und "Job leer" duerfen nicht denselben Wert haben.
    EXPECT_FALSE(finde_job_block(doku(), "gibt:es:nicht:").has_value());
}

TEST(CiYmlScanner, FehlendeDateiIstNulloptNichtEineLeereListe) {
    const std::filesystem::path weg =
        std::filesystem::temp_directory_path() / "comdare_diese_datei_gibt_es_nicht_2026.yml";
    EXPECT_FALSE(lies_zeilen(weg).has_value());
}

TEST(CiYmlScanner, KommentarerkennungAchtetAufEinrueckung) {
    EXPECT_TRUE(ist_kommentarzeile("# ganz links"));
    EXPECT_TRUE(ist_kommentarzeile("    # eingerueckt"));
    EXPECT_TRUE(ist_kommentarzeile("\t# mit Tab"));
    EXPECT_FALSE(ist_kommentarzeile("  - befehl # nachgestellter Kommentar"));
    EXPECT_FALSE(ist_kommentarzeile(""));
}

// =============================================================================
// TEIL 2 -- DIE ECHTE .gitlab-ci.yml.
// =============================================================================
#ifdef COMDARE_CI_YML_PFAD
const std::vector<std::string>& ci_yml() {
    static const std::vector<std::string> zeilen = [] {
        const std::optional<std::vector<std::string>> gelesen = lies_zeilen(COMDARE_CI_YML_PFAD);
        // FAIL-CLOSED: ist die Datei nicht lesbar, bleibt der Vektor leer und JEDE
        // Zusicherung unten faellt -- es gibt kein stilles Gruen.
        return gelesen.value_or(std::vector<std::string>{});
    }();
    return zeilen;
}

TEST(CiYmlAbnahme, DieDateiIstUeberhauptDaUndNichtLeer) {
    ASSERT_FALSE(ci_yml().empty()) << "Konnte " << COMDARE_CI_YML_PFAD << " nicht lesen -- alle "
                                   << "folgenden Abnahmen waeren wertlos.";
    RecordProperty("ci_yml_zeilen", std::to_string(ci_yml().size()));
}

// Die Jobs, die die Wachen rufen. NEU gegenueber der abgeloesten Probe: nicht die
// PROBEN-Jobs stehen hier, sondern die WACHEN-Jobs -- genau die drei, die niemand auf
// allow_failure ansah.
//
// UEBERGANGSSTAND, ausdruecklich benannt: die Aufruf-Literale sind noch die der
// Shell-Fassung. Dieses Paket landet ADDITIV (Bibliothek + Binaries + Tests); ob und
// wann die drei Jobs auf ci-xml-wellformed-wache bzw. ci-thesis-gitlink-wache
// umschwenken, entscheidet der Lead nach der Abnahme -- lint:xml-wellformed haette
// dafuer erstmals einen Bau in der lint-Stufe noetig, das ist keine Nebenwirkung, die
// ein Testpaket im Vorbeigehen ausloest. Beim Schwenk aendert sich in dieser Tabelle
// GENAU EINE Spalte, und dieser Test faellt vorher laut, wenn jemand nur die Haelfte
// umstellt.
struct WachenAufruf {
    const char* job;
    const char* aufruf;             // das Literal, das die Wache wirklich startet
    const char* pflicht_argumente;  // leer = keine Argument-Forderung
};

const std::vector<WachenAufruf>& aufrufstellen() {
    static const std::vector<WachenAufruf> tabelle = {
        {"lint:xml-wellformed:", "scripts/ci_xml_wellformed_guard.sh", ""},
        {"verify:submodules:", "ci/thesis_gitlink_parity.sh", "--quelle head"},
        {"anhang:forward:", "ci/thesis_gitlink_parity.sh", "--quelle index"},
    };
    return tabelle;
}

class WachenAufrufTest : public testing::TestWithParam<WachenAufruf> {};

TEST_P(WachenAufrufTest, WacheWirdGerufenUndDerJobIstHART) {
    const WachenAufruf& stelle = GetParam();
    ASSERT_FALSE(ci_yml().empty());

    const std::optional<JobBlock> block = finde_job_block(ci_yml(), stelle.job);
    ASSERT_TRUE(block.has_value()) << "Job-Block '" << stelle.job << "' fehlt in .gitlab-ci.yml.";

    // (1) DIE WACHE LAEUFT -- wirksam, nicht nur als Text.
    const std::size_t wirksam = zaehle_wirksam(block->zeilen, stelle.aufruf);
    EXPECT_GE(wirksam, 1u) << "Die Wache '" << stelle.aufruf << "' wird im Job '" << stelle.job
                           << "' nicht (mehr) gerufen -- sie liefe in keinem Job (T-7). Rohzaehlung "
                           << "zur Gegenprobe: " << zaehle_roh(block->zeilen, stelle.aufruf);

    // (2) DIE RICHTIGEN ARGUMENTE -- vorher komplett ungedeckt, ausdruecklich als
    //     Luecke in der Testkritik der abgeloesten Probe benannt.
    if (stelle.pflicht_argumente[0] != '\0') {
        EXPECT_GE(zaehle_wirksam(block->zeilen, stelle.pflicht_argumente), 1u)
            << "Job '" << stelle.job << "' ruft die Wache ohne '" << stelle.pflicht_argumente
            << "' -- der Lesepfad der Aufrufstelle waere ein anderer als zugesichert.";
    }

    // (3) KEIN allow_failure -- DAS IST DIE LUECKE, DIE HIER GESCHLOSSEN WIRD.
    EXPECT_EQ(zaehle_wirksam(block->zeilen, "allow_failure"), 0u)
        << "Job '" << stelle.job << "' traegt allow_failure. Eine advisory Wache ist die naechste "
        << "stille Null (verboten seit 06.07.: ZELLE = Warnung, JOB = hart rot).";

    RecordProperty("job_block_zeilen", std::to_string(block->zeilen.size()));
}

INSTANTIATE_TEST_SUITE_P(Wachen, WachenAufrufTest, testing::ValuesIn(aufrufstellen()),
                         [](const testing::TestParamInfo<WachenAufruf>& info) {
                             std::string name(info.param.job);
                             for (char& c : name) {
                                 if (c == ':' || c == '-' || c == '.') c = '_';
                             }
                             while (!name.empty() && name.back() == '_') name.pop_back();
                             return name;
                         });

TEST(CiYmlAbnahme, DieUnitSuiteLaeuftInBEIDENStufenUndOhneAllowFailure) {
    // DER OWNER-KERN, ZUM TEIL DER ABNAHME GEMACHT: "STANDARD GOOGLE TESTS ... UND DIESE
    // IN RELEASE ZU WIEDERHOLEN AUFGRUND VON COMPILE REGRESSIONEN."
    // Die Begruendung ist gemessen: test_ms1 war LOKAL GRUEN (build-xml ohne
    // CMAKE_BUILD_TYPE, also -O0) und fiel in Pipeline 15437, weil der Uebersetzer unter
    // -O3 die Koeder-Allokationen als nicht beobachtbar entfernte. JEDE
    // Beobachtbarkeits-Zusage ist unter -O0 SCHWAECHER als in der CI.
    ASSERT_FALSE(ci_yml().empty());
    for (const char* job : {"test:unit:", "test:unit:debug:"}) {
        const std::optional<JobBlock> block = finde_job_block(ci_yml(), job);
        ASSERT_TRUE(block.has_value())
            << "Job '" << job << "' fehlt -- die Suite liefe nicht in beiden Stufen.";
        EXPECT_EQ(zaehle_wirksam(block->zeilen, "allow_failure"), 0u)
            << "Job '" << job << "' traegt allow_failure.";
    }

    const std::optional<JobBlock> debug = finde_job_block(ci_yml(), "test:unit:debug:");
    ASSERT_TRUE(debug.has_value());
    EXPECT_GE(zaehle_wirksam(debug->zeilen, "--with-build-type=Debug"), 1u)
        << "test:unit:debug baut nicht wirklich Debug -- zwei Jobs mit derselben Stufe "
        << "beweisen keine Compile-Regression.";

    const std::optional<JobBlock> release = finde_job_block(ci_yml(), "test:unit:");
    ASSERT_TRUE(release.has_value());
    EXPECT_GE(zaehle_wirksam(release->zeilen, "--with-build-type=Release"), 1u)
        << "test:unit baut nicht ausdruecklich Release.";
    // Die zwei Baeume muessen getrennt sein, sonst ueberschreibt einer den anderen.
    EXPECT_GE(zaehle_wirksam(debug->zeilen, "Code/build-test-debug"), 1u);
}

#endif  // COMDARE_CI_YML_PFAD

// =============================================================================
// TEIL 3 -- ABSCHRIFT SCHLAEGT LOESCHUNG.
// Die vier Shell-Dateien BLEIBEN im Baum (Doku wird nie geloescht, sie zieht um).
// Solange sie daliegen, muss ihr Kopf sagen, dass sie abgeloest sind und wohin --
// sonst faehrt jemand sie weiter und glaubt ihrem Urteil. Ob sie noch in der CI
// laufen, entscheidet der Lead; diese Zusicherung haengt NICHT daran.
// =============================================================================
#ifdef COMDARE_REPO_WURZEL
struct AbgeloesteDatei {
    const char* pfad;
    const char* verweis;  // der Nachfolger, der im Kopf stehen MUSS
};

const std::vector<AbgeloesteDatei>& abgeloeste_dateien() {
    static const std::vector<AbgeloesteDatei> tabelle = {
        {"scripts/ci_xml_wellformed_guard.sh", "ci_wachen"},
        {"ci/thesis_gitlink_parity.sh", "ci_wachen"},
        {"ci/tests/xml_wellformed_probe.sh", "test_ci_wache_xml_wellformed.cpp"},
        {"ci/tests/thesis_gitlink_parity_probe.sh", "test_ci_wache_gitlink_parity.cpp"},
    };
    return tabelle;
}

class AbgeloestTest : public testing::TestWithParam<AbgeloesteDatei> {};

TEST_P(AbgeloestTest, KopfNenntAbloesungUndNachfolger) {
    const AbgeloesteDatei& datei = GetParam();
    const std::filesystem::path voll = std::filesystem::path(COMDARE_REPO_WURZEL) / datei.pfad;

    const std::optional<std::vector<std::string>> zeilen = lies_zeilen(voll);
    // FAIL-CLOSED: fehlt die Datei, ist das ROT. Sie wurde ausdruecklich NICHT geloescht;
    // verschwindet sie doch, soll es laut sein.
    ASSERT_TRUE(zeilen.has_value()) << "Abgeloeste Datei '" << voll.string() << "' fehlt. Bestand "
                                    << "wird nie geloescht, nur abgeloest.";
    ASSERT_FALSE(zeilen->empty());

    // Nur der Kopf zaehlt: die Kennzeichnung muss lesen, wer die Datei oeffnet.
    const std::size_t kopf = std::min<std::size_t>(zeilen->size(), 40);
    const std::vector<std::string> kopfzeilen(zeilen->begin(), zeilen->begin() + kopf);

    EXPECT_GE(zaehle_roh(kopfzeilen, "ABGELOEST"), 1u)
        << "Der Kopf von '" << datei.pfad << "' sagt nicht, dass die Datei abgeloest ist.";
    EXPECT_GE(zaehle_roh(kopfzeilen, datei.verweis), 1u)
        << "Der Kopf von '" << datei.pfad << "' nennt den Nachfolger '" << datei.verweis
        << "' nicht -- eine Abloesung ohne Verweis ist eine Sackgasse.";

    RecordProperty("datei_zeilen", std::to_string(zeilen->size()));
}

INSTANTIATE_TEST_SUITE_P(AbschriftStattLoeschung, AbgeloestTest,
                         testing::ValuesIn(abgeloeste_dateien()),
                         [](const testing::TestParamInfo<AbgeloesteDatei>& info) {
                             std::string name(info.param.pfad);
                             for (char& c : name) {
                                 if (c == '/' || c == '.' || c == '-') c = '_';
                             }
                             return name;
                         });

TEST(AbschriftStattLoeschung, DerNennerStehtDabei) {
    // Eine Zahl ohne Grundgesamtheit ist keine Aussage.
    EXPECT_EQ(abgeloeste_dateien().size(), 4u)
        << "Vier Shell-Dateien werden abgeloest: 2 Wachen + 2 Proben.";
}
#endif  // COMDARE_REPO_WURZEL

}  // namespace
