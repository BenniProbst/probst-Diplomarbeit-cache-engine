# 05_diagram_generator — Pipeline-Stufe 5

**V35.A.2 (2026-05-22) — XX_operation/ Umstrukturierung**

## Was

Liest CSV-Datei aus [`03_binary_to_csv`](../03_binary_to_csv/) und erzeugt
TikZ-Diagramme (Bar / Scatter / Heatmap, A4-aware Layout).

Plus: NEU V34.B.1 — `MessreiheReportExporter::write_tikz_summary()` in
[`02_messung_driver`](../02_messung_driver/) liefert ebenfalls TikZ direkt
aus dem `MessreiheReport` (alternativer Weg ohne Binary/CSV-Umweg).

## Warum

Diagramme visualisieren die F15-Hypothesen-Resultate (Throughput-Ratio, Welch
p-Values, Wins/Ties/Losses pro Achse). Tikz statt PNG: skalierbar im LaTeX.

## Wie

```bash
cmake --build build --target diagram_generator_cli --config Release
./build/05_diagram_generator/Release/diagram_generator_cli.exe \
    results.csv plot.tex --type bar
```

## Pipeline-Position

```
03_binary_to_csv          (Quelle: CSV)
05_diagram_generator      <- DIESES MODUL
06_latex_to_pdf           (embedded TikZ in main.tex)
```

Parallel zu [`04_csv_to_latex`](../04_csv_to_latex/).

## tests/fixtures/cached/

CSV-Samples aus 03_binary_to_csv (mind. 1 Sample pro Diagramm-Typ).
