// SPDX-License-Identifier: Apache-2.0
// lizenz_konsistenz.cpp -- Umsetzung (Begruendung im Kopf von lizenz_konsistenz.hpp).
// ASCII-only, Zeilen <= 120 Byte.

#include "comdare/ci_wachen/lizenz_konsistenz.hpp"

#include <algorithm>
#include <fstream>
#include <functional>
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
// Zusicherung 8 (25.08.2026): WACHE: LIZENZTEXT <datei> BYTEGLEICH <quelle>
constexpr std::string_view kFormLizenztext = "LIZENZTEXT ";
constexpr std::string_view kFormBytegleich = "BYTEGLEICH ";

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
    std::string_view  rest = kopf.substr(pos + marke.size());
    const std::size_t nl   = rest.find('\n');
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

// ALLE Lizenzdateien an dieser Wurzel, lexikografisch sortiert. Frueher stand
// hier ein bool -- damit war die DATEI-Bindung nicht formulierbar: "es liegt
// eine da" sagt nichts darueber, ob es DIE benannte ist.
std::vector<std::string> lizenzdateien_an_wurzel(const std::filesystem::path& wurzel) {
    std::vector<std::string>            namen;
    std::error_code                     ec;
    std::filesystem::directory_iterator it(wurzel, ec);
    if (ec) { return namen; }
    for (const auto& eintrag : it) {
        std::error_code ec2;
        if (!eintrag.is_regular_file(ec2) || ec2) { continue; }
        const std::string name = eintrag.path().filename().string();
        if (ist_lizenzdateiname(name)) { namen.push_back(name); }
    }
    std::sort(namen.begin(), namen.end());
    return namen;
}

// Der Fremdcode-Skip plus JEDES aus Code/.gitignore abgeleitete Muster. Die
// Liste kommt als Parameter herein und wird NICHT hier abgeschrieben -- eine
// abgeschriebene Liste behauptete "genau die zwei Klassen der .gitignore",
// waehrend die Datei VIER trug, und liess die CI-Bauverzeichnisse durch.
bool ist_uebersprungen(std::string_view name, const std::vector<std::string>& muster) {
    if (name == LIZENZ_SPDX_SKIP_FEST) { return true; }
    return std::any_of(muster.begin(), muster.end(),
                       [name](const std::string& m) { return passt_verzeichnismuster(name, m); });
}

// Fuer den Fehltext: "LICENSE, LICENSE_AUDIT_EXT.md" bzw. "(keine)".
std::string liste_text(const std::vector<std::string>& werte) {
    if (werte.empty()) { return "(keine)"; }
    std::string aus;
    for (const std::string& w : werte) {
        if (!aus.empty()) { aus += ", "; }
        aus += w;
    }
    return aus;
}

// ASCII heisst hier: druckbar plus Tabulator. Zeilenenden hat in_zeilen bereits
// abgetrennt, ein '\r' oder '\n' kann hier also nicht mehr auftauchen.
bool ist_ascii_zeichen(unsigned char c) { return c == '\t' || (c >= 0x20 && c <= 0x7e); }

// Laenge UND ASCII fuer JEDE Zeile eines der beiden Lizenz-Dokumente. Eine
// gemeinsame Funktion fuer NOTICE und LICENSE, weil zwei Abschriften genau die
// Divergenz erzeugen wuerden, die diese Wache anderswo verbietet.
void pruefe_zeilennorm(std::string_view name, std::string_view text,
                       const std::function<void(BefundArt, std::string)>& melde) {
    std::size_t nr = 0;
    for (const std::string& zeile : in_zeilen(text)) {
        ++nr;
        if (zeile.size() > LIZENZ_ZEILE_MAX_BYTE) {
            melde(BefundArt::TextZeileZuLang,
                  std::string(name) + "-Zeile ueber " + std::to_string(LIZENZ_ZEILE_MAX_BYTE) + " Byte: Zeile " +
                      std::to_string(nr) + " hat " + std::to_string(zeile.size()) + " Byte.");
        }
        for (std::size_t i = 0; i < zeile.size(); ++i) {
            const unsigned char c = static_cast<unsigned char>(zeile[i]);
            if (ist_ascii_zeichen(c)) { continue; }
            char        hex[3]  = {0, 0, 0};
            const char* ziffern = "0123456789ABCDEF";
            hex[0]              = ziffern[(c >> 4) & 0x0f];
            hex[1]              = ziffern[c & 0x0f];
            melde(BefundArt::TextZeileNichtAscii, std::string(name) + "-Zeile " + std::to_string(nr) +
                                                      " traegt Byte 0x" + hex + " an Position " +
                                                      std::to_string(i + 1) + " -- ausserhalb ASCII.");
            break; // ein Befund je Zeile genuegt; die Zeile ist benannt.
        }
    }
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
    std::vector<NoticeEintrag>     eintraege;
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
        eintrag.zeile         = i + 1;
        std::string_view rest = rand_weg(zeile.substr(kWacheMarke.size()));

        if (rest.rfind(kFormSubmodul, 0) == 0) {
            eintrag.art = NoticeArt::Submodul;
            rest        = rest.substr(kFormSubmodul.size());
        } else if (rest.rfind(kFormVendor, 0) == 0) {
            eintrag.art = NoticeArt::Vendor;
            rest        = rest.substr(kFormVendor.size());
        } else if (rest.rfind(kFormLizenztext, 0) == 0) {
            eintrag.art = NoticeArt::Lizenztext;
            rest        = rest.substr(kFormLizenztext.size());
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

        if (eintrag.art == NoticeArt::Lizenztext) {
            // <datei> ist ein NACKTER Dateiname unter LICENSES/. Ein Pfad mit '/'
            // wuerde die Kopie irgendwohin legen, wo REUSE sie nicht sieht -- das
            // ist kein Eintrag, sondern eine unlesbare Zeile (nie ein stiller Skip).
            if (eintrag.pfad.find('/') != std::string::npos || rest.rfind(kFormBytegleich, 0) != 0) {
                eintraege.push_back(eintrag);
                continue;
            }
            const std::string_view quelle = rand_weg(rest.substr(kFormBytegleich.size()));
            if (quelle.empty()) {
                eintraege.push_back(eintrag);
                continue;
            }
            eintrag.quelle      = std::string(quelle);
            eintrag.wohlgeformt = true;
            eintraege.push_back(eintrag);
            continue;
        }

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
        rest                      = rest.substr(kFormLizenz.size());
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

std::string lizenztext_pfad(const NoticeEintrag& eintrag) {
    if (eintrag.art != NoticeArt::Lizenztext || eintrag.pfad.empty()) { return {}; }
    return std::string(LIZENZ_TEXTE_WURZEL) + "/" + eintrag.pfad;
}

bool marker_ist_aussagekraeftig(std::string_view marker) {
    // ZWEI Schranken, und beide sind noetig. Die Laenge allein liesse "the"
    // durch; die Gegenprobe allein liesse ein einzelnes seltenes Zeichen durch.
    if (rand_weg(marker).size() < LIZENZ_MARKER_MIN_ZEICHEN) { return false; }
    // Die Richtung ist wichtig: KONTROLLE enthaelt MARKER. "Apache" faellt
    // darunter, "Apache License" nicht -- der zusammengesetzte Marker sagt etwas,
    // der Baustein allein nicht.
    return LIZENZ_MARKER_GEGENPROBE.find(marker) == std::string_view::npos;
}

bool passt_verzeichnismuster(std::string_view name, std::string_view muster) {
    if (muster.empty()) { return false; }
    if (muster.back() != '*') { return name == muster; }
    const std::string_view praefix = muster.substr(0, muster.size() - 1);
    // FAIL-CLOSED gegen das nackte "*": ein leerer Praefix traefe JEDES
    // Verzeichnis und liesse den SPDX-Scan mit 0 Dateien enden -- also genau die
    // verdeckte Null, gegen die diese Wache gebaut ist. Der eigene Fall K18 hat
    // das aufgedeckt; parse_gitignore legt ein solches Muster zusaetzlich in
    // `unverstanden`, damit die Luecke auch in der AUSGABE steht.
    if (praefix.empty()) { return false; }
    return name.size() >= praefix.size() && name.rfind(praefix, 0) == 0;
}

GitignoreMuster parse_gitignore(std::string_view text) {
    GitignoreMuster ergebnis;
    for (const std::string& roh : in_zeilen(text)) {
        std::string_view zeile = rand_weg(roh);
        if (zeile.empty() || zeile.front() == '#') { continue; }
        // KEIN abschliessender Schraegstrich = Dateimuster. Der SPDX-Scan
        // ueberspringt VERZEICHNISSE; Dateimuster sind nicht sein Gegenstand
        // und deshalb auch kein "unverstandenes" Muster.
        if (zeile.back() != '/') { continue; }
        zeile = zeile.substr(0, zeile.size() - 1);
        if (!zeile.empty() && zeile.front() == '/') { zeile = zeile.substr(1); }
        if (zeile.empty()) { continue; }
        const std::size_t stern     = zeile.find('*');
        const bool        sternform = stern == std::string_view::npos || stern + 1 == zeile.size();
        // Das nackte "*" ist KEIN auswertbares Muster: es traefe jedes
        // Verzeichnis und leerte den Scan. Es gehoert in `unverstanden`.
        if (zeile == "*" || zeile.front() == '!' || zeile.find('/') != std::string_view::npos || !sternform) {
            // PROTOKOLLIERT statt verworfen: ein Muster, das nicht wirkt, ist
            // eine Luecke im Skip -- sie gehoert in die Ausgabe, nicht ins Nichts.
            ergebnis.unverstanden.emplace_back(zeile);
            continue;
        }
        ergebnis.verzeichnisse.emplace_back(zeile);
    }
    return ergebnis;
}

std::string befund_name(BefundArt art) {
    switch (art) {
        case BefundArt::NoticeFehlt: return "NoticeFehlt";
        case BefundArt::NoticeZeileUnlesbar: return "NoticeZeileUnlesbar";
        case BefundArt::TextZeileZuLang: return "TextZeileZuLang";
        case BefundArt::TextZeileNichtAscii: return "TextZeileNichtAscii";
        case BefundArt::SubmodulOhneNoticeZeile: return "SubmodulOhneNoticeZeile";
        case BefundArt::NoticeZeileOhneSubmodul: return "NoticeZeileOhneSubmodul";
        case BefundArt::NoticeZeileOhneLizenzdatei: return "NoticeZeileOhneLizenzdatei";
        case BefundArt::NoticeDateiIstKeineLizenzdatei: return "NoticeDateiIstKeineLizenzdatei";
        case BefundArt::MarkerNichtInLizenzdatei: return "MarkerNichtInLizenzdatei";
        case BefundArt::MarkerOhneAussagekraft: return "MarkerOhneAussagekraft";
        case BefundArt::KeineLizenzdateiObwohlVorhanden: return "KeineLizenzdateiObwohlVorhanden";
        case BefundArt::VendorProjektOhneNoticeZeile: return "VendorProjektOhneNoticeZeile";
        case BefundArt::NoticeZeileMehrfach: return "NoticeZeileMehrfach";
        case BefundArt::GitmodulesPfadMehrfach: return "GitmodulesPfadMehrfach";
        case BefundArt::WurzelLizenzOhneApacheMarker: return "WurzelLizenzOhneApacheMarker";
        case BefundArt::WurzelLizenzOhneKlauselMarker: return "WurzelLizenzOhneKlauselMarker";
        case BefundArt::SpdxAbweichler: return "SpdxAbweichler";
        case BefundArt::LizenztextFehlt: return "LizenztextFehlt";
        case BefundArt::LizenztextQuelleFehlt: return "LizenztextQuelleFehlt";
        case BefundArt::LizenztextAbweichend: return "LizenztextAbweichend";
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
    // Der Zaehler NEBEN seiner Grundgesamtheit (V-1). "26" allein war die Zahl,
    // die am 11.08. als umgebungsabhaengig auffiel, ohne dass die Ausgabe es
    // zeigte; "26 von 187 gescannten" traegt seine Herkunft mit, und die
    // SKIP-Zeilen darunter nennen jedes ausgelassene Verzeichnis beim Namen.
    aus << "  NENNER SPDX-Dateien          : " << ergebnis.nenner_spdx << " von " << ergebnis.nenner_code_dateien
        << " gescannten Dateien unter Code/\n";
    aus << "  NENNER NOTICE SUBMODUL-Zeilen: " << ergebnis.nenner_notice_submodul << "\n";
    aus << "  NENNER NOTICE VENDOR-Zeilen  : " << ergebnis.nenner_notice_vendor << "\n";
    aus << "  NENNER NOTICE LIZENZTEXT-Zln : " << ergebnis.nenner_notice_lizenztext << "\n";
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

    ergebnis.nenner_gitmodules   = gitmodule.size();
    ergebnis.nenner_vendor       = eingang.vendor_am_baum.size();
    ergebnis.nenner_spdx         = eingang.spdx_funde.size();
    ergebnis.nenner_code_dateien = eingang.spdx_gescannt;

    // DIE HERKUNFT DES SPDX-NENNERS IN DIE AUSGABE. Sie ist der Unterschied
    // zwischen "26" und "26, weil diese vier Verzeichnisse ausgelassen wurden".
    for (const std::string& d : eingang.spdx_uebersprungen) {
        ergebnis.skips.push_back("SPDX-Scan uebersprungen: " + d);
    }
    for (const std::string& m : eingang.gitignore_unverstanden) {
        ergebnis.skips.push_back("Code/.gitignore-Verzeichnismuster nicht ausgewertet: " + m);
    }

    for (const NoticeEintrag& e : eintraege) {
        if (e.art == NoticeArt::Vendor) {
            ++ergebnis.nenner_notice_vendor;
        } else if (e.art == NoticeArt::Lizenztext) {
            // Eine LIZENZTEXT-Zeile ist KEINE Submodul-Zeile: sie darf die Paarung
            // .gitmodules <-> NOTICE nicht verschieben (Fall K23 haelt das fest).
            ++ergebnis.nenner_notice_lizenztext;
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
    // Die GRUNDGESAMTHEIT des SPDX-Nenners. 0 angefasste Dateien heisst: der Scan
    // lief ins Leere (falsche Wurzel, alles uebersprungen) -- dann sagt auch ein
    // Zaehler von 0 nichts, und "0 Befunde" waere ein verdecktes Gruen.
    if (ergebnis.nenner_code_dateien == 0) {
        nenner_null = true;
        melde(BefundArt::NennerNull, "NENNER 0: der SPDX-Scan hat unter Code/ keine einzige Datei angefasst.");
    }

    // -- Die ZEILENNORM beider Lizenz-Dokumente ----------------------------------
    // JEDE Zeile, nicht nur die WACHE:-Eintragszeilen. Die Diff-Hygiene-Wache
    // ueberspringt NOTICE und LICENSE namentlich; ohne diesen Block prueft die
    // Prosa dieser beiden Dateien KEIN Werkzeug auf ASCII oder Laenge.
    pruefe_zeilennorm("NOTICE", eingang.notice_text, melde);
    pruefe_zeilennorm("LICENSE", eingang.license_text, melde);

    for (const NoticeEintrag& e : eintraege) {
        if (!e.wohlgeformt) {
            melde(BefundArt::NoticeZeileUnlesbar,
                  "NOTICE-Zeile folgt der Grammatik nicht: Zeile " + std::to_string(e.zeile));
            continue;
        }
        // DIE AUSSAGEKRAFT DES MARKERS, an EINER Stelle geprueft und von beiden
        // Inhaltsschleifen unten wiederbenutzt. Ein Marker aus einem Leerzeichen
        // ist grammatisch tadellos und steht in praktisch jeder Datei -- er ist
        // eine Zusicherung, die nie reissen kann (gemessen 11.08., Koeder aus
        // einer gewuerfelten Position der echten Lizenzdatei).
        if (e.art == NoticeArt::SubmodulOhneLizenzdatei || e.art == NoticeArt::Lizenztext) { continue; }
        if (!marker_ist_aussagekraeftig(e.marker)) {
            melde(BefundArt::MarkerOhneAussagekraft,
                  "Marker ohne Aussagekraft in NOTICE-Zeile " + std::to_string(e.zeile) + ": \"" + e.marker +
                      "\" -- zu kurz (unter " + std::to_string(LIZENZ_MARKER_MIN_ZEICHEN) +
                      " Zeichen) oder selbst nur ein Baustein, den jeder Text traegt.");
        }
    }

    // -- MULTIPLIZITAET: "GENAU EINE", nicht "mindestens eine" -------------------
    // any_of/find beantworten die Frage "gibt es mindestens eine". Zusicherung (1)
    // sagt aber GENAU EINE, und genau dazwischen liegt der Zustand, in dem NOTICE
    // ueber DENSELBEN Pfad zwei Aussagen macht und beide bestaetigt werden. Am
    // Objekt gemessen (11.08., verdoppelte SUBMODUL-Zeile): NENNER NOTICE
    // SUBMODUL-Zeilen 5 gegen NENNER .gitmodules 4 -- und 0 Befunde.
    std::map<std::string, std::size_t> notice_submodul_je_pfad;
    std::map<std::string, std::size_t> notice_vendor_je_pfad;
    std::map<std::string, std::size_t> notice_lizenztext_je_datei;
    for (const NoticeEintrag& e : eintraege) {
        if (!e.wohlgeformt) { continue; }
        if (e.art == NoticeArt::Vendor) {
            ++notice_vendor_je_pfad[e.pfad];
        } else if (e.art == NoticeArt::Lizenztext) {
            ++notice_lizenztext_je_datei[e.pfad];
        } else {
            ++notice_submodul_je_pfad[e.pfad];
        }
    }
    const auto anzahl_in = [](const std::map<std::string, std::size_t>& tabelle, const std::string& pfad) {
        const auto it = tabelle.find(pfad);
        return it == tabelle.end() ? std::size_t{0} : it->second;
    };

    // -- Paarung .gitmodules <-> NOTICE (gilt AUCH fuer nicht ausgecheckte) ------
    // Die Reihenfolge der .gitmodules bleibt die Reihenfolge der Meldungen;
    // `gesehen` sorgt nur dafuer, dass ein doppelter Pfad nicht doppelt gemeldet wird.
    std::vector<std::string> gesehen;
    for (const std::string& pfad : gitmodule) {
        if (std::find(gesehen.begin(), gesehen.end(), pfad) != gesehen.end()) { continue; }
        gesehen.push_back(pfad);
        const auto        treffer       = std::count(gitmodule.begin(), gitmodule.end(), pfad);
        const std::size_t in_gitmodules = static_cast<std::size_t>(treffer);
        if (in_gitmodules > 1) {
            melde(BefundArt::GitmodulesPfadMehrfach,
                  ".gitmodules nennt denselben Pfad " + std::to_string(in_gitmodules) + " mal: " + pfad);
        }
        const std::size_t in_notice = anzahl_in(notice_submodul_je_pfad, pfad);
        if (in_notice == 0) {
            melde(BefundArt::SubmodulOhneNoticeZeile, "Submodul ohne NOTICE-Zeile: " + pfad);
        } else if (in_notice > 1) {
            melde(BefundArt::NoticeZeileMehrfach, "NOTICE nennt denselben SUBMODUL-Pfad " + std::to_string(in_notice) +
                                                      " mal, zugesichert ist GENAU EINE: " + pfad);
        }
    }
    for (const NoticeEintrag& e : eintraege) {
        if (e.art == NoticeArt::Vendor || e.art == NoticeArt::Lizenztext || !e.wohlgeformt) { continue; }
        if (std::find(gitmodule.begin(), gitmodule.end(), e.pfad) == gitmodule.end()) {
            melde(BefundArt::NoticeZeileOhneSubmodul,
                  "NOTICE-Zeile nicht in .gitmodules: " + e.pfad + " (Zeile " + std::to_string(e.zeile) + ")");
        }
    }

    // -- Inhaltspruefung der Submodul-Zeilen -------------------------------------
    for (const NoticeEintrag& e : eintraege) {
        if (e.art == NoticeArt::Vendor || e.art == NoticeArt::Lizenztext || !e.wohlgeformt) { continue; }
        const auto am_baum = eingang.submodule_am_baum.find(e.pfad);
        if (am_baum == eingang.submodule_am_baum.end() || !am_baum->second.ausgecheckt) {
            // NICHT AUSGECHECKT: nur die Paarung oben gilt. Der Verzicht wird
            // PROTOKOLLIERT -- ein stiller Verzicht waere eine verdeckte Null.
            ergebnis.skips.push_back("Submodul nicht ausgecheckt, nur gepaart: " + e.pfad);
            continue;
        }
        if (e.art == NoticeArt::SubmodulOhneLizenzdatei) {
            if (!am_baum->second.lizenzdateien.empty()) {
                melde(BefundArt::KeineLizenzdateiObwohlVorhanden,
                      "KEINE-LIZENZDATEI behauptet, aber an der Wurzel von " + e.pfad +
                          " liegt: " + liste_text(am_baum->second.lizenzdateien));
            }
            continue;
        }
        // DIE DATEI-BINDUNG. Ohne sie bindet Zusicherung (2) die DATEI an nichts:
        // NOTICE duerfte auf irgendeine Datei zeigen, die den Marker zufaellig
        // traegt, waehrend die wirkliche Lizenzdatei danebenliegt und etwas
        // anderes sagt. Genau die Fehlerklasse KON2-25, gegen die diese Wache
        // gebaut ist -- und sie ueberlebte sie bis zum 11.08.
        const std::vector<std::string>& liste = am_baum->second.lizenzdateien;
        if (std::find(liste.begin(), liste.end(), e.lizenzdatei) == liste.end()) {
            melde(BefundArt::NoticeDateiIstKeineLizenzdatei,
                  "NOTICE nennt \"" + e.lizenzdatei + "\" als Lizenzdatei von " + e.pfad +
                      ", aber dort liegt als Lizenzdatei: " + liste_text(liste));
            continue;
        }
        const std::string voll   = lizenzdatei_pfad(e);
        const auto        inhalt = eingang.dateiinhalt.find(voll);
        if (inhalt == eingang.dateiinhalt.end()) {
            melde(BefundArt::NoticeZeileOhneLizenzdatei,
                  "NOTICE nennt eine Lizenzdatei, die es am Baum nicht gibt: " + voll);
            continue;
        }
        // Ein Marker ohne Aussagekraft ist oben schon gemeldet; ihn hier noch
        // einmal am Text zu messen, brachte nur einen zweiten, irrefuehrenden
        // Befund ueber dieselbe Zeile.
        if (!marker_ist_aussagekraeftig(e.marker)) { continue; }
        if (!enthaelt(inhalt->second, e.marker)) {
            melde(BefundArt::MarkerNichtInLizenzdatei,
                  "Marker nicht in Lizenzdatei: \"" + e.marker + "\" fehlt in " + voll);
        }
    }

    // -- Vendor: beide Richtungen ------------------------------------------------
    for (const NoticeEintrag& e : eintraege) {
        if (e.art != NoticeArt::Vendor || !e.wohlgeformt) { continue; }
        const auto am_baum = eingang.vendor_am_baum.find(e.pfad);
        if (am_baum == eingang.vendor_am_baum.end()) {
            melde(BefundArt::NoticeZeileOhneLizenzdatei,
                  "VENDOR-Zeile ohne Projekt mit Lizenzdatei am Baum: " + e.pfad);
            continue;
        }
        // DIESELBE DATEI-BINDUNG wie im Submodul-Zweig, aus demselben Grund.
        const std::vector<std::string>& liste = am_baum->second;
        if (std::find(liste.begin(), liste.end(), e.lizenzdatei) == liste.end()) {
            melde(BefundArt::NoticeDateiIstKeineLizenzdatei,
                  "NOTICE nennt \"" + e.lizenzdatei + "\" als Lizenzdatei von " + e.pfad +
                      ", aber dort liegt als Lizenzdatei: " + liste_text(liste));
            continue;
        }
        const std::string voll   = lizenzdatei_pfad(e);
        const auto        inhalt = eingang.dateiinhalt.find(voll);
        if (inhalt == eingang.dateiinhalt.end()) {
            melde(BefundArt::NoticeZeileOhneLizenzdatei,
                  "NOTICE nennt eine Lizenzdatei, die es am Baum nicht gibt: " + voll);
            continue;
        }
        if (!marker_ist_aussagekraeftig(e.marker)) { continue; }
        if (!enthaelt(inhalt->second, e.marker)) {
            melde(BefundArt::MarkerNichtInLizenzdatei,
                  "Marker nicht in Lizenzdatei: \"" + e.marker + "\" fehlt in " + voll);
        }
    }
    for (const auto& [pfad, dateien] : eingang.vendor_am_baum) {
        const std::size_t in_notice = anzahl_in(notice_vendor_je_pfad, pfad);
        if (in_notice == 0) {
            melde(BefundArt::VendorProjektOhneNoticeZeile,
                  "Vendor-Projekt ohne NOTICE-Zeile: " + pfad + " (Lizenzdatei " + liste_text(dateien) + ")");
        } else if (in_notice > 1) {
            melde(BefundArt::NoticeZeileMehrfach, "NOTICE nennt denselben VENDOR-Pfad " + std::to_string(in_notice) +
                                                      " mal, zugesichert ist GENAU EINE: " + pfad);
        }
    }

    // -- Lizenztext-Kopien unter LICENSES/ (Zusicherung 8) -----------------------
    // super ist Apache-lizenziert und zieht die restriktiv lizenzierte cache engine
    // als Submodul ein. Owner X1 (25.08.2026): super wird "um die restriktive
    // ce-Lizenz ERWEITERT" -- der Volltext liegt deshalb als Kopie unter LICENSES/,
    // damit ihn ein Leser dieses Repos OHNE Submodul-Checkout sieht. Eine Kopie
    // kann veralten; deshalb Byte fuer Byte gegen die Quelle, nie "aehnlich".
    for (const auto& [datei, n] : notice_lizenztext_je_datei) {
        if (n > 1) {
            melde(BefundArt::NoticeZeileMehrfach, "NOTICE nennt denselben LIZENZTEXT " + std::to_string(n) +
                                                      " mal, zugesichert ist GENAU EINE: " + datei);
        }
    }
    for (const NoticeEintrag& e : eintraege) {
        if (e.art != NoticeArt::Lizenztext || !e.wohlgeformt) { continue; }
        const std::string ziel  = lizenztext_pfad(e);
        const auto        kopie = eingang.dateiinhalt.find(ziel);
        if (kopie == eingang.dateiinhalt.end()) {
            melde(BefundArt::LizenztextFehlt, "Lizenztext fehlt: " + ziel + " (NOTICE-Zeile " +
                                                  std::to_string(e.zeile) + ", Quelle " + e.quelle + ")");
            continue;
        }
        // Liegt die Quelle in einem NICHT ausgecheckten Submodul, gilt dieselbe
        // Regel wie bei den Submodul-Zeilen: kein Rot auf dem frischen Klon, aber
        // ein PROTOKOLLIERTER Verzicht -- nie ein stilles Gruen. Die Kopie selbst
        // ist oben bereits verlangt worden; der Verzicht gilt nur der Byte-Probe.
        bool quelle_nicht_ausgecheckt = false;
        for (const auto& [pfad, zustand] : eingang.submodule_am_baum) {
            if (!zustand.ausgecheckt && e.quelle.rfind(pfad + "/", 0) == 0) { quelle_nicht_ausgecheckt = true; }
        }
        if (quelle_nicht_ausgecheckt) {
            ergebnis.skips.push_back("Lizenztext-Quelle nicht ausgecheckt, nur Kopie geprueft: " + e.quelle);
            continue;
        }
        const auto quelle = eingang.dateiinhalt.find(e.quelle);
        if (quelle == eingang.dateiinhalt.end()) {
            melde(BefundArt::LizenztextQuelleFehlt,
                  "Lizenztext-Quelle fehlt am Baum: " + e.quelle + " (NOTICE-Zeile " + std::to_string(e.zeile) + ")");
            continue;
        }
        if (kopie->second != quelle->second) {
            const std::string& a = kopie->second;
            const std::string& b = quelle->second;
            std::size_t        i = 0;
            while (i < a.size() && i < b.size() && a[i] == b[i]) { ++i; }
            // Das ERSTE abweichende Byte steht im Fehltext: wer den Befund liest,
            // soll die Stelle finden, nicht erst einen Diff fahren muessen.
            melde(BefundArt::LizenztextAbweichend,
                  "Lizenztext nicht byte-gleich: " + ziel + " (" + std::to_string(a.size()) + " Byte) gegen " +
                      e.quelle + " (" + std::to_string(b.size()) + " Byte), erste Abweichung bei Byte " +
                      std::to_string(i + 1));
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
            melde(BefundArt::SpdxAbweichler, "SPDX-Abweichler: " + fund.datei + " traegt \"" + fund.wert + "\" statt " +
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
    if (const auto gi = lies_datei(wurzel / std::filesystem::path(std::string(LIZENZ_CODE_GITIGNORE)))) {
        eingang.code_gitignore_text = *gi;
    }

    for (const std::string& pfad : parse_gitmodules(eingang.gitmodules_text)) {
        SubmodulAmBaum              zustand;
        const std::filesystem::path dir = wurzel / pfad;
        zustand.ausgecheckt             = verzeichnis_nicht_leer(dir);
        if (zustand.ausgecheckt) { zustand.lizenzdateien = lizenzdateien_an_wurzel(dir); }
        eingang.submodule_am_baum.emplace(pfad, zustand);
    }

    // Vendor-Projekte: je Projektverzeichnis unter Forschungsarbeiten/code die
    // ERSTE Lizenzdatei in lexikografischer Ordnung (std::map haelt sie sortiert,
    // damit die Auswahl nicht von der Dateisystem-Reihenfolge abhaengt).
    const std::filesystem::path vendor_wurzel = wurzel / std::filesystem::path(std::string(LIZENZ_VENDOR_WURZEL));
    std::error_code             ec;
    if (std::filesystem::is_directory(vendor_wurzel, ec) && !ec) {
        std::map<std::string, std::vector<std::string>> je_projekt;
        std::filesystem::recursive_directory_iterator   it(vendor_wurzel, ec);
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
            // ALLE, nicht die erste. Welche davon NOTICE nennen darf, entscheidet
            // die DATEI-Bindung im Pruefkern -- eine Auswahl hier haette diese
            // Frage vorweggenommen und die Bindung wieder hohl gemacht.
            eingang.vendor_am_baum.emplace(projekt, dateien);
        }
    }

    // Die von NOTICE benannten Lizenzdateien -- und nur die. Was NOTICE nicht
    // nennt, braucht die Wache auch nicht zu lesen. Der Schluessel kommt aus
    // lizenzdatei_pfad(), also aus DERSELBEN Funktion, die der Pruefkern zum
    // Nachschlagen benutzt -- zwei Fassungen waeren eine stille Divergenz.
    for (const NoticeEintrag& e : parse_notice(eingang.notice_text)) {
        if (e.art == NoticeArt::Lizenztext) {
            // Zusicherung 8: Kopie UND Quelle, beide byte-genau (lies_datei liest
            // binaer). Eine fehlende Datei bekommt KEINEN Eintrag -- der Pruefkern
            // unterscheidet "fehlt" von "nicht ausgecheckt" ueber submodule_am_baum.
            if (!e.wohlgeformt) { continue; }
            const std::string ziel = lizenztext_pfad(e);
            if (const auto inhalt = lies_datei(wurzel / ziel)) { eingang.dateiinhalt.emplace(ziel, *inhalt); }
            if (const auto inhalt = lies_datei(wurzel / e.quelle)) { eingang.dateiinhalt.emplace(e.quelle, *inhalt); }
            continue;
        }
        const std::string voll = lizenzdatei_pfad(e);
        if (voll.empty()) { continue; }
        if (const auto inhalt = lies_datei(wurzel / voll)) { eingang.dateiinhalt.emplace(voll, *inhalt); }
    }

    // SPDX unter Code/. Die Skip-Liste kommt AUS Code/.gitignore, nicht aus einer
    // Abschrift: eine Abschrift behauptete "genau die zwei Verzeichnisklassen der
    // .gitignore", waehrend die Datei vier trug -- und die CI baut nach
    // Code/build-test und Code/build-test-debug. Am Objekt stieg der Nenner damit
    // von 26 auf 39, und die Wache las generierte Bauartefakte als Repo-Quelle.
    const GitignoreMuster muster   = parse_gitignore(eingang.code_gitignore_text);
    eingang.gitignore_unverstanden = muster.unverstanden;
    std::vector<std::string> uebersprungen;

    const std::filesystem::path code = wurzel / "Code";
    if (std::filesystem::is_directory(code, ec) && !ec) {
        std::map<std::string, std::string>            sortiert;
        std::filesystem::recursive_directory_iterator it(code, ec);
        if (!ec) {
            for (auto lauf = std::filesystem::begin(it); lauf != std::filesystem::end(it); lauf.increment(ec)) {
                if (ec) { break; }
                std::error_code   ec2;
                const std::string name = lauf->path().filename().string();
                if (lauf->is_directory(ec2) && !ec2) {
                    if (ist_uebersprungen(name, muster.verzeichnisse) || name.rfind('.', 0) == 0) {
                        lauf.disable_recursion_pending();
                        // JEDER Verzicht wird benannt. Ein stiller Skip ist genau
                        // die verdeckte Null, gegen die diese Wache gebaut ist --
                        // und er ist die Herkunft des SPDX-Nenners.
                        const std::filesystem::path rel = std::filesystem::relative(lauf->path(), wurzel, ec2);
                        uebersprungen.push_back(ec2 ? lauf->path().generic_string() : rel.generic_string());
                    }
                    continue;
                }
                if (!lauf->is_regular_file(ec2) || ec2) { continue; }
                ++eingang.spdx_gescannt; // die Grundgesamtheit, nicht nur der Zaehler
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
    std::sort(uebersprungen.begin(), uebersprungen.end()); // Ausgabe unabhaengig von der Platten-Reihenfolge
    eingang.spdx_uebersprungen = std::move(uebersprungen);

    return eingang;
}

} // namespace comdare::ci_wachen
