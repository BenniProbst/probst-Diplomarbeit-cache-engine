# A21 — ptmalloc2 / glibc malloc

## Bibliographie
- **Author:** Wolfram Gloger (Originator of ptmalloc, ptmalloc2, ptmalloc3)
- **Original:** ptmalloc2 ist eine Multi-Thread-Anpassung von **Doug Lea's malloc-2.7.0** (A20 dlmalloc)
- **glibc-Integration:** ptmalloc2 wurde Default-Allokator von glibc (Linux Standard C Library)
- **Modern:** glibc-malloc ist eine **stark customisierte** ptmalloc2-Variant, kontinuierlich evolved
- **Online-Doku:** Doug Lea's Page + LWN.net + verschiedene Heap-Exploitation-Tutorials
- **Code-Repos:**
  - [github.com/emeryberger/Malloc-Implementations/tree/master/allocators/ptmalloc/ptmalloc2](https://github.com/emeryberger/Malloc-Implementations/tree/master/allocators/ptmalloc/ptmalloc2) (historisch)
  - glibc malloc.c: [sourceware.org/git/?p=glibc.git;a=tree;f=malloc](https://sourceware.org/git/?p=glibc.git)
- **Status:** **Default-Allokator fast aller Linux-Distributionen** (sofern nicht via LD_PRELOAD ueberschrieben)

## Kerninnovation — Multi-Arena Heaps

ptmalloc2 erweitert dlmalloc (A20) um **Multi-Threading-Faehigkeit**:
- Mehrere unabhaengige **Arenas** (jede ein vollstaendiger dlmalloc-style Heap)
- Threads werden zu Arenas zugeordnet
- Pro Arena ein eigener Lock → reduce contention

## Architektur

### Multiple Arenas
- Default: **1 Arena pro Thread** bis zu Limit (typ. `8 × ncpu`)
- Wenn Allokator findet seine Arena gelocked: **try next arena**
- Wenn alle gelocked: **create new arena** (bis Limit)
- Arena-Switching ist transparent fuer User

### Bin-Hierarchie (mit Erweiterungen ueber dlmalloc)

#### Fast Bins (10 lists, max chunk 160 Byte auf 64-bit)
- Hot path fuer **kleinste Allocations** (<= 160 Byte)
- Single-linked list (LIFO)
- **Kein Coalescing** (Performance!)
- Periodisch via `malloc_consolidate()` zu Smallbins migriert

#### Small Bins (62 bins)
- Pro Bin **fixe Chunk-Size** (alle Chunks gleich gross)
- Doubly-linked
- Range: bis ca. 1024 Bytes (varies by config)

#### Unsorted Bin (1 bin)
- **Catch-all** fuer recently freed chunks
- Keine Size-Restriktion
- Bei malloc: durchsucht, sorted → moves zu Smallbin/Largebin

#### Large Bins (32 bins auf 64-bit)
- Pro Bin **Range von Chunk-Sizes** (erste 32 increment by 64 Byte each)
- Sorted by size (best-fit possible)
- Tree-basierte Suche moeglich

### tcache (Thread Cache, glibc 2.26+, July 2017)
- **Per-Thread Cache** vor allen anderen Bins
- 64 single-linked tcache bins per thread
- Max **7 same-size chunks per bin**
- Range: 24 - 1032 Bytes
- → Hot Path = thread-local **lockless** (analog tcmalloc!)

### Allocation-Strategie (Modern glibc)

```
malloc(size):
  if (size <= 1032 AND tcache[size_class].not_empty):
      return tcache[size_class].pop()       # FAST PATH (lockless!)

  acquire arena_lock:
      if (size <= 160):
          if (fastbin[size_class].not_empty):
              return fastbin[size_class].pop()
      if (size <= 1024):
          if (smallbin[size_class].not_empty):
              return smallbin[size_class].pop()
      # Walk unsorted bin: sort and try to satisfy
      ...
      if (size > 1024):
          search largebin (best-fit in tree-bin)
      # Last resort: split top chunk or sbrk/mmap
  release arena_lock
```

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | ptmalloc2/glibc-Konkretisierung |
|-------|----------------------------------|
| **AA1 FreeList-Topologie** | tcache (per-thread) + fastbin + smallbin + unsorted + largebin (per-arena) |
| **AA2 Size-Class-Schema** | tcache: 64 bins (24-1032 Byte 16-Byte steps); fastbin: 10 (≤160B); smallbin: 62 fixed; largebin: 32 ranged |
| **AA3 Thread-Locality** | tcache (modern glibc 2.26+); arena assignment per thread |
| **AA4 Synchronization** | Per-arena lock (mutex); tcache lockless |
| **AA5 Allocation-Policy** | tcache → fastbin → smallbin → unsorted → largebin → top → sbrk/mmap (in dieser Reihenfolge) |
| **AA6 Reclamation** | malloc_consolidate(): periodic fastbin → smallbin migration; coalescing on free; mmap-chunks freed direct to OS |
| **AA7 Fragmentation-Strategy** | Boundary-Tag-Coalesce, multiple bin granularities, mmap-threshold |

## Heap-Exploitation-Aspekte (relevant fuer Security)

ptmalloc2/glibc-malloc ist ein **populaerer Heap-Exploitation-Target**:
- **Heap-Overflow → adjacent Chunk Header korrumpieren**
- **Use-After-Free → tcache/fastbin double-free** Tricks
- **House of Spirit / House of Force / etc.** Exploitation-Techniques

→ deshalb sind A04 smimalloc und A13 StarMalloc als **hardened alternatives** entwickelt worden.

## Performance vs Modern Allocators

ptmalloc2 wird in mimalloc-Paper (A04) als **glibc** gezeigt:
- Auf den meisten Benchmarks **schlechter** als tcmalloc/jemalloc/mimalloc
- Aber **Default** auf jedem Linux ohne Override
- Vor glibc 2.26 (ohne tcache): deutlich langsamer im Multi-Thread

## Bedeutung fuer Comdare-CacheEngine

1. **Default-Linux-Allokator** = Pflicht-Vergleichs-Baseline in Phase-7 (analog A19 Buddy = Pflicht-Reference)
2. **Multi-Bin-Hierarchie** (fast/small/unsorted/large) = bewaehrtes Pattern, aber zu komplex fuer Comdare's Diplomarbeit-Scope
3. **tcache (glibc 2.26+)** = Beweis: auch Klassiker uebernehmen Per-Thread-Cache (analog tcmalloc/jemalloc)
4. **House-of-XXX-Exploitation** = wichtige Lehre fuer Comdare's Hardening-Variant — **Metadata-Trennung** ist entscheidend (analog A13 StarMalloc)
5. **Arena-Pattern** = analog jemalloc (A05), aber simpler — zeigt: Multi-Arena ist robust + skalierbar
6. **NICHT** als Default-Konkretisierung in Comdare; aber als **Vergleichs-Baseline** in Allokator_Matrix.txt

## Lizenz + Code-Verfuegbarkeit

- **Lizenz ptmalloc2 original:** GPL (Wolfram Gloger Code) + LGPL (glibc-Variante)
- **glibc malloc:** **LGPL v2.1+** (Lesser GPL — kompatibel mit Most Open Source)
- **Plattformen:** Linux primarily; FreeBSD optional
- **Embedded-Variants:** uClibc, musl haben eigene malloc-Implementationen (NICHT ptmalloc2)
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A21-ptmalloc2/` (Emery-Berger-Mirror als historische Vorlage; glibc-Source als modern Reference)

## Verwandte Werke

- A20 dlmalloc (Doug Lea) — Vorlage
- A04 mimalloc — moderner Konkurrent (oft 14% faster than glibc-malloc)
- A05 jemalloc — alternativer Konkurrent (oft 5-10% faster than glibc-malloc)
- A06 tcmalloc — Google-Konkurrent (oft 5-10% faster)
- A18 Exgen-Malloc (2025) — Single-Thread-Konkurrent (1.93× faster auf mimalloc-bench)
- A13 StarMalloc — verifizierte hardened Alternative
