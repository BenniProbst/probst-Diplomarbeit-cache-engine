---
name: reference_ci_runner_ice_cold_cache_instability
description: g++-ICE-Segfaults auf Cold-Cache-Builds = transiente Runner-Instabilitäts-Episode (Infra
metadata: 
  node_type: memory
  type: reference
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**Symptom (08.07. beobachtet, mehrfach):** Downstream-Pipelines failen mit `internal compiler error: Segmentation fault` in g++ (BEIDE g++-13 UND g++-16), gekoppelt an `Failed to extract cache` (Cold-Build), in Schwer-Template-Dateien (gtest, anatomy_perm-Module, unicode.h/system_error/type_traits). Je Lauf ICE-en ANDERE Downstreams (ce / prt-art / thesis) — reine Runner-Pool-Lotterie.

**Diagnose = transient/NICHT-Code, wenn:** (a) die **Push-Pipeline** (`source=push`) desselben Commits GRÜN ist; (b) ein **docs-only-Commit** (kann keinen Build ändern) failt trotzdem seine Umbrella; (c) je Lauf sind ANDERE Downstreams rot. Alle drei traten 08.07. auf → eindeutig Umgebung, nicht Code.

**Wurzel:** Cache-Extract-Fehlschlag → Cold-Build → g++-ICE auf den Schwer-Templates (Speicherdruck/Runner-State). Infra-Kette: **#21 (Runner-Cache-Vereinheitlichung → dev-MinIO)** + K87b-Montags-Audit + [[reference_cluster_vlan_tabelle_sni_standard_pattern]]. **NICHT meine Domäne** (Cluster read-only, Infra-Agent).

**Verschärfung (08.07., Infra-Agent-Beleg b30d122):** Die ICE ist NICHT nur Cold-Cache, sondern primär **RAM-druck-korreliert** — auf **prod2** (id 17, 62-GB-Host mit 5 VMs talos/opn-2/samba/win11/win2022, nur ~12 GB Runner-Budget) hat **earlyoom `cc1plus` schon bei niedrigerer Last gekillt**. Seit 08.07. läuft prod2 auf **`concurrent=3 × -j10` = bis 30 Compile-Threads** (User-Auftrag, Infra ausgeführt) → ICE-/OOM-Risiko auf prod2 ERHÖHT (prod1 = 157 GB frei, unkritisch). ⇒ Bei ICE-Häufung auf prod2: `-j` drosseln ODER #21 (dev-MinIO, Cold-Build-Vermeidung) priorisieren; ninja-Resume-Retry (ci-templates) fängt Einzel-ICE ab. Beobachtungs-, kein Code-Fix.

**WURZEL BEHOBEN (08.07. Impl-Agent, User-Infra-Freigabe; Cluster K89d):** Die eigentliche prod2-Haupt-Wurzel war NICHT (nur) RAM — prod2 `[runners.cache.s3]` zeigte noch aufs abgelöste `minio.prod.comdare.de` (DNS→10.0.10.1 = V10-VIP OHNE 9000-FE = toter Endpoint) → „Failed to extract cache" → Cold-Build → ICE. Fix: prod2 auf dev-MinIO nachgezogen (K87-H10-Parität: `minio.comdare.de:9000`/`buildsystem-cache`/V60-hosts-Pin `10.0.60.1`, Secret file-to-file von prod1), **Round-Trip PUT200/GET200/DELETE204 bewiesen**. Zusätzlich concurrent 3→2 (prod1+prod2) + `CMAKE_BUILD_PARALLEL_LEVEL` 10→8. Erwartung: prod2-Fehlerrate (war 36 % vs prod1 11 %) sinkt deutlich. Rest-RAM-Druck bleibt (prod2 50 GB VMs/12 GB Runner-Budget) → weiterhin `-j`-moderat + [[reference_cluster_vlan_tabelle_sni_standard_pattern]] V60→SNI→V90.

**HANDLUNGSREGEL (Kadenz-konform):** max **1× re-triggern** ([[feedback_verify_gitlab_pipeline_green_after_push]]: transient/Stall max 1×). Bei erneutem Fail = **bestätigte Episode → leave-as-history** (Ledger-Präzedenz **8775** „Status-Recalc-Anomalie belassen"). **KEIN Retry-Loop, KEIN weiterer super-Push** — denn: **jeder super-Commit (auch docs-only) triggert die VOLLE Umbrella** (trigger:cache-engine + :prt-art + :thesis → alle drei Voll-Rebuilds) und verliert in einer Instabilitäts-Episode dieselbe Lotterie. Der Code-Grün-Beweis ist die **Push-Pipeline** (source=push, kein Umbrella-Trigger) + eine grüne Umbrella eines Vorgänger-Commits. Nicht [[feedback_no_success_marks_without_literal_output]] verletzen: „Code grün" nur mit der literalen source=push-Success-Ausgabe belegen, Umbrella-Rot als Infra ausweisen.
