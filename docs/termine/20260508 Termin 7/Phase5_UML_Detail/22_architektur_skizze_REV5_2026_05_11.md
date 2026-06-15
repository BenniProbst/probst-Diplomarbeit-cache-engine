# Architektur-Skizze REV 5 (kanonisch, 2026-05-11)

**Status:** REV 5 = REV 3 NACHARBEITUNG + REV 4 Delta + Review-Korrekturen 2026-05-11
**Vorgaenger:** `20_architektur_skizze_REV3_2026_05_10.md` (kanonische REV 3) + `21_architektur_skizze_REV4_2026_05_10.md` (REV 4 mit Future-Proof + Layer-Matrix)
**Begleit-Dateien:** `11_cache_strategy_taxonomie.md` (29 ICacheStrategy-Familien F1-F29), `12_algorithmus_strategie_taxonomie.md` (4-Ebenen + 17 Hybrid-Commands), `13_saeule_b_plattform_modell_konkretisierung.md` (~80 Heuristiken + 28 fehlende Concepts)
**drawio:** `phase5_uml_detail_REV5.drawio` (12 Konzept + 8 UML + 2 Matrix = 22 Tabs)

---

## 0. Einarbeitung der Review-Korrekturen 2026-05-11

| Tab | Review-Befund | REV 5 Korrektur |
|-----|---------------|------------------|
| K02 | Hierarchie unvollstaendig: ISearchPageStructure + ISearchPageStructureInterpreter fehlen | NEU §2.1+§2.2: jede ISearchPage besitzt eine ISearchPageStructure; ISearchPageStructureInterpreter dekodiert die variable lokale Codierung (Invariante I4 aus Termin 2) und stellt Iteratoren je Such-Element bereit |
| K03 | CacheEngineBuilder-Permutationsdimension fehlt | NEU §3.3: User waehlt zur Compile-Time **oder** CacheEngineBuilder erzeugt aus ICacheStrategy eine eigene Permutationsdimension fuer F15-Vergleich (Basis-Heuristik vs. Cache-Engine) |
| K04 | korrekt (kein Aenderungsbedarf) | unveraendert vs REV 3 |
| K05 | PRT-ART-Bausteinkombination unvollstaendig — Termin 1-6 nicht eingearbeitet | NEU §5.2: 7-Quellen-Hybrid (CoCo + ART + START + HOT + Masstree + CSS/CSB+ + B^2-Tree), 6 Seitentypen (Redirect/Dense-ART/Multilevel-START/Sparse-HOT/Decision-Span-B^2/Custom-Aligned), 3 Iteratoren (Prefix/Enumeration/Range), ValueHandle::Inline/External/ChainRef |
| K06 | falsch: Hybrid-Command muss als ISearchEngine-Familien-Taxonomie analog 11_md uebertragen werden | NEU K13/K14: ISearchEngine-Familien-Taxonomie mit atomaren + Hybrid-Strategy-Commands wie 11_md fuer ICacheEngine |
| K07 | unvollstaendig vs Termin-Inhalt | NEU §7.2: 28 fehlende Saeule-B-Concept-Klassen (`IRankSelectPrimitive`, `IBranchPredictorModel`, `IBitManipulationFeatureGate`, `IStorageMedium`, `IPageCacheModel`, `IConcurrencyProtocol`, `IRebuildScheduler`, `IRebuildCostModel`, `IWorkloadModel`, `ICellProbeModel` vs `IWordProbeModel`, ...) integriert |
| K08 | unvollstaendig vs 33-Paper-Code | NEU §8.2: Plattform-Modell verfeinert um NUMA-Awareness, TLB-Modell, Hardware-Counter-Feedback, NVRAM/Persistent-Memory, 6-Flavor-RCU-Klassifikation |
| K09 | gemeinsam mit K08 vollstaendig pruefen | §9: alle ~80 Heuristiken aus 13_md §9 + 12_md §4 vereint und bereinigt |
| K10 | Layout-Familien enthalten nicht-zerlegte hybride Layouts | NEU §10.2: 8 fehlende Hybrid-Aufloesungen ergaenzt (F8 PathCollapse, F11 P11/P22/P26, F13 P17 vEB, F14 P18, F22 P12+P23, F25 P07/P08, F27 P33, F28 P31) |
| K11 | Darstellungsfehler: Pfeil Phase 5 zeigt direkt auf Phase 7 statt Phase 6 | drawio-Korrektur: Phase 5 → Phase 6 → Phase 7 (sequentiell) |
| K12 | Cache+Search-Permutationen-Cross fehlt | NEU §12.2: Bausteine der Cache-Engine permutieren GEGEN Permutationen der Search-Engine; F15 = vollstaendige Cross-Matrix mit beiden Permutations-Achsen |

---

## 1. Drei-Ebenen-Architektur (Wurzel-Sicht, REV 5)

PRT-ART ist auf drei klar getrennten Ebenen organisiert:

```
EBENE 1 - IExecutingEngine
   Wurzel-Abstraktion fuer alle Engines, die CacheEngine konsumieren
   ISearchEngine (PRT-ART-Diplomarbeit-Fokus)
   IFutureEngine (Architektur-Slot - z.B. ICompactingEngine, ISortingEngine)

   konsumiert
   v
EBENE 2 - Suchalgorithmus-Datenstruktur (Saeule A)
   IPage / IRootPage / IFanout / INode / ISearchPage / ISearchPageStructure /
   ISearchPageStructureInterpreter / ICachePage / ICacheStrategy (Visitor) /
   ISearchPagesStrategy / ISearchPagesStrategyPattern / ISearchPageStrategy /
   IStrategyCommand / HybridCompositionCommand / Iteratoren-Familie (3 Pflicht)

   optimiert via
   v
EBENE 3 - CacheEngine + Plattform-Modell (Saeule B)
   IPlatformProbe (Auto-Discovery) / IPlatformPropertyClassifier /
   ICacheLevel / ICacheLine / ICacheTopology / ICacheResidency /
   ICpuCore / ICoreLayout / IPinningPolicy / IInterconnect / IBusTopology /
   IRankSelectPrimitive / IBranchPredictorModel / IBitManipulationFeatureGate /
   IStorageMedium / IPageCacheModel / IConcurrencyProtocol /
   IRebuildScheduler / IRebuildCostModel / IWorkloadModel /
   IHardwareExtension / IIsaFeatureSet /
   ILivePlatformModel / ILiveCpuModel /
   IScheduler / IHeuristic / ICacheEngineOptionPublisher /
   DecisionLambdaTrees
```

**Trennungs-Prinzip (REV 5 verfeinert):**
- Ebene 1 ist generisch — jede Engine kann CacheEngine als Optimierungs-Service nutzen
- Ebene 2 weiss nichts direkt von CPU/Caches/Bandbreiten — konsumiert nur ICacheStrategy
- Ebene 3 ist plattform-agnostisch im Code, plattform-konkret im Verhalten via Auto-Discovery
- **Future-Proof:** Open/Closed an jedem Concept-Header, Modular-Architecture pro Achse, Encapsulation via stable contracts (siehe §13)

---

## 2. EBENE 2 — Saeule A: ISearchEngine (REV 5 mit Interpreter + Structure)

### 2.1 Concept-Hierarchie (vollstaendig REV 5)

```
«concept» IPage<P>                                       (Top-Abstraktion: jede „Seite")
   inherits
«concept» IRootPage<R> : IPage                           (Wurzel-Spezialisierung)
   composes 1 IFanout

«concept» IFanout<F>                                     (Verzweigungs-Abstraktion)
   composes [N] INode  via «contains»
   has EXACTLY 1 ISearchPagesStrategy                    ★ K3.4 erweitert REV 5 ★
   has EXACTLY 1 ISearchPagesStrategyPattern              ★ K3.4 ★

«concept» INode<N>                                       (Verzweigungs-/Daten-Einheit)
   placed on ISearchPage  via «mapped via ISearchPageStrategy»

«concept» ISearchPage<S>                                 (logische Such-Seite)
   contains [N] INode
   has EXACTLY 1 ISearchPageStructure                    ★ NEU REV 5 ★
   has EXACTLY 1 ISearchPageStructureInterpreter         ★ NEU REV 5 ★
   mapped onto ICachePage[s]  via «ICacheStrategy»

«concept» ISearchPageStructure<SST>                      ★ NEU REV 5 ★
   - encoding : Encoding (eine der 6 PRT-ART-Seitentyp-Kodierungen)
   - layout_invariants : LayoutInvariantSet
   - 6 Konkretisierungen: RedirectStructure, DenseByteStructure,
     MultilevelDenseStructure, SparsePatriciaStructure,
     DecisionSpanStructure, CustomAlignedStructure

«concept» ISearchPageStructureInterpreter<SSI>           ★ NEU REV 5 ★
   - interpret(structure, key) -> NextSlot/Handle/Pointer/ValueHandle
   - bietet Iteratoren je nach Such-Element
   - 6 Konkretisierungen analog ISearchPageStructure
   - Begruendung: Invariante I4 (lokale Seitencodierung darf variieren,
     solange Ordnungsrelation der rohen Byte-Keys nicht verletzt wird)

«concept» ICachePage<C>                                  (physische Speicher-Repraesentation)
   - size : size_t
   - cache_line_formation : CacheLineFormation
   - influenced_by : CacheEngine
```

### 2.2 ISearchPageStructure x ISearchPageStructureInterpreter Matrix

| Seitentyp (PRT-ART) | ISearchPageStructure | ISearchPageStructureInterpreter | Iterator(en) |
|---------------------|----------------------|----------------------------------|---------------|
| Redirect-Page (CoCo) | RedirectStructure (komprimierter Reststring) | RedirectInterpreter (memcmp/byte-prefix) | PrefixIterator |
| Dense-Byte-Page (ART) | DenseByteStructure (1-Byte direkt-adressiert, Node4/16/48/256) | DenseByteInterpreter (linear scan SIMD-aware) | EnumerationIterator (forward) |
| Multilevel-Dense-Page (START) | MultilevelDenseStructure (mehrbyteig, Cost-Modell) | MultilevelInterpreter (Cost-DP-gestuetzte Suche) | EnumerationIterator + RangeIterator |
| Sparse-Patricia-Page (HOT) | SparsePatriciaStructure (k-constrained, diskriminierende Bits) | PatriciaInterpreter (single/multi-mask AVX2/BMI2) | EnumerationIterator |
| Decision-Span-Page (B^2) | DecisionSpanStructure (Decision + Span Sub-Trees pro 64KiB) | B2Interpreter (Decision-then-Span page-lokale Suche) | EnumerationIterator |
| Custom-Aligned-Page (PRT-ART intern) | CustomAlignedStructure (cache-line-aligned, pool-relative Handles) | CustomInterpreter (B^2-aehnlich, eigene Optimierungen) | EnumerationIterator + RangeIterator |

### 2.3 ICacheStrategy als Visitor-Pattern (REV 5 mit 3 visit-Slots)

```
«concept, visitor» ICacheStrategy<CS>
   + visit(read_op : PageReadOp&) : void
   + visit(write_op : PageWriteOp&) : void
   + visit(layout_op : PageLayoutOp&) : void                ★ NEU REV 4/5 ★

«concrete» BaseEngineStrategy : ICacheStrategy           (NICHT-OPTIMIERT, Baseline F15)
   - StaticEngine-Pfad: Originalcode-Bauteil ohne CacheEngine-Beeinflussung
   - keine ILivePlatformModel-Konsultation; keine Heuristik-Aufrufe

«concrete» CacheEngineStrategy : ICacheStrategy          (CACHE-ENGINE-OPTIMIERT)
   - konsumiert ILivePlatformModel + ICacheResidency + IHeuristic (Ebene 3)
   - kann Read/Write umrouten auf bessere Cache-Ebene
   - kann Page-Layout vor Write rearrangieren via visit(layout_op)
```

### 2.4 ISearchPagesStrategy + Pattern + ISearchPageStrategy (Multiplizitaeten K3.4 fixiert)

```
«concept» ISearchPageStructureContainer<SSC>             (Container fuer mehrere ISearchPage)
   contains [N] ISearchPage  in geordneter Abfolge

«concept» ISearchPagesStrategy<SPS>                      ★ K3.4 REV 5 ★
   - 1 pro IFanout (eindeutig)
   - controls: insertion / removal / re-ordering / consolidation
   - delegates per-page entry handling via ISearchPagesStrategyPattern
   - z.B. BPlusTreePerLayerStrategy, AdaptiveRadixTreeStrategy,
     KConstrainedHotStrategy, MacroNodeCollapsingStrategy, etc.

«concept» ISearchPagesStrategyPattern<SSP>               (PATTERN: Anordnungs-Vorschrift)
   - 1 pro IFanout (eindeutig)
   - has N ISearchPageStrategy (eine pro ISearchPage)
   - 21 Patterns aus 12_md §1 (siehe K06)

«concept» ISearchPageStrategy<SP>                        (POLICY: pro EINE ISearchPage)
   - controls: where in the page key-value goes
   - controls: when to split/merge the page
   - controls: layout invariants
   - 1 pro ISearchPage; ISearchPagesStrategyPattern hat N davon
   - 74 Singular-Strategien aus 12_md §3
```

---

## 3. K03 — ICacheStrategy als Permutationsdimension (REV 5 erweitert)

### 3.1 Compile-Time-Wahl

User kann beim Build per Template-Parameter waehlen:
```cpp
using SearchEngine = ISearchEngine<
    BaseEngineStrategy,             // Visitor 1: Baseline F15
    /*oder*/ CacheEngineStrategy    // Visitor 2: CacheEngine-aktiv
>;
```

### 3.2 CacheEngineBuilder-Generierung (Permutationsdimension)

Alternativ: `CacheEngineBuilder` entwirft mit der Eigenschaft der ICacheStrategy eine eigene Permutationsdimension:

```cpp
class CacheEngineBuilder {
    // Permutationsdimension N+1: ICacheStrategy-Variant
    auto build_permutations() {
        return {
            { Strategy = BaseEngineStrategy,        // Variante 1
              CacheModus = NONE                  },
            { Strategy = CacheEngineStrategy,       // Variante 2
              CacheModus = HEURISTIC_STATIC      },
            { Strategy = CacheEngineStrategy,       // Variante 3
              CacheModus = INFORMED_KALIBRIERT   },
            { Strategy = CacheEngineStrategy,       // Variante 4
              CacheModus = AUTOMATIC_ADAPTIVE    }
        };
    }
};
```

**Zweck:** Pro Search-Engine-Permutation entstehen 4 Builds (1 Baseline + 3 CacheEngine-Modi). F15 vergleicht alle 4 systematisch.

### 3.3 F15-Vergleich-Pflicht

Jede Permutation des 4-Ebenen-Tupels (Pattern x Plural x Singular x Heuristic) wird in 4 Versionen gebaut + gemessen:
- **V1:** BaseEngineStrategy (kein CacheEngine, statische Heuristik) — Baseline
- **V2:** CacheEngineStrategy + HEURISTIC_STATIC (passive Defaults)
- **V3:** CacheEngineStrategy + INFORMED_KALIBRIERT (Warm-up-Mikrobenchmark)
- **V4:** CacheEngineStrategy + AUTOMATIC_ADAPTIVE (online-adaptive)

Vergleich liefert: hat die CacheEngine-Investition messbaren Mehrwert? In welchem Modus? Auf welcher Plattform?

---

## 4. K04 — 4-Ebenen-Strategien (REV 5 unveraendert vs REV 3)

User-Bestaetigung 2026-05-11: K04 ist korrekt.

```
Ebene A: ISearchPagesStrategyPattern (1 pro IFanout)
   21 Patterns aus 12_md §1 (10 Komposition + 6 Adaptivitaet + 5 Aufbau)

Ebene B: ISearchPagesStrategy PLURAL (N pro Pattern)
   41 Plural-Strategien aus 12_md §2:
   - 12 BPlus-Familie (P03/P11/P12/P13/P14/P21/P22)
   - 8 Trie-Familie (P01/P02/P04/P05/P09/P10)
   - 8 Hybrid-Familie (P07/P11/P21/P22/P26)
   - 10 Layout-Theorie-Familie (P15/P16/P17/P18/P19/P28)
   - 3 Adaptive-Layout-Selectors (P05/P14/P20)

Ebene C: ISearchPageStrategy SINGULAR (1 pro ISearchPage)
   74 Singular-Strategien aus 12_md §3:
   - 22 Intra-Page Search-Strategien
   - 15 Intra-Page Insert/Update-Strategien
   - 28 Intra-Page Layout-/Encoding-Strategien
   - 9 Concurrency-Strategien innerhalb Page

Ebene D: IHeuristic (beliebig, parametriert die Strategien)
   ~80 paper-abgeleitete Heuristiken aus 13_md §9 + 12_md §4
```

---

## 5. K05 — PRT_ART vollstaendige Bausteinkombination (NEU REV 5 aus Termin 1-6)

### 5.1 Architektur-Freeze in 4 Schichten (Termin 4 Scope-Freeze)

```
A. Trie-Huelle mit Redirect-Knoten fuer kollabierte Praefixpfade (CoCo-trie-Idee)
B. Suchseitenfamilie mit mehreren implementierten Seitentypen
C. Terminale Knoten mit ValueHandle als Uebergang zur Payload
D. Cache-Engine als explizite Steuerungsschicht fuer Layout, Prefetch, Affinity, Rebuild
```

### 5.2 7-Quellen-Hybrid (vollstaendig aus Termin 1+2)

| Baustein | Quelle | Rolle in PRT-ART |
|----------|--------|------------------|
| Redirect-Page / Trie-Huelle | CoCo-trie (Belazzougui/Boffa) | Globale praefixorientierte Huelle, data-aware Subtrie-Collapse |
| Dense-Byte-Page | ART (Leis/Kemper/Neumann 2013) | 1-Byte direkte Adressierung, Node4/16/48/256 |
| Multilevel-Dense-Page | START (Fent et al.) | Mehrbyteige Seiten, Cost-Modell, Schwellwert-Umschaltung |
| Sparse-Patricia-Page | HOT (Binna et al. 2018) | Diskriminierende Bits, k-constrained, 9 Layouts |
| Decision-Span-Page | B^2-Tree (Schmeisser et al. 2022) | Page-lokale Decision/Span Subtrees pro 64KiB |
| PRT-Custom-Cache-Page | CSS+CSB+ + B^2 | Cache-line-aligned, pool-relative Handles |
| Subbaumgrenzen / Fences | Masstree (Mao/Kohler/Morris) | Fences, getrange-Semantik (NICHT als lokaler B+) |
| Hardwareprofil-Kalibrierung | Processor-conscious CSB+ (Samuel) | Hardware-Discovery + ISA-spezifische Schwellwerte |

### 5.3 6 Seitentypen mit P0/P1/P2-Prioritaet (Termin 4 Scope-Freeze)

| Klasse | Literaturanker | Prioritaet | ISearchPageStructure | ISearchPageStructureInterpreter |
|--------|----------------|-----------|---------------------|----------------------------------|
| Redirect-Knoten | CoCo-trie | P0 | RedirectStructure | RedirectInterpreter |
| Dense-Byte-Page | ART | P0 | DenseByteStructure | DenseByteInterpreter |
| Sparse-Patricia-Page | HOT | P0/P1 | SparsePatriciaStructure | PatriciaInterpreter |
| Multilevel-Dense-Page | START | P1 | MultilevelDenseStructure | MultilevelInterpreter |
| Decision-Span-Page | B^2-Tree | P2 | DecisionSpanStructure | B2Interpreter |
| Custom-Aligned-Page | PRT-ART intern | P2 | CustomAlignedStructure | CustomInterpreter |

### 5.4 ValueHandle (Pflicht-Datenpfad)

```
«concept» ValueHandle
   Drei Auspraegungen (compile-time + runtime parametrisierbar):
   - Inline       : Value direkt im terminalen Knoten (kleine Werte)
   - External     : Pointer auf externen Payload-Speicher (grosse Werte)
   - ChainRef     : verkettete Referenz fuer Multi-Value (vertagt P3)

   Inline-vs-External-Grenze ist H3-Hypothese (architektur+workloadabhaengig)
   und MUSS aktiv ueber Kostenmodell gewaehlt werden.
```

### 5.5 Iteratoren-Familie (Pflicht: 3 Iteratoren mit beiden Richtungen)

```
class comdare::prt_art<Key, Value>
   + iterator           (mutable forward iterator)
   + const_iterator
   + reverse_iterator
   + const_reverse_iterator
   + range_iterator     (lex-Modus, getrange-Semantik aus Masstree)
   + key_iterator
   + value_iterator
   + prefix_iterator    (fuer Prefix-Lookup, abgeleitet aus Termin 1 final)

«concept» INodeIterator<NI>                              (visit_each_child, byte-by-byte)
«concept» ISearchPageIterator<SI>                        (Range-Scan ueber ISearchPage)
«concept» ISearchPageStrategyIterator<SSI>               (Cross-Algorithm-Iteration)

3 Pflicht-Iteratoren-Semantik-Modi (Termin 2):
   - Default-Modus       : keine garantierte Enumerationsreihenfolge
   - Lokaler Ordnungsmodus : geordnete Eintraege innerhalb einer Seite
   - Lex-Modus           : global lexikographisch (Prefix Enumeration + Range)

User-Direktive: "Iterator wird in all unseren Arbeiten immer vollstaendig implementiert"
=> beide Richtungen (asc + desc) + custom Modus (Termin 2 API-Entscheidung)
```

### 5.6 6 Invarianten (Termin 2 hart eingefroren)

| ID | Invariante |
|----|------------|
| I1 | Jeder Lookup traversiert ausschliesslich Navigationsknoten bis zu terminalem Knoten oder Miss |
| I2 | Terminaler Knoten besitzt genau ein ValueHandle; Payload standardmaessig extern, optional inline |
| I3 | Redirect-Knoten komprimieren eindeutige Restpfade, ersetzen NICHT echte Mehrfachverzweigung |
| I4 | Lokale Seitencodierung darf variieren, solange Ordnungsrelation der rohen Byte-Keys nicht verletzt wird (=> ISearchPageStructureInterpreter PFLICHT) |
| I5 | Seitentyp-Umschaltungen sind explizite Policy-Entscheidungen; KEINE festen universellen Schwellwerte |
| I6 | Concurrency bleibt im Kernumfang auf spaetere Erweiterung begrenzt; Single-Thread + Read-Scaling-Vorbereitung |

### 5.7 4 Hypothesen (Termin 4 Scope-Freeze)

| ID | Hypothese |
|----|-----------|
| H1 | Aktive Cache-Engine verbessert CLU, Footprint und Laufzeit gegenueber statischen Layouts |
| H2 | Dense-/Sparse-/Multilevel-Seiten gewinnen abhaengig von Datensatz/ISA/Core-Typ/Ordnungsmodus unterschiedlich |
| H3 | Inline-vs-ValueHandle-Grenze ist architektur- und workloadabhaengig, MUSS aktiv gewaehlt werden |
| H4 | Online-Umlagerung + Prefetching helfen NUR wenn Seitentyp + Wertablage + Affinity gemeinsam modelliert werden |

---

## 6. K06 — ISearchEngine-Familien-Taxonomie (NEU REV 5 analog 11_md fuer Saeule A)

User-Kritik 2026-05-11: K06 muss ISearchEngine-Familien analog zu 11_cache_strategy_taxonomy fuer ICacheEngine modellieren.

### 6.1 Strategie-Familien-Definition

Analog zu den 29 ICacheStrategy-Familien F1-F29 in 11_md werden hier die ISearchEngine-Strategie-Familien aus 12_md §1-3 als orthogonale Familien gruppiert. Statt "Cache-Disziplinen" sind es "Such-Algorithmus-Disziplinen" — beide sind Achsen der Bausteine_Matrix.

### 6.2 ISearchEngine Strategy-Familien S1-S21 (Pattern-Ebene A)

**S1-S10 Komposition-Patterns:**
| ID | Concept-Klasse | Konkretisierungen | Hybrid-Status |
|----|----------------|---------------------|---------------|
| S1 | `IAllPagesUniformPattern` | P11 CSS, P12 CSB+, P14 Samuel, P21 Chen | atomar |
| S2 | `ILayerMixPattern` | P03 Masstree, P10 SuRF, P04 CoCo, P22 fpB+ | HYBRID (4 Sub-Patterns) |
| S3 | `IInnerVsLeafPattern` | P02 HOT, P10 SuRF Dense/Sparse, P04 CoCo, P19 alpha-subgraph, P22 | HYBRID (5 Sub-Patterns) |
| S4 | `IHotVsColdPattern` | P26 Zhang FGCS, P28 Kuehn, P10 SuRF | HYBRID (3 Sub-Patterns) |
| S5 | `IDynamicRebalancePattern` | P05 START, P18, P19, P20 Mueller-Benson-Leis | HYBRID (4 Sub-Patterns - Aufloesung in §6.5) |
| S6 | `IHierarchicalFractalPattern` | P22 fpB+, P15, P06 B^2 | HYBRID (3 Sub-Patterns) |
| S7 | `IOrthogonalRuntimeParametrizedPattern` | P23 Khan, P26, P14 ConfigTable | HYBRID (3 Sub-Patterns) |
| S8 | `IMultiStrategyOrchestrationPattern` | P07 Wormhole, P26, P15 | HYBRID (3 Sub-Patterns) |
| S9 | `IHeterogeneousAdaptivePattern` | P20 Mueller-Benson-Leis | HYBRID (Sub-Pattern Aufl. in §9 #17) |
| S10 | `IBoundaryNodePartitionPattern` | P20 Sequential-Insert FDL | atomar / Sub-Pattern |

**S11-S16 Adaptivitaets-Patterns:**
| ID | Concept-Klasse | Konkretisierungen | Hybrid-Status |
|----|----------------|---------------------|---------------|
| S11 | `IOfflineSelfTuningPattern` | P05 START | HYBRID (in §9 #9 aufgeloest) |
| S12 | `IOnlineProbabilityRebalancePattern` | P28 Kuehn, P26 | HYBRID (P28 in §9 #7 aufgeloest) |
| S13 | `IOnEveryStructureModificationPattern` | P19 Saikkonen Local Reloc | HYBRID (Aufl. NEU REV 5 §9.18) |
| S14 | `IPeriodicGlobalRelocationPattern` | P19 Composite mit P18 | HYBRID (Aufl. NEU REV 5 §9.19) |
| S15 | `IBulkLoadLevelByLevelPattern` | P11 / P12 / P14 | atomar |
| S16 | `ICompoundFastBuildPattern` | P02 HOT k-constrained, P04 CoCo Post-Order DP | HYBRID (P02 §9 #5, P04 §9 #3) |

**S17-S21 Aufbauverfahren-Patterns:**
| ID | Concept-Klasse | Konkretisierungen | Hybrid-Status |
|----|----------------|---------------------|---------------|
| S17 | `IBfsLevelByLevelPagePackingPattern` | P18 Saikkonen | atomar |
| S18 | `IRecursiveDfsBlockPackingPattern` | P17 vEB, P11 CSS Build | HYBRID (P17 Aufl. NEU REV 5 §9.20) |
| S19 | `IProbabilityGreedyPagePackingPattern` | P16 Bender, P28 Kuehn | atomar |
| S20 | `IPostOrderDpPattern` | P04 CoCo, P05 START Bellman-DP | HYBRID (P04+P05 in §9 #3+#9) |
| S21 | `IRecursiveCommonPrefixDecompositionPattern` | P06 B^2-Tree | HYBRID (in §9 #12 aufgeloest) |

### 6.3 ISearchEngine Strategy-Familien S22-S26 (Plural-Ebene B)

| ID | Familie | Konkretisierungen (Anzahl) |
|----|---------|----------------------------|
| S22 | `BPlus-Familie` | 12 Strategien (BPlusTreePerLayer P03, ClassicBPlus, CSS-Full P11, CSS-Level P11, CSBPlus-Basic P12, CSBPlus-Segmented P12, CSBPlus-FullPreallocated P12, WideNodeBPlus P21, FractalBPlus-DiskFirst P22, FractalBPlus-CacheFirst P22, LargeNodeBPlus P13, EmbeddedSecondaryIndex P06) |
| S23 | `Trie-Familie` | 8 Strategien (AdaptiveRadixTree P01, MultilevelAdaptiveRadix P05, KConstrainedHot P02, MacroNodeCollapsing P04, LoudsDenseSparse P10, JacobsonLouds P09, WormholeTriple P07, PathCompressedTrie P01/P02) |
| S24 | `Hybrid-Familie` | 8 Strategien (TripleHashThenBPlus P07, StaticPreSortedDirectory P11, EmbeddedDecisionSpanTree P06, JumpPointerArray-External P21, JumpPointerArray-Internal P21, DualJumpPointerArray P22, JumpPointerVersionChain P26, MicroIndexing P22) |
| S25 | `Layout-Theorie-Familie` | 14 Strategien (vEB P17, DynamicVEB-PMA P17, BufferNodesVEB P17, IndirectedVEB P17, CacheSensitiveMultiLevel P18, LocalReloc-alpha2 P19, LocalReloc-alpha-N P19, ProbabilityWeightedRootBlock P16, ProbabilityGreedy P16, RelaxedGreedy P16, CacheObliviousProbabilityLayout P16, BTreeOfCacheLines P15, VerticalPartitioning P15, HotPathLayout P28) |
| S26 | `Adaptive-Layout-Selectors` | 3 Strategien (AdaptiveLeafSelector P20, OfflineSelfTuning P05, ConfigurationLookup P14) |

### 6.4 ISearchEngine Singular-Strategien S27-S30 (Singular-Ebene C)

| ID | Sub-Familie | Anzahl |
|----|-------------|--------|
| S27 | Intra-Page Search-Strategien | 22 atomare Singular-Strategien |
| S28 | Intra-Page Insert/Update-Strategien | 15 atomare Singular-Strategien |
| S29 | Intra-Page Layout-/Encoding-Strategien | 28 atomare Singular-Strategien |
| S30 | Concurrency-Strategien innerhalb Page | 9 atomare/Hybrid-Singular-Strategien (TripleClassConcurrency P07, DualHashTableCoW P07 als Hybride - Aufl. NEU §9.21+§9.22) |

### 6.5 NEU REV 5: Hybrid-Auflösungen, die §9 in 12_md fehlten

| § neu | Quelle | Atomare Strategy-Commands | HybridCompositionCommand |
|-------|--------|---------------------------|--------------------------|
| §9.18 | S13 P19 LocalReloc | `OnModRelocationCommand` + `LocalAlphaRelocationCommand` + `WaitFreeRelocationCommand` | `OnEveryStructureModificationCompositionCommand` |
| §9.19 | S14 P18+P19 GlobalReloc | `BfsGlobalRelocationCommand` + `LocalReloc-Composite` + `PeriodicTriggerCommand` | `PeriodicGlobalRelocationCompositionCommand` |
| §9.20 | S18 P17 vEB Layout | `VEBClassicCommand` + `DynamicVEBPmaCommand` + `BufferNodesVEBCommand` + `IndirectedVEBCommand` | `VEBLayoutVariantCompositionCommand` |
| §9.21 | S30 P07 TripleConcurrency | `Class1RcuCommand` + `Class2RWLockCommand` + `Class3MutExCommand` | `WormholeTripleConcurrencyCompositionCommand` |
| §9.22 | S30 P07 DualHashTable | `T1MetaTrieHashCommand` + `T2CowMetaTrieHashCommand` + `BarrierSwapCommand` | `WormholeDualHashTableCompositionCommand` |

(Plus die 8 fehlenden Cache-Familien-Aufloesungen in K10/§10.2)

---

## 7. K07 — IPlatformProbe Auto-Discovery (REV 5 mit 28 fehlenden Concepts)

### 7.1 5-Schritt-Pflicht (CacheEngineBuilder pro Permutations-Build)

```
1. DISCOVER (statisch)  - CPUID / sysfs / /proc/cpuinfo / hwloc
2. MEASURE (dynamisch)  - Mikrobenchmark (clflush-cycle / All-Pairs-Pinning /
                          Cache-Coherence-Calibration)
3. CLASSIFY            - Properties zusammenstellen (PlatformPropertySet)
4. PUBLISH             - Properties allen Permutations-Modulen als Konfigurations-Optionen
5. BIND                - Pro Permutation entscheidet ICacheStrategy-Visitor
```

### 7.2 NEU REV 5: 28 fehlende Saeule-B-Concept-Klassen aus 13_md §6+§7

```
«concept» IPlatformProbe (REV 3 vorhanden)
«concept» IPlatformPropertyClassifier (REV 3 vorhanden)
«concept» ICacheEngineOptionPublisher (REV 3 vorhanden)

NEU REV 5 (aus 13_md §7.1+§7.2 als zwingend identifiziert):

1.  «concept» IRankSelectPrimitive    - popcount / Jacobson Two-Level / Poppy
2.  «concept» IModelAcquisitionStrategy - wie ILivePlatformModel gewonnen?
3.  «concept» IVirtualMemoryStrategy  - DirectMapping / RewiredSharedPages / HugePages
4.  «concept» IBranchPredictorModel   - Mispredict-Cost als Plattform-Kennzahl
5.  «concept» IBitManipulationFeatureGate - BMI2 PEXT/PDEP, AVX2, popcount + Fallback
6.  «concept» IStorageMedium          - DRAM/NVRAM/SSD/HDD-Hierarchy
7.  «concept» IPageCacheModel         - OS Page Cache + App Block Cache (2-stufig)
8.  «concept» IConcurrencyProtocol    - eigene Saeule C, orthogonal A/B
9.  «concept» IRebuildScheduler       - VACUUM-aehnliche Trigger
10. «concept» IRebuildCostModel       - O(N h^2) bei P04 CoCo
11. «concept» IWorkloadModel          - Read-Only/Read-Mostly/Write-Heavy/Mixed/Skewed
12. «concept» ICellProbeModel vs. IWordProbeModel - 2 alternative Plattform-Modelle (P09)
13. «concept» IPositionalCorrespondencePrefetch - Prefetch via Layout-Invariante
14. «concept» ICacheConflictModel     - FullAssociative vs. SetAssociative
15. «concept» ITemporalCacheStrategy  - Instruction-Cache, P15 §7
16. «concept» IIntelligentDMA         - Configurator/AGU/DataFetcher/Crawler (P31 iDMA)
17. «concept» IComputeOffload         - PE/iDMA/App-Core/FPGA (P31)
18. «concept» IHardwareExtension Sub-Hierarchie - WAH/PLWAH/COMPAX, Hash-Lookup, MergeSort, RiscBaseISA, SSE/AVX/SGX/THUMB/NEON
19. «concept» IMemoryDecorator (NFP)  - latency/throughput/transience/reliability/wearout (P33)
20. «concept» IHeterogeneousAllocator (V-malloc) - heterogene Memory-Auswahl (P33)
21. «concept» IMigrationPolicy        - transparente Migration zwischen Memory-Ebenen (P33)
22. «concept» ICompileTimeNegotiator  - Multi-Query Compile-Time-Negotiation (P33)
23. «concept» IPipelineScheduler      - Operation-Pipelines mit Memory-Awareness (P33)
24. «concept» IAccessPatternStrategy  - sequential/strided/simd (P32)
25. «concept» IPaddingStrategy        - 576-Byte-Padding fuer Cache-Set-Disalignment (P32)
26. «concept» IInformationTheoreticLowerBound - Optimality-Marker fuer Encoding (P09)
27. «concept» IPositionalAddressing   - Implicit Addressing via Position-in-Bitstring (P09)
28. «concept» ITopologyEncoding       - LOUDS/DFUDS/BP/Pointer/BitArray (orthogonal zu IFanout)
```

### 7.3 PlatformPropertySet (REV 5 erweitert auf 7+ Properties)

```
struct PlatformPropertySet {
    // REV 3
    bool has_asymmetric_l3;       // entdeckt
    bool has_hybrid_cores;         // entdeckt
    PinningPolicy preferred_pinning;  // gemessen

    // REV 4 ergaenzt
    bool has_hbm_tier;             // entdeckt
    int  usable_simd_width;        // gemessen
    bool has_software_prefetch;    // entdeckt
    double coherence_cost_threshold; // gemessen

    // NEU REV 5
    BranchPredictorModel branch_predictor; // 24-Cycle vs. 14-Cycle Mispredict-Cost
    bool has_bmi2_pext_pdep;       // BMI2 fuer HOT P02
    StorageMediumKind primary_storage; // DRAM/NVRAM
    PageCacheModel page_cache_model;   // OS-Cache vs App-Cache
    int memory_channels;            // DDR5-Bandwidth-Modell
    bool has_3d_v_cache;           // Block AO Ryzen 9950X3D
    bool has_intel_thread_director; // Block AO i9-14900KS
};
```

---

## 8. K08 — Plattform-Modell (REV 5 verfeinert nach 33-Paper-Code)

### 8.1 Cache-Hierarchie + CPU-Modell + Bus + ISA + Live-Modell (REV 3 unveraendert)

```
«concept» ICacheLevel<L>     - L1/L2/L3/HBM/V-Cache, size, latency, bandwidth + tier_kind enum
«concept» ICacheLine<CL>     - Granularitaet (typ. 64 B, 256 B ARM A64FX)
«concept» ICacheTopology<CT> - gesamte Hierarchie + asymmetric_l3 + per_ccd Map
«concept» ICacheResidency<CR> - Cache whereabouts (Cached/HeaderCached/Uncached)
«concept» ICpuCore<C>        - core_class als generic enum
«concept» ICoreLayout<CL>    - Topologie ohne CPU-Namen
«concept» ICoreToThreadMap<CTM> - Thread-zu-Core, IPinningPolicy generisch
«concept» IPinningPolicy<P>  - LARGEST_L3_CCD / HIGH_IPC_CORES / NUMA_LOCAL / ROUND_ROBIN
«concept» IHardwareExtension<HX> + IIsaFeatureSet<IFS>  - ISA-Features
«concept» IInterconnect<IC> + IBusTopology<BT> + IMemoryBandwidthModel<MBM>
«concept» ILivePlatformModel<LPM> + ILiveCpuModel<LCM>
```

### 8.2 NEU REV 5 (aus 33-Paper-Code-Adapter — 13_md §7.1):

| Verfeinerung | Quelle | Konzept |
|--------------|--------|---------|
| **NUMA-Awareness** durchgaengig (statt nur P03/P28) | Cluster A/B/E | `IPinningPolicy` muss min. Cross-Socket-cost + NUMA-node-binding + first-touch-policy abdecken |
| **TLB explizit modelliert** statt nur P13/P28/P32 | ART/HOT/CoCo/SuRF ergaenzen | `ITlbModel` als eigenes Concept (dTLB / sTLB) |
| **Hardware-Counter-Feedback** als STATISCHE Strategy | Cluster A/B/C | `ILivePlatformModel` getriebenes adaptives Resizing |
| **SIMD in B+/Hybrid-Familie** statt nur P03 PALM | Cluster B Luecke | `ISimdAcceleratedLookupStrategy` (F7 in 11_md) auf B+/Hybrid anwenden |
| **6-Flavor-RCU-Klassifikation** statt nur P29-4-Flavors | URCU-Literatur Desnoyers 2012 | `IConcurrencyProtocol` mit RCU-Subhierarchie (qsbr/mb/membarrier/signal) |
| **Cache-Coherence-Energiekosten** quantitativ | P24 aggregiert | `IEnergyModel` mit per-protocol-Cost (MESI vs MOESI) |
| **Range-Scan bei ROWEX** Konflikt | P08 notiert | `IRangeAtomicityProtocol` als Sub-Concept |
| **Concurrent Reconstruction** unter Concurrency | P06 erkennt | `ICompositionMode` (OneNodePerPage / MultipleNodesPerPage) |
| **Multi-Tenancy/Cache-Pollution** (alle Paper nehmen "dedicated" an) | NEU | `ITenancyModel` als orthogonales Concept |
| **NVRAM/Persistent Memory** durchgaengig (statt nur P25/P31) | NEU | `IStorageMedium`-Hierarchie (siehe §7.2 Concept #6) |
| **Compiler-Automation der ISA-Extensions** | P30/P31 OFFEN | `IIsaCompileGate` als build-time-Concept |

### 8.3 Block AO Production-Plattform (5 OFFEN-Punkte aus 13_md §10.5)

| OFFEN | Beschreibung |
|-------|--------------|
| 42 | Cache-Coherence-Pressure-Quantifizierung 3D V-Cache Ryzen 9 9950X3D — keines der 33 Paper modelliert 3D-stacked Cache |
| 43 | P/E-Core-Heterogenitaet i9-14900KS — keines der 33 Paper modelliert Hybrid-Architecture, IntelThreadDirector-Integration ist Eigenleistung |
| 44 | Bandwidth-Aware Layout fuer DDR5-5600 Multi-Channel + Refresh-Cycle-Effekte (P31 DDR2 / P32 DDR4/5 nur implizit) |
| 45 | Live-Probing der Plattform-Konstanten via CPUID + `__cpu_indicator_init` — kein Paper liefert Code-Template |
| 46 | Cross-CCX-Coherence-Latenz Ryzen 9 9950X3D — nicht in 33 Papern modelliert |

---

## 9. K09 — IHeuristic-Familie (REV 5 vereint 13_md §9 + 12_md §4, ~80-85 distinkte)

```
«concept» IHeuristic<H>
   - input: ILivePlatformModel + Strategy-State
   - output: Recommendations -> DecisionLambdaTrees
   + score(Context) : double
   + recommend(input : HeuristicInput const&) : Recommendation
   + estimated_value(input) const : double
   + confidence() const noexcept : double  (0.0-1.0)  ★ NEU REV 4/5 ★
   + heuristic_kind() const noexcept : HeuristicKind
```

### 9.1 Heuristik-Kategorien (REV 5 konsolidiert auf 8 Cluster)

| Cluster | Anzahl | Beispiele |
|---------|--------|-----------|
| Layout-Selection (9.1 in 13_md) | 19 | AdaptiveLayout (P01), DataAwareCollapsing (P04), CacheCostBasedNodePlacement (P05), ProbabilityWeightedRootBlock (P16), AlphaTuning (P19), HeadQuality (P20) |
| Cost-Modell (9.2) | 12 | CacheCostDP (P05), OptimalNodeSize (P13), TLBAwareSizing (P13), OptimalNodeWidth (P21), OptimalWidthMultiTier (P22 Fractal), ConflictMissPrediction (P18) |
| Adaptive Prefetch-Distance (9.3) | 8 | AdaptivePrefetchDistance (P23), AffineDistance (P23), CostBenefitGated (P23), TemplateSpecializer (P23), StrideVsSequential (P32) |
| Workload-Detection (9.4) | 6 | SequentialInsertOptim (P03), WorkloadDetection (P20), ScanFrequencyCounter (P20), SkewedDistributionDetection (P26), SlidingWindowDriftDetection (P28-Future) |
| Cache-Coherence (9.5) | 6 | CacheCoherenceCost (P28 Block AN), OverpredictionGate (P24), NegativPredictionDetection (P24), PrefetchReliability (P25), FBSizeAwareLimiting (P25) |
| Telemetry-getrieben (9.6) | 9 | PathReadCounter (P26), MonitorClustering (P26), JaccardSimilarityTelemetry (P27), HotPathExtraction (P28), PerNodeHistogram (P28), LeafOnlyCounter (P28-Mail), LeafOnlySampledCounter (P28-Mail), RetroactiveAggregation (P28-Mail) |
| Layout-Auswahl/Kompatibilitaet (9.7) | 10 | LinearVsBinarySearchPreferred (P14), InterpolationSearchPreferred (P15), PoorMansKeyAccelerated (P15), StrategyCompatibilityMatrix (P15), PointQueryOptimized (P14, P19) |
| Hardware-Probing (9.8) | 4 | PlatformProbe (P05/P13/P32), OnlinePerformanceCounterReader (P23/P25), DynamicSpecializer (P23), BundleThreshold (P27) |

**Bilanz:** ~80-85 distinkte IHeuristic-Konkretisierungen ueber alle 33 Paper.

---

## 10. K10 — 29 Cache-Strategie-Familien F1-F29 (REV 5 mit ALLEN Hybrid-Aufloesungen)

### 10.1 Familien (siehe vollstaendige Tabelle in `_rev5_extractions/extract_taxonomien.md` Sektion A)

| Cluster | Familien |
|---------|----------|
| LAYOUT (F1-F8) | F1 AdaptiveFootprint, F2 SuccinctEncoding, F3 CacheLineAligned, F4 MultiCacheLineNode, F5 SoftwarePrefetch, F6 PointerChasingResolution, F7 SimdAcceleratedLookup, F8 PathCollapse |
| PREFETCH (F9-F14) | F9 LayerDependentEncoding, F10 PointerTagDispatch, F11 EmbeddedSecondaryIndex, F12 IndirectionVector, F13 CacheObliviousLayout, F14 CacheSensitiveMultiLevelLayout |
| VERGLEICH (F15) | F15 ProbabilityWeightedLayout (Forschungs-Vergleichsstrategie) |
| NODE (F16-F19) | F16 Compression, F17 PoorMansNormalizedKey, F18 NoSharedWrite, F19 HotColdLayerEncoding |
| CONCURRENCY (F20-F25) | F20 BlockOrientedRankSelect, F21 VirtualMemoryRewiring, F22 CodeSpecialization, F23 AdaptiveRuntimePrefetchDistance, F24 TelemetryDriven, F25 SyncMechaniken |
| TELEMETRIE (F26-F29) | F26 StrideAccessPattern, F27 NfpDecorator, F28 HardwareOffload, F29 Filter |

### 10.2 NEU REV 5: 8 fehlende Hybrid-Aufloesungen (User-Kritik 2026-05-11 zu K10!)

User: "K10 hat unter den Layout Familien schon wieder nicht nach Command Pattern aufgelöste hybride Layouts, deren Bestandteile korrekt zerteilt werden müssen"

| § neu | Familie | Quelle | Atomare Strategy-Commands | HybridCompositionCommand |
|-------|---------|--------|---------------------------|--------------------------|
| §10.21 | F8 PathCollapse | P02 HOT k-constrained, P04 CoCo Macro+DP, P05 START Multilevel | `KConstrainedPartitioningCommand` + `MacroNodeCollapseCommand` + `DataAwareCollapseDPCommand` + `MultilevelCollapseCommand` | `PathCollapseFamilyCompositionCommand` |
| §10.22 | F11 EmbeddedSecondaryIndex (P11) | P11 CSS Embedded Directory | `EmbeddedDirectoryCommand` + `PartialPointerCommand` | `CSSEmbeddedDirectoryCompositionCommand` |
| §10.23 | F11 EmbeddedSecondaryIndex (P22) | P22 Chen Fractal in-page B+ | `InPageBPlusCommand` + `MicroIndexingCommand` | `FractalInPageBPlusCompositionCommand` |
| §10.24 | F11 EmbeddedSecondaryIndex (P26) | P26 Zhang PathPrefetcher + SearchBlockTable | `PathPrefetcherCommand` + `SearchBlockTableCommand` | `ZhangSearchBlockTableCompositionCommand` |
| §10.25 | F13 CacheObliviousLayout (P17) | P17 vEB + DynamicVEB + PackedMemoryArray + BufferNodes + Indirected | `VEBClassicCommand` + `DynamicVEBPmaCommand` + `BufferNodesVEBCommand` + `IndirectedVEBCommand` | `VEBLayoutVariantCompositionCommand` |
| §10.26 | F14 CacheSensitiveMultiLevel (P18) | P18 MultiLevelCacheSensitive + AliasingCorrection | `MultiLevelCacheSensitiveCommand` + `AliasingCorrectionCommand` | `SaikkonenMultiLevelCompositionCommand` |
| §10.27 | F22 CodeSpecialization (P12) | P12 CSB+ basic + uniform + variable | `BasicCSBCommand` + `UniformCSBCommand` + `VariableCSBCommand` | `CSBCodeVariantsCompositionCommand` |
| §10.28 | F22 CodeSpecialization (P23) | P23 Khan TemplateSpecializer 2-5 Modify-Locations | `TemplateSpecializerCommand` + `ModifyLocationCommand[1-5]` | `KhanTemplateSpecializerCompositionCommand` |
| §10.29 | F25 SyncMechaniken (P07) | P07 Wormhole RCU+RW-Lock+MutEx | (siehe §6.5/§9.21) | `WormholeTripleConcurrencyCompositionCommand` |
| §10.30 | F25 SyncMechaniken (P08) | P08 ART OLC + ROWEX | `OLCCommand` + `ROWEXCommand` | `ARTSyncVariantCompositionCommand` |
| §10.31 | F27 NfpDecorator (P33) | P33 VAMPIR NFP-Decorator + V-malloc + Compensation + Migration | `NfpDecoratorCommand` + `VMallocCommand` + `CompensationCommand` + `MigrationCommand` | `VampirNfpCompositionCommand` |
| §10.32 | F28 HardwareOffload (P31) | P31 iDMA Configurator/AGU/DataFetcher/Crawler | `IdmaConfiguratorCommand` + `IdmaAguCommand` + `IdmaDataFetcherCommand` + `IdmaCrawlerCommand` | `UngethuemIdmaCompositionCommand` |

**Wirkung:** Permutations-Raum erweitert sich um 12 weitere Atom-Sets x Composition-Variants. F15 hat damit deutlich mehr atomare Bausteine zur Cross-Familien-Permutation.

---

## 11. K11 — Drei-Ebenen-Verbindungen + Phase 1-7 Pipeline (REV 5 Korrektur)

User-Korrektur 2026-05-11: Pfeil von Phase 5 zeigte direkt auf Phase 7 statt Phase 6 (Darstellungsfehler).

### 11.1 7-Phasen-Pipeline (sequentiell, korrigiert)

```
Phase 1 - DISCOVER
   IPlatformProbe entdeckt: ICacheTopology / ICoreLayout / IIsaFeatureSet / IBusTopology
v
Phase 2 - MEASURE
   Mikrobenchmarks: clflush-cycle / All-Pairs-Pinning / Cache-Coherence-Cost / DDR5-Latency
v
Phase 3 - CLASSIFY
   IPlatformPropertyClassifier => PlatformPropertySet (12+ Properties REV 5)
v
Phase 4 - PUBLISH
   ICacheEngineOptionPublisher liefert nur konsumierbare Optionen pro Permutation
v
Phase 5 - BIND
   ICacheStrategy-Visitor wird pro Permutation: BaseEngineStrategy / CacheEngineStrategy
v
Phase 6 - EXECUTE  (REV 5.2 erweitert mit Visitor-Interface)
   IExecutingEngine.execute() ->
     ISearchEngine.search() ->
       IFanout.distribute() ->
         ISearchPagesStrategy ->
           ISearchPageStrategy(N) ->
             ICacheStrategy(N).visit(op)             // Visitor-Pattern
                |
                | Pro Op-Visit ruft die Strategy:
                v
             ICacheEngine.advise(RequestContext)     // Visitor-Aufruf an CacheEngine
                |
                +- ICacheEngine ist Visitor-Wurzel + Mediator + State-Holder
                +- snapshot() : PlatformSnapshot (C05+C10)
                +- classify_pressure() : PressureState (State-Pattern)
                +- run_pipeline() ueber 12 Sub-Engines (C05->C10->C09->C01->C08->C06->C02->C07->C03->C04->C12->C11)
                +- merge() konsolidiert partielle Empfehlungen
                v
             CacheRecommendation                      // Rueckgabe an ISearchPageStrategy
                {verdict, alloc_hint, layout_proposal,
                 prefetch_advice, migration_directive,
                 pinning_directive, pressure_summary, confidence}
                |
                v
           ISearchPageStrategy konsumiert Recommendation:
             - Allocate? -> verwendet alloc_hint fuer neue Page
             - Reshape?  -> wechselt ISearchPageStructure
             - Migrate?  -> verschiebt Daten zu anderer Ebene
             - Hint?     -> aktualisiert Prefetch-Distance
             - Abort?    -> bricht Operation ab + reportet Telemetry
v
Phase 7 - COMPARE (F15 - die Forschungsmission)
   Permutations-Builds + Experiment-Loop:
     V1 BaseEngine, V2 CacheEngine+Static, V3 CacheEngine+Warmup, V4 CacheEngine+Adaptive
   Vergleich pro 4-Ebenen-Tupel: Throughput / Latency / Cache-Miss / Bandwidth /
   Cache-Coherence-Bus-Verkehr / Energieverbrauch
```

---

## 12. K12 — Forschungsmission F15 + Cache+Search-Permutationen Cross (REV 5 erweitert)

User-Kritik 2026-05-11: K12 wendet das Prinzip der Baustein-Familien nur auf Execution Engine -> Search Engine an. Bausteine der Cache Engine muessen GEGEN Permutationen der Search Engine permutiert werden, um die insgesamt beste Loesung zu finden.

### 12.1 Forschungsmission (REV 3 unveraendert)

> Saeule B Cache-Engine erzeugt durch Plattform-Modell-Auswertung Permutations-Familien,
> die Saeule A vorher fest entscheidet — und beweist, dass diese dynamische Komposition
> messbar bessere Lookup-Zeiten als statisch vordefinierte Algorithmen liefert auf konkreter
> Plattform (z.B. Block AO Ryzen 9 9950X3D + i9-14900KS).

### 12.2 NEU REV 5: Vollstaendige Cross-Permutation Saeule A x Saeule B

```
F15-Cross-Permutation:

  SUCH-DIMENSION (Saeule A):                       CACHE-DIMENSION (Saeule B):
  - 21 Patterns (S1-S21)                           - 29 Cache-Familien (F1-F29)
  - 41 Plural-Strategien (S22-S26)                 - ~80-85 IHeuristic-Konkretisierungen
  - 74 Singular-Strategien (S27-S30)               - 28+ Plattform-Concepts
  - 12+ neue Hybrid-Auflosungen (§9.18-§9.22)      - 12+ neue Hybrid-Aufloesungen (§10.21-§10.32)

  + ENGINE-CHOICE-DIMENSION (K3 Erweiterung REV 5):
  - 4 Varianten pro Tupel: Base / CacheEngine+Static / CacheEngine+Warmup / CacheEngine+Adaptive

  = SUCH-Permutationen x CACHE-Permutationen x ENGINE-Choice
  = (21 x 41 x 74) x (29 x 80) x 4
  = 63.714 x 2.320 x 4 ~= 590 Mio. theoretische Tupel
  - ConstraintFilter (compile-time-Concepts) reduziert auf ~10.000-50.000 valide Permutationen pro Plattform

CROSS-PFLICHT:
   Jede Such-Engine-Konfiguration (Saeule-A-Tupel) wird gegen alle Cache-Engine-Modi
   (Saeule-B-Tupel) gemessen, um die beste Cross-Kombination zu finden.

   Z.B.: Such-Tupel {LayerMixPattern, Trie-Familie, AdaptiveRadixTreeStrategy,
   AdaptivePrefetchDistanceHeuristic} x Cache-Tupel {F1.AdaptiveFootprint,
   F5.SoftwarePrefetch, F24.TelemetryDriven} = ein konkretes 7-Tupel.
```

### 12.3 Pflicht-Reporting (REV 5 aus Termin 6)

Aus Termin 6 (T6-AA): "fuenf Rohlaeufe, keine Mittelung von Perzentilen, getrennte Ausweisung nach Plattform, Core-Typ, ISA und Cache-Engine-Modus."

Pflicht-Reporting-Dimension D1 x D3 x D2 x D4 (siehe `_rev5_extractions/extract_termin5_6.md` Tabelle D):
- D1 Plattform: 9 Pflicht (VisionFive 2 / RPi 5 / Mac mini M1 / ODROID-H4 / i7-1270P / i9-14900KS / Ryzen 9 9950X3D / Barnard / Grace Hopper GH200)
- D2 ISA: 5 (scalar / x86_avx2 / x86_avx512 / arm_neon / arm_sve2)
- D3 Core-Typ: 2 (cpu_core P / cpu_atom E)
- D4 Cache-Engine-Modus: 3 (passiv / Warm-up / online-adaptiv)
- D14 Suchalgorithmus-Baseline: ART / HOT / Masstree / B^2-tree / CoCo-trie / START / Wormhole + PRT-ART

---

## 13. Future-Proof-Prinzipien (REV 5 aus REV 4 uebernommen)

### 13.1 Open/Closed-Prinzip

- Concept-Klassen (`ICacheStrategy`, `IPage`, `IHeuristic`, `ISearchPageStructure`, `ISearchPageStructureInterpreter`) sind **closed for modification** - Methoden-Signaturen sind Contracts und aendern sich NICHT
- Konkretisierungen sind **open for extension** - neue Klasse implementiert das Concept ohne Aenderung am Concept-Interface
- **Mechanismus:** C++23 Templates + `requires`-Klausel + `concept`-Definitionen

### 13.2 Modular Architecture

- Jede Achse einer Matrix (Layer-Matrix-Hybrid) ist unabhaengig austauschbar mit eigenem Sub-Verzeichnis
- Konkretisierungen koennen ohne Aenderung an anderen Achsen ergaenzt werden
- Verzeichnis-Granularitaet: pro Cache-Familie pro ISA-Feature pro Plattform-Property pro Concurrency-Mechanik pro Telemetry-Strategie

### 13.3 Encapsulation through stable contracts

- Concept-Header (`i_*.hpp`) sind die einzigen oeffentlichen API-Punkte
- Implementierungs-Header (`*.hpp` ohne `i_`-Praefix) sind privat zur Konkretisierungs-Achse
- Aenderungen innerhalb einer Achse beeinflussen keine anderen Achsen

### 13.4 Single Responsibility auf Architektur-Ebene

- `IPage` = logische Seiten-Abstraktion
- `ISearchPageStructure` = Codierung
- `ISearchPageStructureInterpreter` = Decodier-Logik
- `ICacheStrategy` = Read/Write/Layout-Routing-Visitor
- `IHeuristic` = Wert-/Kostenberechnung
- `IPlatformProbe` = Auto-Discovery der Plattform
- Mehrfach-Verantwortlichkeiten werden in mehrere Concepts aufgeteilt

### 13.5 Separation of Concerns

- Saeulen A (Strategien) und B (Plattform-Modell) sind disjunkt
- Engine konsumiert nur abstrakte Schnittstellen - kennt keine konkreten Implementierungen
- DecisionLambdaTrees vermitteln Events zwischen den Saeulen ohne direkte Abhaengigkeit

### 13.6 API-First Design

- Jede Erweiterung beginnt mit einer Concept-Erweiterung (oder neuem Concept-Header)
- Erst wenn die API stabil ist, folgen Konkretisierungen
- Aenderungen an Concepts erfordern formelle Architektur-Korrekturrunde (REV1-2-3-4-5 Vorgehen)

### 13.7 Dependency Structure Matrix (DSM) als Visualisierungs-Tool

- DSM-Matrix mit allen Concepts als Zeilen + Spalten
- Zellen markieren vorhandene Abhaengigkeiten (`uses`, `composes`, `inherits`)
- Ziel: **Block-Triangulare Struktur** (saubere Layer-Trennung)
- Tooling: Lattix / Structure101 / eigenes Skript

---

## 14. Layer-Matrix-Hybrid (REV 5 aus REV 4 MX1 uebernommen)

### 14.1 Antwort: HYBRID

**LAYER-DIMENSION (vertikal, klassisch):**
- Drei Ebenen: Engine | Strategien | CacheEngine
- Ein Concept gehoert genau einem Layer
- Klare Abhaengigkeits-Richtung (oben -> unten)
- Vorteil: Encapsulation, stabile Contracts, einfaches Reasoning, Open/Closed pro Layer

**MATRIX-DIMENSION (horizontal, fuer F15-Bausteine-Quer-Permutation):**
Pro Layer existiert eine Matrix der Konkretisierungen entlang mehrerer orthogonaler Achsen.

**Konkrete Achsen (REV 5 erweitert):**
- Cache-Familie F1-F29 (siehe `11_cache_strategy_taxonomie.md`)
- Such-Familie S1-S30 (NEU REV 5 K06)
- Strategie-Ebene A-D (Pattern / Plural / Singular / Heuristic)
- Plattform-Property (12+ aus PlatformPropertySet)
- ISA-Feature (AVX-512, BMI2, NEON, SVE2, RISC-V V-Ext)
- Concurrency-Mechanik (OLC, ROWEX, RCU 6-Flavors, Hazard, EBR, QSBR)
- Telemetry-Strategie (PerNode, LeafOnly, Sampled, Retroactive)
- Cache-Engine-Modus (Static / Warmup / Adaptive — NEU REV 5 K3-Erweiterung)

**DSM** als Visualisierungs-Tool fuer Cross-Achsen-Beziehungen.

### 14.2 Verzeichnis-Konsequenz pro Concept

```
search_engine/
├── concepts/
│   ├── i_cache_strategy.hpp                          (Concept-Header — Contract)
│   ├── i_search_page_structure.hpp                   ★ NEU REV 5
│   └── i_search_page_structure_interpreter.hpp       ★ NEU REV 5
├── cache_strategies/                                  (Matrix-Layer fuer Konkretisierungen)
│   ├── visitor_variants/                              (Achse 1: Visitor-Variante)
│   │   ├── base_engine_strategy.hpp                   (1A — Baseline F15)
│   │   └── cache_engine_strategy.hpp                  (1B — CacheEngine-aktiv)
│   └── families/                                      (Achse 2: Cache-Familie F1-F29)
│       ├── f01_adaptive_footprint/
│       │   ├── art_node_footprint_strategy.hpp        (P01)
│       │   ├── hot_layout_footprint_strategy.hpp      (P02)
│       │   └── ...
│       ├── f02_succinct_encoding/                     (F2)
│       │   ├── louds_jacobson_encoding_strategy.hpp   (P09)
│       │   ├── louds_dense_encoding_strategy.hpp      (P10)
│       │   ├── louds_sparse_encoding_strategy.hpp     (P10)
│       │   └── ...
│       └── ... (F3-F29 analog)
└── search_page_structures/                            ★ NEU REV 5
    ├── redirect_structure.hpp / redirect_interpreter.hpp
    ├── dense_byte_structure.hpp / dense_byte_interpreter.hpp
    ├── multilevel_dense_structure.hpp / multilevel_interpreter.hpp
    ├── sparse_patricia_structure.hpp / patricia_interpreter.hpp
    ├── decision_span_structure.hpp / b2_interpreter.hpp
    └── custom_aligned_structure.hpp / custom_interpreter.hpp
```

---

## 15. Tab-Inventar phase5_uml_detail_REV5.drawio (22 Tabs)

| # | Tab | Typ | Inhalt | Quelle in dieser md |
|---|-----|-----|--------|---------------------|
| K01 | Drei-Ebenen-Architektur | Konzept | IExecutingEngine + Saeule A + Saeule B | §1 |
| K02 | Saeule A Concept-Hierarchie + Interpreter | Konzept | IPage/IFanout/INode/ISearchPage/ISearchPageStructure/Interpreter | §2 |
| K03 | ICacheStrategy Visitor + CacheEngineBuilder-Permutationsdimension | Konzept | Base/CacheEngine + 4 Build-Varianten | §3 |
| K04 | 4-Ebenen-Strategien | Konzept | Pattern/Plural/Singular/Heuristic | §4 |
| K05 | PRT_ART Bausteinkombination | Konzept | 7-Quellen-Hybrid + 6 Seitentypen + 3 Iteratoren | §5 |
| K06 | ISearchEngine-Familien-Taxonomie S1-S30 | Konzept | analog 11_md aber fuer Saeule A | §6 |
| K07 | IPlatformProbe Auto-Discovery + 28 Concepts | Konzept | 5-Schritte + erweiterte Concept-Liste | §7 |
| K08 | Plattform-Modell verfeinert (33-Paper-Code-Adapter) | Konzept | Cache + CPU + Bus + ISA + 11 NEUE Verfeinerungen | §8 |
| K09 | IHeuristic-Familie ~80-85 Heuristiken | Konzept | 8 Cluster aus 13_md §9 + 12_md §4 | §9 |
| K10 | 29 Cache-Strategie-Familien F1-F29 + 12 NEU Hybrid-Aufloesungen | Konzept | F1-F29 + 8 fehlende Hybride aufgeloest | §10 |
| K11 | Phase 1-7 Pipeline (Pfeilkorrektur) | Konzept | Discover-Measure-Classify-Publish-Bind-Execute-Compare | §11 |
| K12 | Forschungs-Mission F15 + Cache+Search Cross | Konzept | Cross-Permutation Saeule A x Saeule B | §12 |
| K13 | Future-Proof-Prinzipien | Konzept | 7 Prinzipien (REV 4 uebernommen) | §13 |
| K14 | Layer-Matrix-Hybrid + DSM | Konzept | Layer-Matrix + DSM-Tooling | §14 |
| U01 | UML IExecutingEngine + ISearchEngine + IFutureEngine | UML | Klassen mit Variablen + Methoden | §1+§5 |
| U02 | UML Saeule A Page-Familie (mit Structure + Interpreter) | UML | IPage/IRootPage/IFanout/INode + ISearchPageStructure/Interpreter | §2 |
| U03 | UML Saeule A Strategy-Familie + Iteratoren + Visitor | UML | ISearchPagesStrategy/Pattern/Strategy + ICacheStrategy + Iteratoren | §2.4+§5.5 |
| U04 | UML Hybrid-Command Klassen | UML | IStrategyCommand + HybridCompositionCommand + ICompositionRule + 17 Atom-Beispiele | §6.5+§10.2 |
| U05 | UML Saeule B Plattform-Probe | UML | IPlatformProbe + IPlatformPropertyClassifier + ICacheEngineOptionPublisher | §7 |
| U06 | UML Saeule B Cache + Heuristic | UML | ICacheLevel/Topology/Residency + IHeuristic + 28 NEUE Concepts | §7.2+§8+§9 |
| U07 | UML ISearchEngine-Familien-Taxonomie | UML | S1-S30 als Klassen + 17 Composition-Commands sichtbar | §6 |
| U08 | UML PRT_ART vollstaendig | UML | comdare::prt_art + alle Iteratoren + Operationen | §5.5 |

(Optional NEU REV 5: MX1 = Layer-Matrix-Hybrid, MX2 = DSM-Beispiel.)

---

## 16. Naechste Schritte

1. **JETZT:** drawio `phase5_uml_detail_REV5.drawio` mit den 22 Tabs erzeugen + Kontrast-Konvention K01-Stil (weisser Hintergrund, helle Pastell-Boxen, schwarzer Text)
2. **User-Review:** REV 5 zur Entscheidung vorlegen
3. **NACH FREIGABE:** Phase 6+ Implementation gemaess `concepts/` + `<concept_plural>/<axis>/<family>/` Verzeichnis-Konvention
4. **Phase 7:** Permutations-Builds + Experiment-Loop (F15 vollstaendige Cross-Matrix)
5. **Phase 8:** LaTeX-Anhang aus MeasurementBuffer-Disk-Dump

---

## 17. REV 5.1 Korrekturen (2026-05-11 - User-Review zweite Runde)

### 17.1 Eingearbeitete Korrekturen

| Tab | Korrektur | Quelle |
|-----|-----------|--------|
| K02 | KOMPLETT NEU: 3-Schichten-Architektur (Konzept/Strategie/Physisch). INode = Mikro-Verweis (Slot-Eintrag), KEIN Container. IFanout HAT ISearchPages. ISearchPage HAT INodes. ICachePage traegt INodes (ganz oder fragmentiert). Cache-Lines explizit. Facade-Pattern fuer ISearchPageStructureInterpreter (Singleton). | extract_masstree_inode.md + extract_cache_lines_facade.md |
| K14 | ERWEITERT: Disjunkte Permutationen Cache-Engine (C1-C12) vs. Search-Engine (S1-S30). Eine andere ExecutionEngine wuerde dieselben C-Permutationen durchgehen. Cache-Engine ist wiederverwendbarer Optimierungs-Service. | User-Direktive |
| K15 | NEU: ICacheEngine-Familien-Taxonomie C1-C12 als Pendant zu K06 ISearchEngine-Familien S1-S30. ~264 atomare Bausteine + ~30 Hybrid-Composition-Commands. | extract_cache_engine_families.md |
| U02 | KOMPLETT NEU: IRootPage -> IRootNode (KONZEPTIONELLE Wurzel auf SearchPage). 3-Schichten-Audit aller Klassen. INode als Tagged Union mit 5 NodeRefKind. ICacheLine plattform-spezifisch (NIE 64 B hardcoded). | extract_masstree_inode.md + extract_cache_lines_facade.md |
| U09 | NEU: ICacheEngine als 12 orthogonale Sub-Engines (ICacheLayoutEngine, ICachePinningEngine, ICachePrefetchEngine, ICacheCoherenceEngine, ICacheTelemetryEngine, ICacheAllocationEngine, ICacheMigrationEngine, ICacheEncodingEngine, ICacheHeuristicEngine, ICacheTopologyEngine, ICacheSchedulerEngine, ICacheFilterEngine). | extract_cache_engine_families.md |

### 17.2 Korrektes 3-Schichten-Modell (REV 5.1 Architekt-Konsens)

```
SCHICHT 1 - KONZEPT (was sind die Bausteine?)
   IRootNode / IFanout / INode (Mikro-Verweis = Slot-Eintrag, Tagged Union)
   - INodes residieren AUF ISearchPages (placement, KEIN Speicher-Ownership)
   - IFanout HAT ISearchPages (NICHT INodes direkt)
   - INodes sind logisch ueber permutation_index adressiert (kein vtable-Pointer pro INode)

SCHICHT 2 - STRATEGIE (wie kombinieren wir Konzept und Cache optimal? = CacheEngine als KLEBER)
   ISearchPage (logischer Knoten = "Page" im Masstree-Sinn)
      contains [W=15] INode  (W = Fanout-Width)
      has 1 ISearchPageStructure (Strategy + Facade)
      mapped onto [1..K] ICachePage
   ISearchPageStructure
      Singleton-Interpreter (Facade-Pattern - Praezedenz LLVM TargetInfo)
      6 Konkretisierungen mit eigenem Singleton-Interpreter
   ISearchPagesStrategy + Pattern + ISearchPageStrategy + ICacheStrategy (Visitor)
   12 ICacheEngine-Internal-Familien (C1-C12, K15)

SCHICHT 3 - PHYSISCH (wo liegt es im Speicher?)
   ICachePage (4 KiB Standard, 2 MiB Huge)
      carries [0..M] INode (ganz ODER fragmentiert!)
      carries [0..K] ISearchPage (typisch K=1 wenn aligned)
   ICacheLine (Hardware-Atomic-Transfer)
      size : PLATTFORM-SPEZIFISCH (NIE hardcoded 64 B!)
      C++17: std::hardware_destructive_interference_size
      x86-64: 64 B / Apple Silicon: 128 B / A64FX: 256 B / POWER: 128 B
```

### 17.3 INode-Korrektur (Masstree-Korrekt)

```cpp
// FALSCH (REV 5):
class INode {                                 // war: "Verzweigungs-/Daten-Einheit"
    placement_page_ : ISearchPage&;
    // composes [N] INode in IFanout direkt - FALSCH!
};

// KORREKT (REV 5.1) - Tagged Union:
enum class NodeRefKind {
    ValueRef,    // lv_.value in Masstree (terminal)
    ChildRef,    // child_[i+1] in internode
    LayerRef,    // lv_.layer in Border-Slot, keylenx==layer_keylenx==128
    SiblingRef,  // next_/prev_ B-link
    SuffixRef    // ksuf_ + offset, keylenx==ksuf_keylenx==64
};

class INode {                                 // jetzt: "Mikro-Verweis (Slot-Eintrag)"
    placement_page : ISearchPage&;            // Nur Reference!
    slot_index    : uint8_t;                  // Adressiert via permutation_
    ikey          : ikey_type;                // 8-Byte slice (Masstree)
    ref_kind      : NodeRefKind;              // Discriminator (= keylenx_ in Masstree)
    payload       : Variant<ValueHandle, ChildPtr, LayerPtr, SiblingPtr, SuffixPtr>;
    // KEINE eigenstaendige Speicher-Adresse!
};

// IFanout NEU:
class IFanout {
    pages_                  : vector<ISearchPage&>;       // KORRIGIERT: HAT Pages
    pages_strategy_         : ISearchPagesStrategy&;
    pages_strategy_pattern_ : ISearchPagesStrategyPattern&;
    // KEIN composes [N] INode direkt mehr!
};

// ISearchPage NEU:
class ISearchPage {
    nodes_       : array<INode, W>;           // W = Fanout-Width (15 in Masstree)
    structure_   : ISearchPageStructure&;     // Facade-Singleton
    mapped_pages : vector<ICachePage&>;       // [1..K] physische Pages
};
```

### 17.4 Facade-Pattern fuer ISearchPageStructureInterpreter

```cpp
// Singleton-Interpreter pro Layout-Variante (Praezedenz: LLVM TargetInfo):
class RedirectInterpreter : public ISearchPageStructureInterpreter {
    static const RedirectInterpreter& instance();
    INode* find(structure, key) const override;
    Iterator make_iterator(structure, mode) const override;
};

class ISearchPageStructure {
    encoding_   : Encoding;
    interpreter : ISearchPageStructureInterpreter const&;  // Singleton-Verweis
    
    // Facade-Delegation:
    INode* find(key) { return interpreter.find(*this, key); }
    Iterator scan(range) { return interpreter.make_iterator(*this, range); }
};

// Vorteil: Spart 8 B vtable-Pointer pro INode (kritisch bei 16-B-INodes!)
```

### 17.5 12 ICacheEngine-Familien (C1-C12)

| ID | Name | Atoms | F-Mapping | Hauptzweck |
|----|------|-------|-----------|------------|
| C1 | Cache-Layout-Engine | ~26 | F1/F3/F4/F8/F11-F17/F19/F22 | Knoten-Format + Footprint |
| C2 | Cache-Pinning-Engine | ~10 | F18/F25 | NUMA/Core/Ebenen-Bindung |
| C3 | Cache-Prefetch-Engine | ~25 | F4/F5/F6/F23/F26 | Latenz-Hiding |
| C4 | Cache-Coherence-Engine | ~12 | F18/F25/F26 | Reader/Writer-Sync |
| C5 | Cache-Telemetry-Engine | ~22 | F23/F24 | Mess- + Probe |
| C6 | Cache-Allocation-Engine | ~17 | F1/F12/F21/F27 | Allocator + Ebene |
| C7 | Cache-Migration-Engine | ~12 | F9/F19/F27 | Ebenen-Migration |
| C8 | Cache-Encoding-Engine | ~28 | F2/F10/F16/F17/F19/F20 | Topologie + Bit-Packing |
| C9 | Cache-Heuristik-Engine | ~73 | orthogonal | Decision + Cost-Modell |
| C10 | Cache-Topologie-Engine | ~17 | Saeule-B-Adapter | Plattform-Probe + Discovery |
| C11 | Cache-Scheduler-Engine | ~13 | F24/F25 | Background-Worker + Trigger |
| C12 | Cache-Filter-Engine | ~9 | F29 | Approximate-Membership |

**Gesamt:** ~264 atomare Bausteine + ~30 Hybrid-Composition-Commands ueber 12 Familien.
**Disjunktivitaet:** C1-C12 (ICacheEngine) ist DISJUNKT zu S1-S30 (ISearchEngine). Cross-Permutation = ~10^12 theoretisch, ~10^4-10^5 valide nach IStrategyCompatibilityMatrix.

### 17.6 Cache-Lines plattform-spezifisch

REV 5.1 fixiert: KEINE hardcoded 64 B-Annahme. C++17 Standard-API:

```cpp
struct alignas(std::hardware_destructive_interference_size) NodeLock {
    std::atomic<uint64_t> version;
    // Padding wird vom Compiler automatisch eingefuegt
};

// GCC-Defaults (Stand 2026):
// x86-64:           destructive=64,  constructive=64
// generic AArch64:  destructive=256, constructive=64 (A64FX-kompatibel)
// Apple Silicon:    destructive=128, constructive=64
```

### 17.7 Tab-Inventar REV 5.1 (24 Tabs)

| # | Tab | Status |
|---|-----|--------|
| K01-K12 | Konzept-Tabs | unveraendert vs REV 5 |
| K02 | 3-Schichten + INode-Korrektur | ★ KOMPLETT NEU REV 5.1 |
| K13 | Future-Proof-Prinzipien | unveraendert |
| K14 | Layer-Matrix-Hybrid + DSM | ★ ERWEITERT (disjunkte Permutationen) |
| K15 | ICacheEngine-Familien C1-C12 | ★ NEU REV 5.1 |
| U01 | UML IExecutingEngine + ISearchEngine + IFutureEngine | unveraendert |
| U02 | UML Page-Familie 3-Schichten + IRootNode | ★ KOMPLETT NEU REV 5.1 |
| U03-U08 | UML weitere | unveraendert |
| U09 | UML ICacheEngine-Familien C1-C12 | ★ NEU REV 5.1 |

---

## 18. STATUS / NAECHSTE ENTSCHEIDUNGEN / OFFENE AUFGABEN

### 18.1 Was steht JETZT zur Entscheidung an?

| # | Entscheidung | Erfordert |
|---|--------------|-----------|
| 1 | REV 5.1 als kanonische Skizze freigeben? | Architekt-Review der 24 Tabs (insbesondere K02, K15, U02, U09 - die NEUEN/KORRIGIERTEN) |
| 2 | K07 + K08 weiter verfeinern (Detail-Splitting K07a/K07b/K07c)? | Optional - K15 + U09 enthalten bereits die volle Auto-Discovery + Plattform-Modell-Detaillierung |
| 3 | Web-Recherche-Cache-Lines in eigenes Architektur-Dokument auslagern? | Optional - extract_cache_lines_facade.md ist bereits vollstaendig |

### 18.2 Was ist OFFEN (vor Phase 6 Implementation)?

| Pri | Aufgabe | Status | Verweis |
|-----|---------|--------|---------|
| P0 | Architekt-Freigabe REV 5.1 | OFFEN - User entscheidet jetzt | diese Datei + drawio |
| P0 | Email-Antworten auf 5 verschickte Anfragen (P06, P28, P31, P32, P33) | WARTEN | Task #74 |
| P1 | Cluster-Migration: Fortigate-31G + GitLab-Push | OFFEN | Task #77 |
| P1 | comdare-cache-engine GitHub-Push (Habich H4) | OFFEN | Task #103 |
| P1 | Habich H2 Code-Qualitaets-Bewertung pro Bausteine-Quelle | OFFEN | Task #101 |
| P1 | Habich H3 LaTeX-Toolchain mit dynamischer Diagramm-Compile | OFFEN | Task #102 |
| P2 | Datasets Phase 4.A Implementation (SCHRITT 1-6) | OFFEN | Task #81 |
| P2 | Bausteine_Matrix.txt Detail-Punkte P4B-1 bis P4B-6 | OFFEN | Task #83 |
| P2 | Talos OS Java-Runtime-Provisioning fuer YCSB | OFFEN | Task #111 |
| P2 | Debian-Pod als YCSB-Daten-Provider | OFFEN | Task #109 |
| P3 | Eigene RCU-Implementation (statt liburcu) | OFFEN | Task #104 |
| P3 | SDSL-Lite C++23-Portierung in eigene comdare-succinct | OFFEN | Task #105 |
| P3 | HBM-Hybrid-Cache-Hierarchie via Abstract Factory | OFFEN | Task #106 |
| P3 | Adapter-Skelette in adapters/&lt;paper&gt;/ pro Repo | OFFEN | Task #79 |

### 18.3 Wo stehen wir im Prozess?

```
PHASE 1-2: Quellen + Glossar                                    DONE
PHASE 3: Domaenenmodell + Tieflektuere 33 Paper                  DONE
PHASE 4.A: Datasets Pflicht-Korpus                               PENDING (Task #81)
PHASE 4.B: comdare-cache-engine Setup + LEGACY_REIMPL            DONE
PHASE 5 REV 1-2: Erste UML + ER-Modell                           DONE
PHASE 5 REV 3: Kanonische Architektur-Skizze                     DONE
PHASE 5 REV 4: Future-Proof + Layer-Matrix                       DONE
PHASE 5 REV 5: Termin 1-6 Integration + Korrekturen              DONE (jetzt vorgelegt)
PHASE 5 REV 5.1: 3-Schichten + INode-Korrektur + ICacheEngine-   DONE (heute, jetzt vorgelegt)
                 Familien C1-C12
                 -- ARCHITEKT-FREIGABE STEHT JETZT AUS --
PHASE 6: Implementation in prt_art/                              PENDING (Task #85)
PHASE 7: Permutations-Builds + Experiment-Loop F15                PENDING (Task #87)
PHASE 8: LaTeX-Anhang aus MeasurementBuffer                       PENDING (Task #88)
```

### 18.4 Bei FREIGABE REV 5.1 - was startet?

1. **Phase 6 Implementation** (Task #85) auf Basis der 22 + 2 = 24 Tabs:
   - concepts/ Header-Generation aus K01-K15
   - 6 ISearchPageStructure-Konkretisierungen (K05/U02)
   - 12 ICacheEngine-Sub-Engine-Konkretisierungen (K15/U09)
   - HybridCompositionCommand fuer 17 + 5 + 12 = 34 Composition-Commands
2. **comdare-cache-engine GitHub-Push** (Task #103) parallel
3. **Habich H2 Code-Qualitaets-Bewertung** (Task #101) parallel
4. **Datasets Phase 4.A** (Task #81) als Vorbereitung fuer Phase 7

### 18.5 KRITISCHE Manoever vor Phase 7

- **Cluster-Migration** muss VOR Phase 7 abgeschlossen sein (sonst keine Production-Plattform fuer F15-Vergleichsmessungen)
- **YCSB-Daten-Provider** muss VOR Phase 7 laufen (Pflicht-Workload-Mix)
- **Email-Antworten Habich/Kuehn** muessen VOR Phase 6 ausgewertet werden




