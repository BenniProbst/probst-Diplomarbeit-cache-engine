# KARTIERUNG: Profile-Interpretations-Bibliothek der cache-engine

Basis-Pfad `CE` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine` (alle `libs/…`- und `tests/…`-Angaben unten sind relativ dazu; die Thesis-Seite liegt unter `…/Code/02_messung_driver/`).

## Kernbefund vorab: die Bibliothek ist real, aber ZWEIGETEILT und die geplante „EINE Eintritts-API" ist noch NICHT als Lib-Target exportiert

Es gibt **zwei** Interpretations-Pfade, und die Diplomarbeit konsumiert derzeit den ALTEN:

- **NEU (deklarativ, profil-getrieben, „SOLL")**: `ThesisProfile → build_axis_levels → ExperimentTree → run_workload_perm`. Die Eintritts-API `run_profile()` liegt aber in `tests/unit/thesis_tiere/` (Harness), **nicht** in `libs/` — bewusst, weil sie den `all_axes_umbrella` zieht (`tests/unit/thesis_tiere/profile_run_entry.hpp:20-21`: „⚠️ Katalog-/Umbrella-schwer … gehoert in die HARNESS-/Test-.cpp, NICHT in den engine-agnostischen Treiber-Header").
- **ALT (REV 7.6, tatsächlich verlinkt)**: `Code/02_messung_driver/main.cpp:28` inkludiert `experiment_driver/experiment_driver.hpp`, `Code/02_messung_driver/CMakeLists.txt:14` verlinkt `comdare_builder_experiment_driver` (Phase-1–7-Pipeline). Dieser Pfad liest die alten 4 XML-Sätze und nutzt einen **anderen** WorkloadConfig-Typ.

---

## Frage 1 — Konkrete API/Bibliothek je Aufgabe (exportierte CMake-Target-Grenze)

### (a) Profil-XML-Parsen → Target `comdare_builder_xml_config_parser` (PROJECT COMMON)
`libs/common/serialization/xml_config_parser/`
- Self-contained DOM-Reader (kein tinyxml2, FortiGate-Offline): `comdare::common::xml::parse_document(string_view) → optional<XmlNode>` — `xml_reader.hpp:194`; `XmlNode` mit `child/children_named/attr/text_tokens` — `xml_reader.hpp:21-55`.
- Thesis-Profil-Parser: `comdare::builder::xml::XmlConfigParser::parse_thesis_profile(path) → optional<ThesisProfile>` — Deklaration `xml_config_parser.hpp:195`, Body `xml_config_parser.cpp:200-290+`. Wurzel-Tag `comdare_thesis_profile`.
- `struct ThesisProfile` — `xml_config_parser.hpp:151-181` (Felder: `base_tiers`, `permute_axes`, `workloads`, `telemetry_mode`, `thread_counts`, `hw_prefetcher`, `repetitions`, `modes`, `working_set_sweep`, `axis_sweeps`, `sota_series`, `run_options`).
- Legacy-Seite desselben Targets: `XmlConfigParser::parse/load_sota_profiles/load_messreihen → CacheEngineConfig` (`xml_config_parser.hpp:183-191`) für die alten `cache_engine_permutations.xml / … / test_data_sets.xml`.

### (b) Workload-Interpretation → Target `comdare_workload_driver` (PROJECT CACHE_ENGINE, alias `comdare::workload_driver`)
`libs/cache_engine/builder/workload_driver/`
- `struct WorkloadConfig` — `workload_config.hpp:99-146` (seed, num_operations, key_min/max, op-mix pct_*, `KeyDistribution`, zipfian_theta, negative_query_pct, scan_length_max); `WorkloadOp`/`WorkloadOpKind` `:77/:26`; `KeyDistribution` `:46`.
- YCSB-Treue-Fabriken `make_ycsb_c/d/e/f`, `make_mixed_a/b`, `make_insert_heavy/lookup_heavy` — `workload_config.hpp:153-281`.
- **Lastprofil-XML → WorkloadConfig**: `parse_load_profile(path) → optional<LoadProfile>` — `load_profile_parser.hpp:74`; Wurzel-Tag `comdare_load_profile`; `struct LoadProfile` `:31-39`.
- **Achse-2-Wertemenge**: `discover_load_profiles(dir) → vector<pair<id,path>>` — `load_profile_parser.hpp:122`.
- Token→Config-Fallback (Single-Source): `profile_by_name(tok, seed, ops)` — `workload_profiles.hpp:23`.

### (c) Experiment-Durchführung — ZWEI Engines
**NEU (header-only, in `libs/`, engine-agnostisch):**
- Baum-Kern: `ExperimentTree`, `struct AxisLevel` (`experiment_tree.hpp:189`), `struct DynamicDim` (`:198`), `StaticBinaryView` — `libs/cache_engine/builder/experiment_tree/experiment_tree.hpp`.
- Brücke Profil→Baum: `build_axis_levels(tp, mode, registry) → vector<AxisLevel>` — `experiment_tree/profile_to_tree.hpp:25`.
- Mess-Iterator: `run_lazy_static_then_dynamic(...)`, `struct LazyRunConfig` (`cache_engine_builder_iterator.hpp:55`, Feld `workload_configs` `:84`, `workload_records` `:80`), `lazy_csv_header/format_csv_row`.
- Treiber je Binary×Setting: `run_workload_perm(...)` — `experiment_tree/perm_runner.hpp:211` (Registry-Lookup, Fallback `profile_by_name` `:229`), `run_observable_perm` (Alt-Workload).

**ALT (kompiliertes Target `comdare_builder_experiment_driver`, alias `comdare::builder::experiment_driver`):**
- `class ExperimentDriver` Phase 1–7 — `experiment_driver/experiment_driver.hpp:75-119`; nutzt `WorkloadOptions{ workload_generator::WorkloadConfig, YcsbWorkload }` — `:70-73` (also den **test_infra**-Generator, nicht `workload_driver`).

---

## Frage 2 — Schnittstelle (Kette Profil-XML → Messung)

```
comdare_thesis_profile.xml  (z.B. m3v2_study.profile.xml)
  │  XmlConfigParser::parse_thesis_profile        [xml_config_parser.cpp:200]
  ▼
ThesisProfile                                     [xml_config_parser.hpp:151]
  │  build_axis_levels(tp, mode, registry)        [profile_to_tree.hpp:25]
  │    • permute_axes(active) → is_static=true  (compile-time, → binary_id)
  │    • runtime_dynamic       → is_static=false (thread_count/hw_prefetcher/repetition)
  ▼
vector<AxisLevel>
  │  run_profile(RunProfileArgs)                  [profile_run_entry.hpp:104]  (Harness)
  │    • drop_tier_level → build_profile_basis_levels [profile_runner.hpp:127]
  │    • Achse-2 als DYN-Ebene injizieren "workload.workload_id" [profile_run_entry.hpp:132-134]
  ▼
ExperimentTree.build → StaticBinaryView (binary_count rein arithmetisch, nie voll materialisiert)
  ║  parallel: Achse-2 Registry
  ║    discover_load_profiles(COMDARE_LOAD_PROFILE_DIR) [run_lazy_150.cpp:193-197]
  ║      → parse_load_profile je comdare_load_profile.xml → map<id,WorkloadConfig>
  ▼
run_lazy_static_then_dynamic(tree, sel, compile, union_gen, ram, cfg)  [iterator]
  │  je STATISCHE binary_id: lazy 1 DLL = 1 TU  (union_gen: source_catalog ∪ sota_catalog)
  │  je DYN-Setting (inkl. workload_id):
  │    run_workload_perm(...) [perm_runner.hpp:211]
  │      lazy_extract_workload_id → WorkloadConfig aus cfg.workload_configs [iterator:730-735]
  │      → WorkloadGenerator (deterministisch, xorshift64) → Zwei-Phasen-Warmup → PMC-Messung
  ▼
LazyMeasuredRow → CSV (lazy_csv_header; two_phase_valid-Spalte = Mess-Gültigkeit)
```

Konkrete Feld-Zuordnung Lastprofil-XML → WorkloadConfig (Beispiel `algorithm_profiles/load_profiles/ycsb_a.xml`): `<op_mix insert/lookup/erase/clear/scan/rmw>` → `pct_*` (`load_profile_parser.hpp:99-104`), `<key_distribution>` → `KeyDistribution` (`:108-109`), `<records>` → `key_max` (`:116`), Skala (`num_operations`/records) darf der Harness überschreiben (`:113-116`). Fehlendes/leeres `<op_mix>` → hart `nullopt` (`:97-107`, MAJOR-MESS-05: kein stilles Default).

---

## Frage 3 — Vollständig/geplant? Was fehlt?

**VOLLSTÄNDIG & funktional** (alles „schon geplant" bestätigt): (a) beide XML-Parser self-contained; (b) YCSB A–F treu (Op-Mix + Key-Verteilung als Definitionsmerkmal), deterministisch reproduzierbar, Negativ-Query-Sweep, Scan/RMW-Ops; (c) lazy per-Binary-Compile, Zwei-Phasen-Warmup, Resume, SOTA-Reihen-Pässe, CSV.

**Ehrliche LÜCKEN:**
1. **Eintritts-API nicht als Lib exportiert.** `run_profile`/`RunProfileArgs` (`profile_run_entry.hpp:104/51`), `profile_runner.hpp` (`load_thesis_profile:94`, `build_profile_basis_levels:127`, `profile_select:241`, `make_union_source_gen:62`), `source_catalog.hpp`/`sota_catalog.hpp` und der reale `main()` (`run_lazy_150.cpp:108`) liegen alle in `tests/unit/thesis_tiere/`. Konsumenten: nur `test_run_profile_union.cpp` + `run_lazy_150.cpp`. Die Thesis (`02_messung_driver`) verlinkt weiterhin die ALTE `ExperimentDriver`-Lib.
2. **Mess-Kategorie-Selektion: geparst, aber tot.** `<compile_dims><telemetry mode=on/off/leaf_sampled/all silent=…>` → `tp.telemetry_mode` (`xml_config_parser.cpp:229-231`), wird aber NIRGENDS im Baum-/Mess-Pfad konsumiert (grep: kein Verbraucher). Welche PMC-Counter/Observer aufgezeichnet werden, ist durch die kompilierte Binary + Host-PMC-Source (`pmc.get()`) fix, **nicht profil-wählbar**. (Achtung: die `permute_axes`-Achse `telemetry` ist etwas anderes — ein Compile-time-Organ, das WELCHER Counter-Code einkompiliert wird bestimmt; das wird konsumiert.)
3. **Keine Dataset-Achse.** Im Profil-Pfad existiert KEINE First-Class-Dataset-Dimension (grep in `profile_to_tree/profile_run_entry/profile_runner` leer). Datensätze sind reduziert auf (i) `working_set_sweep` = Record-ANZAHL (→ `key_max`) und (ii) `key_distribution ∈ {uniform,zipfian,latest}` aus dem Lastprofil-XML. Reale Korpora / lognormal sind **explizit unsupported → stiller Uniform-Fallback** (`load_profile_parser.hpp:66-70`). Der ALTE Pfad hatte `test_data_sets.xml` (`xml_config_parser.hpp:74`); der NEUE Thesis-Profil-Pfad hat die Dataset-Dimension fallengelassen.
4. **`tp.workloads` (compile_dims/workloads YCSB A..F) tot im Baum-Pfad** (grep leer); die LIVE-Achse-2 kommt aus `discover_load_profiles(COMDARE_LOAD_PROFILE_DIR)`, nicht aus dem Profil-`compile_dims`.
5. **Zwei divergente WorkloadConfig-Typen** nicht vereinheitlicht: `workload_driver::WorkloadConfig` (neu, Lastprofil-XML) vs. `workload_generator::WorkloadConfig` + `YcsbWorkload` aus `libs/test_infra/workload_generator/` (Target `comdare_workload_generator`, den die alte `ExperimentDriver` verlinkt).

---

## Frage 4 — Compile-time / Runtime-Grenze IN dieser Bibliothek

Die Grenze ist **exakt das Flag `AxisLevel::is_static`** (`experiment_tree.hpp:189-195`), gesetzt in `build_axis_levels` (`profile_to_tree.hpp`):

- **COMPILE-TIME** (`is_static=true` → Teil der `binary_id` → je Tupel eine EIGENE DLL, „1 DLL = 1 TU" lazy): die tier/Paper-Ebene (`profile_to_tree.hpp:32-36`) und ALLE `permute_axes`-Organ-Achsen — search_algo, node_type, memory_layout, migration_policy, filter, value_handle, path_compression, isa, allocator, telemetry-Organ, … (`:51-66`), plus die cacheline-Sub-Achsen line_size/alignment/sw_hint (`:53-57`, wörtlich „compile-time → statische Sub-Ebenen (Binary-Identität)"). **Das sind die Achsen-Algorithmen — compile-time, statischer Dispatch, kein Runtime-Switch.**
- **RUNTIME** (`is_static=false` → for-Schleife über DERSELBEN DLL, ändert `binary_id` NICHT): concurrency.thread_count, prefetch.hw_prefetcher, repetition.repetition_index (`profile_to_tree.hpp:75-86`) UND die Achse-2 workload.workload_id (`profile_run_entry.hpp:132-134`). **Workloads/Datasets aus den Profilen sind rein runtime**: `run_workload_perm` (`perm_runner.hpp:211`) schlägt die `WorkloadConfig` per `workload_id` aus `cfg.workload_configs` nach (`iterator:730-735`) und treibt die Op-Sequenz — dieselbe Binary, viele Workloads. Working-Set-N (`workload_records`) ist eine äußere Runtime-Schleife.

Explizit terminalisiert: „is_static=false ⇒ veraendert die binary_id NICHT (Round-Trip-Gate unberuehrt)" (`profile_run_entry.hpp:131`), abgesichert durch das Round-Trip-Gate gegen `golden_fullpilot_320_binary_ids.txt` (`profile_runner.hpp:13-17`). Damit ist die Grenze scharf und maschinell erzwungen: **Achsen-Algorithmen = compile-time (statische Ebenen → binary_id → DLL), Workloads/Datasets aus Profilen = runtime (dynamische Ebenen + WorkloadConfig-Registry-Lookup)** — konsistent mit „kein Runtime-Switch im Hot-Path" (der Workload-Antrieb ist die äußere Mess-Schleife, keine Hot-Path-Dispatch).

---

## Zentrale Datei-Anker (absolut)
- `CE/libs/common/serialization/xml_config_parser/xml_config_parser.hpp` (ThesisProfile:151, parse_thesis_profile:195) + `.cpp:200`
- `CE/libs/common/serialization/xml_config_parser/xml_reader.hpp` (parse_document:194)
- `CE/libs/cache_engine/builder/workload_driver/workload_config.hpp` (WorkloadConfig:99)
- `CE/libs/cache_engine/builder/workload_driver/load_profile_parser.hpp` (parse_load_profile:74, discover_load_profiles:122)
- `CE/libs/cache_engine/builder/workload_driver/workload_profiles.hpp` (profile_by_name:23)
- `CE/libs/cache_engine/builder/experiment_tree/profile_to_tree.hpp` (build_axis_levels:25 — COMPILE/RUNTIME-Grenze)
- `CE/libs/cache_engine/builder/experiment_tree/experiment_tree.hpp` (AxisLevel:189, DynamicDim:198)
- `CE/libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp` (LazyRunConfig:55, workload_configs:84)
- `CE/libs/cache_engine/builder/experiment_tree/perm_runner.hpp` (run_workload_perm:211)
- `CE/libs/cache_engine/builder/experiment_driver/experiment_driver.hpp` (ALT: ExperimentDriver:75)
- `CE/tests/unit/thesis_tiere/profile_run_entry.hpp` (run_profile:104, RunProfileArgs:51) — **nicht als Lib exportiert**
- `CE/tests/unit/thesis_tiere/profile_runner.hpp` (load_thesis_profile:94 u.a.) — **nicht als Lib exportiert**
- `CE/tests/unit/thesis_tiere/run_lazy_150.cpp` (main:108, Achse-2-Wiring:193) — realer Harness-Einstieg
- Thesis-Konsument (ALT): `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/02_messung_driver/main.cpp:28` + `CMakeLists.txt:14`
- Beispiel-Profile: `CE/libs/cache_engine/algorithm_profiles/thesis_profiles/m3v2_study.profile.xml`, `CE/libs/cache_engine/algorithm_profiles/load_profiles/ycsb_a.xml`