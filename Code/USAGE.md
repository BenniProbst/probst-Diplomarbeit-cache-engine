# Diplomarbeit/Code — Stack-Anleitung (REV 7.6 + V8-V11 Updates)

> ⚠️ **TEILS VERALTET (2026-06-27, Codex-Befund):** einzelne Targets/Exe-Namen/CLI-Argumente unten sind stale. **Für den manuellen Self-Test ist `Code/MANUAL_RUN.md` autoritativ** (verifizierter Hand-Flow; Task #193). Abweichungen bitte dort pflegen.

Diese Anleitung beschreibt die **vollstaendige Befehlskette** vom frischen
Klonen des Repos bis zum fertigen PDF mit eingebetteten LaTeX-Tabellen
und TikZ-Diagrammen. Sie ist explizit als Schritt-fuer-Schritt-Skript
geschrieben, damit der Stand jederzeit reproduzierbar ist.

> Wichtig: **NO Python in der Build-Pipeline** (F-EXTRA-5). Alle Tools
> sind CMake + sh + bat + C++23. Python ist nur dann erlaubt, wenn der
> User es ausserhalb der Pipeline manuell aufruft.

---

## 0. Bestandteile des Stacks

```
Diplomarbeit/Code/                    ← Anwender-Schicht (WAS)
├── CMakeLists.txt                    Top-Level cmake, C++23, FetchContent gtest
├── external/
│   ├── comdare-prt-art/              Submodule (Pruefling, REV 7.1)
│   └── comdare-cache-engine/         Submodule (WIE-Library, REV 7.6)
├── experiment_config/
│   ├── config_a_prt_art_vs_sota.xml      Messreihe A
│   ├── config_b_cache_engine_perms.xml   Messreihe B
│   └── config_c_merge_alt_neu.xml        Messreihe C
├── 01_sample_data_generator/         Helper: synthetische CSV (Test-Daten)
├── 02_messung_driver/                V32Orchestrator + HardwareFilter + Validator + Exporter
├── 03_binary_to_csv/                 binary records → CSV (kBinaryMagic 0xC0FFEE02)
├── 04_csv_to_latex/                  CSV → LaTeX-Tabelle + Baustein-Steckbrief
├── 05_diagram_generator/             CSV → TikZ Bar/Scatter/Heatmap (A4-aware)
├── 06_latex_to_pdf/                  Wrapper um cache-engine latex_toolchain
└── tests/                            GoogleTest-Suite (Mess-Driver + Pipeline)
```

**V35.A.2:** Pipeline-Module folgen jetzt der `XX_operation/`-Konvention mit
zweistelliger Index-Praefix. Jedes Modul hat eine eigene `README.md` + ein
`tests/fixtures/cached/` Skelett (Konventions-Disziplin "Teile und Herrsche").
Pro Modul sind die Eingangs-Fixtures der Vorgaenger-Stufe gecacht damit
isolierte Schritt-Tests moeglich sind (User-Direktive 2026-05-22).

**Pflicht-Tools auf dem Host:**

| Tool | Mindest-Version | Wofuer |
|------|-----------------|--------|
| CMake | 3.28 | Top-Level Generator |
| MSVC (Win) oder GCC/Clang (Linux) | C++23 | Sources |
| pdflatex (TeX Live / MiKTeX) | 2022+ | latex_to_pdf |
| Git | 2.30+ | Submodules |
| ctest | (bundled) | Tests |

Optional: `git lfs` (nur falls grosse Binaries committet werden — derzeit nein).

---

## 1. Klonen + Submodule init

```sh
git clone https://github.com/BenniProbst/probst-Diplomarbeit-cache-engine.git
cd probst-Diplomarbeit-cache-engine/Code
git submodule update --init --recursive
```

Auf Windows mit PowerShell:

```powershell
git clone https://github.com/BenniProbst/probst-Diplomarbeit-cache-engine.git
cd .\probst-Diplomarbeit-cache-engine\Code
git submodule update --init --recursive
```

Verifikation: `external/comdare-prt-art/CMakeLists.txt` und
`external/comdare-cache-engine/CMakeLists.txt` muessen existieren.

---

## 2. cmake configure (Top-Level)

```sh
cmake -B build -G "Visual Studio 17 2022"   # Windows MSVC
cmake -B build -G "Ninja"                   # Linux/macOS
```

Erwartete Status-Ausgabe (Tail):

```
-- comdare-diplomarbeit-code 0.1.0
--   C++ Standard         : 23
--   prt-art Submodule    : .../external/comdare-prt-art
--   cache-engine Submod. : .../external/comdare-cache-engine
--   Build Tests          : ON
```

Wenn cmake nach googletest fragt: das CMake-Skript faellt auf
`FetchContent` zurueck, falls keine lokale Tar-Archive existieren.

---

## 3. Build der Tools (cache-engine-Library + Code-Module)

```sh
# Alles auf einmal
cmake --build build --config Debug --target ALL_BUILD          # Windows
cmake --build build --target all                                # Linux/macOS

# Oder gezielt:
cmake --build build --config Debug --target comdare-messung-driver
cmake --build build --config Debug --target comdare-binary-to-csv
cmake --build build --config Debug --target comdare-csv-to-latex
cmake --build build --config Debug --target comdare-diagram-generator
```

Die cache-engine-Library `comdare_builder_experiment_driver` wird
automatisch als Sub-Target gebaut.

---

## 4. Tests (ctest + GoogleTest)

```sh
ctest --test-dir build --output-on-failure
```

Erwartet: alle Unit-Tests gruen. Die GoogleTest-Suite fuer den
Mess-Driver liegt unter `tests/unit/test_messung_driver.cpp` und deckt
ab:

- XML-Config-Parse (3 Messreihen)
- Pro-Phase-Dispatch (Phase 1 enumerate, Phase 2 codegen, Phase 3 compile
  via `--skip-build` Mock, Phase 4 load mit Mock-DLLs, Phase 7 export)
- End-to-End: `--enumerate-only` ueber alle 3 Messreihen
- Fehlerpfade: ungueltige XML, fehlendes Output-Verzeichnis

---

## 5. Pipeline-Lauf (Phase 1 → 7, alle 3 Messreihen)

### 5.1 Klassischer 3-Reihen-Modus (V8 Default)

```sh
build/Debug/messung_driver/comdare-messung-driver.exe \
    experiment_config \
    _runs/2026-05-14 \
    --comdare-root=C:/path/to/comdare-cache-engine
```

### 5.2 NEU (V11.3): Messreihen-XML-Modus

```sh
build/Debug/messung_driver/comdare-messung-driver.exe \
    experiment_config \
    _runs/2026-05-14 \
    --messreihen-xml=experiment_config/messreihen.xml
```

Liest `messreihen.xml` + startet pro `<messreihe>` einen eigenen
ExperimentDriver-Lauf mit dem entsprechenden Mode (defined/full) +
sota_profile_filter. Output: `_runs/<date>/<id>/measurements.{csv,json}`.

### 5.3 EXPERIMENT_MODE Compile-Flag (V8.4 + V8.12)

Damit der ResultAggregator als integraler Bestandteil der ExecutionEngine
kompiliert wird, muss der Sub-Build mit `-DCOMDARE_EXPERIMENT_MODE=ON`
laufen. messung_driver gibt eine Warnung aus, wenn das Flag nicht aktiv ist.

```sh
cmake -B build -DCOMDARE_EXPERIMENT_MODE=ON
```

Auf Linux:

```sh
build/messung_driver/comdare-messung-driver \
    --config-dir experiment_config \
    --output-dir _runs/2026-05-13 \
    --verbose
```

Ablauf pro Messreihe (intern delegiert an
`comdare::builder::ExperimentDriver::run_pipeline_full`):

1. **Phase 1 — ENUMERATION**: XML parsen, Permutations-Liste erzeugen
2. **Phase 2 — CODEGEN**: pro Permutation eine `comdare_perm_<fp>.cpp`
3. **Phase 3 — COMPILE**: cmake configure + cmake --build (Sub-Build)
4. **Phase 4 — LOAD**: alle `.dll`/`.so` per LoadLibrary/dlopen laden
5. **Phase 5 — EXECUTE**: pro Modul `create_instance` + `run_workload`
6. **Phase 6 — MEASURE**: binary measurement-records aggregieren
7. **Phase 7 — PERSIST**: `measurements.csv` + `measurements.json`

Output liegt unter `_runs/2026-05-13/<reihe>/measurements.{csv,json}` und
unter `_runs/2026-05-13/<reihe>/build-perms/`.

---

## 6. Binary → CSV (optional Detail-Konvertierung)

Falls das binary-record-Format (`kBinaryMagic 0xC0FFEE02`) ausserhalb der
Standard-CSV-Exports verwendet werden soll:

```sh
build/Debug/binary_to_csv/comdare-binary-to-csv.exe \
    --in  _runs/2026-05-13/messreihe_a/raw.bin \
    --out _runs/2026-05-13/messreihe_a/extended.csv
```

---

## 7. CSV → LaTeX-Tabelle + Baustein-Steckbrief

```sh
build/Debug/csv_to_latex/comdare-csv-to-latex.exe \
    --in  _runs/2026-05-13/messreihe_b/measurements.csv \
    --out latex/messreihe_b/table.tex \
    --baustein-description on
```

Erzeugt:
- `latex/messreihe_b/table.tex` — eine booktabs-LaTeX-Tabelle
- `latex/messreihe_b/algorithm_description.tex` — Steckbrief jedes
  Bausteins (Allokator, Layout, Prefetch, etc.)

---

## 8. C++ → TikZ Diagramm-Generator

```sh
build/Debug/diagram_generator/comdare-diagram-generator.exe \
    --in       _runs/2026-05-13/messreihe_b/measurements.csv \
    --out-dir  latex/messreihe_b/diagrams/ \
    --types    bar,scatter,heatmap \
    --page-format a4
```

Erzeugt fuer jede Permutation `tikz_<id>.tex`. A4-Awareness bedeutet:
maximale Breite/Hoehe pro Diagramm werden vor Generierung gepruefft,
um keine LaTeX-Overfull-hbox zu erzeugen.

---

## 9. LaTeX → PDF (Manuskript-Wrapper)

```sh
# POSIX
cd Code/latex_to_pdf
./build_thesis.sh latex/main.tex

# Windows
cd .\Code\latex_to_pdf
.\build_thesis.bat latex\main.tex
```

Der Wrapper ruft intern die cache-engine `latex_toolchain.cmake`-Pipeline
auf (pdflatex 3 Durchlaeufe + biber + makeindex). Output:
`latex/main.pdf`.

---

## 10. Voll-automatischer All-in-one-Lauf (Beispiel)

```sh
#!/usr/bin/env bash
set -euo pipefail
RUN_ID=$(date +%Y-%m-%d_%H%M%S)
OUT="_runs/${RUN_ID}"

cmake --build build --target ALL_BUILD
ctest --test-dir build --output-on-failure

build/Debug/messung_driver/comdare-messung-driver \
    --config-dir experiment_config --output-dir "${OUT}" --verbose

for reihe in messreihe_a messreihe_b messreihe_c; do
    build/Debug/csv_to_latex/comdare-csv-to-latex \
        --in "${OUT}/${reihe}/measurements.csv" \
        --out "latex/${reihe}/table.tex" \
        --baustein-description on
    build/Debug/diagram_generator/comdare-diagram-generator \
        --in "${OUT}/${reihe}/measurements.csv" \
        --out-dir "latex/${reihe}/diagrams/" \
        --types bar,scatter,heatmap --page-format a4
done

latex_to_pdf/build_thesis.sh latex/main.tex
```

---

## 11. Fehler-Diagnose

| Fehler | Ursache | Loesung |
|--------|---------|---------|
| `Submodule nicht initialisiert` | `git submodule update --init --recursive` vergessen | wie genannt |
| `cmake configure: cache-engine not found` | falscher COMDARE_CACHE_ENGINE_DIR | mit `-DCOMDARE_CACHE_ENGINE_DIR=...` override |
| `Phase 3: cmake --build failed` | Sub-Build der DLLs schlug fehl | Logs unter `build-perms/` lesen |
| `Phase 4: No modules loaded` | DLLs nicht in `Debug/` oder `Release/` | `--config-dir` Pfad pruefen |
| `pdflatex: command not found` | TeX Live / MiKTeX nicht installiert | nachinstallieren |
| `Overfull hbox` | A4-Limit ueberschritten | `--page-format` einschraenken oder Diagramm splitten |

---

## 12. Querverweise

- `STRUCTURAL_CORRECTION_diplomarbeit.md` — Drei-Repo-Aufteilung (Master)
- `FINDINGS_REV7_6_diplomarbeit.md` — Findings 2026-05-13 (Master)
- `20260508 Termin 7/HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md`
- `20260508 Termin 7/REVIEW_PLAN_6_TAGE.md`
- `20260508 Termin 7/Phase5_UML_Detail/30_architektur_delta_REV7_6_drei_repo_layer_2026_05_13.md`
- `docs/sessions/20260514-1430-v11-anker-mit-delta.md` (V11-Anker)
- cache-engine: `cache_engine/builder/experiment_driver/experiment_driver.hpp`
- cache-engine: `cache_engine/algorithm_profiles/sota/*.profile.xml` (30 SOTA)
- cache-engine: `cache_engine/include/cache_engine/abi/baustein_variants.hpp` (V9.2/V11.4)
- prt-art: `prt_art/identity/prt_art_search_engine.hpp`
- prt-art: `prt_art/identity/prt_art_search_engine_adapter.hpp` (V9.1/V10.3/V11.1)
- prt-art: `prt_art/algorithm_profiles/prtart_pruefling.profile.xml`
- experiment_config/messreihen.xml (V11.5 Standard-Template)

---

## 13. V8-V11 Delta (Was hat sich seit V7.6 geaendert?)

| Sprint | Aenderung | Datei/Komponente |
|---|---|---|
| V8.4  | `COMDARE_EXPERIMENT_MODE` CMake Flag (default OFF) | cache-engine/CMakeLists.txt |
| V8.5  | ResultAggregator integral in ExecutionEngine | execution_engine.hpp |
| V8.3  | algorithm_profiles/sota/ mit 8 SOTA-Profilen | cache-engine |
| V8.6  | defined/full mode + AlgorithmProfile-Loader | xml_config_parser |
| V8.8  | algorithm_baustein.hpp std::variant Pattern | abi/algorithm_baustein.hpp |
| V8.9  | PrtArtSearchEngineAdapter (Komposition) | prt-art ABI-Adapter |
| V9.1  | 3 Adapter-Subklassen (Map/Vector/Tuple) | prt-art Adapter |
| V9.2  | baustein_variants.hpp + DefaultElevenAxes | cache-engine ABI |
| V9.3  | generate_module_from_profile | cache-engine codegen |
| V9.5  | +22 Tier-2/3 SOTA-Profile = 30 gesamt | cache-engine algorithm_profiles |
| V9.6  | --messreihen-xml=FILE Option | messung_driver |
| V10.1 | cache-engine prt_art/legacy_reimpl/ geloescht | cache-engine cleanup |
| V10.2 | resolve_baustein operationalisiert | cache-engine ABI |
| V10.3 | notify_*-Methoden (Skelett mit TODO) | prt-art Adapter |
| V10.4 | 6 Codegen-Tests | cache-engine tests/unit |
| V10.5 | ExperimentDriver Auto-Pickup von Profilen | cache-engine experiment_driver |
| V10.6 | MessreihenMode + sota_profile_filter | ExperimentDriverOptions |
| V11.1 | notify_*-Methoden vollstaendig verdrahtet | prt-art Adapter + Komponenten |
| V11.2 | Profile-aware Workload-Routing in Phase 5 | cache-engine experiment_driver |
| V11.3 | messung_driver Spec→ExperimentDriver E2E | Diplomarbeit messung_driver |
| V11.4 | Variant-Bodies mit description + paper_ref | cache-engine baustein_variants |
| V11.5 | experiment_config/messreihen.xml Template | Diplomarbeit |
| V11.6 | test_messung_driver MessreihenMode-Tests | Diplomarbeit tests |
| V11.7 | GitLab CI + GitHub Actions in alle 3 Repos | .gitlab-ci.yml + .github/workflows/ |
