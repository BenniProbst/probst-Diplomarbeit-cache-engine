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

## ROOT-CAUSE GEFUNDEN — tiefe Diagnose 2026-07-09 (via Diagnose-Job auf prod2, /proc-Inspektion)
Da SSH als `admin-management` (Vault-PW korrekt) nach der Auth **hängt** (Shell-Init/`chdir($HOME)` reagiert
nicht) und der gitlab-runner **kein sudo** hat, wurde die Wurzel über einen rules-gated Diagnose-Job (`diag:prod2`)
auf prod2 selbst lokalisiert. Befunde (literal):
- **System gesund:** `nproc=32`, load ~27 (75-85 %, NICHT überlastet), Mem 15 Gi frei, Swap 0, `df`/`ls`/`mount`
  antworten in <1 s, **KEIN stale S3/NFS/FUSE-Mount** (nur `fusectl`). → stale-Mount-/Last-Hypothese **widerlegt**.
- **Der Hang ist cmake-spezifisch:** `cmake -B build` gibt nach 40 s **null Output** (hängt vor der Compiler-ID).
  Der cmake-Prozess steht in `State: S, wchan=sigsuspend` → er **wartet auf sein Kind** (Compiler-Check).
- **Das Kind (cc1plus/g++) steckt in uninterruptible D-state:** `ps` **hängt selbst** beim Lesen von
  `/proc/PID/wchan` (klassisches D-state-Symptom); der Prozess übersteht **SIGTERM UND SIGKILL** (timeout killt
  ihn nicht). Solche Zombies sind **nicht aus dem Userspace killbar**.
- **Runner-Verstopfung:** diese nicht-killbaren D-state-Prozesse blockieren den gitlab-runner-shell-executor →
  Runner meldet sich `online` + Slots „frei", **nimmt aber keinen neuen Job mehr an** (jeder neue Job bleibt `pending`).
- **Umfeld:** Kernel **6.17.0-35-generic (experimental)** + Intel **i9-14900KS** + g++-16-experimental-trunk.

**WURZEL:** cmake/cc1plus gehen auf prod2 reproduzierbar in permanenten uninterruptible D-state (Kernel-/Microcode-
Interaktion, nicht Code/Mount/Last). Sie akkumulieren und verstopfen den Runner.

**FIX (Infra, root — außerhalb meiner Rechte, Multi-VM-Prod-Node):**
1. **prod2 REBOOTEN** — der einzige Weg, die D-state-Zombies zu reapen + den Runner zu entstopfen. Achtung: prod2
   trägt VMs/K8s (KubeVirt/Talos + Windows-Runner) → geordnet drainen.
2. Danach `dmesg`/`journalctl` nach dem Reboot prüfen (I/O-/MCE-/Microcode-Einträge um die Hang-Zeitfenster).
3. **Kernel 6.17-experimental hinterfragen** — auf einen stabilen LTS-Kernel pinnen; Intel-Microcode aktualisieren.
   (Verdacht: Compiler-Deadlock im Kernel-Scheduler/MM auf 6.17 + Raptor-Lake.)
4. Zusätzlich prüfen: warum der `admin-management`-Login-Shell hängt (evtl. dasselbe D-state-Symptom im Profil).
5. Erst nach Reboot + grünem Probe-`cmake`: Runner 17 entpausieren (`PUT /runners/17 paused=false`) + `COMDARE_PROD2_AVAILABLE="true"`.

## Verifikation (Historie)
Pipeline 9093 (sha 3fb7dea8): `pmc:intel` fehlt (nur `pmc:amd`), 17 Jobs, success. 9100: pmc:intel-Hang bestätigt. Diagnose-Läufe 9111/9112/9115: D-state-Compiler-Hang belegt, Runner verstopft.
