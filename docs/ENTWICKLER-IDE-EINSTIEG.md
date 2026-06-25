# Entwickler-Einstieg: Projekt in VS Code UND CLion öffnen, ausführen, debuggen

> **Zweck.** Diese Datei schließt die in den READMEs offene Lücke: **(a)** wie man das
> Super-Projekt in **VS Code** *und* **CLion** öffnet und konfiguriert, **(b)** wie man pro
> Hauptprogramm einen **Debug-/Run-Einstiegspunkt** einrichtet, **(c)** welche **Programm-
> Argumente** die Hauptprogramme erwarten. Alle Argumente unten sind aus dem **echten
> `argv`-Parsing** der jeweiligen `main()` abgeleitet (Datei + Zeile sind genannt), nicht
> erfunden.
>
> **Plattform-Hinweis.** Befehle sind für Windows/PowerShell *und* bash/Linux angegeben.
> Auf Windows ist der Default-Generator `Visual Studio 17 2022` (MSVC); auf Linux/CLion
> typischerweise Ninja + gcc/clang.

---

## 0. Projekt- und Submodul-Übersicht

Wurzel: `C:\Users\benja\OneDrive\Desktop\Diplomarbeit - Datenbanken`

```
Diplomarbeit - Datenbanken/            ← Super-Projekt (Git-Repo, .gitmodules)
├── Code/                              ← C++23 Anwender-Schicht (HIER liegt CMakePresets.json)
│   ├── CMakeLists.txt                 ← Top-Level der baubaren Software
│   ├── CMakePresets.json             ← 11 Presets (msvc-*, ninja-mingw-*, gcc/clang)
│   ├── 01_sample_data_generator/     → Executable  sample_data_generator
│   ├── 02_messung_driver/            → Executable  comdare-messung-driver  (Haupt-Orchestrator)
│   ├── 03_binary_to_csv/             → Executable  binary-to-csv
│   ├── 04_csv_to_latex/              → Executable  csv-to-latex
│   ├── 05_diagram_generator/         → Executable  diagram-generator
│   ├── 06_latex_to_pdf/              → KEIN Executable (CMake/Skript: build_thesis.sh/.bat)
│   └── external/
│       ├── comdare-cache-engine/     ← Submodul: Werkzeug-Bibliothek + apps/ (CacheEngineBuilder, perm_runner …)
│       └── comdare-prt-art/          ← Submodul: Prüfling PRT-ART (Bibliothek, KEIN eigenes App-Executable)
└── thesis/
    └── diplomarbeit/                 ← Submodul: LaTeX-Quelle (Overleaf), kein C++-Build
```

**Wichtig zur Auswahl des Wurzelverzeichnisses in der IDE:**
Die **baubare Software** hat ihre `CMakeLists.txt` / `CMakePresets.json` in **`Code/`** — *nicht*
in der Repo-Wurzel. Öffne in der IDE daher **den Ordner `Code/`** (nicht die Super-Repo-Wurzel),
sonst findet die IDE kein CMake-Projekt. Die Super-Repo-Wurzel ist nur die Git-/Submodul-/
Dokument-Klammer.

**Submodule zuerst initialisieren** (einmalig, sonst bricht CMake mit `FATAL_ERROR: ... Submodule
nicht initialisiert` ab — siehe `Code/CMakeLists.txt`):

```bash
cd "Diplomarbeit - Datenbanken"
git submodule update --init --recursive
```

---

## 1. Toolchain-Voraussetzungen

| Anforderung | Wert | Quelle |
|---|---|---|
| C++-Standard | **C++23 erzwungen** | `Code/CMakeLists.txt` (`CMAKE_CXX_STANDARD 23`, `CMAKE_CXX_EXTENSIONS OFF`) |
| CMake | **≥ 3.28** | `Code/CMakeLists.txt`, `Code/CMakePresets.json` |
| MSVC | ≥ 19.34 (VS 2022 17.4) | `Code/CMakeLists.txt` (FATAL_ERROR-Guard) |
| gcc | ≥ 13.0 | dito |
| clang | ≥ 16.0 | dito |
| Apple-Clang | ≥ 15.0 | dito |
| optional | `ccache`/`sccache` (Vendor-Lib-Cache), `pdflatex` (Stufe 06) | `Code/CMakeLists.txt` |

Die `06_latex_to_pdf`-Stufe braucht zusätzlich **`pdflatex`** (+ `bibtex`); ohne pdflatex laufen
01–05, nur die finale PDF-Erzeugung wird übersprungen.

---

## 2. CMake-Presets (für beide IDEs identisch)

Aus `Code/CMakePresets.json` (Version 6). Auszug der wichtigsten:

| Preset | Generator | Build-Typ | Empfohlen für |
|---|---|---|---|
| `msvc-debug` | Visual Studio 17 2022 (x64) | Debug | **VS Code / Windows-Debugging (Default)** |
| `msvc-release` | Visual Studio 17 2022 (x64) | Release | Voll-Build der Permutationen |
| `msvc-relwithdebinfo` | Visual Studio 17 2022 (x64) | RelWithDebInfo | Profiling mit Debug-Info |
| `ninja-mingw-debug` | Ninja + MinGW | Debug | **CLion-Default (Windows)** |
| `ninja-mingw-release` | Ninja + MinGW | Release | CLion Performance |
| `gcc-release` | Unix Makefiles + gcc | Release | Linux-Cluster |
| `ninja-gcc-release` | Ninja + gcc | Release | Linux schnellster Build |
| `clang-release` | Unix Makefiles + clang | Release | Linux/clang |

Der **Binary-Ausgabeordner** ist (laut `_base`-Preset) `Code/build/<presetName>/`, z. B.
`Code/build/msvc-debug/`. Bei Multi-Config-Generatoren (MSVC) liegen die `.exe` zusätzlich in
einem Konfig-Unterordner (`.../Debug/`, `.../Release/`).

Konfigurieren + bauen auf der Kommandozeile:

```bash
cd Code
cmake --preset msvc-debug            # bzw. ninja-mingw-debug / gcc-release
cmake --build --preset msvc-debug
```

---

## 3. Die Hauptprogramme: Einstiegspunkte, Targets, exakte Argumente

> Spalte **„Output-Name"** = der tatsächliche `.exe`-Name (aus `set_target_properties(... OUTPUT_NAME ...)`).
> Spalte **„CMake-Target"** = der Name, den du in der IDE als Run/Debug-Ziel auswählst.

### 3.1 Diplomarbeit/Code — die 6-stufige Pipeline

| # | CMake-Target | Output-Name (.exe) | `main()`-Quelle | Pflicht-Argumente | Optionale Argumente |
|---|---|---|---|---|---|
| 02 | `messung_driver` | `comdare-messung-driver` | `Code/02_messung_driver/main.cpp` | `<config_dir> <output_dir>` | `--comdare-root=DIR` `--messreihen-xml=FILE` |
| 01 | `sample_data_generator` | `sample_data_generator` | `Code/01_sample_data_generator/sample_data_generator.cpp` | `<output_csv_path>` | – |
| 03 | `binary_to_csv_cli` | `binary-to-csv` | `Code/03_binary_to_csv/main_cli.cpp` | `<input.bin> <output.csv>` | – |
| 04 | `csv_to_latex_cli` | `csv-to-latex` | `Code/04_csv_to_latex/main_cli.cpp` | `<input.csv> <output.tex>` | `--caption=<text>` `--label=<text>` `--lang=de\|en` `--schema=legacy\|wide` + Sondermodi (s. u.) |
| 05 | `diagram_generator_cli` | `diagram-generator` | `Code/05_diagram_generator/main_cli.cpp` | `<input.csv> <output.tex>` | `--lang=de\|en` `--body-only` + Subkommandos (s. u.) |
| 06 | *(kein C++-Exe)* | `build_thesis.sh` / `.bat` | `Code/06_latex_to_pdf/CMakeLists.txt` | siehe §3.3 | – |

**Belegte Argument-Details (aus dem echten Parsing):**

- **02 `comdare-messung-driver`** — `main.cpp:211` `if (argc < 3) { print_usage(); return 1; }`.
  `argv[1]`=`config_dir`, `argv[2]`=`output_dir` (`main.cpp:413–414`). Ab `argv[3]` Schleife
  (`main.cpp:418`): `--comdare-root=` (Offset 15) und `--messreihen-xml=` (Offset 17); jedes andere
  Argument → `Unknown arg` + Exit 1.
  Erwartete Dateien in `<config_dir>` (aus `print_usage`, `main.cpp:154`):
  `cache_engine_permutations.xml`, `search_algorithm_permutations.xml`, `allocator_permutations.xml`,
  `test_data_sets.xml`, optional `messreihen.xml`.
  Ausgabe: `<output_dir>/{A_PRT_ART_vs_SOTA,B_CacheEngine_Perms,C_Merge_Alt_Neu}/measurements.{csv,json}`.
  Exit-Codes: `1`=Usage, `2`=keine Permutationen vorhanden (`assert_permutations_available_or_die`,
  `main.cpp:216`). Das Programm sucht zur Laufzeit eine `perm/`-Wurzel ausgehend vom **Arbeits-
  verzeichnis** nach oben (`main.cpp:238–244`) → **Working-Directory korrekt setzen** (s. §4/§5).

- **01 `sample_data_generator`** — `sample_data_generator.cpp:47` `int main(int argc, char** argv)`,
  `:48` `if (argc < 2)` → Usage `sample_data_generator <output_csv_path>`. Genau **1 Argument**: der
  Ziel-CSV-Pfad. Erzeugt eine 16-Spalten-Demo-CSV (lauffähig ohne gebaute DLLs) — ideal als erstes
  Debug-Ziel zum „Pipeline-Durchstechen".

- **03 `binary-to-csv`** — `main_cli.cpp:11–15`, `if (argc < 3)` → `binary-to-csv <input.bin> <output.csv>`.
  Exakt 2 Pflicht-Argumente; kein Flag-Parsing.

- **04 `csv-to-latex`** — `main_cli.cpp:9`. Basismodus: `<input.csv> <output.tex>` (`argc<3` → Usage,
  `:94`). Ab `argv[3]` (`:109`): `--caption=` (Offset 10), `--label=` (Offset 8), `--lang=` (Offset 7,
  Default `en`), `--schema=` (Offset 9, `legacy`|`wide`). **Sondermodi VOR der Arity-Prüfung**
  (`:13–91`): `--exchange=<csv> <outdir> [--lang]`, `--limitierung <out.tex> [--lang]`,
  `--sota-series=<csv> <out.tex>`, `--sweep-axis=<csv> <out.tex>`, `--seg-coverage=<csv> <out.tex>`.

- **05 `diagram-generator`** — `main_cli.cpp:15`. Basismodus: `<input.csv> <output.tex>` (`argc<3` →
  Usage, `:103`) mit `--lang=de|en`, `--body-only` (`:122–126`). Subkommandos (jeweils
  `argc>=4`, geprüft auf `argv[1]`): `--by-workload <input.csv> <output.tex>` (`:87`),
  `--surface=<z_field> <wide.csv> <out.tex> [--lang][--3d][--body-only]` (`:22`),
  `--sweep-curve=<z_field> <wide.csv> <out.tex> [--lang][--body-only]` (`:60`).
  Gültige `z_field`: `ns_per_op|op_insert_p50_ns|op_lookup_p50_ns|op_erase_p50_ns|op_scan_p50_ns|op_rmw_p50_ns`.

- **06 `latex_to_pdf`** — **kein C++-Programm.** `Code/06_latex_to_pdf/CMakeLists.txt` kopiert
  `latex_toolchain.cmake` + `build_thesis.sh`/`build_thesis.bat` in den Build-Ordner. Direktaufruf:
  ```bash
  cmake -DCOMDARE_THESIS_SOURCE=<dir> -DCOMDARE_THESIS_OUTPUT=<dir> -P latex_toolchain.cmake
  ```

**Komfort-Target für einen geschlossenen Demo-Durchlauf:** `comdare_pipeline_e2e`
(`Code/CMakeLists.txt:328`) treibt EINEN Datensatz 01 → 04 → 05 → 06 durch (ohne gebaute Permutations-DLLs
lauffähig). Aufruf: `cmake --build --preset msvc-debug --target comdare_pipeline_e2e`.

### 3.2 cache-engine-Submodul — eigene Programme unter `apps/`

Die cache-engine bringt eigene Executables mit (Werkzeug-Schicht). Diese baut man, indem man **`Code/`**
konfiguriert (das Submodul wird via `add_subdirectory` eingebunden) ODER das **cache-engine-Repo
eigenständig** öffnet (`Code/external/comdare-cache-engine/CMakePresets.json` → Presets `msvc-debug`,
`msvc-release`, `gcc-release`, `clang-release`).

| CMake-Target | Output-Name (.exe) | `main()`-Quelle | Pflicht-Argumente | Optionale Argumente |
|---|---|---|---|---|
| `cache_engine_builder` | `comdare-cache-engine-builder` | `apps/cache_engine_builder/main.cpp` | `<config_dir> <output_dir>` | `--enumerate-only` `--comdare-root=DIR` `--skip-build` `--quiet` |
| `comdare_perm_runner` | `perm_runner` | `apps/perm_runner/main.cpp` | `<perm.dll>` | `[binary_id]` `[n_ops]` (Default: binary_id=DLL-Pfad, n_ops=1000) |
| `comdare_adhoc_emitter_cli` | `comdare_adhoc_emitter_cli` | `apps/adhoc_emitter/main.cpp` | (Codegen-Tool, Configure-Time) | – |
| `comdare_anatomy_codegen_cli` | `comdare_anatomy_codegen_cli` | `apps/anatomy_codegen_tool/main.cpp` | (Codegen-Tool) | – |
| `comdare_f15_compare_cli` | `comdare_f15_compare_cli` | `apps/f15_compare/main.cpp` | (Auswertungs-Tool) | – |
| `is_original_validator` | `is_original_validator` | `apps/is_original_validator/main.cpp` | (Validator) | – |

**Belegte Argument-Details:**

- **`comdare-cache-engine-builder`** — `main.cpp:65–66` `if (argc < 3) { print_usage(); return 1; }`.
  `argv[1]`=`config_dir`, `argv[2]`=`output_dir` (`:69–70`). Ab `argv[3]` (`:74`): `--enumerate-only`,
  `--skip-build`, `--quiet`, `--comdare-root=` (Offset 15); jedes andere → `Unknown option` + Exit 1.
  Erwartet im `config_dir` dieselben 4 XML-Configs wie der messung_driver (`:46–51`). Dies ist der
  **cache-engine-Demo-Treiber**; der echte 3-Reihen-Orchestrator ist `comdare-messung-driver` (s. 3.1).
- **`perm_runner`** — `main.cpp:24` `if (argc < 2) { ... usage: perm_runner <perm.dll> [binary_id] [n_ops] ... return 2; }`.
  `argv[1]`=Pfad zur Permutations-DLL; `argv[2]`=`binary_id` (optional, Default = DLL-Pfad, `:26`);
  `argv[3]`=`n_ops` (optional, `std::strtoull`, Default 1000, `:27`). Lädt EINE DLL, treibt den Mess-Workload,
  schreibt EINE `result_ingest`-Zeile nach stdout. Exit `2`=Usage, `1`=Lade-/Mess-Fehler.

**PRT-ART (`Code/external/comdare-prt-art`)** liefert **kein eigenes Anwendungs-Executable** — es ist eine
Bibliothek/ein Prüfling, der (a) von der cache-engine als Permutations-Quelle eingebunden wird und (b) als
PRT-ART-Permutations-DLLs gebaut wird. Im Submodul existieren nur Test-Executables
(`tests/unit/CMakeLists.txt`, z. B. `test_default_lookup_registry`). Debuggen von PRT-ART-Verhalten erfolgt
daher über `perm_runner <prt-art-perm.dll>` oder über die `messung_driver`-Messreihe **A**.

### 3.3 Build-Reihenfolge / Daten-Fluss (für sinnvolle Debug-Ziele)

```
sample_data_generator  ──►  (Demo-CSV)
                                 └─► csv-to-latex / diagram-generator   (ohne echte Messung testbar)

comdare-messung-driver ──► measurements/*.bin ──► binary-to-csv ──► *.csv
                                                                       ├─► csv-to-latex   ──► *.tex
                                                                       └─► diagram-generator ──► *.tex
                                                                                                   └─► latex_to_pdf (06)
```
Detaillierter Abhängigkeitsbaum: `docs/TEILPROGRAMM-ABHAENGIGKEITSBAUM.md`.
Schritt-für-Schritt-Messanleitung: `docs/anleitung_messwerte_erzeugen.md`.

---

## 4. VS Code öffnen + konfigurieren + debuggen

### 4.1 Extensions
- **CMake Tools** (`ms-vscode.cmake-tools`) — Konfigurieren/Bauen/Presets.
- **C/C++** (`ms-vscode.cpptools`) — Debugger (`cppvsdbg` für MSVC, `cppdbg`/gdb für MinGW/Linux).

### 4.2 Ordner öffnen + Preset wählen
1. **Datei → Ordner öffnen → `…\Diplomarbeit - Datenbanken\Code`** (den `Code`-Ordner, nicht die Repo-Wurzel).
2. CMake Tools erkennt `CMakePresets.json`. Über die Statusleiste (oder `CMake: Select Configure Preset`)
   z. B. **`msvc-debug`** wählen.
3. `CMake: Configure`, dann `CMake: Build` (oder Target-spezifisch über `CMake: Set Build Target`).
   Beim ersten Konfigurieren müssen die Submodule initialisiert sein (§0).

### 4.3 `launch.json` — konkrete Debug-Konfigurationen
Lege **`Code/.vscode/launch.json`** an (der Ordner existiert noch nicht). `${command:cmake.buildDirectory}`
löst auf den Preset-Build-Ordner auf (`Code/build/<preset>`); bei MSVC liegt die `.exe` im Konfig-Unterordner
`Debug/`. Working-Directory bewusst auf den Build-Ordner gesetzt, damit der `messung_driver` die `perm/`-Wurzel
findet (§3.1).

```jsonc
{
  "version": "0.2.0",
  "configurations": [
    {
      // Haupt-Orchestrator (Messreihen A/B/C). Argumente = <config_dir> <output_dir>.
      "name": "Debug messung_driver (MSVC)",
      "type": "cppvsdbg",
      "request": "launch",
      "program": "${command:cmake.buildDirectory}/02_messung_driver/Debug/comdare-messung-driver.exe",
      "args": [
        "${workspaceFolder}/02_messung_driver/config",
        "${command:cmake.buildDirectory}/messung_out",
        "--comdare-root=${command:cmake.buildDirectory}"
      ],
      "cwd": "${command:cmake.buildDirectory}",
      "console": "integratedTerminal",
      "preLaunchTask": ""
    },
    {
      // Schnellster „läuft-überhaupt"-Smoke: nur 1 Argument (Ausgabe-CSV).
      "name": "Debug sample_data_generator (MSVC)",
      "type": "cppvsdbg",
      "request": "launch",
      "program": "${command:cmake.buildDirectory}/01_sample_data_generator/Debug/sample_data_generator.exe",
      "args": [ "${command:cmake.buildDirectory}/demo_measurements.csv" ],
      "cwd": "${command:cmake.buildDirectory}",
      "console": "integratedTerminal"
    },
    {
      // CSV -> LaTeX (wide-Schema). args: <input.csv> <output.tex> [flags].
      "name": "Debug csv-to-latex (MSVC)",
      "type": "cppvsdbg",
      "request": "launch",
      "program": "${command:cmake.buildDirectory}/04_csv_to_latex/Debug/csv-to-latex.exe",
      "args": [
        "${command:cmake.buildDirectory}/demo_measurements.csv",
        "${command:cmake.buildDirectory}/table.tex",
        "--lang=de",
        "--schema=wide"
      ],
      "cwd": "${command:cmake.buildDirectory}",
      "console": "integratedTerminal"
    },
    {
      // cache-engine: EINE Permutations-DLL messen. args: <perm.dll> [binary_id] [n_ops].
      "name": "Debug perm_runner (MSVC)",
      "type": "cppvsdbg",
      "request": "launch",
      "program": "${command:cmake.buildDirectory}/_cache_engine_external/apps/perm_runner/Debug/perm_runner.exe",
      "args": [
        "${command:cmake.buildDirectory}/perm/cache_engine/<PERM_ID>.dll",
        "demo_binary",
        "2000"
      ],
      "cwd": "${command:cmake.buildDirectory}",
      "console": "integratedTerminal"
    }
  ]
}
```

> **MinGW/Linux statt MSVC:** `"type"` auf `"cppdbg"` setzen, `"MIMode": "gdb"` ergänzen, im
> `program`-Pfad den `Debug/`-Konfig-Unterordner weglassen (Ninja/Makefiles sind Single-Config) und
> `.exe` unter Linux weglassen, z. B.
> `"${command:cmake.buildDirectory}/02_messung_driver/comdare-messung-driver"`.

> **Pfad-Hinweis:** Die exakten Binary-Pfade unter `build/<preset>/…` einmal mit dem Datei-Explorer der
> IDE verifizieren — bei Ninja entfällt der `Debug/`-Zwischenordner; bei MSVC ist er vorhanden.

---

## 5. CLion öffnen + konfigurieren + debuggen

### 5.1 Öffnen
- **File → Open → `…\Diplomarbeit - Datenbanken\Code`** (den `Code`-Ordner). CLion findet
  `Code/CMakeLists.txt` + `CMakePresets.json` automatisch.
- Beim ersten Öffnen Submodule initialisieren (§0), sonst meldet CMake `FATAL_ERROR` (Submodul fehlt).

### 5.2 CMake-Profil aus Preset
- **Settings/Preferences → Build, Execution, Deployment → CMake.**
- **„+ → From CMakePresets"** und z. B. **`ninja-mingw-debug`** (Windows/CLion-Default) oder
  **`msvc-debug`** (CLion mit Visual-Studio-Toolchain) bzw. **`gcc-release`** (Linux) übernehmen.
- CLion legt das Build-Verzeichnis gemäß Preset auf `Code/build/<preset>` an.

### 5.3 Run/Debug-Konfiguration je Hauptprogramm
CLion erzeugt für jedes `add_executable` automatisch eine **CMake Application**-Konfiguration (Name =
CMake-Target, **nicht** Output-Name). Für jedes Hauptprogramm:

1. **Run → Edit Configurations… → CMake Application →** Target wählen (z. B. `messung_driver`,
   `sample_data_generator`, `csv_to_latex_cli`, `diagram_generator_cli`, `binary_to_csv_cli`,
   `cache_engine_builder`, `comdare_perm_runner`).
2. **Program arguments** setzen (exakt wie in §3):

   | Target | Program arguments (Beispiel) | Working directory |
   |---|---|---|
   | `messung_driver` | `config measurements_out --comdare-root=.` | `$CMakeCurrentBuildDir$` (Build-Ordner; enthält `perm/`) |
   | `sample_data_generator` | `demo_measurements.csv` | `$CMakeCurrentBuildDir$` |
   | `binary_to_csv_cli` | `measurements/all_permutations.bin out.csv` | `$CMakeCurrentBuildDir$` |
   | `csv_to_latex_cli` | `demo_measurements.csv table.tex --lang=de --schema=wide` | `$CMakeCurrentBuildDir$` |
   | `diagram_generator_cli` | `--by-workload demo_measurements.csv diagram.tex` | `$CMakeCurrentBuildDir$` |
   | `cache_engine_builder` | `config builder_out --quiet` | `$CMakeCurrentBuildDir$` |
   | `comdare_perm_runner` | `perm/cache_engine/<PERM_ID>.dll demo_binary 2000` | `$CMakeCurrentBuildDir$` |

3. **Working directory:** unbedingt auf den **Build-Ordner** setzen (Makro `$CMakeCurrentBuildDir$`),
   weil `comdare-messung-driver` und `perm_runner` relative `perm/`-/`measurements/`-Pfade ab dem
   Arbeitsverzeichnis auflösen (§3.1).
4. **Debuggen:** Breakpoint setzen, dann **Debug (Umschalt+F9)**. CLion baut das Target vorab automatisch
   (CMake-Application-Konfigurationen haben „Build" als Before-launch-Step).

### 5.4 Nur ein Submodul-Tool debuggen
Die cache-engine-Targets (`cache_engine_builder`, `comdare_perm_runner`, …) erscheinen in CLion **nur**,
wenn `Code/` als Projekt offen ist (Submodul via `add_subdirectory`) **oder** wenn man stattdessen
`Code/external/comdare-cache-engine/` direkt als CLion-Projekt öffnet (eigene `CMakePresets.json` mit
`msvc-debug`/`gcc-release`).

---

## 6. Schnell-Checkliste „läuft + debuggt"

1. `git submodule update --init --recursive` (Repo-Wurzel).
2. IDE öffnet **`Code/`** (nicht die Super-Repo-Wurzel).
3. Preset wählen: VS Code `msvc-debug`, CLion `ninja-mingw-debug` (Win) / `gcc-release` (Linux).
4. Konfigurieren + bauen (mind. `sample_data_generator` als Smoke-Target).
5. Debug-Ziel **`sample_data_generator`** mit Argument `demo_measurements.csv` → bestätigt End-to-End-Debugbarkeit
   ohne gebaute Permutations-DLLs.
6. Danach **`messung_driver`** mit `<config_dir> <output_dir>` und Working-Dir = Build-Ordner
   (für die `perm/`-Auflösung).

---

*Belege:* Alle Argument-Angaben stammen aus dem realen `argv`-Parsing der genannten `main()`-Dateien
(`Code/0{1..5}_*/…`, `Code/external/comdare-cache-engine/apps/{cache_engine_builder,perm_runner}/main.cpp`),
den `add_executable`/`OUTPUT_NAME`-Einträgen der jeweiligen `CMakeLists.txt` sowie `Code/CMakePresets.json`
und `Code/external/comdare-cache-engine/CMakePresets.json`.
