---
name: feedback_gitflow_branch_doktrin_main_authoritaet_development_voraus
description: "Branch-Doktrin (07.07. + PRAEZISIERT 13.07.): IMMER auf development stehen+committen; main ist STETS Vorfahr von development (development ⊇ main, traegt neuesten Stand); wenn main voraus -> main->development back-mergen (NIE rebase); master nur loeschen wenn ⊆ main; immer syncen, nichts unverantwortbar loeschen"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

User-Direktive (2026-07-07, GitLab-Flotte, sole owner/admin): einheitliches GitFlow-Branch-Modell fuer ALLE Repos.

- **main** = Default-/Haupt-Branch, stabile Basis, traegt den NEUESTEN Stand (Vereinigung aller Branches).
- **development** >= main: development ist stets auf main-Stand ODER voraus (aktive Arbeit laeuft auf development, nie dahinter). Wenn main je voraus ist -> development auf main hochziehen.
- **master** (Alt-Default aus dem DB-importierten Alt-GitLab) wird geloescht **NUR wenn `master ⊆ main`** (main hat master-Stand oder ist voraus). Ist master voraus/divergiert -> ZUERST master->main mergen (main = neuester Stand), dann master loeschen. **Merge-Konflikt => master BEHALTEN + melden.**
- **Grundsatz: immer auf den neuesten Stand syncen; NICHTS loeschen, was wir nicht verantworten koennen.**

**Why:** Die Repos wurden per DB aus einem alten GitLab eingelesen + per Samba-AD neu verknuepft -> uneinheitliche Branches (development-default+master-Rest, teils divergiert). Verlustfreiheit ist Pflicht; ein blindes master-Loeschen koennte einzigartige Commits vernichten (Pilot foundation-all: master war trotz +1 Commit inhaltlich AELTER -> Content-Diff-Pruefung obligatorisch, kein Regress-Merge).

**How to apply:** Vor jeder master-Loeschung `compare(from=master, to=main)` == 0 verifizieren (master vollstaendig in main). Neue Repos: default=main + development-Arbeitsbranch. Content-Klassifikation (diff development<->master) trennt stale-aelter (verlustfrei) von unique-Inhalt (erst mergen). Owner: root/User ist alleiniger Owner ([[feedback_remote_deletion_requires_explicit_user_authorization]] durch expliziten fleet-GO erfuellt); als direkter Owner in allen Projekten eingetragen 07.07.

**PRAEZISIERUNG 2026-07-13 (User woertlich: „stehe immer auf development. main ist immer ein Vorfahr von development, merke dir das"):**
- **IMMER auf `development` stehen + committen** — aktive Arbeit (auch #24-artige Increments) landet auf development, nie direkt auf main.
- **INVARIANTE: `main` ist STETS Vorfahr von `development`** (`git merge-base --is-ancestor main development` == 0). development traegt den neuesten Stand, main ist die stabile ge-fast-forward-te Teilmenge.
- **Wenn main Commits traegt, die development fehlen** (z.B. Hotfix/Release-Doku, von anderen Agenten waehrend Blockade gepusht) -> **`main` in `development` back-mergen** (Doktrin wiederherstellen), NIE rebase ([[feedback_nie_rebase_immer_merge]]). Ledger/Doku-Konflikte: BEIDE Bloecke behalten (Doku nie loeschen).
- Beobachtet 13.07.: Cluster erfuellte die Invariante bereits (main ⊆ development); super+thesis-`origin` verletzten sie (development HINTER main) — durch Parallel-Agenten-Pushes waehrend GitLab-Blockade. Fix = FF (thesis) bzw. main->development-Merge (super, Ledger-§12-Konflikt).
