// werkbank.cpp -- Umsetzung (Begruendung im Kopf von werkbank.hpp).
// ASCII-only, Zeilen <= 120 Byte.

#include "comdare/ci_wachen/werkbank.hpp"

#include <atomic>
#include <chrono>
#include <fstream>

#include "comdare/ci_wachen/prozess.hpp"

namespace comdare::ci_wachen::werkbank {
namespace {

std::uint64_t frischer_seed() {
    std::random_device  geraet;
    const std::uint64_t hoch = static_cast<std::uint64_t>(geraet()) << 32;
    const std::uint64_t tief = static_cast<std::uint64_t>(geraet());
    const std::uint64_t zeit = static_cast<std::uint64_t>(std::chrono::steady_clock::now().time_since_epoch().count());
    return hoch ^ tief ^ zeit;
}

std::string eindeutiger_temp_pfad() {
    static std::atomic<unsigned> zaehler{0};
    std::random_device           geraet;
    std::string                  name = "comdare_ci_wachen_";
    name += std::to_string(static_cast<unsigned long long>(geraet()));
    name += "_";
    name += std::to_string(zaehler.fetch_add(1));
    return (std::filesystem::temp_directory_path() / name).string();
}

} // namespace

// ---- Wuerfel ----------------------------------------------------------------------
Wuerfel::Wuerfel() : Wuerfel(frischer_seed()) {}
Wuerfel::Wuerfel(std::uint64_t seed) : seed_(seed), quelle_(seed) {}

int Wuerfel::zahl(int min_inklusive, int max_inklusive) {
    std::uniform_int_distribution<int> verteilung(min_inklusive, max_inklusive);
    return verteilung(quelle_);
}

std::string Wuerfel::token(std::size_t stellen) {
    static const char*                 ZIFFERN = "0123456789abcdef";
    std::uniform_int_distribution<int> verteilung(0, 15);
    std::string                        text;
    text.reserve(stellen);
    for (std::size_t i = 0; i < stellen; ++i) text.push_back(ZIFFERN[verteilung(quelle_)]);
    return text;
}

std::string Wuerfel::sha40() { return token(40); }

// ---- FixtureRepo ------------------------------------------------------------------
FixtureRepo::FixtureRepo() : pfad_(eindeutiger_temp_pfad()) {}

FixtureRepo::~FixtureRepo() {
    std::error_code fehler;
    std::filesystem::remove_all(pfad_, fehler); // Aufraeumen darf nie einen Test kippen
}

testing::AssertionResult FixtureRepo::git(const std::vector<std::string>& argumente, const char* was) {
    const ProzessAusgang     ausgang = fuehre_git_aus(pfad_, argumente);
    const std::optional<int> code    = exit_code(ausgang);
    if (!code.has_value()) {
        // Werkzeug-Ausfall. Er faellt hier auf und wird ROT -- er wird NICHT als Biss
        // verbucht und auch nicht als Erfolg. Genau das ging am 09.08. schief.
        return testing::AssertionFailure()
               << "Fixture-Schritt '" << was << "' konnte nicht laufen: " << ausgang.beschreibung();
    }
    if (*code != 0) {
        return testing::AssertionFailure()
               << "Fixture-Schritt '" << was << "' scheiterte mit Exit(" << *code << "). stderr: " << ausgang.fehler;
    }
    return testing::AssertionSuccess();
}

testing::AssertionResult FixtureRepo::init() {
    std::error_code fehler;
    std::filesystem::create_directories(pfad_, fehler);
    if (fehler) {
        return testing::AssertionFailure()
               << "Wegwerf-Verzeichnis '" << pfad_.string() << "' liess sich nicht anlegen: " << fehler.message();
    }
    return git({"init", "--quiet"}, "git init");
}

testing::AssertionResult FixtureRepo::schreibe(const std::string& relativ, const std::string& inhalt) {
    const std::filesystem::path ziel = pfad_ / relativ;
    std::error_code             fehler;
    if (ziel.has_parent_path()) std::filesystem::create_directories(ziel.parent_path(), fehler);
    std::ofstream strom(ziel, std::ios::binary | std::ios::trunc);
    if (!strom) return testing::AssertionFailure() << "Datei '" << ziel.string() << "' nicht schreibbar.";
    strom.write(inhalt.data(), static_cast<std::streamsize>(inhalt.size()));
    strom.close();
    if (!strom) return testing::AssertionFailure() << "Datei '" << ziel.string() << "' nicht vollstaendig.";
    return testing::AssertionSuccess();
}

testing::AssertionResult FixtureRepo::verfolge(const std::string& relativ) {
    return git({"add", "--", relativ}, "git add");
}

testing::AssertionResult FixtureRepo::schreibe_und_verfolge(const std::string& relativ, const std::string& inhalt) {
    const testing::AssertionResult geschrieben = schreibe(relativ, inhalt);
    if (!geschrieben) return geschrieben;
    return verfolge(relativ);
}

testing::AssertionResult FixtureRepo::loesche_aus_arbeitsbaum(const std::string& relativ) {
    std::error_code fehler;
    if (!std::filesystem::remove(pfad_ / relativ, fehler)) {
        return testing::AssertionFailure() << "'" << relativ << "' liess sich nicht entfernen: " << fehler.message();
    }
    return testing::AssertionSuccess();
}

testing::AssertionResult FixtureRepo::committe(const std::string& nachricht) {
    // Identitaet NUR fuer diesen einen Aufruf: weder globale noch Repo-Konfiguration
    // wird angefasst.
    return git({"-c", "user.name=Comdare Wachen-Test", "-c", "user.email=wachen@example.invalid", "commit", "--quiet",
                "-m", nachricht},
               "git commit");
}

testing::AssertionResult FixtureRepo::setze_index_eintrag(const std::string& relativ, const std::string& modus,
                                                          const std::string& objekt) {
    return git({"update-index", "--add", "--cacheinfo", modus + "," + objekt + "," + relativ},
               "git update-index --cacheinfo");
}

testing::AssertionResult FixtureRepo::ist_verfolgt(const std::string& relativ) {
    const ProzessAusgang     ausgang = fuehre_git_aus(pfad_, {"ls-files", "--error-unmatch", "--", relativ});
    const std::optional<int> code    = exit_code(ausgang);
    if (!code.has_value()) {
        return testing::AssertionFailure() << "Gegenprobe 'ist verfolgt' lief nicht: " << ausgang.beschreibung();
    }
    if (*code != 0) {
        return testing::AssertionFailure() << "'" << relativ << "' ist NICHT verfolgt -- die "
                                           << "Voraussetzung des Falls steht nicht.";
    }
    return testing::AssertionSuccess();
}

testing::AssertionResult FixtureRepo::ist_nicht_verfolgt(const std::string& relativ) {
    const ProzessAusgang     ausgang = fuehre_git_aus(pfad_, {"ls-files", "--error-unmatch", "--", relativ});
    const std::optional<int> code    = exit_code(ausgang);
    if (!code.has_value()) {
        return testing::AssertionFailure() << "Gegenprobe 'nicht verfolgt' lief nicht: " << ausgang.beschreibung();
    }
    if (*code == 0) {
        return testing::AssertionFailure() << "'" << relativ << "' IST verfolgt -- der Fall wollte "
                                           << "gerade das Gegenteil belegen.";
    }
    return testing::AssertionSuccess();
}

std::string FixtureRepo::index_modus(const std::string& relativ) {
    const ProzessAusgang     ausgang = fuehre_git_aus(pfad_, {"ls-files", "--stage", "--", relativ});
    const std::optional<int> code    = exit_code(ausgang);
    if (!code.has_value() || *code != 0) return {};
    const GitlinkAntwort antwort = parse_ls_files_stage_zeile(ausgang.ausgabe);
    return antwort.modus;
}

// ---- Fixture-Bausteine ------------------------------------------------------------
std::string xml_wohlgeformt(const std::string& token) {
    return "<?xml version=\"1.0\"?>\n<wurzel token=\"" + token +
           "\">\n  <!-- sauberer Kommentar -->\n"
           "  <kind/>\n</wurzel>\n";
}

std::string xml_doppelbindestrich(const std::string& token) {
    // GENAU die Fehlerklasse der fuenf am 08.08. gefundenen Dateien: ein CLI-Flag, das
    // als Aufruf-Beispiel im Kommentar stand.
    return "<?xml version=\"1.0\"?>\n<wurzel token=\"" + token +
           "\">\n"
           "  <!-- Beispielaufruf: werkzeug --flag wert -->\n</wurzel>\n";
}

std::string xml_namensraum_fehler(const std::string& token) {
    // Gemessen: rc=0 UND stderr nicht leer. Der einzige gefundene Weg in den Riegel.
    return "<?xml version=\"1.0\"?>\n<wurzel token=\"" + token + "\"><a:kind/></wurzel>\n";
}

std::string xml_doctype_einzelbindestrich(const std::string& token) {
    return "<?xml version=\"1.0\"?>\n<!DOCTYPE wurzel [\n  <!ELEMENT wurzel (#PCDATA)>\n]>\n"
           "<wurzel>ein - einzelner Bindestrich, token " +
           token + "</wurzel>\n";
}

// ---- Fakes ------------------------------------------------------------------------
DateiBestand FakeGitQuelle::ls_files_z(const std::string&) const { return bestand; }

GitlinkAntwort FakeGitQuelle::gitlink(const std::string& pfad, GitlinkQuelle quelle) const {
    const std::map<std::string, GitlinkAntwort>& tabelle =
        (quelle == GitlinkQuelle::Head) ? gitlinks_head : gitlinks_index;
    const auto treffer = tabelle.find(pfad);
    if (treffer == tabelle.end()) {
        GitlinkAntwort antwort;
        antwort.werkzeug_ok = true; // git hat geantwortet: der Eintrag existiert nicht
        return antwort;
    }
    return treffer->second;
}

std::filesystem::path FakeGitQuelle::aufloesen(const std::string& pfad) const {
    return wurzel.empty() ? std::filesystem::path(pfad) : wurzel / pfad;
}

FakeXmlParser::FakeXmlParser() { vorgabe.art = XmlUrteilArt::Wohlgeformt; }

XmlUrteil FakeXmlParser::pruefe(const std::filesystem::path& datei) const {
    ++aufrufe;
    const auto treffer = urteile.find(datei.filename().string());
    if (treffer != urteile.end()) return treffer->second;
    return vorgabe;
}

} // namespace comdare::ci_wachen::werkbank
