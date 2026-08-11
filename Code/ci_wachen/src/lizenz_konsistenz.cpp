// SPDX-License-Identifier: Apache-2.0
// lizenz_konsistenz.cpp -- Umsetzung (Begruendung im Kopf von lizenz_konsistenz.hpp).
// ASCII-only, Zeilen <= 120 Byte.

#include "comdare/ci_wachen/lizenz_konsistenz.hpp"

#include <algorithm>
#include <fstream>
#include <optional>
#include <sstream>
#include <system_error>

namespace comdare::ci_wachen {
namespace {

constexpr std::string_view kWacheMarke   = "WACHE:";
constexpr std::string_view kFormSubmodul = "SUBMODUL ";
constexpr std::string_view kFormVendor   = "VENDOR ";
constexpr std::string_view kFormKeine    = "KEINE-LIZENZDATEI";
constexpr std::string_view kFormLizenz   = "LIZENZ \"";
constexpr std::string_view kFormDatei    = " DATEI ";

std::string_view rand_weg(std::string_view s) {
    const std::size_t a = s.find_first_not_of(" \t\r\n");
    if (a == std::string_view::npos) { return {}; }
    const std::size_t b = s.find_last_not_of(" \t\r\n");
    return s.substr(a, b - a + 1);
}

std::vector<std::string> in_zeilen(std::string_view text) {
    std::vector<std::string> zeilen;
    std::size_t              start = 0;
    while (start <= text.size()) {
        const std::size_t ende = text.find('\n', start);
        if (ende == std::string_view::npos) {
            if (start < text.size()) { zeilen.emplace_back(text.substr(start)); }
            break;
        }
        std::string zeile(text.substr(start, ende - start));
        if (!zeile.empty() && zeile.back() == '\r') { zeile.pop_back(); }
        zeilen.push_back(std::move(zeile));
        start = ende + 1;
    }
    return zeilen;
}

bool enthaelt(std::string_view heuhaufen, std::string_view nadel) {
    return !nadel.empty() && heuhaufen.find(nadel) != std::string_view::npos;
}

// Ein Dateiname, der eine Lizenz TRAEGT -- LICENSE*, LICENCE*, COPYING*.
// Vergleich ohne Ruecksicht auf Gross-/Kleinschreibung: eine der drei am
// 10.08. gemessenen Falsch-Null-Klassen ist genau Case.
bool ist_lizenzdateiname(std::string_view name) {
    std::string gross(name);
    for (char& c : gross) {
        if (c >= 'a' && c <= 'z') { c = static_cast<char>(c - 'a' + 'A'); }
    }
    return gross.rfind("LICENSE", 0) == 0 || gross.rfind("LICENCE", 0) == 0 || gross.rfind("COPYING", 0) == 0;
}

std::optional<std::string> lies_datei(const std::filesystem::path& datei) {
    std::ifstream strom(datei, std::ios::binary);
    if (!strom) { return std::nullopt; } // fail-closed: kein leerer String als Ersatz
    std::ostringstream puffer;
    puffer << strom.rdbuf();
    if (strom.bad()) { return std::nullopt; }
    return puffer.str();
}

std::optional<std::string> lies_kopf(const std::filesystem::path& datei, std::size_t byte) {
    std::ifstream strom(datei, std::ios::binary);
    if (!strom) { return std::nullopt; }
    std::string puffer(byte, '\0');
    strom.read(puffer.data(), static_cast<std::streamsize>(byte));
    puffer.resize(static_cast<std::size_t>(strom.gcount()));
    return puffer;
}

// Der Wert hinter der SPDX-Marke in einem Dateikopf, oder nullopt.
std::optional<std::string> spdx_wert_aus(std::string_view kopf) {
    const std::string marke = std::string(LIZENZ_SPDX_MARKE_A) + std::string(LIZENZ_SPDX_MARKE_B);
    const std::size_t pos   = kopf.find(marke);
    if (pos == std::string_view::npos) { return std::nullopt; }
    std::string_view rest = kopf.substr(pos + marke.size());
    const std::size_t nl  = rest.find('\n');
    if (nl != std::string_view::npos) { rest = rest.substr(0, nl); }
    const std::string_view wert = rand_weg(rest);
    return std::string(wert);
}

bool verzeichnis_nicht_leer(const std::filesystem::path& p) {
    std::error_code ec;
    if (!std::filesystem::is_directory(p, ec) || ec) { return false; }
    std::filesystem::directory_iterator it(p, ec);
    if (ec) { return false; }
    return it != std::filesystem::directory_iterator{};
}

bool traegt_lizenzdatei(const std::filesystem::path& wurzel) {
    std::error_code ec;
    std::filesystem::directory_iterator it(wurzel, ec);
    if (ec) { return false; }
    for (const auto& eintrag : it) {
        std::error_code ec2;
        if (!eintrag.is_regular_file(ec2) || ec2) { continue; }
        if (ist_lizenzdateiname(eintrag.path().filename().string())) { return true; }
    }
    return false;
}

// Genau die zwei Verzeichnisklassen der .gitignore (Z.10 `build/`, Z.23
// `cmake-build-*/`) plus der Fremdcode unter external/.
bool ist_uebersprungen(std::string_view name) {
    return name == "build" || name == "external" || name.rfind("cmake-build-", 0) == 0;
}

} // namespace

std::vector<std::string> parse_gitmodules(std::string_view text) {
    std::vector<std::string> pfade;
    for (const std::string& roh : in_zeilen(text)) {
        const std::string_view zeile = rand_weg(roh);
        if (zeile.rfind("path", 0) != 0) { continue; }
        const std::size_t gleich = zeile.find('=');
        if (gleich == std::string_view::npos) { continue; }
        // Zwischen "path" und "=" darf nur Rand stehen -- sonst waere "pathologisch = x"
        // ein Treffer.
        if (!rand_weg(zeile.substr(4, gleich - 4)).empty()) { continue; }
        const std::string_view wert = rand_weg(zeile.substr(gleich + 1));
        if (!wert.empty()) { pfade.emplace_back(wert); }
    }
    return pfade;
}

std::vector<NoticeEintrag> parse_notice(std::string_view text) {
    std::vector<NoticeEintrag> eintraege;
    const std::vector<std::string> zeilen = in_zeilen(text);
    for (std::size_t i = 0; i < zeilen.size(); ++i) {
        // SPALTE 0 BINDET. Nur eine Zeile, die OHNE Einrueckung mit WACHE:
        // beginnt, ist ein Eintrag. Das ist keine Formalie, sondern der Grund,
        // aus dem die NOTICE ihre eigene Grammatik erklaeren kann: die drei
        // Muster-Zeilen im Erklaerungsblock stehen EINGERUECKT und sind damit
        // Text, nicht Eintrag. Ohne diese Regel las die Wache am Bautag 6
        // SUBMODUL- statt 4 und 10 VENDOR- statt 9 Eintraegen -- gemessen, nicht
        // vermutet. Dieselbe Regel wie im ci_yml_scanner: Spalte 0 trennt.
        const std::string_view zeile = zeilen[i];
        if (zeile.rfind(kWacheMarke, 0) != 0) { continue; }

        NoticeEintrag eintrag;
        eintrag.zeile = i + 1;
        std::string_view rest = rand_weg(zeile.substr(kWacheMarke.size()));

        if (rest.rfind(kFormSubmodul, 0) == 0) {
            eintrag.art = NoticeArt::Submodul;
            rest        = rest.substr(kFormSubmodul.size());
        } else if (rest.rfind(kFormVendor, 0) == 0) {
            eintrag.art = NoticeArt::Vendor;
            rest        = rest.substr(kFormVendor.size());
        } else {
            eintraege.push_back(eintrag); // wohlgeformt bleibt false
            continue;
        }

        const std::size_t leer = rest.find(' ');
        if (leer == std::string_view::npos || leer == 0) {
            eintraege.push_back(eintrag);
            continue;
        }
        eintrag.pfad = std::string(rest.substr(0, leer));
        rest         = rand_weg(rest.substr(leer + 1));

        if (rest == kFormKeine) {
            if (eintrag.art == NoticeArt::Submodul) {
                eintrag.art         = NoticeArt::SubmodulOhneLizenzdatei;
                eintrag.wohlgeformt = true;
            }
            eintraege.push_back(eintrag);
            continue;
        }

        if (rest.rfind(kFormLizenz, 0) != 0) {
            eintraege.push_back(eintrag);
            continue;
        }
        rest                     = rest.substr(kFormLizenz.size());
        const std::size_t schluss = rest.find('"');
        if (schluss == std::string_view::npos || schluss == 0) {
            eintraege.push_back(eintrag); // leerer Marker gilt als UNLESBAR:
            continue;                     // "" stuende sonst in jeder Datei.
        }
        eintrag.marker = std::string(rest.substr(0, schluss));
        rest           = rest.substr(schluss + 1);

        if (rest.rfind(kFormDatei, 0) != 0) {
            eintraege.push_back(eintrag);
            continue;
        }
        const std::string_view datei = rand_weg(rest.substr(kFormDatei.size()));
        if (datei.empty()) {
            eintraege.push_back(eintrag);
            continue;
        }
        eintrag.lizenzdatei = std::string(datei);
        eintrag.wohlgeformt = true;
        eintraege.push_back(eintrag);
    }
    return eintraege;
}

std::string lizenzdatei_pfad(const NoticeEintrag& eintrag) {
    if (eintrag.lizenzdatei.empty() || eintrag.pfad.empty()) { return {}; }
    if (eintrag.art == NoticeArt::Vendor) {
        return std::string(LIZENZ_VENDOR_WURZEL) + "/" + eintrag.pfad + "/" + eintrag.lizenzdatei;
    }
    return eintrag.pfad + "/" + eintrag.lizenzdatei;
}

std::string befund_name(BefundArt art) {
    switch (art) {
        case BefundArt::NoticeFehlt: return "NoticeFehlt";
        case BefundArt::NoticeZeileUnlesbar: return "NoticeZeileUnlesbar";
        case BefundArt::NoticeZeileZuLang: return "NoticeZeileZuLang";
        case BefundArt::SubmodulOhneNoticeZeile: return "SubmodulOhneNoticeZeile";
        case BefundArt::NoticeZeileOhneSubmodul: return "NoticeZeileOhneSubmodul";
        case BefundArt::NoticeZeileOhneLizenzdatei: return "NoticeZeileOhneLizenzdatei";
        case BefundArt::MarkerNichtInLizenzdatei: return "MarkerNichtInLizenzdatei";
        case BefundArt::KeineLizenzdateiObwohlVorhanden: return "KeineLizenzdateiObwohlVorhanden";
        case BefundArt::VendorProjektOhneNoticeZeile: return "VendorProjektOhneNoticeZeile";
        case BefundArt::WurzelLizenzOhneApacheMarker: return "WurzelLizenzOhneApacheMarker";
        case BefundArt::WurzelLizenzOhneKlauselMarker: return "WurzelLizenzOhneKlauselMarker";
        case BefundArt::SpdxAbweichler: return "SpdxAbweichler";
        case BefundArt::NennerNull: return "NennerNull";
    }
    return "UNBEKANNT"; // fail-closed, wie exit_code_von in ergebnis.hpp
}

bool hat_befund(const LizenzErgebnis& ergebnis, BefundArt art) {
    return std::any_of(ergebnis.befunde.begin(), ergebnis.befunde.end(),
                       [art](const Befund& b) { return b.art == art; });
}

std::string ergebnis_bericht(const LizenzErgebnis& ergebnis) {
    std::ostringstream aus;
    aus << "LIZENZ-KONSISTENZ: " << status_text(ergebnis.status) << "\n";
    aus << "  NENNER .gitmodules-Eintraege : " << ergebnis.nenner_gitmodules << "\n";
    aus << "  NENNER Vendor-Projekte       : " << ergebnis.nenner_vendor << "\n";
    aus << "  NENNER SPDX-Dateien          : " << ergebnis.nenner_spdx << "\n";
    aus << "  NENNER NOTICE SUBMODUL-Zeilen: " << ergebnis.nenner_notice_submodul << "\n";
    aus << "  NENNER NOTICE VENDOR-Zeilen  : " << ergebnis.nenner_notice_vendor << "\n";
    for (const std::string& skip : ergebnis.skips) { aus << "  SKIP    " << skip << "\n"; }
    for (const Befund& b : ergebnis.befunde) { aus << "  BEFUND  [" << befund_name(b.art) << "] " << b.text << "\n"; }
    if (ergebnis.befunde.empty()) { aus << "  0 Befunde.\n"; }
    return aus.str();
}

LizenzErgebnis pruefe(const LizenzEingang& eingang) {
    LizenzErgebnis ergebnis;
    const auto     melde = [&ergebnis](BefundArt art, std::string text) {
        ergebnis.befunde.push_back(Befund{art, std::move(text)});
    };

    if (!eingang.notice_vorhanden) { melde(BefundArt::NoticeFehlt, "NOTICE fehlt an der Wurzel"); }

    const std::vector<std::string>   gitmodule = parse_gitmodules(eingang.gitmodules_text);
    const std::vector<NoticeEintrag> eintraege = parse_notice(eingang.notice_text);

    ergebnis.nenner_gitmodules = gitmodule.size();
    ergebnis.nenner_vendor     = eingang.vendor_am_baum.size();
    ergebnis.nenner_spdx       = eingang.spdx_funde.size();
    for (const NoticeEintrag& e : eintraege) {
        if (e.art == NoticeArt::Vendor) {
            ++ergebnis.nenner_notice_vendor;
        } else {
            ++ergebnis.nenner_notice_submodul;
        }
    }

    // -- DIE NENNER-PFLICHT. Ein leerer Gegenstand ist ein ABBRUCH, nie ein Gruen:
    // sonst waere jede Forderung unten an einer leeren Menge trivial erfuellt.
    bool nenner_null = false;
    if (ergebnis.nenner_gitmodules == 0) {
        nenner_null = true;
        melde(BefundArt::NennerNull, "NENNER 0: kein .gitmodules-Eintrag gelesen -- die Paarung waere leer.");
    }
    if (ergebnis.nenner_vendor == 0) {
        nenner_null = true;
        melde(BefundArt::NennerNull, "NENNER 0: kein Vendor-Projekt mit Lizenzdatei gefunden.");
    }
    if (ergebnis.nenner_spdx == 0) {
        nenner_null = true;
        melde(BefundArt::NennerNull, "NENNER 0: keine SPDX-tragende Datei gescannt.");
    }

    // -- Die Grammatik der Eintragszeilen ---------------------------------------
    std::size_t nr = 0;
    for (const std::string& zeile : in_zeilen(eingang.notice_text)) {
        ++nr;
        if (zeile.rfind(kWacheMarke, 0) != 0) { continue; } // Spalte 0 bindet, s. parse_notice
        if (zeile.size() > LIZENZ_ZEILE_MAX_BYTE) {
            melde(BefundArt::NoticeZeileZuLang, "NOTICE-Zeile ueber " + std::to_string(LIZENZ_ZEILE_MAX_BYTE) +
                                                    " Byte: Zeile " + std::to_string(nr) + " hat " +
                                                    std::to_string(zeile.size()) + " Byte.");
        }
    }
    for (const NoticeEintrag& e : eintraege) {
        if (!e.wohlgeformt) {
            melde(BefundArt::NoticeZeileUnlesbar,
                  "NOTICE-Zeile folgt der Grammatik nicht: Zeile " + std::to_string(e.zeile));
        }
    }

    // -- Paarung .gitmodules <-> NOTICE (gilt AUCH fuer nicht ausgecheckte) ------
    for (const std::string& pfad : gitmodule) {
        const bool gepaart = std::any_of(eintraege.begin(), eintraege.end(), [&pfad](const NoticeEintrag& e) {
            return e.art != NoticeArt::Vendor && e.pfad == pfad;
        });
        if (!gepaart) {
            melde(BefundArt::SubmodulOhneNoticeZeile, "Submodul ohne NOTICE-Zeile: " + pfad);
        }
    }
    for (const NoticeEintrag& e : eintraege) {
        if (e.art == NoticeArt::Vendor || !e.wohlgeformt) { continue; }
        if (std::find(gitmodule.begin(), gitmodule.end(), e.pfad) == gitmodule.end()) {
            melde(BefundArt::NoticeZeileOhneSubmodul,
                  "NOTICE-Zeile nicht in .gitmodules: " + e.pfad + " (Zeile " + std::to_string(e.zeile) + ")");
        }
    }

    // -- Inhaltspruefung der Submodul-Zeilen -------------------------------------
    for (const NoticeEintrag& e : eintraege) {
        if (e.art == NoticeArt::Vendor || !e.wohlgeformt) { continue; }
        const auto am_baum = eingang.submodule_am_baum.find(e.pfad);
        if (am_baum == eingang.submodule_am_baum.end() || !am_baum->second.ausgecheckt) {
            // NICHT AUSGECHECKT: nur die Paarung oben gilt. Der Verzicht wird
            // PROTOKOLLIERT -- ein stiller Verzicht waere eine verdeckte Null.
            ergebnis.skips.push_back("Submodul nicht ausgecheckt, nur gepaart: " + e.pfad);
            continue;
        }
        if (e.art == NoticeArt::SubmodulOhneLizenzdatei) {
            if (am_baum->second.hat_lizenzdatei) {
                melde(BefundArt::KeineLizenzdateiObwohlVorhanden,
                      "KEINE-LIZENZDATEI behauptet, aber eine Lizenzdatei liegt an der Wurzel von " + e.pfad);
            }
            continue;
        }
        const std::string voll   = lizenzdatei_pfad(e);
        const auto        inhalt = eingang.dateiinhalt.find(voll);
        if (inhalt == eingang.dateiinhalt.end()) {
            melde(BefundArt::NoticeZeileOhneLizenzdatei,
                  "NOTICE nennt eine Lizenzdatei, die es am Baum nicht gibt: " + voll);
            continue;
        }
        if (!enthaelt(inhalt->second, e.marker)) {
            melde(BefundArt::MarkerNichtInLizenzdatei,
                  "Marker nicht in Lizenzdatei: \"" + e.marker + "\" fehlt in " + voll);
        }
    }

    // -- Vendor: beide Richtungen ------------------------------------------------
    for (const NoticeEintrag& e : eintraege) {
        if (e.art != NoticeArt::Vendor || !e.wohlgeformt) { continue; }
        if (eingang.vendor_am_baum.find(e.pfad) == eingang.vendor_am_baum.end()) {
            melde(BefundArt::NoticeZeileOhneLizenzdatei,
                  "VENDOR-Zeile ohne Projekt mit Lizenzdatei am Baum: " + e.pfad);
            continue;
        }
        const std::string voll   = lizenzdatei_pfad(e);
        const auto        inhalt = eingang.dateiinhalt.find(voll);
        if (inhalt == eingang.dateiinhalt.end()) {
            melde(BefundArt::NoticeZeileOhneLizenzdatei,
                  "NOTICE nennt eine Lizenzdatei, die es am Baum nicht gibt: " + voll);
            continue;
        }
        if (!enthaelt(inhalt->second, e.marker)) {
            melde(BefundArt::MarkerNichtInLizenzdatei,
                  "Marker nicht in Lizenzdatei: \"" + e.marker + "\" fehlt in " + voll);
        }
    }
    for (const auto& [pfad, datei] : eingang.vendor_am_baum) {
        const bool gepaart = std::any_of(eintraege.begin(), eintraege.end(), [&pfad](const NoticeEintrag& e) {
            return e.art == NoticeArt::Vendor && e.pfad == pfad;
        });
        if (!gepaart) {
            melde(BefundArt::VendorProjektOhneNoticeZeile,
                  "Vendor-Projekt ohne NOTICE-Zeile: " + pfad + " (Lizenzdatei " + datei + ")");
        }
    }

    // -- Die Wurzel-LICENSE ------------------------------------------------------
    if (!enthaelt(eingang.license_text, LIZENZ_APACHE_MARKER_A) ||
        !enthaelt(eingang.license_text, LIZENZ_APACHE_MARKER_B)) {
        melde(BefundArt::WurzelLizenzOhneApacheMarker,
              "Wurzel-LICENSE ohne Apache-Marker: \"" + std::string(LIZENZ_APACHE_MARKER_A) + "\" und \"" +
                  std::string(LIZENZ_APACHE_MARKER_B) + "\" muessen beide darin stehen.");
    }
    if (!enthaelt(eingang.license_text, LIZENZ_KLAUSEL_MARKER)) {
        melde(BefundArt::WurzelLizenzOhneKlauselMarker,
              "Klausel-Marker fehlt in der Wurzel-LICENSE: \"" + std::string(LIZENZ_KLAUSEL_MARKER) + "\"");
    }

    // -- SPDX-Uniformitaet unter Code/ -------------------------------------------
    for (const SpdxFund& fund : eingang.spdx_funde) {
        if (fund.wert != LIZENZ_SPDX_SOLL) {
            melde(BefundArt::SpdxAbweichler,
                  "SPDX-Abweichler: " + fund.datei + " traegt \"" + fund.wert + "\" statt " +
                      std::string(LIZENZ_SPDX_SOLL));
        }
    }

    if (nenner_null) {
        ergebnis.status = WacheStatus::Abbruch;
    } else if (!ergebnis.befunde.empty()) {
        ergebnis.status = WacheStatus::Riss;
    } else {
        ergebnis.status = WacheStatus::Gruen;
    }
    return ergebnis;
}

LizenzEingang sammle_vom_baum(const std::filesystem::path& wurzel) {
    LizenzEingang eingang;

    if (const auto notice = lies_datei(wurzel / "NOTICE")) {
        eingang.notice_vorhanden = true;
        eingang.notice_text      = *notice;
    }
    if (const auto gm = lies_datei(wurzel / ".gitmodules")) { eingang.gitmodules_text = *gm; }
    if (const auto lic = lies_datei(wurzel / "LICENSE")) { eingang.license_text = *lic; }

    for (const std::string& pfad : parse_gitmodules(eingang.gitmodules_text)) {
        SubmodulAmBaum zustand;
        const std::filesystem::path dir = wurzel / pfad;
        zustand.ausgecheckt             = verzeichnis_nicht_leer(dir);
        zustand.hat_lizenzdatei         = zustand.ausgecheckt && traegt_lizenzdatei(dir);
        eingang.submodule_am_baum.emplace(pfad, zustand);
    }

    // Vendor-Projekte: je Projektverzeichnis unter Forschungsarbeiten/code die
    // ERSTE Lizenzdatei in lexikografischer Ordnung (std::map haelt sie sortiert,
    // damit die Auswahl nicht von der Dateisystem-Reihenfolge abhaengt).
    const std::filesystem::path vendor_wurzel = wurzel / std::filesystem::path(std::string(LIZENZ_VENDOR_WURZEL));
    std::error_code             ec;
    if (std::filesystem::is_directory(vendor_wurzel, ec) && !ec) {
        std::map<std::string, std::vector<std::string>> je_projekt;
        std::filesystem::recursive_directory_iterator it(vendor_wurzel, ec);
        if (!ec) {
            for (auto lauf = std::filesystem::begin(it); lauf != std::filesystem::end(it); lauf.increment(ec)) {
                if (ec) { break; }
                // Tiefe 0 = Projektverzeichnis, 1 = Klon darin, 2 = die Lizenzdatei.
                // Ab Tiefe 2 wird nicht weiter abgestiegen -- dieselbe Schranke wie
                // `find -maxdepth 3` in der Erhebung am Bautag.
                if (lauf.depth() >= 2) { lauf.disable_recursion_pending(); }
                std::error_code ec2;
                if (!lauf->is_regular_file(ec2) || ec2) { continue; }
                if (!ist_lizenzdateiname(lauf->path().filename().string())) { continue; }
                std::filesystem::path projekt = lauf->path();
                while (projekt.parent_path() != vendor_wurzel && projekt.has_parent_path() &&
                       projekt.parent_path() != projekt) {
                    projekt = projekt.parent_path();
                }
                // Beide Schluessel sind RELATIV -- der Projektname zur Vendor-Wurzel,
                // die Lizenzdatei zum Projekt (s. Grammatik-Block im Header).
                const std::filesystem::path projekt_rel = std::filesystem::relative(projekt, vendor_wurzel, ec2);
                if (ec2) { continue; }
                const std::filesystem::path datei_rel = std::filesystem::relative(lauf->path(), projekt, ec2);
                if (ec2) { continue; }
                je_projekt[projekt_rel.generic_string()].push_back(datei_rel.generic_string());
            }
        }
        for (auto& [projekt, dateien] : je_projekt) {
            std::sort(dateien.begin(), dateien.end());
            eingang.vendor_am_baum.emplace(projekt, dateien.front());
        }
    }

    // Die von NOTICE benannten Lizenzdateien -- und nur die. Was NOTICE nicht
    // nennt, braucht die Wache auch nicht zu lesen. Der Schluessel kommt aus
    // lizenzdatei_pfad(), also aus DERSELBEN Funktion, die der Pruefkern zum
    // Nachschlagen benutzt -- zwei Fassungen waeren eine stille Divergenz.
    for (const NoticeEintrag& e : parse_notice(eingang.notice_text)) {
        const std::string voll = lizenzdatei_pfad(e);
        if (voll.empty()) { continue; }
        if (const auto inhalt = lies_datei(wurzel / voll)) { eingang.dateiinhalt.emplace(voll, *inhalt); }
    }

    // SPDX unter Code/, ohne external/ und ohne die Bauverzeichnisse.
    const std::filesystem::path code = wurzel / "Code";
    if (std::filesystem::is_directory(code, ec) && !ec) {
        std::map<std::string, std::string> sortiert;
        std::filesystem::recursive_directory_iterator it(code, ec);
        if (!ec) {
            for (auto lauf = std::filesystem::begin(it); lauf != std::filesystem::end(it); lauf.increment(ec)) {
                if (ec) { break; }
                std::error_code ec2;
                const std::string name = lauf->path().filename().string();
                if (lauf->is_directory(ec2) && !ec2) {
                    if (ist_uebersprungen(name) || name.rfind('.', 0) == 0) { lauf.disable_recursion_pending(); }
                    continue;
                }
                if (!lauf->is_regular_file(ec2) || ec2) { continue; }
                const auto kopf = lies_kopf(lauf->path(), LIZENZ_SPDX_KOPF_BYTE);
                if (!kopf) { continue; }
                const auto wert = spdx_wert_aus(*kopf);
                if (!wert) { continue; }
                const std::filesystem::path rel = std::filesystem::relative(lauf->path(), wurzel, ec2);
                if (ec2) { continue; }
                sortiert.emplace(rel.generic_string(), *wert);
            }
        }
        for (const auto& [datei, wert] : sortiert) { eingang.spdx_funde.push_back(SpdxFund{datei, wert}); }
    }

    return eingang;
}

} // namespace comdare::ci_wachen
