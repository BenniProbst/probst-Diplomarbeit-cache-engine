---
name: feedback_consult_analysis_backups_via_ultracode_before_decisions
description: "Vor WICHTIGEN Entscheidungen je Thema (v.a. Modul-Abhängigkeiten/Layering/Schema im Matrix-System) IMMER ZUERST die Rohdaten der teuren Analyse-Backups von comdare-db UND buildsystem via ultracode-Workflow konsultieren, statt zu raten/annehmen. Strikt einhalten — die Analysen waren sündhaft teuer und sind die Orientierung im gigantischen Matrix-System."
metadata:
  node_type: memory
  type: feedback
  originSessionId: c6f15797-7fa1-4e66-874f-55631afe1d28
---

**Direktive (User 2026-07-04):** Bei wichtigen Entscheidungen je Thema — insbesondere **Modul-Abhängigkeiten, Baseline-Layering (n→n-1), Schema, wo ein Typ/Modul lebt** — IMMER **zuerst die Rohdaten der Analyse-Backups** (comdare-db + buildsystem) **mit einem ultracode-Workflow** konsultieren, wenn Fragen bestehen. Nicht raten, nicht annehmen.

**Warum:** In diese Analysen wurde „sündhaft teuer" investiert (Millionen Tokens: Ist-Kartografie, Soll-FEATURES-MASTER, Diff/Wellenplan, Konsumenten-Karten, Design-Workflows). Sie sind die **Orientierung im gigantischen Matrix-System** (VLAN×Slot-artige Modul-Matrix, Baseline-Ebenen, source=modules|products|layerN) und dessen Schema.

**How to apply:**
- Vor einer Layering-/Abhängigkeits-/Platzierungs-Entscheidung (z.B. „wo lebt `DataReference`?", „darf Modul X auf Y linken?", „welche Baseline?"): einen ultracode-Workflow starten, der die **Analyse-Backup-Rohdaten** liest (comdare-db: `docs/architecture/*`, `sessions/_*-rohdaten*`, IST/SOLL/FEATURES-MASTER/Diff-Dossiers; buildsystem: `cd-buildsystem-core/docs/architecture/*`, `_backup-diff-ledger-rohdaten-*`, Kartografie) + die konkrete Abhängigkeitsfrage beantwortet.
- Das gilt getrennt je System (comdare-db-Analysen für DB-Fragen, buildsystem-Analysen für Buildsystem-Fragen) — [[feedback_comdare_db_and_buildsystem_separate_ledgers]].
- Konkret offen (Beispiel): die `DataReference`-Hoisting-Frage (in welche gemeinsame niederwertigere Baseline?) VOR Umsetzung per ultracode gegen die Analyse-Backups klären. Ebenso 1a-① Cluster-Transport-Modulgrenzen.
- Verwandt: [[feedback_never_guess_always_lookup_state_of_art_and_docs]], [[feedback_ultracode_workflow_for_uncertainty_and_absolute_claims]], [[feedback_thorough_assumptions_workflow_planning]].
