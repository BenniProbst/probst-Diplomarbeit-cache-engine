# Extraktion REV4 Delta zu REV3 — Future-Proof + Layer-Matrix-Hybrid

**Erstellt:** 2026-05-11
**Quellen:**
- `21_architektur_skizze_REV4_2026_05_10.md` (383 Zeilen)
- `phase5_uml_detail_REV4.drawio` (231 Zeilen, 13 Tabs: K01-K06, U01-U06, MX1)
- Vergleichsbasis: `20_architektur_skizze_REV3_2026_05_10.md` (507 Zeilen, 12 drawio-Tabs)

**Zweck:** Vollstaendige Delta-Extraktion fuer REV5-Synthese.

---

## A) WAS IST IN REV4 NEU vs REV3? (pro Tab)

### A.1 Strukturelle Tab-Reorganisation

**REV3 hatte 12 nummerische Tabs (01-12) gemischt** (Konzept + UML in einem Topf).
**REV4 hat 13 typisierte Tabs:** 6 Konzept (K01-K06) + 6 UML (U01-U06) + 1 Matrix (MX1).

| REV3 Tab | REV4 Aequivalent | Aenderungs-Typ |
|----------|------------------|----------------|
| 01 IExecutingEngine + Spezialisierungen | K01 + U01 | aufgespalten in Konzept (K01) + UML (U01) |
| 02 Search Engine Concept-Hierarchie | K02 + U02 | aufgespalten Konzept/UML |
| 03 Search Engine ICacheStrategy Visitor | K03 (Teil) | konsolidiert in K03 (4-Ebenen) |
| 04 Strategy-Achsen + 4-Ebenen + Multiplizitaeten | K03 + U03 | aufgespalten |
| 05 Iteratoren-Familie | U03 (Teil) | mit Strategy-Familie zusammengefasst |
| 06 Hybrid-Command + 17 Composition-Commands | K04 + U04 | aufgespalten Konzept/UML |
| 07 Cache Engine IPlatformProbe Auto-Discovery | K05 (Teil) + U05 | aufgespalten |
| 08 Cache Engine Plattform-Modell | K05 (Teil) + U06 (Teil) | konsolidiert |
| 09 Cache Engine IHeuristic-Familie | K05 (Teil) + U06 | aufgespalten |
| 10 Cache-Strategie-Familien F1-F29 | NICHT mehr separater Tab | nur als Achse in MX1 referenziert |
| 11 Drei-Ebenen-Verbindungen | K01 (Teil) | im Wurzel-Konzept aufgegangen |
| 12 Forschungs-Mission + F15 | K06 | unveraendert uebernommen |
| (NEU) | MX1 | Layer-vs-Matrix Hybrid + Future-Proof Prinzipien |

### A.2 Drawio-XML-Fixes (technisch)

**REV3-Bug:** XML-Parser brach an Zeile 31 wegen ASCII-`"` und deutscher Anfuehrungszeichen `„` `"` mitten in `value=""`-Attributen. Symptom: `Specification mandates value for attribute eines`.

**REV4-Fix:**
1. Alle ASCII-Anfuehrungszeichen aus value-Attributen entfernt
2. Deutsche Anfuehrungszeichen `„` `"` aus den Beschriftungen entfernt
3. Konsequent ASCII-sichere Schreibweise innerhalb der drawio-Strings
4. Validierung mit Python `xml.etree.ElementTree` bestanden

**Zusaetzlich:** Alle Edges nutzen `edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;` mit explizit gesetzten exit/entry-Punkten — UML-konforme Verbindungslinien (rein vertikal/horizontal, keine Diagonal-Kreuzungen ueber Klassen).

### A.3 Tab-fuer-Tab Inhaltsdelta REV3→REV4

#### K01 — Drei-Ebenen-Architektur (NEU als reines Konzept-Diagramm)
- Drei farbig getrennte Layer-Boxen (E1 Cyan, E2 Gruen, E3 Indigo)
- Pfeile mit edge-Labels `konsumiert` und `optimiert via`
- Legende rechts unten mit Farb-Konvention (Cyan=Concept, Gruen=Saeule A, Indigo=Saeule B, Pink=Hybrid-Command, Lila=ADR/Forschung)

#### K02 — Saeule A Concept-Hierarchie (kondensiert + farb-codiert)
- IPage / IRootPage / IFanout / INode / ISearchPage / ICachePage als Concepts (Cyan)
- ICachePage zusaetzlich Gruen-markiert als physische Speicherrepraesentation
- ISearchPagesStrategyPattern + ISearchPageStrategy in ORANGE markiert (visuell hervorgehoben als 4-Ebenen-Patterns)
- ICacheStrategy Visitor + Hybrid-Command (Pink) + Iteratoren als untere Reihe
- Beziehungen: composition (`diamondThin endFill=1`) zwischen IRootPage→IFanout→INode

#### K03 — ICacheStrategy Visitor + 4-Ebenen-Strategien
- Top: ICacheStrategy als Visitor-Pattern Wurzel
- Zwei Konkretisierungen: `BaseEngineStrategy` (Blau, Baseline F15) und `CacheEngineStrategy` (Gruen, optimiert)
- 4 Ebenen-Boxen darunter:
  - **EBENE A**: ISearchPagesStrategyPattern (1 pro IFanout, **alle 10 PatternKind aufgelistet**: AllPagesUniform / LayerMix / InnerVsLeaf / HotVsCold / DynamicRebalance / HierarchicalFractal / OrthogonalRuntimeParametrized / MultiStrategyOrchestration / HeterogeneousAdaptive / BoundaryNodePartition)
  - **EBENE B**: ISearchPagesStrategy (PLURAL, N pro Pattern, BPlus/Trie/Hybrid-Familien)
  - **EBENE C**: ISearchPageStrategy (SINGULAR, 1 pro ISearchPage, Atom-Strategien)
  - **EBENE D**: IHeuristic (~80 paper-abgeleitete Heuristiken)

#### K04 — Hybrid-Command-Pattern (ueberarbeitet)
- IStrategyCommand-Wurzel + HybridCompositionCommand + ICompositionRule (Sequential/Parallel/Conditional/Recursive)
- **NEU explizit aufgelistet (atomare Strategy-Commands):**
  - P03 Masstree: SliceLayerJump + BPlusPerLayer + PermutationFieldInsert
  - P10 SuRF: LoudsDenseEncoding + LoudsSparseEncoding
  - P02 HOT: CompoundContainer + BiNodeSubtree + SingleMaskPK + MultiMaskPK
  - P07 Wormhole: HashAnchorLookup + BPlusHopLookup + LeafLinkedListScan
  - P06 B²-Tree: OuterBPlusPage + DecisionPageStrategy + SpanPageStrategy
  - P04 CoCo: MacroNodeCollapse + PatriciaInnerExpand + SuccinctEncodingPool
  - P22 Fractal: DiskTierTraversal + CacheTierTraversal + DualJumpPointerArray
  - P28 Kuehn: LeafOnlyCounter + RetroactiveAggregation + GreedyHotPathLayout
  - P26 Zhang: CachePrefetcher (CP) + PathPrefetcher (PP) + MonitorPrefetcher (MP)
- **17 HybridCompositionCommand-Konkretisierungen vollstaendig nummeriert (1-17):** MasstreeSliceLayered / CutoffLevelLouds / HOTAdaptiveLayoutSelection / TripleLayerLookup / B2TreeRecursiveCommonPrefix / CoCoLevelLDecision / CoCoEncodingPool / ThreePrefetcherOrchestration / KuehnHotPathOptimization / ChenPrefetchedBPlus / HankinsPatelCostModel / ZhangFGCSPointerResolution / STARTAdaptive / KhanRuntimeAdaptive / SamuelConfigurationTable / BTreesAreBackHeterogeneousAdaptive / SequentialInsertComposition

#### K05 — Saeule B Plattform-Modell (Auto-Discovery)
- IPlatformProbe + IPlatformPropertyClassifier + ICacheEngineOptionPublisher als Top-Reihe
- 5-Schritt-Pflichtsequenz mittig (DISCOVER / MEASURE / CLASSIFY / PUBLISH / BIND) mit Annotation: CPUID/sysfs/proc/hwloc fuer Discover; clflush-cycle/All-Pairs-Pinning/Coherence-Calibration fuer Measure
- 3 Concept-Reihen darunter: Cache-Hierarchie / CPU-Modell / Bus+ISA-Features
- Echtzeit-Modelle (ILivePlatformModel, ILiveCpuModel) mit periodischem ~100ms-Tick-Annotation
- IScheduler + IHeuristic-Konkretisierungen (LargestL3CcdPinning, HotPathOnHighIpcCore, CacheCostDP P05, WidthCostModel P13, CacheCoherenceCost P28, StrideVsSequential P32)

#### K06 — Forschungs-Mission F15 (unveraendert uebernommen)
- 3 Modi-Boxen: HEURISTIC_STATIC / INFORMED_KALIBRIERT / AUTOMATIC_ADAPTIVE
- F15 Kombinatorik-Block: 29 × 4 × ~80 = ~10.000 Tupel; mit Hybrid ×3 = ~30.000; ConstraintFilter ~500-1000 valid pro Plattform
- Operationalisierungs-Hinweis: gleiche Workload-Sequenz auf allen 3 Modi → direkter Vergleich

#### U01-U06 — UML-Tabs (NEU vollstaendig)
Siehe Sektion D fuer Klassen, Variablen, Methoden.

#### MX1 — Layer-vs-Matrix Hybrid (komplett NEU, Kern der REV4)
Siehe Sektion C.

---

## B) FUTURE-PROOF-PRINZIPIEN (Sektion 2 in REV4-MD)

### B.1 Open/Closed-Prinzip
**Anwendung in PRT-ART:**
- Concept-Klassen (`ICacheStrategy`, `IPage`, `IHeuristic`) sind **closed for modification** — Methoden-Signaturen sind Contracts und aendern sich NICHT
- Konkretisierungen sind **open for extension** — neue Klasse implementiert das Concept, ohne dass andere Konkretisierungen oder das Concept-Interface sich aendern
- **Mechanismus:** C++23 Templates + `requires`-Klausel + `concept`-Definitionen

### B.2 Modular Architecture
**Anwendung:**
- Jede Achse einer Matrix ist eine unabhaengig austauschbare Achse mit eigenem Sub-Verzeichnis
- Konkretisierungen koennen ohne Aenderung an anderen Achsen ergaenzt werden
- Verzeichnis-Granularitaet: pro Cache-Familie pro ISA-Feature pro Plattform-Property pro Concurrency-Mechanik pro Telemetry-Strategie

### B.3 Encapsulation through stable contracts
**Anwendung:**
- Concept-Header (`i_*.hpp`) sind die einzigen oeffentlichen API-Punkte
- Implementierungs-Header (`*.hpp` ohne `i_`-Praefix) sind privat zur Konkretisierungs-Achse
- Aenderungen innerhalb einer Achse beeinflussen keine anderen Achsen

### B.4 Single Responsibility auf Architektur-Ebene
**Anwendung pro Concept:**
- `IPage` = logische Seiten-Abstraktion
- `ICacheStrategy` = Read/Write-Routing-Visitor
- `IHeuristic` = Wert-/Kostenberechnung
- `IPlatformProbe` = Auto-Discovery der Plattform
- Mehrfach-Verantwortlichkeiten werden in mehrere Concepts aufgeteilt

### B.5 Separation of Concerns
**Anwendung:**
- Saeulen A (Strategien) und B (Plattform-Modell) sind disjunkt
- Engine konsumiert nur abstrakte Schnittstellen — kennt keine konkreten Implementierungen
- DecisionLambdaTrees vermitteln Events zwischen den Saeulen, ohne dass die Saeulen direkt voneinander abhaengen

### B.6 API-First Design
**Anwendung:**
- Jede Erweiterung beginnt mit einer Concept-Erweiterung (oder neuem Concept-Header)
- Erst wenn die API stabil ist, folgen Konkretisierungen
- Aenderungen an Concepts erfordern formelle Architektur-Korrekturrunde (REV1→REV2→REV3→REV4 Vorgehen)

### B.7 Dependency Structure Matrix (DSM) als Visualisierungs-Tool
**Anwendung in Phase 6+:**
- DSM-Matrix mit allen Concepts als Zeilen + Spalten
- Zellen markieren vorhandene Abhaengigkeiten (`uses`, `composes`, `inherits`)
- Ziel: **Block-Triangulare Struktur** (saubere Layer-Trennung)
- Tooling-Optionen: Lattix, Structure101, oder eigenes Skript

**Web-Recherche-Quellen (REV4 §8, 11 URLs):**
- codewave.com, moldstud.com, buildsimple.substack.com, superblocks.com, transcenda.com, ResearchGate, strapi.io, O'Reilly Layered Architecture Patterns, Wikipedia Multitier, DZone DSM, Bitloops Layered Architecture

---

## C) LAYER-MATRIX-HYBRID (Tab MX1 + REV4 §1)

### C.1 Architekt-Frage (Anlass)
> "Reicht es, die Implementierungsklassen in Layern anzuordnen, oder braucht es eine mehrdimensionale Matrix-Struktur, um multiple verbundene Aspekte zu implementieren?"

### C.2 Antwort: HYBRID

**LAYER-DIMENSION (vertikal, klassisch):**
- Drei Ebenen aus REV3 §0: Engine | Strategien | CacheEngine
- Ein Concept gehoert genau einem Layer
- Klare Abhaengigkeits-Richtung (oben → unten)
- Vorteil: Encapsulation, stabile Contracts, einfaches Reasoning, Open/Closed pro Layer

**MATRIX-DIMENSION (horizontal, fuer F15-Bausteine-Quer-Permutation):**
Pro Layer existiert eine Matrix der Konkretisierungen entlang mehrerer orthogonaler Achsen.

**Konkrete Achsen (Auswahl):**
- Cache-Familie F1-F29 (siehe `11_cache_strategy_taxonomie.md`)
- Strategie-Ebene A-D (Pattern / Plural-Strategy / Singular-Strategy / Heuristic — siehe `12_algorithmus_strategie_taxonomie.md`)
- Plattform-Property (has_asymmetric_l3, has_hybrid_cores — siehe `13_saeule_b_plattform_modell_konkretisierung.md`)
- ISA-Feature (AVX-512, BMI2, NEON, SVE2)
- Concurrency-Mechanik (OLC, ROWEX, RCU, Hazard)
- Telemetry-Strategie (PerNode, LeafOnly, Sampled, Retroactive — Achse 11 Kuehn)

**DSM** als Visualisierungs-Tool fuer Cross-Achsen-Beziehungen.

### C.3 Hybrid-Empfehlung pro Concept (Beispiele in MX1)

| Concept | Achse 1 | Achse 2 |
|---------|---------|---------|
| ICacheStrategy | Visitor-Variante (Base/CacheEngine) | Cache-Familie F1-F29 |
| IHeuristic | Heuristik-Kategorie (Prefetch/Layout/Coherence/Plattform/ISA/Concurrency) | Paper-Quelle |
| ISearchPagesStrategyPattern | PatternKind (10 Varianten) | Adaptivitaet (Statisch/Adaptive/Runtime) |

### C.4 Verzeichnis-Konsequenz pro Concept (Beispiel ICacheStrategy aus REV4 §1.3)

```
search_engine/
├── concepts/
│   └── i_cache_strategy.hpp                          (Concept-Header — Contract)
├── cache_strategies/                                  (Matrix-Layer fuer Konkretisierungen)
│   ├── visitor_variants/                              (Achse 1: Visitor-Variante)
│   │   ├── base_engine_strategy.hpp                   (1A — Baseline F15)
│   │   └── cache_engine_strategy.hpp                  (1B — CacheEngine-aktiv)
│   └── families/                                      (Achse 2: Cache-Familie F1-F29)
│       ├── f01_adaptive_footprint/                    (F1 IAdaptiveFootprintStrategy)
│       │   ├── art_node_footprint_strategy.hpp        (P01)
│       │   ├── hot_layout_footprint_strategy.hpp      (P02)
│       │   └── ...
│       ├── f02_succinct_encoding/                     (F2 ISuccinctEncodingStrategy)
│       │   ├── louds_jacobson_encoding_strategy.hpp   (P09)
│       │   ├── louds_dense_encoding_strategy.hpp      (P10)
│       │   ├── louds_sparse_encoding_strategy.hpp     (P10)
│       │   └── ...
│       └── ... (F3-F29 analog)
```

**Mechanik:** Achse 1 + Achse 2 sind orthogonal; eine konkrete Konkretisierung kombiniert beide (z.B. `BaseEngineStrategy x F2.LoudsDenseEncoding`). Die Composition ist **Compile-Time-Composition via C++23 Templates + requires-Klauseln**. Im Build entstehen ABI-stabile Module (siehe Architekturentscheidung F9).

### C.5 Klassen + Beziehungen im MX1-Tab (drawio)

MX1 enthaelt **5 Boxen** (rein konzeptuell, keine UML-Klassen):
1. **layer_box** (Cyan): "LAYER-DIMENSION (vertikal, klassisch)" — beschreibt Engine|Strategien|CacheEngine + Vorteile
2. **matrix_box** (Gruen): "MATRIX-DIMENSION (horizontal, fuer Bausteine-Quer-Permutation F15)" — listet die 6 Achsen + DSM
3. **hybrid** (Lila): "HYBRID-EMPFEHLUNG (PRT-ART)" — listet die 3 Beispiel-Concepts (ICacheStrategy, IHeuristic, ISearchPagesStrategyPattern) mit ihren Achsen
4. **future** (Orange): "FUTURE-PROOF-PRINZIPIEN" — listet Open/Closed, Modular, Encapsulation, SRP, SoC, API-First
5. **hint** (Gelb): DSM-Hinweis als Phase-6+ Werkzeug

**Was MX1 beweist:**
- Layer alleine reicht NICHT, weil F15-Permutationen orthogonal zu Layern verlaufen
- Matrix alleine reicht NICHT, weil sie Abhaengigkeitsrichtung verliert
- HYBRID = Layer fuer Architektur-Reasoning + Matrix fuer Konkretisierungs-Skalierung
- Verzeichnis-Konvention `concepts/` + `cache_strategies/<axis>/<family>/` ist die OPERATIVE Umsetzung

---

## D) UML-TABS U01-U06 (vollstaendige Klassen-Listen)

### D.1 U01 — IExecutingEngine + ISearchEngine + IFutureEngine

**`<<concept>> IExecutingEngine`** (Cyan, top center)
- **Attribute (protected):**
  - `# cache_engine_ : optional<CacheEngine&>`
  - `# observer_registry_ : ObserverRegistry&`
  - `# lifecycle_state_ : EngineLifecycleState`
- **Methoden (public):**
  - `+ execute<Op>(operation : Op&) : Result<Op>`
  - `+ warm_up() : void`
  - `+ reset() : void`
  - `+ shutdown() : void`
  - `+ telemetry_hooks() const : ObserverSlots`
  - `+ bind_cache_engine(engine : CacheEngine&) : void`
  - `+ unbind_cache_engine() : void`

**`<<concept>> ISearchEngine : IExecutingEngine`** (Gruen, links unten)
- **Attribute (private):**
  - `- root_page_ : IRootPage&`
  - `- page_structure_ : ISearchPageStructure&`
  - `- cache_strategy_ : ICacheStrategy&`
  - `- prt_art_container_ : comdare::prt_art<K, V>`
- **Methoden (public):**
  - `+ lookup(key : K) const : optional<V>`
  - `+ insert(key : K, value : V) : InsertResult`
  - `+ erase(key : K) : EraseResult`
  - `+ range_scan(begin : K, end : K) : RangeIterator`
  - `+ begin() / end() / rbegin() / rend()`
  - `+ size() const noexcept : size_t`
  - `+ empty() const noexcept : bool`

**`<<concept>> IFutureEngine : IExecutingEngine`** (Lila, rechts unten)
- Architektur-Slot, leer in PRT-ART
- Zukuenftige Konkretisierungen: ICompactingEngine / IDeduplicationEngine / ISortingEngine / IRetentionEngine
- ALLE nutzen die selbe CacheEngine-Schnittstelle ueber geerbte `bind_cache_engine()`

### D.2 U02 — Saeule A Page-Familie

**`<<concept>> IPage<P>`** (Cyan, links oben)
- **Typen:** `~ using PageHeader = typename P::PageHeader`, `~ using Value = typename P::Value`
- **Attribute (protected):** `# header_ : PageHeader`, `# bytes_ : span<byte>`
- **Methoden (public):**
  - `+ lookup(key : KeyView) const : LookupResult<P>`
  - `+ insert(key : KeyView, value : Value) : InsertResult`
  - `+ remove(key : KeyView) : RemoveResult`
  - `+ bytes() const noexcept : span<byte const>`
  - `+ value_type() const : type_info`
  - `+ accept(visitor : ICacheStrategy&) : void`

**`<<concept>> IRootPage<R> : IPage`** (Cyan, mitte oben)
- **Attribute (private):** `- fanout_ : IFanout&`
- **Methoden (public):**
  - `+ root_fanout() const : IFanout&`
  - `+ set_root_fanout(fanout : IFanout&) : void`
  - `+ algorithm_signature() const : AlgorithmSignature`
  - `+ supports_concurrent_root_swap() const noexcept : bool`
- **Constraint:** `inv: fanout_ ist genau 1 (eindeutig)`

**`<<concept>> IFanout<F>`** (Cyan, rechts oben)
- **Attribute (private):**
  - `- nodes_ : array<INode*, F::max_fanout>`
  - `- node_count_ : uint16_t`
  - `- pages_strategy_pattern_ : ISearchPagesStrategyPattern&`
- **Methoden (public):**
  - `+ visit_each_child(visitor : auto&&) const : void`
  - `+ lookup_child(byte : uint8_t) const : INode*`
  - `+ insert_child(byte, child : INode&) : InsertChildResult`
  - `+ remove_child(byte : uint8_t) : RemoveChildResult`
  - `+ load_factor() const : double`
  - `+ pages_strategy_pattern() const : ISearchPagesStrategyPattern&`
- **Constraint K3.4:** `inv: pages_strategy_pattern_ ist genau 1 pro IFanout`

**`<<concept>> INode<N>`** (Cyan, links unten)
- **Typen:** `~ using ChildHandle = typename N::ChildHandle`
- **Attribute (private):** `- placement_page_ : ISearchPage&`, `- placement_offset_ : uint16_t`
- **Methoden (public):**
  - `+ visit_each_child(visitor : auto&&) const : void`
  - `+ value_handle_for(byte : uint8_t) const : ValueHandle`
  - `+ child_handle_for(byte : uint8_t) const : ChildHandle`
  - `+ load_factor() const : double`
  - `+ search_page() const : ISearchPage&`
  - `+ key_byte_at(slot : uint8_t) const : uint8_t`

### D.3 U03 — Saeule A Strategy-Familie + ICacheStrategy + Iteratoren

**`<<concept>> ISearchPagesStrategy<SPS>`** (Cyan, links oben)
- **Attribute (protected):** `# structure_ : ISearchPageStructure&`, `# pattern_ : ISearchPagesStrategyPattern&`
- **Methoden (public):**
  - `+ on_insert_request(key : K, value : V) : OpResult`
  - `+ on_remove_request(key : K) : OpResult`
  - `+ on_consolidation_barrier(event : Event&) : void`
  - `+ on_capacity_exceeded(page : ISearchPage&) : void`
  - `+ get_target_page(key : K) const : ISearchPage&`
  - `+ pattern() const : ISearchPagesStrategyPattern&`

**`<<concept>> ISearchPagesStrategyPattern<SSP>`** (Orange, mitte oben — K3.4 Multiplizitaet: 1 pro IFanout, has N ISearchPageStrategy)
- **Attribute (private):** `- per_page_strategies_ : map<PageId, ISearchPageStrategy&>`, `- pattern_kind_ : PatternKind`
- **Methoden (public):**
  - `+ assign_strategy(page : PageId, strat : ISearchPageStrategy&)`
  - `+ strategy_for(page : PageId) const : ISearchPageStrategy&`
  - `+ kind() const : PatternKind`
  - `+ visit_assignments(visitor : auto&&) const : void`
- **PatternKind enum:** AllPagesUniform | LayerMix | InnerVsLeaf | HotVsCold | DynamicRebalance | HierarchicalFractal | ...

**`<<concept>> ISearchPageStrategy<SP>`** (Orange, rechts oben — K3.4 Multiplizitaet: 1 pro ISearchPage)
- **Attribute (protected):** `# owning_page_ : ISearchPage&`, `# layout_invariants_ : LayoutInvariantSet`
- **Methoden (public):**
  - `+ insert_into(slot : Slot, key : K, value : V) : OpResult`
  - `+ remove_from(slot : Slot) : OpResult`
  - `+ should_split() const noexcept : bool`
  - `+ should_merge_with(other : ISearchPage&) const : bool`
  - `+ check_invariants() const : bool`

**`<<concept, visitor>> ICacheStrategy<CS>`** (Cyan, links unten)
- **Methoden (public):**
  - `+ visit(read_op : PageReadOp&) : void`
  - `+ visit(write_op : PageWriteOp&) : void`
  - `+ visit(layout_op : PageLayoutOp&) : void` ← **NEU in REV4** (REV3 hatte nur read_op + write_op)
- **Konkretisierungen:** A) BaseEngineStrategy (Baseline F15), B) CacheEngineStrategy (mit ILivePlatformModel + IHeuristic)

**Iteratoren-Familie** (Gruen, rechts unten)
- `<<concept>> INodeIterator<NI>` — byte_at() / next() / done() / current()
- `<<concept>> ISearchPageIterator<SI>` — page_at() / next_page() / range_advance(steps)
- `<<concept>> ISearchPageStrategyIterator<SSI>` — strategy_at() / next_strategy() / cross_algorithm_permutation()
- `class comdare::prt_art<K, V>:` iterator (mutable) operator++/operator*/operator-> + const_iterator + range_iterator + key_iterator + value_iterator + begin/end/cbegin/cend/rbegin/rend

### D.4 U04 — Hybrid-Command Klassen

**`<<abstract>> IStrategyCommand`** (Cyan italic, top)
- **Methoden (public abstract):**
  - `+ virtual execute(context : StrategyContext&) : Result = 0`
  - `+ virtual can_compose_with(other : IStrategyCommand&) const : bool = 0`
  - `+ virtual command_kind() const noexcept : CommandKind = 0`
  - `+ virtual estimated_cost(context : StrategyContext&) const : Cost = 0`
  - `+ virtual ~IStrategyCommand() = default`

**`<<composite>> HybridCompositionCommand : IStrategyCommand`** (Pink, links unten)
- **Attribute (private):**
  - `- parts_ : vector<unique_ptr<IStrategyCommand>>`
  - `- composition_rule_ : unique_ptr<ICompositionRule>`
  - `- composition_id_ : CompositionId`
- **Methoden (public):**
  - `+ execute(context : StrategyContext&) override : Result`
  - `+ add_part(part : unique_ptr<IStrategyCommand>) : void`
  - `+ remove_part(idx : size_t) : void`
  - `+ part_count() const noexcept : size_t`
  - `+ composition_rule() const : ICompositionRule&`
  - `+ set_composition_rule(rule : unique_ptr<ICompositionRule>)`

**`<<concept>> ICompositionRule`** (Indigo, mitte unten)
- **Methoden (public):**
  - `+ apply(parts : span<IStrategyCommand*>, ctx : StrategyContext&) : ExecutionPlan`
  - `+ rule_kind() const noexcept : RuleKind`
  - `+ supports_parallel() const noexcept : bool`
- **Konkrete Subklassen:** SequentialRule, ParallelRule, ConditionalRule (mit ConditionPredicate), RecursiveRule (mit DepthLimit)

**Atom-Beispiel: `HashAnchorLookupCommand : IStrategyCommand`** (Blau, rechts unten — P07 Wormhole)
- **Attribute (private):** `- anchor_table_ : AnchorTable&`, `- hash_function_ : HashFn`
- **Methoden (public):** `+ execute() override`, `+ can_compose_with() override`, `+ command_kind() override : CommandKind::HashAnchor`

### D.5 U05 — Saeule B Plattform-Probe + Auto-Discovery

**`<<concept>> IPlatformProbe`** (Cyan, links oben — KEINE CPU-Spezialisierung)
- **Methoden (public abstract):**
  - **Discover-Phase:** `+ discover_cache_topology() : ICacheTopology`, `+ discover_core_layout() : ICoreLayout`, `+ discover_isa_features() : IIsaFeatureSet`, `+ discover_interconnect() : IBusTopology`
  - **Measure-Phase:** `+ measure_cache_latencies() : map<TierPair, Cycles>`, `+ measure_bandwidths() : map<InterconnectId, Gbps>`, `+ measure_cache_coherence_cost() : CoherenceCostFunction`, `+ measure_pinning_effects() : map<PinningPolicy, Speedup>`

**`<<concept>> IPlatformPropertyClassifier`** (Indigo, mitte oben)
- **Methoden:** `+ classify(probe_results : ProbeResults const&) : PlatformPropertySet`
- **PlatformPropertySet enthaelt:** has_asymmetric_l3, has_hybrid_cores, has_hbm_tier, preferred_pinning, usable_simd_width, has_software_prefetch, coherence_cost_threshold

**`<<concept>> ICacheEngineOptionPublisher`** (Gruen, rechts oben)
- **Attribute (private):** `- properties_ : PlatformPropertySet`, `- registered_modules_ : vector<PermutationModule*>`
- **Methoden (public abstract):**
  - `+ register_module(module : PermutationModule&) : void`
  - `+ unregister_module(module : PermutationModule&) : void`
  - `+ publish_options_to_all() : void`
  - `+ filter_options_for(module : PermutationModule&) : OptionSet`
  - `+ properties() const : PlatformPropertySet const&`

**5-Schritt-Pflicht-Sequenz (CacheEngineBuilder, orange Box):**
1. DISCOVER — `probe.discover_*()` (statisch)
2. MEASURE — `probe.measure_*()` (Mikrobenchmark)
3. CLASSIFY — `classifier.classify(probe_results)`
4. PUBLISH — `publisher.register_module + publish_options_to_all`
5. BIND — pro Permutation entscheidet ICacheStrategy (Visitor) was konsumiert

### D.6 U06 — Saeule B Cache-Hierarchie + IHeuristic Familie

**`<<concept>> ICacheLevel<L>`** (Cyan, links oben)
- **Attribute (public):** `+ size_bytes : size_t`, `+ line_size_bytes : size_t (typ. 64, 256 ARM)`, `+ associativity : int`, `+ latency_cycles : double`, `+ bandwidth_gbps : double`, `+ tier_kind : enum L1/L2/L3/HBM/V_CACHE`
- **Methoden:** `+ effective_capacity()`, `+ measured_at(timestamp) : MeasureSnapshot`

**`<<concept>> ICacheTopology<CT>`** (Cyan, mitte oben)
- **Attribute (private):** `- levels_ : vector<ICacheLevel&>`, `- per_ccd_ : map<CcdId, ICacheLevel&>`, `- asymmetric_l3_ : bool (Auto-discovered)`
- **Methoden:** `+ levels()`, `+ level_count()`, `+ has_asymmetric_l3()`, `+ largest_l3_ccd()`, `+ tier_for(ptr) : Optional<TierKind>`

**`<<concept>> ICacheResidency<CR>`** (Cyan, rechts oben — Cached / HeaderCached / Uncached)
- **Methoden:** `+ residency_of(page)`, `+ track_access()`, `+ track_eviction()`, `+ pinning_hint_for(page) : Optional<TierKind>`, `+ snapshot() : ResidencyMap`

**`<<concept>> IHeuristic<H>`** (Lila, gross unten — komplette Breite)
- **Attribute (protected):** `# live_model_ : ILivePlatformModel&`, `# property_set_ : PlatformPropertySet const&`
- **Methoden (public abstract):**
  - `+ recommend(input : HeuristicInput const&) : Recommendation`
  - `+ estimated_value(input : HeuristicInput const&) const : double`
  - `+ confidence() const noexcept : double  (0.0-1.0)`
  - `+ heuristic_kind() const noexcept : HeuristicKind`
- **Konkretisierungen (~80, siehe 13 §8):** LargestL3CcdPinning (allgemein, ersetzt X3DAware) / HotPathOnHighIpcCore (allgemein, ersetzt IntelHybridP) / CacheCostDPHeuristic (P05) / WidthCostModel (P13) / ProbabilityLayout (P16) / StrideVsSequential (P32) / CacheCoherenceCost (P28 Block AN) / usw.

---

## E) KONZEPTE AUS REV3 IN REV4 VERFEINERT/ERWEITERT/KORRIGIERT

| Bereich | REV3 | REV4 Verfeinerung |
|---------|------|-------------------|
| ICacheStrategy Visitor | nur `visit(read_op)`, `visit(write_op)` | **+ `visit(layout_op : PageLayoutOp&)`** als dritter Visit-Slot |
| Concept-Methoden-Detail | Stichworte | vollstaendige UML-Signaturen mit Returntypen + Modifier (`const`, `noexcept`, `override`) |
| Sichtbarkeitskonventionen | implizit | explizite UML-Konvention `+/#/-/~` (public/protected/private/package-using) |
| ISearchPagesStrategyPattern | 10 Patterns aufgelistet | + `per_page_strategies_ : map<PageId, ISearchPageStrategy&>` als konkrete Attributstruktur + `assign_strategy/strategy_for/visit_assignments` API |
| IStrategyCommand | abstrakt mit 2 Methoden | + `command_kind()`, `estimated_cost()`, `virtual ~IStrategyCommand() = default` (RAII-Korrektheit) |
| HybridCompositionCommand | Sammler mit parts | + `composition_id_ : CompositionId`, `unique_ptr`-Ownership, `add_part/remove_part/part_count` API |
| ICompositionRule | 4 Subklassen aufgelistet | + `apply()`, `rule_kind()`, `supports_parallel()` API + ConditionPredicate/DepthLimit Parameter |
| IPlatformPropertyClassifier | bool-Properties (asymmetric_l3, hybrid_cores) | + `has_hbm_tier`, `usable_simd_width`, `has_software_prefetch`, `coherence_cost_threshold` (7 Properties) |
| ICacheEngineOptionPublisher | nur publish_options_to() | + `register_module/unregister_module/filter_options_for/properties` (vollstaendige Module-Lifecycle-API) |
| ICacheLevel | size, latency, bandwidth | + `tier_kind : enum L1/L2/L3/HBM/V_CACHE`, + `measured_at(timestamp) : MeasureSnapshot` (Telemetry-Integration) |
| ICacheTopology | levels + asymmetric_l3 | + `per_ccd_ : map<CcdId, ICacheLevel&>` als CCD-Aware-Storage, + `largest_l3_ccd()`, + `tier_for(ptr) : Optional<TierKind>` |
| ICacheResidency | nur Konzept | + `pinning_hint_for(page) : Optional<TierKind>` + `snapshot() : ResidencyMap` (Live-Decision-API) |
| IHeuristic | nur Liste | + `confidence() : double 0.0-1.0` (NEU: probabilistische Heuristik-Bewertung), + `live_model_` / `property_set_` Attribute, + `HeuristicInput`/`Recommendation` Returntypen |
| Verzeichnisstruktur | linear pro Concept | Matrix-Achsen pro Concept (`visitor_variants/` + `families/<f01>/<paper>.hpp`) |
| Verbindungslinien | mehrheitlich diagonal | konsequent orthogonal (UML-konform) |

---

## F) FUTURE-PROOF-KONSEQUENZEN FUER REV5 (zwingend)

### F.1 Strukturelle Pflicht-Aufnahmen
1. **MX1-Konzept beibehalten** als eigener Tab (Layer-vs-Matrix Erklaerung); REV5 darf NICHT zur reinen Layer-Sicht zurueckkehren
2. **Tab-Praefix-Konvention** (K/U/MX) als verbindliches Tabbenennungsschema fortfuehren
3. **DSM** als Phase-6+ Werkzeug architektonisch verankern (separater Tab oder Anhang in REV5)
4. **Kontrast-Korrektur:** REV4-MD nennt explizit "noch nicht final reviewed wegen Kontrast" — REV5 muss menschen-lesbaren Farbkontrast garantieren (alle Text-auf-Hintergrund-Paare mindestens WCAG AA, Schwarz-auf-Weiss oder Weiss-auf-tiefem-Hintergrund; helle Pasteltoene als Hintergrund nur mit dunkler Schrift)

### F.2 Concept-Erweiterungen (Open/Closed-Pflicht)
5. **ICacheStrategy::visit(layout_op : PageLayoutOp&)** in REV5 dokumentieren (Layout-Operation als gleichwertiges Visitor-Ziel neben read/write)
6. **IHeuristic::confidence() : double** als probabilistische API in alle Heuristik-Konkretisierungen propagieren
7. **PlatformPropertySet** auf 7 Properties erweitern (has_hbm_tier, usable_simd_width, has_software_prefetch, coherence_cost_threshold zusaetzlich zu den 3 REV3-Properties)
8. **CompositionRule-Konkretisierungen** mit Parametern (ConditionPredicate, DepthLimit) detaillieren
9. **HybridCompositionCommand** Ownership-Modell (`unique_ptr` statt `vector<IStrategyCommand*>`) als Pflicht-Konvention

### F.3 Verzeichnis-Konvention (Modular-Architecture-Pflicht)
10. Verbindliche Pfad-Konvention: `<layer>/concepts/i_<concept>.hpp` + `<layer>/<concept_plural>/<axis_name>/<family_name>/<concretization>.hpp`
11. Pro Concept genau 2 Achsen-Dimensionen (Compile-Time-Composition); mehr Dimensionen werden via Sub-Verzeichnisse repraesentiert
12. **Heuristik-Kategorisierung** (5 Kategorien: prefetch / layout / coherence / platform / isa) als Verzeichnis-Struktur in `cache_engine/heuristics/concrete/`

### F.4 API-First Pflicht in REV5
13. JEDE neue Klasse zuerst als `<<concept>>` mit Methoden-Signaturen (UML), erst danach Konkretisierung
14. Concept-Aenderungen verlangen Architektur-Korrekturrunde (REV5→REV6 Konvention beibehalten)
15. **Stable contracts:** `i_*.hpp`-Header sind die einzigen public-Includes; alle anderen `*.hpp` sind privat zur Achse

### F.5 Dokumentations-Pflicht in REV5-MD
16. Sektion §1 Layer+Matrix Hybrid mit Beispiel-Verzeichnis-Baum
17. Sektion §2 Future-Proof-Prinzipien mit den 7 Prinzipien (Open/Closed, Modular, Encapsulation, SRP, SoC, API-First, DSM)
18. Sektion §3 Variablen-/Methoden-Schema-Standard-Layout (UML-Konvention) als Referenz fuer alle U-Tabs
19. Tab-Tabelle (REV4 §4) mit allen K/U/MX-Tabs als Inhaltsverzeichnis
20. Verzeichnis-Vollstruktur (REV4 §5) als Phase-6+-Implementations-Vorlage

### F.6 Forschungs-Mission-Konsistenz
21. K06 (Forschungs-Mission F15) unveraendert uebernehmen — drei Modi (HEURISTIC_STATIC / INFORMED_KALIBRIERT / AUTOMATIC_ADAPTIVE) bleiben Diplomarbeits-Wurzel-These
22. F15-Mathematik (29 × 4 × 80 = ~10.000; ×3 = ~30.000; ConstraintFilter ~500-1000 valid) in REV5 erneut validieren gegen aktualisierte Cache-Familien-Anzahl

### F.7 17 Hybrid-Commands (vollstaendigkeit)
23. Alle 17 nummerierten HybridCompositionCommand-Konkretisierungen in REV5 erhalten (REV4 K04 bzw. U04 hint-Box)
24. Die expliziten Atom-Listen pro Paper (P02/P03/P04/P06/P07/P10/P22/P26/P28) in REV5-K04 beibehalten — sie sind die Bruecke zwischen Cluster-Tieflektuere und Architektur

### F.8 Visualisierung / Drawio-Hygiene
25. ASCII-only in value-Attributen (keine `"`, `„`, `"`)
26. `edgeStyle=orthogonalEdgeStyle` mit explizitem exit/entry fuer alle Edges
27. Python `xml.etree.ElementTree`-Validierung VOR dem Push in REV5
28. Farbkontrast: Schrift mind. #000000 oder #FFFFFF; Hintergrund-Helligkeit gegen Schrift mind. 4.5:1 Kontrastverhaeltnis (WCAG AA)

---

## Zusammenfassung

REV4 hat 3 Hauptbeitraege ueber REV3 hinaus:
1. **Layer-Matrix-Hybrid** (MX1) als architektonische Antwort auf F15-Permutations-Skalierung
2. **7 Future-Proof-Prinzipien** (Open/Closed, Modular, Encapsulation, SRP, SoC, API-First, DSM) explizit aus Web-Recherche dokumentiert + auf PRT-ART angewendet
3. **Vollstaendige UML-Signaturen** in 6 U-Tabs mit Variablen, Methoden, Sichtbarkeiten, Konstraints (vorher nur Stichworte)

Zusaetzlich: drawio-XML-Korrektheit, orthogonale Edges, Tab-Typisierung K/U/MX.

REV5 muss diese 3 Beitraege erhalten + Kontrast-Korrektur leisten + Concept-Erweiterungen (visit_layout_op, confidence(), 7-Property PlatformPropertySet) propagieren.
