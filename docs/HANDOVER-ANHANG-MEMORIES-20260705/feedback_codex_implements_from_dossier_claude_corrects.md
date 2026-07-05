---
name: feedback_codex_implements_from_dossier_claude_corrects
description: "Arbeitsteilung (User 2026-07-01, Fable-5-Manager-Modus): Codex IMPLEMENTIERT jede Code-Aufgabe anhand eines unglaublich ausführlichen Dossiers; Claude korrigiert den Vorschlag anschließend selbst so präzise wie möglich. Review-Direktiven bleiben bestehen."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 78cf67f8-571e-4fcd-a907-1556dbc5be72
---

**Direktive (User 2026-07-01, bei Fable-5-Reaktivierung):** Claude agiert als MANAGER anderer Modelle (mcp codex). Für JEDE Code-Implementierungsaufgabe: (1) ein UNGLAUBLICH AUSFÜHRLICHES Dossier schreiben (Auftrag, Architektur-Kontext, exakte file:line-Verweise, SOLL-API, Constraints/Verbote, DoD, Test-Erwartungen) und Codex die Lösung IMPLEMENTIEREN lassen; (2) den Codex-Vorschlag anschließend SELBST so präzise wie möglich korrigieren — nie vorbehaltlos übernehmen (Codex baut „halbwegs gute" Lösungen).

**Why:** Spart Claude-Tokens ohne Qualitätsverlust — Codex ist stark genug für Implementierungs-Drafts; Claude sichert die Qualität über den Korrektur-Pass und behält die Architektur-Hoheit.

**How to apply:** Dossier (gern als Datei im Scratchpad) → Codex ausführen lassen: MCP `mcp__codex__codex` (sandbox workspace-write fürs Implementieren im Arbeitsbaum, read-only für Reviews; approval never; `model_reasoning_effort: xhigh`) ODER Fallback `codex exec`-CLI, falls der MCP-Server getrennt ist. NUR Code-Repos (cache-engine/prt-art/super/thesis), NIE Cluster/keys; Secrets maskieren; Arbeitsbaum VOR dem Codex-Lauf sauber (git status) → `git diff` = exakt der Codex-Vorschlag → eigener Korrektur-Pass (präzise Edits) → bestehende Review-Direktiven WEITER anwenden ([[feedback_codex_mcp_review_before_code_complete]] vor „done"; [[feedback_pair_explore_with_codex_same_investigation]]). Je Increment eigener sauberer Commit; modules/* + ext/ bleiben für Codex tabu (in jedes Dossier schreiben).

**Parallelität (User 2026-07-01, Ergänzung):** Bei mcp-codex-Workflows mit ultracode dürfen bis zu **16 Agenten parallel im Hintergrund** laufen — ausdrücklich erwünscht, um viele Coding-Aufgaben GLEICHZEITIG zu erledigen, SOLANGE sie DISJUNKT sind (keine überlappenden Dateien/Module; sonst Merge-Konflikte im Arbeitsbaum → disjunkte Aufgaben je Codex-Instanz zuschneiden, z. B. per-Familie/per-Datei-Increments wie die 4 Node-Shape-Achsen).

**IMMER als ultracode-Workflow starten (User 2026-07-03, VERBINDLICH):** Codex NICHT mehr als einzelnen BLOCKIERENDEN `mcp__codex__codex`-Aufruf starten — stattdessen über das **Workflow-Tool (ultracode)**, damit mehrere Codex-Aufgaben PARALLEL im Hintergrund laufen und den Hauptstrang NICHT blockieren. Workflow-`agent()` kann `mcp__codex__codex` per ToolSearch erreichen; je disjunktes Arbeitspaket ein Codex-Aufruf. Einzige Ausnahme = ein inhärent serielles Einzel-Artefakt (eine Datei) → dann 1 Agent, aber weiterhin via Workflow (non-blocking). **Codex-Dossiers so ELABORAT und DETAILLIERT wie möglich** (re-bekräftigt 2026-07-03): voller Architektur-Kontext, exakte Pfade/Zeilen, SOLL-Verhalten, Constraints/Verbote, DoD, Validierungsschritte.
