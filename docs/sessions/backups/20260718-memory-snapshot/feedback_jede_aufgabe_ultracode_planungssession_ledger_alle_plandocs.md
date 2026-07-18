---
name: feedback_jede_aufgabe_ultracode_planungssession_ledger_alle_plandocs
description: "JEDE Aufgabe wird durch eine ultracode-Planungssession über Ledger + ALLE Planungsdokumente vorbereitet (Systemkomplexität passt nicht vollständig in einen Kontext); Bau-Phasen gibt der User nach Vorlage des Plans EXPLIZIT frei"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

User-Direktive (2026-07-17, verbatim): „**Jede Aufgabe muss durch eine ultracode Planungssession über ledger und ALLE Planungsdokumente vorbereitet werden, weil diese Bestandteile aufgrund der Systemkomplexität nicht alle vollständig in den Kontext passen können.**" Ergänzend im selben Auftrag: „Bereite die Bau-Phase vor, **ich gebe sie danach explizit frei** und wir überschreiben die Direktive des Anhaltens."

**Why:** Ledger (~1800+ Zeilen) + ~20 Design-Dossiers + Ist-Code übersteigen jeden Einzel-Kontext; ohne Workflow-gestützte Voll-Erfassung entstehen Entscheidungen auf Teilbild (Anlass-Historie: v32-Parallel-Engine, #31-Fehlbau). Zudem trennt der User Planung (autonom, Workflow) von Bau (explizite Freigabe je Phase).

**How to apply:** Vor JEDER Aufgabe (auch bereits GO'ten Increments wie INC-0/1/2): (1) ultracode-Workflow mit parallelen Erfassungs-Strängen über die relevanten Ledger-Sektionen + ALLE einschlägigen Plandokumente (`docs/sessions/backups/`) + Ist-Code + Verifikations-Harness → Synthese = Bauplan-Dossier in `docs/sessions/backups/<datum>-<aufgabe>/`; (2) Plan dem User vorlegen; (3) Bau erst nach EXPLIZITER Freigabe der Bau-Phase (dann gilt die Anhalte-Direktive als überschrieben). Verschärft [[feedback_ledger_komplett_plus_ultracode_richtung_vor_abschnitten]] + [[feedback_before_each_todo_agent_reads_full_ledger_then_manual_details]]; siehe [[feedback_open_decision_first_reread_ledger_and_plandocs]], [[project_diplomarbeit_stand_20260717_volles_go_bau_roadmap]].

**VERSCHÄRFUNG (2026-07-17 Abend, verbatim):** „**stets zu jeder Aufgabe und Entscheidung, die vom Plan abweichen könnte, erst einen ultracode Planungs-Workflow gegen Ledger und Pläne durchziehen, um wirklich auf der Spur der Konformität zu bleiben, NIEMALS etwas erfinden oder raten.**" ⇒ Der Trigger ist nicht nur „neue Aufgabe", sondern **jede Entscheidung mit Abweichungs-Potenzial vom Plan** (neuer Increment, Architektur-Naht, Schwellen-/Flag-Änderung, Interpretation einer Auflage). Reine Ausführung eines bereits belegten Plan-Schritts (z. B. eine vom Konformitäts-Verdikt konkret gelistete Doku-Korrektur) braucht keinen neuen Workflow; sobald aber Ermessen/Neu-Design im Spiel ist → ultracode gegen Ledger+Pläne ZUERST, Konformität literal belegen, nie raten. Kopplung: [[feedback_never_guess_always_lookup_state_of_art_and_docs]] + [[feedback_increments_architekturkonform_nicht_nur_gruen]].
