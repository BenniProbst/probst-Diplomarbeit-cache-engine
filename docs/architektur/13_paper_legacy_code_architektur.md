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
