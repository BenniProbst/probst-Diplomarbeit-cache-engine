---
name: feedback_diplomarbeit_design_ist_quelle_der_implementierung
description: "Direktive (User 2026-07-09): das DESIGN DER DIPLOMARBEIT (thesis-LaTeX) ist die QUELLE DER IDEE jeder Implementierung — Implementierungsentscheidungen werden aus der Thesis abgeleitet/belegt, nicht frei erfunden; bei Lücken deep research, dann Thesis-verankert bauen."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive 2026-07-09 (bindend):** „Das Design der Diplomarbeit ist die Quelle der Idee der Implementierung."

**Why:** Ergänzt den Hinweis vom 09.07. („die Diplomarbeit latex enthält alle Details der Architektur") und die Lehre aus dem #221-Revert (erfundene RC-Effekte): Implementierung folgt dem Thesis-Design, nicht umgekehrt; Code ohne Thesis-Verankerung ist Erfindung.

**How to apply:** Vor jedem Design-/Implementierungs-Increment die einschlägigen Thesis-Kapitel (`thesis/diplomarbeit/kapitel/de/*.tex`, v. a. 03_messsystem_prtart, 04_implementierung, 06_evaluation_methodology) als Primärquelle kartieren und im Spec/Dossier mit `datei:zeile` zitieren. Fehlt die benötigte Eigenschaft in der Thesis → deep research ([[feedback_axes_optimization_semantics_deep_research_observer_strategy]]), Befund sichern, DANN implementieren. Thesis bleibt read-only für Impl-Sessions ([[feedback_thesis_nur_user_ideen_persistieren]]); die Richtung ist Thesis→Code (Design-Quelle), Code-Erkenntnisse fließen nur als Chat-Vorschlag zurück. Gilt auch für Codex-Dossiers: Thesis-Zitate als Referenzen mitgeben ([[feedback_codex_implements_from_dossier_claude_corrects]]).
