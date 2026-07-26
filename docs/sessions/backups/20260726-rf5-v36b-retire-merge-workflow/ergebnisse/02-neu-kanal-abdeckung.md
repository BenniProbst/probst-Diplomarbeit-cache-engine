STRANG B - MELDUNG (read-only-Kartierung, Stand super working tree 26.07.2026, ce HEAD dbc98fd6). Pfad-Kuerzel: super = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine; ce = super/Code/external/comdare-cache-engine.

== (1) KANAL-KARTE NEUER KANAL (end-to-end) ==

STUFE 0 - XML-Eintritt (2 offizielle Wurzeln):
- Parser: ce/libs/common/serialization/xml_config_parser/xml_config_parser.hpp:91 (comdare_thesis_profile), :201 (beide Wurzeln ThesisProfile UND ExperimentProfile), :288-304 (<system_axes> opt_level/simd/target_isa additiv, geteilte parse_system_axes-Naht).
- Profil-Ablage: ce/libs/cache_engine/algorithm_profiles/thesis_profiles/ (super/MANUAL_RUN.md:32, golden = all_axes_golden.profile.xml).
- Host/Treiber: super/Code/02_messung_driver/main.cpp - Root-Tag-Sniff waehlt run_profile_facade vs run_experiment_profile_facade (main.cpp:1135-1142); Profilwahl im Lauf ueber Env COMDARE_THESIS_PROFILE mit Compile-Default (main.cpp:929-931, Default aus 02_messung_driver/CMakeLists.txt:27).
- CLI-Flags (alle auf die EINE Fassade): --validate main.cpp:419, --dump-plan :460, --dump-ci :512, --dump-cmake :528, --emit-tier-ci :546, --emit-tier-cmake :569, --measurement-combo-Selektor :555/:578.

STUFE 1 - PLANER (Mess-Achsen-Konfiguration):
- ExperimentPlanDirector = der EINE benannte Walk (GoF Director+Builder): ce/libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:3-27 (Kopf), IPlanBuilder :169, PlanTextBuilder :193, CMakeGraphBuilder :253, CiYamlBuilder :578, TierCiYamlBuilder :820, TierCmakeGraphBuilder :1326.
- Mess-Achsen-Zustaendigkeit des Planers: PlanMeasurementCombo :90-103 (Mess-Tooling-HAUPT {wallclock/macro/micro} = [a,b,c]-Auffaecherung bestimmt den CEB-TYP; die 16 measurement_categories = UNTER/CSV-Spalten), PlanBuildSemantic :105-113 (run_methodology_registry, Build-/Mess-Semantik).
- EIN Walk fuer ALLE 5 Emissionen: construct_plan_into ce/libs/cache_engine/profile_facade/profile_run_facade.cpp:804, director.construct :845 (thesis) / :858 (experiment); Traeger: --dump-plan :872, --dump-ci :886, --dump-cmake :900, --emit-tier-ci :913, --emit-tier-cmake :926.

STUFE 2 - CEB (profile_run_entry/profile_run_facade):
- Fassade: run_profile_facade profile_run_facade.cpp:411 (Pre-Flight-Validat :419, Lastprofil-/Workload-Aufloesung :431-476, Methodik-Override :482-487).
- CompileFn-Montage make_gpp_compile_fn (Definition ce/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp:717): Einzelpfad profile_run_facade.cpp:495-500; Perm-Pfad compile_for_perm :521-543; Experiment-Pfad :1017/:1029.
- System-Perm-Schleife (opt x simd): ce/libs/cache_engine/profile_facade/profile_run_entry.hpp:735 (opt-Loop) x :751 (simd-Loop), per-Zelle-Montage perm_compile = compile_for_perm(opt_flag, march_flag) :778; Identitaets-Perm ohne <system_axes> :724-734.
- GATE-NAHT (Section 40.a-E4): gate_extra_march_flags_for_build/route_of_march_flag an der CompileFn-Naht profile_run_facade.cpp:534-541 (Pfad 1) und :1003-1016 (Pfad 2, zeichengleich belegt durch ce/tests/unit/test_c3b_kanal_merge_beleg.cpp:43-50); Include simd_build_gate.hpp profile_run_facade.cpp:20.

STUFE 3 - TIER-CODEGEN:
- Lazy Per-Index-Emitter: ce/libs/cache_engine/profile_facade/lazy_adhoc_source_gen.hpp:2-24 (O(17) je binary_id, KEIN mp_product; GN-2-Grenze 4096 umgangen), Freigabe-Kopplung System->Organ sitzt AN der perm_compile/provision_all-Naht, nicht im Emitter (:41-49).
- Verdrahtung in den Lauf: profile_run_entry.hpp:320 (make_lazy_adhoc_source_gen_from_env), Bau/Messung via run_lazy_static_then_dynamic :583/:633/:706.
- Render-Kern: ce/libs/cache_engine/builder/codegen/adhoc_emitter.hpp:52 (adhoc_macro_args, 17 Slots inkl. persistence_target :76), :84 (render_adhoc_module_source, Stempel-Formen :112-140).

VERTEILUNGS-PRUEFUNG (Planer=Mess / CEB=System+Organ): BESTAETIGT im Ist. Mess-Auffaecherung ausschliesslich im Director (PlanMeasurementCombo, experiment_plan_director.hpp:90-103); System-Perms + Organ-Bau-Delegation in CEB (profile_run_entry.hpp:735-778; lazy_adhoc_source_gen.hpp:43-49 "der Zulaessigkeits-Filter sitzt ... EXAKT an der CEB-BAU-DELEGATIONS-NAHT"). Rollenaussage explizit: profile_run_facade.hpp:283-285 (Planer steuert CEB-Jobs via --dump-ci, CEB steuert Tier-Jobs via --emit-tier-ci; heute EINE Binary in zwei Rollen).

== (2) NEBEN-KANAL-LISTE (alle Konfigurations-Eintrittspunkte, klassifiziert) ==

HAUPT-KANAL: Profil-XML (2 Wurzeln) + Treiber-CLI + COMDARE_*-Env. Die Env ist KEIN Fremdkanal, sondern der Zellen-Pinning-Draht des Kanals selbst: die emittierten Plaene pinnen die Vars selbst (TierCiYamlBuilder experiment_plan_director.hpp:1036-1039/:1182-1201; TierCmakeGraphBuilder :1461-1463: COMDARE_THESIS_PROFILE/GOLDEN_N_RANGE/GN_OPT/GN_SIMD/PROVISION_ONLY).

V36.B (RETIRE per Owner-Entscheid Paragraph 71):
- Schalter: option(COMDARE_BUILD_PERMUTATIONS ... OFF) ce/CMakeLists.txt:33 -> ce/cmake/permutations.cmake (V36.A/V36.B-Marker :29-40; 4 Backends cpp/cmake/sh/bat :22-24, Default cpp = #25-B-Byte-Vertrag).
- Generator: ce/libs/cache_engine/builder/permutation_codegen_tool/permutation_codegen_tool.cpp:448 (V36.B Per-Permutation-Targets), :500 (V36.B Aggregator), :515 (manifest); Flag-Kanal A zusaetzlich ce/cmake/isa_features.cmake (Beleg test_c3b_kanal_merge_beleg.cpp:16-18).
- Alt-Manual haengt daran: super/Code/MANUAL_RUN.md:50 ("comdare_perms_all ZWINGEND zuerst") - nach Retire irrefuehrend.

SONSTIGE NEBEN-KANAELE (benannt):
(a) catalog_codegen-CMake-Schiene: ce/CMakeLists.txt:655 include(cmake/catalog_codegen.cmake) -> comdare_catalog_codegen_cli erzeugt generated_source_catalog.hpp, hart gepinnt auf m3v2_study (320er) (catalog_codegen.cmake:5-13,:24-26). Zulieferer des Haupt-Kanals zur Configure/Build-Zeit - unter der Praemisse "keine CMake-Umwege" ein Merge-Kandidat, traegt aber heute den GN-2-Guard.
(b) Registry-Generatoren (ANGEBOT): ce/tools/CMakeLists.txt:11/:16/:17 (axis_registry_gen, system_axis_registry_gen, measurement_axis_registry_gen) - erzeugen die Angebots-XMLs; kein Steuer-Kanal.
(c) anatomy_codegen_runner: ce/cmake/anatomy_codegen_runner.cmake:1-12 (V41-Configure-Time-execute_process, 2-Pass) - alter Codegen-Zulieferer.
(d) DIREKTE CMake-option()-Schienen (echter Fremd-Eintrittspunkt am XML vorbei): COMDARE_AXIS_06_ENABLE_* (~20 Allocator-Schalter, ce/CMakeLists.txt:156-179, konsumiert u.a. in ce/libs/cache_engine/axes/alloc/axis_06_allocator_registry.hpp), COMDARE_MEASUREMENT_MODE/COMDARE_RELEASE_MODE :112-113, COMDARE_CE_ENABLE_STATISTICS :133, COMDARE_CE_ENABLE_OBSERVER_PUSH :145, COMDARE_ENABLE_PMC :44 / PAPI :57. Der EnabledStrategies-/Angebots-ZUSCHNITT laeuft hier ueber CMake, nicht ueber Profil-XML -> die Ein-Kanal-Praemisse ist an DIESER Stelle heute NICHT voll erfuellt.
(e) .gitlab-ci-Matrix-Reste (RF-4 = ARCHIV, noch im Baum): build:golden-n super/.gitlab-ci.yml:1044 (24-Zellen-Matrix, DEPRECATED, doppelt gegatet COMDARE_BUILD_GOLDEN_N + COMDARE_STATIC_MATRIX_FALLBACK :1061-1062), build:golden-n-avx512 :1070 (dreifach gegatet); alte Pilot-Mess-Jobs :631/:713 (abgeloest, "NICHT geloescht (Pilot-Historie)" :642-644). RF-4-Entscheid dokumentiert in super/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:3539 (70.4: archivieren per Infra-Handout) - Umsetzung im Working Tree noch NICHT erfolgt.
(f) E4-Messreihen-Eintritt: messreihen.xml (super/Code/experiment_config/, verdrahtet super/Code/CMakeLists.txt:403; Treiber main.cpp:188-222/:849-856/:1314) - aelterer XML-Eintrittspunkt (V9.6, Reihen A/B/C) im SELBEN Treiber neben dem Profil-Kanal.
(g) CMakePresets.json (ce/README.md:82-87) - Bau-Ergonomie, kein Mess-Konfig-Kanal.

== (3) CI==BAREMETAL-GLEICHLAUF-BEFUND ==

GLEICHLAUF (belegt):
- BEIDE Welten haengen am SELBEN Director-Walk: construct_plan_into ist Single-Source (profile_run_facade.cpp:804/:845/:858); CI-Traeger CiYamlBuilder/TierCiYamlBuilder (:886/:913) vs Bare-Metal-Traeger CMakeGraphBuilder/TierCmakeGraphBuilder (:900/:926) sind nur verschiedene ConcreteBuilder derselben Enumeration; byte-deterministisch/host-unabhaengig zugesichert (profile_run_facade.hpp:263-265/:275-276).
- Beide emittieren denselben Treiber-Aufruf mit demselben Env-Satz (experiment_plan_director.hpp:1036-1039 CI vs :1461-1463 CMake).
- Treiber-Bau identisch: CI `cmake -B build -G Ninja -DCOMDARE_V32_ENABLE=ON -DCMAKE_BUILD_TYPE=Release` (super/.gitlab-ci.yml:858/:860) == MANUAL_RUN.md:40-41; realer CI-Zell-Bau ruft denselben E4-Block (COMDARE_THESIS_PROFILE=... "$DRIVER" experiment_config ..., super/.gitlab-ci.yml:1010-1012) wie der Bare-Metal-Handlauf (main.cpp:929/:1229-1242).
- planer:delegate = "$DRIVER" --dump-ci (super/.gitlab-ci.yml:1228/:1265) ist das CI-Gegenstueck zu lokalem --dump-cmake (MANUAL_RUN.md:102); Beweis-Lauf Bare-Metal dokumentiert (MANUAL_RUN.md:181-189, 69 perm.dll rc 0).

DIVERGENZEN (ehrlich):
- Profilwahl: CI-Smoke-Zweig delegiert m3v2_smoke statt all_axes_golden (super/.gitlab-ci.yml:1239-1242/:1298); Bare-Metal nimmt das Profil literal als CLI-Argument.
- Mess-Stufe: Bare-Metal measure = Echo-Skelett (MANUAL_RUN.md:193-195); CI-emittierte Mess-Jobs when:manual (super/.gitlab-ci.yml:1289) - beidseits gated, aber verschieden mechanisiert.
- CI-only: GitLab-CI-Lint-Pflicht vor Scharfschalten (MANUAL_RUN.md:219-220), planer_block/Bestandslog-Kontext nur host-gegatet (profile_run_facade.hpp:250-259), resource_group ceb-measurement-exclusive (:631/:713), Runner-SIMD-Tags GN_RUNNER_TAG (:1050-1058) vs Bare-Metal Host-CPU-Voraussetzung (MANUAL_RUN.md:198-199). Das sind Umgebungs-/Gating-Divergenzen, keine Plan-Byte-Divergenzen.

== (4) TOOLCHAIN/MANUAL-IST ==

Toolchain Haupt-Kanal (belegt):
- Compiler: g++-16 als Achsen-Single-Source-Default (ce/libs/cache_engine/include/cache_engine/measurement/compiler_system_axis.hpp:49; clang-Leg clang++-22 :55; Override COMDARE_CXX profile_run_facade.cpp:307); C++23 hart (ce/CMakeLists.txt:16-17).
- CMake: minimum 3.28 fuer ce-/Treiber-Bau (ce/CMakeLists.txt:7 "C++23 Modules-Support"; super/Code/CMakeLists.txt:10); nur die emittierten Plan-Wrapper brauchen >=3.20 (MANUAL_RUN.md:129/:150). Die Manual-Tabelle ">= 3.20" (MANUAL_RUN.md:18) ist damit fuer den Treiber-Bau ZU LAX.
- ninja: ja (MANUAL_RUN.md:19, getestet 1.13.1; CI :858).
- Boost: NUR Boost.MP11, offline vendored (ce/CMakeLists.txt:469 boost_mp11_setup; Pflicht-Pfad cmake/third_party/boost_mp11 super/Code/MANUAL_RUN.md:7).
- xmllint: KEIN Treffer in super/ce (.gitlab-ci.yml + *.cmake + CMakeLists, grep leer) -> nach Ist nicht benoetigt.

User-Manual: EXISTIERT = super/MANUAL_RUN.md (19.07., kompletter Bare-Metal-Handlauf Stufe 1-3 mit Toolchain-Tabelle :15-19 und Beweis-Lauf :181-189). LUECKEN: (i) kein Manual fuer den ECHTEN Messlauf (Stufe 3 nur Skelett, :191-195); (ii) zweites, veraltetes Manual super/Code/MANUAL_RUN.md (13.07.) verlangt noch den V36.B-Weg (comdare_perms_all :50) - nach Paragraph-71-Retire zu deprecaten (nie loeschen); (iii) ce/MANUAL_RUN.md:15-17 nennt widersprechende Anforderungen (GCC 13+/CMake >=3.24 vs real 3.28/g++-16); (iv) KEINE install()-Targets in ce/CMakeLists.txt und super/Code/CMakeLists.txt (grep 0 Treffer) -> "leicht installierbar nach Stand der Technik" (cmake install/Paketierung des Treibers) fehlt heute; (v) CI-Anwendung (planer:delegate) nur als Anhang (MANUAL_RUN.md:203-220), Lint-Schritt manuell. UNGEPRUEFT: ob weitere Handlauf-Dokumente unter super/docs/plaene den Mess-Teil abdecken (nicht vollstaendig durchsucht); Versionen g++-16/cmake 4.3.4/ninja 1.13.1 sind Doku-Angaben (MANUAL_RUN.md:8), nicht von mir live verifiziert.