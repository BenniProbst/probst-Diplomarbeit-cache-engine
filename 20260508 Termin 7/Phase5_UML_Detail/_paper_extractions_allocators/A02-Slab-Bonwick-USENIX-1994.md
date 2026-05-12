# A02 — The Slab Allocator: An Object-Caching Kernel Memory Allocator

## Bibliographie
- **Titel:** The Slab Allocator: An Object-Caching Kernel Memory Allocator
- **Autor:** Jeff Bonwick (Sun Microsystems)
- **Venue:** USENIX Summer 1994 Technical Conference, Boston MA, Pages 87-98
- **PDF-Quelle:** [people.eecs.berkeley.edu/~kubitron/courses/cs194-24-S14/hand-outs/bonwick_slab.pdf](https://people.eecs.berkeley.edu/~kubitron/courses/cs194-24-S14/hand-outs/bonwick_slab.pdf)
- **Code-Vermaechtnis:** SunOS 5.4 (Solaris) Kernel + Linux SLAB/SLUB + FreeBSD UMA + illumos kmem
- **Status:** **Klassiker** — Grundlage fast aller modernen Kernel-Allokatoren

## Kerninnovation

**Object Caching:** Konstruktor/Destruktor wird **nur einmal pro Slab-Initialisierung** aufgerufen — Objects werden in ihrem **constructed state** zwischen Use+Free behalten.

Beispiel-Performance: Stream-Head allocation 33 µs → 5.7 µs (~6× speedup)

## Object Cache Interface

```c
struct kmem_cache* kmem_cache_create(
    char *name, size_t size, int align,
    void (*constructor)(void*, size_t),
    void (*destructor)(void*, size_t));

void* kmem_cache_alloc(struct kmem_cache *cp, int flags);  // KM_SLEEP | KM_NOSLEEP
void  kmem_cache_free(struct kmem_cache *cp, void *buf);
void  kmem_cache_destroy(struct kmem_cache *cp);
```

**Designprinzip:**
- (A) Object-Beschreibung gehoert zum **Client**, nicht zum Allokator
- (B) Memory-Management-Policies gehoeren zum Allokator, nicht zum Client

## Architektur — 3 Schichten

```
┌──────────────────────────────────────┐
│ kmem_cache_alloc/free  (Front-End)   │ ← Client-API
├──────────────────────────────────────┤
│ Cache (kmem_cache)                   │
│  - circular doubly-linked slab list  │
│  - empty/partial/complete sortiert   │
│  - per-cache lock                    │
├──────────────────────────────────────┤
│ kmem_cache_grow / _reap  (Back-End)  │ ← getpages/freepages
└──────────────────────────────────────┘
```

### Slab
- **1 oder mehrere virtually contiguous pages**
- Geteilt in **n equal-size buffers** (chunks)
- Reference count → wenn 0: ganzer Slab → VM zurueck
- 2 Layouts:
  - **Klein (<1/8 Page):** `kmem_slab` data + `kmem_bufctl` linkage **embedded am Page-Ende**
  - **Gross (≥1/8 Page):** `kmem_slab` + `kmem_bufctl` in eigenen kleinen Caches; Hash-Table fuer buffer→bufctl

### bufctl
```
struct kmem_bufctl {
    void           *buf;        // pointer to buffer
    struct kmem_slab *slab;     // back-pointer to slab
    struct kmem_bufctl *next;   // freelist linkage
};
```
Freelist-Linkage am **Buffer-Ende** statt -Anfang (Debugging-friendly).

## Slab Coloring (Cache-Optimierung)

**Problem:** Power-of-2-Allokatoren mappen alle "hot" Buffer-Anfaenge auf wenige Cache-Lines → schlechte Cache-Utilization, Bus-Imbalance.

**Loesung:** Pro neue Slab beginnen die Buffer-Adressen mit einem **anderen Offset (color)** vom Slab-Beginn.

**Beispiel:** 200-byte Cache mit 8-byte Alignment, 4096-byte Slab → max 20 Buffer × 200B = 4000B + 32B kmem_slab = 64B uebrig fuer Coloring → Color-Sequenz 0, 8, 16, ..., 64, 0, 8, ...

**Resultat (LADDIS-Benchmark, SPARCcenter 2000):**
- Bus-Imbalance: 43% → **17%**
- Primary cache miss rate: **-13%**

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | Slab-Konkretisierung |
|-------|----------------------|
| **AA1 FreeList-Topologie** | Pro-Cache: doubly-linked Slab-List (empty/partial/complete sortiert); Pro-Slab: einfache bufctl-Liste |
| **AA2 Size-Class-Schema** | **Object-Cache pro Typ** (vom Client erstellt); Default-Caches 8B-9K in 10-20% Increments (~30 Caches) |
| **AA3 Thread-Locality** | NEIN (1994!) — Future Work in §7.2 verweist auf McKenney 1993 4-layer hierarchy → erst in **A23 Vmem Magazines** realisiert |
| **AA4 Synchronization** | **Per-Cache Locking** (kein globaler Heap-Lock) — Skalierbarkeit ohne Lock-Free |
| **AA5 Allocation-Policy** | "Never destruct unless reclaiming" — Konstruktor nur bei Slab-Erweiterung (kmem_cache_grow) |
| **AA6 Reclamation** | 15-second working-set algorithm; kmem_cache_reap nur bei Memory-Pressure (push/pull mit VM-System) |
| **AA7 Fragmentation-Strategy** | Internal Frag = **max 1/n** pro Slab (SunOS 5.4: cap 12.5% = 1/8); **External Frag minimiert** durch same-type-same-lifetime Heuristic; Object-Coloring fuer Cache-Distribution |

## Konstruktor-Pattern

```c
foo = kmem_cache_alloc(foo_cache, KM_SLEEP);
// foo ist BEREITS in constructed state — keine mutex_init noetig!
use foo;
ASSERT(foo->foo_refcnt == 0);  // muss in constructed state geblieben sein!
kmem_cache_free(foo_cache, foo);
```

→ Mutex/Condvar/Refcount bleiben **zwischen Allokationen erhalten** → **mutex_init/cv_init nur einmal pro Slab**.

## Debugging Features (kompletter Block)

| Feature | Mechanismus |
|---------|-------------|
| **Audit log** | Circular Transaction-Log mit Thread-Ptr + Timestamp + Stack-Trace im Bufctl |
| **Freed-Address Verification** | Hash-Lookup → wenn Fail: bogus address |
| **Detect Use-of-Freed-Memory** | `0xdeadbeef` Pattern beim Free, verifizieren beim Re-Alloc |
| **Uninitialized Data Detection** | `0xbaddcafe` Fill nach Constructor |
| **Redzone Checking** | Guard-Word am Buffer-Ende, verifizieren beim Free |
| **Synchronous Unmapping** | Page sofort unmappen → Page-Fault bei Use-after-Free |
| **Page-per-Buffer Mode** | Jeder Buffer eigene Page → individuelle Page-Protection |
| **Leak Detection** | Audit-Timestamps + /dev/kmem-Scan + |

## Performance-Vergleich (SPARCstation-2 µs)

| Allokator | µs (kmem_cache_alloc) | Methode |
|-----------|----------------------|---------|
| **slab (kmem_cache_alloc)** | **3.8** | Object cache |
| 4.4BSD | 4.1 | Sequential-fit |
| slab (kmem_alloc) | 4.7 | Object cache fallback |
| SVr4 | 9.4 | Power-of-2 buddy |
| SunOS 4.1.3 | 25.0 | Sequential-fit |

## Bedeutung fuer Comdare-CacheEngine

1. **Object Cache Interface** = Vorlage fuer **Constructor/Destructor-Lifecycle in `comdare::cache_engine::allocator::CacheEngineAllocator`** — kann Optimierung bringen wenn Algorithmus Objekte mit ueber-konstruktorischer Logik wiederverwendet
2. **Slab Coloring** = **Pflicht-Konzept fuer AA7 Fragmentation-Strategy** — zentrale Anti-False-Sharing-Idee fuer Cache-Page-Aware-Allokator-Variante
3. **3-Schichten-Architektur** (Front-End API / Cache / Back-End) = Bestaetigung der REV-7-Drei-Schichten-Hierarchie auf der Allokator-Ebene
4. **Per-Cache-Locking statt Global-Lock** = Skalierungs-Lehre, ohne lock-free zu werden
5. **Empty/Partial/Complete-Sortierung** + Reference-Count-Reclamation = analog zu Hoard's Fullness-Groups

## Future Work (§7) als Bruecke zu A23 Vmem

> "Per-CPU memory allocation techniques of McKenney/Slingwine [McKenney93] would fit nicely on top of the slab allocator. They define a four-layer allocation hierarchy of decreasing speed and locality: per-CPU, global, coalesce-to-page, coalesce-to-VM-block. The latter three correspond closely to the slab allocator's front-end, back-end, and page-supplier layers, respectively."

→ Diese Vision wird in **A23 (Bonwick/Adams Vmem 2001)** realisiert.

## Lizenz + Code-Verfuegbarkeit

- **Original:** Sun-Lizenz (heute illumos: CDDL); Linux SLAB/SLUB: GPL; FreeBSD UMA: BSD
- **Pragmatischer Pfad:** Linux SLUB-Source als Studie-Vorlage (Linux/mm/slub.c)
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A02-bonwick-slab/` (Linux SLUB-Subset oder eigene Reimplementation)
