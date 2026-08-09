// gitlink_parity.cpp -- Umsetzung (Begruendung im Kopf von gitlink_parity.hpp).
// ASCII-only, Zeilen <= 120 Byte.

#include "comdare/ci_wachen/gitlink_parity.hpp"

namespace comdare::ci_wachen {

std::string riss_text(ParityRissArt art) {
    switch (art) {
        case ParityRissArt::GitlinkFehlt:     return "GitlinkFehlt";
        case ParityRissArt::Divergenz:        return "Divergenz";
        case ParityRissArt::ErwartetVerfehlt: return "ErwartetVerfehlt";
    }
    return "UNBEKANNT";
}

std::string abbruch_text(ParityAbbruchGrund grund) {
    switch (grund) {
        case ParityAbbruchGrund::KeinRepo:          return "KeinRepo";
        case ParityAbbruchGrund::GitFehlgeschlagen: return "GitFehlgeschlagen";
        case ParityAbbruchGrund::Bedienfehler:      return "Bedienfehler";
    }
    return "UNBEKANNT";
}

std::string hilfe_text() {
    std::string text;
    text += "Aufruf: ci_thesis_gitlink_wache [--quelle head|index] [--erwartet <sha40>]\n";
    text += "  --quelle head   (Vorgabe) liest die Gitlinks aus dem HEAD-Tree\n";
    text += "  --quelle index  liest die Gitlinks aus dem Staging-Index (nach update-index)\n";
    text += "  --erwartet SHA  verlangt zusaetzlich, dass beide auf genau SHA stehen\n";
    return text;
}

ParityArgumente parse_parity_argumente(const std::vector<std::string>& argumente) {
    ParityArgumente ergebnis;
    for (std::size_t i = 0; i < argumente.size(); ++i) {
        const std::string& arg = argumente[i];
        if (arg == "--quelle") {
            if (i + 1 >= argumente.size()) {
                ergebnis.fehler = "FEHLER: --quelle ohne Wert";
                return ergebnis;
            }
            const std::string& wert = argumente[++i];
            if (wert == "head") {
                ergebnis.quelle = GitlinkQuelle::Head;
            } else if (wert == "index") {
                ergebnis.quelle = GitlinkQuelle::Index;
            } else {
                ergebnis.fehler = "FEHLER: --quelle muss 'head' oder 'index' sein, war '" + wert + "'";
                return ergebnis;
            }
        } else if (arg == "--erwartet") {
            if (i + 1 >= argumente.size()) {
                ergebnis.fehler = "FEHLER: --erwartet ohne Wert";
                return ergebnis;
            }
            ergebnis.erwartet = argumente[++i];
        } else if (arg == "-h" || arg == "--hilfe" || arg == "--help") {
            ergebnis.hilfe_gewuenscht = true;
            ergebnis.ok = true;
            return ergebnis;
        } else {
            ergebnis.fehler = "FEHLER: unbekannte Option '" + arg + "'";
            return ergebnis;
        }
    }
    ergebnis.ok = true;
    return ergebnis;
}

ParityErgebnis pruefe_gitlink_paritaet(const GitQuelle& git, GitlinkQuelle quelle,
                                       const std::string& erwartet) {
    ParityErgebnis ergebnis;
    ergebnis.quelle = quelle;
    ergebnis.erwartet = erwartet;

    if (!git.ist_arbeitsbaum()) {
        ergebnis.status = WacheStatus::Abbruch;
        ergebnis.abbruch = ParityAbbruchGrund::KeinRepo;
        return ergebnis;
    }

    const GitlinkAntwort a = git.gitlink(PFAD_LEBEND, quelle);
    const GitlinkAntwort b = git.gitlink(PFAD_TOT, quelle);
    ergebnis.nenner = 2;  // der Nenner steht IMMER dabei, auch wenn er konstant ist

    if (!a.werkzeug_ok || !b.werkzeug_ok) {
        // git-Fehler sind fatal, nie eine stille Null. In der Shell-Fassung hing das an
        // der Abwesenheit eines `|| true`; hier ist es ein eigener Zustand.
        ergebnis.status = WacheStatus::Abbruch;
        ergebnis.abbruch = ParityAbbruchGrund::GitFehlgeschlagen;
        ergebnis.abbruch_detail = a.werkzeug_ok ? b.diagnose : a.diagnose;
        return ergebnis;
    }

    ergebnis.sha_lebend = a.ist_gitlink() ? a.objekt : std::string();
    ergebnis.sha_tot = b.ist_gitlink() ? b.objekt : std::string();

    // FAIL-CLOSED IST DER KERN: ein fehlender Pfad ist ein FEHLER, kein Freifahrtschein.
    // Waere er einer, koennte jede Umbenennung eines der beiden Gitlinks die Wache still
    // entwaffnen -- genau die Klasse "stille Null", gegen die hier gebaut wird.
    if (!a.ist_gitlink()) ergebnis.fehlende_pfade.emplace_back(PFAD_LEBEND);
    if (!b.ist_gitlink()) ergebnis.fehlende_pfade.emplace_back(PFAD_TOT);
    if (!ergebnis.fehlende_pfade.empty()) {
        ergebnis.status = WacheStatus::Riss;
        ergebnis.riss = ParityRissArt::GitlinkFehlt;
        return ergebnis;
    }

    if (ergebnis.sha_lebend != ergebnis.sha_tot) {
        ergebnis.status = WacheStatus::Riss;
        ergebnis.riss = ParityRissArt::Divergenz;
        return ergebnis;
    }

    if (!erwartet.empty() && ergebnis.sha_lebend != erwartet) {
        ergebnis.status = WacheStatus::Riss;
        ergebnis.riss = ParityRissArt::ErwartetVerfehlt;
        return ergebnis;
    }

    ergebnis.status = WacheStatus::Gruen;
    return ergebnis;
}

std::string ParityErgebnis::protokoll() const {
    const std::string q = quelle_text(quelle);
    std::string text;

    if (abbruch.has_value()) {
        switch (*abbruch) {
            case ParityAbbruchGrund::KeinRepo:
                text += "FEHLER: kein git-Repository\n";
                break;
            case ParityAbbruchGrund::GitFehlgeschlagen:
                text += "FEHLER: git hat die Gitlink-Abfrage nicht beantwortet (Quelle '" + q + "').\n";
                break;
            case ParityAbbruchGrund::Bedienfehler:
                text += "FEHLER: Bedienfehler\n";
                break;
        }
        if (!abbruch_detail.empty()) text += "  Diagnose: " + abbruch_detail + "\n";
        text += "NENNER: " + std::to_string(nenner) + " Gitlink-Pfade vorgesehen, 0 beurteilt.\n";
        return text;
    }

    if (riss.has_value()) {
        switch (*riss) {
            case ParityRissArt::GitlinkFehlt:
                for (const std::string& pfad : fehlende_pfade) {
                    text += "FEHLER (Thesis-Doppelbindung): Gitlink FEHLT in Quelle '" + q + "': " + pfad + "\n";
                }
                text += "  fail-closed: ein fehlender Gitlink-Pfad ist ein FEHLER, kein Freifahrtschein.\n";
                text += "  Beide Einbindungen stehen in .gitmodules (thesis/diplomarbeit + Code/external/...).\n";
                break;
            case ParityRissArt::Divergenz:
                // DIE QUELLE STEHT MIT DABEI. Sie fehlte in der abgeloesten Shell-Fassung
                // an genau dieser Stelle (Zeilen 130-136) -- und nur hier: alle anderen
                // Zweige nannten ihren Lesepfad. Ein Divergenz-Befund ohne Lesepfad ist
                // nicht nachstellbar: head und index koennen verschieden urteilen, das ist
                // der ganze Grund fuer zwei Aufrufstellen. Gefunden vom eigenen Test
                // (ParityFallTest.Fall/F03_divergenz_*), nicht durch Nachlesen.
                text += "FEHLER (Thesis-Doppelbindung, Quelle '" + q +
                        "'): die beiden Gitlinks DESSELBEN Repos divergieren:\n";
                text += std::string("  ") + PFAD_LEBEND + " = " + sha_lebend + "\n";
                text += std::string("  ") + PFAD_TOT + " = " + sha_tot + "\n";
                text += "  -> beide Zeiger IMMER GEMEINSAM setzen (Begruendung im .gitmodules-Kopf).\n";
                break;
            case ParityRissArt::ErwartetVerfehlt:
                text += "FEHLER (Thesis-Doppelbindung): beide Gitlinks stehen auf " + sha_lebend + ",\n";
                text += "  erwartet war aber " + erwartet + " (Quelle '" + q + "').\n";
                break;
        }
        text += "NENNER: " + std::to_string(nenner) + " Gitlink-Pfade geprueft, " +
                std::to_string(fehlende_pfade.size()) + " fehlend, Riss: " + riss_text(*riss) + ".\n";
        return text;
    }

    text += "Thesis-Gitlink-Paritaet OK (Quelle '" + q + "'): beide Zeiger auf " + sha_lebend + "\n";
    text += "NENNER: " + std::to_string(nenner) + " Gitlink-Pfade geprueft, 0 fehlend, 0 divergent.\n";
    return text;
}

}  // namespace comdare::ci_wachen
