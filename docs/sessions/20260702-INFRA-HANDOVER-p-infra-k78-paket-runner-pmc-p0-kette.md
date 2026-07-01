# INFRA-HANDOVER (Impl→Infra, 2026-07-02) — P-INFRA-Paket „K78": Runner/PMC/P0-Kette/Rotation

> **Von:** Implementierungs-Agent (cache-engine, #188-Strang) · **An:** Infra-Agent (via User-Pfad-Übergabe)
> **Kontext:** TODO-Neuplanung 2026-07-02 (ultracode `wf_37f3adb1`, Fable-5-Manager-Modus). Der Impl-Strang fährt
> Wellen W1–W5 (Node-Shape-Achsen → 4a → #215 EIN 320-DLL-Neubau) und danach W6 = M3-GESAMT-MESSUNG (#156/#162).
> Dieses Paket bündelt ALLE Infra-Wünsche; Prioritäten + Fenster-Regeln unten. Rückmeldungen bitte als
> Session-Doc-Pfad über den User. Ich (Impl) führe KEINE ändernden Infra-Aktionen aus; Verify-Slots übernehme ich.

## 0) Schutzregel über allem (Mess-Integrität)
Ab „#215 grün" (Meldung folgt) gilt QUELL-/UMGEBUNGS-FREEZE bis zum Ende des mehrtägigen #156-M3-Laufs:
**keine Runner-/GitLab-/Storage-Eingriffe, keine Rotationen, keine Reboots** im Mess-Fenster (Ausnahme: Notfall,
dann bitte sofortige Meldung — Lauf ist resumierbar, aber jede Störung kostet Tage). #210-Watchdog-Timer MUSS an bleiben.

## 1) 🔴 #207 — ESKALATIONS-KOPF (längster Vorlauf, hartes M3-Gate): prod2 → pmc:intel
- Ziel: prod2-I/O-Writeback-Stall beheben (staged: Kernel-Update → ggf. NVMe-Wipe + bare-metal, Blueprint
  `configs/prod1-ubuntu-inventory`; Memory `project_prod_rebuild_nvme_wipe_windows_vms`) und den `pmc:intel`-CI-Job
  wieder aktivieren. Ohne pmc:intel keine Cache-Miss-Kernmetrik im M3-Lauf (Thesis-Kern).
- **User-Go + Wartungsfenster** werden parallel über P-USER eingeholt — bitte Vorbereitung (Plan, Medien, Checkliste)
  SOFORT starten, Ausführung erst nach Go.
- Ziel-Termin: geliefert VOR W6 (M3). Alles andere in diesem Paket ist dahinter priorisierbar.

## 2) 208-rest — Runner-Versionen + auto-cancel (Teil-verifiziert, Belege unten)
- IST (API-Beleg 2026-07-02): bare-metal-Runner = 19.1.1 (Job-Trace `is_original:relock` 191797); **k8s-runner (id 1)
  = 18.9.0**; weitere k8s-Runner (ids 10-12) bitte prüfen; einige Runner `stale`/`never_contacted` (ids 2-5, 13-15, 19).
- SOLL: alle aktiven Runner ≥ 19.1.1; `auto_cancel_pending_pipelines` (Projekt 286, aktuell **"disabled"**) wieder
  auf „enabled/safe" — bitte NACH Prüfung, dass der #210-Watchdog dem nicht widerspricht.
- Stale-Runner (macintel/macarm/rpi5/visionfive/zih-socks5/prod-k8s-*): bitte Status klären (gehört zu #189-Matrix).

## 3) #210 — Runner-Idle-Stall (Wurzel bei euch)
Wurzel = gitlab-Backend Zero-Window-Backpressure / Workhorse-Redis idle Long-Poll (Paket-bewiesen 2026-06-29,
Memory `reference_gitlab_runner_210_silent_poll_stall`). Watchdog mitigiert — Timer AN lassen. Wurzel-Fix wann immer
möglich, aber NICHT im M3-Fenster.

## 4) P0-Pipeline-Kette (strikte Reihenfolge, cache-engine-CI-YAML-Anteile liefere ICH als Beifang der Impl-Wellen)
1. **#199** k8s-deploy-Stufe (Mess-/Build-Last als prod-K8s-Pod) — bitte Mess-Echtheit Pod vs. prod2/PMC mit mir
   abstimmen, bevor Mess-Jobs dorthin wandern (PMC im Pod = offene Frage).
2. **#200** deploy-staging (prod→dev read-only DB-Sync-Gate — die eine erlaubte CI-Brücke der dev/prod-Trennung).
3. **#201** smoke-canary (Loggate + canary-promote), setzt #200 voraus.
4. **#202** in 3 Teillieferungen: NAS-Writeback / schnellste-Tier-Binary-Release / PDF-Artefakt-Stufen.

## 5) #209 — MinIO gitlab-runner-cache S3-SecretKey-Rotation (Fenster-Regel!)
NUR im Leerlauf ZWISCHEN CI-Wellen (nie während W2-Fanout, W5-320-Neubau, W6/W6b-Messung). Rotations-Direktive:
erst NEU setzen + verifizieren, DANN alt revoken. Bitte Fenster mit mir über den User abstimmen (ich melde Wellen-Grenzen).

## 6) #231 — V111(K8S-PROD-CALICO) → gitlab .1-SNI
V111 in die OPNsense-unbound-access-control-Views + FW aufnehmen (Split-Horizon-Muster, Memory
`reference_dns_split_horizon_unbound_views_dot1_sni`; unbound-checkconf vor Reload!). Nach Vollzugsmeldung übernehme
ich NUR den Verify-Slot (Auflösung+Push aus V111).

## 7) #205-infra — texlive-Runner
Runner/Image mit texlive (chktex/latexmk) für das Thesis-Hard-Gate bereitstellen. Die GATE-AKTIVIERUNG selbst macht
der Text-Agent (Abstimmung Habich-Restruktur) — hier nur die Ausführungsumgebung.

## 8) 19-beschaffung — Allokator-/ZIH-Toolchain (M3-Zulieferung)
hoard/scalloc (Linux-Builds/Pakete) + jemalloc/tcmalloc-Verfügbarkeit auf den Mess-Runnern; ZIH-seitig Singularity-
Toolchain-Stand prüfen. Ziel: `COMDARE_HAVE_<X>`-Voll-Linkage für die Allokator-Achse (#19/#163) vor bzw. mit M3.

## 9) 165-ANKÜNDIGUNG (NICHT jetzt ausführen — W6-Vorstufe, M3-gebunden)
Unmittelbar vor dem #156-Lauf brauchen wir OS-Quiescing auf prod2/Runner (isolcpus/Governor performance/Dienste aus)
+ SLURM-Exklusiv-Flags (ZIH). Bitte NUR vormerken/planen; Abruf erfolgt mit der W6-Meldung.

## 10) #189 — universelle Runner-Matrix (ISA×OS×{bm/docker/k8s})
Wie im Task beschrieben; pmc:intel-Bedarf ist markiert; entsperrt die 186-X-CI-Matrix. Stale-Runner aus §2 gehören
in diese Inventur. #24 (externe Cluster-Termine) bleibt termin-/GATE-MAXIMAL-gebunden mit User-Absprache.

## Belege (literal, 2026-07-02)
- `runners/all`-API: id 1 k8s-runner online **18.9.0**; ids 6-12,16-18 online; ids 2-5,13-15 stale; id 19 never_contacted.
- `projects/286`: `"auto_cancel_pending_pipelines":"disabled"`.
- relock-Trace 191797: Runtime platform … version=**19.1.1** (bare-metal).
- Aktuelle grüne Referenz-Pipelines: 7372 (`e064c49`), 7377 (`46e6ce6`, inkl. `contract:pool_flip`).
