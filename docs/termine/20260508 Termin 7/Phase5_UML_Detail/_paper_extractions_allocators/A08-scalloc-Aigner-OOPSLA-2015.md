# A08 — scalloc: A Scalable Allocator Based on Span-Pooling

## Bibliographie
- **Titel:** Fast, Multicore-Scalable, Low-Fragmentation Memory Allocation through Large Virtual Memory and Global Data Structures
- **Autoren:** Martin Aigner, Christoph M. Kirsch, Michael Lippautz, Ana Sokolova (Universitaet Salzburg, Austria)
- **Venue:** OOPSLA 2015 (ACM SIGPLAN International Conference on Object-Oriented Programming, Systems, Languages, and Applications)
- **DOI:** 10.1145/2814270.2814294
- **PDF-Quelle:** [ckirsch.github.io/publications/conferences/OOPSLA15-Scalloc.pdf](https://ckirsch.github.io/publications/conferences/OOPSLA15-Scalloc.pdf)
- **arXiv:** [arxiv.org/abs/1503.09006](https://arxiv.org/abs/1503.09006)
- **Code-Repo:** [github.com/cksystemsgroup/scalloc](https://github.com/cksystemsgroup/scalloc) (BSD)
- **Project-Page:** [scalloc.cs.uni-salzburg.at](http://scalloc.cs.uni-salzburg.at/)

## Kerninnovation — Virtual Spans + Global Data Structures

**Drei zentrale Design-Entscheidungen:**

1. **Uniforme Behandlung** kleiner und grosser Objekte ueber **Virtual Spans**
2. **Schnelles + skalierbares globales Reclaiming** durch globale Datenstrukturen (kein Per-Heap-Locking)
3. **Constant-time Allokation/Free** (modulo Synchronization), die Memory-Reuse + Spatial-Locality balanciert ohne False-Sharing

## Virtual Spans

**Klassische Allokatoren:** Behandeln Small/Medium/Large/Huge unterschiedlich → Code-Komplexitaet, Edge-Cases.

**scalloc:** Behandelt **alle Objekte ≤ 1 MiB als Span** — uniform!
- Span-Groessen: typ. 4 KiB, 8 KiB, 16 KiB, ..., 1 MiB
- Pro Size-Class ein Span-Pool
- Spans werden **virtuell adressiert** in **grossem Virtual-Memory-Range** → kein klassisches Buddy-Splitting noetig
- Objekte > 1 MiB → conventional mmap

### Virtual-Memory-Trick
- Reserviere riesigen virtuellen Adressraum (z.B. 2^46 Bytes auf 64-bit-Systemen)
- Pages werden **nur on-demand committed** (lazy via OS page-fault → mmap-on-demand)
- → **kein Address-Space-Mangel auf 64-bit-Systemen**!
- Vermeidet Fragmentation-Probleme klassischer Buddy-Allokatoren

## Span Lifecycle

```
allocate_object(size):
  size_class = lookup_size_class(size);
  span = thread_local_span[size_class];     // hot path, no lock
  if (span == NULL OR span.is_empty()):
      span = global_span_pool[size_class].acquire();  // lock-free pop
      thread_local_span[size_class] = span;
  return span.allocate_object();

free_object(p, span):
  span.deallocate_object(p);
  if (span.is_completely_free()):
      global_span_pool[span.size_class].release(span);
      // GLOBAL pool, but lock-free via Treiber-stack-style algorithms
```

## Global Data Structures (scaling claim)

scalloc claims **scalable global structures** — counterintuitive da global ueblich = bottleneck!

Mechanismus:
- **Treiber-stack-style** lock-free LIFO mit ABA-prevention
- Pro Size-Class **eine** globale Span-Pool
- Per-Thread holt nur 1 Span pro Burst (~1000s Allocations) → globale Lock-Frequenz ist niedrig

→ **Constant-time** im Common-Case (thread-local span); **Constant-time amortized** bei Span-Reload via global lock-free LIFO.

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | scalloc-Konkretisierung |
|-------|--------------------------|
| **AA1 FreeList-Topologie** | Per-Span: object freelist (LIFO); Pro Size-Class: globaler Span-Pool als lock-free LIFO |
| **AA2 Size-Class-Schema** | Power-of-2 Span-Sizes (4 KiB - 1 MiB); pro Size-Class own Pool; uniforme Behandlung |
| **AA3 Thread-Locality** | Thread-local active Span pro Size-Class (hot path) |
| **AA4 Synchronization** | Lock-free Treiber-stack fuer Globale Pools; Per-Thread-Span lockless |
| **AA5 Allocation-Policy** | Thread-local Span first; bei Bedarf acquire from global; Span-Allocation aus Virtual-Memory-Reservation (lazy mmap) |
| **AA6 Reclamation** | Span freed bei letztem Object-Free zurueck zum globalen Pool; **kein Buddy-Coalesce noetig** dank Virtual-Span-Approach |
| **AA7 Fragmentation-Strategy** | Niedrige Fragmentation durch Virtual-Memory-Reservation + Span-Pooling; kein Splitting/Coalescing |

## Performance-Vergleich (mimalloc-Paper Reference)

scalloc wird im mimalloc-Paper (A04) **NICHT** explizit benchmarked — andere Konkurrenten (sn, je, tc, hd, glibc, tbb) ja. Das deutet entweder auf scalloc's **Nische** (eher akademisch / Linux-only) oder weniger Production-Adoption.

scalloc's eigenes Paper (OOPSLA 2015): linear scalability auf 64-Core AMD-Maschinen, low fragmentation gegenueber jemalloc (zu der Zeit), tcmalloc, ptmalloc.

## Bedeutung fuer Comdare-CacheEngine

1. **Virtual Spans + Lazy mmap** = **innovative** Idee fuer Comdare's Plattform-Modell (insbesondere 64-bit-Plattformen Pflicht-Block AO)
2. **Uniforme Behandlung kleiner+grosser Objekte** = vereinfacht Code-Komplexitaet — Comdare-Cache-Engine sollte vermeiden Special-Cases fuer Small/Large/Huge wo moeglich
3. **Globale lock-free LIFO** = Pflicht-Konkretisierung fuer `c06_allocation_engine.aa4_synchronization.LockFreeLifoPool` — analog zum DescAvail in A03 Michael
4. **Treiber-stack ABA-prevention** = bekanntes Pattern; in PRT-ART OLC-Variante anwendbar
5. **Span-LIFO statt FIFO** = Cache-Hot-Reuse (ähnlich Hoard's LIFO)
6. **Linear scalability auf 64-Cores** = bestaetigt: lock-free global pool ist machbar

## Lizenz + Code-Verfuegbarkeit

- **Lizenz:** BSD
- **Repo:** [github.com/cksystemsgroup/scalloc](https://github.com/cksystemsgroup/scalloc) (Stand 2026-05-13: weniger aktiv als mimalloc/snmalloc, aber stabil)
- **Plattformen:** Linux primarily (64-bit virtual memory ist Pflicht)
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A08-scalloc/`

## Verwandte Werke

- jemalloc (A05) — wurde im scalloc-Paper als baseline benchmarked
- tcmalloc (A06) — alternative Per-Thread-Approach
- mimalloc (A04, 2019) — moderner Konkurrent, nutzt aehnliche Ideen (per-page sharded freelists)
- Local Linearizability (Henzinger et al. 2016 CONCUR) — formaler Hintergrund der lock-free LIFO Korrektheit
