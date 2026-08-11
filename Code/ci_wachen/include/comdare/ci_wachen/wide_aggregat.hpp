// wide_aggregat.hpp -- die EINE WIDE-Konkatenation der Mess-Kette, als Bibliothek.
//                                                                        (2026-08-10)
// =============================================================================
// WORUM ES GEHT -- und was am Objekt schon erledigt war, bevor dieses Modul entstand:
//
// Der Auftrag lautete "drei Kopien derselben Logik zu einer machen". Die drei Kopien
// gab es wirklich (ci/anhang_forward_core.sh und die zwei measure-Jobs der
// .gitlab-ci.yml); sie sind am 09.08. in ci/wide_aggregat.sh zusammengezogen worden.
// AM OBJEKT NACHGEMESSEN (10.08., am Elternstand 97fa074a^): die drei Schleifen waren
// nach Normalisierung von Einrueckung und Variablenname BYTE-IDENTISCH -- es war
// Kopier-Duplikation, KEINE Verhaltens-Divergenz.
//
// MIT EINER AUSNAHME, die eine Zwei-Zeilen-Betrachtung nicht sieht: die Kern-Kopie las
// ihre Liste per bash-Prozess-Substitution (`done < <(af_finde_result_csv ... | sort)`),
// die beiden YAML-Kopien aus einer Datei. Die Kern-Kopie war damit bash-only und unter
// `sh` gar nicht lauffaehig -- ein Dialekt-Unterschied, kein Ergebnis-Unterschied. Die
// Vereinigung hat ihn beseitigt: alle drei schreiben heute erst eine Liste.
//
// -----------------------------------------------------------------------------
// WAS HIER NEU IST -- DER NENNER (V-1)
// -----------------------------------------------------------------------------
// Die vereinigte Shell-Fassung gab DREI Zahlen aus: WIDE_ZEILEN, WIDE_DATEN,
// WIDE_HEADER. Keine davon nennt die GRUNDGESAMTHEIT. Am Objekt gemessen (10.08.,
// gewuerfelter Koeder je Aufrufweg): eine Liste mit VIER Eintraegen -- eine 0-Byte-CSV,
// zwei volle, eine die zwischen `find` und `read` verschwunden war -- lieferte
//     WIDE_ZEILEN=3 WIDE_DATEN=2 WIDE_HEADER=ja       rc=0
// Die verschwundene Datei war NICHT von "es gab sie nie" zu unterscheiden. Der Grund
// ist K11 in Reinform: `tail -n +2 "$f" | awk 1 >> "$WIDE"` liefert den Status des
// LETZTEN Pipe-Glieds, und awk gelingt immer. `set -e` sieht nichts, rc bleibt 0.
// Das ist genau die Klasse, gegen die die Kette gebaut ist ("ein Messwert, der hier
// verschwindet, kostet Tage Rechenzeit") -- und sie sass IN der Heilung.
//
// Deshalb traegt das Ergebnis hier seinen Nenner: quellen == mit_daten + ohne_daten +
// nicht_lesbar. Die Identitaet wird nicht behauptet, sie wird geprueft (nenner_haelt()),
// und eine verletzte Identitaet ist ein Abbruch, nie ein Gruen.
//
// -----------------------------------------------------------------------------
// DIE VIER GEHEILTEN DEFEKTE, DIE HIER WOHNEN
// -----------------------------------------------------------------------------
//  (F2) Zaehlweise: gezaehlt werden DATENSAETZE (awk NR), nicht Zeilenumbrueche.
//       Kopfzeile + eine Datenzeile ohne Schluss-Newline ergaben mit `wc -l` die 1 und
//       galten als leer.
//  (F3) Konkatenation: jeder Datensatz wird mit Zeilenende ausgegeben (awk 1). Ohne das
//       klebte die erste Datenzeile der naechsten Datei an die letzte der vorigen --
//       und der fehlende Schluss-Newline ist der REGELFALL, ce schreibt so.
//  (F4) Header-Dieb: die Kopfzeile darf nur von einer Datei mit Groesse > 0 kommen.
//       Eine 0-Byte-CSV, die im `sort` vorne liegt, setzte sonst "Header ist da",
//       und die volle Datei danach kam nur noch durch `tail -n +2`.
//  (F5) NEU, 10.08.: eine gelistete Datei, die nicht lesbar ist, ist ein ABBRUCH.
//       Vorher verschwand sie still (s. o.).
//
// -----------------------------------------------------------------------------
// NICHT ZUGESICHERT -- ausdruecklich benannt, damit niemand mehr hineinliest
// -----------------------------------------------------------------------------
//   * dass die Kopfzeilen aller Dateien GLEICH sind. Der Header wird EINMAL von der
//     ersten Datei mit Inhalt genommen; abweichende Spalten faende hier niemand.
//   * dass eine Datei mit Groesse > 0 eine BRAUCHBARE Kopfzeile hat. Eine Datei aus
//     einem einzelnen Newline liefert eine leere. Geprueft wird die HERKUNFT.
//   * die REIHENFOLGE. Sortiert wird vom AUFRUFER, bevor er die Liste schreibt.
//   * die AUSWAHL der Dateien. Welcher Glob welche CSV findet, bleibt beim Aufrufer.
//   * das URTEIL ueber die Zahl. "Leer" ist hier KEIN Fehler, sondern eine Zahl; der
//     Anhang-Kern nennt es honest-empty, die measure-Jobs ueberspringen die
//     Anhang-Regenerierung. Zwei Urteile ueber dieselbe Zahl, nur die Zahl ist gemeinsam.
//
// -----------------------------------------------------------------------------
// WARUM C++ UND NICHT NOCH EINE SHELL-ZEILE (Owner-KERN 09.08.)
// -----------------------------------------------------------------------------
//   "Ich sehe einen Haufen shells statt vernuenftiger google tests, was soll das? ...
//    SKRIPTE SAGEN GAR NICHTS. ... also die C++ Implementierung dazu."
// Diese Fassung ist die STUFE 1 des Umbaus, dieselbe Form wie xml_wellformed und
// gitlink_parity: Bibliothek + duennes Binary + Google Test in Debug UND Release.
// Die drei Produktions-Aufrufstellen rufen weiterhin ci/wide_aggregat.sh -- der Schwenk
// ist Stufe 2 und ausdruecklich Lead-Entscheid (bei den zwei Vorgaengern ist er einen
// Tag spaeter immer noch nicht getroffen). Bis dahin ist diese Fassung der FREMDE
// NENNER der Shell-Fassung (V-7): der Test faehrt beide ueber dieselbe gewuerfelte
// Population und fordert Byte-Gleichheit. Divergieren sie, ist der Test rot -- und
// zwar bevor eine Messung daran verlorengeht.
//
// Selbstcheck: der CLI-Vertrag (3 Argumente, Exit 0/2, Kennzahlen-Datei mit
// WIDE_ZEILEN/WIDE_DATEN/WIDE_HEADER an erster Stelle) ist hier und in
// ci/wide_aggregat.sh derselbe; wer einen von beiden aendert, macht
// WideFall.ParitaetShellUndCppUeberEineGewuerfeltePopulation rot.
//
// ASCII-only, Zeilen <= 120 Byte.
// =============================================================================

#ifndef COMDARE_CI_WACHEN_WIDE_AGGREGAT_HPP
#define COMDARE_CI_WACHEN_WIDE_AGGREGAT_HPP

#include <cstdint>
#include <filesystem>
#include <optional>
#include <ostream>
#include <string>
#include <vector>

#include "comdare/ci_wachen/ergebnis.hpp"

namespace comdare::ci_wachen {

// Was eine gelistete Quelle beigetragen hat. Die drei Werte sind DISJUNKT und
// erschoepfend -- daraus entsteht der Nenner, und deshalb kann er nicht "fast stimmen".
enum class QuellBefund {
    MitDaten,    // lesbar, hat mindestens einen Datensatz nach der Kopfzeile beigetragen
    OhneDaten,   // lesbar, hat KEINEN Datensatz beigetragen (0 Byte oder nur Kopfzeile)
    NichtLesbar, // steht in der Liste, ist aber keine lesbare regulaere Datei -- F5
};

inline constexpr QuellBefund alle_quell_befunde[] = {
    QuellBefund::MitDaten,
    QuellBefund::OhneDaten,
    QuellBefund::NichtLesbar,
};
static_assert(sizeof(alle_quell_befunde) / sizeof(alle_quell_befunde[0]) == 3,
              "QuellBefund hat einen neuen Wert -- Tabelle, Nenner-Identitaet und Fall-Tabellen nachziehen.");

// Warum nicht aggregiert werden konnte. Vier unterscheidbare Gruende statt eines
// Sammel-rc -- dieselbe Lehre wie in ergebnis.hpp: kollidierende Zweige sind hier
// nicht "besser getestet", sie sind nicht mehr formulierbar.
enum class AggregatAbbruchGrund {
    ListeFehlt, // die Listendatei selbst ist nicht lesbar
    ZielNichtSchreibbar,
    QuelleNichtLesbar, // >= 1 gelistete Datei fehlt/ist unlesbar -> das Aggregat ist unvollstaendig
    NennerVerletzt,    // die Identitaet quellen == mit+ohne+nicht_lesbar haelt nicht (Selbstcheck)
};

inline constexpr AggregatAbbruchGrund alle_aggregat_abbruch_gruende[] = {
    AggregatAbbruchGrund::ListeFehlt,
    AggregatAbbruchGrund::ZielNichtSchreibbar,
    AggregatAbbruchGrund::QuelleNichtLesbar,
    AggregatAbbruchGrund::NennerVerletzt,
};
static_assert(sizeof(alle_aggregat_abbruch_gruende) / sizeof(alle_aggregat_abbruch_gruende[0]) == 4,
              "AggregatAbbruchGrund hat einen neuen Wert -- Tabelle und Fall-Tabellen nachziehen.");

struct QuellErgebnis {
    std::string  pfad;
    QuellBefund  befund      = QuellBefund::NichtLesbar; // fail-closed als Vorgabe
    std::int64_t datensaetze = 0;                        // beigetragene Datenzeilen (ohne Kopfzeile)
};

struct WideErgebnis {
    WacheStatus status = WacheStatus::Abbruch; // fail-closed als Vorgabe

    // Die drei Zahlen des ALTEN Vertrags -- Reihenfolge und Namen sind bindend.
    std::int64_t zeilen = 0;     // WIDE_ZEILEN  -- Datensaetze im Aggregat (awk NR)
    std::int64_t daten  = 0;     // WIDE_DATEN   -- ohne Kopfzeile
    bool         header = false; // WIDE_HEADER  -- ja/nein

    // DER NENNER (V-1). Er ist neu und ausdruecklich Teil der AUSGABE, nicht nur des
    // Protokolls: ohne ihn ist WIDE_DATEN=0 nicht von "es gab nichts zu tun" zu trennen.
    std::int64_t quellen      = 0; // nicht-leere Zeilen der Liste = die Grundgesamtheit
    std::int64_t mit_daten    = 0;
    std::int64_t ohne_daten   = 0;
    std::int64_t nicht_lesbar = 0;

    std::vector<QuellErgebnis>          je_quelle;
    std::optional<AggregatAbbruchGrund> abbruch;
    std::string                         abbruch_detail;

    // Der Selbstcheck des Nenners. Er wird in aggregiere() gefahren; eine Verletzung
    // ist Abbruch. Hier oeffentlich, damit ein Test ihn unabhaengig nachrechnen kann.
    bool nenner_haelt() const { return quellen == mit_daten + ohne_daten + nicht_lesbar; }

    // Die Kennzahlen-Datei, per '.' einlesbar -- BYTE-GLEICH zu ci/wide_aggregat.sh.
    // Die drei alten Schluessel stehen zuerst und unveraendert; der Nenner haengt hinten
    // an. Ein Aufrufer, der nur die alten drei liest, merkt vom Umbau nichts.
    std::string kennzahlen() const;

    // Menschenlesbare Zeile fuer das Job-Log. Traegt IMMER den Nenner.
    std::string protokoll() const;
};

// Der Aggregator. Liest <liste> zeilenweise, schreibt <ziel_wide> neu und liefert die
// Kennzahlen. Er ENTSCHEIDET NICHT, ob "leer" ein Fehler ist -- das bleibt beim Aufrufer.
WideErgebnis aggregiere(const std::filesystem::path& liste, const std::filesystem::path& ziel_wide);

std::string quell_befund_text(QuellBefund befund);
std::string aggregat_abbruch_text(AggregatAbbruchGrund grund);

inline std::ostream& operator<<(std::ostream& strom, QuellBefund befund) { return strom << quell_befund_text(befund); }
inline std::ostream& operator<<(std::ostream& strom, AggregatAbbruchGrund grund) {
    return strom << aggregat_abbruch_text(grund);
}

} // namespace comdare::ci_wachen

#endif // COMDARE_CI_WACHEN_WIDE_AGGREGAT_HPP
