# Cross-Reference — Bausteine_Matrix ↔ UML-Klasse ↔ ER-Entitaet ↔ Glossar

> ⚠️ **SUPERSEDED (2026-05-31):** Überholter Planungs-/Architektur-Stand (axis-zentrische Restruktur F.2, Plugin-Prüfling-Modell, DLL-F15-Pipeline, sezierte Organe). IST-treue Single-Source-of-Truth: `comdare-cache-engine/docs/sessions/architektur-ziele-offene-punkte-ledger.md` + `…/20260531-e2e-abnahme-audit-und-entscheidungen.md`. Niemals löschen — nur Banner.

**Stand:** 2026-05-15 (K-C.8)
**Quelle:** `Phase5_UML_Detail/08_cross_reference.md` (129 Z)
**Habich-Anforderung H1:** "Cross-References zwischen Klassen-Diagrammen und ER-Modell"

---

## §1 Bausteine_Matrix Achsen ↔ UML-Klassen ↔ ER-Felder ↔ Glossar v7

| Achse | UML-Concept | UML-Datei (K-C.6 §) | ER-Feld | Glossar v7 BLOCK |
|---|---|---|---|---|
| 1 PAGE-TYPE | `IPage<P>` | §2 (Doc 01 §2) | PermutationFlags.bank_page | A, B (Page-Konzepte) |
| 2 NODE-TYPE | `INode<N>` | §2 (Doc 01 §3) | PermutationFlags.bank_node | C, D |
| 3 TRAVERSAL | `ITraversalAlgorithm<T>` | §2 (Doc 01 §4) | PermutationFlags.bank_traversal | E, F |
| 4 VALUEHANDLE | `IValueHandle<S,V>` | §2 (Doc 01 §5) | PermutationFlags.bank_value_handle | G |
| 5 MEMORY-LAYOUT | `IMemoryLayout<L>` | §2 (Doc 01 §6) | PermutationFlags.bank_memory | H |
| 6 ALLOCATOR | `IAllocator<A>` | §2 (Doc 01 §7) | PermutationFlags.bank_allocator | I |
| 7 PREFETCH | `IPrefetchStrategy<P>` | §2 (Doc 01 §8) | PermutationFlags.bank_prefetch | K |
| 8 CONCURRENCY | `IConcurrencyDiscipline<D>` + `IConcurrencyMechanic<M>` | §3 (Doc 02 §3) | PermutationFlags.bank_concurrency | L, M, N (Konsolidierungsbarriere); **AN** (Cache-Coherence-Cost, NEU v7) |
| 9 ISA | (Compiler-Flags + target_clones) | §5 (Doc 04) | PermutationFlags.bank_isa | O |
| 10 MEASUREMENT | `Measure<Category, Detail>` constexpr | §4 (Doc 03) | MeasurementRecord.category + algo_detail | P |
| **11 TELEMETRY-COLLECTION-STRATEGY (NEU 2026-05-09 Kuehn)** | `ITelemetryStrategy<T>` | §3 (Doc 02 §4) | PermutationFlags.bank_telemetry + MeasurementRecord.telemetry_strategy | **AI, AJ, AK, AL** (Kuehn-Erkenntnisse) |

---

## §2 23 ADRs ↔ UML-Klassen ↔ Bausteine-Achsen

| ADR | Was wird festgelegt | UML-Klasse(n) | Bausteine-Achse |
|---|---|---|---|
| F1 | CacheEngineRuntime-Singleton + Heap-Allokation | CacheEngine, InMemoryMeasurementBuffer | (Querschnitt) |
| F2 | Observer-Push synchron + Lambda-Tree-Filter | Event, IDecisionLambdaTree | Achse 11 (Hooks) |
| F3 | Visitor mid-granularity | ICacheStrategy (Visitor) | (Querschnitt) |
| F4 | Permutationsraum + ISA-Filter | PermutationFlags, IsaFeatureSet | Achse 9 + (Querschnitt) |
| F5 | In-Memory MeasurementBuffer | InMemoryMeasurementBuffer | Achse 10 |
| F6 | ConcurrencyManager: Klassen + Policy-Template | ConcurrencyManager, IConcurrencyDiscipline | Achse 8 |
| F7 | Adapter-Pattern fuer Originalcode (HABICH-DIREKTIVE) | (alle V31-Adapter) | (Querschnitt) |
| F8 | ValueHandle: std::variant + Concept-Constraint | IValueHandle, ValueHandleKind | Achse 4 |
| F9 | ABI-Stabiles C++23-Modul + ModuleLoader | ModuleLoader | (Querschnitt) |
| F10-K | Flag-System statt perm_id (CPUID-Vorbild) | PermutationFlags (9 Banken) | (alle Achsen) |
| F11 | Sampled 1:N Mikrobenchmark-Triggering | Measure<>, RuntimeMicroBenchmark | Achse 10 |
| F12-K | CacheEngine im Builder (Heap-Singleton) | CacheEngine, CacheEngineBuilder | (Querschnitt) |
| F13 | Cross-Compilation-Toolchain (ZIH Runtime, sonst Compile-Time) | IsaFeatureSet, target_clones | Achse 9 |
| F14 | Datasets-Akquise (Pflicht-Korpus + Custom) | DatasetMetadata | (ER) |
| F15 | Bausteine-Quer-Permutation (zentrales Forschungs-Prinzip) | PermutationFlags (alle 9 Banken) | (alle Achsen) |
| F-EXTRA-1 | Original-Compiler pro Algorithmus (Layering) | (V31 ext-Repo Aktivierung) | (Querschnitt) |
| F-EXTRA-2 | Custom-Datasets | DatasetMetadata.type=Custom | (ER) |
| F-EXTRA-3 | SOCKS5-ZIH-Lieferung | (Plattform-Workflow) | (Querschnitt) |
| F-EXTRA-4 | Self-Built Compiler auf Pi 5 + VisionFive 2 | (Cross-Build-Pfad) | Achse 9 |
| F-EXTRA-5 | KEIN Python in Build (CMake/sh/bat) | CodegenSkript | (Querschnitt) |
| F-EXTRA-6 | DecisionLambdaTrees PRO Baustein | IDecisionLambdaTree | (alle Achsen) |
| F-EXTRA-7 | Default-Mess-Hooks + Algo-Override | Measure<>, HasMeasurement | Achse 10 |
| F-EXTRA-8 | ABI-Stabilitaets-Test + GTests | (CI + ABI-Test) | (Querschnitt) |

---

## §3 33 Paper P01-P33 ↔ Bausteine-Achsen ↔ V31-Adapter

| P-ID | Hauptkonzept | Achse(n) | V31-Adapter |
|---|---|---|---|
| P01 ART | Adaptive Radix Tree | 1 (Page), 2 (Node) | `comdare::adapter::p01_art::UnodbDbAdapter` ✅ |
| P02 HOT | Compound Node + BMI2 | 2 (Node), 7 (SIMD) | `comdare::adapter::p02_hot::HotAdapter` ✅ |
| P03 Masstree | Trie-of-B+-Trees | 1 (Page), 2 (Node), 8 (Concurrency) | `comdare::adapter::p03_masstree::MasstreeAdapter` ✅ |
| P04 CoCo-trie | Macro-Node | 1 (Page), 5 (Memory) | `comdare::adapter::p04_coco_trie::CocoTrieAdapter` ✅ (GPL-3) |
| P05 START | Multibyte + Rewiring | 2 (Node), 3 (Traversal) | `comdare::adapter::p05_start::StartAdapter` ✅ |
| P06 B²-Tree | Decision/Span Page | 1 (Page) | `comdare::adapter::p06_b2tree::B2TreeAdapter` ✅ (no-LICENSE) |
| P07 Wormhole | Trie-Hash-B+ Hybrid | (alle 1-3 + 8) | `comdare::adapter::p07_wormhole::WormholeAdapter` ✅ (GPL-3) |
| P08 ART of Practical Sync | OLC | 8 (Concurrency) | (in OLC-Concurrency-Adapter, nicht V31.K) |
| P09 LOUDS | Succinct Tree-Encoding | 1 (Page), 7 (SIMD) | LEGACY_REIMPL |
| P10 SuRF | LOUDS-Dense + LOUDS-Sparse | 1 (Page), 5 (Memory) | `comdare::adapter::p10_surf::SurfAdapter` ✅ |
| P11 CSS-tree | Cache-Line-Node | 1 (Page), 5 (Memory) | LEGACY_REIMPL |
| P12 CSB+-tree | Sibling-Cluster | 5 (Memory), 7 (Prefetch) | LEGACY_REIMPL |
| P13 Hankins | Wider Nodes | 1 (Page) | LEGACY_REIMPL |
| P14 Samuel | Configuration Table | (Tooling) | LEGACY_REIMPL |
| P15 Graefe | B-Tree Indexes Survey | (Konzept) | (Survey) |
| P16 Bender Tree Layout | Probability-driven | 5 (Memory) | LEGACY_REIMPL |
| P17 Bender Cache-Oblivious | vEB-Recursion | 5 (Memory) | LEGACY_REIMPL |
| P18 Saikkonen 2008 | Multi-Level Reloc | 8 (Concurrency, Reloc) | LEGACY_REIMPL |
| P19 Saikkonen 2016 | Layout-Invariante | 5 (Memory) | LEGACY_REIMPL |
| P20 B-Trees Are Back | LeanStore Adaptive Layout | 1 (Page) | `comdare::adapter::p20_leanstore::LeanStoreAdapter` ✅ |
| P21 Chen 2001 | PB-Trees Prefetching | 7 (Prefetch) | LEGACY_REIMPL |
| P22 Chen 2002 | Fractal Prefetching | 7 (Prefetch) | LEGACY_REIMPL |
| P23 Khan 2010 | Adaptive Prefetch Distance | 7 (Prefetch) | LEGACY_REIMPL |
| P24 Naderan-Tahan | Useless Prefetch | 7 (Prefetch) | LEGACY_REIMPL |
| P25 Mahling | Fill Buffer | 7 (Prefetch), 11 (Telemetry) | `comdare::adapter::p25_mahling::FillBufferProbe` ✅ (no-LICENSE) |
| P26 Zhang FGCS | Read Counter | 11 (Telemetry) | LEGACY_REIMPL |
| P27 Zhang ASPLOS | Hierarchical Bundle | 7 (Prefetch) | `tools/p27_bundle_finder/` (V31.K5) + `legacy_reimpl/P27/HierarchicalBundlePrefetcher` (V31.K6) |
| P28 Kuehn DAMON | Histogram/HotPath + Cache-Coherence-Anti-Pattern | 11 (Telemetry) | (LeafOnly-Counter-Familie in v7) |
| P29 RCU | Read-Copy-Update | 8 (Concurrency) | `comdare::adapter::p29_rcu::LiburcuAdapter` ✅ (LGPL) |
| P30 Hazard Pointers | Wait-free Memory Reclamation | 8 (Concurrency) | `comdare::adapter::p30_hazard_pointers::HazardPointerAdapter` ✅ (no-LICENSE; F12-K ENTFERNT, RCU bevorzugt) |
| P31 Ungethuem | TUD Hardware Survey | 9 (ISA), Plattform-Modell | (Survey) |
| P32 Schmidt | TUD To Stride or Not | 7 (Prefetch) | (Survey) |
| P33 Berthold | TUD VAMPIR Poster | (Plattform) | (Tool-Verweis) |

---

## §4 23 Allokator-Paper A01-A23 ↔ AA-Achsen ↔ V31-Adapter

Siehe `../bausteine/02_allokator_matrix.md` Detail. 10 V31-Adapter implementiert (A01, A03, A04, A05, A06, A07, A08, A10, A11, A20).

---

## §5 V31-Sprints ↔ Doku-Update

| Sprint | UML-Update | ER-Update | Bausteine-Update | thesis-Update |
|---|---|---|---|---|
| V12 | PrtArtSearchEngine std-API | (kein) | (kein) | NAMING_CONVENTIONS.md |
| V13 | runtime_codegen + functional_tests + Stage-1/2 | (kein) | (kein) | thesis-Skelett |
| V19 | `<expected_workload>` Tag | DatasetMetadata.expected_workload | Achse 11 erweitert | (kein) |
| V20 | PermutationResult.workload_used | MeasurementRecord.workload_used | (kein) | (kein) |
| V25.B | 30 SOTA-Profile mit Tag | (kein) | Bausteine-Matrix V31-Spalte | thesis ch02 (V28) |
| V25.C | 11 SOTA-Adapter-Skelette | (kein) | (kein) | (kein) |
| V26.A | 10 Allokator-Profile | (kein) | Allokator-Matrix erweitert | thesis ch02 (V28) |
| V26.B | 10 Allokator-Adapter-Skelette | (kein) | (kein) | (kein) |
| V29 | `<allocator_override>` Tag | PermutationFlags.allocator_override | (kein) | (kein) |
| V30 | libs/-Migration | (kein) | (kein) | thesis ch04 (V31.I) |
| V31.K1-K6 | 22 Adapter-Inhalte + P27 hp-soft | (kein) | (kein) | thesis ch04 (V31.I) |

---

## §6 Querverweise

- Original-Quelle (UNVERAENDERT): `../termine/20260508 Termin 7/Phase5_UML_Detail/08_cross_reference.md`
- Bausteine-Matrix: `../bausteine/01_bausteine_matrix.md`
- Allokator-Matrix: `../bausteine/02_allokator_matrix.md`
- F1-F15 Architekturentscheidungen: `../bausteine/04_architekturentscheidungen_F1_F15.md`
- UML-Klassen: `05_uml_klassen.md` (K-C.6)
- ER-Modell: `06_er_modell.md` (K-C.7)
- Begriffsglossar v7 Master: `../glossar/01_begriffsglossar_v7_master.md`
- Forschungslandkarte 33 Paper: `../forschungslandkarte/01_quellen_gesamtkatalog.md` (K-F.2, in Arbeit)
