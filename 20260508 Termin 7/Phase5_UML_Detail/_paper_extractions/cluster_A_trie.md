# Cluster A — Trie-Familie

> Tiefe Lektuere von 6 Paper im Kontext der Concept-Hierarchie REV 2.
> Saeule A: ISearchPage / IRootPage / IFanout / INode / ICacheStrategy (BaseEngine vs. CacheEngine) / ISearchPagesStrategy / ISearchPagesStrategyPattern.
> Saeule B: ICacheLevel / ICacheLine / ICacheTopology / ICacheResidency / ICpuCore / IIsaFeatureSet / IInterconnect / IMemoryBandwidthModel / ILivePlatformModel / IHeuristic.

---

## P01 ART (Leis/Kemper/Neumann 2013)

PDF-Quelle: ICDE 2013, "The Adaptive Radix Tree: ARTful Indexing for Main-Memory Databases".

### 1. Cache-Strategien
- **Adaptive Knotengroessen** (Sec. III.B/III.C): Knoten haben 4 verschiedene physische Repraesentationen (Node4 / Node16 / Node48 / Node256), gewaehlt nach Anzahl nicht-leerer Kinder. Zweck: Kompakte Knoten passen in wenige Cache-Lines, sind besser cachebar als sparse 256-Pointer-Arrays. Section V.B (Caching Effects) zeigt: bei dense keys verursacht ART nur halb so viele Cache-Misses wie FAST/HT, weil "compact nodes can be cached effectively".
- **Single-Cache-Line-Header** (16 Bytes): jeder Inner-Node beginnt mit einem konstanten Header (Knotentyp, Childcount, compressed path). Dimensioniert kleiner als eine Cache-Line, sodass Header und Payload-Beginn gemeinsam geladen werden.
- **Lazy expansion + Path compression** (Sec. III.E, Fig. 6): kollabiert one-way-Pfade und truncatiert Subtrees ueber einzelnen Leaves. Reduziert Knotenzahl → reduziert Anzahl Cache-Misses pro Lookup.
- **Implizite Pre-Sortierung im Node4/Node16-Layout** (Fig. 5): Keys gespeichert sortiert, sodass Range-Scans cache-freundlich linear sind.
- **Implizit: Read-Caching ohne Schreib-Optimierung**. ART verwendet keine speziellen Write-Combining/NT-Stores oder explizite Prefetches.
- **Konkretisierungs-Kandidat**: `AdaptiveNodeFootprintStrategy` (Cache-Strategie, die Knoten-Footprint dynamisch an Population anpasst, um Cache-Line-Count zu minimieren).

### 2. Algorithmus-Strategien
- **findChild-Strategie pro Node-Typ**, dispatched nach `node.type`:
  - Node4: linearer Scan ueber 4 Eintraege (Fig. 8, Z. 1-5).
  - Node16: SIMD-paralleler Vergleich (`_mm_set1_epi8` + `_mm_cmpeq_epi8` + `_mm_movemask_epi8`), alternativ binary search.
  - Node48: zweistufiger Lookup ueber `childIndex[byte]` → `child[index]`.
  - Node256: direkter `child[byte]`-Lookup, ein Array-Zugriff.
- **Span s = 8 Bit** (1 Byte) als globaler Trie-Span, weil "bytes are directly addressable which avoids bit shifting and masking operations" (Sec. III.C).
- **Pessimistic vs. Optimistic Path Compression** (Sec. III.E): hybrid mit konstantem 8-Byte-Vektor und dynamischem Switch.
- **Bulk loading**: rekursive Radix-Partitionierung in 256 Buckets (Sec. III.F.Bulk).
- **Binary-Comparable-Keys-Transformation** (Sec. IV): Keys werden vor Insert in eine bytewise lexikographisch sortierbare Form gebracht (Vorzeichenflip, Float-Klassifikation, ICU UCA, Compound Keys, Null Handling).
- **Konkretisierungs-Kandidat**:
  - `PerNodeTypeFindChildStrategy` (eine `ISearchPageStrategy` pro Node-Typ).
  - `AdaptiveFanoutPolicyStrategy` (entscheidet bei grow/shrink den Wechsel des Layouts).
  - `KeyNormalizationStrategy` (binary-comparable Transformation, koennte `IKeyTransformStrategy` werden).

### 3. Sondermerkmale
- **Garantierte Worst-Case-Bytes pro Key (52 B)** durch induktive Budget-Analyse (Sec. III.G, Theorem mit Funktion b(n)). Nutzt 6 statt 4 Node-Typen (Node2/5/32/64) → 34 Bytes pro Key.
- **Tagged pointers** (Sec. III.D, Combined pointer/value slots): Tuple-Identifier koennen direkt im Pointer-Slot stehen (1 Bit Tag), spart Leaf-Knoten.
- **Differential update mechanism** als Alternative zu update-faehigen Strukturen (Sec. V.C, vs. FAST+delta).
- **Branch-Misprediction-Profil**: Tabelle III zeigt 0.85 mispredicted branches/lookup bei sparse keys (Node-Typ Dispatch); HT hat fast keine; FAST hat keine. Branch-Prediction ist also Performance-Kostenfaktor.

### 4. Plattform-Modellierung-Bezug (Saeule B)
- **L3-Hits/Misses pro Lookup** explizit gemessen (Tabelle III): 0.65 L3 hits / 1.9 L3 misses bei 65K Keys ART, etc. Zeigt: Paper modelliert implizit `ICacheLevel` (L1/L2/L3) und `ICacheResidency` (hot vs. cold) anhand effective cache size (Fig. 13, 192 KB → 12 MB).
- **DRAM-Latenz** als motivierende Konstante ("DRAM latency amounts to hundreds of CPU cycles").
- **SIMD/SSE als IIsaFeatureSet**: explizite Nutzung von SSE-Vergleichen in Node16. Implizite Annahme: 16-Byte-SIMD-Register.
- **Multithreaded throughput** mit 12 Threads (Sec. V.A, Fig. 11), software pipelining mit 8 queries/thread → impliziert `IScheduler` und `ICoreLayout`.
- **Effective cache size** als Tunable (Fig. 13) → `IMemoryBandwidthModel` ist NICHT explizit; aber Bezug zu `ICacheTopology` (shared L3 vs. private L1/L2).

### 5. Verallgemeinerungs-Vorschlaege
- **`INodeTypeRegistry`** (oder `IFanoutRepresentationCatalog`): Set von Knoten-Layout-Klassen, parametriert nach Population-Bucket (4 / 16 / 48 / 256 / individuell). Generalisiert die Auswahl-Logik.
- **`IFanoutGrowShrinkPolicy`**: Konkretisierung von `ISearchPagesStrategyPattern`, die entscheidet, wann die Knoten-Layout-Variante gewechselt wird (Threshold-Funktionen pro Node-Typ).
- **`IPathCollapsePolicy`**: Lazy-Expansion + Path-Compression als generalisierte Strategie (waere auch fuer HOT relevant).
- **`IBranchDispatchStrategy`**: per-Node-Type findChild-Implementierung als Visitor-aehnliche Konkretisierung.
- **`IBudgetGuarantee` (Saeule B-relevant)**: Worst-Case-Space pro Key als invariant; koennte als Concept fuer `ISearchPagesStrategyPattern.guaranteed_max_bytes_per_key` modelliert werden.

### 6. Lueckenhinweise
- Concept-Hierarchie hat KEINE Ebene fuer `IKeyTransformStrategy` / `IKeyNormalizer`. ART zeigt: das ist ein eigener orthogonaler Aspekt zwischen User-Key und Trie-Key.
- Concept fuer **TaggedPointer / EmbeddedValue** in Pointer-Slots fehlt — koennte `IPointerEncoding` oder `ILeafEncodingStrategy` heissen.
- **Branch-Misprediction-Cost** als Plattform-Kennzahl ist nicht in Saeule B sichtbar — koennte `IBranchPredictorModel` werden.
- Concept fuer **Bulk-Loading-Strategie** fehlt (Sortier-vs-Inkrementell-Aufbau hat starke Cache-Implikationen).

---

## P02 HOT (Binna/Zangerle/Pichl/Specht/Leis 2018)

PDF-Quelle: SIGMOD 2018, "HOT: A Height Optimized Trie Index for Main-Memory Database Systems".

### 1. Cache-Strategien
- **k-constrained Compound Nodes** (Sec. 3.1): Eine ganze binaere Patricia-Subtrie wird in EIN Compound-Node mit max. Fanout k=32 gepackt. Ziel: Hoehe minimieren → weniger Cache-Misses (vgl. Fig. 1, Fig. 11: bis zu 68% niedrigere mean depth als ART bei strings).
- **Linearisiertes Knoten-Layout** (Sec. 4.1): Compound-Node wird in compact bit-string codiert (header + bit positions + partial keys + values), sodass der gesamte Knoten in moeglichst wenig Cache-Lines passt (size 64-472 Byte je nach Variante, Fig. 6).
- **9 physische Node-Layouts** (Fig. 6): Single-Mask-{8,16,32-Bit-PKEYS} und Multi-Mask 8/16/32 mit 8/16/32 partial-key-bits. Adaptive Auswahl der kleinsten passenden Variante pro Knoten.
- **Prefetch der ersten 4 Cache-Lines** des Knotens (Sec. 4.5): explicit prefetch + node-type kodiert in den least-significant bits des Pointers (pointer tagging) → Cache-Line-Load und Type-Dispatch ueberlappen.
- **Copy-on-Write fuer Concurrent Reads** (Sec. 5): obsolete-Marker statt sofortigem Free. Erlaubt lock-free reads (ROWEX-Strategie) → vermeidet Cache-Line-Bouncing durch shared writes.
- **Konkretisierungs-Kandidat**:
  - `LinearizedCompoundNodeStrategy` (Cache-Strategie: viele logische Knoten in einer kontinuierlichen Cache-Line-Folge).
  - `PointerTagDispatchStrategy` (Type-Bits im Pointer um Cache-Line-Load und Branch-Prediction zu ueberlappen).

### 2. Algorithmus-Strategien
- **Discriminative Bits Selection** (Sec. 3): pro Knoten werden nur die diskriminativen Bits der gespeicherten Keys betrachtet, nicht ein fester Span.
- **k-constrained Subtree Partitioning** (Sec. 3.1): Algorithmus, der binaere Patricia-Subtries in compound nodes mit max. k Eintraegen partitioniert, sodass Hoehe minimiert wird (Verallgemeinerung von Kovacs/Kis).
- **Insertion mit 4 Faellen** (Listing 1):
  - Normal Insert (BiNode-Modifikation).
  - Leaf-Node Pushdown.
  - Parent Pull Up (Overflow → propagiert nach oben).
  - Intermediate Node Creation (wenn Hoehenbudget vorhanden).
- **Lookup-Operation** (Listing 2):
  - `retrieveResultCandidates`: extract partial key (PEXT/AVX2), `searchPartialKeys` mit AVX2 (`_mm256_cmpeq_epi8` + `_mm256_movemask_epi8` + `bit_scan_reverse`).
  - Postfix-Verifikation (Patricia-Trie-Eigenschaft).
- **Dense vs. Sparse Partial Keys** (Sec. 4.4): zwei Repraesentationen fuer Partial-Keys, sparse erlaubt schnellere Inserts (PDEP-Instruktion zum Recodieren).
- **Konkretisierungs-Kandidat**:
  - `DiscriminativeBitsSelectionStrategy` (variante von `ISearchPagesStrategy` — bestimmt, welche Bits am Knoten gepruft werden).
  - `HeightConstrainedPartitioningStrategy` (`ISearchPagesStrategyPattern`, der die Hoehe global minimiert).
  - `SimdParallelKeyComparisonStrategy` (`ISearchPageStrategy`, nutzt AVX2 fuer parallele Key-Comparison im Knoten).

### 3. Sondermerkmale
- **PEXT/PDEP (BMI2)**: explizite Nutzung von Hardware-Bit-Manipulation-Instruktionen zur Partial-Key-Extraktion. Sehr ISA-spezifisch.
- **Hybrid Single-Mask / Multi-Mask Layout**: Single-Mask wenn alle diskriminativen Bits in 64-Bit-Fenster passen, sonst bis zu 4 Multi-Masks (8-Bit Offset + 8-Bit Mask).
- **Synchronization Protocol** (Sec. 5, Fig. 7): 5-Phasen Insert (determine affected, lock bottom-up, validate, perform+mark obsolete, unlock top-down).
- **Epoch-based memory reclamation** fuer obsolete nodes.
- **Determinismus-Eigenschaft (vermutet)**: HOT konstruiert moeglicherweise gleiche Struktur unabhaengig von Insertion Order (Sec. 3.3, "we conjecture").
- **AVX2 als Mindest-ISA**: nicht backward-kompatibel zu SSE-only.

### 4. Plattform-Modellierung-Bezug (Saeule B)
- **AVX2 / BMI2 als IIsaFeatureSet**: explizit benannt; Single-Mask braucht PEXT.
- **Cache-Line Awareness** durch Layout (4 Cache-Lines prefetched explizit).
- **Pointer Tagging** als Plattform-Optimierung (annahme 64-Bit Pointer mit 3-Bit Type-Tag).
- **i7-6700 4-Core / i9-7900X 10-Core** (Sec. 6.1): Skalierungsdaten bis 10 Threads → ICoreLayout (4 vs 10 Cores).
- **L1/L2/L3-Hierarchie**: explizit erwaehnt (32 KB L1, 256 KB L2, 8 MB L3).
- **ROWEX-Synchronization-Strategie**: explizit modelliertes Concurrency-Pattern (`IConcurrencyProtocol`?).

### 5. Verallgemeinerungs-Vorschlaege
- **`IDiscriminativeBitSelectionStrategy`**: generelles Concept fuer "bits of interest" pro Knoten — verallgemeinerbar fuer LOUDS (P09), CoCo (P04) etc.
- **`IPartialKeyEncoding`** (8/16/32-Bit-Varianten): Concept-Klasse fuer ISearchPage's interne Key-Speicherung (Subkonzept zu ICachePage).
- **`INodeOverflowResolutionStrategy`**: 4-Wege-Algorithmus (Normal / LeafPushdown / ParentPullUp / IntermediateNode). Kann in `ISearchPagesStrategyPattern` als policy abstrahiert werden.
- **`IBitManipulationFeatureGate`** (Saeule B): Concept fuer ISA-Features wie BMI2/PEXT/PDEP/AVX2 mit Fallback-Pfad bei Abwesenheit.
- **`IHeightOptimization`** als generischer Heuristic-Ansatz: minimiere expected lookup depth — koennte `IHeuristic` als Konkretisierung sein (Sub-Klasse: `BalancedHeightHeuristic`).

### 6. Lueckenhinweise
- **Concept fuer "Compound Node = Container-of-many-logical-nodes"** fehlt: HOT verwischt die 1:1-Beziehung zwischen INode und ISearchPage, ein HOT-Compound-Node enthaelt bis zu k INodes und bis zu k+1 Children-Pointer. Concept-Hierarchie sollte erlauben: ISearchPage hostet [N] INode (ISearchPage:INode = 1:N).
- **Concept fuer "Determinismus der Struktur"** fehlt — relevant fuer Reproducibility/Auditability.
- **Concept fuer "Partial vs. Full Key Verification"** fehlt: HOT kann durch Patricia-Eigenschaft false positives liefern, braucht Postfix-Check. Aehnliches Pattern in SuRF (P10). → koennte `IKeyVerificationStrategy` werden.
- **Synchronization-Protocol** ist orthogonal zur Suchalgorithmus-Hierarchie — fehlt als eigene Saeule (`IConcurrencyProtocol`).

---

## P04 CoCo-trie (Boffa/Ferragina/Tosoni/Vinciguerra 2024)

PDF-Quelle: Information Systems 120 (2024) 102316, "CoCo-trie: Data-aware compression and indexing of strings".

### 1. Cache-Strategien
- **Subtrie-Collapsing in Macro-Nodes** (Sec. 4.1): vollstaendige Subtries werden in einen einzigen Knoten kollabiert, dessen branching-Macro-Symbole succinct kodiert sind. Fewer nodes → fewer cache misses.
- **Pool of Succinct Encoding Schemes** (Sec. 4.3): pro Macro-Node wird datenabhaengig die kompakteste Kodierung gewaehlt aus:
  - **EF (Elias-Fano)**: monotone Sequenzen mit predecessor-search.
  - **PA (Packed Array)**: log u Bits pro Eintrag, supports binary search.
  - **BV (Bitvector)**: charakteristischer Bitvektor.
  - **DE (Dense Encoding)**: wenn alle Macro-Charaktere konsekutiv sind.
- **LOUDS-Topologie** als Cache-effiziente succinct-Repraesentation der Trie-Struktur (Sec. 4.6).
- **DFUDS** als alternative Topologie fuer rank-Operation (Sec. 4.6).
- **Alphabet-aware Encoding** (Sec. 4.4): lokales Alphabet pro Macro-Node squeezed → weniger Bits pro Symbol → mehr Inhalt pro Cache-Line. Ergebnis: bis 38% weniger Space, 16% schneller.
- **Konkretisierungs-Kandidat**:
  - `MacroNodeCollapsingStrategy` (Cache-Strategie: kollabiert Subtries in einzelne Knoten — verkuerzt Cache-Miss-Pfad).
  - `SuccinctEncodingPoolStrategy` (Cache-Strategie: waehlt pro Knoten das kompakteste Encoding).
  - `AlphabetAwareEncodingStrategy` (Cache-Strategie: lokales Alphabet → reduzierter Footprint).

### 2. Algorithmus-Strategien
- **Data-aware Optimization** (Sec. 4.2): Post-Order-DP, das pro Knoten v die optimale Anzahl Levels l zum Kollabieren bestimmt:
  ```
  C*(v) = min_{l in 1..h(v)} { C(v_l) + sum_{d in desc(v,l)} C*(d) }
  ```
  Bewertet, fuer jede potentielle Kollaps-Tiefe, die Space-Kosten der gewaehlten Encodings.
- **int_l(s)-Funktion** (Eq. 1, Sec. 4.1): wandelt die ersten l Symbole eines Branching-Strings in einen Integer ueber das Alphabet. Erlaubt lex-erhaltende Compression der Edge-Labels.
- **Lcp-Subtraction** (Sec. 4.1, Beispiel "he"): subtrahiert den longest common prefix x = c_v_l^1 von allen anderen Macro-Charakteren → reduziert das Universum auf den lcp-bereinigten Bereich.
- **Space-Time Trade-Off via alpha** (Sec. 4.5): erlaubt l auch dann zu vergroessern, wenn Space leicht wird (Faktor (1+alpha)) — schnellere Traversal bei minimalem Space-Verlust.
- **Lookup-Operation** (Sec. 4.6): traversal ueber LOUDS, pro Schritt: int_l(P[k..k+l-1]) berechnen, in EF-Sequence binary search → naechste LOUDS-Position.
- **rank/access/prefix_search/predecessor**: alle ueber DFUDS (rank) bzw. LOUDS (lookup) implementiert.
- **Konkretisierungs-Kandidat**:
  - `DataAwareCollapsingHeuristic` (`IHeuristic`-Konkretisierung — Saeule B! — datenabhaengige DP-Optimierung).
  - `LcpAwareIntegerEncodingStrategy` (`ISearchPageStrategy` — pro Knoten Integer-Mapping mit lcp-Subtraktion).
  - `EncodingSelectionStrategy` (`ISearchPageStrategy` — waehlt aus Pool {EF,PA,BV,DE}).

### 3. Sondermerkmale
- **Multi-Criteria Cost Function** (Theorem 1): O(N h^2) Bauzeit, O(N) Space; trade-off zwischen Bauzeit und Query-Performance.
- **Globaler vs. Lokaler Span-Wert l**: l muss lokal gewaehlt werden (Q3 in Sec. 4); ein globaler Wert ist sub-optimal.
- **Static Index** (vs. ART/HOT die dynamisch sind): rebuild-only, kein incremental update.
- **Word-Size-Bound auf l** (Sec. 4.4): l <= w / log sigma_v_l mit w = 128-Bit (uint128_t) — d.h. ISA-Wortbreite begrenzt die maximale Kollaps-Tiefe.
- **Interplay zwischen Topologie-Encoding (LOUDS/DFUDS), Edge-Label-Encoding (Pool) und Alphabet-Squeeze**: dreifache Optimierung gleichzeitig.

### 4. Plattform-Modellierung-Bezug (Saeule B)
- **Word Size w** (Sec. 4.4) als explizite Plattform-Variable: bestimmt l-bound. → `ICpuCore.word_size` oder `IIsaFeatureSet.machine_word_bits`.
- **Implementation auf SDSL/sux/ds2i** (Sec. 5.1): nutzt rank_support_v und SimpleSelectZero — diese impl. nutzen Cache-aware Block-Strukturen.
- **128-Bit uint128_t** als Plattform-Annahme (GCC __int128).
- **Intel Xeon Platinum 8260M, 384 GiB RAM** (Sec. 5.2).
- **Keine explizite Prefetch-Steuerung**, keine SIMD — die Optimierung ist primaer datengetrieben (DP-basiert).

### 5. Verallgemeinerungs-Vorschlaege
- **`ISuccinctEncodingPool`**: Concept-Klasse fuer Pool-of-Encodings mit Selection-Strategie. Sub-Klassen: EF / PA / BV / DE.
- **`IDataAwareOptimizer`**: Saeule B! — eine Konkretisierung von `IHeuristic`, die Space/Time-Cost-Funktionen ueber den gesamten Trie minimiert via DP. Sehr generalisierbar (vgl. P05 START Cost Model).
- **`ITopologyEncoding`**: separates Concept fuer LOUDS/DFUDS/BP — orthogonal zu den Edge-Label-Encodings. Sub-Klassen: `LoudsTopology`, `DfudsTopology`, `BpTopology`.
- **`ILocalAlphabet`**: pro Knoten eigenes Alphabet → Concept-Klasse fuer alphabet-bewusste Kompression.
- **`ISpaceTimeTradeOffParameter`** (Sec. 4.5, alpha): Konfigurierbarer Trade-Off-Knopf — koennte als `ITuningParameter` in `IHeuristic` modelliert werden.
- **`IRebuildCostModel`** (Saeule B): Bauzeit O(N h^2) ist relevant — Bauzeit-Modell fehlt in Saeule B.

### 6. Lueckenhinweise
- **Topologie-Encoding** ist nicht in der Concept-Hierarchie modelliert — LOUDS/DFUDS/BP/Pointer sind alle alternative Repraesentationen der Trie-Struktur und sollten als `ITopologyEncoding` mit Sub-Klassen abstrahiert werden.
- **Datenabhaengiger DP-Optimizer** ist eine eigene Concept-Familie (`IBuildTimeOptimizer` / `IConfigurationSearch`) — fehlt komplett in Saeule B.
- **Local Alphabet** ist ein neues Concept: Knoten kennt sein eigenes Alphabet (Subset des globalen).
- **Macro-Node = Mehrere Logische Knoten** (wie HOT) — die `INode`-Klasse muss erlauben, dass eine `ISearchPage` mehrere logische `INode` haelt.
- **Static vs. Dynamic** als Concept-Dimension fehlt (CoCo ist static, ART/HOT sind dynamic). → `IUpdatability` oder Mixin.

---

## P05 START (Fent/Jungmair/Kipf/Neumann 2020)

PDF-Quelle: ICDEW 2020, "START — Self-Tuning Adaptive Radix Tree".

### 1. Cache-Strategien
- **Multilevel Nodes** (Sec. III): NEUER Knoten-Typ in ART, der MEHRERE Key-Bytes ueberspannt (statt 1 Byte). Reduziert Trie-Hoehe → reduziert Cache-Miss-Anzahl. Erstes Beispiel: `Node64K` (2 Levels), `Node16M` (3 Levels).
- **Rewired Nodes** (Sec. III.A, Fig. 3-4): nutzt `memfd_create` + multiple `mmap`-Calls, um sparse virtual pages auf SHARED physical pages zu mappen. Dichtgepackte Bereiche teilen sich physical pages → leerer Adress-Bereich kostet 0 Speicher. Pointer-Tagging zur Identifikation aktiver Slots.
- **Multilevel Node4** (Sec. III.B, Fig. 5): nutzt die 12 ungenutzten Bytes eines regular Node4 als zusaetzliche key-bytes (4 Keys * 4 Byte) → spannt 4 Radix-Levels in EINER Cache-Line.
- **CLFLUSH-basierte Cache-Cost-Messung** (Sec. IV.A): explizite Plattform-Vermessung mit CLFLUSH zwischen Knoten-Traversals.
- **LFENCE als Speculation Barrier** (Sec. IV.A): isoliert Mess-Phase vor speculative execution.
- **Konkretisierungs-Kandidat**:
  - `MultilevelNodeStrategy` (Cache-Strategie: ein physischer Knoten umfasst mehrere logische Trie-Levels — Tiefe wird reduziert).
  - `VirtualMemoryRewiringStrategy` (Cache-Strategie: virtual<->physical page mapping zur Compaction).

### 2. Algorithmus-Strategien
- **Workload-agnostisches Cost Model** (Sec. IV.A):
  ```
  C(n) = C_L(n) * #_k(n) + sum_{x in child+(n,1)} C(x)
  C_Replaced(o, i) = C_L(o) * #_k(o) + sum_{x in child+(o,i)} C(x)
  b(n, o, i) = C(n) - C_Replaced(o, i)
  ```
  Bewertet pro Knoten den Benefit einer Multilevel-Ersetzung mit i Levels.
- **Level-aware Cache-Cost-Extrapolation** (Sec. IV.A):
  ```
  C_{L,Li}(n) = C_{L,L1}(n) + floor(C_{L,RAM}(n)/L_RAM) * (L_Li - L_L1)
  ```
  Approximiert die Kosten in tieferen Cache-Leveln basierend auf Latenz und gemessener Cache-Line-Anzahl.
- **Dynamic Programming Optimization** (Sec. IV.B, Bellman): bottom-up DP auf dem ART, pro Knoten ein Array combined-optimal-cost je Multilevel-Level. Wenn benefit b > 0, wird Multilevel-Replacement gewaehlt.
- **Self-Tuning Phase** (Sec. IV): einmalige offline-Phase, amortisiert ueber Zeit (z.B. wenn >10% Daten geaendert oder bei VACUUM).
- **Konkretisierungs-Kandidat**:
  - `CacheCostBasedNodePlacementHeuristic` (`IHeuristic`-Konkretisierung — datengetrieben + plattformgetrieben).
  - `BellmanDPNodeOptimizer` (`IHeuristic` — DP zur Optimal-Placement-Berechnung).
  - `OfflineSelfTuningStrategy` (`ISearchPagesStrategyPattern` — periodische re-tuning).

### 3. Sondermerkmale
- **Workload-agnostisches Modell**: Sec. IV.A explizit "we point out that this cost model is workload-agnostic", aber Tuning waere mit workload-aware Cost-Function moeglich. Gibt einen klaren Hook fuer `IWorkloadModel`.
- **Self-Tuning** als amortisierte Phase: Bauzeit-Cost akzeptabel, weil read-mostly Workload.
- **Cost-Messung erfolgt direkt auf Target-Machine** (Sec. I): keine Annahmen ueber Hardware — Plattform-Modell wird durch Vermessung gewonnen, nicht aus statischen Specs.
- **Garantierte Worst-Case-Bytes wie ART**: 52 Bytes pro Key bleiben gewahrt (Multilevel-Knoten <= sum b(x) - 52).
- **Page-Sharing collisions** (Sec. III.A): Inserts koennen page-collisions verursachen → explicit unsharing.
- **Memory consumption shared physical pages** vs. ART: variiert pro Dataset (books +54%, normal -55%).

### 4. Plattform-Modellierung-Bezug (Saeule B)
- **STARK relevant fuer Saeule B**:
  - **`ICacheLevel` mit Latency** (L_L1, L_L2, L_RAM): explizit modelliert (Sec. IV.A).
  - **`ICacheResidency`** (Cached/HeaderCached/Uncached, Tabelle I): explizit unterschieden bei Knoten-Lookup.
  - **`ILivePlatformModel`**: das Cost-Modell IST eine Live-Messung → exakt das Concept.
  - **Memory-page-management** (memfd_create, mmap, virtual<->physical): tiefer Kontakt zum OS-Memory-Management. → koennte `IVirtualMemoryStrategy` werden.
  - **CLFLUSH / LFENCE als ISA-Features**: explizit verwendet.
- **i9-7900X mit 13.8 MB LLC**, 60 ns LLC miss: konkrete Plattform-Kennzahlen.
- **Speculative execution / out-of-order processor** (Sec. V): explizit erwaehnt als Grund, warum Node48/Node256 weniger cache-misses zeigen als erwartet.
- **TLB Misses**: in Related Work erwaehnt (Wong et al. [17]), aber nicht direkt modelliert.

### 5. Verallgemeinerungs-Vorschlaege
- **`ICacheCostModel`**: Concept-Klasse fuer die Bewertung von Knoten-Traversal-Kosten unter Beruecksichtigung von Cache-Hierarchie. Key-Konkretisierung: `MeasuredCacheCostModel` (CLFLUSH-basiert), `EstimatedCacheCostModel` (analytisch).
- **`IPlatformProbe`**: Concept fuer das Konzept "messe die Hardware-Kosten direkt"; Sub-Klassen: `ClflushNodeProbe`, `LatencyProbe`, `BranchPredictorProbe`.
- **`INodeReplacementOptimizer`**: DP-basierter Optimizer als generalisiertes Concept fuer "ersetze N Knoten durch einen optimalen multi-level Knoten".
- **`ISpanWidthStrategy`**: bisherige `ISearchPagesStrategy` deckt nur 1-Byte-Span ab; START erweitert auf 2/3 Byte. Verallgemeinerung noetig.
- **`IPageMappingStrategy` (Saeule B)**: virtual-physical page mapping als orthogonal zu Knoten-Layout. Sub-Klassen: `DirectMapping`, `RewiredSharedPages`, `HugePages`.

### 6. Lueckenhinweise
- **`ILivePlatformModel` ist in Saeule B benannt, aber START zeigt: man braucht konkrete Probing-Methoden**. Concept fuer "Wie wird das Modell gewonnen?" fehlt — `IModelAcquisitionStrategy`.
- **Concept fuer "Memory Page Lifecycle"** fehlt: Rewiring impliziert Page-Sharing/Unsharing und ist eng mit OS-API gekoppelt (`memfd_create`, `mmap`).
- **`IHeuristic.cost_function` als Workload-agnostic vs. Workload-aware**: wichtige Dimension. Sollte `IWorkloadModel` als Input erlauben.
- **`IRebuildScheduler`** (analog VACUUM): wann wird das Self-Tuning angestossen? Time-basiert vs. Change-basiert.

---

## P09 Jacobson LOUDS (1989)

PDF-Quelle: SFCS 1989 (CH2806-8/89), "Space-efficient Static Trees and Graphs", Guy Jacobson, CMU.

### 1. Cache-Strategien
- **2-Bit-pro-Knoten Repraesentation** (Sec. 1, Sec. 3.1): ~2n Bits fuer eine n-Knoten Binary Tree (statt O(n log n) bei Pointern). Asymptotisch optimal — minimaler Memory-Footprint → wenig Cache-Lines.
- **Implicit Bit-Map / Level-Order Binary Marked** (Sec. 3.1, Fig. 1-2): die Position im Bit-String entspricht direkt der Knoten-ID. Kein Overhead durch separate Adressierung.
- **Level-Order Unary Degree Sequence (LOUDS)** (Sec. 3.2, Fig. 3): Knoten in BFS-Reihenfolge, Grad als unary code (1^d 0). Ergebnis: 2n+1 Bits insgesamt.
- **rank/select Auxiliary Data Structure (Directory)** (Sec. 2): o(n) Bits Overhead, ermoeglicht O(log n) bit-inspections fuer rank/select. Tarjan-Yao-Tabellen zur Dichtung.
- Cache-Strategie ist hier IMPLIZIT (Paper ist von 1989, vor moderner Cache-Analyse). Aber: alle Operationen brauchen wenige Bit-Inspections, was bei rank/select-Strukturen mit kleinen Word-Sizes bedeutet, dass ein einziger Cache-Line-Load reicht.
- **Konkretisierungs-Kandidat**:
  - `BitStringNodeRepresentationStrategy` (Cache-Strategie: maximaler Footprint-Compression via Succinct Encoding).
  - `LevelOrderTraversalLayoutStrategy` (Cache-Strategie: BFS-Layout begrenzt Working-Set bei Range-Scans).

### 2. Algorithmus-Strategien
- **rank(m)** und **select(m)** als atomare Operationen ueber Bit-Strings (Sec. 2). Universelle Bausteine.
- **left_child(m) = 2 * rank(m)**, **right_child(m) = 2 * rank(m) + 1** (Sec. 3.1) — pure Arithmetik + 1 rank-Call.
- **first_child(m) = select_0(rank_1(m)) + 1** (Sec. 3.2, fuer LOUDS) — 1 rank + 1 select.
- **next_sibling(m) = m + 1**, **parent(m) = select_1(rank_0(m))** (Sec. 3.2).
- **Parenthesis-Balancer** (Sec. 4.1): findet matching parenthesis in O(log n) bit-inspections via "pioneer parenthesis"-Konstruktion.
- **Konkretisierungs-Kandidat**:
  - `RankSelectNavigationStrategy` (`ISearchPageStrategy` — Navigation ueber rank/select primitives).
  - `LevelOrderUnaryDegreeStrategy` (`ISearchPagesStrategy` — Knoten-Grad als unary kodiert in BFS).

### 3. Sondermerkmale
- **Information-theoretic Lower Bound** (Sec. 1): Catalan-Number-basierte Untergrenze 2n + o(n) Bits, asymptotisch erreicht.
- **Cell-Probe Modell als Time-Metric**: bit-inspections statt instructions/cycles. Ist eine andere Plattform-Annahme als alle modernen Paper.
- **Static-only**: keine inserts, keine updates.
- **Auch Planar Graph Representation** (Sec. 4.2): bounded-pagenumber graphs in O(n) Bits.
- **Pre-Cache-Era-Paper**: Knoten kann zwar 1 Bit-Inspection brauchen, aber Cache-Lines sind nicht modelliert.
- **Foundation-Paper fuer ALL succinct trie work** (FST in P10, CoCo in P04 verwenden LOUDS direkt).

### 4. Plattform-Modellierung-Bezug (Saeule B)
- Saeule B fast vollstaendig ABWESEND. Plattform-Modell ist das Cell-Probe-Modell (Sec. 1.2): "cells can hold only a single bit".
- **Word-Size**: NICHT modelliert; Operations sind log n bit-inspections, nicht word-inspections.
- **Indirekter Bezug zu IIsaFeatureSet**: moderne Implementations (P10 SuRF, P04 CoCo) nutzen `popcount` und SIMD um rank/select zu beschleunigen — Jacobson selbst nicht.
- **`IBitVectorIndexingStrategy`** (Saeule B): Concept fuer rank/select-Hilfsstrukturen — z.B. Tarjan-Yao zwei-Level-Tabelle, oder modern: Block-LUT + popcount.

### 5. Verallgemeinerungs-Vorschlaege
- **`ITopologyEncoding`** (zwingend): LOUDS / DFUDS / BP (Balanced Parentheses) sind alle alternative Encodings derselben Trie-Topologie. Concept-Klasse + 3 Sub-Klassen.
- **`IRankSelectPrimitive`** (Saeule B): Concept fuer rank/select-Operationen mit Implementierungsvarianten:
  - `BitVectorRank` (popcount-basiert)
  - `JacobsonTwoLevelDirectory` (klassisch)
  - `PoppyRank` (SuRF-Variante)
- **`ISuccinctVsCompactDistinction`**: Concept-Markierung fuer Space-Asymptotik (succinct = Z+o(Z), compact = O(Z), implicit = Z+O(1)).
- **`ICellProbeModel` vs. `IWordProbeModel`** (Saeule B): zwei alternative Plattform-Modelle. Saeule B sollte beide kennen.
- **`IInformationTheoreticLowerBound`** als Optimality-Marker fuer Encoding-Strategien.

### 6. Lueckenhinweise
- **Concept fuer Asymptotic Space Optimality** fehlt komplett in Saeule A.
- **`ITopologyEncoding`** als orthogonal-zu-Layout Concept fehlt.
- **`IRankSelectPrimitive`** als Saeule-B-Bestandteil fehlt — alle modernen succinct tries setzen darauf auf.
- **Static vs. Dynamic** als Concept-Dimension nochmal bestaetigt.
- **Concept fuer "Implicit Addressing" via Position-in-Bitstring** fehlt: koennte `IPositionalAddressing` werden.

---

## P10 SuRF (Zhang/Lim/Leis/Andersen et al. 2018)

PDF-Quelle: SIGMOD 2018, "SuRF: Practical Range Query Filtering with Fast Succinct Tries".

### 1. Cache-Strategien
- **LOUDS-DS Hybrid Encoding** (Sec. 2, Fig. 2):
  - **LOUDS-Dense**: obere Levels (wenige Knoten, viele Accesses, "warm") als Bitmap mit drei Bitmaps der Groesse 256 (D-Labels, D-HasChild, D-IsPrefixKey). Schneller Zugriff via array lookup + 1 rank.
  - **LOUDS-Sparse**: untere Levels (viele Knoten, wenige Accesses, "cold") als label-byte-Sequence (S-Labels, S-HasChild, S-LOUDS). Kompakter (8n + 2n Bits).
- **Cutoff-Level R = 64** (Sec. 2.4): Dense-Sparse-Uebergang tunable als size ratio. Default verschiebt mehr Knoten in Sparse fuer space efficiency.
- **Block-basierte rank/select-LUT** (Sec. 2.6, Fig. 3): rank-Block-Size B=64 fuer Dense (1 popcount pro rank), B=512 fuer Sparse (so dass Block in 1 Cache-Line passt, 6.25% Overhead).
- **Per-Level-Cursors fuer Range Queries** (Sec. 2.4): Iterator haelt Cursor pro Level, vermeidet teure rank/select-Calls fuer move-to-parent/move-to-child. Cache-friendly weil sequenziell.
- **Prefetching** (Sec. 2.6, Fig. 7 +prefetching-Optimierung): explizit prefetch der noch nicht zugegriffenen bit/byte-sequences in LOUDS-DS — die Sequences haben positional correspondence, also Prefetch des Next-Sequences sobald die erste Position bekannt ist.
- **128-Bit SIMD Label Search** (Sec. 2.6): Label-Search in Sparse mit `_mm_set1_epi8` + `_mm_cmpeq_epi8` + `_mm_movemask_epi8`. >90% der Knoten haben <8 Labels → 1 SIMD-Check reicht.
- **Konkretisierungs-Kandidat**:
  - `HotColdLayerEncodingStrategy` (Cache-Strategie: getrennte Encodings fuer hot upper levels und cold lower levels).
  - `BlockOrientedRankSelectStrategy` (Cache-Strategie: Block-Size auf Cache-Line abgestimmt).
  - `PositionalCorrespondencePrefetchStrategy` (Cache-Strategie: nutzt Layout-Korrelation zum proaktiven Prefetch).

### 2. Algorithmus-Strategien
- **ExactKeySearch / LowerBound / MoveToNext**: drei Basis-Operations (Sec. 2.4).
- **lookup-Algorithmus** mit Suffix-Vergleich (Sec. 3.5): nach Trie-Traversal Vergleich mit gespeichertem Suffix `k_s` → Filter mit one-sided error (no false negatives).
- **Truncated Trie + Suffix Encoding** (Sec. 3): vier Varianten:
  - **SuRF-Base**: Praefix bis zur Eindeutigkeit + 1 byte.
  - **SuRF-Hash**: zusaetzliche Hash-Bits H(K)[0..n-1] pro Leaf — reduziert FPR nur fuer point queries.
  - **SuRF-Real**: zusaetzliche reale Key-Bits — reduziert FPR fuer point UND range queries (preserves order).
  - **SuRF-Mixed**: Kombination — full tuning spectrum.
- **Range-Query-Algorithmus** (Sec. 5): scan-friendly via per-level cursors; nutzt FST's order-preserving Eigenschaft.
- **Konkretisierungs-Kandidat**:
  - `OneSidedErrorFilterStrategy` (`ISearchPageStrategy` — approximate membership mit garantierten no-false-negatives).
  - `SuffixTruncationStrategy` (`ISearchPagesStrategy` — truncate die unteren Levels, ersetze durch Suffix-Bits).
  - `HashVsRealSuffixEncoding` (`ISearchPagesStrategy` — Trade-Off zwischen Punkt- und Range-FPR).

### 3. Sondermerkmale
- **Approximate Membership statt Exact**: SuRF ist ein RANGE FILTER (vgl. Bloom-Filter), keine exakte Suchstruktur. Nur Filter-Funktion, mit FPR-Tuning.
- **One-Sided Error Garantie**: keine False Negatives (key fehlt → Filter sagt nein); nur False Positives (key fehlt → Filter sagt vielleicht ja).
- **LSM-Tree-Integration mit RocksDB** (Sec. 5): SuRF ersetzt Bloom-Filter, ermoeglicht Range-Filtering.
- **Statisch** (wie CoCo): full rebuild fuer Updates noetig (Sec. 7 Appendix A: hybrid mit dynamic trie + tombstone bit-array).
- **Sampling-Rate S=64 fuer select-LUT** (Sec. 2.6): 9-17% space overhead lokal.
- **Ueberlappende Operationen via Prefetch + Pointer-Tag-Decoding** (vgl. HOT).

### 4. Plattform-Modellierung-Bezug (Saeule B)
- **CPU popcount instruction** (Sec. 2.6): explizit als Hardware-rank-Beschleunigung.
- **128-Bit SSE SIMD** (Sec. 2.6): explizit fuer Label-Search.
- **Cache-Line size 64 Byte** (Sec. 2.6): bestimmt Block-Groesse fuer LOUDS-Sparse rank-LUT (B=512 Bits = 1 Cache-Line).
- **Prefetching als ISA-Feature**: `__builtin_prefetch` o.ae. (impliziert).
- **Intel Xeon E5-2680v2, 4×32 GB RAM** (Sec. 4.1).
- **Disk I/O via SSD** (Sec. 6, Intel 540s 480 GB SSD): explizite `IStorageMedium`-Modellierung. Filter dient zur I/O-Reduktion.
- **OS Page Cache** (Sec. 6): explizit erwaehnt — RocksDB Block Cache + OS Page Cache als 2-stufige Memory-Hierarchy.

### 5. Verallgemeinerungs-Vorschlaege
- **`IFilterStrategy` / `IApproximateMembershipStrategy`**: neues Concept-Dach! Bloom-Filter, SuRF, ARF, Cuckoo-Filter sind alle Sub-Klassen. Saeule A/B kennt noch keine Filter-Konkretisierungen.
- **`IFalsePositiveRateModel`**: Concept fuer FPR-Garantien als first-class Property einer SearchPage.
- **`IHotColdAwareLayoutStrategy`**: das Konzept "obere Levels anders enkodieren als untere" ist generalisierbar — schon in P05 START implizit vorhanden (Multilevel-Knoten oben). → koennte `ILevelDependentLayoutStrategy` werden.
- **`IPositionalCorrespondencePrefetch`**: Concept fuer Prefetch basierend auf Layout-Invarianten.
- **`IStorageMedium`** (Saeule B): SSD/HDD/NVRAM/DRAM als Hierarchy-Konzept; SuRF macht Filter-Logik abhaengig vom storage tier.
- **`IPageCacheModel`** (Saeule B): OS Page Cache und Application Block Cache als 2-stufige Cache-Layer ueber `ICacheLevel`.

### 6. Lueckenhinweise
- **`IFilterStrategy` als Geschwister-Concept zu ISearchPage** fehlt komplett — die Hierarchie geht bisher davon aus, dass eine ISearchPage exakte Treffer liefert.
- **`IStorageMedium` / Persistenz-Hierarchie** fehlt in Saeule B — alle bisherigen Concepts gehen von in-memory aus.
- **`IFalsePositiveRateModel`** als Quality-of-Service Concept fehlt.
- **`ITopologyEncoding`** mit hot/cold-aware Hybrid (LOUDS-Dense + LOUDS-Sparse) → bestaetigt nochmal die Notwendigkeit.
- **`IRankSelectPrimitive`** mit hardware-popcount-Beschleunigung (Saeule B) wird zur kritischen Plattform-Feature.
- **`IIteratorStateCacheStrategy`** (per-level-cursors): wenn Iteratoren komplexen State haben, ist deren Cache-Verhalten ein eigenes Concept.

---

## QUERVERWEISE / SYNTHESE

### Welche Cache-Strategien tauchen in mehreren Papern auf?

| Cache-Strategie | P01 ART | P02 HOT | P04 CoCo | P05 START | P09 LOUDS | P10 SuRF |
|---|---|---|---|---|---|---|
| **Footprint-Reduktion via Adaptive Layout** | Adaptive Nodes | k-constrained Compound | Macro-Node Collapse | Multilevel Nodes | Implicit Bitmap | LOUDS-Dense+Sparse |
| **Single Cache-Line Header** | 16 B Header | Header + Bitmask | (LOUDS) | NodeHeader cached | n/a | n/a |
| **SIMD-parallele Knoten-Suche** | SSE in Node16 | AVX2 + PEXT | n/a | n/a | n/a | SSE in Sparse |
| **Hot/Cold Layer-Trennung** | (implizit via Path Compression) | n/a | n/a | Multilevel oben | n/a | LOUDS-DS Hybrid |
| **Pointer Tagging** | Tagged Pointers (combined slots) | Type-Bits in LSB | n/a | Rewiring-Tag | n/a | (impliziert) |
| **Prefetching expliziert** | n/a | erste 4 Cache-Lines | n/a | n/a | n/a | positional correspondence |
| **Lazy Path Collapsing** | Lazy Expansion + Path Compression | (k-constrained kollabiert) | Subtrie collapsing | (Multilevel kollabiert) | (n/a) | (n/a) |
| **Block-orientierte rank/select-LUT** | n/a | n/a | (in SDSL) | n/a | n/a | B=64/512 |
| **Bit-Manipulation-Hardware** | n/a | PEXT/PDEP | n/a | popcount fuer rank | n/a | popcount |

**Querverweis-Erkenntnis #1:** Drei klar wiederkehrende **ICacheStrategy-Konkretisierungen**:
- **`AdaptiveLayoutStrategy`** (alle 6 Paper): Form-Anpassung an Daten-Population.
- **`LayerDependentEncodingStrategy`** (HOT, START, SuRF): obere Trie-Levels anders behandeln als untere.
- **`SimdAcceleratedLookupStrategy`** (ART, HOT, SuRF): Hardware-parallele Branching-Suche.

**Querverweis-Erkenntnis #2:** **`PointerTagDispatchStrategy`** ist eine wiederkehrende Plattform-Optimierung (ART tagged pointers, HOT type-bits, START rewiring-tags). Sollte als eigene Konkretisierung von `ICacheStrategy` ODER als Plattform-Pattern in Saeule B festgehalten werden.

### Welche Algorithmus-Strategien sind cluster-spezifisch (Trie)?

Trie-spezifisch (in dieser Familie immer wiederkehrend):
- **Span-Selection** (1 Byte ART, dynamisch HOT, lokal CoCo, multi-Level START, 1 Bit LOUDS, byte SuRF): Ein zentraler Parameter, der pro Trie-Familie variiert.
- **Path Compression / Lazy Expansion**: in 4/6 Papern (ART, HOT implizit, CoCo via Macro-Node, START Multilevel = ext. Path Compression).
- **Branching via SIMD-Vergleich**: in 3/6 Papern (ART, HOT, SuRF).
- **Topology Encoding via LOUDS / DFUDS / BP**: in 3/6 Papern (LOUDS, CoCo, SuRF) — alle succinct.
- **Suffix Truncation** (nur SuRF): trie-spezifisch wegen Patricia-Eigenschaft.
- **k-constrained Subtree Partitioning** (nur HOT): trie-spezifisch.
- **Macro-Node-Collapsing mit Encoding-Pool** (nur CoCo): trie-spezifisch wegen Subtrie-Reduktion.

### Welche Verallgemeinerungs-Vorschlaege staerken sich gegenseitig?

**Synthese-Block 1: Topologie als orthogonal zu Layout**
P04 CoCo, P09 Jacobson, P10 SuRF zeigen alle: die TOPOLOGIE-REPRAESENTATION (LOUDS / DFUDS / BP / Pointer / Bit-Array) ist ein eigenes Concept, orthogonal zur Knoten-Layout-Variante (Node4/16/48/256, Compound, MacroNode).
- **Empfehlung**: Neue Concept-Klasse **`ITopologyEncoding`** mit Sub-Klassen `LoudsTopology`, `DfudsTopology`, `BpTopology`, `PointerTopology`, `BitArrayTopology`. Eingebettet als Komponente von `ISearchPageStructure`.

**Synthese-Block 2: Layer-dependent Layout**
P02 HOT (Compound oben/unten egal), P05 START (Multilevel oben), P10 SuRF (Dense oben, Sparse unten) zeigen alle: obere Trie-Levels haben anderes Cache-Verhalten als untere.
- **Empfehlung**: Neue Concept-Klasse **`ILayerDependentLayoutStrategy`** als Konkretisierung von `ISearchPagesStrategyPattern`. Jede ISearchPage kennt ihren `cache_temperature` (hot/warm/cold) → Layout-Strategy waehlt entsprechend.

**Synthese-Block 3: Plattform-Probe als IHeuristic-Input**
P05 START zeigt explizit, P02 HOT und P01 ART implizit: das beste Layout haengt von der KONKRETEN Hardware ab. Das Cost-Model muss vermessen, nicht angenommen werden.
- **Empfehlung**: Neue Concept-Klassen in Saeule B:
  - **`IPlatformProbe`** mit Sub-Klassen `ClflushNodeProbe`, `LatencyProbe`, `BranchPredictorProbe`, `SimdThroughputProbe`.
  - **`ILivePlatformModel.acquired_via : IPlatformProbe`** — explizite Provenance.
  - **`IHeuristic` nimmt `ILivePlatformModel` als Parameter**.

**Synthese-Block 4: Filter als orthogonales Search-Pattern**
P10 SuRF passt nicht in die exakte-Suche-Hierarchie. Bloom-Filter, ARF, SuRF sind orthogonal.
- **Empfehlung**: Neue Concept-Familie **`IApproximateMembershipStrategy`** als Geschwister von `ISearchPageStrategy`, mit sub-classes:
  - `BloomFilterStrategy`
  - `SuRFFilterStrategy` (mit FPR-Tuning)
  - `AdaptiveRangeFilterStrategy`
- Eigenschaft **`IFalsePositiveRateModel`** als Quality-Property.

**Synthese-Block 5: Compound-Knoten-Pattern**
P02 HOT, P04 CoCo, P05 START zeigen: ein physischer Knoten kann MEHRERE LOGISCHE Knoten enthalten. Die strenge 1:1-Beziehung zwischen `ISearchPage` und `INode` funktioniert nicht.
- **Empfehlung**: Concept-Klarstellung — `ISearchPage` enthaelt `[N] INode` (1:N). `IFanout` operiert auf der Liste der INodes innerhalb einer ISearchPage. **`ICompositionMode`** als Marker: `OneNodePerPage` (klassisches ART) vs. `MultipleNodesPerPage` (HOT, CoCo, START).

**Synthese-Block 6: Encoding Pool**
P04 CoCo (Pool {EF,PA,BV,DE}), P10 SuRF (LOUDS-Dense/Sparse Pool), P02 HOT (9 Layout-Varianten Pool) zeigen alle Pool-Pattern.
- **Empfehlung**: **`IEncodingPool`** als Concept-Klasse, parametriert mit `IEncodingSelector` (entscheidet pro Knoten). Konkretisierungen: `SuccinctEncodingPool`, `NodeLayoutPool`, `TopologyEncodingPool`.

**Synthese-Block 7: Static vs. Dynamic als Concept-Dimension**
P01 ART, P02 HOT, P05 START sind dynamic; P04 CoCo, P09 LOUDS, P10 SuRF sind static (oder semi-static).
- **Empfehlung**: Concept-Mixin **`IUpdatability`** mit Werten `Static`, `BulkUpdate`, `Incremental`, `Concurrent`.

**Synthese-Block 8: Worst-Case-Space-Garantie**
P01 ART (52 B/Key), P05 START (52 B/Key), P09 Jacobson (2n+o(n)), P04 CoCo (info-theoretic-near).
- **Empfehlung**: **`ISpaceGuarantee`** als Property einer `ISearchPagesStrategyPattern`, mit Sub-Klassen `WorstCaseBoundPerKey`, `AsymptoticInfoTheoreticBound`, `EmpiricalBoundOnly`.

### Konsolidierte Liste neuer Concept-Vorschlaege fuer REV 3 der Hierarchie

**Saeule A Neu/Erweitert:**
1. `ITopologyEncoding` (mit `LoudsTopology`, `DfudsTopology`, `BpTopology`, `PointerTopology`, `BitArrayTopology`)
2. `ILayerDependentLayoutStrategy` (Konkretisierung von `ISearchPagesStrategyPattern`)
3. `IEncodingPool` + `IEncodingSelector`
4. `IApproximateMembershipStrategy` (Geschwister von `ISearchPageStrategy`)
5. `IFilterStrategy` (Dach-Concept fuer Filter, parallel zu ISearchPageStrategy)
6. `IKeyTransformStrategy` / `IKeyNormalizer`
7. `IPathCollapsePolicy`
8. `IFanoutGrowShrinkPolicy`
9. `INodeOverflowResolutionStrategy`
10. `ICompositionMode` (Marker: 1:1 vs. 1:N zwischen ISearchPage und INode)
11. `IUpdatability` (Marker: Static/BulkUpdate/Incremental/Concurrent)
12. `ISpaceGuarantee` (mit `WorstCaseBoundPerKey`, `AsymptoticInfoTheoreticBound`)
13. `IPartialKeyEncoding` (8/16/32-Bit-Varianten)
14. `IBranchDispatchStrategy` (per-Node-Type findChild)
15. `ISpanWidthStrategy` (1 Byte / variable / multi-level)

**Saeule B Neu/Erweitert:**
1. `IRankSelectPrimitive` (mit `BitVectorRank`, `JacobsonTwoLevelDirectory`, `PoppyRank`)
2. `IPlatformProbe` (mit `ClflushNodeProbe`, `LatencyProbe`, `BranchPredictorProbe`, `SimdThroughputProbe`)
3. `IModelAcquisitionStrategy` (wie wird ILivePlatformModel gewonnen?)
4. `IVirtualMemoryStrategy` (Page-Sharing, Rewiring, HugePages)
5. `IBranchPredictorModel` (Misprediction-Cost als Plattform-Kennzahl)
6. `IBitManipulationFeatureGate` (BMI2 PEXT/PDEP, AVX2, popcount mit Fallback)
7. `IStorageMedium` (DRAM/NVRAM/SSD/HDD)
8. `IPageCacheModel` (OS Page Cache + App Block Cache als 2-stufige Layer ueber ICacheLevel)
9. `IConcurrencyProtocol` (ROWEX, Lock-Free, Latch-Free, COW)
10. `IRebuildScheduler` (wann Self-Tuning starten? Time/Change/Manual)
11. `IRebuildCostModel` (Bauzeit-Modell, fehlt bisher)
12. `IWorkloadModel` (Read-Only/Read-Mostly/Write-Heavy/Mixed/Skewed/Range-Heavy)
13. `IFalsePositiveRateModel` (Filter-Quality-Property)
14. `ICellProbeModel` vs. `IWordProbeModel` (zwei alternative Plattform-Modelle)
15. `IPositionalCorrespondencePrefetch` (Prefetch basierend auf Layout-Invarianten)

### OFFEN

- **OFFEN P02 HOT**: das Paper "conjectures" Determinismus-Eigenschaft (gleiche Struktur unabhaengig von Insertion Order), beweist sie aber nicht. → Concept `IInsertionOrderInvariance` ist sinnvoll, aber empirische Stuetze fehlt.
- **OFFEN P04 CoCo**: Construction-Time O(N h^2) wird als "may seem prohibitive" anerkannt; das Cost-Model fuer Bauzeit-vs-Query-Time ist nicht formalisiert.
- **OFFEN P05 START**: Workload-aware Cost-Function ist als zukuenftige Arbeit erwaehnt, nicht implementiert. `IWorkloadModel`-Integration in `ICacheCostModel` ist offen.
- **OFFEN P10 SuRF**: Update-Mechanismus ist nur als Appendix-Skizze (hybrid mit dynamic trie + tombstone) — voll-dynamische Variante existiert nicht.
- **OFFEN allgemein**: Wo genau in der Hierarchie sitzt `IConcurrencyProtocol`? Es ist orthogonal sowohl zu Saeule A als auch B (HOT ROWEX) → moeglicherweise eigene Saeule C noetig.
