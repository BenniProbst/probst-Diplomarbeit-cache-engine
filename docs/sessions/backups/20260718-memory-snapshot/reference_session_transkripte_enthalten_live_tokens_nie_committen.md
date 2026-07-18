---
name: reference_session_transkripte_enthalten_live_tokens_nie_committen
description: "Session-Transkripte (.jsonl) enthalten LIVE-Tokens (github_pat_/glpat-) aus Tool-Ausgaben — NIE ins Repo committen, nur lokal + gitignore"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**Befund (10.07.2026):** Beim Sichern des Session-Transkripts (`docs/sessions/20260710-SESSION-TRANSKRIPT-*`)
hat GitHub-Push-Protection einen **GitHub-PAT** blockiert; grep fand zusätzlich **glpat-**-Tokens. Das
Transkript-.jsonl zeichnet ALLE Tool-Ergebnisse auf — inkl. `git credential fill`-Ausgaben, Push-Outputs
etc., in denen Tokens auftauchen können.

**Konsequenz-Regel:** Session-Transkripte (Roh-.jsonl UND gerenderte Fassungen) **NIE ins Git committen**.
Nur lokal in `docs/sessions/` ablegen und SOFORT in `.gitignore` eintragen. Wenn ein Transkript-Sicherungs-
Auftrag kommt: lokal speichern + gitignoren, dem User erklären, dass Commit wegen Live-Tokens unterbleibt.

**Remediation, falls doch gepusht:** GitHub blockt (Push-Protection); GitLab (comdare) hat KEINE
Push-Protection und akzeptiert → sofort `git commit --amend` (Transkript raus) + `--force-with-lease` über den
Leak-Commit; der Commit-Objekt bleibt bis GC im GitLab-Store erreichbar → **die geleakten Tokens MÜSSEN rotiert
werden** (User-Aktion; ich kann/darf sie nicht rotieren). Verwandt: [[reference_gitlab_pat_format_dots_regex]],
[[feedback_all_projects_dual_remote_github_gitlab]].
