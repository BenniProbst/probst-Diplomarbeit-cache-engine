# Korrektur-Architektur-Skizze 2026-05-09

> **HINWEIS — Korrektur-Runde 3 (2026-05-10) ergaenzt am Anfang dieses Dokuments.**
> Die ursprueng­liche REV-2-Skizze (Stand 2026-05-09) bleibt unten erhalten und wird durch die folgenden vier Korrekturen verfeinert. Es wird KEIN Inhalt geloescht — nur erweitert + an Schluesselstellen inline-praezisiert.

---

# KORREKTUR-RUNDE 3 (2026-05-10) — 4 Praezisierungen ohne Loeschen

**Quelle:** Architekt-Korrektur 2026-05-10 nach Pruefung der Konsolidierungs-Dateien `11_cache_strategy_taxonomie.md`, `12_algorithmus_strategie_taxonomie.md`, `13_saeule_b_plattform_modell_konkretisierung.md` und der 6 Cluster-Dateien.

## K3.1 — IExecutingEngine als Wurzel-Abstraktion ueber ISearchEngine

**Heute:** Die Architektur kennt nur eine ISearchEngine als Konsumentin der CacheEngine.

**Korrektur:** Die ISearchEngine ist eine SPEZIALISIERUNG einer allgemeineren `IExecutingEngine`. Andere Engines (z.B. ICompactingEngine, IDeduplicationEngine, IRetentionEngine, ...) werden in Zukunft ebenfalls die CacheEngine als Optimierungs-Service nutzen.

```
«concept» IExecutingEngine                              (allgemeine Wurzel-Abstraktion)
   - holds: reference to CacheEngine (optional)         (CacheEngine wird zur Verfuegung gestellt)
   - generic API: execute<Op>(operation : Op&) : Result
   - exposes: telemetry hooks fuer DecisionLambdaTrees
   - exposes: lifecycle (warm_up, reset, shutdown)
   - subclasses are Engine-Familien

«concept» ISearchEngine : IExecutingEngine               (Spezialisierung)
   - composes: IRootPage, IFanout, INode, ISearchPage, ICachePage
   - composes: ISearchPagesStrategy, ISearchPagesStrategyPattern, ISearchPageStrategy
   - composes: ICacheStrategy (Visitor)
   - subscribes: comdare::prt_art<K,V>::iterator family

«concept» IFutureEngine : IExecutingEngine               (Platzhalter)
   - z.B. ICompactingEngine, IDeduplicationEngine, ISortingEngine
   - keine Implementierung in PRT-ART-Diplomarbeit, aber Architektur-Slot frei
```

**Verzeichnis-Korrektur (war: `search_engine/concepts/...`):**

```
executing_engine/                                         (NEU — Wurzel-Schicht)
├── concepts/
│   ├── i_executing_engine.hpp                            (Wurzel-Abstraktion)
│   └── i_engine_lifecycle.hpp
├── search_engine/                                        (Spezialisierung 1)
│   ├── concepts/
│   │   ├── i_search_engine.hpp  : public IExecutingEngine
│   │   ├── i_root_page.hpp ... (alle Saeule-A-Concepts wie REV 2)
│   │   └── iterators/...
│   ├── adapters/                                         (siehe ext/<paper>/<repo>/)
│   └── prt_art/
│       └── pages/, nodes/, strategies/
└── future_engines/                                       (Platzhalter, leer in PRT-ART)
    └── README.md: "Architektur-Slot fuer kuenftige Engines, die CacheEngine nutzen"
```

**Wirkung auf REV-2-Saeule-A (unten):** `IRootPage` bleibt wie ist, aber das Wurzel-Konzept ist jetzt `IExecutingEngine` mit `ISearchEngine` als Konkretisierung. Der CacheEngine-Slot ist von der Wurzel `IExecutingEngine` aus zugaenglich (per Composition oder dependency injection).

---

## K3.2 — Cache-Engine: Plattform-AUTO-DISCOVERY statt plattform-spezifischer Klassen

**Heute (FALSCH):** In `13_saeule_b_plattform_modell_konkretisierung.md` und in der Skizze werden konkrete Klassen wie `RyzenX3DProbe`, `IntelHybridProbe`, `X3DAwareFactory`, `IntelHybridPCoreScheduler` modelliert. Das ist eine konkrete Implementierung pro CPU-Generation.

**Korrektur:** Die Cache-Engine darf KEINE plattform-spezifischen Klassen tragen. Stattdessen:

1. **CacheEngineBuilder** fuehrt **Auto-Discovery** ALLER Cache-Eigenschaften der Plattform durch (Cache-Hierarchie, V-Cache-CCDs, Hybrid-Cores, Bandbreiten, ISA-Features).
2. CacheEngineBuilder fuehrt **automatische Vermessung** der Eigenschaften durch (Latenzen, Bandbreiten, Cache-Coherence-Cost-Funktion).
3. Daraus entstehen **klassifizierte Cache-Eigenschaften** als Properties (`PlatformProperty<T>`).
4. Diese Properties werden den **kompilierten Such-Algorithmus-Permutationen als Konfigurations-Optionen bereitgestellt** (compile-time bei statischer Engine, runtime bei adaptive Engine).
5. Die Cache-Engine waehlt SELBST die schnellste Rekombination der verfuegbaren Optionen.

```
«concept» IPlatformProbe                                 (allgemein, OHNE CPU-Spezialisierung)
   - discover_cache_topology() : ICacheTopology
   - discover_core_layout() : ICoreLayout
   - discover_isa_features() : IIsaFeatureSet
   - discover_interconnect() : IBusTopology
   - measure_cache_latencies() : map<TierPair, Cycles>
   - measure_bandwidths() : map<InterconnectId, Gbps>
   - measure_cache_coherence_cost() : CoherenceCostFunction
   - measure_pinning_effects() : map<PinningPolicy, Speedup>
                                  (probiert ALLE moeglichen Pinning-Varianten + misst)

«concept» IPlatformPropertyClassifier                    (NEU — die Konsequenz aus Auto-Discovery)
   - classify(probe_results) : PlatformPropertySet
   - PlatformPropertySet enthaelt z.B.:
       * has_asymmetric_l3 : bool   (entdeckt durch Vermessung, nicht via "Ryzen X3D")
       * has_hybrid_cores  : bool   (entdeckt, nicht via "Intel Hybrid")
       * preferred_pinning : PinningPolicy  (gewaehlt aus Vermessungs-Ergebnis)

«concept» ICacheEngineOptionPublisher                    (NEU — Bereitstellung an Permutationen)
   - publish_options_to(permutation_modules : list) : void
   - jede Permutation erhaelt nur die Optionen, die ihre Bausteine
     tatsaechlich konsumieren koennen (compile-time-gefiltert via Concepts)
```

**Korrektur-Beispiele in `13_saeule_b_plattform_modell_konkretisierung.md`:**

| Bisheriger Eintrag (FALSCH) | Korrigierter Eintrag (RICHTIG) |
|-----------------------------|--------------------------------|
| `RyzenX3DProbe` Klasse | `IPlatformProbe` entdeckt `cache_topology.l3_per_ccd` Map mit verschiedenen Werten ⇒ `has_asymmetric_l3 = true` als Property |
| `IntelHybridProbe` Klasse | `IPlatformProbe` entdeckt `core_layout.core_classes` mit mehreren Klassen ⇒ `has_hybrid_cores = true` als Property |
| `X3DAwareFactory` | `IPlatformPropertyClassifier` liefert `preferred_pinning = LARGEST_L3_CCD` (gewaehlt durch Messung, nicht hard-coded) |
| `X3DVCachePinningHeuristic` | `LargestL3CcdPinningHeuristic` (allgemeine Heuristik fuer asymmetrisches L3, nicht CPU-spezifisch) |
| `IntelHybridPCoreRoutingHeuristic` | `HotPathOnHighIpcCoreHeuristic` (allgemeine Heuristik fuer Cores mit hoeherer IPC, nicht CPU-spezifisch) |

**Wirkung:** Block AO (Production-Plattform Ryzen 9950X3D + i9-14900KS) bleibt als KONKRETIONS-BEISPIEL fuer die Auto-Discovery — die Plattformen werden vom IPlatformProbe entdeckt, nicht hard-coded modelliert. Die CacheEngine ist generisch fuer JEDE Plattform.

---

## K3.3 — Cluster-Aufloesung: A + B = EINE Familie (Algorithmus-Konfigurationspakete)

**Heute (FALSCH):** Cluster A (Trie-Familie) und Cluster B (Hybrid + B+-Familie) werden als unterschiedliche Familien dargestellt. Das gilt fuer den klassischen Sprachgebrauch (Trie vs B+).

**Korrektur:** Die Forschungs-These der Diplomarbeit ist gerade, dass diese „Familien" nur unterschiedliche **Rekombinations-Pakete** der gleichen atomaren Bausteine sind. Was klassisch als „Trie" bezeichnet wird, ist heute eine **zusammengesetzte Strategie** aus einem Basis-Subset von Methoden-Bausteinen, die wir in dieser Arbeit:
- aufschluesseln,
- einzeln verallgemeinert vergleichen,
- gegen die Bausteine anderer „Familien" austauschen koennen.

**Konsequenz fuer die Cluster-Files (`cluster_A_trie.md`, `cluster_B_hybrid_bplus.md`):**
- Inhaltlich nichts loeschen.
- Hinzufuegen: Einleitungs-Hinweis „**Diese Cluster-Bezeichnungen sind nur das Gruppierungs-Werkzeug fuer die Lektuere — die hier gelisteten Algorithmen sind Konfigurations-Pakete, deren atomare Bausteine in `11_cache_strategy_taxonomie.md` und `12_algorithmus_strategie_taxonomie.md` einzeln katalogisiert sind**".

**Konsequenz fuer `12_algorithmus_strategie_taxonomie.md`:**
- Im B+- bzw. Trie-Familien-Abschnitt der `ISearchPagesStrategy`-Liste eine Vorbemerkung einfuegen, dass die Familien-Bezeichnungen `BPlus*Strategy` / `Trie*Strategy` Sammel-Bezeichner sind, deren Bausteine ueber die Pattern + Page-Strategy + Heuristic-Achsen frei rekombiniert werden koennen.

**Konsequenz fuer `11_cache_strategy_taxonomie.md`:**
- Die 29 Familien sind genau die schichtweise Zerlegung der Rekombinatorik — die Taxonomie ist also bereits korrekt strukturiert.
- Hinzufuegen: Einleitungs-Hinweis dass die Familien orthogonal zu den Algorithmus-Paketen sind und ueber alle Paket-Bezeichnungen hinweg permutierbar.

---

## K3.4 — Hybrid-Familien IMMER als Command-Pattern aufgliedern

**Heute (TEILWEISE):** Einige Hybrid-Strategien (z.B. LOUDS-Dense + LOUDS-Sparse Cutoff in P10 SuRF, HOT-Compound mit BiNode-Subtree in P02, B²-Tree Decision-Page + Span-Page in P06, Wormhole Triple-Layer Hash+B+/LinkedList in P07) sind in den Familien als monolithische Hybrid-Konzepte vermerkt.

**Korrektur:** Bei JEDER Hybrid-Familie aus mehreren direkt zusammengeschlossenen Strategien:
1. **Aufgliedern** in einzelne atomare Strategien (Command-Objekte)
2. **Zusammensetzen** unter einem **generellen Command-Pattern** (HybridCompositionCommand)
3. **Einzeln testbar** machen — jeder Bestandteil als eigenstaendiger Permutations-Baustein
4. **Konkret benennen** der atomaren Bestandteile und des Composition-Commands

**Schema:**
```
«abstract» IStrategyCommand                              (Command-Pattern Wurzel)
   + execute(context : StrategyContext&) : Result
   + can_compose_with(other : IStrategyCommand&) : bool

«composite» HybridCompositionCommand : IStrategyCommand  (NEU — Sammler)
   - parts : vector<IStrategyCommand*>
   - composition_rule : ICompositionRule           (sequenziell, parallel, conditional ...)
   + execute(context) : Result                     (orchestriert die Bestandteile)
```

**Konkrete Hybrid → Command-Pattern Aufloesungen (Pflicht-Pruefung in 11/12):**

| Quelle | Bisher monolithisch | Zerlegen in atomare Commands | Hybrid-Composition |
|--------|---------------------|------------------------------|--------------------|
| P10 SuRF Dense+Sparse | `LOUDSDenseSparseHybridStrategy` | `LoudsDenseEncodingCommand` + `LoudsSparseEncodingCommand` | `CutoffLevelLoudsCompositionCommand` (mit Cutoff-R-Decision) |
| P02 HOT Compound+BiNode | `HOTCompoundHybridStrategy` | `CompoundContainerCommand` + `BiNodeSubtreeCommand` + `PartialKeyMaskingCommand` (Single+Multi) | `HOTCompoundCompositionCommand` |
| P07 Wormhole Hash+B++LL | `WormholeTripleLayerHybridStrategy` | `HashAnchorLookupCommand` + `BPlusHopLookupCommand` + `LeafLinkedListScanCommand` | `TripleLayerLookupCompositionCommand` |
| P06 B²-Tree Decision+Span | `B2TreeDecisionSpanHybridStrategy` | `DecisionPageStrategyCommand` + `SpanPageStrategyCommand` | `B2TreeRecursiveCommonPrefixCompositionCommand` (gem. P06 Sec. 3.1.1) |
| P04 CoCo Macro+Patricia | `CoCoMacroPatriciaHybridStrategy` | `MacroNodeCollapseCommand` + `PatriciaInnerExpandCommand` + `SuccinctEncodingPoolCommand` | `CoCoLevelLDecisionCompositionCommand` |
| P03 Masstree Slice+B+ | `MasstreeSliceBPlusHybridStrategy` | `SliceLayerJumpCommand` + `BPlusPerLayerCommand` + `PermutationFieldInsertCommand` | `MasstreeSliceLayeredCompositionCommand` |
| P20 B-Trees-Are-Back KeyAdapt+OpAdapt | `BTreesAreBackAdaptiveSelectorHybrid` | `KeyAdaptionCommand` (mit Comparison/Fingerprinting Sub-Commands) + `OperationAdaptionCommand` (mit SDL/FDL Sub-Commands) | `BTreesAreBackHeterogeneousAdaptiveCompositionCommand` |
| P28 Kuehn (NEU 2026-05-08) Hot-Path-Layout | `HotPathLayoutHybrid` | `LeafOnlyCounterCommand` + `RetroactiveAggregationCommand` + `GreedyHotPathLayoutCommand` | `KuehnHotPathOptimizationCompositionCommand` |
| P22 Chen Fractal Disk+Cache | `FractalDualTierHybrid` | `DiskTierTraversalCommand` + `CacheTierTraversalCommand` + `DualJumpPointerArrayCommand` | `FractalHierarchicalCompositionCommand` |
| P26 Zhang FGCS 3 Prefetcher | `ThreePrefetcherMixHybrid` | `CachePrefetcherCommand (CP)` + `PathPrefetcherCommand (PP)` + `MonitorPrefetcherCommand (MP)` | `ThreePrefetcherOrchestrationCompositionCommand` |
| P25 Mahling Coro Full+Half-Node | `MahlingCoroutinedPrefetchHybrid` | `CoroutinedFullNodePrefetchCommand` + `CoroutinedHalfNodePrefetchCommand` | `CoroutineSelectionCompositionCommand` |
| P19 Saikkonen Local + Global Reloc | `SaikkonenLocalGlobalRelocHybrid` | `LocalRelocationCommand` (wait-free) + `GlobalRelocationCommand` (BFS-Periodic) | `LayoutInvariantCompositionCommand` |
| ... | (alle weiteren Familien aus 11+12 systematisch pruefen) | ... | ... |

**Vorteil der Auflosung:**
- Permutations-Raum-Erweiterung: Statt 1 monolithischer Strategie haben wir N atomare Bausteine pro Hybrid + 1 Composition-Variante.
- Einzeln testbare Atome: Beweis dass die Composition-Wirkung tatsaechlich aus einer bestimmten atomaren Komponente stammt (Ablations-Studien moeglich).
- Wir verpassen sonst genau die Einzelergebnis-Rekombinationen, auf die F15-Kern-These der Diplomarbeit zielt.

**Konsequenz fuer 11_cache_strategy_taxonomie.md:** Pro hybrid-erkannter Familie eine zusaetzliche Zeile „Command-Pattern-Aufloesung: ..." mit den atomaren Bausteinen + Composition-Command.

**Konsequenz fuer 12_algorithmus_strategie_taxonomie.md:** Pro hybrid-erkannter Strategy/Pattern eine zusaetzliche Zeile gleicher Form. Plus eine neue Sektion „§9 — Hybrid-Command-Pattern-Konvention" als Zusammenfassung.

---

## K3.X — Aenderungs-Liste (Konsequenzen aus K3.1-K3.4)

| Datei | Aenderungs-Typ | Inhalt |
|-------|----------------|--------|
| `10_korrektur_architektur_skizze...md` | Erweiterung am Anfang | Diese 4 Korrekturen + inline-Hinweise an Schluesselstellen |
| `11_cache_strategy_taxonomie.md` | Inline-Hinweise | Pro Hybrid-Familie: Command-Pattern-Aufloesung in einer Tabellen-Zeile |
| `12_algorithmus_strategie_taxonomie.md` | Inline-Hinweise + neue Sektion §9 | Cluster-Aufloesungs-Vorbemerkung (B+/Trie sind Konfigurations-Pakete) + Hybrid-Command-Pattern-Konvention |
| `13_saeule_b_plattform_modell_konkretisierung.md` | Inline-Korrektur | Plattform-spezifische Klassen entfernen / umbenennen in allgemeine Auto-Discovery-Concepts; Block AO als Beispiel-Konkretion fuer die Auto-Discovery |
| `_paper_extractions/cluster_A_trie.md` | Einleitungs-Hinweis | „Sammelbezeichnung fuer Lektuere — Bausteine sind in 11/12 atomar verfuegbar" |
| `_paper_extractions/cluster_B_hybrid_bplus.md` | Einleitungs-Hinweis | dito |

KEINE Loeschungen — alle Inhalte bleiben + werden ergaenzt.

---

# REV 2 SKIZZE (UNVERAENDERT — Stand 2026-05-09)

## Anlass (REV 2)

User-Korrektur zur ersten drawio-Version (`phase5_uml_detail.drawio`) — meine UML war Achsen-Klassifikation (Page/Node/Traversal/...), aber der Architekt erwartet eine **hierarchische Concept-Architektur** mit zwei klar getrennten Saeulen.

**Stand REV 2 (2026-05-09 nachmittag):** Diese Skizze enthaelt Architekt-Korrekturen Runde 2:
1. Multiplizitaeten praezisiert (siehe §1.2)
2. ICacheStrategy als **Visitor-Pattern** mit zwei Konkretisierungen (siehe §1.4)
3. **Cache-Strategien-Verallgemeinerung** ist NOCH NICHT VOLLSTAENDIG — separate Tieflektuere aller 33 Paper laeuft gerade in 6 parallelen Agenten (siehe §8 unten). Die hier aufgelisteten Cache-Strategy-Familien werden nach Agenten-Abschluss verfeinert in `_paper_extractions/`.

Zwei Saeulen:

1. **Saeule A — Suchalgorithmus-Datenstruktur** (Verallgemeinerung der 33 Paper-Algorithmen unter gemeinsamen Daechern)
2. **Saeule B — Cache-Engine-Plattform-Modell** (Echtzeit-Modell der CPU/Caches/Bandbreiten als Grundlage fuer Scheduling + Heuristik)

**Stand:** Skizze, vor drawio-Update — bitte pruefen, ob die Struktur stimmt.

---

## 1. Saeule A — Suchalgorithmus-Hierarchie (KORRIGIERT)

### 1.1 Concept-Hierarchie (Algorithmus-Wurzel ↓ bis Speicher-Repraesentation)

```
«concept» IPage<P>                                     (oberste Abstraktion: jede „Seite" eines Algorithmus)
   ↑ inheritance
«concept» IRootPage<R> : IPage                         (Wurzel-Spezialisierung: Einstiegspunkt eines Such-Algorithmus)
   composes 1 IFanout

«concept» IFanout<F>                                   (Verzweigungs-Abstraktion der Wurzel + innerer Knoten)
   composes [N] INode  via  «contains»

«concept» INode<N>                                     (einzelner Knoten = Verzweigungs-/Daten-Einheit)
   placed on ISearchPage  via  «mapped via ISearchPageStrategy»

«concept» ISearchPage<S>                               (logische Such-Seite — abstrahiert die Knoten-Anordnung)
   contains [N] INode
   mapped onto ICachePage[s]  via  «ICacheStrategy»

«concept» ICachePage<C>                                (physische Speicher-Repraesentation einer Such-Seite)
   - size : size_t                                      (Page-Groesse, z.B. 64 B / 256 B / 4 KiB / 2 MiB)
   - cache_line_formation : CacheLineFormation          (wie liegt das Page-Layout auf Cache-Lines?)
   - influenced_by : CacheEngine                        (CacheEngine beeinflusst Formation aktiv)

«concept» ICacheStrategy<CS>                           (steuert Abbildung ISearchPage → ICachePage[s])
   - decides: cache_line_formation
   - decides: page_size
   - decides: tier (L1/L2/L3/HBM/V-Cache, siehe Saeule B)
```

### 1.2 Strukturelle Anordnung mehrerer Such-Seiten

```
«concept» ISearchPageStructure<SS>                     (ORDNUNGS-Container fuer mehrere ISearchPage)
   contains [N] ISearchPage  in geordneter Abfolge
   ordering controlled by  ISearchPagesStrategy

«concept» ISearchPagesStrategy<SPS>                    (POLICY: steuert Aufbau/Pflege der ISearchPageStructure)
   - controls: insertion of new ISearchPage
   - controls: removal of obsolete ISearchPage
   - controls: re-ordering / consolidation
   - delegates per-page entry handling via  ISearchPagesStrategyPattern

«concept» ISearchPagesStrategyPattern<SSP>             (PATTERN: Anordnungs-Vorschrift)
   ★★ KORREKTUR REV 2: Multiplizitaeten praezisiert ★★
   - IFanout  has  EXACTLY 1  ISearchPagesStrategyPattern    (eindeutig pro Fanout)
   - ISearchPagesStrategyPattern  has  N  ISearchPageStrategy  (eine pro ISearchPage)
   - assigns: which ISearchPageStrategy applies to which ISearchPage in the Structure
   - examples (aus Papern):
       * „all-pages-uniform"      (P11 CSS, P12 CSB+ — gleiche Strategie fuer alle Seiten)
       * „layer-mix"              (P03 Masstree — pro Layer eine andere Strategie)
       * „inner-vs-leaf"          (P10 SuRF — LOUDS-Dense oben, LOUDS-Sparse unten;
                                              P04 CoCo — Macro-Node oben, Patricia unten)
       * „hot-vs-cold"            (P26 Zhang FGCS — Hot-Pages eigene Strategie)
       * „dynamic-rebalance"      (P05 START — Tag-Manager schaltet Strategien um)

«concept» ISearchPageStrategy<SP>                      (POLICY: steuert Eintraege in EINE ISearchPage)
   - controls: where in the page key-value goes
   - controls: when to split/merge the page
   - controls: layout invariants
   ★ MULTIPLIZITAET: 1 ISearchPageStrategy pro 1 ISearchPage; ISearchPagesStrategyPattern hat N davon ★
```

### 1.4 ICacheStrategy als Visitor-Pattern (KORREKTUR REV 2)

```
«concept, visitor» ICacheStrategy<CS>                  (Visitor — entscheidet Read/Write-Pfad pro Page-Op)
   ★★ KORREKTUR REV 2: Visitor-Pattern mit ZWEI Konkretisierungen ★★
   - visit(read_op : PageReadOp&) : void
   - visit(write_op : PageWriteOp&) : void

«concrete» BaseEngineStrategy : ICacheStrategy
   - ruft die NICHT-OPTIMIERTE Read/Write-Variante auf
   - StaticEngine-Pfad: Originalcode-Bauteil ohne CacheEngine-Beeinflussung
   - Baseline fuer F15-Vergleich (Pflicht-Vergleichsbasis pro Permutation)
   - keine ILivePlatformModel-Konsultation; keine Heuristik-Aufrufe

«concrete» CacheEngineStrategy : ICacheStrategy
   - ruft die CACHEENGINE auf, um Speicher-optimiert zu lesen/schreiben
   - konsultiert ILivePlatformModel + ICacheResidency + IHeuristic (Saeule B)
   - kann Read/Write umrouten auf besseres Cache-Tier (L1/L2/L3/HBM/V-Cache)
   - kann Page-Layout vor Write rearrangieren (cache_line_formation aendern)
   - Forschungs-Pfad fuer F15-Vergleich

ABBILDUNG ISearchPage → ICachePage[s] passiert IMMER ueber eine ICacheStrategy:
   - In der StaticEngine-Konfiguration: BaseEngineStrategy
   - In der CacheEngine-Konfiguration: CacheEngineStrategy
   - Die Wahl ist Compile-Time (Engine-Choice, Domaenenmodell §1B)
```

### 1.3 Iteratoren (orthogonale Schicht, vom User explizit verlangt)

```
«concept» INodeIterator<NI>                            (ueber INode-Mengen — z.B. visit_each_child)
«concept» ISearchPageIterator<SI>                      (ueber ISearchPage in einer Structure)
«concept» ISearchPageStrategyIterator<SSI>             (ueber Strategien — z.B. fuer Cross-Algorithm-Vergleich)

class comdare::prt_art<Key, Value>
   + iterator
   + const_iterator
   + range_iterator
   + key_iterator
   + value_iterator
   ' kompatibel zu std::map-API (Architekturentscheidung Domaenenmodell §1A)
```

---

## 2. Saeule B — Cache-Engine-Plattform-Modell (NEU, fehlte komplett)

### 2.1 Speicher-Hierarchie (Caches + Memory)

```
«concept» ICacheLevel<L>                               (eine einzelne Cache-Ebene: L1/L2/L3/HBM/V-Cache)
   - size : bytes
   - line_size : bytes                                  (typ. 64 B)
   - associativity : int
   - latency_cycles : double
   - bandwidth_gbps : double

«concept» ICacheLine<CL>                               (eine Cache-Line; Granularitaet der Caches)
   - data : array<byte, line_size>
   - residency : ICacheLevel*                           (wo aktuell residiert)
   - state : MESI/MOESI                                 (aus P29 RCU + P30 Hazard verwandt)

«concept» ICacheTopology<CT>                           (gesamte Cache-Hierarchie der Plattform)
   contains [N] ICacheLevel  in Hierarchie-Reihenfolge
   - asymmetric_l3 : bool                               (Block AO Ryzen 9950X3D V-Cache)
   - per_ccd : map<CcdId, ICacheLevel>

«concept» ICacheResidency<CR>                          (laufende Wo-ist-was-Modellierung — „Cache whereabouts")
   - tracks: which ICacheLine is in which ICacheLevel
   - tracks: which ICachePage (Saeule A) is mapped to which ICacheLevel
   - updated_by: live measurement (perf-Counter, P28 Kuehn-Histogram-Inspiration)
```

### 2.2 CPU-Kern-Modell

```
«concept» ICpuCore<C>                                  (ein einzelner CPU-Kern)
   - core_id : CoreId
   - core_class : enum {P_CORE, E_CORE, ZEN5_X3D_CCD0, ZEN5_X3D_CCD1, ARM_PI5, ...}
   - assigned_caches : list<ICacheLevel*>               (welche Cache-Ebenen sieht der Kern?)
   - hyperthreading : optional<HtSibling>

«concept» ICoreLayout<CL>                              (gesamte Kern-Topologie der Plattform)
   contains [N] ICpuCore
   - p_core_count / e_core_count                        (Block AO i9-14900KS Hybrid-CPU)
   - ccd_count                                          (Block AO Ryzen 9950X3D)

«concept» ICoreToThreadMap<CTM>                        (Mapping Threads → Kerne, „CPU Kern mapping")
   - pinning_policy : IPinningPolicy
   - current_assignment : map<thread::id, CoreId>
   - rebalance_trigger : ConsolidationBarrierEvent

«concept» IPinningPolicy<P>                            (Strategie fuer Thread-Kern-Zuordnung)
   - examples:
       * „V_CACHE_CCD" (Block AO Ryzen — Hot-Path-Threads auf V-Cache-CCD0 pinnen)
       * „P_CORE"      (Block AO i9 Hybrid — Hot-Path auf P-Cores)
       * „NUMA_LOCAL"  (P25 Mahling NUMA-aware)
       * „ROUND_ROBIN" (Default)
```

### 2.3 Hardware-Erweiterungen (ISA-Features)

```
«concept» IHardwareExtension<HX>                       (eine ISA-Feature-Bank, z.B. AVX-512, BMI2, NEON)
   - feature_name : string
   - bit_position : int                                 (in IsaFlagBank, F10-K)
   - cost_model : map<Operation, Cycles>                (fuer Heuristik-Berechnung)

«concept» IIsaFeatureSet<IFS>                          (gesamte ISA-Feature-Verfuegbarkeit)
   contains [N] IHardwareExtension
   - x86_features : SseAvxBmiSet
   - arm_features : NeonSveSet
   - riscv_features : RiscVVSet
```

### 2.4 Kommunikations- + Bandbreitenverbindungen

```
«concept» IInterconnect<IC>                            (Verbindung zwischen Komponenten — CCD↔CCD, Core↔Cache, Cache↔Memory)
   - source : Node*                                     (CCD/Core/Cache/MemController)
   - target : Node*
   - bandwidth_gbps : double
   - latency_ns : double
   - link_class : enum {INTRA_CCD, INTER_CCD, MEMORY_BUS, NUMA_LINK, PCIE, NVLINK}

«concept» IBusTopology<BT>                             (gesamte Bus-/Interconnect-Topologie)
   contains [N] IInterconnect
   - models: Inter-Chiplet-Links (Block AO Ryzen Infinity Fabric)
   - models: Hybrid-CPU intra-cluster (Block AO i9 Ring-Bus)

«concept» IMemoryBandwidthModel<MBM>                   (Bandbreiten-Modell, „Bandbreitenverbindungen")
   - per_link_capacity : map<IInterconnect*, double>
   - current_utilization : map<IInterconnect*, double> (Live-Messung via perf)
   - bottleneck_detection : function
```

### 2.5 Echtzeit-Modell der Plattform (das „Gesamtbild")

```
«concept» ILivePlatformModel<LPM>                      (das ECHZEIT-Modell, das die CacheEngine pflegt)
   composes:
      cache_topology : ICacheTopology
      cache_residency : ICacheResidency               (waehrend Lookup-Workload aktualisiert)
      core_layout : ICoreLayout
      core_thread_map : ICoreToThreadMap
      isa_features : IIsaFeatureSet
      bus_topology : IBusTopology
      bandwidth_model : IMemoryBandwidthModel
   - update_period : milliseconds                       (z.B. 100 ms-Tick)
   - update_source : perf-Counter / sysfs / cpuid

«concept» ILiveCpuModel<LCM>                           (Live-Sicht auf Per-Core-Lasten)
   - per_core_utilization : map<CoreId, double>
   - per_core_cache_pressure : map<CoreId, double>
   - per_core_hot_path_score : map<CoreId, double>
```

### 2.6 Scheduling + Heuristik (auf dem Live-Modell)

```
«concept» IScheduler<S>                                (entscheidet Thread-zu-Kern + Task-zu-Tier)
   - input: ILivePlatformModel
   - output: ICoreToThreadMap-Updates + ICacheResidency-Hints
   - reacts_to: SchedulingEvent (siehe ObserverRegistry)

«concept» IHeuristic<H>                                (Heuristische Berechnungen auf dem Live-Modell)
   - input: ILivePlatformModel + ISearchPagesStrategy-State
   - output: Recommendations → DecisionLambdaTrees
   - examples:
       * „Cache-Coherence-Cost-Heuristic" (Block AN Kuehn — siehe CoherenceAwareWriteDecisionTree)
       * „X3D-V-Cache-Pinning-Heuristic"  (Block AO Ryzen)
       * „Hybrid-CPU-Routing-Heuristic"   (Block AO i9)
       * „Hot-Page-Migration-Heuristic"   (Saeule A: ISearchPagesStrategy → ICacheStrategy)
```

---

## 3. Verbindung Saeule A ↔ Saeule B (das Forschungs-Herz von PRT-ART)

```
ISearchPage  ──gemappt durch──>  ICacheStrategy  ──erzeugt──>  ICachePage[s]
                                       ↑
                                       │ beeinflusst von
                                       │
                              ILivePlatformModel  +  IHeuristic  +  IScheduler
                                                         (alle in Cache-Engine)

ISearchPagesStrategy  ──liest──>  ICacheResidency  (aus Saeule B)
                       ──ruft──>  IHeuristic       (aus Saeule B)
                       ──schreibt──>  ISearchPageStructure (Re-Ordering)

DecisionLambdaTrees (siehe 02_uml_cache_engine.md §2)
   ──route Events zwischen──  Saeule A (ISearchPagesStrategy)  ↔  Saeule B (IHeuristic)
```

**Trennungsprinzip:** Saeule A weiss NICHT direkt von CPU-Kernen / Cache-Lines / Bandbreiten. Sie konsumiert nur das Live-Modell ueber `IHeuristic` + `ICacheStrategy`. Das ist die formelle Trennung „Suchalgorithmus-Bausteine ↔ Cache-Engine-Modellierung", die der Architekt verlangt.

---

## 4. Cross-Reference zu allen 33 Papern (Verallgemeinerungs-Beleg)

| Paper | Konkrete Implementierung | Verallgemeinert als |
|-------|---------------------------|---------------------|
| **P01 ART** | Node4/16/48/256 + Pfad-Compression + Lazy Expansion | INode (4 Spezialisierungen), ISearchPage (eine Page = ein Knoten), ISearchPagesStrategy „all-pages-uniform" |
| **P02 HOT** | Compound Node mit BiNode-Subtree + Discriminative Bits + Single/Multi-Mask | INode (HOT-Compound), IFanout (Compound enthaelt ≤32 INode), ISearchPagesStrategy „inner-vs-leaf" |
| **P03 Masstree** | B+-Tree-of-Trie, 8-Byte-Slices, Permutation-Field | ISearchPagesStrategyPattern „layer-mix", ISearchPageStrategy mit Permutation-Field, INodeIterator ueber Slices |
| **P04 CoCo-trie** | Macro-Node = kollabierter Subtrie, Pool succinct encodings | ISearchPagesStrategyPattern „inner-vs-leaf" (Macro oben, expandiert unten), ICacheStrategy „succinct-bit-vector-on-cache-line" |
| **P05 START** | Multilevel Nodes, Rewired64K/16M, Tag-Manager, Cache-Cost-DP | ISearchPagesStrategy „dynamic-rebalance" (Tag-Manager), IHeuristic (Cache-Cost-DP-Optimizer), IPinningPolicy (Rewiring) |
| **P06 B²-tree** | Decision Page (byte-decision) + Span Page (prefix-span) + B+-Outer | IRootPage (B+-Outer), ISearchPagesStrategyPattern „all-pages-uniform per Layer" + Inner-Layer-spezifisch (Decision/Span) |
| **P07 Wormhole** | Anchor-Hash + B+-Hop + Leaf-LinkedList (Triple-Layer) | IRootPage (Anchor-Hash), 3 ISearchPagesStrategy in einer ISearchPagesStrategyPattern „layer-mix" |
| **P09 Jacobson** | LOUDS Bit-String mit Unary-Degree | ICacheStrategy „succinct-bit-vector-page" |
| **P10 SuRF** | LOUDS-Dense (oben) + LOUDS-Sparse (unten) | ISearchPagesStrategyPattern „inner-vs-leaf" mit Cutoff-R + zwei verschiedenen ISearchPageStrategy |
| **P11 CSS-tree** | Pointer-freier sortierter Cache-Line-Knoten | ICacheStrategy „pointer-free-cacheline-aligned", ISearchPageStrategy „all-pages-uniform" (statisch) |
| **P12 CSB+** | Sibling-Cluster mit 1 Pointer + Offset | ICacheStrategy „sibling-cluster-cacheline" |
| **P13 Hankins** | Wider-B+ (4-16 Cache-Lines), Cost-Model | IHeuristic „width-cost-model" (waehlt Page-Size in ICacheStrategy) |
| **P14 Samuel** | Configuration-Table fuer Tree-Shape | IHeuristic „config-table-lookup" |
| **P16 Bender** | Probability-Layout, Multi-Level Memory | IHeuristic „probability-layout" + IBusTopology Multi-Level |
| **P17 Bender** | Cache-Oblivious B+ | ICacheStrategy „cache-oblivious-recursive-layout" (Algorithmus weiss NICHT von ICacheTopology) |
| **P18 Saikkonen 2008** | Multi-Level globale Re-Allocation BFS | ISearchPagesStrategy „dynamic-rebalance" + IScheduler „BFS-tree-rewrite" |
| **P19 Saikkonen 2016** | Layout-Invariante mit konstanten Update-Ops | ISearchPageStrategy mit Invariante-Checks |
| **P20 B-Trees Are Back** | 6 Layout-Optimierungen + adaptive Selection | ISearchPagesStrategy „adaptive-layout-selection" + ICacheStrategy mit 6 Varianten |
| **P21 Chen 2001** | Wider Nodes via Software-Prefetch | ICacheStrategy „wider-page-with-prefetch" + IHeuristic „prefetch-distance" |
| **P22 Chen 2002 Fractal** | Multi-Granularitaet (Disk + Cache) | ICacheTopology Multi-Tier (analog Block AO Hybrid) |
| **P23 Khan** | Runtime-adaptierte Prefetch-Distanz | IHeuristic „adaptive-prefetch-distance" + DecisionLambdaTree (PrefetchAdjustmentTree) |
| **P24 Naderan-Tahan** | Negativer Befund (Prefetch hilft nicht immer) | IHeuristic „prefetch-effectiveness-detector" → DecisionLambdaTree „SKIP" |
| **P25 Mahling** | Fill-Buffer-Aware + NUMA + Coroutined Prefetch | IHeuristic „fill-buffer-occupancy" + ICoreToThreadMap NUMA-Routing |
| **P26 Zhang FGCS** | Path-Prefetcher + Hot-Path-Counter + Jump-Pointers | ISearchPagesStrategy „hot-vs-cold" + IHeuristic „path-prediction" |
| **P27 Zhang ASPLOS** | Bundle-based Instruction-Prefetcher | IHeuristic „instruction-prefetch-bundle" |
| **P28 Kuehn DAMON** | Histogramm pro Knoten + Hot-Path-Detection (static) | TelemetryStrategy Per-Node + LeafOnly + Sampled (Achse 11) → IHeuristic |
| **P08 ART Sync** | OLC + ROWEX | ConcurrencyMechanic OLC/ROWEX (siehe Saeule A unter ISearchPagesStrategy) |
| **P29 RCU** | Quiescent-State + Grace-Period | ConcurrencyMechanic RCU (comdare-rcu, Task #104) |
| **P30 Hazard Pointers** | per-Thread Hazard Pointers | (NICHT im aktuellen Permutations-Raum, kann ergaenzt werden) |
| **P31 Ungethuem TUD** | Survey HW-Optimization | IHeuristic-Patterns (Sammlung aller HW-Optimierungen) |
| **P32 Schmidt TUD „To Stride"** | DTLB-bewusster Stride-Pattern | IHeuristic „stride-vs-sequential" + IBusTopology DTLB-Aware |
| **P33 VAMPIR Poster** | Heterogeneous Memory + NFP-Modeling | ICacheTopology HBM + DIMM (Block AO/Block AP) |

---

## 5. Verzeichnis-Vorschlag (Implementierungs-Pfad)

```
comdare-cache-engine/
├── search_engine/                                (Saeule A)
│   ├── concepts/
│   │   ├── i_page.hpp
│   │   ├── i_root_page.hpp
│   │   ├── i_fanout.hpp
│   │   ├── i_node.hpp
│   │   ├── i_search_page.hpp
│   │   ├── i_cache_page.hpp
│   │   ├── i_cache_strategy.hpp
│   │   ├── i_search_page_structure.hpp
│   │   ├── i_search_pages_strategy.hpp
│   │   ├── i_search_pages_strategy_pattern.hpp
│   │   ├── i_search_page_strategy.hpp
│   │   └── iterators/
│   │       ├── i_node_iterator.hpp
│   │       ├── i_search_page_iterator.hpp
│   │       └── i_search_page_strategy_iterator.hpp
│   ├── adapters/                                  (siehe ext/<paper>/<repo>/)
│   └── prt_art/
│       └── pages/, nodes/, strategies/

cache_engine/                                      (Saeule B)
├── platform_model/
│   ├── i_cache_level.hpp
│   ├── i_cache_line.hpp
│   ├── i_cache_topology.hpp
│   ├── i_cache_residency.hpp
│   ├── i_cpu_core.hpp
│   ├── i_core_layout.hpp
│   ├── i_core_thread_map.hpp
│   ├── i_pinning_policy.hpp
│   ├── i_hardware_extension.hpp
│   ├── i_isa_feature_set.hpp
│   ├── i_interconnect.hpp
│   ├── i_bus_topology.hpp
│   ├── i_memory_bandwidth_model.hpp
│   ├── i_live_platform_model.hpp
│   └── i_live_cpu_model.hpp
├── scheduling/
│   ├── i_scheduler.hpp
│   └── concrete/
│       ├── x3d_v_cache_scheduler.hpp
│       ├── intel_hybrid_p_core_scheduler.hpp
│       └── numa_local_scheduler.hpp
├── heuristics/
│   ├── i_heuristic.hpp
│   └── concrete/
│       ├── cache_coherence_cost_heuristic.hpp     (Block AN Kuehn)
│       ├── x3d_v_cache_pinning_heuristic.hpp      (Block AO Ryzen)
│       ├── hybrid_cpu_routing_heuristic.hpp       (Block AO i9)
│       ├── hot_page_migration_heuristic.hpp
│       └── prefetch_effectiveness_heuristic.hpp   (P24 Naderan-Tahan)
├── decision_trees/                                (F-EXTRA-6 PRO Baustein)
└── observer_registry/                             (F2 Push synchron)
```

---

## 6. Naechste Schritte (zur User-Abstimmung)

1. **JETZT:** Du pruefst diese Skizze auf Korrektheit der Hierarchie + Cross-Reference zu Papern.
2. **BEI BESTAETIGUNG:**
   - Aktualisiere `01_uml_search_engine.md` → korrigierte hierarchische Concept-Spezifikation (Saeule A)
   - Erstelle `02b_uml_cache_engine_platform.md` → komplette Saeule-B-Spezifikation (Plattform-Modell)
   - Aktualisiere `02_uml_cache_engine.md` → CacheEngine besitzt jetzt `ILivePlatformModel`, `IScheduler`, `IHeuristic[]`
   - Aktualisiere `08_cross_reference.md` → Mapping-Tabelle erweitert (siehe Sektion 4 dieses Dokuments)
   - Aktualisiere `phase5_uml_detail.drawio` → 8 Tabs werden zu 12 Tabs:
     - Tab 01-A bis 01-C: Saeule A Suchalgorithmen-Hierarchie (3 Sub-Tabs)
     - Tab 02-A bis 02-D: CacheEngine Innenleben (4 Sub-Tabs)
     - Tab 03-A bis 03-D: NEU Saeule B Plattform-Modell (4 Sub-Tabs)
     - Tab 04: Verbindung Saeule A ↔ Saeule B (Forschungs-Herz)
3. **BEI KORREKTUR:** Du nennst die Punkte, ich passe diese Skizze an, dann Schritt 2.

---

## 8. LAUFENDE TIEFLEKTUERE — Cache-Strategien aus 33 Papern (REV 2)

**Architekt-Direktive 2026-05-09 nachmittag:** Cache-Strategien-Verallgemeinerung ist UNVOLLSTAENDIG. Alle 33 Paper muessen mit hoechster Praezision MANUELL gelesen werden, um:
1. **Cache-Strategien** unter gemeinsamen Daechern zu finden (zentrale Luecke)
2. **Algorithmus-Strategien** auf Luecken zu pruefen
3. Aus jeder konkreten Paper-Implementierung **verallgemeinerte Strategie-Absichten** zu extrahieren

**Vorgehen:** 6 parallele general-purpose-Agenten, jeder liest 5-6 Paper mit Read-Tool (PDF + pages-Argument), schreibt einen strukturierten Bericht in `_paper_extractions/<cluster>.md`. Konsolidierung danach.

**Cluster-Zuordnung:**
| Cluster | Paper | Output |
|---------|-------|--------|
| A — Trie-Familie | P01 ART, P02 HOT, P04 CoCo, P05 START, P09 LOUDS, P10 SuRF | `_paper_extractions/cluster_A_trie.md` |
| B — Hybrid + B+ | P03 Masstree, P06 B²-tree, P07 Wormhole, P11 CSS, P12 CSB+, P13 Hankins | `_paper_extractions/cluster_B_hybrid_bplus.md` |
| C — Layout-Theorie | P14 Samuel, P15 Graefe, P16 Bender Tree-Layout, P17 Bender CO, P18 Saikkonen 2008, P19 Saikkonen 2016 | `_paper_extractions/cluster_C_layout_theorie.md` |
| D — Prefetching 1 | P20 B-Trees-Are-Back, P21 Chen 2001, P22 Chen Fractal, P23 Khan | `_paper_extractions/cluster_D_prefetching_1.md` |
| E — Prefetching 2 + Telemetry | P24 Naderan-Tahan, P25 Mahling, P26 Zhang FGCS, P27 Zhang ASPLOS, P28 Kuehn | `_paper_extractions/cluster_E_prefetching_telemetry.md` |
| F — Sync + TUD-Habich | P08 ART-Sync, P29 RCU, P30 Hazard, P31 Ungethuem, P32 To-Stride, P33 VAMPIR | `_paper_extractions/cluster_F_sync_tud_habich.md` |

**Pro Paper extrahiert jeder Agent:**
1. Identifizierte CACHE-STRATEGIEN (Concept-Verallgemeinerungen fuer ICacheStrategy-Familie)
2. Identifizierte ALGORITHMUS-STRATEGIEN (Concept-Verallgemeinerungen fuer ISearchPagesStrategy / ISearchPageStrategy / IHeuristic)
3. Implementations-Details die NICHT in andere Paper passen (Sondermerkmale)
4. Verallgemeinerungs-Vorschlaege (welches gemeinsame Dach passt?)

**Konsolidierung nach Agent-Abschluss:**
- Alle Cache-Strategie-Konzepte unter einem gemeinsamen Schirm in `11_cache_strategy_taxonomie.md`
- Alle Algorithmus-Strategie-Konzepte verfeinert in dieser Skizze (REV 3)
- Lueckenanalyse: was haben wir uebersehen?

## 9. Offene Punkte fuer User-Bestaetigung

- **Begriffe stimmen?** IPage / IFanout / INode / ISearchPage / ICachePage / ICacheStrategy / ISearchPageStructure / ISearchPagesStrategy / ISearchPagesStrategyPattern / ISearchPageStrategy
- **Iteratoren-Schicht:** INodeIterator + ISearchPageIterator + ISearchPageStrategyIterator + comdare::prt_art::iterator — passt das?
- **Plattform-Modell-Granularitaet:** sind ICacheLevel + ICacheLine + ICacheTopology + ICacheResidency richtig getrennt? Oder zu fein/grob?
- **CPU-Modell:** ICpuCore + ICoreLayout + ICoreToThreadMap + IPinningPolicy — fehlen Concepts?
- **Heuristik vs Scheduler-Trennung:** IScheduler entscheidet Thread→Core, IHeuristic berechnet Wert-Modelle — passt diese Trennung?
- **Cross-Mapping Paper → Concepts:** Sektion 4 liefert pro Paper die Verallgemeinerungs-Zuordnung — sind die Verallgemeinerungen sinnvoll? Wo fehlen welche?
- **Verzeichnis-Pfade:** `search_engine/concepts/`, `cache_engine/platform_model/`, etc. — passend?
