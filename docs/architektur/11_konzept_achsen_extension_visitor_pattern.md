# Architektur-Skizze: 2-Ebenen-Achsen + Pruefling-Namespace-Extension + Visitor-Permutation

**Status:** SKIZZE zur User-Abstimmung (V41.F.6.1)
**Datum:** 2026-05-25
**Verbunden mit:** V41.F.6 P0 Migration, V41.F.2 Namespace-Restrukturierung, V41.E11 Master-Framework Facade
**User-Direktive 2026-05-25:** "Wir muessen erst nach Cache Engine migrieren und dann davon ableiten" + "statische Metaprogrammierung durch CacheEngineBuilder Pre-compile Permutation" + "concept System zur Absicherung der Metaprogrammierung"
**Zweck:** Dieses Dokument klaert das Pattern fuer cache-engine ↔ Pruefling (prt-art) BEVOR Code geschrieben wird, um die zwei aufeinanderfolgenden Architektur-Fehler vom 25.05. zu vermeiden.

---

## §1 Probleme die geloest werden muessen

1. **Migrations-Reihenfolge:** Bisher wurde prt-art-Code geschrieben **ohne** Basis in cache-engine. Korrekt: cache-engine zuerst (Vererbungsgrundlage), dann prt-art als Spezialisierung.
2. **Dispatch-Pattern:** Bisheriger Versuch war Monolith mit `std::variant` + Runtime-Switch (DYNAMISCH). User-Direktive: **statische Metaprogrammierung** via Template-System.
3. **Concept-Absicherung:** Bisher kein concept-System. Concepts (C++23) garantieren dass jede Klasse die erwartete API erfuellt — kompiliert nicht falls Vertrag verletzt.
4. **Pruefling-Erweiterung:** Wie kann ein Pruefling (prt-art) optional eine Achse ueberschreiben, ohne dass cache-engine ihn kennen muss?

---

## §2 Konzept-Vorschlag: 4 zusammenwirkende Patterns

### 2.1 Pattern A — Concepts pro Achse (C++23)

Pro Achse ein concept das die API absichert.

```cpp
// libs/cache_engine/axes/traversal/concepts/i_search_algo_concept.hpp
namespace comdare::cache_engine::traversal::concepts {

template <typename T>
concept SearchAlgoVariant = requires(T t, std::uint16_t d, std::uint64_t c) {
    { t.insert(d, c) }                 -> std::same_as<void>;
    { t.lookup(d) }                    -> std::same_as<std::optional<std::uint64_t>>;
    { t.erase(d) }                     -> std::same_as<void>;
    { t.occupied_count() }             -> std::same_as<std::size_t>;
    { t.density_percent() }            -> std::same_as<double>;
};

}  // namespace comdare::cache_engine::traversal::concepts
```

Jede konkrete Klasse (Array256, Array65535, VectorU8U8, VectorU16U16, prt-art's eigene Varianten) muss diesem Concept genuegen, indem er die Achsen unter den Hauptkategorien als Permutative Basis der Erstellung eines Suchlagorithmus (map<key,value> oder als Liste mit den interfaces von std::vector<T> bereitstellt). Falls eine Hauptkategorie -> Achse -> Klassen-Achsenimplementierung das Concept nicht erfuellt, **kompiliert sie nicht** in der Permutations-Liste. Vertrag ist Compile-Time-absichert.

### 2.2 Pattern B — Basis-Interface (CRTP oder einfache Vererbung)

```cpp
// libs/cache_engine/axes/traversal/i_traversal_strategy.hpp
namespace comdare::cache_engine::traversal {

// CRTP-Basis fuer Compile-Time-Polymorphie (kein virtual, keine vtable)
template <typename Derived>
class TraversalStrategyBase {
public:
    void insert(std::uint16_t d, std::uint64_t c) {
        static_cast<Derived*>(this)->insert_impl(d, c);
    }
    std::optional<std::uint64_t> lookup(std::uint16_t d) const {
        return static_cast<const Derived*>(this)->lookup_impl(d);
    }
    // ...
};

}  // namespace comdare::cache_engine::traversal
```

CRTP (Curiously Recurring Template Pattern) erlaubt:
- Compile-Time-Polymorphie (kein virtual call)
- Zero-Cost-Abstraction
- Inlining moeglich

**Alternative:** Pures Concept ohne Basis-Interface. Klassen sind unabhaengig, nur durch Concept verbunden. Schlanker, aber keine gemeinsame Default-Implementation moeglich.

**❓ FRAGE 1 an User:** CRTP vs reines Concept-System? CRTP bietet Default-Methoden, Concept bietet Freiheit.

Antwort: Wir verwenden ein CRTP, dessen Typisierung durch ein Concept System abgesichert ist. Jede Ebene bzw. Ordner von Hauptkategorie -> Achsen hat seine eigene Registrierung und Spezifizierung an Concepts, welche durch die Achsenimplementierung erfüllt und bereitgestellt wird.

### 2.3 Pattern C — Permutations-Visitor mit Compile-Time-Registrierung

```cpp
// libs/cache_engine/permutations/permutation_visitor.hpp
namespace comdare::cache_engine::permutations {

// Statische Achsen-Variant-Liste pro Achse, gefuellt zur Compile-Time
template <typename... Variants>
struct AxisVariantList {
    using Tuple = std::tuple<Variants...>;
    static constexpr std::size_t count = sizeof...(Variants);
};

// Visitor besucht jede Variante einer Achse zur Compile-Time
template <typename AxisList, typename Visitor>
constexpr void for_each_variant(Visitor&& v) {
    [&]<std::size_t... I>(std::index_sequence<I...>) {
        (v.template visit<std::tuple_element_t<I, typename AxisList::Tuple>>(), ...);
    }(std::make_index_sequence<AxisList::count>{});
}

}  // namespace comdare::cache_engine::permutations
```

Ein **Visitor** wird per Compile-Time-Fold-Expression ueber alle Achsen-Varianten "besucht" — alle Permutationen werden statisch enumeriert. Das ist die statische Metaprogrammierung die User fordert.

### 2.4 Pattern D — Namespace-Slot mit Compile-Time-Fallback

Pro Achse wird ein **optionaler Namespace** definiert. Wenn der Pruefling diesen mit eigenen Varianten fuellt, werden sie ZUSAETZLICH zu den cache-engine-Defaults registriert. Wenn der Namespace leer bleibt, faellt das System auf cache-engine-Defaults zurueck.


```cpp
// libs/cache_engine/axes/traversal/registry.hpp
namespace comdare::cache_engine::traversal {

// Default-Varianten (immer da)
using DefaultVariants = AxisVariantList<
    Array256, Array65535, VectorU8U8, VectorU16U16
>;

// Pruefling-Namespace-Slot
namespace optional_prt_art_impl {
    // wird vom Pruefling befuellt — leer wenn kein Override
    // Pruefling fuegt z.B. struct AccelArray256 ein
}

// Compile-Time-Detection: pruefe ob Pruefling-Namespace etwas enthaelt
// (via SFINAE oder concept-check)
template <typename T = int>
constexpr bool prt_art_provides_traversal_v = requires {
    typename optional_prt_art_impl::PruefingVariants;
};

// Effective-Variants:
//   wenn Pruefling vorhanden -> Default + Pruefling
//   sonst -> Default
using EffectiveVariants = std::conditional_t<
    prt_art_provides_traversal_v<>,
    AxisListAppend<DefaultVariants, typename optional_prt_art_impl::PruefingVariants>,
    DefaultVariants
>;

}  // namespace comdare::cache_engine::traversal
```

Der Pruefling registriert seine Varianten so:

```cpp
// comdare-prt-art/include/prt_art/traversal_extension.hpp
namespace comdare::cache_engine::traversal::optional_prt_art_impl {

struct PrtArtAcceleratedArray256 { /* ... */ };

using PruefingVariants = AxisVariantList<PrtArtAcceleratedArray256>;

}  // namespace comdare::cache_engine::traversal::optional_prt_art_impl
```

Wenn comdare-prt-art als Submodule in der Diplomarbeit eingebunden ist und der Header includiert wird, ist `prt_art_provides_traversal_v == true`, sonst false. Compile-Time-Auswahl.

**❓ FRAGE 2 an User:** Soll der Pruefling die Defaults ERSETZEN, ERWEITERN (Anhang), oder soll der Pruefling pro Variante explizit sagen "ersetze Default-Variant X durch meine Y"?

Kommentar des Users: Exakt. Wenn also eine Achse keine eigenen Prüflings-Implementierungen anbietet, werden die cache-engine Permutationen VOLLSTÄNDIG als fallback verwendet, als wären es die eigenen Implementierungen des Prüflingsalgorithmus der Achse des Prüflings. Es gibt für die LISTE der Prüflinge jeweils eine Metaprogrammierung der Registrierung und wir unterscheiden IMMER zwischen den cache-engine Implementierungen und den Prüflings-Implementierungen.
Wir haben in der vergangenen Dokumentation (bitte suchen und weiträumiger nachlesen) festgelegt, dass im Experiment default erst die cache-engine mit all ihren Varianten allein permutiert, gebaut und gemessen wird; danach ausschließlich die Prüflinge EINZELN wie prt-art (Fremdnutzung aller Permutationen einer Achse aus cache-engine wenn keine eigenen Überschreibungen in einer Achse stattfinden), zum Schluss die builds und Experimente eines full join aus der Permutation der cache-engine gegen alle machbaren nicht-redundanten Permuationen der cache-engine gegen eingerichtete Prüflinge (PLURAL! -> multiple Prüflinge möglich parallel in einem Durchlauf des Gesamtaufbaus).

### 2.5 Pattern E — CacheEngineBuilder Pre-Compile-Permutations-Generator

```cpp
// libs/cache_engine/builder/permutation_compiler.hpp
namespace comdare::cache_engine::builder {

// Erzeugt alle Permutationen aus den 14 Achsen zur Compile-Time
template <typename... AxisLists>
struct PermutationCompiler {
    // Cartesian-Product aller Achsen-Listen
    using AllPermutations = cartesian_product_t<AxisLists...>;

    // Visitor-Pattern: rufe func<P>() fuer jede Permutation P auf
    template <typename Visitor>
    static constexpr void visit_all(Visitor&& v) {
        std::apply([&](auto... Perms) {
            (v.template visit<decltype(Perms)>(), ...);
        }, AllPermutations{});
    }
};

// Beispiel-Usage:
using AllAxes = PermutationCompiler<
    traversal::EffectiveVariants,
    layout::EffectiveVariants,
    allocator::EffectiveVariants,
    // ... alle 14 Achsen
>;

// Build-Time wird der Codegen das durchlaufen + perm_<id>.so/.dll erzeugen
}
```

Das gibt der CacheEngineBuilder als Pre-Compile-Logik die User-Direktive verlangt.

---

## §3 KORRIGIERTE Hierarchie (nach User-Antwort 3, 2026-05-25)

**KEIN separates `axes/`-Verzeichnis.** Topics enthalten Achsen direkt als Unterordner. Mindestens eine Achse pro Topic. Hilfsfunktionen ohne Achsen liegen unter `src/`.

```
libs/cache_engine/
├── topics/                       # Hauptkategorien (mind. 1 Achse je Topic)
│   │
│   ├── allocator/                # Hauptkategorie Allocator
│   │   ├── concepts/             # Topic-Ebene Concepts (gemeinsame Vertraege)
│   │   ├── axis_06_allocator/    # Achse 6 (mit 5 Sub-Achsen)
│   │   │   ├── concepts/         # Achsen-Ebene Concepts
│   │   │   ├── i_allocator_strategy.hpp  # CRTP-Basis-Interface
│   │   │   ├── default_variants/         # cache-engine Standards (BASIS)
│   │   │   │   ├── std_malloc.hpp
│   │   │   │   ├── mimalloc.hpp
│   │   │   │   └── ...
│   │   │   ├── sub_61_alloc_lib/        # Sub-Achse 6.1
│   │   │   ├── sub_62_reclamation/      # Sub-Achse 6.2
│   │   │   ├── sub_63_numa/             # Sub-Achse 6.3
│   │   │   ├── sub_64_huge_page/        # Sub-Achse 6.4
│   │   │   └── sub_65_strategy/         # Sub-Achse 6.5
│   │   └── src/                  # Hilfsfunktionen ohne Achsen (z.B. PoolDescriptor)
│   │
│   ├── concurrency/              # Hauptkategorie Concurrency
│   │   ├── concepts/
│   │   ├── axis_08_concurrency/  # Achse 8 (mit 2 Sub-Achsen)
│   │   │   ├── concepts/
│   │   │   ├── i_concurrency_strategy.hpp
│   │   │   ├── default_variants/
│   │   │   ├── sub_81_concurrency_basic/
│   │   │   └── sub_82_locking_mode/
│   │   └── src/                  # z.B. OLC-RAII-Guards
│   │
│   ├── traversal/                # Hauptkategorie Traversal (3 Achsen)
│   │   ├── concepts/
│   │   ├── axis_03a_search_algo/   # Density-basierte Sub-Search-Dispatch
│   │   │   ├── concepts/
│   │   │   ├── i_search_algo_concept.hpp
│   │   │   └── default_variants/   # Array256, Array65535, VectorU8U8, VectorU16U16
│   │   ├── axis_03b_cache_traversal/  # Default-Lookup Achse 3.B
│   │   │   └── default_variants/
│   │   └── axis_03m_traversal_mapping/  # Mapping-Achse 3.M
│   │       └── default_variants/    # VirtualOffsetAddress-Mapping
│   │
│   ├── nodes/                    # Hauptkategorie Node-Typen (Achse 4)
│   │   ├── axis_04_node_type/
│   │   │   └── default_variants/   # BPlusNode, RedirectNode
│   │   └── src/                  # Density-Reklassifizierung Utility
│   │
│   ├── memory_layout/            # Hauptkategorie Layout (Achse 5)
│   │   ├── axis_05_memory_layout/
│   │   │   └── default_variants/   # AoS, SoA, hybrid (V41.A4 AoSoA)
│   │   └── src/                  # BytePath, CacheLineAlignedLayout, VirtualOffsetAddress
│   │
│   ├── prefetch/                 # Hauptkategorie Prefetch (Achse 7)
│   │   ├── axis_07_prefetch/
│   │   │   └── default_variants/   # PathOriented, Redirect, DistanceEstimator
│   │   └── src/
│   │
│   ├── telemetry/                # Hauptkategorie Telemetrie (Achse 11)
│   │   ├── axis_11_telemetry/
│   │   │   └── default_variants/   # LeafOnlyCounter (Kuehn X1), PerNode (Anti-Pattern X4)
│   │   └── src/
│   │
│   ├── serialization/            # Hauptkategorie Serialisierung (Achse 10?)
│   │   ├── axis_10_compression/
│   │   │   └── default_variants/   # SignalingBits + VarLen
│   │   └── src/
│   │
│   ├── value_handle/             # Hauptkategorie ValueHandle (Achse 14)
│   │   ├── axis_14_value_handle/
│   │   │   └── default_variants/   # Inline, External, ChainRef + CostModel
│   │   └── src/
│   │
│   ├── value_buffer/             # ❓ Welche Achse? Siehe Rueckfrage RQ-3
│   │   └── src/
│   │
│   ├── identity/                 # ❓ Hat eine Achse oder nur src/? Siehe Rueckfrage RQ-4
│   │   └── src/
│   │
│   ├── measurement/              # ❓ Welche Achse? Siehe Rueckfrage RQ-5
│   │   └── src/
│   │
│   ├── default_lookup/           # ❓ Eigenstaendiges Topic oder Marker in andere Topics? Siehe Rueckfrage RQ-6
│   │   └── ...
│   │
│   ├── internal_search/          # ❓ Eigenstaendig oder Sub von traversal/? Siehe Rueckfrage RQ-7
│   │   └── ...
│   │
│   └── (weitere Achsen 1, 2, 9, 12, 13 - siehe Rueckfrage RQ-2 fuer Topic-Zuordnung)
│
└── src/                          # Globale Hilfsfunktionen ohne Achsen
    ├── builder/                  # CacheEngineBuilder (Pre-Compile-Permutator)
    ├── permutations/             # PermutationVisitor, AxisVariantList
    ├── abi/                      # ABI-Layer (execution_engine, search_engine)
    ├── api/                      # Facade (ICacheEngine, IPrueflingFactory)
    └── ...
```

**Pruefling-Namespace pro Achse:**

Jedes `axes/<axis_NN>/` Verzeichnis hat zusaetzlich `optional_<pruefling>_impl/` Slot fuer Pruefling-Override:

```
topics/allocator/axis_06_allocator/
├── ...
├── default_variants/          # cache-engine Standards (immer da)
└── optional_prt_art_impl/     # prt-art kann hier eigene Allokator-Varianten reinhaengen
                               # leer = cache-engine-Defaults werden als Fallback verwendet
```

### §3.1 NEUE Rueckfragen aus Hierarchie-Korrektur

Bevor F.6.1.A startet, muss diese Topic-Zuordnung mit User abgestimmt werden:

**RQ-1:** Topic-Concepts und Achsen-Concepts sind beides vorhanden. Hat das Topic ein eigenes "Topic-Concept" das alle Achsen-Concepts darunter erfuellen muessen, oder existieren Topic-Concepts nicht und nur Achsen-Concepts werden geprueft? (Vorschlag: Beides — Topic-Concept ist breit ("alle haben insert/lookup"), Achse-Concept ist enger ("Allocator hat allocate/deallocate")).

**RQ-2:** Topic-Zuordnung der noch nicht zugeordneten Achsen:
- Achse 1 (Index-Organization) → eigenes Topic? Oder unter `traversal/`?
- Achse 2 (Path-Compression) → eigenes Topic? Oder unter `nodes/`?
- Achse 9 (ISA) → eigenes Topic `isa/`? Oder unter `src/abi/`?
- Achse 12 (Hardware-Strategy) → eigenes Topic? Oder unter `src/`?
- Achse 13 (Scheduling-Strategy) → eigenes Topic? Oder unter `src/`?

**RQ-3:** Hat `value_buffer/` eine eigene Achse oder ist es nur Hilfsfunktion (`src/`)? In Bausteine-Matrix nicht eindeutig.

**RQ-4:** Hat `identity/` eine eigene Achse, oder ist es eine Pruefling-Identifikation die unter `src/` (oder unter dem Pruefling-spezifischen Repo) liegt?

**RQ-5:** Hat `measurement/` eigene Achsen, oder ist es Mess-Infrastruktur (gehoert dann zu `comdare-measurement` Submodule)?

**RQ-6:** `default_lookup/` ist nach Audit ein **Vermittler** zwischen prt-art und cache-engine-Achsen (3.B, 6.2-6.4, 8.2, 9, 11, 12, 13). Bleibt es als eigenes Topic in cache-engine, oder werden die 9 Marker direkt in die jeweiligen Achsen-Verzeichnisse migriert (z.B. `topics/allocator/axis_06_allocator/sub_62_reclamation/` enthaelt dann die `prt_art_uses_default.hpp` Marker)?

**RQ-7:** `internal_search/` (Array256, Array65535, VectorU8U8, VectorU16U16) sind die default_variants/ der Achse 3.A SearchAlgo-Traversal. Bleibt es als eigenes Topic oder wandert es als `topics/traversal/axis_03a_search_algo/default_variants/`?

**RQ-8:** `src/` global vs. `src/` pro Topic — beides parallel? Hilfsfunktion die ueber mehrere Topics genutzt wird (z.B. `VirtualOffsetAddress` von memory_layout + traversal): liegt sie global oder im Topic mit "Haupt-Owner"?

**RQ-9:** Sub-Achsen wie 6.2 (Reclamation): bekommt das eigene `default_variants/` + eigenes `optional_prt_art_impl/`, oder erbt die Sub-Achse die Slots der Eltern-Achse 6?

---

## §3.5 3-Stufen-Pruefungs-Modell (User-Antwort 2 + V41.F.5)

User-Klarstellung 2026-05-25:
> "Im Experiment default erst die cache-engine mit all ihren Varianten allein permutiert, gebaut und gemessen wird; danach ausschliesslich die Prueflinge EINZELN wie prt-art (Fremdnutzung aller Permutationen einer Achse aus cache-engine wenn keine eigenen Ueberschreibungen in einer Achse stattfinden), zum Schluss die builds und Experimente eines full join aus der Permutation der cache-engine gegen alle machbaren nicht-redundanten Permuationen der cache-engine gegen eingerichtete Prueflinge (PLURAL! -> multiple Prueflinge moeglich parallel in einem Durchlauf des Gesamtaufbaus)."

```
Stufe 1: cache-engine-only
   EffectiveVariants pro Achse = DefaultVariants (ohne Pruefling-Erweiterung)
   Target: comdare_perms_ce
   Anzahl: Σ pro Achse (#DefaultVariants) als Kartesisches Produkt

Stufe 2: Pruefling EINZELN (pro Pruefling ein Build)
   Fuer prt-art:
     EffectiveVariants pro Achse =
       if (prt_art liefert in dieser Achse Override)
          PrtArtVariants
       else
          DefaultVariants    # <-- Compile-Time-Fallback, transparent!
   Target: comdare_perms_pa (fuer prt-art)
           comdare_perms_<pruefling2>, ...
   Bei mehreren Prueflingen: pro Pruefling separater Build

Stufe 3: Full Join (Multi-Pruefling)
   EffectiveVariants pro Achse =
       DefaultVariants ∪ PrtArtVariants ∪ Pruefling2Variants ∪ ...
   Target: comdare_perms_all (existiert, aber neu definiert als "non-redundant join")
   Wichtig: nicht-redundant, d.h. wenn ein Pruefling eine Default-Variante reuses,
            wird sie nur einmal gezaehlt
```

**Compile-Time-Logik fuer "ERSETZT-mit-Fallback" pro Stufe (User-Antwort 2):**

```cpp
namespace comdare::cache_engine::allocator::axis_06_allocator {

using DefaultVariants = AxisVariantList<StdMalloc, MiMalloc, JeMalloc, ...>;

// Pruefling-Slot (leer wenn nicht ueberschrieben)
namespace optional_prt_art_impl {
    // Hier definiert prt-art seine PruefingVariants oder garnichts
}

// Pruefe ob Pruefling den Slot gefuellt hat
template <typename = void>
constexpr bool prt_art_overrides_axis_v = requires {
    typename optional_prt_art_impl::PruefingVariants;
};

// Stufe 1: cache-engine-only
using Stage1_Variants = DefaultVariants;

// Stufe 2: prt-art einzeln (ERSETZT pro Achse, sonst Fallback)
using Stage2_PrtArt_Variants = std::conditional_t<
    prt_art_overrides_axis_v<>,
    typename optional_prt_art_impl::PruefingVariants,  // Pruefling-Varianten ALLEIN
    DefaultVariants                                     // Fallback komplett
>;

// Stufe 3: Full Join (alle Prueflinge + Defaults non-redundant)
using Stage3_FullJoin_Variants = UnionNonRedundant<
    DefaultVariants,
    optional_prt_art_impl_or_empty_v<>,
    optional_pruefling2_impl_or_empty_v<>,
    ...
>;

}
```

**Wichtig:** "ERSETZT" gilt nur fuer Stufe 2 — Pruefling-Varianten ALLEIN, Defaults werden ueberlagert pro Achse. Fallback greift wenn Pruefling diese Achse nicht ueberschreibt. Stufe 3 dagegen vereinigt alle.

**Mess-Reihen-Mapping zu §5 PRT-ART 3-Stufen-System (REV7 §6):**
- Stufe 1 ≈ Messreihe B (cache-engine-Permutationen)
- Stufe 2 ≈ Messreihe A (PRT-ART vs SOTA-Varianten in CE-Achsen)
- Stufe 3 ≈ Messreihe C (gemischte Vollausbau)

---

## §3.6 CRTP + Concept-Guard Konsolidierung (User-Antwort 1)

User-Antwort: **Mix — CRTP-Basis-Klasse, deren Derived-Parameter durch Concept-Constraint abgesichert ist.** Pro Hierarchie-Ebene (Topic, Achse) eigene Concepts.

```cpp
// 1. TOPIC-Ebene: breites Concept (z.B. "alle Topics-Komponenten muessen API X haben")
namespace comdare::cache_engine::allocator::concepts {

template <typename T>
concept AllocatorComponent = requires(T t) {
    { t.allocate(std::size_t{}) } -> std::same_as<void*>;
    { t.deallocate((void*)nullptr) } -> std::same_as<void>;
};

}

// 2. ACHSEN-Ebene: enges Concept (spezifisch fuer Achse)
namespace comdare::cache_engine::allocator::axis_06_allocator::concepts {

template <typename T>
concept AllocatorStrategy = AllocatorComponent<T> && requires(T t) {
    // ergaenzt um Achse-spezifische Anforderungen
    { t.pool_kind() } -> std::convertible_to<PoolKind>;
    { t.bytes_in_use() } -> std::same_as<std::uint64_t>;
};

}

// 3. CRTP-Basis-Klasse mit Concept-Guard (Mix)
namespace comdare::cache_engine::allocator::axis_06_allocator {

template <typename Derived>
    requires concepts::AllocatorStrategy<Derived>
class AllocatorStrategyBase {
public:
    // Default-Methoden moeglich (CRTP-Inlining)
    void* allocate(std::size_t bytes) {
        return static_cast<Derived*>(this)->allocate_impl(bytes);
    }
    // ... weitere Default-Methoden
};

// Konkrete Klasse muss Concept erfuellen
class StdMalloc : public AllocatorStrategyBase<StdMalloc> {
public:
    void* allocate_impl(std::size_t bytes) { return std::malloc(bytes); }
    void deallocate(void* p) { std::free(p); }
    PoolKind pool_kind() const { return PoolKind::B_DensePages; }
    std::uint64_t bytes_in_use() const { return /* ... */; }
};

}  // namespace
```

**Compile-Time-Garantien:**
- Wenn `StdMalloc` das `AllocatorStrategy`-Concept nicht erfuellt → `requires` schlaegt fehl → Build-Error mit klarer Diagnostik
- Wenn `StdMalloc` direkt von `AllocatorStrategyBase` erbt aber Concept-Constraint verletzt → Concept-Failure → Build-Error
- Wenn `optional_prt_art_impl::PrtArtAccel` in die `EffectiveVariants` aufgenommen wird, muss es ebenfalls das Achsen-Concept erfuellen

---

## §4 Konkrete Reihenfolge fuer F.6.1 Implementation

```
F.6.1.A  Concepts pro Achse (14 concept-Header-Files)
         |
F.6.1.B  Default-Variants Re-Use (bestehende cache-engine + migrierte prt-art BASIS-Klassen)
         |
F.6.1.C  Namespace-Slot-Mechanik (optional_<pruefling>_impl + Compile-Time-Detection)
         |
F.6.1.D  PermutationVisitor + EffectiveVariants pro Achse
         |
F.6.1.E  CacheEngineBuilder Pre-Compile-Permutations-Generator
         |
F.6.1.F  Pilot mit EINER Achse (z.B. 3.A SearchAlgo) — User-Validierung
         |
F.6.1.G  Wenn Pilot OK: Rollout auf 13 weitere Achsen
```

**❓ FRAGE 4 an User:** Pilot-Achse Vorschlag 3.A (SearchAlgo-Traversal). Alternative: 5 (Memory-Layout, weil mehr Varianten + AoSoA bereits diskutiert)?

Antwort: fahre wie vorgeschlagen fort.

---

## §5 Konsequenzen fuer F.6.2 Migration

Sobald F.6.1 steht:
- 27 BASIS-Files werden nach `libs/cache_engine/topics/<topic>/` migriert + parallel als `axes/<axis>/default_variants/` referenziert
- Jede Klasse erbt von Basis-Interface (CRTP) oder erfuellt mindestens das Concept
- prt-art's `identity/` bleibt unter `comdare::prt_art::*`, registriert via Pruefling-Adapter

---

## §6 Bezug zu V41.E11 Facade

cache-engine wird Master-Framework (V41.E11 Skeleton). Der Permutations-Compiler aus §2.5 ist eine Tools-Kategorie unter `ICacheEngineTools` (V41.F.4):

```cpp
auto& tools = comdare::cache_engine::api::get_cache_engine().tools();
auto& compiler = tools.permutation_compiler();
compiler.visit_all([](auto perm) {
    // Compile-time: enumeriere alle Permutationen + erzeuge Binary
});
```

---

## §7 Beantwortete Fragen (User-Antworten 2026-05-25 spaet)

| # | Frage | Antwort |
|---|-------|---------|
| 1 | CRTP vs Concept | **MIX:** CRTP, dessen Derived-Parameter durch Concept-Constraint abgesichert ist. Pro Hierarchie-Ebene (Topic + Achse) eigene Concepts. (§3.6) |
| 2 | Pruefling ERSETZT/ERWEITERT/Override-Liste | **ERSETZT mit Compile-Time-Fallback:** Pro Achse ersetzt der Pruefling die Defaults vollstaendig. Wenn Pruefling die Achse NICHT ueberschreibt, faellt das System (Compile-Time-transparent) auf cache-engine-Defaults. **3-Stufen-Pruefung:** Stufe 1=CE-only, Stufe 2=Pruefling einzeln (mit Fallback), Stufe 3=Full Join multi-Pruefling. (§3.5) |
| 3 | 2-Ebenen Symlinks vs Hauptlage | **KEIN separates axes/-Verzeichnis.** Topics enthalten Achsen direkt als Unterordner. Hilfsfunktionen ohne Achsen liegen in `src/`. Mindestens eine Achse pro Topic. (§3) |
| 4 | Pilot-Achse | **3.A SearchAlgo-Traversal** (wie vorgeschlagen). |

## §7.1 NEUE Rueckfragen an User (RQ-1 bis RQ-9)

Aufgrund der Hierarchie-Korrektur entstehen 9 neue Detail-Rueckfragen — gesammelt in §3.1. Vor F.6.1.A Start bitte abstimmen. Kurzform:

| RQ | Thema | Vorschlag |
|----|-------|-----------|
| RQ-1 | Topic-Concept vs Achsen-Concept | Beides — Topic-Concept breit, Achsen-Concept eng |
| RQ-2 | Topic-Zuordnung Achsen 1, 2, 9, 12, 13 | Einzeln klaeren |
| RQ-3 | value_buffer/ — eigene Achse oder src/? | src/ (Hilfsfunktion) |
| RQ-4 | identity/ — eigene Achse oder src/? | src/ (Pruefling-Identifikation) |
| RQ-5 | measurement/ — gehoert zu comdare-measurement Submodule? | Ja, ausgliedern |
| RQ-6 | default_lookup/ als eigenes Topic oder Marker in Achsen-Verzeichnisse? | Marker direkt in Achsen-Verzeichnisse |
| RQ-7 | internal_search/ eigenstaendig oder Sub von traversal/? | Sub von traversal/axis_03a/default_variants/ |
| RQ-8 | src/ global vs src/ pro Topic | Beides (Topic-src wenn Topic-spezifisch, global wenn Topic-uebergreifend) |
| RQ-9 | Sub-Achsen eigene default_variants + optional_prt_art_impl Slots? | Ja, pro Sub-Achse eigene Slots (Vollausbau) |

---

## §8 Nicht-Entscheidungen (User-Direktiven konsolidiert nach Antwort-Runde 1)

- ✓ Reihenfolge: cache-engine zuerst, prt-art als Ableitung
- ✓ Statische Metaprogrammierung (nicht Runtime-Switch)
- ✓ Concept-System fuer Metaprog.-Absicherung (C++23)
- ✓ Pruefling via Namespace-Erweiterung `optional_<pruefling>_impl`
- ✓ Compile-Time-Fallback wenn Pruefling-Namespace leer
- ✓ Topics enthalten Achsen direkt (KEIN separates axes/-Verzeichnis)
- ✓ Hilfsfunktionen ohne Achsen: `src/`
- ✓ Mindestens eine Achse pro Topic
- ✓ CRTP-Basis + Concept-Guard (MIX-Pattern)
- ✓ 3-Stufen-Pruefung: CE-only / Pruefling-einzeln / Full-Join-multi-Pruefling
- ✓ ERSETZT-mit-Fallback pro Achse (NICHT Append)
- ✓ Multiple Prueflinge moeglich (Stufe 3 = non-redundant union)
- ✓ Pro Hierarchie-Ebene eigene Concept-Spezifizierung
- ✓ CacheEngineBuilder Pre-Compile-Permutation
- ✓ Visitor-Registrierungs-Pattern
- ✓ Pilot-Achse: 3.A SearchAlgo-Traversal

---

## §9 Implementierungs-Hinweise (defensive)

- **KEIN dynamischer Switch.** Wenn Switch noetig: `if constexpr` oder Compile-Time-Variant-Tuple.
- **KEINE virtuelle Funktionen** auf Hot-Path. CRTP statt vtable.
- **KEINE std::variant** auf Hot-Path. Variant-Tuple zur Compile-Time aufloesen.
- **KEINE Runtime-Registrierung.** Alle Achsen-Varianten compile-time-bekannt.
- **Concept-Constraints werden in template `requires` ausgewiesen** — Vertragsverletzung bricht Build.

---

## §10 Naechste Schritte

1. **User-Abstimmung dieser Skizze** (4 Fragen oben)
2. Nach Antwort: F.6.1.A Concepts pro Achse implementieren
3. Pilot in F.6.1.F validieren
4. Rollout F.6.1.G + F.6.2 + F.6.3
