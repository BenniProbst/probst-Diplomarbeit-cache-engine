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

Jede konkrete Klasse (Array256, Array65535, VectorU8U8, VectorU16U16, prt-art's eigene Varianten) muss diesem Concept genuegen. Falls eine Klasse das Concept nicht erfuellt, **kompiliert sie nicht** in der Permutations-Liste. Vertrag ist Compile-Time-absichert.

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

## §3 2-Ebenen-Architektur: Themen + Achsen parallel

User-Direktive 2026-05-25 (vorher): Themen-Module + Achsen-Module bestehen parallel.

```
libs/cache_engine/
├── topics/                       # Ebene 1: Themen (alte prt-art-Struktur)
│   ├── default_lookup/           # mit mind. einer Achse als Haupt-Kategorie
│   │   ├── README.md             # listet Achsen 3.B + 6.2 + 6.3 + 6.4 + 8.2 + 9 + 11 + 12 + 13
│   │   └── (Cross-Refs zu axes/)
│   ├── nodes/                    # mit Achsen 4 (Node), 8 (Concurrency), ...
│   ├── memory_layout/            # mit Achse 5 (Layout)
│   ├── value_handle/             # mit Achse 14 (Value-Handle)
│   ├── prefetch/                 # mit Achse 7 (Prefetch)
│   ├── telemetry/                # mit Achse 11 (Telemetry)
│   ├── traversal/                # mit Achsen 3.A + 3.M
│   ├── serialization/
│   ├── value_buffer/
│   ├── allocator/                # mit Achse 6 + Sub-Achsen
│   ├── concurrency/              # mit Achse 8 + Sub-Achsen
│   ├── measurement/
│   └── identity/                 # Pruefling-Identifikation
│
└── axes/                         # Ebene 2: Achsen (V41.F.2 + F.6.1 Neu-Struktur)
    ├── axis_01_index_organization/
    │   ├── concepts/<...>_concept.hpp
    │   ├── i_<...>_strategy.hpp
    │   ├── default_variants/             # cache-engine-Standards
    │   │   ├── linear_probe_hashset.hpp  # Symlink/Re-Export von topics/
    │   │   └── ...
    │   └── (optional_prt_art_impl namespace slot)
    ├── axis_02_path_compression/
    ├── axis_03a_search_algo/
    ├── axis_03b_cache_traversal/
    ├── axis_03m_traversal_mapping/
    ├── axis_04_node_type/
    ├── axis_05_memory_layout/
    ├── axis_06_allocator/
    │   ├── sub_61_alloc_lib/
    │   ├── sub_62_reclamation/
    │   ├── sub_63_numa/
    │   ├── sub_64_huge_page/
    │   └── sub_65_strategy/
    ├── axis_07_prefetch/
    ├── axis_08_concurrency/
    │   ├── sub_81_concurrency_basic/
    │   └── sub_82_locking_mode/
    ├── axis_09_isa/
    ├── axis_10_compression/
    ├── axis_11_telemetry/
    ├── axis_12_hardware/
    ├── axis_13_scheduling/
    └── axis_14_value_handle/
```

**Cross-Reference-Mechanik:** Beide Ebenen verweisen aufeinander via using-Aliases oder #includes — KEINE Code-Duplikation. Ein Algorithmus ist sowohl Thema (z.B. `topics/traversal/array_256.hpp`) als auch Achsen-Variante (`axes/axis_03a_search_algo/default_variants/array_256.hpp` via Re-Export).

**❓ FRAGE 3 an User:** Soll die Doppelhierarchie via Symlinks/Re-Exports oder via Single-Source-of-Truth (z.B. eine der beiden Ebenen ist die Hauptlage, die andere nur Index/View) realisiert werden?

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

## §7 Offene Fragen an User (4)

| # | Frage | Optionen |
|---|-------|----------|
| 1 | CRTP vs reines Concept-System fuer Basis-Interface? | CRTP (Default-Methoden) / Concept (Freiheit) / Mix (CRTP + Concept-Guard) |
| 2 | Pruefling-Namespace ERSETZT, ERWEITERT, oder pro-Variant explizit? | Erweitert (Append) / Ersetzt komplett / pro-Variant Override-Liste |
| 3 | 2-Ebenen via Symlinks/Re-Exports oder Single-Source-of-Truth? | Symlinks (Doppelhierarchie real) / topics/ als Hauptlage + axes/ als Views / axes/ als Hauptlage + topics/ als Views |
| 4 | Pilot-Achse fuer F.6.1.F? | 3.A SearchAlgo (klein, klar) / 5 Memory-Layout (groesserer Scope) / 11 Telemetry (Kuehn-validiert) / andere |

---

## §8 Nicht-Entscheidungen (eindeutig vom User vorgegeben)

- ✓ Reihenfolge: cache-engine zuerst, prt-art als Ableitung
- ✓ Statische Metaprogrammierung (nicht Runtime-Switch)
- ✓ Concept-System fuer Metaprog.-Absicherung (C++23)
- ✓ Pruefling via Namespace-Erweiterung `optional_<pruefling>_impl`
- ✓ Compile-Time-Fallback wenn Pruefling-Namespace leer
- ✓ 2-Ebenen-Architektur Themen + Achsen parallel
- ✓ CacheEngineBuilder Pre-Compile-Permutation
- ✓ Visitor-Registrierungs-Pattern

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
