# Cluster B - Hybrid + B+-Familie

Dokument: Tiefe Lektuere von 6 Forschungspapern (P03 Masstree, P06 B^2-Tree, P07 Wormhole, P11 CSS-Tree, P12 CSB+-Tree, P13 Hankins/Patel) zur Verallgemeinerung von Cache- und Algorithmus-Strategien unter den Concept-Daechern der korrigierten REV-2-Architektur.

Bezugsarchitektur:
- Saeule A: ICacheStrategy (Visitor: BaseEngineStrategy / CacheEngineStrategy), ISearchPage, ISearchPagesStrategy(Pattern), IFanout, INode, IRootPage
- Saeule B: ICacheLevel/Line/Topology/Residency, ICpuCore, ICoreLayout, IPinningPolicy, IInterconnect, IBusTopology, IMemoryBandwidthModel, ILivePlatformModel, IScheduler, IHeuristic, IIsaFeatureSet, IHardwareExtension

---

## P03 Masstree (Mao, Kohler, Morris - EuroSys 2012)

### 1. Cache-Strategien

- **Cache-line-aware Node-Sizing**: Border- und Interior-Nodes haben Breite 15 (Section 4.2). Vier Cache-Lines (256 Byte) ergeben den hoechsten Durchsatz (Fanout 15) - empirisch verifiziert. Knotengroesse als Funktion `node_bytes = 4 * cache_line_bytes` entspricht einer ICacheStrategy-Variante "MultiLineNodeStrategy" mit Parameter `lines_per_node = 4`.
- **Software-Prefetching aller Knoten-Cache-Lines parallel** (Section 4.2): Vor Verwendung eines Knotens werden ALLE seine Cache-Lines explizit geprefetcht, sodass die DRAM-Latenzen ueberlappen. Dies entspricht einem `PrefetchAllLinesStrategy` (Visitor) auf der ICacheStrategy.
- **Slice-basierte Schluessellage** (Section 4, "8-byte slice"): Schluesselbytes werden in 64-Bit slices verpackt und nativ als Integer verglichen (mit byte-swap, Section 4.2 "improving performance by 13-19%"). Erlaubt 1-Cycle-Vergleich statt strncmp. Dies entspricht einer Cache-Line-Formation-Strategie "IntegerSliceFormation" (formt 8-Byte-Schluessel-Praefixe als nativ vergleichbare Werte in einer Cache-Line).
- **Suffix-Allokation adaptiv** (Section 4.2 "keysuffixes"): Suffixe werden adaptiv inline ODER extern gespeichert. Reduziert Speicher um bis zu 16% und verbessert Performance um 3% bei kurzen Schluesseln. Bezeichnet einen `AdaptiveSuffixPlacement` als Visitor-Variante.
- **Lineare Suche statt Binary** (Section 4.8 "Discussion"): Auf Intel-CPUs ist lineare Suche bis zu 5% schneller als Binary-Search bei Knotengroessen, weil die Locality besser ausgenutzt wird. Dies stellt eine `LinearScanIntraNode` ICacheStrategy bereit, die auf die Plattform reagiert (auf AMD: identische Performance).
- **No-shared-write/Cache-line non-dirtying** (Section 4 + 4.4): Lookups duerfen NIEMALS shared cache lines dirty machen (kein Write zu shared memory), damit Coherence-Traffic vermieden wird. Versionsnummer wird mit `compare_exchange`/atomic-Bitfeld bedient. Dies entspricht einer `NoSharedWriteStrategy` als CacheEngineStrategy-Variante (mit Bezug zu MESI/Coherence).

### 2. Algorithmus-Strategien

- **ISearchPagesStrategyPattern: Trie-of-B+Trees-Layering** (Section 4.1, "Layer 0/Layer 1"): Eine Masstree besteht aus einer trie-aehnlichen Verkettung von B+-Baeumen, jeder Layer indexiert genau 8 Bytes (eine slice). Layer-Kinder werden via `next_layer`-Pointer aus Border-Nodes verlinkt. Dies definiert einen `SliceLayeredTrieB+Pattern` als ISearchPagesStrategyPattern (multi-level pattern).
- **ISearchPagesStrategy: B+Tree-pro-Layer** (Section 4): Innerhalb jedes Layers ist die Strategie ein B+-Baum (sortierte Border-Nodes mit Doppelliste). Multiple ISearchPageStrategy-Instanzen pro Pattern, jeweils ein B+-Baum-Lookup mit slice-Vergleichen.
- **ISearchPageStrategy: Permutation-Field-Insertion** (Section 4.6.2 "Border inserts"): Das `permutation`-Feld (64 Bit) speichert kompakt 16 4-Bit-Indizes plus nkeys. Inserts veraendern *nur* die Permutation atomar, nicht den physikalischen Schluessel-Slot. Erlaubt lock-freie Reader. Dies ist eine sehr spezifische `AtomicPermutationInsertStrategy`.
- **IHeuristic: Prefix-Layer-Erstellung** (Section 4): Layer wird nur erzeugt, wenn ein Schluessel mit mehr als 8h Bytes Praefix kollidiert (h = Layer-Tiefe). Adaptiv-trie-gleichartig: bei seltenem Konflikt bleiben Schluessel als suffix in border-node.
- **IHeuristic: Sequential-Insert-Detection** (Section 4.3, "common case optimization"): Bei sequenziellem Insert wird der alte Knoten nicht aufgespalten, sondern leer gelassen, neuer Slot eingefuegt. Eine `SequentialInsertHeuristic`.
- **Hand-over-Hand Optimistic Locking** (Section 4.6, 4.6.4 "Splits"): Reader nutzen Versionsnummern (vinsert/vsplit-Counter), Writer halten lokale Spinlocks. Dies ist ein Concurrency-Strategy (siehe Saeule B, IScheduler-naher Aspekt).

### 3. Sondermerkmale

- **Permutation-Field als atomarer Insert-Mechanismus**: Einzigartig in P03. 16 * 4-Bit-Indizes + 4-Bit nkeys in einem 64-Bit-Word - erlaubt einen einzigen aligned Write zur Sichtbarmachung neuer Schluessel ohne Reader-Retry.
- **stableversion / lock / unlock Bit-Layout** (Figure 3): version-Counter haelt locked, inserting, splitting, deleted, isroot, isborder, vinsert (7 Bit), vsplit (18 Bit) in einem Wort.
- **Layer-h Tree Removal** (Section 4.6.5): Entire layer-h Subtree-Removal mit Epoch-based Reclamation (RCU-Variante).
- **Logging + Checkpointing** (Section 5): Per-Core Log-File, Background-Checkpointing. Eher System-Aspekt, fuer Persistenz.
- **PALM-Konzept als Vergleich**: Section 2 erwaehnt PALM (lock-free B+-Tree mit Batch-SIMD Lookups). Masstree adaptiert NICHT die Batch-Strategie, sondern nutzt singuler-Query-Latency-Optimierung.
- **Storing 8 statt 16 Bytes pro Interior-Slot** (Section 6.2 "+IntCmp"): bewusst 8 Byte slices statt 16-Byte Praefix - Slim-down trotz potenzieller Unbalance.

### 4. Plattform-Modellierung-Bezug

- **ICacheLine = 64 Byte** (impliziert, da 256 Byte Knoten = 4 Cache-Lines).
- **ICpuCore = 16-core AMD Opteron 8431** (Section 6.1), 64 KB I+D L1, 512 KB L2 privat, 6 MB L3 shared per Chip. Section 6.1 nutzt 8 Chips * 6 Cores = 48-Core, 16 davon aktiv.
- **IInterconnect/IMemoryBandwidthModel**: Section 6.5 zeigt Per-Core-Skalierung; DRAM-Stall-Time waechst mit Cores (2050 Cycles bei 1 Core, 2800 bei 16 Cores) - klare Bandbreitenkonstellation. Zeigt **NUMA-Effekte** (Section 6.6): Hard-partitioned Masstree hat 1.5x Throughput auf einer Multi-Socket-Maschine bei uniformer Last. Implikation: ICoreToThreadMap und IPinningPolicy sind plattform-relevant.
- **IIsaFeatureSet**: Byte-Swap-Instruktion fuer little-endian Slice-Vergleich, 4-Bit-Index-Permutation per 64-Bit Single-Atomic-Write (impliziert atomic int64 Native).
- **ILivePlatformModel**: linear vs binary search ist architektur-dependent (Intel: linear schneller, AMD: gleich) - Hinweis auf `IHeuristic` mit Plattform-Sensorik.

### 5. Verallgemeinerungs-Vorschlaege

- **Neue Concept-Klasse `ISliceAccessor`**: Liest k-Byte-Slices eines Schluessels als nativ vergleichbare Integers, parametriert durch slice-Width (8, 16). Ermoeglicht Generalisierung des "IntegerSliceFormation"-Patterns von P03.
- **Neue Concept-Klasse `ITrieLayerStrategy`** (Sub-ISearchPagesStrategyPattern): Praefix-konsumierende Layer mit Eltern-Kind-Relation ueber ein `next_layer_pointer`. Allgemeinere Form fuer P03, P07 und ART.
- **Neue Concept-Klasse `IAtomicSlotIndirection`**: Generalisierung des Permutation-Felds. Reine Indirektion (Slot-Indizes) erlaubt nicht-physikalisches Sortieren, wodurch lock-freie Inserts moeglich sind. Bei B+-Tree und Hashindex anwendbar.
- **Neue Cache-Strategie `ParallelLineFetch`**: Visitor-Variante der ICacheStrategy mit Plattform-Tunable `lines_per_node`. Loest die explizite Prefetch-Phase aus P03 ab. Verallgemeinerbar auf P12/P13.
- **Neue Heuristik `LayerCreationDecision`**: IHeuristic mit Input "Common-Prefix-Length" und Output "create_new_layer". Verbindet P03, P06 (Span-Node-Creation), P07 (Anchor-Splitting).

### 6. Luecken

- Kein **dynamisches Tuning** der Slice-Width (8 Byte fix). Eine `IAdaptiveSliceWidth` Heuristik fehlt.
- **NUMA-Awareness fehlt explizit** (Section 6.6: "may diminish on single-chip machines"). Keine bewusste Partition zwischen NUMA-Knoten.
- **Kein Hardware-Counter Feedback**: ICacheStrategy ist statisch - keine Reaktion auf gemessene cache-miss-rate.
- **OFFEN**: Wechselwirkung mit grossem L3 / Hyperthreading bleibt unklar - keine HT-Effekt-Messung.

---

## P06 B^2-Tree (Schmeisser, Schuele, Leis, Neumann, Kemper - Datenbank Spektrum 22, 2022)

### 1. Cache-Strategien

- **Page-Local Embedded Tree** (Section 3, Fig. 1): Jede 64 KiB B+-Page enthaelt einen sekundaeren *embedded tree* (Decision Nodes + Span Nodes). Dadurch wird eine binaere Suche ueber 64 KiB nicht direkt durchgefuehrt - sondern erst auf einen kleinen Such-Range (32 Eintraege) reduziert. Dies entspricht einer ICacheStrategy "EmbeddedSecondaryIndexStrategy".
- **Cache-Line-Constrained Embedded Tree** (Section 3.5 "Space Requirements"): Embedded Tree benoetigt < 0.5% der 64 KiB Page; Decision Node + Span Node sind je 12-15 Byte; passt in **wenige Cache-Lines** (8-way assoziativer 32 KiB L1, 64-Byte Line). Section 3.5: Section explizit: "embedded structure, excluding span nodes, fits into a couple of cache lines".
- **Range-Array Indirection** (Section 3.1, Fig. 2): `r_i`-Werte verweisen auf Eintraege in der page-internen Indirection-Vektor (Umbra-Konvention). Trennt logischen Tree vom physikalischen Eintrags-Layout. Eine `IndirectionVectorStrategy` (Visitor).
- **Infix-Speicherung im Indirection-Vector** (Section 3.5): Statt nur Praefix, werden Substring-Bytes ("infix") gespeichert, da Praefixe bereits im embedded Tree sind. Reduziert L1D-Misses (Tabelle 2: 38.32 vs 44.63 fuer Random; 45.69 vs 79.58 fuer URL).
- **Span-Nodes fuer gemeinsame Praefixe** (Section 3.1): Speichern den longest-common-prefix einer Page-Sektion - reduziert wiederholte Cache-Line-Loads gleicher Bytes. Eine `SharedPrefixCompressionStrategy`.
- **Fewer L1D-Misses** (Tabelle 2): Random 38.32 vs 44.63 (B+); URL 45.69 vs 79.58; Wikipedia 46.02 vs 61.7. **LLC-Misses ~halbiert**: Random 10.17 vs 20.02 / URL 11.35 vs 28.88 / Wiki 13.84 vs 30.82.

### 2. Algorithmus-Strategien

- **ISearchPagesStrategyPattern: Two-Layer Page-Tree-of-Trees** (Section 1, Section 3): Aussere Struktur identisch zum B+-Baum (Pages mit Separators). Innere Struktur (per Page) ist ein **eigener Tree** (embedded). Dies ist eine `DualLevelTreeOfTrees` als ISearchPagesStrategyPattern - in REV-2 sehr relevant: ein IFanout enthaelt Pages, die wiederum eigene Mini-Search-Trees enthalten.
- **ISearchPageStrategy DECISION-NODE**: Decision-Node operiert auf einem **single byte** (Section 3.1, "single byte at a time"). Aehnlich Patricia-Trie, aber `Bereich-basiert` (Range statt Equality). Eine `ByteRangeDecisionStrategy`.
- **ISearchPageStrategy SPAN-NODE**: Span-Node speichert eine Byte-Sequenz (longest common prefix), `extension`-Konzept aus Patricia-Trie, mit zwei zusaetzlichen `virtual edges` (minimum/maximum) fuer non-equality cases (Section 3.1, Fig. 2). Eine `ExtensionSpanStrategy`.
- **Pro Page: ZWEI verschiedene Strategien gleichzeitig** (Decision + Span). Genau das Beispiel fuer einen ISearchPagesStrategyPattern, der NICHT homogen ist - deshalb explizit als Pattern erforderlich (mehrere ISearchPageStrategy fuer eine Page-Group).
- **Construction-Heuristik** (Section 3.1.1): Rekursive Zerlegung des Page-Inhalts. Findet longest-common-prefix - wenn `>0`, Span-Node; sonst Decision-Node, der den **mittleren Byte-Wert** als Splitter waehlt UND in beide Sub-Ranges weiter zerlegt. Threshold: Subrange darf Mindestgroesse nicht unterschreiten (~32 Entries). Eine sehr klare `IHeuristic` "RecursiveCommonPrefixDecomposition".
- **Optimistic Lock Coupling (OLC)** (Section 3.6): jeder Knoten hat optimistic version. Reader validieren, dass Pointer innerhalb der Page-Boundary sind. Termination Guarantee fuer Inner-Search-Loops trotz interleaved Writers.

### 3. Sondermerkmale

- **Virtual Nodes / Minimum / Maximum Edges** (Section 3.1, Fig. 2 "rounded grayish"): Logisch im Tree, aber nicht physisch gespeichert. Behandeln "Input < span-content" und "Input > span-content" Faelle.
- **Range Array (translation table)** (Section 3.1, Fig. 2): Outputs des embedded Tree (`r_i`) werden auf Positionen `j` im Indirection-Vector gemappt. Loest die "Insert/Delete shifts the embedded tree NOT" Problematik elegant.
- **Skip-Field / LCP-Confirmation** (Section 3.2): `skip` enthaelt die laenge des longest common prefix bei einer search-range; spaetere binary search vergleicht NUR die Suffixe.
- **Space-Bound Proof** (Section 3.5): Mathematischer Beweis per Induktion, dass `b(n) >= x` (ein Pfad-Budget pro Node). Stark formal - relevant fuer Verifikations-Theorie.
- **Key-Insertion-Triggered Rebuild** (Section 3.1.1): Embedded Tree wird bei Page-Split neu konstruiert (nicht inkrementell aktualisiert). Gleicher Ansatz wie CSS-Tree.
- **64 KiB Pages** (Section 4.1): Vorgegeben durch Umbra Buffer Manager (NICHT cache-line-Groesse).

### 4. Plattform-Modellierung-Bezug

- **ICacheLevel + ICacheLine**: Explizite Bezugnahme auf "32 KiB L1, 8-way assoziativ, 64 Byte Line" (AMD/Intel current x86) - Section 3.5.
- **ICpuCore = Intel Core i9 7900X** (Section 4.1).
- **IIsaFeatureSet**: branch-free binary search aus Khuong/Morin (Section 2). Voraussetzung fuer effiziente intra-page Suche < L2 cache.
- **ILivePlatformModel**: Hyperthread-Sensitivity (Section 4.4): "B^2-tree appears to better utilize Hyperthreads". Relative speedup steigt jenseits der physical core count.
- **IBufferManager** (extern): Umbra liefert `pointer swizzling`, Page-Faulting. P06 wird durch Umbra-`buffer manager` getrieben - Page-Boundary ist absoluter Constraint.

### 5. Verallgemeinerungs-Vorschlaege

- **Neue Concept-Klasse `IEmbeddedSearchPage`**: Spezialisierung von ISearchPage, die eine **innere** Mini-Search-Struktur traegt. Allgemeine Form fuer "page-local secondary index" - relevant auch fuer P11/P12 (CSS-Directory IST eine Form davon).
- **`ISearchPagesStrategyPattern` muss heterogene Strategien zulassen**: P06 demonstriert klar, dass innerhalb einer logischen Page-Gruppe mehrere ISearchPageStrategy-Konkretisierungen koexistieren (Decision + Span). REV-2-Architektur sollte Heterogenitaet explizit erlauben.
- **Neue Concept-Klasse `IIndirectionVector`**: Trennung von logischer Sortierordnung (slot-array) und physikalischem Eintrag (key-payload). Verbindet P06 mit klassischen Slot-Pages.
- **Neue Heuristik `RangeDecomposition`**: Threshold-basierte Zerlegung (32 Eintraege per Section 3.5). Generalisierbar auf P11, P12.
- **Neue Cache-Strategie `LCP-Compression-Page`**: Span-Node-Konzept als Cache-Strategie - Prefix-Bytes werden NIEMALS dupliziert.

### 6. Luecken

- **Maximum Span-Length von 8 Bytes** (in Masstree-Vergleich Section 2 erwaehnt) - hier nicht explizit, aber `length` des Span-Node ist by design klein.
- **Kein adaptives Page-Sizing**: 64 KiB ist fest durch Umbra. Fuer pure-in-memory-Use-Cases waere Grain Tuning eine Option.
- **Concurrent Reconstruction**: Tree-Rebuild bei Split ist nicht-trivial unter konkurrentem Zugriff. OFFEN, ob das skaliert.
- **OFFEN**: Implementierung des "binary search" innerhalb der Sub-Range nicht detailliert (Khuong/Morin oder klassisch?).
- **Keine SIMD-Nutzung**: Bytewise comparison koennte SIMD-vektorisiert werden, wird nicht erwaehnt.

---

## P07 Wormhole (Wu, Ni, Jiang - EuroSys 2019)

### 1. Cache-Strategien

- **Triple-Layer Multi-Strategy Cache-Konfiguration** (Section 2): Hash-Table (MetaTrieHT) + Trie-Struktur (MetaTrie) + LeafList (B+-aehnlich). Drei Strategien mit unterschiedlichen Cache-Profilen werden orchestriert. Dies ist eine `MultiLayerCacheStrategy` als komposites ICacheStrategy.
- **64-Byte Hash Slot ("hash slot")** (Section 3.1, Fig. 6): 8 Praefixe in einem Cache-Line-grossen Array (16-bit Tag + 48-bit Pointer). Reduziert avg key-comparisons auf ~1 pro Lookup. Eine `CacheLineHashSlot`-Strategie.
- **Tag-Matching mit speculative DirectPos** (Section 3.1): 16-bit CRC32-Tag vorab; nur bei Tag-Match wird der full Key geprueft. Speculative Position: bei uniform Hash kann der Lookup direkt an Position `T*k/Tmax` starten - 1-3 Tag-Vergleiche statt 6-7. Eine `SpeculativeHashedAccess`-Strategie.
- **Incremental Hashing** (Section 3.1): Bei common-prefix-Suche wird CRC32-Hash inkrementell erweitert (CRC32c-Eigenschaft). Spart CPU.
- **Cache-Line-aligned trie node** (Fig. 6): 64 Byte fuer trie-node = 8 Byte left/right-most leaf + 8 Byte node-key + 32 Byte bitmap + 16 Byte pad/unused.
- **Sort-By-Tag Leaf-Layout** (Section 3.2, Fig. 7): Leaf-Node hat Tag-Array + Key-Array, **Tag-Array ist sortiert**, Key-Array nicht zwingend. Erspart full-key-comparison. `SortedTagArrayStrategy`.
- **Fat Leaf Node** (Section 3.3, Fig. 8): Leafs duerfen ueber MaxSize wachsen, wenn Anchor-Bildung wegen Praefix-Konflikten fehlschlaegt. Eine `OverflowLeafStrategy` (Heuristik-getriggert).

### 2. Algorithmus-Strategien

- **ISearchPagesStrategyPattern: Triple-Index** (Section 2.4, Fig. 5): Drei verschiedene Strategien (Hash + Trie + LinkedList) werden vom EINEN logical lookup orchestriert. Genauer:
  - Phase 1: MetaTrieHT-Lookup via Hash auf Anchor-Praefix (O(log L) durch Binary Search auf Praefix-Laengen, Algorithm 1)
  - Phase 2: Walk-down ueber MetaTrie (oder LeafList-Sibling-Walk)
  - Phase 3: pointSearchLeaf via Tag/Hash innerhalb des Leaf-Nodes
- **ISearchPageStrategy: Anchor-Key Mechanism** (Section 2.2): Jeder Leaf-Node hat einen `anchor-key` (kein realer Key, dient als Borderline). Anchor erfuellt Ordering-Condition + **Prefix-Condition** (kein Anchor darf Praefix eines anderen sein). Eine `AnchorKeyStrategy` mit zwei expliziten Constraints.
- **ISearchPageStrategy: Doubly-Linked LeafList** (Section 2.1, Fig. 1, 3): Leaves sind doppelt verkettet (klassisch B+); Range Scan = Linear Walk. Das ist die `LinkedLeafSequenceStrategy` (gleich wie B+/Masstree).
- **IHeuristic: Anchor-Length Minimization** (Section 2.2): Anchor wird so kurz wie moeglich gehalten (kuerzeste eindeutige Borderline). Reduziert MetaTrie-Tiefe. Eine `MinimumDistinguishingPrefix` Heuristik.
- **IHeuristic: Smart-Split** (Section 3.3): "Optionale" Heuristik - intelligenter Split-Punkt im Leaf, um Anchor-Laenge minimal zu halten. Eine offene `SplitPointSelectionHeuristic`.

### 3. Sondermerkmale

- **Search Cost O(log L) statt O(log N)**: Schluesselasymptotik. L = Schluessellaenge, N = Anzahl Schluessel. Praktisch O(1) bei beschraenkter Schluessellaenge (~1000 Byte).
- **MetaTrieHT vs MetaTrie**: Dual-Datastruktur - die HT ist der Performance-Pfad, der echte MetaTrie wird nur fuer Walk-Down nach LPM verwendet.
- **QSBR RCU + RW-Lock + MutEx fuer 3 Operation-Klassen** (Section 2.5):
  - Klasse 1 (Lookup): nur RCU
  - Klasse 2 (single-leaf insert/del): RW-Lock auf Leaf
  - Klasse 3 (split/merge): MutEx auf MetaTrieHT + leaf locks
  - Dual-Hash-Tables (T1/T2) fuer copy-on-write des MetaTrieHT.
- **Version-Number per LeafNode + per MetaTrieHT** (Section 2.5): Lookups detektieren stale state und retry.
- **Wormhole-unsafe**: Single-writer Optimierung erreicht 21.2 MOps - 7.8% schneller als safe.
- **anchor-key MUST NOT BE PREFIX of another anchor**: harte Bedingung. Notwendig fuer Hash-basierte LPM ohne Ambiguity. Loesung mit `\bot`-Suffix oder Fat-Node.

### 4. Plattform-Modellierung-Bezug

- **ICacheLine = 64 Byte explizit** (Section 3.1): "8 prefixes in an array of a cache-line size (64 bytes)".
- **ICacheLevel**: 16-core Intel Xeon E5-2697A v4 / 40 MB LLC (Section 4) - Hyperthreading **disabled** for measurement.
- **IInterconnect**: 100 Gb/s Infiniband fuer networked test (Section 4.1) - networking can become bottleneck.
- **IIsaFeatureSet**: CRC32c HW-Instruction wird benutzt; lower 16 Bit als Tag. Implies SSE 4.2.
- **IPinningPolicy / NUMA**: "We use one NUMA node to run the experiments" - explizit NUMA-Sensitiv.
- **Direct Speculative Position** (Section 3.1, Footnote 3): "On x86-64 only the low-order 48 bits are used in virtual memory address" - direkter Bezug zur Plattform.

### 5. Verallgemeinerungs-Vorschlaege

- **Neue Concept-Klasse `IMultiStrategySearchPage`**: Ein ISearchPage, das intern verschiedene ISearchPageStrategies fuer **Sub-Phasen** des Lookups verwendet. P07 ist Paradebeispiel: Hash fuer Anchor-LPM, Trie-Walk-Down, dann Leaf-Tag-Match.
- **Neue Concept-Klasse `IAnchorKey`**: Spezielle `borderline key` mit Constraints (Ordering + Prefix-Condition). Generalisiert das "synthetisch erzeugte Splitter-Key"-Konzept und kann auf P03 (border node lowkey/highkey), P12 (segment splitter) angewendet werden.
- **Neue ICacheStrategy `TaggedHashSlotStrategy`**: Cache-Line als Hash-Bucket mit Tag-Filtering. Generalisierbar zu jeder hash-basierten Sub-Struktur.
- **Neue Heuristik `LongestPrefixMatchByLength`**: Binary search auf Praefix-Laengen statt Trie-Walk. Aus IP-Routing (Waldvogel) - hier auf KV-Stores adaptiert. Sehr generisch.
- **`ISearchPagesStrategyPattern` muss DIFFERENT TREE-FAMILY-Strategien orchestrieren**: P07 zeigt, dass Hash + Trie + B+ KOMBINIERT werden. ISearchPagesStrategyPattern ist genau das Pattern dafuer.

### 6. Luecken

- **Anchor-Konstruktion ist konservativ**: Section 3.3 erwaehnt "smart split" als future work. Aktuell potenziell zu lange Anchors.
- **Range-Operations sind klassisch O(L) + linear scan**: keine besondere Optimierung.
- **OFFEN**: Wechselwirkung mit fat-Leaf-Faellen bei realen Workloads - Section 3.3: "we believe it has virtually no impact on real systems" ist ungetestet.
- **Insertion-Throughput** (Fig. 15): Wormhole verliert teilweise gegen Skip-List - schwere Insertions belasten MetaTrieHT-Updates stark.
- **Kein explizites NUMA-Awareness**: One-NUMA-Node-Restriction.

---

## P11 CSS-Tree (Rao, Ross - VLDB 1999)

### 1. Cache-Strategien

- **Cache-Line-Sized Node** (Section 4.1, Section 7): "We may have a node fit in a cache line, then all local searching within a node happens with at most one cache miss". Das definitive `CacheLineSizedNodeStrategy`.
- **Pointer-Elimination** (Section 4.1): Child-Pointer werden NICHT explizit gespeichert. Berechnet via Arithmetik (`b(m+1)+1` bis `b(m+1)+(m+1)` fuer Children of Node b). Spart die Haelfte der Cache-Line. Eine `PointerEliminationStrategy`.
- **Embedded Directory above Sorted Array** (Section 1, Section 4.1, Fig. 3): CSS-Tree ist eine Verzeichnisstruktur ueber einem **bereits sortierten Array**. Tree-Knoten halten nur Schluessel, keine Pointer; Leaves werden durch Offset-Berechnung in das Array gefunden. `DirectoryOverSortedArrayStrategy`.
- **Hard-coded if-else (Code Specialization)** (Section 6 "Implementation Details"): Loops aufgerollt, Branchings als if-else hardcoded. Ist eine Code-Generierung-Variante, in der `IHeuristic` die Knotengroesse vorgibt und der Compiler-Output spezialisiert wird. Als `SpecializedCodeGenStrategy`.
- **Unrolled Search per Node** (Section 4.2 "Level CSS-Trees"): Hardcoded binary search innerhalb des Knotens. Bei m=2^t Eintraegen: alle Branches gleich tief. Spart Loop-Overhead.

### 2. Algorithmus-Strategien

- **ISearchPagesStrategy: Full CSS** (Section 4.1): m+1-aerer Full-Tree mit alternierender natuerlicher Schluesselordnung im Speicher (kompliziert wegen sorted-array-merge mit tree-order).
- **ISearchPagesStrategy: Level CSS** (Section 4.2): m-aerer Tree, nutzt nur m-1 Slots als Splitter. Branching factor exact m, einfacheres Indizierungsschema. Vorteil: log_m N statt log_{m+1} N Cache-Misses fuer Cross-Level-Bewegung.
- **ISearchPageStrategy: Binary search within node** (hardcoded). Eine `HardcodedBinarySearchStrategy`.
- **IHeuristic: Node Size = Cache Line Size** (Section 7, Fig. 7): Empfehlung 64 Byte (= 16 Integer-Schluessel pro Knoten auf der ULTRA-SPARC II). Die definitive `IHeuristic` "MatchCacheLineSize".
- **Heuristik: Build from sorted array level-by-level** (Section 4.1 "Building a Full CSS-Tree"): Level-Top-Down-Konstruktion mit max-key-promotion (linkester Subtree-rightmost-leaf).

### 3. Sondermerkmale

- **STATIC structure - rebuilt von scratch** (Section 4.1, Section 6): Periodisch rebuild moeglich (25M Keys < 1 Sekunde). Inkrementelle Updates NICHT unterstuetzt.
- **OLAP-Fokus** (Section 1 "decision-support context"): Entwurfs-Annahme: read-only / batch-update.
- **Two-Part Leaf Layout** (Section 4.1, Fig. 3): Leaf nodes split in zwei Teile (rechte Haelfte, dann linke Haelfte). Fuer Konsistenz mit sorted-array-Layout.
- **OLAP "Domain"-Konzept**: Section 2 erwaehnt `domain values` mit Domain-IDs (compressed integers). Erlaubt Indexierung mit `key_size = sizeof(int)`.
- **Space cost: 0 (fuer Pointer-frei)**: Section 5, Table 2: `nK^2/sc` (sehr klein).
- **Compared with Hash Index**: 1/3 der Zeit von CSS, aber 20x mehr Speicher (Section 7). Trade-off explizit.

### 4. Plattform-Modellierung-Bezug

- **ICacheLine: 32 Byte Sun Ultra Sparc II / 32 Byte Pentium II** (Section 6).
- **ICacheLevel**: 16k L1 1-way Sun, 16k L1 4-way Pentium - WICHTIG: associativity beruehrt Conflict-Misses.
- **IBusTopology / IMemoryBandwidthModel**: 350 MB/s memory bandwidth (Section 6, Footnote 3).
- **ILivePlatformModel**: cache simulator zur Validierung (Section 6 "+ifdef SIMULATOR").
- **IIsaFeatureSet**: logical shifts statt Multiplikation/Division (m = 2^t). Compiler tuning explizit.

### 5. Verallgemeinerungs-Vorschlaege

- **Neue Concept-Klasse `IPointerlessNode`**: Generalisierung der Pointer-Elimination. Anwendbar auf P12 (CSB+ ist halb-pointerless) und auf array-basierte Heaps.
- **Neue Concept-Klasse `IDirectoryStructure`**: Tree-Index ueber externen sorted-array. Generalisierung des "tree as directory" Konzepts. Verbindung zu Heap-Strukturen.
- **`IHeuristic: SizeFromCacheLine(width)`**: bereits implizit; sollte als parametrisiertes IHeuristic erfasst werden.
- **`ICacheStrategy: ArithmeticChildAddressing`**: Visitor, der child-positions per arithmetic statt pointer-deref findet.

### 6. Luecken

- **Keine Updates** - eine fundamentale Einschraenkung. Erst CSB+ loest das.
- **Cache Line Conflict Misses** sind nicht modelliert (Section 5 "first-order approximation").
- **Branch Prediction & TLB Misses fehlen** - werden erst von P13 (Hankins/Patel) eingebracht.
- **OFFEN**: Multicore/Concurrency completely outside scope.

---

## P12 CSB+-Tree (Rao, Ross - SIGMOD 2000)

### 1. Cache-Strategien

- **Partial Pointer Elimination** (Section 3): Speichert nur EINEN Pointer (`firstChild`) pro Node statt aller Children. Andere Children ueber Offset-Arithmetik. Kombiniert CSS-Vorteil mit Update-Faehigkeit. Eine `PartialPointerEliminationStrategy`.
- **Node Group: Contiguous Sibling Storage** (Section 3.1, Fig. 2): Alle Children eines Nodes liegen contiguous im Speicher als `node group`. Die `firstChild`-Pointer + Offset reichen.
- **Cache-Line-Sized Node** (Section 5 "Implementation Details"): "Choosing the cache line size to be the node size is close to optimal for B+-Trees" (zitiert RR99). 64 Byte (Sun) bzw 32 Byte (Pentium).
- **Code Expansion (unfolding) per Knoten-Suche** (Section 3.1.2): 3 Varianten (basic, uniform, variable). `Uniform` performant am besten - hardcoded binary search tree mit if-then-else, padded mit max-keys.
- **Segment-Layout fuer Split-Cost-Reduction** (Section 3.2, Fig. 4): Node-Group in Segmente aufteilen; Split kopiert nur ein Segment (ca 2KB statt 4KB bei 2 Segmenten). Eine `SegmentedNodeGroupStrategy`.
- **Full CSB+ mit pre-allocated Space** (Section 3.3): Volles Node-Group reserviert; Insert-Splits brauchen keine Reallokation. Spart cache-write-misses (write-allocate-Cost).

### 2. Algorithmus-Strategien

- **ISearchPagesStrategy: B+-Tree mit firstChild-Pointer + arithmetisches Adressing**.
- **ISearchPagesStrategy: Segmented CSB+** mit kleineren Node-Groups, mehrere `firstChild`-Pointer (einer pro Segment).
- **ISearchPagesStrategy: Full CSB+** (pre-allocated): wie segmented CSB+, aber Group voll reserviert.
- **ISearchPageStrategy: Hardcoded Binary Search** (uniform variant). Besonders schnell weil branch-free predicted.
- **IHeuristic: Branch Factor Selection** (Section 3.1): m = (cache_line_size - sizeof(firstChild) - sizeof(nKeys))/sizeof(key). Bei 64-Byte Line + 4-Byte Keys: 14 Keys pro CSB+-Node (statt 7 bei B+).
- **IHeuristic: Segmented vs Full** (Section 4 Table 4): Trade-off Search/Update/Space. Auswahl-Strategie: Wenn Space-bound + many Updates: Segmented; Wenn Space-egal + many Updates: Full.

### 3. Sondermerkmale

- **First-Child-Pointer + Arithmetic**: Ein einziger Pointer + Index = Adresse. Knoten-Group muss contiguous sein.
- **2-Segment vs 3-Segment Splits**: Bei 2 Segmenten: kopiert ~2KB pro Split. Bei 3 Segmenten: kopiert ~1.34KB. Aber: Segmented braucht "additional comparisons" zur Segment-Wahl.
- **Bulk Load Level-by-Level**: Section 3.1.1: erst alle Leaves anlegen, dann Level fuer Level Eltern bauen. Spaeter Re-used von P11.
- **Concurrency NOT addressed** (Section 2.2 "we don't address concurrency control"): wird auf future work verschoben.
- **Insertion penalty**: Section 5: "B+-Trees only need to create a new node ... CSB+-Trees have to allocate a new node group". Pre-allocation in Full CSB+ loest das.
- **Lazy Deletion** (Section 3.1, "lazy"): Bei Delete wird Eintrag nur markiert, kein 50% occupancy enforcement. P12 nimmt damit Sun's CC + GNU gcc compiler-Praktik auf.

### 4. Plattform-Modellierung-Bezug

- **ICacheLine: 32-128 Byte Range** (Section 2 "32 to 128 bytes"); experimentell auf 64 Byte gesetzt.
- **ICacheLevel**: 2-Level Cache (L1, L2) explizit Section 2 modelliert.
- **IIsaFeatureSet**: GCC `Label as Values` (`Pro99`) fuer indirect jumps in `variable` Code-Variant.
- **ICpuCore**: Sun Ultra Sparc II 296 MHz / Pentium II 333 MHz.
- **ILivePlatformModel**: Cache misses durch `perfmon` direkt gemessen (Section 5 "perfmon Tool").

### 5. Verallgemeinerungs-Vorschlaege

- **Neue Concept-Klasse `INodeGroup`**: Contiguous-storage-Block fuer Children. Generalisiert "first-child-pointer" Konzept.
- **Neue Concept-Klasse `ISegmentedNodeGroup`**: Variante mit mehreren Segmenten und mehreren first-child-pointern. Trade-off klar parametrierbar (Anzahl Segmente).
- **`IHeuristic: SegmentationPolicy`**: Anzahl Segmente = function(workload, space_budget).
- **`ICacheStrategy: PreAllocatedFullGroup`**: Visitor, der Splits ohne Allocation ermoeglicht.
- **`IHeuristic: HardcodedSearchVariant`**: 3-Way-Choice (basic/uniform/variable). Selektion via Compiler-Capability + Workload-Prediction.

### 6. Luecken

- **Concurrency Control fehlt** (explizit). Erst spaeter durch andere Arbeiten ergaenzt.
- **Range Queries nicht im Fokus**: Implizit unterstuetzt durch Sibling-Pointer auf Leaf-Level, aber nicht gemessen.
- **Skewed Data nicht behandelt** (P11/P12 verwenden uniform random keys).
- **OFFEN**: Optimal Segment Count fuer realistic mixed workloads.

---

## P13 Hankins/Patel (SIGMOD 2003)

### 1. Cache-Strategien

- **NICHT cache-line-sized: 256-512 Byte** (Section 4.5 "best performance occurs at node sizes greater than 160 bytes"): Empfiehlt Knotengroesse **8-16x cache-line** (Pentium III 32-Byte Line + 512-Byte Node). Eine `LargeNodeMultiCacheLineStrategy`.
- **Trade-off Cache-Misses vs Instructions/TLB-Misses** (Section 3.1): Konvenzionelle Wahl (node = cache line) minimiert nur cache-misses, **ignoriert** Instruction-Count (binary search depth), Branch-Mispredictions, TLB-Misses. Section 3.1.6 zeigt: bei 32-Byte Node sind 60% mehr Branches missed; bei 1696-Byte: 27% schneller!
- **Speculative Memory Access in Binary Search** (Section 3.1.1, Equation 13): Out-of-order Execution loest "missed branches" -> "wasted cache loads". m_spec wird als 1.5 * log_2(l+1) - 0.5 modelliert. Eine Cache-Strategy "AccountForSpeculativeFetch".

### 2. Algorithmus-Strategien

- **ISearchPagesStrategy: B+-Tree mit large nodes** (256-512 Byte oder mehr).
- **IHeuristic: Cost Model fuer Optimal Node Size** (Section 3.1, Equation 1): `t = I*cpi + M*miss_latency + B*pred_penalty + T*tlb_penalty` - eine vollstaendige IHeuristic mit 4 Parameter:
  - I (Instructions)
  - M (Cache Misses)
  - B (Branch Mispredictions)
  - T (TLB Misses)
- **IHeuristic: TLB-Miss-Modeling** (Section 3.1.4, Equation 18): explizit ueber `tlb_cap`, `page_sz` und Levels. P13 ist das ERSTE Paper, das TLB explizit in B+-Tree-Cost einbaut.
- **IHeuristic: Branch-Misprediction-Counting** (Section 3.1.3, Equation 16): B = h + log_2(sigma)/2 - eine Naehrungsformel. Hilfreich fuer ILivePlatformModel.
- **IHeuristic: Cardenas-Formula fuer Cache-Hit-Rate Schaetzung** (Section 3.1, Equation 9): `X_D(lambda, q) = lambda * (1 - (1 - 1/lambda)^q)` fuer steady-state cache occupancy. Generalisierbar fuer ICacheResidency.

### 3. Sondermerkmale

- **Cost Model statt Empirie** (Section 3): Erstes Paper im Cluster, das ANALYTISCH die Knotengroesse herleitet (statt nur experimentell zu messen wie P11/P12).
- **Tree-Height-Tradeoff**: Kleinere Nodes -> tiefere Baeume -> mehr Instructions/Comparisons + mehr TLB-Misses (Section 4.5: 73% fewer TLB-Misses bei 512-Byte Node statt 32-Byte).
- **Zipfian Skew Bonus** (Section 4.7): Bei skewed data (Zipfian theta = 0-1) sind 256-512 Byte Nodes bis zu **1.95x bzw 2x speedup** ueber 32 Byte. Cache wird durch Hot-Range besser genutzt.
- **Optimum bei 512 Byte (Pentium III)**: Validiert sowohl analytisch als auch experimentell mit 17% Speedup ueber 32-Byte Variante.
- **Extra Verifikation auf Sun UltraSPARC-II**: Section 4.2 - Resultate bei 1024-3072 Byte. Konsistent.

### 4. Plattform-Modellierung-Bezug

- **ICacheLevel + ICacheLine + ICacheTopology**: Vollstaendig modelliert (cpi=0.63, lsz=32, miss_latency=75 cycles, page_sz=4096).
- **IPinningPolicy / TLB**: tlb_cap=64, tlb_penalty=75 cycles - ein **vollstaendiges Plattform-Modell** in einer Tabelle (Table 2)!
- **IBusTopology / IMemoryBandwidthModel**: Bus-traffic implizit durch miss_latency (75 cycles).
- **IIsaFeatureSet**: pred_penalty=15 cycles fuer branch misprediction.
- **ILivePlatformModel**: cardenas-formula als steady-state-modell. PAPI library zum Counter-Auslesen (Section 4.2).
- **ICpuCore**: 600 MHz Pentium III, 16 KB L1 4-way, 512 KB L2 4-way, 32-entry i-TLB, 64-entry d-TLB.

### 5. Verallgemeinerungs-Vorschlaege

- **Neue Concept-Klasse `ICostModel`**: Vollstaendige Kostenmodellierung mit Parametern aus IIsaFeatureSet, ICacheTopology, IPinningPolicy. P13 liefert das erste Konkrete Beispiel:
  ```
  cost = instructions * cpi
       + cache_misses * miss_latency
       + branch_mispredicts * pred_penalty
       + tlb_misses * tlb_penalty
  ```
- **Neue IHeuristic-Konkretisierung `OptimalNodeSize`**: Nimmt eine ICostModel + ILivePlatformModel und berechnet die optimale Knotengroesse fuer eine gegebene IFanout/ISearchPage. Wichtig: Verbindet ALLE Saeulen-B-Concepts mit Saeule A.
- **`IHeuristic: TLBAwareSizing`**: TLB-Miss-Penalty in Sizing einbeziehen. Generalisierbar auf alle Page-basierten Strukturen.
- **`IHeuristic: BranchPredictionAware`**: Branch-Mispredict-Cost in intra-node-Search-Wahl einfliessen lassen (z.B. zwischen linear/binary).
- **Concept-Klasse `IPlatformAwareSizingModel`**: ein zusammengesetzter Concept-Type, der die Saeule-B-Hardware-Modelle in eine Auswahl-Heuristik fuer Saeule-A-Strukturen verbindet.

### 6. Luecken

- **Cache Conflict Misses ignoriert** (Section 3.1.1): "we assume a large cache where these effects are not significant".
- **Concurrency-Effekte ignoriert** (Section 3.3 "implications similar to instruction-count").
- **Cardenas-Formula konservativ**: Steady-state-only.
- **Skewed/Adaptive Workload Modeling fehlt**: Nur Zipfian und Uniform getestet.
- **Static Choice**: Kein dynamisches Re-sizing zur Laufzeit.
- **OFFEN**: Out-of-Order-Effects "best effort" modelliert (Eq 13), nicht hardware-spezifisch.

---

## QUERVERWEISE / SYNTHESE

### Cache-Strategien, die mehrfach im Cluster auftauchen

| Cache-Strategie | P03 | P06 | P07 | P11 | P12 | P13 |
|---|---|---|---|---|---|---|
| Cache-Line-Sized Node | -- | (intern) | (slot) | + | + | -- |
| Pointer-Elimination | -- | (Span-Node teil) | (intern) | + | + (partial) | -- |
| Multi-Cache-Line Node | + (4 lines) | + (Page=64KiB) | + | -- | -- | + (8-16 lines) |
| Embedded Secondary Index | -- | + | + (MetaTrieHT) | + (directory) | -- | -- |
| Cache-Line-Aligned Hash Slot | -- | -- | + | -- | -- | -- |
| Software-Prefetch | + | -- | -- | -- | -- | -- |
| Indirection / Permutation | + | + (range array) | -- | -- | -- | -- |
| Hardcoded Search Code | -- | -- | -- | + | + | -- |

**Zentrale Einsichten:**
1. **Cache-Line-Sized Node ist NICHT universell optimal**: P11/P12 bevorzugen es, P03/P07/P13 widerlegen. P13 liefert das analytische Modell fuer "warum groessere Nodes oft besser sind" (TLB, Branch-Mispredict, Instructions).
2. **Multi-Cache-Line Node + Prefetch (P03)** und **Multi-Cache-Line Node mit Cost-Model (P13)** konvergieren auf dasselbe Resultat: 4-16 Cache-Lines pro Knoten optimal.
3. **Pointer-Elimination ist im Cluster ein durchgaengiges Thema** (P11 vollstaendig, P12 teilweise, P03 implizit ueber permutation): es spart Cache-Line-Bandbreite.
4. **Embedded Secondary Index (P06, P07)** ist ein NEUES Pattern dieses Clusters: Ein PRIMAERES Index-Element haelt einen kleineren SEKUNDAEREN Tree-Index, der die intra-page-Suche weiter beschleunigt.

### Algorithmus-Strategien: cluster-spezifisch B+ vs Hybrid

**B+-Familie (P11, P12, P13):**
- Statisch oder semi-statisch (P11 nur batch).
- Klassische balanced B+-Topologie.
- Fokus: Cache-Miss-Reduktion + intra-node-Search-Optimierung.
- IHeuristic: hauptsaechlich `OptimalNodeSize` (P13).

**Hybrid-Familie (P03, P06, P07):**
- DYNAMIC, concurrent (alle drei nutzen optimistic concurrency: Versions, OLC, RCU).
- ZWEI Daten-Strukturen pro Page/Node:
  - P03: Trie-Layer + B+-pro-Layer
  - P06: B+-Page + Embedded Decision/Span Tree
  - P07: B+-LeafList + MetaTrie + MetaTrieHT
- Sehr klar als ISearchPagesStrategyPattern (Plural!) modellierbar - genau das Konstrukt der REV-2-Architektur.

**Cluster-uebergreifende Pattern:**
- **AnchorKey-Konzept** (P07) generalisiert die `border_node lowkey/highkey` (P03) und `Range-Array Boundaries` (P06).
- **Permutation/Indirection** (P03 permutation-Field, P06 range-array) sind dasselbe Pattern fuer "logical order != physical order" - lock-free-friendly.
- **Layer/Page-Local Sub-Tree** ist allen 3 Hybrid-Papern gemeinsam.

### Verallgemeinerungs-Vorschlaege die sich verstaerken

1. **`IEmbeddedSearchPage` als Concept**: Verstaerkt durch P06 + P07 + indirekt P11. Eine ISearchPage, die intern eine sekundaere ISearchPagesStrategy haelt - ist die saubere Abstraktion fuer den "tree of trees" Pattern.

2. **`ITrieLayerStrategy` als Sub-Pattern von ISearchPagesStrategyPattern**: Verstaerkt durch P03 (slice-Layer) und P07 (anchor-Praefix-Layer). Beide Paper nutzen Layer-Konzept zur Schluessel-Konsumierung.

3. **`IIndirectionVector / IAtomicSlotIndirection`**: Verstaerkt durch P03 (permutation), P06 (range array), Umbra-Pages (Indirection-Vector). Eine SAUBERE Trennung von logischer Reihenfolge und physikalischer Speicherung.

4. **`ICostModel` mit Parametern aus Saeule B**: Verstaerkt durch P13 (vollstaendig formuliert). Anderen Papern fehlt die explizite Cost-Modellierung, aber IHeuristic-Wahl ist implizit eine Cost-Modell-Anwendung.

5. **`IHeuristic: OptimalNodeSize(plattform_model)`**: Aus P13 hergeleitet, anwendbar auf P03/P11/P12 als generische Sizing-Decision. Verstaerkt das Saeulen-A/B-Konzept-Bridge.

6. **Heterogene `ISearchPagesStrategyPattern`**: P06 (Decision + Span) und P07 (Hash + Trie + LinkedList) demonstrieren, dass ein Pattern KEINE homogene Sammlung sein muss - REV-2-Architektur sollte das explizit modellieren.

7. **`PrefetchAllLinesStrategy` als Cache-Strategy-Visitor**: Aus P03 - generalisierbar auf alle Multi-Cache-Line-Knoten. Gibt ICacheStrategy + IPrefetchPolicy.

### Cluster-spezifische Luecken (gemeinsame "blind spots")

- **NUMA-Awareness durchgehend schwach**: P03 hat eine kleine Erwaehnung (Section 6.6), P07 vermeidet NUMA durch single-node-Restriction. KEINE Plattform-Modellierung fuer ICoreToThreadMap mit NUMA-Topologie.
- **Hardware-Counter-Feedback fehlt**: Alle Strategien sind STATISCH. Kein Paper implementiert ein `ILivePlatformModel`-getriebenes adaptives Resizing.
- **SIMD wird kaum genutzt** (Cluster B): Nur P03 erwaehnt PALM (das SIMD nutzt), aber adaptiert es nicht. Hybrid + B+-Familie hat hier offensichtliche Optimierungs-Reserven.
- **TLB explizit nur in P13**: Andere Paper ignorieren TLB-Effects. Ein wichtiger Gap, da TLB-Misses bei 64KiB-Pages (P06) kritisch sein koennen.
- **Multi-Tenancy / Cache-Pollution**: Alle Paper nehmen "dedizierten Cache" an. Cardenas-Formula (P13) ist ein Schritt Richtung mehr-Tenancy, aber sehr grob.

---

OFFEN-Markierungen aus den 6 Papern:
- P03: Wechselwirkung mit Hyperthreading nicht gemessen.
- P06: Branch-free binary search Implementierung nicht detailliert.
- P07: smart-split future work; fat-Leaf-Effekte ungetestet.
- P11: Multicore/Concurrency komplett aussen vor.
- P12: Optimal Segment Count for mixed workloads unklar.
- P13: Out-of-Order Effects "best effort" modelliert, hardware-spezifisch ungetestet.
