# STRUKTUR_NOTIZ — P25 prefetching (hpides/prefetching, Mahling/Weisgut/Rabl 2025)

**Paper:** P25 — Mahling/Weisgut/Rabl 2025 — "Fetch Me If You Can: Evaluating CPU Cache Prefetching and Its Reliability on High Latency Memory" (DaMoN 2025)
**Repo:** `hpides/prefetching` (HPI Data Engineering Systems)
**Lokal:** `Forschungsarbeiten/code/P25-Mahling-FillBuffer/prefetching/`
**Lizenz:** **KEINE LICENSE-Datei** — README markiert „This is just the initial Code dump". Architekt-Direktive 2026-05-08: keine-Lizenz im akademischen Forschungskontext zulaessig (modularisierte Bruchstuecke + C++23-Metaprogrammierung = neues Werk).
**Voranalyse:** `_voranalyse_output_klasse_a/P25-Mahling-FillBuffer__prefetching.txt` (2026-05-09)
**Stand der Notiz:** 2026-05-09

---

## 1. Repository-Klassifikation

| Feld | Wert |
|------|------|
| Klasse | A — geklonter Originalcode (HPI Data Engineering Systems Lab) |
| Originalpaper-Code? | JA (Microbenchmarks fuer das DaMoN'25-Paper) |
| C++-Standard (CMake) | C++20 (`set(CMAKE_CXX_STANDARD 20)`) |
| Build-System | CMake (CMakeLists.txt 53 Zeilen) + `setup.sh` + `cmake/` |
| Compiler-Anforderungen | GCC mit C++20-Coroutines-Support |
| ISA-Anforderungen | x86_64; LFB-spezifische Mikrobenchmarks |
| Externe Abhaengigkeiten | `third_party/` (Submodule, .gitmodules vorhanden, 565 Bytes) |
| LOC (gesamt source) | 17 044 |
| Top-LOC-Datei | `src/lib/HashJoin/npj2epb.c` (1 069), `src/lib/BTree/coro_lines_btree_olc.h` (815) |

## 2. Verzeichnis-Hierarchie

```
prefetching/
├── src/
│   ├── benchmark/                — 22 Mikrobenchmarks (LFB-Verhalten, Pointer-Chasing, ROB-Druck, etc.)
│   │   ├── lfb_full_behavior.cpp / lfb_reliability.cpp / lfb_scale_benchmark.cpp / lfb_size_benchmark{,_smt}.cpp
│   │   ├── prefetch_latency.cpp / prefetch_locality_behavior.cpp
│   │   ├── pointer_chasing.cpp / old_pointer_chasing.cpp
│   │   ├── rob_pressure.cpp / cache_size_nvlink.cpp
│   │   ├── btree_benchmark.cpp / hashmap_benchmark.cpp / hash_join.cpp / cssl.cpp
│   │   ├── tree_simulation_benchmark.cpp (708 LOC)
│   │   └── utils/{stats,zipfian_int_distribution,fujitsu_memory_allocation}.hpp
│   ├── lib/
│   │   ├── BTree/                — **5 BTree-Varianten mit Coroutinen + OLC + Prefetch**
│   │   │   ├── btree_olc.h                      (581 LOC, baseline OLC)
│   │   │   ├── coro_btree_olc.h                 (691 LOC)
│   │   │   ├── coro_btree_olc_optimized.h       (665 LOC)
│   │   │   ├── coro_base_btree_olc.h            (650 LOC)
│   │   │   ├── coro_lines_btree_olc.h           (815 LOC)
│   │   │   ├── btree_vectorized_helper.h        — SIMD-Helfer
│   │   │   ├── prefetch.h                       — Prefetch-Helfer
│   │   │   └── builtin.h, coro.h
│   │   ├── BinarySearch/         — coroutined binary search (coro.h, sm.h, naive.h)
│   │   ├── HashJoin/             — Klassischer NPJ HashJoin (npj2epb.c 1 069 LOC, generator.c)
│   │   ├── coroutine.hpp         — Coroutine-Hilfen
│   │   ├── numa/                 — NUMA-Allocator
│   │   ├── profiling/            — Profiling
│   │   └── utils/                — Hilfen (utils.cpp 280 LOC)
│   ├── perf_configs/             — Linux perf-event Konfigs
│   └── test/                     — Tests
├── third_party/                  — Submodule
├── visualization/MT_final/       — Auswertung (MT = Master Thesis Mahling)
├── notes_dump/                   — Author-Notizen (TBD-Cleanup)
└── scripts/                      — Hilfsskripte
```

## 3. Bausteine-Klassifikation (Achsen 1-11)

| Achse | Identifizierte Implementierung | Quelldatei(en) |
|-------|-------------------------------|----------------|
| **1 Page** | implizit (BTree-Knoten als Page) | `btree_olc.h` |
| **2 Node** | klassisches B+Tree-Node mit OLC, jeweils mit/ohne Coroutinen | `btree_olc.h` und coro-Varianten |
| **3 Traversal** | **Coroutined Pointer Chasing** + Prefetch-Pipeline (paper-Hauptbeitrag) | `coro_*_btree_olc.h`, `pointer_chasing.cpp` |
| **4 ValueHandle** | uint64_t (Integer-Werte) | (typisch fuer Microbenchmarks) |
| **5 MemoryLayout** | NUMA-aware (`src/lib/numa/`); Fujitsu-Memory-Allocation `utils/fujitsu_memory_allocation.hpp` | `numa/`, `utils/fujitsu_*` |
| **6 Allocator** | NUMA-aware; Fujitsu-spezifische Allocators | `lib/numa/`, `utils/` |
| **7 Prefetch** | **35+43 Treffer fuer Prefetch/prefetch in Source** — KERN-THEMA des Papers | grep |
| **8 Concurrency** | **OLC** (4 Dateien) + **Coroutinen** als Concurrency-Pattern | `*_olc*.h`, `coroutine.hpp` |
| **9 ISA** | x86_64 + LFB (Line-Fill-Buffer) Mikroarchitektur-Untersuchung | `lfb_*.cpp` |
| **10 Measurement** | **22 Mikrobenchmarks** + perf-Configs + zipfian_int_distribution.hpp + stats.hpp | `benchmark/`, `perf_configs/` |
| **11 Telemetry-Strategy** | Counter-Treffer (4 Dateien); perf-event-Integration | `perf_configs/` |

**Hervorhebung:** Mahling-Code ist **die wichtigste Quelle fuer F7-Prefetch** und liefert **Coroutined Prefetch Pipeline** als alternative zur klassischen Software-Prefetch-Insertion. Direkter Inspirationsfluss fuer PRT-ART F7 (Prefetch).

## 4. Adapter-Strategie fuer comdare-cache-engine

| Strategie-Punkt | Entscheidung |
|-----------------|--------------|
| Einbindung-Form | **Code-Adapter MOEGLICH** — Architekt-Direktive 2026-05-08 erlaubt keine-Lizenz im Forschungskontext. Bausteine_Matrix verweist `PREFETCH_FILL_BUFFER_AWARE` auf `ext/P25-Mahling/prefetching/`. |
| Compiler-Layering (F-EXTRA-1) | Bausteine-Internals mit GCC 11+ (P25 nutzt C++20 Coroutines); Modul-Wrapper bleibt C++23 |
| Konzept-Quelle | **JA, Hauptquelle fuer F7-Prefetch** (35+43 Treffer) + **F8-Coroutinen-Concurrency** (alternative zu OLC/RCU) |
| Coroutined Prefetch | innovatives Pattern — direkt als Originalcode einbindbar, plus konzeptuell weitergetragen in PRT-ART |
| Lizenz-Vermerk | NOTICE-Datei (PENDING — KEINE LICENSE) — als Originalcode-Quelle markiert mit Direktive-Bezug |
| Talos-Kompatibilitaet | NUMA-aware Code mit Fujitsu-Memory-Allocator → COMDARE-Production hat KEINE Fujitsu-Hardware (Ryzen 9950X3D + i9-14900KS, Block AO); muss per F4 Abstract Factory + plattform-spezifischer HBM/X3D-Allocator (Task #106) ersetzt werden |
| LEGACY_REIMPL-Bedarf | **TEILWEISE** — Originalcode-Bausteine direkt einbindbar; aber NUMA-Allocator muss gegen plattform-spezifische COMDARE-Variante getauscht werden |

## 5. Code-Qualitaets-Bewertung (Habich H2: Quelle/Ziel/Aenderung)

| Kriterium | Bewertung (★ 1-5) | Begruendung |
|-----------|-------------------|-------------|
| Quelle gepflegt | ★★ | "initial Code dump" laut Author-Hinweis; Cleanup TBD |
| Doku-Qualitaet | ★ | README sehr knapp (1.1 KB); `notes_dump/` weist auf unaufgeraeumte Notizen hin |
| Test-Abdeckung | ★★ | `src/test/` vorhanden, aber Tests sind primaer Microbenchmarks |
| Ueberein­stimmung mit Originalpaper | ★★★★ | Microbenchmarks = paper-Beitrag, aber Code-Doku entspricht nicht Paper-Klarheit |
| Adapter-Aufwand | ★★★ — Originalcode-Bausteine kompilierbar; Fujitsu-Allocator gegen X3D-V-Cache- und HBM-Allocator (Task #106) tauschen |
| **Bauszenario** | **Quelle:** KEINE Lizenz, C++20 Coroutined Prefetch, Fujitsu-spezifisch → **Ziel:** Modul-Wrapper in C++23 mit GCC 11+ kompilierten Bausteinen, plattform-Allocator gemaess F4 → **Aenderung:** Originalcode bleibt im Original-Compiler-Build; nur Allocator-Achse via Abstract Factory anders verdrahtet |

## 6. Compile-Test-Plan

| Aktion | Erfolgs-Kriterium |
|--------|-------------------|
| (a) Klon im Cluster | ✅ erledigt |
| (b) Lizenz-Klaerung | OFFEN — Task #74 (Email an Mahling/Weisgut/Rabl) |
| (c) CMake-Build | OFFEN — bei Lizenz-OK |
| (d) Mikrobenchmarks-Lauf zur Reproduktion der DaMoN-Resultate | NICE-TO-HAVE |

## 7. Offene Punkte / Beobachtungen

- **KEINE LICENSE — Architekt-Direktive 2026-05-08 (Re-Verifikation 2026-05-09):** akademische Nutzung im Forschungskontext erlaubt. Email-Anfrage an Author bleibt offen (Task #74) zur formellen Klaerung, aber kein Block der Bausteine-Einbindung.
- **Achse 11 (Telemetry-Collection-Strategy):** P25's Counter-Treffer + adaptive Prefetch-Distanzen passen zu LeafOnlySampledCounter und SamplingRateAdjustmentTree (Kuehn-Erkenntnisse 2026-05-09); Cross-Bezug fuer F11-Diskussion in Diplomarbeit.
- **Production-Plattform (Block AO):** Ryzen 9 9950X3D X3D-V-Cache (96+32 MiB asymmetrisch) + i9-14900KS Hybrid-CPU mit cpu_core/cpu_atom-Trennung — Mahling's NUMA-Logik passt nicht direkt; muss ersetzt werden.
- **Author-Hinweis im README:** "This is just the initial Code dump. Clean-up and documentation are TBD." — d.h. der Code ist nicht produktionsreif strukturiert.
- **5 BTree-Varianten in `src/lib/BTree/`:** ausgezeichnete Vergleichsbasis. Direkt fuer Bausteine-Permutations-Studie der PRT-ART relevant.
- **`coro_lines_btree_olc.h` 815 LOC:** wahrscheinlich die optimierteste Coroutined-OLC-Variante; lesenswert.
- **`fujitsu_memory_allocation.hpp`:** Fujitsu-spezifisch (vermutlich A64FX SVE-Cluster); nicht auf COMDARE-Hardware portierbar.
- **NUMA-Allocator (`lib/numa/`):** wertvoll fuer X3D-V-Cache-Awareness der Comdare-Production-Plattform (Ryzen 9950X3D).
- **`tree_simulation_benchmark.cpp` 708 LOC:** simuliert Cache-Hierarchien; passt sehr gut zu COMDARE F11-Forschungs-Mission.

## 8. Verweise

- **Voranalyse-Output:** `_voranalyse_output_klasse_a/P25-Mahling-FillBuffer__prefetching.txt`
- **NOTICE-Eintrag:** `comdare-cache-engine/NOTICE` (KEINE LICENSE — akademische Nutzung im Forschungskontext, Architekt-Direktive 2026-05-08)
- **Bausteine_Matrix:** `PREFETCH_FILL_BUFFER_AWARE` → ext/P25-Mahling/prefetching/. Achse 8 OLC+Coroutinen (P25) ist alternative Concurrency-Mechanik. Achse 11 (Telemetry-Strategy) Cross-Bezug zu LeafOnlySampledCounter.
- **Re-Impl. Modul:** kein LEGACY_REIMPL-Skelett — Originalcode direkt einbindbar via Compiler-Layering (F-EXTRA-1)
- **Email-Tracking:** Task #74 (Author-Antwort offen)
- **Direktbezug zu COMDARE-Forschung:** F11-Telemetry-Strategy + F7-Prefetch sind durch P25 stark beeinflusst
