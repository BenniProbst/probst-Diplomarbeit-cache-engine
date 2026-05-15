# A18 — Old is Gold: Optimizing Single-threaded Applications with Exgen-Malloc

## Bibliographie
- **Titel:** Old is Gold: Optimizing Single-threaded Applications with Exgen-Malloc
- **Autoren:** Ruihao Li, Lizy K. John, Neeraja J. Yadwadkar (UT Austin Sysml-Group)
- **Venue:** **IEEE CAL 2025** (Computer Architecture Letters), Submitted Oct 11, 2025
- **arXiv:** [arxiv.org/abs/2510.10219](https://arxiv.org/abs/2510.10219)
- **PDF:** [ut-sysml.ece.utexas.edu/publications/prints/cal2025_li.pdf](https://ut-sysml.ece.utexas.edu/publications/prints/cal2025_li.pdf)
- **IEEE Xplore:** [ieeexplore.ieee.org/document/11075519](https://ieeexplore.ieee.org/document/11075519/)
- **Status:** **Newest** — Hot Topics in Operating Systems Workshop / IEEE CAL 2025

## Kerninnovation — Modern Single-Threaded Allokator

**Beobachtung der Autoren:** Single-threaded Apps sind im Datacenter wieder relevant (Container-Workloads, Microservices), aber moderne Allokatoren (mimalloc, tcmalloc, jemalloc) sind fuer Multi-Threading optimiert → unnoetiger Overhead bei Single-Thread.

**Loesung:** Allokator **purpose-built fuer Single-Threaded** Apps:
- Eliminiert unnoetige Multi-Thread-Metadata
- Vereinfacht Control-Flow
- Aber **uebernimmt moderne Designs** (Free-List-Sharding etc.) die in legacy Single-Thread-Allokatoren wie dlmalloc fehlen

## Architektur

### Heap-Layout
- **Centralized Heap** (1 Heap fuer den einen Thread)
- **Single Free-Block List** (kein Per-Thread-Cache noetig!)
- **Balanced Strategy** fuer Memory-Commitment + Relocation

### Segments + Pages
- **Segment-Size:** typ. **4 MiB**
- Pro Segment: subdivided in **Pages tailored fuer Block-Size-Klassen**
- Page-Metadata: block size + capacity + alloc/free counts + **single pointer** zu Free-Block-List

### Page-Metadata-Compaction
- Page-Metadata **adjacent zu den Blocks** die sie beschreibt
- → **minimaler Pointer-Chase**
- → **erhoehte Cache-Residency** der Allokation-Control-Information

### Fine-Grained Size Classes
- **8-byte steps** size classes (statt power-of-2)
- → reduce Internal Fragmentation
- → accommodates diverse Block-Sizes typischer moderner Apps

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | Exgen-Malloc-Konkretisierung |
|-------|-------------------------------|
| **AA1 FreeList-Topologie** | **Single Free-Block List** (single-thread!) + Page-local Free-Pointers |
| **AA2 Size-Class-Schema** | **8-Byte-Step** fine-grained classes (statt power-of-2) |
| **AA3 Thread-Locality** | **N/A** — Single-Thread by Design |
| **AA4 Synchronization** | **Keine** — Single-Thread eliminiert alle Locks/Atomics |
| **AA5 Allocation-Policy** | Hot path: page-local free-block pop; Slow: new page from segment |
| **AA6 Reclamation** | Page returns to centralized free-block list |
| **AA7 Fragmentation-Strategy** | 8-Byte fine-grained reduces internal frag; Page-Metadata-Compaction reduces overhead |

## Performance-Resultate

Auf Intel Xeon Systemen:

| Benchmark | Speedup vs dlmalloc | Memory-Saving vs mimalloc |
|-----------|---------------------|----------------------------|
| **SPEC CPU2017** | **1.17×** | 6.2% |
| **redis-benchmark** | 1.10× | 0.1% |
| **mimalloc-bench** | **1.93×** | **25.2%** |

**Wichtige Beobachtung:** Exgen-Malloc ist auf SPEC CPU2017 **schneller** als mimalloc — auf single-thread-Workloads wo mimalloc's Multi-Thread-Optimierungen Overhead sind.

## Bedeutung fuer Comdare-CacheEngine

1. **Single-Thread-Optimization** = **wertvolle Permutations-Option** fuer Comdare CacheEngine wenn `single_threaded_only_workload` flag gesetzt
2. **Page-Metadata Compaction** = **brillante Cache-Optimization** — direkt anwendbar fuer Comdare's PRT-ART Pool A/B/C/D Headers
3. **8-Byte fine-grained Size-Classes** = Pflicht-Konkretisierung wenn Workload **size-diverse** ist (typisch fuer Trie-Internals mit varying Knoten-Groessen)
4. **"Old is Gold" Lesson:** moderne Allokatoren sind nicht **immer** besser — Workload-spezifische Optimierung ist entscheidend
5. Direkter Bezug zu **Comdare PRT-ART OLC Single-Writer Mode:** in dieser Konfiguration koennte Exgen-Malloc-style Single-Thread Allokation Overhead sparen
6. **2025-Hot-Topic** = Aktualitaets-Pflicht in Diplomarbeit-Literatur-Review

## Lizenz + Code-Verfuegbarkeit

- **Code:** vermutlich GitHub bei UT Austin SysML-Group
- **Paper:** arXiv-Open-Access + IEEE CAL
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A18-exgen-malloc/`

## Verwandte Werke

- A20 dlmalloc (Doug Lea) — der "alte" Vergleichs-Baseline (Single-Thread-Allokator)
- A04 mimalloc — moderner Multi-Thread-Konkurrent (auf Single-Thread suboptimal)
- A06 tcmalloc — moderner Multi-Thread-Konkurrent
- A05 jemalloc — moderner Multi-Thread-Konkurrent
