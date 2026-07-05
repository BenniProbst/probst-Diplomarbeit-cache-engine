# SESSION-STAND BEP-Abteilung #1 — Setup/Onboarding auf prod1 (2026-07-05, vor User-Reboot)

**Zweck:** Zwischensicherung vor Maschinen-Neustart (User-Auftrag). Nächste Session liest dieses Dokument + Memory-Index und setzt bei „NÄCHSTER SCHRITT" fort. Kein Code-Edit erfolgt — reine Setup-/Verifikations-Session.

---

## 1. WAS ERLEDIGT IST (verifiziert, mit Belegen)

### 1.1 Plugins/Umgebung Claude Code (User-Auftrag „Plugins installieren")
Quelle: `Projekte/Cluster/docs/sessions/K86-CLAUDE-CODE-CODEX-MCP-AUF-PROD1-SETUP-20260705.md` §5b.
- Marketplace `claude-plugins-official` (anthropics) war vorhanden; `barkain-plugins` (barkain/claude-code-workflow-orchestration) **hinzugefügt** ✅
- Plugins **installiert** (alle scope user, Exit 0): `commit-commands@claude-plugins-official` ✅ · `feature-dev@claude-plugins-official` ✅ · `workflow-orchestrator@barkain-plugins` ✅
- Codex-MCP (`codex mcp-server`) war bereits verbunden (mcp__codex__* Tools verfügbar).

### 1.2 Memories importiert
- Alle 58 Dateien aus `docs/HANDOVER-ANHANG-MEMORIES-20260705/` → `/root/.claude/projects/-root/memory/` kopiert, `MEMORY.md`-Index generiert (58 Einträge). Persistiert über Reboot/Sessions hinweg.

### 1.3 Repo-/Git-Ist-Verifikation (Handover §0.4)
Alle Klone durch Vorsession vorhanden (`/root/keys/dipl-clone.log`), Stände deckungsgleich mit Handover:
- **super** `/root/Projekte/Research/probst-diplomarbeit-cache-engine`: `81f0975` (main, clean, origin/main)
- **cache-engine** `Code/external/comdare-cache-engine`: `c4eb7d7f` = AP-15-1 (detached HEAD — vor Arbeit auf main/Branch checken!)
- **prt-art** `Code/external/comdare-prt-art`: `7997a0b` (detached HEAD)
- **thesis** `thesis/diplomarbeit`: `75da5b8` (Text-Agent-Zone, NUR lesen)

### 1.4 Zugänge/Umgebung prod1 (diese Maschine, hostname `prod1`)
- **GitLab-API funktioniert:** `curl --cacert /root/Projekte/Cluster/keys/gitlab-ca-ROOTCA-20260621.crt -H "PRIVATE-TOKEN: $(cat /root/keys/***CRED-NAME-REF:***CRED-NAME-REF:gitlab-pat******)" https://gitlab.comdare.de/api/v4/user` → **HTTP 200**, user=root(id=1). PAT liegt in `/root/keys/***CRED-NAME-REF:***CRED-NAME-REF:gitlab-pat******`.
- **⚠️ Remotes unvollständig:** super+ce+prt-art haben NUR `origin`=GitLab (mit eingebettetem PAT in URL). **GitHub-Remote (BenniProbst/<repo>) FEHLT auf dieser Maschine** — vor erstem Push-Increment einrichten (Token: `Projekte/Cluster/keys/github-token.txt`; Kadenz verlangt Push zu BEIDEN Remotes).
- **Toolchain prod1:** cmake 4.3.4 · g++ **16.0.1 trunk r16-8100** (= exakt der ICE-verursachende Trunk-Compiler wie auf den Runnern!) · clang **22.1.8** · git 2.43.0 · **clang-format FEHLT lokal** → vor erstem Code-Commit clang-format exakt 22.1.8 beschaffen (apt clang-format-22 sollte zur installierten clang-Version passen; CI-Pin beachten).
- Kein gcc-15/gcc-13 lokal geprüft — Runner-Inventar kommt ohnehin via CI-Job `toolchain:probe` (A2), nicht lokal.

### 1.5 Pflichtlektüre (Handover §0) — VOLLSTÄNDIG gelesen
1. Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`: §0–§11 + §13.3 (Katalog) + §13.4 (GOAL V2) + §13.5–13.8 + **§13.9 (User-Entscheide A1–E3)** + **§13.10 (W1–W5 + korrigierte Definitionen AP-2/S7/7b-3/AP-10 + OFFEN-Liste)** + §13.11 (Schluss-Nachtrag). (§12-Chronik nur überflogen — historisch.)
2. Session-Handover `docs/sessions/20260705-SESSION-HANDOVER-goalv2-audit-restore-ci-s7-ap7b.md` komplett (Degenerationen §4, Fallstricke §5).
3. `docs/sessions/20260705-matrix-grundlagen-goalv2/MATRIX-GRUNDLAGEN-GOALV2.md` komplett (normativ #256/#274/#265/#266).
4. `docs/HANDOVER-BEP-ABTEILUNG-20260705.md` + `docs/HANDOVER-ANHANG-TODO-BOARD-20260705.md` komplett.

## 2. AUFGABENTEILUNG (User-Ansage diese Session)
Zwei Abteilungs-Aufgaben; **diese Session = Diplomarbeit-Weiterimplementierung** (Goal V2, Stränge A–G). Die zweite Aufgabe übernimmt eine andere Claude-Session — hier NICHT anfassen.

## 3. NÄCHSTER SCHRITT (nach Reboot hier fortsetzen)
**Strang A (#258/#257-Rest/#273-T2) gemäß Goal-V2-Reihenfolge:**
1. **mimalloc-Include-Fix** (Ledger §13.11 Schluss-Nachtrag = „ERSTER Punkt für die Abteilung"): `libs/.../axes/alloc/axis_06_allocator_mimalloc.hpp:38` includiert nicht-existentes `topics/allocator/axis_06_allocator/legacy_code/paper_a04_mimalloc_is_original.hpp` → auf existierenden libs/-legacy_code-Pfad korrigieren ODER Datei nachliefern. Vorher Kartierung (wo liegt die Datei wirklich, wer konsumiert sie), Kadenz §2 Handover einhalten (Dossier→Impl→Voll-Review→Mojibake-Check→clang-format→doppelt-literale Verifikation→granularer Commit→BEIDE Remotes→Pipeline).
2. **A1:** Endstatus Pipelines ce 7930 + 7963/7965/7974-Nachfolger via GitLab-API dokumentieren; deterministische Fehler fixen, nicht re-triggern.
3. **A2:** `toolchain:probe`-Output der nächsten super-Pipeline lesen → T2-Entscheid gcc-15.3-Pin (Kette 15→14→13) in ci-templates `base-pipeline.yml` ODER Infra-HO „gcc-15.3 installieren" (HO-11, Strang F).
4. Davor GitHub-Remotes einrichten + clang-format 22.1.8 beschaffen (s. 1.4).

**Merkposten:** Board-Tasks dieser Session (harness-lokal, nach Reboot neu anlegen): Stränge A–F als Tasks #4–#9 angelegt gewesen; Reihenfolge = Goal V2. Die 3 offenen User-Gates (Handover §5: Datensatz-Katalog 6-vs-48 · 7b-3-Andockpunkt T12-vs-09b · AP-15-Scope Set/Sequence) sind weiterhin unbeantwortet — betroffene Punkte erst nach User-Antwort bzw. mit dokumentierten Empfehlungs-Defaults.

**TABUS gelten unverändert** (Handover §2 / Ledger §13.4): ABI-MAJOR==4 · golden-320/AllStrategies/First-4/conformance-Oracle unantastbar · Messdaten/Doku nie löschen · Remotes nie löschen/anlegen ohne User-Auftrag je Repo · `apps/perm_runner/main.cpp` = User-Live-Datei · Cluster strikt read-only · AskUserQuestion nie · keine Erfolgsmarke ohne literale Ausgabe.

## 4. STATUS DIESES DOKUMENTS
Bewusst **uncommitted** (additiv, Working Tree sonst clean): Commit erst zusammen mit dem ersten Increment ODER nachdem GitHub-Remote eingerichtet ist (Push-BEIDE-Remotes-Regel; halber Push wäre Regelverstoß).
