---
name: feedback_never_use_askuserquestion_crashes_session
description: AskUserQuestion-Tool crasht die Terminal-Session des Users (PowerShell-Neustart nötig) — NIE verwenden; Forks/Auswahl immer als Klartext vorschlagen
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 885d4915-6f41-4b18-9770-e729576e9fee
---

Das **AskUserQuestion-Tool crasht die Session des Users** (er musste PowerShell neu starten — 2026-07-01, mehrfach). → **NIE AskUserQuestion verwenden.** Rückfragen, Architektur-/Gate-Forks und Auswahloptionen IMMER als **Klartext** in der Antwort formulieren; der User antwortet dann normal in der nächsten Nachricht.

**Why:** Das interaktive Frage-UI bringt das Terminal zum Absturz → Kontext-/Zeitverlust + manueller Session-Neustart.

**How to apply:** Bei Gabelungen (Gate/Architektur/Sizing) die Optionen + klare Empfehlung als nummerierte **Klartext**-Liste schreiben und auf die Antwort warten. Bei reversibler/bereits freigegebener Aktion direkt fortfahren + narrieren statt fragen. Ersetzt die frühere Direktive „ask Rückfragen at forks" mechanisch: **Fork = Text, nicht Tool.** Siehe [[feedback_tasks_list_is_user_visible_todo_keep_current]] · [[feedback_immer_ledger_zuerst_lesen_vor_handeln]].
