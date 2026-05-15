# UML — Engine-Choice + CacheEngineBuilder

**Bezug:**
- ADR F12 (CacheEngineBuilder als Orchestrator, main.cpp-Stil)
- ADR F12-K (Korrektur: CacheEngine ist Heap-Singleton im Builder-Prozess; KEIN separater Service)
- ADR F4 (Permutationsraum vollstaendig mit ISA-Filter via CMake compile-time)
- ADR F10-K (Strukturiertes Flag-System statt opaker perm_id, Intel-CPUID-Vorbild)
- ADR F-EXTRA-1 (Compiler-Layering: Hauptcompiler IMMER C++23; Bausteine-Internals mit Original-Compiler statisch gelinkt)
- ADR F-EXTRA-5 REVIDIERT durch H6 (NO-PYTHON-DIREKTIVE: CMake + sh/bat statt Python)
- Block AP (Forschungs-Mission: heuristisch ↔ informiert ↔ adaptiv)

**Architektur-Lokation:** `cache_engine/builder/` im Repo `comdare-cache-engine`.

---

## 1. CacheEngineBuilder — Top-Level Orchestrator (F12-K)

```
class CacheEngineBuilder <<orchestrator>> <<main>> {
    ' F12: lebt als main.cpp-Prozess (eigenes Binary pro Plattform)
    ' F12-K: enthaelt CacheEngine als Heap-Singleton

    -- Lebenszyklus-Phasen --
    + run() : ExitCode
    ' Sequenziell: probe → scan → build_missing → instantiate_cache_engine
    '              → for each module: load → warmup → experiment → reset → unload
    '              → serialize_buffer → render_latex

    -- Sub-Komponenten (Heap, F1) --
    - platform_probe_       : unique_ptr<IPlatformProbe>
    - module_registry_      : ModulePermutationRegistry
    - cmake_codegen_driver_ : CMakeShBatCodegenDriver  ' F-EXTRA-5 REVIDIERT (NO PYTHON)
    - dataset_loader_       : DatasetLoader            ' F14 + F-EXTRA-2
    - measurement_buffer_   : InMemoryMeasurementBuffer&  ' Reference auf CacheEngine-Slot
    - latex_renderer_       : LatexRenderer            ' H3 LaTeX-Toolchain

    -- Kompilier-Kontroll-Methoden --
    + scan_modules() : vector<ModuleSpec>
    + build_missing_modules() : void
    ' Triggert adhoc CMake-Skript (F12, codegen.cmake + sh/bat)

    -- Experiment-Loop-Methoden --
    + run_single_experiment(spec : ModuleSpec) : ExperimentResult
    + run_all_permutations() : vector<ExperimentResult>

    -- Mode-Selection (Block AP — Forschungs-Mission) --
    + set_mode(mode : CacheEngineMode) : void
    ' HEURISTIC_STATIC | INFORMED_KALIBRIERT | AUTOMATIC_ADAPTIVE

    -- Constraints --
    inv: lebt als Builder-Prozess (main.cpp), NICHT als Library
    inv: instantiiert CacheEngine::instance() einmal in run()
    inv: vor jedem Experiment: cache_engine.reset_state()
}
```

---

## 2. F12 Lebenszyklus-Sequenz

```
@startuml
participant "main()" as M
participant CacheEngineBuilder as B
participant PlatformProbe as P
participant ModulePermutationRegistry as MR
participant CMakeCodegenDriver as CG
participant CacheEngine as CE
participant InMemoryMeasurementBuffer as Buf
participant DynamicModule as Mod

M -> B: run()
B -> P: probe()
P --> B: PlatformProfile (CPU + ISA + Cache-Topo + Compiler)

B -> MR: scan_modules()
MR --> B: existing : list<ModuleSpec>

alt missing modules
  B -> CG: build_missing(specs)
  CG -> CG: cmake -P codegen.cmake (oder codegen.sh/bat)
  CG -> CG: cmake --build (Pre-Build-Phase)
  CG --> B: ok / fail
end

B -> CE: instance()
CE --> B: ref

loop for each spec in MR
  B -> Mod: dlopen(spec.path)
  Mod --> B: handle
  B -> CE: bind_loaded_module(handle)
  B -> CE: warm_up_for_module(handle)
  B -> Buf: begin_run(spec)
  B -> Mod: run_workload(dataset)
  Mod -> CE: notify(events) <<F2 push>>
  CE -> Buf: append_measurement(...)
  B -> CE: reset_state()
  B -> Mod: dlclose
end

B -> Buf: serialize_to_disk(path)
B -> B: latex_renderer.render(buffer)
@enduml
```

---

## 3. F10-K — PermutationFlags (CPUID-Vorbild)

```
struct PermutationFlags <<value>> {
    ' Bank-Layout aus Flag_System.txt
    + page_bank          : uint64_t
    + node_bank          : uint64_t
    + traversal_bank     : uint64_t
    + value_handle_bank  : uint64_t
    + memory_layout_bank : uint64_t
    + allocator_bank     : uint64_t
    + prefetch_bank      : uint64_t
    + concurrency_bank   : uint64_t
    + isa_bank           : uint64_t
    + telemetry_bank     : uint64_t  <<NEU 2026-05-09 — Achse 11>>

    + to_identifier() const noexcept : string_view
    ' z.B. "PAGE_DENSEBYTE_ART256.NODE_NODE256.TRAVERSAL_BYTEBYBYTE.
    '       VALUEHANDLE_INLINE.MEMORY_CACHELINE_ALIGNED.ALLOCATOR_POOL.
    '       PREFETCH_NONE.CONCURRENCY_OLC.ISA_X86_AVX2.TELEMETRY_LEAFONLY"

    + is_valid_combination() const noexcept : bool
    ' ConstraintFilter: pruefe inkohaerente Bit-Kombinationen
    ' z.B. AVX-512-Bit nur bei isa_bank.AVX512F gesetzt
    '       LeafOnlyCounter-Bit nur mit RetroactiveAggregation-Bit (Block AJ Abhaengigkeit)
}
```

---

## 4. ModulePermutationRegistry

```
class ModulePermutationRegistry {
    -- Attribute --
    - registry : map<PermutationFlags, ModuleSpec>
    - module_root : filesystem::path  ' build/modules/<perm_id>/<perm_id>.module.so

    -- Methoden --
    + scan_modules() : vector<ModuleSpec>
    + identify_missing(target_set : set<PermutationFlags>) : vector<PermutationFlags>
    + register(spec : ModuleSpec) : void
}

struct ModuleSpec <<value>> {
    + flags    : PermutationFlags
    + path     : filesystem::path
    + identifier : string
    + compile_pipeline : CompilePipeline   ' F-EXTRA-1 Compiler-Layering
}

struct CompilePipeline <<value>> {
    + main_compiler : CompilerInfo     ' immer C++23 (GCC 14+/Clang 17+/MSVC 19.39+)
    + bauteil_compilers : map<BausteinId, CompilerInfo>  ' pro Bausteine-Internal
    + link_strategy : LinkStrategy     ' static_link
}
```

---

## 5. CMakeShBatCodegenDriver (F-EXTRA-5 REVIDIERT durch H6)

```
class CMakeShBatCodegenDriver <<NO PYTHON>> {
    ' Loest urspruengliches Python-Codegen ab (H6 Direktive)
    -- Tooling-Dateien (synchron gepflegt) --
    - codegen_cmake : path = "tools/permutation_codegen/codegen.cmake"
    - codegen_sh    : path = "tools/permutation_codegen/codegen.sh"
    - codegen_bat   : path = "tools/permutation_codegen/codegen.bat"

    -- Methoden --
    + invoke(target : Platform, output_dir : path) : ExitCode
    ' Ruft codegen.cmake (cmake -P) oder codegen.sh/bat
    + verify_synchronization() : bool
    ' Stellt sicher, dass sh und bat aequivalent sind

    -- Constraints --
    inv: KEIN Python in der Toolchain (Talos-OS-Kompatibilitaet)
    inv: codegen.sh und codegen.bat bleiben synchron (verify_sync vor jedem Build)
}
```

---

## 6. EngineChoice — H5 ABI-stabiles Production-Container-Interface

```
<<concept>> ICacheAwareSearchAlgorithm {
    + lookup(key) -> optional<Value>
    + insert(key, value) -> InsertResult
    + erase(key) -> EraseResult
    + range_scan(begin, end) -> RangeIterator
}

class StaticEngineChoice <<production-container>> {
    ' Production-Modus: Optimal-Permutation pro Plattform geladen
    ' H5: ABI-stabil; std::map-aehnlich
    -- Attribute --
    - selected_module : unique_ptr<ICacheAwareSearchAlgorithm>
    - platform_signature : PlatformSignature
    -- Methoden (std::map-aehnliches Public-Interface) --
    + at(key) -> Value&
    + operator[](key) -> Value&
    + insert(...) -> ...
    + find(...) -> iterator
    + erase(...) -> ...
    -- Production-Specifics --
    + verify_abi(expected : AbiSignature) -> bool   ' F-EXTRA-8
}

class CacheEngineChoice <<experimental>> {
    ' Builder-Modus: CacheEngine aktiv, DecisionTrees + Adaptation
    -- Attribute --
    - engine_ref : CacheEngine&  ' aus Builder-Prozess
    - module_handle : ModuleHandle&
    -- Methoden --
    + run_in_mode(mode : CacheEngineMode) -> ExperimentResult
}
```

---

## 7. F-EXTRA-1 Compiler-Layering — UML-Komponenten

```
package "F-EXTRA-1 Compiler-Layering" {
  class ModulWrapperC23 <<C++23>> <<Schale>> {
    ' Concept-Bindungen, Adapter, ABI-stabiles Interface
    ' kompiliert mit GCC 14+/Clang 17+/MSVC 19.39+
  }

  class BausteinInternal <<Original-Compiler>> <<Internals>> {
    ' kompiliert mit jeweils Paper-Original-Compiler
    ' P01 GCC 4.7+, P02 GCC 5+, P04 GCC 11+, P03 GCC 4.6+,
    ' P06 GCC 9+, P07 GCC 7+, P25 GCC 11+
  }

  class StaticLinker {
    ' Linkt Schale + Internals zu .so/.dll/.dylib (ABI-stabil)
    ' INTERNAL_LINKAGE der Bauteile bleibt — externe ABI bleibt stabil
  }

  ModulWrapperC23 *-- "1" StaticLinker
  BausteinInternal *-- "*" StaticLinker
}
```

---

## 8. Lebenszyklus zwischen Experimenten (F12-K)

```cpp
// Pseudo-Code, im Builder run_single_experiment
auto& engine = CacheEngine::instance();   // F1 thread-safe call_once
auto module = dlopen(spec.path);           // ABI-stabiles Modul
engine.bind_loaded_module(module);
engine.warm_up_for_module(module);         // Cache-Warmup gehoert zur Permutation (F12)
auto result = run_workload(module, dataset);
engine.reset_state();                       // F12-K reset, NICHT Instanz
dlclose(module);
```

---

## 9. drawio-Tab-Struktur

| drawio-Tab | Inhalt |
|-----------|--------|
| Tab 05-A | CacheEngineBuilder Lebenszyklus (Section 1+2) |
| Tab 05-B | PermutationFlags + ConstraintFilter (Section 3) |
| Tab 05-C | F-EXTRA-1 Compiler-Layering Architektur (Section 7) |
| Tab 05-D | EngineChoice Production-Container (Section 6) |
| Tab 05-E | F-EXTRA-5 NO-PYTHON Codegen-Pipeline (Section 5) |
