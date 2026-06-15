# Inventur Phase5_UML_Detail Taxonomien (Dateien 11/12/13)

**Stand:** 2026-05-11
**Quelle:** `11_cache_strategy_taxonomie.md` (610 Z), `12_algorithmus_strategie_taxonomie.md` (916 Z), `13_saeule_b_plattform_modell_konkretisierung.md` (631 Z)
**Zweck REV5:** Vollstaendige Inventur aller Bausteine fuer Architektur-Skizze REV5 + drawio.

---

## A) 29 Cache-Familien F1-F29 aus `11_cache_strategy_taxonomie.md`

| ID | Concept-Klasse | Konkretisierungen (Paper) | Hybrid-Status |
|----|----------------|---------------------------|---------------|
| F1 | `IAdaptiveFootprintStrategy` | P01 ART (4 Node-Typen), P02 HOT (9 Layouts), P05 START (Multilevel), P12 CSB+ (3 Allocations), P14 CSB+ Itanium, P20 B-Tree adaptive, P28 Kuehn HotPathLayout | **HYBRID** (P02 HOT 9-Layout, P05 START Multi+Rewired, P12 3 Modi, P14 ConfigTable, P20 KeyAdaption, P28 HotPath) |
| F2 | `ISuccinctEncodingStrategy` | P09 Jacobson LOUDS, P04 CoCo (EF/PA/BV/DE Pool), P10 SuRF (LOUDS-Dense+Sparse), P11 CSS, P12 CSB+ partial-pointer, P14 NodeGroupContiguous | **HYBRID** (P10 SuRF LOUDS-DS, P04 CoCo Encoding-Pool); P11/P12 atomar |
| F3 | `ICacheLineAlignedStrategy` | P01 ART (16B Header), P02 HOT (Compound 64-472B), P07 Wormhole (64B Hash-Slot), P11 CSS, P12 CSB+, P14, P15 Survey, P32 To-Stride | **ATOMAR** (alle Konkretisierungen sind atomare Aligning-Strategien) |
| F4 | `IMultiCacheLineNodeStrategy` | P03 Masstree (256B=4 Lines), P13 Hankins/Patel (256-512B), P21 Chen pB+ (Wide-Node w=8), P22 Chen Fractal (in-page Tree mit adaptive Width) | **HYBRID** (P22 Fractal in-page+adaptive, P21 Wide+JumpPointer+ChunkedList, P13 Cost-Modell-getrieben) |
| F5 | `ISoftwarePrefetchStrategy` | P02 HOT, P03 Masstree, P10 SuRF, P14 Itanium (lfetch), P15 Graefe Survey, P21 Chen, P22 Chen Fractal (Dual-Jump), P25 Mahling Coro (Full+Half), P26 Zhang Index (3 Prefetcher CP+PP+MP), P27 Zhang Hierarchical | **HYBRID** (P26 3-Komponenten, P22 DualJump, P25 Full+Half, P14 lfetch+RangeScan, P15 Multi-Cache+IndirVec+Multi-Record, P21 Wide+JumpPointer) |
| F6 | `IPointerChasingResolutionStrategy` | P21 Chen pB+ (JumpPointerArray ext+int), P22 Fractal (DualJumpPointer), P26 Zhang (JumpPointerQueue MVCC) | **HYBRID** (P22 Dual-Ebene, P26 Queue+MVCC+2-ahead) |
| F7 | `ISimdAcceleratedLookupStrategy` | P01 ART (SSE Node16), P02 HOT (AVX2+PEXT/PDEP), P03 Masstree, P10 SuRF (128-Bit SSE Sparse), P20 B-Tree adaptive, P31 Ungethuem Tomahawk-PE | **ATOMAR** (Konkretisierungen sind atomare SIMD-Strategien); P02 HOT BMI2+AVX2+SingleMask+MultiMask Bestandteil F1-Aufloesung |
| F8 | `IPathCollapseStrategy` | P01 ART (Lazy+Pessimistic+Optimistic), P02 HOT (k-constrained Compound), P04 CoCo (Macro-Node Collapsing), P05 START (Multilevel), P06 B^2-Tree (Span LCP), P07 Wormhole (Anchor+LeafList+MetaTrieHT), P08 ART OLC | **ATOMAR** (Konkretisierungen sind atomare Collapse-Tactics — keine Aufloesung in §10) |
| F9 | `ILayerDependentEncodingStrategy` | P02 HOT (k-constrained oben), P05 START (Multilevel oben), P10 SuRF (Dense oben+Sparse unten Cutoff R=64), P20 (AdaptiveLeafSelector), P28 Kuehn (HotPath) | **TEILWEISE HYBRID** (P10 SuRF Cutoff aufgeloest in F2; P20 KeyAdaption+OperationAdaption aufgeloest in F1) |
| F10 | `IPointerTagDispatchStrategy` | P01 ART (Tagged Pointers), P02 HOT (Type-Bits LSB), P05 START (Slot-Identifikation), P07 Wormhole (low-order 48 bits) | **ATOMAR** |
| F11 | `IEmbeddedSecondaryIndexStrategy` | P06 B^2-Tree (Decision+Span pro 64KiB), P07 Wormhole (MetaTrieHT+MetaTrie+LeafList), P11 CSS (Embedded Directory), P22 Chen Fractal (in-page B+), P26 Zhang (PathPrefetcher+SearchBlockTable) | **HYBRID** (P06 Outer-B+ + Inner-Decision/Span; siehe `B2TreeRecursiveCommonPrefixCompositionCommand`; P07 Triple-Layer in §9 aufgeloest) |
| F12 | `IIndirectionVectorStrategy` | P03 Masstree (Permutation-Field 16x4-Bit), P06 B^2 (Range-Array), P07 Wormhole (Sort-By-Tag), P15 Graefe Survey, P20 (Slotted-Page-Hyperdesign) | **ATOMAR** |
| F13 | `ICacheObliviousLayoutStrategy` | P16 Bender (Cache-Oblivious Probability Greedy), P17 Bender (vEB+DynamicVEB+PackedMemory), P18 Saikkonen (vEB Special Case), P22 Chen Fractal (Mischform) | **TEILWEISE HYBRID** (P22 Fractal als Mischform; P17 vEB+DynamicVEB-PackedMemoryArray Komposit) |
| F14 | `ICacheSensitiveMultiLevelLayoutStrategy` | P18 Saikkonen 2008 (MultiLevelCacheSensitive+AliasingCorrection), P19 Saikkonen 2016 (LayoutInvariant+LocalRelocation alpha 1-6), P28 Kuehn (Hot Path Layout TLB-aware) | **HYBRID** (P19 Local + Global Reloc → `LayoutInvariantCompositionCommand`) |
| F15 | `IProbabilityWeightedLayoutStrategy` | P16 Bender (GreedyRootBlock + RelaxedGreedy), P28 Kuehn (HotPath Greedy) | **ATOMAR** |
| F16 | `ICompressionStrategy` | P15 Graefe Survey (Order-preserving Huffman, KeyNorm, PrefixSuffixTrunc, NextNeighborDiff), P20 (PrefixTruncation), P28 Kuehn (impliziert) | **ATOMAR** |
| F17 | `IPoorMansNormalizedKeyStrategy` | P15 Graefe Survey (Sec. 6.1), P20 (Heads + Hints 16 in 64B), P28 (impliziert) | **ATOMAR** |
| F18 | `INoSharedWriteStrategy` | P03 Masstree (lookups never dirty), P08 ART OLC (read-only readLockOrRestart), P29 RCU (no atomics), P30 Hazard Pointers (no shared writes) | **ATOMAR** |
| F19 | `IHotColdLayerEncodingStrategy` (Filter-Spezialform F9) | P10 SuRF (Base/Hash/Real/Mixed) | **ATOMAR** (4 Filter-Varianten parametrisierbar) |
| F20 | `IBlockOrientedRankSelectStrategy` | P09 Jacobson (Tarjan-Yao), P10 SuRF (B=64 Dense, B=512 Sparse), P04 CoCo (SDSL/sux/ds2i) | **ATOMAR** |
| F21 | `IVirtualMemoryRewiringStrategy` | P05 START (memfd_create + multiple mmap) | **ATOMAR** (Bestandteil F1 START-Aufloesung als `RewiredVirtualPhysicalCommand`) |
| F22 | `ICodeSpecializationStrategy` | P11 CSS (Hardcoded if-else), P12 CSB+ (basic/uniform/variable), P14 (LoopUnrolledBinarySearch), P23 Khan (TemplateSpecializer mit Bitwise Modification) | **TEILWEISE HYBRID** (P12 3 Varianten; P23 TemplateSpecializer aufgeloest in F23) |
| F23 | `IAdaptiveRuntimePrefetchDistanceStrategy` | P23 Khan (Dynamic+Affine+CostBenefitGated), P25 Mahling (FB_FULL Counter Half/Full-Switch) | **HYBRID** (P23 Khan Base+DistanceAdapt+LoopUnroll → `KhanRuntimeAdaptiveCompositionCommand`) |
| F24 | `ITelemetryDrivenStrategy` (Achse 11) | P26 Zhang Index (PathReadCounter + MonitorClustering), P27 Zhang Hierarchical (Bundle 200KB Threshold), P28 Kuehn (PerNodeHistogram), **P28 Kuehn-Mail 2026-05-08 NEU** (LeafOnlyCounter, LeafOnlySampledCounter\<N\>, RetroactiveAggregation, ProbabilityHintsHeader) | **HYBRID** (P28 Kuehn HotPath: LeafOnlyCounter+RetroactiveAggregation+GreedyHotPath → `KuehnHotPathOptimizationCompositionCommand`; P26 in F5 als 3-Prefetcher) |
| F25 | `ISyncMechanikenStrategy` | P03 Masstree (Hand-over-Hand OLC), P06 B^2 (OLC), P07 Wormhole (QSBR-RCU + RW-Lock + MutEx 3-Klassen), P08 ART OLC (5-Schritt+4-Schritt), P29 RCU McKenney (Grace+QS), P30 Hazard Pointers, P02 HOT (CoW Obsolete-Marker ROWEX) | **HYBRID** (P07 3-Klassen-Sync; P08 OLC+ROWEX 2 alternative Mechaniken) |
| F26 | `IStrideAccessPatternStrategy` | P32 To-Stride TUD (strided-unrolled Partition 30-42, 127.32 MiB Stride) | **ATOMAR** |
| F27 | `INfpDecoratorStrategy` | P33 VAMPIR (NFP-Decorator+V-malloc+Compensation/Migration), P25 Mahling (DDR4/HBM2/HBM3/LPDDR5X/GDDR), P22 Chen Fractal (Multi-Ebenen Cache+Disk) | **HYBRID** (P33 Decorator+V-malloc+Compensation; P25 Multi-Ebenen-Allocator) |
| F28 | `IHardwareOffloadStrategy` | P31 Ungethuem TUD (iDMA Configurator/AGU/DataFetcher/Crawler + WAH/Hash/MergeSort auf Tomahawk-PE) | **HYBRID** (iDMA-Komponenten als Sub-Atome) |
| F29 | `IFilterStrategy` (Geschwister von ISearchPage) | P10 SuRF (FPR-Tuning, 4 Encoding-Varianten) | **ATOMAR** (Filter-Concept; orthogonal zu BaseEngine/CacheEngine) |

**Zusammenfassung Hybrid-Status:** 14 Familien mit Hybrid-Konkretisierungen (F1, F2, F4, F5, F6, F9-T, F11, F13-T, F14, F22-T, F23, F24, F25, F27, F28); 15 atomare Familien (F3, F7, F8, F10, F12, F15, F16, F17, F18, F19, F20, F21, F26, F29).

---

## B) AUS 11: Welche F-Familien sind Hybrid-Layouts und muessten via Command-Pattern zerlegt werden? (User-Kritik K10)

§10 Tabelle 11_cache_strategy_taxonomie.md liefert die explizite Zerlegungs-Tabelle. Stand 11_md ist **TEILWEISE ZERLEGT**: §10 ist ein Skeleton mit 8 expliziten Familien-Aufloesungen + Sammelhinweis "F8-F29 atomar mit Ausnahmen" — aber pro Hybrid wurde noch nicht jede atomare Sub-Command konkret benannt:

### Bereits aufgeloest in §10 (mit konkreten Atom-Commands):

1. **F1 P02 HOT** → 9 Atome (`SingleMask{8,16,32}PKEYCommand` + `MultiMask{8,16,32}x{8,16,32}Command`) → `HOTAdaptiveLayoutSelectionCompositionCommand`
2. **F1 P05 START** → `MultilevelNodeCommand` + `RewiredVirtualPhysicalCommand` + `Multinode4Command` → `STARTAdaptiveCompositionCommand`
3. **F1 P12 CSB+** → `SegmentedAllocation` + `FullPreallocated` + `BasicSinglePointer` → `CSBPlusAllocationModeCompositionCommand`
4. **F1 P14/P20/P28** → Verweise auf §9 in 12_md (siehe C/D unten)
5. **F2 P10 SuRF** → Verweis §9 → `CutoffLevelLoudsCompositionCommand`
6. **F2 P04 CoCo** → 4 Atome (`EliasFanoEncodingCommand` + `PackedArrayEncodingCommand` + `BitvectorEncodingCommand` + `DenseEncodingCommand`) → `CoCoEncodingPoolCompositionCommand`
7. **F4 P21** → 3 Atome (`WideNodePrefetch` + `JumpPointerArrayPrefetch` + `ChunkedLinkedListHint`) → `ChenPrefetchedBPlusCompositionCommand`
8. **F4 P13** → 3 Atome (`CostModelEvaluation` + `NodeSizeSelection` + `LargeNodePrefetch`) → `HankinsPatelCostModelCompositionCommand`
9. **F5 P25 Mahling Coro** → 2 Atome (`CoroutinedFullNodePrefetch` + `CoroutinedHalfNodePrefetch`) → `CoroutineSelectionCompositionCommand`
10. **F5 P14 Itanium** → 2 Atome (`LfetchExplicit` + `RangeScanLookahead`) → `ItaniumPrefetchCompositionCommand`
11. **F5 P15 Graefe Survey** → 4 Atome (`MultiCacheLinePrefetch` + `IndirectionVector` + `MultiRecordHint` + `PostLocationCheck`) → `GraefePrefetchSurveyCompositionCommand`
12. **F6 P26 Zhang JumpPointerQueue** → 3 Atome (`JumpPointerQueue` + `MvccVersionChain` + `TwoAheadLookup`) → `ZhangFGCSPointerResolutionCompositionCommand`

### Schwammig pauschalisiert in §10 (KRITIK K10!):

13. **F8 IPathCollapseStrategy** — 7 Konkretisierungen, KEINE Aufloesungstabelle. P02 HOT (k-constrained), P04 CoCo (Macro+DataAware DP), P05 START (Multilevel) sind klar hybride Mehrkomponenten-Strategien.
14. **F11 IEmbeddedSecondaryIndexStrategy** — 5 Hybride (P06, P07, P11, P22, P26), nur P06+P07 in 12_md §9 aufgeloest, P11/P22/P26 stehen ohne expliziten Eintrag in 11_md §10.
15. **F13 ICacheObliviousLayoutStrategy** — P17 (vEB+DynamicVEB+PackedMemory+BufferNodes+Indirected = 4 Sub-Strategien) NICHT aufgeloest.
16. **F14 ICacheSensitiveMultiLevelLayoutStrategy** — P19 wird in §10 als `LocalRelocationCommand+GlobalRelocationCommand → LayoutInvariantCompositionCommand` markiert, aber die Sub-Strategien P18 (MultiLevelCacheSensitive + AliasingCorrection) sind ohne Atom-Aufloesung.
17. **F22 ICodeSpecializationStrategy** — P12 (basic+uniform+variable 3 Varianten) und P23 (TemplateSpecializer 2-5 Modify-Locations) NICHT als atomare Commands listet.
18. **F25 ISyncMechanikenStrategy** — P07 Triple (RCU+RW-Lock+MutEx) und P08 (OLC+ROWEX) sind durch §9 in 12_md grob abgehandelt, in 11_md §10 nur "F-Sync-Familien" pauschal genannt — KEINE Atom-Liste.
19. **F27 INfpDecoratorStrategy** — P33 VAMPIR multi-Komponenten (NFP-Decorator + V-malloc + Compensation + Migration) NICHT zerlegt.
20. **F28 IHardwareOffloadStrategy** — P31 iDMA (Configurator/AGU/DataFetcher/Crawler) als Komponenten genannt, aber kein Composition-Command-Mapping.

**FAZIT zu B:** §10 ist UNVOLLSTAENDIG. Die Tabelle nennt 12 voll aufgeloeste Hybride und sagt fuer F8-F29 pauschal "ueberwiegend atomar mit Ausnahmen". Das `F-Composition-uebergreifend` Catch-all (Wormhole, Masstree, B^2) ist Verweis auf 12_md §9 und nicht eigenstaendig in 11_md formalisiert. **8 Familien benoetigen explizite Atom-Aufloesung in REV5**: F8, F11 (P11/P22/P26), F13 (P17), F14 (P18), F22 (P12+P23), F25 (P07/P08), F27 (P33), F28 (P31).

---

## C) AUS 12: Algorithmus-Strategie-Familien (alle 4 Ebenen)

### Ebene A: ISearchPagesStrategyPattern (1 pro IFanout) — 1.1 + 1.2 + 1.3

**1.1 Patterns nach Komposition (10):**
1. `AllPagesUniformPattern` (P11/P12/P14/P21) — homogen
2. `LayerMixPattern` (P03 Masstree, P10 SuRF, P04 CoCo, P22 fpB+) — heterogen pro Layer
3. `InnerVsLeafPattern` (P02 HOT, P10 SuRF Dense/Sparse, P04 CoCo, P19 alpha-subgraph, P22) — heterogen pro Rolle
4. `HotVsColdPattern` (P26 Zhang FGCS, P28 Kuehn, P10 SuRF) — dynamisch heterogen
5. `DynamicRebalancePattern` (P05 START, P18, P19, P20 Mueller-Benson-Leis) — dynamisch
6. `HierarchicalFractalPattern` (P22 fpB+, P15 B-Trees-of-Cache-Lines, P06 B^2-Tree) — rekursiv
7. `OrthogonalRuntimeParametrizedPattern` (P23 Khan, P26, P14 ConfigTable) — parametriert
8. `MultiStrategyOrchestrationPattern` (P07 Wormhole, P26, P15) — orchestrierend heterogen
9. `HeterogeneousAdaptivePattern` (P20 Mueller-Benson-Leis) — dynamisch heterogen
10. `BoundaryNodePartitionPattern` (P20 Sequential-Insert FDL) — Sub-Pattern

**1.2 Patterns nach Adaptivitaet (6):**
11. `OfflineSelfTuningPattern` (P05 START)
12. `OnlineProbabilityRebalancePattern` (P28, P26)
13. `OnEveryStructureModificationPattern` (P19 Saikkonen Local Reloc)
14. `PeriodicGlobalRelocationPattern` (P19 Composite mit P18)
15. `BulkLoadLevelByLevelPattern` (P11/P12/P14)
16. `CompoundFastBuildPattern` (P02 HOT k-constrained, P04 CoCo Post-Order DP)

**1.3 Patterns nach Aufbauverfahren (5):**
17. `BfsLevelByLevelPagePackingPattern` (P18 Saikkonen)
18. `RecursiveDfsBlockPackingPattern` (P17 vEB, P11 CSS Build)
19. `ProbabilityGreedyPagePackingPattern` (P16 Bender, P28 Kuehn)
20. `PostOrderDpPattern` (P04 CoCo, P05 START Bellman-DP)
21. `RecursiveCommonPrefixDecompositionPattern` (P06 B^2-Tree)

### Ebene B: ISearchPagesStrategy (PLURAL — Structure-Pflege) — 5 Sub-Familien

**2.1 B+-Familie (12):** `BPlusTreePerLayerStrategy` (P03), `ClassicBPlusTreeStrategy`, `CompactedSearchTreeStrategy (CSS-Full)` (P11), `CompactedSearchTreeStrategy (CSS-Level)` (P11), `CSBPlusTreeStrategy (Basic)` (P12), `CSBPlusTreeStrategy (Segmented)` (P12), `CSBPlusTreeStrategy (Full pre-allocated)` (P12), `WideNodeBPlusStrategy (pB+)` (P21), `FractalBPlusStrategy (Disk-First)` (P22), `FractalBPlusStrategy (Cache-First)` (P22), `LargeNodeBPlusStrategy (256-512B)` (P13), `EmbeddedSecondaryIndexStrategy (B^2)` (P06)

**2.2 Trie-Familie (8):** `AdaptiveRadixTreeStrategy` (P01), `MultilevelAdaptiveRadixStrategy` (P05), `KConstrainedHotStrategy` (P02), `MacroNodeCollapsingStrategy (CoCo)` (P04), `LoudsDenseSparseStrategy` (P10), `JacobsonLoudsStrategy` (P09), `WormholeTripleStrategy` (P07), `PathCompressedTrieStrategy` (P01/P02)

**2.3 Hybrid-Familie (8):** `TripleHashThenBPlusStrategy (Wormhole)` (P07), `StaticPreSortedDirectoryStrategy` (P11), `EmbeddedDecisionSpanTreeStrategy (B^2)` (P06), `JumpPointerArrayStrategy (External chunked)` (P21), `JumpPointerArrayStrategy (Internal)` (P21), `DualJumpPointerArrayStrategy` (P22), `JumpPointerVersionChainStrategy` (P26), `MicroIndexingStrategy (Lomet)` (P22)

**2.4 Layout-Theorie-Familie (10):** `VanEmdeBoasLayoutStrategy` (P17), `DynamicVEBPackedMemoryArrayStrategy` (P17), `BufferNodesVEBStrategy` (P17), `IndirectedVEBStrategy` (P17), `CacheSensitiveMultiLevelLayoutStrategy` (P18), `LocalRelocationLayoutStrategy (alpha=2)` (P19), `LocalRelocationLayoutStrategy (alpha>2)` (P19), `ProbabilityWeightedRootBlockStrategy (DP)` (P16), `ProbabilityGreedyLayoutStrategy` (P16 Th. 1), `RelaxedGreedyLayoutStrategy` (P16 Th. 2), `CacheObliviousProbabilityLayoutStrategy` (P16 Th. 3), `BTreeOfCacheLinesStrategy (intra-page)` (P15), `VerticalPartitioningStrategy (Spalten-Layout)` (P15), `HotPathLayoutStrategy (HLS)` (P28)

**2.5 Adaptive Layout-Selectors (3):** `AdaptiveLeafSelectorStrategy` (P20), `OfflineSelfTuningStrategy` (P05), `ConfigurationLookupStrategy` (P14)

### Ebene C: ISearchPageStrategy (SINGULAR — pro Page) — 4 Sub-Familien

**3.1 Intra-Page Search-Strategien (22):** LinearScanWithinNode (P01/P03/P14/P28/P15), BinarySearchWithinNode (P11/P12/P14), LoopUnrolledBinarySearch (P11/P12), SimdParallelKeyComparison-SSE (P01 Node16, P10 Sparse), SimdParallelKeyComparison-AVX2 (P02 HOT), SimdParallelHeadComparison (P20), Fingerprinting-PointLookup (P20), DenseOffsetLookup-FDL (P20), HintNarrowedBinarySearch (P20), InterpolationSearch (P15), PoorMansNormalizedKeySearch (P15), RankSelectNavigation (P09/P10/P04), TwoCandidatePrefetchBinarySearch (P15), TaggedHashSlotLookup-Wormhole (P07), SpeculativeHashedAccess (P07), IncrementalHashing (P07), LoudsLookup (P09/P04/P10), DfudsRankAccess (P04), ExtensionSpanSearch-B^2 (P06), ByteRangeDecision-B^2 (P06), DiscriminativeBitsSelection (P02 HOT), PrefixingLinearSearch (P14)

**3.2 Intra-Page Insert/Update-Strategien (15):** PermutationFieldInsertion (P03), AdaptiveLayoutInsertion (P20), KConstrainedSubtreePartitioning (P02 HOT 4-Wege), LazyDeletion (P12/P14), LazySortInsertion-Fingerprinting (P20), SequentialInsertHeuristic (P03), SmartSplit (P07), BulkLoadLevelByLevelInsertion (P11/P12/P14), InsertionPathPrefetch (P21), SiblingRedistributionPrefetch (P21), RebuildOnSplit-B^2 (P06), BoundaryAwareSeparatorSelection-FDL (P20), NodeReplacement-ROWEX (P08), OverflowLeaf-Wormhole (P07), ContentionSplit (P20 vmcache)

**3.3 Intra-Page Layout-/Encoding-Strategien (28):** PrefixTruncation (P20/P15), Heads-PoorMansNormalized (P20/P15), Hints (P20), Fingerprinting-LeafLayout (P20), SemiDenseLeafLayout-SDL (P20), FullyDenseLeafLayout-FDL (P20), IndirectionVector (P06/Umbra), InfixSpeicherung-B^2 (P06), SpanNodeLcpCompression-B^2 (P06), LinearizedCompoundNode-HOT (P02), PointerElimination (P11/P12 partial), NodeGroupContiguous (P12/P14), SegmentedNodeGroup (P12), OrderPreservingCompression (P15), KeyNormalization (P15/P01), NextNeighborDifferencing (P15), PointerToExtentsCompression (P15), IntegerSliceFormation (P03), AdaptiveSuffixPlacement (P03), PartialKeyEncoding (P02 8/16/32), LcpAwareIntegerEncoding (P04), EncodingSelection (P04 EF/PA/BV/DE), AlphabetAwareEncoding (P04), SuffixTruncation (P10 SuRF 4 Varianten), PerNodeTypeFindChild (P01), MultilevelNode (P05), RewiredNode (P05), MultilevelNode4 (P05)

**3.4 Concurrency-Strategien innerhalb Page (9):** OptimisticLockCoupling-OLC (P03/P06/P08/P20), ROWEX (P02 HOT/P08), RCU (P29), HazardPointers (P30), EpochBasedReclamation (P02 HOT/P08), HandOverHandOptimistic (P03), QuiescentStateBased (P29), TripleClassConcurrency (P07), CopyOnWrite (P02 HOT/P19), DualHashTableCopyOnWrite (P07)

### Ebene D: IHeuristic (Wert-Berechnungen) — 5 Sub-Sektionen

(Detail siehe F unten — IHeuristic ist Saeule-A-Heuristics-Familie aus 12_md §4 mit ca. 60 Eintraegen ueber 4.1-4.5 + parallel saeule-B-Heuristics in 13_md §9)

---

## D) AUS 12: §9 Hybrid-Command-Pattern Aufloesungen — 17 Eintraege

§9 von 12_md liefert die Pflicht-Aufloesungs-Tabelle. **Vollstaendige Liste der 17 Aufloesungen:**

| # | Quelle Pattern | Atomare Strategy-Commands | HybridCompositionCommand |
|---|----------------|---------------------------|--------------------------|
| 1 | §1.1 LayerMixPattern (P03 Masstree) | `SliceLayerJumpCommand` + `BPlusPerLayerCommand` + `PermutationFieldInsertCommand` | `MasstreeSliceLayeredCompositionCommand` |
| 2 | §1.1 LayerMixPattern (P10 SuRF) | `LoudsDenseEncodingCommand` + `LoudsSparseEncodingCommand` | `CutoffLevelLoudsCompositionCommand` |
| 3 | §1.1 LayerMixPattern (P04 CoCo) | `MacroNodeCollapseCommand` + `PatriciaInnerExpandCommand` + `SuccinctEncodingPoolCommand` | `CoCoLevelLDecisionCompositionCommand` |
| 4 | §1.1 LayerMixPattern (P22 fpB+) | `DiskTierTraversalCommand` + `CacheTierTraversalCommand` | `FractalHierarchicalCompositionCommand` |
| 5 | §1.1 InnerVsLeafPattern (P02 HOT) | `CompoundContainerCommand` + `BiNodeSubtreeCommand` + `SingleMaskPartialKeyCommand` + `MultiMaskPartialKeyCommand` | `HOTCompoundCompositionCommand` |
| 6 | §1.1 InnerVsLeafPattern (P19 Saikkonen alpha) | `InnerSubgraphLayoutCommand` + `LeafSubgraphLayoutCommand` | `AlphaConnectedSubgraphCompositionCommand` |
| 7 | §1.1 HotVsColdPattern (P28 Kuehn) | `LeafOnlyCounterCommand` + `RetroactiveAggregationCommand` + `GreedyHotPathLayoutCommand` | `KuehnHotPathOptimizationCompositionCommand` |
| 8 | §1.1 HotVsColdPattern (P26 Zhang FGCS) | `CachePrefetcherCommand (CP)` + `PathPrefetcherCommand (PP)` + `MonitorPrefetcherCommand (MP)` | `ThreePrefetcherOrchestrationCompositionCommand` |
| 9 | §1.1 DynamicRebalancePattern (P05 START) | `OfflineCostMeasureCommand` + `BellmanDPLayoutCommand` + `LkmRewireCommand` + `MultilevelRebuildCommand` | `STARTSelfTuningCompositionCommand` |
| 10 | §1.1 HierarchicalFractalPattern (P22 fpB+) | (siehe #4) | `FractalHierarchicalCompositionCommand` |
| 11 | §1.1 HierarchicalFractalPattern (P15 B-Trees of Cache-Lines) | `IntraCachelineSubtreeCommand` + `InterCachelineTreeCommand` | `BTreesOfCachelinesCompositionCommand` |
| 12 | §1.1 HierarchicalFractalPattern (P06 B^2) | `OuterBPlusPageCommand` + `DecisionPageStrategyCommand` + `SpanPageStrategyCommand` | `B2TreeRecursiveCommonPrefixCompositionCommand` |
| 13 | §1.1 MultiStrategyOrchestrationPattern (P07 Wormhole) | `HashAnchorLookupCommand` + `BPlusHopLookupCommand` + `LeafLinkedListScanCommand` | `TripleLayerLookupCompositionCommand` |
| 14 | §1.1 MultiStrategyOrchestrationPattern (P15 Strategy-Mix) | (parametriert pro Mix) | `GraefeStrategyMixCompositionCommand` |
| 15 | §1.1 OrthogonalRuntimeParametrizedPattern (P23 Khan) | `BasePrefetchCommand` + `DistanceAdaptCommand` + `LoopUnrollAdaptCommand` | `KhanRuntimeAdaptiveCompositionCommand` |
| 16 | §1.1 OrthogonalRuntimeParametrizedPattern (P14 ConfigTable) | `NodeSizeSelectCommand` + `SearchMethodSelectCommand` + `ConfigurationLookupCommand` | `SamuelConfigurationTableCompositionCommand` |
| 17 | §1.1 HeterogeneousAdaptivePattern (P20 B-Trees-Are-Back) | `KeyAdaptionCommand` (mit `ComparisonSubCommand` + `FingerprintingSubCommand`) + `OperationAdaptionCommand` (mit `SDLSubCommand` + `FDLSubCommand`) | `BTreesAreBackHeterogeneousAdaptiveCompositionCommand` |
| (18) | §1.1 BoundaryNodePartitionPattern (P20 sequential-FDL) | `SplitPointSelectCommand` + `DenseLayoutPreserveCommand` | `SequentialInsertCompositionCommand` |

(17 vorgesehen, 18. ist Sub-Pattern; §9 nennt zusammen 18 Eintraege wenn man Sub-Pattern mitzaehlt)

**Verzeichnis-Anbindung (12_md §9):** `search_engine/strategies/commands/{pages,traversals,prefetchers,relocations,compositions}/` mit 17 expliziten `*_composition.hpp` Dateien.

---

## E) AUS 12: Sind ALLE Algorithmus-Hybride zerlegt? Welche fehlen?

§9 von 12_md sagt explizit: "WO IMMER eine Strategy oder ein Pattern als hybrid/composite/mixed/dual-ebene/dual-layer/triple-layer/N-prefetcher/hierarchical/heterogen beschrieben ist, ist eine Command-Pattern-Aufloesung Pflicht." Tabelle hat 17/18 Eintraege.

### Bereits abgedeckt durch §9 (vollstaendig):
- Alle 4 LayerMixPattern-Konkretisierungen (P03/P10/P04/P22)
- Beide InnerVsLeafPattern-Konkretisierungen (P02/P19)
- Beide HotVsColdPattern-Konkretisierungen (P26/P28)
- DynamicRebalancePattern (nur P05; P18/P19/P20 fehlen — siehe Luecke unten)
- 3 HierarchicalFractalPattern (P22/P15/P06)
- 2 MultiStrategyOrchestrationPattern (P07/P15)
- 2 OrthogonalRuntimeParametrizedPattern (P23/P14)
- 1 HeterogeneousAdaptivePattern (P20)
- 1 BoundaryNodePartitionPattern (P20)

### EXPLIZITE LUECKEN (nicht in §9 aufgeloest, obwohl Hybrid):

1. **DynamicRebalancePattern: P18 Saikkonen Global Relocation** — Composite mit P19, aber nur als `LayoutInvariantCompositionCommand` in 11_md §10 vermerkt; in 12_md §9 fehlt der Eintrag.
2. **DynamicRebalancePattern: P19 Saikkonen Local Relocation** — wird in 11_md §10 erwaehnt (`LocalRelocationCommand+GlobalRelocationCommand`), aber NICHT in 12_md §9 gespiegelt.
3. **DynamicRebalancePattern: P20 Mueller-Benson-Leis Adaptive Layout-Selector** — als `BTreesAreBackHeterogeneousAdaptive` aufgeloest (Pattern Nr. 17), Adaptive-Selector-Aspekt aber nicht explizit als DynamicRebalance.
4. **HierarchicalFractalPattern: P17 vEB Layout** — vEB wird in §2.4 als 4 Sub-Strategien gelistet (vEB, DynamicVEBPackedMemoryArray, BufferNodesVEB, IndirectedVEB) aber NICHT als HierarchicalFractal in §9 zerlegt. P17 ist Hybrid (3 Layout-Varianten + Indirection), benoetigt `VEBLayoutVariantCompositionCommand`.
5. **MultiStrategyOrchestrationPattern: P26 Zhang FGCS 3-Prefetcher Mix** — als HotVsCold (Pattern Nr. 8) `ThreePrefetcherOrchestration` aufgeloest, aber Multi-Strategy-Aspekt redundant mit HotVsCold-Aufloesung.
6. **OfflineSelfTuningPattern (1.2 Adaptivitaet)** — nur P05 START explizit aufgeloest (Pattern Nr. 9). Andere Adaptivitaets-Patterns (`OnlineProbabilityRebalance`, `OnEveryStructureModification`, `PeriodicGlobalRelocation`) ohne §9-Eintrag.
7. **CompoundFastBuildPattern (1.2)** — P02 HOT k-constrained Partitioning + P04 CoCo Post-Order DP sind klar Hybride; P02 ist via `HOTCompoundCompositionCommand` (Nr. 5) abgedeckt, P04 ist via `CoCoLevelLDecisionCompositionCommand` (Nr. 3) — aber Aufbau-Aspekt ist nicht eigenstaendig.
8. **PostOrderDpPattern (1.3)** — P04 + P05 doppelt-gemoppelt mit existierenden Aufloesungen; expliziter PostOrderDP-Composition fehlt aber.
9. **RecursiveDfsBlockPackingPattern (1.3)** — P17 vEB + P11 CSS Build sind Algo-Hybride; P17 nicht aufgeloest (siehe Luecke 4).
10. **2.4 Layout-Theorie-Familie:** `BufferNodesVEBStrategy` + `IndirectedVEBStrategy` (P17 SIAM 2005 Variante) — formaler Hybrid (Tree-Layer + Indirection-Layer), keine Aufloesung.

### 3.4 Concurrency-Strategien (mehrfache Hybride aus §9 ausgeklammert):
11. **TripleClassConcurrencyStrategy (Wormhole P07 - Class 1 RCU/Class 2 RW-Lock/Class 3 MutEx)** — wird in 11_md §10 unter F25 angedeutet, aber NICHT in 12_md §9 als atomare Aufloesung formalisiert. Sollte `WormholeTripleConcurrencyCompositionCommand` mit 3 Atomen werden.
12. **DualHashTableCopyOnWriteStrategy (Wormhole P07 T1/T2 fuer MetaTrieHT)** — separater Hybrid, KEINE §9-Aufloesung.

**FAZIT zu E:** 17 explizite Aufloesungen in §9 + 1 Sub-Pattern. **MINDESTENS 12 Hybride sind nicht oder nur indirekt zerlegt** — Hauptluecken: P17 vEB (4 Varianten), P19 Saikkonen Local+Global (in 11_md erwaehnt nicht in 12_md), P07 Wormhole TripleConcurrency und DualHashTable, alle Adaptivitaets-Patterns (1.2) ohne P05, alle Aufbauverfahren (1.3) ausser was indirekt abgedeckt.

---

## F) AUS 13: Komplette Liste aller IHeuristic-Konkretisierungen mit Paper-Quelle

### 13_md §9 — Saeule-B-Heuristik-Inventar (aus den 33 Papern abgeleitet)

#### 9.1 Layout-Selection-Heuristiken (19):
1. `AdaptiveLayoutSelectionHeuristic` (P01 ART)
2. `HeightConstrainedPartitioningHeuristic` (P02 HOT)
3. `DataAwareCollapsingHeuristic` (P04 CoCo)
4. `CacheCostBasedNodePlacementHeuristic` (P05 START)
5. `BellmanDPNodeOptimizer` (P05 START)
6. `RecursiveCommonPrefixDecompositionHeuristic` (P06 B^2-Tree)
7. `MinimumDistinguishingPrefixHeuristic` (P07 Wormhole)
8. `SmartSplitHeuristic` (P07 Wormhole)
9. `SplitPointSelectionHeuristic` (P07 Wormhole)
10. `MatchCacheLineSizeHeuristic` (P11 CSS-Tree)
11. `BranchFactorSelectionHeuristic` (P12 CSB+)
12. `SegmentationPolicyHeuristic` (P12 CSB+)
13. `HardcodedSearchVariantHeuristic` (P12 CSB+)
14. `ConfigurationLookupHeuristic` (P14 Samuel)
15. `ProbabilityWeightedRootBlockHeuristic` (P16 Bender)
16. `OptimalAllocationHeuristic` (P19 Saikkonen)
17. `AlphaTuningHeuristic` (P19 Saikkonen)
18. `HeadQualityHeuristic` (P20)
19. `KeyTypeHeuristic` (P20)
20. `BoundaryNodeHeuristic` (P20)

#### 9.2 Cost-Modell-Heuristiken (12):
21. `CacheCostDPHeuristic` (P05 START)
22. `OptimalNodeSizeHeuristic` (P13 Hankins/Patel)
23. `TLBAwareSizingHeuristic` (P13)
24. `BranchPredictionAwareHeuristic` (P13)
25. `CardenasFormulaHeuristic` (P13)
26. `OptimalNodeWidthHeuristic` (P21 Chen)
27. `OptimalPrefetchDistanceHeuristic` (P21)
28. `OptimalChunkSizeHeuristic` (P21)
29. `OptimalWidthMultiTierHeuristic` (P22 Chen Fractal)
30. `OverflowVsOffloadHeuristic` (P22 Fractal)
31. `DiskFirstVsCacheFirstHeuristic` (P22 Fractal)
32. `ConflictMissPredictionHeuristic` (P18 Saikkonen)

#### 9.3 Adaptive Prefetch-Distance-Heuristiken (8):
33. `AdaptivePrefetchDistanceHeuristic` (P23 Khan)
34. `RuntimeOffsetAdaptationHeuristic` (P23)
35. `CostBenefitGatedHeuristic` (P23)
36. `AffineDistanceHeuristic` (P23)
37. `TemplateSpecializerHeuristic` (P23)
38. `StrideVsSequentialHeuristic` (P32 TUD)
39. `PartitionCountHeuristic` (P32 TUD)
40. `PaddingStrategyHeuristic` (P32 TUD)

#### 9.4 Workload-Detection-Heuristiken (6):
41. `SequentialInsertOptimizationHeuristic` (P03 Masstree)
42. `LayerCreationDecisionHeuristic` (P03)
43. `WorkloadDetectionHeuristic` (P20)
44. `ScanFrequencyCounterHeuristic` (P20)
45. `SkewedDistributionDetectionHeuristic` (P26 Zhang Index)
46. `SlidingWindowDriftDetectionHeuristic` (P28 Future Work)

#### 9.5 Cache-Coherence-Heuristiken (6):
47. `CacheCoherenceCostHeuristic` (P28 Kuehn Block AN)
48. `OverpredictionGateHeuristic` (P24 Naderan-Tahan)
49. `NegativPredictionDetectionHeuristic` (P24)
50. `PrefetchReliabilityHeuristic` (P25 Mahling)
51. `FBSizeAwareLimitingHeuristic` (P25 Mahling)
52. `AccessProbabilitySortedPrefetchHeuristic` (P25)

#### 9.6 Telemetry-getriebene Heuristiken (9):
53. `PathReadCounterHeuristic` (P26 Zhang Index)
54. `MonitorClusteringHeuristic` (P26)
55. `JaccardSimilarityTelemetryHeuristic` (P27 Zhang Hierarchical)
56. `StaticVsDynamicFootprintRatioHeuristic` (P27)
57. `HotPathExtractionHeuristic` (P28 Kuehn)
58. `PerNodeHistogramHeuristic` (P28 Kuehn)
59. `LeafOnlyCounterHeuristic` (P28 Kuehn-Mail 2026-05-08, NEU PRT-ART)
60. `LeafOnlySampledCounterHeuristic<N>` (P28 Kuehn-Mail 2026-05-08, NEU)
61. `RetroactiveAggregationHeuristic` (P28 Kuehn-Mail 2026-05-08, NEU)

#### 9.7 Layout-Auswahl/Kompatibilitaet (10):
62. `LinearSearchPreferredHeuristic` (P14, P28)
63. `BinarySearchPreferredHeuristic` (P14)
64. `InterpolationSearchPreferredHeuristic` (P15)
65. `PoorMansKeyAcceleratedHeuristic` (P15)
66. `StrategyCompatibilityMatrixHeuristic` (P15 Survey)
67. `PointQueryOptimizedHeuristic` (P14, P19)
68. `ScanOptimizedHeuristic` (P14, P19)
69. `InsertOptimizedHeuristic` (P14, P19)
70. `MixedWorkloadHeuristic` (P14)
71. `LayoutDegradationHeuristic` (P19 Saikkonen)
72. `WidthCostModelHeuristic` (P13)
73. `ProbabilityLayoutHeuristic` (P16 Bender)

#### 9.8 Hardware-Probing-Heuristiken (4):
74. `PlatformProbeHeuristic` (P05, P13, P32)
75. `OnlinePerformanceCounterReaderHeuristic` (P23, P25)
76. `DynamicSpecializerHeuristic` (P23 Khan)
77. `BundleThresholdHeuristic` (P27)

### 12_md §4 — Saeule-A-Heuristik-Inventar (parallel-Liste, ueberschneidend)

§4.1 Statische Cost-Model-Heuristiken (24): OptimalNodeSize (P13), OptimalPrefetchDistance (P21), OptimalChunkSize (P21), OptimalNodeWidth (P21), OptimalWidthMultiTier (P22), CardenasFormulaCacheHitRate (P13), BranchMispredictionCounting (P13 Eq.16), TLBMissCounting (P13 Eq.18), SpeculativeFetchAccounting (P13 Eq.13), CacheCostDP-START (P05), BellmanDPNodeOptimizer (P05), LevelAwareCacheCostExtrapolation (P05), DataAwareCollapsing-CoCo (P04), GilItaiOptimalLayoutDP (P16), ProbabilityGreedyLayout (P16 Th.1), WidthCostModel-Hankins (P13), CompressionVsSearchTradeoff (P04 alpha, P20), OverflowVsOffload-fpB+ (P22), DiskFirstVsCacheFirst-fpB+ (P22), BranchFactorSelection-CSB+ (P12), SegmentationPolicy-CSB+ (P12), HardcodedSearchVariant-CSB+ (P12), OptimalPartitionCount-P32 (P32 Schmidt), OptimalStrideSize-P32 (P32), BurstLength-P31 (P31 Ungethuem)

§4.2 Adaptive/Runtime-Heuristiken (29): AdaptivePrefetchDistance (P23), RuntimeOffsetAdaptation (P23), AffineDistance (P23 Eq.7-10), CostBenefitGated (P23 Eq.4), TemplateSpecializer (P23), OnlinePerformanceCounter (P23), ScanFrequencyCounter (P20), KeyType (P20), HeadQuality (P20), BoundaryNode (P20), LayerCreationDecision-Masstree (P03), MinimumDistinguishingPrefix-Wormhole (P07), LongestPrefixMatchByLength-Wormhole (P07), RecursiveCommonPrefixDecomposition-B^2 (P06), MonitorClustering-P26 (P26), PathReadCounter (P26), PerNodeHistogram-P28 (P28), LeafOnlyCounter-NEU (P28-Mail), LeafOnlySampledCounter\<N\> (P28-Mail), RetroactiveAggregationBarrier (P28-Mail), JaccardSimilarityTelemetry-P27 (P27), BundleIdentification-P27 (P27 Algo 1), HotPathExtraction-P28 (P28), SlidingWindowDriftDetection-P28-Future, LayoutDegradation (P19), AlphaTuning (P19), ConfigurationLookup (P14), LinearVsBinarySearchPreference (P14, P15), EagerVsLazyPrefetch (P14, P15), FBSizeAwareLimiting-P25, PrefetchReliability-P25, AccessProbabilitySortedPrefetch-P25

§4.3 Workload-/Negativ-Befund-Heuristiken (10): WorkloadDetection (P20, P26), NegativPredictionDisable-P24, OverpredictionGate-P24, ReuseDistanceTelemetry-P24, WorkloadTypeStrategy-P24, EnergieAwareCache-P24, StrategyCompatibilityMatrix-P15, WorkloadAdaptation (P14, P19), CriticalPath-P31, UniversalityVsTechnicalFeasibility-P31

§4.4 Layout-Invarianten-/Topologie-Heuristiken (6): ProbabilityWeightedRootBlock-Bender (P16 Lemma 1), EpsilonRelaxedGreedy (P16 Th.2), NeighborhoodConnectednessAlpha (P19), ConflictMissPrediction (P18), AliasingCorrectionAdressPermutation (P18), RangeDecomposition-B^2 (P06)

§4.5 Hardware-Probe-/Live-Heuristiken (9): ClflushNodeProbe-P05, LatencyProbe (P05, P25), BranchPredictorProbe (Empfehlung), SimdThroughputProbe (Empfehlung), DTLBSTLBCapacityProbe-P32, HardwarePrefetcherStreamLimitProbe-P32, CacheAssociativityDisalignment-P32, StridedVsSimd-P32, NumaMemoryLatencyHiding-P32

**Bilanz Heuristiken Total:** 13_md §9 nennt 77 Heuristiken (durchnummeriert oben), 12_md §4 nennt ca. 78 (Ueberschneidungen mit 13_md). **Bereinigtes Inventar: ca. 80-85 distinkte IHeuristic-Konkretisierungen** ueber alle 33 Paper.

---

## G) AUS 13: Welche Plattform-Modell-Concepts fehlen, die in 33-Paper-Code drin sind?

### Im Dokument explizit als "fehlend" markierte Plattform-Concepts (13_md §7 + 11_md §4.1/4.3/6 + 12_md §6):

#### Saeule B Concept-Klassen (13_md §6 + Lueckenanalyse §7):

**Komplett fehlend in REV 2:**
1. `IRankSelectPrimitive` — popcount-basiert; Sub: BitVectorRank, JacobsonTwoLevelDirectory, PoppyRank (P09/P10/P04)
2. `IPlatformProbe` — Subklassen: ClflushNodeProbe (P05), LatencyProbe (P05/P25), BranchPredictorProbe (Empfehlung), SimdThroughputProbe, DTLBSTLBCapacityProbe (P32), HardwarePrefetcherStreamProbe (P32)
3. `IModelAcquisitionStrategy` — wie wird `ILivePlatformModel` gewonnen? (P05 explicit)
4. `IVirtualMemoryStrategy` — DirectMapping/RewiredSharedPages/HugePages (P05 START Rewiring)
5. `IBranchPredictorModel` — Mispredict-Cost als Plattform-Kennzahl (P01/P13)
6. `IBitManipulationFeatureGate` — BMI2 PEXT/PDEP, AVX2, popcount mit Fallback (P02)
7. `IStorageMedium` — DRAM/NVRAM/SSD/HDD-Hierarchy (P10 SuRF, P22)
8. `IPageCacheModel` — OS Page Cache + App Block Cache 2-stufig (P10 SuRF)
9. `IConcurrencyProtocol` — orthogonal zu A/B (P02/P03/P08/P29/P30) — eigene Saeule C
10. `IRebuildScheduler` — VACUUM-aehnliche Trigger (P05 START Self-Tuning)
11. `IRebuildCostModel` — Bauzeit O(N h^2) bei P04 CoCo
12. `IWorkloadModel` — Read-Only/Read-Mostly/Write-Heavy/Mixed/Skewed/Range-Heavy (P05 future)
13. `ICellProbeModel` vs. `IWordProbeModel` — 2 alternative Plattform-Modelle (P09 Jacobson)
14. `IPositionalCorrespondencePrefetch` — Prefetch via Layout-Invarianten (P10 SuRF)
15. `ICacheConflictModel` — FullAssociative vs. SetAssociative (P18)
16. `ITemporalCacheStrategy` (Instruction-Cache) — P15 Sektion 7; REV 2 ICachePage ist Daten-orientiert
17. `IIntelligentDMA` (Compute-Offload) — Configurator/AGU/DataFetcher/Crawler (P31 iDMA)
18. `IComputeOffload` — wo wird Operation ausgefuehrt? PE/iDMA/App-Core/FPGA (P31)
19. `IHardwareExtension` Sub-Hierarchie — WAH/PLWAH/COMPAX (Bitmap), Hash+Lookup/Insert/CityHash32/Sampling, MergeSort/Intersection/Union/Difference/SortMergeJoin/SortMergeAggregation, RiscBaseISA, SSE/AVX/SGX/THUMB/NEON (P31 TUD Goldstandard)
20. `IMemoryDecorator` (NFP) — latency/throughput/transience/reliability/wearout/random-accessibility/cache-coherence (P33 VAMPIR)
21. `IHeterogeneousAllocator` (V-malloc) — heterogene Memory-Auswahl (P33)
22. `IMigrationPolicy` — transparente Daten-Migration zwischen Memory-Ebenen (P33 Compensation)
23. `ICompileTimeNegotiator` — Multi-Query Compile-Time-Negotiation (P33)
24. `IPipelineScheduler` — Operation-Pipelines mit Memory-Awareness (P33)
25. `IAccessPatternStrategy` — sequential/strided/simd (P32 To-Stride)
26. `IPaddingStrategy` — 576-Byte-Padding fuer Cache-Set-Disalignment (P32)
27. `IInformationTheoreticLowerBound` — Optimality-Marker fuer Encoding (P09)
28. `IPositionalAddressing` — Implicit Addressing via Position-in-Bitstring (P09)

**Konkrete Hauptluecken Cluster-uebergreifend (13_md §7.1):**
- `INode` 1:1-Annahme zu ISearchPage kollidiert mit Compound-Pattern (HOT/CoCo/START) → `ICompositionMode` (OneNodePerPage / MultipleNodesPerPage)
- `ISearchPagesStrategyPattern` nur homogen → 4 Konkretisierungen (Homogeneous/HeterogeneousAdaptive/HierarchicalFractal/OrthogonalRuntimeParametrized)
- `ICacheStrategy` (Visitor) erfasst nur Daten-Cache → `ITemporalCacheStrategy` ergaenzen (P15 §7)
- `IFanout` nur Branching-Faktor → `ITopologyEncoding` als orthogonales Feld (LOUDS/DFUDS/BP/Pointer/BitArray)
- `IHeuristic` nicht typisiert → 4 Sub-Hierarchien (IStaticHeuristic/IRuntimeHeuristic/IMultiTierHeuristic/IPrefetchTacticHeuristic)
- `ILivePlatformModel` Saeule B — wie gewonnen? → `IPlatformProbe` + `IModelAcquisitionStrategy` 
- `IConcurrencyProtocol` nicht eigene Saeule → eigene Saeule C (8 Disziplinen + 5 Mechaniken)
- `IUpdatability` Static/Dynamic fehlt als Concept-Dimension → Mixin-Marker
- `ISpaceGuarantee` nicht als Property → First-Class Property einer ISearchPagesStrategyPattern
- `IAdaptationTrigger` (wann re-applied?) → `IRebuildScheduler`-Hierarchie
- `IFilterStrategy` nicht in REV 2 → Geschwister-Concept zu ISearchPageStrategy (mit `IFalsePositiveRateModel`)
- `IIteratorStateCacheStrategy` (per-level cursors haben eigenes Cache-Verhalten) — fehlt
- `INodeIterator/ISearchPageIterator/ISearchPageStrategyIterator` in REV 2 verlangt aber nicht ausspez. → 12+ Konkretisierungen aus 12_md §5

#### Im 33-Paper-Code drin, aber NICHT als Concept formalisiert (Mehr-Detail):

29. **NUMA-Awareness** durchgaengig schwach (Cluster A/B/E) — nur P03/P28 explizit. `IPinningPolicy` muss min. Cross-Socket-cost + NUMA-node-binding + first-touch-policy abdecken (P25/P28/P32 als Leitpaper).
30. **Hardware-Counter-Feedback** keine STATISCHE Strategy implementiert ILivePlatformModel-getriebenes adaptives Resizing (Cluster A/B/C).
31. **TLB explizit modelliert** nur P13/P28/P32 — ART/HOT/CoCo/SuRF ignorieren TLB.
32. **SIMD in B+/Hybrid-Familie** nur P03 PALM erwaehnt, nicht adaptiert (Cluster B Luecke).
33. **6-Flavor-RCU-Klassifikation** P29 hat nur 4 Flavors; qsbr/mb/membarrier/signal aus URCU-Literatur (Desnoyers 2012) nicht im Original-RCU-Paper.
34. **Cache-Coherence-Energiekosten** P24 aggregiert; quantitative Modellierung fehlt.
35. **Range-Scan bei ROWEX** P08 notiert: sortierte Reihenfolge im Linear-Node aufgegeben → Range-Scan-Konflikt.
36. **Concurrent Reconstruction** P06 erkennt: Embedded Tree-Rebuild bei Split unter Concurrency nicht-trivial.
37. **Multi-Tenancy/Cache-Pollution** alle Paper nehmen "dedizierten Cache" an.
38. **Multi-Level Local-Relocation** P19 erkennt: nicht-trivial.
39. **NVRAM/Persistent Memory** nur P25 (Grace HBM), P31 (Tomahawk-LX5) — nicht durchgaengig.
40. **Compiler-Automation der ISA-Extensions** P31/P30 OFFEN.
41. **Plattform-spezifische Validierung** P14 nur Itanium2; P32 nur Cascade Lake/Sapphire Rapids.

#### Block AO Production-Plattform OFFEN (13_md §10.5):
42. **Cache-Coherence-Pressure-Quantifizierung 3D V-Cache** Ryzen 9 9950X3D — keines der 33 Paper modelliert 3D-stacked Cache.
43. **P/E-Core-Heterogenitaet i9-14900KS** — keines der 33 Paper modelliert Hybrid-Architecture, IntelThreadDirector-Integration ist Eigenleistung.
44. **Bandwidth-Aware Layout fuer DDR5-5600** Multi-Channel-Modell und Refresh-Cycle-Effekte in P31 (DDR2)/P32 (DDR4/5) implizit aber nicht voll formalisiert.
45. **Live-Probing der Plattform-Konstanten via CPUID** + `__cpu_indicator_init` — kein Paper liefert Code-Template.
46. **Cross-CCX-Coherence-Latenz Ryzen 9 9950X3D** — nicht in 33 Papern modelliert.

---

## ZUSAMMENFASSUNG (Quick-Reference fuer REV5)

| Aspekt | Anzahl |
|--------|-------:|
| Cache-Familien F1-F29 | **29** |
| Davon Hybrid-Layouts (zerlegungsbeduerftig) | **14** |
| Davon atomar | **15** |
| Vollstaendig in 11_md §10 mit Atom-Commands aufgeloest | **12** |
| Familien mit explizit fehlender Aufloesung (KRITIK K10) | **8** (F8/F11/F13/F14/F22/F25/F27/F28) |
| ISearchPagesStrategyPattern Patterns (Ebene A) | **21** (10 Komposition + 6 Adaptivitaet + 5 Aufbau) |
| ISearchPagesStrategy (Ebene B PLURAL) | **41** (12 B+ + 8 Trie + 8 Hybrid + 10 Layout + 3 AdaptSelector) |
| ISearchPageStrategy (Ebene C SINGULAR) | **74** (22 Search + 15 Insert + 28 Layout + 9 Concurrency) |
| IHeuristic-Konkretisierungen Saeule A (12_md §4) | **78** |
| IHeuristic-Konkretisierungen Saeule B (13_md §9) | **77** (Ueberschneidungen) |
| Bereinigtes IHeuristic-Inventar | **~80-85** distinkt |
| §9 Hybrid-Command-Aufloesungen explizit | **17** (+1 Sub-Pattern) |
| Hybride OHNE Aufloesung in §9 | **mind. 12** (P17 vEB, P19 Local+Global, P07 TripleConcurrency, P07 DualHashTable, alle Adaptivitaets/Aufbau-Patterns) |
| Iterator-Inventar (12_md §5) | **45** (12 INodeIterator + 11 ISearchPageIterator + 10 ISearchPageStrategyIterator + 12 prt_art<K,V>::iterator) |
| Saeule-B Plattform-Modell-Concepts FEHLEND in REV 2 | **28** (`IRankSelectPrimitive` ... `IPositionalAddressing`) |
| Cluster-uebergreifende Konzept-Luecken | **13** |
| 33-Paper blind spots | **41-46** (NUMA/TLB/SIMD-B+/RCU-Flavors/Energiekosten/Coherence-Quantifizierung etc.) |
| Block-AO Production-Plattform OFFEN-Punkte | **5** |

**Gesamtbausteine REV5 Konsolidiert:**
- Vor §10 + §9 Aufloesung: ~100 monolithische Familien × wenige Konkretisierungen
- Nach Aufloesung: 29 Familien × atomare Commands × Composition-Variants = **~250-300 Bausteine**
- Plus 21 Patterns + 41 Plural-Strategien + 74 Singular-Strategien + 80 Heuristiken + 45 Iteratoren + 28 fehlende Saeule-B-Concepts = **~590 individuelle Concept-Eintraege**

**Hauptbefund fuer REV5:**
1. **B-Antwort (Hybrid-Familien-Luecke):** 8 Cache-Familien benoetigen explizite Atom-Aufloesung in 11_md §10.
2. **E-Antwort (Algorithmus-Hybrid-Luecke):** 12+ Algorithmus-Hybride sind nicht durch §9 abgedeckt — insbesondere P17 vEB (4 Sub-Strategien), P19 Saikkonen, P07 Wormhole TripleConcurrency, alle Adaptivitaets/Aufbauverfahren-Patterns.
3. **G-Antwort (Plattform-Concepts-Luecke):** 28 Saeule-B-Concept-Klassen explizit fehlend; weitere 13 cluster-uebergreifende Luecken; 41-46 33-Paper-blind-spots.

