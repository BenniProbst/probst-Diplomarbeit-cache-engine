SESSION-DOC GELESEN (docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md, 119 Zeilen, komplett). NICHTS geaendert (read-only Kartierung).

PFAD-LEGENDE: `CE` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine`

# 1. TYPEN-KARTE der System-Achsen-Welt (Ist-Stand)

## 1.1 Dach + Wurzeln
| Naht | datei:zeile | Rolle |
|---|---|---|
| `topics::AxisKind` | `CE/libs/cache_engine/topics/axis.hpp:17-21` | NUR 3 Werte: `organ`, `system_measurement`, `system_config`. **Kein `meta_meta`** -> R-C/R-E haben heute KEINEN Diskriminator. |
| `topics::Axis<Derived>` | `topics/axis.hpp:26-30` | Layer-Supertype, empty, CRTP |
| `AxisConcept` | `topics/axis.hpp:32-36` | `is_empty && !is_polymorphic` (Anti-vtable) |
| `CebSystemAxis<Derived>` | `CE/libs/cache_engine/include/cache_engine/measurement/ceb_system_axis.hpp:20-30` | Konfig-System-Wurzel; `axis_kind()=system_config` (:22), `axis_label()` -> `Derived::do_axis_label()` (:26) |
| `CebSystemAxisConcept` | `ceb_system_axis.hpp:32-37` | verlangt NUR `do_axis_label()`. **Kein `parent_axis_label`, keine Haupt/Unter-Unterscheidung im Concept.** |
| `SystemAxis<Derived>` (Mess-Blut) | `measurement/system_axis.hpp:148-184` | disjunkte Geschwister-Wurzel (`system_measurement`), nicht Teil der 5er-Menge |

## 1.2 Die 5 CebSystemAxis-HAUPT-Achsen (alle in `CE/libs/cache_engine/include/cache_engine/measurement/`)
| # | Label | Typ-Datei:zeile | Auspraegungen | Ziel laut KERN |
|---|---|---|---|---|
| 1 | `compiler` | `compiler_system_axis.hpp:22` (CRTP), `:23` (Label), `:47` Gcc, `:53` Clang | `driver_default()`, `supports_fno_gnu_unique()` | **R-D: -> Unter-Achsen-GRUPPE** |
| 2 | `extension_hardware` | `extension_hardware_family_axis.hpp:40` (CRTP), `:41` (Label), `:44` `family_id()`, `:49` `sub_axis_label()==family_id()`, `:66` `SimdExtensionHardwareFamily`, `:74` `kAllExtensionHardwareFamilyIds` (Groesse 1) | Familie `simd` (spaeter gpu) | **R-E: -> Command-Pattern-HUB** |
| 3 | `target_isa` | `target_isa_system_axis.hpp:33` (CRTP), `:34` (Label), `:64` X86_64, `:73` Aarch64, `:85` `kAllTargetIsaIds` | `is_native/target_triple/target_march` | **R-B-Ziel: nimmt `scheduling` als Unter-Achse auf; R-D: Teil der Komplex-Haupt-Achse** |
| 4 | `scheduling` | `scheduling_system_axis.hpp:23` (CRTP), `:24` (Label), `:60` `DefaultSchedulingSystemAxis` | 5 getypte Sub-Dims aus `concepts/scheduling_strategy.hpp`, **ohne id-Strings** | **R-B: -> Unter-Achse von target_isa** |
| 5 | `load_framework` | `load_framework_system_axis.hpp:21` (CRTP), `:22` (Label), `:29` `sub_axis_label()=="workload"` (hartkodiert!), `:44` Ycsb | Framework-Wahl | **R-C: -> 1. Meta-Meta** |

Zwei NICHT-Teilnehmer (bewusst ausgeschlossen, `tools/system_axis_registry_gen/main.cpp:21-23`):
- `extension_hardware_system_axis.hpp:36-83` = DEPRECATED-Insel (flaches Alt-Modell, nur `test_striktheit_axis_dach_guard` Block F haelt sie kompilierbar; NICHT loeschen)
- `hardware_isa_system_axis.hpp:20-40` = HOST-Deskriptor Label `"hardware"` (`Amd64HostIsaAxis:38`), treibt NICHT den Bau

## 1.3 Unter-Achsen-Modellierung (das EINE Muster)
Unter-Achsen erben ebenfalls `CebSystemAxis` (also selbst `system_config`!) und tragen ZWEI Labels:
- `do_axis_label()` = eigenes Label, `parent_axis_label()` = String-Kopplung zum Elternteil.

| Unter-Achse | Datei:zeile Label / parent | parent |
|---|---|---|
| `opt_level` | `optimization_level_sub_axis.hpp:37` / `:41` | `"compiler"` |
| `atomic128` | `compiler_atomic_sub_axis.hpp:38` / `:42` | `"compiler"` |
| `simd` | `simd_sub_axis.hpp:34` / `:38` | `"extension_hardware"` |
| `workload` | KEINE eigene Klasse — nur String in `load_framework_system_axis.hpp:29` | `load_framework` |
| `scheduling_dims` | KEINE Klasse — nur Generator-Literal `main.cpp:265` | `scheduling` |

Anker-static_asserts, die die Struktur compile-time PINNEN:
`optimization_level_sub_axis.hpp:145`, `compiler_atomic_sub_axis.hpp:97-98`, `simd_sub_axis.hpp:103-104`, `extension_hardware_family_axis.hpp:84-93` (GN-1-Aufloesung `SimdNoExtOption::parent_axis_label()==SimdExtensionHardwareFamily::axis_label()`).

**RISS 1 (fundamental): Es gibt KEINE `CebSubAxis`-Wurzel.** Haupt/Unter unterscheidet sich ausschliesslich durch die Anwesenheit eines `parent_axis_label()`-Members — ein reiner Konventions-String, nicht typisiert. R-B/R-D sind daher NICHT als Typ-Umhaengung ausdruckbar, sondern nur als String-Aenderung + Generator-Umbau. Fuer R-B/R-D/R-C/R-E braucht es zuerst eine echte Schicht-Taxonomie (`CebSubAxis<Derived, Parent>` mit `parent_axis()`-TYP statt String, plus `AxisKind::system_meta_meta`).

# 2. Generator (die XML ist GENERIERT)

`CE/tools/system_axis_registry_gen/main.cpp` (338 Z.), Build: `CE/tools/system_axis_registry_gen/CMakeLists.txt:10`.
Ausgabe: `CE/libs/cache_engine/include/cache_engine/measurement/system_axis_registry.xml` (`<axis id=` in Z. 10 compiler, 53 extension_hardware, 98 target_isa, 102 scheduling, 114 load_framework).

Die 5 Emissions-Bloecke sind HANDGESCHRIEBEN SEQUENTIELL (keine Achsen-Liste, kein variadisches Array):
- `main.cpp:164-213` compiler (+ sub_axis opt_level `:178-203`, sub_axis atomic128 `:205-212`)
- `main.cpp:215-242` extension_hardware (+ sub_axis simd `:222-231`, `simd_feature_catalog` `:235-241`)
- `main.cpp:244-256` target_isa
- `main.cpp:258-282` scheduling (+ `sub_axis id="scheduling_dims"` `:265`, 5 `sub_dim`-Literale `:270-279`)
- `main.cpp:284-296` load_framework
- `main.cpp:298-316` `machine_signatures` (3 fest aufgezaehlte Signatur-Typen `:312-314`)
- `main.cpp:334` stdout-Literal `"5 System-Achsen-Elemente"`

Helfer: `emit_axis_open` `:124-128` (schreibt `stage=` als Aufrufer-Parameter), `emit_baustein` `:104-111`, `emit_option` `:114-122`, Namens-GUARD `:91-93`/`:323-328`.

**RISS 2:** Der Generator hat KEINE Vorstellung von Achsen-ORDNUNG als Datum — die Ordnung ist die Quelltext-Reihenfolge der Bloecke. Die bindende Sortierung (Tooling->target_isa->operating_system->extension_hardware) existiert nirgends als Single-Source-Tabelle. `stage="ct"|"runtime"` ist die EINZIGE Schicht-Information in der XML; ein 3. Level (Meta-Meta) hat kein Vokabular.

**RISS 3 (Byte-Wache):** `CE/tests/unit/registry_roundtrip.cmake:55-66` erzwingt Byte-Diff==0 zwischen committeter XML und Generator-Reflexion; verdrahtet in `CE/tests/unit/CMakeLists.txt:3822-3831` (`test_system_axis_registry_roundtrip`). Jede Typ-Aenderung MUSS im selben Commit die XML mit-regenerieren, sonst rot.

# 3. Konsumenten der 5er-System-Menge (vollstaendig)

## 3.1 RegistryTrio 17/5/16
`CE/libs/cache_engine/profile_facade/validate_profile.hpp`
- `:691-709` `struct RegistryTrio`; `:698` `system_axis_count()`; Kommentar `:696` "Organ-golden = 17, System = 5"
- `:715-723` `read_axis_registry_trio(organ, system, measurement)`
- `:706-708` `measurement_category_count()` (die 16)
- `:748-799` `resolve_axis_refs_against_trio` — klassifiziert `V-CATEGORY` wenn eine System-Achse in Organ-Position steht (`:781-789`). **Riss:** Diese Klassifikation prueft NUR `trio.system.axis_names` flach; eine Achse, die nach R-B/R-D zur UNTER-Achse wird, verschwindet je nach Generator-Umbau aus `axis_names` -> die Route-Meldung kippt still auf `V-UNREG-AXIS` (harter Reject) fuer bestehende Profile, die `scheduling`/`compiler` nennen.
- Registry-Pfade als CMake-Defines: `CE/libs/cache_engine/profile_facade/CMakeLists.txt:137`, `CE/tests/unit/CMakeLists.txt:2816` und `:2880`; Nutzung `CE/libs/cache_engine/profile_facade/profile_run_facade.cpp:688-690`

## 3.2 Wert-Validat gegen die Achsen-Klassen (ZWEI Kanaele, dupliziert)
`validate_profile.hpp:373-448` (Thesis-Kanal): opt_level `:387-405` (Ofast-Reject `:396`), simd `:406-415`, atomic128 `:416-433` (+ `static_assert parent_axis_label()=="compiler"` `:421-422`), target_isa `:434-447`.
`validate_profile.hpp:929-993` (Experiment-Kanal): opt_level `:935-944`, simd `:948-961` (+ `static_assert` GN-1 `:948-949`), atomic128 `:962-978` (+ `static_assert` `:971-972`), target_isa `:979-993`.
Zaehler-Felder: `:101-104` (Thesis-Report) und `:624-627` (Experiment-Report).

**RISS 4:** `scheduling` und `load_framework` werden in KEINEM der beiden Kanaele validiert (kein XML-Wert-Raum). R-B/R-C haben deshalb keinen Validat-Ort — er muss neu geschaffen werden. Umgekehrt sind opt_level/atomic128/simd/target_isa DOPPELT validiert -> jede Umhaengung muss an 2 Stellen + 4 static_asserts nachgezogen werden.

## 3.3 `build_system_axis_levels` — ACHTUNG: eine ZWEITE, DISJUNKTE 5er-Menge
`CE/libs/cache_engine/builder/experiment_tree/registry_to_axis_levels.hpp:113-122`:
```
lv.reserve(5);
push_static_axis<axes26::T17_page_type>(lv, "page_type");
push_static_axis<axes26::T18_simd_extension>(lv, "simd_extension");
push_static_axis<axes26::T19_general_hardware>(lv, "general_hardware");
push_static_axis<axes26::T10_telemetry>(lv, "telemetry");
push_static_axis<axes26::T12_isa>(lv, "isa");
```
Das sind **Organ-Registry-Achsen in System-Rolle** (`page_type/simd_extension/general_hardware/telemetry/isa`) — NICHT die 5 CebSystemAxis. Konsument: `profile_run_facade.cpp:391-394` (Telemetry-Token-Gate `+tel=silent`). Aufruf aus `build_all_axis_levels()` `:137-144` (26 Achsen).

**RISS 5 (schwerster begrifflicher Riss):** Zwei verschiedene Mengen tragen beide den Namen "System-Achsen, 5 Stueck": (a) `RegistryTrio.system` = {compiler, extension_hardware, target_isa, scheduling, load_framework}; (b) `build_system_axis_levels()` = {page_type, simd_extension, general_hardware, telemetry, isa}. Die Zufalls-Koinzidenz "beide 5" verschleiert die Trennung. R-A (`operating_system` NEU) muss explizit in (a) landen, und die Session-Sortierung §1 spricht ueber (a). `telemetry` in (b) ist ausserdem eine System-Achse OHNE CebSystemAxis-Typ — ein weiterer Kandidaten-Riss, den die Neuordnung mitentscheiden muss.

## 3.4 `system_axes_version_suffix` (build_version / Bestandslog-Identitaet)
`CE/libs/cache_engine/profile_facade/profile_run_facade.cpp:364-400`. Feste Token-Reihenfolge:
`+ext=<simd>` (`:371`) `+cxx=<compiler>` (`:371`) `+opt=<level>` (`:372-373`) `+ceb=<major>.<minor>` (`:378-379`) `[+target=<isa>` nur wenn != x86_64, `:382-384]` `[+tel=silent`, `:390-395]` `[+bt=Debug`, `:398]`.
Aufloeser TU-lokal: `active_simd_policy:168`, `active_target_isa:199`, `perm_target_isa_cflags:205-215`, `active_telemetry_is_silent:230`, `active_opt_level:321-349`, `facade_build_type_is_debug:357`. Einbau in CompileFn: `:295` (Cross-Flags), `:488`/`:535`/`:873`/`:885` (`make_gpp_compile_fn`).
Zweit-Konsument der GLEICHEN Ordnung: `CE/libs/cache_engine/builder/artifact_transport/artifact_cache.hpp:216-220` `cache_key_prefix` (+`+mtool=`+`+mrg=none`); Kommentar `:206` nennt die Single-Source-Kopplung explizit. Warnung `profile_run_facade.cpp:938` dokumentiert bereits, dass eine ANDERE Reihenfolge (`+ext+cxx+opt`) existiert -> Ordnungs-Drift ist bereits Ist.
Stempel-Block: `CE/libs/cache_engine/profile_facade/g1_binary_version_stamp.hpp:11,39`; Render `profile_run_facade.cpp:961-965`.

**RISS 6:** Die bindende Sortierung aus §1 ist mit der Suffix-Ordnung `+ext+cxx+opt+ceb+target` INKOMPATIBEL (target_isa muss vor extension_hardware, os dazwischen). Jede Umsortierung invalidiert JEDEN `.version`-Sidecar und JEDEN minio-Key (`cache_key_prefix`) -> W-13-Suffix-Ordnung und STRUKT-R muessen im SELBEN Bruch-Fenster laufen (Session §7 sagt das bereits).

## 3.5 `parse_system_axes` (die EINE geteilte Parse-Naht)
`CE/libs/common/serialization/xml_config_parser/xml_config_parser.cpp:98-116` — Signatur:
```
void parse_system_axes(XmlNode const& sa, CompilerAxisSel&, ExtensionHardwareAxisSel&, TargetIsaAxisSel&)
```
Zweige: `compiler/opt_level/option` `:101-102`, `compiler/atomic128/option` `:104-105`, `extension_hardware/simd/option` `:107-111`, `target_isa/option` (direkt, KEIN Zwischen-Container) `:114-116`.
Aufrufe: `:386-387` (Thesis-Kanal), `:516-517` (Experiment-Kanal).
PODs: `xml_config_parser.hpp:204-212` `CompilerAxisSel{opt_levels, atomic128}`, `:213-216` `ExtensionHardwareAxisSel{simd_options}`, `:220-224` `TargetIsaAxisSel{isa}`; Felder in `ThesisProfile` `:285-292`, in `ExperimentProfile` `:425-428`.
XSD-Pin: `CE/Code/test_data_xml/experiment_schema.xsd:43` (`SystemAxesType`), `:245-340` (compiler/opt_level `:258`, atomic128 `:282`, extension_hardware/simd `:306`, target_isa direkt `:332`).

**RISS 7:** Die 3-Parameter-Signatur ist die eigentliche Struktur-Zementierung. `scheduling`/`load_framework`/`operating_system` haben keinen POD, keinen Parse-Zweig und keinen XSD-Typ. R-A/R-B/R-C brauchen: neuen POD `OperatingSystemAxisSel{os_version, kernel, build, update_zustand}`, Umhaengung von `atomic128`+`opt_level`+`compiler` in EINEN Gruppen-POD, `scheduling` in `TargetIsaAxisSel`, `load_framework` in eine Meta-Meta-Sektion — plus XSD-Nachzug (sonst schlaegt xmllint-Validat).

## 3.6 `plan_legend` + Director-Emission
`CE/libs/cache_engine/profile_facade/planner/plan_legend.hpp:102-105`:
```
[[nodiscard]] inline std::string system_perm(std::string const& opt_id, std::string const& simd_id) {
    return axis_array({opt_id, simd_id});
}
```
-> `[d,e,f]` besteht heute aus GENAU 2 Tokens (opt x simd), obwohl §42.b "nur HAUPT-Achsen" verlangt: **opt_level ist eine UNTER-Achse und steht faelschlich in der Haupt-Legende, target_isa/scheduling/load_framework fehlen darin.**
Mess-Haupt-Achse: `plan_legend.hpp:90-92` `measurement_tooling_combo` gegen `cm::kMeasurementToolingCount` (=3, `measurement_tooling_registry.hpp:32`); Mess-Unter `:98-100` gegen `kMeasurementAxisCount` (=16).
Organ-Referenz `:110-115` (`ex::kCompositionAxisNames`, `axis_path_serialization.hpp:34`, Groesse 17).

`CE/libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp` (1813 Z.):
- `PlanPerm` `:139-151` — Felder `opt_id`, `simd_id`, `opt_flag`, `march_flag`, `build_version_suffix`, `host_supports_simd`. **Nur 2 Achsen-Dimensionen.**
- Plan-Kopf-Render `:196-207` (`system_axes=<count>` `:203`), Perm-Zeile `:222`
- Walk: `walk_perms_` `:1768-1800` (`perm_count = opt_perms.size()*simd_perms.size()` `:1775`; Suffix-Montage `:1796`); Ableitungen `opt_perms_of` `:1686-1689`, `simd_perms_of` `:1690-1693`
- Kanal-Eintritte `:1560-1590` (Thesis), `:1602-1630` (Experiment)
- Runner-/Lane-Routing: `simd_runner_tag` `:353-357`, `simd_runner_tags` `:369-392`, `measure_host_lane` `:396-405`
- YAML/Make-Emission mit `COMDARE_GN_OPT`/`COMDARE_GN_SIMD`: `:1003-1040`, `:1148-1190`, `:1427-1509`
- Legenden-Aufrufe `system_perm(p.opt_id, p.simd_id)`: `:841`, `:1003`, `:1148`, `:1218`, `:1362`, `:1428`, `:1478`

**RISS 8:** Die gesamte Planer-Emission ist auf ein 2-dimensionales `opt x simd`-Kreuzprodukt fest verdrahtet (Env-Variablen `COMDARE_GN_OPT`/`COMDARE_GN_SIMD` in 3 Emitter-Backends). Nach R-D wird `opt_level` Teil einer Gruppe UNTER der Komplex-Haupt-Achse, und die Haupt-Legende muss target_isa x os x ext_hw x MetaMetas tragen. Das ist der breiteste einzelne Umbau (ca. 20 Fundstellen), und er beruehrt die generierte CI-YAML -> Pipeline-Vertrag.

## 3.7 Der ABI-/Stempel-Anker (harte 5)
`CE/libs/cache_engine/include/cache_engine/abi/system_axis_code_versions.hpp`:
- `:28` `inline constexpr std::size_t kSystemAxisCodeCount = 5;`
- `:32-38` Tabelle in kanonischer Stempel-Ordnung: `compiler, extension_hardware, target_isa, scheduling, load_framework`
- `:49-50` `static_assert` Vollstaendigkeit
Render: `CE/libs/cache_engine/include/cache_engine/abi/anatomy_version_stamp.hpp:64-79` (`system_stamp_line()`, iteriert die Tabelle).
Konsumenten des Stempels: `profile_facade/lazy_adhoc_source_gen.hpp:199-201, 259`, `builder/codegen/adhoc_emitter.hpp:94`, `builder/experiment_tree/pilot_source_map.hpp:52-56`.

**RISS 9 (Byte-/CRC-Wache):** Der System-Stempel geht in den GENERIERTEN AdHoc-Quelltext ein (`lazy_adhoc_source_gen`) und ist damit byte-relevant fuer jede Tier-Binary. Sowohl die Umsortierung (R-A..R-D) als auch das Hinzufuegen von `operating_system` (5->6 bzw. 5->3+MetaMetas) bricht `system_stamp_line()` byte-weise -> golden-Bruch. Gehoert exakt in das offene §66-G2-Bruch-Fenster, gemeinsam mit `persistence_target` (binary_id 17->18).

## 3.8 Weitere Beruehrungen
- `CE/libs/cache_engine/profile_facade/profile_run_entry.hpp:175-201` `system_axis_opt_flag_of` / `system_axis_march_of` / `system_axis_host_supports_simd`; Perm-Walk `:697-760`
- `CE/libs/cache_engine/profile_facade/planner/planner_version.hpp`, `experiment_run_entry.hpp`, `profile_run_entry.hpp:430, 694`
- Profil-XMLs mit `<system_axes>`: `CE/libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml`, `cacheline_study.profile.xml`, `CE/tests/unit/thesis_tiere/experiment_golden.xml`, `experiment_golden_kern.xml`

## 3.9 Tests, die die Struktur PINNEN
| Test | Zeilen | Pin |
|---|---|---|
| `CE/tests/unit/test_striktheit_axis_dach_guard.cpp` | `:70` scheduling-Label, `:87` ext_hw (DEPRECATED-Insel), `:88` hardware, `:102-103` simd+parent, `:117,120` load_framework+`workload`, `:125` compiler, `:138-139` opt_level+parent, `:153-154` atomic128+parent, `:166,171` target_isa | ALLE Labels + ALLE parent-Strings |
| `CE/tests/unit/thesis_tiere/test_validate_profile.cpp` | `:289` `system_axis_count()==5u`, `:292` target_isa vorhanden | 5er-Zahl |
| `CE/tests/unit/thesis_tiere/test_experiment_plan_director.cpp` | `:112-113` `==5u` mit Kommentar der 5 Namen, `:120-122` compiler/ext_hw/target_isa vorhanden, `:124` `numa==0`, `:308` `==5u` | 5er-Zahl + Namen |
| `CE/tests/unit/test_m_w12_stamp_bausteine.cpp` | `:105-109` Stempel enthaelt `;load_framework=code@1.0.0`, `:261` `kSystemAxisCodeCount==5`, `:267-269` VOLLE Stempel-Zeile literal, `:338` Stempel-Literal "// 5" | exakte Stempel-BYTES + Ordnung |
| `CE/tests/unit/registry_roundtrip.cmake` (via `CMakeLists.txt:3822-3831`) | Byte-Diff==0 | XML == Reflexion |
| weitere Beruehrer | `test_kf1_thesis_profile_parser.cpp`, `thesis_tiere/test_experiment_parser.cpp`, `test_smoke_coverage_profile.cpp`, `test_genus_organ_binding.cpp` | Parser-/Profil-Struktur |

# 4. Bruch-Analyse R-B (scheduling -> Unter von target_isa) und R-D (compiler -> Unter-Gruppe)

**R-B bricht:**
1. `system_axis_code_versions.hpp:32-38` (Tabelle/Ordnung) + `:28` (Count) -> `system_stamp_line()` Bytes -> `test_m_w12_stamp_bausteine.cpp:267-269, 338`
2. Generator-Block `main.cpp:258-282` muss von `<axis id="scheduling">` zu `<sub_axis id="scheduling" parent="target_isa">` unter dem target_isa-Block `:244-256` wandern; `stdout`-Literal `:334`; danach XML neu -> `registry_roundtrip`
3. `RegistryTrio.system_axis_count()` 5 -> 4 (bzw. je nach R-A/R-C/R-D-Endzustand 3) -> `test_validate_profile.cpp:289`, `test_experiment_plan_director.cpp:112, 308`
4. `SchedulingSystemAxis` braucht ein `parent_axis_label()=="target_isa"` -> `test_striktheit_axis_dach_guard.cpp:70` erweitern
5. Fachlich sauber nur mit Typ-Wurzel: die 5 getypten Sub-Dims (`scheduling_system_axis.hpp:26-40`) haben keine id-Strings -> als Unter-Achse braucht `scheduling` entweder eine Options-Familie (wie `SimdSubAxis`) oder bleibt `kind="fixed_enum_tuple"`; Generator `main.cpp:265-280` haengt das an Literale.
6. `resolve_axis_refs_against_trio` `validate_profile.hpp:778-789`: `scheduling` verschwindet aus `trio.system.axis_names` -> `V-CATEGORY` kippt zu `V-UNREG-AXIS`. Der Resolver muss Unter-Achsen-Namen mit-aufloesen.

**R-D bricht zusaetzlich:**
1. `compiler` verliert `<axis>`-Status -> Generator `main.cpp:164-176` (2 Bausteine gcc/clang) muss zu Optionen einer Unter-Achse werden; `opt_level`/`atomic128` `parent_axis_label()` (`optimization_level_sub_axis.hpp:41`, `compiler_atomic_sub_axis.hpp:42`) zeigen dann auf ein Label, das kein `<axis>` mehr ist -> genau die GN-1-Verwaisung, die `extension_hardware_family_axis.hpp:1-22` schon einmal reparieren musste. Die 4 static_asserts `validate_profile.hpp:421-422, 971-972`, `compiler_atomic_sub_axis.hpp:98`, `optimization_level_sub_axis.hpp:145` brechen oder werden zu Phantom-Ankern.
2. Die Komplex-Haupt-Achse braucht ein LABEL (heute existiert keins). Alle `parent="..."`-Strings der Gruppe zeigen darauf.
3. `plan_legend.hpp:103` `system_perm(opt_id, simd_id)` ist dann semantisch falsch (opt = Unter). Alle 7 Aufrufstellen im Director.
4. `system_axes_version_suffix` `profile_run_facade.cpp:371-373` `+ext+cxx+opt` — `+cxx=` kommt aus `cxx_compiler()` (Host-Env), nicht aus der Achse; nach R-D muss der Compiler aus der Gruppen-Wahl kommen. `artifact_cache.hpp:216` mit.
5. XSD `experiment_schema.xsd:250-305` (`compiler` als Kind von `SystemAxesType`) -> Schema-Bruch fuer alle 4 `<system_axes>`-Profil-XMLs.

**R-C bricht:** `load_framework` verliert `<axis>` (Generator `main.cpp:284-296`); der hartkodierte `sub_axis_label()=="workload"` (`load_framework_system_axis.hpp:29`) ist die Single-Source der Zwei-Phasen-Gueltigkeit `cache_engine_builder_iterator.hpp:789-793` -> darf NICHT mitwandern. Der 5. Modus CUSTOM_COMPILE braucht `run_methodology_registry.hpp:27-34` (`kRunMethodologyCount = 3`!) + `:60-66` Registry + `:77-104` sechs static_asserts (Index==Enum, cmake_build_type, measurement_on, single_thread) + alle `for i < kRunMethodologyCount`-Schleifen `:68-72, 124-125, 133-134`. **Riss: die Registry hat 3 Eintraege, die Session spricht von einem 5. Modus -> COMPARE (§62) fehlt dort offenbar ebenfalls.** Vor R-C ist zu klaeren, ob COMPARE bereits ein 4. Eintrag werden soll (nicht im Code gefunden).

# 5. Natuerlicher Ort fuer Komplex-Haupt-Achse (Command-Pattern) und ext_hw-HUB

Empfohlene Verortung, alle im selben Verzeichnis wie die Achsen-Typen (`CE/libs/cache_engine/include/cache_engine/measurement/`), damit `system_axis_registry_gen` sie per Reflexion greift ohne neue Include-Pfade:

1. **Schicht-Wurzeln (neu, Voraussetzung fuer alles):** `ceb_sub_axis.hpp` + Erweiterung `ceb_system_axis.hpp:32-37` — `CebSubAxis<Derived, ParentAxis>` mit `parent_axis()` als TYP (`static_assert(CebSystemAxisConcept<ParentAxis>)`), `parent_axis_label()` nur noch als abgeleiteter Convenience-Wert. Damit werden R-B/R-D typgeprueft statt string-geprueft, und `AxisKind` (`topics/axis.hpp:17-21`) bekommt `system_meta_meta`.
2. **Komplex-Haupt-Achse (R-D):** neu `ceb_complex_system_axis.hpp` — Command-Pattern nach dem VORBILD, das im Repo bereits benannt ist: `CE/libs/cache_engine/builder/commands/axis_library_registry.hpp` (Command-Achsen-Registry). Form: `template <class TargetIsa, class ExtHw, class... MetaMetas> struct CompoundSystemAxis` mit `axis_label()` (ein NEUER Name, z.B. `"build_target_complex"`), das `do_axis_label()` der 3 Teile weiter exponiert (Session §2 R-D: "alle 3 sind Haupt-Achsen, verhalten sich aber wie EINE"). Die Unter-Achsen-Gruppe `compiler+opt_level+atomic128` als `template <class... SubAxes> struct SubAxisGroup` mit `group_label()`.
3. **ext_hw-HUB (R-E):** Erweiterung von `extension_hardware_family_axis.hpp` (schon der aktive Familien-Knoten, `:40-53`). Variadisches Meta-Meta-Array OHNE `std::variant`: das exakte Vorbild liegt in `machine_simd_signature.hpp:30-47` (CRTP + `std::span<X const>` ueber `static constexpr std::array` in einer `do_*()`-Funktion, `:79-87`) — dieselbe Technik traegt `std::span<MetaMetaDescriptor const> meta_metas()`. Die Aufwaerts-Halbordnung (R-E: GPU einbauen -> CPU-only laeuft weiter) gehoert als `constexpr bool subsumes(A, B)` neben das bestehende Gate-Vorbild `simd_build_gate.hpp:40-47` (`SimdGateState` als GoF-State-Pattern OHNE vtable, `route_allows` `:62-70`, `route_of_simd_id` `:73-77`). `simd_organ_sensibility.hpp` / `simd_organ_requirement.hpp` sind die vorhandenen Freigabe/Durchsetzungs-Nachbarn.
4. **Ordnungs-Single-Source (fehlt heute komplett):** eine `constexpr`-Tabelle `kSystemAxisOrder` neben `abi/system_axis_code_versions.hpp:32` — die bindende Sortierung §1 als DATUM, ueber das Generator, `system_axes_version_suffix`, `plan_legend::system_perm` und die Lager-Baum-Ordner-Kaskade GEMEINSAM iterieren. Ohne sie bleibt die Ordnung an 4 Orten dupliziert (Riss 2 + Riss 6).

# 6. R-A: Naht fuer Host-/OS-Erhebung — Befund

**Es gibt heute KEINE Erhebungs-Naht in der Engine.** Live-Verifikation:

- `gethostname`/`uname`/`utsname`/`/etc/os-release`/`/proc/version` kommen in `CE/libs`, `CE/apps`, `CE/tools` **nirgends** vor (grep leer; einzige `kernel`-Treffer sind Sachbegriffe wie `attr.exclude_kernel` in `CE/libs/cache_engine/builder/linux_perf_pmc_source.hpp:97` und NUMA-`kernel-Default`-Kommentare).
- Hostname wird ausschliesslich **generiert als Shell-Text** in die CI: `CE/libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:1142` -> `"@$(hostname)"` (platform-Tag, CSV-Provenienz).
- Der einzige DEKLARATIVE Maschinen-Kanal: `CE/libs/common/serialization/xml_config_parser/xml_config_parser.hpp:338-350` `<machines><machine id cpu_fabrication ram_pair hostname_hint/>` (Feld `hostname_hint` `:348`, ausdruecklich "NUR ein Hinweis, NICHT Schluessel"); Parse `xml_config_parser.cpp:505-513`; Validat `CE/libs/cache_engine/profile_facade/validate_profile.hpp:1045-1060` (prueft den SCHLUESSEL, nicht den Namen).
- Das einzige VORBILD fuer per-Maschine-Eigenschaften ist rein CT-DEKLARATIV, nicht erhoben: `CE/libs/cache_engine/include/cache_engine/measurement/machine_simd_signature.hpp:30-47` (CRTP-Basis) + `:77-87` `Prod1Zen5Signature`, `Prod2RaptorLakeSignature`, `OdroidGracemontSignature`; Reflexion in den Generator `tools/system_axis_registry_gen/main.cpp:298-316`. Quelle der Werte war ein LIVE-Abgleich, der von Hand in Code gegossen wurde (Kommentar `machine_simd_signature.hpp:5-8`, Referenzdoc `docs/architektur/20260719-simd-flag-signaturen-REFERENZ.md`).
- Der Host-DESKRIPTOR-Platz existiert bereits: `hardware_isa_system_axis.hpp:20-40`, Label `"hardware"`, mit `Amd64HostIsaAxis:38-40`. Er ist explizit NICHT bau-treibend und daher aus dem Generator ausgeschlossen (`main.cpp:22-23`).

**Empfehlung R-A (Naht-Vorschlag, nicht ausgefuehrt):** `operating_system` folgt dem `machine_simd_signature`-Muster exakt: eine CT-deklarative `OperatingSystemSystemAxis`-CRTP-Wurzel (`operating_system_system_axis.hpp`) mit Auspraegungen je real gemessener Maschine, deren Unter-Achsen `os_version/kernel/build/update_zustand` als `CebSubAxis`-Familien haengen (Vorbild `optimization_level_sub_axis.hpp`). Die ERHEBUNG (uname/os-release) gehoert NICHT in die Engine-Bibliothek, sondern — analog `$(hostname)` `experiment_plan_director.hpp:1142` — in die generierte Mess-Emission als Provenienz-Stempel, plus als deklarativer `<machine os_version= kernel= build= update_zustand=>`-Nachzug in `xml_config_parser.hpp:344-350`. Damit bleibt der Bau CT-deterministisch (Direktive "Metaprogrammierung compile-time zwingend") und der Ist-Zustand wird nur PROTOKOLLIERT, nicht zur Bauzeit erraten. Offene Entscheidung fuer den Owner: ob `update_zustand` (Paket-Stand) ueberhaupt CT-deklarierbar ist oder zwingend Laufzeit-Provenienz bleibt — er aendert sich ohne Code-Aenderung, waere also als CT-Achse strukturell luegen-anfaellig.

# 7. RISS-BILANZ (Prioritaet fuer STRUKT-R)

| # | Riss | Ort | Schwere |
|---|---|---|---|
| 1 | Keine `CebSubAxis`-Wurzel; Haupt/Unter nur per String-Konvention; kein `AxisKind::meta_meta` | `ceb_system_axis.hpp:32-37`, `topics/axis.hpp:17-21` | BLOCKER fuer R-B/R-C/R-D/R-E |
| 2 | Achsen-ORDNUNG existiert nirgends als Datum (4-fach dupliziert) | Generator-Blockfolge, `system_axis_code_versions.hpp:32`, `profile_run_facade.cpp:371`, `plan_legend.hpp:103` | BLOCKER fuer §1-Sortierung |
| 5 | ZWEI disjunkte "5 System-Achsen"-Mengen mit gleichem Namen | `validate_profile.hpp:696` vs `registry_to_axis_levels.hpp:113-122` | begrifflicher Kernriss; R-A muss eindeutig zugeordnet werden |
| 6+9 | Suffix-/Stempel-Ordnung byte-relevant fuer Sidecar, minio-Key UND generierten AdHoc-Quelltext | `profile_run_facade.cpp:364-400`, `artifact_cache.hpp:216`, `anatomy_version_stamp.hpp:64-79`, `lazy_adhoc_source_gen.hpp:199` | golden-Bruch, muss in §66-G2-Fenster mit `persistence_target` |
| 7 | `parse_system_axes` 3-Parameter-Signatur + XSD zementieren die Alt-Struktur; kein Ort fuer os/scheduling/load_framework | `xml_config_parser.cpp:98-116`, `experiment_schema.xsd:245-340` | breiter Umbau, 4 Profil-XMLs betroffen |
| 8 | Planer hart auf 2D `opt x simd`; 3 Emitter-Backends + CI-YAML-Vertrag | `experiment_plan_director.hpp:139-151, 1768-1800` + 7 `system_perm`-Aufrufe | breitester Einzel-Umbau |
| 4 | `scheduling`/`load_framework` haben KEIN Validat; opt/simd/atomic/isa DOPPELT | `validate_profile.hpp:373-448` vs `:929-993` | Nachzug an 2 Stellen + 4 static_asserts |
| 3 | Byte-Roundtrip-Gate erzwingt XML-Regeneration im selben Commit | `registry_roundtrip.cmake:55-66`, `CMakeLists.txt:3822-3831` | Prozess-Auflage |
| — | `kRunMethodologyCount = 3` — COMPARE (§62) im Code NICHT gefunden; CUSTOM_COMPILE waere der 5., der 4. fehlt | `run_methodology_registry.hpp:27-34, 77-104` | **offene Entscheidung fuer Owner vor R-C** |
| — | `telemetry` ist System-Achse OHNE CebSystemAxis-Typ (nur Organ-Registry-Reflexion) | `registry_to_axis_levels.hpp:119`, `profile_run_facade.cpp:390-395` | offene Entscheidung: gehoert telemetry in die neue Sortierung? |

SELBSTCHECK: read-only Kartierung, keine Datei geaendert (nur Read/Bash-grep/sed). Alle Zeilennummern aus Live-Lesung des Working-Tree am 26.07.2026. Ausgabe ASCII-only ausser `§`.