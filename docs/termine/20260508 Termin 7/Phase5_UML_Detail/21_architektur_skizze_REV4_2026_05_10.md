# Architektur-Skizze REV 4 (2026-05-10) — Future-Proof Layer + Matrix Hybrid

**Status:** Erweiterung zu REV 3 (`20_architektur_skizze_REV3_2026_05_10.md`) — REV 3 bleibt unveraendert.
**Anlass (2026-05-10):** Architekt-Korrekturen + Web-Recherche zu Future-Proof Software Engineering.
**drawio:** `phase5_uml_detail_REV4.drawio` (10 Tabs, davon 6 Konzept-Tabs + 6 UML-Tabs + 1 Layer-Matrix-Konzept-Tab; XML-validiert).

---

## 0. Anlass + Korrekturen

### 0.1 Drawio-Fehler in REV 3 (behoben in REV 4)

**Fehler:** REV-3-drawio brach den XML-Parser an Zeile 31 wegen ASCII-Anfuehrungszeichen `"` mitten im Text (z.B. `"Seite"` als Wort, nicht als XML-Begrenzer). Der Parser interpretierte den Text-Apostroph als Attribut-Begrenzung und sah `eines` als naechstes Attribut, das einen Wert braucht — daher `Specification mandates value for attribute eines`.

**Fix in REV 4:**
- Alle ASCII-Anfuehrungszeichen `"` aus value-Attributen entfernt
- Deutsche Anfuehrungszeichen `„` `"` aus den Beschriftungen entfernt
- Konsequent ASCII-sichere Schreibweise innerhalb der drawio-Strings
- XML-Validierung mit Python `xml.etree.ElementTree` bestanden

### 0.2 Verbindungslinien orthogonal (UML-konform)

**Fix in REV 4:** Alle Edges nutzen `edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;` mit explizit gesetzten exit/entry-Punkten. Verbindungslinien laufen nur **vertikal/horizontal**, kreuzen keine Klassen quer.

### 0.3 Tab-Kategorisierung Konzept vs UML

**REV 4 trennt Tabs explizit:**

| Kategorie | Praefix | Inhalt | Layout |
|-----------|---------|--------|--------|
| Konzept | `K` | Concepts + Beziehungen ohne Member | kompakt, Beziehungs-orientiert |
| UML | `U` | Concepts + konkrete Variablen + Methoden + Sichtbarkeiten | professionell, Klassen-Box-Stil |
| Matrix | `MX` | Layer-vs-Matrix-Anordnungs-Entscheidung | Konzept-Diagramm |

---

## 1. Layer + Matrix — Hybrid-Anordnung der Implementierungs-Klassen

### 1.1 Vorab — die Frage des Architekten

> *Reicht es, die Implementierungsklassen in Layern anzuordnen, oder braucht es eine mehrdimensionale Matrix-Struktur, um multiple verbundene Aspekte zu implementieren?*

### 1.2 Antwort (basierend auf Web-Recherche + REV-3-Konsolidierung): **HYBRID**

**Layer-Dimension (vertikal, klassisch):**
- Drei Ebenen aus REV 3 §0: Engine | Strategien | CacheEngine.
- Ein Concept gehoert genau einem Layer.
- Klare Abhaengigkeits-Richtung (oben nach unten).
- Vorteil: Encapsulation, stabile Contracts, einfaches Reasoning.

**Matrix-Dimension (horizontal, fuer F15 Bausteine-Quer-Permutation):**
- Pro Layer existiert eine Matrix der Konkretisierungen entlang mehrerer orthogonaler Achsen.
- Achsen (PRT-ART, Auswahl):
  - Cache-Familie F1-F29 (siehe `11_cache_strategy_taxonomie.md`)
  - Strategie-Ebene A-D (Pattern / Plural-Strategy / Singular-Strategy / Heuristic — siehe `12_algorithmus_strategie_taxonomie.md`)
  - Plattform-Property (has_asymmetric_l3, has_hybrid_cores, ... — siehe `13_saeule_b_plattform_modell_konkretisierung.md`)
  - ISA-Feature (AVX-512, BMI2, NEON, SVE2, ...)
  - Concurrency-Mechanik (OLC, ROWEX, RCU, Hazard)
  - Telemetry-Strategie (PerNode, LeafOnly, Sampled, Retroactive — Achse 11 Kuehn)
- Dependency Structure Matrix (DSM) als Visualisierungs-Tool fuer Cross-Achsen-Beziehungen.

### 1.3 Verzeichnis-Konsequenz pro Concept (Beispiel ICacheStrategy)

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
│       │   ├── start_multilevel_footprint_strategy.hpp (P05)
│       │   └── ...
│       ├── f02_succinct_encoding/                     (F2 ISuccinctEncodingStrategy)
│       │   ├── louds_jacobson_encoding_strategy.hpp   (P09)
│       │   ├── louds_dense_encoding_strategy.hpp      (P10 - aufgeloest)
│       │   ├── louds_sparse_encoding_strategy.hpp     (P10 - aufgeloest)
│       │   ├── coco_pool_encoding_strategy.hpp        (P04)
│       │   └── ...
│       ├── f03_cache_line_aligned/
│       ├── ... (F4-F29 analog)
```

**Konkretisierung der Hybrid-Anordnung:**
- Achse 1 + Achse 2 sind orthogonal; eine konkrete Konkretisierung kombiniert beide (z.B. `BaseEngineStrategy x F2.LoudsDenseEncoding`).
- Die Composition ist Compile-Time-Composition via C++23 Templates + `requires`-Klauseln.
- Im Build entstehen ABI-stabile Module (siehe Architekturentscheidung F9).

---

## 2. Future-Proof-Prinzipien (aus Web-Recherche 2026-05-10)

### 2.1 Open/Closed-Prinzip

**Anwendung in PRT-ART:**
- Concept-Klassen (z.B. `ICacheStrategy`, `IPage`, `IHeuristic`) sind **closed for modification**: ihre Methoden-Signaturen sind Contracts, sie aendern sich nicht.
- Konkretisierungen sind **open for extension**: neue Klasse implementiert das Concept ohne dass andere Konkretisierungen oder die Concept-Klasse sich aendern.
- Mechanismus: C++23 Templates + `requires`-Klausel + `concept`-Definitionen.

### 2.2 Modular Architecture

**Anwendung:**
- Jede Achse einer Matrix ist eine unabhaengig austauschbare Achse — eigenes Sub-Verzeichnis.
- Konkretisierungen koennen ohne Aenderung an anderen Achsen ergaenzt werden.
- Verzeichnis pro Cache-Familie pro ISA-Feature pro Plattform-Property pro Concurrency-Mechanik pro Telemetry-Strategie.

### 2.3 Encapsulation through stable contracts

**Anwendung:**
- Concept-Header (`i_*.hpp`) sind die einzigen oeffentlichen API-Punkte.
- Implementierungs-Header (`*.hpp` ohne `i_` Praefix) sind privat zur Konkretisierungs-Achse.
- Aenderungen innerhalb einer Achse beeinflussen keine anderen Achsen.

### 2.4 Single Responsibility auf Architektur-Ebene

**Anwendung:**
- Jede Concept-Klasse hat einen klaren, einzigen Zweck:
  - `IPage` = logische Seiten-Abstraktion
  - `ICacheStrategy` = Read/Write-Routing-Visitor
  - `IHeuristic` = Wert-/Kostenberechnung
  - `IPlatformProbe` = Auto-Discovery der Plattform
- Mehrfach-Verantwortlichkeiten werden in mehrere Concepts aufgeteilt.

### 2.5 Separation of Concerns

**Anwendung:**
- Saeulen A (Strategien) und B (Plattform-Modell) sind disjunkt.
- Engine konsumiert nur abstrakte Schnittstellen — kennt keine konkreten Implementierungen.
- DecisionLambdaTrees vermitteln Events zwischen den Saeulen, ohne dass die Saeulen direkt voneinander abhaengen.

### 2.6 API-First Design

**Anwendung:**
- Jede Erweiterung der Architektur beginnt mit einer Concept-Erweiterung (oder neuem Concept-Header).
- Erst wenn die API stabil ist, folgen Konkretisierungen.
- Aenderungen an Concepts erfordern formelle Architektur-Korrekturrunde (siehe REV 1 → REV 2 → REV 3 → REV 4 Vorgehen).

### 2.7 Dependency Structure Matrix (DSM) als Visualisierungs-Tool

**Anwendung in Phase 6+:**
- DSM-Matrix mit allen Concepts als Zeilen + Spalten.
- Zellen markieren vorhandene Abhaengigkeiten (`uses`, `composes`, `inherits`).
- Ziel: Block-Triangulare Struktur (saubere Layer-Trennung).
- Tooling: z.B. Lattix, Structure101, oder eigenes script.

---

## 3. Variablen- und Methoden-Schema pro Concept (UML-Vorgehen)

### 3.1 Standard-Layout fuer eine Concept-Klasse (UML-konform)

```
<<concept>> IConceptName<TemplateParam>
━━━━━━━━━━━━━━━━━━━━━━
Typen (Type Aliases):
  ~ using Foo = typename TemplateParam::Foo
━━━━━━━━━━━━━━━━━━━━━━
Attribute:
  + public_field_     : Type
  # protected_field_  : Type
  - private_field_    : Type
━━━━━━━━━━━━━━━━━━━━━━
Methoden (UML-Konvention):
  + public_method(arg : ArgType) : ReturnType
  # protected_method(...) : ...
  - private_method(...) : ...
  + virtual abstract_method(...) = 0
━━━━━━━━━━━━━━━━━━━━━━
Constraints (OCL-aehnlich):
  inv: Invarianten-Beschreibung
```

### 3.2 Sichtbarkeits-Konvention

| Symbol | Sichtbarkeit | Verwendung |
|--------|--------------|------------|
| `+` | public | API-Methoden, oeffentliche Konstanten |
| `#` | protected | von Subklassen ueberschreibbar |
| `-` | private | rein interne Implementation |
| `~` | package / using | Type-Aliase, internal-linkage |

### 3.3 Vorgeschlagene Variablen + Methoden pro Concept (Auswahl, vollstaendig im drawio U01-U06)

**IExecutingEngine (Tab U01):**
- Attribute: `# cache_engine_`, `# observer_registry_`, `# lifecycle_state_`
- Methoden: `+ execute<Op>()`, `+ warm_up()`, `+ reset()`, `+ shutdown()`, `+ telemetry_hooks()`, `+ bind_cache_engine()`, `+ unbind_cache_engine()`

**ISearchEngine : IExecutingEngine (Tab U01):**
- Attribute: `- root_page_`, `- page_structure_`, `- cache_strategy_`, `- prt_art_container_`
- Methoden: `+ lookup()`, `+ insert()`, `+ erase()`, `+ range_scan()`, `+ begin()/end()`, `+ size()/empty()`

**IPage<P> (Tab U02):**
- Typen: `~ PageHeader`, `~ Value`
- Attribute: `# header_`, `# bytes_`
- Methoden: `+ lookup()`, `+ insert()`, `+ remove()`, `+ bytes()`, `+ value_type()`, `+ accept(visitor : ICacheStrategy&)`

**IFanout<F> (Tab U02):**
- Attribute: `- nodes_`, `- node_count_`, `- pages_strategy_pattern_`
- Methoden: `+ visit_each_child()`, `+ lookup_child()`, `+ insert_child()`, `+ remove_child()`, `+ load_factor()`, `+ pages_strategy_pattern()`
- Constraint: `inv: pages_strategy_pattern_ ist genau 1 pro IFanout` (K3.4)

**ISearchPagesStrategyPattern<SSP> (Tab U03):**
- Attribute: `- per_page_strategies_ : map<PageId, ISearchPageStrategy&>`, `- pattern_kind_ : PatternKind`
- Methoden: `+ assign_strategy()`, `+ strategy_for()`, `+ kind()`, `+ visit_assignments()`
- PatternKind enum: `AllPagesUniform`, `LayerMix`, `InnerVsLeaf`, `HotVsCold`, `DynamicRebalance`, `HierarchicalFractal`, `OrthogonalRuntimeParametrized`, `MultiStrategyOrchestration`, `HeterogeneousAdaptive`, `BoundaryNodePartition`

**IStrategyCommand (Tab U04, abstract):**
- Methoden: `+ virtual execute() = 0`, `+ virtual can_compose_with() = 0`, `+ virtual command_kind() = 0`, `+ virtual estimated_cost() = 0`, `+ virtual ~IStrategyCommand() = default`

**HybridCompositionCommand : IStrategyCommand (Tab U04):**
- Attribute: `- parts_`, `- composition_rule_`, `- composition_id_`
- Methoden: `+ execute() override`, `+ add_part()`, `+ remove_part()`, `+ part_count()`, `+ composition_rule()`, `+ set_composition_rule()`

**IPlatformProbe (Tab U05):**
- Methoden:
  - Discover-Phase: `+ discover_cache_topology()`, `+ discover_core_layout()`, `+ discover_isa_features()`, `+ discover_interconnect()`
  - Measure-Phase: `+ measure_cache_latencies()`, `+ measure_bandwidths()`, `+ measure_cache_coherence_cost()`, `+ measure_pinning_effects()`

**IHeuristic<H> (Tab U06):**
- Attribute: `# live_model_`, `# property_set_`
- Methoden: `+ recommend()`, `+ estimated_value()`, `+ confidence()`, `+ heuristic_kind()`

---

## 4. drawio REV 4 Tab-Struktur

| Tab-ID | Kategorie | Inhalt |
|--------|-----------|--------|
| K01 | Konzept | Drei-Ebenen-Architektur (Wurzel-Sicht) |
| K02 | Konzept | Saeule A Concept-Hierarchie (IPage bis ICachePage) |
| K03 | Konzept | ICacheStrategy Visitor + 4-Ebenen-Strategien |
| K04 | Konzept | Hybrid-Command-Pattern mit 17 Composition-Commands |
| K05 | Konzept | Saeule B Plattform-Modell (Auto-Discovery + 5-Schritte) |
| K06 | Konzept | Forschungs-Mission F15 (heuristisch / informiert / adaptiv) |
| U01 | UML | IExecutingEngine + ISearchEngine + IFutureEngine (mit Variablen + Methoden) |
| U02 | UML | Saeule A Page-Familie (IPage / IRootPage / IFanout / INode) |
| U03 | UML | Saeule A Strategy-Familie + ICacheStrategy + Iteratoren |
| U04 | UML | Hybrid-Command-Pattern Klassen (IStrategyCommand / HybridCompositionCommand / ICompositionRule) |
| U05 | UML | Saeule B Plattform-Probe + Auto-Discovery |
| U06 | UML | Saeule B Cache-Hierarchie + IHeuristic-Familie |
| MX1 | Konzept | Layer + Matrix Hybrid-Anordnung (Future-Proof) |

**Konzept-Tabs (K)** sind kompakte Beziehungs-Diagramme — keine Member.
**UML-Tabs (U)** sind professionelle Klassen-Diagramme mit Variablen + Methoden + Sichtbarkeiten.
**Matrix-Tab (MX)** ist die Layer-vs-Matrix-Architektur-Antwort.

---

## 5. Verzeichnis-Struktur REV 4 (Hybrid Layer + Matrix)

```
executing_engine/                                          (LAYER 1)
├── concepts/
│   ├── i_executing_engine.hpp
│   └── i_engine_lifecycle.hpp
└── search_engine/                                         (LAYER 1 Spezialisierung)
    ├── concepts/                                          (LAYER 2 Concept-Header)
    │   ├── i_page.hpp
    │   ├── i_root_page.hpp
    │   ├── i_fanout.hpp
    │   ├── i_node.hpp
    │   ├── i_search_page.hpp
    │   ├── i_cache_page.hpp
    │   ├── i_cache_strategy.hpp
    │   ├── i_search_pages_strategy.hpp
    │   ├── i_search_pages_strategy_pattern.hpp
    │   ├── i_search_page_strategy.hpp
    │   └── iterators/...
    ├── cache_strategies/                                  (MATRIX fuer Konkretisierungen)
    │   ├── visitor_variants/
    │   │   ├── base_engine_strategy.hpp                   (Achse 1A)
    │   │   └── cache_engine_strategy.hpp                  (Achse 1B)
    │   └── families/
    │       ├── f01_adaptive_footprint/                    (Achse 2.F1)
    │       ├── f02_succinct_encoding/                     (Achse 2.F2)
    │       ├── f03_cache_line_aligned/                    (Achse 2.F3)
    │       └── ...                                        (F4-F29 analog)
    ├── pages_strategies/
    │   └── patterns/                                      (10 PatternKind-Konkretisierungen)
    │       ├── all_pages_uniform_pattern.hpp
    │       ├── layer_mix_pattern.hpp
    │       └── ...
    └── commands/                                          (Hybrid-Command-Pattern)
        ├── i_strategy_command.hpp
        ├── hybrid_composition_command.hpp
        ├── i_composition_rule.hpp
        ├── pages/                                         (atomare Page-Strategy-Commands)
        ├── traversals/                                    (atomare Traversal-Commands)
        ├── prefetchers/
        ├── relocations/
        └── compositions/                                  (17 Composition-Commands)

cache_engine/                                              (LAYER 3)
├── platform_model/                                        (Concepts + Auto-Discovery)
│   ├── i_platform_probe.hpp
│   ├── i_platform_property_classifier.hpp
│   ├── i_cache_engine_option_publisher.hpp
│   ├── i_cache_level.hpp
│   ├── i_cache_topology.hpp
│   ├── i_cache_residency.hpp
│   ├── i_cpu_core.hpp
│   ├── i_core_layout.hpp
│   ├── i_pinning_policy.hpp
│   ├── i_isa_feature_set.hpp
│   ├── i_interconnect.hpp
│   ├── i_bus_topology.hpp
│   ├── i_memory_bandwidth_model.hpp
│   ├── i_live_platform_model.hpp
│   └── i_live_cpu_model.hpp
├── scheduling/
│   ├── i_scheduler.hpp
│   └── concrete/                                          (Achse: Scheduler-Variante)
│       ├── pinning_aware_scheduler.hpp
│       ├── numa_local_scheduler.hpp
│       └── round_robin_scheduler.hpp
├── heuristics/
│   ├── i_heuristic.hpp
│   └── concrete/                                          (Matrix-Achsen: Kategorie x Paper-Quelle)
│       ├── prefetch/                                      (Heuristik-Kategorie 1)
│       │   ├── adaptive_prefetch_distance_heuristic.hpp   (P23 Khan)
│       │   ├── prefetch_effectiveness_heuristic.hpp       (P24 Naderan-Tahan)
│       │   └── ...
│       ├── layout/                                        (Kategorie 2)
│       │   ├── cache_cost_dp_heuristic.hpp                (P05 START)
│       │   ├── width_cost_model_heuristic.hpp             (P13 Hankins)
│       │   └── ...
│       ├── coherence/                                     (Kategorie 3)
│       │   ├── cache_coherence_cost_heuristic.hpp         (P28 Kuehn)
│       │   └── ...
│       ├── platform/                                      (Kategorie 4)
│       │   ├── largest_l3_ccd_pinning_heuristic.hpp       (allgemein, ersetzt X3DAware)
│       │   ├── hot_path_on_high_ipc_core_heuristic.hpp    (allgemein, ersetzt IntelHybridP)
│       │   └── ...
│       └── isa/                                           (Kategorie 5)
│           ├── stride_vs_sequential_heuristic.hpp         (P32 To-Stride)
│           └── ...
└── decision_trees/                                        (F-EXTRA-6 PRO Baustein)
```

---

## 6. Aenderungen vs REV 3

| Bereich | REV 3 | REV 4 |
|---------|-------|-------|
| drawio-Korrektheit | XML-Fehler an Zeile 31 | XML-validiert (Python ElementTree OK) |
| Verbindungslinien | nicht orthogonal | `edgeStyle=orthogonalEdgeStyle` durchgaengig |
| Tab-Kategorisierung | gemischt | klar getrennt: Konzept (K) vs UML (U) vs Matrix (MX) |
| Variablen + Methoden | nur teilweise | systematisch in U-Tabs mit Sichtbarkeits-Konvention |
| Implementierungs-Anordnung | nicht explizit | Layer + Matrix Hybrid (MX1) |
| Future-Proof-Begruendung | implizit | explizite Sektion §2 mit 7 Prinzipien |
| Verzeichnis-Struktur | linear | Matrix-Achsen pro Concept (siehe §5) |

REV 3 bleibt vollstaendig erhalten; REV 4 ergaenzt — keine Loeschungen.

---

## 7. Naechste Schritte

1. **JETZT:** Du oeffnest `phase5_uml_detail_REV4.drawio` und prueft die 13 Tabs.
2. **Bei Akzeptanz:** Wir gehen zu Vorschlag (c) — OFFEN-Punkte aus `13_saeule_b_plattform_modell` durchgehen.
3. **Phase 6+:** Implementierung gemaess Verzeichnis-Vorschlag — Concept-Header zuerst, dann Matrix-Konkretisierungen achsenweise.

---

## 8. Web-Recherche-Quellen (2026-05-10)

Sources:
- [Software Architecture Principles in 2026: 12 Practical Rules](https://codewave.com/insights/software-architecture-principles-practices/)
- [Designing for Extensibility: Future-Proofing Software Architectures (MoldStud)](https://moldstud.com/articles/p-designing-for-extensibility-future-proofing-software-architectures)
- [Extensibility: Designing for Future Growth in Software Architecture (BuildSimple)](https://buildsimple.substack.com/p/extensibility-designing-for-future)
- [12 Enterprise Architecture Principles to Future-Proof IT in 2026 (Superblocks)](https://www.superblocks.com/blog/enterprise-architecture-principles)
- [Future-Proof Software Engineering (Transcenda)](https://www.transcenda.com/insights/future-proof-software-engineering-what-to-know)
- [Future-Proof Software-Systems: A Sustainable Evolution Strategy (ResearchGate)](https://www.researchgate.net/publication/336048954_Future-Proof_Software-Systems_A_Sustainable_Evolution_Strategy)
- [Software Extensibility: Complete Guide for Development Teams (Strapi)](https://strapi.io/blog/extensibility-in-software-engineering)
- [Layered Architecture - Software Architecture Patterns (O'Reilly)](https://www.oreilly.com/library/view/software-architecture-patterns/9781491971437/ch01.html)
- [Multitier architecture (Wikipedia)](https://en.wikipedia.org/wiki/Multitier_architecture)
- [Dependency Structure Matrix for Software Architecture (DZone)](https://dzone.com/articles/dependency-structure-matrix-for-software-architect)
- [Layered Architecture: Building Scalable & Maintainable Software Systems (Bitloops)](https://bitloops.com/docs/bitloops-language/learning/software-architecture/layered-architecture)
