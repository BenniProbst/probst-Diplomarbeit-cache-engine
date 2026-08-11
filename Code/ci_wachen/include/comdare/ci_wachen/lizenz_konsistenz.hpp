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
//   (1) Jeder .gitmodules-Pfad hat genau eine WACHE:-Zeile in NOTICE und umgekehrt.
//   (2) Der in NOTICE behauptete Lizenz-Marker steht WOERTLICH in der dort
//       benannten Lizenzdatei -- die Behauptung wird am Text gemessen.
//   (3) Jedes Vendor-Projekt unter Forschungsarbeiten/code/ MIT Lizenzdatei hat
//       eine WACHE:-Zeile. Ein neu hinzugefuegtes Fremdprojekt wird damit rot,
//       bis es in NOTICE steht.
//   (4) Die Wurzel-LICENSE traegt die Apache-Marker UND den Titel des
//       Geltungs-Abschnitts (LIZENZ_KLAUSEL_MARKER, s.u.).
//   (5) Alle SPDX-Zeilen unter Code/ (ohne Code/external/) lauten Apache-2.0.
//
// WAS SIE NICHT ZUSICHERT -- TESTKRITIK (T-9), ausdruecklich statt verschwiegen:
//   * Der Marker ist eine SUBSTRING-PROBE, keine juristische Textanalyse. Sie
//     erkennt einen Lizenz-WECHSEL (der Titel aendert sich), aber NICHT jeden
//     Versions-Wechsel innerhalb derselben Familie: die vier Boilerplate-Texte
//     (Apache, GPL) tragen ihren Titel in Zeile 1 und ihre Version erst in Zeile
//     2. Wer GPLv3 gegen GPLv2 tauscht, laesst den Titel-Marker stehen. Diese
//     Luecke ist benannt, nicht geschlossen.
//   * NICHT AUSGECHECKTE SUBMODULE werden nur GEPAART, nicht inhaltsgeprueft.
//     Sonst waere die Wache auf jedem Klon ohne `git submodule update` konstant
//     rot -- gegen die Doktrin "die Pipeline ist immer hart gruen". Am Objekt
//     sind beide Thesis-Einbindungen leer (ls -A je 0 Eintraege). Der Verzicht
//     wird als SKIP-Zeile PROTOKOLLIERT, nie stillschweigend genommen.
//   * Sie liest den ARBEITSBAUM, nicht die Historie. Was einmal in einem alten
//     Commit stand, ist ihr Gegenstand nicht.
//   * Der SPDX-Scan liest je Datei nur den KOPF (LIZENZ_SPDX_KOPF_BYTE). Eine
//     SPDX-Zeile tief im Rumpf sieht er nicht; die Hauskonvention setzt sie in
//     Zeile 1.
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

// Die Hoechstlaenge einer NOTICE-Eintragszeile. Dieselbe Schranke wie die
// Diff-Hygiene-Wache und die .clang-format des Repos (ColumnLimit: 120).
inline constexpr std::size_t LIZENZ_ZEILE_MAX_BYTE = 120;

// Das Verzeichnis des vendorten Forschungscodes.
inline constexpr std::string_view LIZENZ_VENDOR_WURZEL = "Forschungsarbeiten/code";

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
    NoticeArt   art  = NoticeArt::Submodul;
    std::string pfad;
    std::string marker;      // leer bei SubmodulOhneLizenzdatei
    std::string lizenzdatei; // relativ zu `pfad`; leer bei SubmodulOhneLizenzdatei
    std::size_t zeile     = 0;
    bool        wohlgeformt = false; // false = die Zeile trug WACHE:, war aber unlesbar
};

struct SubmodulAmBaum {
    bool ausgecheckt     = false; // Verzeichnis existiert und ist NICHT leer
    bool hat_lizenzdatei = false; // LICENSE*/COPYING* an der Submodul-Wurzel
};

struct SpdxFund {
    std::string datei;
    std::string wert;
};

// ALLES, was die Wache von der Platte braucht -- als WERTE hereingereicht. Der
// Pruefkern unten fasst kein Dateisystem an; deshalb ist jeder Fall aus dem Test
// heraus konstruierbar, auch die, die man am echten Baum nie herstellen koennte.
struct LizenzEingang {
    bool        notice_vorhanden = false; // false = die Datei fehlt (nicht: sie ist leer)
    std::string notice_text;
    std::string gitmodules_text;
    std::string license_text;
    // Pfad (repo-relativ, wie in .gitmodules) -> Zustand am Arbeitsbaum
    std::map<std::string, SubmodulAmBaum> submodule_am_baum;
    // Projektname UNTER LIZENZ_VENDOR_WURZEL -> Lizenzdatei relativ zum Projekt
    std::map<std::string, std::string> vendor_am_baum;
    // REPO-RELATIVER Pfad (Ergebnis von lizenzdatei_pfad) -> Dateiinhalt
    std::map<std::string, std::string> dateiinhalt;
    std::vector<SpdxFund>              spdx_funde;
};

enum class BefundArt {
    NoticeFehlt,
    NoticeZeileUnlesbar,
    NoticeZeileZuLang,
    SubmodulOhneNoticeZeile,
    NoticeZeileOhneSubmodul,
    // Deckt BEIDE Zeilenformen: die genannte Lizenzdatei fehlt am Baum, oder das
    // genannte Vendor-Projekt gibt es dort nicht. Beides ist dieselbe Klasse --
    // NOTICE behauptet einen Gegenstand, den der Arbeitsbaum nicht hergibt.
    NoticeZeileOhneLizenzdatei,
    MarkerNichtInLizenzdatei,
    KeineLizenzdateiObwohlVorhanden,
    VendorProjektOhneNoticeZeile,
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
    std::size_t nenner_gitmodules      = 0;
    std::size_t nenner_vendor          = 0;
    std::size_t nenner_spdx            = 0;
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

LizenzErgebnis pruefe(const LizenzEingang& eingang);

// Fuer lesbare EXPECT-Ausgaben statt nackter Zahlen (dieselbe Begruendung wie
// operator<< in ergebnis.hpp).
std::string befund_name(BefundArt art);
bool        hat_befund(const LizenzErgebnis& ergebnis, BefundArt art);
std::string ergebnis_bericht(const LizenzErgebnis& ergebnis);

// -- Die Naht zum Dateisystem: AUSDRUECKLICH NICHT Teil des Pruefkerns ---------
// Sie liest den Arbeitsbaum unter `wurzel` und baut daraus einen LizenzEingang.
// Uebersprungen werden dabei genau die zwei Verzeichnisklassen, die .gitignore
// (Z.10 `build/`, Z.23 `cmake-build-*/`) ohnehin ausschliesst, sowie
// Code/external/ -- Fremdcode ist nicht Gegenstand der SPDX-Uniformitaet.
LizenzEingang sammle_vom_baum(const std::filesystem::path& wurzel);

} // namespace comdare::ci_wachen

#endif // COMDARE_CI_WACHEN_LIZENZ_KONSISTENZ_HPP
