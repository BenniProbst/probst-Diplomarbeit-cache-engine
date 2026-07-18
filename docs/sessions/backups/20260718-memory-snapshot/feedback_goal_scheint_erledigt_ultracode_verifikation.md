---
name: feedback_goal_scheint_erledigt_ultracode_verifikation
description: "Wenn ein Goal erledigt SCHEINT, den Hook/Abschluss um einen ultracode-Verifikations-Workflow erweitern; nicht bei offensichtlich unfertigem Goal"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**Direktive (User, 10.07.2026):** „Wenn ein goal erledigt scheint, erweitere den hook so, dass er einen ultracode workflow startet, um das zu verifizieren. Das machst du aber nicht, wenn das goal sehr offensichtlich noch nicht erledigt ist und von allein weiter zieht."

**Why:** Scheinbare Erledigung ist die gefährlichste Stelle (plausible-aber-falsche Grün-Bescheinigung — vgl. wf_fce92d2c-Lehre); ein adversarialer Workflow prüft billiger als ein Fehl-Abschluss kostet. Bei offensichtlich unfertigen Goals wäre er dagegen reine Token-Verschwendung.

**How to apply:** Bevor ein Goal-/Stop-Hook-Zustand als ERFÜLLT gemeldet wird: EINEN ultracode-Verifikations-Workflow starten (Finder über die Goal-Kriterien + adversariale Verifier gegen Ledger/Code/CI-Ist), Verdikt abwarten, Rohdaten als Backup sichern ([[feedback_e_schichten_separat_fertigstellen_top_down]]-Muster). Läuft das Goal offensichtlich weiter (Stack nicht leer, Increments offen), KEINEN Verifikations-Workflow starten — einfach weiterarbeiten. Verwandt: [[feedback_ultracode_workflow_for_uncertainty_and_absolute_claims]].
