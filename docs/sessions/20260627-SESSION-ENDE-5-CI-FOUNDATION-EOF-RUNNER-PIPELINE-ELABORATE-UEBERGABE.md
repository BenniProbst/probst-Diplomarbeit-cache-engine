# SESSION-ENDE 5 (2026-06-27, Teil 3) — Elaborate Übergabe: CI-Foundation GRÜN + EOF-Runner-Wurzel + Pipeline-Stufen-Ausbau

> **Definitive Übergabe bei Kontext-Ende.** Knüpft an `SESSION-ENDE-4` + `20260627-TODO-KONSOLIDIERUNG-ELABORAT.md` (50 TODOs) + `20260627-MANUAL-RUN-GAP-ANALYSE-CODEX.md` an. Rolle: **Implementierungsagent der Diplomarbeit.** Diese Session = der CI-Pipeline-Foundation-Durchbruch.

---

## 0. STATUS-SCHNAPPSCHUSS (2026-06-27 ~17:5x UTC)
**Git-HEADs (gepusht GitLab):**
- cache-engine (286) `07220a2` (#193 ps1-resolve + #195 durability-Gate; davor 9480f98/e4bf7c8/5b188be-Drift)
- super (288) `d333ea7` (#196 integration:smoke + cache-engine-Submodul-Bump; davor cf2d446 forward:false, 01846ca TODO-doc)
- ci-templates (269) `5ddfd4a` (`.lint-base` CITOOLS-Fallback)
- prt-art (287) `f98445e` · thesis (289) `a97f9c7`
- **Runner prod1 (id 16): 19.1.1 · `request_concurrency=4` · EOF-Auto-Heal-Watchdog aktiv.** prod2 (17) pausiert.

**CI-Foundation = GRÜN verifiziert** (literal, wörtliche Tool-Ausgabe):
- #194 super-Orchestrierung: super #7029 `success`, alle 3 Bridges→Downstream `success`.
- #195 `contract:durability` = `success` (16 Müll-Configs ohne Crash).
- #196 `integration:smoke` = `success` (E2E-Auswerte-Kette record.bin→CSV→LaTeX/TikZ).

## 1. MISSION DIESER SESSION
User-Korrektur: „Die Pipeline steht noch nicht und ist die GRUNDLAGE für jede weitere Überarbeitung — fertigstellen." + „dieser Laptop ist zu langsam für Tests → Verifikation auf die Pipeline (schnelle prod-Runner)" + „du darfst schwere Aufgaben erledigen, ich sichere sie ab". Codex hat 48 offene Impl-TODOs seit 12.06 gefunden → sichtbare TODO-Liste erweitert (#194–210) + elaborates Konsolidierungs-Doc.

## 2. WAS GRÜN GEMACHT WURDE (committet + literal verifiziert)
- **Pipeline-rot root-caused + behoben:** super-Orchestrierung forwarded per `trigger:forward`-Default ihre Variablen (`GIT_SUBMODULE_STRATEGY:recursive`, `COMDARE_CITOOLS_DIR`) in die getriggerten Downstream-Modul-Pipelines → `mkdir /.citools` Permission-denied + Submodul-Checkout → `lint:secrets` failt. **Fix:** `trigger:forward:{yaml_variables:false, pipeline_variables:false}` auf den 3 Bridges (super `cf2d446`) + `.lint-base` CITOOLS-Fallback in ci-templates (`5ddfd4a`).
- **#195 contract config-durability** (Sub-Agent + Codex-Review): `tests/unit/test_config_durability.cpp` (16 Müll-XML → parse_document kein-Crash + parse_load_profile nullopt + Positiv-Kontrolle) + CMake-Reg + CI-Job `contract:durability`. **grün**.
- **#196 integration:smoke** (Sub-Agent erkundet, von mir auf super-Root korrigiert): super-Root-`.gitlab-ci.yml` `integration`-Stufe — baut 4 leichte Auswerte-Tools (01/03/04/05, keine perms-DLLs/Infra) + reale record.bin→CSV→LaTeX/TikZ-Kette auf committeten Fixtures. **grün**. (= auch #193-Auswerte-Kette CI-verifiziert.)

## 3. ⭐ ARCHITEKTUR-KONSOLIDIERUNG — die wahre „Runner-Hang"-Wurzel (für ALLE künftigen CI-Sessions)
**Es war NIE der Runner.** `journalctl -u gitlab-runner`: `WARNING: Checking for jobs... failed — POST https://gitlab.comdare.de/api/v4/jobs/request: EOF` — der **Server/Proxy kappt intermittierend die Long-Poll-Verbindung** (Runner pollt korrekt, bekommt EOF → keine Jobs → Pipelines „pending" → sieht aus wie Hang; `contacted_at` stale weil die Requests fehlschlagen). Zwei Erscheinungsformen: (a) EOF-Sturm im Idle, (b) stiller Stall mitten in Jobs (GitLab zeigt Jobs „running", Completion wird nie gemeldet).
- **Runner-seitige Milderungen (erledigt, halfen nur teils):** `request_concurrency=4` (config.toml, Backup `config.toml.bak-reqconc`) + Upgrade 19.1.0→**19.1.1**.
- **⭐ DURABLE Auto-Heal (erledigt, wirkt — #7036 lief durch ohne manuellen Restart):** systemd `gitlab-runner-eof-watchdog.timer` (alle 2 min): restart bei (EOF-Sturm ≥8/2min) ODER (0 erfolgreiche GitLab-Comms in 8min ∧ uptime≥9min). Script `/usr/local/bin/gitlab-runner-eof-watchdog.sh`. Sicher (bei Stall läuft kein Job).
- **ECHTER FIX = INFRA (#210), USER-AUTORISIERT („Ich mache den HAProxy-Fix selbst"), NÄCHSTE SESSION:** s. §4.
- Memory: `reference_gitlab_trigger_forward_downstream_pollution` (forward:false + EOF + Watchdog).

## 4. #210 HAProxy-EOF-FIX — präziser Plan (User-Go vorhanden, nächste Session ausführen)
**Zugang bestätigt:** `ssh -i ~/.ssh/cluster root@10.0.10.11` (opn-1 MGMT V10, CARP-Master; Cluster-Key CRLF-strip via `tr -d '\r'`). opn-2 = HA-Partner (haproxy-config-sync MASTER→opn-2, Key `cluster-access`). Fallback-Login: OPNsense-root-PW = ***CRED-NAME-REF:***CRED-NAME-REF:universal-admin-pw****** (Vault). **OPNsense NUR via V10 erreichbar.**
**Pfad:** runner → OPN-HAProxy (SNI gitlab.comdare.de) → dev-K8s-Ingress (10.0.40.6) → GitLab-Workhorse. EOF kann an jedem Hop entstehen.
**SCHRITTE (read-only ZUERST — rate nie):**
1. opn-1: HAProxy-Config des gitlab.comdare.de-Backends lesen (`cat /usr/local/etc/haproxy.conf` bzw. config.xml) → `timeout server`/`timeout tunnel`/`timeout client` ermitteln. Wenn < ~60s → das ist die Wurzel.
2. Falls HAProxy-Timeout < Long-Poll: `timeout server` + `timeout tunnel` fürs GitLab-Backend auf **≥120s** (besser 300s, Long-Poll/Git-Clone-tauglich). **REBOOT-SICHER via config.xml/Plugin** (Memory `feedback_opn_config_xml_only_reboot_safe`), NICHT Hand-`haproxy.conf` (Kaltstart-Risiko). os-haproxy-CLI-Objekte: Memory `reference_opnsense_oshaproxy_cli_object_creation` + `reference_opnsense_haproxy_staging_live_deploy` (template reload → STAGING, dann graceful softreload promote; **opn-1 syshook friert bei softreload ein** — Caveat). **BEIDE OPN** (XMLRPC-Sync MASTER→opn-2).
3. Falls HAProxy-Timeout OK → Ursache ist K8s-Ingress-Timeout ODER GitLab-Workhorse-Flapping (dev-K8s; Secret-Swap-Nachwehen) → dort prüfen.
4. Verifizieren: nach dem Fix EOF in journalctl weg + Pipeline läuft ohne Watchdog-Restart durch. Watchdog danach als Netz behalten.
⚠️ **KRITISCH:** OPNsense = prod-Firewall (serviert gitlab.comdare.de + alles). Vorsichtig, beide OPN, reboot-sicher, verifizieren. Watchdog mildert, also KEIN Zeitdruck.

## 5. 10-STUFEN-PIPELINE — Stand
| Stufe | Status |
|---|---|
| lint (secrets HART; format/static manual) | ✅ |
| build (prod1/AMD) | ✅ |
| sanitize (ASan/UBSan, advisory) | ✅ (→#204 HART) |
| contract (ABI + **durability #195**) | ✅ |
| **integration (#196 E2E-Smoke)** | ✅ NEU |
| chaos (#197: >5% Drift→3× Wdh.+Warn-Log) | ⬜ nächste (autonom baubar) |
| manifest+prebackup (#198) | ⬜ nächste (autonom baubar) |
| k8s-deploy (#199) · deploy-staging/prod→dev-Gate (#200) · smoke-canary (#201) · NAS-Writeback+Binary-Release+PDF (#202) | ⬜ **INFRA-GEGATET** (K8s-Deploy-Ziel + MinIO/NAS) |
| super-Orchestrierung (#194) | ✅ |

## 6. FALLSTRICKE (diese Session NEU)
- ⭐ **`trigger:forward`-Default pollutet Downstream** (super-Variablen → /.citools + Submodul-Checkout). Fix forward:false. [[reference_gitlab_trigger_forward_downstream_pollution]]
- ⭐ **„Runner-Hang" = serverseitiger EOF auf /jobs/request** (nicht der Runner). Watchdog mildert; Infra-Fix #210.
- ⭐ **Orchestrierungs-Explosion:** jeder super-Push = super + 3 re-getriggerte Downstream = ~4 Pipelines × concurrency=2 + auto-cancel-OFF → Backlog (langsam). (auto-cancel bleibt aus bis #208-Härtung.)
- ⭐ **Code/ ist KEIN eigenes Repo** — Unterordner des super (288); super-CI = ROOT `.gitlab-ci.yml` (nicht Code/.gitlab-ci.yml). Submodule unter `Code/external/`, .gitmodules am super-Root.
- ⭐ **OPNsense nur via V10** (`root@10.0.10.11`, Cluster-Key); root@10.0.10.243 landet auf OPN (nicht NAS).
- ⭐ **Vault = ***CRED-NAME-REF:***CRED-NAME-REF:universal-admin-pw******** (OPNsense/FortiGate/Pi5/Samba/BGP/ZIH/Matrix) — bei Vault-Reads AGGRESSIV redacten (SecretKey/AccessKey/PW).
- ⭐ **PowerShell ConvertFrom-Json** bricht bei getrunkter API-Antwort (EOF) → Poller in try/catch.

## 7. TODOs / NÄCHSTE SCHRITTE (Single-Source: `20260627-TODO-KONSOLIDIERUNG-ELABORAT.md` + Tasks #194–210)
1. **#210 HAProxy-EOF-Fix** (User-Go, §4) — read-only zuerst, dann reboot-sicher beide OPN.
2. **#197 chaos** + **#198 manifest+prebackup** (autonom baubar, Pattern wie #195/#196: Job in ci-templates/Modul, auf prod-Runner verifizieren via Poller).
3. **#199–202** (k8s-deploy/deploy-staging/canary/NAS-Writeback) — **infra-gegatet** → Infra-Handoff/User-Go (K8s-Ziel + MinIO/NAS; #189).
4. **#203/#204** lint/sanitize HART (nach #179-Format-Pass). **#205** thesis-texlive-Gate (COMDARE_TEXLIVE_AVAILABLE=true auf prod1, TeX Live 2026 da).
5. **#208** auto-cancel safe wieder AN (jetzt mit 19.1.1 + Watchdog evtl. sicher). **#209** MinIO-Cache-SecretKey rotieren. **2 ***REDACTED***-Tokens** rotieren.
6. Diplomarbeit-Kern danach: #156/#162 Mess-Voll-Lauf · #179 codex-pro-Datei-Sweep · #193-Rest (USAGE-CLI/ExperimentDriver-Pfad).

## 8. DIREKTIVEN (nächste Session)
- **Verifikation NUR auf der Pipeline** (Laptop zu langsam); Spezial-Tests als CI-Jobs. Pattern: Job bauen → push → Poller (`/tmp/pollNNN.ps1`, try/catch) → grün bestätigen → Codex-Review.
- **Codex-Review** nach jedem Code-Abschnitt (gpt-5.5/xhigh, read-only, nur Code-Repos NIE Cluster/keys). Session-Start: ultracode-Survey + Codex-5-Summary.
- **prod1↔prod2 synchron** · **4 Research-Klone syncen** (external=Quelle) · thesis-Commits OHNE Co-Authored-By, Code-Repos MIT · Messdaten nie löschen · kein Erfolgsmark ohne literale Ausgabe.
- **PAT lebend** ermitteln (Vault, alle glpat testen) · Push: Git-Bash `git -c http.sslCAInfo=<CA> -c credential.helper`; API: PowerShell `curl.exe --ssl-no-revoke --cacert`.

## 9. ZUGANG (keine Secrets hier)
- GitLab-PAT: Vault `…/Cluster/keys/CREDENTIALS-VAULT.md` (lebenden testen); CA `keys/gitlab-ca-ROOTCA-20260621.crt`. Repo-IDs 286/287/288/289, ci-templates 269.
- prod1 `root@10.0.10.211` (Cluster-Key `~/.ssh/cluster`, CRLF-strip). **opn-1 `root@10.0.10.11`** (V10, Cluster-Key). prod2 `admin-management@10.0.10.212`.
- Watchdog: `/usr/local/bin/gitlab-runner-eof-watchdog.sh` + `.timer` (prod1). config.toml-Backup `config.toml.bak-reqconc`.
- Codex: gpt-5.5/xhigh per-call.
