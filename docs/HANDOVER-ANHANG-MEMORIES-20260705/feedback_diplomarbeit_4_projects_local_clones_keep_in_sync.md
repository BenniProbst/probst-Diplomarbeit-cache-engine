---
name: feedback_diplomarbeit_4_projects_local_clones_keep_in_sync
description: Die 4 Diplomarbeit-Projekte haben lokale Repos NICHT NUR unter Code/external — alle lokalen Klone bei Änderung synchron halten (wenn unsauber/divergent); Codex-Find NUR sicher (nie Cluster/keys)
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 78cf67f8-571e-4fcd-a907-1556dbc5be72
---

Die 4 Diplomarbeit-Projekte (cache-engine, prt-art, super=probst-diplomarbeit-cache-engine, thesis=20260931-overleaf-diplomarbeit) haben **lokale Repos NICHT NUR unter `Diplomarbeit - Datenbanken/Code/external/`** (die GitLab-Submodule) — laut User existieren weitere lokale Klone, die **synchron bleiben müssen**. **Bei jeder Änderung gegen diese Klone syncen, sofern unsauberer/divergenter Stand** (User-Direktive 2026-06-27).

**SICHERHEIT (überschreibt „beauftrage codex"):** Codex NIE auf den ganzen `Desktop\Projekte`-Baum richten — der enthält `Cluster\keys\` (Vault) + `machines\` (Secrets) → OpenAI-Exposition verboten ([[feedback_codex_mcp_review_before_code_complete]]-Caveat). Das **Finden** der Klone = sicherer **lokaler** Verzeichnis-/Remote-Scan (Pfade+Remote-URLs, keine Inhalte) durch MICH; Codex nur auf konkrete **Code-Repo-Dirs** scopen (nie Cluster/keys/machines).

**STATUS (2026-06-27, sicherer Scan Desktop\Projekte Depth 8):** KEINE direkten Klone der 4 Repos gefunden — nur `Research\comdare-celm` (separates, **stale [2026-03-09]**, eigenes `src/`, KEIN `.gitmodules`, dual-remote gitlab `comdare/research/comdare-celm` + github `BenniProbst/comdare-celm`; **kein cache-engine/prt-art-Spiegel**). Portfolio-Repos unter Modules/Products/Research = andere Projekte (primitives/client-capi/licensing/storage-ha-postgres/steuerrater-a+b/lightweight/celm/via, github BenniProbst). → **Zuordnung/Ort der zu-synchronisierenden 4-Projekt-Klone ist beim User RÜCKGEFRAGT** (Prämisse deckte sich nicht mit Scan; kein Blind-Sync = Datenverlust-Risiko). Verwandt: [[feedback_prod1_prod2_keep_config_and_progress_in_sync]] (analoge Sync-Disziplin).

**KORREKTUR (User 2026-06-27):** Die Klone der 4 Projekte LIEGEN sehr wohl unter **`Desktop\Projekte\Research`** mit DENSELBEN Remotes (gitlab `comdare/research/...`) wie die `Code/external`-Submodule. Mein Scan übersah sie — vmtl. **OneDrive cloud-only/dehydriert** → `Get-ChildItem -Recurse` übersprang den Teilbaum (Lehre: bei OneDrive Top-Level-pro-Ordner listen, nicht blind -Recurse; ggf. hydrieren). comdare-celm war ein Fehl-Treffer (separates Projekt). → Beim Sync die exakten Research-Klon-Dirs erst **lokalisieren+verifizieren** (Remote == external-Remote), DANN syncen.

**SYNC-MODUS (User 2026-06-27): `Code/external` = QUELLE, `Desktop\Projekte\Research`-Klon spiegelt 1:1.** Nach Commit+Push in external: im Research-Klon `git fetch` + **fast-forward** auf denselben Remote-Stand — **NUR wenn der Research-Klon sauber ist** (`git status` clean, kein divergenter lokaler Commit). Bei dirty/divergent/uncommitted → **STOPP + melden, NICHT überschreiben** (kein `reset --hard`/force ohne Rückfrage). Gilt für alle 4 Projekte, bei jeder Änderung.
