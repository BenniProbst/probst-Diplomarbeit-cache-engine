# Y.1 — comdare-cache-engine Ist-Kartografie (V31.F Stand)

**Stand:** 2026-05-18 (Y.1)
**Repo-HEAD:** `16176ee` (V31.F Teil 1: Smoke-Tests fuer alle 22 V31-Adapter)
**Vorgehen:** Klassen-Inventar pro Verzeichnis, Achsen-Zuordnung (N-Phase 14 Achsen), Reuse-Status, M-Subsystem-Rolle

> Dieses Dokument ist die **Ist-Bestandsaufnahme** vor der UML-Planung (Z-Phase). Pro Klasse: Datei + Namespace + Achse + Subsystem-Rolle. Quelle: 193 Header-Files unter `libs/`, `apps/`, `adapters/`.

---

## §1 Repo-Top-Level-Struktur

```
comdare-cache-engine/
├── apps/                            (Subsystem 2: CacheEngineBuilder - Executable)
│   └── cache_engine_builder/main.cpp
├── libs/                            (Subsystem 3: CacheEngine - Library)
│   ├── cache_engine/
│   │   ├── builder/                 (5 Sub-Module: codegen, experiment_driver, experiment_runner, module_loader, permutation_loop)
│   │   ├── include/cache_engine/
│   │   │   ├── abi/                 (10 Header: ABI-stabile C++23-Modul-Schnittstelle)
│   │   │   ├── allocators/          (concepts/, families/, locking/)
│   │   │   ├── concepts/            (40+ Header: Sub-Engine-Interfaces, Disciplines, Decision-Trees)
│   │   │   ├── fingerprint/, hbm/, measurement/
│   │   ├── reclamation/rcu_reclaim/
│   │   └── subsystems/              (12 Sub-Engines C01-C12!)
│   ├── common/
│   │   ├── serialization/xml_config_parser/
│   │   └── succinct/                (eigene C++23-Portierung von SDSL)
│   ├── deprecated/prt_art_legacy/   (V23.A Marker, leer per Memory-Direktive)
│   ├── execution_engine/include/comdare/
│   └── test_infra/                  (3 Sub-Module: benchmark_suite, test_data, workload_generator)
└── adapters/                        (22 V31-Adapter)
    ├── A01-hoard / A03-michael-lockfree / A04-mimalloc / ... A20-dlmalloc (10 Allokator)
    └── P01-ART / P02-HOT / P03-Masstree / ... P30-HazardPointers (12 SOTA)
```

**Header-Files total:** 193
**Adapter:** 22 (12 SOTA + 10 Allokator)
**Sub-Engines C01-C12:** 12 (entspricht M-Modell Ebene II)

---

## §2 Subsystem 2 — CacheEngineBuilder (apps/)

| Datei | Inhalt | Phasen 1-7 |
|---|---|---|
| `apps/cache_engine_builder/main.cpp` | Executable Entry-Point | orchestriert Phasen 1-7 |

**M-Modell-Rolle:** Subsystem 2 (autonomes Plattform-Ausmess-System).

### §2.1 Builder-Sub-Module (libs/cache_engine/builder/)

| Sub-Modul | Datei | Phase |
|---|---|---|
| codegen | `codegen/codegen.hpp` | Phase 2/3 (CodeGen fuer Permutations) |
| experiment_driver | `experiment_driver/experiment_driver.hpp` | Phase 5 BIND + Phase 6 EXECUTE |
| experiment_runner | `experiment_runner/experiment_runner.hpp` | Phase 6 EXECUTE |
| module_loader | `module_loader/module_loader.hpp` | Phase 5 BIND (DLL-Loading) |
| permutation_loop | `permutation_loop/permutation_loop.hpp` | Phase 7 COMPARE (Loop-Driver) |

---

## §3 Subsystem 3 — CacheEngine (libs/)

### §3.1 ABI-Schicht (libs/cache_engine/include/cache_engine/abi/)

| Header | Klasse / Concept | Rolle |
|---|---|---|
| `algorithm_baustein.hpp` | `IAlgorithmBaustein` Concept | Achse 1-13 Baustein-Interface |
| `baustein_variants.hpp` | `std::variant`-Family | Compile-time Baustein-Sammlung |
| `configuration_permutation.hpp` | `ConfigurationPermutation` | Permutation-Descriptor |
| `execution_engine.hpp` | `IExecutingEngine` Concept | Pruefling-Interface (M.3 Bidi-Eingang) |
| `module_abi_v1.hpp` | `ModuleABI` | DLL-Schnittstelle (V31) |
| `module_loader.hpp` | `ModuleLoader` | Dynamic-Loading |
| `processing_strategy.hpp` | `IProcessingStrategy` | ExecutionEngine-Helfer |
| `resolve_baustein.hpp` | `ResolveBaustein` | Permutations-zu-Baustein-Auswahl |
| `search_algorithm_type_collection.hpp` | `SearchAlgorithmTypeCollection` | Type-Family Container |
| `search_engine.hpp` | `ISearchEngine<Key,Value>` Concept | **Pruefling-API (V12.3+, M.3 Bidi-Eingang)** |
| `type_collection_traits.hpp` | Type-Traits | Compile-time Helfer |

### §3.2 Allocators (libs/cache_engine/include/cache_engine/allocators/)

| Sub-Verzeichnis | Inhalt | Achsen-Zuordnung |
|---|---|---|
| `concepts/` | `IAllocationStrategy`, `LockingConcept`, `PmrResourceConcept` | Achse 6.1-6.5 + 8.2 |
| `families/a01_hoard` bis `a23_vmem_magazines` | 23 Allokator-Familie-Adapter | Achse 6.1 (Allocation-Strategy) |
| `locking/` | `cache_page_aware_lock`, `shared_mutex_lock` | Achse 8.2 (Locking-Mode) |
| `allocator_manager.hpp` | `AllocatorManager` (Top-Level) | Achse 6 Top-Level |
| `allocator_permutation_flags.hpp` | Sub-Bank-Encoding fuer Allokator | Bank 6 (3+2+2+2+2 = 11 bit) |
| `portable_aligned_alloc.hpp` | Cross-Platform Aligned-Alloc | Hilfs-Modul |

### §3.3 Sub-Engines C01-C12 (libs/cache_engine/subsystems/)

| Sub-Engine | Verzeichnis | M-Modell Ebene II |
|---|---|---|
| C01 Cost-Engine | `c01_cost_engine/` | ~28 Atome (Layout-Cost-Modelle) |
| C02 Pinning-Engine | `c02_pinning_engine/` | ~10 Atome (CPU-Pinning) |
| C03 Prefetch-Engine | `c03_prefetch_engine/` | ~25 Atome (HW + SW Prefetch) |
| C04 Coherence-Engine | `c04_coherence_engine/` | ~12 Atome (Cache-Coherence) |
| C05 Telemetry-Engine | `c05_telemetry_engine/` | ~22 Atome (Mess-Strategien) |
| C06 Allocation-Engine | `c06_allocation_engine/` | ~17 Atome (Allocation-Helper) |
| C07 Migration-Engine | `c07_migration_engine/` | ~12 Atome (Page-Migration) |
| C08 Encoding-Engine | `c08_encoding_engine/` | ~28 Atome (LOUDS, Succinct) |
| C09 Heuristik-Engine | `c09_heuristik_engine/` | ~73 Atome ORTHOGONAL |
| C10 Topologie-Engine | `c10_topologie_engine/` | ~17 Atome (Cache-Topology) |
| C11 Scheduler-Engine | `c11_scheduler_engine/` | ~13 Atome (Worker-Pool-Steuerung) |
| C12 Filter-Engine | `c12_filter_engine/` | ~9 Atome (Bloom, Surf) |

**Total Atome:** ~280 ueber 12 Sub-Engines. (Anti-Vermischung Ebene II laut R.11.)

### §3.4 Concepts (libs/cache_engine/include/cache_engine/concepts/)

Top-Level Concepts (40+ Header):

| Header | Concept | Achsen-Zuordnung |
|---|---|---|
| `i_cache_engine.hpp` | `ICacheEngine` | Master-API |
| `i_sub_engine.hpp` | `ISubEngine` | Ebene II (C01-C12) |
| `i_concurrency_discipline.hpp` | `IConcurrencyDiscipline` | Achse 8.1 (Pattern) |
| `i_concurrency_mechanic.hpp` | `IConcurrencyMechanic` | Achse 8.1 (3 Mechaniken) |
| `i_decision_lambda_tree.hpp` | `IDecisionLambdaTree` | F-EXTRA-6 |
| `i_observer.hpp` | `IObserver` | Event-System (V148 INK-1) |
| `i_telemetry_strategy.hpp` | `ITelemetryStrategy` | **Achse 11 (Kuehn 11.X1-X4 noch FEHLT)** |
| `cache_engine_mode.hpp` | `CacheEngineMode` | Achse Engine-Choice (V1-V4) |
| `cache_hierarchy_manager.hpp` | `CacheHierarchyManager` | F4 Plattform-Adapter |
| `cache_recommendation.hpp` | `CacheRecommendation` | Heuristik-Output |
| `concurrency_manager.hpp` | `ConcurrencyManager` | Achse 8 Top-Level (8 Disziplinen + 3 Mechaniken) |
| `decision_lambda_tree_bundle.hpp` | Bundle | F-EXTRA-6 Composition |
| `decision_lambda_tree_registry.hpp` | Registry | Lookup |
| `event.hpp` | `Event` Hierarchie | Observer-Pattern |
| `permutation_flags.hpp` | `PermutationFlags` | **N-Phase: muss 9 -> 14 Banks (V32.2)** |
| `platform_snapshot.hpp` | `PlatformSnapshot` | Phase 1 DISCOVER Output |
| `pressure_state.hpp` | `PressureState` | Live-Modell |
| `request_context.hpp` | `RequestContext` | Per-Lookup Context |

#### Disziplinen-Cluster (concepts/disciplines/)

| Header | Discipline | Achse |
|---|---|---|
| `array_discipline.hpp` | Array-Operationen | Achse 3.B |
| `data_structure_discipline.hpp` | Struct-Hilfe | Achse 1 |
| `memory_read_discipline.hpp` | Read-Side | Achse 8.2 (read-only) |
| `memory_read_write_discipline.hpp` | RW-Side | Achse 8.2 (read-write) |
| `memory_write_discipline.hpp` | Write-Side | Achse 8.2 (write) |
| `node_discipline.hpp` | INode-Operationen | Achse 2 |
| `page_discipline.hpp` | IPage-Operationen | Achse 1 |
| `path_discipline.hpp` | Path-Traversal | Achse 3.A |
| `simd_flow_discipline.hpp` | SIMD-Pipeline | Achse 12.1 (SIMD-Family) |
| `simd_thread_discipline.hpp` | SIMD-Worker | **Achse 13.2 (SIMD-Worker-Count-Limit, NEU)** |

#### Mechaniken-Cluster (concepts/mechanics/)

| Header | Mechanic | Achse 8.1 Pattern |
|---|---|---|
| `comdare_rcu_mechanic.hpp` | Comdare-RCU (eigen, statt liburcu) | RCU |
| `olc_mechanic.hpp` | Optimistic Lock Coupling | OLC |
| `rowex_mechanic.hpp` | Read-Optimized Write Exchange | ROWEX |

#### Decision-Trees (concepts/decision_trees/)

10 Decision-Tree-Familien (F-EXTRA-6):
- `allocator_rebalance_tree.hpp`
- `cache_coherence_detection_tree.hpp`
- `coherence_aware_write_decision_tree.hpp`
- `concurrency_discipline_switch_tree.hpp`
- `hot_path_recognition_tree.hpp`
- `page_relocation_tree.hpp`
- `page_type_change_tree.hpp`
- `prefetch_adjustment_tree.hpp`
- `sampling_rate_adjustment_tree.hpp`
- `value_handle_selection_tree.hpp`

#### Telemetry-Cluster (concepts/telemetry/)

| Header | Strategie | Achse 11 (Kuehn N-Phase) |
|---|---|---|
| `leaf_only_counter.hpp` | Leaf-Only | **11.X1 (Kuehn-Hauptvariante DA!)** |
| `leaf_only_sampled_counter.hpp` | Leaf-Only + Sampling | **11.X2 (Kuehn-Sampling DA!)** |
| `path_read_counter.hpp` | Path-Counter | (Achse 11 Default-Variante) |
| `per_node_counter.hpp` | Inner+Outer-Node | **11.X4 (ANTI-PATTERN DA!)** |
| `probability_hints_header.hpp` | Probabilistic-Hints | (Achse 11 Hilfs) |
| `retroactive_aggregation.hpp` | **11.X3 (Offline-Recompute DA!)** | **11.X3 (Kuehn)** |

**WICHTIG:** Achse 11 Kuehn-Erkenntnisse 11.X1-X4 sind tatsaechlich **schon im Code** als Concept-Header vorhanden! N.6 Doku-Update war korrekt — Code muss nicht neu sondern dokumentiert + benannt werden.

### §3.5 Allokator-Familien (concepts/allocators/families/)

Alle 23 Allokator-Familien (A01-A23) als Concept-Header. Quelle: docs/bausteine/02_allokator_matrix.md §10.

### §3.6 Reclamation (libs/cache_engine/reclamation/rcu_reclaim/)

Eigene RCU-Implementation (statt liburcu — Phase 6 #104). Achse 6.2 Reclamation-Policy.

### §3.7 Common (libs/common/)

| Sub-Verzeichnis | Inhalt | Achsen-Zuordnung |
|---|---|---|
| `serialization/xml_config_parser/` | XML-Profile-Parser | Achse Config-Loading (V19+) |
| `succinct/include/` | Eigene SDSL-Portierung (Phase 6 #105) | Hilfs-Lib fuer LOUDS |

### §3.8 Execution Engine (libs/execution_engine/include/comdare/)

V30.D.1 Migration aus `experiment/` → `libs/execution_engine/`. Wrapper um ProcessingStrategy.

### §3.9 Test-Infra (libs/test_infra/)

| Sub-Modul | Inhalt |
|---|---|
| `benchmark_suite/` | Mikrobenchmark-Framework (V180) |
| `test_data/` | YCSB-aehnliche Test-Daten-Helfer |
| `workload_generator/` | Workload-Generator (V181) |

---

## §4 Subsystem 4 — Pruefling-Adapter (adapters/)

22 V31-Adapter, alle als Stub-Skelette mit `COMDARE_HAVE_<X>` Schalter.

### §4.1 SOTA-Adapter (12)

| Adapter | Achse 1 PAGE-TYPE | Achse 12 HARDWARE | Status |
|---|---|---|---|
| P01-ART | NODE16/48/256 | AVX2 | Skelett |
| P02-HOT | COMPOUND_HOT | AVX2 (Bit-Vector) | Skelett |
| P03-Masstree | BPLUS_MASSTREE | scalar | Skelett |
| P04-CoCo-trie | MACRO_COCO | scalar (succinct) | Skelett (GPL-3) |
| P05-START | MULTIBYTE_START | AVX2 | Skelett |
| P06-B2tree | DECISION_B2TREE | scalar (BMI2) | Skelett (no-LICENSE, **ext/-Code in Forschungsarbeiten DA**) |
| P07-Wormhole | METATRIEHT_WORMHOLE | scalar | Skelett (GPL-2) |
| P10-SuRF | LOUDS_SPARSE_SURF | scalar | Skelett |
| P20-leanstore | ADAPTIVE_BTREESAREBACK | AVX2 (HBM) | Skelett |
| P25-Mahling | (Prefetch-Spec) | PREFETCH | Skelett |
| P29-RCU | (Concurrency) | atomic-load | Skelett |
| P30-HazardPointers | (Concurrency) | CAS + LL-SC | Skelett |

### §4.2 Allokator-Adapter (10)

A01-hoard, A03-michael-lockfree, A04-mimalloc, A05-jemalloc, A06-tcmalloc, A07-snmalloc, A08-scalloc, A10-rpmalloc, A11-lrmalloc, A20-dlmalloc — alle als Skelett-Wrapper mit `COMDARE_HAVE_<X>=OFF` Default.

### §4.3 V32+ geplant (T-Phase)

- T.1: P06-B2tree mit ext/-Verweis auf `Forschungsarbeiten/code/P06-B2tree/b2-tree-master`
- T.2: NEU P27-hp-soft (Wrapper fuer V31.K5+K6)
- T.3: NEU P28-DaMoN-LeafCounter (Wrapper fuer Achse 11.X1)
- T.4: NEU P06-B2tree/sub/{hattrie, bart_hybrid, pbtree_static}

---

## §5 M-Modell-Subsystem-Zuordnung

| Subsystem | Verzeichnis | Eigentumsverhaeltnis |
|---|---|---|
| **2 CacheEngineBuilder (autonom)** | `apps/cache_engine_builder/main.cpp` + `libs/cache_engine/builder/` | Executable + Builder-Modules |
| **3 CacheEngine (Werkzeug-Bibliothek)** | `libs/cache_engine/include/` + `libs/cache_engine/subsystems/` + `libs/execution_engine/` + `libs/common/` + `libs/test_infra/` | Library |
| **4 Pruefling-Adapter** | `adapters/` (22 Stueck, V32+ 28) | Stub-Wrapper |

---

## §6 N-Phase 14-Achsen-Abdeckung (CACHE-ENGINE Sicht)

| Achse | Header-Beleg im CE | Sub-Achsen-Beleg |
|---|---|---|
| 1 PAGE-TYPE | `concepts/disciplines/page_discipline.hpp` | implizit pro Adapter |
| 2 NODE-TYPE | `concepts/disciplines/node_discipline.hpp` | implizit pro Adapter |
| 3.A SearchAlgo-Traversal | `concepts/disciplines/path_discipline.hpp` | **N.5 Split noch nicht in CE-Header** |
| 3.B Cache-Memory-Traversal | `concepts/disciplines/array_discipline.hpp` | analog |
| 3.M Traversal-Mapping | (fehlt explizit) | **fehlt, muss NEU** |
| 4 VALUEHANDLE | `concepts/decision_trees/value_handle_selection_tree.hpp` | implizit |
| 5 MEMORY-LAYOUT | `concepts/decision_trees/page_relocation_tree.hpp` | implizit |
| 6.1 Allocation | `allocators/families/a*` | DA (23 Familien) |
| 6.2 Reclamation | `reclamation/rcu_reclaim/` + concepts/mechanics/comdare_rcu_mechanic | DA |
| 6.3 NUMA | (fehlt explizit) | **fehlt, muss NEU** |
| 6.4 HugePage | `allocators/portable_aligned_alloc.hpp` (Teil-Aspekt) | partiell |
| 6.5 FreeList | `allocators/concepts/i_allocation_strategy.hpp` | DA |
| 7 PREFETCH | `subsystems/c03_prefetch_engine/` + concepts | DA |
| 8.1 Concurrency-Pattern | `concepts/i_concurrency_discipline.hpp` + mechanics/* | DA (OLC + RCU + ROWEX) |
| 8.2 Locking-Mode | `concepts/disciplines/memory_*_discipline.hpp` | **N.2 Split implizit, muss explizit** |
| 9 ISA | (fehlt explizit als CE-Header) | **fehlt, ist Hardware-Probing-Output** |
| 10 MEASUREMENT | `measurement/in_memory_measurement_buffer.hpp` + `measure.hpp` | DA |
| 11 TELEMETRY | `concepts/telemetry/leaf_only_counter, *_sampled_counter, retroactive_aggregation` | **DA! Kuehn 11.X1+X2+X3 IM CODE, nur Doku-Mapping fehlt** |
| 12 HARDWARE-STRATEGY | (fehlt explizit) | **fehlt, ist NEUE Algorithmus-Achse, NICHT C09 Heuristik** |
| 13 SCHEDULING | `subsystems/c11_scheduler_engine/` + concepts/disciplines/simd_thread_discipline.hpp | DA (Sub-Achsen implizit, muss klargestellt werden) |

**Bilanz:** ~70% der N-Phase-Achsen sind im CE-Code abgedeckt. 4 Sub-Achsen fehlen explizit (3.M, 6.3, 9, 12).

---

## §7 V32+ Refactoring-Bedarf (Gap zu N-Phase)

1. `concepts/disciplines/path_discipline.hpp` → splitten in `search_algo_traversal.hpp` + `cache_memory_traversal.hpp` + `traversal_mapping.hpp` (N.5)
2. `concepts/disciplines/memory_*_discipline.hpp` → mit `LockingMode` Enum klar Achse 8.2 zuordnen (N.2)
3. NEU `concepts/hardware_strategy.hpp` als Algorithmus-Permutations-Achse 12 (NICHT C09 Heuristik!)
4. NEU `concepts/scheduling_strategy.hpp` mit Sub-Achsen 13.1-13.5 (V32+ N.4)
5. NEU `concepts/numa_affinity.hpp` als Achse 6.3
6. `concepts/permutation_flags.hpp` → 9 → 14 Banks (V32.2)
7. Telemetry-Kuehn-Mapping: `concepts/telemetry/per_node_counter.hpp` als 11.X4 ANTI-PATTERN markieren (Doku!)

---

## §8 Querverweise

- N-Phase Bausteine: `../bausteine/07_bausteine_matrix_N_erweitert.md`
- M-Modell Schichten: `../architektur/10_schichten_modell_M.md`
- Anti-Vermischung: `../architektur/11_axes_vs_strategies_disambiguation.md`
- V32 Refactoring-Plan: `../adapters/V32_CODE_REFACTORING_PLAN.md`
- O-Phase PRT-ART Spiegel: `../adapters/O_PHASE_PRT_ART_AXES_MIRROR.md` (Y.2 = prt-art Pendant)
- T-Phase Adapter: `../adapters/T_PHASE_ADAPTER_STATUS.md`

---

**Ende docs/uml_planning/Y1_cache_engine_ist_kartografie.md (Y.1 DONE).**
