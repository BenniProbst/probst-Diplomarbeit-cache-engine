# SESSION-ÜBERGABE 2026-07-19 — post-Crash-Recovery + Konsolidierung + Planer-Ketten-Frage (für Fable-5-Übernahme)

> **Zweck:** Reiche Kontextübergabe, damit ein neuer Model-/Session-Wechsel (Fable 5) den Arbeitsstrang OHNE Bruch fortsetzt.
> **Autoritativer Einstieg zuerst lesen:** dieser Handover → Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` **§26** (neuester) → **§25** → §24/§22/§21 → Register `docs/audits/20260719-konsolidierung-register-post-crash-REGISTER.md`.
> **Deadline:** 28.07.2026 (honest-100% FF0–FF4-Messwerte + Thesis-PDF).

---

## 0. GIT-ZUSTAND (alles committet + beide Remotes ref-gleich, 0 uncommitted)
- **ce** (`Code/external/comdare-cache-engine`, Submodul) HEAD = `5da2caf7`
- **super** HEAD = `3f8ae5c` — `local == origin == github` verifiziert
- Remotes: `origin` = gitlab.comdare.local (Projekt 288), `github` = github.com/BenniProbst/*. Cluster-git = **nur gitlab** (plain-text Vault, gewollt).

## 1. WAS DIESE SESSION GELANDET IST (mit SHAs, alle beide Remotes, verifiziert)
| Thema | Ergebnis | SHA |
|---|---|---|
| **#50 stale-grüner CI-Bruch** BEHOBEN | `algo_version`-Weiterleitung fehlte in **11 `Observable*`-Achsen-Hüllen** (Strategie-Klassen hatten es, Hüllen nicht) → `build_axis_variant_version_table` brach nur bei clean rebuild (`build:clang`/`analyse`, Pipeline 11166). Fix + `<iostream>` in `artifact_cache.hpp`. **Pipeline 11278 = success** (literal). Lokal g++-16 + clang-22 verifiziert. | ce `f1562636`+`5da2caf7`, super `ebf3ac5` |
| **Weg A** Storage-#51 CI-Aktivierung (inert-by-default) | Hidden-Job `.storage_cache_activation` via `!reference` in `measure:golden-320`+`measure:smoke`, Gate `COMDARE_STORAGE_CACHE==true` → byte-neutral. Driver-Code fertig (`02_messung_driver/main.cpp:625` `from_env`). | super `0b669e9` |
| **Infra-Handout** (6 Punkte) an Cluster | P1 `COMDARE_MINIO_ENDPOINT`-Semantik (URL vs mc-Alias), P2 `mc` im Runner-Image, P3 measure-drop-CI-Vars, P4 GitLab-API-500 (Variables-Endpoint), **P5 DRINGEND PAT-Rotation**, P6 V91-#72 gated. | Cluster `116a862` |
| **2 Audits + Konsolidierungs-Register (61 Einträge)** persistiert | 9-Dim (4/9 KONFORM), Ketten Planer→CEB→Tier (3/5 KONFORM), 0 hart. Register + Kritik. | super `a83e17c`, `dcebb38`(§25), `3f8ae5c`(§26) |
| **Memory** | `reference_observable_wrapper_must_forward_concept_members` neu; MEMORY.md kompaktiert 24→19.8KB (Mojibake=0, 133 Pointer erhalten, unter Read-Limit). | (memory/) |

## 2. PLANER-BAUPLAN — FERTIG (Workflow `wf_9acb53ac-0e4` completed, 7 Agenten, Dock-Muster ermittelt)
- **Persistiert:** `docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md` (Bauplan + Dock-Muster + adversariale Kritik).
- **Dock-Vertrags-Muster (rekursiv, alle 3 Schichten):** eine Dock-Grenze = (1) benanntes Vertrags-Interface (GoF Template-Method-vtable, NIE musterlos) (2) ABI-`.so`-Grenze = geladene .so + POD (NICHT das Interface selbst) (3) MAGIC/MAJOR-Gate + `host_compatible_with` (4) gerichteter Antrieb via `standard_layout`+`trivially_copyable`-POD (memcpy). Fuß CEB↔Tier BIDIREKTIONAL (`SearchAlgorithmDrive`↔`ComdareTierObserverSnapshot`); Kopf Planer↔CEB EINDIMENSIONAL (Planer steuert, kein Rückkanal → CEB schreibt Messwerte selbst).
- **Top-down-Plan:** Phase 1 Kopf (Interpreter + `ExperimentPlanDirector` + 2 ConcreteBuilder `CMakeGraphBuilder`/`CiYamlBuilder` + Template-Method + Planer-Executable + `IExperimentDock`) an `run_experiment_profile` andocken; Phase 2 CEB mit `CebSystemAxisDrive` (Spiegel `SearchAlgorithmDrive`) bestücken; Phase 3 Tier über bestehendes Dock (REUSE). Golden-neutral, INERT-by-default.
- **⚠️ KRITIK-BLOCKER (live bestätigt) — vor JEDEM Bau lösen:** Der Bauplan analysierte NUR das ce-Submodul. Im **super-Repo** existiert schon ein Planer-Skelett `Code/02_messung_driver/v32_messreihe_antrieb.hpp` (`execute_messreihe` + `PhaseStrategyFor<MergeStrategy>` INC-E + `PhaseCompositions<S>` Policy-Based), selbst betitelt „der EINE offizielle XML-Weg" — heute **return-0-Stub/INERT** (opt-in `main.cpp:339`), Live-Pfad = `run_experiment_profile_facade` (`main.cpp:679`). ⇒ **PHASE 0: super-Repo reconcilen** (execute_messreihe füllen/wiederverwenden) STATT neuen Director daneben (das wäre der v32-Parallelstruktur-Fehler, `feedback_vor_aufgaben_erst_projektstruktur_analyse`). Zweiter Builder-Main `apps/cache_engine_builder→ExperimentDriver→CodegenEngine` = Legacy/quarantäniert.
- **GO-FORKS (Klartext vorlegen, NIE AskUserQuestion):** A Planer↔CEB als echtes dlopen-`.so` vs In-Prozess-Vertragsform (deferred .so) · B welche 2 ConcreteBuilder (CMakeGraph+CiYaml; `--dump-plan` als 3. trivialer PlanTextBuilder?) · C Schnittlinie vor/nach 28.07 (Vorschlag: vor = Phase-1-I1 Skelett + Phase-2-Wiring golden-neutral; nach = CI-Emitter/.so-Grenze/V42) · D `ceb_contract_version`-Minor-Bump? (vermutl. nein) · E XML-Pfad-Vereinheitlichung (Experiment- vs Thesis-Profil — berührt golden → GO).
- **Fable-5-Aktion:** dem User Bauplan + Dock-Muster + **Phase-0-v32-Blocker** + GO-Forks vorlegen. **NICHT bauen ohne explizite Phasen-Freigabe.** Vor Bau: ultracode-Projektstruktur-Analyse `02_messung_driver` (v32 reconcile).

## 3. DIE KRITISCHE ARCHITEKTUR-FRAGE (User-Fokus zuletzt)
**Frage:** Ist der Experiment-Planer fertig wie im Ledger (§18.1.1 rekursive Dock) beschrieben? **Antwort: NEIN.** Live verifiziert (top-down):
- **Ebene 0 Planer (Kopf) = LÜCKE:** header-only Naht `run_experiment_profile` (`experiment_run_entry.hpp`), imperative `opt×simd×Phasen`-Schleife; **kein benannter Codegen** (`ExperimentPlanDirector`/`IPlanBuilder`/`CiYamlBuilder`/`CMakeGraphBuilder` = **0 Treffer**); **kein Planer-Executable** (kein `apps/`-Aufrufer); `builder/codegen/codegen.cpp` = Alt-Phase-6.4-Stub.
- **Ebene 1 CEB = teilweise:** existiert, aber Multi-Gattungs-Dispatch hartkodiert `acquire_search_algorithm_drive` (nur SearchAlgorithm); System⊃Tier flach statt verschachtelt.
- **Ebene 2 CEB→Tier (Fuß) = REAL + test-bewiesen:** ABI-`.so`-Dock (`builder/anatomy_module_loader/anatomy_module_loader.{hpp,cpp}` dlopen `RTLD_NOW|RTLD_LOCAL`, 4 Pflicht-Symbole, Magic+Major-Gate; `builder/pruef_dock/*.hpp`; ABI-Decl `include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp` Major=6). **NICHT neu bauen — nach oben spiegeln.**
- ⇒ Register-Eintrag **E-10** (P7=P8). Top-down-Bau muss am **Planer-Kopf** ansetzen. Bauplan wird gerade erzeugt (§2).

## 4. DER KRITISCHE PFAD ZUR DEADLINE (Register-Korrektur — WICHTIG)
Der adversariale Kritiker widerlegte die Annahme „nur infra-gated": **#49 golden-N ist NICHT fertig.** Nur die CRC64/Count-Fixture landete (ce `aa25c9a4`); der **golden-N-Bau (E-1 XML alle 17 Achsen + E-2 opt×simd-Verdrahtung + E-3 Referenz↔Katalog-Entkopplung + Materialisierung) ist CE-seitig UNGEBAUT**. Kritischer Pfad:
1. **golden-N-Bau (CE)** — E-1/E-2/E-3 (Materialisierung gated auf Storage/Bloat)
2. **Storage/Infra** (#56 Infra-Handout-Ausführung → #51 scharfschalten)
3. **#46 FF0–FF4-Messlauf** (mehrtägig, opt-in CI, nie pollen)
4. **#47 Thesis-PDF** (Messwerte-LaTeX, DE+EN)
Plus die **Planer-Kette** (§3) als Architektur-Fundament (top-down).

## 5. OFFEN OHNE GO ZIEHBAR (golden-neutral Quick-Wins, Register §C) — nächster Bau-Batch
Mit **REALER Build-Verifikation** (kein Stale-Green wieder!): **L2** `reflect_versions<alle 17>`-Instanziierungs-ctest (verhindert #50-Klasse-Wiederkehr — höchster Wert) · **L3** `static_assert(sizeof(ComdareTierObserverSnapshot)==1272)` `anatomy/observable_tier.hpp:145` · **L4** Slot-Zahlen-Sweep 19/18/15/11/7→17/13/9/5 (`anatomy/set_composition.hpp:59` + aktiver `static_assert tests/unit/test_d9_set.cpp:38` kSetCompositionSlotCount 15→13) · **V6/P3** loader `host_compatible_with` `builder/anatomy_module_loader/anatomy_module_loader.cpp:138` · **V7/P4** `all_axes_binary_count`→`all_axes_matrix_count` `builder/experiment_tree/registry_to_axis_levels.hpp:147` · **V3/G4** `scripts/copy_results_to_nas.sh` DEPRECATED-Marker · **V4/G9** `CMakeLists.txt:550` Python-Kommentar · **V5/G10** 4 Root-Python-Skripte DEPRECATED · **E-6** n/a-Renderer `cache_engine_builder_iterator.hpp:382-388`.

## 6. BRAUCHT USER-GO / ENTSCHEIDUNG (Register §D — als Klartext vorlegen, NIE AskUserQuestion)
- **O-1:** `rm tier150_measurements.csv` + `adapter_measurements.csv` — **KONFLIKT mit „Messdaten nie löschen"**; git-Reversibilität reicht laut Direktive nicht → GO zwingend.
- **E-2:** opt-f/opt-g bauen ist **nicht golden-neutral** → triggert O3-golden-Rebuild + mehrtägigen Mess-Lauf → Rebuild-Fenster-Timing.
- **O-3:** welche opt-Stufen ins Mess-golden (O2/O3; Ofast bricht 1-Thread-Determinismus).
- **O-7/O-8:** Storage-Policy — measure-drop ersetzt/ergänzt Git-Writeback? Alte ABI-Binaries retain/evict?
- **Planer-Forks** (kommen aus §2-Bauplan): Planer als echtes `.so` vs header-only-Vertragsgrenze; vor/nach Deadline; welche 2 ConcreteBuilder.

## 7. WARTET AUF INFRA-AGENT (Cluster-git, Handout `116a862`)
P1 Endpoint-Semantik · P2 `mc` im Runner-Image · P3 measure-drop-CI-Vars (`COMDARE_MEASUREMENT_DROP_URL`/`COMDARE_NFS_DROP_TOKEN`) · P4 API-500 · **P5 PAT-Rotation (Security, sofort)** · P6 V91-#72. Storage-#51-Scharfschaltung ist danach ein reiner Env-Var-Schritt (`COMDARE_STORAGE_CACHE=true`).

## 8. BINDENDE GUARDRAILS (Fable 5: NICHT verletzen — Arbeitsstrang-kritisch)
- **NIE rebase, IMMER merge** (vor jedem Push `fetch` + `merge --no-edit origin/development`).
- **PAT NIE ausgeben:** extrahieren via `grep -oE 'glpat-[A-Za-z0-9._-]{15,}' "$VAULT" | head -1` in `$PAT`, **nie echoen**. ⚠️ **Der Shell-Bug `${PAT:-NEIN}` gibt bei gesetztem PAT den WERT aus** — hat diese Session den PAT ins Transkript geleakt → P5-Rotation offen. Für „gesetzt?"-Checks NUR `${#PAT}`/`${PAT:+ja}`, nie `${PAT:-…}`.
- **„completed" erst nach CLEAN-Rebuild / CI-GRÜN** — nie nach inkrementellem Lokal-Build (das war die #50-Stale-Green-Falle). Vor ctest force-recompile.
- **Compile-time-only Hot-Path** (CRTP+Concept, keine vtable außer ABI-.so-Grenzen), kein Runtime-Switch, **kein `std::variant` für statische/Organ-Achsen**. Nur **benannte** GoF/Metaprog-Patterns.
- **Organ-Achsen bilden `binary_id`; System-Achsen (CebSystemAxis: compiler/opt/isa/simd/scheduling/load) + Mess-Achsen (SystemAxis „Blut") NIE `binary_id`** (→ `.version`/Sidecar).
- **KEINE Parallelstruktur** — am bestehenden offiziellen Pfad andocken (v32-Parallel-Engine wurde gestoppt).
- **Bau nur nach expliziter User-Freigabe je Phase**; VOR+NACH jeder Aufgabe ultracode-Planung über Ledger + Plandocs.
- **Messdaten nie löschen; Doku nie löschen (nur deprecaten); ABI darf brechen.**
- **AskUserQuestion NIE** (crasht Session) — Forks als Klartext.
- **Verifikations-Kadenz je Increment:** targeted-compile beide Compiler ODER realer Build → clang-format-22 `--dry-run --Werror`==0 → Mojibake-grep `Ã|â€`==0 → golden-Roundtrip==320 wo berührt → granularer Commit (nie `git add -A`) → beide Remotes → CI grün.
- **Session-Transkripte enthalten Live-Tokens → nie committen.** Dieser Handover ist secret-frei (nur Pfade).

## 9. PFADE / ENV (secret-frei)
- super = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`
- ce = `super/Code/external/comdare-cache-engine` (Submodul, eigenes Repo)
- Ledger = `super/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (§26 neuester Einstieg)
- Register = `super/docs/audits/20260719-konsolidierung-register-post-crash-REGISTER.md`; Audits = `super/docs/audits/20260718-*.md`; Pläne = `super/docs/plaene/20260718-*.md`
- CA = `/home/comdare/Projekte/Cluster/keys/gitlab-ca-ROOTCA-20260621.crt` · VAULT (PAT drin, nie echoen) = `/home/comdare/Projekte/Cluster/keys/CREDENTIALS-VAULT-DEV.md`
- gitlab = `gitlab.comdare.local`, Projekt 288 · Cluster = `/home/comdare/Projekte/Cluster` (nur gitlab)
- clang-format-22 = `/home/comdare/tools/cf22/usr/bin/clang-format-22` · Compiler: `g++-16`, `clang++` (22.1.8)
- ce-Standalone-Build: `cmake --preset gcc-release` (Ninja) ODER build-conf; super-Sub-Build = `build-i2`
- Storage: `minio.prod.comdare.de` → Bucket `cache-engine-tier-binaries`; measure-drop `measure-drop.comdare.local` (V60 .1-SNI); Gate `COMDARE_STORAGE_CACHE` (CE) + `COMDARE_RUN_MEASURE`/`COMDARE_PERSIST_MEASUREMENTS` (Mess-Job, opt-in)
- Host: **prod1** (10.0.10.211), Runner-Host; prod2 separat (`COMDARE_PROD2_AVAILABLE`)

## 10. LEDGER-BOOKKEEPING NOCH OFFEN (Kritik-Befund, klein)
§12-FORTSCHREIBUNGS-LOG (`~Zeile 413`) hat als jüngsten Eintrag 2026-07-17 — die 07-18/19-SHAs (§26 gelistet) noch nicht im §12-Log; #49 im Board NICHT als done führen (nur Fixture); L5 (3 build-i2-Tests stale-rot B2/B4-Gap) höher tracken.

---
**Sofort-Nächstes für Fable 5:** (1) Auf Planer-Bauplan-Workflow `wv3x8ll3i` warten → Bauplan+GO-Forks vorlegen. (2) Parallel golden-neutrale Quick-Wins (§5) mit realem Build ziehbar. (3) GO-Entscheidungen (§6) sammeln. (4) Infra-Antworten (§7) abwarten für Storage-Scharfschaltung.
