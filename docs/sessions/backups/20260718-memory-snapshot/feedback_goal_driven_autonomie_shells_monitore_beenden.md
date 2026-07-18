---
name: feedback_goal_driven_autonomie_shells_monitore_beenden
description: "User 06.07.: NUR das Goal sichert den autonomen Betrieb — nicht Monitore/Shells. Am Ende jedes Arbeitszyklus ALLE Shells und Monitore beenden, das Goal abwarten (Stop-Hook re-invoked), Notwendiges im neuen Zyklus erneut starten. Fortschritt muss goal-driven sein."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive (2026-07-06, wörtlich sinngemäß):** „Die Annahme ist falsch, dass die Monitore den autonomen Betrieb sichern — nur das Goal tut das. Bitte merke dir, dass du alle Shells und Monitore beendest, das Goal abwartest und Notwendiges erneut startest. Der Fortschritt muss goal-driven sein."

**Why:** Session-gebundene Monitore/Hintergrund-Shells sterben mit der Session/dem Kontext und suggerieren eine Kontinuität, die es nicht gibt (Beleg 06.07.: Monitor-Blickfeld-Lücke wirkte wie Autonomie-Bruch). Der einzige echte Autonomie-Träger ist der Goal-Mechanismus (Stop-Hook re-invoked die Arbeit mit dem Goal-Text) — er überlebt Kontext-Enden und treibt den nächsten Zyklus deterministisch an.

**How to apply:**
1. Arbeitszyklus goal-driven schneiden: Increment fertigstellen → Beweise/Doku/Commits → dann ALLE eigenen Hintergrund-Shells und Monitore per TaskStop beenden — NIE dangling hängen lassen. PRÄZISIERUNG (User 06.07. abends): Beim erneuten Goal-Zyklus-Aufruf die nötigen Monitore NEU starten, sofern etwas Neues gebaut wird; nach erfolgreichem Abschluss der Programmieraufgabe wieder beenden.
2. Turn/Zyklus enden lassen und das Goal den nächsten Zyklus starten lassen; dort den Ist-Stand frisch verifizieren und die Zyklus-Monitore SOFORT neu bewaffnen. PRÄZISIERUNG (User 06.07. spät): INNERHALB des Zyklus REGELMÄSSIG die Monitore nutzen statt wiederholter API-Schnappschüsse — Monitore sparen Tokens (Events nur bei Änderung), Schnappschuss-Polling verschwendet sie.
3. Host-seitige Dauer-Aufgaben (z. B. Runner-Freeze-Abfang) gehören in HOST-Mechanik (systemd-Timer/Watchdogs), nie in Session-Monitore — die Session-Monitore sind reine Zyklus-Werkzeuge.
4. Monitor-Qualitätsregeln bleiben für die Zyklus-Nutzung gültig ([[feedback_monitore_duerfen_nie_stumm_haengen_vollblick_heartbeat]]), ändern aber nichts an der Beende-Pflicht am Zyklusende.

Verwandt: [[feedback_verify_gitlab_pipeline_green_after_push]] (Grün-Beweis je Hauptaufgabe gehört IN den Zyklus).
