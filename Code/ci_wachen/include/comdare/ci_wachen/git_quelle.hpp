// git_quelle.hpp -- die NAHT zu git.                                      (2026-08-09)
//
// ZWEI SACHEN SIND HIER ANDERS ALS IN DER ABGELOESTEN SHELL-WACHE, BEIDE AUS MESSUNG:
//
// (1) ES GIBT NUR NOCH EINE AUFZAEHLUNG, NUL-GETRENNT.
//     Die Shell-Wache zaehlte ZWEIMAL -- einmal zeilenweise (`git ls-files '*.xml'`)
//     und einmal NUL-getrennt (`... -z | tr -dc '\0' | wc -c`) -- und brach ab, wenn
//     die Zahlen auseinanderliefen. Der Zweig ist TOT, am Objekt gemessen (git 2.43.0):
//         git -c core.quotePath=off ls-files '*.xml'  ->  "a\nb.xml"   (EINE Zeile)
//         ... | tr -dc '\0' | wc -c                   ->  1
//     git C-quotet Steuerzeichen im NICHT-`-z`-Ausgabeweg IMMER; core.quotePath regelt
//     nur Bytes >= 0x80. Die beiden Zaehler KOENNEN nicht divergieren. Die abgeloeste
//     Probe musste den Zweig ehrlich als ungedeckt melden ("ein Mutant davon bliebe an
//     ALLEN Eingaengen gruen"). HIER faellt er ersatzlos weg: es wird ausschliesslich
//     `-z` gelesen, und ein Dateiname MIT Zeilenende ist damit ein funktionierender
//     POSITIV-Fall statt eines toten Abwehr-Zweiges. Aus der Luecke wird Deckung.
//
// (2) DIE FELDLAGE WIRD GETRENNT GEPARST -- UND DAS IST DIE FALLE, DIE ES WIRKLICH GIBT.
//     Die beiden Lesepfade der Paritaets-Wache haben UNTERSCHIEDLICHE Feldreihenfolgen:
//         git ls-tree HEAD -- <pfad>        <mode> SP <type> SP <object> TAB <path>
//         git ls-files --stage -- <pfad>    <mode> SP <object> SP <stage> TAB <path>
//     Das Objekt steht also einmal im DRITTEN und einmal im ZWEITEN Feld. Wer die
//     Reihenfolge verwechselt, liest bei --quelle index die STAGE-Nummer als SHA und
//     vergleicht zwei Nullen miteinander -- eine Wache, die immer gruen ist. Beide
//     Parser sind deshalb REINE FUNKTIONEN und werden mit missgestalteten Eingaben
//     geprueft, die es an echtem git gar nicht gibt.
//
// ASCII-only, Zeilen <= 120 Byte.

#ifndef COMDARE_CI_WACHEN_GIT_QUELLE_HPP
#define COMDARE_CI_WACHEN_GIT_QUELLE_HPP

#include <filesystem>
#include <ostream>
#include <string>
#include <string_view>
#include <vector>

namespace comdare::ci_wachen {

enum class GitlinkQuelle {
    Head,   // ls-tree HEAD  -- Praevention in verify:submodules
    Index,  // ls-files --stage -- Nachbedingung in anhang:forward
};

inline constexpr GitlinkQuelle alle_gitlink_quellen[] = {GitlinkQuelle::Head, GitlinkQuelle::Index};
static_assert(sizeof(alle_gitlink_quellen) / sizeof(alle_gitlink_quellen[0]) == 2,
              "GitlinkQuelle hat einen neuen Wert -- Tabelle und Fall-Tabellen nachziehen.");

std::string quelle_text(GitlinkQuelle quelle);

inline std::ostream& operator<<(std::ostream& strom, GitlinkQuelle quelle) {
    return strom << quelle_text(quelle);
}

// Antwort auf eine Bestands-Aufzaehlung. `werkzeug_ok == false` heisst: git hat nicht
// geantwortet. Das ist NIE eine leere Liste -- ein Werkzeug-Ausfall und "nichts
// gefunden" duerfen nicht denselben Wert haben (genau diese Verwechslung liess die
// Shell-Probe bei leerer od-Ausgabe 12/12 gruen melden).
struct DateiBestand {
    bool werkzeug_ok = false;
    std::string diagnose;
    std::vector<std::string> pfade;
};

// Antwort auf eine Gitlink-Abfrage. Auch hier: Werkzeug-Ausfall, "kein Eintrag" und
// "Eintrag mit falschem Modus" sind DREI unterscheidbare Zustaende.
struct GitlinkAntwort {
    bool werkzeug_ok = false;
    std::string diagnose;
    bool eintrag_vorhanden = false;
    std::string modus;   // z.B. "160000" (Gitlink) oder "100644" (gewoehnliche Datei)
    std::string objekt;  // der SHA -- nur belastbar, wenn modus == "160000"

    bool ist_gitlink() const { return eintrag_vorhanden && modus == "160000"; }
};

class GitQuelle {
public:
    virtual ~GitQuelle() = default;
    virtual bool ist_arbeitsbaum() const = 0;
    virtual DateiBestand ls_files_z(const std::string& muster) const = 0;
    virtual GitlinkAntwort gitlink(const std::string& pfad, GitlinkQuelle quelle) const = 0;
    // Absolut aufgeloester Pfad einer getrackten Datei -- damit der Parser nicht vom
    // Arbeitsverzeichnis des Aufrufers abhaengt.
    virtual std::filesystem::path aufloesen(const std::string& pfad) const = 0;
};

// Produktions-Implementierung ueber die Prozess-Naht (argv-exec, nie `sh -c`).
class EchteGitQuelle final : public GitQuelle {
public:
    explicit EchteGitQuelle(std::filesystem::path verzeichnis);
    bool ist_arbeitsbaum() const override;
    DateiBestand ls_files_z(const std::string& muster) const override;
    GitlinkAntwort gitlink(const std::string& pfad, GitlinkQuelle quelle) const override;
    std::filesystem::path aufloesen(const std::string& pfad) const override;

    // Die Wurzel, die git selbst nennt -- NICHT dirname($0)/... Die abgeloeste Wache
    // begruendet das am Objekt: faellt dirname aus, landet `cd "/.."` lautlos auf "/"
    // und die Wache liefe gegen den FALSCHEN Baum, ohne dass irgendetwas anschlaegt.
    const std::filesystem::path& wurzel() const { return wurzel_; }

private:
    std::filesystem::path start_;
    std::filesystem::path wurzel_;
    bool arbeitsbaum_ = false;
};

// ---- REINE PARSER (ohne git, ohne Prozess) ---------------------------------------
// Genau hier liegt die Feldlage-Falle aus (2). Beide Funktionen sind total: jede
// Eingabe liefert eine Antwort, keine wirft, keine liest ausserhalb ihrer Zeile.
GitlinkAntwort parse_ls_tree_zeile(std::string_view zeile);
GitlinkAntwort parse_ls_files_stage_zeile(std::string_view zeile);

// Zerlegt eine NUL-getrennte git-Ausgabe. Ein Dateiname mit '\n' bleibt EIN Eintrag --
// das ist der Positiv-Fall, der den toten Nenner-Mismatch-Zweig ersetzt.
std::vector<std::string> trenne_nul(std::string_view rohdaten);

}  // namespace comdare::ci_wachen

#endif  // COMDARE_CI_WACHEN_GIT_QUELLE_HPP
