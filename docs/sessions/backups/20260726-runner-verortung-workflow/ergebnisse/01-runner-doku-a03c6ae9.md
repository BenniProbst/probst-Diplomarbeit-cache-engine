# 20260726-runner-verortung-workflow / runner-doku (agent a03c6ae9)

runId: wf_9c896c61-367
agentId: a03c6ae9a45c70640
label-Zuordnung: runner-doku (Prompt-Marker-Deckung 33%)

---

(a) RUNNER-CONFIG JE MASCHINE (Doku-Ist, live nicht geprueft - Cluster read-only)
- prod1 (10.0.10.211 V10 / 10.0.60.211 V60, Ryzen 9 9950X3D 16C/32T, 60 GiB RAM):
  `/etc/gitlab-runner/config.toml`, executor=shell, systemd-Unit `gitlab-runner`.
  User: Doku widerspruechlich - "laeuft als root" (C/sessions/2026-07-19-INFRA-RESPONSE-storage-scharfschaltung-P1-P6.md:10)
  vs. Zombie-PIDs unter User `gitlab-runner` (C/sessions/2026-07-22-IMPL-TO-INFRA-zombie-driver-prod1-stale-pw.md:4) -> live verifizieren.
  1 Linux-Runner: id=16 `prod-baremetal-prod1`, Version 18.9.0 (`apt-mark hold`), Tags
  [prod,baremetal,amd,amd64,avx2,avx512] (+x86_64/13 AVX512-Subflags nur in der DB, NICHT im File).
- prod2 (10.0.10.212, i9-14900KS, 62 GB RAM, 5 VMs): gleicher Pfad, Version 19.1.1,
  1 Linux-Runner id=17 `prod-baremetal-prod2`, Tags [prod,baremetal,intel,amd64,avx2].
- Zusaetzlich je Host Windows-VM-Runner mit EIGENER config.toml im Gast (`C:\GitLab-Runner\`):
  prod1-win2022 id=53, prod1-win11 (Orphan id=55, pending), prod2-win2022 id=54, prod2-win11 id=19
  (C/sessions/2026-07-17-INFRA-HANDOVER-cred-leak-rotation-baremetal-runner.md:72,88-98).
- Ist-Werte laut letzter dokumentierter Referenz (prod1/id16, 2026-07-17, ebd.:95):
  `concurrent=3, check_interval=2, request_concurrency=4, executor=shell`; cache.s3 -> minio buildsystem-cache.
  KEIN per-Runner `limit =` in irgendeinem Doku-Fundort - nur das GLOBALE `concurrent`.
  CI-Gegenstueck: Gruppen-Variable `CMAKE_BUILD_PARALLEL_LEVEL` (Gruppe comdare id=3, scope *) = 10.
- Muster fuer Fremd-/Mandanten-Runner: dedizierte Instanz mit eigener Config
  (`--config /etc/gitlab-runner/config-kamdi24.toml`) + eigene systemd-Unit; macOS-Runner nutzen
  `~/.gitlab-runner/config.toml`, nicht /etc/ (C/agent-memories-infra/INFRA-AGENT-MEMORIES-KONSOLIDIERT-20260708.md:302).

(b) DOKUMENTIERTE AENDERUNGS-PROZEDUR
1. Backup ZUERST, Namensschema `config.toml.bak-<zweck>-<YYYYMMDD>` (belegte Beispiele:
   .bak-concurrency-20260706, .bak-concurrency-20260708, .bak-ccache-20260706, .bak-devminio-20260706, .bak-wegA-20260717).
2. Reload NUR per `kill -HUP <MainPID>`: die Unit hat KEIN ExecReload; SIGHUP ist graceful, killt keine
   Jobs, und das globale `concurrent` wird bei SIGHUP neu gelesen (v13.2+).
   `systemctl restart` DRAINET laufende Jobs ("Session terminated, killing shell") -> bei Mess-/Bau-Jobs verboten;
   Manager-Restarts nur bei builds=0 (C/FEHLER-LOESUNGEN-KB.md:65, KB-039 Regel 2).
3. Danach `gitlab-runner verify` (Erwartung "is valid, prod-baremetal-prod1") + journal-Beleg
   "Configuration loaded ... max_builds=N".
4. Doktrin-Bundling: #242 (.de->.local) und #295 (concurrent) in EINEM config.toml-Pass je Host mit EINEM
   SIGHUP; vor dem Edit je Host `nslookup gitlab.comdare.local` (C/sessions/2026-07-18-K327d-DESIGN-PLAN-BUCH-je-stufe.md:192,197,207,208).
5. Vorsichtsregeln: Secret-Zeilen NIE printen (der cache.s3-SecretKey liegt im File; zwei dokumentierte Leaks,
   ebd. 2026-07-17:85) - feldgezielt lesen, kein cat/tail. Tags nur ADDITIV, DB-Tags muessen ins File
   persistiert werden, sonst Reset bei Re-Register (RUNN-23). prod1/prod2 synchron halten oder Divergenz begruenden.
   Fremd-Bundles `install-runner.sh`/`register-runner.sh` NIEMALS blind: sie ueberschreiben die
   Standard-config.toml und restarten den Dienst (wuerde id16/17 zerstoeren).
6. Drift-Falle: File-Wert und Live-Wert koennen auseinanderlaufen (K90: SIGHUP-Revert wirkte global, File blieb 3)
   -> BEIDES pruefen.

(c) HISTORIE DES concurrency=1 (Wurzel = RAM/OOM-Schutz, NICHT Mess-Schutz)
- S2638/S2639 (User-Direktive, urspruenglich): ALLE 12 Runner `concurrent=1` ("immer nur 1 Job"), verifiziert;
  Exoten duerfen alle Kerne, Nicht-Exoten CMAKE_BUILD_PARALLEL_LEVEL=7 (INFRA-AGENT-MEMORIES...:295-299).
- 2026-06-25 User: halbe Host-Kerne + `concurrent=2` (16->8 Kerne bzw. Talos 20->10).
- 2026-07-03 User (PROD-Revision): `concurrent=1` + 8 Kerne. Begruendung literal: >=12 GB je Host, ~2 GB belegt,
  ~10 GB frei, Modell 1 GB RAM pro arbeitendem Kern -> 8 Kerne = 8 GB passen; bei concurrent=1 zieht kein
  zweiter Job RAM. Ausgefuehrt: prod1 2->1 per SIGHUP; prod2 war schon 1. Auslöser: earlyoom hatte auf prod2
  `cc1plus` gekillt (C/.../memories/feedback_runner_concurrency_half_cores_concurrency2.md:11).
- 2026-07-06 K87 (User): prod1 1->2 ("concurrency 2 x je 6 Kerne") nach RAM-Pruefung (17 GiB available,
  earlyoom auf prod1 INAKTIV); Backup .bak-concurrency-20260706 (C/sessions/20260706-13-38-003297-K87-...md §1-2).
- 2026-07-08 (User-Auftrag, Infra-Agent): prod1 2->3, prod2 1->3, `CMAKE_BUILD_PARALLEL_LEVEL=10`; hebt die
  concurrent=2-Direktive explizit auf (D/docs/sessions/20260708-INFRA-an-IMPL-prod-runner-concurrency3-threads10-DONE.md).
- 2026-07-08 spaeter (Impl, wegen prod2-36%-Fehlerrate): 3->2 per SIGHUP + Level 10->8; echte Wurzel war ein
  toter prod-MinIO-Cache-Endpunkt, NICHT die Concurrency; File blieb auf 3 (Drift).
- OFFENER WIDERSPRUCH, VOR JEDER UMSTELLUNG ZU KLAEREN: #295/DIPL-37 ("prod1 concurrency -> 3") laeuft weiter als
  pending, Memory-Direktive sagt 2, prod-Revision sagt 1, File/Referenz sagt 3
  (C/sessions/2026-07-26-WELLEN-GESAMTPLAN-KONSOLIDIERT.md:39; .../05_widersprueche.md:97,233,234,417).
- Mess-Schutz ist ein SEPARATER Mechanismus: P11-Wache + resource_group + 1-Thread-Doktrin, nicht `concurrent`.

(d) FALLEN
- Zombie-Driver (RUN-1/RUNN-16/W-43): GitLab-Cancel toetet nur den Shell-Wrapper, nicht die Prozessgruppe ->
  `comdare-messung-driver` laeuft weiter (bis 18 h, 97% CPU), 3+ Vorfaelle 21./22.07. Dauerfix (setsid +
  `kill -- -PGID` bzw. systemd KillMode / FF_USE_LEGACY_KILL) ist OFFEN und infra-seitig.
  Workaround: CI-Job `runner:sweep-zombies` (D/.gitlab-ci.yml:148-169, Tags $SWEEP_TAG=amd|intel, nur per
  API-Trigger COMDARE_SWEEP_ZOMBIES=true, `[c]omdare...`-Regex-Trick) + manueller root-Kill.
- Cancel-trap (`trap -` zuerst) ist diplom-seitig gebaut; runner-seitige Haertung bleibt Infra
  (C/sessions/2026-07-26-DIPLOM-AGENT-rueckschreibe-report-gigascrub-phaseA-stand.md:66-69).
- P11-Exklusivitaet (D/.gitlab-ci.yml:602-623,658,744): Pre-Flight bricht HART ab, wenn ein FREMDER Driver
  laeuft - korrekt, kostet aber einen Lauf. Hoehere Concurrency erhoeht die Chance, dass zwei Mess-Jobs auf
  demselben Host landen. W-45: ein mehrtaegiger Mess-Job haelt einen von zwei prod1-Slots -> CI-Kapazitaet halbiert.
- Runner-Restart-Falle (P8): Job 280514 wurde trotz build_timeout=14d und interruptible:false gekillt; Restart
  hinterlaesst zusaetzlich Driver-Waisen -> Mess-Fenster koordinieren.
- OOM W-44: prod1 60 G RAM; unter 32 Workern nur 12 G available + 20 G Swap -> Bau ist RAM-gebunden, nicht
  CPU-gebunden; T-Werte amd deshalb 32->24. Waehrend Voll-Bau-4 (>=30 h, 24/24 Worker je Maschine) KEINE schweren
  parallelen CI-Jobs auf prod1/prod2 (OOM-Vorfaelle 23.07.).
- prod2-RAM-Grenze: 62-GB-Host mit 5 VMs, ~12 GB Runner-Budget; `concurrent=3 x -j10` = bis 30 Compile-Threads
  -> erhoehtes ICE/OOM-Risiko; earlyoom ist auf prod2 AKTIV, auf prod1 INAKTIV. prod2 zusaetzlich
  RMA/NVMe-Rebuild-gegated (Rueckkehr ~Sep 2026).
- Disk: ~56 GB DLL-Masse je Zelle, ~224 GB fuer 4 Perms, prod1 zuletzt 109 G frei (W-41);
  `builds_dir` nie auf tmpfs (node7/node8-Lehre).
- Versions-Skew: prod1 18.9.0 vs prod2 19.1.1 -> unterschiedliche $CI_PROJECT_DIR-Expansion in Child-Pipelines;
  RUNN-24 (prod1-Upgrade) offen, NICHT waehrend Bau-/Mess-Jobs.
- Poll-Freeze/#172/#210: Watchdog-Timer `comdare-runner-watchdog` (45 s) restartet nur bei contacted_at >120 s
  und ohne Build-Prozesse; `contacted_at` ist Redis-gecacht (20-40 min stale ist NORMAL, kein Lebenszeichen-Beweis).
- Begriffskollision: die Sidekiq-`ConcurrencyLimit`-Deferred-Queue (Ci::BuildTraceChunkFlushWorker, K87b) hat
  NICHTS mit `concurrent` zu tun; ResumeWorker-Cron liegt nur in Redis (W-46).

Quellen-Basis: /home/comdare/Projekte/Cluster/docs (sessions/, FEHLER-LOESUNGEN-KB.md, agent-memories-infra/) und
/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine (.gitlab-ci.yml, docs/sessions/).
Selbstcheck: ASCII-only (grep -P '[^\x00-\x7F]' = 0 Treffer); keine Secret-Werte, nur Fundstellen; 08_BUILD_NODES_SETUP.txt und 12_RUNBOOK_PRO_MACHINE.txt enthalten KEINE prod1/prod2-Runner-Sektion (v3-Alt-Doku, nur Build-Nodes macOS/Pi5/VisionFive2); CICD-DEPLOYMENT-PLAN.md §2 nennt prod1/prod2 nicht (Stand 2026-05-28, veraltet).
