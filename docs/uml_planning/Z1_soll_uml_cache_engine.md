# Z.1 — Soll-UML comdare-cache-engine (Master)

> ⚠️ **SUPERSEDED (2026-05-31):** Überholter Planungs-/Architektur-Stand (axis-zentrische Restruktur F.2, Plugin-Prüfling-Modell, DLL-F15-Pipeline, sezierte Organe). IST-treue Single-Source-of-Truth: `comdare-cache-engine/docs/ledger-sections/architektur-ziele-offene-punkte-ledger.md` + `…/20260531-e2e-abnahme-audit-und-entscheidungen.md`. Niemals löschen — nur Banner.

**Stand:** 2026-05-18 (Z.1)
**Vorgaenger:** `Y1_cache_engine_ist_kartografie.md` (Ist-Bestandsaufnahme)
**Konsequenz:** V32+ Code-Refactoring nach diesen Klassendiagrammen

> Soll-UML fuer cache-engine. Hybrid-Format: Mermaid inline (Klassen-Hierarchien + Sequence-Diagramme) + Verweise auf drawio-Tabs (komplexe Klassendiagramme via Phase P-Erweiterungen).

---

## §1 Master-Klassen-Diagramm CacheEngine + Builder + ABI

```mermaid
classDiagram
    %% Subsystem 2: CacheEngineBuilder (autonom)
    class CacheEngineBuilder {
        <<Executable>>
        +build(config_xml: XmlConfig)
        +enumerate_permutations() : list~PermutationDescriptor~
        +start_experiment_loop()
        +collect_results() : MeasurementBuffer&
        -permutation_engine_ : IPermutationEngine&
        -cache_engine_ : ICacheEngine&
        -platform_probe_ : IPlatformProbe&
    }

    class IPlatformProbe {
        <<Concept>>
        +discover() : PlatformSnapshot
        +get_topology() : ICacheTopology
    }

    %% Subsystem 3: CacheEngine (Werkzeug)
    class ICacheEngine {
        <<Concept>>
        +register_engine(engine: IExecutingEngine&)
        +execute_permutation(desc: PermutationDescriptor)
        +get_telemetry_strategy() : ITelemetryStrategy&
        +get_prefetch_strategy() : IPrefetchStrategy&
        +get_heuristic_for(kind: HeuristicKind) : IHeuristic&
        +get_scheduler() : IScheduler&  %% NEU V32 Achse 13
        +get_hardware_strategy() : IHardwareStrategy&  %% NEU V32 Achse 12
    }

    class CacheEngine {
        +sub_engines_: array~ISubEngine, 12~
        +observer_registry_: ObserverRegistry
        +concurrency_manager_: ConcurrencyManager
        +cache_hierarchy_manager_: CacheHierarchyManager
    }

    %% Subsystem 4: Pruefling-Adapter
    class IExecutingEngine {
        <<Concept>>
        +execute(workload: Workload) : Status
        +configure(baustein_set: BausteinSet) : Status
        +notify_lookup_start(key: Key)
        +notify_lookup_complete(result: Result)
    }

    class ISearchEngine~Key, Value~ {
        <<Concept>>
        +lookup(key: Key) : optional~Value~
        +insert(key: Key, value: Value) : Status
        +scan(begin: Key, end: Key) : Iterator
    }

    CacheEngineBuilder --> ICacheEngine : verwendet als Werkzeug
    CacheEngineBuilder --> IPlatformProbe : verwendet (Phase 1)
    ICacheEngine <|.. CacheEngine
    ICacheEngine ..> IExecutingEngine : registriert (Phase 5)
    ISearchEngine ..> ICacheEngine : nutzt CE-Services (Phase 6, M.3 Richtung b)
    IExecutingEngine <|.. ISearchEngine
```

---

## §2 12 Sub-Engines C01-C12 — Klassen-Hierarchie

```mermaid
classDiagram
    class ISubEngine {
        <<Concept>>
        +sub_engine_kind() : SubEngineKind
        +configure(perm: PermutationFlags)
        +reset()
    }

    class C01_CostEngine {
        +estimate_layout_cost(layout: ILayout) : Cost
    }
    class C02_PinningEngine {
        +pin_thread(thread_id, core_id)
        +get_numa_node(core_id) : NumaNode
    }
    class C03_PrefetchEngine {
        +prefetch_l1(addr)
        +prefetch_l2(addr)
        +prefetch_l3(addr)
        +get_hierarchical_bundle() : HierarchicalBundlePrefetcher&
    }
    class C04_CoherenceEngine {
        +detect_false_sharing(cache_line_id) : bool
        +recommend_write_strategy() : WriteStrategy
    }
    class C05_TelemetryEngine {
        +get_leaf_only_counter() : LeafOnlyCounter&
        +get_sampled_counter() : LeafOnlySampledCounter&
        +get_retroactive_aggregator() : RetroactiveAggregator&
        +get_per_node_counter_legacy() : PerNodeCounter&  %% Achse 11.X4 ANTI-PATTERN
    }
    class C06_AllocationEngine {
        +get_allocator(strategy: AllocStrategy) : IAllocator&
        +get_pool(pool_kind: PoolKind) : IPool&
    }
    class C07_MigrationEngine {
        +migrate_page(from, to)
    }
    class C08_EncodingEngine {
        +get_louds_encoder() : ILoudsEncoder&
        +get_succinct_encoder() : ISuccinctEncoder&
    }
    class C09_HeuristikEngine {
        +recommend(context) : Recommendation
        +get_hardware_probe() : C8_HardwareProbing&  %% NICHT identisch mit Achse 12!
    }
    class C10_TopologieEngine {
        +get_cache_topology() : ICacheTopology&
        +get_cpu_layout() : ICoreLayout&
    }
    class C11_SchedulerEngine {
        +get_worker_pool() : IWorkerPool&
        +get_simd_worker_count_limit() : size_t  %% Hardware-Limit, typ. 2 von N
    }
    class C12_FilterEngine {
        +get_bloom_filter() : BloomFilter&
        +get_surf_filter() : SurfFilter&
    }

    ISubEngine <|-- C01_CostEngine
    ISubEngine <|-- C02_PinningEngine
    ISubEngine <|-- C03_PrefetchEngine
    ISubEngine <|-- C04_CoherenceEngine
    ISubEngine <|-- C05_TelemetryEngine
    ISubEngine <|-- C06_AllocationEngine
    ISubEngine <|-- C07_MigrationEngine
    ISubEngine <|-- C08_EncodingEngine
    ISubEngine <|-- C09_HeuristikEngine
    ISubEngine <|-- C10_TopologieEngine
    ISubEngine <|-- C11_SchedulerEngine
    ISubEngine <|-- C12_FilterEngine
```

---

## §3 PermutationFlags V32.2 — 14 Banks Struct

```mermaid
classDiagram
    class PermutationFlags {
        <<Struct 82-bit Bitfield>>
        +page_bank : uint8_t (8 bit)
        +node_bank : uint8_t (5 bit)
        +traversal_3a : uint8_t (3 bit)
        +traversal_3b : uint8_t (3 bit)
        +traversal_3m : uint8_t (2 bit)
        +value_handle_bank : uint8_t (3 bit)
        +memory_layout_bank : uint8_t (3 bit)
        +allocator_6_1 : uint8_t (3 bit)
        +allocator_6_2 : uint8_t (2 bit)
        +allocator_6_3 : uint8_t (2 bit)
        +allocator_6_4 : uint8_t (2 bit)
        +allocator_6_5 : uint8_t (2 bit)
        +prefetch_bank : uint8_t (3 bit)
        +concurrency_8_1 : uint8_t (3 bit)
        +concurrency_8_2 : uint8_t (2 bit)
        +isa_bank : uint8_t (4 bit)
        +measurement_bank : uint8_t (4 bit)
        +telemetry_bank : uint8_t (3 bit)
        +hw_12_1 : uint8_t (3 bit)
        +hw_12_2 : uint8_t (2 bit)
        +hw_12_3 : uint8_t (2 bit)
        +hw_12_4 : uint8_t (2 bit)
        +hw_12_5 : uint8_t (2 bit)
        +sched_13_1 : uint8_t (3 bit)
        +sched_13_2 : uint8_t (3 bit)
        +sched_13_3 : uint8_t (2 bit)
        +sched_13_4 : uint8_t (2 bit)
        +sched_13_5 : uint8_t (2 bit)
        +engine_choice_bank : uint8_t (2 bit)
        +to_uint128() : __uint128_t
        +from_uint128(id: __uint128_t)$ : PermutationFlags
    }
```

---

## §4 Telemetry Achse 11 — Kuehn-Strategien V32 Doku-Mapping

```mermaid
classDiagram
    class ITelemetryStrategy {
        <<Concept Achse 11>>
        +notify_node_access(node_id)
        +notify_leaf_access(leaf_id)
        +offline_recompute()
    }

    class LeafOnlyCounter {
        <<Achse 11.X1 KUEHN HAUPTVARIANTE>>
        +notify_leaf_access(leaf_id)
        +get_count(leaf_id) : uint64_t
        -counter_per_leaf_ : map~LeafId, atomic_u64~
    }

    class LeafOnlySampledCounter {
        <<Achse 11.X2 KUEHN SAMPLING>>
        +notify_leaf_access(leaf_id)
        -sample_every_n_ : size_t = 1000
    }

    class RetroactiveAggregator {
        <<Achse 11.X3 KUEHN OFFLINE-RECOMPUTE>>
        +offline_recompute()
        +aggregate_bottom_up(tree: Tree&)
    }

    class PerNodeCounter {
        <<Achse 11.X4 ANTI-PATTERN Cache-Line-Ping-Pong>>
        +notify_node_access(node_id)
        -counter_per_node_ : map~NodeId, atomic_u64~
    }

    ITelemetryStrategy <|.. LeafOnlyCounter
    ITelemetryStrategy <|.. LeafOnlySampledCounter
    ITelemetryStrategy <|.. RetroactiveAggregator
    ITelemetryStrategy <|.. PerNodeCounter
```

---

## §5 Hardware-Strategy (NEU Achse 12, V32 + O.3)

```mermaid
classDiagram
    class IHardwareStrategy {
        <<Concept Achse 12 NEU>>
        +get_simd_family() : SimdFamily
        +get_cache_level_target() : CacheLevelTarget
        +get_numa_strategy() : NumaStrategy
        +get_prefetch_hw() : PrefetchHwInstruction
        +get_atomic_family() : AtomicFamily
    }

    class SimdFamily {
        <<Enum 12.1>>
        Scalar
        AVX2
        AVX512
        NEON
        SVE2
    }

    class CacheLevelTarget {
        <<Enum 12.2>>
        L1Aware
        L2Aware
        L3Aware
        HBMAware
    }

    class NumaStrategy {
        <<Enum 12.3>>
        Local
        Interleave
        Preferred
        Bind
        None
    }

    class PrefetchHwInstruction {
        <<Enum 12.4>>
        None
        Prefetch
        PrefetchNta
        PrefetchW
    }

    class AtomicFamily {
        <<Enum 12.5>>
        None
        CAS
        LLSC
        RmwExtended
    }

    IHardwareStrategy ..> SimdFamily
    IHardwareStrategy ..> CacheLevelTarget
    IHardwareStrategy ..> NumaStrategy
    IHardwareStrategy ..> PrefetchHwInstruction
    IHardwareStrategy ..> AtomicFamily
```

---

## §6 Scheduling-Strategy (NEU Achse 13, V32 + O.3)

```mermaid
classDiagram
    class ISchedulingStrategy {
        <<Concept Achse 13 NEU>>
        +get_worker_pool_layout() : WorkerPoolLayout
        +get_simd_worker_count_limit() : size_t
        +get_hetero_core_dispatch() : HeteroCoreDispatch
        +get_co_routine_strategy() : CoRoutineStrategy
        +get_batch_granularity() : BatchGranularity
    }

    class WorkerPoolLayout {
        <<Enum 13.1>>
        ThreadPerCore
        WorkStealing
        CpuPinning
        FreePool
    }

    class IScheduler {
        +submit_simd_task(task) : Future
        +submit_scalar_task(task) : Future
        -simd_worker_count_ : size_t  %% Hardware-Limit, typ. 2 von N
        -scalar_worker_count_ : size_t  %% kein Limit
    }

    ISchedulingStrategy ..> WorkerPoolLayout
    IScheduler ..> ISchedulingStrategy
```

---

## §7 Sequence-Diagramm: Phasen 1-7 Pipeline (Master)

```mermaid
sequenceDiagram
    participant MD as messung_driver (Sub-1)
    participant CEB as CacheEngineBuilder (Sub-2)
    participant CE as CacheEngine (Sub-3)
    participant PA as PrtArt-Adapter (Sub-4)

    MD->>CEB: build(config_a.xml, mode=defined)
    activate CEB

    CEB->>CE: get_platform_probe()
    CE-->>CEB: IPlatformProbe&
    CEB->>CE: Phase 1 DISCOVER (IPlatformProbe.discover())
    CE-->>CEB: PlatformSnapshot

    CEB->>CE: Phase 2 MEASURE (Mikrobenchmarks)
    CE-->>CEB: PlatformPropertySet

    CEB->>CE: Phase 3 CLASSIFY
    CEB->>CE: Phase 4 PUBLISH (ICacheEngineOptionPublisher)

    loop pro Permutation
        CEB->>CE: Phase 5 BIND (register_engine(PA))
        CE->>PA: configure(baustein_set)

        CEB->>CE: Phase 6 EXECUTE (execute(workload))
        CE->>PA: execute(workload)
        activate PA

        loop pro Lookup im Workload
            PA->>CE: get_telemetry_strategy()  %% M.3 (b)
            CE-->>PA: ITelemetryStrategy&
            PA->>CE: get_prefetch_strategy()  %% M.3 (b)
            CE-->>PA: IPrefetchStrategy&
            PA->>PA: lookup(key)
            PA->>CE: notify_lookup_complete()
        end

        PA-->>CE: PermutationResult
        deactivate PA
        CE-->>CEB: PermutationResult
        CEB->>CEB: ResultAggregator.collect(result)
    end

    CEB->>CEB: Phase 7 COMPARE (aggregation)
    CEB-->>MD: MeasurementBuffer
    deactivate CEB

    MD->>MD: binary_to_csv -> csv_to_latex -> diagram_generator
```

---

## §8 V32+ Sequence-Diagramm: register_engine + bidirektionale Calls (M.3)

```mermaid
sequenceDiagram
    participant MD as messung_driver
    participant CEB as CacheEngineBuilder
    participant CE as CacheEngine
    participant Reg as engine_registry_
    participant PA as PrtArtAdapter
    participant PrtArt as PrtArtSearchEngine

    Note over MD,PrtArt: Phase 5 BIND - CE registriert PrtArt (Richtung a)
    MD->>CEB: build(config)
    CEB->>CE: register_engine(prt_art_adapter)
    CE->>Reg: registered_engines_.push_back(&prt_art_adapter)
    Reg-->>CE: OK

    Note over MD,PrtArt: Phase 6 EXECUTE - PrtArt nutzt CE-Services (Richtung b)
    CEB->>CE: execute_permutation(desc)
    CE->>PA: execute(workload)
    PA->>PrtArt: PrtArtSearchEngine.lookup(key) [pro Element]

    activate PrtArt
    PrtArt->>CE: get_telemetry_strategy() [Achse 11]
    CE-->>PrtArt: LeafOnlyCounter& [Kuehn-Hauptvariante]
    PrtArt->>PrtArt: telemetry.notify_leaf_access(leaf_id)

    PrtArt->>CE: get_prefetch_strategy() [Achse 7]
    CE-->>PrtArt: HierarchicalBundlePrefetcher& [V31.K6]
    PrtArt->>PrtArt: prefetcher.prefetch_l2(addr)

    PrtArt->>CE: get_heuristic_for(HotPath) [C09]
    CE-->>PrtArt: IHeuristic&
    PrtArt->>PrtArt: heuristic.recommend(LiveModel)

    PrtArt-->>PA: optional~Value~
    deactivate PrtArt

    PA-->>CE: PermutationResult
```

---

## §9 V32 Refactoring-Klassen-Map

| Existierende V31-Klasse | V32-Refactoring | Sub-Achse |
|---|---|---|
| `permutation_flags.hpp` (9 Banks) | + 5 NEUE Banks (12 HW, 13 Sched, 14 EngineChoice) + 3 Splits (3.A/B/M, 6.1-5, 8.1+2) | Achse 12+13 |
| `i_telemetry_strategy.hpp` | + 4 Doxygen-Marker fuer Kuehn 11.X1-X4 (Klasse existiert!) | Achse 11 |
| `concepts/disciplines/path_discipline.hpp` | splitten in `search_algo_traversal.hpp` + `cache_memory_traversal.hpp` + `traversal_mapping.hpp` | Achse 3 |
| NEU `concepts/hardware_strategy.hpp` | + 5 Sub-Achsen-Enum + Default-Variant | Achse 12 |
| NEU `concepts/scheduling_strategy.hpp` | + 5 Sub-Achsen-Enum + IScheduler-API | Achse 13 |
| NEU `concepts/numa_affinity.hpp` | + Enum + IAllocator-Hook | Achse 6.3 |
| `allocators/concepts/locking_concept.hpp` | + `LockingMode` Enum explizit | Achse 8.2 |

---

## §10 drawio-Tab-Vorschlaege fuer Z.1 (P.4-Erweiterung)

Pro Hauptklassen-Gruppe ein neuer drawio-Tab (komplexe Klassen-Beziehungen, die Mermaid-Beschraenkungen ueberschreiten):

| drawio-Tab-Vorschlag | Inhalt |
|---|---|
| `Z1-CE-Master-Klassen` | CacheEngine + 12 Sub-Engines + ABI |
| `Z1-PermutationFlags-V32-Bitfield` | 14-Banks-Bitfield-Layout grafisch |
| `Z1-Telemetry-Achse11-Hierarchie` | ITelemetryStrategy + 4 Kuehn-Strategien |
| `Z1-Hardware-Strategy-NEU` | IHardwareStrategy + 5 Sub-Achsen-Enums |
| `Z1-Scheduling-Strategy-NEU` | ISchedulingStrategy + IScheduler |
| `Z1-Pipeline-Phasen-1-7-Detail` | CEB + CE + PA Subsystem-Trennung pro Phase |

---

## §11 Querverweise

- Y.1 Ist-Kartografie cache-engine: `Y1_cache_engine_ist_kartografie.md`
- O-Phase PRT-ART-Spiegel: `../adapters/O_PHASE_PRT_ART_AXES_MIRROR.md`
- V32 Code-Refactoring-Plan: `../adapters/V32_CODE_REFACTORING_PLAN.md`
- M-Modell: `../architektur/10_schichten_modell_M.md`
- Anti-Vermischung: `../architektur/11_axes_vs_strategies_disambiguation.md`
- Bausteine 14 Achsen: `../bausteine/07_bausteine_matrix_N_erweitert.md`

---

**Ende docs/uml_planning/Z1_soll_uml_cache_engine.md (Z.1 DONE).**
