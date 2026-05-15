---
title: "PRT-ART Termin 7 — REV 7.6 Stand"
author: "Benjamin Probst"
date: "2026-05-13"
---

# Slide 1 — Titel

**PRT-ART Diplomarbeit — Termin 7**

Architektur-Konsolidierung der drei Repos (REV 7.6)

Stand 2026-05-13 · Benjamin Probst · TU Dresden

---

# Slide 2 — Agenda

1. Drei-Repo-Aufteilung (User-Klarstellungen 2026-05-13)
2. Drei Pflicht-Messreihen (XML-Configs)
3. Phase 6+ Implementations-Inkremente (INK-1 bis INK-8)
4. Phase 6.2 Custom Allokation
5. Phase 6.3-6.6 ABI + Builder + Test
6. Phase 7 Permutations-Builds + Experiment-Loop
7. Begriffsglossar v3-v7 + Domaenenmodell v4
8. Bausteine-Matrix + Allokator-Matrix
9. F1-F15 + 8 F-EXTRA Architektur-Entscheidungen
10. Diskussionspunkte

---

# Slide 3 — Drei-Repo-Aufteilung

| Repo | Rolle | Verantwortlichkeit |
|---|---|---|
| `Diplomarbeit/Code/` | **WAS** + Auswertung | 3 Messreihen, XML-Configs, Driver-Loop, Binary→CSV→LaTeX→PDF |
| `comdare-prt-art` | **Pruefling** | Hybride PrtArtSearchEngine (REV 7.1), 8 Schichten Bausteine |
| `comdare-cache-engine` | **WIE** + Werkzeuge | Pipeline-Mechanik Phase 1-7, Demo-Workloads, ModuleLoader, Aggregator |

---

# Slide 4 — Drei Pflicht-Messreihen

| Reihe | Datei | Ziel |
|---|---|---|
| A | `config_a_prt_art_vs_sota.xml` | PRT-ART vs ART/HOT/Masstree (SOTA) |
| B | `config_b_cache_engine_perms.xml` | Cache-Engine-Permutationen (Allokator × Layout × Prefetch) |
| C | `config_c_merge_alt_neu.xml` | Regressions-Vergleich alt vs neu |

Speicher-Ort: `Diplomarbeit/Code/experiment_config/*.xml`
Driver iteriert ueber alle drei.

---

# Slide 5 — Phase 6+ Implementations-Inkremente (INK-1 bis INK-8)

- **INK-1**: PermutationFlags + Event + ObserverRegistry
- **INK-2**: DecisionLambdaTrees (10+ Familien)
- **INK-3**: ConcurrencyManager (8 Disziplinen + 3 Mechaniken)
- **INK-4**: TelemetryStrategy Achse 11 (Kuehn 5 Strategien)
- **INK-5**: Plattform-Auto-Discovery (REV 3 K3.2)
- **INK-6**: CacheHierarchy + LiveModel + Scheduler + Heuristik + Mode
- **INK-7**: HybridCompositionCommand (Command-Pattern, REV 3 K3.4)
- **INK-8**: InMemoryMeasurementBuffer + Measure-Matrix (F5 + F1)

Alle DONE.

---

# Slide 6 — Phase 6.2 Custom Allokation

**5 Cluster** (AC1-AC5):
- AC1 Foundation: A20 dlmalloc, A21 ptmalloc2
- AC2 Modern Production: A04 mimalloc, A05 jemalloc, A06 tcmalloc
- AC3 NUMA + Hardware: A09 NUMAlloc, A14 (in A06), A15 HMalloc, A16 PIM-malloc
- AC4 Concurrent + Formal: A03 Michael, A07 snmalloc, A11 LRMalloc, A13 StarMalloc, A17 Crystalline, A22 N3916 PMR
- AC5 Standard + Optimizing: A01 Hoard, A08 scalloc, A10 rpmalloc, A18 Exgen, A19 Buddy, A23 Vmem+Magazines

**7 Achsen** (AA1-AA7): Free-List-Topologie, Size-Class-Schema, Thread-Locality, Synchronization, Allocation-Policy, Reclamation, Fragmentation-Strategy.

---

# Slide 7 — Begriffsglossar v3-v7 + Domaenenmodell v4

**Begriffsglossar:** ~161 KANON-Begriffe ueber 5 Versionen.
- v3 Hauptmasse mit P01-P33-Belegen
- v4 Architektur-Pattern + Engine-Choice + Concepts + std::map-API
- v5 F1-F15 Beschluss-Begriffe (DecisionLambdaTree, ABI-Module, F15)
- v6 F-EXTRA + Korrekturen (Flag-System, Compiler-Layering)
- v7 Kuehn-Erkenntnisse + Production-Plattform + Forschungs-Mission

**Domaenenmodell:** v3 strukturell + v4 KORREKTUREN D-1 bis D-8.

---

# Slide 8 — Bausteine-Matrix

**85 Bausteine ueber 11 Achsen:**

| Achse | Anzahl |
|---|---|
| 1 PAGE-TYPE | 26 |
| 2 NODE-TYPE | 13 |
| 3 TRAVERSAL | 14 |
| 4 VALUEHANDLE | 5 |
| 5 MEMORY-LAYOUT | 8 |
| 6 ALLOCATOR | 7 (+ 23 Allokator-Paper extra) |
| 7 PREFETCH | 6 |
| 8 CONCURRENCY | (siehe Original) |
| 9 ISA | (siehe Flag_System) |
| 10 MEASUREMENT | (Mess-Kategorie x Algo-Detail Matrix) |
| 11 TELEMETRY-COLLECTION-STRATEGY | 6 (NEU 2026-05-09 Kuehn) |

---

# Slide 9 — F1-F15 + 8 F-EXTRA Architektur-Entscheidungen

**25 ADRs total**, alle DONE oder Code-vorbereitet.

Wichtigste:
- **F1**: CacheEngineRuntime-Singleton (heap-allokiert mit COMDARE_EXPERIMENT_MODE Flag)
- **F2**: Observer Push synchron + Command-Pattern Lambda-Trees (DELAY/EXECUTE/SKIP)
- **F5**: In-Memory MeasurementBuffer (KEINE externe DB)
- **F7**: Adapter-Pattern (Habich-Direktive)
- **F9**: ABI-stabiles C++23-Modul + ModuleLoader
- **F12**: CacheEngine im Builder (KEIN separater Singleton)
- **F15**: Bausteine-Quer-Permutation als zentrales Forschungs-Prinzip
- **F-EXTRA-1**: Original-Compiler pro Algorithmus
- **F-EXTRA-5**: KEIN Python in Build (CMake/sh/bat)

---

# Slide 10 — Drei Heutige Veraenderungen (cache-engine, prt-art, Diplomarbeit)

**cache-engine:**
- ExperimentDriver-Library (`comdare::builder::ExperimentDriver`)
- main.cpp Wrapper 165 → 82 Zeilen
- `--verbose` Flag fuer alle Diagnose-Outputs
- E2E "Demo pipeline OK" mit 54 DLLs

**prt-art:**
- Keine Code-Aenderungen — REV 7.1 stabil

**Diplomarbeit:**
- Code/-Verzeichnis als Anwender-Schicht
- 5 Module + experiment_config/ mit 3 XMLs
- cmake configure erfolgreich (26.5s)

---

# Slide 11 — Diskussionspunkt

**Granularitaet Messreihe B** (Cache-Engine-Permutationen):
- Allokator × Layout × Prefetch × Density × Sync = mehrere 100 DLLs
- Reduzierung auf Teil-Auswahl (3 × 3 × 2)?

**Antwort des Architekten:**
**Nein, vollstaendige Messung erforderlich.**

---

# Slide 12 — Aufgaben-Stand zu Termin 7

| # | Punkt | Stand 2026-05-13 |
|---|---|---|
| V1 | cache-engine Library + E2E | DONE |
| V2 | Diplomarbeit/Code/ Submodule + cmake configure | DONE |
| V3 | Per-Repo Findings + STRUCTURAL_CORRECTION | DONE |
| V4 | Diplomarbeit/Code/ Full-Build alle Targets | OFFEN |
| V5 | Diplomarbeit/Code/ ctest | OFFEN |
| V6 | E2E: 3 Messreihen | OFFEN |
| V7 | Manuskript-Wrapper thesis/main.tex | OFFEN |

---

# Slide 13 — Fragen?

**Vielen Dank fuer Ihre Zeit, Herr Habich.**

Drei-Repo-Aufteilung etabliert.
REV 7.6 Stand stabil.
Naechste Schritte: V8 (Implementations-Sprint).
