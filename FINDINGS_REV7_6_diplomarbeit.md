# FINDINGS REV 7.6 — Diplomarbeit (2026-05-13)

**Status:** **MASTER-Dokument** der heutigen Findings + Korrekturen. Konsolidiert
alle drei Repos, da die Diplomarbeit selbst das **WAS**-Repo ist und damit
die Architektur-Hoheit haelt.

**Schwester-Dokumente** (gleicher Sprint, pro Repo):
- comdare-cache-engine: `FINDINGS_REV7_6_cache_engine.md`
- comdare-prt-art: `FINDINGS_REV7_6_prt_art.md`
- Habich-Termin-Zusammenfassung: `20260508 Termin 7/HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md`

---

## §1 Drei-Repo-Architektur (User-Direktive, hoechste Praezision)

```
Diplomarbeit/Code/  =  WAS + AUSWERTUNG    (Anwender)
       │
       ▼ (Submodule, parallel)
comdare-prt-art      =  Test-Algorithmus  (Pruefling)
       │
       ▼ (Submodule)
comdare-cache-engine =  WIE gemessen wird  (Werkzeug + Bibliothek + Mechanismus)
```

### Konkrete Aufteilung (User-Direktive 2026-05-13)

| Aspekt | Repo | Begruendung |
|---|---|---|
| Mess-Mechanismus (Phase 1-7 Driver) | cache-engine | "Die CacheEngine bestimmt WIE getestet wird" |
| Builder-Executable | cache-engine | "Modul-loads und -builds sind Teil der Cache-Engine" |
| Demo-Workloads (YCSB-Library) | cache-engine | "Die Demo workloads sind Bibliothek-Bestandteil der cache-engine" |
| Mikrobenchmark-Suite | cache-engine | "echte Messmodule und Mikrobenchmarks wie gehabt" |
| Precompiled-C++23-Module-Loading | cache-engine | "laed precompiled C++23 modules adhoc" |
| XML-Configs (compile-time-Ausprägung) | Diplomarbeit | "Die Diplomarbeit bestimmt nur die Compiletime Auspraegung ueber die Definition einer Konfigurationsdatei xml" |
| Binary → CSV → LaTeX → PDF Auswertung | Diplomarbeit | "Die Diplomarbeit verarbeitet die Ergebnisse weiter" |
| 3 Messreihen (A/B/C) Definition | Diplomarbeit | "Die Diplomarbeit bestimmt WAS getestet wird" |

---

## §2 FINDING 1 — Diagnose-Output beim Library-Refactoring verloren

**Schwere:** HOCH (kritische Mess-Mechanik-Doku).

### Was war im alten main.cpp (vor REV 7.6)?

Pro Pipeline-Phase ein detaillierter `std::cout`-Output:

```
==== CacheEngineBuilder Phase 7.2 ====
Config:   /path/to/example_configs
Output:   /path/to/output
Mode:     full pipeline
Comdare-Root: /path/to/repo

[Phase 1] Parsed XML configs:
  cache_engine_permutations:     3
  search_algorithm_permutations: 3
  allocator_permutations:        3
  test_data_sets:                 2
  Enumerated 54 permutations.

[Phase 2] Generating 54 modules ...
  Generated: ce_lockfree:art:tcmalloc:ycsb_c
  Generated: ce_hardened:hot:mimalloc:commoncrawl
  ... (54 Lines)
  Aggregator: /path/to/generated/CMakeLists.txt

[Phase 3] Configuring cmake subbuild under /path/to/build-perms ...
  $ cmake -S "..." -B "..."
  $ cmake --build "..." --target comdare_all_permutations
[Phase 3] OK — all 54 permutation modules built.

[Phase 4] Loading permutation modules from /path/to/Debug ...
[Phase 4] Loaded 54 of 54 modules.

[Phase 5+6] Running workload (500 ops) against 54 modules ...
[Phase 5+6] Collected 54 measurement records.

[Phase 7] Wrote /path/to/measurements.csv
[Phase 7] Wrote /path/to/measurements.json
[Phase 7] Unloaded all modules.
```

### Was im REV 7.6 Wrapper (nach Library-Refactoring) verblieb:

```
==== CacheEngineBuilder Demo Wrapper (REV 7.6) ====
Config       : /path/to/example_configs
Output       : /path/to/output
Comdare-Root : /path/to/repo

Demo pipeline OK.
```

**ALLE Phase-1-bis-7 Diagnose-Outputs sind verloren.**

### Root-Cause

Beim Refactoring wurde die Phase-Logik in `ExperimentDriver`-Methoden
verschoben, aber die `std::cout`-Calls **nicht** in die Methoden mit-
verschoben. Sie wurden im main.cpp **stillschweigend geloescht**.

### Korrektur (F2 + F3)

- **F2:** `ExperimentDriver::phase1..phase7` ergaenzen jeden Output, der
  vorher in main.cpp stand. Default-Behavior: alle Diagnose-Outputs via
  `std::cout`. Optional via `Logger`-Hook abstellbar.
- **F3:** main.cpp Wrapper bekommt zurueck:
  - Mode-Banner ("full pipeline" / "enumerate-only" / "generate-only")
  - `--enumerate-only`-Loop ueber alle descriptors mit hex-fingerprint

---

## §3 FINDING 2 — `*.cmake`-gitignore-Pattern hat 2 wichtige Files verschluckt

**Schwere:** HOCH (Build-blockierend bei Submodule-Konsum).

### Was war broken?

`.gitignore` enthielt:
```
*.cmake
!cmake/*.cmake
```

→ `tools/latex_toolchain/latex_toolchain.cmake` und
  `tools/permutation_codegen/codegen.cmake` waren silent von Git ignoriert.

Im Hauptrepo: Files lagen im Working-Tree. Build OK.
Im Submodule-Konsum (Diplomarbeit/Code/external/comdare-cache-engine/):
Files fehlten → CMake-Error "File does not exist".

### Korrektur

```
*.cmake
!cmake/*.cmake
!tools/permutation_codegen/*.cmake   # NEU REV 7.6
!tools/latex_toolchain/*.cmake       # NEU REV 7.6
```

cache-engine commit `e2dc290`: Whitelist erweitert + beide Files
committed.

### Lesson Learned

Vor jedem Submodule-Pin-Bump verifizieren: `git ls-tree -r HEAD <dir>`
muss alle erwarteten Files anzeigen. Silent gitignore-Konflikte
verstecken sich oft hinter generischen Patterns.

---

## §4 FINDING 3 — 3 Messreihen sind Diplomarbeits-spezifisch

Die XML-Configs unter `Diplomarbeit/Code/experiment_config/`:

| Datei | Messreihe | Beschreibung |
|---|---|---|
| `config_a_prt_art_vs_sota.xml` | A | PRT-ART (hybride API) gegen 8 Stand-der-Technik-Adapter (ART, HOT, Masstree, CoCo-Trie, START, B2tree, Wormhole, SuRF) |
| `config_b_cache_engine_perms.xml` | B | Bestehende cache-engine Permutationen (SOTA-only) |
| `config_c_merge_alt_neu.xml` | C | 4 konkrete Merge-Punkte: PRT-ART OLC + tcmalloc + ART, 4+2-Pool + HOT, PathPrefetch + B2tree, MultiLevelLayout + Wormhole |

**Diese 3 Configs sind die zentrale Definition von "WAS getestet wird".**

`messung_driver/main.cpp` loopt ueber diese 3 + ruft pro Messreihe
`ExperimentDriver::run_pipeline_full()` mit messreihen-spezifischer
Workload-Konfiguration auf.

---

## §5 FINDING 4 — Submodule-Layout parallel (REV 7.6 Q2)

```
Diplomarbeit/Code/external/
├── comdare-prt-art/         (Submodule, HEAD 3e8044b)
└── comdare-cache-engine/    (Submodule, HEAD e2dc290)
```

**Vorteil:** Kein Submodule-Tiefe-2-Nesting. Direkte Pins beider Repos.
**Nachteil:** prt-art hat IN seinem eigenen Repo ein
`external/comdare-cache-engine/` Submodule — das wird nicht von
Diplomarbeit konsumiert (Diplomarbeit nutzt ihre OWN cache-engine-
Submodule-Kopie).

**Konsequenz fuer Build:** Diplomarbeit/Code/CMakeLists.txt explizit
auf `${COMDARE_CACHE_ENGINE_DIR}` setzen, nicht auf prt-arts
`external/comdare-cache-engine/`.

---

## §6 FINDING 5 — TikZ statt matplotlib fuer Diagramme (REV 7.6 Q3)

User-Entscheidung: **TikZ-Code generieren**.

### Vorteile

- **Kein Python** (F-EXTRA-5-konform)
- **A4-Awareness durch LaTeX-Layout** (`\textwidth`, `\textheight`)
- Diagramme automatisch korrekt positioniert (PageConstraints)
- TikZ-Code direkt in Manuskript einbindbar

### Implementation (in Diplomarbeit/Code/diagram_generator/)

```cpp
struct PageConstraints {
    double width_fraction      = 0.95;   // * \textwidth
    double height_fraction     = 0.40;   // * \textheight
    bool   keep_aspect_ratio   = true;
    std::string position_hint  = "!htbp";  // LaTeX-Float
};
```

3 Plot-Typen: `BarChartData`, `ScatterData`, `HeatmapData` →
TikZ/pgfplots-Output.

---

## §7 FINDING 6 — Hybride PrtArtSearchEngine (REV 7.1) bleibt unveraendert

Die heutige Architektur-Korrektur betrifft NICHT die hybride API:

- 1 Param = std::vector-API
- 2+ Params = std::map-API (mit tuple-Magic fuer N>2)
- Schreiboperatoren = `status_t` (errno-style, 0=ok)

Verbleibt in `comdare-prt-art/prt_art/include/prt_art/identity/`.
Die prt-art-Bibliothek wird von der Diplomarbeit-Code-Schicht via
Submodule-Pfad konsumiert.

---

## §8 FINDING 7 — ExperimentDriver-Library + main.cpp Wrapper-Pattern (REV 7.6 Q4)

### Library (cache_engine/builder/experiment_driver/)

```cpp
namespace comdare::builder {
    class ExperimentDriver {
        int phase1_enumerate(std::vector<PermutationDescriptor>&);
        int phase2_generate(std::vector<PermutationDescriptor> const&);
        int phase3_compile();
        int phase4_load(std::vector<ModuleHandle>&);
        int phase5_run_workload(std::span<ModuleHandle>, WorkloadOptions const&,
                                 std::vector<PermutationDescriptor> const&,
                                 ResultAggregator&);
        int phase7_export(ResultAggregator const&);
        int run_pipeline_full(WorkloadOptions const&);
    };
}
```

### Library-Konsumenten

1. **cache-engine main.cpp** — Demo-Wrapper, ruft `run_pipeline_full()`
2. **Diplomarbeit/Code/messung_driver/main.cpp** — 3-Messreihen-Loop, ruft
   `run_pipeline_full()` separat pro Messreihe (A/B/C)

### Konsequenz fuer Diagnose-Output

Diagnose muss in der Library sein (nicht in main.cpp), damit BEIDE
Konsumenten den gleichen Output bekommen. → F2

---

## §9 KONSOLIDIERTER STAND DER 3 REPOS

| Repo | Aktueller HEAD | Aenderungen heute |
|---|---|---|
| comdare-cache-engine main | `e2dc290` | REV 7.6 ExperimentDriver-Lib + gitignore-Fix |
| comdare-prt-art development | `3e8044b` | unveraendert seit gestern |
| probst-Diplomarbeit-cache-engine main | `21aa4d8` | REV 7.6 Code/-Skelett + Submodules + Delta 30 + STRUCTURAL_CORRECTION |

### Noch ausstehende Korrekturen (heute):

1. **F2+F3:** Diagnose-Output wiederherstellen → cache-engine
2. **F4+F5+F6:** PROJECT_LAYER_MAP.md aller 3 Repos um REV 7.6 erweitern
3. **F7:** E2E-Verifikation
4. **F8:** Commits + Pushes + Submodule-Pin-Bumps

---

## §10 Querverweis

- STRUCTURAL_CORRECTION_2026_05_13.md (Master + Original-Nachricht §10, Q1-Q4)
- 20260508 Termin 7/Phase5_UML_Detail/30_architektur_delta_REV7_6_drei_repo_layer_2026_05_13.md
- 24_architektur_skizze_REV7_2026_05_13.md (Basis-REV-7 Architektur)
- Code-Repos:
  - github.com/BenniProbst/comdare-cache-engine (`e2dc290` + heute REV 7.6 Diagnose-Fix)
  - github.com/BenniProbst/comdare-prt-art (`3e8044b`)
  - github.com/BenniProbst/probst-Diplomarbeit-cache-engine (`21aa4d8` + heute LAYER_MAP-Update)
