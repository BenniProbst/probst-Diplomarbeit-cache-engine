---
name: reference_codex_null_junk_artifact_ignore
description: "Codex/PowerShell hinterlässt ein nicht-löschbares `$null`-Junk-File im Repo-Root — NICHT löschen (geht nicht), nur ignorieren + nie stagen"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 78cf67f8-571e-4fcd-a907-1556dbc5be72
---

Codex-Impl-Läufe (PowerShell-Redirect wie `... > $null`) legen im Repo-Root ein Datei namens `$null` ab (Teil
des F-J-Junk-Musters). **User 2026-07-04: „Die junk null kann man nicht löschen, wir ignorieren sie."** →
NICHT `rm -f '$null'` versuchen (scheitert — OneDrive-/Windows-Lock; der Tool-Call wurde vom User rejected);
einfach IGNORIEREN. Beim Commit schützt gezieltes Staging (`git add <konkrete Pfade>`, NIE `git add -A`) davor,
dass `$null` mitcommittet wird — es bleibt als untracked `?? $null` in `git status` stehen = harmlos.

**Why:** Löschversuche sind vergeblich + kosten Zeit + provozieren Rückfragen; gezieltes Staging genügt.
**How to apply:** `$null` (und andere Codex-Junk-Artefakte) einfach stehenlassen; nie ins Commit-`git add` aufnehmen.
Siehe [[feedback_commit_push_regularly_not_only_session_end]].
