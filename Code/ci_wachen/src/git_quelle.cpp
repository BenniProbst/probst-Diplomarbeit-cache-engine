// git_quelle.cpp -- Umsetzung der git-Naht (Begruendung im Kopf von git_quelle.hpp).
// ASCII-only, Zeilen <= 120 Byte.

#include "comdare/ci_wachen/git_quelle.hpp"

#include "comdare/ci_wachen/prozess.hpp"

namespace comdare::ci_wachen {
namespace {

// Felder einer git-Zeile bis zum TAB. git trennt Metadaten mit SPACE und haengt den
// Pfad nach einem TAB an -- deshalb wird der Pfad NIE als Feld mitgezaehlt und ein
// Pfad mit Leerzeichen kann die Feldlage nicht verschieben.
std::vector<std::string> felder_vor_tab(std::string_view zeile) {
    const std::size_t tab = zeile.find('\t');
    const std::string_view kopf = (tab == std::string_view::npos) ? zeile : zeile.substr(0, tab);
    std::vector<std::string> felder;
    std::size_t i = 0;
    while (i < kopf.size()) {
        while (i < kopf.size() && kopf[i] == ' ') ++i;
        const std::size_t start = i;
        while (i < kopf.size() && kopf[i] != ' ') ++i;
        if (i > start) felder.emplace_back(kopf.substr(start, i - start));
    }
    return felder;
}

std::string erste_zeile(const std::string& text) {
    const std::size_t nl = text.find('\n');
    std::string zeile = (nl == std::string::npos) ? text : text.substr(0, nl);
    while (!zeile.empty() && (zeile.back() == '\r' || zeile.back() == ' ')) zeile.pop_back();
    return zeile;
}

GitlinkAntwort werkzeug_ausfall(const ProzessAusgang& ausgang) {
    GitlinkAntwort antwort;
    antwort.werkzeug_ok = false;
    antwort.diagnose = ausgang.beschreibung();
    if (!ausgang.fehler.empty()) antwort.diagnose += " | stderr: " + erste_zeile(ausgang.fehler);
    return antwort;
}

}  // namespace

std::string quelle_text(GitlinkQuelle quelle) {
    return quelle == GitlinkQuelle::Head ? "head" : "index";
}

std::vector<std::string> trenne_nul(std::string_view rohdaten) {
    std::vector<std::string> teile;
    std::size_t start = 0;
    for (std::size_t i = 0; i < rohdaten.size(); ++i) {
        if (rohdaten[i] == '\0') {
            if (i > start) teile.emplace_back(rohdaten.substr(start, i - start));
            start = i + 1;
        }
    }
    // Ein Rest ohne abschliessendes NUL zaehlt mit: git haengt es zwar immer an, aber
    // eine Naht, die still einen Eintrag verliert, waere genau die Klasse "zu kleiner
    // Nenner", gegen die die Wache gebaut ist.
    if (start < rohdaten.size()) teile.emplace_back(rohdaten.substr(start));
    return teile;
}

// ls-tree: <mode> SP <type> SP <object> TAB <path>   -- das Objekt ist das DRITTE Feld.
GitlinkAntwort parse_ls_tree_zeile(std::string_view zeile) {
    GitlinkAntwort antwort;
    antwort.werkzeug_ok = true;
    const std::vector<std::string> felder = felder_vor_tab(zeile);
    if (felder.size() < 3) return antwort;  // kein Eintrag -- kein Raten
    if (felder[1] != "commit" && felder[0] == "160000") {
        // Modus sagt Gitlink, Typ sagt etwas anderes: das ist keine Zeile, der man den
        // SHA glauben darf. Als "kein Eintrag" behandeln, nie als stiller Erfolg.
        return antwort;
    }
    antwort.eintrag_vorhanden = true;
    antwort.modus = felder[0];
    antwort.objekt = felder[2];
    return antwort;
}

// ls-files --stage: <mode> SP <object> SP <stage> TAB <path>  -- Objekt ist das ZWEITE.
GitlinkAntwort parse_ls_files_stage_zeile(std::string_view zeile) {
    GitlinkAntwort antwort;
    antwort.werkzeug_ok = true;
    const std::vector<std::string> felder = felder_vor_tab(zeile);
    if (felder.size() < 3) return antwort;
    antwort.eintrag_vorhanden = true;
    antwort.modus = felder[0];
    antwort.objekt = felder[1];
    return antwort;
}

EchteGitQuelle::EchteGitQuelle(std::filesystem::path verzeichnis) : start_(std::move(verzeichnis)) {
    const ProzessAusgang ausgang = fuehre_git_aus(start_, {"rev-parse", "--show-toplevel"});
    const std::optional<int> code = exit_code(ausgang);
    if (code.has_value() && *code == 0) {
        const std::string pfad = erste_zeile(ausgang.ausgabe);
        if (!pfad.empty()) {
            wurzel_ = std::filesystem::path(pfad);
            arbeitsbaum_ = true;
        }
    }
}

bool EchteGitQuelle::ist_arbeitsbaum() const { return arbeitsbaum_; }

std::filesystem::path EchteGitQuelle::aufloesen(const std::string& pfad) const {
    return wurzel_.empty() ? std::filesystem::path(pfad) : wurzel_ / pfad;
}

DateiBestand EchteGitQuelle::ls_files_z(const std::string& muster) const {
    DateiBestand bestand;
    if (!arbeitsbaum_) {
        bestand.diagnose = "kein git-Arbeitsbaum unter '" + start_.string() + "'";
        return bestand;
    }
    // Genau EINE Aufzaehlung, NUL-getrennt. core.quotePath=off bleibt gesetzt, damit
    // Bytes >= 0x80 unveraendert durchkommen; das Quoting von Steuerzeichen ist im
    // -z-Weg ohnehin abgeschaltet.
    const ProzessAusgang ausgang =
        fuehre_git_aus(wurzel_, {"-c", "core.quotePath=off", "ls-files", "-z", "--", muster});
    const std::optional<int> code = exit_code(ausgang);
    if (!code.has_value() || *code != 0) {
        bestand.diagnose = ausgang.beschreibung();
        if (!ausgang.fehler.empty()) bestand.diagnose += " | stderr: " + erste_zeile(ausgang.fehler);
        return bestand;
    }
    bestand.werkzeug_ok = true;
    bestand.pfade = trenne_nul(ausgang.ausgabe);
    return bestand;
}

GitlinkAntwort EchteGitQuelle::gitlink(const std::string& pfad, GitlinkQuelle quelle) const {
    if (!arbeitsbaum_) {
        GitlinkAntwort antwort;
        antwort.diagnose = "kein git-Repository unter '" + start_.string() + "'";
        return antwort;
    }
    const std::vector<std::string> argumente =
        (quelle == GitlinkQuelle::Head)
            ? std::vector<std::string>{"ls-tree", "HEAD", "--", pfad}
            : std::vector<std::string>{"ls-files", "--stage", "--", pfad};

    const ProzessAusgang ausgang = fuehre_git_aus(wurzel_, argumente);
    const std::optional<int> code = exit_code(ausgang);
    if (!code.has_value() || *code != 0) return werkzeug_ausfall(ausgang);

    const std::string zeile = erste_zeile(ausgang.ausgabe);
    if (zeile.empty()) {
        GitlinkAntwort antwort;
        antwort.werkzeug_ok = true;  // git hat geantwortet: es gibt den Eintrag nicht
        return antwort;
    }
    return (quelle == GitlinkQuelle::Head) ? parse_ls_tree_zeile(zeile) : parse_ls_files_stage_zeile(zeile);
}

}  // namespace comdare::ci_wachen
