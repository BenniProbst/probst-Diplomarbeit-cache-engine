---
name: feedback_monitore_duerfen_nie_stumm_haengen_vollblick_heartbeat
description: "User 06.07.: Bei autonomer Arbeit dürfen Monitore NIE stumm hängen oder Ereignisse verpassen — Pipeline-Monitore müssen ALLE offenen Pipelines je Projekt tracken (nicht nur die neueste je ref) + Heartbeat, damit Hängen sichtbar wird"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive (2026-07-06, wörtlich sinngemäß):** „Jetzt hängt dein Monitor, obwohl die Pipeline fertig ist. Wollen wir autonom arbeiten, dann darf das nicht mehr passieren."

**Anlass:** Mein Pipeline-Monitor trackte je Repo/Branch nur die NEUESTE Pipeline (`pipelines?ref=X&per_page=1`). Als eine neuere Pipeline (8096, super-Kind) auf ce/main erschien, fiel die noch laufende ältere (8093) aus dem Blickfeld — ihr running→success-Übergang wurde nie gemeldet. Kein Prozess-Hang, sondern ein Blickfeld-Designfehler; wirkt für den User identisch zu einem Hänger.

**Why:** Autonomes Arbeiten steht und fällt mit verlässlichen Wecksignalen. Ein Monitor, der Ereignisse verpasst oder still stirbt, blockiert den gesamten autonomen Fluss (User muss manuell anstoßen = Autonomie kaputt).

**How to apply:**
1. Pipeline-Monitore: pro Projekt ALLE nicht-terminalen Pipelines listen (z. B. `per_page=6`, Filter auf created/pending/running/…) und den Zustandsstring über ALLE offenen bilden — nie nur „neueste je ref".
2. IMMER Heartbeat einbauen (kürzer als die typische Job-Dauer — hier 5 min (Pipelines max ~8 min); eine „Monitor lebt, unverändert"-Zeile), damit Stille von Tod/Hang unterscheidbar ist.
3. Jeden curl/Netz-Call im Loop mit hartem Timeout (`timeout 15 curl -m 10 …`) + expliziten `api-err`-Zustand als eigenen Statuswechsel melden.
4. Erwartete Terminal-Ereignisse, die der Monitor NICHT binnen erwarteter Frist meldet, manuell per API gegenprüfen (Monitor-Ausgabedatei-mtime als Lebend-Indikator).
5. Gleiche Disziplin für Detektoren (Runner-Freeze etc.): Schwellen so wählen, dass legitime Zustände (z. B. beide Slots belegt → contacted_at altert) keine Fehlalarme erzeugen; Reaktion gehört in serverseitige Watchdogs (systemd-Timer), Session-Monitore nur als Anomalie-Netz.

Verwandt: [[feedback_no_success_marks_without_literal_output]] · [[feedback_prod_ci_measurement_multiday_experiment]] (Ausnahme: mehrtägige Mess-Pipelines nicht aktiv pollen).
