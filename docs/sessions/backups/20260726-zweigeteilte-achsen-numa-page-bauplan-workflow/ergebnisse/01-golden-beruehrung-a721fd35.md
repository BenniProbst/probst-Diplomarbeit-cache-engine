## (a) VERDIKT: binary_id-beruehrend?

**NUMA/locking: NEIN. page_type: NEIN.** Beide golden-neutral, CRC `0x56F1B721C72DC10E` bleibt.

Der binary_id ist ausschliesslich `kCompositionAxisNames` (18 Namen, `axis_path_serialization.hpp:40-43`): `search_algo, cache_traversal, mapping, path_compression, node_type, memory_layout, allocator, prefetch, concurrency, serialization, value_handle, index_organization, io_dispatch, migration_policy, filter, queuing_q1, queuing_q2, persistence_target`. Weder `page_type` noch NUMA/locking stehen darin.

**Praezedenz ist bindend und zweifach vollzogen** (`axis_path_serialization.hpp:26-31`): `telemetry` (Bau-INC-2c, ABI-5) und `isa` (Bau-INC-2d, ABI-6) haben die binary_id-permutierende Komposition **verlassen, GENAU als sie System-Achsen wurden** - obwohl das isa-ORGAN (`Amd64Isa/ObservableIsa`) als CT-statischer Codegen-Traeger im Tier-Binary bleibt. Das ist exakt der Zwei-Stufen-Fall des OWNER-KERNs: CT-statisch am Tier **und trotzdem** nicht in der binary_id, sondern im `+target=`-Sidecar. §54-T3 (`profile_run_entry.hpp:720`: "binary_id BLEIBT Organ-only") ist damit produktiv durchgesetzt, nicht bloss dokumentiert.

**page_type ist heute BEREITS System-Achse, nicht Komposition:**
- `registry_to_axis_levels.hpp:117-120` - `build_system_axis_levels()` pusht `push_static_axis<T17_page_type>(lv, "page_type")`; `:68-69` fuehrt es explizit als "build-only" neben `simd_extension`/`general_hardware`.
- `topic_nodes_config_set.hpp` hat **nur** `StaticAxisVariants_02` (path_compression) und `StaticAxisVariants_04` (node_type) und `CartesianCompression02xNodeType04`. **`StaticAxisVariants_01` FEHLT** - page_type ist nicht in die Komposition verdrahtet.
- `axis_observer_classification.hpp:79` - `{"page_type", AxisObserverKind::DefinitionOnly}`.
- `axis_variant_version_table.hpp:19` - "System-Achsen (telemetry/isa/page_type/simd_extension/general_hardware) bleiben AUSSEN: sie tragen KEINE algo_sig".

**NUMA ist heute nicht einmal eigene Achse**, sondern Definitions-FELD der System-Achse `general_hardware` (axis_12): `build_variant_definition.hpp:27` `std::uint64_t hw_numa_capable = 0;`, gefuellt via `:116` `HW::numa_capable()`. Es landet im dritten Sidecar `<output>.variant` (`build_variant_sidecar.hpp:3,32,55-56`), nicht in der binary_id.

**Der Guard, der das erzwingt:** `profile_to_tree.hpp:32-36` `is_organ_composition_axis()` prueft gegen `kCompositionAxisNames`; `:96` `if (!is_organ_composition_axis(ax.ref)) continue;`. Eine Anwender-XML darf `numa` oder `page_type` als Achse deklarieren - sie wird beim Bau der statischen Baum-Ebenen **uebersprungen** und kann keine binary_id-Segmente erzeugen. Die CEB-Freigabe (§37) ist also mechanisch von der Organ-Permutation getrennt.

## (b) page_type: System-Freigabe vs. Organ-Durchsetzung

**Ja, die Zweiteilung ist genau die von dir beschriebene** - und der Code realisiert sie schon:

- **System-Seite (Freigabe, CEB-Laufzeit):** `axis_01_page_type_flags.hpp.in` -> `T::enabled` -> `EnabledPageTypes = mp_filter<is_enabled, AllPageTypes>` (`axis_01_page_type_registry.hpp:24-28`). Die CEB entscheidet pro Architektur, **welche** Seitentypen ueberhaupt existieren. Das ist die dynamische Einstellung der Vorstufe.
- **Organ-Seite (Durchsetzung, Tier-CT):** die 6 Varianten sind echte Knoten-Seitenstrukturen - `DenseBytePageType` ("dense byte-indexed branch page, direct-addressed", `axis_01_page_type_dense_byte.hpp:28`), `BPlusPageType` ("sorted B+-style branch page, Masstree family", `axis_01_page_type_bplus.hpp:28`), `ExtendedDense`, `SparsePatricia`, `Redirect`, `CustomCache`. Das Tier-Binary traegt **eine** davon CT-statisch, ueber das Concept `axis_01_page_type_cache_engine_permutation_concept.hpp` durchgesetzt.

§24-C stufen-relativ ist damit erfuellt: RT-Unter-Achse unter der ISA an der CEB, CT-Haupt am Tier. Der Ausgang der Freigabe wird zum CT-Draht der Folgestufe. **Aber**: dass eine Achse am Tier CT-statisch und fachlich Organ-artig ist, macht sie nicht binary_id-tragend - `isa` ist derselbe Fall und ist bewusst herausgenommen. Der binary_id ist die Achse der **Permutation innerhalb einer Freigabe**, nicht der Freigabe selbst.

## (c) Golden-Neuanker?

**Nein - fuer keine der beiden Achsen.** Solange NUMA/locking und page_type als System-Achsen gefuehrt werden:

- `source_catalog.hpp:139` `FullSourceCatalog = CatalogAxes<2,...,2,1>` (17x2 x persistence_target 1) bleibt unveraendert; `:169-170` `static_assert(catalog_axis_product<FullSourceCatalog>() == 131072u)` haelt.
- `gen_golden_fullpilot/main.cpp:86-99` bildet die CRC64-ECMA-182 **ueber die binary_id-Strings** (`crc64_ecma182_update(crc, view[i].binary_id)` + `"\n"`). Da kein Segment hinzukommt, ist jeder String byte-identisch -> `kNewGolden131072Crc64 = 0x56F1B721C72DC10EULL` (`source_catalog.hpp:189`) bleibt gueltig.

**Neuanker waere NUR noetig, wenn eine der beiden in `kCompositionAxisNames` aufgenommen wuerde.** Dann waechst der Array auf 19/20, jede binary_id gewinnt ein Segment, `serialize_composition_from_slots` (`:80-85`, HANDARBEIT) und `CatalogAxes`-Slot-Zahl muessen mitwandern -> CRC bricht fuer **alle** 131072 ids. Das ist ein STRUKT-R-artiger Eingriff. **Empfehlung: nicht tun.** Beide Achsen sind System-Freigaben, kein Permutations-Radix. Falls page_type doch permutieren soll, ist der billige Weg der `with_shape_segment`-Anhang (`:100-106`, Default-OFF `Shape=void` -> Pfad byte-identisch zurueck) - additiv, ohne Alt-CRC-Bruch, weil das Segment nur bei aktivem Traeger emittiert wird.

## (d) Stempel-/POD-/ABI-Folgen

**AnatomyVersionLines waechst NICHT** - kein Layout-Bump, kein ABI-Major.

- `anatomy_module_abi_v1_decl.hpp:188-193`: `system_entries` ist ein `{AnatomyStampEntryV1 const*, uint64 count}`-**Paar**, Kommentar "System-Array [d,e,f] (5 Achsen) -- NIE mit Organ fusioniert". Ein 6. bzw. 7. System-Achsen-Eintrag (numa, ggf. locking) erhoeht nur `system_entry_count` und die Zeilen-**Inhalte**; die Feld-Offsets bleiben, `kAnatomyVersionLinesLayout = 5` (`:206`) bleibt. Das ist genau der Zweck der A4-Array-Form (Lager-Gate A4, Section 58-V/66).
- §57/§58 bleibt strukturell intakt: CEB=[a,b,c] unberuehrt; Tier=[d,e,f] (System) waechst inhaltlich, [g,h,i] (Organ, 17 Haupt-Achsen, `:189`) unberuehrt. **Kein Uebertritt zwischen den Arrays** - das waere die Layer-Doktrin-Verletzung.
- **Versions-Quelle**: System-Achsen tragen **kein** `algo_version` (`axis_variant_version_table.hpp:19-21`). NUMA/page_type brauchen also eine System-Sub-Achsen-Konstante nach dem Muster `kAllocHwSubaxisVersion` / `kCacheLineSubaxisVersion` (`axis_variant_version_table.hpp:29-31`), **nicht** den Organ-CRTP-Guard. Sonst bricht der `static_assert(requires { Derived::algo_version; })` falsch.
- **Einzige reale Kosten-Stelle: `build_version`.** Ein neuer Token in `system_axes_version_suffix()` (`profile_run_facade.cpp:371,378`) laesst jede `perm.dll.version` mismatchen -> `dll_is_current` sieht **alle** Tier-Binaries als neu -> Voll-Rebuild + Neu-Mess-Lauf (genau der bewusste Effekt, der bei `+opt=` dokumentiert ist, `:372-376`). **Mess-neutral bleibt es nur mit dem `+target=`-Muster** (`:389-391`): Token nur emittieren, wenn der Wert vom benannten Default abweicht. Bei Default-NUMA/Default-page_type -> Suffix byte-identisch -> Alt-Binaries bleiben gueltig, Alt-Mess-Reihen anschlussfaehig.
- `.variant`-Sidecar (`build_variant_sidecar.hpp:38-56`) hat feste Feld-Reihenfolge; `hw_numa_capable` existiert dort schon. Eine NUMA-**Politik** (mehr als 0/1) braucht ein neues Feld -> `BuildVariantDefinitionV1`-POD waechst + `kBuildVariantDefinitionVersion`-Bump + `parse_variant_signature` (`:65,92`) erweitern. Das ist ein **Sidecar**-Bruch, kein binary_id-Bruch: golden bleibt trotzdem unberuehrt.

**Selbstcheck: ASCII-only, keine Nicht-ASCII-Zeichen ausser dem erlaubten §.**
