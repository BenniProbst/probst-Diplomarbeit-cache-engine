# 01_sample_data_generator — Pipeline-Stufe 1

**V35.A.1 (2026-05-22) — Pilot der XX_operation/-Umstrukturierung**

## Was

Generiert synthetische Mess-Daten als CSV-Datei in dem Format das spaeter von
[`03_binary_to_csv`](../03_binary_to_csv/) erwartet wird. Wird **nur** verwendet
wenn echte Hardware-Messungen via [`02_messung_driver`](../02_messung_driver/)
noch nicht verfuegbar sind (z.B. fuer Schritt-Tests der nachfolgenden Stufen).

## Warum

Nachfolgende Pipeline-Stufen brauchen valide CSV-Eingaben zum Testen. Statt
fuer jeden Test-Lauf den vollen V32Orchestrator-Run zu fahren (sekundenlang,
benoetigt cache-engine + prt-art Submodule), liefert dieses Modul in
Millisekunden eine synthetische CSV mit demselben Schema. Erlaubt isoliertes
Pruefen jeder Folge-Stufe.

## Wie

```bash
# Build (Top-Level Build, dieses Modul wird per add_subdirectory eingebunden)
cmake -B build -G "Visual Studio 17 2022"
cmake --build build --target sample_data_generator --config Release

# Ausfuehren
./build/01_sample_data_generator/Release/sample_data_generator.exe \
    --output sample_results.csv \
    --rows 100 \
    --seed 42
```

## Pipeline-Position

```
01_sample_data_generator  <- DIESES MODUL (kein Input, generiert synthetische Daten)
02_messung_driver         (echte Messung, alternativer Daten-Lieferant)
03_binary_to_csv          (konvertiert binary records von 02 -> CSV)
04_diagram_generator      (TikZ aus CSV)
05_csv_to_latex           (LaTeX-Tabelle aus CSV)
06_latex_to_pdf           (Final-PDF)
```

## tests/fixtures/cached/

Stufe 01 hat keine Vorgaenger-Stufe, daher KEINE cached Eingangs-Fixtures.
Die generierten Outputs dienen aber als Fixture-Quelle fuer Stufe 03/04/05
(`*/tests/fixtures/cached/sample_*.csv`).

## Cross-Refs

- Top-Level USAGE: [`../USAGE.md`](../USAGE.md) Schritt 2-3
- Memory-Direktive: [[feedback-thesis-divide-and-conquer]]
- Vorgaenger-Pfad (entfaellt): `Code/sample_data_generator/` (vor V35.A Pilot)
