# queuing-Topic: Achsen-Eigenschaften (V41.F.6.1 Pilot, 2026-05-26)

**Stand:** 2026-05-26 nach Naming-Refactor + Edge-Case-Tests + Zero-Cap-Fix
**Vorlage:** Allocator-Achse 6 (24 Vendor, 7 Pflicht-Properties)
**Tests:** 81/81 standalone gruen

---

## §1 Topic-Uebersicht

Topic `queuing` (W2-Recherche, Master-Doc §11.2) erfuellt Buffer/Queue-Strategien
fuer Cache-Engine. **User-Entscheidung 2026-05-26: 2 Achsen mit Cartesian-Product:**

| Achse | Aufgabe | Pilot | Vollausbau geplant |
|-------|---------|:-----:|:------------------:|
| `axis_q1_queuing` | Buffer-Strategy (WAS ist der Buffer?) | 4 | 13 (Q01-Q13 + LF-MPMC) |
| `axis_q2_queuing` | Flush-Policy (WANN wird gespuelt?) | 3 | 5 (F01-F05) |

**TopicConfigSet.CartesianQ1xQ2 = Q1 × Q2** (Pilot: 4 × 3 = 12; Vollausbau: 13 × 5 = 65)

> **Einordnung ins 3-Ebenen-Modell (korr. 2026-06-03, s. Doc 30 §8.0):**
> `queuing` ist ein **Topic** und damit **kein Interface/keine Gattung** und auch keine
> eigene Lebewesen-Unterklasse. `axis_q1_queuing` und `axis_q2_queuing` sind **Pflicht-Achsen
> (Organe) DERSELBEN aktuell gebauten Lebewesen-Unterklasse** (die std::map-ähnliche
> SearchAlgorithm-Lebewesen-Unterklasse, die UNTER dem SearchAlgorithm-**Gattungs-Interface**
> liegt und einen festen Achsen-Satz verwendet). Q1 (Buffer) und Q2 (Flush) sind also
> **nicht optional** und kein eigenes Außen-Interface — ein nicht-pufferndes/nicht-spülendes
> Lebewesen wählt den konkreten Durchreich-Algorithmus (`NoBuffer` Q01 bzw. `LazyFlush`/`NoFlush`),
> NICHT „Achse weglassen". Das u. g. Cartesian-Product Q1 × Q2 ist die Permutation INNERHALB
> dieser einen Lebewesen-Unterklasse, nicht eine Kombination von Gattungen.

---

## §2 axis_q1_queuing (Buffer-Strategy)

### §2.1 Pflicht-API (analog std::queue + std::deque hybrid)

```cpp
template <typename B>
concept BufferStrategy = QueuingComponent<B> && requires(B b, typename B::element_type v) {
    typename B::element_type;          // std::uint64_t in Pilot
    typename B::size_type;
    { b.put(v) }                       -> std::same_as<void>;
    { b.get() }                        -> std::same_as<std::optional<element_type>>;
    { b.emplace(v) }                   -> std::same_as<void>;
    { b.peek_front() }                 noexcept -> std::same_as<std::optional<element_type>>;
    { b.peek_back() }                  noexcept -> std::same_as<std::optional<element_type>>;
    { b.size() }                       noexcept -> std::convertible_to<std::size_t>;
    { b.is_empty() }                   noexcept -> std::convertible_to<bool>;
    { b.clear() }                      noexcept;
};
```

### §2.2 Cache-Engine-Pflicht (analog Allocator)

```cpp
typename topic_tag;        // QueuingTopicTag
typename axis_tag;         // QS1-QS6 (sequential/ordered/cyclic/versioned/batched/lock_free)
typename family_id;        // std::integral_constant<int, Q01..Q13>
static constexpr bool        is_thread_safe();
static constexpr bool        is_bounded();           // FIFO=false, Ring=true
static constexpr std::size_t default_capacity();
static constexpr std::string_view name() / family_name() / flag_suffix();
// Sonderfall-Properties (Pflicht):
static constexpr bool supports_concurrent_producers();
static constexpr bool supports_concurrent_consumers();
static constexpr bool supports_priority_ordering();
static constexpr bool is_versioned();
static constexpr ProgressGuarantee progress_guarantee();   // Stufen-Enum analog Allocator
// Mess-API (wenn STATISTICS=ON):
using snapshot_t = BufferStatistics;
using observer_t = MeasurableObserver<snapshot_t>;
statistics() / snapshot() / reset() / observer()
```

### §2.3 Pilot-Strategien (4 von 13)

| Family | Klasse | Subaxis (QS) | Bounded | TLS-Cache | ProgressGuarantee | Sonderfall |
|:------:|--------|:-----------:|:-------:|:---------:|:-----------------:|------------|
| Q01 | `NoBuffer` | QS1 sequential | true (cap=0) | false | **WaitFree** (trivially) | no-op Passthrough (= **Durchreich-Algorithmus** für ein nicht-pufferndes Lebewesen; korr. 2026-06-03, s. Doc 30 §8.0 — die Q1-Achse bleibt Pflicht und wird getrieben, sie wird NICHT weggelassen) |
| Q03 | `FIFOQueue` | QS1 sequential | false (unbounded) | false | Blocking | std::deque-basiert |
| Q04 | `LIFOStack` | QS1 sequential | false (unbounded) | false | Blocking | std::vector-basiert; peek_front=top |
| Q05 | `BoundedRing` | QS3 cyclic | true | false | Blocking | iterable_aspect_t {8/64/1024/16384/65536}; **cap=0 throws** |

### §2.4 Vendor-Vollausbau-Roadmap (9 weitere)

| Family | Klasse | Subaxis | Notiz |
|:------:|--------|:-------:|-------|
| Q02 | AppendOnly | QS1 sequential | LSM-MemTable, Bw-Tree Delta-Chain |
| Q06 | PriorityHeap | QS2 ordered | LRU-Approx, Hot-Key Promotion |
| Q07 | DeltaChain | QS4 versioned | Bw-Tree (Levandoski 2013) |
| Q08 | SkiplistBuffer | QS2 ordered | LSM (RocksDB, LevelDB) |
| Q09 | TombstoneBuffer | QS4 versioned | LSM, ART-Optimistik, MVCC |
| Q10 | CopyOnWrite | QS4 versioned | Persistent ART, RCU-Tries |
| Q11 | EpochBuffer | QS4 versioned | SMART ART (OSDI 2023), Masstree |
| Q12 | BatchedInsertBuffer | QS5 batched | OLAP-Index, ART-Bulk-Insert |
| Q13a | LockFreeSPSC | QS6 lock_free | Lamport, Per-Thread → Background |
| Q13b | LockFreeMPMC | QS6 lock_free | Vyukov/Michael-Scott |

### §2.5 Edge-Cases (Tests im Pilot)

**Zero-Capacity:** `BoundedRing{0}` wirft `std::invalid_argument` (UB-Vermeidung
modulo durch capacity_=0). Memory `[[zero-size-allocation-exception]]`.

**Buffer-Sizes getestet (kTestBufferCapacities, 9 Edge-Werte):**
- Extrem: 1, 2, 3
- Power-of-2 (Cache-Line-aligned): 8, 64, 16384
- NICHT-Power-of-2: 7, 15, 100

---

## §3 axis_q2_queuing (Flush-Policy)

### §3.1 Pflicht-API

```cpp
enum class FlushDecision : std::uint8_t { NoFlush=0, PartialFlush=1, FullFlush=2 };

template <typename P>
concept FlushPolicy = QueuingComponent<P> && requires(P p, std::size_t fill, std::size_t cap) {
    { p.should_flush(fill, cap) }     noexcept -> std::convertible_to<FlushDecision>;
    { p.on_flush_complete() }         noexcept;
};
```

### §3.2 Cache-Engine-Pflicht

```cpp
typename topic_tag / axis_tag (FS1-FS3) / family_id (F01..F05);
name() / family_name() / flag_suffix();
// Sonderfall-Properties:
static constexpr bool is_time_based();
static constexpr bool is_threshold_based();
static constexpr bool is_event_driven();
static constexpr bool is_adaptive();
// Mess-API (wenn STATISTICS=ON):
using snapshot_t = FlushPolicyStatistics;
// + statistics/snapshot/reset/observer analog Q1
```

### §3.3 Pilot-Policies (3 von 5)

| Family | Klasse | Subaxis (FS) | Trigger | Decision | Sonderfall |
|:------:|--------|:-----------:|---------|----------|------------|
| F01 | `EagerFlush` | FS1 event_triggered | per-op | immer FullFlush | niedrige Latenz, kein Batching |
| F02 | `WatermarkFlush` | FS2 threshold | bei `fill/cap >= threshold_pct` | FullFlush wenn >= | iterable_aspect_t {50/65/75/85/95}; Default 75% |
| F04 | `LazyFlush` | FS1 event_triggered | nur Eviction | immer NoFlush | Maximum-Batching, Optimistic-Defer |

### §3.4 Vendor-Vollausbau (2 weitere)

| Family | Klasse | Notiz |
|:------:|--------|-------|
| F03 | TimedFlush | FS3 time_triggered; iterable_aspect_t = window_ms {10/100/1000/10000} |
| F05 | AdaptiveLsmFlush | FS4 adaptive_triggered; lernt aus Workload (LSM-spezifisch) |

### §3.5 Edge-Cases (Tests im Pilot)

- `should_flush(fill, cap=0)` → NoFlush (division-by-zero-guard)
- WatermarkFlush(75%) bei fill=74 → NoFlush, fill=75 → FullFlush (Schwellen-Edge)
- ShouldFlushAtAllIterableThresholds: iteriert alle 5 Watermark-Werte
- ShouldFlushWithNonStandardCapacities: cap=7 (non-Power-of-2), cap=1 (extrem)

---

## §4 TopicConfigSet (Cross-Achsen-Integration)

```cpp
namespace queuing {
struct TopicConfigSet {
    using StaticAxisVariants_Q1 = axis_q1_queuing::EnabledStrategies;
    using StaticAxisVariants_Q2 = axis_q2_queuing::EnabledPolicies;
    using StaticAxisVariants    = StaticAxisVariants_Q1;  // Default fuer 1-Topic-PermutationEngine
    using CartesianQ1xQ2        = mp::mp_product<mp::mp_list, StaticAxisVariants_Q1, StaticAxisVariants_Q2>;
};
}
```

**Pilot Cartesian:** 4 Q1 × 3 Q2 = **12 Buffer×Flush-Permutationen**

**Vollausbau Cartesian:** 13 × 5 = 65 (vor Cross-Constraint-Filter)

---

## §5 Cross-Constraints (TODO Batch 5+)

Aus W2-Recherche bekannte Constraints (heute noch nicht enforced):

- `Q-EPOCH + F-EAGER = INVALID` (Epoch wartet auf Quiescent-Period, eager spuelt nicht passend)
- `Q-COW + F-ADAPTIVE = INVALID` (CoW-Snapshot ist statisch, adaptive bringt nichts)
- `Q-SPSC + F-WATERMARK with high threshold = SUBOPTIMAL` (lock-free SPSC braucht eager)
- `Q-NONE + F-* = nur F-LAZY OK` (kein Buffer = nichts zu flushen ausser bei Eviction)

Implementation in PermutationEngine via `mp_filter` mit Constraint-Predicate
(siehe Master-Doc §15.4 PermutationEngine for_each_filtered_q).

---

## §6 Naming-Konvention (Allocator-Stil bestaetigt)

```
topics/queuing/
├── concepts/topic_queuing_concept.hpp           (QueuingTopicTag, QueuingComponent)
├── topic_queuing_config_set.hpp                  (TopicConfigSet)
├── axis_q1_queuing/                              (analog axis_06_allocator/)
│   ├── concepts/
│   │   ├── axis_q1_queuing_concept.hpp
│   │   └── axis_q1_queuing_cache_engine_permutation_concept.hpp
│   ├── axis_q1_queuing_base.hpp                  (CRTP)
│   ├── axis_q1_queuing_subaxes_qs1_to_qs6.hpp
│   ├── axis_q1_queuing_flags.hpp.in
│   ├── axis_q1_queuing_registry.hpp              (mp_list + mp_filter)
│   ├── axis_q1_queuing_no_buffer.hpp             (Q01)
│   ├── axis_q1_queuing_fifo.hpp                  (Q03)
│   ├── axis_q1_queuing_lifo.hpp                  (Q04)
│   └── axis_q1_queuing_bounded_ring.hpp          (Q05, iterable_aspect_t)
└── axis_q2_queuing/                              (analog axis_06_allocator/)
    ├── concepts/...
    ├── axis_q2_queuing_subaxes_fs1_to_fs3.hpp
    ├── axis_q2_queuing_flags.hpp.in
    ├── axis_q2_queuing_registry.hpp
    ├── axis_q2_queuing_eager.hpp                 (F01)
    ├── axis_q2_queuing_watermark.hpp             (F02, iterable_aspect_t)
    └── axis_q2_queuing_lazy.hpp                  (F04)
```

**Naming-Regel (verbindlich `[[neue-achse-strict-vorlage-allocator]]`):**
- Verzeichnis: `axis_<ID>_<topic-name>/` (NICHT `axis_<ID>_<thema-name>/`)
- Files: `axis_<ID>_<topic-name>_<inhalt>.hpp`
- Namespace: `comdare::cache_engine::<topic>::axis_<ID>_<topic-name>`

---

## §7 Test-Suite (81 Tests)

| Test-Suite | Anzahl | Inhalt |
|-----------|:------:|--------|
| Q1BufferStrategyTest (TYPED) | 8 × 4 = 32 | Concept/Identification/EmptyAfterDefault/PutDoesNotCrash/ClearMakesEmpty/PutGetRoundtrip/PeekDoesNotConsume/EmplaceEquivalentToPut + SonderfallProperties + (mit STATISTICS) ObserverAlias/ObserverNotify |
| Q2FlushPolicyTest (TYPED) | 5 × 3 = 15 | Concept/Identification/ShouldFlushDeterministisch/OnFlushCompleteNoCrash/SonderfallProperties + (mit STATISTICS) ObserverAlias/ObserverNotify |
| Spezifische Verhaltens-Tests | ~10 | FIFO-Order, LIFO-Order, BoundedRing-Overflow-Drops-Oldest, BoundedRing-ZeroCap-Throws, IterableAspect-Values-Count, Eager-Always, Lazy-Never, Watermark-75pct |
| Edge-Case-Tests | ~14 | BufferSize-PutGet (9 caps), BufferSize-Peek (8 caps), Watermark-Iterable-Thresholds, Watermark-Fill-Edges (7), Watermark-NonStandard-Capacities (4) |
| Cross-Axes-Tests | 2 | TopicConfigSet-CartesianProductSize, TopicQueuing-PermutationEngine-ForEachQ1xQ2 |

**Tests sind TYPED_TEST_SUITE-skalierend:** bei Batch 2 (+3 Q1 Strategien) →
+24 typed Tests automatisch (8 × 3); bei Batch 2 Q2 (+2 Policies) →
+10 typed Tests; Total Vollausbau: 13 × 8 + 5 × 5 = 129 typed + ~30 spezifisch = ~160.

---

## §8 Cross-Refs

- Master-Doc: `docs/architektur/11_konzept_achsen_extension_visitor_pattern.md` (§11.7.A FINALE Topic-Liste)
- Allocator-Vorlage: `docs/sessions/20260526-V41-F-6-1-allocator-achse-vollausbau-session.md`
- Session-Ende: `docs/sessions/20260526-V41-F-6-1-queuing-topic-pilot-session.md`
- Memory: `[[neue-achse-strict-vorlage-allocator]]`, `[[vendor-sonderfaelle-als-pflicht-property]]`, `[[zero-size-allocation-exception]]`, `[[scheduling-cross-topic-interface]]`
