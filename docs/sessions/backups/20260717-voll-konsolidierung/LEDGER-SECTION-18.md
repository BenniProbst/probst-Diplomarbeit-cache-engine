## Paragraf 18 — ARCHITEKTUR-MODELL + KONSTRUKTIONSLOGIK + ENTSCHEIDUNGS-KONSOLIDIERUNG 2026-07-16/17 (autoritativ)

> **Zweck.** Reiche Voll-Konsolidierung des gesamten Kontexts 2026-07-16 (drei User-Entscheidungsrunden §12 + F/E-Runden + §16-Konsolidierung + gebaute Increments I1–I4) UND 2026-07-17 (die 6 §17-Antworten LED:370, die rekursive Dock-Schärfung LED:369, die Konstruktionslogik-Durchdringung LED:368/wf_83ed4865). Dies ist **KONSOLIDIERUNG des Bestehenden, KEIN Neu-Entscheiden**: jede Aussage ist verbatim-treu zu den User-Aussagen und belegt.
>
> **Vorrang-Regel.** Bei Widerspruch zwischen Dokument-Stellen gilt **Paragraf 18 + die verbatim-treuen User-Aussagen** (LED:368–370 §12-Kopf 2026-07-17; §16.1–16.4). Insb. kehrt der User-Entscheid F2 (LED:370) die frühere Vorlage-Annahme „golden-erhaltend" um → **golden wird ZERLEGT + UMGEBAUT** (mit GO; Messdaten nie löschen).
>
> **Verweis / Geltungsbereich.** Paragraf 18 **erweitert** und synthetisiert §16 (16.1–16.4, Index §16.6 LED:1492–1513) und §17 (die 6 gestellten Punkte, hier via LED:370 aufgelöst). Autoritäre Quellen: Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` §12-Kopf LED:368–370 + §16 (Z.1339–1459) + §17.E (LED:1543–1547); Dossiers `docs/sessions/backups/20260717-konstruktionslogik-durchdringung/{KONSTRUKTIONSLOGIK,F12III-DESIGN-VORLAGE}.md` + `docs/sessions/backups/20260716-*`; Memories [[feedback_recursive_dock_planer_ceb_tier_abi_stable_so]], [[feedback_ceb_config_cmake_interface_static_registry_paths_prt_module]], [[feedback_gattung_own_genus_own_abi_nonintersecting_mutually_usable]], [[feedback_serialization_flat_systemaxis_folders_deep_tier_tree_dynamic_only_columns]], [[feedback_system_axes_measurement_own_abstract_root_blood]], [[feedback_measurement_modes_debug_parallel_measure_singlethread_planer_generates_ci_cmake]], [[feedback_measurement_failure_visibility_csv_failed_not_null_plus_log]], [[project_mess_ergebnis_rueckschreibung_pipeline_persistiert]], [[feedback_no_runtime_switch]], [[feedback_compile_time_only_no_runtime]], [[feedback_crtp_concept_guard_mix_pattern]], [[reference_meta_driven_concept_hardening_pattern]], [[feedback_vendoring_doctrine_ordered_vendor_faithful_selfcontained]], [[feedback_infra_cleanest_not_easiest]], [[feedback_messdaten_nie_loeschen_abi_darf_brechen]], [[feedback_raw_data_backups_additive_never_delete]], [[feedback_only_one_official_xml_driven_program_no_behelfswege]], [[feedback_vor_aufgaben_erst_projektstruktur_analyse]], [[feedback_ci_gruen_messfaehig_nur_punktuelle_refactorings]], [[feedback_e_schichten_separat_fertigstellen_top_down]]. Code-Zitate rel. `Code/external/comdare-cache-engine/libs/cache_engine/` (Ausnahmen ausgeschrieben).

---

## 18.1 DAS DEFINITIVE ARCHITEKTUR-MODELL (User 2026-07-16/17, autoritativ)

### 18.1.1 Rekursive Dock-Topologie — dasselbe Muster auf zwei Ebenen
REKURSIVES Dock-/ABI-stabile-.so-/Vertrags-Muster ([[feedback_recursive_dock_planer_ceb_tier_abi_stable_so]]; LED:369 „USER-SCHÄRFUNG um ganz sicher zu gehen"):

- **Ebene 1 — EXPERIMENT-(PLANER-)DOCK (Planer ↔ CEB), EINDIMENSIONAL.** Der Planer hat ein Dock für C++23-ABI-stabile CEB-.so-Programme; er STEUERT die Einstellungen der von ihm kompilierten CEB (Planer → CEB, **KEIN Rückkanal**), bestückt jede CEB mit verschiedenen System-Achsen(+Unter-Achsen)-Algorithmen+Einstellungen → verschiedene CEB-Varianten je System-Achsen-Wahl (LED:368 „DOCK-TERMINOLOGIE-SCHÄRFUNG"; Dossier KONSTRUKTIONSLOGIK.md NACHTRAG 2026-07-17).
- **Ebene 2 — PRÜF-DOCK (CEB ↔ Tier-Binary), BIDIREKTIONAL.** Die CEB ist selbst eine ABI-stabile .so, **SYSTEM-ACHSEN-VERSIONIERT**, mit eigenem bidirektionalem Prüf-Dock zu ihren Tier-Binary-.so-Interfaces (CEB treibt an ↔ Tier-Binary meldet ABI-stabil zurück); dort kompiliert die CEB die C++23-ABI-stabilen Tier-Binary-.so-Module.
- **Ergebnis-Rückschrieb NICHT über das eindimensionale Experiment-Dock.** Die CEB schreibt nach Planer-Bestimmungen die angeforderten Aufgaben + Messwerte **SELBST** an das in der XML eingegebene Ziel zurück (LED:368/369; verknüpft §11-G `measurement/<YYYYMMDD-HHMMSS>/`, Write-Token id=54, Loop-Schutz `[skip ci]`+`_bot_`; [[project_mess_ergebnis_rueckschreibung_pipeline_persistiert]]).

⇒ = dasselbe Muster REKURSIV (Planer→CEB gespiegelt zu CEB→Tier, geteilte Concepts). Der **Anatomy-Major 4→5 reitet am Experiment-Planer-Dock** gegenüber der CEB-Messsystem-Erstellung (LED:369/370). **Ist-Delta:** benannter „Planer-Dock" im Code NOCH NICHT (grep `Planer/planner/AnatomyMajor` in `libs/` leer); reale Naht = `profile_facade/experiment_run_entry.hpp:93` → `cache_engine_builder_iterator.hpp:668` (hier Golden-Zerlegung); ABI-Major heute **4** (`include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp:43-44`), 4→5 ungebaut.

### 18.1.2 CEB-System-Achsen ⊃ Tier-Binary-Achsen — die zentrale Soll-Schichtung
Modell: `System-Achsen (CEB-Ebene, compile-time-STATISCH, versioniert) ⊃ Tier-Binary-Achsen (Organ + Governor/Prefetcher)`, verbunden über den Prüf-Dock-ABI (Dossier §6; LED:370 F2). Die CEB wird UNTER ihren System-Achsen gebaut; das bestimmt, wie die Tier-Binaries untergeordnet ebenfalls STATISCH gebaut werden. Kompile-Reihenfolge: die CEB kann verschiedene Gattungen bauen+durchmessen, muss aber VORHER auf deren Observer+Module kompiliert werden — **System-Konfiguration → Mess-Achsen-heuristische-Konfiguration** ([[feedback_recursive_dock_planer_ceb_tier_abi_stable_so]] Z.16; LED:369).

**Die vier CEB-System-Achsen (User 2026-07-16/17, LED:370):**
- **Scheduling (#37)** = zunächst SYSTEM-Achse, unter der die CEB gebaut wird (LED:370 F2). — Ist: `ISchedulingStrategy` RUNTIME-VTABLE (`include/cache_engine/concepts/scheduling_strategy.hpp:37-46`), NIRGENDS konsumiert (Doktrin-Verletzung [[feedback_no_runtime_switch]]) → durch compile-time-CRTP-System-Achse ersetzen/deprecaten.
- **Telemetrie (F12iii)** = SYSTEM-Achse in der CEB (LED:370; = entparktes #29). — Ist: Organ-Slot T10 (`anatomy/composition_factory.hpp:62`) → aus `binary_id` herauslösen (POD/kV3AxisSchema-Bruch; Design-Vorlage `F12III-DESIGN-VORLAGE.md`, GATED nach User-Gegenprüfung).
- **Hardware/ISA/AVX (H-7/H-10)** = System-Achse, treibt den Compiler: eine Tier-Binary wird durch eine CEB-System-Achse STATISCH für system-passende Optimierungen kompiliert (AVX512 + weitere Befehlssatzerweiterungen speziell einkompiliert ODER zum Performance-Vergleich bewusst NICHT — „volle Kontrolle"; LED:370 H-7). — Ist: `build_orchestrator.hpp::make_gpp_compile_fn` ohne `-march`/`-mavx` (`:474-483`), Binary faktisch generisch `-O2`.
- **Last/Last-Frameworks (H-9)** = die Wahl der Lasten und Last-Frameworks ist ebenfalls System-Achse in der CEB (LED:370).

**Tier-Binary-Achsen** = Organe (permutieren `binary_id` über 19 Slots) + Governor/Prefetcher. **H-8:** Governor+Prefetcher = Tier-Binary-Achse; der Governor ist Teil des Strategy-Pattern bzw. der automatischen Heuristik-Command-Pattern-Einschätzung eines (virtuellen) Tier-Binaries (LED:370). Tier-Binaries zwei Formen: **(a) heuristisch** — noch EINE Ebene NACH dem Command-Pattern in einer compile-time Chain-of-Responsibilities (virtuell) ODER **(b) plain** am CEB-Prüf-Dock ([[feedback_recursive_dock_planer_ceb_tier_abi_stable_so]] Z.15; LED:369). **H-1/P-E-Core (CPUID 0x1A):** separate System-Achse, aber DYNAMISCHE Unter-Achse unter der Hardware-System-Achse (§16.3-E17 LED:1424). — Ist-Delta: KEINE Schichtung — `builder/experiment_tree/registry_to_axis_levels.hpp::build_all_axis_levels` reflektiert 26 Achsen FLACH in einer `std::vector<AxisLevel>`; `is_static`-vs-dynamisch ist eine **Organ**-Zweiteilung (`experiment_tree.hpp:189-203`), KEINE System/Organ-Schichtung. Andockpunkt: `build_system_axis_levels()` mit eigener abstrakter Wurzel abspalten (Organ vs System nie mischen, [[feedback_system_axes_measurement_own_abstract_root_blood]]).

### 18.1.3 Prüf-Dock-ABI-Vertrag — 3-teilig
CEB ↔ ABI-stabile Tier-.so, DREI Teile (Dossier §4):
- **(a) Befehl** — was/welche Last: `PruefDockMeasureOptions = AbiTierTraceConfig` (`anatomy/pruef_dock.hpp:33`, `anatomy/tier_observe_trace_abi.hpp:33-43`), host-getriebene Last (NICHT in der Binary).
- **(b) Settings** — dynamische System-Einstellungen: flacher POD `ComdareResourceControlV1` (`anatomy/resource_controllable_tier.hpp:34-43`, 6× uint64, `standard_layout`+`trivially_copyable`), ABI `IResourceControllableTier`, **IMMER verfügbar** (auch Messung-AUS).
- **(c) Rückkanal** — ABI-stabil zurück: `tier_observe(ComdareTierObserverSnapshot*)` (`anatomy/observable_tier.hpp:181`), EIN konsolidierter POD, verifiziert **sizeof==1416 / alignof==8**, memcpy über DLL-Grenze, Spalten-Vertrag `kV3AxisSchema[19]`.

Die ABI-Grenze ist **NICHT** `IPruefDock` (Builder-vtable, `pruef_dock.hpp:10-14`), sondern das **gattungs-eigene Antriebs-Sub-Interface + POD-Snapshot**. Loader `AnatomyModuleLoader`: `dlopen(RTLD_NOW|RTLD_LOCAL)`, 4 Pflicht-Symbole, Magic `0x434F4D444141342E` (".A4."), Major=4 (`anatomy_module_loader.cpp:106-157`). **H-9/PF1:** die runtime der CEB als Unter-Achse befehligt eine Tier-Binary am Prüf-Dock (was ausführen, welche Last aus welchem Framework — die CEB hat die Daten vorbereitet); die Tier-Binary sendet Messergebnisse ABI-stabil zurück (LED:370 F5/H-9). — Ist-Delta: Lazy-Iterator umgeht `IPruefDock`, castet direkt (`cache_engine_builder_iterator.hpp:750-756`); nur `SearchAlgorithmDock` existiert („Set/Sequence/Adapter/View kommen mit V42", `pruef_dock_registry.hpp:4-5`).

### 18.1.4 Allokatoren = Algorithmen der Allokator-Achse (axis_06)
Modell-konform (Dossier §2): der Wrapper IST die Algorithmus-Wahl (Strategy als compile-time Typ). `MimallocAllocator : AllocatorStrategyBase<MimallocAllocator>` (`axes/alloc/axis_06_allocator_mimalloc.hpp:61-62`), reines **CRTP + Concept-Guard, KEIN vtable**; An/Aus compile-time (`static constexpr bool enabled = flags::mimalloc_enabled`, Z.83, OFF-Shim `vendor_includes/mimalloc_include.hpp:20-36`, W6-Pattern, kein `#ifdef`). 26 Wahlen = EINE Boost.MP11-Liste `AllVendors = mp_list<…>` (`axis_06_allocator_registry.hpp:78-100`), gefiltert `EnabledVendors = mp_filter<is_enabled,…>` (Z.117); Codegen backt pro Tier-Binary genau EINE Wahl statisch je `perm_<id>.cpp` ([[feedback_no_runtime_switch]], [[feedback_compile_time_only_no_runtime]]). Der externe Vendor-Objektcode ist genau der DLL-Load-Bruch (→ 18.2.3).

### 18.1.5 Gattungen Ebene-1 + Kopf-Framework + View
Es gibt IMMER ein **Kopf-Framework aus gemeinsamen Gattungs-Concepts je Ebene-1-Gattung**: map (= SearchAlgorithm-Hülle), (sequential) container, set, graph, … (LED:370 F2). Prinzip ([[feedback_gattung_own_genus_own_abi_nonintersecting_mutually_usable]]; §16.3-E18 LED:1430): jede Gattung = eigenes Genus mit EIGENER ABI, nur teilweise wiederverwendete Observer; Gattungen schneiden sich untereinander NICHT (distinkte Außen-Hülle), dürfen sich aber gegenseitig VERWENDEN. Set = eigenes Genus mit eigener ABI (**NICHT** Sub-Typ von Sequence); map / container(=vector=Sequence) / Set = getrennte Gattungen. **View = „nur lesen" aus einem sequential container** (LED:370; `genus_binding_traits.hpp:135-152` non-owning). — Ist-Delta: Ebene-1 `AnatomyGattung` heute NUR **3** (SearchAlgorithm=0/Container=1/Graph=2, `anatomy/anatomy_base.hpp:40-44`); Set = Ebene-2-Genus UNTER Container (`gattung_of(Set)→Container`, Z.100-109), obwohl bereits eigene ABI (`ISetTier`/`SetObserverSnapshotV1`, `GenusBindingTraits<Set>` slot_count=15). Ebene-1-Promotion = koordinierter ABI-4→5-Schritt **F1b**; „die Gattungen und deren Durchsetzung ist UNVERHANDELBAR"; **F1a DONE** (ce `f4d87059→dad91fe5`), **F1b-GO GEWÄHRT** (MAJOR, Design VOR golden/ABI-Änderung vorlegen, koordiniert mit #37 + F12(iii)=entparktes #29; §16.3-E18).

### 18.1.6 Golden zerlegt + umgebaut + Serialisierung
Golden wird **ZERLEGT + UMGEBAUT** (NICHT golden-erhaltend — bewusster Umbau MIT GO; Messdaten nie löschen; LED:370 F2 — kehrt §17.B-1-„golden-erhaltend" um). Naht `run_experiment_profile` (Dossier §7). Serialisierung (§16.2-M2/Q LED:1385/1403; [[feedback_serialization_flat_systemaxis_folders_deep_tier_tree_dynamic_only_columns]]): System-Achsen **FLACH** als Ordnerstruktur; Tier-Binary-Achsen + CSV als **tiefer** serialisierter Permutationsbaum; statische compile-time-Achsen + System-Achsen NICHT als Spalten (Redundanz) → in Ordner+Datei-Beschriftung/Metadaten; NUR dynamische Unter-Achsen (Workload/RC/P-E-Core/NUMA/Multithreading) bleiben Spalten. **Q1** = flach je Binary + Sidecar-Manifest + Baum-Index; **Q2** = statische per-Achsen-Spalten RAUS (kehrt E1 um; Baum wandert in den Planer); **Q3** additiv gespiegelt (Host→OS→Toolchain→ISA, schützt `test_profile_roundtrip==320`); **Q4** On-Disk-Baum+Index + build→ziel-Copy. **Reihe C = Option C** (SdT-vs-Prüfling-View UND build-über-Build-Regression, KEINE 4. Stufe, `MergeStrategy` bleibt 3-Enum; §16.3-F3i LED:1418).

### 18.1.7 Versionierung/Metadaten je statischer Kompilation (H-10) + Mess-Verfahren
**H-10:** AVX10-Versionsfeld JA; die statische Kompilation einer CEB ODER Tier-Binary ist IMMER zu **VERSIONIEREN** und in Metadaten NEBEN diesem Binary zu dokumentieren (LED:370). Vorhanden: ABI-Sidecar `BuildVariantDefinitionV1` (simd_width/avx512, Kohärenz-Guard `declared_extension_matches_build<SE>()`), `.version`-Sidecar, `write_provenance_manifest` (isa_built_for/ran_on/compiler/git-SHAs; Dossier §8); Delta: heute global statt per-Binary → per-Binary-Subdir + AVX10-Feld. **Mess-Verfahren** (§16.2-M1 LED:1379; [[feedback_measurement_modes_debug_parallel_measure_singlethread_planer_generates_ci_cmake]]): Debug = alle Threads parallel; Mess = 1 Mess-Thread (Gattungs-Threading aus der Tier-Binary, nicht Harness-überschrieben); Messung NIE als Nullen abschalten; der Planer generiert aus DERSELBEN XML den CI- ODER cmake-Code (**PF2:** Runner = ISA×OS×alle-System-Achsen, disjunkte Runner parallel über ISA, concurrency 1 je Mess-Maschine; **PF3** stabil-zuerst; **PF4:** Index-Manifest = XML; LED:370). **Fehler-Sichtbarkeit** (§16.2-M4 LED:1397; [[feedback_measurement_failure_visibility_csv_failed_not_null_plus_log]]): gescheiterter Achsen-Algorithmus → CSV-Zelle **„failed"** (NICHT null) + aggregierter Log neben der CSV (macht Verprogrammierung ODER ISA+OS-Inkompatibilität sichtbar).

### 18.1.8 Baumaterial-Bereitstellung / Planer = 3. Framework-Anwendung
Pfade per CMake-Interface als statische, dokumentierte Pfade — NICHT env, NICHT Co-Location ([[feedback_ceb_config_cmake_interface_static_registry_paths_prt_module]]; §16.1-C1 LED:1351). **2-Registry-Kanon:** je CacheEngine UND je PRT-ART eine Achsen-Registry-XML (super `Code/02_messung_driver/CMakeLists.txt:33-34`: `COMDARE_CE_AXIS_REGISTRY_PATH` + `COMDARE_PRT_AXIS_REGISTRY_PATH`, verschiedene Verzeichnisse → per-Engine-Auflösung, KEIN gemeinsames `registry_dir/<filename>`). PRT-ART = ein MODUL der CacheEngine, per XML **full-join additiv je Phase** compile-time an die ce-Achsen kompiliert (Familie-C via `PrueflingSlot`, nie hart verdrahtet, nie Surrogat; §16.1-C4 LED:1369). Die XML nennt explizit **NUR EINEN Pfad**: den Ergebnis-Ziel-Ordner; Ergebnisse erst statisch im BUILD-Pfad, dann atomarer build→ziel-Copy in `<output>` (§16.1-C2 LED:1357, §16.2-Q4). Der **Experiment-Planer = versteckte root-Minimal-Binary** aus der Anwender-CMake-Konfig aus ce-Bibliotheken → XML-ABHÄNGIGES Build der Diplomarbeit; CEB+Tier-Binaries untergeordnet als tiefe Build-Struktur = **die 3. Framework-Anwendung** (§16.1-C3 LED:1363). — Ist: Planer-Executable existiert NICHT (`parse_experiment_profile` nur test-/`--validate`-verdrahtet; CoR `selection_filter_chain.hpp` unverdrahtet).

---

## 18.2 KONSTRUKTIONSLOGIK IST ↔ SOLL (Deckung ~70 %, Schichtungs-Delta, DLL-Load=B, 4→5-Umbau)

### 18.2.1 Deckungs-Befund: ~70 % modell-konform (Fundamente da, SCHICHTUNG fehlt)
Ist deckt das USER-KONSTRUKTIONS-MODELL 2026-07-17 zu **~70 %** (LED:368 „Fundamente da, SCHICHTUNG fehlt"). KONFORME, code-belegte Fundamente:

| Fundament | Beleg (Ist) | Doktrin |
|---|---|---|
| **CRTP+Concept-Hot-Path, kein vtable** | Organ-Achse = topic-CRTP-Basis erbt `topics::AxisBase` (`topics/axis_base.hpp:52-79`), protected-Ctor `static_assert`t 3 Concepts (`axes/prefetch_axis/axis_07_prefetch_strategy_base.hpp:11-18`); monomorphisiert je Punkt `AnatomyPermutationDriver::for_each_composition_type` (`anatomy/anatomy_permutation_driver.hpp:76-81`) | [[feedback_crtp_concept_guard_mix_pattern]], [[reference_meta_driven_concept_hardening_pattern]] |
| **binary_id über 19 Organ-Achsen** | `using`-Slots T0..T18 (`anatomy/composition_factory.hpp:49-74`); `kCompositionAxisNames` `std::array<…,19>` (`builder/experiment_tree/axis_path_serialization.hpp:30-34`); `PermTuple<V0..V18>`, `static_assert(sizeof...==19)` (`:87-109`) | — |
| **Allokatoren = Algorithmen axis_06** | siehe 18.1.4; EINE MP11-Liste, `EnabledVendors` compile-time gefiltert | [[feedback_no_runtime_switch]] |
| **Prüf-Dock-ABI 3-teilig** | siehe 18.1.3; Snapshot sizeof==1416/alignof==8, Loader Magic `.A4.` Major-Match | — |
| **H-10-Build-Variant-Metadaten** | `BuildVariantDefinitionV1`, `.version`-Sidecar, `write_provenance_manifest` | — |
| **Dyn. System-Unter-Achse via Prüf-Dock (H-9)** | `IResourceControllableTier`+`AlgorithmResourceControl` SAUBER; host-getrieben min(tier-caps, env_limits) in `run_lazy_static_then_dynamic` (`cache_engine_builder_iterator.hpp:668-819`) | — |

### 18.2.2 DAS DELTA = fehlende SCHICHTUNG (die 4 CEB-System-Achsen sind KEINE gemeinsame Schicht)
Kernbefund (KL §6): heute KEINE Schichtung — `registry_to_axis_levels.hpp::build_all_axis_levels` (Z.81) reflektiert **26 Achsen FLACH** in einer `std::vector<AxisLevel>`; die einzige Zweiteilung `is_static` vs. dynamisch ist eine **Organ**-Zweiteilung, KEINE System/Organ-Schichtung. Die 4 CEB-System-Achsen liegen verstreut ([[feedback_system_axes_measurement_own_abstract_root_blood]] — Organ vs System nie mischen):

| CEB-System-Achse | Ist-Zustand | Delta |
|---|---|---|
| **Telemetrie** (F12iii) | Organ-Slot T10 (`composition_factory.hpp:62`), permutiert binary_id; Mess-Telemetrie separat `ObserverSnapshotSystemAxis`/`PmcSystemAxis` | permutiert binary_id statt System-Achse zu sein |
| **Hardware/ISA** (H-7/H-10) | gespalten: `isa` T12 Organ-Slot + 3 build-only `DefinitionOnly`-Achsen; `make_gpp_compile_fn` **KEIN `-march`/`-mavx`** (`build_orchestrator.hpp:474-483`) → Binary generisch `-O2` | H-7 (gezielt kompiliert) nicht realisiert |
| **Scheduling** (#37) | `ISchedulingStrategy` = **RUNTIME-VTABLE** (`include/cache_engine/concepts/scheduling_strategy.hpp:37-46`), **NIRGENDS konsumiert** | doppeltes Delta: verwaist + laufzeit-polymorph, **verletzt** [[feedback_no_runtime_switch]]/[[feedback_compile_time_only_no_runtime]] |
| **Last/Last-Frameworks** (H-9) | ABI-Antrieb via `run_workload`/`WorkloadOrchestrator`; `workload`-DynDim organ-dynamisch | Antriebspunkt, nicht System-Achse |

Weitere Delta-Achsen: **Ebene-1-Gattungen = 3 statt 4** (Set = Genus UNTER Container, F1b-Promotion ausstehend; „map=SearchAlgorithm-Hülle" ✓, „View=read-only aus sequential container" ✓); **ABI Major = 4** verifiziert, **4→5-Bump + „Experiment-Planer-Dock" im Code NOCH NICHT** (grep leer, reale Naht `experiment_run_entry.hpp:225-251`, HIER wird Golden zerlegt); **Prüf-Dock heute umgangen** (Lazy-Iterator castet direkt `cache_engine_builder_iterator.hpp:750-756`; nur 1 von 3 Gattungs-Docks).

### 18.2.3 DLL-Load = OPTION-B-AUFLÖSUNG (INC-0, ABI-4-kompatibel)
**Bruch** (KL §9): zwei Wege `perm_<id>.cpp`→`.so`, nur einer linkt den Allokator. **(A-Bau) CMake `add_library(SHARED)` self-linkt** (`tools/permutation_codegen/codegen.cmake:584`, `target_link_libraries … comdare::vendor_mimalloc` `:607-613`, statisches Archiv `MI_STATIC_LIB=1` PIC) → `mi_*` definiert. **(B-Bau) Laufzeit `make_gpp_compile_fn` bricht** (`build_orchestrator.hpp:466-489`: `.rsp` nur `-std=c++23 -O2 -fPIC -shared -fno-gnu-unique`, **kein `-l`, kein Archiv**; `BuildJob` `:86-92` **kein Link-Input-Kanal**) → `mi_*` undefined → `dlopen(RTLD_NOW|RTLD_LOCAL)` scheitert `undefined symbol: mi_malloc_aligned`. Das ist der Produktions-Golden-Pfad (`profile_run_facade.cpp:154`) und die Ursache von **`measured=0`** (§17.E LED:1543-1547).

**EMPFEHLUNG Option B** (DLL self-linkt Allokator; User tendiert B, LED:370 F1). Option A (`-rdynamic`/Host-Export) ist **doktrin-widrig an 5 Stellen**: (1) bricht Allokator-als-Algorithmus-Achse — EINE prozessweite mimalloc-Instanz, Arena/Thread-Cache-Kontamination Perm N−1→N → **verfälschte Achsen-Messung**; (2) bricht Destroy-Vertrag (`dlclose` gibt Arenas nicht zurück); (3) verletzt self-contained-ABI ([[feedback_vendoring_doctrine_ordered_vendor_faithful_selfcontained]]); (4) bricht H-10-Wahrheitsfähigkeit; (5) koppelt statisches Dispatch an Runtime-Symbol-Resolution. **B** = faire pro-DLL-Isolation unter `RTLD_LOCAL` (mi_* privat), sauberer `dlclose`-Teardown, self-contained, wahrheitsfähiges H-10, **bereits bewiesener CMake-Pfad** ([[feedback_infra_cleanest_not_easiest]] „einfachster ≠ sauberster"). **Fix (Struktur-Lücke):** `link_libs`/`link_inputs`-Feld durch `make_gpp_compile_fn`/`BuildJob` + Fassade backt `$<TARGET_FILE:comdare::vendor_mimalloc>` (Muster `COMDARE_FACADE_PERM_INCLUDES`, `profile_facade/CMakeLists.txt:131-138`), an `.rsp` nach der Quelle; `--whole-archive` i.d.R. unnötig. **Rein additiv, ABI-4-kompatibel, sofort autonom (INC-0), verify-first.**

### 18.2.4 Der koordinierte 4→5-UMBAU-PLAN (EIN Bruch, nicht vier)
Vier Verschiebungen brechen ALLE dieselbe ABI-Grenze (Modul-Symbole + POD-Layouts + Gattungs-Diskriminator + binary_id-Konvention); einzeln = TABU-Grenze 4× berühren + Golden 4× neu materialisieren → **EIN gemeinsamer Bruch am Experiment-Planer-Dock** (F12III-VORLAGE §1). TABU: Major 4→5 + Golden-Byte-Ordnung nur mit koordiniertem GO; Doku/Messdaten nie löschen ([[feedback_messdaten_nie_loeschen_abi_darf_brechen]], [[feedback_raw_data_backups_additive_never_delete]]). Der Anatomy-Major reitet am Experiment-Planer-Dock gegenüber CEB-Messsystem-Erstellung (LED:370 autoritativ; Golden ZERLEGT+UMGEBAUT, nicht -erhaltend).

**Gemeinsam beim Bump** (F12III §3):
- **F12iii — Telemetrie als CEB-System-Achse:** T10 raus aus `kCompositionAxisNames` → neue Achsen-Zahl → neues `kV3AxisSchema` + neuer Snapshot-`sizeof` (heute 1416) = **POD-Layout-Bruch = ABI-Major-Bruch** (`observable_tier.hpp`). `TelemetryConfig{Active/Silent}` ist bereits richtige Semantik; gemeinsame Wurzel = `measurement::SystemAxis` (golden-neutral, immer präsent); Telemetrie-Wahl NEBEN dem Binary versioniert (H-10), nicht binary_id-Segment.
- **F1b — Set-Ebene-1-Promotion:** `Set` als eigenes `AnatomyGattung`; `gattung_of()` faltet Set NICHT mehr → Container (`anatomy_base.hpp:40-44,100-109`).
- **F2 — Set-ABI:** gattungs-eigenes `ISetTier` (Antrieb) + Set-POD + `SetDock` in `PruefDockRegistry`.
- **#37 — Scheduling als compile-time CEB-System-Achse** (CRTP+Concept, kein vtable), ersetzt verwaiste Runtime-vtable; alte `ISchedulingStrategy` **deprecaten** (nicht löschen — einzige der 4 vtable-Achsen OHNE Deprecated-Marker, anders als deprecatete Schwestern `numa_affinity`/`locking_mode`/`hardware_strategy` „DEPRECATED 2026-07-16 V32.EE.5") → stellt [[feedback_no_runtime_switch]] wieder her.

Neue Marker `COMDARE_ANATOMY_ABI_MAJOR 5`, Magic `.A5.`; Loader-Gate verwirft alle ABI-4-DLLs sauber. ABI-Grenzen (F12III §4): Prüf-Dock ist KEINE Grenze (`pruef_dock.hpp:10-14`, Builder-Binary); Grenze = **gattungs-eigenes Antriebs-Sub-Interface (vtable-stabil) + flacher POD (memcpy)**. Frei umbaubar: `IPruefDock`, `AnatomyPermutationDriver`, `BuildOrchestrator`, `registry_to_axis_levels`, gesamte CRTP-Kompositionslogik. **H-7-Compiler-Kopplung:** `make_gpp_compile_fn` um `-march`/`-mavx…` aus System-Achsen-Belegung (injizierte `CompileFn` = sauberer Engine-agnostischer Ort). **H-10 per-Binary-Sidecar:** `BuildVariantDefinitionV1` um AVX10-Feld, ins per-Binary-Verzeichnis (heute global).

**Golden-Neubau messdaten-erhaltend** (F12III §5): `golden_fullpilot_320` = `CatalogAxes<4,4,5,4>` (`source_catalog.hpp:113`) — 320 = L00 search_algo(4)·L04 node_type(4)·L05 memory_layout(5)·L07 prefetch(4), 15 Slots gepinnt, fix `isa=isa_amd64`+`telemetry=leaf_only_counter`, alle Genus SearchAlgorithm; Gate `test_profile_roundtrip.cpp`. Umbau bricht Golden 3-fach (System-Achsen isa/telemetry verlassen Pfad; F1b-Gattung-Diskriminator; Major 4→5). **Regenerierungs-Plan:** (1) `…_abi4`-Fixtures+Mess-CSV/PDF **additiv einfrieren** unangetastet; (2) `serialize_composition_path`/`kCompositionAxisNames` **erweitern statt ersetzen**; (3) EINMALIG neu materialisieren je Gattung (`golden_abi5_map_/_set_/_sequence_`) via `gen_golden_fullpilot.cpp`; (4) Gate umhängen, alt als historische Referenz behalten.

**Increment-Schnitt** (je Schicht testbar, [[feedback_e_schichten_separat_fertigstellen_top_down]]): **INC-0** (ABI-4-kompat, kein GO) DLL-Load-Fix B + F6-Nachzieh · **INC-1** (ABI-4-kompat) `build_system_axis_levels()` abspalten + H-7-Kopplung + H-10 per-Binary-Sidecar · **INC-2** (koordiniertes GO, EIN Backup/Review) Experiment-Planer-Dock einziehen, `IPruefDock` scharf, F12iii+F1b+F2+#37 gemeinsam, Major 4→5 · **INC-3** Golden additiv einfrieren + neu materialisieren je Gattung · **INC-4** Sequence-/Container-/Graph-Dock (V42). Jeder Increment endet CI-grün+messfähig, nur punktuelle Refactorings, keine Parallelstruktur ([[feedback_vor_aufgaben_erst_projektstruktur_analyse]], [[feedback_ci_gruen_messfaehig_nur_punktuelle_refactorings]]).

---

## 18.3 ENTSCHEIDUNGS-INDEX 2026-07-16/17 (kompakt; Legende: DOK belegt · NACHGEHOLT §16-verankert · GEBAUT Code gelandet · GATED/GEPARKT offen)

### 18.3.1 TAG 2026-07-16 — S/F/E-Runden (§12, verbatim; LED:381/384/385)

| ID | Kurzform | Beleg/Status |
|----|----------|-------|
| **S-1** | (b) beides — Scheduling-Systemachse jetzt (golden-neutral); #37-A-Organ-Achse separater TABU-Entscheid | LED:381 · DOK |
| **S-2** | 3 vtable-Header deprecaten + Registry auf Live-Substanz + 4 Pflicht-Systemachsen NEU bauen (CRTP, in CEB) | LED:381 · GEBAUT (ce `780459ec`) |
| **S-3** | (a) Registry-Achse-14 umbenennen/kommentieren (Betriebswahl ≠ Prüfstufe) | LED:381 · GEBAUT |
| **S-4** | wie empf. (keine Kategorie-Erweiterung 1. Schritt) + TODO eigene Mess-Kategorie später | LED:381 · DOK |
| **S-5** | Experiment-Planer = XML-Interpreter/Konfigurator, kompiliert CEB compile-time-optimiert, baut VERSCHIEDENE CEB je Systemachsen-Komb.; Stufe CEB→Tier als Planer→CEB nachgebaut; geteilte Concepts | LED:381 · DOK |
| **S-6** | strikt gcc\|clang erst; +dynamisch je Compiler-VERFÜGBARKEIT erweiterbar (runtime-Unter-Achse) | LED:381 · DOK |
| **S-7** | PFLICHT deep-research+ultracode; Achse in Suchalg.- UND Container-Gattung echt; alle Gattungen Observer echt. **RUHT** → Opus-Session (Fable-Safety blockte Web-Recherche) | LED:381 · GEPARKT |
| **F1** | JA+ERW: `<phases>` 1..∞; CE-Framework = BIBLIOTHEK, per XML „Programmierung" von Experimenten + Auswertung | LED:384 · DOK |
| **F2** | Serie = Variante 1 (Envelope-Root) | LED:384 · DOK |
| **F3** | (i) 4. merge-Wert erst untersuchen (→§16.3-F3i: KEINE 4. Stufe); (ii) 4 CEB-Betriebsmodi als XML-Element PFLICHT (Dossier 19) | LED:384 · DOK |
| **F4** | Option 3 (Reparatur) — erst Revert `804aa3c2` ultracode-untersuchen → Rückfrage | LED:384 · GATED |
| **F5** | JA (#35→#38→#37) + AUDIT der Fassaden-Kette | LED:384 · GEBAUT (#35 R1) |
| **F6** | JA+GROSS: XML steuert CI via INTERPRETER; JEDES CE-Feature XML-unterstützt + je Schritt CI-getrackt | LED:384 · DOK |
| **F7** | (i) 4 .py erst nach XML-Ersatzbeweis löschen · (ii) jemalloc NICHT löschen→Allokator-Achse · (iii) ZIH-README benötigt · (iv) Behelfs-Tier nach P5 | LED:384 · teils GATED |
| **F8** | GO je-Repo: 4 Branch-Löschungen (nur main+development behalten) | LED:384 · DOK |
| **F9** | ENTSPERRT: perf-Messung PFLICHT für alle Ergebnisse, Infra fertig, Agent darf installieren | LED:384 · DOK |
| **F10** | ICH baue B/E + LaTeX-Schnittstelle: Messabschnitt aus fixem Output ins Overleaf-Git, je Messung überschreiben | LED:384 · DOK |
| **F11** | 48er verworfen, Thesis-Set kanonisch + Ist-Stand überall updaten | LED:384 · DOK |
| **F12** | (i) DEADLINE 28.07.: CI+standalone messbar, cmake+C++23, EINE Maschine · (ii) 2 ABI-Schutz-Vermerke JA · (iii) ABI-Grenzen gemeinsam planen (=#29) · (iv) 4 Kleinpunkte wie vorgeschlagen | LED:384 · DOK |
| **E1–E16** | CSV-Spalten/`;phase;engine` (E1, *später §16.2-Q2 umgekehrt*); Welch=eigene Stufe (E2); n_repeats≥3 PFLICHT (E3); Root-Tag-Sniff+env, EINE XML→alles „Firmware-Compile" (E4); (merge,lebewesen)-Overloads (E5); op_types via kOpTypeTable fail-loud (E6); Single-Source 320er (E7); gemeinsame `e4_xml/measurements.csv` (E8); DoD-7+Experiment-Serie-Schema (E9); erst offizielle Strecke, dann V32 zurück (E10); Phasen>3 FALSCH→ultracode (E11); permutation_axes read-only (E12); „#37-3-Achsen" ultracode (E13); Branches prüfen+mergen statt löschen (E14, Audit: 0 Merges LED:1287); C2/Grace-Hopper §8 (E15); echte Workaround-Tilgung (E16) | LED:385 · DOK |
| **E17–E21** | GEPARKT, später aufgelöst: E17→§16.3-E17 (P/E-Core dyn. Unter-Achse) · E18→§16.3-E18 (Set eigenes Genus, F1b GEWÄHRT) · E19→§16.4-E19 (Löschpolitik behalten) · E20 #35→#38→#37 · E21 Anhänge-B/E gated | LED:385 |

### 18.3.2 §16-Konsolidierung (autoritativ; Index §16.6 LED:1492-1513)

| ID | Kurzform | Status/Beleg |
|----|----------|-------------|
| **§16.1-C1** | 2 Registries + XML per CMake-Interface = STATISCHE Pfade (nicht env/Co-Loc); ce+prt-art external Module | DOK (LED:1351) |
| **§16.1-C2** | XML nennt NUR EINEN Pfad = Ergebnis-Ziel-Ordner; build→ziel-Copy | NACHGEHOLT (LED:1357) |
| **§16.1-C3** | Planer = versteckte root-Minimal-Binary aus Anwender-CMake → XML-abhäng. Build; CEB/Tier tief; 3. Framework-Anwendung | NACHGEHOLT (LED:1363) |
| **§16.1-C4** | I2-Fork = Option c (statische Pfade); PRT-ART = ce-Modul, per XML full-join additiv je Phase | DOK+GEBAUT (LED:1369) |
| **§16.2-M1** | Mess-Modi Debug-parallel / Mess-1-Thread; NIE-Nullen; perf beide prod; Planer generiert CI ODER cmake synchron | NACHGEHOLT (LED:1379) |
| **§16.2-M2** | Serialisierung lazy Baum, flach (System) vs. tief (Tier), dynamic-only-Spalten; Reihe C = Option C | NACHGEHOLT (LED:1385) |
| **§16.2-M3** | Zwei-Phasen-Schleife save→warmup-kalt→rollback→measure + Messblock 3×; #225 = kein neuer Grundsatz | NACHGEHOLT (LED:1391) |
| **§16.2-M4** | Fehler-Sichtbarkeit: CSV-Zelle „failed" (nicht null) + aggregierter Log | VOLL DOK (LED:1397) |
| **§16.2-Q** | Q1 flach+Manifest / Q2 statische per-Achsen-Spalten RAUS (kehrt E1 um) / Q3 additiv gespiegelt / Q4 On-Disk-Baum+Index | VOLL DOK (LED:1403) |
| **§16.3-F3i** | Reihe C = Option C (beides); KEINE 4. Stufe, KEIN 4. MergeStrategy-Enum (bleibt 3) | NACHGEHOLT (LED:1418) |
| **§16.3-E17** | P/E-Core (0x1A) = separate Systemachse, aber DYNAMISCHE Unter-Achse unter Hardware; H-1 wie empf. | NACHGEHOLT (war GEPARKT) (LED:1424) |
| **§16.3-E18** | Set = eigenes Genus + eigene ABI; Gattungen non-intersecting + mutual-use; **F1a=TUN, F1b=ABI/golden-GO GEWÄHRT (MAJOR, „UNVERHANDELBAR")**, F2/F3 wie empf. | NACHGEHOLT (war GEPARKT) (LED:1430) |
| **§16.4-G5** | G5/#274 measurement-all-Migration ans PROJEKTENDE; Comdare-2D-Matrix als Abschluss | NACHGEHOLT (LED:1443) |
| **§16.4-E19** | Löschpolitik = (a) behalten; neue Löschziele zuerst fragen (gated) | NACHGEHOLT (LED:1449) |
| **§16.4-DIR** | Bei scheinbar offener Entscheidung IMMER erst Ledger + alle Plandocs; sonst Rückfrage+PAUSIEREN | DOK (LED:1455) |

### 18.3.3 TAG 2026-07-17 — die 6 §17-Antworten (USER-ENTSCHEIDE, AUTORITATIV, LED:370)

| ID | Kurzform | Status |
|----|----------|--------|
| **F1 (DLL-Load)** | NICHT beantwortbar — Konstruktionslogik fehlte. User **tendiert Option B**, unsicher → **ultracode-Durchdringung beauftragt** | GATED (→ 18.2.3: B empfohlen) |
| **F2 (4→5-Schritt)** | **4→5 BESTÄTIGT.** Scheduling zunächst SYSTEM-Achse (CEB darunter gebaut → Tier untergeordnet STATISCH); Anatomy-Major reitet am Planer-Dock. **Golden ZERLEGT+UMGEBAUT** (nicht -erhaltend; Messdaten nie löschen). **View = read-only aus sequential container.** IMMER **Kopf-Framework je Ebene-1-Gattung** (map/(seq)container/set/graph) | AUTORITATIV; kehrt §17.B-1 um |
| **F12(iii)** | **Telemetrie = SYSTEM-Achse in der CEB.** ultracode-Design-Vorlage, sonst wie empf., **GATED nach User-Gegenprüfung** (=entparktes #29) | GATED |
| **H-1 / H-6..H-10** | H-6 wie empf. (Deskriptor-Schwesterwurzel) · H-7 wie empf. + Tier statisch für system-passende Opt. (AVX512 passend ODER weggelassen → volle Kontrolle) · H-8 Governor+Prefetcher = Tier-Binary-Achse (Governor Teil Strategy/Heuristik-Command) · H-9 dyn. System-Unter-Achse via Prüf-Dock, Tier meldet ABI-stabil zurück, Lasten+Frameworks = System-Achse · H-10 AVX10-Feld JA + Kompilation IMMER versioniert + Metadaten neben Binary | AUTORITATIV |
| **F5 (Planer-Codegen)** | PF1 CEB-runtime Unter-Achse befehligt Tier am Prüf-Dock · PF2 Runner = ISA×OS×alle-System-Achsen, disjunkt PARALLEL über ISA, concurrency 1/Maschine · PF3 aus XML, muss stabil stehen · PF4 Index-Manifest = XML | AUTORITATIV |
| **F6 (#40+Kleinteile)** | autonom nachziehen **NACH** ultracode-State-Search (verify-first, keine Löschung) | GATED |

### 18.3.4 Rekursive Dock-Schärfung (LED:369) + Konstruktionslogik-Durchdringung (LED:368, wf_83ed4865)
- **DOCK** (LED:369; Memory [[feedback_recursive_dock_planer_ceb_tier_abi_stable_so]]): Experiment-(Planer-)Dock eindimensional (Planer→CEB, kein Rückkanal) · Prüf-Dock bidirektional (CEB↔Tier, CEB = system-achsen-versionierte .so) · Rückschrieb ans XML-Ziel (nicht übers Experiment-Dock) · Tier zwei Formen (heuristisch/plain) · Kompile-Reihenfolge System→Mess-Heuristik · dasselbe Muster REKURSIV.
- **KL** (LED:368; Doku, KEIN Code): Deckung ~70 % · DLL-Load = Option B empfohlen · fehlende Schichtung (4 System-Achsen verstreut, Achsen flach, Gattungen 3≠4, ABI-4/Planer-Dock ungebaut) · F6-Nachzieh (verify-first, keine Löschung; `module_abi_v1.hpp` = 3 reale Konsumenten NICHT anfassen; erledigt `abi_v1_to_v2_mapper`, CRC64-Footer honest-0) · Dock-Terminologie verankert.

### 18.3.5 Q1–Q5 Synthese-Mapping (5 dem User vorgelegte Gegenprüfungs-Fragen; GATED, LED:368)

| Q | Synthese-Frage | Deckt heutige Antwort |
|---|----------------|----------------------|
| **Q1** | Gattung Ebene-1 3 vs. 4 — Set-Promotion F1b im 4→5? | §16.3-E18 F1b (GEWÄHRT) + F2 Kopf-Framework je Gattung |
| **Q2** | Scheduling compile-time-CRTP-System-Achse (verwaiste vtable ersetzen/deprecaten)? | S-1/S-2 + F2 Scheduling=System-Achse; KL-DELTA (Doktrin-Verletzung) |
| **Q3** | Telemetrie aus binary_id herauslösen → POD/kV3AxisSchema-Bruch → 320 golden ≥2 Segmente neu materialisiert (alt eingefroren)? | F12(iii) + F2 golden ZERLEGT+UMGEBAUT |
| **Q4** | Prüf-Dock als EINZIGER Träger (heute umgeht Lazy-Iterator `IPruefDock`, `cache_engine_builder_iterator.hpp:750-756`)? | DOCK-E2/H-9 Prüf-Dock bidirektionaler Vertragsträger |
| **Q5** | H-7 `-march`/`-mavx`-Compiler-Kopplung (Messdaten vor/nach nicht vergleichbar → neue Metadaten-Version)? | H-7 (Tier statisch AVX-kompiliert) + H-10 (immer versioniert+Metadaten) |

---

## 18.4 GEBAUTE INCREMENTS + VORLAGEN-REGISTER + REPO-STAND

### 18.4.1 Gebaute + verifizierte Increments (2026-07-16/17, SHAs; beide Remotes ref-gleich origin=gitlab.comdare.local + github)
Fork-A-Brücke = dünne Orchestrierung ÜBER dem offiziellen E4/CEB-Pfad, KEINE Parallelstrecke ([[feedback_only_one_official_xml_driven_program_no_behelfswege]], [[feedback_vor_aufgaben_erst_projektstruktur_analyse]]):

| Increment | ce-SHA(s) | Belege / Literal |
|---|---|---|
| **#35-Fassade R1** (F5.R1) | `780459ec→a22007d6` | `get_cache_engine()`-Default-Impl + f15_compare 1. Konsument; super `e87ae40`; LED:1264/1467 |
| **S-2a/b + S-3** | `780459ec` | S-2a `dc1b735d` (3 tote V32.EE.5-vtable-Header deprecated→Live-CRTP, 0-Konsumenten-grep); S-2b `452a1b6f` (Provenienz Live); S-3 Achse-14 = ENGINE-CHOICE. golden 320, `test_axis_registry_roundtrip` Passed, cf22 0; super `5b2a161`; LED:379/1469-1472 |
| **BRÜCKE I1** (Workload-Gate) | `a22007d6→cb841787` | `validate_experiment_profile` +3. Arg `known_workload_ids`; `test_experiment_parser [PASSED] 13 tests`, golden 320, phasen-orthogonal/golden-neutral; LED:377/1476 |
| **BRÜCKE I2** (`--validate` + facade) | `cb841787→16874347` (`fa519a8b`+`16874347`) | +4. Arg `engine_registry_paths` (statischer Registry-Pfad, rückwärts-kompat); `main.cpp`-Sniff rc 0/1/5; 13 tests, golden 320; super Host-Wiring; LED:376/1478 |
| **F12i** (snmalloc-Fix) | `730831d2` | Directory-scope `link_libraries(comdare::vendor_snmalloc)`; `[66/69] Linking … comdare-messung-driver`, 0 FAILED; `--validate` rc 0/1/5, golden 320, roundtrip==320; super `1687434→730831d`; LED:928-954/1480 |
| **BRÜCKE I3** (Projektion) | `84079438→f4d87059` | E5-`(merge,lebewesen)`-Overloads + `project_experiment_to_sota_passes`; `test_experiment_projection [PASSED] 3 tests` (19 Pässe), parser 13/13, golden 320, `sota_catalog.hpp` unberührt; super `cc0d4b9c`; LED:1517/1524 |
| **F1a** (Vokabular-Versöhnung, REIN DOKU) | `f4d87059→dad91fe5` | Nur Doc-Block `anatomy_base.hpp` (Ebene-1 `AnatomyGattung`≡Ebene-2 `AnatomyGenus`; Set bereits eigenes Genus mit `ISetTier`), #29-ENTPARKT; 26 ins/0 del; `test_29_container_framework 3 PASSED`, `test_d9_set ALLE OK`, golden 320; super `c234c9e2`; LED:373/1525 |
| **BRÜCKE I4** (Lauf-Fassade) | `dad91fe5→8bacde51` | `run_experiment_profile_facade` + `run_experiment_profile` + `comdare_experiment`-Root-Tag-Dispatch; `--validate` rc 0, 13/13, Projektion 3, golden 320, cf22 0, Mojibake 0, TABU unberührt. Läuft e2e bis Messung, **ABER `measured=0`** (7 SOTA-DLLs `built=1/loaded=0`, undefinierte `mi_*`; pre-existing, NICHT I4-Code). super **`c78359d`** (§12 LED:371) / **`a92f362`** (§17.E LED:1544) — *SHA-Diskrepanz zwischen beiden Ledger-Stellen, verbatim so belegt*; LED:1543-1547 |
| **S-7-PLAN** (Doku) | — | super `0e87b64` (Opus 4.8, 5/5 Agenten); `backups/20260716-s7-locking-observer-research/PLAN.md`: OptiQL-faithful + ARTSynchronized-Vendoring, `UpgradeableConcurrency`=10. Organ Default-OFF golden-neutral (sizeof==1416), INC-1→3; Observer-Audit PHANTOM-frei außer T8; LED:1474 |
| **§16-Konsolidierung** (Doku) | — | super `0930b65`: alle 07-16-Entscheide an einer Stelle, 3 stale GEPARKT korrigiert; H-1-Dossier+Back-Merge super `02996e2`; LED:1517/1526 |
| **KONSTRUKTIONSLOGIK-DURCHDRINGUNG** (Doku, wf_83ed4865) | — | super **`4b7162f` (HEAD)**; 2 Vorlagen `20260717-konstruktionslogik-durchdringung/{KONSTRUKTIONSLOGIK,F12III-DESIGN-VORLAGE}.md`; LED:368 |

**Verifikations-Backlog** (2026-07-16 Nacht, read-only, kein Code): #31 `<workload>`/OP-Pfad LIVE in CI · main→development Back-Merge sauber (`--is-ancestor`=0 super/ce/prt-art) · #40 Dead-Code STALE — ALLE NICHT OFFEN. LED:372/1527.

### 18.4.2 Vorlagen-Register (Design-Dossiers, `docs/sessions/backups/`, VOR-Bau; per ls)
18 Verzeichnisse `20260716-*` + 1 `20260717-*`. Kern-Vorlagen für die Bau-Roadmap:
- `20260717-konstruktionslogik-durchdringung/{KONSTRUKTIONSLOGIK,F12III-DESIGN-VORLAGE}.md` — die 2 aktuellen Autoritäts-Vorlagen (LED:368).
- `20260716-fork-a-bruecken-dossier/DOSSIER-ENTWURF.md` — I1–I7-Spec (LED:1277).
- `20260716-e18-ebene1-und-h1-hardware-design/` — E18-Ebene-1-Promotion (F1b) + H-1-Hardware-Systemachse (LED:1528/1531/1532).
- `20260716-experiment-planer-codegen-design/` — Planer-CI/cmake-Codegen (Interpreter+Director+2 Builder, F1–F4-Forks; LED:1534).
- `20260716-dll-load-mimalloc-diagnose/DOSSIER.md` — §17.E-Root-Cause (Option A vs. B; LED:1547).
- `20260716-s7-locking-observer-research/PLAN.md` — S-7 (LED:1474).
- `20260716-gesamtkonzept-experiment-ausfuehrung/` — Gesamtkonzept (LED:1528).
- Weitere 12: voll-audit-sessions-plaene-architektur, wp1-parallel-engine-gestoppt-fork-a, wp5-rev-mining, e14-branch-audit, e11-phasen-e13-kontext, e17-e18-deep-research, g5-274-migration-vorlage, f4-systemachsen-dossier, f-runde2-untersuchungen, richtungs-verdikt-ledger-vollsicht, finale-entscheidungs-konsolidierung.

### 18.4.3 Repo-Stand (git, alle branch `development`, beide Remotes)
- **ce** (`Code/external/comdare-cache-engine`): **`8bacde51`** — „Bruecke I4 — run_experiment_profile-Fassade".
- **super** (`probst-diplomarbeit-cache-engine`): **`4b7162f`** — „dossier+ledger: Konstruktionslogik-Durchdringung".
- **prt-art** (`Code/external/comdare-prt-art`): **`9b8dd09`** — „WP-4/F29: Registry-Round-Trip-ctest".
- **thesis** (`thesis/diplomarbeit`): **`8d156a5`** — „feat(anhang #24): INC-7 Thesis-\input observer_detail DE+EN".
- (§17.D-Snapshot LED:1541 nannte ce `dad91fe5`/prt-art `9b8dd09`/thesis `8d156a5`/Cluster `bf4cd4b`; ce+super sind seither um I4/Konstruktionslogik weiter.)

---

## 18.5 BAU-ROADMAP + NOCH OFFENE PUNKTE

### 18.5.1 Roadmap (§17.D LED:1541 + §12 2026-07-17 LED:368/370 + §15.10 LED:1277)
1. **INC-0 = DLL-Load Option B** (deadline-kritisch DEADLINE 28.07., ABI-4-kompatibel, sofort autonom): `make_gpp_compile_fn` (`build_orchestrator.hpp:466-489`) self-linkt den Vendor-Allokator → `link_libs`-Feld in `BuildJob`/`make_gpp_compile_fn` + Fassaden-Bake `$<TARGET_FILE:comdare::vendor_mimalloc>` (Muster `COMDARE_FACADE_PERM_INCLUDES`). Repliziert byte-genau den funktionierenden CMake-In-Process-Pfad (`codegen.cmake:610`), wahrt RAII-Destroy-Vertrag + faire Allokator-Achsen-Messung, löst `measured=0` (LED:1547). Option A (`-rdynamic`/Host-Export) verworfen (Arena-Kontamination, bricht Destroy-Vertrag/self-contained-ABI/H-10).
2. **INC-1 = CEB-System-Achsen-Schichtung (S-2c, ABI-4-kompat):** `build_system_axis_levels()` abspalten (eigene abstrakte Wurzel, Organ vs System nie mischen) + 4 Pflicht-Systemachsen CRTP in CEB + Compiler-Systemachse gcc|clang (golden-neutral) + **H-7** `-march`/AVX512-Kopplung (volle Kontrolle) + **H-10** per-Binary-Sidecar (AVX10-Feld). Schichtung `System-Achsen ⊃ Tier-Binary-Achsen` (heute flach). Scheduling zunächst SYSTEM-Achse, unter der die CEB gebaut wird; Tier untergeordnet STATISCH. LED:370/1538.
3. **INC-2 = koordinierter 4→5-ABI-Bump am Experiment-Planer-Dock** (koordiniertes GO, EIN Backup/Review, Naht `experiment_run_entry.hpp:225-251`, `IPruefDock` scharf stellen): F12(iii) Telemetrie=System-Achse + F1b (Set=Ebene-1-Promotion) + F2 (native `ISetTier`+Set-POD+`SetDock`) + #37-Scheduling compile-time-CRTP — gemeinsam auf EINEM Anatomy-Major (`.A5.`). Golden ZERLEGT+UMGEBAUT mit GO ([[feedback_messdaten_nie_loeschen_abi_darf_brechen]]). Design VOR golden/ABI-Änderung vorlegen (§17.C). LED:370/1531/1533.
4. **INC-3 = Golden additiv einfrieren + neu materialisieren je Gattung** (`…_abi4`-Fixtures+CSV/PDF unangetastet einfrieren; `golden_abi5_map_/_set_/_sequence_` einmalig via `gen_golden_fullpilot.cpp`; Gate umhängen, alt als historische Referenz).
5. **INC-4 = Sequence-/Container-/Graph-Dock** (V42-Fahrplan, `pruef_dock_registry.hpp:4-5`).
- **F6-Nachzieh (autonom laufend, verify-first, KEINE Löschung, parallel ab INC-0):** `scheduling_strategy.hpp`-Deprecated-Marker (einzige der 4 vtable-Achsen ohne, konsumfrei); `comdare_is_original_macro.hpp`+`ctsha.hpp` deprecaten (0 Includer, ABER Sibling-Concept `LegacyOriginalCodePflicht` LEBT); `resolve_baustein.hpp` test-only-Marker; **AUSNAHME `module_abi_v1.hpp` = 3 reale Lib-Konsumenten NICHT anfassen**. Erledigt: `abi_v1_to_v2_mapper` getilgt (`ebcc5498`), `cache_engine.hpp` (#35-Konsument), CRC64-Footer honest-0. LED:368/372.
- **Danach:** Planer-Codegen-I1 (golden-neutrales Skelett), F12(i) Standalone-Parität, F9/F10/F11, S-7-INC-1, #276 3-ISA-CI (allerletzte, infra-gated).

Jeder Increment endet CI-grün+messfähig, nur punktuelle Refactorings, keine Parallelstruktur ([[feedback_ci_gruen_messfaehig_nur_punktuelle_refactorings]], [[feedback_e_schichten_separat_fertigstellen_top_down]]).

### 18.5.2 Noch offene Punkte (GATED nach 2026-07-17)
- **DLL-Load-B-GO:** Option B ist INC-0-autonom + ABI-4-kompatibel, aber **F1 formal ultracode-gated** (User tendiert B, LED:370). → **User-GO für den Bau von Option B ausstehend.**
- **Q1–Q5-Mapping-Bestätigung:** die 5 Synthese-Gegenprüfungsfragen (18.3.5) sind dem User vorgelegt, **User-Bestätigung des Mappings ausstehend** (LED:368).
- **F12iii-Design-Vorlage → User-Gegenprüfung** nach Design (GATED; = entparktes #29).
- **golden-Umbau + Kopf-Frameworks + F1b/F2/#37 als EIN 4→5-Bump** — Design VOR Bau vorlegen (§17.C).
- **F5-Planer-Codegen-Bau** (PF1–PF4, aus stabiler XML abgeleitet).
- **S-7-Deep-Research** (Opus-Session; Fable-Safety-Block, LED:381-Nachzieh).
- **GEPARKT (User-GO):** E17/E18-Set-Folge-Bau, G5/#274 measurement-all-Migration (Projektende).

---

*Belege durchgängig: LED:Zeile = `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (§12 LED:368–370 verifiziert 2026-07-17; §16 Z.1339–1459; §17.E LED:1543–1547). Interne „LED:xxxx"-Referenzen in §16 sind post-Prepend stale — hier gegen Ist-Zeilen belegt. Code-Zitate rel. `Code/external/comdare-cache-engine/libs/cache_engine/`; super-CMake ausgeschrieben. Dossiers `docs/sessions/backups/20260717-konstruktionslogik-durchdringung/` (verifiziert vorhanden: KONSTRUKTIONSLOGIK.md, F12III-DESIGN-VORLAGE.md) + `20260716-*`. VERBATIM-treu zu den User-Aussagen; KONSOLIDIERUNG, kein Neu-Entscheiden.*
