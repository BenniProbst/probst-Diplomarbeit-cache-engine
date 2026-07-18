---
name: feedback_goal_hook_thorough_read_in_never_guess
description: "User 2026-07-08 — bei JEDEM auftretenden Goal-Hook (Stop-Hook-Re-Invoke) gruendlich einlesen (alle Memories + Ledger + betroffene Ist-Struktur), NIE raten, IMMER verifizieren, bevor gehandelt oder behauptet wird"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive (2026-07-08):** „Bitte merke dir, dich zu jedem auftretenden Goal-Hook gruendlich einzulesen, um nie zu raten und immer zu verifizieren."

**Anlass (konkreter Fehler):** In einem Goal-Hook-Zyklus schrieb ich ein Owner-Handover mit der Behauptung „`comdare-db-client-*` in licensing-all sind fehlplatziert" — ohne die Ist-Struktur + die bereits vorhandene Umbrella-SOLL-Memory gruendlich nachzulesen. Der User korrigierte: es gibt **generische client- UND server-Module** (licensing = kanonisches Beispiel `client/`+`server/`, db-client-* = „Base client modules"). Der korrekte Befund stand bereits in [[feedback_umbrella_soll_struktur_trackt_alles_ausser_baseline_zellen]] + im licensing-README — ich hatte geraten statt gelesen.

**Why:** Goal-Hook-Re-Invokes starten oft mit frischem/gekuerztem Kontext; die Versuchung, aus dem Gedaechtnis oder aus veralteten Task-Notizen (z.B. stale #38-Annahme) zu handeln, fuehrt zu falschen Behauptungen in dauerhaften Artefakten (Handover, Ledger). Verstaerkt [[feedback_never_guess_always_lookup_state_of_art_and_docs]], [[feedback_immer_ledger_zuerst_lesen_vor_handeln]], [[feedback_thorough_assumptions_workflow_planning]].

**How to apply:** Bei JEDEM Goal-Hook-Feuern ZUERST der Pflicht-Einstieg, BEVOR irgendetwas behauptet/geschrieben/mutiert wird: (1) ALLE Memories laden (MEMORY.md + Dateien); (2) den relevanten Ledger-Abschnitt lesen; (3) die konkret betroffene **Ist-Struktur live verifizieren** (Verzeichnis/README/Code/git — nicht aus einer Task-Notiz ableiten, die stale sein kann); (4) jede Absolut-/„fehlplatziert"-/„defekt"-Behauptung gegen die autoritative Doku + Live-Ist gegenpruefen, sonst NICHT schreiben. Stale Task-/Board-Notizen sind Verdachtsmomente, KEINE Beweise — vor Uebernahme in ein dauerhaftes Artefakt verifizieren. Lieber teuer nachlesen als raten.
