---
name: feedback_ci_gesamtlauf_ist_messung_abgeschaltet_pdf_kompiliert
description: "Der CI-Gesamtlauf (der grün werden MUSS) = Diplomarbeit-super-Pipeline mit ABGESCHALTETER Messung, sonst alles an, wenn sie die comdare-cache-engine nutzt; der ganze Lauf muss durch, damit die Messwerte ins Diplomarbeit-PDF kompilieren. Der echte wissenschaftliche Messlauf (golden-320, mehrtägig, Cluster) ist davon getrennt/opt-in"
metadata:
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**Direktive (2026-07-11):** Als „Gesamtlauf" der Diplomarbeit zählt der super-Pipeline-Lauf **mit
abgeschalteter Messung** (sonst alles an), wenn er die comdare-cache-engine verwendet. Dieser Lauf muss
**vollständig grün durch** — denn erst der komplette Durchlauf kompiliert die (vorhandenen) Messwerte ins
Diplomarbeit-PDF (`thesis:pdf`-Stage, Mess→PDF-Fluss).

**Warum / Trennung:**
- Der **CI-Gesamtlauf** ist das schnelle, wiederholbare Grün-Ziel: Messung AUS (keine mehrtägige echte
  Vermessung im CI), aber ALLE anderen Stages laufen — lint → submodules → analyse (Werkzeuge bauen) → test →
  integration → manifest → **thesis-pdf** (PDF aus den bereits vorhandenen Mess-Daten kompilieren).
- Der **echte wissenschaftliche Messlauf** (golden-320, Coverage) ist DAVON getrennt: mehrtägig, auf dem
  Cluster (perf_event_open/MSR baremetal), als eigener opt-in CI-Job (`$COMDARE_RUN_MEASURE==true`) oder
  detached. Siehe [[feedback_autonomous_measurement_via_ci_job_authorized]] und
  [[feedback_production_track_full_golden_run_finds_errors]].

**Wie anwenden:** Wenn der User sagt „der Diplomarbeit-Lauf ist rot" / „der Gesamtlauf muss durch", ist das
Ziel = super-Pipeline (development/main) mit Messung AUS komplett grün, insb. `thesis:pdf` erreicht. Aktueller
Wurzel-Blocker (Pipeline 9670, 2026-07-11): `verify:submodules` + `test:unit` failen am get_sources
(Cross-Projekt-Private-Submodul-Klon-Auth) → ALLE nachgelagerten Stages inkl. `thesis:pdf` werden **skipped**.
D.h. der Submodul-Auth-Fix ([[reference_super_ci_cannot_fetch_new_ce_submodule_commits]]) ist die EINE
Bedingung, damit der ganze Mess→PDF-Fluss überhaupt durchlaufen kann. Messung im CI bleibt dabei aus.
