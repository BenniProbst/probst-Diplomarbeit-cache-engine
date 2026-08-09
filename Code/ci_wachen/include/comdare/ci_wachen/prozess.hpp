// prozess.hpp -- die PROZESS-NAHT der CI-Wachen.                          (2026-08-09)
//
// WARUM ES DIESE DATEI GIBT -- der Defekt, der alles ausloeste:
// Das Selbstbiss-Orakel der abgeloesten Shell-Probe (ci/tests/xml_wellformed_probe.sh,
// Zeilen 688-701) zaehlte JEDEN Rueckgabewert ausser 0 und 2 als "Biss":
//     if   rc = 0 -> ROT ("Mutant UEBERLEBT")
//     elif rc = 2 -> ROT ("Abbruch ist kein Biss")
//     else        -> N_MUT_GEBISSEN++   "Mutant wird gefangen (Probe rc=$_rc)"
// Am Objekt gemessen (09.08.): ein `tr`-Shim, der schlicht mit 127 endet, liess ALLE
// FUENF Mutanten als "gefangen (Probe rc=127)" durchgehen -- GESAMT rc=0, die Probe
// meldete "SELBSTBISS GRUEN", und KEIN EINZIGER MUTANT war angesehen worden.
// Ein Werkzeug-Ausfall war vom Biss nicht unterscheidbar, weil beide in denselben
// int-Eimer fielen.
//
// DIE ANTWORT IST NICHT "besser behandeln", SONDERN "unrepraesentierbar machen":
// Ein Prozess endet hier in GENAU EINER von drei Arten, und nur eine davon traegt
// ueberhaupt einen Exit-Code:
//     Exit                -- der Prozess lief und endete per exit(code)
//     Signal              -- der Prozess starb an einem Signal (kein Exit-Code)
//     ExecFehlgeschlagen  -- der Prozess LIEF NIE (Werkzeug fehlt, kein Recht, chdir kaputt)
// exit_code() gibt nur bei ProzessArt::Exit einen Wert. Ein fehlendes Werkzeug liefert
// std::nullopt und kann damit KEINEM Soll-Code jemals gleichen -- die Klasse "127 gilt
// als Biss" existiert nicht mehr, sie ist nicht mehr formulierbar.
//
// KEIN `sh -c`: alles wird per argv-Vektor gestartet (execvp). Es gibt keine Shell im
// Pfad, also auch keine Wort-Trennung, keine Ersetzung und kein "command not found"
// mit rc=127, das wie ein echter Exit aussaehe. Fehlt das Werkzeug, kommt ENOENT aus
// der Selbst-Pipe zurueck -- als ExecFehlgeschlagen, nicht als Exit.
//
// DIE SELBST-PIPE (die Technik dahinter): das Kind bekommt eine zusaetzliche Pipe mit
// FD_CLOEXEC. Gelingt execvp, schliesst der Kernel sie beim Bildwechsel und der Vater
// liest 0 Byte -> der Prozess lief. Scheitert execvp, schreibt das Kind Stufe+errno
// hinein -> der Vater weiss GENAU, woran es lag, ohne einen Exit-Code raten zu muessen.
//
// ASCII-only, Zeilen <= 120 Byte (scripts/ci_diff_ascii_width_guard.sh).

#ifndef COMDARE_CI_WACHEN_PROZESS_HPP
#define COMDARE_CI_WACHEN_PROZESS_HPP

#include <filesystem>
#include <optional>
#include <string>
#include <vector>

namespace comdare::ci_wachen {

// Die drei Arten sind DISJUNKT und erschoepfend. Wer eine vierte hinzufuegt, bricht
// zuerst an alle_prozess_arten() (static_assert unten), dann an den Fall-Tabellen.
enum class ProzessArt {
    Exit,                // lief, endete per exit(code)
    Signal,              // lief, starb an Signal(nummer)
    ExecFehlgeschlagen,  // lief NIE: execvp/chdir schlug fehl, code = errno
};

// Wo genau es scheiterte, wenn der Prozess nie lief. Ohne diese Unterscheidung waere
// "Werkzeug fehlt" nicht von "Arbeitsverzeichnis fehlt" zu trennen.
enum class ExecStufe {
    Keine,
    Arbeitsverzeichnis,  // chdir() im Kind schlug fehl
    Ausfuehrung,         // execvp() schlug fehl
};

struct ProzessAusgang {
    ProzessArt art = ProzessArt::ExecFehlgeschlagen;
    // Exit: der Exit-Code. Signal: die Signalnummer. ExecFehlgeschlagen: errno.
    // ABSICHTLICH NICHT "rc": es gibt keinen gemeinsamen Zahlenraum mehr.
    int code = -1;
    ExecStufe stufe = ExecStufe::Keine;
    std::string ausgabe;   // stdout, vollstaendig
    std::string fehler;    // stderr, vollstaendig
    std::string werkzeug;  // argv[0] -- damit die Diagnose das Werkzeug benennt

    // Menschenlesbare Form fuer Testausgaben und Protokolle. Traegt IMMER die Art,
    // nie nur die Zahl -- eine nackte Zahl war der Defekt.
    std::string beschreibung() const;
};

// DER RIEGEL: nur ein echter exit() liefert einen Code. Alles andere ist nullopt und
// kann deshalb keinem erwarteten Code gleichen. Jede Zusicherung ueber einen Exit-Code
// laeuft ueber diese Funktion, nie ueber ProzessAusgang::code direkt.
std::optional<int> exit_code(const ProzessAusgang& ausgang);

struct ProzessAuftrag {
    std::vector<std::string> argv;             // argv[0] ist das Werkzeug; NIE eine Shell
    std::filesystem::path arbeitsverzeichnis;  // leer = vom Vater geerbt
    // Diese Variablen werden im Kind ENTFERNT, bevor exec laeuft. Ohne das biegt ein
    // gesetztes GIT_DIR der CI die Wegwerf-Fixtures in ein fremdes Repo um (dieselbe
    // Haertung wie in der abgeloesten Shell-Probe, Zeile 142).
    std::vector<std::string> env_entfernen;
};

// Fuehrt den Auftrag aus und liest stdout und stderr VOLLSTAENDIG (poll-Schleife ueber
// beide Rohre, deshalb kein Deadlock bei viel Ausgabe auf einem der beiden).
ProzessAusgang fuehre_aus(const ProzessAuftrag& auftrag);

// Bequemform fuer git-Aufrufe: entfernt die git-Umgebungsvariablen, die Fixtures
// umbiegen koennten, und setzt das Arbeitsverzeichnis.
ProzessAusgang fuehre_git_aus(const std::filesystem::path& arbeitsverzeichnis,
                              const std::vector<std::string>& argumente);

// Vollstaendigkeits-Tabelle (T-4/Stufe 1): waechst das enum, reisst zuerst dieser
// static_assert, dann die Fall-Tabellen der Tests. Ein neuer Zweig kann sich nicht
// still an der Deckung vorbeischleichen.
inline constexpr ProzessArt alle_prozess_arten[] = {
    ProzessArt::Exit,
    ProzessArt::Signal,
    ProzessArt::ExecFehlgeschlagen,
};
static_assert(sizeof(alle_prozess_arten) / sizeof(alle_prozess_arten[0]) == 3,
              "ProzessArt hat einen neuen Wert -- alle_prozess_arten und die Fall-Tabellen nachziehen.");

}  // namespace comdare::ci_wachen

#endif  // COMDARE_CI_WACHEN_PROZESS_HPP
