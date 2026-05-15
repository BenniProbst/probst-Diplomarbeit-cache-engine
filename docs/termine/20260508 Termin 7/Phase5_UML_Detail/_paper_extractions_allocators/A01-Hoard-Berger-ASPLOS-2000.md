# A01 — Hoard: A Scalable Memory Allocator for Multithreaded Applications

## Bibliographie
- **Titel:** Hoard: A Scalable Memory Allocator for Multithreaded Applications
- **Autoren:** Emery D. Berger, Kathryn S. McKinley, Robert D. Blumofe, Paul R. Wilson
- **Venue:** ASPLOS-IX (Ninth International Conference on Architectural Support for Programming Languages and Operating Systems), Cambridge MA, November 2000
- **DOI:** 10.1145/378993.379232
- **PDF-Quelle:** [people.cs.umass.edu/~emery/pubs/berger-asplos2000.pdf](https://people.cs.umass.edu/~emery/pubs/berger-asplos2000.pdf)
- **Code:** [github.com/emeryberger/Hoard](https://github.com/emeryberger/Hoard) (BSD/GPL Dual)

## Kerninnovation

Hoard ist der erste Allokator, der **gleichzeitig vier Eigenschaften** garantiert:
1. **Speed** (uniprocessor-Performance vergleichbar serieller Allokatoren)
2. **Scalability** (linear mit Prozessorzahl)
3. **False-sharing-Vermeidung** (sowohl active als auch passive)
4. **Low Fragmentation** (mit beweisbarem konstanten Blowup-Bound)

## Architektur

### Heap-Hierarchie
- **1 globaler Heap** (heap 0) + **P (oder 2P) per-processor heaps** (heap 1..P)
- Thread-Mapping: Hash(thread-id) → heap; auf Solaris LWP-ID
- Ein Thread konsumiert nur seinen eigenen heap + globalen heap
- **Per-Heap usage statistics:** u_i (in use) + a_i (allocated by Hoard from OS)

### Superblock
- Feste Groesse `S` = Vielfaches der System-Page-Size (Default S=8 KiB)
- Enthaelt Array gleichgrosser Blocks → exklusiv eine **size class**
- Free-list **LIFO-order** (Cache-Lokalitaet)
- Owner-Pointer im Superblock-Header → free findet Owner via Block-Header
- Objekte > S/2 → direkt mmap/munmap (large objects)

### Size Classes
- **Power-of-b** apart (b > 1), Default b = 1.2
- → Internal Fragmentation gebunden auf Faktor b = 20%
- Eine Size Class pro Superblock

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | Hoard-Konkretisierung |
|-------|------------------------|
| **AA1 FreeList-Topologie** | Innerhalb Superblock: LIFO Free-List (Cache-Lokalitaet); Pro Heap: doubly-linked List of Superblocks per Fullness-Group |
| **AA2 Size-Class-Schema** | Power-of-b (b=1.2), eine Class pro Superblock |
| **AA3 Thread-Locality** | Per-processor heap via Hash(thread-id) → heap-id; private heaps with thresholds |
| **AA4 Synchronization** | Pro-Heap-Lock (1 fuer Malloc, 2 fuer Free: heap+superblock); KEIN globaler Lock im Common-Case |
| **AA5 Allocation-Policy** | Always allocate from "fullest" superblock (move-to-front auf Fullness-Bin) |
| **AA6 Reclamation** | Empty-Threshold: wenn `u_i < a_i - K*S` AND `u_i < (1-f)a_i` → transfer mostly-empty Superblock zu global heap (NICHT zur OS!) |
| **AA7 Fragmentation-Strategy** | Empty-fraction `f` (Default 1/4) + Threshold-K-Superblocks; bounded blowup `O(1)` |

## Blowup-Theorem

**Definition:** `blowup = O(A(t) / U(t))` (allocated / used)

**Theorem 1:** `A(t) = O(U(t) + P)`

**Beweis-Skizze:** Invariante pro Per-Processor-Heap:
```
(a_i(t) - K*S ≤ u_i(t)) ∨ ((1-f)a_i(t) ≤ u_i(t))
```
Summiert ueber alle Heaps: `A(t) ≤ U(t) + P*K*S` → `blowup = O(1)` (konstant fuer fixiertes P, K, S).

→ **kein P²-Blowup** wie bei naive Per-Thread-Heaps oder unbounded wie bei pure-private-heaps!

## False-Sharing-Vermeidung

| Typ | Mechanismus |
|-----|-------------|
| **Active** | Nur ein Thread besitzt Superblock zur Zeit → verschiedene Threads bekommen Blocks aus verschiedenen Superblocks |
| **Passive** | Free returns block to **owning superblock** (nicht zum free-Thread-Heap) → keine Cache-Line-Sharing nach Free |

Tabelle 3 im Paper: 0 falsely-shared objects auf 14 Prozessoren bei allen 5 Multithreaded-Benchmarks.

## Synchronization Costs

- **Per-malloc:** 1 Lock-Acquire (heap)
- **Per-free:** 2 Lock-Acquires (heap + superblock)
- **Globaler Heap-Lock:** nur bei Cross-Heap-Transfer (selten)

Worst-case-Kontention bei `f=1/4, S=8K`: thread-acquires global heap lock at most `k/(f*S/s)` times per k memory ops = sehr selten.

## Performance-Resultate

- **Solaris 14-CPU SunFire 5000, 400MHz UltraSPARC:**
  - Threadtest: **+278% schneller** als Ptmalloc (next best) bei 14 procs
  - shbench: +85% schneller
  - Larson: **18× schneller** als Ptmalloc, 30 Sekunden Server-Sim
- **Single-thread Overhead:** +6.2% Average (akzeptabel)

## Empty Fraction Sensitivitaet

Tabelle 5: f=1/8, 1/4, 1/2 → **runtime nahezu unveraendert**, fragmentation 1.22-1.61.
→ Hoard ist **robust** gegen Wahl von f in [1/8, 1/2].

## Bedeutung fuer Comdare-CacheEngine

1. **Per-Processor-Heaps + Global-Heap-Discipline** → Vorlage fuer `c06_allocation_engine` AC2 ThreadLocality
2. **Superblock-Konzept** = unsere PRT-ART 4+2 Pools-Idee verallgemeinert
3. **Fullness-Groups** als Permutationsachse fuer `IPrtArtAllocator.consolidate()`
4. **Empty-Fraction f als Compile-time-Permutationsparameter** (analog Density-Schwellen 25/50/75 in PRT-ART)
5. **Move-to-Front-Heuristic** als `c09_heuristik_engine`-Atom

## Lizenz + Code-Verfuegbarkeit

- Lizenz: **BSD-style** (siehe `Hoard/blob/master/LICENSE`)
- Aktiv gepflegt seit 2000, **stable, production-ready**
- Plattformen: Linux, Windows, macOS (auch Solaris/IRIX/AIX historisch)
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A01-hoard/`

## Referenzen aus Hoard-Paper (relevant)

- [3] bCandid.com (legacy, nicht mehr verfuegbar)
- [22] Larson, Krishnan ISMM 1998 (Per-Heap Approach)
- [37] Vee, Hsu I-SPAN 1999 (Private Heaps with Threshold)
- [25] McKenney, Slingwine USENIX 1993 (Per-CPU memory allocation, Vorlage fuer A23 Vmem)
