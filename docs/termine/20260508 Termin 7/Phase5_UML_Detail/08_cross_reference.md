# Cross-Reference — Bausteine_Matrix ↔ UML-Klasse ↔ ER-Entitaet ↔ Glossar

**Habich-Anforderung H1:** "Cross-References zwischen Klassen-Diagrammen und ER-Modell".

**Stand:** 2026-05-09

---

## 1. Bausteine_Matrix Achsen ↔ UML-Klassen

| Bausteine-Achse | UML-Concept | UML-Datei | ER-Entitaet | Glossar v7 BLOCK |
|-----------------|-------------|-----------|-------------|------------------|
| 1 Page | `IPage<P>` | 01_uml_search_engine.md §2 | PermutationFlags.bank=page | A, B (Page-Konzepte) |
| 2 Node | `INode<N>` | 01_uml_search_engine.md §3 | PermutationFlags.bank=node | C, D |
| 3 Traversal | `ITraversalAlgorithm<T>` | 01_uml_search_engine.md §4 | PermutationFlags.bank=traversal | E, F |
| 4 ValueHandle | `IValueHandle<S,V>` | 01_uml_search_engine.md §5 | PermutationFlags.bank=value_handle | G |
| 5 MemoryLayout | `IMemoryLayout<L>` | 01_uml_search_engine.md §6 | PermutationFlags.bank=memory | H |
| 6 Allocator | `IAllocator<A>` | 01_uml_search_engine.md §7 | PermutationFlags.bank=allocator | I |
| 7 Prefetch | `IPrefetchStrategy<P>` | 01_uml_search_engine.md §8 | PermutationFlags.bank=prefetch | K |
| 8 Concurrency | `IConcurrencyDiscipline<D>` + `IConcurrencyMechanic<M>` | 02_uml_cache_engine.md §3 | PermutationFlags.bank=concurrency | L, M, N (Konsolidierungsbarriere); AN (Cache-Coherence-Cost, NEU) |
| 9 ISA | (Compiler-Flags + target_clones) | 04_uml_hardware_isa.md | PermutationFlags.bank=isa | O |
| 10 Measurement | `Measure<Category, Detail>` constexpr | 03_uml_measurement.md | MeasurementRecord.category + algo_detail | P |
| **11 Telemetry-Collection-Strategy (NEU 2026-05-09)** | `ITelemetryStrategy<T>` | 02_uml_cache_engine.md §4 | PermutationFlags.bank=telemetry + MeasurementRecord.telemetry_strategy | **AI, AJ, AK, AL** (Kuehn) |

---

## 2. Klasse-A-Originalcode-Repos ↔ Bausteine ↔ UML-Klassen

| P-ID | Repo | Bausteine-Achse | konkrete Bausteine | UML-Klasse |
|------|------|------------------|---------------------|------------|
| P01 | unodb | 1, 2, 3, 8 | PAGE_DENSEBYTE_ART256, NODE_NODE4-256, TRAVERSAL_BYTEBYBYTE, CONCURRENCY_OLC | Art256Page, NodeXxX, …, OLCMechanic |
| P02 | hot | 1, 2, 3, 7, 8 | PAGE_COMPOUND_HOT, NODE_HOT_COMPOUND_K32 + BINODE, TRAVERSAL_DISCRIMINATIVE_BITS, PREFETCH_*, CONCURRENCY_ROWEX | HotCompoundNode, RowexMechanic |
| P03 | masstree-beta | 1, 2, 3 | PAGE_BPLUS_MASSTREE, NODE_INTERNAL/BORDER_MASSTREE, TRAVERSAL_LAYER_SLICE | MasstreePage, InternalMasstreeNode, BorderMasstreeNode |
| P04 | CoCo-trie | 1, 2, 3, 5 | PAGE_MACRO_COCO, NODE_MACRONODE_COCO, TRAVERSAL_MACRO_NODE, MEMORY_*succinct* | MacroCocoPage, MacronodeNode |
| P05 | START | 1, 2, 6, 10, 11 | PAGE_MULTIBYTE_START, NODE_MULTIBYTE, ALLOCATOR-rewiring, MEASUREMENT (mfence/rdtsc/clflush), TELEMETRY-Tag-Manager (Konzept-Bezug RetroactiveAggregation) | StartPage, RewiringAllocator |
| P06a | b2-tree-master | 1, 2, 3, 5, 8 | PAGE_DECISION/SPAN_B2TREE, NODE, TRAVERSAL_EMBEDDED_DEC_TREE, MEMORY_EMBEDDED_TREE, OLC+EPOCH | B2TreePage |
| P06b | bart-master | 1, 2, 3 (bonus) | PAGE_BART_HYBRID/HATTRIE/PBTREESTATIC*-Familie + Node + Traversal | BartHybridPage, HatTriePage, PBTreeStaticPage etc. |
| P07 | wormhole | 1, 3, 8 | PAGE_METATRIEHT_WORMHOLE, TRAVERSAL_HASH_ANCHOR, USER_SPACE_RWLOCK+QSBR (Konzept-Bezug F2) | WormholePage |
| P10 | SuRF | 1, 3, 5 | PAGE_LOUDS_DENSE/SPARSE_SURF, TRAVERSAL_RANK_SELECT/LOWER_BOUND, MEMORY_SUCCINCT | SurfDensePage, SurfSparsePage |
| P20 | leanstore | 1, 8, 11 (Konzept) | PAGE_ADAPTIVE_BTREESAREBACK, OCC+SI+MVCC, COUNTER-Suite | (Konzept-Studie, kein direkter Adapter) |
| P25 | prefetching | 7, 8, 11 | PREFETCH_FILL_BUFFER_AWARE, OLC+Coroutinen, sampling/adaptive-Prefetch | PrefetchFillBufferTraversal |
| P29 | userspace-rcu | 8 | CONCURRENCY_RCU (Konzept fuer Task #104 ComdareRcuMechanic) | (Konzept-Quelle, eigene Impl. via comdare-rcu) |
| P30 | haz_ptr | 8 | (NICHT im Bausteine-Permutations-Raum aktuell — Achse 8 listet OLC/ROWEX/RCU) | (nicht implementiert; kann via b2-tree-master/hazard.hpp einsteigen falls in Phase 6+ ergaenzt) |

---

## 3. Klasse-B-LEGACY_REIMPL ↔ Bausteine ↔ UML-Skelette

| P-ID | Paper | Skelett-Pfad | Bausteine-Achsen | UML-Klassen |
|------|-------|---------------|-------------------|------------|
| P11 | CSS-tree (Rao/Ross 1999) | `prt_art/legacy_reimpl/P11-CSS-tree/` | 1, 2, 3, 5 | CssNodePage, CssNode, PointerArithTraversal, MEMORY_POINTER_FREE_CONTIG |
| P12 | CSB+-tree (Rao/Ross 2000) | `prt_art/legacy_reimpl/P12-CSB-tree/` | 1, 2, 3, 5 | CsbNodeGroupPage, CsbNode, OffsetTraversal, MEMORY_SIBLING_CLUSTER |
| P13 | Hankins (2003) | `prt_art/legacy_reimpl/P13-Hankins/` | 1, 2 | WiderHankinsPage, WiderBplusNode |
| P14 | Samuel CSB-Conscious (2005) | `prt_art/legacy_reimpl/P14-Samuel/` | 1 | ConfigtableSamuelPage |
| P16 | Bender Tree Layout (2002) | `prt_art/legacy_reimpl/P16-Bender-TreeLayout/` | 5 | ProbabilityLayout |
| P17 | Bender Cache-Oblivious (2005) | `prt_art/legacy_reimpl/P17-Bender-CacheOblivious/` | 5 | CacheObliviousLayout |
| P18 | Saikkonen Multi-Level (2008) | `prt_art/legacy_reimpl/P18-Saikkonen-MultiLevel/` | 5 | MultiLevelReloc |
| P19 | Saikkonen Layout-Invariant (2016) | `prt_art/legacy_reimpl/P19-Saikkonen-LayoutInvariant/` | 5 | LayoutInvariant |
| P21 | Chen Prefetching B+ (2001) | `prt_art/legacy_reimpl/P21-Chen-PrefetchBPlus/` | 1, 7 | PrefetchChenPage, SoftwareFixedPrefetch |
| P22 | Chen Fractal (2002) | `prt_art/legacy_reimpl/P22-Chen-Fractal/` | 1, 7 | FractalChenPage |
| P23 | Khan Adaptive Prefetch (2010) | `prt_art/legacy_reimpl/P23-Khan-AdaptivePrefetch/` | 7 | AdaptivePrefetchTraversal |
| P24 | NaderanTahan (2016) | `prt_art/legacy_reimpl/P24-NaderanTahan/` | 11 (Studie) | UselessPrefetchStudy (Mess-Hilfe) |
| P26 | Q. Zhang FGCS Prefetch (2024) | `prt_art/legacy_reimpl/P26-Zhang-FGCS/` | 7, 11 | PathReadCounter, HotPathRecognitionTree |
| P27 | T. Zhang ASPLOS Hierarchical (2025) | `prt_art/legacy_reimpl/P27-Zhang-ASPLOS-Hierarchical/` | 7 | HierarchicalBundlePrefetch |

---

## 4. Klasse-C ↔ Bausteine ↔ UML-Klassen

| P-ID | Quelle | Status | Bausteine-Achse | UML-Klasse |
|------|--------|--------|------------------|------------|
| P09 | Jacobson 1989 LOUDS | NO-CODE (Konzept) | 1 (Konzept) | (SDSL-Lite-Portierung Task #105) |
| P15 | Graefe Survey 2001 | NO-CODE | — (Survey) | (Konzept-Verweise) |
| P28 | Kuehn DAMON 2023 | ZUGESAGT (Code-Drop offen) | **11 (NEU 2026-05-09 — Hauptquelle)** | PerNodeCounter, LeafOnlyCounter, LeafOnlySampledCounter<N>, RetroactiveAggregation, SamplingRateAdjustmentTree, CacheCoherenceDetectionTree, CoherenceAwareWriteDecisionTree |
| P31 | Ungethuem TUD 2017 | ANFRAGE OFFEN | (offen) | (vermutlich F4 HBM-Allocator-Familie) |
| P32 | Schmidt TUD 2025 (To Stride) | ANFRAGE OFFEN | (offen) | (vermutlich PrefetchStrategy-Erweiterung) |
| P33 | VAMPIR Poster 2023 | ANFRAGE OFFEN | (offen) | (vermutlich PerfEvent-Wrapper) |
| P08 | ART Sync (Leis 2016) | in P01 integriert | 8 | OLCMechanic (P01 unodb implementiert das) |

---

## 5. Architektur-Entscheidungen ↔ UML-Klassen

| ADR-ID | Beschluss | UML-Klasse | UML-Datei |
|--------|-----------|------------|-----------|
| F1 | Heap-Singleton mit unique_ptr + call_once + constexpr Mess-Spezialisierung | CacheEngine, Measure<Category,Detail> | 02_uml_cache_engine.md §1, 03_uml_measurement.md |
| F2 | Push synchron mit Lambda-Tree-Filter | ObserverRegistry + IDecisionLambdaTree | 02_uml_cache_engine.md §2, §5 |
| F3 | Visitor mid-granularity | (Visitor-Methoden in IPage, INode) | 01_uml_search_engine.md |
| F4 | Permutationsraum vollstaendig + ISA-Filter via CMake | PermutationFlags + ConstraintFilter | 05_uml_engine_choice_builder.md §3 |
| F5 | Eigene InMemoryMeasurementBuffer; KEINE externe DB | InMemoryMeasurementBuffer | 06_uml_persistence.md, 07_er_model.md |
| F6 | ConcurrencyManager: 8 Disziplinen + 3 Mechaniken + Policy-Templates | ConcurrencyManager (template policy) | 02_uml_cache_engine.md §3 |
| F7 | C++23 Modules + Original-Compiler pro fremdem Algo | F-EXTRA-1 Compiler-Layering Architektur | 05_uml_engine_choice_builder.md §7 |
| F8 | std::variant<...> + Concept-Constraint | ValueHandle, DynamicValueHandle | 01_uml_search_engine.md §5 |
| F9 | Modularisiert + dlopen/LoadLibrary; Compile-time + Runtime ISA-Detection | DynamicModule + PlatformProbe | 04_uml_hardware_isa.md, 05_uml_engine_choice_builder.md |
| F10 + F10-K | Strukturiertes Flag-System (Intel-CPUID-Vorbild) | PermutationFlags struct | 05_uml_engine_choice_builder.md §3 |
| F11 | Continuous (Builder) + Sampled (Production) Mikrobenchmarks | Measure-Trigger-Modus | 03_uml_measurement.md |
| F12 + F12-K | CacheEngineBuilder = main.cpp; CacheEngine ist Heap-Singleton im Builder-Prozess | CacheEngineBuilder + CacheEngine | 05_uml_engine_choice_builder.md §1, 02_uml_cache_engine.md §1 |
| F13 | Cross-Compile via Infrastruktur + ZIH-Lieferung + CI/CD | CompilePipeline + DeliveryDriver | 05_uml_engine_choice_builder.md §7 |
| F14 | YCSB komplett + Custom-Korpus voll | DatasetLoader + 6 Custom-Datasets | 03_uml_measurement.md, 07_er_model.md (DatasetMetadata) |
| F15 | Bausteine-Quer-Permutation als KERN | PermutationModule (Compile-Time-Komposition) | 01_uml_search_engine.md §9 |
| F-EXTRA-1 | Compiler-Layering: Schale C++23 + Internals Original-Compiler | ModulWrapperC23 + BausteinInternal + StaticLinker | 05_uml_engine_choice_builder.md §7 |
| F-EXTRA-5 REVIDIERT durch H6 | NO-PYTHON: CMake + sh/bat statt Python | CMakeShBatCodegenDriver | 05_uml_engine_choice_builder.md §5 |
| F-EXTRA-6 | DecisionLambdaTrees PRO Baustein | IDecisionLambdaTree-Familie + Bundle | 02_uml_cache_engine.md §2 |
| F-EXTRA-7 | Default-Hooks + algo-spezifische Overrides via requires | Measure<Category, Detail> + HasMeasurement-Concept | 03_uml_measurement.md |
| F-EXTRA-8 | Bit-Identitaets-Test + Funktional + Strukturell + Habich-Log | BuildArtefact.abi_signature + abi_test_status | 07_er_model.md |
| H6 | NO-PYTHON-DIREKTIVE | (Memory-Notiz + F-EXTRA-5 REVIDIERT) | 05_uml_engine_choice_builder.md §5 |
| Block AO | Production-Plattform Ryzen 9950X3D + i9-14900KS | PlatformProbe + CacheHierarchyManager | 04_uml_hardware_isa.md, 02_uml_cache_engine.md §6 |
| Block AP | Forschungs-Mission heuristisch ↔ informiert ↔ adaptiv | CacheEngineMode-Enum + ExperimentRun.mode | 02_uml_cache_engine.md §9, 07_er_model.md |
| Kuehn AI | Cache-Coherence-Anti-Pattern | CacheCoherenceDetectionTree + NotInTopLevels-Concept | 02_uml_cache_engine.md §2 |
| Kuehn AJ | LeafOnlyCounter | LeafOnlyCounter-Klasse | 02_uml_cache_engine.md §4 |
| Kuehn AK | RetroactiveAggregation (Barriere) | RetroactiveAggregation-Klasse | 02_uml_cache_engine.md §4 |
| Kuehn AL | LeafOnlySampledCounter<N> | LeafOnlySampledCounter-Template | 02_uml_cache_engine.md §4 |
| Kuehn AM | SamplingRateAdjustmentTree | SamplingRateAdjustmentTree-Klasse | 02_uml_cache_engine.md §2 |
| Kuehn AN | CacheCoherenceCost in MemoryAccessConcurrency::Write | MemoryAccessConcurrencyWrite-Erweiterung + CoherenceAwareWriteDecisionTree | 02_uml_cache_engine.md §2, §3 |

---

## 6. Klassendiagramm-Tabs in drawio (REV 2)

| Tab | Inhalt | UML-Datei |
|-----|--------|-----------|
| 01-A bis 01-G | Search Engine Bausteine (alle 7 Achsen) | 01_uml_search_engine.md |
| 02-A bis 02-G | Cache Engine Komponenten (Singleton, DecisionTrees, Concurrency, Telemetry, Observer, CacheHierarchy, Sequence) | 02_uml_cache_engine.md |
| 03-A bis 03-C | Measurement (Mess-Matrix, Hooks, Trigger) | 03_uml_measurement.md |
| 04-A bis 04-C | Hardware/ISA + Flag-System + PlatformProbe (Block AO) | 04_uml_hardware_isa.md |
| 05-A bis 05-E | Engine-Choice + Builder (F12-K, Compiler-Layering, Codegen) | 05_uml_engine_choice_builder.md |
| 06-A bis 06-B | Persistence (InMemoryBuffer + Disk-Format) | 06_uml_persistence.md |
| 07-A | ER-Modell (alle Tabellen + Beziehungen) | 07_er_model.md |
| 08-A | Cross-Reference-Map (visualisiert dieses Dokument) | 08_cross_reference.md |
