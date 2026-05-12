# REV5.2 — State-Pattern + Visitor-Pattern: Per-Paper Extraktion (P01–P33)

> Tieflektuere ALLER 33 Forschungspaper mit Fokus auf:
> A) Plattform-Zustaende, B) State-Transitions, C) Mess-/Monitor-Mechanismen,
> D) Visitor-aehnliche Strukturen, E) Empfehlungs-/Allokations-Rueckgaben.
>
> Quelle: cluster_A_trie.md, cluster_B_hybrid_bplus.md, cluster_C_layout_theorie.md,
> cluster_D_prefetching_1.md, cluster_E_prefetching_telemetry.md, cluster_F_sync_tud_habich.md.
>
> Architektur-Kontext: ICacheEngine mit 12 internen C-Familien (C1 Layout, C2 Pinning, C3 Prefetch,
> C4 Coherence, C5 Telemetry, C6 Allocation, C7 Migration, C8 Encoding, C9 Heuristik, C10 Topologie,
> C11 Scheduler, C12 Filter). State-Pattern ueber Plattform-Zustaende; Visitor zurueck an
> ISearchPageStrategy mit Optimierungs-Hinweisen + ggf. Speicher-Allokation.

---

## CLUSTER A — TRIE-FAMILIE

### P01 ART (Leis/Kemper/Neumann 2013)
- **A) Zustaende:** `Node-Population-Bucket ∈ {≤4, ≤16, ≤48, ≤256}`; `Cache-Residency ∈ {hot, cold}` (effective cache size 192 KB→12 MB Tabelle); `Branch-Predictor-State` (0.85 mispredictions/lookup bei Sparse).
- **B) Transitions:** `Node4 → Node16 → Node48 → Node256` bei Insertion-Wachstum; Reverse bei Shrink. `Lazy-Expansion → Path-Compressed` bei singulaerem Pfad. Keine Concurrency-Transitionen.
- **C) Monitor:** L3-Hits/Misses pro Lookup explizit (Tab. III); branch-misprediction-Profil; Effective-Cache-Size als Tunable. KEIN Live-Probing.
- **D) Visitor-Strukturen:** `findChild`-Strategie dispatched per `node.type` (Node4 linear, Node16 SSE-SIMD, Node48 indirekt, Node256 direkt) — KLASSISCHES VISITOR. Jede Node-Variante = ConcreteVisitor.
- **E) Rueckgaben an Strategy:** "Wechsle Layout zu groesserem Node-Typ", "nutze SIMD-Pfad", "tagged-pointer statt Leaf-Knoten" (1-Bit-Tag spart Allokation).

### P02 HOT (Binna et al. 2018)
- **A) Zustaende:** `Compound-Node-Layout ∈ {Single-Mask 8/16/32, Multi-Mask 8/16/32}` (9 Varianten); `Concurrency-State ∈ {free, locked, validating, obsolete}`; `Cache-Line-Slot ∈ {first-4-prefetched, others}`.
- **B) Transitions:** `Insert`: NormalInsert → LeafPushdown → ParentPullUp → IntermediateNodeCreation. `Sync`: 5-Phasen-Insert (determine-affected → bottom-up-lock → validate → perform+obsolete → top-down-unlock). Layout-Switch: kleinste-passende-Variante.
- **C) Monitor:** Skalierungsdaten 1-10 Threads; Mean-Depth-Vergleich; Ueberlappung Cache-Load + Pointer-Tag-Decoding via Pointer-Tagging.
- **D) Visitor-Strukturen:** `searchPartialKeys` mit AVX2 (`_mm256_cmpeq_epi8`) — Visitor pro Layout-Variante. Pointer-Tag-Dispatch ist explizites Visitor-Pattern (Type-Bits in LSB des Pointers).
- **E) Rueckgaben:** "Prefetche erste 4 Cache-Lines", "wechsle zu Multi-Mask wenn diskriminative Bits >64", "verwende AVX2-Pfad", "epoch-basierte Reclamation" (Allokations-Hint).

### P04 CoCo-trie (Boffa et al. 2024)
- **A) Zustaende:** `Encoding ∈ {EF, PA, BV, DE}` pro Macro-Node; `Topology ∈ {LOUDS, DFUDS}`; `Local-Alphabet-State` (subset des globalen); `Word-Size-Bound-State` (l ≤ w/log σ).
- **B) Transitions:** Statisch (rebuild-only) — kein Runtime-Switch. Bei Bauzeit DP: pro Knoten Auswahl `l*(v) = argmin C(v_l) + Σ C*(d)`.
- **C) Monitor:** Bauzeit O(N h^2); Space-Cost-Funktion; KEINE Runtime-Telemetry (statisch).
- **D) Visitor-Strukturen:** `EncodingSelectionStrategy` ist klassischer Visitor (Pool {EF, PA, BV, DE}). LOUDS-vs-DFUDS-Topology als 2 Visitor-Klassen.
- **E) Rueckgaben:** "Verwende EF-Encoding bei monotoner Sequenz", "DE bei consecutive characters", "lcp-subtraction reduziert Universum", "alpha-Parameter erlaubt Space/Time-Trade-off".

### P05 START (Fent/Jungmair/Kipf/Neumann 2020)
- **A) Zustaende:** `Cache-Cost-Class ∈ {Cached, HeaderCached, Uncached}` (Tabelle I); `Cache-Level-State ∈ {L1, L2, L3, RAM}` mit Latenzen; `Page-Sharing-State ∈ {shared-physical, unshared}` (rewiring); `Multi-Level-Replacement-State` (Bellman-DP-Output).
- **B) Transitions:** `Self-Tuning-Trigger ∈ {>10% data changed, VACUUM}`. Re-Layout offline. Page-Collision → unsharing.
- **C) Monitor:** **CLFLUSH-basierte Cache-Cost-Messung** + LFENCE als Speculation-Barrier — DIREKT auf Target-Hardware. Live-Probe!
- **D) Visitor-Strukturen:** `CacheCostBasedNodePlacementHeuristic` als Visitor. `BellmanDPNodeOptimizer` — DP traversiert Knoten, akkumuliert Cost-Vector pro Multi-Level-Wahl.
- **E) Rueckgaben:** "Ersetze i Knoten durch Multilevel-Knoten der Tiefe i wenn benefit > 0", "alloziere via memfd_create + mmap shared", "verwende CLFLUSH-gemessene Cost statt statische Annahme". Allokations-Strategie ist eingebaute Komponente.

### P09 Jacobson LOUDS (1989)
- **A/B/C:** Bit-String-Position + Rank-Select-Block-State; statische Struktur, keine Transitionen; Cell-Probe-Metric (bit-inspections) statt cycles.
- **D) Visitor:** rank/select-Primitive — Visitor pro Encoding (LOUDS, DFUDS, BP).
- **E) Rueckgaben:** Implizit: "popcount-Hardware wenn verfuegbar", "Block-LUT-Sizes aus rank/select-Tabellen".

### P10 SuRF (Zhang et al. 2018)
- **A) Zustaende:** `Layer-Tier ∈ {hot upper (LOUDS-Dense), cold lower (LOUDS-Sparse)}`; `Cutoff-Level R = 64`; `Filter-Variant ∈ {SuRF-Base, SuRF-Hash, SuRF-Real, SuRF-Mixed}`; `FPR-State` (one-sided).
- **B) Transitions:** Statisch (rebuild-only). Cutoff-R steuerbar fuer Space-Time-Trade-off.
- **C) Monitor:** False-Positive-Rate gemessen; Cache-Line-Size 64B als Block-Granularitaet (B=64 Dense, B=512 Sparse).
- **D) Visitor-Strukturen:** Visitor pro Layer (Dense vs Sparse); `OneSidedErrorFilterStrategy` als Visitor; SIMD-Label-Search (`_mm_cmpeq_epi8`) Visitor.
- **E) Rueckgaben:** "Prefetche positional-correspondence-Sequenz", "verwende popcount fuer rank-Block", "wechsle Suffix-Encoding auf Hash bei Point-Query, Real bei Range-Query".

---

## CLUSTER B — HYBRID + B+

### P03 Masstree (Mao/Kohler/Morris 2012)
- **A) Zustaende:** `Layer-Tiefe h` (Trie-of-B+); `Border-Node-Permutation-State` (atomarer 64-Bit Counter); `Version-State` (locked / inserting / splitting / deleted, 7-Bit vinsert + 18-Bit vsplit); `Concurrency-State` (Reader optimistic, Writer hold spinlocks).
- **B) Transitions:** `Sequenzial-Insert-Detected → empty-half-Optimization`; `Conflict bei kollidierendem 8h-Praefix → next_layer-Erstellung`; Hand-over-Hand-Locking traversiert Versionen.
- **C) Monitor:** DRAM-Stall-Time waechst mit Cores (2050→2800 cycles); NUMA-Sensitivity (1.5x bei hard-partitioning); Linear-vs-Binary-Search-Architektur-abhaengig.
- **D) Visitor-Strukturen:** `SliceLayeredTrieB+Pattern` ist 2-Stufen-Visitor (Trie + B+ pro Layer). `AtomicPermutationInsertStrategy` als Concurrency-Visitor.
- **E) Rueckgaben:** "Prefetche ALLE 4 Cache-Lines des Knotens parallel" (PrefetchAllLinesStrategy), "verwende lineare Suche auf Intel" (Plattform-bedingt), "kein-Schreib-auf-shared-Cacheline-Garantie".

### P06 B^2-Tree (Schmeisser et al. 2022)
- **A) Zustaende:** `Page-Internal-Tree-State` (Decision-Node, Span-Node, Virtual-Min/Max-Edge); `Skip-Field-LCP-Length`; `Concurrency-State ∈ {OLC-validating, OLC-restart}`; `Range-Array-Indirection-State`.
- **B) Transitions:** Bei Page-Split: rekursive embedded-Tree-Konstruktion. `Common-Prefix > 0 → Span-Node, sonst Decision-Node`. OLC: Reader-Validierung-Fehler → restart.
- **C) Monitor:** L1D-Misses (38.32 vs 44.63), LLC-Misses ~halbiert; Hyperthread-Sensitivity (rel. speedup steigt jenseits physical cores).
- **D) Visitor-Strukturen:** ZWEI Visitor pro Page (Decision + Span = Heterogene `ISearchPagesStrategyPattern`); `RecursiveCommonPrefixDecomposition` als Builder-Visitor.
- **E) Rueckgaben:** "Vergleiche bytewise im Decision-Node", "skip die Praefix-Bytes", "verwende Sub-Range mit ~32 Eintraegen vor Binary-Search".

### P07 Wormhole (Wu/Ni/Jiang 2019)
- **A) Zustaende:** `Phase ∈ {MetaTrieHT-Lookup, MetaTrie-Walk, pointSearchLeaf}`; `Tag-Match-State` (16-bit CRC32 vorab); `Fat-Leaf-Overflow-State`; `Concurrency-Klasse ∈ {Lookup-RCU, Single-Leaf-RW, Split-Mutex}`.
- **B) Transitions:** Phase 1 → 2 → 3 in Lookup; bei Anchor-Konflikt → Fat-Leaf; Smart-Split-Heuristik bestimmt Anchor-Laenge minimal.
- **C) Monitor:** Search Cost O(log L) statt O(log N); Versionsnummern-Detection von stale state; Hyperthreading disabled fuer Messung; Tag-Vergleiche (1-3 statt 6-7).
- **D) Visitor-Strukturen:** `MultiStrategySearchPage` mit drei Sub-Visitors (Hash + Trie + LinkedList). `AnchorKeyStrategy` als Constraint-Visitor.
- **E) Rueckgaben:** "Speculative DirectPos = T*k/Tmax bei uniform Hash", "verwende incremental CRC32-Hashing", "lange-Sicht-Cache-Line-Slot mit 8 Praefixen".

### P11 CSS-Tree (Rao/Ross 1999)
- **A/B/C:** Node-Size=Cacheline; Pointer ∈ {explicit, arithmetic-eliminated}; statisch (rebuild only); Cache-Simulator zur Validierung; 350 MB/s Memory-Bandwidth.
- **D) Visitor:** HardcodedBinarySearch; Full-CSS vs Level-CSS.
- **E) Rueckgaben:** "Knoten-Groesse = Cache-Line-Size", "Child-Adresse via b(m+1)+i statt Pointer", "unrolle Loop bei m=2^t".

### P12 CSB+-Tree (Rao/Ross 2000)
- **A/B/C:** NodeGroup ∈ {Full-pre-alloc, segmented, dynamic}; CodeVariant ∈ {basic, uniform, variable}; Lazy-Deletion-Mark; Insert-Split-Pfad pro Variante; perfmon Cache-Misses.
- **D) Visitor:** 3 Hardcoded-Search-Varianten; Segmented vs Full Pattern-Visitor.
- **E) Rueckgaben:** "Uniform fuer branch-free predicted", "Space-bound + Updates → Segmented; sonst Full".

### P13 Hankins/Patel (2003)
- **A) Zustaende:** `Node-Size-Class ∈ {32B, 256-512B, 1696B}`; `Branch-Misprediction-State`; `TLB-Miss-State`; `Speculative-Execution-State`.
- **B) Transitions:** Statisch — Cost-Model bestimmt optimal-node-size pro Plattform. KEIN Runtime-Switch.
- **C) Monitor:** PAPI-Counter zur Hardware-Counter-Messung; Cardenas-Formula `X_D(λ,q) = λ(1-(1-1/λ)^q)` als steady-state-Model; vollstaendige Plattform-Tabelle (cpi=0.63, lsz=32, miss_latency=75, page_sz=4096, tlb_cap=64, tlb_penalty=75, pred_penalty=15).
- **D) Visitor-Strukturen:** Cost-Model `t = I*cpi + M*miss_latency + B*pred_penalty + T*tlb_penalty` ist ein 4-Parameter-Visitor. ICostModel als Composite-Visitor.
- **E) Rueckgaben:** **Erstes Paper mit echtem Cost-Model-Output:** "optimale Node-Size bei 8 Cache-Lines", "TLB-Miss-Penalty einbeziehen", "branch-prediction-aware between linear/binary".

---

## CLUSTER C — LAYOUT-THEORIE

### P14 Samuel/Pedersen/Bonnet (2005) — Processor-conscious CSB+
- **A/B/C:** KeySize (8B/16B), NodeSize ∈ {≤384B linear, >384B binary}, Search ∈ {linear, binary, loop-unrolled}, Itanium-EPIC in-order; statisch via Configuration-Table-Lookup; Branch-Mispredictions als Hauptmetrik (Configuration-Experiment).
- **D) Visitor:** ConfigurationTableHeuristic mit (KeySize, NodeSize, SearchStrategy) → optimal; Itanium-Software-Prefetch.
- **E) Rueckgaben:** "Linear ≤384B", "Prefetch naechstes Level VOR Suche", "Range-Scan: 2 voraus", "Insert-Optimum ≠ PointQuery-Optimum".

### P15 Graefe/Larson (2001) — Survey
- **A/B/C:** Survey listet ALLE Cache-Strategien (Alignment, Compression, KeyForm, Layout, Prefetch, Recursive, Temporal); StrategyCompatibilityMatrix impliziert; Cache-Coherency-Cost (Latch-Pingpong); 5-Level-Memory-Hierarchie.
- **D) Visitor:** Sub-Search vor eigentlicher Suche (Poor-Man's-Keys-Visitor).
- **E) Rueckgaben:** "Code-Cache als ITemporalCacheStrategy", "MicroServer-Threading mit IPinningPolicy", "Software-Prefetch fuer Multi-Line-Pages".

### P16 Bender/Demaine/Farach-Colton (2002) — Probability-Weighted Layout
- **A/B/C:** RootBlock (connected subtree); ProbabilityDistribution Leaves; BlockSize ∈ {known/cache-aware, unknown/cache-oblivious}; Greedy iterativ adjacent+max-prob; Smooth-Cost-Modell; Schranken (B-1)/B / 1/ε / 4×.
- **D) Visitor:** `IAccessProbabilityDistribution` (Uniform/HeavyTail/Empirical/Learned).
- **E) Rueckgaben:** "Heavy-tail → Greedy", "unknown B → Cache-Oblivious", "B-faktorielle Savings bei Skew".

### P17 Bender/Demaine/Farach-Colton (2005) — Cache-Oblivious B-Trees
- **A/B/C:** vEB-Layout (rekursiv Top/Bottom); PMA-Density (τ_k, ρ_k); 3-stufiges Indirection-Layer; Ghost-Element-Marker; PMA-Rebalance bei Density-Verletzung; Memory-Transfers O(1+log_{B+1} N).
- **D) Visitor:** Layout als Visitor (vEB statisch); Indirection-Layer als 3-stufiger Composite.
- **E) Rueckgaben:** "vEB optimal auf JEDEM Cache-Level innerhalb Konstanten-Faktor", "PMA fuer dynamic + scan-friendly", "Buffer-Nodes vs Indirection-Layer".

### P18 Saikkonen/Soisalon-Soininen (2008) — Cache-Sensitive Multi-Level Layout
- **A/B/C:** Cache-Level i mit B_i; Block-Path-Length P_i; Aliasing ∈ {conflict-free, set-thrashing}; BFS-Border-Queue; statische Konstruktion via BFS-Greedy; AliasingCorrection als Adresse-Permutation; TLB als Cache-Level mit 4096B.
- **D) Visitor:** BFSGreedyMultiLevelLayout (Builder); AliasingCorrection (Address-Permutation).
- **E) Rueckgaben:** "Layout fuer alle k Levels gleichzeitig", "Aliasing-Correction bei d-way", "Cache-Oblivious als Special Case B_i=(2^{2^i}-1)·B_0".

### P19 Saikkonen/Soisalon-Soininen (2016) — Local Relocation Dynamic
- **A/B/C:** Layout-Invariant alpha-tunable; Broken-Set (1-6 pro Modifikation); 7 Faelle: Ext-/Int-Insert / Leaf-/NonLeaf-Delete / Single-/Double-Rotation; Invariant-Repair via FIX-BROKEN; TPC-C 26-30% Improvement.
- **D) Visitor:** LocalRelocationLayout (Maintenance); IAdaptationTrigger ∈ {OnStructMod, OnDegradationThreshold, Periodic, Manual} als Composite.
- **E) Rueckgaben:** "Move broken b zu Nachbar mit freiem Slot", "force-Allocate neuen Cache-Block", "kombiniere local + periodic global".

---

## CLUSTER D — PREFETCHING 1

### P20 Mueller/Benson/Leis (2025) — B-Trees Are Back
- **A) Zustaende:** `LeafLayout ∈ {Comparison, Fingerprinting, SDL, FDL}`; `Heads-Quality-State ∈ {bad ≤16, good ≤64 unique}`; `Operation-Counter ∈ {0,1,2,3}` (saturating); `Boundary-Node-State` (sequential-insert-detected).
- **B) Transitions:** **KEY-Adaption**: Layout-Wahl bei Splits/Merges basierend auf good/bad heads + String-Detektion. **Operation-Adaption**: Counter +1 bei Scan (15% prob), -1 bei Point-Op (5% prob), saturating 0..3, Counter <2 → Fingerprinting. **Layout-Konversion** zwischen 4 Layouts entlang partieller Ordnung (Fig. 12).
- **C) Monitor:** Per-Leaf Counter (1 Byte); Probabilistic Sampling der Operation-Type; vmcache-Integration mit Optimistic-Lock-Coupling.
- **D) Visitor-Strukturen:** `AdaptiveLeafSelectorStrategy` ist KLASSISCHES STATE-PATTERN: 4 Leaf-Layouts als ConcreteState. `IAdaptiveCacheStrategy<TPolicy>` mit KeyAdaptionPolicy + OperationAdaptionPolicy als orthogonale Visitor.
- **E) Rueckgaben:** "Konvertiere zu Fingerprinting wenn Counter <2", "verwende SDL/FDL bei Dense Keys", "PartitionedSequentialInsertStrategy: max split point statt Median", "16 Hints (64 Bytes Budget)".

### P21 Chen/Gibbons/Mowry (2001) — Prefetching B+-Trees
- **A) Zustaende:** `Node-Width w` (Cache-Lines); `Memory-Bandwidth B = T1/T_next` (= 15 Compaq ES40); `Prefetch-Distance k = ⌈B/w⌉`; `Chunk-Size c = ⌈B/(2m)⌉`; `Jump-Pointer-Array-State ∈ {external-chunked, internal-bottom-non-leaves}`.
- **B) Transitions:** Range-Scan: Startup → Steady-State → Chunk-Boundary-Crossing-Prefetch.
- **C) Monitor:** Total-Stall-Time-Equation (Eq. 1) als analytisches Cost-Model; T1=150 cycles, T_next=10 cycles (Compaq ES40).
- **D) Visitor-Strukturen:** `WideNodePrefetchStrategy` und `JumpPointerScanStrategy` als 2 Visitor; `PointerChasingResolutionStrategy` mit Tactic-Pattern (DataLinearization vs HistoryPointer).
- **E) Rueckgaben:** "w_optimal = 8 Cache-Lines fuer typische Parameter", "k=2-3 Prefetches voraus", "Internal-vs-External-Jump-Array nach w/k-Verhaeltnis", "Wider-Nodes verbessern UPDATE Performance (gegen Intuition)".

### P22 Chen et al. (2002) — Fractal Prefetching B+-Trees
- **A/B/C:** GranularityTier ∈ {Cacheline, Page, Disk}; Mode ∈ {Disk-First, Cache-First}; Mismatch + Overflow-Pages; Two-Granularity-Insert mit Cache-/Page-Split; Tier-Latencies T1+T_next+Disk-Seek+Page-IO.
- **D) Visitor:** IFractalLayoutStrategy<Outer,Inner> rekursiv; IGranularityMismatchResolver (Overflow/OffsetCompression/AdaptiveNodeSize).
- **E) Rueckgaben:** "Disk-First fuer Insert/Update-heavy", "Cache-First fuer Search-heavy", "DualJumpPointerArray: Internal Cache-Tier, External I/O-Tier".

### P23 Khan (2010) — Dynamic Adaptation Cache Prefetching
- **A) Zustaende:** `Compile-Time-Template-State` (mit Konstanten A, B); `Runtime-Specializer-State`; `Cost-Benefit-Gate ∈ {ON, OFF}` (Equation 4); `Affine-Distance I = O*A+B`.
- **B) Transitions:** **3-Phasen-Pipeline:** (1) Compile-Time Analysis → (2) Runtime-Specialization (Modify-Add bei Itanium-II) → (3) Online-Distance-Adaptation (Loop-Iteration-Counter). State-Switch wenn `sum(L_{1,i}) > R`.
- **C) Monitor:** **Hardware-Performance-Counters** zur Loop-Iteration-Latency-Messung; CMRF (Cache-Miss-Reduction-Factor) bis zu 88%; Overhead 1.5-6.5%.
- **D) Visitor-Strukturen:** `IRuntimeAdaptiveHeuristic` als Live-Visitor mit `getCurrentLatency() / computeOptimalDistance() / shouldPrefetch()`. **Direkt mappbar auf DecisionLambdaTree-Knoten.**
- **E) Rueckgaben:** "O_r = MissLatency / IterLatency als optimale Distance", "Modify 2-5 Instructions pro Variable zur Laufzeit", "Cost-Benefit-Gate disable wenn Overhead > Profit".

---

## CLUSTER E — PREFETCHING 2 + TELEMETRY

### P24 Naderan-Tahan/Sarbazi-Azad (2016) — "Why Does Data Prefetching Not Work"
- **A) Zustaende:** `Workload-Type ∈ {Cache-friendly, Prefetch-friendly, Scale-Out}`; `Coverage-State ∈ {positive, negative}`; `Reuse-Distance-Class`; `Spatial-Locality-Degree`.
- **B) Transitions:** Negative-Befund: Prefetcher → Cache-Pollution → schlechtere Performance. **NegativPredictionStrategy mit Disable-Trigger**.
- **C) Monitor:** Coverage% / Overprediction% pro Prefetcher-Variante; Reuse-Distance-Histogramm; Sequitur-Algorithmus zur Time-Dimension-Analyse; CACTI+McPAT fuer Energie.
- **D) Visitor-Strukturen:** 5 Hardware-Prefetcher-Varianten als Visitor (NLP, Stream, GHB-PC/DC, ISB, SMS). **Negative-Coverage-Visitor**: Disable wenn Coverage<0.
- **E) Rueckgaben:** "DEAKTIVIERE Prefetch wenn Workload Scale-Out", "WorkloadTypeStrategy basierend auf miss-ratio<0.5%", "Energie-aware-Heuristik (10-100x mehr Memory-Requests bei marginal Coverage)".

### P25 Mahling/Weisgut/Rabl (2025) — "Fetch Me If You Can"
- **A) Zustaende:** `Prefetch-Locality ∈ {T0, T1, T2, NTA}` (x86) / `{KEEP, STREAM} × {L1, L2, L3}` (ARM); `FB-Reliability ∈ {WEAK, STRONG, KONFIGURIERBAR}`; `FB-Slot-Utilization` (Fill-Buffer-Capacity 10-24); `Granularity ∈ {Half-Node, Full-Node}`.
- **B) Transitions:** **Coro Full-Node ↔ Half-Node** Switch; bei FB_FULL Counter > Threshold → Reduce-Granularity. **Plattform-Detection-Phase**: Microbenchmark zur FB-Reliability-Erkennung.
- **C) Monitor:** **L1D_PEND_MISS.FB_FULL Performance-Counter** (Xeon-3) als Runtime-Telemetry. Microbenchmark-Detection: Batch-Prefetch + sequential Access mit Data-Dependency, Threshold-Detection bei Batch-Size > FB.
- **D) Visitor-Strukturen:** `PrefetchReliabilityStrategy` als Plattform-State-Visitor; **TwoGranularityPrefetchVisitor** als ICacheStrategy-Visitor mit Half/Full-Node-Methods.
- **E) Rueckgaben:** "FBSizeAwareLimiting: prefetches ≤ FB-Size", "AccessProbabilitySortedPrefetch bei WEAK Reliability", "PortablePrefetchStrategy: nur T0 + NTA verwenden", "Switch Half-Node bei FB_FULL > Threshold".

### P26 Zhang et al. (2024) — Prefetching Indexing Scheme
- **A) Zustaende:** `Path-Read-Counter` pro Block; `Hot-Path-State ∈ {≤cache, exceeds-cache}`; `Prefetch-Strategy ∈ {Cache-Pref, Path-Pref, Monitor-Pref}`; `Forgetting-Factor w` (Drift-Adaption).
- **B) Transitions:** Worker-Thread baut Index periodisch; Stage 1 (Clustering) → Stage 2 (Round-Robin); bei Drift-Detection → Re-Layout.
- **C) Monitor:** Per-Block PathReadCounter (NICHT inline, separater Block!); Cost-Model TIT/TIT_p/VCT/VCT_p; T_tlb=18, T_1=200, T_next=8.
- **D) Visitor-Strukturen:** **3 Prefetching-Strategien als Composite-Visitor** (CP+PP+MP); `MonitorClusteringAlgorithm` als Heuristic-Visitor; JumpPointerPrefetcher als 2-ahead-Visitor.
- **E) Rueckgaben:** "Levelled-Monitor: per-Tree-Level Telemetry", "PrefetchDistance = p × B_L3 / B_InnerNode", "**PathReadCounter pro Block, NICHT pro Tuple**" (vermeidet False-Sharing), "1.20-1.76x Speedup auf YCSB".

### P27 Zhang et al. (2025) — Hierarchical Prefetching
- **A/B/C:** Bundle-Entry (Static-FP > 200KB); Bundle-Execution ~63045 cycles; Spatial-Region (max 32 blocks); Compression-Buffer (16-entry FIFO); Record-and-Replay; Avg Jaccard 0.81-0.97; Late-Prefetch 3% vs 29%.
- **D) Visitor:** BundlePrefetchStrategy (Coarse-grained Path); JaccardSimilarityTelemetry; CompressionBufferStrategy.
- **E) Rueckgaben:** "Distance 90 Cache-Blocks bei 53% Accuracy", "Bundle-Threshold 200KB", "1.94KB on-chip + 512KB in-memory".

### P28 Kuehn et al. (2023) — "Towards Data-Based Cache Optimization"
- **A) Zustaende:** `Per-Node-Histogram P_n_x = {p_ck1, ..., p_ckn}`; `Hot-Path-State` (greedy: root → highest-prob child); `Layout-Variant ∈ {Native, NL, H, HL, HS, HLS}`; `Sliding-Window-Drift-State` (Future Work).
- **B) Transitions:** Static im Paper P28, aber Kuehn-Mail 2026-05-08 erweitert: **LeafOnlyCounter, LeafOnlySampledCounter<N>, RetroactiveAggregation als BARRIERE**.
- **C) Monitor:** PerNodeHistogram (Counter pro Comparison Key); perf + Intel VTune; L1D Miss Ratio (Native 0.42 vs HLS 0.30); STLB Misses dramatisch reduziert.
- **D) Visitor-Strukturen:** **5 Layout-Strategien als ConcreteState** (H/NL/HL/HS/HLS); HotPathLayoutStrategy als greedy Visitor; PerNodeHistogramTelemetry als Telemetry-Visitor.
- **E) Rueckgaben:** "Layout in linear-ascending memory locations", "256B Sweet Spot fuer cache-friendly + linear-search", "21-26% besser als Native", "**LeafOnlyCounter vermeidet Cache-Coherence-Storm auf Root**" (PRT-ART eigene Erkenntnis).

---

## CLUSTER F — SYNC + TUD-HABICH

### P08 ART of Practical Synchronization (Leis et al. 2016)
- **A) Zustaende:** `Lock-State ∈ {free, read-locked, write-locked, obsolete}` (alles in 64-Bit Atomic); `Version-Counter`; `Concurrency-Modus ∈ {OLC, ROWEX, HTM-Fallback}`; `Reader-Restart-Count` (limit fuer Forward-Progress).
- **B) Transitions:** **OLC 5-Schritt-Lookup**: readLockOrRestart → checkParent → prefixMatches → findChild + checkOrRestart → Recurse. Bei Konflikt → restart() vom Root. Nach Limit → Fallback Write-Locks. **ROWEX 4-Schritt Node-Replacement**: Lock-node-und-parent → Allokiere-neuen-Node → Atomar-Pointer-Swap → Unlock + obsolete-Markierung.
- **C) Monitor:** Cache-Line-Bouncing-Skalierung (211→2787 cycles, Faktor 6.6x bei 1→20 Threads); L1-Misses 5.2→9.0; HTM-Restart-Limit 20.
- **D) Visitor-Strukturen:** **OLC = BaseEngineStrategy-Visitor (lightweight), ROWEX = CacheEngineStrategy-Visitor (komplex). Optimistic-Lock und Write-Lock-Upgrade als 2 Visitor-Methods.**
- **E) Rueckgaben:** "Verwende SIMD bei Linear-Node-Lookup (Node4/16)", "level-Feld unveraenderlich nach Erstellung — atomarer Reader-Detection-Mechanismus", "Epoch-based Reclamation als 4. Mechanik kandidat", "ROWEX braucht 200 LOC fuer Insert vs. 148 OLC vs. 95 unsynchronized".

### P29 RCU McKenney et al. (2001)
- **A) Zustaende:** `Quiescent-State ∈ {Context-Switch, Idle, User-Mode, SystemCall, Trap, CPU-Offline}`; `Grace-Period-State ∈ {open, closed}`; `Per-CPU-Tracking-State`; `Reclamation-Pending-Queue-State`.
- **B) Transitions:** **2-Phase Update**: Phase 1 (neue Operationen sehen new state, alte sehen old) → Wait-for-Grace-Period → Phase 2 (Reclamation safe). `wait_for_rcu()` schaltet durch alle CPUs (FIFO-Scheduling).
- **C) Monitor:** `wait_for_rcu()` als forced-schedule auf jede CPU; Per-CPU-Quiescent-State-Counter; Memory-Latency-Ratios (1996+ NUMA-Trend).
- **D) Visitor-Strukturen:** **4 historische Flavors-Familien als ConcreteState** (DYNIX/ptx 2.1, DYNIX/ptx 4.0, Russell-voluntary, Tornado/K42-Generation). `call_rcu()` / `kfree_rcu()` als Reclamation-Visitor.
- **E) Rueckgaben:** "Reader fuehren NIE Schreiben aus → keine Cacheline-Invalidation", "**erfordert Update-Fraktion f << 1/N**", "Stale-Data-Toleranz als Cache-Strategie", "Per-CPU-Tracking minimiert L2/L3-Coherence-Traffic".

### P30 Hazard Pointers Michael (2004)
- **A) Zustaende:** `HP-Slot-State ∈ {NULL, valid-pointer, validating}`; `Per-Thread-rlist-State` (count vs Threshold R); `Active-Flag pro HP-Record`; `Wait-Free-Progress-State`.
- **B) Transitions:** **5-Schritt Application-Protokoll**: (1) Identify hazardous refs → (2) Find creation+last-access → (3) Compare periods → (4) Write to HP → (5) Validate; bei !valid → branch/back-off/retry. **Scan-Routine 2-Stage**: collect HP-list → check rlist gegen plist.
- **C) Monitor:** Threshold R (= H + Ω(H)) triggert Scan; Anzahl retired-Nodes NR ≤ N·K + N·H + N·R bounded; AllocateHPRec via TAS auf Active-Flag.
- **D) Visitor-Strukturen:** `HazardPointer = 4. ConcurrencyManager-Mechanik` (neben OLC, ROWEX, RCU). Per-Thread Hazard-Pointer als single-writer/multi-reader Visitor. PrepareForReuse als pluggable Reclamation-Hook.
- **E) Rueckgaben:** "Wait-Free Forward-Progress garantiert", "K HPs pro Thread (typisch 1-2, ART braucht mehr)", "ABA-Loesung als Side-Effect via single-word CAS", "False-Sharing-Padding mandatory".

### P31 Ungethuem TUD (2017) — Hardware Optimizations
- **A/B/C:** PE-Local (Scratchpad); iDMA-Crawler ∈ {LL, HT, BT, LA}; ISA-Ext ∈ {WAH, PLWAH, COMPAX, Hash, MergeSort, ...}; Burst ∈ {4,8}; 7-Schritt DB-Pipeline; Core-Manager schedules; Energie LX5 <0.15W vs i7; 100x-1000x Speedup.
- **D) Visitor:** 7 Pipeline-Schritte = 7 Visitor-Methods; iDMA als IComputeOffload; ISA-Extensions als Hardware-Visitor.
- **E) Rueckgaben:** "Push-Down Operations zum Memory-Controller", "Burst=8 fuer 64B Cacheline", "Local Data Memory 0+1 simultane Streams".

### P32 Schmidt/Habich TUD (2025) — "To Stride or Not to Stride"
- **A) Zustaende:** **DTLB/STLB-Capacity-State** (Sapphire 96/2048, Cascade 64/1536); **L2-Hardware-Prefetcher-Stream-Limit** (Sapphire 72, Cascade 32); `Cache-Set-Thrashing-State` (bei Multiples of 8/16/24); `Memory-Tier ∈ {Local-DRAM, Remote-DRAM, Local-HBM, Remote-HBM}`; `Access-Pattern ∈ {sequential, simd-sequential, strided, strided-unrolled}`.
- **B) Transitions:** **4 Hauptbeobachtungen als State-Transitions:** (Obs 0) Partition-Count >4096 → niedrig; (Obs 1) 1024-4096 → erster Anstieg (TLB); (Obs 2) <64 → zweiter Anstieg (Prefetcher); (Obs 3) 8/16/24 → Downward-Outlier (Cache-Associativity).
- **C) Monitor:** **LIVE-PROBING der TLB/Prefetcher/Associativity-Limits**; Hardware-Prefetcher kann (de-)aktiviert werden; numactl Pinning; gemessene Throughput pro Memory-Tier.
- **D) Visitor-Strukturen:** **Stride-Strategie als ICacheStrategy-Visitor**; `IAccessPatternStrategy` als State-Visitor mit 4 ConcreteStates.
- **E) Rueckgaben:** "Optimal-Partition-Count = 30-42 fuer Sapphire Rapids", "Stride-Size NICHT power-of-2 (nicht 128MiB) → 127.32MiB optimal", "576-Byte Padding zwischen Partitions", "**scalar strided OUTPERFORMS simd-sequential** (24 GiB/s vs 19.8 GiB/s)", "fewer threads needed bei strided".

### P33 VAMPIR Berthold/Habich TUD (2023) — Poster
- **A) Zustaende:** `NFP-Context ∈ {latency, throughput, transience, persistence, reliability, wearout, random-accessibility, cache-coherence}`; `Memory-Tier ∈ {DRAM, HBM, NVRAM, ...}`; `Pipeline-Schedule-State ∈ {Phase 1: Single-Query, Phase 2: Multi-Query}`.
- **B) Transitions:** **Compensation/Migration**: transparent-migration zwischen Memory-Tiers wenn NFP-Anforderung sich aendert. Multi-Query-Negotiation at compile-time.
- **C) Monitor:** NFP-Modellierung als first-class memory-property. V-malloc waehlt unter der Haube DRAM/NVRAM/HBM.
- **D) Visitor-Strukturen:** **Memory-Decorator-Pattern als NFP-Visitor**; `IPipelineScheduler` als Composite-Visitor mit Saeule-A-Pipeline + Saeule-B-Memory-Awareness; ICompileTimeNegotiator als Multi-Query-Visitor.
- **E) Rueckgaben:** "V-malloc als IHeterogeneousAllocator", "transparent migration/replacement bei NFP-Aenderung", "Multi-Query Compile-Time-Negotiation", "Pipeline-Dependency-Graph als DAG-Scheduling".

---

## QUERSCHNITTS-TABELLE 1: STATE-PATTERN-MODELLIERUNG

| Paper | Plattform-Zustand              | States      | Trigger                          | Monitor                      |
|-------|--------------------------------|-------------|----------------------------------|------------------------------|
| P01   | NodePopulationBucket           | 4           | Insert/Delete-Count              | L3-Hits/Misses (Tab III)     |
| P02   | CompoundNodeLayout             | 9           | Bit-Distribution-Check           | AVX2, Mean-Depth             |
| P03   | LayerDepth+Version             | h×4         | Conflict, Permutation            | DRAM-Stall, NUMA-Sens.       |
| P04   | EncodingSelection              | 4           | DP bei Build (static)            | Bauzeit O(N h²)              |
| P05   | CacheCostClass                 | 3           | CLFLUSH, VACUUM                  | **CLFLUSH+LFENCE Live**      |
| P06   | EmbeddedTreeSub                | 2           | LCP>0?                           | L1D-Miss 38vs44, LLC ½       |
| P07   | LookupPhase                    | 3           | Phase-1→2→3                      | Tag-Vergleiche 1-3           |
| P08   | LockState (64-Bit Atomic)      | 4           | OLC-Restart, ROWEX-Swap          | Cacheline-Bouncing           |
| P09   | BitStringPos                   | implizit    | rank/select                      | Cell-Probe-Bits              |
| P10   | LayerTier                      | 2           | Cutoff-R                         | popcount, FPR                |
| P11   | NodeSize                       | 1           | statisch                         | Cache-Simulator              |
| P12   | NodeGroup                      | 3           | Insert-Pattern, Space            | perfmon                      |
| P13   | NodeSizeClass                  | 3           | Cost-Model bei Build             | **PAPI cpi/miss/branch/TLB** |
| P14   | (KeySize,NodeSize,Search)      | 2×3×3       | Config-Table bei Build           | Config-Experiment            |
| P15   | Survey-Strategien              | n/a         | Compat-Matrix                    | Coherency, 5-Level           |
| P16   | RootBlock+ProbDist             | 4           | Greedy-Iteration                 | Smooth-Cost (Theorie)        |
| P17   | vEB+PMA-Density                | continuous  | Insert/Del + Threshold           | Memory-Transfers (asympt.)   |
| P18   | Cache-Level + Aliasing         | k+2         | BFS-Greedy bei Build             | Worst-case Path P_i          |
| P19   | LayoutInvariant + BrokenSet    | 1+7         | Strukturmod (Insert/Del/Rot)     | TPC-C-Benchmark              |
| P20   | LeafLayout                     | 4           | **Op-Counter ±1, KeyAdaption**   | **Per-Leaf 1B + Sampling**   |
| P21   | NodeWidth + PrefetchDist       | continuous  | Cost-Model + Scan-Phase          | Total-Stall-Equation         |
| P22   | GranularityTier × Mode         | 3×2         | Insert-Split per Tier            | Tier-Latency + OptWidth-Tab  |
| P23   | RuntimeAffine                  | continuous  | **Cost-Gate, Loop-Iteration**    | **HW-Perf-Counter**          |
| P24   | WorkloadType                   | 3           | Coverage<0 → disable             | Coverage% + Overpred%        |
| P25   | PrefetchLoc + FB-Reliability   | 4×3+2+2     | **FB_FULL, Microbench**          | **Perf-Counter+Microbench**  |
| P26   | PathReadCounter + HotPath      | continuous  | Worker-Thread periodisch         | **Per-Block (separat!)**     |
| P27   | BundleEntry + SpatialRegion    | FP>200KB    | Record-and-Replay                | Jaccard-Index 0.81-0.97      |
| P28   | PerNodeHist + Layout-Variant   | 5           | Static; +LeafOnly/RetroAgg       | **perf+VTune**               |
| P29   | QuiescentState + GracePeriod   | 6+2         | wait_for_rcu, context-switch     | Per-CPU, FIFO-Schedule       |
| P30   | HP-Slot + rlist-Count          | 3+cont      | Threshold R, Active-Flag         | rlist vs R, Helpscan         |
| P31   | PE+iDMA-Mode+ISA               | n×4×8       | Core-Manager-Schedule            | Energie + ISA-Speedup        |
| P32   | DTLB+Prefetcher+Assoc+Access   | 4×4 cont    | **LIVE-PROBING**                 | **HW-Prefetcher de/aktiv.**  |
| P33   | NFP+MemTier+Pipeline           | 8×4×2       | Compile-Time-Negotiation         | Memory-Decorator-Trace       |

---

## QUERSCHNITTS-TABELLE 2: VISITOR-PATTERN-BEDIENUNGSMUSTER

| Paper | Visitor-Typ                  | Rueckgabe-Hint an Strategy                          | C-Familien     |
|-------|------------------------------|-----------------------------------------------------|----------------|
| P01   | findChild-Dispatch           | Layout-Switch, SIMD-Pfad, tagged-pointer            | C1, C8         |
| P02   | searchPartialKeys+PtrTag     | Prefetch 4 Lines, AVX2, EBR                         | C1, C3, C4     |
| P03   | SliceLayered+AtomPermut      | PrefetchAllLines, Linear vs Binary                  | C1, C3, C4     |
| P04   | EncodingSelection (Pool)     | EF/PA/BV/DE-Wahl, lcp-subtraction, alpha            | C8, C9         |
| P05   | CacheCostBased + BellmanDP   | Multi-Level-Replace, memfd_create-Alloc             | C1, C5, C6     |
| P06   | Decision+Span (heterogen)    | Bytewise-Vergleich, Sub-Range 32                    | C1, C8         |
| P07   | MultiStrategySearchPage      | Speculative DirectPos, incremental CRC32            | C1, C8, C12    |
| P08   | OLC+ROWEX (Concurrency)      | SIMD-Linear, level-Feld, EBR                        | C4, C5, C11    |
| P09   | rank/select-Primitive        | popcount-HW, Block-LUT-Sizes                        | C8, C10        |
| P10   | LayerTier+SIMD-Label         | positional-corr-Prefetch, Suffix-Variant            | C1, C3, C8, C12|
| P11   | HardcodedBinarySearch        | NodeSize=Cacheline, Pointer-Elim                    | C1             |
| P12   | Code-Variant                 | Uniform branch-free, Segmented-vs-Full              | C1, C6         |
| P13   | CostModel (4-Param)          | optimale Node-Size, TLB-aware                       | C1, C9, C10    |
| P14   | ConfigurationTable           | Linear ≤384B, Range-Prefetch 2 ahead                | C3, C9         |
| P15   | Survey-Pool                  | Code-Cache, Micro-Server-Threading                  | ALL            |
| P16   | ProbWeighted-RootBlock       | Heavy-tail→Greedy, unknown-B→Cache-Oblivious        | C1, C9         |
| P17   | vEB+PMA+Indirection          | vEB optimal alle Levels, Buffer vs Indirection      | C1             |
| P18   | BFS-Greedy-MultiL+Aliasing   | Multi-Level Layout, Aliasing-Correction             | C1, C10        |
| P19   | LocalReloc+AdaptTrigger      | Move broken b, force-Alloc, periodic global         | C1, C5, C6     |
| P20   | AdaptiveLeafSelector (State!)| FP <2 Counter, FDL bei Dense, 16 Hints              | C1, C5, C9     |
| P21   | WideNode+JumpPointer         | w=8, k=2-3, Jump-Array intern/extern                | C3             |
| P22   | FractalLayout (rekursiv)     | Disk-First/Cache-First, DualJumpPointer             | C1, C3         |
| P23   | RuntimeAdaptive (3-Phasen)   | O_r=MissLat/IterLat, Modify 2-5 Inst, Gate          | C5, C9         |
| P24   | NegativPrediction (Disable!) | DEAKTIVIERE bei Scale-Out, Energie-aware            | C3, C9         |
| P25   | TwoGranularityPrefetch       | FBSizeAware, T0+NTA only, AccessProbSorted          | C3, C5         |
| P26   | 3-Strat-Composite (CP+PP+MP) | Levelled-Monitor, p × B_L3/B_InnerNode              | C3, C5         |
| P27   | Bundle+CompressionBuffer     | Distance 90, Bundle-Threshold 200KB                 | C3, C5, C10    |
| P28   | HotPathLayout (greedy)       | Linear-Ascending, 256B Sweet, LeafOnly              | C1, C5, C9     |
| P29   | RCU-Flavor (4 hist.)         | Reader-no-writes, f<<1/N, Per-CPU                   | C4, C7, C11    |
| P30   | HazardPointer (Wait-Free)    | Wait-Free, K HPs/Thread, ABA                        | C4, C5, C7     |
| P31   | PE-Pipeline 7+iDMA+ISA       | Push-Down-iDMA, Burst=8, Local-Mem 0+1              | C2, C6, C7, C10, C11 |
| P32   | StridePattern+Live-Probing   | OptParts=30-42, Stride 127MiB, Padding 576B         | C3, C5, C9, C10|
| P33   | NFP-Decor+V-malloc+Negotiat. | Heterogene Allokation, transparent migration        | C5, C6, C7     |

---

## ARCHITEKTUR-BEZUG: STATE-PATTERN + VISITOR FUER ICacheEngine

### State-Pattern-Klassen-Hierarchie (10 State-Klassen aus 33 Papern)

```
IPlatformState (Context-Klasse der Cache-Engine)
├── CacheResidencyState        [P01,P05,P21,P22]: Hot/Warm/Cold
├── PrefetchReliabilityState   [P24,P25]: Weak/Strong/Configurable
├── WorkloadTypeState          [P24,P26,P28]: ReadMostly/WriteHeavy/Mixed/ScaleOut
├── TLBState                   [P13,P32]: DTLB-Sat/STLB-Sat/Healthy
├── PrefetcherStreamState      [P32]: Below/Above (Cascade 32, Sapphire 72)
├── CacheAssociativityState    [P18,P32]: ConflictFree/SetThrashing
├── ConcurrencyState           [P08,P29,P30]: ReaderUnc/Cont/WriterCont/Restart
├── LayoutDegradationState     [P19,P26,P28]: Held/Partial/Full
├── MemoryTierState            [P22,P25,P33]: LocalDRAM/RemoteDRAM/LocalHBM/RemoteHBM/NVRAM
└── EnergyBudgetState          [P24,P31]: Headroom/Constrained
```

### Visitor-Hierarchie (Rueckgabe an ISearchPageStrategy)

```
ICacheEngineVisitor: visit(IPlatformState s, ISearchPageStrategy ctx) → IOptimizationHint
├── LayoutVisitor      [C1]:  {newLayoutClass, allocSize, allocStrategy}
├── PinningVisitor     [C2]:  {coreAffinity, pinningPolicy}
├── PrefetchVisitor    [C3]:  {distance, granularity, hwHint, fbAware, disable?}
├── CoherenceVisitor   [C4]:  {mechanism (OLC/ROWEX/RCU/HP), restartLimit}
├── TelemetryVisitor   [C5]:  {counterDelta, samplingRate, retroAggTrigger}
├── AllocationVisitor  [C6]:  {tier (DRAM/HBM/NVRAM), preferLocal, vMallocHint}
├── MigrationVisitor   [C7]:  {direction, reclamationPolicy, graceEpoch}
├── EncodingVisitor    [C8]:  {encodingSelection (EF/PA/BV/DE), lcpSubFlag}
├── HeuristicVisitor   [C9]:  {strategyChoice, costParams, gate} (orchestriert!)
├── TopologyVisitor    [C10]: {rankSelectImpl, blockSize, paddingBytes}
├── SchedulerVisitor   [C11]: {affinity, threadPool, batchSize}
└── FilterVisitor      [C12]: {enabled, fprTarget, suffixVariant}
```

### Sub-Visitor-Bedienungsmuster pro C-Familie (kompakt)

| C-Familie     | Reads State                            | Returns Hint                         | Belegende Paper              |
|---------------|----------------------------------------|--------------------------------------|------------------------------|
| C1 Layout     | LayoutDegradation + WorkloadType       | layoutClass, allocationSize          | P01/P02/P05/P06/P11/P12/P20/P28|
| C2 Pinning    | MemoryTier (NUMA)                      | coreAffinity, pinningPolicy          | P03/P15/P31                  |
| C3 Prefetch   | PrefetchReliability+Stream+TLB         | distance, granularity, hwHint, disable| P21/P22/P24/P25/P26          |
| C4 Coherence  | ConcurrencyState                       | mechanism (OLC/ROWEX/RCU/HP)         | P08/P29/P30                  |
| C5 Telemetry  | (write-back to IPlatformState)         | counterDelta, samplingRate           | P20/P26/P28/P32              |
| C6 Allocation | MemoryTier + EnergyBudget              | tier, allocationStrategy             | P05/P22/P31/P33              |
| C7 Migration  | LayoutDegradation transitions          | direction, reclamationPolicy         | P19/P29/P30/P33              |
| C8 Encoding   | WorkloadType                           | encodingSelection (Pool)             | P02/P04/P06/P10              |
| C9 Heuristik  | (top-level orchestriert)               | strategyChoice, costFunctionParams   | P14/P16/P23/P24/P26          |
| C10 Topologie | CacheAssociativity + TLB               | rankSelectImpl, padding, correction  | P09/P10/P18/P32              |
| C11 Scheduler | MemoryTier                             | affinity, threadPool, batchSize      | P15/P29/P31                  |
| C12 Filter    | Workload (Range-Anteil)                | enabled, fprTarget, suffixVariant    | P10                          |

**Wichtige Hinweise:**
- C5 Telemetry schreibt nicht zurueck, sondern aktualisiert IPlatformState. **LeafOnlyCounter + RetroactiveAggregation** ist Cache-Coherence-sichere Variante.
- C9 Heuristik ist Top-Level-Visitor, der andere Sub-Visitor orchestriert. Configuration-Table (P14) als Default.
- C3 Prefetch unterstuetzt **negative Empfehlung** (P24: disable bei Scale-Out).
- C4 Coherence dynamisch waehlbar: OLC default, ROWEX bei Lookup-dominant, RCU bei f<<1/N, HP wenn Wait-Free.

### State-Transition-Trigger-Konsolidierung

| Trigger                            | Paper          | Granularitaet              |
|------------------------------------|----------------|----------------------------|
| Operation-Counter (saturating)     | P20            | Per-Leaf, byte             |
| CLFLUSH-Probe                      | P05            | Per-Knoten, on-demand      |
| Hardware-Performance-Counter       | P23/P25/P28/P32| Live, kontinuierlich       |
| PathReadCounter                    | P26            | Per-Block, Worker-Thread   |
| LeafOnlyCounter (PRT-ART)          | P28+Mail       | Per-Leaf, Coherence-sicher |
| RetroactiveAggregation             | PRT-ART        | Periodisch (alle N Queries)|
| Cost-Benefit-Gate                  | P23            | Per-Loop-Iteration         |
| OLC-Restart-Limit                  | P08            | Per-Lookup                 |
| Grace-Period-Detection             | P29            | wait_for_rcu / per-CPU     |
| HP-Threshold-R                     | P30            | Per-Thread                 |
| Live-Probing                       | P32            | Startup + periodisch       |
| Configuration-Table-Lookup         | P14            | Bei Index-Creation         |

### Schluss-Empfehlungen fuer U09

1. **Context** = `IPlatformState` (10 State-Klassen, singleton).
2. **Visitor-Top-Level** = `ICacheEngineVisitor` mit 12 Sub-Visitor.
3. **Rueckgabe** = `IOptimizationHint` mit { layout, allocation, prefetch, concurrency, telemetry }.
4. **Default-Trigger-Kombination:** P20 OperationCounter + P28 LeafOnlyCounter + P32 LiveProbing + P05 CLFLUSH-OnDemand.
5. **Heterogene Pattern-Unterstuetzung** (P06/P07): ISearchPagesStrategyPattern muss N verschiedene Sub-Strategien orchestrieren koennen.

### Offene Punkte
- Synchronisation IPlatformState zwischen Cores (RCU vs padding).
- Visitor-Aufruf-Frequenz (per Lookup vs per N vs event-driven).
- Konflikt-Aufloesung zwischen mehreren Hint-Vorschlaegen.
