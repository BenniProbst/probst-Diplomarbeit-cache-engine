// mutations_lauf_main.cpp -- argv -> Bibliothek -> Exit-Mapping. Sonst nichts.
//
// EXIT-VERTRAG (derselbe wie bei den anderen Wachen, ergebnis.hpp):
//   0  alle Mutanten getoetet
//   1  RISS -- mindestens ein Mutant ueberlebt die Suite (ein BEFUND ueber die Suite)
//   2  ABBRUCH -- der Harness konnte nicht messen. Ausdruecklich KEIN Gruen.
//
// NICHT IN DER CI VERDRAHTET. Der Lauf veraendert Produktionsdateien und nimmt sie
// zurueck; ihn ungefragt in eine Pipeline zu haengen waere eine Entscheidung des
// Owners/Lead, nicht dieses Moduls. Er wird von Hand gefahren und protokolliert.
//
// ASCII-only, Zeilen <= 120 Byte.

#include <cstdlib>
#include <iostream>
#include <string>
#include <vector>

#include "comdare/ci_wachen/mutations_lauf.hpp"

namespace {

void hilfe() {
    std::cout << "Aufruf: ci-mutations-lauf --repo <pfad> --bau <pfad> [--label da_unit] [--jobs 6]\n"
              << "  --repo   Wurzel des Arbeitsbaums (muss sauber sein: git status --porcelain leer)\n"
              << "  --bau    konfiguriertes CMake-Bauverzeichnis\n"
              << "  --label  ctest-Label der Suite (Vorgabe: da_unit)\n"
              << "  --jobs   Bau-Parallelitaet (Vorgabe: 6 -- der Runner teilt sich den RAM)\n";
}

} // namespace

int main(int argc, char** argv) {
    using namespace comdare::ci_wachen;

    std::string repo;
    std::string bau;
    std::string label = "da_unit";
    int         jobs  = 6;

    const std::vector<std::string> argumente(argv + 1, argv + argc);
    for (std::size_t i = 0; i < argumente.size(); ++i) {
        const std::string& arg  = argumente[i];
        auto               wert = [&](const char* name) -> std::string {
            if (i + 1 >= argumente.size()) {
                std::cerr << "FEHLER: " << name << " ohne Wert\n";
                std::exit(2);
            }
            return argumente[++i];
        };
        if (arg == "--repo") {
            repo = wert("--repo");
        } else if (arg == "--bau") {
            bau = wert("--bau");
        } else if (arg == "--label") {
            label = wert("--label");
        } else if (arg == "--jobs") {
            jobs = std::atoi(wert("--jobs").c_str());
        } else if (arg == "-h" || arg == "--hilfe" || arg == "--help") {
            hilfe();
            return 0;
        } else {
            std::cerr << "FEHLER: unbekannte Option '" << arg << "'\n";
            hilfe();
            return 2;
        }
    }

    if (repo.empty() || bau.empty()) {
        std::cerr << "FEHLER: --repo und --bau sind Pflicht (fail-closed: ohne beide wird nichts gemessen)\n";
        hilfe();
        return 2;
    }
    if (jobs <= 0) {
        std::cerr << "FEHLER: --jobs muss > 0 sein\n";
        return 2;
    }

    EchteLaufNaht naht(repo, bau, label, jobs);
    std::cout << "Naht: " << naht.bezeichnung() << "\n\n";

    const MutationsLaufErgebnis ergebnis = fahre_mutationslauf(repo, naht, katalog());
    std::cout << ergebnis.protokoll();
    return exit_code_von(ergebnis.status);
}
