# Korrektur-Architektur-Skizze 2026-05-09

**Anlass:** User-Korrektur zur ersten drawio-Version (`phase5_uml_detail.drawio`) — meine UML war Achsen-Klassifikation (Page/Node/Traversal/...), aber der Architekt erwartet eine **hierarchische Concept-Architektur** mit zwei klar getrennten Saeulen:

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
   - delegates per-page entry handling to:  ISearchPageStrategy[s]  via  ISearchPagesStrategyPattern

«concept» ISearchPagesStrategyPattern<SSP>             (PATTERN: Anordnungs-Vorschrift fuer Strategien)
   - assigns: which ISearchPageStrategy applies to which ISearchPage in the Structure
   - examples (aus Papern):
       * „all-pages-uniform"      (P11 CSS, P12 CSB+ — eine Strategie fuer alle Seiten)
       * „layer-mix"              (P03 Masstree — pro Layer eine andere Strategie)
       * „inner-vs-leaf"          (P10 SuRF — LOUDS-Dense oben, LOUDS-Sparse unten;
                                              P04 CoCo — Macro-Node oben, Patricia unten)
       * „hot-vs-cold"            (P26 Zhang FGCS — Hot-Pages eigene Strategie)
       * „dynamic-rebalance"      (P05 START — Tag-Manager schaltet Strategien um)

«concept» ISearchPageStrategy<SP>                      (POLICY: steuert Eintraege in EINE ISearchPage)
   - controls: where in the page key-value goes
   - controls: when to split/merge the page
   - controls: layout invariants
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

## 7. Offene Punkte fuer User-Bestaetigung

- **Begriffe stimmen?** IPage / IFanout / INode / ISearchPage / ICachePage / ICacheStrategy / ISearchPageStructure / ISearchPagesStrategy / ISearchPagesStrategyPattern / ISearchPageStrategy
- **Iteratoren-Schicht:** INodeIterator + ISearchPageIterator + ISearchPageStrategyIterator + comdare::prt_art::iterator — passt das?
- **Plattform-Modell-Granularitaet:** sind ICacheLevel + ICacheLine + ICacheTopology + ICacheResidency richtig getrennt? Oder zu fein/grob?
- **CPU-Modell:** ICpuCore + ICoreLayout + ICoreToThreadMap + IPinningPolicy — fehlen Concepts?
- **Heuristik vs Scheduler-Trennung:** IScheduler entscheidet Thread→Core, IHeuristic berechnet Wert-Modelle — passt diese Trennung?
- **Cross-Mapping Paper → Concepts:** Sektion 4 liefert pro Paper die Verallgemeinerungs-Zuordnung — sind die Verallgemeinerungen sinnvoll? Wo fehlen welche?
- **Verzeichnis-Pfade:** `search_engine/concepts/`, `cache_engine/platform_model/`, etc. — passend?
