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

Die drei projektinternen Submodule verfolgen explizit den Integrationsbranch
`development` und verwenden die nicht-destruktive Update-Strategie `merge`.
Der Gitlink im Superprojekt bleibt der reproduzierbare Snapshot; zum bewussten
Nachziehen auf den aktuellen Integrationsstand dienen aus der Wurzel des
Superprojekts:

```bash
git submodule update --init --recursive
git submodule update --remote --merge -- \
  Code/external/comdare-cache-engine \
  Code/external/comdare-prt-art \
  thesis/diplomarbeit
```

Das gezielte zweite Kommando laesst transitiv gepinnte Drittanbieter-Submodule
(beispielsweise Q01/concurrentqueue) bewusst auf dem vom jeweiligen Parent
festgelegten Gitlink.

Vor einem Gitlink-Commit muessen `main` und `development` des jeweiligen
Submoduls synchronisiert sein (`development` enthaelt mindestens `main`).

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
| `COMDARE_BUILD_PERMUTATIONS` | **OFF** (seit V-3) | Alt-Kanal cache-engine Permutations-Codegen; der Container setzt ihn nicht mehr — nur noch explizit per `-D` fuer historische Vergleichslaeufe |
| `COMDARE_PRT_ART_BUILD_PERMUTATIONS` | **OFF** (seit V-3) | dito fuer die PRT-ART Pruefling-Permutationen |
| `COMDARE_PERMUTATION_MODE` | on_build_on_demand | nur wirksam bei explizit eingeschaltetem Alt-Kanal |
| `COMDARE_PERMUTATION_PROFILE` | smoke | dito: smoke (~27) / medium (~108) / full |
| `COMDARE_PRT_ART_PERMUTATION_PROFILE` | smoke | dito: smoke (~16) / medium / full |
| `COMDARE_PROVISION_VENDOR_ALLOCATORS` | ON | Vendor-Allokatoren bereitstellen (V-1-Entkopplung; traegt die `COMDARE_VENDOR_*`-Defaults, seit V-3 unabhaengig vom Alt-Kanal) |
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
| ~~`comdare_perms_ce`~~ | ENTFALLEN mit V-3 (2026-07-27) — Alt-Kanal-Re-Export der cache-engine Permutations-DLLs |
| ~~`comdare_perms_pa`~~ | ENTFALLEN mit V-3 — Alt-Kanal-Re-Export der PRT-ART Pruefling-Permutations-DLLs |
| ~~`comdare_perms_all`~~ | ENTFALLEN mit V-3 — Kombi-Target + Aggregator-Manifest |
| `messung_driver` | Driver-Binary (Plugins laden, binary records, Welch-Stats) |
| Tests `test_*` | 104 GTest-Tests |

## Hilfs-Skripte

| Befehl | Was |
|--------|-----|
| `make check` (Repo-Wurzel) | Selbsttests -- der offizielle Weg (GNU Standard Target) |
| `make testdata` (Repo-Wurzel) | Test-Daten holen; `TESTDATA_ARGS="--dataset <name>"` |

> **`Code/tools/` ist am 08.08.2026 entfallen** (Owner-Ansage: der offizielle Linux-Bauweg ist
> `configure.sh`/`make`/`make install`/`make check`). `run_all_tests.{sh,bat}` und
> `cross_compiler_matrix.sh` sind ersatzlos weg -- `make check` tut dasselbe, und zwar
> nachweislich: `run_all_tests.sh` suchte zuletzt drei Build-Verzeichnisse, die es nicht mehr
> gab, und meldete trotzdem Erfolg (`TOTAL_NOT_FOUND` ging nicht in den Exit-Code ein,
> Zeilen 191-194). `fetch_testdata.sh` ist als **Datenbeschaffer** erhalten geblieben und liegt
> jetzt unter `scripts/`; er wird ueber `make testdata` gerufen.

## CLion

Open `Code/` als Projekt → CMakePresets.json wird automatisch erkannt.
