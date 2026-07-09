Ich habe das Dossier vollständig gelesen (workflow-result-full.json: `result.maps[0..3]` + `result.synth`, bestätigt durch workflow-script.js und journal.jsonl). Keine mutierenden Befehle ausgeführt.

# Quellen-Verankerung (Map→Layer, definitiv)

workflow-script.js baut `maps` via `parallel(layers.map(...))` (ordnungserhaltend); die Synthese-Vorlage verdrahtet LAYER 1=maps[0] … LAYER 4=maps[3] hart. 5 Agenten (4 Karten + 1 Synthese), 529 002 Tokens, 98 Tool-Calls. Wurzel aller Pfade: `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine` (= `BASE`), relativ meist `libs/cache_engine/` (= `LCE/`).

- **LAYER 1** = `maps[0]`, Agent-Key `experiment_tree`
- **LAYER 2** = `maps[1]`, Agent-Key `builder`
- **LAYER 3** = `maps[2]`, Agent-Key `anatomie`
- **LAYER 4** = `maps[3]`, Agent-Key `mess_achsen`

Wichtige Vorab-Präzisierung aus `result.synth:16-18`: Es sind **nicht** vier gleichrangige Hierarchie-Schichten, sondern „ein **Zwei-Ebenen-System plus eine orthogonale dritte (Mess-)Ebene**". Die vier Karten sind vier read-only-Kartierungs-Achsen desselben Baums; die eigentliche compile-time/runtime-Grenze läuft quer durch LAYER 1 und trennt LAYER 3 (compile-time) von LAYER 4 (runtime), zusammengezogen von LAYER 2.

---

# FRAGE 1 — Die vier Schichten (Name, Zweck, konkrete Typen/Dateien)

## LAYER 1 — `experiment_tree` (Knoten-Ebene: was ist compile-time vs. runtime)

**Zweck:** Definiert pro Achse als **Knoten-Eigenschaft**, ob sie Binär-Identität (compile-time) oder Mess-Variation (runtime) ist. Original (`maps[0]:7`): „Die Unterscheidung ist eine KNOTEN-EIGENSCHAFT (zwei Produkt-Typen einer GoF-Factory-Method, ein Creator `ExperimentNodeFactory`), NICHT eine Baum-Hierarchie — belegt `experiment_tree.hpp:27-34, 205-210`."

Konkrete Typen/Dateien (Zitate):
- **`StaticAxisNode`** (`experiment_tree.hpp:116-134`): „`kind()==NodeKind::Static`, `contributes_to_signature()==true` (Zeile 124), `is_runtime_loop()==false` (Zeile 126). `serialize()` → `"axis=value"` (Zeile 123). Genau diese Segmente bilden die `binary_id`. … JE Static-Pfad EINE eigene Tier-Binary (DLL)."
- **`DynamicVariableNode`** (`experiment_tree.hpp:138-155`): „`contributes_to_signature()==false` (Zeile 146), `is_runtime_loop()==true` (Zeile 148). `serialize()` → `"axis.var=value"` (Zeile 145). … VIRTUELLE for-Schleife über EINER bereits geladenen Binary; erzeugt KEINE neue Binary (Doc-Kommentar `runtime_variable_loop.hpp:2-9`)."
- **Der Schalter:** „das Flag `bool is_static` auf `AxisLevel` (`experiment_tree.hpp:189-195`, Default true)" mit `static_filter()` (`:342-347`) und `dynamic_filter()` (`:349-354`).
- **Identitäts-Trennung** (`maps[0]:23`): „`binary_id`/`pinned_signature` werden AUSSCHLIESSLICH aus `static_levels_` serialisiert (`StaticBinaryView::operator[]` `experiment_tree.hpp:266-288`; `for_each_binary` `:378-391`). Dynamische Dims fließen NICHT in die `binary_id`" — Belege `profile_to_tree.hpp:72-74` und `profile_run_entry.hpp:130-131` („is_static=false ⇒ veraendert die binary_id NICHT").
- **Heute STATISCH** (`maps[0]:42-45`): `search_algo`(4: k_ary/interpolation/eytzinger/linear_scan), `node_type`(4: node4/16/48/256), `memory_layout`(5: cache_line_aligned/aos_strict/soa/packed_bitmap/aosoa), `prefetch`(4: none/distance_estimator/hardware/path_oriented) = „**4·4·5·4 = 320**"; 15 Achsen je 1 Wert gepinnt.
- **Heute DYNAMISCH** (`maps[0]:47-51`): `concurrency.thread_count` (1 2 4), `prefetch.hw_prefetcher` (MSR-Toggle), `repetition.repetition_index` (0..2), `workload.workload_id`.
- **Workload-Anbindung** (`maps[0]:64-65`, DynamicVariableNode-Seite): `profile_run_entry.hpp:132-134`: `ex::AxisLevel{"workload", a.workload_values, /*is_static=*/false, "workload_id", "workload"}`.

## LAYER 2 — `CacheEngineBuilder` / `builder/` (die Naht)

**Zweck:** Der Orchestrator, der compile-time-Typuniversum und runtime-Auswahl zusammenzieht. Kern-Vorbefund (`maps[1]:7`): „Es gibt **keine** Klasse `class CacheEngineBuilder`. Der Name existiert nur als Banner/Kommentar." Verteilt auf:
- **Schicht A — Laufzeit/XML-Pipeline** (`maps[1]:9`): `comdare::builder::ExperimentDriver` (`builder/experiment_driver/…` + `codegen/codegen.hpp`), gefahren von `apps/cache_engine_builder/main.cpp` (main.cpp:177-178). Konfig-Objekt `ExperimentDriverOptions` (`experiment_driver.hpp:34-68`); Anatomie-Wahl „STRING/XML-getrieben" via `CodegenEngine::generate_module(...)` (`experiment_driver.cpp:155-159`).
- **Schicht B — Compile-time/typgetriebene Maschinerie** (`maps[1]:10`): Namespace `comdare::cache_engine::builder::experiment` (`builder/experiment_tree/*`, `codegen/adhoc_emitter.hpp`). „Die Datei, die *namentlich* der Builder ist — `experiment_tree/cache_engine_builder_iterator.hpp` — gehört zu B."

Die real gefahrene Funktion (`maps[1]:43`): **`run_lazy_static_then_dynamic(tree, sel, compile, gen, ram, cfg)`** (`cache_engine_builder_iterator.hpp:603-812`): „(1) Statisch-Iterator über `tree.static_binary_view()` + `BuildSelection` → `BuildOrchestrator` baut DLLs, auf `cfg.max_binaries` gekappt (`:613-639, 617-619`); (2) je DLL laden + `dynamic_cast` auf `IObservableTier`/`IResourceControllableTier` (`:691-702`); (3) Dynamisch-Iterator `loop.run(*ctrl, tree.dynamic_filter(), measure)` (`:773-782`)."

Die Naht selbst (`maps[1]:65-66`): „Compile-time fixiert das **Typ-Universum** (welche Organ-Implementierungen existieren + die feste 19-Slot-Anatomie-Form); Runtime wählt **welche Punkte** dieses Universums gebaut/gemessen werden und **wie**."

## LAYER 3 — Anatomie-Ebenen (Gattung/Genus/Typ — Binary-Identität)

**Zweck:** Das compile-time-Typuniversum + die Binary-Identität. Header-Doktrin wörtlich (`maps[2]:11`): „3-EBENEN-MODELL … korr. 2026-06-03 — vorher fälschlich ‚5 Gattungen'" (`anatomy_base.hpp:30-37`).
- **Ebene 1 `AnatomyGattung`** (`anatomy_base.hpp:40-44`): `enum class AnatomyGattung : uint8_t { SearchAlgorithm=0, Container=1, Graph=2 }` — „das Außen-Interface/Prüf-Dock".
- **Ebene 2 `AnatomyGenus`** (`anatomy_base.hpp:67-73`): `enum class AnatomyGenus : uint8_t { SearchAlgorithm=0, Set=1, Sequence=2, Adapter=3, View=4 }`; `gattung_of()` (`:89-98`) projiziert Ebene-2→Ebene-1.
- **`AnatomyConcept`** (`anatomy_base.hpp:109-116`): „compile-time C++23-Concept, Static Dispatch. … konkrete Anatomien nutzen DIESE Concept-Schicht (NICHT die Virtual-Schicht) für Hot-Path-Performance."
- **`IAnatomyBase`** (`anatomy_base.hpp:133-160`): „virtual Interface … **ausschließlich** R5.E Module-Loader-Adapter-Grenze; ‚ein .so/.dll exportiert genau EINE IAnatomyBase-Instanz (extern ‚C' Factory)'." ABI-Grenze: `anatomy_module_loader.cpp:66-67,148` (`PfnCreate = IAnatomyBase*(*)()`).
- **Binary-Identität `golden_fullpilot_320`** (`maps[2]:28-39`): Generator `gen_golden_fullpilot.cpp` mit Hard-Gate „`if (ids.size() != 320) … "ERWARTET 320 binary_ids (4*4*5*4)" … return 1`". Quelle der 320: `using FullSourceCatalog = CatalogAxes<4, 4, 5, 4>;` (`source_catalog.hpp:113`). Präzision (`maps[2]:48`): „das 320er-Golden ist **rein SearchAlgorithm-Genus** … Container-Genus (Set/Sequence/Adapter/View) kommen im 320-Golden NICHT vor."
- **#29-Stand** (`maps[2]:52-60`): `container_framework.hpp` (`comdare::container`, additiv, `type_count`=4) ist Schritt-1; die tiefe Genus→Typ-Umstrukturierung ist „explizit GEPARKT, nicht realisiert" (`container_framework.hpp:15-17`).

## LAYER 4 — Workload-/Mess-Achsen (runtime Mess-Input + Mess-Output)

**Zweck:** Die runtime-Mess-Variation (Workload W, Dataset D) und die Mess-Output-Projektion (Kategorie M).
- **`workload_matrix.hpp` (#31)** (`maps[3]:15-23`): `ycsb_profile_list` (`:57-63`) = 6 YCSB A–F, `ycsb_profile_count == 6` = **Achse W**; `CanonicalDataset` (`:80`) = 6 Datasets (Url/Dna/Protein/Xml/TpcdsId/TrecTerms) = **Achse D**; `matrix_cells` (`:105-106`) = `mp::mp_product<mp_list, ycsb_profile_list, dataset_list>`, `matrix_cell_count == 36` (W×D). `config_for → profile_by_name` (`:67-71`) = „Hybrid: compile-time Auswahl (W-Tag) → runtime `WorkloadConfig`". Wiring: „**nur** von `tests/unit/test_31_workload_matrix.cpp` inkludiert … **nicht** an Orchestrator/Pipeline/POD angeschlossen".
- **`measurement_category.hpp` — Achse M** (`maps[3]:29`): „Die 16 MeasurementCategory (`:9-26`): `CLU=0, CACHE_MISS_L1=1, …, FILL_BUFFER_OCCUPANCY=15`. Flache `enum class : uint8_t`, **kein** Gruppierungs-Tag."
- **Regime-Frage** (`maps[3]:31-36`): „Existiert eine metrics/pmc-Regime-Zweiteilung (observer vs counter)? — **NEIN, nicht auf der M-Achse.**" Die Trennung sitzt „**strukturell im `builder/`-Layer**": Counter-Regime `struct PmcCounters` (`pmc_source.hpp:19-28`) via `make_pmc_source()` (`pmc_source_factory.hpp:29-37`); Observer-Regime (`measurement_snapshot.hpp:105-113`); Zusammenführung in **einem** POD `ComdareMeasurementSnapshotV1` (`measurement_snapshot.hpp:34-66`), „`pmc_available` ist der EINE Ehrlichkeits-Schalter".
- **Ist-Grenze** (`maps[3]:40`): „**M ist heute faktisch abgekoppelt** … `MeasurementCategory` wird NUR konsumiert von `measure.hpp` … **Nicht** von der Pipeline/`ComdareMeasurementSnapshotV1`."

---

# FRAGE 2 — Wie die 4 Schichten die Einstellbarkeit realisieren

Kern-Synthese (`synth:18`): Der `CacheEngineBuilder` (LAYER 2, Funktion `run_lazy_static_then_dynamic`, `cache_engine_builder_iterator.hpp:603-812`) „**ist die Naht, die alle drei Ebenen zusammenzieht**".

Der Mechanismus über die Schichten (`synth:37`):
> „Phase 1 = statischer Iterator über `tree.static_binary_view()` + `BuildSelection` → DLLs bauen (compile-time-Typuniversum → Runtime-Auswahl WELCHER Punkte via `coverage_selection.hpp:25-71`, gekappt auf `cfg.max_binaries`); Phase 3 = dynamischer Iterator `loop.run(*ctrl, tree.dynamic_filter(), measure)` → for-Schleifen + Messung. **W/D speisen Phase-3-Mess-INPUTs; M projiziert Phase-3-Mess-OUTPUT.** Das compile-time-Typuniversum ist `AdHocComposition<T0..T18>` (19 Slots, `composition_factory.hpp:49-74`), die Runtime wählt nur Punkte + Mess-Bedingungen daraus."

Zusammenspiel konkret:
1. **LAYER 3** liefert das feste **Typ-Universum** (19-Slot-Anatomie `AdHocComposition<T0..T18>`, die Organ-Implementierungen je Achse) und die Regel, dass eine Binary genau EINE `IAnatomyBase` exportiert.
2. **LAYER 1** legt per `is_static`-Flag fest, welche Achsen dieses Universums die **`binary_id`** bilden (StaticAxisNode → 320) und welche als **for-Schleifen je Binary** laufen (DynamicVariableNode).
3. **LAYER 2** iteriert lazy: baut je selektiertem statischem Blatt eine DLL, lädt sie, und fährt darauf die dynamischen for-Schleifen — ohne jemals den ∏-großen Baum zu materialisieren (`maps[0]:31`: „lazy mixed-radix Odometer, O(Tiefe) Speicher").
4. **LAYER 4** liefert die Mess-Inputs (Workload W über `profile_run_entry.hpp:132-134`, geplant Dataset D) und die Mess-Output-Projektion (Kategorie M).

Die entscheidende Nuance — die drei Rollen von W/D/M (`synth:32-35`):
- **W (Workload)** = „echte dynamische for-Schleife … W multipliziert **Läufe**" (`RuntimeVariableLoop.run`, `runtime_variable_loop.hpp:73-107`).
- **D (Dataset)** = „konzeptionell **ebenfalls eine Lauf-multiplizierende dynamische Achse** — aber heute existiert dafür **keine** dynamische `AxisLevel`" (Lücke A-G2).
- **M (Kategorie)** = „multipliziert **KEINE Läufe** … ist eine **Spalten-Projektion** über den bereits erzeugten Snapshot. **Darum darf M NICHT als `mp_product`-Faktor in die Lauf-Matrix**."

---

# FRAGE 3 — compile-time/runtime-Split über die 4 Schichten

Die Grenze (`synth:30`): „`binary_id`/`pinned_signature` werden AUSSCHLIESSLICH aus `static_levels_` serialisiert … alles `is_static=false` wird herausgefiltert und berührt die 320 nie. `binary_count()` ist reine Arithmetik ∏ der statischen Ebenen (`experiment_tree.hpp:360-365`)."

Verteilung (aus der Synthese-Tabelle `synth:20-28`):

| Ebene | Schicht(en) | in `binary_id`? | golden-320? |
|---|---|---|---|
| `search_algo`(4)·`node_type`(4)·`memory_layout`(5)·`prefetch`-Strategie(4) | **COMPILE-TIME — Binär-Identität** — LAYER 1 (`StaticAxisNode`) + LAYER 3 (`CatalogAxes<4,4,5,4>`) | **JA** | **JA = 4·4·5·4 = 320** |
| 15 gepinnte SA-Achsen | COMPILE-TIME (je 1 Wert) — LAYER 1/3 | JA (konstant) | JA (konstant) |
| `tier` | COMPILE-TIME, **separate Pass-Dimension** (aus 320 ausgeschlossen) | Voll-Lauf ja / 320 nein | teilweise |
| `concurrency.thread_count`·`prefetch.hw_prefetcher`·`repetition.repetition_index` | **RUNTIME — Mess-Variation** — LAYER 1 (`DynamicVariableNode`) | **NEIN** | **NEIN** |
| `workload.workload_id` (**Achse W**) | RUNTIME — Mess-Variation — LAYER 1 + LAYER 4 | NEIN | NEIN |
| `dataset` (**Achse D**) | RUNTIME (**heute NICHT verdrahtet**) — LAYER 4 | NEIN | NEIN |
| `MeasurementCategory` (**Achse M**) | **MESS-OUTPUT-PROJEKTION** (weder static noch for-loop) — **KEIN Baum-Knoten** — LAYER 4 | NEIN | NEIN |

Zuordnung Schicht→Regime auf den Punkt:
- **compile-time (Achsen-Algorithmen, Binär-Identität):** LAYER 3 (Anatomie: `AnatomyConcept` Hot-Path, `AdHocComposition<T0..T18>`, golden 320) + der `is_static=true`-Zweig von LAYER 1 (`StaticAxisNode`). Original (`maps[1]:66`): „Die statische `binary_id` ist eine reine compile-time-Typ-Rekombination; dyn-Settings ändern sie nie."
- **runtime (Workloads, Mess-Variation):** LAYER 4 (Workload W, Dataset D) + der `is_static=false`-Zweig von LAYER 1 (`DynamicVariableNode` → `RuntimeVariableLoop`, POD-Klammerung `algorithm_resource_control.hpp:38-56`).
- **LAYER 2 ist die Naht** zwischen beiden (compile-time Typuniversum → runtime Punkt-/Mess-Auswahl).
- **M ist ein Sonderfall** — weder compile-time-Identität noch runtime-Schleife, sondern Output-Spalten-Projektion aus dem einen POD `ComdareMeasurementSnapshotV1`, dessen `pmc_available` Counter- von Observer-Spalten trennt.

Ehrlichkeits-Vorbehalt (`maps[1]:69`): „Nicht alle 26/19 Achsen werden real getrieben: `axis_operability_classification.hpp:34-53` — nur `search_algo` + `allocator` sind `Operative`, 4 `OperativeCapable`, 11 `Descriptor` (passive Build-Konstanten)."

---

# FRAGE 4 — Rolle von BuildSelection / Emitter / Binary-Generierung

Alle drei sind das runtime-Scharnier von LAYER 2, das aus dem compile-time-Typuniversum konkrete DLLs materialisiert.

**BuildSelection** (`coverage_selection.hpp:25-71`) — runtime-Wahl WELCHE statischen Binaries gebaut werden. Original (`maps[1]:60`): „Laufzeit-Wahl WELCHE statischen Binaries gebaut werden — `select_full`/`select_one_wise`/`select_explicit`/pinned (OOM-Schutz `:32-48`)." In `run_lazy_static_then_dynamic` (`:613-639`) selektiert sie über der `StaticBinaryView`, gekappt auf `cfg.max_binaries` (`:617-619`). Sie multipliziert nichts — sie **wählt Punkte** aus dem 320er-Raum (bzw. dem vollen ∏), die tatsächlich gebaut werden.

**Emitter** (`codegen/adhoc_emitter.hpp`) — Typ→Source. Original (`maps[0]/maps[1]:26`): „`generate_all_real<Engine>` → `codegen::emit_adhoc_modules<Engine>` (`adhoc_emitter.hpp:94-108`): je Komposition-Typ C ein `.cpp` mit `#include all_axes_umbrella.hpp` + `COMDARE_DEFINE_ANATOMY_MODULE_ADHOC(<19 FQ-Typen>)` (`adhoc_emitter.hpp:50-89`). Die 19 Slots = `AdHocComposition<T0..T18>`." Das Makro „instanziiert compile-time `SearchAlgorithmAnatomy<AdHocComposition>` (`all_axes_umbrella.hpp:1-14`)". Wichtig (`maps[1]:26`): Es gibt zwei Emitter-Pfade — `generate_perm_source`/`generate_all` = „**Diagnose-Shell**, `perm_run` gibt 0.0 zurück, misst nichts" (`ceb_generator.hpp:62-114`) vs. der reale `generate_all_real<Engine>` (`ceb_generator.hpp:121`).

**Binary-Generierung** — je StaticAxisNode-Pfad genau eine DLL. Original (`maps[0]:12`): „compile-time-Entscheidung → JE Static-Pfad EINE eigene Tier-Binary (DLL). Ist Teil der Binary-Identität." In Schicht A dagegen string/XML-getrieben: „Phase 2 `CodegenEngine::generate_module(...)` je Descriptor (`experiment_driver.cpp:155-159`) … Je Permutation ein `module_<fp>.cpp` → DLL. Wahl der Organe geschieht hier zur **Laufzeit aus XML-Strings**" (`maps[1]:20`). Injizierte Strategy-Funktionsobjekte halten den Header engine-agnostisch (`maps[1]:63`): „`CompileFn`/`SourceGenFn`/`FreeRamFn` an `run_lazy_static_then_dynamic` übergeben (`cache_engine_builder_iterator.hpp:20-24, 609-611`) — engine-agnostisch, hält den Header frei vom schweren Umbrella-Include."

Zusammengefasst (`synth:37`): BuildSelection = **welche** Punkte, Emitter = **Typ→Source** je Punkt, Binary-Generierung = **compile → DLL** je selektiertem Static-Pfad; danach lädt LAYER 2 die DLL und fährt die dynamischen for-Schleifen (W, thread_count, prefetch.hw, repetition) darauf, ohne neu zu bauen.

---

# Belegdateien (absolut, aus den Karten)

- LAYER 1/2: `BASE/libs/cache_engine/builder/experiment_tree/experiment_tree.hpp`, `.../cache_engine_builder_iterator.hpp`, `.../profile_to_tree.hpp`, `.../runtime_variable_loop.hpp`, `.../registry_to_axis_levels.hpp`, `.../ceb_generator.hpp`; `BASE/libs/cache_engine/builder/codegen/adhoc_emitter.hpp` + `all_axes_umbrella.hpp`; `BASE/libs/cache_engine/anatomy/composition_factory.hpp` + `anatomy_permutation_driver.hpp`; `BASE/libs/cache_engine/builder/experiment_driver/experiment_driver.{hpp,cpp}`; `BASE/apps/cache_engine_builder/main.cpp` + `BASE/apps/adhoc_emitter/main.cpp`; `BASE/tests/unit/thesis_tiere/profile_runner.hpp`, `profile_run_entry.hpp`, `source_catalog.hpp`, `gen_golden_fullpilot.cpp`.
- LAYER 3: `BASE/libs/cache_engine/anatomy/anatomy_base.hpp`, `container_framework.hpp`; `BASE/libs/cache_engine/builder/experiment_tree/genus_binding_traits.hpp`; `BASE/libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1.hpp` (+ `_decl.hpp`, `{set,sequence,adapter,view}_module_abi_v1.hpp`); `BASE/libs/cache_engine/builder/anatomy_module_loader/anatomy_module_loader.cpp`; `BASE/tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt`; `BASE/libs/cache_engine/algorithm_profiles/permutation_axes.xml`; `BASE/docs/architecture/37_ap15_container_typen_sequence_plan.md`; `BASE/tests/unit/test_29_container_framework.cpp`.
- LAYER 4: `BASE/libs/cache_engine/builder/workload_driver/workload_matrix.hpp`, `.../builder/commands/workload.hpp`, `workload_profiles.hpp`, `workload_config.hpp`; `BASE/libs/cache_engine/include/cache_engine/measurement/measurement_category.hpp`; `BASE/libs/cache_engine/builder/measurement_snapshot.hpp` + `pmc_source.hpp` (+ `pmc_source_factory.hpp`); `BASE/tests/unit/test_31_workload_matrix.cpp`.

Extrahierte Rohtexte liegen in meinem Scratchpad (`/tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad/map0.md` … `map3.md`, `synth.md`), falls die exakten Karten-Volltexte weiterverwendet werden sollen.