---
name: project_diplomarbeit_stand_20260706_comdare_prod1
description: "Stand 2026-07-06: Arbeit läuft jetzt als comdare@prod1 (Migration von root); Nacht-Session hinterließ INKONSISTENTEN Stand + rote GitLab-Pipeline (Ursache: Codex-Arbeit nicht Zeile für Zeile reviewt); Goal-Text-Fundorte (/goal-Wortlaut, Ledger §13.4, GOAL-VORLAGE Handover §2)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**Umgebung (seit 2026-07-05 abends):** Diplomarbeit-Arbeit läuft als User **comdare@prod1** (vorher root@prod1; kompletter root-Claude-State wurde nach `/home/comdare/.claude` migriert — root-Sessions liegen unter `~/.claude/projects/-root/`). Repos: super = `~/Projekte/Research/probst-diplomarbeit-cache-engine` (ce/prt-art als Submodule unter `Code/external/`), Cluster-Docs = `~/Projekte/Cluster/docs`. GitHub- UND GitLab-Remotes eingerichtet; GitLab-PAT unter `~/keys/***CRED-NAME-REF:***CRED-NAME-REF:gitlab-pat******`. **clang-format 22.1.8 fehlte unter comdare noch** (hartes CI-Gate — vor Code-Commits beschaffen/prüfen).

**Letzter Arbeitsstand (Nacht-Session 06.07., 01:05–02:46 UTC, Ledger §12 fortgeschrieben):** S7-Serie KOMPLETT (alle 10 Pool-Familien echte T6-DEG), 234-V GEPARKT (Architektur-Fork, 2 User-Fragen: Option A per-Source-Emission? binary_id-Shape-Segment?), AP-15-2/15-3 DONE (#263 KOMPLETT), #264 264-a/a2/b/c DONE (264-d gated auf #179), prt-art Race-Fix 211/211. Endstand: super `3d23d7a`, ce `3895a3a5`, prt-art `8cb32fe`.

**🚨 ABER (User 2026-07-06):** Die Session hinterließ einen **inkonsistenten Stand**, die **GitLab-Pipeline läuft nicht mehr durch**, und Codex-Arbeit wurde entgegen Anweisung nicht Zeile für Zeile gegengeprüft ([[feedback_codex_outputs_always_full_manual_review]]). → Vor Weiterarbeit: Ist-Verifikation (git status/log beider Repos + Remotes), Pipeline-Endstand via GitLab-API dokumentieren, deterministische Fehler FIXEN statt re-triggern, und die nicht-reviewten Nacht-Commits (S7-5..10, AP-15-2/3, 264-a/b/c) nachträglich Zeile für Zeile reviewen.

**Goal-Text-Fundorte (User fragte danach):**
1. Der vom User selbst gesetzte `/goal`-Wortlaut (05.07. 23:00, pfad-korrigierte Fassung): `~/.claude/history.jsonl` Zeile 23 + Session `~/.claude/projects/-home-comdare-Projekte/34effcef-*.jsonl` (Zeilen 633/643).
2. Das eigentliche Arbeitsprogramm: **GOAL-TEXT V2 = Ledger §13.4** (`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` Z.247–254), korrigiert durch §13.9/§13.10/§13.11.
3. Fertige **GOAL-VORLAGE** („1:1 als /goal setzbar"): `docs/HANDOVER-BEP-ABTEILUNG-20260705.md` §2 Z.26.

Pflicht-Einstieg jeder Session: Ledger zuerst ([[feedback_immer_ledger_zuerst_lesen_vor_handeln]]), dann Session-Handover `docs/sessions/20260705-SESSION-HANDOVER-goalv2-audit-restore-ci-s7-ap7b.md` (Degenerationen §4, Fallstricke §5), Matrix-Grundlagen normativ für #256/#265/#266/#274.
