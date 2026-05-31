# Y.3 — Diplomarbeit/Code/ Ist-Kartografie (V31.F Stand)

> ⚠️ **SUPERSEDED (2026-05-31):** Überholter Planungs-/Architektur-Stand (axis-zentrische Restruktur F.2, Plugin-Prüfling-Modell, DLL-F15-Pipeline, sezierte Organe). IST-treue Single-Source-of-Truth: `comdare-cache-engine/docs/sessions/architektur-ziele-offene-punkte-ledger.md` + `…/20260531-e2e-abnahme-audit-und-entscheidungen.md`. Niemals löschen — nur Banner.

**Stand:** 2026-05-18 (Y.3)
**Repo-HEAD:** Diplomarbeit/Code/ ist Teil des Diplomarbeit-Datenbanken Top-Repos (HEAD `9ecdd3f`)
**Vorgehen:** Tool-Inventar pro Sub-Verzeichnis, Klassen + Datenfluss, M-Modell-Subsystem-1-Rolle

> Ist-Bestandsaufnahme des Outer-Loop-Subsystems (Subsystem 1 im M-Modell). Hier wohnt der Diplomarbeit-spezifische Auswertungs-Code, der den CacheEngineBuilder triggert + die Mess-Resultate fuer den thesis-Anhang aufbereitet.

---

## §1 Top-Level-Struktur

```
Diplomarbeit/Code/
├── CMakeLists.txt              (Top-Level Build-Orchestrator)
├── CMakePresets.json           (Build-Presets fuer MSVC/GCC/Clang)
├── README.md, USAGE.md         (User-Doku)
├── .gitignore
│
├── binary_to_csv/              (Tool 1: Binary-Result-Parser)
├── csv_to_latex/               (Tool 2: CSV-Tabellen-Generator)
├── diagram_generator/          (Tool 3: C++ -> TikZ-Diagramm-Pipeline)
├── latex_to_pdf/               (Tool 4: LaTeX-Compiler-Wrapper)
├── messung_driver/             (Tool 5: HAUPT-Driver, Subsystem 1 Outer-Loop)
├── sample_data_generator/      (Tool 6: Sample-Daten-Generator V21.3)
│
├── experiment_config/          (XML-Configs fuer Messreihen-Steuerung)
├── test_data_xml/              (3 Pflicht-Messreihen-Configs A/B/C)
├── tests/unit/                 (Unit-Tests fuer alle 6 Tools)
│
└── external/                   (Submodules)
    ├── comdare-cache-engine/   (Subsystem 2 + 3)
    └── comdare-prt-art/        (Subsystem 4)
```

**Tools-Anzahl:** 6 (5 mit C++-Code, 1 LaTeX-Wrapper)
**Tests:** 4 Unit-Test-Files
**XML-Configs:** experiment_config/ + test_data_xml/ (Pflicht-Messreihen)

---

## §2 messung_driver — HAUPT-Driver (Subsystem 1)

**M-Modell-Rolle:** Subsystem 1 (Outer-Loop / Auswertung-Orchestrator)
**Dateien:**
- `messung_driver/main.cpp` (Entry-Point)
- `messung_driver/CMakeLists.txt`

### §2.1 main()-Verantwortung

1. XML-Config-Loader (3 Messreihen A/B/C aus test_data_xml/)
2. MessreihenMode-Auswahl (Defined / Full / Full-Sampled)
3. Loop ueber Messreihen-Tupel
4. Pro Tupel: CacheEngineBuilder-Trigger (Phase 1-7)
5. ResultAggregator (Sammeln + Output CSV/JSON)
6. thesis-Anhang-Vorbereitung

### §2.2 V32+ Soll-Erweiterung (siehe Q.1)

- IPlatformProbe-Pre-Check (Achse 12 + 13 Filter pro Host)
- Sub-Bank-aware XML-Profile parsen (V32.3)
- HTTP-Loader fuer YCSB-Daten-Pod (#109)

---

## §3 binary_to_csv

**Zweck:** Binaere Mess-Resultate (PermutationResult-Records) → CSV-Tabelle

**Dateien:**
- `binary_to_csv/binary_to_csv.cpp` (Hauptlogik)
- `binary_to_csv/binary_to_csv.hpp` (Klassen-Header)
- `binary_to_csv/main_cli.cpp` (CLI-Wrapper)
- `binary_to_csv/CMakeLists.txt`

**Vermutliche Hauptklasse:** `BinaryToCsv` (CLI-Tool)
**Input:** `_runs/<date>/<spec_id>/results.bin`
**Output:** `_runs/<date>/<spec_id>/results.csv`

---

## §4 csv_to_latex

**Zweck:** CSV-Tabellen → LaTeX-Tabular-Code (thesis-Anhang)

**Dateien:**
- `csv_to_latex/csv_to_latex.cpp`
- `csv_to_latex/csv_to_latex.hpp`
- `csv_to_latex/main_cli.cpp`
- `csv_to_latex/CMakeLists.txt`

**Vermutliche Hauptklasse:** `CsvToLatex`
**Input:** CSV-Tabelle aus binary_to_csv
**Output:** `.tex`-Snippet fuer `\input{}` in thesis-Anhang

---

## §5 diagram_generator

**Zweck:** Mess-Daten → TikZ-Diagramm-Code mit A4-Awareness (V22.1)

**Dateien:**
- `diagram_generator/diagram_generator.cpp`
- `diagram_generator/diagram_generator.hpp`
- `diagram_generator/main_cli.cpp`
- `diagram_generator/CMakeLists.txt`

**Vermutliche Hauptklasse:** `DiagramGenerator` mit `plot_by_workload`-Methode (V22.1)
**Input:** PermutationResult-Records oder CSV
**Output:** TikZ-Code fuer thesis-Plots (Throughput vs Workload etc.)

---

## §6 latex_to_pdf

**Zweck:** LaTeX-Compiler-Wrapper (pdflatex + bibtex)

**Dateien:**
- `latex_to_pdf/CMakeLists.txt` (nur Build-Helper, kein eigener C++-Code)

**Vermutung:** Wrapper-Script oder CMake-Target zum Aufruf von `pdflatex` + `bibtex` mit korrektem CWD.

---

## §7 sample_data_generator

**Zweck:** Sample-Mess-Daten-Generator (V21.3, fuer thesis-Sample-Diagramme vor V21.2 echten HW-Mess-Daten)

**Dateien:**
- `sample_data_generator/sample_data_generator.cpp`
- `sample_data_generator/CMakeLists.txt`

**Vermutliche Hauptklasse:** Standalone-Tool, generiert plausible PermutationResult-Daten fuer thesis-Sample-Plots.

**Status:** wird durch reale HW-Mess-Daten ersetzt sobald V21.2 (HW-E2E Mess-Reihe) ausgefuehrt ist.

---

## §8 experiment_config + test_data_xml

**Zweck:** XML-Konfigurations-Files fuer messung_driver-Steuerung

### §8.1 test_data_xml/ — Pflicht-Messreihen (V8.13)

| Datei | Messreihe | Ziel |
|---|---|---|
| `config_a_prt_art_vs_sota.xml` | A | PRT-ART vs SOTA (12 SOTA-Adapter) |
| `config_b_cache_engine_perms.xml` | B | Cache-Engine-Permutationen (Allokator x Layout x Prefetch x ...) |
| `config_c_merge_alt_neu.xml` | C | Regressions-Vergleich alt vs neu |

### §8.2 experiment_config/

Detailliertere XML-Profile pro Messreihe. (Stand: V11.5 messreihen.xml als Standard-Template.)

---

## §9 tests/unit/

Unit-Tests fuer alle 6 Tools:

| Test-File | Testet |
|---|---|
| `test_binary_to_csv.cpp` | binary_to_csv Tool |
| `test_csv_to_latex.cpp` | csv_to_latex Tool |
| `test_diagram_generator.cpp` | diagram_generator Tool |
| `test_messung_driver.cpp` | messung_driver Outer-Loop (V11.6) |

---

## §10 V32+ Soll-Erweiterungen

| Aenderung | Was | Wo | Trigger |
|---|---|---|---|
| messung_driver HTTP-Loader | YCSB-Daten via HTTP von Debian-Pod #109 | `messung_driver/main.cpp` + neue `dataset_loader.cpp` | Q.1 + #109 |
| messung_driver Hardware-Pre-Check | IPlatformProbe-Filter pro Host (Achse 12 + 13) | `messung_driver/main.cpp` | Q.1 |
| XML-Schema V32 (14 Banks) | xml_config_parser auf 14 Banks anpassen | `external/comdare-cache-engine/libs/common/serialization/xml_config_parser/` (Submodule-Pin) | V32.3 |
| Diagramm-Generator pro Achse | Pro Achse 1-14 Plot-Schema | `diagram_generator/diagram_generator.cpp` | (S.3 thesis Update) |
| Dataset-Filter-Test | Hardware-Verfuegbarkeits-Filter | `tests/unit/test_dataset_filter.cpp` (NEU) | Q.1 |

---

## §11 M-Modell-Subsystem-1-Pflicht

Subsystem 1 (Outer-Loop) wird laut M-Modell von **Diplomarbeit/Code/messung_driver/main.cpp** repraesentiert. Pflicht:

1. **Outer-Loop ueber Messreihen-Konfigurationen** (XML-getrieben)
2. **CacheEngineBuilder.build(config_xml) Aufruf** pro Tupel
3. **Sammeln der Mess-Resultate** ueber `_runs/<date>/<spec_id>/`
4. **Aufbereitung fuer thesis-Anhang** (binary_to_csv -> csv_to_latex -> latex_to_pdf)

Diese Verantwortung ist KLAR vom CacheEngineBuilder (Subsystem 2, autonom) getrennt:
- messung_driver = WAS gemessen wird (Auswertung-Orchestrator)
- CacheEngineBuilder = WIE gemessen wird (Plattform-Ausmess-System)

---

## §12 Querverweise

- M-Modell Schichten: `../architektur/10_schichten_modell_M.md` §2.1 Subsystem 1
- Q-Phase Datasets-Plan: `../adapters/Q_PHASE_DATASETS_F_EXTRA_PLAN.md`
- V32 Code-Refactoring (V32.3 xml_config_parser): `../adapters/V32_CODE_REFACTORING_PLAN.md` §3
- Debian-Pod YCSB-Provider: `../infra/I109_DEBIAN_POD_YCSB_DATA_PROVIDER.md`
- Y.1 Cache-Engine Pendant: `Y1_cache_engine_ist_kartografie.md`
- Y.2 PRT-ART Pendant: `Y2_prt_art_ist_kartografie.md`

---

**Ende docs/uml_planning/Y3_diplomarbeit_code_ist_kartografie.md (Y.3 DONE).**
