---
name: feedback_thorough_assumptions_workflow_planning
description: "Jede Annahme gründlich verifizieren (nie raten) + Aufgaben mit einem Workflow PLANEN, bevor losgearbeitet wird (User 2026-06-18, unter ultracode)"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 78cf67f8-571e-4fcd-a907-1556dbc5be72
---

KRITISCH (User 2026-06-18, ultracode-Modus): **(1) JEDE Annahme gründlich bearbeiten** = literal verifizieren statt
voraussetzen — keine Aussage/Marke ohne Evidenz, symmetrisch auch für Fehler-/Phantom-Marken (Anlass: meine voreilige
„node_type_find = ECHTER PHANTOM"-Marke, die die Code-Prüfung `axis_04_node_type_observable.hpp:57-68` zu „Single-Probe-
Observer-Zähler, kein fabrizierter Wert" korrigierte). **(2) Aufgaben mit einem WORKFLOW PLANEN, BEVOR mit der Umsetzung
begonnen wird** — die Planungssession ist als Multi-Agent-Workflow zu orchestrieren (Erdung/Verständnis fan-out → adversariale
Verifikation der Annahmen → Synthese eines Plans), nicht ad hoc loszulegen.

**Why:** Verschärft [[feedback_never_guess_always_lookup_state_of_art_and_docs]] um den konkreten Workflow-Mechanismus.
Voreilige Annahmen + ungeplantes Losarbeiten führten wiederholt zu Fehl-Marken und Architektur-Verstößen.

**How to apply:** Bei JEDER substanziellen Aufgabe ZUERST einen Workflow zum Erden/Planen fahren (Doku/Code/Ist literal lesen,
jede Annahme gegen Evidenz prüfen, adversarial verifizieren, Synthese), DANN erst umsetzen — ggf. ein zweiter Workflow für die
Umsetzung. Triviale/konversationelle Turns ausgenommen. Verwandt: [[feedback_no_success_marks_without_literal_output]]
[[reference_thesis_core_contribution_axis_library]].
