# UML — Cache Engine Klassen (zentrale Forschungs-Komponente)

**Bezug:**
- ADR F1 (CacheEngine-Singleton, Heap-Allokation, `unique_ptr` + `call_once`)
- ADR F2 (Observer-Push synchron mit Lambda-Tree-Filter)
- ADR F6 (ConcurrencyManager: 8+ Disziplin-Klassen + Policy-Templates)
- ADR F12-K (CacheEngine ist Heap-Singleton IM Builder-Prozess)
- ADR F-EXTRA-6 (DecisionLambdaTrees PRO Baustein)
- ADR F-EXTRA-1 (Compiler-Layering — die Cache-Engine selbst ist C++23)
- Bausteine_Matrix Achse 8 (Concurrency) + Achse 11 (Telemetry-Collection-Strategy)
- Glossar v7 BLOCK AI-AP (Kuehn-Erkenntnisse 2026-05-09 + Production-Plattform)

**Architektur-Lokation:** `cache_engine/` im Repo `comdare-cache-engine`.

---

## 1. Top-Level — CacheEngine Heap-Singleton

```
class CacheEngine <<singleton>> <<heap-allocated>> {
    ' F1: Heap-Singleton mit unique_ptr + call_once
    ' F12-K: lebt IM CacheEngineBuilder-Prozess als globale Variable
    ' Sub-Singletons via Composition

    -- Statische Lebenszyklen-Methoden --
    + static instance() : CacheEngine&  <<thread-safe call_once>>
    - static instance_ptr_ : unique_ptr<CacheEngine>
    - static initialize_once_ : once_flag

    -- Kompositions-Sub-Singletons (alle Heap, F1) --
    - concurrency_manager_  : unique_ptr<IConcurrencyManager>
    - decision_registry_    : DecisionLambdaTreeRegistry
    - measurement_buffer_   : unique_ptr<InMemoryMeasurementBuffer>
    - observer_registry_    : ObserverRegistry
    - platform_probe_       : unique_ptr<IPlatformProbe>
    - allocator_factory_    : unique_ptr<IPlatformAllocatorFactory>
    - cache_hierarchy_mgr_  : unique_ptr<CacheHierarchyManager>

    -- Zustands-Methoden --
    + reset_state() : void  <<noexcept>>
    ' setzt zwischen Experimenten zurueck (F12-K), nicht die Instanz
    + warm_up_for_module(module : ICacheAwareSearchAlgorithm&) : void
    + bind_loaded_module(module : ICacheAwareSearchAlgorithm&) : void
    + unbind_module() : void

    -- F2: Synchroner Push-Notify-Slot --
    + notify(event : Event&&) : void  <<inline noexcept>>
    ' Wird vom Algorithmus im Hot-Path aufgerufen
    ' Filtert via DecisionLambdaTrees pro Baustein

    -- Constraints --
    inv: instance() liefert immer dieselbe Adresse [F12-K]
    inv: NICHT als separater Service-Prozess [F12-K]
    inv: Lebenszeit = Builder-Prozess-Lebenszeit
    inv: thread-safe gemaess F1 (call_once)
}
```

---

## 2. F-EXTRA-6 — DecisionLambdaTree-Hierarchie (PRO Baustein)

```
<<abstract>> class IDecisionLambdaTree<EventT, DecisionClassT> {
    -- Decision-Enum --
    + enum class Decision : uint8_t { EXECUTE, DELAY, SKIP }
    -- Bewertungs-Methode --
    + virtual evaluate(event : EventT&&, ctx : Context&) const noexcept : Decision = 0
    -- Konfigurations-Methoden --
    + virtual configure(config : NodeTreeConfig const&) : void = 0
    + virtual save_state() const : NodeTreeState
    + virtual restore_state(state : NodeTreeState const&) : void
}

' --- Konkrete Tree-Familien (F-EXTRA-6: PRO BAUSTEIN) ---

class PageRelocationTree<PageT> {
    ' Bringt jeder Page-Bauteil mit (Art256Page, HOTCompoundPage, ...)
    -- Lambda-Knoten --
    - root : LambdaNode<PageRelocationEvent>
    -- Konkrete Lambdas --
    - eval_load_factor : function<bool(PageRelocationEvent&)>
    - eval_neighbor_pressure : function<bool(PageRelocationEvent&)>
    - eval_cache_coherence_cost : function<bool(PageRelocationEvent&)>  ' Block AN
    -- evaluate-Methode --
    + evaluate(event : PageRelocationEvent&&, ctx : Context&) const noexcept : Decision
}

class PageTypeChangeTree<PageT> {
    ' z.B. Node4 → Node16 → Node48 → Node256 (P01)
}

class PrefetchAdjustmentTree<TraversalT> {
    ' z.B. P23 Khan adaptive Prefetch-Distanz
}

class HotPathRecognitionTree<TraversalT> {
    ' z.B. P26 Zhang FGCS Hot-Path-Detection per Read-Counter
}

class AllocatorRebalanceTree<AllocatorT> {
    ' Pool-Per-PageType ↔ Arena-Per-Subtree
}

class ConcurrencyDisciplineSwitchTree<DiscT> {
    ' OLC ↔ ROWEX ↔ RCU bei Last-Aenderung
}

class ValueHandleSelectionTree<HandleT> {
    ' VALUEHANDLE_DYNAMIC switch_array-Wahl
}

class SamplingRateAdjustmentTree<TelemetryT> <<NEU 2026-05-09>> {
    ' Kuehn-Erkenntnis Block AM
    -- Adaptive N-Anpassung fuer LeafOnlySampledCounter<N> --
    - current_n : atomic<size_t>
    -- Lambda-Knoten --
    - eval_cpu_load : function<bool(SamplingEvent&)>
    - eval_hot_path_variability : function<bool(SamplingEvent&)>
    - eval_cache_miss_rate : function<bool(SamplingEvent&)>
    -- evaluate-Methode --
    + evaluate(event : SamplingEvent&&, ctx : Context&) const noexcept : Decision
    + adjust_n(target_n : size_t) : void
}

class CoherenceAwareWriteDecisionTree <<NEU 2026-05-09>> {
    ' Kuehn-Erkenntnis Block AN — MemoryAccessConcurrency::Write Cost-Funktion
    -- Lambda-Knoten --
    - eval_node_depth : function<bool(WriteEvent&)>
    - eval_num_cores_sharing : function<bool(WriteEvent&)>
    - eval_cache_line_size : function<bool(WriteEvent&)>
    -- Cost-Berechnung --
    - compute_cache_coherence_cost(target : NodeRef&) const : double
    -- evaluate-Methode --
    + evaluate(event : WriteEvent&&, ctx : Context&) const noexcept : Decision
    ' SKIP fuer Wurzelnaehe-Knoten unter Multi-Core-Last
    ' DELAY Reordering bis ConsolidationBarrier
}

class CacheCoherenceDetectionTree <<NEU 2026-05-09>> {
    ' Kuehn-Erkenntnis Block AI — Anti-Pattern-Erkennung
    -- evaluate(per Knoten-Tiefe + cores) --
    + evaluate(event : TelemetryUpdateEvent&&, ctx : Context&) const noexcept : Decision
    ' SKIP Per-Node-Counter-Updates an Wurzelnaehe-Knoten unter Multi-Core
}

' Beziehung
IDecisionLambdaTree <|-- PageRelocationTree
IDecisionLambdaTree <|-- PageTypeChangeTree
IDecisionLambdaTree <|-- PrefetchAdjustmentTree
IDecisionLambdaTree <|-- HotPathRecognitionTree
IDecisionLambdaTree <|-- AllocatorRebalanceTree
IDecisionLambdaTree <|-- ConcurrencyDisciplineSwitchTree
IDecisionLambdaTree <|-- ValueHandleSelectionTree
IDecisionLambdaTree <|-- SamplingRateAdjustmentTree
IDecisionLambdaTree <|-- CoherenceAwareWriteDecisionTree
IDecisionLambdaTree <|-- CacheCoherenceDetectionTree
```

### DecisionLambdaTreeRegistry

```
class DecisionLambdaTreeRegistry {
    ' Vereint alle Trees, die ein geladenes Modul mitbringt
    -- Attribute --
    - trees_per_module : map<ModuleId, DecisionLambdaTreeBundle>
    -- Methoden --
    + register_module_trees(module_id : ModuleId, bundle : DecisionLambdaTreeBundle&&) : void
    + unregister_module(module_id : ModuleId) : void
    + dispatch(event : Event&&) : Decision
    ' Routing nach Event-Typ + Modul-Kontext
}

class DecisionLambdaTreeBundle {
    ' Komposition aller Trees pro Permutation (F-EXTRA-6)
    -- Attribute (jeweils 0..1, je nach Bausteine-Auswahl) --
    - page_relocation : optional<PageRelocationTree>
    - page_type_change : optional<PageTypeChangeTree>
    - prefetch_adjustment : optional<PrefetchAdjustmentTree>
    - hot_path_recognition : optional<HotPathRecognitionTree>
    - allocator_rebalance : optional<AllocatorRebalanceTree>
    - concurrency_switch : optional<ConcurrencyDisciplineSwitchTree>
    - value_handle_selection : optional<ValueHandleSelectionTree>
    - sampling_rate : optional<SamplingRateAdjustmentTree>
    - coherence_aware_write : optional<CoherenceAwareWriteDecisionTree>
    - cache_coherence_detect : optional<CacheCoherenceDetectionTree>
}
```

---

## 3. F6 + F-EXTRA-X — ConcurrencyManager (8 Disziplinen + 3 Mechaniken)

```
<<concept>> IConcurrencyDiscipline<D>
   ^
   |____ implements (8 Disziplin-Klassen)
   |
+--+------+-----+-----+
PageDiscipline       NodeDiscipline       ArrayDiscipline       DataStructureDisc
PathDiscipline       MemoryReadDisc       MemoryWriteDisc       MemoryReadWriteDisc
SimdThreadDisc       SimdFlowDisc

' Block AN: MemoryWriteDisc enthaelt CacheCoherenceCost-Funktion
class MemoryAccessConcurrencyWrite <<extends Block AN>> {
    -- Cost-Funktion --
    + compute_cache_coherence_cost(target : NodeRef&) const : double
    ' = f(node_depth_from_root, num_cores_sharing_node, write_frequency, cache_line_size)
    -- DecisionLambdaTree-Anbindung --
    + write_decision_tree() : CoherenceAwareWriteDecisionTree&
}
IConcurrencyDiscipline <|.. MemoryAccessConcurrencyWrite
```

```
<<concept>> IConcurrencyMechanic<M>
   ^
   |
+--+--+
OLC (P01/P08)       ROWEX (P02/P08)      RCU (P29 — comdare-rcu, Task #104)

class OLCMechanic <<adapter>> {
    -- Bezug zu unodb optimistic_lock.hpp --
}

class RowexMechanic <<adapter>> {
    -- Bezug zu HOTRowex-Bauteilen --
}

class ComdareRcuMechanic <<comdare eigen>> {
    ' F2-Beschluss: eigene RCU statt liburcu
    -- 6 RCU-Flavors aus userspace-rcu als Konzept-Quelle --
    + qsbr_register_thread() : void
    + qsbr_quiescent_state() : void
    + synchronize_rcu() : void
}
IConcurrencyMechanic <|.. OLCMechanic
IConcurrencyMechanic <|.. RowexMechanic
IConcurrencyMechanic <|.. ComdareRcuMechanic
```

### Komposition via Policy-Template (F6 A+C)

```
template<IConcurrencyDiscipline... Ds, IConcurrencyMechanic M>
class ConcurrencyManager <<policy>> <<zero-overhead>> {
    -- Disziplinen-Tuple (Compile-Time) --
    - disciplines_ : tuple<Ds...>
    - mechanic_ : M
    -- Forwarding-Methoden --
    + dispatch(event : Event&&) : void  <<inline>>
    ' Verteilt synchron an alle Disziplinen, dann an Mechanic
}

IConcurrencyManager <|.. ConcurrencyManager
```

---

## 4. NEU 2026-05-09 — Achse 11: TelemetryStrategy (Kuehn-Erkenntnisse)

```
<<concept>> ITelemetryStrategy<T>
   ^
   |
+--+--+
TELEMETRY_PER_NODE_COUNTER         (P28 Original)
TELEMETRY_LEAFONLY_COUNTER         (P28 Kuehn NEU 2026-05-08)
TELEMETRY_LEAFONLY_SAMPLED_COUNTER (P28 Kuehn NEU 2026-05-08)
TELEMETRY_RETROACTIVE_AGGREGATION  (P28 Kuehn NEU 2026-05-08, BARRIERE)
TELEMETRY_PATH_READ_COUNTER        (P26 Zhang FGCS)
TELEMETRY_PROBABILITY_HINTS_HEADER (PRT-ART eigen, T4)
```

```
class PerNodeCounter <<P28 original, WARNING>> {
    ' WARNING: Cache-Coherence-Anti-Pattern (Block AI)
    -- Attribute --
    - counter : array<atomic<uint32_t>, NUM_NODES>
    -- Methoden --
    + increment(node_id : NodeId) : void <<inline>>
    -- Constraint --
    requires NotInTopLevels<TelemetryStrategy>  ' Multi-Core-Workload
    -- Begleit-DecisionTree --
    + cache_coherence_detection_tree() : CacheCoherenceDetectionTree&
}

class LeafOnlyCounter <<NEU Kuehn 2026-05-08>> {
    ' Counter NUR in Blatt-Knoten — vermeidet Cache-Coherence-Anti-Pattern
    -- Attribute --
    - leaf_counters : array<atomic<uint32_t>, NUM_LEAVES>
    -- Methoden --
    + increment_leaf(leaf_id : LeafId) : void <<inline>>
    -- Abhaengigkeit --
    requires Companion<RetroactiveAggregation>  ' fuer innere Knoten
}

template<size_t SamplingRateN = 1000>
class LeafOnlySampledCounter <<NEU Kuehn 2026-05-08, parametrisiert>> {
    ' Counter nur in Blaettern, nur jeder N-te Zugriff
    -- Attribute --
    - sample_counter : thread_local atomic<size_t>
    - leaf_counters : array<atomic<uint32_t>, NUM_LEAVES>
    -- Methoden --
    + maybe_increment_leaf(leaf_id : LeafId) : void <<inline>>
    ' if (++sample_counter % SamplingRateN == 0) leaf_counters[leaf_id]++
    -- Begleit-DecisionTree --
    + sampling_rate_adjustment_tree() : SamplingRateAdjustmentTree&
}

class RetroactiveAggregation <<barrier>> <<NEU Kuehn 2026-05-08>> {
    ' Wurzel-Up-Traversal vor Reordering — laeuft Single-Threaded
    -- Methoden --
    + run_aggregation(root : NodeRef&) : AggregatedHistogram
    ' Iterativer Walk; sammelt Blatt-Counter zu inneren Knoten
    -- Trigger --
    + on_consolidation_barrier(event : ConsolidationBarrierEvent&) : void
}

class PathReadCounter <<P26 Zhang FGCS>> {
    -- Read-Counter pro Block, Hot-Path-Detection-Schwelle --
}

class ProbabilityHintsHeader <<PRT-ART eigen, T4>> {
    ' Quantisierte Wahrscheinlichkeits-Sketches im Page-Header
    -- Attribute --
    - hint_bits : array<uint8_t, BIT_LAYOUT_BYTES>  ' Build-Flag konfigurierbar 16/32 Bit (F1)
    -- Methoden --
    + record_access(byte : uint8_t) : void <<inline>>
}

ITelemetryStrategy <|.. PerNodeCounter
ITelemetryStrategy <|.. LeafOnlyCounter
ITelemetryStrategy <|.. LeafOnlySampledCounter
ITelemetryStrategy <|.. PathReadCounter
ITelemetryStrategy <|.. ProbabilityHintsHeader
```

---

## 5. F2 — ObserverRegistry + Event-Hierarchie

```
<<abstract>> class Event {
    -- Attribute --
    + timestamp : steady_clock::time_point
    + module_id : ModuleId
    + thread_id : thread::id
}

class PageRelocationEvent {
    + source_page : PageRef
    + target_layout : LayoutHint
    + load_factor : double
}

class PageTypeChangeEvent {
    + current_type : PageType
    + suggested_type : PageType
    + reason : ResizeReason
}

class PrefetchAdjustmentEvent { ... }
class HotPathRecognitionEvent { ... }
class TelemetryUpdateEvent { ... }
class WriteEvent { ... }
class ConsolidationBarrierEvent { ... }
class SamplingEvent { ... }
class ErrorEvent { ... }

Event <|-- PageRelocationEvent
Event <|-- PageTypeChangeEvent
Event <|-- PrefetchAdjustmentEvent
Event <|-- HotPathRecognitionEvent
Event <|-- TelemetryUpdateEvent
Event <|-- WriteEvent
Event <|-- ConsolidationBarrierEvent
Event <|-- SamplingEvent
Event <|-- ErrorEvent

class ObserverRegistry {
    ' F2: Push synchron — Algorithmus ruft direkt notify(event)
    -- Attribute --
    - module_observers : map<ModuleId, vector<IObserver*>>
    -- Methoden --
    + register_observer(module : ModuleId, obs : IObserver*) : void
    + dispatch(event : Event&&) : void  <<inline noexcept>>
    ' Filtert via DecisionLambdaTrees, dann routet an passende Observer
}
```

---

## 6. CacheHierarchyManager (F4 Plattform-Adapter)

```
class CacheHierarchyManager <<NEU F4>> {
    ' Software-Cache-Hierarchie ueber DIMM + HBM + V-Cache
    -- Attribute --
    - allocator_factory : IPlatformAllocatorFactory&
    - probe : PlatformProbe&
    - tier_routing : map<DataTemperature, AllocatorTier>
    -- Methoden --
    + allocate_for(temp : DataTemperature, size : size_t) : void*
    + migrate_tier(ptr : void*, src : Tier, dst : Tier) : void
    -- Plattform-Spezifika (Block AO) --
    + ryzen_x3d_v_cache_aware() : bool   ' bevorzugt CCD0 fuer Hot-Set
    + intel_hybrid_p_core_aware() : bool ' P-Core-Pinning fuer Hot-Path
}
```

---

## 7. Lambda-Tree Pseudocode-Beispiel

Beispiel: `PageRelocationTree<Art256Page>` evaluation:

```cpp
constexpr Decision PageRelocationTree<Art256Page>::evaluate(
    PageRelocationEvent&& event,
    Context& ctx
) const noexcept {
    // Lambda 1: Pruefe Load-Factor
    if (event.load_factor < 0.20)
        return Decision::EXECUTE;  // Page schrumpfen
    if (event.load_factor > 0.95)
        return Decision::EXECUTE;  // Page wachsen

    // Lambda 2: Pruefe Cache-Coherence-Cost (Block AN, Kuehn)
    auto cost = ctx.coherence_aware_write_tree
                   .compute_cache_coherence_cost(event.source_page);
    if (cost > ctx.cost_threshold)
        return Decision::DELAY;  // verzoegern bis ConsolidationBarrier

    // Lambda 3: Pruefe Last-Spirale
    if (ctx.recent_relocations_count > MAX_PER_INTERVAL)
        return Decision::SKIP;  // Anti-Last-Spirale (F2)

    return Decision::EXECUTE;
}
```

---

## 8. F-EXTRA-7 — Mess-Hooks-Default (siehe `03_uml_measurement.md`)

CacheEngine bietet die Mess-Default-Hooks an, die pro Bausteine-Permutation in den Hot-Path inlinieren werden. Details in `03_uml_measurement.md`.

---

## 9. Block AP — Forschungs-Mission als Operations-Modus

```
<<enum>> class CacheEngineMode {
    HEURISTIC_STATIC,        ' StaticEngine, klassische Faustregeln
    INFORMED_KALIBRIERT,     ' Cache-Engine-Modell + plattform-Kalibrierung
    AUTOMATIC_ADAPTIVE       ' DecisionLambdaTree-Steuerung waehrend Laufzeit
}

' CacheEngine traegt einen current_mode_-Flag (Compile-Time-Konstante in Builder-Modus)
' F15 Bausteine-Quer-Permutation operationalisiert den Vergleich aller drei Modi
```

---

## 10. drawio-Tab-Struktur (REV 2)

| drawio-Tab | Inhalt |
|-----------|--------|
| Tab 02-A | CacheEngine Singleton + Sub-Singletons (oben Section 1) |
| Tab 02-B | DecisionLambdaTree-Hierarchie (Section 2 — alle 10+ Tree-Familien) |
| Tab 02-C | ConcurrencyManager (Section 3 — 8 Disziplinen + 3 Mechaniken + Composition) |
| Tab 02-D | TelemetryStrategy NEU 2026-05-09 (Section 4 — Kuehn-Erkenntnisse) |
| Tab 02-E | ObserverRegistry + Event-Hierarchie (Section 5) |
| Tab 02-F | CacheHierarchyManager (Section 6 — Block AO Plattform-Bezug) |
| Tab 02-G | Lambda-Tree Sequence-Diagramm (Section 7 — evaluate-Aufruf-Pfad) |

---

## 11. Cross-Reference (Kurzform)

| UML-Klasse | Bausteine_Matrix-Achse | Glossar v7 BLOCK |
|-----------|------------------------|------------------|
| CacheEngine | — (uebergeordnet) | F1, F12-K (Singleton im Builder) |
| ConcurrencyManager | Achse 8 | F6 |
| MemoryAccessConcurrencyWrite | Achse 8 (erweitert) | AN (Cache-Coherence-Cost) |
| OLCMechanic | Achse 8 | (P08 OLC) |
| RowexMechanic | Achse 8 | (P02 ROWEX) |
| ComdareRcuMechanic | Achse 8 | F2 (eigene RCU, Task #104) |
| PerNodeCounter | Achse 11 | AI (Anti-Pattern) |
| LeafOnlyCounter | Achse 11 (NEU) | AJ |
| LeafOnlySampledCounter | Achse 11 (NEU) | AL |
| RetroactiveAggregation | Achse 11 (NEU) | AK (Barriere) |
| SamplingRateAdjustmentTree | F-EXTRA-6 + Achse 11 | AM |
| CoherenceAwareWriteDecisionTree | F-EXTRA-6 + Achse 8 | AN |
| CacheHierarchyManager | F4 | AO (Plattform) |
| ProbabilityHintsHeader | Achse 11 (PRT-ART eigen) | T4 |
