# Architektur-Skizze REV 3 (kanonisch, 2026-05-10)

**Status:** kanonische integrierte Architektur-Skizze nach Architekt-Bestaetigung der Korrektur-Runde 3.
**Vorgaenger:** `10_korrektur_architektur_skizze_2026_05_09.md` (REV 2 + Korrektur-Runde 3 als Historie).
**Begleit-Dateien (referenziert):** `11_cache_strategy_taxonomie.md`, `12_algorithmus_strategie_taxonomie.md`, `13_saeule_b_plattform_modell_konkretisierung.md`, `_paper_extractions/cluster_A-F.md`.
**drawio:** `phase5_uml_detail_REV3.drawio` (12 Tabs).

---

## 0. Drei-Ebenen-Architektur (Wurzel-Sicht)

PRT-ART ist auf drei klar getrennten Ebenen organisiert:

```
┌──────────────────────────────────────────────────────────────────────┐
│ EBENE 1 — IExecutingEngine                                           │
│   Wurzel-Abstraktion fuer alle Engines, die CacheEngine konsumieren  │
│                                                                      │
│   ├── ISearchEngine     (PRT-ART-Diplomarbeit-Fokus)                 │
│   └── IFutureEngine     (Architektur-Slot — z.B. ICompactingEngine,  │
│                          ISortingEngine, IDeduplicationEngine)       │
└──────────────────────────────────────────────────────────────────────┘
                                  ▼ konsumiert
┌──────────────────────────────────────────────────────────────────────┐
│ EBENE 2 — Suchalgorithmus-Datenstruktur (Saeule A)                   │
│   IPage / IRootPage / IFanout / INode / ISearchPage / ICachePage /   │
│   ICacheStrategy (Visitor) / ISearchPagesStrategy /                  │
│   ISearchPagesStrategyPattern / ISearchPageStrategy /                │
│   IStrategyCommand / HybridCompositionCommand /                      │
│   Iteratoren-Familie                                                 │
└──────────────────────────────────────────────────────────────────────┘
                                  ▼ optimiert via
┌──────────────────────────────────────────────────────────────────────┐
│ EBENE 3 — CacheEngine + Plattform-Modell (Saeule B)                  │
│   IPlatformProbe (Auto-Discovery) / IPlatformPropertyClassifier /    │
│   ICacheLevel / ICacheLine / ICacheTopology / ICacheResidency /      │
│   ICpuCore / ICoreLayout / ICoreToThreadMap / IPinningPolicy /       │
│   IHardwareExtension / IIsaFeatureSet /                              │
│   IInterconnect / IBusTopology / IMemoryBandwidthModel /             │
│   ILivePlatformModel / ILiveCpuModel /                               │
│   IScheduler / IHeuristic / ICacheEngineOptionPublisher /            │
│   DecisionLambdaTrees                                                │
└──────────────────────────────────────────────────────────────────────┘
```

**Trennungs-Prinzip:**
- Ebene 1 ist generisch — jede Engine kann CacheEngine als Optimierungs-Service nutzen
- Ebene 2 weiss nichts direkt von CPU/Caches/Bandbreiten — konsumiert nur ICacheStrategy
- Ebene 3 ist plattform-agnostisch im Code, plattform-konkret im Verhalten via Auto-Discovery

---

## 1. EBENE 1 — IExecutingEngine (NEU in REV 3)

### 1.1 Wurzel-Abstraktion

```
«concept» IExecutingEngine
   - reference to CacheEngine                            (optional, Optimierungs-Service)
   - generic API: execute<Op>(operation : Op&) : Result
   - exposes: telemetry hooks for DecisionLambdaTrees
   - exposes: lifecycle (warm_up, reset, shutdown)
   - subscribes: IExecutingEngineObserver

«concept» ISearchEngine : IExecutingEngine               (PRT-ART-Diplomarbeit)
   - composes: IRootPage, IFanout, INode, ISearchPage, ICachePage
   - composes: ISearchPagesStrategy, ISearchPagesStrategyPattern, ISearchPageStrategy
   - composes: ICacheStrategy (Visitor)
   - exposes: comdare::prt_art<K, V>::iterator family

«concept» IFutureEngine : IExecutingEngine               (Architektur-Slot, leer in PRT-ART)
   z.B. ICompactingEngine, IDeduplicationEngine, ISortingEngine
```

### 1.2 Verzeichnis (REV 3)

```
executing_engine/
├── concepts/
│   ├── i_executing_engine.hpp                            (Wurzel-Abstraktion)
│   └── i_engine_lifecycle.hpp
├── search_engine/                                        (Spezialisierung 1)
│   ├── concepts/                                         (siehe Ebene 2)
│   ├── adapters/                                         (siehe ext/<paper>/<repo>/)
│   ├── prt_art/                                          (eigene Implementation)
│   └── strategies/commands/                              (siehe §3.4 — Command-Pattern)
└── future_engines/                                       (leer in PRT-ART, Architektur-Slot)
    └── README.md
```

---

## 2. EBENE 2 — Suchalgorithmus-Datenstruktur (Saeule A, korrigiert + erweitert)

### 2.1 Concept-Hierarchie (vollstaendig REV 3)

```
«concept» IPage<P>                                       (Top-Abstraktion: jede „Seite")
   ↑ inherits
«concept» IRootPage<R> : IPage                           (Wurzel-Spezialisierung)
   composes 1 IFanout

«concept» IFanout<F>                                     (Verzweigungs-Abstraktion)
   composes [N] INode  via «contains»
   has EXACTLY 1 ISearchPagesStrategyPattern             ★ K3.4 Multiplizitaet ★

«concept» INode<N>                                       (Verzweigungs-/Daten-Einheit)
   placed on ISearchPage  via «mapped via ISearchPageStrategy»

«concept» ISearchPage<S>                                 (logische Such-Seite)
   contains [N] INode
   mapped onto ICachePage[s]  via «ICacheStrategy»

«concept» ICachePage<C>                                  (physische Speicher-Repraesentation)
   - size : size_t
   - cache_line_formation : CacheLineFormation
   - influenced_by : CacheEngine
```

### 2.2 ICacheStrategy als Visitor-Pattern (REV 3 fixiert)

```
«concept, visitor» ICacheStrategy<CS>
   + visit(read_op : PageReadOp&) : void
   + visit(write_op : PageWriteOp&) : void

«concrete» BaseEngineStrategy : ICacheStrategy           (NICHT-OPTIMIERT, Baseline F15)
   - StaticEngine-Pfad: Originalcode-Bauteil ohne CacheEngine-Beeinflussung
   - keine ILivePlatformModel-Konsultation; keine Heuristik-Aufrufe

«concrete» CacheEngineStrategy : ICacheStrategy          (CACHE-ENGINE-OPTIMIERT)
   - konsumiert ILivePlatformModel + ICacheResidency + IHeuristic (Ebene 3)
   - kann Read/Write umrouten auf bessere Cache-Ebene
   - kann Page-Layout vor Write rearrangieren
```

### 2.3 ISearchPagesStrategy + Pattern + ISearchPageStrategy (Multiplizitaeten K3.4 fixiert)

```
«concept» ISearchPageStructure<SS>                       (Container fuer mehrere ISearchPage)
   contains [N] ISearchPage  in geordneter Abfolge

«concept» ISearchPagesStrategy<SPS>                      (POLICY: Structure-Pflege, key-value)
   - controls: insertion / removal / re-ordering / consolidation
   - delegates per-page entry handling via ISearchPagesStrategyPattern

«concept» ISearchPagesStrategyPattern<SSP>               (PATTERN: Anordnungs-Vorschrift)
   ★ FIXIERT REV 3:
   - 1 ISearchPagesStrategyPattern pro IFanout (eindeutig)
   - has N ISearchPageStrategy (eine pro ISearchPage)
   - Beispiele aus 12 §1.1: AllPagesUniform, LayerMix, InnerVsLeaf, HotVsCold,
     DynamicRebalance, HierarchicalFractal, OrthogonalRuntimeParametrized,
     MultiStrategyOrchestration, HeterogeneousAdaptive, BoundaryNodePartition

«concept» ISearchPageStrategy<SP>                        (POLICY: pro EINE ISearchPage)
   - controls: where in the page key-value goes
   - controls: when to split/merge the page
   - controls: layout invariants
   - 1 pro ISearchPage; ISearchPagesStrategyPattern hat N davon
```

### 2.4 Hybrid-Command-Pattern (NEU in REV 3, K3.4)

```
«abstract» IStrategyCommand                              (Wurzel jeder atomaren Strategie)
   + execute(context : StrategyContext&) : Result
   + can_compose_with(other : IStrategyCommand&) : bool

«composite» HybridCompositionCommand : IStrategyCommand  (Sammler von Atom-Commands)
   - parts : vector<IStrategyCommand*>
   - composition_rule : ICompositionRule  (sequenziell|parallel|conditional|recursive)
   + execute(context) : Result

«concept» ICompositionRule
   - applies(parts, context) : ExecutionPlan
   - varianten: SequentialRule, ParallelRule, ConditionalRule, RecursiveRule
```

**17 Hybrid-Aufloesungen dokumentiert** in `12_algorithmus_strategie_taxonomie.md` §9 + `11_cache_strategy_taxonomie.md` §10. Beispiele:
- Wormhole P07 Triple-Layer → 3 Atome + `TripleLayerLookupCompositionCommand`
- HOT P02 (9 Layouts) → 9 Atome + `HOTAdaptiveLayoutSelectionCompositionCommand`
- LOUDS Dense+Sparse P10 → 2 Atome + `CutoffLevelLoudsCompositionCommand`
- Masstree Slice+B+ P03 → 3 Atome + `MasstreeSliceLayeredCompositionCommand`
- B²-Tree Decision+Span P06 → 3 Atome + `B2TreeRecursiveCommonPrefixCompositionCommand`

### 2.5 Iteratoren (REV 3 fixiert)

```
«concept» INodeIterator<NI>                              (visit_each_child, byte-by-byte etc.)
«concept» ISearchPageIterator<SI>                        (Range-Scan ueber ISearchPage)
«concept» ISearchPageStrategyIterator<SSI>               (Cross-Algorithm-Iteration)

class comdare::prt_art<Key, Value>
   + iterator           (mutable forward iterator)
   + const_iterator
   + range_iterator
   + key_iterator
   + value_iterator
   ' kompatibel zu std::map-API (Domaenenmodell §1A)
```

### 2.6 Verzeichnis Ebene 2 (REV 3)

```
executing_engine/search_engine/
├── concepts/
│   ├── i_page.hpp
│   ├── i_root_page.hpp
│   ├── i_fanout.hpp
│   ├── i_node.hpp
│   ├── i_search_page.hpp
│   ├── i_cache_page.hpp
│   ├── i_cache_strategy.hpp
│   ├── i_search_page_structure.hpp
│   ├── i_search_pages_strategy.hpp
│   ├── i_search_pages_strategy_pattern.hpp
│   ├── i_search_page_strategy.hpp
│   └── iterators/
│       ├── i_node_iterator.hpp
│       ├── i_search_page_iterator.hpp
│       └── i_search_page_strategy_iterator.hpp
├── strategies/
│   └── commands/                                         (NEU REV 3 — Command-Pattern)
│       ├── i_strategy_command.hpp
│       ├── hybrid_composition_command.hpp
│       ├── i_composition_rule.hpp
│       ├── pages/                                        (atomare Page-Strategy-Commands)
│       ├── traversals/                                   (atomare Traversal-Commands)
│       ├── prefetchers/                                  (atomare Prefetch-Commands)
│       ├── relocations/                                  (atomare Reloc-Commands)
│       └── compositions/                                 (Composition-Commands pro Hybrid)
│           ├── triple_layer_lookup_composition.hpp
│           ├── hot_compound_composition.hpp
│           ├── cutoff_level_louds_composition.hpp
│           └── ... (17 Composition-Commands gem. 12 §9)
├── adapters/                                             (siehe ext/<paper>/<repo>/)
└── prt_art/
    └── pages/, nodes/, strategies/
```

---

## 3. EBENE 3 — CacheEngine + Plattform-Modell (Saeule B, korrigiert)

### 3.1 Plattform-Auto-Discovery (NEU in REV 3, K3.2)

```
«concept» IPlatformProbe                                 (allgemein, OHNE CPU-Spezialisierung)
   + discover_cache_topology() : ICacheTopology
   + discover_core_layout() : ICoreLayout
   + discover_isa_features() : IIsaFeatureSet
   + discover_interconnect() : IBusTopology
   + measure_cache_latencies() : map<TierPair, Cycles>
   + measure_bandwidths() : map<InterconnectId, Gbps>
   + measure_cache_coherence_cost() : CoherenceCostFunction
   + measure_pinning_effects() : map<PinningPolicy, Speedup>

«concept» IPlatformPropertyClassifier                    (NEU)
   + classify(probe_results) : PlatformPropertySet
   - PlatformPropertySet z.B.:
       * has_asymmetric_l3 : bool   (entdeckt, nicht hard-coded „Ryzen X3D")
       * has_hybrid_cores  : bool   (entdeckt, nicht hard-coded „Intel Hybrid")
       * preferred_pinning : PinningPolicy  (gewaehlt aus Vermessung)

«concept» ICacheEngineOptionPublisher                    (NEU)
   + publish_options_to(permutation_modules : list) : void
   - jede Permutation erhaelt nur Optionen, die ihre Bausteine konsumieren koennen
```

**5-Schritt-Pflicht (CacheEngineBuilder):** Discover → Measure → Classify → Publish → Bind.

### 3.2 Cache-Hierarchie + CPU-Modell (REV 3 unveraendert vs REV 2, fokussiert)

```
«concept» ICacheLevel<L>          - L1/L2/L3/HBM/V-Cache mit size, latency, bandwidth
«concept» ICacheLine<CL>          - Granularitaet (typ. 64 B, 256 B ARM A64FX)
«concept» ICacheTopology<CT>      - gesamte Hierarchie, asymmetric_l3 als Property
«concept» ICacheResidency<CR>     - Cache whereabouts (Cached/HeaderCached/Uncached)

«concept» ICpuCore<C>             - core_class als generic enum (P_CORE/E_CORE/CCD0_HIGH_L3/...)
«concept» ICoreLayout<CL>         - Topologie, ohne CPU-Spezialisierung
«concept» ICoreToThreadMap<CTM>   - Thread→Core, IPinningPolicy als generic
«concept» IPinningPolicy<P>       - LARGEST_L3_CCD, HIGH_IPC_CORES, NUMA_LOCAL, ROUND_ROBIN
                                    (alle generisch, keine CPU-Namen)
```

### 3.3 IHardwareExtension + Bandbreiten + Live-Modell

```
«concept» IHardwareExtension<HX>  - eine ISA-Feature-Bank (AVX-512, BMI2, NEON, SVE2)
«concept» IIsaFeatureSet<IFS>     - gesamte Feature-Verfuegbarkeit, Auto-discovered

«concept» IInterconnect<IC>       - CCD↔CCD, Core↔Cache, Cache↔Memory, NUMA-Link, PCIe, NVLink
«concept» IBusTopology<BT>        - gesamte Bus-/Interconnect-Topologie
«concept» IMemoryBandwidthModel<MBM>  - Live-Bandbreiten + Bottleneck-Detection

«concept» ILivePlatformModel<LPM>  - Echtzeit-Modell, periodisch aktualisiert
«concept» ILiveCpuModel<LCM>      - Per-Core-Lasten + Hot-Path-Score
```

### 3.4 IScheduler + IHeuristic (mit ~80 paper-abgeleiteten Heuristiken)

```
«concept» IScheduler<S>           - Thread→Core + Task→Ebene
«concept» IHeuristic<H>           - Wert-Berechnungen auf dem Live-Modell
                                    Konkretisierungen siehe 13 (~80 Heuristiken aus 33 Papern)
```

**Beispiele Heuristiken (aus 13 §8):**
- `AdaptivePrefetchDistanceHeuristic` (P23 Khan)
- `CacheCostDPHeuristic` (P05 START)
- `CacheCoherenceCostHeuristic` (P28 Kuehn Block AN)
- `WidthCostModelHeuristic` (P13 Hankins/Patel)
- `ProbabilityLayoutHeuristic` (P16 Bender)
- `LargestL3CcdPinningHeuristic` (allgemeine Asymmetric-L3-Heuristik)
- `HotPathOnHighIpcCoreHeuristic` (allgemeine Hybrid-CPU-Heuristik)
- `StrideVsSequentialHeuristic` (P32 To-Stride)
- `CacheCoherenceDetectionHeuristic` (P28 NEU 2026-05-08)
- ... (siehe 13 §8 fuer vollstaendige Liste)

### 3.5 Verzeichnis Ebene 3 (REV 3 ohne CPU-Spezialisierung)

```
cache_engine/
├── platform_model/
│   ├── i_platform_probe.hpp                              (Auto-Discovery)
│   ├── i_platform_property_classifier.hpp                (NEU)
│   ├── i_cache_level.hpp / i_cache_line.hpp / i_cache_topology.hpp / i_cache_residency.hpp
│   ├── i_cpu_core.hpp / i_core_layout.hpp / i_core_thread_map.hpp / i_pinning_policy.hpp
│   ├── i_hardware_extension.hpp / i_isa_feature_set.hpp
│   ├── i_interconnect.hpp / i_bus_topology.hpp / i_memory_bandwidth_model.hpp
│   ├── i_live_platform_model.hpp / i_live_cpu_model.hpp
│   └── i_cache_engine_option_publisher.hpp               (NEU)
├── scheduling/
│   ├── i_scheduler.hpp
│   └── concrete/                                         (KEINE CPU-Namen)
│       ├── pinning_aware_scheduler.hpp                   (allgemeine Pinning-Logik)
│       ├── numa_local_scheduler.hpp
│       └── round_robin_scheduler.hpp
├── heuristics/
│   ├── i_heuristic.hpp
│   └── concrete/                                         (~80 Heuristiken aus 13 §8)
│       ├── adaptive_prefetch_distance_heuristic.hpp
│       ├── cache_cost_dp_heuristic.hpp
│       ├── cache_coherence_cost_heuristic.hpp
│       ├── width_cost_model_heuristic.hpp
│       ├── probability_layout_heuristic.hpp
│       ├── largest_l3_ccd_pinning_heuristic.hpp           (allgemein, ersetzt X3DAware)
│       ├── hot_path_on_high_ipc_core_heuristic.hpp        (allgemein, ersetzt IntelHybridP)
│       └── ... (vollstaendige Liste aus 13)
├── decision_trees/                                        (F-EXTRA-6 PRO Baustein)
└── observer_registry/                                     (F2 Push synchron)
```

---

## 4. Strategie-Achsen (Ebene-2-Querschnitt, Referenz auf 11/12)

### 4.1 Cache-Strategien (29 Familien aus 11)

Die ICacheStrategy-Familie ist in 29 orthogonale Strategie-Familien zerlegt (siehe `11_cache_strategy_taxonomie.md`):

| Familie | Concept-Klasse | Beispiel-Paper |
|---------|----------------|----------------|
| F1 | IAdaptiveFootprintStrategy | P01, P02, P05, P12, P14, P20, P28 |
| F2 | ISuccinctEncodingStrategy | P09, P04, P10, P11, P12, P14 |
| F3 | ICacheLineAlignedStrategy | P01, P02, P07, P11, P12, P14, P15, P32 |
| F4 | IMultiCacheLineNodeStrategy | P03, P13, P21, P22 |
| F5 | ISoftwarePrefetchStrategy | P02, P03, P10, P14, P15, P21, P22, P25, P26, P27 |
| F6 | IPointerChasingResolutionStrategy | P21, P22, P26 |
| F7 | ISimdAcceleratedLookupStrategy | P01, P02, P10, P14, P32 |
| F8-F29 | (siehe 11 fuer vollstaendige Liste) | ... |

**Drei Meta-Achsen** (siehe 11):
- Awareness (cache-aware vs cache-oblivious vs auto-discovery)
- Compositionality (atomare vs zusammengesetzte Strategien)
- Dynamicity (statisch vs adaptive vs runtime-adaptiv)

### 4.2 Algorithmus-Strategien (4-Ebenen aus 12)

| Ebene | Concept | Kardinalitaet | Patterns/Strategien |
|-------|---------|---------------|---------------------|
| A | ISearchPagesStrategyPattern | 1 pro IFanout | 10 Patterns (siehe 12 §1.1) |
| B | ISearchPagesStrategy | N pro Pattern | B+-, Trie-, Hybrid-Familie (siehe 12 §2) — als Konfigurations-Pakete (K3.3) |
| C | ISearchPageStrategy | 1 pro ISearchPage | Atom-Strategien (siehe 12 §3) |
| D | IHeuristic | beliebig | ~80 paper-abgeleitete Heuristiken (siehe 13 §8) |

---

## 5. Verbindungen zwischen Ebenen (REV 3)

```
IExecutingEngine ────konsumiert────▶ CacheEngine (Ebene 3)
        ▲                                   │
        │ implementiert                     │ stellt zur Verfuegung
        │                                   │
ISearchEngine ────uses────▶ ISearchPagesStrategy ───nutzt───▶ ICacheStrategy (Visitor)
                                   │                                    │
                                   │ uses Pattern                       │ (a) BaseEngineStrategy
                                   │ has-N ISearchPageStrategy          │     - keine CacheEngine
                                   │                                    │
                                   ▼                                    │ (b) CacheEngineStrategy
                            IStrategyCommand                            │     - liest ILivePlatformModel
                                   │                                    │     - ruft IHeuristic
                                   │ kompositioniert via                │     - schreibt ICacheResidency
                                   ▼
                       HybridCompositionCommand
                            (atomare Bausteine
                             einzeln testbar)

CacheEngine ────betreibt────▶ IPlatformProbe (Auto-Discovery)
                    │              │
                    │              ▼
                    │      IPlatformPropertyClassifier
                    │              │
                    │              ▼
                    │      ICacheEngineOptionPublisher ──liefert Optionen──▶ Permutationen
                    │
                    ▼
            DecisionLambdaTrees ──routen Events zwischen──▶ Ebene 2 ↔ Ebene 3
            (PerBaustein gemaess F-EXTRA-6)
```

---

## 6. Forschungs-Mission integriert (Block AP)

**Drei Modi der Cache-Engine** (siehe Glossar v7 BLOCK AP):

```
«enum» CacheEngineMode {
    HEURISTIC_STATIC,        // klassische Faustregeln, plattform-unabhaengige Defaults
                             //   ⇒ ISearchPagesStrategy + ICacheStrategy = BaseEngineStrategy
    INFORMED_KALIBRIERT,     // Cache-Engine-Modell + plattform-Kalibrierung (Auto-Discovery)
                             //   ⇒ CacheEngineStrategy mit Statischer Heuristik-Wahl
    AUTOMATIC_ADAPTIVE       // DecisionLambdaTree-Steuerung waehrend Laufzeit
                             //   ⇒ CacheEngineStrategy mit dynamischer Heuristik-Wahl
}
```

**F15 Bausteine-Quer-Permutation** wird durch K3.3 + K3.4 architektonisch erschlossen:
- 29 Cache-Familien × 4 Strategie-Ebenen × ~80 Heuristiken = ~10.000 mögliche Bausteine-Tupel
- Mit Hybrid-Command-Pattern-Aufloesung × 3 = ~30.000 Bausteine
- ConstraintFilter (F4 K3.2) liefert ~500-1000 valide Permutationen pro Plattform
- Cross-Familien-Permutationen (Trie-Page + B+-Layout + LOUDS-Encoding + Hot-Path-Heuristic) sind explizites Forschungs-Ziel

---

## 7. Wichtigste Aenderungen vs REV 2

| Bereich | REV 2 | REV 3 |
|---------|-------|-------|
| Wurzel | direkt ISearchEngine | IExecutingEngine als Wurzel, ISearchEngine als Spezialisierung (K3.1) |
| Plattform | RyzenX3DProbe, IntelHybridProbe, X3DAwareFactory | IPlatformProbe + IPlatformPropertyClassifier (Auto-Discovery), Block AO als Beispiel-Konkretion (K3.2) |
| Cluster | „Trie-Familie" vs „Hybrid + B+-Familie" als Trennlinien | EINE Familie (Algorithmus-Konfigurations-Pakete), Cluster sind Lektuere-Hilfen (K3.3) |
| Hybrid | monolithische Hybrid-Strategien | IStrategyCommand + HybridCompositionCommand mit 17 Composition-Commands (K3.4) |
| Permutations-Raum | ~100 Bausteine | ~30.000 Bausteine durch Aufloesung |
| Cache-Strategien | wenige uebergeordnete Klassen | 29 Familien F1-F29 (siehe 11) |
| Algorithmus-Strategien | 11 Bausteine-Achsen | 4 Strategie-Ebenen mit klaren Multiplizitaeten (siehe 12) |
| Heuristiken | wenige Beispiele | ~80 paper-abgeleitete Heuristiken (siehe 13) |
| Iteratoren | knapp erwaehnt | INodeIterator + ISearchPageIterator + ISearchPageStrategyIterator + comdare::prt_art<K,V>::iterator-Familie |

---

## 8. drawio-Tab-Struktur REV 3 (12 Tabs statt 8)

| # | Tab-Name | Quelle |
|---|----------|--------|
| 01 | IExecutingEngine + Engine-Spezialisierungen | §1 |
| 02 | Search Engine — Concept-Hierarchie (IPage/IFanout/INode/...) | §2.1 + 2.5 |
| 03 | Search Engine — ICacheStrategy Visitor (Base/CacheEngine) | §2.2 |
| 04 | Search Engine — Strategy-Achsen + 4-Ebenen + Multiplizitaeten | §2.3 + 4.2 |
| 05 | Search Engine — Iteratoren-Familie | §2.5 |
| 06 | Hybrid-Command-Pattern + 17 Composition-Commands | §2.4 |
| 07 | Cache Engine — IPlatformProbe Auto-Discovery (5-Schritte) | §3.1 |
| 08 | Cache Engine — Plattform-Modell (Cache-Hierarchie + CPU + Bus) | §3.2 + 3.3 |
| 09 | Cache Engine — IHeuristic-Familie (~80 Heuristiken aus 13) | §3.4 |
| 10 | Cache-Strategie-Familien F1-F29 (Mapping zu Papern) | §4.1 |
| 11 | Drei-Ebenen-Verbindungen (Engine ↔ Strategien ↔ Cache-Engine) | §5 |
| 12 | Forschungs-Mission (heuristisch ↔ informiert ↔ adaptiv) + F15 | §6 |

---

## 9. Naechste Schritte

1. **JETZT:** drawio `phase5_uml_detail_REV3.drawio` mit den 12 Tabs erzeugen.
2. **Vorschlag (c) Folge:** OFFEN-Punkte aus `13_saeule_b_plattform_modell` durchgehen (Auto-Discovery-Detail-Spezifikation, Heuristik-Trennung, etc.)
3. Phase 6+ Implementierung gemaess Verzeichnis-Vorschlag (Saeule-A + Saeule-B Concept-Header anlegen, dann konkrete Bauteile)

---

## 10. Cross-Reference zu allen anderen Dokumenten

| Dokument | Beziehung zu REV 3 |
|----------|---------------------|
| `10_korrektur_architektur_skizze` | Vorgaenger REV 2 + Korrektur-Runde 3 (Begruendungs-Historie) |
| `11_cache_strategy_taxonomie` | 29 Cache-Familien-Detail (referenziert in §4.1) |
| `12_algorithmus_strategie_taxonomie` | 4-Ebenen-Detail + 17 Hybrid-Command-Pattern-Aufloesungen §9 |
| `13_saeule_b_plattform_modell_konkretisierung` | ~80 Heuristiken + Plattform-Konkretionen (referenziert in §3.4) |
| `_paper_extractions/cluster_A-F` | Tieflektuere-Quellen (33 Paper) |
| `Bausteine_Matrix.txt` | klassische Achsen-Sicht — wird durch REV 3 ersetzt |
| `Domaenenmodell_PRT_ART_v3` + `v4_DELTA` | aelteres Domaenenmodell — REV 3 ist die aktuelle Wurzel |
| `Habich_Feedback_2026_05_08.txt` | H1-H6 + F-Antworten — alle in REV 3 integriert |
| `Architekturentscheidungen_F1_F15.txt` | F1-F15 + F-EXTRA — alle in REV 3 integriert |
| `Begriffsglossar_v7_FINAL.txt` | Block A-AP — alle in REV 3 integriert |
| `Kuehn_Erkenntnisse_Einarbeitung_2026_05_09.txt` | Achse 11 Telemetry — Bezug in §3.4 (CacheCoherenceCost-Heuristik)  |
