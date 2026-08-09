// xml_parser.hpp -- die NAHT zum XML-Urteil.                              (2026-08-09)
//
// DREI URTEILE, NICHT ZWEI -- und das ist ein am Objekt gemessener Befund, keine
// Vorsichtsmassnahme. Der Kopf der abgeloesten Wache begruendete den "stderr-Riegel"
// (rc=0, aber stderr nicht leer) mit einer per --nonet blockierten externen Entity.
// Nachgemessen mit dem xmllint dieser Maschine (libxml 20914) trifft das NICHT zu:
// externe DTD ueber http, externe DTD lokal, externe Entity im Inhalt und externer
// Parameter-Entity im internen Subset liefern ALLE VIER rc=0 UND 0 Byte stderr.
//
// Der Riegel ist trotzdem nicht tot. Der Weg hinein ist ein undefiniertes Namensraum-
// Praefix -- am 09.08. in diesem Worktree woertlich nachgemessen:
//     Eingabe:  <?xml version="1.0"?>\n<b><a:c/></b>
//     xmllint --noout --nonet  ->  rc=0, stderr 89 Byte:
//         "ns.xml:2: namespace error : Namespace prefix a on c is not defined"
// Waere die Wache ihrer eigenen Doku gefolgt statt der Messung, haette sie einen
// GRUENEN Fall gebaut und den Riegel ungedeckt gelassen.
// Gegenmessung derselben Runde, damit die drei Klassen wirklich disjunkt sind:
//     "--" im Kommentar  -> rc=1, "parser error : Double hyphen within comment"
//     sauberes Dokument  -> rc=0, 0 Byte stderr
//
// Deshalb ist "Diagnose trotz Erfolg" hier ein EIGENER Wert und kein Byte-Zaehlen auf
// stderr: die Wachen-Logik entscheidet ueber einen Aufzaehlungswert, nicht ueber eine
// Zeichenkettenlaenge.
//
// WARUM EIN KINDPROZESS UM xmllint UND (NOCH) NICHT libxml2 GELINKT:
// Das Design nennt beide Wege und haelt ausdruecklich fest, dass das TESTDESIGN gegen
// die Wahl invariant ist -- die Naht ist genau diese Invarianz. Gewaehlt ist der Weg,
// der NICHTS RAET (Hausregel "nie raten"):
//   * xmllint ist auf den Runnern BELEGT -- lint:xml-wellformed ruft es seit dem 08.08.
//     fail-closed und ist gruen. Das ist eine Messung, keine Annahme.
//   * libxml2-DEV ist NICHT belegt. Auf prod1 liegt /usr/include/libxml2 (2.9.14), fuer
//     den zweiten baremetal-Host und die 8er-Docker-Matrix habe ich keinen Beleg, und
//     im gesamten Baum linkt heute KEIN CMakeLists libxml2 (gegengeprueft: grep ueber
//     alle CMakeLists.txt/*.cmake findet nur Kommentar-Erwaehnungen). Ein REQUIRED-
//     find_package haette test:unit auf einem unbelegten Host gerissen -- also eine
//     Regression aus einer Vermutung heraus.
// Der Wechsel kostet spaeter GENAU EINE neue XmlParser-Implementierung; keine Zeile
// Testcode aendert sich dabei. Die Verifikationspflicht steht im Uebergabe-Bericht.
//
// ZUGEWINN GEGENUEBER DEM libxml2-WEG: der Zweig "Parser nicht verfuegbar" bleibt
// LEBENDIG und pruefbar. Beim Link-Weg waere er ersatzlos entfallen -- also ein Zweig
// weniger, den irgendetwas beobachten kann.
//
// ASCII-only, Zeilen <= 120 Byte.

#ifndef COMDARE_CI_WACHEN_XML_PARSER_HPP
#define COMDARE_CI_WACHEN_XML_PARSER_HPP

#include <filesystem>
#include <string>
#include <vector>

namespace comdare::ci_wachen {

enum class XmlUrteilArt {
    Wohlgeformt,           // der Parser akzeptiert das Dokument und schweigt
    ParserFehler,          // der Parser lehnt das Dokument ab
    DiagnoseTrotzErfolg,   // der Parser akzeptiert es und beschwert sich TROTZDEM
    ParserNichtVerfuegbar, // das Werkzeug lief nie -- KEINE Aussage ueber das Dokument
};

struct XmlUrteil {
    XmlUrteilArt             art = XmlUrteilArt::ParserNichtVerfuegbar; // fail-closed als Vorgabe
    std::vector<std::string> meldungen;                                 // die Zeilen des Parsers, woertlich
    std::string              werkzeug_diagnose;                         // nur bei ParserNichtVerfuegbar gefuellt
};

inline constexpr XmlUrteilArt alle_xml_urteil_arten[] = {
    XmlUrteilArt::Wohlgeformt,
    XmlUrteilArt::ParserFehler,
    XmlUrteilArt::DiagnoseTrotzErfolg,
    XmlUrteilArt::ParserNichtVerfuegbar,
};
static_assert(sizeof(alle_xml_urteil_arten) / sizeof(alle_xml_urteil_arten[0]) == 4,
              "XmlUrteilArt hat einen neuen Wert -- Tabelle und Fall-Tabellen nachziehen.");

class XmlParser {
public:
    virtual ~XmlParser()                                                 = default;
    virtual XmlUrteil   pruefe(const std::filesystem::path& datei) const = 0;
    virtual std::string bezeichnung() const                              = 0;
};

// Die Produktions-Implementierung: ein Kindprozess ueber die Prozess-Naht.
// Fehlt das Werkzeug, kommt ExecFehlgeschlagen zurueck und wird zu
// ParserNichtVerfuegbar -- niemals zu "Wohlgeformt".
class XmllintParser final : public XmlParser {
public:
    XmlUrteil   pruefe(const std::filesystem::path& datei) const override;
    std::string bezeichnung() const override;
};

} // namespace comdare::ci_wachen

#endif // COMDARE_CI_WACHEN_XML_PARSER_HPP
