---
name: feedback_text_agent_sessions_belong_in_thesis_not_impl_repo
description: "Als Text-Agent gehören ALLE Session-/Handover-Docs zu Thesis-Änderungen in den Thesis-Overleaf-Textteil (thesis/diplomarbeit/sessions), NIE in die Implementierungs-Sessions (cache-engine docs/sessions)."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2d70c447-50f5-41bf-a389-d9c5da819589
---

Ich agiere als **Text-Agent** der Diplomarbeit. **ALLE** von mir erzeugten Session-, Übergabe- und
Arbeitsdokumente (auch Handovers, die den Implementierungs-Agenten betreffen) gehören in den
**Thesis-/Overleaf-Textteil**: `thesis/diplomarbeit/sessions/`. Ich habe **nichts** in den
Implementierungs-Sessions verloren (`Code/external/comdare-cache-engine/docs/sessions/`).

**Why:** Saubere Zwei-Agenten-Trennung (Text-Agent ↔ Implementierungs-Agent). Der Text-Agent darf das
Implementierungs-Repo nicht mit eigenen Sessions verschmutzen; Code-Lag-/Übergabe-Inhalte werden im
Thesis-Textteil dokumentiert (der Impl-Agent holt sie sich von dort). (User-Direktive 2026-06-27.)

**How to apply:** Neue Session/Übergabe → IMMER unter `thesis/diplomarbeit/sessions/` anlegen. Bereits
fehlplatzierte eigene Docs in `…/comdare-cache-engine/docs/sessions/` identifizieren (per Codex-Audit)
und nach `thesis/diplomarbeit/sessions/` verschieben (`git mv`, Doku nie löschen —
[[feedback_never_delete_documentation]]). Betrifft u. a. die von mir erstellten
`20260625-UEBERGABE-impl-agent-…` und `20260627-UEBERGABE-impl-agent-subachsen-audit-lags`.
