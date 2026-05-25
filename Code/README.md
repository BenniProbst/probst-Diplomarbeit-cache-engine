# Diplomarbeit/Code/

**Rolle:** Anwender-Schicht der Drei-Repo-Architektur (REV 7.6, 2026-05-13).

Diese C++23-Application ruft die `comdare-prt-art`-Submodule (mit ihrem
`comdare-cache-engine`-Backbone) auf, fuehrt die drei Pflicht-Messreihen
durch und uebersetzt die binary measurement-records in LaTeX-PDFs.

## Architektur

```
Diplomarbeit/Code/
  └─ ruft als Submodule auf:
     ├─ external/comdare-prt-art         (Test-Algorithmus PRT-ART)
     └─ external/comdare-cache-engine    (Werkzeug-Bibliothek + Bausteine)
```

Die `ExperimentDriver`-Library lebt in cache-engine, der **Driver** lebt
hier (in `messung_driver/main.cpp`).

## Pipeline (5 Stufen)

```
experiment_config.xml
      │
      ▼
[1] messung_driver/   ◄── ruft prt-art-API auf
      │   ├── PRT-ART vs SOTA       (Messreihe A)
      │   ├── cache-engine Perm.    (Messreihe B)
      │   └── Merge alt/neu         (Messreihe C)
      │
      ▼ binary measurement_record_v1
[2] binary_to_csv/    ◄── deserialisiert binary → CSV
      │
      ▼ CSV (15-Spalten)
[3] csv_to_latex/     ◄── CSV + Algorithmus-Baustein-Doku → LaTeX
      │
      ▼ .tex Tabellen-Snippets
[4] diagram_generator/ ◄── C++ → TikZ-Code (A4-aware)
      │
      ▼ .tex Plot-Snippets
[5] latex_to_pdf/      ◄── pdflatex 2x + bibtex → Diplomarbeit.pdf
```

## Drei Pflicht-Messreihen

| ID | Was | Quelle |
|---|---|---|
| **A** | PRT-ART Testalgorithmus gegen Stand-der-Technik | prt-art + cache-engine SOTA-Adapter |
| **B** | Bestehende cache-engine Permutationen | cache-engine 54+ Permutationen |
| **C** | Merge alt/neu (PRT-ART-Bausteine in cache-engine-Stack) | Configurable Merge-Punkte |

Spezifikation in `experiment_config/config_{a,b,c}_*.xml`.

## Build

```bash
cd Code/
git submodule update --init --recursive
cmake -B build
cmake --build build
cd build && ctest --output-on-failure
```

## CMake-Presets (V37+, 11 vordefinierte)

Aus `Code/CMakePresets.json` — alle aktivieren V32 + Pre-Build Permutations + 8 parallel Jobs.

| Preset | Generator | Build-Type | Empfohlen fuer |
|--------|-----------|-----------|----------------|
| `msvc-debug` | Visual Studio 17 2022 | Debug | Daily Development MSVC |
| `msvc-release` | Visual Studio 17 2022 | Release | Vollausbau Permutations |
| `msvc-minsizerel` | Visual Studio 17 2022 | MinSizeRel | Disk-Footprint optimiert |
| `msvc-relwithdebinfo` | Visual Studio 17 2022 | RelWithDebInfo | Profiling mit Debug-Info |
| `ninja-mingw-debug` | Ninja + MinGW gcc 13.1 | Debug | CLion-Default |
| `ninja-mingw-release` | Ninja + MinGW gcc 13.1 | Release | CLion-Performance |
| `ninja-mingw-minsizerel` | Ninja + MinGW gcc 13.1 | MinSizeRel | CLion Min-Size |
| `ninja-mingw-relwithdebinfo` | Ninja + MinGW gcc 13.1 | RelWithDebInfo | CLion-Profiling |
| `gcc-release` | Unix Makefiles + gcc | Release | Linux-Cluster Standard |
| `ninja-gcc-release` | Ninja + gcc | Release | Linux schnellster Build |
| `clang-release` | Unix Makefiles + clang | Release | Apple Clang/Linux |

Aufruf: `cmake --preset msvc-release` + `cmake --build --preset msvc-release`.

## CMake-Cache-Optionen (Schluesseloptionen)

| Option | Default | Bedeutung |
|--------|---------|-----------|
| `COMDARE_V32_ENABLE` | ON | V32 Orchestrator + Tests |
| `COMDARE_BUILD_PERMUTATIONS` | ON | cache-engine Permutations-Codegen |
| `COMDARE_PRT_ART_BUILD_PERMUTATIONS` | ON | PRT-ART Pruefling-Permutationen |
| `COMDARE_PERMUTATION_MODE` | on_build_on_demand | on_rebuild / on_build_on_demand / off_pause_build |
| `COMDARE_PERMUTATION_PROFILE` | smoke | smoke (~27) / medium (~108) / full |
| `COMDARE_PRT_ART_PERMUTATION_PROFILE` | smoke | smoke (~16) / medium / full |
| `COMDARE_DA_BUILD_TESTS` | ON | Diplomarbeit-Tests (104) |
| `COMDARE_FETCHCONTENT_USER_CACHE` | ON | User-Cache fuer FetchContent |
| `COMDARE_QUIET_SUBMODULE_CHECK` | ON | Submodule-Hinweise als STATUS statt WARNING |
| `COMDARE_VENDOR_MIMALLOC` | ON | mimalloc Vendored Static (V40.A) |
| `COMDARE_VENDOR_JEMALLOC` | ON | jemalloc 3-Stage Detection (V41.A1) |
| `COMDARE_VENDOR_SNMALLOC` | ON | snmalloc header-only (V41.A2) |
| `COMDARE_VENDOR_TCMALLOC` | ON | tcmalloc Detection (V41.A2) |
| `COMDARE_VENDOR_HOARD` | ON | hoard Detection (V41.A2) |
| `COMDARE_VENDOR_SCALLOC` | ON | scalloc Detection (V41.A2) |

## Wichtige Top-Level Targets

| Target | Was |
|--------|-----|
| `comdare_perms_ce` | Alle cache-engine Permutations-DLLs |
| `comdare_perms_pa` | Alle PRT-ART Pruefling-Permutations-DLLs |
| `comdare_perms_all` | Beide zusammen + Aggregator-Manifest |
| `messung_driver` | Driver-Binary (Plugins laden, binary records, Welch-Stats) |
| Tests `test_*` | 104 GTest-Tests |

## Hilfs-Skripte

| Skript | Was |
|--------|-----|
| `tools/run_all_tests.sh` | All-in-one Test-Runner (autodetect Build-Config) |
| `tools/cross_compiler_matrix.sh` | Cross-Compiler-Matrix (8 Combos) |
| `tools/fetch_testdata.sh` | Test-Daten holen |

## CLion

Open `Code/` als Projekt → CMakePresets.json wird automatisch erkannt.
