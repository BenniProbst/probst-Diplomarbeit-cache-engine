# DESIGN — opt-f/opt-g (System-Achsen-Schichtung) + A2-Neben + neue golden-Basis

> **Status:** Design-Vorlage zur Freigabe (Bau hält bis User-Rulings E1–E5). Konsolidiert 2 ultracode-Läufe
> (`wf_bd2878b3` opt-g-Code-Dock + A2-Neben; `wf_e7e52856` System-vs-Mess-Schichtung + golden-Regen/Lösch).
> Belege `datei:zeile`. **ce** = `Code/external/comdare-cache-engine`. Anlass: User-Bruch-Rulings 2026-07-18
> (golden-320-TABU + „additiv" aufgehoben, alte golden+Messwerte löschen, neue golden-Version, „so sauber wie möglich").

## 0. Die Achsen-Schichtung (die User-Präzisierung „System-Achsen vs Mess-Achsen build")

Ein semantik-freies Dach `topics::Axis<Derived>` (`ce/.../topics/axis.hpp:26-30`, empty base, **keine vtable**),
Diskriminator `enum class AxisKind { organ, system_measurement, system_config }` (`axis.hpp:17-21`). **Drei Schichten:**

| Schicht | AxisKind | Wurzel | Rolle | binary_id? |
|---|---|---|---|---|
| **Organ** | `organ` | Topic-ConfigSets | Komposition T0.. (`kCompositionAxisNames`, `axis_path_serialization.hpp:31-34`, **heute 18** — telemetry seit ABI-5 abgewandert) | **JA — bildet binary_id** via `serialize_composition_path` (:44-60) |
| **Mess/„Blut"** | `system_measurement` | `SystemAxis<D>` (`system_axis.hpp:150-152`) | WallClock/Observer/Pmc, misst **innerhalb** der geladenen Binary, immer präsent | NIE |
| **System-Config** | `system_config` | `CebSystemAxis<D>` (`ceb_system_axis.hpp:22`) | CEB-**Bau**-Achsen: compiler/opt_level/isa/simd/scheduling/load | NIE — Provenienz in `build_version`/Sidecar |

**`opt_level` sitzt exakt als Unter-Achse UNTER `compiler`** (`optimization_level_sub_axis.hpp:40` `parent_axis_label()=="compiler"`, static_assert :137; `axis_kind()==system_config` geerbt). Volle Familie `{O0,O1,O2,O3,Ofast}` als leere CRTP-Structs; CEB-Default **O3** (`:127`, IEEE-754-det. :135). **Exakt dieselbe Schicht wie `extension_hardware`/simd** — das strikte Vorbild.

**Das mehrstufige Build, präzise:**
- **Stufe 1 = System-Config** (compiler × opt_level × simd × isa …) → wählt die injizierte `CompileFn` + Flags (`-O<n>`, `-march`) → geht in `build_version`/`.version`-Sidecar, **NIE in binary_id**.
- **Stufe 2 = Organ** → `serialize_composition_path` → `binary_id` → `perm_<id>.dll`, kompiliert **mit** den Stufe-1-Flags.
- **Stufe 3 = Mess-Achsen** → messen in der geladenen Binary. **Dieselbe binary_id existiert unter mehreren opt-Sidecars mehrfach** — unterschieden über die CSV-Spalte `build_version`, NICHT über binary_id.

## 1. opt-g präzise (die Korrektur)

**opt_level/simd sind `system_config` → sie gehen NICHT in die golden-Kardinalität.** Der binary_id bleibt Organ-only.
Beleg schon heute: `isa` ist im `FullSourceCatalog` auf `isa_amd64` gepinnt (`source_catalog.hpp` `take<...,1>`) — eine
System/HW-Achse multipliziert den binary_id nicht. **Was auf `Organ × |opt|` wächst, ist AUSSCHLIESSLICH die Mess-Matrix
(CSV-Zeilen)** — nicht die binary_id-Fixture.

Provenienz sauber dreigeteilt: **(a)** binary_id = Organ · **(b)** `build_version`+`.version`-Sidecar = System-Config (opt/simd) · **(c)** CSV-Spalten = Mess-Unter-Achsen (thread_count, prefetch_distance, workload/dataset, op_type …).

**Verdrahtungslücke:** `+opt=`-Suffix ist heute nur SOLL/Kommentar (`optimization_level_sub_axis.hpp:12-13`) — keine
Concatenation-Site in `experiment_run_entry.hpp`. Code-Loop (aus `wf_bd2878b3`): Permutations-Schleife **innerhalb**
`run_experiment_profile` unter dem CSV-Header-Write; je opt eigene `CompileFn(opt_flag)` + `build_version+="+opt="+level`
+ eigenes Sidecar; `sota_seen_bids` **je opt zurücksetzen** (sonst baut nur die 1. Stufe).

## 2. Die neue golden-Basis — was WIRKLICH passiert (destruktiver Umfang klein)

Die golden-Matrix kommt aus dem compile-time C++-Katalog `FullSourceCatalog = CatalogAxes<4,4,5,4>` (`source_catalog.hpp:111`),
**320 = search_algo 4 × node_type 4 × memory_layout 5 × prefetch 4** (14 weitere Organ-Achsen gepinnt). Regeneriert **nur**
via `comdare_gen_golden_fullpilot` (EXCLUDE_FROM_ALL; `tools/gen_golden_fullpilot/main.cpp:31-53`, schreibt `.txt` mit trunc,
Exit 0 nur bei `size()==320`). Die aktuelle `.txt` ist **bereits ABI-5 (18-Slot, telemetry raus)**.

- **REGENERIERT (nicht von Hand):** `golden_fullpilot_320_binary_ids.txt` — **nur falls die Organ-Matrix wächst** (Achsen entpinnen). Sonst **unverändert** (opt ändert sie nicht).
- **rm (destruktiv, git-reversibel, überholte Messwerte):** `tests/unit/thesis_tiere/tier150_measurements.csv`, `.../adapter_measurements.csv`, `build/thesis_tiere/tier150_measurements.csv`.
- **NICHT anfassen (unbeteiligt):** `libs/.../permutation_axes.xml` + `cmake/permutations.cmake` (separater ~Mrd-Perm-codegen, KEINE golden), `experiment_golden.xml` (E4-Fixture, inert).
- **Offen:** `golden_fullpilot_320_binary_ids_abi4.txt` (ABI-4-Historie, „eingefroren, nicht neu generieren") — löschen unter Bruch-Freigabe kollidiert mit ABI-Historie-Direktive.

**Harte Count-Gates (falls Organ-Matrix wächst, 320 → neuer Count):** `test_profile_roundtrip.cpp:94-95,116,233,252-279`,
`test_limits_entkopplung_vorstufe.cpp:78-86,120`, `test_wdk_datasets_fairness.cpp:49-50,64`, `test_measurement_categories.cpp:41-42,55,163`,
`test_smoke_coverage_profile.cpp:47-48,76-78,154`, `test_axis_sweep_pilot.cpp:113,188-189`; CMake `tests/unit/CMakeLists.txt:2523,2550,2577,3245,3419-3430` (`COMDARE_GOLDEN_320_IDS`-Define umbenennen); Profil-Zwilling `m3v2_study.profile.xml:40-71,151`.

## 3. A2-Neben (Zyklus-Bruch) — aus `wf_bd2878b3`

`pmc_source.hpp` = reiner POD/Interface (`PmcCounters` 7×uint64+bool, `IPmcSource`, `NullPmcSource`; nur `<cstdint>/<string_view>`).
Zyklus = **measurement→builder aufwärts** über NUR `system_axis.hpp:10` + `i_measurement_source.hpp:13` (beide inkludieren `builder/pmc_source.hpp`).
**Minimal-Bruch:** `pmc_source.hpp` nach `measurement/` verschieben → Aufwärts-Kante weg, `perm_runner` unangetastet. `PmcCounters`
wird feldweise in den ABI-heiligen `ComdareMeasurementSnapshotV1` kopiert (`measurement_snapshot.hpp:124-131`) — **Struct-Inhalt byte-verbatim lassen** (#156).
- **Stufe 1:** move + (E3) Namespace-Frage. **Stufe 2 (separat):** `perm_runner` → `harness/` herauslösen (10 Includer, kreuzt #156/result_ingest/e2e/#223/observer/slurm).

## 4. Offene Entscheidungen (E1–E5)

- **E1 — Organ-Matrix: 320 lassen oder wachsen?** opt-g wächst die **Fixture NICHT** (opt=System). Bleibt die Organ-Fixture bei 320 (nur Mess-Matrix → 320×|opt|)? Oder Organ-Achsen entpinnen (>320 binary_ids)? *Empf.: 320 lassen; Organ-Wachstum separater Entscheid.*
- **E1b — welche opt-Stufen in die Mess-golden?** O3=det. Baseline; O0/O1/O2 additiv; **Ofast** bricht 1-Thread-Determinismus. *Empf.: O2/O3 golden, O0/O1/Ofast additiv daneben.*
- **E2 — rm-Umfang.** `tier150_measurements.csv` (tests+build) + `adapter_measurements.csv`. *Empf.: ja (git-reversibel).*
- **E3 — A2-Neben Namespace.** sauber (`builder::`→`measurement::` + ~6 Call-Sites) vs minimal (Namespace behalten). *Empf.: sauber.*
- **E4 — `perm_runner` Stufe 2.** jetzt (im selben GO) oder Folge-Increment? *Empf.: Stufe 1 zuerst, dann Stufe 2.*
- **E5 — `..._abi4.txt`.** löschen (Bruch) oder als deprecated ABI-Historie behalten? *Empf.: behalten/deprecaten (git ≠ Ersatz für getrackte Referenz).*

## 5. KONFORMITÄTS-DIFF opt-f/opt-g (ultracode `wf_d27ad90d`, User-Einwand Haupt/Unter-Achse 2026-07-18)

**Führende Tabelle (workflow-belegt):** `docs/sessions/20260522-…-compiler-axis.md:66-74` §2.1 + Memory `project_compiler_axis_v35`: **Haupt-Achse 15 `compiler`** → Unter-Achsen **15.1 Compiler-Family** {gcc,clang}, **15.2 Optimization-Level** {O0..Ofast}, 15.3 LTO, 15.4 PGO, 15.5 Target-Arch. O0..Ofast = **Optionen** der Unter-Achse 15.2. `extension_hardware` = eigene Haupt-Achse (6., Q2 Option C). Mess-Achsen = formal System (`AxisKind::system_measurement`), **getrennte Wurzel** (Mess-SystemAxis ⟂ CebSystemAxis) unter EINEM Dach `topics::Axis`.

**Verdikt:** Die **C++-Achsen-Library ist SOLL-konform** (`opt_level`=Unter-Achse `parent=="compiler"`, O0..Ofast=`opt_level_id`-Ausprägungen). Der User-Einwand trifft die Kernschicht NICHT, aber die Haupt/Unter-Vertauschung lebt real an **3 Nähten**:

| Ebene | SOLL | IST (Verstoß) | Fix |
|---|---|---|---|
| Namensfalle | O-Typen = Optionen | structs `OptO0..OfastSubAxis` (Suffix „SubAxis") legen Fehl-Lesart nahe | → `OptO0..OfastOption` |
| XML-Flachheit | `opt_level`/`simd` = EIN Container, Optionen als Kinder | `<opt_level value>` je Option WIEDERHOLT; Parser dropt `compiler`-Parent (flach `opt_levels`) | XSD Container+`<option>`; Parser `CompilerAxisSel{family,opt_options}` |
| Asymmetrie | extension_hardware → simd-Unter-Achse → Optionen | XSD hat `<simd>`, aber typed KEINE `SimdSubAxis` (Optionen direkt) | `SimdSubAxis` (parent=="extension_hardware") symmetrisch anlegen **[Entscheidung]** |
| Mess=System | getrennte Wurzel, formal System | ✓ korrekt getrennt | KEIN Verstoß; optional Kinship-Kommentar im XSD |
| opt-Default | O3 (Ruling 18.07.) | Code ✓ O3; `BAUPLAN-…-OPT-C-UEBERSETZER.md` STALE (Ofast) | Doku-Nachzug O3 |

**Konforme Ziel-XML:** `<compiler><opt_level><option value="O2"/><option value="O3"/></opt_level></compiler>` + `<extension_hardware><simd><option value="no_extension"/><option value="avx2"/></simd></extension_hardware>`.
