# Gesamtkontext, Maschinerie-Konfiguration & autonomes /goal (Stand 2026-05-31)

Dieses Dokument ist die **Übersicht für den Operator** (dich): was die Maschinerie tut, wie du sie konfigurierst,
wo das PDF mit den Messdiagrammen herauskommt — und das **/goal**, das du setzen kannst, um die nächste Ausbaustufe
autonom abarbeiten zu lassen.

Single-Source-of-Truth für offene/erledigte Punkte bleibt das **Ledger**:
`Code/external/comdare-cache-engine/docs/sessions/architektur-ziele-offene-punkte-ledger.md`.

---

## 1. Was die Maschinerie ist (3-Repo-Kette)

| Repo | Rolle | Pfad |
|------|-------|------|
| **cache-engine** | Anatomie-Generator (Achsen→Lebewesen-Binaries) + Prüf-Dock (misst Binaries) — der „Stand der Technik" | `Code/external/comdare-cache-engine/` |
| **prt-art** | Prüfling (experimenteller Hybrid-Suchalgorithmus), wird gegen den Stand der Technik geprüft | `Code/external/comdare-prt-art/` |
| **Diplomarbeit (Superprojekt)** | 6-Stufen-LaTeX-Pipeline: fragt Messwerte ab → CSV → LaTeX-Tabellen/Diagramme → PDF | `Code/` (+ Repo-Wurzel) |

**Datenfluss (die 6 Stufen):**
```
01_sample_data_generator  →  02_messung_driver  →  03_binary_to_csv  →  04_csv_to_latex  →  05_diagram_generator  →  06_latex_to_pdf
   (Sample-CSV)              (echte Messung,        (16-Spalten-CSV)     (LaTeX-Tabelle)     (TikZ-Diagramm)        (PDF)
                             .bin-Container)
```
16-Spalten-CSV-Schema (kanonisch): `permutation_id, fingerprint, succeeded, workload_used, op_count, total_cycles,
cache_misses_l1, cache_misses_l2, cache_misses_l3, dtlb_misses, coherence_invalidations, energy_micro_joules,
bytes_allocated, bytes_in_use_peak, external_frag, internal_frag`. Die 6 Spalten 7-12 (Cache-Misses…Energie) sind
**heute Platzhalter 0** — sie werden durch die neue Mess-Abstraktion (siehe §4) mit echten HW-Countern gefüllt.

---

## 2. Aktueller Zustand (/goal V3 abgenommen)

Der vorige autonome Auftrag (E2E-Schließung) ist **ABGENOMMEN** (finaler Audit-Workflow `wu8pehnk3`, 2026-05-31):
- **C(a)** geschlossene Pipeline an realen i7-1270P-Daten → PDF (literal belegt).
- **C(b)** F15 an sezierten Organen (6 Organ-Kompositionen + `EnabledStrategies`=4 primitive Such-Organe, 13 Monolithen deregistriert).
- **C(c)** Ledger ohne offene actionable nicht-gatete Punkte.
- **C(d)** finaler Abnahme-Audit bestätigt (zwei Audit-Halluzinationen on-disk widerlegt).
- Verbleibend nur die zwei zulässig gateten P4-Stränge: **P4-Vendor** (jemalloc/tcmalloc toolchain-gated) + **P4-PMC** (HW-Counter).

Auf P4-PMC baut die nächste Stufe auf — daraus ist ein **größerer Architektur-Plan** geworden (§4).

---

## 3. Neuerungen dieser Session (Changelog)

| # | Neuerung | Beleg |
|---|----------|-------|
| G10 | `op_type_filter` — wirksame OP-1..OP-6 → WorkloadKind-Auswahl (statt nur dokumentarisch) + V32Orchestrator-Verdrahtung + 7 Tests | `Code/02_messung_driver/op_type_filter.hpp`; Standalone-MSVC „ALL PASS" |
| G12 | Doku-Drift-Sweep komplett (SUPERSEDED-Banner über 3 Repos, nichts gelöscht) | CE/PA/DA, Ledger §e |
| C(d) | Finaler Abnahme-Audit-Workflow + Befund-Korrekturen (PA-Banner + #42 als Falsch-Befunde widerlegt) | `…/20260531-cd-abnahme-audit-verdikt-und-planrunde.md` |
| P4-PMC | Intel-PCM-Recherche + Live-Geräte-Status (Secure Boot AUS, BitLocker AUS, HVCI AN) + Beschaffungs-/Setup-Plan | `…/20260531-p4-pmc-intel-pcm-plan.md` |
| **Plan** | **Architektur-Plan: einheitliche Mess-Abstraktion (PCM/AMD/ARM) + arch-Builder-Werkzeuge + Plattform-Fit-Check + ZIH-Precompile** | **`…/20260531-mess-abstraktion-cross-platform-architektur-plan.md`** |

**Entscheidungen (User, 2026-05-31):** Start mit **Rückgrat I1–I4** (vendor-neutral, ZIH-tauglich, kein Treiber);
ABI-Mess-Record = **EIN einziger POD** (Major-Version-Bump von `comdare_hw_counters_v1`, alle DLLs neu bauen).

---

## 4. Die nächste Ausbaustufe: einheitliche Mess-Abstraktion (Kurzfassung)

Vollständig in `…/20260531-mess-abstraktion-cross-platform-architektur-plan.md`. Kern:
- **R1** `IMeasurementSource` (= `IPmcSource`) als Wurzel; Intel PCM / AMD uProf / ARM PMU·PAPI / Wall-Clock = **gleichrangige** Implementierungen; Compile-Time-Selektor `COMDARE_MEASUREMENT_VENDOR`.
- **EIN ABI-POD** (User-Entscheidung): `comdare_hw_counters_v1` wird per Major-Bump auf die volle Mess-Spaltenmenge erweitert; `pull_live_counters` (bereits im ABI vorhanden, nie befüllt) wird verkabelt.
- **R2** Anknüpfung an f15_compare / Prüf-Dock / `tier_observe_trace_abi` / `measurement_writer` (kein Neubau) + P5: zwei Mess-Pfade → EINE autoritative Quelle.
- **R3** `ArchEvaluator` am Prüf-Dock bewertet Lebewesen-Binaries gegen das ISA-Kostenmodell (AMD/Intel).
- **R4/R5/R6** Build-Metaprogrammierung + Plattform-Fingerprint-Fit-Check (Binary passt zur Plattform? sonst Rebuild) + Precompile-Modus für ZIH (vorkompilierte Binaries mitbringen, dort nur run+measure).
- **Ehrliche ZIH-Realität:** PCM/RAPL brauchen Admin → auf ZIH-Knoten gesperrt; dort Fallback auf PAPI/perf-user-level bzw. Wall-Clock, **Energie nicht erhebbar**. Volle PMC-Tiefe nur auf deinem Laptop.

---

## 5. Maschinerie konfigurieren — Schritt für Schritt

Alle Befehle ab der Wurzel `Code/` (= `C:/Users/benja/OneDrive/Desktop/Diplomarbeit - Datenbanken/Code/`).
Konfiguration läuft über **CMake-Presets** (`Code/CMakePresets.json`); Build-Verzeichnis = `Code/build/<preset>/`.

### 5.1 Konfigurieren (einmal pro Preset)
```powershell
# Windows / MSVC (Default-Entwicklung):
cmake --preset msvc-release          # → build/msvc-release/   (Release-Vollausbau)
cmake --preset msvc-debug            # → build/msvc-debug/     (Debug)
# Linux (z.B. für ZIH-x86_64-Targets):
cmake --preset gcc-release           # → build/gcc-release/
```
Wichtige Cache-Variablen (im `_base`-Preset gesetzt): `COMDARE_V32_ENABLE=ON`, `COMDARE_BUILD_PERMUTATIONS=ON`,
`COMDARE_PERMUTATION_MODE=on_build_on_demand`, `COMDARE_PERMUTATION_PROFILE=smoke` (Stichprobe; für Vollausbau
auf `full`/`full_coverage` heben).

### 5.2 Bauen
```powershell
cmake --build --preset msvc-release                       # alles
cmake --build build/msvc-release --target comdare_perms_all   # Tier-Binaries (CE + prt-art Permutations-DLLs)
```

### 5.3 Messen (F15 / Prüf-Dock)
```powershell
# Beobachtende Messung über die realen Organ-DLLs (Pfad B, Observer + — künftig — HW-Counter):
build/msvc-release/.../comdare-f15-compare --observe <dll-verzeichnis>
# Direkter CSV-Export für die Pipeline (16 Spalten):
build/msvc-release/.../comdare-f15-compare --pipeline-csv <out.csv> --workload micro <dll-verzeichnis>
# Plugin-Discovery alternativ über Umgebungsvariable:  COMDARE_PERM_ROOT=<dll-verzeichnis>
```
(Nach Umsetzung der Mess-Abstraktion zusätzlich: `--measure-source=auto|intel|amd|arm|wallclock`.)

### 5.4 Pipeline schließen → PDF erzeugen
```powershell
cmake --build build/msvc-release --target comdare_pipeline_e2e
```
Dieser Ziel-Build treibt **01 Sample-CSV → 04 LaTeX-Tabelle + 05 TikZ-Diagramm → 06 PDF** und braucht `pdflatex`
(MiKTeX, vorhanden unter `…/MiKTeX/…/x64`). Ohne `pdflatex` entstehen Tabelle+Diagramm-`.tex`, aber kein PDF.

---

## 6. Wo kommt das PDF mit den Messdiagrammen heraus?

Das PDF wird IMMER **ins Build-Verzeichnis** geschrieben (nicht in die Quellen), unter `build/<preset>/…`:

| Zweck | Pfad (Beispiel-Preset) | Womit erzeugt |
|-------|------------------------|---------------|
| **Demo / Abnahme** (Sample-Daten, garantiert lauffähig ohne DLLs) | `build/<preset>/pipeline_e2e/pipeline_demo.pdf` | `--target comdare_pipeline_e2e` |
| **Reale i7-Organ-Messung** (P3-Beleg, echte ns-Zahlen) | `build/<preset>/pipeline_real_organ/pipeline_demo.pdf` | manueller Lauf (f15_compare `--pipeline-csv` → 04/05/06) |
| **Thesis-Hauptdokument** | `build/<preset>/thesis-final/main.pdf` | Thesis-LaTeX-Build (D1/D2-Volltext, user-manuell) |

> Das PDF enthält die **04-LaTeX-Tabelle** (CSV-Werte) + das **05-TikZ/pgfplots-Diagramm** (`--by-workload` gruppiert).
> Konkret vorhanden (Stand 2026-05-31): `Code/build/msvc-g1/pipeline_e2e/pipeline_demo.pdf`,
> `Code/build/msvc-g1/pipeline_real_organ/pipeline_demo.pdf`, `Code/build/msvc-g1/thesis-final/main.pdf`.
> `pipeline_demo.pdf` ist ein **Build-Artefakt** (Demonstration), KEIN Thesis-Volltext — der Thesis-Volltext (D1/D2)
> wird von dir manuell geschrieben; die Pipeline ersetzt nur die Mess-Artefakte in Kapitel 06.

**Merksatz:** „Die Messdiagramme liegen im jeweiligen Build-Ordner unter `pipeline_e2e/pipeline_demo.pdf` (Demo) bzw.
`pipeline_real_organ/pipeline_demo.pdf` (echte Daten); das Thesis-PDF unter `thesis-final/main.pdf`."

---

## 7. Das autonome /goal (zum Setzen)

Setze den folgenden Text per `/goal`, um die Mess-Abstraktion autonom abarbeiten zu lassen. Er verweist als
Programm auf den Plan und respektiert alle Direktiven.

> Fahre autonom fort, bis die einheitliche, vendor-/ISA-übergreifende **Mess-Abstraktion** der 3-Repo-Kette gemäß
> `Code/external/comdare-cache-engine/docs/sessions/20260531-mess-abstraktion-cross-platform-architektur-plan.md`
> umgesetzt ist — mit garantierter, Audit-Workflow-bestätigter Vollständigkeit. Arbeite die Inkremente in Reihenfolge ab:
>
> - **I1 (zuerst):** EIN autoritativer Mess-ABI-POD — `comdare_hw_counters_v1` per Major-Version-Bump auf die volle
>   16+6-Spaltenmenge erweitern (User-Entscheidung „ein einziger ABI-POD"); `ComdareMeasurementSnapshotV1` +
>   `kMeasurementSnapshotVersion`, `static_assert(standard_layout && trivially_copyable)`. ABI-Bruch bewusst → alle
>   Permutations-DLLs neu bauen, volle Regression grün.
> - **I2:** `IMeasurementSource`/`IPmcSource`-Interface + `WallClockSource` (garantierter, ZIH-tauglicher Fallback);
>   16+6-Spalten-CSV erscheint mit `resolution_mode`.
> - **I3:** Dock-Verkabelung — `IMeasurementSource*`-DI in `SearchAlgorithmDock` + `drive_tier_observe_trace_abi`;
>   `pull_live_counters` im `abi_adapter.hpp` endlich implementieren (Kanal existiert, war nie befüllt).
> - **I4:** `result_aggregator` 16+6 + `measurement_writer::make_record_from_snapshot`; P5-Konsolidierung der zwei
>   Plugin-ABIs auf die EINE autoritative Mess-Quelle (Sub-Interface-Status-Enum, `MeasurementResolution`).
> - Danach (beschaffungs-/plattform-gated, soweit lokal machbar): **I5** Intel-PCM-Source (gated auf User-Treiber-Setup
>   gem. `20260531-p4-pmc-intel-pcm-plan.md`) bzw. ARM-PAPI; **I6** `ArchEvaluator` am Dock; **I7** Plattform-Fingerprint
>   + `platform_fit_check.cmake` (Rebuild bei Plattform-Mismatch); **I8** `precompile_mode.cmake` (NORMAL/PRECOMPILE/
>   PRECOMPILED) + `precompile_batch_builder` für den ZIH-Fall (run+measure ohne Compile); **I9** restliche Vendor-Quellen.
>
> Garantie & Disziplin: (A) Lebendiges Ledger `architektur-ziele-offene-punkte-ledger.md` = Single-Source-of-Truth;
> kein Punkt „done" ohne literale Code-/Test-/Mess-Evidenz + Commit-Ref; Vendor-Event-Codes pro Event web-verifizieren.
> (B) Pro Inkrement: bauen + Regression grün, dann done-verified. (C) Abschluss: I1–I4 umgesetzt + ein Audit-Workflow
> bestätigt die vendor-neutrale Mess-Kette end-to-end (16+6-CSV mit echten Wall-Clock/Observer-Werten → PDF); I5–I9 +
> ZIH-Precompile + PCM-Treiber als getrennt geführte gated/Folge-Punkte. (D) Autonom, nicht fragen außer bei echter
> Unklarheit (dann Planrunde); destruktive Ops in den 3 Thesis-Repos mit Tag+Commit+Push; Submodul-Sync nach jedem
> Push; KEIN Eingriff in D1/D2-Volltext; ABI-Bruch (I1) bewusst + mit Tag abgesichert.

---

## 8. Was DU parallel für die volle HW-Messung tun kannst (optional, gated)

Nur falls du echte L1/L3/Energie-Counter auf dem Laptop willst (I5 Intel-PCM) — Details + Befehle in
`…/20260531-p4-pmc-intel-pcm-plan.md`. Kürzest: Memory Integrity temporär aus (Secure Boot ist bereits aus) →
PCM `202604` bauen → MSR-Treiber test-signieren → `pcm.exe`-Funktionstest. Für ZIH ist das **nicht** nötig (dort
Wall-Clock/PAPI). Das Rückgrat I1–I4 läuft komplett ohne dieses Setup.
