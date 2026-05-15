# Taxonomien — Cache-Strategie + Algorithmus-Strategie (Konsolidiert)

**Stand:** 2026-05-15 (K-C.10)
**Quellen:** Phase5_UML_Detail Doks 11+12 (`11_cache_strategy_taxonomie.md` 610 Z + `12_algorithmus_strategie_taxonomie.md` 916 Z)
**Zweck:** Voll-konsolidierte Taxonomien beider Saeulen — referenziert von Saeule A (`03_konzepte_saeule_a.md`) und Saeule B (`04_konzepte_saeule_b.md`).

---

## §1 Zwei orthogonale Taxonomien

| Taxonomie | LOC | Quelle | Pendant |
|---|---|---|---|
| **Cache-Strategien** (29 ICacheStrategy-Familien F1-F29) | 610 | Doc 11 | siehe `04_konzepte_saeule_b.md` (Plattform-Modell) |
| **Algorithmus-Strategien** (4-Ebenen + 17 Hybrid-Commands) | 916 | Doc 12 | siehe `03_konzepte_saeule_a.md` (Such-Algorithmen) |

**REV K3.3 Beschluss 2026-05-10:** Beide Taxonomien sind **orthogonal**. Klassische "Familien" (Trie, B+, Hybrid) sind nur **Lektuere-Gruppierungen**.

---

## §2 Cache-Strategien (Doc 11) — 29 Familien F1-F29

Detail-Auflistung in `03_konzepte_saeule_a.md` §3.

### 2.1 Hybrid-Aufloesung (REV K3.4 + REV5 K10.2)

8 Familien wurden als "nicht-zerlegt hybrid" erkannt und in Strategy-Commands aufgeloest:

| Hybrid-Familie | Original-Quelle | Aufloesung in atomare Commands |
|---|---|---|
| F2 ISuccinctEncodingStrategy | P10 SuRF | LOUDS-Dense-Command + LOUDS-Sparse-Command |
| F2 ISuccinctEncodingStrategy | P04 CoCo | EF-Encoding + PA-Encoding + BV-Encoding + DE-Encoding (Pool) |
| F1 IAdaptiveFootprintStrategy | P02 HOT | Single-Mask-Command + Multi-Mask-Command (9 Layout-Varianten) |
| F4 IMultiCacheLineNodeStrategy | P22 Fractal | Disk-Tier-Command + Cache-Tier-Command (in-page Tree mit adaptive Width pro Tier) |
| F5 ISoftwarePrefetchStrategy | P26 Zhang FGCS | CP (Counter-Prefetcher) + PP (Path-Prefetcher) + MP (Memory-Prefetcher) |
| F8 IPathCollapseStrategy | P01 ART, P05 START | Path-Compression-Command + Lazy-Expansion-Command + Rewiring-Command |
| F11 IPrefetchHintHeaderStrategy | P11/P22/P26 | CSS-Header-Command + Fractal-In-Page-Command + Zhang-Read-Counter-Command |
| F22 IAdaptiveLayoutStrategy | P12 CSB+ + P23 Khan | NodeGroup-Command + AdaptivePrefetchDistance-Command |

---

## §3 Algorithmus-Strategien (Doc 12) — Vier-Ebenen + 17 Hybrid-Commands

### 3.1 Vier-Ebenen-Strategie-Hierarchie (Detail siehe `03_konzepte_saeule_a.md` §2)

| Ebene | Concept | Kardinalitaet |
|---|---|---|
| A | `ISearchPagesStrategyPattern` | 1 pro `IFanout` |
| B | `ISearchPagesStrategy` | N pro Pattern |
| C | `ISearchPageStrategy` | M pro Strategy |
| D | `IStrategyCommand` | K pro Strategy |

### 3.2 17 HybridCompositionCommands (REV K3.4)

Pro Hybrid-Algorithmus eine Aufloesung in atomare Commands:

| # | Hybrid-Algorithmus / Pattern | Quelle | Zerlegung |
|---|---|---|---|
| 1 | MultiStrategyOrchestrationPattern | (REV5) | (siehe Doc 12 §9.1) |
| 2 | HierarchicalFractalPattern | P22 Chen Fractal | (siehe Doc 12 §9.2) |
| 3 | HeterogeneousAdaptivePattern | (REV5) | (siehe Doc 12 §9.3) |
| 4 | P02 HOT (Compound + BMI2 SIMD) | P02 HOT 2018 | Single-Mask-Cmd + Multi-Mask-Cmd + BMI2-Bitmanipulation-Cmd |
| 5 | P10 SuRF (LOUDS-DS Hybrid) | P10 SuRF 2018 | LOUDS-Dense-Cmd + LOUDS-Sparse-Cmd + Range-Filter-Cmd |
| 6 | P07 Wormhole (Trie+Hash+B+) | P07 Wu 2019 | Anchor-Hash-Cmd + Trie-Segment-Cmd + B+-Local-Cmd |
| 7 | P03 Masstree (Trie-of-B+-Trees) | P03 Mao 2012 | Layer-Slice-Cmd + B+-Inner-Cmd + B+-Border-Cmd |
| 8 | P04 CoCo (Pool-of-Encodings + Macro-Node) | P04 Boffa 2024 | EF-Cmd + PA-Cmd + BV-Cmd + DE-Cmd + Macro-Node-Cmd |
| 9 | P06 B²-Tree (Decision + Span Page) | P06 Schmeisser 2022 | Decision-Cmd + Span-Cmd + Embedded-Tree-Cmd |
| 10 | P20 LeanStore (6 Layouts adaptive) | P20 Mueller 2025 | 6 Layout-Cmds + Adaptive-Selection-Cmd |
| 11-17 | (siehe Doc 12 §9.11-9.17 fuer Detail) | (verschiedene Quellen) | (siehe Original) |

---

## §4 Hauptpunkt: Orthogonalitaet (REV5 K3.3)

Die 29 Cache-Strategie-Familien (Doc 11) und die Algorithmus-Strategien (Doc 12) sind **orthogonal zu klassischen Familien-Klassifikationen**:

- Ein "Trie"-Algorithmus (z.B. P01 ART) konfiguriert eine bestimmte Auswahl der 29 ICacheStrategy-Familien (z.B. F1 AdaptiveFootprint + F3 CacheLineAligned + F7 SimdAccelerated + ...) UND nutzt eine bestimmte Algorithmus-Strategie aus Doc 12.
- Ein "B+"-Algorithmus (z.B. P12 CSB+) konfiguriert eine ANDERE Auswahl der 29 Familien + ANDERE Algorithmus-Strategie.
- **Cross-Algorithmus-Permutationen** (Trie-Page + B+-Layout + LOUDS-Encoding + Hot-Path-Heuristic) sind durch die Orthogonalitaet **architekturell vorgesehen** und sind das Kern-Forschungs-Ziel **F15**.

---

## §5 Anbindung an V31-Adapter

Die Architektur-Direktive II 2026-05-14 (NOTICE) operationalisiert die Orthogonalitaet:

> "Da wir alle Algorithmus-Bestandteile zerschneiden, entsteht fuer alle
> Permutations-Achsen ein neues Werk. Das gilt fuer alle Lizenztypen."

Dies ermoeglicht V31-Adapter (22 Stueck), die die einzelnen Bausteine der 33 Paper als COMDARE_HAVE_<X>-konfigurierbare Wrapper zur Verfuegung stellen — fuer freie Cross-Permutation in der Mess-Pipeline.

---

## §6 Querverweise

- Original-Quellen (UNVERAENDERT):
  - `../termine/20260508 Termin 7/Phase5_UML_Detail/11_cache_strategy_taxonomie.md` (Doc 11, 610 Z)
  - `../termine/20260508 Termin 7/Phase5_UML_Detail/12_algorithmus_strategie_taxonomie.md` (Doc 12, 916 Z)
- Saeule A Konzepte: `03_konzepte_saeule_a.md` (K-C.4) §3 (29 Familien) + §4 (4-Ebenen + 17 Hybrid-Commands)
- Saeule B Konzepte: `04_konzepte_saeule_b.md` (K-C.5)
- UML-Klassen: `05_uml_klassen.md` (K-C.6)
- Cross-Reference: `07_cross_reference.md` §3 (33 Paper ↔ Bausteine-Achsen ↔ V31-Adapter)
- Bausteine-Matrix: `../bausteine/01_bausteine_matrix.md`
- F15 Architekturentscheidung: `../bausteine/04_architekturentscheidungen_F1_F15.md`
- NOTICE Architekt-Direktive II: `../../Code/external/comdare-cache-engine/NOTICE`
