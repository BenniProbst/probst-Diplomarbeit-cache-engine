# 2c/OP-8 (2026-07-27) - schreibt die EINE kanonische Planer-Rohausgabe
# "comdare-messung-driver plan dump" (Format v1.1) in eine Datei.
#
# Warum ein -P-Skript: add_custom_target/add_custom_command kennen keine portable
# Ausgabe-Umlenkung; execute_process(OUTPUT_FILE) ist der offizielle CMake-Weg.
# Aufrufer: comdare_tier_binary_visibility (Code/CMakeLists.txt), Schritt 1 von 2.
#
# Eingaben (per -D):
#   DUMP_PLAN_DRIVER - Pfad zum comdare-messung-driver
#   DUMP_PLAN_OUT    - Zieldatei der Rohausgabe
#
# Profil OHNE Argument: Fallback-Kette COMDARE_THESIS_PROFILE -> einkompiliertes
# Default-Profil (identisch zum CI-Job visibility:tier-binaries; Pinning = OP-5).
# Der Aufruf ist rein lesend: KEIN DLL-Bau, KEINE Messung.

cmake_minimum_required(VERSION 3.28)

if(NOT DEFINED DUMP_PLAN_DRIVER OR NOT DEFINED DUMP_PLAN_OUT)
    message(FATAL_ERROR "DUMP_PLAN_DRIVER und DUMP_PLAN_OUT muessen gesetzt sein")
endif()

get_filename_component(_dump_plan_dir "${DUMP_PLAN_OUT}" DIRECTORY)
file(MAKE_DIRECTORY "${_dump_plan_dir}")

execute_process(
    COMMAND "${DUMP_PLAN_DRIVER}" plan dump
    OUTPUT_FILE "${DUMP_PLAN_OUT}"
    RESULT_VARIABLE _dump_plan_rc)

if(NOT _dump_plan_rc EQUAL 0)
    message(FATAL_ERROR "plan dump fehlgeschlagen (rc=${_dump_plan_rc}): ${DUMP_PLAN_DRIVER}")
endif()

# Kein Inhalts-Gate hier: die Formatwache sitzt im auswertenden Werkzeug
# (tier-binary-report --visibility, Exit 1 ohne Kopf-Anker) - eine Wahrheit, eine Stelle.
message(STATUS "#279 plan dump -> ${DUMP_PLAN_OUT}")
