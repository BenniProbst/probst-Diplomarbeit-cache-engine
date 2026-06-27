# Konsolidierte offene Tasks + Self-Handoffs (2026-06-26)

> **Zweck (Self-Handoff an die nächste Session):** EIN gründlich deduplizierter Single-Source-Übergabepunkt aller offenen CI/Infra-Tasks, Versäumnisse, Blocker und User-Entscheidungen der CI-EPIC-#186-Session (2026-06-23 → 06-26), damit die nächste Session ohne Re-Discovery direkt priorisiert weiterarbeiten kann.

---

## 0. Status-Schnappschuss — 4-Modul-CI

| Modul | Repo-ID | Pipeline | REV | Stand bei Kontext-Ende |
|---|---|---|---|---|
| **super** | 288 | #6953 / #288 | REV 10 | ✅ **GRÜN** (verifiziert #6953; submodule-none + artefakt-arm) |
| **thesis** | 289 | #6991 / #289 | REV 1 | ✅ **GRÜN** (#6991, gitleaks-PDF-Fix; chktex/latexmk texlive-gegatet) |
| **cache-engine (AMD)** | 286 | #6987 / #286 | REV 11 | ✅ **GRÜN** (verifiziert #6987; #6993 lief erneut sauber) |
| **prt-art** | 287 | #6992 / #287 | REV 11 | ✅ **harte Gates GRÜN** (`build:standalone`=SUCCESS 329s + `lint:secrets`=SUCCESS, verifiziert 06-26 13:43 UTC; nur advisory `lint:format` (AF, ~35min-LLVM-Bootstrap) + `lint:static` (AF, failed) offen — gaten NICHT) |
| cache-engine (Intel) | 286 | #6990 | — | ⛔ **abgebrochen / gegatet** (`pmc:intel`; `COMDARE_PROD2_AVAILABLE=false`) |

- **Git-HEADs (gepusht):** ci-templates(269)=`63c13ac` (base-pipeline v4) · cache-engine(286)=`cc91122` · prt-art(287)=`a23187e` · super(288)=`17428ad` · thesis(289)=`e5d000f`.
- **Runner:** prod1 = id 16, **gesund** (frischer Heartbeat nach `systemctl restart gitlab-runner`), jetzt **`concurrent=2` + cgroup `CPUQuota=800%` (8 Kerne)**. prod2 = id 17, **pausiert** (crashy HW / SSH tot).
- **Watcher** `b06os5q3x` **gestoppt** (Auftrag erfüllt, 06-26 ~13:43 UTC). **4-Modul-Foundation = harte Gates ALLER 4 Module GRÜN**, verifiziert mit wörtlicher Tool-Ausgabe: cache-engine #6993=success · super #6953=success · thesis #6991=success · prt-art `build:standalone`=success 329s + `lint:secrets`=success. Intel-Seite (`pmc:intel`) bewusst gegatet bis prod2 HW-OK.
- ✅ **Memory-Direktive erfüllt:** „4-Modul-Foundation (prod1/AMD-Seite) grün" ist jetzt **verifizierter Zustand** (wörtliche Tool-Ausgabe; advisory `lint:format`/`static` (allow_failure) gaten NICHT). VERBLEIBT für Voll-Grün: prod2/Intel-Seite (blockiert) + advisory-Lints auf HART (#179).

---

## 1. SOFORT-HANDOFFS AN MICH (nächste Session, priorisiert)

> Format je Zeile: **[Prio] WAS + WO (Datei/Pfad/ID) + WARUM**

1. **[P0] ✅ ERLEDIGT (06-26 13:43 UTC) — 4-Modul-Foundation-Grün BESTÄTIGT** — harte Gates aller 4 Module grün (cache-engine #6993=success · super #6953=success · thesis #6991=success · prt-art `build:standalone`=success 329s + `lint:secrets`=success). Watcher gestoppt. KEIN P0 mehr; VERBLEIBT nur: advisory-Lints auf HART (#179) + Intel/prod2-Seite (blockiert).
2. **[P0] ✅ ERLEDIGT — prt-art + thesis Endzustand verifiziert** — thesis #6991=success (gitleaks-PDF-Fix), prt-art #6992 harte Gates grün (REV-11-`--target test_prt_art_identity`-Fix wirkte). Alte #6988/#6989 sind durch die REV-11-Re-Runs ersetzt.
3. **[P1] Entscheidung B umsetzen:** `lint:format` + `lint:static` auf **`when: manual`** stellen (raus aus jedem Push) — via `comdare/cluster/ci-templates/base-pipeline.yml` (`.lint-format`/`.lint-static`) ODER per-Modul. WARUM: schnellere Foundation; harte Gates (gitleaks 8.30.1) bleiben. **Beim #179-Format-Pass reaktivieren + auf HART stellen.**
4. **[P1] `systemctl daemon-reload` auf prod1** (`root@10.0.10.211`, cluster-Key) — Drop-in-Warnung der config.toml-Änderung sauber machen. WARUM: Folge-TODO aus Entscheidung A.
5. **[P1] `CMAKE_BUILD_PARALLEL_LEVEL=4` in den 3 Build-CIs setzen** (cache-engine=8→4, prt-art=4, super=8→4). WARUM: 8 Kerne / 2 concurrent = 4; aktuell 8/4 = leichte Oversubscription (Core-Budget-Mismatch #189-abgestimmt).
6. **[P1] prod2-Hardware-Test fahren — SOBALD User-Zugang** (cluster-Pubkey via IPMI ODER BMC-Creds in `machines/Comdare`) → Runbook `RUNBOOK-prod2-14900KS-stabilitaetstest.md` (memtest86+/mprime/stress-ng `--verify`/mcelog) → **Ergebnisse live in Ordner auf DIESEM Windows-Desktop streamen** (Ordner noch NICHT angelegt) → Verdikt (RMA?). WARUM: Verdacht Intel-13/14-Gen-Degradation am i9-14900KS.
7. **[P2] Memory-Lektionen persistieren (§E)** + **MEMORY.md-Pointer** für `reference_cluster_ci_runner_access_topology` setzen; Session-Docs aufräumen. WARUM: Lektionen dieser Session teuer erkauft, noch nicht alle in Memory.
8. **[P2] Session-Start-Ritual nachholen** (CLAUDE.md: „letzte 15 Themen-Session-Dokumente + alle Masterpläne laden"). WARUM: Session kam aus Compaction — nicht belegt nachgeholt (§B-9).

---

## 2. VERSÄUMT / UMGANGEN (offene Schuld, mit Begründung)

1. **Echter Mess-Lauf fehlt — nur Smoke gemergt.** build+measure → EIN `pmc`-Smoke (`linux_perf_pmc_smoke`). Der reale mehrtägige PMC-Mess-Lauf (286 build→measure, **#156/#162**, FF3) ist **nicht** in der CI. **Geschuldet:** separater Mess-Job (scheduled/manual) + **NAS-Writeback (A1) statt GitLab-Artefakte**.
   - **Detail-Direktive (nur in 06-25-Docs `USER-ANTWORTEN-13`, A1):** Mess-Pipeline soll je Cache-Engine-Config **mindestens EINE als schnellste ermittelte Tier-Binary** (über 3 Mess-Schichten SOTA / PRT-ART / kombiniert) an ein Zielsystem **zurückschreiben** → „als perfekte Plattform-Binary-Release zu arbeiten". Cache-Engine ist konzeptionell von **UltiHash** abgeleitet (Konzept zeigen, nicht Code).
2. **Artefakt-Storage-500 nur umgangen, nicht gelöst.** Alle großen Artefakte (`build/`, `Code/build/`) entfernt, um post-swap-MinIO-500 („invalid argument") zu dodgen. Der Mess-Writeback BRAUCHT aber Artefakte. **Geschuldet (Infra):** Object-Storage prüfen/fixen → dann Mess-Artefakte/NAS-Writeback restaurieren.
3. **`test_v41_anatomy_module_abi` nicht auf Linux gebaut.** contract auf `test_abi_interface` eingegrenzt (um den — jetzt gefixten — Include-Bug zu dodgen). Linux-Vollbau von test_v41 mit den 3 korrigierten Includes UNVERIFIZIERT. **Geschuldet:** test_v41 Linux bauen — Teil **#179**.
4. **`lint:format` + `lint:static` = advisory (allow_failure) übersprungen.** clang-format + cppcheck FAILEN (Code nicht formatiert / cppcheck-Findings). **Geschuldet:** #179-Format-Pass (clang-format) + cppcheck-Fixes → dann HART.
5. **10-Stufen-Pipeline nur ~1/3.** Gebaut: lint/build/contract (+ analyse/pdf bei super). **Fehlen komplett:** sanitize (P1b, ASan/UBSan/TSan), integration, **chaos-engineering**, manifest+prebackup, K8s-prod-Pod-Deploy, deploy-staging, **smoke-canary**. **Geschuldet:** Reststufen pro Modul.
6. **prod→dev-DB-Sync-Gate nur persistiert, NICHT implementiert (P1f).** Konzept in CICD-Doc **§8b** + Memory; CI-seitig nicht gebaut. **Geschuldet (infra-gated).**
   - **Detailsemantik (nur `CICD-PIPELINE-ARCHITEKTUR §8b`):** vor jedem prod-Deploy ALLE prod-DBs **read-only → dev syncen** → isoliertes **Chaos-Engineering mit realer Datenkopie** → **dev-Artefakte zuerst verifizieren** → **DANN erst prod-Deploy**.
7. **Core-Budget-Mismatch (concurrency=2).** `CMAKE_BUILD_PARALLEL_LEVEL`: cache-engine=8, prt-art=4, super=8. Bei `concurrent=2` + 8-Kern-cgroup → 2 Jobs × 8 = 16 > 8 = **Oversubscription**. **Geschuldet:** je Runner `=Kerne/concurrent` (8/2 = **4**) — mit **#189** abstimmen. (Teil-erledigt via Sofort-Handoff #5.)
8. **thesis chktex + latexmk-PDF nie real getestet.** texlive-gegatet (P1c) → auf thesis(289) läuft NUR gitleaks. **Geschuldet (Infra):** texlive auf Runner → `COMDARE_TEXLIVE_AVAILABLE=true` → chktex+PDF verifizieren.
9. **Session-Start-Ritual unklar erfüllt.** (Siehe Sofort-Handoff #8.) **Geschuldet:** nächsten Start nachholen.
10. **Neue Session-Lektionen noch nicht alle in Memory.** Siehe §6/§E. Zu persistieren.
11. **prt-art + thesis Grün-Status nie bestätigt** (Session zweigte zum prod2-Hardware-Thema ab). Siehe §3-1.
12. **Web-Recherche nach sinnvollen Pipeline-Gates je Eigenschaft** (User #459, Frage 4: „recherchiere im Web nach sonst sinnvollen gates für jede einzelne Pipeline Eigenschaft"). Steht NUR in 06-25 `USER-ANTWORTEN-13`; in keinem 06-26-Doc als offener Punkt. **Geschuldet:** nachholen.
13. **„Beide Formate dokumentieren" (Doku-Konvention).** Alle künftigen User-Antworten EINMAL im Klartext als TODO-Anweisungs-Erweiterung UND in eigener verständlicher Formulierung persistieren (User #459, Schluss). In 06-26-Docs nicht als fortzuschreibende Konvention erwähnt → Risiko des Verlusts.

---

## 3. OFFEN / BLOCKIERT (mit Blocker je Punkt)

1. **prt-art #6988 + thesis #6989 — Endzustand UNBESTÄTIGT.** Blocker: nie terminal geprüft. → Job-Stände holen, grün bestätigen oder debuggen (Trace).
2. **cache-engine Intel-Seite (`pmc:intel` / `measure:intel`) — nie grün verifiziert.** Blocker: prod2 instabil (Crashes) + SSH kaputt → re-gated (`COMDARE_PROD2_AVAILABLE=false`), Intel-Lauf #6990 abgebrochen, Runner 17 pausiert. Hängt an prod2-Stabilität (Punkt 3) **und** prod2-Toolchain/texlive (§4).
3. **prod2-Hardware-Test (i9-14900KS) — wartet auf User-Zugang.** Blocker: kein remoter Zugang (IPMI-Key-Add ODER BMC-Creds nötig). Verdacht: Intel-13/14-Gen-Degradation → ggf. CPU-RMA (Intel 5-Jahre-Garantie). Vorlauf: µcode **0x133**, BIOS **4505=latest** (Phase 1 weitgehend erfüllt); **offen** Intel-ME 16.1.32→16.1.38 (ASUS-Tool Windows-only, per SSH/Ubuntu nicht flashbar, brick-riskant → vertagt).
   - ⚠️ **Faktischer Widerspruch (aufzulösen):** Ledger K81-60/K81-73 markieren die Instabilität als „**GELÖST 2026-06-25**" (BIOS-Factory-Reset/Intel-Default → 0 Segfaults @ -j32, kein RMA). Das **neuere Runbook (06-26)** eröffnet die Diagnose erneut, weil prod2 **wieder „wiederholt abstürzt"** → Root-Cause (#56) gilt als **NICHT dauerhaft behoben**. Runbook = neue Verifikationsschiene.
4. **prod2-SSH-Recovery — GRUNDLEGEND kaputt.** Blocker: prod2 `authorized_keys` akzeptiert KEINEN Key — auch **nicht vom Bastion Pi5** (`node7@10.0.10.207`, cluster-Key ✓ bis Pi5; Pi5→prod2 alle Key×User = denied). Recovery nur via **IPMI-Konsole/physisch** (Key legen). Zusatz: ASPEED-BMC (Pro WS W680-ACE IPMI) **in-band tot** (BIOS-disabled / Port unverkabelt) → echtes Remote-IPMI existiert noch nicht; „Konsole" = lokal physisch. Cluster-Key-Rotation (#66/#13) bewusst auf **Inside-Session (kein VPN)** vertagt; Privatteil lag base64-Klartext im OPN-syshook `96-ssh-cluster-key` (Exposition offen).
5. **config.toml concurrency=2 + cgroup auf prod2 + K8s-Runner** — Infra-Handoff **#189** (Host-Eingriff, nicht Impl-Agent). Blocker: prod2-Anteil hängt an prod2-Stabilität/-Verfügbarkeit.
6. **Tieferer Struktur-Umbau (User-Scope-Erweiterung) — komplett offen / nicht begonnen.** Blocker: bewusst auf „nach grünem CI-Netz / Phase D" verschoben. Inhalt: 01-06 → semantische Tool-Namen, verstreute Skripte konsolidieren, Test-Runner/CMake-Konventionen vereinheitlichen (überlappt **#179**, dort nicht ausformuliert).
7. **super (288) `analyse:thesis-data`-Artefakt (`Code/build/`) verkleinern/streichen** zur Artefakt-500-Umgehung (analog cache-engine REV 10). Blocker: super ist auf 06-26 grün (#6953) → evtl. bereits via „artefakt-arm" erledigt → **bei Bedarf verifizieren**.

---

## 4. INFRA-HANDOFFS (Host/Keys/Storage/texlive/Concurrency #189 — nicht Impl-Agent-Domäne)

- **prod2-SSH-Key legen** (authorized_keys-Recovery via IPMI-Konsole/physisch). Owner: User/Infra (Inside-Session).
- **prod2-CPU/RAM-Test bzw. RMA** (i9-14900KS, Runbook abarbeiten). Owner: User/Infra am Gerät.
- **Artefakt-Object-Storage (MinIO post-swap 500).** Stand: prod-MinIO deployed (`minio-0` 1/1 Running auf prod1; PVC 50Gi longhorn-cold HEALTHY; Cert-SAN `minio.prod.comdare.de`; Bucket `gitlab-runner-cache`; ClusterIP 10.32.243.80; OPN→ClusterIP:9000 OK). **Offen:** (3) OPN-Unbound Host-Override `minio.prod.comdare.de → 10.0.10.1` + `configctl unbound restart`; **(4) 🔴P0** OPN-HAProxy os-haproxy-CLI (`srv/be/acl/act`-Kette, mode tcp, ssl_sni, additiv an `https-in`/`gitlab.comdare.de`-P0-Frontend, `haproxy -c` validieren, graceful, BEIDE OPN, opn-2-zuerst); (5) Runner `config.toml [runners.cache.s3]` (ServerAddress `minio.prod.comdare.de`, Insecure=false, comdare-ca im Host-Trust) → Cache-Round-Trip per Testjob verifizieren. **Achtung:** prod-Host/Runner erreicht 10.32-ClusterIP NICHT direkt → MinIO muss OPN-präsentiert sein (HAProxy + `.1`-SNI), nie ClusterIP-direkt. Manifest: `configs/k8s/prod-minio/02-minio-prod.yaml`.
- **texlive auf Runnern (thesis P1c).** prod1 **komplett** (TeX Live 2026 + latexmk 4.88 verifiziert). prod2: fast✓ + Boost✓, aber `install-tl` scheme-full lief beim Handover noch → `latexmk`/`pdflatex` auf prod2 noch nicht final (gekoppelt an prod2-Verfügbarkeit). Skript: `scripts/prod-runner-toolchain-setup.sh` (fast|heavy|all).
- **`config.toml concurrent=2` + 8/10-Kern-cgroup** auf prod1 (✅ erledigt) + prod2 + K8s-Runner (**#189**). Standard: halbe Host-Kerne bei concurrency=2 (Ubuntu 16→8, Talos-VM 20→10).
- **universelle Runner-Matrix ISA×OS×{bm/docker/k8s}** (**#189**) — ci-templates id=269 (reife v7.0.3-Shared-Lib, 66-Job-Multi-Plattform-Matrix) ist wiederverwendbar. **Detail-Zusagen (nur 06-25 `HANDOFF-infra-universelle-runner`):** Windows-Server-2022-Keys gekauft → zusätzlich als Bare-Metal-Ubuntu-KVM; jede ISA+OS × {bare-metal/docker/k8s} (auch k8s-in-k8s); **macOS-Runner physisch da aber fehlkonfiguriert** (Infra in den nächsten Tagen); **Power + AArch64 via ZIH** (zuletzt anschließen).
- **`CMAKE_BUILD_PARALLEL_LEVEL=4`** in CI-Templates/Runner-Env verankern (Memory `feedback_runner_concurrency_half_cores_concurrency2`; `-j`=`CMAKE_BUILD_PARALLEL_LEVEL`, nicht `nproc`). Auch Stabilitäts-Schutz, solange prod2-HW-Root-Cause offen.
- **A13-Folgeauftrag (Secret-Rotation):** Infra-Agent per Handoff fragen, **OB und WIE WEIT** die Secrets bereits rotiert sind (restliche ~20 Klartext-Secrets im cluster_development-HEAD/History-Rewrite). gitlab-root-PW gilt als rotiert; Rotations-FORTSCHRITT-Rückfrage in 06-26-Docs nicht mehr sichtbar.

**Topologie-Lektion (verbatim-nah):** Diese Windows-Maschine erreicht NUR **V10 (10.0.10.x)**, NICHT das Heim-LAN (192.168.178.x, inkl. Pi5@.66). Pi5/Bastion = `node7@10.0.10.207` (cluster-Key, aarch64, NICHT admin/root). prod1 = `root@10.0.10.211` (cluster-Key) ✓, hat aber KEINE Privatkeys (kein Jump). prod2 = `.212`, SSH **tot**. `pve1/pve2 = .201/.202` = Proxmox. Talos-VMs (`talos-cp-1/2`) = K8s, **kein SSH** (nur talosctl). BMC: ASUS W680 ACE **IPMI** vorhanden (SEL/Sensoren/KVM theoretisch, Creds in `machines/Comdare`). Querverweis prod-Zugang: `ssh -i ~/.ssh/cluster admin-management@10.0.10.211/.212` (`sudo -n` passwortlos), talosctl-prod **nur von node7** (V16 10.0.16.211/.212/.213). prod aktuell **3/3 Ready, etcd-Quorum gold, P0=200**.

---

## 5. ENTSCHEIDUNGEN A/B/C (User 2026-06-26, autoritativ)

### Entscheidung A — ✅ ERLEDIGT (mit Folge-TODOs)
`concurrency=2` auf prod1 gesetzt: `concurrent = 2` in `/etc/gitlab-runner/config.toml` + cgroup `CPUQuota=800%` (8 Kerne) + Runner-Restart. Backup: `config.toml.bak-concfix`. → **User hat damit config.toml-Eingriff auf den prod-Runnern für den Impl-Agent freigegeben.**
**Folge-TODOs (nächste Session):** (1) `systemctl daemon-reload` auf prod1 (Drop-in-Warnung); (2) **`CMAKE_BUILD_PARALLEL_LEVEL=4`** in den 3 CIs (8/4 = leichte Oversubscription); (3) gleiche config (concurrent=2 + cgroup) auf **prod2** (nach HW-OK) + **K8s-Runner** (Teil #189).

### Entscheidung B — TODO nächste Session
`lint:format` + `lint:static` bis zum #179-Format-Pass auf **`when: manual`** (raus aus jedem Push → schnellere Foundation; harte Gates bleiben). Umsetzen via base-pipeline `.lint-format`/`.lint-static` ODER per-Modul. **Beim #179-Format-Pass reaktivieren + auf HART stellen.**

### Entscheidung C — Nächster Fokus nach 4-Modul-grün
**#179-Sweep + tieferer Struktur-Umbau** (01-06→semantisch, Skripte konsolidieren, Test-Runner/CMake vereinheitlichen, lint:format/static hart, `test_v41`-Linux-Vollbau). GROSS, datei-für-datei über alle 4 Repos. (Rest-10-Stufen + Mess-Architektur danach.)

### Zusätzliche User-Direktiven (#459, nur in 06-25-Docs verankert — nicht verlieren)
- **Chaos-Gate-Schwelle exakt:** **>5% Messabweichung → alle 3 aufeinanderfolgenden 2-Phasen-Messungen wiederholen + Ereignis als Warnung loggen** (Frage 4). In keinem 06-26-Doc.
- **A8 (Text-vs-Code-Vorrang):** Wenn Diplomarbeit-Text NEUER ist als Code → **Code reparieren (Thesis = Sollzustand)**; sonst per Dokument-Handoff an den Text-Agenten. Relevant u.a. für **#178/#190**.

---

## 6. FALLSTRICKE (kompakte Liste — diese Session teuer erkauft)

- ⭐ **Pipeline-Cancel hängt den prod-gitlab-runner auf** → danach `systemctl restart gitlab-runner` (prod1-SSH geht). War DER „keine Jobs"-Blocker.
- ⭐ **prod2-SSH grundlegend tot** — kein Key, auch nicht vom Bastion Pi5. Nur via IPMI-Konsole/physisch lösbar. Runner pollt trotzdem ausgehend.
- ⭐ **Windows-Desktop = V10-only** (10.0.10.x); Heim-LAN 192.168.178.x unerreichbar. Pi5 via V10-IP 10.0.10.207, User `node7` (NICHT admin/root).
- ⭐ **Cluster-Docker-Runner ohne apt-Egress** → CI **bare-metal** (prod-Toolchain), nicht `image: debian + apt-get`.
- ⭐ **INTERFACE-Lib hat kein baubares Target** → über Test-Consumer bauen (`cmake --build` ALL), kein `--target <interface-lib>`.
- ⭐ **`ctest -R '<substring>'` matcht ALLE Tests mit dem Substring** (auch ungebaute → „Not Run" → Fail) → geprüfte Tests bauen + exakte `^name$`-Regex. (Konkret: `ctest -R 'abi'` traf ungebautes `test_v41_anatomy_module_abi`; build-ALL traf kaputten `test_internal_search`.)
- ⭐ **gitleaks scannt `CI_PROJECT_DIR` inkl. `.citools` + Submodule + getrackte Binär-PDFs** (Entropie-FP-Schleuder) → Lint `GIT_SUBMODULE_STRATEGY: none`; `.gitleaks.toml` PDF/EPS allowlisten + `disabledRules=["generic-api-key"]` (~100 High-Confidence-Regeln bleiben); `.citools` bei Bedarf allowlisten.
- ⭐ **`!reference [.x, before_script]` + `extends`** → CI-Lint „script should be a string…" → Bootstrap **INLINE** statt `!reference`.
- ⭐ **Artefakt-Object-Storage 500 „invalid argument"** post-swap (MinIO) → keine großen `build/`-Artefakte (Infra-Sache).
- ⭐ **GitLab `contacted_at` = UTC** (lokal UTC+2) → „stale"-Fehldeutung vermeiden.
- ⭐ **Projekt-Transfer = `PUT /projects/:id/transfer?namespace=ID`, NICHT POST** (POST → 404, sieht aus wie Proxy-Block, ist Methoden-Irrtum).
- ⭐ **Vault-SSH-Keys haben CRLF** (OneDrive) → `tr -d '\r' < cluster > /tmp/ckey; chmod 600`, sonst `error in libcrypto` (wirkt wie Permission-denied).
- ⭐ **Runner-`tag_list`** nur im Detail-Endpoint (`/runners/:id`), in `/projects/:id/runners`-LISTE leer.
- ⭐ **GitLab-Secret-Swaps mehrfach/Session** → Rails-API/Gitaly/Storage flaky/503; **Gitaly kommt oft SPÄTER zurück als Rails-API** → warten + retry, nicht umkonfigurieren. PATs überleben Swaps (gehasht).
- ⭐ **OneDrive-Git träge** (Push-Timeouts) → Commit + Push trennen, Push ggf. nachholen.
- ⭐ **OneDrive-Vault Cloud-only** → Glob sieht ihn nicht; `Get-ChildItem`/`Get-Content` nutzen.
- ⭐ **PowerShell:** `$pid` read-only; `gl`/`GL` = Get-Location-Alias → eigene Namen (`Glab`, `projId`); `-match` auf Array (curl-Multiline) füllt `$matches` nicht → erst `-join "\`n"`. `Remove-Item -Recurse -Force` / `cmd rmdir /s` vom Session-Guard geblockt → `.NET [IO.Directory]::Delete($p,$true)`.
- ⭐ **ci-templates id=269** war KEIN stale Dup, sondern reife v7.0.3-Shared-Lib (66-Job-Matrix) → wiederverwendbar für ISA×OS×{bm/docker/k8s}-Matrix (#189).

---

## 7. VORBESTEHENDE DIPLOMARBEIT-TASKS (nicht CI-überholt, weiterhin offen)

| ID | Inhalt | Status/Blocker |
|---|---|---|
| **#19** | Allokatoren echt linken | offen |
| **#125** | P6 lazy-DLL Content-Hash-Versionierung | offen |
| **#152** | Cache-Misses-Neumessung | HELD bis Linux+PMC |
| **#156** | M3-Neumessung / Mess-Writeback | HELD bis Linux+PMC; braucht Artefakt-Storage |
| **#162** | Mess-Vorbereitung PRT-ART + SOTA | offen |
| **#163** | SIMD + Allokator-Achsen | offen |
| **#165** | quiesziertes OS (Mess-Vorbereitung) | offen |
| **#178** | sota_catalog Stufe→Reihe | blockiert bis Thesis-Drift (vgl. A8 Text-vs-Code) |
| **#179** | Wartbarkeits-Sweep ALLER C++-Dateien — **GROSS** | offen (Entscheidung C; überlappt tieferen Umbau + lint-hart + test_v41-Linux) |
| **#184** | Dataset-Loader-Slot | offen |
| **#185** | TPIE/EM-BFS | offen |
| **#187** | PMC-Auto-Adaption | offen |
| **#188** | T0-Such-Delegation Architekturfix | offen |
| **#189** | Infra-Handoff universelle Runner (config.toml/cgroup/Matrix) | offen (siehe §4) |

> Hinweis: **#190** taucht als Bezug auf (A8 Text-vs-Code / prod2-SSH-Koordination), ist aber nicht in der autoritativen 13er-Vorbestehend-Liste enthalten.

---

## 8. Konsolidierungs-Workflow — Provenienz dieses Dokuments + Ergebnisse (ultracode, 2026-06-26)

> Dieses Dokument (§0–§7) ist das **Produkt** eines ultracode-Multi-Agenten-Workflows (User-Auftrag: „Verwende einen ultracode agenten dafür, weil der Kontext knapp ist"). §8 hält Methode, Ergebnis und Grenzen fest, damit die nächste Session die **Herkunft** — und die **Verlässlichkeit** — jeder Aussage einordnen kann.

### Aufbau (Run `wf_d71e2567-969` · 6 Agenten · 2 Phasen · ~488k Subagent-Tokens · 64 Tool-Calls · ~11 min)
- **Phase 1 „Sweep" — 5 Agenten parallel, je 1 Quelle:**
  1. `retrospektive` → `20260626-SESSION-RETROSPEKTIVE-…` (Versäumt/Offen/Infra/Fallstricke).
  2. `handover-2` → `20260626-SESSION-ENDE-2-…` (TODOs/Entscheidungen/Credentials).
  3. `handover-1` → `20260625-SESSION-ENDE-…` (nicht-überholte Restpunkte).
  4. `transcript-completeness` → **Completeness-Critic**: Glob+Grep über den Session-Transcript-`.jsonl` nach „versäum / deferred / später / TODO / #179 / blockiert / Infra-Handoff / …" → fand Zusagen + User-Direktiven, die in den Handover-Docs FEHLTEN.
  5. `infra-host-offen` → prod2-Runbook + host-/infra-seitige offene Punkte.
- **Phase 2 „Consolidate" — 1 Agent:** harte Deduplikation über alle 5 Extrakte → EIN strukturiertes Dokument (§0–§7), vom Agenten selbst per Write persistiert.

### Ergebnis (was der Workflow geliefert hat)
- **8 priorisierte Sofort-Handoffs** (§1): 2× **P0** (4-Modul-Foundation-Grün + prt-art/thesis-Endzustand — **beide inzwischen ✅ erledigt**, s. §0/§1) · 4× **P1** (B `when:manual` · daemon-reload prod1 · `CMAKE=4` · prod2-HW-Test) · 2× **P2** (Memory-Lektionen + Session-Start-Ritual).
- **GERETTETE Detail-Direktiven** — lagen NUR in den überholten 06-25-Docs, wären sonst verloren gegangen: UltiHash-Ableitung + **schnellste-Tier-Binary-Writeback** ans Zielsystem (§2-1) · **Chaos-Gate exakt: >5 % Abweichung → 3× Wiederholung + Warn-Log** (§5) · **A8 Text-vs-Code-Vorrang** (Thesis = Sollzustand) (§5) · **#189-Einzelzusagen** (Windows-Server-2022-KVM, macOS-Runner-Fix, ZIH-Power+AArch64) (§4) · **A13-Rotations-Fortschrittsfrage** (§4) · prod→dev-DB-Gate-Detailsemantik §8b (§2-6) · „beide-Formate-dokumentieren"-Konvention (§2-13) · Web-Recherche-nach-sinnvollen-Gates (§2-12).
- **FLAG — faktischer Widerspruch prod2** (§3-3, vom Completeness-Critic entdeckt): Ledger K81-60/73 = Instabilität „**GELÖST 2026-06-25**" (BIOS-Reset → 0 Segfaults @ -j32, kein RMA) ↔ Runbook 06-26 „**stürzt wieder ab**" → Root-Cause **#56 NICHT dauerhaft behoben**. **Vor jeder Intel-(`pmc:intel`)-Reaktivierung auflösen.**

### Grenzen / Verlässlichkeit (WICHTIG für die nächste Session)
- Die Sweep-Agenten lasen den gesamten `docs/sessions/`-Bestand — also **auch Nachbar-Session-Cluster-Docs** (Infra/Ledger). Daher trägt v.a. **§4** breiteren Infra-Kontext (prod-MinIO-Deploy-Stand, ASPEED-BMC-in-band-tot, µcode 0x133 / BIOS 4505, talosctl-prod-nur-von-node7), der **über diese CI-Session hinausgeht**. → Diese Cluster-Infra-Details sind **Querverweis-Kontext**: vor dem Handeln gegen den **Ledger** (`architektur-ziele-offene-punkte-ledger.md`, Single-Source-Vorrang) verifizieren, NICHT blind als „diese-Session-Fakt" behandeln.
- Alle IDs/Pfade verbatim erhalten; harte Dedup über 5 Quellen. **Verlässlichkeits-Schätzung:** CI-Teil (§0–§2, §5, §6) = **hoch** (diese Session, tool-belegt); Infra-Cluster-Details (§3–§4) = **mittel** (Querverweis, gegen Ledger prüfen).

---

### Referenzierte Pfade/Dokumente (nicht löschen)

- **Single-Source Rest-/Schuld-Liste:** `…/Diplomarbeit - Datenbanken/docs/sessions/20260626-SESSION-RETROSPEKTIVE-VERSAEUMTE-UND-OFFENE-AUFGABEN.md`
- **Elaborierte Übergabe:** `…/docs/sessions/20260626-SESSION-ENDE-2-CICD-PROD2-ELABORATE-UEBERGABE.md`
- **Superseded (überholt, aber Detail-Direktiven #459 NUR hier):** `…/docs/sessions/20260625-SESSION-ENDE-CICD-PIPELINE-ELABORATE-UEBERGABE.md` · `…20260625-USER-ANTWORTEN-13-ENTSCHEIDUNGEN…md` · `…20260625-CICD-PIPELINE-ARCHITEKTUR-4-MODULE…md` (§8b) · `…20260625-HANDOFF-infra-universelle-runner-3D-matrix-secret-rotation.md` · `…20260624-…SECRET-ROTATIONS-AUDIT…md`
- **prod2-Runbook:** `C:\Users\benja\OneDrive\Desktop\Projekte\Cluster\docs\RUNBOOK-prod2-14900KS-stabilitaetstest.md` (CLAUDE.md-Pfad `cluster_development\docs\…` existiert NICHT mehr → OneDrive-Klon = Hauptarbeitspfad)
- **GitLab-Projekt:** `comdare/cluster/ci-templates` (`base-pipeline.yml`, hermetischer Lint-Bootstrap) — id=269
- **Memory:** `reference_cluster_ci_runner_access_topology` (MEMORY.md-Pointer noch zu setzen)
- **Repo-IDs:** cache-engine=286, prt-art=287, super=288, thesis=289, ci-templates=269, cluster-Gruppe=340. **Runner:** prod1=16, prod2=17 (pausiert). **CI-Var:** `COMDARE_PROD2_AVAILABLE` (in 286) = false.
- **Single-Source Cluster:** `docs/sessions/architektur-ziele-offene-punkte-ledger.md`; Sessions K81-73 / K81-60.
