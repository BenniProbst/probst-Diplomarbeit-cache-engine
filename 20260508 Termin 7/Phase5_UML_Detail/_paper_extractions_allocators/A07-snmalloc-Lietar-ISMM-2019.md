# A07 — snmalloc: A Message Passing Allocator

## Bibliographie
- **Titel:** snmalloc: A Message Passing Allocator
- **Autoren:** Paul Liétar, Theodore Butler, Sylvan Clebsch, Sophia Drossopoulou, Juliana Franco, Matthew J. Parkinson, Alex Shamis, Christoph M. Wintersteiger, David Chisnall (Microsoft Research, Imperial College London, Galois)
- **Venue:** ISMM 2019 (ACM SIGPLAN International Symposium on Memory Management), Phoenix AZ, June 2019
- **DOI:** 10.1145/3315573.3329980
- **PDF-Quelle:** [microsoft.com/en-us/research/uploads/prod/2020/04/snmalloc.pdf](https://www.microsoft.com/en-us/research/uploads/prod/2020/04/snmalloc.pdf)
- **Code-Repo:** [github.com/microsoft/snmalloc](https://github.com/microsoft/snmalloc) (MIT-Lizenz)
- **Status:** Production-grade — verwendet in Verona-Sprache, MS-Forschungsprojekten

## Kerninnovation — Message-Passing Memory Free

snmalloc adressiert spezifisch das **producer-consumer Workload** Problem:
- Thread A allociert Objekte
- Thread B (oder C, D, ...) freed sie (via shared queue, message bus, etc.)

In klassischen Allokatoren (jemalloc, tcmalloc): non-local free → atomic operation auf Owner-Thread's Cache → **Cache-Coherence-Storm**.

**snmalloc-Loesung:** Batch-Sammlung von Free'd Objects, **Message-Passing** zurueck zum Owner in Batches.

## Architektur — Radix-Tree fuer Multi-Hop Routing

```
Allocator pro Thread, jeder hat:
  - 2^k = 64 Buckets (k=6 in implementation)
  - Pending-Messages Bucket-Array

free(p):
  owner = lookup_owner(p);                      // page-table lookup
  if (owner == self):
      local_free(p);                            // direct push to local list
  else:
      bucket = (owner_id) mod 64;
      pending[bucket].push(p);                  // enqueue in bucket
      if (pending[bucket].size >= 1MB):         // batch threshold
          dispatch(bucket);                     // send batch to "next hop"

dispatch(bucket):
  recipient = (next_allocator with same bucket);
  send batch;
  // recipient processes own objects, forwards rest to OWN bucket-recipient
```

### Multi-Hop Routing
- Alle Allokatoren bilden einen logischen Ring/Mesh
- Jede Message macht **multiple Hops** durch Allokatoren
- Pro Hop: Recipient verarbeitet seine eigenen Objects, weiterleitet Rest

→ **Lock-frei**, **batch-efficient** (1 MiB Batches), **lokal**.

## Object-Klassifikation

| Klasse | Range | Allokations-Pfad |
|--------|-------|-------------------|
| **Small** | < 64 KiB | Slab-allocated, message-passing for non-local frees |
| **Medium** | 64 KiB - 16 MiB | own slab, less optimization |
| **Large** | ≥ 16 MiB | mmap directly |

## 64-bit Slab Metadata

**Innovation:** snmalloc benoetigt nur **64 Bits Metadata pro 64 KiB Slab**!

Erreicht durch:
- **Bump-Pointer-Free List Hybrid:** Slab haelt einen single bump-pointer + lazy free list
- Slab beginnt mit bump-pointer-allocation; bei first-free wird Free-List initialisiert
- → Allocation-Hot-Path = bump-pointer-increment (extrem schnell)

### Bump-Pointer-Free-List
```
slab metadata = {
    bump_pointer:  uintptr_t,      // points to next bump-allocate position
    free_list:     ptr,             // populated lazily on first free
    used_count:    uint16,
    ...
}
```

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | snmalloc-Konkretisierung |
|-------|---------------------------|
| **AA1 FreeList-Topologie** | Hybrid Bump-Pointer + lazy Free-List per Slab; Per-Thread Pending-Bucket-Array (2^k=64 Buckets) |
| **AA2 Size-Class-Schema** | Small (<64 KiB) / Medium (64 KiB-16 MiB) / Large (≥16 MiB) |
| **AA3 Thread-Locality** | Per-Thread Allocator + Per-Thread Pending-Buckets; Multi-Hop Routing fuer Cross-Thread Frees |
| **AA4 Synchronization** | **Lock-free** (atomic ops only); Batched Message-Passing reduce Atomic-Frequency drastisch |
| **AA5 Allocation-Policy** | Bump-Pointer first, dann Free-List, dann mehr Slabs allozieren; Non-Local Free → Bucket → Batch-Dispatch |
| **AA6 Reclamation** | 1 MiB Batch-Dispatch zwischen Allokatoren; Cross-Allocator-Forwarding via Multi-Hop |
| **AA7 Fragmentation-Strategy** | 64-bit slab metadata = minimaler Overhead; Slab freed bei letztem Free; Page-protection optional |

## Performance-Vergleich (mimalloc-Paper Fig. 2)

Auf 16-core AMD EPYC, niedriger ist besser (relative time):

| Benchmark | mi (mimalloc) | sn (snmalloc) | tc | je |
|-----------|----|-----|------|------|
| cfrac | 1.00 | 1.05 | 1.04 | 1.17 |
| larsonN | 1.00 | **2.07** | 2.83 | 3.14 |
| sh6benchN | 1.00 | **1.83** | 2.83 | 2.74 |
| **xmalloc-testN** (asym!) | 1.00 | **1.29** | 8.22 | 1.77 |
| **cache-scratchN** | 1.00 | **1.00** | 19.23 | 18.69 |

**Schluesselbeobachtungen:**
- snmalloc ist **stark** auf **xmalloc-testN** (1.29 vs tcmalloc 8.22): producer-consumer pattern ist genau seine Staerke
- snmalloc ist **stark** auf **cache-scratchN** (1.00 vs tc/je 19×): Cross-Thread-Free-Pattern
- Auf "normalen" Workloads (cfrac, espresso) konkurrenzfaehig mit tcmalloc/jemalloc, aber etwas hinter mimalloc

## Bedeutung fuer Comdare-CacheEngine

1. **Message-Passing-Pattern** = Pflicht-Konkretisierung fuer **Asymmetric-Producer-Consumer-Workloads** im Comdare-Plattform-Modell — z.B. bei PRT-ART wenn Insert-Thread und Update-Thread unterschiedlich sind
2. **64-bit Slab Metadata** = **enorme Inspiration** fuer Comdare's Pool-Compactness — extrem geringer Memory-Overhead
3. **Bump-Pointer + Lazy-Free-List Hybrid** = **brilliant**: Hot-Path = `pointer++`, Lazy-Init der Free-List bei erstem Free → fuer **Allocation-Heavy + Rarely-Freeing** Workloads optimal (z.B. Trie-Build-Phase)
4. **Multi-Hop Routing** = analog Comdare's IPermutationEngine routing zwischen ExecutionEngine-Instanzen
5. **2^k Bucket-Hashing** = Cache-Page-Aware Multi-Writer (REV 7 §3.3) Variante!
6. **Verona-Language-Integration** = Beweis: snmalloc ist bereit fuer **Multi-Owner Memory-Models** wie Comdare's Layer-Provider-Hierarchy

## Lizenz + Code-Verfuegbarkeit

- **Lizenz:** MIT
- **Repo:** [github.com/microsoft/snmalloc](https://github.com/microsoft/snmalloc) (aktiv gepflegt)
- **Plattformen:** Linux, FreeBSD, macOS, Windows
- **Header-only Variante** verfuegbar (snmalloc-1)
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A07-snmalloc/`

## Verwandte Werke

- mimalloc (A04, Leijen 2019) — paralleler MSR-Allokator, gleicher Zeitraum
- tcmalloc (A06, Google 2009) — Per-CPU/Per-Thread-Cache-Konkurrent
- Hoard (A01, Berger 2000) — Per-Processor-Heap-Wurzel
- Hazard Pointers (Michael 2002) — vorlage fuer batched lock-free reclamation
- Verona (Microsoft Research) — Sprach-Projekt das snmalloc verwendet (region-based memory)
