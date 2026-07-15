# Paper-Legacy-Code Architektur (V41.F.6.1.P1, 2026-05-26)

**Stand:** 2026-05-26 nach traversal-Konsolidierung
**Vorgaenger:** `11_konzept_achsen_extension_visitor_pattern.md` + `12_queuing_topic_achsen_eigenschaften.md`
**Trigger:** User-Direktive (Habich-Compliance) — Paper-Original-Code mit Original-Compiler bauen
**Master-Cross-Memory:** `[[paper-original-code-pattern]]`, `[[experiment-compiler-property]]`,
`[[legacy-code-sha256-validation]]`, `[[pseudocode-papers-fallback]]`,
`[[consteval-sha256-function-validation]]`

---

## §1 Problem + Habich-Compliance-Konflikt

**Bisherige Praxis (V41.F.6.1 Stand vor 2026-05-26):**
Wir haben Algorithmus-Bodies aus Paper-Quellen teilweise in unsere
C++23-Wrapper kopiert (z.B. Allocator-Achse), teilweise als
"Inspirations-Patterns" re-implementiert (traversal-Achse). Das ist
**wissenschaftlich problematisch**:

| Symptom | Konsequenz |
|---|---|
| Original-Code copy-pasted in C++23-Wrapper | Compiler-Optimierungen aendern Performance-Charakteristik |
| Re-Implementation aus Pseudocode | Algorithmus-Aequivalenz nicht beweisbar |
| Kein SHA-Tracking | "Schummeln" theoretisch moeglich (Reviewer kann nicht pruefen) |
| Eine moderne Compiler-Version | Paper-Compiler-Eigenheiten (z.B. GCC-9.5-spezifisches Inlining) gehen verloren |

**Prof. Habich-Forderung (Diplomarbeit-Compliance):**
> "Fuer alle Paper moeglichst der Original-Code mit dem jeweils Original-Compiler
> kompiliert werden muss, sofern moeglich."

**Konflikt mit existierender Achs-Architektur:** Wir haben mit V41.F.6.1
ein cleaneres Concept-System gebaut, wollen aber nicht zurueck zu
Adapter-Pattern + virtual + Singleton-Facades. **Loesung:** Architektur
bleibt unveraendert, Code wird *gelinkt* statt kopiert.

---

## §2 Loesungs-Architektur (4 Schichten)

```
┌─────────────────────────────────────────────────────────────────┐
│ Schicht 1: C++23 Concept-System (unveraendert — V41.F.6.1)      │
│ libs/cache_engine/topics/<topic>/axis_<NN>/concepts/             │
│ - axis_<NN>_<topic>_concept.hpp (Standard-Pflicht-API)           │
│ - axis_<NN>_<topic>_cache_engine_permutation_concept.hpp         │
│   (cache-engine-spec — ERWEITERT um experiment_compiler() +      │
│    has_original_paper_code() + is_original_module())             │
│ - Sub-Concept-Files (LegacyOriginalCodeStrategy NEU)             │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ delegiert wenn has_original=true
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ Schicht 2: C-Interface Adapter (Pflicht pro Paper-Wrapper)       │
│ libs/cache_engine/topics/<topic>/axis_<NN>/                      │
│ - axis_<NN>_<topic>_<wrapper>_original.hpp+cpp                   │
│   extern "C" Wrapper um Paper-API (z.B. mi_malloc → allocate)    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ linkt gegen
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ Schicht 3: Paper-Original-Code (kuratiert + git-tracked)        │
│ libs/cache_engine/topics/<topic>/axis_<NN>/legacy_code/          │
│ - paper_<id>_<paper_name>/                                       │
│   - <original_sources>     (unangetastete Snapshot)              │
│   - LICENSE                (Original-Lizenz)                     │
│   - compiler_info.txt      ("gcc-9.5 -O3 -mavx2")                │
│   - sha256_originals.txt   (Pro File: SHA256 zur Validierung)    │
│   - README.md              (Paper-Vollangabe + Curation-Notes)   │
│   - MODIFICATIONS.md       (NUR wenn Anpassungen pflicht)        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ kompiliert mit
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ Schicht 4: Compiler-Cache (on-demand fetched + gebaut)          │
│ ${CMAKE_SOURCE_DIR}/compiler_cache/                              │
│ - gcc-9.5/                                                       │
│   - bin/gcc-9.5, bin/g++-9.5                                     │
│   - .build_complete.marker                                       │
│ - clang-15/, msvc-19.30/, etc.                                   │
│                                                                  │
│ CMake-Modul cmake/compiler_cache.cmake bietet:                   │
│ - comdare_ensure_compiler(NAME url SHA256 BUILD_WITH ...)        │
│ - Pflicht VOR CacheEngineBuilder-Precompile-Run abgeschlossen    │
└─────────────────────────────────────────────────────────────────┘
```

---

## §3 Verzeichnis-Struktur (Pilot mimalloc-Beispiel)

```
libs/cache_engine/topics/allocator/axis_06_allocator/
├── concepts/
│   ├── axis_06_allocator_concept.hpp
│   ├── axis_06_allocator_cache_engine_permutation_concept.hpp
│   ├── axis_06_allocator_legacy_original_code_strategy_concept.hpp   ← NEU
│   └── (bestehende Sub-Concepts)
├── legacy_code/                                                       ← NEU
│   └── paper_a04_mimalloc/
│       ├── mimalloc-2.x/                  (vollstaendiger Quellbaum)
│       │   ├── src/alloc.c
│       │   ├── src/heap.c
│       │   ├── include/mimalloc.h
│       │   └── ...
│       ├── LICENSE                        (MIT)
│       ├── compiler_info.txt              ("gcc-9.5 -O3 -mavx2 -DMI_DEBUG=0")
│       ├── sha256_originals.txt           (alloc.c=..., heap.c=..., ...)
│       ├── README.md                      (Leijen MSR-TR-2019-18 + ISMM 2019)
│       └── MODIFICATIONS.md               (leer beim Pilot)
├── axis_06_allocator_mimalloc_original.hpp                            ← NEU
├── axis_06_allocator_mimalloc_original.cpp                            ← NEU
└── axis_06_allocator_mimalloc.hpp                                     (bestehend, refactored)
```

---

## §4 Sub-Concept LegacyOriginalCodeStrategy (cross-topic)

Pflicht-Erweiterung ALLER Achsen-Permutation-Concepts:

```cpp
// libs/cache_engine/src/concepts/legacy_original_code_strategy_concept.hpp
// (global, cross-topic — analog measurable_concept.hpp)

namespace comdare::cache_engine::concepts {

/**
 * @brief LegacyOriginalCodePflicht — Pflicht-Properties pro Wrapper
 *
 * Pflicht-API in JEDEM CacheEngine<X>PermutationStrategy-Concept.
 */
template <typename W>
concept LegacyOriginalCodePflicht =
    requires {
        { W::experiment_compiler() } -> std::convertible_to<std::string_view>;
        { W::has_original_paper_code() } -> std::convertible_to<bool>;
        { W::is_original_module() } -> std::convertible_to<bool>;
    };

/**
 * @brief HasOriginalCode — Sub-Concept: Wrapper hat legacy_code-Linking
 *
 * Erfuellt wenn has_original_paper_code()=true. CacheEngineBuilder kann
 * via mp_filter is_compiler_available pruefen ob Paper gebuildet werden kann.
 */
template <typename W>
concept HasOriginalCode =
    LegacyOriginalCodePflicht<W> && (W::has_original_paper_code());

}  // namespace
```

Pflicht-Erweiterung pro Achsen-Concept:
```cpp
template <typename A>
concept CacheEngineAllocatorPermutationStrategy =
    /* ... bestehende API ... */
    && ::comdare::cache_engine::concepts::LegacyOriginalCodePflicht<A>;
```

---

## §5 Compiler-Cache CMake-Module

```cmake
# cmake/compiler_cache.cmake (NEU)

set(COMDARE_COMPILER_CACHE_DIR "${CMAKE_SOURCE_DIR}/compiler_cache"
    CACHE PATH "Cache fuer Paper-Compiler-Builds")

function(comdare_ensure_compiler)
    cmake_parse_arguments(ARG "" "NAME;URL;SHA256;BUILD_WITH" "FLAGS" ${ARGN})

    set(_compiler_dir "${COMDARE_COMPILER_CACHE_DIR}/${ARG_NAME}")
    set(_marker_file  "${_compiler_dir}/.build_complete.marker")

    if(EXISTS ${_marker_file})
        message(STATUS "Compiler-Cache HIT: ${ARG_NAME}")
        set(COMDARE_COMPILER_${ARG_NAME}_BIN "${_compiler_dir}/bin"
            CACHE PATH "" FORCE)
        return()
    endif()

    message(STATUS "Compiler-Cache MISS: ${ARG_NAME} — fetching + building")

    # 1. Fetch
    file(DOWNLOAD ${ARG_URL} "${_compiler_dir}/source.tar.xz"
         EXPECTED_HASH SHA256=${ARG_SHA256})

    # 2. Extract
    file(ARCHIVE_EXTRACT INPUT "${_compiler_dir}/source.tar.xz"
         DESTINATION "${_compiler_dir}/build")

    # 3. Build with system compiler (BUILD_WITH)
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E env CC=${ARG_BUILD_WITH}
                ./configure --prefix=${_compiler_dir}
        WORKING_DIRECTORY "${_compiler_dir}/build")
    execute_process(
        COMMAND make -j8 install
        WORKING_DIRECTORY "${_compiler_dir}/build")

    # 4. Marker
    file(TOUCH ${_marker_file})

    set(COMDARE_COMPILER_${ARG_NAME}_BIN "${_compiler_dir}/bin"
        CACHE PATH "" FORCE)
endfunction()

# Verwendung am Beispiel mimalloc:
comdare_ensure_compiler(
    NAME       gcc-9.5
    URL        "https://ftp.gnu.org/gnu/gcc/gcc-9.5.0/gcc-9.5.0.tar.xz"
    SHA256     "27769f64ef1d4cd5e2c1c8af167d8c5a"
    BUILD_WITH ${CMAKE_CXX_COMPILER})
```

**Pflicht:** Aufruf VOR CacheEngineBuilder-Precompile-Run (sonst Permutationen
nicht bauen).

---

## §6 Paper-Binary CMake-Module

```cmake
# cmake/paper_binary.cmake (NEU)

function(comdare_build_paper_binary)
    cmake_parse_arguments(ARG "" "PAPER;COMPILER;OUTPUT" "SOURCES;FLAGS" ${ARGN})

    set(_legacy_dir "${CMAKE_SOURCE_DIR}/libs/cache_engine/topics/.../legacy_code/paper_${ARG_PAPER}")
    set(_paper_binary "${CMAKE_BINARY_DIR}/paper_cache/${ARG_OUTPUT}")

    if(EXISTS ${_paper_binary})
        message(STATUS "Paper-Binary HIT: ${ARG_PAPER}")
        return()
    endif()

    # Compiler aus Cache laden
    set(_cc "${COMDARE_COMPILER_${ARG_COMPILER}_BIN}/gcc")

    # Compile (sequentiell, da Original-Build-System)
    execute_process(
        COMMAND ${_cc} -c ${ARG_FLAGS} ${ARG_SOURCES} -o ${_paper_binary}
        WORKING_DIRECTORY ${_legacy_dir}
        RESULT_VARIABLE _rc)

    if(NOT _rc EQUAL 0)
        message(FATAL_ERROR "Paper-Build FAILED: ${ARG_PAPER}")
    endif()
endfunction()
```

---

## §7 SHA256-Engine (Compile-Time)

Siehe `[[consteval-sha256-function-validation]]` Memory fuer Details.
Zusammenfassung:

**Bibliothek:** ctsha (vexingcodes, MIT) als consteval SHA256-Impl
(~150 LoC). Einbindung in `libs/cache_engine/src/sha256/`.

**Pattern:**
```cpp
// Pro Wrapper, pro Function:
COMDARE_IS_ORIGINAL(allocate, sha256("..."))   // Macro generiert is_original_allocate()
COMDARE_IS_ORIGINAL(deallocate, sha256("..."))

// Auf Wrapper-Ebene:
static constexpr bool is_original_module() {
    return mp::mp_all_of<function_originality_predicates, std::true_type>::value;
}
```

**Compromises (Recherche 2026-05-26 — siehe Reference-Memory):**
1. Function-Name-Extraktion nur via Macro `#fn` Stringification (kein
   type-magic ohne C++26 Reflection)
2. MSVC #embed-Blocker — Windows-Dev braucht Workaround-Script (xxd → .inc)
3. SHA256 Compile-Cost <50 KB pro Function-Body realistisch

---

## §8 Pflicht-API Pro Wrapper (Beispiel mimalloc)

```cpp
class MimallocAllocator : public AllocatorStrategyBase<MimallocAllocator> {
public:
    // [[experiment-compiler-property]] Pflicht-API:
    static constexpr std::string_view experiment_compiler() noexcept {
        return "gcc-9.5";
    }
    static constexpr bool has_original_paper_code() noexcept { return true; }

    // [[legacy-code-sha256-validation]] — per Macro generiert:
    COMDARE_IS_ORIGINAL(allocate,   "5f8b3a..." /* sha256 */)
    COMDARE_IS_ORIGINAL(deallocate, "a7c2d9..." /* sha256 */)
    COMDARE_IS_ORIGINAL(reallocate, "b6e1f4..." /* sha256 */)

    using function_originality_predicates = mp::mp_list<
        std::bool_constant<is_original_allocate()>,
        std::bool_constant<is_original_deallocate()>,
        std::bool_constant<is_original_reallocate()>
    >;
    static constexpr bool is_original_module() noexcept {
        return mp::mp_all_of<function_originality_predicates,
                              std::true_type>::value;
    }

    // Delegate (extern "C" zu legacy_code/paper_a04_mimalloc/)
    void* allocate(std::size_t bytes, std::size_t align) {
        return ::comdare::cache_engine::allocator::axis_06_allocator::original::
                   mimalloc_allocate(bytes, align);
    }
    // ... weitere Methoden delegieren analog
};
```

---

## §9 Migrations-Plan (50 bestehende Wrapper)

**Phase A (Doku — JETZT):** Memory-Files + Architektur-Doku + Web-Recherche.

**Phase B (Pilot — als naechstes):** A04 mimalloc komplett. Validiert
Pattern + Macro + CMake-Module + SHA-Engine.

**Phase C (Roll-out):**

| Wrapper | `experiment_compiler()` | `has_original_paper_code()` | Aufwand |
|---|---|---|---|
| A04 mimalloc | "gcc-9.5" | true | **PILOT — jetzt** |
| A05 jemalloc | "gcc-9.5" | true | mittel (BSD-Build-System) |
| A06 tcmalloc | "gcc-9.5" | true | hoch (Bazel-Build) |
| A07 snmalloc | "clang-12" | true | mittel (C++17, modern) |
| A22 StdMalloc | "system" | false | trivial (kein Paper) |
| A22 PMR Resource | "system" | false | trivial (C++17 Standard) |
| A19 Buddy | "self" | false | trivial (Knuth Pseudocode) |
| A03 Michael-LF | "self" | false | trivial (PODC 2002 Algorithm, kein C-Repo) |
| Andere Allokatoren | "self" oder paper-spez | je nach Code-Verfuegbarkeit | variabel |
| **alle queuing** (19) | "self" | false | trivial (std-basierte Re-Impl) |
| **alle traversal** (7) | "self" | false | trivial (std-basierte Re-Impl) |

**Konsequenz:** Pilot mimalloc ist der EINZIGE Wrapper im aktuellen Stand
mit echtem Original-Code-Linking. Roll-out auf andere Wrapper bedeutet
fuer ~80% nur Property-Ergaenzung `experiment_compiler="self"` +
`has_original_paper_code=false` + `is_original_<fn>=false` hart.

---

## §10 Validierungs-Workflow (Diplomarbeit-Reports)

```
Mess-Reihen-Spalten (CSV-Export):
- algorithm_name
- experiment_compiler
- has_original_paper_code
- is_original_module
- compiler_actually_used  (System oder Cache?)
- sha256_validation       (PASS/FAIL/N/A)
- ... bestehende Metriken (lookups/sec, etc.)

LaTeX-Report-Filter:
- Tabelle "ORIGINAL ✓" — nur Mess-Reihen mit is_original_module=true
- Tabelle "ADAPTED"    — Re-Implementations + MODIFICATIONS-Verweis
- Tabelle "SYSTEM"     — StdMalloc + PMR (kein Paper-Bindung)

Reproducibility-Manifest (build/reproducibility.md):
- Pro Permutation: compiler_id + paper_id + sha256_validation
- Hash der Mess-Reihen-Result (Welch-Test-Konfidenz dokumentiert)
```

---

## §11 Status nach V41.F.6.1.P1 (heute, Phase A)

| Komponente | Status |
|---|---|
| Memory-Files | ✓ 4 NEU (Pattern + Compiler-Property + SHA-Validierung + Pseudocode-Fallback) + 1 Reference (consteval-sha256-Research) |
| Architektur-Doku | ✓ Dieses Dokument (`13_paper_legacy_code_architektur.md`) |
| Web-Recherche | ✓ C++23 function-name + consteval SHA256 (ctsha empfohlen, 3 Compromises) |
| Sub-Concept `LegacyOriginalCodePflicht` | TODO Phase B |
| `cmake/compiler_cache.cmake` | TODO Phase B |
| `cmake/paper_binary.cmake` | TODO Phase B |
| `libs/.../sha256/ctsha.hpp` | TODO Phase B |
| `legacy_code/paper_a04_mimalloc/` | TODO Phase B |
| `axis_06_allocator_mimalloc_original.hpp+cpp` | TODO Phase B |
| `axis_06_allocator_mimalloc.hpp` Refactor | TODO Phase B |
| Tests fuer Pilot | TODO Phase B |

---

**Naechste Phasen:**
- **Phase B (nach User-Bestaetigung dieser Doku):** mimalloc Pilot komplett.
- **Phase C:** Roll-out auf restliche ~50 Wrapper (~80% trivial mit
  `has_original=false`, ~20% echte Paper-Linking).
- **Phase D (V42):** Compiler-Matrix-Permutationen (V41.B4 / V41.B4.1 als
  CartesianProduct mit experiment_compiler).

---

# Teil B — Erweiterungen aus Phase B.2.x (Stand 2026-05-26 spaete Nacht)

> **Anmerkung Memory `[[never-delete-documentation]]`:** Sektionen §1-§11 oben sind die Phase-A-Konzeption (Initial-Doku 2026-05-26 frueh). Phase B.2 hat substantielle Architektur-Korrekturen erbracht (Pre-Build-Tool, Mixin-Pattern, AxisBase Wurzel). Folgende §12-§18 dokumentieren den Endstand nach P2.A0 + P2.A0.5 + P2.A0.6 + P2.A0.7 + P2.C.1. Bei Konflikten zwischen Teil A und Teil B ist Teil B verbindlich.

---

## §12 AxisBase Wurzel-Pattern (V41.F.6.1.P2.A0.7 + P2.C.1)

### §12.1 Motivation

Phase A Doku (§1-§11) hatte 4 Schichten konzipiert (Concept-System + C-Interface-Adapter + Paper-Original-Code + Compiler-Cache). Phase B.2 hat sich gezeigt: die Achsen-Wrapper waren **strukturell synchron** in ihren Eigenschaften (z.B. `is_thread_safe`, `progress_guarantee`, `name`), aber ohne **gemeinsame Wurzel**. Eine echte Cross-Axis-Basis war Pflicht fuer:

- Konsistente Property-API ueber alle Topics (allocator/queuing/traversal/...)
- Vererbungs-Hierarchie statt "informal-synchronisiert"
- Default-Werte ueber alle Wrapper (Beispiel `get_compiler() = "original"` wenn nicht explizit gesetzt)
- Concept-Basis-Pattern fuer zukuenftige Cross-Axis-Properties

User-Direktive (verbatim, vor P2.A0.7):
> "Weitere abrufbare constexpr Eigenschaft je Achse: `std::string_view get_compiler()` ist standard ein Text 'original' und kann in einem Paper-Algorithmus einer Achse mit dem Zielcompiler ueberschrieben werden. Bisher hatten wir nur `is_eigenschaft`, jetzt erweitern wir um dieses string pattern und erfordern dieses als Interface aller topics und Achsen. Daraus folgt, dass die Achsen diese Eigenschaft aus einer abstract class aus der Ebene der topics erben und je Algorithmus optional per overload setzen."

### §12.2 Wurzel-Datei `topics/axis_base.hpp`

Direkt im `topics/` Ordner (NICHT in einem `axis_<NN>_*/` Unterordner). Cross-Axis-Basis fuer ALLE Achsen-Wrapper.

```cpp
namespace comdare::cache_engine::topics {

/// AxisBase — Cross-Axis Pflicht-Properties (alle Wrapper erfuellen via Inheritance)
struct AxisBase {
    /// Default-Compiler-Identitaet pro Algorithmus. Override pro Paper-Wrapper.
    [[nodiscard]] static constexpr std::string_view get_compiler() noexcept {
        return "original";  // Default — Wrapper kann ueberschreiben (gcc-9.5, etc.)
    }
};

/// Concept zur statischen Verifikation
template <typename T>
concept AxisBaseConcept = requires {
    { T::get_compiler() } -> std::convertible_to<std::string_view>;
};

}  // namespace
```

### §12.3 Default vs Override (Wertebereich)

| Wert | Semantik | Wer setzt? |
|---|---|---|
| `"original"` | Default (AxisBase) — kein Override, beliebiger Compiler OK | AxisBase via Default |
| `"self"` | Re-Impl ohne Paper-Bindung (Pseudocode-Papers, eigene Erfindung) | Wrapper manual override |
| `"system"` | C-Standard-libc (StdMalloc, PMR) — kein Paper | Wrapper manual override |
| `"gcc-9.5"` / `"gcc-12"` / `"gcc-14"` | Konkreter GCC-Compiler aus Paper-Original-Build | Paper-Mixin via Manifest |
| `"clang-12"` / `"clang-15"` / `"clang-18"` | analog Clang | Paper-Mixin via Manifest |
| `"msvc-19.30"` / `"icc-2021"` / `"icx-2024"` | analog MSVC/Intel | Paper-Mixin via Manifest |

### §12.4 CRTP-Henne-Ei-Pattern

Concept-Constraint `requires AxisBaseConcept<Derived>` als template-clause funktioniert NICHT — `Derived` ist bei Basis-Instantiation incomplete. Loesung analog Allocator-Achse: `static_assert` im Konstruktor (Derived ist dann vollstaendig).

```cpp
template <typename Derived>
class AllocatorStrategyBase : public ::comdare::cache_engine::topics::AxisBase {
public:
    constexpr AllocatorStrategyBase() noexcept {
        static_assert(concepts::AllocatorStrategy<Derived>, "...");
        static_assert(concepts::CacheEnginePermutationStrategy<Derived>, "...");
        static_assert(::comdare::cache_engine::topics::AxisBaseConcept<Derived>,
            "Pflicht: Derived erfuellt AxisBaseConcept (get_compiler() Default 'original' via Inheritance)");
    }
};
```

### §12.5 Mass-Update P2.C.1 (KOMPLETT)

5 CRTP-Bases + 5 q2-Wrappers haben Inheritance bekommen. Effekt: alle 50 Wrappers haben `get_compiler()` ohne manuelles Edit. Tests: 569/569 cache-engine standalone gruen.

| Komponente | Vererbungs-Pfad | Status |
|---|---|---|
| `AllocatorStrategyBase<D>` (CRTP) | `: public AxisBase` | ✅ |
| `BufferStrategyBase<D>` (Q1 CRTP) | `: public AxisBase` | ✅ |
| `SearchAlgoBase<D>` (03a CRTP) | `: public AxisBase` | ✅ |
| `CacheTraversalBase<D>` (03b CRTP) | `: public AxisBase` | ✅ |
| `MappingBase<D>` (03m CRTP) | `: public AxisBase` | ✅ |
| `EagerFlush` (q2 Wrapper, kein CRTP) | `: public AxisBase` direkt | ✅ |
| `WatermarkFlush` (q2) | `: public AxisBase` direkt | ✅ |
| `LazyFlush` (q2) | `: public AxisBase` direkt | ✅ |
| `TimedFlush` (q2) | `: public AxisBase` direkt | ✅ |
| `AdaptiveLsmFlush` (q2) | `: public AxisBase` direkt | ✅ |
| 24 Allocator-Wrappers (StdMalloc, MimallocAllocator, ...) | indirekt via `AllocatorStrategyBase` | ✅ |
| 14 Q1-Buffer-Wrappers (NoBuffer, FIFOQueue, ...) | indirekt via `BufferStrategyBase` | ✅ |
| 7 Traversal-Wrappers (Array256, ...) | indirekt via SearchAlgo/CacheTraversal/Mapping-Base | ✅ |

---

## §13 Pre-Build-Tool Workflow vollstaendig (P2.A0 + P2.A0.5 + P2.A0.6)

### §13.1 Tool-Architektur

`apps/is_original_validator/main.cpp` (~390 LoC, C++23 Standalone-Binary, nutzt ctsha intern). Wird zur Build-Time gestartet (NICHT zur Runtime — `[[compile-time-only-no-runtime]]`).

**Architektur-Entscheidung (kritisch — siehe §7 alte MSVC-Episode):**
Compile-Time-Issues (z.B. MSVC `std::array<char,64>` constexpr-Bug) duerfen NICHT zu Runtime-Fallback fuehren. Stattdessen wird der Algorithmus in ein Pre-Build-Tool ausgelagert; der Output (constexpr Bool-Header) wird zur Compile-Zeit der eigentlichen Cache-Engine eingebunden.

### §13.2 CLI

```bash
is_original_validator \
    --manifest path/to/legacy_code/paper_a04_mimalloc/manifest.txt \
    --base-dir path/to/legacy_code/paper_a04_mimalloc/ \
    --output ${CMAKE_BINARY_DIR}/generated/.../a04_mimalloc_is_original.hpp \
    --namespace generated::a04_mimalloc \
    --axis-mixin-type comdare::cache_engine::allocator::axis_06_allocator::concepts::AllocatorOriginalCodeMixin
```

### §13.3 Auto-Discovery via Regex + Brace-Balancer

User-Direktive (verbatim, vor P2.A0.5):
> "Die in der compile time abzugleichenden Function bodies ueber den Funktions Namen im Original Paper file gefunden und von allein per regex ausgewertet und dann gehasht werden."

Implementation:

- Function-Body extrahiert via Regex `\b<paper_fn>\s*\([^)]*\)[^{;]*\{`
- Brace-Balancer-State-Machine mit Behandlung von:
  - String-Literals: `"..."` und `'...'`
  - Line-Comments: `//`
  - Block-Comments: `/* ... */`
  - Char-Escape-Sequences: `\"`, `\\`, etc.
- Extrahiert von Signatur (inkl. opening `{`) bis matching `}`
- Deckt typische C-Variationen ab: Comment zwischen `)` und `{`, `__attribute__`-Annotations, `inline`/`static` modifiers, multi-line signatures

### §13.4 Lock-File-Pattern

User-Direktive (vor P2.A0.5):
> "Die Registrierung muss voll dynamisch sein, alles was der User tut, ist die Achse zu definieren und moeglicherweise den Pfad fuer die Paper-source anzugeben."

Implementation `sha256_locked.txt` im `legacy_code/paper_<id>/` Verzeichnis:

```
1. First-Time-Init (Lock-File fehlt):
   Tool berechnet SHA pro Function aus Source
   Tool schreibt sha256_locked.txt (Reference-SHAs)
   Generiert Header mit kIsOriginal_<fn>=true fuer alle Functions
   User committet sha256_locked.txt ins Git

2. Spaetere Builds (Lock-File existiert):
   Tool berechnet SHA aus aktueller Source
   Vergleicht gegen sha256_locked.txt
   Match  → kIsOriginal_<fn> = true
   Mismatch → kIsOriginal_<fn> = false
   Mismatch ist deklarativer Hinweis "jemand hat legacy_code modifiziert"
```

### §13.5 Multi-File-Paper-Support (P2.A0.6)

User-Direktive (vor P2.A0.6):
> "Ein paper hat vielleicht multiple source files, welche die zu referenzierenden Funktionen verteilt beinhalten und in einem source file koennen mehrere relevante function bodies existieren."

Pro Function eigener `source_relative_path`. Tool iteriert pro Mapping, liest pro Iteration das entsprechende Source-File. Beispiel mimalloc:

```
allocate    mi_malloc      src/alloc.c
deallocate  mi_free        src/alloc.c     # gleiches File wie allocate
reallocate  mi_realloc     src/heap.c      # anderes File
init        mi_init        src/init.c      # noch anderes File
```

### §13.6 Mixin-Generation (P2.A0.6)

Tool generiert PaperManifest + using-Alias (KEINE Macros mehr). Output:

```cpp
// AUTO-GENERATED: ${BUILD}/generated/.../paper_a04_mimalloc_is_original.hpp
namespace generated::a04_mimalloc {

inline constexpr bool kIsOriginal_allocate   = true;
inline constexpr bool kIsOriginal_deallocate = true;
inline constexpr bool kIsOriginal_reallocate = false;

struct PaperManifest {
    static constexpr std::string_view kCompiler = "gcc-9.5";
    static constexpr bool kHasOriginalPaperCode = true;
    static constexpr bool kIsOriginal_allocate   = generated::a04_mimalloc::kIsOriginal_allocate;
    static constexpr bool kIsOriginal_deallocate = generated::a04_mimalloc::kIsOriginal_deallocate;
    static constexpr bool kIsOriginal_reallocate = generated::a04_mimalloc::kIsOriginal_reallocate;
};

using OriginalCodeMixin = ::comdare::cache_engine::allocator::axis_06_allocator::
                          concepts::AllocatorOriginalCodeMixin<PaperManifest>;

}  // namespace
```

Wrapper erbt EINMAL → alle Pflicht-API automatisch (KEINE manuelle Property-Registrierung):

```cpp
class MimallocAllocator
    : public AllocatorStrategyBase<MimallocAllocator>,
      public generated::a04_mimalloc::OriginalCodeMixin {     // 1 Zeile fuer ALLES
    void* allocate(std::size_t bytes, std::size_t align) { /* mi_malloc */ }
    void  deallocate(void* p, std::size_t bytes, std::size_t align) noexcept { /* mi_free */ }
};
```

---

## §14 Manifest-Format (vollstaendige Spezifikation)

### §14.1 Datei `legacy_code/paper_<id>_<paper_name>/manifest.txt`

```
# Kommentar (Zeilen mit # am Anfang werden ignoriert)

# Pflicht-Annotations (3 Stueck)
@compiler gcc-9.5
@has_original_paper_code true
@axis_mixin_type comdare::cache_engine::allocator::axis_06_allocator::concepts::AllocatorOriginalCodeMixin

# Function-Mappings (3-Felder, whitespace-separated, eine Zeile pro Function)
# wrapper_fn  paper_fn   source_relative_path
allocate      mi_malloc    src/alloc.c
deallocate    mi_free      src/alloc.c
reallocate    mi_realloc   src/heap.c
```

### §14.2 @-Annotations

| Annotation | Typ | Pflicht | Default (Phase A) | Beispiel-Wert |
|---|---|---|---|---|
| `@compiler` | string | ja | (Default in AxisBase: `"original"`) | `"gcc-9.5"` |
| `@has_original_paper_code` | bool | ja | (Default: `false`) | `true` |
| `@axis_mixin_type` | fully-qualified C++ type-name | ja | — | siehe oben |

### §14.3 Function-Mappings

| Feld | Bedeutung |
|---|---|
| `wrapper_fn` | interner Wrapper-Function-Name (entspricht Achs-Interface, z.B. `allocate`) |
| `paper_fn` | Function-Name im Paper-Original-Code (z.B. `mi_malloc`) |
| `source_relative_path` | Pfad zur Source-Datei relativ zu `--base-dir` |

### §14.4 `sha256_locked.txt` (auto-generated)

Erste Build: auto-erstellt. Danach git-committed. Inhalt:

```
allocate     5f8b3a8e0c1a8e7c8b3a8e0c1a8e7c8b3a8e0c1a8e7c8b3a8e0c1a8e7c8b3a8e
deallocate   a7c2d96b4e1093b2c2d96b4e1093b2c2d96b4e1093b2c2d96b4e1093b2c2d96b
reallocate   b6e1f48c2a37d9e8e1f48c2a37d9e8e1f48c2a37d9e8e1f48c2a37d9e8e1f48c
```

Bei zukuenftigen Builds vergleicht Tool die aktuelle Source-SHA gegen diese gespeicherten Hashes (siehe §13.4).

---

## §15 Vererbungs-Hierarchie kompletter Diagram

```
                  ┌────────────────────────────────────┐
                  │ topics/axis_base.hpp (cross-topic) │
                  │ struct AxisBase {                  │
                  │   get_compiler() = "original"      │
                  │ };                                 │
                  │ concept AxisBaseConcept = ...      │
                  └──────────────┬─────────────────────┘
                                 │
                ┌────────────────┴────────────────┐
                │                                 │
   (a) CRTP-Pfad │                  (b) Mixin-Pfad │ (cross-topic)
                ▼                                 ▼
   ┌──────────────────────────┐    ┌─────────────────────────────────┐
   │ AllocatorStrategyBase<D> │    │ OriginalCodeMixinBase<M>         │
   │ (Achs-CRTP-Basis)        │    │ - get_compiler() OVERRIDE        │
   │ : public AxisBase        │    │     returns M::kCompiler         │
   │                          │    │ - has_original_paper_code()      │
   │ static_assert(           │    │     returns M::kHasOriginalPaperCode│
   │   AxisBaseConcept<D>)    │    │ : public AxisBase                │
   └──────────┬───────────────┘    └─────────────────┬───────────────┘
              │                                      │
              │                                      ▼
              │              ┌──────────────────────────────────────┐
              │              │ AllocatorOriginalCodeMixin<M>         │
              │              │ (Achsen-spezifisches Mixin-Template)  │
              │              │ : OriginalCodeMixinBase<M>            │
              │              │ - is_original_allocate()              │
              │              │ - is_original_deallocate()            │
              │              │ - is_original_reallocate()            │
              │              │ - is_original_module() = mp_all_of    │
              │              └─────────────────┬────────────────────┘
              │                                │
              │                                ▼
              │              ┌──────────────────────────────────────┐
              │              │ generated::a04_mimalloc::             │
              │              │   OriginalCodeMixin (Tool-Alias)      │
              │              │                                       │
              │              │ struct PaperManifest {                │
              │              │   kCompiler = "gcc-9.5"               │
              │              │   kHasOriginalPaperCode = true        │
              │              │   kIsOriginal_allocate = ... (Tool)   │
              │              │   ...                                 │
              │              │ };                                    │
              │              │                                       │
              │              │ using OriginalCodeMixin =             │
              │              │   AllocatorOriginalCodeMixin<         │
              │              │       PaperManifest>;                 │
              │              └─────────────────┬────────────────────┘
              │                                │
              ▼                                ▼
       ┌────────────────────────────────────────────────────────────┐
       │ class MimallocAllocator                                    │
       │   : public AllocatorStrategyBase<MimallocAllocator>        │  (CRTP)
       │   , public generated::a04_mimalloc::OriginalCodeMixin       │  (Mixin)
       │                                                            │
       │ // get_compiler() = "gcc-9.5" (via OriginalCodeMixinBase)   │
       │ // is_original_module() = true (via AllocatorOrigMixin)     │
       │                                                            │
       │ void* allocate(...) { return mi_malloc(...); }              │
       │ void  deallocate(...) { mi_free(...); }                     │
       └────────────────────────────────────────────────────────────┘
```

**Diamond-Vererbung:** beide Pfade enden in `AxisBase`. KEINE virtual base notwendig, weil `AxisBase` keinen instance state hat (nur `static constexpr` Methoden). C++ Lookup-Regeln: `get_compiler()` ohne Ambiguitaet, weil Mixin-Pfad explizit ueberschreibt.

---

## §16 User-Pflicht-Trennung (pro Achse vs pro Paper-Wrapper)

### §16.1 Pro Achse (1× pro Achse, vor ersten Paper-Wrapper)

| Datei | Inhalt | Status |
|---|---|---|
| `topics/<topic>/axis_<NN>_<topic>/concepts/axis_<NN>_<topic>_interface_functions.hpp` | `std::array<std::string_view> kAxisInterfaceFunctions` | TODO P2.F |
| `topics/<topic>/axis_<NN>_<topic>/concepts/axis_<NN>_<topic>_original_code_mixin.hpp` | Achsen-spezifisches Mixin-Template | TODO P2.F |

Beispiel allocator:

```cpp
// axis_06_allocator_interface_functions.hpp
namespace ::concepts {
inline constexpr std::array<std::string_view, 3> kAxisInterfaceFunctions = {
    "allocate", "deallocate", "reallocate"
    // zero_allocate ist optional Sub-Concept, nicht hier
};
}

// axis_06_allocator_original_code_mixin.hpp
template <typename PaperManifest>
struct AllocatorOriginalCodeMixin
    : ::comdare::cache_engine::concepts::OriginalCodeMixinBase<PaperManifest> {
    static constexpr bool is_original_allocate()   noexcept { return PaperManifest::kIsOriginal_allocate; }
    static constexpr bool is_original_deallocate() noexcept { return PaperManifest::kIsOriginal_deallocate; }
    static constexpr bool is_original_reallocate() noexcept { return PaperManifest::kIsOriginal_reallocate; }
    static constexpr bool is_original_module()      noexcept {
        return is_original_allocate() && is_original_deallocate() && is_original_reallocate();
    }
};
```

### §16.2 Pro Paper-Wrapper

| Datei / Aenderung | Inhalt | Aufwand |
|---|---|---|
| `legacy_code/paper_<id>_<paper_name>/` | Verzeichnis anlegen | trivial |
| `legacy_code/paper_<id>/src/*.c` | Original-Source kuratiert | abhaengig vom Paper |
| `legacy_code/paper_<id>/LICENSE` | Original-Lizenz | trivial |
| `legacy_code/paper_<id>/README.md` | Paper-Vollangabe (Autor/Titel/Venue/Jahr) | trivial |
| `legacy_code/paper_<id>/manifest.txt` | @-Annotations + Function-Mappings | siehe §14 |
| `legacy_code/paper_<id>/sha256_locked.txt` | auto-generated First-Build | 0 manuell |
| Wrapper-Klasse | 1 Inheritance-Zeile + extern "C" Delegates | ~30 Zeilen |

### §16.3 Was der User NICHT mehr tun muss

- `COMDARE_IS_ORIGINAL` Macro pro Function manuell aufrufen
- SHA per Function manuell berechnen
- Property im Wrapper deklarieren (alles via Inheritance)
- Modul-Aggregat manuell `a && b && c` schreiben (Tool/Mixin macht es)
- Source-Region-Marker im Header pflegen (line_start/line_end — entfaellt durch Auto-Discovery)

---

## §17 Naming-Konvention (cross-axis Pflicht-Pattern)

### §17.1 Property-Naming nach Return-Typ

| Pattern | Return-Typ | Default | Beispiele |
|---|---|---|---|
| `is_<eigenschaft>()` | `bool` | meist `false` (Opt-In) | `is_thread_safe`, `is_event_driven`, `is_versioned`, `is_simd_capable` |
| `supports_<feature>()` | `bool` | `false` | `supports_pmr`, `supports_numa_node_hint`, `supports_simd` |
| `requires_<resource>()` | `bool` | `false` | `requires_explicit_init`, `requires_specialized_hardware`, `requires_pool_base` |
| `has_<feature>()` | `bool` | true/false je Semantik | `has_native_aligned_alloc`, `has_original_paper_code` |
| `get_<eigenschaft>()` | `std::string_view` | je Default (`"original"` fuer compiler) | `get_compiler` |
| `<name>()` ohne Verb-Praefix | `enum class` | je Semantik | `progress_guarantee`, `density_class` |
| `statistics()` / `snapshot()` / `observer()` | Struct/Type | leerer State | siehe Allocator-Pattern |
| `<eigenschaft>_count()` / `<eigenschaft>_pct()` | numeric | 0 | `occupied_count`, `density_percent`, `threshold_pct` |

### §17.2 Pflicht: snake_case + bedeutungsvoller Prefix

Alle Property-Methoden in snake_case. Verb-Prefix MUSS Boolean-Semantik klarmachen (`is_*`, `has_*`, `supports_*`, `requires_*`). String-Getter MUESSEN `get_*` Prefix tragen.

### §17.3 Stufen-Pattern (User-Direktive nach Allocator Batch 7)

Wenn eine Property eine **Stufe/Klassifikation** ausdrueckt (statt isoliertem Bool-Flag) — z.B. WaitFree impliziert LockFree impliziert ObstructionFree impliziert Blocking — dann **`enum class` mit int-Backing** statt mehrere separate Bools:

```cpp
enum class ProgressGuarantee : int {
    Blocking        = 0,
    ObstructionFree = 1,
    LockFree        = 2,
    WaitFree        = 3,
};
```

Vorteil: Vergleich `level() >= LockFree` deckt impliziert WaitFree + LockFree. Erweiterbar ohne Concept-Breakage (z.B. `BoundedWaitFree = 4` fuer Real-Time).

| Pattern | Verwendung |
|---|---|
| `bool` | orthogonale binaere Eigenschaften (z.B. `supports_pmr`, `has_native_aligned_alloc`) |
| `enum class int` | ordinale Klassifikationen mit Implikations-Hierarchie (z.B. `ProgressGuarantee`, `DensityClass`) |

### §17.4 `get_compiler()`-Werte-Konvention

Siehe §12.3 oben — Default in AxisBase ist `"original"`. Wrapper ueberschreibt mit konkretem Wert. Paper-Mixin via PaperManifest.

---

## §18 Migrations-Plan 50 Wrapper (aktualisiert nach P2.C.1)

### §18.1 Status-Tabelle nach P2.C.1 (heute)

| Komponente | get_compiler() | has_original_paper_code() | is_original_module() | P2.C.1 |
|---|---|---|---|---|
| **5 CRTP-Bases** (AllocatorStrategyBase, BufferStrategyBase, SearchAlgoBase, CacheTraversalBase, MappingBase) | `"original"` (via AxisBase) | (n/a) | (n/a) | ✅ erben |
| **5 q2-Wrappers** (Eager/Watermark/Lazy/Timed/AdaptiveLsm) | `"original"` (via AxisBase direkt) | (Phase B.2.C pending) | (Phase B.2.C pending) | ✅ erben |
| **24 Allocator-Wrappers** (StdMalloc, ..., MimallocAllocator, ...) | `"original"` indirekt via Base | (Phase B.2.C pending) | (Phase B.2.C pending) | ✅ indirekt |
| **14 Q1-Buffer-Wrappers** (NoBuffer, FIFOQueue, ..., LockFreeMPMC) | `"original"` indirekt via Base | (Phase B.2.C pending) | (Phase B.2.C pending) | ✅ indirekt |
| **7 Traversal-Wrappers** (Array256, ..., PoolRelative) | `"original"` indirekt via Base | (Phase B.2.C pending) | (Phase B.2.C pending) | ✅ indirekt |
| **MimallocAllocator** (nach P2.B Pilot) | `"gcc-9.5"` via Mixin | `true` via Mixin | computed via Tool | pending P2.B |
| **PMR Resource / StdMalloc** | `"system"` manual override | `false` manual | `false` manual | pending P2.C |

### §18.2 Pending Sub-Tasks (Reihenfolge nach Session-End §12)

| Sub-Task | Inhalt | Aufwand |
|---|---|---|
| **P2.E ✓** | Diese Doku-Erweiterung (heute) | done |
| **P2.F** | 14 Achsen-Mixin-Templates + Interface-Functions-Listen (pro Achse 2 Files) | ~28 Files |
| **P2.A** | 4 CMake-Module (is_original_codegen + compiler_cache + paper_binary + tools_cache xxd) | ~400 LoC |
| **P2.B** | mimalloc Pilot End-to-End (legacy_code Snapshot + manifest.txt + Wrapper-Refactor) | substantieller Sprint |
| **P2.C** | Concept-Pflicht-Erweiterung + Default-Properties fuer alle 50 Wrappers (kein-Paper Defaults `"self"` / `false` / `false`) | ~150 Zeilen |
| **P2.D** | Roll-out A05 jemalloc + A06 tcmalloc + A07 snmalloc (3 weitere Paper-Wrappers) | optional, separater Sprint |

### §18.3 Skalierungs-Schaetzung P2.C (Default-Properties)

| Achse | Wrappers | Aufwand pro Wrapper | Total |
|---|:---:|---|---|
| allocator | 23 ohne Paper, 1 mit (MimallocAllocator nach P2.B) | 3-4 Zeilen Property-Default oder 1 Mixin-Inheritance | ~80 Zeilen |
| queuing Q1 | 14 alle Re-Impl (`"self"`) | 3-4 Zeilen Property-Default | ~56 Zeilen |
| queuing Q2 | 5 alle Re-Impl (`"self"`) | 3-4 Zeilen Property-Default | ~20 Zeilen |
| traversal 03a | 3 alle Re-Impl | 3-4 Zeilen Property-Default | ~12 Zeilen |
| traversal 03b | 2 alle Re-Impl | 3-4 Zeilen Property-Default | ~8 Zeilen |
| traversal 03m | 2 alle Re-Impl | 3-4 Zeilen Property-Default | ~8 Zeilen |
| **TOTAL** | **50** | — | **~184 Zeilen** |

### §18.4 Cross-Memory + Cross-Doku

- Memory `[[axis-base-pattern]]` — Wurzel-Pattern + Naming-Konvention
- Memory `[[legacy-code-sha256-validation]]` — Tool-Workflow + Mixin-Pattern
- Memory `[[compile-time-only-no-runtime]]` — KRITISCHE Pflicht-Direktive bei MSVC-Issues
- Memory `[[paper-original-code-pattern]]` — Verzeichnis-Struktur
- Memory `[[experiment-compiler-property]]` — Cross-Wirkung mit `has_original_paper_code`
- Memory `[[meta-driven-concept-hardening-pattern]]` — M0/M1/M2/M3 OMG-MOF-Mapping
- Session-Doku `20260526-V41-F-6-1-traversal-konsolidierung-paper-legacy-pattern-session.md` §5-§7
- Session-Doku `20260526-V41-F-6-1-P2-A0-tool-refactor-axisbase-pattern-session-end.md` §3-§7

---

**Ende Teil B (Stand 2026-05-26 spaete Nacht nach P2.E).**

---

# Teil C — Korrektur Phase B.2.C (Stand 2026-05-26 noch spaeter)

> **Anmerkung [[never-delete-documentation]]:** Teil A + B oben bleiben unangetastet.
> Teil C dokumentiert User-Kritik (heute spaet) am ersten P2.C-Skelett + den
> resultierenden Refactor zu kompakter Generik. Bei Konflikten mit Teil A/B ist
> Teil C verbindlich. Bei Bedarf bitte alle 3 Teile lesen — Teile A+B fuer
> Architektur-Genese, Teil C fuer aktuellen Endstand.

---

## §19 User-Kritik am ersten P2.C-Skelett + Refactor

### §19.1 Drei Kritikpunkte (verbatim Direktive)

User-Stop vor P2.C-Commit:
> "Das sieht aber noch nicht nach einer compile time dynamischen Auswertung der
> Code-Validitaet aus, das ist einfach hardcoded. Wo ist das cmake flag fuer
> alle Funktionen, welches mit der app die Originalitaet beweist? `is_original_module`
> ist keine Metaprogrammierung, welche die Originalen Funktionen ueber ein AND
> prueft. [...] Weiterhin ist das doppelt, weil entweder ist der paper code
> original und damit auch das Modul UND UMGEKEHRT. Wir brauchen nur eine der
> beiden Variablen. [...] Das ist Code-Bloat statt generischer Modularisierung!
> Wir verwenden wie im Allokator Achse immer Template Tests und moeglichst
> kompakte Strukturen."

**3 substantielle Punkte:**

1. **Redundanz:** `has_original_paper_code` + `is_original_module` sind semantisch identisch — eine reicht
2. **Code-Bloat:** Hardcoded `false`-Defaults in 10 Wrapper-Files (5 CRTP-Bases + 5 q2-Wrappers) statt cross-axis Generik
3. **Fehlt:** Zentrales CMake-Flag fuer Original-Code-Validierung (Build-Switch)

### §19.2 Refactor-Loesung (P2.C neu, 587 Tests gruen)

| Schritt | Aktion | Konsequenz |
|---|---|---|
| 1 | `AxisBase` erweitert: `is_original_module() = false` Default | Cross-axis generisch — ALLE 50 Wrappers haben `false` automatisch ohne Code |
| 2 | `AxisBaseConcept` fordert beide Properties (`get_compiler` + `is_original_module`) | Statische Verifikation cross-axis |
| 3 | `LegacyOriginalCodePflicht` reduziert auf 2 Properties (statt 3) | `has_original_paper_code` entfernt — Redundanz weg |
| 4 | `OriginalCodeMixinBase`: `has_original_paper_code` Override entfernt | Mixin liefert nur noch `get_compiler` Override |
| 5 | 5 CRTP-Bases + 5 q2-Wrappers: alle hardcoded Defaults entfernt | KEIN Code-Bloat mehr — Defaults via AxisBase Inheritance |
| 6 | mimalloc-Wrapper: `using has_original_paper_code` entfernt | Konsequenz aus Schritt 3+4 |
| 7 | **NEU `option(COMDARE_CE_ENABLE_ORIGINAL_CODE_VALIDATION ON)`** | Zentrales CMake-Flag: bei OFF kein Codegen, alle `false` via AxisBase Default |
| 8 | Concept-Anhang `&& LegacyOriginalCodePflicht<W>` in alle 6 Achs-Permutation-Concepts | Pflicht-API statisch enforced (Allocator/Q1/Q2/03a/03b/03m) |
| 9 | `HasOriginalCode` Sub-Concept reformiert: `get_compiler() != "original"/"self"/"system"` | Detection von konkretem Paper-Compiler ohne separate Bool |
| 10 | Tool-Output `kHasOriginalPaperCode` bleibt im PaperManifest als Diagnose-Info | User-Wahl (Doku-Comment, nicht API) |

### §19.3 Aktualisierte AxisBase (Endstand P2.C)

```cpp
namespace comdare::cache_engine::topics {

struct AxisBase {
    [[nodiscard]] static constexpr std::string_view get_compiler() noexcept {
        return "original";  // Override pro Paper-Wrapper via Mixin
    }
    [[nodiscard]] static constexpr bool is_original_module() noexcept {
        return false;  // Override pro Paper-Wrapper via Mixin
    }
};

template <typename T>
concept AxisBaseConcept = requires {
    { T::get_compiler() }       -> std::convertible_to<std::string_view>;
    { T::is_original_module() } -> std::convertible_to<bool>;
};

}  // namespace
```

### §19.4 Aktualisierte LegacyOriginalCodePflicht

```cpp
namespace comdare::cache_engine::concepts {

template <typename W>
concept LegacyOriginalCodePflicht = requires {
    { W::get_compiler() }       -> std::convertible_to<std::string_view>;
    { W::is_original_module() } -> std::convertible_to<bool>;
};

template <typename W>
concept HasOriginalCode =
    LegacyOriginalCodePflicht<W>
    && (W::get_compiler() != std::string_view{"original"})
    && (W::get_compiler() != std::string_view{"self"})
    && (W::get_compiler() != std::string_view{"system"});

template <typename W>
concept PaperOriginalValidated =
    LegacyOriginalCodePflicht<W> && (W::is_original_module());

}  // namespace
```

### §19.5 CMake-Option Workflow

```cmake
option(COMDARE_CE_ENABLE_ORIGINAL_CODE_VALIDATION
       "Enable Paper-Original-Code SHA-Validation (Habich-Compliance Pre-Build-Tool)" ON)

if(COMDARE_CE_ENABLE_ORIGINAL_CODE_VALIDATION
   AND COMMAND comdare_paper_init
   AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/ext/A04-mimalloc/src/alloc-aligned.c")
    # P2.B Pilot-Block: comdare_paper_init + comdare_generate_is_original_mixin
    ...
endif()
```

**Drei OFF-Konsequenzen (bei `COMDARE_CE_ENABLE_ORIGINAL_CODE_VALIDATION=OFF`):**

1. Kein Tool-Lauf, kein PaperManifest-Header generiert
2. Wrapper-Inheritance vom Mixin schlaegt fehl (Header fehlt) → Build-Error
   → User MUSS bei OFF auch Paper-Wrapper-Includes deaktivieren oder ext/ entfernen
3. Wenn alle Paper-Wrapper deaktiviert: alle 50 Wrappers haben `is_original_module()=false`
   via AxisBase Default — KEINE Code-Aenderung am Wrapper noetig

### §19.6 Endstand-Tabelle 50 Wrappers (ueberholt §18.1)

| Wrapper-Kategorie | get_compiler() | is_original_module() | Quelle |
|---|---|---|---|
| 5 CRTP-Bases (kein Wrapper, nur Vererbungs-Schicht) | (n/a) | (n/a) | inherits AxisBase |
| 24 Allocator-Wrappers ohne Paper (StdMalloc, PMR, ..., 23 Stueck) | "original" | false | via AxisBase Default |
| MimallocAllocator (A04 Paper-Pilot, **EINZIGER mit echtem Linking**) | "gcc-9.5" | true | via generated Mixin |
| 14 Q1-Buffer-Wrappers (NoBuffer, FIFOQueue, ...) | "original" | false | via AxisBase Default |
| 5 Q2-FlushPolicy-Wrappers (Eager, ..., AdaptiveLsm) | "original" | false | via AxisBase Default |
| 3 SearchAlgo-Wrappers (Array256, VectorU8U8, VectorU16U16) | "original" | false | via AxisBase Default |
| 2 CacheTraversal-Wrappers (LinearFanout, HashLookup) | "original" | false | via AxisBase Default |
| 2 Mapping-Wrappers (DirectPlacement, PoolRelative) | "original" | false | via AxisBase Default |

**Konsequenz:** **49 von 50 Wrappers brauchen ZERO Code** fuer LegacyOriginalCodePflicht-
Konformitaet — alles via AxisBase Default. Nur MimallocAllocator hat aktiv via Mixin-
Inheritance + 4 using-Statements einen Override.

### §19.7 Lessons-Learned (kompakte Generik vs Bloat)

| Anti-Pattern | Pattern |
|---|---|
| Hardcoded `static constexpr bool xxx = false;` in N Wrapper-Files | Cross-Axis-Default in AxisBase, Wrapper erbt automatisch |
| 2 Boolean-Properties die immer dieselbe Antwort liefern | 1 Property, das andere als Computed-Derivative |
| Concept fordert N Properties, von denen N-1 redundante Defaults sind | Concept fordert nur die einzigartig-semantischen Properties |
| Kein zentraler Build-Switch fuer optionale Feature-Schicht | `option(...)` mit ON Default + Gating-Conditional in CMake-Block |

**Pattern-Disziplin (verbindlich fuer kuenftige Cross-Axis-Properties):**
- Zuerst pruefen: ist neue Property semantisch redundant zu existierender? Falls ja: Computed-Helper, nicht Property
- Defaults gehoeren in `topics/axis_base.hpp` (cross-axis Wurzel), NICHT in CRTP-Bases oder Wrappern
- Optional Features brauchen CMake-Option als Build-Switch (Standard ON, dokumentierter OFF-Pfad)

---

**Ende Teil C (Stand 2026-05-26 spaete Nacht nach P2.C-Refactor).**

---

# Teil D — Erweiterungen Phase B.2.D + Helper-Refactor + TYPED_TEST + Papers-Sortierung

> **Anmerkung [[never-delete-documentation]]:** Teil A+B+C bleiben unangetastet.
> Teil D dokumentiert die Roll-out-Erweiterungen + User-Kritik-Reaktionen
> (Test-Bloat-Reduktion via TYPED_TEST, Papers-Reorganisation).

---

## §20 Helper-Refactor `comdare_register_paper_wrapper()`

User-Kritik (analog [[cross-axis-defaults-no-bloat]]): pro Paper 12-Zeilen-Block
in CMakeLists.txt war Wiederholungs-Bloat fuer Roll-out.

**Loesung:** Helper-Funktion in `cmake/is_original_codegen.cmake`. Pro Paper 1 Aufruf:

```cmake
comdare_register_paper_wrapper(
    PAPER_ID          a05_jemalloc
    EXT_DIR           "${CMAKE_CURRENT_SOURCE_DIR}/ext/A05-jemalloc"
    EXT_SENTINEL_FILE "src/jemalloc.c"
    LEGACY_DIR        "${_a06_legacy_root}/paper_a05_jemalloc"
    FILES             "src/jemalloc.c"
    OUTPUT_HEADER     "${_a06_gen_root}/paper_a05_jemalloc_is_original.hpp"
    NAMESPACE         "${_a06_namespace_root}::a05_jemalloc"
    WRAPPER_NAME      jemalloc
)
```

Auto-SKIP wenn EXT_SENTINEL_FILE fehlt (graceful Fallback wenn ext/-Submodul nicht ausgecheckt).

---

## §21 TYPED_TEST_SUITE Refactor — Smoke-Tests skalieren ueber Type-List

User-Kritik: P2.B + P2.D Smoke-Tests waren per-Wrapper kopiert (Code-Bloat).

**Refactor in `test_v41_paper_legacy_code.cpp`:**

```cpp
using PaperWrapperList = ::testing::Types<
    MimallocAllocator, JemallocAllocator, SnmallocAllocator,
    DlmallocAllocator, RPMallocAllocator, LRMallocAllocator
>;
template <typename W> class PaperWrapperConformance : public ::testing::Test {};
TYPED_TEST_SUITE(PaperWrapperConformance, PaperWrapperList);

TYPED_TEST(PaperWrapperConformance, AxisBaseConcept) { static_assert(AxisBaseConcept<TypeParam>); ... }
TYPED_TEST(PaperWrapperConformance, IsOriginalModuleAggregation) { static_assert(TypeParam::is_original_module()); ... }
// ... 8 Tests total pro Wrapper
```

Bei Roll-out weiterer Paper-Wrappers: nur Type-List ergaenzen → automatisch 8 weitere Tests.

**Analog NonPaperWrapperDefaults** (5 Tests × 6 Cross-Topic-Wrappers).

---

## §22 Roll-out Status (Allocator-Achse 24 Wrappers)

| Status | Wrappers | Bemerkung |
|---|---|---|
| **6 INTEGRIERT** (P2.B + P2.D + P2.D.b2) | mimalloc, jemalloc, snmalloc, dlmalloc, rpmalloc, lrmalloc | Paper-Mixin-Inheritance + Tool-validiert |
| **4 DEFERRED P2.D.t2** | tcmalloc, hoard, michael_lf, scalloc | Bazel-Build oder Custom-Shim-Symbol-Mapping |
| **14 ohne ext/-Source** | StdMalloc, PMR, Slab, NUMAlloc, CAMA, StarMalloc, TC-WH, HMalloc, PIM, Crystalline, Exgen, Buddy, PtMalloc2, Vmem-Mag | Pseudocode/algorithmic — AxisBase Default `false`/`"original"` |

**Konsequenz aktuell:** 6 von 24 Allocator-Wrappers haben echte Habich-Compliance,
14 sind via AxisBase Default abgedeckt (kein Code-Bloat).

---

## §23 Traversal-Achse Roll-out (TODO P2.D.tr — separater Sprint)

ext/ enthaelt P0X-Submodule fuer Paper-Algorithmen jenseits Allocator:

| ext-Submodul | Traversal-Wrapper | Paper |
|---|---|---|
| ext/P01-ART/unodb | Array256 | Leis ICDE 2013 |
| ext/P02-HOT/hot | VectorU8U8 | Binna PVLDB 2018 |
| ext/P05-START/START | VectorU16U16 | Mertens ICDE 2024 |
| ext/P03-Masstree | (kein direkter Wrapper, evtl. zukuenftig) | Mao 2012 |
| ext/P04-CoCo-trie | (kein direkter Wrapper) | Boffa 2024 |
| ext/P06-B2tree, P07-Wormhole, P10-SuRF, P20-BTreesAreBack, P25-Mahling, P29-RCU, P30-HazardPointers | (kein direkter Wrapper) | verschiedene |

**Plan-Sprint P2.D.tr:**
1. Audit P01/P02/P05 Source-Function-Names + manifest.txt
2. legacy_code/paper_p0X_xxx/ Skelett pro Wrapper
3. CMakeLists Helper-Aufruf (analog Allocator-Pattern)
4. Wrapper-Refactor (Array256/VectorU8U8/VectorU16U16 erben vom Paper-Mixin)
5. TYPED_TEST-Liste in test_v41_paper_legacy_code.cpp erweitern (Auto-Skalierung)

Mixin-Template: braucht entweder neue Achs-Mixin-Files (axis_03a_search_algo_original_code_mixin.hpp
existiert bereits aus P2.F!) — Wrappers koennen direkt davon erben.

---

## §24 Papers-Sortierung Diplomarbeit/Forschungsarbeiten/

37 Papers nach Topic-Achse strukturiert ([[never-delete-documentation]]: nur git mv):

| Topic-Unterordner | Papers | Inhalt-Beispiele |
|---|---|---|
| traversal/ | 17 | ART, HOT, START, B+/B²/CSB+-Trees, CoCo-trie, SuRF, Wormhole, Masstree |
| prefetch/ | 8 | Hardware/Software-Prefetching + Fractal B+ |
| concurrency/ | 3 | Hazard Pointers, RCU, ART of Practical Synchronization |
| memory_layout/ | 5 | Cache-Sensitive Layouts, Tree Layout Multilevel |
| general/ | 1 | Overview Hardware Optimizations |
| hardware/ | 1 | vampir-poster ZIH |
| code/ | (unangetastet) | P0X Source-Code-Kartographien |
| low priority/ | (unangetastet) | spaeter zu sichten |

cache-engine `ext/`-Submodule sind bereits topic-strukturiert
(A0X = Allocator, P0X = Paper-Algorithmus).

---

## §25 Tests-Stand Endstand P2.D.b2

| Test-Target | Tests | Aenderung |
|---|---|---|
| test_v41_topic_allocator_axis_06 | 252 | unveraendert |
| test_v41_topic_queuing | 205 | unveraendert |
| test_v41_topic_traversal | 95 | unveraendert |
| test_v41_paper_legacy_code | 102 | +24 (3 neue Paper-Wrappers × 8 TYPED_TEST) |
| **TOTAL cache-engine** | **654** | **+61 von 593** |

---

**Ende Teil D (Stand 2026-05-26 noch spaeter — Phase B.2.D.b2 Endstand).**

---

# Teil E — Traversal Roll-out (P2.D.tr.s1) + Luecken-Pattern + Build-Hinweise

> **Anmerkung [[never-delete-documentation]]:** Teil A+B+C+D bleiben unangetastet.
> Teil E dokumentiert User-Direktive zur Luecken-Markierung (per-Function is_original)
> + Mixin-Refactor + traversal Roll-out s1 + CLion-Build-Note. Bei Konflikten verbindlich.

---

## §26 Luecken-Pattern (User-Direktive 2026-05-26 noch spaeter)

User-Klarstellung:
> "per-Function is_original markiert nur ob die Funktion original ist. Ist eine
> Luecke da, ist es auch false. Es ist nur true, wenn der Original code vorliegt."

Plus User-Direktive zu Lücken-Strategie:
> "Wir benoetigen einige zusaetzliche Funktionen, die noch nicht implementiert sind,
> aber ohne die der gesamte Experiment Aufbau nicht funktioniert. Es ist unsere
> Aufgabe diese Luecken zu fuellen und die Probleme zu loesen, aber wir muessen
> diese Funktionen als nicht original markieren. So koennen wir in der Permutation
> Engine ueber die Konfiguration der CacheEngineBuilder spaeter Kombinationen
> abwaehlen, die bestimmte Voraussetzungen nicht erfuellen."

**Konsequenz: 3 Wrapper-Klassen-Kategorien:**

| Kategorie | get_compiler() | is_original_<fn>() | is_original_module() | Beispiel |
|---|---|---|---|---|
| **Pure-Original** | "gcc-9.5" via Mixin | true (alle Funktionen) | true | OriginalArtSearchAlgo (4/4) |
| **Teil-Original mit Luecken** | "gcc-9.5" via Mixin | true (Paper-API), false (Luecken-Fueller) | false | OriginalHotSearchAlgo (2/4) |
| **Re-Impl ohne Paper-Binding** | "self" oder "original" Default | false (alle) | false | Array256, VectorU8U8 (existing) |

**PermutationEngine-Filter (zukuenftig):**
- `HasOriginalCode<W>`: `get_compiler() != "original"/"self"/"system"` — Paper-Bindung
- `PaperOriginalValidated<W>`: `is_original_module() == true` — ALLE Functions origin
- Custom-Concept "PartialPaperOriginal": `HasOriginalCode && !PaperOriginalValidated` — Mixed

---

## §27 Mixin-Refactor — if constexpr requires fuer fehlende Felder

**Problem:** Paper mit Teil-API (HOT/START kein remove/clear) → Tool generiert
PaperManifest mit weniger Feldern. Achs-Mixin erwartete vorher ALLE Felder → Compile-Error.

**Loesung:** Alle 6 Achs-Mixins refactored mit `if constexpr (requires { PaperManifest::kIsOriginal_<fn>; })`:

```cpp
[[nodiscard]] static constexpr bool is_original_erase() noexcept {
    if constexpr (requires { PaperManifest::kIsOriginal_erase; })
        return PaperManifest::kIsOriginal_erase;
    else
        return false;  // Luecke: Function nicht im Paper, eigene Erweiterung
}
```

**Backward-Compatible:** Existing Wrappers mit kompletten PaperManifest-Fields liefern weiter
unveraendert. NEUE Wrappers mit Teil-Manifest defaulten fehlende auf false.

**Refactored Files (alle 6 Achsen):**
- axis_06_allocator_original_code_mixin.hpp (2 Functions)
- axis_q1_queuing_original_code_mixin.hpp (6 Functions)
- axis_q2_queuing_original_code_mixin.hpp (2 Functions)
- axis_03a_search_algo_original_code_mixin.hpp (4 Functions)
- axis_03b_cache_traversal_original_code_mixin.hpp (4 Functions)
- axis_03m_mapping_original_code_mixin.hpp (4 Functions)

---

## §28 Traversal Roll-out s1 — 3 Paper-Skelette (axis_03a_search_algo)

| Paper | Wrapper-Name (TODO s2) | Source | API-Mapping |
|---|---|---|---|
| **P01 ART** (Leis ICDE 2013) | OriginalArtSearchAlgo | ext/P01-ART/unodb/art.hpp | insert→insert_internal, lookup→get, erase→remove_internal, clear→clear (4/4) |
| **P02 HOT** (Binna PVLDB 2018) | OriginalHotSearchAlgo | ext/P02-HOT/hot/.../HOTRowex.hpp | insert→insert, lookup→lookup (2/4 — erase+clear LUECKEN) |
| **P05 START** (Mertens ICDE 2024) | OriginalStartSearchAlgo | ext/P05-START/START/sosd-competitor-adapter-START.h | insert→insertLater, lookup→EqualityLookup (2/4 — erase+clear LUECKEN) |

**s1 Status (heute):**
- ✅ legacy_code/paper_p0X_xxx/ Skelette (5-6 Files je: LICENSE/README/manifest/compiler_info/MODIFICATIONS/.gitignore)
- ✅ Helper-Aufrufe in CMakeLists.txt mit AXIS_MIXIN_TYPE = SearchAlgoOriginalCodeMixin
- ✅ Tool-Pipeline ART (4/4) + HOT (2/4) + START (2/4 via insertLater)
- ✅ sha256_locked.txt fuer alle 3 commit-ready
- ✅ Mixin if constexpr requires → fehlende Felder default false

**Pending:**
- **s2** Wrapper-Klassen (Concept-Conformance + Body-Stubs)
- **s4** Library-Build mit Original-Compiler + Linking gegen Paper-Lib

---

## §29 User-Direktive: extern Linking Original-Compiler-Build + Fallback

**User-Direktive heute:**
> "Zur Entdeckung war die direktive: extern ueber Wrapper den Original code mit
> original compiler bauen und linken und eigene Implementierung nur als fallback."

**Dokumentations-Status (verifiziert):** Direktive bereits dokumentiert in:
- Doku 13 §1 Z28: "Original-Code mit jeweils Original-Compiler kompiliert"
- Doku 13 §1 Z34: "Code wird gelinkt statt kopiert"
- Doku 13 §5: cmake/compiler_cache.cmake (gcc-9.5 fetch + build)
- Doku 13 §6: cmake/paper_binary.cmake (compile mit Paper-Compiler)
- Doku 13 §8 Pflicht-API: extern "C" Adapter Pattern
- Memory [[paper-original-code-pattern]]: Coexistence
- Memory [[experiment-compiler-property]]: Compiler-Cache via mp_filter

**Implementation-Realitaet (LUECKE):**

| Komponente | Stand |
|---|---|
| SHA-Validierung Source-Identity | ✅ aktiv |
| Mixin liefert get_compiler="gcc-9.5" | ✅ aktiv |
| Compiler-Cache (compiler_cache.cmake) | ❌ nur Skelett P2.A, NICHT aktiv |
| Paper-Library mit Original-Compiler gebaut | ❌ NICHT aktiv |
| Wrapper-Methods linken gegen Paper-Original-built-Library | ⚠️ aktuell System-built |
| Eigene Implementation als Fallback | ✅ vendor_includes/-Shim-Pattern |

**Folge-Sprint P2.A.W + P2.D.tr.s4:** Library-Build mit Original-Compiler aktivieren.
Cross-Platform-Komplexitaet (3 OS + 4 ISAs).

---

## §30 CLion-Build-Hinweis (User-Bug 2026-05-26 spaet)

**Bug-Report:**
```
cmake -DCMAKE_BUILD_TYPE=Release -G "MinGW Makefiles"
      -S .../Modules/comdare-cacheengine-all/comdare-cache-engine
      -B .../Modules/comdare-cacheengine-all/comdare-cache-engine/cmake-build-release
...
CMake Error: The current CMakeCache.txt directory
  .../cmake-build-release/_deps/googletest-subbuild/CMakeCache.txt
is different than the directory
  c:/Users/benja/OneDrive/Desktop/Projekte/Research/comdare-cache-engine/cmake-build-release/_deps/googletest-subbuild
where CMakeCache.txt was created.
```

**Root-Cause:** `cmake-build-release/` enthaelt einen stale Cache, der auf
**Research/comdare-cache-engine** zeigt — aber CLion will jetzt aus
**Modules/comdare-cacheengine-all/comdare-cache-engine** bauen.

**Loesung:**

```powershell
# Stale Build-Cache loeschen
Remove-Item -Recurse -Force `
    C:\Users\benja\OneDrive\Desktop\Projekte\Modules\comdare-cacheengine-all\comdare-cache-engine\cmake-build-release

# Dann CLion neu konfigurieren oder via Kommandozeile:
C:\Users\benja\AppData\Local\Programs\CLion\bin\cmake\win\x64\bin\cmake.exe `
    -DCMAKE_BUILD_TYPE=Release `
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON `
    -G "MinGW Makefiles" `
    -S C:\Users\benja\OneDrive\Desktop\Projekte\Modules\comdare-cacheengine-all\comdare-cache-engine `
    -B C:\Users\benja\OneDrive\Desktop\Projekte\Modules\comdare-cacheengine-all\comdare-cache-engine\cmake-build-release
```

**Pflicht-Disziplin:** Pro Source-Pfad einen eigenen Build-Pfad. Nicht zwischen
`Modules/...` und `Research/...` mit demselben `cmake-build-release/` mixen.

**Empfohlene Source-Aufraeumung (separate Task):** Pruefen ob `Research/comdare-cache-engine/`
noch verwendet wird oder veraltet (Backup-Pfad?). Wenn nicht aktiv: archivieren oder
loeschen. `[[never-delete-documentation]]` gilt nur fuer `docs/`, NICHT fuer redundante
Source-Klone.

---

**Ende Teil E (Stand 2026-05-26 nacht — P2.D.tr.s1 + Mixin-Refactor + CLion-Build-Hinweis).**

---

# Teil F — Traversal Roll-out s2: 3 NEUE Original-Wrapper-Klassen (2026-05-26 spaeter)

> **Anmerkung [[never-delete-documentation]]:** Teil A-E unangetastet. Teil F dokumentiert
> P2.D.tr.s2 — die 3 NEUEN Wrapper-Klassen (OriginalArt/Hot/StartSearchAlgo) parallel zu
> den existing Re-Impl-Wrappern (Array256/VectorU8U8/VectorU16U16). Konsequente Umsetzung
> der User-Direktive Option B aus s1 (NEUE Wrapper-Klassen, NICHT existing umbauen).

---

## §31 P2.D.tr.s2 — 3 NEUE Original-Wrapper-Klassen (axis_03a)

| Wrapper | Family | Subaxis | Paper | Mixin-Inheritance | is_original_module() |
|---|:-:|---|---|---|:-:|
| **OriginalArtSearchAlgo** | S04 | SA1 dense | P01 ART (Leis ICDE 2013) | `generated::p01_art::OriginalCodeMixin` | **true** (4/4) |
| **OriginalHotSearchAlgo** | S05 | SA2 sparse | P02 HOT (Binna PVLDB 2018) | `generated::p02_hot::OriginalCodeMixin` | **false** (2/4 Lücken) |
| **OriginalStartSearchAlgo** | S06 | SA3 multilevel | P05 START (Mertens ICDE 2024) | `generated::p05_start::OriginalCodeMixin` | **false** (2/4 Lücken) |

Alle 3 liefern `get_compiler() = "gcc-9.5"` via Mixin (AxisBase-Default "original" wird per Diamond-using-Disambiguation überschrieben).

---

## §32 Body-Strategie (Cache-Engine Standalone in s2, extern Linking in s4)

**s2-Pattern:** Body ist Standalone-Re-Impl analog existing Re-Impl-Wrappers
(`Array256`/`VectorU8U8`/`VectorU16U16`). Konkretes Schema pro Wrapper:

| Wrapper | Body s2 | Wrapper-Vorlage | Body s4 (Plan) |
|---|---|---|---|
| OriginalArtSearchAlgo | `std::array<optional<u64>, 256>` direct addressed | Array256 | extern "C" Adapter zu `unodb::db<K,V>::insert_internal/get/remove_internal/clear` |
| OriginalHotSearchAlgo | `std::vector<u8>` + `std::vector<u64>` sorted (lower_bound) | VectorU8U8 | extern "C" Adapter zu `HOTRowex<KeyType, u64>::insert/lookup` (erase/clear bleiben Re-Impl) |
| OriginalStartSearchAlgo | `std::vector<u16>` + `std::vector<u64>` sorted | VectorU16U16 | extern "C" Adapter zu `START::insertLater/EqualityLookup` (erase/clear bleiben Re-Impl) |

Pattern `if constexpr (enabled) { ... } else { (void)k; }` macht den s2-Body neutral —
bei OFF wird der Wrapper konsequent zur Compile-Time eliminiert via Dead-Code-Elimination.
Pflicht-API-Returns (`optional<u64>`, `bool`, etc.) liefern konsistent leere Werte.

---

## §33 Diamond-Vererbung (Mixin wins) — Praezisierung

```
SearchAlgoBase<Derived>           generated::p0X_xxx::OriginalCodeMixin
       │                                       │ (= SearchAlgoOriginalCodeMixin<PaperManifest>)
       │ : public AxisBase                     │ : OriginalCodeMixinBase<PaperManifest>
       │                                       │ : public AxisBase
       │                                       │
       │                                       │
       └────────────────┬──────────────────────┘
                        ▼
              class OriginalArtSearchAlgo
                : public SearchAlgoBase<OriginalArtSearchAlgo>,
                  public generated::p01_art::OriginalCodeMixin
```

**Diamond:** beide Pfade enden in `AxisBase` (kein State, nur `static constexpr`). Da
beide Pfade `get_compiler()` und `is_original_module()` liefern (Default in AxisBase,
Override in Mixin), gibt es ohne explizite Disambiguation einen ambiguous-Compile-Error.

**Loesung im Wrapper (s2-Pattern):**
```cpp
class OriginalArtSearchAlgo
    : public SearchAlgoBase<OriginalArtSearchAlgo>,
      public generated::p01_art::OriginalCodeMixin {
public:
    using generated::p01_art::OriginalCodeMixin::get_compiler;       // → "gcc-9.5"
    using generated::p01_art::OriginalCodeMixin::is_original_insert; // → kIsOriginal_insert (true)
    using generated::p01_art::OriginalCodeMixin::is_original_lookup;
    using generated::p01_art::OriginalCodeMixin::is_original_erase;
    using generated::p01_art::OriginalCodeMixin::is_original_clear;
    using generated::p01_art::OriginalCodeMixin::is_original_module; // → mp_all_of (true)
    ...
};
```

Mixin-Pfad wins — Habich-Compliance erfuellt.

---

## §34 Tests-Architektur s2 (TYPED_TEST_SUITE Auto-Skalierung)

Pattern-Disziplin [[cross-axis-defaults-no-bloat]]: 2 separate TYPED_TEST_SUITE-Klassen,
jeweils mit unterschiedlicher Assertion-Semantik:

### §34.1 FullOriginalSearchAlgoConformance (alle 4 Functions originall)

```cpp
using FullOriginalSearchAlgoList = ::testing::Types<OriginalArtSearchAlgo>;
TYPED_TEST_SUITE(FullOriginalSearchAlgoConformance, FullOriginalSearchAlgoList);
```

**10 Tests pro Wrapper:** AxisBaseConcept / LegacyOriginalCodePflichtConcept /
HasOriginalCodeConcept / **PaperOriginalValidatedConcept (true)** /
GetCompilerOverridesAxisBaseDefault / IsOriginalInsert / IsOriginalLookup /
IsOriginalErase / IsOriginalClear / IsOriginalModuleAggregation (true).

### §34.2 PartialOriginalSearchAlgoConformance (2/4 + Lücken)

```cpp
using PartialOriginalSearchAlgoList = ::testing::Types<OriginalHotSearchAlgo, OriginalStartSearchAlgo>;
TYPED_TEST_SUITE(PartialOriginalSearchAlgoConformance, PartialOriginalSearchAlgoList);
```

**7 Tests pro Wrapper:** AxisBaseConcept / LegacyOriginalCodePflichtConcept /
HasOriginalCodeConcept / **NotPaperOriginalValidated (false)** /
GetCompilerOverridesAxisBaseDefault / **PaperApiFunctionsOriginal (insert+lookup true)** /
**LueckenFunctionsNotOriginal (erase+clear false)**.

### §34.3 Skalierung bei Roll-out

Bei zukünftigen Original-SearchAlgo-Wrappers (z.B. OriginalMasstreeSearchAlgo) reicht
das Hinzufügen zum entsprechenden Type-Liste-Eintrag — alle 10 (Full) bzw. 7 (Partial)
Tests werden automatisch ausgeführt. ZERO Test-Code-Aenderung pro Roll-out.

---

## §35 Test-Bilanz s2 Endstand

| Test-Target | Tests s1 | Tests s2 | Delta | Bemerkung |
|---|:-:|:-:|:-:|---|
| test_v41_topic_allocator_axis_06 | 252 | 252 | 0 | unveraendert |
| test_v41_topic_queuing | 205 | 205 | 0 | unveraendert |
| test_v41_topic_traversal | 95 | 131 | +36 | TYPED_TEST Auto-Skalierung ueber 6 statt 3 Wrappers + PropertyFilter-Count-Anpassung |
| test_v41_paper_legacy_code | 102 | 126 | +24 | 10 Full + 14 Partial Original-SearchAlgo |
| **TOTAL cache-engine** | **654** | **714** | **+60** | |

---

## §36 PermutationEngine-Filter (Concept-API fuer CacheEngineBuilder)

Mit den 3 NEUEN Wrappers ergibt sich folgendes Filter-Verhalten (Compile-Time):

```cpp
// EnabledStrategies = mp_filter<is_enabled, AllStrategies>  (alle 6 Wrappers ON Default)

using HasOriginalCodeSubset =
    mp::mp_filter<HasOriginalCodePred, EnabledStrategies>;
// → {OriginalArtSearchAlgo, OriginalHotSearchAlgo, OriginalStartSearchAlgo}  (3 von 6)

using PaperOriginalValidatedSubset =
    mp::mp_filter<PaperOriginalValidatedPred, EnabledStrategies>;
// → {OriginalArtSearchAlgo}  (nur 1 — ART ist 4/4)

// Re-Impl ohne Paper-Bindung: {Array256, VectorU8U8, VectorU16U16}
// Teil-Original mit Luecken:  {OriginalHotSearchAlgo, OriginalStartSearchAlgo}
// Pure-Original:              {OriginalArtSearchAlgo}
```

**Konsequenz fuer Mess-Reihen:** CacheEngineBuilder kann Permutationen pro Klasse separat
generieren — Reviewer kann (bei Habich-Mess-Reihe) `PaperOriginalValidatedSubset` als
Subset waehlen fuer maximal-strikte Paper-Konformitaet.

---

## §37 Pending Sub-Stufen — Reihenfolge (Stand nach s2)

| Sub-Task | Stand | Bemerkung |
|---|---|---|
| ~~P2.D.tr.s1~~ Skelette + Mixin-Refactor | ✅ vorherige Phase |
| ~~P2.D.tr.s2~~ 3 NEUE Wrapper-Klassen | ✅ **heute** |
| **P2.D.tr.s4** Library-Build Original-Compiler + extern Linking | **pending** Task #689 |
| **P2.D.t2** 4 deferred Allocator (Bazel + Custom-Shims) | **pending** Task #685 |
| **P2.D.q** queuing Paper-Source-Audit | **pending** Task #687 |

Empfohlene Naechst-Reihenfolge:
1. **P2.D.q** queuing-Audit (analog Allocator-Pattern, ohne Library-Build-Komplexitaet)
2. **P2.D.t2** 4 deferred Allocator (Custom-Shims für Hoard/Michael-LF/Scalloc + Bazel-Build für tcmalloc)
3. **P2.A.W + P2.D.tr.s4** Library-Build Original-Compiler (separater Sprint, Cross-Platform 3 OS + 4 ISAs)

---

**Ende Teil F (Stand 2026-05-26 spaeter — P2.D.tr.s2: 3 NEUE Original-Wrapper-Klassen + TYPED_TEST Suites).**

---

# Teil G — P2.D.q Queuing Paper-Source-Audit (2026-05-26 spaeter)

> **Anmerkung [[never-delete-documentation]]:** Teil A-F unangetastet. Teil G dokumentiert
> Task #687 (P2.D.q) — **Audit-only Sprint**, keine Code-Aenderungen am queuing-Topic.
> Ergebnis: queuing-Achse hat aktuell 0 ext/-Sources → Paper-Bindung-Roll-out wartet
> auf Folge-Sprint mit externen Submodule-Hinzufuegungen.

---

## §38 Audit-Methodik P2.D.q

Pro queuing-Wrapper (Q1 14 + Q2 5 = 19 total): pruefen ob in `ext/` ein
Paper-Source verfuegbar ist (analog ext/A04-mimalloc fuer MimallocAllocator,
ext/P01-ART/unodb fuer OriginalArtSearchAlgo).

**Pruefungs-Methodik:**
1. Wrapper-Header lesen — Paper-Referenz im Kommentar?
2. `ext/`-Verzeichnis listen — entsprechende Submodule vorhanden?
3. Wenn Referenz UND Submodule → Roll-out-Kandidat
4. Wenn Referenz ABER kein Submodule → Pending fuer Folge-Sprint
5. Wenn keine Referenz (Standard-Container/std::chrono) → Re-Impl ohne Paper-Bindung

---

## §39 Audit-Ergebnis (Stand 2026-05-26)

### §39.1 Q1 Buffer-Strategy (14 Wrappers)

| Wrapper | Family | Paper-Referenz (Wrapper-Header) | ext/-Source | Roll-out-Kandidat |
|---|:-:|---|:-:|:-:|
| NoBuffer | Q01 | (Standard, no-op) | n/a | nein |
| AppendOnly | Q02 | LSM-MemTable + Bw-Tree Delta-Chain (Levandoski 2013) | ❌ | pending (Folge-Sprint) |
| FIFOQueue | Q03 | (std::deque) | n/a | nein |
| LIFOStack | Q04 | (std::vector) | n/a | nein |
| BoundedRing | Q05 | (Standard Ring-Buffer) | n/a | nein |
| PriorityHeap | Q06 | LRU-Approx, Hot-Key Promotion (kein konkretes Paper) | n/a | nein |
| DeltaChain | Q07 | Levandoski/Lomet/Sengupta Bw-Tree, ICDE 2013 | ❌ | **pending (Microsoft Bw-Tree Repo)** |
| SkiplistBuffer | Q08 | RocksDB, LevelDB LSM-MemTable | ❌ | **pending (RocksDB Repo)** |
| TombstoneBuffer | Q09 | LSM, ART-Optimistik, MVCC | ❌ | pending |
| CopyOnWrite | Q10 | Persistent ART, RCU-Tries | ❌ | pending |
| EpochBuffer | Q11 | McKenney OLS 2001 + Masstree EuroSys 2012 + SMART ART OSDI 2023 | ❌ | **pending (Masstree Repo)** |
| BatchedInsertBuffer | Q12 | Leis ICDE 2013 §6 + Lopez-Pesch ICDE 2024 | ❌ | pending |
| LockFreeSPSC | Q13a | Lamport, Per-Thread → Background | ❌ | pending |
| LockFreeMPMC | Q13b | Vyukov/Michael-Scott (moodycamel-Style) | ❌ | **pending (moodycamel concurrentqueue)** |

### §39.2 Q2 Flush-Policy (5 Wrappers)

| Wrapper | Family | Paper-Referenz | ext/-Source | Roll-out-Kandidat |
|---|:-:|---|:-:|:-:|
| EagerFlush | F01 | (Standard, per-op) | n/a | nein |
| WatermarkFlush | F02 | (Standard Threshold) | n/a | nein |
| LazyFlush | F04 | (Standard Defer) | n/a | nein |
| TimedFlush | F03 | (std::chrono::steady_clock) | n/a | nein |
| AdaptiveLsmFlush | F05 | RocksDB DynamicLevel (EWMA-adaptiv) | ❌ | **pending (RocksDB Repo)** |

### §39.3 Summary

```
ext/ Allocator-Sources verfuegbar:  10 (6 integriert, 4 deferred Task #685)
ext/ SearchAlgo-Paper verfuegbar:   11 (3 integriert P2.D.tr.s1+s2, 8 deferred)
ext/ Queuing-Paper verfuegbar:       0  ← P2.D.q Befund: KEINE
```

**Konsequenz:** P2.D.q Audit-Sprint produziert KEINE Code-Aenderung an queuing-Wrappers.
Alle 19 queuing-Wrappers bleiben Cache-Engine-Standalone-Re-Impl mit `get_compiler() = "original"`
und `is_original_module() = false` via AxisBase-Default (Pattern [[cross-axis-defaults-no-bloat]]).

---

## §40 Roll-out-Kandidaten fuer P2.D.q.s2 (externer Repos-Folge-Sprint)

Wenn Folge-Sprint die externen Repos als `ext/Q-*` Submodule hinzufuegt, ergibt sich
folgendes Roll-out-Potential (priorisiert nach wissenschaftlicher Relevanz fuer
Habich-Mess-Reihen):

### §40.1 Pflicht-Repos (substantielle Paper-Bindung)

| Repo | URL-Vorschlag | Roll-out-Kandidaten | Source-Lizenz | Build-Komplexitaet |
|---|---|---|---|:-:|
| **RocksDB** | github.com/facebook/rocksdb | SkiplistBuffer (memtable), AdaptiveLsmFlush (DynamicLevel) | Apache 2.0 / GPL-2 dual | hoch (CMake, viele deps) |
| **Bw-Tree** | github.com/wangziqi2013/BwTree (akademischer Port) ODER microsoft/peloton-sub | DeltaChain | MIT-ähnlich | mittel |
| **Masstree-beta** | github.com/kohler/masstree-beta | EpochBuffer (QSBR-Pattern) | BSD-3 | mittel |
| **moodycamel concurrentqueue** | github.com/cameron314/concurrentqueue | LockFreeSPSC, LockFreeMPMC | BSD-2 | trivial (header-only) |

### §40.2 Optional-Repos (geringere Prioritaet)

| Repo | Roll-out-Kandidat | Bemerkung |
|---|---|---|
| LevelDB (github.com/google/leveldb) | SkiplistBuffer Alt-Variante | redundant zu RocksDB |
| Bonsai-Tree (Akademisch) | CopyOnWrite | schwer zu finden |
| Tombstone-Pattern Papers (Yang et al.) | TombstoneBuffer | Custom-Shim |

### §40.3 Vermutete Permutations-Verteilung nach Roll-out

Bei vollem P2.D.q.s2 Roll-out (4 Wrappers mit Paper-Bindung):

| Wrapper-Kategorie | get_compiler() | Anzahl |
|---|---|:-:|
| Pure-Original (alle Functions Paper-bound) | "gcc-9.5" via Mixin | ~4 (Skiplist/AdaptiveLsm/DeltaChain/Masstree-Epoch) |
| Re-Impl (Standard-Container) | "original" (AxisBase Default) | ~10 |
| Re-Impl mit Paper-Inspiration (kein Code-Link) | "original" (AxisBase Default) | ~5 (TombstoneBuffer/CopyOnWrite/BatchedInsertBuffer/etc.) |

---

## §41 Architektonische Konsequenz

### §41.1 Disziplinen fuer P2.D.q.s2

Wenn der externe Repos-Sprint kommt, gelten folgende Pattern-Disziplinen:

1. **EIN externer Repo pro Pilot-Wrapper** vor Vollausbau (analog mimalloc-Pilot in P2.B)
2. **Header-only-Repos bevorzugen** (concurrentqueue trivial vs RocksDB komplex)
3. **Compile-Time-Detection** via `comdare_register_paper_wrapper` Auto-SKIP wenn EXT_SENTINEL_FILE fehlt
4. **Cross-Platform-Pflicht** (3 OS + 4 ISAs analog Allocator)
5. **Lizenz-Audit** vor Integration (RocksDB dual-licensed, Masstree BSD-3, etc.)

### §41.2 Tests-Bilanz-Erwartung nach Roll-out

| Test-Target | Heute | nach P2.D.q.s2 (Schaetzung) |
|---|:-:|:-:|
| test_v41_topic_queuing | 205 | 205 + (4 Wrappers × ~5 Body-Tests) ≈ 225 |
| test_v41_paper_legacy_code | 126 | 126 + (4 Wrappers × ~10 TYPED Tests) ≈ 166 |
| **TOTAL cache-engine** | **714** | **~770** (Schaetzung) |

---

## §42 Pending Sub-Stufen — Reihenfolge (Stand nach P2.D.q Audit)

| Sub-Task | Stand | Bemerkung |
|---|---|---|
| ~~P2.D.tr.s1/s2~~ Traversal Roll-out 3 Original-Wrapper | ✅ vorherige Sprints |
| ~~P2.D.q (Audit)~~ Queuing Paper-Source-Audit | ✅ **heute** — Ergebnis: 0 ext/-Sources |
| **P2.D.q.s2** External Repos + Roll-out (RocksDB/Bw-Tree/Masstree/concurrentqueue) | **pending** Folge-Sprint (NEU Task) |
| **P2.D.t2** 4 deferred Allocator (Bazel + Custom-Shims) | **pending** Task #685 |
| **P2.D.tr.s3** weitere Traversal-Paper (P03 Masstree, P04 CoCo-trie, P06 B²tree, P07 Wormhole, P10 SuRF, P20, P25, P29, P30) | **NEU pending** |
| **P2.A.W + P2.D.tr.s4** Library-Build Original-Compiler (Cross-Platform) | **pending** Task #689 |

---

**Ende Teil G (Stand 2026-05-26 spaeter — P2.D.q Audit-only Sprint, 0 ext/-Sources verfuegbar).**

---

# Teil H — ext/-Topic-Reorganisation (2026-05-26 spaeter)

> **Anmerkung [[never-delete-documentation]]:** Teil A-G unangetastet. Teil H dokumentiert
> die ext/-Verzeichnis-Reorganisation nach User-Direktive 2026-05-26 + concurrentqueue
> Pilot-Submodule fuer P2.D.q.s2.

---

## §43 User-Direktive (2026-05-26)

> "Viele paper werden mir einfach per zip zugesendet, es ist teilweise einfach ein
> lokaler Ordner mit code. Wenn es ein externes repo gibt, sollten wir die ext in
> topics analog gliedern und dort die Paper entweder speichern oder hinein clonen
> (beim ersten build). Hab das geklont, vielleicht noch nach Namenskonventionen
> umbenennen und wie gesagt Struktur etwas aufraeumen."

**Konsequenz:** ext/ wird nach Topic gegliedert (analog libs/cache_engine/topics/):

```
ext/
├── allocator/      ← Topic 06 (10 Paper-Sources: A01-A20)
│   ├── A01-hoard/      (ZIP, regulaerer git-Subtree)
│   ├── A03-michael-lockfree/
│   ├── A04-mimalloc/
│   ├── A05-jemalloc/
│   ├── A06-tcmalloc/
│   ├── A07-snmalloc/
│   ├── A08-scalloc/
│   ├── A10-rpmalloc/
│   ├── A11-lrmalloc/
│   ├── A20-dlmalloc/
│   └── REPOS_OVERVIEW.md
├── traversal/      ← Topic 03 (12 Paper-Sources: P01-P30)
│   ├── P01-ART/        (ZIP, regulaerer git-Subtree)
│   ├── P02-HOT/
│   ├── ...
│   └── P30-HazardPointers/
├── queuing/        ← Topic Q (1 Paper-Source: Q01-concurrentqueue als Submodule)
│   └── Q01-concurrentqueue/  ← echtes git Submodule (header-only, cameron314)
└── CMakeLists.txt
```

---

## §44 Source-Eintrag-Methoden (zwei Pattern)

### §44.1 Pattern A — Lokaler Source-Snapshot (ZIP/Manual)

Wenn ein Paper-Code als ZIP oder lokaler Ordner vom Autor/Reviewer kommt
(kein externes Repo verfuegbar oder nicht gewuenscht): direkt als regulaerer
Git-Subtree ins cache-engine repository einfuegen.

**Pattern (manuell):**
```bash
# User entpackt ZIP nach ext/<topic>/<XX-name>/
unzip Paper-XXX.zip -d ext/allocator/A99-foo/
# Dann commit als regulaerer git-Subtree:
git add ext/allocator/A99-foo/
git commit -m "Add A99-foo Paper-Source (ZIP from Author 2026-XX-XX)"
```

**Stand 2026-05-26:** 22 Source-Snapshots dieser Art (10 Allokatoren + 12 SearchAlgo-Paper)

### §44.2 Pattern B — Externes Submodule (git submodule add)

Wenn ein Paper als public GitHub/GitLab-Repo verfuegbar ist: als git Submodule
einbinden mit folgender Namens-Konvention.

**Pattern (vom User auszufuehren — Memory `[[no-git-submodules]]` Ausnahme cache-engine):**
```bash
cd ext/<topic>/
git submodule add <URL> XX-<name>
# z.B.: git submodule add https://github.com/cameron314/concurrentqueue Q01-concurrentqueue
```

**Stand 2026-05-26:** 1 Submodule (Q01-concurrentqueue).

### §44.3 Pattern C (zukuenftig) — Lazy-Clone bei first Build

User-Direktive (verbatim): "beim ersten Build". Konkret koennte das per
CMake-FetchContent oder `add_custom_command` (PRE_BUILD) realisiert werden:

```cmake
function(comdare_ext_lazy_clone)
    cmake_parse_arguments(ARG "" "TOPIC;NAME;URL;TAG" "" ${ARGN})
    set(_dest "${CMAKE_SOURCE_DIR}/ext/${ARG_TOPIC}/${ARG_NAME}")
    if(NOT EXISTS "${_dest}/.git" AND NOT EXISTS "${_dest}/CMakeLists.txt")
        message(STATUS "comdare ext lazy-clone: ${ARG_NAME} from ${ARG_URL}")
        execute_process(COMMAND ${GIT_EXECUTABLE} clone --depth 1 ${ARG_URL} "${_dest}"
                        RESULT_VARIABLE _rc)
        if(NOT _rc EQUAL 0)
            message(WARNING "comdare ext lazy-clone FAILED: ${ARG_NAME} (skip Paper-Wrapper)")
        endif()
    endif()
endfunction()
```

**Status:** Nicht implementiert. TODO fuer P2.D.q.s2 oder Folge-Sprint.

---

## §45 Namens-Konvention (verbindlich seit P2.D.q.s2)

```
ext/<topic>/<TOPICPREFIX><NN>-<descriptive_name>/
```

| Komponente | Regel | Beispiele |
|---|---|---|
| `<topic>` | snake_case Topic-Name (matched libs/cache_engine/topics/) | allocator, traversal, queuing |
| `<TOPICPREFIX>` | Single Capital Letter | A (allocator), P (traversal/Paper), Q (queuing) |
| `<NN>` | 2-stellige Zahl, Null-paddiert | 01, 04, 25 |
| `<descriptive_name>` | kebab-case Paper/Repo-Name | mimalloc, ART, concurrentqueue |

**Beispiele konform:**
- `ext/allocator/A04-mimalloc/`
- `ext/traversal/P01-ART/`
- `ext/queuing/Q01-concurrentqueue/`

**Korrektur 2026-05-26:** `ext/Q-concurrentqueue` → `ext/queuing/Q01-concurrentqueue`
(2-stellige NN-Padding angeglichen).

---

## §46 CMake-Pfad-Auswirkungen

Pfad-Aenderungen in folgenden Files (~25 Stellen total):

| File | Anzahl | Bemerkung |
|---|:-:|---|
| `CMakeLists.txt` (Root) | 9 | comdare_register_paper_wrapper EXT_DIR pro Wrapper |
| `ext/CMakeLists.txt` | mehrere | mimalloc/snmalloc Vendor-Build-Pfade |
| `cmake/is_original_codegen.cmake` | 2 | Doku-Kommentare |
| `adapters/A01-A20/CMakeLists.txt` | 10 Files × 2 | COMDARE_HAVE_<X> include_directories |
| `adapters/P01-P30/CMakeLists.txt` | 12 Files × 1-2 | COMDARE_HAVE_<X> include_directories |

**Tests-Verifikation:** alle 714 cache-engine Tests gruen nach Reorganisation
(252 + 205 + 131 + 126). KEINE Test-Code-Aenderung noetig — nur Pfad-Anpassung.

---

## §47 Pilot-Plan P2.D.q.s2 (concurrentqueue — Folge-Sprint)

Nach erfolgter ext/-Reorganisation kann der queuing Pilot-Wrapper folgen:

### §47.1 Verzeichnis-Struktur (Plan)

```
libs/cache_engine/topics/queuing/axis_q1_queuing/
├── ... (existing 14 Wrappers)
├── axis_q1_queuing_original_lockfree_mpmc.hpp  ← NEU (Pilot fuer P2.D.q.s2)
└── legacy_code/
    └── paper_q01_concurrentqueue/
        ├── LICENSE                 (BSD-2)
        ├── README.md
        ├── manifest.txt            (@compiler gcc-9.5, mapping enqueue/try_dequeue)
        ├── compiler_info.txt       (gcc-9.5 -O3 -std=c++17 -DMOODYCAMEL_DELETE_FUNCTION=delete)
        ├── MODIFICATIONS.md
        ├── .gitignore              (excludes concurrentqueue.h Source-Copy)
        └── sha256_locked.txt       (auto-generated First-Build)
```

### §47.2 CMakeLists.txt Erweiterung (axis_q1_queuing Block)

```cmake
# V41.F.6.1.P2.D.q.s2 Queuing Roll-out Stufe 1 — axis_q1_queuing
set(_aq1_legacy_root "${CMAKE_CURRENT_SOURCE_DIR}/libs/cache_engine/topics/queuing/axis_q1_queuing/legacy_code")
set(_aq1_gen_root    "${CMAKE_CURRENT_BINARY_DIR}/generated/topics/queuing/axis_q1_queuing/legacy_code")
set(_aq1_namespace_root "comdare::cache_engine::queuing::axis_q1_queuing::generated")
set(_aq1_axis_mixin     "comdare::cache_engine::queuing::axis_q1_queuing::concepts::BufferOriginalCodeMixin")

comdare_register_paper_wrapper(
    PAPER_ID          q01_concurrentqueue
    EXT_DIR           "${CMAKE_CURRENT_SOURCE_DIR}/ext/queuing/Q01-concurrentqueue"
    EXT_SENTINEL_FILE "concurrentqueue.h"
    LEGACY_DIR        "${_aq1_legacy_root}/paper_q01_concurrentqueue"
    FILES             "concurrentqueue.h"
    OUTPUT_HEADER     "${_aq1_gen_root}/paper_q01_concurrentqueue_is_original.hpp"
    NAMESPACE         "${_aq1_namespace_root}::q01_concurrentqueue"
    WRAPPER_NAME      concurrentqueue
    AXIS_MIXIN_TYPE   "${_aq1_axis_mixin}"
)
```

### §47.3 Wrapper-Klasse OriginalLockFreeMpmcConcurrentQueue

Inheritance: `BufferStrategyBase` + `generated::q01_concurrentqueue::OriginalCodeMixin`.
Paper-API-Mapping: put → enqueue, get → try_dequeue (concurrentqueue MPMC-API).
6/6 originall (BufferOriginalCodeMixin hat put/get/emplace/peek_front/peek_back/clear —
peek_front/peek_back/emplace sind Cache-Engine Re-Impl-Erweiterung, also 2-3 Lücken
je nach Mixin-Field-Konfiguration). Body: extern Linking gegen concurrentqueue.h Headers.

**Plan Status:** Wartet auf P2.D.q.s2 Sprint.

---

## §48 Pending Sub-Stufen — Reihenfolge (Stand nach ext/-Reorganisation)

| Sub-Task | Stand | Bemerkung |
|---|---|---|
| ~~ext/ Topic-Reorganisation~~ | ✅ **heute** — V41.F.6.1.struct |
| **P2.D.q.s2 Pilot** OriginalLockFreeMpmcConcurrentQueue | **NEXT** Task #690 |
| **P2.D.t2** 4 deferred Allocator (Bazel + Custom-Shims) | pending Task #685 |
| **P2.D.tr.s3** weitere Traversal-Paper (P03/P04/P06/P07/P10/P20/P25/P29/P30) | pending |
| **P2.A.W + P2.D.tr.s4** Library-Build Original-Compiler | pending Task #689 |

---

**Ende Teil H (Stand 2026-05-26 spaeter — ext/-Topic-Reorganisation + concurrentqueue Pilot-Submodule).**

---

# Teil I — P2.D.q.s2 Pilot: OriginalLockFreeMpmcConcurrentQueue (2026-05-26 spaeter)

> **Anmerkung [[never-delete-documentation]]:** Teil A-H unangetastet. Teil I dokumentiert
> P2.D.q.s2 — erster Q-Wrapper mit echter externer Submodule-Bindung (moodycamel
> ConcurrentQueue, BSD-2, header-only). Pilot fuer Pattern B (Submodule) im
> queuing-Topic.

---

## §49 P2.D.q.s2 Pilot — OriginalLockFreeMpmcConcurrentQueue (Q15)

| Aspekt | Wert |
|---|---|
| Family | Q15 (parallel zu Re-Impl Q13b LockFreeMPMC) |
| Subaxis | QS6 lock_free_access |
| Paper-Source | `ext/queuing/Q01-concurrentqueue/concurrentqueue.h` |
| Lizenz | BSD-2 Simplified |
| Einbindung | git submodule (cameron314/concurrentqueue) |
| Compiler-Marker | "gcc-9.5" via Mixin |
| Habich-Compliance | 2/6 originall, 4/6 Lücken |
| Body-Strategie s2 | Standalone Vyukov bounded MPMC (analog LockFreeMPMC) |
| Body-Strategie s4 | extern Linking `#include <concurrentqueue.h>` + `ConcurrentQueue<u64>` |

### §49.1 API-Mapping (Tool-validiert)

| wrapper_fn | paper_fn | Status | Bemerkung |
|---|---|---|---|
| put | `ConcurrentQueue::enqueue` | ✅ originall | SHA256 d3424613c119... |
| get | `ConcurrentQueue::try_dequeue` | ✅ originall | SHA256 4f866455144e... |
| emplace | (LUECKE) | ❌ Re-Impl | concurrentqueue hat keine emplace-Methode |
| peek_front | (LUECKE) | ❌ Re-Impl | concurrentqueue ist async-only, kein peek im Paper-Design |
| peek_back | (LUECKE) | ❌ Re-Impl | analog peek_front |
| clear | (LUECKE) | ❌ Re-Impl | kein clear in concurrentqueue, Drain-Loop |

### §49.2 Mixin-Diamond-Vererbung (Pattern wie Allocator/SearchAlgo)

```cpp
class OriginalLockFreeMpmcConcurrentQueue
    : public BufferStrategyBase<OriginalLockFreeMpmcConcurrentQueue>,
      public generated::q01_concurrentqueue::OriginalCodeMixin {
public:
    using generated::q01_concurrentqueue::OriginalCodeMixin::get_compiler;       // → "gcc-9.5"
    using generated::q01_concurrentqueue::OriginalCodeMixin::is_original_put;    // → true
    using generated::q01_concurrentqueue::OriginalCodeMixin::is_original_get;    // → true
    using generated::q01_concurrentqueue::OriginalCodeMixin::is_original_emplace; // → false (Mixin-Default via if-constexpr-requires)
    using generated::q01_concurrentqueue::OriginalCodeMixin::is_original_peek_front;
    using generated::q01_concurrentqueue::OriginalCodeMixin::is_original_peek_back;
    using generated::q01_concurrentqueue::OriginalCodeMixin::is_original_clear;
    using generated::q01_concurrentqueue::OriginalCodeMixin::is_original_module; // → mp_all_of = false
    ...
};
```

---

## §50 Tests s2 Endstand

| Test-Target | Vorher (P2.D.q Audit) | Nachher (P2.D.q.s2 Pilot) | Delta |
|---|:-:|:-:|:-:|
| test_v41_topic_allocator_axis_06 | 252 | 252 | 0 |
| test_v41_topic_queuing | 205 | 216 | **+11** (TYPED_TEST Auto-Skalierung Q15) |
| test_v41_topic_traversal | 131 | 131 | 0 |
| test_v41_paper_legacy_code | 126 | 133 | **+7** (PartialOriginalBufferConformance) |
| **TOTAL cache-engine** | **714** | **732** | **+18** |

Plus ext/-Reorganisation (V41.F.6.1.struct, unmittelbar vor P2.D.q.s2): cache-engine unverändert 714.

### §50.1 PartialOriginalBufferConformance TYPED_TEST (NEU)

Analog `PartialOriginalSearchAlgoConformance` (HOT/START Pattern), aber fuer Q1-Buffer
(6 Functions statt 4). 7 Tests pro Wrapper: AxisBaseConcept / LegacyOriginalCodePflicht /
HasOriginalCode / NotPaperOriginalValidated / GetCompilerOverridesAxisBaseDefault /
PaperApiFunctionsOriginal (put+get) / LueckenFunctionsNotOriginal (emplace+peek_front+peek_back+clear).

Bei Roll-out weiterer Partial-Original-Buffer-Wrappers (RocksDB/Bw-Tree/Masstree)
nur Type-Liste erweitern → automatisch +7 Tests pro Wrapper.

---

## §51 Lessons-Learned Pilot P2.D.q.s2

1. **CMake-Custom-Command-Dependency** zwischen `comdare_paper_q01_concurrentqueue_codegen` (Tool-Run) und Test-Target ist NICHT automatisch — bei erstem Build muss Tool-Target explizit aufgerufen werden:
   ```bash
   cmake --build build-pilot --config Release --target comdare_paper_q01_concurrentqueue_codegen
   ```
   Folge-Builds funktionieren transparent. TODO Folge-Sprint: Dependency-Edge explizit hinzufuegen.

2. **Concept-Naming-Disziplin:** im Q1-Achs-Namespace heißen die Concepts `BufferStrategy`, `BoundedBufferStrategy`, `IterableAspectStrategy`, `CacheEngineBufferPermutationStrategy` (NICHT `IterableAspectBufferStrategy` oder `CacheEngineQueuingBufferPermutationStrategy` wie initial vermutet). Pflicht-Check `grep -n "concept" concepts/*.hpp` vor neuem Wrapper.

3. **Pattern B (Submodule) ist trivial wenn Header-only:** concurrentqueue funktioniert direkt nach `git submodule add`. Tool generiert PaperManifest aus header. Build-System kennt keine extra Vendor-Library — `comdare_register_paper_wrapper` reicht.

4. **Body-Strategie analog Re-Impl-Vorlage:** in s2 kann der Body 1:1 vom existing Re-Impl-Wrapper kopiert werden (LockFreeMPMC → OriginalLockFreeMpmcConcurrentQueue), Properties via Mixin-Inheritance differenziert. s4 wird Body durch extern "C" Adapter ersetzen.

---

## §52 Pending Sub-Stufen — Reihenfolge (Stand nach P2.D.q.s2)

| Sub-Task | Stand | Bemerkung |
|---|---|---|
| ~~P2.D.tr.s2~~ Traversal 3 Original-Wrapper (ART/HOT/START) | ✅ vorherige Phase |
| ~~ext/-Reorganisation~~ Topic-Gliederung + Submodule-Pattern | ✅ vorherige Phase |
| ~~P2.D.q.s2 Pilot~~ OriginalLockFreeMpmcConcurrentQueue (Q15) | ✅ **heute** |
| **P2.D.tr.s3** 9 weitere Traversal-Paper (P03/P04/P06/P07/P10/P20/P25/P29/P30) | **pending** Task NEU |
| **P2.D.q.s2.t2** weitere Queuing-Paper (RocksDB Skiplist+AdaptiveLsm, Bw-Tree DeltaChain, Masstree EpochBuffer) | **pending** (User-Aktion git submodule add) |
| **P2.D.t2** 4 deferred Allocator (tcmalloc/Hoard/Michael-LF/Scalloc) | **pending** Task #685 |
| **P2.A.W + P2.D.tr.s4** Library-Build Original-Compiler (Cross-Platform) | **pending** Task #689 |

---

**Ende Teil I (Stand 2026-05-26 spaeter — P2.D.q.s2 Pilot OriginalLockFreeMpmcConcurrentQueue, 732 Tests gruen).**

---

## Nachtraege — E2E-Re-Audit 2026-07-15 (Ausrichtung an §0-GOAL-V5 / erweiterte A-H-Architektur)

> Additive Ausrichtungs-Vermerke; der Originaltext oben bleibt unveraendert (Doku nie loeschen).

- **[R8 · Anker docs/architektur/13_paper_legacy_code_architektur.md:27]** Additiver Verweis: Das hier verankerte SHA256-Locking (§7, `sha256_originals.txt`/`sha256_locked.txt`) plus das Linking gegen den jeweiligen Original-Compiler (Habich-Forderung §1, Validierungs-Workflow §10 mit dokumentierter Welch-Test-Konfidenz) bilden das Provenienz-Fundament der honest-100%-Anforderung (R8) — echte, verifizierte, nicht synthetisierte Mess-Grundlage, "Schummeln" per SHA-Tracking ausgeschlossen. Der so gelinkte Original-Code ist die reale Ausfuehrungsgrundlage der Katalog-DLLs. Komplementaer, nicht deckungsgleich zum W4-Gate: Doc 13 deckt die Code-Provenienz-Dimension der Ehrlichkeit ab, waehrend das W4-Gate (reale Katalog-DLLs statt `unordered_map`-Surrogat) eine separate, hier nicht auftauchende Dimension ist. Rein informativ, keine Aenderung noetig.  
  *(Bezug: SHA256-Locking + Original-Compiler-Linking = honest-100%-Fundament, komplementaer zum W4-Gate)*
