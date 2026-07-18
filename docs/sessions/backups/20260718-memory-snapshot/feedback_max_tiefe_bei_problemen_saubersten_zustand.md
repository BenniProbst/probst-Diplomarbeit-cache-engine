---
name: feedback_max_tiefe_bei_problemen_saubersten_zustand
description: "Bei gefundenem Problem maximale Tiefe fahren, echte Wurzel beheben, saubersten Zustand hinterlassen — auch wenn GO + viel Arbeit"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

Sobald ein Problem gefunden ist (Bug, Defekt, Infra-Störung), NICHT bei Absicherung/Workaround stehenbleiben — die **echte Ursache** finden und **an der Wurzel beheben**, mit **maximaler Tiefe**, und alles im **saubersten Zustand** hinterlassen. Das gilt ausdrücklich auch dann, wenn es ein explizites GO des Users und viel Arbeit bedeutet — der User gibt dieses GO in dem Fall.

**Why:** Absichern (z. B. defekten Runner pausieren statt den Node zu fixen) lässt das Problem bestehen; der User will Wurzel-Behebung, nicht Symptom-Verwaltung. Ein Workaround als Endzustand ist inakzeptabel.

**How to apply:** Bei jedem gefundenen Problem: (1) Root-Cause-Diagnose in voller Tiefe — auch tiefere System-/Infra-Ebenen, read-only zuerst; (2) echte Behebung an der Wurzel; (3) verifizieren, dass es grün/sauber läuft (literaler Beleg, kein Success-Mark ohne Ausgabe); (4) sauberen Endzustand hinterlassen (Doku aktuell, reversible Notmaßnahmen wie Runner-Pause zurücknehmen, TODOs schließen). Anlass 2026-07-09: prod2-`cmake`-configure-Hang — Runner-Pause war nur Absicherung; User verlangt die echte Node-Ursache (stale Mount / I/O) + Fix. Verwandt: [[feedback_no_quick_fixes]], [[feedback_infra_cleanest_not_easiest]], [[feedback_no_success_marks_without_literal_output]].
