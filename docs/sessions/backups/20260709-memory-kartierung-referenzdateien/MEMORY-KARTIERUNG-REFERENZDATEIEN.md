Ich habe jetzt die vollständige Kartierung. Alle Kern-#31-Dateien sind verifiziert; nur die zwei SYNTHESE-Namen `source_catalog.hpp`/`profile_run_entry.hpp` existieren nicht verbatim (nächste reale Dateien: `pilot_source_map.hpp`, `profile_to_tree.hpp`/`registry_to_axis_levels.hpp` im selben `experiment_tree/`-Verzeichnis). Hier die strukturierte Kartierung.

---

# Kartierung: gesicherte Memories → #31 (Mess-Frameworks × Workloads als 2D-Matrix)

## Kernbefund vorab
Der User-Hinweis „cache-engine-Memories findest du wohl nichts" ist **widerlegt**: die cache-engine trägt einen umfangreichen `docs/architecture/`- und `docs/sessions/`-Bestand, und der Super-Repo enthält das **autoritative #31-Plandokument** plus einen **taggleichen (2026-07-09) Chef-Architekt-Review** des laufenden #31-Baus. #31 wird **aktiv heute** bearbeitet — `workload_matrix.hpp` trägt im Kopf die Kennung „#31-Schritt-2, 2026-07-09".

---

## (a) Relevante Memories/Dokumente + Kernaussage

### Super-Memory-Sicherung (`docs/HANDOVER-ANHANG-MEMORIES-20260705/`)
- **`feedback_command_pattern_achsen_mess_visitor_container_in_sa.md`** (37 KB) — Die drei bindenden User-Direktiven 02.07.: (CMD-1/#251) Command-Pattern-Basis-Interface aller Achsen per Metaprogrammierung, das die **Mess-Achsen als Visitor** mitführt (= „Limitations-Interface", Mess-Visitor nur bei `COMDARE_MEASUREMENT_ON`); (CMD-2/#252) Container-Gattung IN der SA-Messung aufschlüsseln; (#224) `container_`→`container_algorithm_`-Rename.
- **`feedback_baseline_system_in_stein_gemeisselt_layering.md`** — Baseline-Schichtung (`baseline_0..N`, `n→n-1`) in Stein gemeißelt; Produkte erben aus generischen Modules — der Rahmen, in dem die #31-2D-Matrix als Modul entstehen muss (INV-1..4).
- **`feedback_prod_ci_measurement_multiday_experiment.md`** — Mess-Pipeline 286 (`build:amd/intel`→`measure:amd/intel`, PMC über 320 `.so`) = mehrtägiges Experiment, passiv beobachten; bleibt bei #31 unberührt.
- **`project_cache_engine_research_vs_cacheengine_all_split_todo.md`** — cache-engine = Forschungsrepo (CI 286); `Modules/comdare-cacheengine-all` = künftiges Inventar-Zuhause; Split deferred. Verortet, wohin #31-Module perspektivisch wandern.
- **`feedback_thesis_universelle_baum_anatomie_und_prinzipsuche.md`** — Aufgabenstellung = **Suche eines Prinzips**, cache-line-Verhalten an vielen strukturellen Stellen fair zu **messen/auswerten**; 19 Achsen / 5 Gattungen. Der wissenschaftliche Rahmen von #31.
- **`feedback_thesis_divide_and_conquer.md`** — Pipeline-Stufen als `XX_operation/`-Module mit Doku+Tests+Fixtures. Erklärt die 7 Super-Pipeline-Stufen (`01_sample_data_generator`…`07_tier_binary_report`).

### cache-engine `docs/architecture/`
- **`24_messmodell_korrektur_zwei_dimensionen.md`** (52 KB) — **DER 2D-Kern-Doc**: die Messung hat zwei Dimensionen (Lebewesen-Wall-Clock vs. Per-Achsen-Observer `observe_all`) + Achsen-Vergleich; §8 HYBRID (Pfad A DLL-selbst / Pfad B host-zentral); §8.8 **Prüf-Dock** (per-Gattung ABI-Mess-Übergang der CacheEngineBuilder).
- **`messarchitektur_v5_drei_profile.md`** — **Build-Profil ⊥ Lastenprofil** = die zwei Haupt-Experiment-Achsen (kartesisches Kreuz); Compile-Release-Profil ist nur Schalter. Die knappste Definition der 2D-Matrix + Ebenen-Trennung.
- **`31_observer_interface_konsolidierung_i1.md`** — GENAU EINE Observer-Schnittstelle (`IObservableTier::tier_observe`), POD `axis_stats[19][8]+seg_ns[19]` (`kV3AxisSchema`); Pfad A (`IMeasurableWorkload`) bleibt getrennt. Das ist der reale „Mess-Visitor".
- **`32_lastprofil_katalog_und_paper_bias.md`** — 14 Lastprofile (→ `load_profiles/*.xml`) als Werte der dynamischen **Workload-Achse 2**; jedes Profil muss über ALLE Lebewesen laufen (Paper-Bias-Bruch).
- **`22_f15_messpipeline_und_such_bibliothek.md`** — F15-Pipeline end-to-end (adhoc_emitter→DLLs→Loader→run_workload→Welch/MWU/Cliff's δ); §3.2/§3.3 die zweidimensionale Messung (search × allocator × layout).

### Super `docs/` (die eigentlichen #31-Steuerdokumente)
- **`docs/architektur/15_F7_mess_frameworks_workloads_2d_matrix_plan.md`** — **DAS autoritative #31-Plandokument** (F7). Definiert Achse M (Mess-Kategorien) × Achse W (Workloads), Struktur-Fork Option A/B/C, **Empfehlung Option A** (compile-time-Parametrisierung IN den Baseline-Zellen von `comdare-measurement-all`).
- **`docs/sessions/backups/20260709-wf-architektur-4schichten-workloads/SYNTHESE.md`** — **Chef-Architekt-Kritik am aktuellen #31-Bau** (taggleich): benennt jede Schlüsseldatei mit datei:zeile; Verdikt „M compile-time korrekt, W/D müssen runtime sein, Hybrid ist deklariert aber nicht verdrahtet".
- **`…/kartierung_5_workload-subsystem-ist.md`** — IST-Kartierung: `workload_matrix.hpp` ist **toteliegend** (einziger Consumer = `test_31_workload_matrix.cpp`), der Produktiv-Pfad läuft über Runtime-Strings.
- **`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`** (F7, Z.298/369e/371) — #31-Historie: Schritt-1 (WorkloadKind-Reuse), Schritt-1b (Dataset-Achse), **Hybrid-Auflösung** (User 08.07.: „NICHT rein compile-time, Option A verworfen"), TABU `permutation_axes.xml`.
- **`Code/02_messung_driver/README.md`** — die Ebenen-Naht: „**Bridge zwischen Diplomarbeit-Konfiguration (`messreihen.xml`) und cache-engine V32 Command-Pattern**".

---

## (b) Konkrete Referenzdateien je Belang (verifizierte reale Pfade)

Alle Pfade relativ zu `…/Code/external/comdare-cache-engine/` (cache-engine) bzw. `…/probst-diplomarbeit-cache-engine/` (super).

### Der Mess-Visitor / Observer (Pfad B + Pfad A)
| Symbol / Rolle | Datei |
|---|---|
| `IObservableTier` + `tier_observe(ComdareTierObserverSnapshot*)` + `kV3AxisSchema` (der EINE konsolidierte Mess-Visitor, Pfad B) | `libs/cache_engine/anatomy/observable_tier.hpp` |
| `IMeasurableWorkload::run_workload*` + `seg_ns[19]` (Pfad A, isolierte Achse) | `libs/cache_engine/anatomy/measurable_workload.hpp` |
| `SearchAlgorithmAbiAdapter` (füllt POD aus getriebenen Organen; genus-typisierter ABI-Adapter) | `libs/cache_engine/anatomy/abi_adapter.hpp` |
| `observe_all()` / `ObserverAggregate` (Per-Achsen-Statistics) | `libs/cache_engine/anatomy/search_algorithm_anatomy.hpp` |
| `AnatomyExecutionContext::observe_all()` (Pfad B in-process) | `libs/cache_engine/builder/anatomy_commands/anatomy_execution_context.hpp` |
| `drive_tier_observe_trace` / `_abi` (Füllstand-Treiber r/w/d + Observer-POD ziehen) | `builder/anatomy_commands/tier_observe_trace.hpp` + `tier_observe_trace_abi.hpp` |
| `ComdareMeasurementSnapshotV1` (16+6-Spalten-POD, `pmc_available`-Gate) | `libs/cache_engine/builder/measurement_snapshot.hpp` |

### Die Achsen-Command-Basis
| Symbol / Rolle | Datei |
|---|---|
| `WorkloadKind`-Enum + `struct Workload` (EE-Command-Datenmodell, REUSE-Basis) | `libs/cache_engine/builder/commands/workload.hpp` |
| `IExecutionEngine` (Basis der Organ-Achsen laut CMD-1-Direktive „IExecutionEngine als Basis") | `libs/cache_engine/execution_engine/…` + `include/cache_engine/abi/cache_engine_execution_engine_adapter.hpp` |
| Command-/Visitor-Ist-Bausteine (grep-belegt) | `search_algorithm_anatomy.hpp`, `include/cache_engine/platform/workload_model.hpp`, `result_aggregator.hpp`, `apps/cache_engine_builder/main.cpp` |

> Anmerkung: Das Command-Basis-Interface aus CMD-1 (#251, `algorithm_visitor`-Platzhalter, ICommand/IStrategyCommand-Konsolidierung) ist laut Memory **noch Design** — es ist die geplante Formalisierung der verstreuten Ist-Bausteine, kein fertiges einzelnes File.

### Die Mess-Frameworks / -Kategorien (Achse M)
| Symbol / Rolle | Datei | Status |
|---|---|---|
| `measurement_category_list` (16 Kategorien als `mp_list`) + `MeasurementRegime{Observer,Counter,Derived}` + `category_regime`/`category_needs_pmc` (**Achse M**, #31-Schritt-2) | `libs/cache_engine/include/cache_engine/measurement/measurement_category_axis.hpp` | **NEU, korrekt** |
| `enum class MeasurementCategory` (Bestands-Enum, REUSE) | `libs/cache_engine/include/cache_engine/measurement/measurement_category.hpp` | vorhanden |
| Modul-Zuhause `comdare-measurement-all`: `comdare-metrics`(b0: `IMeasurementObserver`, `LatencyHdrHistogram`), `comdare-pmc`(b1: `IPmcSource`), `comdare-workloads`(b2), `baseline_3-analysis`(leer) | (Firmeninventar, Doc 15 §1) | b0-b2 live, b3 geplant |
| Domain-3 Mess-Bausteine + Dataset-Lader | `libs/common/measurement/` + `libs/common/measurement/dataset_loader/{dataset_akte,dataset_loader}.hpp` | vorhanden |

### Workload-/Profile-Struktur (Achse W + Achse D)
| Symbol / Rolle | Datei |
|---|---|
| 21 Lastprofil-XMLs (`ycsb_a..f`, `lp_*`, `coco_p04_neg{0,25,50,75,100}`, `ih`, `lh`) + Schema | `libs/cache_engine/algorithm_profiles/load_profiles/*.xml` + `SCHEMA.md` |
| `parse_load_profile` / `discover_load_profiles` (Runtime-XML→Config, Verzeichnis=Wertemenge) | `builder/workload_driver/load_profile_parser.hpp` |
| `WorkloadConfig` (Runtime-POD: seed/ops/op-mix/key-dist/neg%) | `builder/workload_driver/workload_config.hpp` |
| `profile_by_name` (String-Token→WorkloadConfig; `"A".."F"/"IH"/"LH"`) | `builder/workload_driver/workload_profiles.hpp` |
| `WorkloadGenerator` (xorshift64, bit-identisch je Seed) | `builder/workload_driver/workload_generator.{hpp,cpp}` |
| `WorkloadOrchestrator` + `MeasurementPlan{vector<WorkloadConfig>}` + `run_measurement_plan` (**V5-I9**) | `builder/workload_driver/workload_orchestrator.hpp` |
| `run_workload_perm` (löst Runtime-`workload_id`→Config auf) | `builder/experiment_tree/perm_runner.hpp` |
| `CanonicalDataset` (6er-Kanon url/dna/protein/xml/tpcds-id/trec-terms) — Achse D | in `workload_matrix.hpp` + `libs/common/measurement/dataset_loader/` |
| SOTA-/Permutations-Profile (super-Seite) | `Code/experiment_config/{messreihen,config_a_prt_art_vs_sota,config_b_cache_engine_perms,config_c_merge_alt_neu}.xml` |

### Die 2D-Matrix
| Symbol / Rolle | Datei |
|---|---|
| **DAS #31-File**: `ycsb_profile_list`(W, 6) / `workload_profile_list`(8) / `dataset_list`(D, 6) / `matrix_cells = mp_product = 48` / `config_for`+`ycsb_token` (Hybrid-Brücke) | `builder/workload_driver/workload_matrix.hpp` |
| Vorgesehener Framework×Workload-2D-Ort (**leeres Skelett**, nur `CMakeLists.txt`) | `builder/measurement_matrix/` |
| LAYER-1-Schalter `AxisLevel.is_static` (compile-time `StaticAxisNode` vs. runtime `DynamicVariableNode`), `binary_count()=∏` | `builder/experiment_tree/experiment_tree.hpp` |
| LAYER-2-Naht `run_lazy_static_then_dynamic` (compile-time-Typuniversum + runtime-Auswahl) | `builder/experiment_tree/cache_engine_builder_iterator.hpp` |
| `RuntimeVariableLoop` (kartesische for-Schleife auf EINER geladenen Binary) | `builder/experiment_tree/runtime_variable_loop.hpp` |
| BuildSelection `select_full/one_wise/explicit/pinned` | `builder/experiment_tree/coverage_selection.hpp` |
| Emitter Typ→Source je Komposition | `builder/codegen/adhoc_emitter.hpp` |
| Prüf-Dock (per-Gattung Mess-Übergang) | `builder/pruef_dock/{pruef_dock,search_algorithm_dock,pruef_dock_registry,pruef_dock_sequencer}.hpp` |
| Tests | `tests/unit/test_31_workload_matrix.cpp` + `test_31b_measurement_category_axis.cpp` |

---

## (c) Ebenen-Trennung + architektonische Verortung von #31

Es gibt **zwei Ebenen-Trennungen**, beide belegt:

**1. Laufzeit-Pipeline (Diplomarbeit stellt bereit / cache-engine interpretiert):**
- **Super/Diplomarbeit = Bereitstellung + Orchestrierung.** `Code/02_messung_driver` (`V32Orchestrator`, `messreihe_v32_validator.hpp`, `plugin_loader.hpp`) liest die **Experiment-Konfiguration** (`experiment_config/messreihen.xml` = 4 Pflicht-Messreihen A/B/C, `config_a/b/c.xml`) und ist laut README explizit die „**Bridge zwischen Diplomarbeit-Konfiguration und cache-engine V32 Command-Pattern**". Die 7 `XX_operation/`-Stufen bilden die äußere Thesis-Pipeline.
- **cache-engine = Interpretation + Messung.** `load_profile_parser` parst die Lastprofile **zur Laufzeit** (SCHEMA.md wörtlich: „zur Laufzeit interpretiert `parse_load_profile`→`WorkloadConfig`"); `adhoc_emitter`+`permutation_engine` bauen die Tier-Binaries; das **Prüf-Dock** (Doc 24 §8.8) lädt/treibt/misst sie über die Gattungs-ABI. Die `load_profiles/*.xml` liegen physisch **in** der cache-engine (`algorithm_profiles/load_profiles/`).

**2. Modul-Architektur (wohin #31 gehört):**
- Doc 15 §1: `comdare-measurement-all` ist die generische Modul-Familie (`metrics`/`pmc`/`workloads`/`analysis`). Die feingliedrige **2D-Matrix (M×W) gehört dorthin als Option A** = compile-time-Parametrisierung IN den Baseline-Zellen (F6-Kopf-Framework mit Metaprogrammierungs-Interface), **NICHT** als Zell-/Repo-Explosion (Option B/C verworfen). Nach Migrationsplan-Schritt 13 (gated) „konsumiert die Diplomarbeit `measurement-all` statt der ce-Kopie".

**Die kritische Präzisierung der SYNTHESE (das eigentliche #31-Ziel — compile-time ⊥ runtime):**
- **Achse M (Mess-Frameworks/-Kategorien) = COMPILE-TIME** — reine **Spalten-Projektion** eines Snapshots, `mp_list`, **nie** ein `mp_product`-Faktor (sonst ×16-Läufe-Blähung). `measurement_category_axis.hpp` ist **korrekt** (Soll==Ist).
- **Achsen W (Workload) + D (Dataset) = RUNTIME**, lauf-multiplizierend, als dynamische `AxisLevel{is_static=false}` (getrieben von `discover_load_profiles`/XML) — **Drop-in ohne Rebuild**. Beleg-Direktiven: `messarchitektur_v5_design.md:100` („Lastenprofil hat absichtlich KEINE CMake-Flags = Runtime-Matrix-Achse"), `drei_profile.md:13`.
- **Der compile-time `workload_matrix.hpp` ist NUR ein Hybrid-Katalog-Begleiter** einer runtime-Achse (via `config_for`), **niemals** die Achse selbst und **niemals** in `binary_id`/`golden_fullpilot_320`/`permutation_axes.xml` (TABU, würde die golden 320 multiplizieren).
- **Aktueller Bau-Defekt:** Der Hybrid ist **deklariert, aber nicht verdrahtet** — `workload_matrix.hpp` ist toteliegend (einziger Consumer = `test_31_…`), `config_for` wird produktiv nie gerufen; Achse D hat **nur** die compile-time-Liste und **kein** Runtime-Rückgrat (Lücke A-G2).

---

## (d) Existenz-Check der Kern-Referenzdateien

**EXISTIERT** (verifiziert, source-only): `observable_tier.hpp` · `measurable_workload.hpp` · `abi_adapter.hpp` · `search_algorithm_anatomy.hpp` · `anatomy_execution_context.hpp` · `tier_observe_trace.hpp` · `tier_observe_trace_abi.hpp` · `measurement_snapshot.hpp` · `measurement_category_axis.hpp` · `measurement_category.hpp` · `workload_matrix.hpp` · `workload_config.hpp` · `workload_profiles.hpp` · `workload_generator.{hpp,cpp}` · `workload_orchestrator.hpp` · `load_profile_parser.hpp` · `commands/workload.hpp` · `experiment_tree.hpp` · `cache_engine_builder_iterator.hpp` · `runtime_variable_loop.hpp` · `coverage_selection.hpp` · `perm_runner.hpp` · `codegen/adhoc_emitter.hpp` · `anatomy_base.hpp` · `pruef_dock/*.hpp` · `permutation_engine.hpp` · `pruefling_merge.hpp` · `anatomy_module_abi_v1_decl.hpp` · `anatomy_module_loader.hpp` · `algorithm_profiles/load_profiles/*.xml` (21) · `dataset_loader/{dataset_akte,dataset_loader}.hpp` · Tests `test_31_workload_matrix.cpp` + `test_31b_measurement_category_axis.cpp` · super: `experiment_config/messreihen.xml` + `config_a/b/c` + 7× `XX_operation/`.

**LEERES SKELETT (existiert, aber unbefüllt):** `builder/measurement_matrix/` (nur `CMakeLists.txt`) — genau der in Doc 15 §1 als „leeres Skelett" markierte vorgesehene 2D-Ort. `baseline_3-analysis` (nur vorgesehen).

**NICHT VERBATIM GEFUNDEN** (SYNTHESE-Mis-Naming durch Workflow-Agenten): `source_catalog.hpp` und `profile_run_entry.hpp` existieren nicht so — nächste reale Dateien im selben `builder/experiment_tree/`: **`pilot_source_map.hpp`** (golden-320/CatalogAxes-Träger; `CatalogAxes` real auch in `anatomy/container_framework.hpp`) und **`profile_to_tree.hpp`** / **`registry_to_axis_levels.hpp`** (die Workload-AxisLevel-Injektion). Zeilennummern der SYNTHESE daher mit Vorsicht.

---

## Synthese: die Schlüssel-Dateien für die korrekte #31-Umsetzung

Für „Mess-Frameworks × Workloads in der richtigen Ebene" sind **diese Dateien load-bearing**:

1. **`docs/architektur/15_F7_mess_frameworks_workloads_2d_matrix_plan.md`** (super) — der verbindliche Bauplan (Option A, M×W, TABU-Grenzen). **Zuerst lesen.**
2. **`docs/sessions/backups/20260709-wf-architektur-4schichten-workloads/SYNTHESE.md`** (super) — die Korrektur-Empfehlung: M behalten, W/D runtime fahren, Hybrid via `config_for` verdrahten. **Die Arbeitsanweisung für den Fix.**
3. **`measurement_category_axis.hpp`** — Achse M (compile-time, korrekt; noch **unverdrahtet** an `measurement_snapshot.hpp`-Spalten-Selektor).
4. **`workload_matrix.hpp`** — Achse W×D Katalog; muss von „totem Manifest" zu echtem Hybrid werden (`config_for` in den Produktiv-Pfad einhängen).
5. **`load_profile_parser.hpp` + `workload_config.hpp` + `workload_profiles.hpp` + `workload_orchestrator.hpp`** — der reale Runtime-Workload-Kanal (W-Achse), der autoritativ bleiben muss (Drop-in ohne Rebuild).
6. **`experiment_tree.hpp` + `runtime_variable_loop.hpp` + `perm_runner.hpp` + `profile_to_tree.hpp`/`registry_to_axis_levels.hpp`** — die `is_static=false`-Injektion; hier fehlt die **D-Runtime-AxisLevel** (`discover_datasets` analog `discover_load_profiles`) — die größte offene Lücke.
7. **`measurement_snapshot.hpp` + `observable_tier.hpp` (`kV3AxisSchema`)** — der Mess-Visitor/POD, dessen Spalten M projiziert.
8. **`builder/measurement_matrix/`** (leer) + `comdare-measurement-all` — das perspektivische Modul-Zuhause der 2D-Matrix (Baseline-Struktur, gated).
9. **`messarchitektur_v5_drei_profile.md` + Doc 24 §8** — die Doktrin, an der jede Änderung zu prüfen ist (Build-Profil ⊥ Lastenprofil; Prüf-Dock).

**Leitsatz aus den Memories:** M = compile-time-**Projektion** (behalten), W/D = runtime-**Lauf-Achsen** (D neu als `is_static=false` anlegen), der compile-time-Katalog ist nur ein via `config_for` verdrahteter Begleiter — **nie** in `binary_id`/golden_320/`permutation_axes.xml`.