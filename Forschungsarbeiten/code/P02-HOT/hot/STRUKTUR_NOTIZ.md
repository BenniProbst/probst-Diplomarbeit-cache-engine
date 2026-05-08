# STRUKTUR_NOTIZ — P02 hot (speedskater/hot)

**Paper:** P02 — Binna/Zangerle/Pichl/Specht/Leis 2018 — "HOT: A Height Optimized Trie Index for Main-Memory Database Systems" (SIGMOD 2018)
**Repo:** `speedskater/hot`
**Lokal:** `Forschungsarbeiten/code/P02-HOT/hot/`
**Lizenz:** ISC (Copyright 2018, Robert Binna)
**Voranalyse:** `_voranalyse_output_klasse_a/P02-HOT__hot.txt` (2026-05-09)
**Stand der Notiz:** 2026-05-09

---

## 1. Repository-Klassifikation

| Feld | Wert |
|------|------|
| Klasse | A — geklonter Originalcode (cleaned-up Version der Original-Publikations-Quelle laut README) |
| Originalpaper-Code? | JA (Author = Robert Binna, einer der HOT-Autoren) |
| C++-Standard | C++14 (laut README) — kein `cxx_std_*` in CMake erkennbar |
| Build-System | CMake (CMakeLists.txt 68 Zeilen Top-Level, viele sub-CMakeLists) |
| Compiler-Anforderungen | nicht im README spezifiziert; Travis-CI mit gcc/clang; AVX2 wahrscheinlich (popcnt + AVX-512 in einer Datei) |
| ISA-Anforderungen | SSE/AVX2 (popcnt in 7 Dateien, AVX-512 in 1 Datei) |
| Externe Abhaengigkeiten | TBB (Intel Threading Building Blocks), Boost-Hana, boost-cmake, bilke-cmake-modules — alle als third-party Submodule |
| LOC (gesamt source) | 42 322 (wesentlicher Teil in Tests + Test-Daten) |
| Top-LOC-Datei | `tests/hot/test-helpers/src/hot/testhelpers/SampleTriples.cpp` (10 011 LOC, generierte Testdaten) |
| Wesentliche Header-LOC | `HOTSingleThreadedNode.hpp` (890), `HOTSingleThreaded.hpp` (658), `HOTRowexNode.hpp` (616) |

## 2. Verzeichnis-Hierarchie

```
hot/
├── apps/benchmarks/{integer,string}/{single-threaded,rowex}*/   — 4 Bench-Apps
├── libs/
│   ├── hot/
│   │   ├── commons/                  — Gemeinsame Bausteine (BiNode, PartialKeyMapping, SIMDHelper, …)
│   │   ├── single-threaded/          — Single-Threaded HOT-Variante (HOTSingleThreaded.hpp)
│   │   └── rowex/                    — Read-Optimized Write EXclusion HOT-Variante
│   ├── idx/                          — Index-Hilfen (benchmark, content, map, utils)
│   └── profile-lib/                  — Profiling-Wrapper
├── tests/                            — GoogleTest-Suite (~30 Dateien, ~25 000 LOC inkl. Testdaten)
└── third-party/                      — TBB, boost-cmake, boost-hana, bilke-cmake-modules
```

## 3. Bausteine-Klassifikation (Achsen 1-11)

| Achse | Identifizierte Implementierung | Quelldatei(en) |
|-------|-------------------------------|----------------|
| **1 Page** | keine eigenstaendige Page-Abstraktion; HOT-Knoten = Cache-Line-grosses Layout | `HOT*Node.hpp` |
| **2 Node** | **HOT-Compound-Knoten** mit dynamic-span (BiNode-Tree → kompakter Knoten); 4 Knoten-Groessen via SparsePartialKeys | `BiNode.hpp`, `HOTSingleThreadedNode.hpp`, `HOTRowexNode.hpp` |
| **3 Traversal** | Multi-Mask Partial-Key-Traversal mit AVX2-Bit-Manipulation (popcnt-basiert) | `MultiMaskPartialKeyMapping.hpp`, `Algorithms.hpp` |
| **4 ValueHandle** | Template-Param `Value` mit `ChildPointer`; ROWEX-Variante mit atomaren Pointern | `HOTRowexChildPointer.hpp` |
| **5 MemoryLayout** | Cache-Line-aligned Compound-Knoten; "Sparse" und "Dense" Partial-Key-Layouts | `SparsePartialKeys.hpp`, `MultiMaskPartialKeyMapping.hpp` |
| **6 Allocator** | nicht prominent; nutzt Standard-`new` mit ggf. TBB-Allocator | (implizit) |
| **7 Prefetch** | mehrere `prefetch` und `Prefetch` Treffer (4-5 Dateien) — Path-Prefetching beim Traversal | (grep: `prefetch`) |
| **8 Concurrency** | **ROWEX** (Read-Optimized Write EXclusion) — eigenstaendige Synchronisations­strategie + Epoch-Based Reclamation | `HOTRowex*.hpp`, `EpochBasedMemoryReclamationStrategy.hpp`, `MemoryGuard.hpp`, `SpinLock.hpp` |
| **9 ISA** | popcnt (7 Dateien), AVX-512 (1 Datei), SSE/AVX2 implizit | `SIMDHelper.hpp` |
| **10 Measurement** | umfassendes Benchmark-Framework (`Benchmark.hpp` 528 LOC, `StringBenchmark.hpp` 461 LOC) | `libs/idx/benchmark-helpers/` |
| **11 Telemetry-Strategy** | Profile-Lib (`libs/profile-lib/`) — wahrscheinlich Sampling-/Timer-basiert | `libs/profile-lib/` |

**Hervorhebung:** HOT liefert die einzige reife ROWEX-Implementierung der Klasse A (Concurrency-Konzept-Quelle).

## 4. Adapter-Strategie fuer comdare-cache-engine

| Strategie-Punkt | Entscheidung |
|-----------------|--------------|
| Einbindung-Form | Header-Subset (commons + single-threaded + rowex) in `adapters/P02-HOT/`; Bausteine_Matrix verweist `PAGE_COMPOUND_HOT`, `NODE_HOT_COMPOUND_K32`, `NODE_HOT_BINODE`, `TRAVERSAL_DISCRIMINATIVE_BITS` auf `ext/P02-HOT/hot/` |
| Compiler-Layering (F-EXTRA-1) | **WICHTIG:** HOT-Bausteine bleiben C++14 und werden mit GCC 5+ (Original-Compiler, BMI2/AVX2 erforderlich) kompiliert. KEINE „Aufwertung" des Originalcode-Standards. Modul-Wrapper bleibt C++23 (Hauptcompiler) und linkt die GCC-5-Object-Files statisch. |
| TBB-Abhaengigkeit | TBB ist als third-party-Submodule eingebunden. Fuer COMDARE: **TBB ablehnen** (eigene Concurrency-Bausteine F8). Sub-Bauteile, die TBB nicht benoetigen, koennen direkt eingebunden werden; ROWEX-Variante via eigenem Epoch-Reclaim oder ueber comdare-rcu. |
| Boost-Hana-Frage | Bleibt mit GCC 5+ kompatibel (Hana ist C++14-Header-only). Da der Originalcode mit GCC 5+ kompiliert wird, kein Hana-Konflikt. Im C++23-Modul-Wrapper interagieren wir nicht direkt mit Hana. |
| Lizenz-Vermerk | NOTICE-Datei (ISC) bereits erstellt (Task #73) |
| Concurrency-Brueck­e | ROWEX als Konzept-Vorlage; eigene RCU-Impl. (Task #104) ersetzt EpochBasedMemoryReclamationStrategy bei Bedarf |
| Node-Inspiration | HOT-Compound-Knoten ist Schluessel-Konzept und in Bausteine_Matrix als Originalcode-Quelle gefuehrt; KEINE Re-Implementation noetig |

## 5. Code-Qualitaets-Bewertung (Habich H2: Quelle/Ziel/Aenderung)

| Kriterium | Bewertung (★ 1-5) | Begruendung |
|-----------|-------------------|-------------|
| Quelle gepflegt | ★★★ | Travis-CI sichtbar, aber Stand 2018, kein modernes CI-Update; codecov vorhanden |
| Doku-Qualitaet | ★★★ | README ausfuehrlich (8.6 KB), aber keine Doxygen-Doku, keine Architektur-Doku |
| Test-Abdeckung | ★★★★ | umfangreiche Tests (~25 000 LOC); aber stark an Testdaten gekoppelt |
| Ueberein­stimmung mit Originalpaper | ★★★★★ | Author = einer der HOT-Autoren, "cleaned-up version der Original-Publikation" |
| Adapter-Aufwand | ★★★ | TBB-Pfad weglassen, Submodule-Cluster nicht initialisieren; aber Header-only Inkludierung der Compound-Node-Bauteile direkt moeglich |
| **Bauszenario** | **Quelle:** HOT-Original-Code in C++14 mit GCC 5+ Original-Compiler → **Ziel:** Originalcode-Bausteine in `ext/P02-HOT/hot/`, Modul-Wrapper in C++23 (F-EXTRA-1 Compiler-Layering) → **Aenderung:** keine im Originalcode (Habich-Direktive: exakt kopiert); Adapter-Header in `adapters/P02-HOT/` re-exportiert via Concept-Constraints |

## 6. Compile-Test-Plan

| Aktion | Erfolgs-Kriterium |
|--------|-------------------|
| (a) Klon im Cluster | ✅ erledigt |
| (b) Eigenstaendiger CMake-Build (mit Submodulen) | OFFEN — riskant wegen TBB |
| (c) Testsuite-Lauf | OFFEN — wahrscheinlich nur fuer Konzept-Verifikation noetig |
| (d) Adapter-Build (Subset ohne TBB) | OFFEN — Phase 6 |

## 7. Offene Punkte / Beobachtungen

- **F-EXTRA-1 Compiler-Layering — Korrektur Re-Verifikation 2026-05-09:** HOT-Bausteine bleiben C++14 und werden mit GCC 5+ kompiliert (Habich-Direktive: Originalcode exakt unangetastet). Der C++23-Hauptcompiler ist nur fuer den Modul-Wrapper, der die GCC-5-Object-Files statisch linkt. Erste Fassung dieses Dokuments hatte das missverstanden ("C++14 → C++23 Aufwertung erforderlich") — korrigiert.
- **Submodule:** TBB, boost-hana, boost-cmake, bilke-cmake-modules — bei Einbindung NICHT initialisieren (siehe `feedback_no_git_submodules.md`).
- **ROWEX-Konzept:** Wert fuer F8-Slot der PRT-ART. Eigene Re-Impl. statt Code-Uebernahme.
- **SampleTriples.cpp 10 011 LOC:** generierte Testdaten — irrelevant fuer Adapter-Pfad.

## 8. Verweise

- **Voranalyse-Output:** `_voranalyse_output_klasse_a/P02-HOT__hot.txt`
- **NOTICE-Eintrag:** `comdare-cache-engine/NOTICE` (ISC, Copyright Robert Binna 2018)
- **Bausteine_Matrix:** `PAGE_COMPOUND_HOT`, `NODE_HOT_COMPOUND_K32`, `NODE_HOT_BINODE`, `TRAVERSAL_DISCRIMINATIVE_BITS` → ext/P02-HOT/hot/. Achse 8 ROWEX (P02 Konzept-Bezug fuer F2-Concurrency).
- **Re-Impl. Modul:** kein LEGACY_REIMPL — Originalcode direkt einbindbar via Compiler-Layering (F-EXTRA-1)
