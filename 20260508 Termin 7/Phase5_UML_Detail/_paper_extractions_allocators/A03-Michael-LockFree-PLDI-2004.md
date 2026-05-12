# A03 — Scalable Lock-Free Dynamic Memory Allocation

## Bibliographie
- **Titel:** Scalable Lock-Free Dynamic Memory Allocation
- **Autor:** Maged M. Michael (IBM T.J. Watson Research Center)
- **Venue:** PLDI 2004 (ACM SIGPLAN Conference on Programming Language Design and Implementation), Washington DC, June 9-11 2004
- **DOI:** 10.1145/996841.996848
- **PDF-Quelle:** [www.cs.tufts.edu/~nr/cs257/archive/maged-michael/pldi-2004.pdf](https://www.cs.tufts.edu/~nr/cs257/archive/maged-michael/pldi-2004.pdf)
- **Code-Quelle:** [github.com/scotts/michael](https://github.com/scotts/michael) (Re-Implementation)

## Kerninnovation

**Vollstaendig lock-free** Dynamic Memory Allocator — KEIN OS-Support noetig, NUR widely-available CAS (oder LL/SC). Bietet:

- **Immunity to deadlock** (kein Lock)
- **Async-signal-safety** (verwendbar in Signal-Handlern!)
- **Tolerance to priority inversion**
- **Kill-tolerant availability**
- **Preemption-tolerance**

Leverage's hoehere Hoard-Strukturen (Size-Classes + Processor-Heaps), aber **finer-grained** als Hoard's Per-Heap-Lock-Strategie.

## Lock-Freedom Definition

> A shared object is lock-free (nonblocking) if it guarantees that whenever a thread executes some finite number of steps, at least one operation on the object by some thread must have made progress.

→ NICHT wait-free (kein per-Thread-Progress), aber **system-weit garantierter Progress**.

## Datenstrukturen (PowerPC 64-bit Pseudocode aus Paper)

### Anchor (Single 64-bit atomic word in Descriptor)
```c
typedef anchor : {
    unsigned avail:10;   // Index of first free block (10 bits = max 1024 blocks)
    unsigned count:10;   // Number of unreserved blocks
    unsigned state:2;    // ACTIVE=0 FULL=1 PARTIAL=2 EMPTY=3
    unsigned tag:42;     // ABA-prevention counter
};
```

### Descriptor
```c
typedef descriptor : {
    anchor       Anchor;       // atomic
    descriptor*  Next;
    void*        sb;           // pointer to superblock
    procheap*    heap;         // pointer to owner procheap
    unsigned     sz;           // block size
    unsigned     maxcount;     // = superblock_size / sz
};
```

### Procheap
```c
typedef ptr : {
    unsigned ptr:58, credits:6;  // 58-bit ptr + 6-bit credits
};
typedef procheap : {
    active        Active;        // initially NULL (descriptor* + credits)
    descriptor*   Partial;       // initially NULL
    sizeclass*    sc;            // pointer to parent sizeclass
};
```

### Sizeclass
```c
typedef sizeclass : {
    descList   Partial;     // initially empty (lock-free FIFO)
    unsigned   sz;          // block size
    unsigned   sbsize;      // superblock size
};
```

## Malloc-Algorithmus (3 Pfade)

```c
void* malloc(sz) {
    heap = find_heap(sz);          // Use sz and thread id
    if (!heap) {                    // Large block
        return AllocFromOS(sz);
    }
    while(1) {
        addr = MallocFromActive(heap);  if (addr) return addr;
        addr = MallocFromPartial(heap); if (addr) return addr;
        addr = MallocFromNewSB(heap);   if (addr) return addr;
    }
}
```

### MallocFromActive (Common Path)
1. **Reserve Block:** CAS `Active` to decrement `credits` field while validating Active is still valid
2. **Pop Block:** CAS `Anchor` to:
   - Read `next = *(unsigned*)addr` (LIFO-pop)
   - Set `Anchor.avail = next`
   - Increment `Anchor.tag++` (ABA-prevention!)
3. Set `*addr = desc` (so free can find descriptor via 8-byte prefix)
4. Return `addr+EIGHTBYTES`

### MallocFromPartial
1. `desc = HeapGetPartial(heap)` — pop from sizeclass.Partial lock-free FIFO
2. CAS reserve `min(count-1, MAXCREDITS)` blocks
3. CAS pop the first reserved block
4. Update Active with remaining credits via UpdateActive

### MallocFromNewSB
1. Allocate new descriptor + superblock (mmap or hyperblock-batch)
2. Initialize blocks as linked list (LIFO)
3. CAS install as Active

## Free-Algorithmus

```c
void free(ptr) {
    if (!ptr) return;
    ((void**)ptr)--;            // get prefix
    desc = *(descriptor**)ptr;
    if (large_block_bit_set(desc)) {  // Large block
        return Free_to_OS(desc);
    }
    sb = desc->sb;
    do {
        newanchor = oldanchor = desc->Anchor;
        *(unsigned*)ptr = oldanchor.avail;     // push to LIFO
        newanchor.avail = (ptr-sb)/desc->sz;   // new head index

        // State transitions:
        if (oldanchor.state == FULL)
            newanchor.state = PARTIAL;
        if (oldanchor.count == desc->maxcount-1) {
            // We are freeing the LAST allocated block
            heap = desc->heap;
            instruction_fence;
            newanchor.state = EMPTY;
        } else {
            newanchor.count++;
        }
        memory_fence;
    } while (!CAS(&desc->Anchor, oldanchor, newanchor));

    if (newanchor.state == EMPTY) {
        Free_superblock(sb);
        RemoveEmptyDesc(heap, desc);
    } else if (oldanchor.state == FULL) {
        HeapPutPartial(desc);
    }
}
```

## ABA-Prevention

**Problem (ABA):** Thread X reads `Anchor.avail = A`, dann context-switch. Threads Y/Z popppen A, freien C, pushen B, freien C, pushen A. X wakes, CAS sees A → succeeds, but state has changed!

**Loesung im Paper:** `tag:42` field in Anchor incremented on every pop → CAS(oldanchor, newanchor) fails wenn tag changed.

**Wraparound-Sicherheit:** 42 Bits = 4 Trillion Increments → praktisch unmoeglich in kurzer Zeit.

**Alternative ohne tag:** SafeCAS via Hazard Pointers oder pointer-sized LL/SC (Michael 2002 IPDPS — Hazard Pointers Paper)

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | Michael-LockFree-Konkretisierung |
|-------|-----------------------------------|
| **AA1 FreeList-Topologie** | Per-Superblock: lock-free LIFO via Anchor.avail; Sizeclass: lock-free FIFO Partial-List (Sec 3.2.6) |
| **AA2 Size-Class-Schema** | Power-of-2 (geleihen von Hoard); pro Sizeclass mehrere Procheaps (proportional zu CPU-Count) |
| **AA3 Thread-Locality** | Per-thread procheap mapping via thread-id (analog Hoard); `find_heap(sz)` lookup |
| **AA4 Synchronization** | **Vollstaendig lock-free CAS** (oder LL/SC); SafeCAS fuer pointer-sized Strukturen via Hazard Pointers; nur Memory-Fences |
| **AA5 Allocation-Policy** | Active first (Hot-Path), dann Partial, dann NewSB; Credits-System fuer Reserve-Optimierung |
| **AA6 Reclamation** | EMPTY-state Superblocks → free_superblock; descriptor recycle via DescAvail lock-free LIFO; Hyperblocks (1MB batches of 16KB superblocks) via mmap |
| **AA7 Fragmentation-Strategy** | Internal: power-of-2 size classes; External: Hyperblocks reduzieren mmap-Frequency; Memory-fence-Pflicht (Sec 3.2.4) fuer Consistency |

## Performance-Resultate (POWER3 16-CPU, 375 MHz)

| Metric | new (Michael) | Hoard | Ptmalloc | libc |
|--------|---------------|-------|----------|------|
| **Linux scalability speedup vs libc** | 33× | 18× | 22× | 1× |
| **Threadtest speedup** | 28× | 16× | 18× | 1× |
| **Larson speedup** | 45× | 21× | 5× | 1× |
| **Active-False speedup** | 16× | 8× | 2× | 1× |
| **Passive-False speedup** | 16× | 5× | 2× | 1× |

**Contention-free Latency speedup vs libc:**
| Bench | new | Hoard | Ptmalloc |
|-------|-----|-------|----------|
| Linux scalability | 2.25 | 1.11 | 1.83 |
| Threadtest | 2.18 | 1.20 | 1.94 |
| Larson | 2.90 | 2.22 | 2.53 |

→ **Lower latency than even Hoard** + signifikant bessere Skalierbarkeit.

## Kritische Implementations-Details

### Memory Fences (Sec 3.2.4)
```c
// Line 12 in Free: instruction_fence  → ensure new desc fields visible before CAS
// Line 17 in Free: memory_fence       → ensure write in line 8 observed before CAS in line 18
```

### Hyperblocks (Sec 3.2.5)
- Batch-mmap: 1 MB Hyperblocks → split in 64× 16 KB Superblocks
- Reduce OS interaction frequency
- Descriptors NICHT geschrieben fuer ungenutzte Superblocks (Disk-Swap-Save)

### DescAvail Free-List (Sec 3.2.5)
- Lock-free LIFO of free descriptors
- ABA-prevention via SafeCAS (Hazard Pointer fuer pointer-sized DescAvail)
- DescRetire = simple lock-free push

### Lists of Partial Superblocks (Sec 3.2.6)
- LIFO oder FIFO (preferred): lock-free FIFO queue
- ListGetPartial / ListPutPartial / ListRemoveEmptyDesc

## Bedeutung fuer Comdare-CacheEngine

1. **Lock-Free Variante** als Pflicht-Konkretisierung von `c04_coherence_engine` AA4-Synchronization-Achse
2. **ABA-Prevention via Tag-Field** = Vorlage fuer **PRT-ART OLC-Variante** (auch tag-based version)
3. **Async-signal-safety** = Pflicht-Eigenschaft fuer **embedded-/realtime-Plattformen** im Block AO
4. **Hyperblock-Batching** = Reduce mmap-Overhead → wichtig fuer **Talos-OS Pflicht-Plattform** (minimaler OS-Overhead)
5. **Procheap-Active+Partial+NewSB-Pfad-Hierarchie** = Vorlage fuer Pflicht-Pfade `c06_allocation_engine.allocate_fast / allocate_slow / allocate_grow`
6. **DescAvail Hazard-Pointer-Recycling** = Bridge zu `comdare_rcu_mechanic.hpp` (Task #104)

## Lizenz + Code-Verfuegbarkeit

- **Originalcode:** IBM intern (kein offizielles Open-Source)
- **Re-Implementation:** [github.com/scotts/michael](https://github.com/scotts/michael) (MIT-style)
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A03-michael-lockfree/` (scotts/michael als Basis + eigene Reimpl)
- **Verwandtes Patent:** US 2006/0190697 A1 "A lock-free memory allocator with delayed coalescing" (Patent-Lizenz pruefen!)

## Limitations + Tradeoffs (Author-Discussion)

> "Note that in our allocator, unlike Hoard, we do not maintain fullness classes or keep statistics about the fullness of processor heaps and we are quicker to move partial superblocks to the partial list of the size class. This simplicity allows lower latency and lower fragmentation. But, one concern may be that this makes it more likely for blocks to be freed to a superblock in the size class partial lists."

→ Tradeoff: **simpler / lower latency** vs **less precise fullness tracking**.
