# DOSSIER AP-1/#235 — Mess-Record + CSV um branch_misses + throughput_ops_per_sec erweitern (HOST-seitig, ABI-4, golden-neutral)

> **Für Codex** (`--sandbox workspace-write`, gpt-5.5, xhigh). EIN Agent. Repo-Wurzel = `--cd` (comdare-cache-engine).
> **NICHT committen, KEINE git-Operationen.** Basis = fresh-context-Kartierung (Explore a4572a5e), alle Zeilen belegt.
> **Reiner HOST-Anteil — NULL ABI-Modul-Berührung** (`ComdareMeasurementSnapshotV1` quert die DLL-Grenze NICHT).
> COMDARE_ANATOMY_ABI_MAJOR bleibt **4**. golden-320 unberührt (Mess-Record fließt NICHT in binary_id).

## 1. Auftrag
Zwei neue Mess-Spalten in den host-seitigen Mess-Record + die 23-Spalten-CSV: **`branch_misses`** (PMC-Zähler, wie die anderen HW-Counter)
und **`throughput_ops_per_sec`** (host-**abgeleitet** aus op_count / Laufzeit). Die 16-Spalten-Pipeline-Sicht (LaTeX/PDF-Stufe) bleibt
UNVERÄNDERT.

## 2. VERIFIZIERTER Ist-Zustand (nutze GENAU diese Belege)
- **Mess-Record-POD (host):** `libs/cache_engine/builder/measurement_snapshot.hpp:34-63` — `ComdareMeasurementSnapshotV1` (namespace
  `comdare::cache_engine::builder`, `kVersion=1`), HW-Counter-Felder `cache_misses_l1/l2/l3, dtlb_misses, coherence_invalidations,
  energy_micro_joules` (`:44-49`) — KEIN branch_misses, KEIN throughput. Baut host-seitig aus `WorkloadRunResult`+`PmcCounters`
  (`measurement_from_workload_result` `:87-122`).
- **PMC-Quelle:** `libs/cache_engine/builder/pmc_source.hpp:19-27` — `PmcCounters` (dieselben 6, kein branch_misses). Reale Quelle =
  Drop-in `IPmcSource` (WindowsPcmPmcSource #153/#156-M3), „KEINE Änderung an POD/Pipeline/PDF" (Kommentar `:9`).
- **op_count/Laufzeit für throughput:** `WorkloadRunResult` trägt `op_count` + Zeit (`total_ns`/`total_cycles`). throughput = op_count /
  (total_ns/1e9). (Prüfe die genauen Feldnamen in `WorkloadRunResult` — vermutlich `measure.hpp`/`workload`-Header; nutze die realen.)
- **CSV-Emission (2 Sichten):** `measurement_snapshot.hpp:127-153` `serialize_measurements_csv` = **23 Spalten** (die volle Sicht) ·
  `:157-177` `serialize_measurements_pipeline16_csv` = **16 Spalten** (LaTeX-Stufe 04/05 — **DIESE NICHT verbreitern**).
- **Regressions-Test:** `tests/unit/test_v5_measurement_snapshot.cpp:68` fixt `count_cols==23`; `:82` fixt pipeline16 `==16`; `:83` fixt
  das exakte 16er-Präfix. → 23→25 nachziehen, 16 + Präfix UNVERÄNDERT lassen.

## 3. Soll (der Increment)
(a) **`branch_misses` (uint64)**: Feld in `PmcCounters` (`pmc_source.hpp`) + in `ComdareMeasurementSnapshotV1` (`measurement_snapshot.hpp`),
   in `measurement_from_workload_result` aus `pmc.branch_misses` befüllt (Default 0, wenn PMC nicht verfügbar — KEINE Fabrikation), als
   NEUE CSV-Spalte in `serialize_measurements_csv` (Wert + Header-Name `branch_misses`).
(b) **`throughput_ops_per_sec` (double)**: Feld in `ComdareMeasurementSnapshotV1` (NICHT in PmcCounters — host-abgeleitet), berechnet in
   `measurement_from_workload_result` als `op_count / (total_ns / 1e9)` mit **Div-0-Guard** (total_ns==0 → 0.0), als NEUE CSV-Spalte
   (Wert + Header `throughput_ops_per_sec`).
(c) `serialize_measurements_csv`: **23 → 25 Spalten** (Header-Zeile + Werte-Zeile konsistent, gleiche Reihenfolge). Positioniere die 2
   neuen Spalten am ENDE der 23er-Sicht (stabile bestehende Spalten-Reihenfolge, wie die additive POD-Konvention).
(d) `serialize_measurements_pipeline16_csv` (`:157-177`): **UNVERÄNDERT** (16 Spalten, LaTeX/PDF-Pfad; die 2 neuen NICHT aufnehmen).
(e) Test `test_v5_measurement_snapshot.cpp`: `:68` `23→25`; einen Assert ergänzen, dass `branch_misses`/`throughput_ops_per_sec` in der
   Header-Zeile stehen + throughput bei total_ns>0 = op_count/s plausibel; `:82`/`:83` (pipeline16==16 + Präfix) UNVERÄNDERT bestätigen.

## 4. HARTE Auflagen (Verstoß = Abbruch)
1. **NULL ABI-Modul-Änderung:** NICHT anfassen: `libs/cache_engine/anatomy/observable_tier.hpp` (`ComdareTierObserverSnapshot`),
   `anatomy_module_abi_v1_decl.hpp` (`COMDARE_ANATOMY_ABI_MAJOR`/Magic), extern-C-Factory. Der Mess-Record ist host-seitig — MAJOR bleibt 4.
2. **golden-320-neutral:** keine Kompositions-Achse/`permutation_axes.xml`/`kCompositionAxisNames`/`golden_fullpilot_320_binary_ids.txt`/
   `source_catalog.hpp` — der Mess-Record fließt NICHT in binary_id. Nicht anfassen.
3. **pipeline16-Sicht (LaTeX/PDF) bleibt EXAKT 16 Spalten** — die 2 neuen NUR in der 23→25-Voll-CSV. (Sonst bricht die PDF-Stufe.)
4. **Keine Fabrikation:** branch_misses = realer PMC-Wert oder 0 (nicht erfunden); throughput = ehrliche Ableitung mit Div-0-Guard.
5. **Submodul-Spiegel NICHT anfassen:** `modules/comdare-measurement/…`/`modules/comdare-build-tools/…`-Spiegel von `measurement_snapshot.hpp`
   sind eigene Submodul-Repos → NUR die `libs/`-Autoritativ-Quelle ändern; Spiegel-Sync ist ein separater Follow-up (im Output vermerken).
6. Kein `git`.

## 5. Verifikation (PFLICHT — Codex, literal)
- Baue+laufe `test_v5_measurement_snapshot` lokal → literal `[ PASSED ]` (25-Spalten-Assertion grün, pipeline16==16 grün).
- Zeige die neue 25-Spalten-Header-Zeile (mit `branch_misses` + `throughput_ops_per_sec`).
- Bestätige: `COMDARE_ANATOMY_ABI_MAJOR` unverändert (4); observable_tier.hpp/permutation_axes/golden unberührt; pipeline16 exakt 16.
- `git status --short` = NUR `pmc_source.hpp`, `measurement_snapshot.hpp`, `test_v5_measurement_snapshot.cpp` (+ ggf. der WorkloadRunResult-Header, falls op_count/total_ns dort ergänzt werden müssen — begründen).

## 6. Ausgabe an Claude
(a) Diffs; (b) literal `[ PASSED ]` + 25-Header-Zeile; (c) Bestätigung ABI-4/golden-neutral/pipeline16==16/keine Fabrikation;
(d) Notiz zu WindowsPcmPmcSource-branch_misses-Anbindung (falls #153-Quelle das Feld setzen muss — als Follow-up, NICHT in AP-1 wenn PMC-gated);
(e) Submodul-Spiegel-Drift als expliziter Follow-up.
