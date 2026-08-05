# Diplomarbeit/Code/ — Experiment-Orchestrator + Auswertung-Pipeline
# Anwender-Schicht: ruft prt-art-Submodule + cache-engine-Library auf,
# generiert binary measurement-records → CSV → LaTeX → PDF.
#
# REV 7.6 Architektur-Korrektur 2026-05-13:
# - Diplomarbeit-Code ist Anwender, ruft prt-art + cache-engine auf
# - 3 Messreihen: PRT-ART vs SOTA, cache-engine Permutationen, Merge alt/neu
# - C++23, NO Python (F-EXTRA-5)

cmake_minimum_required(VERSION 3.28)
project(comdare-diplomarbeit-code
        VERSION 0.1.0
        DESCRIPTION "Diplomarbeit-Code: Experiment-Orchestrator + Auswertung"
        LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# V38.A (2026-05-24): C++23 Compiler-Mindestversion erzwingen.
# User-Direktive: "Dazu brauchen wir mindestens compiler der Stufe C++23"
#
# Mindestversionen mit ausreichendem C++23-Support fuer Phase 6 (SHARED-
# Module + dlopen, std::format, ranges, std::expected, deducing this):
#   gcc:   13.0+  (volles std::format, partial std::expected via libstdc++ 13)
#   clang: 16.0+  (volles std::format ab 17, std::expected ab 16)
#   MSVC:  19.34+ (VS 2022 17.4, std::format + std::expected ab MSVC 19.35)
#   apple-clang: 15.0+ (Xcode 15)
#
# V-6iii (Bauplan TEIL V, Ledger 73.4 Q5, 2026-07-27): GNU-Zweig auf den Flotten-FLOOR g++ >= 15.3
# angehoben -- Minimum UND Standard (prod1/prod2 + CI==baremetal-Weg), bewusst KEIN Versions-Pin
# (neuere g++ zugelassen; kein 16er-Pin, P2996 bleibt spaeterer Drop-in, mp11 = Metaprog-Weg).
# Clang/MSVC/AppleClang behalten ihre V38.A-Floors (W2: Floor-Anhebung NUR fuer GNU).
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS 15.3)
    message(FATAL_ERROR "g++ >= 15.3 erforderlich (Toolchain-Floor V-6iii/Ledger 73.4; gefunden: ${CMAKE_CXX_COMPILER_VERSION})")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS 16.0)
    message(FATAL_ERROR "clang >= 16.0 erforderlich fuer C++23 (gefunden: ${CMAKE_CXX_COMPILER_VERSION})")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang" AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS 15.0)
    message(FATAL_ERROR "Apple Clang >= 15.0 erforderlich (gefunden: ${CMAKE_CXX_COMPILER_VERSION})")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC" AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS 19.34)
    message(FATAL_ERROR "MSVC >= 19.34 (VS 2022 17.4+) erforderlich (gefunden: ${CMAKE_CXX_COMPILER_VERSION})")
endif()
message(STATUS "V38.A C++23-Compiler: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION} OK")

# V-6i (Bauplan TEIL V, W1): Standard-Installationslayout fuer die install()-Targets der
# Mess-Auswerte-Kette (02 Treiber + 03/04/05 Auswerte-CLIs; je Modul-CMakeLists).
include(GNUInstallDirs)

# V41.E2 (2026-05-25): Vendor-Lib User-Cache via ccache/sccache.
# Vendor-Libraries (mimalloc-static.c, jemalloc/snmalloc Headers, etc.) werden
# bei jedem clean-Build neu kompiliert (~5s pro perm × 43 perms = ~3min Overhead).
# ccache/sccache cachen Compile-Output user-global -> spaeter clean-Build = instant.
# Aktivierung: cmake compiler-launcher. Installation: 'choco install ccache' oder 'sccache'.
option(COMDARE_USE_COMPILER_CACHE "Aktiviere ccache/sccache wenn verfuegbar (User-Cache fuer Vendor-Libs)" ON)
if(COMDARE_USE_COMPILER_CACHE)
    find_program(COMDARE_CCACHE_EXE NAMES ccache sccache)
    if(COMDARE_CCACHE_EXE)
        set(CMAKE_C_COMPILER_LAUNCHER "${COMDARE_CCACHE_EXE}" CACHE STRING "" FORCE)
        set(CMAKE_CXX_COMPILER_LAUNCHER "${COMDARE_CCACHE_EXE}" CACHE STRING "" FORCE)
        message(STATUS "V41.E2 Compile-Cache aktiviert: ${COMDARE_CCACHE_EXE}")
    else()
        message(STATUS "V41.E2 ccache/sccache nicht gefunden. Vendor-Libs werden pro Build-Tree neu kompiliert.")
        message(STATUS "  Aktivierung: 'choco install ccache' oder 'choco install sccache' (Windows)")
        message(STATUS "  Linux/Mac:   'apt install ccache' / 'brew install ccache'")
    endif()
endif()

option(COMDARE_DA_BUILD_TESTS "Build Diplomarbeit-Code Tests" ON)

# #279 (User 2026-07-06, VORLETZTE Aufgabe): konfigurierbare Mess-Durchfuehrung.
#   debug_sample   - Default. Die E2E-Pipeline (comdare_pipeline_e2e) speist die
#                    PDF aus synthetischen Sample-Daten -> schnell, CI-tauglich.
#   release_measure - Fuehrt VOR der PDF den echten messung_driver-Lauf ueber
#                    experiment_config aus (comdare_pipeline_release). Der schwere
#                    Mess-Lauf (#156, mehrtaegig) bleibt bewusst opt-in/lokal und
#                    wird NICHT in der Standard-CI getriggert.
set(COMDARE_DA_PIPELINE_MODE "debug_sample" CACHE STRING
    "Mess-Durchfuehrung der Pipeline: debug_sample (synthetisch, Default) | release_measure (echter Lauf vor PDF)")
set_property(CACHE COMDARE_DA_PIPELINE_MODE PROPERTY STRINGS debug_sample release_measure)

# V37.G (2026-05-23): Dynamische CPU-Core-Erkennung fuer optimale
# Parallelisierung der Permutations-Builds. User-Direktive:
# "Anzahl verfuegbarer Kerne messen, jedem parallelen Build 2 Threads als
#  Ressource zuteilen. Pipeline moeglichst voll halten." Cross-Platform.
include(ProcessorCount)
ProcessorCount(_comdare_n_cores)
if(_comdare_n_cores EQUAL 0)
    set(_comdare_n_cores 4)  # Fallback wenn nicht detektierbar
endif()
math(EXPR COMDARE_PARALLEL_JOBS "${_comdare_n_cores} / 2")
if(COMDARE_PARALLEL_JOBS LESS 1)
    set(COMDARE_PARALLEL_JOBS 1)
endif()
set(COMDARE_PARALLEL_JOBS "${COMDARE_PARALLEL_JOBS}" CACHE STRING
    "Parallele Builds (User-Direktive: cores/2, je 2 Threads, Pipeline voll)")
message(STATUS "Comdare V37.G: ${_comdare_n_cores} cores detected, ${COMDARE_PARALLEL_JOBS} parallel jobs (2 threads each)")

# V-3 (Bauplan TEIL V, 2026-07-27): die Alt-Kanal-Schalter des Diplomarbeit-Containers sind
# ENTFALLEN -- der super-Configure ruft keinen Permutations-Codegen mehr auf.
# Hier standen bis zur Super-Abschaltung sechs Setzungen: COMDARE_BUILD_PERMUTATIONS (V36.B)
# und COMDARE_PRT_ART_BUILD_PERMUTATIONS (V36.C) je auf ON sowie die zugehoerigen
# COMDARE_[PRT_ART_]PERMUTATION_MODE/_PROFILE (on_build_on_demand / smoke). Sie zwangen den
# ce- und den prt-art-Sub-Build bei JEDEM Configure durch den V36.B-Codegen (27 + 16 smoke-
# Permutationen). Der Fassaden-/Planer-Kanal hat diesen Kanal vollstaendig abgeloest: das
# Treiber-Startgate fragt den Planer-Plan (V-2, 02_messung_driver/CMakeLists.txt), der
# CI-Job visibility:tier-binaries liest die Planer-Rohausgabe 'plan dump' v1.1 (D3.4/2b),
# und die perm_*-DLLs sind nicht die Tier-Binaries. Die Repo-Defaults bleiben unberuehrt
# (ce CMakeLists.txt:41 OFF, prt-art CMakeLists.txt:41 OFF) -- wer den Alt-Kanal fuer einen
# Vergleichslauf braucht, setzt -DCOMDARE_BUILD_PERMUTATIONS=ON explizit auf der Kommandozeile.
# Der ce-seitige Retire (Codegen-Werkzeug, cmake/permutations.cmake) folgt als Paket V-4.
#
# V-1 (O-8 Schritt 1): Vendor-Provisioning EXPLIZIT, nicht als Mitnahme-Effekt der
# Permutationen. Der ce-Default leitet sich aus COMDARE_BUILD_PERMUTATIONS ab und ist mit
# V-3 dort OFF -- diese explizite Setzung haelt das Provisioning am Leben und ist damit ab
# jetzt die TRAGENDE Quelle der COMDARE_VENDOR_*-Defaults (nicht mehr nur die Absicherung).
set(COMDARE_PROVISION_VENDOR_ALLOCATORS ON CACHE BOOL
    "Vendor-Allokatoren im Diplomarbeit-Container bereitstellen (V-1 Entkopplung)")

# ─────────────────────────────────────────────────────────────────────────────
# V35.E (2026-05-22) - FetchContent-Cache im User-Home
#
# Vermeidet, dass GoogleTest (und weitere FetchContent-Pakete) bei JEDEM
# cmake-clean-Build neu geladen werden. Wirkt fuer ALLE FetchContent-Calls
# inkl. der cache-engine + prt-art Sub-Builds (transitive).
#
# Reihenfolge: CLI -DFETCHCONTENT_BASE_DIR=... > ENV > Plattform-Default
# Override: cmake -DCOMDARE_FETCHCONTENT_USER_CACHE=OFF
# ─────────────────────────────────────────────────────────────────────────────
option(COMDARE_FETCHCONTENT_USER_CACHE
       "Lege FetchContent-Downloads im User-Cache ab (geteilt zwischen Build-Trees)"
       ON)

# V35.F (2026-05-22): Im Diplomarbeit-Container ist der cache-engine-Skelett-
# Build OK — die internen Submodules (modules/comdare-*) sind erst nach
# Cluster-Migration verfuegbar. CLion zeigt sonst alle Submodule-Warnings als
# rote Fehler im Debug-Tab.
set(COMDARE_QUIET_SUBMODULE_CHECK ON CACHE BOOL
    "Submodule-Check-Warnings als STATUS statt WARNING ausgeben (CLion)")

if(COMDARE_FETCHCONTENT_USER_CACHE AND NOT DEFINED FETCHCONTENT_BASE_DIR)
    set(_comdare_fetch_cache "")
    if(DEFINED ENV{COMDARE_FETCHCONTENT_CACHE})
        set(_comdare_fetch_cache "$ENV{COMDARE_FETCHCONTENT_CACHE}")
    elseif(WIN32 AND DEFINED ENV{LOCALAPPDATA})
        set(_comdare_fetch_cache "$ENV{LOCALAPPDATA}/comdare/_deps")
    elseif(DEFINED ENV{XDG_CACHE_HOME})
        set(_comdare_fetch_cache "$ENV{XDG_CACHE_HOME}/comdare/_deps")
    elseif(DEFINED ENV{HOME})
        set(_comdare_fetch_cache "$ENV{HOME}/.cache/comdare/_deps")
    elseif(DEFINED ENV{USERPROFILE})
        set(_comdare_fetch_cache "$ENV{USERPROFILE}/.cache/comdare/_deps")
    endif()
    if(_comdare_fetch_cache)
        # V35.E.3 (2026-05-22): Sub-Verzeichnis pro Generator+Compiler+BuildType.
        # Sonst kollidiert googletest-subbuild/CMakeCache.txt zwischen z.B.
        # "Visual Studio 17 2022" und "Ninja" (verschiedene Build-Backends).
        string(MAKE_C_IDENTIFIER "${CMAKE_GENERATOR}" _gen_safe)
        set(_compiler_id "${CMAKE_CXX_COMPILER_ID}")
        if(NOT _compiler_id)
            set(_compiler_id "unknown")
        endif()
        set(_btype "${CMAKE_BUILD_TYPE}")
        if(NOT _btype)
            set(_btype "multi")
        endif()
        set(_cache_dir "${_comdare_fetch_cache}/${_gen_safe}-${_compiler_id}-${_btype}")
        file(MAKE_DIRECTORY "${_cache_dir}")
        set(FETCHCONTENT_BASE_DIR "${_cache_dir}"
            CACHE PATH "User-Cache fuer FetchContent (V35.E.3)")
        message(STATUS "Comdare V35.E.3: FetchContent-Cache unter ${_cache_dir}")
    endif()
endif()

# ─────────────────────────────────────────────────────────────────────────────
# Submodule-Pfade (parallel, NICHT genested — REV 7.6 Q2)
# ─────────────────────────────────────────────────────────────────────────────
set(COMDARE_PRT_ART_DIR
    "${CMAKE_SOURCE_DIR}/external/comdare-prt-art"
    CACHE PATH "Pfad zur prt-art Submodule")
set(COMDARE_CACHE_ENGINE_DIR
    "${CMAKE_SOURCE_DIR}/external/comdare-cache-engine"
    CACHE PATH "Pfad zur cache-engine Submodule")

if(NOT EXISTS "${COMDARE_PRT_ART_DIR}/CMakeLists.txt")
    message(FATAL_ERROR
        "prt-art Submodule nicht initialisiert. Bitte ausfuehren:\n"
        "  git submodule update --init --recursive")
endif()

if(NOT EXISTS "${COMDARE_CACHE_ENGINE_DIR}/CMakeLists.txt")
    message(FATAL_ERROR
        "cache-engine Submodule nicht initialisiert.")
endif()

# cache-engine + prt-art als EXCLUDE_FROM_ALL einbinden (wir bauen nur,
# was wir wirklich brauchen)
# K-4/L5 (2026-07-19, Ledger par.20.D-B2/B4): generated-Include-Root des ce-Sub-Builds.
# ce setzt in cmake/provenance.cmake include_directories("${CMAKE_BINARY_DIR}/generated")
# als Directory-Include fuer ALLE ce-Targets — im ce-Standalone-Build ist das der
# ce-eigene generated-Root (axes/, topics/, generated_source_catalog.hpp), im
# super-Embed zeigt CMAKE_BINARY_DIR aber auf den super-Build-Root. Damit blieben
# <axes/...>-rootige Includes der exgen-Header (z.B. axis_06_allocator_exgen.hpp:18
# -> axes/alloc/axis_06_allocator_flags.hpp) im ce-Teilbaum unaufloesbar:
# test_experiment_projection gruen in ce build-conf, rot im super-Tree (build-i2);
# smoke/measurement/wdk-Tests stale-rot. Fix: den ce-Embed-generated-Root VOR dem
# add_subdirectory als Directory-Include setzen — vererbt sich in den gesamten
# ce-Teilbaum und stellt Standalone-Paritaet her. Gleiche Pfad-Konvention wie
# 02_messung_driver/CMakeLists.txt (COMDARE_V32-Include ..._cache_engine_external/generated).
include_directories("${CMAKE_BINARY_DIR}/_cache_engine_external/generated")
add_subdirectory(${COMDARE_CACHE_ENGINE_DIR}
                 ${CMAKE_BINARY_DIR}/_cache_engine_external
                 EXCLUDE_FROM_ALL)

# V-6i-NACHTRAG / F-B3 super-Naht (Codex-Nachreview W1/W2, 05.08.2026 abend): install()-Naht der
# PLANER-Binary. Der W1-Rollen-Schnitt (F1-HART) hat die Planer-Kommandos (validate | plan
# dump/ci/cmake | cache-key | fingerprint) aus dem installierten comdare-messung-driver entfernt;
# die ce-eigene Regel (ce apps/experiment_planner/CMakeLists.txt) ist HIER INERT, weil das
# add_subdirectory(... EXCLUDE_FROM_ALL) direkt oben einer Unterverzeichnis-Ebene dokumentiert auch
# ihre install()-Regeln aus dem Install-Ziel des Elternprojekts nimmt. Ohne super-eigene Naht
# verloere jedes super-Deployment die Planer-Kommandos ersatzlos (Funktionsverlust statt Teilung).
# FORM: install(PROGRAMS $<TARGET_FILE:...>) statt install(TARGETS ...), weil die Install-Regel im
# NICHT-excludeten Eltern-Scope leben muss und die PROGRAMS-Form die fertige Datei (OUTPUT_NAME
# comdare-experiment-planner) explizit ins selbe GNUInstallDirs-bin-Layout legt wie der Treiber
# (02_messung_driver/CMakeLists.txt:27, install(TARGETS messung_driver RUNTIME DESTINATION
# ${CMAKE_INSTALL_BINDIR})) -- Muster-Reuse, kein zweites Layout.
# BAU-VOR-INSTALL-NAHT: install() baut nicht. Damit `cmake --build` (ALL) + `cmake --install` die
# Datei sicher vorfinden, holt die Target-Property EXCLUDE_FROM_ALL=FALSE das ce-Target ins ALL des
# super-Builds zurueck (live gegen cmake 4.3.4 geprueft: der Property-Override aus dem Eltern-Scope
# wirkt, das Target baut im nackten ALL-Lauf mit; Mehrkosten = die eine App, denn die tragende
# Fassaden-lib comdare::profile_run_facade haengt ohnehin am Treiber). Ebenfalls live geprueft:
# die Property-Ruecknahme aktiviert NICHT die inerte ce-install()-Regel (die DIRECTORY-Ebene
# entscheidet ueber die Aufnahme der install()-Regeln) -- es bleibt bei genau EINER Install-Zeile.
set_property(TARGET comdare_experiment_planner PROPERTY EXCLUDE_FROM_ALL FALSE)
install(PROGRAMS "$<TARGET_FILE:comdare_experiment_planner>"
        DESTINATION "${CMAKE_INSTALL_BINDIR}")

# V36.C (2026-05-23): prt-art als add_subdirectory einbinden — nur fuer
# Pruefling-Permutations, NICHT die internen prt-art-Tests (vermeidet
# doppelten gtest-FetchContent + Test-Konflikte).
set(COMDARE_PRT_ART_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(COMDARE_PRT_ART_USE_CACHE_ENGINE OFF CACHE BOOL "" FORCE)
add_subdirectory(${COMDARE_PRT_ART_DIR}
                 ${CMAKE_BINARY_DIR}/_prt_art_external
                 EXCLUDE_FROM_ALL)

# V-3 (Bauplan TEIL V, 2026-07-27): die drei Re-Export-Targets des Alt-Kanals sind ENTFALLEN.
# Hier standen comdare_perms_ce (V36.B, Re-Export von comdare_permutations_all aus dem
# ce-Sub-Build), comdare_perms_pa (V36.C, Re-Export von comdare_prt_art_permutations_all) und
# das Kombi-Target comdare_perms_all (V36.D). Ihr Zweck war, die generierten Per-Permutations-
# Targets aus den Sub-Builds in der Diplomarbeit-Solution sichtbar zu machen; mit dem
# abgeschalteten Codegen (s. Options-Block oben) existieren die Quell-Targets gar nicht mehr,
# die if(TARGET ...)-Waechter waeren also ohnehin dauerhaft falsch.

# V-3 (Bauplan TEIL V, 2026-07-27): der perm/-Ausgabebaum des Alt-Kanals ist ENTFALLEN.
# Hier stand V37.G: das Drei-Wurzel-Layout (${BINARY_DIR}/perm/{cache_engine,prt_art,all})
# samt perm/BUILD_LABEL.txt (Compiler/BuildType/Generator/Profile/Mode als Beschriftung des
# Permutations-Builds) und dem POST_BUILD-Aggregator auf comdare_perms_all, der die beiden
# Codegen-Manifeste zu perm/all/manifest_all.txt zusammenzog (cmake/write_perm_all_manifest.cmake).
# Ohne Codegen bleibt kein Inhalt fuer diesen Baum: die drei Wurzeln waeren leere Verzeichnisse,
# das Label trueg leere permutation_profile/-mode-Felder (Doku-Luege), und der POST_BUILD-Waechter
# if(TARGET comdare_perms_all) ist dauerhaft falsch. Lebende Konsumenten hatte weder BUILD_LABEL.txt
# noch manifest_all.txt (Grep ueber super: nur diese CMake-Stellen selbst und Doku/Backups).
# Das Skript cmake/write_perm_all_manifest.cmake bleibt vorerst im Baum (Aufrufer = 0) und ist als
# Kandidat des Abschluss-Aufraeumpasses (Ledger 75) vermerkt.

# prt-art baut intern wieder cache-engine ein — das aber NICHT noch einmal:
# wir setzen COMDARE_CACHE_ENGINE_DIR explizit, sodass prt-art unsere
# Version benutzt statt seiner eigenen Sub-Submodule.
set(_CACHE_ENGINE_FORWARD "${COMDARE_CACHE_ENGINE_DIR}")
# prt-art's submodule-Pfad wird unten direkt via include-Path eingebunden,
# ohne dessen CMakeLists nochmal auszuwerten.

# ─────────────────────────────────────────────────────────────────────────────
# Tests (Top-level GoogleTest fuer alle Diplomarbeit-Code-Module)
# ─────────────────────────────────────────────────────────────────────────────
if(COMDARE_DA_BUILD_TESTS)
    enable_testing()
    include(FetchContent)
    set(_gtest_local "${COMDARE_CACHE_ENGINE_DIR}/cmake/third_party/googletest-1.15.2.tar.gz")
    if(EXISTS "${_gtest_local}")
        FetchContent_Declare(googletest URL "${_gtest_local}")
    else()
        FetchContent_Declare(
            googletest
            URL https://github.com/google/googletest/archive/refs/tags/v1.15.2.tar.gz
            URL_HASH SHA256=7b42b4d6ed48810c5362c265a17faebe90dc2373c885e5216439d37927f02926
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE)
    endif()
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    set(BUILD_GMOCK ON CACHE BOOL "" FORCE)
    set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)
    FetchContent_MakeAvailable(googletest)
endif()

# ─────────────────────────────────────────────────────────────────────────────
# Diplomarbeit-Code-Module
# ─────────────────────────────────────────────────────────────────────────────
# V41.E10.3-E10.5 (2026-05-31) - STATIC/SHARED-Linkage-Achse pro Untermodul (COMDARE_DA_<Mxx>_BUILD_SHARED)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/comdare_da_add_library.cmake)
# V35.A.2 (2026-05-22) - Pipeline-Module nach XX_operation/ Konvention
add_subdirectory(01_sample_data_generator)  # Helper: synthetische Test-Daten
add_subdirectory(02_messung_driver)          # echte Messung via V32Orchestrator
add_subdirectory(03_binary_to_csv)           # binary records -> CSV
add_subdirectory(04_csv_to_latex)            # CSV -> LaTeX-Tabelle
add_subdirectory(05_diagram_generator)       # CSV -> TikZ-Plot
add_subdirectory(06_latex_to_pdf)            # final PDF-Build
add_subdirectory(07_tier_binary_report)      # #279 Build-Sichtbarkeit + Interface-Roster
add_subdirectory(08_appendix_generator)      # Inc1: In-Process-Appendix-Orchestrator (ersetzt .ps1)
add_subdirectory(09_tex_formatter)           # #25: LaTeX-Formatierer C++23 (ersetzt format_tex.py)

# ─────────────────────────────────────────────────────────────────────────────
# V41.P1 (2026-05-31) — E2E-Pipeline-Orchestrierung: treibt EINEN Datensatz GESCHLOSSEN durch die
# 6-Stufen-Kette und beweist damit den 16-Spalten-Schema-Fluss (Audit-Blocker G1/G2 behoben).
#   Sample-Pfad (ohne Permutations-DLLs lauffaehig, fuer die Abnahme-Demonstration):
#     01 -> 16-col CSV -> 04 LaTeX-Tabelle + 05 TikZ-Diagramm (--by-workload) -> 06 PDF (best-effort, braucht pdflatex)
#   Realer Pfad (mit gebauten DLLs): messung_driver(02) -> .bin -> binary-to-csv(03) -> 04/05/06 (analog).
# Aufruf: cmake --build <build> --target comdare_pipeline_e2e
# ─────────────────────────────────────────────────────────────────────────────
set(_comdare_pipe_dir "${CMAKE_BINARY_DIR}/pipeline_e2e")
# V41.P1: pdflatex (optional) — schliesst die Kette bis zum PDF (pipeline_demo.pdf), das die
# generierten Tabelle/Diagramm einbindet. Demo = Build-Artefakt, KEIN Thesis-Volltext (D1/D2 user-manuell).
find_program(COMDARE_PDFLATEX NAMES pdflatex)
set(_comdare_pipe_pdf_cmds "")
if(COMDARE_PDFLATEX)
    set(_comdare_pipe_pdf_cmds
        COMMAND ${CMAKE_COMMAND} -E copy
            "${CMAKE_CURRENT_SOURCE_DIR}/06_latex_to_pdf/pipeline_demo.tex" "${_comdare_pipe_dir}/pipeline_demo.tex"
        COMMAND ${CMAKE_COMMAND} -E chdir "${_comdare_pipe_dir}"
            "${COMDARE_PDFLATEX}" -interaction=nonstopmode -halt-on-error pipeline_demo.tex)
endif()
add_custom_target(comdare_pipeline_e2e
    COMMAND ${CMAKE_COMMAND} -E make_directory "${_comdare_pipe_dir}"
    # Stufe 01: synthetischer 16-Spalten-Mess-Datensatz (Standin bis reale HW-Messung, P3).
    COMMAND $<TARGET_FILE:sample_data_generator> "${_comdare_pipe_dir}/measurements.csv"
    # Stufe 04: CSV -> booktabs-LaTeX-Tabelle (parst jetzt 16 Spalten ohne Wurf).
    COMMAND $<TARGET_FILE:csv_to_latex_cli> "${_comdare_pipe_dir}/measurements.csv" "${_comdare_pipe_dir}/04_table.tex" "F15 Messreihe" "tab:f15"
    # Stufe 05: CSV -> TikZ-Diagramm, gruppiert nach workload_used (16-Spalten-Schema).
    COMMAND $<TARGET_FILE:diagram_generator_cli> --by-workload "${_comdare_pipe_dir}/measurements.csv" "${_comdare_pipe_dir}/05_diagram.tex"
    # Stufe 06 (best-effort, falls pdflatex vorhanden): Demo-PDF aus den generierten Artefakten.
    ${_comdare_pipe_pdf_cmds}
    COMMENT "V41.P1 E2E-Pipeline: 01 Sample-CSV -> 04 LaTeX + 05 TikZ -> 06 pipeline_demo.pdf (geschlossener 16-Spalten-Fluss)"
    VERBATIM)
add_dependencies(comdare_pipeline_e2e
    sample_data_generator csv_to_latex_cli diagram_generator_cli)

# ─────────────────────────────────────────────────────────────────────────────
# #279 (User 2026-07-06) — release_measure: echter Mess-Lauf VOR der PDF.
# Nur aktiv bei -DCOMDARE_DA_PIPELINE_MODE=release_measure; Default debug_sample
# laesst comdare_pipeline_e2e (synthetisch) unberuehrt. Der schwere Lauf (#156,
# mehrtaegig) ist bewusst opt-in/lokal und wird NICHT in der Standard-CI getriggert.
# ─────────────────────────────────────────────────────────────────────────────
set(_comdare_release_dir "${CMAKE_BINARY_DIR}/pipeline_release")
if(COMDARE_DA_PIPELINE_MODE STREQUAL "release_measure")
    set(_comdare_release_deps
        messung_driver binary_to_csv_cli csv_to_latex_cli diagram_generator_cli)
    # V-3 (Bauplan TEIL V, 2026-07-27): der bedingte Anhang von comdare_perms_all bzw.
    # comdare_perms_ce an die Release-Abhaengigkeiten ist ENTFALLEN. Sein Kommentar behauptete
    # "alle Tier-Binaries PFLICHT vor dem Lauf" -- das war schon vor dem Retire falsch: die
    # perm_*-DLLs des V36.B-Codegens sind NICHT die Tier-Binaries (Bauplan TEIL V, Paket V-4:
    # "perm_*-DLLs sind nicht die Tier-Binaries; kein ce-Runtime-Konsument"). Die Tier-Binaries
    # baut der Planer-/CEB-Kanal aus dem Profil. Mit den entfallenen Re-Export-Targets waeren
    # beide if(TARGET ...)-Zweige ohnehin dauerhaft falsch.
    # Best-effort finale PDF (nur wenn pdflatex vorhanden) — analog comdare_pipeline_e2e.
    set(_comdare_release_pdf_cmds "")
    if(COMDARE_PDFLATEX)
        set(_comdare_release_pdf_cmds
            COMMAND ${CMAKE_COMMAND} -E copy
                "${CMAKE_CURRENT_SOURCE_DIR}/06_latex_to_pdf/pipeline_demo.tex"
                "${_comdare_release_dir}/pipeline_demo.tex"
            COMMAND ${CMAKE_COMMAND} -E chdir "${_comdare_release_dir}"
                "${COMDARE_PDFLATEX}" -interaction=nonstopmode -halt-on-error pipeline_demo.tex)
    endif()
    # Voller RELEASE-Fluss VOR der PDF: echter Mess-Lauf -> binaere Records -> 16-Spalten-CSV
    # -> Stufe 04 (LaTeX-Tabelle) + Stufe 05 (TikZ) -> Stufe 06 (PDF, best-effort). Namen der
    # .tex-Artefakte (04_table.tex/05_diagram.tex) spiegeln die \input von pipeline_demo.tex.
    add_custom_target(comdare_pipeline_release
        COMMAND ${CMAKE_COMMAND} -E make_directory "${_comdare_release_dir}"
        COMMAND $<TARGET_FILE:messung_driver>
            "${CMAKE_CURRENT_SOURCE_DIR}/experiment_config"
            "${_comdare_release_dir}"
            "--messreihen-xml=${CMAKE_CURRENT_SOURCE_DIR}/experiment_config/messreihen.xml"
        COMMAND $<TARGET_FILE:binary_to_csv_cli>
            "${_comdare_release_dir}/measurements/all_permutations.bin"
            "${_comdare_release_dir}/measurements.csv"
        COMMAND $<TARGET_FILE:csv_to_latex_cli>
            "${_comdare_release_dir}/measurements.csv" "${_comdare_release_dir}/04_table.tex"
            "Release Messreihe" "tab:release"
        COMMAND $<TARGET_FILE:diagram_generator_cli>
            --by-workload "${_comdare_release_dir}/measurements.csv" "${_comdare_release_dir}/05_diagram.tex"
        ${_comdare_release_pdf_cmds}
        COMMENT "#279 release_measure: echter Mess-Lauf -> CSV -> LaTeX-Tabelle+Diagramm -> PDF (opt-in, nicht in Standard-CI)"
        VERBATIM)
    add_dependencies(comdare_pipeline_release ${_comdare_release_deps})
else()
    # Stub, damit das Target immer existiert (dokumentiert den Schalter).
    add_custom_target(comdare_pipeline_release
        COMMAND ${CMAKE_COMMAND} -E echo
            "#279: comdare_pipeline_release INAKTIV (COMDARE_DA_PIPELINE_MODE=${COMDARE_DA_PIPELINE_MODE}). Aktivieren mit -DCOMDARE_DA_PIPELINE_MODE=release_measure."
        COMMENT "#279 release_measure INAKTIV (Default debug_sample)"
        VERBATIM)
endif()

# ─────────────────────────────────────────────────────────────────────────────
# #279 — dynamische Tier-Binary-Build-Sichtbarkeit (comdare_tier_binary_visibility):
# rostert geplante vs. gebaute vs. offene Rekombinationen + CacheEngineBuilder-Status
# ueber das committete Tool tier-binary-report.
# 2c/OP-8 (2026-07-27): die geplante Menge kommt NICHT mehr aus dem Configure-Zeit-Manifest
# (generated/permutations_manifest.txt), sondern aus der Planer-Rohausgabe "plan dump" v1.1 --
# derselbe Text, den der CI-Job visibility:tier-binaries liest (EIN-FORMAT-REGEL, Ledger 73.1).
# Das Target erzeugt die Rohausgabe zuerst selbst (Schritt 1) und wertet sie dann aus (Schritt 2);
# es ist dadurch schwerer als vorher (Treiber-Bau statt Einzel-Tool) und bleibt manuell.
# W1/S3 (2026-08-05, F1-HART): 'plan dump' ist die PLANER-Rolle und lebt seit dem Rollen-Schnitt
# in der eigenen ce-Binary comdare-experiment-planner (ce-Target comdare_experiment_planner,
# apps/experiment_planner). Der ce-Sub-Build ist EXCLUDE_FROM_ALL -> die Bau-Sicherung laeuft
# ueber die Target-DEPENDS unten (Gegenstueck zum expliziten
# `cmake --build ... --target comdare_experiment_planner` der S2-CI-Jobs). Der Treiber bleibt
# in DEPENDS stehen: das Target beweist die Bau-Sichtbarkeit BEIDER Stufen-Traeger
# (CEB + Planer), identisch zum CI-Job visibility:tier-binaries.
# Profil OHNE Argument: Fallback-Kette COMDARE_THESIS_PROFILE -> einkompiliertes Default
# (identisch zum CI-Job; explizites Pinning waere OP-5).
# ─────────────────────────────────────────────────────────────────────────────
set(_comdare_plan_dump "${CMAKE_BINARY_DIR}/generated/dump_plan.txt")
set(_comdare_visibility_cmd
    $<TARGET_FILE:tier_binary_report_cli> --visibility
        "${_comdare_plan_dump}" "${CMAKE_BINARY_DIR}/perm")
# M-SU-06: echtes CMake-Target = cache_engine_builder (apps/cache_engine_builder, if COMDARE_BUILD_BUILDER);
# „comdare-cache-engine-builder" ist NUR OUTPUT_NAME und existiert NICHT als Target — daher hier der Target-Name.
if(TARGET cache_engine_builder)
    list(APPEND _comdare_visibility_cmd "--builder-exe=$<TARGET_FILE:cache_engine_builder>")
endif()
add_custom_target(comdare_tier_binary_visibility
    COMMAND ${CMAKE_COMMAND}
        -DDUMP_PLAN_PLANNER=$<TARGET_FILE:comdare_experiment_planner>
        -DDUMP_PLAN_OUT=${_comdare_plan_dump}
        -P ${CMAKE_SOURCE_DIR}/cmake/comdare_dump_plan.cmake
    COMMAND ${_comdare_visibility_cmd}
    DEPENDS tier_binary_report_cli messung_driver comdare_experiment_planner
    COMMENT "#279 Build-Sichtbarkeit: geplante/gebaute/offene Tier-Binaries + CacheEngineBuilder-Status"
    VERBATIM)

# ─────────────────────────────────────────────────────────────────────────────
# #273/A3 (2026-07-06) — Sammel-Target fuer die clang-Matrix (build:clang, ci-templates
# .build-clang-latest baut genau EIN COMDARE_CMAKE_BUILD_TARGET; Muster: ce comdare_tests, 264-a).
# Scope = super-eigene C++-Werkzeugflaeche (analyse:thesis-data ∪ integration:smoke):
# Libs M03-M05 + alle CLI-/Treiber-Executables 01-05. Tests/DLL-Codegen bewusst NICHT enthalten.
# ─────────────────────────────────────────────────────────────────────────────
add_custom_target(comdare_da_tools
    DEPENDS
        sample_data_generator
        messung_driver
        comdare_binary_to_csv    binary_to_csv_cli
        comdare_csv_to_latex     csv_to_latex_cli
        comdare_diagram_generator diagram_generator_cli
        tier_binary_report_cli)   # #279 Build-Sichtbarkeit/Interface-Roster-Tool

if(COMDARE_DA_BUILD_TESTS)
    add_subdirectory(tests)
    # ── User-Direktive 06.07. (strikt grün, Tests nie manual/auslassen): Sammel-Target NUR der
    # super-eigenen Tests (11 Code/tests via Registry + 4 Stufen-Fixture-Tests; ce-Suite hat ihr
    # EIGENES test:unit im ce-Repo). CI: test:unit baut dieses Target + ctest -L da_unit.
    get_property(_comdare_da_tests GLOBAL PROPERTY COMDARE_DA_TEST_TARGETS)
    add_custom_target(comdare_da_unit_tests)
    foreach(_t IN LISTS _comdare_da_tests)
        if(TARGET ${_t})
            add_dependencies(comdare_da_unit_tests ${_t})
        endif()
    endforeach()
    # M-SU-05 (Muster-F, 2026-07-13): test_08_appendix_generator + test_09_tex_formatter werden in ihren Stufen-
    # Subdirs via gtest_discover_tests (LABELS da_unit) definiert, NICHT ueber comdare_da_add_test → sie fehlten im
    # Sammel-Bau comdare_da_unit_tests → test:unit baute sie nie → ihre da_unit-Suites liefen in CI nie (silent
    # skip; tex_formatter wurde in keinem CI-Job kompiliert). Additiv in dieselbe explizite Liste wie die 03..06-
    # Fixture-Tests aufgenommen (TARGET-Guard: greift nur bei COMDARE_DA_BUILD_TESTS).
    foreach(_t
            test_03_binary_to_csv_cached_fixtures
            test_04_csv_to_latex_cached_fixtures
            test_05_diagram_generator_cached_fixtures
            test_06_latex_to_pdf_cached_fixtures
            test_08_appendix_generator
            test_09_tex_formatter)
        if(TARGET ${_t})
            add_dependencies(comdare_da_unit_tests ${_t})
        endif()
    endforeach()
endif()

# ─────────────────────────────────────────────────────────────────────────────
# Status-Ausgabe
# ─────────────────────────────────────────────────────────────────────────────
message(STATUS "──────────────────────────────────────────────────────────")
message(STATUS "comdare-diplomarbeit-code ${PROJECT_VERSION}")
message(STATUS "  C++ Standard         : ${CMAKE_CXX_STANDARD}")
message(STATUS "  prt-art Submodule    : ${COMDARE_PRT_ART_DIR}")
message(STATUS "  cache-engine Submod. : ${COMDARE_CACHE_ENGINE_DIR}")
message(STATUS "  Build Tests          : ${COMDARE_DA_BUILD_TESTS}")
message(STATUS "──────────────────────────────────────────────────────────")
