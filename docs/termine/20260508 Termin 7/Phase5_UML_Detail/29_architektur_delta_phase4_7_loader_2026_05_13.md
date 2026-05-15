# Architektur-Delta REV 7.5 — Phase 4-7: LINK + LOAD + EXECUTE + MEASURE + TEARDOWN (2026-05-13)

**Status:** Delta-Erweiterung zu `24_architektur_skizze_REV7_2026_05_13.md`
**Anlass:** Phase 7.2 Restpunkte — vorher waren Phase 4-7 in `main.cpp` als `[TODO]`
            markiert. REV 6 §5.28.4 fordert dlopen-basiertes Loading.

---

## §1 Was wurde umgesetzt

Drei aufeinander aufbauende Komponenten + voller End-to-End-Lauf der 7 Phasen:

### 7.2.D — `ModuleLoader` (plattform-agnostisch)

`cache_engine/builder/module_loader/module_loader.{hpp,cpp}`:

- `ModuleHandle` (RAII): non-copyable, movable; haelt native handle +
  `comdare_permutation_module_v1 const*`-Pointer.
- `ModuleLoader::load(path, handle_out)` — plattform-spezifisch:
  - Windows: `LoadLibraryW(wide-path)` + `GetProcAddress(hmod, "comdare_get_module_v1")`
  - POSIX:   `dlopen(path, RTLD_NOW | RTLD_LOCAL)` + `dlsym(handle, "comdare_get_module_v1")`
- `ModuleLoader::load_all(dir, out_handles)` — scanned ein Verzeichnis nach
  `comdare_perm_*.{dll,so,dylib}` und ladet alle.
- `ModuleLoader::platform_suffix()` — Compile-time-Auswahl der Suffix.
- Status-Codes (errno-style):
  - `status_ok = 0`
  - `status_file_not_found = 1`
  - `status_load_failed = 2`
  - `status_symbol_not_found = 3`
  - `status_abi_mismatch = 4`
  - `status_null_module = 5`

CMakeLists.txt:
```cmake
add_library(comdare_module_loader STATIC module_loader.cpp)
if(UNIX AND NOT APPLE)
    target_link_libraries(comdare_module_loader PUBLIC dl)
endif()
```

### 7.2.D-Codegen-Fix — `__declspec(dllexport)` / `visibility("default")`

Erstes End-to-End-Loaden ergab `status_symbol_not_found` fuer alle 54 DLLs —
weil das `comdare_get_module_v1`-Symbol auf Windows-DLLs **NICHT exportiert**
ist ohne `__declspec(dllexport)`. Codegen (`cache_engine/builder/codegen/codegen.cpp`)
emit jetzt:

```cpp
#if defined(_WIN32)
  #define COMDARE_MODULE_EXPORT __declspec(dllexport)
#elif defined(__GNUC__) || defined(__clang__)
  #define COMDARE_MODULE_EXPORT __attribute__((visibility("default")))
#else
  #define COMDARE_MODULE_EXPORT
#endif

extern "C" COMDARE_MODULE_EXPORT comdare_permutation_module_v1 const*
comdare_get_module_v1(void) { return &k_module; }
```

### 7.2.E — Phase 4-7 in `main.cpp`

`main.cpp` ersetzt den `[TODO]`-Block durch echte Implementierungen:

**Phase 4 LINK+LOAD:**
```cpp
std::filesystem::path dll_dir = build_dir / "Debug";  // Single-Config-Generator fallback: build_dir
std::vector<ModuleHandle> handles;
ModuleLoader::load_all(dll_dir, handles);
```

**Phase 5+6 EXECUTE+MEASURE:**
```cpp
WorkloadConfig wc{ .num_keys=1000, .num_operations=500, .random_seed=42 };
auto ops          = WorkloadGenerator{wc}.generate_ycsb(YcsbWorkload::C);
auto workload_abi = WorkloadGenerator{wc}.to_abi_descriptor(ops);

ResultAggregator aggregator;
for (auto& h : handles) {
    auto const* m = h.get();
    void* inst = m->create_instance(nullptr);
    comdare_measurement_record_v1 rec{};
    m->run_workload(inst, &workload_abi, &rec);
    m->destroy_instance(inst);  // Phase 7 TEARDOWN
    aggregator.add({ permutation_id, fingerprint, rec, true });
}
```

**Phase 7 PERSIST+UNLOAD:**
```cpp
aggregator.export_csv (output_dir / "measurements.csv");
aggregator.export_json(output_dir / "measurements.json");
handles.clear();  // RAII unload aller DLLs
```

---

## §2 Tests (Phase 7.2.D)

`tests/unit/test_module_loader.cpp` + `tests/unit/mock_permutation_module.cpp`:

Mock-DLL `comdare_perm_mock_test` exportiert ABI mit Fingerprint
`0xABCDEF0123456789ULL` + `run_workload` setzt `op_count=12345`, `total_cycles=67890`.

**8 Tests grün** (MSVC Debug C++23):

| Test | Inhalt |
|---|---|
| `PlatformSuffixIsValid` | `.dll`/`.so`/`.dylib` je Plattform |
| `LoadNonexistentReturnsFileNotFound` | Status 1 fuer nicht-existente Datei |
| `LoadInvalidBinaryReturnsLoadFailed` | Status 2 fuer Text-Datei mit `.dll`-Suffix |
| `LoadMockDllSucceeds` | ABI-Version + Fingerprint + alle 4 Function-Pointer != nullptr |
| `MockDllRunWorkloadProducesExpectedRecord` | `op_count==12345`, `total_cycles==67890`, `hw.cycles==99` |
| `FingerprintAccessorMatches` | `ModuleHandle::fingerprint()` == Mock-Fingerprint |
| `MoveSemanticsTransferOwnership` | Source nach `std::move` invalid, target valid |
| `LoadAllFromDirectoryFindsMockDll` | `load_all()` findet Mock-DLL in target dir |

CMake-Integration via Generator-Expression:
```cmake
target_compile_definitions(test_module_loader PRIVATE
    "COMDARE_MOCK_DLL_PATH=\"$<TARGET_FILE:comdare_perm_mock_test>\"")
```

---

## §3 End-to-End-Verifikation (alle 7 Phasen)

```text
==== CacheEngineBuilder Phase 7.2 ====
[Phase 1] Parsed XML configs ...  Enumerated 54 permutations.
[Phase 2] Generated 54 modules + Aggregator-CMakeLists.txt
[Phase 3] cmake configure + cmake --build --target comdare_all_permutations
          OK — all 54 permutation modules built.
[Phase 4] Loading permutation modules from .../build-perms/Debug ...
          Loaded 54 of 54 modules.
[Phase 5+6] Running workload (500 ops) against 54 modules ...
          Collected 54 measurement records.
[Phase 7] Wrote .../measurements.csv (55 Zeilen: 1 Header + 54 Records)
[Phase 7] Wrote .../measurements.json
[Phase 7] Unloaded all modules.
```

Verifikation der CSV-Ausgabe (3 von 54 Zeilen):
```
ce_lockfree:prt_art_v1:tcmalloc_modern:ycsb_c_zipfian,1535...,1,0,0,...
ce_hardened:art_baseline:mimalloc_default:commoncrawl_urls,1943...,1,0,...
ce_hardened:prt_art_v1:tcmalloc_modern:ycsb_c_zipfian,2191...,1,0,...
```

`op_count=0` ist konsistent mit der Mock-Implementation der generierten
Module — `out_record = {}; out_record->version = COMDARE_ABI_VERSION` (kein
echter Workload-Loop). Bei realer Re-Implementation der Permutationen werden
diese Felder mit echten Counter-Werten gefuellt.

---

## §4 Architektur-Konventionen

1. **`COMDARE_MODULE_EXPORT`** Macro im generierten Code — Pflicht fuer
   Symbol-Export auf Windows (`__declspec(dllexport)`). Ohne wuerden die DLLs
   compilieren, aber das `comdare_get_module_v1`-Symbol waere fuer
   `GetProcAddress` nicht sichtbar.
2. **RAII fuer ModuleHandle** — Destruktor unload, non-copyable, movable.
   Verhindert Doppel-Unload + Memory-Leaks bei Exception-Pfaden.
3. **`load_all()` Pattern-Match** — nur `comdare_perm_*.{dll,so,dylib}`-Files
   werden geladen; andere Dateien im build-Verzeichnis (Compiler-Artefakte,
   `.lib`, `.pdb`) werden ignoriert.
4. **`ResultAggregator`** als ABI-Brueckenkopf — der existing Phase-7.3-
   ResultAggregator akzeptiert `comdare_measurement_record_v1` direkt, kein
   Adapter-Layer noetig.
5. **Single-Config-Build-Path:** Auf Visual Studio (Multi-Config-Generator)
   landen DLLs in `<build_dir>/Debug/`. Auf Ninja/Make (Single-Config) in
   `<build_dir>/`. main.cpp prueft beide via `is_directory()`.

---

## §5 Naechste Schritte

- **Echte Permutations-Logic** — die generierten Module sind aktuell
  Mock-Stubs. Naechster Schritt: pro Permutation echten ExecutionEngine-Code
  einsetzen (z. B. PRT-ART-Bausteine kombinieren) — Codegen muss Template-
  Code mit Permutations-spezifischen `using`-Aliases emittieren.
- **HW-Counter-Integration** — `pull_live_counters` ist noch ungenutzt;
  in echten Workloads kann das pro Operation aufgerufen werden.
- **`comdare_cache_engine_v1`-Service-Wiring** — bisher rufen wir
  `create_instance(nullptr)` mit Null-Pointer fuer den `engine`. Bei realem
  Wiring waere hier eine geteilte CacheEngine-Instanz, die `advise()` +
  `notify()` + `snapshot()` zwischen Permutationen koordiniert.
- **Pfad-Robustheit:** der `dll_dir = build_dir/Debug` fallback ist
  Visual-Studio-spezifisch. Eine robustere Loesung waere, die Module-Pfade
  aus CMake's `$<TARGET_FILE_DIR:comdare_all_permutations>` zu lesen.

---

## §6 Querverweis

- ABI: `cache_engine/include/cache_engine/abi/module_abi_v1.hpp`
- Loader: `cache_engine/builder/module_loader/{module_loader.hpp, module_loader.cpp}`
- Builder: `cache_engine/builder/main.cpp` (Phase 4-7 Implementierung)
- Codegen-Fix: `cache_engine/builder/codegen/codegen.cpp` (`COMDARE_MODULE_EXPORT`)
- Tests: `tests/unit/{test_module_loader.cpp, mock_permutation_module.cpp}`
- Aggregator: `experiment/src/result_aggregator.cpp` (Phase 7.3)
- WorkloadGenerator: `workload_generator/include/comdare/workload_generator/workload_generator.hpp`
- Vorgaenger-Deltas: 25 (hybrid_search), 26 (legacy_reimpl), 27 (ycsb_cli), 28 (cmake_pipeline)
