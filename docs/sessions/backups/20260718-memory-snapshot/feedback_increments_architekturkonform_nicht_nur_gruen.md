---
name: feedback_increments_architekturkonform_nicht_nur_gruen
description: "Jeder Bau-Schritt PFLICHT architekturkonform zu den Planungsdokumenten, nicht nur ctest-grün"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

Ein Increment (z.B. Bau-INC-2c) ist NICHT erledigt, wenn es nur compile-/ctest-grün ist. **Pflicht:** jeder
einzelne Schritt muss zusätzlich **architekturkonform zu den Planungsdokumenten** sein (F12III-DESIGN-VORLAGE,
BAUPLAN-INC2, Ledger §-Vorgaben, Doc-30-Slot-Konvention).

**Why:** Grün ≠ korrekt. Man kann Tests durch Anpassen von Erwartungswerten grün machen, ohne dass der Umbau
der geplanten Architektur entspricht — genau das will der User NICHT (verwandt: [[feedback_no_quick_fixes]],
[[feedback_diplomarbeit_design_ist_quelle_der_implementierung]], [[feedback_no_success_marks_without_literal_output]]).
Anlass: 2026-07-17 während INC-2c-Telemetrie-Herauslösung; zuvor hatte ich 2 Test-Stellen abgekürzt
(1 Test ersatzlos gelöscht, 1 hart→weich abgeschwächt) statt sauber umzuwidmen — der User fragte explizit nach.

**How to apply:** Nach compile+ctest-grün je Increment eine EXPLIZITE Konformitäts-Prüfung gegen die
Planungsdokumente fahren: (1) entspricht der Schnitt exakt der Design-Vorlage (Slot-Zahlen, Schicht-Verortung,
System- vs. Organ-Achse)? (2) Wurde nichts nur „grün gemacht" (gelöschter/abgeschwächter Test statt umgewidmet)?
(3) Negativ-Guards positiv formulieren (beweisen, dass die neue Invariante gilt, nicht nur `!=alt`). Erst
danach committen. Beim Bericht die Konformität literal belegen, nicht behaupten.
