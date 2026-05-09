# Cluster E - Prefetching 2 + Telemetry

Datum: 2026-05-09
Architektur-Bezug: REV 2 Concept-Hierarchy (Saeule A: IPage/IRootPage/IFanout/INode/ISearchPage/ICachePage; Saeule B: ICacheLevel/ICacheLine/ICacheTopology/IInterconnect/ILivePlatformModel; Achse 11: TelemetryStrategy)

Quellen:
- P24 = Naderan-Tahan & Sarbazi-Azad (2016) "Why Does Data Prefetching Not Work for Modern Workloads?", The Computer Journal Vol 59 No 2
- P25 = Mahling, Weisgut, Rabl (2025) "Fetch Me If You Can: Evaluating CPU Cache Prefetching and Its Reliability on High Latency Memory", DaMoN '25
- P26 = Zhang, Song, Zhou, Wei, Xiao (2024) "A prefetching indexing scheme for in-memory database systems", FGCS 156
- P27 = Zhang, Grot, He, Lv, Qu, Su, Wang, Zhang, Zhang, Zhang (2025) "Hierarchical Prefetching: A Software-Hardware Instruction Prefetcher for Server Applications", ASPLOS '25
- P28 = Kuehn, Biebert, Hakert, Chen, Teubner (2023) "Towards Data-Based Cache Optimization of B+-Trees", DaMoN '23

---

## P24 Naderan-Tahan & Sarbazi-Azad (2016) "Why Does Data Prefetching Not Work for Modern Workloads?"

### 1. CACHE-STRATEGIEN

| Konzept | Detail |
|---------|--------|
| L1 Data Cache Fokus | Split I/D, 64KB private, 2-way, 64B Line, LRU, write-through, 2-cycle hit, 32-entry MSHR (Tab. 1) |
| L2 Cache Setup | 8MB shared, unified, NON-INCLUSIVE, 8-way, 64B Line, LRU, write-back, 10-cycle hit, 64-entry MSHR |
| L1 Trend | L1-Cache-Groessen stagnieren seit 2000 (Fig. 1) wegen Latenz-Constraints — Architekten KOENNEN L1 nicht groesser machen |
| Cache-Line Granularitaet | 64B Standard-Annahme |
| Reuse Distance Analyse | Anzahl distinkter Elemente zwischen 2 Accesses zur selben Adresse (Sektion 4.1, Fig. 5) |
| Spatial-Locality-Definition | Counter C inkrementiert wenn M konsekutive Adressen auf selben Block mappen, Spatial Degree = C/(N-1) (Sektion 4.2) |

### 2. ALGORITHMUS-STRATEGIEN

**Evaluierte Hardware-Prefetcher (Sektion 3):**

| Prefetcher | Beschreibung | Coverage Scale-Out | Overprediction |
|------------|--------------|--------------------|----------------|
| NLP (Next-Line) | Issue Prefetch fuer Block X+1 bei Access auf X | 24.16% | 83.28% |
| Stream (med) | 4 States (Invalid/Allocated/Training/Monitor-Request), Prefetch-Distanz N, Prefetch-Degree d=2 | 13.03% | 90.69% |
| GHB PC/DC | Global History Buffer, n-entry FIFO, Delta-Correlation, 1K-Entries Index, 64B Lines | 9.2% | 92.28% |
| ISB | Irregular Stream Buffer, Physical-to-Structural Address Mapping, 1K-Entry PS-AMC + SP-AMC | -5.4% (NEGATIV!) | 92.4% |
| SMS | Spatial Memory Streaming, Spatial Region Tag + PC-Bitvector, Filter+Accumulation+PHT (16K) | 19.5% | 33.9% |

**KRITISCHE ERKENNTNIS:** ALLE 5 evaluierten Prefetcher (urspruenglich fuer SPECCPU/Server entwickelt) sind FUER SCALE-OUT WORKLOADS UNGEEIGNET (Tab. 3, Fig. 2). ISB hat sogar NEGATIVE Coverage = mehr Misses als Baseline.

**Sequitur-basierte Time-Dimension Analyse (Sektion 5.2):**
- Hierarchical data compression algorithm baut Grammatik-Regeln aus Miss-Sequenzen
- Kategorien: non-repetitive / new / head / opportunity
- Cloudsuite (ausser Map Reduce): >50% non-repetitive Misses → kaum Opportunity fuer history-basierte Prefetcher

### 3. SONDERMERKMALE

**NEGATIVER BEFUND (Hauptbeitrag des Papers):**
1. Modern Cloud/Big-Data/Scale-Out-Workloads (Cassandra, Hadoop MapReduce, Cloudstone, Cloud9, Nutch/Lucene, Darwin Streaming) sind grundlegend ANDERS als SPECCPU
2. Hohe Overprediction-Rates fuehren zu Cache-Pollution (prefetched blocks evicted ohne Access)
3. Modern Workloads haben POOR Temporal Locality
4. Variable+lange Reuse-Distanzen (Vips: 80% Distanzen <64; Scale-Out: Mix zwischen 4K-8K)
5. Top 20 reused Adressen tragen <30% bei (Web Search, Media Streaming sehr arm)
6. ENERGIE-INEFFIZIENT: 10×, 15×, 1.2×, 100× mehr Memory-Requests bei marginaler Coverage (Tab. 3)

**Modern Workloads haben aber ueberraschend HOHE Spatial Locality** (Fig. 8) - sogar besser als traditionelle Workloads bei kleinen Block-Sizes.

### 4. PLATTFORM-MODELLIERUNG-BEZUG

| Bezug zu Saeule B | Detail |
|-------------------|--------|
| ICacheLevel | L1/L2/LLC + main memory in 4-Level-Hierarchy explizit modelliert |
| ICacheTopology | UltraSPARC-III ISA, 16-core directory based shared L2, 4 memory controllers |
| ICacheResidency | MSHR-Groesse (32 vs 64) als Kapazitaets-Limitierung |
| IHardwareExtension | Implizit ueber Cloudsuite-Workloads (Web/SAT/Map-Reduce) |
| IIsaFeatureSet | UltraSPARC-III, 8-stage pipeline, 4-wide dispatch, 96-entry ROB |
| IInterconnect | LLC slices, routers, directories — alle als Energiekonsumenten markiert (Sektion 6) |

### 5. VERALLGEMEINERUNGS-VORSCHLAEGE (fuer PRT-ART)

1. **NegativPredictionStrategy** als Achse-11 TelemetryStrategy: System soll erkennen WANN Prefetch SCHADET (negative Coverage Indikator) und Prefetch deaktivieren
2. **OverpredictionGate**: Telemetry pro ICachePage wenn (overprediction/coverage > threshold) → Prefetch-Degree reduzieren
3. **ReuseDistanceTelemetry**: Per-IFanout Counter fuer Distanzen-Histogramm (BARRIERE: pro Knoten oder leaf-only)
4. **WorkloadTypeStrategy** als ICacheStrategy: cache-friendly vs prefetch-friendly vs scale-out (definiert ueber Miss-Ratio <0.5% bzw. Coverage >50%)
5. **EnergieAwareCacheStrategy**: ALLE 5 Prefetcher kombinieren bei Scale-Out 33%-92% mehr Memory-Traffic — Verallgemeinerung in Saeule B IMemoryBandwidthModel

### 6. LUECKEN

- OFFEN: Paper liefert KEINE konstruktive Loesung, nur Analyse "warum Prefetcher versagen" — Anschlussforschung notwendig
- OFFEN: Energie-Modell verwendet CACTI+McPAT, aber ohne Detail zu Cache-Coherence-Energiekosten
- OFFEN: Keine Aussage zu MULTI-CORE Coherence-Effekten (16-core simuliert, aber Coherence-Traffic nicht aufgeschluesselt)
- OFFEN: Kein Bezug zu PathReadCounter / TelemetryStrategy auf Indexstruktur-Ebene

---

## P25 Mahling, Weisgut, Rabl (2025) "Fetch Me If You Can"

### 1. CACHE-STRATEGIEN

**Hardware-Prefetch-Lokalitaeten (Sektion 2, Fig. 2+3):**

| Hint | x86 Standard | Tatsaechliche Implementierung pro CPU |
|------|--------------|---------------------------------------|
| T0 | Prefetch in L1 | Konsistent in L1 ueber alle 7 CPUs (NTA + T0 deckungsgleich auf 6/7) |
| T1 | Prefetch in L2 | Intel: T1=T2 (auf Xeon Scalable); AMD: alle Hints = T0 |
| T2 | Prefetch in L3 | Intel: T1=T2; AMD: gleicher Pfad wie T0/T1; Grace: T2 → L3 (einziger CPU der ALLE 4 Localities unterscheidet) |
| NTA | Non-Temporal Access (frueh evicten) | AMD: gleicher Pfad wie T0 mit frueher Eviction; Grace: in L1 mit Direkt-Eviction zu Memory |

**ARM-spezifisch:** 6 Instructions ueber 2 Policies (KEEP, STREAM) × 3 Targets (L1, L2, L3) — STREAM ~ NTA, KEEP cacht.

**Fill Buffer (FB) - HAUPTERKENNTNIS:**
- Intel: line fill buffer (LFB)
- AMD: miss address buffer (MAB)
- Fujitsu: move in buffer (MIB)
- FB sitzt zwischen L1 und L2
- FB-Slot pro outstanding L2/L3/Memory-Request
- FB ist DER zentrale Bottleneck fuer latency-bound Workloads

**FB-Sizes (Tab. 1):**

| System | CPU | Memory | FB-Size | Local Lat (ns) | Remote Lat (ns) |
|--------|-----|--------|---------|-----------------|-----------------|
| EPYC-2 | 2× 7742 | DDR4 | 21 | 153 | 277 |
| EPYC-3 | 2× 7413 | DDR4 | 24 | 83 | 272 |
| Xeon-E5 | 2× E5-2689 v4 | DDR4 | 10 | 80 | 130 |
| Xeon-2 | 2× 5220S | DDR4 | 12 | 76 | 156 |
| Xeon-3 | 2× 8352Y | DDR4 | 12 | 83 | 134 |
| A64FX | 1× A64FX | HBM2 | 12 | 215 | 307 |
| Grace | 1× Grace CPU | LPDDR5X+HBM3 | 16 | 181 | 760 |

**Hardware Prefetcher** liegen typischerweise auf L2 — FB zwischen L1/L2 limitiert sie NICHT, sondern hoehere Queues.

### 2. ALGORITHMUS-STRATEGIEN (inkl. TelemetryStrategy)

**Software-Prefetching mit Coroutines (Sektion 4.1):**
- Basis: OLC B+-Tree (Optimistic Lock Coupling, Leis et al.)
- Erweitert von Kuehn et al. (P28-Vorgaenger 2024-DaMoN)
- Coroutines = suspendable/resumable Functions, 1 pro Lookup
- Prefetch Node → Suspend Coroutine → Resume andere
- Granularitaeten:
  - Coro Full Node: ganzen Knoten prefetchen
  - Coro Half Node: erst Header, dann Keys; in Leaf zusaetzlich Value

**KRITISCHES KONZEPT: Prefetching Reliability (Sektion 3.2):**

| Reliability | Verhalten | CPUs |
|-------------|-----------|------|
| WEAK | Prefetch wird DROPPED wenn FB voll | EPYC-2, EPYC-3, Grace, A64FX-Weak |
| STRONG | CPU STALLT bis FB-Slot frei | Xeon-E5, Xeon-2, Xeon-3, A64FX-Strong |
| KONFIGURIERBAR | Per-Setting | A64FX (einziger dokumentierter) |

**TelemetryStrategy-relevant: Microbenchmark zur FB-Reliability-Erkennung (Sektion 3.2):**
- Batch-Prefetch + sequential Access mit Data-Dependency
- Threshold-Detection: bei Batch-Size > FB → entweder Prefetch-Latenz steigt steil (STRONG) oder Access-Latenz steigt (WEAK)
- L1D_PEND_MISS.FB_FULL Performance Counter (Xeon-3) als RUNTIME-TELEMETRY
- FB_FULL stieg von 332→2712 bei Switch 512B→8KB Nodes mit Coro Full Node (Remote)

### 3. SONDERMERKMALE

**Hauptbefund (Fig. 1):**
- Bei 8 KiB B+-Tree-Nodes:
  - WEAK Reliability: Speedup 1.1× bis 2× (auch Remote)
  - STRONG Reliability: Slowdown 0.4× bis 1× (defeating prefetch purpose!)
- Binary Search: Speedup 1.4-2.1× (lokal) und 1.9-2.8× (remote)

**Speculative Prefetching Problem:**
- 8KB Node = 128 Cache Lines = 128 FB-Slots → exceeds ALL FB sizes
- STRONG-CPUs stallen ENDLOS waehrend Prefetch
- WEAK-CPUs prefetchen nur die ersten Lines, accessen aber NUR Header + ein paar Keys → Vorteil

**Implementation Effort (Sektion 4.2):**
- State Machine: 84 LOC, hoechste Performance
- Coroutine: 20 LOC, etwas hoeherer Overhead aber praktischer

### 4. PLATTFORM-MODELLIERUNG-BEZUG

| Bezug zu Saeule B | Detail |
|-------------------|--------|
| ICacheLevel | L1/L2/L3 + Memory mit konkreten Latenzen alle 7 Plattformen |
| ICacheTopology | x86 (Zen2/Zen3, Skylake/Ice Lake), ARM (A64FX, Grace), Multi-Socket |
| ICacheResidency | NTA = direct evict / KEEP = retain — als Strategy-Knob |
| IHardwareExtension | NVLink-C2C (Grace+Hopper), CXL als Future-Trend genannt |
| IIsaFeatureSet | T0/T1/T2/NTA (x86), KEEP/STREAM × L1/L2/L3 (ARM) |
| IInterconnect | CHA (Caching/Home Agent) explizit modelliert (Fig. 2) |
| IMemoryBandwidthModel | DDR4 / HBM2 / HBM3 / LPDDR5X / GDDR — heterogene Bandbreiten |
| ILivePlatformModel | THP (madvise), NUMA mbind System Calls — Live-Konfiguration |
| IPinningPolicy | numactl/mbind fuer NUMA Pinning |

### 5. VERALLGEMEINERUNGS-VORSCHLAEGE (fuer PRT-ART)

1. **PrefetchReliabilityStrategy** als Achse 11 TelemetryStrategy:
   - PerNodeReliabilityCounter erkennt FB_FULL pro Knoten via Performance Counter
   - Switch zwischen Half-Node-Prefetch und Full-Node-Prefetch dynamisch
2. **AccessProbabilitySortedPrefetch**: Bei WEAK Reliability sortiere Prefetches nach Access-Wahrscheinlichkeit (Header/Middle-Key zuerst) — verbindet zu P28 Hot-Path-Detection
3. **FBSizeAwareLimiting**: ICacheStrategy konsultiert ILivePlatformModel.fbSize — Prefetches ≤ FB-Size
4. **PortablePrefetchStrategy**: NUR T0 + NTA verwenden (consistent ueber x86+ARM laut P25 Empfehlung)
5. **TwoGranularityPrefetchVisitor**: ICacheStrategy = Visitor mit Half/Full Node Methods

### 6. LUECKEN

- OFFEN: Paper macht KEINE per-Node-Counter (nur per-Workload-Reliability-Test)
- OFFEN: Coroutine-Implementation Code-Path fuer custom node sizes nicht detailliert
- OFFEN: NUMA-Aware Allocator wird erwaehnt, aber Implementation-Details fehlen
- OFFEN: Cache-Coherence-Anti-Pattern bei PerNodeCounter NICHT adressiert (PRT-ART eigene Erkenntnis 2026-05-09)

---

## P26 Zhang, Song, Zhou, Wei, Xiao (2024) "A prefetching indexing scheme for in-memory database systems"

### 1. CACHE-STRATEGIEN

**Hauptkonzept Cache Prefetching (Sektion 3.2.1):**
- Code Snippet 1(b): `__builtin_prefetch((void*) node + i*64, 0, L3)` bei jeder Inner-Node-Iteration
- Optimal Node Width w_optimal = 8 Cache Lines (laut P26 Experiment)
- Issue Prefetches in L3-Cache VOR Binary Search

**Read Counter pro Block (Sektion 3.2.2):**
- Counter wird inkrementiert bei jedem Block-Read
- Levelled Query Monitor: pro L_i Tree-Level
- Counter-Storage: NICHT inline in Block (verursacht Cascade-Updates), SONDERN separater Block (Search Block Table)
- Array indexed by Block Address (Fig. 5)

**Cache Capacity Allocation (Tab. 5):**
- Bsp 20M Tuples, Tree-Height 7
- L1: 0.03MB, L2: 0.1MB, L3: 2MB, L4: 7MB, L5: 102MB(!)
- L5 EXCEED L3-Cache → Prefetching mandatory

### 2. ALGORITHMUS-STRATEGIEN (inkl. TelemetryStrategy)

**3-Komponenten-Architektur (Fig. 3):**

| Komponente | Funktion |
|------------|----------|
| Online Query Monitor | Tracked Blocks pro Query, Read Counter per Block, Search Block Table |
| Path Prefetcher | Prefetch Table mit hot Access Paths, Cache-Pref + Path-Pref + Monitor-Pref |
| Jump Pointer Prefetcher | Prefetch Queue fuer Version-Chain, 2-ahead Jump Pointers |

**3 Prefetching-Strategien (Sektion 3.2.1, P-Definition: P = {p(l,i) | 1 ≤ l ≤ h-1}):**

1. **Cache Prefetching (CP)**: Prefetch CACHE LINES eines Knotens VOR Binary Search innerhalb dieses Knotens
2. **Path Prefetching (PP)**: VOR Root-to-Leaf-Search prefetche ALLE Knoten-Bloecke entlang erwartetem Pfad
3. **Monitor Prefetching (MP)**: Sammle Query-Statistiken, generiere Prefetch Table mit haeufigen Pfaden, e.g. {p(1,i-2), p(1,i-1), p(1,i), p(1,i+1), p(1,i+2)}

**Monitor Prefetching Algorithm (Algorithm 1):**
```
Stage 1 (Clustering): Fuer jeden Key k in K:
   foreach r_k in P: if (r_k closest to k) then r_k = r_k + w*(k - r_k)
Stage 2 (Round-Robin): Generiere Prefetch-Instruktionen fuer L_1 unter Verwendung r
```
- w = Forgetting-Factor fuer Drift-Adaption
- Round-Robin spreads access path candidates across queries
- L3-limited Prefetching Distance: p × B_L3 / B_InnerNode

**Jump Pointer Queue (Sektion 3.3, Fig. 6):**
- Layout: [v_i, &v_i+1, &v_i+2, &v_i+3, ..., &v_header]
- Cursor zeigt auf physical Address des HEAD (statt direct version pointer)
- Insertion bei HEAD-Aenderung gracefully handhabbar
- Implementation als chunked linked list (chunk size 8 = 1 cache line)

**TelemetryStrategy-relevant: PathReadCounter (Sektion 3.2.2 + Sektion 3.2.4):**
- Per-Block Counter (NICHT per Tuple/Key) → leaf node split kopiert Counter zu beiden Childs
- Computed Optimal Access Path: w(k) = Sum_{l=1}^{h-1}(BlockCounter_l)
- Naive Approach: Hold ALL access paths → infeasible (e.g. 248,760 Inner Nodes × 16 keys → 121MB > L3)
- Resource-efficient: 2-Stage Algorithm mit Clustering
- Distance Metric: Anzahl gemeinsamer Bloecke auf Traversal-Pfad
- Worker Thread baut Index auf Read Counters

### 3. SONDERMERKMALE

**MVCC-Spezifika (Sektion 2.2, Fig. 2):**
- 3-Pfad Search: Path 1 (Root→Leaf) + Path 2 (Indirection Layer) + Path 3 (Long Version Chain)
- Pointer Chasing in Version-Chain als Hauptproblem
- 50%/50% Search/Update Workload: 75-82% Total Execution Time geht in Pointer Chasing

**Cost Model (Sektion 3.5):**

```
TIT  = (1 + ⌈log_max(N)⌉) × (T_tlb + (w_l/2) × T_1)         (Eq. 1, Tree Index Traversal)
TIT_p = (1 + ⌈log_max(N)⌉) × (T_1 + (w_l/2 - 1) × T_next)   (Eq. 2, mit Prefetching)
VCT   = T_tlb + T_1 + n_i × (T_tlb + (w_v/2) × T_1)         (Eq. 3, Version Chain Traversal)
VCT_p = n_i × (T_1 + (w_v/2 - 1) × T_next)                  (Eq. 4, mit Prefetching)
```

Mit Werten T_tlb=18, T_1=200, T_next=8 (cycles):
- Traditional 6324 cycles vs. Prefetching 3440 cycles → 1.84× besser

**Performance:**
- 1.20-1.76× Speedup auf YCSB
- 20-70% besser als state-of-the-art
- Path Prefetching meist BESTE Strategie (warmer Cache)

**Space Overhead:**
- 16 × 8B = 128B pro 1536B Block = 8% Jump Pointers
- Jump Pointer Queue: 8B × n / 200B × n ≈ 0.04% (durch GC reduziert)

### 4. PLATTFORM-MODELLIERUNG-BEZUG

| Bezug zu Saeule B | Detail |
|-------------------|--------|
| ICacheLevel | L1 (32KB), L2 (256KB-1MB), L3 (8-28MB), DRAM (200-220 cycles) explizit |
| ICacheTopology | Coffee Lake (E-2224G, 4 cores) + Cascade Lake (Gold 5218R, 20 cores) |
| ICoreLayout | 1 vs 10 Threads explizit getestet |
| IIsaFeatureSet | __builtin_prefetch + L3-Hint (Locality 0/1/2/3) |
| ILivePlatformModel | DRAM-Latenz 200-220 cycles als Konstante |

**TLB-Modellierung implizit:**
- T_tlb = 18 cycles in Cost Model
- TLB Miss Penalty separat von Cache Miss Penalty

### 5. VERALLGEMEINERUNGS-VORSCHLAEGE (fuer PRT-ART)

1. **PathReadCounter** (Saeule A Achse 11) — DIREKT in PRT-ART uebernommen aus P26
   - Per-Block (= per ICachePage) Counter, NICHT per-Tuple
   - Update durch Worker-Thread (vermeidet Hot-Path-Coherence-Storm)
2. **PrefetchTable als ISearchPagesStrategy-Cache**: Speichert hot Pfade fuer wiederverwendbare Queries
3. **JumpPointerPrefetcher**: 2-ahead Jump Pointer fuer Version-Chains; Verallgemeinerung zu N-ahead via PRT-ART-Levels
4. **MonitorClusteringAlgorithm**: Stage 1+2 als ICacheStrategy-Subtype mit Forgetting-Factor w
5. **CacheCapacityBudget**: PrefetchDistance = p × B_L3 / B_InnerNode → ILivePlatformModel.cacheCapacity-Konsultation
6. **Levelled Monitor**: Per-Tree-Level Telemetry (NICHT alle Levels gleich) — passt zu PRT-ART LeafOnlyCounter

### 6. LUECKEN

- OFFEN: Counter-Updates IM Block koennen False Sharing erzeugen — P26 erkennt aber separater Storage als Loesung
- OFFEN: Worker-Thread fuer Counter-Index-Build laeuft async — Konsistenz-Modell unklar
- OFFEN: Bei stark skewed Zipfian (theta=0.99) sinkt der Vorteil — P26 erkennt dies
- OFFEN: KEINE Aussage zu LeafOnlyCounter (NEU 2026-05-08 PRT-ART Idee)
- OFFEN: KEINE Aussage zu RetroactiveAggregation
- OFFEN: Range-Scan-Performance bei wenigen Keys (10-20) sinkt — P26 erkennt dies
- OFFEN: Cache-Coherence Anti-Pattern bei updates auf Counter-Block nicht analysiert

---

## P27 Zhang, Grot, He et al. (2025) "Hierarchical Prefetching"

### 1. CACHE-STRATEGIEN

**Multi-Level Cache Hierarchy (Tab. 1):**

| Cache | Groesse | Way | Cycles | MSHRs |
|-------|---------|-----|--------|-------|
| L1 I-Cache | 32 KB | 8 | 2 | 16 |
| L1 D-Cache | 48 KB | 12 | 4 | 16 (NextLine Prefetcher) |
| L2 (private) | 512 KB | 8 | 14 | 32 |
| LLC (shared) | 2 MB/core | 16 | 50 | 64 |
| Memory | DDR4 2400MHz | - | - | - |

**Schluesselkonzept BUNDLE:**
- Coarse-grained Code-Region (10s-100s KB)
- Static Footprint via Call-Graph-Analyse
- Dynamic Footprint waehrend Bundle-Execution: 3-10× kleiner als statisch
- Avg Bundle Size: 15-68 KB Instruktionen
- Bundle Execution: ~63045 cycles avg
- 3.7% (avg) der Funktionen sind Bundle-Entries

**Spatial Region Encoding (Sektion 5.3.1):**
- Compression Buffer: 16-entry FIFO
- Spatial Region: max 32 contiguous cache blocks, encoded als (base address, bit vector)
- 60% der Bandwidth-Overhead in Metadata Read/Write, 40% in Wrong Prefetch

**Storage:**
- 1.94 KB on-chip total (Metadata Address Table)
- 512 KB in-memory Metadata Buffer (per-core)
- Reads access Metadata Buffer cached in L3

### 2. ALGORITHMUS-STRATEGIEN (inkl. TelemetryStrategy)

**Bundle-Identification Algorithm (Algorithm 1):**
```
procedure GetBundleEntries(binary, threshold):
  call_graph = BuildCallGraph(binary)
  reachable_size = GetReachableSize(call_graph)
  for func, size in reachable_size do
    if size < threshold then continue
    if any(func.fathers.size - size > threshold) then
      Entries.add(func)
    end if
  end for
```
- Threshold = 200 KB (default)
- Call-Graph aus Static Linker (deckt dynamic libs ab durch ELF .dynamic)

**Record-and-Replay Mechanism:**
- Record Phase: Bei tagged Instruction → record alle retired Instructions als Spatial Regions
- Replay Phase: Bei tagged Instruction → look up Bundle ID in Metadata Address Table → start Prefetch von Head Segment
- Segments fit in L1-I capacity (segments-aware prefetching)

**Hardware Components:**

| Component | Beschreibung |
|-----------|--------------|
| Compression Buffer | 16-entry FIFO, fully associative, retired instructions zu Spatial Regions |
| Metadata Buffer | 512 KB main memory, segments + spatial regions |
| Metadata Address Table | 512 entries 8-way LRU, 24-bit Bundle ID, 1.94 KB on-chip |

**TelemetryStrategy-relevant: Bundle Statistics (Tab. 4):**
- Avg Jaccard Index pro Bundle (Recurrence-Quality)
- 0.81-0.97 ueber alle Workloads → hohe Stabilitaet
- Static vs Dynamic Footprint Ratio
- Late Prefetch Percentage (3% bei Hierarchical, 29% bei EFetch)

### 3. SONDERMERKMALE

**Bundle-based Instruction Prefetcher** (NICHT Data-Prefetcher!) — ANDERE DOMAIN als P24-P26+P28!

**Vergleich State-of-the-Art (Tab. 2 + Tab. 3):**

| Prefetcher | Distance | L1-I Accuracy | L1-I Coverage | L2 Coverage | Storage |
|------------|----------|---------------|---------------|-------------|---------|
| EFetch (caller-callee) | 3.4 | 58% | 10% | 8% | ~40 KB |
| MANA (temporal) | 4.3 | 55% | 14% | 12% | 15 KB |
| EIP (correlating) | 6.1 | 30% | 48% | 23% | 40 KB |
| **Hierarchical** | **90** | **53%** | **37%** | **54%** | **1.94 KB** |

**Performance:** 6.6% IPC Speedup ueber FDIP (Fetch-Directed Instruction Prefetching) Baseline. 16.8% wenn Perfect L1-I.

**KRITISCHE INNOVATION:** Hierarchical erreicht 90 cache blocks Prefetch-Distance bei 53% Accuracy — andere Prefetcher zerfallen bei distance > 4-6.

### 4. PLATTFORM-MODELLIERUNG-BEZUG

| Bezug zu Saeule B | Detail |
|-------------------|--------|
| ICacheLevel | L1-I/L1-D/L2/LLC explizit, Ice Lake-like x86-64 4GHz |
| ICacheTopology | Out-of-order O3CPU model in gem5 |
| IBusTopology | FTQ (Fetch Target Queue, 24 entries default) |
| IIsaFeatureSet | x86-64 / AArch64 (beide unterstuetzt durch Reserved Bits in call/return) |
| IInterconnect | LLC + main memory access via bandwidth model |
| ILivePlatformModel | DDR4 2400 MHz konkrete Memory-Spezifikation |
| IHeuristic | Bundle Threshold 200 KB als Tunable |

### 5. VERALLGEMEINERUNGS-VORSCHLAEGE (fuer PRT-ART)

1. **BundlePrefetchStrategy** als ISearchPagesStrategyPattern: Coarse-grained Path-Prefetch fuer N adjacent ISearchPages
2. **JaccardSimilarityTelemetry** in Achse 11: Per-Bundle Avg Jaccard Index als Telemetry-Metric
3. **CompressionBufferStrategy**: 16-Entry FIFO Spatial-Region-Encoding fuer ICacheLine-Set-Prediction
4. **StaticVsDynamicFootprintRatio** als Telemetry: Bundle-Speedup correlations to ratio
5. **ThresholdedDivergenceDetection** im Algorithm 1: PRT-ART koennte aehnliche Heuristik fuer IFanout-Splitting nutzen

### 6. LUECKEN

- OFFEN: Hierarchical Prefetching fokussiert INSTRUKTIONS-Cache — Datenprefetcher (PRT-ART-Hauptfokus) nur INDIREKT relevant
- OFFEN: Bundle-Concept laesst sich auf Data-Pages uebertragen, aber Paper macht das nicht
- OFFEN: Wann ein neuer Bundle? Aenderung der Probability-Distribution braucht Trigger (P28 LRU Future Work)
- OFFEN: Kein Zusammenhang zu Cache-Coherence-Anti-Pattern (Single-Core-Setup im Paper trotz Server-Workload-Fokus)
- OFFEN: Cross-Core Metadata Sharing erwaehnt aber nicht detailliert (random core selection)

---

## P28 Kuehn, Biebert, Hakert, Chen, Teubner (2023) "Towards Data-Based Cache Optimization of B+-Trees"

### 1. CACHE-STRATEGIEN

**Cache Architecture Annahmen (Sektion 3):**
- Multi-Level Cache Hierarchy + TLB
- Lower Levels: nur queried bei Miss auf Upper Level
- Eviction: age-based (LRU-aehnlich, modern CPUs)
- Prefetching: Pattern-based, easily exploited = LINEAR ASCENDING ACCESS

**Test-Hardware (Sektion 5.1):**
- 2× Intel Xeon Gold 6230, 2.1 GHz, 20 Cores each
- L1D: 32 KB
- L2: 1 MB
- L3: 27.5 MB
- TLB Level 1: 64 entries
- TLB Level 2: 1536 entries
- 192 GB DDR4 RAM

**Tree-Sizes:**
- Node 4096B → 2.1 GB tree
- Node 256B → 2.7 GB tree (deeper, more nodes)
- 100M random keys, 8B key/8B payload

### 2. ALGORITHMUS-STRATEGIEN (inkl. TelemetryStrategy)

**Probabilistic Modeling (Sektion 4.1):**
- Per-Node Histogram: P_n_x = {p_ck1, p_ck2, ..., p_ckn}
- Counter pro Comparison Key, normalisiert nach Lookup-Set
- Idealisierende Annahme: P_future = P_past

**Hot Path Extraction (Sektion 4.2):**
- Greedy: root → highest-prob child → highest-prob child → ...
- Disjunkte Hot Paths (jeder Node in max. 1 Hot Path)
- Layout in linear ascending memory locations
- Erwartung: Hardware-Prefetcher erfasst die Pfad-Sequenz automatisch

**5 Layout-Strategien (Sektion 5.1):**

| ID | Name | Beschreibung |
|----|------|--------------|
| 1 | H | Hot Path: nur Hot-Path-Nodes neu mappen |
| 2 | NL | Native + Linear Search statt Binary Search |
| 3 | HL | Hot Path + Linear Search |
| 4 | HS | Hot Path + Sort: zusaetzlich verbleibende Nodes nach Read-Counter sortiert |
| 5 | HLS | Hot Path + Linear Search + Sort (BEST) |

**TelemetryStrategy-relevant - PerNodeCounter (Sektion 4.1):**
- Counter pro Comparison Key in JEDEM Knoten
- Sliding Window fuer Drift-Detection (in Future Work)
- Normalization: lazy (only on query)

**HOT PATH = STATIC im Paper P28 selbst!** Kuehn-Mail 2026-05-08 erweitert um:
- LeafOnlyCounter (NEU - nicht im Paper P28!)
- LeafOnlySampledCounter<N> (NEU)
- RetroactiveAggregation als Barriere (NEU)

### 3. SONDERMERKMALE

**Hauptbefund (Sektion 5.2, Fig. 3+4):**
- Best Variant HLS @ 256B nodes, 40 threads: 21% besser als NL (best non-remap), 50% besser als Native
- HLS @ 80 threads: 26% besser als best Native (4096B nodes)
- Linear Search BESSER als Binary Search bei Node-Sizes <1024B
- Bei Node-Size >1024B verschlechtert Linear Search die Performance (mehr Comparisons)

**Cache Hardware Effects:**
- L1D Miss Ratio: Native 0.42, HLS 0.30 (256B nodes) — gewinnt durch Layout
- STLB (2nd Level TLB) Misses: HLS und HS dramatisch reduziert
- 10000 Hot Paths: H/HL konvergieren mit HS/HLS → mehr Hot Paths machen Sortierung unnoetig

**NUMA-Limitation:**
- Single-threaded Remapping → first-touch policy auf Linux NUMA
- Bei >40 Threads: Memory auf einem NUMA-Node = costly remote access

### 4. PLATTFORM-MODELLIERUNG-BEZUG

| Bezug zu Saeule B | Detail |
|-------------------|--------|
| ICacheLevel | L1D/L2/L3 + 2 TLB-Levels explizit |
| ICacheTopology | 2× Xeon Gold 6230, 40 cores total (kein Cross-Socket-Test relevant) |
| ICacheResidency | Age-based Eviction (LRU-aehnlich, abstrakt im Paper) |
| ICoreLayout | 20 physical cores per CPU, 40 threads HT |
| IIsaFeatureSet | x86 (Cascade Lake-aehnlich) |
| IInterconnect | Inter-Socket implizit ueber NUMA |
| ILivePlatformModel | Linux 20.04, perf, Intel VTune fuer Telemetry |

**TLB-Bezug PROMINENT:**
- 1536 STLB Entries → bei kleinen Nodes nicht ausreichend
- Hot Path Layout reduziert STLB Misses massiv (Fig. 4a)
- "TLB als last-layer-coarse-managed-cache" Abstraktion explizit (Sektion 3)

### 5. VERALLGEMEINERUNGS-VORSCHLAEGE (fuer PRT-ART)

**Direkt aus Paper:**
1. **HotPathLayoutStrategy**: Linear-Ascending-Memory + ICacheStrategy.greedy(highest_prob_child)
2. **PerNodeHistogramTelemetry** (PerNodeCounter): Counter pro Comparison Key
3. **NodeSizeStrategy**: 256B als Sweet Spot fuer cache-friendly + linear-search-kompatibel
4. **LinearSearchInNode** als ISearchPageStrategy fuer Nodes <1024B

**NEU 2026-05-08 (Kuehn-Mail Erkenntnisse):**
5. **LeafOnlyCounter** als Achse 11 TelemetryStrategy:
   - Counter NUR auf Leaf-Pages (vermeidet Cache-Coherence Storm auf Root)
   - Aggregation retroactive ueber sampling
6. **LeafOnlySampledCounter<N>**: Sampling 1/N reduziert Schreib-Frequenz
7. **RetroactiveAggregation als BARRIERE**: Periodisch (nach N Queries) wird Counter-Stand vom Leaf zur Root propagiert
8. **ProbabilityHintsHeader** (PRT-ART eigen): Lookup-Hints in IRootPage / IFanout-Header — vermeidet Histogram-Pflege im hot path

**Drift-Detection Strategy (Future Work P28):**
9. **SlidingWindowDriftDetection** als Telemetry: Erkenne Verteilungs-Drift, trigger Re-Layouting

### 6. LUECKEN

- OFFEN: Paper P28 ist STATISCH — Re-Layouting at Runtime in Future Work
- OFFEN: Per-Node-Counter mit Cache-Coherence-Storm-Risiko nicht adressiert (User-Erkenntnis 2026-05-08!)
- OFFEN: Insert/Update-Performance NICHT evaluiert (nur Reads, 200M Operations Zipf 0.99)
- OFFEN: Optimal Number of Hot Paths empirisch (10/100/1000/10000 getestet, kein Algorithmus)
- OFFEN: Concurrent Re-Layouting waehrend Lookup-Workload nicht behandelt
- OFFEN: Memory-Allocator Overhead beim Remap (single-threaded) nicht modelliert

---

## QUERVERWEISE / SYNTHESE

### Telemetry-Konzepte ueber mehrere Paper

| Telemetry-Konzept | P24 | P25 | P26 | P27 | P28 |
|-------------------|-----|-----|-----|-----|-----|
| Per-Node/Block Counter | - | - | **PathReadCounter** | Compression Buffer (per-region) | **PerNodeHistogram** |
| Reuse-Distance | **Reuse Distance Analysis** | - | - | Long-Reuse Misses | implicit |
| Coverage/Overprediction | **Coverage% / Overpred%** | (FB_FULL Counter) | - | **Accuracy/Coverage Tab.2** | - |
| Hot Path Detection | implicit (PC streams) | - | **Prefetch Table mit hot Pfaden** | **Bundle Identification** | **Hot Path Extraction** |
| Sliding Window / Drift | - | - | Forgetting Factor w | - | Future Work |
| Performance Counter (Hardware) | implicit | **L1D_PEND_MISS.FB_FULL** | - | gem5 measurements | perf + VTune |
| Sampling-based Telemetry | - | - | Round-Robin Stage 2 | - | (LeafOnlySampledCounter NEU 2026-05-08) |
| Spatial-Region Encoding | SMS PHT | - | - | **Compression Buffer 32-block bitvec** | - |
| Histogram per Node | - | - | per-Block (= per-Page) | - | **per-Node mit Comparison Keys** |

**Konvergenz:** P26 (PathReadCounter), P28 (PerNodeHistogram), P27 (Compression Buffer Spatial Region) und PRT-ART eigene LeafOnlyCounter-Idee bewegen sich alle auf coarse-grained Telemetry zu, mit Reduktion der Coherence-Pressure.

### Cache-Coherence-Probleme (relevant fuer Saeule B IInterconnect)

**P24 explizit**: Multi-Core 16-core Directory-Based Shared L2 mit Coherence-Energiekosten — aber NICHT detailliert pro Counter-Kategorie. Coherence-Energie als 100× Multiplier (Tab. 3) offenbar aggregiert.

**P25 explizit**: CHA (Caching/Home Agent) explizit modelliert (Fig. 2). Cross-Socket-Latenz dominant: EPYC-3 local 83ns / remote 272ns; Grace local 181ns / remote 760ns. False Sharing implizit ueber FB-Slot-Allocation.

**P26 implizit**: Counter-Updates IM Block (initial Approach) wuerde False Sharing erzeugen (Cascade Updates) — Loesung: Separate Counter Block. Worker Thread baut Index async.

**P27 explizit**: Cross-Core Metadata Sharing erwaehnt ("share Metadata Buffer across multiple cores and randomly select one core to generate the instruction history"). Effekt offenbar wirksam fuer reduction Metadata-Volume ohne Performance-Compromise.

**P28 implizit**: Per-Node-Counter mit POTENZIELL massivem False Sharing auf Root-Pages bei concurrent Updates — User-Erkenntnis 2026-05-08 erkannte dies als Anti-Pattern, fuehrt zu LeafOnlyCounter.

**SAEULE B IInterconnect-Implikation:**
- ILivePlatformModel.cohrencyPressure = function(numCores, sharedCounters)
- IPinningPolicy muss Counter-Cores beruecksichtigen (write-mostly Cores nicht cross-socket)
- IBusTopology bestimmt Update-Latenz pro Counter-Increment

### Verbindung zu Kuehn-Erkenntnissen 2026-05-08

| PRT-ART Achse 11 Konzept | Paper-Bezug | Status |
|---------------------------|-------------|--------|
| **PerNodeCounter** mit Cache-Coherence-Anti-Pattern-Warnung | P28 (PerNodeHistogram) DIREKTE Quelle — aber P28 erkennt die Coherence-Falle NICHT explizit | PRT-ART eigene Erkenntnis |
| **LeafOnlyCounter** (NEU 2026-05-08) | KEINE Paper-Quelle (echte PRT-ART-Innovation) | Generalisiert P28 PerNodeCounter |
| **LeafOnlySampledCounter<N>** (NEU 2026-05-08) | Sampling-Idee in P26 Round-Robin (Stage 2) und implizit in P27 Compression Buffer (16-entry FIFO) | Erweiterung |
| **RetroactiveAggregation** (NEU 2026-05-08, BARRIERE) | P26 Worker-Thread baut Index periodisch (asynchron) | Konzeptuell verwandt |
| **PathReadCounter** | P26 DIREKT (Kapitel 3.2.2) | Etabliert in Literatur |
| **ProbabilityHintsHeader** (PRT-ART eigen) | Verwandt zu P27 Bundle-Entry-Tags in ELF | Konzept-Innovation |

**KRITISCHE BEOBACHTUNG:** P28 (Kuehn 2023) ist die DIREKTE QUELLE fuer PerNodeCounter, aber Kuehn-Mail 2026-05-08 (Erweiterungen) ist NICHT IM PAPER P28 dokumentiert! Diese Konzepte (LeafOnly, RetroactiveAggregation) sind PRT-ART-Innovation auf Basis Kuehn-Korrespondenz.

### Cache-Strategie-Hierarchie (mapping zu Saeule A ICacheStrategy = VISITOR)

```
ICacheStrategy (VISITOR)
├── BaseEngineStrategy
│   ├── NoPrefetch (Baseline aus P28 Native)
│   ├── LinearSearchOnly (P28 NL)
│   └── BinarySearchOnly (P26/P28 Default)
└── CacheEngineStrategy
    ├── CachePrefetching (P26 CP — Cache-Lines im Knoten)
    ├── PathPrefetching (P26 PP — Pfad-Knoten)
    ├── MonitorPrefetching (P26 MP — adaptive via Telemetry)
    ├── HotPathLayoutStrategy (P28 H/HS/HLS)
    ├── CoroutineFullNode (P25 Coro Full Node)
    ├── CoroutineHalfNode (P25 Coro Half Node)
    ├── BundlePrefetchStrategy (P27 — fuer Instruction!)
    └── JumpPointerPrefetch (P26 — fuer Version Chains)
```

### Plattform-Modell-Konvergenz (Saeule B)

ALLE 5 Paper konvergieren auf:
- **ICacheLevel** mit konkretem L1/L2/L3-Setup
- **ICacheLine** 64B Standard (Ausnahme A64FX 256B)
- **IInterconnect** explizit (CHA in P25, Directory in P24, NVLink in P25 Grace)
- **IMemoryBandwidthModel** heterogen (DDR4/HBM/LPDDR/CXL)

**Plattform-Telemetry-Konvergenz:**
- **Hardware Performance Counter** als ground truth (P25 L1D_PEND_MISS.FB_FULL, P28 perf+VTune, P26 implizit)
- **gem5 Simulation** fuer Architekturforschung (P27)
- **Coverage/Overprediction Metrics** als Cross-Paper Standard (P24, P27)

### Negative Befunde-Zusammenfassung

| Paper | Negativer Befund | Implication fuer PRT-ART |
|-------|-------------------|--------------------------|
| P24 | History-basierte Prefetcher SCHADEN Scale-Out (negative Coverage ISB) | NegativPredictionStrategy mit Disable-Trigger |
| P25 | STRONG Reliability + grosse Nodes → Performance-DEGRADATION | FBSizeAwareLimiting mandatory |
| P26 | Bei stark skewed Zipfian sinkt Vorteil; Range-Scan <30 keys | StrategyFallback bei Zipfian-Detection |
| P27 | Andere Prefetcher zerfallen bei Distance >4-6 | Coarse-grained Bundles (Distance 90) |
| P28 | Native Layout schlecht bei kleinen Nodes (TLB pressure) | TLB-aware Layout Strategy mandatory |

### Architektur-Bezugs-Zusammenfassung

**Saeule A — Direkte Mapping:**
- `ISearchPagesStrategy` ⇔ `Path Prefetcher` (P26) + `Hot Path Strategy` (P28)
- `ISearchPageStrategy` ⇔ `Cache Prefetching innerhalb Node` (P26 CP) + `Linear/Binary Search` (P28)
- `ICacheStrategy = VISITOR` ⇔ `Coro Full/Half Node` (P25)
- `ICachePage[s]` mapping ⇔ `Compression Buffer Spatial Regions` (P27)

**Saeule B — Direkte Mapping:**
- `ICacheLevel` ⇔ Tab. 1 in P26+P27, Tab. 1 in P25
- `ICacheLine` ⇔ 64B/256B-Setup explizit
- `IInterconnect` ⇔ CHA (P25), Directory (P24), NVLink-C2C (P25)
- `IMemoryBandwidthModel` ⇔ DDR4/HBM/LPDDR-Heterogenitaet (P25)
- `IScheduler / IHeuristic` ⇔ Bundle Threshold (P27), w_Forgetting (P26)

**Achse 11 TelemetryStrategy — Konkrete Realisierungen:**
- `PerNodeCounter` ⇔ P28 (mit COHERENCE-FALLE-Warnung)
- `LeafOnlyCounter` ⇔ NEU 2026-05-08, generalisiert P28 + reduziert P24-Energiekosten
- `LeafOnlySampledCounter<N>` ⇔ NEU 2026-05-08, kombiniert P26 Round-Robin Sampling + P28 Counter
- `RetroactiveAggregation` ⇔ NEU 2026-05-08, kombiniert P26 Worker-Thread + P28 Layout-Refresh — **BARRIERE zwischen Online/Offline-Phase**
- `PathReadCounter` ⇔ P26 (etabliert)
- `ProbabilityHintsHeader` ⇔ PRT-ART eigen, verwandt zu P27 Bundle-Tags

---

## OFFENE FRAGEN FUER DIPLOMARBEIT 2026-05-08

1. OFFEN: Welche Coherence-Effekte ergeben sich konkret bei PerNodeCounter auf Root-Pages? Quantifizierung fehlt in allen 5 Papern.
2. OFFEN: Wie haeufig muss RetroactiveAggregation triggern, um Drift zu erfassen ohne Layout-Thrashing?
3. OFFEN: Kann PRT-ART JumpPointerQueue (P26) auf Saeule A IFanout uebertragen?
4. OFFEN: Lassen sich Bundles (P27) auf data-centric ISearchPages mappen?
5. OFFEN: PRT-ART ProbabilityHintsHeader vs. P28 Hot-Path-Layout — welche Synergie/Konflikte?
6. OFFEN: NUMA-Pinning-Strategie fuer Worker-Threads (Counter-Builder) — keine der 5 Paper adressiert dies.
