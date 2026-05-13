# Diplomarbeit/Code/

**Rolle:** Anwender-Schicht der Drei-Repo-Architektur (REV 7.6, 2026-05-13).

Diese C++23-Application ruft die `comdare-prt-art`-Submodule (mit ihrem
`comdare-cache-engine`-Backbone) auf, fuehrt die drei Pflicht-Messreihen
durch und uebersetzt die binary measurement-records in LaTeX-PDFs.

## Architektur

```
Diplomarbeit/Code/
  └─ ruft als Submodule auf:
     ├─ external/comdare-prt-art         (Test-Algorithmus PRT-ART)
     └─ external/comdare-cache-engine    (Werkzeug-Bibliothek + Bausteine)
```

Die `ExperimentDriver`-Library lebt in cache-engine, der **Driver** lebt
hier (in `messung_driver/main.cpp`).

## Pipeline (5 Stufen)

```
experiment_config.xml
      │
      ▼
[1] messung_driver/   ◄── ruft prt-art-API auf
      │   ├── PRT-ART vs SOTA       (Messreihe A)
      │   ├── cache-engine Perm.    (Messreihe B)
      │   └── Merge alt/neu         (Messreihe C)
      │
      ▼ binary measurement_record_v1
[2] binary_to_csv/    ◄── deserialisiert binary → CSV
      │
      ▼ CSV (15-Spalten)
[3] csv_to_latex/     ◄── CSV + Algorithmus-Baustein-Doku → LaTeX
      │
      ▼ .tex Tabellen-Snippets
[4] diagram_generator/ ◄── C++ → TikZ-Code (A4-aware)
      │
      ▼ .tex Plot-Snippets
[5] latex_to_pdf/      ◄── pdflatex 2x + bibtex → Diplomarbeit.pdf
```

## Drei Pflicht-Messreihen

| ID | Was | Quelle |
|---|---|---|
| **A** | PRT-ART Testalgorithmus gegen Stand-der-Technik | prt-art + cache-engine SOTA-Adapter |
| **B** | Bestehende cache-engine Permutationen | cache-engine 54+ Permutationen |
| **C** | Merge alt/neu (PRT-ART-Bausteine in cache-engine-Stack) | Configurable Merge-Punkte |

Spezifikation in `experiment_config/config_{a,b,c}_*.xml`.

## Build

```bash
cd Code/
git submodule update --init --recursive
cmake -B build
cmake --build build
cd build && ctest --output-on-failure
```

## CLion

Open `Code/` als Projekt → CMake-Profile **Debug** / **Release** /
**MSVC-Debug** automatisch erkannt.
