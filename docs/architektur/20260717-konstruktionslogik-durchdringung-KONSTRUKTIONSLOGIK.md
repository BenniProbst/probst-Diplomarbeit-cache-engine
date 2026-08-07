# KONSTRUKTIONSLOGIK — comdare-cache-engine (DEFINITIV)

> ---
>
> ## ⚠️ STAND 2026-08-07: DER MODELL-TEIL GILT, DER IST-TEIL IST VIER ABI-MAJORS ALT
>
> **Das Wort „DEFINITIV" im Titel bezieht sich auf das Konstruktions-MODELL -- nicht auf die
> Code-Kartierung.** Genau die ist veraltet. Das Dokument sagt von sich, es „kartiert das Modell
> gegen den Ist-Code (datei:zeile) und markiert jedes Delta" (`:4-5`); mehrere dieser Deltas sind
> inzwischen geschlossen, und die Kartierung nennt durchgehend 19 Achsen und ABI-Major 4.
> Belege gegen ce `ba069e38` (identisch in `ab0b352e`).
>
> ### ABI: der im Dokument als bevorstehend gefuehrte 4→5-Bruch ist vollzogen -- und dreimal ueberholt
>
> `:10` „TABU (Golden/ABI-Major) nur mit koordiniertem **4→5-GO**", `:181-182` „**ABI-Major = 4**
> (verifiziert)", `:194` „**ABI-Major noch 4**, kein 4→5", `:180` Magic `.A4.` -- alle vier sind
> ueberholt. Ist: **ABI-MAJOR 8**, Minor 0, Magic `.A8.` = `0x434F4D444141382E`
> (`abi/anatomy_module_abi_v1_decl.hpp:89`, `:90`, `:92`).
>
> Der belegte Verlauf, alles im selben Header:
>
> | Bruch | Anlass | Beleg |
> |---|---|---|
> | 4 → 5 | Bau-INC-2b, **2026-07-17**, TABU-GO (das Buendel, das F12iii vorbereitete) | `:46` |
> | 5 → 6 | Bau-INC-2d, 2026-07-18, isa-Herausloesung | `:52` |
> | 6 → 7 | STRUKT-R ORG-18, 2026-07-26, `persistence_target` als 18. Organ-Achse | `:57` |
> | 7 → 8 | E-24 C8, 2026-08-04, Ebene-1-Gattung wird ABI-Flaeche | `:65` |
>
> Das Dokument entstand also **am Tag des ersten dieser vier Brueche** -- sein ABI-Stand war schon
> bei Erstellung im Begriff zu kippen.
>
> ### Achsenzahlen: durchgehend 19, Ist ist 18
>
> | Zeile | steht im Dokument | Ist heute | Beleg (ce) |
> |---|---|---|---|
> | `:44-45` | „**19 Organ-Achsen** = Slots T0..T18" | **18**, T0..T17 | `anatomy/composition_factory.hpp:104` |
> | `:46-49` | „`kCompositionAxisNames` … `array<…,19>`: … telemetry, value_handle, **isa**, …" | `array<…,**18**>`; **telemetry und isa sind raus**, `persistence_target` ist neu als T17 | `builder/experiment_tree/axis_path_serialization.hpp:40-43` |
> | `:52-54` | „`static_assert(sizeof...(Vs)==19)`" | **== 18** | `composition_factory.hpp:104` |
> | `:55-56` | die binary_id endet auf `queuing_q2=<V18::name()>` | endet auf `persistence_target=<V17::name()>` | `axis_path_serialization.hpp:58-60` |
> | `:115` | Genus-Slots „SA=**19**, Adapter=**13**, Set=**15**, Sequence=**11**, View=**7**" | **18 / 11 / 13 / 9 / 5** | `builder/experiment_tree/genus_binding_traits.hpp:48`, `:74`, `:102`, `:132`, `:160` |
> | `:170-173` | „`axis_stats[19][8]` + `seg_ns[19]` … `sizeof==1416`" | `[18][8]`, `seg_ns[18]`, **sizeof 1344** | `anatomy/observable_tier.hpp:141-142`, `:168` |
> | `:270` | „`COMDARE_DEFINE_ANATOMY_MODULE_ADHOC(<19 FQ-Typen>)`" | **18** | `composition_factory.hpp:104` |
>
> ### Gattungs-Vokabular: der Enumerator wurde umbenannt
>
> `:105-106` „Ebene 1 `AnatomyGattung` … **NUR 3**: `SearchAlgorithm=0`, `Container=1`, `Graph=2`" --
> der Enumerator heisst seit E-24 C7-1 (04.08.) **`Map = 0`**; der Zahlenwert 0 blieb unangetastet,
> die Enum-Reihenfolge ist TABU (`anatomy/anatomy_base.hpp:49-57`). Ebene 2 heisst weiterhin
> `AnatomyGenus::SearchAlgorithm` -- **das Genus** heisst so, nicht die Gattung. Damit ist auch
> `:127` („User-,Gattung' == Code-`AnatomyGenus`") ueberholt: „Gattung" ist im finalen Owner-Modell
> eindeutig Ebene 1.
>
> ### Vollzugs-Marken -- als Delta gefuehrt, inzwischen geschlossen
>
> - `:249-250` „**Es gibt heute keinen benannten Experiment-Planer-Dock** (grep = leer)" --
>   **ES GIBT IHN.** Ganzes Planer-Verzeichnis `profile_facade/planner/` (u.a.
>   `experiment_plan_director.hpp`, GoF Director/Builder) plus eigene Binary
>   `apps/experiment_planner/CMakeLists.txt:13`.
> - `:305-312`, `:356-365` DLL-Load-Bruch, „**Kein `-l`, kein Archiv**; `BuildJob` traegt **kein
>   Link-Input-Kanal**" und der dort vorgeschlagene Fix Option B -- **BEIDE PUNKTE GEBAUT.**
>   `make_gpp_compile_fn` hat einen `link_libs`-Parameter
>   (`builder/build_orchestrator/build_orchestrator.hpp:880`, Anhang nach der Quelle `:911`), und die
>   Fassade backt die Archiv-Pfade (`profile_facade/CMakeLists.txt:198-211`,
>   `COMDARE_FACADE_PERM_LINK_LIBS`).
> - `:191-192` „Nur 1 von 3 Gattungs-Docks; Set/Sequence/Adapter/View kommen mit V42" --
>   **FUENF Docks.** Der zitierte Satz ist im Code selbst als „UEBERHOLT, steht nur noch als
>   Historie" markiert (`builder/pruef_dock/pruef_dock_registry.hpp:11-19`).
> - `:215-219`, `:235-236` „`build_all_axis_levels` reflektiert 26 Achsen **flach**, **es fehlt die
>   Schichtung**; Andockpunkt: abspalten in `build_system_axis_levels()`" -- **GEBAUT**
>   (`builder/experiment_tree/registry_to_axis_levels.hpp:144-151`).
> - `:226` „`make_gpp_compile_fn` hat **KEIN `-march`/`-mavx`**" -- **GEHEILT**, `opt_flag`-Parameter
>   (`build_orchestrator.hpp:881`, `:895`).
> - `:300-304`, `:348`, `:364` verweisen auf `tools/permutation_codegen/codegen.cmake:584` usw. --
>   **dieses Verzeichnis existiert nicht mehr.** (`find` ueber den ganzen ce-Baum: kein
>   `codegen.cmake`; `tools/` enthaelt 16 andere Werkzeuge.) Neuer Ort der Aussage:
>   `cmake/adhoc_emitter.cmake:141` (`add_library(${_target} SHARED …)`), `:165`.
>   Die konkreten Zeilenverweise `:584`/`:594`/`:607-632` sind damit belegfrei.
>
> **Weiterhin korrekt (nicht anfassen):** `:21`, `:39-40` `topics::AxisBase` samt
> `AxisBaseConcept` · `:74-77`, `:83` das Mimalloc-CRTP-Muster · `:88-90` die MP11-Registry-Form
> („26 Vendor", `axes/alloc/axis_06_allocator_registry.hpp:99`) · `:156-160` `ComdareResourceControlV1`
> mit 6 Membern und die beiden RC-Methodennamen · `:138`, `:146` `IPruefDock` ·
> `:313-315` `dlopen(RTLD_NOW|RTLD_LOCAL)` (`abi/module_loader.hpp:26`, Zeile exakt getroffen) ·
> `:286-289` das AVX10-Delta ist **weiterhin offen**.
>
> ---

Stand 2026-07-17. Basis = USER-KONSTRUKTIONS-MODELL 2026-07-17 (autoritativ, Ledger §12-Kopf).
Diese Datei ist die durchdrungene, code-belegte Konstruktionslogik: sie ENTSCHEIDET NICHT neu,
sondern kartiert das Modell gegen den Ist-Code (datei:zeile) und markiert jedes Delta.

Pfadkonvention: Zitate relativ zu
`Code/external/comdare-cache-engine/libs/cache_engine/` sofern nicht anders angegeben.
Doktrin durchgängig: compile-time-only Hot-Path (CRTP + Concept, **kein vtable**), benannte
GoF-Patterns, Doku/Messdaten nie löschen, TABU (Golden/ABI-Major) nur mit koordiniertem 4→5-GO.

---

## 0. Die DREI Achsen-Begriffe (ohne diese Unterscheidung ist nichts eindeutig)

Im Code koexistieren zwei disjunkte „Achsen"-Hierarchien; das User-Modell fordert eine dritte.
Sie dürfen NIE vermischt werden (Direktive `system_axes_measurement_own_abstract_root_blood`).

| Begriff | Rolle | Wurzel im Code | Zustand |
|---|---|---|---|
| **Organ-Achse** | compile-time Strategy-Wrapper, permutiert `binary_id`, sitzt IN der Komposition | `topics::AxisBase` (`topics/axis_base.hpp:52-79`) + topic-eigene CRTP-Basis | realisiert |
| **Mess-System-Achse** („Blut") | host-seitige Mess-Wurzel, golden-neutral, immer präsent bei Messung | `measurement::SystemAxis<Derived>` (`include/cache_engine/measurement/system_axis.hpp:147-180`) | realisiert (nur Messung) |
| **CEB-System-Achse** (Modell) | compile-time-STATISCH, unter der die CEB gebaut wird, ÜBER den Tier-Binaries | — (keine gemeinsame Wurzel) | **verstreut / offenes Delta** |

Die CEB-System-Achse des Modells (Scheduling / Hardware / Telemetrie / Last) ist heute **nicht** als
eigenes Compile-Time-Konstrukt vorhanden; ihre Fragmente liegen teils als Organ-Achse, teils als
Build-Config-Feld, teils als verwaister Runtime-vtable vor (siehe §6).

---

## 1. Organ-Achse — der compile-time CRTP+Concept-Wrapper

Ein konkreter Achsen-Wert ist eine Klasse, die

1. per **CRTP** eine topic-eigene Basis erbt, z.B.
   `PrefetchStrategyBase<Derived> : topics::AxisBase` (`axes/prefetch_axis/axis_07_prefetch_strategy_base.hpp:11-18`),
   deren protected-Ctor **drei Concepts** `static_assert`t (`PrefetchStrategy`,
   `CacheEnginePermutationStrategy`, `AxisBaseConcept`) — der **CRTP+Concept-Guard-Mix, KEIN vtable**;
2. die Cross-Axis-Wurzel `topics::AxisBase` (`get_compiler()`/`is_original_module()`,
   `topics/axis_base.hpp:52-79`) erfüllt, validiert durch `AxisBaseConcept` (`axis_base.hpp:90-94`);
3. den Permutations-Vertrag `axis_tag`/`family_id`/`name()`/`enabled` ergänzt
   (`axes/prefetch_axis/concepts/axis_07_prefetch_cache_engine_permutation_concept.hpp:11-18`).

**19 Organ-Achsen** = `using`-Slots T0..T18 in `AdHocComposition<T0..T18>`
(`anatomy/composition_factory.hpp:49-74`). Kanonische Namen/Reihenfolge:
`kCompositionAxisNames` (`builder/experiment_tree/axis_path_serialization.hpp:30-34`, verifiziert
`std::array<…,19>`): search_algo, cache_traversal, mapping, path_compression, node_type,
memory_layout, allocator, prefetch, concurrency, serialization, telemetry, value_handle, isa,
index_organization, io_dispatch, migration_policy, filter, queuing_q1, queuing_q2.
Physische Topic-Ordner unter `topics/`.

**Permutation → binary_id.** Ein Blatt ist ein `PermTuple<V0..V18>`; `CompositionFromPermTuple`
materialisiert die `AdHocComposition` (`composition_factory.hpp:87-109`,
`static_assert(sizeof...(Vs)==19)`). Der serialisierte Pfad
`search_algo=<V0::name()>/…/queuing_q2=<V18::name()>` **IST** der `binary_id`
(`axis_path_serialization.hpp:44-60`). Genau EINE kompilierte Tier-Binary je kartesischem Punkt.

**Komposition → Tier-Binary (monomorphisiert).** `SearchAlgorithmAnatomy<IsComposition Composition>`
(`anatomy/search_algorithm_anatomy.hpp:31-46`) hält jede Achse als reales Member
(`Composition::search_algo axis_search_algo_` …, Z.177-200) und exponiert `observe_all()`, per
`if constexpr (ObservableAxis<…>)` gegatet (Z.62-105). `AnatomyPermutationDriver::for_each_composition_type`
läuft das kartesische Produkt ab und instanziiert je Punkt eine Anatomie
(`anatomy/anatomy_permutation_driver.hpp:76-81`) — der compile-time Hot-Path, kein vtable.

**Pattern-Benennung:** Strategy (jede Achse) + CRTP-statischer-Dispatch + Concept-Guard (Meta-driven
Concept-Hardening, MOF/Sheard/Kiczales-benannt, `reference_meta_driven_concept_hardening_pattern`).

---

## 2. Allokatoren = Algorithmen der Allokator-Achse (axis_06) — MODELL-KONFORM

Der **Wrapper IST die Algorithmus-Wahl** (klassischer „Strategy als compile-time Typ"):

- `MimallocAllocator : public AllocatorStrategyBase<MimallocAllocator>`
  (`axes/alloc/axis_06_allocator_mimalloc.hpp:61-62`); Basis reines CRTP mit Concept-Guard-Ctor,
  **kein vtable** (`axis_06_allocator_strategy_base.hpp:63-81`,
  `static_assert(concepts::AllocatorStrategy<Derived>…)`).
- Der Wrapper übersetzt die Achsen-API `allocate(bytes,alignment)`/`deallocate` auf die Vendor-Calls
  `::mi_malloc_aligned`/`::mi_free` (`axis_06_allocator_mimalloc.hpp:125-166`). Sub-Refinements
  (`ZeroingStrategy`→`mi_calloc`, `ReallocatingStrategy`→`mi_realloc_aligned`,
  `IntrospectableStrategy`→`mi_usable_size`, `ReclaimableStrategy`→`mi_collect`) sind separate
  Concepts (Z.183-262, `static_assert` Z.274-281).
- **An/Aus ist compile-time:** `static constexpr bool enabled = flags::mimalloc_enabled` (Z.83).
  Der Vendor-Header läuft über EINEN Shim, der bei OFF Forward-Stubs liefert, damit der
  `if constexpr(false)`-Zweig syntaktisch gültig bleibt (`vendor_includes/mimalloc_include.hpp:20-36`).
  Kein `#ifdef` im Wrapper (W6-Pattern).

**Die 26 Algorithmus-Wahlen = eine Boost.MP11-Liste** (Single-Source-of-Truth der Achse):
`AllVendors = mp_list<StdMalloc, MimallocAllocator, SnmallocAllocator, JemallocAllocator, …>`
(`axis_06_allocator_registry.hpp:78-100`), gefiltert `EnabledVendors = mp_filter<is_enabled, AllVendors>`
(Z.117). Der Permutations-Codegen backt pro Tier-Binary genau EINE `EnabledVendors`-Wahl als
Template-Argument in `perm_<id>.cpp` — statisch, nicht runtime-geschaltet
(`no_runtime_switch`/`compile_time_only`). `std`/`pmr`/`pool` sind selbst-enthaltene Algorithmen;
die Vendor-Familien (mimalloc/jemalloc/snmalloc/tcmalloc) sind Algorithmen mit externem Objektcode.

→ **Modell-konform:** „Allokatoren = Algorithmen der Allokator-Achse (axis_06)" ist im Code sauber
realisiert. Der externe Objektcode ist genau der Grund für den DLL-Load-Bruch in §9.

---

## 3. Gattungen — 3-Ebenen-Taxonomie und das Modell-Delta

`anatomy/anatomy_base.hpp` führt die bewusst benannte Zwei-Namen-Realität (Z.68-77):

- **Ebene 1 `AnatomyGattung`** (Z.40-44, verifiziert) = Außen-/Prüf-Dock-Interface, **NUR 3**:
  `SearchAlgorithm=0` (K→V, std::map-artig), `Container=1`, `Graph=2`.
- **Ebene 2 `AnatomyGenus`** (Z.78-84) = Tier-Unterklasse: `SearchAlgorithm=0, Set=1, Sequence=2,
  Adapter=3, View=4`. `gattung_of()` (Z.100-109) faltet Set/Sequence/Adapter/View → `Container`.
  Die dokumentierte Zoologie-Brücke (Z.62-66): Säugetier=SearchAlgorithm, Vogel=Set, Reptil=Sequence,
  Wirbelloses=Adapter, Pflanze=View.
- **Ebene 3** = Achsen = Organe (permutieren).

**Bau-Brücke pro Gattung:** `GenusBindingTraits<G>`
(`builder/experiment_tree/genus_binding_traits.hpp:31-160`) liefert `slot_count`, `axis_names()`,
`CompositionFor`, `AnatomyFor` — SearchAlgorithm=19 (kCompositionAxisNames), Adapter=13, Set=15,
Sequence=11, View=7. „View = nur lesen aus sequential container" ist als eigenes non-owning Genus
gebunden (`genus_binding_traits.hpp:135-152`).

**Compile-Time-Wurzel** `AnatomyConcept` (Z.120-127): statisch `composition_t/composition_name/
paper_id/organ_count/genus`. **Runtime-ABI-Wurzel** `IAnatomyBase : IExecutionEngine` (Z.144-171):
liefert `composition_name/paper_id/genus/organ_count` virtuell, **trägt bewusst KEINE Treib-/Mess-
Methoden** (vtable-Layout stabil).

**DELTA zum User-Modell.** Das Modell setzt Ebene-1-Gattungen `map / container / set / graph` an
(Set als **eigene** Gattung). Der Code führt Set als **Genus UNTER Container** (Z.73-77). Die echte
Ebene-1-Promotion (`Set` als eigenes `AnatomyGattung`) ist der explizit ausstehende, **koordinierte
ABI-4→5-Schritt F1b** (Z.75-77). Vokabular-Brücke: User-„Gattung" == Code-`AnatomyGenus` (Ebene-2)
ist dokumentiert. „map = SearchAlgorithm-Hülle" ✓, „View = read-only aus sequential container" ✓.

---

## 4. Prüf-Dock-ABI-Vertrag CEB ↔ ABI-stabile Tier-.so

Der Vertrag hat DREI Teile: **Befehl** (was/welche Last) + **Settings** (dyn. System-Einstellungen)
+ **Ergebnis-Rückkanal** (Messwerte ABI-stabil zurück). Alle drei existieren funktional.

### 4a. Der Prüf-Dock selbst ist KEINE ABI-Grenze
`IPruefDock` (`builder/pruef_dock/pruef_dock.hpp:57-80`, `dock_genus()/accepts()/measure()`) lebt im
Builder-Binary, eine vtable, nicht Hot-Path (Z.10-14). Die **ABI-Grenze** ist das gattungs-eigene
Antriebs-Sub-Interface + der flache POD-Snapshot. `SearchAlgorithmDock::measure()`
(`search_algorithm_dock.hpp:36-58`): `accepts` matcht über die **im Modul deklarierte Gattung**
`anatomy()->genus()` (kein Dateiname), dann `dynamic_cast<IObservableTier*>` → **Konformitäts-Gate**
→ Messung. Bindende Reihenfolge `import → GATE → messen` (`pruef_dock.hpp:74-79`).

### 4b. Befehl — was ausführen / welche Last
Nutzlast `PruefDockMeasureOptions = AbiTierTraceConfig` (`pruef_dock.hpp:33`) =
`fill_checkpoints`/`lookups_per_checkpoint`/`deletes_per_checkpoint`/`seed`
(`tier_observe_trace_abi.hpp:33-43`). Treiber `drive_two_phase_tier_trace_abi` (Z.198-273) fährt je
Checkpoint WRITE/READ/DELETE **host-seitig** über die ABI-Punkt-Ops — die Last lebt NICHT in der
Binary. Reichere Last-Frameworks: `WorkloadOrchestrator::run_workload_profile`
(`workload_orchestrator.hpp:65-164`, Insert/Lookup/Erase/Clear/Scan via `IScannableTier`/RMW),
`run_measurement_plan` (Z.172-197) = „mehrere Lastprofile je Binary". **Diese läuft heute NICHT
durch das Prüf-Dock**, sondern im CEB-Iterator-Pfad (Lücke, §4f).

### 4c. Settings — dynamische System-Einstellungen via Prüf-Dock (H-9)
Flacher POD `ComdareResourceControlV1` (`anatomy/resource_controllable_tier.hpp:34-43`, verifiziert
`standard_layout`+`trivially_copyable`, 6× uint64: thread_count/prefetch_distance/pool_budget_bytes/
batch_size/inline_threshold_bytes/controllable_axis_count; Sentinel 0 = Default). ABI:
`IResourceControllableTier` (Z.56-68) mit `tier_query_resource_caps`/`tier_apply_resource_control`,
**IMMER verfügbar, auch Messung-AUS**. Fluss (`abi_adapter.hpp:224-279`): Caps-Query (5 steuerbare
Achsen: axis_06/07/08/03a/14) → apply klammert an Caps → reicht via
`if constexpr (requires{ organ_.set_runtime_*() })` an die Organe durch (gezählt nur bei realem
Setter-Konsum). Host-Treiber `AlgorithmResourceControl::apply_to`
(`builder/algorithm_resource_control.hpp:28-33`) leitet den `desired`-POD aus einem
`WorkloadProfileAggregate` her (Heuristik-Kurve). Das IST die „dynamische System-Unter-Achse via
Prüf-Dock gesendet" — sauber realisiert.

### 4d. Ergebnis-Rückkanal — ABI-stabil zurück
`tier_observe(ComdareTierObserverSnapshot*)` (`anatomy/observable_tier.hpp:181`) schreibt EINEN
konsolidierten, komposition-unabhängigen POD (Z.130-147): `axis_stats[19][8]` + `seg_ns[19]` +
Meta. Verifiziert **`sizeof==1416`, `alignof==8`**, `standard_layout`+`trivially_copyable`
(Z.128-151) → memcpy über die DLL-Grenze. Spalten-Vertrag `kV3AxisSchema[19]` (Z.66-104,
Single-Source Schreiber↔CSV). Host stempelt jeden Snapshot Wall-Clock-korreliert und persistiert
CSV/JSON. Segment-Latenzen zusätzlich als flache PODs (`ComdareSegmentLatencyV1`,
`measurable_workload.hpp:51-70`).

### 4e. Loader + ABI-Version
`AnatomyModuleLoader` (`anatomy_module_loader.cpp:106-157`): `dlopen(RTLD_NOW|RTLD_LOCAL)` /
`LoadLibraryW`, Validierung exists → load → **alle 4 Pflicht-Symbole** (`comdare_anatomy_abi_version/
_magic/comdare_create_anatomy/comdare_destroy_anatomy`) → **Magic** `0x434F4D444141342E` (".A4.") →
**Major-Match + Minor≤** → Factory non-null. **ABI-Major = 4** (verifiziert
`anatomy_module_abi_v1_decl.hpp:43-44`). `AnatomyModuleHandle` RAII/move-only, Destruktor ruft
`comdare_destroy_anatomy` VOR `dlclose` (gleicher Heap). Major-Bruch verwirft alt-gebaute DLLs.

### 4f. Lücken (funktional solide, aber noch nicht EIN Dock)
1. **Zwei parallele Treib-Pfade.** RC + Last-Framework + Scan + PMC laufen NICHT via Prüf-Dock,
   sondern im `cache_engine_builder_iterator`-Pfad (Z.750-756 castet direkt, umgeht `IPruefDock`).
   Das Modell „die CEB befiehlt AM Prüf-Dock … Settings via Prüf-Dock" ist nur im Iterator-Pfad real.
2. **RC ist organ-scoped, nicht system-scoped.** Der POD trägt 5 Tier/Organ-Achsen; die
   CEB-System-Achsen (Scheduling/Telemetrie-System/Last-Wahl) haben KEINEN eigenen ABI-Settings-POD.
3. **Nur 1 von 3 Gattungs-Docks.** Es existiert nur `SearchAlgorithmDock`
   (`pruef_dock_registry.hpp:4-5`: „Set/Sequence/Adapter/View kommen mit V42"); Container/Graph ohne Dock.
4. **ABI-Major noch 4**, kein 4→5 (siehe §7).

---

## 5. Compile-time Haupt-Achse + dynamische Runtime-Unter-Achse

- **Compile-time Haupt-Achse** = der T0..T18-Slot-Wert (permutiert `binary_id`, §1).
- **Dynamische Runtime-Unter-Achse** = `IResourceControllableTier` + `ComdareResourceControlV1`
  (§4c), host-getrieben via `AlgorithmResourceControl`, geklammert auf min(tier-caps, env_limits),
  auch bei abgeschalteter Messung. Orchestriert im CEB-Iterator: `run_lazy_static_then_dynamic`
  (`cache_engine_builder_iterator.hpp:668-819`) baut statisch → lädt → `dynamic_cast` der
  Sub-Interfaces (Z.750-756) → `RuntimeVariableLoop.run` wendet je dyn. Kombination
  `tier_apply_resource_control` an (`runtime_variable_loop.hpp:86-89`) → misst darunter.
- Daneben: compile-time Sub-Axis-Tags (queuing QS1–QS6/FS1–FS4, `topics/queuing/axis_q1_queuing/*.hpp
  @subaxis`) — reine Compile-Time-Familien-Klassifikatoren, kein Runtime.

Das deckt das Modell „compile-time Haupt-Achse + dynamische System-Unter-Achse via Prüf-Dock" (H-9).

---

## 6. CEB-System-Achsen ÜBER Tier-Binary-Achsen — Ist FLACH, Ziel GESCHICHTET

**Kernbefund:** Heute existiert KEINE Schichtung. `registry_to_axis_levels.hpp::build_all_axis_levels`
(Z.81) reflektiert **26 Achsen als eine flache `std::vector<AxisLevel>`**. Die einzige strukturelle
Zweiteilung ist `is_static` (compile-time → Teil der `binary_id`,
`experiment_tree.hpp:189-195`) vs. dynamisch (Laufzeit-Schleife, Z.198-203) — eine **Organ**-Zweiteilung,
keine System/Organ-Schichtung.

Die vom Modell geforderten CEB-System-Achsen liegen heute verstreut:

| CEB-System-Achse (Modell) | Modell-Soll | Ist-Zustand | Delta |
|---|---|---|---|
| **Telemetrie** (F12iii) | System-Achse in der CEB | Organ-Slot T10 (`composition_factory.hpp:62`; kCompositionAxisNames[10]); Mess-Telemetrie separat als `ObserverSnapshotSystemAxis`/`PmcSystemAxis` | telemetry permutiert `binary_id` statt CEB-System-Achse zu sein |
| **Hardware/ISA/AVX** (H-7, H-10) | CEB-System-Achse, treibt den Compiler | gespalten: `isa` T12 Organ-Slot; 3 build-only-Achsen (page_type, simd_extension/09b, general_hardware/12) als `DefinitionOnly`-Codegen NEBEN der Komposition (`registry_to_axis_levels.hpp:67-70). `make_gpp_compile_fn` hat KEIN `-march`/`-mavx` (Z.474-483) → Binary faktisch immer generisch `-O2` | H-7 (gezielt kompiliert) nicht realisiert; H-10-Metadaten vorhanden (§8) |
| **Scheduling** (#37) | CEB-System-Achse, compile-time STATISCH | `ISchedulingStrategy` = **RUNTIME-VTABLE** (`include/cache_engine/concepts/scheduling_strategy.hpp:37-46`), **NIRGENDS konsumiert** (repo-weiter grep: nur die Definitionsdatei) | doppeltes Delta: verwaist + laufzeit-polymorph, verletzt `no_runtime_switch`/`compile_time_only` |
| **Last/Last-Frameworks** (H-9) | CEB-System-Achse (Wahl der Lasten + Frameworks) | Last als ABI-Antrieb via `run_workload`/`WorkloadOrchestrator`; `workload`-DynDim ist Organ-dynamisch (`experiment_run_entry.hpp:144-147`) | Last existiert als Antriebspunkt, nicht als System-Achse |
| **Dyn. System-Unter-Achsen** (H-9) | via Prüf-Dock gesendet | `IResourceControllableTier` + `AlgorithmResourceControl` | **SAUBER realisiert** |

**Modell-Soll-Schichtung:** `System-Achsen (CEB-Ebene, statisch, versioniert) ⊃ Tier-Binary-Achsen
(Organ + Governor/Prefetcher)`, verbunden über den Prüf-Dock-ABI. Die Bausteine (Orchestrator,
CompileFn-Injektion, Prüf-Dock, Provenance-POD) sind vorhanden; es fehlt die **Schichtung** und die
**H-7-Compiler-Kopplung**. Andockpunkte:
- System-Achsen-Reflektion abspalten aus `registry_to_axis_levels.hpp:81` in ein eigenes
  `build_system_axis_levels()` mit eigener abstrakter Wurzel (Organ vs System nie mischen).
- H-7: `make_gpp_compile_fn` (`build_orchestrator.hpp:466`) um `-march`/`-mavx…` aus der
  System-Achsen-Belegung erweitern (die injizierte `CompileFn`, `build_orchestrator.hpp:115`, ist der
  saubere, Engine-agnostische Parametrisierungs-Ort).
- Scheduling: statt der verwaisten vtable-Version eine compile-time CEB-System-Achse (deckt sich mit
  Golden-Umbau).
- Governor/Prefetcher (H-8) bleiben **Tier-Binary-Achse** (Teil des Strategy-/Heuristik-Command-Pattern
  eines virtuellen Tier-Binaries), NICHT System-Achse.

---

## 7. Experiment-Planer-Dock (die Naht für Anatomy-Major 4→5)

**Es gibt heute keinen benannten „Experiment-Planer-Dock"** (grep `Planer/planner/AnatomyMajor` im
`libs/`-Code = leer). Die reale Naht, an der der Anatomy-Major reiten soll, ist die Übergabe
**Planer → CEB-Messsystem-Erstellung**: `run_experiment_profile`
(`profile_facade/experiment_run_entry.hpp:93`) parst die 3-Phasen-Experiment-XML (Z.97-105),
projiziert auf SOTA-Pässe, baut je Pass eine `LazyRunConfig` (Z.225-249) und reicht sie an
`run_lazy_static_then_dynamic(...)` (Z.250-251, Kern in `cache_engine_builder_iterator.hpp:668`).
Genau HIER wird die Golden-XML in Bau-/Mess-Pässe zerlegt — die Stelle, an der die GOLDEN
„zerlegt + umgebaut" wird.

Der Experiment-Planer-Dock (neu, 4→5) ist zwischen diese beiden zu ziehen und soll: (1) die
System-Achsen-Belegung entgegennehmen, (2) die CEB darunter parametrieren, (3) die Tier-Binaries
untergeordnet-statisch bauen (`BuildOrchestrator::provision_all`,
`cache_engine_builder_iterator.hpp:697-698`), (4) am **Prüf-Dock** die Messung befehlen und die
ABI-stabilen Ergebnisse zurücknehmen — womit der heute umgangene `IPruefDock`-Vertrag wieder scharf
gestellt wird. Der ANATOMY-MAJOR 4→5 reitet an dieser Naht gegenüber der bestehenden Golden-Zerlegung.

Die untergeordnete Tier-Binary-Fertigung ist bereits vorhanden: `BuildOrchestrator`
(`builder/build_orchestrator/build_orchestrator.hpp:182`) — multithreaded, RAM-gated, resumierbar;
`provision_core` (Z.210) generiert Source (injizierte `SourceGenFn`) und kompiliert (injizierte
`CompileFn`), schreibt danach das Versions-Sidecar (Z.322). Real-Anatomie-Source via
`ceb_generator.hpp::generate_all_real<Engine>` → `adhoc_emitter.hpp::emit_adhoc_modules<Engine>`
(`COMDARE_DEFINE_ANATOMY_MODULE_ADHOC(<19 FQ-Typen>)`).

---

## 8. Versionierung / Metadaten (H-10)

**Vorhanden und kohärent:**
- ABI-Sidecar `BuildVariantDefinitionV1` via extern-C `COMDARE_DEFINE_BUILD_VARIANT_INSPECTION`
  (`include/cache_engine/abi/build_variant_inspection.hpp`), trägt simd_width/avx512
  (`build_variant_definition.hpp:22-24`).
- Kohärenz-Guard `declared_extension_matches_build<SE>()` + CMake-Flag
  `comdare_apply_simd_extension_flags`.
- `.version`-Sidecar (`build_orchestrator.hpp:162-179`, geschrieben Z.322) +
  `provenance_manifest.hpp::write_provenance_manifest` (Z.98) mit
  `isa_built_for`/`isa_ran_on`/`compiler`/git-SHAs (Z.79-95).

**Delta zum Modell (H-10 „NEBEN jedem Binary, AVX10-Versionsfeld"):** das Provenance-Manifest ist
heute **global**, nicht per-Binary. Modell verlangt es je Tier-Binary im per-Binary-Subdir
(`build_orchestrator.hpp:265-274`) mit einem AVX10-Versionsfeld. Natürliches Zuhause: der ABI-POD
`BuildVariantDefinitionV1` um ein AVX10-Feld erweitert, ins per-Binary-Verzeichnis geschrieben.
Statische Kompilation einer CEB/Tier-Binary IMMER versioniert + in Metadaten NEBEN dem Binary
dokumentiert (H-10).

---

## 9. DLL-LOAD-AUFLÖSUNG (F1) — Option A vs B, begründete Empfehlung: **B**

### Der Bruch (code-belegt)
Zwei getrennte Wege, aus `perm_<id>.cpp` eine ladbare `.so` zu machen — nur einer linkt den Allokator:

- **(A-Bau) CMake-`add_library(SHARED)`-Pfad (funktioniert, self-linkt).**
  `tools/permutation_codegen/codegen.cmake:584` legt `add_library(perm_<id> SHARED …)` an und
  `:607-613` `target_link_libraries(perm_<id> PRIVATE comdare::vendor_mimalloc)` (statisches Archiv
  aus `ext/CMakeLists.txt:29-35`, `MI_STATIC_LIB=1`, PIC). → `mi_malloc_aligned` als **definiertes**
  T-Symbol in der `.so`. Analog je/sn/tc (`:614-632`). Zweiter CMake-SHARED-Pfad: `adhoc_emitter.cmake:141`.
- **(B-Bau) Laufzeit-`make_gpp_compile_fn`-Pfad (bricht).** `build_orchestrator.hpp:466-489` schreibt
  eine `.rsp` mit **ausschließlich** `-std=c++23 -O2 -fPIC -shared -fno-gnu-unique`, defines,
  include_dirs, Quelle, `-o` (verifiziert Z.474-483). **Kein `-l`, kein Archiv.** `BuildJob`
  (`:86-92`) trägt nur source/output/cores — **kein Link-Input-Kanal**. → `mi_*` bleiben **undefined**.
  Die Fassade backt nur die Include-Menge (`profile_facade/CMakeLists.txt:131-138`,
  `COMDARE_FACADE_PERM_INCLUDES`), nie das Archiv; `perm_include_dirs()`/`perm_mess_defines()`
  (`profile_run_facade.cpp:65-96`) führen keine Link-Bibliothek. Das ist der Produktions-Golden-Run-
  Pfad (`profile_run_facade.cpp:154`).
- **Warum erst beim Laden:** `dlopen(RTLD_NOW|RTLD_LOCAL)` (`module_loader.hpp:26`, verifiziert)
  erzwingt sofortige Auflösung ALLER undefinierten Symbole und hält Symbole privat → `dlopen`
  scheitert mit `undefined symbol: mi_malloc_aligned` (`module_loader.hpp:38-42`).

### Die zwei Auflösungs-Optionen
- **Option A** — Host `ENABLE_EXPORTS`/`-rdynamic`, Host linkt mimalloc, DLL zieht `mi_*` aus dem
  Host-globalen Scope.
- **Option B** — die DLL self-linkt ihren Allokator (repliziert den CMake-Pfad in den Laufzeit-Pfad).

### Bewertung im Licht der Konstruktionslogik

**Option A ist DOKTRIN-WIDRIG an fünf Stellen:**
1. **Bricht die Allokator-ALS-Algorithmus-Achse an der Wurzel** (§2): eine EINZIGE prozessweite
   mimalloc-Instanz, geteilt von jeder dlopen'ten Perm-DLL. Zwei mimalloc-Permutationen teilen
   Arenas/Thread-Caches → warmer, verschmutzter Zustand aus Permutation N−1 kontaminiert Messung N →
   verfälschte Allokator-Achsen-Messung.
2. **Bricht den Destroy-Vertrag** (§4e): `destroy_instance`+`dlclose` können die Arenas nicht
   zurückgeben, wenn der Allokator im Host lebt → kein sauberer, wiederholbarer Mess-Zyklus.
3. **Verletzt den Prüf-Dock-ABI „self-contained":** `mi_*` sind NICHT Teil des ABI
   (`module_abi_v1`/`get_module_v1`); A schmuggelt eine verdeckte globale Symbol-Abhängigkeit ins
   Kontrakt-Fundament → Widerspruch zur Vendoring-Doktrin vendor→faithful→**self-contained**.
4. **Bricht die H-10-Versionierung** (§8): die Metadaten-Zeile „diese Binary nutzt mimalloc vX" kann
   den Artefakt-Inhalt nicht wahrheitsgemäß beschreiben, wenn der Allokator im Host liegt.
5. **Koppelt statisches Dispatch an Runtime-Symbol-Resolution** → konträr zu
   `no_runtime_switch`/`compile_time_only`.

**Option B ist die konstruktionslogisch korrekte:**
1. **Faire, isolierte, pro-DLL-Messung:** eigenes statisches mimalloc je Perm-DLL; unter
   `RTLD_LOCAL` sind `mi_*` privat, kein Clash → jede Permutation startet mit frischem Allokator →
   keine Kreuz-Kontamination, exakt was die Achse messen SOLL.
2. **Ehrt den Destroy-Vertrag:** `dlclose` entlädt die DLL samt mimalloc → sauberer Teardown.
3. **Self-contained Prüf-Dock-ABI:** Allokator ist internes Detail (Visibility hidden,
   `codegen.cmake:594-595`); die DLL erfüllt den Kontrakt allein über ihre C-Symbole.
4. **Macht H-10 wahrheitsfähig:** der Allokator liegt IN der Binary.
5. **Bereits der bewiesene, funktionierende Golden-Pfad** — B macht den Laufzeit-Pfad nur
   string-gleich zu `codegen.cmake:610`.
- **Kosten:** größere DLLs (je eine Allokator-Kopie), minimal längeres Linken — der korrekte Preis
  für Isolation, im CMake-Pfad ohnehin schon gezahlt.

### EMPFEHLUNG: Option B (deckt sich mit der User-Tendenz)
Option A wäre der „einfachste Weg" (ein `-rdynamic` am Host) — und genau der falsche laut
`infra_cleanest_not_easiest`.

**Konkreter Fix-Ort (Struktur-Lücke, nicht Zeile):** Der Bruch ist, dass `make_gpp_compile_fn`
(`build_orchestrator.hpp:466-489`) und `BuildJob`/`CompileFn` (`:86-115`) **keinen Link-Input-Kanal**
haben. B erfordert:
1. einen `link_libs`/`link_inputs`-Parameter durch `make_gpp_compile_fn` (bzw. ein Feld in
   `BuildJob`), der pro gewählter Allokator-Wahl den aufgelösten Archiv-Pfad trägt (z.B.
   `…/libcomdare_vendor_mimalloc.a`), angehängt an die `.rsp` **nach** der Quelle;
2. die Fassade backt diesen Pfad genauso wie heute die Includes (`profile_facade/CMakeLists.txt:131-138`)
   — zusätzlich `$<TARGET_FILE:comdare::vendor_mimalloc>` (und je/sn/tc) statt nur deren
   `INTERFACE_INCLUDE_DIRECTORIES`. Das spiegelt `codegen.cmake:607-632` eins-zu-eins in den
   Laufzeit-Pfad. `--whole-archive` ist i.d.R. unnötig (`mi_*` per Wrapper odr-genutzt → vom Linker gezogen).

**Relevante Dateien:** `builder/build_orchestrator/build_orchestrator.hpp` (466-489, 86-115),
`profile_facade/profile_run_facade.cpp` (65-96, 154), `profile_facade/CMakeLists.txt` (131-138),
`include/cache_engine/abi/module_loader.hpp` (26, 38-42), `tools/permutation_codegen/codegen.cmake`
(584, 606-632), `ext/CMakeLists.txt` (23-50), `axes/alloc/axis_06_allocator_mimalloc.hpp`,
`axis_06_allocator_strategy_base.hpp`, `axis_06_allocator_registry.hpp`,
`axes/alloc/vendor_includes/mimalloc_include.hpp`.

## NACHTRAG 2026-07-17 — Dock-Terminologie (User-Schärfung, autoritativ)
- **Experiment-Dock** (Planer ↔ CEB): **EINDIMENSIONAL** — der Experiment-Planer STEUERT die Einstellungen der von ihm kompilierten CEB (Planer → CEB, KEIN Rückkanal hier).
- **Prüf-Dock** (CEB ↔ Tier-Binary): **BIDIREKTIONAL** — die CEB treibt die Tier-Binary an ↔ die Tier-Binary meldet Messergebnisse ABI-stabil zurück (zu ihren verschiedenen Arten von Tier-Binary-.so-Interfaces).
- **Ergebnis-Rückschrieb NICHT über das Experiment-Dock:** die CEB schreibt nach Bestimmungen des Experiment-Planers die angeforderten Aufgaben + Messwerte SELBST an das in der XML eingegebene Ziel zurück. Verknüpft mit dem Mess-Ergebnis-Rückschreibungs-Strang (§11-G: `measurement/<YYYYMMDD-HHMMSS>/`, Write-Token id=54, Loop-Schutz) + Memory `feedback_recursive_dock_planer_ceb_tier_abi_stable_so`.
