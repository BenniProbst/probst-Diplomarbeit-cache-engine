# Architektur-Delta REV 7.4 — Echte cmake-Module-Build-Pipeline (2026-05-13)

**Status:** Delta-Erweiterung zu `24_architektur_skizze_REV7_2026_05_13.md`
**Anlass:** Aufgabe #182 — Phase 7.2 "Echte cmake-Module-Build-Pipeline"
            (vorher nur `--enumerate-only` mode mit 54 Permutationen)

---

## §1 Was wurde umgesetzt

Drei aufeinander aufbauende Aenderungen am `CacheEngineBuilder`:

### 7.2.A — Aggregator-CMakeLists.txt im Codegen

`CodegenEngine::generate_aggregate_cmake(std::span<uint64_t>)` schreibt im
`output_root` einen zentralen `CMakeLists.txt`, der:
- `cmake_minimum_required(VERSION 3.28)` + `project(comdare_permutations)`
- C++23 + `CMAKE_POSITION_INDEPENDENT_CODE ON` (Pflicht fuer SHARED-Modules)
- Pro Fingerprint: `include(...module_<fp>_CMakeLists.txt)` + `add_dependencies(comdare_all_permutations comdare_perm_<fp>)`
- `add_custom_target(comdare_all_permutations ALL ...)` als Master-Target

Zusaetzlich Codegen-Fix: alle Pfade in der CMake-Ausgabe via
`std::filesystem::path::generic_string()` mit **Forward-Slashes** — Windows-
Backslashes triggern sonst CMake-Escape-Errors.

### 7.2.B — Subbuild-Driver in CacheEngineBuilder/main.cpp

Phase 2+3 in `main.cpp` ist nicht mehr `[TODO]`, sondern:

1. **Phase 2 (Codegen):** Loop ueber `descriptors` → `generate_module(...)` +
   sammeln aller fingerprints → `generate_aggregate_cmake(fingerprints)`
2. **Phase 3 (Subbuild):**
   ```
   cmake -S <output_root> -B <output_root>/build-perms
   cmake --build <output_root>/build-perms --target comdare_all_permutations
   ```
3. Fehlerbehandlung: bei Non-Zero-Exit von cmake wird der entsprechende
   Status-Code des Builders zurueckgegeben.

Neue CLI-Optionen:
- `--comdare-root=DIR` ueberschreibt den `current_path()`-Default fuer die
  Include-Pfad-Eintrag in den generierten Module-CMakeLists. Pflicht, wenn der
  Builder ausserhalb des Repo-Roots gestartet wird (z. B. aus `C:\Windows\System32`).
- `--skip-build` generiert nur Sources + Aggregator, ohne cmake aufzurufen
  (fuer schnelle Codegen-Iteration + CI-Pruefung der Source-Schritte).

### 7.2.C — Tests fuer Codegen-Pipeline

`tests/unit/test_builder_codegen.cpp` mit **7 Tests** (`CodegenFixture`):

| Test | Inhalt |
|---|---|
| `GenerateModuleCreatesSourceFile` | `.cpp` enthaelt `comdare_get_module_v1` + fingerprint-hex + perm-ID |
| `GenerateModuleCreatesCMakeListsFile` | `.CMakeLists.txt` enthaelt `add_library SHARED` + `cxx_std_23` + **keine Backslashes** |
| `AggregateCmakeEmptyListProducesValidFile` | Aggregator funktioniert auch mit 0 Permutationen |
| `AggregateCmakeListsAllFingerprints` | Alle Fingerprints werden via `include(...)` + `add_dependencies(...)` aggregiert |
| `AggregateCmakeUsesCxxStd23` | Aggregator setzt C++23 |
| `AggregateCmakeUsesPositionIndependentCode` | Aggregator setzt `CMAKE_POSITION_INDEPENDENT_CODE ON` |
| `TwoPermsEndToEndGeneration` | 2 Mock-Permutationen voll generieren — alle 5 Dateien (2× .cpp, 2× per-CMakeLists, 1× Aggregator) existieren |

**7/7 PASSED** (MSVC Debug C++23, ~106 ms).

---

## §2 End-to-End-Verifikation

Mit `cache_engine\builder\example_configs\` (3 cache_engine_perms × 3 search_algorithm_perms × 3 allocator_perms × 2 test_data_sets — abzueglich Filter):

```
> comdare-cache-engine-builder.exe <repo>/cache_engine/builder/example_configs \
    <tmp>/comdare_pipeline_test \
    --comdare-root=<repo>

==== CacheEngineBuilder Phase 7.2 ====
[Phase 1] Parsed XML configs: ...
  Enumerated 54 permutations.
[Phase 2] Generating 54 modules ...
  Aggregator: ...generated/CMakeLists.txt
[Phase 3] Configuring cmake subbuild under <tmp>/build-perms ...
  $ cmake -S "..." -B "..."
  $ cmake --build "..." --target comdare_all_permutations
[Phase 3] OK — all 54 permutation modules built.
```

**Ergebnis:** 54 DLL-Module gebaut (jeweils ~57 KB):
```
comdare_perm_<hex>.dll  ×  54
```

Jede DLL exponiert `comdare_get_module_v1(void)` (extern "C") — dlopen-/
LoadLibrary-loadbar fuer Phase 4 (LINK+LOAD im naechsten Schritt).

---

## §3 Architektur-Konventionen

1. **Pfad-Convention:** Codegen schreibt **alle** Pfade in CMake-Ausgaben mit
   `generic_string()` (Forward-Slashes) — Windows-Backslashes brechen CMake-
   Escape-Parsing (`\W` als invalid escape).
2. **Position-Independent-Code:** Pflicht fuer SHARED-Module-Binaries
   (`CMAKE_POSITION_INDEPENDENT_CODE ON`).
3. **Aggregator-Target:** `comdare_all_permutations` (ALL-Target) ermoeglicht
   `cmake --build ... --target comdare_all_permutations` als 1-Befehl-Build.
4. **Generate-Only-Mode:** `--skip-build` trennt Source-Generation von
   Subbuild — wichtig fuer CI-Pipelines mit getrennten Build-Phasen.
5. **`--comdare-root` Override:** entkoppelt CWD vom Include-Pfad.

---

## §4 Naechste Schritte (Phase 7.3+, deferred)

- **Phase 4-7 (LINK+LOAD+EXECUTE+MEASURE+TEARDOWN)** noch `[TODO]` in
  main.cpp — naechster Schritt: dlopen/LoadLibrary der 54 DLLs, dann
  `comdare_get_module_v1()->run_workload(workload_descriptor, &record)`
  pro Modul + ResultAggregator-Integration (Phase 7.3).
- **Per-Module Compile-Flags** — derzeit nutzt das Codegen-Skelett kein
  Permutations-spezifisches `#define`/`add_compile_definitions(...)`.
  Bei Bedarf kann pro Permutation z. B. `-DCOMDARE_ALLOC_FAMILY=tcmalloc`
  gesetzt werden (REV 7 §5.3.2).
- **PRT-ART als 4. Achse** — die `prt_art_permutations.xml` koennte als 4.
  Faktor zum Permutations-Raum hinzukommen (3×3×3×N statt 3×3×3×2).

---

## §5 Querverweis

- Aggregator-Pfad: `CodegenEngine::aggregate_cmake_path()` → `<output_root>/CMakeLists.txt`
- Code: `cache_engine/builder/codegen/codegen.{hpp,cpp}`, `cache_engine/builder/main.cpp`
- Tests: `tests/unit/test_builder_codegen.cpp` (7 Tests)
- E2E-Beispiel: `cache_engine/builder/example_configs/*.xml` → 54 DLLs
- Memory: [[feedback-phase-completeness-discipline]]
- Memory: [[feedback-algorithm-correctness-when-named]] (relevant fuer
          Permutations-Codegen — kein generischer Skelett-Code, sondern
          ABI-konforme Module)
