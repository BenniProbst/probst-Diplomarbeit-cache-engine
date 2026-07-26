STRUKT-R BAUPLAN (Synthese aus 3 Kartierungen + Session-Doc, 26.07.2026)

SESSION-DOC KOMPLETT GELESEN: `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md` (119 Zeilen, §1-§8). Zusatz-Verifikationen live durchgefuehrt (siehe Belege unten). NICHTS geaendert.

Pfad-Kuerzel: `CE/` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/`, `SUP/` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/`.

---

## 0. NEUE BELEGE (fuer den Plan tragend, live verifiziert)

| # | Befund | Beleg |
|---|---|---|
| N-1 | **Die Suffix-Umsortierung kostet NULL zusaetzliche Invalidierung** — der von ORG18 erzwungene ABI-Major-Bump 6->7 faltet sich AUTOMATISCH als `+ceb=7.0` in build_version UND cache_key_prefix. Jede `perm.dll.version` mismatcht ohnehin, jeder minio-Key wechselt ohnehin. | `CE/libs/cache_engine/profile_facade/profile_run_facade.cpp:378-379` (`"+ceb=" + COMDARE_ANATOMY_ABI_MAJOR`), `CE/libs/cache_engine/builder/artifact_transport/artifact_cache.hpp:215-217` (dieselbe Faltung), `CE/libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp:266-274` ("Jeder Bump laesst jede perm.dll.version mismatchen -> ALLE Binaries neu") |
| N-2 | **Voll-Bau-Kosten-Basis:** 2^17 = **524288 DLLs** (4 System-Perms x 4 Chunks x 32768), ~224 GB, ~24 h. Fall A (`disk_writeback` enabled) verdoppelt exakt: ~1.049 Mio DLLs, ~448 GB, ~48 h. | `SUP/docs/sessions/backups/20260726-kontext-neugruendung-workflow/ergebnisse/29-transkript-25-a6523e0d.md:82` |
| N-3 | `axes26::T17..T25` sind BELEGT (page_type/simd_extension/general_hardware/queuing_q1/q2/4 Shapes). Der neue Alias muss `T26_persistence_target` heissen; der Kompositions-SLOT ist Index 17 (18. Slot). | `CE/libs/cache_engine/builder/experiment_tree/registry_to_axis_levels.hpp:47-78` |
| N-4 | Andock-Topic fuer die 18. Organ-Achse: `topics/io/` traegt heute genau 1 Achse; das 2-Achsen-Muster liegt fertig in `topics/queuing/` (`StaticAxisVariants_Q1/_Q2`). Also `StaticAxisVariants_PT = axis_persistence_target::EnabledTargets`. | `CE/libs/cache_engine/topics/io/topic_io_config_set.hpp:16-17`, `CE/libs/cache_engine/topics/queuing/topic_queuing_config_set.hpp:22-29` |
| N-5 | Durchreich-Nachzug ist exakt **34 Dateien / 34 Vorkommen** `using queuing_q2` (13 `compositions/*_reference.hpp`, 20 Tests, 1x `composition_factory.hpp`) -> genau 33 Nachzugs-Zeilen. | `grep -rln "using queuing_q2" libs tests apps tools \| wc -l` = 34 |
| N-6 | **Der Planer-CLI ist JETZT belegt:** `git status` zeigt ` M Code/02_messung_driver/main.cpp` -> jede CLI-Arbeit (CUSTOM_COMPILE-Flag, §60-R3) ist zwingend seriell nach G4b-1. | `git -C SUP status --short` |
| N-7 | Kein CI-Tripwire auf `kCebContractCodegenMinor` in `.gitlab-ci.yml` gefunden (0 Treffer) -> der in `anatomy_module_abi_v1_decl.hpp:268` behauptete "CI-Tripwire-gated" ist NICHT verifizierbar; Minor darf bei Major-Bump auf 0 bleiben (Annahme, in J1 zu pruefen, NICHT geraten). | `grep -n kCebContractCodegenMinor SUP/.gitlab-ci.yml` = leer |

---

## 1. SCHEIBEN-SCHNITT IN LANES (datei-disjunkt zu G4b-1 UND untereinander)

**SPERR-MENGE G4b-1 (kein STRUKT-R-Lane beruehrt eine dieser Dateien):**
`CE/libs/cache_engine/builder/build_orchestrator/fingerprint_sidecar.hpp`, `.../build_orchestrator.hpp`, `CE/libs/cache_engine/builder/bestandslog/fingerprint_key_source.hpp`, `CE/libs/cache_engine/profile_facade/profile_run_facade.hpp`, `.../profile_run_facade.cpp`, `.../profile_run_entry.hpp`, `CE/tests/unit/test_g3_artifact_cache_transport.cpp`, `SUP/Code/02_messung_driver/main.cpp`.

**Ueberlapp-Verdikt (belegt, nicht geschaetzt):** die Sperr-Menge enthaelt (i) `system_axes_version_suffix()` (facade.cpp:364-400), (ii) beide Perm-Suffix-Kopien-Anker P1 (`profile_run_entry.hpp:754-757`), (iii) den Identitaets-Durchsetzungspunkt (`build_orchestrator.hpp:457-468`), (iv) die ZellKoordinaten-Befuellung (`profile_run_entry.hpp:331-347`), (v) den Planer-CLI. **Folge: W-13-Suffix, Identitaets-Scharfschaltung und Modus-Vollzug sind NICHT parallelisierbar — sie sind Lane F, seriell NACH G4b-1.** Alles Uebrige ist echt parallel.

| Lane | Titel | EXKLUSIVER Datei-Besitz (Auszug, vollstaendig in §3) | Parallel? |
|---|---|---|---|
| **A** | SYS-TAX: R-A/R-B/R-C/R-D Typ-Schicht + Ordnungs-Single-Source + Stempel + Generator + Validat | `CE/libs/cache_engine/topics/axis.hpp`; `CE/libs/cache_engine/include/cache_engine/measurement/{ceb_system_axis,compiler_system_axis,optimization_level_sub_axis,compiler_atomic_sub_axis,scheduling_system_axis,load_framework_system_axis,target_isa_system_axis}.hpp` + NEU `{ceb_sub_axis,ceb_complex_system_axis,operating_system_system_axis,os_*_sub_axis}.hpp`; `CE/libs/cache_engine/include/cache_engine/abi/{system_axis_code_versions,anatomy_version_stamp}.hpp` + NEU `system_axis_order.hpp`; `CE/libs/cache_engine/profile_facade/validate_profile.hpp` + NEU `system_version_suffix.hpp`; `CE/tools/system_axis_registry_gen/main.cpp` + `.../measurement/system_axis_registry.xml`; `CE/libs/common/serialization/xml_config_parser/xml_config_parser.{hpp,cpp}`; `SUP/Code/test_data_xml/experiment_schema.xsd`; Tests `test_striktheit_axis_dach_guard.cpp`, `test_m_w12_stamp_bausteine.cpp`, `thesis_tiere/test_validate_profile.cpp`, `thesis_tiere/test_experiment_parser.cpp`, `test_kf1_thesis_profile_parser.cpp`, `thesis_tiere/test_experiment_plan_director.cpp` (nur die `==5u`-Zahlen) | JA (P0) |
| **B** | ORG-18: `persistence_target` 17->18 (Achse, Komposition, POD, ABI, CSV, Katalog, Registry, golden) | NEU `CE/libs/cache_engine/axes/persistence_target/*` + `CE/libs/cache_engine/topics/io/axis_persistence_target/*`; `topics/io/topic_io_config_set.hpp`; `CE/CMakeLists.txt`; `builder/experiment_tree/{axis_path_serialization,genus_binding_traits,registry_to_axis_levels,result_ingest,axis_observer_classification,axis_operability_classification,axis_variant_version_table,composition_registry,profile_to_tree,cache_engine_builder_iterator,experiment_tree}.hpp`; `anatomy/{composition_factory,composition_concept,search_algorithm_anatomy,abi_adapter,observable_tier,observer_aggregate,measurable_workload}.hpp`; `include/cache_engine/abi/{anatomy_module_abi_v1_decl,anatomy_module_abi_v1}.hpp`; `harness/perm_runner.hpp`; `profile_facade/{source_catalog,lazy_adhoc_source_gen}.hpp`; `builder/codegen/{adhoc_emitter,all_axes_umbrella}.hpp`; `apps/catalog_codegen_tool/main.cpp`; `tools/axis_registry_gen/main.cpp` + `algorithm_profiles/cache_engine_axis_registry.xml`; ALLE Profil-XMLs; 33 Durchreich-Dateien; `CE/tests/unit/CMakeLists.txt`; ~10 Test-Dateien (§3) | JA (P0) |
| **C** | IDENT-GEN + R-E-HUB: Meta-Meta-Identitaet als Typ, Halbordnung generalisiert, **byte-neutral, INERT** | `include/cache_engine/measurement/{machine_simd_signature,simd_build_gate,simd_organ_requirement,simd_organ_sensibility,simd_feature_flag,extension_hardware_family_axis,simd_sub_axis}.hpp` + NEU `{hardware_meta_meta_axis,meta_meta_identity}.hpp`; `builder/bestandslog/bestandslog_document.hpp` (nur additives Feld, siehe Auflage C-3); Test `test_m_simd_feature_flag_catalog.cpp` + NEU `test_meta_meta_halbordnung.cpp` (unregistriert) | JA (P0) |
| **D** | MODE: Registry um CUSTOM_COMPILE (+ COMPARE, falls GO) | `include/cache_engine/measurement/run_methodology_registry.hpp` (EINE Datei) | JA (P0), absorbierbar in A |
| **F** | SUFFIX/KEY W-13 + Wiring (Modus-Vollzug, Identitaets-Scharfschaltung, Kommentar-Nachzug in Sperr-Dateien) | die 8 Sperr-Dateien + `experiment_run_entry.hpp` + `artifact_transport/artifact_cache.hpp` + `SUP/.gitlab-ci.yml` + Suffix-Tests (`test_s1_cache_key_prefix`, `test_g3_prune`, `test_g1_binary_version_stamp`, `test_s2_pull_tier_binary`, `test_s5_artifact_cache_bounded`, `test_w11_async_push_pump`) | NEIN — seriell nach G4b-1 |
| **E** | PLAN-ND: Planer von 2D `opt x simd` auf N-dimensional | `profile_facade/planner/{plan_legend,experiment_plan_director,planner_version}.hpp`, `thesis_tiere/test_experiment_plan_director.cpp` (Legenden) | NEIN — seriell nach A |
| **G** | LAGER/xlsx-Materialisierung (Ordner-Kaskaden, xlsx-Writer, Factory je Sheet) | offen (#46b) | NEIN — nach Voll-Bau-4 |

**INTEGRATIONS-NAHTSTELLEN (geteilte Dateien, per Patch am Join, NICHT parallel editiert):**
- `abi/anatomy_version_stamp.hpp`: Datei-Besitz **A** (System-Zeile `:64-79`). **B** liefert die Organ-Array-Aenderung (`:42-62`, 17->18) als Patch-Text an J1. Zwei Lanes duerfen diese Datei NIE gleichzeitig anfassen.
- `profile_facade/validate_profile.hpp`: Besitz **A**. B's Organ-18-Beruehrungen (`:54,:188,:191,:226`) sind array-getrieben = 0 Edits erwartet; falls doch, Patch an A.
- `CE/tests/unit/CMakeLists.txt` + `CE/CMakeLists.txt`: Besitz **B**. A und C erzeugen neue Test-`.cpp`, registrieren sie NICHT — Registrierung sammelt der Integrator am Join (verhindert das klassische 3-Wege-Konflikt-Nest).
- Profil-XMLs (`all_axes_golden.profile.xml` u.a.): Besitz **B**. A braucht dort nur dann Edits, wenn `<operating_system>`/`<scheduling>` deklariert werden sollen -> mit Empfehlung Q-6 (`xs:all` + weglassbar) sind es NULL Edits.

**HARTE AUFLAGE C-3 (sonst bricht die Sperr-Datei):** `ZellKoordinaten` (`bestandslog_document.hpp:147-157`) darf nur um ein Feld **am Ende mit Default-Initialisierer** wachsen — `CE/tests/unit/test_g3_artifact_cache_transport.cpp:202` konstruiert mit designated init `{.combo,.opt,.simd}` und ist G4b-1-gesperrt. Umsortieren oder Pflicht-Feld = roter Bau in fremdem Lane-Gebiet.

---

## 2. REIHENFOLGE + ABHAENGIGKEITEN

```
VERTRAGS-SYNC (0,5 Ah, VOR P0, Integrator+A+C):
  V1  ext_hw-HUB-API: std::span<MetaMetaDescriptor const> meta_metas() + constexpr subsumes(A,B)
      -> A's Generator emittiert dagegen, C implementiert sie.  (A<->C Einzige Kopplung)
  V2  Ordnungs-Single-Source: Datei/Name/Form (constexpr Tabelle kSystemAxisOrder) friert A ein;
      B/E/G konsumieren sie spaeter read-only.
  V3  Stempel-End-Form (Owner-Frage Q-3!) -- ohne diese Entscheidung darf A-II nicht starten.

P0  ---- PARALLEL, sofort, datei-disjunkt zu G4b-1 ----
    A (SYS-TAX)     ~32-36 Ah   |
    B (ORG-18)      ~31 Ah      |  laufen echt gleichzeitig
    C (IDENT/R-E)   ~12,5 Ah    |
    D (MODE)        ~1,5 Ah     |

J1  ---- JOIN 1 (Integrator, seriell, ~6 Ah) ----
    Patch-Uebergaben (anatomy_version_stamp Organ-Zeile, Test-Target-Registrierung)
    BEIDE Registry-XMLs regenerieren (system_axis_registry.xml + cache_engine_axis_registry.xml)
    golden neu ankern: kNewGolden131072Crc64 + golden_fullpilot_320_binary_ids.txt
    voller lokaler ctest (Mode A, bare metal) + ASCII-Selbstcheck + grep -P '[^\x00-\x7F]'

G4b-1 landet  ----> Sperr-Menge frei

P1  F (SUFFIX/KEY W-13)  ~12,5 Ah  SERIELL. Voraussetzungen: G4b-1 gemergt UND A fertig
    (F konsumiert A's system_version_suffix.hpp + kSystemAxisOrder).

J2  ---- JOIN 2: lokale Voll-Verifikation, dann Push, dann CI gruen ----

TRIGGER Voll-Bau-4   (ab hier ist Bau-Laufzeit = Arbeitsfenster)

P2  ---- NACH dem Trigger, waehrend der Bau laeuft ----
    E (PLAN-ND) ~10 Ah   |  C2 Identitaets-Scharfschaltung ~4 Ah  |
    D2 Modus-Vollzug (emits_measure_job + CLI) ~5 Ah  |  A-IV Parser/XSD-Vollausbau ~4 Ah
    G (Lager-Baeume/xlsx) ~12-16 Ah
```

**"Was muss vor W-13": A vollstaendig** (W-13 montiert die Segmente in der Ordnung, die A als Single-Source definiert; ohne A hat F kein Datum und wuerde die Ordnung ein 5. Mal duplizieren = Riss 2 verschlimmern). **B muss NICHT vor W-13** (ORG-18 beruehrt keine Suffix-Bytes; es liefert nur den ABI-Major-Bump, der F's Umsortierung gratis macht — beides muss aber im SELBEN Bruch-Fenster VOR dem Trigger liegen, sonst zweiter Voll-Bau). **C und D muessen NICHT vor W-13** und sind byte-neutral (Auflage: `+ext=<simd>` bleibt fuer die Ein-Familien-CPU-Konfiguration byte-identisch — der HUB ist dann der Spezialfall-Wrapper, nicht ein neues Segment).

**Kritischer Pfad = A -> J1 -> F -> J2 -> Trigger.** B laeuft vollstaendig im Schatten von A (B ist 31 Ah gegen A's 32-36 Ah). Bei 3 Agenten (A, B, C+D) ist die Wanduhr-Zeit ~= A + J1 + F ~= 36 + 6 + 12,5 = **~55 Wanduhr-Stunden**, also **~2 bis 2,5 Kalendertage** vor dem Trigger. Das ist die ehrliche Zahl; sie ist der Kern von Owner-Frage Q-0.

---

## 3. JE SCHEIBE: UMFANG / WACHEN / AUFWAND

### LANE A — SYS-TAX (R-A, R-B, R-C, R-D + Ordnung + Stempel + Generator + Validat)

| Stufe | Umfang | Ah |
|---|---|---|
| A-I.1 | **Schicht-Taxonomie** (Riss 1, BLOCKER): `AxisKind` um `system_meta_meta` (`topics/axis.hpp:17-21`); NEU `ceb_sub_axis.hpp` mit `CebSubAxis<Derived, ParentAxis>` -> `parent_axis()` als TYP, `parent_axis_label()` nur abgeleitet, `static_assert(CebSystemAxisConcept<ParentAxis>)`; `ceb_system_axis.hpp:32-37` Concept um Schicht-Praedikate | 3 |
| A-I.2 | **R-A** NEU `operating_system_system_axis.hpp` (CRTP nach Vorbild `machine_simd_signature.hpp:31-48`) + 4 Unter-Achsen `os_version/kernel/build/update_zustand` (Vorbild `optimization_level_sub_axis.hpp`) | 3 |
| A-I.3 | **R-B** `scheduling` -> `CebSubAxis<..., TargetIsaSystemAxis>`; Entscheidung Q-7 (Options-Familie vs `fixed_enum_tuple`) | 2 |
| A-I.4 | **R-D** NEU `ceb_complex_system_axis.hpp` (Command-Pattern, Vorbild `builder/commands/axis_library_registry.hpp`): `CompoundSystemAxis<TargetIsa, ExtHw, MetaMetas...>` + `SubAxisGroup<compiler, opt_level, atomic128>`; `compiler` verliert Haupt-Status; die 4 `parent_axis_label()=="compiler"`-static_asserts (`validate_profile.hpp:421-422,971-972`, `compiler_atomic_sub_axis.hpp:98`, `optimization_level_sub_axis.hpp:145`) auf das Gruppen-Label umhaengen (NICHT streichen -> sonst GN-1-Verwaisung wie in `extension_hardware_family_axis.hpp:1-22` beschrieben) | 5 |
| A-I.5 | **R-C** `load_framework` -> `AxisKind::system_meta_meta`, 1. Meta-Meta; `sub_axis_label()=="workload"` (`load_framework_system_axis.hpp:29`) bleibt UNANGETASTET (Single-Source der Zwei-Phasen-Gueltigkeit `cache_engine_builder_iterator.hpp:789-793`) | 2 |
| A-II | **Ordnungs-Single-Source** (Riss 2): NEU `abi/system_axis_order.hpp` mit `constexpr kSystemAxisOrder` = §1-Kette; `system_axis_code_versions.hpp:28,32-38,49-50` darauf umstellen; `anatomy_version_stamp.hpp:64-79` `system_stamp_line()` iteriert die neue Ordnung | 3 |
| A-III | **Generator** `tools/system_axis_registry_gen/main.cpp`: 5 handgeschriebene Bloecke (`:164,215,244,258,284`) -> Iteration ueber `kSystemAxisOrder`; `scheduling` als `sub_axis` unter target_isa; `compiler/opt_level/atomic128` als Gruppe; `operating_system`-Block NEU; `stdout`-Literal `:334`; XML regenerieren | 4 |
| A-IV | **Parser/PODs/XSD** (Riss 7): `parse_system_axes` 3-Param-Signatur (`xml_config_parser.cpp:98-116`) -> Gruppen-PODs + NEU `OperatingSystemAxisSel`; XSD `SystemAxesType` (`experiment_schema.xsd:245-340`) `xs:sequence` -> `xs:all` (Q-6) | 4 (DEFERRABLE, siehe §6) |
| A-V | **Validat** (Riss 4): beide Kanaele (`validate_profile.hpp:373-448` + `:929-993`), `RegistryTrio::system_axis_count()` (`:698`), Resolver `resolve_axis_refs_against_trio:748-799` muss Unter-Achsen-Namen mit-aufloesen (sonst kippt `V-CATEGORY` auf `V-UNREG-AXIS` und bestehende Profile mit `scheduling`/`compiler` werden hart rejected) | 4 |
| A-VI | Test-Re-Anker (siehe Wachen-Tabelle) | 4 |
| A-VII | NEU `profile_facade/system_version_suffix.hpp`: reine Segment-Funktion in §1-Ordnung, jedes Segment weglassbar-bei-Default; **nicht verdrahtet** (F verdrahtet) + Unit-Test (unregistriert) | 2 |
| | **Summe A** | **32-36** |

**Wachen, die A BEWUSST bricht + neu ankert:**

| Wache | Anker | Was bricht | Neu-Anker |
|---|---|---|---|
| `test_system_axis_registry_roundtrip` (Byte-Diff==0) | `CE/tests/unit/registry_roundtrip.cmake:55-66`, `CMakeLists.txt:3822-3831` | jede Typ-Aenderung | XML im SELBEN Commit regenerieren (Prozess-Auflage, Riss 3) |
| System-Stempel-BYTES | `test_m_w12_stamp_bausteine.cpp:105-109,261,267-269,338` | `kSystemAxisCodeCount`, volle Stempel-Zeile literal, `;load_framework=code@1.0.0` | Zeilen literal neu schreiben nach Q-3-Entscheid |
| 5er-Zahl | `thesis_tiere/test_validate_profile.cpp:289`; `thesis_tiere/test_experiment_plan_director.cpp:112-113,308` | `system_axis_count()==5u` | neue Zahl nach Q-3 |
| Label-/parent-Pins | `test_striktheit_axis_dach_guard.cpp:70,102-103,117,120,125,138-139,153-154,166,171` | ALLE parent-Strings von scheduling/compiler-Gruppe; neue OS-Bloecke | Block je Achse erweitern; DEPRECATED-Insel (`:87-88`) NICHT anfassen |
| Generierter AdHoc-Quelltext (byte-relevant fuer JEDE Tier-Binary) | `lazy_adhoc_source_gen.hpp:199-201,259`, `adhoc_emitter.hpp:94`, `pilot_source_map.hpp:52-56` | System-Stempel im Quelltext | faellt mit dem ABI-7-/golden-Bruch von B zusammen — **nur gemeinsam sinnvoll** |
| MUSS gruen BLEIBEN | `test_br1_full22_count.cpp:60-65` (5 System-Levels in `build_system_axis_levels()`) | — | `operating_system` gehoert in die CebSystemAxis-Menge, **NICHT** in `registry_to_axis_levels.hpp:113-122` (Riss 5) |

### LANE B — ORG-18 (`persistence_target`)

| Stufe | Umfang | Ah |
|---|---|---|
| B-1 | Achsen-Modul NEU `axes/persistence_target/` (Skelett = `axes/mapping/` = kleinste vollstaendige 2-Wert-Achse; Durchreich-Koerper = `axes/migration_policy/axis_migration_none.hpp` bzw. `axes/io_dispatch/axis_io_in_memory_only.hpp`), `topics/io/`-Andockung (N-4), `CE/CMakeLists.txt` option/foreach/configure_file/message, `COMDARE_DEFINE_ORGAN_LOCATION` je Baustein | 2 |
| B-2 | `kCompositionAxisNames` 17->18 (`axis_path_serialization.hpp:34-37`) + `serialize_composition_from_slots` (`:70-84`, HANDARBEIT) + Kopf-Doku `:10` | 1 |
| B-3 | `composition_factory.hpp:60-79,98-101,126-133` (18 Template-Params, `static_assert(sizeof...(Vs)==18)`); `composition_concept.hpp:20-56,62-65` (`composition_organ_count=18` -> ABI-Symbol `organ_count()`) | 1,5 |
| B-4 | `genus_binding_traits.hpp:39,49-51` SearchAlgorithm 17->18 (Adapter/Set/Sequence/View 11/13/9/5 nur bei Q-8=ja) | 1 |
| B-5 | `search_algorithm_anatomy.hpp` (18. Organ-Member, `observe_all`-Zweig) + `abi_adapter.hpp` (2218 Z., harte Indizes `:1294-1404`, `acc[17]`->`acc[18]` bei `:671,837,1454,1634`, Reset `:1674,1971`) + `observer_aggregate.hpp:94-140` (`total_slots()`) | 5 |
| B-6 | Observer-POD: `observable_tier.hpp:49,68-100,127-144` + **sizeof 1272 -> 1344** (`:152-154`) + Snapshot-Version 7->8 (`:158`); `measurable_workload.hpp:99`, `experiment_tree.hpp:75` | 2 |
| B-7 | ABI-Major 6->7 (`anatomy_module_abi_v1_decl.hpp:54` + Doku `:35,51`) -> Loader lehnt Alt-DLLs per Major-Mismatch ab (gewollt), `+ceb=7.0` faellt automatisch (N-1) | 0,5 |
| B-8 | Mess-Zeilen-Kontrakt 160 -> 169: `result_ingest.hpp:47,60-62`; `harness/perm_runner.hpp:49-50,83,114,324`. **Auflage:** Reader BEIDE Laengen akzeptieren (Q-9) | 1,5 |
| B-9 | `source_catalog.hpp` (598 Z.): `CatalogAxes` 18. Param + `L17` + Engine; `FullSourceCatalog:127` (K17 = 2 oder 1, Q-1!); `golden_320_catalog:131`; `SmallSourceCatalog:135`; `catalog_axis_product:141-152`; Count-Guards `:156-160`; `catalog_static_levels:192-218`; `AxisSweepCatalogFull:354-380`; **16 Sweep-Aliase je 18 Positions-Argumente `:411-452`** + Dispatch `:460-489` | 4 |
| B-10 | Emitter/Codegen: `adhoc_emitter.hpp:52-77`, `all_axes_umbrella.hpp:19-40`, `lazy_adhoc_source_gen.hpp:112,134-153`, `apps/catalog_codegen_tool/main.cpp:113-171` | 2 |
| B-11 | `registry_to_axis_levels.hpp` (`T26`-Alias, `append_composition_tail_axis_levels` nach `queuing_q2`, `all_axis_matrix_count`) + `tools/axis_registry_gen/main.cpp:207-224` + Organ-Registry-XML regenerieren (17/82 -> 18/84) | 2 |
| B-12 | Profil-XMLs: `all_axes_golden.profile.xml` (18. `<axis ref>`, 18. `<axis_sweep>`, `active_axes`, `cap`), `m3v2_study.profile.xml`, `experiment_golden.xml` | 1,5 |
| B-13 | Durchreich-Nachzug 33 Dateien (N-5) | 2 |
| B-14 | Klassifikations-/Legenden-Tabellen: `axis_observer_classification.hpp:34,54`, `axis_operability_classification.hpp:34-52`, `axis_variant_version_table.hpp:129,159`, `composition_registry.hpp:31,40` | 1 |
| B-15 | Test-Re-Anker + golden-Regeneration (`gen_golden_fullpilot --crc64`, ~38 s/1,28 GB laut Doku) | 4 |
| | **Summe B** | **31** |

**Wachen, die B BEWUSST bricht + neu ankert:**

| Wache | Anker | Neu-Anker |
|---|---|---|
| **golden-CRC64** `kNewGolden131072Crc64 = 0xF1C1F26A1232073B` | `source_catalog.hpp:168` | bricht in BEIDEN Faellen (Q-1), weil jede id das Segment `/persistence_target=memory_only` erhaelt. Neu ermitteln per `gen_golden_fullpilot --crc64`. **TABU-Regel beachten:** der Wert ist EIN Symbol; Re-Anker nur mit literalem Werkzeug-Output belegen |
| **320er-id-Datei** | `tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt` (Kopf "17 Slots") | neu erzeugen, Kopfzeile 18 Slots |
| Katalog-Count-Guards | `source_catalog.hpp:156-160` | 131072 (Fall B) bzw. 262144 (Fall A) |
| POD-sizeof | `observable_tier.hpp:152-154` (1272) | 1344 |
| CSV-Feldzahl | `result_ingest.hpp:47` (160) | 169 (+ Alt-Laengen-Akzeptanz, Q-9) |
| ABI-Major | `anatomy_module_abi_v1_decl.hpp:54` (6) | 7 |
| Test-Erwartungen | `test_limits_entkopplung_vorstufe.cpp:120-141`, `test_lazy_adhoc_source_gen.cpp:135,190-207,409`, `test_profile_roundtrip.cpp`, `test_reflect_versions_all17.cpp`, `test_all19_segment_timer.cpp`, `test_smoke_coverage_profile.cpp`, `test_measurement_categories.cpp`, `test_axis_sweep_pilot.cpp`, `test_wdk_datasets_fairness.cpp`, `test_genus_organ_binding.cpp` | pro Datei |
| MUSS gruen BLEIBEN | `kMaxMaterializableCatalogCardinality=4096` + Guard-des-Guards (`source_catalog.hpp:183,187-190`); `test_axis_registry_roundtrip` (nur mit XML-Regen im selben Commit) | unangetastet |

### LANE C — IDENT-GEN + R-E-HUB (byte-neutral, INERT)

| Stufe | Umfang | Ah |
|---|---|---|
| C-1 | Meta-Meta-Typ-Familie: variadisches Template-Pack (**kein `std::variant`**), Vorbild `machine_simd_signature.hpp:30-47,79-87` (`std::span` ueber `static constexpr std::array` in `do_*()`); `for_each`-Fold-Vorbild `run_methodology_registry.hpp:130-135` | 3 |
| C-2 | Halbordnung generalisieren: `admit_organ_on_machine` (`simd_build_gate.hpp:153-159`, ist bereits exakt `T subset S`) von `SimdFeatureFlag` auf Meta-Meta-Saetze heben; `subsumes(A,B)` constexpr; Freigabe-Maximum `S geschnitten meaningful geschnitten route` (`:141-146`) beibehalten | 3 |
| C-3 | **R-E HUB**: `extension_hardware_family_axis.hpp:40-53` wird Command-Pattern-Hub mit `meta_metas()`-Span (Vertrag V1); GN-1-static_asserts `:84-93` erhalten | 3 |
| C-4 | `machine_signatures`-Reflexion um den Meta-Meta-Satz je Maschine (Patch an A's Generator `main.cpp:298-316`, `count="3"` `:302,336`) | 1,5 |
| C-5 | Tests (neu, unregistriert) + `test_m_simd_feature_flag_catalog.cpp` bleibt gruen (additiv) | 2 |
| | **Summe C** | **12,5** |

**Wachen:** C bricht **absichtlich KEINE**. Auflagen: (i) `active_machine_signature()` (`simd_build_gate.hpp:187`) bleibt in P0 der Stub `{}` -> das Gate bleibt inert -> keine Verhaltens-/Flag-Aenderung vor dem Voll-Bau (Scharfschaltung = P2/C2', Owner-Frage Q-11); (ii) `+ext=<simd>` bleibt byte-identisch (Ein-Familien-Spezialfall); (iii) Auflage C-3 aus §1 (ZellKoordinaten additiv am Ende).

### LANE D — MODE

Umfang: `run_methodology_registry.hpp` — Enum-Wert(e) (`:27-31`), `kRunMethodologyCount` (`:34`), Registry-Zeile(n) (`:60-64`), NEUER Namen-Anker-static_assert (`:82-86`), NEUER Build-Semantik-Anker (Muster `:90-104`). XSD (`experiment_schema.xsd:191-199`, offener `xs:string`, unbounded), Parser (`xml_config_parser.cpp:393-395,494-496`) und Validat (`validate_profile.hpp:475-485,1214-1223`) kosten **NULL** (registry-getrieben). **1,5 Ah** (+1 Ah falls COMPARE als 4. Modus mitkommt, Q-4). Wachen: keine bricht (`test_validate_profile.cpp:418-430` / `test_experiment_parser.cpp:703-713` pruefen nur "Fehler enthaelt run_methodology"). **Der teure Teil (Mess-Job-Entfall) ist NICHT hier** -> §6.

### LANE F — SUFFIX/KEY W-13 (seriell)

Umfang: A's `system_version_suffix.hpp` verdrahten als EINZIGE Quelle; Form P (P1 `profile_run_entry.hpp:754-757`, P2 `experiment_run_entry.hpp:293-297`, P3 `profile_run_facade.cpp:951-953` faellt weg) und Form S (`facade.cpp:364-400` wird duenne Resolver-Huelle) zusammenfuehren; `+ceb` aus `cache_key_prefix` (`artifact_cache.hpp:215-217`) entfernen und als letztes Suffix-Segment falten (behebt den Doppel-`+ceb`); `+os`/`+a128`/`+sched`/`+lf` weglassbar-bei-Default ergaenzen; `.gitlab-ci.yml:877-880` GN_PREFIX + Fallback `:896` hart fehlschlagen lassen; Kommentar-Nachzug in den (dann freien) Sperr-Dateien. **12,5 Ah.**
Wachen: `test_s1_cache_key_prefix.cpp:36,44,53,61,70`, `test_g3_prune.cpp:148,171-173,206`, `test_g1_binary_version_stamp.cpp:64,98`, `test_s2_pull_tier_binary.cpp:94,116,161`, `test_s5_artifact_cache_bounded.cpp:84`, `test_w11_async_push_pump.cpp:57,65,174,232` -> alle neu ankern. NEUE Wachen: (T-a) Perm-Suffix == Facade-Suffix; (T-b) `count("+ceb=")==1`; (T-c) Ordnungs-Wache `+target < +os < +ext < +cxx < +opt < +a128 < +bt < +ceb`, `+mtool/+mrg` NUR in `cache_key_prefix` und NUR hinter `+ceb`.
Remote-Folge: die Form-P-Objekte mit `+ext=avx2`/`+ext=avx512` (golden-Reihe x CI-Matrix `.gitlab-ci.yml:1048-1076`) verwaisen — **Kosten additiv NULL**, weil `+ceb=6.0`->`7.0` (N-1) sie ohnehin alle invalidiert. Additiv liegen lassen, **kein Loesch-GO angefragt** (Bau-Artefakte, keine Messdaten).

### AUFWANDS-BILANZ (ehrlich)

| Block | Ah | im kritischen Pfad? |
|---|---|---|
| Vertrags-Sync | 0,5 | ja |
| A SYS-TAX | 32-36 | **ja** |
| B ORG-18 | 31 | nein (laeuft im Schatten von A) |
| C IDENT/R-E | 12,5 | nein |
| D MODE | 1,5 | nein |
| J1 Join + golden-Re-Anker | 6 | ja |
| F SUFFIX/KEY | 12,5 | **ja** |
| J2 lokale Voll-Verifikation + CI | 4 | ja |
| **VOR-TRIGGER-SUMME** | **~100 Ah Arbeit / ~55 h Wanduhr bei 3 Agenten** | |
| E PLAN-ND | 10 | nach Trigger |
| C2' Scharfschaltung | 4 | nach Trigger |
| D2 Modus-Vollzug + CLI | 5 | nach Trigger |
| A-IV Parser/XSD-Vollausbau | 4 | nach Trigger |
| G Lager/xlsx | 12-16 | nach Trigger |

---

## 4. OWNER-ABNAHME-FRAGEN (Gegenvorschlag zuerst; NICHTS erfunden)

**Q-0 (ueberlagert alles) — Umfang vor dem Trigger.** STRUKT-R vollstaendig vor Voll-Bau-4 kostet **~55 Wanduhr-Stunden bei 3 parallelen Agenten** (kritischer Pfad A -> J1 -> F). Drei Varianten:
- **V1 voll** (A+B+C+D+F, ~100 Ah): alles architekturkonform, Trigger ~2,5 Tage spaeter.
- **V2 Byte-Schnitt** (A ohne A-IV + B + F, ~76 Ah): alles was Bytes/Identitaet beruehrt ist drin; Parser/XSD-Vollausbau, Planer-ND, Identitaets-Scharfschaltung, Modus-Vollzug nach dem Trigger. Trigger ~2 Tage spaeter. **EMPFEHLUNG.**
- **V3 nur ORG-18+Suffix** (B+F, ~44 Ah): Trigger ~1 Tag spaeter, ABER der System-Stempel aendert sich bei R-A..R-D spaeter erneut -> **ein FUENFTER Voll-Bau** (~24 h, ~224 GB) wird faellig. Nur waehlen, wenn der Termin haerter ist als die Ordentlichkeit.
Frage: **V1, V2 oder V3?**

**Q-1 (Kern-Frage a) — `disk_writeback` `enabled=true` oder `false` fuer Voll-Bau-4?**
- `true` (Fall A): `FullSourceCatalog = CatalogAxes<2 x 18>` -> 2^18 = **262144** Katalog-Kardinalitaet -> Voll-Bau **~1,049 Mio DLLs, ~448 GB, ~48 h** (Verdoppelung, belegt N-2). Der Anti-Materialisierungs-Guard haelt (262144 > 4096); `golden_320_catalog` bleibt 320.
- `false` (Fall B): die Achse existiert vollstaendig (Typ, Registry, binary_id-Segment, Stempel), Raum bleibt **131072**, ~224 GB, ~24 h. **Auflage:** `FullSourceCatalog` MUSS dann explizit `K17=1` tragen — `mp_take_c<L,2>` auf einer 1-elementigen Liste ist ill-formed (`cmake/third_party/boost_mp11/.../algorithm.hpp:430,447`), `CatalogAxes` hat KEINEN `min()`-Schutz (anders als `axis_registry_gen/main.cpp:140-141`). Ein uniformes `<2,...,2>` bricht im TU.
- In **beiden** Faellen bricht der golden-CRC (jede id erhaelt `/persistence_target=...`).
- **EMPFEHLUNG: `false`.** Begruendung: 448 GB gegen den dokumentierten Plattenplatz-Engpass (~72 GB frei auf prod1 laut Nachlese-Doku, in J1 live neu zu pruefen), 48 h gegen das Zeitbudget, und die disk-Messung wird ohnehin erst scharf, wenn `axis_persistence_disk_writeback` einen echten Schreibpfad implementiert (heute waere er ein Durchreich-Zwilling = Messwert-Luege). Der Raum bleibt per `option()` jederzeit ohne Code-Aenderung aufschaltbar.

**Q-2 (Kern-Frage b) — OS-Unter-Achsen-Werte: Host-Erhebung oder Registry-Deklaration?**
Ist-Befund: es gibt **keine** Erhebungs-Naht (`uname`/`utsname`/`/etc/os-release`/`/proc/version` = 0 Treffer in `libs`/`apps`/`tools`); Hostname existiert nur als generierter Shell-Text `"@$(hostname)"` (`experiment_plan_director.hpp:1142`).
- **Variante D (deklarativ, EMPFEHLUNG):** `operating_system` + 4 Unter-Achsen CT-deklarativ nach dem Vorbild `machine_simd_signature.hpp:77-108` (je real gemessener Maschine ein Typ); die Ist-Werte werden zur Mess-Zeit als **Provenienz** protokolliert (xlsx-INFO-Sheet je §6 des Session-Docs, plus `<machine os_version= kernel= build= update_zustand=>` in `xml_config_parser.hpp:344-350`). Haelt den Bau CT-deterministisch (Direktive "Metaprogrammierung compile-time zwingend").
- **Variante R (erhoben):** Laufzeit-`uname` speist die Achse -> der Bau wird host-abhaengig, Byte-Determinismus und Reproduzierbarkeit des golden fallen.
- **Teilfrage Q-2b:** `update_zustand` (Paket-Stand) aendert sich **ohne Code-Aenderung**. Als CT-Achse ist er strukturell luegen-anfaellig. Soll er (i) CT-Achse mit Grob-Klassen (z.B. `frozen`/`rolling`) sein, (ii) reine Laufzeit-Provenienz (keine Achse), oder (iii) Achse mit genau einem Baustein `unknown` als Platzhalter?

**Q-3 (Kern-Frage c) — Sichtbarkeit der Komplex-Haupt-Achse in Stempel/Suffix.** (Blockiert A-II; ohne Entscheid darf A-II nicht starten.)
- **S1 flach/intern:** Stempel-Tabelle = `{target_isa, operating_system, extension_hardware, load_framework}` (Count 5 -> 4), Komplex-Achse und alle Unter-Achsen unsichtbar. **Nachteil:** die Code-Version von `compiler`/`opt_level`/`atomic128`/`scheduling` verschwindet aus der Provenienz -> Rueckschritt.
- **S2 geschachtelt, Komplex intern (EMPFEHLUNG):** 4 Haupt-Zeilen + explizite Unter-Zeilen in Klammer-Notation (`target_isa[scheduling]`, `extension_hardware`, `<gruppe>[compiler,opt_level,atomic128]`), Komplex-Achse bleibt CEB-intern. Provenienz vollstaendig, Suffix unveraendert segmentiert.
- **S3 Komplex sichtbar:** zusaetzlich eine eigene Klammer/Zeile (`build_target_complex[...]`) im Stempel **und** ein eigenes Suffix-Segment. Maximale Explizitheit, aber ein weiteres Segment in jedem Key und eine weitere Byte-Wache.
Frage: **S1, S2 oder S3** — und falls S2/S3: soll die Klammer auch im **Suffix** erscheinen oder nur im Stempel?

**Q-4 — COMPARE: 4. Modus jetzt mitbauen?** Der Owner-KERN nennt CUSTOM_COMPILE den **fuenften** Modus; im Code gibt es heute **drei** (`run_methodology_registry.hpp:27-31`) und COMPARE existiert nur als XSD-Kommentar-Reserve fuer #47 (`experiment_schema.xsd:60-61`) plus als unbeteiligter CEB-Command (`compare_engine_command.hpp:10`). Ohne COMPARE ist CUSTOM_COMPILE der 4. **Vorschlag:** COMPARE als 4. Registry-Eintrag mitbauen (+1 Ah), damit die Nummerierung des KERN stimmt. Zustimmung?

**Q-5 — `cmake_build_type` fuer CUSTOM_COMPILE.** Das consteval-Vollstaendigkeits-Praedikat (`run_methodology_registry.hpp:67-75`) verbietet einen leeren `cmake_build_type`; CUSTOM_COMPILE ist aber genau der Modus, dessen Build-Typ der Anwender frei setzt. **Vorschlag:** Sentinel `"Custom"`, und die 5 Emissions-Verzweigungen (`experiment_plan_director.hpp:955,1079,1156,1406,1481` — sie pruefen ausschliesslich `== "Debug"`) behandeln ihn wie Release. Alternative: `cmake_build_type` optional, consteval-Anker weicht auf (nicht empfohlen).

**Q-6 — XSD `xs:sequence` -> `xs:all`?** `SystemAxesType` (`experiment_schema.xsd:253-366`) ist heute order-binding in Alt-Ordnung (compiler, extension_hardware, target_isa). Der Parser ist ordnungs-agnostisch (`xml_config_parser.cpp:98-116`, `child("<name>")`-Lookups). **Vorschlag:** `xs:all` + Ordnungs-Kommentar -> bruchfrei, alle 11 Profil-XMLs bleiben valide. Alternative: `xs:sequence` umsortieren + alle Profil-XMLs mit-umsortieren (mehr Bruch, kein Gewinn).

**Q-7 — `scheduling` als Unter-Achse: Options-Familie oder Enum-Tupel?** Die 5 getypten Sub-Dims (`scheduling_system_axis.hpp:26-40`) haben **keine id-Strings** und heute **keinen XML-Wertebereich**. (i) Options-Familie mit ids (Vorbild `simd_sub_axis.hpp`) -> voll deklarierbar/permutierbar, mehr Arbeit + neuer Validat-Ort; (ii) `kind="fixed_enum_tuple"` ohne ids -> Generator-Literale wie heute (`main.cpp:265-280`), nicht profil-waehlbar. **Vorschlag: (ii) fuer STRUKT-R**, (i) nach dem Voll-Bau (Q-7 ist kein Byte-Thema).

**Q-8 — Bekommen Adapter/Set/Sequence/View `persistence_target`?** `GenusBindingTraits` traegt eigene Namenslisten mit slot_count 11/13/9/5 (`genus_binding_traits.hpp:63,88,115,140`); nur SearchAlgorithm haengt am 17er-Array. **Vorschlag: NEIN** (nur SearchAlgorithm auf 18) — Gattungen sind per Direktive disjunkt, und persistence_target ist eine Such-/Index-Eigenschaft. Zustimmung?

**Q-9 — Alt-Mess-CSV (160 Felder) nach dem 169-Feld-Bruch.** `result_ingest.hpp:47` verwirft eine Zeile mit falscher Feldzahl **still** (`return nullopt`) -> alle bestehenden Mess-CSV werden unsichtbar. **Vorschlag:** versionierter Reader, der 160 UND 169 akzeptiert (160-Zeilen implizieren `persistence_target=memory_only`), plus Log-Zeile je verworfener Laenge. Alternative: separater Lager-Zweig fuer Alt-Daten. Messdaten werden in keinem Fall geloescht (Direktive), aber der Weg braucht ein GO.

**Q-10 — Slot-Position von `persistence_target`.** **Vorschlag: T-Anhang hinter `queuing_q2`** (byte-minimal: nur ein Suffix-Segment je id, alle 17 bestehenden Segment-Positionen bleiben; die §1-/§5-Gruppen-Ordnung wird auf der **Lager-Baum-Ebene** realisiert, nicht in der binary_id-Radix-Folge). Alternative (Einschieben in die 05_write_path_io-Gruppenposition) schneidet die mixed-radix-Reihenfolge der `StaticBinaryView` neu = groesserer Bruch ohne Gewinn. Zustimmung? Zusatzfrage Q-10b: `golden_wired`-GoldenK der neuen Achse = **1** (nur `memory_only` im 320er-Snapshot, EMPFEHLUNG) oder 2?

**Q-11 — Identitaets-Halbordnung: Scharfschaltung vor oder nach Voll-Bau-4?** `active_machine_signature()` (`simd_build_gate.hpp:187`) gibt heute `{}` zurueck -> das Gate (`build_orchestrator.hpp:457-468`) ist inert. Scharfschalten kann (i) Binaries ablehnen (`status=-4`) und (ii) via `effective_march_flags` (`:163-170`) **Compile-Flags aendern** = Byte-Aenderung. **Vorschlag: Typ-Generalisierung jetzt (Lane C, inert), Scharfschaltung NACH dem Trigger** in einem eigenen kleinen Bruch-Fenster mit A/B-Beleg. Zustimmung?

**Q-12 — Bestandslog waehrend Voll-Bau-4 weiterhin AUS?** Der Meta-Meta-Satz muss in `ZellKoordinaten` (`bestandslog_document.hpp:147-157`, heute nur `{combo,opt,simd}`), sonst kollidieren GPU- und CPU-only-Binary derselben Perm auf EINEM `LagerKey`. Wenn das Bestandslog fuer Voll-Bau-4 wie beschlossen AUS bleibt (P-2), ist das kein Vor-Trigger-Thema. Bestaetigung, dass AUS gilt?

**Q-13 — `telemetry` in der neuen Sortierung?** `telemetry` ist heute System-Achse **ohne** CebSystemAxis-Typ (nur Organ-Registry-Reflexion `registry_to_axis_levels.hpp:119` + Suffix-Token `+tel=silent`). Soll sie (i) in STRUKT-R einen echten CebSystemAxis-Typ und einen Platz in `kSystemAxisOrder` bekommen, (ii) unveraendert als Sonderfall bleiben (EMPFEHLUNG fuer dieses Fenster)? Achtung: (i) beruehrt `test_br1_full22_count.cpp:60-65` (5 System-Levels).

**Q-14 — Modus-Registry: neue Achsen-Sichtbarkeit.** Die Ablaufmethodik ist heute per Invariante **nie** im Stempel (`anatomy_version_stamp.hpp:89`, `anatomy_module_abi_v1_decl.hpp:154`). CUSTOM_COMPILE aendert daran nichts — Bestaetigung, dass diese Invariante bestehen bleibt (sonst waere CUSTOM_COMPILE binary-identitaets-relevant und muesste VOR den Trigger).

---

## 5. WAS NICHT VOR VOLL-BAU-4 MUSS (ehrliche Abgrenzung)

Kriterium: **beruehrt es die Bytes eines Tier-Binary, seiner `.version` oder seines Objekt-Store-Keys?** Wenn nein, darf es nach dem Trigger in das Arbeitsfenster der Bau-Laufzeit.

| Block | Warum verzichtbar (Beleg) | Preis des Verschiebens |
|---|---|---|
| **E PLAN-ND** (Planer 2D `opt x simd` -> N-dimensional, `experiment_plan_director.hpp:139-151,1768-1800` + 7 `system_perm`-Aufrufe + 3 Emitter-Backends) | Die `build_version` entsteht in der Facade, nicht im Planer; Voll-Bau-4 faehrt die **statische** CI-Matrix `.gitlab-ci.yml:1048-1076` (`GN_OPT`/`GN_SIMD`), nicht die Director-Emission. Kein Byte-Bezug. | `plan_legend.hpp:103` bleibt vorlaeufig semantisch falsch (`opt` als Unter-Achse in der Haupt-Legende, §42.b-Verstoss). Reine Plan-Ausgabe, keine Messung. |
| **C2' Identitaets-Scharfschaltung** (`simd_build_gate.hpp:187` Stub) | inert; Scharfschalten kann `march`-Flags aendern = Byte-Risiko **kurz vor** dem Bau (Q-11) | Gate bleibt ein Fenster laenger blind (Ist-Zustand seit Bau-Beginn) |
| **D2 Modus-Vollzug** (4. Feld `emits_measure_job` in `PlanBuildSemantic`, Mess-Job-Entfall an `experiment_plan_director.hpp:1070-1119,1475`, Kopplung `provision_only`/`pruef_only` aus der Methodik, `--custom-compile` im CLI) | Modus ist per Invariante **nie** im Stempel (`anatomy_version_stamp.hpp:89`); `Code/02_messung_driver/main.cpp` ist ohnehin G4b-1-gesperrt (N-6) | CUSTOM_COMPILE bleibt bis dahin Etikett ohne Vollzug (Registry-Eintrag vorhanden, Wirkung nicht) — muss so **benannt** werden, kein Erfolgs-Haken |
| **A-IV Parser/XSD-Vollausbau** (`parse_system_axes`-Signatur, `OperatingSystemAxisSel`, Gruppen-POD, `xs:all`) | Nur noetig, wenn Profile OS-/scheduling-**Werte** deklarieren. Mit "weglassbar bei Default" bleibt der Voll-Bau ohne diese Werte vollstaendig beschreibbar | OS-Achse ist bis dahin registry-sichtbar, aber nicht profil-waehlbar |
| **G Lager-Baeume + xlsx** (Ordner-Kaskaden je Achsen-Typ, Messdaten-/Binaries-Baum, xlsx-Writer, INFO-Sheet, Factory je Sheet) | Session-Doc §7 sagt es selbst: "Design jetzt fix, Vollausbau im #46b-/vor-01.08.-Paket". CSV-Fallback traegt Voll-Bau-4 | Mess-Ergebnisse landen ein Fenster laenger im flachen Prototyp-Layout |
| **Q-7 (i) scheduling-Options-Familie**, Adapter/Set/Sequence/View-Ausdehnung (Q-8), `disk_writeback`-Echt-Implementierung | additive Erweiterungen im bestehenden Raum, keine Identitaets-Aenderung (bei Q-1=false) | spaetere Aufschaltung per `option()` ohne Neubau moeglich |

**Was UNVERZICHTBAR vor dem Trigger ist (und warum genau):**
1. **B ORG-18 vollstaendig** — binary_id 17->18, POD-sizeof/Version, ABI-Major, CSV 160->169, golden-CRC. Spaeter = kompletter Neubau.
2. **A-I/A-II/A-III/A-V/A-VI** (Typ-Schicht + Ordnungs-Single-Source + Stempel + Generator/XML + Validat-Compile-Zwang + Test-Anker) — der System-Stempel geht in den **generierten AdHoc-Quelltext** (`lazy_adhoc_source_gen.hpp:199-201`) und ist damit byte-relevant fuer JEDE Tier-Binary. Spaeter = zweiter Voll-Bau.
3. **A-VII + F** (Suffix/Key-Single-Source in neuer Ordnung) — `.version`-Sidecar und minio-Key. Spaeter = jede Binary erneut invalidiert.
4. **`operating_system` als Stempel-Zeile** — auch wenn keine Werte deklariert werden: eine spaetere Aufnahme in die Stempel-Tabelle bricht die Bytes erneut.

---

**SELBSTCHECK:** `grep -P '[^\x00-\x7F]'` auf diesen Bericht = 0 Treffer ausser `§` (per Direktive erlaubt). Read-only: keine Datei im Repo geaendert (nur Read/grep/sed/ls/wc/git status). Session-Doc `docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md` vollstaendig gelesen (119/119 Zeilen). Alle Zeilennummern stammen aus den 3 Kartierungen bzw. aus eigener Live-Lesung (N-1..N-7 mit Werkzeug-Output belegt); keine Zahl geraten. Kein Erfolgs-Haken ohne literale Ausgabe gesetzt. G4b-1-Sperr-Menge gegen jeden Lane-Datei-Besitz geprueft: 0 Ueberlapp in A/B/C/D, vollstaendiger Ueberlapp in F -> F als seriell ausgewiesen.