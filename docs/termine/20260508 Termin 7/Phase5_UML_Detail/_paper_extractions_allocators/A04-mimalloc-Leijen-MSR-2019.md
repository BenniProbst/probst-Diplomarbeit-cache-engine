# A04 — Mimalloc: Free List Sharding in Action

## Bibliographie
- **Titel:** Mimalloc: Free List Sharding in Action
- **Autoren:** Daan Leijen, Benjamin Zorn, Leonardo de Moura (alle Microsoft Research)
- **Venue:** Microsoft Technical Report MSR-TR-2019-18, June 2019; spaeter publiziert APLAS 2019
- **PDF-Quelle:** [microsoft.com/en-us/research/wp-content/uploads/2019/06/mimalloc-tr-v1.pdf](https://www.microsoft.com/en-us/research/wp-content/uploads/2019/06/mimalloc-tr-v1.pdf)
- **Code-Repo:** [github.com/microsoft/mimalloc](https://github.com/microsoft/mimalloc) (MIT-Lizenz)
- **Code-Groesse:** **~3500 LOC** (vs tcmalloc ~20k, jemalloc ~25k)
- **Status:** Production-grade, verwendet in Microsoft-Produkten + Lean/Koka-Runtimes

## Kerninnovation — Free List Sharding

**Ein Free-List pro mimalloc-Page** (statt **ein Free-List pro Size-Class**).

**Effekt:** Allokationen erfolgen lokal innerhalb einer Page → Spatial Locality fuer functional-style/Reference-Counting-Workloads.

**Beispiel (Lean Compiler v3):** Replacement der custom single-free-list durch sharded free list per slab → **>25% Performance-Verbesserung** auf 1 GiB Heap-Workloads.

## Drei Free-Lists pro Page

```
struct mi_page_t {
    block_t*           free;          // (1) Allocation Free-List (local)
    block_t*           local_free;    // (3) Local Free-List (built up by frees)
    atomic<block_t*>   thread_free;   // (2) Thread Free-List (foreign frees)
    uint16_t           used;          // # objects in use
    uint16_t           thread_freed;  // # foreign frees observed
    uint16_t           capacity;
    uint16_t           reserved;
    bool               in_full;
    ...
};
```

### Rolle der drei Listen
| Liste | Wird von wem geschrieben? | Wird von wem gelesen? | Synchronization |
|-------|---------------------------|------------------------|-----------------|
| **free** | Owning thread (in slow path: aus local_free + thread_free konsolidiert) | Owning thread (Hot-Path malloc) | NUR Single-Thread |
| **local_free** | Owning thread (jeder lokale Free pusht hier statt zu free) | Owning thread (Slow-Path: tauscht mit free) | NUR Single-Thread |
| **thread_free** | Andere Threads (atomic_push bei non-local Free) | Owning thread (Slow-Path: atomic_swap → append zu free) | atomic CAS |

### Warum Local-Free + Free getrennt?
**Ohne Local-Free:** local frees pushen direkt in `free` → free wird nie leer → slow-path nie aufgerufen → deferred-free-Callback nie ausgefuehrt → **kein temporal cadence**.

**Mit Local-Free:** garantiert nach **fixed number of allocations** wird slow-path aufgerufen — ermoeglicht **Deterministic Heartbeat** + Reference-Count-Decrement-Batching.

## Hot-Path malloc-Pfad

```c
void* malloc_in_page(page_t* page, size_t size) {
    block_t* block = page->free;        // (1) page-local free list
    if (block == NULL) return malloc_generic(size);  // slow path
    page->free = block->next;
    page->used++;
    return block;
}
```

→ **Genau 1 Conditional + 1 Pop in der Fast-Path!**

## Hot-Path free-Pfad

```c
void free(void* p) {
    segment_t* segment = (segment_t*) ((uintptr_t)p & ~(4*MB - 1));   // mask to 4MiB
    if (segment == NULL) return;
    page_t* page = &segment->pages[(p - segment) >> segment->page_shift];
    block_t* block = (block_t*)p;
    if (thread_id() == segment->thread_id) {
        // LOCAL FREE
        block->next = page->local_free;
        page->local_free = block;
        page->used--;
        if (page->used - page->thread_freed == 0) page_free(page);
    } else {
        // FOREIGN FREE
        atomic_push(&page->thread_free, block);
        atomic_incr(&page->thread_freed);
    }
}
```

## Heap-Layout

```
heap                          segment (4 MiB aligned)
┌──────────┐                  ┌─────────────────┐
│ tlb      │                  │ thread_id       │
├──────────┤                  │ page_shift      │
│ pages_   │                  │ page_kind       │
│ direct[] │ ─→ size-class    ├─────────────────┤
│ [8]      │     pointers     │ pages[]         │ → page 1 (64 KiB)
│ [16]     │     (≤1 KiB)     │ ┌─────────────┐ │   ┌──────────┐
│ ...      │                  │ │page meta    │ │   │ free     │
│ [1024]   │                  │ └─────────────┘ │   │ local_free│
├──────────┤                  ├─────────────────┤   │ thread_free
│ pages[]  │ → size-class      │ page area 1     │   │ used     │
│ lists    │                  │ (data blocks)   │   │ ...      │
└──────────┘                  └─────────────────┘   └──────────┘
```

### Segment-Groessen

| Segment-Typ | Segment-Size | # Pages | Page-Size |
|-------------|--------------|---------|-----------|
| Small Objects (<8 KiB) | 4 MiB | 64 | 64 KiB |
| Large Objects (<512 KiB) | 4 MiB | 1 | spans whole segment |
| Huge Objects (>512 KiB) | required size | 1 | required size |

→ **Uniform code path** trotz unterschiedlicher Object-Klassen.

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | mimalloc-Konkretisierung |
|-------|---------------------------|
| **AA1 FreeList-Topologie** | **Free List Sharding** — 3 Free-Lists pro Page (free + local_free + thread_free); KEINE size-class-globale Free-List! |
| **AA2 Size-Class-Schema** | pages_direct[1024]: direct array fuer Objects <1 KiB; pages[]: lists pro size class darueber; max internal frag 1/6 = 16.7% |
| **AA3 Thread-Locality** | Per-thread heap (`tlb` thread-local-buffer); pages gehoeren strikt einem thread; non-local frees via thread_free atomic-push |
| **AA4 Synchronization** | **No locks at all!** — nur atomic ops fuer thread_free; thread_id check via fs-register-read O(1) |
| **AA5 Allocation-Policy** | Fast: pop from page->free; Slow (malloc_generic): walk size-class pages, page_collect (move local_free + atomic-swap thread_free to free), page_free if empty |
| **AA6 Reclamation** | Slow path collects all 3 lists; deferred_free callback (User-Hook für reference-count batching!); page_free returns to segment; full pages moved to "full list" with NORMAL/DELAYED/DELAYING state |
| **AA7 Fragmentation-Strategy** | Internal: 1/6 = 16.7% max waste; Extra randomization in smimalloc-Variante; meta-data overhead 0.2% |

## Temporal Cadence + Deferred Free

```c
void* malloc_generic(heap_t* heap, size_t size) {
    deferred_free();   // user-defined callback (e.g., for refcount batch decrement)
    foreach (page in heap->pages[size_class(size)]) {
        page_collect(page);       // move local_free + thread_free → free
        if (page->used - page->thread_freed == 0)
            page_free(page);
        else if (page->free != NULL)
            return malloc(size);   // recurse with collected free list
    }
    /* allocate fresh page and malloc from there */
}
```

→ **Pflicht-Aufruf nach fixed # allocations** = "temporal cadence" — wertvoll fuer **deterministic heartbeat** in Lean/Koka-Runtimes.

## Full-List + Delayed-Free

Optimization fuer asymmetric workloads (gcc-Benchmark: 18000+ Full-Pages):

- Pages, deren `used == capacity` werden in **separate full list** verschoben
- Non-local free auf einer Full-Page: 2-bit state in thread_free pointer encodes:
  - `NORMAL` (default)
  - `DELAYED` (page in full-list, owning heap moved to delayed-free list)
  - `DELAYING` (transition state)
- Erste non-local free bei Full-Page → setze DELAYED + push to heap delayed_free list
- Alle weiteren non-local frees → push direkt zu thread_free (NORMAL state restored)

→ vermeidet expensive Full-List-Scans bei jedem non-local Free.

## Security-Variante (smimalloc)

| Mechanismus | Schutz |
|-------------|--------|
| OS Guard Pages zwischen mimalloc-Pages | Heap-Overflow → Page-Fault statt Heap-Meta-Korruption |
| Randomized initial free list per page | Schutz gegen "heap feng shui" (Sotirov 2007) |
| XOR-encoded free list pointers | Schutz gegen heap-block-overflow attacks |
| Multi-Heap fuer V-Tables vs App-Objects | Type-Confusion-Mitigation |

**Performance-Cost:** nur **~3% slower** als plain mimalloc — beeindruckend wenig!

## Performance-Resultate (16-core AMD EPYC)

Relative time (lower = better, normalized to mi=1.00):

| Benchmark | mi | tc | je | sn | rp | hd | glibc | tbb |
|-----------|-----|-----|-----|-----|-----|-----|-------|------|
| cfrac | 1.00 | 1.04 | 1.17 | 1.05 | 1.13 | 1.11 | 1.05 | 1.28 |
| espresso | 1.00 | 1.03 | 1.07 | 1.07 | 1.13 | 1.13 | 1.07 | 1.22 |
| barnes | 1.00 | 1.00 | 1.00 | 1.00 | 1.00 | 1.00 | 1.01 | 1.00 |
| leanN | 1.00 | 1.07 | 1.06 | 1.04 | 1.14 | 1.14 | 1.14 | 1.06 |
| redis | 1.00 | 1.07 | 1.14 | 1.08 | 1.40 | 1.49 | 1.10 | 1.39 |
| **larsonN** | **1.00** | 2.83 | 3.14 | 2.07 | 3.14 | 1.69 | 1.92 | 2.17 |
| **sh6benchN** | **1.00** | 2.83 | 2.74 | 1.83 | 2.36 | 2.37 | 3.49 | — |
| **xmalloc-testN** | **1.00** | 8.22 | 1.77 | 1.29 | 12.52 | 33.85 | 11.78 | 1.76 |
| **cache-scratchN** | **1.00** | 19.23 | 18.69 | 1.00 | 4.21 | 2.50 | 4.18 | — |

**Schluesselbeobachtungen:**
- **Average +7%** vs tcmalloc, **+14%** vs jemalloc
- **18× faster** than tc/je auf cache-scratchN (passive false sharing!)
- **8.22×** vs tc auf xmalloc-testN (asymmetric producer/consumer)
- **2.5×** vs tc/je auf larsonN (object migration)
- **Konsistent gut** ueber **alle** Benchmarks (anders als Konkurrenz mit Sudden-Underperformance)

## Verwandte Idee: VAM (Feng/Berger ISMM 2005)

VAM war Vorlaeufer der Free-List-Sharding-Idee:
- Maintained free lists per 4 KiB hardware page
- Bump-pointer support (mimalloc verwarf das wegen 2 Conditionals + Security)
- Wasn't multi-threaded
- Mimalloc verbessert: 64 KiB-Pages + Multi-Threading + 3-List-Sharding

## Bedeutung fuer Comdare-CacheEngine

1. **Free List Sharding pro Page** = direkt anwendbar fuer **PRT-ART Pool A/B/C/D** — pro Page eigene Free-List statt globaler size-class-Liste → Locality-Boost
2. **3-List-Pattern (free / local_free / thread_free)** = **Vorlage** fuer `comdare::cache_engine::allocator::concepts::SingleWriterMultiReader` mit asynchronen Foreign-Frees
3. **Temporal Cadence + Deferred Free** = perfekt fuer **PRT-ART Reference-Counting Lazy Deletion** + Density-Tracker-Konsolidierung
4. **Heap als Array von Pages organisiert nach Size-Class** = generalisierbar zu CacheEngine-Allocator-Architektur
5. **Security-Variante (smimalloc)** = optionale Achse "Allocation-Hardening" fuer **Block-AO-Plattformen** (insbesondere Production-Talos-Cluster)
6. **Code-Groesse 3500 LOC** = beweist: **Production-grade Allokator IST machbar** in begrenztem Code-Footprint — wichtig fuer Diplomarbeit-Scope!

## Lizenz + Code-Verfuegbarkeit

- **Lizenz:** MIT (sehr permissiv)
- **GitHub:** [github.com/microsoft/mimalloc](https://github.com/microsoft/mimalloc) (aktiv gepflegt seit 2019)
- **Plattformen:** Linux, FreeBSD, macOS, Windows
- **Static Linking:** trivial (~3500 LOC, single object)
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A04-mimalloc/` (vollstaendig + STRUKTUR_NOTIZ.md)
- **Bench-Suite:** [github.com/daanx/mimalloc-bench](https://github.com/daanx/mimalloc-bench) — verwendbar als Benchmark-Vorlage fuer Comdare

## Verwandte Werke

- VAM (Feng/Berger 2005) — Vorlaeufer-Idee per-page free lists
- Hoard (A01, Berger 2000) — Per-Processor heaps + superblocks
- jemalloc (A05, Evans 2006) — multiple arenas
- tcmalloc (A06, Google) — thread-local cache
- snmalloc (A07, Liétar et al. 2019) — radix-tree producer/consumer
- TBB Allocator (Kukanov/Voss 2007) — public free list per bin
