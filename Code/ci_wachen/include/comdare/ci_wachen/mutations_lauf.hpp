// mutations_lauf.hpp -- DER MUTATIONS-HARNESS.                            (2026-08-10)
//
// WOZU. Der Designplan V7 (docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-
// wellen.md, Abschnitt 2) ordnet 117 Posten in sieben Testklassen. Die GROESSTE heisst
// K1 keine-negativprobe (29 von 117) und ist woertlich in der Sprache des
// Mutationstestens formuliert: "Der Mutant ueberlebt, weil nur die gesunde Seite je
// betreten wird." K5 test-zementiert-defekt (10 von 117) ist die zweite. Ein Werkzeug,
// das diese Aussage MISST statt sie zu behaupten, gab es bisher nicht.
//
// WAS DIESER HARNESS TUT -- und was er ausdruecklich NICHT tut:
//   ER BAUT EINE PRODUKTIONS-MUTATION EIN, faehrt die Suite, protokolliert und NIMMT
//   DIE MUTATION ZURUECK. Er fuehrt KEIN fremdes Werkzeug ein (mull, Dextool): beide
//   verlangen eigene Pflege (LLVM-Version, Compiler-Plugin, eigene Konfiguration), und
//   das Fenster bis 15.09. traegt keine zweite Werkzeugkette. Der Preis dafuer steht
//   offen im Bericht: der Katalog ist HANDGESCHRIEBEN, also klein und nicht erschoepfend.
//
// DER UNTERSCHIED ZUM KOEDER-VERFAHREN (K13), der im Bericht gezogen werden MUSS:
//   Der Koeder prueft EINE Wache an EINER Stelle -- er beantwortet "beisst dieser eine
//   Test?". Der Mutations-Harness prueft die GESAMTE Suite gegen eine Fehlerpopulation
//   -- er beantwortet "wieviele Fehler dieser Art laufen ueberhaupt durch?". Das eine
//   ersetzt das andere nicht: der Koeder ist punktuell und scharf, der Harness ist
//   flaechig und grob.
//
// UND DER UNTERSCHIED ZU DEN VORHANDENEN Selbstbiss-TESTS: XmlWacheSelbstbiss.M1..M6
// und ParitySelbstbiss.M1..M5 mutieren das ORAKEL (die erwarteten Literale) im
// Speicher. Der Designplan V7 sagt dazu: "Produktions-Mutation schlaegt Test-Mutation.
// Der staerkste Beleg ist: unter der eingebauten Mutation werden NUR die neuen Tests
// rot, waehrend der Bestand gruen bleibt -- dann war der Bestand fuer diese
// Fehlerklasse blind." Genau diese Produktions-Mutation liefert dieser Harness.
//
// VIER AUSGAENGE STATT ZWEI -- und der Grund ist derselbe wie in prozess.hpp:
//   VomBauGetoetet   Der Uebersetzer nahm den Mutanten. Die Suite kam NIE zum Zug --
//                    das ist KEIN Beleg fuer Beissfaehigkeit der Tests und darf mit
//                    VomTestGetoetet nicht in einen Eimer fallen.
//   VomTestGetoetet  Bau gruen, mindestens ein Test rot. NUR das ist Test-Deckung.
//   Ueberlebend      Bau gruen, NULL Tests rot. Das ist ein BEFUND ueber die Suite,
//                    kein Fehler des Harness.
//   HarnessAbbruch   Der Harness konnte nicht messen. Fail-closed: ROT, nie Gruen und
//                    ausdruecklich nie "getoetet".
//
// ASCII-only, Zeilen <= 120 Byte.

#ifndef COMDARE_CI_WACHEN_MUTATIONS_LAUF_HPP
#define COMDARE_CI_WACHEN_MUTATIONS_LAUF_HPP

#include <array>
#include <cstddef>
#include <filesystem>
#include <optional>
#include <span>
#include <string>
#include <string_view>
#include <vector>

#include "comdare/ci_wachen/ergebnis.hpp"

namespace comdare::ci_wachen {

// ---- Die vier Ausgaenge eines Mutanten ---------------------------------------------
enum class MutantAusgang {
    VomBauGetoetet,
    VomTestGetoetet,
    Ueberlebend,
    HarnessAbbruch,
};

inline constexpr MutantAusgang alle_mutant_ausgaenge[] = {
    MutantAusgang::VomBauGetoetet,
    MutantAusgang::VomTestGetoetet,
    MutantAusgang::Ueberlebend,
    MutantAusgang::HarnessAbbruch,
};
static_assert(sizeof(alle_mutant_ausgaenge) / sizeof(alle_mutant_ausgaenge[0]) == 4,
              "MutantAusgang hat einen neuen Wert -- Tabelle und Fall-Tabellen nachziehen.");

std::string          ausgang_text(MutantAusgang ausgang);
inline std::ostream& operator<<(std::ostream& strom, MutantAusgang a) { return strom << ausgang_text(a); }

// ---- Die Testklassen des Designplans, auf die dieser Lauf zielt ---------------------
// NUR ZWEI von sieben. Das ist eine Beschraenkung, keine Vollstaendigkeit -- wer eine
// dritte Klasse fahren will, traegt sie hier ein und der static_assert erzwingt, dass
// klasse_text() und die Fall-Tabellen mitwachsen.
enum class Testklasse {
    KeineNegativprobe,   // K1, 29 von 117 Posten
    TestZementiertDefekt // K5, 10 von 117 Posten
};

inline constexpr Testklasse alle_testklassen[] = {
    Testklasse::KeineNegativprobe,
    Testklasse::TestZementiertDefekt,
};
static_assert(sizeof(alle_testklassen) / sizeof(alle_testklassen[0]) == 2,
              "Testklasse hat einen neuen Wert -- Tabelle und Fall-Tabellen nachziehen.");

std::string          klasse_text(Testklasse klasse);
inline std::ostream& operator<<(std::ostream& strom, Testklasse k) { return strom << klasse_text(k); }

// ---- Ein Mutant -------------------------------------------------------------------
// `erwartete_treffer` ist der Kern der Fail-Closed-Haertung: ein Mutant, dessen Anker
// nicht mehr GENAU so oft in der Datei steht, wird NICHT angewandt. Ohne diese Zahl
// wuerde eine Umformatierung der Produktionsdatei den Mutanten still ins Leere laufen
// lassen -- und ein Mutant, der nichts aendert, ueberlebt jede Suite. Das waere die
// "stille Null" in Reinform: der Harness meldete Deckung, wo er nichts gemessen hat.
struct Mutant {
    std::string_view id;
    std::string_view datei; // repo-relativ
    Testklasse       klasse;
    std::string_view aussage; // welche Zusicherung dieser Mutant aufhebt
    std::string_view suchen;
    std::string_view ersetzen;
    std::size_t      erwartete_treffer;
    // VORHERSAGE, nicht Zusicherung: welche Tests nach meinem Lesen des Bestandes rot
    // werden MUESSTEN. Eine Vorhersage, die nicht eintritt, ist selbst ein Befund --
    // deshalb steht sie im Katalog und nicht nur im Bericht. Leere Eintraege = keine.
    std::array<std::string_view, 2> erwartet_rot;
};

// Der Katalog. Er ist die Grundgesamtheit dieses Laufs (T-3: der Nenner steht NEBEN
// dem Pruefling, nicht in ihm).
std::span<const Mutant> katalog();

// Eingefrorener Soll-Nenner. Er steht hier und nicht in einem Test, damit ein Zuwachs
// des Katalogs an GENAU EINER Stelle nachgezogen werden muss.
inline constexpr std::size_t KATALOG_SOLL = 5;

// ---- DAS SELBSTBEZUGS-PROBLEM, am eigenen Objekt gemessen ---------------------------
// ERSTER LAUF 2026-08-10, woertlich: alle fuenf Mutanten "VOM-TEST-GETOETET" -- aber bei
// M4 und M5 waren die EINZIGEN zwei roten Tests
// MutationsKatalog.JederAnkerStehtGENAUSooftInDerECHTENProduktionsdatei und
// MutationsKatalog.JederMutantVERAENDERTDieDateiWIRKLICH. Beide lesen die
// Produktionsdatei VON DER PLATTE und werden deshalb von JEDEM Mutanten rot -- der
// Harness toetete seine eigenen Mutanten. Die Ueberlebensrate waere per Konstruktion
// immer 0 gewesen: das selbstreferenzielle Orakel in Reinform (Designplan V7, K5).
//
// DIE ABHILFE IST EIN MECHANISMUS, KEIN VORSATZ. Die Katalog-Faelle liegen in einem
// EIGENEN ctest-Ziel mit dem Zusatz-Label unten; der Harness waehlt die Suite mit
// `-LE <Label>` ab UND prueft danach die Auswahl per `ctest -N` gegen das Praefix.
// Faellt die Abwahl aus (Label umbenannt, Ziel verschoben), ist das ein ABBRUCH --
// fail-closed, nie ein stiller Nullwert.
inline constexpr std::string_view SELBSTBEZUG_LABEL   = "mut_selbstbezug";
inline constexpr std::string_view SELBSTBEZUG_PRAEFIX = "MutationsKatalog.";

// ---- Die reinen Bausteine (ohne Datei, ohne Prozess) --------------------------------
std::size_t zaehle_vorkommen(std::string_view heuhaufen, std::string_view nadel);

struct ErsetzErgebnis {
    bool        ok = false;
    std::string inhalt; // nur bei ok gefuellt
    std::size_t gefunden = 0;
    std::string diagnose; // bei !ok: warum nicht
};

// Ersetzt ALLE Vorkommen -- aber nur, wenn es GENAU `erwartete_treffer` sind. Vier
// Eingaenge sind ausdruecklich NICHT ok (T-4 Gegeneingang, jeder mit eigener Diagnose):
// leerer Anker, erwartete_treffer==0, Trefferzahl abweichend, suchen==ersetzen.
ErsetzErgebnis ersetze_genau(std::string_view inhalt, std::string_view suchen, std::string_view ersetzen,
                             std::size_t erwartete_treffer);

// ---- Was ctest berichtet ------------------------------------------------------------
// Gelesen wird die ZUSAMMENFASSUNGSZEILE ("N tests failed out of M"), nicht die
// Anwesenheit eines Wortes. Fehlt sie, ist das ein Abbruch -- ctest hat dann nicht
// geantwortet, und "keine Fehlermeldung gefunden" ist keine Aussage ueber die Suite.
struct CtestBefund {
    bool                     zusammenfassung_gelesen = false;
    int                      gefallen                = 0;
    int                      gesamt                  = 0;
    std::vector<std::string> rote_tests;
};

CtestBefund lies_ctest_befund(std::string_view ausgabe);

// Was `ctest -N` AUSWAEHLT. Der Harness braucht die NAMEN, nicht nur die Zahl: nur an
// ihnen laesst sich belegen, dass kein selbstbezueglicher Fall in der Suite steckt.
struct CtestListe {
    bool                     gesamtzeile_gelesen = false;
    int                      gesamt              = 0;
    std::vector<std::string> namen;
};

CtestListe lies_ctest_liste(std::string_view ausgabe);

// ---- Die Naht zur Aussenwelt --------------------------------------------------------
// Dieselbe Bauform wie GitQuelle/XmlParser: bauen, Suite fahren und den Arbeitsbaum
// befragen sind Parameter. Damit erreicht ein Test JEDEN der vier Ausgaenge, ohne
// cmake, ohne ctest und ohne git zu starten.
class LaufNaht {
public:
    virtual ~LaufNaht()                      = default;
    virtual bool        baue()               = 0; // true = Bau gruen
    virtual std::string fahre_suite()        = 0; // die VOLLSTAENDIGE ctest-Ausgabe
    virtual std::string liste_suite()        = 0; // `ctest -N` mit DERSELBEN Auswahl
    virtual std::string arbeitsbaum_status() = 0; // git status --porcelain, woertlich
    virtual std::string bezeichnung() const  = 0;
};

// Die echte Naht: cmake --build, ctest, git status -- alle drei ueber prozess.hpp,
// also per argv-Vektor und ohne Shell.
class EchteLaufNaht final : public LaufNaht {
public:
    EchteLaufNaht(std::filesystem::path repo, std::filesystem::path bauverzeichnis, std::string ctest_label,
                  int bau_jobs);

    bool        baue() override;
    std::string fahre_suite() override;
    std::string liste_suite() override;
    std::string arbeitsbaum_status() override;
    std::string bezeichnung() const override;

    // Fuer die Diagnose: die letzte Bau-Ausgabe, woertlich.
    const std::string& letzte_bau_ausgabe() const { return letzte_bau_ausgabe_; }

private:
    // Die Suite-Auswahl -- EINE Quelle fuer den Mess-Lauf und fuer die Auswahl-Liste.
    std::vector<std::string> auswahl_argumente() const;

    std::filesystem::path repo_;
    std::filesystem::path bau_;
    std::string           label_;
    int                   jobs_;
    std::string           letzte_bau_ausgabe_;
};

// ---- Warum ein ganzer Lauf abbrechen kann -------------------------------------------
enum class LaufAbbruchGrund {
    BaumSchmutzigVorher,       // ohne sauberen Baum ist "byte-gleich danach" nicht belegbar
    SuiteAuswahlUnlesbar,      // `ctest -N` hat keine Gesamtzeile geliefert
    SelbstbezugInDerSuite,     // die Katalog-Faelle stecken in der gemessenen Suite (s. Kopf)
    GrundlaufBauRot,           // schon ohne Mutation kaputt -- kein Mutant waere zurechenbar
    GrundlaufSuiteUnlesbar,    // ctest hat nicht geantwortet
    GrundlaufSuiteRot,         // K13 Gegenkoeder verletzt: der unmanipulierte Lauf ist NICHT gruen
    GrundlaufLeererNenner,     // 0 Tests -- ein leerer Nenner ist kein bestandener Lauf
    RuecknahmeNichtByteGleich, // der Harness hat den Baum veraendert: harter Stopp
    BaumSchmutzigNachher,      // git sagt: es liegt noch etwas herum
};

inline constexpr LaufAbbruchGrund alle_lauf_abbruch_gruende[] = {
    LaufAbbruchGrund::BaumSchmutzigVorher,    LaufAbbruchGrund::SuiteAuswahlUnlesbar,
    LaufAbbruchGrund::SelbstbezugInDerSuite,  LaufAbbruchGrund::GrundlaufBauRot,
    LaufAbbruchGrund::GrundlaufSuiteUnlesbar, LaufAbbruchGrund::GrundlaufSuiteRot,
    LaufAbbruchGrund::GrundlaufLeererNenner,  LaufAbbruchGrund::RuecknahmeNichtByteGleich,
    LaufAbbruchGrund::BaumSchmutzigNachher,
};
static_assert(sizeof(alle_lauf_abbruch_gruende) / sizeof(alle_lauf_abbruch_gruende[0]) == 9,
              "LaufAbbruchGrund hat einen neuen Wert -- Tabelle und Fall-Tabellen nachziehen.");

std::string          lauf_abbruch_text(LaufAbbruchGrund grund);
inline std::ostream& operator<<(std::ostream& strom, LaufAbbruchGrund g) { return strom << lauf_abbruch_text(g); }

// ---- Die Ergebnisse -----------------------------------------------------------------
struct MutantLaufErgebnis {
    std::string   id;
    std::string   datei;
    Testklasse    klasse  = Testklasse::KeineNegativprobe;
    MutantAusgang ausgang = MutantAusgang::HarnessAbbruch; // fail-closed als Vorgabe
    CtestBefund   befund;
    // Vorhergesagt rot, aber gruen geblieben. Nicht leer heisst: die benannte Deckung
    // greift an dieser Stelle nicht -- auch dann nicht, wenn ein ANDERER Test biss.
    std::vector<std::string> vorhergesagt_aber_gruen;
    bool                     byte_gleich_zurueckgenommen = false;
    std::string              diagnose;
};

struct MutationsLaufErgebnis {
    WacheStatus status            = WacheStatus::Abbruch; // fail-closed
    std::size_t katalog_gesamt    = 0;                    // DER NENNER
    std::size_t gefahren          = 0;
    std::size_t vom_bau_getoetet  = 0;
    std::size_t vom_test_getoetet = 0;
    std::size_t ueberlebend       = 0;
    std::size_t harness_abbruch   = 0;
    int         basis_tests       = 0; // Suite-Nenner aus dem Grundlauf
    // Was `ctest -N` mit DERSELBEN Auswahl aufzaehlt. Zweite, unabhaengige Quelle fuer
    // denselben Nenner (V-7): weicht sie vom Grundlauf ab, wurden Tests uebersprungen.
    int                             suite_auswahl = 0;
    std::optional<LaufAbbruchGrund> abbruch;
    std::string                     abbruch_detail;
    std::vector<MutantLaufErgebnis> je_mutant;

    // Der Nenner ist eine IDENTITAET, keine Schaetzung. Haelt sie nicht, hat der
    // Harness sich selbst verzaehlt und darf sein Ergebnis nicht als Messung ausgeben.
    bool nenner_haelt() const {
        return gefahren == vom_bau_getoetet + vom_test_getoetet + ueberlebend + harness_abbruch;
    }

    std::string protokoll() const;
};

// Der Lauf. Er schreibt in `repo` -- und nimmt jede Aenderung zurueck.
MutationsLaufErgebnis fahre_mutationslauf(const std::filesystem::path& repo, LaufNaht& naht,
                                          std::span<const Mutant> mutanten);

// Datei-Naht, hier oeffentlich, weil die Tests damit ihre Fixtures pruefen.
std::optional<std::string> lies_datei_ganz(const std::filesystem::path& datei);
bool                       schreibe_datei_ganz(const std::filesystem::path& datei, std::string_view inhalt);

} // namespace comdare::ci_wachen

#endif // COMDARE_CI_WACHEN_MUTATIONS_LAUF_HPP
