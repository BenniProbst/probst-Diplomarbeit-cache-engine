---
name: feedback_nie_rebase_immer_merge
description: "Git-Integration: NIE rebase, IMMER merge — bei jeder Divergenz-Reconciliation (Remote voraus, andere Session gepusht) merge statt rebase; kein History-Rewrite/force-push auf geteilte Branches"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**NIE `git rebase`, IMMER `git merge`** (User-Direktive 2026-07-13, bindend). **Immer einen Commit MERGEN.**

**KONTEXT: dutzende Agenten laufen parallel** (User 2026-07-13) und pushen konkurrierend auf dieselben
Branches (github ist bei GitLab-Ausfall der einzige Live-Remote) → Divergenzen sind der NORMALFALL, nicht
die Ausnahme. Merge integriert fremde Commits konfliktfrei; Rebase/force-push würde die Arbeit anderer
Agenten überschreiben.

Bei JEDER Divergenz-Reconciliation — Remote ist voraus, ein anderer Agent hat auf denselben Branch
(development/main) gepusht — **`git merge <remote>/<branch>`**, nie `git rebase`. Gilt für super, ce,
prt-art, thesis, Cluster, alle Repos. **Vor JEDEM Push: `git fetch` + `git merge <remote>/<branch>`**, damit
konkurrierende Agenten-Commits mitgenommen werden, dann push.

**Why:** Rebase schreibt Commit-Hashes um → in der Submodul-Gitlink-Topologie (super→ce) verwaisen alte
Hashes, der Gitlink muss nach-gebumpt werden, und geteilte Branches (github ist bei GitLab-Ausfall der
einzige Live-Remote, mehrere Sessions pushen) dürfen NIE per force-push umgeschrieben werden. Merge bewahrt
beide Historien konfliktfrei und ist nachvollziehbar.

**How to apply:** Divergenz → `git fetch <remote> <branch>` → `git merge <remote>/<branch>` (Merge-Commit ok)
→ ctest/verify → push. NIE `git rebase`, NIE `git push --force`/`+`. Ein bereits gepushter Rebase wird NICHT
per force-push „korrigiert" (das wäre schlimmer) — ab dann merge-only weiterfahren. Bezug:
[[feedback_gitflow_branch_doktrin_main_authoritaet_development_voraus]], [[feedback_verify_gitlab_pipeline_green_after_push]].
