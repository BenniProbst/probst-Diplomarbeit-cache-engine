// ci_invarianten.hpp -- die zwei ABSCHALT-KLASSEN der .gitlab-ci.yml.     (2026-08-10)
//
// EINE PIPELINE KANN GRUEN SEIN, WEIL SIE NICHTS PRUEFT. Beide Klassen, die das
// bewirken, sind im Haus belegt -- und keine von beiden konnte bisher rot werden.
//
// KLASSE 1 -- DER DOPPELTE TOP-LEVEL-SCHLUESSEL.
//   `contract:axis-version-lock` stand ZWEIMAL in der ce-.gitlab-ci.yml. YAML gibt dem
//   LETZTEN Vorkommen recht; die zweite Fassung war inert gegatet. Ergebnis: der
//   Tripwire lief DREI WOCHEN in keinem einzigen Lauf, bei gruener Pipeline und ohne
//   jedes Signal. Kein Job wurde rot, weil der Job, der rot geworden waere, nicht mehr
//   existierte.
//
// KLASSE 2 -- DIE REGEL-VARIABLE, DIE NIRGENDS GESETZT IST.
//   Ein Job mit `rules: - if: '$COMDARE_X == "1"'`, bei dem COMDARE_X in der Datei
//   nirgends gesetzt wird, ist von einem abgeschalteten Job nicht zu unterscheiden. Er
//   steht im Text, er liest sich wie ein Gate, und er faehrt nie. Genau dieser
//   Ausschalter (`COMDARE_AXIS_LOCK_CHECK`) hielt Klasse 1 am Leben.
//
// WARUM DIESE WACHE WEITER GREIFT ALS DER VORGESCHRIEBENE EINZEILER.
//   Der Auftrag nennt als Wache:
//       grep -oE '^[a-z][a-z0-9_:.-]*:' .gitlab-ci.yml | sort | uniq -d
//   Dieses Muster sieht NUR Schluessel, die mit einem Kleinbuchstaben beginnen. YAML-
//   TEMPLATES beginnen aber mit einem Punkt (`.code-rules:`), und sie sind der
//   GEFAEHRLICHERE Fall: ein doppeltes Template aendert per `extends` die rules JEDES
//   erbenden Jobs auf einmal, nicht nur den eigenen. Am Objekt gemessen (11.08.2026):
//       super  7 Template-Schluessel, 13 WIRKSAME `extends:`-Nutzer (18 Vorkommen minus
//              5 Kommentarzeilen -- die frueher hier stehende 17 war keine der beiden
//              Zahlen und ist ersatzlos korrigiert)
//       ce     3 Template-Schluessel, 24 `extends:`-Nutzer (0 davon in Kommentaren)
//   Der Einzeiler haette eine Dublette an keiner dieser 10 Stellen gesehen. Diese Wache
//   sammelt JEDEN Top-Level-Schluessel -- Job, Template, Struktur.
//
// DIE SCHLUESSEL-REGEL IST DIE ECHTE YAML-REGEL, NICHT EINE NAEHERUNG.
//   Ein ':' trennt Schluessel und Wert nur, wenn ihm ein Leerzeichen oder das
//   Zeilenende folgt; sonst gehoert es zum Namen. Deshalb ist
//       test:unit:debug:   -> EIN Schluessel "test:unit:debug"
//       image: alpine      -> Schluessel "image"
//   Ohne diese Regel zerfiele jeder Doppelpunkt-Jobname in Teile, und die Namen der 48
//   super-Jobs waeren falsch. Gegenprobe am Objekt: 55 von 55 Spalte-0-Zeilen der
//   super-Datei sind unter dieser Regel Schluessel, 0 Ausnahmen.
//
// DIE DECKUNG EINER REGEL-VARIABLEN hat genau zwei ehrliche Formen:
//   (a) sie wird in der Datei GESETZT, oder
//   (b) sie traegt eine ausdrueckliche Herkunfts-Annotation
//           # extern: COMDARE_X -- <Begruendung>
//       weil sie von aussen kommt (Projekt-/Gruppen-Variable, Trigger-Nutzlast,
//       manueller Start). Die Annotation ist NAMENSGEBUNDEN: sie deckt den genannten
//       Namen und keinen anderen. Ein Sammel-Kommentar kann damit nicht versehentlich
//       die ganze Datei decken -- ein eigener Fall friert das ein.
//   Alles andere ist ungedeckt und damit ein moegliches totes Gate.
//
// TESTKRITIK (T-9), ausdruecklich benannt statt verschwiegen:
//   Strenger ZEILEN-Scanner, kein YAML-Parser -- dieselbe Grenze wie beim
//   Schwester-Scanner in ci_yml_scanner.hpp. Was er NICHT sieht:
//     - Schluessel aus `include:`-Dateien. super erbt `.build-clang-latest` aus
//       comdare/cluster/ci-templates; eine Dublette DORT bleibt unsichtbar.
//     - YAML-Anker/Aliase (&anker/*alias).
//     - Variablen, die eine Regel indirekt ueber ein Template erbt.
//   Die erste Grenze ist die wichtigste und gehoert in den Bericht, nicht in eine
//   Fussnote: diese Wache deckt die Datei, die das Repository BESITZT.
//
// ASCII-only, Zeilen <= 120 Byte.

#ifndef COMDARE_CI_WACHEN_CI_INVARIANTEN_HPP
#define COMDARE_CI_WACHEN_CI_INVARIANTEN_HPP

#include <cstddef>
#include <map>
#include <set>
#include <string>
#include <vector>

namespace comdare::ci_wachen {

// ---- Klasse 1: Top-Level-Schluessel ------------------------------------------------

struct TopLevelSchluessel {
    std::string name;
    std::size_t zeile = 0; // 1-basiert, wie ein Editor zaehlt
};

struct Dublette {
    std::string              name;
    std::vector<std::size_t> zeilen; // ALLE Fundstellen, immer >= 2
};

// Sammelt jeden Top-Level-Schluessel: Job (`test:unit:`), Template (`.code-rules:`),
// Struktur (`stages:`, `variables:`, `include:`). Kommentar- und Leerzeilen zaehlen nie.
std::vector<TopLevelSchluessel> sammle_top_level_schluessel(const std::vector<std::string>& zeilen);

// Nur Namen, die mehr als einmal vorkommen; je Dublette ALLE Zeilennummern, damit die
// Fehlermeldung beide Fundstellen nennt und nicht nur sagt "es gibt eine".
std::vector<Dublette> finde_dubletten(const std::vector<TopLevelSchluessel>& schluessel);

// GEGENPROBE zur Reichweite: die Teilmenge, die mit '.' beginnt (die Templates). Sie ist
// genau die Menge, die der vorgeschriebene `^[a-z]`-Einzeiler nicht sehen kann.
std::vector<TopLevelSchluessel> nur_templates(const std::vector<TopLevelSchluessel>& schluessel);

// ---- Klasse 2: Regel-Variablen -----------------------------------------------------

struct VariablenFund {
    std::string name;
    std::size_t zeile = 0;
};

// Jede $COMDARE_*-Referenz aus einer REGEL-BEDINGUNG (getrimmt beginnend mit "- if:"
// oder "if:"). Mehrfach genannte Namen erscheinen mehrfach -- mit ihrer Zeile.
std::vector<VariablenFund> sammle_regel_referenzen(const std::vector<std::string>& zeilen);

// Jeder COMDARE_*-Name, der in der Datei als Schluessel eines variables-Eintrags
// GESETZT wird (eingerueckt, nicht Kommentar, Form `COMDARE_X: wert`).
// NICHT dabei: die SELBST-DURCHREICHUNG `COMDARE_X: "$COMDARE_X"`. Sie definiert nichts,
// sondern reicht den Eltern-Wert an eine Child-Pipeline weiter; steht X sonst nirgends,
// ist der Wert leer. Sie als Setzung zu zaehlen macht die Wache an ihrer eigenen Klasse
// blind -- s. Kopf von ci_invarianten.cpp und den Fall KoederDurchreichungIstKeineSetzung.
std::set<std::string> sammle_gesetzte_variablen(const std::vector<std::string>& zeilen);

// Die namensgebundenen Herkunfts-Annotationen: `# extern: COMDARE_X -- Begruendung`.
// Schluessel = Variablenname, Wert = Begruendung (nie leer, sonst kein Eintrag).
std::map<std::string, std::string> sammle_extern_annotationen(const std::vector<std::string>& zeilen);

// Das Urteil: referenziert, aber weder gesetzt noch annotiert. Leer = gedeckt.
std::vector<VariablenFund> ungedeckte_regel_variablen(const std::vector<std::string>& zeilen);

} // namespace comdare::ci_wachen

#endif // COMDARE_CI_WACHEN_CI_INVARIANTEN_HPP
