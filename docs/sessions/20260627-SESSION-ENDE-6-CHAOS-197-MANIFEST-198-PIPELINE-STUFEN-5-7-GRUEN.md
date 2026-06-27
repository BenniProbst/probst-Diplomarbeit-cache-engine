# SESSION-ENDE 6 (2026-06-27, Teil 4) — Pipeline-Stufen 6+7 GRÜN: chaos #197 + manifest/prebackup #198

> **Definitive Übergabe.** Knüpft an `SESSION-ENDE-5` (CI-Foundation grün #194/195/196 + EOF-Runner-Wurzel + #210-Plan) + `20260627-TODO-KONSOLIDIERUNG-ELABORAT.md` (Single-Source) an. Rolle: **Implementierungsagent der Diplomarbeit.** Diese Session = die zwei autonom baubaren Pipeline-Stufen (6 chaos, 7 manifest+prebackup) gebaut, codex-geprüft, auf dem prod-Runner GRÜN verifiziert, beide Remotes synchron.

---

## 0. STATUS-SCHNAPPSCHUSS (2026-06-27 ~19:42 UTC)
**Git-HEADs (gepusht GitLab + GitHub):**
- cache-engine (286) **`ef6ecd6`** (#197 chaos:drift) — davor 07220a2
- super (288) **`88e6b38`** (#198 manifest+prebackup + cache-engine-Submodul-Bump auf ef6ecd6) — davor 315dfd0
- ci-templates (269) `5ddfd4a` · prt-art (287) `f98445e` · thesis (289) `a97f9c7` (unverändert)
- **Runner prod1 (16): 19.1.1 + request_concurrency=4 + EOF-Watchdog AKTIV (diese Session live ausgelöst, s. §3).** prod2 (17) pausiert.

**GRÜN verifiziert (literal, wörtliche Pipeline-Ausgabe):**
- **#197 chaos:drift** = success (cache-engine-Pipeline **7041**: chaos:drift + contract:durability + contract + sanitize:asan-ubsan + pmc:amd + lint:secrets alle success; lint format/static = manual wie vorgesehen).
- **#198 manifest:provenance + prebackup:measurements** = success (Super-Pipeline **7042** = **success gesamt**; alle 3 orchestrate-Bridges success; + integration:smoke/analyse/verify:submodules/lint:secrets success).

## 1. MISSION
User-Steuerung (nach Kontext-Kompaktierung): „fahre mit der Arbeit der letzten Session autonom fort, ich sichere ab und schaue zu." + bestätigte Nächste-Session-Priorität „HAProxy-Fix #210 + Stufen #197/#198". Arbeitsteilung: **#210 (OPNsense-HAProxy-EOF-Fix) macht der USER selbst** (kritische Firewall); **#197 + #198 = mein autonomer Strang.** Verifikation NUR auf der Pipeline (Laptop zu langsam). Codex-Gegenreview vor „done" (nur Code-Repos).

## 2. WAS GEBAUT + GRÜN WURDE (elaborat)

### #197 chaos — Mess-Drift-Detektor + Rerun-Gate (Pipeline-Stufe 6, cache-engine-Modul)
- **`libs/cache_engine/builder/commands/drift_detector.hpp`** (NEU): `assess_drift(span<int64> samples, threshold=0.05)` → `relative_drift = (max−min)/median` mit `median = stats::percentile_ns(s,0.5)` — **aufgesetzt auf die Single-Source-Statistik `latency_stats.hpp`** (Nearest-Rank-Perzentil), KEINE Duplikation, KEIN synthetischer Puffer. Crash-frei an den Rändern (leer/1-Sample/median≤0 → drift 0, kein Div-by-0); `unstable = drift > threshold` (strikt). `run_with_drift_gate(measure_one, reps=3, threshold, max_reruns=3, ostream*, label)`: erhebt N Wiederholungen; instabil → ganze Gruppe bis max_reruns neu + Warn-Log je Rerun; erschöpft → advisory die stabilste Gruppe (Selbstheilung statt stiller Korruption, kein Abbruch/throw); `reps==0`-Guard (ehrlich „nicht gemessen", nicht „stabil").
- **`tests/unit/test_chaos_drift_gate.cpp`** (NEU) + CMake-Reg (header-only, Include-Root `libs/cache_engine` wie #195): deterministischer Mechanismus-Test (Klassifikation stabil/instabil, striktes >, Selbstheilung mit Warn-Log, Erschöpfung-advisory, reps==0, nullptr-warn, Null-Median-Guard).
- **`.gitlab-ci.yml`**: stage `chaos` + Job `chaos:drift` (extends `.bare_metal`, needs lint:secrets, eigener build-chaos, kein Artefakt) → verifiziert den MECHANISMUS hart.
- **Scope/Folgeschritt (gegatet):** die ANWENDUNG auf reale PMC-Messungen + die Schwellen-**Kalibrierung** = **#156-gegatet** (mehrtägiger Voll-Lauf). Codex-Empfehlung als Folgeschritt notiert: **dünner `perm_runner`-Adapter**, der echte 2-Phasen-Proben in `run_with_drift_gate` füttert und `stable/exhausted` ins **Quality-Flag #165** überträgt.
- Codex-Gegenreview (gpt-5.5/xhigh, read-only): keine BLOCKER/MAJOR; alle Test-Erwartungen rechnerisch bestätigt; 3 NITs umgesetzt (`<span>`-Include, reps==0-Guard, reps==0-Test).

### #198 manifest+prebackup — Build-/Mess-Manifest + additives Prebackup (Pipeline-Stufe 7, Super-Root)
- **`manifest:provenance`** (stage `manifest`, needs verify:submodules): sammelt in EIN Artefakt `manifest_out/build_manifest.txt`: super-SHA + Commit-SHAs **ALLER** Submodule (`git submodule status --recursive`, Prefix-Strip) + Toolchain (cmake/Compiler/ninja) + OS/ISA (uname/os-release/cpu_model/cpu_flags_sha256) + **Profil-Hash** (kombinierter sha256 aller cache-engine-`*.xml`). Cross-cutting → bewusst am Super-Root (sieht alle Submodule).
- **`prebackup:measurements`**: Shell-`prebackup()` = **additiv + sha256-verifiziert, NIE überschreiben** (Direktive „Messdaten nie löschen"): rc=0 idempotent (gleicher Hash), rc=3 Overwrite-Schutz (abweichender Hash → abgelehnt), rc=1 Kopier-Fehler. Selbsttest beweist: 2 Versionen additiv erhalten + Idempotenz + Overwrite-Schutz greift (rc=3). Beleg = versioniertes Artefakt.
- **Scope/gegatet:** reales Storage-Ziel (**NAS/MinIO-Writeback**) = **#202-gegatet** → hier Mechanismus-Beleg als CI-Artefakt.
- Codex-Gegenreview: keine BLOCKER/MAJOR (YAML gültig, `set -euo pipefail`/`if prebackup` korrekt); 3 NITs umgesetzt (submodule-SHA-Prefix-Strip, cpu_flags Einzelwert statt Doppelzeile, Overwrite-Test rc=3-präzise).

## 3. ⭐ LIVE-BELEG für #210 (EOF-Stall → Watchdog-Selbstheilung)
Während Super-Pipeline 7042 hing sie ~7 min komplett `pending` (kein Job gestartet, Bridges `created`), obwohl Runner 16 `online` + idle war (cache-engine 7041 seit 19:20Z fertig). API-Befund: `contacted_at` sprang nach exakt ~10 min Stille auf **19:30:20Z**, und 7042 ging um **21:30:20 (CEST) = 19:30:20Z** pending→running. = **der EOF-Watchdog hat um ~19:30Z neugestartet** (Schwelle „keine erfolgreiche GitLab-Comm in 8 min", letzte Erfolgs-Comm 19:20Z). **Self-Healing griff ohne manuellen Eingriff** → 7042 lief durch bis success. **Bestätigt: der Watchdog mildert zuverlässig; der ECHTE Fix bleibt #210 (OPNsense-HAProxy `timeout server`/`timeout tunnel` ≥120s) — USER-Strang.** Ich habe Runner/Firewall NICHT angefasst.

## 4. 10-STUFEN-PIPELINE — Stand nach dieser Session
| Stufe | Status |
|---|---|
| 1 lint (secrets HART; format/static manual) | ✅ |
| 2 build (prod1/AMD) | ✅ (Intel/ISA-Matrix offen, infra) |
| 3 sanitize (ASan/UBSan advisory) | ✅ (→#204 HART) |
| 4 contract (ABI + durability #195) | ✅ |
| 5 integration (#196 E2E-Smoke) | ✅ |
| **6 chaos (#197 Drift-Rerun-Gate)** | ✅ **NEU** |
| **7 manifest+prebackup (#198)** | ✅ **NEU** |
| 8 k8s-deploy (#199) · 9 deploy-staging/prod→dev-Gate (#200) · 10 smoke-canary (#201) · NAS-Writeback+Binary-Release+PDF (#202) | ⬜ **INFRA-GEGATET** |
| super-Orchestrierung (#194) | ✅ (7042 = success, 3 Bridges grün) |

**→ ALLE autonom (ohne Infra) baubaren P0-Pipeline-Stufen sind jetzt grün (#194–#198).** Die verbleibenden P0-Stufen #199–#202 brauchen ein K8s-Deploy-Ziel (KubeVirt/Talos) + MinIO/NAS-Writeback → **Infra-Handoff/User-Go (#189)**.

## 5. FALLSTRICKE (diese Session neu)
- ⭐ **GitLab `?sha=<X>` braucht die VOLLE 40-Zeichen-SHA** — Kurz-SHA liefert STILL leer (kein Fehler). Robuster Poll: erst Pipeline-ID holen, dann per ID pollen. (Memory `reference_pipeline_stage_build_verify_pattern`.)
- ⭐ **EOF-Stall tritt weiter live auf** (super 7042 ~7 min pending) → Watchdog heilt in ~8–10 min; #210 ist der Heiler.
- ⭐ **Orchestrierungs-Backlog:** super-Push = super + 3 Downstream × concurrency=2 + auto-cancel-aus → langsam (7042 ~18 min gesamt). (auto-cancel safe wieder AN = #208.)
- **Super (288) = Code-Repo-Konvention** (Commits MIT Co-Authored-By; verifiziert an den letzten 5 Commits). Thesis-Text-Repo (289) bleibt OHNE.

## 6. TODOs / NÄCHSTER SCHRITT (Single-Source: TODO-KONSOLIDIERUNG + Tasks #194–210)
**Heavy decision (User):** Die autonom baubaren Pipeline-Stufen sind erschöpft. Weiter geht es nur über EINEN von:
1. **Infra-Go für #199–#202** (K8s-Deploy-Ziel + MinIO/NAS) — dann baue ich die restlichen 3+ Stufen. Braucht #189-Infra-Handoff.
2. **Pivot auf #193 (manuelle Bedienbarkeit, TOP-PRIO)** — USAGE-CLI-Fix, ExperimentDriver-SOTA-Pfad, EXPERIMENT_MODE-Preset, echter Hand-Lauf-Verifikation (auf schnellem Runner). User-Self-Test rangiert hoch.
3. **#179 codex-pro-Datei-Sweep** (alle 4 Projekte, Wartbarkeit/Auskommentierung) — groß, mehr-Session, autonom.
4. **#206 Web-Recherche Pipeline-Gates je Eigenschaft** — speist #203/#204-Härtung.
- #210 HAProxy (USER) · #209 MinIO-SecretKey + 2 ***REDACTED***-Tokens rotieren · #207 prod2-I/O-Fix · #156/#162 Mess-Voll-Lauf.

## 7. DIREKTIVEN (bekräftigt)
Verifikation NUR auf der Pipeline · Codex-Review vor „done" (Code-Repos, NIE Cluster/keys) · Push GitLab(oauth2:glpat)+GitHub(x-access-token:github_pat), CA `keys/gitlab-ca-ROOTCA-20260621.crt`, lebenden PAT = Vault root-Keeper · Token in Ausgabe IMMER maskieren · Messdaten nie löschen · kein Erfolgsmark ohne literale Tool-Ausgabe · super-Repo Commits MIT, thesis-Text OHNE Co-Authored-By.

## 8. ZUGANG / RESUME (keine Secrets hier)
- Repos: cache-engine 286 `comdare/research/comdare-cache-engine`, super 288 `comdare/research/probst-diplomarbeit-cache-engine`, GitHub `BenniProbst/{comdare-cache-engine,probst-Diplomarbeit-cache-engine}`.
- Poll-Muster + Push-Mechanik: Memory `reference_pipeline_stage_build_verify_pattern`. Poller-Skripte: scratchpad `poll197b.sh`/`poll198.sh` (per Pipeline-ID).
- prod1 `root@10.0.10.211` (Watchdog) · opn-1 `root@10.0.10.11` (#210, USER) — beide Cluster-Key `~/.ssh/cluster`, CRLF-strip.
- Codex: `mcp__codex__codex`, Default-Modell (gpt-5.5-codex NICHT für ChatGPT-Account), `config:{model_reasoning_effort:"xhigh"}`, sandbox read-only.
