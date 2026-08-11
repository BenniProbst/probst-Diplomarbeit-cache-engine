// wide_aggregat.cpp -- Umsetzung. Begruendung vollstaendig im Kopf des Headers.
//                                                                        (2026-08-10)
// DIE SATZ-DEFINITION IST DIE GANZE FEINHEIT DIESER DATEI und muss zu `awk 1` passen:
//   * ein Datensatz endet an '\n' ODER am Dateiende;
//   * eine Datei aus 0 Byte hat 0 Datensaetze;
//   * eine Datei "a\nb" (ohne Schluss-Newline) hat ZWEI Datensaetze, und beide werden
//     MIT Zeilenende ausgegeben -- genau das heilt F3.
// Wer das aendert, aendert die Zahlen der ganzen Mess-Kette.
//
// ASCII-only, Zeilen <= 120 Byte.

#include "comdare/ci_wachen/wide_aggregat.hpp"

#include <cstdio>
#include <fstream>
#include <sstream>
#include <system_error>

namespace comdare::ci_wachen {
namespace {

// Liest eine Datei VOLLSTAENDIG und binaer. nullopt heisst "nicht lesbar" -- und das ist
// etwas anderes als "leer". Die beiden zu vermengen war der Defekt F5.
std::optional<std::string> lies_ganz(const std::filesystem::path& datei) {
    std::error_code fehler;
    // Nur regulaere Dateien (Symlinks werden verfolgt). Ein Verzeichnis oder eine FIFO
    // ist hier NICHT lesbar -- fail-closed, nie "0 Datensaetze".
    if (!std::filesystem::is_regular_file(datei, fehler) || fehler) { return std::nullopt; }
    std::ifstream strom(datei, std::ios::binary);
    if (!strom) { return std::nullopt; }
    std::ostringstream puffer;
    puffer << strom.rdbuf();
    if (strom.bad()) { return std::nullopt; }
    return puffer.str();
}

// Zerlegt in Datensaetze nach der awk-Regel (s. Dateikopf).
std::vector<std::string> in_saetze(const std::string& inhalt) {
    std::vector<std::string> saetze;
    std::string              lauf;
    for (const char zeichen : inhalt) {
        if (zeichen == '\n') {
            saetze.push_back(lauf);
            lauf.clear();
        } else {
            lauf.push_back(zeichen);
        }
    }
    if (!lauf.empty()) { // letzter Satz ohne Schluss-Newline -- er zaehlt (F2/F3)
        saetze.push_back(lauf);
    }
    return saetze;
}

// Zeilen der Listendatei. Leere Zeilen fallen heraus (wie `[ -n "$rcsv" ] || continue`).
std::vector<std::string> listen_eintraege(const std::string& inhalt) {
    std::vector<std::string> eintraege;
    for (std::string& satz : in_saetze(inhalt)) {
        if (!satz.empty()) { eintraege.push_back(satz); }
    }
    return eintraege;
}

} // namespace

std::string quell_befund_text(QuellBefund befund) {
    switch (befund) {
        case QuellBefund::MitDaten: return "MitDaten";
        case QuellBefund::OhneDaten: return "OhneDaten";
        case QuellBefund::NichtLesbar: return "NichtLesbar";
    }
    return "UnbekannterQuellBefund";
}

std::string aggregat_abbruch_text(AggregatAbbruchGrund grund) {
    switch (grund) {
        case AggregatAbbruchGrund::ListeFehlt: return "ListeFehlt";
        case AggregatAbbruchGrund::ZielNichtSchreibbar: return "ZielNichtSchreibbar";
        case AggregatAbbruchGrund::QuelleNichtLesbar: return "QuelleNichtLesbar";
        case AggregatAbbruchGrund::NennerVerletzt: return "NennerVerletzt";
    }
    return "UnbekannterAbbruchGrund";
}

std::string WideErgebnis::kennzahlen() const {
    std::ostringstream aus;
    aus << "WIDE_ZEILEN=" << zeilen << '\n'
        << "WIDE_DATEN=" << daten << '\n'
        << "WIDE_HEADER=" << (header ? "ja" : "nein") << '\n'
        << "WIDE_QUELLEN=" << quellen << '\n'
        << "WIDE_MIT_DATEN=" << mit_daten << '\n'
        << "WIDE_OHNE_DATEN=" << ohne_daten << '\n'
        << "WIDE_FEHLEND=" << nicht_lesbar << '\n';
    return aus.str();
}

std::string WideErgebnis::protokoll() const {
    std::ostringstream aus;
    aus << "WIDE-Aggregat: " << zeilen << " Zeilen (header=" << (header ? "ja" : "nein")
        << ", davon Datenzeilen=" << daten << "), Zaehlweise awk NR\n";
    // DER NENNER GEHOERT IN DIE AUSGABE, nicht nur in den Rueckgabewert: ein Job-Log ohne
    // ihn laesst "0 Datenzeilen" und "0 Quellen" gleich aussehen.
    aus << "WIDE-Nenner: " << quellen << " Quelle(n) gelistet -- " << mit_daten << " mit Daten, " << ohne_daten
        << " ohne Daten, " << nicht_lesbar << " nicht lesbar\n";
    if (abbruch.has_value()) {
        aus << "ABBRUCH: " << aggregat_abbruch_text(*abbruch);
        if (!abbruch_detail.empty()) { aus << " -- " << abbruch_detail; }
        aus << '\n';
    }
    return aus.str();
}

WideErgebnis aggregiere(const std::filesystem::path& liste, const std::filesystem::path& ziel_wide) {
    WideErgebnis ergebnis;

    const std::optional<std::string> listen_inhalt = lies_ganz(liste);
    if (!listen_inhalt.has_value()) {
        ergebnis.status         = WacheStatus::Abbruch;
        ergebnis.abbruch        = AggregatAbbruchGrund::ListeFehlt;
        ergebnis.abbruch_detail = liste.string();
        return ergebnis;
    }

    const std::vector<std::string> eintraege = listen_eintraege(*listen_inhalt);
    ergebnis.quellen                         = static_cast<std::int64_t>(eintraege.size());

    // Das Ziel wird angelegt/geleert -- auch dann, wenn die Liste leer ist. Ein altes
    // Aggregat, das stehen bleibt, waere von einem frischen nicht zu unterscheiden.
    std::ofstream ziel(ziel_wide, std::ios::binary | std::ios::trunc);
    if (!ziel) {
        ergebnis.status         = WacheStatus::Abbruch;
        ergebnis.abbruch        = AggregatAbbruchGrund::ZielNichtSchreibbar;
        ergebnis.abbruch_detail = ziel_wide.string();
        return ergebnis;
    }

    std::string erste_unlesbare;
    for (const std::string& eintrag : eintraege) {
        QuellErgebnis quelle;
        quelle.pfad = eintrag;

        const std::optional<std::string> inhalt = lies_ganz(eintrag);
        if (!inhalt.has_value()) {
            quelle.befund = QuellBefund::NichtLesbar; // F5 -- frueher still verschwunden
            ergebnis.nicht_lesbar += 1;
            if (erste_unlesbare.empty()) { erste_unlesbare = eintrag; }
            ergebnis.je_quelle.push_back(quelle);
            continue;
        }

        const std::vector<std::string> saetze = in_saetze(*inhalt);

        // F4: die Kopfzeile darf NUR von einer Datei mit Groesse > 0 kommen. Eine
        // 0-Byte-Datei hat null Datensaetze und darf den Header nicht "stellen".
        // 'saetze nicht leer' ist dasselbe Kriterium wie '[ -s "$rcsv" ]' der
        // Shell-Fassung (jeder Inhalt > 0 Byte ergibt mindestens einen Datensatz) --
        // und es ist zugleich die Bedingung, unter der front() ueberhaupt definiert ist.
        if (!ergebnis.header && !saetze.empty()) {
            ziel << saetze.front() << '\n'; // F3: immer MIT Zeilenende
            ergebnis.header = true;
        }

        std::int64_t beigetragen = 0;
        for (std::size_t i = 1; i < saetze.size(); ++i) {
            ziel << saetze[i] << '\n'; // F3
            beigetragen += 1;
        }

        quelle.datensaetze = beigetragen;
        quelle.befund      = (beigetragen > 0) ? QuellBefund::MitDaten : QuellBefund::OhneDaten;
        if (beigetragen > 0) {
            ergebnis.mit_daten += 1;
        } else {
            ergebnis.ohne_daten += 1;
        }
        ergebnis.je_quelle.push_back(quelle);
        ergebnis.daten += beigetragen;
    }

    ziel.flush();
    if (!ziel) {
        ergebnis.status         = WacheStatus::Abbruch;
        ergebnis.abbruch        = AggregatAbbruchGrund::ZielNichtSchreibbar;
        ergebnis.abbruch_detail = ziel_wide.string();
        return ergebnis;
    }
    ziel.close();

    // WIDE_ZEILEN ist die Zahl der Datensaetze IM AGGREGAT. Sie wird hier gerechnet und
    // nicht nachgezaehlt: das Aggregat endet konstruktionsbedingt auf ein Zeilenende,
    // also gilt zeilen == daten + (header ? 1 : 0). Der Test rechnet sie unabhaengig
    // aus der geschriebenen Datei nach -- V-7: zwei Quellen, nicht eine.
    ergebnis.zeilen = ergebnis.daten + (ergebnis.header ? 1 : 0);
    // Der ALTE Vertrag: ohne Kopfzeile werden 0 Datenzeilen gemeldet. Das ist keine
    // Rundung, sondern die Aussage "ein kopfloses Aggregat ist nicht auswertbar".
    if (!ergebnis.header) { ergebnis.daten = 0; }

    if (!ergebnis.nenner_haelt()) {
        ergebnis.status         = WacheStatus::Abbruch;
        ergebnis.abbruch        = AggregatAbbruchGrund::NennerVerletzt;
        ergebnis.abbruch_detail = "quellen != mit_daten + ohne_daten + nicht_lesbar";
        return ergebnis;
    }

    if (ergebnis.nicht_lesbar > 0) {
        // FAIL-CLOSED: das Aggregat bildet die Liste NICHT vollstaendig ab. Eine Zahl,
        // die eine unvollstaendige Grundgesamtheit verschweigt, ist schlimmer als keine.
        ergebnis.status         = WacheStatus::Abbruch;
        ergebnis.abbruch        = AggregatAbbruchGrund::QuelleNichtLesbar;
        ergebnis.abbruch_detail = erste_unlesbare;
        return ergebnis;
    }

    ergebnis.status = WacheStatus::Gruen;
    return ergebnis;
}

} // namespace comdare::ci_wachen
