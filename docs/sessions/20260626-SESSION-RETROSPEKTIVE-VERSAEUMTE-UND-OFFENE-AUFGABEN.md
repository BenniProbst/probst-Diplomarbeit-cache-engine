# SESSION-RETROSPEKTIVE (2026-06-25/26) — Versäumte + Offene Aufgaben (elaborat)

> **Auftrag (User 2026-06-26):** „notiere ab hier elaborat über die gesamte Session alle versäumten und noch offenen Aufgaben, persistiere das." Diese Datei ist die **Single-Source der Rest-/Schuld-Liste** dieser sehr langen Session (CI-EPIC #186 + Abzweige). Ergänzt/aktualisiert die früheren Handover-Docs `20260625-SESSION-ENDE-…` (teils überholt).
> **Rolle:** Implementierungsagent · **Primärziel der Session:** GitLab-CI grün auf 4 Modulen (cache-engine 286, prt-art 287, super 288, thesis 289) + Projektstruktur-Verbesserung + echtes Pipeline-Debugging. „Bitte rate nie."

---

## A. WAS ERREICHT WURDE (Kontext, knapp)
- ci-templates dedupliziert + per **PUT** (nicht POST!) nach `comdare/cluster/ci-templates` transferiert; `base-pipeline.yml` mit **hermetischem Lint-Bootstrap** (gitleaks 8.30.1 hart, clang-format/cppcheck advisory).
- **4 Modul-CIs angelegt + gepusht:** cache-engine (REV 11), prt-art (REV 10), super (REV 10), thesis (REV 1).
- **2 Module verifiziert GRÜN:** super (#6953) · cache-engine AMD (#6987: lint:secrets+pmc:amd+contract).
- 5 echte Root-Causes gefixt: prod2-Blackhole (pausiert) · thesis-Submodul ungepusht (FF gepusht) · prt-art apt-Egress (→bare-metal) · cache-engine Linux-Include-Bug (3 `axes/*/concepts/`-Header) · prt-art INTERFACE-Lib-Target (→via Test-Consumer).
- Runbook prod2-14900KS-Hardwaretest geschrieben (`cluster_development/docs/RUNBOOK-prod2-14900KS-stabilitaetstest.md`).

---

## B. VERSÄUMT / UMGANGEN — Schuld, die noch offen ist (mit Begründung)
1. **Mess-Lauf nur als Smoke gemergt — der ECHTE Mess-Lauf fehlt.** build+measure → EIN `pmc`-Smoke (`linux_perf_pmc_smoke`). Der reale mehrtägige PMC-Mess-Lauf (286 build→measure, #156/#162, FF3) ist **nicht** in der CI. **Geschuldet:** separater Mess-Job (scheduled/manual) + NAS-Writeback statt GitLab-Artefakte.
2. **Artefakt-Storage-500 nur umgangen, nicht gelöst.** Alle großen Artefakte (`build/`, `Code/build/`) entfernt, um das post-swap-MinIO-500 zu dodgen. Der Mess-Writeback BRAUCHT aber Artefakte. **Geschuldet (Infra):** Artefakt-Object-Storage prüfen/fixen → dann Mess-Artefakte/NAS-Writeback restaurieren.
3. **`test_v41_anatomy_module_abi` nicht auf Linux gebaut.** contract auf `test_abi_interface` eingegrenzt (um den — jetzt gefixten — Include-Bug zu dodgen). Der **Linux-Vollbau von test_v41** mit den 3 korrigierten Includes ist UNVERIFIZIERT. **Geschuldet:** test_v41 Linux bauen (Include-Fix + evtl. weitere Linux-Befunde) — Teil #179.
4. **lint:format + lint:static = advisory (allow_failure) übersprungen.** clang-format + cppcheck FAILEN aktuell (Code nicht formatiert / cppcheck-Findings). **Geschuldet:** #179-Format-Pass (clang-format) + cppcheck-Fixes → dann auf HART umstellen.
5. **10-Stufen-Pipeline nur zu ~1/3.** Gebaut: lint/build/contract (+ analyse/pdf bei super). **Fehlen komplett:** sanitize (P1b, ASan/UBSan/TSan), integration, **chaos-engineering**, manifest+prebackup, K8s-prod-Pod-Deploy, deploy-staging, **smoke-canary**. **Geschuldet:** Reststufen pro Modul gemäß 10-Stufen-Prinzip.
6. **prod→dev-DB-Sync-Gate nur persistiert, NICHT implementiert.** Konzept in CICD-Doc §8b + Memory; CI-seitig nicht gebaut (prod-DBs read-only→dev → Chaos-Eng → dev-Artefakt-Verify VOR prod-Deploy). **Geschuldet (infra-gated):** P1f umsetzen.
7. **Core-Budget-Mismatch (concurrency=2).** `CMAKE_BUILD_PARALLEL_LEVEL`: cache-engine=8, prt-art=4, super=8. Sobald config.toml `concurrent=2` + 8-Kern-cgroup greift → 2 Jobs × 8 = 16 > 8 = **Oversubscription**. **Geschuldet:** je Runner `CMAKE_BUILD_PARALLEL_LEVEL = Kerne/concurrent` (z.B. 8-Kern/2 = **4**) — mit #189 abstimmen.
8. **thesis chktex + latexmk-PDF nie real getestet.** texlive-gegatet (Infra-Voraussetzung P1c) → auf thesis(289) läuft NUR gitleaks. **Geschuldet (Infra):** texlive auf Runner → `COMDARE_TEXLIVE_AVAILABLE=true` → chktex+PDF verifizieren.
9. **Session-Start-Ritual unklar erfüllt.** CLAUDE.md: „lade zu jeder Session die letzten 15 Themen + alle Masterpläne". Session kam aus Compaction — **nicht belegt**, dass die letzten 15 Sessions + alle Masterpläne explizit vorgeladen wurden. **Geschuldet:** beim nächsten Start nachholen.
10. **Neue Session-Lektionen noch nicht alle in Memory.** Siehe §E — diese sind zu persistieren.
11. **prt-art + thesis Grün-Status nie bestätigt** (Session zweigte zum prod2-Hardware-Thema ab). Siehe §C-1.

---

## C. OFFEN / BLOCKIERT / UNBESTÄTIGT
1. **prt-art #6988 + thesis #6989 — Endzustand UNBESTÄTIGT.** Getriggert (bare-metal build:standalone / gitleaks), aber nie auf terminal geprüft. **Nächster Schritt:** Job-Stände holen → grün bestätigen oder debuggen.
2. **cache-engine Intel-Seite (`pmc:intel`) — nie grün verifiziert.** prod2 instabil (Crashes) + SSH kaputt → re-gated (`COMDARE_PROD2_AVAILABLE=false`), Intel-Lauf #6990 abgebrochen, Runner 17 **pausiert**. Blockiert bis prod2-Hardware OK + SSH-Recovery.
3. **prod2-Hardware-Test (14900KS) — wartet auf User-Zugang.** User stellt Zugang bereit (IPMI-Key-Add ODER BMC-Creds), DANN fahre ich Runbook (memtest86+/mprime/stress-ng/mcelog) + streame Ergebnisse in Windows-Desktop-Ordner. **Verdacht:** Intel-13/14-Gen-Degradation → ggf. CPU-RMA.
4. **prod2-SSH-Recovery — GRUNDLEGEND kaputt.** prod2 `authorized_keys` akzeptiert KEINEN Key — auch **nicht vom Bastion Pi5** (`node7@10.0.10.207`, cluster-Key ✓ bis Pi5; Pi5→prod2 alle Key×User = denied). Der dokumentierte „prod2-SSH-Recovery"-Gate ist real ungelöst. **Geschuldet (Infra/User):** Key via IPMI-Konsole/physisch auf prod2 legen.
5. **config.toml concurrency=2 + cgroup (8/10 Kerne)** — Infra-Handoff #189 (Host-Eingriff, nicht Impl-Agent).
6. **Vorbestehende offene Diplomarbeit-Tasks** (nicht CI, aber offen): #19 (Allokatoren echt linken), #125 (P6 lazy-DLL Content-Hash-Versionierung), #152/#156 (Cache-Misses/M3-Neumessung HELD bis Linux+PMC), #162/#163/#165 (Mess-Vorbereitung PRT-ART+SOTA / SIMD+Allokator-Achsen / quiesziertes OS), #178 (sota_catalog Stufe→Reihe, blockiert bis Thesis-Drift), **#179 (Wartbarkeits-Sweep ALLER C++-Dateien — GROSS)**, #184 (Dataset-Loader-Slot), #185 (TPIE/EM-BFS), #187 (PMC-Auto-Adaption), #188 (T0-Such-Delegation Architekturfix), #189 (Infra-Handoff universelle Runner).
7. **Tieferer Struktur-Umbau (User-Scope-Erweiterung) — komplett offen.** 01-06→semantische Tool-Namen, verstreute Skripte konsolidieren, Test-Runner/CMake-Konventionen vereinheitlichen (überlappt #179). Bewusst auf „nach grünem CI-Netz / Phase D" verschoben — **nicht begonnen**.

---

## D. INFRA-HANDOFFS (nicht Impl-Agent-Domäne)
- prod2-SSH-Key legen (authorized_keys-Recovery) · prod2-CPU/RAM-Test bzw. RMA (14900KS) · Artefakt-Object-Storage (MinIO post-swap 500) · texlive auf Runnern (thesis P1c) · `config.toml concurrent=2` + 8/10-Kern-cgroup auf prod1+prod2+K8s-Runner (#189) · universelle Runner-Matrix ISA×OS×{bm/docker/k8s} (#189).
- **Topologie-Lektion für Handoffs:** Diese Windows-Maschine erreicht NUR **V10 (10.0.10.x)**, nicht das Heim-LAN (192.168.178.x). Pi5/Bastion = `node7@10.0.10.207` (cluster-Key, aarch64). prod1 = `root@10.0.10.211` (cluster-Key) ✓, hat aber KEINE Privatkeys (kein Jump). prod2 = `.212`, SSH **tot**. BMC: ASUS W680 ACE **IPMI** vorhanden (SEL/Sensoren/KVM möglich, Creds in `machines/Comdare`).

---

## E. ZU PERSISTIERENDE LEKTIONEN (Memory-Schuld dieser Session)
1. **apt-Egress fehlt auf Cluster-Docker-Runnern** → CI-Builds auf **bare-metal** (prod-Toolchain), nicht Docker+apt.
2. **INTERFACE-Lib hat kein baubares Target** → über Test-Consumer bauen (`cmake --build` ALL, kein `--target <interface-lib>`).
3. **prod2-SSH grundlegend tot — auch vom Bastion** (nicht nur mein Key-Gap); Recovery nur via Konsole/IPMI.
4. **GitLab contacted_at = UTC**, lokale Zeit = UTC+2 → „stale"-Fehldeutung vermeiden.
5. **Zugriffstopologie** (V10-only von Windows; Pi5=node7@10.0.10.207; prod1 ohne Jump-Keys; prod2 BMC vorhanden).
6. **gitleaks scannt CI_PROJECT_DIR inkl. `.citools` + Submodule** → Lint-Jobs `GIT_SUBMODULE_STRATEGY: none`; `.citools` bei Bedarf allowlisten.
7. **OneDrive-Git träge** (Push-Timeouts) → Commit + Push trennen, Push ggf. nachholen.
8. (bereits notiert: Transfer=PUT, CRLF-Keys, gitleaks-generic-api-key, Runner-tag_list-list-vs-detail.)

---

## F. EMPFOHLENE REIHENFOLGE NÄCHSTE SESSION
1. **prt-art #6988 + thesis #6989 Grün bestätigen** (oder debuggen) → 4-Modul-CI-Foundation grün dokumentieren.
2. **prod2-Hardwaretest** fahren (sobald User-Zugang) → Verdikt (RMA?) → Ergebnis-Ordner Windows.
3. Memory-Lektionen (§E) persistieren + Session-Docs aufräumen.
4. **DANN** echte Projektstruktur-Verbesserung: #179-Sweep + tieferer Umbau + lint:format/static hart + test_v41-Linux-Vollbau.
5. Rest-Stufen 10-Stufen-Pipeline (sanitize/integration/chaos/deploy/canary) + prod→dev-Gate (infra-gated).
6. Intel-Seite (`pmc:intel`) reaktivieren, sobald prod2 stabil + SSH-Recovery (Infra).
7. Mess-Lauf-Architektur (separater Job + NAS-Writeback) sobald Artefakt-Storage (Infra) ok.
