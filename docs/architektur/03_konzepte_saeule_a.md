# Konzepte Saeule A — Such-Algorithmen-Datenstruktur

> ⚠️ **SUPERSEDED (2026-05-31):** Überholter Planungs-/Architektur-Stand (axis-zentrische Restruktur F.2, Plugin-Prüfling-Modell, DLL-F15-Pipeline, sezierte Organe). IST-treue Single-Source-of-Truth: `comdare-cache-engine/docs/ledger-sections/architektur-ziele-offene-punkte-ledger.md` + `…/20260531-e2e-abnahme-audit-und-entscheidungen.md`. Niemals löschen — nur Banner.

**Stand:** 2026-05-15 (K-C.4)
**Quellen:** Phase5_UML_Detail Doks 11+12 (`11_cache_strategy_taxonomie.md` 610 Z + `12_algorithmus_strategie_taxonomie.md` 916 Z)

---

## §1 Saeule A im Drei-Saeulen-Modell

```
EBENE 1: IExecutingEngine
  ├── ISearchEngine
  └── IFutureEngine
       ▼ konsumiert
EBENE 2: ← SAEULE A — Suchalgorithmus-Datenstruktur
  IPage / IRootPage / IFanout / INode / ISearchPage / ICachePage /
  ICacheStrategy (Visitor) /
  ISearchPagesStrategy / ISearchPagesStrategyPattern / ISearchPageStrategy /
  IStrategyCommand / HybridCompositionCommand /
  Iteratoren-Familie
       ▼ optimiert via
EBENE 3: CacheEngine + Plattform-Modell (Saeule B)
```

**Trennungs-Prinzip:** Ebene 2 (Saeule A) weiss nichts direkt von CPU/Caches/Bandbreiten — konsumiert nur ICacheStrategy.

---

## §2 Vier-Ebenen-Strategie-Hierarchie (Quelle: Doc 12)

Die REV-2-Architektur differenziert vier orthogonale Strategie-Schichten:

| Ebene | Concept | Kardinalitaet | Zweck |
|---|---|---|---|
| A | `ISearchPagesStrategyPattern` | 1 pro `IFanout` | Komposition/Orchestrierung der Pluralstrategien |
| B | `ISearchPagesStrategy` | N pro Pattern | Plurale Strategien fuer mehrere ISearchPages |
| C | `ISearchPageStrategy` | M pro Strategy | Singulare Strategien pro Page |
| D | `IStrategyCommand` | K pro Strategy | Atomare ausfuehrbare Commands |

**HybridCompositionCommand** (REV5/REV6 K3.4): Hybrid-Strategien werden in atomare Commands zerlegt + unter HybridCompositionCommand zusammengesetzt.

---

## §3 29 ICacheStrategy-Familien F1-F29 (Quelle: Doc 11)

**Hauptpunkt (REV K3.3):** Die 29 Cache-Strategie-Familien sind **orthogonal** zu klassischen Algorithmus-"Familien" (Trie, B+, Hybrid). Ein "Trie"-Algorithmus konfiguriert eine bestimmte Auswahl der 29 Familien.

| ID | Strategie | Konkretisierungen (Auszug) |
|---|---|---|
| F1 | IAdaptiveFootprintStrategy | P01 ART (4 Node-Typen), P02 HOT (9 Layouts), P05 START (multilevel) |
| F2 | ISuccinctEncodingStrategy | P09 LOUDS, P10 SuRF (LOUDS-Dense + LOUDS-Sparse), P04 CoCo (Pool EF+PA+BV+DE) |
| F3 | ICacheLineAlignedStrategy | P11 CSS (1 Knoten = 1 Cache Line), P12 CSB+ |
| F4 | IMultiCacheLineNodeStrategy | P13 Hankins (16 Cache Lines), P22 Fractal |
| F5 | ISoftwarePrefetchStrategy | P21 Chen, P22 Chen Fractal, P26 Zhang FGCS |
| F6 | IAdaptivePrefetchDistanceStrategy | P23 Khan (adaptive distance) |
| F7 | ISimdAcceleratedStrategy | P02 HOT (BMI2/AVX2), P05 START |
| F8 | IPathCollapseStrategy | P01 ART (Path Compression + Lazy Expansion), P05 START Rewiring |
| F9 | IInlineValueStrategy | (PRT-ART eigen) |
| F10 | IExternalValueStrategy | (PRT-ART eigen) |
| F11 | IPrefetchHintHeaderStrategy | P11 CSS, P22 Fractal, P26 Zhang FGCS |
| F12 | ICacheCoherentTelemetryStrategy | P28 Kuehn DAMON (Per-Knoten Counter) — KORRIGIERT v7: Cache-Kohaerenz-Anti-Pattern |
| F13 | IRecursiveCacheLayoutStrategy | P17 vEB, P16 Bender |
| F14 | IRelocationLayoutStrategy | P18 Saikkonen (Multi-Level Relocation), P19 Saikkonen 2016 |
| F15 | IRedirectStrategy | P04 CoCo Macro-Node, P05 START Rewired, P07 Wormhole Anchor |
| F16 | ISiblingClusterStrategy | P12 CSB+ (Node Group), P11 CSS |
| F17 | ITrieStrategy | (atomar) — P01 ART byte-by-byte, P02 HOT discriminative bits |
| F18 | IBPlusStrategy | (atomar) — P03 Masstree, P12 CSB+ |
| F19 | IHashStrategy | (atomar) — P07 Wormhole Anchor-Hash |
| F20 | IRangeFilterStrategy | P10 SuRF |
| F21 | IPrefixEnumerationStrategy | P01 ART, P10 SuRF |
| F22 | IAdaptiveLayoutStrategy | P20 B-Trees Are Back (6 Layouts + adaptive selection) |
| F23 | IConcurrencyStrategy | P08 Leis OLC, P29 RCU, P30 Hazard Pointers |
| F24 | IRebuildStrategy | P14 Samuel Configuration Table, P18 Saikkonen Multi-Level |
| F25 | IHybridSearchStrategy | P07 Wormhole (Trie+Hash+B+), P08 ART of Practical Sync |
| F26 | IConfigurationTableStrategy | P14 Samuel |
| F27 | IBranchPredictionAwareStrategy | P33 VAMPIR (TUD/SPP2377) |
| F28 | IHardwareCounterFeedbackStrategy | P31 Ungethuem TUD, P32 Schmidt TUD |
| F29 | IAuxiliaryProbabilityHintStrategy | P16 Bender (probability-driven layout), P28 Kuehn |

**Detail:** siehe `../termine/20260508 Termin 7/Phase5_UML_Detail/11_cache_strategy_taxonomie.md` Z 30-610

---

## §4 Algorithmus-Strategien-Taxonomie (Quelle: Doc 12)

### 4.1 Hybrid-Command-Pattern-Konvention (Doc 12 §9, REV K3.4)

Wo immer eine Strategie als "hybrid" bezeichnet wird (z.B. MultiStrategyOrchestrationPattern, HierarchicalFractalPattern, HeterogeneousAdaptivePattern, sowie hybrid kombinierte Algorithmen P02 HOT, P10 SuRF, P07 Wormhole, P03 Masstree, P04 CoCo, P06 B²-Tree, P20 B-Trees-Are-Back, P22 Fractal):

→ Diese Hybrid-Strategien werden in **atomare Strategy-Commands** zerlegt + unter einem **HybridCompositionCommand** zusammengesetzt.

Atomare Commands sind einzeln testbar und einzeln in Permutationen rekombinierbar.

### 4.2 17 HybridCompositionCommands (Doc 12)

Detaillierte Liste der 17 Hybrid-Aufloesungen siehe Original-Datei `12_algorithmus_strategie_taxonomie.md` §9.

---

## §5 Wesentliche Unterschiede zu klassischer "Familie"-Klassifikation

### 5.1 Orthogonalitaet (REV5 K10)

In REV5 K10 (Doc 22) wurde explizit gemacht, dass die "Familien" (Trie/B+/Hybrid) nur **Lektuere-Gruppierungen** sind. Die echten architektonischen Achsen sind die 29 ICacheStrategy-Familien aus Doc 11.

### 5.2 8 Hybrid-Aufloesungen (REV5 K10.2)

Acht Layouts-Familien wurden in REV5 als "nicht-zerlegt hybrid" erkannt und in einzelne Strategy-Commands aufgeloest:

| Hybrid | Original-Quelle | Aufloesung |
|---|---|---|
| F8 PathCollapse | P01 ART, P05 START | Path Compression + Lazy Expansion + Rewiring |
| F11 PrefetchHintHeader | P11 / P22 / P26 | CSS-Header + Fractal-In-Page + Zhang-Read-Counter |
| F13 RecursiveCacheLayout | P17 vEB | vEB-Recursion (echte vEB-Reihenfolge ungleich BFS-Approximation, siehe Memory-Direktive) |
| F14 RelocationLayout | P18 Saikkonen | Multi-Level-Reloc + KonsolidierungsBARRIERE |
| F22 AdaptiveLayout | P12 CSB+ + P23 Khan | NodeGroup + AdaptivePrefetchDistance |
| F25 HybridSearch | P07 Wormhole, P08 ART of Practical Sync | Trie+Hash+B+ Anchor-Hash + ART+OLC |
| F27 BranchPredictionAware | P33 VAMPIR | (TUD-spezifisch) |
| F28 HardwareCounterFeedback | P31 Ungethuem | (TUD-spezifisch) |

---

## §6 PRT-ART-Mapping zu Saeule A

PRT-ART ist EINE konkrete Algorithmus-Variante, die je Baustein-Familie zusaetzliche Permutations-Optionen liefert.

**REV6-Korrektur 2026-05-12:** Im PRT-ART-Code selbst werden nur **2 Node-Typen** (Redirect + B+) verwendet. Die 6 Pflicht-Seitentypen aus Termin 4 BLEIBEN aber im Cache-Engine-Framework permutierbar.

**PRT-ART-spezifische Strategien (REV6 §5.17):**
- 2 Node-Typen: Redirect + B+
- 4 Suchtypen: Exact, Prefix, Range, Hash-Anchor
- ValueHandle::{Inline, External, ChainRef}
- Linearer Value-Buffer (PRT-ART eigen)
- 4+2 Allokator-Pools (A/B/C/D + R/V)

---

## §7 Querverweise

- Original-Quellen (UNVERAENDERT):
  - `../termine/20260508 Termin 7/Phase5_UML_Detail/11_cache_strategy_taxonomie.md` (610 Z)
  - `../termine/20260508 Termin 7/Phase5_UML_Detail/12_algorithmus_strategie_taxonomie.md` (916 Z)
- Saeule B Konzepte: `04_konzepte_saeule_b.md` (K-C.5)
- UML-Klassen: `05_uml_klassen.md` (K-C.6)
- REV-Historie: `01_REV_Historie.md` (K-C.2)
- Aktueller Master: `02_aktueller_master_REV7_7.md` (K-C.3)
- Begriffsglossar v7 Master: `../glossar/01_begriffsglossar_v7_master.md` (D1 KNOTEN bis F29 IAuxiliaryProbabilityHintStrategy)
- Bausteine-Matrix: `../bausteine/01_bausteine_matrix.md` (Achsen 1-11)
- Forschungslandkarte 6 Cluster: `../forschungslandkarte/02-07_cluster_*.md` (K-F, in Arbeit)
