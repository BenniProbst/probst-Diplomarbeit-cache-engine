# TOP-DOWN-BAUPLAN Planer->CEB->Tier + Dock-Muster (ultracode wf_9acb53ac, resumed post-crash)
> 2026-07-19, 7 Agenten (5 Leser SOLL/IST + Bauplan + adversariale Kritik). Rekursive Dock-Kette vom KOPF. Basis: Ledger §18.1.1/§19.C + Ketten-Audit. GATED auf User-Phasen-Freigabe.
>
> **⚠️ KRITIK-BLOCKER (Befund 1, live bestätigt):** Bauplan analysierte NUR das ce-Submodul. Im super-Repo existiert bereits ein Planer-Skelett `Code/02_messung_driver/v32_messreihe_antrieb.hpp` (execute_messreihe + PhaseStrategyFor<MergeStrategy> INC-E + PhaseCompositions<S> Policy-Based), heute return-0-Stub/INERT (opt-in main.cpp:339); Live-Pfad fuer <comdare_experiment> = run_experiment_profile_facade (main.cpp:679). => PHASE 0 noetig: super-Repo reconcilen (execute_messreihe fuellen/wiederverwenden) STATT neuen Director daneben bauen (v32-Parallelstruktur-Fehler). Zweiter Builder-Main apps/cache_engine_builder->ExperimentDriver->CodegenEngine (Legacy/quarantaeniert).

---

All anchor points verified against the live tree — the basis is internally consistent with the code (`run_experiment_profile` header-only naht at `experiment_run_entry.hpp:144` with the opt×simd Doppelschleife at `:257-289`; `IPruefDock` vtable at `pruef_dock.hpp:57`; ABI `MAJOR 6` / Magic `.A6.` / 4 C-Symbole / `host_compatible_with` at `anatomy_module_abi_v1_decl.hpp:54-149`; legacy stub `CodegenEngine` at `codegen.hpp:24`; codegen-naht blueprint at `catalog_codegen.cmake:27-37`; the unwired CoR `run_selection_filter_chain`/`ResumeFilter` at `selection_filter_chain.hpp:76-101`). Returning the build plan.

---

# TOP-DOWN-BAUPLAN — Rekursive Dock-Kette Experiment-Planer → CEB → Tier

Doktrin: `feedback_recursive_dock_planer_ceb_tier_abi_stable_so` (LED §18.1.1/§19.C). Basis: Ketten-Audit `docs/audits/20260718-ketten-konformitaets-audit-planer-ceb-tier-REPORT.md` (P7/P8/E-10 = Planer-Codegen-Lücke; V1/V2 = ABI-Grenze-Lücke). Alle Pfade relativ zu `Code/external/comdare-cache-engine/`, sofern nicht absolut.

## Executive Summary

Die 2-Ebenen-Dock-Topologie ist **asymmetrisch fertig**: der **Fuß CEB↔Tier ist REAL gebaut + test-bewiesen** (`AnatomyModuleLoader`/dlopen + `IPruefDock` + 3-teiliger POD-Vertrag, ABI Major 6, Tests `test_v41_*`) — der **Kopf Planer↔CEB existiert nur als Doku-Beschriftung** auf einer header-only Freifunktion (`experiment_run_entry.hpp:138-143` betitelt `run_experiment_profile` als „Experiment-Planer-Dock", ist aber ein musterloser 5-tiefer Schleifennest `:257-365`, kein Director/Builder/Vertragsobjekt).

**Der Bau geht vom Kopf aus, spiegelt den realen Fuß nach oben und baut ihn NICHT neu.** Drei Phasen:

- **Phase 1 (Kopf, NEU)** — benannter Codegen: `Interpreter` (vorhanden, umverdrahten) + **EIN** `Director` + **ZWEI** `ConcreteBuilder` + `Template-Method` + Planer-Executable + Planer↔CEB-Vertragsgrenze, angedockt an `run_experiment_profile` (nicht daneben). Golden-neutral, opt-in/INERT.
- **Phase 2 (CEB, WIRING)** — CEB-Bestückung mit System-Achsen (`CebSystemAxis`: compiler/opt/isa/simd/scheduling/load) + Mess-Achsen (`SystemAxis`/„Blut"); das Achsen-Vokabular existiert, es fehlt der vertragliche Andockpunkt (Spiegel von `SearchAlgorithmDrive`). Additiv, ABI-Major bleibt 6.
- **Phase 3 (Fuß, REUSE)** — Tier-Binaries über das **bestehende** CEB↔Tier-Dock. Kein Neubau; Rest rein additiv (V42-Gattungs-Docks).

Aufwand grob: **Phase 1 ≫ Phase 2 > Phase 3**. Vor Deadline 28.07 realistisch nur Phase-1-I1/I2 + Phase-2-Wiring (golden-neutral); die echte .so-ABI-Grenze und I3–I5 sind Fork-abhängig (siehe FORKS).

---

## Phase 1 — Planer-Kopf (Dock Planer↔CEB), VOM KOPF beginnend

Ziel: aus dem musterlosen `run_experiment_profile`-Nest die **drei benannten Bausteine** (Director / 2 ConcreteBuilder / Template-Method) herausziehen, ein `comdare_experiment_planner`-App-Target schaffen und die Planer↔CEB-Vertragsgrenze setzen — **ohne** die golden Callees anzutasten.

### Andockpunkte (datei:zeile)

- **Planer-Naht (hier andocken, nicht daneben):** `libs/cache_engine/profile_facade/experiment_run_entry.hpp:144` (`run_experiment_profile`), Doku-Label `:138-143`, Interpreter-Aufruf `:148-149` (`parse_experiment_profile`) + `:160` (`project_experiment_to_sota_passes` → `ExperimentPhaseProjection`), der zu zerlegende Nest `:257-365` (opt×simd-Doppelschleife `:257-289`, per-Perm `CompileFn` `:284-285`, per-Perm `build_version` `:286-289`).
- **WAS/WIE-Injektionspunkt für den Director:** `libs/cache_engine/profile_facade/profile_run_facade.cpp:494` (`run_experiment_profile_facade`), Fabrik `:560-568` (`compile_for_perm`), `:572-577` (`algo_sig`), Naht-Aufruf `:599`.
- **Interpreter-Input (umverdrahten, nicht neu schreiben):** `libs/common/serialization/xml_config_parser/xml_config_parser.hpp:300` (`struct ExperimentProfile`), `:337` (`parse_experiment_profile`).
- **CoR (vorhanden, UNWIRED → in `resolve_selection` einhängen):** `libs/cache_engine/builder/experiment_tree/selection_filter_chain.hpp:87` (`run_selection_filter_chain`) + `:76` (`ResumeFilter`) — verifiziert real, aber ohne Konsument.
- **Codegen-Naht-VORBILD (Blaupause für App-Target + cmake):** `cmake/catalog_codegen.cmake:27-37` (`add_custom_command` + `COMMAND $<TARGET_FILE:comdare_catalog_codegen_cli>` + `DEPENDS <xml>`); App-Muster `apps/catalog_codegen_tool`.
- **NICHT erweitern (Legacy/Stub, disjunkt):** `libs/cache_engine/builder/codegen/codegen.hpp:24` (`CodegenEngine::generate_module`), `codegen.cpp:12` (90ns-Stub, quarantänisiert), nur in `builder/experiment_driver/experiment_driver.cpp:145` verdrahtet — **Namens-Präzedenz für die Gestalt, nicht das Vehikel.**

### Benannte Patterns (musterlos verboten)

| Baustein | Pattern | Rolle |
|---|---|---|
| XML → `ExperimentPlan` (geordnete `PhaseStep`-Liste) | **Interpreter** | `parse_experiment_profile` + `project_experiment_to_sota_passes` als Kern, formalisiert |
| `ExperimentPlanDirector::construct(IPlanBuilder&)` — **EIN** Walk | **Director** | besitzt die Enumeration opt×simd×phase×pass (heute inline `:257-365`) |
| `CMakeGraphBuilder` + `CiYamlBuilder` aus **demselben** Walk | **2× ConcreteBuilder** (GoF Builder) | Synchronie **strukturell** garantiert (ein Walk, zwei Syntaxen) |
| `resolve_selection → emit_build → emit_measure → emit_serialize → emit_copy` je `PhaseStep` | **Template-Method** | invariantes Skelett + gattungs-/emitter-Hooks |
| Reduktion Auswertung→Generierung in `resolve_selection` | **Chain of Responsibility** | `run_selection_filter_chain` einhängen (`selection_filter_chain.hpp:87`) |
| `IExperimentDock` + `ExperimentDockRegistry` (accepts/select_for) | **Abstract-Factory** (Spiegel `PruefDockRegistry`) | die Planer↔CEB-Vertragsform |

Hot-Path bleibt compile-time-only: der Codegen läuft **strikt Configure/Pre-Build-Zeit**, keine vtable im gemessenen Hot-Path; `PhaseStrategyFor<S>` bleibt CT (keine CT→RT-Degradierung).

### NEU vs. WIEDERVERWENDET

**NEU:**
1. App-Target `comdare_experiment_planner` (Muster `apps/catalog_codegen_tool`) mit `main`: `--dump-plan` / `--emit-cmake` / `--emit-ci`.
2. `ExperimentPlanDirector::construct(IPlanBuilder&)` + `IPlanBuilder`-Interface (zerlegt `experiment_run_entry.hpp:257-365`).
3. `CMakeGraphBuilder` → `generated/experiment_plan.cmake` (`add_custom_command`+`DEPENDS`) und `CiYamlBuilder` → Child-Pipeline (`trigger:include:artifact:`).
4. `cmake/experiment_plan.cmake` (2-Pass, `-DCOMDARE_EXPERIMENT_XML=`), 1:1 nach `catalog_codegen.cmake:27-37`.
5. `IExperimentDock` + `ExperimentDockRegistry` als Planer↔CEB-Vertragsform (Spiegel `IPruefDock`/`PruefDockRegistry`).
6. `<measurement mode="debug|mess" threads="N"/>`-Schalter + echte `thread_count`-Konsumtion (#221); `"failed"`-Zelle + `<binary_id>.error.log` (try/catch um `run_*_perm`, additiv zu `two_phase_valid`).

**WIEDERVERWENDET (nicht duplizieren):** `parse_experiment_profile`/`ExperimentProfile` (`xml_config_parser.hpp:300/337`) als Interpreter-Kern; `project_experiment_to_sota_passes`/`ExperimentPhaseProjection` (`experiment_run_entry.hpp:160`); die golden Callees als Orchestrierungs-Ziele **unangetastet** — `run_lazy_static_then_dynamic`, `ex::ExperimentTree`, `make_union_source_gen` (`experiment_run_entry.hpp:186`), `generated_make_catalog_source_gen`, `project_experiment_to_sota_passes`, `select_explicit`; `run_selection_filter_chain` (`selection_filter_chain.hpp:87`); ~80% Mess-/Bau-Maschinerie (`BuildOrchestrator::provision_all`, `per_binary_subdirs`+`result.csv`, `lazy_csv_header`, `rollbackable_tier`).

### Golden/ABI-Neutralität

- Organ→`binary_id`; opt/simd (`system_config`) fließen NIE in `binary_id` (verifiziert `experiment_run_entry.hpp:254`, „binary_id BLEIBT Organ-only, Q2 Option C") → nur die MESS-Matrix (CSV × |opt×simd|) wächst, `golden_fullpilot_320_binary_ids_abi6` unberührt.
- Planer INERT-by-default (opt-in `-DCOMDARE_EXPERIMENT_XML=`); ohne Flag ist die offizielle CSV **byte-identisch**.
- Kein ABI-Bump: der Planer emittiert Bau-/Mess-Graph, nicht Tier-Binary-Quelle → `COMDARE_ANATOMY_ABI_MAJOR` bleibt 6, `kCebContractCodegenMinor` bleibt 0 (Fork D beachten).

### Verifikation (compile+test)

- ce-standalone Build grün + super-Sub-Build grün.
- **Contract-Test** `test_experiment_planner_plan` (I1): Director-Walk deterministisch; `CMakeGraphBuilder`- und `CiYamlBuilder`-Ausgabe **topologie-isomorph** (gleiche `PhaseStep`-Menge, gleiche `build:→measure:`-Kanten) — beweist strukturelle Synchronie.
- Golden-Neutralitäts-Test: mit Planer-Flag OFF ist `measurements.csv` byte-gleich zum Vor-Zustand.
- CoR-Test: `run_selection_filter_chain` mit `ResumeFilter` reduziert eine Kandidatenmenge korrekt (`two_phase_valid`→Reject).

---

## Phase 2 — CEB bestückt mit System- + Mess-Achsen über den Planer

Ziel: den De-facto-Planer (host-seitige opt×simd-Permutation) zur **Planer-Seite eines Vertrags** formalisieren und der CEB die Achsen über ein **Antriebs-Bündel** (Spiegel `SearchAlgorithmDrive`) übergeben statt über eine host-vorgebackene `std::function`-Closure.

### Andockpunkte (datei:zeile)

- **Zu spiegelnder realer Vertrag:** `libs/cache_engine/builder/pruef_dock/search_algorithm_dock.hpp:63-86` (`SearchAlgorithmDrive` + `acquire_search_algorithm_drive`, Bündel obs/ctrl/rbk/scn).
- **Achsen-blinde Injektions-Naht:** `libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp:227-230` (ctor `CompileFn`/`SourceGenFn`/`FreeRamFn`/`AlgoSigFn`), CT-Draht-Kanal `:546-579` (`make_gpp_compile_fn` mit `link_libs`+`opt_flag`).
- **CEB-Host-Treiber:** `libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:694-696` (`run_lazy_static_then_dynamic`-Signatur — Eintritt von `CompileFn`/`SourceGenFn`/`AlgoSigFn`; hier dockt das System-Achsen-Bündel an), Provenienz `:67` (`LazyRunConfig.build_version`).
- **System-Provenienz-Kompositionspunkt:** `build_orchestrator.hpp:64,393` (`.version`-Sidecar), `profile_run_facade.cpp:296-308` (`system_axes_version_suffix` `+cxx=+opt=+ext=`) + `:365/:560-568/:579` (`make_gpp_compile_fn`-Montage aus Achsen-Flags).
- **System-Achsen-Vokabular (CT-statisch, CRTP+Concept, keine vtable):** `include/cache_engine/measurement/ceb_system_axis.hpp:20-37` (`CebSystemAxis`-Wurzel, `AxisKind::system_config`), `compiler_system_axis.hpp`, `optimization_level_sub_axis.hpp`, `simd_sub_axis.hpp`, `extension_hardware_system_axis.hpp` (`gcc_march_flag`, H-7), `target_isa_system_axis.hpp` (ISA-Gate).
- **Mess-Achsen-Wurzel („Blut", senkrecht):** `include/cache_engine/measurement/system_axis.hpp:148-194` (`SystemAxis` + `collect()`, `AxisKind::system_measurement`) — soll Spalten-Quelle werden statt roher POD-Zugriff in `format_csv_row` (`cache_engine_builder_iterator.hpp:335-508`).
- **System-Schicht-Keimzelle:** `builder/experiment_tree/registry_to_axis_levels.hpp:113-122` (`build_system_axis_levels`, binary_id-orthogonal) vs. `:88-104` (`append_organ_core_axis_levels`, bildet binary_id) — hier die System-Wurzel von der flachen Reflexion abspalten.
- **Schichtungs-Basis:** `topics/axis.hpp:17-20` (`AxisKind{organ, system_measurement, system_config}`, Doc „system_config berührt NIE binary_id").
- **CEB-.so-Versionierungs-Marker:** `include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp:54` (`ABI_MAJOR 6`), `:124-149` (`host_compatible_with` + `ceb_contract_version`).

### Benannte Patterns

- **Abstract-Factory** — `acquire_*_drive`-Spiegel: `acquire_ceb_system_axis_drive` löst das Bündel aus den `CebSystemAxis`-Structs auf.
- **Builder-Rolle** der CEB (Gegenstück zur Director-Rolle des Planers).
- CT-Monomorphisierung: die vom Planer runtime permutierten opt/simd (dynamisch-Vorstufe) frieren in der CEB als Compile-Konstante ein (stufen-relativ, `feedback_haupt_achse_static_unter_achse_runtime_chain_ct_wiring`).

### NEU vs. WIEDERVERWENDET

**NEU:**
1. `CebSystemAxisDrive`-Vertrags-POD (Spiegel `SearchAlgorithmDrive`) — compiler/opt/isa/simd/scheduling/load aus den `CebSystemAxis`-Structs aufgelöst; `standard_layout`+`trivially_copyable`.
2. `acquire_ceb_system_axis_drive(...)` CEB-seitig: **entgegennehmen** statt vorgebackene Closure — montiert intern `BuildConfig.build_version` + `CompileFn` (dockt an `make_gpp_compile_fn`).
3. `SystemAxis::collect()` als maßgebliche CSV-Spalten-Quelle (ersetzt rohen POD-Zugriff in `format_csv_row`).
4. (Fork A) die .so-ABI-Grenze zwischen Planer und CEB.

**WIEDERVERWENDET:** das gesamte Achsen-Vokabular (`CebSystemAxis` + konkrete Achsen, `SystemAxis`-Blut, `topics::Axis`+`AxisKind` mit Concept-Guard `is_empty && !is_polymorphic`); Provenienz-Mechanik (`.version`-Sidecar System getrennt von `.algos` Organ, `dll_is_current` `build_orchestrator.hpp:184-215`); `system_axes_version_suffix` + `compile_for_perm`-Fabrik + die opt×simd-Permutation (`experiment_run_entry.hpp:257-289`); `build_system_axis_levels()`.

### Golden/ABI-Neutralität

- System- + Mess-Achsen NIE in `binary_id` → 320-golden binary_ids stabil.
- `+ceb=<major>.<minor>` fließt in `build_version` (`system_axes_version_suffix`), **nie** in `perm.algos`/`binary_id` (`anatomy_module_abi_v1_decl.hpp:140-142`).
- ABI-Major bleibt 6, solange kein POD-/vtable-/Emitter-Arität-Bruch (Fork D).

### Verifikation (compile+test)

- Round-Trip: `CebSystemAxisDrive` → `build_version`-Suffix identisch zur bisherigen host-seitigen Montage (`+cxx=+opt=+ext=`).
- Bestehende Tier-DLLs laden weiter (`host_compatible_with`, Major 6) — kein unbeabsichtigter Bump.
- CSV-Spalten aus `SystemAxis::collect()` byte-gleich zu den bisherigen roh gezogenen Mess-Spalten (regressionsfrei).
- golden binary_ids-Diff = leer.

---

## Phase 3 — Tier-Binaries über das bestehende (reale) CEB↔Tier-Dock

Ziel: **NICHTS neu bauen.** Der Fuß ist real + test-bewiesen; er ist die REFERENZ zum Nach-oben-Spiegeln. Rest rein additiv.

### Andockpunkte (datei:zeile)

- `libs/cache_engine/builder/pruef_dock/pruef_dock.hpp:57` (`IPruefDock`, uniformer Vertrag), `:36-41` (Status-Codes) — Header sagt selbst „KEINE ABI-Grenze, eine vtable, NICHT Hot-Path".
- `builder/pruef_dock/pruef_dock_registry.hpp:22/28` (`PruefDockRegistry`, `select_for`/`dock_for_genus`) — initial nur `SearchAlgorithmDock`, Set/Sequence/Adapter/View „kommen mit V42".
- `builder/pruef_dock/search_algorithm_dock.hpp:63-86` (`SearchAlgorithmDrive` + `acquire_search_algorithm_drive`), `pruef_dock_sequencer.hpp:46` (`measure_genus_sequential`, Sequencer-Rolle).
- `builder/pruef_dock/driveable_map_contract.hpp:34` (`DriveableMapContract<Derived>`, host-only CRTP über ABI-stabile `IDriveableTier`, vtable nur an ABI-Grenze).
- Loader: `builder/anatomy_module_loader/anatomy_module_loader.cpp:40` (`dlopen RTLD_NOW|RTLD_LOCAL`), `:114-117` (4 Symbol-Resolves), `:130-133` (Magic-Gate), `:138-145` (Major/Minor-Gate).
- 3-teiliger POD-Vertrag: `builder/pruef_dock/pruef_dock.hpp:33` (`PruefDockMeasureOptions = AbiTierTraceConfig`), `anatomy/resource_controllable_tier.hpp` (`ComdareResourceControlV1`), `anatomy/observable_tier.hpp:179` (`tier_observe`) + POD `:128-149` (`ComdareTierObserverSnapshot`, `standard_layout`+`trivially_copyable`, sizeof 1272, memcpy).
- Antrieb hinab: `anatomy/idriveable_tier.hpp:33-45` (`tier_insert/lookup/erase/clear/size`).
- **Fuß-Beweis (nicht neu bauen):** `tests/unit/test_v41_anatomy_module_loader.cpp`, `test_v41_pruef_dock_search_algorithm.cpp`, `test_genus_docks.cpp`, `test_conformance_gate.cpp`.

### Patterns / NEU vs. WIEDERVERWENDET

- **REUSE komplett** — Muster: `IPruefDock` (Template-Method-Vertrag), `PruefDockRegistry` (Abstract-Factory), `measure_genus_sequential` (Sequencer/Director-Rolle), `DriveableMapContract` (CRTP Hot-Path). Organ-Achsen permutieren `binary_id` über 19 Slots (direkt einkompiliert); Governor/Prefetcher = Heuristik-Command in CT-CoR (a) oder plain (b); monomorph EIN Algorithmus je Perm, **kein `std::variant`**.
- **NEU nur additiv** (Fork/INC-4): V42-Gattungs-Docks (Set/Sequence/Container/Graph) als je neue `IPruefDock`-Implementierung + gattungs-eigenes Antriebs-Sub-Interface + neuer flacher POD — **NIE** Mutation von `IAnatomyBase` oder bestehendem Snapshot.

### Golden/ABI-Neutralität + Verifikation

- Additive V42-Docks brechen `SearchAlgorithm` nicht (eigene Gattung, eigenes POD).
- Verifikation: bestehende `test_v41_*` bleiben grün; neue Docks bekommen additiv `test_genus_docks`-Erweiterung; ABI-Major nur bei echtem POD-/vtable-Bruch bumpen (dann koordinierter Bündel-Bump wie 4→5→6, `anatomy_module_abi_v1_decl.hpp:43-53`).

---

## Muster-Spiegelung: wie Planer↔CEB das CEB↔Tier-Dock spiegelt

Der reale Fuß (rechts) ist die 1:1-Vorlage; der Kopf (links) wird daraus gespiegelt — **KEINE Parallelstruktur, NICHT neu bauen.**

| Invariante | Fuß CEB↔Tier (REAL, test-bewiesen) | Kopf Planer↔CEB (zu bauen — Spiegel) |
|---|---|---|
| Benanntes Vertrags-Interface (Template-Method-vtable, KEINE ABI-Grenze) | `IPruefDock` `pruef_dock.hpp:57` | `IExperimentDock` (accepts/select_for + construct-Skelett) |
| Abstract-Factory-Registry | `PruefDockRegistry` `pruef_dock_registry.hpp:28` | `ExperimentDockRegistry` |
| 4 extern-C-Pflichtsymbole an der .so-Grenze | `comdare_anatomy_abi_version/magic/create/destroy` `anatomy_module_abi_v1_decl.hpp:84-102` | 4 CEB-.so-Symbole (version / magic / create-CEB / destroy-CEB) |
| MAGIC/MAJOR-Gate (Magic kodiert Major .A6.) | `ABI_MAJOR 6` `:54`, `MAGIC 0x…362E` `:58`, Loader-Gate `anatomy_module_loader.cpp:130-145` | eigenes Planer↔CEB `MAGIC`/`MAJOR` + `host_compatible_with`-Gate |
| Loader (dlopen RTLD_NOW\|RTLD_LOCAL + Symbol-Resolve + Gate + RAII destroy-vor-unload) | `anatomy_module_loader.cpp:40-157` | Planer-seitiger CEB-Loader (identische Blaupause) |
| `host_compatible_with` (major==major && modul.minor<=host.minor) | `anatomy_module_abi_v1_decl.hpp:124-127` | identisch, Planer als Host |
| Antriebs-Bündel-POD (standard_layout+trivially_copyable, memcpy) | `SearchAlgorithmDrive` `search_algorithm_dock.hpp:63-86` | `CebSystemAxisDrive` (compiler/opt/isa/simd/scheduling/load) |
| **Rückkanal-POD** | `ComdareTierObserverSnapshot` via `tier_observe` `observable_tier.hpp:179` | **ENTFÄLLT** — Planer↔CEB ist EINDIMENSIONAL; CEB schreibt Messwerte SELBST ans XML-Ziel (`§11-G`) |
| Richtung | BIDIREKTIONAL (CEB treibt `IDriveableTier`, Tier meldet POD zurück) | EINDIMENSIONAL (Planer steuert, kein Rückkanal) |
| Rolle | Builder (CEB baut/misst Tier) | Director (Planer orchestriert CEB) |
| Nutzlast bzgl. binary_id | Organ-Achsen → `binary_id` | System+Mess-Achsen → NIE `binary_id` (nur Ordner/`parallel:matrix`-Fan-out) |

**Kern der Spiegelung:** Die ABI-Grenze ist NIE das Interface selbst (auch `IPruefDock` ist keine ABI-Grenze), sondern die geladene .so + der POD. Beim Kopf gilt das identisch — nur der Rückkanal-POD entfällt und die Nutzlast wechselt von Organ-Antrieb zu Achsen-Bestückung.

---

## FORKS für USER-GO (blockieren bis entschieden)

- **FORK A — Planer↔CEB als echtes dlopen-.so vs. header-only-Vertragsgrenze.** Der Fuß-`IPruefDock` ist selbst **keine** ABI-Grenze (nur vtable im Builder-Binary); die ABI-Grenze ist die geladene Tier-.so. Analog: wird die **CEB als eigene, dlopen-geladene, system-achsen-versionierte .so** gebaut (voller 4-Symbol-Loader-Spiegel, `host_compatible_with`) — oder bleibt sie In-Prozess und nur die Vertragsobjekte (`IExperimentDock`/Director/Builder + `CebSystemAxisDrive`-POD) werden formalisiert (die .so-Grenze deferred)? Doktrin verlangt „CEB selbst ABI-stabile .so" (LED:1619) → langfristig A=echte .so; kurzfristig vor Deadline evtl. nur die Vertragsform. **Braucht GO.**
- **FORK B — welche 2 ConcreteBuilder.** DOSSIER legt `CMakeGraphBuilder` (`--emit-cmake` → `experiment_plan.cmake` → `include()`) + `CiYamlBuilder` (`--emit-ci` → Child-Pipeline `trigger:include:artifact:`) fest. Unterfrage: ist `--dump-plan` (I1) ein **dritter trivialer** `PlanTextBuilder` (sauberer für den Contract-Test) oder eine Director-Methode? **Bestätigen.**
- **FORK C — Scope vor/nach Deadline 28.07 (heute 19.07, 9 Tage).** Vorschlag: **vor** 28.07 = Phase-1-I1 (Planer-Skelett `--dump-plan` + Contract-Test, golden-neutral) + I2 (`CMakeGraphBuilder`, opt-in) + Phase-2-Wiring (`CebSystemAxisDrive`, additiv, kein .so). **Nach** 28.07 = I3 (`CiYamlBuilder`/Child-Pipeline), I4 (`<measurement mode>`+`failed`-Zelle), I5 (Serialisierungs-Emitter), Fork-A-.so-Grenze, Phase-3-V42. **Braucht GO auf die Schnittlinie.**
- **FORK D — `ceb_contract_version`-Minor-Bump beim Planer-Emitter?** Der Planer emittiert Bau-/Mess-Graph (kein Tier-Binary-Quellcode) → voraussichtlich **kein** Bump (`kCebContractCodegenMinor` bleibt 0, `anatomy_module_abi_v1_decl.hpp:144`). Falls der Emitter jedoch eine CEB-universelle Codegen-Quelle berührt (all_axes_umbrella/Observer-Basis-Emission), ist der Minor-Bump Pflicht (CI-Tripwire-gated, `:143`). **Verifizieren/entscheiden vor Merge.**
- **FORK E — XML-Pfad-Vereinheitlichung.** `run_experiment_profile` fährt bereits über `parse_experiment_profile` (verifiziert `experiment_run_entry.hpp:148-149`), der **offizielle golden Mess-Pfad** läuft aber über `parse_thesis_profile`/`run_profile_facade` (m3v2). Soll der Planer auf **eine** XML-Interpreter-Quelle konvergieren (Experiment- vs. Thesis-Profil) oder bleiben beide koexistent? Konsolidierung berührt den golden Pfad → **GO nötig**, sonst Phase-1 strikt additiv am Experiment-Profil halten.

---

## Reihenfolge, Abhängigkeiten, Aufwand

**Strikt top-down, aber Fuß bleibt Referenz:**

1. **Phase 1 zuerst** (Kopf) — hängt an nichts Neuem; dockt an `run_experiment_profile`. Reihenfolge intern: I1 Interpreter+Director+`IPlanBuilder`+`--dump-plan`+Contract-Test → I2 `CMakeGraphBuilder`+2-Pass `experiment_plan.cmake` → (Fork C) I3 `CiYamlBuilder` → I4 mode/failed → I5 Serialisierung. **Aufwand: groß** (netto-neuer Codegen; ~5 Increments).
2. **Phase 2 danach** (CEB-Bestückung) — hängt von Phase 1 (Director muss existieren, um das `CebSystemAxisDrive`-Bündel zu übergeben). Achsen-Vokabular ist fertig → primär Wiring. **Aufwand: mittel.** Fork A (echte .so) verschiebt Teil nach 28.07.
3. **Phase 3 zuletzt** (Fuß) — hängt von Phase 2 (CEB reicht das System-Achsen-Bündel CT-verdrahtet an die Tier-Binaries). **Aufwand: klein** (Reuse + additive V42-Docks, Fork-C/INC-4-gated).

**Kritischer Pfad:** Phase-1-I1 (Director-Zerlegung) → Phase-2-`acquire_ceb_system_axis_drive` → alles Weitere. Doktrin-Kompile-Reihenfolge bleibt: CEB VORHER auf Gattungs-Observer+Module kompilieren, dann bauen+durchmessen (System-Config → Mess-Achsen-Heuristik).

**Bau nur nach expliziter User-Phasen-Freigabe** (F5 = Folgearbeit, noch nicht erteilt — `xml-ci-automatisierung:210`; `feedback_jede_aufgabe_ultracode_planungssession...`).

---

## Risiken

- **R1 — Musterloser Nest-Umbau bricht golden.** `experiment_run_entry.hpp:257-365` ist der golden Mess-Pfad; die Director-Zerlegung darf die Callees (`run_lazy_static_then_dynamic`, `select_explicit`, `ExperimentTree`) nur orchestrieren, nicht ändern. **Mitigation:** Byte-Identitäts-Test der CSV bei Planer-OFF; reiner Extract-Method-Refactor, keine Semantik-Änderung.
- **R2 — Verwechslung Legacy-`CodegenEngine` als Vehikel.** `codegen.hpp:24`/`codegen.cpp:12` ist ein quarantänisierter 90ns-Stub, nur an `experiment_driver.cpp:145` (App `cache_engine_builder`) — **NICHT** der golden Pfad. Gefahr, daran zu bauen statt an der Planer-Naht. **Mitigation:** ausschließlich an `run_experiment_profile`/`run_experiment_profile_facade` andocken (Namens-Präzedenz nur für die Gestalt nutzen).
- **R3 — Fork-A-.so-Grenze zieht ABI-Arbeit nach.** Echte CEB-.so bedeutet eigener Symbolsatz/Loader/Gate — Aufwand + Bruch-Risiko. **Mitigation:** vor Deadline nur Vertragsform (In-Prozess), .so-Grenze als separater INC nach GO.
- **R4 — CoR-Verdrahtung ändert Bau-Selektion.** `run_selection_filter_chain` in `resolve_selection` einzuhängen darf die heutige Kandidatenmenge nicht ungewollt reduzieren (`ResumeFilter` rejectet `two_phase_valid`). **Mitigation:** leere Kette = Identität (`selection_filter_chain.hpp:87` „Leere Kette → alle überleben"); schrittweise, mit Provenance-Audit.
- **R5 — CI-Emitter (I3) darf hand-CI nicht rot machen.** Child-Pipeline ist INERT-by-default; `measure:*` bleibt rules-gated. **Mitigation:** gesamte Pipeline hart grün (`feedback_gesamte_pipeline_immer_hart_gruen`), Emitter INERT bis explizitem opt-in.
- **R6 — `SystemAxis::collect()`-Umstellung als Spalten-Quelle** kann CSV-Schema verschieben (`kV3AxisSchema`). **Mitigation:** Spalten-Diff-Test byte-gleich; ABI-Spalten-Vertrag unverändert.
- **R7 — Deadline-Druck 28.07** kann zu Behelfswegen verleiten (`feedback_no_quick_fixes`/`feedback_only_one_official_xml_driven_program`). **Mitigation:** Fork C hart schneiden; nur benannte Patterns; keine Parallelstruktur.

---

# ADVERSARIALE KRITIK (Verdikt: NICHT vollstaendig architektur-konform bis Phase-0-super-Reconcile)

Verdikt: **NICHT vollständig architektur-konform** — der Bauplan ist top-down korrekt geordnet und dockt (nach Fork-E-Vorbehalt) an eine reale, von einem Main erreichbare Naht an, aber seine Projektstruktur-Analyse ist **einseitig auf das Submodul beschränkt** und übersieht genau die Stelle im Super-Repo, an der schon eine parallele Enumerations-/Export-Engine liegt — das ist der historische v32-Stopp-Grund. Live belegte Schwächen (≤8):

**1. (b) BLOCKER — Projektstruktur-Analyse endet am Submodul; das offizielle `02_messung_driver` (Super-Repo) samt vorhandener Parallel-Enumeration ist ungeprüft.** Der echte, live erreichbare Mess-Einstieg ist `Code/02_messung_driver/main.cpp:679` (`run_experiment_profile_facade` → Dock) bzw. `:722` (`run_profile_facade`). **Alle** Bauplan-Anker liegen dagegen in `Code/external/comdare-cache-engine/`. Dadurch übersieht der Plan `Code/02_messung_driver/v32_messreihe_antrieb.hpp:214` — eine ZWEITE Funktion namens `run_experiment_profile(ExperimentProfile, EnumerationMode)` mit compile-time-Phasen-Enumeration (`drive_phase<MergeStrategy::…>`, `dispatch_phase`) und `execute_messreihe():259`, selbst betitelt „**der OFFIZIELLE Einstieg (INC-G+H)**" inkl. CSV+TikZ-Export. Der geplante NEUE `ExperimentPlanDirector` (Phasen/opt×simd-Walk) + I4/I5-Export würde damit zur **dritten** Enumerations-/Export-Engine — exakt die v32-Parallel-Engine-Klasse, die laut Memory (`feedback_vor_aufgaben_erst_projektstruktur_analyse`) bereits einmal gestoppt wurde. **Korrektur: v32_messreihe_antrieb + dessen `MergeStrategy`-CT-Dispatch zuerst kartieren und wiederverwenden/reconcilen, nicht daneben einen neuen Director-Walk bauen.**

**2. (f) Zwei live Builder-Entrypoints, aber „NUR EIN offizielles XML-Programm" behauptet — nicht als Fork offengelegt.** Neben `02_messung_driver` existiert `apps/cache_engine_builder/main.cpp:182` → `ExperimentDriver::run_pipeline_full` (`experiment_driver.cpp:534`) → **CodegenEngine** (`experiment_driver.cpp:149/156/198`). Die R2-Quarantäne von `CodegenEngine` ist zwar im Ergebnis richtig (golden läuft über `02_messung_driver`), aber der Plan hat das nirgends belegt und behauptet in R1 unverifiziert, `experiment_run_entry.hpp:257-365` sei „der golden Mess-Pfad". Die Koexistenz beider Builder-Mains gegen die 1-Programm-Doktrin gehört als Fork oder Bereinigung in den Plan, nicht als stille Annahme.

**3. (e/d) Die Spiegel-Tabelle übercommittet auf die .so-ABI-Grenze, die Fork A ausdrücklich offenlässt.** Die Zeilen „4 extern-C-Symbole / MAGIC-MAJOR-Gate / Loader / host_compatible_with" (Vorbild `anatomy_module_abi_v1_decl.hpp:54/57/124-127`) werden als Planer↔CEB-**Design** präsentiert, während Fork A sagt, die reale CEB-.so werde evtl. deferred/in-process. Bei In-Prozess verschwinden genau diese vier Zeilen. **Korrektur: die .so-Zeilen als Fork-A-kontingent markieren, sonst ist die Tabelle als „entschieden" getarnt, was offen ist (Verstoß gegen Prüfpunkt f).**

**4. (b) CoR-Andockpunkt `resolve_selection` existiert nicht** (0 Produktions-Treffer im ganzen Baum; `run_selection_filter_chain`, `selection_filter_chain.hpp:87`, wird NUR von `tests/unit/test_d15_selection_filter_chain.cpp` konsumiert). Der Plan formuliert „in `resolve_selection` einhängen", als sei das eine bestehende Naht — es ist selbst eine neue Methode. Als NEU deklarieren, nicht als Andockpunkt.

**5. (a) Kritischer-Pfad-Übertreibung: „Phase 2 hängt von Phase 1 (Director muss existieren)".** `CebSystemAxisDrive`/`acquire_ceb_system_axis_drive` spiegeln `SearchAlgorithmDrive` (`search_algorithm_dock.hpp:65/77`) unabhängig vom Director; das Wiring könnte parallel zu Phase-1 laufen. Die harte Sequenz-Abhängigkeit ist sachlich nicht gegeben — Sequenzierung präzisieren.

**6. (Low) Toter Breadcrumb im Zielcode:** `experiment_run_entry.hpp:143` sagt „DER ANATOMY-MAJOR-4→5-BUMP REITET AN DIESER NAHT (INC-2b)", der Baum steht aber bereits bei `COMDARE_ANATOMY_ABI_MAJOR 6` (`anatomy_module_abi_v1_decl.hpp:54`, Magic `.A6.`). Der referenzierte Bump ist zwei Majors überholt; Kommentar bei der Director-Zerlegung mitziehen/deprecaten.

Positiv bestätigt (live): top-down-Reihenfolge Kopf→Fuß korrekt (a); realer Fuß `IPruefDock`/Loader/POD wird als Muster gespiegelt, nicht neu gebaut (c); binary_id-Organ-only-Neutralität belegt (`experiment_run_entry.hpp:254-256`), `+ceb=` fließt in `build_version` nie in binary_id (`anatomy_module_abi_v1_decl.hpp:138-149`), ABI-Major-6-Erhalt konsistent (g); die sechs als NEU deklarierten Symbole sind tatsächlich nirgends im Baum vorhanden (kein verstecktes Duplikat im Submodul) (d). Der einzige echte Parallelstruktur-Befund liegt im **nicht analysierten Super-Repo** (Befund 1) — dort muss die Analyse nachgeholt werden, bevor gebaut wird.
