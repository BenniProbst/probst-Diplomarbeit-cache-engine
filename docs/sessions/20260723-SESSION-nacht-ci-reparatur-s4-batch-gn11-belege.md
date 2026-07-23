# SESSION 22./23.07.2026 (Nacht) — CI-Reparatur, S1-S4 Batch-Emission komplett, GN-11-Belege

> Manager-Session (Fable, Hauptstrang). Zeitraum ~21:00-07:00. Enthaelt einen prod1-SYSTEMABSTURZ
> (~22:50, alle Agenten/Monitore/Task-Board verloren, VERLUSTFREI wiederaufgesetzt) und eine
> autonome GitLab-SERVER-Reparatur (User-Freigabe ~22:00 "CI reparieren, eingreifen bis Jobs
> wieder korrekt angenommen werden").

## 1. HARTE STAENDE (Ende der Nacht, alle dual gepusht, Divergenzen 0/0 manuell geklaert)
- **ce** development: `9df09f14` (S4) < `7d9b4b55` (S3) < `091aca87` (S1) < 5aaee411 (K7b, Vortag)
- **super** development: `c706f3e` (S4-Gitlink) < `5258f08` (S3) < `ff45502` (S2) < `cf616d2`/`f97d2fe`
  (Ledger-Ebenen-Korrekturen) < `43e6978`/`23e0e16` (S1+docs) < `21364bb` (board-verify) < ff71c5a
- CI-Belege: Vollwellen **12516** (S1-S3) und **12591** (S4) je HART GRUEN inkl. ce-Bridge
  (12561 bzw. 12592). 12591 entstand als AUTOMATISCHE Push-Pipeline = Dauerbeweis der CI-Reparatur.
- main: NICHT angefasst. SCRUB-BEFUND: origin/main UND github/main wurden vom PAT-Scrub auf
  `91897d4a` rewritten (Scrub-Welle 12272 lief die ganze Nacht) — vor dev→main-Merge beide sichten.

## 2. GITLAB-CI-REPARATUR (Server-Eingriff, autonome User-Freigabe)
**Symptom:** Seit Scrub-Push 16:24 erzeugten Push-Events KEINE Pipelines mehr; API-erzeugte
Pipeline 12344 hing in `created` (Jobs nie dispatched); Sidekiq wirkte gesund (busy 0, backlog 0).
**Diagnose-Weg:** API-Sidekiq-Metriken → K8s-Zugang via pve1 (ssh cluster-Key → kubectl, GitLab
laeuft im dev-K8s ns `gitlab`, Helm-Chart) → Redis-Inspektion → Rails-Konsole (toolbox).
**WURZELURSACHEN (2 Ebenen):**
1. Sidekiq-**ConcurrencyLimit**-Deferred-Queues (`sidekiq:concurrency_limit:throttled_jobs:{...}`)
   katastrophal verstopft: `ci/unlock_pipelines_in_queue_worker` **6.441.925** + `ci/delete_objects`
   351.489 + `ci/destroy_old_pipelines` 13.231 — ALLE drei = identische ARGUMENTLOSE Cron-Drainer
   (idempotent, DB-getriebener Nachschub). Dahinter verhungerten die echten Events:
   `create_pipeline_worker` 125 (ALLE Push-Pipelines seit 16:24), `ci/initial_pipeline_process` 8
   (u.a. 12344), build_finished 105k / build_queue 102k (echte Build-IDs).
   Kaskaden-Design: solange eine Worker-Liste nicht leer ist, wird JEDER neue Job deferred.
2. **Der `ConcurrencyLimit::ResumeWorker`-CRON WAR NICHT REGISTRIERT** (Sidekiq::Cron leer) —
   es gab KEINEN Rueckweg; jede Lastspitze (hier der Scrub) frisst sich permanent fest.
**EINGRIFFE (chronologisch, alle via offizielle Wege):**
- UNLINK der 3 Cron-Drainer-Listen (gefahrlos: no-arg, Cron/DB erzeugt nach).
- Cron `sidekiq_concurrency_limit_resume_worker` (*/1min, Klasse ConcurrencyLimit::ResumeWorker)
  via gitlab-rails registriert + Sofort-Tick. ACHTUNG: liegt nur in Redis — nach GitLab-Pod-Restart
  pruefen; NACHHALTIGER Fix gehoert in Helm-Values/gitlab.yml cron_jobs (Infra-Merkposten: WARUM
  fehlte er? Chart-/Versions-Luecke).
- TEMPORAERE Feature-Flags `disable_sidekiq_concurrency_limit_middleware_<W>` fuer 5 Volumen-Worker
  (Ci::UnlockPipelinesInQueueWorker, Ci::BuildFinishedWorker, BuildQueueWorker,
  Ci::DeleteObjectsWorker, Ci::DestroyOldPipelinesWorker) — ZURUECKNEHMEN sobald bf/bq-Listen leer
  (Schwellen-Wache laeuft; Stand 07:00 ~bf17k/bq10k sinkend, blockwirkungsfrei).
**VERIFIKATION:** 12344 created→pending→running; Rueckstau materialisierte alle Push-Pipelines
(12491-12518); frische Pushes erzeugen wieder automatisch Wellen (12591). Toolbox-Rails-runner kann
OOM-killen (Exit 137) — Aufrufe klein halten.
**Zugangs-Notiz (Infra):** cluster-Key (Cluster/keys/cluster) funktioniert fuer pve1 root@10.0.10.201
(kubectl/K8s) und prod2 admin-management@10.0.10.212; die gestrigen Fehlschlaege auf .211/.212 waren
ein STALE-Konto, nicht der Key.

## 3. KETTE 2 — BATCH-EMISSION S1-S4 KOMPLETT (§62-B)
- **S1 Log-Flush** (ce 091aca87): ProgressHeartbeat header-only (30s zeit-gated, Sofort-erste,
  done(), thread-sicher, geflusht) in Bau- und Mess-Zelle + progress_sink zeitbasiert+flush.
- **S2 Smoke-Umfang** (super ff45502, Entscheid A): Smoke-Zweig delegiert m3v2_smoke (3 statt 18
  Paesse); golden-Pfad bleibt all_axes_golden; GN-11-Bau laeuft SEPARAT.
- **S3 Pruef-only** (ce 7d9b4b55): COMDARE_PRUEF_ONLY=true — .so laden + NUR run_conformance_gate
  ueber das Fenster, kein Neubau/keine Messung, exit!=0 bei Gate-Fail.
- **S4 Batch-Emission** (ce 9df09f14): TierCiYamlBuilder+TierCmakeGraphBuilder von O(Perms x Chunks)
  auf O(Maschinen): je CEB (end_measurement_combo — bewusste, genehmigte Abweichung vom Bauplan-
  end_plan: CEB==Mess-Combo, N>1-Combos nie vermischen) und je Maschine EIN tier:build-batch:<host>
  (interne Perm-Schleife x kGnBatchSlice=4096-Fenster, PRUEF-Schritt je Perm, K-Budget
  COMDARE_BUILD_PARALLEL amd=24/intel=16) + EIN measure:<combo>:batch:<host>. Testat-Grammatik
  EBENEN-RICHTIG (User-Korrekturen 22.07. abends, Ledger §62-B-NACHTRAG): Kopf einmal [a,b,c]+lane;
  Bau/Pruef je Schritt [d,e,f][g,h,i] (ZWEI Klammern); nur Mess drei Klammern; System/Organ-Layer
  NIE verschmolzen — auch nicht in der CEB-Laufzeit (aeussere Perm-Schleife / inneres Organ-Fenster).
  resource_group ceb-measure-<host> Literal-Reuse (P4), timeout 7d, Leere-Lane-Regel, Trace-Hygiene
  (Detail in Log-Artefakte, expire 4 weeks), 49 Planner-Tests (44 umgebaut, 5 neu).
  Design-Herkunft: ultracode-Judge-Panel (3 Entwuerfe x 3 Judges; Sieger minimal-Linse; Rohdaten
  docs/sessions/backups/20260722-ultracode-s4-batch-design-*.json).
- Test-Abdeckung: 297/297 im frischen Ninja-Dir + die 4 fixture-gebundenen Tests (f15_compare_cli_smoke,
  test_184, test_25_kanon, test_v41_autobuilt) im etablierten build/ gruen = 301er-Abdeckung komplett.
  golden-CRC 0xF1C1F26A1232073B in JEDEM Schritt literal unveraendert.

## 4. GN-11-MESSFAEHIGKEITS-ABNAHME (§41 Teil b — LITERALE BELEGE)
- **(a) CI:** vereinter Debug-Smoke 12160/12168 (Vortag) + Vollwellen 12516/12591 = measure:smoke-
  Klasse + Gesamtkette hart gruen. ERBRACHT.
- **(b) bare-metal (prod1, 23.07. frueh, Impl-S6-P1):** Neue Kette end-to-end mit BYTE-denselben
  Env-Naehten, die die S4-Batch-Jobs emittieren: (1) BAU provision-only m3v2_smoke Fenster 0:2 →
  8 perm.dll, S1-Heartbeat "[heartbeat] tier-build 1/2 t+4s", K7b-Stempel
  `m3v2+ext=no_extension+cxx=g++-16+opt=O3+ceb=6.0` + Organ-Fingerprint (.algos) · (2) PRUEF
  COMDARE_PRUEF_ONLY ueber dasselbe dll_dir → 8/8 Gate bestanden, kein Neubau · (3) MESSUNG
  1-Thread-Doktrin ("W6 Bau-Pool ... Messen bleibt 1-Thread") → 16 ECHTE Mess-Zeilen
  (8 Binaries x 2 Workloads), CSV mit binary_id/ns_per_op/platform=amd@prod1/build_version.
  ERBRACHT — die vormals duennste Stelle ist geschlossen.
- **Voll-Bau-Vorbedingungen ALLE geklaert:** Runner-maximum_timeout prod1/prod2 = None (kein Cap);
  Platz: prod1 72G frei / prod2 149G frei (je-Maschine-Anteil ~28GB der ~56GB-DLL-Masse passt;
  NFS/MinIO-Auslagerung = Anschluss-Thema); prod2 nproc=24 bestaetigt K-Budget-Basis.

## 5. ABSTURZ + WIEDERAUFSETZEN (~22:50)
prod1-Systemabsturz killte Session-Agenten, Monitore und das Task-Board. Wiederaufgesetzt:
Board komplett neu (25 Tasks mit aktuellen Staenden + Gate-Kanten), Impl-S6-P1 neu gespawnt
(S4-Briefing), Wachen neu bewaffnet. Working-Trees waren clean — KEIN Arbeitsverlust.
Absturz-Artefakte in der Pipeline-Historie: 12344 (lief auf prod1) failed, 12518 (redundanter
Rueckstau-Zwilling von ff455029) failed, 12505-12510 (ueberholte Zwischen-SHAs) — keine Aktion,
durch 12516/12591 ueberholt.

## 6. NAECHSTE SCHRITTE (Stand 07:00)
1. Batch-Struktur-Smoke **12623** (laeuft): erste LIVE-Emission der neuen O(Maschinen)-Struktur
   (tier:build-batch:amd/intel + measure:[all]:batch:<host>, kleiner m3v2_smoke-Umfang). Nach Gruen:
   Kette 2 COMPLETED.
2. **2^17-VOLL-BAU** (GN-11, §33-strikt): Trigger heute Mi-Vormittag (frueher als Do-Deadline):
   COMDARE_BUILD_GOLDEN_N=true, GN_TOTAL=131072 Default, MEASURE_PROFILE UNGESETZT → reine
   Bau-Batches auf beiden Maschinen (~2 Tage, Wiederaufnahme via Sidecar-Resume+Retry).
3. Sa+So 320er-Messlauf + M-4 + PDF; Mo 27.07. Abgabe. Flags-Ruecknahme nach Listen-Leerung.
