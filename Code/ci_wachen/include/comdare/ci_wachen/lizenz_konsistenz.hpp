// SPDX-License-Identifier: Apache-2.0
// lizenz_konsistenz.hpp -- sagen NOTICE, LICENSE und der Arbeitsbaum       (2026-08-11)
// dasselbe ueber die Lizenzen dieses Repositoriums?
// =============================================================================
// DER BEFUND, DER DIESE WACHE AUSLOEST (am Objekt gemessen, 11.08.2026):
//
//   * An der Wurzel lag KEINE NOTICE -- weder im Arbeitsbaum noch in irgendeinem
//     Commit irgendeines Branches (`git log --all -- NOTICE` leer; Gegenprobe
//     `-- LICENSE` = 1 Commit). Das super-Repo zieht 4 Submodul-Einbindungen und
//     1544 getrackte Dateien vendorten Forschungscode ein, darunter GPL-3.0 und
//     LGPL-2.1-or-later. Die Wurzel-LICENSE war unveraendertes 201-Zeilen-Apache-
//     Boilerplate und sagte ueber diese Fremdanteile NICHTS.
//
//   * DIE FEHLERKLASSE, GEGEN DIE SIE GEBAUT IST, IST LIVE BELEGT (KON2-25): im
//     gepinnten cache-engine-Stand behauptet ce/NOTICE Apache-2.0, waehrend
//     ce/LICENSE danebenliegend "Comdare Cache Engine -- Dual License" traegt.
//     ZWEI DATEIEN, ZWEI AUSSAGEN, kein Werkzeug, das es merkt. Genau das ist der
//     Gegenstand hier -- deshalb ist je Komponente ihre eigene LIZENZDATEI
//     massgeblich, nie das NOTICE eines Fremdrepos.
//
// WAS SIE ZUSICHERT:
//   (1) Jeder .gitmodules-Pfad hat GENAU EINE WACHE:-Zeile in NOTICE und
//       umgekehrt -- und ebenso jedes Vendor-Projekt. "Genau eine" heisst
//       gezaehlt, nicht `any_of`: s. NoticeZeileMehrfach unten.
//   (2) Der in NOTICE behauptete Lizenz-Marker steht WOERTLICH in der dort
//       benannten Lizenzdatei, UND die benannte Datei ist eine der Lizenzdateien,
//       die an der Wurzel dieser Komponente TATSAECHLICH liegen (DATEI-BINDUNG,
//       BefundArt::NoticeDateiIstKeineLizenzdatei). Ohne die zweite Haelfte
//       bindet diese Zusage die DATEI an nichts.
//   (3) Jedes Vendor-Projekt unter Forschungsarbeiten/code/ MIT Lizenzdatei hat
//       eine WACHE:-Zeile. Ein neu hinzugefuegtes Fremdprojekt wird damit rot,
//       bis es in NOTICE steht.
//   (4) Die Wurzel-LICENSE traegt die Apache-Marker UND den Titel des
//       Geltungs-Abschnitts (LIZENZ_KLAUSEL_MARKER, s.u.).
//   (5) Alle SPDX-Zeilen unter Code/ lauten Apache-2.0. Uebersprungen wird
//       Code/external/ (Fremdcode) und JEDE Verzeichnisklasse, die
//       Code/.gitignore ausschliesst -- die Skip-Liste wird aus dieser Datei
//       ABGELEITET, nicht abgeschrieben (s. LIZENZ_CODE_GITIGNORE).
//   (6) NOTICE und die Wurzel-LICENSE sind ASCII-only und halten
//       LIZENZ_ZEILE_MAX_BYTE -- in JEDER Zeile, nicht nur in den
//       WACHE:-Eintragszeilen. Die Diff-Hygiene-Wache ueberspringt beide
//       Dateien namentlich; ohne diese Zusage prueft sie NIEMAND.
//   (7) Ein Lizenz-Marker traegt AUSSAGEKRAFT: mindestens
//       LIZENZ_MARKER_MIN_ZEICHEN Zeichen und kein Baustein, den jeder Text
//       ohnehin traegt (LIZENZ_MARKER_GEGENPROBE). Ein Marker aus einem
//       Leerzeichen steht in praktisch jeder Datei und kann nie reissen.
//
// WAS SIE NICHT ZUSICHERT -- TESTKRITIK (T-9), ausdruecklich statt verschwiegen:
//   * Der Marker ist eine SUBSTRING-PROBE, keine juristische Textanalyse. Sie
//     erkennt einen Lizenz-WECHSEL (der Titel aendert sich), aber NICHT jeden
//     Versions-Wechsel innerhalb derselben Familie: die vier Boilerplate-Texte
//     (Apache, GPL) tragen ihren Titel in Zeile 1 und ihre Version erst in Zeile
//     2. Wer GPLv3 gegen GPLv2 tauscht, laesst den Titel-Marker stehen. Diese
//     Luecke ist benannt, nicht geschlossen.
//   * Die AUSSAGEKRAFT-Probe (7) ist eine UNTERGRENZE, kein Beweis. Sie faengt
//     den Marker, der SELBST ein ueberall vorkommender Baustein ist; einen
//     Marker, der zwar selten, aber fuer die behauptete Lizenz nicht kennzeich-
//     nend ist, faengt sie nicht.
//   * NICHT AUSGECHECKTE SUBMODULE werden nur GEPAART, nicht inhaltsgeprueft.
//     Sonst waere die Wache auf jedem Klon ohne `git submodule update` konstant
//     rot -- gegen die Doktrin "die Pipeline ist immer hart gruen". Am Objekt
//     sind beide Thesis-Einbindungen leer (ls -A je 0 Eintraege). Der Verzicht
//     wird als SKIP-Zeile PROTOKOLLIERT, nie stillschweigend genommen.
//   * Sie liest den ARBEITSBAUM, nicht die Historie. Was einmal in einem alten
//     Commit stand, ist ihr Gegenstand nicht.
//   * Sie liest den ARBEITSBAUM, nicht den INDEX. Eine ungetrackte Datei
//     ausserhalb der Skip-Klassen zaehlt mit. Deshalb steht die Skip-Liste in
//     der AUSGABE: der Nenner ist umgebungsabhaengig, und diese Abhaengigkeit
//     ist damit sichtbar statt verdeckt.
//   * Der SPDX-Scan liest je Datei nur den KOPF (LIZENZ_SPDX_KOPF_BYTE). Eine
//     SPDX-Zeile tief im Rumpf sieht er nicht; die Hauskonvention setzt sie in
//     Zeile 1.
//   * DIE EROSIONS-GRENZE DES SPDX-SCANS, gemessen am 11.08.: eine SPDX-Zeile zu
//     ENTFERNEN statt zu wechseln laesst die Wache gruen -- die Datei faellt
//     still aus dem Zaehler. Zusicherung (5) ist eine UNIFORMITAETS-, keine
//     VOLLSTAENDIGKEITS-Zusage. Eine SPDX-PFLICHT ist ausdruecklich NICHT
//     abgenommen: am Objekt tragen 26 von 98 C++-Dateien unter Code/ (ohne
//     external/ und ohne die Bauverzeichnisse) ueberhaupt eine SPDX-Zeile; die
//     Pflicht waere ein eigenes Paket ueber 72 Dateien. Sichtbar gemacht ist die
//     Erosion durch nenner_code_dateien: der Zaehler steht neben seiner
//     Grundgesamtheit, ein Wegfall aendert das Verhaeltnis in der AUSGABE.
//
// NENNER-PFLICHT (V-1, Verbot verdeckter exit-Zweige): 0 .gitmodules-Eintraege,
// 0 gescannte SPDX-Dateien oder 0 Vendor-Verzeichnisse sind ein ABBRUCH, nie ein
// stilles Gruen. Alle Nenner stehen im Ergebnis und gehoeren in die Ausgabe.
//
// ASCII-only, Zeilen <= 120 Byte.
// =============================================================================

#ifndef COMDARE_CI_WACHEN_LIZENZ_KONSISTENZ_HPP
#define COMDARE_CI_WACHEN_LIZENZ_KONSISTENZ_HPP

#include <cstddef>
#include <filesystem>
#include <map>
#include <string>
#include <string_view>
#include <vector>

#include "comdare/ci_wachen/ergebnis.hpp"

namespace comdare::ci_wachen {

// DER TITEL DES GELTUNGS-ABSCHNITTS. Er steht HIER und ein zweites Mal in der
// Wurzel-LICENSE; genau dieses Paar haelt der Befund WurzelLizenzOhneKlauselMarker
// zusammen. Wer den Abschnitt umbenennt, aendert beide Stellen -- oder wird rot.
inline constexpr std::string_view LIZENZ_KLAUSEL_MARKER =
    "GELTUNGSBEREICH DIESER LIZENZ -- EIGENCODE, SUBMODULE, VENDORED FORSCHUNGSCODE";

// Die Wurzel-LICENSE muss BEIDE tragen: der Titel allein unterscheidet Apache 2.0
// nicht von einer anderen Apache-Fassung.
inline constexpr std::string_view LIZENZ_APACHE_MARKER_A = "Apache License";
inline constexpr std::string_view LIZENZ_APACHE_MARKER_B = "Version 2.0";

// Der einzige unter Code/ zugelassene SPDX-Wert.
inline constexpr std::string_view LIZENZ_SPDX_SOLL = "Apache-2.0";

// Das Erkennungswort der SPDX-Zeile. In ZWEI Stuecken, damit diese Header-Datei
// nicht selbst als SPDX-Fundstelle mit dem Wert "" zaehlt, wenn sie je gescannt
// wird -- das Konstrukt ist Absicht, kein Schoenheitsfehler.
inline constexpr std::string_view LIZENZ_SPDX_MARKE_A = "SPDX-License-";
inline constexpr std::string_view LIZENZ_SPDX_MARKE_B = "Identifier:";

// Kopfgroesse des SPDX-Scans in Byte (s. TESTKRITIK oben).
inline constexpr std::size_t LIZENZ_SPDX_KOPF_BYTE = 4096;

// Die Hoechstlaenge einer Zeile in NOTICE und in der Wurzel-LICENSE -- JEDER
// Zeile, nicht nur der WACHE:-Eintragszeilen. Dieselbe Schranke wie die
// Diff-Hygiene-Wache und die .clang-format des Repos (ColumnLimit: 120).
// GEMESSEN am 11.08.: NOTICE MAXLEN 110 von 144 Zeilen, LICENSE MAXLEN 80 von
// 232 Zeilen, beide 0 Byte ausserhalb ASCII. Die Schranke schneidet heute also
// nichts -- sie faengt den kuenftigen Drift, den sonst KEIN Werkzeug faengt:
// die Diff-Hygiene-Wache ueberspringt LICENSE und NOTICE namentlich.
inline constexpr std::size_t LIZENZ_ZEILE_MAX_BYTE = 120;

// Das Verzeichnis des vendorten Forschungscodes.
inline constexpr std::string_view LIZENZ_VENDOR_WURZEL = "Forschungsarbeiten/code";

// DIE UNTERGRENZE DER MARKER-AUSSAGEKRAFT, in Zeichen nach Rand-Trimmung.
// DREI ist die Laenge der kuerzesten wirklichen Lizenz-Bezeichnung ueberhaupt
// (MIT, ISC, GPL, BSD); kuerzer kann ein Marker nicht sein und trotzdem eine
// Lizenz benennen. Am Objekt gemessen (11.08., alle 11 Marker der NOTICE): der
// kuerzeste in Gebrauch ist 11 Byte ("ISC License" / "MIT License") -- die
// Schranke schneidet also KEINEN heutigen Eintrag und faengt jeden entarteten.
inline constexpr std::size_t LIZENZ_MARKER_MIN_ZEICHEN = 3;

// DIE NEGATIV-KONTROLLE DER MARKER-AUSSAGEKRAFT.
// Ein Marker, der selbst nur ein Baustein ist, den ohnehin jeder Text traegt,
// sichert NICHTS zu: er steht in jeder Datei und kann nie reissen. Genau das
// war der am 11.08. gemessene Befund -- ein Marker aus EINEM LEERZEICHEN lief
// gruen durch. Diese Zeichenkette ist die Liste dieser Bausteine; ein Marker,
// der als TEILKETTE darin vorkommt, ist zurueckgewiesen. Die Richtung ist
// wichtig: geprueft wird "Kontrolle enthaelt Marker", nicht umgekehrt --
// "Apache License" faellt deshalb NICHT darunter, "Apache" allein schon.
inline constexpr std::string_view LIZENZ_MARKER_GEGENPROBE =
    " \t\r\n.,;:-_/\\()[]{}<>\"'`*+=&#%!?|~^$@0123456789"
    " the The THE and And AND or Or of Of for For in In to To is Is are Are be Be by By"
    " with With a A an An as As at At on On not Not no No all All any Any this This that That"
    " License license LICENSE Licence licence Lizenz LIZENZ Copyright copyright COPYRIGHT"
    " Version version VERSION Software software Public public General general Free free"
    " GNU MIT BSD ISC Apache GPL LGPL AGPL MPL EPL CC0 SPDX"
    // Die nackten Versionsnummern. Sie kamen erst durch den eigenen Fall K16 in
    // diese Liste: "2.0" lief durch, obwohl es in jedem zweiten Lizenztext steht.
    // Ein zusammengesetzter Marker wie "Version 2.0" bleibt zulaessig -- er ist
    // hier nirgends als zusammenhaengende Teilkette enthalten.
    " 1.0 1.1 2.0 2.1 3.0 4.0 v1 v2 v3";

// Die .gitignore, aus der die Skip-Liste des SPDX-Scans ABGELEITET wird.
// Sie steht hier als PFAD und nicht als abgeschriebene Liste, weil eine
// abgeschriebene Liste genau der Defekt war: der Kommentar behauptete "genau die
// zwei Verzeichnisklassen, die .gitignore ohnehin ausschliesst", waehrend
// Code/.gitignore VIER traegt (build/, build-*/, cmake-build-*/, _runs/). Die
// CI baut nach Code/build-test und Code/build-test-debug -- am Objekt gemessen
// (11.08.) stieg der SPDX-Nenner damit von 26 auf 39, und die Wache las
// GENERIERTE Bauartefakte, als waeren sie Repo-Quelle.
inline constexpr std::string_view LIZENZ_CODE_GITIGNORE = "Code/.gitignore";

// Der EINZIGE fest verdrahtete Skip -- und er hat einen eigenen Grund, der nicht
// aus .gitignore kommt: Fremdcode ist nicht Gegenstand der SPDX-Uniformitaet.
// Code/external/ ist getrackt und steht deshalb in KEINER .gitignore.
inline constexpr std::string_view LIZENZ_SPDX_SKIP_FEST = "external";

// DIE ZEILENGRAMMATIK.
//
// SPALTE 0 BINDET: nur eine Zeile, die OHNE Einrueckung mit WACHE: beginnt, ist
// ein Eintrag. Eine eingerueckte WACHE:-Zeile ist Text. Das ist der Grund, aus
// dem die NOTICE ihre eigene Grammatik erklaeren darf, ohne sich dabei selbst
// als Eintrag zu zaehlen -- am Bautag gemessen: ohne diese Regel las die Wache
// 6 SUBMODUL-Eintraege statt 4 und 10 VENDOR-Eintraege statt 9, weil der
// Erklaerungsblock der Datei mitgezaehlt wurde. Dieselbe Regel wie im
// ci_yml_scanner (Spalte 0 trennt).
//
// Beide Pfadangaben sind RELATIV, und zwar aus einem gemessenen Grund: mit
// repo-relativen Pfaden trug die laengste Zeile 145 Byte (Bautag 11.08.
// nachgerechnet) und riss damit die 120-Byte-Norm des Hauses.
//   * <pfad>     Submodul: repo-relativ (so steht er in .gitmodules).
//                Vendor:   relativ zu LIZENZ_VENDOR_WURZEL.
//   * <relpfad>  IMMER relativ zu <pfad>, also zur Wurzel der benannten
//                Komponente. Das ist auch die natuerliche Lesart: die
//                Lizenzdatei gehoert zu IHREM Projekt, nicht zum super.
// Zusammengesetzt wird an EINER Stelle: lizenzdatei_pfad() weiter unten. Kern
// und Sammler benutzen dieselbe Funktion -- eine Abschrift waere eine
// Gelegenheit zur Divergenz.
enum class NoticeArt {
    Submodul,                // WACHE: SUBMODUL <pfad> LIZENZ "<marker>" DATEI <relpfad>
    SubmodulOhneLizenzdatei, // WACHE: SUBMODUL <pfad> KEINE-LIZENZDATEI
    Vendor,                  // WACHE: VENDOR <pfad> LIZENZ "<marker>" DATEI <relpfad>
};

struct NoticeEintrag {
    NoticeArt   art = NoticeArt::Submodul;
    std::string pfad;
    std::string marker;      // leer bei SubmodulOhneLizenzdatei
    std::string lizenzdatei; // relativ zu `pfad`; leer bei SubmodulOhneLizenzdatei
    std::size_t zeile       = 0;
    bool        wohlgeformt = false; // false = die Zeile trug WACHE:, war aber unlesbar
};

struct SubmodulAmBaum {
    bool ausgecheckt = false; // Verzeichnis existiert und ist NICHT leer
    // ALLE LICENSE*/LICENCE*/COPYING* an der Submodul-Wurzel, lexikografisch
    // sortiert. Frueher stand hier ein blosses bool -- damit liess sich die
    // DATEI-Bindung (Zusicherung 2) gar nicht formulieren, denn "es liegt EINE
    // Lizenzdatei da" sagt nichts darueber, ob es DIE in NOTICE benannte ist.
    // Am Objekt sind es fuer die cache-engine ZWEI (LICENSE, LICENSE_AUDIT_EXT.md)
    // -- ein bool haette hier ohnehin die falsche Kardinalitaet.
    std::vector<std::string> lizenzdateien;
};

struct SpdxFund {
    std::string datei;
    std::string wert;
};

// Die aus einer .gitignore gelesenen VERZEICHNIS-Muster. Was die Form nicht
// trifft, wird nicht stillschweigend verworfen, sondern in `unverstanden`
// PROTOKOLLIERT -- ein stiller Verzicht waere genau die verdeckte Null, gegen
// die diese Wache gebaut ist.
struct GitignoreMuster {
    // Verzeichnisname ohne Schraegstrich, hoechstens EIN '*' und nur am Ende.
    std::vector<std::string> verzeichnisse;
    // Verzeichnismuster, die diese Form NICHT treffen (Negation, innerer '/',
    // '*' in der Mitte). Sie wirken nicht und stehen deshalb in der Ausgabe.
    std::vector<std::string> unverstanden;
};

// ALLES, was die Wache von der Platte braucht -- als WERTE hereingereicht. Der
// Pruefkern unten fasst kein Dateisystem an; deshalb ist jeder Fall aus dem Test
// heraus konstruierbar, auch die, die man am echten Baum nie herstellen koennte.
struct LizenzEingang {
    bool        notice_vorhanden = false; // false = die Datei fehlt (nicht: sie ist leer)
    std::string notice_text;
    std::string gitmodules_text;
    std::string license_text;
    std::string code_gitignore_text; // Quelle der SPDX-Skip-Liste, s. LIZENZ_CODE_GITIGNORE
    // Pfad (repo-relativ, wie in .gitmodules) -> Zustand am Arbeitsbaum
    std::map<std::string, SubmodulAmBaum> submodule_am_baum;
    // Projektname UNTER LIZENZ_VENDOR_WURZEL -> ALLE Lizenzdateien relativ zum
    // Projekt, sortiert. Eine Liste statt einer einzelnen Datei, weil die
    // DATEI-Bindung fragt "ist die BENANNTE Datei eine davon?" -- eine Auswahl
    // haette diese Frage vorweggenommen.
    std::map<std::string, std::vector<std::string>> vendor_am_baum;
    // REPO-RELATIVER Pfad (Ergebnis von lizenzdatei_pfad) -> Dateiinhalt
    std::map<std::string, std::string> dateiinhalt;
    std::vector<SpdxFund>              spdx_funde;
    // Wieviele regulaere Dateien der SPDX-Scan ueberhaupt angefasst hat. Der
    // Zaehler spdx_funde.size() ohne diese Grundgesamtheit ist eine nackte Zahl.
    std::size_t spdx_gescannt = 0;
    // Die vom Scan uebersprungenen Verzeichnisse, REPO-RELATIV. Sie erklaeren
    // den Nenner und gehoeren deshalb in die Ausgabe, nicht in einen Kommentar.
    std::vector<std::string> spdx_uebersprungen;
    // Verzeichnismuster aus Code/.gitignore, die nicht ausgewertet werden konnten.
    std::vector<std::string> gitignore_unverstanden;
};

enum class BefundArt {
    NoticeFehlt,
    NoticeZeileUnlesbar,
    // Zeilennorm (Zusicherung 6). Sie heissen Text*, nicht Notice*, weil sie
    // BEIDE Dokumente decken -- NOTICE und die Wurzel-LICENSE. Ein Name, der
    // nur die Haelfte seines Gegenstands nennt, ist ein Name, der luegt.
    TextZeileZuLang,
    TextZeileNichtAscii,
    SubmodulOhneNoticeZeile,
    NoticeZeileOhneSubmodul,
    // Deckt BEIDE Zeilenformen: die genannte Lizenzdatei fehlt am Baum, oder das
    // genannte Vendor-Projekt gibt es dort nicht. Beides ist dieselbe Klasse --
    // NOTICE behauptet einen Gegenstand, den der Arbeitsbaum nicht hergibt.
    NoticeZeileOhneLizenzdatei,
    // Die DATEI-BINDUNG (Zusicherung 2, zweite Haelfte): die benannte Datei gibt
    // es zwar, sie ist an dieser Komponenten-Wurzel aber gar keine Lizenzdatei.
    NoticeDateiIstKeineLizenzdatei,
    MarkerNichtInLizenzdatei,
    // Der Marker taugt nicht als Zusicherung (Zusicherung 7).
    MarkerOhneAussagekraft,
    KeineLizenzdateiObwohlVorhanden,
    VendorProjektOhneNoticeZeile,
    // "GENAU EINE" (Zusicherung 1): NOTICE nennt denselben Pfad mehrfach.
    NoticeZeileMehrfach,
    // Die Gegenrichtung: .gitmodules selbst nennt denselben Pfad mehrfach.
    GitmodulesPfadMehrfach,
    WurzelLizenzOhneApacheMarker,
    WurzelLizenzOhneKlauselMarker,
    SpdxAbweichler,
    NennerNull,
};

struct Befund {
    BefundArt   art = BefundArt::NoticeFehlt;
    std::string text; // traegt den LITERALEN Fehltext, an dem die Koeder gemessen werden
};

struct LizenzErgebnis {
    // fail-closed: wer vergisst, den Status zu setzen, bekommt Abbruch -- nie Gruen.
    WacheStatus              status = WacheStatus::Abbruch;
    std::vector<Befund>      befunde;
    std::vector<std::string> skips; // protokollierte Verzichte (nicht ausgecheckt)

    // DIE NENNER. Sie gehoeren in die AUSGABE, nicht nur in den Kopf des Autors.
    std::size_t nenner_gitmodules = 0;
    std::size_t nenner_vendor     = 0;
    std::size_t nenner_spdx       = 0;
    // Die Grundgesamtheit von nenner_spdx: alle vom Scan angefassten Dateien.
    // "26" allein ist eine nackte Zahl; "26 von 187" traegt seine Herkunft mit.
    std::size_t nenner_code_dateien    = 0;
    std::size_t nenner_notice_submodul = 0;
    std::size_t nenner_notice_vendor   = 0;
};

// -- Der Pruefkern: drei reine Funktionen, kein Dateizugriff -------------------

// Die `path = `-Werte aus einer .gitmodules. Reihenfolge wie im Text.
std::vector<std::string> parse_gitmodules(std::string_view text);

// Alle Zeilen, die mit dem Marker WACHE: beginnen (nach fuehrendem Rand). Eine
// Zeile, die WACHE: traegt aber der Grammatik nicht folgt, kommt mit
// wohlgeformt=false zurueck -- sie wird NICHT stillschweigend verworfen.
std::vector<NoticeEintrag> parse_notice(std::string_view text);

// Der REPO-RELATIVE Pfad der von einem Eintrag benannten Lizenzdatei. DIE EINE
// Stelle, an der die relativen Angaben der Zeile zusammengesetzt werden -- vom
// Pruefkern UND vom Sammler benutzt. Leer, wenn der Eintrag keine Datei nennt.
std::string lizenzdatei_pfad(const NoticeEintrag& eintrag);

// Traegt dieser Marker ueberhaupt eine Zusicherung? Siehe Zusicherung (7).
// Oeffentlich, damit der Test das Orakel DIREKT fahren kann und nicht ueber den
// Umweg eines vollen pruefe()-Laufes raten muss (T-5).
bool marker_ist_aussagekraeftig(std::string_view marker);

// Die VERZEICHNIS-Muster einer .gitignore. Dateimuster (Zeilen ohne
// abschliessenden '/') sind nicht Gegenstand und fallen still heraus -- alles
// andere, was die unterstuetzte Form verfehlt, landet in `unverstanden`.
GitignoreMuster parse_gitignore(std::string_view text);

// Trifft `muster` (Name oder Name mit genau EINEM '*' am Ende) diesen
// Verzeichnisnamen? Dieselbe Funktion, die der Sammler benutzt -- eine
// Abschrift waere eine Gelegenheit zur Divergenz.
bool passt_verzeichnismuster(std::string_view name, std::string_view muster);

LizenzErgebnis pruefe(const LizenzEingang& eingang);

// Fuer lesbare EXPECT-Ausgaben statt nackter Zahlen (dieselbe Begruendung wie
// operator<< in ergebnis.hpp).
std::string befund_name(BefundArt art);
bool        hat_befund(const LizenzErgebnis& ergebnis, BefundArt art);
std::string ergebnis_bericht(const LizenzErgebnis& ergebnis);

// -- Die Naht zum Dateisystem: AUSDRUECKLICH NICHT Teil des Pruefkerns ---------
// Sie liest den Arbeitsbaum unter `wurzel` und baut daraus einen LizenzEingang.
// Der SPDX-Scan ueberspringt Code/external/ (LIZENZ_SPDX_SKIP_FEST, eigener
// Grund: Fremdcode) und jede Verzeichnisklasse, die Code/.gitignore
// ausschliesst. Die Skip-Liste wird aus dieser Datei ABGELEITET und jedes
// tatsaechlich uebersprungene Verzeichnis in spdx_uebersprungen protokolliert;
// eine abgeschriebene Liste war der Defekt, den das ersetzt.
LizenzEingang sammle_vom_baum(const std::filesystem::path& wurzel);

} // namespace comdare::ci_wachen

#endif // COMDARE_CI_WACHEN_LIZENZ_KONSISTENZ_HPP
