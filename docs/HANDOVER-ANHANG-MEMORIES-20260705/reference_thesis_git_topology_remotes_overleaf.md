---
name: reference_thesis_git_topology_remotes_overleaf
description: "Git-Topologie der Diplomarbeit: BASE-Superprojekt + 2 Submodule, je 2 Remotes (origin=GitHub, gitlab=intern); Overleaf pusht auf GitHub-origin → bei Push-Divergenz mergen (kein Rebase); zu BEIDEN pushen."
metadata: 
  node_type: memory
  type: reference
  originSessionId: 2d70c447-50f5-41bf-a389-d9c5da819589
---

**Repos (alle Branch `main`):**
- **BASE-Superprojekt** `C:\Users\benja\OneDrive\Desktop\Diplomarbeit - Datenbanken` — remotes `origin`=GitHub (`BenniProbst/probst-Diplomarbeit-cache-engine`) + `gitlab`=intern (`gitlab.comdare.de/comdare/research/probst-diplomarbeit-cache-engine`).
- Submodul **`thesis/diplomarbeit`** (= Overleaf-Repo, der Text-Teil) — `origin`=GitHub (`BenniProbst/20260931-Overleaf-Diplomarbeit`, Groß-`O`; lokale URL hat Klein-`o` → „repository moved"-Redirect, Push läuft trotzdem) + `gitlab`=intern.
- Submodul **`Code/external/comdare-cache-engine`** + **`comdare-prt-art`** — je `origin`=GitHub + `gitlab`=intern. **Shared mit Impl-Agent** (Commits „COMDARE Impl-Agent", `#179` …).

**Push-Regeln (User-Konvention):**
- Zu **BEIDEN** Remotes pushen: `git -C <repo> push origin main` **und** `push gitlab main`. Upstream-Tracking ist `origin/main`.
- Reihenfolge: **erst Submodule, dann BASE** (Pointer referenziert die schon-gepushten Commits).
- **Nur eigene Änderungen** committen (explizite Pfade), NIE Fremd-Arbeit mit-`add -A`en: prt-art-Pointer, Impl-Agent-Commits im cache-engine, untracked Infra/Research-Docs im BASE bleiben unangetastet. Commit-Messages enden mit `Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>`.

**Overleaf-Divergenz-Muster (wichtig):** Overleaf committet automatisch (`Updates from Overleaf` / `Merge overleaf-…`) und pusht auf **GitHub-origin** des Thesis-Repos. Darum schlägt ein `push origin` oft mit non-fast-forward fehl, während `gitlab` durchläuft → **`git fetch origin` + `git merge origin/main`** (NIE Rebase, NIE Force; [[feedback_https_only_no_http_real_cert_identity_check]] sinngemäß: kein `sslVerify=false`), dann zu **beiden** Remotes pushen, um sie wieder zu synchronisieren. Overleaf-Edits sind WIP-Prosa des Users → **nicht „korrigieren"**, nur einmergen. Meist konfliktfrei (Overleaf editiert `kapitel/de/*`, Text-Agent oft andere Dateien). Build-Befehl: `pwsh -NoProfile -File build.ps1 -Lang de|en` (Jobnames `diplomarbeit-de/-en`; die getrackte Overleaf-PDF `20260931_…pdf` NICHT mit-committen — anderer Jobname).
