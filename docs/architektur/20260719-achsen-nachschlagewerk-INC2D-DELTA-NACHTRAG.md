# ACHSEN-NACHSCHLAGEWERK — INC-2d-DELTA-NACHTRAG (2026-07-19)

> ---
>
> ## ⚠️ STAND 2026-08-07: AUCH DIESER NACHTRAG IST UEBERHOLT -- ZWEI ABI-MAJORS
>
> **Dieser Nachtrag hob das Original von ABI-5/18-Slots auf ABI-6/17-Slots. Seither ist zweimal
> weitergezogen worden: ABI-7 (STRUKT-R ORG-18) und ABI-8 (E-24 C8).** Wer Original plus Nachtrag
> liest, hat damit **immer noch nicht** den Ist-Stand. Das ist die gefaehrlichste Eigenschaft dieses
> Dokuments: es sieht wie die Korrektur aus, ist aber selbst korrekturbeduerftig. Belege gegen ce
> `ba069e38` (identisch in `ab0b352e`).
>
> **Was an diesem Nachtrag NICHT zu beanstanden ist.** Seine Delta-Notation ist gesund und bleibt
> stehen: wo er schreibt „18x8 sizeof 1344 V6 ABI-5 → 17x8 sizeof 1272 V7 ABI-6" (`:98`), nennt er
> einen **Zeitschnitt**, keinen Ist-Zustand. Solche Zeilen sind der historische Wert des Dossiers
> und **nicht** zu korrigieren. Der Vermerk unten richtet sich ausschliesslich gegen drei andere
> Textsorten, die als *heute geltend* gelesen werden:
> - **die Vorrang-Regel `:7`** („Bei Widerspruch gilt der Nachtrag") -- sie erklaert den ABI-6-Stand
>   zur massgeblichen Fassung und ist damit die Zeile, die den Fehlbefund traegt;
> - **die als OFFEN gefuehrten Audit-Posten** (`:102` L4/G8==P2, `:111` Quick-Win L3, `:150` V7/P4,
>   `:11` G2/E-4) -- sie sind Gate-Bedingungen im Praesens und **alle vier inzwischen erledigt**;
> - **der CRC64-Anker `:138`/`:166`**, als Tatsache formuliert und inzwischen gewandert.
>
> ### Der Kopf `:5` und die Kern-Ereignisse `:10-15`
>
> | Angabe | Ist-Stand 07.08. | Beleg (ce) |
> |---|---|---|
> | `:5` „auf den Stand **ABI-6, 17 Slots**" | **ABI-8, 18 Slots** | `abi/anatomy_module_abi_v1_decl.hpp:89`; `builder/experiment_tree/axis_path_serialization.hpp:40` |
> | `:5` „live gegen ce HEAD `5da2caf7` verifiziert" | Verifikationsbasis ueberholt; ebenso der `a9c433d0`-Block in §G (`:210`, `:229`) -- **alle dort „woertlich bestaetigten" ABI-6/17-Anker sind heute falsch** | -- |
> | `:10` „isa verliess die Komposition (**18→17** Organ-Slots)" | isa ist weiterhin raus (**korrekt**), aber die Kette ging weiter: **17→18**, `persistence_target` kam als T17 dazu | `axis_path_serialization.hpp:40-43` |
> | `:14` „`FullSourceCatalog` = alle **17** Achsen je 2 = 2^17 = 131.072" | **Der Wert 131.072 stimmt.** Die Formulierung nicht: `CatalogAxes` hat **18** Parameter, K17 (`persistence_target`) ist auf **1 gepinnt** → 2^17 x 1 | `profile_facade/source_catalog.hpp:139`, `:135-138` |
> | `:11` „Der aktive Familien-Knoten `axis_label()=="extension_hardware"` **FEHLT** (Audit G2/E-4 offen)" | **GESCHLOSSEN -- zweifach.** (1) Der Knoten existiert: `measurement/external_utils_family_axis.hpp`. (2) Er heisst nach dem A2-Rename **`external_utils`**, und `SimdSubAxis::parent_axis_label()` liefert genau das | `external_utils_family_axis.hpp:1`; `simd_sub_axis.hpp:38` |
>
> ### Die Zahlen im Fliesstext
>
> | Zeile | steht im Nachtrag | Ist heute | Beleg (ce) |
> |---|---|---|---|
> | `:24` | `std::array<std::string_view, **17**>` | `<…, **18**>` | `axis_path_serialization.hpp:40` |
> | `:26`, `:97`, `:148` | Genus-Counts „**17**-11-13-9-5" | **18**-11-13-9-5 (nur SA bewegt sich) | `genus_binding_traits.hpp:48`, `:74`, `:102`, `:132`, `:160` |
> | `:30`, `:110`, `:111` | „**17x8**, sizeof **1272**, Version **7**, ABI-**6**, Magic `.A6.`" | **18x8**, sizeof **1344**, Version **8**, ABI-**8**, Magic `.A8.` = `0x434F4D444141382E` | `observable_tier.hpp:50`, `:168`, `:174`; `anatomy_module_abi_v1_decl.hpp:89`, `:93` |
> | `:42` | „NUR die **17** Organ-Achsen permutieren" | **18** | `axis_path_serialization.hpp:40` |
> | `:52` | „`kCebContractCodegenMinor` (**=0**)" | **= 1** → `+ceb=8.1` | `anatomy_module_abi_v1_decl.hpp:460` |
> | `:60` | „`static_assert sizeof...==17`; `kV3AxisCount=17`" | **==18**; **=18** | `composition_factory.hpp:104`; `observable_tier.hpp:50` |
> | `:132` | „`CatalogAxes` ueber alle 17 Achsen (**K00..K16**)" | **K00..K17** (18 Parameter) | `source_catalog.hpp:91-93` |
> | `:138`, `:166` | CRC64-Anker `kNewGolden131072Crc64` = **`0xF1C1F26A1232073B`** | **`0x56F1B721C72DC10E`**. Der alte Wert steht im Code noch als dokumentierter `[MISMATCH]` -- das ist der Beweis, dass er ueberholt ist | `source_catalog.hpp:190`, MISMATCH-Zeile `:187` |
> | `:145` | „axes26 bleibt **26** Aliasse" | **27** (`T26_persistence_target` kam dazu) | `registry_to_axis_levels.hpp:47-82` |
> | `:146` | „**16 vs 17 vs 8** NIE verwechseln" | **16 vs 18 vs 8** | `observable_tier.hpp:50`, `:53` |
> | `:147` | „(B) Jetzt **DOPPEL**-Shift 19→18→17" | **DREIFACH: 19→18→17→18** | `observable_tier.hpp:45-49` |
>
> ### Die Slot-Tabelle `:64-82`
>
> **T0..T16 stimmen alle** -- Namen, Reihenfolge und golden-Pins. Es fehlt genau eine Zeile:
> **T17 `persistence_target`**, gepinnt auf `persistence_memory_only`
> (`axis_path_serialization.hpp:43`; `algorithm_profiles/cache_engine_axis_registry.xml:125`).
> Entsprechend gilt `grep -c "<axis " == 18`, nicht 17 wie in `:122` behauptet -- die beiden dort
> genannten Einzel-Anker (`index_organization slot="T11"` Z.77, `io_dispatch slot="T12"` Z.83) sind
> dagegen **woertlich weiterhin richtig**.
>
> ### Als ERLEDIGT zu markierende Audit-Posten
>
> - `:102` „stale `k*SlotCount` … **alle bestehen unveraendert**; AKTIVER stale `static_assert`
>   `tests/unit/test_d9_set.cpp:38` (15). **Audit L4/G8==P2 OFFEN**" -- **ERLEDIGT.** Set = 13
>   (`set_composition.hpp:62`), Sequence = 9 (`:69`), View = 5 (`view_composition.hpp:77`);
>   `test_d9_set.cpp:38` steht auf 13 und bindet zusaetzlich gegen `SC::slot_count` (`:40-41`).
>   Nur Adapter = 13 bleibt **bewusst** frozen (`adapter_anatomy.hpp:200`).
> - `:111` „der geforderte `static_assert(sizeof==1272)` **fehlt noch = Quick-Win L3 offen**"
>   -- **ERLEDIGT**, mit dem Ist-Wert: `static_assert(sizeof(...) == 1344)`, `observable_tier.hpp:168`.
> - `:150` „Rename `all_axes_binary_count`→`all_axes_matrix_count` = **Audit V7/P4 OFFEN**"
>   -- **ERLEDIGT** (`registry_to_axis_levels.hpp:191`).
> - `:139` Aufrufer-Frage zu `build_system_axis_levels()` -- Aufrufer ist `build_all_axis_levels()`
>   (`registry_to_axis_levels.hpp:178`).
>
> **Weiterhin korrekt (nicht anfassen):** isa ohne Organ-Slot (`:86`) · `build_system_axis_levels()`
> = 5 Achsen (`:31`) · Adapter/Set/Sequence/View = 11/13/9/5 (`:98-101`) · `kV3FieldCount` = 8
> (`:196`) · Mess-Kategorien 16 · 13 gepinnte Slots im golden-320 (`:133`) · der Wert 131.072 ·
> die flache `ExtensionHardwareSystemAxis` bleibt deprecated, nicht geloescht (`:50`, `:124`) ·
> die Existenz von `TargetIsaSystemAxis`, `OptimizationLevelSubAxis`, `CompilerAtomicSubAxis`,
> `artifact_cache.hpp`.
>
> ---

## (A) Kopf

**Zweck.** Dieser Nachtrag hebt das Nachschlagewerk `20260717-achsen-nachschlagewerk-ACHSEN-NACHSCHLAGEWERK.md` (Stand INC-2c, 18 Slots, ABI-5) auf den Stand **INC-2d + #50 + #51 + F-SIMD-DEPRECATED (ABI-6, 17 Slots)**. Das Original bleibt UNVERÄNDERT als historische Referenz des INC-2c-Standes (Doku-nie-löschen); dieses Dokument ist ADDITIV und führt NUR die überholten bzw. neuen Zeilen. **Jede Delta-Zeile ist live gegen ce HEAD `5da2caf7` verifiziert** (2026-07-19; `git log`: `5da2caf7` #51-iostream-Fix, `f1562636` #50-algo_version-Weiterleitung).

**Lese-Reihenfolge:** Original (Struktur + unveränderte Sektionen) → dieser Nachtrag (Deltas + Neues). Bei Widerspruch gilt der Nachtrag.

**Kern-Ereignisse seit dem Original (alle live verifiziert):**
1. **INC-2d (ABI 5→6):** `isa` verließ die binary_id-Komposition (18→17 Organ-Slots); NEU build-treibende System-Achse `TargetIsaSystemAxis` (+target=-Sidecar). Alt-golden als `..._abi5.txt` additiv eingefroren.
2. **F-SIMD:** die flache `ExtensionHardwareSystemAxis` ist DEPRECATED; konforme Struktur = `extension_hardware` (Haupt) → `simd` (SimdSubAxis) → Optionen. Der aktive Familien-Knoten mit `axis_label()=="extension_hardware"` FEHLT (Audit G2/E-4 offen).
3. **#50 inkrementeller Tier-Binary-Cache:** Pflicht-`algo_version` je Organ-Variante (Concept-erzwungen) + `perm.algos`-Sidecar (Organ-Provenienz, strikt getrennt von `.version`).
4. **#51 artifact_cache:** MinIO-Binary-Cache + measure-drop-Senke (inert-by-default, env-getrieben).
5. **NEW-GOLDEN-ALL-AXES:** `FullSourceCatalog` = alle 17 Achsen je 2 = 2^17 = 131.072 (Referenz + CRC64-Anker); die alte 320-Semantik heißt jetzt `golden_320_catalog`.
6. **opt-g/2c.opt:** opt_level ist GEBAUT (`OptimizationLevelSubAxis`, Default O3) + im Sidecar/`+opt=` und in der Planer-Dock-Permutation opt×simd verdrahtet.

---

## (B) NEUE Gesamt-Zählung je Ebene (kanonisch, INC-2d)

| Ebene | Kanon-Zahl (ALT → NEU) | Bestandteile | Beleg (live) |
|---|---|---|---|
| System-Konfig (CEB) | **6 → 7** Haupt (+3 Wurzeln) | Scheduling · Hardware/ISA (Host-Deskriptor, `axis_label=="hardware"`) · Telemetrie · Last/Frameworks · Compiler · Erweiterungshardware (6., Familien-Knoten G2-offen) · **Target-ISA (7., NEU)**. TargetIsa zählt ADDITIV als 7. — sie ERSETZT NICHTS: HardwareIsa bleibt Host-Deskriptor (`hardware_isa_system_axis.hpp:21`), extension_hardware bleibt die 6. (`simd_sub_axis.hpp:5` „Haupt-System-Achse, 6."), target_isa = „eigene Haupt-System-Achse" (`target_isa_system_axis.hpp:29-33`) | `target_isa_system_axis.hpp:33-34` |
| Organ / Komposition | **18 → 17** (T0..T16) | binary_id-permutierend, `kCompositionAxisNames` = `std::array<std::string_view, 17>` | `axis_path_serialization.hpp:34-37` |
| Gattung Ebene-1 / Ebene-2 | **3 / 5 (unverändert)** | SearchAlgorithm·Container·Graph / SA·Set·Sequence·Adapter·View | geprüft, unverändert |
| Genus-Slot-Counts (struct-intern) | **18-12-14-10-6 → 17-11-13-9-5** | SA=17 · Adapter=11 · Set=13 · Sequence=9 · View=5 | `genus_binding_traits.hpp:39/63/88/115/140` (jetzt unter `builder/experiment_tree/`) |
| Mess-Dimensionen | **3 (unverändert)** | D1/D2/D3 | geprüft, unverändert |
| Mess-Kategorien | **16 (unverändert, verifiziert)** | 9 TimeObserver + 7 PmcCounter | `measurement_category.hpp:32` (`kMeasurementCategoryCount = 16`) |
| System-Mess-Kollektoren | **3 (unverändert, verifiziert)** | WallClock/ObserverSnapshot/Pmc | `system_axis.hpp:196/242/287` |
| Observer-POD | **18×8 sizeof 1344 V6 ABI-5 → 17×8 sizeof 1272 V7 ABI-6** | `kV3AxisCount=17`; `axis_stats[17][8]` + `seg_ns[17]`; Magic `.A5.`→`.A6.` | `observable_tier.hpp:49/129-130/153-154`; `anatomy_module_abi_v1_decl.hpp:54-58` (`COMDARE_ANATOMY_ABI_MAJOR 6`, Magic `0x434F4D444141362E`) |
| Build-/System-Schicht (nicht binary_id) | **7 → 9** | `build_system_axis_levels()` jetzt **5** (page_type · simd_extension(09b) · general_hardware(12) · telemetry · **isa NEU**) + 4 node-shapes (btree/skip/bst/hash) | `registry_to_axis_levels.hpp:113-122` (isa-push `:120`) |

---

## (C) Sektion-für-Sektion-Delta

### C.0 — Sektion (0) Kopf

| Original-Zeile (Anker) | ALT | NEU (live-verifiziert) |
|---|---|---|
| „Stand INC-2c" (Absatz) | Organ 19→18, ABI 4→5, POD V5→6, sizeof 1416→1344 | INC-2d: Organ **18→17** (isa raus), ABI **5→6**, POD-Version **6→7**, sizeof **1344→1272** (−72); `observable_tier.hpp:125-126,153-154`; `anatomy_module_abi_v1_decl.hpp:49-58` |
| „binary_id-Disziplin" (Lesehinweis) | „NUR die 18 Organ-Achsen permutieren" | NUR die **17** Organ-Achsen permutieren; isa-Provenienz = `+target=`-Sidecar (nur bei Cross-Compile emittiert), `profile_run_facade.cpp:307-311` |
| Gesamt-Zählungstabelle | s. Original | KOMPLETT ersetzt durch Tabelle (B) oben |

### C.1 — Sektion (1) System-Achsen

| Original-Zeile (1a/1b) | ALT | NEU (live-verifiziert) |
|---|---|---|
| Intro §1 | „Nur Erweiterungshardware ist bau-treibend" | Bau-treibend sind jetzt: Erweiterungshardware (march-Flags), Compiler (opt_level-/atomic128-Flags), **Target-ISA** (Cross-Flags `-target`/`-march` an `make_gpp_compile_fn`-Naht); `target_isa_system_axis.hpp:12-16` |
| 1a „Erweiterungshardware — `ExtensionHardwareSystemAxis` (6.)" | gebaut + verdrahtet (+ext=) | Die FLACHE `ExtensionHardwareSystemAxis` ist **DEPRECATED (F-SIMD, 2026-07-18)**; keine aktiven Consumer mehr (Parser/opt-g-Facade/Validate nutzen `SimdSubAxis`); nur `test_striktheit_axis_dach_guard` Block F hält sie kompilierbar; nicht löschen (user-gated); `extension_hardware_system_axis.hpp:4-10`. **Aktiver Familien-Knoten mit `axis_label()=="extension_hardware"` FEHLT** — einzige Klasse mit dem Label ist die deprecated (`:33`); `SimdSubAxis::parent_axis_label()=="extension_hardware"` (`simd_sub_axis.hpp:37`) zeigt auf diesen **verwaisten** Knoten → **Audit G2/E-4 OFFEN** (`docs/audits/20260718-konformitaets-audit-9dim-REPORT.md:31,98,118`; `20260719-...-REGISTER.md:50,166`) |
| 1a — (NEUE ZEILE, 7. Achse) | — | **Target-ISA — `TargetIsaSystemAxis`** (label `target_isa`): Ausprägungen `X86_64TargetIsa` (native, keine Cross-Flags, Default) / `Aarch64TargetIsa` (`-target aarch64-linux-gnu`, `-march=armv8-a`); `kAllTargetIsaIds` (2); Flags → CompileFn (`perm_target_isa_cflags`), Provenienz `+target=<ziel>` NUR bei Ziel≠Host; env-Smoke-Schalter `COMDARE_PILOT_TARGET_ISA` (`profile_run_facade.cpp:148-152`); echter aarch64-Lauf = Toolchain-Handover; binary_id? NEIN; `target_isa_system_axis.hpp:29-97` |
| 1a `system_axes_version_suffix` (H-10-Träger) | `"+ext=<policy>+cxx=<driver>"`; +opt= geplant | **`"+ext=<policy>+cxx=<driver>+opt=<level>+ceb=<ABI-Major>.<CodegenMinor>[+target=<ziel>]"`** — +opt IMMER emittiert (kein O2-Sonderfall, A1/OF-2-Ruling), Default `+opt=O3`; `+ceb=` = `COMDARE_ANATOMY_ABI_MAJOR` + `kCebContractCodegenMinor` (=0, `anatomy_module_abi_v1_decl.hpp:144`); `+target=` nur bei Cross; `profile_run_facade.cpp:293-313` |
| 1b „opt-level (dyn. XML-Unterachse)" | 5: O0..Ofast, **geplant** (INC-2c.opt) | **GEBAUT + verdrahtet**: `OptimizationLevelSubAxis` (label `opt_level`, `parent_axis_label()=="compiler"`), Optionen `OptO0/O1/O2/O3/OfastOption`, `kAllOptLevelIds` (5), `DefaultOptLevelOption = OptO3Option` (Ruling 2026-07-18 Option B, IEEE-754-deterministisch); env `COMDARE_PILOT_OPT_LEVEL`; `optimization_level_sub_axis.hpp:37/41/101/128/133/142-143` + Facade `profile_run_facade.cpp:252-289` |
| 1b `simd_extension_id`/`gcc_march_flag`/`clang_march_flag` (Quelle flache Achse) | `extension_hardware_system_axis.hpp:28/32/33` | Quelle jetzt **`SimdSubAxis`-Optionen** (`SimdNoExtOption`/`SimdAvx2Option`/`SimdAvx512Option`; zusätzlich `msvc_march_flag`); label `simd`, parent `extension_hardware`; `simd_sub_axis.hpp:34-96` (Optionen `:68-90`); alte flache Zeilen = deprecated |
| 1b „Flags (je Compiler)" | geplant (LEDGER:430 F3i) | teilweise GEBAUT: **`CompilerAtomicSubAxis`** (label `atomic128`, parent `compiler`, `Cx16Option` u.a.) als erste gebaute Flag-Unter-Achse; `compiler_atomic_sub_axis.hpp:7/38/42/97-98`; Rest (freie Flags/Commands) weiter geplant |
| 1a Telemetrie (Quelle) | `registry_to_axis_levels.hpp:110-118` | Zeilen-Shift: telemetry-push jetzt `registry_to_axis_levels.hpp:119` (isa `:120` dahinter) |

### C.2 — Sektion (2) Organ-Achsen: die NEUE T0..T16-Slot-Tabelle

Header-Absatz NEU: Autoritative Reihenfolge = `kCompositionAxisNames` `std::array<…,17>` (`axis_path_serialization.hpp:34-37`); AdHocComposition `static_assert sizeof...==17` (`composition_factory.hpp:97-98`); Observer-POD `kV3AxisSchema[kV3AxisCount]`, `kV3AxisCount=17` (`observable_tier.hpp:49/68`).

**Slot-Shift:** T0–T10 unverändert; alter Slot T11 (isa) ENTFERNT; alle alten Slots ≥T12 um −1 verschoben. Ausprägungen/Observer-Felder/golden-Pins der verbleibenden Achsen UNVERÄNDERT (nur Slot-Nummer + kV3AxisSchema-Index):

| NEU T | Achse | ALT T | golden-Faktor | Beleg Slot-Reihenfolge |
|---|---|---|---|---|
| T0 | search_algo | T0 | ×4 FREI | `axis_path_serialization.hpp:35` |
| T1 | cache_traversal | T1 | ×1 `linear_fanout` | ebd. |
| T2 | mapping | T2 | ×1 `direct_placement` | ebd. |
| T3 | path_compression | T3 | ×1 `path_compression_none` | ebd. |
| T4 | node_type | T4 | ×4 FREI | ebd. |
| T5 | memory_layout | T5 | ×5 FREI | `axis_path_serialization.hpp:35-36` |
| T6 | allocator | T6 | ×1 `std_malloc` | ebd. |
| T7 | prefetch | T7 | ×4 FREI | ebd. |
| T8 | concurrency | T8 | ×1 `concurrency_none` | ebd. |
| T9 | serialization | T9 | ×1 `serialization_raw_binary` | ebd. |
| T10 | value_handle | T10 | ×1 `value_handle_inline` | `axis_path_serialization.hpp:36` |
| **T11** | **index_organization** | T12 | ×1 `index_org_heap` | ebd. |
| **T12** | **io_dispatch** | T13 | ×1 `io_in_memory_only` | `axis_path_serialization.hpp:37` |
| **T13** | **migration_policy** | T14 | ×1 `migration_none` | ebd. |
| **T14** | **filter** | T15 | ×1 `filter_bloom` | ebd. |
| **T15** | **queuing_q1** | T16 | ×1 `no_buffer` | ebd. |
| **T16** | **queuing_q2** | T17 | ×1 `eager_flush` | ebd. |

| Original-Zeile | ALT | NEU (live-verifiziert) |
|---|---|---|
| T11 isa (Slot-Zeile) | Organ-Slot T11, ×1 gepinnt `isa_amd64` | **KEIN Slot mehr.** isa-ORGAN-Typ (Amd64Isa/ObservableIsa, axis_09) bleibt **Codegen-Träger** (telemetry-treu); Selektion wandert von der binary_id-Permutation zur build-config-Achse Target-ISA; isa steht jetzt in `build_system_axis_levels()` (`registry_to_axis_levels.hpp:120`); Doku-Kommentar `axis_path_serialization.hpp:28-30` |
| Organ-Sub-Achsen-Tabelle: `simd_extension`/`general_hardware` (Parent isa) | Parent = isa (Organ-Slot) | Parent-Achse isa ist selbst System-seitig; die beiden bleiben build-only in `build_system_axis_levels()` (`:117/:118`); zusätzlich NEUE Zeile analog telemetry: **isa (ex-T11, herausgelöst)** — 4 Varianten (Amd64/Aarch64/RiscV/PowerPc), INC-2d: KEIN Slot mehr → System-Achse target_isa |
| Varianten-Summe | „18 Komposition-Achsen (All): 127 Strategien" | **17 Komposition-Achsen (All): 123 Strategien** (127 − 4 isa-Varianten; isa-4 zählen jetzt System-seitig) |
| `all_axes_binary_count()`-Satz | über Enabled, Z.145-159 | Formel besteht UNVERÄNDERT als 26er-Produkt inkl. `T10_telemetry` **UND** `T12_isa` (`registry_to_axis_levels.hpp:147-161`, isa `:154`) — s. Falle I (verschärft) |

### C.3 — Sektion (3) Gattungs-Matrix

Quelle `genus_binding_traits.hpp` liegt jetzt unter `builder/experiment_tree/` (Umzug #45 A2-Neben).

| Original-Zeile | ALT | NEU (live-verifiziert) |
|---|---|---|
| SearchAlgorithm slot_count | 18 (T0..T17) | **17** (T0..T16); `axis_names()` = direkt `kCompositionAxisNames` (17); `builder/experiment_tree/genus_binding_traits.hpp:39/49-50` |
| Adapter slot_count | 12 | **11** (10 geteilt/delegiert + inner_container); `genus_binding_traits.hpp:63` + `adapter_anatomy.hpp:129`; Achsen-Satz OHNE isa. ⚠ stale Zusatz-Kommentar `adapter_anatomy.hpp:168` sagt noch „// 12" |
| Set slot_count | 14 | **13**; `genus_binding_traits.hpp:88` + `set_composition.hpp:34`; Satz OHNE isa |
| Sequence slot_count | 10 | **9** (8 geteilte + growth_policy); `genus_binding_traits.hpp:115` + `sequence_composition.hpp:45`; Satz OHNE isa |
| View slot_count | 6 | **5** (2 geteilt + extent/layout/accessor); `genus_binding_traits.hpp:140` + `view_composition.hpp:55`; Satz OHNE memory_layout-Partner isa |
| ⚠ Stale-k*SlotCount-Warnung | „+1 telemetry" | Diff jetzt **+2 (telemetry + isa)**: `kSetCompositionSlotCount=15` (`set_composition.hpp:59`) · `kSequenceCompositionSlotCount=11` (`sequence_composition.hpp:65`) · `kViewCompositionSlotCount=7` (`view_composition.hpp:71`) · `kAdapterCompositionSlotCount=13` („frozen legacy §28-Count", `adapter_anatomy.hpp:151`) — alle bestehen unverändert; zusätzlich AKTIVER stale `static_assert` `tests/unit/test_d9_set.cpp:38` (15). **Audit L4/G8==P2 OFFEN** (Slot-Zahlen-Sweep 19/18/15/11/7→17/13/9/5; Session-Handover 2026-07-19 §5). Belastbar NUR struct-internes `slot_count` + `axis_names().size()` (**17/11/13/9/5**) |

Genus-eigene Achsen + BUILD/SHAPE-Tabelle: GEPRÜFT-UNVERÄNDERT (nur: simd_extension-Zeile bezieht ihr CEB-Gegenstück jetzt aus SimdSubAxis, s. C.1).

### C.4 — Sektion (4) Mess-Achsen

| Original-Zeile | ALT | NEU (live-verifiziert) |
|---|---|---|
| D2 Per-Achsen-Observer | `axis_stats[18][8]` | `axis_stats[17][8]` + `seg_ns[17]`; `observable_tier.hpp:129-130` |
| ComdareTierObserverSnapshot | kV3AxisCount=18, Version 6, sizeof 1344 | **kV3AxisCount=17** (`:49`), **Version 7** (`kTierObserverSnapshotVersionUnified=7`, `:153-154`), **sizeof 1272** (Kommentar `:125-126`; ⚠ der geforderte `static_assert(sizeof==1272)` fehlt noch = Quick-Win L3 offen, nur standard_layout/trivially_copyable-Asserts `:146-148`) |
| kV3AxisSchema | 18 Achsen × ≤8 Felder | **17** Achsen × ≤8 Felder (`:68-101`); isa-Zeile (simd_calls/…) ENTFERNT; Indizes ab value_handle-Nachfolger −1 (`:88`); `kV3FilledAxisCount` wird jetzt aus dem Schema ABGELEITET statt hartkodiert (`v3_count_filled_axes()`, `:106-113`) |

Alle übrigen §4-Zeilen (Mess-Dimensionen, Pfade A/B, 3 Profile, 16 Kategorien, Perzentile, Granularität, Reihen, Workload, W/D/K, DynamicDims, PmcCounters, kMeasurementAxisRegistry, Kollektoren): GEPRÜFT-UNVERÄNDERT (`measurement_category.hpp:32` =16; `system_axis.hpp:196/242/287` =3 Kollektoren).

> **§47/§54-T2-VERWEIS (2026-07-20, A10, additiv):** Die Mess-Achsen-Rollen sind architektur-kanonisch Haupt/Unter geteilt — **HAUPT = Mess-Tooling {Wallclock/Makro/Micro}**, **UNTER = Ablaufmethodik + Workloads/Datasets + 16 measurement_categories + Rückschrieb-Methoden** (manifestieren sich als CSV-Spalten). Siehe den §47/§54-T2-Sektions-Nachtrag am Kopf der Mess-Sektion in NW1 (`20260717-achsen-nachschlagewerk-ACHSEN-NACHSCHLAGEWERK.md`, „(4) MESS-ACHSEN") sowie Ledger §47/§28.

### C.5 — Sektion (5) Compile-/Registry-XML-Achsen

| Original-Zeile | ALT | NEU (live-verifiziert) |
|---|---|---|
| **cache_engine_axis_registry.xml** | „18 Achsen T00-T17 … JA (GENERIERT, live golden) … gebaut" | **REGENERIERT (VERIFIKATIONS-KORREKTUR 2026-07-19):** ce `a9c433d0` („INC-2d-Nachzug-Verbund — Registry-Regen 18→17", direkt nach `5da2caf7`, jetzt HEAD) hat die XML auf **17 Achsen T00-T16 OHNE isa** regeneriert (verifiziert: `grep -c "<axis " == 17`, kein `id="isa"`, `index_organization slot="T11"` Z.77, `io_dispatch slot="T12"` Z.83). Die frühere Fassung dieses Nachtrags meldete zur Basis `5da2caf7` korrekt „STALE: 18 inkl. isa T11 Z.77-82" (so bei `git show 5fe811db:…xml` belegbar) — das ist ÜBERHOLT. Das string-ID-System bleibt kanonisch (§27), und die Falle-B-Anweisung des Originals („immer Registry-XML als Ist nehmen") gilt wieder NORMAL: XML = Ist = Code (17) |
| 15.2 Optimization-Level | parsed, „geplant (INC-2c.opt)" | **GEBAUT**: `OptimizationLevelSubAxis` + `+opt=`-Sidecar + opt×simd-Planer-Dock-Permutation (s. C.1/C.6) |
| ExtensionHardwareSystemAxis (IST -march/15.5) | „gebaut, JA (+ext=)" | Flache Achse **DEPRECATED (F-SIMD)**; +ext=-Fluss läuft über `SimdSubAxis`-Optionen; Familien-Knoten G2-offen (s. C.1) |

Übrige §5-Zeilen (permutation_axes.xml Legacy-11, AxisLibraryRegistry 1-14, 15.1/15.3/15.4/15.5, simd_extension 09b, page_type PG1-PG3, cacheline, messreihe_v32-Familie, comdare_experiment, CompilerSystemAxis, CebSystemAxis): GEPRÜFT-UNVERÄNDERT (inkl. „Compiler-Achse ⊃ Unterachsen"-Ruling — durch OptimizationLevelSubAxis/CompilerAtomicSubAxis jetzt teilweise MATERIALISIERT).

### C.6 — Sektion (6) Abhängigkeits-Übersicht

| Original-Zeile | ALT | NEU (live-verifiziert) |
|---|---|---|
| golden-Faktoren-Kopf | „`FullSourceCatalog = CatalogAxes<4,4,5,4> = 320`" | **UMGEBAUT (NEW-GOLDEN-ALL-AXES):** `CatalogAxes` ist jetzt über ALLE 17 Achsen parametrisiert (`K00..K16`, `source_catalog.hpp:90-118`). **`FullSourceCatalog = CatalogAxes<2,…,2> = 2^17 = 131.072`** (`:126`, `static_assert :155-156`) = Ganz-System-Regressions-Detektor (REFERENZ, lazy, NIE materialisiert). Die alte 320-Semantik heißt jetzt **`golden_320_catalog = CatalogAxes<4,1,1,1,4,5,1,4,1,…,1> = 320`** (`:130`, `static_assert :157-158`). `SmallSourceCatalog` = 2·2 = 4 (`:134`). Materialisierter Bau-/Mess-Katalog bleibt 320/kuratiert (`GeneratedFullSourceCatalog`/catalog_codegen.cmake) |
| Gepinnt-Liste | „die übrigen **14** Komposition-Slots gepinnt … isa=isa_amd64 …" | die übrigen **13** Slots gepinnt — **isa=isa_amd64 entfällt** (kein Slot); Rest wortgleich. Verifiziert gegen aktives `golden_fullpilot_320_binary_ids.txt` (Header: „ABI-6 / Bau-INC-2d (17 Slots, ohne telemetry-/isa-Segment)"; `grep -c "isa=" == 0`); Alt-golden **additiv eingefroren** als `golden_fullpilot_320_binary_ids_abi5.txt` (+ `_abi4.txt`) |
| „Pinnt/permutiert": „isa trägt simd_extension(09b) + general_hardware(12)" | isa = Organ-Träger | isa selbst System-seitig; 09b/12 hängen weiter an der hardware-Topic-Seite, CEB-seitig unter extension_hardware/simd bzw. general_hardware (build-only) |
| e18-Rollentrennung | „Erweiterungshardware = einzige Bau-Treiberin" | Bau-Treiber sind jetzt DREI: Erweiterungshardware/simd (march), Compiler (opt_level, atomic128), **Target-ISA (Cross-Triple/march)**; HardwareIsa bleibt reiner Host-Deskriptor |
| binary_id-vs-Sidecar-Tabelle | 18 Organ-Achsen T0..T17 vs 6 System-Achsen; „+opt= geplant" | **17 Organ-Achsen T0..T16** vs **7** System-Achsen; Sidecar-Seite zusätzlich: telemetry + isa in `build_system_axis_levels()` (`:119-120`); Suffixe IST: `+ext=` `+cxx=` `+opt=` `+ceb=<maj>.<min>` (immer) + `+target=` (nur Cross) |
| IST-vs-GEPLANT Consumer-Wiring | „VARIABEL verdrahtet = nur +ext= + +cxx=" | VARIABEL verdrahtet = **+ext= +cxx= +opt= +ceb=** (immer) **+target=** (bei Cross); zusätzlich Planer-Dock-Permutation **opt×simd** in `run_experiment_profile` (per-Perm-CompileFn + per-Perm-build_version `+cxx=+opt=[+ext=]`, `experiment_run_entry.hpp:253-289`, Default O3/no_extension, Fehlerklassen KonfigXmlParse/HardwareErweiterungFehlt) |
| TABU-Liste | „`CatalogAxes<4,4,5,4>`" | TABU-Objekt heißt jetzt `golden_320_catalog`; NEU TABU-artig: `kNewGolden131072Crc64` (Änderung nur im koordinierten ABI-Fenster, `source_catalog.hpp:166-167`) |
| OFFENE AUDIT-AUFLAGE (build_system_axis_levels ohne Aufrufer) | „repo-weit KEIN Aufrufer" | **ÜBERHOLT:** Aufrufer existiert — `build_all_axis_levels()` konsumiert es (`registry_to_axis_levels.hpp:141`). Die Sidecar-Emission der System-Belegungen läuft real über `system_axes_version_suffix` (`profile_run_facade.cpp:293`) |

### C.7 — Sektion (7) Zähl-Fallen

| Falle | ALT | NEU (live-verifiziert) |
|---|---|---|
| (A) Zähl-Tabelle | Organ 18 · System 6 · Observer-POD 18 | Organ **17** (`axis_path_serialization.hpp:34`) · System-Konfig **7** · Observer-POD **17** (`observable_tier.hpp:49`); axes26 bleibt **26** Aliasse (T00..T25, ALTE Nummerierung: `T10_telemetry`, `T12_isa` als Registry-Reflexions-Quellen der System-Seite, `registry_to_axis_levels.hpp:47-78`) — axes26-T-Nummern ≠ neue Slot-T-Nummern! |
| Merksatz | „16 vs 18 vs 8" | „**16 vs 17 vs 8** NIE verwechseln: 16 Mess-KATEGORIEN, 17 Observer-ACHSEN, 8 Feld-SLOTS" |
| (B) Stale-Falle 19→18 | Registry hat 18; Belege sagen 19 | Jetzt DOPPEL-Shift **19→18→17**. Weiter stale „19": `ceb_system_axis.hpp:7` („permutieren die 19 Organ-Achsen NICHT"), `genus_binding_traits.hpp:12` („19 SearchAlgorithm-Achsen"). ~~NEU stale „18": das committete `cache_engine_axis_registry.xml` selbst~~ **(VERIFIKATIONS-KORREKTUR: seit ce `a9c433d0` regeneriert auf 17, wieder Ist-konform, s. C.5)**. Slot-Verschiebung: alt-T12 index_organization→**T11** … alt-T17 queuing_q2→**T16** |
| (C) Stale k*SlotCount | +1 telemetry; belastbar 14/10/6/12 | +2 (telemetry+isa); belastbar **17/11/13/9/5**; Audit L4/G8 offen (s. C.3) |
| (D) Drei ID-Systeme | string-IDs = „die 18 golden" | string-ID-System bleibt **kanonisch** (die 17 golden); ~~XML-Inhalt bis Regeneration stale~~ **(VERIFIKATIONS-KORREKTUR: XML seit ce `a9c433d0` auf 17 regeneriert, Ist-konform, s. C.5)**; numerische IDs (axis_library_registry) + GROSS-Aliasse (permutation_axes.xml) = **Legacy**, unverändert TABU/Deskriptor |
| (I) Kardinalitäts-Formel | Formel multipliziert telemetry mit | **VERSCHÄRFT:** Formel multipliziert jetzt `T10_telemetry` UND `T12_isa` mit (`registry_to_axis_levels.hpp:153-154`) — beide System-seitig; die 26er-Zahl ist eine Matrix-, keine binary_id-Zählung. **Rename `all_axes_binary_count`→`all_axes_matrix_count` = Audit V7/P4 OFFEN** (`:147`; Session-Handover 2026-07-19 §5) |

Fallen (E) 5%-Doppeldeutigkeit, (F) Op-Kind vs OP-1..6, (G) POD-Spalten 24, (H) page_type, (J) queuing ≠ Gattung, (K) ~279 unbelegt, (L) Deprecated-Liste: GEPRÜFT-UNVERÄNDERT — (L) erweitert um die flache `ExtensionHardwareSystemAxis` (F-SIMD, nicht löschen, user-gated Entfernung).

---

## (D) NEUE Zeilen (dem Original noch unbekannt)

| Neue Achse / Mechanik | Was | Status | Quelle (live) |
|---|---|---|---|
| **`algo_version` je Organ-Variante (#50)** | Pflicht-Angebots-Feld JEDER Kompositions-Organ-Varianten-Klasse: `static constexpr std::string_view algo_version` — Concept-/static_assert-erzwungen in den Strategie-Basen („ohne → Kompilation bricht MIT Typ-Namen"); **Weiterleitung in allen 11 `Observable*`-Achsen-Hüllen** (Fix f1562636: node_type, io_dispatch, serialization, concurrency, index_organization, memory_layout, prefetch, filter, path_compression, migration, value_handle) | gebaut, CI grün (Pipeline 11278) | z.B. `axes/path_compression/axis_02_path_compression_strategy_base.hpp:15-20`; Hüllen-grep = 11 Dateien |
| **`axis_variant_version_table` / `reflect_versions`** | compile-time {axis, W::name() → W::algo_version}-Tabelle über GENAU die 17 Slots (skippt `T10_telemetry`+`T12_isa`); `compose_algo_signature`; `lookup_algo_version` (Sentinel `@v0`); `sub_axis_valueset_segment` (BUILD-globale Werteset-Versionen als algo_sig-Schwanz) | gebaut | `builder/experiment_tree/axis_variant_version_table.hpp:42-115` (Tabelle `:53-82` skippt `T10_telemetry`+`T12_isa`, `lookup :88`, Werteset `:100`, `compose_algo_signature :115`; VERIFIKATIONS-KORREKTUR: alte Angabe `:42-101` deckte compose nicht) |
| **`perm.algos`-Sidecar** | ZWEITES additives Sidecar `<output>.algos` = Organ-Provenienz (algo_sig), **strikt getrennt** von `.version` (System-Provenienz ext/cxx/opt/target/ceb); Skip nur bei String-Gleichheit BEIDER; algo_sig leer = Organ-Gate AUS (rückwärts-kompatibel) | gebaut | `builder/build_orchestrator/build_orchestrator.hpp:108-112/181-203`; `experiment_run_entry.hpp:55` (`AlgoSigFn`) |
| **#51 `artifact_cache`** | Zwei injizierte Nähte: `CachePushFn` (Tier-Binary-Verzeichnis → MinIO, Ebene B) + `MeasurementSinkFn` (Mess-Datei → write-only measure-drop, HTTPS-PUT, additiv, Duplikat→409). Env-Achsen: `COMDARE_MINIO_ENDPOINT` (mc-Alias; Credentials via `MC_HOST_<alias>`) / `COMDARE_MINIO_BUCKET` / `COMDARE_MINIO_PREFIX` / `COMDARE_MEASUREMENT_DROP_URL`; **inert-by-default** (beide leer → No-Op); CI-Scharfschaltung super-seitig gated `COMDARE_STORAGE_CACHE==true` | gebaut (inert) | `builder/artifact_transport/artifact_cache.hpp:10-79` |
| **`+ceb=`-Sidecar-Komponente** | CEB-Contract-Version in build_version: `COMDARE_ANATOMY_ABI_MAJOR` (automatisch) + `kCebContractCodegenMinor` (=0, manuell/Tripwire) → jeder Bump invalidiert ALLE perm.dll.version | gebaut | `anatomy_module_abi_v1_decl.hpp:144-149`; `profile_run_facade.cpp:300-306` |
| **`all_axes_golden.profile.xml`** | deklarative Referenz des NEUEN golden-Standards: alle 17 Kompositions-Achsen je 2 `<value>` (erste 2 Enabled) → N = 2^17 = 131.072; ADDITIV (m3v2 = 320-Grundlage bleibt TABU); bewusst NICHT in catalog_codegen.cmake | gebaut (Referenz); **Materialisierung/golden-N-BAU OFFEN** (E-1-Rest/E-3 + E-2-Rest=O3-golden-Rebuild-Fenster; #49 NICHT fertig — nur Fixture. VERIFIKATIONS-KORREKTUR: Register-E-2 „NICHT-GEBAUT" ist STALE — opt-f/opt-g sind gebaut, ce `2c474c86`+`43c3aa0c` 2026-07-18, vor Register-Erstellung; ebenso Register-E-1-Teil „XML bauen" — die XML liegt seit `aa25c9a4` vor) | `algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml:1-53`; Session-Handover 2026-07-19 §4 |
| **CRC64-Anker `kNewGolden131072Crc64`** | CRC-64/ECMA-182 der 131.072 golden-binary_ids = `0xF1C1F26A1232073B`; ersetzt die 62-MB-id-Datei (kommt NICHT ins git); Prüfung lazy via `gen_golden_fullpilot --crc64` / test_limits | gebaut | `profile_facade/source_catalog.hpp:161-167` |
| **`OptimizationLevelSubAxis`** (Unter-Achsen-Header) | label `opt_level`, parent `compiler`; 5 Optionen O0..Ofast (gcc/clang/msvc-Flag je Option); Default O3 | gebaut + verdrahtet | `measurement/optimization_level_sub_axis.hpp:37-143` |
| **`SimdSubAxis`** (Unter-Achsen-Header) | label `simd`, parent `extension_hardware` (⚠ verwaist bis G2-Fix); Optionen NoExt/Avx2/Avx512 (gcc/clang/msvc) | gebaut; Familien-Knoten offen | `measurement/simd_sub_axis.hpp:34-96` (Basis `:34-50`, Optionen `:68-90`, `kAllSimdIds :96`; VERIFIKATIONS-KORREKTUR: alte Angabe `:34-50` deckte die Optionen nicht) |
| **`CompilerAtomicSubAxis`** (Unter-Achsen-Header) | label `atomic128`, parent `compiler` (z.B. `Cx16Option` -mcx16); **(VERIFIKATIONS-KORREKTUR)** „Ziel≠x86_64 ⇒ degradiert" ist DESIGN-Zusage (Kommentar `target_isa_system_axis.hpp:7-8`; Header sagt „ISA-gegated (nur x86_64)", `compiler_atomic_sub_axis.hpp:19/69`) — an der Flag-Montage heute NUR Host-Makro-Gate `COMDARE_ARCH_X86_64` (`profile_run_facade.cpp:188-196`), KEIN Laufzeit-Ziel-ISA-Check | gebaut (Ziel-Degradierung offen) | `measurement/compiler_atomic_sub_axis.hpp:7/38/42/97-98` |
| **`TargetIsaSystemAxis`** (7. System-Achse) | s. C.1 (1a-NEU-Zeile) | gebaut | `measurement/target_isa_system_axis.hpp` |

---

## (E) PLANER-/RESOLVER-RELEVANZ (Ledger §27 + §28-Präzisierung)

**§27-Modell:** Registry = ANGEBOT (was die Engine compilieren kann), Anwender-XML = ANZEIGE (welche Experimente/Achsen/Einstellungen/Flags/Unter-Achsen/Abläufe+Ranges laufen sollen), dazwischen eine **Resolve/Link-Stufe** (.pom-Modell; unregistriert = harter Validierungsfehler; Andockpunkt = `validate_profile.hpp`, KEIN Parallel-Validator). **§28:** DREI art-spezifische Registries, je im Modul ihrer Achsen-Art; Haupt-Achse = CT-statisch, Unter-Achsen = meist dynamisch im Ziel-Binary.

**Welche Nachschlagewerk-Tabellen speisen das ANGEBOT (die 3 Registries):**

| Registry (§28) | Speisende Tabellen (Original + Nachtrag) | Ist-Stand |
|---|---|---|
| **Organ-Registry** = `cache_engine_axis_registry.xml` (+ `prt_art_axis_registry.xml`) | §2-Slot-Tabelle T0..T16 (C.2) + Varianten-Inventare + **NEU je Baustein: `algo_version` (#50, D)** als künftiges Angebots-Feld | existiert; Regeneration auf 17 Achsen **ERLEDIGT** (ce `a9c433d0`, VERIFIKATIONS-KORREKTUR, s. C.5); **string-ID-System = KANONISCH** — die 2 anderen ID-Systeme (numerische `axis_library_registry`-IDs, GROSS-Aliasse `permutation_axes.xml`; Falle D) sind **Legacy** und speisen NICHTS |
| **System-Registry** (NEU zu bauen, measurement-Modul) | §1a-Tabelle der jetzt **7** Haupt-Achsen (C.1) + deren Unter-Achsen: `opt_level` (5), `simd` (3, +GPU später), `atomic128`, `target_isa` (2), workload, Scheduling-Sub-Dims; Single-Sources `kAllOptLevelIds`/`kAllSimdIds`/`kAllAtomic128Ids`/`kAllTargetIsaIds` sind die natürlichen Reflexions-Anker | Header gebaut; XML-Registry fehlt |
| **Mess-Registry** (NEU zu bauen, Mess-Modul) | §4-Tabellen: 16 Kategorien (`kMeasurementAxisRegistry` = fertiger constexpr-Anker), 3 Kollektoren, DynamicDims, Workload-Achse, W/D/K | constexpr-Quelle gebaut; XML-Registry fehlt |

**Welche Tabellen sind die Unter-Achsen-Kandidaten für die Anwender-XML-ANZEIGE (Vollsupport):** die **1b-Tabelle** (System-Unter-Achsen: opt_level/simd/atomic128/target/workload/Scheduling-Dims), die **Organ-Sub-Achsen-Tabelle** (§2: per-K, btree_order, skip_list_shape, bst_shape, hash_probe_shape, page_type), die **Genus-eigenen Achsen** (§3: inner_container, growth_policy, extent/layout/accessor_policy) und die **DynamicDims-Tabelle** (§4: thread_count, prefetch_distance, pool_budget_bytes, batch_size, inline_threshold_bytes, hw_prefetcher, repetition, workload, fixed_conditions, working_set_sweep). Haupt-/Unter-Semantik nach §28 + `feedback_haupt_achse_static_unter_achse_runtime_chain_ct_wiring`: Haupt statisch (binary_id bzw. Sidecar), Unter-Achsen als Runtime-/RC-POD-/Flag-Werte, stufen-relativ verdrahtet.

**Planer-Ist (Einordnung):** Der Planer-Kopf ist LÜCKE (kein benannter Codegen/Director/Executable; imperative opt×simd-Schleife `experiment_run_entry.hpp:253-289` = heutiges Dock); Ebene CEB→Tier real + test-bewiesen (ABI-6-Loader). Top-down-Bauplan + Phase-0-v32-Reconcile-Blocker: `docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md`, Session-Handover 2026-07-19 §2/§3.

---

## (F) GEPRÜFT-UNVERÄNDERT (explizit)

Live gegengeprüft und im INC-2d-Stand UNVERÄNDERT gültig:

- **§0:** Gattung Ebene-1/2 (3/5), Mess-Dimensionen (3), Mess-Kategorien (**16**, `measurement_category.hpp:32`), System-Mess-Kollektoren (**3**, `system_axis.hpp:196/242/287`), 8 Feld-Slots (`kV3FieldCount=8`, `observable_tier.hpp:52`).
- **§1:** Wurzel-Zeilen `Axis<Derived>`/`CebSystemAxis`/`SystemAxis`; Scheduling-Zeile + alle Scheduling-Unter-Achsen; Hardware/ISA-Zeile (bleibt Host-Deskriptor, label `hardware`); Last/Frameworks + workload; Compiler-Hauptzeile (Gcc/Clang, +cxx=); Telemetrie-Zeile (nur Zeilen-Shift der Quelle, C.1); `ISchedulingStrategy` deprecated.
- **§2:** Ausprägungs-Inventare, Observer-Felder, golden-Pins und Sub-Achsen ALLER verbleibenden 17 Achsen (nur Slot-Nummern ≥ alt-T12 verschoben); node-shape-Status (DefinitionOnly, default-OFF); search_algo per-K gated.
- **§3:** 3-Ebenen-Modell, Achsen-SÄTZE der Genera (nur je −isa), Genus-eigene-Achsen-Tabelle, BUILD/SHAPE-Tabelle, binary_id-Dreiteilung.
- **§4:** alles außer den 3 POD-Zeilen (C.4).
- **§5:** alles außer den 3 Zeilen in C.5.
- **§6:** search_algo↔cache_traversal-Kopplung; BUILD⊥LASTENPROFIL; Orthogonalitäts-Garantie (keine System-Achse in `kCompositionAxisNames` — gilt weiter, jetzt inkl. target_isa); gated-Liste (PMC #26, Voll-Messlauf #156).
- **§7:** Fallen (E), (F), (G), (H), (J), (K), (L)-Kern.

---
*Erstellt 2026-07-19 als INC-2d-Delta-Nachtrag; Verifikationsbasis ce `5da2caf7`, Audits `docs/audits/20260718-konformitaets-audit-9dim-REPORT.md` + `20260719-konsolidierung-register-post-crash-REGISTER.md`, Ledger §26–§28.*

---

## (G) VERIFIKATION (adversarial, 2026-07-19, ce HEAD `a9c433d0` = development)

**Basis-Verschiebung:** Die Erst-Verifikationsbasis `5da2caf7` ist NICHT mehr HEAD — ce hat seither GENAU EINEN neuen Commit: `a9c433d0` (2026-07-19 04:05, „fix(registry): INC-2d-Nachzug-Verbund — Registry-Regen 18→17 + experiment_golden-Fixture isa→mapping + Parser-Test"). Alle Deltas dieses Nachtrags wurden gegen `a9c433d0` (Live-Arbeitsbaum, `git status` clean) nachgeprüft.

**94 Delta-/NEU-Zeilen geprüft** (alle Tabellenzeilen B, C.0–C.7 inkl. der 17 Slot-Zeilen, D, E sowie die F-Stichproben), **7 korrigiert**. Kern-Anker sämtlich WÖRTLICH bestätigt: `kCompositionAxisNames` `std::array<std::string_view, 17>` in exakt der C.2-Reihenfolge (`axis_path_serialization.hpp:34-37`); `kV3AxisCount=17`/`kV3FieldCount=8`/`axis_stats[17][8]`+`seg_ns[17]`/Version 7/sizeof-1272-nur-Kommentar-KEIN-static_assert (`observable_tier.hpp:49/52/129-130/153-154/125-126`; repo-weit kein `static_assert(sizeof(ComdareTierObserverSnapshot))` — L3 offen bestätigt); `COMDARE_ANATOMY_ABI_MAJOR 6` + Magic `0x434F4D444141362E` „.A6." (`anatomy_module_abi_v1_decl.hpp:54/57-58`) + `kCebContractCodegenMinor=0` (`:144`); `target_isa`-Label + `X86_64TargetIsa`(native)/`Aarch64TargetIsa`(`-target aarch64-linux-gnu`+`-march=armv8-a`) + `kAllTargetIsaIds`(2) (`target_isa_system_axis.hpp:34/64-78/85-86`); die 5 struct-internen slot_counts **17/11/13/9/5** (`genus_binding_traits.hpp:39/63/88/115/140`) inkl. aller stale-Gegenstücke (15/11/7/13 `set_composition.hpp:59`/`sequence_composition.hpp:65`/`view_composition.hpp:71`/`adapter_anatomy.hpp:151`, „// 12" `:168`, `test_d9_set.cpp:38`); Suffix-Kette WÖRTLICH `"+ext="…"+cxx="…"+opt="…"+ceb=<MAJOR>.<Minor>` + `+target=` nur bei Ziel≠Host (`profile_run_facade.cpp:298-312`), `+opt=` immer emittiert; `algo_version` per `static_assert(requires { Derived::algo_version; })` in den Strategie-Basen (z.B. `axis_02_path_compression_strategy_base.hpp:18-21`) + Weiterleitung in EXAKT 11 `Observable*`-Hüllen (grep „#50 Caching: algo_version-Weiterleitung" = 11 Dateien, Liste == C.4/D-Angabe); DEPRECATED-Block der flachen `ExtensionHardwareSystemAxis` (`extension_hardware_system_axis.hpp:4-10`), einziger Label-Träger (`:33`), Consumer nur `test_striktheit_axis_dach_guard.cpp`; `all_axes_binary_count()` multipliziert `T10_telemetry` (`registry_to_axis_levels.hpp:153`) UND `T12_isa` (`:154`) im 26er-Produkt (`:147-161`), axes26 = 26 Aliasse T00..T25 (`:47-78`), `build_system_axis_levels()` = 5 (isa-push `:120`), Aufrufer `build_all_axis_levels()` `:141`; Kataloge `FullSourceCatalog=2^17` `:126`/`golden_320_catalog=320` `:130`/CRC64 `0xF1C1F26A1232073B` `:167` + static_asserts `:155-159`; `composition_factory.hpp:97` `sizeof...(Vs)==17`; golden-320-Datei ABI-6-Header + `grep -c "isa=" == 0` + `_abi5`/`_abi4` additiv vorhanden; 16 Kategorien (`measurement_category.hpp:32`), 3 Kollektoren (`system_axis.hpp:196/242/287`), isa-Organ 4 Varianten (`axis_09_isa_registry.hpp:18`); `all_axes_golden.profile.xml` 17 Achsen × je 2 `<value>` (`:35-53`); `artifact_cache.hpp` Env-Namen + inert-by-default (`:10-79`); `AlgoSigFn` (`experiment_run_entry.hpp:55`) + opt×simd-Doppelschleife mit `KonfigXmlParse`/`HardwareErweiterungFehlt` (`:252-289`); `.algos`-Sidecar strikt getrennt von `.version` (`build_orchestrator.hpp:108-112/184-205`).

**Korrektur-Liste (7):**
1. **C.5 Registry-XML-Zeile:** „STALE, 18 Achsen inkl. isa T11, Regeneration OFFEN" → ÜBERHOLT durch ce `a9c433d0`: XML regeneriert auf 17 Achsen ohne isa (`grep -c "<axis " == 17`; `index_organization slot="T11"` Z.77). Falle-B-Anweisung gilt wieder normal (XML = Ist).
2. **C.7 Falle (B):** „NEU stale 18: die committete XML" gestrichen (seit `a9c433d0` Ist-konform).
3. **C.7 Falle (D):** „XML-Inhalt bis Regeneration stale" gestrichen (dito).
4. **E Organ-Registry-Zeile:** „Regeneration auf 17 OFFEN" → ERLEDIGT (`a9c433d0`).
5. **D CompilerAtomicSubAxis:** „Ziel-ISA-gegated (Ziel≠x86_64 ⇒ degradiert)" präzisiert: nur DESIGN-Zusage (`target_isa_system_axis.hpp:7-8`; `compiler_atomic_sub_axis.hpp:19/69`) — implementiert ist ausschließlich das Host-Makro-Gate `COMDARE_ARCH_X86_64` (`profile_run_facade.cpp:188-196`), kein Laufzeit-Ziel-Check.
6. **D axis_variant_version_table:** Zeilenangabe `:42-101` → `:42-115` (compose_algo_signature `:115` lag außerhalb).
7. **C.1/D SimdSubAxis:** Zeilenangabe `:34-50` → `:34-96` (Optionen `:68-90`, `kAllSimdIds :96` lagen außerhalb).

**Widerspruchs-Prüfung Register/Bauplan:**
- **Konsolidierungs-Register (`…REGISTER.md`):** KEIN Widerspruch bei G2/E-4 (`:50/:166` decken sich wörtlich mit C.1). ABER Register-**E-2** („opt-f/opt-g … ENTSCHIEDEN-NICHT-GEBAUT", `:48`) und der E-1-Teil „XML bauen" (`:47`) widersprechen diesem Nachtrag — der NACHTRAG ist richtig: opt-f/opt-g sind live gebaut (ce `2c474c86` 07-18 10:47 + `43c3aa0c` 07-18 11:23, `experiment_run_entry.hpp:252-289`), die golden-XML liegt seit `aa25c9a4` (07-18 19:58) vor; beide Commits VOR der Register-Erstellung → Register-Zeilen E-1(Teil)/E-2 sind stale (offen bleibt dort real nur O3-golden-Rebuild-Fenster + Materialisierung/#56).
- **Planer-Bauplan (`…BAUPLAN.md`):** KEIN Widerspruch — deckungsgleich in ABI-6/Magic/`host_compatible_with`, „Fuß real / Kopf Doku-Beschriftung", Phase-0-v32-Reconcile-Blocker und opt×simd-Naht (Bauplan `:257-289` vs Nachtrag `:253-289` = dieselbe Naht, Kommentarkopf `:252`).

*Verifiziert 2026-07-19 (adversarial, Live-Code ce `a9c433d0`).*
