# STRUKTUR_NOTIZ — P01 unodb (laurynas-biveinis/unodb)

**Paper:** P01 — Leis/Kemper/Neumann 2013 — "The Adaptive Radix Tree: ARTful Indexing for Main-Memory Databases" (ICDE 2013)
**Repo:** `laurynas-biveinis/unodb`
**Lokal:** `Forschungsarbeiten/code/P01-ART/unodb/`
**Lizenz:** Apache License 2.0
**Voranalyse:** `_voranalyse_output_klasse_a/P01-ART__unodb.txt` (2026-05-09)
**Stand der Notiz:** 2026-05-09

---

## 1. Repository-Klassifikation

| Feld | Wert |
|------|------|
| Klasse | A — geklonter Originalcode (Drittanbieter, hochwertige Re-Impl. der Originalidee) |
| Originalpaper-Code? | NEIN — unodb ist eine eigenstaendige Re-Impl. von ART durch Laurynas Biveinis |
| C++-Standard (CMake) | C++20 (`cxx_std_20`) |
| Build-System | CMake (CMakeLists.txt 902 Zeilen, CMakePresets.json 16797 Bytes) |
| Compiler-Anforderungen (README) | GCC ≥ 10, LLVM ≥ 11, Xcode ≥ 16.1, MSVC 2022 |
| ISA-Anforderungen | SSE4.1 (Nehalem+), AVX (MSVC), AVX2 optional, NEON auf ARM |
| Externe Abhaengigkeiten | Boost.Container (Pflicht: `small_vector`), Boost.Accumulator (optional: Stats), GoogleTest, Google Benchmark, deepstate (Fuzz) |
| LOC (gesamt source) | 31 052 |
| Top-LOC-Datei | `art_internal_impl.hpp` (3 868 LOC) |

## 2. Verzeichnis-Hierarchie (gekuerzt)

```
unodb/
├── art.hpp                    (2 108 LOC)  — Public-Header non-concurrent ART
├── art_common.hpp             (  723 LOC)  — Gemeinsame Hilfen
├── art_internal.cpp/.hpp      (  635 LOC)  — Private Implementierung
├── art_internal_impl.hpp      (3 868 LOC)  — Node-Implementierungen Node4/16/48/256
├── olc_art.hpp                (3 362 LOC)  — Optimistic Lock Coupling Variante
├── optimistic_lock.hpp        (  953 LOC)  — OLC-Primitive
├── qsbr.cpp/.hpp              (1 608+535)  — Quiescent State Based Reclamation
├── qsbr_ptr.cpp/.hpp                       — QSBR-Smart-Pointer
├── mutex_art.hpp                           — std::mutex-basierte Variante
├── portability_arch.hpp                    — ARM/x86 Detection
├── portability_builtins.hpp                — Compiler-Builtin-Wrapper
├── 3rd_party/                 — benchmark, deepstate, googletest (Submodule)
├── benchmark/                 — Micro-Benchmarks pro Node-Typ + OLC
├── examples/                  — example_art, example_olc_art, example_art_stats
├── fuzz_deepstate/            — Property-based Fuzz-Tests
└── test/                      — GoogleTest-Suite (~10 Dateien, ~5 600 LOC)
```

## 3. Bausteine-Klassifikation (Achsen 1-11)

| Achse | Identifizierte Implementierung | Quelldatei(en) |
|-------|-------------------------------|----------------|
| **1 Page** | implizit (`std::byte`-Array Sequenzen) — keine ausgewiesene Page-Abstraktion | — |
| **2 Node** | **Node4 / Node16 / Node48 / Node256** (kanonisches ART) — verifiziert via grep | `art_internal_impl.hpp` |
| **3 Traversal** | Path-Compression + Lazy Expansion + Sequential-then-SIMD-Search | `art_internal_impl.hpp`, `art.hpp` |
| **4 ValueHandle** | `db<Key,Value>` Template-Param `Value`; QSBR-geschuetzte Pointer | `qsbr_ptr.hpp` |
| **5 MemoryLayout** | Header-only Templates; `art_common.hpp` definiert Node-Layouts (cache-line aligned) | `art_internal_impl.hpp` |
| **6 Allocator** | `heap.hpp` — duenner Allokator-Wrapper; nutzt Boost `small_vector` | `heap.hpp` |
| **7 Prefetch** | Sehr eingeschraenkt — keine Treffer im grep; ART verlaesst sich auf SIMD-Suche | (nicht ausgepraegt) |
| **8 Concurrency** | **OLC** (Optimistic Lock Coupling) + **QSBR** (Quiescent State Based Reclamation) — beide implementiert | `olc_art.hpp`, `optimistic_lock.hpp`, `qsbr.{cpp,hpp}` |
| **9 ISA** | SSE4.1 (mandatorisch), AVX2 (optional), AVX-512 (1 Datei), NEON (ARM) | `art_internal_impl.hpp`, `portability_*.hpp` |
| **10 Measurement** | Micro-Benchmarks pro Node-Typ, Stats-Counter (Boost.Accumulator) | `benchmark/`, `examples/example_art_stats.cpp` |
| **11 Telemetry-Strategy** | Stats-Counter optional aktivierbar (Compile-Time-Schalter); kein per-leaf-Sampling | (Compile-Schalter) |

**Hervorhebung:** unodb ist die ein­zige Quelle in Klasse A, die OLC + QSBR voll implementiert (Konzept-Quelle fuer F8-Concurrency-Slot der PRT-ART).

## 4. Adapter-Strategie fuer comdare-cache-engine

| Strategie-Punkt | Entscheidung |
|-----------------|--------------|
| Einbindung-Form | Subset via Source-Inkludierung in `adapters/P01-ART/` (KEIN git submodule, F-EXTRA "no-submodules") |
| Header-Bridge | `adapters/P01-ART/unodb_adapter.hpp` re-exportiert `unodb::db<>` und `unodb::olc_db<>` mit COMDARE-Typen |
| Lizenz-Vermerk | NOTICE-Datei (Apache-2.0) bereits erstellt (Task #73) |
| Abhaengigkeits-Kapsel | Boost-Container muss von DependencyManager bereitgestellt werden (KEIN System-Boost) |
| Concurrency-Brueck­e | OLC/QSBR aus unodb wird **NICHT** uebernommen — eigene RCU-Impl. (F2 ✗ liburcu, eigene RCU per Task #104). unodb dient als Konzept-Referenz, nicht als Code-Lieferant fuer Concurrency. |
| Node-Inspiration | Node4/16/48/256-Layouts werden konzeptuell uebernommen, aber neu implementiert in `prt_art/node/` (Anti-Pattern „Cross-Repo-ABI-Kupplung" vermeiden) |

## 5. Code-Qualitaets-Bewertung (Habich H2: Quelle/Ziel/Aenderung)

| Kriterium | Bewertung (★ 1-5) | Begruendung |
|-----------|-------------------|-------------|
| Quelle gepflegt | ★★★★★ | Aktive Wartung 2024-2026, modernes C++20, super-linter, codecov |
| Doku-Qualitaet | ★★★★ | Doxyfile (134 KB), README umfangreich, CONTRIBUTING.md (12 KB) |
| Test-Abdeckung | ★★★★★ | ~10 Test-Dateien (~5 600 LOC), Fuzz-Tests, Concurrency-Tests, OOM-Tests |
| Ueberein­stimmung mit Originalpaper | ★★★★ | Variante (SSE4.1 statt SSE2, AVX-Optionen), Konzept identisch, dokumentiert |
| Adapter-Aufwand | ★★★ | Boost-Dependency erschwert Bare-Metal-Bauart; gut isolierbar via DependencyManager |
| **Bauszenario** | **Quelle nutzt OLC/QSBR/Boost** → **Ziel:** Konzept-Vorlage fuer eigene Node-Implementierung; **Aenderung:** Neu-Schreiben der Node4/16/48/256 in `prt_art/node/` ohne Boost |

## 6. Compile-Test-Plan

| Aktion | Erfolgs-Kriterium |
|--------|-------------------|
| (a) Klon im Cluster (NFS-Share, `comdare-cache-engine/ext/P01-ART/unodb/`) | ✅ erledigt |
| (b) Eigenstaendiger CMake-Build mit Boost vom DependencyManager | OFFEN — Phase 6 |
| (c) Testsuite-Lauf (GoogleTest) | OFFEN — Phase 6 |
| (d) Adapter-Build durch comdare-cache-engine BuildSystem | OFFEN — Phase 6 |

## 7. Offene Punkte / Beobachtungen

- **C++20 → C++23 Brueck­e:** unodb nutzt C++20-Features, COMDARE setzt C++23. Da COMDARE C++23 ist, sollte das ohne Code-Aenderung funktionieren (forward-kompatibel).
- **Submodule-Konflikt:** Repo enthaelt `.gitmodules` (3rd_party). Bei Einbindung in COMDARE-Buildsystem: Submodules NICHT initialisieren (Memory-Direktive `feedback_no_git_submodules.md`); statt dessen DependencyManager fuer GoogleTest/Benchmark.
- **DeepState fuzz_deepstate:** wird NICHT uebernommen — eigene Property-Tests via comdare TestSystem.
- **`art.hpp` (81 KB Single-Header):** koennte als „Drop-in"-Header genutzt werden ohne CMake — Option fuer Adapter-Pfad.

## 8. Verweise

- **Voranalyse-Output:** `_voranalyse_output_klasse_a/P01-ART__unodb.txt`
- **NOTICE-Eintrag:** `comdare-cache-engine/NOTICE` (Apache-2.0, Copyright Laurynas Biveinis)
- **Bausteine_Matrix:** Achse 2 Node4-256, Achse 8 OLC+QSBR (P01-Verweise)
- **Re-Impl. Modul:** kein LEGACY_REIMPL noetig — unodb steht als Klasse-A-Adapter zur Verfuegung
