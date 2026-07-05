---
name: feedback_diplomarbeit_impl_agent_cluster_readonly_no_infra
description: Ich bin der Diplomarbeit-IMPLEMENTIERUNGSagent — Cluster NUR lesend, KEIN Infra, WireGuard verboten; Pipeline-Connectivity/Runner/Storage/texlive/prod2 = Infra-Handover, nicht meine Aufgabe
metadata:
  node_type: memory
  type: feedback
  originSessionId: 78cf67f8-571e-4fcd-a907-1556dbc5be72
---

**User 2026-07-04 (drei Klartext-Korrekturen, real-time, während ich in die Netz-Diagnose lief):**
„wireguard ist verboten" · „du machst kein infra, schreibe handover" · „du bist der Diplomarbeit
Implementierungsagent und darfst das cluster nur lesend benutzen".

**Warum:** Ich war dabei, die gitlab-Unerreichbarkeit (diese Maschine im Fremd-WLAN 10.75.47.x;
`gitlab.comdare.de`→hosts→`10.0.10.1`/V10 nicht geroutet; kein VPN aktiv) selbst über VPN/Netz lösen
zu wollen. Das ist **INFRA und NICHT meine Rolle**.

**How to apply:**
- **Rolle = Diplomarbeit-IMPLEMENTIERUNG** (Code der 4 Repos: cache-engine/prt-art/super/thesis).
- **Cluster = NUR lesend:** `git status/log/remote`, `Read`, read-only Probes ok — NIEMALS am Cluster
  mutieren (keine Konfig, keine Runner, kein Netz), NIEMALS WireGuard aktivieren/vorschlagen (**verboten**).
- **KEIN Infra:** Connectivity zu gitlab, VPN/WireGuard, Runner-Stalls (#210), Storage-500 (Artefakt-Upload),
  texlive/thesis-pdf (#205), prod2-I/O / pmc:intel-Gate (#207), lint→PFLICHT-Umschaltung-Infra (#203) =
  **Infra-Domäne → Handover schreiben** (super `docs/sessions/`), NICHT selbst anfassen.
- **Pipeline-Grün-SPLIT (wichtig):** Der **CODE-Anteil** (lint/format-Konformität + Linux-g++-Compile-
  Portabilität MEINER Änderungen) ist meiner → lokal review-/fixbar. Der **INFRA-Anteil** (gitlab
  überhaupt erreichen, Runner laufen, Storage, texlive) ist NICHT meiner → Handover.
- **Push-Realität bei Fremdnetz:** `origin` (GitHub) erreichbar; `gitlab` (self-hosted, V10) NICHT →
  gitlab-Push + CI-Verify sind connectivity-/infra-gated, nicht „done" behauptbar.

Verstärkt [[feedback_verify_gitlab_pipeline_green_after_push]], [[feedback_protect_customer_data]],
[[feedback_immer_ledger_zuerst_lesen_vor_handeln]].
