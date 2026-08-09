// test_ci_wache_xml_wellformed.cpp -- die XML-Wohlgeformtheits-Wache als Pruefling.
//                                                                        (2026-08-09)
// =============================================================================
// LOEST AB (nicht: loescht): ci/tests/xml_wellformed_probe.sh (732 Zeilen, F1-F12,
// M1-M5). Die Datei bleibt im Baum und traegt einen Verweis hierher.
//
// WARUM SIE ABGELOEST WIRD -- am Objekt gemessen, 09.08.2026:
// Ihr Selbstbiss-Orakel (Zeilen 688-701) zaehlte JEDEN Rueckgabewert ausser 0 und 2 als
// Biss. Ein `tr`-Shim, der schlicht mit 127 endet, liess damit ALLE FUENF Mutanten als
// "wird gefangen (Probe rc=127)" durchgehen -- GESAMT rc=0, "SELBSTBISS GRUEN", und
// KEIN EINZIGER MUTANT war angesehen worden. Die "Literale Ausgabe:"-Zeilen der fuenf
// Faenge waren LEER, weil das Orakel die Riss-Literale gar nicht forderte.
// Vier weitere Defekte derselben Bauart: die Registrierungs-Pruefung mass TEXT statt
// Ausfuehrung; die allow_failure-Wache sah nur die Proben-Jobs, nie die Wachen-Jobs;
// das Orakel war nicht fail-closed (od-Shim mit leerer Ausgabe -> 12/12 GRUEN);
// F11-F13 zaehlten fail-open (`N=$(grep -cF ... || true)`, und `[ "$N" = "0" ]` ist
// fuer LEER falsch).
//
// -----------------------------------------------------------------------------
// DIE DREI ZUSTAENDE SIND HIER STRUKTURELL GETRENNT -- das ist der ganze Umbau.
// -----------------------------------------------------------------------------
// (a) DIE WACHE GREIFT: jeder Fall fordert DREI Ebenen, nie nur eine.
//       KLASSE  EXPECT_EQ(status, ...)          -- Gruen / Riss / Abbruch
//       ZWEIG   EXPECT_EQ(befund.art, ...)      -- in Shell UNMOEGLICH, rc kollidierte
//       LITERAL EXPECT_THAT(protokoll, HasSubstr(...)) -- Pflichtfeld der Fall-Tabelle
//     Ein Fall OHNE Literal-Forderung faellt an der Tabellenform auf; ein leeres
//     Literal-Feld ist ein eigener roter Test (FallTabelleFordertLiterale).
//
// (b) DER MUTANT UEBERLEBT -> ROT. Zweistufig:
//     Stufe 1, COMPILE-ZEIT: der Shell-Mutant "ein exit faellt heraus -> Fall-through"
//       hat hier kein Analogon. Jede Verzweigung RETURNT ein Ergebnis; ein entferntes
//       return ist mit -Werror=return-type ein BAU-Fehler, ein vergessener enum-Fall
//       mit -Werror=switch ebenso (beide auf comdare_ci_wachen gesetzt). Der
//       Vollstaendigkeitstest unten fordert zusaetzlich, dass JEDER Wert von
//       XmlBefundArt und XmlAbbruchGrund mindestens einmal als SOLL vorkommt.
//     Stufe 2, JE LAUF: die Selbstbiss-Suite setzt den Forderungs-Helfern GEFAELSCHTE
//       Ergebnisse vor -- die fuenf Mutanten-Klassen von damals, auf den Ergebnistyp
//       abgebildet -- und beweist mit EXPECT_NONFATAL_FAILURE, dass GENAU EINE
//       Assertion mit GENAU DIESEM Text faellt. Die Helfer sind DIESELBEN, die die
//       echten Faelle benutzen; sonst bewiese der Selbstbiss etwas ueber eine andere
//       Funktion.
//
// (c) DAS WERKZEUG IST KAPUTT -> ROT, NIEMALS "GEFANGEN". Der 127-Defekt ist
//     unrepraesentierbar gemacht: die Prozess-Naht liefert Exit / Signal /
//     ExecFehlgeschlagen als eigene Arten, und exit_code() gibt NUR bei Exit einen
//     Wert. Fixture-Schritte sind AssertionResult -- ein misslungenes Arrangement ist
//     ein roter Fall mit Diagnose, nie ein stilles Gruen. Es gibt keinen rc-Eimer mehr,
//     in den ein Werkzeugausfall fallen koennte.
//
// -----------------------------------------------------------------------------
// TESTKRITIK (T-9) -- WAS DIESE SUITE NICHT DECKT. Gemessen, nicht geschaetzt: der
// Mutations-Lauf vom 09.08. fuhr 12 Mutanten gegen die Suite, 11 starben, EINER
// UEBERLEBTE -- und genau der hat diese Liste erzeugt.
//   * ProzessArt::Signal entsteht nirgends WIRKLICH. Der ueberlebende Mutant
//     veraenderte den Signal-Text der Beschreibung; seitdem deckt
//     ProzessNaht.JedeProzessArtHatEineEIGENEUnterscheidbareBeschreibung den Zweig --
//     aber auf der Formatier-Ebene. Ein Kindprozess, der wirklich an einem Signal
//     stirbt, wird nicht erzeugt. Benannt statt zugedeckt.
//   * xmllint selbst wird als Urteil vertraut (wie zuvor). Faellt libxml2 auf eine
//     Fassung zurueck, die "--" im Kommentar durchlaesst, faellt F02 -- als Fehler der
//     Wache, obwohl das Werkzeug schuld waere.
//   * Submodule: die Wache steigt bewusst nicht hinein (das ce lintet seinen Bestand in
//     SEINER Pipeline). Ein Submodul-Fixture wird nicht gebaut, die Zusage nicht belegt.
//   * Der Mutations-Katalog ist NICHT erschoepfend. Er ist ein Beweis je Zweig, keine
//     Score. Das gehoert spaeter zu mull, periodisch, nie als CI-Gate.
//   * Die drei CI-Aufrufstellen rufen weiterhin die SHELL-Fassung; dieses Paket landet
//     additiv. Der Schwenk braucht erstmals einen Bau in der lint-Stufe und ist deshalb
//     ausdruecklich Lead-Entscheid, kein Nebeneffekt eines Testpakets.
// -----------------------------------------------------------------------------
//
// ORAKEL (T-5 / K13): kein Fall schreibt eine Zahl ab. Anzahl guter und kaputter
// Dateien und jeder Token werden je Lauf gewuerfelt und WOERTLICH zurueckgefordert; der
// Seed steht per RecordProperty im Protokoll. Der NENNER kommt damit aus einer ANDEREN
// Quelle als dem Pruefling (T-3): der Test WEISS, wie viele Dateien er angelegt hat.
//
// ASCII-only, Zeilen <= 120 Byte.
// =============================================================================

#include <algorithm>
#include <filesystem>
#include <optional>
#include <set>
#include <string>
#include <vector>

#include <gmock/gmock.h>
#include <gtest/gtest-spi.h>
#include <gtest/gtest.h>

#include "comdare/ci_wachen/git_quelle.hpp"
#include "comdare/ci_wachen/prozess.hpp"
#include "comdare/ci_wachen/werkbank.hpp"
#include "comdare/ci_wachen/xml_parser.hpp"
#include "comdare/ci_wachen/xml_wellformed.hpp"

using comdare::ci_wachen::EchteGitQuelle;
using comdare::ci_wachen::exit_code;
using comdare::ci_wachen::ProzessArt;
using comdare::ci_wachen::ProzessAuftrag;
using comdare::ci_wachen::ProzessAusgang;
using comdare::ci_wachen::pruefe_xml_bestand;
using comdare::ci_wachen::WacheStatus;
using comdare::ci_wachen::XmlAbbruchGrund;
using comdare::ci_wachen::XmlBefundArt;
using comdare::ci_wachen::XmllintParser;
using comdare::ci_wachen::XmlUrteilArt;
using comdare::ci_wachen::XmlWacheErgebnis;
using comdare::ci_wachen::werkbank::FakeGitQuelle;
using comdare::ci_wachen::werkbank::FakeXmlParser;
using comdare::ci_wachen::werkbank::FixtureRepo;
using comdare::ci_wachen::werkbank::Wuerfel;
using testing::HasSubstr;

namespace {

// =============================================================================
// DIE FORDERUNGS-HELFER. JEDER ERZEUGT GENAU EINE ASSERTION.
// Das ist die Vorbedingung von EXPECT_NONFATAL_FAILURE -- und zugleich der Grund,
// warum der Selbstbiss unten wirklich etwas ueber DIESE Faelle beweist: die echten
// Faelle rufen keine anderen Funktionen.
// =============================================================================
void fordere_status(const XmlWacheErgebnis& ist, WacheStatus soll) {
    EXPECT_EQ(ist.status, soll) << "Protokoll:\n" << ist.protokoll();
}

void fordere_abbruch(const XmlWacheErgebnis& ist, XmlAbbruchGrund soll) {
    EXPECT_EQ(ist.abbruch, std::optional<XmlAbbruchGrund>{soll}) << "Protokoll:\n" << ist.protokoll();
}

void fordere_kein_abbruch(const XmlWacheErgebnis& ist) {
    EXPECT_EQ(ist.abbruch, std::optional<XmlAbbruchGrund>{}) << "Protokoll:\n" << ist.protokoll();
}

void fordere_riss_zahl(const XmlWacheErgebnis& ist, std::size_t soll) {
    EXPECT_EQ(ist.risse.size(), soll) << "Protokoll:\n" << ist.protokoll();
}

std::optional<XmlBefundArt> art_bei(const XmlWacheErgebnis& ist, std::size_t i) {
    if (i >= ist.risse.size()) return std::nullopt;
    return ist.risse[i].art;
}

void fordere_befund_art(const XmlWacheErgebnis& ist, std::size_t i, XmlBefundArt soll) {
    EXPECT_EQ(art_bei(ist, i), std::optional<XmlBefundArt>{soll}) << "Protokoll:\n" << ist.protokoll();
}

void fordere_nenner(const XmlWacheErgebnis& ist, int soll) {
    EXPECT_EQ(ist.nenner, soll) << "Protokoll:\n" << ist.protokoll();
}

void fordere_literal(const XmlWacheErgebnis& ist, const std::string& literal) {
    EXPECT_THAT(ist.protokoll(), HasSubstr(literal));
}

void fordere_kein_literal(const XmlWacheErgebnis& ist, const std::string& literal) {
    EXPECT_THAT(ist.protokoll(), testing::Not(HasSubstr(literal)));
}

// =============================================================================
// DIE FALL-TABELLE.
// =============================================================================
enum class KaputtArt { Doppelbindestrich, Namensraum };

struct XmlBauplan {
    bool git_init = true;
    int gute_min = 0;
    int gute_max = 0;
    int kaputte_min = 0;
    int kaputte_max = 0;
    KaputtArt kaputt_art = KaputtArt::Doppelbindestrich;
    bool tief = false;                  // Dateien in Unterverzeichnissen
    int ungetrackt_kaputt = 0;          // kaputte XML, die NICHT verfolgt werden
    bool eine_geloescht = false;        // im Index, im Arbeitsbaum weg (sparse checkout)
    bool zeilenende_im_namen = false;   // der Positiv-Fall, der den toten Zweig ersetzt
    bool doctype = false;               // DOCTYPE + Einzelbindestrich
};

struct XmlFall {
    const char* name;
    XmlBauplan bauplan;
    WacheStatus soll_status;
    std::optional<XmlAbbruchGrund> soll_abbruch;
    std::optional<XmlBefundArt> soll_befund_art;  // Art JEDES erwarteten Risses
    std::vector<std::string> soll_literale;       // PFLICHT: mindestens eines
    std::vector<std::string> verbotene_literale;
};

// Die Namen werden zu ctest-Zeilen (gtest_discover_tests) -- `ctest -N` liest sich
// deshalb wie das Protokoll der abgeloesten Probe.
const std::vector<XmlFall>& xml_faelle() {
    static const std::vector<XmlFall> tabelle = {
        {"F01_gewuerfelt_alle_gut",
         XmlBauplan{.gute_min = 2, .gute_max = 6},
         WacheStatus::Gruen, std::nullopt, std::nullopt,
         {"alle wohlgeformt", "NENNER (nie eine nackte Null):"},
         {"FAILED --", "FALSE-GREEN"}},

        {"F02_doppelbindestrich_im_kommentar",
         XmlBauplan{.gute_min = 1, .gute_max = 3, .kaputte_min = 1, .kaputte_max = 3},
         WacheStatus::Riss, std::nullopt, XmlBefundArt::ParserFehler,
         {"FAILED --", "Double hyphen within comment", "NICHT WOHLGEFORMTE DATEIEN:"},
         {"alle wohlgeformt"}},

        {"F03_gemischt_in_unterverzeichnissen",
         XmlBauplan{.gute_min = 2, .gute_max = 4, .kaputte_min = 1, .kaputte_max = 2, .tief = true},
         WacheStatus::Riss, std::nullopt, XmlBefundArt::ParserFehler,
         {"FAILED --", "Double hyphen within comment"},
         {"alle wohlgeformt"}},

        {"F04_null_getrackte_xml_ist_ABBRUCH_kein_gruen",
         XmlBauplan{},
         WacheStatus::Abbruch, XmlAbbruchGrund::NullDateien, std::nullopt,
         {"NULL getrackte *.xml gefunden", "Ein leerer Nenner ist kein bestandener Lauf"},
         {"alle wohlgeformt", "OK ("}},

        {"F05_kein_git_arbeitsbaum_ist_ABBRUCH",
         XmlBauplan{.git_init = false},
         WacheStatus::Abbruch, XmlAbbruchGrund::KeinGitBaum, std::nullopt,
         {"kein git-Arbeitsbaum", "also auch kein Gruen"},
         {"alle wohlgeformt"}},

        {"F07_namensraum_fehler_rc0_aber_diagnose_FALSE_GREEN",
         XmlBauplan{.gute_min = 1, .gute_max = 2, .kaputte_min = 1, .kaputte_max = 2,
                    .kaputt_art = KaputtArt::Namensraum},
         WacheStatus::Riss, std::nullopt, XmlBefundArt::DiagnoseTrotzErfolg,
         {"FALSE-GREEN", "is not defined", "FAILED --"},
         {"alle wohlgeformt"}},

        {"F08_ungetrackt_kaputt_bleibt_gruen",
         XmlBauplan{.gute_min = 1, .gute_max = 3, .ungetrackt_kaputt = 1},
         WacheStatus::Gruen, std::nullopt, std::nullopt,
         {"alle wohlgeformt"},
         {"FAILED --", "ungetrackt_kaputt"}},

        {"F09_eingefroren_index_aber_nicht_im_arbeitsbaum",
         XmlBauplan{.gute_min = 1, .gute_max = 1, .eine_geloescht = true},
         WacheStatus::Gruen, std::nullopt, std::nullopt,
         {"gezaehlt, NICHT gelesen", "alle wohlgeformt"},
         {"FAILED --"}},

        {"F10_doctype_mit_einzelbindestrich_ist_gruen",
         XmlBauplan{.gute_min = 1, .gute_max = 2, .doctype = true},
         WacheStatus::Gruen, std::nullopt, std::nullopt,
         {"alle wohlgeformt"},
         {"FAILED --", "FALSE-GREEN"}},

        // NEU: der ehemals TOTE Nenner-Mismatch-Zweig wird zum POSITIV-FALL.
        // Die Shell-Wache brach hier ab, weil sie zwei Aufzaehlungen gegeneinander
        // hielt; gemessen konnten die beiden Zaehler nie divergieren (git C-quotet
        // Steuerzeichen im Nicht-`-z`-Weg immer). Hier wird nur `-z` gelesen, und ein
        // Dateiname MIT Zeilenende ist damit ein Fall, der FUNKTIONIERT.
        {"F11neu_dateiname_mit_zeilenende_wird_korrekt_gezaehlt",
         XmlBauplan{.gute_min = 1, .gute_max = 2, .kaputte_min = 1, .kaputte_max = 1,
                    .zeilenende_im_namen = true},
         WacheStatus::Riss, std::nullopt, XmlBefundArt::ParserFehler,
         {"FAILED --", "Double hyphen within comment"},
         {"Nenner nicht vertrauenswuerdig"}},
    };
    return tabelle;
}

struct XmlAufbau {
    int nenner_soll = 0;   // aus dem WUERFEL, nicht aus dem Pruefling (T-3)
    int kaputte_soll = 0;
    std::vector<std::string> tokens_kaputt;
};

class XmlWacheFall : public testing::TestWithParam<XmlFall> {};

// Baut das Fixture und liefert die Erwartung. JEDE Gegenprobe ist ein ASSERT --
// misslingt das Arrangement, ist der EINE Fall rot, mit Diagnose.
void baue(FixtureRepo& repo, Wuerfel& wuerfel, const XmlBauplan& plan, XmlAufbau& aufbau) {
    if (!plan.git_init) return;
    ASSERT_TRUE(repo.init());

    const int gute = (plan.gute_max > 0) ? wuerfel.zahl(plan.gute_min, plan.gute_max) : 0;
    const int kaputte = (plan.kaputte_max > 0) ? wuerfel.zahl(plan.kaputte_min, plan.kaputte_max) : 0;

    for (int i = 0; i < gute; ++i) {
        const std::string token = wuerfel.token();
        const std::string unter = plan.tief ? ("tief" + std::to_string(i) + "/") : std::string();
        const std::string name = unter + "gut_" + token + ".xml";
        const std::string inhalt = plan.doctype
                                       ? comdare::ci_wachen::werkbank::xml_doctype_einzelbindestrich(token)
                                       : comdare::ci_wachen::werkbank::xml_wohlgeformt(token);
        ASSERT_TRUE(repo.schreibe_und_verfolge(name, inhalt));
        ASSERT_TRUE(repo.ist_verfolgt(name));  // Gegenprobe: sie liegt WIRKLICH im Index
    }

    for (int i = 0; i < kaputte; ++i) {
        const std::string token = wuerfel.token();
        aufbau.tokens_kaputt.push_back(token);
        std::string name;
        if (plan.zeilenende_im_namen && i == 0) {
            // Der Positiv-Fall: ein Dateiname MIT Zeilenende.
            name = std::string("kaputt_") + token + "\nzweite_zeile.xml";
        } else {
            const std::string unter = plan.tief ? ("tief_k" + std::to_string(i) + "/") : std::string();
            name = unter + "kaputt_" + token + ".xml";
        }
        const std::string inhalt = (plan.kaputt_art == KaputtArt::Namensraum)
                                       ? comdare::ci_wachen::werkbank::xml_namensraum_fehler(token)
                                       : comdare::ci_wachen::werkbank::xml_doppelbindestrich(token);
        ASSERT_TRUE(repo.schreibe_und_verfolge(name, inhalt));
        ASSERT_TRUE(repo.ist_verfolgt(name));
    }

    for (int i = 0; i < plan.ungetrackt_kaputt; ++i) {
        const std::string token = wuerfel.token();
        const std::string name = "ungetrackt_" + token + ".xml";
        ASSERT_TRUE(repo.schreibe(name, comdare::ci_wachen::werkbank::xml_doppelbindestrich(token)));
        // Gegenprobe: sie ist WIRKLICH ungetrackt -- sonst pruefte der Fall das Gegenteil.
        ASSERT_TRUE(repo.ist_nicht_verfolgt(name));
    }

    aufbau.nenner_soll = gute + kaputte;
    aufbau.kaputte_soll = kaputte;

    if (plan.eine_geloescht) {
        const std::string token = wuerfel.token();
        const std::string name = "nur_im_index_" + token + ".xml";
        ASSERT_TRUE(repo.schreibe_und_verfolge(name, comdare::ci_wachen::werkbank::xml_wohlgeformt(token)));
        ASSERT_TRUE(repo.ist_verfolgt(name));
        ASSERT_TRUE(repo.loesche_aus_arbeitsbaum(name));
        ASSERT_FALSE(std::filesystem::exists(repo.pfad() / name));  // Gegenprobe
        aufbau.nenner_soll += 1;
    }
}

TEST_P(XmlWacheFall, Fall) {
    const XmlFall& fall = GetParam();

    // T-4-RIEGEL: ein Fall ohne Literal-Forderung ist kein Fall. Die leeren
    // "Literale Ausgabe:"-Zeilen der abgeloesten Probe sind damit unmoeglich.
    ASSERT_FALSE(fall.soll_literale.empty())
        << "Fall '" << fall.name << "' fordert kein Literal -- 'irgendwas ist gebrochen' genuegt nicht.";

    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));

    FixtureRepo repo;
    XmlAufbau aufbau;
    ASSERT_NO_FATAL_FAILURE(baue(repo, wuerfel, fall.bauplan, aufbau));

    const EchteGitQuelle git{repo.pfad()};
    const XmllintParser parser;

    // FAIL-CLOSED: fehlt xmllint auf dieser Maschine, ist das ein ausdrueckliches SKIP
    // mit Grund -- niemals ein stilles Gruen und niemals ein Fall, der "gefangen" meldet.
    {
        ProzessAuftrag probe;
        probe.argv = {"xmllint", "--version"};
        const ProzessAusgang ausgang = comdare::ci_wachen::fuehre_aus(probe);
        if (ausgang.art == ProzessArt::ExecFehlgeschlagen) {
            GTEST_SKIP() << "SKIP MIT GRUND: xmllint laeuft auf dieser Maschine nicht ("
                         << ausgang.beschreibung() << "). Der Fall wird NICHT als bestanden gezaehlt.";
        }
    }

    const XmlWacheErgebnis ergebnis = pruefe_xml_bestand(git, parser);

    // (1) KLASSE
    fordere_status(ergebnis, fall.soll_status);

    // (2) ZWEIG -- in der Shell-Fassung strukturell unmoeglich: rc kollidierte.
    if (fall.soll_abbruch.has_value()) {
        fordere_abbruch(ergebnis, *fall.soll_abbruch);
    } else {
        fordere_kein_abbruch(ergebnis);
        fordere_nenner(ergebnis, aufbau.nenner_soll);  // Nenner aus dem Wuerfel (T-3)
        fordere_riss_zahl(ergebnis, static_cast<std::size_t>(aufbau.kaputte_soll));
        if (fall.soll_befund_art.has_value()) {
            for (std::size_t i = 0; i < ergebnis.risse.size(); ++i) {
                fordere_befund_art(ergebnis, i, *fall.soll_befund_art);
            }
        }
    }

    // (3) LITERAL -- Pflicht.
    for (const std::string& literal : fall.soll_literale) fordere_literal(ergebnis, literal);
    for (const std::string& literal : fall.verbotene_literale) fordere_kein_literal(ergebnis, literal);

    // (4) DER GEWUERFELTE KOEDER MUSS WOERTLICH ZURUECKKOMMEN (K13): jeder kaputte
    //     Dateiname traegt seinen Token, und der Token steht im Protokoll. Eine Wache,
    //     die eine feste Zahl oder einen festen Namen faelscht, faellt hier.
    if (fall.soll_status == WacheStatus::Riss) {
        for (const std::string& token : aufbau.tokens_kaputt) fordere_literal(ergebnis, token);
    }

    if (fall.bauplan.eine_geloescht) {
        EXPECT_EQ(ergebnis.nicht_gelesen, 1) << "Protokoll:\n" << ergebnis.protokoll();
    }
}

INSTANTIATE_TEST_SUITE_P(XmlWache, XmlWacheFall, testing::ValuesIn(xml_faelle()),
                         [](const testing::TestParamInfo<XmlFall>& info) {
                             return std::string(info.param.name);
                         });

// =============================================================================
// DIE NAHT-FAELLE: Zweige, die die abgeloeste Probe EHRLICH ALS UNGEDECKT MELDEN
// MUSSTE, weil sie ohne root bzw. ohne Selbstverstuemmelung nicht erreichbar waren.
// Mit den Fakes sind es gewoehnliche Faelle.
// =============================================================================
TEST(XmlWacheNaht, F06_ParserFehltIstAbbruchNiemalsGruen) {
    FakeGitQuelle git;
    git.bestand.werkzeug_ok = true;
    git.bestand.pfade = {"a.xml", "b.xml"};
    git.wurzel = std::filesystem::temp_directory_path();

    // Damit die Wache ueberhaupt bis zum Parser kommt, muessen die Dateien existieren.
    FixtureRepo repo;
    ASSERT_TRUE(repo.init());
    ASSERT_TRUE(repo.schreibe("a.xml", "<r/>\n"));
    ASSERT_TRUE(repo.schreibe("b.xml", "<r/>\n"));
    git.wurzel = repo.pfad();

    FakeXmlParser parser;
    parser.vorgabe.art = XmlUrteilArt::ParserNichtVerfuegbar;
    parser.vorgabe.werkzeug_diagnose = "xmllint: ExecFehlgeschlagen bei Ausfuehrung (errno 2)";

    const XmlWacheErgebnis ergebnis = pruefe_xml_bestand(git, parser);

    fordere_status(ergebnis, WacheStatus::Abbruch);
    fordere_abbruch(ergebnis, XmlAbbruchGrund::ParserFehlt);
    fordere_literal(ergebnis, "wurde im PATH NICHT gefunden");
    fordere_literal(ergebnis, "libxml2-utils");
    fordere_kein_literal(ergebnis, "alle wohlgeformt");
}

TEST(XmlWacheNaht, GitFehlerIstNichtNullDateien) {
    // Die Shell-Fassung konnte beides nur ueber denselben rc=2 melden. Hier sind es
    // zwei Werte -- und genau das macht den Unterschied zwischen "die Aufzaehlung
    // greift nicht" und "git ist kaputt" beobachtbar.
    FakeGitQuelle git;
    git.bestand.werkzeug_ok = false;
    git.bestand.diagnose = "git: Exit(128) | stderr: fatal: not a git repository";

    FakeXmlParser parser;
    const XmlWacheErgebnis ergebnis = pruefe_xml_bestand(git, parser);

    fordere_status(ergebnis, WacheStatus::Abbruch);
    fordere_abbruch(ergebnis, XmlAbbruchGrund::GitFehlgeschlagen);
    fordere_literal(ergebnis, "Ein git-Fehler ist NICHT 'null Dateien'");
    EXPECT_EQ(parser.aufrufe, 0) << "Der Parser darf nach einem git-Fehler gar nicht erst laufen.";
}

TEST(XmlWacheNaht, NennerKommtAusDerAufzaehlungNichtAusDenGelesenenDateien) {
    // T-3: der Nenner ist die GRUNDGESAMTHEIT, nicht die Zahl der geoeffneten Dateien.
    // Genau diese Verwechslung ist der eingefrorene F9-Defekt.
    FakeGitQuelle git;
    git.bestand.werkzeug_ok = true;
    git.bestand.pfade = {"gibt_es_nicht_1.xml", "gibt_es_nicht_2.xml", "gibt_es_nicht_3.xml"};
    git.wurzel = std::filesystem::temp_directory_path() / "comdare_gibt_es_sicher_nicht";

    FakeXmlParser parser;
    const XmlWacheErgebnis ergebnis = pruefe_xml_bestand(git, parser);

    fordere_status(ergebnis, WacheStatus::Gruen);
    fordere_nenner(ergebnis, 3);
    EXPECT_EQ(ergebnis.nicht_gelesen, 3);
    EXPECT_EQ(parser.aufrufe, 0);
    // DIE ZAHL STEHT JETZT IM PROTOKOLL. Die Shell-Fassung meldete an dieser Stelle
    // "3 XML-Dateien geprueft, alle wohlgeformt", obwohl sie NULL gelesen hatte.
    fordere_literal(ergebnis, "davon 3 im Index, aber nicht im Arbeitsbaum (gezaehlt, NICHT gelesen)");
}

// =============================================================================
// STUFE 1 DES MUTATIONS-BEWEISES: VOLLSTAENDIGKEIT.
// Jeder Wert der beiden Aufzaehlungen muss mindestens einmal als SOLL vorkommen --
// sonst gibt es einen Zweig, den keine Fall-Tabelle je fordert.
// =============================================================================
TEST(XmlWacheVollstaendigkeit, JederAbbruchGrundKommtAlsSollVor) {
    std::set<XmlAbbruchGrund> gefordert;
    for (const XmlFall& fall : xml_faelle()) {
        if (fall.soll_abbruch.has_value()) gefordert.insert(*fall.soll_abbruch);
    }
    // Die zwei Naht-Faelle oben fordern die restlichen beiden Gruende. Sie stehen als
    // eigene TESTs (sie brauchen Fakes) und werden hier NAMENTLICH mitgezaehlt --
    // eine Abschrift, die bricht, sobald einer der Tests verschwindet: der
    // Nichtfund unten meldet den fehlenden Grund.
    gefordert.insert(XmlAbbruchGrund::ParserFehlt);        // XmlWacheNaht.F06_...
    gefordert.insert(XmlAbbruchGrund::GitFehlgeschlagen);  // XmlWacheNaht.GitFehler...

    for (const XmlAbbruchGrund grund : comdare::ci_wachen::alle_xml_abbruch_gruende) {
        EXPECT_TRUE(gefordert.count(grund) == 1)
            << "Kein Fall fordert den Abbruch-Grund '" << grund << "' -- dieser Zweig ist ungedeckt.";
    }
    EXPECT_EQ(gefordert.size(), std::size(comdare::ci_wachen::alle_xml_abbruch_gruende));
}

TEST(XmlWacheVollstaendigkeit, JedeBefundArtKommtAlsSollVor) {
    std::set<XmlBefundArt> gefordert;
    for (const XmlFall& fall : xml_faelle()) {
        if (fall.soll_befund_art.has_value()) gefordert.insert(*fall.soll_befund_art);
    }
    for (const XmlBefundArt art : comdare::ci_wachen::alle_xml_befund_arten) {
        EXPECT_TRUE(gefordert.count(art) == 1)
            << "Kein Fall fordert die Befund-Art '" << art << "' -- dieser Zweig ist ungedeckt.";
    }
    EXPECT_EQ(gefordert.size(), std::size(comdare::ci_wachen::alle_xml_befund_arten));
}

TEST(XmlWacheVollstaendigkeit, FallTabelleFordertLiteraleUndIstNichtLeer) {
    ASSERT_FALSE(xml_faelle().empty());
    for (const XmlFall& fall : xml_faelle()) {
        EXPECT_FALSE(fall.soll_literale.empty()) << "Fall '" << fall.name << "' ohne Literal-Forderung.";
        for (const std::string& literal : fall.soll_literale) {
            EXPECT_FALSE(literal.empty()) << "Fall '" << fall.name << "' fordert ein LEERES Literal.";
        }
    }
}

// =============================================================================
// STUFE 2 DES MUTATIONS-BEWEISES: DER SELBSTBISS, JE LAUF, IM SELBEN BINARY.
//
// Die fuenf Mutanten der abgeloesten Probe, auf den Ergebnistyp abgebildet. Jeder
// Faelschung wird EIN Forderungs-Helfer vorgesetzt, und EXPECT_NONFATAL_FAILURE
// beweist, dass GENAU EINE Assertion mit GENAU DIESEM Text faellt.
//
// gtest-spi-Randbedingung beachtet: das Statement referenziert keine lokalen
// non-static Variablen -- die Faelschungen sind Funktionen im namespace-Scope.
//
// EXPECT_NONFATAL_FAILURE IST SELBST FAIL-CLOSED: null Fehlschlaege oder falscher Text
// -> der spi-Fall faellt. Der Heartbeat "ein Fehlschlag kommt als Fehlschlag an" laeuft
// damit in JEDEM Lauf mit -- genau das, was der 127-Defekt zerstoert hatte.
// =============================================================================
XmlWacheErgebnis faelschung_m1_kein_git_zweig_entfernt() {
    // M1: aus dem "kein git-Arbeitsbaum"-Zweig faellt der Ausstieg heraus -> die Wache
    // meldet Gruen statt Abbruch.
    XmlWacheErgebnis ist;
    ist.status = WacheStatus::Gruen;
    ist.nenner = 7;
    return ist;
}

XmlWacheErgebnis faelschung_m3_null_xml_zweig_entfernt() {
    // M3: der NULL-Dateien-Ausstieg faellt heraus -> Gruen bei Nenner 0.
    XmlWacheErgebnis ist;
    ist.status = WacheStatus::Gruen;
    ist.nenner = 0;
    return ist;
}

XmlWacheErgebnis faelschung_m4_failed_zweig_entfernt() {
    // M4: der FAILED-Ausstieg faellt heraus -> Gruen, obwohl Risse vorliegen.
    XmlWacheErgebnis ist;
    ist.status = WacheStatus::Gruen;
    ist.nenner = 3;
    ist.risse.push_back({"kaputt.xml", XmlBefundArt::ParserFehler, {"Double hyphen within comment"}});
    return ist;
}

XmlWacheErgebnis faelschung_m5_stderr_riegel_entfernt() {
    // M5: der Riegel faellt heraus -> die Namensraum-Datei wird gar nicht erst zum
    // Befund. Die Faelschung traegt den Riss deshalb NICHT.
    XmlWacheErgebnis ist;
    ist.status = WacheStatus::Gruen;
    ist.nenner = 2;
    return ist;
}

XmlWacheErgebnis faelschung_m6_falsche_befund_art() {
    // M6 (neu, in der Shell nicht formulierbar): der Zweig feuert, aber mit der
    // FALSCHEN Art. In der rc-Domaene war das unsichtbar -- beide lieferten rc=1.
    XmlWacheErgebnis ist;
    ist.status = WacheStatus::Riss;
    ist.nenner = 2;
    ist.risse.push_back({"ns.xml", XmlBefundArt::ParserFehler, {"is not defined"}});
    return ist;
}

TEST(XmlWacheSelbstbiss, M1_StatusForderungFaelltAmKeinGitBaumMutanten) {
    EXPECT_NONFATAL_FAILURE(
        fordere_status(faelschung_m1_kein_git_zweig_entfernt(), WacheStatus::Abbruch), "ABBRUCH");
}

TEST(XmlWacheSelbstbiss, M1_LiteralForderungFaelltAmKeinGitBaumMutanten) {
    EXPECT_NONFATAL_FAILURE(
        fordere_literal(faelschung_m1_kein_git_zweig_entfernt(), "kein git-Arbeitsbaum"),
        "kein git-Arbeitsbaum");
}

TEST(XmlWacheSelbstbiss, M1_AbbruchGrundForderungFaelltAmKeinGitBaumMutanten) {
    EXPECT_NONFATAL_FAILURE(
        fordere_abbruch(faelschung_m1_kein_git_zweig_entfernt(), XmlAbbruchGrund::KeinGitBaum),
        "KeinGitBaum");
}

TEST(XmlWacheSelbstbiss, M3_NullDateienMutantWirdGetoetet) {
    EXPECT_NONFATAL_FAILURE(
        fordere_abbruch(faelschung_m3_null_xml_zweig_entfernt(), XmlAbbruchGrund::NullDateien),
        "NullDateien");
}

TEST(XmlWacheSelbstbiss, M3_LiteralNullGetrackteFehltAmMutanten) {
    EXPECT_NONFATAL_FAILURE(
        fordere_literal(faelschung_m3_null_xml_zweig_entfernt(), "NULL getrackte *.xml gefunden"),
        "NULL getrackte");
}

TEST(XmlWacheSelbstbiss, M4_FailedZweigMutantWirdGetoetet) {
    EXPECT_NONFATAL_FAILURE(fordere_status(faelschung_m4_failed_zweig_entfernt(), WacheStatus::Riss),
                            "RISS");
}

TEST(XmlWacheSelbstbiss, M4_LiteralFAILEDFehltAmMutanten) {
    EXPECT_NONFATAL_FAILURE(fordere_literal(faelschung_m4_failed_zweig_entfernt(), "FAILED --"),
                            "FAILED --");
}

TEST(XmlWacheSelbstbiss, M5_StderrRiegelMutantWirdGetoetet) {
    EXPECT_NONFATAL_FAILURE(
        fordere_befund_art(faelschung_m5_stderr_riegel_entfernt(), 0, XmlBefundArt::DiagnoseTrotzErfolg),
        "DiagnoseTrotzErfolg");
}

TEST(XmlWacheSelbstbiss, M5_LiteralFALSE_GREENFehltAmMutanten) {
    EXPECT_NONFATAL_FAILURE(fordere_literal(faelschung_m5_stderr_riegel_entfernt(), "FALSE-GREEN"),
                            "FALSE-GREEN");
}

TEST(XmlWacheSelbstbiss, M6_FalscheBefundArtWirdGetoetet_InShellUnmoeglich) {
    // DIESER FALL IST DER BEWEIS DES GANZEN UMBAUS: der Mutant liefert den RICHTIGEN
    // Status (Riss) und haette in der rc-Domaene mit rc=1 als "gefangen" gegolten.
    // Erst weil die Art ein WERT ist, faellt er auf.
    EXPECT_NONFATAL_FAILURE(
        fordere_befund_art(faelschung_m6_falsche_befund_art(), 0, XmlBefundArt::DiagnoseTrotzErfolg),
        "DiagnoseTrotzErfolg");
}

// GEGENPROBE ZUM SELBSTBISS (T-4, andere Richtung): dieselben Helfer duerfen am
// GESUNDEN Ergebnis NICHT fallen. Faellt einer, ist dieser Test rot -- und der
// Selbstbiss oben waere ein Beweis fuer nichts, weil die Helfer immer fielen.
TEST(XmlWacheSelbstbiss, GegenprobeDieHelferSchweigenAmGesundenErgebnis) {
    XmlWacheErgebnis gesund;
    gesund.status = WacheStatus::Riss;
    gesund.nenner = 4;
    gesund.risse.push_back({"ns.xml", XmlBefundArt::DiagnoseTrotzErfolg, {"is not defined"}});

    fordere_status(gesund, WacheStatus::Riss);
    fordere_kein_abbruch(gesund);
    fordere_nenner(gesund, 4);
    fordere_riss_zahl(gesund, 1);
    fordere_befund_art(gesund, 0, XmlBefundArt::DiagnoseTrotzErfolg);
    fordere_literal(gesund, "FALSE-GREEN");
    fordere_kein_literal(gesund, "alle wohlgeformt");
}

// =============================================================================
// DIE PROZESS-NAHT SELBST -- (c) "das Werkzeug ist kaputt".
// Hier wird der Defekt vom 09.08. direkt gegen die Wand gefahren.
// =============================================================================
TEST(ProzessNaht, FehlendesWerkzeugLiefertKEINENExitCode) {
    ProzessAuftrag auftrag;
    auftrag.argv = {"comdare_dieses_werkzeug_gibt_es_ganz_sicher_nicht_2026"};
    const ProzessAusgang ausgang = comdare::ci_wachen::fuehre_aus(auftrag);

    EXPECT_EQ(ausgang.art, ProzessArt::ExecFehlgeschlagen) << ausgang.beschreibung();
    // DAS IST DER KERN: der 127-Eimer existiert nicht mehr.
    EXPECT_EQ(exit_code(ausgang), std::optional<int>{}) << ausgang.beschreibung();
    EXPECT_NE(exit_code(ausgang), std::optional<int>{127});
    EXPECT_NE(exit_code(ausgang), std::optional<int>{0});
    EXPECT_THAT(ausgang.beschreibung(), HasSubstr("der Prozess LIEF NIE"));
}

TEST(ProzessNaht, EchterExitCodeKommtDurch) {
    ProzessAuftrag auftrag;
    auftrag.argv = {"git", "--version"};
    const ProzessAusgang ausgang = comdare::ci_wachen::fuehre_aus(auftrag);
    ASSERT_EQ(ausgang.art, ProzessArt::Exit) << ausgang.beschreibung();
    EXPECT_EQ(exit_code(ausgang), std::optional<int>{0});
    EXPECT_THAT(ausgang.ausgabe, HasSubstr("git version"));
}

TEST(ProzessNaht, StdoutUndStderrWerdenGETRENNTUndVOLLSTAENDIGGelesen) {
    // Kein Deadlock bei viel Ausgabe auf einem der beiden Rohre: die poll-Schleife
    // leert beide. Ohne sie blockierte das Kind beim Schreiben und der Test haenge.
    ProzessAuftrag auftrag;
    auftrag.argv = {"git", "diese-unterkommandozeile-gibt-es-nicht"};
    const ProzessAusgang ausgang = comdare::ci_wachen::fuehre_aus(auftrag);
    ASSERT_EQ(ausgang.art, ProzessArt::Exit) << ausgang.beschreibung();
    EXPECT_NE(exit_code(ausgang), std::optional<int>{0});
    EXPECT_FALSE(ausgang.fehler.empty()) << "git meldet den Fehler auf stderr.";
}

TEST(ProzessNaht, UnbrauchbaresArbeitsverzeichnisIstExecFehlgeschlagenKeinExit) {
    ProzessAuftrag auftrag;
    auftrag.argv = {"git", "--version"};
    auftrag.arbeitsverzeichnis = std::filesystem::temp_directory_path() / "comdare_gibt_es_nicht_2026";
    const ProzessAusgang ausgang = comdare::ci_wachen::fuehre_aus(auftrag);
    EXPECT_EQ(ausgang.art, ProzessArt::ExecFehlgeschlagen) << ausgang.beschreibung();
    EXPECT_EQ(exit_code(ausgang), std::optional<int>{});
    EXPECT_THAT(ausgang.beschreibung(), HasSubstr("Arbeitsverzeichnis"));
}

TEST(ProzessNaht, JedeProzessArtHatEineEIGENEUnterscheidbareBeschreibung) {
    // GEFUNDEN DURCH EINEN UEBERLEBENDEN MUTANTEN, nicht durch Nachlesen: der
    // Mutations-Lauf vom 09.08. veraenderte den Signal-Text und ueberlebte die Suite --
    // ProzessArt::Signal hatte keinen einzigen Fall. Ein Zweig, den kein Test ansieht,
    // ist genau die Klasse, gegen die dieses Modul gebaut ist.
    ProzessAusgang beendet;
    beendet.werkzeug = "werkzeug";
    beendet.art = ProzessArt::Exit;
    beendet.code = 3;

    ProzessAusgang gestorben;
    gestorben.werkzeug = "werkzeug";
    gestorben.art = ProzessArt::Signal;
    gestorben.code = 9;

    ProzessAusgang nie_gelaufen;
    nie_gelaufen.werkzeug = "werkzeug";
    nie_gelaufen.art = ProzessArt::ExecFehlgeschlagen;
    nie_gelaufen.code = 2;

    EXPECT_THAT(beendet.beschreibung(), HasSubstr("Exit(3)"));
    EXPECT_THAT(gestorben.beschreibung(), HasSubstr("Signal(9)"));
    EXPECT_THAT(gestorben.beschreibung(), HasSubstr("der Prozess starb, er endete nicht"));
    EXPECT_THAT(nie_gelaufen.beschreibung(), HasSubstr("der Prozess LIEF NIE"));

    // NUR der Exit traegt einen Code -- ein Signal 9 darf nie wie ein Exit 9 aussehen.
    EXPECT_EQ(exit_code(gestorben), std::optional<int>{});
    EXPECT_NE(exit_code(gestorben), exit_code(beendet));

    // Die drei Beschreibungen sind PAARWEISE VERSCHIEDEN -- sonst waere die Trennung
    // der Arten in der Ausgabe wieder aufgehoben.
    const std::vector<std::string> texte = {beendet.beschreibung(), gestorben.beschreibung(),
                                            nie_gelaufen.beschreibung()};
    EXPECT_NE(texte[0], texte[1]);
    EXPECT_NE(texte[1], texte[2]);
    EXPECT_NE(texte[0], texte[2]);
    EXPECT_EQ(texte.size(), std::size(comdare::ci_wachen::alle_prozess_arten))
        << "Es gibt eine ProzessArt ohne Fall -- die Tabelle ist unvollstaendig.";
}

TEST(ProzessNaht, SelbstbissEinWerkzeugAusfallDarfKEINEMSollCodeGleichen) {
    // Der Defekt vom 09.08. in einem Satz: `rc != 0 && rc != 2` galt als Biss, und ein
    // 127 aus einem Shim erfuellte das. Hier faellt jede Gleichsetzung -- unabhaengig
    // davon, welchen Code jemand erwartet haette.
    ProzessAuftrag auftrag;
    auftrag.argv = {"comdare_dieses_werkzeug_gibt_es_ganz_sicher_nicht_2026"};
    const ProzessAusgang ausgang = comdare::ci_wachen::fuehre_aus(auftrag);
    for (int code = 0; code <= 130; ++code) {
        ASSERT_NE(exit_code(ausgang), std::optional<int>{code})
            << "Ein ExecFehlgeschlagen wurde dem Exit-Code " << code << " gleichgesetzt.";
    }
}

// =============================================================================
// E2E: DER CLI-VERTRAG DER AUFRUFSTELLE (.gitlab-ci.yml lint:xml-wellformed).
// Nur diese Faelle beruehren Exit-Codes -- und sie lesen sie TYPISIERT.
// Nebeneffekt mit Absicht: weil test:unit in Debug UND Release faehrt, wird das
// Binary in BEIDEN Optimierungsstufen geprueft -- genau die Klasse, die test_ms1 in
// Pipeline 15437 riss (lokal -O0 gruen, CI -O3 rot).
// =============================================================================
#ifdef COMDARE_CI_WACHE_XML_BINARY
TEST(XmlWacheE2E, GruenerBestandLiefertExit0) {
    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));
    FixtureRepo repo;
    ASSERT_TRUE(repo.init());
    const int gute = wuerfel.zahl(2, 5);
    for (int i = 0; i < gute; ++i) {
        const std::string token = wuerfel.token();
        ASSERT_TRUE(repo.schreibe_und_verfolge("gut_" + token + ".xml",
                                               comdare::ci_wachen::werkbank::xml_wohlgeformt(token)));
    }

    ProzessAuftrag auftrag;
    auftrag.argv = {COMDARE_CI_WACHE_XML_BINARY};
    auftrag.arbeitsverzeichnis = repo.pfad();
    const ProzessAusgang ausgang = comdare::ci_wachen::fuehre_aus(auftrag);

    // PFLICHT-RIEGEL VOR JEDEM CODE-VERGLEICH.
    ASSERT_EQ(ausgang.art, ProzessArt::Exit) << ausgang.beschreibung();
    EXPECT_EQ(exit_code(ausgang), std::optional<int>{0}) << ausgang.fehler;
    EXPECT_THAT(ausgang.ausgabe, HasSubstr(std::to_string(gute) + " XML-Dateien geprueft"));
}

TEST(XmlWacheE2E, KaputterBestandLiefertExit1UndDenDateinamen) {
    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));
    FixtureRepo repo;
    ASSERT_TRUE(repo.init());
    const std::string token = wuerfel.token();
    const std::string name = "kaputt_" + token + ".xml";
    ASSERT_TRUE(repo.schreibe_und_verfolge(name,
                                           comdare::ci_wachen::werkbank::xml_doppelbindestrich(token)));

    ProzessAuftrag auftrag;
    auftrag.argv = {COMDARE_CI_WACHE_XML_BINARY};
    auftrag.arbeitsverzeichnis = repo.pfad();
    const ProzessAusgang ausgang = comdare::ci_wachen::fuehre_aus(auftrag);

    ASSERT_EQ(ausgang.art, ProzessArt::Exit) << ausgang.beschreibung();
    EXPECT_EQ(exit_code(ausgang), std::optional<int>{1});
    EXPECT_THAT(ausgang.fehler, HasSubstr(name));       // der GEWUERFELTE Name, woertlich
    EXPECT_THAT(ausgang.fehler, HasSubstr("FAILED --"));
}

TEST(XmlWacheE2E, LeererBestandLiefertExit2NichtExit0) {
    FixtureRepo repo;
    ASSERT_TRUE(repo.init());
    ProzessAuftrag auftrag;
    auftrag.argv = {COMDARE_CI_WACHE_XML_BINARY};
    auftrag.arbeitsverzeichnis = repo.pfad();
    const ProzessAusgang ausgang = comdare::ci_wachen::fuehre_aus(auftrag);

    ASSERT_EQ(ausgang.art, ProzessArt::Exit) << ausgang.beschreibung();
    EXPECT_EQ(exit_code(ausgang), std::optional<int>{2});
    EXPECT_NE(exit_code(ausgang), std::optional<int>{0}) << "Ein leerer Nenner ist KEIN Gruen.";
    EXPECT_THAT(ausgang.fehler, HasSubstr("NULL getrackte *.xml gefunden"));
}
#endif  // COMDARE_CI_WACHE_XML_BINARY

}  // namespace
