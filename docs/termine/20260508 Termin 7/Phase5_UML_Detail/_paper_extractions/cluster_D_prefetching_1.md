# Cluster D — Prefetching 1

Tieflektuere von 4 Papern zu Prefetching-Strategien fuer B+-Tree-Indices und allgemeine Cache-Prefetching-Adaption. Architektur-Bezug: ICacheStrategy-Familie, ISearchPageStrategy/ISearchPagesStrategy, ICacheTopology (multi-tier), IHeuristic, ILivePlatformModel.

---

## P20 — B-Trees Are Back: Engineering Fast and Pageable Node Layouts (Mueller/Benson/Leis 2025, SIGMOD)

### Sektion 1: Cache-Strategien (ICacheStrategy-Familie)

**Page-Layout-Strategien (slotted page mit 4 KiB Default):**
- **PrefixTruncationStrategy** (Sec 3.1): Gemeinsamer Praefix aller Keys eines Knotens ist durch die Fences (lower/upper) bestimmt; im Knoten wird Praefix nur einmal gespeichert (`prefixLength` im Header), Suchschluessel ueberspringen Praefix-Bytes beim Vergleich. Spart Speicher 7-64 % je nach Keyset und verbessert Cache-Lokalitaet.
- **HeadsStrategy** (Sec 3.2 — "Poor Man's Normalized Keys"): Erste 4 Bytes jedes Keys werden im Slot-Array kopiert ("head"). Binaersuche vergleicht Heads als Integer (SIMD-faehig) statt memcmp. Reduziert Random-Heap-Zugriffe.
- **HintsStrategy** (Sec 3.3): Fixed-Size-Array von N Heads aus gleichmaessig verteilten Slots; lineare Suche im Hint-Array verschmaelert den Bereich der nachfolgenden Binaersuche → Cache-Misses-Reduktion. Hints werden bei Insert nur an/nach Insert-Punkt aktualisiert (incremental). LeanStore-Erbe (16 Hints, 64 Bytes).
- **FingerprintingLeafStrategy** (Sec 3.4): 1-Byte-Hash jedes Keys im Heap, gespeichert als Fingerprint-Array. Punktsuche per SIMD-Vergleich ueber Fingerprints — Heap-Zugriff nur bei Match. Lazy-Sort: Bei Insert wird Eintrag an Ende des Unsorted-Range angehaengt; Sort erst vor Scan (downside fuer Concurrent-Scan).
- **SemiDenseLeafStrategy (SDL)** (Sec 3.5): Frame-of-Reference-Encoding: Lower Fence definiert non-numeric Praefix; nur die letzten 4 Bytes (numeric part) werden als Big-Endian-Integer interpretiert. Slot-Array indiziert auf Offset, jeder Slot hat 16-bit Pointer auf Heap-Value. Nutzt FoR im B-Tree (akademisch erstmal beschrieben).
- **FullyDenseLeafStrategy (FDL)** (Sec 3.5): Alle Werte gleicher Groesse, Bitmap-Praesenz fuer jeden Slot, Werte direkt im Array (keine Indirection). ~500 Records pro 4 KiB bei 8-Byte-Werten und Dense-Keys.

**Adaptive Cache-Strategie:**
- **AdaptiveLeafSelectorStrategy** (Sec 5): Pro Leaf wird Layout-Typ dynamisch gewaehlt: `Comparison ↔ Fingerprinting ↔ SDL ↔ FDL`. Zwei Mechanismen:
  1. **KeyAdaption**: Layout-Wahl bei Splits/Merges, basierend auf "good/bad heads" (16/64 Threshold) und String-Detektion.
  2. **OperationAdaption**: 1-Byte-Counter pro Leaf, +1 bei Scan (15 % Wahrscheinlichkeit), -1 bei Point-Op (5 % Wahrscheinlichkeit), saturating 0..3. Counter triggert Konversion (Fingerprinting wenn Counter < 2 = Lookup-dominant).

### Sektion 2: Algorithmus-Strategien (ISearchPageStrategy/ISearchPagesStrategy)

- **InNodeBinarySearchStrategy** auf Heads (statt vollem Key-Vergleich) — `HeadsSearchStrategy`.
- **HintNarrowedBinarySearchStrategy** — lineare Suche auf 16 Hints + Binaersuche im narrowierten Bereich.
- **FingerprintingPointLookupStrategy** — SIMD-Hash-Vergleich + selektiver Heap-Zugriff.
- **DenseOffsetLookupStrategy** — direkte Index-Berechnung aus Numeric-Part-Offset (O(1) statt O(log n)).
- **AdaptiveScanStrategy** — Lazy-Sort vor Scan (komplikationsbedingt fuer Concurrent).
- **PartitionedSequentialInsertStrategy** (Sec 4.6): FDLs verwenden alternative Separator-Selection — bei Sortiertem Insert wird "max split point" statt Median verwendet, um eine der zwei neuen Knoten als Dense-Layout-faehig zu erhalten. Wird ueber "boundary node detection" getriggert.

### Sektion 3: Sondermerkmale

- **Slotted-Page-Hyperdesign**: Header (tag/count/heapUsed/heapStart/lower fence/upper fence/upperChild/prefixLength), variable Slot-Array (offset+keyLen+valLen je 16-bit), Heap waechst von oben, Slots von unten — bidirektional in 4 KiB.
- **vmcache-Integration** (Sec 7): Optimistic Lock Coupling, transparentes Paging durch Buffer-Manager-Pointer-Swizzling. Adaptive B-Tree skaliert auf 24 Threads, Out-Of-Memory-Performance bei Buffer-Pool < Datasize.
- **Contention Split** (Sec 7.3): Bei Hot-Pages werden Leaves bei min. 1/30 Sample contention konfliktfrei gesplittet.
- **Dense Leaves akademisch erstmals**: Frame-of-Reference im B-Tree wurde in Literatur erwaehnt (15, 24), aber nie implementiert.
- Fingerprinting basiert auf FPTree (Oukid 2016, persistente Memory).

### Sektion 4: Plattform-Modell-Bezug (Saeule B)

- **ICacheLevel/ICacheLine**: Evaluation auf AMD Ryzen 9 7950X mit `L1=32KiB, L2=1MiB, L3=32MiB`, Frequency-Boost off bei 4.5 GHz.
- **IPageSize**: 4 KiB default (vmcache-bedingt) — bei Out-Of-Memory mit 2 KiB getestet (Contention-Sektion). 16-bit-Offsets in Slots erlauben max. 64 KiB Page.
- **IIsaFeatureSet**: SIMD fuer Fingerprint-Suche (AVX/SSE) und Head-Vergleich. Slot-Alignment-Wahl (10-Byte-Slot vs 12-Byte-padded) wurde mit Throughput-Differenz < 3 % validiert.
- **IInterconnect/IMemoryBandwidthModel**: Implizit ueber Out-Of-Memory-Tests (Samsung 980 PRO 1TB SSD, vmcache pages-out, fio-Vergleich 1080k-Block).

### Sektion 5: Verallgemeinerungs-Vorschlaege

- **AdaptiveLayoutStrategy** als generische Konzept-Klasse: `IAdaptiveCacheStrategy<TPolicy>` mit `KeyAdaptionPolicy` und `OperationAdaptionPolicy` als orthogonale Strategy-Patterns.
- **ICachePageLayout** als Visitor-Pattern: `ComparisonLayout | FingerprintingLayout | SemiDenseLayout | FullyDenseLayout`. Transitionen sind partielle Ordnung (Figure 12: "bad heads/few scans" → Fingerprint, "necessary" → Comparison, "good heads/many scans + dense" → Dense).
- **IHeuristic-Klassen** aus diesem Paper:
  - `HeadQualityHeuristic` (Schwellwert 16/64 fuer eindeutige Heads)
  - `ScanFrequencyCounterHeuristic` (saturating counter, +1/-1 mit fester Wahrscheinlichkeit)
  - `KeyTypeHeuristic` (String-vs-Integer-Detektion via Heads-Eindeutigkeit)
  - `BoundaryNodeHeuristic` (fuer Partitioned-Sequential-Insert in FDL)
- **PageBudgetStrategy**: Trade-off Heads ↔ Hints ↔ Fingerprint ↔ Dense via "Insight 1-6" — abstrahierbar als `ICacheStrategyCostModel`.

### Sektion 6: Luecken

- OFFEN: Konkurrenzfaehige Implementierung der DenseLeaf-Range-Updates (FDL-Insert "throughput-Spikes" bei Page-Splits Figure 13b).
- OFFEN: Fingerprint-Kollisionsrate bei sehr kurzen Integer-Keys (Insight 2 — Integer-Lookups 10 % langsamer wegen Kollisionen).
- OFFEN: Compression-Alternativen (Bingmann TLX, Delta-Compression) wurden nicht integriert; Autoren empfehlen alignement mit ihrer Implementation, ohne quantitativ zu evaluieren.
- OFFEN: Multi-Threaded Fingerprint-Sort-Konsistenz (Sort waehrend Scan benoetigt komplexe Sync).

---

## P21 — Improving Index Performance through Prefetching (Chen/Gibbons/Mowry 2001, SIGMOD)

### Sektion 1: Cache-Strategien (ICacheStrategy-Familie)

- **WideNodePrefetchStrategy** (Sec 2 — "pB+-Tree" / "Prefetching B+-Tree"): Knoten-Breite `w` Cache-Lines ist > 1 (typisch w=8 bei 64-Byte Lines). VOR Binaersuche werden ALLE w Cache-Lines des Knotens parallel geprefetched. Reduziert Tree-Hoehe (Branching-Factor steigt linear mit w), Cache-Miss-Penalty pro Knoten ist `T1 + (w-1)*T_next` ≈ `T1` (wegen `T_next << T1`).
- **JumpPointerArrayPrefetchStrategy** (Sec 3 — "p_e^w B+-Tree" external / "p_i^w B+-Tree" internal): Externes Array von Leaf-Adressen, k Leaves voraus prefetched waehrend Range-Scan. Loest Pointer-Chasing-Problem. Zwei Varianten:
  - **External JumpPointerArray** (Sec 3.2): Chunked-Linked-List mit interleaved Leerschlitzen (fuer effiziente Inserts), Hint-Pointer in Leaf zeigt nur ungefaehr auf Chunk-Position.
  - **Internal JumpPointerArray** (Sec 3.4): Bottom-Non-Leaves dienen als Jump-Pointer-Array (Children = Leaves). Spart Pointer-Overhead, aber Chunk-Groesse ist B+-Tree-strukturbedingt fest.

**Cache-Strategy-Parameter:**
- **Prefetching-Distance `k`** (Sec 3.3): `k = ceil(B/w)`, wobei `B = T1/T_next` (normalized memory bandwidth). Fuer Compaq ES40: B=15, w=8 → k=2 (mit Slack k=3).
- **Chunk-Size `c`** (Sec 3.3): `c = ceil(B/(2m))` Cache-Lines, wobei m Children-Pointer pro Cache-Line. Mindestens c=8 bei B=15, m=8.

### Sektion 2: Algorithmus-Strategien (ISearchPageStrategy/ISearchPagesStrategy)

- **PrefetchedBinarySearchStrategy** (Sec 2.1): VOR der Binaersuche im Knoten alle w Cache-Lines prefetched, Standard-Binaersuche danach.
- **JumpPointerScanStrategy** (Sec 3.3): Startup-Phase prefetched die ersten k Leaves; Steady-State prefetched k Leaves voraus pro Loop-Iteration. Chunk-Boundary-Crossing prefetched naechsten Chunk.
- **HintFollowSearchStrategy** (Sec 3.3): Hint-Pointer im Leaf folgen, dann lokal in Chunk in beiden Richtungen suchen ("not a costly operation").
- **InsertionPathPrefetchStrategy** (Sec 2.1): Bei Insert ist Suchpfad bereits cache-warm; nur neue Knoten bei Splits werden in Gaenze geprefetched.
- **SiblingRedistributionPrefetchStrategy** (Sec 2.1 Deletion): Bei Deletion mit Key-Redistribution wird Geschwister-Knoten geprefetched.

**Optimal Node Width Berechnung (Equation 1):**
```
TotalStallTime = T_next * (log_{wm/(wm-1)}(N/(wm-1)) + 1) * (B + ceil(3w/4) - 1)
```
→ `w_optimal = 8` fuer typische Parameter (B=15, m=8).

### Sektion 3: Sondermerkmale

- **Pointer-Chasing-Problem (Sec 3.1)**: Klassische Problem-Definition (Luk/Mowry 1996/1999): Pointer-basierte Datenstrukturen koennen Cache-Miss-Latenz nicht ueberlappen, da Adresse von n_{i+1} erst nach Fetch von n_i bekannt.
- **Loesungsansaetze**: data-linearization (read-only, contiguous Leaves) ODER history-pointer = jump-pointers.
- **Komplementaer zu CSB+-Tree** (Rao/Ross 1999/2000): pB+-Tree und CSB+-Tree koennen kombiniert werden zu pCSB+-Tree.
- **Speedup-Werte**: Search 1.27-1.55x, Update 1.24-1.52x, Range Scan 6.5-8.7x ueber Standard-B+-Tree.
- **Update-Performance verbessert sich** (gegen intuitive Erwartung): Wider Nodes → seltenere Splits → schnellere Updates.

### Sektion 4: Plattform-Modell-Bezug (Saeule B)

- **ILiveCpuModel**: Compaq ES40 simuliert (1 GHz, 4 insts/cycle, 32 in-flight Loads, 8 outstanding off-chip Cache-Misses pro CPU, Crossbar-Interconnect mit 24 outstanding Cache-Misses).
- **IMemoryBandwidthModel**: `B = T1/T_next = 150/10 = 15` (normalized bandwidth = wieviele Cache-Misses parallel servable).
- **ICacheLevel**:
  - L1 D-Cache: 64 KB 2-way
  - L1 I-Cache: 64 KB 2-way
  - L2: 2 MB direct-mapped
  - Line Size: 64 Bytes
  - L1→L2 Miss Latency: 15 cycles
  - L1→Memory Miss Latency: 150 cycles
  - Main Memory Bandwidth: 1 access / 10 cycles
- **IIsaFeatureSet**: MIPS R10000 (super-skalar dynamisch geschedulter Pipeline), explizite `prefetch`-Instructions (gcc ASM macro). 32 Miss-Handlers fuer Daten, 2 fuer Instructions.
- **IPinningPolicy**: Single-Threaded Evaluation, kein Multi-Core.

### Sektion 5: Verallgemeinerungs-Vorschlaege

- **IPrefetchStrategy** als orthogonales Konzept zu IPageLayout:
  - `WideNodePrefetchStrategy(w_lines)` fuer Search-Pfade (Top-Down)
  - `JumpPointerScanStrategy(k_distance, c_chunk_size)` fuer Range-Scans (Sequential)
- **CacheCostModelHeuristic**: Berechnung von w_optimal und k_optimal aus B (memory bandwidth), m (children per cacheline), N (entries) — direkt in `ICacheTopology`-konsumierende Heuristik.
- **PointerChasingResolutionStrategy** als Tactic-Pattern:
  - `DataLinearizationTactic` (read-only, sequentielle Allocation)
  - `HistoryPointerTactic` (Jump-Pointer-Arrays mit Update-Support)
- **InternalVsExternalArrayChoice**: Architektur-Entscheidung ob Jump-Pointer im Tree (parents-of-leaves) ODER extern (separate Datenstruktur). Trade-off Space vs Update-Flexibility — abstrahierbar als `IJumpPointerStorage` Strategy.
- **JumpPointerArrayMaintenanceStrategy**: Chunked-List mit interleaved Empty-Slots ist ein generelles Pattern (Hint-Pointer akzeptieren imprezise Lookups → "almost free" Updates).

### Sektion 6: Luecken

- OFFEN: Search-Performance bleibt von "full Cache-Miss-Latency pro Tree-Level" limitiert (Sec 5 Discussion). Kein Prefetch von Children/Grandchildren wegen Datenabhaengigkeit (`d` random Children, alle gleich wahrscheinlich).
- OFFEN: Internal-vs-External-Jump-Pointer-Entscheidung haengt stark von w/k-Verhaeltnis ab und Hardware (Disk-Latency vs Memory-Latency).
- OFFEN: Bulkload-Optimierung erwaehnt aber nicht evaluiert (Sec 2.2).
- OFFEN: Konkurrenzkontroll-Aspekte (sibling-Pointers fuer Concurrency haben paralleles Use-Case zu Jump-Pointer-Arrays — koennten unifiziert werden).

---

## P22 — Fractal Prefetching B+-Trees: Optimizing Both Cache and Disk Performance (Chen/Gibbons/Mowry/Valentin 2002, SIGMOD)

### Sektion 1: Cache-Strategien (ICacheStrategy-Familie)

- **FractalPrefetchingStrategy** ("fpB+-Tree"): Selbst-aehnliche "Tree within a Tree"-Struktur: Disk-Page (4-64 KB) enthaelt einen kompletten Cache-optimierten B+-Tree (in-page tree). Kombiniert Disk-I/O-Optimierung (Page-granular) mit Cache-Optimierung (Cache-Line-granular).
- **DiskFirstFractalStrategy** (Sec 3.1): Start mit Disk-optimierten Page-Boundaries, dann in-page Tree mit Cache-optimierten Knoten. In-Page Offsets statt Full-Pointers (2 Bytes statt 4-8 Bytes) — packt mehr Entries pro Knoten.
- **CacheFirstFractalStrategy** (Sec 3.2): Start mit Cache-optimiertem B+-Tree, dann aggressiv Subtrees in Disk-Pages packen. Sibling-Leaves in selbe Page (Range-Scan-Optimierung). Overflow-Pages fuer Leaf-Parents bei Mismatch.
- **MicroIndexingStrategy** (Sec 3 — Lomet): Erstes Key jeder Cache-Line in kleinem Sub-Array, gefolgt von Standard-Binaersuche. Schwaeche: Update-Performance schlecht (gleicher grosser Array bleibt erhalten).
- **JumpPointerArrayForRangeScan** (Sec 2.2 — wiederverwendet aus P21): Disk-Page-granulare Prefetching, Start- UND End-Key vor Range-Scan suchen, dann Leaf-Pages prefetchen ohne overshooting (anders als P21).

**Optimal-Sizing-Strategien:**
- **NodeSizeMismatchProblem** (Sec 3.1, Figure 6): Cache-optimal Node-Size selten ein Teiler der Disk-Page-Size → Overflow oder Underflow im in-page Tree.
- **AdaptiveNodeWidthStrategy** (Sec 3.1.1): In-page Tree erlaubt zwei Knoten-Groessen (eine fuer Leaves, eine fuer Non-Leaves). Optimization-Goal G: maximize page fan-out unter Constraint dass analytical search cost innerhalb 10 % vom Optimum ist.

### Sektion 2: Algorithmus-Strategien (ISearchPageStrategy/ISearchPagesStrategy)

- **TwoGranularitySearchStrategy** (Sec 3.1.2 / 3.2): Search ist conceptually einfach — Standard-B+-Tree-Search durch Disk-Page-Tree, in jedem Page wird Cache-optimierter Sub-Tree durchsucht.
- **TwoGranularityInsertStrategy** (Sec 3.1.2):
  - In-Page Leaf hat Platz: einfache Binary-Search-Insert.
  - Cache-Granularitaet-Split: leaf node innerhalb der Page splitten.
  - Page-Granularitaet-Split: Half der Leaves in neue Page kopieren, Tree rekonstruieren.
- **AggressiveNodePlacementStrategy** (Sec 3.2.1): Non-Leaves der Page werden aggressively in dieselbe Page gepackt (Bitmap-Markierung welche Children in selber Page liegen).
- **OverflowPageStrategy** (Sec 3.2.1): Wenn Aggressive-Placement nicht passt, Overflow-Pages fuer Leaf-Parents allokieren.
- **NonleafSplitStrategy** (Sec 3.2.2, Figure 9): Wenn Nonleaf A gesplittet werden muss und A_2's Children waeren noch in A's Page, dann muss die ganze Page gesplittet werden (Mehrstufige Komplexitaet).
- **DualJumpPointerArrayStrategy** (Sec 3.3): Zwei separate Jump-Pointer-Arrays:
  - Internal Array fuer Cache-Prefetching (zwischen in-page leaf parents)
  - External Array fuer I/O-Prefetching (zwischen Page-IDs aller Leaf-Pages)

### Sektion 3: Sondermerkmale

- **Erste B+-Tree-Variante mit BEIDEN Granularitaeten optimiert** (vor Bender et al. 2000 cache-oblivious B+-Tree war asymptotisch optimal, aber ohne Prefetching).
- **Speedups**: Search 1.1-1.8x, Range-Scan 4.2x (Cache) + 2.5-5x I/O (DB2), Updates 20x.
- **Validierung in industriellem DBMS**: IBM DB2 Universal Database mit Jump-Pointer-Array → 2.5-5x Speedup auf RS/6000, 8 Prozessoren, 80 SSA-Disks.
- **Disk-First vs Cache-First**: Disk-First leicht besser bei Insert/Update (in-page tree behaelt Slot-Layout). Cache-First leicht besser bei Search/Cache-Performance (sibling-leaves in selbe Page).
- **Empfehlung**: In general Disk-First waehlen (geringerer I/O-Overhead). Falls Memory dominant: Cache-First.

### Sektion 4: Plattform-Modell-Bezug (Saeule B)

- **ICacheLevel/ICacheLine**: 64 Byte Lines, 64 KB L1 D/I-Cache, 2 MB L2 direct-mapped, 150 cycle Memory-Latency, 10 cycle pipelined-miss-Latency (gleiche Compaq ES40 Spec wie P21).
- **IPageSize**: 4 KB / 8 KB / 16 KB / 32 KB evaluiert. Optimal-Width-Tabelle (Tabelle 2):
  - 4 KB Page → Disk-First nonleaf 64 B, leaf 384 B / Cache-First node 384 B, fan-out 470
  - 16 KB Page → nonleaf 192 B, leaf 512 B / node 704 B, fan-out 2001
  - 32 KB Page → nonleaf 256 B, leaf 832 B / node 640 B, fan-out 4029
- **IInterconnect**: Multi-Disk SCSI (SGI Origin 200, 12 SCSI Disks Cheetah 4LP, 40 MB/s, 18 ms seek).
- **IIsaFeatureSet**: MIPS R10000 + IBM POWER (DB2-Test), software-gesteuerte Prefetch-Instructions.
- **ILivePlatformModel**: Cross-Granularitaeten — `T1 (Memory-Miss-Latency)` und `T_next (pipelined Miss)` fuer Cache-Modell, plus `Disk Seek Time` und `Page-IO-Throughput` fuer Disk-Modell. Beide Granularitaeten gleichzeitig adressiert.

### Sektion 5: Verallgemeinerungs-Vorschlaege

- **MultiTierCacheStrategy** als generalisierte Concept-Klasse: `ICacheStrategy<TierGranularity[]>` mit getrennten Strategien pro Tier (z. B. `[CacheLine, Page, Disk]`). Speziell relevant fuer **ICacheTopology multi-tier**.
- **IFractalLayoutStrategy<OuterTier, InnerTier>**: Auessere Granularitaet (z. B. Page) enthaelt vollstaendiges inneres Layout (z. B. Cache-optimaler Tree). Rekursiv anwendbar (3+ Tiers).
- **IGranularityMismatchResolver**: Strategien zur Behandlung von Mismatch zwischen optimalen Sizes auf verschiedenen Tiers:
  - `OverflowResolverStrategy` (Cache-First)
  - `OffsetCompressionResolverStrategy` (Disk-First — kuerzere Pointer)
  - `AdaptiveNodeSizeResolverStrategy` (verschiedene Node-Groessen pro Level)
- **IDualJumpPointerArrayStrategy**: Zwei separate Prefetching-Arrays (Cache-Tier vs I/O-Tier) als Pattern fuer multi-tier Range-Scan.
- **IHeuristic-Klassen**:
  - `OptimalWidthHeuristic(TierLatencies, FanOutGoal)` (Equation cost = (L-1)(T1+(w-1)T_next) + T1+(x-1)T_next)
  - `OverflowVsOffloadHeuristic` (Aggressive Placement vs Overflow-Page fuer Leaf-Parents)

### Sektion 6: Luecken

- OFFEN: Cache-First fuer Mature Trees ueber 36 % Space-Overhead — Aggressive-Placement skaliert nicht gut bei vielen Inserts.
- OFFEN: Konkurrenzkontroll bei Page-Splits mit DualJumpPointerArrays nicht behandelt.
- OFFEN: Cache-Oblivious-Alternativen (Bender 2000) nicht direkt verglichen — fpB+-Tree benoetigt explizite Tier-Konfiguration.
- OFFEN: 3+ Tier-Hierarchien (NUMA L1/L2/L3 + DRAM + NVMe + Disk) nicht generalisiert; Paper bleibt bei 2 Tiers (Cache + Disk).
- OFFEN: Compression-Integration (Key-Compression, Bohannon-Style Partial-Keys) nicht evaluiert.

---

## P23 — Data Cache Prefetching With Dynamic Adaptation (Khan 2010, The Computer Journal 54(5))

### Sektion 1: Cache-Strategien (ICacheStrategy-Familie)

- **DynamicAdaptivePrefetchingStrategy** (Sec 2): Compiler instrumentiert Code mit Prefetch-Instructions, die zur **Laufzeit** ueber Template-Specialization angepasst werden. Prefetch-Distance wird **online** berechnet aus echter Loop-Iteration-Latency und Cache-Miss-Latency.
- **CompileTimeTemplateStrategy** (Sec 3.1.3): Generic Template-Code wird mit zwei verschiedenen Offsets kompiliert (z. B. 5 und 7), Diff der Object-Code-Versionen liefert affine Formula `I = O*A + B` (Coefficients A, B), die zur Laufzeit fuer Offset-Modifikation genutzt wird.
- **RuntimeSpecializerStrategy** (Sec 3.2): Template-Specializer modifiziert nur wenige Binary-Instructions zur Laufzeit (typisch 2-5 Instructions pro Variable). Sehr geringer Overhead (1.5-6.5 % laut Figure 8).
- **CostBenefitGatedPrefetchStrategy** (Sec 3.1.2, Equation 3-4): Dynamic Prefetching wird nur aktiviert wenn `sum(L_{1,i}) > R`, d. h. Cache-Miss-Latencies der initialen Iterationen ueberwiegen Runtime-Overhead R = B + sum(M_i) + F (Initialization + Modification + Cache-Flush).

**Distance-Berechnung (Equation 6):**
```
O_r = AvgCacheMissLatency / AvgIterationLatency
```
Powers-of-2 fuer Performance-Counter-Berechnung (Shift-Operations statt Multiplikation).

### Sektion 2: Algorithmus-Strategien (ISearchPageStrategy/IHeuristic)

- **VariableSelectionStrategy** (Sec 3.1.1): Offline-Profiling identifiziert Variablen mit `Sv_i = sum(L_{k,i})` (kumulative Latency-Summe) als Prefetch-Kandidaten. Variablen mit `L_{k,j} = 0` (bereits in Cache) werden eliminiert: `V = V - {v_j | L_{k,j} = 0}`.
- **AffineOffsetAdaptationStrategy** (Sec 3.2, Equation 7-10): Pro Instruktion `j`: `I_{rj} = O_r * A_j + B_j` zur Laufzeit. Fuer p Instructions: p Affine-Formeln muessen evaluiert werden.
- **BitwiseInstructionModificationStrategy** (Sec 4): Itanium-II spezifisch — Instruction-Bundles werden via Bitwise-Operations modifiziert (Cache-Coherence-Aktivitaeten danach).
- **DelinquentLoadDetectionStrategy** (Sec 6 Related Work): Trident/ADORE-aehnlicher Ansatz, aber mit Compile-Time-Analyse statt Runtime-Profiling-Threads.

### Sektion 3: Sondermerkmale

- **Itanium-II spezifisch**: VLIW-Architektur, lfetch.nt1-Instruction (non-temporal Level-1 Prefetch), 2 GB RAM Linux-System. Compiler-Vergleich icc 9.0 vs gcc 4.0.
- **Speedup-Werte**:
  - Mit Compiler-Prefetching disabled: 2.51 % (icc), 2.56 % (gcc) Average-Speedup
  - Mit Compiler-Prefetching enabled: 1.77 % (icc), 1.83 % (gcc) — additiv zu statischen Prefetches
  - Cache-Miss-Reduction-Factor (CMRF) bis zu 88 %, Average 26.47 %
- **Vorteil ggü. ADORE/Trident** (Sec 6): Keine Multi-Threaded Profiling-Infrastructure noetig — portabel auf Single-Thread-Systeme.
- **Overhead**: 1.5-6.5 % Runtime-Overhead, abhaengig von Variance der Application-Behavior (177.mesa hat hoechsten Overhead 6.5 %).
- **Kein Multi-Threading**: Vorteil gegenueber Speculative-Precomputation (Collins 2001) — keine Helper-Threads.

### Sektion 4: Plattform-Modell-Bezug (Saeule B)

- **IIsaFeatureSet**: VLIW-Itanium-II spezifisch — `lfetch`-Instruction-Family, Instruction-Bundles, Predication. Architektur-spezifische Parameter B, F, M_i.
- **IHardwareExtension**: Performance-Counters fuer Iteration-Latency-Messung (Cycle-genau).
- **ILivePlatformModel**: Runtime-Adaptation basierend auf laufender CPU-Zeit, Cache-Miss-Latency dynamisch gemessen.
- **ICacheLevel**: Itanium-II hat 3-Level-Cache (Sec 6: L1+L2+L3), `lfetch.nt1` zielt auf L1 mit non-temporal Hint (kein L2/L3-Pollution).
- **IScheduler**: Single-Threaded — KEIN Helper-Thread (Differenz zu ADORE/Trident).

### Sektion 5: Verallgemeinerungs-Vorschlaege (DIREKT relevant fuer IHeuristic + DecisionLambdaTree)

- **IRuntimeAdaptiveHeuristic** als Konzept-Basisklasse:
  - `getCurrentLatency() → cycles` (live measurement)
  - `computeOptimalDistance(L_miss, L_iter) → distance` (Khan Equation 6)
  - `shouldPrefetch(costBenefit) → bool` (Khan Equation 4)
- **IDistanceComputationHeuristic**: Affine `I = O*A + B` ist generisches Pattern fuer parametrisierbare Strategie-Wahl. **Direkt mappbar auf DecisionLambdaTree-Knoten**: Lambda-Expression mit zwei Eingangsparametern (L_miss, L_iter) und Output-Distance.
- **ITemplateSpecializerStrategy**: Template-Code-Pattern fuer JIT-aehnliche Anpassung **ohne Code-Generation** (nur Konstanten-Modifikation in 2-5 Instructions). Sehr leichtgewichtig im Vergleich zu vollstaendigem JIT.
- **ICostBenefitGatedStrategy**: Generisches Pattern — Strategy wird nur aktiviert wenn Benefit > Overhead. Gilt fuer alle Runtime-Adaptive-Strategies.
- **IDynamicSpecializerHeuristic**: Drei-Phasen-Pipeline:
  1. Compile-Time Analysis (Variablen-Selection, Cost-Benefit, Template-Generation)
  2. Runtime-Specialization (Modify-Add bei Itanium-II)
  3. Online-Distance-Adaptation (Loop-Iteration-Counter)
- **IOnlinePerformanceCounterHeuristic**: Hardware-Counter-basierte Latency-Messung als Input fuer alle anderen IHeuristics.

### Sektion 6: Luecken

- OFFEN: Runtime-Adaptation arbeitet nur fuer Code, der **mehrfach** aufgerufen wird (Amortisierung). Single-Shot Workloads bleiben unprofitiert.
- OFFEN: Variance-Empfindlichkeit (177.mesa zeigt 6.5 % Overhead bei wenig Profit) — keine Strategy-Switch-Logik wenn Workload-Type aendert.
- OFFEN: Nur Stride-Prefetching adressiert; Pointer-Chasing (P21!) und unregelmaessige Patterns nicht behandelt.
- OFFEN: Multi-Threading komplett ausgeklammert — Cache-Coherence-Issues bei Modify-Add nicht im Detail evaluiert (nur erwaehnt).
- OFFEN: Itanium-II-Plattform-Spezifisch — Portierung auf x86/ARM nicht im Paper, ist aber konzeptuell uebertragbar.
- OFFEN: Keine Dynamic-Recompilation/JIT — limitiert auf affine Konstanten-Aenderungen.

---

## QUERVERWEISE / SYNTHESE

### Cluster-uebergreifende Prefetch-Strategien

**Software-gesteuerter Prefetch (P21, P22, P23):**
- Alle drei nutzen explizite Prefetch-Instructions (compiler-emitted oder programmer-emitted).
- Distanz `k` ist in P21/P22 statisch berechnet aus `B = T1/T_next`; in P23 dynamisch aus Live-Counter-Messung (`O_r = MissLatency/IterLatency`).
- **Generalisierung**: Beide Ansaetze fallen unter `IPrefetchDistanceHeuristic` mit `STATIC` und `DYNAMIC` Sub-Strategies.

**Wider Nodes als Prefetch-Enabler (P20, P21):**
- P21 fuehrt das Konzept ein: w = 8 Cache-Lines (statt 1) erlaubt parallel Prefetch aller Lines, Cost-Reduktion durch geringere Tree-Hoehe.
- P20 nutzt das Konzept implizit mit 4 KiB Pages — diese sind "wide" im Sinne von P21, aber das Hauptaugenmerk liegt auf intra-page Layout-Strategien (Heads, Hints, Fingerprint).
- **Generalisierung**: `IWideNodeStrategy` mit `Width` als orthogonalem Parameter zu `ILayoutStrategy`.

**Jump-Pointer-Arrays (P21, P22):**
- P21 konzipiert: external chunked-list mit Hint-Pointers UND internal (parents-of-leaves).
- P22 erweitert auf zwei Granularitaeten: Internal-Array fuer Cache-Tier, External-Array fuer Disk-Tier — DUAL.
- **Generalisierung**: `IJumpPointerArrayStrategy<Tier>` mit Tier-Parameter; Multi-Tier ueber Comp-Pattern.

**Multi-Granularitaeten (P22, partiell P20):**
- P22 ist DAS Multi-Granularitaeten-Paper: Cache-Line + Disk-Page als getrennt optimierte Tiers, fractal selbst-aehnlich.
- P20 hat implizit 2 Granularitaeten: Cache-Line (Heads, Fingerprint) + Page (4 KiB für vmcache).
- **Generalisierung — direkt fuer ICacheTopology**: `IMultiTierCacheStrategy<Tier[]>` mit fractaler oder distinkter Layout-Wahl pro Tier.

### Software-Prefetch vs Hardware-Prefetch

**Software-Prefetch (alle 4 Paper):**
- Vorteil: Predictability, kein Speculation-Cost, kein Cache-Pollution wenn richtig dosiert.
- Nachteil: Compiler-Komplexitaet, statische Distanz oft suboptimal (P23 Loesung), Code-Bloat.
- P21/P22: Distance statisch berechnet (B-basiert) — funktioniert gut bei homogenen Workloads.
- P23: Dynamisch adaptiert — funktioniert bei heterogenen Workloads.

**Hardware-Prefetch (NICHT in diesen 4 Papern, aber Querverweis):**
- Stride-Detector, Stream-Detector, IP-Based-Predictor — alle adaptiv im Hardware-Layer.
- ZhangEtalASPLOS2025HierarchicalPrefetching (im Cluster vorhanden, nicht hier) komplementaer.
- WhyDoesDataPrefetchingNotWork (Cluster vorhanden) ist die Gegenposition fuer moderne Workloads.

**Hybrid-Approach** (impliziert in P23):
- Compile-Time-Analyse erzeugt Templates, Hardware-Counter messen Live-Latencies, Runtime-Specializer modifiziert Distanzen.
- **Generalisierung**: `IHybridPrefetchStrategy` mit `IStaticDistanceHeuristic + IRuntimeAdaptationHeuristic + IPerformanceCounterReader` als Komponenten.

### IHeuristic-Klassen aus Prefetch-Cost-Modellen

**Aus P20 (Layout-Selection):**
- `HeadQualityHeuristic(threshold=16/64)` — String-vs-Integer-Detektion
- `ScanFrequencyCounterHeuristic(probabilities=[15%, 5%], range=[0,3])` — Workload-Adaption
- `KeyTypeHeuristic(uniqueness)` — Layout-Type-Selection
- `BoundaryNodeHeuristic` — Sequential-Insert-Detection

**Aus P21 (Static Cost Model):**
- `OptimalNodeWidthHeuristic(B, m, N) → w_optimal` — Tree-Hoehen-Optimierung
- `OptimalPrefetchDistanceHeuristic(B, w) → k_optimal` — Range-Scan-Distance
- `OptimalChunkSizeHeuristic(B, m) → c_optimal` — Jump-Pointer-Array-Granularitaet

**Aus P22 (Multi-Tier Cost Model):**
- `OptimalWidthMultiTierHeuristic(TierLatencies[], FanOutGoal)` — pro Tier separat
- `OverflowVsOffloadHeuristic(PageSize, OptimalNodeSize, MismatchRatio)` — Aggressive-Placement-Decision
- `DiskFirstVsCacheFirstHeuristic(MemoryFootprint, IORatio)` — Architektur-Wahl

**Aus P23 (Runtime Adaptation):**
- `RuntimeOffsetAdaptationHeuristic(L_miss_live, L_iter_live) → O_r`
- `CostBenefitGatedHeuristic(SumLatencies, R_overhead) → bool`
- `AffineDistanceHeuristic(O, A, B) → I` — generisches affines Modell
- `TemplateSpecializerHeuristic(p_instructions, modify_locations[]) → modified_template`

**Konsolidierter IHeuristic-Konzept-Hierarchie-Vorschlag:**
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

### Architektur-Mapping zu ICacheStrategy-VISITOR (Saeule A)

Aus Hierarchie `ICacheStrategy = VISITOR: BaseEngineStrategy | CacheEngineStrategy`:

**BaseEngineStrategy** (kein Cache-spezifisches Verhalten):
- Standard-B+-Tree (Vergleichsbaseline in allen 4 Papern)

**CacheEngineStrategy** (mit Cache-Optimierungen):
- **Layout-Komposition** (P20): Heads + Hints + Fingerprint + Dense → AdaptiveLeafSelector
- **Prefetch-Komposition** (P21): WideNodePrefetch + JumpPointerScan
- **Multi-Tier-Komposition** (P22): FractalPrefetching (Cache + Disk)
- **Runtime-Adaptation-Komposition** (P23): TemplateSpecializer + RuntimeDistanceAdaptation

**Visitor-Methoden** auf ISearchPage:
- `visit(searchPage, baseEngine) → standard binary search`
- `visit(searchPage, cacheEngine) → prefetch + layout-aware search`

### Mapping zu ISearchPagesStrategyPattern (1 pro IFanout)

Gemaess REV-2-Hierarchie hat eine IFanout (Branching-Faktor) genau eine ISearchPagesStrategyPattern, die N ISearchPageStrategy fuer die N INodes erzeugt.

- **P20 Adaptive B-Tree**: Pattern erzeugt heterogene Strategien pro Leaf (Comparison/Fingerprint/SDL/FDL je nach KeyAdaption-Ergebnis).
- **P21 pB+-Tree**: Pattern ist homogen — alle Knoten haben dieselbe WideNodePrefetchStrategy (gleiche w).
- **P22 fpB+-Tree**: Pattern ist hierarchisch — Disk-Page-Tree-Pattern enthaelt In-Page-Tree-Pattern (rekursive Composition).
- **P23 Adaptive Prefetch**: Pattern ist orthogonal — gleiche Search-Strategie, aber unterschiedliche Prefetch-Distanzen pro Loop-Iteration.

**Konsolidierter Vorschlag**: `ISearchPagesStrategyPattern` sollte mindestens vier Konkretisierungen erlauben:
1. **HomogeneousPattern** (P21) — alle Knoten gleich
2. **HeterogeneousAdaptivePattern** (P20) — pro Knoten verschieden, gewaehlt durch Heuristic
3. **HierarchicalFractalPattern** (P22) — pro Tier verschieden, rekursiv komponiert
4. **OrthogonalRuntimeParametrizedPattern** (P23) — gleicher Algorithmus, parametrisiert per Runtime

### Hardware-Interaktion mit ILivePlatformModel

P23's Runtime-Adaptation ist DER direkte Anknuepfungspunkt fuer `ILivePlatformModel`:
- Lese aktuelle CPU-Cycle-Counter → `ILiveCpuModel.getCurrentCycle()`
- Lese aktuelle Cache-Miss-Latency → `ILiveCpuModel.getMeasuredMissLatency(level)`
- Lese aktuelle Iteration-Latency → `ILiveCpuModel.getLoopIterationCycles(loopId)`
- Modifikation der Prefetch-Distanz wird direkt in CompiledCode geschrieben → `ILivePlatformModel.applyRuntimeSpecialization(template, newConstants)`

Dies fuegt sich nahtlos in die geplante DecisionLambdaTree-Architektur ein — Lambda-Knoten konsumieren Live-Counter-Werte als Input, geben Prefetch-Konfiguration als Output.

### Offene cluster-uebergreifende Punkte

- **OFFEN**: Wie unifizieren wir P22's Multi-Tier-Granularitaet mit P20's Page-Level-Adaptive-Layout? Beide sind orthogonal, koennten aber kombiniert werden zu einer "Multi-Tier-Adaptive-Layout-Strategy".
- **OFFEN**: P23's Runtime-Adaptation ist nur fuer Stride-Prefetch beschrieben. Generalisierung auf P21's Pointer-Chasing-Strategien (Jump-Pointer-Arrays) ist konzeptuell moeglich aber nicht im Paper — koennte ein eigener Beitrag der Diplomarbeit sein.
- **OFFEN**: Prefetch-Cost-Modelle gehen alle von einheitlicher Cache-Architektur aus. Heterogene Multi-Core-Plattformen (z. B. P-Cores + E-Cores Intel 12th Gen, NUMA-Aware-Prefetching) sind nicht abgedeckt.
- **OFFEN**: P20's vmcache-Integration zeigt OOM-Performance, aber kein expliziter Prefetch-Mechanismus fuer SSD-Tier — koennte um P22's External-Jump-Pointer-Array erweitert werden.
