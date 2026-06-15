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

Kommentar des Users zur Struktur: Bei value_buffer erzeugen wir eine Axe "queuing" und recherchieren im Web, welche Buffer Implementierungen es für diese Achse geben kann: kein Buffer, oder bestimmte buffer Strategien wie FIFO, LIFO und so weiter, dabei verschiedene Buffer Größen -> Buffer muss gleichzeitig der Achsen-Konfiguration der Allokation unter eigener Permutation gegen die Buffer Strategie unterliegen, mithilfe von Metaprogrammierung. "identity" war die Basisklasse des Suchalgorithmus und ist definitiv src. Von hier aus werden angefragte Suchalgorithmus-Permutationen oder Listen-Permutationen custom als Binary Modul gebaut (suche nach dem Stichwort default "Precompiled"). Measurement ist ein submodule der cache-engine für das Abbilden der Messung - bitte überprüfe bestehende comdare Module, ob es das nicht schon gibt und wir erweitern sollten, anstatt ein völlig neues Modul auf zu machen -> bessere Wiederverwendbarkeit. Wir sollten alle nun aufgeteilten submodules unter cache-engine prüfen, ob nicht schon was ähnliches und erweiterbares in den Projekte/Comdare-Modules existiert. internal_search ist ein Unterpunkt von traversal und kann gelöscht werden, weil es schon traversal Achsen gibt. Noch nicht zugeordnete Achsen brauchen jeweils ein Hauptthema (oder teilen sich ein Hauptthema), welches zum Umsetzungsort im Suchalgorithmus passt.

**Pruefling-Namespace pro Achse:**

Jedes `axes/<axis_NN>/` Verzeichnis hat zusaetzlich `optional_<pruefling>_impl/` Slot fuer Pruefling-Override:

```
topics/allocator/axis_06_allocator/
├── ...
├── default_variants/          # cache-engine Standards (immer da)
└── optional_prt_art_impl/     # prt-art kann hier eigene Allokator-Varianten reinhaengen
                               # leer = cache-engine-Defaults werden als Fallback verwendet
```

Kommentar des users: Das ist richtig, aber "optional_prt_art_impl" heißt am besten einfach "prt_art_impl" und ist Teil des prt-art Projektes, welches durch die cache-engine geladen und durch seine bloße dynamische cmake include Technik in die cache-engine geladen wird (reine cmake Konfiguration von prt-art mithilfe von C++23 Metaprogrammierung mit Auflistung von fremden includes -> recherchiere das Feature im Web).

### §3.1 NEUE Rueckfragen aus Hierarchie-Korrektur

Bevor F.6.1.A startet, muss diese Topic-Zuordnung mit User abgestimmt werden:

**RQ-1:** Topic-Concepts und Achsen-Concepts sind beides vorhanden. Hat das Topic ein eigenes "Topic-Concept" das alle Achsen-Concepts darunter erfuellen muessen, oder existieren Topic-Concepts nicht und nur Achsen-Concepts werden geprueft? (Vorschlag: Beides — Topic-Concept ist breit ("alle haben insert/lookup"), Achse-Concept ist enger ("Allocator hat allocate/deallocate")).

Antwort des Users: Ja, jedes Topic hat ein generelles Concept, von dem die Achsen ihre Concepts ableiten und spezifizieren, wir haben also eine saubere zweischichtige Architektur. Jeder Ordner und Unterordner hat genau ein File für die Definition aller concepts des Ordner- oder Unterordner Suchraums. Also ja beides.

**RQ-2:** Topic-Zuordnung der noch nicht zugeordneten Achsen:
- Achse 1 (Index-Organization) → eigenes Topic? Oder unter `traversal/`? -> traversal
- Achse 2 (Path-Compression) → eigenes Topic? Oder unter `nodes/`? -> nodes
- Achse 9 (ISA) → eigenes Topic `isa/`? Oder unter `src/abi/`? -> neues topic /hardware
- Achse 12 (Hardware-Strategy) → eigenes Topic? Oder unter `src/`? -> Achse unter /hardware -> als "general_hardware" neben dem ISA Achse.
- Achse 13 (Scheduling-Strategy) → eigenes Topic? Oder unter `src/`? -> Zerlegen je topic, weil Scheduling kann im Buffer, im concurrency, im IO und vielen anderen Bereichen auftreten und muss jeweils im Topic eine NEUE SEPARATE zu permutierende Achse bilden. Dies ist ein experimentell wertvoll zu variierender Faktor. Bitte recherchiere im Web zu welchen Topic- UND Achsen-Themen scheduling auftreten kann.

**RQ-3:** Hat `value_buffer/` eine eigene Achse oder ist es nur Hilfsfunktion (`src/`)? In Bausteine-Matrix nicht eindeutig.

Antwort des Users:
Siehe RQ2 und vorangegangenes.

**RQ-4:** Hat `identity/` eine eigene Achse, oder ist es eine Pruefling-Identifikation die unter `src/` (oder unter dem Pruefling-spezifischen Repo) liegt?

Antwort des Users:
Siehe RQ2 und vorangegangenes.

**RQ-5:** Hat `measurement/` eigene Achsen, oder ist es Mess-Infrastruktur (gehoert dann zu `comdare-measurement` Submodule)?

Antwort des Users:
Siehe RQ2 und vorangegangenes. Das measurement wird von der CacheEngineBuilder laut UML Plan bedient und kann von ihr durchgewechselt werden. Die Struktur der topics und Achsen betrifft NUR die zu konstruierenden Experiment Binary Permutationen der Suchalgorithmen bzw. Listen-Algorithmen. Alles was klar per Architektur außerhalb des direkten Kontextes von Suchalgorithmus-Achsen-Permutationen liegt, ist Teil der Experimentier Struktur, also Diplomarbeit, welche die Cache Engine mit Konfigurationen bedient. Alles was also in der Cache Engine in src liegt bedient nur die CacheEngineBulider Instanz, welche die Experimente misst und durchwechselt, sowie on demand Prebuild der Binary-Module der Suchalgorithmen vornimmt. Dazu kann die cache-engine Submodule verwenden, um die für "alles drum rum" notwendigen Einrichtungen bereitzustellen.


**RQ-6:** `default_lookup/` ist nach Audit ein **Vermittler** zwischen prt-art und cache-engine-Achsen (3.B, 6.2-6.4, 8.2, 9, 11, 12, 13). Bleibt es als eigenes Topic in cache-engine, oder werden die 9 Marker direkt in die jeweiligen Achsen-Verzeichnisse migriert (z.B. `topics/allocator/axis_06_allocator/sub_62_reclamation/` enthaelt dann die `prt_art_uses_default.hpp` Marker)?

Antwort des users: Eigentlich ist diese Einrichtung ein Strategy pattern, welches durch einen Interpreter die Konfigurationen der Diplomarbeit lesen und per Metaprogrammierung statisch kompilieren sollte. Dort sind bereits Einrichtungen für Experimente vorbereitet und angedeutet, aber noch nicht vollständig bezüglich der Konfiguration der Achsen. Der default_lookup gehört also zur src als Konfiguration der CacheEngineBuilder (bitte präzise die drawio Detail UML nachlesen für Architektur). Die Aufgabe von default_lookup ist es aus der Cache Engine heraus bei dynamisch konfigurierten Prüflingen, auch deren Konfiguration aufzunehmen und zu validieren. Wir hatten eine massive Architektur Verdrehung in der letzten session erlitten, dass der prt-art die Hauptrolle spielen wollte, was aber falsch ist. Im Prinzip ist es also richtig, dass der Default lookup damit Vermittler zwischen Cache Engine und Prüflingen/prt-art ist (nicht umgekehrt!). Die Registry ist auf der Seite des prt-art in Kombination der neuen Topics/Axes Architektur weiterhin erforderlich, muss allerdings durch das neue Namespace System ersetzt werden. Ist analog ein Prüflings-Subnamespace eines cache-engine namespaces vorhanden (automatische Erkennung), dann wird das Feature automatisch unter dem betreffenden Prüfling für Experimente registriert, fehlende eigene Achsenimplementierungen werden auch automatisch erkannt. Keine Implementierung einer Achse (also kein comdare::cache_engine::numa_default::prt_art (merke prt_art als Namespace Anzeige einer validen zusätzlichen Implementierung auf die cache_engine Basis) bedeutet vollständige Übernahme der Cache Engine Permutationen einer Achse aus der Cache Engine Bibliothek. Wir emulieren damit also mit Metaprogrammierung ein Vererbungs-System mit der Cache Engine als allgemeinsten Fall einer "Klasse" und dem Prüflings-Algorithmus als Spezifikation und Erweiterung.

**RQ-7:** `internal_search/` (Array256, Array65535, VectorU8U8, VectorU16U16) sind die default_variants/ der Achse 3.A SearchAlgo-Traversal. Bleibt es als eigenes Topic oder wandert es als `topics/traversal/axis_03a_search_algo/default_variants/`?

Antwort des Users: Das habe ich weiter oben schon beantwortet.

**RQ-8:** `src/` global vs. `src/` pro Topic — beides parallel? Hilfsfunktion die ueber mehrere Topics genutzt wird (z.B. `VirtualOffsetAddress` von memory_layout + traversal): liegt sie global oder im Topic mit "Haupt-Owner"?

Antwort des users: Habe ich weiter oben schon beantwortet. Ja src ist global, aber die Topics sind paralle zu src und beinhalten speziell die "modular" erweiterbaren Achsen (je mindestens eine ) je Topic.

**RQ-9:** Sub-Achsen wie 6.2 (Reclamation): bekommt das eigene `default_variants/` + eigenes `optional_prt_art_impl/`, oder erbt die Sub-Achse die Slots der Eltern-Achse 6?

Antwort des Users: Du vermischt hier grundsätzlich das Zielprojekt unserer Bemühungen (die Cache Engine) mit dem prt-art von dem wir verschieben wollen. Wenn ein Prüfling Topics und dann auch Achsen erweitern will, muss die Cache Engine alle diese Strukturen vorhalten und der prt-art hat exakt dieselbe Topics Struktur (nur vollständig wo notwendig für überschreibende Achsen), um die Cache Engine Basis Struktur zu erweitern. Daher existiert weder "default_variants" noch "optional_prt_art_impl" . Es gibt die Cache Engine und den prt-art. Sonst nichts. Stelle gerne nochmal Rückfragen, dieser Punkt scheint mir am weitesten vom Plan weg zu sein. Reclamation ist einfach eine Achse in einem am besten passenden Topic, welches sich um Speicher kümmert.

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

Kommentar des Users: Wieder unscharfe Architektur Abgrenzung. Ein Prüfling ist ein KOMPLETTES Achsen-Kompendium eines neuen Suchalgorithmus Vorschlages. Das heißt ein eigenes Projekt. Eine Prüflings-Binary ist dahingegen ein build einer exakten Rekombination aus neuen und bestehenden Algorithmen je Achsen-Schicht. Daher kann es je Prüfling NIE NUR EINEN BUILD geben, sondern eine Metaprogrammierte Sammlung aus Builds der Rekombinationen - das können einerseits für die Cache Engine, als auch für den Prüfling mehrere zehntausende Rekombinationen für einzelne binaries sein, welche je in einem EIGENEN Experiment durchgemessen werden (von der CacheEngineBuilder Klasse als orchestrator). Die 3 Modi setzen fest, dass zu Beginn erst die Rekombinations-binaries der Cache Engine, dann die der Prüflinge einzeln, und dann je Achsen-Schicht die möglichen Rekombinationen der Cache Engine gegen ein separates Permutationssystem multipler Prüflinge+CacheEngine gegeneinander als Permutationen der full join Achsen ausgewertet werden. Hier entstehen je der 3 Modi zehntausende (default static) binaries, die als C++23 Modul feature dynamisch in die CacheEngineBuilder als Prüflings-Binary geladen werden. Also Prüfling != Prüflings-binary !!! Der Prüfling liefert ein komplexes Messprofil aus den Prüflings-Binaries, die über die Achsen Ergebnisse in der Dimensionalen Ordnung der Anzahl der Achsen liefern. Das sind gigantische Experiment Setups für große Super-Computer wie das ZIH der TU Dresden.


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

---

## §11 Konsolidierungs-NACHTRAG 2026-05-25 (W1/W2/W3 Web-Recherchen + UML REV7 + bestehende Struktur)

### §11.1 W1-Ergebnis: C++23 Modules NICHT geeignet → configure_file Master-Header

**Verdikt:** Echte C++23 Modules (`import`) erzwingen Kopplung (Konsument muss expliziten `import comdare.ce.prt_art;` schreiben). Das widerspricht dem Pruefling-Unabhaengigkeits-Ziel.

**Empfohlene Mechanik (3-fach):**

```cmake
# 1. prt-art exportiert sich als INTERFACE-Provider
add_library(comdare_ce_prueflinge_prt_art INTERFACE)
target_include_directories(comdare_ce_prueflinge_prt_art INTERFACE include)
set_property(TARGET comdare_ce_prueflinge_prt_art APPEND PROPERTY
    INTERFACE_COMDARE_CE_PRUEFLING_HEADERS
        "prt_art/extensions/allocator_extension.hpp"
        "prt_art/extensions/traversal_extension.hpp")

# 2. cache-engine sammelt + generiert Master-Header
foreach(tgt IN LISTS COMDARE_CE_PRUEFLINGE)
    get_target_property(h ${tgt} INTERFACE_COMDARE_CE_PRUEFLING_HEADERS)
    list(APPEND _all_headers ${h})
endforeach()
set(CE_PRUEFLING_INCLUDE_LINES "")
foreach(h IN LISTS _all_headers)
    string(APPEND CE_PRUEFLING_INCLUDE_LINES "#include \"${h}\"\n")
endforeach()
configure_file(prueflinge_includes.hpp.in
               ${CMAKE_BINARY_DIR}/generated/comdare/ce/prueflinge_includes.hpp
               @ONLY)
```

```cpp
// 3. C++20/23 concept-Detection auf Namespace-Inhalt
#include <comdare/ce/prueflinge_includes.hpp>  // auto-generiert, leer wenn keine Prueflinge

namespace comdare::cache_engine::allocator::axis_06 {

template <typename = void>
concept has_prt_art_variants = requires {
    typename prt_art::PrueflingVariants;
};

template <typename Permuter>
constexpr auto generate_permutations() {
    if constexpr (has_prt_art_variants<>) {
        return Permuter::expand(prt_art::PrueflingVariants{});
    } else {
        return Permuter::defaults();
    }
}
}
```

**Referenzen:** Kitware C++ Modules Blog (Hanwell 2024), Crascit Modules/CMake/Shared (2024), Catch2 configure_file Pattern, Boost.Hana Detection-Idiom.

### §11.2 W2-Ergebnis: Achse "queuing" mit 13 Strategien × 6 Sizes

**Neue Achse `queuing` (ehemals `value_buffer`):**

| ID | Strategie | Anwendung |
|----|-----------|-----------|
| Q-NONE | NoBuffer | Klassisch B+ / ART (Leaf direkt) |
| Q-APP | AppendOnly (Linear) | LSM-MemTable, Bw-Tree Delta-Chain |
| Q-FIFO | FIFOQueue (Ring/Deque) | LSM, Write-Coalescing |
| Q-LIFO | LIFOStack | Hot-Path Reuse, Versions-Tombstones |
| Q-RING | BoundedRing<N> | SPSC/MPMC, Disruptor-Pattern |
| Q-PRIO | PriorityHeap | LRU-Approx, Hot-Key Promotion |
| Q-DELTA | DeltaChain | **Bw-Tree (Levandoski 2013)** |
| Q-SKIP | SkiplistBuffer | LSM (RocksDB, LevelDB) |
| Q-TOMB | TombstoneBuffer | LSM, ART-Optimistik, MVCC |
| Q-COW | CopyOnWrite Snapshot | Persistent ART, RCU-Tries |
| Q-EPOCH | EpochBuffer (QSBR) | SMART ART (OSDI 2023), Masstree |
| Q-BATCH | BatchedInsertBuffer<N> | OLAP-Index, ART-Bulk-Insert |
| Q-SPSC | LockFreeSPSC (Lamport) | Per-Thread → Background |
| Q-MPMC | LockFreeMPMC (Vyukov/MS) | Globaler Write-Pfad |

**Sweep-Groessen:** {0, 8, 64, 1024, 16384, dynamic_2x} (6 Werte) × 13 Strategien = **78 Konfigurationen, ~38 nach Constraint-Filter valide**.

**Cross-Constraints (Buffer × Allocator) als compile-time `requires`-Klausel:**
```cpp
template<QueuingKind Q, class Alloc>
inline constexpr bool valid_combo_v = []{
    if constexpr (Q == QueuingKind::AppendOnly)
        return AllocatorTrait<Alloc>::is_monotonic;
    if constexpr (Q == QueuingKind::Epoch)
        return AllocatorTrait<Alloc>::supports_qsbr;
    return true;
}();
```

**Wissenschaftliche Referenzen:** Leis (ART, ICDE 2013), Luo (SMART, OSDI 2023), Levandoski (Bw-Tree ICDE 2013), Mao (MassTree EuroSys 2012), O'Neil (LSM 1996), Disruptor (Thompson 2011), Vyukov MPMC, Michael-Scott PODC 1996, McKenney RCU (OLS 2001).

### §11.3 W3-Ergebnis: Scheduling als 7 Sub-Achsen pro Topic

User-Direktive 2026-05-25: Scheduling ZERLEGEN je Topic. W3-Recherche liefert konkrete Sub-Achsen:

| Topic | Sub-Achse | Varianten |
|-------|-----------|-----------|
| `queuing` (buffer) | `buffer::flush_policy` | eager_per_op / threshold_watermark / time_window / lazy_on_evict / adaptive_lsm |
| `concurrency` | `concurrency::scheduler_topology` | per_core_pinned / work_stealing_global / work_stealing_numa_neighbor / hybrid_p_e_split (Intel) / coroutine_stackless / coroutine_stackful / learned_pmoss |
| `io` (NEU? siehe RQ) | `io::dispatch_policy` | in_memory_only / sync_spill / async_io_uring_batch / read_ahead_tuned / cooling_classified (LeanStore) |
| `prefetch` | `prefetch::interleave_depth` | none / single_lookahead_1 / group_prefetch_8 / coroutine_suspend_resume / amac_async_4 / adaptive_distance |
| `allocator` | `allocator::pool_resize_policy` | eager_preallocate / lazy_first_use / hwm_watermark_75 / oom_reactive (CacheLib) / prediction_driven |
| `telemetry` | `telemetry::collection_rhythm` | disabled / push_per_op / pull_5s / pull_60s / adaptive_sampled / hardware_pmu_driven (P-MOSS) |
| `codegen` (Build-Time) | `codegen::permutation_emit_order` | lexicographic_serial / parallel_per_topic / dependency_dag_topological / hotpath_first_pgo |

**Cross-Topic-Constraints (Beispiele):**
- `buffer::lazy_on_evict + io::sync_spill = INVALID` (Burst-Konflikt)
- `prefetch::adaptive_distance REQUIRES telemetry != disabled`
- `allocator::prediction_driven REQUIRES telemetry::hardware_pmu_driven`
- `buffer::adaptive_lsm + io::in_memory_only = INVALID`

**Referenzen:** LeanStore (Leis ICDE 2018, PVLDB 17), P-MOSS (Mukherjee 2024), CoroBase (He PVLDB 14), Interleaving with Coroutines (Psaropoulos PVLDB 11), SAP HANA NUMA Scaling, CacheLib Slab-Rebalancing, Hyrise HPI.

### §11.4 UML REV7 §4 Drei-Schichten-Hierarchie + Variadic-Template + Fingerprint

Aus `docs/termine/20260508 Termin 7/Phase5_UML_Detail/24_architektur_skizze_REV7_2026_05_13.md`:

```
CacheEngine (Basis, Visitor-Wurzel)
    ^
    |  erbt
execution_engine<processing_strategy_type>     (Provider: OS-Primitiven)
    ^
    |  erbt
search_engine<collection<K,V>, ConfigPerm>     (Provider: Such-Patterns)
    ^
    |  Spezialisierung
prt_art<K, V, ...>                              (Pruefling-SearchEngine)
```

**Layer-Provider-Rollen (Pflicht):**
- CacheEngine: Stand-der-Technik-Bausteine + OS-Primitiven (Cache-Page-Topologie, Allocator-Pools, Concurrency-Disziplinen, Telemetrie, Scheduling-Heuristiken)
- ExecutionEngine: stellt experimentelle OS-Primitiven via CacheEngine bereit (cache-line-aligned-Alloc, NUMA-pinning, ...)
- SearchEngine: stellt Such-Patterns bereit (Trie-Walk, Range-Scan, Hot-Path-Lookup), Dach des Konstrukts

**Pflicht-Regeln:**
- SearchEngine darf NICHT direkt CacheEngine-Bausteine konsumieren → muss durch ExecutionEngine
- ExecutionEngine darf KEINE Such-spezifischen Patterns kennen — nur OS-Primitiven-Ebene
- PRT-ART als Pruefling-SearchEngine kann eigene Patterns hinzufuegen, faellt aber per Compile-time-Fallback auf ExecutionEngine-Primitiven zurueck

**Variadic-Template-Magie:**
```cpp
// 1 Param: Value-only, Key = auto-incrementing uint64
// 2 Params: (Key, Value)
// N>2: (Key, std::tuple<Value1..N>)
template <typename... Ts>
class search_algorithm_type_collection {
    using traits = type_collection_traits<Ts...>;
    using key_t  = typename traits::key_t;
    using value_t = typename traits::value_t;
    using binary_key_t = decltype(fingerprint::to_binary_string(std::declval<key_t>()));
};
```

**Komplexer Key → Fingerprint-Hash:**
```cpp
template <std::size_t Bytes = 16>
class FixedLengthFingerprint {
    static std::array<std::byte, Bytes> hash(auto const& complex_object);
};
// Overload: einfach-Typen direkter binary-cast, komplex via FixedLengthFingerprint<16>
```

### §11.5 Allokator-Achsen AA1-AA7 (UML REV7 §2.5)

Bestehende Allokator-Achsen-Klassifizierung (analog 7 Such-Achsen):

| Achse | Konzept | Beispiele |
|-------|---------|-----------|
| AA1 | Free-List-Topologie | A04 mimalloc Free-List-Sharding, A07 snmalloc Per-Thread-Caching, A19 Buddy-Tree |
| AA2 | Size-Class-Schema | A02 Slab-per-Objektgroesse, A20 dlmalloc bins, A05 jemalloc size-classes, A08 scalloc spans |
| AA3 | Thread-Locality | A06 tcmalloc thread-local-caches, A10 rpmalloc, A07 snmalloc message-passing |
| AA4 | Synchronization | A03 lock-free CAS, A11 LRMalloc, A04 mimalloc-CAS-on-non-local-free, A01 Hoard-per-heap-locks |
| AA5 | Allocation-Policy | A09 NUMA-origin-aware, A12 cache-set-aware, A14 NUCA-aware, A16 PIM-aware |
| AA6 | Reclamation | A02 magazine cache, A06 page-heap-release, A17 lock-free-reclamation, A04 deferred-free |
| AA7 | Fragmentation-Strategy | A20 dlmalloc coalescing, A02 object-coloring, A19 buddy-splitting, A04 page-local-sharding |

### §11.6 MAPPING bestehende cache-engine libs/ → neue Topics+Achsen-Hierarchie

**Bestehende libs/cache_engine/ Struktur (heute, HEAD `2eb21d6`):**

| Pfad | Inhalt | Mapping nach neuer Hierarchie |
|------|--------|-------------------------------|
| `libs/cache_engine/subsystems/c01_cost_engine/` | Kosten-Modell | → `topics/cost/axis_<N>_*/` (NEU) ODER `src/cost_engine/` |
| `libs/cache_engine/subsystems/c02_pinning_engine/` | NUMA-Pinning | → `topics/hardware/axis_12_general_hardware/sub_pinning/` |
| `libs/cache_engine/subsystems/c03_prefetch_engine/` | Prefetch | → `topics/prefetch/axis_07_prefetch/` (bestehende Achse-7) |
| `libs/cache_engine/subsystems/c04_coherence_engine/` | Cache-Kohaerenz | → `topics/concurrency/axis_08_concurrency/sub_83_coherence/` (NEU) |
| `libs/cache_engine/subsystems/c05_telemetry_engine/` | Telemetrie | → `topics/telemetry/axis_11_telemetry/` |
| `libs/cache_engine/subsystems/c06_allocation_engine/` | Allokator | → `topics/allocator/axis_06_allocator/` |
| `libs/cache_engine/subsystems/c07_migration_engine/` | Migration | → `topics/migration/axis_<N>_migration/` (NEU?) — Rueckfrage |
| `libs/cache_engine/subsystems/c08_encoding_engine/` | Encoding/Serialisierung | → `topics/serialization/axis_10_compression/` |
| `libs/cache_engine/subsystems/c09_heuristik_engine/` | Heuristiken | → `src/heuristics/` (CacheEngineBuilder-internal) |
| `libs/cache_engine/subsystems/c10_topologie_engine/` | Topologie | → `topics/hardware/axis_topologie/` (NEU?) |
| `libs/cache_engine/subsystems/c11_scheduler_engine/` | Scheduling | **WIDERSPRUCH** zu User-Direktive "Scheduling zerlegen je Topic". Loesung: c11 wird zerlegt in 7 Topic-Sub-Achsen (W3-Ergebnis) |
| `libs/cache_engine/subsystems/c12_filter_engine/` | Filter (z.B. Bloom) | → `topics/filter/axis_<N>_*/` (NEU?) |
| `libs/cache_engine/subsystems/platform_profiler/` | Plattform-Probe | → `topics/hardware/axis_09_isa/sub_profiler/` |
| `libs/cache_engine/concurrency_manager/array_concurrency/` | Concurrency Sub | → `topics/concurrency/axis_08_concurrency/sub_array/` |
| `libs/cache_engine/concurrency_manager/data_structure_concurrency/` | | → `topics/concurrency/axis_08_concurrency/sub_data_structure/` |
| `libs/cache_engine/concurrency_manager/memory_access_concurrency/` | | → `topics/concurrency/axis_08_concurrency/sub_memory_access/` |
| `libs/cache_engine/concurrency_manager/node_concurrency/` | | → `topics/concurrency/axis_08_concurrency/sub_node/` |
| `libs/cache_engine/concurrency_manager/page_concurrency/` | | → `topics/concurrency/axis_08_concurrency/sub_page/` |
| `libs/cache_engine/concurrency_manager/path_concurrency/` | | → `topics/concurrency/axis_08_concurrency/sub_path/` |
| `libs/cache_engine/concurrency_manager/simd_flow_concurrency/` | | → `topics/concurrency/axis_08_concurrency/sub_simd_flow/` |
| `libs/cache_engine/concurrency_manager/simd_thread_concurrency/` | | → `topics/concurrency/axis_08_concurrency/sub_simd_thread/` |
| `libs/cache_engine/reclamation/rcu_reclaim/` | Reclamation | → `topics/allocator/axis_06_allocator/sub_62_reclamation/` |
| `libs/cache_engine/builder/{22 Subkomponenten}` | Builder-Infrastruktur | → `src/builder/*` (CacheEngineBuilder-Domaene, NICHT Topic) |
| `libs/cache_engine/include/cache_engine/abi/` | ABI-Headers | → `src/abi/` |
| `libs/cache_engine/include/cache_engine/concepts/` | Globale Concepts | → `src/concepts/` (Topics haben eigene Concepts) |
| `libs/cache_engine/include/cache_engine/fingerprint/` | Fingerprint-Hash | → `src/fingerprint/` (Hilfsfunktion fuer Variadic-Template) |
| `libs/cache_engine/include/cache_engine/hbm/` | HBM-Allokator | → `topics/allocator/axis_06_allocator/sub_64_huge_page/` |
| `libs/cache_engine/include/cache_engine/indexes/` | Index-Strukturen (V41.A5 LinearProbeHashSet, RadixIndex) | → `topics/search_engine/axis_01_index_organization/default_variants/` |
| `libs/cache_engine/include/cache_engine/measurement/` | Mess-Headers | → `src/measurement/` (CacheEngineBuilder-internal) |
| `libs/cache_engine/include/cache_engine/platform/` | Plattform-Probe | → `topics/hardware/axis_09_isa/` |
| `libs/cache_engine/include/cache_engine/platform_probe/` | (Duplikat?) | → konsolidieren mit platform/ |
| `libs/cache_engine/include/cache_engine/strategy_command/` | Strategy-Pattern + Commands | → `src/strategy_command/` (Builder-Pattern, CacheEngineBuilder-internal) |
| `libs/cache_engine/include/cache_engine/allocators/families/a01-a14_*/` | 14 Allocator-Familien | → `topics/allocator/axis_06_allocator/sub_61_alloc_lib/default_variants/{a01..a14}/` |
| `libs/cache_engine/algorithm_profiles/{allocators,sota}/` | Algorithmus-Profile | → `src/algorithm_profiles/` |

**Geplante NEUE Topics (nach User-RQ-Antworten + W3-Recherche):**

| Topic | Achsen |
|-------|--------|
| `topics/allocator/` | axis_06 (mit Sub-Achsen 6.1-6.5 + neue 6.x scheduling) |
| `topics/concurrency/` | axis_08 (mit Sub-Achsen 8.1, 8.2, 8.3 coherence + scheduling) |
| `topics/traversal/` | axis_01 (Index-Org), axis_03a (Search-Algo), axis_03b (Cache-Traversal), axis_03m (Mapping) |
| `topics/nodes/` | axis_02 (Path-Compression), axis_04 (Node-Type) |
| `topics/memory_layout/` | axis_05 (Layout, mit AoS/SoA/AoSoA-Sub) |
| `topics/prefetch/` | axis_07 (mit scheduling Sub) |
| `topics/telemetry/` | axis_11 (mit scheduling Sub) |
| `topics/serialization/` | axis_10 (Compression, mit scheduling Sub) |
| `topics/value_handle/` | axis_14 (Inline/External/ChainRef) |
| `topics/queuing/` (NEU, ex value_buffer) | axis_Q (13 Strategien, mit scheduling Sub) |
| `topics/hardware/` (NEU) | axis_09 (ISA), axis_12 (general_hardware) |
| `topics/search_engine/` (NEU?) | axis_01 (Index-Organization, fuer std::map/vector/list/multi_map Klassifizierung) |
| `topics/io/` (NEU? siehe RQ-W3) | axis_io (mit scheduling Sub: io::dispatch_policy) |
| `topics/migration/` (NEU? siehe RQ-Bestand c07) | axis_<N>_migration |
| `topics/cost/` (NEU? siehe RQ-Bestand c01) | axis_<N>_cost |
| `topics/filter/` (NEU? siehe RQ-Bestand c12) | axis_<N>_filter |

**Geplante src/-Hilfsfunktionen (NICHT Topics, da achsenfrei):**

```
src/
├── builder/                      # CacheEngineBuilder + 22 Subkomponenten
├── abi/                          # ABI-Layer (execution_engine, search_engine)
├── api/                          # Facade (ICacheEngine, IPrueflingFactory) (V41.E11)
├── concepts/                     # Globale Cross-Topic-Concepts
├── fingerprint/                  # FixedLengthFingerprint<Bytes>
├── strategy_command/             # Strategy-Pattern + Command-Pattern fuer Builder
├── algorithm_profiles/           # CMake-/XML-Profile
├── default_lookup/               # Interpreter fuer Pruefling-Achs-Defaults (RQ-6 User-Antwort: src/)
├── identity/                     # Pruefling-Identifikation (RQ-4 User-Antwort: src/)
├── measurement/                  # Mess-Infrastruktur fuer CacheEngineBuilder (RQ-5: ggf. comdare-measurement Submodule)
├── heuristics/                   # c09_heuristik_engine (Builder-internal)
└── permutations/                 # PermutationVisitor + AxisVariantList + cartesian_product_t
```

### §11.7 RQ-10 bis RQ-15 ALLE BEANTWORTET (User 2026-05-25 spaet)

| RQ | Frage | User-Antwort |
|----|-------|--------------|
| RQ-10 | c01_cost_engine | **Sub-Achse von Engine-Choice V3 (Informed-Kalibriert)** — wird Teil der V42.P0.2 V1-V4 Engine-Choice-Achse, NICHT eigenes Topic |
| RQ-11 | c07_migration_engine | **Eigenes Topic `migration/` mit Achse `migration::policy`** (none/lazy_on_access/proactive_scan/hot_cold_split/learned) |
| RQ-12 | c12_filter_engine | **Eigenes Topic `filter/`** (Bloom/Cuckoo/Quotient/XOR/Ribbon) |
| RQ-13 | c10_topologie_engine | **Sub-Achse von `hardware/axis_topologie`** (flat/numa_2sock/numa_8sock/hetero_p_e/disaggregated) |
| RQ-14 | io als Topic | **Eigenes Topic `io/` mit Achse `io::dispatch_policy`** (in_memory_only/sync_spill/async_io_uring/read_ahead_tuned/cooling_classified) |
| RQ-15 | search_engine axis_01 Klassifizierung | **JA, Konzept-Skelett:** axis_01 mit 4 Sub-Klassifikationen: 01a `std_map_like` (sorted+unique+ordered), 01b `std_vector_like` (positional+dense), 01c `std_list_like` (linked+sequence), 01d `std_multi_map_like` (sorted+non-unique). Pro Sub eigene default_variants + Cross-Constraints (z.B. linked_list braucht pseudo Spread) |

### §11.7.A FINALE Topic-Liste (User-validiert)

15 Topics + jeweils mind. 1 Achse + jeweils mind. 1 scheduling Sub-Achse (W3) wo sinnvoll:

| # | Topic | Achsen | Scheduling Sub-Achse |
|---|-------|--------|----------------------|
| 1 | `allocator/` | axis_06 (Sub 6.1-6.5: alloc_lib, reclamation, numa, huge_page, strategy) | allocator::pool_resize_policy |
| 2 | `concurrency/` | axis_08 (Sub 8.1, 8.2, 8.3 coherence + 8 Disziplinen-Liste C.6) | concurrency::scheduler_topology |
| 3 | `traversal/` | axis_03a search_algo, 03b cache_traversal, 03m mapping | — |
| 4 | `nodes/` | axis_02 path_compression, axis_04 node_type | — |
| 5 | `memory_layout/` | axis_05 (AoS/SoA/hybrid/AoSoA) | — |
| 6 | `prefetch/` | axis_07 | prefetch::interleave_depth |
| 7 | `telemetry/` | axis_11 (Sub 11.X1 LeafOnly, X2 Sampled, X3 Offline-Recompute, X4 Inner-AntiPattern) | telemetry::collection_rhythm |
| 8 | `serialization/` | axis_10 compression | — |
| 9 | `value_handle/` | axis_14 (Inline/External/ChainRef + CostModel) | — |
| 10 | `queuing/` (NEU ex value_buffer) | axis_Q (13 W2-Strategien × 6 Sizes) | buffer::flush_policy |
| 11 | `hardware/` (NEU) | axis_09 ISA, axis_12 general_hardware, axis_topologie (c10) | — |
| 12 | `search_engine/` (NEU) | axis_01 Index-Organization (Sub 01a std_map_like, 01b std_vector_like, 01c std_list_like, 01d std_multi_map_like) | — |
| 13 | `io/` (NEU) | axis_io dispatch_policy | — (axis_io selbst ist scheduling-Domaene) |
| 14 | `migration/` (NEU, ex c07) | axis_migration policy | — |
| 15 | `filter/` (NEU, ex c12) | axis_filter (Bloom/Cuckoo/Quotient/XOR/Ribbon) | — |

### §11.7.B FINALE src/-Hilfsfunktionen (KEINE Topics, KEINE Achsen)

```
libs/cache_engine/src/
├── builder/                  # CacheEngineBuilder + 22 Subkomponenten
├── abi/                      # ABI-Layer (execution_engine, search_engine POD)
├── api/                      # Facade (ICacheEngine, IPrueflingFactory) V41.E11
├── concepts/                 # Cross-Topic-Concepts (Topic-Concepts liegen IN topics/)
├── fingerprint/              # FixedLengthFingerprint<Bytes> (UML §4.2(c))
├── strategy_command/         # Strategy + Command fuer Builder
├── algorithm_profiles/       # CMake-/XML-Profile (Bausteine_Matrix.txt)
├── default_lookup/           # Strategy-Pattern + Interpreter fuer Pruefling-Validierung (RQ-6)
├── identity/                 # Pruefling-Identifikation (RQ-4)
├── measurement/              # Mess-Infrastruktur (ggf. comdare-measurement Submodule, RQ-5)
├── heuristics/               # c09_heuristik_engine (Builder-internal)
├── cost_engine/              # c01 Kosten-Modell (RQ-10: Teil von Engine-Choice V3)
├── permutations/             # PermutationVisitor + AxisVariantList + cartesian_product_t
├── platform_probe/           # c-bestand + V42.P0.3 IPlatformProbe Auto-Discovery
└── codegen/                  # Build-Time codegen::permutation_emit_order (W3)
```

### §11.7.C Mapping bestehende libs/cache_engine/* → FINAL (User-validiert)

| Bestehender Pfad | Ziel |
|------------------|------|
| `subsystems/c01_cost_engine/` | `src/cost_engine/` (Teil V3 Engine-Choice V42.P0.2) |
| `subsystems/c02_pinning_engine/` | `topics/hardware/axis_12_general_hardware/sub_pinning/` |
| `subsystems/c03_prefetch_engine/` | `topics/prefetch/axis_07_prefetch/` |
| `subsystems/c04_coherence_engine/` | `topics/concurrency/axis_08_concurrency/sub_83_coherence/` |
| `subsystems/c05_telemetry_engine/` | `topics/telemetry/axis_11_telemetry/` |
| `subsystems/c06_allocation_engine/` | `topics/allocator/axis_06_allocator/` |
| `subsystems/c07_migration_engine/` | `topics/migration/axis_migration/` (NEUES Topic) |
| `subsystems/c08_encoding_engine/` | `topics/serialization/axis_10_compression/` |
| `subsystems/c09_heuristik_engine/` | `src/heuristics/` |
| `subsystems/c10_topologie_engine/` | `topics/hardware/axis_topologie/` (Sub-Achse von hardware) |
| `subsystems/c11_scheduler_engine/` | **ZERLEGT in 7 Sub-Achsen pro Topic** (W3-Pattern, KEIN eigenes Subsystem mehr) |
| `subsystems/c12_filter_engine/` | `topics/filter/axis_filter/` (NEUES Topic) |
| `subsystems/platform_profiler/` | `src/platform_probe/` (+ V42.P0.3 Auto-Discovery erweitert) |
| `concurrency_manager/{array,data_structure,memory_access,node,page,path,simd_flow,simd_thread}_concurrency/` | `topics/concurrency/axis_08_concurrency/sub_{...}/` (8 Disziplinen — C.6 vergessenes Feature wieder einsortiert) |
| `reclamation/rcu_reclaim/` | `topics/allocator/axis_06_allocator/sub_62_reclamation/` (+ V42.P1.2 comdare-rcu eigene Impl) |
| `builder/{22 Subkomponenten}` | `src/builder/*` |
| `include/cache_engine/abi/` | `src/abi/` |
| `include/cache_engine/concepts/` | `src/concepts/` |
| `include/cache_engine/fingerprint/` | `src/fingerprint/` |
| `include/cache_engine/hbm/` | `topics/allocator/axis_06_allocator/sub_64_huge_page/` (+ V42.P1.3 HBM Abstract Factory) |
| `include/cache_engine/indexes/` (LinearProbeHashSet, RadixIndex) | `topics/search_engine/axis_01_index_organization/sub_01a_std_map_like/default_variants/` |
| `include/cache_engine/measurement/` | `src/measurement/` |
| `include/cache_engine/platform/` + `platform_probe/` | `src/platform_probe/` (konsolidiert) |
| `include/cache_engine/strategy_command/` | `src/strategy_command/` |
| `include/cache_engine/allocators/families/a01-a14_*/` | `topics/allocator/axis_06_allocator/sub_61_alloc_lib/default_variants/{a01..a14}/` |
| `algorithm_profiles/{allocators,sota}/` | `src/algorithm_profiles/` |

**Konsequenz:** Migration ist substantiell aber strukturell klar — 12 Subsystems + 8 Concurrency-Disziplinen + 14 Allocator-Familien werden in 15 Topics mit klarer Achsen-Zuordnung restrukturiert. Bestehende Code-Substanz bleibt erhalten; nur Pfade + Namespaces wechseln.

### §11.8 Konkreter F.6.1.A Vorschlag (nach User-Validierung von §11.6 Mapping)

**Pilot: Topic `allocator` mit Achse `axis_06_allocator` und Sub-Achse `sub_61_alloc_lib`:**

```
libs/cache_engine/topics/allocator/
├── concepts/topic_concept.hpp     # Topic-Concept (breit, fuer alle Achsen darunter)
└── axis_06_allocator/
    ├── concepts/axis_concept.hpp  # Achsen-Concept (eng, alloc/dealloc)
    ├── i_allocator_strategy.hpp   # CRTP-Basis + concept-Guard
    └── sub_61_alloc_lib/
        ├── concepts/sub_concept.hpp
        ├── default_variants/      # KEIN extra Ordner — User RQ-9 Antwort
        ├── std_malloc.hpp
        ├── mimalloc.hpp
        ├── ...
        └── (prt_art Namespace-Slot existiert NICHT als Ordner —
             prt_art-Code lebt im prt-art-Repo unter
             `comdare::cache_engine::allocator::axis_06::sub_61::prt_art::*`,
             cmake-Master-Header `prueflinge_includes.hpp` includiert ihn falls Submodule aktiv)
```

**Pilot-Code-Beispiel (cache-engine):**

```cpp
// libs/cache_engine/topics/allocator/axis_06_allocator/i_allocator_strategy.hpp
namespace comdare::cache_engine::allocator::axis_06 {

namespace concepts {
    template <typename T>
    concept AllocatorStrategy = requires(T t, std::size_t bytes) {
        { t.allocate(bytes) } -> std::same_as<void*>;
        { t.deallocate((void*)nullptr, bytes) } -> std::same_as<void>;
        typename T::pool_kind_t;
    };
}

template <typename Derived>
    requires concepts::AllocatorStrategy<Derived>
class AllocatorStrategyBase {
public:
    void* allocate(std::size_t bytes) {
        return static_cast<Derived*>(this)->allocate_impl(bytes);
    }
    // Default-Methoden via CRTP-Inlining
};

}  // namespace
```

**Pilot-Code-Beispiel (prt-art Erweiterung):**

```cpp
// comdare-prt-art/include/prt_art/extensions/allocator_extension.hpp
namespace comdare::cache_engine::allocator::axis_06::prt_art {

struct PrtArtPoolAllocator
    : public comdare::cache_engine::allocator::axis_06::AllocatorStrategyBase<PrtArtPoolAllocator> {
    using pool_kind_t = ...;
    void* allocate_impl(std::size_t bytes) { /* ... */ }
    void deallocate(void* p, std::size_t bytes) { /* ... */ }
};

using PrueflingVariants = AxisVariantList<PrtArtPoolAllocator>;

}  // namespace
```

**Pilot-CMake (prt-art):**

```cmake
add_library(comdare_ce_prueflinge_prt_art INTERFACE)
target_include_directories(comdare_ce_prueflinge_prt_art INTERFACE include)
set_property(TARGET comdare_ce_prueflinge_prt_art APPEND PROPERTY
    INTERFACE_COMDARE_CE_PRUEFLING_HEADERS
        "prt_art/extensions/allocator_extension.hpp")
```

**Pilot-CMake (cache-engine, generischer Master-Header-Generator):**

```cmake
# cache-engine bekommt von Diplomarbeit-Container die Pruefling-Liste
foreach(tgt IN LISTS COMDARE_CE_PRUEFLINGE)
    get_target_property(h ${tgt} INTERFACE_COMDARE_CE_PRUEFLING_HEADERS)
    list(APPEND _ce_all_pruefling_headers ${h})
    list(APPEND _ce_all_pruefling_targets ${tgt})
endforeach()
set(CE_PRUEFLING_INCLUDE_LINES "")
foreach(h IN LISTS _ce_all_pruefling_headers)
    string(APPEND CE_PRUEFLING_INCLUDE_LINES "#include \"${h}\"\n")
endforeach()
configure_file(prueflinge_includes.hpp.in
               ${CMAKE_BINARY_DIR}/generated/comdare/ce/prueflinge_includes.hpp
               @ONLY)
target_link_libraries(cache_engine_topic_allocator INTERFACE ${_ce_all_pruefling_targets})
```

### §11.9 Status der laufenden W-Agents

| Agent | Status | Output |
|-------|--------|--------|
| W1 (C++23 Modules + cmake) | ✓ DONE | configure_file Master-Header empfohlen, NICHT echte C++23 Modules |
| W2 (Buffer/Queuing-Strategien) | ✓ DONE | 13 Strategien × 6 Sizes = 78 Permutationen, 38 valide |
| W3 (Scheduling pro Topic) | ✓ DONE | 7 Sub-Achsen pro Topic + Cross-Constraints |
| W4 (Doku-Audit vergessene Features) | LAEUFT | Erwartet: Liste vergessener Features aus gesamter docs/ |

### §11.10 Naechste Schritte (KORRIGIERT nach W1/W2/W3/W4 + bestehende Struktur)

1. **User-Validierung der §11.6 Mapping-Tabelle** (kritisch: 6 Rueckfragen RQ-10 bis RQ-15)
2. **W4 fertig** (vergessene Features in §12 dokumentiert) — User-Priorisierung
3. F.6.1.A Pilot: Topic `allocator/axis_06/sub_61_alloc_lib/` mit den 3 Mechaniken aus §11.1 (configure_file + INTERFACE-Target + concept-detection)
4. F.6.1.B Q-Achse `queuing/` neu anlegen mit W2-Strategien
5. F.6.1.C 7 Scheduling-Sub-Achsen pro Topic nach W3-Empfehlung
6. F.6.1.D Mapping bestehender libs/* → topics/* per git mv schrittweise (104 Tests gruen halten)
7. F.6.1.E `src/permutations/` mit PermutationVisitor + AxisVariantList (W1-Pattern)
8. F.6.1.F BUILD-Test
9. F.6.1.G Rollout auf 14+ Topics

---

## §12 W4 Doku-Audit Ergebnis: VERGESSENE FEATURES in V41-Planung

W4-Agent durchsuchte `docs/` + Termin 7 Detailplanung. Liefert priorisierte Liste vergessener Features die Diplomarbeit-Ergebnis beeinflussen.

### §12.A KRITISCH (P0) — direkt thesis-relevant

| # | Feature | Quelle | Warum fehlt |
|---|---------|--------|-------------|
| A.1 | **H1/H2/H3 Hypothesen als formale Mess-Achse pro Permutation** | `uml_planning/Y2_prt_art_ist_kartografie.md:175`, `Z3_soll_uml_diplomarbeit_code.md:127-129` | V41 behaelt `hypothesis_metrics.hpp` als prt-art-SPEZIFISCH. ABER: H1 (PageType-Cost / CLU), H2 (Layout-Quality), H3 (Inline/External/ChainRef-Distribution) sind das **wissenschaftliche Resultat** und gehoeren pro Lauf evaluiert. V41.D2 deckt das nicht ab. |
| A.2 | **V1-V4 Engine-Choice-Dimension** (Meta-Achse) | `architektur/11_axes_vs_strategies_disambiguation.md:301-322`, `glossar/02_domaenenmodell_v4_master.md` §1B, `bausteine/05_flag_system.md:170` Bank 14 EngineChoiceBank | F15-Forschungsmission braucht 4 Builds pro Permutation: V1=BaseEngine (Baseline), V2=Static-CE, V3=Informed-Kalibriert, V4=Adaptive. V41-Codegen erzeugt nur 1 Build/Permutation → **kein sauberer CE-Wirksamkeitsbeweis** |
| A.3 | **IPlatformProbe Auto-Discovery** (K3.2) | `termine/.../10_korrektur_architektur_skizze_2026_05_09.md:60-107` | V41.A3 erwaehnt nur "TODO". F13 sagt "ZIH nutzt Runtime-Detection" — fehlt in Codegen. Pflicht-These der "Plattform-Kalibrierung" (P05 START, P14 Samuel) |

### §12.B WICHTIG (P1) — F15-Permutationsraum erweiternd

| # | Feature | Quelle | Action |
|---|---------|--------|--------|
| B.1 | **SDSL-Lite C++23-Portierung + comdare-succinct Modul** (F3-Beschluss) | `termine/.../Habich_Feedback_2026_05_08.txt:258-272` | NEUES Submodule `comdare-succinct/` mit BMI2/AVX-512/SVE2 ISA-Opt. Blockt Achse 1 LOUDS_DENSE/SPARSE/JACOBSON/MACRO_COCO |
| B.2 | **comdare-rcu eigene Implementation** (F2-Beschluss) | `termine/.../Habich_Feedback_2026_05_08.txt:248-256` | NEUER Pfad `cache_engine/reclamation/comdare_rcu/`, liburcu nur KONZEPT. Achse 6.2 (Reclamation: epoch/RCU/hazard/QSBR) in V41 nicht abgebildet |
| B.3 | **HBM Abstract Factory + Cache-Hierarchy-Manager** (F4-Beschluss) | `termine/.../Habich_Feedback_2026_05_08.txt:274-289` | `IHBMAllocator`-Concept mit IntelHBM/GraceHopperHBM/StandardDIMM. Pflicht-Plattform Sapphire Rapids HBM (P31/P32/P33 Habich-Linie) |
| B.4 | **Hybrid-Command-Pattern-Aufloesungen** (K3.4) | `termine/.../10_korrektur_architektur_skizze_2026_05_09.md:134-178` Tabelle 12+ Aufloesungen | V41 behandelt SuRF Dense+Sparse monolithisch. Zerlegung in atomare Commands (`LoudsDenseEncodingCommand` + `LoudsSparseEncodingCommand` + `CutoffLevelLoudsCompositionCommand`). Ohne diese verliert F15 Ablations-Studien |
| B.5 | **Reproduzierbarkeits-Slots** (Seeds, Warmups, Pinning, Compiler-Flags) | `termine/.../Begriffsglossar_v3_FINAL.txt:1125`, `termine/.../06_uml_persistence.md:69-78` (RunMetadata.config_hash:sha256) | Welch-Tests in V41.B3 ohne Provenance-Trail unvollstaendig fuer Publizierung |
| B.6 | **D10-D13 PRT-ART-Permutationsdimensionen** aus REV 6 | `termine/.../23_architektur_skizze_REV6_2026_05_11.md:676-689` | D10 Suchtyp-Reihenfolge (6 Permutationen A/B/C/D), D11 Dichte-Schwellen kalibriert (30/55/80), D12 Fingerprint-Filter an/aus (P31), D13 Serialization-Wahl statisch/dynamisch Compile-Time |
| B.7 | **Dataset-Permutations-Achsen** (F6/F7/F8) | `termine/.../Habich_Feedback_2026_05_08.txt:298-319` | F6: 4 Zipf-Theta-Klassen. F7: Mixed-Length Verteilungen. F8: Prefix-Sharing 10/50/80%. Nicht im V41.B2 YCSB-TODO |
| B.8 | **Cluster F TUD-Habich iDMA + Strided** (P31/P32) | `termine/.../_paper_extractions/cluster_F_sync_tud_habich.md:255-466` | P31 `IIntelligentDMA`-Concept (push-down Pointer-Chasing, 10x Speedup). P32 "strided > SIMD" Re-Denken auf Sapphire Rapids. V41 hat keine strided-Achse |

### §12.C OPTIONAL aber wertvoll fuer Thesis

| # | Feature | Quelle |
|---|---------|--------|
| C.1 | LaTeX-Toolchain H3 (Auto-Compile mit Diagrammen, `\PRTARTPlot{...}` Bausteine) | Habich H3 (`Habich_Feedback_2026_05_08.txt:85-130`) + `06_uml_persistence.md:95-107` LatexRenderer |
| C.2 | Code-Qualitaets-Bewertung pro Bausteine-Quelle (H2: `BAUSTEIN_BEWERTUNG.md` pro Adapter) | Habich H2 (`Habich_Feedback_2026_05_08.txt:46-83`) |
| C.3 | Volle Plattform-Matrix (8 Plattformen): Ryzen 9950X3D, i9-14900KS, ARM Pi5 NEON, VisionFive2 RISC-V, Grace Hopper SVE2+HBM3 | T6-Konsolidierung (`_review/T6-konsolidierung.md:28`) |
| C.4 | Achse 15 (Compiler) + Achse 16 (Allokator real vs Fallback) | V41.D2 erwaehnt, nicht implementiert |
| C.5 | P15 Graefe Survey + P19 Saikkonen Layout-Invariante (konstante Update-Ops) | `Eigenschaften_Suchalgorithmen.txt:109-130, 265-278` |
| C.6 | Achse 8 Original-Disziplinen-Liste (Page/Node/Array/DataStructure/Path/MemoryRW/SimdThread/SimdFlow) + 3 Mechaniken (OLC/ROWEX/RCU) | `Bausteine_Matrix.txt:516-547`. 14-Achsen-Erweiterung verlor die feinere Disziplinen-Liste |
| C.7 | P29 RCU + P30 Hazard Pointers Pruefling-Permutationen (Achse 6.2) | `cluster_F_sync_tud_habich.md:92-254` |
| C.8 | ZIH-Workspace-Strategie + Singularity-Container-Manifest + SLURM-Template (600 GPU-h + 20.000 Core-h Budget) | `CLAUDE.md` ZIH-Sektion |
| C.9 | BART-Master Bonus-Bausteine P06 (6 BART-Varianten als F15-Vergleichsbasis) | `Bausteine_Matrix.txt:133-198, 302-323, 362-381` |

### §12.D KRITISCH FEHLENDE Architektur-Patterns

| # | Pattern | Quelle | Fehlende Bezug |
|---|---------|--------|---------------|
| D.1 | **IExecutingEngine-Wurzel** ueber ISearchEngine (K3.1) | `architektur/10_schichten_modell_M.md:0-50` (AA.2-Korrektur 2026-05-18) | CE und PRT-ART sind **gleichberechtigte ExecutionEngines**, vom CacheEngineBuilder via Command-Pattern orchestriert. V41 hat nicht das `IExecutingEngine`-Wurzel-Interface mit `ExecuteEngineACommand` + `ExecuteEngineBCommand` + `CompareResultsCommand` |
| D.2 | **Multi-Pruefling-Faehigkeit** (M-Modell §6, Stufe 3 echtes Kartesisches Produkt) | `architektur/10_schichten_modell_M.md:226-240` | V41.F.5 markiert "comdare_perms_all = nur Aggregator, NICHT echtes Kartesisches Produkt 27×16=432". Multi-Pruefling-Full-Join fehlt |
| D.3 | **ABI-stabiles C++23-Modul-Interface** als POD-ABI | `termine/.../23_architektur_skizze_REV6_2026_05_11.md:576-606` | `struct ComdarePermutationModule_v1` + `struct comdare_cache_engine_v1`. V41.E11 Facade ist verwandt, nicht identisch. Detail fehlt |

### §12.E Empfohlene Top-7 fuer V42 (W4-Empfehlung)

1. **H1/H2/H3 als Mess-Achse** in jeder Permutation auswerten (P0)
2. **V1-V4 Engine-Choice-Multiplikation** in Codegen aktivieren (P0)
3. **IPlatformProbe Auto-Discovery + Live-Tuning** implementieren (P0)
4. **Hybrid-Command-Pattern-Aufloesung** (12+ Algorithmen aus K3.4-Tabelle) (P1)
5. **Reproduzierbarkeits-Slots** (Seeds + RunMetadata.config_hash) (P1)
6. **D10-D13 PRT-ART-Permutationsdimensionen** in Codegen (P1)
7. **comdare-rcu + comdare-succinct + comdare-hbm** als Module (P1)

### §12.F Wichtige Quelldateien fuer Audit (W4-Bericht referenziert)

- `docs/termine/20260508 Termin 7/Habich_Feedback_2026_05_08.txt`
- `docs/termine/20260508 Termin 7/Phase5_UML_Detail/10_korrektur_architektur_skizze_2026_05_09.md`
- `docs/termine/20260508 Termin 7/Phase5_UML_Detail/23_architektur_skizze_REV6_2026_05_11.md`
- `docs/bausteine/07_bausteine_matrix_N_erweitert.md`
- `docs/architektur/11_axes_vs_strategies_disambiguation.md`
- `docs/architektur/10_schichten_modell_M.md`
- `docs/termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions/cluster_F_sync_tud_habich.md`
- `docs/uml_planning/Y2_prt_art_ist_kartografie.md`

---

## §13 F.6.1.A Pilot-Status (Live ab 2026-05-25)

Pilot-Topic `allocator/axis_06_allocator` ist Stand HEAD `20dd0fa` (cache-engine standalone) bzw. `4e5f8d4` (Diplomarbeit-Submodule) **implementiert + getestet**.

### §13.1 Implementierte Files (10 Files)

```
libs/cache_engine/
├── topics/allocator/                                  Topic-Verzeichnis
│   ├── concepts/topic_allocator_concept.hpp           Marker AllocatorComponent
│   └── axis_06_allocator/                             Achsen-Verzeichnis
│       ├── concepts/
│       │   ├── axis_06_allocator_concept.hpp                              Pflicht-Standard (AllocatorStrategy)
│       │   ├── axis_06_allocator_cache_engine_permutation_concept.hpp     Pflicht cache-engine-spec (parallel)
│       │   ├── axis_06_allocator_zeroing_strategy_concept.hpp             Sub-Concept (calloc)
│       │   ├── axis_06_allocator_overallocating_strategy_concept.hpp      Sub-Concept (C++23 allocate_at_least)
│       │   ├── axis_06_allocator_introspectable_strategy_concept.hpp      Sub-Concept (usable_size)
│       │   ├── axis_06_allocator_reclaimable_strategy_concept.hpp         Sub-Concept (collect/purge)
│       │   ├── axis_06_allocator_resettable_strategy_concept.hpp          Sub-Concept (Pool release_all)
│       │   └── axis_06_allocator_reallocating_strategy_concept.hpp        Sub-Concept (realloc)
│       ├── axis_06_allocator_subaxes_aa1_to_aa7.hpp                       7 AA-Tags
│       ├── axis_06_allocator_strategy_base.hpp                            CRTP-Basis (static_assert Concept-Guard)
│       └── axis_06_allocator_std_malloc.hpp                               Concept-Beweis-Klasse (A22 ptmalloc2/glibc)
├── src/
│   ├── measurement/measurable_concept.hpp             Skelett (Topic-uebergreifend)
│   └── permutations/permutation_strategy_concept.hpp  Skelett (Topic-uebergreifend)
└── tests/unit/test_v41_topic_allocator_axis_06.cpp    18 Tests (mit STATISTICS=ON) / 17 (OFF)
```

### §13.2 Naming-Konvention (User-validiert)

| Datei | Schema |
|-------|--------|
| Topic-Concept | `topic_<topic_name>_concept.hpp` |
| Achsen-Concept | `axis_<NN>_<topic_name>_concept.hpp` (Hauptanforderungen) |
| Sub-Concept | `axis_<NN>_<topic_name>_<refinement>_strategy_concept.hpp` |
| CE-Permutation-Concept | `axis_<NN>_<topic_name>_cache_engine_permutation_concept.hpp` |
| AA-Tags | `axis_<NN>_<topic_name>_subaxes_aa1_to_aa<M>.hpp` |
| CRTP-Basis | `axis_<NN>_<topic_name>_strategy_base.hpp` |
| Concrete Vendor-Wrapper | `axis_<NN>_<topic_name>_<vendor_name>.hpp` |
| Test | `test_v41_topic_<topic_name>_axis_<NN>.cpp` |

### §13.3 3-Schichten-Architektur (User-Direktive bestaetigt durch Pilot)

```
┌──────────────────────────────────────────────────────────────────────┐
│ Schicht 1: src/ (Topic-uebergreifend, allgemein)                     │
│ ├── measurement/measurable_concept.hpp        MeasurableComponent    │
│ ├── permutations/permutation_strategy_concept.hpp  PermutationStrat. │
│ └── (weiter: builder/, abi/, api/, fingerprint/, ...)                │
└──────────────────────────────────────────────────────────────────────┘
                                  ↑ Spezialisierung
┌──────────────────────────────────────────────────────────────────────┐
│ Schicht 2: topics/<topic>/concepts/topic_<topic>_concept.hpp         │
│  Topic-Marker-Concept (z.B. AllocatorComponent mit topic_tag)        │
└──────────────────────────────────────────────────────────────────────┘
                                  ↑
┌──────────────────────────────────────────────────────────────────────┐
│ Schicht 3: topics/<topic>/axis_<NN>_<name>/concepts/                 │
│  Achsen-Concepts (Pflicht-API + Sub-Concepts mit Refinements)       │
│   + axis_<NN>_<name>_strategy_base.hpp  CRTP-Basis                  │
│   + axis_<NN>_<name>_<vendor>.hpp       Konkrete Vendor-Wrapper     │
└──────────────────────────────────────────────────────────────────────┘
```

### §13.4 Parallel-Concepts (User-Direktive)

```
AllocatorStrategy                      CacheEnginePermutationStrategy
(Standard-Pflicht, PMR-konform)        (cache-engine-spec, parallel Pflicht)
├ allocate(bytes, alignment)           ├ typename axis_tag (AA1-AA7)
├ deallocate(p, bytes, align) noexcept ├ typename family_id (A01-A23)
├ value_type / size_type               ├ static constexpr is_thread_safe()
├ operator==                           ├ static constexpr supports_pmr()
└ copy_constructible + nothrow_destr.  ├ static constexpr max_alignment()
                                        ├ static constexpr name() / family_name()
              ↓                         ├ statistics() [WENN STATISTICS=ON]
   6 Sub-Concept-Refinements:          └ reset()      [WENN STATISTICS=ON]
   - ZeroingStrategy
   - OverAllocatingStrategy
   - IntrospectableStrategy
   - ReclaimableStrategy
   - PoolResettableStrategy (release_all)
   - ReallocatingStrategy
```

Eine Klasse erfuellt typischerweise **beide Pflicht-Concepts** + optional N Sub-Refinements.

### §13.5 CMake-Flag `COMDARE_CE_ENABLE_STATISTICS` (Production-Build ohne Mess-Overhead)

**Definition:** `CMakeLists.txt` Zeile 38ff:
```cmake
option(COMDARE_CE_ENABLE_STATISTICS
    "V41.F.6.1.A: Topic+Achsen-Statistics enabled (jede Achse muss statistics()+reset() bieten)"
    ON)
if(COMDARE_CE_ENABLE_STATISTICS)
    add_compile_definitions(COMDARE_CE_ENABLE_STATISTICS=1)
endif()
```

**Auswirkung bei OFF:**
1. `CacheEnginePermutationStrategy`-Concept verlangt KEIN `statistics()` + `reset()` mehr
2. Topic+Achsen-Wrapper-Klassen (z.B. `StdMalloc`) #ifdef'n:
   - `statistics()` + `reset()` Methoden weg
   - `stats_` Member weg
   - alle stats-Updates in `allocate/deallocate/zero_allocate/reallocate` weg
3. CRTP-Basis Delegate-Methoden `statistics()`/`reset()` weg
4. Production-Binary einer Final-Permutation enthaelt **keinen Mess-Overhead**

**Verifikation Pilot (2026-05-25):**
- STATISTICS=ON → 18 Tests passing (inkl. `ResetClearsStatistics` Test)
- STATISTICS=OFF → 17 Tests passing (Statistik-Tests #ifdef'd raus)

### §13.6 Naechste Pilot-Iterationen (engmaschig)

| Iteration | Inhalt | Status |
|-----------|--------|--------|
| F.6.1.A   | Pilot allocator/axis_06 (10 Files + Concepts + StdMalloc + Test) | **DONE** (HEAD 20dd0fa) |
| F.6.1.A+  | Concept-Vollausbau Permutation+Statistics mit Observer + Boost.MP11 + CMake-Flag | **DONE** (HEAD 8257c15) |
| F.6.1.B   | NEUE Wrapper-Files: `std_allocator_wrapper` + `pmr_resource_wrapper` (kompatibel mit neuem Concept) | TODO |
| F.6.1.C   | Mimalloc + Snmalloc Vendor-Wrapper als Concept-Generalisierungs-Beweis (mehr Sub-Concepts erfuellt) | NEXT |
| F.6.1.D   | StdMalloc um axis_id/family_id/variant_tag/variant_hash erweitern (PermutationVariant-Concept) | TODO |
| F.6.1.E   | 2. Topic anlegen (`queuing/` mit W2-Buffer-Strategien) — validiert Pattern-Generalisierung | TODO |
| F.6.1.F   | Cross-Constraint-Validator (W3-Pattern) | TODO |
| F.6.2     | Migration der 27 BASIS-Files bestehender prt-art-Headers in neue Topics | TODO |
| F.6.3     | prt-art Namespace-Restrukturierung (`comdare::prt_art::*` → `comdare::cache_engine::<topic>::<axis>::prt_art::*`) | TODO |

---

## §14 Roadmap-Erweiterung 2026-05-25 spaet (User-Direktive, NUR ELABORAT DOKUMENTIERT)

User-Direktive 2026-05-25 abendlich spaet: nach Sichtung der bestehenden Strukturen unter
`https://github.com/BenniProbst/comdare-cache-engine/tree/main/libs/cache_engine` +
`https://github.com/BenniProbst/comdare-cache-engine/tree/main/libs` +
`https://github.com/BenniProbst/comdare-cache-engine/tree/main/apps` +
`https://github.com/BenniProbst/comdare-cache-engine/tree/main/adapters` +
`https://github.com/BenniProbst/comdare-cache-engine/tree/main/ext` +
`https://github.com/BenniProbst/comdare-cache-engine/tree/main/modules` +
`https://github.com/BenniProbst/comdare-cache-engine/tree/main/tools`

sind acht zusaetzliche strukturelle Konsolidierungs-Punkte identifiziert.

**WICHTIG:** Dieser Abschnitt ist NUR Architektur-Roadmap. Aktuelle Aufgaben (F.6.1.C Mimalloc/Snmalloc-Adapter, dann F.6.1.D StdMalloc-Erweiterung, dann F.6.1.E Queuing-Topic) bleiben prioritaer. Umsetzung von §14 erfolgt **NACH** Pilot-Vollausbau + nach mind. 2 Topics-Validierung des Patterns.

**Repo-Status:** Diplomarbeit-Repo `probst-Diplomarbeit-cache-engine` ist seit 2026-05-25 abendlich **PUBLIC** auf GitHub (vorher PRIVATE). Prof. Habich kann mitlesen.

### §14.1 Bestehende libs/cache_engine Verzeichnisse → Migration nach topics/ + src/

User-Direktive: "die bestehende Architektur die du vorher in groben (falschen) Schritten ausgeheckt hattest, nach topics, src und die anderen libs und Module unter `libs/` auszulagern und weiter wie gehabt KLEINSCHRITTIG zu konsolidieren."

Bestehende Verzeichnisse die migriert werden muessen (nach §11.7.C Mapping):

| Bestehend | Soll | F.6.2 Sub-Task |
|-----------|------|----------------|
| `libs/cache_engine/subsystems/c01_cost_engine/` | `libs/cache_engine/src/cost_engine/` (Teil V3 Engine-Choice) | F.6.2.X |
| `libs/cache_engine/subsystems/c02_pinning_engine/` | `topics/hardware/axis_12_general_hardware/sub_pinning/` | F.6.2.X |
| `libs/cache_engine/subsystems/c03_prefetch_engine/` | `topics/prefetch/axis_07_prefetch/` | F.6.2.X |
| `libs/cache_engine/subsystems/c04_coherence_engine/` | `topics/concurrency/axis_08/sub_83_coherence/` | F.6.2.X |
| `libs/cache_engine/subsystems/c05_telemetry_engine/` | `topics/telemetry/axis_11_telemetry/` | F.6.2.X |
| `libs/cache_engine/subsystems/c06_allocation_engine/` | `topics/allocator/axis_06_allocator/` | F.6.2.X |
| `libs/cache_engine/subsystems/c07_migration_engine/` | `topics/migration/axis_migration/` (NEUES Topic) | F.6.2.X |
| `libs/cache_engine/subsystems/c08_encoding_engine/` | `topics/serialization/axis_10_compression/` | F.6.2.X |
| `libs/cache_engine/subsystems/c09_heuristik_engine/` | `src/heuristics/` | F.6.2.X |
| `libs/cache_engine/subsystems/c10_topologie_engine/` | `topics/hardware/axis_topologie/` (Sub-Achse hardware) | F.6.2.X |
| `libs/cache_engine/subsystems/c11_scheduler_engine/` | **ZERLEGT in 7 Sub-Achsen pro Topic** (W3-Pattern) | F.6.2.X |
| `libs/cache_engine/subsystems/c12_filter_engine/` | `topics/filter/axis_filter/` (NEUES Topic) | F.6.2.X |

Migration KLEINSCHRITTIG pro Subsystem, jeweils 104 Tests gruen halten.

### §14.2 apps/cache_engine_builder als kompilierbares Tool/Submodule

User-Direktive: "Dazu gehoert spaeter auch die Klassifizierung des cache_engine_builder unter `apps/` als kompilierbares Tool (vielleicht auch ein Submodule und eigenes Projekt unter comdare-cache-engine unter modules)."

**Bestehend:** `apps/cache_engine_builder/` ist heute Teil des cache-engine-Repos (direkt-builtin).

**Soll-Optionen:**

| Option | Beschreibung | Konsequenz |
|--------|--------------|------------|
| A | Bleibt unter `apps/cache_engine_builder/` als reines Tool | minimal Aenderung, keine Wiederverwendung extern |
| B | Migration zu `tools/cache_engine_builder/` (analog anderen Tools) | konsistente Tool-Verzeichnisstruktur |
| C | NEUES Submodule `modules/comdare-cache-engine-builder/` (eigenes Repo) | wiederverwendbar in anderen Comdare-Projekten, eigenes Versionierung |

**Empfehlung Option C** wenn CacheEngineBuilder generisch nutzbar werden soll (z.B. fuer prt-art Sub-Builds, oder fuer andere Pruefling-Projekte ohne cache-engine selbst).

### §14.3 adapters/ + ext/ mergen — Achsen-Adapter direkt in Achsen-Unterordner

User-Direktive: "Wir haben unter `comdare-cache-engine/` noch adapters, die eigentlich mit `ext/` gemerged werden muessen, um je externer Ressource Erweiterungen fuer Achsen zu definieren, die direkt in einem Unterordner in der Achse mit einem Adapter fuer die Permutation nutzbar gemacht werden. So haben wir sonst mehrere schwer wartbare orthogonale Strukturen."

**Bestehend (orthogonal, schwer wartbar):**
- `ext/A01-Hoard/`, `ext/A04-mimalloc/`, ..., `ext/P01-ART/`, `ext/P04-CoCo-trie/`, ... (Vendor-Originalcode mit eigenen Build-Systemen)
- `adapters/A0*/`, `adapters/P0*/` (Comdare-Adapter-Wrapper auf Vendor-API)

**Soll (Achsen-zentriert, eine Stelle pro Vendor):**
```
topics/<topic>/axis_<NN>_<topic>/
├── concepts/                               (wie heute)
├── axis_<NN>_<topic>_std_malloc.hpp        (eigene Default-Variants)
├── ...
└── vendors/                                (NEU — externe Vendor-Wrapper pro Achse)
    ├── A04_mimalloc/
    │   ├── ext_source/                     (vorher unter ext/A04-mimalloc/, oder Symlink)
    │   ├── adapter/                        (vorher unter adapters/A04/, jetzt hier)
    │   └── axis_06_allocator_mimalloc.hpp  (Pruefling-Permutations-Wrapper)
    ├── A06_tcmalloc/...
    └── A14_tcmalloc_warehouse/...
```

**Vorteil:** pro Vendor 1 Verzeichnis-Slot, der Vendor-Source + Adapter + Wrapper buendelt. Keine orthogonalen Verzeichnisbaum-Strukturen mehr.

**Migration:** F.6.X — pro Vendor schrittweise migrieren, ext/ + adapters/ Verzeichnisse leeren wenn alle Vendor in topics/<topic>/axis_<NN>/vendors/<vendor>/ umgezogen sind.

### §14.4 modules/ vs tools/ — alle als Submodules

User-Direktive: "Wenn ich mir jetzt ausserdem in der comdare-cache-engine die modules und die tools anschaue, dann ist der einzige thematische Unterschied zwischen den Beiden, dass die modules vollstaendig git getrackte Submodules sind. Die Tools lassen sich ALLE in wiederverwendbare generische Module umbauen und ebenfalls als tools-Submodule definieren."

**Bestehend:**
- `modules/comdare-{search-engine, cache-engine-core, measurement, isa-dispatch, build-tools, test-system}/` (6 echte Git-Submodules)
- `tools/permutation_codegen/`, `tools/perf_counters/`, ... (direkt im cache-engine-Repo)

**Soll:** ALLE Tools als wiederverwendbare generische Submodules definieren — z.B.:
- `modules/comdare-permutation-codegen/` (statt `tools/permutation_codegen/`)
- `modules/comdare-perf-counters/` (statt `tools/perf_counters/`)
- `modules/comdare-cache-engine-builder/` (statt `apps/cache_engine_builder/`, siehe §14.2)

**Konsequenz:** `tools/`-Verzeichnis wird obsolet. cache-engine ist Aggregator-Repo mit nur `modules/`-Submodules + `topics/` + `src/`. Wiederverwendbarkeit der Tools in anderen Comdare-Projekten (z.B. nur permutation_codegen aus anderem Projekt ziehen ohne cache-engine selbst).

### §14.5 Mess-Strategien als statisch CMake-einstellbare src-Komponenten

User-Direktive: "Hinweis: die hier verwendeten Modules sind in unseren gerade eben erstellten Concepts unter anderem valide Strategien sofern es um Messung geht, also muessen wir bezueglich Messung notieren, dass auch hier Mess-Strategien als separates src, statisch cmake-einstellbar definiert werden koennen."

**Konkret:**
- `comdare-measurement` Submodule (aktuell Skelett unter `modules/`) liefert Mess-Strategien
- Diese Strategien sind valide Implementations des `MeasurableComponent`-Concepts (siehe §13.4)
- Sie sind **selbst eine Achse** — verschiedene Mess-Strategien (z.B. Welch-T-Test vs Mann-Whitney-U vs Anderson-Darling) können per CMake-Option `COMDARE_CE_STATS_STRATEGY=welch|mannwhitney|anderson` statisch gewaehlt werden
- Compile-Time-Selektion via `if constexpr` oder `using StatsStrategy = WelchStrategy;`

**Code-Skizze (zukuenftig in `src/measurement/strategy_selector.hpp`):**
```cpp
#if defined(COMDARE_CE_STATS_STRATEGY_WELCH)
    using ActiveStatsStrategy = WelchTTestStrategy;
#elif defined(COMDARE_CE_STATS_STRATEGY_MANNWHITNEY)
    using ActiveStatsStrategy = MannWhitneyUStrategy;
#else
    using ActiveStatsStrategy = NoStatsStrategy;  // wenn STATISTICS=OFF
#endif
```

Damit ist die Mess-Strategie selbst ein eigener Permutationsfaktor (jede Pruefling-Permutations-Binary kann anders konfiguriert sein).

### §14.6 reclamation/ ist strukturell falsch positioniert

User-Direktive: "Dann sehe ich noch die strukturellen Probleme, dass reclamation bei `libs/cache_engine/reclamation/` falsch positioniert ist, weil wir ja definiert hatten, dass es eine Achse unter einem Topic ist."

**Bestehend:** `libs/cache_engine/reclamation/rcu_reclaim/` als Top-Level-Verzeichnis (parallel zu subsystems, concurrency_manager, ...).

**Soll:** Migration nach `topics/allocator/axis_06_allocator/sub_62_reclamation/`. Mapping bereits in §11.7.C dokumentiert.

**Zusammenhang mit V42.P1.2 (comdare-rcu eigene Implementation):** F2-Beschluss erfordert eigene RCU-Impl unter dem korrekten Pfad — also direkt in `sub_62_reclamation/` migrieren, nicht im alten reclamation/-Pfad ausbauen.

### §14.7 concurrency_manager/* → topics/concurrency/axis_08/sub_*

User-Direktive: "Dann haben wir noch den concurrency_manager unter `libs/cache_engine/concurrency_manager/` dessen Unterpunkte streng genommen jeweils eine Achse unter einem concurrency-topic sind, deren definierte Strategien gegeneinander geprueft werden muessen."

**Bestehend (8 Unterpunkte als Top-Level Sub-Verzeichnisse):**
- `concurrency_manager/array_concurrency/`
- `concurrency_manager/data_structure_concurrency/`
- `concurrency_manager/memory_access_concurrency/`
- `concurrency_manager/node_concurrency/`
- `concurrency_manager/page_concurrency/`
- `concurrency_manager/path_concurrency/`
- `concurrency_manager/simd_flow_concurrency/`
- `concurrency_manager/simd_thread_concurrency/`

**Soll:**
```
topics/concurrency/
├── concepts/topic_concurrency_concept.hpp
└── axis_08_concurrency/
    ├── concepts/axis_08_concurrency_concept.hpp
    ├── sub_array/                  (← array_concurrency)
    ├── sub_data_structure/         (← data_structure_concurrency)
    ├── sub_memory_access/          (← memory_access_concurrency)
    ├── sub_node/                   (← node_concurrency)
    ├── sub_page/                   (← page_concurrency)
    ├── sub_path/                   (← path_concurrency)
    ├── sub_simd_flow/              (← simd_flow_concurrency)
    └── sub_simd_thread/            (← simd_thread_concurrency)
```

**Permutations-Konsequenz:** jede Sub-Achse ist eine eigene Permutationsdimension. Cartesian-Product 8 Sub-Achsen × ihre Variants kann grosse Zahlen erzeugen — siehe §14.8.

### §14.8 Sonderfall concurrency: hybrider statisch+dynamisch Variant-Ansatz

User-Direktive: "Im Sonderfall von concurrency lohnt sich die vollstaendige Kompilation nicht, wenn der eigentliche switch in jeder Strategie im Prinzip nur eine einzige Variable betrifft, weshalb wir hier nur fuer besonders kleine Achsen-Anpassungen den hybriden dynamischen Ansatz von `std::variant<>` in Kombination mit static compiled variant verwenden — das concurrency-Topic ist fuer SIMD-Themen statisch variant in der Strategie kompiliert und fuer alle uebrigen Achsen gilt, dass wir dynamisch zur Laufzeit Permutationen durch-iterieren, also concurrency-thresholds permutativ ausprobieren, indem wir uns darauf besinnen dass sinnvolle Limits den Suchraum stark einschraenken."

**Konkrete Regel pro concurrency-Sub-Achse:**

| Sub-Achse | Variant-Strategie | Begruendung |
|-----------|-------------------|-------------|
| `sub_simd_flow/` | **statisch** (compiled per Permutation) | SIMD-Code-Pfade sind ISA-spezifisch + branch-frei optimiert; Runtime-Switch im Hot-Path zerstoert Vector-Pipeline |
| `sub_simd_thread/` | **statisch** | gleich wie sub_simd_flow |
| `sub_array_concurrency/` | **dynamisch (std::variant<> + Runtime-iter)** | Threshold-basierte Permutationen (z.B. lock-free-cutoff bei N elements), sinnvolle Limits schraenken Suchraum stark ein |
| `sub_data_structure/` | **dynamisch** | analog |
| `sub_memory_access/` | **dynamisch** | analog |
| `sub_node/` | **dynamisch** | analog |
| `sub_page/` | **dynamisch** | analog |
| `sub_path/` | **dynamisch** | analog |

**Hybride Variant-Architektur:**
```cpp
// Statisch (SIMD): jede Permutation = eigene Binary
template <typename SimdFlowVariant, typename SimdThreadVariant>
class ConcurrencyEngine_Static { /* ... */ };

// Dynamisch (alle anderen): EINE Binary, Runtime-iteration ueber sinnvolle Thresholds
class ConcurrencyEngine_Dynamic {
    std::variant<LockFreeUnder<10>, LockFreeUnder<100>, LockFreeUnder<1000>,
                 SpinLock<2>, SpinLock<8>, SpinLock<32>,
                 MutexBase> threshold_strategy_;
public:
    void switch_strategy(ConcurrencyThreshold limit) { /* runtime variant assignment */ }
};

// Hybrid-Komposition:
template <typename SimdF, typename SimdT>
class ConcurrencyEngine {
    ConcurrencyEngine_Static<SimdF, SimdT> simd_;     // compile-time
    ConcurrencyEngine_Dynamic               threshold_; // runtime
};
```

**Konsequenz fuer Permutations-Zahl:** Wenn SIMD (2 statische Sub-Achsen mit z.B. 5 Variants) statisch und 6 dynamische Sub-Achsen runtime-iteriert werden:
- Statisch: 5 × 5 = 25 Concurrency-SIMD-Permutations-Binaries
- Dynamisch: 6 × ~5 Thresholds = 30 Runtime-Iterationen pro Binary
- Effektive Mess-Reihen: 25 × 30 = 750 (statt 5 × 5 × 5⁶ = ~390.000 vollstaendig statisch)

**Mess-Praezisions-Anmerkung:** dynamische Threshold-Iteration im Mess-Hot-Path muss `[[gnu::hot]]` + Branch-Hint markiert sein, sonst zerstoert std::variant-Switch die ±0.1%-Praezision (siehe Memory `[[no-runtime-switch]]` — Sonderfall concurrency-thresholds aufgehoben weil Switch nur einmal pro Mess-Reihe statt pro Operation).

**Generelle Regel:** `[[no-runtime-switch]]` gilt weiter fuer Achsen wo der Switch im Hot-Path liegt (allocator, layout, prefetch, ...). Ausnahme `concurrency::sub_*` (ausser SIMD): Switch nur zwischen Mess-Permutationen, nicht pro Operation.

### §14 Status-Marker

- **Doku-Aufnahme:** 2026-05-25 abendlich spaet (User-Direktive elaborate ergaenzen, keine Code-Aenderungen)
- **Code-Umsetzung:** NACH Pilot-Vollausbau (mind. F.6.1.B-F + F.6.1.E 2. Topic) — also fruehestens V41.F.6.2 oder spaeter
- **Tasks:** NICHT als separate Tasks angelegt — bleiben unter §14 als Architektur-Roadmap-Erweiterung referenzierbar
- **Memory:** keine neuen Memory-Files (alle Punkte gehoeren in Master-Doc-Referenz `[[reference-master-architektur-skizze]]`)

---

## §15 Roadmap-Erweiterung 2026-05-25 abendlich (nach Batch 1, weitere Strukturprobleme)

User-Direktive 2026-05-25 nach Batch 1 Vendor-Wrapper (F.6.1.C): NUR elaborat dokumentieren,
nicht direkt umsetzen — Code-Konzentration bleibt auf F.6.1.X Pilot-Vollausbau + W6-Recherche
(Metaprogrammierungs-Verbesserung).

### §15.1 benchmarks/ gehoert ins Mess-Modul + Facade-Pattern

User-Direktive: "Die Bestandteile des Ordners `https://github.com/BenniProbst/comdare-cache-engine/tree/main/benchmarks` gehoeren eigentlich in das Mess-Modul und sie sollten ueber ein Facade-Pattern Moeglichkeiten der Systemanalyse und Messung sowie Messdaten bereitstellen, welche wiederum die cache-engine ueber ihr eigenes Facade-Pattern der Diplomarbeit zur Verfuegung stellen kann. Die Unterordner sind hier wieder TODO-Stubs die mit hoechster Praezision gegen bestehende Features konsolidiert und final umgesetzt werden muessen. Auch hier gibt es ein weiteres Strukturproblem."

**Bestehend:** `benchmarks/` als Top-Level-Verzeichnis (parallel zu `apps/`, `libs/`, `ext/`, `adapters/`, `modules/`, `tools/`).

**Soll:** Migration in `modules/comdare-measurement/` (eines der 6 V41.E4 Skelett-Submodules).

**Facade-Architektur:**

```
Diplomarbeit-Container
    |
    | konsumiert
    v
cache-engine Facade (V41.E11 ICacheEngine — Schicht 1)
    |
    | vermittelt
    v
modules/comdare-measurement Facade (NEU — Schicht 2)
    |
    | vermittelt
    v
benchmarks/* (Systemanalyse, Mess-Strategien, Mess-Daten) — Schicht 3
```

**Konkret die `benchmarks/`-Unterordner sind heute TODO-Stubs** und muessen mit hoechster Praezision gegen bestehende Features konsolidiert werden:
- Pruefen: was ueberlappt mit `libs/cache_engine/builder/runtime_micro_benchmarks/`?
- Pruefen: was ueberlappt mit `libs/cache_engine/builder/in_memory_measurement_buffer/`?
- Pruefen: was ueberlappt mit `libs/cache_engine/builder/measurement_matrix/`?
- Pruefen: was ueberlappt mit `libs/cache_engine/builder/telemetry_spool/`?

**Migration in F.6.2.X-Iterationen:**
1. `benchmarks/<inhalt>` Audit + Mapping zu existierenden Mess-Komponenten
2. Code-Konsolidierung (Duplikate eliminieren, nicht-Duplikate ausbauen)
3. Migration nach `modules/comdare-measurement/src/`
4. Facade-Header `modules/comdare-measurement/include/IMeasurementFacade.hpp`
5. cache-engine `ICacheEngine::measurement()` Accessor (V41.E11 erweitert)
6. Diplomarbeit konsumiert nur `ce.measurement().<service>()`

**Bezug zu §11.7.B (src/-Hilfsfunktionen):** `src/measurement/` enthaelt heute nur den Concept-Skelett. Die echte Implementierung wandert NICHT nach `src/measurement/` sondern nach `modules/comdare-measurement/` (Submodule). `src/measurement/` bleibt fuer Topic-uebergreifende Concepts (`MeasurableComponent` etc.) zustaendig.

### §15.2 Compile-Flag-Strategie revidieren (W6-Recherche nachgelagert)

User-Kritik 2026-05-25 nach Batch 1: `#ifdef COMDARE_HAVE_<VENDOR>` pro Vendor-Wrapper ist
ineffizient + verteilt Compile-Schalter. Stattdessen:

**Soll-Pattern (W6-Recherche-Ergebnis abwarten):**
- Zentralisierte CMake-Flags pro Topic-Achse (z.B. `COMDARE_AXIS_06_ENABLE_A04=ON|OFF`)
- Variadische Topic-Registrierung mit Boost.MP11 (mp_list/mp_filter)
- Meta-programmierte if-else-Kette: pro registrierter Achs-Klasse Compile-Time-Test ob CMake-Flag ON → akkumulieren in `EnabledAxisVariants` mp_list
- Compiler verwirft unbenutzte Referenzen automatisch aus Binary (Linker-Strip)
- KEINE `#ifdef COMDARE_HAVE_*` mehr in Vendor-Wrapper-Klassen — nur in CMake-Topic-Registrierung
- Wartungskosten massiv reduziert

**Konsequenz fuer Batch 1 (Mimalloc/Snmalloc/PMR):** Vendor-Wrapper bleiben Code-konsistent (ohne Compile-Switches), aber die Topic-Registrierung filtert pro Build welche Wrapper instanziiert werden.

**Umsetzung:** NACH W6-Recherche, dann Refactoring von Batch 1 + Batch 2+ nutzen das neue Pattern.

### §15.3 AllocatorStrategyBase muss bei STATISTICS=ON variadische Statistik-Observer-Auswertung erzwingen

User-Kritik 2026-05-25: aktuell `AllocatorStrategyBase` hat `#ifdef COMDARE_CE_ENABLE_STATISTICS`
Delegate-Methoden — aber das Concept verlangt nicht zwingend dass die Derived-Klasse die
Statistik-Observer-Auswertungsklasse als variadische Erweiterung definiert.

**Soll:** Wenn STATISTICS=ON, muss `CacheEnginePermutationStrategy` zusaetzlich verlangen:
- `typename observer_t = MeasurableObserver<snapshot_t>` Pflicht-Alias
- `observer() const noexcept -> observer_t` Pflicht-Methode
- Variadische Akkumulation aller Observer pro Topic-Achse fuer externe Auswertung

Direkter Bezug zu §15.4 (Permutation Engine Verknuepfung).

### §15.4 PermutationEngine noch nicht mit Topic-System verknuepft

User-Kritik 2026-05-25: das `PermutationStrategy`-Concept (W5 Boost.MP11) ist heute
allgemein definiert — aber es gibt KEINE konkrete `PermutationEngine`-Klasse die die
variadische Registrierung der statisch kompilierbaren Bestandteile durchfuehrt.

**Soll:** `src/permutations/permutation_engine.hpp` (NEU) mit:
- `template <typename TopicAxisList> class PermutationEngine`
- Sammelt alle `EnabledAxisVariants` aus den Topic-Achsen (per CMake-Flag gefiltert)
- Bietet `enumerate_all_permutations()` Visitor-Pattern
- Bietet `select_for_pruefling<Pruefling>()` Pruefling-spezifische Filterung (via `prt_art` Namespace-Slot, §3-§11)

### §15.5 Hybride Laufzeit-Permutation pro Achse (iterierbarer ASPEKT)

User-Kritik 2026-05-25: PermutationEngine bietet noch KEINE generische Funktion ab, um
die **hybride Laufzeit-Permutation** in einer Achse zu iterieren, sofern mindestens ein
Achsen-Bestandteil einen **iterierbaren Aspekt** hat (vgl. §14.8 Sonderfall concurrency
threshold-Permutationen).

**Soll:** Achsen-Strategy-Klasse darf optional definieren:
- `typename iterable_aspect_t = void` (Default: keine Laufzeit-Iteration)
- `static constexpr std::span<iterable_aspect_t const> iterable_values()` Pflicht wenn aspect_t nicht void
- PermutationEngine erkennt iterierbaren Aspekt zur Compile-Time und generiert Hybrid-Variant:
  - Statisch: kartesisches Produkt aller Variants OHNE iterierbaren Aspekt
  - Dynamisch: pro Variant mit iterable_aspect_t → Runtime-Iteration via `for (auto v : iterable_values())`

**Konkret-Pattern fuer concurrency thresholds:**
```cpp
struct LockFreeConcurrency {
    using iterable_aspect_t = std::size_t;  // threshold N
    static constexpr std::array values{16, 64, 256, 1024, 4096};
    static constexpr std::span<std::size_t const> iterable_values() noexcept {
        return values;
    }
    // Runtime: threshold wird via setter eingestellt
};
```

PermutationEngine erkennt `iterable_aspect_t != void` → generiert Hybrid-Permutation:
- 1 Compile-Time-Binary fuer `LockFreeConcurrency` (statt 5 separate)
- Innerhalb der Binary: Runtime-Loop ueber 5 thresholds → 5 Mess-Datenpunkte

### §15.6 Bezug zu §14.8 Concurrency-Sonderfall

§15.5 ist die generelle Realisierung des in §14.8 fuer concurrency-Sonderfall beschriebenen
hybriden Ansatzes — als optionaler Aspekt pro Achs-Variant. Andere Achsen koennen es ebenfalls
nutzen (z.B. Buffer-Size-Thresholds in queuing-Topic, Cache-Ebenen-Schwellen in prefetch-Topic).

### §15.7 Topic-constexpr-Konfigurations-Set + CacheEngineBuilder als C++-App-Orchestrator

User-Direktive 2026-05-25 nach W6-Recherche:
"Jedes Topic soll ein constexpr-Set an Achs-Konfigurationen tragen (eine je Achse, dynamische
Permutation mit den constexpr-Listen der durchzufuehrenden Aspekt-Iterations-Permutationen),
welches ueber architektonisch als Build-Orchestrator separat geladene Modul CacheEngineBuilder
konfiguriert und on-demand (oder default precompile) gebaut wird."

**Soll-Architektur (klare Trennung statisch/dynamisch):**

```
┌──────────────────────────────────────────────────────────────────────┐
│  CacheEngineBuilder (separate C++-App, nicht CMake)                  │
│  Hauptfunktionen:                                                     │
│   - Liest constexpr-Topic-Konfigurations-Sets                         │
│   - Bestimmt welche Permutationen zu bauen sind (Meta-Konfiguration) │
│   - Stoesst CMake mit dynamischen Flags pro Permutation an           │
│   - Trennt Experiment-Durchfuehrungs-Strategie + Testdaten von      │
│     realer permutierter Binary-Implementierung                       │
└──────────────────────────────────────────────────────────────────────┘
              |                                            |
              | a) STATIC: stoesst Compile pro Perm an     | b) DYNAMIC: lade Binaries
              v                                            v
┌──────────────────────────────┐         ┌─────────────────────────────────┐
│ Compile-Time:                │         │ Runtime: Pre-Built Permutations │
│ Statischer Bestandteil       │         │ - dynamisches Laden (.so/.dll)  │
│ jeder Permutation Engine     │         │   via C++23 import oder dlopen  │
│ - axis_06_registry.hpp       │         │ - Pro Binary intern KEINE       │
│   AllVendors / EnabledVendors│         │   weiteren dlopen, ALLES static │
│ - mp_filter, mp_product      │         │   gelinkt (V41.E10 Direktive)   │
│ - PermutationEngine          │         │ - **Innerhalb der Binary:**     │
│   <TopicConfigSet>           │         │   dynamische Aspekt-Iteration   │
│ - per Vendor enabled-flag    │         │   ueber iterable_aspect_t span  │
│ - Wrapper-Code mit if constexpr│       │   z.B. concurrency thresholds  │
└──────────────────────────────┘         └─────────────────────────────────┘
```

**Warum C++-App statt CMake-Script fuer CacheEngineBuilder:**
- Mehr Kontrolle ueber Permutations-Strategy (Reihenfolge, Filterung, Constraint-Erkennung)
- Meta-Konfiguration: Experiment-Strategy + Testdaten klar getrennt von der realen Binary-Implementation
- Modular: CacheEngineBuilder kann pro Pruefling spezifische Permutations-Subsets steuern
- C++ erlaubt direkte Compile-Time-Auswertung der constexpr-Topic-Konfigurations-Sets
- Saubere Trennung: Experiment-Orchestrierung (C++-App) vs Algorithmus-Implementierung (Wrapper)

**Statisch vs Dynamisch Trennung (klar spezifiziert):**

| Aspekt | Statischer Anteil | Dynamischer Anteil |
|--------|-------------------|---------------------|
| **Wer steuert** | CacheEngineBuilder (C++-App, build-time) | Pre-Built Binary (run-time) |
| **Was wird permutiert** | cache-engine-Achsen (Allokator, Layout, Prefetch, ...) | Aspekt-Iterations (z.B. Concurrency Thresholds 16/64/256/1024/4096) |
| **Wie kompiliert** | Eine eigene Binary pro Achsen-Kombination | EINE Binary mit Runtime-Loop ueber iterable_values() |
| **Latenz-Verhalten** | KEINE Latenz (alles static gelinkt, V41.E10) | Wechsel ueber Threshold-Span ist setter-Aufruf zwischen Mess-Reihen, NICHT in jeder Operation |
| **Mess-Reihen pro Binary** | 1 Mess-Reihe = 1 Binary | N Mess-Reihen pro Binary (eine je iterable_value) |

**Topic-Konfigurations-Set (constexpr):**

Pro Topic eine zentrale Konfigurations-Datei, die alle Achsen + Aspekt-Iterations zentral deklariert:

```cpp
// topics/allocator/topic_allocator_config_set.hpp (NEU, kommt in F.6.1.D)
namespace comdare::cache_engine::allocator {
struct TopicConfigSet {
    // Static-Variant-Liste (CacheEngineBuilder generiert Binary pro Eintrag)
    using StaticAxisVariants = EnabledVendors;   // = mp_filter aus axis_06_registry

    // Dynamic-Aspekt-Iteration (Runtime-Loop innerhalb jeder Binary)
    template <class Vendor>
    using AspectIterations = typename Vendor::iterable_aspect_t;  // void wenn keine

    template <class Vendor>
    static constexpr auto aspect_values() {
        if constexpr (!std::is_void_v<AspectIterations<Vendor>>) {
            return Vendor::iterable_values();  // z.B. std::array{16, 64, 256, 1024, 4096}
        } else {
            return std::array<int, 0>{};
        }
    }
};
}
```

**CacheEngineBuilder (separate C++-App) konsumiert TopicConfigSet:**

```cpp
// apps/cache_engine_builder/main.cpp (REFACTOR von heutiger Binary)
int main(int argc, char** argv) {
    // Lade Meta-Konfiguration (Experiment-Strategy, Testdaten, ...)
    auto meta_cfg = load_meta_config(argv[1]);

    // Compile-Time: enumeriere alle StaticAxisVariants pro Topic
    mp_for_each<allocator::TopicConfigSet::StaticAxisVariants>([&](auto V){
        // Generiere CMake-Build pro Vendor-Permutation
        invoke_cmake_build_for_permutation<decltype(V)>(meta_cfg);
    });

    // Runtime (separater Schritt): lade Binaries + fuehre Mess-Reihen aus
    // - Pro Binary: intern Runtime-Loop ueber aspect_values<Vendor>()
}
```

**Bezug zu §14.8 / §15.5 hybride Laufzeit-Permutation:**

§15.7 ist die formale Spezifikation. §14.8 + §15.5 sind die konkrete Anwendung fuer
concurrency-Sonderfall mit iterable_aspect_t = std::size_t (threshold).

**Pflicht-Pattern fuer alle Topics:** Constexpr TopicConfigSet definiert WAS permutiert wird
(statisch + dynamisch), CacheEngineBuilder definiert WIE die Mess-Reihen orchestriert werden.

### §15.8 Stufe 2 LIVE + offene Aufgaben fuer Stufe 3+ (Session-Uebergabe 2026-05-26)

**Stufe 1+2 abgeschlossen (cache-engine HEAD 2d55de3, Diplomarbeit e576f61):**
- ✅ CMake-Optionen `COMDARE_AXIS_06_ENABLE_<VENDOR>` (Default ON)
- ✅ `axis_06_allocator_flags.hpp.in` configure_file mit `USE_<VENDOR>` = ENABLE && HAVE
- ✅ `vendor_includes/` Shims mit Forward-Stubs (einzige #if-Stelle pro Vendor)
- ✅ `axis_06_allocator_registry.hpp` mit `AllVendors` + `EnabledVendors` mp_filter
- ✅ Wrapper StdMalloc/Mimalloc/Snmalloc/PMR refactored: KEIN `#ifdef COMDARE_HAVE_*` mehr, alles via `static constexpr bool enabled = flags::<vendor>_enabled` + `if constexpr`
- ✅ 33/33 Standalone-Tests + 104/104 Diplomarbeit-Tests gruen

**Stufe 3 ANGEFANGEN, Observer-Konzept BLEIBT als Pflicht-Architektur (Aktivierung verschoben):**
- Observer-Konzept ([[statistics-observer-pflicht]]) ist und bleibt **Pflicht-Bestandteil** der Architektur — User-Klarstellung 2026-05-26: "das observer Konzept ist NICHT gestrichen"
- Concept-Constraint `typename observer_t + observer()` Pflicht wenn STATISTICS=ON wurde im Concept-File temporaer auskommentiert (TODO-Marker), weil WRAPPER-Klassen die observer_t-API noch nicht implementieren
- TODO-Marker steht jetzt im Concept-File als verbindliche Erinnerung — Aktivierung in der naechsten Iteration zusammen mit Wrapper-Updates
- **Naechste Iteration F.6.1.I:**
  1. Wrapper-Klassen erweitern: `using observer_t = ::comdare::cache_engine::measurement::MeasurableObserver<snapshot_t>;`
  2. Wrapper-Member: `observer_t observer_;`
  3. Wrapper-Methode: `[[nodiscard]] observer_t const& observer() const noexcept { return observer_; }`
  4. allocate/deallocate/reallocate/zero_allocate ergaenzen um `observer_.notify(stats_);` nach jedem stats-Update
  5. Concept-Constraint im axis_06_allocator_cache_engine_permutation_concept.hpp REAKTIVIEREN (TODO-Kommentar entfernen)
  6. Tests fuer Observer-Notify-Pattern (Callback-Registrierung + notify-Empfang)

### §15.9 Pflicht min-1-Algorithmus pro Achse (User-Direktive 2026-05-26)

User-Direktive: "Wir definieren, dass wir je Achse mindestens einen Algorithmus fuer
Permutationen anbieten muessen, dazu verwenden wir ebenfalls mp11. Soweit ich das sehe,
fuehrt diese fehlende Grenze derzeit dazu, dass noch verbotene Permutationen moeglich
sind, die der CacheEngineBuilder erlauben koennten den Build zu crashen."

**Heute (Stufe 2 LIVE):**
- `axis_06_allocator_registry.hpp` hat `static_assert(mp_size<EnabledVendors>::value > 0)`
- Aber **nur** als Sanity-Check innerhalb dieser einen Achse — KEINE achsen-uebergreifende Grenze

**Soll-Erweiterung (Stufe 3+):**
- **Topic-uebergreifender mp11-Constraint:** PermutationEngine pruefe pro Achse dass `mp_size<EnabledVendors_<axis>>::value >= 1`
- **CacheEngineBuilder muss Achsen-Vollstaendigkeit validieren** BEVOR er CMake-Build mit `cmake -DCOMDARE_AXIS_<NN>_ENABLE_<V>=ON|OFF` Build-Flags startet
- **Crash-Vermeidung:** wenn der Builder eine Achse mit 0 Variants konfigurieren wuerde → frueh Compile-Fail-Diagnostik (klar formuliert), NICHT spaeter Linker-Crash

**Konkrete Implementation (TODO V41.F.6.1.H):**
```cpp
// src/permutations/permutation_engine.hpp (NEU, geplant)
template <class... TopicAxisLists>
class PermutationEngine {
    // Compile-Time Pflicht: alle Achsen-Listen NICHT-leer
    static_assert(
        (boost::mp11::mp_size<typename TopicAxisLists::variants>::value > 0 && ...),
        "PermutationEngine: jede Topic-Achse muss mindestens 1 enabled Vendor haben."
        " Pruefe COMDARE_AXIS_<NN>_ENABLE_<VENDOR> CMake-Flags pro Achse."
    );
    // ...
};
```

### §15.10 USE-Flags via CacheEngineBuilder CLI (User-Direktive 2026-05-26)

User-Direktive: "Die CacheEngineBuilder Anwendung wird die Kompilation mit Build-Flags
fuer die Permutation-Binary aufrufen und daher direkt auf der Kommandozeile setzen."

**Konkrete Implementation (TODO V41.F.6.1.G):**

```cpp
// apps/cache_engine_builder/main.cpp (geplant)
int main(int argc, char** argv) {
    auto meta_cfg = load_meta_config(argv[1]);

    // Compile-Time: enumeriere alle Permutationen aus TopicConfigSet (siehe §15.7)
    mp_for_each<allocator::TopicConfigSet::StaticAxisVariants>([&](auto V){
        // Pro Permutation-Variant ein CMake-Build mit dynamischen Flags via CLI
        std::string cmake_cmd = "cmake -B build/perm_" + std::to_string(V::variant_hash);
        cmake_cmd += " -DCOMDARE_AXIS_06_ENABLE_STD=OFF";       // disable
        cmake_cmd += " -DCOMDARE_AXIS_06_ENABLE_" + std::string{V::name} + "=ON";  // enable nur dieser
        // ... weitere Achsen-Flags pro Permutation-Element
        std::system(cmake_cmd.c_str());

        // dann: cmake --build build/perm_<hash> --config Release
    });
}
```

**Vorteil:**
- Keine separate Build-Konfig-Datei je Permutation noetig
- CMake-Cache pro Permutations-Build-Verzeichnis isoliert
- Pro Permutation eine eigene Binary `perm_<hash>.so/.dll`
- CacheEngineBuilder kontrolliert vollstaendig welche Vendor je Permutation aktiv sind

**Konsequenz fuer Stufe 1+2 Refactoring:**
- Die heute vorhandene `COMDARE_AXIS_06_ENABLE_*` Optionen sind die richtige Schnittstelle fuer den CacheEngineBuilder
- HAVE-Detection bleibt im ext/CMakeLists.txt (Verfuegbarkeit der Vendor-Header)
- USE = ENABLE && HAVE als effektive Aktivierung weiterhin via CMakeLists.txt am Ende

### §15.11 mp11-Limits + Vendor-Vollausbau (User-Direktive 2026-05-26 nach F.6.1.G)

User-Frage 2026-05-26: "Ich habe gehoert, dass nur 10 templates in einer variadischen
Liste unterstuetzt werden — koennen wir die ganze Allokations-Achse (~23 Vendor) ueberhaupt
mit mp11 abbilden?"

**Recherche-Ergebnis (Agent 2026-05-26):**

Das "10-Template-Limit"-Geruecht stammt aus **altem Boost.MPL** (Vorgaenger, `BOOST_MPL_LIMIT_LIST_SIZE=20` Default wegen Preprocessor-Spezialisierungen).

**Boost.MP11 (modern, C++11+) hat KEIN solches Limit:**
```cpp
template <class... T> struct mp_list {};  // echtes variadic template, kein BOOST_MP11_LIMIT_* Makro
```

**Praktische Compiler-Limits:**

| Limit | GCC | Clang | MSVC |
|-------|-----|-------|------|
| Parameter-Pack-Size Standard-Minimum | 1024 | 1024 | 1024 |
| Template-Instantiation-Depth (Default) | 900 | 256 (!) | 500 |
| Flag zum Erhoehen | `-ftemplate-depth=N` | `-ftemplate-depth=N` | `/Zc:templateDepth=N` |

**Unser Use-Case (vollkommen unproblematisch):**
- Allocator-Achse: 23 Vendor (A01-A23, Vollausbau Batch 1-8)
- 15 Topic-Achsen × 3-5 Variants pro Achse
- Cartesian-Product: 30 × 15 × 5 = 2.250 Instanziierungen — sub-Sekunde Compile
- Kritisch wird erst ab ~100k Cartesian-Produkten (RAM 4-8 GB / Compile-Minuten)

**Empfehlung (Sicherheits-Puffer):** in `CMakeLists.txt` optional:
```cmake
target_compile_options(<target> PRIVATE
    $<$<CXX_COMPILER_ID:Clang>:-ftemplate-depth=1024>
    $<$<CXX_COMPILER_ID:GNU>:-ftemplate-depth=1024>
)
```

**Allocator-Achse Vendor-Vollausbau (~23 Implementierungen):**

| Batch | Vendor | Status |
|-------|--------|--------|
| Batch 1 | A04 mimalloc + A07 snmalloc + A22 pmr + A22 std | ✅ DONE Pilot |
| Batch 2 | **A05 Jemalloc + A06 TCMalloc + A20 dlmalloc** | NEXT |
| Batch 3 | A01 Hoard + A02 Slab + A03 Michael LockFree | pending |
| Batch 4 | A08 Scalloc + A09 NUMAlloc + A10 RPMalloc | pending |
| Batch 5 | A11 LRMalloc + A12 CAMA + A13 StarMalloc | pending |
| Batch 6 | A14 TCMalloc-Warehouse + A15 HMalloc + A16 PIM-Malloc | pending |
| Batch 7 | A17 Crystalline + A18 Exgen-Malloc + A19 Buddy | pending |
| Batch 8 | A21 ptmalloc2 + A23 Vmem-Magazines + (1 weiterer) | pending |

Alle 23 Vendor passen problemlos in `AllVendors = mp::mp_list<...>` (kein Limit).
Stufe 1+2 W6-Pattern (Flags + Shim + Wrapper-if-constexpr) skaliert linear.

### §15 Status-Marker (Stand 2026-05-26 Session-Ende)

- **Doku-Aufnahme:** 2026-05-25 abendlich → 2026-05-26 Session-Ende
- **W6 Web-Recherche:** DONE (zentralisierte CMake-Topic-Registrierung + MP11-Akkumulation)
- **Refactoring Batch 1 Stufe 1+2:** DONE (cache-engine 2d55de3 + Diplomarbeit e576f61)
- **Stufe 3 (Observer-Concept + PermutationEngine + iterable_aspect_t):** PENDING (TODO #657 + #658)
- **§15.7 TopicConfigSet + CacheEngineBuilder:** PENDING in F.6.1.D
- **§15.8 Concept-Constraint observer_t:** REVERTIERT, naechste Iteration aktivieren + Wrapper updaten
- **§15.9 min-1-Algorithmus pro Achse:** TODO neu (CacheEngineBuilder darf keinen 0-Achsen-Build starten)
- **§15.10 CacheEngineBuilder CLI-Flags:** TODO neu (apps/cache_engine_builder/main.cpp Refactor)
- **Tasks:** alle #635-#658 (siehe TaskList)
