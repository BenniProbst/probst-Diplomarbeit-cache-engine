# Pipeline-End-to-End-Validierung mit ECHTEN golden-320-Mess-Daten (2026-07-11)

**Auslöser (User 2026-07-11):** „mit Messung das echte Verhalten der Pipeline durchtesten und Plausibilität
der Resultate testen und durchsehen" → danach „mach es so, wie du es gemacht hättest" (Autonomie).

**Kontext:** Der golden-320-Messlauf läuft (Cluster #9900 auf prod1 + lokaler `~/measurements/golden-320-run1`,
zum Prüfzeitpunkt 95/320 Permutationen fertig). Diese Validierung nutzt die REALEN Zwischenergebnisse, um die
gesamte Kette **Messung → CSV → LaTeX/TikZ → PDF** zu beweisen, statt auf den mehrtägigen Voll-Lauf zu warten.

## Verdikt: die gesamte „Messwerte → PDF"-Kette funktioniert end-to-end mit echten Daten — 5 Stufen belegt

1. **Rohmesswerte plausibel** (6.480 Datenzeilen über 40 result.csv, Python-Analyse): **0 Anomalien**.
   - lookup p50 ≈ 2 µs (1,56–7,9 µs), p99 ≈ 4,8 µs — **p99 > p50 durchgehend monoton korrekt**.
   - ns_per_op Median ≈ 9 µs (1,9–229 µs) — plausible Spanne über die Permutationen.
   - Segment-Summen positiv, keine NaN/Nullwerte, keine negativen Zeiten.
   - `two_phase_valid = 1` für alle 162 Zeilen je Datei → die Zwei-Phasen-Op-Schleife liefert gültige Messungen.

2. **Format-Kontrakt hält** (Ist-CSV ↔ `Code/04_csv_to_latex/csv_to_latex.hpp:48-50`):
   - reale result.csv = **175 Spalten, `;`-delimitiert, WIDE-Schema** — exakt der dokumentierte Erwartungs-Kontrakt
     (`binary_id;setting;repetition;n_ops;total_ns;ns_per_op;19×seg_*_ns;…;stat_*;…;workload;two_phase_valid`).
   - Parser ist **HEADER-GETRIEBEN** (Spalten per Name, reihenfolge-/breiten-agnostisch) → robust.

3. **Tabelle** (`csv-to-latex --schema=wide`, echtes 2-Permutations-Aggregat, 324 Datenzeilen → 12 Zellen):
   valide booktabs-Bias-Bruch-Matrix (search_algo × YCSB-Workload, Zelle = Median ns/op). Werte konsistent:
   ycsb_c (read-only) ≈ 1,9–2,1 µs = deckt sich mit dem lookup-p50; ycsb_a (update-heavy) ≈ 124–136 µs. → `real_measure.tex`

4. **Diagramm** (`diagram-generator --surface=op_lookup_p50_ns`): valide pgfplots-TikZ-Heatmap
   (viridis, search_algo × workload). → `real_surface.tex`

5. **PDF kompiliert** (`pdflatex`, TeX Live 2026, booktabs+pgfplots): **wrapper.pdf = 66.330 Bytes** — Tabelle +
   Heatmap aus echten Mess-Daten in einem gerenderten PDF. → `wrapper.pdf`

## Artefakte
| Datei | Inhalt |
|---|---|
| `real_aggregate.csv` | echtes 2-Permutations-Aggregat (interpolation + k_ary) aus dem laufenden golden-320-Lauf |
| `real_measure.tex` | daraus erzeugte LaTeX-Bias-Matrix (csv_to_latex) |
| `real_surface.tex` | daraus erzeugte TikZ-Heatmap (diagram_generator) |
| `wrapper.tex` / `wrapper.pdf` | Wrapper + kompiliertes PDF (der literale End-to-End-Beweis) |

## Konsequenz
Der volle golden-320-Lauf (#9900) wird am Ende via `persist:measurements` das Aggregat nach `development`
schreiben; die Auswerte-Tools (csv_to_latex/diagram_generator) und der thesis:pdf-Pfad konsumieren exakt dieses
Schema — **hier real-daten-verifiziert**. Kein Format-Bruch zwischen Mess-Output und PDF-Erzeugung.
