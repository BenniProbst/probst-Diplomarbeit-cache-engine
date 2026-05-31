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
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS 13.0)
    message(FATAL_ERROR "gcc >= 13.0 erforderlich fuer C++23 (gefunden: ${CMAKE_CXX_COMPILER_VERSION})")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS 16.0)
    message(FATAL_ERROR "clang >= 16.0 erforderlich fuer C++23 (gefunden: ${CMAKE_CXX_COMPILER_VERSION})")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang" AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS 15.0)
    message(FATAL_ERROR "Apple Clang >= 15.0 erforderlich (gefunden: ${CMAKE_CXX_COMPILER_VERSION})")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC" AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS 19.34)
    message(FATAL_ERROR "MSVC >= 19.34 (VS 2022 17.4+) erforderlich (gefunden: ${CMAKE_CXX_COMPILER_VERSION})")
endif()
message(STATUS "V38.A C++23-Compiler: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION} OK")

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

# V36.B (2026-05-23): Permutations-Pre-Build Default-ON im Diplomarbeit-Container
# Mode: on_build_on_demand (User-Direktive 2026-05-23) — inkrementell
set(COMDARE_BUILD_PERMUTATIONS ON CACHE BOOL
    "Pre-Build der cache-engine Permutationen (V36.B Diplomarbeit-Default)")
set(COMDARE_PRT_ART_BUILD_PERMUTATIONS ON CACHE BOOL
    "Pre-Build der PRT-ART Pruefling-Permutationen (V36.C Diplomarbeit-Default)")
set(COMDARE_PERMUTATION_MODE "on_build_on_demand" CACHE STRING
    "Tri-State Mode: on_rebuild | on_build_on_demand | off_pause_build")
set(COMDARE_PRT_ART_PERMUTATION_MODE "on_build_on_demand" CACHE STRING
    "Tri-State Mode (PRT-ART): on_rebuild | on_build_on_demand | off_pause_build")
set(COMDARE_PERMUTATION_PROFILE "smoke" CACHE STRING
    "Profile-Filter: smoke (~27) | medium (~108) | full (Stunden)")
set(COMDARE_PRT_ART_PERMUTATION_PROFILE "smoke" CACHE STRING
    "PRT-ART Profile: smoke (~16) | medium (~81) | full")

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
add_subdirectory(${COMDARE_CACHE_ENGINE_DIR}
                 ${CMAKE_BINARY_DIR}/_cache_engine_external
                 EXCLUDE_FROM_ALL)

# V36.C (2026-05-23): prt-art als add_subdirectory einbinden — nur fuer
# Pruefling-Permutations, NICHT die internen prt-art-Tests (vermeidet
# doppelten gtest-FetchContent + Test-Konflikte).
set(COMDARE_PRT_ART_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(COMDARE_PRT_ART_USE_CACHE_ENGINE OFF CACHE BOOL "" FORCE)
add_subdirectory(${COMDARE_PRT_ART_DIR}
                 ${CMAKE_BINARY_DIR}/_prt_art_external
                 EXCLUDE_FROM_ALL)

# V36.B (2026-05-23): Re-Export der Permutations-Targets auf Top-Level.
# Ohne dieses Re-Export sind die ~27 Per-Permutation-Targets nur in der
# cache-engine.sln, nicht in der Diplomarbeit-Sln.
if(TARGET comdare_permutations_all)
    # Aggregator-Top-Level Target: explizit baubar via
    #   cmake --build <preset> --target comdare_perms
    add_custom_target(comdare_perms_ce
        DEPENDS comdare_permutations_all
        COMMENT "V36.B Pre-Build aller cache-engine Permutationen")
    message(STATUS "Comdare V36.B: 'comdare_perms_ce' Top-Level-Target registriert")
endif()

# V36.C (2026-05-23): PRT-ART Pruefling-Permutations Top-Level Re-Export
if(TARGET comdare_prt_art_permutations_all)
    add_custom_target(comdare_perms_pa
        DEPENDS comdare_prt_art_permutations_all
        COMMENT "V36.C Pre-Build aller PRT-ART Pruefling-Permutationen")
    message(STATUS "Comdare V36.C: 'comdare_perms_pa' Top-Level-Target registriert")
endif()

# V36.D (2026-05-23): Kombi-Target — beide Permutations-Sets in einem Schritt
if(TARGET comdare_perms_ce AND TARGET comdare_perms_pa)
    add_custom_target(comdare_perms_all
        DEPENDS comdare_perms_ce comdare_perms_pa
        COMMENT "V36.D Pre-Build aller Permutationen (cache-engine + PRT-ART)")
endif()

# V37.G (2026-05-23): Drei-Wurzel-Filesystem-Layout fuer Permutations.
# User-Direktive: "Cache Engine Rekombinationen vs Prueflings Rekombinationen
# vs ALLE Rekombinationen sind jeweils die Wurzel des Baumes"
#
# Wurzeln:
#   ${BINARY_DIR}/perm/cache_engine/  (27 smoke / 144 medium)
#   ${BINARY_DIR}/perm/prt_art/       (16 smoke / 81 medium)
#   ${BINARY_DIR}/perm/all/           (Aggregator-Manifest)
#
# Compiler/BuildType-Label als perm/BUILD_LABEL.txt (User-Direktive:
# "Compiler/CMake-build-type/Version koennen als Beschriftung des
# Permutation-Builds vereinfacht werden")
file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/perm/all")
file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/perm/cache_engine")
file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/perm/prt_art")

# Compiler/BuildType/Version als Label
# Bei Multi-Config-Generatoren (VS) ist CMAKE_BUILD_TYPE leer
set(_label_build_type "${CMAKE_BUILD_TYPE}")
if(NOT _label_build_type)
    set(_label_build_type "multi-config")
endif()
set(_build_label_content "# perm/BUILD_LABEL.txt — generiert vom Diplomarbeit-Container
# User-Direktive V37.G: Compiler/BuildType/Version als Beschriftung

compiler_id=${CMAKE_CXX_COMPILER_ID}
compiler_version=${CMAKE_CXX_COMPILER_VERSION}
compiler_path=${CMAKE_CXX_COMPILER}
build_type=${_label_build_type}
generator=${CMAKE_GENERATOR}
cmake_version=${CMAKE_VERSION}
system_name=${CMAKE_SYSTEM_NAME}
system_processor=${CMAKE_SYSTEM_PROCESSOR}
parallel_jobs=${COMDARE_PARALLEL_JOBS}
permutation_profile=${COMDARE_PERMUTATION_PROFILE}
prt_art_profile=${COMDARE_PRT_ART_PERMUTATION_PROFILE}
permutation_mode=${COMDARE_PERMUTATION_MODE}
prt_art_mode=${COMDARE_PRT_ART_PERMUTATION_MODE}
")
file(WRITE "${CMAKE_BINARY_DIR}/perm/BUILD_LABEL.txt" "${_build_label_content}")

# Aggregator-Manifest (perm/all/manifest_all.txt) wird via custom_command
# nach jedem comdare_perms_all-Build geschrieben (POST_BUILD).
if(TARGET comdare_perms_all)
    add_custom_command(TARGET comdare_perms_all POST_BUILD
        COMMAND ${CMAKE_COMMAND}
            -DPERM_CE_MANIFEST=${CMAKE_BINARY_DIR}/generated/permutations_manifest.txt
            -DPERM_PA_MANIFEST=${CMAKE_BINARY_DIR}/generated/prt_art_permutations_manifest.txt
            -DPERM_ALL_OUT=${CMAKE_BINARY_DIR}/perm/all/manifest_all.txt
            -DPERM_ROOT=${CMAKE_BINARY_DIR}/perm
            -P ${CMAKE_SOURCE_DIR}/cmake/write_perm_all_manifest.cmake
        COMMENT "V37.G: schreibe perm/all/manifest_all.txt + perm/README.md")
endif()

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

# ─────────────────────────────────────────────────────────────────────────────
# V41.P1 (2026-05-31) — E2E-Pipeline-Orchestrierung: treibt EINEN Datensatz GESCHLOSSEN durch die
# 6-Stufen-Kette und beweist damit den 16-Spalten-Schema-Fluss (Audit-Blocker G1/G2 behoben).
#   Sample-Pfad (ohne Permutations-DLLs lauffaehig, fuer die Abnahme-Demonstration):
#     01 -> 16-col CSV -> 04 LaTeX-Tabelle + 05 TikZ-Diagramm (--by-workload) -> 06 PDF (best-effort, braucht pdflatex)
#   Realer Pfad (mit gebauten DLLs): messung_driver(02) -> .bin -> binary-to-csv(03) -> 04/05/06 (analog).
# Aufruf: cmake --build <build> --target comdare_pipeline_e2e
# ─────────────────────────────────────────────────────────────────────────────
set(_comdare_pipe_dir "${CMAKE_BINARY_DIR}/pipeline_e2e")
add_custom_target(comdare_pipeline_e2e
    COMMAND ${CMAKE_COMMAND} -E make_directory "${_comdare_pipe_dir}"
    # Stufe 01: synthetischer 16-Spalten-Mess-Datensatz (Standin bis reale HW-Messung, P3).
    COMMAND $<TARGET_FILE:sample_data_generator> "${_comdare_pipe_dir}/measurements.csv"
    # Stufe 04: CSV -> booktabs-LaTeX-Tabelle (parst jetzt 16 Spalten ohne Wurf).
    COMMAND $<TARGET_FILE:csv_to_latex_cli> "${_comdare_pipe_dir}/measurements.csv" "${_comdare_pipe_dir}/04_table.tex" "F15 Messreihe" "tab:f15"
    # Stufe 05: CSV -> TikZ-Diagramm, gruppiert nach workload_used (16-Spalten-Schema).
    COMMAND $<TARGET_FILE:diagram_generator_cli> --by-workload "${_comdare_pipe_dir}/measurements.csv" "${_comdare_pipe_dir}/05_diagram.tex"
    COMMENT "V41.P1 E2E-Pipeline: 01 Sample-CSV -> 04 LaTeX + 05 TikZ (geschlossener 16-Spalten-Fluss)"
    VERBATIM)
add_dependencies(comdare_pipeline_e2e
    sample_data_generator csv_to_latex_cli diagram_generator_cli)

if(COMDARE_DA_BUILD_TESTS)
    add_subdirectory(tests)
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
