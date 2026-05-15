# A06 — TCMalloc: Thread-Caching Malloc

## Bibliographie
- **Original-Tech-Report:** Sanjay Ghemawat, Paul Menage (Google) — "TCMalloc: Thread-Caching Malloc", 2009 — [gperftools.github.io/gperftools/tcmalloc.html](https://gperftools.github.io/gperftools/tcmalloc.html)
- **Modern Design Doc:** Google TCMalloc Design (2024+) — [google.github.io/tcmalloc/design.html](https://google.github.io/tcmalloc/design.html)
- **Code-Repo:** [github.com/google/tcmalloc](https://github.com/google/tcmalloc) (Apache 2.0)
- **Legacy-Code:** [github.com/gperftools/gperftools](https://github.com/gperftools/gperftools)
- **Wissenschaftliches Folge-Paper:** "Characterizing a Memory Allocator at Warehouse Scale" — ASPLOS 2024 (siehe A14)
- **Status:** **Production-grade** — Google-internal default, Chrome-Browser, viele open-source Projekte

## Kerninnovation

**Hierarchical Cache:** Thread-Local-Cache (lockless) → Central-Cache (per-size-class lock) → Page-Heap (lock).

→ Common-Path is **lockless and CPU-local**.

## Architektur — Hierarchie

```
malloc(size)
   ↓
[1] FRONT END
    └─ Per-Thread Cache (small size classes, ≤256 KiB)
       OR Per-CPU Cache (Linux RSEQ-based, modern variant)
   ↓ (cache miss)
[2] MIDDLE END
    └─ Transfer Cache (per size class) + Central FreeList (per size class)
   ↓ (centralFL empty)
[3] BACK END
    └─ Page Heap
       ├─ Legacy Page-Allocator (TCMalloc Pages)
       └─ Hugepage-Aware Allocator (2 MiB chunks, modern)
```

### Per-Thread Cache (Legacy)
- 1 single-linked list pro size class
- Per-Thread bounded by `KMinThreadCacheSize = 512 KiB`
- Total bounded via `SetMaxTotalThreadCacheBytes` (typ. 32 MiB)
- Adaptive `max_per_class` per size class

### Per-CPU Cache (Modern, Linux RSEQ)
- Pro logical CPU 1 Slab (typ. 256 KiB)
- Layout: Metadata Header + Object Pointer Array
- Per-CPU lockless via **Restartable Sequences** (RSEQ syscall) — keine Locks, kein Atomic-CAS!
- Bound: `SetMaxPerCpuCacheSize`
- **Schluesselvorteil:** kein Per-Thread-Init-Cost, kein Thread-Termination-Cleanup

### Central Cache + Transfer Cache
- Pro size class **1 mutex-protected central freelist** + **transfer cache** (rapid CPU-to-CPU object batches)
- Transfer Cache verschiebt Object-Batches zwischen CPUs **ohne** dass jeder Object-Move den Lock hold muss

### Page Heap
- **Spans:** Sequenz von 1+ TCMalloc-Pages der gleichen size class
- Page Sizes konfigurierbar: **4 KiB, 8 KiB, 32 KiB, 256 KiB**
- Span fuer Small Objects: bis zu 2^16 = 65,536 Objects pro Span
- Span-IDs: 2-byte indices fuer Cache-effiziente Free-Linked-Lists

### PageMap (Radix Tree)
- 2- oder 3-Level Radix-Tree
- Mapping: Virtual Page → Span
- O(1) Lookup bei Free fuer Span-Identifikation

### Hugepage-Aware Backend
3 Caches im Modern Backend:
- **Filler:** sub-hugepage allocations (verteilt kleinere Anfragen ueber Hugepages)
- **Region:** cross-hugepage packing
- **Hugepage Cache:** ≥ 2 MiB allocations
- Reduziert TLB-Misses fuer Large-Footprint Apps

## Size Classes

- **~88 size classes** (genau 60-80 je nach Konfig)
- Alignment: 8-Byte fuer `operator new` wenn `__STDCPP_DEFAULT_NEW_ALIGNMENT__ ≤ 8`, sonst 16-Byte
- Size classes carefully chosen fuer minimal internal fragmentation + cache-line alignment

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | tcmalloc-Konkretisierung |
|-------|---------------------------|
| **AA1 FreeList-Topologie** | Per-Thread/Per-CPU: single-linked Object Lists; Central: per-class linked list; Span: 2-byte indexed array (Cache-effizient) |
| **AA2 Size-Class-Schema** | ~88 carefully chosen Klassen; max ~12.5% internal frag |
| **AA3 Thread-Locality** | **2 Modi:** Per-Thread Cache (legacy) ODER **Per-CPU Cache via RSEQ** (modern, Pflicht ab Linux 4.18+); Per-CPU ist Default-Future |
| **AA4 Synchronization** | Per-CPU: lockless via RSEQ (kein Atomic noetig!); Central: mutex per size class; Page Heap: 1 lock |
| **AA5 Allocation-Policy** | Bottom-up: try thread/CPU cache → central cache → page heap → mmap |
| **AA6 Reclamation** | Adaptive max_per_class steals from underused classes; Page release back to OS via madvise; Decay-based |
| **AA7 Fragmentation-Strategy** | Size-class density (~88) + page-class alignment; Hugepage-aware reduces external frag fuer Large-Footprint |

## Restartable Sequences (RSEQ) — Kritisches Detail

**Restartable Sequences** sind ein Linux-Kernel-Feature (added in 4.18, 2018):
- Userspace markiert eine "critical section"
- Kernel restart die Sequence wenn der Thread preempted wird **innerhalb** der Section
- → **Lockless-Updates ohne CAS** moeglich!

**TCMalloc Per-CPU Cache exploits RSEQ:**
- malloc-Hot-Path: load slab pointer, decrement count, store object — alles in RSEQ
- Wenn preempted: kernel restart sequence — value kann aber stale sein
- → Allocator validates value before use; if stale, retry

**Performance:** RSEQ Per-CPU Cache **schneller** als Per-Thread Cache (kein TLS-Setup, kein Cache-Per-Thread-Memory-Bloat)

## Performance-Resultate

- **Google-internal Production:** 50%+ aller Allocations in Per-CPU Cache (Cache-Hit-Rate >99% nach Warmup)
- **Hugepage-Aware:** typ. **30-40% TLB-Miss-Reduktion** bei Large-Footprint Apps
- **vs jemalloc:** ~5-10% schneller im Mittel, **deutlich** schneller bei Hugepage-Workloads
- **vs Hoard/Glibc:** 2-5× schneller in Multi-CPU-Workloads

## Bedeutung fuer Comdare-CacheEngine

1. **Per-CPU Cache via RSEQ** = **Pflicht-Konkretisierung** fuer Linux-Talos-Cluster — `c06_allocation_engine.aa3_thread_locality.PerCpuRseqCache` Atom
2. **Hierarchical Cache (Front+Middle+Back)** = direkte Vorlage fuer Comdare-Allokator-Architektur (3 Layers ↔ Comdare's CacheEngine→ExecutionEngine→SearchEngine!)
3. **Span = 2-byte indexed array** = elegant fuer Cache-Effizienz; Vorlage fuer PRT-ART Pool B (Array[65535]) Index-Encoding
4. **PageMap Radix-Tree** = analog SuRF (P10) fuer Page→Span-Lookup; Wiederverwendung der SuRF-Library moeglich
5. **Hugepage-Aware Backend** = Pflicht-Achse fuer **Large-Memory Workloads** (z.B. PRT-ART mit Millionen-Trie-Nodes)
6. **Transfer Cache** = clever! Batch-Transfer zwischen Caches reduziert Lock-Hold-Time
7. **Adaptive max_per_class** = Beispiel fuer **Cache-Engine-Heuristic-Atom** (steals from underused classes)

## Lizenz + Code-Verfuegbarkeit

- **Lizenz:** Apache 2.0
- **Repo:** [github.com/google/tcmalloc](https://github.com/google/tcmalloc) (modern), [github.com/gperftools/gperftools](https://github.com/gperftools/gperftools) (legacy)
- **Plattformen:** Linux primarily (RSEQ requires Linux 4.18+); macOS/BSD partial
- **Build-System:** Bazel (modern) / Autoconf (legacy)
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A06-tcmalloc/` (modern Google-Variante)

## Verwandte Werke

- jemalloc (A05, Evans 2006) — Multi-Arena-Konkurrent, etwas weniger Per-CPU-Optimierung
- mimalloc (A04, Leijen 2019) — modernster Free-List-Sharding-Konkurrent
- snmalloc (A07, Liétar 2019) — Message-Passing-Approach
- Hoard (A01, Berger 2000) — Per-Processor-Heap-Vorlaeufer
- ASPLOS 2024 TCMalloc-Charakterisierung (A14, Zhou et al.) — Warehouse-Scale-Performance-Analyse
