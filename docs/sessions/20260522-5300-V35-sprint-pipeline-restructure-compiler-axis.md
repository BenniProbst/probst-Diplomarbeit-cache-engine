# Session 5300 — V35-Sprint: Pipeline-Restructure + Compiler-Achse + Stufen-Tests

**Datum:** 2026-05-22
**Vorgaenger:** `20260521-5200-V33-autonomous-sprint-12-todos-komplett.md`
**Trigger:** User-Direktive 2026-05-22 — XX_operation/ Struktur + Compiler-Achse + isolierte Stufen-Tests + Build-Type-Independence

---

## §0 EXECUTIVE SUMMARY

**Komplett: V35.A + V35.B + V35.C. In-Progress: V35.D (1/4 Stufen, Stufe 03 fertig).**

V35-Direktive vom User: "Teile und Herrsche" sichtbar machen — Pipeline-Module als
`XX_operation/`, eigene README + tests/fixtures/cached/, Compiler als 15. Achse,
keine hartcodierten Build-Configs.

| Phase | Status | Tests |
|---|---|---|
| **V35.A** Pipeline-Restrukturierung | ✅ DONE | 85 Tests gruen vor/nach Rename |
| **V35.B** Compiler-Achse 15 (15.1-15.5) | ✅ DONE | +9 Tests (2 cache-engine + 7 Diplomarbeit) |
| **V35.C** Build-Type-Independence run_all_tests | ✅ DONE | autodetect + override modi |
| **V35.D** Pro-Stufe Tests mit Fixtures | ⏳ 1/4 (Stufe 03 fertig +5 Tests) | 90 gruen total |

Final HEADs:
- cache-engine: `2863b3f` (V35.B.1 Achse 15)
- prt-art: `b6fac8f` (unveraendert seit V34)
- Diplomarbeit: `79d131b` + Stufe 03 uncommitted (`614b4fc` V35.B+C, `9c54143` V35.A.1 Pilot, `79d131b` V35.A.2 Option A)

---

## §1 V35.A — Pipeline-Module zu XX_operation/

### §1.1 Rename-Mapping (git mv)

| Vorher | Nachher |
|---|---|
| `Code/sample_data_generator/` | `Code/01_sample_data_generator/` |
| `Code/messung_driver/` | `Code/02_messung_driver/` |
| `Code/binary_to_csv/` | `Code/03_binary_to_csv/` |
| `Code/csv_to_latex/` | `Code/04_csv_to_latex/` |
| `Code/diagram_generator/` | `Code/05_diagram_generator/` |
| `Code/latex_to_pdf/` | `Code/06_latex_to_pdf/` |

### §1.2 Pfad-Korrekturen

- `Code/CMakeLists.txt` Zeilen 82-87: 6× `add_subdirectory()` neu zugeordnet
- `Code/tests/CMakeLists.txt`: 4× `${CMAKE_SOURCE_DIR}/messung_driver` → `02_messung_driver`
- 4 Test-CPPs (`test_dataset_filter.cpp`, `test_messreihe_*.cpp`, `test_v32_orchestrator.cpp`):
  `#include "../../messung_driver/..."` → `"../../02_messung_driver/..."`
- `Code/USAGE.md` §0 aktualisiert

### §1.3 Pro Modul NEU

- `README.md` mit Was/Warum/Wie/Pipeline-Position/Module-Inhalt/Fixtures-Hinweis
- `tests/fixtures/cached/.gitkeep` als Konventions-Skelett

### §1.4 Commits

- `9c54143` V35.A.1 Pilot (sample_data_generator)
- `79d131b` V35.A.2 Option A (5 verbleibende Module + READMEs + USAGE)

---

## §2 V35.B — Compiler-Achse 15

### §2.1 Sub-Achsen (cache-engine AxisLibraryRegistry V35.B.1)

| Sub | Name | Varianten |
|---|---|---|
| 15.1 | Compiler-Family | GCC, Clang, AppleClang, MSVC |
| 15.2 | Optimization-Level | O0..O3, Ofast, MSVC_Od/O1/O2 (8) |
| 15.3 | LTO-Mode | None, ThinLTO, FullLTO, MSVC_LTCG |
| 15.4 | PGO-Profile | None, Generate, Use, SamplePGO |
| 15.5 | Target-Arch | native, x86-64-v3, x86-64-v4, znver4, armv9-a, generic |

Total Achsen-Eintraege: 28 → 33.

### §2.2 Diplomarbeit-Integration (V35.B.2-B.5)

`02_messung_driver/hardware_filter.hpp`:
- NEU `enum class CompilerFamily { Unknown, GCC, Clang, AppleClang, MSVC }`
- NEU `HostCapabilities.compiler_family` + `detect_compile_time()` Erkennung
- NEU `struct CompilerRequest { family, opt_level, lto, pgo, target_arch }`
- NEU `compiler_family_name()` string conversion
- NEU `HardwareFilter::evaluate(CompilerRequest)` mit Skip-Logik fuer:
  - falsche Family
  - `x86-64-v4` ohne AVX-512
  - `armv9-a` ohne NEON
  - OptLevel/LTO/PGO sind Soft-Constraints (kein Skip)

XSD/XML:
- `messreihe_v32_schema.xsd`: NEU `<compiler_strategy>` Element (family enum + 4 strings)
- `messreihe_v32_schema_example.xml` tupel `t03_scan`: Clang+O3+ThinLTO+x86-64-v4

Tests:
- cache-engine `test_commands.cpp`: 2 NEU (`CompilerAxis15SubAxesPopulated`, `CompilerAxisLookupContent`)
- Diplomarbeit `test_dataset_filter.cpp`: 7 NEU (5 CompilerFilter + 1 CompilerFamilyName + 1 HostCapabilities.DetectsCompilerAtCompileTime)

### §2.3 Commits

- cache-engine `2863b3f` V35.B.1
- Diplomarbeit `614b4fc` V35.B.2-B.5 + V35.C.1 (zusammen)

---

## §3 V35.C — Build-Type-Independence

### §3.1 run_all_tests.sh + .bat Refactor

CLI + ENV-Support:
- `--config <Type>` CLI-Argument
- `BUILD_TYPE=<Type>` ENV-Variable
- Default: Autodetect-Reihenfolge `Release > Debug > RelWithDebInfo > MinSizeRel > <single-config>`
- Graceful fallback wenn Override nicht existiert (z.B. `--config Debug` → Release)

`resolve_test_exe()` Helper-Function (sh) + `:run_test_exe` Label (bat):
- Sucht in jeder moeglichen Verzeichnis-Variation
- Multi-config (MSVC): `<base>/Release/<test>.exe`
- Single-config (Ninja): `<base>/<test>.exe`

### §3.2 Bilanz-Anzeige

```
Build-Type: Release  (Override: <autodetect>)
passed: 76
failed: 0
```

`RESOLVED_BUILD_TYPE` wird aus dem ersten gefundenen Pfad abgeleitet.

---

## §4 V35.D — Pro-Stufe Tests mit gecachten Fixtures (IN-PROGRESS 1/4)

### §4.1 Konzept

Pro `XX_operation/` ein NEUES Test-Programm `test_NN_<modul>_cached_fixtures.cpp` das:

1. **Generator-as-Test** (`CachedFixturesExistOrAreGenerated`): Erzeugt Fixtures
   programmatisch in `tests/fixtures/cached/<name>` falls nicht existiert
2. **Consumer-Tests**: Lesen die Fixture + verarbeiten via Modul-API + verifizieren Output
3. **Pipeline-Step-Tests**: Vorgaenger-Output → Modul → Nachfolger-Input (Schema-Konsistenz)

Fixture-Path-Resolution: ENV-Variable `COMDARE_FIXTURES_DIR_NN` (via CMake `gtest_discover_tests
ENVIRONMENT` gesetzt), Fallback `current_path()/fixtures/cached`.

### §4.2 Stufe 03 (DONE)

**File:** `Code/03_binary_to_csv/tests/test_03_binary_to_csv_cached_fixtures.cpp`

**Fixtures generiert (cached, persistent):**
- `sample_3_records.bin` (400 B) — 3 Zipf-Workload Records (perm_zipf_0..2)
- `sample_failed.bin` (144 B) — 1 failed Record

**Tests (5/5 gruen):**
1. `CachedFixturesExistOrAreGenerated` (Generator)
2. `ReadCachedSample3Records` (Consumer 1)
3. `ReadFailedRunFixture` (Consumer 2)
4. `WriteCsvFromCachedFixture` (Pipeline-Step Stufe-04 input)
5. `FullPipelineThreeStepsBinaryToCsv` (3-Schritt-Pipeline + Schema-Check)

**CMake-Integration:** `03_binary_to_csv/CMakeLists.txt` mit
`gtest_discover_tests(... ENVIRONMENT "COMDARE_FIXTURES_DIR_03=...")`.

**Pfad-Bugfix Side-Effect:** `${COMDARE_CACHE_ENGINE_DIR}/cache_engine/include`
korrigiert auf `libs/cache_engine/include` (Pfad war seit V30 falsch).

### §4.3 Stufe 04/05/06 (PENDING, Kontext-Ende)

- **Stufe 04** (`04_csv_to_latex`): `test_04_csv_to_latex_cached_fixtures.cpp` GESCHRIEBEN aber noch nicht gebaut/getestet
  - 5 Tests: CachedCsvFixtureExists, ParseCachedCsv, WriteLatexFromCachedFixture,
    BausteinDescriptionFromPermutationId, EscapeLatexHandlesSpecialChars
- **Stufe 05** (`05_diagram_generator`): noch nicht begonnen
- **Stufe 06** (`06_latex_to_pdf`): noch nicht begonnen — evtl. ohne pdflatex-Build (minimal-LaTeX-Snippet)

---

## §5 Test-Bilanz Stand 2026-05-22 nach Stufe 03

```
cache-engine V32+V34+V35.B:  9 + 20 + 7      = 36
prt-art V33+V34:             5 + 10           = 15
Diplomarbeit V33+V34+V35.B+D: 7+6+16+5+5     = 39
                                              ─────
                                              90 gruen
```

V35.D fuegt +5 (Stufe 03), Stufe 04 +5, Stufe 05 vermutlich +4, Stufe 06 +3
= V35.D total ~17 Tests, projected 107 cross-repo nach Abschluss.

---

## §6 ZUSAETZLICHE USER-AUFGABEN (Restzeit V35 / V36)

User-Direktive 2026-05-22 (separate Liste, NICHT V35.D):

### §6.1 GoogleTest cachen

User-Wunsch: "Das clone mit cmake ist ja sehr hilfreich, aber langfristig ist
es gut, wenn die Kopie nicht ständig neu gedownloaded werden muss, sofern nicht
wirklich erforderlich."

Aktuell in `Code/CMakeLists.txt:63`:
```cmake
set(_gtest_local "${COMDARE_CACHE_ENGINE_DIR}/cmake/third_party/googletest-1.15.2.tar.gz")
if(EXISTS "${_gtest_local}")
    FetchContent_Declare(googletest URL "${_gtest_local}")
else()
    FetchContent_Declare(... URL https://github.com/...)
endif()
```

Verbesserung: zusaetzlicher Cache unter `~/.cache/comdare/` oder via
`FETCHCONTENT_BASE_DIR` ENV-variable damit auch ohne cache-engine-Submodule
der Tarball lokal bleibt. Pfad-Reihenfolge:
1. CLI/ENV `COMDARE_GTEST_CACHE`
2. `~/.cache/comdare/googletest-1.15.2.tar.gz`
3. cache-engine-Submodule (wenn vorhanden)
4. GitHub Download

### §6.2 tools/ verschieben

User-Hinweis: "Weiterhin haben sich hierhin tools verirrt, die vermutlich besser
Teil des Codes sein sollten, bitte verschieben: C:\Users\benja\OneDrive\Desktop\Diplomarbeit - Datenbanken\tools"

Aktion: `git mv tools/ Code/tools/`. Anpassung:
- `tools/run_all_tests.sh` + `.bat`: `REPO_ROOT="$SCRIPT_DIR/.."` → `"$SCRIPT_DIR/../.."`
- Build-Pfade evtl. ueberpruefen

### §6.3 CLion-Setup mit weniger Warnings + JetBrains/VS-Test-Umgebung

CLion-Aufruf: `cmake -G Ninja -DCMAKE_BUILD_TYPE=Debug` ohne `-DCOMDARE_V32_ENABLE=ON`.
Warnings aus `external/comdare-cache-engine/cmake/check_submodules.cmake`:
- "Fehlende COMDARE-Submodules: modules/comdare-search-engine, ..."
- 7 Submodules werden geprueft, alle nicht vorhanden (Cluster-Migration pending)

Loesung:
1. Im cache-engine eine Option `COMDARE_QUIET_SUBMODULE_CHECK` (default OFF) ergaenzen
2. Im Diplomarbeit `CMakeLists.txt` VOR `add_subdirectory(external/comdare-cache-engine)`
   diese Option setzen: `set(COMDARE_QUIET_SUBMODULE_CHECK ON)`
3. Alternativ ein `CMakePresets.json`-Preset `clion-debug` mit allen Defaults
   (COMDARE_V32_ENABLE=ON + COMDARE_QUIET_SUBMODULE_CHECK=ON + Debug)

Plus: VS-Code + JetBrains kompatible Test-Umgebung — `.vscode/launch.json` + CLion
Run-Configuration als Sample.

---

## §7 KRITISCHE PFAD-VERBESSERUNG (V35.D Side-Effect)

`Code/03_binary_to_csv/CMakeLists.txt` Zeile 10:
- **VORHER:** `${COMDARE_CACHE_ENGINE_DIR}/cache_engine/include`
- **NACHHER:** `${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine/include`

Pfad war seit V30 (libs/-Migration) falsch — funktionierte aber nur weil die
zentralen tests/ die richtigen Pfade benutzten. Beim Standalone-Build von
`03_binary_to_csv` wurde der Fehler sichtbar.

**Empfehlung:** analog in 04/05/06 pruefen wenn sie Standalone gebaut werden.

---

## §8 NACH KONTEXT-WIEDERAUFNAHME — KONKRETE NAECHSTE SCHRITTE

1. **V35.D Stufe 04** — `04_csv_to_latex/tests/test_04_csv_to_latex_cached_fixtures.cpp`
   - File ist BEREITS GESCHRIEBEN (siehe §4.3), aber noch nicht in `CMakeLists.txt` eingehaengt
   - Folge: `add_executable` Block in `04_csv_to_latex/CMakeLists.txt` + Build + Run
2. **V35.D Stufe 05** — `test_05_diagram_generator_cached_fixtures.cpp`
   - Erzeugt CSV-Fixture mit `workload_used`-Spalte (16 Spalten)
   - Tests: `load_csv_with_workload_used`, `write_bar_chart`, `write_scatter_plot`,
     `write_heatmap`, `write_throughput_by_workload`
3. **V35.D Stufe 06** — `test_06_latex_to_pdf_cached_fixtures.cpp`
   - Fixture: minimal_main.tex + 1 TikZ + 1 Tabelle
   - Pdf-Build evtl. SKIPPED wenn pdflatex nicht da (Test-Helper-Skript existiert vermutlich)
4. **run_all_tests.sh** erweitern um 4 neue Tests (test_03..06_*_cached_fixtures)
5. **§6.1 GoogleTest-Cache** (kleine CMakeLists-Aenderung)
6. **§6.2 tools/ -> Code/tools/** + Pfad-Korrekturen
7. **§6.3 check_submodules Warnings unterdruecken** (cache-engine + Diplomarbeit-Side)

---

## §9 Querverweise

- Vorgaenger: `20260521-5200-V33-autonomous-sprint-12-todos-komplett.md`
- V33-final-Tag: alle 3 Repos (cache-engine: `fe0a864`, prt-art: `7f3b62c`, Diplomarbeit: `4a7edb7`)
- V34-final-Tag: alle 3 Repos (cache-engine: `bb8541b`, prt-art: `15c5697`, Diplomarbeit: `ae3d249`)
- Memory neu (5 Files): feedback_thesis_divide_and_conquer, feedback_no_hardcoded_build_config,
  project_compiler_axis_v35, feedback_user_manual_workflow, project_cluster_paused_until_monday

---

**Ende docs/sessions/20260522-5300-V35-sprint-pipeline-restructure-compiler-axis.md.**
