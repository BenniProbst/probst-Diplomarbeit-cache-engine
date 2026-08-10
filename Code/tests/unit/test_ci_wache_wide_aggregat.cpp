// test_ci_wache_wide_aggregat.cpp -- die WIDE-Konkatenation als Pruefling. (2026-08-10)
// =============================================================================
// POSTEN #29. DER AUFTRAG WAR "drei Kopien derselben Logik zu einer machen", und die
// entscheidende Vorfrage war: identisch (Aufraeum-Aufgabe) oder divergent (DEFEKT)?
//
// GEMESSEN, NICHT GEGLAUBT (10.08., am Elternstand 97fa074a^): die drei Schleifen waren
// nach Normalisierung von Einrueckung und Variablenname byte-identisch -- Kopier-
// Duplikation, keine Verhaltens-Divergenz. Die Vereinigung in ci/wide_aggregat.sh war
// am 09.08. bereits vollzogen. WAS FEHLTE, war etwas anderes und Schlimmeres:
//
//   DIE AUSGABE HATTE KEINEN NENNER. Am Objekt gemessen, mit gewuerfeltem Koeder je
//   Aufrufweg: eine Liste aus VIER Eintraegen -- eine 0-Byte-CSV, zwei volle, eine
//   zwischen `find` und `read` verschwundene -- lieferte auf ALLEN DREI Aufrufwegen
//       WIDE_ZEILEN=3  WIDE_DATEN=2  WIDE_HEADER=ja        rc=0
//   und auf stderr eine einzige `tail: cannot open ...`-Zeile, die in einem CI-Log mit
//   tausenden Zeilen niemand sieht. "Die Datei war weg" und "es gab sie nie" waren
//   NICHT unterscheidbar. Ursache ist K11 in Reinform: `tail ... | awk 1` liefert den
//   Status des LETZTEN Pipe-Glieds, awk gelingt immer, `set -e` sieht nichts.
//
// -----------------------------------------------------------------------------
// WAS DIESE SUITE ZUSICHERT -- und wie sie es tut
// -----------------------------------------------------------------------------
// (1) DIE C++-FASSUNG (Stufe 1 des Owner-KERN-Umbaus) haelt F2/F3/F4/F5, jeweils MIT
//     GEGENEINGANG (T-4): zu jeder Zusicherung ein Eingang, bei dem sie NICHT gilt.
//
// (2) PARITAET SHELL <-> C++ (V-7, der fremde Nenner). Beide Fassungen fahren dieselbe
//     gewuerfelte Population, und gefordert wird BYTE-Gleichheit des Aggregats, des
//     Kennzahlen-Inhalts und des Exit-Codes. Keine der beiden ist ihr eigener Nenner:
//     die Zahlen der Shell werden gegen eine ANDERE Implementierung gehalten, nicht
//     gegen sich selbst. Divergieren sie, ist das rot -- und das ist die Antwort auf
//     die Kernfrage des Postens, dauerhaft und maschinell statt einmalig und erzaehlt.
//
// (3) DIE DREI AUFRUFWEGE liefern dasselbe. Sie werden nicht behauptet, sondern
//     GEFAHREN: die Konventionen von ci/anhang_forward_core.sh (Liste in AF_TMP),
//     measure:smoke (measure_out_smoke/_rc_list.txt) und measure:golden-320
//     (measure_out/_rc_list.txt) laufen ueber DIESELBE Population mit DREI
//     verschiedenen, je Lauf gewuerfelten Koedern; verglichen wird nach Maskierung
//     des jeweils eigenen Koeders.
//
// (4) DER ZWILLINGS-RIEGEL. Die Konkatenation ist im Baum GENAU EINMAL IMPLEMENTIERT.
//     Gemessen wird diese AUSSAGE, nicht das Vorkommen einer Zeichenkette: Kommentare
//     und zitierte Zeichenketten werden abgezogen, bevor gezaehlt wird. Der Nenner steht
//     in der Meldung, und ein Positiv-Test nennt die Datei, die gefunden werden MUSS.
//     Die ausfuehrliche Begruendung -- samt der zwei Defekte, die der Riegel bis zum
//     10.08.2026 hatte -- steht unmittelbar vor Abschnitt (4) weiter unten.
//
// (5) DER NENNER-RIEGEL (Posten M4). Der Riegel aus (4) zaehlt Implementierungen; der
//     NENNER, ueber dem er zaehlt, war bis zum 10.08.2026 selbst unbewacht. Wer den Gang
//     verkuerzt, bekam weiter "1 Implementierung" und damit GRUEN. Jetzt haelt ein SOLL
//     aus fremder Quelle dagegen: `git ls-files` nennt die Skripte aus dem INDEX, und
//     jedes davon, das auf der Platte liegt, MUSS im Gang vorgekommen sein -- als MENGE
//     verglichen, nicht als Zahl, damit die Meldung sagt WELCHE fehlt. Dazu vier
//     eingefrorene Anker in vier Zweigen und eine grobe Untergrenze. Begruendung, die
//     drei Instrumente und was jedes NICHT deckt: Abschnitt (4a).
//
// -----------------------------------------------------------------------------
// T-1 ROT ZUERST -- protokolliert, nicht behauptet
// -----------------------------------------------------------------------------
// Diese Suite wurde gegen die UNGEHEILTE ci/wide_aggregat.sh gefahren, bevor die
// Heilung geschrieben war. Literal, 10.08.2026:  10 PASSED, 4 FAILED
//   WideFall.ShellNenntIhrenNennerInDerAusgabe                  (WIDE_QUELLEN fehlt)
//   WideFall.ShellBrichtBeiVerschwundenerQuelleStattStillZuSchlucken (rc 0 statt 2)
//   WideFall.ParitaetShellUndCppUeberEineGewuerfeltePopulation  (Kennzahlen + rc)
//   WideFall.DieDreiAufrufwegeLiefernDasselbeErgebnis           (kein Nenner)
// Die zehn gruenen Faelle sind die GEGENPROBE (K13): eine Wache, die immer rot ist,
// ist so wertlos wie eine, die nie rot wird. Nach der Heilung: 14 von 14 gruen.
//
// ZWEITER ROT-LAUF, 10.08.2026 -- der Riegel aus (4) gegen SICH SELBST. super/development
// war seit Pipeline 15529 rot, test:unit UND test:unit:debug, je 1 von 310. Literal aus
// der CI:   [  FAILED  ] WideFall.DieKonkatenationStehtImBaumGenauEinmal (0 ms)
// Lokal war derselbe Baum GRUEN (14/14). Die Ursache war der PFAD, nicht der Inhalt --
// nachgestellt, indem der Quellbaum ueber .../builds/... erreicht wurde:
//     0 Dateien angesehen -- das waere eine Null ohne Nenner, also kein Gruen
//     [  FAILED  ] WideFall.DieKonkatenationStehtImBaumGenauEinmal (0 ms)   rc=8
// Byte-gleich zur CI, inklusive der (0 ms): es wurde keine einzige Datei gelesen.
//
// DRITTER ROT-LAUF, 10.08.2026 -- Posten M4, der Nenner-Riegel gegen sich selbst. Hier
// war das "Rot" ein GRUEN, das keines sein durfte. Derselbe Mutant (der Gang auf den
// Zweig 'ci' verkuerzt, gewuerfelte Grenze aus /dev/urandom, Seed 4108327412), zweimal
// gefahren, literal:
//   VORHER, ohne (4a):  <property name="nenner_skripte" value="31"/>
//                       [       OK ] WideFall.DieKonkatenationStehtImBaumGenauEinmal (1 ms)
//                       [  PASSED  ] 1 test.
//   NACHHER, mit (4a):  [  NENNER  ] SOLL 100 Skripte (git ls-files, 114 getrackt) -- IST 31
//                       Actual: false (DER GANG IST VERKUERZT -- SOLL 100 ..., IST 31 gesehen;
//                                69 fehlen: .github/workflows/ci.yml, ...)
//                       [  FAILED  ] WideFall.DieKonkatenationStehtImBaumGenauEinmal   rc=1
// GEGENPROBE: unmanipuliert 21 von 21 gruen in Release UND Debug.
//
// -----------------------------------------------------------------------------
// TESTKRITIK (T-9) -- WAS DIESE SUITE NICHT DECKT
// -----------------------------------------------------------------------------
//   * Die drei Produktions-Aufrufstellen rufen weiterhin die SHELL-Fassung. Dass das
//     C++-Binary in der CI liefe, ist NICHT zugesichert -- der Schwenk ist Stufe 2 und
//     Lead-Entscheid (bei xml_wellformed/gitlink_parity seit dem 09.08. offen).
//   * Die measure-Jobs selbst laufen hier nicht (inert-by-default, mehrtaegig). Was
//     geprueft wird, ist der Aggregator und die Aufruf-KONVENTION, nicht der Job.
//   * Die AUSWAHL der Dateien (af_finde_result_csv / find -name 'result.csv') und das
//     'sort' gehoeren dem Aufrufer und werden hier nicht geprueft.
//   * Eine Datei, die WAEHREND des Lesens verschwindet (Wettlauf innerhalb des Laufs),
//     wird nicht erzeugt. Gedeckt ist "vor dem Lesen weg", nicht "mittendrin weg".
//   * Zeichenkodierung: die Faelle sind ASCII. CSV mit CRLF oder NUL-Bytes ist nicht
//     Gegenstand -- benannt statt zugedeckt.
//   * DER ZWILLINGS-RIEGEL sieht NUR .sh/.yml/.yaml. Eine zweite Implementierung in
//     C++, Make oder CMake faende er nicht. Der C++-Zwilling in Code/ci_wachen ist
//     GEWOLLT (Stufe 1) und durch den Paritaets-Fall oben gedeckt, nicht durch (4).
//   * Der Riegel erkennt die Konkatenation an 'tail -n +2' + '>>'. Eine Neu-Fassung mit
//     einem ANDEREN Kopfzeilen-Sprung ('sed 1d', "awk 'NR>1'") ginge durch. Das ist eine
//     bewusste Grenze: das Muster deckt die Wiederkehr DIESER Kopie, nicht jede
//     denkbare Neuerfindung derselben Idee.
//   * nur_code() ist ein Zerleger fuer den Hausgebrauch, kein Shell-Parser. Here-Docs,
//     Zeilenfortsetzungen mit '\' und $'...' sind nicht modelliert; ein Here-Doc-Rumpf
//     gilt ihm als Code. Am Bestand gemessen traegt das (die Zahlen stehen im Nenner der
//     Meldung), aber es ist eine Annahme und keine Zusicherung.
//   * Die Bau-Erkennung haengt an CMakeCache.txt. Ein Bauverzeichnis eines ANDEREN
//     Werkzeugs (Meson, Bazel) traegt diese Datei nicht und wuerde mitgelesen. Fuer
//     diesen Baum -- er ist reines CMake -- ist das gedeckt, fuer einen fremden nicht.
//   * DER NENNER-RIEGEL (4a) haengt an git. Faellt git aus, ist der Fall ROT und nicht
//     etwa schwaecher -- aber er ist dann eben ROT, auch wenn der Bestand in Ordnung ist.
//     Das ist die bewusst gewaehlte Seite des Irrtums (fail-closed), keine Deckung.
//   * Er sieht nur, was git AUFFUEHRT. `git rm --cached` verkleinert das Soll lautlos;
//     dagegen stehen allein die vier Anker, und die decken Forschungsarbeiten/ (57 der
//     100 Skripte, der groesste Zweig) ausdruecklich NICHT ab.
//   * Die Anker sind eingefroren. Wird eine der vier Dateien umbenannt oder entfernt, ist
//     der Fall rot und die Zeile in (4a) NACHZUZIEHEN. Das ist Wartung mit Ansage, kein
//     Defekt -- aber es ist Wartung.
//   * Ein getracktes Skript INNERHALB eines CMake-Baubaums wird vom Gang abgeschnitten,
//     vom Soll aber gefordert; der Fall waere rot. Er kommt heute nicht vor (Baubaeume
//     sind gitignoriert) und ist deshalb nicht modelliert, sondern benannt.
//   * Ein Submodul-Gitlink, dessen PFAD auf .sh/.yml/.yaml endete, kaeme als getrackter
//     Eintrag zurueck, ohne eine Datei zu sein. Der stat faengt das ab; geprueft ist es
//     nicht, weil es diesen Fall im Baum nicht gibt.
//
// ORAKEL (T-5 / K13): kein Fall schreibt eine Zahl ab. Anzahl der Quellen, ihre Art und
// jeder Koeder werden je Lauf gewuerfelt und WOERTLICH zurueckgefordert; der Seed steht
// per RecordProperty im Protokoll. Der NENNER kommt damit aus einer ANDEREN Quelle als
// dem Pruefling (T-3): der Test WEISS, wie viele Quellen er angelegt hat.
//
// ASCII-only, Zeilen <= 120 Byte.
// =============================================================================

#include <algorithm>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <functional>
#include <iostream>
#include <optional>
#include <sstream>
#include <string>
#include <vector>

#include <gmock/gmock.h>
#include <gtest/gtest.h>

#include "comdare/ci_wachen/ci_yml_scanner.hpp"
#include "comdare/ci_wachen/ergebnis.hpp"
#include "comdare/ci_wachen/git_quelle.hpp"
#include "comdare/ci_wachen/prozess.hpp"
#include "comdare/ci_wachen/werkbank.hpp"
#include "comdare/ci_wachen/wide_aggregat.hpp"

namespace {

using comdare::ci_wachen::AggregatAbbruchGrund;
using comdare::ci_wachen::DateiBestand;
using comdare::ci_wachen::EchteGitQuelle;
using comdare::ci_wachen::exit_code;
using comdare::ci_wachen::exit_code_von;
using comdare::ci_wachen::fuehre_aus;
using comdare::ci_wachen::ProzessAuftrag;
using comdare::ci_wachen::ProzessAusgang;
using comdare::ci_wachen::QuellBefund;
using comdare::ci_wachen::WacheStatus;
using comdare::ci_wachen::WideErgebnis;
using comdare::ci_wachen::werkbank::FixtureRepo;
using comdare::ci_wachen::werkbank::Wuerfel;
using testing::HasSubstr;
using testing::UnorderedElementsAre;

#ifndef COMDARE_WIDE_AGGREGAT_SH
#error "COMDARE_WIDE_AGGREGAT_SH fehlt -- ohne den Pfad der Produktions-Shell ist die Paritaet nicht pruefbar."
#endif
#ifndef COMDARE_REPO_WURZEL_W29
#error "COMDARE_REPO_WURZEL_W29 fehlt -- ohne die Repo-Wurzel ist der Zwillings-Riegel nicht pruefbar."
#endif

// ---------------------------------------------------------------------------
// Wegwerf-Werkstatt. Jeder Fall bekommt ein eigenes Verzeichnis; der Bestand wird nie
// angefasst. Jeder Schritt ist eine Zusicherung -- ein misslungenes Arrangement ist ROT
// mit Diagnose, nie "gefangen".
// ---------------------------------------------------------------------------
class Werkstatt {
public:
    Werkstatt() {
        std::error_code fehler;
        const auto      basis = std::filesystem::temp_directory_path(fehler);
        static int      lauf  = 0;
        pfad_                 = basis / ("comdare_w29_" + std::to_string(::getpid()) + "_" + std::to_string(++lauf));
        std::filesystem::create_directories(pfad_, fehler);
    }
    ~Werkstatt() {
        std::error_code fehler;
        std::filesystem::remove_all(pfad_, fehler);
    }
    Werkstatt(const Werkstatt&)            = delete;
    Werkstatt& operator=(const Werkstatt&) = delete;

    const std::filesystem::path& pfad() const { return pfad_; }

    testing::AssertionResult schreibe(const std::string& relativ, const std::string& inhalt) {
        const std::filesystem::path ziel = pfad_ / relativ;
        std::error_code             fehler;
        std::filesystem::create_directories(ziel.parent_path(), fehler);
        std::ofstream strom(ziel, std::ios::binary | std::ios::trunc);
        if (!strom) { return testing::AssertionFailure() << "konnte '" << ziel.string() << "' nicht anlegen"; }
        strom << inhalt;
        strom.close();
        if (!strom) { return testing::AssertionFailure() << "Schreibfehler auf '" << ziel.string() << "'"; }
        return testing::AssertionSuccess();
    }

private:
    std::filesystem::path pfad_;
};

std::string lies_datei(const std::filesystem::path& datei) {
    std::ifstream strom(datei, std::ios::binary);
    if (!strom) { return "<NICHT LESBAR: " + datei.string() + ">"; }
    std::ostringstream puffer;
    puffer << strom.rdbuf();
    return puffer.str();
}

// ---------------------------------------------------------------------------
// DIE POPULATION. Sie ist der NENNER aus fremder Quelle (T-3/V-7): der Test WEISS, wie
// viele Quellen welcher Art er angelegt hat -- er fragt den Pruefling nicht danach.
// ---------------------------------------------------------------------------
struct Population {
    std::vector<std::string> listen_eintraege;
    int                      soll_quellen      = 0;
    int                      soll_mit_daten    = 0;
    int                      soll_ohne_daten   = 0;
    int                      soll_nicht_lesbar = 0;
    int                      soll_datenzeilen  = 0;
    std::string              listen_datei;
};

// Baut eine gewuerfelte Population unter <unterordner>. Der Koeder steckt in JEDER
// Datenzeile und wird woertlich zurueckgefordert.
testing::AssertionResult baue_population(Werkstatt& werk, Wuerfel& wuerfel, const std::string& unterordner,
                                         const std::string& koeder, Population& heraus) {
    const int volle    = wuerfel.zahl(1, 4); // mindestens eine, sonst gibt es keinen Header
    const int leere    = wuerfel.zahl(0, 2);
    const int fehlende = wuerfel.zahl(0, 2);

    std::vector<std::string> eintraege;
    int                      datenzeilen = 0;

    // (a) die 0-Byte-Dateien zuerst -- sie liegen im 'sort' VOR den vollen und sind
    //     damit der Header-Dieb-Fall F4.
    for (int i = 0; i < leere; ++i) {
        const std::string rel = unterordner + "/a" + std::to_string(i) + "_leer_result.csv";
        const auto        ok  = werk.schreibe(rel, "");
        if (!ok) { return ok; }
        eintraege.push_back((werk.pfad() / rel).string());
    }
    // (b) die vollen. Die LETZTE bekommt bewusst KEINEN Schluss-Newline -- das ist der
    //     Regelfall (ce schreibt so) und der Eingang, an dem F2 und F3 haengen.
    for (int i = 0; i < volle; ++i) {
        const int          zeilen = wuerfel.zahl(1, 3);
        std::ostringstream inhalt;
        inhalt << "perm,ns,koeder\n";
        for (int z = 0; z < zeilen; ++z) {
            inhalt << "p" << i << "_" << z << "," << (100 + z) << "," << koeder;
            const bool letzte_ueberhaupt = (i == volle - 1) && (z == zeilen - 1);
            if (!letzte_ueberhaupt) { inhalt << "\n"; }
        }
        const std::string rel = unterordner + "/b" + std::to_string(i) + "_voll_result.csv";
        const auto        ok  = werk.schreibe(rel, inhalt.str());
        if (!ok) { return ok; }
        eintraege.push_back((werk.pfad() / rel).string());
        datenzeilen += zeilen;
    }
    // (c) die verschwundenen: sie stehen in der Liste, aber es gibt sie nicht. Das ist
    //     der Fall, den die Shell-Fassung still verschluckt hat (F5).
    for (int i = 0; i < fehlende; ++i) {
        const std::string rel = unterordner + "/c" + std::to_string(i) + "_WEG_result.csv";
        eintraege.push_back((werk.pfad() / rel).string());
    }

    std::ostringstream liste;
    for (const std::string& eintrag : eintraege) { liste << eintrag << "\n"; }
    const std::string listen_rel = unterordner + "/_rc_list.txt";
    const auto        ok         = werk.schreibe(listen_rel, liste.str());
    if (!ok) { return ok; }

    heraus.listen_eintraege  = eintraege;
    heraus.soll_quellen      = static_cast<int>(eintraege.size());
    heraus.soll_mit_daten    = volle;
    heraus.soll_ohne_daten   = leere;
    heraus.soll_nicht_lesbar = fehlende;
    heraus.soll_datenzeilen  = datenzeilen;
    heraus.listen_datei      = (werk.pfad() / listen_rel).string();
    return testing::AssertionSuccess();
}

// ---------------------------------------------------------------------------
// Die Produktions-Shell fahren. KEIN `sh -c`: argv-Vektor, damit ein fehlendes Werkzeug
// als ExecFehlgeschlagen zurueckkommt und NIE als Exit-Code, der wie ein Urteil aussieht.
// ---------------------------------------------------------------------------
struct ShellLauf {
    ProzessAusgang ausgang;
    std::string    wide;
    std::string    kennzahlen;
};

ShellLauf fahre_shell(const std::string& liste, const std::filesystem::path& wide,
                      const std::filesystem::path& kennzahlen) {
    ProzessAuftrag auftrag;
    auftrag.argv          = {"sh", COMDARE_WIDE_AGGREGAT_SH, liste, wide.string(), kennzahlen.string()};
    auftrag.env_entfernen = {"GIT_DIR", "GIT_WORK_TREE", "GIT_INDEX_FILE"};
    ShellLauf lauf;
    lauf.ausgang    = fuehre_aus(auftrag);
    lauf.wide       = lies_datei(wide);
    lauf.kennzahlen = lies_datei(kennzahlen);
    return lauf;
}

// Zieht einen Schluessel aus einer Kennzahlen-Datei. nullopt = Schluessel fehlt --
// ausdruecklich verschieden von "Schluessel steht da und ist 0".
std::optional<std::string> kennzahl(const std::string& inhalt, const std::string& schluessel) {
    std::istringstream strom(inhalt);
    std::string        zeile;
    const std::string  praefix = schluessel + "=";
    while (std::getline(strom, zeile)) {
        if (zeile.rfind(praefix, 0) == 0) { return zeile.substr(praefix.size()); }
    }
    return std::nullopt;
}

// Zaehlt die Datensaetze einer Zeichenkette nach der awk-Regel -- UNABHAENGIG von der
// Bibliothek gerechnet (V-7: die zweite Zahl kommt nicht aus dem Pruefling).
std::int64_t saetze_in(const std::string& inhalt) {
    std::int64_t n     = 0;
    bool         offen = false;
    for (const char zeichen : inhalt) {
        if (zeichen == '\n') {
            n += 1;
            offen = false;
        } else {
            offen = true;
        }
    }
    return n + (offen ? 1 : 0);
}

class WideFall : public testing::Test {
protected:
    void      SetUp() override { RecordProperty("wuerfel_seed", std::to_string(wuerfel_.seed())); }
    Wuerfel   wuerfel_;
    Werkstatt werk_;
};

// ===========================================================================
// (1) DIE C++-FASSUNG -- die vier Defekte, jeder mit GEGENEINGANG (T-4)
// ===========================================================================

TEST_F(WideFall, F3KonkatenationVerklebtDieLetzteZeileNicht) {
    const std::string koeder_a = wuerfel_.token(16);
    const std::string koeder_b = wuerfel_.token(16);
    // Die erste Datei endet OHNE Newline -- ohne 'awk 1' klebte die erste Datenzeile der
    // zweiten an sie an. Das ist der Regelfall, nicht die Ausnahme.
    ASSERT_TRUE(werk_.schreibe("f3/a_result.csv", "perm,ns,koeder\nA,1," + koeder_a));
    ASSERT_TRUE(werk_.schreibe("f3/b_result.csv", "perm,ns,koeder\nB,2," + koeder_b + "\n"));
    ASSERT_TRUE(werk_.schreibe("f3/_rc_list.txt", (werk_.pfad() / "f3/a_result.csv").string() + "\n" +
                                                      (werk_.pfad() / "f3/b_result.csv").string() + "\n"));

    const WideErgebnis erg =
        comdare::ci_wachen::aggregiere(werk_.pfad() / "f3/_rc_list.txt", werk_.pfad() / "f3/wide.csv");
    const std::string wide = lies_datei(werk_.pfad() / "f3/wide.csv");

    EXPECT_EQ(erg.status, WacheStatus::Gruen);
    EXPECT_EQ(erg.daten, 2);
    // DIE ZUSICHERUNG: die beiden Koeder stehen in GETRENNTEN Zeilen.
    EXPECT_THAT(wide, HasSubstr("A,1," + koeder_a + "\n"));
    EXPECT_THAT(wide, HasSubstr("B,2," + koeder_b + "\n"));
    // GEGENEINGANG (T-4): die verklebte Form darf NICHT vorkommen.
    EXPECT_THAT(wide, testing::Not(HasSubstr(koeder_a + "B,2")));
    EXPECT_EQ(saetze_in(wide), 3) << "Kopfzeile + zwei Datenzeilen -- unabhaengig nachgezaehlt";
}

TEST_F(WideFall, F2ZaehlungZaehltSaetzeNichtZeilenumbrueche) {
    const std::string koeder = wuerfel_.token(16);
    // Kopfzeile + EINE Datenzeile, kein Schluss-Newline. 'wc -l' liefert hier 1 und
    // haette das Aggregat als leer gemeldet -- der Messwert waere verschwunden.
    ASSERT_TRUE(werk_.schreibe("f2/a_result.csv", "perm,ns,koeder\nA,1," + koeder));
    ASSERT_TRUE(werk_.schreibe("f2/_rc_list.txt", (werk_.pfad() / "f2/a_result.csv").string() + "\n"));

    const WideErgebnis erg =
        comdare::ci_wachen::aggregiere(werk_.pfad() / "f2/_rc_list.txt", werk_.pfad() / "f2/wide.csv");

    EXPECT_EQ(erg.status, WacheStatus::Gruen);
    EXPECT_EQ(erg.zeilen, 2);
    EXPECT_EQ(erg.daten, 1) << "eine Datenzeile ohne Schluss-Newline ist EINE Datenzeile";
    EXPECT_TRUE(erg.header);
    // GEGENEINGANG: eine Datei OHNE Datenzeile liefert 0 -- die Zusicherung gilt dort nicht.
    ASSERT_TRUE(werk_.schreibe("f2b/a_result.csv", "perm,ns,koeder\n"));
    ASSERT_TRUE(werk_.schreibe("f2b/_rc_list.txt", (werk_.pfad() / "f2b/a_result.csv").string() + "\n"));
    const WideErgebnis leer =
        comdare::ci_wachen::aggregiere(werk_.pfad() / "f2b/_rc_list.txt", werk_.pfad() / "f2b/wide.csv");
    EXPECT_EQ(leer.status, WacheStatus::Gruen) << "leer ist KEIN Fehler -- das URTEIL faellt der Aufrufer";
    EXPECT_EQ(leer.daten, 0);
    EXPECT_EQ(leer.ohne_daten, 1);
}

TEST_F(WideFall, F4NullByteDateiStiehltDenHeaderNicht) {
    const std::string koeder = wuerfel_.token(16);
    ASSERT_TRUE(werk_.schreibe("f4/a_leer_result.csv", ""));
    ASSERT_TRUE(werk_.schreibe("f4/b_voll_result.csv", "perm,ns,koeder\nB,2," + koeder + "\n"));
    ASSERT_TRUE(werk_.schreibe("f4/_rc_list.txt", (werk_.pfad() / "f4/a_leer_result.csv").string() + "\n" +
                                                      (werk_.pfad() / "f4/b_voll_result.csv").string() + "\n"));

    const WideErgebnis erg =
        comdare::ci_wachen::aggregiere(werk_.pfad() / "f4/_rc_list.txt", werk_.pfad() / "f4/wide.csv");
    const std::string wide = lies_datei(werk_.pfad() / "f4/wide.csv");

    EXPECT_EQ(erg.status, WacheStatus::Gruen);
    EXPECT_TRUE(erg.header) << "die 0-Byte-Datei darf den Header nicht 'gestellt' haben";
    EXPECT_THAT(wide, HasSubstr("perm,ns,koeder\n")) << "die Kopfzeile kommt aus der VOLLEN Datei";
    EXPECT_EQ(erg.daten, 1);
    EXPECT_EQ(erg.ohne_daten, 1) << "die 0-Byte-Datei steht im Nenner, nicht im Nichts";
    EXPECT_EQ(erg.mit_daten, 1);
}

TEST_F(WideFall, F5VerschwundeneQuelleIstAbbruchKeinGruen) {
    const std::string koeder = wuerfel_.token(16);
    ASSERT_TRUE(werk_.schreibe("f5/a_result.csv", "perm,ns,koeder\nA,1," + koeder + "\n"));
    const std::string weg = (werk_.pfad() / "f5/b_WEG_result.csv").string();
    ASSERT_TRUE(werk_.schreibe("f5/_rc_list.txt", (werk_.pfad() / "f5/a_result.csv").string() + "\n" + weg + "\n"));

    const WideErgebnis erg =
        comdare::ci_wachen::aggregiere(werk_.pfad() / "f5/_rc_list.txt", werk_.pfad() / "f5/wide.csv");

    EXPECT_EQ(erg.status, WacheStatus::Abbruch);
    ASSERT_TRUE(erg.abbruch.has_value());
    EXPECT_EQ(*erg.abbruch, AggregatAbbruchGrund::QuelleNichtLesbar);
    EXPECT_EQ(erg.nicht_lesbar, 1);
    EXPECT_EQ(erg.quellen, 2);
    EXPECT_THAT(erg.protokoll(), HasSubstr("1 nicht lesbar"));
    // GEGENEINGANG (T-4): dieselbe Liste, aber die Datei ist da -> GRUEN. Ohne das waere
    // die Wache ein Daueralarm und damit wertlos.
    ASSERT_TRUE(werk_.schreibe("f5/b_WEG_result.csv", "perm,ns,koeder\nB,2," + koeder + "\n"));
    const WideErgebnis gegen =
        comdare::ci_wachen::aggregiere(werk_.pfad() / "f5/_rc_list.txt", werk_.pfad() / "f5/wide2.csv");
    EXPECT_EQ(gegen.status, WacheStatus::Gruen);
    EXPECT_EQ(gegen.nicht_lesbar, 0);
    EXPECT_EQ(gegen.daten, 2);
}

TEST_F(WideFall, LeereListeIstGruenUndNenntNullQuellen) {
    ASSERT_TRUE(werk_.schreibe("leer/_rc_list.txt", ""));
    const WideErgebnis erg =
        comdare::ci_wachen::aggregiere(werk_.pfad() / "leer/_rc_list.txt", werk_.pfad() / "leer/wide.csv");
    EXPECT_EQ(erg.status, WacheStatus::Gruen) << "leer ist eine ZAHL, kein Fehler";
    EXPECT_EQ(erg.quellen, 0);
    EXPECT_EQ(erg.zeilen, 0);
    EXPECT_FALSE(erg.header);
    EXPECT_THAT(erg.protokoll(), HasSubstr("0 Quelle(n) gelistet"));
}

TEST_F(WideFall, FehlendeListeIstAbbruchNichtLeer) {
    const WideErgebnis erg =
        comdare::ci_wachen::aggregiere(werk_.pfad() / "gibtsnicht/_rc_list.txt", werk_.pfad() / "gibtsnicht_wide.csv");
    EXPECT_EQ(erg.status, WacheStatus::Abbruch);
    ASSERT_TRUE(erg.abbruch.has_value());
    EXPECT_EQ(*erg.abbruch, AggregatAbbruchGrund::ListeFehlt)
        << "'Liste weg' und 'Liste leer' duerfen nicht denselben Wert haben";
}

TEST_F(WideFall, DerNennerIstEineIdentitaetKeineSchaetzung) {
    const std::string koeder = wuerfel_.token(16);
    Population        pop;
    ASSERT_TRUE(baue_population(werk_, wuerfel_, "nenner", koeder, pop));
    RecordProperty("soll_quellen", std::to_string(pop.soll_quellen));

    const WideErgebnis erg = comdare::ci_wachen::aggregiere(pop.listen_datei, werk_.pfad() / "nenner/wide.csv");

    // Die SOLL-Zahlen kommen aus dem Test, nicht aus dem Pruefling (T-3).
    EXPECT_EQ(erg.quellen, pop.soll_quellen);
    EXPECT_EQ(erg.mit_daten, pop.soll_mit_daten);
    EXPECT_EQ(erg.ohne_daten, pop.soll_ohne_daten);
    EXPECT_EQ(erg.nicht_lesbar, pop.soll_nicht_lesbar);
    EXPECT_TRUE(erg.nenner_haelt()) << "quellen != mit + ohne + nicht_lesbar";
    EXPECT_EQ(static_cast<int>(erg.je_quelle.size()), pop.soll_quellen) << "je Quelle genau ein Befund";
}

TEST_F(WideFall, JederQuellBefundKommtInDerFallTabelleVor) {
    // Vollstaendigkeit (T-4/Stufe 1): kein enum-Wert darf sich still an der Deckung
    // vorbeischleichen. Waechst QuellBefund, faellt zuerst der static_assert im Header,
    // dann dieser Fall.
    std::vector<QuellBefund> gedeckt = {QuellBefund::MitDaten, QuellBefund::OhneDaten, QuellBefund::NichtLesbar};
    for (const QuellBefund befund : comdare::ci_wachen::alle_quell_befunde) {
        EXPECT_NE(std::find(gedeckt.begin(), gedeckt.end(), befund), gedeckt.end())
            << "QuellBefund " << befund << " hat keinen Fall";
        EXPECT_FALSE(comdare::ci_wachen::quell_befund_text(befund).empty());
    }
    for (const AggregatAbbruchGrund grund : comdare::ci_wachen::alle_aggregat_abbruch_gruende) {
        EXPECT_FALSE(comdare::ci_wachen::aggregat_abbruch_text(grund).empty())
            << "Abbruchgrund ohne Text ist eine nackte Zahl";
    }
}

// ===========================================================================
// (2) DER NENNER IN DER AUSGABE DER PRODUKTIONS-SHELL
//     Diese beiden Faelle waren am ungeheilten Objekt ROT (T-1).
// ===========================================================================

TEST_F(WideFall, ShellNenntIhrenNennerInDerAusgabe) {
    const std::string koeder = wuerfel_.token(16);
    Population        pop;
    ASSERT_TRUE(baue_population(werk_, wuerfel_, "shellnenner", koeder, pop));
    RecordProperty("koeder", koeder);

    const ShellLauf lauf =
        fahre_shell(pop.listen_datei, werk_.pfad() / "shellnenner/wide.csv", werk_.pfad() / "shellnenner/kz.env");
    ASSERT_TRUE(exit_code(lauf.ausgang).has_value()) << "die Shell lief nicht: " << lauf.ausgang.beschreibung();

    // V-1: der Nenner gehoert in die AUSGABE des Werkzeugs, nicht in seinen Kopf.
    const std::optional<std::string> quellen = kennzahl(lauf.kennzahlen, "WIDE_QUELLEN");
    ASSERT_TRUE(quellen.has_value()) << "WIDE_QUELLEN fehlt -- die Ausgabe traegt keinen Nenner:\n" << lauf.kennzahlen;
    EXPECT_EQ(*quellen, std::to_string(pop.soll_quellen));
    ASSERT_TRUE(kennzahl(lauf.kennzahlen, "WIDE_MIT_DATEN").has_value());
    ASSERT_TRUE(kennzahl(lauf.kennzahlen, "WIDE_OHNE_DATEN").has_value());
    ASSERT_TRUE(kennzahl(lauf.kennzahlen, "WIDE_FEHLEND").has_value());
    EXPECT_EQ(*kennzahl(lauf.kennzahlen, "WIDE_MIT_DATEN"), std::to_string(pop.soll_mit_daten));
    EXPECT_EQ(*kennzahl(lauf.kennzahlen, "WIDE_OHNE_DATEN"), std::to_string(pop.soll_ohne_daten));
    EXPECT_EQ(*kennzahl(lauf.kennzahlen, "WIDE_FEHLEND"), std::to_string(pop.soll_nicht_lesbar));
    // Der ALTE Vertrag bleibt: die drei bisherigen Schluessel stehen weiter da.
    EXPECT_TRUE(kennzahl(lauf.kennzahlen, "WIDE_ZEILEN").has_value());
    EXPECT_TRUE(kennzahl(lauf.kennzahlen, "WIDE_DATEN").has_value());
    EXPECT_TRUE(kennzahl(lauf.kennzahlen, "WIDE_HEADER").has_value());
}

TEST_F(WideFall, ShellBrichtBeiVerschwundenerQuelleStattStillZuSchlucken) {
    const std::string koeder = wuerfel_.token(16);
    ASSERT_TRUE(werk_.schreibe("shellweg/a_result.csv", "perm,ns,koeder\nA,1," + koeder + "\n"));
    const std::string weg = (werk_.pfad() / "shellweg/b_WEG_result.csv").string();
    ASSERT_TRUE(
        werk_.schreibe("shellweg/_rc_list.txt", (werk_.pfad() / "shellweg/a_result.csv").string() + "\n" + weg + "\n"));

    const ShellLauf lauf = fahre_shell((werk_.pfad() / "shellweg/_rc_list.txt").string(),
                                       werk_.pfad() / "shellweg/wide.csv", werk_.pfad() / "shellweg/kz.env");
    ASSERT_TRUE(exit_code(lauf.ausgang).has_value()) << "die Shell lief nicht: " << lauf.ausgang.beschreibung();
    EXPECT_EQ(*exit_code(lauf.ausgang), exit_code_von(WacheStatus::Abbruch))
        << "eine gelistete, verschwundene Quelle muss FAIL-CLOSED sein -- Ausgabe war:\n"
        << lauf.kennzahlen << lauf.ausgang.fehler;
    EXPECT_EQ(kennzahl(lauf.kennzahlen, "WIDE_FEHLEND").value_or("<fehlt>"), "1");

    // GEGENKOEDER (K13): dieselbe Liste, Datei vorhanden -> GRUEN. Eine Wache, die immer
    // rot ist, ist so wertlos wie eine, die nie rot wird.
    ASSERT_TRUE(werk_.schreibe("shellweg/b_WEG_result.csv", "perm,ns,koeder\nB,2," + koeder + "\n"));
    const ShellLauf gegen = fahre_shell((werk_.pfad() / "shellweg/_rc_list.txt").string(),
                                        werk_.pfad() / "shellweg/wide2.csv", werk_.pfad() / "shellweg/kz2.env");
    ASSERT_TRUE(exit_code(gegen.ausgang).has_value()) << gegen.ausgang.beschreibung();
    EXPECT_EQ(*exit_code(gegen.ausgang), exit_code_von(WacheStatus::Gruen));
    EXPECT_EQ(kennzahl(gegen.kennzahlen, "WIDE_FEHLEND").value_or("<fehlt>"), "0");
    EXPECT_THAT(gegen.wide, HasSubstr(koeder)) << "der gewuerfelte Koeder muss woertlich durchkommen";
}

// ===========================================================================
// (3) PARITAET SHELL <-> C++ (V-7) und DIE DREI AUFRUFWEGE
// ===========================================================================

TEST_F(WideFall, ParitaetShellUndCppUeberEineGewuerfeltePopulation) {
    const std::string koeder = wuerfel_.token(16);
    Population        pop;
    ASSERT_TRUE(baue_population(werk_, wuerfel_, "paritaet", koeder, pop));
    RecordProperty("koeder", koeder);
    RecordProperty("soll_quellen", std::to_string(pop.soll_quellen));

    const ShellLauf shell =
        fahre_shell(pop.listen_datei, werk_.pfad() / "paritaet/wide_sh.csv", werk_.pfad() / "paritaet/kz_sh.env");
    ASSERT_TRUE(exit_code(shell.ausgang).has_value()) << "die Shell lief nicht: " << shell.ausgang.beschreibung();

    const WideErgebnis cpp  = comdare::ci_wachen::aggregiere(pop.listen_datei, werk_.pfad() / "paritaet/wide_cpp.csv");
    const std::string  wide = lies_datei(werk_.pfad() / "paritaet/wide_cpp.csv");

    // DIE KERNFRAGE DES POSTENS, maschinell statt erzaehlt: zwei unabhaengige
    // Implementierungen desselben Vertrags duerfen nicht auseinanderlaufen.
    EXPECT_EQ(shell.wide, wide) << "das Aggregat divergiert zwischen Shell und C++";
    EXPECT_EQ(shell.kennzahlen, cpp.kennzahlen()) << "die Kennzahlen divergieren";
    EXPECT_EQ(*exit_code(shell.ausgang), exit_code_von(cpp.status)) << "der Exit-Code divergiert";
    // Und beide gegen den fremden Nenner des Tests.
    EXPECT_EQ(cpp.quellen, pop.soll_quellen);
    EXPECT_EQ(saetze_in(wide), cpp.zeilen) << "WIDE_ZEILEN gegen die Datei nachgezaehlt";
    if (cpp.status == WacheStatus::Gruen) {
        EXPECT_THAT(wide, HasSubstr(koeder)) << "der gewuerfelte Koeder muss woertlich durchkommen";
    }
}

TEST_F(WideFall, DieDreiAufrufwegeLiefernDasselbeErgebnis) {
    // Die drei Aufruf-KONVENTIONEN der drei echten Aufrufer, jede mit EIGENEM Koeder --
    // nichts abgeschrieben, nichts wiederverwendet (K13).
    struct Weg {
        std::string name;
        std::string ordner; // die Verzeichnis-Konvention des jeweiligen Aufrufers
        std::string koeder;
    };
    std::vector<Weg> wege = {
        {"AF_KERN(anhang_forward_core.sh)", "af_tmp", wuerfel_.token(16)},
        {"measure:smoke", "measure_out_smoke", wuerfel_.token(16)},
        {"measure:golden-320", "measure_out", wuerfel_.token(16)},
    };
    ASSERT_NE(wege[0].koeder, wege[1].koeder) << "die Koeder muessen je Weg verschieden sein";
    ASSERT_NE(wege[1].koeder, wege[2].koeder);
    for (const Weg& weg : wege) { RecordProperty("koeder_" + weg.ordner, weg.koeder); }

    // DIESELBE Population je Weg, nur der Koeder unterscheidet sich. Verglichen wird
    // nach Maskierung des jeweils eigenen Koeders -- sonst verglichen man Koeder.
    std::vector<std::string> maskiert_wide;
    std::vector<std::string> kennzahlen_je_weg;
    std::vector<int>         rc_je_weg;
    for (const Weg& weg : wege) {
        ASSERT_TRUE(werk_.schreibe(weg.ordner + "/a_leer_result.csv", ""));
        ASSERT_TRUE(werk_.schreibe(weg.ordner + "/b_voll_result.csv", "perm,ns,koeder\nB,2," + weg.koeder + "\n"));
        ASSERT_TRUE(werk_.schreibe(weg.ordner + "/c_ohne_nl_result.csv", "perm,ns,koeder\nC,3," + weg.koeder));
        const std::string liste = (werk_.pfad() / (weg.ordner + "/a_leer_result.csv")).string() + "\n" +
                                  (werk_.pfad() / (weg.ordner + "/b_voll_result.csv")).string() + "\n" +
                                  (werk_.pfad() / (weg.ordner + "/c_ohne_nl_result.csv")).string() + "\n";
        ASSERT_TRUE(werk_.schreibe(weg.ordner + "/_rc_list.txt", liste));

        const ShellLauf lauf = fahre_shell((werk_.pfad() / (weg.ordner + "/_rc_list.txt")).string(),
                                           werk_.pfad() / (weg.ordner + "/wide_aggregate.csv"),
                                           werk_.pfad() / (weg.ordner + "/_wide_kz.env"));
        ASSERT_TRUE(exit_code(lauf.ausgang).has_value()) << weg.name << ": " << lauf.ausgang.beschreibung();
        EXPECT_THAT(lauf.wide, HasSubstr(weg.koeder)) << weg.name << ": eigener Koeder fehlt im Aggregat";

        std::string maske = lauf.wide;
        for (std::size_t pos = maske.find(weg.koeder); pos != std::string::npos; pos = maske.find(weg.koeder, pos)) {
            maske.replace(pos, weg.koeder.size(), "<KOEDER>");
        }
        maskiert_wide.push_back(maske);
        kennzahlen_je_weg.push_back(lauf.kennzahlen);
        rc_je_weg.push_back(*exit_code(lauf.ausgang));
    }

    ASSERT_EQ(maskiert_wide.size(), 3u) << "der Nenner der Aufrufwege ist 3 -- gemessen, nicht geraten";
    EXPECT_EQ(maskiert_wide[0], maskiert_wide[1]) << wege[0].name << " gegen " << wege[1].name;
    EXPECT_EQ(maskiert_wide[1], maskiert_wide[2]) << wege[1].name << " gegen " << wege[2].name;
    EXPECT_EQ(kennzahlen_je_weg[0], kennzahlen_je_weg[1]);
    EXPECT_EQ(kennzahlen_je_weg[1], kennzahlen_je_weg[2]);
    EXPECT_EQ(rc_je_weg[0], rc_je_weg[1]);
    EXPECT_EQ(rc_je_weg[1], rc_je_weg[2]);
    // Und die Aussage, um die es geht: 3 Quellen, 1 ohne Daten, 0 fehlend.
    EXPECT_EQ(kennzahl(kennzahlen_je_weg[0], "WIDE_QUELLEN").value_or("<fehlt>"), "3");
    EXPECT_EQ(kennzahl(kennzahlen_je_weg[0], "WIDE_OHNE_DATEN").value_or("<fehlt>"), "1");
    EXPECT_EQ(kennzahl(kennzahlen_je_weg[0], "WIDE_DATEN").value_or("<fehlt>"), "2");
}

// ===========================================================================
// (4) DER ZWILLINGS-RIEGEL -- gegen die Rueckkehr der drei Kopien
// ===========================================================================
//
// WAS HIER BIS ZUM 10.08.2026 STAND UND WARUM ES ZWEIMAL FALSCH WAR:
//
// (I) FEHLERKLASSE 'anwesenheit-statt-bedingung' (T-2). Der Riegel suchte die
//     ZEICHENKETTEN "tail -n +2 " und "awk 1 >> " im Baum und nahm zwei Dateien per
//     NAMEN von der Wertung aus. Er beantwortete damit "nennt eine Datei diese
//     Zeichenkette?" statt der Frage, um die es geht: "gibt es eine zweite
//     IMPLEMENTIERUNG?". Ein Kommentar, der die geheilte Falle BESCHREIBT, zaehlte ihm
//     wie eine Wiederholung des Defekts -- die Wache bestrafte ihre eigene
//     Dokumentation und war damit ein Daueralarm-Kandidat, den T-1 ausdruecklich
//     verbietet. Die Ausnahmeliste nach Dateinamen war das Symptom: wo eine Zusicherung
//     Namen kennen muss, misst sie den falschen Gegenstand.
//
// (II) DER PFAD-DEFEKT -- er war die Ursache des roten development seit Pipeline 15529.
//     Der Ausschluss lautete s.find("/build") auf dem ABSOLUTEN Pfad. Der GitLab-Runner
//     checkt nach /home/gitlab-runner/builds/... aus, und "/builds/" ENTHAELT "/build":
//     in der CI war damit JEDER Pfad ausgeschlossen, 'angesehen' blieb 0, der ASSERT
//     fiel -- in Debug wie in Release, in (0 ms), weil keine einzige Datei gelesen wurde.
//     Lokal, an einem Pfad ohne "build", war derselbe Baum gruen: die Wache mass die
//     Maschine, nicht den Bestand. DIESELBE FALLENKLASSE hatte das Projekt am 27.07.
//     schon einmal getroffen (P9: die gitleaks-Allowlist '(^|/)build[^/]*/' traf
//     /builds/ im Runner-Pfad und allowlistete das ganze Repo). Deshalb haengt der
//     Ausschluss jetzt am RELATIVEN Pfad und an VERZEICHNIS-NAMEN, nie an einer
//     Teilzeichenkette des absoluten Pfades.
//
// WAS JETZT GEMESSEN WIRD -- eine Aussage ueber Implementierungen:
//   Eine Zeile IMPLEMENTIERT die WIDE-Konkatenation, wenn sie -- nach Abzug des
//   Kommentars und aller zitierten Zeichenketten -- immer noch 'tail -n +2' (den
//   Kopfzeilen-Sprung) UND '>>' (das Anhaengen ins Aggregat) enthaelt.
//     * Kommentar = ab einem '#', das am Zeilenanfang oder nach Leerraum steht. In
//       Shell wie in YAML ist das die Doku-Grenze. Doku zu schreiben ist erwuenscht.
//     * In Anfuehrungszeichen = die Zeile NENNT die Operation (printf-Format,
//       sed-Ausdruck, grep-Muster); sie TUT sie nicht.
//   Kein Dateiname steht mehr auf einer Ausnahmeliste. Der Riegel traegt seinen Nenner
//   in der MELDUNG und einen POSITIV-Test: die eine bekannte Fundstelle MUSS gefunden
//   werden -- das ist schaerfer als 'angesehen > 0' und faengt genau den Zustand, in
//   dem die Wache blind statt gruen ist.

// Schneidet Kommentar und zitierte Zeichenketten aus EINER Zeile. Was uebrigbleibt, ist
// der Teil, den die Shell (bzw. der YAML-Leser) als CODE sieht -- die Grenze zwischen
// "tut es" und "nennt es".
std::string nur_code(const std::string& zeile) {
    std::string aus;
    aus.reserve(zeile.size());
    char zitat      = '\0'; // '\0' = offen, sonst das offene Anfuehrungszeichen
    bool wortgrenze = true; // steht der Cursor am Anfang eines Wortes?
    for (std::size_t i = 0; i < zeile.size(); ++i) {
        const char c = zeile[i];
        if (zitat != '\0') {
            // In '...' ist alles literal; in "..." maskiert '\' das naechste Zeichen.
            if (zitat == '"' && c == '\\' && i + 1 < zeile.size()) {
                ++i;
                continue;
            }
            if (c == zitat) { zitat = '\0'; }
            continue; // der Inhalt von Zeichenketten faellt weg
        }
        if (c == '#' && wortgrenze) { break; } // ab hier ist die Zeile Dokumentation
        if (c == '\'' || c == '"') {
            zitat      = c;
            wortgrenze = false;
            continue;
        }
        aus.push_back(c);
        wortgrenze = (c == ' ' || c == '\t');
    }
    return aus;
}

struct Fundstelle {
    std::string datei; // relativ zur Wurzel -- nie der absolute Pfad (siehe Defekt II)
    int         zeile = 0;
    std::string code; // die Zeile nach Abzug von Kommentar und Zeichenketten
};

struct Riegelbefund {
    // ACHTUNG, MASCHINEN-ABHAENGIG: 'verzeichnisse' zaehlt auch die Baubaeume, die unter
    // der Wurzel liegen -- der Ordner wird gezaehlt und DANN abgeschnitten. Am Objekt
    // gemessen (10.08.2026, derselbe Bestand): 410 ohne Bauverzeichnis, 411 mit einem,
    // 412 mit zweien. Die "412" aus 88b6409d war also keine Eigenschaft des Bestands,
    // sondern eine der Maschine. Auf diese Zahl gehoert KEINE Zusicherung; sie steht in
    // der Meldung als Zusammenhang, nicht als Nenner. 'dateien' und 'skripte' sind
    // dagegen stabil, weil der INHALT der Baubaeume nicht mitgeht.
    int                      verzeichnisse = 0;
    int                      dateien       = 0; // alle regulaeren Dateien im Gang
    int                      skripte       = 0; // davon .sh/.yml/.yaml -- DER NENNER
    long long                code_zeilen   = 0;
    std::vector<Fundstelle>  implementierungen;
    std::vector<std::string> nennungen; // Dateien, die die Operation nur NENNEN
    std::vector<std::string> unlesbar;  // fail-closed: "nicht lesbar" ist nicht "enthaelt nichts"
    // WELCHE Skripte der Gang gesehen hat, nicht nur WIE VIELE (Posten M4). Eine Zahl
    // laesst sich nur gegen eine Zahl halten; erst die MENGE laesst sich gegen eine
    // fremde Aufzaehlung halten und benennt, was fehlt. skripte == gesehen.size().
    std::vector<std::string> gesehen;
};

// Ein CMake-Baubaum wird an seinem ERZEUGNIS erkannt, nicht an seinem NAMEN. Ein Name ist
// eine Vermutung: 'build-w' und 'Code/build-test-debug' heissen zufaellig so, das '/builds/'
// im Runner-Pfad auch -- und ein Bauverzeichnis, das anders hiesse, entkaeme der Vermutung
// lautlos. CMakeCache.txt dagegen liegt in JEDEM CMake-Bauverzeichnis und in keinem
// Quellverzeichnis. Das ist der Unterschied zwischen einer BEDINGUNG und einem Namen.
bool ist_cmake_baubaum(const std::filesystem::path& verzeichnis) {
    std::error_code fehler;
    return std::filesystem::exists(verzeichnis / "CMakeCache.txt", fehler);
}

// Ausschluss am VERZEICHNIS selbst -- nie an einer Teilzeichenkette des absoluten Pfades,
// genau dort lag Defekt II.
bool verzeichnis_bleibt_draussen(const std::filesystem::path& verzeichnis, const std::string& relativ) {
    const std::string name = verzeichnis.filename().string();
    if (name == ".git" || name == "external") { return true; }
    if (relativ == "docs/sessions/backups") { return true; } // Historie, kein Bestand
    return ist_cmake_baubaum(verzeichnis);
}

// Der Ausschluss ist INJIZIERBAR -- nicht aus Bequemlichkeit. Der Mutant, gegen den der
// Nenner-Riegel (4a) gebaut ist, greift GENAU HIER an: wer den Gang verkuerzt, faelscht
// den Nenner. Ein Koeder, der sich nicht formulieren laesst, ist keiner (K13). Die
// Produktion uebergibt nichts und faehrt damit verzeichnis_bleibt_draussen; die
// verkuerzte Fassung existiert ausschliesslich im Koeder-Fall.
using AusschlussRegel = std::function<bool(const std::filesystem::path&, const std::string&)>;

Riegelbefund riegel_scan(const std::filesystem::path& roh_wurzel,
                         const AusschlussRegel&       bleibt_draussen = verzeichnis_bleibt_draussen) {
    Riegelbefund b;
    // Die Wurzel wird EINMAL lexikalisch normalisiert und der Gang von dort gestartet;
    // damit tragen alle Eintraege exakt dieses Praefix und der relative Pfad ist reine
    // Zeichenketten-Arithmetik -- ohne weakly_canonical, das Symlinks aufloesen und das
    // Praefix zerreissen wuerde. Endet die Wurzel auf '..', traegt lexically_normal
    // einen Schluss-Trenner nach; der muss weg, sonst zeigt lexically_relative nach oben.
    std::filesystem::path wurzel = roh_wurzel.lexically_normal();
    if (wurzel.filename().empty()) { wurzel = wurzel.parent_path(); }

    std::error_code fehler;
    for (std::filesystem::recursive_directory_iterator it(wurzel, fehler), ende; it != ende; it.increment(fehler)) {
        if (fehler) { break; }
        const std::filesystem::path& p       = it->path();
        const std::string            relativ = p.lexically_relative(wurzel).generic_string();
        std::error_code              art;
        if (it->is_directory(art) && !art) {
            b.verzeichnisse += 1;
            // Backups, Fremdbaeume und Baubaeume bleiben draussen -- Historie und Erzeugnis,
            // kein Bestand.
            if (bleibt_draussen(p, relativ)) { it.disable_recursion_pending(); }
            continue;
        }
        if (!it->is_regular_file(art) || art) { continue; }
        b.dateien += 1;
        const std::string ext = p.extension().string();
        if (ext != ".sh" && ext != ".yml" && ext != ".yaml") { continue; }
        b.skripte += 1;
        b.gesehen.push_back(relativ);

        // FAIL-CLOSED gelesen: eine unlesbare Datei liefert nullopt und wird GEMELDET. Ein
        // stiller ifstream, der nichts liefert, waere von "Datei ohne Treffer" nicht zu
        // unterscheiden -- dieselbe Verwechslung, die F5 im Aggregator war.
        const std::optional<std::vector<std::string>> zeilen = comdare::ci_wachen::lies_zeilen(p);
        if (!zeilen.has_value()) {
            b.unlesbar.push_back(relativ);
            continue;
        }
        bool nur_genannt = false;
        for (std::size_t i = 0; i < zeilen->size(); ++i) {
            const std::string& zeile = (*zeilen)[i];
            b.code_zeilen += 1;
            const std::string code = nur_code(zeile);
            if (code.find("tail -n +2") != std::string::npos && code.find(">>") != std::string::npos) {
                b.implementierungen.push_back({relativ, static_cast<int>(i + 1), code});
            } else if (zeile.find("tail -n +2") != std::string::npos && zeile.find(">>") != std::string::npos) {
                nur_genannt = true; // der ALTE Riegel haette hier zugeschlagen
            }
        }
        if (nur_genannt) { b.nennungen.push_back(relativ); }
    }
    // DETERMINISTISCH SORTIERT. recursive_directory_iterator sagt ueber die Reihenfolge
    // NICHTS zu -- sie haengt am Dateisystem. Eine Meldung, die heute anders sortiert ist
    // als morgen, ist nicht vergleichbar, und eine Zusicherung ueber implementierungen[1]
    // waere ein Wuerfelwurf: am Objekt gemessen (10.08., Debug, 20 Laeufe) war genau das
    // in 3 von 20 Laeufen rot, je nachdem wie der gewuerfelte Koeder-Name einsortierte.
    std::sort(b.implementierungen.begin(), b.implementierungen.end(), [](const Fundstelle& l, const Fundstelle& r) {
        return l.datei != r.datei ? l.datei < r.datei : l.zeile < r.zeile;
    });
    std::sort(b.nennungen.begin(), b.nennungen.end());
    std::sort(b.unlesbar.begin(), b.unlesbar.end());
    std::sort(b.gesehen.begin(), b.gesehen.end()); // Voraussetzung fuer den Mengen-Abgleich in (4a)
    return b;
}

// Enthaelt der Befund eine Implementierung in dieser Datei? Zugehoerigkeit statt Position:
// die Aussage lautet "sie wird benannt", nicht "sie steht an Stelle 1".
bool nennt_implementierung(const Riegelbefund& b, const std::string& datei) {
    return std::any_of(b.implementierungen.begin(), b.implementierungen.end(),
                       [&datei](const Fundstelle& f) { return f.datei == datei; });
}

std::string befund_nenner(const Riegelbefund& b) {
    std::ostringstream aus;
    aus << b.verzeichnisse << " Verzeichnisse, " << b.dateien << " Dateien, davon " << b.skripte
        << " Skripte (.sh/.yml/.yaml) mit " << b.code_zeilen << " Zeilen angesehen; " << b.implementierungen.size()
        << " Implementierung(en), " << b.nennungen.size() << " Datei(en) nennen die Operation nur, "
        << b.unlesbar.size() << " unlesbar";
    return aus.str();
}

// Die Fehlermeldung des Unlesbar-Riegels, die den LEEREN Fall selbst traegt. gtest wertet den
// Stream hinter einem ASSERT nur im Fehlerfall aus -- ein b.unlesbar.front() direkt dort ist zur
// Laufzeit also sicher. Eine statische Analyse sieht diese Kopplung nicht: cppcheck 2.21.0 meldet
// containerOutOfBounds ("Either the condition 'b.unlesbar.empty()' is redundant or expression
// 'b.unlesbar.front()' causes access out of bounds", Pipeline 15534, lint:static). Der Zugriff
// wandert deshalb hierher, wo die Leerheit VOR dem Lesen entschieden wird. Die Aussage des Tests
// aendert sich nicht: gedruckt wird der Text nur, wenn die Liste nicht leer ist, und dann steht
// dort dieselbe erste Datei wie zuvor.
std::string befund_unlesbar(const Riegelbefund& b) {
    if (b.unlesbar.empty()) { return "(keine)"; }
    return b.unlesbar.front();
}

std::string befund_liste(const Riegelbefund& b) {
    std::ostringstream aus;
    for (const Fundstelle& f : b.implementierungen) { aus << "\n  " << f.datei << ":" << f.zeile << "  " << f.code; }
    return aus.str();
}

// ===========================================================================
// (4a) DER NENNER-RIEGEL -- wer den GANG verkuerzt, faelscht die AUSSAGE
// ===========================================================================
//
// BIS ZUM 10.08.2026 WAR ER NICHT DA, und das stand als Posten M4 ausdruecklich offen.
//
// DIE LUECKE, am Objekt belegt und nicht vermutet. Der Riegel oben zaehlt
// Implementierungen -- aber der NENNER, ueber dem er zaehlt, war selbst unbewacht. Ein
// Eingriff in riegel_scan, der den Gang auf den Zweig 'ci' verkuerzt (gewuerfelte Grenze
// aus /dev/urandom, Seed 4108327412), lieferte literal:
//     <property name="nenner_skripte" value="31"/>
//     [       OK ] WideFall.DieKonkatenationStehtImBaumGenauEinmal (1 ms)
//     [  PASSED  ] 1 test.
// GRUEN, mit 69 von 100 Skripten NIE ANGESEHEN. Der bestehende ASSERT_GT(skripte, 0)
// faengt genau eine Zahl: die Null. Eine kleine Zahl faengt er nicht -- und das ist
// dieselbe Klasse, die diesen Test am selben Tag schon einmal getroffen hat, als
// s.find("/build") den Runner-Pfad /builds/ traf und 'angesehen' auf 0 fiel. Damals war
// es eine Null und schlug an; 31 statt 100 waere lautlos durchgegangen.
//
// DIE ANTWORT IST EIN SOLL AUS FREMDER QUELLE (T-3). Drei Instrumente, absichtlich
// ungleich stark -- jedes beantwortet eine ANDERE Frage:
//
//   (i)  GIT ALS ZWEITE AUFZAEHLUNG -- das tragende Instrument. `git ls-files` kennt den
//        Bestand aus dem INDEX; das ist ein anderer Apparat als der Verzeichnis-Iterator
//        und von jedem Eingriff in ihn unberuehrt. Verglichen werden nicht Zahlen,
//        sondern MENGEN: jede getrackte .sh/.yml/.yaml ausserhalb der Ausschluesse, die
//        auf der Platte liegt, MUSS im Gang vorgekommen sein. Fehlt EINE, wird sie
//        NAMENTLICH gemeldet -- eine blosse Untergrenze taete das nicht.
//        WAS ES NICHT DECKT: was git selbst nicht mehr auffuehrt. Wer eine Datei per
//        `git rm --cached` aus dem Index nimmt, verkleinert das Soll lautlos mit.
//        Ebenso: Dateien, die es nur im Arbeitsbaum gibt (unverfolgt). Das Soll ist eine
//        UNTERGRENZE, nie eine Gleichheit -- der Gang darf mehr sehen, nie weniger.
//
//   (ii) VIER EINGEFRORENE ANKER -- gegen genau die Luecke von (i). Sie stehen hier
//        woertlich, kommen weder aus git noch aus dem Gang und liegen in VIER
//        verschiedenen obersten Zweigen, damit ein auf EINEN Zweig verkuerzter Gang an
//        mindestens zweien scheitert. Ausgewaehlt sind sie nach TRAGFAEHIGKEIT, nicht
//        nach Groesse: jede ist Gegenstand oder Voraussetzung genau dieser Suite.
//        Verschwindet eine, ist die Zeile NACHZUZIEHEN -- nicht der Riegel zu entfernen.
//        WAS ES NICHT DECKT: die 57 Skripte unter Forschungsarbeiten/. Der GROESSTE
//        Einzelzweig des Nenners hat mit Absicht KEINEN Anker, weil vendorierte
//        Fremdkorpora legitim neu gezogen oder entfernt werden. Fuer ihn traegt allein (i).
//
//   (iii) EINE GROBE UNTERGRENZE, absichtlich niedrig. Das schwaechste der drei: den
//        'ci'-Mutanten mit seinen 31 Skripten faengt sie NICHT -- sie soll ihn auch nicht
//        fangen. Sie beantwortet nur "gibt es ueberhaupt noch einen Bestand" fuer den
//        Fall, dass (i) und (ii) zugleich ausfielen, und sie traegt eine Zahl in die
//        Ausgabe (V-1). Hoch angesetzt waere sie ein programmierter Daueralarm, denn die
//        .sh-Haelfte des Nenners SOLL schrumpfen (Owner-KERN 09.08.: die Shells werden
//        zu Google Tests).
//
// FAIL-CLOSED, OHNE HINTERTUER: antwortet git nicht -- Werkzeug fehlt, kein Arbeitsbaum,
// `safe.directory` schlaegt zu --, ist das ROT mit git-eigener Diagnose und NICHT ein
// stiller Rueckfall auf (ii)+(iii). Ein Rueckfall waere die naechste stille Null: die
// Wache liefe weiter, aber ihre Aussage waere heimlich kleiner geworden, ohne dass es
// jemand saehe. Genau diese Verwechslung -- Werkzeug-Ausfall gegen leeres Ergebnis --
// traegt DateiBestand::werkzeug_ok als eigenes Feld, statt sie in eine Liste zu falten.

// Die vier eingefrorenen Anker (Stand 10.08.2026), je einer in einem anderen obersten
// Zweig. Sie sind KEINE Stichprobe, sondern Voraussetzungen dieser Suite.
const char* const W29_ANKER[] = {
    ".gitlab-ci.yml",                       // Wurzel  -- die Pipeline, die den Aggregator ruft
    ".github/workflows/ci.yml",             // .github -- der Spiegel; fuer DEFEKT II war er blind
    "ci/wide_aggregat.sh",                  // ci      -- der Gegenstand des Postens selbst
    "scripts/ci_diff_ascii_width_guard.sh", // scripts -- die Wache, der DIESE Datei gehorcht
};

// (iii) Die grobe Untergrenze. Am 10.08.2026 sah der Gang 100 Skripte, davon 27
// .yml/.yaml. 12 ist bewusst weit darunter: die Zahl soll die geplante Schrumpfung der
// Shell-Menge ueberleben und nur den Zusammenbruch des Gangs anzeigen.
constexpr int W29_NENNER_UNTERGRENZE = 12;

// Der Ausschluss auf der GIT-Seite ist mit Absicht EIGENSTAENDIG formuliert und ruft
// verzeichnis_bleibt_draussen NICHT auf. Riefe er es, mutierte ein Eingriff in den Gang
// die Referenz gleich mit -- und der Abgleich waere wieder sein eigener Nenner (T-3).
// SEGMENTE, nie Teilzeichenketten: ein find("external") traefe auch 'my_external_tool/',
// genau wie s.find("/build") das '/builds/' des Runners traf. Der Dateiname am Ende wird
// nicht geprueft -- er ist kein Verzeichnis.
bool git_pfad_bleibt_draussen(const std::string& relativ) {
    if (relativ.rfind("docs/sessions/backups/", 0) == 0) { return true; } // Historie, kein Bestand
    std::size_t start = 0;
    while (true) {
        const std::size_t ende = relativ.find('/', start);
        if (ende == std::string::npos) { return false; }
        if (relativ.compare(start, ende - start, "external") == 0) { return true; }
        if (relativ.compare(start, ende - start, ".git") == 0) { return true; }
        start = ende + 1;
    }
}

// Das SOLL: was der Gang gesehen haben MUSS. Es kommt aus git und aus einem direkten
// stat, nie aus dem Gang. git_ok == false ist ein WERKZEUG-AUSFALL und nie eine leere
// Liste -- die beiden duerfen nicht denselben Wert haben.
struct NennerSoll {
    bool                     git_ok = false;
    std::string              diagnose;
    std::size_t              getrackt_gesamt = 0; // alle getrackten .sh/.yml/.yaml
    std::vector<std::string> im_gang;             // davon: nicht ausgeschlossen UND auf der Platte
};

NennerSoll nenner_soll_aus_git(const std::filesystem::path& wurzel) {
    NennerSoll           soll;
    const EchteGitQuelle git(wurzel);
    if (!git.ist_arbeitsbaum()) {
        soll.diagnose = "git nennt unter '" + wurzel.string() + "' keinen Arbeitsbaum";
        return soll;
    }
    // DIE WURZELN MUESSEN DIESELBE SEIN. Antwortete git ueber einen ANDEREN Baum als den
    // gegangenen, fiele der Abgleich beliebig aus. Verglichen wird ueber equivalent(),
    // also ueber die Inode: ein Symlink im Pfad -- genau die /builds/-Lage des Runners --
    // darf hier nichts entscheiden, und ein Zeichenketten-Vergleich taete es.
    std::error_code fehler;
    if (!std::filesystem::equivalent(git.wurzel(), wurzel, fehler) || fehler) {
        soll.diagnose =
            "git-Wurzel '" + git.wurzel().string() + "' ist nicht der gegangene Baum '" + wurzel.string() + "'";
        return soll;
    }
    for (const char* muster : {"*.sh", "*.yml", "*.yaml"}) {
        const DateiBestand bestand = git.ls_files_z(muster);
        if (!bestand.werkzeug_ok) {
            soll.diagnose = std::string("git ls-files ") + muster + " hat nicht geantwortet: " + bestand.diagnose;
            return soll;
        }
        for (const std::string& pfad : bestand.pfade) {
            if (pfad.empty()) { continue; }
            soll.getrackt_gesamt += 1;
            if (git_pfad_bleibt_draussen(pfad)) { continue; }
            // DIREKTER stat auf den BENANNTEN Pfad -- nicht der Iterator. Genau deshalb
            // ueberlebt diese Frage jede Manipulation des Gangs. Und deshalb ist eine im
            // Arbeitsbaum geloeschte, aber noch indizierte Datei kein Fehlalarm: sie
            // faellt hier heraus, statt spaeter als "nicht gegangen" gemeldet zu werden.
            std::error_code art;
            if (!std::filesystem::is_regular_file(wurzel / pfad, art) || art) { continue; }
            soll.im_gang.push_back(pfad);
        }
    }
    std::sort(soll.im_gang.begin(), soll.im_gang.end());
    soll.git_ok = true;
    return soll;
}

// REINE FUNKTION: welche Soll-Pfade fehlen im Gang? Ohne git, ohne Platte, ohne Zustand --
// damit sie fuer sich geprueft werden kann. 'gesehen' kommt sortiert aus riegel_scan.
std::vector<std::string> fehlende_im_gang(const std::vector<std::string>& soll,
                                          const std::vector<std::string>& gesehen) {
    std::vector<std::string> fehlend;
    for (const std::string& pfad : soll) {
        if (!std::binary_search(gesehen.begin(), gesehen.end(), pfad)) { fehlend.push_back(pfad); }
    }
    return fehlend;
}

// Groesse als int -- die Vergleiche unten halten int gegen int, statt eine
// vorzeichenlose Subtraktion zu riskieren.
int gross(const std::vector<std::string>& liste) { return static_cast<int>(liste.size()); }

std::string erste_drei(const std::vector<std::string>& liste) {
    std::ostringstream aus;
    for (std::size_t i = 0; i < liste.size() && i < 3; ++i) { aus << (i > 0 ? ", " : "") << liste[i]; }
    if (liste.size() > 3) { aus << ", ... (+" << (liste.size() - 3) << " weitere)"; }
    return aus.str();
}

// DER RIEGEL. Als AssertionResult, damit ihn jeder Fall gleich faehrt und BEIDE ZAHLEN --
// Soll und Ist -- in JEDER Meldung stehen (V-1). Er gilt fuer den ECHTEN Baum: (ii) und
// (iii) sind auf ihn eingefroren und haben in einem Wegwerf-Repo nichts zu suchen.
testing::AssertionResult nenner_haelt(const NennerSoll& soll, const Riegelbefund& b) {
    if (!soll.git_ok) {
        return testing::AssertionFailure()
               << "FAIL-CLOSED: das Soll aus fremder Quelle fehlt -- " << soll.diagnose
               << ". Ohne zweite Aufzaehlung ist der Gang unbewacht, und ein unbewachter Nenner "
               << "ist kein Gruen. IST: " << befund_nenner(b);
    }
    const std::vector<std::string> fehlend = fehlende_im_gang(soll.im_gang, b.gesehen);
    if (!fehlend.empty()) {
        return testing::AssertionFailure()
               << "DER GANG IST VERKUERZT -- SOLL " << soll.im_gang.size() << " Skripte (git ls-files, "
               << soll.getrackt_gesamt << " getrackt), IST " << b.skripte << " gesehen; " << fehlend.size()
               << " fehlen: " << erste_drei(fehlend) << ". " << befund_nenner(b);
    }
    std::vector<std::string> anker_fehlen;
    for (const char* anker : W29_ANKER) {
        if (!std::binary_search(b.gesehen.begin(), b.gesehen.end(), std::string(anker))) {
            anker_fehlen.push_back(anker);
        }
    }
    if (!anker_fehlen.empty()) {
        return testing::AssertionFailure()
               << "EINGEFRORENE ANKER FEHLEN IM GANG -- SOLL " << (sizeof(W29_ANKER) / sizeof(W29_ANKER[0]))
               << " Anker, IST " << b.skripte << " Skripte gesehen; nicht dabei: " << erste_drei(anker_fehlen)
               << ". Entweder ist der Gang verkuerzt, oder die Datei ist weg und die Anker-Zeile "
               << "in (4a) ist nachzuziehen -- der Riegel ist es nicht. " << befund_nenner(b);
    }
    if (b.skripte < W29_NENNER_UNTERGRENZE) {
        return testing::AssertionFailure()
               << "NENNER UNTER DER EINGEFRORENEN GRENZE -- SOLL mindestens " << W29_NENNER_UNTERGRENZE << ", IST "
               << b.skripte << ". " << befund_nenner(b);
    }
    return testing::AssertionSuccess() << "SOLL " << soll.im_gang.size() << ", IST " << b.skripte;
}

TEST_F(WideFall, DieKonkatenationStehtImBaumGenauEinmal) {
    // T-3: die Grundgesamtheit kommt aus einem Verzeichnis-Durchlauf, nicht aus einer
    // Liste im Pruefling. V-1: der Nenner steht in der MELDUNG, nicht nur im Kopf.
    const std::filesystem::path wurzel(COMDARE_REPO_WURZEL_W29);
    const Riegelbefund          b = riegel_scan(wurzel);
    RecordProperty("nenner_verzeichnisse", std::to_string(b.verzeichnisse));
    RecordProperty("nenner_dateien", std::to_string(b.dateien));
    RecordProperty("nenner_skripte", std::to_string(b.skripte));
    RecordProperty("nenner_code_zeilen", std::to_string(b.code_zeilen));
    RecordProperty("nenner_nennungen", std::to_string(b.nennungen.size()));

    // V-8: eine Null ohne Nenner ist kein Gruen. Der Gang muss ueberhaupt stattgefunden
    // haben, bevor sein Ergebnis etwas bedeutet.
    ASSERT_GT(b.skripte, 0) << "0 Skripte angesehen -- die Wache ist blind, nicht gruen. " << befund_nenner(b);

    // POSTEN M4 -- DER NENNER-RIEGEL. Die Null oben ist zu wenig: 31 statt 100 Skripte war
    // am 10.08.2026 literal gruen. Das SOLL kommt aus git und aus einem direkten stat,
    // nicht aus dem Gang (T-3); die Begruendung samt dem, was die Wahl NICHT deckt, steht
    // vollstaendig in (4a) unmittelbar oben.
    const NennerSoll soll = nenner_soll_aus_git(wurzel);
    RecordProperty("nenner_soll_git", std::to_string(soll.im_gang.size()));
    RecordProperty("nenner_soll_getrackt", std::to_string(soll.getrackt_gesamt));
    // V-1: BEIDE ZAHLEN in die Ausgabe, nicht nur in die Fehlermeldung. Wer den Lauf liest,
    // soll den Nenner sehen, ohne dass erst etwas kaputt sein muss.
    std::cout << "[  NENNER  ] SOLL " << soll.im_gang.size() << " Skripte (git ls-files, " << soll.getrackt_gesamt
              << " getrackt) -- IST " << b.skripte << " gesehen; " << befund_nenner(b) << std::endl;
    ASSERT_TRUE(nenner_haelt(soll, b));
    // FAIL-CLOSED: ein Skript, das nicht gelesen werden konnte, ist ein Loch im Nenner und
    // damit kein Gruen. Es zu uebergehen hiesse, "nicht angesehen" fuer "sauber" zu halten.
    const std::string erstes_unlesbares = befund_unlesbar(b);
    ASSERT_TRUE(b.unlesbar.empty()) << "unlesbare Skripte im Gang -- der Nenner hat ein Loch: " << erstes_unlesbares
                                    << " (" << befund_nenner(b) << ")";

    ASSERT_EQ(b.implementierungen.size(), 1u)
        << "ZWILLING: die WIDE-Konkatenation ist nicht genau einmal implementiert. " << befund_nenner(b)
        << befund_liste(b);
    // POSITIV-TEST (V-8, schaerfer als 'angesehen > 0'): die eine Implementierung ist
    // die BEKANNTE. Waere der Gang je wieder verkrueppelt, faenge er 0 statt 1 -- und
    // diese Zeile sagt, welche Datei gefehlt hat, statt nur eine Zahl zu nennen.
    EXPECT_EQ(b.implementierungen.front().datei, "ci/wide_aggregat.sh")
        << "die eine Implementierung liegt nicht dort, wo sie liegen soll. " << befund_nenner(b) << befund_liste(b);
}

TEST_F(WideFall, EinVerkuerzterGangMachtDenNennerRiegelRot) {
    // K13 BEIDSEITIG, AM ECHTEN BAUM. Der Koeder ist genau der Mutant, der am 10.08.2026
    // noch ueberlebte: der Gang wird auf Zweige verkuerzt, 'ci' bleibt stehen. Die eine
    // Implementierung wird also weiterhin gefunden -- der ALTE Riegel bleibt gruen --, und
    // nur der NENNER faellt. Wer 'ci' mit abschnitte, scheiterte schon am Positiv-Test und
    // bewiese ueber den Nenner nichts; deshalb ist 'ci' vom Wurf ausgenommen.
    const std::filesystem::path wurzel(COMDARE_REPO_WURZEL_W29);
    const NennerSoll            soll = nenner_soll_aus_git(wurzel);
    ASSERT_TRUE(soll.git_ok) << "ohne fremdes Soll ist dieser Fall nicht fahrbar: " << soll.diagnose;

    // (a) DER GEGENKOEDER ZUERST (T-1): unmanipuliert ist der Riegel GRUEN. Ohne diese
    //     Haelfte waere eine immer-rote Wache von einer richtigen nicht zu unterscheiden.
    const Riegelbefund voll = riegel_scan(wurzel);
    ASSERT_TRUE(nenner_haelt(soll, voll));

    // (b) DIE GEWUERFELTE GRENZE. Welche obersten Zweige es ueberhaupt gibt, kommt aus dem
    //     SOLL (git) -- nicht aus dem Gang, den der Koeder gleich manipuliert.
    std::vector<std::string> zweige;
    for (const std::string& pfad : soll.im_gang) {
        const std::size_t schnitt = pfad.find('/');
        if (schnitt == std::string::npos) { continue; } // Datei in der Wurzel, kein Zweig
        const std::string zweig = pfad.substr(0, schnitt);
        if (zweig == "ci") { continue; }
        if (std::find(zweige.begin(), zweige.end(), zweig) == zweige.end()) { zweige.push_back(zweig); }
    }
    std::sort(zweige.begin(), zweige.end());
    ASSERT_FALSE(zweige.empty()) << "kein Zweig ausser 'ci' traegt Skripte -- dann liesse sich dieser "
                                 << "Koeder nicht formulieren und der Fall waere ein stilles Gruen. "
                                 << befund_nenner(voll);

    std::vector<std::string> gekappt;
    for (const std::string& zweig : zweige) {
        if (wuerfel_.zahl(0, 1) == 1) { gekappt.push_back(zweig); }
    }
    // Der Wurf darf leer ausfallen; dann wird EIN gewuerfelter Zweig erzwungen. Ein Koeder,
    // der sich je nach Wurf selbst ueberspringt, waere keiner.
    if (gekappt.empty()) { gekappt.push_back(zweige[static_cast<std::size_t>(wuerfel_.zahl(0, gross(zweige) - 1))]); }
    RecordProperty("gekappte_zweige", erste_drei(gekappt));

    const Riegelbefund mutant =
        riegel_scan(wurzel, [&gekappt](const std::filesystem::path& v, const std::string& relativ) {
            if (verzeichnis_bleibt_draussen(v, relativ)) { return true; }
            return std::find(gekappt.begin(), gekappt.end(), relativ) != gekappt.end();
        });

    // DER ALTE RIEGEL BLEIBT GRUEN -- das ist die Aussage des Postens, hier festgehalten
    // statt erzaehlt: die Zahl der Implementierungen sagt ueber den Nenner NICHTS.
    ASSERT_EQ(mutant.implementierungen.size(), 1u)
        << "der Koeder sollte die eine Implementierung stehen lassen -- sonst prueft dieser Fall "
        << "den Positiv-Test und nicht den Nenner. " << befund_nenner(mutant) << befund_liste(mutant);
    EXPECT_EQ(mutant.implementierungen.front().datei, "ci/wide_aggregat.sh");
    ASSERT_LT(mutant.skripte, voll.skripte) << "der Koeder hat den Gang gar nicht verkuerzt -- dann beweist "
                                            << "sein Biss nichts. " << befund_nenner(mutant);

    // UND DER NENNER-RIEGEL BEISST. Die Meldung wird GEDRUCKT, nicht nur geprueft: ein
    // Biss, den niemand im Lauf sieht, ist eine Behauptung ueber einen Biss (V-8).
    const testing::AssertionResult verdikt = nenner_haelt(soll, mutant);
    std::cout << "[  BISS    ] gekappt: " << erste_drei(gekappt) << " -- " << verdikt.message() << std::endl;
    EXPECT_FALSE(verdikt) << "DER KOEDER HAT NICHT GEBISSEN: der Gang sah nur noch " << mutant.skripte << " von "
                          << soll.im_gang.size() << " Skripten -- und der Nenner-Riegel blieb "
                          << "gruen. Genau dieser Zustand war bis zum 10.08.2026 der Bestand. "
                          << befund_nenner(mutant);
    // Er NENNT, was fehlt, statt nur eine Zahl zu melden -- sonst waere die Meldung so
    // wenig verwertbar wie das stille Gruen, das sie ersetzt.
    const std::vector<std::string> fehlend = fehlende_im_gang(soll.im_gang, mutant.gesehen);
    ASSERT_FALSE(fehlend.empty()) << "der gekappte Zweig trug keine Skripte -- der Koeder hat nichts entfernt. "
                                  << befund_nenner(mutant);
    EXPECT_THAT(std::string(verdikt.message()), HasSubstr(fehlend.front()))
        << "die Meldung nennt die erste fehlende Datei nicht: " << verdikt.message();
    // BEIDE ZAHLEN in der Meldung (V-1), woertlich nachgefordert statt geglaubt.
    EXPECT_THAT(std::string(verdikt.message()), HasSubstr(std::to_string(soll.im_gang.size())));
    EXPECT_THAT(std::string(verdikt.message()), HasSubstr(std::to_string(mutant.skripte)));
}

TEST_F(WideFall, DasSollKommtAusGitUndNichtAusDemGang) {
    // T-4 GEGENEINGANG fuer das SOLL selbst. Ohne diesen Fall bliebe unbewiesen, dass
    // nenner_soll_aus_git ueberhaupt git liest -- eine Funktion, die immer dieselbe Liste
    // lieferte, saehe von aussen genauso aus. Gefahren wird gegen ein WEGWERF-REPO, in dem
    // jeder Eintrag von Hand abgezaehlt ist (zweite Quelle), mit gewuerfelten Namen.
    FixtureRepo repo;
    ASSERT_TRUE(repo.init());
    const std::string koeder = wuerfel_.token(16);
    RecordProperty("koeder", koeder);

    // (a) verfolgt UND auf der Platte -- gehoert ins Soll.
    ASSERT_TRUE(repo.schreibe_und_verfolge("ci/w_" + koeder + ".sh", "#!/bin/sh\necho " + koeder + "\n"));
    ASSERT_TRUE(repo.schreibe_und_verfolge("stufe/zwei_" + koeder + ".yml", "job:\n  script: [echo]\n"));
    // (b) NICHT verfolgt -- git kennt es nicht, der Gang sieht es sehr wohl. Das Soll ist
    //     eine UNTERGRENZE, keine Gleichheit; deshalb darf es hier fehlen.
    ASSERT_TRUE(repo.schreibe("ci/unverfolgt_" + koeder + ".sh", "#!/bin/sh\n"));
    // (c) verfolgt, aber im Arbeitsbaum GELOESCHT -- git nennt es, die Platte nicht. Es darf
    //     NICHT ins Soll, sonst waere jeder halbfertige Checkout ein Fehlalarm.
    ASSERT_TRUE(repo.schreibe_und_verfolge("ci/weg_" + koeder + ".sh", "#!/bin/sh\n"));
    ASSERT_TRUE(repo.loesche_aus_arbeitsbaum("ci/weg_" + koeder + ".sh"));
    // (d) verfolgt, aber unter einem SEGMENT 'external' -- draussen, wie im Gang.
    ASSERT_TRUE(repo.schreibe_und_verfolge("Code/external/fremd_" + koeder + ".sh", "#!/bin/sh\n"));
    // (e) verfolgt, aber unter 'my_external_tool' -- das ist KEIN Segment 'external' und
    //     bleibt drin. Der Gegeneingang zur Teilzeichenketten-Falle (/build vs. /builds/).
    ASSERT_TRUE(repo.schreibe_und_verfolge("my_external_tool/drin_" + koeder + ".sh", "#!/bin/sh\n"));
    // (f) keine Skript-Endung -- danach wird gar nicht erst gefragt.
    ASSERT_TRUE(repo.schreibe_und_verfolge("ci/notiz_" + koeder + ".md", "text\n"));

    const NennerSoll soll = nenner_soll_aus_git(repo.pfad());
    ASSERT_TRUE(soll.git_ok) << soll.diagnose;
    // WOERTLICH zurueckgefordert, nicht gezaehlt: (b) fehlt (unverfolgt), (c) fehlt (nicht
    // auf der Platte), (d) fehlt (Segment 'external'), (f) fehlt (keine Skript-Endung).
    EXPECT_THAT(soll.im_gang, UnorderedElementsAre("ci/w_" + koeder + ".sh", "my_external_tool/drin_" + koeder + ".sh",
                                                   "stufe/zwei_" + koeder + ".yml"));
    EXPECT_EQ(soll.getrackt_gesamt, 5u) << "fuenf getrackte Skripte: (a) zwei, (c) eins, (d) eins, (e) eins. "
                                        << "Die .md aus (f) wird nicht abgefragt.";

    // UND DER ABGLEICH HAELT: der Gang sieht alles aus dem Soll -- und MEHR, naemlich die
    // unverfolgte Datei aus (b). Mehr ist erlaubt, weniger nicht.
    const Riegelbefund b = riegel_scan(repo.pfad());
    EXPECT_TRUE(fehlende_im_gang(soll.im_gang, b.gesehen).empty())
        << "der Gang hat ein getracktes Skript nicht gesehen. " << befund_nenner(b);
    EXPECT_GT(b.skripte, gross(soll.im_gang))
        << "der Gang muesste MEHR sehen als git nennt (die unverfolgte Datei aus (b)) -- sonst "
        << "misst das Soll nicht als Untergrenze, sondern als Gleichheit. " << befund_nenner(b);
}

TEST_F(WideFall, OhneGitIstDasSollRotUndNichtLeer) {
    // FAIL-CLOSED, der Gegeneingang zur schlimmsten Verwechslung: "git hat nicht
    // geantwortet" darf nicht wie "es gibt nichts" aussehen. Ein leeres Soll waere
    // NAEMLICH IMMER ERFUELLT -- die Wache liefe weiter und sagte nichts mehr aus. Die
    // Werkstatt ist ein gewoehnliches Verzeichnis ohne .git.
    const NennerSoll soll = nenner_soll_aus_git(werk_.pfad());
    EXPECT_FALSE(soll.git_ok) << "ein Verzeichnis ohne git-Arbeitsbaum wurde als gueltiges Soll gewertet";
    EXPECT_TRUE(soll.im_gang.empty());
    EXPECT_THAT(soll.diagnose, HasSubstr("Arbeitsbaum")) << "die Diagnose benennt den Grund nicht: " << soll.diagnose;
    // UND DER RIEGEL MACHT DARAUS ROT, nicht Gruen-mit-leerem-Soll.
    Riegelbefund frei;
    frei.skripte = 4711; // ein Gang, der alles gesehen haette -- und trotzdem kein Gruen
    EXPECT_FALSE(nenner_haelt(soll, frei))
        << "ohne fremdes Soll war der Riegel gruen -- genau der stille Rueckfall, den (4a) verbietet";
}

TEST_F(WideFall, EinPfadMitBuildsImNamenBlendetDenRiegelNichtAus) {
    // GENAU DER CI-FEHLSCHLAG seit Pipeline 15529, als dauerhafte Zusicherung. Der
    // Runner checkt nach /home/gitlab-runner/builds/... aus; ein Ausschluss, der
    // "/build" als Teilzeichenkette des ABSOLUTEN Pfades sucht, schliesst dort alles
    // aus. Dieser Fall ist pfad-unabhaengig: er baut die Falle selbst nach.
    const std::string koeder = wuerfel_.token(16);
    RecordProperty("koeder", koeder);
    ASSERT_TRUE(werk_.schreibe("builds/runner/0/repo/ci/wide_aggregat.sh",
                               "#!/bin/sh\n  tail -n +2 \"$rcsv\" | awk 1 >> \"$WIDE\"  # " + koeder + "\n"));

    const Riegelbefund b = riegel_scan(werk_.pfad() / "builds/runner/0/repo");
    EXPECT_GT(b.skripte, 0) << "0 Skripte angesehen -- der Pfad hat die Wache geblendet. " << befund_nenner(b);
    ASSERT_EQ(b.implementierungen.size(), 1u)
        << "die gepflanzte Implementierung wurde nicht gefunden. " << befund_nenner(b) << befund_liste(b);
    EXPECT_EQ(b.implementierungen.front().datei, "ci/wide_aggregat.sh");

    // GEGENEINGANG (T-4): ein Bau-Verzeichnis INNERHALB der Wurzel bleibt sehr wohl
    // draussen. Der Ausschluss ist geschaerft, nicht abgeschafft. Erkannt wird es an
    // CMakeCache.txt, nicht am Namen -- deshalb liegt hier eine echte Cache-Datei.
    ASSERT_TRUE(werk_.schreibe("builds/runner/0/repo/build-w/CMakeCache.txt", "CMAKE_PROJECT_NAME:STATIC=probe\n"));
    ASSERT_TRUE(werk_.schreibe("builds/runner/0/repo/build-w/kopie.sh", "  tail -n +2 \"$x\" | awk 1 >> \"$W\"\n"));
    const Riegelbefund c = riegel_scan(werk_.pfad() / "builds/runner/0/repo");
    EXPECT_EQ(c.implementierungen.size(), 1u)
        << "das Bau-Verzeichnis unter der Wurzel haette draussen bleiben muessen. " << befund_nenner(c)
        << befund_liste(c);

    // UND DIE GEGENPROBE ZUR GEGENPROBE: derselbe Ordner OHNE CMakeCache.txt ist ein
    // gewoehnliches Quellverzeichnis und wird gelesen. Sonst waere nicht gezeigt, dass die
    // BEDINGUNG traegt und nicht doch der Name 'build-w'.
    ASSERT_TRUE(werk_.schreibe("nurname/repo/ci/wide_aggregat.sh", "  tail -n +2 \"$r\" | awk 1 >> \"$W\"\n"));
    ASSERT_TRUE(werk_.schreibe("nurname/repo/build-w/kopie.sh", "  tail -n +2 \"$x\" | awk 1 >> \"$W\"\n"));
    const Riegelbefund d = riegel_scan(werk_.pfad() / "nurname/repo");
    EXPECT_EQ(d.implementierungen.size(), 2u)
        << "ohne CMakeCache.txt ist 'build-w' nur ein Name -- der Riegel haette hineinsehen muessen. "
        << befund_nenner(d) << befund_liste(d);
}

TEST_F(WideFall, DokumentationDerFalleMachtDenRiegelNichtRot) {
    // T-1 KEIN DAUERALARM: wer die geheilte Falle beschreibt, darf die Wache nicht
    // ausloesen. Alle vier Eingaenge hier sind dem Bestand nachgebaut.
    const std::string koeder = wuerfel_.token(16);
    RecordProperty("koeder", koeder);
    ASSERT_TRUE(werk_.schreibe("doku/ci/wide_aggregat.sh", "#!/bin/sh\n  tail -n +2 \"$rcsv\" | awk 1 >> \"$WIDE\"\n"));
    // (a) ein Kommentar, der die Falle BESCHREIBT -- ci/anhang_forward_core.sh:49.
    ASSERT_TRUE(werk_.schreibe("doku/ci/anhang_forward_core.sh",
                               "#   (F3) DIE KONKATENATION VERKLEBTE ZEILEN. 'tail -n +2 >>' ohne 'awk 1' haengte\n"
                               "echo " +
                                   koeder + "\n"));
    // (b) Zeilen, die das Muster nur als Zeichenkette TRAGEN -- die sed-Mutanten und der
    //     printf-Koeder aus ci/tests/anhang_forward_probe.sh:578/804/809.
    ASSERT_TRUE(werk_.schreibe("doku/ci/tests/anhang_forward_probe.sh",
                               "_n2b='s@^  tail -n +2 \"$rcsv\" .*$@  tail -n +2 \"$rcsv\" >> \"$WIDE\"@'\n"
                               "printf 'tail -n +2 \"$rc\" | awk 1 >> \"$WIDE\"\\n' >> \"$KOEDER_A11\"\n"));
    // (c) dieselbe TECHNIK fuer einen anderen Zweck -- scripts/ci_host_klassen_bericht.sh:174.
    //     'awk 1' erzwingt dort den Schluss-Newline einer git-config-Liste; es gibt keinen
    //     Kopfzeilen-Sprung, keine N-nach-1-Zusammenfuehrung, kein Mess-Aggregat.
    ASSERT_TRUE(werk_.schreibe("doku/scripts/ci_host_klassen_bericht.sh",
                               "git config --get-regexp x | awk '{print $2}' | awk 1 >> \"$TMP/submodule.txt\"\n"));
    // (d) Prosa. .md wird ohnehin nicht geoeffnet -- der Fall haelt das fest.
    ASSERT_TRUE(werk_.schreibe("doku/docs/LEDGER.md", "plus `tail -n +2 >> $WIDE` in der Kette\n"));

    const Riegelbefund b = riegel_scan(werk_.pfad() / "doku");
    ASSERT_EQ(b.implementierungen.size(), 1u)
        << "Doku, sed-Muster und eine gleichnamige Technik duerfen nicht als Implementierung zaehlen. "
        << befund_nenner(b) << befund_liste(b);
    EXPECT_EQ(b.implementierungen.front().datei, "ci/wide_aggregat.sh");
    // GEGENPROBE (V-8): die Nennungen sind da. Ohne sie waere nicht unterscheidbar, ob
    // der Riegel richtig trennt oder ob er gar nichts mehr sieht.
    EXPECT_GT(b.nennungen.size(), 0u) << "keine einzige Nennung erkannt -- dann trennt hier nichts, "
                                      << "es sieht nur nichts mehr. " << befund_nenner(b);
}

TEST_F(WideFall, EineEchteZweiteImplementierungMachtDenRiegelRot) {
    // T-4/K13 DER KOEDER MUSS BEISSEN. Eine Wache, die eine echte zweite Implementierung
    // durchlaesst, hat die Aufgabe des Postens (#29: drei Kopien zu einer machen)
    // unbewacht gelassen -- das waere die schlechteste aller Loesungen.
    const std::string koeder = wuerfel_.token(16);
    RecordProperty("koeder", koeder);
    ASSERT_TRUE(
        werk_.schreibe("koeder/ci/wide_aggregat.sh", "#!/bin/sh\n  tail -n +2 \"$rcsv\" | awk 1 >> \"$WIDE\"\n"));
    const Riegelbefund vorher = riegel_scan(werk_.pfad() / "koeder");
    ASSERT_EQ(vorher.implementierungen.size(), 1u)
        << "der Ausgangszustand ist nicht EINE Implementierung. " << befund_nenner(vorher) << befund_liste(vorher);

    // Der Koeder ist gewuerfelt benannt UND gewuerfelt markiert -- nichts abgeschrieben.
    ASSERT_TRUE(werk_.schreibe("koeder/ci/zweitkopie_" + koeder + ".sh",
                               "#!/bin/sh\n# marker " + koeder + "\n  tail -n +2 \"$f\" | awk 1 >> \"$AGG\"\n"));
    // Und derselbe Koeder als INLINE-Fassung in der YAML -- der Weg, auf dem die drei
    // Kopien seinerzeit entstanden sind.
    ASSERT_TRUE(werk_.schreibe("koeder/.gitlab-ci.yml",
                               "script:\n  - tail -n +2 \"$f\" | awk 1 >> wide_aggregate.csv  # " + koeder + "\n"));

    const Riegelbefund nachher = riegel_scan(werk_.pfad() / "koeder");
    ASSERT_EQ(nachher.implementierungen.size(), 3u)
        << "DER KOEDER HAT NICHT GEBISSEN -- eine echte zweite (und dritte) Implementierung "
        << "ist unbemerkt geblieben. " << befund_nenner(nachher) << befund_liste(nachher);
    // Und der Riegel NENNT sie, statt nur eine Zahl zu melden -- ueber ZUGEHOERIGKEIT
    // gefragt, nicht ueber die Position im Ergebnis.
    EXPECT_TRUE(nennt_implementierung(nachher, "ci/zweitkopie_" + koeder + ".sh"))
        << "die gewuerfelte Zweitkopie wird nicht benannt. " << befund_nenner(nachher) << befund_liste(nachher);
    EXPECT_TRUE(nennt_implementierung(nachher, ".gitlab-ci.yml"))
        << "die INLINE-Fassung in der YAML wird nicht benannt -- und genau dort standen ZWEI der drei "
        << "urspruenglichen Kopien. " << befund_nenner(nachher) << befund_liste(nachher);
    EXPECT_TRUE(nennt_implementierung(nachher, "ci/wide_aggregat.sh"))
        << "die echte Fassung fehlt im Befund. " << befund_nenner(nachher) << befund_liste(nachher);
}

TEST_F(WideFall, NurCodeTrenntTunVonNennen) {
    // Die Trennlinie selbst, an den WOERTLICHEN Zeilen des Bestands (10.08.2026).
    // TUT es -- ci/wide_aggregat.sh:173:
    EXPECT_NE(nur_code("  tail -n +2 \"$rcsv\" | awk 1 >> \"$WIDE\"").find("tail -n +2"), std::string::npos);
    EXPECT_NE(nur_code("  tail -n +2 \"$rcsv\" | awk 1 >> \"$WIDE\"").find(">>"), std::string::npos);
    // NENNT es nur -- und zwar auf jede der vier Arten, die im Baum vorkommen:
    //   ci/anhang_forward_core.sh:49 (Kommentar)
    EXPECT_EQ(nur_code("#   (F3) ... 'tail -n +2 >>' ohne 'awk 1' haengte"), "");
    //   ci/tests/anhang_forward_probe.sh:804 (sed-Ausdruck in Hochkommata)
    EXPECT_EQ(nur_code("    _n2b='s@^  tail -n +2 \"$rcsv\" .*$@  tail -n +2 \"$rcsv\" >> \"$WIDE\"@'").find("tail"),
              std::string::npos);
    //   ci/tests/anhang_forward_probe.sh:578 (printf-Format; das '>>' der Zeile bleibt,
    //   der Kopfzeilen-Sprung nicht -- deshalb ist die UND-Bedingung noetig)
    const std::string p578 = nur_code("    printf 'zeile: tail -n +2 \"$rc\" | awk 1 >> \"$W\"\\n' >> \"$KOEDER\"");
    EXPECT_EQ(p578.find("tail -n +2"), std::string::npos);
    EXPECT_NE(p578.find(">>"), std::string::npos);
    //   ci/wide_aggregat.sh:172 -- der Kopfzeilen-Griff. Er haengt an, springt aber
    //   nicht: 'head -1' ist eine ANDERE Operation und darf nicht mitzaehlen.
    const std::string h172 = nur_code("  [ \"$_hdr\" = \"0\" ] && { head -1 \"$rcsv\" | awk 1 >> \"$WIDE\"; }");
    EXPECT_EQ(h172.find("tail -n +2"), std::string::npos);
    // GEGENEINGANG (T-4): ein '#' MITTEN in einem Wort ist kein Kommentar -- sonst
    // schnitte der Zerleger '${#feld}' weg und maesse zu wenig.
    EXPECT_NE(nur_code("n=${#feld}; tail -n +2 $a >> $b").find("tail -n +2"), std::string::npos);
}

TEST_F(WideFall, DreiAufrufstellenRufenDieEineDatei) {
    // Der NENNER der Aufrufer, aus fremder Quelle: die YAML und der Kern werden gelesen,
    // nicht der Aggregator gefragt. Kommentarzeilen zaehlen NICHT als Aufruf --
    // 'grep -c' haette einen auskommentierten Aufruf mitgezaehlt.
    const std::filesystem::path wurzel(COMDARE_REPO_WURZEL_W29);
    const auto                  yml = comdare::ci_wachen::lies_zeilen(wurzel / ".gitlab-ci.yml");
    ASSERT_TRUE(yml.has_value()) << ".gitlab-ci.yml nicht lesbar -- fail-closed, kein Gruen";
    const auto kern = comdare::ci_wachen::lies_zeilen(wurzel / "ci" / "anhang_forward_core.sh");
    ASSERT_TRUE(kern.has_value()) << "ci/anhang_forward_core.sh nicht lesbar";

    const std::size_t yml_aufrufe  = comdare::ci_wachen::zaehle_wirksam(*yml, "sh ../ci/wide_aggregat.sh");
    const std::size_t kern_aufrufe = comdare::ci_wachen::zaehle_wirksam(*kern, "sh \"$AF_WIDE_AGGREGAT\"");
    const std::size_t gesamt       = yml_aufrufe + kern_aufrufe;

    EXPECT_EQ(yml_aufrufe, 2u) << "measure:smoke und measure:golden-320 -- zwei Aufrufe, nicht mehr, nicht weniger";
    EXPECT_EQ(kern_aufrufe, 1u) << "der Anhang-Kern ruft ueber die Variable AF_WIDE_AGGREGAT (Grossschreibung!) -- "
                                << "ein case-sensitives grep nach 'wide_aggregat' findet diesen Aufruf NICHT";
    EXPECT_EQ(gesamt, 3u) << "DER NENNER: 3 echte Aufrufe. Er steht hier, damit niemand die 39 Nennungen "
                          << "im Baum fuer die Zahl der Aufrufer haelt.";
    // GEGENPROBE (V-8): das Muster greift ueberhaupt. Sonst meldete '0 Zwillinge' Erfolg.
    EXPECT_GT(comdare::ci_wachen::zaehle_roh(*yml, "wide_aggregat"), yml_aufrufe)
        << "roh muss mehr sein als wirksam -- sonst misst das Muster nichts";
}

} // namespace
