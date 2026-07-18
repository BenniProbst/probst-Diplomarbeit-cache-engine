---
name: feedback_ci_infra_blocked_proceed_local_double_verify_mode_a
description: "User-GO 13.07. (Modus a): wenn CI-Grün NICHT durch eigenen Fehler blockiert ist, sondern durch Infra (z.B. baremetal-Runner offline / config.toml noch .de) — dann auf LOKAL doppelt-literal verifizierten Increments fortfahren + beide Remotes pushen + Infra per Handover flaggen; CI-Grün-Verifikation zieht BATCH nach, sobald Runner zurueck. NICHT hart blockieren."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

> **AUFGEHOBEN 2026-07-17 (Abend):** Modus a galt NUR während des Infra-Blocks. Der User meldete: „prod1 und prod2 sind bezüglich gitlab runner wieder online und können verwendet werden" + „direktive zurück auf parallele CI und lokale Prüfung setzen". ⇒ Ab jetzt gilt WIEDER die volle Dual-Verifikation ([[feedback_dual_verifikation_baremetal_lokal_und_ci_synchron_gruen]]): je Increment **lokal (ce build-conf + super build-i2) UND CI-Pipeline synchron grün**, nicht batch-nachgezogen. Modus a reaktiviert sich nur, falls die Runner erneut ausfallen.

**User-Direktive 2026-07-13 (Antwort auf explizite Rueckfrage, „Frage 1: a bitte") — HISTORISCH, s. AUFGEHOBEN-Vermerk oben:**

Die DoD verlangt „CI strikt gruen bevor du fortschreitest". Wenn CI aber **nicht durch einen eigenen Fehler**, sondern durch einen **Infra-Blocker** haengt (der ausserhalb der Impl-Agent-Reichweite liegt — Cluster read-only), gilt **Modus a**:
- Jeden Increment **lokal doppelt-literal** verifizieren (frischer offizieller CMake/ctest==263, golden-Roundtrip==320 wo beruehrt, clang-format-22==0, Mojibake==0) — der schwere offizielle Weg, keine Behelfe.
- Auf **beide** Remotes pushen (gitlab.comdare.local + github).
- Den Infra-Blocker per **Handover** in `Cluster/docs/sessions` flaggen ([[feedback_diplomarbeit_impl_agent_cluster_readonly_no_infra]]); User benachrichtigt den Infra-Agenten.
- Die geforderte **CI-Gruen-Verifikation zieht BATCH nach**, sobald die Runner zurueck sind — NICHT jeden Increment hart blockieren.

**Konkreter Ausloeser (13.07.):** nach `.de→.local`-Migration ([[reference_gitlab_de_abgeschaltet_local_kanonisch_scoped_ca]]) hingen alle 4 Diplomarbeit-Pipelines `pending`, weil die Jobs `tag_list:["baremetal"]` verlangen, aber die baremetal-Runner (node5-8/pve1-2/node3-4, id 2-9) offline/stale sind und nur 2 k8s-Runner (ohne den Tag) online. = Runbook-§3.3/§6-Punkt (Runner-config.toml noch `.de`). Handover: `Cluster/docs/sessions/2026-07-13-INFRA-baremetal-runner-offline-diplomarbeit-ci-pending.md`; Pipelines #10319/#10320/#10322/#10323.

**Warum:** Ein harter CI-Block bei einem reinen Infra-Ausfall wuerde jeden Fortschritt bis zur Runner-Reparatur einfrieren; die lokale Doppel-Verifikation ist starke Evidenz, CI ist die bestaetigende Zweit-Instanz die nachzieht. Gilt NUR bei Infra-Blocker, NICHT wenn CI wegen eines eigenen Fehlers rot ist ([[feedback_verify_gitlab_pipeline_green_after_push]] bleibt sonst bindend). [[feedback_no_success_marks_without_literal_output]] weiter Pflicht.
