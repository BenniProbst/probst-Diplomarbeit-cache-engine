# fixture_sync_check.cmake — WP-4/F33+F66 (Voll-Audit 2026-07-16): super-seitiges Fixture-Sync-Gate.
#
# PROBLEM: die ce-Test-Fixtures tests/unit/thesis_tiere/{experiment_golden.xml, prt_art_axis_registry.xml}
# sind KOPIEN (Layering-Doktrin: ce darf prt-art nicht konsumieren; Golden-Instanz doppelt super/ce ohne
# entschiedene Kanonizitaet, F27 user-gated) — ohne Sync-Gate testete ce nach einer Master-Aenderung still
# gegen einen stalen Stand (Phantom-Fixture, honest-100%-Beruehrung). Das super-Repo konsumiert BEIDE
# Submodule -> hier ist der layering-saubere Ort fuer den Byte-Vergleich (Befund-Fixes F33/F66).
#
# UEBERGANG bis E7-Single-Source (Bruecke I7): User-E7 will langfristig EINE Quelle statt Kopien; dieses
# Gate ist die Uebergangs-Sicherung, bis die Single-Source-Struktur steht — danach ersatzlos abloesbar.
#
# STAND-NACHZUG 2026-08-06 (#48-SCHEIBE-6, B14; loest den Ledger-Posten zu Zeile 3 dieser Datei):
# Die oben genannte experiment_golden.xml ist seit dem 27.07. NICHT mehr die kanonische golden -- das ist
# experiment_golden_kern.xml (comdare_experiment v2). Dieses Byte-Gate bleibt trotzdem in Kraft, weil das
# Alt-Paar weiter produktiv ist: 02_messung_driver/CMakeLists.txt setzt COMDARE_V32_EXPERIMENT_GOLDEN_XML
# real auf experiment_golden.xml, der Antriebs-Test faehrt also nach wie vor darueber.
# Das Neu-Paar bekommt KEIN Byte-Gate, sondern eine eigene Vokabular-Wache
# (tests/fixture_schema_subset_check.cmake, ctest test_fixture_schema_experiment_golden_kern): die
# ce-Datei gleichen Namens ist eine eigenstaendige Naht-Fixture mit absichtlich abweichenden Werten,
# ein Byte-Vergleich wuerde test_experiment_kern_seam.cpp sofort rot schiessen. Die Begruendung und die
# offene ce-Umbenennungs-Auflage stehen im Kopf jener Datei.
#
# MECHANIK: KOPIE == MASTER byte-genau, NACH Ausblendung des markierten FIXTURE-PROVENIENZ-Kommentar-
# Blocks in der Kopie (der Block dokumentiert Herkunft+Sync-Pflicht IN der Kopie und existiert im Master
# bewusst nicht). Fehlt ein Nachbar-Checkout (Submodule nicht ausgecheckt), wird sauber GESKIPPT
# (Ausgabe-Marker FIXTURE-SYNC-SKIP + ctest-Property SKIP_REGULAR_EXPRESSION), NIE stumm-gruen.
#
# Erwartete -D Variablen: MASTER (Referenz-Datei), KOPIE (Fixture-Kopie mit optionalem Provenienz-Block).

foreach(_req MASTER KOPIE)
    if(NOT DEFINED ${_req})
        message(FATAL_ERROR "fixture_sync_check: -D${_req} fehlt.")
    endif()
endforeach()

if(NOT EXISTS "${MASTER}" OR NOT EXISTS "${KOPIE}")
    # Sauberer SKIP (kein Fehler, kein Stumm-Gruen): Nachbar-Checkout fehlt (z.B. Submodule nicht
    # initialisiert). Nur die zweite Zeile matcht die SKIP_REGULAR_EXPRESSION des add_test-Aufrufs.
    # B14-NB4 / Befund B4: der Marker steht allein auf seiner Zeile und enthaelt KEINE Interpolation.
    # Vorher standen Marker und Pfade in EINER Zeile und die ctest-Property matchte das Teilwort
    # "FIXTURE-SYNC-SKIP" irgendwo in der Ausgabe -- jeder FATAL, der diese Zeichenfolge mitfuehrt
    # (etwa weil sie im Dateiinhalt oder in einem Pfad steht), waere als SKIP statt als FAIL
    # klassifiziert worden.
    message(STATUS "Nachbar-Checkout fehlt (MASTER='${MASTER}' KOPIE='${KOPIE}') -- keine Aussage moeglich.")
    message(STATUS "COMDARE-XML-WACHE-SKIP")
    return()
endif()

file(READ "${MASTER}" _master)
file(READ "${KOPIE}" _kopie)

# Markierten Provenienz-Block aus der KOPIE ausblenden (genau EIN Block; inkl. Folge-Newline).
set(_marker "<!-- FIXTURE-PROVENIENZ")
string(FIND "${_kopie}" "${_marker}" _p)
if(NOT _p EQUAL -1)
    string(SUBSTRING "${_kopie}" 0 ${_p} _head)
    string(SUBSTRING "${_kopie}" ${_p} -1 _rest)
    string(FIND "${_rest}" "-->" _e)
    if(_e EQUAL -1)
        message(FATAL_ERROR "fixture_sync_check: FIXTURE-PROVENIENZ-Block in '${KOPIE}' ohne '-->' (kaputt).")
    endif()
    math(EXPR _after "${_e} + 3")
    string(SUBSTRING "${_rest}" ${_after} -1 _tail)
    if(_tail MATCHES "^\n")
        string(SUBSTRING "${_tail}" 1 -1 _tail)
    endif()
    set(_kopie "${_head}${_tail}")
endif()

if(NOT _kopie STREQUAL _master)
    message(FATAL_ERROR
        "fixture_sync_check: DRIFT — Fixture-Kopie != Master (Byte-Vergleich nach Provenienz-Ausblendung).\n"
        "  MASTER: ${MASTER}\n"
        "  KOPIE:  ${KOPIE}\n"
        "Fix: Kopie vom Master nachziehen (bzw. bei bewusster Master-Aenderung beide synchron committen); "
        "der FIXTURE-PROVENIENZ-Block in der Kopie bleibt dabei erhalten.")
endif()
message(STATUS "fixture_sync_check: OK — Kopie byte-identisch zum Master (ohne Provenienz-Block).")
