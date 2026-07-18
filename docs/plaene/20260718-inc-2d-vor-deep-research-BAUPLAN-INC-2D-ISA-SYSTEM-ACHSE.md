# BAUPLAN-DOSSIER — INC-2d: isa aus Komposition → Target-ISA-System-Achse (ABI 5→6, golden-Umbau)

> **Status:** VOR-Deep-Research abgeschlossen (Workflow `wf_1e82195b-e20`, 6 Agenten, ~480k tokens), dem User als
> Klartext vorgelegt 2026-07-18. **GATED auf User-Entscheid** (Variante A vs B) + explizite Freigabe je Phase
> (TABU-golden-Umbau, GO-bedingtes Änderungsfenster). Bau erst NACH GO. Roots: **ce** =
> `Code/external/comdare-cache-engine`, **super** = Repo-Wurzel.
>
> **Voraus-Kette (erledigt, alles beide Remotes, NACH-COMMIT_OK):** F-SIMD komplett+Feinspiegel (ce `0947a64b`),
> Single-Source-Validate (ce `bf6d414d`), INC-0 Schritt 1 (ce `e5eb990f`) + Schritt 2 (ce `01748163`).

## 0. Auftrag (User-Ruling verbatim, 2026-07-18)
> „INC-2d: Bitte jetzt herauslösen, das ist definitiv eine **eigene System-Achse**. Wenn wir von einem x86 System
> die ISA ARM64 kompilieren, ist das faktisch ein **cross compile**, aber konfigurierbar in den System-Achsen und
> vollkommen zulässig und ok."

isa (T11, Slot 12) aus `kCompositionAxisNames` (18→17) + `GenusBindingTraits` herauslösen → eine build-treibende
**Target-ISA-System-Achse** (cross-compile x86→ARM64), binary_id-NEUTRAL; `golden_fullpilot_320` messdaten-erhaltend
regenerieren (Count 320 bleibt, isa war gepinnt); ABI 5→6.

## 1. Semantische Klärung (Live-Read-belegt) — 4 „ISA"-Dinge
- **(a) isa-ORGAN** `axis_09` {Amd64Isa, Aarch64Isa, RiscVIsa, PowerPcIsa} mit echtem per-ISA-Codegen
  (`simd_field_sum`, AVX/NEON), heute `kCompositionAxisNames[11]`.
- **(b) HardwareIsaSystemAxis** = reiner **HOST-Deskriptor** (`do_axis_label()=="hardware"`, `host_isa()→"x86_64"`,
  „treibt NICHT den Bau"), Mess-Gate.
- **(c) simd_extension(09b) + general_hardware(12)** = build-only System.
- **(d) NEU vom Ruling adressiert: TARGET-ISA** (wofür kompiliert wird) — verschieden von (b) Host.

## 2. Empfohlenes Design (Variante A, telemetry-/INC-2c-treu + Freigabe-Prinzip)
1. **NEUE `TargetIsaSystemAxis`** (`CebSystemAxis<Derived>`, CRTP+Concept, is_empty/nicht-polymorph = keine vtable,
   compile-time-only), `do_axis_label()=="target_isa"`. Auspräg.: `X86_64TargetIsa` (default, host==target, kein
   cross), `Aarch64TargetIsa` (cross). NICHT in `kCompositionAxisNames`, nie binary_id.
2. **`HardwareIsaSystemAxis`** (Host-Deskriptor, label `hardware`) **BLEIBT unverändert** als Mess-Gate „Binary-ISA ⊆
   Host-Capability". Freigabe-Prinzip: TargetIsa **gibt** die Ziel-ISA **frei**, Host-Gate **prüft** Lauffähigkeit;
   SIMD(avx2/512)+atomic128(cx16) sind Organe **≤ Ziel-Zulassung** (Ziel≠x86_64 ⇒ avx*/cx16 degradieren zu
   no_extension/no_cx16, NEON/SVE-Vokabular).
3. **isa-ORGAN-Typen** (`Amd64Isa` etc., `IsaStrategyBase:OrganAxis`) **BLEIBEN** als Codegen-Träger (**exakt
   INC-2c-Telemetrie-Muster**: Organ verlässt nur die Komposition, Typ bleibt Mess-/Code-Infra). Ihre **Selektion**
   wandert von binary_id-Permutation zu build-config (TargetIsa wählt zur Compile-Zeit den ISA-Codepfad).
   → `IsaStrategyBase`-Basis NICHT auf System umstellen (bewusst telemetry-treu).

**Cross-Compile-Flag-Kanal** (Muster `SimdSubAxis::gcc_march_flag` / `CompilerAtomicSubAxis::gcc_flag`):
TargetIsa-Auspräg. reflektiert compile-time `target_triple()→"-target aarch64-linux-gnu"`, `sysroot()→"--sysroot=…"`,
`target_march()→"-march=armv8-a"`. Naht = `make_gpp_compile_fn` (`build_orchestrator.hpp:498-538`); für echten
Cross-Build zusätzlich Cross-Treiber (`aarch64-linux-gnu-g++`) statt g++-16. Facade: **neu**
`perm_target_isa_cflags()` spiegelbildlich zu `perm_extension_hardware_cflags`/`perm_compiler_isa_cflags`, eingereiht
in `perm_compile_flags()`; Cross-Treiber in `cxx_compiler()`. Provenienz additiv `+target=<ziel-isa>` in
`system_axes_version_suffix` → `.version`-Sidecar, **NIE binary_id**.

**Name:** `target_isa` (spiegelt -target/--sysroot; grenzt sauber ab gegen `hardware`=Host, `isa`=frei werdender
Alt-Organ-Name, `simd_extension`; vermeidet `do_axis_label()`-Kollision).

## 3. golden-Umbau (höchste Sorgfalt)
- **Zeilenformat VORHER** (18 Slots, isa=Slot 12): `…value_handle=value_handle_inline/isa=isa_amd64/index_organization=…`
- **NACHHER** (17 Slots): `…value_handle=value_handle_inline/index_organization=…` (`/isa=isa_amd64` fällt exakt 1×/Zeile).
- Alle 320 Zeilen ändern sich (`grep -c 'isa=isa_amd64' == 320` verifiziert; nur isa_amd64 existiert).
- **Count-320-Erhalt (belegt):** `FullSourceCatalog=CatalogAxes<4,4,5,4>` (`source_catalog.hpp:111`); die 4
  variierenden Achsen (L00 search_algo/L04 node_type/L05 memory_layout/L07 prefetch) liegen VOR isa (Slot 12) und
  bleiben gepinnt=1; isa=L11=Fanout 1 ⇒ 4·4·5·4=320 unverändert, nur der konstante Teilstring fällt.
- **Regen (offizieller Pfad):** `tools/gen_golden_fullpilot/main.cpp` (EXCLUDE_FROM_ALL) → im ABI-Fenster explizit
  `cmake --build <build> --target comdare_gen_golden_fullpilot`, dann
  `./comdare_gen_golden_fullpilot tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt`. Generator geht über
  `catalog_static_levels<FullSourceCatalog>→ExperimentTree.build→StaticBinaryView` (positions-getreu), Count-Wache
  eingebaut (`main.cpp:53`). **ZUERST** Generator-Header-Literal `main.cpp:44` „18 Slots" → „17 Slots ohne
  telemetry/isa".
- **Messdaten-erhaltend:** (1) VOR Regen die 18-Slot-Fassung additiv als
  `golden_fullpilot_320_binary_ids_abi5.txt` einfrieren (**Präzedenz `_abi4.txt` existiert**). (2) Generator schreibt
  AUSSCHLIESSLICH die REFERENZ (ofstream trunc argv[1]) — KEINE gemessene CSV. **super-Repo hat KEINEN golden-Spiegel
  verifiziert** — kein Cross-Repo-Sync nötig.

## 4. ABI 5→6 (POD/Schema/sizeof)
- `anatomy_module_abi_v1_decl.hpp:49` `COMDARE_ANATOMY_ABI_MAJOR` 5→6; `:53` MAGIC `…A5.`→`…A6.` (nur Byte 0x35→0x36).
- `observable_tier.hpp`: `:48` `kV3AxisCount` 18→17; `:67-103` `kV3AxisSchema` T11-isa-Zeile raus + T12..T17→T11..T16
  reindexen; `:130/:131` `axis_stats[17][8]`/`seg_ns[17]` folgen automatisch; **sizeof 1344→1272** (Δ−72 =
  17·8·8+17·8+48 Meta = 1272, verifiziert); `:154-155` PODVersion 6→7.
- Mit-betroffen (gleiche POD-Größe): `measurable_workload.hpp:99` `seg_ns[17]`; `abi_adapter.hpp` `fill_observer_v3`
  isa-Schreibpfad raus + **alle Indizes ≥11 um −1 rücken** (⚠ still, nicht compile-gefangen — sorgfältiges Review).
- `AbiTransportPods`-Count (`test_striktheit_abi_pod_guard.cpp:46`) bleibt **12** (isa ist kein eigener POD).

## 5. Geordnete Bau-Schritte (build bricht zwischendrin nicht)
0. **Freeze** `golden_fullpilot_320_binary_ids.txt` → `_abi5.txt` (additiv, verlustfrei; keine CSV anfassen).
1. **NEUE `target_isa_system_axis.hpp` additiv** (build bleibt grün, noch nicht verdrahtet).
2.–3. **ATOMARER compile-gekoppelter Kern-Commit** (alle static_asserts lock-step): `kCompositionAxisNames` 18→17
   isa raus; alle 5 `GenusBindingTraits` slot_count 18/12/14/10/6→17/11/13/9/5 + isa-Literale + CompositionFor-Arität
   −1; POD `kV3AxisCount`/Schema/sizeof/Version; `abi_adapter` Index-Shift; `source_catalog` L11 raus (`<4,4,5,4>`
   unverändert); ABI-Major/Magic; `experiment_tree.hpp:73-74` Host-Matrix [19]→[17] (räumt INC-2c-Rest mit).
4. **Test-Zahlen** (im selben Commit): `test_genus_organ_binding.cpp:47-51`→17u/11u/13u/9u/5u + `:38`
   `is_organ_axis_label("isa")` **invertieren** (in KEINE-Organ-Block); roundtrip/limits 18→17; alle sizeof
   1344u→1272u; Generator-Header.
5. **Cross-Flag-Kanal** additiv (golden-neutral): `perm_target_isa_cflags()` + `cxx_compiler` Cross-Treiber +
   `+target=`-Sidecar; `registry_to_axis_levels` isa-Ebene aus `append_organ_core_axis_levels` raus. Default
   `X86_64TargetIsa` = host==target = KEINE Flag-Änderung → golden byte-identisch zum Regen.
6. **LOKAL grün** (EIN Build, 1–4 compile-gekoppelt): volle Unit-Suite + POD/ABI-Diff-Checkpoint.
7. **golden REGEN ZULETZT** (nach grünem Build): Generator-Lauf → 320 Zeilen ohne isa, Header „ABI-6/INC-2d 17
   Slots"; `test_profile_roundtrip` (Diff==leer) grün; Mojibake-grep; cf22; super-Sub-Build; beide Remotes nach grün.

## 6. TABU-berührt (GO-Fenster) vs unberührt
**Angefasst (GO-Fenster):** kCompositionAxisNames · alle 5 GenusBindingTraits · Observer-POD+kV3AxisSchema+kV3AxisCount
· ABI-Major+Magic · golden_fullpilot_320 (Regen, Alt→`_abi5.txt`) · permutation_axes.xml (isa Organ→System-Tag) ·
source_catalog L11 · experiment_tree Host-Matrix.
**Unberührt:** `CatalogAxes<4,4,5,4>=320` Template-Params + die 4 variierenden Achsen · gemessene CSV ·
`AbiTransportPods`-Count 12 · fixture_sync-Spiegel · `HardwareIsaSystemAxis` (Host-Deskriptor) · isa-ORGAN-Codegen.

## 7. Konformitäts-Verdikt: JA
Freigabe-Prinzip (TargetIsa gibt frei / Organe ≤ Zulassung / Host-Gate prüft) · isa-als-eigene-System-Achse
(User-Ruling) · binary_id-neutral (Flags→Closure+Sidecar, golden bei Default byte-identisch) · compile-time-only
(CRTP+Concept, keine vtable, keine CT→RT-Degradierung) · messdaten-erhaltend (nur Referenz neu, CSV unberührt,
Alt-golden additiv `_abi5.txt`; ABI darf brechen). Muster identisch zu telemetry/INC-2c.

## 8. Risiken
- **Resume-Key-Invalidierung (größtes stilles Risiko):** binary_id IST der Resume-Key (#139/BR-4); jede id ändert
  sich → alte Mess-CSV/Resume-Stamps matchen nicht → ein Lauf misst neu. Erwartbar bei ABI-Fenster (wie 4→5),
  abgefedert durch `_abi5.txt`-Freeze.
- **Positions-Drift:** golden von Hand editiert statt Generator → Roundtrip bricht. **Nur** offizieller Generator-Pfad.
- **EXCLUDE_FROM_ALL-Falle:** Generator wird vom Standard-Build nicht gebaut → Regen leicht vergessen → Roundtrip rot
  (laut, gut).
- **abi_adapter Index-Shift:** alle `axis_stats`/`acc`-Indizes ≥11 um −1; ein vergessener → stiller Mess-Versatz
  (nicht compile-gefangen). Sorgfältiges Review.
- **Cross-Toolchain:** echter aarch64-Build braucht `aarch64-linux-gnu-g++`+sysroot (prod1/prod2); fehlt → Compiler-
  Compiler-Fehler ins Log (Fehlerklasse), kein Absturz; Default X86_64TargetIsa umgeht es.

## 9. Offene Entscheidungen (dem User vorgelegt)
- **[KERN-FORK] Naming/Granularität:** **A** (empfohlen) NEUE `TargetIsaSystemAxis` + `HardwareIsaSystemAxis` bleibt
  Host-Deskriptor — vs **B** bestehende `HardwareIsaSystemAxis` zur Target-Achse umbauen + Host splitten. Beide
  golden-neutral; A hält Host≠Target sauber + kleinere TABU-Fläche.
- **Von mir entschieden (kleiner):** isa-Organ-Typ bleibt (telemetry-treu); experiment_tree Host-Matrix auf 17
  reconcilen; Label-Trio `target_isa`/`hardware`/`isa`; Cross-Lauf = Kanal+Default-x86_64 jetzt, echter aarch64-Lauf
  separater Toolchain-Handover (infra=handover).
- **GAPs aufgelöst:** super-Repo golden-Spiegel = KEINER (nur ce); `_abi4.txt`-Präzedenz bestätigt.
