# Architektur-Delta REV 7.6 — Drei-Repo-Schichten + Diplomarbeits-Code (2026-05-13)

**Status:** Delta-Erweiterung zu REV 7.5 + Architektur-Korrektur.
**Anlass:** User-Direktive 2026-05-13 (zwei Klarstellungs-Nachrichten):

1. *"Die Diplomarbeit hat ein Code-Verzeichnis, das den prt-art aufruft,
   Messergebnisse generiert und in LaTeX-PDF konvertiert."*
2. *"Die Diplomarbeit bestimmt WAS getestet wird, die CacheEngine bestimmt
   WIE es getestet wird. Demo-Workloads + Builder-Driver bleiben in
   cache-engine."*

---

## §1 Drei-Repo-Schichten-Klarstellung

```
┌──────────────────────────────────────────────────────────────────────┐
│  Diplomarbeit/Code/  =  WAS getestet wird + AUSWERTUNG                │
│  ─────────────────────────────────────────────────────────────────── │
│  XML-Configs der 3 Messreihen (compile-time-Aussage)                  │
│  Driver-Loop ueber 3 Messreihen                                       │
│  Binary-Records → CSV → LaTeX → PDF Post-Processing                   │
│                                                                       │
│  Module:                                                              │
│  ├── messung_driver/      → konsumiert ExperimentDriver-Lib          │
│  ├── binary_to_csv/       → deserialisiert cache-engine binary       │
│  ├── csv_to_latex/        → LaTeX-Tabelle + Baustein-Steckbrief      │
│  ├── diagram_generator/   → C++ → TikZ (A4-Awareness)                │
│  ├── latex_to_pdf/        → Manuskript-Wrapper um cache-engine-Toolchain│
│  └── experiment_config/   → XML pro Messreihe (A/B/C)                │
└──────────────────────────────────────────────────────────────────────┘
                       │
                       │ ruft auf via Submodule (parallel layout)
                       ▼
┌──────────────────────────────────────────────────────────────────────┐
│  comdare-prt-art  =  Test-Algorithmus PRT-ART + Mess-Interfaces       │
│  ─────────────────────────────────────────────────────────────────── │
│  Hybride PrtArtSearchEngine (REV 7.1: Vector-/Map-/Tuple-API)         │
│  8 Schichten Bausteine (Pool, OLC, Layout, Prefetch, Density, ...)    │
└──────────────────────────────────────────────────────────────────────┘
                       │
                       │ konsumiert als Submodule
                       ▼
┌──────────────────────────────────────────────────────────────────────┐
│  comdare-cache-engine  =  WIE gemessen wird + Bausteine + Werkzeuge   │
│  ─────────────────────────────────────────────────────────────────── │
│  Pipeline-Mechanik (Phase 1-7):                                       │
│  ├── cache_engine/builder/experiment_driver/  (NEU REV 7.6 Library)  │
│  ├── cache_engine/builder/{xml_parser,codegen,permutation_loop,      │
│  │                          module_loader,experiment_runner}         │
│  └── cache_engine/builder/main.cpp (Wrapper-Driver, REV 7.6)         │
│                                                                       │
│  Bausteine (Library):                                                 │
│  ├── 23 Allokator-Familien (A01-A23)                                  │
│  ├── 33 Such-Algorithmen-Adapter + 14 LEGACY_REIMPL                  │
│  ├── workload_generator/ (YCSB-A..F, Zipfian)                        │
│  ├── experiment/ (ResultAggregator)                                  │
│  ├── benchmark_suite/ (Mikrobenchmarks)                              │
│  ├── succinct/ (BitVector + LOUDS, P09)                              │
│  └── cache_engine/reclamation/rcu_reclaim/ (eigene RCU)              │
│                                                                       │
│  Generische Werkzeuge:                                                │
│  ├── tools/ycsb_cli/       (Vorab-CSV-Generierung)                   │
│  ├── tools/latex_anhang/   (CSV → LaTeX, generic)                    │
│  ├── tools/latex_toolchain/ (pdflatex-Pipeline)                      │
│  └── tools/permutation_codegen/ (CMake/sh/bat NO-PYTHON)             │
└──────────────────────────────────────────────────────────────────────┘
```

---

## §2 Verantwortlichkeiten-Matrix (User-Direktive)

| Aspekt | cache-engine | Diplomarbeit/Code |
|---|---|---|
| Mess-Mechanik (Phase 1-7) | ja | nein |
| Builder-Executable | ja | nein |
| ModuleLoader (LoadLibrary/dlopen) | ja | nein |
| Demo-Workloads (YCSB-Generator-Library) | ja | nein |
| Mikrobenchmark-Suite | ja | nein |
| ResultAggregator (binary records) | ja | nein |
| **Welche 3 Messreihen?** | nein | **ja** |
| **XML-Config (compile-time)** | nein | **ja** |
| **Binary → CSV Post-Processing** | partial | **ja, eigene Variante** |
| **CSV → LaTeX-Tabelle + Algo-Steckbrief** | nein | **ja** |
| **C++ → TikZ Diagramm-Generator** | nein | **ja** |
| **LaTeX → PDF Pipeline** | partial | **ja, Wrapper** |

---

## §3 Konkrete Aenderungen heute (REV 7.6)

### §3.1 cache-engine: ExperimentDriver-Library + main.cpp-Wrapper

**Commit `05b41a8` (REV 7.6 Q4):**
- NEU: `cache_engine/builder/experiment_driver/{hpp,cpp,CMakeLists.txt}`
  - Klasse `comdare::builder::ExperimentDriver`
  - 5 Phasen-Methoden (phase1..7), `run_pipeline_full()`
  - 7 Status-Codes (errno-style)
- main.cpp Wrapper-Refactoring: 165 → 82 Zeilen, ruft Library auf
- E2E-Verifikation: "Demo pipeline OK" mit example_configs (54 DLLs)

**Commit `e2dc290` (gitignore-Bugfix):**
- `tools/latex_toolchain/latex_toolchain.cmake` war silent vom
  `*.cmake`-Pattern ignoriert — Whitelist erweitert
- `tools/permutation_codegen/codegen.cmake` — gleicher Fix
- Beide Files jetzt committed + im Submodule sichtbar

### §3.2 Diplomarbeit/Code/ — komplett neue Anwender-Schicht

```
Diplomarbeit/Code/
├── CMakeLists.txt                    (top-level C++23, ruft submodules)
├── README.md                         (Anwender-Doku)
├── .gitignore                        (build/, _runs/)
├── external/
│   ├── comdare-prt-art/             Submodule  3e8044b
│   └── comdare-cache-engine/        Submodule  e2dc290
├── messung_driver/
│   ├── main.cpp                     (3-Messreihen-Loop)
│   └── CMakeLists.txt
├── binary_to_csv/
│   ├── binary_to_csv.{hpp,cpp}      (kBinaryMagic 0xC0FFEE02)
│   ├── main_cli.cpp                  (binary-to-csv Executable)
│   └── CMakeLists.txt
├── csv_to_latex/
│   ├── csv_to_latex.{hpp,cpp}        (mit generate_baustein_description)
│   ├── main_cli.cpp                  (csv-to-latex Executable)
│   └── CMakeLists.txt
├── diagram_generator/
│   ├── diagram_generator.{hpp,cpp}   (Bar+Scatter+Heatmap → TikZ)
│   ├── main_cli.cpp                   (diagram-generator Executable)
│   └── CMakeLists.txt
├── latex_to_pdf/
│   ├── build_thesis.sh + .bat         (POSIX + Windows Frontend)
│   └── CMakeLists.txt
├── experiment_config/
│   ├── config_a_prt_art_vs_sota.xml    (Messreihe A)
│   ├── config_b_cache_engine_perms.xml  (Messreihe B)
│   └── config_c_merge_alt_neu.xml       (Messreihe C)
└── tests/
    ├── CMakeLists.txt
    └── unit/
        ├── test_binary_to_csv.cpp
        ├── test_csv_to_latex.cpp
        └── test_diagram_generator.cpp
```

**Configure-Verifikation:** `cmake -B build` OK (26.5s configure, 13.8s
generate, exit 0).

### §3.3 Submodule-Layout (REV 7.6 Q2: parallel)

`.gitmodules` in Diplomarbeit:

```ini
[submodule "Code/external/comdare-prt-art"]
    path = Code/external/comdare-prt-art
    url  = https://github.com/BenniProbst/comdare-prt-art.git

[submodule "Code/external/comdare-cache-engine"]
    path = Code/external/comdare-cache-engine
    url  = https://github.com/BenniProbst/comdare-cache-engine.git
```

Beide auf Top-Level + parallel (kein Submodule-Tiefe-2-Nesting).

---

## §4 Was sich gegenueber den 5 vorherigen REV-7.X-Docs aendert

| Doc | Status | Korrektur |
|---|---|---|
| 25 hybrid_search_engine | OK | unveraendert |
| 26 legacy_reimpl | OK | unveraendert |
| 27 ycsb_cli | **Bleibt** in cache-engine — Demo-Workload-Tool ist Werkzeug |
| 28 cmake_pipeline | OK | unveraendert (Builder bleibt cache-engine) |
| 29 phase4_7_loader | OK | unveraendert (ModuleLoader bleibt cache-engine) |
| **30 REV 7.6 (this)** | NEU | drei-Repo-Schichten geklarrt, Diplomarbeit/Code/ angelegt |

---

## §5 Verifikations-Status

| # | Test | Status |
|---|---|---|
| V1 | cache-engine `comdare-cache-engine-builder` baut + E2E "Demo pipeline OK" | DONE |
| V2 | cache-engine ExperimentDriver-Library separat compile-bar | DONE |
| V3 | cache-engine latex_toolchain.cmake im git getrackt | DONE (e2dc290) |
| V4 | Diplomarbeit/Code/ Submodule init OK | DONE (e2dc290 + 3e8044b) |
| V5 | Diplomarbeit/Code/ cmake -B build configure | DONE (26.5s, 0 errors) |
| V6 | Diplomarbeit/Code/ Full-Build alle Targets | OFFEN (lange Zeit) |
| V7 | Diplomarbeit/Code/ ctest (5 Module-Tests) | OFFEN |
| V8 | E2E: messung_driver führt 3 Messreihen aus | OFFEN — nach Full-Build |

---

## §6 Naechste Schritte

- **Doku** (jetzt): committen + push aller 3 Repos
- **V6 Full-Build:** vom User selbst (in CLion) erwartet — 30 Min+
- **V7 ctest:** nach V6
- **V8 E2E:** sobald V6+V7 OK, dann erste Messreihen-Run
- **Manuskript (`thesis/main.tex`)** noch nicht existent — separate Aufgabe

---

## §7 Querverweis

- STRUCTURAL_CORRECTION_2026_05_13.md (Master-Doku mit Original-Nachricht + Q1-Q4)
- 24_architektur_skizze_REV7_2026_05_13.md (Basis-REV-7 Architektur)
- 25-29 (vorherige REV 7.X Deltas)
- Code-Repos:
  - comdare-cache-engine: `e2dc290` (gitignore-Fix + ExperimentDriver-Lib)
  - comdare-prt-art:      `3e8044b` (unveraendert seit gestern)
  - Diplomarbeit:         heute commit + push (PROJECT_LAYER_MAP update + Code/ neu)
