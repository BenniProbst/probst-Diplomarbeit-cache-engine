# Bausteine — P4B Detail-Klassen (Q.3)

**Stand:** 2026-05-21 (Q.3 unter V33-Architektur-Bezug)
**Trigger:** User-Direktive 2026-05-21 — Q-Phase implementieren
**Vorgaenger-Doku:** `07_bausteine_matrix_N_erweitert.md` (14-Achsen-Erweiterung)
**Bezug zu V33:** Spiegelt die Struktur von `cache_engine/builder/commands/axis_library_registry.hpp` (28 Achsen-Eintraege)

---

## §0 Pflicht-Pre-Read

Diese Doku ist **synchron gehalten** mit dem Code in:
- `comdare-cache-engine/libs/cache_engine/builder/commands/axis_library_registry.hpp`
- `comdare-prt-art/prt_art/include/prt_art/default_lookup/default_lookup_registry.hpp`

Aenderungen hier → entsprechende Code-Updates in AxisLibraryRegistry.

---

## §1 P4B-1 PAGE-TYPE Detail-Klassen (Achse 1)

26 Bausteine aus Bausteine_Matrix.txt. Concept-Header-Stub:

```cpp
// libs/cache_engine/include/cache_engine/concepts/page_type.hpp (geplant V34)
namespace comdare::cache_engine::concepts::page {

template<class T>
concept IsPageType = requires(T page, std::byte* slot, std::size_t key) {
    { page.lookup_slot(key) } -> std::convertible_to<std::byte*>;
    { page.insert_slot(key, slot) } -> std::convertible_to<bool>;
    { page.fanout() } -> std::convertible_to<std::size_t>;
    { page.cache_line_size_bytes() } -> std::convertible_to<std::size_t>;
};

}  // namespace comdare::cache_engine::concepts::page
```

**Detail-Klassen (Auswahl, mindestens 3):**

| Klasse | Quelle | Notes |
|---|---|---|
| `PageDenseByteART256` | P01 ART | Dense byte array, 256 slots |
| `PageCompoundHOT` | P02 HOT | Compound node mit discriminative bits |
| `PageMultibyteSTART` | P05 START | Multibyte spans |
| `PageLOUDSDenseSuRF` | P10 SuRF | LOUDS encoding, dense |
| `PageDecisionB2Tree` | P06 B²-Tree | Decision tree pages |

**V33-Verankerung:** Pro Klasse ein `AxisVariant{"1", "<Klasse>", "<ce_library_path>"}` in `AxisLibraryRegistry::lookup("1")`.

---

## §2 P4B-2 NODE-TYPE Detail-Klassen (Achse 2)

13 Bausteine. Concept:

```cpp
namespace comdare::cache_engine::concepts::node {

template<class T>
concept IsNodeType = requires(T node, std::byte key) {
    typename T::value_type;
    { node.find_child(key) } -> std::convertible_to<T*>;
    { node.is_leaf() } -> std::convertible_to<bool>;
    { node.height_in_tree() } -> std::convertible_to<std::uint8_t>;
};

}
```

**Detail-Klassen:** `ART_Node4` / `ART_Node16` / `ART_Node48` / `ART_Node256`, `HOT_Compound_K32`, `Masstree_Internal` / `Masstree_Border`, `B2Tree_Decision` / `B2Tree_Span`.

---

## §3 P4B-3 TRAVERSAL Detail-Klassen (Achse 3 — V33 SPLIT 3.A/3.B/3.M)

### §3.A Algorithm-Seite (3.A)

```cpp
namespace comdare::cache_engine::concepts::traversal {

template<class T>
concept IsAlgorithmTraversal = requires(T traverser, std::byte* node, std::size_t depth) {
    { traverser.next_byte(node, depth) } -> std::convertible_to<std::byte*>;
    { traverser.max_depth_seen() } -> std::convertible_to<std::size_t>;
};

}
```

**Detail-Klassen 3.A:** `ByteByByte` (P01), `DiscriminativeBits` (P02), `LayerSlice` (P03), `MacroNode` (P04), `MultibyteSpan` (P05), `EmbeddedDecTree` (P06), `BPlusBinarySearch` (P12).

### §3.B Cache-Seite (3.B)

```cpp
template<class T>
concept IsCacheTraversal = requires(T traverser, std::byte* node) {
    { traverser.prefetch_next(node) } -> std::same_as<void>;
    { traverser.cache_lines_touched() } -> std::convertible_to<std::uint64_t>;
};
```

**Detail-Klassen 3.B:** `CacheLineLinear`, `PrefetchPipelined` (P21 Chen), `OffsetBasedJump` (PRT-ART default-lookup).

### §3.M Mapping-Schicht (3.M Virtual-Offset-Calculator)

```cpp
template<class T>
concept IsMappingCalculator = requires(T calc, std::uint64_t logical_offset) {
    { calc.physical_addr(logical_offset) } -> std::convertible_to<std::byte*>;
    { calc.alignment_bytes() } -> std::convertible_to<std::size_t>;
};
```

**Detail-Klassen 3.M:** `DirectIndex`, `VirtualOffsetCalc` (PRT-ART), `HashedSlot`.

---

## §4 P4B-4 ALLOCATOR Detail-Klassen (Achse 6 — V33 SPLIT 6.1-6.5)

### §4.1 Allocator-Family (6.1)

```cpp
namespace comdare::cache_engine::concepts::allocator {

template<class T>
concept IsAllocator = requires(T alloc, std::size_t bytes) {
    { alloc.allocate(bytes) } -> std::convertible_to<void*>;
    { alloc.deallocate(std::declval<void*>(), bytes) } -> std::same_as<void>;
    { alloc.fragmentation_ratio() } -> std::convertible_to<double>;
};

}
```

**Detail-Klassen 6.1:** Pro Allokator A01-A20 ein Concept-Wrapper (Hoard, mimalloc, jemalloc, tcmalloc, snmalloc, scalloc, rpmalloc, lrmalloc, dlmalloc, MichaelLockfree).

### §4.2 Reclamation-Policy (6.2)

```cpp
template<class T>
concept IsReclamationPolicy = requires(T policy, void* ptr) {
    { policy.defer_free(ptr) } -> std::same_as<void>;
    { policy.try_reclaim() } -> std::convertible_to<std::size_t>;  // returns bytes reclaimed
};
```

**Detail-Klassen 6.2:** `EpochBased`, `RCU`, `HazardPointer` (P30), `QSBR`.

### §4.3 NUMA-Affinity (6.3)

```cpp
template<class T>
concept IsNumaAffinity = requires(T policy, int node_id) {
    { policy.preferred_node() } -> std::convertible_to<int>;
    { policy.bind_to_node(node_id) } -> std::convertible_to<bool>;
};
```

**Detail-Klassen 6.3:** `Local`, `Interleave`, `Preferred`, `Bind`.

### §4.4 Huge-Page (6.4) + Pool-Count (6.5)

Analog 6.3, mit `IsHugePageStrategy` (Detail: `NoHugePages`, `Transparent2MB`, `Explicit2MB`, `Explicit1GB`) und `IsPoolStrategy` (Detail: `SinglePool`, `PrtArt_4Plus2`, `ThreadLocal`, `PerCorePool`).

---

## §5 P4B-5 CONCURRENCY Detail-Klassen (Achse 8 — V33 SPLIT 8.1/8.2)

### §5.1 Concurrency-Pattern (8.1)

```cpp
namespace comdare::cache_engine::concepts::concurrency {

template<class T>
concept IsConcurrencyPattern = requires(T pattern) {
    { pattern.acquire_read() } -> std::convertible_to<bool>;
    { pattern.acquire_write() } -> std::convertible_to<bool>;
    { pattern.release() } -> std::same_as<void>;
};

}
```

**Detail-Klassen 8.1:** `OptimisticLockCoupling` (P08), `MultiReaderSingleWriter`, `ReadWriteLock`, `LockFreeCAS`, `Snapshot`, `SingleThreaded`, `Transactional`.

### §5.2 Locking-Mode (8.2)

```cpp
template<class T>
concept IsLockingMode = requires(T mode) {
    { mode.is_blocking() } -> std::convertible_to<bool>;
    { mode.is_wait_free() } -> std::convertible_to<bool>;
};
```

**Detail-Klassen 8.2:** `Optimistic`, `Pessimistic`, `LockFree`, `WaitFree`.

---

## §6 P4B-6 TELEMETRY Detail-Klassen (Achse 11 — Kuehn V33)

```cpp
namespace comdare::cache_engine::concepts::telemetry {

template<class T>
concept IsTelemetryStrategy = requires(T tel, void* node) {
    { tel.record_access(node) } -> std::same_as<void>;
    { tel.access_count(node) } -> std::convertible_to<std::uint64_t>;
    { tel.cache_pressure() } -> std::convertible_to<double>;
};

}
```

**Detail-Klassen 11 (Kuehn-validierte, siehe `Forschungsarbeiten/code/P28-Kuehn-DAMON/`):**

| Klasse | Beschreibung | Anti-Pattern? |
|---|---|---|
| `LeafOnlyCounter` (11.X1) | Counter NUR in Blatt-Knoten | NEIN — Kuehn-Hauptvariante |
| `LeafOnlySampledCounter` (11.X2) | jeder n-te Zugriff im Blatt | NEIN — erweitert |
| `RetroactiveAggregator` (11.X3) | bottom-up Aufsummierung vor Reordering | NEIN — Standard |
| `PathReadCounter` (11.X3b) | Counter entlang Read-Pfaden | NEIN — Hybrid |
| `PerNodeCounter` (11.X4) | Counter in ALLEN Knoten | **JA — ANTI-PATTERN** (Cache-Line-Ping-Pong) |

---

## §7 P4B-7 NEU HARDWARE-STRATEGY Detail-Klassen (Achse 12)

**V33-NEU.** Concept:

```cpp
namespace comdare::cache_engine::concepts::hardware {

template<class T>
concept IsHardwareStrategy = requires(T hw) {
    { hw.simd_family() } -> std::convertible_to<SimdFamily>;  // Scalar/AVX2/AVX512/NEON/SVE2
    { hw.cache_level_target() } -> std::convertible_to<CacheLevelTarget>;
    { hw.numa_strategy() } -> std::convertible_to<NumaStrategy>;
    { hw.prefetch_distance_cl() } -> std::convertible_to<std::uint8_t>;
    { hw.atomic_granularity_bits() } -> std::convertible_to<std::uint8_t>;
};

}
```

**Detail-Klassen 12 (5 Sub-Achsen):**

| Sub-Achse | Klassen |
|---|---|
| 12.1 SIMD-Family | `Scalar`, `AVX2`, `AVX512`, `NEON`, `SVE2` |
| 12.2 Cache-Level | `L1Aware`, `L2Aware`, `L3Aware`, `HBMAware` |
| 12.3 NUMA-Strategy | `Local`, `Interleave`, `Preferred`, `Bind` |
| 12.4 Prefetch-Distance | `NoPrefetch`, `PrefetchT0`, `PrefetchT1`, `PrefetchT2`, `PrefetchNTA` |
| 12.5 Atomic-Granularity | `CAS_64`, `CAS_128`, `LL_SC`, `Relaxed_Ordering` |

---

## §8 P4B-8 NEU SCHEDULING-STRATEGY Detail-Klassen (Achse 13)

**V33-NEU.** Concept:

```cpp
namespace comdare::cache_engine::concepts::scheduling {

template<class T>
concept IsSchedulingStrategy = requires(T sched) {
    { sched.worker_pool_layout() } -> std::convertible_to<WorkerPoolLayout>;
    { sched.simd_worker_count() } -> std::convertible_to<std::uint8_t>;
    { sched.is_heterogeneous_aware() } -> std::convertible_to<bool>;
    { sched.batch_size() } -> std::convertible_to<std::size_t>;
};

}
```

**Detail-Klassen 13 (5 Sub-Achsen):**

| Sub-Achse | Klassen |
|---|---|
| 13.1 Worker-Pool-Layout | `ThreadPerCore`, `WorkStealing`, `CpuPinning` |
| 13.2 SIMD-Worker-Count | `Limit_1`, `Limit_2`, `Limit_4` |
| 13.3 Heterogeneous | `Homogeneous`, `HybridAware` (P-Core vs E-Core) |
| 13.4 Memory-Interleave | `NoInterleave`, `RoundRobin`, `FirstTouch` |
| 13.5 Batching | `Single`, `MicroBatch`, `MacroBatch` |

---

## §9 Cross-Reference

**Code-Anker (V33):**

- `cache-engine/libs/cache_engine/builder/commands/axis_library_registry.hpp` (28 Achsen-Eintraege)
- `cache-engine/libs/cache_engine/include/cache_engine/concepts/hardware_strategy.hpp` (V32.EE.5)
- `cache-engine/libs/cache_engine/include/cache_engine/concepts/scheduling_strategy.hpp` (V32.EE.5)
- `cache-engine/libs/cache_engine/include/cache_engine/concepts/numa_affinity.hpp` (V32.EE.5)
- `cache-engine/libs/cache_engine/include/cache_engine/concepts/locking_mode.hpp` (V32.EE.5)
- `prt-art/prt_art/include/prt_art/default_lookup/default_lookup_registry.hpp` (V33.B.1)

**Doku-Anker:**

- `07_bausteine_matrix_N_erweitert.md` (14-Achsen-Master)
- `02_allokator_matrix.md` (Allokator-Detail fuer P4B-4)
- `06_eigenschaften_suchalgorithmen.md` (Achsen-Properties pro Paper)
- `../adapters/O_PHASE_PRT_ART_AXES_MIRROR.md` (PRT-ART Spiegel-Module)

---

**Q.3 Akzeptanz-Kriterien erfuellt:**
- [x] 8 Sektionen (P4B-1 bis P4B-8) — §1-§8
- [x] Pro Sektion mind. 3 Detail-Klassen mit Concept-Header-Stub
- [x] V33-Verankerung in AxisLibraryRegistry dokumentiert

**Ende docs/bausteine/08_p4b_detail_klassen.md (Q.3 DONE).**
