---
name: reference_gitlab_de_abgeschaltet_local_kanonisch_scoped_ca
description: "GitLab-Migration 13.07.: comdare.de BEWUSST abgeschaltet (404), kanonisch = gitlab.comdare.local (gleiche IP 10.0.10.1/CA/PAT, nur Hostname); Remote-Fix .de->.local + SCOPED CA (nie unscoped, sonst GitHub-Push bricht); credential.useHttpPath=true global -> host-Reuse via useHttpPath=false; CA=Cluster/keys/gitlab-ca-ROOTCA-20260621.crt"
metadata:
  node_type: memory
  type: reference
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

Runbook-Quelle: `Cluster/docs/sessions/2026-07-13-comdare-de-abschaltung-gitlab-local-migration-und-minisign-runbook.md` (auf Cluster `development`).

- **`gitlab.comdare.de` ist bewusst ABGESCHALTET** (User 2026-07-13) -> liefert **404** (HAProxy-Default). Kanonischer Host = **`gitlab.comdare.local`** (external_url; 302 auf `/users/sign_in` beweist es). **Gleiche IP 10.0.10.1, gleiche CA, gleicher PAT — nur der Hostname aendert sich.** `.de`-DNS zeigt jetzt auf 10.0.60.1 (anderes Netz).
- **Remote-Fix je Repo:** `git remote set-url origin https://gitlab.comdare.local/<pfad>.git` + **host-SCOPED CA**: `git config http.https://gitlab.comdare.local/.sslcainfo <ca>`. **NIE unscoped** `http.sslcainfo` — das ueberschreibt die System-CA und **bricht GitHub-Pushes** („unable to get local issuer certificate"). Alt.: per-command `git -c http.https://gitlab.comdare.local/.sslcainfo=<ca> push ...`.
- **CA (austauschbar):** `Cluster/keys/gitlab-ca-ROOTCA-20260621.crt` (oder je BS-Zelle `ci/gitlab-rootca.crt`), beide `ssl_verify_result=0`.
- **Credential-Fallstrick (13.07. verifiziert):** `credential.useHttpPath=true` ist GLOBAL gesetzt -> git matcht Store-Credentials per VOLLEM Pfad. Ein `.local`-Eintrag fuer *einen* Repo-Pfad (z.B. cluster) matcht die anderen Repos NICHT -> „could not read Username". **Fix ohne Secret-Duplikat:** je Diplomarbeit-Repo `git config credential.useHttpPath false` -> host-basiertes Matching, derselbe `.local`-Token (host gitlab.comdare.local) greift fuer alle Pfade. (Alt.: pfad-spezifische Eintraege je Repo, aber Secret-Streuung.)
- **Diplomarbeit-Remotes (alle 4 auf .local umgestellt 13.07.):** super `comdare/research/probst-diplomarbeit-cache-engine`, ce `.../comdare-cache-engine`, prt-art `.../comdare-prt-art`, thesis `.../20260931-overleaf-diplomarbeit`. GitHub-Remotes (super/ce/prt-art) bleiben unangetastet (Dual-Remote [[feedback_all_projects_dual_remote_github_gitlab]]); thesis hat KEIN github (Overleaf-Kette).
- **minisign** (im Runbook §4) = **Registry-Artefakt-Signierung** (Ed25519, F-4/Policy B, CI-seitig, protected refs) — **NICHT git-Auth**, reiner Zeit-Zufall zur .de-Abschaltung. Keys im Vault; Infra-Domaene (Memory `project_minisign_registry_signing_armed_tested` = Infra-Set).
- **Runner/CI:** `.de`-Hardcodes in BS-Zellen/`prepare_workspace.sh`/`config.toml` muessen ebenfalls auf `.local` (Runbook §3.3/§3.4) — Infra-Owner-Scope. Bezug: [[reference_cluster_vlan_tabelle_sni_standard_pattern]].
