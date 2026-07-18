# UML-Klassen — Konsolidierter Master

> ⚠️ **SUPERSEDED (2026-05-31):** Überholter Planungs-/Architektur-Stand (axis-zentrische Restruktur F.2, Plugin-Prüfling-Modell, DLL-F15-Pipeline, sezierte Organe). IST-treue Single-Source-of-Truth: `comdare-cache-engine/docs/ledger-sections/architektur-ziele-offene-punkte-ledger.md` + `…/20260531-e2e-abnahme-audit-und-entscheidungen.md`. Niemals löschen — nur Banner.

**Stand:** 2026-05-15 (K-C.6)
**Quellen:** Phase5_UML_Detail Doks 01-06 (~1.700 Z) — alle in `../termine/20260508 Termin 7/Phase5_UML_Detail/`
**Notation:** PlantUML-aehnliche Pseudo-Syntax (siehe Doc 00_README.md §"Notations-Konvention")

---

## §1 6 UML-Doks-Index

| Doc | Titel | LOC | Inhalt | Bausteine_Matrix-Achse |
|---|---|---|---|---|
| 01 | UML — Search Engine Klassen | 356 | Page / Node / Traversal / ValueHandle / MemoryLayout / Allocator / Prefetch | Achse 1-7 |
| 02 | UML — Cache Engine Klassen | 497 | CacheEngine-Singleton, DecisionLambdaTree, ConcurrencyManager, TelemetryStrategy | Achse 8 + 11 |
| 03 | UML — Measurement | 132 | Mess-Kategorie x Algo-Detail Matrix, constexpr-Spezialisierung | Achse 10 |
| 04 | UML — Hardware/ISA | 185 | Flag_System.txt-Bezug, PlatformProbe, X3D-V-Cache-Awareness | Achse 9 |
| 05 | UML — Engine-Choice + CacheEngineBuilder | 281 | F12-K Heap-Singleton im Builder-Prozess | (Querschnitt) |
| 06 | UML — Persistence | 115 | InMemoryMeasurementBuffer Disk-Dump, Binary/CSV-Schema | (F5 + ER-Modell) |

---

## §2 UML — Search Engine Klassen (Doc 01)

**ADR-Bezug:**
- F-EXTRA-1: Bausteine-Internals mit Original-Compiler kompiliert; Concept-Interface in C++23
- F3 (Visitor mid-granularity): `visit(IPage*)`, `visit(INode*)` — keine ValueHandle/TraversalStep-Visit
- F8 (ValueHandle): `std::variant<...>` + Concept-Constraint, Algorithmus-spezifische Untermenge
- F10-K (Bausteine via Bit-Position in Flag-Bank statt opake perm_id)

**Hauptklassen:**
```
class IPage <<concept>> {
    -- requires --
    + size_in_bytes() : size_t  <<noexcept>>
    + cache_line_count() : size_t  <<noexcept>>
    + serialize_to(buf : Buffer&) const : void
}

class IRootPage <<concept>>  // erweitert IPage
class IFanout <<concept>>     // konsumiert IPage als Container
class INode <<concept>>       // konsumiert vom IFanout

class ISearchPage <<concept>> // hat ISearchPageStructure (REV5 K02)
class ISearchPageStructure <<concept>>
class ISearchPageStructureInterpreter <<concept>>  // dekodiert variable lokale Codierung

class ICachePage <<concept>>  // hat ICacheStrategy (Visitor)
class ICacheStrategy <<concept>>  // VISITOR

class ITraversal <<concept>>  // Achse 3
class IValueHandle <<concept>>  // Achse 4 - std::variant + Concept-Constraint
class IMemoryLayout <<concept>>  // Achse 5
class IAllocator <<concept>>  // Achse 6 - typsicher std::allocator + std::pmr
class IPrefetch <<concept>>  // Achse 7
```

**Vollangaben** siehe Original-Datei `01_uml_search_engine.md` (356 Zeilen).

---

## §3 UML — Cache Engine Klassen (Doc 02, ZENTRALE Forschungs-Komponente)

**ADR-Bezug:**
- F1 (CacheEngine-Singleton, Heap-Allokation, `unique_ptr` + `call_once`)
- F2 (Observer-Push synchron mit Lambda-Tree-Filter)
- F6 (ConcurrencyManager: 8+ Disziplin-Klassen + Policy-Templates)
- F12-K (CacheEngine ist Heap-Singleton IM Builder-Prozess)
- F-EXTRA-6 (DecisionLambdaTrees PRO Baustein)

**Hauptklassen:**
```
class CacheEngine <<singleton>> {
    -- Attribute --
    + concurrency_manager : ConcurrencyManager& [0..1]
    + decision_trees : map<BausteinId, IDecisionLambdaTree*>
    - measurement_buffer : InMemoryMeasurementBuffer
    -- Methoden --
    + static instance() : CacheEngine&  <<thread-safe call_once>>
    + notify(event : Event&&) : void  <<noexcept>>
    + reset_state() : void
    -- Constraints --
    inv: instance() liefert immer dieselbe Adresse [F12-K]
    inv: lebt im Builder-Prozess, NICHT als separater Service [F12-K]
}

class IDecisionLambdaTree <<concept>>  // F-EXTRA-6: pro Baustein eigener Tree
class ConcurrencyManager  // F6: 8+ Disziplinen
class TelemetryStrategy <<concept>>  // Achse 11 - 6 Familien (REV v7 Kuehn-Erkenntnisse)

class Event {
    + baustein_id : BausteinId
    + decision_outcome : enum {EXECUTE, DELAY, SKIP}  // F2
    + timestamp_ns : uint64_t
}
```

**8 Concurrency-Disziplinen (REV v5 + V8.7 INK-3):**
1. SingleThreadedRead
2. SingleThreadedWrite
3. MultiReadSingleWrite (Default)
4. MultiReadMultiWrite (mit OLC-Variante)
5. MutexBased
6. SharedMutexBased
7. ScopedLockBased (Hierarchical)
8. RcuBased (mit 6 Flavor-Varianten)

**Plus 3 Mechaniken:**
- Lock-Free CAS
- RCU
- Hazard Pointers (REV4 ENTFERNT durch F12-K, RCU bevorzugt)

**6 TelemetryStrategy-Familien (Achse 11, NEU REV v7 Kuehn-Erkenntnisse 2026-05-09):**
1. PerNodeCounter (Cache-Coherence-Anti-Pattern auf Multi-Core ⚠️)
2. LeafOnlyCounter (Multi-Core-tauglich)
3. LeafOnlySampledCounter<N>
4. RetroactiveAggregation
5. PathReadCounter (P26 Zhang FGCS)
6. ProbabilityHintsHeader (P16 Bender)

**Vollangaben** siehe Original-Datei `02_uml_cache_engine.md` (497 Zeilen).

---

## §4 UML — Measurement (Doc 03)

**ADR-Bezug:**
- F1 (Per Mess-Kategorie x Algorithmus-Detail eine `constexpr`-Spezialisierung)
- F11 (Continuous fuer Builder, Sampled 1:N fuer Production)
- F-EXTRA-7 (Default-Hooks + algo-spezifische Overrides via `requires HasMeasurement<...>`)
- Bausteine_Matrix Achse 10 + 11

**Hauptklassen:**
```
template <MeasurementCategory C, AlgorithmDetail A>
class Measurement <<constexpr>> {
    -- requires --
    requires HasMeasurement<C, A>
    -- Methoden --
    + record(value : double) : void  <<noexcept>>
    + flush_to(buf : InMemoryMeasurementBuffer&) const : void
}

class MeasurementCategory <<enum>> { Throughput, Latency, CacheMiss, dTLBMiss, BranchMiss, Memory, ... }
class AlgorithmDetail <<enum>> { PerLookup, PerInsert, PerDelete, PerRange, PerRebalance, ... }
class HasMeasurement <<concept>>  // F-EXTRA-7 Constraint
```

**V31 Code-Stand:**
- `comdare-cache-engine/libs/cache_engine/builder/measurement_matrix/`
- `comdare-cache-engine/libs/cache_engine/builder/in_memory_measurement_buffer/` (V8.5 INK-8)

**Vollangaben** siehe Original-Datei `03_uml_measurement.md` (132 Zeilen).

---

## §5 UML — Hardware/ISA (Doc 04)

**ADR-Bezug:**
- F4 (Permutationsraum + ISA-Filter via CMake compile-time)
- F9 (ABI-Stabilitaet via C++23-Modules; Compile-Time UND Runtime-Detection)
- F10-K (Strukturiertes Flag-System nach CPUID-Vorbild, Bank pro Achse)
- F13 (Cross-Compilation + ZIH-Lieferung + CI/CD)

**Block AO (Production-Plattform):**
- Ryzen 9 9950X3D + i9-14900KS, 64 GB DDR5-5600 CL36

**Hauptklassen:**
```
class IPlatformProbe <<concept>>  // Auto-Discovery (REV5 K3.2)
class IPlatformPropertyClassifier <<concept>>
class FlagBank <<uint64_t>>  // Bank pro Achse, Bit-Position pro Implementation
class PermutationFlags {
    - banks : array<FlagBank, 9>  // 9 Banken
    + match_filter(filter : PermutationFlags) const : bool  // Bit-AND
}

class IsaFeatureSet <<enum>> { SSE2, SSE4_2, AVX, AVX2, AVX512, BMI2, ... }
class CacheTopology  // ICacheLevel + ICacheLine + ICacheResidency
class CoreLayout  // ICpuCore + ICoreToThreadMap
```

**V31 Code-Stand:**
- `comdare-cache-engine/libs/cache_engine/builder/platform_probe/`
- `comdare-common/platform/` (V23.C.3, ehem. hardware_isa)

**Vollangaben** siehe Original-Datei `04_uml_hardware_isa.md` (185 Zeilen) + `../bausteine/05_flag_system.md`.

---

## §6 UML — Engine-Choice + CacheEngineBuilder (Doc 05)

**ADR-Bezug:**
- F12 (CacheEngineBuilder als Orchestrator, main.cpp-Stil)
- F12-K (Korrektur: CacheEngine ist Heap-Singleton im Builder-Prozess; KEIN separater Service)
- F4 (Permutationsraum vollstaendig mit ISA-Filter via CMake compile-time)
- F10-K (Strukturiertes Flag-System statt opaker perm_id, Intel-CPUID-Vorbild)
- F-EXTRA-1 (Compiler-Layering: Hauptcompiler IMMER C++23; Bausteine-Internals mit Original-Compiler statisch gelinkt)

**Hauptklassen:**
```
class CacheEngineBuilder <<orchestrator>> {  // Pseudo-main.cpp (F12)
    -- Attribute --
    - cache_engine : unique_ptr<CacheEngine>  // F12-K Heap-Singleton im Builder-Prozess
    - permutations : vector<PermutationFlags>
    - module_loader : ModuleLoader
    -- Methoden --
    + run() : int  // Phase 1-7
    + run_permutation(p : PermutationFlags) : ExperimentResult
    -- Phasen --
    + phase_1_enumerate() : vector<PermutationFlags>
    + phase_2_codegen() : vector<ModuleSource>
    + phase_3_compile() : vector<ModulePath>
    + phase_4_load(paths : vector<ModulePath>) : vector<ModuleHandle>
    + phase_5_run(handle : ModuleHandle) : MeasurementSet
    + phase_6_measure(set : MeasurementSet) : void
    + phase_7_export(buf : InMemoryMeasurementBuffer&) : void
}

class StaticEngine <<engine_choice>>  // Compile-Time-Wahl
class CacheEngine <<engine_choice>>  // Runtime-aktiv (F12-K)
class EngineChoice <<concept>>  // C++23 Concept fuer Compile-Time-Wahl

class ModuleLoader {
    + load(path : ModulePath) : ModuleHandle  // LoadLibrary/dlopen (F9)
    + unload(handle : ModuleHandle) : void
}
```

**V31 Code-Stand:**
- `comdare-cache-engine/apps/cache_engine_builder/main.cpp` (V23.B Wrapper, 82 Zeilen)
- `libs/cache_engine/builder/experiment_driver/` (V8.7 Library)
- `libs/common/config/` (V30.D.3 ehem. engine_choice/ + ALIAS comdare::common::config)

**Vollangaben** siehe Original-Datei `05_uml_engine_choice_builder.md` (281 Zeilen).

---

## §7 UML — Persistence (Doc 06)

**ADR-Bezug:**
- F5 (eigene InMemoryMeasurementBuffer; KEINE externe DB; Disk-Dump am Ende)

**Hauptklassen:**
```
class InMemoryMeasurementBuffer {  // F5
    - records : vector<MeasurementRecord>
    + record(record : MeasurementRecord) : void  <<noexcept>>
    + dump_to_disk(path : Path) const : void  // Binary-Format
    + size() const : size_t
    + clear() : void
}

class MeasurementRecord {
    + permutation : PermutationFlags
    + category : MeasurementCategory
    + algo_detail : AlgorithmDetail
    + value : double
    + workload_used : WorkloadId  // V20.1
    + timestamp_ns : uint64_t
}
```

**Disk-Dump-Format:** Binary, sparse-serialisiert (siehe `06_er_model.md` ER-Modell)

**V31 Code-Stand:**
- `comdare-cache-engine/libs/cache_engine/builder/in_memory_measurement_buffer/`
- `Diplomarbeit/Code/binary_to_csv/` (Konvertierung Binary → CSV)
- `Diplomarbeit/Code/csv_to_latex/` (CSV → LaTeX-Tabelle)

**Vollangaben** siehe Original-Datei `06_uml_persistence.md` (115 Zeilen).

---

## §8 V12-V31 UML-Updates (REV7.7)

| Sprint | UML-Update | Doc-Bezug |
|---|---|---|
| V12 | PrtArtSearchEngine Vector-API +5 / Map-API +8 / Tuple-API / Container-Vertraege ABI | (in prt-art prt_art_search_engine.hpp) |
| V13 | runtime_codegen + functional_tests + CMake Stage-1/2 | (in libs/cache_engine/builder/codegen) |
| V20 | PermutationResult.workload_used Field | (in libs/cache_engine/builder/permutation_engine) |
| V25.B | `<expected_workload>`-Tag fuer alle 30 SOTA-Profile | (in libs/common/serialization/xml_config_parser) |
| V29 | `<allocator_override>`-Tag | (in libs/common/serialization/xml_config_parser) |
| V30 | libs/-Migration | (alle libs/-Pfade aktualisiert) |
| V31 | 22 Adapter-Klassen | (in adapters/{P,A}*/) |

---

## §9 Querverweise

- Original-Quellen (UNVERAENDERT):
  - `../termine/20260508 Termin 7/Phase5_UML_Detail/01_uml_search_engine.md`
  - `../termine/20260508 Termin 7/Phase5_UML_Detail/02_uml_cache_engine.md`
  - `../termine/20260508 Termin 7/Phase5_UML_Detail/03_uml_measurement.md`
  - `../termine/20260508 Termin 7/Phase5_UML_Detail/04_uml_hardware_isa.md`
  - `../termine/20260508 Termin 7/Phase5_UML_Detail/05_uml_engine_choice_builder.md`
  - `../termine/20260508 Termin 7/Phase5_UML_Detail/06_uml_persistence.md`
- ER-Modell: `06_er_modell.md` (K-C.7)
- Cross-Reference: `07_cross_reference.md` (K-C.8)
- drawio-Export: `08_drawio_export.md` (K-C.9)
- F1-F15 Architekturentscheidungen: `../bausteine/04_architekturentscheidungen_F1_F15.md`
- Flag-System: `../bausteine/05_flag_system.md`
- Begriffsglossar v7 Master: `../glossar/01_begriffsglossar_v7_master.md`
- drawio-Datei (REV6 Basis): `../termine/20260508 Termin 7/Phase5_UML_Detail/phase5_uml_detail_REV6.drawio`
