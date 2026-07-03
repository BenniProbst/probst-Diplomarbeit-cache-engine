# SESSION-ENDE 22 (2026-07-03) — lint-Pflicht KOMPLETT + Runner-Fix + /goal-Parallelstrategie mit 4 Kartierungen

> **EINSTIEG NÄCHSTE SESSION:** (1) Memory `feedback_command_pattern_achsen_mess_visitor_container_in_sa`
> (⚡⚡-Block = lint-Strecke DONE; 🏁-Block = #188-4c). (2) DIESES Doc = /goal-Parallelstrategie + die 4
> teuren Kartierungen (NICHT neu machen!). (3) Masterplan `20260702-MASTERPLAN-188-4c-…-cmd-visitor.md`
> (CMD-1/CMD-2-Entscheide). (4) Vorgänger SE-21 (`3ee71c6`) + SE-21b (lint-Diagnose).

## §0 SOFORT-STATUS bei Kontext-Ende (KRITISCH — In-Flight-Arbeit)
- **Codex #216-H2 LÄUFT in einem FLÜCHTIGEN Worktree** (`…/scratchpad/worktrees/216h2`, Branch `wt-216h2`,
  Task bx2epn7kc). Beim Kontext-Ende gerade erst SessionStart, KEINE Edits → **die Arbeit ist NICHT
  gesichert und der Scratchpad-Worktree verwaist**. ⟹ **NÄCHSTE SESSION: #216-H2 aus dem Dossier §4 NEU
  starten** (das Dossier ist unten vollständig, reproduzierbar). Verwaiste Worktrees aufräumen:
  `cd <cache-engine> && git worktree prune && git branch -D wt-216h2` (falls vorhanden).
- **FALLSTRICK-LEKTION (neu):** Codex-Läufe im Scratchpad-Worktree = Verlust-Risiko. Entweder Codex IM
  Worktree committen lassen (Branch überlebt) ODER Worktree an persistenten Ort (NICHT Scratchpad) ODER
  Diff sofort nach Lauf als Patch sichern. Für die geplante Parallel-Welle: Worktrees unter einem
  persistenten Pfad anlegen (z.B. `…/Diplomarbeit - Datenbanken/.wt/`), NICHT im Session-Scratchpad.

## §1 DIESE SESSION GELEISTET
### (A) #203 lint-Pflicht KOMPLETT (alle 6 C++-Jobs auto-grün, umgeschaltet)
- **Umschaltung committet:** cache-engine `1e3b839`, prt-art `7997a0b`, super `5ff9e1f` (+CMAKE-8 `c9a317a`);
  `allow_failure`+`when:manual` RAUS bei lint:format/lint:static; andere allow_failure-Jobs unangetastet.
- **6/6 auto-grün** (Push-Pipelines 7539/7540/7541 = format+static × 3 Repos).
- **ci-templates 8 Fixes (final `4666192@development`):** std.cfg-exe-relativ (968b333), CITOOLS-Fallback
  (5ddfd4a), LLVM-SHA-Pin+`--library=googletest` (0595811), COMDARE_CPPCHECK_IGNORE_DIRS (237b6ec),
  `-DUSE_BOOST=Off` (09f3bae), -j4 (bcc690b), **g++-13+-j2+4×ninja-Resume-Retry (6709248)**, **-j2→-j8
  (4666192)**.
- **Format-Pass** clang-format 22.1.8 (offizielles win64-Asset, SHA-verifiziert im Scratchpad) alle 3
  C++-Repos (~700 Dateien) + 52 static-Findings gefixt (ODR→anon-NS/PFCompositionT7-Rename, uninit→{}-Init,
  begründete inline-Suppr, ignoredReturnValue→status.ok()).
- **thesis:** KEINE Umschaltung — `thesis:pdf` (§7-Hard-Gate, 0 LaTeX-Fehler) schon Pflicht+grün; **texlive
  TL2026 scheme-full auf prod1 UND prod2 gespiegelt** (4.6G, `tlmgr path add` Voll-Symlinks + chktex).
  chktex/lint:latex bleibt advisory (978 diskretionäre Stilwarnungen; hartes 0-Gate unrealistisch).
### (B) Runner-Korrektur (User 03.07.)
- prod1 `concurrent = 2→1` (`/etc/gitlab-runner/config.toml`, SIGHUP-reload, journal „Configuration loaded
  max_builds=1"); prod2 war schon 1. Backup `config.toml.bak-20260703-concurrent`.
- cppcheck-Build `-j8`, super `CMAKE_BUILD_PARALLEL_LEVEL 8`. RAM-Modell: ≥12G/VM, ~2 belegt → ~10 frei,
  1G/Kern → 8 Kerne sicher bei concurrent=1. Memory `feedback_runner_concurrency_half_cores_concurrency2`
  revidiert.
### (C) prod2-HW-Befund dokumentiert
- earlyoom `--prefer cc1plus` killt Compiler bei VM-RAM-Druck → nicht-determ. cc1plus-Segfaults beim
  cppcheck-from-source-Build (wechselnde Dateien, 2 Compiler). Memory `project_prod2_hardware_verdict_io_not_cpu`
  (K-lint-UPDATE). Mitigation = g++-13+-j2/-j8+Retry (im Template).

## §2 /goal-PARALLELSTRATEGIE (User 03.07.: „maximale Parallelität, disjunkte Delegation, GO für alles")
**Zwei-Spuren-Modell + Worktree-Git-Isolation.** Kern-Constraint: alles was `abi_adapter.hpp` ODER den
Mess-POD (`observable_tier.hpp` / `builder/measurement_snapshot.hpp`) berührt = **serieller god-header-
Sperrbereich** (max 1 offenes Increment, nie halb committen). Alles andere dateidisjunkt = parallel.

- **Spur S (seriell, 1 Codex-Strang, je Increment Pipeline-belegt):**
  **#216-H2 → #217 (Array-Gattung) → AP-7 (SwissTable, teilt Registry mit #217) → #221 (RC/DynamicVariableNode)
  → CMD-1 (Zwei-Wurzel-Konsolidierung) → CMD-2+AP-1 gebündelt (EIN POD-Bruch) → #234 → #215 (CoW-Schleuse)
  → #224 (Etiketten-Hygiene, ZULETZT wenn alle Namen final)** + AP-8-POD-Teil (p50/p95/p99, mit AP-1).
- **Spur P (paralleler Schwarm, je eigener Worktree/Branch, dateidisjunkt — Matrix §3 belegt):**
  AP-2 ∥ AP-3 ∥ AP-6 ∥ AP-10 ∥ AP-11 ∥ AP-13. AP-8-Vendoring-Teil (ext/+LatencyHistogram-Impl) disjunkt.
- **Git-sicher:** jeder Parallel-Lauf in eigenem Worktree/Branch von main → sequenziell konfliktfrei nach
  main mergen (dateidisjunkt) → push → EINE Sammel-Pipeline. Codex NUR editieren lassen, Integrator
  committet (Co-Authored-By-Hygiene) + reviewt adversarisch.

## §3 AP-DISJUNKTHEITS-MATRIX (Explore-Kartierung — NICHT neu machen; Pfade VERIFIZIERT korrigiert)
**SERIAL (berührt abi_adapter/POD):** #217 (`abi_adapter.hpp:1870-1890` container_algorithm_t/container_traversal_t
+ `axes/lookup/axis_03a_search_algo_registry.hpp:54,104-130`), #221 (`abi_adapter.hpp:187-204,1935` RC-apply+applied_rc_
+ `builder/experiment_tree/runtime_variable_loop.hpp:103`+`experiment_tree.hpp` DynamicVariableNode
+ `anatomy/resource_controllable_tier.hpp`), #224 (Querschnitt: `abi_adapter.hpp:1871` #224-Falle + Mess-POD + viele axes),
AP-1 (`builder/measurement_snapshot.hpp:34-63,136-157` POD+CSV + `builder/pmc_source.hpp` + linux/windows-pmc),
AP-7 (`axis_03a_search_algo_registry.hpp:52-88` AllStrategies S14=HashSearchAlgo:69 endet S21:83 → +S22; NEU `axis_03a_search_algo_swisstable.hpp`; teilt Registry mit #217 → nach #217),
AP-8-POD-Teil (T10-Schema `observable_tier.hpp:83` hat NUR events/leaf_updates/node_updates/peak_tracked — KEIN p50/p95/p99 → surfacen = POD-Bruch mit AP-1).
**PARALLEL (dateidisjunkt):**
- AP-2 (`include/cache_engine/abi/cache_engine_execution_engine_adapter.hpp:39-60,88-98` DefaultMapBackend=std::map-Surrogat
  + `builder/commands/execute_engine_command.hpp:43,58,72` Simulations-/V32-Pfad = „Stub"; real: `compositions/prt_art_reference.hpp` existiert).
  ⚠️ „90ns"-Literal NICHT lokalisiert — Surrogat = Simulation-V32-Pfad + DefaultMapBackend (std::map, nicht wörtlich unordered_map).
- AP-3 (`include/cache_engine/platform/i_platform_probe.hpp:27-33` Interface da, discover_and_measure() rein virtuell;
  Impl-Ort `include/cache_engine/platform_probe/cpuid_probe.hpp`; HardwareFilter `builder/commands/auto_permutator.hpp`).
- AP-6 (**`libs/cache_engine/algorithm_profiles/sota/` 30→33 + `/allocators/` 10→23** — echte Pfade! braucht fachliche Paper-(P01-P33)/Allokator-(A01-A23)-Zuordnung aus Thesis → NICHT trivial, Welle-2 mit Grundlage).
- AP-10 (`libs/common/measurement/dataset_loader/…` + example_uint64_keyfile_loader + String-Loader NEU).
- AP-11 (**`libs/cache_engine/algorithm_profiles/load_profiles/lp_*.xml` 8→14** +6; SCHEMA.md LP-ID; braucht LP09-14-Semantik).
- AP-13 (`subsystems/c02_pinning_engine/i_pinning_engine.hpp:10-29` IPinningEngine da; `concepts/numa_affinity.hpp`, `platform/core_layout.hpp`; 3-ISA=CMake/CI).
**NÄHTE:** AP-3∥AP-13 teilen `platform/`-Konzeptheader (PlatformPropertySet); AP-1/AP-2/AP-8 evtl. `builder/commands/execution_result.hpp`; CMake/CI (AP-6/AP-8/AP-13). → Merge-Reihenfolge dort koordinieren.

## §4 #216-H2-DOSSIER (konvergent Explore+Codex — DIREKT reproduzierbar, god-header)
**Problem:** `run_workload_perm` ruft `tier_clear()` NUR vor Load (`perm_runner.hpp:261`); Load-Inserts (`:262`)
treiben Observer-Stat; Observer-Read am Run-Ende (`workload_orchestrator.hpp:155`) → `axis_stats` = LOAD+RUN.
`tier_clear()` löscht auch DATEN → ungeeignet (read/scan brauchen Daten). Doku-Widerspruch `iterator.hpp:177-185`
(„WARMUP-FREI" gilt nur run_observable_perm). **seg_ns n>1 ist BEREITS aktiv** (`abi_adapter.hpp:1275` kBatches=8).
**Fix:** (1) NEUE `void tier_reset_statistics() noexcept` in abi_adapter.hpp — extrahiere die Stat-`.reset()`-Aufrufe
aus `tier_clear()` (`:902` container_algorithm_.reset() + `:915-933` ct/map/queuing_q1/q2/telemetry/pf/cc/pc_organ_.reset())
OHNE die Daten-clears; `#if COMDARE_MEASUREMENT_ON`-gated; tier_clear() ruft sie DRY intern; deklariere im Tier-Interface
das perm_runner ohnehin hält (kein dynamic_cast). (2) `perm_runner.hpp` NACH Load-Schleife (vor PMC-begin `:268`)
`tier.tier_reset_statistics();`. (3) Stale-Kommentare `perm_runner.hpp:12,165,188,191` search_organ_→container_algorithm_.
(4) `iterator.hpp:177-185`-Doku präzisieren (gilt jetzt auch Workload-Pfad). (5) NEUER Test test_216h2_stat_reset_after_load.cpp:
Load N, reset, Run M, observe → axis_stats[0] zählt NUR M. Registrieren (CMakeLists; is_original-Liste falls Achsen-Header mit is_original).
**Constraints:** god-header (nur abi_adapter Kern); modules/ext/golden/Registry-mp_list TABU; C++23/GTest; clang-format-konform.

## §5 CMD-1-IST-KARTIERUNG (Explore — NICHT neu machen; Andock für Spur-S-CMD-1)
**Andock-Header (CMD-1 fasst an):** `execution_engine/execution_engine_base.hpp` (IExecutionEngine:98 — hier F1-**separate
Mess-Wurzel** abspalten → Zwei-Wurzel), `anatomy/anatomy_base.hpp` (IAnatomyBase:IExecutionEngine), `anatomy/idriveable_tier.hpp`
(Antriebs-Op), `anatomy/observable_tier.hpp` (Mess-Slot runtime), `src/measurement/measurable_concept.hpp:60/113`
(MeasurableComponent/Observer = compile-time Mess-Slot, STATISTICS-gated — BEHALTEN), `anatomy/resource_controllable_tier.hpp:56`
(Limitations-Auskunft — BEHALTEN, „die Limitations-Auskunft von CMD-1"), `topics/axis_base.hpp:64/78` (enabled/is_original-Statik),
**`anatomy/abi_adapter.hpp`** (god-header, wo alle 3 Belange zusammenlaufen: erbt IResourceControllableTier:145 + IObservableTier:150
+ IDriveableTier:158), `builder/anatomy_commands/anatomy_execution_context.hpp:116` (einzige CMD-1-#251-Code-Marke).
**Zu subsumieren/stilllegen (überschneiden NICHT abi_adapter):** `builder/commands/i_command.hpp` (Test-Treiber-Insel, Skelett),
`builder/anatomy_commands/*` (Builder-Pilot, 1 Test), `include/cache_engine/strategy_command/*` (vestigial, 1 Test),
`builder/algorithm_visitor/` (LEER, nur .gitkeep+CMake-Audit-Kommentar „KEIN GoF-Visitor, hybrider-Visitor-Anspruch NICHT umgesetzt").
**BEHALTEN:** `workload_orchestrator.hpp:75-152` WorkloadOp switch (Command-als-Daten, IM Mess-Pfad); `RuntimeMeasureVisitor`
(kein Visitor → UMBENENNEN). **le_limitierung-Generator** = Cross-Repo `Code/04_csv_to_latex/csv_to_latex.hpp:157` (außerhalb CMD-1-Scope).
⚠️ **`modules/comdare-*` = ZWEITE KOPIE aller Header** (Doppelung) — TABU (nie anfassen), aber CMD-1 „Parallelitäten konsolidieren" muss es benennen.
**F1-Vorgabe:** Organ-Achsen = IExecutionEngine-Basis (real via IAnatomyBase); Mess-Achsen = SEPARATE Mess-Basis (existiert
NOCH NICHT → CMD-1 spaltet sie ab). Achsen-Compile-time-Basis = `topics/axis_base.hpp:52 AxisBase` (KEIN CRTP; CRTP steckt in
`axes/*/axis_NN_*_strategy_base.hpp`). CMD-2 (E2): Sidecar für Organ-Achsen + statischer Visitor-Pfad für statische Mess-Achsen;
ContainerObserver-Gattungs-Reservierung UNBERÜHRT; mit AP-1 bündeln (ein POD-Bruch).

## §6 ZU MARKIERENDE DEGENERATIONEN (offen)
- Masstree-Referenz erntet keys={0} (kein for_each_record-Walk) — #234.
- Hüllen-Kompositionen T4/T5/T6/T7/T13-T16 honest-0 bis observe-Hooks (#234) — BEWUSSTE Konvention.
- cow_capable_-Kipp Richtung true durch 4c-iii (real wirksam erst mit #215-320-Neubau).
- seg_ns innere n=1 nur für nicht-store-traversierbare Container (keys={0}); store-backed 320 = großes n_ops (kein Defekt).
- Pfad A (`run_workload_segmented_v2`/drive_segment_latencies) DEFINIERT aber UNVERDRAHTET (perm_runner.hpp:308, kein Aufruf) — toter Konfig-Ballast (seg_batches=32/seg_ops_per_batch=4000); Doku empfiehlt Entfernung.
- stat_*-Load-Akkumulation = #216-H2 (Fix §4, in Arbeit).

## §7 FALLSTRICKE (diese Session, zusätzlich zu SE-21/21b)
- **Flüchtiger Worktree = Verlust-Risiko** (§0). Persistente Worktree-Pfade + Codex-commit-im-Worktree ODER Patch-Sicherung.
- **Kartierungs-Pfade können ungenau sein:** Explore vermutete `algorithm_profiles/sota`, real `libs/cache_engine/algorithm_profiles/sota`. IMMER Pfade + Zahlen verifizieren VOR Codex-Delegation.
- **Git-Push-Serialisierung** bei parallelen Läufen im selben Repo → Worktree-Branches sequenziell mergen.
- **prod2-HW-Instabilität** unter Compile-Last (earlyoom cc1plus). Schwere from-source-Builds mit Retry/g++-13/-j-Cap.
- **AP-6/AP-11 sind NICHT triviale Daten-Aufgaben** — brauchen fachliche Paper-/Allokator-/LP-Zuordnung (Thesis) → Text-Agent-Grundlage oder Recherche zuerst.
- Codex-Plugin-Override-Flag IMMER: `-c 'plugins."workflow-orchestrator@barkain-plugins".enabled=false'`.

## §8 DIREKTIVEN (unverändert bindend)
Manager-Modus (Codex aus ausführlichem Dossier, Claude korrigiert selbst, adversarischer Review vor done; bis 16 disjunkt parallel).
Codex NUR Code-Repos (cache-engine/prt-art/super/thesis), NIE Cluster/keys/machines. modules/ext/golden/Registry-mp_list TABU.
Commits `Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>`; NUR MERGE kein REBASE; push BEIDE Remotes (origin+gitlab).
super: nur gezielte Pfade stagen (kein git add -A; NIE thesis-Submodul/.claude/untracked). Verify NUR Pipeline; keine Erfolgsmarke ohne
Literal. #188 nie halb committen. curl `--cacert Cluster/keys/gitlab-ca-ROOTCA-20260621.crt --ssl-no-revoke`, NIE --insecure.
PAT via `git credential fill` host=gitlab.comdare.de; cache-engine=286, prt-art=287, super=288, thesis=289, ci-templates@development.
AskUserQuestion NIE (crasht Session) → Klartext-Rückfragen. Explore IMMER mit Codex paaren (gleiche Aufgabe, gegenprüfen).

## §9 OFFENE TODO-LISTE (top-down, user-sichtbar = Task-Liste)
**A #188-Architektur (Spur S, gate-frei, JETZT):** #216-H2 → #217 → AP-7 → #221 → CMD-1(#251) → CMD-2(#252)+AP-1 → #234 → #215 → #224.
**B M3-Gate-Welle P0 (Spur P + seriell):** AP-1(#235) AP-2(#236) AP-3(#237) AP-4(#238) AP-5(#239) AP-6(#240) AP-7(#241).
**C P1 Mess-Qualität:** AP-8(#242) AP-9(#243) AP-10(#244) AP-11(#245) AP-12(#246) AP-13(#247) AP-14(#248) AP-15(#249).
**D Audit-Rest E1/E2:** #221 RC · #224 Etiketten · #217 Array-Gattung · #225 (Diskussion USER) · #226 Appendix.
**E gated/extern:** #156 M3-Messung (HELD Linux+PMC) · #152 Cache-Misses · #163 SIMD/ISA · #162 PRT-ART-SOTA · #189/#199-210/#231 Infra · #25 Thesis-Text (User).
