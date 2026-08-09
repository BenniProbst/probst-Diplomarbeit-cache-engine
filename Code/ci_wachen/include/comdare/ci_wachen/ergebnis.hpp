// ergebnis.hpp -- der gemeinsame ERGEBNISTYP aller CI-Wachen.             (2026-08-09)
//
// DIE WURZEL ALLER FUENF AM 09.08. GEMESSENEN DEFEKTE WAR DIE rc-DOMAENE.
// Die abgeloeste Shell-Wache presste SIEBEN Ausstiege in DREI Exit-Codes (0/1/2).
// Das erzwang zwei Uebel, die beide am Objekt zuschnappten:
//
//  (a) ZWEIGE KOLLIDIERTEN. Bei der Paritaets-Wache liefern "ein Gitlink fehlt" und
//      "die beiden Zeiger divergieren" BEIDE rc=1. Ein Mutant ohne den fail-closed-Zweig
//      fiel deshalb eine Handvoll Zeilen spaeter im Divergenz-Zweig -- mit demselben rc.
//      Die abgeloeste Probe brauchte 28 Kopfzeilen Messprotokoll allein fuer diese
//      Kollision und einen einzigen Fall (F6, "BEIDE fehlen"), der den Mutanten ueberhaupt
//      toeten konnte. HIER SIND FehlenderGitlink UND Divergenz ZWEI WERTE: die Kollision
//      ist nicht "besser getestet", sie ist NICHT MEHR FORMULIERBAR.
//
//  (b) DAS ORAKEL MUSSTE rc RATEN. "alles ausser 0 und 2 ist ein Biss" liess einen
//      Werkzeug-Ausfall mit 127 als Erfolg durchgehen. Ein Wert traegt hier seine
//      Bedeutung selbst; ein Werkzeug-Ausfall ist gar kein WacheStatus, sondern faellt
//      in die Prozess-Naht (prozess.hpp) und wird zu Abbruch -- nie zu Gruen, nie zu Riss.
//
// DER CLI-VERTRAG DER AUFRUFSTELLEN BLEIBT BYTE-VERTRAEGLICH: Gruen->0, Riss->1,
// Abbruch->2. Nur die INNERE Domaene ist reicher geworden. .gitlab-ci.yml muss dafuer
// nichts wissen.
//
// ASCII-only, Zeilen <= 120 Byte.

#ifndef COMDARE_CI_WACHEN_ERGEBNIS_HPP
#define COMDARE_CI_WACHEN_ERGEBNIS_HPP

#include <ostream>
#include <string>

namespace comdare::ci_wachen {

enum class WacheStatus {
    Gruen,   // die Zusicherung haelt              -> Exit 0
    Riss,    // die Zusicherung ist VERLETZT       -> Exit 1
    Abbruch, // die Wache konnte nicht pruefen     -> Exit 2 (ausdruecklich KEIN Gruen)
};

// Die einzige Stelle, an der aus einem Status wieder eine Zahl wird. Sie steht hier und
// nicht in den beiden main()-Dateien, damit die zwei Wrapper nicht auseinanderlaufen
// koennen -- eine Abschrift ist eine Gelegenheit zur Divergenz.
constexpr int exit_code_von(WacheStatus status) {
    switch (status) {
        case WacheStatus::Gruen: return 0;
        case WacheStatus::Riss: return 1;
        case WacheStatus::Abbruch: return 2;
    }
    return 2; // fail-closed: ein unbekannter Status ist ein Abbruch, nie ein Gruen
}

std::string status_text(WacheStatus status);

// Damit ein fehlgeschlagenes EXPECT_EQ den NAMEN druckt und nicht eine nackte Zahl.
// Eine Zahl ohne Bedeutung war der Defekt, den dieses Modul ersetzt -- er darf auch in
// der Fehlermeldung nicht zurueckkommen.
inline std::ostream& operator<<(std::ostream& strom, WacheStatus status) { return strom << status_text(status); }

// Vollstaendigkeits-Tabelle (T-4/Stufe 1). Der static_assert reisst, sobald jemand einen
// vierten Status einfuehrt, ohne die Fall-Tabellen der Tests nachzuziehen.
inline constexpr WacheStatus alle_wache_status[] = {
    WacheStatus::Gruen,
    WacheStatus::Riss,
    WacheStatus::Abbruch,
};
static_assert(sizeof(alle_wache_status) / sizeof(alle_wache_status[0]) == 3,
              "WacheStatus hat einen neuen Wert -- alle_wache_status und die Fall-Tabellen nachziehen.");

// Die drei Codes sind der CI-Vertrag. Sie hier compile-hart zu binden verhindert, dass
// eine spaetere Umnummerierung die Aufrufstellen in .gitlab-ci.yml still umdeutet.
static_assert(exit_code_von(WacheStatus::Gruen) == 0, "CI-Vertrag: Gruen ist Exit 0.");
static_assert(exit_code_von(WacheStatus::Riss) == 1, "CI-Vertrag: Riss ist Exit 1.");
static_assert(exit_code_von(WacheStatus::Abbruch) == 2, "CI-Vertrag: Abbruch ist Exit 2.");

} // namespace comdare::ci_wachen

#endif // COMDARE_CI_WACHEN_ERGEBNIS_HPP
