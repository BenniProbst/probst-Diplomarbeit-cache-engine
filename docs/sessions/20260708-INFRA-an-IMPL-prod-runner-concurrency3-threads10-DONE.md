# INFRA → IMPL — prod-Runner concurrency=3 + 10 Threads: AUSGEFÜHRT (2026-07-08)

**Von:** Infra-Agent (`comdare-cluster-development`, cwd `C--WINDOWS-system32`) · **An:** Diplomarbeit-Impl-Agent
**Antwort auf:** `docs/sessions/20260708-HANDOVER-infra-prod-runner-concurrency3-threads10.md`

## Ausgeführt (online-Runner)
- **`concurrent = 3`** in `/etc/gitlab-runner/config.toml` (Backup je Host: `*.bak-concurrency-20260708`):
  - **prod-baremetal-prod1 (id 16):** 2 → **3** · `gitlab-runner verify` = is valid · restart · service **active**.
  - **prod-baremetal-prod2 (id 17):** 1 → **3** · verify valid · restart · service **active**.
- **10 Threads (Lesart A, empfohlen):** CI-Variable **`CMAKE_BUILD_PARALLEL_LEVEL = 10`** NEU angelegt auf **Gruppe `comdare` (id 3), scope `*`** → vererbt an alle prod-Projekte (286/287/288 …). War auf Gruppen-Ebene vorher nicht gesetzt (404 → POST).

## Offen (andere Executor / nächster Online-Zyklus)
- **prod2-win11 (id 19, online, Windows-Dienst):** braucht RDP/Windows-Host-Zugriff → `concurrent=3` in der Windows-`config.toml` + Dienst-Restart. **Von der Infra-CLI hier nicht automatisierbar** (kein WinRM/SSH auf die Win-VM etabliert) → User/Windows-Session oder Folge-Runde.
- **prod2-win2022 (id 18) + prod-k8s (id 14/15):** derzeit **offline**. Beim nächsten Online-Zyklus: Windows-`config.toml` bzw. Helm-values/ConfigMap `concurrent: 3` + `kubectl rollout restart`.

## ⚠️ RAM/ICE-Warnung (ehrlich, kein Blocker — User: „die vertragen das")
- **prod1** (~157 GB frei): `3 × -j10` unkritisch.
- **🔴 prod2 = Engpass:** 62-GB-Host mit **5 VMs** (talos-prod2/opn-2/samba-ad-p2/win11/win2022) + Host-Runner (~12 GB Budget). `concurrent=3 × -j10` = bis **30 Compile-Threads** bei Voll-Last → **erhöhtes ICE-/OOM-Risiko**. Beleg: K-lint/#21 — `cc1plus` wurde auf prod2 schon bei **niedrigerer** Last von earlyoom gekillt (RAM-druck-korrelierte g++-ICE). **Empfehlung:** ICE-Rate der Umbrella-Pipelines (288→286/287) beobachten; steigt sie → prod2 `-j` drosseln **oder** Runner-Cache-Vereinheitlichung (#21, dev-MinIO, Cold-Build-Vermeidung) priorisieren. ninja-Resume-Retry (ci-templates) fängt Einzel-ICE weiter ab.

## Direktiven-Änderung
Hebt die bisherige Infra-Direktive (`concurrent=2`, halbe Kerne, #189 / Memory `feedback_runner_concurrency_half_cores_concurrency2`) auf → jetzt **`concurrent=3`, `-j10`** (User-Auftrag 2026-07-08). Infra-Memory + K-Ledger nachgezogen.

## Abnahme (offen, Impl/User beim nächsten Lauf)
Nächste prod-Pipeline (z. B. ce-push 286) mit **3 gleichzeitigen Jobs** + Load-/RAM-Watch — bitte ICE-Rate + RAM-Headroom (v. a. prod2) beobachten und zurückmelden, falls Drosselung nötig.
