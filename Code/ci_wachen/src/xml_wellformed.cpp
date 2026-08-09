// xml_wellformed.cpp -- Umsetzung (Begruendung im Kopf von xml_wellformed.hpp).
// ASCII-only, Zeilen <= 120 Byte.

#include "comdare/ci_wachen/xml_wellformed.hpp"

#include <filesystem>

namespace comdare::ci_wachen {

std::string status_text(WacheStatus status) {
    switch (status) {
        case WacheStatus::Gruen:   return "GRUEN";
        case WacheStatus::Riss:    return "RISS";
        case WacheStatus::Abbruch: return "ABBRUCH";
    }
    return "UNBEKANNT";
}

std::string befund_text(XmlBefundArt art) {
    switch (art) {
        case XmlBefundArt::ParserFehler:        return "ParserFehler";
        case XmlBefundArt::DiagnoseTrotzErfolg: return "DiagnoseTrotzErfolg";
    }
    return "UNBEKANNT";
}

std::string abbruch_text(XmlAbbruchGrund grund) {
    switch (grund) {
        case XmlAbbruchGrund::KeinGitBaum:       return "KeinGitBaum";
        case XmlAbbruchGrund::GitFehlgeschlagen: return "GitFehlgeschlagen";
        case XmlAbbruchGrund::NullDateien:       return "NullDateien";
        case XmlAbbruchGrund::ParserFehlt:       return "ParserFehlt";
    }
    return "UNBEKANNT";
}

XmlWacheErgebnis pruefe_xml_bestand(const GitQuelle& git, const XmlParser& parser) {
    XmlWacheErgebnis ergebnis;

    if (!git.ist_arbeitsbaum()) {
        ergebnis.status = WacheStatus::Abbruch;
        ergebnis.abbruch = XmlAbbruchGrund::KeinGitBaum;
        return ergebnis;
    }

    const DateiBestand bestand = git.ls_files_z("*.xml");
    if (!bestand.werkzeug_ok) {
        // Ein git-Fehler ist NICHT dasselbe wie "keine Dateien gefunden". Die Shell-
        // Fassung konnte beides nur ueber denselben rc=2 melden.
        ergebnis.status = WacheStatus::Abbruch;
        ergebnis.abbruch = XmlAbbruchGrund::GitFehlgeschlagen;
        ergebnis.abbruch_detail = bestand.diagnose;
        return ergebnis;
    }

    ergebnis.nenner = static_cast<int>(bestand.pfade.size());
    if (ergebnis.nenner == 0) {
        ergebnis.status = WacheStatus::Abbruch;
        ergebnis.abbruch = XmlAbbruchGrund::NullDateien;
        return ergebnis;
    }

    for (const std::string& pfad : bestand.pfade) {
        const std::filesystem::path datei = git.aufloesen(pfad);
        std::error_code fehler;
        if (!std::filesystem::is_regular_file(datei, fehler)) {
            // Eingefrorenes Verhalten der Shell-Fassung: im Nenner mitgezaehlt, nie
            // geoeffnet. NEU ist nur, dass die Zahl im Protokoll erscheint.
            ++ergebnis.nicht_gelesen;
            continue;
        }
        const XmlUrteil urteil = parser.pruefe(datei);
        switch (urteil.art) {
            case XmlUrteilArt::Wohlgeformt:
                break;
            case XmlUrteilArt::ParserFehler:
                ergebnis.risse.push_back({pfad, XmlBefundArt::ParserFehler, urteil.meldungen});
                break;
            case XmlUrteilArt::DiagnoseTrotzErfolg:
                ergebnis.risse.push_back({pfad, XmlBefundArt::DiagnoseTrotzErfolg, urteil.meldungen});
                break;
            case XmlUrteilArt::ParserNichtVerfuegbar:
                // FAIL-CLOSED UND SOFORT: ein Werkzeug, das nicht laeuft, faellt hier
                // NICHT in "wohlgeformt" und auch nicht in "kaputt" -- die Wache kann
                // ueber den ganzen Bestand keine Aussage mehr treffen.
                ergebnis.status = WacheStatus::Abbruch;
                ergebnis.abbruch = XmlAbbruchGrund::ParserFehlt;
                ergebnis.abbruch_detail = urteil.werkzeug_diagnose;
                ergebnis.risse.clear();
                return ergebnis;
        }
    }

    ergebnis.status = ergebnis.risse.empty() ? WacheStatus::Gruen : WacheStatus::Riss;
    return ergebnis;
}

std::string XmlWacheErgebnis::protokoll() const {
    const std::string NAME = "ci_xml_wellformed_wache";
    std::string text;

    if (abbruch.has_value()) {
        switch (*abbruch) {
            case XmlAbbruchGrund::KeinGitBaum:
                text += NAME + ": ABBRUCH -- kein git-Arbeitsbaum.\n";
                text += "  Der Bestand wird ueber 'git ls-files -z' aufgezaehlt; ohne git gibt es\n";
                text += "  keinen belastbaren Nenner, also auch kein Gruen.\n";
                break;
            case XmlAbbruchGrund::GitFehlgeschlagen:
                text += NAME + ": ABBRUCH -- git hat die Aufzaehlung nicht geliefert.\n";
                text += "  Ein git-Fehler ist NICHT 'null Dateien' -- er ist gar keine Aussage.\n";
                break;
            case XmlAbbruchGrund::NullDateien:
                text += NAME + ": ABBRUCH -- NULL getrackte *.xml gefunden.\n";
                text += "  Ein leerer Nenner ist kein bestandener Lauf. Entweder laeuft die Wache im\n";
                text += "  falschen Verzeichnis, oder die Aufzaehlung greift nicht mehr.\n";
                break;
            case XmlAbbruchGrund::ParserFehlt:
                text += NAME + ": ABBRUCH -- der XML-Parser wurde im PATH NICHT gefunden.\n";
                text += "  Diese Wache liest XML ausschliesslich ueber einen echten Parser; ohne ihn\n";
                text += "  kann sie KEINE Aussage treffen. Ein stiller Skip waere das Abschalten der\n";
                text += "  Wache, nicht ihr Bestehen. Nachinstallieren: Debian/Ubuntu 'libxml2-utils',\n";
                text += "  RHEL/Fedora/SUSE 'libxml2', Alpine 'libxml2-utils', Arch 'libxml2'.\n";
                break;
        }
        if (!abbruch_detail.empty()) text += "  Diagnose: " + abbruch_detail + "\n";
        text += "NENNER (nie eine nackte Null):\n";
        text += "  " + std::to_string(nenner) + " XML-Dateien aufgezaehlt, 0 beurteilt.\n";
        return text;
    }

    text += NAME + ": pruefe " + std::to_string(nenner) + " getrackte *.xml ...\n\n";
    text += "NICHT WOHLGEFORMTE DATEIEN:\n";
    if (risse.empty()) {
        text += "  (keine)\n";
    } else {
        for (const XmlBefund& befund : risse) {
            if (befund.art == XmlBefundArt::ParserFehler) {
                text += "  " + befund.datei + "  (ParserFehler)\n";
            } else {
                text += "  " + befund.datei +
                        "  (Parser akzeptiert, meldet aber -- FALSE-GREEN, s. Kopf-Kommentar)\n";
            }
            int gezeigt = 0;
            for (const std::string& meldung : befund.meldungen) {
                if (gezeigt++ >= 3) break;
                text += "      " + meldung + "\n";
            }
        }
    }
    text += "\n";
    text += "-----------------------------------------------------------------------------\n";
    text += "NENNER (nie eine nackte Null):\n";
    text += "  " + std::to_string(nenner) + " XML-Dateien geprueft, " + std::to_string(risse.size()) +
            " nicht wohlgeformt.\n";
    text += "  davon " + std::to_string(nicht_gelesen) +
            " im Index, aber nicht im Arbeitsbaum (gezaehlt, NICHT gelesen).\n";
    text += "-----------------------------------------------------------------------------\n";

    if (status == WacheStatus::Riss) {
        text += NAME + ": FAILED -- " + std::to_string(risse.size()) + " von " + std::to_string(nenner) +
                " getrackten XML-Dateien sind nicht wohlgeformt.\n";
    } else {
        text += NAME + ": OK (" + std::to_string(nenner) + " XML-Dateien geprueft, alle wohlgeformt).\n";
    }
    return text;
}

}  // namespace comdare::ci_wachen
