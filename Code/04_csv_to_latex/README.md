# 04_csv_to_latex — Pipeline-Stufe 4

**V35.A.2 (2026-05-22) — XX_operation/ Umstrukturierung**

## Was

Liest CSV-Datei aus [`03_binary_to_csv`](../03_binary_to_csv/) und erzeugt
LaTeX-Tabelle (`\begin{tabular}...`) + Baustein-Steckbrief je Tupel.

## Warum

Ergebnis-Tabellen sind Pflichtinhalt der Diplomarbeit-Auswertung
(Habich-Anforderung Termin 5). Automatisch generierte Tabellen vermeiden
manuelle Uebertragungsfehler.

## Wie

```bash
cmake --build build --target csv_to_latex_cli --config Release
./build/04_csv_to_latex/Release/csv_to_latex_cli.exe results.csv table.tex
```

## Pipeline-Position

```
03_binary_to_csv         (Quelle: CSV)
04_csv_to_latex          <- DIESES MODUL
06_latex_to_pdf          (embedded LaTeX-Tabelle in main.tex)
```

Parallel zu [`05_diagram_generator`](../05_diagram_generator/) (beide erzeugen
LaTeX-Snippets fuer 06_latex_to_pdf).

## tests/fixtures/cached/

CSV-Samples aus 03_binary_to_csv (`results_typical.csv`, `results_empty.csv`,
`results_zipf_hotkey.csv`).
