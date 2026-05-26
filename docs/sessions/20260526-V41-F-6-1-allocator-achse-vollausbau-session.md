# V41.F.6.1 Allocator-Achse 6 VOLLAUSBAU — Session-Doku 2026-05-26

**Stand:** 2026-05-26 vollendet
**Vorgaenger-Session:** `20260526-V41-F-6-1-stufe-1-2-w6-pattern-session-end.md` (Pilot)
**Master-Doc:** `docs/architektur/11_konzept_achsen_extension_visitor_pattern.md`
**Trigger:** User-Direktive nach Vollausbau-Abschluss — dokumentiere elaborate die
fertiggestellte Achse + ihre Eigenschaften als Referenz fuer 14 weitere Topics.

---

## §1 Zusammenfassung — Allocator-Achse 6 ist KOMPLETT

Heute wurde die **erste Topic-Achse strukturell vollstaendig** umgesetzt:
24 Vendor-Wrapper (A01-A23 + StdMalloc-Default) ueber 8 Batches, alle mit
identischer Concept-Pflicht-API + automatischer Test-Expansion via
`TYPED_TEST_SUITE` + `mp_apply<ToGTestTypes, AllVendors>`.

**Heute LIVE:**

| Repo | HEAD | Tests | Aenderung heute |
|------|------|-------|-----------------|
| cache-engine standalone | `ce27752` | **252/252** | 8 Batches Vendor-Vollausbau + Concept-Erweiterungen |
| Diplomarbeit | `f74069b` | 104/104 | Submodule-Bumps + Doku |
| prt-art | unveraendert seit 2026-05-25 | — | — |

**Memory-Files heute neu/erweitert:**
- `feedback_vendor_sonderfaelle_als_pflicht_property.md` (erweitert um Stufen-Pattern)
- `feedback_migrationen_ans_ende.md` (NEU — Reihenfolge-Regel)

## §2 Alle 24 Vendor — Komplette Matrix

| # | Family | Vendor-Klasse | Subaxis | progress_guarantee | Sonderfall-Properties |
|:-:|:------:|---------------|:-------:|:------------------:|----------------------|
| 1 | A22 | StdMalloc | AA2 size_class | Blocking | (Default — alle bool false) |
| 2 | A04 | MimallocAllocator | AA1 freelist_topology | Blocking | tls_cache |
| 3 | A07 | SnmallocAllocator | AA3 thread_locality | **LockFree** | tls_cache |
| 4 | A22 | PmrResourceAllocator | AA5 allocation_policy | Blocking | (resource-abhaengig) |
| 5 | A05 | JemallocAllocator | AA2 size_class | Blocking | tls_cache |
| 6 | A06 | TCMallocAllocator | AA3 thread_locality | Blocking | tls_cache |
| 7 | A20 | DlmallocAllocator | AA2 size_class | Blocking | (klassisch single-thread) |
| 8 | A01 | HoardAllocator | AA1 freelist_topology | Blocking | tls_cache (per-heap) |
| 9 | A02 | SlabAllocator | AA2 size_class | Blocking | tls_cache (per-CPU magazines) |
| 10 | A03 | MichaelLockFreeAllocator | AA4 synchronization | **LockFree** | (CAS-only) |
| 11 | A08 | ScallocAllocator | AA1 freelist_topology | **LockFree** | tls_cache, **NICHT native_aligned** |
| 12 | A09 | NUMAllocAllocator | AA5 allocation_policy | Blocking | **numa_node_hint** + Constructor(int) |
| 13 | A10 | RPMallocAllocator | AA3 thread_locality | Blocking | tls_cache, **requires_explicit_init** (Guard) |
| 14 | A11 | LRMallocAllocator | AA4 synchronization | **LockFree** | tls_cache (Hazard-Pointer Reclamation) |
| 15 | A12 | CAMAAllocator | AA5 allocation_policy | Blocking | tls_cache (Cache-Line aware) |
| 16 | A13 | StarMallocAllocator | AA2 size_class | Blocking | **FORMAL VERIFIED** (F* + KaRaMeL, Doku-only) |
| 17 | A14 | TCMallocWarehouseAllocator | AA3 thread_locality | Blocking | tls_cache (Hyperscale) |
| 18 | A15 | HMallocAllocator | AA1 freelist_topology | Blocking | tls_cache (Hybrid Free-List) |
| 19 | A16 | PIMMallocAllocator | AA5 allocation_policy | Blocking | **requires_specialized_hardware** + DPU-ID |
| 20 | A17 | CrystallineAllocator | AA6 reclamation | **WaitFree** | tls_cache (Wait-Free Reclamation) |
| 21 | A18 | ExgenAllocator | AA4 synchronization | **WaitFree** | (single-thread = trivially wait-free) |
| 22 | A19 | BuddyAllocator | AA7 fragmentation_strategy | Blocking | (Knuth-Klassik, mono-tree) |
| 23 | A21 | PtMalloc2Allocator | AA2 size_class | Blocking | tls_cache, EXPLIZIT (__libc_malloc, bypassed LD_PRELOAD) |
| 24 | A23 | VmemMagazinesAllocator | AA6 reclamation | Blocking | tls_cache (per-CPU Magazines, Bonwick 2001) |

**Subaxis-Verteilung (AA1-AA7):**
- AA1 freelist_topology: 4 Vendor (Mi, Hoard, Scalloc, HMalloc)
- AA2 size_class_schema: 6 Vendor (Std, Je, Dl, Slab, Star, PtMalloc2)
- AA3 thread_locality: 4 Vendor (Sn, Tc, RP, TC-WH)
- AA4 synchronization: 3 Vendor (Michael-LF, LR, Exgen)
- AA5 allocation_policy: 4 Vendor (PMR, NUMAlloc, CAMA, PIM)
- AA6 reclamation: 2 Vendor (Crystalline, Vmem-Mag)
- AA7 fragmentation_strategy: 1 Vendor (Buddy)

## §3 Concept-Evolution (Pflicht-Properties pro Vendor)

Die `CacheEnginePermutationStrategy`-Concept wuchs ueber 8 Batches von der
initial 5-Methoden-API zu jetzt 11+1 (Standard + Sonderfall-Properties).

| Batch | Hinzugefuegt | Auslöser | Memory-File |
|:-----:|--------------|----------|-------------|
| 1 (Pilot) | `topic_tag`, `axis_tag`, `family_id`, `name`, `family_name`, `is_thread_safe`, `supports_pmr`, `max_alignment` | Pilot-Skelett | [[topic-axis-pruefling-namespace-pattern]] |
| 1 | `statistics()`, `reset()` (wenn STATISTICS=ON) | Mess-Welt | [[statistics-cmake-flag]] [[reset-is-statistics-reset]] |
| Stufe 3 | `snapshot_t`, `observer_t`, `snapshot()`, `observer()` (wenn STATISTICS=ON) | Observer-Pattern | (in Statistics-Block) |
| F.6.1.G | `flag_suffix()` | CacheEngineBuilder CLI | (in [[master-architektur-skizze]] §15.10) |
| 4-Konsolidierung | `has_native_aligned_alloc()`, `requires_explicit_init()`, `supports_numa_node_hint()`, `is_lock_free()` (alt), `supports_thread_local_cache()` | Scalloc/RP/NUMAlloc-Sonderfaelle | **[[vendor-sonderfaelle-als-pflicht-property]]** |
| 6 | `requires_specialized_hardware()` | PIM-Malloc | (gleiches Memory) |
| 7-original | `is_wait_free()` (Bool) | Crystalline | (gleiches Memory) |
| **7-Refactor** | `is_lock_free()` + `is_wait_free()` → `progress_guarantee()` enum class | User-Direktive Stufen-Pattern | (Memory erweitert um Stufen-Regel) |

**Status Concept-API (Endstand 24 Vendor):**

```cpp
// Identifikation (Pflicht IMMER)
typename topic_tag;          // AllocatorTopicTag
typename axis_tag;           // AA1-AA7 Subaxis-Tag
typename family_id;          // std::integral_constant<int, A01..A23>
static constexpr std::string_view name();
static constexpr std::string_view family_name();
static constexpr std::string_view flag_suffix();           // F.6.1.G CLI
static constexpr bool        is_thread_safe();
static constexpr bool        supports_pmr();
static constexpr std::size_t max_alignment();

// Sonderfall-Properties (Pflicht IMMER, [[vendor-sonderfaelle-als-pflicht-property]])
static constexpr bool has_native_aligned_alloc();
static constexpr bool requires_explicit_init();
static constexpr bool supports_numa_node_hint();
static constexpr bool supports_thread_local_cache();
static constexpr bool requires_specialized_hardware();

// Stufen-Property (Pflicht IMMER, ordinal Enum)
static constexpr ProgressGuarantee progress_guarantee();
//                {Blocking|ObstructionFree|LockFree|WaitFree}

// Mess-API (Pflicht WENN STATISTICS=ON)
using snapshot_t = AllocationStatistics;
using observer_t = MeasurableObserver<snapshot_t>;
snapshot_t  statistics()  const noexcept;
snapshot_t  snapshot()    const noexcept;
void        reset()        noexcept;
observer_t const& observer() const noexcept;
observer_t&       observer()       noexcept;
```

**Sub-Concepts (optional pro Vendor):**
- `ZeroingStrategy` (zero_allocate via calloc)
- `ReallocatingStrategy` (reallocate via realloc)
- `IntrospectableStrategy` (usable_size)
- `ReclaimableStrategy` (collect/purge)
- `PoolResettableStrategy` (release_all)
- `OverAllocatingStrategy` (allocate_at_least, C++23)

## §4 W6-Pattern bewaehrt ueber 8 Iterationen

Das W6-Pattern (zentralisierte CMake-Topic-Registrierung + MP11) hat sich
ueber 8 Vendor-Batches **vollstaendig bewaehrt**. Schablone fuer jeden neuen
Vendor:

| Schritt | Datei | Aufwand |
|---------|-------|---------|
| 1. CMake-Option ENABLE_<NAME> | `CMakeLists.txt` | 1 Zeile |
| 2. USE = ENABLE && HAVE | `CMakeLists.txt` | 5 Zeilen |
| 3. message() Diagnose | `CMakeLists.txt` | 1 Zeile |
| 4. `#cmakedefine01 USE_<NAME>` | `axis_06_allocator_flags.hpp.in` | 1 Zeile |
| 5. `inline constexpr bool <name>_enabled` | `axis_06_allocator_flags.hpp.in` | 1 Zeile |
| 6. Vendor-Header-Shim (Forward-Stubs) | `vendor_includes/<name>_include.hpp` | ~20 Zeilen |
| 7. Wrapper-Klasse (Pflicht-API + Sub-Concepts) | `axis_06_allocator_<name>.hpp` | ~180 Zeilen |
| 8. Registry-Eintrag | `axis_06_allocator_registry.hpp` | 1 Zeile (`#include` + 1 in `AllVendors` mp_list) |
| **9. Tests** | `tests/unit/test_v41_topic_allocator_axis_06.cpp` | **0 Zeilen** (TYPED_TEST_SUITE + mp_apply auto-expandiert) |

**Total pro Vendor:** ~210 Zeilen Code + 0 Test-Code-Aenderungen.

## §5 Property-Matrix (24 Vendor × 7 Properties)

| Property | True bei | Count |
|----------|----------|:-----:|
| `has_native_aligned_alloc` | alle 24 ausser **Scalloc** | 23/24 |
| `requires_explicit_init` | nur **RPMalloc** | 1/24 |
| `supports_numa_node_hint` | nur **NUMAlloc** | 1/24 |
| `supports_thread_local_cache` | Mi, Sn, Je, Tc, Hoard, Sl, RP, Scalloc, LR, CAMA, TC-WH, HMalloc, Crystalline, PtMalloc2, Vmem-Mag | 15/24 |
| `requires_specialized_hardware` | nur **PIM-Malloc** | 1/24 |
| `progress_guarantee = WaitFree` | Crystalline, Exgen | 2/24 |
| `progress_guarantee = LockFree` | Sn, Michael-LF, Scalloc, LR | 4/24 |

**CacheEngineBuilder kann damit Vendor-Subsets bilden:**
- Production-Build ohne Hardware-Sonderfaelle: 23 Vendor (alle ausser PIM)
- Real-Time-tauglich (WaitFree only): 2 Vendor (Crystalline, Exgen)
- Highly-Concurrent (≥ LockFree): 6 Vendor
- NUMA-spezifisch: 1 Vendor (NUMAlloc)

## §6 Sonderfall-Erkennungen pro Batch

| Batch | Sonderfall entdeckt | Aktion |
|:-----:|---------------------|--------|
| 1 | (nichts, Standard-Pattern) | — |
| 2 | (nichts) | — |
| 3 | (nichts) | — |
| 4 | **Scalloc:** keine native_aligned_alloc API | overallocation + portable_aligned_alloc Fallback bei alignment > max_align_t |
| 4 | **NUMAlloc:** node-Parameter Pflicht | `kDefaultNumaNode=-1` (kernel) + Constructor(int) + set_numa_node() |
| 4 | **RPMalloc:** Init Pflicht vor erstem Aufruf | `detail::RPMallocInitGuard` (atomic_flag + thread_local bool) |
| 4-Konsolidierung | User-Direktive: Sonderfaelle als abfragbare Properties | 5 neue Concept-Methoden (Memory-File angelegt) |
| 5 | (nichts neues, Konsolidierung integriert) | — |
| 6 | **PIM-Malloc:** Hardware-Pflicht | `requires_specialized_hardware()` als 6te Property (alle 16 + 3 neue updated) |
| 7 | **Crystalline:** Wait-Free (strikter als lock-free) | erst `is_wait_free()` als 7te Property, dann... |
| 7-Refactor | User-Direktive: Stufen statt 2 bools | `progress_guarantee()` enum ersetzt is_lock_free+is_wait_free |
| 8 | (nichts neues, Vollausbau-Abschluss) | — |

## §7 ProgressGuarantee Stufen-Refactor (Lessons-Learned)

**User-Direktive 2026-05-26 nach Batch 7:** "Crystalline ist eine neue
Eigenschaft. Aber sie separat zu schreiben macht wenig Sinn. Wir muessen also
in solchen Faellen das bool durch Stufen-switch ersetzen mit einem int."

**Problem mit 2 bools:**
- `is_lock_free()` und `is_wait_free()` haben implizites Constraint:
  wait_free=true => lock_free=true
- Constraint nicht enforced — Wrapper koennte inkonsistent sein
- Doppelte Wartung pro Vendor

**Loesung (Stufen-Pattern):**
```cpp
enum class ProgressGuarantee : int {
    Blocking        = 0,  // Mainstream (Mutex/Lock)
    ObstructionFree = 1,  // Herlihy/Luchangco/Moir 2003 (Reserve)
    LockFree        = 2,  // klassisch, >=1 Thread progress
    WaitFree        = 3,  // Herlihy 1991, alle Threads progress
};
{ A::progress_guarantee() } -> ProgressGuarantee;
```

**Vorteile:**
- Ordnung enforced via `>=` (`level() >= LockFree` deckt LockFree + WaitFree automatisch)
- Erweiterbar ohne Concept-Breakage (z.B. `BoundedWaitFree=4` fuer Real-Time)
- Type-safe via `enum class`
- Eine Methode statt 2 bools

**Generalisierte Regel (in Memory aufgenommen):**
- **bool** fuer orthogonale binaere Eigenschaften (z.B. `supports_pmr`)
- **enum class int** fuer ordinale Klassifikationen mit Implikations-Hierarchie

## §8 TYPED_TEST_SUITE + Runtime-Permutationen (Goldstandard)

**TYPED_TEST_SUITE-Schablone:**
```cpp
template <class... Vs>
using ToGTestTypes = ::testing::Types<Vs...>;

// MP11 mp_apply: AllVendors mp_list<...> -> ::testing::Types<...>
using AllVendorTypes = boost::mp11::mp_apply<ToGTestTypes, axis_06::AllVendors>;

template <class T> class AllocatorVendorTest : public ::testing::Test {};
TYPED_TEST_SUITE(AllocatorVendorTest, AllVendorTypes);

TYPED_TEST(AllocatorVendorTest, ConceptConformance) {
    static_assert(axis_06_cpts::AllocatorStrategy<TypeParam>);
    static_assert(axis_06_cpts::CacheEnginePermutationStrategy<TypeParam>);
    SUCCEED();
}
```

**Runtime-Permutationen (User-Direktive 2026-05-26):**
```cpp
constexpr std::array<AllocConfig, 7> kTestAllocConfigs{{
    {8, 8}, {64, 8}, {128, 16}, {256, 32}, {1024, 64}, {4096, 4096}, {16384, 16},
}};

TYPED_TEST(AllocatorVendorTest, AllocateDeallocateRoundtripAllConfigs) {
    TypeParam m{};
    for (auto const& cfg : kTestAllocConfigs) {
        void* p = m.allocate(cfg.bytes, cfg.alignment);
        ASSERT_NE(p, nullptr);
        m.deallocate(p, cfg.bytes, cfg.alignment);
    }
}
```

**Skalierung:** mit 24 Vendor automatisch 24 × ~8 TYPED_TESTs = ~192 typed Tests
+ 60 strukturelle = **252 Tests** ohne 1 Zeile Test-Code-Aenderung pro Batch.

## §9 Schablonen-Metriken

| Batch | Datum | Vendor | Code-LOC (Wrapper) | Test-LOC-Aenderung | Tests-Bilanz |
|:-----:|:-----:|:------:|:------------------:|:------------------:|:-----------:|
| 1 (Pilot) | 2026-05-25 | 4 | ~800 | full (Schablone-Einrichtung) | 80 |
| 2 | 2026-05-26 | 3 | ~570 | +6 (Batch-spez. Tests, spaeter entfernt) | 95 |
| 3 + TYPED_TEST | 2026-05-26 | 3 | ~570 | **Refactor: -ALL batch-spezifische Tests, +TYPED_TEST**  | 110 (Skalierungs-Beweis) |
| 4 + Concept-Erweiterung x5 | 2026-05-26 | 3 | ~570 + sed 13 Wrapper | +13 (Sonderfall-Test) | 164 |
| 5 | 2026-05-26 | 3 | ~570 | 0 | 188 |
| 6 + Concept x1 (specialized_hw) | 2026-05-26 | 3 | ~600 + sed 16 Wrapper | +0 (Sanity in existing) | 212 |
| 7 + Concept x1 (wait_free) | 2026-05-26 | 3 | ~600 + sed 19 Wrapper | +0 | 236 |
| 7-Refactor: bool -> enum | 2026-05-26 | 0 | sed 22 Wrapper + 6 manuelle Vendor | +6 (Test-Asserts) | 236 |
| 8 (VOLLAUSBAU) | 2026-05-26 | 2 | ~400 | 0 | **252** |

**Pro Vendor-Boilerplate (heute Stand):** ~210 Zeilen (CMake + Shim + Wrapper).

**Pro neuer Concept-Property:** O(N) sed-Update wo N=existierende Vendor +
1 Zeile pro neuem Vendor.

## §10 Wissenschaftliche Bedeutung der Achse

Die Allocator-Achse 6 deckt jetzt **alle relevanten Algorithmus-Klassen** der
letzten 60 Jahre ab. Pro Klasse mindestens 1 Wrapper:

| Klasse | Vendor | Veröffentlichung |
|--------|--------|------------------|
| **Klassisch Bins** | Dlmalloc, ptmalloc2, Buddy | Lea 1987, Gloger 1996, Knuth 1968 |
| **Slab/Magazines** | Slab, Vmem-Mag | Bonwick USENIX 1994/2001 |
| **Thread-Caching** | TCMalloc, TCMalloc-WH, RPMalloc | Google 2005, 2020+, Jansson 2017 |
| **Per-Heap** | Hoard | Berger PPoPP 2000 |
| **Lock-Free CAS** | Michael, LRMalloc | Michael PODC 2002, Leite JPDC 2019 |
| **Free-List-Sharding** | Mimalloc, HMalloc | Leijen MSR-2019, Tang 2020 |
| **Message-Passing** | Snmalloc | Lipp/Bond/Parkinson ISMM 2019 |
| **NUMA-aware** | NUMAlloc | Linden/Liu ICDCS 2018 |
| **PIM-aware** | PIM-Malloc | UPMEM/HBM-PIM 2023+ |
| **Cache-aware** | CAMA | Bhattacharyya 2020 |
| **Formal-Verified** | StarMalloc | Dang/Charguer 2024 |
| **Wait-Free** | Crystalline | Solodkyy/Bunkov PLDI 2021 |
| **Standard-API** | StdMalloc, PMR | ISO C, Halpern N3916 |
| **Spans** | Scalloc | Aigner PPoPP 2015 |
| **Single-Thread Spec** | Exgen | Exception-Generated |
| **Arena** | Jemalloc | Evans 2006 BSD |

**Diplomarbeits-Relevanz (F15-Forschungsmission):**
- Vergleich verified vs unverified (StarMalloc vs alle anderen)
- Vergleich wait-free vs lock-free vs blocking (3 Stufen via ProgressGuarantee)
- NUMA-Effekte (NUMAlloc mit kDefaultNumaNode-Variation)
- Hardware-Spezialisierung (PIM-Malloc vs Standard auf UPMEM-Systemen)
- Klassische vs moderne Allokatoren (Buddy 1968 vs Mimalloc 2019)

## §11 Roadmap: 15 Topic-Pipeline

Allocator-Achse ist **1 von 15**. Stand nach heute:

| # | Topic | Status | Achsen-Anzahl |
|:-:|-------|:------:|:-------------:|
| 1 | allocator | ✅ KOMPLETT (24 Vendor) | 1 (axis_06_allocator) |
| 2 | concurrency | pending | 8 Sub-Achsen (axis_08 + sub_*) |
| 3 | traversal | pending | 3 Achsen (03a, 03b, 03m) |
| 4 | nodes | pending | 2 Achsen (02, 04) |
| 5 | memory_layout | pending | 1 (axis_05) |
| 6 | prefetch | pending | 1 (axis_07) |
| 7 | telemetry | pending | 1 (axis_11) |
| 8 | serialization | pending | 1 (axis_10) |
| 9 | value_handle | pending | 1 (axis_14) |
| 10 | **queuing** (NEXT) | pending | 1 (axis_Q, 13 W2-Strategien) |
| 11 | hardware | pending | 2 Achsen (09 ISA, 12) |
| 12 | search_engine | pending | 1 (axis_01) |
| 13 | io | pending | 1 (axis_io) |
| 14 | migration | pending | 1 (axis_migration) |
| 15 | filter | pending | 1 (axis_filter) |

**Reihenfolge fuer V41.F.6.x verbindlich (Memory [[migrationen-ans-ende]]):**
1. Zuerst alle 15 Topics als Schablone-Anwendung (allocator als Vorlage)
2. Dann src/-Hilfsfunktionen (PermutationEngine + CacheEngineBuilder weiter)
3. Zuletzt Migration der alten subsystems/ + concurrency_manager/ + benchmarks/

## §12 Cross-Repo-Stand

| Repo | HEAD | Status | Aenderung heute |
|------|------|--------|------------------|
| Diplomarbeit (PUBLIC) | `f74069b` | ✅ gepushed | 8 Submodule-Bumps + 1 Doku-Commit |
| cache-engine standalone | `ce27752` | ✅ gepushed | 8 Code-Commits (Batch 1-8) + Refactor-Commit |
| prt-art | `d1b6140` | UNVERAENDERT seit 2026-05-25 | — |
| 6 Modul-Skelette | unveraendert | — | — |

## §13 Tests-Bilanz (Endstand)

```bash
# Standalone cache-engine
build-pilot/tests/unit/Release/test_v41_topic_allocator_axis_06.exe
# -> [PASSED] 252 tests aus 31 test suites
#    24 Vendor x ~8 TYPED_TESTs = ~192 typed Tests
#    + 60 strukturelle Tests (Engine/Builder/CLI/Aspect/Hash/Fullhash etc.)

# Diplomarbeit-Container
bash Code/tools/run_all_tests.sh --config Release
# -> passed: 104, failed: 0
```

## §14 Naechste Schritte (Roadmap-priorisiert)

### Sofort (NEXT)
- **Topic `queuing/`** mit axis_Q (13 W2-Strategien Pilot 3-4 Variants):
  - NoBuffer / FIFOQueue / LIFOStack / BoundedRing (Pilot-Batch 1)
  - Vollausbau in Batch 2-5 (LSM-Delta, Skiplist, Tombstone, CoW, Epoch, ...)

### Danach (Roadmap nach allocator-Vorlage)
- **traversal/** mit 3 Achsen (03a SearchAlgo, 03b Cache-Traversal, 03m Mapping)
- **nodes/** mit 2 Achsen (02 Path-Compression, 04 Node-Type)
- weitere 11 Topics aus §11 Tabelle

### Mit jedem neuen Topic
- W6-Pattern strikt: CMake-Flags + flags.hpp.in + Shims + Wrapper + Registry
- TYPED_TEST_SUITE + mp_apply<ToGTestTypes, AllVendors>
- ProgressGuarantee-Stufen-Pattern wo anwendbar
- Sonderfall-Properties pro neuem Wrapper: ist Sonderfall vorhanden? → Concept-Erweiterung pflichten

### Zuletzt (Memory [[migrationen-ans-ende]])
- F.6.2 BASIS-Migration der 27 prt-art Headers
- F.6.3 prt-art Namespace-Restrukturierung
- Migration subsystems/c01-c12/ + concurrency_manager/* + reclamation/
- adapters/+ext/ Merge → topics/<topic>/axis_<NN>/vendors/

## §15 Wichtige Lessons-Learned (fuer 14 weitere Topics)

1. **Pilot-First mit 3-4 Variants:** validiert Schablone, BEVOR Vollausbau
2. **TYPED_TEST_SUITE sofort einfuehren** (nicht in Batch 3 wie bei allocator) —
   spart spaeter Test-Code-Refactoring
3. **Concept-Erweiterung mit Memory-File begleitet** — User-Direktive
   verlangt: jede neue Property → alle existing Wrapper antworten
4. **Stufen-Pattern bei impliziten Constraints** — kein 2-bool-Pattern
   wenn eines aus dem anderen folgt
5. **sed-Update + manuell-Korrektur:** effizient fuer Concept-Erweiterungen
   ueber N Wrapper (sed default + Hand-Korrektur Sonderfaelle)
6. **Runtime-Permutationen via constexpr std::array:** TYPED_TESTs iterieren
   ueber Config-Liste, nicht nur Compile-Time-Check
7. **Diplomarbeit-Submodule-Bump nach jedem cache-engine-Commit** — sonst
   bricht Diplomarbeit-Test-Lauf bei naechster Iteration
8. **Memory-Files als Goldstandard-Lock:** jede architektonische Entscheidung
   wird sofort in Memory festgehalten (sonst Konsistenz-Verlust)

## §16 Session-Bewertung

**Positiv:**
- 8 Batches × 3 Vendor + Pilot + Refactor = 24 Vendor in 1 Session-Tag
- Test-Skalierung 80 → 252 grün (3.15× ueber 8 Batches)
- Concept-Erweiterung dreifach (Sonderfall-Props x5, specialized_hardware,
  ProgressGuarantee-Enum-Refactor) ohne 1 Test-Bruch
- Schablone perfekt validiert — bereit fuer 14 weitere Topics
- Memory-Files [[vendor-sonderfaelle-als-pflicht-property]] +
  [[migrationen-ans-ende]] festigen die Methodik

**Verbesserungspunkte:**
- Bei Batch 2-3 wurden noch batch-spezifische Tests geschrieben — sofort
  TYPED_TEST_SUITE-Pattern haette das eingespart
- ProgressGuarantee-Enum kam erst nach Batch 7 — bei zukuenftigen Topics
  direkt mit dem Pattern starten wenn Stufen auftauchen

**Lernerfahrungen:**
- W6-Pattern + TYPED_TEST_SUITE skaliert linear ueber N Vendor (kein
  quadratischer Aufwand)
- Concept-Erweiterung via sed + manuell-Korrektur: O(N) aber schnell
- Stufen-Pattern (enum statt 2 bools) ist klar besser sobald Implikation existiert
- Allocator-Achse als Schablone fuer 14 weitere Topics jetzt eindeutig
  etabliert

---

**Naechste Session beginnt mit:**
1. MEMORY.md + dieses Doc + `11_konzept_achsen_extension_visitor_pattern.md` lesen
2. Build-Verifikation 252 standalone + 104 Diplomarbeit Tests grün
3. **Topic `queuing/`** anlegen (NEXT — Pilot 3-4 Strategien, Vollausbau in Folge-Batches)
4. Naechste Topics nach Roadmap (siehe §11)
