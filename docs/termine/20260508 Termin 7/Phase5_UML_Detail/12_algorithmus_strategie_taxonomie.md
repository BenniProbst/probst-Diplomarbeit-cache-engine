# Algorithmus-Strategien-Taxonomie (Konsolidierung aus 33 Papern)
**Stand:** 2026-05-09 (REV 1) · Korrektur-Runde 3 ergaenzt 2026-05-10
**Quelle:** 6 Cluster-Dateien (cluster_A_trie.md, cluster_B_hybrid_bplus.md, cluster_C_layout_theorie.md, cluster_D_prefetching_1.md, cluster_E_prefetching_telemetry.md, cluster_F_sync_tud_habich.md)
**Pendant zu:** 11_cache_strategien_taxonomie.md
**Architektur-Bezug:** REV 2 Concept-Hierarchie, Saeule A (IPage / IRootPage / IFanout / INode / ISearchPage / ISearchPagesStrategy / ISearchPagesStrategyPattern / ICacheStrategy)

---

## ⚠ KORREKTUR-RUNDE 3 (2026-05-10) — Cluster-Aufloesung + Hybrid-Command-Pattern + ExecutingEngine

**Bezug:** `10_korrektur_architektur_skizze_2026_05_09.md` Sektionen K3.1, K3.3, K3.4

### K3.1-Wirkung — IExecutingEngine als Wurzel ueber ISearchEngine

Die `ISearchPagesStrategy` etc. unten sind die Strategie-Achsen einer `ISearchEngine`. `ISearchEngine` ist eine Spezialisierung von `IExecutingEngine`. Andere Engines (kuenftig) erben analog. Die Strategien dieser Datei sind also auf der Ebene **„Suchalgorithmus-Spezifikum"** angesiedelt — die CacheEngine-Anbindung erfolgt eine Schicht hoeher (`IExecutingEngine` → CacheEngine als Optimierungs-Service).

### K3.3-Wirkung — Cluster-Aufloesung: B+- und Trie-„Familien" sind Konfigurations-Pakete

In den Sektionen 2.1 (B+-Familie) und 2.2 (Trie-Familie) und in den Cluster-A/B-Dateien wird jeweils eine „Familie" angesprochen. Das ist eine Lektuere-Gruppierung, KEINE architektonische Trennung. Die Forschungs-These der Diplomarbeit ist gerade, dass diese „Familien" nur Rekombinations-Pakete der gleichen atomaren Bausteine sind. Architektur-richtig:
- B+- und Trie-„Strategien" (siehe Sektionen 2.1 + 2.2) sind **Sammel-Bezeichner** fuer Bausteine-Konfigurationen
- Die atomaren Bausteine sind in `11_cache_strategy_taxonomie.md` (29 Cache-Familien) und in den Strategy-Ebenen unten frei rekombinierbar
- Cross-Familien-Permutationen (Trie-Pattern + B+-Strategy + ART-Page + LOUDS-Encoding + Hot-Path-Heuristic) sind explizites Forschungs-Ziel (F15)

### K3.4-Wirkung — Hybrid-Strategien IMMER Command-Pattern-zerlegen

Wo immer in dieser Taxonomie eine Strategie als „hybrid" bezeichnet wird (z.B. `MultiStrategyOrchestrationPattern`, `HierarchicalFractalPattern`, `HeterogeneousAdaptivePattern`, sowie die in §2.1/2.2 hybrid kombinierten Algorithmen P02 HOT, P10 SuRF, P07 Wormhole, P03 Masstree, P04 CoCo, P06 B²-Tree, P20 B-Trees-Are-Back, P22 Fractal):

→ Diese Hybrid-Strategien werden in **atomare Strategy-Commands** zerlegt + unter einem **HybridCompositionCommand** zusammengesetzt. Die atomaren Commands sind einzeln testbar und einzeln in Permutationen rekombinierbar.

Eine vollstaendige Tabelle der Hybrid → Command-Pattern Aufloesungen ist in **§9 Hybrid-Command-Pattern-Konvention** unten am Ende dieses Dokuments.

---

## Vorbemerkung: Vier-Ebenen-Trennung

Die REV-2-Architektur differenziert vier orthogonale Strategie-Schichten:

| Ebene | Concept | Kardinalitaet | Zweck |
|-------|---------|---------------|-------|
| A | `ISearchPagesStrategyPattern` | 1 pro `IFanout` | Komposition/Orchestrierung der Pluralstrategien |
| B | `ISearchPagesStrategy` | N pro Pattern | Pflege der `ISearchPageStructure` (Struktur uebergreifend) |
| C | `ISearchPageStrategy` | 1 pro `ISearchPage` | Lokal pro Page (Suche, Insert, Layout) |
| D | `IHeuristic` | beliebig viele | Wert-/Kostenberechnungen, parametriert die Strategien |

Iteratoren (Saeule A-Querschnitt): `INodeIterator`, `ISearchPageIterator`, `ISearchPageStrategyIterator`, `comdare::prt_art<K,V>::iterator`.

---

## 1. ISearchPagesStrategyPattern (1 pro IFanout)

ISearchPagesStrategyPattern entscheidet, WIE eine `IFanout` ihre `ISearchPagesStrategy`-Instanzen anordnet/kombiniert. Es ist das Komposit-Element. Zwei orthogonale Achsen: (i) Heterogenitaet (homogen vs. heterogen vs. hierarchisch) und (ii) Adaptivitaet (statisch vs. dynamisch vs. runtime-parametrisiert).

### 1.1 Patterns nach Komposition

| Pattern-Name | Paper-Quelle | Kategorie | Beschreibung |
|--------------|--------------|-----------|--------------|
| `AllPagesUniformPattern` | P11 CSS, P12 CSB+, P14 (CSB+/Itanium2), P21 pB+-Tree | homogen | Alle ISearchPages haben dieselbe ISearchPageStrategy (klassische B+/CSS); Branching-Faktor und Knotenlayout sind global identisch |
| `LayerMixPattern` (Slice-Layered Trie of B+) | P03 Masstree, P10 SuRF (LOUDS-DS Hybrid), P04 CoCo (Macro-Levels), P22 fpB+ (Disk-Layer + In-Page-Layer) | heterogen pro Layer | Pro Layer/Tier eine andere Pluralstrategie (z.B. Trie-Layer + B+-Pro-Layer; LOUDS-Dense oben + LOUDS-Sparse unten); rekursive oder Layer-weise Komposition |
| `InnerVsLeafPattern` | P02 HOT (Compound Inner/Leaf), P10 SuRF (Dense vs. Sparse Cutoff), P04 CoCo (Macro-Levels nahe Leaf), P19 Saikkonen (α-Connected-Subgraph), P22 (Inner vs Leaf Knotengroessen) | heterogen pro Rolle | Strikt unterschiedliche Strategien fuer Innere und Leaf-Pages; Rolle bestimmt Layout |
| `HotVsColdPattern` | P26 Zhang FGCS (Path Prefetcher Table), P28 Kuehn DaMoN (Hot-Path-Layout), P10 SuRF (Hot Upper Levels) | dynamisch heterogen | Telemetry-getriggert: hot Pages werden anders enkodiert/angeordnet als cold; Greedy-Highest-Probability-Auswahl |
| `DynamicRebalancePattern` | P05 START (Self-Tuning Multilevel), P18 Saikkonen (Global Relocation), P19 Saikkonen (Local Relocation), P20 Mueller-Benson-Leis (Adaptive Layout-Selector) | dynamisch | Periodische oder einlauf-getriggerte Reorganisation der Layout-Strategien |
| `HierarchicalFractalPattern` | P22 fpB+-Tree, P15 (B-Trees of Cache-Lines), P06 B^2-Tree | rekursiv | Selbst-aehnliche Struktur: Outer-Tier-Pattern enthaelt vollstaendiges Inner-Tier-Pattern (z.B. Disk-Page-Tree → In-Page-Tree) |
| `OrthogonalRuntimeParametrizedPattern` | P23 Khan (Runtime-Adaptive Prefetch), P26 (Cache/Path/Monitor-Prefetcher Mix), P14 (ConfigurationTable) | parametriert | Gleiche Algorithmik, aber Parameter (Distance, Stride, Layout-Variante) zur Laufzeit pro Knoten anders |
| `MultiStrategyOrchestrationPattern` | P07 Wormhole (Hash + Trie + LinkedList), P26 (3 Prefetcher-Komponenten), P15 (Strategy-Compatibility-Matrix) | orchestrierend heterogen | Pattern komponiert verschiedene Tree-Familien (nicht nur Layouts) — Lookup orchestriert mehrere Sub-Strategien sequenziell |
| `HeterogeneousAdaptivePattern` | P20 Mueller-Benson-Leis (KeyAdaption + OperationAdaption Selector) | dynamisch heterogen | Layout-Wahl pro Knoten via Heuristic-Counter (Comparison/Fingerprint/SDL/FDL) |
| `BoundaryNodePartitionPattern` | P20 (Partitioned-Sequential-Insert in FDL) | Sub-Pattern | Bei sequenziellen Inserts wird Split-Punkt anders gewaehlt um Dense-Layout zu erhalten |

### 1.2 Patterns nach Adaptivitaet

| Pattern-Name | Paper | Beschreibung |
|--------------|-------|--------------|
| `OfflineSelfTuningPattern` | P05 START | Periodische Offline-Tuning-Phase (z.B. nach VACUUM oder >10% Aenderung) |
| `OnlineProbabilityRebalancePattern` | P28 (Hot-Path), P26 (Monitor-Clustering Algorithm 1) | Worker-Thread baut Counter-Index/Layout async im Hintergrund |
| `OnEveryStructureModificationPattern` | P19 Saikkonen Local Relocation | Layout-Invariante wird inline mit jeder Insert/Delete erhalten (wait-free Local-Relocation) |
| `PeriodicGlobalRelocationPattern` | P19 (Composite mit P18) | Komposit: Local-Relocation + periodisches Global-Rebuild |
| `BulkLoadLevelByLevelPattern` | P11 CSS, P12 CSB+, P14 | Static-Build top-down, kein incremental update |
| `CompoundFastBuildPattern` | P02 HOT (k-constrained Partitioning), P04 CoCo (Post-Order DP) | Static aufgebaut via Partitionierungs/DP-Algorithmus (O(N h^2) bei CoCo) |

### 1.3 Patterns nach Aufbauverfahren (Post-Order vs. Top-Down vs. BFS)

| Pattern-Name | Paper | Beschreibung |
|--------------|-------|--------------|
| `BfsLevelByLevelPagePackingPattern` | P18 Saikkonen | Globale Block-Allokation per BFS, fill blocks level-wise |
| `RecursiveDfsBlockPackingPattern` | P17 (vEB Layout), P11 (CSS Build) | Rekursive Top-Down-Aufteilung an mittleren Edge-Reihen |
| `ProbabilityGreedyPagePackingPattern` | P16 Bender-Demaine-Farach-Colton, P28 Kuehn (Hot-Path Greedy) | Greedy-Layout: addiere iterativ den Knoten mit hoechster Probability angrenzend an aktuellen Block |
| `PostOrderDpPattern` | P04 CoCo (Data-Aware Optimization), P05 START (Bellman-DP) | Post-Order DP entscheidet pro Knoten optimale Kollaps-Tiefe / Multilevel-Ersetzung |
| `RecursiveCommonPrefixDecompositionPattern` | P06 B^2-Tree (Section 3.1.1) | Rekursive Zerlegung: longest-common-prefix → Span-Node, sonst Decision-Node mit Median-Splitter |

---

## 2. ISearchPagesStrategy (PLURAL — Structure-Pflege)

ISearchPagesStrategy steuert die `ISearchPageStructure` (also wie Pages zueinander angeordnet sind, wie Inserts/Deletes wandern, wie sich die Page-Topologie aendert). N Instanzen pro Pattern.

### 2.1 B+-Familie

| Strategy-Name | Paper | Beschreibung |
|---------------|-------|--------------|
| `BPlusTreePerLayerStrategy` | P03 Masstree | Pro Trie-Layer ein B+-Baum mit slice-Vergleichen (8-Byte-Slices), Border-Nodes mit `next_layer`-Pointer |
| `ClassicBPlusTreeStrategy` | P11/P12/P14, baseline | Standard B+-Tree (Inner: Splitter+Pointer, Leaf: KeyValue-Paare + Sibling-Pointer) |
| `CompactedSearchTreeStrategy (CSS-Full)` | P11 CSS-Tree | Pointer-eliminierter Full-CSS-Baum (m+1-aer, Children via Arithmetik) |
| `CompactedSearchTreeStrategy (CSS-Level)` | P11 CSS-Tree | m-aerer Level-CSS, m-1 Slots als Splitter, einfachere Indizierung |
| `CSBPlusTreeStrategy (Basic)` | P12 CSB+, P14 | Single firstChild-Pointer + Offset-Arithmetik fuer Children |
| `CSBPlusTreeStrategy (Segmented)` | P12 CSB+ | Mehrere Segmente pro Node-Group (mehrere firstChild-Pointer); Split kopiert nur ein Segment |
| `CSBPlusTreeStrategy (Full pre-allocated)` | P12 CSB+ | Volles NodeGroup pre-alloziert; Splits ohne Allokation |
| `WideNodeBPlusStrategy (pB+)` | P21 Chen-Gibbons-Mowry | Knoten-Breite w (z.B. 8 Cache-Lines), parallel prefetched vor Binary Search |
| `FractalBPlusStrategy (Disk-First)` | P22 fpB+ | Outer Disk-Page-Tree; In-Page-Layout startet mit Disk-Boundaries, dann Cache-optimaler In-Page-Tree |
| `FractalBPlusStrategy (Cache-First)` | P22 fpB+ | Outer Cache-Page-Tree; Sibling-Leaves in selbe Page, Aggressive Placement, Overflow-Pages |
| `LargeNodeBPlusStrategy (256-512B)` | P13 Hankins-Patel | Knotengroesse 256-512B (8-16x Cache-Line) — analytisch optimiert via Cost Model |
| `EmbeddedSecondaryIndexStrategy (B^2)` | P06 B^2-Tree | Outer B+-Page (64 KiB) enthaelt eine inner Mini-Search-Struktur (Decision + Span Nodes) |

### 2.2 Trie-Familie

| Strategy-Name | Paper | Beschreibung |
|---------------|-------|--------------|
| `AdaptiveRadixTreeStrategy` | P01 ART | 4 Knoten-Layouts (Node4/16/48/256) adaptiv nach Population; Span = 1 Byte |
| `MultilevelAdaptiveRadixStrategy` | P05 START | ART mit Multilevel-Knoten (mehrere Key-Bytes pro physischem Knoten); 52B/Key Worst-Case erhalten |
| `KConstrainedHotStrategy` | P02 HOT | Compound-Nodes mit max. Fanout k=32; Discriminative Bits selektiert |
| `MacroNodeCollapsingStrategy (CoCo)` | P04 CoCo | Subtries kollabiert in Macro-Nodes mit succinct-encoded Branching-Macro-Symbolen (EF/PA/BV/DE Pool) |
| `LoudsDenseSparseStrategy` | P10 SuRF | LOUDS-Dense fuer obere Levels (Bitmap), LOUDS-Sparse fuer untere (label-byte-sequence); Cutoff R=64 |
| `JacobsonLoudsStrategy` | P09 Jacobson | 2-Bit-pro-Knoten Implicit Bitmap; rank/select Navigation, asymptotisch optimaler Footprint (2n+o(n)) |
| `WormholeTripleStrategy` | P07 Wormhole | Triple Index: MetaTrieHT (Hash) + MetaTrie + LeafList; O(log L) statt O(log N) |
| `PathCompressedTrieStrategy` | P01 ART, P02 HOT | Path-Compression + Lazy Expansion zur Hoehen-Reduktion |

### 2.3 Hybrid-Familie

| Strategy-Name | Paper | Beschreibung |
|---------------|-------|--------------|
| `TripleHashThenBPlusStrategy (Wormhole)` | P07 | Phase 1: Hash-LPM auf Anchor; Phase 2: MetaTrie-Walk; Phase 3: Leaf-Tag-Match |
| `StaticPreSortedDirectoryStrategy` | P11 CSS | Tree als Verzeichnis ueber bereits sortiertem Array; Children per Arithmetik |
| `EmbeddedDecisionSpanTreeStrategy (B^2)` | P06 | Decision-Nodes (1 Byte Range) + Span-Nodes (longest common prefix) gemischt |
| `JumpPointerArrayStrategy (External chunked)` | P21 | External Array von Leaf-Adressen; Hint-Pointer in Leaf zeigt ungefaehr auf Chunk |
| `JumpPointerArrayStrategy (Internal)` | P21 | Bottom-Non-Leaves als Jump-Pointer-Array |
| `DualJumpPointerArrayStrategy` | P22 | Internal Array (Cache-Tier) + External Array (Disk-Tier) |
| `JumpPointerVersionChainStrategy` | P26 | 2-ahead Jump Pointers fuer MVCC Version-Chains; chunked linked list (chunk size 8 = 1 cache line) |
| `MicroIndexingStrategy (Lomet)` | P22 (referenziert) | Erstes Key jeder Cache-Line in kleinem Sub-Array; gefolgt von Standard-Binary-Search |

### 2.4 Layout-Theorie-Familie

| Strategy-Name | Paper | Beschreibung |
|---------------|-------|--------------|
| `VanEmdeBoasLayoutStrategy` | P17 Bender-Demaine-Farach-Colton | Statisches Cache-Oblivious-Layout: rekursive Aufteilung an mittlerer Edge-Reihe |
| `DynamicVEBPackedMemoryArrayStrategy` | P17 | Vollstaendig dynamisch (Top-Tree + Middle-Layer + Bottom-Layer mit Indirection) |
| `BufferNodesVEBStrategy` | P17 (FOCS 2000 Variante) | Indirection-frei mit Buffer-Nodes |
| `IndirectedVEBStrategy` | P17 (SIAM 2005 Variante) | Indirection-Layers mit Representative+Ghost Elements |
| `CacheSensitiveMultiLevelLayoutStrategy` | P18 Saikkonen | Globaler BFS-Recursive-Block-Fill; Level-Wise Block-Allokation |
| `LocalRelocationLayoutStrategy (α=2)` | P19 Saikkonen | 1-6 Knoten lokal verschieben pro Tree-Modifikation; Invariante mit α-Parameter |
| `LocalRelocationLayoutStrategy (α>2)` | P19 (Algo 2) | Sammle Connected-Subgraph U; Move zu existierendem oder neuem Block |
| `ProbabilityWeightedRootBlockStrategy (DP)` | P16 Bender-Demaine-Farach-Colton (Gil-Itai DP) | Optimale DP-basierte Layout-Bestimmung; O(NB² log Δ) |
| `ProbabilityGreedyLayoutStrategy` | P16 Theorem 1 | Greedy: addiere iterativ Knoten mit hoechster Probability adjacent zu Block; (B-1)/B optimal |
| `RelaxedGreedyLayoutStrategy` | P16 Theorem 2 | ε-naheliegende Wahl; 1/ε optimal mit mehr Layout-Freiheit |
| `CacheObliviousProbabilityLayoutStrategy` | P16 Theorem 3 | Greedy ohne Block-Size-Wissen; 4× optimal |
| `BTreeOfCacheLinesStrategy (intra-page)` | P15 Survey | Disk-Page selbst wird zu B-Tree, Cacheline zu Knoten |
| `VerticalPartitioningStrategy (Spalten-Layout)` | P15 Survey 6.4 | Schluessel/Pointer separat (Spalten innerhalb Page) |
| `HotPathLayoutStrategy (HLS)` | P28 Kuehn | Hot-Path-Knoten in linearem Memory-Layout + Linear Search + Sort restl. Knoten nach Counter |

### 2.5 Adaptive Layout-Selectors

| Strategy-Name | Paper | Beschreibung |
|---------------|-------|--------------|
| `AdaptiveLeafSelectorStrategy` | P20 Mueller-Benson-Leis | Pro Leaf dynamisch: Comparison ↔ Fingerprinting ↔ SDL ↔ FDL via KeyAdaption + OperationAdaption |
| `OfflineSelfTuningStrategy` | P05 START | Self-Tuning Phase (Cost-Model-DP) periodisch ausgefuehrt |
| `ConfigurationLookupStrategy` | P14 Samuel-Pedersen-Bonnet | Configuration-Table mappt (KeySize, NodeSize, SearchStrategy) → Optimum |

---

## 3. ISearchPageStrategy (SINGULAR — pro Page)

ISearchPageStrategy steuert das Verhalten innerhalb einer einzelnen ISearchPage: wie Eintraege gespeichert sind (Layout), wie gesucht wird (Search), wie eingefuegt/geloescht wird (Insert).

### 3.1 Intra-Page Search-Strategien

| Strategy-Name | Paper | Beschreibung |
|---------------|-------|--------------|
| `LinearScanWithinNodeStrategy` | P01 ART (Node4), P03 Masstree (5% besser auf Intel), P14 (Itanium2 < 384B), P28 (NL/HL/HLS), P15 Survey | Linearer Scan ueber Eintraege; auf Intel/Itanium oft schneller als Binary < 384B |
| `BinarySearchWithinNodeStrategy` | P11 CSS, P12 CSB+, P14, baseline | Standard Binary Search; bei groesseren Knoten (>1024B) optimal |
| `LoopUnrolledBinarySearchStrategy` | P11 CSS, P12 CSB+ (uniform variant) | Hardcoded if-else, branch-free predicted; Knotengroesse + Keysize bei Compile bekannt |
| `SimdParallelKeyComparisonStrategy (SSE)` | P01 ART (Node16), P10 SuRF (Sparse) | `_mm_set1_epi8` + `_mm_cmpeq_epi8` + `_mm_movemask_epi8` |
| `SimdParallelKeyComparisonStrategy (AVX2)` | P02 HOT | `_mm256_cmpeq_epi8` + `_mm256_movemask_epi8` + `bit_scan_reverse` |
| `SimdParallelHeadComparisonStrategy` | P20 (Heads + SIMD) | Heads als 4-Byte-Int verglichen via SIMD |
| `FingerprintingPointLookupStrategy` | P20 | 1-Byte-Hash pro Key; SIMD-Vergleich, dann Heap-Zugriff nur bei Match |
| `DenseOffsetLookupStrategy (FDL)` | P20 | Direkte Index-Berechnung aus Numeric-Part-Offset → O(1) |
| `HintNarrowedBinarySearchStrategy` | P20 | 16 Hints + Binary Search im narrowierten Bereich |
| `InterpolationSearchStrategy` | P15 Survey 6.2 | Probe-Position aus Wert kalkulieren; bei Uniform-Verteilung effizient |
| `PoorMansNormalizedKeySearchStrategy` | P15 Survey 6.1 | Indirection-Vector enthaelt 2/4/8-Byte-Prefix der normalisierten Keys |
| `RankSelectNavigationStrategy` | P09 Jacobson, P10 SuRF, P04 CoCo | Navigation ueber rank/select-Primitive (BitVector/popcount-basiert) |
| `TwoCandidatePrefetchBinarySearchStrategy` | P15 Survey 4.2 | Vor jeder Comparison werden BEIDE Possible-Next-Match-Points prefetched |
| `TaggedHashSlotLookupStrategy (Wormhole Slot)` | P07 | 16-Bit CRC32-Tag + 48-Bit-Pointer in 64-Byte-Slot; Tag-Match vor Full-Key-Vergleich |
| `SpeculativeHashedAccessStrategy` | P07 | Direct Position via T*k/Tmax bei uniform Hash → 1-3 Tag-Vergleiche |
| `IncrementalHashingStrategy` | P07 | CRC32 inkrementell erweitert bei common-prefix |
| `LoudsLookupStrategy` | P09, P04, P10 | rank → first_child → next_sibling Navigation auf BitString |
| `DfudsRankAccessStrategy` | P04 CoCo | DFUDS-Topologie fuer rank-Operation |
| `ExtensionSpanSearchStrategy (B^2)` | P06 | Span-Node mit longest-common-prefix vergleichen + zwei virtual edges (min/max) |
| `ByteRangeDecisionStrategy (B^2)` | P06 | Decision-Node operiert auf einzelnem Byte; Patricia-aehnlich aber bereich-basiert |
| `DiscriminativeBitsSelectionStrategy` | P02 HOT | Pro Knoten nur die diskriminativen Bits der gespeicherten Keys betrachten (PEXT/AVX2) |
| `PrefixingLinearSearchStrategy` | P14 (Itanium 2) | Linear Search + In-Loop Prefetch des nachfolgenden Knotens |

### 3.2 Intra-Page Insert/Update-Strategien

| Strategy-Name | Paper | Beschreibung |
|---------------|-------|--------------|
| `PermutationFieldInsertionStrategy` | P03 Masstree | 64-Bit-Permutation-Field (16 × 4-Bit Indizes + nkeys); Inserts veraendern nur die Permutation atomar |
| `AdaptiveLayoutInsertionStrategy` | P20 Mueller-Benson-Leis | KeyAdaption (gute/bad heads) + OperationAdaption (saturating Counter) bei Splits/Merges |
| `KConstrainedSubtreePartitioningStrategy` | P02 HOT (Listing 1) | 4-Wege-Insert: Normal / LeafPushdown / ParentPullUp / IntermediateNode |
| `LazyDeletionStrategy` | P12 CSB+, P14 | Eintrag nur markiert; kein 50%-occupancy-enforcement |
| `LazySortInsertionStrategy (Fingerprinting)` | P20 | Insert: an Ende des Unsorted-Range anhaengen; Sort erst vor Scan |
| `SequentialInsertHeuristicStrategy` | P03 Masstree | Bei sequenziellem Insert wird alter Knoten nicht aufgespalten |
| `SmartSplitStrategy` | P07 Wormhole | Intelligenter Split-Punkt im Leaf um Anchor-Laenge minimal zu halten (future work) |
| `BulkLoadLevelByLevelInsertion` | P11 CSS, P12 CSB+, P14 | Erst alle Leaves anlegen, dann Level fuer Level Eltern bauen |
| `InsertionPathPrefetchStrategy` | P21 | Bei Insert ist Suchpfad bereits cache-warm; nur neue Knoten bei Splits prefetched |
| `SiblingRedistributionPrefetchStrategy` | P21 | Bei Deletion mit Key-Redistribution wird Geschwister-Knoten geprefetched |
| `RebuildOnSplitStrategy (B^2)` | P06 | Embedded Tree wird bei Page-Split neu konstruiert (nicht inkrementell aktualisiert) |
| `BoundaryAwareSeparatorSelectionStrategy (FDL)` | P20 | Bei sequenziellem Insert: max split point statt Median, um Dense-Layout zu erhalten |
| `NodeReplacementStrategy (ROWEX)` | P08 ART OLC/ROWEX | Lock node+parent → neuen Node allozieren+kopieren → atomarer Pointer-Swap → alten Node mark obsolete |
| `OverflowLeafStrategy (Wormhole)` | P07 | Leafs duerfen ueber MaxSize wachsen wenn Anchor-Bildung wegen Praefix-Konflikten fehlschlaegt |
| `ContentionSplitStrategy` | P20 (vmcache) | Hot-Pages werden bei min. 1/30 Sample-Contention konfliktfrei gesplittet |

### 3.3 Intra-Page Layout-/Encoding-Strategien

| Strategy-Name | Paper | Beschreibung |
|---------------|-------|--------------|
| `PrefixTruncationLayoutStrategy` | P20, P15 Survey 5.3 | Gemeinsamer Praefix wird einmal gespeichert (prefixLength im Header) |
| `HeadsLayoutStrategy (Poor Man's Normalized)` | P20, P15 Survey 6.1 | Erste 4 Bytes jedes Keys im Slot-Array kopiert |
| `HintsLayoutStrategy` | P20 | Fixed-Size Array von 16 Heads aus gleichmaessig verteilten Slots |
| `FingerprintingLeafLayoutStrategy` | P20 | 1-Byte-Hash jedes Keys als Fingerprint-Array im Heap |
| `SemiDenseLeafLayoutStrategy (SDL)` | P20 | Frame-of-Reference: Lower Fence = non-numeric Praefix; numeric part als 4-Byte BE-Int |
| `FullyDenseLeafLayoutStrategy (FDL)` | P20 | Bitmap-Praesenz, Werte direkt im Array; ~500 Records pro 4 KiB |
| `IndirectionVectorLayoutStrategy` | P06 B^2-Tree, Umbra-Pages | Slot-Array mit Range-Array verweist auf Eintraege; logische Reihenfolge != physikalische |
| `InfixSpeicherungStrategy (B^2)` | P06 | Im Indirection-Vector werden Substring-Bytes gespeichert (Praefixe sind im embedded Tree) |
| `SpanNodeLcpCompressionStrategy (B^2)` | P06 | Span-Nodes speichern longest common prefix einer Page-Sektion |
| `LinearizedCompoundNodeStrategy (HOT)` | P02 | Compound-Node in compact bit-string (header + bit positions + partial keys + values) |
| `PointerEliminationStrategy` | P11 CSS, P12 CSB+ (partial) | Child-Pointer per Arithmetik berechnet (b(m+1)+1..b(m+1)+(m+1)) |
| `NodeGroupContiguousLayoutStrategy` | P12 CSB+, P14 | Alle Children eines Nodes contiguous als node group |
| `SegmentedNodeGroupStrategy` | P12 CSB+ | Node-Group in Segmente; Split kopiert nur ein Segment |
| `OrderPreservingCompressionStrategy` | P15 Survey 5.1 | Huffman-codes (order-preserving), Optimum/ALM-Verfahren |
| `KeyNormalizationStrategy` | P15 Survey 5.2, P01 ART (Sec. IV) | Alle Keys → binaere Strings; Vergleich = strcmp; binary-comparable Form |
| `NextNeighborDifferencingStrategy` | P15 Survey 5.4 | Differenz zum unmittelbaren Vorgaenger speichern (mit Anchor/Back-Pointer) |
| `PointerToExtentsCompressionStrategy` | P15 Survey 6.3 | Zusammenhaengende Page-Pointer komprimieren (page-number + count) |
| `IntegerSliceFormationStrategy (Masstree)` | P03 | Schluesselbytes in 64-Bit-Slices verpackt, nativ als Integer verglichen (mit Byte-Swap) |
| `AdaptiveSuffixPlacementStrategy (Masstree)` | P03 | Suffixe adaptiv inline ODER extern gespeichert |
| `PartialKeyEncodingStrategy (HOT 8/16/32-Bit)` | P02 | Single-Mask oder Multi-Mask-Layout fuer Partial Keys |
| `LcpAwareIntegerEncodingStrategy (CoCo)` | P04 | Pro Knoten Integer-Mapping mit lcp-Subtraktion |
| `EncodingSelectionStrategy (CoCo)` | P04 | Pro Knoten EF/PA/BV/DE aus Pool waehlen |
| `AlphabetAwareEncodingStrategy (CoCo)` | P04 | Lokales Alphabet pro Knoten — squeezed Encoding |
| `SuffixTruncationStrategy (SuRF)` | P10 | Vier Varianten: SuRF-Base / SuRF-Hash / SuRF-Real / SuRF-Mixed |
| `PerNodeTypeFindChildStrategy (ART)` | P01 | findChild dispatched nach Node-Typ (Node4 linear, Node16 SIMD, Node48 zweistufig, Node256 direkt) |
| `MultilevelNodeStrategy (START)` | P05 | Ein physischer Knoten umfasst mehrere logische Trie-Levels |
| `RewiredNodeStrategy (START)` | P05 | memfd_create + multiple mmap → sparse virtual pages auf shared physical pages |
| `MultilevelNode4Strategy (START)` | P05 | Nutzt die 12 ungenutzten Bytes eines Node4 als zusaetzliche key-bytes — 4 Levels in 1 Cache-Line |

### 3.4 Concurrency-Strategien (CrossCutting innerhalb Page)

| Strategy-Name | Paper | Beschreibung |
|---------------|-------|--------------|
| `OptimisticLockCouplingStrategy (OLC)` | P03, P06, P08, P20 (vmcache) | 5-Schritt-Lookup mit Version-Validierung; Reader nur Loads auf Version |
| `ROWEXStrategy (Read-Optimized Write Exclusion)` | P02 HOT, P08 ART | 4-Schritt Node-Replacement; atomare Pointer-Swap; Reader sehen alt ODER neu |
| `RCUStrategy` | P29 McKenney | Two-Phase Update + Grace Period; lock-free reads |
| `HazardPointersStrategy` | P30 Michael | Per-Thread Hazard-Pointer-Records; wait-free reclamation |
| `EpochBasedReclamationStrategy` | P02 HOT (Sec 5), P08 (impliziert) | Obsolete-Marker statt sofortigem Free; epoch-based memory reclamation |
| `HandOverHandOptimisticStrategy` | P03 Masstree | Reader nutzen Versionsnummern (vinsert/vsplit-Counter); Writer halten lokale Spinlocks |
| `QuiescentStateBasedReclamationStrategy` | P29 (DYNIX/ptx Variants) | Per-CPU-Tracking von Quiescent States |
| `TripleClassConcurrencyStrategy (Wormhole)` | P07 | Class 1 (Lookup, RCU) / Class 2 (single-leaf, RW-Lock) / Class 3 (split/merge, MutEx) |
| `CopyOnWriteStrategy` | P02 HOT, P19 (Hyder use-case) | Writes erzeugen neue Version, Reader sehen alte; vermeidet Cache-Line-Bouncing |
| `DualHashTableCopyOnWriteStrategy (Wormhole)` | P07 | T1/T2 fuer copy-on-write des MetaTrieHT |

---

## 4. IHeuristic-Familie (Wert-Berechnungen)

IHeuristics sind Funktionen `(Inputs) → Werte`, die Strategien parametrieren. Sie konsumieren Saeule-B-Plattform-Modelle und liefern Strategie-Parameter.

### 4.1 Statische Cost-Model-Heuristiken

| Heuristic-Name | Paper | Eingang → Ausgang |
|----------------|-------|--------------------|
| `OptimalNodeSizeHeuristic` | P13 Hankins-Patel (Eq. 1) | (cpi, miss_latency, pred_penalty, tlb_penalty) → optimal node size; cost = I·cpi + M·miss_latency + B·pred_penalty + T·tlb_penalty |
| `OptimalPrefetchDistanceHeuristic` | P21 Chen-Gibbons-Mowry | (B = T1/T_next, w) → k_optimal = ceil(B/w) |
| `OptimalChunkSizeHeuristic` | P21 | (B, m children-per-cacheline) → c_optimal = ceil(B/(2m)) |
| `OptimalNodeWidthHeuristic (pB+)` | P21 (Equation 1) | (B, m, N) → w_optimal = 8 (typisch) |
| `OptimalWidthMultiTierHeuristic` | P22 fpB+ | (TierLatencies[], FanOutGoal) → pro Tier optimale Knotengroesse |
| `CardenasFormulaCacheHitRateHeuristic` | P13 (Eq. 9) | (lambda, q) → X_D Steady-State Cache Occupancy |
| `BranchMispredictionCountingHeuristic` | P13 (Eq. 16) | (h, sigma) → B = h + log_2(sigma)/2 |
| `TLBMissCountingHeuristic` | P13 (Eq. 18) | (tlb_cap, page_sz, levels) → erwartete TLB-Misses |
| `SpeculativeFetchAccountingHeuristic` | P13 (Eq. 13) | (l) → m_spec = 1.5 · log_2(l+1) - 0.5 |
| `CacheCostDPHeuristic (START)` | P05 (Sec. IV.B) | (Tree, ICacheLevel-Latenzen) → optimal Multilevel-Replacement via Bellman-DP |
| `BellmanDPNodeOptimizerHeuristic` | P05 | Bottom-up DP auf ART; combined-optimal-cost je Multilevel-Level |
| `LevelAwareCacheCostExtrapolationHeuristic` | P05 (Sec. IV.A) | (C_L1, C_RAM, L_Li) → C_{L,Li} approximiert tiefere Cache-Level-Kosten |
| `DataAwareCollapsingHeuristic (CoCo)` | P04 (Sec. 4.2) | (Knoten v) → optimale Levels l zum Kollabieren via Post-Order-DP |
| `GilItaiOptimalLayoutDPHeuristic` | P16 (Related Work) | (Tree, Block-Size B) → exakt optimales Layout via DP, O(NB² log Δ) |
| `ProbabilityGreedyLayoutHeuristic` | P16 Theorem 1 | (Tree, Probabilities, B) → Greedy-Layout, (B-1)/B optimal |
| `WidthCostModelHeuristic (Hankins)` | P13 | (Knotengroesse, Workload) → analytische Kosten |
| `CompressionVsSearchTradeoffHeuristic` | P04 (alpha-Parameter), P20 | (alpha) → space-time trade-off control |
| `OverflowVsOffloadHeuristic (fpB+)` | P22 | (PageSize, OptimalNodeSize, MismatchRatio) → Aggressive-Placement-Decision |
| `DiskFirstVsCacheFirstHeuristic (fpB+)` | P22 | (MemoryFootprint, IORatio) → Architektur-Wahl |
| `BranchFactorSelectionHeuristic (CSB+)` | P12 | m = (cache_line_size - sizeof(firstChild) - sizeof(nKeys))/sizeof(key) |
| `SegmentationPolicyHeuristic (CSB+)` | P12 | (Workload, Space-Budget) → Anzahl Segmente |
| `HardcodedSearchVariantHeuristic (CSB+)` | P12 | (Compiler-Capability, Workload) → basic / uniform / variable |
| `OptimalPartitionCountHeuristic (P32)` | P32 Schmidt (TUD) | (DTLB-Cap, STLB-Cap, Prefetcher-Streams, Cache-Associativity) → optimal Partition-Count |
| `OptimalStrideSizeHeuristic (P32)` | P32 | (Memory-Tier, Padding) → optimal Stride (z.B. 127.32 MiB bei Sapphire Rapids) |
| `BurstLengthHeuristic (P31)` | P31 Ungethuem | (cache_line, bus_width) → Burst Length 4 oder 8 |

### 4.2 Adaptive/Runtime-Heuristiken

| Heuristic-Name | Paper | Eingang → Ausgang |
|----------------|-------|--------------------|
| `AdaptivePrefetchDistanceHeuristic` | P23 Khan (Eq. 6) | (L_miss_live, L_iter_live) → O_r = MissLatency / IterationLatency |
| `RuntimeOffsetAdaptationHeuristic` | P23 | (live cycle counts) → distance update |
| `AffineDistanceHeuristic` | P23 (Eq. 7-10) | (O, A_j, B_j) → I_rj = O · A_j + B_j |
| `CostBenefitGatedHeuristic` | P23 (Eq. 4) | (sum L_{1,i}, R = B + sum M + F) → activate prefetch yes/no |
| `TemplateSpecializerHeuristic` | P23 | (p_instructions, modify_locations) → modified template (2-5 Instructions) |
| `OnlinePerformanceCounterHeuristic` | P23 | (HW counters) → live latency input fuer alle anderen Heuristiken |
| `ScanFrequencyCounterHeuristic` | P20 | saturating Counter +1 bei Scan (15%), -1 bei Point-Op (5%); 0..3 |
| `KeyTypeHeuristic` | P20 | (uniqueness der Heads) → String vs Integer Layout-Wahl |
| `HeadQualityHeuristic` | P20 | (Threshold 16/64) → eindeutige Heads → Layout-Wahl |
| `BoundaryNodeHeuristic` | P20 | sequential-insert detection → FDL-Partitioned-Splitter |
| `LayerCreationDecisionHeuristic (Masstree)` | P03 | (common-prefix-length) → create_new_layer? |
| `MinimumDistinguishingPrefixHeuristic (Wormhole)` | P07 | Anchor wird so kurz wie moeglich gehalten |
| `LongestPrefixMatchByLengthHeuristic (Wormhole)` | P07 | Binary Search auf Praefix-Laengen statt Trie-Walk |
| `RecursiveCommonPrefixDecompositionHeuristic (B^2)` | P06 (3.1.1) | Pro Page-Bereich: lcp>0 → Span-Node, sonst Decision-Node mit Median |
| `MonitorClusteringHeuristic (P26)` | P26 (Algorithm 1) | (Lookup-Keys, w forgetting factor) → Prefetch-Table mit hot Pfaden |
| `PathReadCounterHeuristic` | P26 | per-Block Counter → Hot-Path-Detection (NICHT per Tuple) |
| `PerNodeHistogramHeuristic (P28)` | P28 Kuehn | per-Node Counter pro Comparison-Key → P_n_x = {p_ck1...p_ckn} |
| `LeafOnlyCounterHeuristic (PRT-ART NEU)` | NEU 2026-05-08 (Kuehn-Mail) | nur Leaf-Pages tracken; vermeidet Cache-Coherence-Storm |
| `LeafOnlySampledCounterHeuristic<N>` | NEU 2026-05-08 | Sampling 1/N reduziert Schreib-Frequenz |
| `RetroactiveAggregationBarrierHeuristic` | NEU 2026-05-08 | Periodisch (nach N Queries) Counter-Stand vom Leaf zur Root propagieren |
| `JaccardSimilarityTelemetryHeuristic (P27)` | P27 Hierarchical Prefetcher | per-Bundle Avg Jaccard Index → Recurrence-Quality |
| `BundleIdentificationHeuristic (P27)` | P27 (Algorithm 1) | (call_graph, threshold=200KB) → Bundle Entries |
| `HotPathExtractionHeuristic (P28)` | P28 | Greedy: root → highest-prob child → ...; disjunkte Hot Paths |
| `SlidingWindowDriftDetectionHeuristic (P28 Future)` | P28 | Verteilungs-Drift erkennen → re-layouting trigger |
| `LayoutDegradationHeuristic` | P19 (impliziert) | (# Updates seit letztem Global-Relocation) → Trigger |
| `AlphaTuningHeuristic` | P19 | (Workload Insert/Search Ratio, Cacheline) → optimal α |
| `ConfigurationLookupHeuristic` | P14 Samuel-Pedersen-Bonnet | (KeySize, NodeSize, SearchStrategy, Workload) → optimale Konfiguration |
| `LinearVsBinarySearchPreferenceHeuristic` | P14, P15 Survey | (CPU, Knotengroesse) → linear (Itanium2 < 384B) oder binary |
| `EagerVsLazyPrefetchHeuristic` | P14, P15 Survey | (CPU In-Order vs Out-of-Order) → trigger timing |
| `FBSizeAwareLimitingHeuristic (P25)` | P25 Mahling-Weisgut-Rabl | (FB-Size aus ILivePlatformModel) → Prefetches ≤ FB-Size |
| `PrefetchReliabilityHeuristic (P25)` | P25 | (FB_FULL Counter, Strong/Weak detection) → switch Half/Full Node Prefetch |
| `AccessProbabilitySortedPrefetchHeuristic (P25)` | P25 | bei WEAK reliability → Header/Middle-Key zuerst |

### 4.3 Workload-/Negativ-Befund-Heuristiken

| Heuristic-Name | Paper | Eingang → Ausgang |
|----------------|-------|--------------------|
| `WorkloadDetectionHeuristic` | P20, P26 | (Scan/Point-Ratio, Skew) → Strategy-Type-Wahl |
| `NegativPredictionDisableHeuristic (P24)` | P24 Naderan | (Coverage, Overprediction) → Prefetch deaktivieren |
| `OverpredictionGateHeuristic` | P24 | (overprediction/coverage > threshold) → Prefetch-Degree reduzieren |
| `ReuseDistanceTelemetryHeuristic` | P24 | per-IFanout Counter Histogramm |
| `WorkloadTypeStrategyHeuristic` | P24 | (Miss-Ratio<0.5%, Coverage>50%) → cache-friendly / prefetch-friendly / scale-out |
| `EnergieAwareCacheHeuristic` | P24 | (Memory-Traffic, Energie-Budget) → Prefetcher gating |
| `StrategyCompatibilityMatrixHeuristic` | P15 Survey | (Strategie-Kombination) → Compatibility-Score |
| `WorkloadAdaptationHeuristic` | P14, P19 | (Point-Query / Scan / Insert / Mixed) → Strategy-Wahl |
| `CriticalPathHeuristic (P31)` | P31 | (ISA-Extension Komplexitaet) → Frequency-Tradeoff |
| `UniversalityVsTechnicalFeasibilityHeuristic (P31)` | P31 | Tradeoff fuer ISA-Extension-Design |

### 4.4 Layout-Invarianten- und Topologie-Heuristiken

| Heuristic-Name | Paper | Eingang → Ausgang |
|----------------|-------|--------------------|
| `ProbabilityWeightedRootBlockHeuristic (Bender)` | P16 (Lemma 1) | (Tree, Probabilities, B) → Root-Block Subtree-Auswahl |
| `EpsilonRelaxedGreedyHeuristic` | P16 Theorem 2 | (epsilon) → 1/ε optimal Layout |
| `NeighborhoodConnectednessAlphaHeuristic` | P19 | (α >= 2) → Layout-Invariante |
| `ConflictMissPredictionHeuristic` | P18 | (SetAssociativity, BlockHierarchy) → erwartete Konflikt-Miss-Rate |
| `AliasingCorrectionAdressPermutationHeuristic` | P18 | (i-te Cache-Block Adresse) → Permutation A_k...A_2A_1A_0 |
| `RangeDecompositionHeuristic (B^2)` | P06 (3.1.1) | Threshold ~32 Eintraege → Sub-Range-Stop |

### 4.5 Hardware-Probe-/Live-Heuristiken

| Heuristic-Name | Paper | Eingang → Ausgang |
|----------------|-------|--------------------|
| `ClflushNodeProbeHeuristic` | P05 START (IV.A) | CLFLUSH + LFENCE-basiert → live Cache-Cost-Messung |
| `LatencyProbeHeuristic` | P05, P25 | live → memory-latency je Tier |
| `BranchPredictorProbeHeuristic` | (Empfehlung) | live mispredict-rate |
| `SimdThroughputProbeHeuristic` | (Empfehlung) | live SIMD throughput |
| `DTLBSTLBCapacityProbeHeuristic (P32)` | P32 | live DTLB/STLB-Capacity → Partition-Count |
| `HardwarePrefetcherStreamLimitProbeHeuristic (P32)` | P32 | live Stream-Tracking-Limit |
| `CacheAssociativityDisalignmentHeuristic (P32)` | P32 | 576-Byte-Padding → Cache-Set-Thrashing-Vermeidung |
| `StridedVsSimdHeuristic (P32)` | P32 | (AVX-512 Plattform + grosser TLB+Prefetcher) → strided scalar default |
| `NumaMemoryLatencyHidingHeuristic (P32)` | P32 | (local vs remote DRAM/HBM) → strided pattern hides remote latency |

---

## 5. Iterator-Inventar

Iteratoren sind die Querschnitts-Schicht zwischen Nodes/Pages/Strategien und Konsumenten. Sie sind in REV-2 explizit verlangt, in der Concept-Hierarchie aber unterspezifiziert. Die Paper-Lektuere zeigt klare Konkretisierungen:

### 5.1 INodeIterator-Konkretisierungen

| Iterator-Name | Paper | Beschreibung |
|---------------|-------|--------------|
| `ArtByteByByteNodeIterator` | P01 ART | Iteriert byte-weise (Span = 1 Byte) ueber Node-Children; per-Type findChild Dispatch (Node4/16/48/256) |
| `HotDiscriminativeBitsNodeIterator` | P02 HOT | Iteriert ueber diskriminative Bits eines Compound-Nodes; 4-Wege-Insert-Dispatch |
| `MultilevelStartNodeIterator` | P05 START | Iteriert ueber mehrere Trie-Levels innerhalb eines physischen Multilevel-Knotens |
| `LoudsRankSelectNodeIterator` | P09 Jacobson, P10 SuRF, P04 CoCo | first_child = select_0(rank_1(m))+1; next_sibling = m+1; parent = select_1(rank_0(m)) |
| `DfudsNodeIterator` | P04 CoCo | Topologie-Encoding mit rank-Operation |
| `MacroNodeIntegerIterator (CoCo)` | P04 | iteriert ueber lcp-bereinigte Integer-Encodings |
| `WormholeAnchorIterator` | P07 | Triple-Iteration: MetaTrieHT → MetaTrie → LeafList |
| `MasstreePermutationIterator` | P03 | Iteriert ueber Permutation-Field (16 × 4-Bit-Indizes) — atomar lesbar |
| `B2DecisionSpanNodeIterator` | P06 | Decision-Node (Byte-Range) und Span-Node (LCP) gemischt iteriert |
| `CSBFirstChildPlusOffsetIterator` | P12 | Children via firstChild + arithmetic offset |
| `CSSPointerlessChildIterator` | P11 | Children via b(m+1)+i Arithmetik |
| `BPlusSlotIterator (slotted page)` | P20, klassisch | Iteriert ueber Slot-Array (16-bit offset+keyLen+valLen) |

### 5.2 ISearchPageIterator (Range-Scan-Implementierungen)

| Iterator-Name | Paper | Beschreibung |
|---------------|-------|--------------|
| `LinkedLeafSequenceRangeIterator` | P03 Masstree, P07 Wormhole, klassisch B+ | Doppelt verkettete Leaves (klassisch); linear walk |
| `PerLevelCursorRangeIterator (SuRF)` | P10 (Sec. 2.4) | Cursor pro Level vermeidet teure rank/select-Calls fuer move-to-parent/move-to-child |
| `JumpPointerRangeIterator (External chunked)` | P21, P22 | Externes Array von Leaf-Adressen; k Leaves voraus prefetched; chunked-list mit Hint-Pointer |
| `JumpPointerRangeIterator (Internal)` | P21 | Bottom-Non-Leaves dienen als Jump-Pointer-Array |
| `DualJumpPointerRangeIterator` | P22 | Internal Array (Cache-Tier) + External Array (Disk-Tier) |
| `JumpPointerVersionChainIterator (P26)` | P26 | 2-ahead Jump Pointers fuer MVCC Version-Chains |
| `WormholeLinkedLeafIterator` | P07 | Doppelt verkettete Leaves mit Anchor-Boundaries |
| `LazySortRangeIterator (Fingerprinting)` | P20 | Sort vor Scan triggert (downside fuer Concurrent-Scan) |
| `PartitionedStridedRangeIterator (P32)` | P32 | n/s Partitionen; pro Pass i-tes Element jeder Partition (Multi-Stream-Prefetcher) |
| `LoudsLinearScanIterator` | P09, P04 | BFS-Order Walk via rank/select |
| `LeafLinkedListWithIndirectionVectorIterator` | P06 B^2 | Range-Array Translation (logisch ↔ physisch) ueber Leaf |

### 5.3 ISearchPageStrategyIterator (Cross-Algorithm-Iteration ueber Permutationen)

Iteriert ueber alternative Strategie-Konfigurationen (z.B. fuer Cost-Model-Vergleich, Auto-Tuning, Batch-Probing).

| Iterator-Name | Paper | Beschreibung |
|---------------|-------|--------------|
| `ConfigurationTableIterator` | P14 Samuel-Pedersen-Bonnet | Iteriert (KeySize, NodeSize, SearchStrategy)-Tupel; stoppt am Optimum |
| `EncodingPoolIterator (CoCo)` | P04 | Iteriert {EF, PA, BV, DE} pro Knoten — Cost-basierte Auswahl |
| `LayoutSelectorIterator (Adaptive B-Tree)` | P20 | Iteriert {Comparison, Fingerprinting, SDL, FDL} pro Leaf |
| `MultilevelLevelIterator (START)` | P05 | Iteriert ueber moegliche Multilevel-Level i pro Knoten — Bellman-DP |
| `PrefetchTacticIterator (Cluster D)` | P21+P22+P23 | Iteriert {WideNodePrefetch, JumpPointerScan, TemplateSpecializer} |
| `NodeTypeIterator (ART)` | P01 | Iteriert {Node4, Node16, Node48, Node256} bei Grow/Shrink-Decision |
| `HotPathLayoutVariantIterator (P28)` | P28 | Iteriert {H, NL, HL, HS, HLS} Layout-Strategien |
| `SearchStrategyIterator` | P14, P15 Survey | Iteriert {Linear, Binary, LoopUnrolled, Interpolation, PoorMansKey} |
| `RcuFlavorIterator` | P29 + Folge | {DYNIX/ptx 2.1, DYNIX/ptx 4.0, voluntary-context-switch, generation-facility, qsbr, mb, membarrier, signal} |
| `ConcurrencyMechanikIterator` | P08 + P29 + P30 | {OLC, ROWEX, RCU, HazardPointers, EpochBasedReclamation} |

### 5.4 comdare::prt_art<K, V>::iterator (Endkonsumenten-Iterator)

Spezialisierte Konsumenten-Iteratoren fuer den eigentlichen Index-Endbenutzer.

| Iterator-Name | Spezialisierung | Verbindet mit |
|---------------|-----------------|----------------|
| `comdare::prt_art<K,V>::key_iterator` | Iteriert nur Keys (ohne Values) | INodeIterator (lesend) |
| `comdare::prt_art<K,V>::value_iterator` | Iteriert nur Values | ISearchPageIterator (Leaf-Walk) |
| `comdare::prt_art<K,V>::const_iterator` | Read-Only (RCU/HP-kompatibel) | RCU-Quiescent-State / HP-Records |
| `comdare::prt_art<K,V>::range_iterator` | Range-Scan [low, high) | ISearchPageIterator + per-level cursors |
| `comdare::prt_art<K,V>::reverse_iterator` | Backward-Walk | Sibling-Pointer in beide Richtungen (P07 Hint-Follow) |
| `comdare::prt_art<K,V>::prefix_iterator` | Iteriert alle Keys mit gegebenem Praefix | Trie-Walk-Down + Subtree-Scan |
| `comdare::prt_art<K,V>::concurrent_iterator` | OLC/ROWEX-konsistent (Snapshot oder Live) | OLC-Restart oder ROWEX-Atomic-Pointer-Swap |
| `comdare::prt_art<K,V>::filter_iterator` | Approximate Membership (FPR) | SuRF-Suffix-Verifikation; one-sided error |
| `comdare::prt_art<K,V>::probabilistic_iterator` | Probability-Order Walk (Heavy-Tail) | P16/P28 Greedy Hot-Path |
| `comdare::prt_art<K,V>::partitioned_iterator` | Strided/Multi-Stream-Walk fuer Aggregation | P32 Partition-Stride |

---

## 6. Neue Concept-Klassen (REV 3 Vorschlaege)

Die Paper-Lektuere enthuellt zahlreiche Konzepte, die in REV 2 entweder fehlen oder unterspezifiziert sind. Hier die konsolidierte Liste mit Begruendung pro Vorschlag.

### 6.1 Saeule A — Strukturelle Concept-Klassen

| Klasse-Name | Quelle (Cluster) | Begruendung |
|-------------|------------------|-------------|
| `ITopologyEncoding` | A (P04 CoCo, P09 Jacobson, P10 SuRF), B (B+ vs CSS-pointerless) | LOUDS / DFUDS / BP / Pointer / Bit-Array sind alternative Repraesentationen derselben Trie-Struktur — orthogonal zur Knoten-Layout-Variante |
| `IEncodingPool` + `IEncodingSelector` | A (P04 EF/PA/BV/DE Pool), A (P02 HOT 9 Layouts), A (P10 SuRF Variants), D (P20 Layout-Pool) | Pool-of-Encodings mit Selection-Strategy ist wiederkehrendes Pattern |
| `ILayerDependentLayoutStrategy` | A (P02 HOT, P05 START, P10 SuRF, P22 fpB+) | Konkretisierung von ISearchPagesStrategyPattern: Layer-Tiefe bestimmt Layout |
| `ICompositionMode` | A (P02 HOT, P04 CoCo, P05 START Compound) | Marker: 1:1 (klassisches ART) vs. 1:N (Compound-Knoten = mehrere logische INodes pro physischer ISearchPage) |
| `IUpdatability` | A (P01/P02/P05 dynamic vs P04/P09/P10 static) | Marker: Static / BulkUpdate / Incremental / Concurrent |
| `ISpaceGuarantee` | A (P01/P05 52B/Key, P09 2n+o(n)) | Property einer ISearchPagesStrategyPattern: WorstCaseBoundPerKey / AsymptoticInfoTheoreticBound / EmpiricalBoundOnly |
| `IPartialKeyEncoding` | A (P02 HOT 8/16/32 Bit), A (P03 IntegerSlice) | ISearchPage-interne Key-Speicherung (Subkonzept zu ICachePage) |
| `IBranchDispatchStrategy` | A (P01 ART per-Type findChild) | Per-Node-Type findChild als Visitor-Konkretisierung |
| `ISpanWidthStrategy` | A (P01 1B, P05 multi-Level, P02 dynamic, P04 lokal) | 1 Byte / variable / multi-level — bisheriges ISearchPagesStrategy deckt nur 1-Byte ab |
| `IPathCollapsePolicy` | A (P01, P02, P05) | Lazy-Expansion + Path-Compression als generalisierte Strategie |
| `IFanoutGrowShrinkPolicy` | A (P01 Adaptive Nodes) | Konkretisierung von ISearchPagesStrategyPattern: wann wechselt Knoten-Layout-Variante |
| `INodeOverflowResolutionStrategy` | A (P02 HOT 4-Wege-Insert) | Normal/LeafPushdown/ParentPullUp/IntermediateNode |
| `IKeyTransformStrategy` / `IKeyNormalizer` | A (P01 binary-comparable Sec. IV), C (P15 KeyNormalization) | Orthogonaler Aspekt zwischen User-Key und Trie-Key (Vorzeichenflip, Float-Klassifikation, ICU UCA, Compound Keys, Null Handling) |
| `IPointerEncoding` / `ILeafEncodingStrategy` | A (P01 TaggedPointer Sec. III.D), A (P02 HOT type-bits in LSB) | Tagged pointers / EmbeddedValue in Pointer-Slots |
| `IFilterStrategy` / `IApproximateMembershipStrategy` | A (P10 SuRF) | Geschwister-Concept zu ISearchPage; Bloom-Filter / SuRF / ARF / Cuckoo-Filter |
| `IFalsePositiveRateModel` | A (P10 SuRF) | FPR-Garantien als first-class Property einer SearchPage |
| `ISliceAccessor` | B (P03 Masstree IntegerSlice) | Liest k-Byte-Slices als nativ vergleichbare Integers; parametriert durch slice-Width (8, 16) |
| `ITrieLayerStrategy` | B (P03), A (P07 Anchor-Praefix-Layer), A (P01) | Praefix-konsumierende Layer mit `next_layer_pointer`-Relation; Sub-Pattern von ISearchPagesStrategyPattern |
| `IAtomicSlotIndirection` / `IIndirectionVector` | B (P03 Permutation, P06 RangeArray), Umbra-Pages | Trennung logische vs physikalische Reihenfolge — lock-free-friendly |
| `IEmbeddedSearchPage` | B (P06 B^2-Tree, P07 Wormhole, P11 CSS-Directory) | ISearchPage mit innerer Mini-Search-Struktur (Tree-of-Trees Pattern) |
| `IMultiStrategySearchPage` | B (P07 Wormhole Hash+Trie+List) | ISearchPage, das intern verschiedene ISearchPageStrategies fuer Sub-Phasen verwendet |
| `IAnchorKey` | B (P07 Wormhole AnchorKey), A (P03 lowkey/highkey), B (P12 segment splitter) | Spezielle borderline key mit Constraints (Ordering + Prefix-Condition) |
| `INodeGroup` | B (P12 CSB+) | Contiguous-storage-Block fuer Children (firstChild + offset) |
| `ISegmentedNodeGroup` | B (P12 CSB+ Segmented) | Variante mit mehreren Segmenten |
| `IPointerlessNode` | B (P11 CSS) | Pointer-Elimination als Concept |
| `IDirectoryStructure` | B (P11 CSS Directory ueber Sorted Array) | Tree-Index als Verzeichnis ueber externem sorted-array |
| `ICacheStrategyAwareness` | C (P17 Cache-Oblivious vs P18/P19 Cache-Sensitive) | Marker: CacheOblivious / CacheSensitive / Hybrid |
| `ILayoutInvariant` | C (P19 Saikkonen NeighborhoodConnectedness) | Formale Invariante als Strategy-Property; Sub-Klassen: WeightBalanceInvariant, VEBLayoutInvariant, DensityThresholdInvariant, RootBlockProbabilityInvariant, NeighborhoodConnectednessInvariant |
| `ILayoutCorrectionStrategy` | C (P18 AliasingCorrection) | Korrektur fuer Set-Associative-Caches; Sub: AliasingCorrection / Identity |
| `ICompositeStrategy` | C (P18+P19 Builder + Maintenance) | Kombiniert eine *aufbauende* mit einer *erhaltenden* Strategy |
| `IAdaptationTrigger` | C (P19) | OnEveryStructureModification / OnLayoutDegradationThreshold / Periodic / Manual |
| `IBranchingFactor` (= Δ) | C (P16, P17 Theorie) | Inneres-Knoten-Fanout (verschieden von IFanout-Wrapper-Concept) |
| `IStrategyCompatibilityMatrix` | C (P15 Survey) | Konflikte/Verstaerkungen zwischen Strategien (Survey nennt "they often conflict") |
| `IAccessProbabilityDistribution` | C (P16 Bender) | Workload-Modellierung als Strategy-Input; Sub: Uniform / HeavyTail / Empirical / Learned |
| `IWideNodeStrategy` | D (P20+P21) | Knoten-Breite als orthogonaler Parameter zu ILayoutStrategy |
| `IPrefetchStrategy` | D (P21, P22, P23, P25) | Orthogonal zu IPageLayout; Sub: WideNodePrefetch / JumpPointerScan / TemplateSpecializer |
| `IPointerChasingResolutionStrategy` | D (P21) | Tactic-Pattern: DataLinearizationTactic / HistoryPointerTactic |
| `IJumpPointerStorage` | D (P21 internal vs external) | Architektur-Entscheidung Jump-Pointer im Tree oder extern |
| `IGranularityMismatchResolver` | D (P22 fpB+) | OverflowResolverStrategy / OffsetCompressionResolverStrategy / AdaptiveNodeSizeResolverStrategy |
| `IFractalLayoutStrategy<OuterTier, InnerTier>` | D (P22 fpB+) | Auessere Granularitaet enthaelt vollstaendiges inneres Layout (rekursiv anwendbar) |
| `IMultiTierCacheStrategy<Tier[]>` | D (P22, partiell P20) | Getrennte Strategien pro Tier (z.B. [CacheLine, Page, Disk]) |
| `IRuntimeAdaptiveHeuristic` | D (P23) | getCurrentLatency / computeOptimalDistance / shouldPrefetch |
| `IDistanceComputationHeuristic` | D (P23) | Affine I = O*A + B als generisches Pattern |
| `ITemplateSpecializerStrategy` | D (P23) | Template-Code-Pattern fuer JIT-aehnliche Anpassung ohne Code-Generation |
| `ICostBenefitGatedStrategy` | D (P23) | Generisches Pattern: aktiviert wenn Benefit > Overhead |
| `ICacheCostModel` | D (P21+P22+P13) | Vollstaendige Kostenmodellierung (instructions·cpi + cache_misses·miss_latency + branch_mispredicts·pred_penalty + tlb_misses·tlb_penalty) |
| `IPlatformAwareSizingModel` | D (P13) | Zusammengesetzter Concept-Type, der Saeule-B-Hardware-Modelle in Auswahl-Heuristik verbindet |
| `IPrefetchReliabilityStrategy` | E (P25) | WEAK / STRONG / KONFIGURIERBAR fuer FB-Behavior |
| `IPathReadCounter` (Achse 11 Telemetry) | E (P26 etabliert) | Per-Block (nicht per-Tuple) Counter |
| `ILeafOnlyCounter` (NEU PRT-ART) | E (Kuehn-Mail 2026-05-08) | Counter NUR auf Leaf-Pages (vermeidet Cache-Coherence Storm) |
| `ILeafOnlySampledCounter<N>` (NEU) | E | Sampling 1/N reduziert Schreib-Frequenz |
| `IRetroactiveAggregationBarrier` (NEU) | E | Periodisch Counter-Stand vom Leaf zur Root propagieren |
| `IProbabilityHintsHeader` (PRT-ART eigen) | E (P27 Bundle-Tags verwandt) | Lookup-Hints in IRootPage / IFanout-Header |
| `IConcurrencyDiscipline` | F (P08+P29+P30) | 8 Disziplinen: Page / Node / Array / DataStructure / Path / MemoryRead / MemoryWrite / MemoryReadWrite / SimdThread / SimdFlow |
| `IConcurrencyMechanik` | F (P08+P29+P30) | OLC / ROWEX / RCU / HazardPointers / EpochBasedReclamation |
| `IRcuFlavor` | F (P29) | DYNIX/ptx 2.1, 4.0, voluntary, generation, qsbr, mb, membarrier, signal |
| `IMemoryReclamationStrategy` | F (P29 RCU, P30 HP, P02/P08 EBR) | Orthogonal zur Lock-Free-Algorithmus selbst |

### 6.2 Saeule B — Plattform-Modell-Concept-Klassen

| Klasse-Name | Quelle (Cluster) | Begruendung |
|-------------|------------------|-------------|
| `IRankSelectPrimitive` | A (P09, P10, P04) | rank/select-Operationen; Sub: BitVectorRank (popcount), JacobsonTwoLevelDirectory, PoppyRank |
| `IPlatformProbe` | A/D (P05 START Probing) | Sub: ClflushNodeProbe, LatencyProbe, BranchPredictorProbe, SimdThroughputProbe, DTLBSTLBProbe (P32), HardwarePrefetcherStreamProbe (P32) |
| `IModelAcquisitionStrategy` | A (P05 explicit) | Wie wird ILivePlatformModel gewonnen? |
| `IVirtualMemoryStrategy` | A (P05 START Rewiring) | DirectMapping / RewiredSharedPages / HugePages |
| `IBranchPredictorModel` | A/B (P01, P13) | Misprediction-Cost als Plattform-Kennzahl |
| `IBitManipulationFeatureGate` | A (P02 HOT BMI2 PEXT/PDEP, AVX2, popcount) | Feature-Gate mit Fallback |
| `IStorageMedium` | A (P10 SuRF SSD/HDD/NVRAM/DRAM) | Hierarchy-Konzept |
| `IPageCacheModel` | A (P10 SuRF OS Page Cache + App Block Cache) | 2-stufige Cache-Layer ueber ICacheLevel |
| `IConcurrencyProtocol` | A/F (P02 ROWEX, P03 OLC, P08, P29, P30) | Orthogonal sowohl zu Saeule A als auch B |
| `IRebuildScheduler` | A (P05 START Self-Tuning) | Time-/Change-/Manual-basiert |
| `IRebuildCostModel` | A (P04 CoCo O(N h^2) Bauzeit) | Bauzeit-Modell, fehlt bisher |
| `IWorkloadModel` | A (P05 future) | Read-Only / Read-Mostly / Write-Heavy / Mixed / Skewed / Range-Heavy |
| `ICellProbeModel` vs. `IWordProbeModel` | A (P09 Jacobson) | Zwei alternative Plattform-Modelle |
| `IPositionalCorrespondencePrefetch` | A (P10 SuRF) | Prefetch basierend auf Layout-Invarianten |
| `ICacheConflictModel` | C (P18 SetAssociativity) | FullAssociativeModel vs SetAssociativeConflictModel |
| `ITemporalCacheStrategy` (Instruction-Cache) | C (P15 Sektion 7) | Instruction-Cache + Code-Locality (REV 2 ICachePage ist Daten-orientiert) |
| `IIntelligentDMA` (Compute-Offload) | F (P31 iDMA) | Push-Down logic to Memory Controller; Submodules: Configurator, AGU, DataFetcher, Crawler |
| `IComputeOffload` | F (P31 iDMA) | Strategie "wo wird Operation ausgefuehrt?" (PE / iDMA / App-Core / FPGA) |
| `IHardwareExtension` (umfangreiche Sub-Hierarchie) | F (P31 TUD) | WAH/PLWAH/COMPAX (Bitmap), Hash+Lookup/Insert, CityHash32, Hash Sampling, MergeSort, Intersection/Union/Difference, SortMergeJoin, SortMergeAggregation |
| `IMemoryDecorator` (NFP-Kontext) | F (P33 VAMPIR) | Allokationen tragen NFP-Kontext (latency, throughput, transience, reliability, wearout, random accessibility, cache coherence) |
| `IHeterogeneousAllocator` (V-malloc) | F (P33 VAMPIR) | Heterogene Memory-Auswahl pro Allokation |
| `IMigrationPolicy` | F (P33 VAMPIR Compensation) | Transparente Daten-Migration zwischen Memory-Tiers |
| `ICompileTimeNegotiator` | F (P33 VAMPIR Multi-Query Negotiation) | Compile-Time-Negotiation fuer Multi-Query-Optimierung |
| `IPipelineScheduler` | F (P33 VAMPIR) | Operation-Pipelines mit Memory-Awareness |
| `IAccessPatternStrategy` (sequential vs strided vs simd) | F (P32 To-Stride) | Wahl Access-Pattern; "Strided > SIMD" als Re-Denken |
| `IPaddingStrategy` | F (P32) | 576-Byte-Padding fuer Cache-Set-Disalignment |
| `IInformationTheoreticLowerBound` | A (P09) | Optimality-Marker fuer Encoding-Strategien |
| `IPositionalAddressing` | A (P09 Implicit Addressing via Position-in-Bitstring) | Implicit Addressing als Concept |

---

## 7. Lueckenanalyse

### 7.1 Concept-Klassen unterspezifiziert in REV 2

| Concept | Defizit | Empfehlung |
|---------|---------|------------|
| `INode` (REV 2) | 1:1 Annahme zwischen ISearchPage und INode kollidiert mit Compound-Pattern (HOT/CoCo/START) | Klarstellung: ISearchPage hostet `[N] INode` (1:N); `ICompositionMode`-Marker einfuehren |
| `ISearchPagesStrategyPattern` | Nur homogen impliziert; heterogen + hierarchisch + runtime-parametriert nicht modelliert | 4 Konkretisierungen: Homogeneous/HeterogeneousAdaptive/HierarchicalFractal/OrthogonalRuntimeParametrized |
| `ICacheStrategy` (Visitor) | Erfasst Daten-Caching, aber nicht Instruction-Cache | `ITemporalCacheStrategy` ergaenzen (P15 Sektion 7) |
| `IFanout` | Nur Branching-Faktor; nicht Topologie-Encoding | `ITopologyEncoding` als orthogonales Feld |
| `IHeuristic` | Eingang/Ausgang nicht typisiert; keine Cost-Model-Hierarchie | Einfuehrung von Sub-Hierarchien: IStaticHeuristic, IRuntimeHeuristic, IMultiTierHeuristic, IPrefetchTacticHeuristic |
| `ILivePlatformModel` (Saeule B) | Wie wird Modell gewonnen? Probing nicht modelliert | `IPlatformProbe` + `IModelAcquisitionStrategy` |
| `IConcurrencyProtocol` | In REV 2 nicht eigene Saeule; orthogonal zu A und B | Eigene Saeule C (ConcurrencyManager) wie bereits in Cluster F angedeutet, mit 8 Disziplinen + 5 Mechaniken |
| `IUpdatability` | Static vs Dynamic ist Concept-Dimension, fehlt | Mixin-Marker einfuehren |
| `ISpaceGuarantee` | Worst-Case-Bounds nicht als Property | First-Class Property einer ISearchPagesStrategyPattern |
| `IAdaptationTrigger` | Wann wird Strategie re-applied? | `IRebuildScheduler`-Hierarchie |
| `IFilterStrategy` (Approximate Membership) | Nicht in REV 2 vorhanden — nur exakte Suche | Geschwister-Concept zu ISearchPageStrategy |
| `IIteratorStateCacheStrategy` | Iteratoren mit komplexem State (per-level cursors) haben eigenes Cache-Verhalten | Eigenes Concept fuer Iterator-Cache-Strategie |
| `INodeIterator/ISearchPageIterator/ISearchPageStrategyIterator` | In REV 2 verlangt aber nicht ausspezifiziert | Konkretisierungen aus Sektion 5 hinzufuegen |
| `IRankSelectPrimitive` | Saeule B fehlt komplett — alle modernen succinct tries setzen darauf | Hardware-popcount als kritisches Feature |
| `IBranchPredictorModel` | Misprediction-Cost als Plattform-Kennzahl unmodelliert | Eigene Concept-Klasse |
| `IStorageMedium` | Saeule B nimmt nur DRAM an | DRAM/NVRAM/SSD/HDD-Hierarchy |
| `IPageCacheModel` | OS Page Cache + App Block Cache als 2-stufige Layer fehlen | Ueber ICacheLevel |
| `IComputeOffload` (iDMA) | Nicht in REV 2 — TUD Tomahawk-Architektur abgedeckt | "Wo wird Operation ausgefuehrt?" PE / iDMA / App-Core / FPGA |
| `IMemoryDecorator` (NFP) | NFPs nicht modelliert | VAMPIR-Pattern |

### 7.2 Uebergreifende Concept-Klassen (Multi-Cluster-Vorkommen)

Strategien, die in mehreren Clustern erscheinen → starker Hinweis auf gemeinsames Concept-Dach:

| Pattern | Cluster | Empfohlener Concept-Name |
|---------|---------|---------------------------|
| Adaptive Layout / Form-Anpassung an Population | A (alle 6), B (P20), D (P20) | `IAdaptiveLayoutStrategy` als ISearchPagesStrategyPattern |
| Layer-Dependent Encoding (oben anders als unten) | A (P02, P05, P10), B (P22), D (P22) | `ILayerDependentLayoutStrategy` |
| SIMD-Accelerated Lookup | A (P01, P02, P10), B (n/a — Luecke), D (P20) | `ISimdAcceleratedLookupStrategy` |
| Pointer Tagging / Type-Bits in LSB | A (P01 ART, P02 HOT, P05 START Rewiring) | `IPointerTagDispatchStrategy` |
| Pool-of-Encodings + Selector | A (P04 EF/PA/BV/DE, P02 HOT 9 Layouts, P10 SuRF) | `IEncodingPool` + `IEncodingSelector` |
| Compound Node (1 ISearchPage hostet N INode) | A (P02 HOT, P04 CoCo, P05 START), B (P06 B^2) | `ICompositionMode` mit OneNodePerPage / MultipleNodesPerPage |
| Static vs Dynamic Tree | A (P01/P02/P05 dyn, P04/P09/P10 stat), B (P11/P14 stat, P03/P06/P07 dyn) | `IUpdatability` |
| Worst-Case Space Guarantee | A (P01 52B, P05 52B, P09 2n+o(n), P04 info-theor.) | `ISpaceGuarantee` |
| Topology Encoding (LOUDS/DFUDS/BP/Pointer) | A (P09, P04, P10), B (P11/P12 implicit Pointerless) | `ITopologyEncoding` |
| Path Compression / Lazy Expansion | A (P01, P02, P05), B (P03 layer-collapse) | `IPathCollapsePolicy` |
| Probability-Weighted Layout | C (P16, P28), D (P26, P28) | `IProbabilityWeightedLayoutStrategy` |
| Cache-Line-Sized Node | B (P11, P12, P14), C (P14, P15) | `ICacheLineAlignedNodeStrategy` |
| Multi-Cache-Line Node + Prefetch | B (P03, P13), D (P21, P22) | `IMultiCacheLineWithPrefetchStrategy` |
| Embedded Secondary Index | B (P06, P07, P11) | `IEmbeddedSearchPage` |
| Indirection / Permutation | B (P03, P06), Umbra | `IIndirectionVector` |
| Anchor Key | B (P07), A (P03 lowkey/highkey), B (P12 splitter) | `IAnchorKey` |
| Trie Layer Pattern | B (P03), A (P07 Anchor-Praefix-Layer), A (P01) | `ITrieLayerStrategy` |
| Jump Pointer Array | D (P21, P22), E (P26 Version-Chain) | `IJumpPointerStorage` |
| Software Prefetching | C (P14, P15), D (P21, P22, P23), E (P25, P26) | `IPrefetchStrategy` mit Subhierarchie |
| Cost Model | B (P13), C (P14, P16), D (P21, P22) | `ICacheCostModel` + `IPlatformAwareSizingModel` |
| Live Plattform-Probing | A (P05), F (P32, P33) | `IPlatformProbe` + `IModelAcquisitionStrategy` |
| Telemetry / Per-Block Counter | E (P26, P27, P28) + PRT-ART NEU | `IPathReadCounter` / `ILeafOnlyCounter` Familie |
| OLC / ROWEX / RCU / HP | F (P02, P03, P06, P08, P29, P30) | `IConcurrencyMechanik` als 4er-Familie + EBR |
| Linear vs Binary Search Intra-Node | A (P01 Node4), B (P03 Masstree, P14 Itanium), C (P14, P15) | `ISearchStrategySelectionHeuristic` |
| Bulk Load Level-by-Level | B (P11, P12, P14) | `IBulkLoadStrategy` |
| Lazy Deletion | B (P12 CSB+, P14) | `ILazyDeletionStrategy` |
| Hot-Cold-Layer-Trennung | A (P10 SuRF), E (P26, P28) | `IHotColdAwareLayoutStrategy` |
| Partial vs Full Key Verification | A (P02, P10) | `IKeyVerificationStrategy` |

### 7.3 Cluster-uebergreifende Luecken (gemeinsame "blind spots")

| Bereich | Luecke | Quellen |
|---------|--------|--------|
| **NUMA-Awareness** | Durchgaengig schwach: P03 erwaehnt nur kurz, P07 vermeidet via single-node-Restriction, P28 first-touch policy problematisch | Cluster A, B, E, F |
| **Hardware-Counter-Feedback** | Keine STATISCHEN Strategien implementieren ILivePlatformModel-getriebenes adaptives Resizing | Cluster A, B, C |
| **TLB explizit modelliert** | Nur P13 (B+) und P28 (Hot-Path), P32 (Stride); ART/HOT/CoCo/SuRF ignorieren TLB | Cluster A |
| **SIMD in B+/Hybrid-Familie** | Nur P03 erwaehnt PALM (das SIMD nutzt), aber adaptiert es nicht | Cluster B |
| **Cache-Coherence-Energiekosten** | P24 aggregiert; quantitative Detail-Modellierung fehlt | Cluster E |
| **Range-Scan bei ROWEX** | P08 notiert: sortierte Reihenfolge im Linear-Node aufgegeben → Range-Scan-Konflikt | Cluster F |
| **6-Flavor-RCU-Klassifikation** | P29 hat nur 4 historische Flavors; qsbr/mb/membarrier/signal aus URCU nicht im Paper | Cluster F |
| **Concurrent Reconstruction (Tree-Rebuild)** | P06 erkennt: Embedded Tree-Rebuild bei Split unter Concurrency nicht-trivial | Cluster B |
| **Multi-Tenancy / Cache-Pollution** | Alle Paper nehmen "dedizierten Cache" an | Cluster A, B, C |
| **Multi-Level Local-Relocation** | P19 erkennt: nicht-trivial fuer Multi-Level | Cluster C |
| **NVRAM / Persistent Memory** | Nur P25 (Grace HBM), P31 (Tomahawk-LX5) — nicht durchgaengig | Cluster E, F |
| **Compiler-Automation der ISA-Extensions** | P31 OFFEN: welche Extensions auf welchem PE; P30 OFFEN: HP nicht automatisch | Cluster F |
| **Plattform-spezifische Validierung** | P14 ausschliesslich Itanium2; P32 ausschliesslich Cascade Lake/Sapphire Rapids | Cluster B, C, F |

---

## 8. Update-Vorschlaege fuer 10_korrektur_architektur_skizze REV 3

Konkrete Aenderungen, die in der Hauptskizze gemacht werden sollten:

### 8.1 Section 1: Core-Concepts erweitern

- **Section 1.X (NEU): ISearchPagesStrategyPattern als Komposit-Concept**
  - 4 Konkretisierungen: Homogeneous / HeterogeneousAdaptive / HierarchicalFractal / OrthogonalRuntimeParametrized
  - Erlaubt explizit heterogene Strategien innerhalb eines Patterns

- **Section 1.X (NEU): ICompositionMode-Marker** auf ISearchPage
  - OneNodePerPage (klassisches ART)
  - MultipleNodesPerPage (HOT, CoCo, START Compound)

- **Section 1.X (NEU): IUpdatability-Mixin** auf ISearchPagesStrategyPattern
  - Static / BulkUpdate / Incremental / Concurrent

- **Section 1.X (NEU): ISpaceGuarantee-Property**
  - WorstCaseBoundPerKey / AsymptoticInfoTheoreticBound / EmpiricalBoundOnly

- **Section 1.X (NEU): ITopologyEncoding** als orthogonales Feld zu Layout
  - LoudsTopology / DfudsTopology / BpTopology / PointerTopology / BitArrayTopology

- **Section 1.X (NEU): IFilterStrategy** als Geschwister-Concept zu ISearchPageStrategy
  - Mit `IFalsePositiveRateModel` als Quality-of-Service Property
  - Sub: BloomFilterStrategy, SuRFFilterStrategy, AdaptiveRangeFilterStrategy

### 8.2 Section 2: Saeule-A-Erweiterungen

- **Section 2.X: Iteratoren-Schicht** explizit ausspezifizieren (siehe Sektion 5 dieser Taxonomie)
  - INodeIterator-Konkretisierungen (12+)
  - ISearchPageIterator (Range-Scan, 11+)
  - ISearchPageStrategyIterator (Cross-Algorithm, 10+)
  - comdare::prt_art<K,V>::iterator-Familie (10 Spezialisierungen)

- **Section 2.X: IEncodingPool + IEncodingSelector** als Concept
  - SuccinctEncodingPool (CoCo: EF/PA/BV/DE)
  - NodeLayoutPool (HOT: 9 Layouts)
  - TopologyEncodingPool

- **Section 2.X: ITrieLayerStrategy** als Sub-Pattern
  - Praefix-konsumierende Layer mit `next_layer_pointer`-Relation

- **Section 2.X: IEmbeddedSearchPage** Concept
  - Tree-of-Trees-Pattern (B^2-Tree, Wormhole, CSS-Directory)

- **Section 2.X: IIndirectionVector** Concept
  - Trennung logische vs physikalische Reihenfolge — lock-free-friendly

### 8.3 Section 3: Saeule-B-Erweiterungen

- **Section 3.X: IPlatformProbe + IModelAcquisitionStrategy**
  - ClflushNodeProbe, LatencyProbe, BranchPredictorProbe, SimdThroughputProbe
  - DTLBSTLBCapacityProbe, HardwarePrefetcherStreamProbe (P32)

- **Section 3.X: IRankSelectPrimitive**
  - BitVectorRank (popcount), JacobsonTwoLevelDirectory, PoppyRank

- **Section 3.X: IHardwareExtension** umfassende Sub-Hierarchie aus P31
  - Bitmap-Compression: WAH / PLWAH / COMPAX
  - Hash: Hash+Lookup, Hash+Insert, CityHash32, Hash Sampling
  - Sort/Set: MergeSort, Intersection, Union, Difference, SortMergeJoin, SortMergeAggregation

- **Section 3.X: IStorageMedium + IPageCacheModel**
  - DRAM / NVRAM / SSD / HDD
  - OS Page Cache + App Block Cache als 2-stufige Layer

- **Section 3.X: IBranchPredictorModel** als Plattform-Kennzahl

- **Section 3.X: IBitManipulationFeatureGate** mit Fallback
  - BMI2 PEXT/PDEP, AVX2, popcount

- **Section 3.X: IMemoryDecorator + IHeterogeneousAllocator + IMigrationPolicy** (VAMPIR-Pattern)
  - NFP-Kontext pro Allokation
  - V-malloc Strategie
  - Compensation/Migration zwischen Tiers

- **Section 3.X: IAccessPatternStrategy + IPaddingStrategy** (P32)
  - Sequential vs Strided vs SIMD
  - 576-Byte-Padding fuer Cache-Set-Disalignment

### 8.4 Section 4: Cross-Reference-Tabelle erweitern

- **Section 4 Cross-Reference: erweiterte Tabelle** mit allen vier Strategie-Ebenen
  - Spalte 1: Pattern (ISearchPagesStrategyPattern)
  - Spalte 2: Plural-Strategy (ISearchPagesStrategy)
  - Spalte 3: Singular-Strategy (ISearchPageStrategy)
  - Spalte 4: Heuristic (IHeuristic)
  - Spalte 5: Iterator-Konkretisierung
  - Spalte 6: Saeule-B-Anforderungen
  - Spalte 7: Concurrency-Mechanik

- **Section 4: Verweis-Matrix** Pattern-zu-Heuristic
  - Welche Heuristics werden von welchem Pattern konsumiert?

### 8.5 Section 5 (NEU): Concurrency als eigene Saeule C

ConcurrencyManager als eigene Saeule (orthogonal zu A und B):

- **8 Disziplinen:** Page / Node / Array / DataStructure / Path / MemoryRead / MemoryWrite / MemoryReadWrite / SimdThread / SimdFlow
- **5 Mechaniken:** OLC / ROWEX / RCU / HazardPointers / EpochBasedReclamation
- **IRcuFlavor:** 8 Flavors (DYNIX/ptx 2.1, 4.0, voluntary, generation, qsbr, mb, membarrier, signal)
- **IConcurrencyDiscipline + IConcurrencyMechanik** als Top-Level-Concepts

### 8.6 Section 6 (NEU): Telemetry als Achse 11

Aus PRT-ART-eigener Architektur + Cluster E:

- `IPathReadCounter` (P26 etabliert)
- `ILeafOnlyCounter` (NEU 2026-05-08, generalisiert P28)
- `ILeafOnlySampledCounter<N>` (NEU 2026-05-08)
- `IRetroactiveAggregationBarrier` (NEU 2026-05-08, BARRIERE)
- `IProbabilityHintsHeader` (PRT-ART eigen, verwandt zu P27 Bundle-Tags)

### 8.7 Section 7 (NEU): Composite + Adaptation-Trigger

- **`ICompositeStrategy`** kombiniert Builder + Maintenance (P18 Global + P19 Local)
- **`IAdaptationTrigger`** mit Sub:
  - OnEveryStructureModification (P19 Local)
  - OnLayoutDegradationThreshold (Composite)
  - Periodic (Time-based, P05 START)
  - OnWorkloadDriftDetected (P28 Future Work)
  - Manual

### 8.8 Section 8 (NEU): Cost-Model-Hierarchie

`IHeuristic` Sub-Hierarchie aus Cluster D:

```
IHeuristic
├── IStaticHeuristic
│   ├── ICacheCostModelHeuristic (P21, P22 Equations)
│   ├── ILayoutSelectionHeuristic (P20 KeyAdaption)
│   └── IWidthOptimizationHeuristic (P21 w_optimal)
├── IRuntimeHeuristic
│   ├── IPerformanceCounterReaderHeuristic (P23)
│   ├── IOnlineDistanceAdaptationHeuristic (P23 O_r)
│   ├── IWorkloadDetectionHeuristic (P20 Counter)
│   └── ICostBenefitGatedHeuristic (P23 Equation 4)
├── IMultiTierHeuristic
│   ├── IPerTierWidthHeuristic (P22)
│   ├── IGranularityMismatchHeuristic (P22 Overflow/Offset)
│   └── IFractalLayoutHeuristic (P22 Disk-First/Cache-First)
└── IPrefetchTacticHeuristic
    ├── IWideNodeTacticHeuristic (P21)
    ├── IJumpPointerTacticHeuristic (P21, P22 dual)
    └── ITemplateSpecializerTacticHeuristic (P23)
```

### 8.9 Section 9 (NEU): Strategy-Compatibility-Matrix

Aus P15 Survey (explizit als Forschungs-TODO genannt):

`IStrategyCompatibilityMatrix` als IHeuristic-Subkomponente:
- Welche Strategien verstaerken sich gegenseitig?
- Welche Strategien inhibieren sich?
- Compatibility-Score pro Kombination

Beispiel-Inkompatibilitaeten aus Lektuere:
- Linear Search + grosse Knoten (>1024B) → Performance-Regression (P28)
- STRONG FB-Reliability + grosse Prefetch-Distanz → Endloses Stallen (P25)
- ROWEX + Range-Scan → sortierte Reihenfolge aufgegeben (P08)

### 8.10 Section 10 (NEU): IAccessProbabilityDistribution

Workload-Modellierung als Strategy-Input (P16, P28):
- `UniformDistribution`
- `HeavyTailDistribution`
- `EmpiricalDistribution` (gefuettert via PRT-ART Telemetry)
- `LearnedDistribution` (Profiling-basiert)

---

## Anhang: Paper-Index pro Cluster

| Cluster | Paper | Hauptbeitrag |
|---------|-------|--------------|
| A (Trie) | P01 ART, P02 HOT, P04 CoCo, P05 START, P09 Jacobson LOUDS, P10 SuRF | Trie-Familie, Adaptive Layouts, Succinct Encoding, Cache-Cost-Models, Filter |
| B (Hybrid + B+) | P03 Masstree, P06 B^2-Tree, P07 Wormhole, P11 CSS, P12 CSB+, P13 Hankins/Patel | Hybrid-Strukturen, B+-Familie, Cost-Model fuer Knotengroesse |
| C (Layout-Theorie) | P14 Samuel/Pedersen/Bonnet, P15 Graefe/Larson Survey, P16 Bender ESA, P17 Bender vEB B-Trees, P18 Saikkonen Static, P19 Saikkonen Dynamic | Cache-Awareness vs Cache-Obliviousness, Probability-Weighted Layout, Layout-Invarianten |
| D (Prefetching 1) | P20 Mueller/Benson/Leis Adaptive B-Tree, P21 Chen/Gibbons/Mowry pB+, P22 Chen et al fpB+, P23 Khan Runtime-Adaptive | Prefetching fuer B+-Tree, Multi-Tier Fractal, Runtime-Adaptation |
| E (Prefetching 2 + Telemetry) | P24 Naderan-Tahan Negativ, P25 Mahling Reliability, P26 Zhang FGCS, P27 Zhang ASPLOS, P28 Kuehn DaMoN | Prefetching-Negativ-Befunde, Reliability, Path-Prefetcher, Bundle-Identifikation, Hot-Path-Layout |
| F (Sync + TUD-Habich) | P08 ART OLC/ROWEX, P29 RCU, P30 Hazard Pointers, P31 Ungethuem TUD, P32 Schmidt To-Stride, P33 VAMPIR Poster | Synchronisations-Mechaniken, Hardware-Optimization-Survey, Live-Plattform-Modell, NFP-Framework |

**Total:** 33 Paper, 6 Cluster, 4 Strategie-Ebenen, 12+ Iterator-Konkretisierungen, 50+ neue Concept-Vorschlaege fuer REV 3.

---

## §9 — Hybrid-Command-Pattern-Konvention (Korrektur-Runde 3, 2026-05-10)

**Bezug:** `10_korrektur_architektur_skizze...md` Sektion K3.4

**Schema (siehe K3.4):**
```
«abstract» IStrategyCommand                              (Command-Pattern Wurzel)
   + execute(context : StrategyContext&) : Result
   + can_compose_with(other : IStrategyCommand&) : bool

«composite» HybridCompositionCommand : IStrategyCommand  (NEU — Sammler)
   - parts : vector<IStrategyCommand*>
   - composition_rule : ICompositionRule           (sequenziell, parallel, conditional, recursive)
```

**Pruefungs-Regel:** WO IMMER in dieser Datei eine Strategy oder ein Pattern als „hybrid" / „composite" / „mixed" / „dual-tier" / „dual-layer" / „triple-layer" / „N-prefetcher" / „hierarchical" / „heterogen" beschrieben ist, ist eine Command-Pattern-Aufloesung Pflicht.

**Aufloesungs-Tabelle (vollstaendig fuer hier dokumentierte Hybride):**

| Quelle in dieser Datei | Bisher monolithisch | Atomare Strategy-Commands | HybridCompositionCommand |
|------------------------|---------------------|---------------------------|--------------------------|
| §1.1 `LayerMixPattern` (P03 Masstree) | Trie-Layer + B+-pro-Layer | `SliceLayerJumpCommand` + `BPlusPerLayerCommand` + `PermutationFieldInsertCommand` | `MasstreeSliceLayeredCompositionCommand` |
| §1.1 `LayerMixPattern` (P10 SuRF) | LOUDS-Dense + LOUDS-Sparse | `LoudsDenseEncodingCommand` + `LoudsSparseEncodingCommand` | `CutoffLevelLoudsCompositionCommand` |
| §1.1 `LayerMixPattern` (P04 CoCo) | Macro-Levels + Patricia-Inner | `MacroNodeCollapseCommand` + `PatriciaInnerExpandCommand` + `SuccinctEncodingPoolCommand` | `CoCoLevelLDecisionCompositionCommand` |
| §1.1 `LayerMixPattern` (P22 fpB+) | Disk-Tier + In-Page-Tier | `DiskTierTraversalCommand` + `CacheTierTraversalCommand` | `FractalHierarchicalCompositionCommand` |
| §1.1 `InnerVsLeafPattern` (P02 HOT) | Compound-Inner + BiNode-Subtree | `CompoundContainerCommand` + `BiNodeSubtreeCommand` + `SingleMaskPartialKeyCommand` + `MultiMaskPartialKeyCommand` | `HOTCompoundCompositionCommand` |
| §1.1 `InnerVsLeafPattern` (P19 Saikkonen α-Connected-Subgraph) | Inner-Layout + Leaf-Layout-Switch | `InnerSubgraphLayoutCommand` + `LeafSubgraphLayoutCommand` | `AlphaConnectedSubgraphCompositionCommand` |
| §1.1 `HotVsColdPattern` (P28 Kuehn) | Hot-Path-Layout monolithisch | `LeafOnlyCounterCommand` + `RetroactiveAggregationCommand` + `GreedyHotPathLayoutCommand` | `KuehnHotPathOptimizationCompositionCommand` |
| §1.1 `HotVsColdPattern` (P26 Zhang FGCS) | Path-Prefetcher-Table monolithisch | `CachePrefetcherCommand (CP)` + `PathPrefetcherCommand (PP)` + `MonitorPrefetcherCommand (MP)` | `ThreePrefetcherOrchestrationCompositionCommand` |
| §1.1 `DynamicRebalancePattern` (P05 START) | Self-Tuning Multilevel monolithisch | `OfflineCostMeasureCommand` + `BellmanDPLayoutCommand` + `LkmRewireCommand` + `MultilevelRebuildCommand` | `STARTSelfTuningCompositionCommand` |
| §1.1 `HierarchicalFractalPattern` (P22 fpB+) | Outer-Tier + Inner-Tier | (siehe oben) | (siehe oben) |
| §1.1 `HierarchicalFractalPattern` (P15 B-Trees of Cache-Lines) | Cache-Line-Sub-Tree + Inter-Line-Tree | `IntraCachelineSubtreeCommand` + `InterCachelineTreeCommand` | `BTreesOfCachelinesCompositionCommand` |
| §1.1 `HierarchicalFractalPattern` (P06 B²-Tree) | Outer-B+ + Inner-Decision/Span | `OuterBPlusPageCommand` + `DecisionPageStrategyCommand` + `SpanPageStrategyCommand` | `B2TreeRecursiveCommonPrefixCompositionCommand` |
| §1.1 `MultiStrategyOrchestrationPattern` (P07 Wormhole) | Hash + B+ + LinkedList | `HashAnchorLookupCommand` + `BPlusHopLookupCommand` + `LeafLinkedListScanCommand` | `TripleLayerLookupCompositionCommand` |
| §1.1 `MultiStrategyOrchestrationPattern` (P15 Strategy-Compatibility-Matrix) | Survey-Mix-Empfehlungen | (pro empfohlenem Mix eigene Composition) | `GraefeStrategyMixCompositionCommand` (parametriert) |
| §1.1 `OrthogonalRuntimeParametrizedPattern` (P23 Khan) | Runtime-adaptive Prefetch | `BasePrefetchCommand` + `DistanceAdaptCommand` + `LoopUnrollAdaptCommand` | `KhanRuntimeAdaptiveCompositionCommand` |
| §1.1 `OrthogonalRuntimeParametrizedPattern` (P14 ConfigurationTable) | Cost-Lookup-Table monolithisch | `NodeSizeSelectCommand` + `SearchMethodSelectCommand` + `ConfigurationLookupCommand` | `SamuelConfigurationTableCompositionCommand` |
| §1.1 `HeterogeneousAdaptivePattern` (P20 B-Trees-Are-Back) | KeyAdaption + OperationAdaption Selector | `KeyAdaptionCommand` (mit `ComparisonSubCommand` + `FingerprintingSubCommand`) + `OperationAdaptionCommand` (mit `SDLSubCommand` + `FDLSubCommand`) | `BTreesAreBackHeterogeneousAdaptiveCompositionCommand` |
| §1.1 `BoundaryNodePartitionPattern` (P20) | Sequential-Insert FDL-Special | `SplitPointSelectCommand` + `DenseLayoutPreserveCommand` | `SequentialInsertCompositionCommand` |
| §2.1 `FractalBPlusStrategy (Disk-First / Cache-First)` (P22) | beide Modi | (siehe HierarchicalFractalPattern oben) | (siehe oben) |
| §2.1 `EmbeddedSecondaryIndexStrategy (B²)` (P06) | Outer-B+ + Inner-Mini-Index | (siehe HierarchicalFractalPattern P06) | (siehe oben) |
| §2.2 Trie-Familie (P03/P10/P02/P04) | (alle bereits oben) | ... | ... |
| §3 (Singular Strategies) | sind atomare Strategie-Commands | — keine Aufloesung noetig — | — |
| §4 IHeuristic | sind atomare Heuristik-Commands | — keine Aufloesung noetig — | — |

**Permutations-Raum-Erweiterung durch Aufloesung:**

Vor Aufloesung: 1 monolithische Hybrid-Strategie pro Eintrag
Nach Aufloesung: N atomare Commands + M Composition-Variants pro Eintrag

Beispiel P07 Wormhole: 1 → 3 Atome + 1 Composition = 4 Bausteine im Permutations-Raum, davon 3 einzeln testbar gegen andere Algorithmen (Hash gegen ART, B+-Hop gegen Masstree-B+, LinkedList-Scan gegen P21-Wide-Node).

Diese Aufloesung erschliesst einen wesentlichen Teil der F15-Cross-Familien-Permutationen, der ohne Command-Pattern unzuganglich bliebe.

**Verzeichnis-Anbindung:**
```
search_engine/strategies/commands/
├── i_strategy_command.hpp                              (Command-Pattern Wurzel)
├── hybrid_composition_command.hpp                      (Composite)
├── i_composition_rule.hpp                              (sequenziell|parallel|conditional|recursive)
├── pages/                                              (atomare Commands der Page-Strategien)
├── traversals/                                         (atomare Commands der Traversal-Strategien)
├── prefetchers/                                        (atomare Commands der Prefetch-Strategien)
├── relocations/                                        (atomare Commands der Reloc-Strategien)
└── compositions/                                       (HybridCompositionCommand-Konkretisierungen pro Hybrid-Quelle)
    ├── masstree_slice_layered_composition.hpp
    ├── cutoff_level_louds_composition.hpp
    ├── coco_level_l_decision_composition.hpp
    ├── fractal_hierarchical_composition.hpp
    ├── hot_compound_composition.hpp
    ├── alpha_connected_subgraph_composition.hpp
    ├── kuehn_hot_path_optimization_composition.hpp
    ├── three_prefetcher_orchestration_composition.hpp
    ├── start_self_tuning_composition.hpp
    ├── b_trees_of_cachelines_composition.hpp
    ├── b2_tree_recursive_common_prefix_composition.hpp
    ├── triple_layer_lookup_composition.hpp
    ├── graefe_strategy_mix_composition.hpp
    ├── khan_runtime_adaptive_composition.hpp
    ├── samuel_configuration_table_composition.hpp
    ├── b_trees_are_back_heterogeneous_adaptive_composition.hpp
    └── sequential_insert_composition.hpp
```

---

## §10 — Wirkung auf §6 (REV 3 Update-Vorschlaege)

In §6 vermerkte Update-Vorschlaege fuer REV 3 werden um folgende Punkte aus K3 erweitert:

- **K3.1 (IExecutingEngine):** Ergaenze `i_executing_engine.hpp` als Wurzel-Konzept ueber `i_search_engine.hpp` in REV 3.
- **K3.3 (Cluster-Aufloesung):** Cluster-Bezeichnungen sind Lektuere-Hilfen, NICHT Architektur-Trennlinien. In REV 3 die Sektionen 2.1/2.2 als „Sammel-Bezeichner fuer Konfigurations-Pakete" markieren.
- **K3.4 (Hybrid-Command-Pattern):** Pro Hybrid-Strategie Command-Pattern-Aufloesung Pflicht. Tabelle aus §9 in `12_algorithmus_strategie_taxonomie.md` ist die Referenz.
