# A19 — Buddy System: Dynamic Storage Allocation

## Bibliographie
- **Original-Paper:** "A Fast Storage Allocator", Kenneth C. Knowlton — Communications of the ACM 8(10), Oktober 1965, pp. 623-625
- **Lehrbuch-Referenz:** Donald E. Knuth, *The Art of Computer Programming*, Vol. 1: Fundamental Algorithms, §2.5 "Dynamic Storage Allocation", Addison-Wesley 1968 (1st Ed.), 1997 (3rd Ed.)
- **Erfindung:** Harry Markowitz (1963) — vor dem Knowlton-Paper
- **Wikipedia-Uebersicht:** [en.wikipedia.org/wiki/Buddy_memory_allocation](https://en.wikipedia.org/wiki/Buddy_memory_allocation)
- **Status:** **Klassiker** — Grundlage des Linux-Kernel-Page-Allokators und vieler embedded Systems

## Kerninnovation

**Rekursive Halbierung** des Speichers in Power-of-2-Bloecke + **schnelles Coalescing** durch XOR-Buddy-Adress-Berechnung.

## Algorithmus

### Order/Rank-System
- **Order n:** Block-Groesse `2^n` Bytes (oder Units)
- Order-Range: `[order_min, order_max]` (z.B. 12..30 fuer 4 KiB...1 GiB Pages)
- Pro Order eine eigene Free-List

### Buddy-Adresse via XOR
Wenn ein Block der Order `n` an Adresse `A` liegt, dann ist sein Buddy bei:
```
buddy(A, n) = A ⊕ (1 << n)
```
→ **Reine XOR-Operation** = O(1), kein Pointer-Lookup noetig.

Beispiel (Order=12, also 4 KiB Bloecke):
```
A = 0x1000_0000   (Block at 256 MiB offset, order 12)
buddy = 0x1000_0000 ⊕ 0x1000 = 0x1000_1000  (next 4KiB block)
```

### Allokations-Algorithmus
```
allocate(size):
    n = ceil(log2(size))                    // smallest order containing size
    if (freelist[n].not_empty)
        return freelist[n].pop()             // direct hit

    // SPLIT: find larger free block, split recursively
    for k = n+1 to order_max:
        if (freelist[k].not_empty):
            block = freelist[k].pop()
            // split k-1 times to get an n-block
            for j = k-1 down to n:
                buddy_block = block + (1 << j)
                freelist[j].push(buddy_block)  // give back the buddy
            return block

    return ERROR_OOM
```

### Free-Algorithmus
```
free(block, n):
    while (n < order_max):
        buddy = block ⊕ (1 << n)
        if (buddy not in freelist[n] OR buddy is allocated):
            break  // cannot coalesce
        freelist[n].remove(buddy)
        block = min(block, buddy)  // coalesced block at lower address
        n = n + 1                  // promote to next order
    freelist[n].push(block)
```

### Datenstruktur (typisch)
- Bitmap pro Order: 1 Bit pro Block-Pair (set = 1 of pair allocated, unset = both same state)
- Doubly-linked Free-List pro Order

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | Buddy-Konkretisierung |
|-------|----------------------|
| **AA1 FreeList-Topologie** | Pro Order eine doppelt verkettete Liste freier Bloecke; Bitmap fuer Buddy-State |
| **AA2 Size-Class-Schema** | Power-of-2 (rein); 1 Order pro Power-of-2 Stufe |
| **AA3 Thread-Locality** | Originale Form: NEIN (single-list per order). Erweiterungen: pro-CPU-Buddy-Heaps (Linux: per_cpu_pages PCP-Lists vor Buddy-Layer) |
| **AA4 Synchronization** | Originale Form: globaler Lock pro Order. Erweiterungen: lock per Order (less contention), oder per-CPU-Cache vor Buddy |
| **AA5 Allocation-Policy** | Smallest-Fit (kleinste Order ≥ Anfrage); falls leer: Split von naechst groesserer Order |
| **AA6 Reclamation** | Coalescing beim Free: Buddy-Lookup via XOR, Merge wenn Buddy frei |
| **AA7 Fragmentation-Strategy** | **Internal:** bis zu 50% (Anfrage 33 KiB → 64 KiB Block, 31 KiB ungenutzt). **External:** sehr gering (Coalescing) |

## Varianten (Knuth §2.5 + Folgearbeiten)

| Variante | Mechanik | Vorteil | Nachteil |
|----------|----------|---------|----------|
| **Binary Buddy** | Block = 2× kleinerer | einfach, XOR-Buddy | bis zu 50% internal frag |
| **Weighted Buddy** | Block = 1×, 3×, 5×, ... | feinere Groessen | komplexere Buddy-Berechnung |
| **Fibonacci Buddy** | Block-Groessen folgen Fib-Reihe | weniger interne Frag | komplexerer Coalesce |
| **Tertiary Buddy** | Pro Block 3 Sub-Bloecke | weniger Wachstumsraten | unsymmetrisch, Buddy-Berechnung schwer |

## Verwendungs-Beispiele

| System | Verwendung |
|--------|------------|
| **Linux Kernel** | `mm/page_alloc.c` — Buddy fuer Page-Allokation (4KiB-Pages, Order 0-10/11), darueber SLAB/SLUB (siehe A02) |
| **FreeBSD** | `vm_phys.c` — Buddy fuer Physical Page Allocation |
| **jemalloc (A05)** | Verwendet Buddy-aehnliche Technik fuer Chunks (chunk = 4 MB, Sub-Allokation via Run-Bins) |
| **NetBSD** | Buddy-aehnliche `vmem` (siehe A23 Bonwick/Adams) |
| **Embedded RTOS** | Haeufig fuer feste Memory-Pools |

## Performance-Charakteristik

| Operation | Zeitkomplexitaet |
|-----------|-------------------|
| **Allocate** (cache hit) | O(1) — Pop von Freelist |
| **Allocate** (cache miss with k splits) | O(k) — k Splits noetig |
| **Free** (no coalesce) | O(1) — Push auf Freelist |
| **Free** (with k coalesces) | O(k) — k Coalesces moeglich |
| **Worst-Case** | O(log₂(M)) wo M = Total-Memory |

## Bausteine-Achsen-Mapping fuer Cache-Engine

Buddy ist als **eines** der Rang-1-Schemata in `c06_allocation_engine.aa1_freelist_topology` zu fuehren — neben Slab (A02), Hoard's Superblocks (A01), und Michael's Lock-Free-Anchor-Bins (A03).

## Bedeutung fuer Comdare-CacheEngine

1. **Buddy-Allokator-Variante** = Pflicht-Konkretisierung fuer **Strict-Power-of-2-Pools** (z.B. PRT-ART Pool A 256B, Pool B 64KiB)
2. **XOR-Buddy-Lookup** = O(1) Coalescing-Primitive — wertvoll fuer **Dynamic-Pool-Resizing** in `IPrtArtAllocator.consolidate()`
3. **Bitmap-Tracking** = vorbild fuer **Dense-Page-State-Tracking** (analog PRT-ART Density-Tracker)
4. **Internal-Frag bis 50%** = Limitation, die Slab/Magazine adressieren — daher **NICHT** als Default-Allokator-Achse-Wert empfohlen, sondern als **Permutations-Option** fuer Workloads mit homogener Power-of-2 Allocation-Distribution

## Lizenz + Code-Verfuegbarkeit

- **Algorithmus:** Public Domain (Knuth-Buch + Knowlton 1965)
- **Linux Kernel:** GPL v2 — `mm/page_alloc.c`, `mm/buddy.c`
- **Eigene Reimplementation:** trivial in C++23 (~200-400 LOC), public domain konform
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A19-buddy-knuth-knowlton/` (eigene Reimplementation als Algorithmus-Studie; ggf. Linux PCP+Buddy-Subset als Vergleichsreferenz)

## Verwandte Werke

- Knowlton, K.C. "A fast storage allocator." Comm. ACM 8(10), Oct 1965, 623-625 (Original-Paper)
- Knuth TAOCP Vol 1, §2.5 (1968) — definitive Beschreibung
- Wise 1978 "The double buddy-system" — Erweiterung
- Peterson/Norman 1977 "Buddy systems" CACM — Fibonacci/Weighted-Varianten
- Linux `mm/page_alloc.c` Source — production-grade Implementation mit Migrate-Types und PCP
