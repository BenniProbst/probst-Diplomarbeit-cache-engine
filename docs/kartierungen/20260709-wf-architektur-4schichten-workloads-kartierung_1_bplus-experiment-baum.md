I have a complete, code-verified picture. Here is the mechanics map.

---

# Mechanik-Karte: Compile-Time-/Runtime-Split des Experiment-Baums

Basis (READ-ONLY, keine Mutation ausgeführt): `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/` — im Folgenden repo-relative `datei:zeile`.

## KERN-ANTWORT (bestätigt der Code die These?)

**JA, eindeutig.** Der Code trennt sauber:
- **Achsen-Algorithmen = COMPILE-TIME → je Kombination eine eigene Tier-Binary/DLL** (`is_static=true`, `contributes_to_signature()=true`, gehen in `binary_id`, ∏ = `binary_count()`).
- **Workloads + OS-Runtime-Stellhebel = RUNTIME → virtuelle for-Schleife über EINER geladenen Binary** (`is_static=false`, `is_runtime_loop()=true`, `contributes_to_signature()=false`, ändern die `binary_id` NICHT).

Der Umschalter ist das eine Feld `AxisLevel.is_static`.

---

## 1. StaticAxisNode vs DynamicVariableNode — und der Schalter

Zwei distinkte Produkt-Typen über eine Factory-Method (`ExperimentNodeFactory`, `NodeKind`-Enum als Selbstauskunft), beide `INodeDescription` — `experiment_tree.hpp:98-177`.

**StaticAxisNode** (`experiment_tree.hpp:115-134`) — Kommentar Z.115 wörtlich *"compile-time-Entscheidung → je Static-Pfad eine Tier-Binary"*:
- `contributes_to_signature() = true` (Z.124) → geht in die `binary_id`
- `contributes_to_pinned_signature() = pinned_` (Z.125)
- `is_runtime_loop() = false` (Z.126)
- `serialize()` = `"axis=value"` (Z.123)

**DynamicVariableNode** (`experiment_tree.hpp:136-155`) — Kommentar Z.136-137 *"Laufzeit-Variable → VIRTUELLE for-Schleife (nicht materialisiert)"*:
- `contributes_to_signature() = false` (Z.146) → ändert `binary_id` nicht
- `contributes_to_pinned_signature() = false` (Z.147)
- `is_runtime_loop() = true` (Z.148)
- `serialize()` = `"axis.var=value"` (Z.145)

**DER SCHALTER = `AxisLevel.is_static`** (bool, Default `true`) — `experiment_tree.hpp:189-195` (Z.192, Kommentar: *"static/dynamic = KNOTEN-EIGENSCHAFT (gleichrangig im Baum)"*). `ExperimentTree::build()` splittet exakt danach:
- `static_filter()` behält `l.is_static` → `static_levels_` (Binary-Identität) — `experiment_tree.hpp:342-347`
- `dynamic_filter()` behält `!l.is_static` → `DynamicDim` (virtuelle for-Schleifen) — `experiment_tree.hpp:349-354`

**„je Kombination eine eigene Binary":** `binary_count() = ∏` der statischen Ebenen-Größen, rein arithmetisch, ohne Materialisierung — `experiment_tree.hpp:360-365`. Jede statische Rekombination wird mixed-radix on-demand zu genau EINER `BinarySpec`/`binary_id` dekodiert (`StaticBinaryView::operator[]`) — `experiment_tree.hpp:266-288`. Das Ausführungsmodell steht als Doktrin im Kopfkommentar `experiment_tree.hpp:14-25` (statisch = eigene DLL je Kombination; dynamisch = virtuell geschachtelte for-Schleifen zur Laufzeit über EINER Binary, KEINE neue Binary).

## 2. Wie ein Lauf real gefahren wird

`run_lazy_static_then_dynamic(tree, sel, compile, gen, ram, cfg)` — `cache_engine_builder_iterator.hpp:609` (Kopf-Doku Z.603-608). Drei explizit lazy Phasen:

- **(1) STATISCH kompilieren:** `StaticBinaryView view = tree.static_binary_view()` (Z.613); Selektion auf `max_binaries` gekappt (Z.617-618); `BuildOrchestrator.provision_all(view, indices, ...)` baut je selektiertem Blatt genau EINE DLL on-demand (Z.637-639), resumierbar via `.version`-Sidecar. `binary_id` = serialisierter Static-Pfad `"axis=value/axis=value/..."`.
- **`static_filter`/`dynamic_filter`:** `dyn_dims = tree.dynamic_filter()` liefert die dynamische Sub-Kartesik (Z.614); die statische Seite kommt aus `static_binary_view()` (→ `static_filter()` intern).
- **(2) Laden:** je DLL → `IAnatomyBase*` → per `dynamic_cast` die zwei ABI-Sub-Interfaces `IObservableTier` (Mess-Antrieb) + `IResourceControllableTier` (Laufzeit-Steuerung) — `cache_engine_builder_iterator.hpp:685-702`.
- **(3) DYNAMISCH variieren:** `RuntimeVariableLoop loop{cfg.env_limits}` (Z.646); `loop.run(*ctrl, dyn_dims, measure_under_setting)` (Z.773-775) — kartesisch über die dyn. Dimensionen auf der GELADENEN Binary, **kein Neu-Bauen/Neu-Laden**.

**RuntimeVariableLoop** (`runtime_variable_loop.hpp:35-107`): rekursives `expand()` (Z.73-107) = die virtuelle geschachtelte for-Schleife (Z.101-106 iteriert `d.values`). Je Blatt: baut `ComdareResourceControlV1`-POD aus den Variablennamen (`set_field`, Z.52-64, 77-85), clampt gegen `caps∩env` (Z.86-88), ruft `tier_apply_resource_control` (Z.89), dann Visitor. Architektonische Ausnahmen (`hw_prefetcher` via MSR) sind KEIN POD-Feld → reisen nur im Label, angewandt vom MSR/SLURM-Launcher (Z.63, Kopf Z.11-13).

**Serialisierung + Messung** (`cache_engine_builder_iterator.hpp:718-771`): `setting_id = binary_id + "#" + setting_label` (Z.725); je Setting `run_observable_perm` (fixer Workload) ODER `run_workload_perm` wenn `workload_id` im Label (Z.730-735); `ingest_result_line(tree, pr.line)` → sparse `NodeValue` im Baum (Z.737). `binary_id` bleibt reine statische Achsen-Rekombination (keine Tag-/Setting-Verschmutzung, Z.90-91).

## 3. WO sind WORKLOADS — static oder dynamic?

**DYNAMIC (Laufzeit-for-Schleife) — verdrahtete Realität.** Injektion in `profile_run_entry.hpp:132-134`:
```
ex::AxisLevel{"workload", a.workload_values, /*is_static=*/false, "workload_id", "workload"}
```
(Begründungskommentar Z.123-131: ohne diese Ebene fällt der Iterator auf `run_observable_perm` ohne Zwei-Phasen-Warmup zurück → `two_phase_valid=0`.)

- **Quelle = Laufzeit-Discovery**, nicht compile-time: `discover_load_profiles(COMDARE_LOAD_PROFILE_DIR)` → `workload_values` — `run_lazy_150.cpp:192-206`, durchgereicht als `a.workload_values`/`a.workload_registry` (Z.271-272).
- **Getrieben zur Laufzeit:** `lazy_extract_workload_id(setting_label)` → `run_workload_perm(*obs, rbk, scn, ..., workload_id, ...)` über die map-Interfaces der EINEN geladenen Binary — `cache_engine_builder_iterator.hpp:730-735`.

**Wichtige Diskrepanz (Beleg):** Das Profil-XML deklariert zwar `<compile_dims><workloads>A B C D E F</workloads>` mit Kommentar *"COMPILE-TIME … je Binary gebacken"* (`m3v2_study.profile.xml`, Abschnitt c-1). Das wird in `tp.workloads` geparst (`xml_config_parser.hpp:157`, `xml_config_parser.cpp:228`), aber **nirgends** zu AxisLevels/Binary-Variation konsumiert (verifiziert: kein Downstream-Consumer von `tp.workloads`). Diese „compile-time-gebackene Workload" ist also **tot/unverdrahtet**; die real gefahrene Workload-Achse (Achse 2) ist dynamisch.

**Heute dynamische Achsen (alle `is_static=false`)** — Emission in `profile_to_tree.hpp:75-86`:
- `concurrency.thread_count` — Werte `tp.thread_counts`, echtes POD-Feld (`thread_count`) — Z.75-76
- `prefetch.hw_prefetcher` — Werte `tp.hw_prefetcher`, KEIN POD-Feld → MSR/Launcher — Z.77-78
- `repetition.repetition_index` — Default 3, KEIN POD-Feld (`set_field` ignoriert) — Z.79-86
- `workload.workload_id` — separat injiziert — `profile_run_entry.hpp:132-134`
- (Nur im Klein-Katalog-Test zusätzlich `prefetch.prefetch_distance` als echtes POD-Feld — `source_catalog.hpp:171-174`)

## 4. Achsen-Algorithmen (die golden 320) — static/compile-time?

**JA, compile-time, je Kombination eine eigene DLL.** Materialisierung rein typ-getrieben in `source_catalog.hpp:83-113`: `CatalogAxes<KSearch, KNode, KLayout, KPrefetch>` mit `mp_take_c` über die **compile-time** `StaticAxisVariants`-Typlisten:
- `L00 search_algo = mp_take_c<...03a, KSearch>` (Z.85)
- `L04 node_type = mp_take_c<...04, KNode>` (Z.89)
- `L05 memory_layout = mp_take_c<..., KLayout>` (Z.90)
- `L07 prefetch = mp_take_c<..., KPrefetch>` (Z.92, SW-Prefetch-Strategie)
- `FullSourceCatalog = CatalogAxes<4,4,5,4>` = **4·4·5·4 = 320** (Z.112-113)

`PermutationEngine` → `build_pilot_source_map` erzeugt je `binary_id` (= serialisierter 19-Achsen-Static-Pfad) eine reale Modul-Quelle (Z.105-109, 154-157). Als STATISCHE AxisLevels gepusht in `catalog_static_levels()` (`source_catalog.hpp:124-146`: search_algo Z.126, node_type Z.130, memory_layout Z.131, prefetch Z.133 — `push_static_axis`, `is_static` implizit true). Profil deklariert genau diese 4 mit Fanout, die übrigen 15 je 1 Wert gepinnt (`m3v2_study.profile.xml` `<permute_axes>`). Gefrorene Referenz: `golden_fullpilot_320_binary_ids.txt` (320 `binary_id`s, 323 Zeilen inkl. 3 Kopf-Kommentaren). **Je 320 = eine eigene Tier-Binary/DLL** (1 `perm_<id>.cpp` = 1 TU = 1 DLL = 1 Komposition — `source_catalog.hpp:24-26`, `profile_run_entry.hpp:18`).

**Zwei wichtige Subtilitäten (gleicher Name, zwei Schichten):**
- **prefetch:** STATISCH `prefetch` (L07, eine der 320 — `prefetch_none`/`..._distance_estimator`/`..._hardware`/`..._path_oriented` = die *compile-time einkompilierte SW-Prefetch-Strategie*) ≠ DYNAMISCH `prefetch.hw_prefetcher` (der MSR-HW-Prefetcher-Toggle `all_on`/`adjacent_off`/`all_off`, Laufzeit).
- **concurrency:** STATISCH `concurrency` (L08, auf `concurrency_none` gepinnt = compile-time Nebenläufigkeits-Strategie) ≠ DYNAMISCH `concurrency.thread_count` (OS-Threadzahl, Laufzeit).

Die vertieften Achsen (`migration_policy`/`filter`/`value_handle`/`path_compression`) sind ebenfalls compile-time/static, aber im Basis-320 gepinnt; ihr Sweep läuft über eigene kleine Sweep-Kataloge (`AxisSweepCatalog`, `source_catalog.hpp:207-296`) — je Ausprägung ebenfalls eine reale distinkte DLL, `is_static=true`.

---

## Kompaktkarte

| Achse | is_static | Knotentyp | in binary_id? | Mechanik | Beleg |
|---|---|---|---|---|---|
| search_algo, node_type, memory_layout, prefetch(-strategie) (golden 320) | true | StaticAxisNode | ja | eigene DLL je ∏-Kombination | `source_catalog.hpp:83-113,124-146` |
| 15 übrige Slots (gepinnt) | true | StaticAxisNode | ja (fest) | in jede DLL einkompiliert | `source_catalog.hpp:86-104` |
| concurrency.thread_count | false | DynamicVariableNode | nein | for-Schleife, POD-Feld, `tier_apply_resource_control` | `profile_to_tree.hpp:75-76` |
| prefetch.hw_prefetcher | false | DynamicVariableNode | nein | for-Schleife, KEIN POD → MSR-Launcher | `profile_to_tree.hpp:77-78` |
| repetition.repetition_index | false | DynamicVariableNode | nein | for-Schleife, KEIN POD | `profile_to_tree.hpp:79-86` |
| workload.workload_id (Achse 2) | false | DynamicVariableNode | nein | for-Schleife → `run_workload_perm` über EINE Binary | `profile_run_entry.hpp:132-134` |

Schlüsselbelege der These: Schalter `experiment_tree.hpp:192`; Static→Binary `experiment_tree.hpp:115,124,360-365`; Dynamic→for-Loop `experiment_tree.hpp:136-148` + `runtime_variable_loop.hpp:73-107`; Lauf-Kette `cache_engine_builder_iterator.hpp:609-775`; golden 320 compile-time `source_catalog.hpp:83-113`; Workload dynamisch `profile_run_entry.hpp:132-134`.