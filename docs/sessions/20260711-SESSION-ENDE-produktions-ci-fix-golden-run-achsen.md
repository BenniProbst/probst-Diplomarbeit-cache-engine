# SESSION-ENDE 2026-07-11 — Produktions-Track vollzogen · golden-Lauf gestartet · CI-Fix in Arbeit · Achsen-Ontologie

> Fortsetzung von `20260711-SESSION-UEBERGABE-produktions-single-xml-path.md` (dort der volle P0–P6-Detailstand).
> Diese Übergabe = der **Session-Ende-Stand** + die **präzisen offenen Fäden** (CI-Fix, T8-Phantom, golden-Lauf).
> Alle Commits auf beide Remotes gepusht; GitFlow gewahrt (`main ⊆ development` auf ce+super).

---

## 1. DIESE SESSION VOLLZOGEN (alles CI-grün-ce + gepusht)

| Block | Commit(s) | Nachweis |
|---|---|---|
| **P0–P5** XML-Suffizienz G1/G3/G4/G5 | ce `6b384d6e`…`dd0fe177` | ctest 209/209; ce-CI 9597 grün |
| **Behelfsweg-Löschung** (37 Dateien: run_lazy_150 + 15 Orphans + 18 .ps1) | ce `e3adec03` | ctest 209/209; ce-CI 9623 grün |
| **Task #18** Coverage: Achsen-Sweep alle 19 Achsen + Gate + `m3_golden_coverage.profile.xml` | ce `e1784e26`+`fc855b20` | ctest 210/210; ce-CI 9632 grün; --validate „19 axis_sweeps, VALIDAT OK" |
| **P6** E4-XML = Default-/Alleinweg (Opt-in weg, Legacy nur via `COMDARE_LEGACY_MESSREIHEN=1`) | super `c8ec3c2`/`54ef01f` | super-Build grün; E4 läuft ohne env bewiesen |
| **g++-Linux-Vollpilot-MILESTONE** | (Lauf) | **323-Zeilen-CSV mit echten Messwerten** — Codegen→g++→dlopen→Measure E2E bewiesen (DESIGN-SPEC:83 „nie gemacht" widerlegt) |
| **golden-320-Vollmesslauf GESTARTET** | (lokal) | PID detached, `~/measurements/golden-320-run1/`, m3v2 cap=320, resume-fähig |
| Memories | — | `feedback_autonomous_measurement_via_ci_job_authorized`, `feedback_only_one_official_...`, `feedback_production_track_...` |

---

## 2. ⚠️ OFFENER FADEN A — DIPLOMARBEIT-CI-FIX (User-GO, IN ARBEIT, 2 Versuche gescheitert)

**Problem:** super-CI (probst-diplomarbeit-cache-engine, Projekt 288) failt in JEDEM Nicht-Lint-Job an `get_sources`:
`remote: HTTP Basic: Access denied` beim rekursiven Klon der 3 privaten Submodule (ce/prt-art/thesis).

**Was verifiziert ist:**
- Die inbound-`job_token_scope`-Allowlists sind KORREKT (super=288 ∈ 286/287/289) — **NICHT die Ursache.**
- Das **CI_JOB_TOKEN hat genuin keinen Cross-Projekt-Klon-Zugriff** auf die privaten Submodule (auch root-getriggert). Die Allowlist ist nicht der wirksame Gate für den git-Klon.
- Der `default.hooks.pre_get_sources_script` **läuft** (Job 252884 Trace: die `git config`-Zeile steht vor „Fetching changes"), der Haupt-Repo-Klon klappt — aber **GitLab's Auto-Submodul-Fetch ignoriert die `url.insteadOf`-Injektion** und nutzt sein eigenes CI_JOB_TOKEN → failt weiter (auch mit Deploy-Token, Pipeline 9665/`d0944875`).

**Was schon gebaut ist (bereit für den finalen Fix):**
- **Group-Deploy-Token** `gitlab+deploy-token-39` (read_repository, `comdare/research` → deckt ce/prt-art/thesis) ist erstellt.
- Als **maskierte super-CI-Variablen** gesetzt: `CE_SUBMODULE_USER` (=`gitlab+deploy-token-39`) + `CE_SUBMODULE_TOKEN` (masked).
- `.gitlab-ci.yml` hat den `default.hooks.pre_get_sources_script`-Hook (super `d094487`).

**➡️ FINALER FIX (nächster Schritt, hohe Konfidenz):** Da GitLab's Auto-Fetch die insteadOf ignoriert, den Auto-Fetch **abschalten + manuell klonen**:
1. In super `.gitlab-ci.yml` `variables:` → `GIT_SUBMODULE_STRATEGY: none` (statt recursive; überschreibt den Template-Default für alle Jobs; Lint nutzt eh none).
2. Den `pre_get_sources_script` erweitern (läuft VOR get_sources, aber der manuelle Klon muss NACH dem Haupt-Repo-Checkout laufen → besser ein globales `default:before_script`):
   ```yaml
   default:
     before_script:
       - git config --global url."https://${CE_SUBMODULE_USER}:${CE_SUBMODULE_TOKEN}@${CI_SERVER_HOST}/".insteadOf "https://${CI_SERVER_HOST}/"
       - git submodule sync --recursive
       - git submodule update --init --recursive --depth 20
   ```
   (Der manuelle `git submodule update` nutzt die insteadOf-Credential = Deploy-Token → authentifiziert. GitLab's Auto-Fetch ist via `none` deaktiviert, bricht get_sources also nicht mehr ab.)
3. Prüfen, ob das Template ein `default:before_script` definiert (Merge-Konflikt) — ggf. per-Job statt global.
4. Commit+push, `verify:submodules` grün verifizieren (get_sources muss „cache-engine OK/prt-art OK/thesis OK" zeigen).
5. **Danach ist der Mess-CI-Job triggerbar** (Track A, s.u.).
- **Aufräumen falls anders gelöst:** das Deploy-Token 39 + die 2 CI-Vars ggf. entfernen; das Token ist read-only + revoke-bar.
- Alt-Diagnose: Memory `reference_super_ci_cannot_fetch_new_ce_submodule_commits` (jetzt: NICHT nur fresh-fetch, sondern CI_JOB_TOKEN-Cross-Projekt-Klon generell).

**Mess-CI-Job (Track A, nach dem get_sources-Fix, ultracode-Plan `backups/20260711-measurement-ci-trigger-plan/`):**
2 inerte `rules: $COMDARE_RUN_MEASURE=="true"`-Jobs `measure:golden-320`/`measure:golden-coverage` in super `.gitlab-ci.yml`, `tags:[baremetal,amd]` (prod-baremetal-prod1, echter perf_event_open + MSR), `timeout:0`, Target `messung_driver` (NICHT `comdare-messung-driver` = **R1** latenter Bug in `analyse:thesis-data:164`). Trigger: `POST /projects/comdare%2Fresearch%2Fprobst-diplomarbeit-cache-engine/pipeline ref=main variables COMDARE_RUN_MEASURE=true`. **G3-Rest:** Mess-Artefakt-Senke (NAS/MinIO #202) — dort landet die CSV; bis dahin nur Job-Workspace.

---

## 3. ⚠️ OFFENER FADEN B — ACHSEN-ONTOLOGIE: 4 bestätigte Lücken (ultracode wf_edd5530e, 22 Agenten, adversarial)

Voll-Verifikation aller 19 Achsen: **15/19 vollständig, 4 bestätigte Lücken** (Backup `docs/sessions/backups/20260711-axis-ontology-verify/`):

- **🔴 T8 concurrency `thread_count` (HIGH, data-honesty) — BETRIFFT DEN LAUFENDEN golden-320-LAUF!** STORED-BUT-UNCONSUMED-Phantom: Setter speichert (`axis_08_concurrency_observable.hpp:82-84`), Getter (`:85-87`) hat NULL Aufrufer, acquire/release konsumieren nicht, aber `abi_adapter.hpp:240` zählt es fälschlich als „applied". Der m3v2-Lauf variiert `thread_count 1/2/4` → **3× Phantom-Zeilen** (identisch). = der #221-Rest (war reverted wg. 8 Defekten). **Fix (B, ehrlich):** thread_count label-only + aus apply1's applied-Zähler raus (wie hw_prefetcher-MSR-Ausnahme) → im m3v2-Profil `<thread_count>1</thread_count>` (honest-0). **Fix (A, ziel-treu):** real konsumieren wie batch_size (`abi_adapter.hpp:1054`). Bis dahin ist die thread_count-Dimension des Laufs Phantom.
- **🔴 T2 mapping (HIGH):** nur strukturelle Prädikate, keine Mess-Objective; MP03 PermutationIndexed (kpermuter existiert in T0!) + MP04 HashedOffset fehlen. Golden-320 pinnt mapping (nicht varied) → kein Lauf-Blocker, aber höchstes „misst-am-Ziel-vorbei"-Risiko. Fix: 2 Registry-Strategy-Werte + per-Auflösung-`*_scan`-Op.
- **🟡 T16 filter (MEDIUM):** Primär-Objective (bits/key@FPR) über die 4 Werte nicht vergleichbar; bits_per_key()/FPR nur im getrennten composable/-Subsystem, nicht verdrahtet. Golden pinnt filter → kein Lauf-Blocker.
- **🟢 T5 memory_layout (LOW):** toter `stride_pattern_tag` (0 Referenzen) + IMC-Heuristik doku-only. Kosmetisch.

**Konsequenz für den golden-320-LAUF:** Er läuft lokal, aber die **runtime_dynamic-Dimensionen sind lokal Phantom**: `thread_count` (T8, überall unkonsumiert) UND `hw_prefetcher` (MSR 0x1A4 = nur Cluster, lokal nicht wirksam). → **Der lokale Lauf ist Pipeline-Validierung (Milestone erfüllt), NICHT die finale wissenschaftliche Datenbasis.** Der scharfe Lauf gehört auf den **Cluster via CI** (echter MSR + perf_event_open) NACH dem CI-Fix + T8-Ehrlich-Machung. Empfehlung: den lokalen Lauf als Pilot behalten/beenden; m3v2 vor dem scharfen Lauf T8-honest-0 setzen (`<thread_count>1</thread_count>`; berührt binary_id NICHT, is_static=false).

---

## 4. OFFENE TODO-LISTE (Stack, chronologisch)

1. **CI-Fix finalisieren** (Faden A §2): `GIT_SUBMODULE_STRATEGY: none` + manueller `git submodule update` mit Deploy-Token in `default:before_script` → `verify:submodules` grün.
2. **T8 honest-machen** (Faden B): m3v2 `<thread_count>1</thread_count>` + `abi_adapter.hpp:240` apply1 thread_count nicht als applied zählen (Fix B) — ODER voll wiren (Fix A, riskanter). Golden-Round-Trip 320 bleibt (is_static=false).
3. **Mess-CI-Job Track A** committen (nach §1-Fix) + `POST pipeline COMDARE_RUN_MEASURE=true` → scharfer Cluster-Lauf (echter MSR/PMC).
4. **golden-320-Vollmesslauf** auf dem Cluster (mehrtägig, nicht pollen) → dann #156-DATA-gated: **#11 Messkurven-Typsystem WURZEL** (jetzt echter Konsument).
5. **P6-Rest:** V38.B/C-Legacy-Microbench gaten + Legacy-Vollentfernung NACH Subsumtions-Bestätigung im Voll-Lauf.
6. **T2/T16 Achsen-Lücken** (Faden B) für den **Coverage-Lauf** (der sweept sie) — vor dem Coverage-Messlauf.
7. **Design-gated #5/#8/#9** (Mess-Signal-Routing/NUMA) — nach ersten echten Mess-Daten fundiert entscheidbar. **NICHT den Mess-Code ändern, solange ein Lauf ihn nutzt.**
8. GitFlow: `development → main`-Promotion bleibt User-/Release-Gate (nicht autonom).

---

## 5. LAUFENDE HINTERGRUND-PROZESSE (Session-Ende-Zustand)
- **golden-320-Lauf** (lokal, PID war 2218234): baut/misst die 320 Binaries, `~/measurements/golden-320-run1/e4_xml/measurements.csv`. Detached (setsid) — überlebt die Session. **Phantom-limitiert (s. §3)** → als Pilot werten.
- Keine weiteren Monitore aktiv.

---

## 6. DIREKTIVEN-STAND / MEMORIES
Alle geladen. Neu diese Session: autonomes Messen via CI-Job freigegeben; „alle übrigen Punkte autonom"; „Diplomarbeit-CI autonom fixen". Kadenz unverändert (ce-CI grün vor nächster Aufgabe; granular committen; beide Remotes; nie Token committen — Deploy-Token 39 ist nur als maskierte CI-Var, nicht im Code).
