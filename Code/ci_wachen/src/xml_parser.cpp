// xml_parser.cpp -- xmllint hinter der Naht (Begruendung im Kopf von xml_parser.hpp).
// ASCII-only, Zeilen <= 120 Byte.

#include "comdare/ci_wachen/xml_parser.hpp"

#include "comdare/ci_wachen/prozess.hpp"

namespace comdare::ci_wachen {
namespace {

// Zerlegt die Parser-Ausgabe in Zeilen. KEIN grep, KEIN awk, KEIN sed: die abgeloeste
// Wache rief /usr/bin/grep im Orakel-Pfad, und genau dort schlugen am 09.08. die
// Werkzeug-Shims zu (od-Shim mit leerer Ausgabe -> 12/12 gruen, tr-Shim mit rc=127 ->
// 5/5 "gefangen"). Ein Textwerkzeug, das es nicht mehr gibt, kann nicht mehr luegen.
std::vector<std::string> in_zeilen(const std::string& text) {
    std::vector<std::string> zeilen;
    std::string              aktuell;
    for (const char c : text) {
        if (c == '\n') {
            if (!aktuell.empty()) zeilen.push_back(aktuell);
            aktuell.clear();
        } else if (c != '\r') {
            aktuell.push_back(c);
        }
    }
    if (!aktuell.empty()) zeilen.push_back(aktuell);
    return zeilen;
}

} // namespace

std::string XmllintParser::bezeichnung() const { return "xmllint --noout --nonet"; }

XmlUrteil XmllintParser::pruefe(const std::filesystem::path& datei) const {
    ProzessAuftrag auftrag;
    auftrag.argv = {"xmllint", "--noout", "--nonet", datei.string()};

    const ProzessAusgang ausgang = fuehre_aus(auftrag);

    XmlUrteil                urteil;
    const std::optional<int> code = exit_code(ausgang);
    if (!code.has_value()) {
        // DER ENTSCHEIDENDE ZWEIG. Fehlt xmllint, endet es NICHT mit 127 -- es laeuft
        // gar nicht, und die Selbst-Pipe meldet ENOENT. Damit kann ein Werkzeug-Ausfall
        // hier keinem Dokument-Urteil gleichen; er ist eine eigene Art.
        urteil.art               = XmlUrteilArt::ParserNichtVerfuegbar;
        urteil.werkzeug_diagnose = ausgang.beschreibung();
        return urteil;
    }

    urteil.meldungen = in_zeilen(ausgang.fehler);
    if (*code != 0) {
        urteil.art = XmlUrteilArt::ParserFehler;
        return urteil;
    }
    if (!urteil.meldungen.empty()) {
        // Gemessen: Namensraum-Fehler liefern rc=0 UND 89 Byte stderr. Wer nur den
        // Rueckgabewert liest, laesst diese Klasse gruen durch (FALSE-GREEN).
        urteil.art = XmlUrteilArt::DiagnoseTrotzErfolg;
        return urteil;
    }
    urteil.art = XmlUrteilArt::Wohlgeformt;
    return urteil;
}

} // namespace comdare::ci_wachen
