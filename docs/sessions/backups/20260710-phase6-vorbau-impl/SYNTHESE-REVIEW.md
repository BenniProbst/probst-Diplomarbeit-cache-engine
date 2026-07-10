# SYNTHESE — Adversarialer Review „Phase-6-Vorbau" (wf_c99a2132-d7f)

> DATEN_GATED-Vorbau (BACKLOG): IMeasurementSource + MeasurementAxisRegistry + E4'-Kurven-Fit-Skeleton.
> Implementierung: Claude selbst. 18 Agenten (3 Finder × 2-Lens), 796k Tokens, 248 Tool-Calls.
> Verdikt: **15 Kandidaten, 14 CONFIRMED / 1 refutiert** — ALLE 14 vor Commit gefixt.
> Rohdaten: rohdaten-review/ (Journal + Skript + Ergebnis). Dossier: DOSSIER.md (dieser Ordner).

## Die 14 CONFIRMED und ihre Fixes

**Interface (i_measurement_source.hpp):**
1. [major] read_delta-Ziel builder::PmcCounters konnte Cycles/Instructions/MemStall strukturell nie
   liefern (Sackgassen-POD für die Folge-Verdrahtung) ⇒ **eigenes vollständiges MeasuredDelta**
   (value[10] + valid[10] je Event, honest: valid=false heißt NICHT gemessen).
2. [major] WallClockSource war wieder der Platzhalter (leere begin/end, immer 0 trotz Cycles-Cap)
   ⇒ echter Plan-§2.2-Cycles-PROXY aus steady_clock (ns-Delta, valid nur Cycles).
3. [major] Adapter-Caps-Lüge (pauschal 7 Events + has_energy-Widerspruch; real liefern linux_perf
   nur L1d/LL/dTLB, windows_pcm nur L2/L3) ⇒ Caps als STRUKTURELL dokumentiert, has_energy
   konsistent, per-Messung-Wahrheit über MeasuredDelta::valid (grob-granular — Ehrlichkeits-Grenze
   der IPmcSource-API, dokumentiert; Verfeinerung = P4/Folge).
4. open() ignorierte die Event-Liste ⇒ detail::validate_events: unsupported ⇒ EventUnsupported.
5. Adapter-last_ nie zurückgesetzt (stale Delta nach close/re-open/abgebrochenem Intervall)
   ⇒ Reset in open/begin/close.

**Registry:**
6. [major] Enum-Drift nicht compile-time erzwungen (17. Kategorie kompilierte still mit 16, weil
   regime_of einen Default-Zweig hat) ⇒ kMeasurementCategoryCount als Single-Source DIREKT am Enum
   (measurement_category.hpp, additiv) + Registry-Kopplung; Drift bricht jetzt im static_assert.
7. Überbreiter Include (curve_fit zog Registry→system_axis→observable_tier+pmc_source in jeden
   Konsumenten) ⇒ curve_fit inkludiert nur noch measurement_category.hpp.

**Kurven-Skeleton (curve_fit.hpp):**
8. [critical] fit_log_linear lieferte **Ok mit NaN** bei x==0 (log2(0)=-inf) — Phantom-Wert-Verbot
   verletzt ⇒ neuer FitStatus::InvalidData (x==0/nicht-endlich) + isfinite-Schutznetz (NIE Ok+NaN).
9. Nicht-numerische Zellen („n/a") wurden still zu Phantom-Punkten (0,0) ⇒ streng-numerische
   Zell-Parser (ganze Zelle konsumiert) + skipped_rows-Diagnose-Zähler.
10. det==0-Guard fing identische x bei Gleitkomma-Rundung nicht (det=9e-13 ⇒ Phantom-Fit)
    ⇒ normalisierter Varianz-Guard (var_x > 1e-9).
11.+13. „WIDE-CSV-Spalten-Leser"-Behauptung war gegen den Bestand erfunden: die reale lazy_csv_header-
    CSV ist SEMIKOLON-separiert mit Spalten working_set_n/op_<art>_p99_ns/pmc_* — Registry-Namen sind
    E4-REPORTING-Vokabular ⇒ Kopf-Kommentar stellt die Spalten-Wahrheit klar, Leser ist
    dialekt-parametrisiert (delimiter, Default ';'), Mapping Registry→Bestands-Spalte = E4'-Folge;
    Test nutzt jetzt den REALEN Dialekt + reale Spaltennamen.
12. CRLF brach das Header-Matching (LATENCY_P99\r) ⇒ \r-Strip im Zeilen-Split.
14. RFC-4180-Quotes verschoben Spalten (Repo-Writer csv_quote quotet!) ⇒ minimales Quote-Handling.

**Refutiert (1):** fehlendes <cstdlib> — auf 9 Toolchains (MSVC 19.41-19.50, libc++ inkl.
REMOVE_TRANSITIVE_INCLUDES) empirisch grün; als IWYU-Hygiene trotzdem ergänzt.

## End-Beweise (literal, offizieller g++-16-Baum)
test_phase6_vorbau „ALLE OK" · voller ctest **199/199** · clang-format==0 · Mojibake==0 ·
system_axis.hpp/pmc_source.hpp/PODs byte-unberührt (measurement_category.hpp NUR additiv:
kMeasurementCategoryCount).
