// gitlink_parity_main.cpp -- der duenne Wrapper der Thesis-Gitlink-Paritaets-Wache.
//
// SUBSTANZ LIEGT IN DER BIBLIOTHEK, main() ist NUR argv -> lib -> Exit-Mapping.
// Ersetzt ci/thesis_gitlink_parity.sh, aufgerufen in .gitlab-ci.yml an zwei Stellen:
//   verify:submodules   --quelle head
//   anhang:forward      --quelle index --erwartet <sha>
// Der Exit-Vertrag ist unveraendert:
//   0 beide gleich (und, mit --erwartet, gleich dem SHA)
//   1 Divergenz ODER fehlender Gitlink-Pfad  (= der rote Biss)
//   2 Aufruf-/Werkzeugfehler (kein Repo, unbekannte Option)
//
// ASCII-only, Zeilen <= 120 Byte.

#include <cstdio>
#include <filesystem>
#include <string>
#include <vector>

#include "comdare/ci_wachen/ergebnis.hpp"
#include "comdare/ci_wachen/git_quelle.hpp"
#include "comdare/ci_wachen/gitlink_parity.hpp"

int main(int argc, char** argv) {
    const std::vector<std::string>            argumente(argv + 1, argv + argc);
    const comdare::ci_wachen::ParityArgumente parse = comdare::ci_wachen::parse_parity_argumente(argumente);

    if (!parse.ok) {
        std::fprintf(stderr, "%s\n", parse.fehler.c_str());
        std::fputs(comdare::ci_wachen::hilfe_text().c_str(), stderr);
        return comdare::ci_wachen::exit_code_von(comdare::ci_wachen::WacheStatus::Abbruch);
    }
    if (parse.hilfe_gewuenscht) {
        std::fputs(comdare::ci_wachen::hilfe_text().c_str(), stdout);
        return 0;
    }

    const comdare::ci_wachen::EchteGitQuelle git{std::filesystem::current_path()};
    const comdare::ci_wachen::ParityErgebnis ergebnis =
        comdare::ci_wachen::pruefe_gitlink_paritaet(git, parse.quelle, parse.erwartet);

    const std::string protokoll = ergebnis.protokoll();
    if (ergebnis.status == comdare::ci_wachen::WacheStatus::Gruen) {
        std::fputs(protokoll.c_str(), stdout);
    } else {
        std::fputs(protokoll.c_str(), stderr);
    }
    return comdare::ci_wachen::exit_code_von(ergebnis.status);
}
