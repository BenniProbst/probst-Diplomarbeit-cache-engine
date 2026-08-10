// wide_aggregat_main.cpp -- der duenne Wrapper der WIDE-Konkatenation.
//
// SUBSTANZ LIEGT IN DER BIBLIOTHEK, main() ist NUR argv -> lib -> Exit-Mapping.
// Das ist die Bedingung, unter der dieses Binary keine Verletzung der Vier-Binary-
// Typen-Doktrin ist: es ist CI-Infrastruktur, kein Teil des Mess-Systems.
//
// DER CLI-VERTRAG IST BYTE-VERTRAEGLICH ZU ci/wide_aggregat.sh -- das ist Absicht und
// der ganze Sinn der Stufe 1: die drei Produktions-Aufrufstellen koennen spaeter
// `sh ci/wide_aggregat.sh` durch dieses Binary ersetzen, ohne ein Argument zu drehen.
//   ci-wide-aggregat <listendatei> <ziel-wide-csv> <kennzahlen-datei>
//   0 = aggregiert (auch leer -- das URTEIL faellt der Aufrufer)
//   2 = konnte nicht aggregieren -- KEIN Gruen
//
// ASCII-only, Zeilen <= 120 Byte.

#include <cstdio>
#include <fstream>
#include <string>
#include <vector>

#include "comdare/ci_wachen/ergebnis.hpp"
#include "comdare/ci_wachen/wide_aggregat.hpp"

int main(int argc, char** argv) {
    using comdare::ci_wachen::AggregatAbbruchGrund;
    using comdare::ci_wachen::exit_code_von;
    using comdare::ci_wachen::WacheStatus;

    const std::vector<std::string> argumente(argv + 1, argv + argc);
    for (const std::string& arg : argumente) {
        if (arg == "-h" || arg == "--hilfe" || arg == "--help") {
            std::fputs("Aufruf: ci-wide-aggregat <listendatei> <ziel-wide-csv> <kennzahlen-datei>\n"
                       "  Klebt die gelisteten CSV zu EINEM Aggregat (Kopfzeile genau einmal).\n"
                       "  Die Liste ist VOM AUFRUFER sortiert. 0 = aggregiert | 2 = Abbruch\n",
                       stdout);
            return 0;
        }
    }
    if (argumente.size() != 3) {
        std::fputs("AUFRUF: ci-wide-aggregat <listendatei> <ziel-wide-csv> <kennzahlen-datei>\n", stderr);
        return exit_code_von(WacheStatus::Abbruch);
    }

    const comdare::ci_wachen::WideErgebnis ergebnis = comdare::ci_wachen::aggregiere(argumente[0], argumente[1]);

    // Die Kennzahlen werden AUCH im Abbruch geschrieben, WENN es ueberhaupt Zahlen gibt:
    // bei WIDE_FEHLEND > 0 tragen sie den Nenner, der den Abbruch erklaert. Fehlt dagegen
    // die LISTE selbst, waeren alle Zahlen 0 -- und ein WIDE_QUELLEN=0 saehe aus wie ein
    // ehrlich leerer Lauf. Genau diese Verwechslung ist der Defekt, gegen den das Modul
    // gebaut ist, also wird dann NICHTS geschrieben. Das ist zugleich die Paritaet zu
    // ci/wide_aggregat.sh, die in demselben Fall vor dem Schreiben aussteigt.
    const bool zahlen_belastbar = !(ergebnis.abbruch == AggregatAbbruchGrund::ListeFehlt ||
                                    ergebnis.abbruch == AggregatAbbruchGrund::ZielNichtSchreibbar);
    if (zahlen_belastbar) {
        std::ofstream kz(argumente[2], std::ios::binary | std::ios::trunc);
        if (!kz) {
            std::fprintf(stderr, "ABBRUCH: Kennzahlen-Datei '%s' nicht schreibbar.\n", argumente[2].c_str());
            return exit_code_von(WacheStatus::Abbruch);
        }
        kz << ergebnis.kennzahlen();
    }

    const std::string protokoll = ergebnis.protokoll();
    if (ergebnis.status == WacheStatus::Gruen) {
        std::fputs(protokoll.c_str(), stdout);
    } else {
        std::fputs(protokoll.c_str(), stderr);
    }
    return exit_code_von(ergebnis.status);
}
