---
name: feedback_dual_verifikation_baremetal_lokal_und_ci_synchron_gruen
description: "Bau-Direktive (User 2026-07-17): bare-metal auf starker Maschine — GitLab-CI-Stand UND lokal kompilierter Standalone-Modus müssen ZU JEDER ZEIT parallel geprüft/verifiziert/getestet sein; grüne Pipeline ⇔ grüne lokale Tests (beide Richtungen)"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

User-Direktive (2026-07-17, mit der INC-0-Bau-Freigabe, verbatim-treu): „du befindest dich bare metal auf einer starken Maschine und kannst somit sowohl per gitlab commit den CI-Stand des Projektes, als auch lokal kompiliert den standalone Modus des Projektes synchron testen. **Beide Stände müssen zu jeder Zeit parallel geprüft und verifiziert, sowie getestet sein. Eine grüne Pipeline braucht also immer grüne lokale Tests und umgekehrt.**"

**Why:** Der §20.D-B2/B4-Befund zeigte, dass super-Sub-Build und ce-standalone unterschiedliche Config-Gaps aufdecken (Include-Root, `-mcx16`-Kette); nur die synchrone Doppel-Verifikation macht beide Pfade ehrlich messfähig (Deadline 28.07.: CI UND standalone).

**GEPARKT (User-Direktive 2026-07-17, später am Tag, verbatim-treu):** „Bitte baue das gesamte Projekt doch erst lokal auf, bevor du die CI Strategy zusätzlich zur local strategy nachziehst, das geht schneller. **Die Direktive der parallelen Checks zwischen CI und lokalen Tests wird bis zum Abschluss aller Aufgaben geparkt und dann nachgezogen.**"

**How to apply (aktuell gültig):** **Lokal-first:** je Increment BEIDE lokale Pfade literal verifizieren — ce-standalone (`build-conf`) UND super-Sub-Build (`build-i2`, PFLICHT §0-GOAL-V6.7) kompilieren + ctest + Smoke; granular committen + beide Remotes pushen. Das **CI-Grün-Gate je Increment ist GEPARKT** — kein Warten auf Pipelines während der Bau-Phase. **NACH Abschluss aller Aufgaben:** CI-Strategie gesammelt nachziehen und alle Pipelines grün bestätigen ([[feedback_verify_gitlab_pipeline_green_after_push]]). Lokale Grün-Behauptungen nur mit wörtlicher Ausgabe ([[feedback_no_success_marks_without_literal_output]]); [[feedback_ci_infra_blocked_proceed_local_double_verify_mode_a]] bleibt das Muster (lokal-doppelt-verifiziert + beide-Remotes-batch).
