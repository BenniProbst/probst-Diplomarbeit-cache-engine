# LENS IST-CEB — Kartierung der realen CEB-Seite (Stand ce = b09ebb8a)

Repo-Wurzel (alle relativen Pfade): `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine`
Super-Repo-Verweise (Kettenende, nur wo noetig): `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code`

READ-ONLY-Audit. Gliederung nach den 5 Auftrags-Punkten; je Punkt Zuordnung zu SOLL-Glied (3)/(4)/(5) und ehrliche Luecken.

---

## 1. CEB-EXISTENZ — was ist die CEB physisch? (SOLL-Glied 3)

### 1.1 apps/cache_engine_builder = STATISCHES CMake-Target, Legacy-Demo-Driver

- `apps/cache_engine_builder/main.cpp` (192 Zeilen, komplett gelesen): duenner Wrapper um
  `comdare::builder::ExperimentDriver` (REV 7.6). argv: `<config_dir> <output_dir>` + Optionen
  `--enumerate-only | --skip-build | --quiet | --comdare-root= | --mode=defined|full|full-sampled |
  --sample-rate= | --sample-seed=` (main.cpp:14-33, 65-88, 92-158). Er faehrt
  `driver.run_pipeline_full(wopts)` mit einem fest verdrahteten **Demo-Workload** (1000 Keys, 500 Ops,
  YCSB-C, main.cpp:175-184).
- **Selbst-Deklaration als Demo**: main.cpp:85-87 — "This Builder is the cache-engine-Demo-Driver. The real
  Experiment-Orchestrator (3 Messreihen A/B/C) lives in Diplomarbeit/Code/messung_driver/ (REV 7.6)."
- CMake: `apps/cache_engine_builder/CMakeLists.txt:8-29` — `add_executable(cache_engine_builder main.cpp)`
  hinter Option `COMDARE_BUILD_BUILDER`, OUTPUT_NAME `comdare-cache-engine-builder`. Also: ein **statisch
  im Repo definiertes CMake-Target**, KEINE vom Planer generierte Binary.
- Die dahinterliegende 7-Phasen-Pipeline: `libs/cache_engine/builder/experiment_driver/experiment_driver.cpp`
  — Phase 1 Enumeration (XML-Parse + `loop::PermutationLoop::enumerate`, :93-137), Phase 2 Codegen
  (:142-223), Phase 3 `cmake -S/-B` + `cmake --build --target comdare_all_permutations` via `std::system`
  (:266-295), Phase 4 dlopen-Load (:357-380), Phase 5+6 Workload+Messen (:386-508), Phase 7 CSV/JSON-Export
  `measurements.csv`/`measurements.json` (:513-529). Diese Strecke ist die ALTE Modul-Loader-Welt
  (voll-eager Enumeration, `permutation_loop.cpp:15-30` = 4-fach-Nest mit `reserve(∏)` — NICHT lazy).

### 1.2 Die LIVE-CEB-Rolle traegt eine ANDERE Binary: comdare-messung-driver

- Der Planer-emittierte Bau-/Mess-Batch-Job baut und ruft:
  `experiment_plan_director.hpp:1112-1121` — `cmake --build build --target comdare-messung-driver` und
  `DRIVER=$(find build ... comdare-messung-driver)`; Aufruf `"$DRIVER" experiment_config "<dll_dir>"`
  (:1170 ff.). Target-Definition im Super-Repo: `Code/02_messung_driver/CMakeLists.txt:18`
  (`OUTPUT_NAME "comdare-messung-driver"`); dieser Treiber konsumiert die ce-Facade
  (`Code/02_messung_driver/main.cpp:51` `#include <profile_facade/profile_run_facade.hpp>`, :1584
  `pf::run_profile_facade(pa)`).
- **"Heute EINE Binary in zwei Rollen"** ist im Code woertlich dokumentiert:
  `experiment_plan_director.hpp:903-905` — "der Planer steuert die CEB-Jobs, die CEB steuert die Tier-Jobs.
  Heute traegt EINE Binary beide Rollen (Planer-Rolle CiYamlBuilder vs CEB-Rolle DIESER Builder) — ehrlich
  getrennt ueber getrennte CLI-Modi + getrennte Emissions-Sichten." Ebenso
  `profile_run_facade.hpp:299-303` (`--emit-tier-ci` = "die CEB-ROLLEN-Emission (Stufe 2)").
- **IST vs SOLL (3)**: Der Planer "baut" die CEB nur in dem schwachen Sinn, dass der von ihm emittierte
  CI-Job je Lauf `cmake --build --target comdare-messung-driver` mit dem plan-aufgeloesten
  `CMAKE_BUILD_TYPE` faehrt (director:1112-1114; `PlanBuildSemantic` :zeilen ~118-124 des Kopfes,
  cmake_build_type/measurement_on/single_thread). Es gibt KEINEN Codegen "ein effizientes CEB je
  Messsystem hart kompiliert": die Messsystem-Differenzierung [a,b,c] kommt zur Laufzeit per Env
  `COMDARE_MEASUREMENT_COMBO` (director:1090-1092) in DIESELBE Binary. GoF Director+Builder existiert
  real (`ExperimentPlanDirector::construct(IPlanBuilder&)`, director:1-56), aber als **Text-Emitter**
  (PlanText/CiYaml/TierCiYaml/TierCmakeGraph), nicht als Binär-Kompilierer der CEB.
- **Sequentialitaet je Maschine (§38.b)** ist real, via GitLab `resource_group "ceb-measure-<host>"` fuer
  Build-Batch UND Mess-Batch derselben Lane (director:1101-1103, 1209-1212) + `single_thread`-Messpolitik
  (PlanBuildSemantic; Mess-Loop 1-Thread, iterator LazyRunConfig-Doku :~101-107).

### 1.3 System-Achsen-Versionierung / ceb_version_stamp.hpp

- `libs/cache_engine/builder/ceb_version_stamp.hpp` (201 Zeilen, gelesen): die CEB hat **KEINE
  Gesamt-Version** (der Planer schon: `profile_facade/planner/planner_version.hpp`). CEB-Identitaet =
  ihr **Mess-ANGEBOT**: consteval gerenderte Zeile aus `kMeasurementToolingRegistry` +
  `[load_framework=ycsb@…]`-Meta-Meta-Anhang (:95-156) + SHA-512-Provenienz `kCebFingerprint` ueber
  die K7b-Primitive `anatomy_fingerprint_hex("","",Messzeile)` (:187-189). Ausgabe im Log-Kopf:
  `ceb_version_stamp()` (:193-199), konsumiert in `apps/cache_engine_builder/main.cpp:161`.
- **Ausdruecklich ZELLWERTFREI** (W10-C3-Wache, :166-178): "die CEB ist KEIN Tier-Binary. Sie baut
  Tier-Binaries fuer beliebige Zellen; ihre Identitaet ist ihre CODE-Identitaet (das Mess-ANGEBOT),
  nicht die Zelle eines einzelnen Bauauftrags." D.h. **System-Achsen-Versionierung der CEB = nur ueber
  die Mess-Kombination [a,b,c] als CEB-TYP-Name** (director `PlanMeasurementCombo`, Kopf ~Z.100-115:
  "Sie bestimmt den CEB-TYP"), nicht als System-Zellen-Stempel in der Binary.

### 1.4 builder/-Schicht-Struktur (Ueberblick, vollstaendige Dateiliste erhoben)

`libs/cache_engine/builder/` enthaelt u.a.: `experiment_driver/` + `experiment_runner/` +
`permutation_loop/` + `module_loader/` (Legacy-REV-7.6-Welt); `experiment_tree/` (die LIVE-Lazy-Welt:
`cache_engine_builder_iterator.hpp` 2065 Z., `ceb_generator.hpp`, `progress_delta.hpp`,
`progress_heartbeat.hpp`, `result_ingest.hpp`, `host_measure_loop.hpp`, `parallel_measure_pool.hpp`,
`slurm_launcher.hpp` …); `build_orchestrator/`; `codegen/` (adhoc_emitter + Templates);
`anatomy_module_loader/`; `pruef_dock/` (10+ Docks/Gates); `commands/` + `anatomy_commands/`;
`bestandslog/` (Lagerhaltung, 20 Header); `artifact_transport/` (ram_spool, spool_writer, async_push_pump,
io_uring/portable Backends); `workload_driver/`. Leere Platzhalter-Module (nur `.gitkeep` + CMakeLists):
`in_memory_measurement_buffer/`, `permutation_engine/`, `observer_registry/`, `platform_probe/`,
`live_cpu_model/`, `latex_renderer/`, `measurement_matrix/`, `telemetry_spool/`, `disk_serializer/`,
`compile_time_knowledge/`, `runtime_micro_benchmarks/`, `module_loader/.gitkeep`-Teil.

---

## 2. VERTRAGS-EINGANG — was konsumiert die CEB als Plan? (SOLL-Glied 4)

### 2.1 Der SOLL-Vertrag (serialisierter Teilbaum) existiert als Code — ist aber DEPRECATED/inert

- `libs/cache_engine/profile_facade/planner/experiment_dock_payload.hpp:38-72`:
  `AxisRangeEntry` (AxisKind-gefaerbt organ/system_config/system_measurement; `enumerated`
  Variant-Namensliste ODER `index_range` start/count) + `ExperimentSubtreePayload` — exakt der
  SOLL-"untere Teilbaum als RANGES je Achse". XML-Wire-Format + Emitter/Parser mit
  Byte-Roundtrip-Gate (:138-195).
- **Aber**: Deprecation-Block :58-64 (S5-P4 Ruling 2026-07-20): "Die LIVE-Kette Planer -> CEB -> Tier
  reicht die Achsen-Ranges NICHT ueber dieses in-process POD, sondern ueber den EMITTIERTEN
  CMake-/YAML-TEXT … Das VOLLE Wire-Format (der 5-tiefe #19-Resolver -> LinkedExperimentPlan …) ist
  Band-C DEFERRED (Task #19). … wird aber HEUTE von keiner Live-Call-Site konsumiert."
  → **Die R1-Notiz 20.07. ("Vertrag derzeit TEXTEMISSION statt .so-ABI, bewusst deferred") ist am
  Objekt BESTAETIGT und im Code selbst als bewusster Entscheid markiert.**

### 2.2 Was die CEB im LIVE-Pfad real konsumiert (exakte Eingangs-Formate)

Quelle: die vom Planer emittierten Batch-Jobs, `experiment_plan_director.hpp emit_batch_build_job`
(:1081-1200) / `emit_batch_measure_job` (:1201 ff.):

1. **argv**: `"$DRIVER" experiment_config "<dll_dir>"` (:1170-1171) — Config-Verzeichnis + Ziel-Verzeichnis
   `gn_out/<slug>/<host>/perm<idx>` bzw. measure-seitig `measure_out/<slug>/perm<idx>`.
2. **Die autoritative Anwender-XML selbst**: `COMDARE_THESIS_PROFILE="$COMDARE_GOLDEN_N_PROFILE"`
   (:1167) — die CEB liest das Profil ERNEUT durch denselben Parser (Root-Tag-Sniff
   `<comdare_thesis_profile>` vs `<comdare_experiment>`, `Code/02_messung_driver/main.cpp:1430-1440`).
   Der Plan kommt also NICHT "bereits aufgeschluesselt" als Datenstruktur an — die CEB
   re-interpretiert die XML.
3. **System-Achsen je Perm als EINZELWERTE per Env**: `COMDARE_GN_OPT="<O3|…>"`,
   `COMDARE_GN_SIMD="<no_extension|avx2|…>"` (:1168).
4. **Organ-Raum als LINEARES Index-Fenster, nicht als Ranges je Achse**:
   `COMDARE_GOLDEN_N_RANGE="${START}:${COUNT}"` ueber `[0,COMDARE_GN_TOTAL)` in 4096er-Scheiben
   (:1156-1169; Default-YAML `COMDARE_GN_RANGE: "0:4"` :949).
5. **Mess-Kombination (CEB-Identitaet)**: `COMDARE_MEASUREMENT_COMBO="[a,b,c]"` (:1090-1092, leer bei `[all]`).
6. **Modus-Schalter**: `COMDARE_GOLDEN_N_PROVISION_ONLY=true` (Bau ohne Messung),
   `COMDARE_PRUEF_ONLY=true` (nur Konformitaets-Gate), `COMDARE_RUN_SOTA=0`, `COMDARE_BUILD_TYPE`,
   `COMDARE_BUILD_PARALLEL` (Lane-Budget 24, :1122-1126), `COMDARE_LANE` (Pflichtfeld der
   Marker-Zeilen, :1138-1141), `COMDARE_HEARTBEAT_EVERY` (progress_heartbeat.hpp:23-40).

**IST vs SOLL (4)**: Die "Instrumentierung der CEB" (#54) geschieht per **Env-Variablen im emittierten
Shell-Text**, nicht per XML-Anweisung; der "aufgeschluesselte untere Teilbaum" reist als
(Einzelwert-Perm x lineares Index-Fenster), das getestete Achsen-Range-POD liegt inert daneben.

---

## 3. BEFEHLS-AUSFUEHRUNG — Commands, Orchestrator, Permutation (SOLL-Glied 5, Teil 1)

### 3.1 commands/ — Command-Pattern nur noch als dokumentierte Rest-Insel

- `libs/cache_engine/builder/commands/i_command.hpp:2-7`: "CMD-1 (c) GEPARKT (#267, 2026-07-06): dieser
  Header bleibt als dokumentierte V32-AUSNAHME — … Die uebrigen Command-Inseln (compare_engine/
  auto_permutate/anatomy_*_command/strategy_command/algorithm_visitor) wurden mit 0-Konsumenten-Beweis
  entfernt; Nachfolger der Command-Semantik = compile-time AxisCommand (topics/axis_command_base.hpp)."
- `ICommand` (i_command.hpp:31-43): `command_name()/execute()/is_parallelizable()` — klassisches GoF-Interface;
  einziger harter Konsument: `execute_engine_command.hpp` via
  `include/cache_engine/abi/cache_engine_execution_engine_adapter.hpp` (V32-Demo-Pfad, default OFF).
  Daneben liegen in commands/ die Statistik-Werkzeuge (welch_t_test, mann_whitney_u_test, multi_compare,
  result_aggregator, latency_stats, workload, drift_detector) als Header-Bausteine.
- **IST vs SOLL (5) "CEB FUEHRT DIE BEFEHLE AUS (Command-Pattern)"**: Das Laufzeit-Command-Pattern ist im
  Live-Pfad ABGELOEST durch compile-time `AxisCommand` + die Treiber-Funktionen des Iterators; die
  GoF-Command-Klassen sind eine eingefrorene V32-Ausnahme.

### 3.2 anatomy_commands/ — Execution-Contexts, keine Command-Objekte

`anatomy_execution_context.hpp:1-30` (+ set/sequence/view/adapter_execution_context.hpp):
`AnatomyExecutionContext<Composition>` wrappt Anatomie + Container fuer die Mess-Treiber-Operationen
(User-Direktive: "Anatomie enthaelt nur Achsen + Observer; alle Tools gehoeren in CacheEngineBuilder").
`tier_observe_trace(_abi).hpp` = die Mess-Treiber-/Trace-Konfiguration (`AbiTierTraceConfig`), die auch
die Pruef-Docks als `PruefDockMeasureOptions` wiederverwenden (pruef_dock.hpp:33).

### 3.3 Lazy Permutation — REAL

`libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:1-27`: die EINE
Host-Treiber-Funktion `run_lazy_static_then_dynamic` (:1198 ff.) mit 3 expliziten LAZY Iteratoren
"alle ohne ∏-Voll-Materialisierung": (1) `StaticBinaryView + BuildSelection` — je Blatt lazy `view[i]`,
O(K) statt O(∏); (2) je gebaute DLL `AnatomyModuleLoader::load` → `IObservableTier` /
`IResourceControllableTier`; (3) `RuntimeVariableLoop` lazy ueber die virtuelle Kartesik des dynamischen
Filterbaums OHNE Neu-Bauen. (Die Legacy-`PermutationLoop` in permutation_loop.cpp ist dagegen eager —
sie gehoert zur Demo-Strecke aus 1.1.)

### 3.4 Batch 4096 — REAL, zweifach verankert; RAM-Puffer — fuer Artefakte real, fuer Messwerte Stub

- Planer-Seite: `experiment_plan_director.hpp:542` `inline constexpr std::size_t kGnBatchSlice = 4096;`
  ("Bestandslog-Korn", Fenster-Schleife :1156-1176, harte Konstante ohne Env-Override :1129-1130).
- CEB-intern: `bestandslog/planer_driven_build.hpp:45-46` `kBuildSliceGrain = 4096` ("spiegelt
  experiment_plan_director kGnBatchSlice"); async Producer/Consumer `SlicePlanner`/`SlicePlanQueue`
  (:137-211) mit per-Binary-Miss-Erkennung `filter_window_for_build` (:116-134); im Iterator verdrahtet
  (cache_engine_builder_iterator.hpp:1044-1065: `SlicePlanner planner(queue, indices, kBuildSliceGrain, present)`).
- RAM-Puffer: `artifact_transport/ram_spool.hpp:1-23` — "Der RAM-SAMMELPUFFER der CEB: fertig kompilierte
  Binaries … als Objekt im RAM gehalten und erst beim AUSLOESER gebuendelt persistiert"
  (`kMaxSpoolBytes` 256 MB / `kSpoolCountTrigger` 12; IO im SpoolWriter-Thread, io_uring/portable-Backend
  per `COMDARE_WRITER_BACKEND`, apps-CMakeLists:31-45). **Luecke**: das Modul
  `builder/in_memory_measurement_buffer/` ist ein LEERER Platzhalter (.gitkeep) — der 4096er-RAM-Puffer
  existiert fuer BAU-Artefakte, nicht als eigener Messwert-RAM-Puffer (Messwerte laufen ueber
  result.csv/MeasurementSinkFn, s. 4.4).

---

## 4. BAU + MESSEN (SOLL-Glied 5, Teil 2)

### 4.1 Tier-Binary-Kompilation durch die CEB — REAL, direkter Compiler-Subprozess (kein CMake im Live-Pfad)

- `build_orchestrator/build_orchestrator.hpp:1-16`: KF-16/16b — "multithreaded Bereitstellung der
  Tier-Binaries VOR den Experimenten, RAM-gewahr + inkrementell-resumierbar … baut ZUERST ALLE DLLs →
  MISST DANACH … ersetzt die CMake-Glob-Loop". `BuildConfig` (:60-110): cores_per_build=4,
  RAM-Admission (ram_per_build_bytes/safety_margin), `.version`-Sidecar-Resume (`build_version`),
  Varianten-Signatur-Gate (`build_variant_sig`, G2-3), W6 `build_parallelism`-Override
  (`COMDARE_BUILD_PARALLEL`), SIMD-Bau-Gate + organ_required-Aggregation (:22-23 Includes).
- Der reale Compiler-Aufruf: `make_gpp_compile_fn` (:749-793) — g++ (Default `g++-16`) via
  Response-File `@rsp` + `posix_spawnp(argv)` (KEIN /bin/sh-String), `-std=c++23 -fPIC -shared
  [-fno-gnu-unique]`, opt_flag von der Facade/Planer-Achse gespeist, Ausgabe `perm_<id>.so` +
  `.cxx.log`; MSVC-Spiegel `make_system_compile_fn` (:729-747, `cl /LD`); Fehlerklassifikation
  ToolchainFehlt/ProzessStart (:344-346). CompileFn/SourceGenFn/FreeRamFn sind injiziert (:15).
  (Die Legacy-Demo-Strecke nutzt stattdessen `cmake --build` via `std::system`,
  experiment_driver.cpp:279-291 — zwei Welten, sauber getrennt.)
- Quellen-Generierung je Tier: `experiment_tree/ceb_generator.hpp` — ZWEI PFADE explizit getrennt (:4-19):
  (1) `generate_perm_source/generate_all` = String-Pfad-Manifest + Diagnose-Stub ("perm_run misst
  NICHTS", :62-97); (2) `generate_all_real<Engine>` = der REALE BR-4-Anatomie-Emitter via
  `codegen::emit_adhoc_modules<Engine>` (typ-getrieben, `COMDARE_DEFINE_ANATOMY_MODULE_ADHOC`, :116-128).

### 4.2 GTest-PRUEFSTAND am Pruef-Dock VOR der Messung — Pruefstand REAL, aber NICHT GTest

- `pruef_dock/pruef_dock.hpp:1-16`: je Anatomie-Gattung EIN Prüf-Dock (SearchAlgorithm/Set/Sequence/
  Adapter/View); IPruefDock ist KEINE ABI-Grenze (lebt im Builder-Binary); die ABI-Grenze ist das
  gattungs-eigene Antriebs-Sub-Interface (bidirektional: Antrieb hinein via `IDriveableTier`/
  `acquire_search_algorithm_drive`, Mess-POD heraus).
- Reihenfolge bindend VOR der Messung: `pruef_dock/conformance_gate.hpp:1-9` — "JEDE geladene
  Tier-Binary muss VOR der Messung die std::map-Huellen-Konformitaet ihrer Gattung ueber ALLE
  Randfaelle bestehen … Reihenfolge bindend: import → GATE → (nur bei pass) messen." Oracle =
  `std::map<uint64,uint64>` (:12-32), Quoten-Ergebnis `ConformanceResult` (:35-40);
  `dock_status_conformance_failed` (pruef_dock.hpp:41-42).
- Sequenzierung: `pruef_dock_sequencer.hpp:56-87` `measure_genus_sequential` — stabile Gruppierung nach
  im-Modul-deklarierter Gattung, je Handle Dock-Auswahl + Messung, D2-Fehlerklassen daneben.
- Standalone-Pruef-Modus: `pruef_dock/pruef_only.hpp:28-40` `run_so_conformance_gate` (Load → Drive →
  Gate, kein Bau/keine Messung) = das, was `COMDARE_PRUEF_ONLY=true` im Batch-Job je Perm NACH der
  Fenster-Schleife faehrt (director:1177-1196, `[PRUEF-TESTAT]`).
- **Luecke vs SOLL**: kein GTest im Pruefstand — es ist ein eigenes std::map-Oracle-Gate (grep gtest in
  pruef_dock/: 0 Treffer). GTest existiert im Repo nur in der tests/-Suite.

### 4.3 workload_driver / Mess-Ablauf

- `builder/workload_driver/`: `workload_generator.{hpp,cpp}` (YCSB A-F), `load_profile_parser/writer`,
  `workload_config.hpp`, `workload_orchestrator.hpp`, `workload_profiles.hpp` — die "WIE gemessen
  wird"-Bibliothek; Mess-Vollzug je (Binary x dyn-Setting) via `harness/perm_runner.hpp`
  (`run_observable_perm`/`format_perm_result`) im Iterator (iterator:34, Kopf :16-20); 18-Segment-
  Workload-Parameter in LazyRunConfig (seg_ops_per_batch=4000, seg_batches=32, workload_seed=42,
  iterator:~118-131). Mess-Parallelitaet: nur Debug-Methodik parallel (`parallel_measure_pool.hpp`,
  `resolve_measure_parallelism`), Mess-Modus 1-Thread (LazyRunConfig-Doku; Ledger §32-F7 in
  build_orchestrator.hpp:76-84).

### 4.4 Ergebnis-Rueckschrieb — durch die CEB selbst, aber CSV+Bestandslog-XML, nicht "ans XML-Ziel"

- Per-Binary: `result.csv` + `result.csv.stamp` im per-Binary-Unterordner, mit Resume-Pruefung
  (iterator:871-940) und Fehlbau-Sichtbarkeit als Marker-Zeile/`result.csv.stale` (iterator:1690-1795 —
  Doktrin "Mess-Fehler => CSV 'failed' + Log", auch in der YAML: director:1216-1218 `allow_failure: true`).
- Je Zelle: "run_profile MISST und schreibt EIN CSV je Zelle nach measure_out/<slug>/perm<idx>"
  (director:1201-1206, Mess-Batch); E4-Experiment-Weg: "DIE EINE offizielle CSV e4_xml/measurements.csv"
  (Code/02_messung_driver/main.cpp:1432-1436).
- Transport-Naehte (synchron an der per-Binary-Naht, No-Op-Default): `CachePushFn` (perm.so → Objekt-Store)
  + `MeasurementSinkFn` (result.csv → measure-drop) (iterator:180-193); async nur der BAU-Artefakt-Pump
  (`AsyncPushPump`, W11 §43.c).
- Bestandslog-Rueckschrieb (XML, MinIO): `bestandslog/messwert_registrierung.hpp:1-20` — der produktive
  Schreiber des measurement-Genus (load/observe/flush, doc_revision monoton); Dokumentform =
  deterministisches XML mit Byte-Roundtrip (`bestandslog_document.hpp:1-20`, ZWEI Genera binary|measurement).
- **Praezisierung vs SOLL "Rueckschrieb ans XML-Ziel"**: die CEB schreibt SELBST (nicht ueber das
  Experiment-Dock — der Rueck-Kanal ist ausdruecklich messdatenfrei, s. 5.), aber die Ziele sind CSV-Dateien
  (result.csv / measure_out / measurements.csv) + das Bestandslog-XML-Inventar; ein Rueckschrieb in die
  Anwender-/Experiment-XML selbst findet nicht statt.

---

## 5. STATUS-PIPE an den Planer (SOLL-Glied 4 Rueck-Kanal + 5)

- **§38-Rueck-Kanal = sparser Fortschritts-Cursor, KEINE Messdaten — BESTAETIGT**:
  `experiment_dock_payload.hpp:11-15` — "ProgressDelta = der Fortschritts-Rueck-Kanal. Erste Meldung
  eines Fensters = Voll-Konfiguration, danach mixed-radix-minimale Deltas …; done=true genau einmal am
  Fensterende. KEIN Mess-Daten-Rueckfluss." PODs kanonisch in
  `builder/experiment_tree/progress_delta.hpp`; Injektions-Naht `ProgressSinkFn` in `LazyRunConfig`
  (iterator:197, Feuerpunkte :1463-1476), durch die Facade durchgereicht
  (`profile_run_facade.cpp:607-611, 1124-1128`).
- **Konsument ist der Treiber, nicht ein residenter Planer-Prozess**: `Code/02_messung_driver/main.cpp:
  1408-1428` — der Treiber baut den ProgressSink selbst: zeit-gedrosselte `[progress]`-Zeilen nach
  stderr + append in eine `progress.cursor`-Datei. Dazu `[heartbeat]`-Zeilen
  (`progress_heartbeat.hpp:42-98`, geflusht, zeit-+zaehl-gated, `COMDARE_HEARTBEAT_EVERY`) und die vom
  Planer-emittierten Shell-Testate `[BATCH-BAU]/[BAU]/[TESTAT]/[FEHLER-TESTAT]/[PRUEF-TESTAT]`
  (director:1142-1196) mit `fenster=START:COUNT offen=…` — der "Cursor" der Shell-Ebene.
- **IST**: "CEB piped Status an den Planer" ist realisiert als Status-Emission in CI-Trace/stderr +
  Cursor-Datei + Artefakt-Logs (`gn_out/<slug>/<host>/logs/`, Artefakt-Deklaration director:1191-1196),
  die der Planer/Owner NACHTRAEGLICH liest. Es gibt keinen lebenden Prozess-Pipe/IPC-Kanal zu einer
  laufenden Planer-Instanz — der Planer ist kein Daemon, sondern emittiert Text und endet.

---

## Ehrliche Luecken-Zusammenfassung (IST vs SOLL 3/4/5)

| SOLL | IST-Befund | Beleg |
|---|---|---|
| (3) CEB = vom Planer generierte+hart-kompilierte Binary je Messsystem | NEIN. Zwei statische Targets: `cache_engine_builder` (Demo, gated) und `comdare-messung-driver` (LIVE-CEB-Rolle). Planer-Job REKOMPILIERT den Treiber nur (CMAKE_BUILD_TYPE aus Plan); Messsystem-Differenzierung per Env `COMDARE_MEASUREMENT_COMBO` in dieselbe Binary; "EINE Binary in zwei Rollen" ist selbst-dokumentiert | director:903-905, 1112-1121; apps-CMakeLists:8-29 |
| (3) System-Achsen-Versionierung | Teilweise: `ceb_version_stamp` = Mess-Angebot+SHA512, bewusst zellwertfrei; CEB-TYP = Mess-Kombination [a,b,c] als Legende | ceb_version_stamp.hpp:2-5, 166-178 |
| (3) Mess-CEBs sequentiell (§38.b) | JA, via resource_group je Host + 1-Thread-Messpolitik | director:1101-1103, 1209-1212 |
| (4) aufgeschluesselter Teilbaum (Ranges je Achse) per Serialisierung | Code existiert (AxisRangeEntry/ExperimentSubtreePayload + Roundtrip), aber DEPRECATED/inert; LIVE = Env-Einzelwerte + lineares Index-Fenster + XML-Re-Read durch die CEB | experiment_dock_payload.hpp:58-64; director:1156-1171 |
| (4) TEXTEMISSION statt .so-ABI (R1, bewusst deferred) | BESTAETIGT, als "Band-C DEFERRED (Task #19)" im Code markiert | experiment_dock_payload.hpp:61-64 |
| (4) Rueck-Kanal sparser Cursor ohne Messdaten | JA (ProgressDelta/ProgressSinkFn, "KEIN Mess-Daten-Rueckfluss") | experiment_dock_payload.hpp:11-15; iterator:1463-1476 |
| (5) Command-Pattern | Nur Rest-Insel (V32-Ausnahme, default OFF); Live-Nachfolger = compile-time AxisCommand + Iterator-Treiberfunktionen | i_command.hpp:2-7 |
| (5) lazy Permutation | JA (StaticBinaryView O(K), RuntimeVariableLoop) | iterator:1-27 |
| (5) Batch 4096 CEB-intern | JA (kGnBatchSlice==kBuildSliceGrain==4096, SlicePlanner/Queue) | director:542; planer_driven_build.hpp:45-46; iterator:1044-1065 |
| (5) RAM-Puffer | Fuer BAU-Artefakte ja (ram_spool 256MB/12); eigener Messwert-RAM-Puffer nur leerer Platzhalter | ram_spool.hpp:1-23; in_memory_measurement_buffer/.gitkeep |
| (5) GTest-Pruefstand VOR Messung | Pruefstand ja, GTest nein: std::map-Oracle-Konformitaets-Gate, Reihenfolge import→GATE→messen bindend; COMDARE_PRUEF_ONLY-Standalone | conformance_gate.hpp:1-9; pruef_only.hpp:28-40 |
| (5) Rueckschrieb durch CEB selbst | JA (result.csv+stamp, CSV je Zelle, MeasurementSinkFn, Bestandslog-measurement-Genus-XML), NICHT ueber den Dock-Rueck-Kanal; aber Ziel ist CSV/Bestandslog, kein Rueckschrieb in die Anwender-XML | iterator:180-193, 871-940; messwert_registrierung.hpp:1-20 |
| (5) Status-Pipe an Planer | Als Trace-/stderr-/Cursor-Datei-Emission, kein lebender IPC zu einem Planer-Prozess | main.cpp(driver):1408-1428; progress_heartbeat.hpp:42-98 |
