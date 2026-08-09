// werkbank.hpp -- die WERKBANK der Wachen-Tests.                          (2026-08-09)
//
// SIE TRAEGT DREI SACHEN, DIE JEDER FALL BRAUCHT:
//
//  (1) DEN WUERFEL (T-5 / K13). Kein Orakel schreibt eine Zahl ab. Wie viele gute und
//      wie viele kaputte XML ein Fall anlegt, welchen Token jede traegt, welchen SHA
//      ein Gitlink bekommt -- alles wird je Lauf frisch gezogen und WOERTLICH
//      zurueckgefordert. Eine Wache, die eine feste Zahl faelscht, faellt daran. Der
//      Seed wird per RecordProperty protokolliert, damit ein Fehlschlag reproduzierbar
//      bleibt. Die Zahlen im Protokoll wechseln deshalb je Lauf -- Absicht, kein Rauschen.
//
//  (2) DAS WEGWERF-REPO. Jeder Fall bekommt ein eigenes git-Repo unter einem eindeutigen
//      Temp-Pfad. Der Bestand wird nie angefasst. JEDER Schritt liefert eine
//      AssertionResult -- der Fall bricht als ROT mit Fixture-Diagnose ab, wenn das
//      Arrangement nicht steht. DAS IST DER KERN DER KORREKTUR: die abgeloeste Probe
//      verbuchte einen Werkzeug-Ausfall als "gefangen"; hier gibt es keinen Eimer mehr,
//      in den er fallen koennte -- nur bestandene und gefallene Assertions.
//
//  (3) DIE FAKES. FakeGitQuelle und FakeXmlParser erlauben es, JEDEN Zweig ohne
//      Werkzeug zu erreichen -- auch die, die die Shell-Probe ehrlich als unerreichbar
//      melden musste ("ohne root nicht ausloesbar", "PATH ohne xmllint nimmt der Probe
//      das Werkzeug, mit dem sie ihre Fixtures baut").
//
// ASCII-only, Zeilen <= 120 Byte.

#ifndef COMDARE_CI_WACHEN_WERKBANK_HPP
#define COMDARE_CI_WACHEN_WERKBANK_HPP

#include <cstdint>
#include <filesystem>
#include <map>
#include <random>
#include <string>
#include <vector>

#include <gtest/gtest.h>

#include "comdare/ci_wachen/git_quelle.hpp"
#include "comdare/ci_wachen/xml_parser.hpp"

namespace comdare::ci_wachen::werkbank {

// ---- (1) DER WUERFEL --------------------------------------------------------------
class Wuerfel {
public:
    Wuerfel();
    explicit Wuerfel(std::uint64_t seed);

    std::uint64_t seed() const { return seed_; }
    int           zahl(int min_inklusive, int max_inklusive);
    // Hex-Token beliebiger Laenge -- als Koeder in Dateien eingebettet und woertlich
    // zurueckgefordert. NIE abgeschrieben, immer erzeugt.
    std::string token(std::size_t stellen = 12);
    std::string sha40();

private:
    std::uint64_t   seed_;
    std::mt19937_64 quelle_;
};

// ---- (2) DAS WEGWERF-REPO ---------------------------------------------------------
class FixtureRepo {
public:
    FixtureRepo();
    ~FixtureRepo();
    FixtureRepo(const FixtureRepo&)            = delete;
    FixtureRepo& operator=(const FixtureRepo&) = delete;

    const std::filesystem::path& pfad() const { return pfad_; }

    // Jeder Schritt ist eine Zusicherung. Der Aufrufer schreibt ASSERT_TRUE(...) --
    // ein misslungenes Arrangement ist ROT, nie "gefangen" und nie ein stilles Gruen.
    testing::AssertionResult init();
    testing::AssertionResult schreibe(const std::string& relativ, const std::string& inhalt);
    testing::AssertionResult verfolge(const std::string& relativ);
    testing::AssertionResult schreibe_und_verfolge(const std::string& relativ, const std::string& inhalt);
    testing::AssertionResult loesche_aus_arbeitsbaum(const std::string& relativ);
    testing::AssertionResult committe(const std::string& nachricht);
    // Ein Gitlink ist ein Index-Eintrag mit Modus 160000 -- er laesst sich ohne
    // Submodul, ohne Netz und ohne existierendes Ziel-Repo direkt setzen.
    testing::AssertionResult setze_index_eintrag(const std::string& relativ, const std::string& modus,
                                                 const std::string& objekt);
    // GEGENPROBE: fragt git selbst, ob eine Datei wirklich verfolgt wird bzw. welchen
    // Modus ein Indexeintrag traegt. Damit belegt ein Fall seine Voraussetzung, statt
    // sie zu behaupten.
    testing::AssertionResult ist_verfolgt(const std::string& relativ);
    testing::AssertionResult ist_nicht_verfolgt(const std::string& relativ);
    std::string              index_modus(const std::string& relativ);

private:
    testing::AssertionResult git(const std::vector<std::string>& argumente, const char* was);
    std::filesystem::path    pfad_;
};

// Fixture-Bausteine mit gemessenem, nicht behauptetem Verhalten (Messung 09.08. am
// xmllint dieser Maschine, libxml 20914 -- die Zahlen stehen im Kopf von xml_parser.hpp).
std::string xml_wohlgeformt(const std::string& token);
std::string xml_doppelbindestrich(const std::string& token);         // -> rc=1, "Double hyphen within comment"
std::string xml_namensraum_fehler(const std::string& token);         // -> rc=0 UND 89 Byte stderr
std::string xml_doctype_einzelbindestrich(const std::string& token); // -> rc=0, 0 Byte stderr

// ---- (3) DIE FAKES ----------------------------------------------------------------
class FakeGitQuelle final : public GitQuelle {
public:
    bool                                  arbeitsbaum = true;
    DateiBestand                          bestand;
    std::map<std::string, GitlinkAntwort> gitlinks_head;
    std::map<std::string, GitlinkAntwort> gitlinks_index;
    std::filesystem::path                 wurzel;

    bool                  ist_arbeitsbaum() const override { return arbeitsbaum; }
    DateiBestand          ls_files_z(const std::string& muster) const override;
    GitlinkAntwort        gitlink(const std::string& pfad, GitlinkQuelle quelle) const override;
    std::filesystem::path aufloesen(const std::string& pfad) const override;
};

class FakeXmlParser final : public XmlParser {
public:
    std::map<std::string, XmlUrteil> urteile; // Schluessel = Dateiname (nur der Stamm)
    XmlUrteil                        vorgabe; // fuer alles, was nicht eingetragen ist
    mutable int                      aufrufe = 0;

    FakeXmlParser();
    XmlUrteil   pruefe(const std::filesystem::path& datei) const override;
    std::string bezeichnung() const override { return "FakeXmlParser"; }
};

} // namespace comdare::ci_wachen::werkbank

#endif // COMDARE_CI_WACHEN_WERKBANK_HPP
