// audit_probe_e07.cpp -- AUDIT-Runde-1-Bissprobe (trigfix @ 0f900dcf), gtest-frei.
// Prueft den ausgelieferten Pruefer e07_gate_kriterien.hpp unabhaengig vom Strang:
//   P1 GRUEN-Seite: konsistentes 23-Zeilen-Protokoll => GO, 10/10, 23/23, 0 Befunde.
//   P2 Entfernungs-Probe: JEDES der 23 Literale einzeln entfernt => NO-GO (23/23 beissen).
//   P3 Leeres Protokoll => NO-GO, 0/23 literal in der Ausgabe.
//   P4 Echo-Gruen-Sperre: Verdikt als Eingabe => NO-GO.
//   P5 Flag-Wertebereich: E07_WINDOW_SUBSET=2 => NO-GO.
//   P6 Delta-0-Ungueltigkeit: ORGAN_DELTA==TREE_COUNT => NO-GO mit UNGUELTIG-Befund.
#include <profile_facade/e07_gate_kriterien.hpp>

#include <cstdio>
#include <string>

namespace e07 = comdare::cache_engine::e07;

static std::string gruen() {
    return "E07_TREE_COUNT=6\nE07_PLAN_PERMS=6\nE07_BUILT_COUNT=6\n"
           "E07_ID_ROUNDTRIP_MISMATCH=0\n"
           "E07_ORGAN_DELTA_EXPECTED=4\nE07_ORGAN_DELTA_ACTUAL=4\nE07_REMOVED_VALUE_HITS=0\n"
           "E07_SYS_CELLS_BEFORE=4\nE07_SYS_CELLS_AFTER=3\nE07_BINARY_ID_SET_CHANGED=0\n"
           "E07_MEASURE_PASSES_BEFORE=2\nE07_MEASURE_PASSES_AFTER=1\n"
           "E07_WINDOW_COUNT=6\nE07_WINDOW_FIRST_ID_MATCH=1\nE07_WINDOW_LAST_ID_MATCH=1\n"
           "E07_PROGRESS_CURSOR_MAX=5\nE07_PROGRESS_DONE_COUNT=1\n"
           "E07_PLAN_BYTE_EQUAL=1\nE07_RERUN_ID_SET_EQUAL=1\n"
           "E07_BYPASS_FINDINGS=0\nE07_STALE_ID_MEASURED=0\n"
           "E07_WINDOW_SUBSET=1\nE07_WINDOW_NEW_IDS=0\n";
}

static std::string ohne_zeile(std::string const& proto, std::string const& key) {
    std::string out;
    std::size_t pos = 0;
    while (pos < proto.size()) {
        std::size_t const nl    = proto.find('\n', pos);
        std::string const zeile = proto.substr(pos, nl - pos);
        pos                     = nl + 1;
        if (zeile.rfind(key + "=", 0) != 0) out += zeile + "\n";
    }
    return out;
}

int main() {
    int fehler = 0;

    auto const g = e07::e07_gate_auswerten(gruen());
    std::printf("P1 GRUEN: go=%d kriterien=%d/10 literale=%d/23 befunde=%zu\n", g.go ? 1 : 0, g.kriterien_erfuellt,
                g.literale_vorhanden, g.befunde.size());
    if (!(g.go && g.kriterien_erfuellt == 10 && g.literale_vorhanden == 23 && g.befunde.empty())) ++fehler;

    int beisser = 0;
    for (auto const key : e07::kPflichtLiterale) {
        auto const r = e07::e07_gate_auswerten(ohne_zeile(gruen(), std::string(key)));
        if (!r.go) ++beisser;
    }
    std::printf("P2 ENTFERNUNG: %d/23 Einzelentfernungen ergeben NO-GO\n", beisser);
    if (beisser != 23) ++fehler;

    auto const leer = e07::e07_gate_auswerten("");
    bool const p3   = !leer.go && leer.protokoll().find("E07_GATE_PFLICHT_LITERALE=0/23") != std::string::npos;
    std::printf("P3 LEER: go=%d nenner_0_23_in_ausgabe=%d\n", leer.go ? 1 : 0, p3 ? 1 : 0);
    if (!p3) ++fehler;

    auto const echo = e07::e07_gate_auswerten(g.protokoll());
    std::printf("P4 ECHO: go=%d (muss 0 sein)\n", echo.go ? 1 : 0);
    if (echo.go) ++fehler;

    auto const flag = e07::e07_gate_auswerten(ohne_zeile(gruen(), "E07_WINDOW_SUBSET") + "E07_WINDOW_SUBSET=2\n");
    std::printf("P5 FLAG=2: go=%d (muss 0 sein)\n", flag.go ? 1 : 0);
    if (flag.go) ++fehler;

    auto d0 = ohne_zeile(ohne_zeile(gruen(), "E07_ORGAN_DELTA_EXPECTED"), "E07_ORGAN_DELTA_ACTUAL");
    d0 += "E07_ORGAN_DELTA_EXPECTED=6\nE07_ORGAN_DELTA_ACTUAL=6\n";
    auto const delta0 = e07::e07_gate_auswerten(d0);
    bool ungueltig    = false;
    for (auto const& b : delta0.befunde)
        if (b.find("UNGUELTIG") != std::string::npos) ungueltig = true;
    std::printf("P6 DELTA-0: go=%d ungueltig_befund=%d\n", delta0.go ? 1 : 0, ungueltig ? 1 : 0);
    if (delta0.go || !ungueltig) ++fehler;

    std::printf("AUDIT-PROBE-ERGEBNIS: %s (fehler=%d)\n", fehler == 0 ? "ALLE OK" : "ROT", fehler);
    return fehler == 0 ? 0 : 1;
}
