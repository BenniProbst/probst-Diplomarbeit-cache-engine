// ci_yml_scanner.cpp -- Umsetzung (Begruendung im Kopf von ci_yml_scanner.hpp).
// ASCII-only, Zeilen <= 120 Byte.

#include "comdare/ci_wachen/ci_yml_scanner.hpp"

#include <fstream>

namespace comdare::ci_wachen {
namespace {

bool beginnt_in_spalte_null(std::string_view zeile) {
    return !zeile.empty() && zeile.front() != ' ' && zeile.front() != '\t';
}

std::size_t zaehle(std::string_view heuhaufen, std::string_view nadel) {
    if (nadel.empty()) return 0;
    std::size_t treffer = 0;
    std::size_t i       = heuhaufen.find(nadel);
    while (i != std::string_view::npos) {
        ++treffer;
        i = heuhaufen.find(nadel, i + nadel.size());
    }
    return treffer;
}

} // namespace

bool ist_kommentarzeile(std::string_view zeile) {
    std::size_t i = 0;
    while (i < zeile.size() && (zeile[i] == ' ' || zeile[i] == '\t')) ++i;
    return i < zeile.size() && zeile[i] == '#';
}

std::optional<std::vector<std::string>> lies_zeilen(const std::filesystem::path& datei) {
    std::ifstream strom(datei, std::ios::binary);
    if (!strom) return std::nullopt; // fail-closed: kein leerer Vektor als Ersatz
    std::vector<std::string> zeilen;
    std::string              zeile;
    while (std::getline(strom, zeile)) {
        if (!zeile.empty() && zeile.back() == '\r') zeile.pop_back();
        zeilen.push_back(zeile);
    }
    if (strom.bad()) return std::nullopt;
    return zeilen;
}

std::optional<JobBlock> finde_job_block(const std::vector<std::string>& zeilen, const std::string& jobname) {
    JobBlock block;
    block.name = jobname;
    bool drin  = false;
    for (std::size_t i = 0; i < zeilen.size(); ++i) {
        const std::string& zeile = zeilen[i];
        if (!drin) {
            // Exakter Zeilenvergleich, wie im abgeloesten awk ($0 == job). Eine
            // Kopfzeile mit angehaengtem Kommentar gilt bewusst NICHT als Treffer --
            // sonst wuerde ein Fund vorgetaeuscht, wo die Struktur eine andere ist.
            if (zeile == jobname) {
                drin              = true;
                block.erste_zeile = i + 1;
                block.zeilen.push_back(zeile);
            }
            continue;
        }
        // Spalte 0 beendet den Block -- Kommentarzeilen AUSDRUECKLICH eingeschlossen.
        if (beginnt_in_spalte_null(zeile)) break;
        block.zeilen.push_back(zeile);
    }
    if (!drin) return std::nullopt;
    return block;
}

std::size_t zaehle_wirksam(const std::vector<std::string>& zeilen, std::string_view literal) {
    std::size_t treffer = 0;
    for (const std::string& zeile : zeilen) {
        if (ist_kommentarzeile(zeile)) continue; // Text ist keine Ausfuehrung
        treffer += zaehle(zeile, literal);
    }
    return treffer;
}

std::size_t zaehle_roh(const std::vector<std::string>& zeilen, std::string_view literal) {
    std::size_t treffer = 0;
    for (const std::string& zeile : zeilen) treffer += zaehle(zeile, literal);
    return treffer;
}

} // namespace comdare::ci_wachen
