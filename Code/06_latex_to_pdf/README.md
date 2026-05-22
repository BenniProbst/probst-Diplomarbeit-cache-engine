# 06_latex_to_pdf — Pipeline-Stufe 6

**V35.A.2 (2026-05-22) — XX_operation/ Umstrukturierung**

## Was

Wrapper um cache-engine `latex_toolchain` (pdflatex / lualatex). Baut das
finale Diplomarbeit-PDF mit embedded LaTeX-Tabellen aus [`04_csv_to_latex`](../04_csv_to_latex/)
und TikZ-Diagrammen aus [`05_diagram_generator`](../05_diagram_generator/).

## Warum

Letzte Pipeline-Stufe. Liefert das pruefbare Endprodukt (PDF) das der Pruefer
sieht. Automatisierter Build vermeidet Reproduzierbarkeitsprobleme.

## Wie

```bash
cmake --build build --target latex_to_pdf_cli --config Release
./build/06_latex_to_pdf/Release/latex_to_pdf_cli.exe \
    thesis/main.tex thesis.pdf
```

## Pipeline-Position

```
04_csv_to_latex          (LaTeX-Tabellen embedded)
05_diagram_generator     (TikZ embedded)
06_latex_to_pdf          <- DIESES MODUL = FINAL
```

## tests/fixtures/cached/

Minimal-LaTeX-Snippets (`minimal_main.tex` + 1 Tabelle + 1 Diagramm) zum
Smoke-Test der pdflatex-Toolchain ohne den vollen Diplomarbeit-Text bauen
zu muessen.
