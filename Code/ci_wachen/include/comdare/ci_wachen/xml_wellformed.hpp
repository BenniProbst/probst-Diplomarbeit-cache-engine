// xml_wellformed.hpp -- die XML-WOHLGEFORMTHEITS-WACHE als Bibliothek.    (2026-08-09)
//
// ABGELOEST, NICHT GELOESCHT: scripts/ci_xml_wellformed_guard.sh (08.08., 157 Zeilen).
// Deren Mess-Befunde ziehen hier ein, statt mit der Datei zu verschwinden --
// die Doku wird nie geloescht, sie zieht um.
//
// WORUM ES URSPRUENGLICH GING (Befund 08.08.): FUENF getrackte XML-Dateien in zwei
// Repos waren nicht wohlgeformt -- vier im ce, eine hier (Code/experiment_config/
// messreihen.xml, das Standard-Template der Messreihen). Kein Job, kein Test und keine
// Wache hat es gemeldet; die Dateien lagen ueber Wochen kaputt im Baum. ALLE FUENF
// trugen dieselbe Fehlerklasse: ein "--" INNERHALB eines XML-Kommentars (XML 1.0,
// Abschnitt 2.5 verbietet das ausnahmslos). Zwei der fuenf wurden MASCHINELL erzeugt,
// die Generatoren schrieben den Defekt also mit -- eine Handkorrektur waere beim
// naechsten Regenerieren zurueckgefallen.
//
// DER NENNER IST DIE HAUSREGEL: die Wache nennt IMMER, wie viele Dateien sie geprueft
// hat. Eine nackte Null ohne Nenner meldet Vollstaendigkeit und deckt nichts.
//
// WAS GEGENUEBER DER SHELL-FASSUNG ANDERS IST -- und warum:
//
//  * ABBRUCH IST EIN EIGENER WERT, KEIN EXIT-CODE. Vier Gruende sind unterscheidbar
//    (KeinGitBaum, GitFehlgeschlagen, NullDateien, ParserFehlt). In der Shell fielen
//    sie alle in rc=2 und waren voneinander nicht mehr zu trennen.
//
//  * DER NENNER-MISMATCH-ZWEIG IST ERSATZLOS ENTFALLEN (er war nachweislich tot,
//    Begruendung im Kopf von git_quelle.hpp). An seine Stelle tritt ein POSITIV-Fall:
//    ein Dateiname mit Zeilenende wird korrekt gezaehlt und geprueft.
//
//  * DER grep-ZWEIG IST ENTFALLEN. Die Shell-Wache hielt /usr/bin/grep fest verdrahtet
//    und pruefte seine Existenz -- ein Zweig, den ohne root nichts ausloesen konnte,
//    also keine Deckung, nur Text. Hier gibt es im Orakel-Pfad kein Textwerkzeug mehr.
//
//  * NEU UND ABSICHTLICH SICHTBAR: `nicht_gelesen`. Eine Datei, die im Index steht, im
//    Arbeitsbaum aber fehlt (sparse checkout), wurde in der Shell-Fassung im Nenner
//    MITGEZAEHLT, aber nie geoeffnet -- sie meldete dann "1 XML-Dateien geprueft, alle
//    wohlgeformt", obwohl sie NULL gelesen hatte. Das URTEIL bleibt hier unveraendert
//    (Gruen), damit eine spaetere Heilung sichtbar bricht; aber die Zahl steht jetzt im
//    Protokoll. Ein eingefrorener Defekt, den man sieht, ist etwas anderes als einer,
//    den man nur in einem Probenkopf nachlesen kann.
//
// ASCII-only, Zeilen <= 120 Byte.

#ifndef COMDARE_CI_WACHEN_XML_WELLFORMED_HPP
#define COMDARE_CI_WACHEN_XML_WELLFORMED_HPP

#include <optional>
#include <string>
#include <vector>

#include "comdare/ci_wachen/ergebnis.hpp"
#include "comdare/ci_wachen/git_quelle.hpp"
#include "comdare/ci_wachen/xml_parser.hpp"

namespace comdare::ci_wachen {

enum class XmlBefundArt {
    ParserFehler,          // der Parser lehnt das Dokument ab (Ex-"xmllint rc!=0")
    DiagnoseTrotzErfolg,   // rc=0, aber der Parser beschwert sich (Ex-stderr-Riegel)
};

inline constexpr XmlBefundArt alle_xml_befund_arten[] = {
    XmlBefundArt::ParserFehler,
    XmlBefundArt::DiagnoseTrotzErfolg,
};
static_assert(sizeof(alle_xml_befund_arten) / sizeof(alle_xml_befund_arten[0]) == 2,
              "XmlBefundArt hat einen neuen Wert -- Tabelle und Fall-Tabellen nachziehen.");

enum class XmlAbbruchGrund {
    KeinGitBaum,       // ohne git gibt es keinen belastbaren Nenner, also auch kein Gruen
    GitFehlgeschlagen, // git hat geantwortet, aber mit Fehler -- nie als "0 Dateien" deuten
    NullDateien,       // ein leerer Nenner ist kein bestandener Lauf
    ParserFehlt,       // das Werkzeug lief nie -- KEINE Aussage ueber den Bestand moeglich
};

inline constexpr XmlAbbruchGrund alle_xml_abbruch_gruende[] = {
    XmlAbbruchGrund::KeinGitBaum,
    XmlAbbruchGrund::GitFehlgeschlagen,
    XmlAbbruchGrund::NullDateien,
    XmlAbbruchGrund::ParserFehlt,
};
static_assert(sizeof(alle_xml_abbruch_gruende) / sizeof(alle_xml_abbruch_gruende[0]) == 4,
              "XmlAbbruchGrund hat einen neuen Wert -- Tabelle und Fall-Tabellen nachziehen.");

struct XmlBefund {
    std::string datei;
    XmlBefundArt art = XmlBefundArt::ParserFehler;
    std::vector<std::string> meldungen;  // die Parser-Zeilen, woertlich
};

struct XmlWacheErgebnis {
    WacheStatus status = WacheStatus::Abbruch;  // fail-closed als Vorgabe
    int nenner = 0;        // getrackte *.xml -- die Grundgesamtheit
    int nicht_gelesen = 0; // im Index, im Arbeitsbaum nicht da (s. Kopf)
    std::vector<XmlBefund> risse;
    std::optional<XmlAbbruchGrund> abbruch;
    std::string abbruch_detail;

    // EINE Formatierfunktion, sie traegt die Literale der abgeloesten Wache weiter.
    std::string protokoll() const;
};

// Die Wache. Beide Naehte sind Parameter -- deshalb braucht kein Test ein echtes
// Repo, wenn er nur die Verzweigung pruefen will, und kein Fall muss ein Werkzeug
// simulieren, indem er den PATH umbiegt.
XmlWacheErgebnis pruefe_xml_bestand(const GitQuelle& git, const XmlParser& parser);

std::string abbruch_text(XmlAbbruchGrund grund);
std::string befund_text(XmlBefundArt art);

inline std::ostream& operator<<(std::ostream& strom, XmlAbbruchGrund grund) {
    return strom << abbruch_text(grund);
}
inline std::ostream& operator<<(std::ostream& strom, XmlBefundArt art) {
    return strom << befund_text(art);
}

}  // namespace comdare::ci_wachen

#endif  // COMDARE_CI_WACHEN_XML_WELLFORMED_HPP
