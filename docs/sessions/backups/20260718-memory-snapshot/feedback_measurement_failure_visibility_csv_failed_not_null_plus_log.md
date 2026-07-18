---
name: feedback_measurement_failure_visibility_csv_failed_not_null_plus_log
description: "Wissenschaftliche Fehler-Sichtbarkeit — scheitert ein Achsen-Algorithmus, steht in der CSV-Zelle \"failed\" (NICHT null), plus ein neben der CSV aggregierter Log dokumentiert den Experiment-Fortschritt; macht Verprogrammierung oder ISA+OS-Inkompatibilität sichtbar"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

Fehler-Sichtbarkeit im Mess-Output (User 2026-07-16, Verschärfung von honest-100%): „In der Wissenschaft geht nicht immer alles glatt, aber das muss SICHTBAR sein."

- Scheitert ein Algorithmus einer Achse (Crash / Exception / nicht lauffähig), steht in der Messwert-Zelle **"failed"** — **NICHT null/0**.
- Zusätzlich wird **neben der CSV ein Log aggregiert**, der den Experiment-Fortschritt DIESER CSV dokumentiert (was scheiterte, wo, warum).
- Damit ist klar erkennbar: entweder hat sich der Forschende **verprogrammiert** ODER der Algorithmus läuft auf **DIESER ISA+OS** einfach nicht.
- **Konsequenz:** der Mess-Harness muss **robust gegen per-Algorithmus-Fehler** sein — Fehler fangen → Zelle="failed" + Log → **weitermessen**, NICHT den ganzen Lauf abbrechen. Beispiel: der A07-snmalloc-Laufzeit-Segfault (g++16/glibc, `V31AdapterAlloc.A07_Snmalloc`) → A07 auf dieser ISA+OS = ehrlich "failed", statt Lauf-Crash oder Phantom-Null.

**Why:** honest-100% (kein Phantom-Null; ein Fehler ist ehrlich "failed"); macht Fehl-Programmierung + Plattform-Inkompatibilität wissenschaftlich sichtbar.

**How to apply:** Mess-CSV-Zelle = "failed" bei Algo-Fehler (nicht 0/null); Log-Aggregat neben der CSV je Experiment-Fortschritt; Harness fängt per-Algorithmus-Fehler + misst die übrigen Permutationen weiter. Siehe [[feedback_serialization_flat_systemaxis_folders_deep_tier_tree_dynamic_only_columns]], [[feedback_no_success_marks_without_literal_output]], [[feedback_measurement_modes_debug_parallel_measure_singlethread_planer_generates_ci_cmake]].
