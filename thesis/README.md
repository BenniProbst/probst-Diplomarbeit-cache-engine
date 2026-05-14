# thesis/ — Diplomarbeit-Manuskript (REV 7.6 V13.7)

**Status:** Skelett mit Kapitel-Stubs. Fuer Vor-Termin-Habich-Folge-Sessions
muss der Inhalt pro Kapitel ausgefuellt werden.

---

## Layout

```
thesis/
├── main.tex                             (Master-Datei mit \include-Liste)
├── README.md                            (dieses Dokument)
├── literatur.bib                        (Bibliographie — TBD)
├── chapters/
│   ├── 01_einleitung.tex                (Motivation + Forschungsfragen)
│   ├── 02_stand_der_technik.tex         (33-Paper-Tieflektuere zusammengefasst)
│   ├── 03_architektur.tex               (REV 7 Drei-Schichten + 11 Achsen)
│   ├── 04_implementation.tex            (cache-engine + prt-art + Diplomarbeit/Code)
│   ├── 05_messverfahren.tex             (3 Messreihen + ExperimentDriver)
│   ├── 06_auswertung.tex                (Diagramme + Tabellen aus messung_driver)
│   ├── 07_fazit_und_ausblick.tex
│   ├── A1_anhang_messreihen.tex         (Vollstaendige Mess-Tabellen)
│   └── A2_anhang_codestruktur.tex       (PROJECT_LAYER_MAP-Auszuege)
├── tikz/                                (von diagram_generator generiert)
└── tabellen/                            (von csv_to_latex generiert)
```

---

## Build

Manuell:
```bash
cd thesis
pdflatex -interaction=nonstopmode main.tex
biber main
pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode main.tex
```

Empfohlen: cache-engine `tools/latex_toolchain/latex_toolchain.cmake`
verwenden (Pflicht-3-Pass-Build mit biber).

---

## Diagramme + Tabellen integrieren

Nach einem messung_driver-Lauf:
```bash
# Aus Diplomarbeit/Code/:
build/Debug/diagram_generator/comdare-diagram-generator \
    --in   _runs/<date>/<spec_id>/measurements.csv \
    --out-dir thesis/tikz/<spec_id>/

build/Debug/csv_to_latex/comdare-csv-to-latex \
    --in   _runs/<date>/<spec_id>/measurements.csv \
    --out  thesis/tabellen/<spec_id>_table.tex
```

In den Kapiteln dann via:
```latex
\input{tikz/A_full/cycles_per_permutation.tikz}
\input{tabellen/A_full_table.tex}
```

---

## Querverweis
- USAGE.md: `Diplomarbeit/Code/USAGE.md`
- V13-Anker: `docs/sessions/20260514-1730-v13-anker.md`
- LaTeX-Toolchain: cache-engine `tools/latex_toolchain/`
