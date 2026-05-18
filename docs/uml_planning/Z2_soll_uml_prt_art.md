# Z.2 — Soll-UML comdare-prt-art (Pruefling-Spiegel mit 14-Achsen-Module)

**Stand:** 2026-05-18 (Z.2)
**Vorgaenger:** `Y2_prt_art_ist_kartografie.md` + `../adapters/O_PHASE_PRT_ART_AXES_MIRROR.md`
**Konsequenz:** V32.1 Code-Refactoring der PrtArtSearchEngine

> Soll-UML fuer PRT-ART als Bausteine-Spiegel zur CacheEngine. Hybrid: Mermaid + drawio-Verweise.

---

## §1 PrtArtSearchEngine Template-Hierarchie (V32.1 Soll, 20+ Params)

```mermaid
classDiagram
    class PrtArtSearchEngine~Key, Value, ...20+ Params~ {
        <<Template>>
        +lookup(key: Key) : optional~Value~
        +insert(key: Key, value: Value) : Status
        +scan(begin: Key, end: Key) : Iterator
        +configure(baustein_set: BausteinSet) : Status
        -root_node_ : IPrtArtNode*
        -allocators_ : AllocStrategy
        -reclamation_ : ReclamationPolicy
        -telemetry_ : TelemetryStrategy
        -prefetcher_ : PrefetchStrategy
        -concurrency_ : ConcurrencyPattern
        -locking_ : LockingMode
        -hardware_ : HardwareStrategy
        -scheduling_ : SchedulingStrategy
        -cache_engine_ : CacheEngine* %% M.3 Richtung b
    }

    class PrtArtSearchEngineAdapter {
        <<implementiert IExecutingEngine + ISearchEngine~Key,Value~>>
        +execute(workload: Workload) : Status
        +configure(baustein_set) : Status
        +notify_lookup_start(key)
        +notify_lookup_complete(result)
        -engine_ : PrtArtSearchEngine~...~
        +get_engine() : PrtArtSearchEngine&
    }

    class IExecutingEngine {
        <<Concept ABI>>
    }

    class ISearchEngine~K,V~ {
        <<Concept ABI>>
    }

    IExecutingEngine <|.. PrtArtSearchEngineAdapter
    ISearchEngine <|.. PrtArtSearchEngineAdapter
    PrtArtSearchEngineAdapter "1" *-- "1" PrtArtSearchEngine : komponiert
```

---

## §2 IPrtArtNode-Familie (Achse 1+2)

```mermaid
classDiagram
    class IPrtArtNode {
        <<Concept>>
        +traverse(key_byte) : NodeRef
        +get_value_handle() : optional~ValueHandle~
        +is_terminal() : bool
    }

    class RedirectNode {
        <<Achse 1+2: Trie-Huelle>>
        +compressed_bytes_ : vector~byte~
        +value_handle_ : optional~ValueHandle~
        +next_node_ : optional~IPrtArtNode*~
        +match_prefix(key: KeyView) : MatchResult
        +is_terminal() : bool
    }

    class BPlusNode {
        <<Achse 1+2: PRT-ART eigenstaendig>>
        +current_search_type_ : SearchTypeKind
        +search_type_data_ : variant~Array256, Array65535, VectorU8U8, VectorU16U16~
        +density_ : double
        +lookup(byte_lookup) : LookupResult
        +insert(byte, next_node) : InsertResult
        +density() noexcept : double
        +transition_if_threshold_reached() : TransitionResult
    }

    IPrtArtNode <|-- RedirectNode
    IPrtArtNode <|-- BPlusNode
```

---

## §3 4 Suchtypen A/B/C/D (Achse 2 Sub-Permutation, K05b)

```mermaid
classDiagram
    class SearchTypeKind {
        <<Enum>>
        TypeA_Array256
        TypeB_Array65535
        TypeC_VectorU8U8
        TypeD_VectorU16U16
    }

    class Array256 {
        <<Suchtyp A: 1-Byte-Slot, 256 Felder>>
        +data : array~Slot, 256~
        +lookup(byte) : LookupResult
        +density() : double
    }

    class Array65535 {
        <<Suchtyp B: 2-Byte-Slot, 65535 Felder>>
        +data : array~Slot, 65535~
        +lookup(byte_pair) : LookupResult
    }

    class VectorU8U8 {
        <<Suchtyp C: Range-Scan tuple~u8,u8~>>
        +data : vector~tuple~uint8_t, Slot~~
        +scan(begin_byte, end_byte) : RangeResult
    }

    class VectorU16U16 {
        <<Suchtyp D: Range-Scan tuple~u16,u16~>>
        +data : vector~tuple~uint16_t, Slot~~
        +scan(begin_pair, end_pair) : RangeResult
    }

    BPlusNode --> SearchTypeKind
    BPlusNode --> Array256
    BPlusNode --> Array65535
    BPlusNode --> VectorU8U8
    BPlusNode --> VectorU16U16
```

---

## §4 4+2 Pool-Familie (Achse 6.1, K05e)

```mermaid
classDiagram
    class IPrtArtAllocator {
        <<Concept>>
        +allocate(pool_kind, size_hint) : VirtualOffset
        +deallocate(pool_kind, offset)
        +bucket_count(pool_kind) : size_t
    }

    class PoolDescriptor {
        +pool_kind_ : PoolKind
        +slot_size_ : size_t
        +bucket_size_ : size_t
        +reclamation_policy_ : ReclamationPolicy
    }

    class PoolKind {
        <<Enum>>
        PoolA  %% 256B Cache-Line/Page-Multiple, Fixed-Size-Slab
        PoolB  %% 64KB Pages, Fixed-Size-Slab
        PoolC  %% 4KB Variable-Vector
        PoolD  %% 64B Cache-Line, Variable-Size-Slab
        PoolR  %% Redirect-Knoten
        PoolV_Static  %% Static-Size Values
        PoolV_Dynamic  %% Dynamic-Size Values mit Signaling-Bits
    }

    class PoolRouter {
        +route(search_type, value_kind) : PoolKind
    }

    class PoolSet {
        +pools_ : array~Pool, 7~
        +get_pool(kind) : Pool&
    }

    IPrtArtAllocator <|.. PoolSet
    PoolSet --> PoolDescriptor
    PoolSet --> PoolKind
    PoolSet --> PoolRouter
```

---

## §5 Concurrency K05g (Achse 8.1 + 8.2)

```mermaid
classDiagram
    class IPrtArtConcurrencyManager {
        <<Concept Achse 8.1+8.2>>
        +reserve_value_block(writer_id, size) : VirtualOffset
        +lock_node_range(node_set, mode) : NodeLock
        +detect_conflict(write_set_a, write_set_b) : bool
        +resolve_conflict(strategy) : ResolutionResult
    }

    class OlcWithReservedBlocks {
        <<PRT-ART Default 8.1+8.2 KOMBINIERT>>
        +olc_ : OlcMechanic
        +reserved_blocks_ : ReservedBlockManager
        +lock_free_reader_path_ : LockFreeReader
        -lock_node_set : NodeSet
        -resolve_conflict : OlcRestart_or_Wait
    }

    class IConcurrencyPattern {
        <<Concept Achse 8.1>>
    }

    class ILockingMode {
        <<Concept Achse 8.2>>
    }

    IPrtArtConcurrencyManager <|.. OlcWithReservedBlocks
    OlcWithReservedBlocks ..> IConcurrencyPattern
    OlcWithReservedBlocks ..> ILockingMode
```

---

## §6 Prefetch (Achse 7) — Spiegel-Klassen + V31.K6 Reuse

```mermaid
classDiagram
    class IPrtArtPrefetcher {
        <<Concept Achse 7>>
        +prefetch(addr, distance_hint)
        +choose_level(distance_estimate) : PrefetchLevel
    }

    class DistanceEstimator {
        <<PRT-ART Neu-Impl>>
        +estimate(current_addr, target_node) : Distance
    }

    class PathOrientedPrefetch {
        <<PRT-ART Neu-Impl>>
        +prefetch_along_path(path: TraversalPath)
    }

    class RedirectPrefetch {
        <<PRT-ART Neu-Impl>>
        +prefetch_redirect_target(redirect_node)
    }

    class HierarchicalBundlePrefetcher {
        <<V31.K6 P27-hp-soft Reuse, license CC-BY>>
        +prefetch_l1(addr)
        +prefetch_l2(addr)
        +prefetch_l3(addr)
        +choose_level(distance) : PrefetchLevel
    }

    IPrtArtPrefetcher <|.. DistanceEstimator
    IPrtArtPrefetcher <|.. PathOrientedPrefetch
    IPrtArtPrefetcher <|.. RedirectPrefetch
    IPrtArtPrefetcher <|.. HierarchicalBundlePrefetcher
```

---

## §7 NEUE Spiegel-Module fuer fehlende Achsen (O.3 Soll-Implementation)

### §7.1 prt_art/hardware/ (Achse 12, V32 NEU)

```mermaid
classDiagram
    class PrtArtHardwareDefault {
        <<struct Achse 12 Default>>
        +simd : SimdFamily = AVX2
        +cache_level : CacheLevelTarget = L1Aware
        +numa : NumaStrategy = Local
        +prefetch_hw : PrefetchHwInstruction = Prefetch
        +atomic : AtomicFamily = CAS
    }

    class IHardwareStrategy {
        <<Concept Achse 12, in cache-engine: IHardwareStrategy>>
    }

    IHardwareStrategy <|.. PrtArtHardwareDefault
```

### §7.2 prt_art/scheduling/ (Achse 13, V32 NEU)

```mermaid
classDiagram
    class PrtArtSchedulingDefault {
        <<struct Achse 13 Default>>
        +worker_pool : WorkerPoolLayout = ThreadPerCore
        +simd_workers : size_t = 2
        +hetero_dispatch : HeteroCoreDispatch = HybridAware
        +co_routine : CoRoutineStrategy = Interleave
        +batch : BatchGranularity = MicroBatch
    }

    class ISchedulingStrategy {
        <<Concept Achse 13, in cache-engine>>
    }

    ISchedulingStrategy <|.. PrtArtSchedulingDefault
```

### §7.3 prt_art/traversal/ (Achse 3.B + 3.M, V32 NEU)

```mermaid
classDiagram
    class IAlgoTraversal {
        <<Concept Achse 3.A, schon vorhanden in internal_search/>>
    }

    class ICacheMemoryTraversal {
        <<Concept Achse 3.B, NEU>>
        +walk_cache_lines(addr, count)
    }

    class ITraversalMapping {
        <<Concept Achse 3.M, NEU>>
        +map_algo_step_to_cache_step(algo_step) : CacheStep
    }

    class VirtualOffsetCalculator {
        <<Aus memory_layout/virtual_offset_address.hpp, jetzt Achse 3.M>>
        +calculate(pool_kind, slot_id) : PhysicalAddress
    }

    ITraversalMapping <|.. VirtualOffsetCalculator
```

### §7.4 prt_art/telemetry/ (Achse 11, V32 NEU, Reuse CE)

```mermaid
classDiagram
    class IPrtArtTelemetryStrategy {
        <<Concept Achse 11, Reuse CE-Concept>>
    }

    class PrtArtLeafOnlyCounter {
        <<11.X1 PRT-ART Default - Reuse aus CE>>
        +cache_engine_counter_ : LeafOnlyCounter&
    }

    IPrtArtTelemetryStrategy <|.. PrtArtLeafOnlyCounter
```

---

## §8 Sequence-Diagramm: PrtArt-Lookup mit bidirektionaler CE-Service-Nutzung

```mermaid
sequenceDiagram
    participant Caller as Caller (CE Phase 6)
    participant PA as PrtArtSearchEngineAdapter
    participant PRT as PrtArtSearchEngine
    participant Node as IPrtArtNode (Root)
    participant CE as CacheEngine (via cache_engine_)

    Caller->>PA: execute(workload)
    activate PA
    PA->>PRT: lookup("hallo")
    activate PRT

    PRT->>Node: traverse('h')
    Node-->>PRT: RedirectNode "hal"

    Note over PRT,CE: M.3 Richtung b: PrtArt nutzt CE-Services
    PRT->>CE: get_telemetry_strategy()
    CE-->>PRT: LeafOnlyCounter& (Kuehn 11.X1)
    PRT->>PRT: telemetry.notify_node_access(...)

    PRT->>CE: get_prefetch_strategy()
    CE-->>PRT: HierarchicalBundlePrefetcher& (V31.K6)
    PRT->>PRT: prefetcher.prefetch_l2(next_node_addr)

    Note over PRT: Traversiere weiter durch BPlusNode (Suchtyp A/B/C/D)
    PRT->>Node: traverse('l')
    Node-->>PRT: BPlusNode (Suchtyp A: Array256)
    PRT->>PRT: BPlusNode.lookup_byte('o') -> Slot mit ValueHandle

    PRT-->>PA: optional~Value~ = "hallo-payload"
    deactivate PRT
    PA-->>Caller: PermutationResult{value, latency, cache_misses}
    deactivate PA
```

---

## §9 V32+ Refactoring-Klassen-Map (Pendant zu O.6)

| Existierende V31-Klasse | V32-Refactoring | Status |
|---|---|---|
| `prt_art_search_engine.hpp` (12 Template-Params) | + 8 NEUE Template-Params (auf 20+) | V32.1 |
| `memory_layout/virtual_offset_address.hpp` | → `traversal/traversal_mapping.hpp` | O.3 |
| `internal_search/array_*.hpp` + `vector_*.hpp` | → `traversal/search_algo_traversal.hpp` (Reorganisation) | O.3 |
| (FEHLT) | NEU `traversal/cache_memory_traversal.hpp` | O.3 |
| (FEHLT) | NEU `hardware/prt_art_hardware_strategy.hpp` + Sub-Achsen | O.3 |
| (FEHLT) | NEU `scheduling/prt_art_scheduling_strategy.hpp` + Sub-Achsen | O.3 |
| (FEHLT) | NEU `telemetry/prt_art_telemetry_strategy.hpp` (Reuse CE) | O.3 |
| (FEHLT) | NEU `isa/isa_features.hpp` | O.3 |
| (FEHLT) | NEU `allocator/reclamation_policy.hpp` + `numa_affinity.hpp` + `huge_page_policy.hpp` | O.3 |

---

## §10 drawio-Tab-Vorschlaege fuer Z.2 (analog Z.1 §10)

| drawio-Tab-Vorschlag | Inhalt |
|---|---|
| `Z2-PrtArt-Template-20-Params` | PrtArtSearchEngine V32.1 mit 20+ Template-Params + Default-Variants |
| `Z2-IPrtArtNode-Familie` | RedirectNode + BPlusNode (4 Suchtypen) Detail |
| `Z2-4plus2-Pool-Familie` | PoolRouter + 7 Pools mit Routing |
| `Z2-PRT-ART-Concurrency-K05g` | OlcWithReservedBlocks + 3 Mechaniken |
| `Z2-PRT-ART-Achsen-Spiegel` | Pro Achse 1-14 die PRT-ART-Klasse(n) |

---

## §11 Querverweise

- Y.2 Ist-Kartografie prt-art: `Y2_prt_art_ist_kartografie.md`
- O-Phase PRT-ART-Spiegel: `../adapters/O_PHASE_PRT_ART_AXES_MIRROR.md`
- V32 Code-Refactoring (V32.1 Template): `../adapters/V32_CODE_REFACTORING_PLAN.md` §1
- Z.1 cache-engine-Pendant: `Z1_soll_uml_cache_engine.md`

---

**Ende docs/uml_planning/Z2_soll_uml_prt_art.md (Z.2 DONE).**
