# SESSION-ENDE 3 (2026-06-27) — Elaborate Übergabe: CI-Härtungs-Wellen + Codex-Integration + prod2-Verdikt

> **Definitive Übergabe bei Kontext-Ende.** Knüpft an `20260626-SESSION-ENDE-2-…` + `20260626-KONSOLIDIERT-OFFENE-TASKS-SELF-HANDOFFS.md` (weiter gültig) an. Diese Datei = das NEUE Material seit dann (Waves 1-4, Codex, prod2-HW-Verdikt, PAT-Rotation).
> **Rolle:** Implementierungsagent · **Primärziel:** CI grün auf 4 Modulen (286/287/288/289) + Härtung + echtes Debuggen. „Bitte rate nie."

---

## 0. STATUS-SCHNAPPSCHUSS (2026-06-27 ~10:41 UTC)
- **4-Modul-CI-Foundation:** super ✅ · thesis #6991 ✅ · cache-engine + prt-art mehrfach grün gelaufen (harte Gates: lint:secrets+build+contract). **Wave-4-Pipelines #6999/#7000/#7001 = PENDING** (Runner-Backlog, healthy) — laufen an; **noch NICHT als grün verifiziert** (kein Erfolgsmark ohne Tool-Ausgabe).
- **Git-HEADs (gepusht GitLab+ggf. GitHub):** cache-engine `c8ab46e` (REV14) · prt-art `f98445e` (REV14) · super `772406d` (REV12) · thesis `e5d000f` (REV1) · Cluster-Ledger `2e39752`.
- **Runner:** prod1=16 gesund (`concurrent=2` + cgroup 8 Kerne); **`auto_cancel_pending_pipelines=disabled`** auf allen 4 Projekten (Hang-Schutz → ABER Backlog bei schnellen Pushes). prod2=17 pausiert.
- **Codex MCP** verbunden (`mcp__codex__codex`), Config `gpt-5.5`/`xhigh`.

## 1. WAS DIESE SESSION GESCHAH (Wellen)
- **Welle 1:** A-Rest = prod1 `systemctl daemon-reload` + `CMAKE_BUILD_PARALLEL_LEVEL=4` (alle Build-CIs) · **B** = `lint:format/static` → `rules: when:manual` (raus aus jedem Push, harte Gates bleiben). Beide gepusht + **B verifiziert** (jobs = `manual (AF)`).
- **Welle 2:** prod2-I/O-Fix safe parts (non-disruptive): `rasdaemon` aktiv (MCE-Logging, Baseline 0 Fehler) + writeback-Burst gekappt (`/etc/sysctl.d/99-comdare-writeback.conf`: `dirty_bytes=1G`/`dirty_background_bytes=256M`, reboot-fest).
- **Welle 3:** **Sanitize-Stufe (ASan+UBSan, 10-Stufen P1b)** auf cache-engine + prt-art (`allow_failure`, eigener Debug-Sanitizer-Build, kein Artefakt).
- **Welle 4:** **Codex-Review-Fixes** — `needs: ["lint:secrets"]` statt `needs: []` auf allen Build/Sanitize/Contract/Verify-Jobs (gated auf den harten Secrets-Check, bleibt parallel) + CMAKE-Kommentar `=8`→`=4` (Doku-Bug). Von **Codex gpt-5.5/xhigh als „none new" bestätigt**.
- **prod2-Hardware-Test** (eigene große Aufgabe, abgeschlossen): Verdikt = **I/O-Writeback-Stall, NICHT CPU** (s. `VERDIKT-FINAL.md` + Memory `project_prod2_hardware_verdict_io_not_cpu`).
- **Codex als Review-Tool integriert** (User-Direktive) + Setup-Doku `docs/CODEX-CROSS-REVIEW-SETUP.md`.

## 2. ARCHITEKTUR-KONSOLIDIERUNGEN
- **CI-Gating-Modell:** harte Gates (gitleaks 8.30.1 + build/contract) gaten via `needs: ["lint:secrets"]`; advisory Lints (clang-format/cppcheck) = `when:manual` bis #179; Sanitize = advisory-Stufe. 10-Stufen-Stand: lint/build/sanitize/contract ✅; integration/chaos/manifest/deploy/canary = infra-gated offen.
- **Codex-Cross-Review-Loop** (NEU, dauerhafte Arbeitsweise): nach Code-Änderung `mcp__codex__codex` (gpt-5.5/xhigh, read-only, cwd=Code-Repo) → Befunde → einarbeiten → Re-Review. NIE auf Cluster-Repo/`keys/`/`machines/` (Daten-Exposition an OpenAI).
- **prod2-Verdikt** löst den Ledger↔Runbook-Widerspruch: CPU einwandfrei (stress-ng --verify 0 Fehler, µcode 0x133, 93 °C kein Throttle); Crash = Kernel-Writeback-Spinlock auf der geteilten NVMe (Host-Root p2 + VM-raw p3/p5). `pmc:intel` reaktivierbar NACH I/O-Fix (nicht CPU-Tausch).

## 3. FALLSTRICKE (diese Session NEU/teuer)
- ⭐ **`systemctl daemon-reload` ≠ Dienst-Restart** — lädt nur Units; ein hängender gitlab-runner bleibt hängen. Für Runner-Hang IMMER `systemctl restart gitlab-runner`.
- ⭐ **`auto_cancel_pending_pipelines` war AN → Push verdrängte laufende Pipeline → Cancel → prod-Runner-Hang.** Jetzt auf allen 4 Projekten **disabled**. KEHRSEITE: schnelle aufeinanderfolgende Pushes erzeugen **Backlog** (kein Superseding) → Runner arbeitet ALLE ab (concurrency=2). Nicht selbst per API canceln (Cancel = Hang-Trigger)!
- ⭐ **GitLab-PATs rotieren häufig → NIE festen Wert/Zeile annehmen.** Bash-Grep `head -1` zog die FALSCHE (alte) Variante einer keeper-root-Zeile mit zwei Tokens → 401. Lösung: ALLE `glpat-…`-Kandidaten testen (`/api/v4/user`=200 ODER `git ls-remote`), den lebenden nehmen. **Quelle = Cluster-Vault `CREDENTIALS-VAULT.md`** (Desktop/keys war 06-27 transient, wurde rückkonsolidiert). 06-27 live = `glpat-7sR…`.
- ⭐ **Git-Bash `curl` gibt hier `000`** (TLS/revocation) trotz `--cacert`; Windows `curl.exe --ssl-no-revoke` (PowerShell) funktioniert. Für API-Checks PowerShell+curl.exe, für Pushes Git-Bash-`git` (dessen TLS geht).
- ⭐ **`needs: []` schwächt das Gate** (Jobs warten nicht auf lint:secrets) — Codex-Befund, gefixt zu `needs: ["lint:secrets"]`.
- ⭐ **Codex-Config-Änderung greift erst nach MCP-Server-Neustart** — ich kann user-scoped MCP NICHT aus einem Tool neu starten (Claude-Code-Aktion). Workaround: per-call `model:"gpt-5.5"` + `config:{model_reasoning_effort:"xhigh"}` erzwingt es restart-unabhängig.
- ⭐ **prod2 läuft die prod-K8s-CP-VM `talos-prod2`** (KVM, 40GB/20vCPU, VFIO+raw-NVMe) → Stress-Tests/Reboots = kritisches Manöver (VM `virsh suspend` + Autostart-Safety + 2/3-etcd-Quorum). NVMe `nvme0n1` ist mit der VM geteilt (Crash-Ursache).
- (weiter gültig: Cancel-hängt-Runner, prod2-SSH nur via `admin-management@.212`+cluster-Key, V10-only, apt-Egress→bare-metal, INTERFACE-Lib-via-Consumer, ctest-`^name$`, gitleaks-PDF, Transfer=PUT.)

## 4. TODOs / OFFEN (mit Blocker)
1. **[P0] Wave-4-Pipelines grün verifizieren** (#6999/#7000/#7001, sha c8ab46e/f98445e/772406d) — Backlog abwarten, dann Job-Stände literal prüfen (live Vault-PAT). Bei Fehler Trace holen (kein Raten).
2. **Mess-Voll-Lauf #156/#162** (Thesis-Kern, reale Cache-Misses; durch Linux+PMC auf prod1 ENTSPERRT) — **braucht User-Zeitfenster** (mehrtägig, lastet prod1 aus) → dann Background-Lauf + NAS-Writeback.
3. **#179 Wartbarkeits-/Lesbarkeits-Sweep** (ALLE C++-Dateien, 4 Repos) — **dedizierter Mehr-Session-Lauf**, datei-für-datei **mit Codex-5.5/xhigh-Gegenreview pro Datei** (User-Direktive). Erst danach lint:format/static auf HART + `test_v41`-Linux-Vollbau.
4. **10-Stufen-Rest** (integration/chaos/manifest-prebackup/K8s-deploy/deploy-staging/smoke-canary) + **prod→dev-DB-Gate** (§8b) — infra-gated (K8s-Deploy-Ziel + Artefakt-Storage-500).
5. **prod2-I/O-Fix** (Kernel-Update 6.8.0-124→neuer · Host-Root/VM-Disk trennen · `softlockup_panic=1`) → dann **`pmc:intel` reaktivieren** (Runner 17 ent-pausieren, `COMDARE_PROD2_AVAILABLE=true`). Infra/Wartungsfenster (prod2 KEIN IPMI → Brick-Risiko).
6. **gitlab-runner 19.1.0→19.1.1** (idle-Fenster, „neueste Tools") — optionales Hardening gegen Rest-Hangs.
7. **Vorbestehend** (Diplomarbeit): #19, #125, #152, #162/#163/#165, #178, #184, #185, #187, #188, #189.

## 5. WICHTIGE DIREKTIVEN (nächste Session beachten)
- 🔁 **Codex-Gegenreview bei JEDER Code-Aufgabe** (`mcp__codex__codex`, gpt-5.5/xhigh per-call, read-only) vor „done" — Memory `feedback_codex_mcp_review_before_code_complete`. Nur Code-Repos, NIE Cluster/keys.
- 🔑 **PAT immer lebend ermitteln** (Vault, alle Kandidaten testen) — Memory `reference_gitlab_admin_access_keeper_pat_and_transfer_block` (06-27 aktualisiert).
- 🛡️ Secrets redacted, PAT nie im Output/Commit; thesis-Commits OHNE Co-Authored-By, Code-Repos MIT; Messdaten nie löschen; keine destruktiven Cluster-git-Ops.
- 🧮 Runner-Core-Budget: concurrent=2 + cgroup halbe Kerne; CI-`-j`=`CMAKE_BUILD_PARALLEL_LEVEL` (=4), nie nproc.
- 📑 IMMER zuerst KONSOLIDIERT-Handout + dieses Doc lesen; „rate nie", Annahmen verifizieren.

## 6. ZUGANG / QUELLEN (keine Secrets hier)
- **GitLab-PAT:** Vault `…/Cluster/keys/CREDENTIALS-VAULT.md`, lebenden testen; CA `keys/gitlab-ca-ROOTCA-20260621.crt`. Push: Git-Bash-`git -c http.sslCAInfo=<CA> -c credential.helper=<oauth2/$GL_PAT>`. API-Check: PowerShell `curl.exe --ssl-no-revoke --cacert`.
- **prod1:** `root@10.0.10.211` (cluster-Key, CRLF-strip). **prod2:** `admin-management@10.0.10.212` (cluster-Key, Infra-gelegt, sudo -n). Pi5-Bastion `node7@10.0.10.207`. Windows-Desktop = V10-only.
- **Codex:** `~/.codex/config.toml` (gpt-5.5/xhigh); Setup `docs/CODEX-CROSS-REVIEW-SETUP.md`; per-call-Override nutzen bis Plugin-Restart.
- **Repo-IDs:** cache-engine 286, prt-art 287, super 288, thesis 289, ci-templates 269.
- **Belege prod2:** Desktop `prod2-HW-Test-20260626\` (9 Dateien).

## 7. EMPFOHLENE REIHENFOLGE NÄCHSTE SESSION
1. Wave-4-Pipelines grün bestätigen (Backlog abgearbeitet?).
2. Entscheidung User: **Mess-Voll-Lauf-Zeitfenster** ODER **#179-Sweep-Start** (s. offene Fragen).
3. Memory/Docs aktuell halten; Codex-Review-Loop bei allen Code-Schritten.

## 8. ENTSCHEIDUNGEN (User 2026-06-27, autoritativ für nächste Session)
- **Nächster dedizierter Fokus = prod2-I/O-Fix** (entsperrt die Intel-CI-Seite `pmc:intel`). Umfang: Kernel-Update (6.8.0-124→neuer) + Host-Root von den VM-Disks trennen (ODER writeback-/IO-Scheduler-Tuning als Zwischenschritt) + `softlockup_panic=1` (Auto-Reboot-Sicherung). ⚠️ **KRITISCHES MANÖVER — IMMER MIT USER ABSPRECHEN (CLAUDE.md):** der prod2-HOST (10.0.10.212) fährt die prod-K8s-Control-Plane-VM `talos-prod2`; ein Kernel-Update braucht Host-Reboot → VM-Handling (suspend/Autostart) + etcd-2/3-Quorum-Toleranz + **prod2 hat KEIN funktionierendes IPMI = Brick-Risiko ohne Vor-Ort-Zugang**. → Erst PLAN + Wartungsfenster + ausdrückliches User-Go, DANN ausführen (kein Blind-Reboot). Nach dem Fix: Runner 17 ent-pausieren + CI-Var `COMDARE_PROD2_AVAILABLE=true` → pmc:intel grün. Zugang: `admin-management@10.0.10.212` (cluster-Key, sudo -n); rasdaemon läuft bereits (MCE-Baseline 0). Details: Memory `project_prod2_hardware_verdict_io_not_cpu` + Desktop-`VERDIKT-FINAL.md`.
- **Runner-Härtung = gitlab-runner 19.1.0→19.1.1 upgraden** (Idle-Fenster auf prod1: `apt-get install` + `systemctl restart`) **+ danach `auto_cancel_pending_pipelines` wieder AN** (alle 4 Projekte via API-PUT). **Reihenfolge: Upgrade ZUERST**, sonst kehrt der Cancel-Hang mit re-aktiviertem auto-cancel sofort zurück. Falls der Hang TROTZ 19.1.1 wiederkehrt → Self-Healing-Watchdog (Stale-Heartbeat → `systemctl restart`). Vorher: Backlog leerlaufen lassen (Wave-3+Wave-4-Pipelines), Upgrade nur wenn Runner idle.
- (NICHT gewählt als nächster Fokus, bleiben offen: **Mess-Voll-Lauf #156/#162** [braucht später User-Zeitfenster] + **#179-Sweep** [autonom-mehr-Session mit Codex].)
