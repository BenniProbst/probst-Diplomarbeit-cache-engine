// SPDX-License-Identifier: Apache-2.0
// CLI fuer tex_formatter — cross-platform C++23-Ersatz fuer thesis/diplomarbeit/tools/format_tex.py (#25).
// In-place-Formatierung (UTF-8, erzwungenes LF, Trailing-\n) — entspricht format_tex.py::main().
// "Kein Python in der Chain" (Direktive).

#include "tex_formatter.hpp"

#include <fstream>
#include <iostream>
#include <iterator>
#include <string>

namespace tf = comdare::da::tex_formatter;

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: tex-formatter <datei1.tex> [datei2.tex ...]\n"
                  << "  In-place-Formatierung (UTF-8, LF): 2-Space-Einrueckung geschachtelter\n"
                  << "  \\begin..\\end + Prosa-Hart-Umbruch auf Breite 100 Code-Points.\n"
                  << "  Cross-platform C++23-Ersatz fuer thesis/diplomarbeit/tools/format_tex.py (#25).\n";
        return 1;
    }

    int rc = 0;
    for (int i = 1; i < argc; ++i) {
        std::string const path{argv[i]};

        std::ifstream in(path, std::ios::binary);
        if (!in) {
            std::cerr << "tex-formatter: kann nicht lesen: " << path << "\n";
            rc = 1;
            continue;
        }
        std::string const src((std::istreambuf_iterator<char>(in)), std::istreambuf_iterator<char>());
        in.close();

        // format_text == Python format_text; das Trailing-\n setzt main() (nicht die Kernfunktion).
        std::string result = tf::format_text(src);
        if (result.empty() || result.back() != '\n') result += "\n";

        std::ofstream out(path, std::ios::binary | std::ios::trunc);
        if (!out) {
            std::cerr << "tex-formatter: kann nicht schreiben: " << path << "\n";
            rc = 1;
            continue;
        }
        out.write(result.data(), static_cast<std::streamsize>(result.size()));
        out.close();

        // Report >WIDTH-Zeilen — CODE-POINTS (nicht Bytes), wie die Python-Referenz.
        std::size_t over  = 0;
        std::size_t start = 0;
        while (true) {
            std::size_t const nl = result.find('\n', start);
            std::string const line =
                (nl == std::string::npos) ? result.substr(start) : result.substr(start, nl - start);
            if (tf::cp_len(line) > static_cast<std::size_t>(tf::kWidth)) ++over;
            if (nl == std::string::npos) break;
            start = nl + 1;
        }
        std::cout << "  format " << path << "  (>WIDTH Zeilen: " << over << ")\n";
    }
    return rc;
}
