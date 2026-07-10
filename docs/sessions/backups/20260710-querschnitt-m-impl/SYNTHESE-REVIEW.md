# SYNTHESE — Querschnitt-M-Review (adversarial), 2026-07-10

> Workflow `wf_f1604ba3-f4d` (19 Agenten: 3 Finder + 16 Verifier, 988k Tokens). Scope = uncommitted M-Increment (SystemAxis-Wurzel + CMD-1-b + Contract-Test) NACH meinem eigenen Voll-Review-Fix (Latenz-Perzentile ≠ Mittelwert, vor dem Workflow eingezogen). Rohdaten: `rohdaten-review/` (Ergebnis + Journal + Skript). 8 Kandidaten → **6 CONFIRMED (2:0) / 2 REFUTED** (ENERGY_J-µJ-Einheit: konsumentenlos, dokumentiert). **Alle 6 vor dem Commit manuell gefixt.**

## CONFIRMED → gefixt
| # | Fund | Schwere | Fix |
|---|---|---|---|
| C1 | `MeasurementVisitable` mit `AxisCommand`-Konjunkt **bricht Bestands-Aufrufer** (compiler-bestätigt: `observe_all` via Organ-Hüllen ohne AxisBase-Statik, `anatomy_execution_context.hpp:167`, betrifft ALLE Referenz-Kompositionen im Default-Build) | **critical** | Konjunkt entfernt — Concept prüft NUR den Visitor-Vertrag; Begründung im Kommentar. **Beweis:** `test_v41_anatomy_f15_measurement` (der reale observe_all-Konsument) kompiliert + läuft **29/29 PASSED** (build-cmd1b, g++-16) |
| C2 | CLU = roher `cache_lines`-Zähler als „Auslastung" etikettiert — **inverse Metrik** (echte CLU = field_bytes/(cache_lines·64), `axis_05…observable.hpp:118-120`, Thesis 03:383) | major | CLU jetzt als Prozent-Ratio aus `[5][2]`+`[5][3]`; cache_lines==0 ⇒ invalid |
| C3 | FILL_BUFFER_OCCUPANCY = Software-T17-Queue-peak als Hardware-Line-Fill-Buffer (P25 Mahling) verkauft — physisch unverwandt | major | honest-0: invalidiert mit Begründungs-Kommentar |
| C4 | MEMORY_FOOTPRINT = Momentanwert `bytes_in_use` statt Thesis-Kanon `bytes_in_use_peak` (05_evaluation:94-95) — verzerrt CoW-lastige Layouts | minor | honest-0: invalidiert; peak-Spalte = künftiger golden-neutraler END-Append |
| C5 | Ungeguardete `static_assert(!MeasurementVisitable<StdMalloc,…>)` bricht STATISTICS=OFF-Builds (compiler-bestätigt) | major | `#ifdef COMDARE_CE_ENABLE_STATISTICS`-Guard + GTEST_SKIP-Pfad (Geschwister-Muster) |
| C6 | Neues Test-Target ohne per-Target-Defines (Schwester test_cmd1_a setzt sie) — RELEASE_MODE-Bruch | major | `target_compile_definitions(... COMDARE_MEASUREMENT_ON=1 COMDARE_CE_ENABLE_STATISTICS=1)` |
| C7 | Magic-Index-Kopplung an axis_stats ohne Schema-Bindung — stille Phantomwerte bei Schema-Drift | major | `static_assert(string_view{kV3AxisSchema[5].names[2/3]} == "field_bytes"/"cache_lines")` — compile-time-Vertrag |

*(Mein eigener Vor-Workflow-Fix: WallClock bediente alle Latenz-Perzentile mit dem Mittelwert — jetzt nur LATENCY_MEAN+THROUGHPUT valid, Perzentile honest-0 [HdrHistogramm/AP-8 ist die echte Quelle].)*

## Verifikations-Endstand (eigene Läufe, literal)
clang-format-22==0 · Mojibake==0 · offizieller build/ (g++-16): **10/10 Passed** (M-Contract + cmd1_a + E2/E3/E4-Contracts + 3 Guards + measurement_buffer) · build-cmd1b: f15_measurement-TU kompiliert + **29/29 PASSED** · ABI-PODs/perm_runner/Organ-Klassifikation/golden byte-unberührt · Slot-Verifikation T5[2/3]/T6[1]/T17[4] gegen kV3AxisSchema nachgezählt.
