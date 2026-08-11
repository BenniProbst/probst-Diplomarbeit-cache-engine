// ci_invarianten.cpp -- Umsetzung der zwei Abschalt-Klassen.              (2026-08-10)
// Begruendung, Reichweite und Testkritik stehen vollstaendig im Kopf von
// ci_invarianten.hpp. Hier steht nur, WIE gelesen wird.
//
// ASCII-only, Zeilen <= 120 Byte.

#include "comdare/ci_wachen/ci_invarianten.hpp"

#include <algorithm>
#include <cctype>
#include <optional>
#include <string_view>
#include <unordered_map>

#include "comdare/ci_wachen/ci_yml_scanner.hpp"

namespace comdare::ci_wachen {
namespace {

constexpr std::string_view kPraefix = "COMDARE_";

bool ist_leerraum(char c) { return c == ' ' || c == '\t' || c == '\r' || c == '\n'; }

std::string rechts_getrimmt(const std::string& s) {
    std::size_t ende = s.size();
    while (ende > 0 && ist_leerraum(s[ende - 1])) { --ende; }
    return s.substr(0, ende);
}

std::string links_getrimmt(const std::string& s) {
    std::size_t start = 0;
    while (start < s.size() && ist_leerraum(s[start])) { ++start; }
    return s.substr(start);
}

bool ist_namenszeichen(char c) {
    const auto u = static_cast<unsigned char>(c);
    return (std::isalnum(u) != 0) || c == '_';
}

// DIE ECHTE YAML-REGEL: ein ':' trennt nur dann Schluessel und Wert, wenn ihm Leerraum
// oder das Zeilenende folgt. Alles davor ist der Name -- deshalb bleibt "test:unit:debug"
// EIN Name und zerfaellt nicht in drei.
std::optional<std::string> schluessel_von_zeile(const std::string& roh, bool eingerueckt_erlaubt) {
    const std::string zeile = rechts_getrimmt(roh);
    if (zeile.empty()) { return std::nullopt; }
    const bool eingerueckt = ist_leerraum(zeile[0]);
    if (eingerueckt != eingerueckt_erlaubt) { return std::nullopt; }
    const std::string kern = links_getrimmt(zeile);
    if (kern.empty() || kern[0] == '#' || kern[0] == '-') { return std::nullopt; }
    const char anfang = kern[0];
    if (!ist_namenszeichen(anfang) && anfang != '.') { return std::nullopt; }
    for (std::size_t i = 0; i < kern.size(); ++i) {
        if (kern[i] != ':') { continue; }
        const bool endet = (i + 1 == kern.size());
        if (endet || ist_leerraum(kern[i + 1])) {
            if (i == 0) { return std::nullopt; }
            return kern.substr(0, i);
        }
    }
    return std::nullopt;
}

bool ist_regelbedingung(const std::string& zeile) {
    const std::string kern = links_getrimmt(zeile);
    if (kern.rfind("- if:", 0) == 0) { return true; }
    return kern.rfind("if:", 0) == 0;
}

// Sammelt $NAME und ${NAME}. Beide Formen kommen in GitLab-Regeln vor.
void sammle_dollar_namen(const std::string& zeile, std::vector<std::string>& hinein) {
    for (std::size_t i = 0; i + 1 < zeile.size(); ++i) {
        if (zeile[i] != '$') { continue; }
        std::size_t start   = i + 1;
        bool        klammer = false;
        if (zeile[start] == '{') {
            klammer = true;
            ++start;
        }
        std::size_t ende = start;
        while (ende < zeile.size() && ist_namenszeichen(zeile[ende])) { ++ende; }
        if (ende == start) { continue; }
        if (klammer && (ende >= zeile.size() || zeile[ende] != '}')) { continue; }
        hinein.push_back(zeile.substr(start, ende - start));
        i = ende;
    }
}

// DIE DURCHREICHUNG IST KEINE SETZUNG.  (CI-INV Nachtrag, 11.08.2026)
// `COMDARE_X: "$COMDARE_X"` deklariert X NICHT -- die Zeile reicht den Wert der Eltern-
// Pipeline an eine Child weiter (GitLab `forward: yaml_variables`). Steht X sonst
// nirgends, ist der weitergereichte Wert leer, und das Gate ist exakt so tot wie ohne
// die Zeile. Wer sie als Deckung zaehlt, macht die Wache an IHRER EIGENEN KLASSE blind:
// die Variable sieht gesetzt aus und ist es nie. Am Objekt gefunden (super:2575,
// COMDARE_MEASURE_PROFILE) -- die Variable gatet drei echte Regeln und meldete gruen.
// Die Regel gilt fuer JEDE Selbst-Referenz im Wert, nicht nur fuer die nackte Form:
// auch "praefix-$COMDARE_X" haengt am Aussenwert und definiert X nicht.
bool wert_reicht_sich_selbst_durch(const std::string& roh, const std::string& name) {
    const std::string kern      = links_getrimmt(rechts_getrimmt(roh));
    const std::size_t nach_name = name.size() + 1; // Name + ':'
    if (nach_name >= kern.size()) {
        return false; // kein Wert -- ein Block-Kopf wie `variables:`, keine Durchreichung
    }
    std::vector<std::string> referenziert;
    sammle_dollar_namen(kern.substr(nach_name), referenziert);
    return std::find(referenziert.begin(), referenziert.end(), name) != referenziert.end();
}

} // namespace

std::vector<TopLevelSchluessel> sammle_top_level_schluessel(const std::vector<std::string>& zeilen) {
    std::vector<TopLevelSchluessel> ergebnis;
    for (std::size_t i = 0; i < zeilen.size(); ++i) {
        if (auto name = schluessel_von_zeile(zeilen[i], /*eingerueckt_erlaubt=*/false)) {
            ergebnis.push_back(TopLevelSchluessel{*name, i + 1});
        }
    }
    return ergebnis;
}

std::vector<Dublette> finde_dubletten(const std::vector<TopLevelSchluessel>& schluessel) {
    // Reihenfolge-stabil: Meldungen sollen zwischen zwei Laeufen gleich aussehen.
    std::vector<std::string>                                  ordnung;
    std::unordered_map<std::string, std::vector<std::size_t>> nach_name;
    for (const auto& s : schluessel) {
        auto& zeilen = nach_name[s.name];
        if (zeilen.empty()) { ordnung.push_back(s.name); }
        zeilen.push_back(s.zeile);
    }
    std::vector<Dublette> ergebnis;
    for (const auto& name : ordnung) {
        const auto& zeilen = nach_name[name];
        if (zeilen.size() >= 2) { ergebnis.push_back(Dublette{name, zeilen}); }
    }
    return ergebnis;
}

std::vector<TopLevelSchluessel> nur_templates(const std::vector<TopLevelSchluessel>& schluessel) {
    std::vector<TopLevelSchluessel> ergebnis;
    for (const auto& s : schluessel) {
        if (!s.name.empty() && s.name[0] == '.') { ergebnis.push_back(s); }
    }
    return ergebnis;
}

std::vector<VariablenFund> sammle_regel_referenzen(const std::vector<std::string>& zeilen) {
    std::vector<VariablenFund> ergebnis;
    for (std::size_t i = 0; i < zeilen.size(); ++i) {
        if (ist_kommentarzeile(zeilen[i]) || !ist_regelbedingung(zeilen[i])) { continue; }
        std::vector<std::string> namen;
        sammle_dollar_namen(zeilen[i], namen);
        for (const auto& n : namen) {
            if (n.rfind(kPraefix, 0) == 0) { ergebnis.push_back(VariablenFund{n, i + 1}); }
        }
    }
    return ergebnis;
}

std::set<std::string> sammle_gesetzte_variablen(const std::vector<std::string>& zeilen) {
    std::set<std::string> ergebnis;
    for (const auto& zeile : zeilen) {
        if (ist_kommentarzeile(zeile)) { continue; }
        if (auto name = schluessel_von_zeile(zeile, /*eingerueckt_erlaubt=*/true)) {
            if (name->rfind(kPraefix, 0) != 0) { continue; }
            if (wert_reicht_sich_selbst_durch(zeile, *name)) {
                continue; // Weiterreichung an eine Child, keine Definition -- s. oben
            }
            ergebnis.insert(*name);
        }
    }
    return ergebnis;
}

std::map<std::string, std::string> sammle_extern_annotationen(const std::vector<std::string>& zeilen) {
    constexpr std::string_view         kMarke = "extern:";
    std::map<std::string, std::string> ergebnis;
    for (const auto& zeile : zeilen) {
        if (!ist_kommentarzeile(zeile)) { continue; }
        const std::size_t pos = zeile.find(kMarke);
        if (pos == std::string::npos) { continue; }
        std::size_t i = pos + kMarke.size();
        while (i < zeile.size() && ist_leerraum(zeile[i])) { ++i; }
        const std::size_t namensanfang = i;
        while (i < zeile.size() && ist_namenszeichen(zeile[i])) { ++i; }
        const std::string name = zeile.substr(namensanfang, i - namensanfang);
        if (name.rfind(kPraefix, 0) != 0) { continue; }
        while (i < zeile.size() && ist_leerraum(zeile[i])) { ++i; }
        // Die Begruendung ist PFLICHT. Ohne sie bleibt die Variable ungedeckt -- eine
        // Annotation ohne Grund waere nur eine hoeflichere Form des Verschweigens.
        if (zeile.compare(i, 2, "--") != 0) { continue; }
        const std::string grund = links_getrimmt(rechts_getrimmt(zeile.substr(i + 2)));
        if (grund.empty()) { continue; }
        ergebnis.emplace(name, grund);
    }
    return ergebnis;
}

std::vector<VariablenFund> ungedeckte_regel_variablen(const std::vector<std::string>& zeilen) {
    const auto                 referenzen = sammle_regel_referenzen(zeilen);
    const auto                 gesetzt    = sammle_gesetzte_variablen(zeilen);
    const auto                 annotiert  = sammle_extern_annotationen(zeilen);
    std::vector<VariablenFund> ergebnis;
    std::set<std::string>      schon_gemeldet;
    for (const auto& r : referenzen) {
        if (gesetzt.count(r.name) != 0 || annotiert.count(r.name) != 0) { continue; }
        if (!schon_gemeldet.insert(r.name).second) {
            continue; // je Name EIN Befund, an seiner ersten Fundstelle
        }
        ergebnis.push_back(r);
    }
    return ergebnis;
}

} // namespace comdare::ci_wachen
