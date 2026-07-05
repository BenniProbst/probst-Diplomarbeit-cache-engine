# INFRA-HANDOVER-PAKET HO-1..HO-12 (#272) — Diplomarbeit cache-engine · 2026-07-05

**An:** Infra-Team (Cluster/Runner/Storage/Netz) · **Von:** Diplomarbeit-Impl-Agent (Cluster strikt read-only — daher Handover statt Eigenversuch)
**Quellen:** Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` §8/§13, Nacht-Audit A8 (`docs/sessions/20260705-nacht-audit-ultracode-rohdaten/`), toolchain:probe super-Pipeline 8007 Job 212458 (2026-07-05, literal).
**Muster:** Je HO steht, was Infra tut und was danach impl-seitig folgt (meist: CI-Variable setzen → gegatete Jobs liegen schon im Repo → Pipeline-Verify durch Impl).

---

## HO-1 (#199/#201 k8s-deploy + smoke-canary)
Im prod-K8s Namespace `comdare-ci` anlegen + ServiceAccount mit minimalem RBAC (create/get/delete Pods+Logs nur dort) + Kubeconfig als masked File-CI-Variable im GitLab-Projekt `comdare/research/comdare-cache-engine`; Harbor-Pull-Secret in den Namespace. Danach CI-Variable `COMDARE_K8S_DEPLOY_AVAILABLE=true` setzen — die gegatete Stufe liegt dann bereits im Repo, Impl verifiziert read-only.

## HO-2 (#200 deploy-staging DB-Sync)
Read-only-Replica/Dump-Endpoint der prod-DBs (CNPG) + dev-Restore-Ziel bereitstellen; Zugangs-Creds als masked CI-Variablen (getrennt RO-prod / RW-dev). Sync-Logik (dump→dev-restore→Test-Gate) implementiert Impl als CI-Job; kein prod-Schreibzugriff nötig.

## HO-3 (#202 NAS-Writeback + Release + PDF-Artefakte)
Auf prod-Runnern NAS-Ziel bereitstellen (NFS-Mount von `backup1.comdare.de` ODER MinIO-Bucket + eigener Access-Key als CI-Variable, additiv-only) + `release-cli` installieren. Zusätzlich Artefakt-Object-Storage-500 bei großen Uploads fixen (bekannt seit Secret-Swap, REV-10-Kommentar cache-engine `.gitlab-ci.yml:5-7`) — blockiert auch Release-Artefakte.

## HO-4 (#205 thesis texlive/chktex-Gate)
texlive (inkl. latexmk + chktex) auf den baremetal-Runnern (mind. prod-amd) installieren; danach CI-Variable `COMDARE_TEXLIVE_AVAILABLE=true` setzen. Hard-Gate-Umschaltung + chktex-Job kommen von Impl per YAML-Push.

## HO-5 (#207 prod2-I/O → pmc:intel) — KRITISCH, braucht User-Go + Zeitfenster
prod2 (.212) I/O-Stall beheben (blkdeviotune-/NVMe-Wipe-Plan #134), SSH-Key-Zugang wiederherstellen, gitlab-runner auf prod2 reaktivieren mit Tags `[baremetal, intel]`; danach CI-Variable `COMDARE_PROD2_AVAILABLE=true`. `pmc:intel` ist im Repo fertig gegatet (cache-engine `.gitlab-ci.yml:75-81`), Impl verifiziert die Pipeline. Hinweis: prod2-Reset laut User frühestens Montagabend.

## HO-6 (#208 Runner-Upgrade + auto-cancel)
Alle gitlab-runner auf die neueste Version upgraden (offizielle Quelle, Neueste-Tools-Direktive); melden, wenn durch. Auto-cancel-Reaktivierung (`workflow:auto_cancel` + `interruptible`) macht Impl anschließend selbst per YAML in beiden Repos. (Stand-Notiz 05.07.: prod1-Runner meldet sich bereits als 19.1.1 — Ist-Versionen der übrigen Runner bitte prüfen.)

## HO-7 (#209 MinIO-Key-Rotation)
MinIO-SecretKey des gitlab-runner-cache-Users rotieren: ERST neuen Key (≥32 Zeichen, voll zufällig) anlegen + in allen runner-config.toml eintragen + Cache-Roundtrip verifizieren, DANN alten Key revoken (Rotation-Doktrin). Grund: Key wurde in config.toml-Diagnose sichtbar.

## HO-8 (#210 Runner-Idle-Stall)
Idle-Stall ~9 min trotz prod2-stabil; Wurzel lt. Diagnose idle Long-Poll (Workhorse/Redis Zero-Window-Backpressure), NICHT Storage. Bitte `apiCiLongPollingDuration` (Workhorse) vs. Runner-`check_interval` prüfen/abstimmen + Redis-Backpressure-Logs im Stall-Fenster ziehen; Watchdog läuft bereits. (Symptom aktuell weiter sichtbar: Stunden-Latenz bis Job-Pickup, z. B. super 8007 lint-Stufe >1,5 h pending am 05.07. abends.)

## HO-9 (#231 V111 → gitlab .1-SNI DNS-View)
OPNsense-Unbound: per-VLAN-View für V111 (K8S-PROD-CALICO) ergänzen — gitlab.comdare.de → Gateway-.1 des V111 (Split-Horizon-Muster wie bestehende Views) + FW-Pass V111→.1:443 (SNI); `unbound-checkconf` VOR Reload (Direktive). Danach Freigabe an Impl — Verifikation erfolgt als CI-Job vom prod-Runner (kein Cluster-Zugriff).

## HO-10 (#189 universelle Runner-Matrix)
Runner-Zellen der Matrix ISA×OS×{bm/docker/k8s} + KVM + macOS + ZIH registrieren; Tag-Schema bitte VOR Registrierung mit Impl abstimmen (Impl liefert die Matrix-YAML + Availability-Gates analog `COMDARE_PROD2_AVAILABLE`). Concurrency nach Halbe-Kerne-Regel (concurrent=2); Runner-Secrets in Vault, Rotation nach Doktrin.

## HO-11 (NEU, #273/T2 — gcc-15.3 auf allen Shell-Runnern) — User-Entscheid E2 vom 05.07.
**Literaler Befund toolchain:probe (prod-baremetal-prod1, super-Pipeline 8007 Job 212458, success):** `gcc-16 = 16.0.1` (Default, experimenteller Trunk r16-8100 = Quelle des csv_to_latex-ICE) · `gcc-13 = 13.3.0` · **KEIN gcc-15, KEIN gcc-14** → „WARNUNG PIN-GAP: gcc-15 NICHT installiert -> Infra-HO: gcc-15.3 bereitstellen (User-E2); Default bleibt bis dahin Trunk-16".
Bitte **gcc-15.3 (g++-15) auf allen Shell-Runnern installieren** (offizielle Quelle/PPA). Danach aktiviert Impl den vorbereiteten CC/CXX-Pin (Kette 15→14→13, lautes PIN-Echo) in ci-templates `base-pipeline.yml` — das löst zugleich den GCC-16-ICE in super `csv_to_latex` (-fmodules). Bis dahin bleibt der ICE bestehen (Impl-seitige Zwischenoption, noch nicht ausgeführt: job-lokaler g++-13-Pin nur für csv_to_latex).

## HO-12 (NEU, #273 — neuestes clang auf allen Runnern) — User-Entscheid E2 vom 05.07.
clang-Pflicht-Matrix (`.build-clang-latest`, `COMDARE_CLANG_MATRIX=1`) ist deployt. **prod1 hat clang++-22.1.8 bereits** (probe-Beleg). Bitte auf allen ÜBRIGEN Runnern das neueste clang (22.x) installieren, damit der Rollout ce→prt-art nicht an fehlendem Compiler rot wird; fehlende Hosts meldet der jeweilige toolchain:probe-Job.

## ZUSÄTZLICH: keeper-adminmgmt-PAT-Klärung (#272-Bestandteil)
GitLab-User id=21 (keeper-adminmgmt, Vault Z.277) liefert **403 „account blocked"**; funktionierender API-Zugriff läuft über keeper-root (id=20). Bitte klären: Account entsperren + PAT rotieren ODER Account bewusst stilllegen und Vault-Eintrag als stale markieren (Vault-Nachtrag). Kanonische lebende Quelle der Git-Creds war zuletzt der Windows Credential Manager der Referenz-Maschine; auf prod1 liegt der root-PAT unter `/home/comdare/keys/***CRED-NAME-REF:***CRED-NAME-REF:gitlab-pat******`.

---

**Abnahme je HO:** Infra meldet Vollzug (+ setzt ggf. die genannte CI-Variable) → Impl verifiziert per Pipeline (kein ssh/kubectl/OPNsense durch Impl). Reihenfolge-Empfehlung: HO-11 (entsperrt CI-Grün super/A4) → HO-8 (Runner-Latenz) → HO-4 (thesis-Gate) → HO-7/HO-6 → HO-5 (Fenster) → HO-1..HO-3 → HO-9/HO-10.
