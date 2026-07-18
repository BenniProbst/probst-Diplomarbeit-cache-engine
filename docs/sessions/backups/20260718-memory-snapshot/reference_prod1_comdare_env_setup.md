---
name: reference_prod1_comdare_env_setup
description: "prod1-Linux-Umgebung (User comdare, ab 2026-07-05): Pfade, Keys, Remotes, clang-format 22.1.8 in ~/tools, Codex bwrap-Sandbox defekt → danger-full-access, sudo passwortpflichtig"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 34effcef-618b-4cb2-bd80-87d2a502062e
---

Seit 2026-07-05 läuft die Diplomarbeit-Impl-Arbeit auf **prod1 als User `comdare`** (vorher root; /root-Klone wurden nach `/home/comdare/Projekte` gespiegelt, Struktur = GitLab-Spiegel wie früher Desktop/Projekte).

- **Super-Repo:** `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine` (ce = `Code/external/comdare-cache-engine`, prt-art = `Code/external/comdare-prt-art`, thesis = `thesis/diplomarbeit` NUR lesen).
- **Keys:** GitLab-PAT `/home/comdare/keys/***CRED-NAME-REF:***CRED-NAME-REF:gitlab-pat******` · CA `Projekte/Cluster/keys/gitlab-ca-ROOTCA-20260621.crt` (immer --cacert, nie -k) · GitHub-Token `Projekte/Cluster/keys/github-token.txt`.
- **Remotes:** `origin`=GitLab (PAT in URL eingebettet), `github`=GitHub (Token eingebettet; 2026-07-05 von mir auf super+ce+prt-art angelegt, ls-remote-verifiziert deckungsgleich). Push IMMER beide.
- **clang-format exakt 22.1.8:** `/home/comdare/tools/clang-format-22.1.8` (Symlink auf dpkg-deb-extrahiertes offizielles apt.llvm.org-Paket; kein sudo nötig, läuft gegen installiertes libclang-cpp22).
- **sudo verlangt Passwort** → apt-Installationen vom User machen lassen (`! sudo apt-get install …`).
- **Codex-CLI:** eingeloggt (ChatGPT), ABER bubblewrap-Sandbox defekt (`bwrap: loopback: Failed RTM_NEWADDR: Operation not permitted`) → `--sandbox workspace-write` startet KEINEN Prozess und kann nicht mal Dateien lesen. Workaround: `--sandbox danger-full-access` + temp CODEX_HOME (Config ohne /root-Trust-Eintrag, mit Trust auf den ce-Pfad) + TABUs im Dossier + Voll-Review.
- **Toolchain lokal = CI-identisch:** g++-16.0.1 trunk r16-8100 (exakt der Runner-Default!), clang 22.1.8, cmake 4.3.4, ninja; cppcheck NICHT lokal (CI hat 2.21.0 via citools-Cache).
- GitLab-Projekt-IDs: ce=286, super=288, prt-art=287, thesis=289 (20260931-overleaf-diplomarbeit), ci-templates=269.

Siehe [[reference_diplomarbeit_impl_session_handover_location]], [[reference_gitlab_pat_format_dots_regex]], [[reference_codex_routing_block_preamble_fix]].
