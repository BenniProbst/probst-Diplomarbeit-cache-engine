// xml_wellformed_main.cpp -- der duenne Wrapper der XML-Wohlgeformtheits-Wache.
//
// SUBSTANZ LIEGT IN DER BIBLIOTHEK, main() ist NUR argv -> lib -> Exit-Mapping.
// Das ist die Bedingung, unter der dieses Binary keine Verletzung der Vier-Binary-
// Typen-Doktrin ist: es ist CI-Infrastruktur wie die 98 ce-Testziele, kein Teil des
// Mess-Systems (Planer/CEB/Tier/Hybrid) und traegt keinerlei Mess-Funktionalitaet.
//
// Ersetzt scripts/ci_xml_wellformed_guard.sh, aufgerufen in .gitlab-ci.yml,
// Job lint:xml-wellformed. Der Exit-Vertrag ist unveraendert:
//   0 alles wohlgeformt | 1 mindestens eine kaputt | 2 Abbruch (keine Aussage moeglich)
//
// ASCII-only, Zeilen <= 120 Byte.

#include <cstdio>
#include <filesystem>
#include <string>
#include <vector>

#include "comdare/ci_wachen/ergebnis.hpp"
#include "comdare/ci_wachen/git_quelle.hpp"
#include "comdare/ci_wachen/xml_parser.hpp"
#include "comdare/ci_wachen/xml_wellformed.hpp"

int main(int argc, char** argv) {
    const std::vector<std::string> argumente(argv + 1, argv + argc);
    for (const std::string& arg : argumente) {
        if (arg == "-h" || arg == "--hilfe" || arg == "--help") {
            std::fputs("Aufruf: ci_xml_wellformed_wache            (aus der Repo-Wurzel)\n"
                       "  Prueft JEDE getrackte *.xml des Repos auf Wohlgeformtheit.\n"
                       "  0 = alle wohlgeformt | 1 = mindestens eine kaputt | 2 = Abbruch\n",
                       stdout);
            return 0;
        }
        std::fprintf(stderr, "FEHLER: unbekannte Option '%s'\n", arg.c_str());
        return comdare::ci_wachen::exit_code_von(comdare::ci_wachen::WacheStatus::Abbruch);
    }

    const comdare::ci_wachen::EchteGitQuelle git{std::filesystem::current_path()};
    const comdare::ci_wachen::XmllintParser parser;
    const comdare::ci_wachen::XmlWacheErgebnis ergebnis =
        comdare::ci_wachen::pruefe_xml_bestand(git, parser);

    const std::string protokoll = ergebnis.protokoll();
    if (ergebnis.status == comdare::ci_wachen::WacheStatus::Gruen) {
        std::fputs(protokoll.c_str(), stdout);
    } else {
        std::fputs(protokoll.c_str(), stderr);
    }
    return comdare::ci_wachen::exit_code_von(ergebnis.status);
}
