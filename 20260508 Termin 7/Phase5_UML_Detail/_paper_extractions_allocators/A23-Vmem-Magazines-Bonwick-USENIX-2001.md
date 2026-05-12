# A23 — Magazines and Vmem: Extending the Slab Allocator to Many CPUs and Arbitrary Resources

## Bibliographie
- **Titel:** Magazines and Vmem: Extending the Slab Allocator to Many CPUs and Arbitrary Resources
- **Autoren:** Jeff Bonwick (Sun Microsystems), Jonathan Adams (Sun Microsystems)
- **Venue:** USENIX Annual Technical Conference 2001, Boston MA
- **PDF-Quelle:** [usenix.org/legacy/publications/library/proceedings/usenix01/full_papers/bonwick/bonwick.pdf](https://www.usenix.org/legacy/publications/library/proceedings/usenix01/full_papers/bonwick/bonwick.pdf) (403 derzeit)
- **HTML:** [usenix.org/legacy/event/usenix01/full_papers/bonwick/bonwick_html](https://www.usenix.org/legacy/event/usenix01/full_papers/bonwick/bonwick_html)
- **Code-Vermaechtnis:** illumos kmem/vmem Subsystem (CDDL); FreeBSD UMA (BSD)
- **Status:** **Klassiker** — direktes Follow-Up zu A02 Slab; geliefert beide Erweiterungen vom 1994-Paper §7.

## Kerninnovation — Zwei Erweiterungen zum 1994 Slab-Allokator

### (1) Magazine-Layer (Per-CPU-Caching)
**Problem:** Slab-Allokator (1994) hatte **Per-Cache-Lock** — skalierte nicht zu vielen CPUs (Solaris 8: 64-CPU bottleneck).

**Loesung:** Per-CPU-Magazines + zentrale Depot.

### (2) Vmem (Universal Resource Allocator)
**Problem:** Slab-Allokator nur fuer Kernel-Memory; Solaris hatte Dutzende Custom-Resource-Allokatoren (PIDs, MinorNumbers, KVA, ...).

**Loesung:** Vmem als **General-Purpose** Resource-Allokator mit **O(1)** Allokation/Free fuer jede Groesse.

## Magazine-Architektur

### Schichten
```
┌─────────────────────────────────────────┐
│ Per-CPU Magazines (loaded + previous)   │ ← keine Locks!
├─────────────────────────────────────────┤
│ Depot (full + empty Magazine-Stacks)    │ ← 1 Lock pro Cache
├─────────────────────────────────────────┤
│ Slab Allocator (1994 layer)             │ ← Backend
├─────────────────────────────────────────┤
│ Vmem (Backing Store)                    │ ← Page Supplier
└─────────────────────────────────────────┘
```

### Magazine-Struktur
```
struct kmem_magazine {
    void *mag_round[M];   // Stack of M object pointers
};
```

- **M** ist die **Magazine-Groesse** (Anzahl Pointer pro Magazine)
- Adaptive: M wird zur Laufzeit dynamisch angepasst (Magazine Resizing)

### Per-CPU-Cache
```
struct kmem_cpu_cache {
    kmutex_t       cc_lock;          // ungenutzt im Common-Case (per-CPU)
    kmem_magazine *cc_loaded;        // current magazine (Stack-Top fuer Pop)
    kmem_magazine *cc_previous;      // backup magazine (Round-Trip-Optimierung)
    int            cc_rounds;        // # objects in loaded magazine
    int            cc_prounds;       // # objects in previous magazine
    int            cc_magsize;       // current M
};
```

### Depot
- Pro Cache **eine Depot** mit zwei Listen:
  - `full`: List of magazines that are FULL (M rounds)
  - `empty`: List of magazines that are EMPTY (0 rounds)

## Round-Trip-Allokations-Pfad

### kmem_cache_alloc (Magazine-Layer)
```
1. Pop from cc_loaded:           # Common Case (no lock)
   if (cc_rounds > 0)
       return cc_loaded->mag_round[--cc_rounds];

2. Swap loaded with previous:    # if loaded empty, previous full
   if (cc_prounds > 0)
       swap(cc_loaded, cc_previous);
       continue at step 1;

3. Depot reload:                 # both empty
   acquire depot lock;
   move cc_previous to depot.empty;
   take a magazine from depot.full as cc_loaded;
   release depot lock;
   continue at step 1;

4. Allocate from slab:           # depot empty
   construct empty magazine;
   fill from slab allocator (1994 layer);
   continue at step 3;
```

### kmem_cache_free (Magazine-Layer)
```
1. Push to cc_loaded:
   if (cc_rounds < M)
       cc_loaded->mag_round[cc_rounds++] = obj;
       return;

2. Swap loaded with previous:
   if (cc_prounds < M)
       swap(cc_loaded, cc_previous);
       continue at step 1;

3. Depot return:
   acquire depot lock;
   move cc_previous to depot.full;
   take an empty magazine from depot.empty as cc_loaded;
   continue at step 1;

4. Free to slab:
   destruct full magazine;
   free objects to slab allocator;
   continue at step 3;
```

**Kritisch:** Steps 1+2 sind **lock-frei** (per-CPU) → linearer Speedup!

## Magazine Resizing (Adaptive M)

**Heuristik:** Wenn Depot-Contention hoch → erhoehe M (mehr Throughput pro Depot-Visit).

- M start klein (z.B. 1)
- Bei Depot-Lock-Kontention: M doppeln, neue Magazines mit groesserem M einfuehren
- Cap: typische Werte M ∈ {1, 3, 7, 15, 31, 63, 127, 143}

## Vmem-Architektur

### Span und Segment
- **Span:** kontinuierlicher Range an Resource-IDs (z.B. eine VA-Page-Range, oder PID-Range)
- **Segment:** Sub-Range innerhalb Span; entweder ALLOCATED oder FREE

### Segment-List
- Doppelt verkettet, **sortiert nach Adresse** → Coalescing in O(1) bei Free (linke + rechte Nachbarn pruefen)

### Boundary-Tags
- **Externe** Boundary-Tags (kein Embedded-Metadata noetig — funktioniert fuer non-memory Resources!)
- Pro Segment ein `vmem_seg_t` mit ptr/size/state/buddy-Pointers
- Werden via Slab-Allokator alloziert (rekursive Bootstrap)

### Power-of-2 Freelists
```
freelist[0] enthaelt Segmente Groesse [1, 2)
freelist[1] enthaelt Segmente Groesse [2, 4)
freelist[2] enthaelt Segmente Groesse [4, 8)
...
freelist[n] enthaelt Segmente Groesse [2^n, 2^(n+1))
```

### Instant-Fit Algorithmus (O(1)!)
```c
seg_t *vmem_alloc(arena, size) {
    n = log2_ceil(size);
    if (size == (1 << n)) {
        // exact: take first segment in freelist[n]
        return freelist[n].pop();
    } else {
        // not exact: take first segment in freelist[n+1]
        // (guaranteed to fit, possibly leaves remainder)
        return freelist[n+1].pop();
    }
}
```

→ **Garantierte O(1)** Allokation, **unabhaengig** vom Fragmentation-Grad!

### Allocated-Segment Hash-Table
- Bei vmem_alloc: insert seg in hash table[hash(addr)]
- Bei vmem_free(addr): hash-lookup → finde seg in O(1)
- Coalesce mit linken/rechten Nachbarn (auch O(1))

## Hierarchische Arenen

```
heap_arena (root)
   ↓ imports
kmem_va_arena         vmem_metadata_arena   pid_arena
   ↓ imports                  ↓                 ↓
kmem_default          kmem_seg              (PIDs)
   ↓
[slab caches]
```

- Jede Arena hat `source_arena` + `import_func`
- Bei Span-Erschoepfung: import von Source-Arena
- Tree-Structure → klare Ressourcen-Hierarchie

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | Magazine + Vmem Konkretisierung |
|-------|----------------------------------|
| **AA1 FreeList-Topologie** | Magazine: Stack[M]; Depot: Linked-List of Magazines (full+empty); Vmem: Power-of-2 Freelists indexed by log2(size) |
| **AA2 Size-Class-Schema** | Magazine: pro Slab-Cache eigene Magazines; Vmem: log2-bucketing |
| **AA3 Thread-Locality** | **Magazine = Per-CPU Cache** (loaded + previous → 2-Level) → KERN der Innovation, lockfreie Common-Path-Operations |
| **AA4 Synchronization** | Per-CPU lockless im Common-Case; Depot-Lock nur bei Magazine-Refill/Drain; Slab-Lock noch seltener |
| **AA5 Allocation-Policy** | Vmem: VM_INSTANTFIT (Default) / VM_BESTFIT / VM_NEXTFIT als Optionen; Magazine: stack-LIFO (Cache-Hot-Reuse) |
| **AA6 Reclamation** | Magazine-Resizing reduce M bei niedriger Last; vmem_xfree → coalesce; ganze Slabs nach Slab-Reaping zurueck zum Vmem |
| **AA7 Fragmentation-Strategy** | Vmem: instant-fit erzeugt etwas Internal-Fragmentation, aber NULL Suchzeit; Magazine: keine Fragmentation (homogene Objekte) |

## Performance-Resultate (Solaris 8, USENIX 2001 Paper)

- **Linear scaling** auf bis zu **64 CPUs** (vs. flacher Slab-1994 schon bei 8-CPU bottleneck)
- TPC-C Throughput: +15% durch Magazines
- Vmem reduces Custom-Resource-Allokator-Code um >50K LOC im Solaris-Kernel

## Bedeutung fuer Comdare-CacheEngine

1. **Magazine-Layer** = **Pflicht** fuer AA3 ThreadLocality auf >16-CPU-Systemen → Loaded+Previous-2-Stack-Pattern bringt linearen Speedup
2. **Magazine Resizing** als adaptive `c09_heuristik_engine` Atom — analog Density-Threshold-Adaptation in PRT-ART
3. **Vmem Boundary-Tags + Instant-Fit + Hash-Table** = Vorlage fuer **Generic-Resource-Allocator** (PRT-ART nutzt das fuer Virtual-Memory-Offset-Mapping in §5.19)
4. **Hierarchical Arenas** = Vorlage fuer **CacheEngine→ExecutionEngine→SearchEngine** Resource-Hierarchie (Layer-Provider-Rollen aus REV-7 §4.2(f))
5. **External Boundary-Tags** = wichtige Eigenschaft: ermoeglicht Vmem-aehnliche Bookkeeping fuer **non-memory Resources** (Test-Data-Set-IDs, Permutations-IDs, ...)

## Lizenz + Code-Verfuegbarkeit

- **illumos kmem/vmem:** [github.com/illumos/illumos-gate/tree/master/usr/src/uts/common/os/kmem.c](https://github.com/illumos/illumos-gate) — CDDL
- **FreeBSD UMA:** [github.com/freebsd/freebsd-src/blob/main/sys/vm/uma_core.c](https://github.com/freebsd/freebsd-src) — BSD
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A23-vmem-magazines/` (illumos-Subset oder FreeBSD-UMA als Studie + eigene Reimplementation der Magazine-Layer-Idee)

## Verwandte Werke

- McKenney/Slingwine 1993 USENIX (Per-CPU Memory Allocation) — frueher Vorlaeufer der Magazine-Idee
- Hoard 2000 (A01) — Per-Processor-Heaps mit anderem Discipline (Empty-Threshold)
- Michael 2004 (A03) — Lock-Free als Alternative zu Magazine-Layer
- jemalloc 2006 (A05) — uebernimmt Konzepte; tcmalloc 2009 (A06) auch
