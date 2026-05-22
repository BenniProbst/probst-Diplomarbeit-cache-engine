# 03_binary_to_csv — Pipeline-Stufe 3

**V35.A.2 (2026-05-22) — XX_operation/ Umstrukturierung**

## Was

Liest binary measurement records (Format `kBinaryMagic = 0xC0FFEE02`, V1) die
von [`02_messung_driver`](../02_messung_driver/) erzeugt wurden und schreibt
eine CSV-Datei mit 15 Spalten (eine Zeile pro Mess-Tupel).

## Warum

Binary-Format ist platzsparend + schnell (von messung_driver waehrend des Laufs
geschrieben). CSV ist menschen-lesbar + Eingabe fuer LaTeX/TikZ.

## Wie

```bash
cmake --build build --target binary_to_csv_cli --config Release
./build/03_binary_to_csv/Release/binary_to_csv_cli.exe input.bin output.csv
```

## Pipeline-Position

```
02_messung_driver       (Quelle: binary records)
03_binary_to_csv        <- DIESES MODUL
04_csv_to_latex         (konsumiert CSV)
05_diagram_generator    (konsumiert CSV)
```

## tests/fixtures/cached/

Stuetzt sich auf 2 binary-Beispieldateien aus 02_messung_driver:
- `sample_v32_results.bin` (typischer Erfolgs-Run)
- `sample_v32_empty.bin` (Edge-Case 0 records)

Diese werden bei groesseren Format-Aenderungen aus `02_messung_driver` neu
generiert + hier eingefroren.
