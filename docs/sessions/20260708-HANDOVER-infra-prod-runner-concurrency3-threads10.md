# HANDOVER an Infra-Agent — prod-GitLab-Runner: concurrency 3 + 10 parallele Build-Threads

**Datum:** 2026-07-08 · **Von:** Diplomarbeit-Impl-Agent (comdare@prod1, Cluster **read-only**) · **An:** Infra-Agent (`comdare-cluster-development`, cwd `C--WINDOWS-system32`)
**Grund der Übergabe:** Runner-`config.toml`-Mutation erfordert ssh/kubectl auf die prod-Runner-Hosts = hartes Cluster-read-only-TABU des Impl-Agenten + nicht meine Rolle (Infra = Handover, #272-Muster). Ausführung ausschließlich durch den Infra-Agenten.

## Auftrag (User, wörtlich, 2026-07-08)
> „Bitte stelle alle aktiven gitlab runner der produktion auf 10 parallele Threads und concurrency 3. Die vertragen das."

## Betroffene Runner (GitLab-Admin-API `/runners/all`, read-only, 2026-07-08 — `active=true`, `instance_type`, `is_shared`)
| id | description | online | Executor / Host | config-Ort |
|----|-------------|:------:|-----------------|-----------|
| 16 | `prod-baremetal-prod1` | ✅ | shell, prod1 = AMD Ryzen 9 9950X3D | `/etc/gitlab-runner/config.toml` |
| 17 | `prod-baremetal-prod2` | ✅ | shell, prod2 = Intel i9-14900KS | `/etc/gitlab-runner/config.toml` |
| 19 | `prod2-win11` (#186 Windows-OS test-tier) | ✅ | Windows-Dienst | `config.toml` (Win-Host) |
| 14 | `prod-k8s-x86-main` | ⚪ offline | Kubernetes | Helm-values / ConfigMap |
| 15 | `prod-k8s-talos-runner` | ⚪ offline | Kubernetes (Talos) | Helm-values / ConfigMap |
| 18 | `prod2-win2022` (#186 Windows-OS test-tier) | ⚪ offline | Windows-Dienst | `config.toml` (Win-Host) |

„Alle aktiven" = alle 6 (`active=true`); 16/17/19 sind aktuell online, 14/15/18 aktiviert-aber-offline (Umstellung dort für den nächsten Online-Zyklus vorbereiten).

## Sollzustand
1. **concurrency 3** = `config.toml` **global** (pro Runner-Prozess/Host): `concurrent = 3` (bisher `2`).
2. **10 parallele Threads** = Build-Parallelismus. Zwei plausible Lesarten — **empfohlen (A)**, da konsistent mit der bestehenden #189-Verdrahtung:
   - **(A, empfohlen):** CI-Variable **`CMAKE_BUILD_PARALLEL_LEVEL = 10`** (bzw. `-j10`), pro Job — auf Gruppen-Ebene `comdare` oder je prod-Projekt (286/287/288 …) setzen. Das ist der Compile-Thread-Fanout je Job.
   - **(B, Alternative):** je `[[runners]]`-Section `request_concurrency = 10` (max gleichzeitige Job-Requests) bzw. `limit = 10`.
   Wahrscheinlich gemeint: **concurrent=3 (3 Jobs gleichzeitig) × -j10 (10 Compile-Threads/Job)**. Bei Unklarheit A umsetzen und rückmelden.

## Konkrete Schritte je Executor
- **Baremetal (16 prod1 / 17 prod2):** in `/etc/gitlab-runner/config.toml` `concurrent = 3`; `gitlab-runner verify` → `gitlab-runner restart`. `CMAKE_BUILD_PARALLEL_LEVEL=10` als CI-Variable (Gruppe `comdare`).
- **k8s (14 / 15):** `concurrent: 3` in Helm-values/ConfigMap; `[[runners.kubernetes]]`-Ressourcen ggf. mitziehen; `kubectl rollout restart` des Runner-Deployments.
- **Windows (18 / 19):** `concurrent = 3` in der Host-`config.toml`; `gitlab-runner`-Dienst neu starten.

## Überschreibt bestehende Infra-Direktive
Bisher galt (Infra-Memory `feedback_runner_concurrency_half_cores_concurrency2` / #189): **halbe Kerne, `concurrent=2`, `-j = CMAKE_BUILD_PARALLEL_LEVEL`**. Der User-Auftrag hebt das ausdrücklich an: **`concurrent=3`, 10 Threads** („die vertragen das"). Bitte die Infra-Memory + K-Ledger entsprechend nachziehen.

## ⚠️ Verifikations-Hinweis (kein Blocker — User hat Kapazität bestätigt)
`concurrent=3 × -j10` = bis zu **30 parallele Compile-Threads pro Host** bei Voll-Last. Die aktuell dokumentierte **g++-ICE-Cold-Cache-Instabilität** (#21 / K87b, `reference_ci_runner_ice_cold_cache_instability`) ist **last-/speicherdruck-korreliert** (ICE-Segfaults in Schwer-Templates auf Cold-Builds). Nach der Umstellung daher beobachten:
- RAM je Host unter 3 parallelen Schwer-Jobs (prod1: ~157 GB frei laut K89b; prod2: nach NVMe-APST-Fix stabil).
- ICE-Rate der Umbrella-Pipelines (288→286/287) — steigt sie, `-j` drosseln **oder** die Runner-Cache-Vereinheitlichung (#21, dev-MinIO) priorisieren, die Cold-Builds vermeidet.

## Verify (Abnahme)
`gitlab-runner verify` je Host → Restart → eine Test-Pipeline (z. B. ce-push auf 286) mit Load-/RAM-Watch während 3 gleichzeitiger Jobs. Rückmeldung an den User: neue `concurrent`-Werte + gewählte Thread-Lesart (A/B) + RAM-Headroom.

---
*Erstellt read-only vom Diplomarbeit-Impl-Agent; keine Cluster-/Runner-Mutation durch den Impl-Agent. Ausführung = Infra-Agent.*
