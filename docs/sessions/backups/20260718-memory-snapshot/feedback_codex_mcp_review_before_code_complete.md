---
name: feedback_codex_mcp_review_before_code_complete
description: "Bei JEDER zukünftigen Code-Aufgabe den Implementierungsstand mit einem Codex-MCP-Agenten gegenreviewen + Feedback einholen (Cross-Model-Review), bevor „fertig\""
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 78cf67f8-571e-4fcd-a907-1556dbc5be72
---

Bei **jeder zukünftigen Code-Aufgabe** den Stand der eigenen Implementierung mit einem **Codex-MCP-Agenten** (`mcp__codex__codex` / `mcp__codex__codex-reply`) gegenreviewen und dort **Feedback einholen**, BEVOR die Aufgabe als fertig gilt. (User-Direktive 2026-06-27.)

**Token-Ersparnis (User 2026-06-27):** ALLE Review-Aufgaben ans Codex-MCP **delegieren** — der Review läuft im Cross-Model statt im Hauptkontext (spart Tokens im Hauptkontext). Gilt über reine Code-Abschluss-Reviews hinaus für Diff-/Korrektheits-/Plausibilitäts-Checks. (Sicherheits-Caveat unten beachten: NIE Cluster/keys/Secrets an Codex.)

**Workflow-Scoping via Codex VOR teuren ultracode-Workflows (User 2026-06-27):** Bevor ein (token-teurer) ultracode-Workflow gestartet wird, Codex die **Vorarbeit/Scoping** machen lassen — Codex sagt, **WO nachzulesen** ist (welche Docs/Bereiche/Dateien relevant sind) → der Workflow wird **zielgerichteter** (weniger Agenten, gezielte 2-3 Dateien statt breitem Fan-out) oder erübrigt sich (direkt die genannten Dateien lesen). Spart Tokens. **An Codex nur Task + Datei-/Struktur-NAMEN (keine Secret-/Credential-Inhalte)** schicken; bei reinen Code-Repos auch Inhalte. Caveat keys/machines/Secrets bleibt strikt.

**Why:** Cross-Model-Review — Codex (OpenAI) prüft Claude-geschriebenen Code → reduziert Single-Model-Bias/Sycophancy (die Schwächen zweier Anbieter überlappen nicht). Codex ist laut Quellen stark für Code-Review, Bug-Hunt, Architektur-Sanity, komplexe Logik.

**How to apply:** Nach dem Implementieren (spätestens vor „done"): Codex-MCP-Tool aufrufen → Diff/Dateien reviewen lassen → Feedback **einarbeiten oder begründet verwerfen**. Read-only-Review (Codex schlägt vor, ich setze um). Gilt für **substanzielle Code-Änderungen** (cache-engine/prt-art/thesis/super) UND **nach JEDEM größeren zusammenhängenden Implementierungs-Abschnitt** (nicht nur am Schluss; User 2026-06-27), nicht für triviale Edits/CI-YAML.

**Text-/Thesis-Edits explizit (User 2026-06-27):** ALLE Änderungen am **Diplomarbeit-Text** (Kapitel-`.tex`, DE+EN) ebenfalls vom Codex-Plugin gegenreviewen lassen — nicht nur Code. Ablauf: Text-Edit machen → Codex über die betroffenen Kapitel/Diffs reviewen (read-only, `cwd` = `thesis/diplomarbeit`) → Feedback einarbeiten oder begründet verwerfen. Thesis-Repo ist Code-/Text-Repo (kein Cluster/keys), Codex-Zugriff also erlaubt.

**Modell (User 2026-06-27):** Codex IMMER mit `model: "gpt-5.5"` + `config: {model_reasoning_effort: "xhigh"}` aufrufen (per-call-Override, restart-unabhängig).

**Session-Start-Ritual (User 2026-06-27):** VOR Beginn einer neuen Session Codex den **Referenz-Stand der letzten 5 bearbeiteten Sessions** zusammenfassen lassen (`docs/sessions/` neueste 5) — ergänzt den ultracode-Status-Survey. Siehe [[project_active_goal_directive]].

**Caveat (Sicherheit, CLAUDE.md):** Codex sendet Code an OpenAI → **NUR auf den Code-Repos**, NIE im Cluster-Repo / `keys/` / `machines/` (Daten-/Credential-Exposition). Setup-Doku: `Diplomarbeit - Datenbanken/docs/CODEX-CROSS-REVIEW-SETUP.md`. Codex-Feedback = ZUSÄTZLICHE Verifikation, ersetzt KEINE echten Test-Belege ([[feedback_no_success_marks_without_literal_output]]).
