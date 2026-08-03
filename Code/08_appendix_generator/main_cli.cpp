// SPDX-License-Identifier: Apache-2.0
// CLI für appendix_generator — cross-platform In-Process-Ersatz für den
// Windows-only PowerShell-Behelfsweg thesis/diplomarbeit/generate_wide_appendix.ps1.
// Linkt comdare::csv_to_latex + comdare::diagram_generator (KEIN .exe-Spawn).

#include "appendix_generator.hpp"

#include <iostream>
#include <string>

namespace ag = comdare::da::appendix_generator;

namespace {

// "de,en" → {"de","en"} (leere Tokens verworfen).
std::vector<std::string> split_commas(std::string const& list) {
    std::vector<std::string> out;
    std::size_t              pos = 0;
    while (pos <= list.size()) {
        auto const        comma = list.find(',', pos);
        std::string const tok   = list.substr(pos, comma == std::string::npos ? std::string::npos : comma - pos);
        if (!tok.empty()) out.push_back(tok);
        if (comma == std::string::npos) break;
        pos = comma + 1;
    }
    return out;
}

} // namespace

int main(int argc, char* argv[]) {
    if (argc < 3) {
        std::cerr << "Usage: appendix-generator <wide.csv> <out_root> [--langs=de,en]\n"
                  << "                          [--bias-label=<label>]\n"
                  << "                          [--bias-caption-de=<text>] [--bias-caption-en=<text>]\n"
                  << "                          [--organ-registry=<xml>] [--system-registry=<xml>]\n"
                  << "                          [--measurement-registry=<xml>]\n"
                  << "  Schreibt je Sprache <out_root>/<lang>/tabellen/:\n"
                  << "    bias_matrix_table.tex, lc_surface_<z>.tex (6x),\n"
                  << "    ld_exchange_<achse>.tex (4x), le_limitierung.tex,\n"
                  << "    seg_attribution.tex, latency_range.tex, latency_ecdf.tex,\n"
                  << "    exchange_forest.tex (honest-empty ⇒ ggf. ausgelassen),\n"
                  << "    axis_inventory.tex (nur mit mindestens einer --*-registry;\n"
                  << "      Quelle sind die GENERIERTEN Achsen-Registries des Codes)\n"
                  << "  In-Process (linkt comdare::csv_to_latex + comdare::diagram_generator);\n"
                  << "  kein .exe-Spawn, cross-platform. Ersetzt generate_wide_appendix.ps1.\n";
        return 1;
    }

    ag::AppendixConfig cfg;
    cfg.csv      = argv[1];
    cfg.out_root = argv[2];
    for (int i = 3; i < argc; ++i) {
        std::string const a{argv[i]};
        if (a.rfind("--langs=", 0) == 0)
            cfg.langs = split_commas(a.substr(8));
        else if (a.rfind("--bias-label=", 0) == 0)
            cfg.bias_label = a.substr(13);
        else if (a.rfind("--bias-caption-de=", 0) == 0)
            cfg.bias_caption_by_lang["de"] = a.substr(18);
        else if (a.rfind("--bias-caption-en=", 0) == 0)
            cfg.bias_caption_by_lang["en"] = a.substr(18);
        else if (a.rfind("--organ-registry=", 0) == 0)
            cfg.organ_axis_registry = a.substr(17);
        else if (a.rfind("--system-registry=", 0) == 0)
            cfg.system_axis_registry = a.substr(18);
        else if (a.rfind("--measurement-registry=", 0) == 0)
            cfg.measurement_axis_registry = a.substr(23);
        else {
            std::cerr << "appendix-generator: unbekanntes Argument '" << a << "'\n";
            return 1;
        }
    }
    if (cfg.langs.empty()) {
        std::cerr << "appendix-generator: --langs ergab leere Sprachliste\n";
        return 1;
    }

    int const rc = ag::generate_wide_appendix(cfg);
    if (rc != ag::status_ok) {
        std::cerr << "appendix-generator: generate_wide_appendix failed " << rc << "\n";
        return rc;
    }
    std::cout << "appendix-generator: OK (" << cfg.langs.size() << " Sprache(n)) -> " << cfg.out_root << "\n";
    return 0;
}
