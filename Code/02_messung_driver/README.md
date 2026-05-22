# 02_messung_driver — Pipeline-Stufe 2

**V35.A.2 (2026-05-22) — XX_operation/ Umstrukturierung**

## Was

Hauptausfuehrung des V32Orchestrator: registriert beide ExecutionEngines (CE-EE-A
+ PrtArt-EE-B), iteriert die Permutationen (oder Default-Lookup-Messreihe via
prt_art::DefaultLookupRegistry), fuehrt parallel via `std::async`, vergleicht
mit `CompareEngineCommand` (Welch's t-test).

Ergebnis: binary measurement records (Eingabe fuer [`03_binary_to_csv`](../03_binary_to_csv/))
oder direkt `MessreiheReport` (Eingabe fuer `MessreiheReportExporter` in derselben Stufe).

## Warum

Einzige Stufe wo der Pruefling (PRT-ART) AKTIV ist (Phase 6 EXECUTE laut M-Modell).
Bridge zwischen Diplomarbeit-Konfiguration (`messreihen.xml`) und cache-engine V32
Command-Pattern.

## Wie

```bash
cmake --build build --target test_v32_orchestrator --config Release
./build/tests/Release/test_v32_orchestrator.exe  # 7 Smoke-Tests
```

Im echten Use-Case wird `V32Orchestrator::run_default_lookup_messreihe(workload)`
aus `main.cpp` aufgerufen.

## Pipeline-Position

```
01_sample_data_generator     (Helper)
02_messung_driver            <- DIESES MODUL
03_binary_to_csv             (konsumiert binary records)
04_csv_to_latex / 05_diagram_generator  (parallel)
06_latex_to_pdf
```

## Module-Inhalt

- `v32_orchestrator.hpp` (V33.C.1) — Hauptklasse
- `hardware_filter.hpp` (V33.E.4 + V35.B.2-B.3) — Host-Capabilities + Hardware/Compiler-Filter
- `messreihe_v32_validator.hpp` (V33.D.2) — XML-Schema-Validator
- `messreihe_report_exporter.hpp` (V34.B.1) — CSV + TikZ-Export
- `main.cpp` — CLI-Entry

## tests/fixtures/cached/

Diese Stufe konsumiert XML-Konfigs aus `Code/test_data_xml/`. Pro Test sind die
relevanten XMLs cached (Skelett-Dir `tests/fixtures/cached/`).
