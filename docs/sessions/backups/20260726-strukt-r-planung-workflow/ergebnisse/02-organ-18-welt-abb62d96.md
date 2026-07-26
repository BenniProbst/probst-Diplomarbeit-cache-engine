# ORGAN-18-WELT (`persistence_target`) — Naht-Karte + Bruch-Kette

Basis: Session-Doc `docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md` komplett gelesen (§1 Sortierung, §2 R-A..R-E, §5 NEUE 18. Organ-Haupt-Achse, §7 STRUKT-R vor Voll-Bau-4). Alle Pfade relativ zu `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/`. NICHTS geaendert (nur gelesen).

## (1) kCompositionAxisNames + Organ-only-Guard

| Naht | Datei:Zeile | Ist |
|---|---|---|
| Array-Aritaet | `libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp:34-37` | `std::array<std::string_view,17> kCompositionAxisNames` = search_algo..queuing_q2 |
| Format-Doku | `.../axis_path_serialization.hpp:10` | `"...queuing_q2=<W16::name()>" (17 Slots, INC-2d)` |
| Serialize aus PermTuple | `.../axis_path_serialization.hpp:50-63` (Guard `i < ...size()` :56) | mp_for_each ueber `P::variants`, Index-getrieben -> zieht automatisch mit, SOBALD das Array 18 hat und PermTuple 18 traegt |
| Serialize aus Slots | `.../axis_path_serialization.hpp:70-84` | `std::array<...,17> v` (:72) + 17 explizite `C::<slot>::name()` (:73-77) -> HANDARBEIT |
| Shape-Anhang | `.../axis_path_serialization.hpp:91-98` | `with_shape_segment` haengt NACH queuing_q2 an; Default `void` = byte-identisch |
| Organ-only-Guard | `libs/cache_engine/builder/experiment_tree/profile_to_tree.hpp:32-36` `is_organ_composition_axis()` | Iteriert `kCompositionAxisNames` -> zieht automatisch mit |
| Guard-Anwendung | `.../profile_to_tree.hpp:96` `if (!is_organ_composition_axis(ax.ref)) continue;` | nur Organ-Achsen erzeugen `is_static=true`-Level (:102) = binary_id-Segment |
| Sub-Achsen-Vorzweige | `.../profile_to_tree.hpp:67-88` | `cacheline`/`node_width`/`alloc_hw` laufen VOR dem Guard (eigene `<axis>.<sub>`-Level) — DAS ist das Muster fuer kuenftige `persistence_target`-Unter-Achsen |
| Weitere Konsumenten | `profile_facade/validate_profile.hpp:54,188,191,226` · `profile_facade/lazy_adhoc_source_gen.hpp:163-164` · `profile_facade/planner/plan_legend.hpp:112-113` · `builder/experiment_tree/axis_variant_version_table.hpp:129,159` · `builder/experiment_tree/composition_registry.hpp:31,40` · `builder/experiment_tree/cache_engine_builder_iterator.hpp:28` | alle iterieren das Array -> auto-mitziehend (CSV-seg-Spalten inkl.) |

## (2) AdHocComposition static_assert 17 + GenusBindingTraits-Slot-Zahlen

| Naht | Datei:Zeile | Ist |
|---|---|---|
| Template-Aritaet | `libs/cache_engine/anatomy/composition_factory.hpp:60-61` | `template <class T0 ... class T16>` (17 Params) |
| Named usings | `.../composition_factory.hpp:63-79` | 17 `using <slot> = T<n>;` |
| **static_assert 17** | `.../composition_factory.hpp:98-101` | `static_assert(sizeof...(Vs) == 17, "PermTuple muss exakt 17 Achsen-Werte enthalten ...")` |
| Concepts | `.../composition_factory.hpp:126-133` | `IsPermTuple19` (real 17) + Alias `IsPermTuple17` |
| **KEINE Template-Defaults** | `.../composition_factory.hpp:56-59` | "jedes Tier deklariert q1/q2 ebenso explizit wie die 15 davor" -> Kern von (6) |
| Concept-Pflichtliste | `libs/cache_engine/anatomy/composition_concept.hpp:20-56` | `IsComposition` = 17 `typename C::<slot>;` |
| Organ-Zahl | `.../composition_concept.hpp:62-65` | `composition_organ_count<C>::value = 17` (hart) -> speist `organ_count()` (`anatomy/search_algorithm_anatomy.hpp:42`, ABI-Symbol) |

GenusBindingTraits (`libs/cache_engine/builder/experiment_tree/genus_binding_traits.hpp`) — 17-11-13-9-5:

| Gattung | slot_count | CompositionFor | axis_names() |
|---|---|---|---|
| SearchAlgorithm | :39 `= 17` | :43-44 (`CompositionFromPermTuple`) | :49-51 `array<...,17>&` -> `kCompositionAxisNames` (Alias, keine eigene Liste) |
| Adapter (Container) | :63 `= 11` | :68-70 (10 + `Inner`) | :74-79 eigene `array<...,11>` |
| Set | :88 `= 13` | :93-95 | :99-106 eigene `array<...,13>` |
| Sequence | :115 `= 9` | :120-122 (8 + `Growth`) | :126-131 eigene `array<...,9>` |
| View | :140 `= 5` | :145-147 (2 + 3 Policies) | :151-155 eigene `array<...,5>` |

Wichtig: nur SearchAlgorithm haengt am 17er-Array. Adapter/Set/Sequence/View haben EIGENE Namenslisten -> `persistence_target` beruehrt sie **nur, wenn** die Gattung sie teilen soll. Header-Kopf :5-9 dokumentiert "AdHocComposition<19>" (stale Kommentar).

## (3) Observer-POD

| Naht | Datei:Zeile | Ist |
|---|---|---|
| Achsen-Zahl | `libs/cache_engine/anatomy/observable_tier.hpp:49` | `kV3AxisCount = 17` |
| Feld-Zahl | `.../observable_tier.hpp:52` | `kV3FieldCount = 8` |
| **kV3AxisSchema** | `.../observable_tier.hpp:68-100` | `V3AxisFieldNames kV3AxisSchema[kV3AxisCount]` — 17 Zeilen `/*T0..T16*/`, jede 8 Slots; T16 queuing_q2 :98-99 = letzte Zeile |
| Abgeleitete Diagnose | `.../observable_tier.hpp:105-112` | `v3_count_filled_axes()` iteriert Schema -> auto-mitziehend |
| POD | `.../observable_tier.hpp:127-144` | `axis_stats[17][8]` (:128) + `seg_ns[17]` (:129) + 4 Meta (:130-133) + 2 P-MD3 (:140-141) |
| **sizeof-Wache** | `.../observable_tier.hpp:152-154` | `static_assert(sizeof(...) == 1272)` = 17*8*8 + 17*8 + 48 |
| Version | `.../observable_tier.hpp:158-159` | `kTierObserverSnapshotVersionUnified = 7` |
| ABI-Major | `libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp:54-55` | `COMDARE_ANATOMY_ABI_MAJOR 6` / MINOR 0 (:35,:51 dokumentieren die 17er-Form) |
| Schreiber (DLL) | `libs/cache_engine/anatomy/abi_adapter.hpp:1294-1404` | `s.axis_stats[10] .. [16]` HARTE Indizes; :1405 `observable_axis_count` |
| Seg-Timer | `abi_adapter.hpp:566` (Index-Doku), `:671` `acc[17]`, `:837` `acc[16] += ...`, `:1454` `acc[17]`, `:1634` `acc[16] += dns(...)` | harte 17/16 |
| Seg-POD Vorstufe | `libs/cache_engine/anatomy/measurable_workload.hpp:99` `seg_ns[17]` · `builder/experiment_tree/experiment_tree.hpp:75` `seg_ns[17]` | |
| Aggregat | `libs/cache_engine/anatomy/observer_aggregate.hpp:94-140` | 17 Snapshot-Member (`queuing_q2` :113), `total_slots() == 17` (:140) |
| **CSV-Schreiber** | `builder/experiment_tree/cache_engine_builder_iterator.hpp:300-330` `lazy_csv_header()` | seg-Spalten aus `kCompositionAxisNames`, `stat_<achse>_<feld>` aus `kV3AxisSchema` -> **auto-mitziehend** (Kommentar :302 sagt noch "18 per-Achsen-Timer-Spalten" = stale) |
| **CSV-Leser (HART)** | `builder/experiment_tree/result_ingest.hpp:47` `if (f.size() != 160 ...) return nullopt;` + `:60-62` `for (t < 17)` | 1 + 136 + 17 + 4 + 2 = 160 EXAKT |
| Formatter | `libs/cache_engine/harness/perm_runner.hpp:49-50,83,114,324` | 160-Feld-Kontrakt |
| Klassifikation | `builder/experiment_tree/axis_observer_classification.hpp:34,54` | "17 Komposition-Achsen -> ObserverAggregate<17>" |
| Operabilitaet | `builder/experiment_tree/axis_operability_classification.hpp:34-52` | `array<AxisOperabilityEntry,17>` (enthaelt noch telemetry/isa statt q1/q2 — vor-INC-2d-Rest) |
| Organ-Stempel | `include/cache_engine/abi/anatomy_version_stamp.hpp:42-62` | `array<AxisVersionEntry,17>` mit 17 expliziten Zeilen |

## (4) FullSourceCatalog + CRC + Anti-Materialisierungs-Guard

Alles in `libs/cache_engine/profile_facade/source_catalog.hpp`:

| Naht | Zeile | Ist |
|---|---|---|
| Template | 91-93 | `template <std::size_t K00 ... K16>` (17 Params) |
| Slot-Listen | 94-112 | `L00..L16 = mp_take_c<...TopicConfigSet::StaticAxisVariants*, K<n>>` |
| Engine | 114-118 | `PermutationEngine<CatalogCfg<L00> ... CatalogCfg<L16>>` (nur Alias, nie instanziiert) |
| **FullSourceCatalog** | **127** | `CatalogAxes<2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2>` = 2^17 = 131072 |
| golden_320_catalog | 131 | `CatalogAxes<4,1,1,1,4,5,1,4,1,1,1,1,1,1,1,1,1>` = 320 |
| SmallSourceCatalog | 135 | `<1,1,1,1,2,2,1,...>` = 4 |
| Produkt | 141-152 | `catalog_axis_product<>()` = 17 explizite `mp_size<L<n>>`-Faktoren |
| **Count-Guards** | 156-160 | `==131072` / `==320` / `==4` |
| **CRC-Anker** | **168** | `kNewGolden131072Crc64 = 0xF1C1F26A1232073BULL` |
| **Anti-Materialisierung** | **183** | `kMaxMaterializableCatalogCardinality = 4096` |
| Guard-des-Guards | 187-190 | Full > 4096 (Ausschluss) UND 320 <= 4096 (Zulassung) |
| Level-Quelle | 192-218 | `catalog_static_levels<Catalog>()` — 17 explizite `push_static_axis<Catalog::L<n>>(lv, "<name>")` |
| Negativ-Guard | 230-253 | `make_catalog_source_gen<Catalog=golden_320_catalog>`: `is_forbidden_full_form` (`is_same_v<Catalog,FullSourceCatalog>`) + `within_materialization_bound` in `if constexpr` -> `build_pilot_source_map<FullSourceCatalog::Engine>` bricht billig statt GB-TU/ICE |
| Sweep-Kataloge | 304 `AxisSweepCatalog`, 354-380 `AxisSweepCatalogFull` (L00..L16, Baseline-Kommentar :380), 411-452 **16 Sweep-Aliase mit je 17 Positions-Argumenten**, 460-480 + 489+ Namens-Dispatch | 17-stellig, HANDARBEIT je Alias |

Flankierend: `profile_facade/lazy_adhoc_source_gen.hpp:112` `LazySlotTables = array<vector<...>,17>` + `:134-153` 17 Tabellen-Initializer · `apps/catalog_codegen_tool/main.cpp:113-150` `array<SlotSpec,17> make_slots()` (+ Signaturen :151,:162,:169) · `builder/codegen/adhoc_emitter.hpp:52-77` `adhoc_macro_args<C>()` = 17 explizite `add(type_name<typename C::<slot>>())` · `builder/codegen/all_axes_umbrella.hpp:19-40` Registry-Includes · `include/cache_engine/abi/anatomy_module_abi_v1.hpp:71-73` ADHOC-Makro (VARIADISCH -> aritaets-neutral), `:83-85` _BUILDVARIANT, `:95+` _SHAPED.

Deklarative Spiegelung: `libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml` — 17 `<axis ref=...>` je 2 `<value>`, 17 `<axis_sweep>`, `active_axes="..."` mit 17 Namen, `run_options cap="131072"`.

## (5) Organ-Registry: GENERIERT, nicht handgefuehrt

`libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml` (125 Zeilen, Header-Kommentar Z.1-8: "GENERIERT von tools/axis_registry_gen ... NICHT von Hand editieren").

- **Tool:** `tools/axis_registry_gen/main.cpp` (Target `comdare_axis_registry_gen`, `EXCLUDE_FROM_ALL`, `tools/axis_registry_gen/CMakeLists.txt`; `tools/CMakeLists.txt:9`). Reflektiert `ex::axes26::T*` (= `TopicConfigSet::StaticAxisVariants*` = `mp_filter<is_enabled, All*>`), NIE `All*` (Leitplanke :9-17). Achsen-Liste hart: **`main.cpp:207-224`** (17 `make_axis<...>(...)`-Zeilen, `T15/T16` = q1/q2 auf Slot `T15`/`T16`), Extra-Achsen `:227-238`. `golden_wired` = `mp_take_c<Enabled*, GoldenK>` mit GoldenK inline im Aufruf (`:207-224`; `reflect_axis` schuetzt via `kTake = min(GoldenK,kSize)` :140-141 — anders als `CatalogAxes`!). Guards: `name_is_clean` (kein `(`/Space) :180-183/:245-249, F30-Literal-Praefix :250-258.
- **Roundtrip-Gate:** `tests/unit/CMakeLists.txt:3793-3803` `test_axis_registry_roundtrip` (Script `tests/unit/registry_roundtrip.cmake`, Labels `contract;registry;roundtrip`, CI-Heimat Job `contract:profile_coverage`) -> Registry-Byte-Drift = harter CI-Rot (das war K-13/§29).
- **Registrierungs-Kette einer NEUEN Organ-Achse (7 Stationen, alle Pflicht):**
  1. `libs/cache_engine/axes/<achse>/axis_<n>_<achse>_registry.hpp`: `AllX = mp_list<...>`, `template<class T> using is_enabled = mp_bool<T::enabled>`, `EnabledX = mp_filter<is_enabled, AllX>`, `static_assert(mp_size<EnabledX> > 0)` (Vorbild: `axes/mapping/axis_03m_mapping_registry.hpp`, `axes/migration_policy/axis_migration_registry.hpp`).
  2. `libs/cache_engine/axes/<achse>/axis_..._flags.hpp.in` mit `#cmakedefine01 COMDARE_AXIS_<X>_USE_<Y>` + `inline constexpr bool <y>_enabled = ...`.
  3. Root `CMakeLists.txt`: `option(COMDARE_AXIS_<X>_ENABLE_<Y> ... ON/OFF)` (Muster :268-269 mapping) + `foreach`-USE/ENABLE-Mapping + `configure_file(...flags.hpp.in -> ${CMAKE_CURRENT_BINARY_DIR}/generated/axes/<achse>/...flags.hpp @ONLY)` + `message(STATUS ...)` (Muster :938-952 mapping, :1181-1194 migration). Keine Header-Auflistung notwendig (header-only, `libs/cache_engine/CMakeLists.txt` listet 0 `.hpp`).
  4. `libs/cache_engine/topics/<topic>/topic_<topic>_config_set.hpp`: `using StaticAxisVariants_XX = axis_<achse>::EnabledX; using StaticAxisVariants = StaticAxisVariants_XX;` (Vorbild `topics/io/topic_io_config_set.hpp`, `topics/migration/topic_migration_config_set.hpp`) + Forwarding-Header `topics/<topic>/axis_<achse>/axis_..._registry.hpp` (Muster `topics/migration/axis_migration/axis_migration_registry.hpp`).
  5. `builder/experiment_tree/registry_to_axis_levels.hpp`: neuer `axes26::T26_persistence_target`-Alias (:47-78) + `push_static_axis<...>(lv, "persistence_target")` in `append_organ_core_axis_levels` (:88-104, bzw. sortierungsgerecht) + Faktor in `all_axes_matrix_count()` (:150-163).
  6. `tools/axis_registry_gen/main.cpp:207-224`: `axes.push_back(make_axis<ex::axes26::T26_persistence_target, K>("T17","persistence_target","composition"));` -> danach Registry-XML regenerieren + committen (sonst Roundtrip-Gate rot).
  7. Je Baustein `COMDARE_DEFINE_ORGAN_LOCATION("::comdare::cache_engine::<ns>::<Typ>", "axes/<achse>/<datei>.hpp")` (`anatomy/organ_location.hpp`) — sonst `header=""` in der XML; F30-Guard prueft Praefix-Beziehung zum echten Typ. Plus `all_axes_umbrella.hpp:19-40`-Include (sonst "kein Member" im emittierten perm-.cpp), plus `algo_version` (`AxisVariantVersion`-Tabelle, `axis_variant_version_table.hpp`).

## (6) Durchreich-Baustein: wo notwendig + Kopier-Vorlage

**Warum ueberhaupt (M6 "keine Achse optional"):** `composition_factory.hpp:56-59` — "KEINE Template-Defaults: jedes Tier deklariert q1/q2 ebenso explizit wie die 15 davor" + `IsComposition` (`composition_concept.hpp:20-56`) verlangt JEDEN Slot als `typename`. Ein `memory_only`-Durchreich-Baustein ist also **kein Default, sondern Pflicht-Wert** jeder Komposition.

Wo er gebraucht wird:
- **14 Referenz-Kompositionen**: `libs/cache_engine/compositions/{art,hot,masstree,surf,start,wormhole,prt_art,prt_art_merge}_reference.hpp` + die 6 `*_paper_binding_reference.hpp` (alle tragen `using queuing_q2 = ...` -> alle brauchen `using persistence_target = ...`).
- **20 Test-Kompositionen**: `tests/unit/test_{v41_anatomy,v41_anatomy_observer,all19_segment_timer,m8_storetrav_segment,d3_ceb_generator,m_w12_stamp_bausteine,234_va_shaped_adapter,234_vb_rest_families_shaped,188_4bbV_pool_adapter_flip_compile,ap15_2_get_allocator_proxy,s7_1..s7_10_*_pool_allocator_deg}.cpp` (34 Dateien insgesamt mit `using queuing_q2`).
- Emitter-Seite: `adhoc_emitter.hpp:52-77` (18. `add(...)`), `lazy_slot_type_tables()` (`lazy_adhoc_source_gen.hpp:134-153`), `make_slots()` (`catalog_codegen_tool/main.cpp:113-150`), `catalog_static_levels()` (`source_catalog.hpp:192-218`).
- Anatomie-Seite: `search_algorithm_anatomy.hpp` (Organ-Member + `observe_all`-Zweig, Muster q1/q2 :98-102/:148-151/:197-198), `abi_adapter.hpp` (Organ-Member :2095-Umgebung + `fill_observer_v3`-Slot + Seg-Timer-Zweig + Reset :1674/:1971), `observer_aggregate.hpp:94-140`.

**Kopier-Vorlage (Empfehlung, zweiteilig):**
- **Achsen-Skelett (kleinste vollstaendige 2-Wert-Achse im Repo):** `libs/cache_engine/axes/mapping/` — 6 Kern-Header (`axis_03m_mapping_base.hpp`, `_registry.hpp`, `_flags.hpp.in`, `_direct_placement.hpp`, `_pool_relative.hpp`, `_subaxes_mp1_to_mp2.hpp`) + `concepts/`; genau 2 Bausteine = exakt die `memory_only` + `disk_writeback`-Kardinalitaet; CMake-Block `CMakeLists.txt:268-269` + `:938-952`; Topic-Andockung `topics/traversal/axis_03m_mapping/` + `TopicConfigSet::StaticAxisVariants_03m`.
- **Durchreich-Koerper (Semantik `memory_only`, `golden_wired`):** `libs/cache_engine/axes/migration_policy/axis_migration_none.hpp` — `NoMigration` ist die reinste Durchreich-Vorlage im Repo: `family_id = integral_constant<int,0>`, `static constexpr bool enabled = flags::none_enabled`, `is_active() == false`, `name() == "migration_none"`, `COMDARE_DEFINE_ORGAN_LOCATION(...)`, `algo_version = "v1.0.0"`, Mess-Op mit ehrlichem `return 0` ("echte Baseline, bewusst leerer Pfad, nicht n/a"). Gleichwertig: `axes/prefetch_axis/axis_07_prefetch_none.hpp` (`NonePrefetch`), `axes/io_dispatch/axis_io_in_memory_only.hpp` (semantisch am naechsten: `io_in_memory_only` ist bereits der golden-Index-0-Wert von io_dispatch).

## (7) RECHNUNG: 2^18 vs 2^17 — woran `enabled` haengt

**Kette (belegt, 5 Glieder):**
`CMakeLists.txt option(COMDARE_AXIS_<X>_ENABLE_<Y>)` -> `foreach` setzt `COMDARE_AXIS_<X>_USE_<Y>` 1/0 -> `configure_file(axis_..._flags.hpp.in)` -> `#cmakedefine01` -> `inline constexpr bool <y>_enabled` -> Baustein `static constexpr bool enabled = flags::<y>_enabled` (`axis_migration_none.hpp`) -> `is_enabled = mp_bool<T::enabled>` -> `EnabledX = mp_filter<is_enabled, AllX>` (`axis_migration_registry.hpp`) -> `TopicConfigSet::StaticAxisVariants` -> `mp_take_c<StaticAxisVariants, K<n>>` in `CatalogAxes` (`source_catalog.hpp:95-112`) -> `mp_size<L<n>>` in `catalog_axis_product<>()` (:141-152).

**Fall A — `disk_writeback` ENABLED (2 Bausteine):**
`FullSourceCatalog = CatalogAxes<2 x 18>` -> `catalog_axis_product` = 2^18 = **262144** (Voll-Bau verdoppelt, wie behauptet). Folgen: `static_assert(...==131072)` (`:156`) bricht -> muss auf 262144; `run_options cap` im golden-XML 131072 -> 262144; `test_limits_entkopplung_vorstufe.cpp:120-121,128` + `test_lazy_adhoc_source_gen.cpp:135,191,207` brechen. Anti-Materialisierungs-Guard **haelt** (262144 > 4096, `:187`), `golden_320_catalog` mit K17=1 bleibt 320 <= 4096 (`:189`).

**Fall B — `disk_writeback` enabled=false (1 Baustein):** die Behauptung "bleibt 2^17" gilt **nur mit Einschraenkung**, die belegt werden muss:
`mp_take_c<L, 2>` ist bei 1-elementiger Liste **ill-formed** — `cmake/third_party/boost_mp11/include/boost/mp11/algorithm.hpp:447` spezialisiert `mp_take_c_impl<2, L<T1,T2,T...>>` (braucht >= 2 Elemente); das Primaer-Template `:430` hat kein `::type` -> harter Compile-Fehler. `CatalogAxes` hat **keinen** `min()`-Schutz (anders als `axis_registry_gen/main.cpp:140-141` `kTake = min(GoldenK,kSize)`).
=> Bei `enabled=false` MUSS `FullSourceCatalog = CatalogAxes<2,...,2,**1**>` geschrieben werden; dann `catalog_axis_product` = 2^17 * 1 = **131072**, `static_assert(:156)` haelt, Voll-Bau-Kardinalitaet unveraendert. Ein uniformes `<2,...,2>` (18 Zweien) bricht bei `enabled=false` bereits im TU.

**Aber: der golden-CRC bricht in BEIDEN Faellen.** Begruendung: `catalog_static_levels<Catalog>()` (`:192-218`) pusht je Slot einen `AxisLevel` (`axis_reflect.hpp:38-42`, `is_static=true`); der `StaticBinaryView`/`serialize_composition_path`-Pfad joint ALLE statischen Level zu `"achse=wert"`-Segmenten. Ein 18. Level mit *einem* Wert aendert die Kardinalitaet nicht, haengt aber an JEDE der 131072 ids das Segment `/persistence_target=memory_only` -> `kNewGolden131072Crc64` (`:168`) ist nicht mehr reproduzierbar, und die 320 committeten ids (`tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt`, Kopfzeile "ABI-6 / Bau-INC-2d (17 Slots)") driften byte-weise. Genau das ist der in §5 des Session-Docs angekuendigte bewusste golden-/ABI-Bruch im §66-G2-Fenster.

## VOLLSTAENDIGE BRUCH-KETTE (Reihenfolge = Bauablauf)

1. **Achsen-Modul** neu: `axes/persistence_target/` (Skelett = `axes/mapping/`, Koerper = `NoMigration`/`in_memory_only`) + `topics/<topic>/` Andockung + `CMakeLists.txt` option/foreach/configure_file/message.
2. **kCompositionAxisNames 17 -> 18** (`axis_path_serialization.hpp:34-37`) + `serialize_composition_from_slots` `array<...,17>`->18 + 18. `::name()` (:72-77) + Kopf-Doku :10.
3. **AdHocComposition** 17 -> 18 Template-Params + usings (`composition_factory.hpp:60-79`) + **`static_assert(sizeof...(Vs)==17)` -> 18** (:98) + `IsComposition` 18. `typename` (`composition_concept.hpp:20-56`) + `composition_organ_count = 18` (:64) -> `organ_count()` ABI-Symbol aendert sich.
4. **GenusBindingTraits<SearchAlgorithm>** `slot_count 17->18` (:39) + `array<...,17>&`->18 (:49). Adapter/Set/Sequence/View (11/13/9/5) nur, falls die Achse geteilt wird — Entscheidung noetig.
5. **Anatomie + ABI-Adapter**: 18. Organ-Member + Accessor + `observe_all`-Zweig (`search_algorithm_anatomy.hpp`, Muster :98-102/:148-151/:197-198); `abi_adapter.hpp` 18. Organ-Member + `s.axis_stats[17]`-Schreiber + `acc[17]`->`acc[18]`/`acc[17] +=` Seg-Zweig (:671,:837,:1454,:1634) + Reset (:1674,:1971); `observer_aggregate.hpp:94-140` 18. Snapshot-Member + `total_slots() 17->18`.
6. **Observer-POD-Bruch**: `kV3AxisCount 17->18` (:49); `kV3AxisSchema` 18. Zeile (:68-100); POD `axis_stats[18][8]` + `seg_ns[18]`; **`sizeof` 1272 -> 1344** (18*8*8=1152 + 18*8=144 + 48) — `static_assert` :152-154 anfassen; `kTierObserverSnapshotVersionUnified 7 -> 8` (:158); `measurable_workload.hpp:99` + `experiment_tree.hpp:75` `seg_ns[18]`.
7. **ABI-Major 6 -> 7** (`anatomy_module_abi_v1_decl.hpp:54`) + Doku :35/:51; Loader lehnt Alt-DLLs per Major-Mismatch ab (gewollt). `kCebContractVersion` (:274) zieht mit.
8. **Mess-Zeilen-Kontrakt 160 -> 169**: `result_ingest.hpp:47` (`f.size() != 160`) + `:60-62` (`t < 17`) + Kommentar :39-42; `harness/perm_runner.hpp:49-50,83,114,324`. CSV-Header wachsen automatisch (`cache_engine_builder_iterator.hpp:300-330`, Single-Source-Arrays) — **alle bestehenden Mess-CSV werden lese-inkompatibel** (Messdaten NIE loeschen; Reader-Versionierung oder separater Lager-Zweig noetig).
9. **Katalog-Bruch** (`source_catalog.hpp`): `CatalogAxes` 18. `K17`-Param + `L17` (:91-112) + `CatalogCfg<L17>` in `Engine` (:114-118); `FullSourceCatalog` (:127) K17=2 (Fall A) bzw. 1 (Fall B); `golden_320_catalog` (:131) + `SmallSourceCatalog` (:135) K17=1; `catalog_axis_product` 18. Faktor (:141-152); `static_assert` 131072 -> 262144 (Fall A) bzw. bleibt (Fall B) (:156); `catalog_static_levels` 18. `push_static_axis` (:192-218); **`AxisSweepCatalogFull` L00..L16 -> L17 (:354-380) + ALLE 16 Sweep-Aliase je 18 Positions-Argumente (:411-452)** + optional neuer `PersistenceTargetSweepCatalog` + Dispatch (:460-480, :489+).
10. **golden-Neuanker**: `kNewGolden131072Crc64` (:168) neu ermitteln (`gen_golden_fullpilot --crc64`) + Konstanten-/Namens-Wahl bei 262144; `tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt` neu erzeugen (18-Slot-Kopfzeile). Anti-Materialisierungs-Guard `kMaxMaterializableCatalogCardinality = 4096` (:183) + Guard-des-Guards (:187-190) bleiben unangetastet gueltig.
11. **Emitter/Codegen**: `adhoc_emitter.hpp:52-77` 18. `add(...)`; `all_axes_umbrella.hpp:19-40` Include + Kopf-Doku :2/:7/:10; `lazy_adhoc_source_gen.hpp:112` `array<...,18>` + `:134-153` 18. Tabelle; `catalog_codegen_tool/main.cpp:113-171` `array<SlotSpec,18>`; `anatomy_version_stamp.hpp:42-62` `array<AxisVersionEntry,18>` + 18. Zeile; `anatomy_module_abi_v1.hpp:71-73` variadisch = neutral, aber Doku-Text 17 -> 18 (:69,:75-85,:95+).
12. **Registry + Gate**: `registry_to_axis_levels.hpp` Alias + `append_organ_core_axis_levels` + `all_axes_matrix_count`; `axis_registry_gen/main.cpp:207-224` neue `make_axis`-Zeile (Slot `T17`, GoldenK bewusst waehlen); **Registry-XML regenerieren** (17 -> 18 Achsen, 82 -> 84 Bausteine) sonst `test_axis_registry_roundtrip` (`tests/unit/CMakeLists.txt:3793-3803`) rot in `contract:profile_coverage`.
13. **Deklarative Profile**: `all_axes_golden.profile.xml` (18. `<axis ref>`, 18. `<axis_sweep>`, `active_axes` 18 Namen, `cap` 131072/262144) + `m3v2_study.profile.xml` (320-Basis, muss den 18. Slot pinnen) + Experiment-Fixtures `Code/test_data_xml/experiment_golden.xml` / `experiment_schema.xsd` `axes_default_lookup`.
14. **Durchreich-Nachzug**: 14 `compositions/*_reference.hpp` + 20 Test-Kompositionen (34 Dateien mit `using queuing_q2`).
15. **Klassifikations-/Legenden-Tabellen**: `axis_observer_classification.hpp:34,54`; `axis_operability_classification.hpp:34-52` (`array<...,17>` + Summen-Kommentar "2+4+11==17"); `plan_legend.hpp:44` `kOrganReferenceAxisCount=3` (unkritisch, `min()`-geschuetzt :112).
16. **Test-Erwartungen**: `test_limits_entkopplung_vorstufe.cpp:120-141` (Produkt, `static_levels == 17`, view.size, CRC); `test_lazy_adhoc_source_gen.cpp:135,190-207,409`; `test_profile_roundtrip.cpp` (320-Byte-Wache); `test_reflect_versions_all17.cpp`; `test_all19_segment_timer.cpp`; `test_smoke_coverage_profile.cpp`; `test_measurement_categories.cpp`; `test_axis_sweep_pilot.cpp`; `test_wdk_datasets_fairness.cpp`.
17. **Sortierungs-Konsequenz aus §1/§5**: `persistence_target` gehoert fachlich in Organ-Gruppe `05_write_path_io` NACH `io_dispatch`/`queuing`. Byte-minimal ist **Anhaengen als T17 hinter queuing_q2** (nur Suffix-Segment, alle 17 bestehenden Segment-Positionen bleiben) — ein Einschieben zwischen io_dispatch und migration_policy schneidet zusaetzlich die mixed-radix-Reihenfolge der StaticBinaryView neu (grosserer, unnoetiger Bruch). Empfehlung: T17-Anhang; die §1-Ordnung wird auf der **Lager-Baum-/Ordner-Ebene** (§4/§5) realisiert, nicht in der binary_id-Slot-Reihenfolge.

**Aritaets-Zusammenfassung:** 17 -> 18 Slots · POD sizeof 1272 -> 1344 · POD-Version 7 -> 8 · ABI-Major 6 -> 7 · CSV-Felder 160 -> 169 · Registry 17 Achsen/82 Bausteine -> 18/84 · Voll-Bau 131072 -> 262144 (Fall A) bzw. 131072 (Fall B) · golden-CRC64 in BEIDEN Faellen neu.

Selbstcheck: `grep -P '[^\x00-\x7F]'` auf diesem Bericht = 0 Treffer (nur `§` bewusst nicht verwendet ausser in Zitaten? — nein: `§` kommt vor und ist per Direktive erlaubt); keine Datei geaendert, kein Schreibzugriff, nur Read/Grep.