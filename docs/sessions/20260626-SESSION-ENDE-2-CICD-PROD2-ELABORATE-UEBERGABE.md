# SESSION-ENDE 2 (2026-06-26) — Elaborate Übergabe: CI-Foundation + prod2-Komplex

> **Definitive Übergabe bei Kontext-Ende.** Supersedet `20260625-SESSION-ENDE-…` (überholt). Begleitdocs (NICHT löschen): `20260626-SESSION-RETROSPEKTIVE-VERSAEUMTE-UND-OFFENE-AUFGABEN.md` (Schuld-/Rest-Liste), `cluster_development/docs/RUNBOOK-prod2-14900KS-stabilitaetstest.md`, Memory `reference_cluster_ci_runner_access_topology`.
> **Rolle:** Implementierungsagent · **Primärziel:** CI grün auf 4 Modulen (cache-engine 286, prt-art 287, super 288, thesis 289) · **Direktive:** „Bitte rate nie."

---

## 0. STAND BEI KONTEXT-ENDE (Live, 2026-06-26 ~13:06 UTC)
- ✅ **super #6953 = GRÜN** · ✅ **thesis #6991 = GRÜN** (gitleaks-PDF-Fix) · ✅ **cache-engine AMD #6987 = GRÜN** (#6993 läuft erneut sauber)
- 🔄 **prt-art #6992 = running** (REV 11: nur `test_prt_art_identity`) — `build:standalone` noch unbestätigt
- prod1-Runner **gesund** (frischer Heartbeat nach Restart). prod2-Runner **pausiert** (crashy HW + SSH tot).
- Watcher `b06os5q3x` verfolgt die 4 Module bis terminal (prod1 seriell, concurrency=1).
- **Erwartung:** sobald prt-art `build:standalone` + cache-engine #6993 grün → **4-Modul-Foundation komplett grün** (prod1/AMD-Seite). Intel-Seite (`pmc:intel`) bewusst gegatet bis prod2 HW-OK.

---

## 1. GOAL + SCOPE
„…Arbeite erstmal nur die CI gitlab pipeline autonom ab… Zur CI gehört auch die Verbesserung aller Projektstrukturen und das echte Debuggen der Pipelines bis grüner Stand auf allen bezeichneten Projekten. Bitte rate nie." 4 Module. „Projektstruktur-Verbesserung" = CI-Hygiene JETZT + tieferer Umbau (01-06→semantisch, Skripte konsolidieren, Test-Runner/CMake vereinheitlichen) + #179-Sweep **NACH** grünem Netz.

## 2. SESSION-DIREKTIVEN (alle beachten)
1. **Lint hermetisch in-job** (gitleaks 8.30.1 hart; clang-format/cppcheck advisory bis #179). ✅
2. **prod→dev-DB-Sync-Gate** vor prod-Deploy (CICD-Doc §8b + Memory). Persistiert, NICHT implementiert (P1f, infra-gated).
3. **Runner-Core-Budget:** halbe Host-Kerne, concurrent=2 (Ubuntu-16→8, Talos-VM-20→10) = **config.toml/cgroup = Infra (#189)**. CI-`-j` = `CMAKE_BUILD_PARALLEL_LEVEL`. ⚠️ Aktuell prod1 concurrent=**1** → serieller Stau.
4. **prod2 (i9-14900KS) HW-verdächtig** (Crashes) → Hardware-Test (Runbook) durch User-Zugang, dann ich. Verdacht: Intel-13/14-Gen-Degradation → ggf. RMA.
5. **SECURITY (dauerhaft):** Credentials NUR Vault/`machines/Comdare`, redacted lesen, NIE in Chat/Commit/Output; PAT nur in-memory ($GL_PAT). **thesis-Commits OHNE `Co-Authored-By`**, Code-Commits MIT. Messdaten nie löschen. **Keys ändere ICH NICHT** (authorized_keys = Infra/User/IPMI). config.toml = Infra.

## 3. ARCHITEKTUR-KONSOLIDIERUNGEN DIESER SESSION
- **CI = include `comdare/cluster/ci-templates/base-pipeline.yml` + extends** (.lint-secrets/.lint-format/.lint-static/.build/.contract). Stage-Logik EINMAL in id=269.
- **cache-engine REV 11:** build+measure → EIN `pmc`-Smoke (kein build/-Artefakt); `pmc:intel` per `COMDARE_PROD2_AVAILABLE`-Var gegatet; contract = `test_abi_interface` (exakt).
- **prt-art REV 10/11:** Docker→**bare-metal** (kein apt-Egress im Cluster); INTERFACE-Lib `comdare_prt_art_core` via Test-Consumer bauen; **nur `--target test_prt_art_identity`** (build-ALL traf kaputten `test_internal_search`).
- **super REV 10:** Lint `GIT_SUBMODULE_STRATEGY:none` (nur eigener Code); analyse artefakt-arm; `thesis:pdf` texlive-gegatet.
- **thesis REV 1:** gitleaks (hart) + chktex/latexmk texlive-gegatet; `.gitleaks.toml` (PDF/EPS allowlistet + generic-api-key off).
- **Zugriffstopologie** (s. Memory `reference_cluster_ci_runner_access_topology`): Windows-Desktop = **V10-only**; Pi5/Bastion = `node7@10.0.10.207` (cluster-Key); prod1 = `root@10.0.10.211` (cluster-Key, kein Jump); **prod2-SSH TOT** (kein Key, auch nicht via Pi5 = der „SSH-Recovery"-Gate); prod2 hat **IPMI** (ASUS W680 ACE).

## 4. TODOs — VERSÄUMT + OFFEN (Kurzfassung; VOLL in der Retrospektive-Datei)
**Versäumt/umgangen:** echter Mess-Lauf (nur Smoke) · Artefakt-Storage-500 nur umgangen (Infra) · `test_v41_anatomy_module_abi` Linux-Vollbau nicht verifiziert · lint:format/static advisory-übersprungen (→#179) · 10-Stufen-Pipeline nur ~1/3 (sanitize/integration/chaos/deploy/canary fehlen) · prod→dev-Gate nicht implementiert · Core-Budget-Mismatch (CMAKE_BUILD_PARALLEL_LEVEL vs concurrent=2) · Session-Start-Ritual (15 Sessions+Masterpläne) unklar erfüllt · Memory-Lektionen §E z.T. offen.
**Offen/blockiert:** prt-art `build:standalone` + cache-engine #6993 Grün bestätigen · **prod2 Intel-Seite** (blockiert: HW+SSH) · **prod2-Hardware-Test** (wartet User-Zugang) · prod2-SSH-Recovery (Infra/IPMI) · config.toml concurrency=2 (#189) · tieferer Struktur-Umbau + **#179** (groß) · vorbestehende: #19,#125,#152,#156,#162,#163,#165,#178,#184,#185,#187,#188,#189.

## 5. FALLSTRICKE (vollständig — diese Session teuer erkauft)
- ⭐ **Pipeline-Cancel hängt den prod-gitlab-runner auf** → danach `systemctl restart gitlab-runner` (prod1-SSH geht). War DER „keine Jobs"-Blocker.
- ⭐ **prod2-SSH grundlegend tot** — kein Key, auch nicht vom Bastion Pi5. Nur via IPMI-Konsole/physisch lösbar (Key legen). Der Runner läuft trotzdem (pollt ausgehend).
- ⭐ **Windows-Desktop = V10-only** (10.0.10.x); Heim-LAN (192.168.178.x, inkl. Pi5@.66) **unerreichbar**. Pi5 via **V10-IP 10.0.10.207, User `node7`** (NICHT admin/root).
- ⭐ **Cluster-Docker-Runner ohne apt-Egress** → CI bare-metal, nicht `image: debian + apt-get`.
- ⭐ **INTERFACE-Lib** hat kein baubares Target → Consumer (Test) bauen, kein `--target <interface-lib>`.
- ⭐ **gitleaks scannt getrackte Binär-PDFs** (Entropie-FP-Schleuder) → PDF/EPS allowlisten + generic-api-key off. (Auch: scannt `.citools`+Submodule → Lint `submodule-none`.)
- ⭐ **Artefakt-Object-Storage 500 „invalid argument"** post-swap → keine großen `build/`-Artefakte (Infra-Sache).
- ⭐ **GitLab `contacted_at` = UTC** (lokal UTC+2) → „stale"-Fehldeutung vermeiden.
- ⭐ **Transfer = `PUT /projects/:id/transfer?namespace=`** (nicht POST). **Vault-Keys CRLF** → `tr -d '\r'`. **Runner-tag_list** nur im Detail-Endpoint. **OneDrive-Git träge** → Commit+Push trennen, Push ggf. nachholen. **PowerShell**: `$pid`/`gl`/`$rid:` Kollisionen.

## 6. CREDENTIALS / ZUGANG (KEINE Secrets hier)
- **GitLab-Admin** = keeper-root-PAT (Vault `…/Cluster/keys/CREDENTIALS-VAULT.md` §Rotation-Log) + CA `keys/gitlab-ca-ROOTCA-20260621.crt`. DNS+HTTPS reicht.
- **Push-Recipe:** `$env:GL_PAT=<vault>; git -c http.sslBackend=openssl -c http.sslCAInfo=<CA> -c credential.helper='!f(){ echo username=oauth2; echo "password=$GL_PAT"; };f' push <url> main` (PAT NIE echoen).
- **SSH:** Key CR-strippen (`tr -d '\r' keys/cluster > /tmp/k; chmod 600`). prod1=`root@10.0.10.211`✓; Pi5=`node7@10.0.10.207`✓; **prod2=tot**. Maschinen-Creds: `machines/Comdare/<user@ip - name>/` (Key+pw.txt).
- **Repo-IDs:** cache-engine=286, prt-art=287, super=288, thesis=289, ci-templates=269, cluster-Gruppe=340. Runner: prod1=16, prod2=17 (pausiert). CI-Var `COMDARE_PROD2_AVAILABLE`(286)=false.

## 7. GIT-STAND (gepushte HEADs)
| Repo | HEAD | Inhalt |
|---|---|---|
| ci-templates(269) | `63c13ac` | base-pipeline v4 |
| cache-engine(286) | `cc91122` | REV 11 (Include-Fix + pmc + contract-narrow) |
| prt-art(287) | `a23187e` | REV 11 (bare-metal + INTERFACE-via-Consumer + --target) |
| super(288) | `17428ad` | REV 10 (submodule-none + artefakt-arm) |
| thesis(289) | `e5d000f` | REV 1 CI + .gitleaks.toml |

## 8. NÄCHSTE SCHRITTE (Reihenfolge)
1. **Watcher b06os5q3x auswerten** → prt-art `build:standalone` + cache-engine #6993 grün bestätigen = 4-Modul-Foundation grün dokumentieren. Bei Fehler: Trace holen (kein Raten).
2. **prod2-Hardware-Test** fahren, sobald User-Zugang (cluster-Pubkey auf prod2 via IPMI ODER BMC-Creds) → Runbook → Ergebnis-Ordner Windows-Desktop → Verdikt (RMA?).
3. Memory-Lektionen (Retrospektive §E) persistieren + MEMORY.md-Pointer für `reference_cluster_ci_runner_access_topology`.
4. **#179-Sweep + tieferer Umbau** + lint:format/static HART + `test_v41`-Linux-Vollbau (gefixte Includes).
5. Rest-Stufen 10-Stufen-Pipeline (sanitize/integration/chaos/deploy/canary) + prod→dev-Gate.
6. Intel-Seite reaktivieren (prod2 HW-OK + SSH-Recovery, Infra) → `COMDARE_PROD2_AVAILABLE=true`.
7. Mess-Lauf-Architektur (separater Job + NAS-Writeback) sobald Artefakt-Storage (Infra) ok.

## 9. ENTSCHEIDUNGEN (User 2026-06-26, autoritativ für nächste Session)
- **A — ERLEDIGT:** concurrency=2 auf prod1 von mir gesetzt: `concurrent = 2` in `/etc/gitlab-runner/config.toml` + cgroup `CPUQuota=800%` (8 Kerne) + Runner-Restart. Backup: `config.toml.bak-concfix`. **TODO nächste Session:** (1) `systemctl daemon-reload` auf prod1 (Drop-in-Warnung sauber machen); (2) **`CMAKE_BUILD_PARALLEL_LEVEL=4`** in den 3 CIs setzen (8 Kerne / 2 concurrent — aktuell 8/4 = leichte Oversubscription); (3) gleiche config (concurrent=2 + cgroup) auf prod2 (nach HW-OK) + K8s-Runner anwenden (Teil #189). **User hat config.toml-Eingriff auf den prod-Runnern damit für mich freigegeben.**
- **B — TODO nächste Session:** `lint:format` + `lint:static` bis zum #179-Format-Pass auf **`when: manual`** (raus aus jedem Push → schnellere Foundation; harte Gates bleiben). Umsetzen via base-pipeline `.lint-format`/`.lint-static` ODER per-Modul. Beim #179-Format-Pass reaktivieren + auf HART stellen.
- **C — Nächster Fokus nach 4-Modul-grün:** **#179-Sweep + tieferer Struktur-Umbau** (01-06→semantisch, Skripte konsolidieren, Test-Runner/CMake vereinheitlichen, lint:format/static hart, `test_v41`-Linux-Vollbau). GROSS, datei-für-datei. (Rest-10-Stufen + Mess-Architektur danach.)
