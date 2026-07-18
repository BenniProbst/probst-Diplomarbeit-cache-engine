---
name: feedback_ci_gruen_messfaehig_nur_punktuelle_refactorings
description: "Stand 10.07.2026 — CI-System weitgehend grün + messfähig, Kern vollständig vorhanden; ab jetzt nur PUNKTUELLE Refactorings, kein Greenfield"
metadata: 
  node_type: memory
  type: project
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Rahmung (10.07.2026):** „Wir haben derzeit ein weitgehend grün getestetes CI-System, welches auch
messen kann. Es ist alles im Kern vorhanden, alles was es jetzt braucht sind punktuelle Refactorings."

**Why:** Der verbleibende Diplomarbeit-Weg ist KEIN Greenfield-Bau mehr — die E4→E1-Maschinerie, das
Mess-System, der Experiment-Baum, die 19 Achsen-Interfaces und die CI (ce c022ce05, ctest 199/199) stehen.
Was fehlt, sind gezielte Nachbesserungen: fehlende Unter-Achsen einhängen, Utilization-Lücken schließen
(Achsen-Interfaces echt cross-applizieren), das Messkurven-Typsystem verdrahten, die Fork-Entscheidungen
umsetzen. Das schützt vor dem Fehler, große neue Konstrukte zu bauen, wo ein punktueller Refactor genügt.

**How to apply:** Vor jedem Increment fragen: „ist das ein punktueller Refactor an vorhandenem Kern, oder
baue ich etwas Neues?" — Neubau nur, wo der Kern die geforderte Eigenschaft nachweislich nicht hat
(deep research zuerst). Bevorzugt bestehende Interfaces/Strategien erweitern statt Parallelkonstrukte
(vgl. der verworfene axis_binding_registry-Doppelquellen-Fehler). Verwandt:
[[feedback_no_quick_fixes]], [[feedback_heuristik_messkurven_typsystem_chain_of_responsibility]],
[[feedback_metaprogrammierung_compile_time_zwingend_durchsetzen]].
