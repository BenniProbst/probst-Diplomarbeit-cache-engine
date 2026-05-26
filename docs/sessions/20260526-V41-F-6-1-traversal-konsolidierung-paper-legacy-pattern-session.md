# V41.F.6.1 Session — traversal-Konsolidierung + Paper-Legacy-Code-Pattern (2026-05-26 Abend)

**Stand:** 2026-05-26 spaeter Abend, vor Phase B.2 Pilot mimalloc Vollausbau
**Vorgaenger:** `20260526-V41-F-6-1-queuing-topic-pilot-session.md` + Q7 axis_q2 Vollausbau + T1 traversal Pilot
**Master-Doc:** `docs/architektur/11_konzept_achsen_extension_visitor_pattern.md`
**NEUES Master-Doc:** `docs/architektur/13_paper_legacy_code_architektur.md` (Habich-Compliance)
**Pflicht-Pre-Read fuer Folge-Session:** dieses Dokument + `13_paper_legacy_code_architektur.md` + `[[compile-time-only-no-runtime]]`

---

## §1 Session-Zusammenfassung (8 Hauptphasen)

Heute Abend wurden **8 substantielle Phasen** abgeschlossen, die alle zusammen
das Topic-Pattern komplettieren UND eine neue Architektur-Schicht
(Paper-Legacy-Code) einfuehren:

1. **Q7 axis_q2 Vollausbau** (TimedFlush F03 + AdaptiveLsmFlush F05) — queuing-Topic JETZT GANZHEITLICH komplett
2. **T1 traversal Topic Pilot** (3 Achsen: 03a search_algo + 03b cache_traversal + 03m mapping mit 7 Wrappers)
3. **T2 traversal Konsolidierung** (4 neue Sub-Concepts + iterable_aspect_t in VectorU8U8/HashLookup + Edge-Cases + PermutationEngine + Property-Filter)
4. **Doku-Korrektur "Standalone statt Legacy-Delegation"** in 7 traversal-Wrappers (prt-art-Verweise → Paper-Referenzen)
5. **Audit Pattern-Konsistenz** Allocator-Vorlage vs alle aktuellen Achsen
6. **P1 Phase A Paper-Legacy-Code Architektur-Doku** (Habich-Compliance, 4 Memory-Files + neues `13_*.md` Doku)
7. **P1 Phase B Pilot ctsha + LegacyOriginalCodeStrategy + Pre-Build-Tool** (12 Compile-Time-Tests)
8. **MSVC-Stop-Episode + Architektur-Umstellung** (Runtime-Workaround verworfen, Pre-Build-Tool-Pattern verankert)

---

## §2 Q7 axis_q2_queuing Vollausbau (TimedFlush + AdaptiveLsmFlush)

**Stand:** Topic queuing 14 Q1 + 5 Q2 = 19 Strategien komplett

Neue Q2-Policies:
- **F03 TimedFlush** (FS3 time_triggered, ERSTE FS3-Belegung): `std::chrono::steady_clock`-basiert, spuelt nach `window_ms` Ablauf. `iterable_aspect_t = size_t window_ms {10/100/1000/10000}`. 2. Q2-Policy mit iterable_aspect_t nach Watermark.
- **F05 AdaptiveLsmFlush** (FS4 adaptive_triggered, ERSTE FS4-Belegung): EWMA-adaptiver Watermark (RocksDB DynamicLevel-Pattern). Lernt aus Workload-Burst-Rate (μs-Delta), adjustiert Threshold dynamisch 60-95%. ERSTE mit `is_adaptive()=true`.

Sub-Concept-Pattern auch in Q2:
- Neues `IterableAspectFlushStrategy<P>` analog Q1
- Watermark: `set_threshold_pct(pct)` → `set_iterable_aspect(pct)` konsolidiert
- Datei-Rename: `axis_q2_queuing_subaxes_fs1_to_fs3.hpp` → `_fs1_to_fs4.hpp` (Inhalt hatte FS4 bereits)

**Cartesian Q1 × Q2:** 14 × 5 = **70 Permutationen** vor Cross-Constraints.

Tests: 191 → **205/205** (+14 typed Tests, 7 × 2 neue Policies).

---

## §3 T1 traversal Topic Pilot (3 Achsen, 32 Files)

Inhalt-Inspiration aus prt-art-Legacy-Audit (Background-Agent):
- DenseByteInterpreter (ART Node256)
- PatriciaInterpreter (HOT Patricia)
- MultilevelInterpreter (START Cost-DP)
- LinearProbeHashSet (Fibonacci-Hash)
- ICachePage::placement_page_ (direkte Pointer)
- CustomAlignedStructure (pool-relative Offsets)

**Achsen-Details:**

| Achse | Wrappers | Subaxis | Highlights |
|---|---|---|---|
| **axis_03a search_algo** | Array256 (ART Node256, Leis ICDE 2013) | SA1 dense | SIMD, max_fanout=256 |
| | VectorU8U8 (HOT Patricia, Binna PVLDB 2018) | SA2 sparse | SIMD, sorted range scan |
| | VectorU16U16 (START Cost-DP, Mertens ICDE 2024) | SA3 multilevel | KEIN SIMD |
| **axis_03b cache_traversal** | LinearFanout (B+ Tree Bayer/McCreight 1972) | CT1 linear | O(N), kein Hash |
| | HashLookup (Fibonacci-Hash Knuth TAOCP 1998) | CT2 hash | O(1) amort, auto-resize |
| **axis_03m mapping** | DirectPlacement (Array-of-Pointers) | MP1 direct | Absolute Offsets |
| | PoolRelative (Persistent DS Driscoll JCSS 1989) | MP2 pool_relative | `rebase()`-faehig, `requires_pool_base=true` |

**Sub-Concept-Pattern von Anfang an:**
- `DensityClassifiedStrategy` mit `DensityClass` enum (Sparse/Balanced/Dense/AdaptiveTransition — Stufen-Pattern analog ProgressGuarantee)
- `SimdCapableStrategy` mit Pflicht-`simd_lookup()` falls `supports_simd=true`
- Negativ-static_assert: `VectorU16U16` darf `SimdCapableStrategy` NICHT erfuellen

**TopicConfigSet Cartesian 03a × 03b × 03m:** 3 × 2 × 2 = **12 Permutationen**.

Tests: 72/72 grün beim ersten Lauf nach 1 Build-Fix (observer().on_event const-Issue analog Q1-Pattern).

---

## §4 T2 traversal Konsolidierung (Sub-Concepts + iterable_aspect + Tests + Doku)

**Anlass:** User-Audit gegen Allocator-Vorlage zeigte 5 Pattern-Luecken:
1. Sub-Concepts in 03b + 03m fehlten (0 vs 4-6 in Allocator)
2. iterable_aspect_t in 03a fehlte
3. Runtime-Permutationen via constexpr-Configs fehlten
4. Edge-Case-Tests (Zero/Power-of-2) fehlten
5. Doku-Kommentare ("Inspiriert von prt-art-Legacy") suggerierten Delegation statt standalone

**Konsolidierung in einem Commit (analog Q6):**

4 neue Sub-Concept-Files:
- `IterableAspectSearchAlgoStrategy<S>` (03a)
- `HashedTraversalStrategy<T>` (03b: `bucket_count` + `load_factor`)
- `IterableAspectCacheTraversalStrategy<T>` (03b)
- `PoolRebasableStrategy<M>` (03m: `pool_base` + `rebase`)

iterable_aspect_t in 2 Wrappers nachgezogen:
- **VectorU8U8:** `density_threshold_pct ∈ {10/20/30/50/70}` steuert `density_class()` dynamisch
- **HashLookup:** `initial_capacity ∈ {8/16/64/256/1024}` (alle Power-of-2); Constructor + `set_iterable_aspect` via Rehash; Validation: `cap=0` oder non-Power-of-2 wirft `std::invalid_argument`

Doku-Korrektur in 7 Wrappers: prt-art-Verweise → wissenschaftliche Paper-Referenzen:
- Array256: Leis/Kemper/Neumann ICDE 2013
- VectorU8U8: Binna/Zangerle/Pichl PVLDB 11(3) 2018
- VectorU16U16: Mertens et al. ICDE 2024 (START)
- LinearFanout: Bayer/McCreight Acta Informatica 1972
- HashLookup: Knuth TAOCP Vol 3 §6.4 1998 (Fibonacci-Hash)
- DirectPlacement: Bayer/McCreight 1972 (Array-of-Pointers)
- PoolRelative: Driscoll/Sarnak/Sleator/Tarjan JCSS 1989

**Explizit dokumentiert:** "Standalone-Implementation, kein Legacy-Delegate". Legacy-Files (`indexes/linear_probe_hashset.hpp`) bleiben gemaess `[[migrationen-ans-ende]]` parallel bis Schluss-Archivierungs-Phase.

Tests-Erweiterung: 72 → **95** (+23: 4 Sub-Concept + 5 iterable_aspect + 5 edge-case + 3 runtime-perm + 3 PermEngine + 4 PropFilter -1 zero-cap-overlap).

Property-Filter (User-Direktive "Algorithmen-Eigenschaften differenzierbar"):
```cpp
using SimdSubset    = mp_filter<is_simd_search_algo, AllStrategies>;       // 2/3
using DenseSubset   = mp_filter<is_dense_search_algo, AllStrategies>;      // 1/3
using HashedSubset  = mp_filter<is_hashed_cache_traversal, AllStrategies>; // 1/2
using PoolRelSubset = mp_filter<is_pool_relative_mapping, AllStrategies>;  // 1/2
```

---

## §5 P1 Phase A — Paper-Legacy-Code Architektur-Doku (Habich-Compliance)

**Trigger:** User-Direktive aus Code-Reviewer-Sicht:
> "Es gibt einen dokumentierten Konflikt bezueglich der Compiler-Direktive von
> Prof. Habich, weil er fordert, dass fuer alle Paper moeglichst der original
> Code mit dem jeweils original compiler kompiliert werden muss, sofern moeglich.
> Also benoetigt jeder Algorithmus einer Achse zusaetzlich die Eigenschaft des
> Experiment-compilers... Wir aendern also nicht unsere Architektur, sondern
> setzen einfach nur nicht mehr direkt den code in unsere Function-bodies,
> sondern linken gegen statisch compiled Paper-Algorithmen."

**Doku-Output (Phase A):**
- `docs/architektur/13_paper_legacy_code_architektur.md` (401 Zeilen, 11 Sektionen)
- 4 neue Memory-Files:
  - `feedback_paper_original_code_pattern.md`
  - `feedback_experiment_compiler_property.md`
  - `feedback_legacy_code_sha256_validation.md`
  - `feedback_pseudocode_papers_fallback.md`
- 1 Reference-Memory:
  - `reference_consteval_sha256_function_validation.md` (Web-Recherche-Ergebnis)

**4-Schichten-Architektur:**
1. C++23 Concept-System (unveraendert V41.F.6.1)
2. C-Interface Adapter (`axis_<NN>_<wrapper>_original.hpp+cpp` extern "C")
3. Paper-Original-Code (`legacy_code/paper_<id>_<paper_name>/`, kuratiert + git-tracked)
4. Compiler-Cache (`${CMAKE_SOURCE_DIR}/compiler_cache/`, on-demand fetched)

**User-Direktiven (verbatim, Phase A):**

| Aspekt | User-Wahl |
|---|---|
| Compiler-Bereitstellung | Mittelding find_program + User-Cache via CMake-Skript (Auto-Download+Compile) |
| legacy_code-Inhalt | Code kuratiert + lokal git-tracked + PARALLEL SHA256-Validierungs-Engine compile-time |
| Verzeichnis-Name | `paper_<id>_<paper_name>` (z.B. `paper_a04_mimalloc`) |
| Coexistence | Original immer wenn vorhanden, sonst C++23-Fallback (kein Runtime-Switch) |
| Pilot | A04 mimalloc komplett vor Generalisierung |
| Pseudocode/Non-C-Papers | Direkte C++23-Re-Impl + `is_original_function=false` hart |
| Embed-Strategie | Option B mit xxd-Auto-Install via CMake — Cross-Platform Pflicht (3 OS + 4 ISAs) |

**Web-Recherche-Ergebnis (consteval SHA256):**
- HEUTE realistisch JA mit 3 Compromises:
  1. Function-Name-Extraktion nur via Macro-Stringification (C++26 P2996 nicht vor 2027 LTS)
  2. MSVC #embed-Blocker (Pre-Build-Tool umgeht das vollständig)
  3. SHA256 Compile-Cost <50KB/Function realistisch
- ctsha (vexingcodes, MIT) als consteval SHA256-Lib, ~150 LoC
- 6 wissenschaftliche Referenzen verankert (Kiczales 1991, Bezivin 2005, OMG MOF 2016, Gregor OOPSLA 2006, Eastlake RFC 6234, Sheard 2001)

---

## §6 P1 Phase B Pilot — ctsha + Sub-Concept + Pre-Build-Tool

**Phase B.1 Deliverables (alle in commit `e841097`):**

| Komponente | Wo | LoC | Status |
|---|---|---|---|
| ctsha consteval SHA256 | `libs/cache_engine/src/sha256/ctsha.hpp` | ~150 | ✅ MSVC-tauglich |
| LegacyOriginalCodeStrategy Sub-Concept | `libs/.../src/concepts/legacy_original_code_strategy_concept.hpp` | ~70 | ✅ cross-topic |
| COMDARE_IS_ORIGINAL_FROM_GENERATED Macro | `libs/.../src/sha256/comdare_is_original_macro.hpp` | ~50 | ✅ Pre-Build-Pattern |
| COMDARE_IS_ORIGINAL_NOT_APPLICABLE Macro | (gleiche Datei) | ~5 | ✅ Pseudocode-Marker |
| apps/is_original_validator Standalone-Tool | `apps/is_original_validator/main.cpp` | ~120 | ✅ End-to-End validiert |
| Compile-Time-only Tests | `tests/unit/test_v41_paper_legacy_code.cpp` | ~190 | ✅ 12/12 alle static_assert |

**End-to-End validiert:** Tool berechnete SHA256 für `int add_impl(int a, int b) { return a + b; }`, generierte Header `comdare::test::generated::kIsOriginal_add = true`.

---

## §7 KRITISCHE EPISODE — MSVC-Stop + Architektur-Umstellung

**Anti-Pattern-Episode (~30 Min, lehrreich):**

1. **Erster Versuch:** `COMDARE_IS_ORIGINAL_FROM_STRING` Macro mit consteval-SHA-Berechnung direkt im Wrapper
2. **MSVC-Build-Errors:** `std::array<char,64>` move-Konstruktor nicht constexpr genug; `mp_all_of<...>::value` als Template-Argument nicht akzeptiert
3. **Mein Workaround-Versuch:** Runtime-Aufruf der SHA-Funktion im Test (`auto digest = ctsha::sha256(...)` statt `constexpr auto digest`)
4. **USER-STOP (verbatim):**
   > "Wir hatten compile time definiert, runtime ist VERBOTEN, wir haben
   > Latenzkritische Suchalgorithmen. Workaround waere ein separates Programm
   > fuer is_original, welches zur compile time ausgewertet wird"
5. **Architektur-Umstellung:**
   - `COMDARE_IS_ORIGINAL_FROM_STRING` ENTFERNT (Runtime-Violation + MSVC-Bug)
   - `COMDARE_IS_ORIGINAL_FROM_GENERATED` NEU (delegiert an Pre-Build-Tool-Output)
   - apps/is_original_validator NEU (C++23 Standalone-Binary, nutzt ctsha intern)
   - Memory `feedback_compile_time_only_no_runtime.md` als KRITISCHE Pflicht-Direktive

**Memory `[[compile-time-only-no-runtime]]` (neu, kritisch):**

| Wenn | Was tun |
|---|---|
| consteval funktioniert auf allen 3 Compilern | NUTZEN |
| MSVC-Bug, GCC/Clang OK | **NICHT Runtime-Fallback** — stattdessen Pre-Build-Codegen-Tool |
| Compile-Time-Cost zu hoch (>1s/Wrapper) | Pre-Build-Tool isolieren |
| Algorithmus nicht consteval-faehig | Pre-Build-Tool ruft externe Lib, Output ist constexpr Header |

**Anti-Pattern (verboten):**
```cpp
// VERBOTEN: Runtime-Workaround
auto digest = ctsha::sha256("...");  // KEIN constexpr → Runtime
EXPECT_EQ(digest, ...);

// VERBOTEN: Lazy-Init zur Programmstart-Zeit
static bool is_original_cached_;
static bool is_original() {
    if (!cached_) { cached_ = compute_sha(...); }  // verfaelscht Mess-Reihen
    return cached_;
}
```

**Pflicht-Pattern (gelernt):**
```cpp
// Pre-Build-Tool generiert Header:
//   inline constexpr bool kIsOriginalAllocate = true;

class MyWrapper {
public:
    static constexpr bool is_original_allocate() noexcept {
        return kIsOriginalAllocate;  // direkter literal, ZERO Runtime-Cost
    }
};
```

**Lehre:** Bei Compile-Time-Issues NIE auf Runtime ausweichen — IMMER Pre-Build-Tool als Workaround prüfen. Insbesondere bei Latenz-kritischen Suchalgorithmen.

---

## §8 Tests-Bilanz (Cache-Engine Standalone, Endstand heute)

| Topic / Komponente | Tests | Aenderung heute |
|---|:---:|:---:|
| allocator (axis_06) | 252 | unveraendert |
| queuing (axis_q1 + axis_q2) | 205 | +14 (Q7 Vollausbau) |
| traversal (axis_03a + 03b + 03m) | 95 | +95 NEU (T1 Pilot 72 + T2 Konsolidierung +23) |
| paper_legacy_code (Phase B Pilot) | 12 | +12 NEU (alle compile-time) |
| **TOTAL Cache-Engine** | **564** | **+121 (heute Abend)** |
| Diplomarbeit-Container | 104 | unveraendert |

Alle Tests grün, sowohl Standalone als auch via Submodule-Bump in Diplomarbeit.

---

## §9 Commits heute Abend (chronologisch)

| Commit | Inhalt | Repo |
|---|---|---|
| `40935e6` | Q7 axis_q2_queuing VOLLAUSBAU (TimedFlush + AdaptiveLsmFlush + Sub-Concept) | cache-engine |
| `a0515d7` | Q7 Submodule-Bump | Diplomarbeit |
| `2e02f3e` | T1 Topic traversal Pilot (32 Files, 3 Achsen, 7 Wrappers, 72 Tests) | cache-engine |
| `08cd802` | T1 Submodule-Bump | Diplomarbeit |
| `01c6b61` | T2 traversal Konsolidierung (4 Sub-Concepts + iterable_aspect + Tests) | cache-engine |
| `614887d` | T2 Submodule-Bump | Diplomarbeit |
| `eb3cbdc` | P1 Phase A Doku (`13_paper_legacy_code_architektur.md` 401 Zeilen) | Diplomarbeit |
| `e841097` | P1 Phase B.1 Pilot (ctsha + Sub-Concept + Tool + Tests) | cache-engine |
| `f9522af` | P1 Phase B.1 Submodule-Bump | Diplomarbeit |

**+1 Session-Doku Commit (dieses Dokument) — pending.**

---

## §10 Memory-Files heute Abend (Neu/Erweitert)

**NEU (6 Files):**
1. `feedback_paper_original_code_pattern.md` — Verzeichnis-Struktur + Workflow (Habich-Compliance)
2. `feedback_experiment_compiler_property.md` — Pflicht-API jeder Wrapper-Klasse
3. `feedback_legacy_code_sha256_validation.md` — Compile-Time SHA-Validierung Pattern
4. `feedback_pseudocode_papers_fallback.md` — Re-Impl-Pattern bei Pseudocode/Non-C/C++/Go
5. `reference_consteval_sha256_function_validation.md` — Web-Recherche-Ergebnis (3 Compromises, ctsha)
6. `feedback_compile_time_only_no_runtime.md` — **KRITISCH:** Runtime VERBOTEN, Pre-Build-Tool als Workaround

**Erweitert:**
- `feedback_legacy_code_sha256_validation.md` (User-Bestaetigungen + Compile-Time-Budget-Check)
- `reference_consteval_sha256_function_validation.md` (xxd-Auto-Install Direktive)

**MEMORY.md Index:** 6 neue Eintraege.

---

## §11 Repo-Stand Endstand heute Abend

| Repo | HEAD | Aenderung heute Abend |
|---|---|---|
| Diplomarbeit (PUBLIC) | `f9522af` (+ pending Session-Doku) | 9 Commits inkl. Doku + 4 Submodule-Bumps |
| cache-engine standalone | `e841097` | 5 substantielle Code-Commits |
| prt-art | unveraendert | — |
| 6 Modul-Skelette | unveraendert | — |

---

## §12 Pattern-Konsistenz-Audit-Tabelle (Endstand)

| Pattern | Allocator (Vorlage) | queuing (Q1+Q2) | traversal (03a/b/m) | Paper-Legacy (P1) |
|---|:---:|:---:|:---:|:---:|
| Topic-Concept + Component | ✓ | ✓ | ✓ | n/a |
| Sub-Achsen-Tags | 7 | 6+4 | 3+2+2 | n/a |
| CRTP-Base + Concept-Guard | ✓ | ✓ | ✓ | n/a |
| flags.hpp.in + Registry | ✓ | ✓ | ✓ | n/a |
| Sub-Concepts | 6 | 4+1 | 2+2+1 | 1 (LegacyOriginalCodePflicht cross-topic) |
| iterable_aspect_t | — | ✓ (4+2) | ✓ (2) | n/a |
| Mess-API (snap+obs+stat+reset) | ✓ | ✓ | ✓ | n/a |
| static_assert Sub-Concept-Footer | n/a | ✓ | ✓ | ✓ |
| Runtime-Permutationen (constexpr-Configs) | ✓ | ✓ | ✓ | n/a |
| Edge-Case-Tests (Zero/Power-of-2) | ✓ | ✓ | ✓ | n/a |
| Algorithm-Property-Filter (mp_filter) | implizit | implizit | ✓ explizit (4 Predicates) | n/a |
| PermutationEngine-Integration | ✓ | ✓ | ✓ | n/a |
| Compile-Time-Only Tests (static_assert) | ✓ | ✓ | ✓ | ✓ (alle 12 hart) |
| **Paper-Original-Code-Linking** | TODO Phase B.2 | n/a (alle "self") | n/a (alle "self") | ✓ Pattern etabliert |
| **experiment_compiler() Pflicht-API** | TODO Phase B.2 | TODO Phase B.2 | TODO Phase B.2 | ✓ definiert |
| **is_original_module() Pflicht-API** | TODO Phase B.2 | TODO Phase B.2 | TODO Phase B.2 | ✓ definiert |

**Konsequenz:** alle 50 bestehenden Wrappers brauchen Mass-Update mit Defaults
(`experiment_compiler="self"`, `has_original_paper_code=false`,
`is_original_module=false`) — Phase B.2.

---

## §13 Phase B.2 Plan (naechster Sprint)

**Reihenfolge (4 Sub-Tasks):**

### P2.A — CMake-Infrastruktur (Build-Time-Tooling)
1. `cmake/is_original_codegen.cmake` — Build-Time-Funktion
   - `comdare_generate_is_original_header(WRAPPER fn SOURCE expected_sha OUTPUT_DIR)`
   - Ruft `apps/is_original_validator` zur Build-Time auf
   - Generiert `${CMAKE_BINARY_DIR}/generated/.../wrapper_is_original.hpp`
2. `cmake/compiler_cache.cmake` — Compiler-Cache Auto-Install
   - `comdare_ensure_compiler(NAME url SHA256 BUILD_WITH)`
   - Auto-Download + Build mit System-Compiler + Marker-File
   - Globaler `${CMAKE_SOURCE_DIR}/compiler_cache/` Ordner
   - Cross-Platform 3 OS + 4 ISAs
3. `cmake/paper_binary.cmake` — Paper-Binary Compile
   - `comdare_build_paper_binary(PAPER COMPILER SOURCES FLAGS OUTPUT)`
   - Compiliert Original-Code mit gecachtem Original-Compiler
   - Output: static library .a/.lib im build-cache

### P2.B — mimalloc Pilot End-to-End
4. `libs/cache_engine/topics/allocator/axis_06_allocator/legacy_code/paper_a04_mimalloc/` Snapshot
   - Kuratierter mimalloc-Source (relevant subset: alloc.c + heap.c + mimalloc.h)
   - LICENSE (MIT)
   - compiler_info.txt ("gcc-9.5 -O3 -mavx2")
   - sha256_originals.txt
   - README.md (Leijen MSR-TR-2019-18 + ISMM 2019)
5. `axis_06_allocator_mimalloc_original.hpp+cpp` — C-Interface Adapter
   - extern "C" Wrapper um mi_malloc/mi_free/mi_realloc
6. `axis_06_allocator_mimalloc.hpp` Refactor
   - `experiment_compiler() = "gcc-9.5"`
   - `has_original_paper_code() = true`
   - COMDARE_IS_ORIGINAL_FROM_GENERATED fuer allocate/deallocate/reallocate
   - is_original_module() Aggregation

### P2.C — Concept-Pflicht-Erweiterung Mass-Update (50 Wrapper)
7. Allocator-Concept Pflicht-Erweiterung mit `LegacyOriginalCodePflicht<W>`
8. queuing-Concept Pflicht-Erweiterung (Q1 + Q2)
9. traversal-Concept Pflicht-Erweiterung (03a + 03b + 03m)
10. **Mass-Update 50 Wrapper:**
    - 24 Allocator (alle ausser mimalloc): `experiment_compiler="self"` oder `"system"` (StdMalloc/PMR), `has_original=false`, `is_original_module=false`
    - 14 queuing Q1: alle `"self"`, `false`, `false`
    - 5 queuing Q2: alle `"self"`, `false`, `false`
    - 7 traversal: alle `"self"`, `false`, `false`
    - mimalloc bleibt einzige Ausnahme mit echtem Original-Linking

### P2.D — Roll-out auf 3 weitere Allocator (optional, separater Sprint)
11. A05 jemalloc (BSD-Build-System)
12. A06 tcmalloc (Bazel-Build — kompliziert)
13. A07 snmalloc (modern C++17, einfacher)

---

## §14 Naechste Session beginnt mit

**Pflicht-Pre-Read (in dieser Reihenfolge):**
1. `MEMORY.md` (Index)
2. **Dieses Dokument** (`20260526-V41-F-6-1-traversal-konsolidierung-paper-legacy-pattern-session.md`)
3. `docs/architektur/13_paper_legacy_code_architektur.md` (Architektur-Schichten)
4. Memory `[[compile-time-only-no-runtime]]` (KRITISCHE Pflicht-Direktive)
5. Memory `[[paper-original-code-pattern]]` + `[[experiment-compiler-property]]` + `[[legacy-code-sha256-validation]]`
6. Memory `[[pseudocode-papers-fallback]]`
7. Memory `[[meta-driven-concept-hardening-pattern]]` (Pattern-Klassifikation)

**Build-Verifikation:** 252 allocator + 205 queuing + 95 traversal + 12 paper_legacy_code = 564 Cache-Engine grün + 104 Diplomarbeit grün.

**Direkt-Start (Phase B.2):**
- Sub-Task P2.A: CMake-Infrastruktur (is_original_codegen + compiler_cache + paper_binary)

---

## §15 Lessons-Learned (3 Hauptpunkte)

1. **Pattern-First, Code-Second** — bei substantiellen Architektur-Aenderungen
   (wie Paper-Legacy-Code) zuerst Memory + Doku schreiben, dann Code. Spart
   Re-Implementations + Anti-Pattern-Risiken.

2. **Compile-Time-Only ist nicht verhandelbar** bei Latenz-kritischen Algorithmen.
   Wenn Compile-Time-Loesung Probleme hat (MSVC-Bug): NICHT Runtime-Fallback,
   sondern Pre-Build-Tool-Pattern erwaegen. Memory
   `[[compile-time-only-no-runtime]]` muss Standard-Reflex werden.

3. **Standalone-Implementations dokumentieren** — Doku-Kommentare "Inspiriert
   von Legacy-X" suggerieren Code-Delegation, auch wenn der Code standalone ist.
   Wissenschaftliche Paper-Referenzen explizit machen statt informeller
   Legacy-Hinweise.

---

**Ende Session-Doku 2026-05-26 spaeter Abend.**
