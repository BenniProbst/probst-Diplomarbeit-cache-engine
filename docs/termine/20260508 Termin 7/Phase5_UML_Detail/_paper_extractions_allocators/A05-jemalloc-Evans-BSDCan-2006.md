# A05 — jemalloc: A Scalable Concurrent malloc(3) Implementation for FreeBSD

## Bibliographie
- **Titel:** A Scalable Concurrent malloc(3) Implementation for FreeBSD
- **Autor:** Jason Evans
- **Venue:** BSDCan 2006, Ottawa, May 2006
- **PDF-Quelle:** [people.freebsd.org/~jasone/jemalloc/bsdcan2006/jemalloc.pdf](https://people.freebsd.org/~jasone/jemalloc/bsdcan2006/jemalloc.pdf)
- **FreeBSD-Paper-Page:** [papers.freebsd.org/2006/bsdcan/evans-jemalloc/](https://papers.freebsd.org/2006/bsdcan/evans-jemalloc/)
- **Code-Repo:** [github.com/jemalloc/jemalloc](https://github.com/jemalloc/jemalloc) (BSD-2-Clause)
- **Status:** **Production-grade** — Default-Allokator FreeBSD seit FreeBSD 7 (2008); Facebook-Production seit 2009; Firefox seit 2007

## Kerninnovation

**Multiple Arenas** zur Reduktion von Lock-Contention + **Size-segregated Regions** fuer Spatial-Locality + **Red-Black-Tree** fuer Run/Chunk-Indexing.

## Architektur — Hierarchie

```
malloc(size)
   ↓
[1] tcache (Thread-Local Cache)        ← optional, modern
   ↓
[2] arena (one of 4*ncpu by default)
   ↓
[3] chunk (2 MiB, mmap-aligned)
   ↓
[4] run (page-aligned, in-chunk subdivision)
   ↓
[5] region (run-internal, fixed size)
```

### Arenas
- **Anzahl:** Default `4 × ncpu` (z.B. 16 Arenas auf 4-CPU-Maschine)
- **Thread-Mapping:** Round-Robin Assignment beim ersten malloc per Thread
- **Eigene Locks:** ein `chunk_alloc_lock` + ein `bin_lock` pro size class
- **Vorteil:** Threads contend in vielen Arenas → meistens kein Lock-Contention

### Chunks (2 MiB, mmap-aligned)
- Allocation-Granularitaet vom OS
- Pro Arena verwaltet via Red-Black-Tree der freien Chunks
- 2 MiB-Alignment = `addr & ~(2*MB - 1)` liefert Chunk-Header

### Runs (page-aligned)
- Eine Run gehoert zu einer Size Class
- Eine Run = mehrere Pages innerhalb eines Chunks
- Bitmap-basierte Region-Allokation innerhalb der Run

### Size Classes
| Klasse | Range | Spacing |
|--------|-------|---------|
| **Tiny** | 2, 4, 8, 16 B | Powers of 2 |
| **Quantum-spaced** | 16, 32, 48, ..., 480, 496 B | 16-Byte Quantum |
| **Sub-page** | 512, 1024, 2048 B | Powers of 2 (≤ Page) |
| **Medium** | 4 KiB..2 KiB | Page-multiples |
| **Large** | bis Chunk-Size | Page-multiples |
| **Huge** | > Chunk-Size | Chunk-multiples (own RB-tree) |

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | jemalloc-Konkretisierung |
|-------|---------------------------|
| **AA1 FreeList-Topologie** | Bitmap-basiert pro Run (Region-Allokation); Red-Black-Tree fuer freie Runs/Chunks pro Arena; lock-frei in tcache (modern) |
| **AA2 Size-Class-Schema** | 4 Stufen (Tiny/Quantum-spaced/Sub-page/Large) + Huge separately; ~64 Size Classes (genaue Anzahl variiert nach Konfig) |
| **AA3 Thread-Locality** | tcache per-thread + Multiple Arenas (4*ncpu) zur Reduktion von Lock-Pressure; Threads zur Arena via Round-Robin |
| **AA4 Synchronization** | Per-Arena `chunk_alloc_lock` + per-Arena per-bin `bin_lock`; tcache lockless |
| **AA5 Allocation-Policy** | tcache → Arena Bin → Run → Chunk-Split (recursive); RB-Tree-Suche fuer best-fit Chunks |
| **AA6 Reclamation** | Decay-based unused-dirty-page-purging (added in 4.1.0, Applicative 2015 talk); madvise(MADV_DONTNEED) on idle pages |
| **AA7 Fragmentation-Strategy** | Size-segregated Runs (eine Klasse pro Run) → External-Frag minimal; Cache-line coloring fuer Run-Placement |

## Modern jemalloc (post-BSDCan-2006)

Seit Facebook-Adoption 2009 + nachfolgender Entwicklung:

- **Extents** ersetzen "Chunks" als universelles Konzept (variabel groß)
- **Decay-based purging** (4.1.0): unused dirty pages werden nach decay_time madvise't
- **Profiling** integrated (jemalloc heap profiles → pprof-kompatibel)
- **Background threads** fuer Page-Purging
- **Per-process Memory Tracking** via `mallctl` API
- **Custom hooks** fuer instrumentation
- **Project sunset 2024:** Jason Evans, primaerer Maintainer, kuendigte 2025-06 das **Ende der Maintenance** an (siehe [jasone.github.io/2025/06/12/jemalloc-postmortem](https://jasone.github.io/2025/06/12/jemalloc-postmortem/))

## Performance-Resultate

- **FreeBSD 7+:** linear scaling auf 8-16-CPU-Systemen
- **Firefox:** Reduktion peak memory um ~25% vs Doug-Lea-malloc
- **Facebook:** 33% reduction in memory growth bei stress-test workloads (zum Zeitpunkt der Adoption)
- Im Vergleich zu mimalloc (A04, 2019): ~14% langsamer im Mittel, aber competitive bei produktionsorientierten Workloads

## Bedeutung fuer Comdare-CacheEngine

1. **Multiple Arenas** = Standard-Pattern fuer **Per-Thread-Locality ohne harte Per-Thread-Bindung** — wertvoll fuer **Multi-Tenant Workloads** wo Thread-Lifetime unbekannt
2. **Size-Class-Stufen (Tiny/Quantum/Sub-page/Large/Huge)** = **Multi-Stufen-Pattern** fuer Comdare's Allokator-Subdivision
3. **Red-Black-Tree fuer Free-Chunk-Indexing** = O(log n) Best-Fit-Lookup als alternative zu Hoard's Fullness-Groups
4. **Bitmap-Region-Allokation** = Vorlage fuer dichtes State-Tracking (analog PRT-ART Density-Tracker fuer Pool A 256B Slots)
5. **Decay-based Purging** als `c10_topologie_engine` Atom — adaptive OS-Memory-Release
6. **Round-Robin Thread-Arena-Mapping** = simpel, gut, vermeidet komplexes Hashing
7. **Wichtig:** Sunset-Hinweis 2025 — fuer Comdare = Allokator-Bibliothek darf nicht **ausschliesslich** auf jemalloc setzen!

## Lizenz + Code-Verfuegbarkeit

- **Lizenz:** BSD-2-Clause
- **Repo:** [github.com/jemalloc/jemalloc](https://github.com/jemalloc/jemalloc) (Sunset 2025, aber Code-Basis bleibt nutzbar)
- **Plattformen:** Linux, FreeBSD, macOS, Windows (partial)
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A05-jemalloc/` (vollstaendig + STRUKTUR_NOTIZ.md)
- **Wiki-Doku:** [github.com/jemalloc/jemalloc/wiki](https://github.com/jemalloc/jemalloc/wiki)

## Verwandte Werke

- Hoard (A01, 2000) — Per-Processor + Global Heap
- mimalloc (A04, 2019) — moderner Konkurrent mit Free-List-Sharding
- tcmalloc (A06, Google) — gleicher Konkurrent mit Per-Thread-Cache
- Bonwick Slab (A02, 1994) — Object-Caching-Wurzel
