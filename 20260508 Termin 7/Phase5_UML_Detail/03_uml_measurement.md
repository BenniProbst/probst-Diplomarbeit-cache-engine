# UML — Measurement (Achse 10, F1, F-EXTRA-7)

**Bezug:**
- ADR F1 (Per Mess-Kategorie x Algorithmus-Detail eine `constexpr`-Spezialisierung)
- ADR F11 (Continuous fuer Builder, Sampled 1:N fuer Production)
- ADR F-EXTRA-7 (Default-Hooks + algo-spezifische Overrides via `requires HasMeasurement<...>`)
- Bausteine_Matrix Achse 10 + 11

---

## 1. Mess-Matrix (F1)

```cpp
template<MeasurementCategory Cat, AlgoDetail Detail>
struct Measure;   // Primary template

// Default-Hook (F-EXTRA-7)
template<MeasurementCategory Cat, AlgoDetail Detail>
struct Measure {
    static constexpr void at_lookup_begin(Context&) noexcept {}
    static constexpr void at_lookup_end(Context&) noexcept {}
    static constexpr void at_node_visit(NodeRef, Context&) noexcept {}
    static constexpr double extract() noexcept { return 0.0; }
};

// Algo-spezifische Override (F-EXTRA-7)
template<>
struct Measure<MeasurementCategory::CLU, AlgoDetail::ART_NODE256> {
    static constexpr void at_node_visit(NodeRef ref, Context& ctx) noexcept {
        // Bit-genaue Berechnung der effektiv genutzten Bytes
        ctx.cache_lines_used += unodb::node256_used_bytes(ref) / 64;
    }
    static constexpr double extract() noexcept { return ctx.cache_lines_used / total_lines; }
};
```

## 2. UML-Klassen

```
class MeasurementCategory <<enum>> {
    CLU
    CACHE_MISS_L1
    CACHE_MISS_L2
    CACHE_MISS_L3
    DTLB_MISS
    MEMORY_FOOTPRINT
    BRANCH_MISS
    IPC_CPI
    LATENCY_MEAN
    LATENCY_P50
    LATENCY_P95
    LATENCY_P99
    LATENCY_P999
    THROUGHPUT
    ENERGY_J
    FILL_BUFFER_OCCUPANCY
}

class AlgoDetail <<enum>> {
    ART_NODE4 / ART_NODE16 / ART_NODE48 / ART_NODE256
    HOT_COMPOUND_K32 / HOT_BINODE
    MASSTREE_INTERNAL / MASSTREE_BORDER
    COCO_MACRONODE
    START_MULTIBYTE
    B2TREE_DECISION / B2TREE_SPAN
    SURF_LOUDS_DENSE / SURF_LOUDS_SPARSE
    CSS_NODE / CSB_NODEGROUP / WIDER_HANKINS
    PRTART_DENSEBYTE / PRTART_EXTENDEDDENSE / PRTART_SPARSEPATRICIA
    PRTART_REDIRECT / PRTART_CUSTOMCACHE
    /* ... */
}

template<MeasurementCategory Cat, AlgoDetail Detail>
class Measure <<constexpr template>> <<F1>> {
    + at_lookup_begin(ctx : Context&) const noexcept <<inline>>
    + at_lookup_end(ctx : Context&) const noexcept <<inline>>
    + at_node_visit(ref : NodeRef, ctx : Context&) const noexcept <<inline>>
    + extract() const noexcept : double <<inline>>
}

class Context <<thread-local>> {
    + cache_lines_used : uint64_t
    + cache_misses_l1 : uint64_t
    + cache_misses_l2 : uint64_t
    + cache_misses_l3 : uint64_t
    + dtlb_misses : uint64_t
    + branch_misses : uint64_t
    + lookup_start_ns : uint64_t
    + lookup_end_ns : uint64_t
}
```

## 3. F-EXTRA-7 — HasMeasurement-Concept

```cpp
template<typename Algo, MeasurementCategory Cat>
concept HasMeasurement = requires(Algo) {
    { Measure<Cat, AlgoDetailFor<Algo>>::at_node_visit } -> std::invocable<NodeRef, Context&>;
};

template<typename Algo>
class AlgoMeasurementBundle <<requires>> {
    // Aktiviert nur Mess-Kategorien, die der Algo unterstuetzt
    + on_node_visit(ref : NodeRef, ctx : Context&) noexcept <<inline>>
        // expandiert zu allen Measure<Cat, Detail>::at_node_visit-Aufrufen
        // wo HasMeasurement<Algo, Cat> erfuellt ist
}
```

## 4. F11 — Trigger-Modus

```
class MeasurementTrigger <<enum>> {
    CONTINUOUS  ' Builder-Modus, jeder Lookup
    SAMPLED_1_N ' Production, default 1:1000
}

class MeasurementHooks {
    - trigger : MeasurementTrigger
    - sample_n : size_t = 1000
    - sample_counter : thread_local size_t
    + maybe_record(record : MeasurementRecord&&) <<inline noexcept>>
    ' if (trigger == CONTINUOUS) buffer.append(record)
    ' else if (++sample_counter % sample_n == 0) buffer.append(record)
}
```

## 5. Bezug zu Achse 11 (Telemetry-Collection-Strategy)

Achse 10 = WAS gemessen wird (Cat).
Achse 11 = WIE Telemetrie erfasst wird (siehe `02_uml_cache_engine.md` §4).
Die Klassen sind orthogonal aber kompositionsfaehig: `Measure<Cat, Detail>` ruft TelemetryStrategy-Increment auf.
