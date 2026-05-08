# STRUKTUR_NOTIZ — P20 leanstore (B-Trees Are Back)

**Paper:** P20 — Mueller/Benson/Leis 2025 — "B-Trees Are Back: Engineering Fast and Robust Indexes" (CIDR 2025) — bzw. LeanStore-Familie (Leis et al. 2018+)
**Repo:** LeanStore (FSU Jena, Maintainer: Leanstore-Familie)
**Lokal:** `Forschungsarbeiten/code/P20-BTreesAreBack/leanstore/`
**Lizenz:** MIT (Copyright 2021, FSU Jena)
**Voranalyse:** `_voranalyse_output_klasse_a/P20-BTreesAreBack__leanstore.txt` (2026-05-09)
**Stand der Notiz:** 2026-05-09

---

## 1. Repository-Klassifikation

| Feld | Wert |
|------|------|
| Klasse | A — geklonter Originalcode (LeanStore TUM/FSU-Forschungsprototyp) |
| Originalpaper-Code? | JA (LeanStore-Familie deckt mehrere Paper ab; P20-Bezug ist die B-Tree-Komponente) |
| C++-Standard (CMake) | C++20 (`set(CMAKE_CXX_STANDARD 20)` + `STANDARD_REQUIRED ON`) |
| Build-System | CMake (CMakeLists.txt 82 Zeilen) |
| Compiler-Anforderungen | GCC-modern; `RelWithDebInfo` Build-Type empfohlen |
| ISA-Anforderungen | AVX-512 (2 Dateien) |
| Externe Abhaengigkeiten | **viele!** libtbb2-dev, libaio-dev, libsnappy-dev, zlib1g-dev, libbz2-dev, liblz4-dev, libzstd-dev, librocksdb-dev, liblmdb-dev, libwiredtiger-dev, **liburing-dev** (NVMe SSD I/O) |
| LOC (gesamt source) | 23 730 |
| Top-LOC-Datei | `frontend/shared/lmdb++.hpp` (1 913 — vendored), `shared-headers/CRC.hpp` (1 705), `frontend/tpc-c/TPCCWorkload.hpp` (1 153) |

## 2. Verzeichnis-Hierarchie

```
leanstore/
├── backend/leanstore/           — Engine
│   ├── LeanStore.{cpp,hpp}      — Hauptklasse
│   ├── KVInterface.hpp          — Public KV-API
│   ├── Config.{cpp,hpp}         — Konfiguration
│   ├── concurrency-recovery/    — MVCC, Worker, GroupCommit, HistoryTree, WAL
│   ├── storage/                 — Buffer-Manager, BTree-Engine
│   │   ├── btree/
│   │   │   ├── BTreeLL.{cpp,hpp}      — Lock-Less B-Tree
│   │   │   ├── BTreeVI.{cpp,hpp}      — Versioned B-Tree (MVCC)
│   │   │   ├── core/BTreeGeneric.*    — Gemeinsame Bauteile
│   │   │   ├── core/BTreeNode.*       — Knoten-Layout (444+424 LOC)
│   │   │   └── FatTupleDifferentAttributes.cpp — Tuple-Storage
│   │   └── buffer-manager/      — Buffer-Manager (BufferManager.cpp 479 LOC, PageProviderThread.cpp 323 LOC)
│   ├── profiling/               — Counter-Suite (CPU, CR, PP, Worker; viele BMTable/CRTable/etc.)
│   ├── sync-primitives/         — Sync-Primitive
│   ├── threads/, utils/         — Helfer
├── frontend/                    — TPC-C, YCSB, Mix, Micro-Benchmarks, Minimal-Example
│   ├── tpc-c/                   — TPCC-Workload (1153 LOC)
│   └── ycsb/                    — YCSB-Treiber
├── libs/                        — externe Helfer
└── shared-headers/              — CRC.hpp (1705), PerfEvent.hpp (329)
```

## 3. Bausteine-Klassifikation (Achsen 1-11)

| Achse | Identifizierte Implementierung | Quelldatei(en) |
|-------|-------------------------------|----------------|
| **1 Page** | **PageProviderThread** + Buffer-Manager-Page (NVMe SSD-backed) | `BufferManager.cpp`, `PageProviderThread.cpp` |
| **2 Node** | **BTreeNode** (444+424 LOC) — generischer Knoten fuer BTreeLL und BTreeVI | `BTreeNode.{cpp,hpp}` |
| **3 Traversal** | **BTreeGenericIterator** (600 LOC Header) — Iterator-Interface | `BTreeGenericIterator.{cpp,hpp}` |
| **4 ValueHandle** | **FatTupleDifferentAttributes** — multi-version tuple storage (498 LOC) | `FatTupleDifferentAttributes.cpp` |
| **5 MemoryLayout** | NVMe-backed buffer pool; Page-aligned; FatTuple-Layout | `BufferManager.cpp`, `BTreeNode.hpp` |
| **6 Allocator** | Buffer-Pool mit dram_gib-Limit; PageProvider als Async-Thread | `BufferManager.cpp` |
| **7 Prefetch** | nicht prominent im grep, aber NVMe I/O via liburing (asynchron) | (durch I/O-Thread) |
| **8 Concurrency** | **Optimistic Concurrency Control** + **Snapshot Isolation** + **MVCC** mit HistoryTree + GroupCommit + WAL | `ConcurrencyControl.cpp`, `Worker.cpp`, `HistoryTree.cpp`, `Logging.cpp`, `WALEntry.hpp` |
| **9 ISA** | AVX-512 (2 Dateien) — vermutlich CRC oder String-Vergleich | (grep) |
| **10 Measurement** | **umfassende Profiling-Tabellen** (CPU, CR, BM, DT, Latency) — direkt CSV-Output | `profiling/tables/*.cpp` |
| **11 Telemetry-Strategy** | **53 Counter-Treffer im grep!** — Counter-orientierte Telemetrie mit Tabellen-Aggregation. Vergleichsbasis fuer Kuehn-Erkenntnisse `LeafOnlyCounter` und `LeafOnlySampledCounter<N>` (Glossar v7 BLOCK AJ/AL) — leanstore zaehlt pro Worker, nicht pro Knoten, daher per-se kein Cache-Coherence-Anti-Pattern (Block AI) | `profiling/counters/*` |

**Hervorhebung:** LeanStore ist die einzige Klasse-A-Quelle, die **production-grade Storage-Engine-Komponenten** (Buffer-Manager, MVCC, WAL, GroupCommit, NVMe-async-I/O) anbietet — wertvolle Architektur-Vorlage fuer F1-Page der PRT-ART.

## 4. Adapter-Strategie fuer comdare-cache-engine

| Strategie-Punkt | Entscheidung |
|-----------------|--------------|
| Einbindung-Form | **NICHT als Code-Adapter** — zu viele externe Abhaengigkeiten (rocksdb, lmdb, wiredtiger), Buffer-Pool-Architektur orthogonal zu PRT-ART |
| Konzept-Quelle | **JA, sehr stark** — fuer F1-Page (Buffer-Pool-Konzept), F11-Telemetrie (Counter-Suite) und F-EXTRA Profiling-Tabellen-Pattern |
| C++-Brueck­e | C++20 → C++23 forward-kompatibel |
| Lizenz-Vermerk | NOTICE (MIT) bereits erstellt (Task #73) |
| liburing-Bezug | LeanStore nutzt liburing fuer NVMe-async-I/O. Fuer PRT-ART (Main-Memory-Index) nicht direkt relevant. |
| TPC-C/YCSB-Workloads | **WICHTIG** — `frontend/ycsb/` ist YCSB-Treiber, der als Architektur-Vorlage fuer F-EXTRA-3 Java-YCSB-Adapter dienen kann |
| LEGACY_REIMPL-Bedarf | **NEIN, weil zu groß** — wir nehmen Konzepte, nicht Code |

## 5. Code-Qualitaets-Bewertung (Habich H2: Quelle/Ziel/Aenderung)

| Kriterium | Bewertung (★ 1-5) | Begruendung |
|-----------|-------------------|-------------|
| Quelle gepflegt | ★★★★ | aktive Wartung, .clang-format gesetzt, GitHub Actions vorhanden |
| Doku-Qualitaet | ★★★★ | README ausfuehrlich (6.9 KB), Build-Anleitung, Workload-Beispiele |
| Test-Abdeckung | ★★★ | mehr Frontend-Workloads als reine Unit-Tests; TPC-C als End-to-End-Test |
| Ueberein­stimmung mit Originalpaper | ★★★★★ | LeanStore = TUM-Forschungsprototyp, deckt mehrere Paper-Generationen ab |
| Adapter-Aufwand | ★ | Sehr hoch wegen externer Abhaengigkeiten (rocksdb/lmdb/wiredtiger/zstd/lz4/snappy) |
| **Bauszenario** | **Quelle:** MIT, C++20, viele externe Libs, NVMe-SSD-fokussiert → **Ziel:** Konzept-Studie fuer PRT-ART → **Aenderung:** Buffer-Manager-Konzept + Counter-Telemetrie als Architektur-Vorlage uebernehmen |

## 6. Compile-Test-Plan

| Aktion | Erfolgs-Kriterium |
|--------|-------------------|
| (a) Klon im Cluster | ✅ erledigt |
| (b) CMake-Build mit allen apt-get-Dependencies | OPTIONAL — nur fuer Konzept-Verifikation |
| (c) TPC-C-Lauf | OPTIONAL |
| (d) Adapter-Build | **ENTFAELLT** — Konzept-Quelle, kein direkter Adapter |

## 7. Offene Punkte / Beobachtungen

- **Externe Abhaengigkeiten:** 12 apt-get-Pakete — auf Talos OS NICHT installierbar. apt-get ist S2686b VERBOTEN; jeder Versuch musst durch DependencyManager (Memory-Direktive `feedback_curl_bootstrap_architecture.md`).
- **NVMe-SSD-Fokus:** PRT-ART ist Main-Memory-Index — LeanStore's I/O-Layer irrelevant.
- **Counter-Suite (53 Counter-Treffer!):** sehr gut strukturiert (CPU/CR/PP/Worker-Counter + Profiling-Tabellen-Klasse). Direkt als Vorlage fuer F11.
- **`shared-headers/CRC.hpp` 1 705 LOC:** vendored CRC32 — wir nutzen unsere eigene CRC oder boost-crc.
- **`shared-headers/PerfEvent.hpp` 329 LOC:** Linux perf_event_open()-Wrapper — gut als Vorlage fuer F11-Telemetry-Hardware-Counter.
- **YCSB-Treiber `frontend/ycsb/`:** Architektur-Vorlage fuer F-EXTRA-3 (Java-YCSB-Vergleich); zeigt sauberes Frontend-Backend-Decoupling.
- **`frontend/shared/lmdb++.hpp` 1 913 LOC:** vendored lmdb-Adapter — LeanStore vergleicht sich mit LMDB. Konzept-Quelle fuer eigene LMDB-Adapter, falls noetig.

## 8. Verweise

- **Voranalyse-Output:** `_voranalyse_output_klasse_a/P20-BTreesAreBack__leanstore.txt`
- **NOTICE-Eintrag:** `comdare-cache-engine/NOTICE` (MIT, Copyright FSU Jena 2021)
- **Bausteine_Matrix:** Achse 1 PAGE_BUFFER_POOL_NVME (P20), Achse 11 TELEMETRY_COUNTER_SUITE (P20), Achse 8 OCC+SI+MVCC+WAL (P20)
- **Re-Impl. Modul:** kein LEGACY_REIMPL — Konzept-Studie + selektive Pattern-Uebernahme
- **F11-Brueck­e:** LeanStore-Counter-Suite als Modell fuer COMDARE Telemetry-Collection-Strategy
- **Achse 11 (Telemetry-Collection-Strategy, Kuehn 2026-05-09) Bezug:** LeanStore zaehlt pro Worker-Thread, nicht pro Knoten — vermeidet das von Kuehn beschriebene Cache-Coherence-Anti-Pattern (Block AI). Diese pro-Worker-Counter-Strategie ist eine alternative zu `LeafOnlyCounter` (Block AJ): beide zielen auf Cache-Kohaerenz-Reduktion ab, aber an verschiedenen Trade-off-Punkten (Worker-Granularitaet vs Blatt-Granularitaet).
- **Production-Plattform-Bezug (Block AO):** LeanStore-Counter werden pro Worker-Thread gefuehrt; auf i9-14900KS muss das in P-Core- und E-Core-Counter aufgeschluesselt werden (cpu_core/cpu_atom-Trennung).
