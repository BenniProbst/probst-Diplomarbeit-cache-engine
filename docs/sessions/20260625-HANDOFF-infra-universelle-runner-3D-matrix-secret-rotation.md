# HANDOFF → Infrastruktur-Agent: universelle GitLab-Runner (3D-Matrix) + Auth + Secret-Rotation-Status

> **Von:** Implementierungs-Agent (Diplomarbeit/Code). **An:** Infrastruktur-Agent. **Datum:** 2026-06-25.
> **Anlass:** Die Diplomarbeit wird die Haupt-CI/CD-Pipeline (EPIC #186); ihre Build-/Sanitize-/Test-/Mess-
> Stufen brauchen eine **universelle Runner-Matrix**. **Bezug/Voll-Kontext:**
> `docs/sessions/20260625-CICD-PIPELINE-ARCHITEKTUR-4-MODULE-BASIS-PIPELINE-PRINZIP.md` +
> `…-USER-ANTWORTEN-13-ENTSCHEIDUNGEN-CICD-MESS-ARCHITEKTUR.md`. **Der User leitet dir dieses TODO weiter;
> bearbeite es, wenn du Zeit hast.** Keine Eile-Marke, aber es ist das **Fundament** der gesamten Pipeline.

---

## 1. ⭐ Universelle Runner-Matrix — **3-dimensional** (User-Direktive 2026-06-25)

Jede Pipeline-Stufe (build/sanitize/test/measure) muss über folgende **3 Dimensionen** laufen:

**Dimension 1 — ISA:** x86-64-AMD (Zen5/9950X3D), x86-64-Intel-Hybrid (i9-14900KS), x86-64-Sapphire-Rapids,
**AArch64**, **RISC-V**, **Power**.
**Dimension 2 — OS:** Linux, **Windows (Server 2022)**, macOS.
**Dimension 3 — Laufzeit-Umgebung (NEU):** **bare-metal**, **docker**, **k8s** — jede ISA+OS-Zelle muss
**zusätzlich** in allen drei Umgebungen laufen, **auch im Fall von K8s selbst**.

→ Zielzustand: je sinnvoller (ISA × OS × Umgebung)-Zelle ein getaggter Runner
`[<isa>, <os>, <env>]` (z. B. `[amd, linux, baremetal]`, `[amd, linux, k8s]`, `[intel, windows, docker]`).

### Konkrete Hardware-/Setup-Aufträge
1. **macOS-Runner** `node5-macintel-x86_64` (id 2) + `node6-macarm-arm64` (id 3): **physisch vorhanden, aber
   verkonfiguriert** → reaktivieren/neu konfigurieren (aktuell `stale`).
2. **Windows Server 2022** (Schlüssel vor einigen Tagen gekauft, im Vault dokumentiert): **als
   bare-metal-Ubuntu-KVM-Gäste** einrichten — Ubuntu-Host (bare metal) + Windows-Server-2022-VM via KVM —
   um die Windows-OS-Dimension wirklich abzudecken.
3. **Power + AArch64 via ZIH:** kommen über das **ZIH** (TU Dresden HPC); **zuletzt** infrastruktur-technisch
   anschließen (nach den lokalen Runnern). Bezug: ZIH-VPN via redshield, SLURM-Singularity-Pfad.
4. **stale ARM/RISC-V** (`node7-rpi5-arm64` id 4, `node8-visionfive-riscv64` id 5): reaktivieren.
5. **perf-Rechte je Runner** (wie CE-DL2 auf prod1/prod2 bereits erledigt — `perf_event_paranoid<=1` ODER
   `CAP_PERFMON`), damit die reale PMC-Messung (#156) auf jeder Plattform läuft. **Hinweis:** auf prod1
   liefert die PMC bereits reale Counter (`cache_misses_l1=4190096`, `dtlb_misses=58566`, measure:amd Job
   189916). Der Impl-Agent baut zusätzlich eine **PMC-Auto-Adaption** (#187), die sich an die je Plattform
   verfügbaren Counter anpasst — du musst nur die Rechte/Tools je Runner bereitstellen.
6. **Toolchain je Runner:** CMake/Ninja/Compiler (C++23), Sanitizer (asan/tsan/ubsan), TeX/latexmk (für die
   thesis-pdf-Stufe), Docker/K8s-Runtime je Umgebungs-Dimension. „Stets neueste Tools, offizielle Quelle."

---

## 2. GitLab-Auth-Klärung (User-Direktive A12)

- **DNS + HTTPS reicht erstmal** — der Impl-Agent pusht erfolgreich via HTTPS-OAuth (CA `gitlab-ca-ROOTCA-…`,
  System-DNS resolved `gitlab.comdare.de`). **Kein Handlungsdruck.**
- **Es wird KEINE VIP auf VLAN 10 geben.** Stattdessen ist (wenn du Zeit hast) eine **`.1`-SNI für
  `gitlab.comdare.de` auf VLAN 10** zu installieren (HAProxy-`.1`-SNI-Passthrough, konsistent mit der
  „interne Services auf Gateway-`.1`"-Direktive). Das frühere „SSH-Deploy-Key/CE-DL6b (SSH-VIP)" ist damit
  **ersetzt** → bitte CE-DL6b als „`.1`-SNI V10, keine VIP" führen.

---

## 3. ❓ FRAGE an dich: Secret-Rotations-Status (User-Direktive A13)

Aus der vorherigen Session offen (Rotations-Audit): **20 HEAD-Dateien mit Klartext-Secrets** in
`cluster_development` + das **4-fach wiederverwendete GitLab-root-PW** (`{{REDACTED:***CRED-NAME-REF:***CRED-NAME-REF:gitlab-root-pw******}}` =
admin-mgmt/CBS/built-in-admin) + DB-weit wiederverwendetes `***CRED-NAME-REF:***CRED-NAME-REF:samba-comdare-database-pw******`.

**Bitte zurückmelden:** Hast du bereits **rotiert**? **Wie weit** bist du? (Reihenfolge laut Vault-Matrix:
erst NEU setzen+verifizieren, DANN alt revoken; GitLab+GitHub-Vollzugriff dauerhaft AN mit ≥1 Voll-Admin-
Keeper; History-Scrubbing via filter-repo erst NACH Rotation+HEAD-Redaktion.) Der Impl-Agent nutzt aktuell
noch das alte root-PW für den OAuth-Push — **gib bitte Bescheid, wenn rotiert ist**, damit der Push-Recipe
nachgezogen wird.

---

## 4. Akzeptanz / Rückmeldung
- (1) Runner-Matrix-Zellen je `[isa,os,env]` online + getaggt (oder dokumentierter Plan, welche kommen wann).
- (2) Win2022-KVM + macOS-Reaktivierung + ZIH-Anschluss-Plan.
- (3) perf-Rechte/Toolchain je Runner.
- (4) `.1`-SNI V10 (wenn Zeit; DNS+HTTPS reicht bis dahin).
- (5) **Antwort auf die Secret-Rotations-Frage (§3).**
