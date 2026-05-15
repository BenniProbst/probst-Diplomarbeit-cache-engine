# Audit der existierenden Projekt-Struktur: comdare-cache-engine + comdare-prt-art

**Stand:** 2026-05-11
**Zweck:** Bestandsaufnahme VOR Phase-6-Implementierungs-Verschiebung in die existierenden comdare-* Repos
**Methode:** Tiefenanalyse der Top-Level-Verzeichnisse, CMake-Dateien, Python-Codegen-Skripte sowie Existenz-Check vorhandener REV-5.3-Headern unter Diplomarbeit/code
**Audit-Ziel:** Welche REV-5.3-Architektur-Aspekte sind bereits skelettiert, welche fehlen vollstaendig, welche Namens- und Build-Konventionen gelten

---

## 0. Executive Summary (vorab)

`comdare-cache-engine` ist ein **strukturell vollstaendig vorbereitetes Skelett-Repository** mit
- 1x Top-Level `CMakeLists.txt` (C++23, CMake 3.28+, Apache 2.0, F-EXTRA-1-konform)
- 7 Domaenen-Subdirectories (`measurement`, `hardware_isa`, `search_engine`, `cache_engine`, `engine_choice`, `prt_art`, `adapters`, `ext`, `benchmarks`, `tests`, `tools`, `datasets`, `modules`)
- 56 Sub-Komponenten als CMake-INTERFACE-Library-Stubs (Header-only, leer)
- 12 geklonte Originalcode-Repos in `ext/` (Habich-Direktive F-EXTRA-1: bit-identische Kopie)
- 14 LEGACY_REIMPL-Skelette in `prt_art/legacy_reimpl/` mit README, leerer hpp und CMake-Stub
- 4 Top-Level Python-Skripte (Setup-Generierung) + 1 Python-Codegen in `tools/permutation_codegen/`
- vollstaendige Lizenz-Doku unter `docs/lizenzen/`, NOTICE, LICENSE

`comdare-prt-art` ist **fast leer** — enthaelt nur 1 Datei: die 35 GPT-Fragen-und-Antworten zum PRT-ART-Algorithmus.

Die **REV-5.3-Architektur-Header** (PressureState, ICacheEngine, ISubEngine, CacheRecommendation, PlatformSnapshot, RequestContext, CpuidProbe) existieren bereits unter `Diplomarbeit - Datenbanken/code/cache_engine/include/cache_engine/concepts/` und sollten in die Skelett-Slots des `comdare-cache-engine` migriert werden.

**Namespace-Schema-Konflikt:** Skelett verwendet `comdare::*` (gemaess MEMORY.md K19), REV-5.3-Header verwenden `prt_art::cache_engine::*`. Vereinheitlichung erforderlich.

---

## A) Top-Level Dateien und Verzeichnisse von `comdare-cache-engine`

### A.1 — `README.md` (123 Zeilen)

Beschreibt das Projekt als
- TU Dresden Diplomarbeit, Apache 2.0, BEP Venture UG / Marke Comdare
- **Status:** Phase 4.B Skelett (KEINE Implementation)
- 6 Domaenen gem. Domaenenmodell v3+v4: SearchEngine, CacheEngine, Measurement, HW/ISA, EngineChoice, Publication
- Habich-Direktive F-EXTRA-1: Originalcode `ext/<paper>/` bit-identisch + Adapter-Pattern `adapters/<paper>/`
- Hauptcompiler IMMER C++23 (GCC 14+ / Clang 17+ / MSVC 19.39+), Original-Bausteine mit ihren Original-Compilern
- Build-Modi F9: COMPILE_TIME vs RUNTIME mutually exclusive, sowie COMDARE_BUILD_PERMUTATIONS fuer den Permutations-Pre-Build
- 11/33 Repos geklont, 14 Re-Implementations noetig, 6 Email-Anfragen ausstehend
- Plattform-Workflow F13: Pi 5/VisionFive 2 (self-built compiler), x86-Server/ODROID H4 (CI), ZIH (cross-compile)
- Submodule-Ausnahme F12-K: `modules/comdare-*` nur in diesem Projekt
- Phasen 4.B → 5 (UML) → 6 (Implementation) → 7 (Permutations) → 8 (LaTeX)

### A.2 — `CMakeLists.txt` (85 Zeilen)

- `cmake_minimum_required(VERSION 3.28)` — fuer C++23 Modules-Support
- `project(comdare-cache-engine VERSION 0.1.0 LANGUAGES CXX)`
- `CMAKE_CXX_STANDARD 23, CMAKE_CXX_STANDARD_REQUIRED ON, CMAKE_CXX_EXTENSIONS OFF`
- `COMDARE_DETECTION_MODE` Cache STRING mit STRINGS `COMPILE_TIME, RUNTIME`
- 5 `option(...)`: BUILDER, BENCHMARKS, TESTS, PERMUTATIONS, MICROBENCH_CONTINUOUS
- `include(cmake/check_submodules.cmake OPTIONAL)` — pruft Submodules-Verfuegbarkeit (modules/comdare-*)
- bei `COMDARE_BUILD_PERMUTATIONS`: `include(cmake/permutations.cmake OPTIONAL)` — ruft `tools/permutation_codegen/codegen.py` auf (F-EXTRA-5 Verletzung!)
- 8 add_subdirectory: measurement, hardware_isa, search_engine, cache_engine, engine_choice, prt_art, adapters, ext
- + benchmarks (option), + tests (option)

### A.3 — `NOTICE` (309 Zeilen)

- Apache 2.0 Copyright Header
- Third-Party Software Notices fuer 12 Repos (P01, P02, P03, P04, P05, P06, P07, P10, P20, P25, P29, P30)
- Pro Repo: Project, Source URL, Path, License, Copyright, Reference, PRT-ART role
- External Concepts (kein Code in `ext/`): P09, P11-P19, P21-P24, P26-P28, P31-P33
- Tooling Dependencies: GoogleTest BSD-3, HdrHistogram_c BSD-2, PAPI BSD-3, perf_event GPL-2 kernel, Intel Advisor proprietary, SDSL GPL-3, tcmalloc/mimalloc/snmalloc
- Verweise auf `docs/lizenzen/`, `docs/email/`, `Forschungsarbeiten/code/REPO_INVENTAR_FINAL.md`

### A.4 — `.gitmodules.template` (42 Zeilen)

Vorlage fuer 6 COMDARE-Submodules (Ausnahme zur globalen No-Submodules-Regel):
- `modules/comdare-search-engine` → `git@gitlab.comdare.de:comdare/search-engine.git`
- `modules/comdare-cache-engine-core`
- `modules/comdare-measurement`
- `modules/comdare-isa-dispatch`
- `modules/comdare-build-tools`
- `modules/comdare-test-system`

**Wichtig:** Datei umbenennen zu `.gitmodules` erst NACH Cluster-Migration und GitLab-Setup. Aktuell ist `modules/` **leer**.

### A.5 — `cmake/` Verzeichnis (2 Module)

| Modul | Zweck |
|-------|-------|
| `check_submodules.cmake` | Prueft 6 erwartete `modules/comdare-*`-Submodules; Warning bei Fehlen, kein FATAL — Skelett-Build moeglich. |
| `permutations.cmake` | `find_package(Python3 REQUIRED)`, ruft `tools/permutation_codegen/codegen.py` auf, schreibt `build/generated/permutations.cmake`. **VERLETZT F-EXTRA-5** (KEIN Python in Build-Pipeline). |

### A.6 — `docs/` Verzeichnis (8 Kategorien + INDEX.md)

| Verzeichnis | Inhalt |
|-------------|--------|
| `architecture/` | `20260504-2300-architektur_referenzen.md` (Verweise auf Termin-7-Quellen), INDEX.md |
| `architekturentscheidungen/` | LEER (Skelett-Slot) — F1-F15 + F-EXTRA-1-8 kommen aus Termin 7 |
| `bausteine/` | LEER (Skelett-Slot) — Bausteine-Matrix kommt aus Termin 7 |
| `domaenenmodell/` | LEER (Skelett-Slot) |
| `glossare/` | LEER (Skelett-Slot) |
| `email/` | 9 Dokumente — Email-Kontakte, Folge-Mails, Bounce-Followups, Zhang-Recherche |
| `lizenzen/` | `20260508-1500-lizenzen_uebersicht.md` (Lizenz-Analyse aller 12 Repos), INDEX.md |
| `status/` | `20260508-1600-status_projekt.md`, INDEX.md |

**Top-3-5 wichtigste Dokumente** (laut INDEX.md):
1. `status/20260508-1600-status_projekt.md` — Phase 4.B-detail Abschluss-Report
2. `email/20260508-1800-email_kontakte.md` — REV 2 mit Vollangaben-Regel
3. `lizenzen/20260508-1500-lizenzen_uebersicht.md` — Lizenz-Analyse aller geklonten Repos
4. `architecture/20260504-2300-architektur_referenzen.md` — Verweise auf Termin-7-Quellen
5. `email/20260508-1700-email_habich_folge_klarstellung.md` — Habich-Klarstellung

**Datei-Namenskonvention:** `YYYYMMDD-HHMM-<lowercase_kebab_or_snake_case>.md` — diese kanonische Konvention sollte beim Hinzufuegen neuer Docs aus Diplomarbeit/code weitergefuehrt werden.

### A.7 — `cache_engine/` Verzeichnis (Domaene 2 KERNBEITRAG)

Top-Level CMakeLists: `add_subdirectory(builder); add_subdirectory(concurrency_manager); add_subdirectory(subsystems); add_subdirectory(reclamation)`.

#### `cache_engine/builder/` — 15 Sub-Komponenten

Alle aktuell als INTERFACE-Library mit ausschliesslich `CMakeLists.txt`-Stub (KEIN Code).

| Sub-Komponente | Erwartete Funktion (aus README + REV 5.3) |
|----------------|--------------------------------------------|
| `algorithm_visitor` | Visitor zur Geometrie-Bestimmung pro Algorithmus-Strategie |
| `cache_engine_component` | Haupt-CacheEngine-Singleton |
| `compile_time_knowledge` | constexpr-/Concept-Knowledge-Basis (F9 COMPILE_TIME) |
| `decision_lambda_trees` | Decision-Trees fuer Sub-Engine-Wahl |
| `disk_serializer` | MeasurementBuffer → Disk Dump |
| `in_memory_measurement_buffer` | RAM-Side Measurement-Buffer |
| `latex_renderer` | F-EXTRA: LaTeX-Anhang-Generator (Phase 8) |
| `live_cpu_model` | Runtime-CPU-Modell (F9 RUNTIME) |
| `measurement_matrix` | Plattform×Algorithmus-Achsen-Matrix |
| `module_loader` | Permutations-Modul-Loader |
| `observer_registry` | Observer-Pattern Registry |
| `permutation_engine` | enumeriert valide Permutationen |
| `platform_probe` | (Builder-Sicht — UNTERSCHEIDET sich von `measurement/platform_probe` und `cache_engine/subsystems/platform_profiler`!) |
| `runtime_micro_benchmarks` | Mikrobenchmarks fuer Live-Calibration |
| `telemetry_spool` | Telemetry-Spool (FIFO) |

#### `cache_engine/concurrency_manager/` — 8 Sub-Komponenten

Alle CMakeLists-Stubs ohne Code:
- `array_concurrency`
- `data_structure_concurrency`
- `memory_access_concurrency`
- `node_concurrency`
- `page_concurrency`
- `path_concurrency`
- `simd_flow_concurrency`
- `simd_thread_concurrency`

#### `cache_engine/reclamation/` — 1 Sub-Komponente

- `rcu_reclaim` (Stub — laut Task #104 soll Phase 6 eine eigene RCU-Implementation statt liburcu liefern)

#### `cache_engine/subsystems/` — 7 Sub-Komponenten

Alle CMakeLists-Stubs ohne Code:
- `allocator_manager`
- `cost_model`
- `page_type_scheduler`
- `platform_profiler`
- `prefetch_controller`
- `relocation_manager`
- `telemetry_aggregator`

### A.8 — `search_engine/` Verzeichnis (Domaene 1)

8 Sub-Komponenten, alle CMakeLists-Stubs:
- `algorithm_strategies` (Strategy-Pattern fuer 4 ART-Suchtypen)
- `fan_out_engine`
- `memory_layout`
- `node`
- `operations`
- `page`
- `traversal`
- `value_handle`

### A.9 — `prt_art/` Verzeichnis (Eigener Algorithmus + Legacy-Reimpls)

9 Sub-Komponenten, alle CMakeLists-Stubs:
- `allocator`
- `concurrency`
- `legacy_reimpl/` (14 Paper-Reimpls, siehe unten)
- `memory_layout`
- `nodes`
- `pages`
- `prefetch`
- `traversal`
- `value_handles`

#### `prt_art/legacy_reimpl/` — 14 Re-Implementations-Skelette

Jedes Skelett hat: `CMakeLists.txt` (kommentierter Stub), `README.md` (Pseudocode-Plan + Habich-Direktive Zitat), `include/<hpp_name>.hpp` (leerer Concept-Stub mit namespace `comdare::prt_art::legacy_reimpl::<sub>`), `src/.gitkeep`, `tests/.gitkeep`.

| Skelett | Paper | Achse |
|---------|-------|-------|
| P11-CSS-tree | Rao/Ross 1999 | Page-Type |
| P12-CSB-tree | Rao/Ross 2000 | Page-Type |
| P13-Hankins | Hankins/Patel 2003 | Page-Type |
| P14-Samuel | Samuel/Pedersen/Bonnet 2005 | Page-Type |
| P16-Bender-TreeLayout | Bender/Demaine/Farach-Colton 2002 | Memory-Layout |
| P17-Bender-CacheOblivious | Bender/Demaine/Farach-Colton 2005 | Memory-Layout |
| P18-Saikkonen-MultiLevel | Saikkonen/Soisalon-Soininen 2008 | Memory-Layout/Allocator |
| P19-Saikkonen-LayoutInvariant | Saikkonen/Soisalon-Soininen 2016 | Memory-Layout |
| P21-Chen-PrefetchBPlus | Chen/Gibbons/Mowry 2001 | Prefetch |
| P22-Chen-Fractal | Chen et al. 2002 | Page-Type/Prefetch |
| P23-Khan-AdaptivePrefetch | Khan 2010 | Prefetch |
| P24-NaderanTahan | Naderan-Tahan/Sarbazi-Azad 2016 | Measurement |
| P26-Zhang-FGCS | Q. Zhang et al. FGCS 2024 | Prefetch/Measurement |
| P27-Zhang-ASPLOS-Hierarchical | T. Zhang et al. ASPLOS 2025 | Prefetch |

### A.10 — `modules/` Verzeichnis

LEER. Wartet auf GitLab-Setup + Submodule-Init via Cluster-Migration.

### A.11 — `adapters/` Verzeichnis (Habich-Direktive)

Top-Level `CMakeLists.txt` + 11 leere Paper-Verzeichnisse:
- P01-ART, P02-HOT, P03-Masstree, P04-CoCo-trie, P05-START, P07-Wormhole, P10-SuRF, P20-BTreesAreBack, P25-Mahling, P29-RCU, P30-HazardPointers

KEIN Code — diese sind die Skelette fuer die C++23-Wrapper, die in `ext/<paper>/<repo>/` die Original-Compilate aufrufen. **Task #79** ist `pending`.

### A.12 — `benchmarks/` Verzeichnis

3 Sub-Komponenten, alle CMakeLists-Stubs:
- `microbenchmarks`
- `platform_calibration`
- `ycsb` (YCSB A-F + 6 Custom-Korpora)

### A.13 — `datasets/` Verzeichnis

LEER (kein CMakeLists, keine Inhalte). **Task #81/#82** ist `pending` — Datasets-Implementation und OP-1 bis OP-6 sind noch offen.

### A.14 — `engine_choice/` Verzeichnis

NUR Top-Level CMakeLists.txt — keine Sub-Komponenten. Domaene 5: StaticEngine vs CacheEngine als Compile-Time Template-Parameter.

### A.15 — `hardware_isa/` Verzeichnis (Domaene 4)

4 Sub-Komponenten:
- `hugepage_manager`
- `hybrid_core_pinning`
- `isa_dispatch`
- `memory_type_detector`

### A.16 — `measurement/` Verzeichnis (Domaene 3)

7 Sub-Komponenten:
- `advisor_wrapper`
- `dataset_loader`
- `hdr_histogram_wrapper`
- `papi_wrapper`
- `perf_wrapper`
- `platform_probe` (UNTERSCHIEDLICH von `cache_engine/builder/platform_probe` und `subsystems/platform_profiler`!)
- `run_recorder`

### A.17 — `tools/` Verzeichnis

5 Tool-Skelette:
- `abi_stability_test/` (README only)
- `compiler_provisioning/` (README only — F-EXTRA-4 Cross-Compile-Toolchain)
- `gitlab_ci_zih_push/` (README only)
- `permutation_codegen/codegen.py` (47 Zeilen Skelett — VERLETZT F-EXTRA-5!)
- `socks5_zih_delivery/` (README only)

### A.18 — `tests/` Verzeichnis

4 Sub-Komponenten, alle CMakeLists-Stubs:
- `generic_module_tests`
- `integration`
- `module_specific_tests`
- `unit`

### A.19 — `ext/` Verzeichnis (33 Paper-Source-Repos — bit-identische Originale)

Top-Level CMakeLists + 12 Paper-Verzeichnisse:

| Verzeichnis | Sub-Repo |
|-------------|----------|
| P01-ART | unodb |
| P02-HOT | hot |
| P03-Masstree | masstree-beta |
| P04-CoCo-trie | CoCo-trie |
| P05-START | START |
| P06-B2tree | b2-tree-master, bart-master |
| P07-Wormhole | wormhole |
| P10-SuRF | SuRF |
| P20-BTreesAreBack | leanstore |
| P25-Mahling | prefetching |
| P29-RCU | userspace-rcu |
| P30-HazardPointers | haz_ptr |

Diese 12 Repos enthalten die ECHTEN Originalcode-Quellen (in eigenen Lizenzen, siehe NOTICE).

### A.20 — Python-Scripts (F-EXTRA-5 Konflikt-Audit)

| Skript | Zweck | F-EXTRA-5 Bewertung |
|--------|-------|---------------------|
| `_analyze_licenses.py` | Heuristische Lizenz-Erkennung in `ext/` Repos, Output Markdown-Tabelle | **One-Shot Setup-Skript** — vermutlich legitim laut Memory-Direktive ("Ehemalige Setup-Skripte bleiben — neues Tooling strikt sh/bat/CMake") |
| `_copy_ext_repos.py` | Kopiert geklonte Repos aus `Forschungsarbeiten/code/` nach `ext/` | **One-Shot Setup-Skript** — legitim |
| `_generate_legacy_reimpl.py` | Generiert 14 LEGACY_REIMPL Skelette mit README/CMake/hpp | **One-Shot Setup-Skript** — legitim |
| `_generate_stubs.py` | Generiert 56 CMakeLists-INTERFACE-Stubs + .gitkeep | **One-Shot Setup-Skript** — legitim |
| `tools/permutation_codegen/codegen.py` | Wird BEI JEDEM BUILD aufgerufen wenn `COMDARE_BUILD_PERMUTATIONS=ON` | **VERLETZT F-EXTRA-5** — muss in sh/bat/CMake umgebaut werden! |

## Top-Level Dateien `comdare-prt-art`

Nur eine Datei:
- `GPT questions to prt art.txt` — 35 Fragen + Antworten zur PRT-ART-Algorithmik (Konsolidierungsbasis fuer REV 6)

Dieses Repo ist **vollkommen leer** im Sinne von Code-Strukturen. Empfehlung: **NICHT** als Ziel fuer die Phase-6-Implementation verwenden, sondern als reines Diskussions-/Recherche-Archiv (oder spaeter als Habich-H4 Separation-Repo).

---

## B) Welche REV-5.3-Architektur-Aspekte sind in comdare-cache-engine SCHON da?

Aufgegliedert nach REV-5.3-Drawio-Tabs:

### B.1 — Vollstaendig vorhanden (Skelett-Slot existiert)

| REV-5.3-Aspekt | Wo im Skelett |
|----------------|----------------|
| **6 Domaenen** (1-6) | `search_engine/, cache_engine/, measurement/, hardware_isa/, engine_choice/, prt_art/` |
| **CacheEngineBuilder** (Kernbeitrag) | `cache_engine/builder/cache_engine_component/` |
| **AlgorithmVisitor** (Tab K03/U09) | `cache_engine/builder/algorithm_visitor/` |
| **PermutationEngine** (Tab K12) | `cache_engine/builder/permutation_engine/` |
| **LatexRenderer** (Phase 8) | `cache_engine/builder/latex_renderer/` |
| **PlatformProbe** (Tab K07a-d) | `cache_engine/builder/platform_probe/` + `measurement/platform_probe/` + `cache_engine/subsystems/platform_profiler/` (3-fach!) |
| **MeasurementBuffer** (Tab K10) | `cache_engine/builder/in_memory_measurement_buffer/, .../disk_serializer/, .../telemetry_spool/` |
| **CostModel** (Tab K15) | `cache_engine/subsystems/cost_model/` |
| **PrefetchController** (Tab K15) | `cache_engine/subsystems/prefetch_controller/` |
| **RelocationManager** (Tab K15) | `cache_engine/subsystems/relocation_manager/` |
| **AllocatorManager** (Tab K15) | `cache_engine/subsystems/allocator_manager/` |
| **PageTypeScheduler** (Tab K15) | `cache_engine/subsystems/page_type_scheduler/` |
| **TelemetryAggregator** (Tab K15) | `cache_engine/subsystems/telemetry_aggregator/` |
| **8 Concurrency-Achsen** | `cache_engine/concurrency_manager/(array, data_structure, memory_access, node, page, path, simd_flow, simd_thread)_concurrency/` |
| **9-Achsen Search-Engine-Concepts** | `search_engine/(algorithm_strategies, fan_out_engine, memory_layout, node, operations, page, traversal, value_handle)/` |
| **Adapter-Pattern** (F-EXTRA-1) | `adapters/P01-...P30-/` |
| **F12-K liburcu-Pflege** | `cache_engine/reclamation/rcu_reclaim/` |
| **PRT-ART Eigen-Bausteine** | `prt_art/(allocator, concurrency, memory_layout, nodes, pages, prefetch, traversal, value_handles)/` |
| **14 LEGACY_REIMPL** (Termin 7) | `prt_art/legacy_reimpl/P11...P27-*/` |

### B.2 — Vorhanden, aber im Diplomarbeit/code-Ordner (NICHT in comdare-cache-engine!)

Diese Dateien existieren bereits implementiert unter
`Diplomarbeit - Datenbanken/code/cache_engine/include/cache_engine/concepts/` aber NICHT im Skelett-Slot des Comdare-Repos:

| Datei | Inhalt | Mappt auf REV-5.3-Tab |
|-------|--------|------------------------|
| `pressure_state.hpp` | `std::variant<Idle, Warmup, Saturated, CoherenceStorm, Recovery>` als State-Pattern | U09 |
| `i_cache_engine.hpp` | abstract base `ICacheEngine` mit `advise(), snapshot(), notify(), register_sub_engine(), on_pressure_transition()` | U09 |
| `i_sub_engine.hpp` | `SubEngineSlot` enum C01-C12, `kPipelineOrder[12]`, `SubEngineEvent`, `ISubEngine`-Interface | U09 + K15 |
| `cache_recommendation.hpp` | `CacheRecommendation, MemoryAllocationHint, LayoutChangeProposal, PrefetchAdvisory, MigrationDirective, PinningDirective, PressureSummary` | U09 + K15 |
| `platform_snapshot.hpp` | `PlatformSnapshot, HwCounters (inkl. mpki()), NumaTopologySnapshot` | K07a-d + K08a-d |
| `request_context.hpp` | `RequestContext, OperationKind` enum | U09 |
| `platform_probe/cpuid_probe.hpp` | `CpuidProbeResults, cpuid(), probe_cpuid()` — Multi-OS x86 + ARM | K07a |
| `cache_engine.hpp` | Aggregations-Header | n/a (Bequemlichkeit) |

### B.3 — Vorhanden im Diplomarbeit/code/prt_art

Konzept-Header existieren bereits unter `Diplomarbeit - Datenbanken/code/prt_art/include/prt_art/concepts/`:

| Datei | Mappt auf REV-5.3-Tab |
|-------|------------------------|
| `i_cache_page.hpp` | K05 |
| `i_executing_engine.hpp` | U01 |
| `i_fanout.hpp` | K02 |
| `i_node.hpp` | K02 |
| `i_root_node.hpp` | K02 |
| `i_search_engine.hpp` | K02 |
| `i_search_page.hpp` | K02 |
| `i_search_page_structure.hpp` | K02 |
| `i_search_page_structure_interpreter.hpp` | K02 |
| `value_handle.hpp` | search_engine/value_handle |

---

## C) Welche REV-5.3-Aspekte FEHLEN vollstaendig (sind weder skelettiert noch implementiert)?

### C.1 — Vollstaendig fehlend (kein Skelett, kein Code)

| REV-5.3-Aspekt | Notwendiger neuer Slot |
|----------------|------------------------|
| **State-Pattern PressureState** (5 Zustaende) | Aktuell unter `Diplomarbeit/code/`. **Soll-Slot:** `cache_engine/include/cache_engine/concepts/pressure_state.hpp` ODER neuer Sub-Komponente `cache_engine/state/` |
| **ICacheEngineVisitor** (Tab K03) | Aktuell als `algorithm_visitor` skelettiert, aber NICHT REV 5.3-konform — fehlt das Visitor-Pattern mit Pipeline ueber 12 Sub-Engines |
| **12 Sub-Engine-Familien C01-C12** | `cache_engine/subsystems/` deckt nur 7 ab (C01 Layout, C02 Pinning teilweise, C03 Prefetch, C06 Allocation, C07 Migration, C11 Scheduler, ...) — es fehlen klare Slots fuer **C02 Pinning, C04 Coherence, C05 Telemetry, C08 Encoding, C09 Heuristik, C10 Topologie, C12 Filter** als separate Verzeichnisse |
| **kPipelineOrder Deterministische Reihenfolge** | Nicht skelettiert |
| **SubEngineEvent Mediator-Callbacks** | Nicht skelettiert |
| **CacheRecommendation Verdict-Typen** | Nicht skelettiert (DoNothing, Hint, Reshape, Migrate, Allocate, Abort) |
| **3-Schichten-Architektur (K02)** | `prt_art/{concept_strategy_physisch}` fehlt — aktuell sind die Slots nach 9 Such-Engine-Achsen organisiert, NICHT nach K02 Schichten |
| **Hybrid-Command-Pattern (K04)** | Nicht skelettiert |
| **Saeule A/B Trennung (K02/K05)** | Implizit in `search_engine/` (Saeule A) und `cache_engine/` (Saeule B), aber explizit als Tab-Konzept nicht abgebildet |
| **CacheRecommendation.confidence + verdict** | Fehlt |
| **9 Plattform-Pflichtszenarien** (Block AO Termin 6) | `PLATFORM_REQUIREMENTS.md` existiert im Diplomarbeit/code, NICHT im Comdare-Repo |

### C.2 — Teilweise fehlend (Slot existiert, aber Detail-Decomposition fehlt)

- `cache_engine/builder/` hat `platform_probe`, aber die K07a-d-Splittung (Discover/Reduce/Resolve/Reify) fehlt
- `cache_engine/concurrency_manager/` deckt die Achsen ab, aber das **CRDT-Mediator-Pattern** ist nicht differenziert
- `cache_engine/builder/measurement_matrix/` ist ein Stub, die **Plattform×Algorithmus-Cross-Permutation (K12)** ist nicht modelliert

---

## D) Welche Namespace-Konvention nutzt comdare-cache-engine?

### D.1 — Kanonische Schreibweise im Skelett

Im **comdare-cache-engine** verwenden die Stub-Header (siehe `_generate_legacy_reimpl.py` HPP_TEMPLATE und `_generate_stubs.py`):

```cpp
namespace comdare::prt_art::legacy_reimpl::{namespace} {
```

Die CMake-Target-Praefixe sind **alle `comdare_*`** (z.B. `comdare_cache_engine_component`, `comdare_concurrency_array`, `comdare_legacy_css_node_page`).

Dies entspricht der **MEMORY.md K19/K20 Direktive**: 
> Namespace `comdare::*` VERBINDLICH — Migration ABGESCHLOSSEN (S2659, 0 verbleibende bep:: Refs)
> Env/Script-Prefix `COMDARE_*`/`comdare_*` — Migration ABGESCHLOSSEN

### D.2 — REV-5.3-Header verwenden anderes Schema

Die existierenden Header unter `Diplomarbeit - Datenbanken/code/cache_engine/include/cache_engine/concepts/` verwenden:

```cpp
namespace prt_art::cache_engine {
namespace prt_art::cache_engine::state {
namespace prt_art::cache_engine::platform_probe {
```

Und der CMake-Alias ist `prt_art::cache_engine`.

### D.3 — KONFLIKT + Empfehlung

Es gibt einen klaren Namespace-Konflikt zwischen den existierenden REV-5.3-Headern (`prt_art::cache_engine::*`) und dem Comdare-Skelett (`comdare::*`).

**Empfehlung:** Bei der Migration der REV-5.3-Header in `comdare-cache-engine/cache_engine/include/cache_engine/concepts/` MUESSEN ALLE Namespaces auf 

```cpp
namespace comdare::cache_engine { ... }
namespace comdare::cache_engine::state { ... }
namespace comdare::cache_engine::platform_probe { ... }
namespace comdare::prt_art { ... }
namespace comdare::prt_art::legacy_reimpl::P21_Chen_PrefetchBPlus { ... }
```

umgestellt werden. Das entspricht der MEMORY.md-Direktive und dem Stub-Pattern im Skelett.

---

## E) CMake-Konvention und Multi-OS-Faehigkeit

### E.1 — CMake-Konvention (comdare-cache-engine)

- **Minimum:** `cmake_minimum_required(VERSION 3.28)` — vereinfacht C++23 Modules-Support
- **Project:** `project(comdare-cache-engine VERSION 0.1.0 LANGUAGES CXX)`
- **C++:** `CMAKE_CXX_STANDARD 23, REQUIRED ON, EXTENSIONS OFF`
- **Options:** alle mit `COMDARE_*`-Praefix
- **Sub-Komponenten:** INTERFACE-Library `add_library(<name> INTERFACE); target_include_directories(<name> INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})`
- **Submodule-Pruefung:** `cmake/check_submodules.cmake` (OPTIONAL include)

### E.2 — CMake-Konvention (Diplomarbeit/code)

- **Minimum:** identisch (`3.28`)
- **Project:** `project(prt_art_diplomarbeit VERSION 0.1.0 LANGUAGES CXX C)` (C zusaetzlich!)
- **C++/C:** identisch C++23, plus C17
- **POSITION_INDEPENDENT_CODE ON**
- **Options:** `PRT_ART_BUILD_*`-Praefix (NICHT comdare!)
- **ISA-Optionen:** `PRT_ART_ENABLE_AVX512, AVX2, BMI2, NEON, SVE2, RISCV_V`
- **CMake-Module-Path:** eigenes `cmake/`-Verzeichnis mit 4 dedizierten Modulen
- **Plattform-Defines:** `prt_art_set_platform_defines()` als Helper-Funktion
- **`FILE_SET HEADERS`** Pattern (CMake 3.23+)

### E.3 — Multi-OS-Faehigkeit

Das Comdare-Skelett **deklariert** Multi-OS via README (Pi 5, VisionFive 2, ODROID, ZIH...), aber das CMake-Setup ist minimal — KEINE expliziten Plattform-Defines, KEINE ISA-Feature-Discovery, KEINE GTest-Integration.

Das Diplomarbeit/code-Setup ist **substantiell Multi-OS-fortgeschrittener** (4 dedizierte CMake-Module: `platform_detection`, `compiler_flags`, `isa_features`, `gtest_setup`).

### E.4 — Empfehlung Mehrwert-Migration

Bei der Migration der REV-5.3-Header sollten **auch die 4 Multi-OS-CMake-Module** aus Diplomarbeit/code in `comdare-cache-engine/cmake/` uebernommen werden:

1. `platform_detection.cmake` → erkennt Pi5/M1/ODROID/ZIH-SappireRapids/GraceHopper
2. `compiler_flags.cmake` → setzt MSVC/GCC/Clang/AppleClang-Flags
3. `isa_features.cmake` → AVX512/BMI2/NEON/SVE2/RISCV-V Discovery
4. `gtest_setup.cmake` → FetchContent fuer GoogleTest 1.15.2 (KEIN Submodule)

Variablen-Praefixe muessen von `PRT_ART_*` auf `COMDARE_*` umbenannt werden.

---

## F) Welche Python-Scripts muessen gemaess F-EXTRA-5 umgebaut werden?

**Direktive (MEMORY.md feedback_no_python_in_buildchain.md):**
> Codegen/Orchestrator: CMake-Funktionen + sh/bat (synchron gepflegt)  
> Begruendung: Talos OS hat kein Python; Prerequisites minimieren  
> Ehemalige Setup-Skripte (`_generate_stubs.py` etc.) bleiben — neues Tooling strikt sh/bat/CMake

### F.1 — Skripte die BLEIBEN duerfen (one-shot Setup, bereits ausgefuehrt)

- `_analyze_licenses.py` — wurde EINMAL ausgefuehrt zur Erzeugung von `docs/lizenzen/20260508-1500-lizenzen_uebersicht.md`. **BLEIBT** als Setup-Skript.
- `_copy_ext_repos.py` — wurde EINMAL ausgefuehrt zum Kopieren der 12 Repos. **BLEIBT**.
- `_generate_legacy_reimpl.py` — wurde EINMAL ausgefuehrt zur Erzeugung der 14 Skelette. **BLEIBT**.
- `_generate_stubs.py` — wurde EINMAL ausgefuehrt zur Erzeugung der 56 CMakeLists-Stubs. **BLEIBT**.

### F.2 — Skripte die UMGEBAUT WERDEN MUESSEN (Build-Pipeline)

#### `tools/permutation_codegen/codegen.py` — KRITISCH

Wird bei jedem Build aufgerufen, wenn `COMDARE_BUILD_PERMUTATIONS=ON`. Verletzt F-EXTRA-5 frontal.

**Umbau-Plan (gemaess Task #107):**

1. **Datenformat:** Bausteine-Matrix + Flag-System als **TSV oder kompaktes CMake-readable Format** (NICHT JSON, nicht Python pickle)
2. **Enumerator:** CMake-Funktion `comdare_enumerate_permutations()` in `cmake/permutations.cmake` (bereits vorhanden — nur die `execute_process(... Python ...)` Logik ersetzen)
3. **Constraint-Filter:** CMake-foreach + if-Statements; bei komplexen Filtern als Helper-Script in **bash + batch (synchron gepflegt)**
4. **Output:** CMake-Funktion schreibt direkt `${CMAKE_BINARY_DIR}/generated/permutations.cmake` via `file(WRITE ...)`

#### `cmake/permutations.cmake` — KRITISCH

Aktuell:
```cmake
find_package(Python3 REQUIRED COMPONENTS Interpreter)
execute_process(COMMAND ${Python3_EXECUTABLE} ${COMDARE_PERMUTATION_CODEGEN} ...)
```

**Muss ersetzt werden durch:**
- `include(cmake/permutations_enumerator.cmake)` — reine CMake-Logik
- ggf. `execute_process(COMMAND bash tools/permutation_codegen/codegen.sh ...)` mit batch-Pendant `codegen.bat`

---

## G) Datei-fuer-Datei: Welche Diplomarbeit/code-Dateien koennen direkt migriert werden? Welche kollidieren?

### G.1 — Source: `Diplomarbeit - Datenbanken/code/cache_engine/include/cache_engine/`

| Datei | Comdare-Zielslot | Status |
|-------|--------------------|--------|
| `cache_engine.hpp` | `comdare-cache-engine/cache_engine/include/cache_engine/cache_engine.hpp` | **NEU** (Zielordner muss angelegt werden) |
| `concepts/cache_recommendation.hpp` | `.../include/cache_engine/concepts/cache_recommendation.hpp` | **NEU** — Namespace-Refactoring von `prt_art::cache_engine` → `comdare::cache_engine` |
| `concepts/i_cache_engine.hpp` | `.../include/cache_engine/concepts/i_cache_engine.hpp` | **NEU** — Namespace-Refactoring |
| `concepts/i_sub_engine.hpp` | `.../include/cache_engine/concepts/i_sub_engine.hpp` | **NEU** — Namespace-Refactoring |
| `concepts/platform_snapshot.hpp` | `.../include/cache_engine/concepts/platform_snapshot.hpp` | **NEU** — Namespace-Refactoring |
| `concepts/pressure_state.hpp` | `.../include/cache_engine/concepts/pressure_state.hpp` | **NEU** — Namespace-Refactoring von `prt_art::cache_engine::state` → `comdare::cache_engine::state` |
| `concepts/request_context.hpp` | `.../include/cache_engine/concepts/request_context.hpp` | **NEU** — Namespace-Refactoring |
| `platform_probe/cpuid_probe.hpp` | `comdare-cache-engine/hardware_isa/include/cpuid_probe.hpp` ODER `cache_engine/include/cache_engine/platform_probe/cpuid_probe.hpp` | **NEU** — siehe G.3 Empfehlung |

**Kollision-Analyse:** Aktuell hat das Comdare-Skelett **KEIN `cache_engine/include/`-Verzeichnis** (CMakeLists ist ein simples passthrough). Der `concepts/`-Pfad existiert NICHT — es ist also reine Neuanlage. **Keine Kollision.**

### G.2 — Source: `Diplomarbeit - Datenbanken/code/prt_art/include/prt_art/concepts/`

| Datei | Comdare-Zielslot | Status |
|-------|--------------------|--------|
| `i_cache_page.hpp` | `comdare-cache-engine/prt_art/include/prt_art/concepts/i_cache_page.hpp` | **NEU** |
| `i_executing_engine.hpp` | `.../include/prt_art/concepts/i_executing_engine.hpp` | **NEU** — KOLLISION-Hinweis: `cache_engine/builder/algorithm_visitor` deckt UML-U01 ab |
| `i_fanout.hpp` | `.../include/prt_art/concepts/i_fanout.hpp` | **NEU** — UEBERLAPPT mit `search_engine/fan_out_engine/` (Slot existiert, ist leer) |
| `i_node.hpp` | `.../include/prt_art/concepts/i_node.hpp` | **NEU** — UEBERLAPPT mit `search_engine/node/` |
| `i_root_node.hpp` | `.../include/prt_art/concepts/i_root_node.hpp` | **NEU** |
| `i_search_engine.hpp` | `.../include/prt_art/concepts/i_search_engine.hpp` | **NEU** — UEBERLAPPT mit `engine_choice/` |
| `i_search_page.hpp` | `.../include/prt_art/concepts/i_search_page.hpp` | **NEU** — UEBERLAPPT mit `search_engine/page/` |
| `i_search_page_structure.hpp` | `.../include/prt_art/concepts/i_search_page_structure.hpp` | **NEU** |
| `i_search_page_structure_interpreter.hpp` | `.../include/prt_art/concepts/i_search_page_structure_interpreter.hpp` | **NEU** |
| `value_handle.hpp` | `.../include/prt_art/concepts/value_handle.hpp` | **NEU** — UEBERLAPPT mit `search_engine/value_handle/` |

**Kollision-Analyse:** Die i_*.hpp-Headers sind im Skelett-Schema unter `search_engine/` und `engine_choice/` "vorgesehen", aber dort sind nur LEERE Sub-Komponente. Die Loesung ist **klare Trennung der Concept-Layer**:
- `comdare::search_engine::concepts::*` → in `search_engine/include/search_engine/concepts/` (Concept-Layer DOMAENE 1)
- `comdare::prt_art::concepts::*` → in `prt_art/include/prt_art/concepts/` (Eigene Algorithmus-Concepts)

Damit gibt es semantisch keine Kollision, sondern eine **Schichten-Konsolidierung**.

### G.3 — `cpuid_probe.hpp` Zielslot-Entscheidung

Das aktuelle Comdare-Skelett hat **drei** unterschiedliche PlatformProbe/Profiler-Slots:
1. `cache_engine/builder/platform_probe/` — Builder-Sicht
2. `measurement/platform_probe/` — Measurement-Sicht
3. `cache_engine/subsystems/platform_profiler/` — Subsystem-Sicht

und zusaetzlich `hardware_isa/isa_dispatch/`, `hardware_isa/memory_type_detector/`, `hardware_isa/hugepage_manager/`, `hardware_isa/hybrid_core_pinning/`.

**Empfehlung G.3:**

`cpuid_probe.hpp` gehoert konzeptionell zu **K07a "Discover-Phase"** (siehe REV 5.3) und ist Teil der ISA-Discovery. Daher **bestes Ziel:**

```
comdare-cache-engine/hardware_isa/isa_dispatch/include/cpuid_probe.hpp
```

ODER (alternativ, naeher an den Concept-Headern):

```
comdare-cache-engine/cache_engine/include/cache_engine/platform_probe/cpuid_probe.hpp
```

Die zweite Variante ist konsistenter mit dem Diplomarbeit/code-Layout. Empfohlen: **zweite Variante**, weil die 8 Concept-Header in `cache_engine/include/cache_engine/concepts/` eine kohaerente "PlatformProbe + State + Visitor + 12 Sub-Engines"-Einheit bilden, die NICHT auf `hardware_isa/` zersplittert werden sollte.

---

## H) Empfehlung: Wo legen wir die NEUEN Concepts aus REV 5.3 in der existierenden Struktur ab?

### H.1 — Anlage neuer Header-Slots

| Concept (aus REV 5.3) | Ziel-Pfad in comdare-cache-engine | Namespace |
|------------------------|------------------------------------|-----------|
| PressureState (5 Varianten als std::variant) | `cache_engine/include/cache_engine/concepts/pressure_state.hpp` | `comdare::cache_engine::state` |
| ICacheEngine | `cache_engine/include/cache_engine/concepts/i_cache_engine.hpp` | `comdare::cache_engine` |
| ISubEngine + SubEngineSlot + kPipelineOrder | `cache_engine/include/cache_engine/concepts/i_sub_engine.hpp` | `comdare::cache_engine` |
| ICacheEngineVisitor (Tab K03) | `cache_engine/include/cache_engine/concepts/i_cache_engine_visitor.hpp` | `comdare::cache_engine` |
| CacheRecommendation, MemoryAllocationHint, ... | `cache_engine/include/cache_engine/concepts/cache_recommendation.hpp` | `comdare::cache_engine` |
| PlatformSnapshot, HwCounters, NumaTopologySnapshot | `cache_engine/include/cache_engine/concepts/platform_snapshot.hpp` | `comdare::cache_engine` |
| RequestContext, OperationKind | `cache_engine/include/cache_engine/concepts/request_context.hpp` | `comdare::cache_engine` |
| CpuidProbe (K07a) | `cache_engine/include/cache_engine/platform_probe/cpuid_probe.hpp` | `comdare::cache_engine::platform_probe` |
| Aggregations-Header | `cache_engine/include/cache_engine/cache_engine.hpp` | n/a |

### H.2 — Anlage neuer Sub-Komponenten fuer fehlende 12 Sub-Engine-Slots

Aktuell deckt `cache_engine/subsystems/` 7 Sub-Engines ab. Wir muessen ergaenzen:

| Slot | Status | Aktion |
|------|--------|--------|
| C01 Layout | (implizit in allocator_manager?) | **NEU:** `subsystems/c01_layout_engine/` |
| C02 Pinning | Fehlt | **NEU:** `subsystems/c02_pinning_engine/` (alternativ: `hardware_isa/hybrid_core_pinning/` umstellen) |
| C03 Prefetch | `subsystems/prefetch_controller/` | **UMBENENNEN:** zu `subsystems/c03_prefetch_engine/` |
| C04 Coherence | Fehlt | **NEU:** `subsystems/c04_coherence_engine/` |
| C05 Telemetry | `subsystems/telemetry_aggregator/` | **UMBENENNEN:** zu `subsystems/c05_telemetry_engine/` |
| C06 Allocation | `subsystems/allocator_manager/` | **UMBENENNEN:** zu `subsystems/c06_allocation_engine/` |
| C07 Migration | `subsystems/relocation_manager/` | **UMBENENNEN:** zu `subsystems/c07_migration_engine/` |
| C08 Encoding | Fehlt | **NEU:** `subsystems/c08_encoding_engine/` |
| C09 Heuristik | Fehlt | **NEU:** `subsystems/c09_heuristik_engine/` |
| C10 Topologie | Fehlt | **NEU:** `subsystems/c10_topologie_engine/` |
| C11 Scheduler | `subsystems/page_type_scheduler/` | **UMBENENNEN:** zu `subsystems/c11_scheduler_engine/` |
| C12 Filter | Fehlt | **NEU:** `subsystems/c12_filter_engine/` |

**Begruendung:** REV 5.3 U09 definiert eine deterministische **Pipeline-Reihenfolge** C05 → C10 → C09 → C01 → C08 → C06 → C02 → C07 → C03 → C04 → C12 → C11, die einer **klaren 1:1-Slot-Zuordnung** beduerftig ist.

### H.3 — Anlage Visitor-Tabs (Tab K03)

| Visitor-Komponente | Ziel-Pfad |
|---------------------|-----------|
| `ICacheEngineVisitor` Interface | `cache_engine/include/cache_engine/concepts/i_cache_engine_visitor.hpp` |
| Visitor-Pipeline-Driver | `cache_engine/builder/algorithm_visitor/include/algorithm_visitor.hpp` (existiert als Stub) |
| Mediator-Event-Dispatch | `cache_engine/builder/observer_registry/include/observer_registry.hpp` (existiert als Stub) |

### H.4 — Anlage 3-Schichten-Architektur (Tab K02)

Empfehlung: NICHT die existierende 9-Achsen-Struktur des `prt_art/` umbauen, sondern **eine Concept-Layer einziehen**:

```
comdare-cache-engine/
└── prt_art/
    ├── include/prt_art/concepts/        ← NEU: 10 Concept-Header (i_*.hpp + value_handle.hpp)
    ├── allocator/   (bestehend)
    ├── concurrency/ (bestehend)
    ├── memory_layout/ (bestehend)
    ├── nodes/      (bestehend)
    ├── pages/      (bestehend)
    ├── prefetch/   (bestehend)
    ├── traversal/  (bestehend)
    └── value_handles/ (bestehend)
```

Die 9 Achsen-Verzeichnisse sind die **Strategie-Schicht** (S1-S30 aus K06), die Concepts sind die **Concept-Schicht**, und die spaetere echte Implementation (in src/) ist die **Physisch-Schicht**.

### H.5 — Anlage Multi-OS-CMake-Module

Migration der 4 CMake-Module aus `Diplomarbeit/code/cmake/` mit Refactoring:

| Quelle | Ziel | Variable-Refactor |
|--------|------|---------------------|
| `cmake/platform_detection.cmake` | `comdare-cache-engine/cmake/platform_detection.cmake` | `PRT_ART_*` → `COMDARE_*` |
| `cmake/compiler_flags.cmake` | `comdare-cache-engine/cmake/compiler_flags.cmake` | dito |
| `cmake/isa_features.cmake` | `comdare-cache-engine/cmake/isa_features.cmake` | dito |
| `cmake/gtest_setup.cmake` | `comdare-cache-engine/cmake/gtest_setup.cmake` | dito |

### H.6 — Tests-Migration

Die 3 vorhandenen Tests aus `Diplomarbeit - Datenbanken/code/cache_engine/tests/` (`test_cache_recommendation.cpp`, `test_cpuid_probe.cpp`, `test_pressure_state.cpp`) und 3 aus `prt_art/tests/` (`test_concepts_compile.cpp`, `test_three_layer_audit.cpp`, `test_value_handle.cpp`) gehoeren nach:

```
comdare-cache-engine/tests/unit/test_cache_recommendation.cpp
comdare-cache-engine/tests/unit/test_cpuid_probe.cpp
comdare-cache-engine/tests/unit/test_pressure_state.cpp
comdare-cache-engine/tests/unit/test_concepts_compile.cpp
comdare-cache-engine/tests/unit/test_three_layer_audit.cpp
comdare-cache-engine/tests/unit/test_value_handle.cpp
```

### H.7 — Dissertation-Komponente

Der `Diplomarbeit/code/dissertation/`-Ordner mit `appendix_generator/`, `measurement_buffer/`, `permutation_loop/` mappt direkt auf das `cache_engine/builder/`-Skelett:

| Diplomarbeit-Slot | Comdare-Zielslot |
|-------------------|-------------------|
| `dissertation/src/measurement_buffer/` | `cache_engine/builder/in_memory_measurement_buffer/` + `disk_serializer/` + `telemetry_spool/` |
| `dissertation/src/permutation_loop/` | `cache_engine/builder/permutation_engine/` |
| `dissertation/src/appendix_generator/` | `cache_engine/builder/latex_renderer/` |

Damit waere die DISSERTATION-Komponente vollstaendig in die Domaene 6 (Publication) des Comdare-Skeletts integriert (laut README.md: `cache_engine/builder/latex_renderer/` ist die kanonische Heimat).

---

## I) Migrations-Risiken und Stolperfallen

### I.1 — Namespace-Doppel-Migration

REV-5.3-Header verwenden TROTZ Memory-Direktive K19/K20 (Migration `bep`→`comdare`) das alte `prt_art::*`-Schema. Dies ist eine **Inkonsistenz** und muss vor jedem Push korrigiert werden.

### I.2 — F-EXTRA-5 Verletzung

`tools/permutation_codegen/codegen.py` + `cmake/permutations.cmake` mit `find_package(Python3 REQUIRED)` muss **VOR dem ersten Permutations-Build** ersetzt werden, sonst funktioniert der Build auf Talos-OS-Nodes nicht.

### I.3 — Submodule-Konflikt-Hinweis

Das Comdare-Skelett deklariert in `.gitmodules.template` 6 Submodules (`modules/comdare-search-engine`, etc.), die noch nicht gepusht sind. Das KOLLIDIERT mit der MEMORY.md-Direktive "feedback_no_git_submodules.md" — diese Ausnahme MUSS explizit in der finalen Doku dokumentiert werden.

### I.4 — `prt_art/legacy_reimpl/` enthaelt 14 Stubs mit Namespace `comdare::prt_art::legacy_reimpl::<sub>`

KORREKT (folgt Stub-Generator). Diese Skelette koennen direkt mit Implementierung gefuellt werden.

### I.5 — `dataset_loader` doppelt belegt

`measurement/dataset_loader/` exists, but no YCSB loader yet. Task #81/#82 sind `pending` und muessen vor Phase 7 abgearbeitet werden.

### I.6 — `comdare-prt-art` Repo-Verwendung

Das `comdare-prt-art` Repo ist faktisch leer und sollte NICHT als Ziel fuer Phase-6-Implementation dienen. Empfehlung: **Implementation gehoert komplett in `comdare-cache-engine`** (das umfangreich vorbereitete Skelett-Repo), und `comdare-prt-art` bleibt als reines GPT-Diskussions-Archiv ODER wird in Phase 8 als Habich-H4-Separation-Repo aktiviert.

---

## J) Naechste Schritte (Empfehlung)

1. **Namespace-Konsistenz herstellen:** Alle Diplomarbeit/code/-Header von `prt_art::cache_engine::*` → `comdare::cache_engine::*` umbenennen (sed-Refactor, sed -i 's/namespace prt_art::cache_engine/namespace comdare::cache_engine/g')
2. **Header-Migration:** 8 Header `cache_engine/include/cache_engine/concepts/*.hpp` + 1 Aggregator + `platform_probe/cpuid_probe.hpp` in das Comdare-Skelett einlegen
3. **PRT-ART Concept-Migration:** 10 Header `prt_art/include/prt_art/concepts/*.hpp` ueber den existierenden Skelett-Slots als neue Concept-Schicht einfuegen
4. **12 Sub-Engine-Slots:** 5 fehlende Sub-Engine-Verzeichnisse (C02, C04, C08, C09, C10, C12) anlegen, 5 bestehende auf C-Praefix umbenennen (C03, C05, C06, C07, C11)
5. **Multi-OS-CMake:** 4 Module aus Diplomarbeit/code/cmake/ mit COMDARE_-Refactoring uebernehmen
6. **F-EXTRA-5 Fix:** `cmake/permutations.cmake` Python entfernen, `tools/permutation_codegen/codegen.py` durch CMake-/sh/bat-Loesung ersetzen
7. **Tests-Migration:** 6 Test-Dateien nach `tests/unit/` migrieren, GTest-Setup uebernehmen
8. **REV-6 Architektur-Skizze:** Die 32 drawio-Tabs + die 35 GPT-Antworten aus `comdare-prt-art/GPT questions to prt art.txt` zu einer **REV-6-Skizze** konsolidieren
9. **Diplomarbeit/code aufraeumen:** Nach erfolgreicher Migration die Dateien unter `Diplomarbeit/code/` archivieren (z.B. `Diplomarbeit/_archive_code_pre_migration/`)
10. **build-msvc/-Build:** Test-Build im Comdare-Repo mit den migrierten Headern durchfuehren, ALL_BUILD verifizieren

---

**Ende des Audit-Berichts.**

Gesamt-Wortzahl: ca. 3700 Woerter.

Status: BESTANDSAUFNAHME ABGESCHLOSSEN, BEREIT FUER PHASE-6-VERSCHIEBUNG.
