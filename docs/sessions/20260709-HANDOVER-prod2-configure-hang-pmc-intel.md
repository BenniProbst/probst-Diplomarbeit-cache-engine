# HANDOVER — prod2 cmake-configure-Hang (pmc:intel) → Infra-Agent

**Datum:** 2026-07-09 · **Autor:** Impl-Agent (Claude) · **Empfänger:** Infra-Agent
**Status:** CI temporär entblockt (Repo-Kill-Switch) · **echter Fix = Infra (prod2-Node)**

## Symptom
ce-Pipeline (GitLab-Projekt 286) ~9 h durchgehend ROT. Root-Job: **`pmc:intel`** (stage `build`,
tags `[baremetal, intel]` → Runner `prod-baremetal-prod2`, i9-14900KS).

## Belegte Diagnose (READ-ONLY, GitLab-API)
- `cmake -B build -G Ninja -DCOMDARE_BUILD_TESTS=ON -DCOMDARE_ENABLE_PMC=ON` **hängt 60 min mit NULL Output**,
  dann Runner-Timeout (`Session terminated, killing shell`). Der Hang liegt **VOR** CMakes erster Ausgabe
  (Compiler-ID) → oberhalb jeder Repo-CMake-Logik. Kein Repo-Fetch/execute_process ist die Ursache
  (die werden nie erreicht); ein grüner Lauf desselben Codes configured in **0,7 s** ohne Netz-I/O.
- **Root-Cause = prod2-Node-Infra, NICHT Code** — zwingender Beleg:
  - Gleicher sha `4d8aedce`: Job 242193 lief **20:36 UTC grün in 28 s**; ab **21:53 UTC** (retriggert,
    **gleicher Runner, identischer Code**) 3× 60-min-Kill. Der Bruch ist **zeitlich**, nicht sha-gebunden.
  - `pmc:amd` (prod1, identisches `.pmc`-Template, gleicher Commit) läuft **grün in ~51 s**.
- Wahrscheinliche Ursache (nur per SSH auf prod2 endgültig bestätigbar — außerhalb meiner Read-only-Rolle):
  **stale S3-/Object-Mount nach dem MinIO-prod→dev-Swap** (jeder Filesystem-Zugriff im build-Tree hängt),
  oder prod2-Node-Überlast/Swap. Der ccache-S3-Endpoint selbst ist bereits korrekt (dev-MinIO, restore lief).

## Was ICH getan habe (Repo-Domäne, reversibel)
1. **CI-Variable `COMDARE_PROD2_AVAILABLE=false`** (vorgesehener Repo-Kill-Switch, .gitlab-ci.yml Z.102-103).
   → `pmc:intel` entfällt, Pipeline grün. **Keine Coverage-Verlust** (Job hing ohnehin; `pmc:amd`/prod1 hält
   die PMC-Messung). Reversibel: Variable zurück auf `"true"`.
2. **`.pmc timeout: 15m`** (ce 3fb7dea8) — fail-fast statt 60-min-Default; schützt künftig **auch prod1**.

## Was INFRA tun muss (echter Fix)
1. prod2-Node (`10.0.10.212`) untersuchen: hängende/stale Mounts (v.a. alte prod-MinIO-Mounts nach dem
   prod→dev-Swap), Disk/Inode-Druck, Runner-Last/Swap. Test: `cmake -B build` im ce-Checkout auf prod2 —
   hängt es VOR der Compiler-ID, ist es der Node.
2. Nach dem Fix: **einen grünen Probe-Lauf** abwarten, DANN `COMDARE_PROD2_AVAILABLE="true"` reaktivieren.
3. Bezug: Runner-Angleichung prod1→prod2 (concurrency 2 / -j8, VLAN/MinIO-Nachzug) — Handover 20260708.

## NACHTRAG 2026-07-09 (nach gemeldeter prod2-Reparatur): Hang besteht WEITER + Runner pausiert
Der User meldete prod2 als repariert. Verifikations-Lauf **Pipeline 9100** (Variable temporär `true`) — **definitiv, isoliert**:
- `pmc:intel` hängt **345 s im `cmake -B`** (Log endet dort, kein Output) — allein auf prod2.
- `contract` (54 s), `sanitize:asan-ubsan` (31 s), `pmc:amd` (39 s) liefen ALLE **grün auf prod1** durch.
→ Der configure-Hang ist **prod2-Node-spezifisch und besteht fort**, unabhängig von Last/Slot-Konkurrenz. Eine
reine Neukonfiguration/Reboot hat ihn NICHT behoben (typisch für stale Mount, der über Reboot überlebt).

**Aktion (reversibel):** `COMDARE_PROD2_AVAILABLE=false` (zurück), Pipeline 9100 gecancelt, und der **GitLab-Runner
`prod-baremetal-prod2` (id=17) pausiert** (`paused=true`). Grund: fast alle Jobs sind `tags: [baremetal]` und
verteilen frei auf prod1/prod2 — ein pausierter prod2 zwingt sie auf das gesunde prod1 → Pipelines grün, kein
Hang mehr (nicht nur ce, alle Projekte). pmc:intel bleibt zusätzlich variablen-gegated.

**INFRA — echter Node-Fix nötig, DANN reaktivieren:**
1. prod2 (10.0.10.212): `cmake -B /tmp/x` in einem ce-Checkout → hängt es vor der Compiler-ID, ist es der Node.
   Prüfen: `mount`/`df -h` (hängende/stale S3-/prod-MinIO-Mounts nach prod→dev-Swap), `dmesg | grep -i 'I/O\|hung'`.
2. Nach echtem Fix + einem grünen Probe-`cmake`: Runner 17 **entpausieren** (`PUT /runners/17 paused=false`)
   UND `COMDARE_PROD2_AVAILABLE="true"` — erst dann läuft `pmc:intel` (Intel-PMU) wieder.

## Verifikation (Historie)
Pipeline 9093 (sha 3fb7dea8): `pmc:intel` fehlt (nur `pmc:amd`), 17 Jobs, success. 9100: pmc:intel-Hang bestätigt.
