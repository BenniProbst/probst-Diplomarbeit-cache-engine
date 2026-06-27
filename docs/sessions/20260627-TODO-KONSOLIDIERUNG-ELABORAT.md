# TODO-Konsolidierung — Elaborat (Single-Source aller offenen Implementierungs-TODOs seit 2026-06-12)

> **Datum:** 2026-06-27 · **Rolle:** Implementierungs-Agent (Code-Revier: cache-engine 286 / prt-art 287 / super-Diplomarbeit 288 / thesis-text 289; NICHT Infra, NICHT Text-Agent).
> **Quelle dieses Dokuments:** Codex-Scan (gpt-5.5/xhigh, read-only) über `docs/sessions` + `docs/architecture` + cache-engine, **plus** die Claude-Code-Task-Liste #193–#208. 48 offene Codex-Tasks + 2 gerettete Direktiven, vollständig elaboriert.

---

## 0. Zweck & Geltung

**Zweck:** Dieses Dokument ist die **Single-Source ALLER offenen Implementierungs-TODOs seit dem 12.06.2026** — damit sie **nie wieder neu herausgesucht** werden müssen. Jeder Eintrag nennt elaborat **Was / Ziel / Wie / Abhängigkeiten-Blocker / Quelle** und ist kontext-ende-sicher (ein frischer Agent rekonstruiert den vollen Stand allein hieraus).

**Geltung & Vorrang:** Diese Datei konsolidiert; die *laufend gepflegte* Live-Single-Source bleibt das cache-engine-Ledger `Code/external/comdare-cache-engine/docs/sessions/architektur-ziele-offene-punkte-ledger.md`. **Bei Widerspruch zu konkreten Code-Stellen gilt: vor jedem Edit Zeilennummern re-greppen** (alle `file:line` sind Momentaufnahmen) und den lebenden GitLab-PAT aus dem Cluster-Vault ermitteln. **Thesis Kap. 1–4 = FESTGEZOGEN = das SOLL**; der Code wird an die Thesis nachgezogen, nie umgekehrt. **Messdaten werden NIE gelöscht** (ABI/Schema darf brechen, alte Mess-CSV bleiben). **Codex-Gegenreview (gpt-5.5/xhigh, read-only, nur Code-Repos) vor „done"** bei jeder Code-Aufgabe.

---

## 1. Lage (Stand 2026-06-27) — autoritativer Kontext für die gesamte Liste

**(L1) Die Pipeline ist das Fundament und erst ~1/3 fertig.** Die 10-Stufen-CI-Pipeline (EPIC **#186**) ist die GRUNDLAGE für ergiebiges Entwicklungs-Feedback (User A6/A7: „CI/CD ist das Fundament"; „erst Pipeline klar, dann Messlauf voll treiben"). Codex-Compliance-Verdikt 2026-06-27: **nur ~35–40 % erfüllt.** Die 4-Modul-Foundation (harte Gates grün) ist nur eine TEILMENGE; die echte #186-Hauptanforderung = volle 10 Stufen + Super-Orchestrierung + Mess→PDF + ISA/OS-Matrix + deploy/canary + prod→dev-Gate. **Die Pipeline muss zuerst stehen.**

**(L2) Pipeline-Ist 2026-06-27 = aktuell ROT.** Root-Cause: die **Super-Orchestrierung forwarded ihre Variablen** (`GIT_SUBMODULE_STRATEGY: recursive` + `COMDARE_CITOOLS_DIR`) per **`trigger:forward`-Default** in die Downstream-Pipelines → dort `mkdir /.citools` **Permission-denied** + ungewollter Submodul-Checkout. **Fix in Arbeit: `trigger: { forward: { pipeline_variables: false, yaml_variables: false } }`** (bzw. gezielt), damit die Kind-Pipelines mit ihren EIGENEN Variablen laufen. Bis dahin gelten Wave-4 + Orchestrierung als **nicht final grün re-verifiziert** (#194).

**(L3) Dieser Laptop ist ZU LANGSAM für Tests → Verifikation gehört in die Pipeline.** User-Direktive: Tests/Mess-/Bau-Verifikation laufen auf den **schnellen prod-Runnern** (prod1=AMD 9950X3D id 16; prod2=Intel 14900KS id 17, pausiert). Alle Tasks, deren *Verifikation/Lauf* auf echte Runner gehört, sind unten mit **`PIPELINE-ONLY`** markiert. Reines Editieren + Codex-Review ist lokal ok; der **Beweis** muss aus wörtlicher Pipeline-/Tool-Ausgabe kommen (kein Erfolgsmark ohne Tool-Output).

**(L4) #193 (manuelle Bedienbarkeit) = NEUE TOP-PRIORITÄT, angearbeitet.** Der User konnte die Lösung nicht manuell ausführen (Self-Test scheiterte). Bereits committet: `build_and_measure_150_tiere.ps1` `$repo` aus `$PSScriptRoot` (e4bf7c8); Profile-Resolve-Fix (teil); `MANUAL_RUN.md` + USAGE-Banner angelegt. **Verbleibend:** Presets-`COMDARE_EXPERIMENT_MODE`-Entscheidung, `ExperimentDriver`-SOTA-Pfad-Fix, USAGE-CLI-Korrektur, **echter Hand-Lauf-Verifikation** (Validate→RunTest→kleiner Run→CSV→TeX, literal grün — auf Pipeline/schnellem Runner).

**(L5) #179 ist erweitert.** Der Wartbarkeits-/Lesbarkeits-Sweep ist **NICHT fertig, bis JEDE Datei aller 4 Projekte mit Codex** auf (a) Auskommentierung UND (b) Struktur/strukturelle Sauberkeit geprüft ist. Die bisherigen Drift-Fixes sind nur eine Teilmenge. Der eigentliche #179 = **per-Datei-Codex-Review ALLER Dateien** (sehr groß, mehr-Session). Das Drift-Theme (Thema-1) ist abgeschlossen (Commit `9480f98`).

**(L6) Autoritatives Achsen-Modell (Codex-aufgelöst, aus dem Code belegt).** **SearchAlgorithm-Kompositionen = 19 Slots T0..T18** (17 Kern-Achsen T0..T16 + `queuing_q1`/`q2` als ECHTE Slots @ T17/T18). Die globale Experiment-**Registry = 22 statische Achsen** = diese 19 + genau 3 **build-only-`DefinitionOnly`-Achsen** (`page_type`, `simd_extension`, `general_hardware`). Das alte Wording „17 Komposition + 5 außerhalb (inkl. q1/q2)" ist **FALSCH** (q1/q2 sind Komposition). `array<…,17>` (axis_operability) ist KORREKT (= die 17 Kern-Achsen). **Diesen Satz überall verwenden.**

### 1.1 — 10-Stufen-Status (Ist je Stufe)

| # | Stufe | Status | Detail |
|---|---|---|---|
| 1 | lint | **partiell** | gitleaks 8.30.1 **HART**; clang-format/cppcheck = `when:manual` (advisory, bis #179) |
| 2 | build | **partiell** | prod1/AMD **HART**; Intel/prod2 + ISA/OS-Matrix **fehlen** |
| 3 | sanitize | **partiell** | ASan+UBSan **advisory** (`allow_failure`, Wave-3 auf cache-engine+prt-art); TSan + matrix-weit + HART fehlt |
| 4 | contract | **partiell** | ABI-Contract (`test_abi_interface`) da; **config-durability/fuzz fehlt** |
| 5 | integration | **DONE** (#196) | E2E-Auswerte-Kette record.bin→CSV→LaTeX/TikZ als `integration:smoke` (super-Root), prod-Runner grün |
| 6 | chaos | **DONE** (#197, 2026-06-27) | Drift-Detektor + Rerun-Gate (`drift_detector.hpp` + `test_chaos_drift_gate`); Job `chaos:drift` grün (cache-engine-Pipeline 7041, prod1). Real-PMC-Anwendung + Schwellen-Kalibrierung = #156-gegatet (dünner perm_runner-Adapter → Quality-Flag #165) |
| 7 | manifest+prebackup | **DONE** (#198, 2026-06-27) | `manifest:provenance` (super-SHA + Submodul-SHAs recursive + Toolchain + OS/ISA + Profil-Hash) + `prebackup:measurements` (additiv + sha256-verifiziert, nie überschreiben) am Super-Root; beide grün (Super-Pipeline 7042 = success, alle 3 Bridges grün). Reales NAS/MinIO-Writeback = #202-gegatet |
| 8 | k8s-deploy | **fehlt** | Mess-/Build-Last als prod-K8s-Pod (KubeVirt/Talos) |
| 9 | deploy-staging | **fehlt** | prod→dev-DB-Read-Only-Sync-Gate (§8b) |
| 10 | smoke-canary | **fehlt** | canary-loggate → canary-promote |

### 1.2 — Referenz (Repos / Runner / Vars)

- **Repo-IDs:** cache-engine **286**, prt-art **287**, super **288**, thesis **289**, ci-templates **269**, cluster-Gruppe **340**.
- **Runner:** prod1 = **16** (AMD Ryzen 9 9950X3D, gesund, `concurrent=2` + cgroup 8 Kerne); prod2 = **17** (Intel i9-14900KS, **pausiert** bis I/O-Fix). `auto_cancel_pending_pipelines = disabled` (Hang-Schutz → Backlog-Kehrseite).
- **CI-Var:** `COMDARE_PROD2_AVAILABLE` (in 286) = `false`. CI-`-j` = `CMAKE_BUILD_PARALLEL_LEVEL` (=4), nie `nproc`.
- **Zugang:** prod1 `root@10.0.10.211` (cluster-Key, CRLF-strip); prod2 `admin-management@10.0.10.212` (sudo -n); PAT = Cluster-Vault `…/Cluster/keys/CREDENTIALS-VAULT.md` (lebenden testen). Windows-Desktop = **V10-only**.

---

## 2. Legende

- **Prio:** `P0` = Pipeline-Fundament (zuerst) · `P1` = hoch (Bedienbarkeit/Architektur/Mess-Prep-Kern) · `P2` = Mess-Lauf/Aufräumen (nach der Pipeline).
- **Effort:** `S` (Stunden) · `M` (Tag) · `L` (mehrere Tage) · `XL` (mehr-Session/Wochen).
- **Runner:** `PIPELINE-ONLY` = Lauf/Verifikation gehört auf schnelle prod-Runner (Laptop zu langsam) · `lokal+Codex` = Code-Edit lokal + Codex-Review · `Infra-Handoff` = nicht Impl-Agent-Domäne.
- **Status-Marker im Text:** `DONE`/`TEIL-DONE` = bereits (teil-)committet (Commit genannt, wo bekannt).

---

## 3. Prioritäts-Übersichtstabelle (streng nach Priorität)

| Prio | Theme | #IDs / Kürzel |
|---|---|---|
| **P0** | pipeline-ci | #194, #203, #189, #204, #195, #196, #197, #198, #199, #200, #201, #202, #207 |
| **P1** | pipeline-ci | #208, #205 |
| **P1** | manual-operability | #193 (6 Facetten: E2E · Manual-Doc · repo-Pfad `DONE` · EXPERIMENT_MODE · Profil-Pfad · USAGE-CLI) |
| **P1** | 179-sweep | #179 (Voll-Sweep) · god-header · finaler-lint+test_v41-Linux |
| **P1** | measurement-prep | #156 · Generalprobe-m3v2 · #187 · #178/#20 · PRT-ART-90ns-Stubs |
| **P1** | architecture-gap | #188 |
| **P1** | other | Research-Klone hydrieren+syncen |
| **P2** | measurement-prep | #162 · SOTA-Legacy-P11–P27 · #163 · #165 · #19 · #125 |
| **P2** | architecture-gap | #184 · #185 · stale-XML-Docs · Crystalline/StdMalloc-Namen · #10 · E11-Facade |
| **P2** | 179-sweep | minor-17-Kern-Wording · Boilerplate-Dedup · topics/*-vs-modules/*-Autorität |
| **P2** | other | #154-Rest (Tabellen-Überlappung) · prt-art-Legacy-Header löschen |
| **Meta** | gerettete Direktiven | #206 (Web-Recherche Gates je Eigenschaft) · Doku-Konvention „beide Formate" (#459) |

---

## 4. TODOs nach Theme (Themen nach Wichtigkeit; je Theme streng P0→P1→P2)

## Theme: pipeline-ci (das Fundament — Pipeline-grün zuerst)

### [P0] Wave-4 + Super-Orchestrierung grün re-verifizieren  (Task #194 · pipeline-ci · S · PIPELINE-ONLY)
- **Was:** Die Wave-4-Pipelines (#6999 cache-engine / #7000 prt-art / #7001 super) + die Super-Orchestrierung (#7002, sha 306a5aa) **literal als grün bestätigen** und das `trigger:forward`-Problem (L2) verifiziert beheben.
- **Ziel:** Beweisbar grünes 4-Modul-Fundament inkl. feuernder Downstream-Bridges (`downstream_pipeline.id` gesetzt), als Basis für alle weiteren Stufen.
- **Wie:** `forward: false` (pipeline_variables + yaml_variables) an den 3 `trigger`-Bridges setzen, pushen; nach Backlog-Abbau via **lebendem Vault-PAT** Job-Stände holen (PowerShell `curl.exe --ssl-no-revoke`); bei Fehler Trace ziehen (kein Raten). Bridges feuern erst NACH `lint:secrets` grün.
- **Abhängigkeiten/Blocker:** Runner-Backlog (auto-cancel disabled); lebender PAT; `forward:false`-Fix muss zuerst greifen.
- **Quelle:** SESSION-ENDE-4:9 · PHASE-A:18,34 · SESSION-ENDE-3:38.

### [P0] lint nach #179 voll HART stellen  (Task #203 · pipeline-ci · M · PIPELINE-ONLY)
- **Was:** Nach Abschluss des #179-Format-Passes die advisory-Lints (`lint:format` clang-format, `lint:static` cppcheck/clang-tidy) von `when:manual`/`allow_failure` auf **harte Gates** umstellen.
- **Ziel:** Stufe 1 vollständig hart: 0 Format-Diffs (`clang-format --dry-run -Werror`), 0 neue clang-tidy/cppcheck-Findings, gitleaks bleibt 0 Secrets.
- **Wie:** In `comdare/cluster/ci-templates/base-pipeline.yml` (`.lint-format`/`.lint-static`) die `rules: when:manual` entfernen bzw. `allow_failure:false` setzen — erst NACHDEM der Code formatiert + cppcheck-Findings gefixt sind (sonst Dauer-Rot).
- **Abhängigkeiten/Blocker:** **Hängt an #179** (Code muss erst formatiert/bereinigt sein); ci-templates 269.
- **Quelle:** KONSOLIDIERT:45 · KONSOLIDIERT (Entscheidung B):94.

### [P0] ISA/OS/Umgebungs-Build-Matrix komplettieren (3D)  (Task #189 · pipeline-ci · XL · PIPELINE-ONLY + Infra-Handoff)
- **Was:** Die Build-/Sanitize-Matrix auf **ISA × OS × {bare-metal, docker, k8s}** ausbauen: stale ARM/RISC-V/macOS-Runner reaktivieren, Windows-Server-2022 als bare-metal-Ubuntu-KVM, Power+AArch64 via ZIH.
- **Ziel:** Der gesamte Diplomarbeit-Test läuft auf dem geplanten Plattform-Niveau (T12 ISA-Achse x86-64/AArch64/Power/RISC-V + Hybrid + Sapphire Rapids) — Voraussetzung für mess-belastbare Multi-Plattform-Ergebnisse.
- **Wie:** Wiederverwendung der ci-templates **269** (reife v7.0.3-Shared-Lib, 66-Job-Matrix); je Runner Toolchain + Tags `[baremetal,<isa>,<os>]`; Infra provisioniert Runner (macOS-Fix, Win2022-KVM, ZIH). Impl-Seite: Matrix-Jobs/Presets je Zelle.
- **Abhängigkeiten/Blocker:** **Infra-gated** (universelle Runner; macOS-Fkonfig; Win2022-KVM; ZIH-Anschluss „zuletzt"); ohne universelle Runner nicht fahrbar.
- **Quelle:** CICD:119-122 · USER-ANTWORTEN:27-34 (A2/A3) · KONSOLIDIERT:79.

### [P0] sanitize HART + matrix-weit  (Task #204 · pipeline-ci · M · PIPELINE-ONLY)
- **Was:** Die Sanitize-Stufe (aktuell ASan+UBSan advisory auf 2 Modulen) auf **asan + tsan + ubsan, je ISA+OS separat einkompiliert** und auf **HART** (`allow_failure:false`) ziehen.
- **Ziel:** Stufe 3 vollständig: 0 Sanitizer-Findings je Variante als blockierendes Gate — Speicher-/Thread-/UB-Sicherheit über die ganze Matrix.
- **Wie:** Je Variante eigener Debug-Build (`-fsanitize=address`/`=thread`/`=undefined`), KEINE gemischten Builds; je ISA+OS eine eigene Sanitizer-Binary + Lauf; nach Stabilisierung `allow_failure` entfernen.
- **Abhängigkeiten/Blocker:** Hängt an #189 (Matrix-Runner) für „matrix-weit"; TSan-Findings müssen zuerst bereinigt sein.
- **Quelle:** SESSION-ENDE-3:17,23.

### [P0] contract: config-durability-Gate (Müll-Config-Robustheit)  (Task #195 · pipeline-ci · M · Code+Pipeline)
- **Was:** Stufe 4 um **„bullshit-config-durability"** ergänzen: fuzz-/property-basierte Robustheit gegen kaputte/unsinnige XML-Profile (`comdare_thesis_profile`) — dürfen NICHT crashen, sondern einen **ehrlichen Fehler** liefern.
- **Ziel:** Vertrags-Stufe komplett (ABI-Contract + std::map-Konformitäts-Gatter + Config-Durability) → keine undefinierten Crashes bei fehlerhaften Nutzer-Profilen.
- **Wie:** Property-/Fuzz-Test über den XML-Profil-Parser (kaputte Felder, fehlende Slots, Out-of-Range); Assertion „definierter Fehler statt Crash"; in die contract-Stage als Gate hängen.
- **Abhängigkeiten/Blocker:** ABI-Contract-Teil steht; Fuzz-Harness neu zu bauen (Code = lokal/Codex, Lauf = Pipeline).
- **Quelle:** CICD:87 · USER-ANTWORTEN (Teil D, Stufe 4):142.

### [P0] integration: E2E-Mess-Kette  (Task #196 · pipeline-ci · L · PIPELINE-ONLY)
- **Was:** Stufe 5 bauen: storage/db-Integration (CNPG/MinIO/Redis wo relevant) + **E2E der Mess-Kette** `messung_driver → .bin → csv → tex → pdf` als minimaler Permutations-Smoke.
- **Ziel:** Beweis, dass die GESAMTE Kette real durchläuft (grüne E2E) — ohne den vollen Permutationsraum (~10^14) zu fahren.
- **Wie:** Smoke-Profil mit ≤2 Konkretisierungen je der 19 Achsen (`m3v2_smoke.profile.xml`, ≤3 Reihen); der Super-`messung_driver` läuft die Kette einmal `bin→csv→tex→pdf`; Coverage-Gate ≥80 % kritische Logik (web-Standard).
- **Abhängigkeiten/Blocker:** Mess-Pfad code-ready; braucht grüne Build-Stufe + Generatoren (Generalprobe-m3v2, Task 17); storage/db-Integration teils infra.
- **Quelle:** CICD:88,160 · USER-ANTWORTEN (Teil D, Stufe 5):143.

### [P0] chaos: Drift-Rerun-Gate (>5 % → 3× + Warn-Log)  (Task #197 · pipeline-ci · M · PIPELINE-ONLY)
- **Was:** Stufe 6 (Diplomarbeit-Kern): ein **Mess-Drift-Detektor**, der bei **>5 % Wiederholungs-Abweichung** die betroffene Messung als unzuverlässig erkennt → **3 aufeinanderfolgende 2-Phasen-Messungen alle 3 wiederholen + das Ereignis als Warnung loggen**.
- **Ziel:** Wissenschaftlich belastbare Messung statt driftverseuchter Werte; Selbstheilung statt stiller Korruption.
- **Wie:** Drift-Überwachung über Median/Perzentile (Statistik-Triade ch3); bei Schwellen-Sprung abort+rerun (Resume-Mechanik #139) + Warn-Log; verzahnt mit Quality-Flag #165. Allgemein zusätzlich Runner-Kill/Netz-Partition-Resilienz + Flaky-Erkennung.
- **Abhängigkeiten/Blocker:** braucht reale PMC-Läufe (prod) zum Kalibrieren; verzahnt mit #156/#165.
- **Quelle:** USER-ANTWORTEN:37-40 (A4) · CICD:89,176-181 · USER-ANTWORTEN (Teil D, Stufe 6):144.

### [P0] manifest + prebackup-Stufe  (Task #198 · pipeline-ci · M · PIPELINE-ONLY)
- **Was:** Stufe 7 bauen: ein **Build-/Mess-Manifest** (Toolchain, Commit-SHAs ALLER Submodule, ISA/OS, Profil-Hash) + **Prebackup** alter Messungen UND Einstellungen VOR Überschreiben.
- **Ziel:** Reproduzierbarkeit + Datenschutz; Direktive „Messdaten NIE löschen" → additiv/versioniert; Prebackup vor Überschreiben Hash-verifiziert.
- **Wie:** Manifest-Generator-Job (sammelt Toolchain/SHAs/ISA/OS/Profil-Hash in eine Datei je Lauf); Prebackup-Job sichert bestehende Mess-Artefakte (Hash-Check) bevor neue geschrieben werden; `build_version`-getrennte Dateien.
- **Abhängigkeiten/Blocker:** sinnvoll mit NAS-Writeback (#202) gekoppelt; Artefakt-Storage muss stehen.
- **Quelle:** CICD:90 · USER-ANTWORTEN (Teil D, Stufe 7):145.

### [P0] Mess-/Build-Last als prod-K8s-Pod  (Task #199 · pipeline-ci · L · PIPELINE-ONLY)
- **Was:** Stufe 8: die Mess-/Build-Last bei Migration als **Produktions-Pod** im prod-Cluster fahren (KubeVirt/Talos-Runner-VMs) statt nur Bare-Metal-Shell.
- **Ziel:** Containerisierte, skalierbare, reproduzierbare Mess-/Build-Umgebung als Teil der `{bm/docker/k8s}`-Dimension.
- **Wie:** Pod-Manifest + Image (prod-Toolchain, perf-Rechte wie CE-DL2); Image-Scan (SBOM `syft` + `grype`/`trivy`, 0 kritisch/hoch); Pod-Readiness-Gate.
- **Abhängigkeiten/Blocker:** **infra-gated** (K8s-Deploy-Ziel, Runner-VMs, Object-Storage); hängt an #189.
- **Quelle:** CICD:91 · USER-ANTWORTEN (Teil D, Stufe 8):146.

### [P0] deploy-staging: prod→dev-DB-Gate (§8b)  (Task #200 · pipeline-ci · L · PIPELINE-ONLY)
- **Was:** Stufe 9: vor jedem prod-Deploy **alle prod-DBs NUR-LESEND → dev-Cluster syncen** → isoliertes Chaos-Engineering mit realer Datenkopie → **dev-Artefakt-Korrektheitsprüfung** → erst bei dev-OK prod-Deploy.
- **Ziel:** Nie unverifizierter Code auf der prod-Mess-Umgebung; jede Code-Änderung erzeugt neue Messwerte, deren Korrektheit ZUERST isoliert auf dev abgesichert wird.
- **Wie:** Read-Only-Sync über **eine der 2 sanktionierten dev/prod-Brücken** (Witness/CI, kein neuer Bypass); dev-DB = V90, prod-DB = V91, Cross-VLAN via Samba-DNS + `.1`-SNI; prod-DB nie geschrieben; Performance-Regressions-Gate auf Staging.
- **Abhängigkeiten/Blocker:** **infra-gated** (dev+prod-Cluster, DBs, Sync-Mechanik); P1f.
- **Quelle:** CICD:192-194 (§8b) · USER-ANTWORTEN (Teil D, Stufe 9):147 · KONSOLIDIERT:47-48.

### [P0] smoke-canary: Log-Gate + promote  (Task #201 · pipeline-ci · M · PIPELINE-ONLY)
- **Was:** Stufe 10: **canary-loggate** (Fehlerrate < Schwelle) → **canary-promote** (+ SLO-Check; später e2e-ui).
- **Ziel:** Finale Absicherung vor Prod-Promotion — nur stabile Releases gehen durch.
- **Wie:** Canary-Job parst Fehlerrate/Logs gegen Schwelle; bei OK promote, sonst stop. Promote-Kriterium (Mess-Stabilität / PDF-Gate) noch festzulegen (offene Frage CICD §11.4).
- **Abhängigkeiten/Blocker:** setzt Stufen 8/9 (Deploy/Staging) voraus; infra-gated.
- **Quelle:** CICD:93 · USER-ANTWORTEN (Teil D, Stufe 10):148.

### [P0] NAS-Writeback + schnellste-Tier-Binary-Release + PDF  (Task #202 · pipeline-ci · L · PIPELINE-ONLY)
- **Was:** Die Deploy-Stufen um **drei Artefakt-Klassen** erweitern: (a) Mess-CSV/Binär-Export → **NAS-Ziel** (additiv/versioniert); (b) je Cache-Engine-Config **mindestens EINE als schnellste ermittelte Tier-Binary** (Sieger der SOTA∪PRT-ART∪kombiniert-Permutation je Speicherinterface) als eigenständige **Plattform-Binary-Release** (#172.1); (c) **Thesis-PDF**, kompiliert GEGEN den Messwert-Export.
- **Ziel:** Demonstriert das **UltiHash-Optimierungs-Konzept** (mess-getriebene Suche nach dem Gattungs-Optimum) ohne UltiHash-Code; liefert mehr als nur PDF+Binaries.
- **Wie:** NAS-Writeback-Job (UNC/NFS, „Messdaten nie löschen"); Sieger-Selektion über die 3 Mess-Schichten → Binary-Release-Artefakt; PDF-Build-Job konsumiert den Messwert-Export.
- **Abhängigkeiten/Blocker:** **Artefakt-Object-Storage (MinIO post-swap-500) zuerst fixen** (Infra); braucht Mess-Daten aus #156/#162.
- **Quelle:** USER-ANTWORTEN:13-25 (A1/B1) · KONSOLIDIERT:41-42.

### [P0] prod2-I/O-Fix + `pmc:intel` reaktivieren  (Task #207 · pipeline-ci · L · PIPELINE-ONLY + kritisches Wartungsfenster)
- **Was:** Den I/O-Writeback-Stall auf prod2 (i9-14900KS) beheben (Kernel-Update 6.8.0-124→neuer + Host-Root von den VM-Disks trennen ODER IO-Scheduler-Tuning + `softlockup_panic=1`), danach **`pmc:intel` reaktivieren** (Runner 17 ent-pausieren, `COMDARE_PROD2_AVAILABLE=true`).
- **Ziel:** Die Intel-Seite der CI/Matrix freischalten — Verdikt steht: **I/O-Stall, NICHT CPU** (kein RMA; stress-ng 0 Fehler, µcode 0x133).
- **Wie:** rasdaemon läuft (MCE-Baseline 0), writeback bereits gekappt (`99-comdare-writeback.conf`). Kernel-Update braucht Host-Reboot → VM-Handling (`talos-prod2` suspend/Autostart) + etcd-2/3-Quorum-Toleranz.
- **Abhängigkeiten/Blocker:** **KRITISCHES MANÖVER — IMMER mit User absprechen** (prod2 fährt die prod-K8s-CP-VM; **KEIN funktionierendes IPMI = Brick-Risiko**); Plan + Wartungsfenster + ausdrückliches Go zwingend.
- **Quelle:** SESSION-ENDE-3:66 · SESSION-ENDE-3:42(5).

### [P1] gitlab-runner 19.1.1 + auto-cancel safe wieder AN  (Task #208 · pipeline-ci · M · PIPELINE-ONLY + Idle-Fenster)
- **Was:** gitlab-runner 19.1.0 → **19.1.1** auf prod1 upgraden (Idle-Fenster) und **danach** `auto_cancel_pending_pipelines` auf allen 4 Projekten wieder AN.
- **Ziel:** „Neueste Tools" + Hang-Härtung; Superseding zurückgewinnen, ohne den Cancel-Hang zu reaktivieren.
- **Wie:** `apt-get install` + `systemctl restart gitlab-runner`; **Reihenfolge: Upgrade ZUERST**, dann auto-cancel via API-PUT. Falls Hang trotz 19.1.1 → Self-Healing-Watchdog (Stale-Heartbeat → restart). Backlog vorher leerlaufen lassen.
- **Abhängigkeiten/Blocker:** Runner muss idle sein; Reihenfolge strikt (sonst sofortiger Cancel-Hang).
- **Quelle:** SESSION-ENDE-3:67 · KONSOLIDIERT:30(Sofort-Handoff).

### [P1] thesis chktex/latexmk Hard-Gate auf echtem Runner  (Task #205 · pipeline-ci · S · PIPELINE-ONLY + TeXLive-gated)
- **Was:** Das Thesis-Text-Build-Gate (latexmk DE+EN, **0 Fehler ≤1 bekannte Warning**, `.blg`/Repeated-entry-Check, chktex-fail-Semantik) auf einem Runner **mit TeXLive real verifizieren** und hart stellen.
- **Ziel:** Der Overleaf-Text gilt als „kaputt", wenn er nicht sauber baut — automatisches Qualitäts-Gate.
- **Wie:** Gate-Logik bereits committet (thesis REV2 `fded1f4`, Codex-reviewed: chktex `-n all` entfernt, `test -s …log`-Guard); latexmk-`.log`-Parser (≥1 Error ODER ≥2 Warnings → fail), die 1 bekannte Warning als Allowlist. prod1 hat TeX Live 2026 + latexmk 4.88; auf prod1 laufen lassen.
- **Abhängigkeiten/Blocker:** **TeXLive auf Runner** (prod1 fertig, prod2 pending); `COMDARE_TEXLIVE_AVAILABLE=true` setzen.
- **Quelle:** SESSION-ENDE-4:29 · CICD:166-172 (§7) · PHASE-A:38.

> Siehe auch **#206** (Web-Recherche sinnvolle Gates je Pipeline-Eigenschaft) unter *Theme: Meta / gerettete Direktiven* — gehört thematisch zu pipeline-ci, ist aber als gerettete #459-Direktive separat geführt.

---

## Theme: manual-operability (#193 — NEUE TOP-PRIORITÄT, User-Self-Test)

### [P1] Lösung manuell E2E lauffähig machen  (Task #193 · manual-operability · L · lokal → Pipeline-Verifikation)
- **Was:** Die Kette **manuell ausführbar** machen, sodass der User sie im Self-Test (Diplomarbeit-Sicht) durchklicken kann: `build_and_measure_150_tiere.ps1 -Validate/-RunTest` → kleiner M3V2-Run → CSV→TeX/Diagramm.
- **Ziel:** „manuell bedienbar" = erfüllt erst, wenn ein echter Hand-Lauf der Kette **literal grün** durchläuft (kein Erfolgsmark ohne Tool-Ausgabe).
- **Wie:** Den aktuellen **Profil-Flow** als empfohlenen Weg etablieren (`m3v2_study.profile.xml`); Smoke-ohne-PMC vs. Real-mit-PMC trennen; die 5 Codex-Fixes (Tasks 32–36) abarbeiten; finaler Hand-Lauf zur Verifikation auf schnellem Runner (Laptop zu langsam, L3).
- **Abhängigkeiten/Blocker:** bündelt Tasks 32–36; echter Lauf braucht prod-Runner-Fenster.
- **Quelle:** MANUAL-RUN:39 · SESSION-ENDE-4:71.

### [P1] Top-Level Manual-Run-Doc  (Task #193 · manual-operability · S · lokal · TEIL-DONE)
- **Was:** Ein primäres `Code/MANUAL_RUN.md` (oder Root-README), das den empfohlenen Profil-Flow + CSV→TeX/Diagramm + Smoke-vs-Real-PMC dokumentiert.
- **Ziel:** Ein eindeutiger Einstiegspunkt statt zwei konkurrierender Wege (alter `messung_driver` vs. aktueller Profil-Flow).
- **Wie:** `MANUAL_RUN.md` ist angelegt (TEIL-DONE) + USAGE-Banner da; verbleibend: vollständigen Flow + Pfadangaben (config_dir = `libs\cache_engine\builder\example_configs`, NICHT `Code\experiment_config`) ergänzen und mit dem echten Hand-Lauf abgleichen.
- **Abhängigkeiten/Blocker:** abhängig von Pfad-/Preset-Fixes (Tasks 34/35); finalisieren nach Hand-Lauf.
- **Quelle:** MANUAL-RUN:23,33.

### [P1] Hartkodierten repo-Pfad aus Mess-Script  (Task #193 · manual-operability · S · lokal · DONE e4bf7c8)
- **Was:** In `build_and_measure_150_tiere.ps1` das hart verdrahtete `$repo`-Absolutpfad-Setzen durch Ableitung aus `$PSScriptRoot` ersetzen.
- **Ziel:** Das Mess-Script läuft auf jedem Klon/Rechner ohne Editieren.
- **Wie:** **Erledigt** (Commit `e4bf7c8`): `$repo` aus `$PSScriptRoot` abgeleitet. Verbleibend nur: im echten Hand-Lauf bestätigen, dass `build\msvc-release\generated` korrekt aufgelöst wird.
- **Abhängigkeiten/Blocker:** keine (DONE); nur Verifikation im Hand-Lauf offen.
- **Quelle:** MANUAL-RUN:27,35.

### [P1] EXPERIMENT_MODE-Preset oder Flag-Doku  (Task #193 · manual-operability · S · lokal)
- **Was:** Klären/umsetzen, ob `COMDARE_EXPERIMENT_MODE` in `CMakePresets.json:_base` global gesetzt wird ODER nur per Commandline (`-DCOMDARE_EXPERIMENT_MODE=ON`) dokumentiert wird.
- **Ziel:** Die Generator-Targets (`csv_to_latex_cli`, `diagram_generator_cli`) sind manuell baubar; default ist cache-engine-seitig OFF.
- **Wie:** Entscheidung nötig (Verhaltensänderung, wenn in `_base`): entweder Preset-Eintrag (`CMakePresets.json:14`) ODER Manual-Doku der Flag. Default-OFF liegt in `…/comdare-cache-engine/CMakeLists.txt:367`.
- **Abhängigkeiten/Blocker:** **leichte Entscheidung** (global vs. nur dokumentiert) — User-Abstimmung sinnvoll, da Verhaltensänderung.
- **Quelle:** MANUAL-RUN:25,34.

### [P1] Stale Config-/Profil-Pfad-Annahmen fixen  (Task #193 · manual-operability · M · lokal · Profile-Resolve TEIL-DONE)
- **Was:** Die inkonsistenten Config-/Profil-Pfade des `messung_driver`/`ExperimentDriver` korrigieren: config_dir erwartet 4 Builder-XMLs unter `libs\cache_engine\builder\example_configs` (nicht `Code\experiment_config`); SOTA-Profile real unter `libs\cache_engine\algorithm_profiles\sota`.
- **Ziel:** Der Driver findet seine Configs/Profile out-of-the-box (kein Pfad-Raten).
- **Wie:** Profile-Resolve-Fix ist TEIL-DONE; verbleibend: `ExperimentDriver`-SOTA-Fallback auf `libs/cache_engine/algorithm_profiles/sota` korrigieren (`experiment_driver.cpp:95`) ODER das Manual-Pfad-Layout dokumentieren; `xml_config_parser.cpp:70` prüfen.
- **Abhängigkeiten/Blocker:** vor Edit Zeilen re-greppen; Hand-Lauf-Verifikation.
- **Quelle:** MANUAL-RUN:26,37.

### [P1] USAGE-CLI-Args + PDF/TeXLive korrigieren  (Task #193 · manual-operability · M · lokal · Banner DONE)
- **Was:** `Code/USAGE.md` auf reale Targets/Exe-Namen/CLI-Args korrigieren (binary-to-csv ist positional, nicht `--in/--out`; csv/diagram haben andere Optionen); PDF/TeXLive-Pfad entstalen (`build_thesis.bat`, kein `latex_to_pdf_cli`).
- **Ziel:** Die Doku nennt die echten Aufrufe (`messung_driver`, `binary_to_csv_cli`, `csv_to_latex_cli`, `diagram_generator_cli`) statt der falschen aus `USAGE.md:102`.
- **Wie:** USAGE-Banner ist DONE; verbleibend: CLI-Args/Exe-Pfade aus dem realen Code ablesen (nicht raten) und TeXLive/MiKTeX als Voraussetzung dokumentieren.
- **Abhängigkeiten/Blocker:** Arg-Namen aus realem `main.cpp` re-greppen.
- **Quelle:** MANUAL-RUN:28-30,36.

---

## Theme: 179-sweep (Wartbarkeit ALLER Dateien — nach Pipeline-Wins)

### [P1] #179-Sweep: JEDE Datei aller 4 Projekte (Codex-Review)  (Task #179 · 179-sweep · XL · lokal+Codex)
- **Was:** Datei-für-datei **alle** `.hpp/.cpp/.template/.ipp/.inl` aller 4 Projekte (cache-engine, prt-art, super, thesis-LaTeX-Lint) mit **Codex-Gegenreview** auf (a) Auskommentierung UND (b) Struktur/strukturelle Sauberkeit prüfen + verbessern.
- **Ziel:** „Ich will mich durchklicken" — jede Datei ohne Vorwissen navigierbar (Header-Doc, Abschnitts-Banner, Funktions-Doc, benannte Lehrbuch-Patterns). **KEINE Verhaltensänderung**, Build nach JEDER Datei grün.
- **Wie:** Inventar je Projekt → priorisierte Reihenfolge (ABI/Architektur-Kern → Achsen-Organe T0–T18 → Builder/Treiber → prt-art → Tests/Codegen zuletzt); je Datei dieselbe Checkliste; Commit pro Datei/Gruppe; Datei-Ledger fortschreiben (`20260627-179-WARTBARKEITS-SWEEP-LEDGER.md`).
- **Abhängigkeiten/Blocker:** **User-Direktive: nach Pipeline-Wins** („Beides: erst Pipeline-Wins, dann #179"); riesig, mehr-Session.
- **Quelle:** SESSION-ENDE-4:69-70 · 179-LEDGER:3.

### [P1] #179 god-header Review  (Task #179 · 179-sweep · L · lokal+Codex)
- **Was:** Die drei god-header je **in Gänze lesen** + Codex-Review + Doku/Naming/Struktur ohne Verhaltensänderung: `anatomy/abi_adapter.hpp`, `builder/experiment_tree/cache_engine_builder_iterator.hpp`, `axes/node/axis_04_node_type_layout_aware_store.hpp`.
- **Ziel:** Die größten Orchestrierungs-Header (ABI+resource+timing+observer+migration+memento+scan / CSV+resume+measure+quality+IO / node+layout+alloc+observer) lesbar machen — höchster „Durchklick"-Wert nach dem Drift-Theme.
- **Wie:** Pro Datei: in Gänze lesen (abi_adapter `:128/186/247/678/907/1136/1369/1519`; iterator `:57/267/379`; layout-aware `:86/192/271/388`), Header-Doc + Banner + Extract-Method/Strategy benennen, Codex-Review (gpt-5.5/xhigh), Build grün, committen.
- **Abhängigkeiten/Blocker:** **nächster #179-Block** (Thema-2, nach Drift-Theme `9480f98`); ggf. nach #193 (User-Self-Test rangiert davor).
- **Quelle:** SESSION-ENDE-4:66 · 179-LEDGER:12,19,24,25.

### [P1] Finaler lint:format/static HART + test_v41-Linux-Vollbau  (Task #179 · 179-sweep · M · PIPELINE-ONLY)
- **Was:** Abschluss von #179: `lint:format`/`lint:static` auf HART (= Task #203) **und** `test_v41`-Vollbau auf Linux (3 korrigierte Includes), der bisher umgangen wurde (`contract` war auf `test_abi_interface` eingegrenzt).
- **Ziel:** Der Wartbarkeits-Sweep ist erst „fertig", wenn formatiert/statisch-sauber UND der bisher gedodgte `test_v41_anatomy_module_abi` auf Linux real baut.
- **Wie:** Nach dem Format-/Struktur-Pass die advisory-Regeln scharf schalten; `test_v41` Linux-Vollbau in der contract-Stage; literal grün belegen.
- **Abhängigkeiten/Blocker:** **hängt am Voll-Sweep** (Code muss erst formatiert/bereinigt sein); identisch verzahnt mit #203.
- **Quelle:** 179-LEDGER:44 · KONSOLIDIERT:44(3).

### [P2] #179 minor: 17-Kern-Wording präzisieren  (Task #179 · 179-sweep · S · lokal+Codex)
- **Was:** Optionaler Drift-Rest: in `axis_operability_classification.hpp` + `axis_centric_namespaces.hpp` das Wording auf „**17 Kern-Achsen T0..T16**" präzisieren (17 bleibt korrekt) + `README.md:29`.
- **Ziel:** Letzte Kommentar-Konsistenz zum autoritativen Achsen-Modell (L6) — rein kosmetisch.
- **Wie:** Nur Kommentare/Doku; `array<…,17>` NICHT ändern (ist korrekt = die 17 Kern-Achsen); Codex-Review.
- **Abhängigkeiten/Blocker:** keine (low-risk); jederzeit mitnehmbar beim nächsten Edit dieser Dateien.
- **Quelle:** SESSION-ENDE-4:53 · 179-LEDGER:10(Minor-Rest),35.

### [P2] Allocator/node-store/pool Boilerplate dedup  (Task #179 · 179-sweep · L · lokal+Codex → Pipeline-Build)
- **Was:** Copy-paste-Duplikation extrahieren: Allocator-Wrappers (realloc-fallback/stats/observer/original-mixin), Node-Stores (chunked vs. layout-aware), Pool-Ref-Bit-Packing (ART/HOT-Patricia/Masstree), CSV/Stat-Helper.
- **Ziel:** Weniger Boilerplate, eine Quelle je Muster — Wartbarkeit + Build-Hygiene.
- **Wie:** Base+Registry+1 Paar lesen (`axes/alloc/*`, `axis_04_node_type_chunked_store.hpp`, `*_node_pool_store.hpp`), Helper extrahieren (Pattern benennen). **Achtung: ändert Code → Build+Test grün halten** (nicht nur Kommentar-Pass).
- **Abhängigkeiten/Blocker:** nach god-header; ABI-Vorsicht (kein versehentlicher ABI-Bruch).
- **Quelle:** 179-LEDGER:14,42 · 179-LEDGER:27,30.

### [P2] topics/* vs. modules/* — Mirror-Autorität klären  (Task #179 · 179-sweep · XL · lokal+Codex + User-Abstimmung)
- **Was:** Die Legacy-Parallelstrukturen entscheiden: `topics/*` (389 divergente Dateien, Spiegel zu `axes/` 314) + `modules/*` (stale ABI/Observer/Memento-Kopien) — welche Quelle ist autoritativ (löschen vs. konsolidieren)?
- **Ziel:** Eine autoritative Quelle je Konzept; tote Spiegel raus → drastisch weniger Verwirr-Fläche.
- **Wie:** **Separater Cleanup-Track, NICHT in den axes-Sweep mischen.** Autoritäts-Analyse + User-Abstimmung (Messdaten/ABI-Vorsicht); `git mv` statt Löschen wo Doku betroffen.
- **Abhängigkeiten/Blocker:** **schwere Entscheidung → mit User abstimmen**; GROSS; nach dem Kern-Sweep.
- **Quelle:** 179-LEDGER:13,43 · 179-LEDGER:33,36.

---

## Theme: measurement-prep (Mess-Lauf — nach der Pipeline)

### [P1] Voll-PMC-Mess-Lauf (mehrtägig) + NAS-Writeback  (Task #156 · measurement-prep · XL · PIPELINE-ONLY)
- **Was:** Der EINE umfassende m3v2-Voll-Mess-Lauf (320 Tiere + ≥21 SOTA inkl. Reihe C × Zwei-Phasen × Working-Set-Sweep) mit **realen Cache-Misses** auf prod1 (AMD) + prod2 (Intel), Ergebnisse per **NAS-Writeback** sichern.
- **Ziel:** Die thesis-kritischen, mess-belastbaren Werte für FF3 — autoritativ auf prod-bare-metal.
- **Wie:** Mess-Pfad code-ready (PMC-WIDE-Naht im `perm_runner`, 7 `pmc_*`-Spalten, `b285002`); `COMDARE_ENABLE_PMC=ON` Drop-in real; läuft als Background-Lauf auf prod-Runnern, danach NAS-Writeback + bilinguale PDF + G5/§7.4-Re-Audit.
- **Abhängigkeiten/Blocker:** **braucht mehrtägiges User-Zeitfenster** (lastet prod1 aus) + Artefakt-Storage (MinIO-500-Fix) + grüne Pipeline; durch Linux+PMC auf prod1 grundsätzlich ENTSPERRT.
- **Quelle:** PHASE-A:11 · IMPL-AGENT:73-76 · SESSION-ENDE-3:39.

### [P1] Generalprobe: m3v2-WIDE CSV→TeX/PDF  (Task — · measurement-prep · M · lokal+Codex)
- **Was:** Vor dem Voll-Lauf die Auswertungs-Pipeline (`csv_to_latex`/`diagram_generator`) header-getrieben auf das m3v2-WIDE-Schema generalisieren und gegen einen Klein-Pilot E2E durchprobieren.
- **Ziel:** Der Voll-Lauf (#156) ist sofort auswertbar; Tabellen/Diagramme passen aufs reale Schema (zusätzliche Spalten `seg_coverage`/`CLU`/`series`/`working_set_n` + SOTA-/CLU-/Working-Set-Tabellen).
- **Wie:** Generatoren `write_sota_series_table`/`write_working_set_sweep`/`write_sweep_axis`/`write_seg_coverage` existieren; L8 `generate_wide_appendix.ps1` hat den m3v2-Schalter → End-to-End gegen reales m3v2-CSV durchprobieren.
- **Abhängigkeiten/Blocker:** **gate-frei** (gegen Klein-Pilot generalprobbar; voller Nutzen erst mit #156-Daten).
- **Quelle:** IMPL-AGENT:78-81 (A.2.2).

### [P1] PMC-Auto-Adaption je ISA/OS/Counter  (Task #187 · measurement-prep · L · PIPELINE-ONLY)
- **Was:** Capability-Detection je ISA+OS+Umgebung (welche Counter existieren: L1/L2/L3/dTLB/branch/energy …) → Messung + Tabellen passen sich **automatisch** an = „maximal genau, so genau wie verfügbar".
- **Ziel:** Die Messung ist immer maximal präzise, ohne bei fehlenden Countern zu brechen; inkl. AMD-L3/LL-Mapping (L3=0-Befund).
- **Wie:** Counter-Capability-Probe je Plattform; Mess-Schema + LaTeX-Tabellen adaptiv (vorhandene Spalten füllen, fehlende sauber auslassen). Event-Codes pro Event web-verifizieren.
- **Abhängigkeiten/Blocker:** Intel-PMC/perf erst seit kurzem verfügbar; reale Counter-Verifikation auf prod (Laptop zu langsam/eingeschränkt).
- **Quelle:** USER-ANTWORTEN:57-60 (A9) · USER-ANTWORTEN:113-114 (B9).

### [P1] sota_catalog Stufe→Reihe-Mapping  (Task #178/#20 · measurement-prep · M · lokal+Codex)
- **Was:** `tests/unit/thesis_tiere/sota_catalog.hpp:18-24` vom falschen flachen Mapping (`A=Stufe1_CeOnly`) auf das ch1-FF3-Soll ziehen: **A = Prüfling vs. SOTA aus Stufe 1 UND 2 gemeinsam; B = `Stufe3_FullJoin`; C = build-übergreifend** (NICHT stufengebunden).
- **Ziel:** A ist nicht länger fälschlich die Isolations-Reihe; Code stimmt mit Treiber-Enum (`main.cpp:108-118`) + Thesis überein.
- **Wie:** **A-Teil sofort** korrigierbar (überall gleich). Ripple beachten: `test_sota_series_pilot.cpp:115/119/123` + 3 Profile + `messung_driver` `MessreiheKind::C`. ch4 NICHT ändern (ist Soll).
- **Abhängigkeiten/Blocker:** **B/C-Labels blockiert**, bis die Thesis-interne B/C-Drift (ch1-FF3 ↔ ch6 sec:series) von Text-Agent/User aufgelöst ist; der tiefere Umbau gehört per A7 zu #162 (P2).
- **Quelle:** SESSION-UEBERGABE-2:89-90 · IMPL-AGENT:130-135 (A.3.1) · USER-ANTWORTEN:161-168 (Nachtrag).

### [P1] PRT-ART: 90ns/codegen-Stubs durch echte Ops ersetzen  (Task — · measurement-prep · XL · lokal+Codex)
- **Was:** Den Codegen-Body (`prt_art/codegen/templates/prtart_body.hpp.template`) + `lookup/insert/erase/range_scan`-Stubs durch **reale Anatomie** ersetzen — aktuell liefert der Prüfling fixe **90 ns/op** („Pruefling-Stub-Wert").
- **Ziel:** Mess-Validität: der Prüfling misst echte Operationen statt fixer ns-Werte (sonst ist der ganze Lauf wertlos).
- **Wie:** Echte Implementation von lookup/insert/erase/range_scan; Signaling-Bits-Serialisierung (1+ser_length+payload); ABI-stabiles C++23-Modul-Interface (POD + function pointers); CacheEngineBuilder-Integration (PRT-ART als Binary).
- **Abhängigkeiten/Blocker:** **mess-validitäts-kritisch**; Vorbedingung für #162; prt-art-Submodule-Pin zuerst bumpen.
- **Quelle:** IMPL-AGENT:95-98 (A.2.5).

### [P2] PRT-ART + SOTA: Reihe C / Voll-Skalierung  (Task #162 · measurement-prep · XL · PIPELINE-ONLY)
- **Was:** PRT-ART + ≥8 Rang-1-SOTA-Lebewesen + Messreihen A/B/C in den Voll-Lauf bringen; verbleibend code-seitig **Reihe C** (`Stufe3_FullJoin` Prüfling-Repräsentant der Union) vollständig + **Voll-Skalierung**.
- **Ziel:** Forschungsfrage FF3 adressieren (ohne diese Reihen nicht beantwortbar).
- **Wie:** Apparat (Tag/Selektion, Reihen A/B, axis_sweep) ist REAL gebaut + probe-gemessen (`sota_catalog.hpp` baut 6 SOTA + PRT-ART; `MasstreePrtStufe3FullJoinComposition` vorhanden). Reihe C komplettieren + skalieren.
- **Abhängigkeiten/Blocker:** **gated auf #156** (Voll-Lauf) + Thesis-B/C-Drift (für Labels); per A7 nach der Pipeline.
- **Quelle:** IMPL-AGENT:83-87 (A.2.3) · KONSOLIDIERT:121.

### [P2] Echte SOTA-Legacy-Impl P11–P27 bauen  (Task — · measurement-prep · XL · lokal+Codex)
- **Was:** Die 14 `legacy_reimpl`-Skelette (P11-CSS, P12-CSB, P13-Hankins, P14-Samuel, P16/17-Bender, P18/19-Saikkonen, P21/22-Chen, P23-Khan, P24-NaderanTahan, P26/27-Zhang) zu **echten Lebewesen** ausbauen (je aktuell 1 Concept-anchored Skelett-Header).
- **Ziel:** Die Rang-1-SOTA-Lebewesen, die #162/FF3 als Vergleichsbasis braucht.
- **Wie:** Pro `prt_art/legacy_reimpl/P*/include/*.hpp`: C++23-Implementation + Adapter an die Bausteine-Matrix-Achse (z. B. P27 Prefetch); Web-Recherche je Algorithmus (Paper-Original-Code-Pattern).
- **Abhängigkeiten/Blocker:** Vorbedingung für #162; groß; nach den Stub-Ersätzen (PRT-ART 90ns).
- **Quelle:** IMPL-AGENT:89-93 (A.2.4).

### [P2] SIMD/ISA + Allokator-Varianten ×2 Plattformen  (Task #163 · measurement-prep · L · PIPELINE-ONLY)
- **Was:** SIMD/ISA + Allokator als **variierte Achsen** messen, über ≥2 Plattformen (Hybrid + Sapphire Rapids).
- **Ziel:** Die Achsen-Wirkung plattformübergreifend belegen (T12 ISA-Achse + Allokator-Achse).
- **Wie:** Achsen-Variation im Profil; Lauf auf prod1/prod2 (+ Matrix-Runner #189); reale Counter.
- **Abhängigkeiten/Blocker:** ≥2 Plattformen (prod2-I/O-Fix #207 + Matrix #189); per A7 nach der Pipeline.
- **Quelle:** KONSOLIDIERT:136-138 · IMPL-AGENT:111 (A.2.8 P-MD5).

### [P2] quiesced-OS Quality-Provenienz  (Task #165 · measurement-prep · M · PIPELINE-ONLY)
- **Was:** Den `system_disturbed`-Provenienz-Teil des `quality_flag` bei quiesziertem Mess-Lauf liefern (Per-Zeilen-Quality-Flag + winsorisierte/Perzentil-Ausgabe).
- **Ziel:** Aussagekräftige Qualitäts-Markierung je Messzeile (datenerhaltend, additive Spalte).
- **Wie:** Statistik-Hälfte (`winsorized_mean_ns` + `quality_flag`) ist code-seitig erledigt (`d60f7b0`); verbleibend = `system_disturbed`-Provenienz bei ruhigem Experiment-OS.
- **Abhängigkeiten/Blocker:** **Infra: quiesziertes Experiment-OS**; Statistik-Code-Hälfte schon da.
- **Quelle:** IMPL-AGENT:115-118 (A.2.9).

### [P2] Allokatoren echt linken (jemalloc/tcmalloc/hoard/scalloc)  (Task #19 · measurement-prep · L · PIPELINE-ONLY)
- **Was:** Die Allokator-Permutationen real linken — aktuell fallen `jemalloc/tcmalloc/hoard/scalloc` auf `std::malloc` zurück (`(real=std)`); nur `mimalloc`+`snmalloc` sind echt eingebunden.
- **Ziel:** Plugin-Output zeigt `(real=<allocator>)` statt `(real=std)` → die Allokator-Achse misst wirklich verschiedene Allokatoren.
- **Wie:** jemalloc (MSYS2 `autogen.sh`/vcpkg/pre-gen Header), tcmalloc (Abseil+`ext/A06` vendored), hoard (`add_subdirectory(ext/A01-hoard)`), scalloc (CMake-Port für `ext/A08`).
- **Abhängigkeiten/Blocker:** **Windows-autoconf/vendored-Build-Toolchain**; auf Linux/ZIH uneingeschränkt baubar → daher auf Runner.
- **Quelle:** SESSION-ENDE-4:54 · IMPL-AGENT:137-140 (A.3.2).

### [P2] lazy-DLL Content-Hash-Versionierung  (Task #125 · measurement-prep · M · lokal+Codex)
- **Was:** Pro Tier-DLL eine inhalts-abgeleitete Versionierung via Content-Hash-Codegen.
- **Ziel:** Identische Anatomien werden nicht neu gebaut; Mess-Daten sind stabil einer Build-Version zugeordnet.
- **Wie:** Content-Hash über die generierte Anatomie → DLL-Versionsname; Build-Skip bei gleichem Hash.
- **Abhängigkeiten/Blocker:** **bewusst deferred, niedrige Prio** (kein Blocker für #156; Resume-Härtung existiert).
- **Quelle:** IMPL-AGENT:158-160 (A.3.6).

---

## Theme: architecture-gap (Code-Lags gegen die Thesis)

### [P1] T0-Such-Delegation über Speicher-Achsen (#182-Lücke-1)  (Task #188 · architecture-gap · XL · lokal+Codex)
- **Was:** Den schwerwiegenden Architekturfehler fixen: T0-Such-Metrik muss über die **Speicher-Achsen T4/T5/T6** statt über den `search_organ_`-Monolith laufen (Tree/Trie/Hash/k-ary/Eytzinger melden derzeit aus dem Monolith).
- **Ziel:** §3.3-Claim „verteilte Interfaces überall" nachweisbar; mess-echte Belege (der `search_organ_`-Sonderpfad verfälscht sonst die Messung).
- **Wie:** SOLL als **Diff** finden; zentrale Steuerung = **Experiment-B+-Baum** (`experiment_tree.hpp` + `perm_runner.hpp`); SOLL-Muster `store_traversable_search_algo.hpp` (Weg-A routet T0 durch den Store); IST `abi_adapter.hpp` `fill_observer_v3` `search_organ_.statistics()` (~:924) + `tier_search_routes_through_store()==false` (~:1490). Mess-Semantik-Wechsel ist hier freigegeben.
- **Abhängigkeiten/Blocker:** GROSS → fokussierte Ausführung (frischer Kontext); Zeilen re-greppen.
- **Quelle:** SESSION-UEBERGABE-2:80-83 · USER-ANTWORTEN:90,169-173 (B10/Nachtrag) · IMPL-AGENT:174 (A.4.1.1).

### [P2] Nicht-YCSB Dataset-Loader/Workload-Achse  (Task #184 · architecture-gap · M · lokal+Codex)
- **Was:** Die Nicht-YCSB-Frameworks (TPC, SOSD, reale String-Korpora url/dna/protein/xml/tpcds-id/trec-terms, SPEC/CloudSuite, mimalloc-bench) als **Workload-Achse** real einbinden.
- **Ziel:** ch2.4.2/ch3 decken die Frameworks (Plural) ab — nicht nur YCSB.
- **Wie:** Dataset-Loader-Slot + Workload-Achse im Code; Bib via AP-Z1/Z2 (Cooper2010 YCSB, Kipf/Marcus SOSD, TPC, SPEC, mimalloc-bench).
- **Abhängigkeiten/Blocker:** Impl-Revier cache-engine; keine harten Blocker (Code).
- **Quelle:** IMPL-AGENT:200-203 (A.4.6).

### [P2] TPIE/EM-BFS I/O-Achse  (Task #185 · architecture-gap · L · lokal+Codex)
- **Was:** Eine externe-Speicher-I/O-Achse (TPIE + EM-BFS) als eigenes Organ in den Achsenbaum einbauen.
- **Ziel:** Die I/O-/External-Memory-Dimension der Survey im Code abbilden (Vollständigkeit gegen die Bausteine-Matrix).
- **Wie:** TPIE als Vendor (ext/), EM-BFS-Algorithmus als Achsen-Organ; Paper-Code-Pattern + Web-Recherche je Algorithmus.
- **Abhängigkeiten/Blocker:** Vendor-Build; nach den mess-kritischen Items.
- **Quelle:** KONSOLIDIERT:141-142 · KONSOLIDIERT(§7-Tabelle):142.

### [P2] Stale Architektur-/XML-Docs auf 19-Achsen-Vokabular  (Task — · architecture-gap · S · lokal+Codex)
- **Was:** Superseded Doc-/XML-Einträge korrigieren: `docs/bausteine/03_cross_paper_konzeptmatrix.md:152` „P20 LeanStore" → `mueller2025btreesback`; `permutation_axes.xml` „11 Achsen REV7.6" → **19 Achsen T0–T18**.
- **Ziel:** Doku/XML stimmen mit dem autoritativen Achsen-Modell (L6) + aktueller Paper-Zuordnung überein.
- **Wie:** Reiner Doc-/XML-Edit auf Doc-34-Vokabular; Codex-Review.
- **Abhängigkeiten/Blocker:** keine; Quick-Win.
- **Quelle:** IMPL-AGENT:210-213 (A.4.8).

### [P2] Crystalline/StdMalloc Allokator-Namen prüfen  (Task — · architecture-gap · S · lokal+Codex)
- **Was:** Zwei Code-Renames gegen die Thesis prüfen/ziehen: falls die Engine-Klasse `CrystallineAllocator` heißt → `CrystallineReclamation` (Crystalline = wait-free Reclamation, kein Allokator); `Std_Malloc`/`StdMalloc` konsistent mit `_Allocator`-Suffix benennen + im 2. A-Korpus-Block führen.
- **Ziel:** Code-Klassennamen = Anhang-D-Tabelle (Konsistenz Code ↔ Thesis).
- **Wie:** Realen Klassennamen re-greppen (nicht raten); falls Mismatch → Rename + Referenzen ziehen; Codex-Review.
- **Abhängigkeiten/Blocker:** keine; Quick-Win (nur falls Name real abweicht).
- **Quelle:** IMPL-AGENT:190-198 (A.4.4/A.4.5).

### [P2] V42: Nicht-SearchAlgorithm-Gattungs-Docks  (Task #10 · architecture-gap · XL · lokal+Codex)
- **Was:** Den Mixed-Genus-Vollausbau gegen die literalen GOAL-V6-Gate-Kriterien schließen: alle 22 Achsen × alle 5 Lebewesen-Unterklassen (Set/Sequence/Adapter/View) je Gattung über EIGENE Komposition/Anatomie/Prüf-Dock, registry-getrieben, jedes Blatt baubar, jeder Knoten echter per-Achsen-Observer.
- **Ziel:** Vollständigkeit über alle Gattungen (IST: SearchAlgorithm voll, Container minimal; `page_type`/`simd_extension`/`general_hardware` nur DefinitionOnly; nur 2/5 Gattungen gebunden).
- **Wie:** Restlücken gegen Gate-3/Gate-4 (ohne Pilot-/R5.B-Vorbehalt) schließen; `ceb_generator` aus der `#define`-Hülle in echten Codegen; danach Phase-E adversarialer Vollständigkeits-Audit.
- **Abhängigkeiten/Blocker:** GROSS; Tracker zeigt #74-77/#80-82 „completed" → literal verifizieren; teils V42-Infra-Rest.
- **Quelle:** ledger:185 · IMPL-AGENT:148-156 (A.3.4/A.3.5).

### [P2] E11-Facade über reale Submodule  (Task — · architecture-gap · L · lokal+Codex)
- **Was:** Die E11-Facade so umbauen, dass sie über die **realen Submodule** (cache-engine/prt-art) statt über Platzhalter/lokale Kopien fassadiert.
- **Ziel:** Eine saubere Fassade über die echten Modul-Grenzen (konsistent mit der 4-Modul-Architektur).
- **Wie:** Facade gegen die Submodul-Targets (CMake `target_link_libraries`/`.gitmodules`) verdrahten; Codex-Review.
- **Abhängigkeiten/Blocker:** Submodule-Pins aktuell; nach I1-Konsolidierung.
- **Quelle:** ledger:165.

---

## Theme: other (Restarbeiten/Hygiene)

### [P1] Alle 4 Research-Klone hydrieren + syncen  (Task — · other · S · lokal)
- **Was:** Die 4 OneDrive-cloud-only/dehydrierten Research-Klone (`Desktop\Projekte\Research\{comdare-cache-engine, comdare-prt-art, super, 20260931-overleaf-diplomarbeit}`) **hydrieren** und gegen `Code/external` (= Quelle) syncen.
- **Ziel:** Lokale Klone aktuell + git-zugänglich (kein Fehlsignal „kein PAT" durch dehydrierte `.git`).
- **Wie:** OneDrive „immer auf diesem Gerät behalten" / git-Zugriff erzwingt Download; dann im Research-Klon `git fetch` + **fast-forward NUR wenn `git status` clean**; bei dirty/divergent **STOPP + melden** (kein `reset --hard`). **Bei `git remote`-Scans IMMER Token redacten** (`sed 's#//[^@/]*@#//***@#'`).
- **Abhängigkeiten/Blocker:** keine (User-bestätigt); Top-Level-`Get-ChildItem` statt blind `-Recurse`.
- **Quelle:** SESSION-ENDE-4:65,72 · SESSION-ENDE-4:37.

### [P2] Mess-Tabellen-Textüberlappung fixen  (Task #154-Rest · other · S · lokal+Codex)
- **Was:** Die verbleibende Textüberlappung in den Mess-Tabellen (Float/Spaltenbreite) beheben.
- **Ziel:** Saubere, lesbare Tabellen im PDF (kein Überlappen) — Rest von #154.
- **Wie:** Spaltenbreiten/`\textwidth`/Float-Layout in den betroffenen Tabellen anpassen; gegen latexmk-Build prüfen.
- **Abhängigkeiten/Blocker:** TeXLive-Build (thesis-Gate #205); klein.
- **Quelle:** phase-L:253-259.

### [P2] Deprecated prt-art-Legacy-Header löschen  (Task — · other · S · lokal+Codex)
- **Was:** Den deprecated `prt_art_search_engine_adapter.hpp` bei der I1-Konsolidierung mit-entfernen (Doc 19: deprecated).
- **Ziel:** Toter Legacy-Header raus; eine API-Klasse (`PrtArtSearchEngine<Ts...>`).
- **Wie:** Bei der Code-Vereinheitlichung (I1/#176) den Adapter-Header entfernen + Referenzen ziehen; `git rm` (Doku via `git mv`, nie hart löschen).
- **Abhängigkeiten/Blocker:** **an I1-Konsolidierung gekoppelt**; prt-art-Submodule-Pin aktuell.
- **Quelle:** ledger:166 · IMPL-AGENT:64-67 (A.1.6).

---

## Theme: Meta / gerettete Direktiven (Session-verschoben, #459 — eigene Einträge)

### [P1/Meta] Web-Recherche: sinnvolle Pipeline-Gates je Eigenschaft  (Task #206 · meta · M · Web-Recherche → Pipeline-Gates)
- **Was:** Im Web nach sinnvollen Quality-Gates für **jede einzelne Pipeline-Eigenschaft** recherchieren (über das User-Drift-Gate hinaus) und je Stufe ein sperrendes Gate definieren.
- **Ziel:** Jede der 10 Stufen hat ein begründetes, web-fundiertes Gate, das die nächste Stufe sperrt — professioneller CI-Standard.
- **Wie:** Eine **erste Tabelle existiert bereits** (USER-ANTWORTEN Teil D, je Stufe ein Gate: clang-format `-Werror`, gitleaks hart, asan/tsan/ubsan, std::map-Gatter, Coverage ≥80 %, Drift >5 %→3×, SBOM `syft`+`grype`/`trivy` 0 kritisch, Performance-Regressions-Gate, canary-loggate). Diese fortlaufend pflegen/erweitern und an die realen Stufen (Tasks #195–#201) koppeln.
- **Abhängigkeiten/Blocker:** speist die P0-Stufen-Tasks; reine Recherche+Doku, Anwendung in der Pipeline.
- **Quelle:** USER-ANTWORTEN:37-40,133-156 (A4/Teil D) · KONSOLIDIERT:54 (§2-12, #459 Frage 4).

### [Meta] Doku-Konvention: User-Antworten in BEIDEN Formaten persistieren  (Task — · meta · S · Prozess/Doku)
- **Was:** Alle künftigen User-Antworten **einmal im Klartext** als wörtlich-treue TODO-Anweisungs-Erweiterung UND **einmal in eigener verständlicher Formulierung** persistieren.
- **Ziel:** Keine Direktive geht verloren oder wird durch Paraphrase verfälscht (Lehre: #459-Direktiven lagen nur in überholten 06-25-Docs und wären fast verloren gegangen).
- **Wie:** Bei jeder User-Antwort beide Blöcke schreiben (vgl. das Muster in `USER-ANTWORTEN-13`: Teil A = Klartext, Teil B = Formulierung); als fortzuschreibende Konvention führen.
- **Abhängigkeiten/Blocker:** keine (Arbeitsweise/Prozess); dauerhaft.
- **Quelle:** KONSOLIDIERT:55 (§2-13, #459 Schluss).

---

## 5. Empfohlene Reihenfolge

1. **Pipeline-grün-Fix (zuerst):** `trigger:forward:false`-Fix → **#194** Wave-4 + Super-Orchestrierung literal grün re-verifizieren. Ohne grünes Fundament hat keine weitere Stufe Wert.
2. **Restliche P0-Stufen aufbauen:** sanitize HART (**#204**) · contract-durability (**#195**) · integration-E2E (**#196**) · chaos-Drift-Gate (**#197**) · manifest+prebackup (**#198**) · K8s-Pod (**#199**) · deploy-staging-prod→dev-Gate (**#200**) · smoke-canary (**#201**) · NAS-Writeback+Binary+PDF (**#202**); flankiert von ISA/OS-Matrix (**#189**, infra-gated) · prod2-I/O-Fix (**#207**, Wartungsfenster) · Runner 19.1.1 (**#208**) · thesis-Gate (**#205**). lint HART (**#203**) erst nach #179.
3. **#193-Rest (manuelle Bedienbarkeit, TOP-PRIO, rangiert plausibel vor #179-god-header):** EXPERIMENT_MODE-Entscheidung · Profil-Pfad-Fix · USAGE-CLI-Korrektur · MANUAL_RUN-Doc finalisieren · **echter Hand-Lauf-Verifikation** (auf schnellem Runner).
4. **#179 (Wartbarkeit):** god-header → Boilerplate-Dedup → topics/*-vs-modules/*-Autorität (User-Abstimmung) → Voll-Sweep aller 4 Projekte → finaler lint:format/static HART + test_v41-Linux-Vollbau (= #203-Abschluss). Parallel: Research-Klone hydrieren/syncen, stale-XML/Namens-Quick-Wins, #188-Architekturfix.
5. **Messung (nach der Pipeline, A7):** Generalprobe-m3v2 → PRT-ART-90ns-Stubs ersetzen + SOTA-Legacy P11–P27 → **#156** Voll-PMC-Lauf (Zeitfenster) + #162/#163/#165/#187/#19 → NAS-Writeback + bilinguale PDF.

---

## 6. Quellen-Index (Kürzel → Datei in `docs/sessions/`)

| Kürzel | Datei |
|---|---|
| CICD | `20260625-CICD-PIPELINE-ARCHITEKTUR-4-MODULE-BASIS-PIPELINE-PRINZIP.md` |
| USER-ANTWORTEN | `20260625-USER-ANTWORTEN-13-ENTSCHEIDUNGEN-CICD-MESS-ARCHITEKTUR.md` |
| IMPL-AGENT | `20260625-IMPL-AGENT-KONSOLIDIERTE-TODOS-HANDOVERS-WARTBARKEIT.md` |
| SESSION-UEBERGABE-2 | `20260625-SESSION-UEBERGABE-2-impl-agent-I1-DONE-CICD-EPIC-MESS-ENTSPERRT-188.md` |
| KONSOLIDIERT | `20260626-KONSOLIDIERT-OFFENE-TASKS-SELF-HANDOFFS.md` |
| SESSION-ENDE-3 | `20260627-SESSION-ENDE-3-CI-WAVES-CODEX-PROD2-ELABORATE-UEBERGABE.md` |
| SESSION-ENDE-4 | `20260627-SESSION-ENDE-4-GOAL-V-179-DRIFT-CI-WINS-ELABORATE-UEBERGABE.md` |
| PHASE-A | `20260627-PHASE-A-PIPELINE-WINS-PROGRESS.md` |
| 179-LEDGER | `20260627-179-WARTBARKEITS-SWEEP-LEDGER.md` |
| MANUAL-RUN | `20260627-MANUAL-RUN-GAP-ANALYSE-CODEX.md` |
| ledger | cache-engine `Code/external/comdare-cache-engine/docs/sessions/architektur-ziele-offene-punkte-ledger.md` (Live-Single-Source) |
| phase-L | thesis phase-L-Mess-Tabellen-Doc (`#154`-Kontext) |

---
*Konsolidiert 2026-06-27. 48 Codex-Tasks + 2 gerettete #459-Direktiven, elaboriert. Bei Widerspruch zu konkreten Code-Stellen: Zeilen re-greppen; Live-Vorrang = cache-engine-Ledger. Kein Erfolgsmark ohne wörtliche Tool-Ausgabe.*
