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
