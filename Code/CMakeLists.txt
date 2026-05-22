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

option(COMDARE_DA_BUILD_TESTS "Build Diplomarbeit-Code Tests" ON)

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
        file(MAKE_DIRECTORY "${_comdare_fetch_cache}")
        set(FETCHCONTENT_BASE_DIR "${_comdare_fetch_cache}"
            CACHE PATH "User-Cache fuer FetchContent (V35.E)")
        message(STATUS "Comdare V35.E: FetchContent-Cache unter ${_comdare_fetch_cache}")
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
# V35.A.2 (2026-05-22) - Pipeline-Module nach XX_operation/ Konvention
add_subdirectory(01_sample_data_generator)  # Helper: synthetische Test-Daten
add_subdirectory(02_messung_driver)          # echte Messung via V32Orchestrator
add_subdirectory(03_binary_to_csv)           # binary records -> CSV
add_subdirectory(04_csv_to_latex)            # CSV -> LaTeX-Tabelle
add_subdirectory(05_diagram_generator)       # CSV -> TikZ-Plot
add_subdirectory(06_latex_to_pdf)            # final PDF-Build

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
