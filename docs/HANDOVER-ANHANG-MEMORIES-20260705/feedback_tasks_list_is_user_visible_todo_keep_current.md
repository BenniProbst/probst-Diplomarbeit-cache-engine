---
name: feedback_tasks_list_is_user_visible_todo_keep_current
description: "Die Tasks-API-Liste IST die user-sichtbare TODO — ständig aktuell halten: offene Punkte aus Sessions/Handoffs als Tasks einreihen, Status pflegen; alle Tasks darauf sind noch offen"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 885d4915-6f41-4b18-9770-e729576e9fee
---

Die **Tasks-Liste (Task-API: TaskCreate/TaskUpdate/TaskList)** ist die **user-sichtbare TODO-Liste**, über die der User plant, priorisiert und überblickt. Direktive (User, 2026-06-26): **ständig aktuell halten** — neue offene Punkte (auch aus älteren Sessions, Inter-Agent-/Impl-Handoffs, EMS/FGT-Projekt usw.) als Tasks **einreihen**, Status pflegen (in_progress beim Start, completed beim Abschluss), Erledigtes sauber schließen. **Alle Tasks auf der Liste sind noch offen zu bearbeiten.**

**Why:** Der User steuert ausschließlich über diese Liste; was nicht drauf steht, existiert für ihn praktisch nicht (Beispiel: Handouts anderer Agenten + EMS-Projekt fehlten und mussten K81-73 nachgetragen werden → #102-#112).

**How to apply:** Offene Punkte regelmäßig harvesten (ultracode-Workflow über `docs/sessions/` + Handover-/Inter-Agent-Docs) und **dedupliziert** gegen den Bestand als Tasks anlegen; bei jeder neuen/erledigten Arbeit die Tasks **sofort** updaten. Single-Source für Cluster-Detail bleibt der Ledger; die Tasks-Liste ist die Arbeits-/Steuer-Sicht. [[feedback_immer_ledger_zuerst_lesen_vor_handeln]]
