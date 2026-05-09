# Cache-Strategien-Taxonomie (Konsolidierung aus 33 Papern)
**Stand:** 2026-05-09
**Quelle:** _paper_extractions/cluster_A-F.md
**Architektur-Bezug:** REV 2 Concept-Hierarchie, Saeule A (ICacheStrategy = VISITOR: BaseEngineStrategy | CacheEngineStrategy)

---

## 1. Familien-Uebersicht (gemeinsame Daecher)

### Familie F1: AdaptiveFootprintStrategy (Knoten-Layout-Anpassung an Daten-Population)
- **Concept-Klasse:** `IAdaptiveFootprintStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Knoten-Repraesentation passt sich dynamisch an die Anzahl/Verteilung der Eintraege an, um Cache-Line-Count zu minimieren.
- **Konkretisierungen:**
  * P01 ART (Cluster A): 4 Node-Typen (Node4/16/48/256), `AdaptiveNodeFootprintStrategy`
  * P02 HOT (Cluster A): 9 Layout-Varianten (Single-Mask {8,16,32}-PKEYS + Multi-Mask 8/16/32 mit 8/16/32 PK-Bits)
  * P05 START (Cluster A): Multilevel Nodes — adaptive Span-Width, Rewired Nodes mit virtual<->physical Mapping
  * P12 CSB+ (Cluster B): Segmented vs. Full vs. Basic CSB+ — 3 Allocation-Varianten
  * P14 CSB+ Itanium (Cluster C): ConfigurationTable-getriebene Auswahl Knoten-Groesse + Search-Strategy
  * P20 B-Tree adaptive (Cluster D): KeyAdaption + OperationAdaption — Layout-Wechsel zwischen Comparison/Fingerprinting/SDL/FDL
  * P28 Kuehn (Cluster E): HotPathLayoutStrategy — Greedy Hot-Path-Selection
- **Visitor-Variante:** `CacheEngineStrategy` (alle, datengetrieben)
- **Verbindung zu Saeule B:** Verbraucht `IWorkloadModel` und `ICacheTopology` als Input.

### Familie F2: SuccinctEncodingStrategy (Pointer-frei + Bit-kompakt)
- **Concept-Klasse:** `ISuccinctEncodingStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Asymptotisch optimaler Footprint (Z+o(Z) Bits) durch Bit-String-Repraesentation; Position im Bit-String entspricht Knoten-ID; Operationen via rank/select-Primitive.
- **Konkretisierungen:**
  * P09 Jacobson LOUDS (Cluster A): 2-Bit-pro-Knoten Repraesentation, BitStringNodeRepresentationStrategy
  * P04 CoCo (Cluster A): Pool aus EF (Elias-Fano), PA (Packed Array), BV (Bitvector), DE (Dense Encoding) — `SuccinctEncodingPoolStrategy`
  * P10 SuRF (Cluster A): LOUDS-Dense + LOUDS-Sparse Hybrid (8n+2n Bits in Sparse)
  * P11 CSS-Tree (Cluster B): PointerEliminationStrategy — Child-Pointers via Arithmetik berechnet
  * P12 CSB+ (Cluster B): PartialPointerEliminationStrategy — nur firstChild-Pointer, Rest arithmetisch
  * P14 CSB+ Itanium (Cluster C): NodeGroupContiguousLayout
- **Visitor-Variante:** `CacheEngineStrategy` (alle, footprint-orientiert)
- **Verbindung zu Saeule B:** Setzt `IRankSelectPrimitive` voraus (popcount-faehige `IIsaFeatureSet`).

### Familie F3: CacheLineAlignedStrategy (Knoten-Groesse = Cache-Line-Vielfaches)
- **Concept-Klasse:** `ICacheLineAlignedStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Knoten exakt auf 1 oder mehrere `ICacheLine` (i.d.R. 64 B) abgestimmt; Header und Payload in derselben Cache-Line; ggf. Padding zur Disalignment-Vermeidung.
- **Konkretisierungen:**
  * P01 ART (Cluster A): 16-Byte Single-Cache-Line-Header
  * P02 HOT (Cluster A): Compound-Node 64-472 B in wenigen Cache-Lines
  * P07 Wormhole (Cluster B): 64-Byte Hash Slot ("hash slot" = 8 Praefixe in 1 Cache-Line)
  * P11 CSS-Tree (Cluster B): "Cache-Line-Sized Node" — definitive Strategie
  * P12 CSB+ (Cluster B): m = (cache_line - sizeof(firstChild) - sizeof(nKeys))/sizeof(key)
  * P14 CSB+ Itanium (Cluster C): "Node size: a multiple of the cache line size"
  * P15 Graefe/Larson Survey (Cluster C): RecordCacheLineAlignmentStrategy + PageHeaderCachelineColocation
  * P32 To-Stride (Cluster F): 576-Byte-Padding zur Cache-Set-Thrashing-Vermeidung
- **Visitor-Variante:** `CacheEngineStrategy` (alle Cache-Line-bewusst)
- **Verbindung zu Saeule B:** Setzt `ICacheLine.size_bytes` als Plattform-Konstante voraus.

### Familie F4: MultiCacheLineNodeStrategy (Knoten ueber mehrere Cache-Lines mit Prefetch)
- **Concept-Klasse:** `IMultiCacheLineNodeStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Knoten umspannen 4-16 Cache-Lines; ALLE Cache-Lines werden vor Verwendung parallel geprefetched; Cost-Reduktion durch geringere Tree-Hoehe ueberwiegt zusaetzliche Cache-Misses.
- **Konkretisierungen:**
  * P03 Masstree (Cluster B): 256 B = 4 Cache-Lines, alle vor Verwendung parallel geprefetched
  * P13 Hankins/Patel (Cluster B): 256-512 B Knoten, 8-16x Cache-Line; analytisches Cost-Modell mit (I, M, B, T)
  * P21 Chen pB+-Tree (Cluster D): WideNodePrefetchStrategy mit w = 8 Cache-Lines, w_optimal aus B = T1/T_next
  * P22 Chen Fractal (Cluster D): in-page Tree mit adaptive Width pro Tier
- **Visitor-Variante:** `CacheEngineStrategy` (Software-Prefetch-ISA-Feature noetig)
- **Verbindung zu Saeule B:** Verbraucht `IMemoryBandwidthModel` (B = T1/T_next) und `IIsaFeatureSet` (Prefetch-Instruktion).

### Familie F5: SoftwarePrefetchStrategy (explizite Prefetch-Instruktionen)
- **Concept-Klasse:** `ISoftwarePrefetchStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Compiler/Programmer-emittierte Prefetch-Instruktionen (`__builtin_prefetch`, `lfetch`, `prefetcht{0,1,2}`, `prefetchnta`) ueberlappen Cache-Miss-Latenz mit Compute.
- **Konkretisierungen:**
  * P02 HOT (Cluster A): Prefetch der ersten 4 Cache-Lines mit Pointer-Tag-Decoding
  * P03 Masstree (Cluster B): PrefetchAllLinesStrategy fuer alle Knoten-Cache-Lines
  * P10 SuRF (Cluster A): PositionalCorrespondencePrefetchStrategy ueber LOUDS-Sequences
  * P14 CSB+ Itanium (Cluster C): ItaniumExplicitPrefetchStrategy (lfetch) + TwoNodesAheadRangeScanPrefetch
  * P15 Graefe/Larson Survey (Cluster C): Multi-Cache-Line, Indirection-Vector, 2-candidate, Post-Location, Multi-Record
  * P21 Chen pB+-Tree (Cluster D): WideNodePrefetch + JumpPointerArrayPrefetch (k voraus)
  * P22 Chen Fractal (Cluster D): DualJumpPointerArrayStrategy fuer Cache-Tier + Disk-Tier
  * P25 Mahling Coro (Cluster E): Coroutine-basierter Prefetch (Full Node + Half Node)
  * P26 Zhang Index (Cluster E): __builtin_prefetch L3 + 3 Strategien (CP, PP, MP)
  * P27 Zhang Hierarchical (Cluster E): Bundle-basierter Prefetch (Distance 90 Cache-Blocks)
- **Visitor-Variante:** `CacheEngineStrategy` (Compiler-emittierte Hints)
- **Verbindung zu Saeule B:** Setzt `IIsaFeatureSet.has_software_prefetch` voraus; konsumiert `ICacheLevel`-Latenzen.

### Familie F6: PointerChasingResolutionStrategy (Jump-Pointer-Arrays / Linearization)
- **Concept-Klasse:** `IPointerChasingResolutionStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Pointer-basierte Datenstrukturen verhindern Latency-Hiding (n_{i+1} unbekannt vor Fetch von n_i). Loesung: data-linearization ODER history-pointers (Jump-Pointer-Arrays).
- **Konkretisierungen:**
  * P21 Chen pB+-Tree (Cluster D): JumpPointerArrayPrefetchStrategy (extern oder intern), Chunked-Linked-List mit Hint-Pointers
  * P22 Chen Fractal (Cluster D): DualJumpPointerArrayStrategy — internal Cache-Tier + external Disk-Tier
  * P26 Zhang Index (Cluster E): JumpPointerQueue fuer MVCC-Version-Chains, 2-ahead Lookups
- **Visitor-Variante:** `CacheEngineStrategy`
- **Verbindung zu Saeule B:** Verbraucht `IMemoryBandwidthModel` zur Bestimmung der optimalen Distance k.

### Familie F7: SimdAcceleratedLookupStrategy (Hardware-parallele Branching-Suche)
- **Concept-Klasse:** `ISimdAcceleratedLookupStrategy` (Konkretisierung von `ICacheStrategy`/`ISearchPageStrategy`)
- **Dach-Idee:** SIMD-Instruktionen (SSE/AVX2/AVX-512/NEON) parallelisieren Key-Comparison innerhalb eines Knotens.
- **Konkretisierungen:**
  * P01 ART (Cluster A): SSE in Node16 — `_mm_set1_epi8` + `_mm_cmpeq_epi8` + `_mm_movemask_epi8`
  * P02 HOT (Cluster A): AVX2 + PEXT/PDEP (BMI2) fuer Partial-Key-Extraktion
  * P03 Masstree (Cluster B): SSE moeglich, primaer aber via 8-Byte Integer-Slice-Vergleich
  * P10 SuRF (Cluster A): 128-Bit SSE Label-Search in LOUDS-Sparse
  * P20 B-Tree adaptive (Cluster D): SIMD fuer Fingerprint-Vergleich + Head-Vergleich
  * P31 Ungethuem TUD (Cluster F): Tomahawk-PE mit ISA-Extensions (WAH, Hash, MergeSort)
- **Visitor-Variante:** `CacheEngineStrategy`
- **Verbindung zu Saeule B:** Setzt `IIsaFeatureSet.has_avx2` / `has_sse42` / `has_avx512` voraus.

### Familie F8: PathCompressionStrategy (Lazy Expansion + Subtree-Collapsing)
- **Concept-Klasse:** `IPathCollapseStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Eindeutige Praefix-Knoten und one-way-Pfade werden kollabiert; Subtries ueber einzelnen Leaves truncated. Reduziert Knotenzahl → reduziert Cache-Misses pro Lookup.
- **Konkretisierungen:**
  * P01 ART (Cluster A): Lazy Expansion + Path Compression (Pessimistic + Optimistic)
  * P02 HOT (Cluster A): k-constrained Compound Nodes (kollabiert binaere Patricia-Subtrie in 1 Knoten)
  * P04 CoCo (Cluster A): Macro-Node Collapsing + DataAware DP-Optimizer
  * P05 START (Cluster A): Multilevel Nodes (Span-Width-Erweiterung kollabiert mehrere Levels)
  * P06 B^2-Tree (Cluster B): Span-Node mit longest common prefix (LCP) reduziert Byte-Duplikation
  * P07 Wormhole (Cluster B): Anchor-Key + Doubly-Linked LeafList + MetaTrieHT
  * P08 ART OLC (Cluster F): Path Compression als Cache-Strategie (Tree-Hoehe reduziert)
- **Visitor-Variante:** `CacheEngineStrategy`
- **Verbindung zu Saeule B:** Indirekt — reduziert Working-Set, profitiert von kleinerem `ICacheLevel.size_bytes`.

### Familie F9: LayerDependentEncodingStrategy (Hot/Cold-Tier-Trennung)
- **Concept-Klasse:** `ILayerDependentEncodingStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Obere Trie-Levels (wenige Knoten, viele Accesses, "warm/hot") werden anders enkodiert als untere ("cold"). Layout adaptiert an Cache-Temperature.
- **Konkretisierungen:**
  * P02 HOT (Cluster A): k-constrained Compound oben, klassisch unten
  * P05 START (Cluster A): Multilevel Nodes oben, normale Nodes unten
  * P10 SuRF (Cluster A): LOUDS-Dense (256-Bit-Bitmaps) oben, LOUDS-Sparse (8n+2n) unten — Cutoff-Level R = 64
  * P20 B-Tree adaptive (Cluster D): AdaptiveLeafSelectorStrategy (Comparison/Fingerprinting/SDL/FDL pro Leaf)
  * P28 Kuehn (Cluster E): Hot Path Layout (greedy highest-prob Pfad in linearer Memory)
- **Visitor-Variante:** `CacheEngineStrategy`
- **Verbindung zu Saeule B:** Verbraucht `IWorkloadModel` (Access-Frequency pro Level).

### Familie F10: PointerTagDispatchStrategy (Type-Bits in LSB von Pointern)
- **Concept-Klasse:** `IPointerTagDispatchStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** 1-3 Bits in Low-Order-Bits eines 64-Bit-Pointers kodieren Knoten-Typ ODER eingebettete Werte; Type-Dispatch und Cache-Line-Load ueberlappen sich.
- **Konkretisierungen:**
  * P01 ART (Cluster A): Tagged Pointers (Combined Pointer/Value Slots)
  * P02 HOT (Cluster A): Type-Bits in LSB (Pointer-Tagging) — Cache-Line-Load und Type-Dispatch ueberlappen
  * P05 START (Cluster A): Pointer-Tagging zur Identifikation aktiver Slots in Rewired Nodes
  * P07 Wormhole (Cluster B): "On x86-64 only the low-order 48 bits are used in virtual memory address" — direkter Bezug zur Plattform
- **Visitor-Variante:** `CacheEngineStrategy`
- **Verbindung zu Saeule B:** Setzt `IIsaFeatureSet.virtual_address_bits` (typisch 48) voraus.

### Familie F11: EmbeddedSecondaryIndexStrategy (Page-Local Sub-Tree)
- **Concept-Klasse:** `IEmbeddedSecondaryIndexStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Eine Page enthaelt einen sekundaeren Mini-Tree-Index (z.B. Decision-Node + Span-Node-Tree, MetaTrie/Hash, in-page B+); reduziert binaere Suche von ganzer Page auf Sub-Range.
- **Konkretisierungen:**
  * P06 B^2-Tree (Cluster B): Decision-Node + Span-Node-Tree pro 64 KiB Page
  * P07 Wormhole (Cluster B): MetaTrieHT + MetaTrie + LeafList als 3-Komponenten-Index pro Leaf
  * P11 CSS-Tree (Cluster B): Embedded Directory above Sorted Array
  * P22 Chen Fractal (Cluster D): Disk-Page enthaelt einen kompletten in-page B+-Tree
  * P26 Zhang Index (Cluster E): Path Prefetcher + Search Block Table
- **Visitor-Variante:** `CacheEngineStrategy`
- **Verbindung zu Saeule B:** Profitiert von `IPageSize` >= 4 KiB.

### Familie F12: IndirectionVectorStrategy (Logische vs. physikalische Reihenfolge)
- **Concept-Klasse:** `IIndirectionVectorStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Indirection-Array (Slot-Indizes) trennt logische Sortierordnung von physikalischer Speicherung. Erlaubt lock-freie Inserts (atomic Slot-Update).
- **Konkretisierungen:**
  * P03 Masstree (Cluster B): Permutation-Field (16 * 4-Bit-Indizes + nkeys in 64-Bit-Wort)
  * P06 B^2-Tree (Cluster B): Range-Array (Umbra-Indirection)
  * P07 Wormhole (Cluster B): Sort-By-Tag Leaf-Layout (Tag-Array sortiert, Key-Array nicht)
  * P15 Graefe/Larson Survey (Cluster C): Indirection-Vector als generelle Strategie
  * P20 B-Tree adaptive (Cluster D): Slotted-Page-Hyperdesign mit bidirektional wachsendem Slot+Heap
- **Visitor-Variante:** `CacheEngineStrategy`
- **Verbindung zu Saeule B:** Profitiert von atomaren 64-Bit-Stores (`IIsaFeatureSet.atomic_int64`).

### Familie F13: CacheObliviousLayoutStrategy (Levels-Unkenntlich, optimal pro Tier)
- **Concept-Klasse:** `ICacheObliviousLayoutStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Layout funktioniert OPTIMAL auf jedem Cache-Level innerhalb Konstanten-Faktor, OHNE Block-Size B zu kennen. Rekursive selbst-aehnliche Aufteilung.
- **Konkretisierungen:**
  * P16 Bender (Cluster C): CacheObliviousProbabilityLayoutStrategy (Greedy mit unbekanntem B; 4× optimal)
  * P17 Bender Cache-Oblivious B-Trees (Cluster C): VanEmdeBoasLayoutStrategy + DynamicVEBWithPackedMemory
  * P18 Saikkonen (Cluster C): CacheObliviousVEBProductionStrategy als Special Case (B_i geometrisch)
  * P22 Chen Fractal (Cluster D): FractalPrefetchingStrategy als Mischform (Cache-Aware mit Tier-Konfiguration, aber selbst-aehnlich)
- **Visitor-Variante:** `CacheEngineStrategy` (mit Awareness=CacheOblivious)
- **Verbindung zu Saeule B:** KEINE konkreten Cache-Parameter noetig (cache-oblivious by definition).

### Familie F14: CacheSensitiveMultiLevelLayoutStrategy (Cache-Aware Multi-Level)
- **Concept-Klasse:** `ICacheSensitiveMultiLevelLayoutStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Algorithmus kennt konkrete Cache-Parameter B_1 < B_2 < ... < B_k inkl. TLB-Page-Size und legt Knoten BFS-rekursiv pro Level an.
- **Konkretisierungen:**
  * P18 Saikkonen 2008 (Cluster C): MultiLevelCacheSensitiveLayoutStrategy + AliasingCorrectionStrategy fuer Set-Associativity
  * P19 Saikkonen 2016 (Cluster C): LayoutInvariantPreservationStrategy + LocalRelocationStrategy mit α-Parameter (1-6 Knoten lokal verschieben)
  * P28 Kuehn (Cluster E): Hot Path Layout in linear ascending memory (TLB-aware)
- **Visitor-Variante:** `CacheEngineStrategy` (mit Awareness=CacheSensitive)
- **Verbindung zu Saeule B:** Verbraucht `ICacheLevel[]` (alle Levels), `ICacheLine.set_associativity`, `ICacheTopology.tlb_page_size`.

### Familie F15: ProbabilityWeightedLayoutStrategy (Workload-Distribution-Aware)
- **Concept-Klasse:** `IProbabilityWeightedLayoutStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Knoten-Layout folgt Schluessel-Verteilung (Heavy-Tail, Zipfian, Uniform); haeufiger zugegriffene Knoten in Root-Block bzw. linear-konsekutiv.
- **Konkretisierungen:**
  * P16 Bender (Cluster C): GreedyRootBlockMaximizationStrategy ((B-1)/B optimal) + RelaxedGreedyStrategy
  * P28 Kuehn (Cluster E): HotPathLayoutStrategy (greedy highest-prob → highest-prob Child)
- **Visitor-Variante:** `CacheEngineStrategy`
- **Verbindung zu Saeule B:** Verbraucht `IWorkloadModel` (Access-Probability pro Knoten).

### Familie F16: CompressionStrategy (Order-preserving + Prefix/Suffix-Truncation)
- **Concept-Klasse:** `ICompressionStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Mehr Daten pro Cache-Line durch Compression: Order-preserving Huffman, Prefix/Suffix-Truncation, Next-Neighbor-Differencing, Key-Normalization.
- **Konkretisierungen:**
  * P15 Graefe/Larson Survey (Cluster C): Order-preserving Huffman, KeyNormalization, PrefixSuffixTruncation, NextNeighborDifferencing
  * P20 B-Tree adaptive (Cluster D): PrefixTruncationStrategy (Fences definieren Praefix-Laenge)
  * P28 Kuehn (Cluster E): impliziert via Hot-Path-Layout
- **Visitor-Variante:** `CacheEngineStrategy`
- **Verbindung zu Saeule B:** Profitiert von `IIsaFeatureSet.has_simd_compare`.

### Familie F17: PoorMansNormalizedKeyStrategy (Sub-Search via 4-Byte-Heads)
- **Concept-Klasse:** `IPoorMansNormalizedKeyStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Indirection-Vector enthaelt nicht nur Offset, sondern 4-/8-Byte Praefix des normalisierten Keys (Single-Hardware-Instruktion-Vergleich; Vollrecord nur bei Match).
- **Konkretisierungen:**
  * P15 Graefe/Larson Survey (Cluster C): PoorMansNormalizedKey (Sektion 6.1)
  * P20 B-Tree adaptive (Cluster D): HeadsStrategy (4-Byte Heads als Integer-Vergleich) + HintsStrategy (16 Heads in 64 B)
  * P28 Kuehn (Cluster E): impliziert via Hot-Path
- **Visitor-Variante:** `CacheEngineStrategy`
- **Verbindung zu Saeule B:** Profitiert von `IIsaFeatureSet.has_branch_free_cmov`.

### Familie F18: NoSharedWriteStrategy (Reader Schreiben Niemals)
- **Concept-Klasse:** `INoSharedWriteStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Lookups duerfen NIEMALS shared cache lines dirty machen (kein Write zu shared memory) → vermeidet Cache-Line-Bouncing/Coherence-Traffic.
- **Konkretisierungen:**
  * P03 Masstree (Cluster B): explizit "lookups must never dirty shared cache lines" (Section 4)
  * P08 ART OLC (Cluster F): Reader fuehren nur Loads auf Lock/Version-Variable durch (`readLockOrRestart` ist read-only)
  * P29 RCU (Cluster F): Reader haben "absolutely no locks or atomic instructions"
  * P30 Hazard Pointers (Cluster F): "Lock-free objects with hazard pointers do not write to any shared locations other than hazard pointers"
- **Visitor-Variante:** `CacheEngineStrategy` (Reader-Side Cache-friendly)
- **Verbindung zu Saeule B:** Reduziert Coherence-Pressure auf `IInterconnect`.

### Familie F19: HotColdLayerEncodingStrategy (Spezialform von F9 fuer Filter)
- **Concept-Klasse:** `IHotColdLayerEncodingStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Sub-Variante von F9 fuer Approximate-Membership-Filter: hot upper Levels als Bitmap, cold lower Levels als Suffix-Encoding mit FPR-Tradeoff.
- **Konkretisierungen:**
  * P10 SuRF (Cluster A): SuRF-Base, SuRF-Hash, SuRF-Real, SuRF-Mixed
- **Visitor-Variante:** `CacheEngineStrategy`
- **Verbindung zu Saeule B:** Verbraucht `IFalsePositiveRateModel` als Quality-Property.

### Familie F20: BlockOrientedRankSelectStrategy (Cache-Line-aligned LUT)
- **Concept-Klasse:** `IBlockOrientedRankSelectStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Block-Size der rank/select-Lookup-Tabelle auf Cache-Line abgestimmt; Hardware-popcount fuer Bit-Counting.
- **Konkretisierungen:**
  * P09 Jacobson LOUDS (Cluster A): Tarjan-Yao-Tabellen (klassisch)
  * P10 SuRF (Cluster A): B=64 fuer Dense, B=512 fuer Sparse (1 Cache-Line, 6.25% Overhead)
  * P04 CoCo (Cluster A): SDSL/sux/ds2i Block-Strukturen
- **Visitor-Variante:** `CacheEngineStrategy`
- **Verbindung zu Saeule B:** Setzt `IIsaFeatureSet.has_popcount` voraus.

### Familie F21: VirtualMemoryRewiringStrategy (Virtual<->Physical Page Mapping)
- **Concept-Klasse:** `IVirtualMemoryRewiringStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** OS-API (memfd_create, mmap) zur Compaction sparser virtueller Pages auf SHARED physische Pages.
- **Konkretisierungen:**
  * P05 START (Cluster A): Rewired Nodes mit Page-Sharing (memfd_create + multiple mmap)
- **Visitor-Variante:** `CacheEngineStrategy`
- **Verbindung zu Saeule B:** Setzt `IVirtualMemoryStrategy` als Saeule-B-Concept voraus.

### Familie F22: CodeSpecializationStrategy (Compile-Time Loop-Unrolling, Hardcoded Search)
- **Concept-Klasse:** `ICodeSpecializationStrategy` (Konkretisierung von `ICacheStrategy` mit Wirkung auf Instruction-Cache)
- **Dach-Idee:** Knoten-Groesse + Search-Code zur Compile-Zeit fest; Loops aufgerollt, Branches als if-else hardcoded; reduziert Loop-Overhead und Branch-Mispredict.
- **Konkretisierungen:**
  * P11 CSS-Tree (Cluster B): Hardcoded if-else, Unrolled Search per Node
  * P12 CSB+ (Cluster B): 3 Varianten (basic, uniform, variable) — uniform = hardcoded BST mit if-then-else, padded mit max-keys
  * P14 CSB+ Itanium (Cluster C): LoopUnrolledBinarySearchPageStrategy
  * P23 Khan (Cluster D): TemplateSpecializerStrategy mit Bitwise Instruction Modification (Itanium-II)
- **Visitor-Variante:** `CacheEngineStrategy` (Instruction-Cache-aware)
- **Verbindung zu Saeule B:** Profitiert von Instruction-Cache (Saeule B braucht `ICachePage` fuer Instructions, oder `IInstructionCacheLevel`).

### Familie F23: AdaptiveRuntimePrefetchDistanceStrategy (Live-Counter-driven)
- **Concept-Klasse:** `IAdaptiveRuntimePrefetchDistanceStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Prefetch-Distance wird ZUR LAUFZEIT aus echter Loop-Iteration-Latency und gemessener Cache-Miss-Latency berechnet; Template-Code mit zwei Offsets compiled, Differenz liefert affine Formel.
- **Konkretisierungen:**
  * P23 Khan (Cluster D): DynamicAdaptivePrefetchingStrategy + AffineOffsetAdaptationStrategy + CostBenefitGatedPrefetchStrategy
  * P25 Mahling Coro (Cluster E): FB_FULL Performance-Counter als Trigger fuer Half/Full-Node-Switch
- **Visitor-Variante:** `CacheEngineStrategy` (Runtime-adaptiv)
- **Verbindung zu Saeule B:** Verbraucht `ILivePlatformModel.measured_miss_latency` und Hardware Performance Counter.

### Familie F24: TelemetryDrivenStrategy (PathReadCounter + Hot-Path-Detection)
- **Concept-Klasse:** `ITelemetryDrivenStrategy` (Konkretisierung von `ICacheStrategy`, Achse 11)
- **Dach-Idee:** Per-Block/per-Knoten-Counter + Worker-Thread → bauen Hot-Path-Index auf; Layout wird periodisch retroaktiv neu organisiert.
- **Konkretisierungen:**
  * P26 Zhang Index (Cluster E): PathReadCounter (per-Block, separater Storage), MonitorClusteringAlgorithm
  * P27 Zhang Hierarchical (Cluster E): Bundle-Identification (Call-Graph, Threshold 200 KB), Compression Buffer 16-Entry FIFO
  * P28 Kuehn (Cluster E): PerNodeHistogram pro Comparison Key
  * P28 Kuehn-Mail 2026-05-08 (Cluster E, NEU): LeafOnlyCounter, LeafOnlySampledCounter<N>, RetroactiveAggregation, ProbabilityHintsHeader
- **Visitor-Variante:** `CacheEngineStrategy` (Cache-Coherence-bewusst)
- **Verbindung zu Saeule B:** Verbraucht `ILivePlatformModel.coherency_pressure` zur Vermeidung von Counter-Storm.

### Familie F25: SyncMechanikenStrategy (Concurrency-Cache-Strategy)
- **Concept-Klasse:** `ISyncMechanikenStrategy` (Konkretisierung von `ICacheStrategy`, orthogonal Saeule)
- **Dach-Idee:** Synchronisations-Mechanik (OLC, ROWEX, RCU, HazardPointers) entscheidet ueber Reader/Writer-Asymmetrie und Cache-Line-Bouncing-Verhalten.
- **Konkretisierungen:**
  * P03 Masstree (Cluster B): Hand-over-Hand Optimistic Locking (Vinsert/Vsplit-Counter)
  * P06 B^2-Tree (Cluster B): Optimistic Lock Coupling (OLC)
  * P07 Wormhole (Cluster B): QSBR RCU + RW-Lock + MutEx fuer 3 Operation-Klassen
  * P08 ART OLC (Cluster F): OLC + ROWEX (5-Schritt + 4-Schritt-Protokoll)
  * P29 RCU McKenney (Cluster F): RCU mit Grace Period + Quiescent States
  * P30 Hazard Pointers (Cluster F): HP wait-free, single-word-CAS, kein Scheduler-Support
  * P02 HOT (Cluster A): Copy-on-Write fuer Concurrent Reads (Obsolete-Marker, ROWEX)
- **Visitor-Variante:** beide moeglich — BaseEngineStrategy fuer "kein Sync" / CacheEngineStrategy fuer "Cache-friendly Sync"
- **Verbindung zu Saeule B:** Verbraucht `IConcurrencyProtocol`, `IInterconnect.cache_coherence_latency`.

### Familie F26: StrideAccessPatternStrategy (Strided > Sequential)
- **Concept-Klasse:** `IStrideAccessPatternStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Bei AVX-512-faehiger Plattform mit grossem TLB+Hardware-Prefetcher → strided scalar Pattern outperformed simd-sequential. Stride-Size auf TLB-Capacity + Prefetcher-Stream-Limit abgestimmt.
- **Konkretisierungen:**
  * P32 To-Stride TUD (Cluster F): strided-unrolled mit Partition-Count 30-42 (Sapphire Rapids), 127.32 MiB Stride
- **Visitor-Variante:** `CacheEngineStrategy`
- **Verbindung zu Saeule B:** Verbraucht `ILivePlatformModel.dtlb_capacity`, `prefetcher_stream_limit`, `cache_associativity`.

### Familie F27: NFP-DecoratorStrategy (Heterogene Memory-NFP-Awareness)
- **Concept-Klasse:** `INfpDecoratorStrategy` (Konkretisierung von `ICacheStrategy`, Saeule-B-naehernd)
- **Dach-Idee:** Allokationen tragen Non-Functional-Memory-Properties (latency, throughput, persistence, reliability, wearout, random accessibility, cache coherence) als Decorator; V-malloc waehlt Tier (DRAM/HBM/NVRAM/CXL).
- **Konkretisierungen:**
  * P33 VAMPIR Poster (Cluster F): NFP-Decorator + V-malloc + Compensation/Migration
  * P25 Mahling (Cluster E): Local vs. Remote Latency, DDR4/HBM2/HBM3/LPDDR5X/GDDR Heterogenitaet
  * P22 Chen Fractal (Cluster D): MultiTierCacheStrategy mit Cache-Tier + Disk-Tier
- **Visitor-Variante:** `CacheEngineStrategy`
- **Verbindung zu Saeule B:** Verbraucht `IMemoryBandwidthModel`, `IInterconnect`, `IStorageMedium`.

### Familie F28: HardwareOffloadStrategy (iDMA, FPGA, Compute-near-Memory)
- **Concept-Klasse:** `IHardwareOffloadStrategy` (Konkretisierung von `ICacheStrategy`)
- **Dach-Idee:** Operationen werden zum Memory-Controller (iDMA) oder spezialisierten Beschleuniger (FPGA, Tomahawk-PE) verlagert; nur Ergebnisse zum CPU-Core.
- **Konkretisierungen:**
  * P31 Ungethuem TUD (Cluster F): iDMA mit Configurator/AGU/DataFetcher/Crawler; ISA-Extensions (WAH, Hash, MergeSort) auf Tomahawk-PEs
- **Visitor-Variante:** `CacheEngineStrategy`
- **Verbindung zu Saeule B:** Verbraucht `IHardwareExtension`, `IComputeOffload` (NEU).

### Familie F29: FilterStrategy (Approximate-Membership Geschwister von ISearchPage)
- **Concept-Klasse:** `IFilterStrategy` / `IApproximateMembershipStrategy` (Geschwister-Concept von `ISearchPageStrategy`)
- **Dach-Idee:** Filter mit One-Sided-Error-Garantie (no false negatives, FPR konfigurierbar). Bloom, SuRF, Cuckoo, ARF.
- **Konkretisierungen:**
  * P10 SuRF (Cluster A): SuRF-Filter mit FPR-Tuning, vier Encoding-Varianten
- **Visitor-Variante:** orthogonal zu BaseEngine/CacheEngine
- **Verbindung zu Saeule B:** Verbraucht `IFalsePositiveRateModel` und `IStorageMedium` (Filter spart I/O).

---

## 2. Tabelle: Familie x Paper-ID

Legende: ✓ = Familie zentral im Paper / (✓) = nur peripher erwaehnt

| Familie | P01 | P02 | P03 | P04 | P05 | P06 | P07 | P08 | P09 | P10 | P11 | P12 | P13 | P14 | P15 | P16 | P17 | P18 | P19 | P20 | P21 | P22 | P23 | P25 | P26 | P27 | P28 | P29 | P30 | P31 | P32 | P33 |
|---------|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|
| F1 AdaptiveFootprint | ✓ | ✓ |   |   | ✓ |   |   |   |   |   |   | ✓ |   | ✓ |   |   |   |   |   | ✓ |   |   |   |   |   |   | ✓ |   |   |   |   |   |
| F2 SuccinctEncoding |   |   |   | ✓ |   |   |   |   | ✓ | ✓ | ✓ | ✓ |   | ✓ |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
| F3 CacheLineAligned | ✓ | ✓ |   |   |   |   | ✓ |   |   |   | ✓ | ✓ |   | ✓ | ✓ |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | ✓ |   |
| F4 MultiCacheLineNode |   |   | ✓ |   |   |   |   |   |   |   |   |   | ✓ |   |   |   |   |   |   |   | ✓ | ✓ |   |   |   |   |   |   |   |   |   |   |
| F5 SoftwarePrefetch |   | ✓ | ✓ |   |   |   |   |   |   | ✓ |   |   |   | ✓ | ✓ |   |   |   |   |   | ✓ | ✓ |   | ✓ | ✓ | ✓ |   |   |   |   |   |   |
| F6 PointerChasingResolution |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | ✓ | ✓ |   |   | ✓ |   |   |   |   |   |   |   |
| F7 SimdAcceleratedLookup | ✓ | ✓ | (✓) |   |   |   |   |   |   | ✓ |   |   |   |   |   |   |   |   |   | ✓ |   |   |   |   |   |   |   |   |   | ✓ |   |   |
| F8 PathCompression | ✓ | ✓ |   | ✓ | ✓ | ✓ | ✓ | ✓ |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
| F9 LayerDependentEncoding |   | ✓ |   |   | ✓ |   |   |   |   | ✓ |   |   |   |   |   |   |   |   |   | ✓ |   |   |   |   |   |   | ✓ |   |   |   |   |   |
| F10 PointerTagDispatch | ✓ | ✓ |   |   | ✓ |   | ✓ |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
| F11 EmbeddedSecondaryIndex |   |   |   |   |   | ✓ | ✓ |   |   |   | ✓ |   |   |   |   |   |   |   |   |   |   | ✓ |   |   | ✓ |   |   |   |   |   |   |   |
| F12 IndirectionVector |   |   | ✓ |   |   | ✓ | ✓ |   |   |   |   |   |   |   | ✓ |   |   |   |   | ✓ |   |   |   |   |   |   |   |   |   |   |   |   |
| F13 CacheObliviousLayout |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | ✓ | ✓ | (✓) |   |   |   | (✓) |   |   |   |   |   |   |   |   |   |   |
| F14 CacheSensitiveMultiLevel |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | ✓ | ✓ |   |   |   |   |   |   |   | ✓ |   |   |   |   |   |
| F15 ProbabilityWeightedLayout |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | ✓ |   |   |   |   |   |   |   |   |   |   | ✓ |   |   |   |   |   |
| F16 Compression |   |   |   | (✓) |   |   |   |   |   |   |   |   |   |   | ✓ |   |   |   |   | ✓ |   |   |   |   |   |   | (✓) |   |   |   |   |   |
| F17 PoorMansNormalizedKey |   |   |   |   |   |   |   |   |   |   |   |   |   |   | ✓ |   |   |   |   | ✓ |   |   |   |   |   |   | (✓) |   |   |   |   |   |
| F18 NoSharedWrite |   |   | ✓ |   |   |   |   | ✓ |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | ✓ | ✓ |   |   |   |
| F19 HotColdLayerEncoding (Filter) |   |   |   |   |   |   |   |   |   | ✓ |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
| F20 BlockOrientedRankSelect |   |   |   | ✓ |   |   |   |   | ✓ | ✓ |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
| F21 VirtualMemoryRewiring |   |   |   |   | ✓ |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
| F22 CodeSpecialization |   |   |   |   |   |   |   |   |   |   | ✓ | ✓ |   | ✓ |   |   |   |   |   |   |   |   | ✓ |   |   |   |   |   |   |   |   |   |
| F23 AdaptiveRuntimePrefetchDistance |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | ✓ | ✓ |   |   |   |   |   |   |   |   |
| F24 TelemetryDriven |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | ✓ | ✓ | ✓ |   |   |   |   |   |
| F25 SyncMechaniken |   | ✓ | ✓ |   |   | ✓ | ✓ | ✓ |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | ✓ | ✓ |   |   |   |
| F26 StrideAccessPattern |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | ✓ |   |
| F27 NFP-Decorator |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | (✓) |   | ✓ |   |   |   |   |   |   |   | ✓ |
| F28 HardwareOffload |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | ✓ |   |   |
| F29 FilterStrategy |   |   |   |   |   |   |   |   |   | ✓ |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |

---

## 3. Konkrete neue Concept-Klassen (REV 3 Vorschlag)

### Paket A: ISearchPage / Layout-Verwandt
- `IAdaptiveFootprintStrategy` (P01, P02, P05, P12, P14, P20, P28) — Form-Anpassung an Daten-Population
- `ISuccinctEncodingStrategy` (P04, P09, P10, P11, P12) — pointer-frei, asymptotisch optimaler Footprint
- `ICacheLineAlignedStrategy` (P01, P02, P07, P11, P12, P14, P15, P32) — Knoten-Groesse = N · cache_line
- `IMultiCacheLineNodeStrategy` (P03, P13, P21, P22) — Knoten umspannt 4-16 Lines mit parallel Prefetch
- `IPathCollapseStrategy` (P01, P02, P04, P05, P06, P07, P08) — Lazy Expansion + Subtree-Collapsing
- `ILayerDependentEncodingStrategy` (P02, P05, P10, P20, P28) — Hot/Cold-Layer-Trennung
- `IPointerTagDispatchStrategy` (P01, P02, P05, P07) — Type-Bits in LSB
- `IEmbeddedSecondaryIndexStrategy` (P06, P07, P11, P22, P26) — page-local Sub-Tree
- `IIndirectionVectorStrategy` (P03, P06, P07, P15, P20) — logische vs. physikalische Reihenfolge
- `ICacheObliviousLayoutStrategy` (P16, P17, P18 als Special Case, P22) — levels-unkenntlich
- `ICacheSensitiveMultiLevelLayoutStrategy` (P18, P19, P28) — multi-level mit α-Parameter
- `IProbabilityWeightedLayoutStrategy` (P16, P28) — workload-distribution-aware
- `ICompressionStrategy` (P15, P20) — order-preserving + prefix/suffix-truncation
- `IPoorMansNormalizedKeyStrategy` (P15, P20) — 4-Byte-Heads als Sub-Search

### Paket B: Prefetch + Runtime-Adaption
- `ISoftwarePrefetchStrategy` (P02, P03, P10, P14, P15, P20, P21, P22, P25, P26, P27) — explizite Prefetch-Instruktionen
- `IPointerChasingResolutionStrategy` (P21, P22, P26) — Jump-Pointer-Arrays / Linearization
- `IAdaptiveRuntimePrefetchDistanceStrategy` (P23, P25) — Live-Counter-driven
- `ITelemetryDrivenStrategy` (P26, P27, P28 + Kuehn-Mail 2026-05-08) — PathReadCounter, Hot-Path-Detection mit Coherence-Awareness
- `IStrideAccessPatternStrategy` (P32) — strided > simd-sequential bei grossem TLB+Prefetcher

### Paket C: Sync, Concurrency, Reader/Writer-Asymmetrie
- `INoSharedWriteStrategy` (P03, P08, P29, P30) — Reader schreiben niemals
- `ISyncMechanikenStrategy` (P02, P03, P06, P07, P08, P29, P30) — OLC, ROWEX, RCU, HazardPointers
- `IConcurrencyProtocol` (eigenes Concept) mit Sub-Klassen `OLC`, `ROWEX`, `RCU`, `HazardPointer`, `EpochBasedReclamation`

### Paket D: SIMD / ISA / Hardware
- `ISimdAcceleratedLookupStrategy` (P01, P02, P10, P20, P31) — SSE/AVX2/AVX-512/NEON
- `IBlockOrientedRankSelectStrategy` (P04, P09, P10) — Cache-Line-aligned LUT, popcount
- `IVirtualMemoryRewiringStrategy` (P05) — virtual<->physical mapping
- `ICodeSpecializationStrategy` (P11, P12, P14, P23) — compile-time loop-unrolling
- `IHardwareOffloadStrategy` (P31) — iDMA, FPGA, Tomahawk-PE

### Paket E: NFP, Filter, Tiering
- `INfpDecoratorStrategy` (P22, P25, P33) — heterogene Memory-NFP
- `IFilterStrategy` / `IApproximateMembershipStrategy` (P10) — Geschwister von ISearchPageStrategy
- `IHotColdLayerEncodingStrategy` (P10) — Spezialform F19 fuer Filter

### Paket F: Orthogonale Concept-Marker (nicht direkt ICacheStrategy, aber Properties)
- `ICompositionMode` mit Werten `OneNodePerPage` (klassisch ART/CSB+) vs. `MultipleNodesPerPage` (HOT, CoCo, START)
- `IUpdatability` mit Werten `Static`, `BulkUpdate`, `Incremental`, `Concurrent`
- `ISpaceGuarantee` mit Sub-Klassen `WorstCaseBoundPerKey`, `AsymptoticInfoTheoreticBound`, `EmpiricalBoundOnly`
- `ICacheStrategyAwareness` mit Werten `CacheOblivious`, `CacheSensitive`, `Hybrid`
- `ILayoutInvariant` mit Sub-Klassen `WeightBalance`, `VEBLayout`, `DensityThreshold`, `RootBlockProbability`, `NeighborhoodConnectedness` (P19, α-tunable)
- `IAdaptationTrigger` mit Sub-Klassen `OnEveryStructureModification`, `OnLayoutDegradationThreshold`, `Periodic`, `Manual`
- `ICompositeStrategy` (P19) — Komposition Builder + Maintenance
- `IPartialKeyEncoding` (8/16/32-Bit-Varianten, P02)
- `IBranchDispatchStrategy` (P01) — per-Node-Type findChild
- `ISpanWidthStrategy` (1 Byte / variable / multi-level, P01/P02/P04/P05)
- `IKeyTransformStrategy` / `IKeyNormalizer` (P01, P15)
- `IPathCollapsePolicy` (P01, P02, P04, P06)
- `IFanoutGrowShrinkPolicy` (P01)
- `INodeOverflowResolutionStrategy` (P02 — 4-Wege Algorithmus)
- `IEncodingPool` + `IEncodingSelector` (P02, P04, P10)
- `ITopologyEncoding` (mit `LoudsTopology`, `DfudsTopology`, `BpTopology`, `PointerTopology`, `BitArrayTopology`) — P04, P09, P10
- `IRankSelectPrimitive` (P09, P10, P04)

---

## 4. Lueckenanalyse

### 4.1 Was haben wir uebersehen / nicht erfasst?

**Concept-Luecken in der REV-2-Hierarchie:**
1. **`IFilterStrategy` als Geschwister von `ISearchPageStrategy`** — komplett fehlend; SuRF (P10) bricht das Modell der "exakten Suche"; muss als Geschwister-Familie modelliert werden.
2. **`IConcurrencyProtocol`** — orthogonale Saeule C noetig; OLC/ROWEX/RCU/HP sind weder rein Saeule A noch rein Saeule B.
3. **`ITopologyEncoding` als orthogonal-zu-Layout Concept** — LOUDS/DFUDS/BP/Pointer sind alle alternative Encodings derselben Topologie, koennen mit jedem `INodeLayout` kombiniert werden (P04, P09, P10).
4. **`IKeyTransformStrategy`** — orthogonaler Aspekt zwischen User-Key und internem Trie-Key (P01 Binary-Comparable Keys, P15 KeyNormalization).
5. **`ICompositionMode`** als Marker fuer 1:N-Beziehung ISearchPage → INode (HOT, CoCo, START verwischen 1:1).
6. **`IUpdatability`** als Concept-Mixin (Static/BulkUpdate/Incremental/Concurrent) — fundamentale Achse die in REV 2 fehlt.
7. **`IDataAwareOptimizer` / `IBuildTimeOptimizer`** — DP-basierte Optimierung pro Knoten (P04 CoCo, P05 START) ist eine eigene Concept-Familie ueber `IHeuristic` hinaus.
8. **`IPlatformProbe` / `IModelAcquisitionStrategy`** — wie wird das `ILivePlatformModel` ueberhaupt gewonnen? P05 START zeigt CLFLUSH-basierte Probing.
9. **`IBranchPredictorModel`** als Plattform-Kennzahl — Mispredict-Cost ist real (P01 Tabelle III, P13 Cost-Modell).
10. **`IInstructionCacheLevel` / `ITemporalCacheStrategy`** — REV 2 modelliert nur Daten-Cache; Code-Cache fehlt (P15 Sektion 7).
11. **`IStrategyCompatibilityMatrix`** — viele Strategien konfligieren oder verstaerken sich; muss explizit modelliert werden (P15 explizit erwaehnt: "they often conflict").
12. **`IRebuildScheduler` / `IRebuildCostModel`** — VACUUM-aehnliche Trigger fuer Self-Tuning (P05 START); Bauzeit-Kosten (P04 CoCo O(N h^2)) fehlen.
13. **`IWorkloadModel`** als first-class Citizen — bisher nur implizit (Read-Only/Read-Mostly/Write-Heavy/Mixed/Skewed/Range-Heavy).
14. **`IFalsePositiveRateModel`** als Quality-of-Service-Property fuer Filter (P10).
15. **`IStorageMedium` + `IPageCacheModel`** — DRAM/NVRAM/SSD/HDD-Hierarchie + OS-Page-Cache + App-Block-Cache (P10 Sektion 6, P22 fpB+-Tree).
16. **`IPositionalCorrespondencePrefetch`** als Concept fuer Prefetch basierend auf Layout-Invarianten (P10).
17. **`IIteratorStateCacheStrategy`** — wenn Iteratoren komplexen State haben (P10 per-level cursors).

### 4.2 Welche Paper-Hinweise sind nicht in einer Familie?

- **P02 HOT Determinismus-Conjecture (Sektion 3.3)** — gleiche Struktur unabhaengig von Insertion Order. Concept `IInsertionOrderInvariance` waere sinnvoll, aber ungestuetzt.
- **P03 Masstree Sequential-Insert-Heuristic (Sektion 4.3)** — bei sequentiellem Insert wird alter Knoten leer gelassen; kein vollstaendiger Split. Eine `SequentialInsertOptimizationHeuristic`.
- **P10 SuRF Update-Mechanismus (Appendix A)** — hybrid mit dynamic trie + tombstone bit-array; nur Skizze, keine Familie.
- **P14 ConfigurationTable als IHeuristic-Wissensbasis** — gehoert eher zu Saeule B (`ConfigurationLookupHeuristic`).
- **P15 MicroServer-Threading (Sektion 7)** — Temporal Locality ueber Code-Cache; orthogonal zu allen Daten-Cache-Strategien.
- **P19 Hyder Use-Case (Copy-on-Write Indexes)** — Production-Use-Case fuer Layout-Invariante; gehoert zu `IConcurrencyProtocol` mit COW-Variante.
- **P22 Aggressive-Placement vs. Overflow-Page (Sektion 3.2.1)** — heuristische Entscheidung, gehoert zu `IGranularityMismatchResolver` (NEU).
- **P26 Cost Model (Eq. 1-4)** — sollte als generisches `ICacheCostModel` formalisiert werden (NEU).
- **P27 Bundle-Identification Algorithm 1** — Coarse-grained Path-Prefetch fuer Instruktionen; analog auf Daten uebertragbar (`BundleDataPrefetchStrategy` waere offen).
- **P32 Memory-/Bank-/Rank-Level-Parallelism** (Refs [6, 13, 22]) — noch nicht als Concept-Klasse formalisiert.
- **P33 Compensation/Migration** — transparente Daten-Migration zwischen Memory-Tiers; fehlt als Concept (`IMigrationPolicy`).
- **P28 Kuehn-Mail 2026-05-08 Erweiterungen** — LeafOnlyCounter, RetroactiveAggregation als BARRIERE; sind PRT-ART-Innovation nicht im Paper.

### 4.3 Welche zusaetzlichen Concept-Klassen koennten sinnvoll sein?

**Aus der Synthese der Cluster-Synthese-Sektionen abgeleitet:**

1. **`IBudgetGuarantee`** — Worst-Case-Bytes pro Key als Invariante (P01 ART 52 B/Key, P05 START gleich, P09 Jacobson 2n+o(n)).
2. **`ITwoGranularitySearchStrategy`** — Search ueber zwei Tier-Ebenen (Cache-Page + in-page Tree), eine Variante von `IEmbeddedSecondaryIndexStrategy` (P22).
3. **`IDualJumpPointerArrayStrategy`** — Dual-Tier-Prefetching (Cache + Disk), Spezialisierung von F6 (P22).
4. **`IGranularityMismatchResolver`** mit Sub-Klassen `OverflowResolverStrategy`, `OffsetCompressionResolverStrategy`, `AdaptiveNodeSizeResolverStrategy` (P22).
5. **`IRuntimeAdaptiveHeuristic`** — Lambda-basierte Heuristik mit Live-Counter-Inputs; passt zu DecisionLambdaTree-Architektur (P23).
6. **`IFractalLayoutStrategy<OuterTier, InnerTier>`** — selbst-aehnliche Layout-Composition (P22).
7. **`IBundlePrefetchStrategy`** — coarse-grained Path-Prefetch fuer N adjacent ISearchPages (P27 fuer Instruction; offen fuer Daten).
8. **`ICompressionBufferStrategy`** — 16-Entry FIFO Spatial-Region-Encoding fuer ICacheLine-Set-Prediction (P27).
9. **`ILocalAlphabetStrategy`** — pro Knoten eigenes Alphabet (P04).
10. **`ISpaceTimeTradeOffParameter`** als Tuning-Knopf (P04 alpha, P19 α, P26 forgetting-factor w).
11. **`IPlatformAwareSizingModel`** — zusammengesetzter Concept-Type, der Saeule-B-Hardware-Modelle in eine Auswahl-Heuristik fuer Saeule-A-Strukturen verbindet (P13).
12. **`IIntegrityProofStrategy`** — Postfix-Verifikation nach Trie-Traversal (P02 HOT Patricia, P10 SuRF Suffix-Vergleich) — koennte `IKeyVerificationStrategy` heissen.
13. **`IConcurrencyDiscipline`** mit den 8 von P08-Synthese identifizierten Disziplinen (Page, Node, Array, DataStructure, Path, MemoryRead, MemoryWrite, MemoryReadWrite, SimdThread, SimdFlow).
14. **`ISliceAccessor`** — k-Byte-Slice-Reader (P03 8-Byte Integer-Slice).
15. **`ITrieLayerStrategy`** als Sub-Pattern von `ISearchPagesStrategyPattern` (P03 Slice-Layer + P07 Anchor-Praefix-Layer).
16. **`IAtomicSlotIndirection`** — generalisiert P03 Permutation-Field, P06 Range-Array.
17. **`IAnchorKey`** — synthetische Borderline-Keys mit Ordering- + Prefix-Constraint (P07).
18. **`INodeGroup` / `ISegmentedNodeGroup`** — contiguous Sibling-Storage fuer firstChild-Pointer + Arithmetic (P12).
19. **`IPlatformProbe`** mit `ClflushNodeProbe`, `LatencyProbe`, `BranchPredictorProbe`, `SimdThroughputProbe` (P05).
20. **`IPlatformAwareSizingModel`** = `IHeuristic` + `ICostModel` + `ILivePlatformModel` (P13).

### 4.4 Hauptkonvergenz aller 33 Paper

Es kristallisieren sich **drei Meta-Achsen** heraus, die in REV 3 explizit modelliert werden sollten:

**Meta-Achse 1: Awareness-Level**
- Cache-Oblivious (P16, P17, P18-Special) — funktioniert auf jedem Level
- Cache-Sensitive (P18, P19, P28, P32) — kennt konkrete Cache-Parameter
- Cache-Adaptive (P05, P20, P23, P25, P26, P28-Mail) — Live-Plattform-Modell ist Input

**Meta-Achse 2: Compositionality**
- Homogen (P01, P11, P12, P21) — alle Knoten gleich
- Heterogen-Adaptiv (P02, P05, P20) — pro Knoten verschieden, gewaehlt durch Heuristic
- Hierarchisch-Fraktal (P22) — pro Tier verschieden, rekursiv komponiert
- Orthogonal-Runtime-Parametriert (P23) — gleicher Algorithmus, parametrisiert per Runtime

**Meta-Achse 3: Dynamicity**
- Static (P04, P09, P10, P11, P16, P17 partial) — rebuild-only
- BulkUpdate (P04 partial) — periodisches Re-Layout
- Incremental (P01, P02, P03, P05, P12, P19, P20) — single insert/delete
- Concurrent (P02, P03, P06, P07, P08, P29, P30) — mit Sync-Mechaniken

Diese drei Meta-Achsen sind in REV 2 nicht explizit modelliert und sollten in REV 3 als orthogonale Concept-Marker eingefuehrt werden.

### 4.5 Konkrete OFFEN-Punkte fuer Diplomarbeit

Aus den paper-spezifischen OFFEN-Listen sind die folgenden Punkte fuer die Diplomarbeit besonders relevant:

- **NUMA-Awareness** durchgehend schwach (Cluster B explizit, Cluster D, Cluster E) — keine Plattform-Modellierung fuer ICoreToThreadMap mit NUMA-Topologie ueber alle 33 Paper.
- **Cache-Coherence-Anti-Pattern bei PerNodeCounter** (P28) — User-Erkenntnis 2026-05-08, fuehrt zu LeafOnlyCounter/RetroactiveAggregation-Innovation.
- **Hardware-Counter-Feedback fehlt** — alle Strategien sind STATISCH; kein Paper implementiert ein `ILivePlatformModel`-getriebenes adaptives Resizing.
- **6-Flavor-Klassifikation RCU (qsbr/mb/membarrier/signal)** — kommt aus spaeterer URCU-Literatur (Desnoyers 2012), nicht im Original-RCU-Paper.
- **Workload-aware Cost-Function** — P05 START nennt es als zukuenftige Arbeit; auch P28 Sliding-Window-Drift-Detection in Future Work.
- **Multi-Level-Local-Relocation** (P19 Sektion 6) — als nicht-trivial diskutiert; Diplomarbeits-Forschungspotenzial.
- **Probability-weighted Trie-Layout** (P16-Methode auf Cluster A) — bisher nicht in Trie-Literatur angewendet.
- **`ITopologyEncoding` als orthogonal-zu-Layout** — fundamentale Concept-Trennung, die in REV 2 fehlt.
