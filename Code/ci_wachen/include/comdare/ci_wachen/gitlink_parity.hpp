// gitlink_parity.hpp -- die THESIS-GITLINK-PARITAETS-WACHE als Bibliothek. (2026-08-09)
//
// ABGELOEST, NICHT GELOESCHT: ci/thesis_gitlink_parity.sh (06.08., 145 Zeilen).
//
// DER BEFUND, GEGEN DEN GEBAUT WIRD (super 7780c6af, selbst nachgemessen):
// .gitmodules bindet ../20260931-overleaf-diplomarbeit.git ZWEIMAL ein --
//     thesis/diplomarbeit                          (LEBEND, 10 Vorkommen in der CI)
//     Code/external/20260931-overleaf-diplomarbeit (TOT,    0 Vorkommen in der CI)
// Der Rueckschrieb-Job anhang:forward bumpte bis zu jenem Paket nur den ERSTEN Zeiger.
// Folge: sobald der Kanal scharf ist, ERZEUGT die CI die Divergenz bei jedem
// Rueckschrieb selbst und still -- gefangen haette sie erst die nachgelagerte
// git-submodule-status-Wache, also NACHDEM sie entstanden ist.
//
// ZWEI AUFRUFSTELLEN, EINE BEHAUPTUNG:
//   verify:submodules  Praevention   (--quelle head)
//   anhang:forward     Nachbedingung (--quelle index --erwartet <sha>)
// An der zweiten Stelle ist diese Wache das EINZIGE, was beweist, dass der Rueckschrieb
// wirklich BEIDE Zeiger gesetzt hat.
//
// DIE KOLLISION, DIE DIE SHELL-FASSUNG 28 KOPFZEILEN MESSPROTOKOLL KOSTETE:
// "ein Gitlink fehlt" und "die Zeiger divergieren" lieferten BEIDE rc=1. Ein Mutant
// ohne den fail-closed-Zweig fiel deshalb eine Handvoll Zeilen spaeter im Divergenz-
// Zweig -- gemessen:
//     Eingang "nur der lebende Pfad":  ORIG 1 -> MUTANT 1   (kein Unterschied)
//     Eingang "BEIDE fehlen":          ORIG 1 -> MUTANT 0   (Unterschied)
// Nur wenn BEIDE fehlen, sind beide Zeiger gleich (beide leer), der Divergenz-Zweig
// greift nicht mehr, und der Mutant meldet "Paritaet OK ... beide Zeiger auf " mit
// LEEREM SHA und rc=0. Genau EIN Fall konnte ihn toeten.
// HIER IST DAS VORBEI: GitlinkFehlt und Divergenz sind zwei Werte. Ein Fall mit EINEM
// fehlenden Gitlink toetet den Mutanten jetzt ebenfalls, weil der Wert falsch ist --
// nicht erst, wenn zufaellig auch der Exit-Code abweicht.
//
// NICHT-ZIEL (unveraendert): diese Wache ENTFERNT die Doppelung nicht. Ob die tote
// Einbindung entfallen darf, ist Owner-Entscheid (Loeschung = GO). Bis dahin wird sie
// gleichgehalten, nicht geloescht.
//
// ASCII-only, Zeilen <= 120 Byte.

#ifndef COMDARE_CI_WACHEN_GITLINK_PARITY_HPP
#define COMDARE_CI_WACHEN_GITLINK_PARITY_HPP

#include <optional>
#include <string>
#include <vector>

#include "comdare/ci_wachen/ergebnis.hpp"
#include "comdare/ci_wachen/git_quelle.hpp"

namespace comdare::ci_wachen {

// Die beiden bewachten Pfade. Sie stehen hier EINMAL -- die abgeloeste Probe schrieb
// sie absichtlich ein zweites Mal ab, damit eine einseitige Umbenennung bricht. Diese
// Rolle uebernimmt jetzt der Test, der sie gegen .gitmodules haelt (eine ANDERE Quelle
// als der Pruefling, T-3) statt gegen eine Abschrift derselben Behauptung.
inline constexpr const char* PFAD_LEBEND = "thesis/diplomarbeit";
inline constexpr const char* PFAD_TOT    = "Code/external/20260931-overleaf-diplomarbeit";

enum class ParityRissArt {
    GitlinkFehlt,     // mindestens ein Pfad ist kein Gitlink (fehlt oder falscher Modus)
    Divergenz,        // beide vorhanden, aber sie zeigen auf verschiedene Commits
    ErwartetVerfehlt, // beide gleich, aber nicht auf dem geforderten SHA
};

inline constexpr ParityRissArt alle_parity_riss_arten[] = {
    ParityRissArt::GitlinkFehlt,
    ParityRissArt::Divergenz,
    ParityRissArt::ErwartetVerfehlt,
};
static_assert(sizeof(alle_parity_riss_arten) / sizeof(alle_parity_riss_arten[0]) == 3,
              "ParityRissArt hat einen neuen Wert -- Tabelle und Fall-Tabellen nachziehen.");

enum class ParityAbbruchGrund {
    KeinRepo,          // ausserhalb eines git-Baums aufgerufen
    GitFehlgeschlagen, // git hat geantwortet, aber mit Fehler
    Bedienfehler,      // argv unbrauchbar (unbekannte Option, fehlender Wert, Unsinns-Quelle)
};

inline constexpr ParityAbbruchGrund alle_parity_abbruch_gruende[] = {
    ParityAbbruchGrund::KeinRepo,
    ParityAbbruchGrund::GitFehlgeschlagen,
    ParityAbbruchGrund::Bedienfehler,
};
static_assert(sizeof(alle_parity_abbruch_gruende) / sizeof(alle_parity_abbruch_gruende[0]) == 3,
              "ParityAbbruchGrund hat einen neuen Wert -- Tabelle und Fall-Tabellen nachziehen.");

struct ParityErgebnis {
    WacheStatus   status = WacheStatus::Abbruch; // fail-closed als Vorgabe
    GitlinkQuelle quelle = GitlinkQuelle::Head;
    int           nenner = 0; // wie viele Gitlink-Pfade die Wache ueberhaupt ansah

    std::optional<ParityRissArt> riss;
    std::vector<std::string>     fehlende_pfade; // nur bei GitlinkFehlt
    std::string                  sha_lebend;
    std::string                  sha_tot;
    std::string                  erwartet;

    std::optional<ParityAbbruchGrund> abbruch;
    std::string                       abbruch_detail;

    std::string protokoll() const;
};

// Die Wache. `erwartet` leer = die --erwartet-Forderung entfaellt.
ParityErgebnis pruefe_gitlink_paritaet(const GitQuelle& git, GitlinkQuelle quelle, const std::string& erwartet);

// ---- argv-Parser als REINE FUNKTION ----------------------------------------------
// In der Shell war die Optionsschleife untrennbar mit dem Prozess verwoben; ein
// Bedienfehler war nur ueber einen Kindprozess und rc=2 beobachtbar. Hier ist er ein
// Wert und wird ohne jeden Prozess geprueft.
struct ParityArgumente {
    bool          ok               = false;
    bool          hilfe_gewuenscht = false;
    GitlinkQuelle quelle           = GitlinkQuelle::Head; // Vorgabe wie in der Shell-Fassung
    std::string   erwartet;
    std::string   fehler; // Literal, das die Wache ausgibt
};

// argumente OHNE argv[0].
ParityArgumente parse_parity_argumente(const std::vector<std::string>& argumente);

std::string hilfe_text();
std::string riss_text(ParityRissArt art);
std::string abbruch_text(ParityAbbruchGrund grund);

inline std::ostream& operator<<(std::ostream& strom, ParityRissArt art) { return strom << riss_text(art); }
inline std::ostream& operator<<(std::ostream& strom, ParityAbbruchGrund grund) { return strom << abbruch_text(grund); }

} // namespace comdare::ci_wachen

#endif // COMDARE_CI_WACHEN_GITLINK_PARITY_HPP
