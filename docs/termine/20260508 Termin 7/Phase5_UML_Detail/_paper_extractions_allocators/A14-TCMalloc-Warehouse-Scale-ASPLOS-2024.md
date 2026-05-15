# A14 — Characterizing a Memory Allocator at Warehouse Scale

## Bibliographie
- **Titel:** Characterizing a Memory Allocator at Warehouse Scale
- **Autoren:** Zhuangzhuang Zhou (Cornell), Vaibhav Gogte, Nilay Vaish, Chris Kennelly, Patrick Xia, Svilen Kanev, Tipp Moseley, Christina Delimitrou (MIT), Parthasarathy Ranganathan (Google) — alle Co-Autoren-Affiliation Google
- **Venue:** ASPLOS 2024 (29th ACM International Conference on Architectural Support for Programming Languages and Operating Systems), April 27 - May 1 2024, La Jolla CA
- **DOI:** 10.1145/3620666.3651350
- **PDF-Quelle:** [people.csail.mit.edu/delimitrou/papers/2024.asplos.memory.pdf](https://people.csail.mit.edu/delimitrou/papers/2024.asplos.memory.pdf)
- **Status:** **First comprehensive characterization** of TCMalloc on Google's production fleet

## Kerninnovation

**Erste umfassende Production-Charakterisierung** eines Memory-Allokators auf **Warehouse-Scale-Computing** (WSC). Identifiziert konkrete Bottlenecks + liefert 4 Optimierungen mit fleet-wide A/B-Test-Resultaten.

**Headline Results:**
- **+1.4% throughput** improvement fleet-wide
- **+3.4% memory reduction** fleet-wide
- **Top-5 apps:** +8.1% throughput, +6.3% memory
- **Bei Warehouse-Scale = Millionen Server-Cost-Savings**

## Production-Daten — Allocation Latency-Hierarchie

Mean allocation latency hitting different cache tiers:

| Tier | Latenz | Mechanismus |
|------|--------|-------------|
| **Per-CPU Cache** | **3.1 ns** | RSEQ fast path (~40 hand-coded x86 instructions) |
| **Transfer Cache** | 59.9 ns | Per-CPU cache empty → mutex-protected |
| **Central FreeList** | 78.5 ns | Span-traversal + linked-list pop |
| **PageHeap** | 136.9 ns | Hugepage-aware 2 MiB chunks |
| **mmap()** | **12,916.7 ns** | OS syscall — orders of magnitude slower! |

→ Per-CPU Cache hit rate = **kritisch** (≥99% in production)

## CPU Cycles Breakdown (Fleet-wide)

- **Total malloc CPU cycles:** **4.3% of fleet** (significant!)
- **Distribution within malloc:**
  - Per-CPU Cache: **53%**
  - Transfer Cache: 3%
  - **Central FreeList: 12%** (Bottleneck!)
  - PageHeap: 3%
  - Sampled (profiling): 4%
  - Prefetch: **16%** (critical for cache misses)
  - Other: 3%

→ Central-FreeList ist **disproportional teuer** wegen Linked-List-Span-Traversal

## Memory Fragmentation (Fleet-wide)

- **Fleet-wide fragmentation ratio:** 22.2%
  - **External:** 18.8% (unused memory cached by allocator)
  - **Internal:** 3.4% (size-class-rounding slack)
- **Fragmentation-Verteilung pro Cache-Tier:**
  - Pagination: 51% (Hugepage-Filler-Effekt!)
  - Central FreeList: 29%
  - Internal: 15%
  - Transfer Cache: 5%

## Object Lifetime + Size Distribution

- **98% der Objects ≤ 1 KiB** in Anzahl
- **>50% der Memory ist in Objects > 8 KiB** (Heavy-tailed)
- **256 KiB:** Maximum Cache-Tier Size; darueber direkt PageHeap
- Object-Lifetime-Diversity: gleiche Size-Class kann sowohl <1 ms als auch ≥7 days leben!
- 65% der Objects > 1 GiB leben > 1 Tag

## 4 Optimierungen + Fleet-Test-Resultate

### Optimization 1 — Heterogeneous Per-CPU Caches

**Problem:** WSC apps run on subset of CPUs (control plane scheduler). Per-CPU caches sind statisch grosse → niedrige vCPU-IDs ueberlastet, hohe vCPU-IDs ungenutzt.

**Loesung:** Dynamic resizing — background thread alle 5s redistributes capacity.

**Fleet-wide A/B test:**
- Memory reduction: **1.94%** im Fleet, 0.58-2.45% im Top-5
- Cache-default-size reduziert von 3 MB → 1.5 MB ohne Performance-Verlust

### Optimization 2 — NUCA-Aware Transfer Caches

**Problem:** Chiplet-CPUs (z.B. AMD EPYC, Intel Sapphire Rapids) haben Multiple Last-Level-Cache-Domaenen. Inter-cache-domain access = **2.07× langsamer** als intra-cache-domain (LLC Domain 0 → LLC Domain 9 = 110.7 ns vs 53.6 ns).

**Loesung:** **NUCA-aware Transfer Caches** — eine Transfer-Cache pro LLC-Domain (chiplet).

**Fleet-wide A/B test:**
- Throughput: **+0.32%** Fleet, **+0.28-1.72%** Top-5
- LLC Load Miss Rate Reduktion: **4.37%**

### Optimization 3 — Span Prioritization in Central FreeList

**Problem:** Spans mit nur einem live object werden NIE released wenn dieses Object long-lived ist → ein single object haelt eine ganze Span (8 KiB - 256 KiB).

**Loesung:** Central FreeList sortiert Spans nach Live-Allocation-Count, allociert aus high-count-Spans zuerst → low-count-Spans werden eher leer und released.

**Implementation:** L=8 linked lists statt einer einzigen Span-List (`max(0, L - log2(A))` für A live allocations).

**Fleet-wide A/B test:**
- Memory reduction: **1.41%** Fleet, 0.34-2.54% Top-5
- Performance: unaffected

### Optimization 4 — Lifetime-Aware Hugepage Filler

**Problem:** Hugepage-Filler weiss nicht, dass spans verschiedene Lifetimes haben → mixt short-lived und long-lived spans → hugepage wird nie completely free.

**Loesung:** **Span-Capacity** als **Proxy fuer Lifetime** (Spearman -0.75 correlation between span capacity and return rate). Threshold C=16:
- Spans mit capacity > C (long-lived) → eigene Hugepage-Pool
- Spans mit capacity ≤ C (short-lived) → eigene Hugepage-Pool

**Fleet-wide A/B test:**
- Throughput: **+1.02%** Fleet, +0.38-6.29% Top-5
- Memory: 0.82% Fleet
- Hugepage coverage: 54.4% → 56.2%
- dTLB miss rate: -8.1%

## Bausteine-Achsen-Mapping (AA1-AA7) — Erweiterungen aus A14

| Achse | A14-Insights |
|-------|--------------|
| **AA1 FreeList-Topologie** | **L=8 Span-Lists** statt 1 in Central FreeList — Lifetime-Differenzierung |
| **AA2 Size-Class-Schema** | Bestaetigt: 80-90 size classes optimal; 256 KiB Cache-Threshold sweet-spot |
| **AA3 Thread-Locality** | **Heterogeneous Per-CPU Caches** dynamisch sized — Pflicht fuer scheduled-subset-Apps |
| **AA4 Synchronization** | RSEQ Per-CPU > Per-Thread (Fleet-Daten bestaetigen) |
| **AA5 Allocation-Policy** | **Span Prioritization** — Live-Count-aware allocation policy |
| **AA6 Reclamation** | **Lifetime-aware Hugepage-Filler** — span capacity als lifetime proxy |
| **AA7 Fragmentation-Strategy** | NUCA-Awareness als neue Achsen-Konkretisierung; Multi-LLC-Domain-Pattern |

## Methodik (wertvoll fuer Comdare!)

- **GWP (Google-Wide Profiling)** — kontinuierliches Sampling von 1-10% der Fleet-Maschinen pro Tag
- **Fleet-Experiments:** A/B test mit 1% experiment + 1% control group, fleet-rollout, vergleich Throughput
- **5 Production Workloads + 4 Microbenchmarks** als Pflicht-Eval-Suite:
  - Spanner (distributed SQL DB)
  - Monarch (time-series metrics)
  - Bigtable (NoSQL key-value)
  - F1 Query (distributed SQL)
  - Disk (low-level storage RPC)
  - + Redis, Data-Pipeline (1GB word count), Image-Processing, Tensorflow

## Bedeutung fuer Comdare-CacheEngine

1. **Hierarchie + Latenzen** = direktes Vorbild fuer Comdare's `c06_allocation_engine`-Hot-Path-Design (3 ns Per-CPU = Goal!)
2. **L=8 Span-Lists fuer Lifetime-Differenzierung** = Pflicht-Konkretisierung fuer `c10_topologie_engine.aa6_reclamation.LifetimeAwareSpanPrioritization` Atom
3. **NUCA-Aware Transfer Caches** = Pflicht fuer Chiplet-CPUs in Block AO Pflicht-Plattformen (AMD EPYC, modern Intel)
4. **Span-Capacity als Lifetime-Proxy** = brilliant + statisch-bestimmbar — direkt anwendbar fuer Comdare ohne Runtime-Profiling
5. **Heterogeneous Per-CPU Caches** = Adaptive Resizing als `c09_heuristik_engine` Atom
6. **GWP-Methodik** = Vorbild fuer Comdare's eigenes Telemetry-System (`c05_telemetry_engine`)
7. **Fleet-Experiment-Methodology** = Vorlage fuer Comdare's Phase-7 Experiment-Loop
8. **mmap() = 12916 ns** = Pflicht-Avoidance: jede mmap-Call = ~4000 Cache-Misses verloren!

## Insights fuer PRT-ART

- **Span-Capacity als Lifetime-Proxy:** PRT-ART **Pool A 256B (Type A)** hat capacity 1, Pool B Array[65535] hat capacity 65535 → kann bereits als Lifetime-Proxy genutzt werden (Type-A-Bloecke leben kuerzer)
- **Hugepage-Awareness:** PRT-ART Pool D (Vector<u16,u16> 4KiB+) sollte hugepage-aligned sein
- **Per-CPU Cache 3.1 ns:** Comdare PRT-ART hot-path muss **unter 100 Instruktionen** bleiben

## Lizenz + Code-Verfuegbarkeit

- **Lizenz Paper:** Open Source (Author Copyright); ASPLOS-Paper unter ACM-Open-Access
- **Code:** Optimierungen sind in modernem [github.com/google/tcmalloc](https://github.com/google/tcmalloc) gerollt — kein separates Repo
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A14-tcmalloc-asplos2024-optimizations/` (Code-Annotations + Tests fuer die 4 Optimierungen aus dem Source-Tree)

## Verwandte Werke

- TCMalloc Original (A06, Google 2009-2024) — Charakterisierungs-Subjekt
- mimalloc (A04, Leijen 2019) — wird kurz als "similar hierarchical architecture" referenced
- jemalloc (A05, Evans 2006) — wird referenced als alternative
- snmalloc (A07) — referenced fuer message-passing approach
- Hoard (A01) — referenced fuer false-sharing
- Mesh (Powers et al. PLDI 2019) — alternative compaction approach
- mallacc (Kanev et al.) — vorhergehender Memory-Allocator-Profiling-Work
- AdaptiveMM (Hunter et al. ISMM 2021) — vorhergehende hugepage-aware-pageheap (Reference [33] im Paper)
- Heracles (Lo et al.) — datacenter resource efficiency baseline
