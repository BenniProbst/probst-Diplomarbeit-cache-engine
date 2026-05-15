# Cluster C — Layout-Theorie

> Tiefe Lektuere von 6 Paper zur Generalisierung von Cache-Strategien und Algorithmus-Strategien unter den COMDARE-Concept-Daechern (REV 2).
>
> Erstellt im Rahmen der TU Dresden Diplomarbeit "Active Cache-Aware Hardware Adaptation Cache Engine for Trie-Based Index Structures" (Probst, Habich), Termin 7 (2026-05-08).

---

## P14 Samuel/Pedersen/Bonnet (2005) — "Making CSB+-Trees Processor Conscious"

**Venue:** First International Workshop on Data Management on New Hardware (DaMoN 2005), 12.06.2004, Baltimore, Maryland, USA, ACM. Publikation: 2005, University of Copenhagen (DIKU).
**Kontext:** Adaptation der CSB+-Tree (Rao/Ross 2000) im MySQL Heap Storage Manager auf Itanium 2 (Gelato Federation).

### 1. CACHE-STRATEGIEN

- **CacheLineAlignedNodeStrategy** (Sektion 2): "Node size: a multiple of the cache line size." — Datenstruktur-Knoten passt auf ganzzahliges Vielfaches von ICacheLine. *Anti-Klassifikation gegenueber CSB+ Original (Rao/Ross): "Hankins and Patel showed that this choice [Cacheline-Knoten] might be suboptimal."*
- **NodeGroupContiguousLayout** (Sektion 2): Alle Kinder eines internen Knotens werden zusammenhaengend in einer "node group" angelegt, identifiziert durch *einen* Pointer + Offset-in-Key-Ordnung. → minimiert Pointer-Speicher, maximiert Keys/Cacheline.
- **FullCSBVariant** (Sektion 3.1): "Full" CSB+-Tree wird gewaehlt, da Trade-off Space/Response-Time. Pre-allokierte Node Groups; Bitmap zur Erkennung leerer Knoten + nodes-in-use Counter (nCnt) + entries-in-use Counter (eCnt).
- **ItaniumExplicitPrefetchStrategy** (Sektion 3.1, 3.2): "Itanium 2 offers an API for explicitly prefetching data into cache. This can be done explicitly at the application level, or implicitly by the Intel compiler." → Software-Prefetch zur Naechstes-Level-Knoten-Vorladung *bevor* die Suchschleife dorthin springt. WICHTIG: "Prefetching nodes at the next-level before having identified the node to be visited is detrimental on Itanium 2. Prefetching can be turned on or off."
- **TwoNodesAheadRangeScanPrefetch** (Sektion 3.1): "Range scan ... we prefetch two nodes ahead." → ICacheStrategy-Subklasse fuer sequenziellen Range-Zugriff.

### 2. ALGORITHMUS-STRATEGIEN

- **LinearSearchPageStrategy** (Sektion 3.3, 3.4): Lineare Suche im Knoten — "linear search is consistently more effective than binary search as an internal node search strategy" auf Itanium 2 fuer Knoten ≤ 384 B.
  - Crossover-Schwellenwert: Bei 8B-Keys ~384 B Knoten, bei 16B-Keys ~512 B.
  - Branch-Mispredictions sind bei Linear deutlich geringer als bei Binary.
- **BinarySearchPageStrategy** (Sektion 2, 3.3): "Rao and Ross identify binary search as a basic approach to searching within a node. They also propose an optimization based on loop unrolling. Note that loop unrolling of the binary search code is only possible if node size and key size are known at compile time."
- **LoopUnrolledBinarySearchPageStrategy** (Sektion 2): Optimierung von Binary Search via Compile-Time-Loop-Unrolling. → Voraussetzung: konstante Node-Size + Key-Size.
- **PrefixingLinearSearchPageStrategy** (kombiniert: Sektion 3.1+3.4): Linear + ItaniumExplicitPrefetch fuer Naechstes-Level-Knoten innerhalb der Suchschleife (Pipeline-Latenz-Hiding).
- **LazyDeletionStrategy** (Sektion 2 "Deletion", 3.1): Statt Reorganisation bei Loeschung — "removing keys without reorganizing the tree." Bitmap unterscheidet leere von Non-Empty-Knoten in Group; Insertion nutzt leere Knoten wieder.
- **LevelByLevelBulkloadStrategy** (Sektion 2 "Bulkload"): "A more effective alternative consists of building the tree, level by level."
- **DynamicVsStaticNodeAllocationStrategy** (Sektion 2 "Insertion"): Drei CSB+-Varianten (basic, segmented, full) als Allokations-Trade-off-Familie.

### 3. SONDERMERKMALE

- **ConfigurationTable / configuration experiment** (Sektion 4 "ADAPTATION METHOD"): Zentraler Beitrag — "We propose to adapt a CSB+-tree by setting node search strategy and node size at index creation time based on the key size given by the user. In order to do that, we need to construct a CSB+-tree configuration table that associates search strategy and node size to key sizes."
  - Befuellung der Tabelle durch Konfigurations-Experiment: variieren von (node size, key size, search method), Optimum messen.
  - **Diese Tabelle ist eine direkte Vorlage fuer eine COMDARE IHeuristic-Wissensbasis!**
- **PointerSizeNotConfigurable** (Sektion 2): "Pointer size is fixed to the processor word size: 4B on a 32 bits processor and 8B on a 64 bits processor. Pointer size thus trivially depends on the processor architecture." → Plattform-Eigenschaft, NICHT Strategie-Parameter.
- **EPIC-Architektur (Itanium 2)** (Sektion 3.2): Compiler buendelt Instruktionen, kein Out-of-Order-Execution. → ISA-Eigenschaft beeinflusst Linear vs Binary Trade-off.
- **Gelato Federation Reference Hardware** (Fussnote 4): Linux/Itanium 2-spezifische Optimierungen; Resultate nicht trivial auf Pentium uebertragbar.
- **Optimum-Knoten-Groesse fuer Insertion ≠ Optimum fuer Point Query** (Sektion 3.5, Fig. 8): "the optimal node sizes for insertions are different from the optimal node sizes we observed for point queries." → impliziert *Workload-Mix-aware* Heuristik.
- **MySQL-Integration** (Sektion 1, 3.1): "incorporate our implementation of the CSB+-tree in MySQL"; produktnaehe als Adoptionshemmnis.

### 4. PLATTFORM-MODELLIERUNG-BEZUG

- **ICacheLevel** (Tabelle 1): L1=16KB/64B, L2=256KB/128B, L3=1.5MB/128B → genau 3-Level-Hierarchie wird berichtet.
- **ICacheLine**: Unterschiedliche Linegroessen pro Level (64B vs 128B) → bestaetigt, dass ICacheLine nicht uniform ueber Levels ist.
- **IHardwareExtension / IIsaFeatureSet**: Itanium 2 EPIC + Software-Prefetch-Instruktion (lfetch) → beides Feature-Klassen im COMDARE-Modell.
- **IScheduler**: "the processor does not rearrange instructions at runtime like e.g. the Pentium 4" → Itanium ist In-Order; Compiler ist Scheduler. → Modellbedarf: ISchedulingModel mit "InOrder|OutOfOrder" Klassen.
- **IHeuristic**: ConfigurationTable ist Praezedenzfall einer Lookup-basierten IHeuristic mit (KeySize, NodeSize, SearchStrategy) → optimaler Konfiguration.

### 5. VERALLGEMEINERUNGS-VORSCHLAEGE

- **ICacheStrategy.NodeSizeMultipleOfCacheLine** als Basis-Constraint — IFanout muss als Ganzzahliges Vielfaches der ICacheLine geplant werden.
- **ICacheStrategy.SoftwarePrefetch** mit Sub-Klassen:
  - `LookaheadPrefetch` (in-loop, naechster Knoten)
  - `RangeScanPrefetch` (k Knoten voraus, hier k=2)
  - **Modellierung:** Parameter `prefetchDistance: int`, `prefetchTrigger: enum{InLoop, BeforeLoop}`
- **ISearchPageStrategy** Familie: `LinearSearch`, `BinarySearch`, `LoopUnrolledBinarySearch` als VISITOR-Implementationen (1 pro IFanout).
- **IHeuristic.ConfigurationTableHeuristic**: Verallgemeinert als COMDARE-eigene Klasse — speichert (Plattform-Tupel, Workload-Tupel) → optimaler Strategie. Befuellung durch Profile-Run.
- Trennung **Search-optimaler Knoten** vs **Insertion-optimaler Knoten** → *Engine-Choice-Time* statt *Engine-Build-Time*-Entscheidung; Ausweg: zwei Index-Varianten + Choice-Builder.

### 6. LUECKEN

- **OFFEN:** Das Paper geht NICHT auf TLB-Misses ein, obwohl in Footnote 3 erwaehnt. Itanium 2 hat eigene TLB-Modelle, die nicht modelliert werden.
- **OFFEN:** Adaptation ist statisch (Index-Creation-Time), keine Runtime-Adaption auf Workload-Drift.
- **OFFEN:** Konfigurations-Experiment ist nicht automatisiert beschrieben — wie viele Konfigurationen, welche Stoppkriterien, wer triggert es?
- **OFFEN:** Resultate sind explizit nur fuer Itanium 2 valide (Sektion 5: "those results are only valid on Itanium 2"). Generalisierung der Configuration-Table-Methode auf Pentium 3/4 angekuendigt, aber im Paper nicht durchgefuehrt.
- **OFFEN:** Concurrency-Aspekt fehlt voellig (heap storage manager nutzt Table Locks, "no durability guarantees").

---

## P15 Graefe/Larson (2001) — "B-tree Indexes and CPU Caches" — SURVEY

**Venue:** ICDE 2001 (1063-6382/01 © 2001 IEEE), pp. 349-358. Microsoft.
**Charakter:** Survey/Folklore-Sammlung. **Kein Benchmark.** Erklaerter Zweck: "to survey and to make widely available this heretofore folkloric knowledge in order to enable, structure, and hopefully stimulate future research."

### 1. CACHE-STRATEGIEN (umfassende Familie!)

#### 4.1 Alignment with cache lines
- **RecordCacheLineAlignmentStrategy**: "if an index entry is smaller than a cache line, it should be fully contained within a single cache line, just as records smaller than pages are typically stored entirely within a single page." Spanning records dramatisch teurer.
- **PageHeaderCachelineColocation**: "if some fields in the page header are used more often than others, and in particular if these fields are often used together, those fields should share a cache line."

#### 4.2 Pre-fetching and asynchrony
- **MultiCacheLinePagePrefetchStrategy**: "If the page header spans multiple cache lines, the buffer manager might issue pre-fetch instructions for all of them before any real work on the page begins."
- **IndirectionVectorRangePrefetch**: pre-fetch parts of the indirection vector (1/4-, 1/2-, 3/4-way points) wenn binary search.
- **TwoCandidateNextPointPrefetch**: "one might want to pre-fetch the two possible next match points before each comparison throughout the binary search." → fuer binaere Suche im Knoten.
- **PostLocationFieldPrefetch**: nach Treffer Felder pre-fetchen, die in Selection-Predikaten direkt geprueft werden.
- **MultiRecordRangeScanPrefetch**: "In a scan or range search, every record of a page has to be inspected. In that case, it may be worthwhile prefetching from multiple records."
- **WriteBehindAfterUpdate**: Komplement zu Prefetch — "already implemented in many CPU caches, but typically is not under software control." → Architektur-Eigenschaft, nicht Strategie.

#### 4.3 B-trees of cache lines
- **BTreeOfCacheLinesStrategy**: "the entire concept of B-trees within a single large disk page" — Disk-Page wird selbst zu B-Tree, Cacheline zu B-Tree-Knoten. ⇒ Entspricht *fractal prefetching B+-Tree* (Chen et al. 2002, P-andere) sowie Rao/Ross-CSS-Trees.

#### 5. Packing more information into cache lines
- **OrderPreservingCompressionStrategy** (5.1): Huffman-codes (order-preserving), Optimum/ALM-Verfahren. *Mehr Daten/Cacheline → weniger Cache-Faults.*
- **KeyNormalizationStrategy** (5.2): Alle Keys → binaere Strings, Vergleich = simpler Strcmp; "form of early binding."
- **PrefixSuffixTruncationStrategy** (5.3): Page-wide oder Sub-Page-Prefixe; Suffix-Truncation in Separator-Keys.
- **NextNeighborDifferencingStrategy** (5.4): Statt Prefix-Truncation: Differenz zum unmittelbaren Vorgaenger speichern. Mit Anchor-Records oder Back-Pointers gegen Backtracking-Kosten.

#### 6. Redesigning data structures and search algorithms
- **PoorMansNormalizedKeysStrategy** (6.1): Indirection-Vector enthaelt nicht nur Byte-Offset, sondern 2-/4-/8-Byte Prefix des normalisierten Keys ⇒ Single-Hardware-Instruktion-Vergleich; viele Comparisons brauchen die Vollrecords nicht zu inspizieren.
- **InterpolationSearchStrategy** (6.2): Statt Binary Search: naechste Probe-Position aus Wert kalkulieren. Kombination mit Poor-Man's-Normalized-Keys/Hash-Werten effektiv.
- **PointingToPageExtentsStrategy** (6.3): Zusammenhaengende Page-Pointer komprimieren (page-number + count), statt jeden einzeln; oder Differenz zum Vorgaenger.
- **VerticalPartitioningStrategy** (6.4): Schluessel/Pointer separat (Spalten-Layout in Seite). "Moving all the keys together and therefore fitting more of them on a cache line seems like a promising idea." → Auch koennte Multi-Column-Index Spalten in separate Sektionen aufteilen.

#### 7. CPU scheduling (Temporal locality)
- **MicroServerThreadingStrategy** (Sektion 7): Statt Connection-pro-Thread → Task-orientierte Micro-Server, jeder bedient ein bestimmtes Modul (Plan-Suche, Recovery-Log, etc.). "Micro servers might be allocated to specific CPUs in a multi-processor system." → Entspricht IPinningPolicy + ICoreToThreadMap im COMDARE-Modell.
- **GroupCommitTemporalLocalityStrategy**: schon in DBs implementiert; analog kann in-memory Logging-Code-Cache aufrechterhalten werden.

### 2. ALGORITHMUS-STRATEGIEN

- **BinarySearchPageStrategy** als de-facto Standard, aber "unfortunately, [techniques] often conflict, and careful engineering tradeoffs are required."
- **LinearSearchPageStrategy** (implizit erwaehnt im Vergleich Strong/Markowsky/Chandra 1979 — "in most cases, binary search was preferable").
- **InterpolationSearchPageStrategy**: Sektion 6.2.
- **PoorMansKeySearchAcceleratorStrategy**: Sektion 6.1 — *Sub-Search* der eigentlichen Suche.

### 3. SONDERMERKMALE

- **Survey-Charakter** — gesamter Beitrag ist Verallgemeinerung. Acht Forschungs-TODO-Punkte am Ende:
  1. Effectiveness of listed technique combinations
  2. Column-wise storage within B-tree page
  3. Effectiveness of poor man's keys (auch in Sortierung)
  4. Algorithmic next-neighbor differencing + back-pointers
  5. Software-controlled pre-fetching
  6. Micro-servers fuer Temporal Locality
  7. Instruction-Level-Parallelism erhoehen
  8. Pipeline-Stalls auf konditionale/computed Branches reduzieren
- **Cache-Coherency-Cost** (Sektion 3): "It is particularly noticeably for heavily used, fast-changing data items (e.g., latches) protecting common data structures... This delay occurs even if there is no contention on the lock."
- **Software-Cache-Hints** (Sektion 3): "some modern cache designs include pre-fetch, invalidation, and write-behind instructions for specific memory addresses... Some cache controllers perform even automatic read-ahead and write-behind."
- **MultiLevelCacheModel** (Sektion 3): "as many as five levels: registers, three levels of caches, and main memory."

### 4. PLATTFORM-MODELLIERUNG-BEZUG

- **ICacheLevel/ICacheLine**: explizit ausgearbeitet — typische Cacheline 16-128 B; L1 8-32 KB; L2 128 KB-2 MB; ggf. L3 on-chip.
- **ICacheTopology**: Set-Associativity erwaehnt (typisch 4-way), LRU oder Second-Chance Replacement.
- **IBusTopology / Cache-Coherency**: explizit als Multiprozessor-Coherency-Cost behandelt; Latch-Pingpong-Effekt.
- **IIsaFeatureSet**: Software-Prefetch-Instruktionen, Write-Behind-Hints, Pre-Validation, Auto-Read-Ahead.
- **IInterconnect / IMemoryBandwidthModel**: implizit — "the bandwidth between all levels of the memory hierarchy seems eternally insufficient."
- **IHardwareExtension**: Transmeta morphed-code cache (Sektion 7), Pentium III Async-Prefetch.
- **IPinningPolicy + IScheduler**: explizit in MicroServer-Sektion 7. "Micro servers might be allocated to specific CPUs in a multi-processor system."
- **IHeuristic**: implizit in Eingangs-Argument: "careful engineering tradeoffs are required, if possible supported by rigorous research."

### 5. VERALLGEMEINERUNGS-VORSCHLAEGE

- **ICacheStrategy** Verallgemeinerungs-Achsen:
  | Achse | Beispiele | COMDARE-Sub-Klassen |
  |-------|-----------|----------------------|
  | Alignment | Cacheline | `CachelineAlignedStrategy`, `PageHeaderColocationStrategy` |
  | Compression | Order-preserving Huffman, Prefix/Suffix, Next-Neighbor | `OrderPreservingCompressionStrategy`, `PrefixTruncationStrategy`, `NextNeighborDifferencingStrategy` |
  | Key-Form | Normalization, Poor-Man's-Keys | `KeyNormalizationStrategy`, `PoorMansNormalizedKeyStrategy` |
  | Layout | Column/Row, Pointer-Compression | `VerticalPartitioningStrategy`, `PointerToExtentsStrategy` |
  | Prefetch | Multi-line page, indirection-vector probes, multi-record scan, write-behind | siehe ICacheStrategy.SoftwarePrefetch oben |
  | Recursive | B-Tree-of-Cachelines | `BTreeOfCacheLinesStrategy` |
  | Temporal | Micro-Servers, Group Commit | gehoert zu IScheduler/IPinningPolicy + IHeuristic |
- **ISearchPageStrategy** Verallgemeinerung:
  - `BinarySearch`, `Linear`, `Interpolation`, `PoorMansKeyAcceleratedSearch` (Sub-Search vor eigentlicher Suche)
- **DERIVED HEURISTIC**: Kombinations-Tabelle mit Kompatibilitaeten/Konflikten — "they often conflict" → COMDARE braucht eine **StrategyCompatibilityMatrix** als Heuristic-Subkomponente.
- **NEUER Concept-Vorschlag: ITemporalCacheStrategy** (Code-Cache, nicht Daten-Cache!) → fehlt in der Architektur-REV-2: ICachePage erfasst Daten-Caching, aber nicht Instruction-Cache. Survey betont: Code-Cache ist signifikant.

### 6. LUECKEN

- **OFFEN:** Survey nennt 8 Forschungs-TODOs explizit; viele davon sind noch nicht systematisch beantwortet.
- **OFFEN:** "We do not consider in detail which techniques complement or inhibit each other." → STRATEGY COMPATIBILITY MATRIX nicht in Paper, aber notwendig fuer COMDARE Choice-Builder.
- **OFFEN:** Survey nennt Instruction-Cache, aber bietet keine Modellierung. Concept ICachePage ist Daten-orientiert; Instruction-Cache fehlt im REV 2.
- **OFFEN:** Der MicroServer-Vorschlag steht orthogonal zu Index-Strategien; in Architektur ist die Verbindung Search-Index ↔ ScheduleHeuristic nicht modelliert.

---

## P16 Bender/Demaine/Farach-Colton (2002) — "Efficient Tree Layout in a Multilevel Memory Hierarchy"

**Venue:** ESA 2002 (LNCS 2461), pp. 165-173. (Conference-Version dieses Papers; eine erweiterte Variante "Tree Layout in Multilevel Memory" existiert separat — die zugrunde liegende Algorithmik ist identisch.)
**Theorie-Beitrag:** Probability-distribution-aware Layout fuer FIXED-Topologie-Trees in Multi-Level Memory.

### 1. CACHE-STRATEGIEN

- **ProbabilityWeightedRootBlockStrategy** (Sektion 2, Lemma 1): Es existiert ein optimales Layout, sodass innerhalb des Blocks, der die Wurzel enthaelt ("root block"), die Knoten einen connected subtree formen. → **Strukturelle Cache-Strategie-Invariante.**
- **GreedyRootBlockMaximizationStrategy** (Sektion 2.1): Algorithm — "chooses the root block that maximizes the sum of the probabilities of the nodes within the block." Beginnt mit Wurzel; addiert iterativ den naechsthoechsten-probabilistischen Knoten, der adjacent zu Block-Knoten ist; bei Saettigung rekursive Anwendung auf die uebrig gebliebenen Subtrees. **Theorem 1**: Greedy ist innerhalb (B-1)/B < 1 Zusatzkosten optimal.
- **RelaxedGreedyStrategy** (Sektion 2.2): Statt strikt-maximaler Wahl: ε-naheliegende Wahl. Kosten 1/ε mal Optimum + (B-1)/B. Ermoeglicht Layout-Flexibilitaet (z.B. Topological-Constraints).
- **CacheObliviousProbabilityLayoutStrategy** (Sektion 3): Greedy mit *unspecified* Block-Size B; rekursiv auf Sub-Blocks. **Theorem 3**: 4 mal Optimum + 4. → erste Cache-Oblivious-Variante mit Probability-Awareness.
- **GilItaiOptimalLayoutStrategy** (Related Work): Vorgaengerverfahren — exakt-optimal via Dynamic Programming, O(NB² log Δ) Zeit, O(B log N) Space. Δ = max degree.

### 2. ALGORITHMUS-STRATEGIEN

- **GreedyAlgorithm** (Sektion 2.1): O(N log B) auf RAM. Implementierung: Priority-Queue-basiert. Initialisierung mit Wurzel; bei Hinzufuegen eines Knotens: Order-Statistik der B-max-probabilistischen Kinder, in Queue einfuegen. Queue-Groesse hoechstens B² (nur top-B-Kinder, da nur B Knoten gewaehlt werden).
  - Open Problem (Sektion 2.1 Ende): "Can we reduce the number of memory transfers below Θ(N)?" wenn Tree mit Pointers in zusammenhaengendem Memory-Segment vorliegt.
- **RecursiveSubtreeLayout**: Nach Wahl des Root-Blocks: Algorithmus rekursiv auf jeden uebrigen Subtree; konkateniere die rekursiv entstehenden Layouts.

### 3. SONDERMERKMALE

- **Probability-of-Internal-Node** (Sektion 2 Eingang): "the probability of an internal node to be the sum of the probabilities of the leaves in its subtree." → Definition relevant, weil Probabilities NUR auf Leaves angegeben sind; Inner-Probability folgt linear.
- **Smooth-Cost-Model** (Sektion 2.1, Theorem 1): Zur Beweisfuehrung — "the cost of accessing a block containing j elements is j/B instead of 1." Bewertungs-Modell, kein Algorithmus.
- **Fixed Tree Topology**: Der zentrale Annahme-Frame — "Search trees frequently encode decision trees that cannot be rebalanced because the operations lack associativity. Such trees naturally arise in the context of string or geometric data, where each node represents a character in the string or a geometric predicate." → Enthaelt **Tries, Suffix-Trees, Cartesian Trees, k-d Trees, BSP, Quadtrees** explizit. **Direkt relevant fuer COMDARE Trie-Index!**
- **Heavy-Tail-Distributions**: "In practice, however, most distributions are nonuniform, e.g., distributions with heavy tails arise almost universally throughout computer science."
- **Dramatic Savings bei Skew**: Naive Layout vs Optimum bei linear-height-Tree oder sehr skewed Verteilung: B-faktorielle Savings.

### 4. PLATTFORM-MODELLIERUNG-BEZUG

- **ICacheLevel + ICacheLine + IBusTopology**: Multilevel-Memory-Hierarchy mit B als Block-Transfer-Size. Die Cache-Oblivious-Erweiterung erfordert KEINE Kenntnis von B — laeuft auf JEDEM Level.
- **IHeuristic**: Probability-Distribution auf Leaves IST eine Workload-Heuristic. → COMDARE braucht eine `IAccessProbabilityDistribution` Concept-Klasse als Input fuer Heuristics.
- **Lookups in mehreren Levels gleichzeitig optimal**: Cache-Oblivious-Variante (Theorem 3) — Performance gleichzeitig optimal auf jedem Memory-Level (innerhalb Konstanten-Faktor).

### 5. VERALLGEMEINERUNGS-VORSCHLAEGE

- **ICacheStrategy.ProbabilityWeightedLayout** als neue Sub-Klasse, mit Sub-Sub-Klassen:
  - `OptimalDPLayout` (Gil-Itai, NP-fuer-Storage-Constrained, P fuer unconstrained)
  - `GreedyLayout` (Bender, (B-1)/B optimal, O(N log B))
  - `RelaxedGreedyLayout` (1/ε optimal, mehr Layout-Freiheit)
  - `CacheObliviousProbabilityLayout` (4× optimal, kein B-Wissen noetig)
- **NEUER Concept-Vorschlag fuer COMDARE: IAccessProbabilityDistribution**
  - Sub-Klassen: `UniformDistribution`, `HeavyTailDistribution`, `EmpiricalDistribution`, `LearnedDistribution` (durch Profiling)
  - Wird gefuettert in `ProbabilityWeightedLayoutStrategy` und in IHeuristic
- **Generalisierung Sub-Layer fuer ISearchPagesStrategy**: Bender-Greedy-Algorithmus IST ein ISearchPagesStrategy-Aufbau-Algorithmus (er ordnet Knoten zu Pages an basierend auf Probability). → COMDARE: `ProbabilityGreedyPagePackingStrategy : ISearchPagesStrategyPattern`.
- **CACHE-OBLIVIOUS vs CACHE-AWARE: konkrete Concept-Trennung** (siehe Synthese-Sektion).

### 6. LUECKEN

- **OFFEN:** Probability-Distribution wird als bekannt (statisch) vorausgesetzt. **Nicht** im Paper: dynamische Probability-Updates bei Workload-Drift.
- **OFFEN:** Insertions/Deletions sind nicht behandelt — Tree-Topologie ist FIXED. → Nicht direkt fuer dynamische COMDARE-Trie anwendbar; Re-Layout-Kosten unklar.
- **OFFEN:** Open Problem aus Sektion 2.1 (Greedy in <Θ(N) Memory-Transfers fuer prescribed-form-Trees) ist im Paper offen.
- **OFFEN:** Greedy braucht Order-Statistik der B max-probabilistischen Kinder — NICHT trivial fuer hohen Fanout (Δ groß).
- **OFFEN:** Bewertung erfolgt analytisch, KEIN empirischer Benchmark im Paper.

---

## P17 Bender/Demaine/Farach-Colton (2005) — "CACHE-OBLIVIOUS B-TREES"

**Venue:** SIAM J. Computing, May 2005 (received May 2001). Konferenz-Vorgaenger: FOCS 2000.
**Theorie-Beitrag:** Erste DYNAMISCHEN Cache-Oblivious-Suchbaeume mit zwei Varianten (mit/ohne Scan).

### 1. CACHE-STRATEGIEN

- **VanEmdeBoasLayoutStrategy** (Sektion 2.1): Statisches Layout — rekursive Aufteilung des Trees an der mittleren Edge-Reihe in Top-Subtree A (Hoehe h/2) + Bottom-Subtrees B1...B_ℓ (Hoehe h/2). Layout: rekursive Layout der Sub-Trees, dann Konkatenation A, B1, ..., B_ℓ. Bei jeder Detail-Stufe k wird jeder rekursive Subtree in einem zusammenhaengenden Memory-Block gespeichert.
  - **Lemma 2.2**: Ein Search in N-Knoten-Tree mit van-Emde-Boas-Layout, Knoten-Children δ ≥ 2, Δ = O(1), kostet hoechstens 4⌈log_δ log_{B+1} N + log_{B+1} Δ⌉ = O(1+log_{B+1} N) Memory-Transfers.
  - Wichtige Eigenschaft: "at any level of detail, each recursive subtree is stored in a contiguous block of memory" → Inkrementelle Verallgemeinerbarkeit.
  - **Hinweis**: Layout RESEMBLES van-Emde-Boas-Datenstruktur; ist aber ein NORMALER Tree mit Pointers, in vEB-Order in Memory.
- **PackedMemoryArrayStrategy** (Sektion 2.3, Theorem 2.5): Halt N Elemente in geordnetem Array der Groesse cN; supports insertions und deletions in O(1 + log²N/B) amortisiert; supports scan O(1 + S/B). Kombiniert dichten Pack (fuer Scan) + leere Slots (fuer Insertion-Locality).
  - Density-Thresholds: pro Knoten u in Tiefe k zwei Schwellenwerte τ_k (oben) und ρ_k (unten), die linear sich entlang Tiefe verteilen.
  - Rebalance: bei Ueberschreitung redistribuiere auf den naechsten "within-threshold" Vorfahren.
- **StronglyWeightBalancedSearchTreeStrategy** (Sektion 2.2, Definition 2.3): Maintains Layout-Invarianz unter Insertions/Deletions. Property 1 (descendant amortization), Property 2 (strong weight balance: jeder Knoten in Hoehe h hat Θ(d^h) descendants).
  - **Branching parameter d > 4**; Wurzel hat 2-4d Kinder; alle internen Knoten d/4-4d Kinder.
- **TopTreeMiddleBottomThreeLayerStrategy** (Sektion 3, Sektion 3.1): "Top tree on Θ(N/log²N) elements stored according to van Emde Boas in packed-memory array. Middle level: Θ(N/log²N) groups of Θ(log N) elements. Bottom: Θ(N/log N) groups of Θ(log N)."
- **IndirectionLayerStrategy** (Sektion 3.2): "We use two levels of indirection to reduce the cost of updating pointers in the top tree." Bottom layer + middle layer + top layer mit "down" und "up" Pointern; representative elements und ghost elements.
- **BufferNodesStrategy** (Sektion 4, alternative Approach): "to enable storing data of different 'fluidity' in a single packed array" — Buffer-Knoten zwischen schneller veraenderlichen und langsam veraenderlichen Daten; protect low-fluidity data from frequent updates of high-fluidity data.
- **OrderedVsUnorderedBTreeVariants** (Sektion 3.3): Zwei Implementierungs-Pfade — *Ordered* mit Packed-Memory-Array auf Bottom (supports optimal scans), *Unordered* mit unsortierter Group-Collection (kein Optimal-Scan, aber bessere Update-Bounds: O(1+log_{B+1}N) statt O(1+log_{B+1}N+log²N/B)).

### 2. ALGORITHMUS-STRATEGIEN

- **vEBSplitMergeAlgorithm** (Sektion 3.1): Insertion/Deletion in Top-Tree folgt Weight-Balanced-B-Tree-Algorithmen. Splits/Merges werden konsistent mit vEB-Layout durchgefuehrt; "split-merge cost" = O(1+d^h/B) Memory-Transfers fuer Knoten in Hoehe h.
  - Operative Schritte beim Split: vEB-Layout-Reparatur via 3 lineare Scans (Kopie nach temp + Kopie B_1...B_i hinter A' + Kopie A''-temp hinter B_i).
  - Pointer-Update: 6× Scan jeder rekursiven Subtree-Hoehe.
- **PackedMemoryArrayInsertionAlgorithm** (Sektion 2.3): Einfuegen in Leaf-Knoten w; bei Vollheit Rebalance via uebergeordneten "within-threshold" Vorfahren u; Redistribute aller Elemente in u's subarray.
- **GhostElementHandling** (Sektion 3.2): Geloeschte Elemente, die in oberen Layern noch Repraesentanten sind, koennen nicht physikalisch entfernt werden; bleiben als "ghost elements".

### 3. SONDERMERKMALE

- **Ideal-Cache-Modell** (Sektion 1.1): Cache-Oblivious-Theorie basiert auf Frigo et al.'s ideal-cache model. Nur 2 Levels (Cache, Main Memory), Block-Size B, Capacity M, fully associative, optimal offline replacement.
  - "Although this model may superficially seem unrealistic, Frigo et al. show that it can be simulated by essentially any memory system with a small constant-factor overhead." → COMDARE: dies ist die theoretische Rechtfertigung, dass Cache-Oblivious-Strategien auf realer Hardware funktionieren.
- **Hyperfloor / Hyperceiling** (Sektion 1.4): ⌊⌊x⌋⌋ = 2^⌊log x⌋ und ⌈⌈x⌉⌉ = 2^⌈log x⌉. Hilfsoperatoren fuer Layout-Berechnung.
- **B-vs-N-Relation** (Sektion 1.3): Update-Bound O(1+log_{B+1}N + log²N/B) "matches the B-tree update bound when B = Ω(log N log log N). This last relation between B and N usually holds in external memory but often does not hold in internal memory." → Fuer In-Memory ist die Bound suboptimal!
- **Conference-vs-Journal-Version** (Sektion 4): Konferenz-Version FOCS 2000 nutzte BUFFER-NODES (kein Indirection); Journal-Version nutzt Indirection (zwei Layer).
- **Linked-List-Cache-Oblivious** (Sektion 4 Ende, Theorem 4.1): Bender et al. 2002 "developed a cache-oblivious linked list that supports insertions and deletions in O(1) memory transfers and scans of S consecutive elements in O(1+S/B) amortized." → Mit dieser Linked-Liste laesst sich der O(log²N/B) Term komplett eliminieren!

### 4. PLATTFORM-MODELLIERUNG-BEZUG

- **ICacheLevel + ICacheLine**: Cache-Oblivious-Algorithmen sind UNAUFLOESBAR-LEVEL — sie funktionieren OPTIMAL auf jedem Level der Hierarchie. → Concept ICacheTopology kann eine "Levels-known: Boolean" Property haben; Cache-Oblivious-Strategien setzen *false* voraus.
- **ICacheStrategy = Visitor**: vEB ist ein typisches **Visitor-Pattern** — eine Layout-Strategie wird auf einen STRUKTUREN-Tree angewendet; verschiedene Strategien lassen sich austauschen.
- **IBusTopology / IInterconnect**: Paper nimmt fully-associativen Cache an. Real-Hardware-Set-Associativity nicht modelliert (siehe Saikkonen unten).

### 5. VERALLGEMEINERUNGS-VORSCHLAEGE

- **ICacheStrategy.CacheObliviousLayout** als TOP-Level-Klasse mit Sub-Klassen:
  - `VanEmdeBoasLayout` (statisch)
  - `DynamicVEBWithPackedMemory` (vollstaendig dynamisch)
  - `BufferNodesVEBLayout` (Indirection-frei, FOCS 2000)
  - `IndirectedVEBLayout` (Indirection-Layers, SIAM 2005)
- **NEUER Concept-Vorschlag: ICacheStrategyAwareness**
  - Werte: `CacheOblivious`, `CacheSensitive` (cache-aware mit bekannten B), `Hybrid`
  - Trennt fundamentale Strategie-Familien voneinander
- **NEUER Concept: ILayoutInvariant**
  - Sub-Klassen: `WeightBalanceInvariant`, `VEBLayoutInvariant`, `DensityThresholdInvariant`, `RootBlockProbabilityInvariant`
  - Ist fuer ISearchPagesStrategy verbindlich, NICHT fuer ISearchPageStrategy.
- **Verbindung zu IHeuristic / IScheduler**:
  - PackedMemoryArray's Rebalance-Cost ist amortisiert → IScheduler kann Rebalance-Operationen *batchen* oder zu off-peak-Zeiten verschieben.
  - vEB-Split-Merge-Algorithmus ist **deterministisch & sequentiell** — IScheduler-Annahme: kein Concurrency-Modell nativ.

### 6. LUECKEN

- **OFFEN:** Worst-Case-Bounds vs Amortized-Bounds: Theorem 4.1 (Bender et al. 2002, Linked List) erreicht optimale Bounds, aber "It remains open whether these bounds can be achieved in the worst case." → COMDARE: bei Real-Time-Anforderungen ist Amortisation problematisch.
- **OFFEN:** Set-Associativity-Konflikte sind im Ideal-Cache-Modell ignoriert. Real-Hardware kann erhebliche Konflikte haben (siehe P18/P19 Saikkonen).
- **OFFEN:** Cache-Oblivious ist optimal ueber alle Levels — das gilt jedoch nur "within constant factors". Konstante Faktoren koennen praktisch erheblich sein.
- **OFFEN:** Implementierungs-Komplexitaet ist hoch (3 Layer + Indirection + Ghost-Elements + vEB-Repair). Praktische Adoption gering. → P18/P19 motivieren mit dieser Komplexitaet die simpleren cache-aware Approaches.

---

## P18 Saikkonen/Soisalon-Soininen (2008) — "Cache-sensitive Memory Layout for Binary Trees"

**Venue:** IFIP TCS (Theoretical Computer Science), 2008. Helsinki University of Technology.
**Bereich:** Cache-sensitive (cache-aware) static **GLOBAL RELOCATION** — Multi-Level Layout fuer Balanced Trees.

### 1. CACHE-STRATEGIEN

- **MultiLevelCacheSensitiveLayoutStrategy** (Sektion 3, Algorithmus Fig. 1): Globaler Relocation-Algorithmus fuer fixed-Size-Knoten + Multi-Level-Cache-Hierarchie B_1 < B_2 < ... < B_k. **Verallgemeinerung der One-Level-Cache-Sensitive-Layouts auf arbitrary block-size hierarchy.**
- **BFSRecursiveBlockFillStrategy** (Sektion 3): "first lowest-level (l = 1) block is filled by a breadth-first traversal of the tree starting from the root r. When this 'root block' is full, each of its children (i.e., the 'grey' or border nodes in the breadth-first search) will become the root node of its own level 1 block, and so on. On levels l > 1, level l-1 blocks are allocated to level l blocks in the same manner."
  - **Theorem 1**: Worst-case B_i-block path length P_i = ⌈h/h_i⌉, mit h_i = h_{i-1} ⌊log_{d_{i-1}} (B_i/B_{i-1} + 1)⌋, h_0 = 1, d_0 = (d_{i-1}-1) ⌊B_i/B_{i-1}⌋ + 1.
  - **Theorem 2**: Algorithmus laeuft in O(nk) Zeit.
- **LeafSpaceOptimization** (Algo Lines 17-20): "ensure that each level l block will be at least half full by trying to allocate the next available subtree in the remaining space in a non-full block." → SUB-Strategie zur Speicherplatznutzung.
- **CacheObliviousVEBProductionStrategy** (Sektion 3 "Cache-oblivious layout"): Mit B_i = (2^{2^i} - 1) · B_0 (i=1..k, k=4-5 reicht fuer In-Memory) erzeugt *unser* Cache-Sensitive-Algorithmus die van-Emde-Boas-Layout — top-down statt bottom-up rekursiv-unterteilt; einige Leaf-Level-Blocks evtl. nicht voll.
  - **WICHTIG**: Unser Algorithmus ist eine *konstruktive* Variante, die VEB als Special Case ergibt!
- **AliasingCorrectionStrategy** (Sektion 3 Ende): Korrektur fuer Set-Associative-Caches (d=2,4,8 way) — wenn die i-te Cache-Block in mehreren TLB-Pages alle auf den gleichen Set-Slot mappen, kann der Cache nur d davon halten. → Adresse-Permutation: A = A_k...A_2A_1A_0; addiere obere A_k...A_{i+1} zu A_i (modulo B_i/B_{i-1}). Erhoeht Algorithmus-Komplexitaet auf O(nk²).

### 2. ALGORITHMUS-STRATEGIEN

- **GlobalRelocationAlgorithm** (Algo Fig. 1, RELOC-BLOCK + RELOCATE): Single-Pass-BFS mit Auxiliary-Queues fuer Border-Knoten je Level. Nicht-rekursiv.
- **BinarySearchPageStrategy implizit**: Binary-Tree heisst Branching=2 → search ist O(h) mit h = Tree-Hoehe; das Layout reduziert nur die # Cache-Misses, nicht den Algorithmus.
- **ApplicableToBalancedTrees**: "The algorithm can be used for any kind of balanced tree with fixed-size nodes." → AVL, RedBlack, B+, CSB+ (auch Cache-Sensitive-B+-Trees).

### 3. SONDERMERKMALE

- **TLB als Level der Cache-Hierarchie**: "the mapping of virtual addresses to physical addresses used by multitasking operating systems employs a third hardware cache: the Translation Lookaside Buffer or TLB cache." Im Modell als zusaetzliches Cache-Level mit Block-Size = Page-Size (4096B). **TLB explizit als Plattform-Modell-Komponente.**
- **AliasingPhenomenon** (Sektion 3 Ende): Konflikt-Misses durch Set-Associativity, die auch von gut konstruiertem Multi-Level-Layout produziert werden koennen.
- **No-Algorithm-Change-Required**: "Our approach does not change the internal structure of the nodes nor the rebalancing strategy of the binary search tree. The approach is easy to implement on top of an existing implementation of any tree that uses rotations for balancing, e.g., red-black trees and AVL trees."
- **B_i-block search path length P_i** als Mass: P_0 = traditional path length; P_1 = #cache blocks visited; etc.
- **Cache-Sensitive vs Cache-Oblivious-Trade-off**: Multi-Level-Cache-Sensitive ist eigentlich nur optimal auf Level B_1; "It is not possible to be optimal on all levels, and we resolved this tradeoff by preferring the lowest level." → **EXPLIZITE TRADE-OFF-DOKUMENTATION**.

### 4. PLATTFORM-MODELLIERUNG-BEZUG

- **ICacheLevel + ICacheLine**: Multi-Level-Modell `B_0 = node size, B_1 = L1-line-size, B_2 = TLB-page-size, ..., B_{k+1} = ∞`. Jedes B_i ist Multiple von B_{i-1}.
- **ICacheTopology / SetAssociativity**: Explizit modelliert — d-way set-associative; Konflikt-Misses sind real und werden via Aliasing-Correction adressiert.
- **ICacheStrategy.CacheSensitive**: Im Sinne von "cache-aware" — Algorithmus kennt die Cache-Parameter B_1, ..., B_k. Cache-Oblivious-Variante ist Special Case (B_i geometrisch verteilt, parameter-frei).
- **IHeuristic** implizit: "in practice, [cache parameters] can be easily inferred from the CPU model or from metadata stored in the CPU."

### 5. VERALLGEMEINERUNGS-VORSCHLAEGE

- **ICacheStrategy.CacheSensitiveMultiLevelLayout** als neue Klasse:
  - Sub-Klassen: `BFSGreedyMultiLevelLayout` (Saikkonen-Algo), `ProbabilityWeightedMultiLevelLayout` (Bender-P16-Erweiterung), `OptimalDPMultiLevelLayout` (Gil-Itai-Erweiterung)
- **NEUER Concept: ICacheConflictModel**
  - Sub-Klassen: `FullAssociativeModel` (theoretisch), `SetAssociativeConflictModel` (real)
  - Beschreibt erwarteten Konflikt-Miss-Effekt
  - Wird gefuettert von ICacheTopology (Set-Associativity-Wert)
- **NEUER Concept: ILayoutCorrectionStrategy**
  - Sub-Klassen: `AliasingCorrection` (Saikkonen), `Identity` (keine Korrektur)
  - Wird auf produzierte Memory-Adressen angewendet
- **ISearchPagesStrategyPattern** Erweiterung:
  - `LevelWiseBFSPattern` (Saikkonen) ordnet Knoten in BFS-Order pro Level
  - `LevelWiseDFSPattern` (vEB-aehnlich) ordnet rekursiv DFS
- Verbindung zu COMDARE-Concepts:
  - `ISearchPagesStrategy.GlobalRelocation` als statische Methode (nicht inkrementell)
  - `IScheduler` koennte Global-Relocation periodisch triggern (abhaengig von Workload-Drift)

### 6. LUECKEN

- **OFFEN:** Algorithmus ist STATISCH — adressiert keine Insertions/Deletions. Dies wird in P19 (2016) gefolgt!
- **OFFEN:** "It is not possible to be optimal on all levels" — Trade-off-Wahl ist implizit "favor lowest level". Andere Wahl-Strategien (gewichtet nach Cache-Miss-Costs) werden erwaehnt aber nicht implementiert: "Knowledge of the relative costs of cache misses at each level could in theory be used to produce a more optimal layout, but we did not want our cache-sensitive algorithms to depend on these kinds of additional parameters."
- **OFFEN:** Aliasing-Correction loest gemessenes Problem, aber NICHT bewiesen optimal.
- **OFFEN:** Concurrency komplett aussen vor.
- **OFFEN:** Trie-Knoten haben variable Fanouts — Algorithmus geht von fixed-size Knoten aus. Generalisierung auf Trie nicht im Paper.

---

## P19 Saikkonen/Soisalon-Soininen (2016) — "Cache-Sensitive Memory Layout for Dynamic Binary Trees"

**Venue:** The Computer Journal, Vol. 59, No. 5, 2016 (Advance Access 4. Nov. 2015), British Computer Society. Aalto University.
**Bereich:** Cache-sensitive **LOCAL RELOCATION** — DYNAMISCHE Erhaltung der Layout-Invariante unter Insertions/Deletions.

### 1. CACHE-STRATEGIEN

- **LayoutInvariantPreservationStrategy** (Sektion 3, Invariante 3.1): "Each non-leaf node x of the search tree T is part of a connected subgraph of T that is stored in a single B_1-sized cache block, and contains either at least α non-leaf nodes or at least one leaf node."
  - α ≥ 2 ist **tunable Parameter**; α ≤ B_1/B_0 (Knoten muessen passen).
  - Im Special Case α = 2: Vereinfachung — "either the parent or one of the children of x is located on the same B_1-sized cache block as x."
- **LocalRelocationStrategy** (Sektion 3.2, Algorithmus Fig. 3 / Algorithmen 1+2): Statt globaler Relocation: nur 1-6 Knoten lokal verschieben pro Strukturmodifikation. Worst-case constant-time per modification (fuer fixed α).
  - **Theorem 3.6**: Algorithmen 1+2 koennen Invariante 3.1 in O(α³) Zeit re-establishen; verschieben O(α²) Knoten; visit O(α) separate cache blocks.
  - **Algorithm 1 (FIX-BROKEN)** fuer α = 2: 3 Optionen sequentiell — (a) Move broken b zu nicht-broken Nachbar mit freiem Slot; (b) Move x + D(x) zu Nachbar mit α freien Slots; (c) Force-Allocate neue Cache-Block.
  - **Algorithm 2 (FIX-BROKEN-LARGER-ALPHA)** fuer α > 2: Erst connected subgraph U sammeln; dann Move zu existing block oder neuer Block.
- **OptimalAllocationHeuristic** (Sektion 3.5): "in insertion, a new node should be allocated in the cache block of its parent, if it happens to have enough free space." → ZUSAETZLICHE Heuristic ueber die Invariante hinaus.
- **GlobalRelocationStrategyAsBaseline** (Sektion 4, vergleichend): Saikkonen-2008-Algorithmus dient als Initial-Layout; Local-Relocation erhaelt es.
- **PeriodicGlobalRelocation** (Sektion 3.7): "Local relocation could be combined with periodic global relocation" — Composite-Strategie. Nach n Updates ist Cache-Sensitivity meaningfully degradiert; dann Trigger fuer Global-Relocation.

### 2. ALGORITHMUS-STRATEGIEN

- **NoTreeStructureModification** (Sektion 1): "preserve both the structure of the tree nodes and the rebalancing algorithm intact." → Strategie ist ORTHOGONAL zur Tree-Strategie. Anwendbar auf AVL, Red-Black, Rank-Balanced, etc.
- **BrokenNodeIdentification** (Sektion 3.2, Fig. 2): Nach jeder Strukturmodifikation (insertion, deletion, rotation) wird eine begrenzte Liste potenziell-broken Knoten identifiziert (1-6 Knoten fuer α=2). Sieben Faelle abgedeckt: external/internal insert, external/internal-leaf/internal-non-leaf delete, single rotation, double rotation.
- **DependantTracking**: D(x) = Set von Nachbarn, die *broken* werden, falls *x* in anderen Block bewegt wird. Wesentlich fuer korrekten Move.
- **SearchUnchanged**: Search-Algorithmus bleibt unveraendert. Layout-Invariante reduziert *erwartete* Pfad-Laenge.
  - **Theorem 3.1**: Bei vollstaendigem Tree der Hoehe h, Invariante erfuellt: E[P_1] ≤ (2^{α-1}/(2^α - 1)) · h + 1/2.
  - **Beispiele**: α = 2 ⇒ P_1 ≤ h/2 + 2h/3 ≈ 0.67h + 1/2; α = 3 ⇒ ≈ 4h/7; α = 4 ⇒ ≈ 8h/15. Limit α → ∞: 1/2 + h/2.
- **Theorem 3.2**: One structure modification can cause O(α) broken nodes; findbar in O(α) Zeit.

### 3. SONDERMERKMALE

- **Memory-Layout-Invariante als Concept**: Erste Paper, das Layout als formale Invariante definiert. → COMDARE: Concept `ILayoutInvariant` ist konkret durch dieses Paper motiviert.
- **Tunable α**: Trade-off zwischen Invarianten-Strenge und Update-Kosten. Kleinere α = schneller, schwaechere Garantie; groesseres α = langsamer, staerker.
- **Hyder-Anwendungsfall** (Sektion 1): Bernstein et al.: Binary Search Trees als Datenbank-Index in Copy-on-Write-Semantik. → Echter In-Production-Use-Case fuer Binary-Trees-mit-Cache-Sensitivity.
- **TPC-C Benchmark** (Sektion 5.4): Erste experimentelle Evaluation mit realem DB-Workload (TPC-C via instrumentiertem MySQL/InnoDB). 26-30% Improvement bei Searches; 19-34% bei cB+; 1-12% bei CSB+.
- **Cross-Hardware-Evaluation** (Tabelle 1): 4 verschiedene CPUs (Athlon XP, Sempron 3000+, Atom N270, Core2 Quad) — alle mit gleicher 64B-Cacheline.
- **Cache-Sensitive vs Cache-Oblivious final ueberprueft** (Sektion 5.1): "Our experiments... support the intuition that multi-level cache-sensitive structures are more efficient than cache-oblivious ones. It has been shown in [14] that a cache-oblivious layout is never more than 44% worse in the number of block transfers than an optimal cache-sensitive layout, and that the two converge when the number of levels of caches increases."

### 4. PLATTFORM-MODELLIERUNG-BEZUG

- **ICacheLevel + ICacheLine**: Wie P18 — k-Level mit B_1 < ... < B_k, B_0 = node size, B_{k+1} = ∞.
- **ICacheTopology**: Set-Associativity erwaehnt aber im Algorithmus 2016 NICHT mehr explizit korrigiert; stattdessen wird Aliasing-Correction aus 2008 als Erweiterung referenziert.
- **IHeuristic**: Allocation-Heuristic ("allocate new node in parent's cache block if possible") als Sub-Komponente des Algorithmus.
- **IScheduler**: Layout-Erhaltung passiert *inline* mit Tree-Modifikationen — kein separater Scheduler-Pass; **Real-Time-affin**.
- **IIsaFeatureSet**: Algorithm verwendet keine speziellen ISA-Features (kein Software-Prefetch); reine Layout-Optimierung.

### 5. VERALLGEMEINERUNGS-VORSCHLAEGE

- **ICacheStrategy.LocalRelocationLayout** als neue Klasse:
  - Parameter: α (tunable)
  - Invariante: ILayoutInvariant.NeighborhoodConnectednessInvariant
  - Sub-Klassen: `LocalRelocationAlpha2`, `LocalRelocationAlphaN`
- **NEUER Concept: ILayoutInvariant.NeighborhoodConnectedness** als Sub-Klasse von ILayoutInvariant
  - Beschreibt: jeder Non-Leaf-Knoten hat Parent oder Child im selben Cache-Block
  - Parameter: α (Connected-Subgraph-Mindestgroesse)
- **NEUER Concept: ICompositeStrategy** (wichtig!): Kombiniert eine *aufbauende* Strategy (Global-Relocation) mit einer *erhaltenden* Strategy (Local-Relocation). → COMDARE-Architektur braucht eine Concept-Klasse zur Komposition mehrerer ICacheStrategies.
- **NEUER Concept: IAdaptationTrigger**:
  - Sub-Klassen: `OnEveryStructureModification` (P19 Local), `OnLayoutDegradationThreshold` (Composite), `Periodic` (Time-based), `Manual`
  - Verbindung zu IScheduler

### 6. LUECKEN

- **OFFEN:** Algorithmus addressiert NUR Single-Level (B_1). Multi-Level-Local-Relocation wird in Sektion 6 als nicht-trivial diskutiert: "we cannot, e.g., move a cache-block-sized area of nodes to establish the invariant after a change in the tree structure. A multi-level approach does not seem feasible in such a model."
- **OFFEN:** Insertion-Times werden um 8-46% (Athlon) bis 48-115% (Atom) langsamer. Trade-off Hardware-spezifisch.
- **OFFEN:** Concurrency komplett aussen vor — keine Lock-Strategien diskutiert. Hyder-Use-Case verwendet Copy-on-Write, was Concurrency umgeht.
- **OFFEN:** Algorithmus geht von Fixed-Size-Knoten (16B in Experimenten) aus. Trie-Knoten mit variabler Fanout-Groesse nicht abgedeckt.
- **OFFEN:** Paper diskutiert KEINE adaptive α-Wahl basierend auf Workload — α ist statisch beim Build.
- **OFFEN:** "Other multi-level cache-sensitive search tree algorithms are presumably also affected by the aliasing phenomenon, and it would be interesting to see the effect of a similar aliasing correction on, for example, the two-level cache-sensitive B-trees."

---

## QUERVERWEISE / SYNTHESE

### Zeitliche/Theoretische Linie

```
P15 (2001) ──┐
             │ Survey-Folklore
             ▼
P14 (2005) ──┐ Cache-Aware Adaptation (Itanium 2)
             │ ConfigurationTable als Heuristic-Vorlage
             │
P16 (2002) ──┼── Probability-Weighted Layout (FIXED Topo)
             │   (Greedy + Cache-Oblivious-Variante)
             │
P17 (2005) ──┼── Cache-Oblivious B-Trees (DYNAMIC)
             │   (vEB + Packed-Memory-Array + Indirection)
             │
P18 (2008) ──┼── Cache-Sensitive Multi-Level Layout (STATIC)
             │   (BFS Greedy, AliasingCorrection, TLB)
             │
P19 (2016) ──┘   Cache-Sensitive Local Relocation (DYNAMIC)
                 (Layout-Invariante mit α-Parameter)
```

Konzeptueller Fluss: P15-Survey identifiziert Strategien-Familie → P14 zeigt Adaptation an konkrete CPU + Configuration-Table-Idee → P16+P17 entwickeln theoretische Cache-Oblivious-Theorie (statisch + dynamisch) → P18+P19 bringen Cache-Aware/-Sensitive-Praxis fuer Multi-Level + Dynamic.

### Welche Layout-Theorien sind cluster-uebergreifend?

| Theorie | Cluster A (Trie) | Cluster B (B+/Suchbaum-Knoten) | Cluster C (Layout-Theorie) | Cluster D (Prefetching) |
|---------|------------------|--------------------------------|----------------------------|--------------------------|
| **Cacheline-Alignment** | grundlegend (ART, HOT) | grundlegend (CSB+) | impliziert in P14, P15, P18 | n/a |
| **Knoten-Groesse-Wahl** | implizit in HOT | explizit Hankins-Patel, P14 | nicht primaer | n/a |
| **Probability-weighted** | NEU fuer Trie! | nicht etabliert | P16 zentral | n/a |
| **Cache-Oblivious** | nicht etabliert | nicht etabliert | P17, P16-CO-Variante, P18-Spezialfall | n/a |
| **Cache-Sensitive Multi-Level** | nicht etabliert | n/a | P18, P19 | n/a |
| **Local-Relocation-Invariante** | NEU fuer Trie! | NEU fuer B+! | P19 | n/a |
| **Order-Preserving Compression** | CoCo-Trie (Cluster A) | P15 | erwaehnt P15 | n/a |
| **Software-Prefetch** | n/a (nicht in Cluster A primaer) | P14, P15, Chen-2001 | erwaehnt P14, P15 | Cluster D zentral |
| **Configuration-Table-Heuristic** | n/a | P14 | n/a | n/a |

**Cluster-uebergreifende Generalisierung**: Die Layout-Theorien aus Cluster C lassen sich systematisch auf Cluster A (Trie) uebertragen, sind aber dort BISHER NICHT angewendet:
- **Probability-weighted Trie-Layout** (Bender P16) — Trie-Pfade folgen Schluessel-Verteilung; heavy-tail-fest!
- **vEB-Trie-Layout** (Bender P17) — fuer balanced-height-Tries
- **Local-Relocation fuer Trie** (Saikkonen P19) — tunable α-Parameter, dynamische Erhaltung

### Cache-Oblivious vs Cache-Aware: Welche Concept-Trennung ergibt sich?

**Vorschlag fuer COMDARE Concept-Hierarchie:**

```
ICacheStrategy (VISITOR)
│
├── BaseEngineStrategy
│   └── (Default-Behaviour, kein Cache-Awareness)
│
└── CacheEngineStrategy
    │
    ├── CacheObliviousStrategy
    │   ├── VanEmdeBoasLayoutStrategy [P17]
    │   ├── DynamicVEBWithPackedMemoryStrategy [P17]
    │   ├── CacheObliviousProbabilityWeightedStrategy [P16, Sektion 3]
    │   └── (Weiter Cache-Oblivious-Familie)
    │
    └── CacheAwareStrategy  (≡ CacheSensitive)
        │
        ├── CachelineAlignedNodeStrategy [P14, P15]
        ├── BTreeOfCacheLinesStrategy [P15 Sektion 4.3]
        │
        ├── CacheSensitiveMultiLevelLayoutStrategy [P18]
        │   ├── BFSGreedyMultiLevelLayout [P18]
        │   ├── ProbabilityWeightedMultiLevelLayout [P16+P18 Verschmelzung]
        │   └── AliasingCorrectedLayout [P18 Erweiterung]
        │
        ├── LocalRelocationLayoutStrategy [P19]
        │   ├── LocalRelocationAlpha2 [P19 Algo 1]
        │   └── LocalRelocationAlphaN [P19 Algo 2]
        │
        ├── ProbabilityWeightedRootBlockStrategy [P16]
        │   ├── OptimalDPLayout [Gil-Itai]
        │   ├── GreedyLayout [P16 Theorem 1]
        │   └── RelaxedGreedyLayout [P16 Theorem 2]
        │
        ├── CompressionStrategy
        │   ├── OrderPreservingCompression [P15 Sektion 5.1]
        │   ├── PrefixSuffixTruncation [P15 Sektion 5.3]
        │   ├── NextNeighborDifferencing [P15 Sektion 5.4]
        │   └── KeyNormalization [P15 Sektion 5.2]
        │
        ├── KeyAcceleratorStrategy
        │   └── PoorMansNormalizedKey [P15 Sektion 6.1]
        │
        ├── LayoutOrganizationStrategy
        │   ├── VerticalPartitioningStrategy [P15 Sektion 6.4]
        │   └── PointerToExtentsStrategy [P15 Sektion 6.3]
        │
        └── SoftwarePrefetchStrategy
            ├── LookaheadPrefetch [P14, P15]
            ├── RangeScanPrefetch [P14, P15]
            ├── IndirectionVectorRangePrefetch [P15 Sektion 4.2]
            └── PostLocationFieldPrefetch [P15 Sektion 4.2]

ICacheStrategyAwareness (Property auf ICacheStrategy)
├── CacheOblivious  (B unbekannt; optimal fuer alle Levels innerhalb Konstanten-Faktor)
├── CacheSensitive   (B bekannt; optimal fuer ein definiertes Level)
└── Hybrid           (Kombination, e.g., P18-Algorithmus mit B_i geometrisch fuer vEB)
```

**Composite-Strategien** (nicht in REV 2 modelliert!):
- `CompositeStrategy = (BuilderStrategy, MaintenanceStrategy)` — z.B. (P18 Global-Relocation, P19 Local-Relocation)
- `CompositeStrategy = (BuilderStrategy, AdaptationTrigger, RebuildStrategy)` — z.B. periodisches Rebuild

### Welche IHeuristic-Klassen koennen wir aus diesen Theorien ableiten?

**Vorschlag fuer COMDARE IHeuristic-Hierarchie:**

```
IHeuristic
│
├── ConfigurationLookupHeuristic [P14]
│   ├── Eingang: (KeySize, NodeSize, SearchStrategy, Workload-Type)
│   └── Ausgang: optimale Strategy-Konfiguration
│
├── ProbabilityDistributionHeuristic [P16]
│   ├── UniformAccessHeuristic
│   ├── HeavyTailAccessHeuristic
│   ├── EmpiricalAccessHeuristic
│   └── LearnedAccessHeuristic (Profiling-basiert)
│
├── ConflictMissPredictionHeuristic [P18]
│   └── Eingang: SetAssociativity, BlockHierarchy
│   └── Ausgang: erwartete Konflikt-Miss-Rate, AliasingCorrection-Bedarf
│
├── SearchStrategySelectionHeuristic [P14, P15]
│   ├── LinearSearchPreferredHeuristic (Itanium 2 / EPIC, kleine Knoten)
│   ├── BinarySearchPreferredHeuristic (Standard)
│   ├── InterpolationSearchPreferredHeuristic (uniforme Verteilung [P15])
│   └── PoorMansKeyAcceleratedHeuristic (variable-length Keys [P15])
│
├── PrefetchTriggerHeuristic [P14, P15, Cluster D]
│   ├── EagerPrefetchHeuristic (Itanium 2 In-Order)
│   ├── LazyPrefetchHeuristic (Out-of-Order Pentium)
│   └── DistanceAdaptivePrefetchHeuristic
│
├── LayoutDegradationHeuristic [P19]
│   ├── Eingang: # Updates seit letztem Global-Relocation, Layout-Invarianten-Verletzungen
│   └── Ausgang: Trigger fuer Local- oder Global-Relocation
│
├── AlphaTuningHeuristic [P19]
│   ├── Eingang: Workload (Insert/Search Ratio, Cacheline-Groesse, Knoten-Groesse)
│   └── Ausgang: optimal α
│
├── StrategyCompatibilityMatrixHeuristic [P15]
│   ├── Eingang: gewaehlte Strategie-Kombinationen
│   └── Ausgang: Compatibility-Score (welche Kombinationen verstaerken/inhibieren sich gegenseitig)
│
└── WorkloadAdaptationHeuristic [P14 + P19]
    ├── PointQueryOptimizedHeuristic
    ├── ScanOptimizedHeuristic
    ├── InsertOptimizedHeuristic
    └── MixedWorkloadHeuristic (Workload-Mix-aware)
```

### Neue Concept-Vorschlaege fuer REV 3 (nicht in REV 2)

| Neues Concept | Quelle | Zweck |
|---------------|--------|-------|
| `IAccessProbabilityDistribution` | P16 | Workload-Modellierung als Strategy-Input |
| `ICacheStrategyAwareness` | P17, P18 | Trennung Cache-Oblivious vs Cache-Aware |
| `ILayoutInvariant` | P19 | Formale Invariante als Strategy-Property |
| `ICacheConflictModel` | P18 | Set-Associativity-Konflikte explizit |
| `ILayoutCorrectionStrategy` | P18 | Aliasing-Correction etc. |
| `ICompositeStrategy` | P19 | Kombination Builder + Maintenance |
| `IAdaptationTrigger` | P19 | Wann wird Strategie re-applied? |
| `ITemporalCacheStrategy` | P15 (Sektion 7) | Instruction-Cache + Code-Locality |
| `IBranchingFactor` (= Δ in Theorie) | P16, P17 | Inneres-Knoten-Fanout (verschieden von IFanout fuer COMDARE-Tries) |
| `IStrategyCompatibilityMatrix` | P15 | Konflikte/Verstaerkungen zwischen Strategien |

### Direkte Implikationen fuer die Diplomarbeit

1. **Configuration-Table-Approach (P14)** ist die direkte Vorlage fuer die "Active Adaptation"-Komponente von COMDARE. → Aufnahme als Initial-IHeuristic-Implementation.
2. **Probability-Weighted Layout (P16) auf Trie-Strukturen anwenden** ist ein klarer Forschungs-Beitrag — bisher nicht in der Trie-Literatur.
3. **Multi-Level + Local-Relocation (P18+P19) sind direkt anwendbar auf Trie**, sofern Knoten-Groesse fixiert wird (z.B. HOT-Bucket-Style).
4. **Cache-Oblivious vs Cache-Aware-Trennung (P17+P18+P19)** ist eine fundamentale Concept-Achse fuer COMDARE; **REV 3 sollte diese explizit modellieren**.
5. **Survey P15 listet 8 Forschungs-TODOs** — mehrere davon (Strategy-Compatibility, Column-Storage, Pre-Fetching, Micro-Servers) sind potentiell Diplomarbeits-Beitraege.

---

## OFFENE PUNKTE / UNKLARHEITEN

- **OFFEN:** P18-Datei ist unter zwei moeglichen Pfaden: "Cache-sensitive Memory Layout for Binary Trees.pdf" wurde gewaehlt (Saikkonen/Soisalon 2008, Helsinki). Alternativ-Pfad "Efficient Tree Layout in a Multilevel Memory Hierarchy.pdf" ist die ESA-2002-Version von Bender/Demaine/Farach-Colton (P16). **Beide gepruft; Zuordnung korrekt.**
- **OFFEN:** P16 (Bender 2002) hat zwei Pfade: "Tree Layout in Multilevel Memory (BenderDemaineFarach-Colton 2002).pdf" und "Efficient Tree Layout in a Multilevel Memory Hierarchy.pdf". Erstere konnte vom System nicht gelesen werden (ENOENT trotz Glob-Treffer); Zweite ist die ESA-Conference-Version (LNCS 2461) und enthaelt die zentrale Algorithmik. Verwendet wurde die ESA-Version.
- **OFFEN:** Im COMDARE-REV-2 ist die Trennung `ICacheStrategy` (Visitor) vs `ICachePage` (mapped target) klar; aber der **Adaptive-Trigger-Mechanismus** fehlt. Dies muss in REV 3 explizit als `IAdaptationTrigger` aufgenommen werden.
- **OFFEN:** P19 erwaehnt explizit die Schwierigkeit von Multi-Level-Local-Relocation. Dies ist ein **Diplomarbeits-Forschungspotenzial** — Generalisierung von P19 auf Multi-Level fuer Trie.
- **OFFEN:** Keine der 6 Paper behandelt explizit **Concurrency** (Lock-Strategien, lock-free, RCU). Cluster G/H Paper (RCU, Hazard Pointers, ART) muessen separat ergaenzt werden.
- **OFFEN:** Keine der 6 Paper behandelt **persistente Speicher / NVRAM**. Lessons-Learned-Optane-Paper (Cluster low-priority) muss separat eingebunden werden.
