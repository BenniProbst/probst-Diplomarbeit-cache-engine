```
================================================================================
READ-ONLY-KARTIERUNG ce + super  (2026-07-26, keine Builds/Aenderungen)
Repo ce: /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine
================================================================================

(2) git diff --stat HEAD | tail  (ce)
 tests/unit/thesis_tiere/test_profile_roundtrip.cpp |   2 +-
 .../thesis_tiere/test_smoke_coverage_profile.cpp   |   6 +-
 tools/axis_registry_gen/main.cpp                   |   7 +-
 tools/gen_golden_fullpilot/main.cpp                |  53 +-
 90 files changed, 1566 insertions(+), 600 deletions(-)

git status --porcelain | wc -l  ->  96   (= 90 " M" + 6 "??")

UNTRACKED (6 Eintraege, davon 3 Ordner; -uall = 13 Dateien):
 ?? Testing/                                                    <- STRAY (siehe unten)
 ?? libs/cache_engine/axes/persistence_target/                   (9 Dateien)
 ?? libs/cache_engine/builder/bestandslog/planer_block_value.hpp
 ?? libs/cache_engine/topics/io/axis_persistence_target/         (1 Datei)
 ?? tests/unit/test_org18_persistence_target.cpp
 ?? tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids_abi6.txt

(3) git log --oneline e3a0c6ff..HEAD  (ce) -> genau 2 lokale Commits, bestaetigt
 42b34354 feat(modus): Lane D - COMPARE als 4. Registry-Modus (Q-4: CUSTOM_COMPILE ist KEIN Modus)
 0cb1902a feat(bestandslog): E3 - ceb_legende + ceb_key_sha512 als optionale batch-Attribute, kSyntaxVersion 3

(4) super: git diff --stat HEAD -- Code/02_messung_driver/main.cpp
 Code/02_messung_driver/main.cpp | 118 ++++++++++++++++++++++++++++++--
 1 file changed, 114 insertions(+), 4 deletions(-)
 super git status --porcelain (vollstaendig, nur 2 Zeilen):
  M Code/02_messung_driver/main.cpp        <- (d2)-super-Teil
  M Code/external/comdare-cache-engine     <- Submodul-Pointer (2 lokale ce-Commits)

(5) B-15-Stand: BEIDE Dateien existieren, aktiver Anker aktualisiert, abi6 eingefroren
 -rw-rw-r-- 169226 Jul 26 14:15 golden_fullpilot_320_binary_ids.txt       (326 Zeilen, " M")
 -rw-rw-r-- 155604 Jul 26 14:15 golden_fullpilot_320_binary_ids_abi6.txt  (327 Zeilen, "??")
 head -3 (aktiv):  "# GOLDEN-REFERENZ: 320 binary_ids des golden_320_catalog (4*4*5*4) -- ABI-7 /
                    STRUKT-R ORG-18 (18 Slots, mit persistence_target-Segment; ohne telemetry-/isa-Segment)."
                    "# EINGEFROREN. test_profile_roundtrip vergleicht den PROFIL-Pfad gegen DIESE Liste."
 head -3 (abi6):   "... ABI-6 / Bau-INC-2d (17 Slots, ohne telemetry-/isa-Segment)."
                   "# EINGEFROREN als ABI-6-HISTORIE (STRUKT-R ORG-18, 2026-07-26): additive Sicherung des
                    17-Slot-Stands VOR dem persistence_target-Bruch. Nur Lese-Referenz."
 -> additive Sicherung korrekt (Direktive "Messdaten/Referenzen nie loeschen"), Anker sauber umgestellt.

(1) GRUPPEN-KARTIERUNG (Klassifikation per Diff-Keyword + Sichtpruefung aller 0-Treffer-Dateien)

 A) ORG18-WIP (18. Organ-Achse persistence_target) = 85 modifizierte + 12 untracked = 97 Datei-Einheiten
   - Bau/Gate:      CMakeLists.txt (option() MEMORY_ONLY=ON / DISK_WRITEBACK=OFF, flags.hpp.in configure_file,
                    Q-1 FALL B haelt Voll-Bau bei 2^17), tests/unit/CMakeLists.txt (+test_org18-Ziel)
   - Neue Achse:    axes/persistence_target/* (9: strategy_base, memory_only, disk_writeback, observable,
                    registry, subaxes_pt1_to_pt2, flags.hpp.in, 2x concepts/), topics/io/axis_persistence_target/
   - anatomy/ (7):  abi_adapter, composition_concept/-factory, measurable_workload, observable_tier,
                    observer_aggregate, search_algorithm_anatomy   (ObserverAggregate<17>->18)
   - experiment_tree/ (10): axis_path_serialization, registry_to_axis_levels, result_ingest,
                    composition_registry, genus_binding_traits, axis_variant_version_table,
                    axis_observer_classification, axis_operability_classification, experiment_tree, u.a.
   - source_catalog: profile_facade/source_catalog.hpp (16 Treffer), lazy_adhoc_source_gen.hpp
   - Registry/XML:  cache_engine_axis_registry.xml + 9 thesis_profiles/*.profile.xml
   - Codegen/Tools: builder/codegen/{adhoc_emitter,all_axes_umbrella}, best_binary_selector, harness/perm_runner,
                    apps/catalog_codegen_tool/main.cpp, tools/axis_registry_gen/main.cpp,
                    tools/gen_golden_fullpilot/main.cpp, abi/anatomy_module_abi_v1_decl.hpp
   - Nachzug io_dispatch: axes/io_dispatch/axis_io_dispatch_observable.hpp, topics/io/topic_io_config_set.hpp
   - compositions/ (13 Referenzen: art/hot/start/surf/wormhole/masstree/prt_art/... +paper_binding)
   - Tests (30): test_org18_persistence_target.cpp (neu) + 17->18-Konstanten-Nachzug in
                    test_genus_binding, test_genus_organ_binding, test_d_v42_abi_telemetry_coupling
                    (kV3AxisCount==18), test_axis_sweep_pilot (kary_perk_levels==18),
                    test_profile_roundtrip (static_levels==18), test_s7_1..test_s7_10 (10x),
                    test_188_4bbV, test_234_va/_vb, test_all19_segment_timer, test_ap15_2,
                    test_br1_full22_count, test_br2_roundtrip, test_d3_ceb_generator, test_d8_operability,
                    test_limits_entkopplung_vorstufe, test_m8_storetrav_segment, test_m_w12_stamp_bausteine,
                    test_v41_anatomy(+_module_abi,+_observer), test_axis_sweep_coverage,
                    test_smoke_coverage_profile
   - Goldene Anker: golden_fullpilot_320_binary_ids.txt (321 Treffer) + _abi6-Kopie (untracked)

 B) (d2)-WIP (Planer-Block / G4b-2) = 5 modifizierte + 1 untracked
   M libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp
   M libs/cache_engine/profile_facade/profile_run_facade.cpp     (11 Planer-Block-Treffer)
   M libs/cache_engine/profile_facade/profile_run_facade.hpp     (nur Kommentar-Block: PlanerBlockContext-
       Begruendung "G4b-2 (#46b I1b / E1+E2+E4)", Lifecycle store(offen)->Emission->mark_done|Release)
   M tests/unit/test_g3_artifact_cache_transport.cpp             (13 Treffer)
   M tests/unit/thesis_tiere/test_experiment_plan_director.cpp   (6 Treffer)
   ?? libs/cache_engine/builder/bestandslog/planer_block_value.hpp
   + super: Code/02_messung_driver/main.cpp (+114/-4)

 C) PASST ZU KEINEM PAKET (Verdacht) = 1 Eintrag
   ?? Testing/  -> Testing/Temporary/{CTestCostData.txt (4 B), LastTest.log (121 B)}, mtime Jul 22 07:53,
      NICHT von .gitignore erfasst (git check-ignore: kein Treffer). Reines CTest-Laufzeit-Residuum eines
      In-Source-ctest-Aufrufs vom 22.07., kein Quellcode, keine Fremd-Feature-Arbeit.
      -> Empfehlung: NICHT committen; entweder .gitignore-Eintrag (Testing/) oder loeschen. Kein Streu-Code.

 SCHNITTMENGE: keine. Kein Datei-Eintrag traegt Aenderungen beider Pakete (CMakeLists.txt = rein Org18;
 profile_facade/* = rein d2 ausser source_catalog.hpp/lazy_adhoc_source_gen.hpp = rein Org18).
 Trennbarkeit: A und B sind datei-disjunkt und koennten als 2 getrennte Commits abgesetzt werden.

SELBSTCHECK: alle Ausgaben literal aus git/ls/wc/head; keine Builds, kein cmake/ctest, keine Datei-Aenderung;
ASCII-only (grep -P '[^\x00-\x7F]' auf diesen Report: keine Treffer).
================================================================================
```
