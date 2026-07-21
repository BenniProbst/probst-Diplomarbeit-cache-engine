# messung_driver — Master-Orchestrator der 3 Messreihen
# Ruft comdare::builder::ExperimentDriver (cache-engine library) auf.

add_executable(messung_driver main.cpp)
target_compile_features(messung_driver PRIVATE cxx_std_23)
target_include_directories(messung_driver PRIVATE
    ${COMDARE_CACHE_ENGINE_DIR}/cache_engine/include
    ${COMDARE_CACHE_ENGINE_DIR}/libs                 # V41.B3 (welch_t_test.hpp)
    ${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine/include
    ${COMDARE_PRT_ART_DIR}/prt_art/include
)
# Library-Konsum: ExperimentDriver (cache-engine REV 7.6) + workload_generator
target_link_libraries(messung_driver PRIVATE
    comdare_builder_experiment_driver
    comdare::workload_generator
)
set_target_properties(messung_driver PROPERTIES
    OUTPUT_NAME "comdare-messung-driver"
)

if(TARGET comdare::profile_run_facade)
    target_link_libraries(messung_driver PRIVATE comdare::profile_run_facade)
    target_compile_definitions(messung_driver PRIVATE COMDARE_MESSUNG_HAVE_E4_FACADE=1)
    set(_comdare_default_thesis_profile
        "${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine/algorithm_profiles/thesis_profiles/m3v2_study.profile.xml")
    target_compile_definitions(messung_driver PRIVATE
        "COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE=\"${_comdare_default_thesis_profile}\"")
    # Bruecke-I2 (2026-07-16): die 2 STATISCHEN Registry-Pfade (2-Registry-Kanon) als compile-defs am
    # messung_driver-Target. main.cpp liest sie via #ifdef und reicht sie an validate_experiment_profile_facade
    # herein — je Engine EINE Registry an ihrem dokumentierten Pfad (verschiedene Verzeichnisse!); die ce-Fassade
    # haelt KEINEN prt-art-Pfad hart vor (ce=Framework, kennt das prt-art-Repo-Layout nicht — Baseline-Layering).
    target_compile_definitions(messung_driver PRIVATE
        "COMDARE_CE_AXIS_REGISTRY_PATH=\"${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml\""
        "COMDARE_PRT_AXIS_REGISTRY_PATH=\"${COMDARE_PRT_ART_DIR}/prt_art/algorithm_profiles/prt_art_axis_registry.xml\"")
    message(STATUS "[messung_driver] E4-XML-Fassade angedockt (opt-in COMDARE_RUN_E4_XML=1)")
else()
    # FATAL statt WARNING: ce und super werden atomar (Submodul-Bump) versioniert -- ein fehlendes
    # Fassaden-Target heisst de-synchronisierter ce-Klon, und COMDARE_RUN_E4_XML=1 wuerde zur
    # Laufzeit sonst kommentarlos ignoriert (silent feature loss).
    message(FATAL_ERROR "[messung_driver] comdare::profile_run_facade nicht verfuegbar -- ce-Klon nicht synchron?")
endif()

# V32.JJ.2 (2026-05-18 spaet) - V32 Orchestrator-Header verfuegbar machen
option(COMDARE_V32_ENABLE "Enable V32 Orchestrator (parallele EE-Submission via Command-Pattern)" OFF)
if(COMDARE_V32_ENABLE)
    target_compile_definitions(messung_driver PRIVATE COMDARE_V32_ENABLE=1)
    target_include_directories(messung_driver PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}  # fuer v32_orchestrator.hpp
    )
    message(STATUS "[messung_driver] V32 Orchestrator AKTIVIERT (parallele EE-A + EE-B)")
else()
    message(STATUS "[messung_driver] V32 Orchestrator DEAKTIVIERT (V31.F Default)")
endif()

# INC-F (C.1, 2026-07-14) — INERT-Flag COMDARE_V32_DRIVER_ENABLE: die F-Verdrahtung (Surrogat -> reale
# CEB-Katalog-Tier im EE-A/EE-B-Vergleich, W4-Gate) lebt in v32_katalog_driver.hpp und hat im Default-Build
# KEINEN Konsumenten. Flag OFF (Muster COMDARE_V32_ENABLE oben) => messung_driver byte-identisch, golden-320
# unveraendert. Nur bei Flag ON wird der W4-Gate-Mess-Test gebaut (frisch, mit COMDARE_MEASUREMENT_ON + dem
# vollen ce-Anatomie-/Achsen-Include-Satz — identisch zu den ce-measured-Tests).
option(COMDARE_V32_DRIVER_ENABLE "Enable INC-F katalog driver (real CEB tier in EE-A/EE-B, W4-gate)" OFF)
if(COMDARE_V32_DRIVER_ENABLE)
    target_compile_definitions(messung_driver PRIVATE COMDARE_V32_DRIVER_ENABLE=1)
    target_include_directories(messung_driver PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

    # Die generierten axis_*_flags-Include-Dirs kommen ueber die GLOBAL-Property, die der ce-Subbuild exportiert
    # (tests/unit/CMakeLists.txt) — single-source, kein Drift.
    get_property(_ce_axis_gen_dirs GLOBAL PROPERTY COMDARE_CE_AXIS_GENERATED_DIRS)

    add_executable(test_v32_katalog_driver tests/test_v32_katalog_driver.cpp)
    target_compile_features(test_v32_katalog_driver PRIVATE cxx_std_23)
    target_include_directories(test_v32_katalog_driver PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}                                    # v32_katalog_driver.hpp
        ${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine
        ${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine/include
        ${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine/src
        ${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine/profile_facade   # sota_catalog.hpp (Katalog-Typ-Identitaet)
        ${COMDARE_CACHE_ENGINE_DIR}/libs/common
        ${COMDARE_CACHE_ENGINE_DIR}/libs/common/serialization
        ${CMAKE_BINARY_DIR}/_cache_engine_external/generated
        ${_ce_axis_gen_dirs})
    target_link_libraries(test_v32_katalog_driver PRIVATE Boost::mp11 comdare_builder_xml_config_parser)
    target_compile_definitions(test_v32_katalog_driver PRIVATE
        COMDARE_V32_DRIVER_ENABLE=1
        COMDARE_MEASUREMENT_ON=1 COMDARE_CE_ENABLE_STATISTICS=1 COMDARE_EXPERIMENT_MODE_ON=1
        "COMDARE_V32_DRIVER_HDR=\"${CMAKE_CURRENT_SOURCE_DIR}/v32_katalog_driver.hpp\""
        "COMDARE_CE_LIB_DIR=\"${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine\""
        "COMDARE_GOLDEN_320_IDS=\"${COMDARE_CACHE_ENGINE_DIR}/tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt\"")
    if(COMMAND comdare_set_platform_defines)
        comdare_set_platform_defines(test_v32_katalog_driver)
    endif()
    add_test(NAME test_v32_katalog_driver COMMAND test_v32_katalog_driver)
    set_tests_properties(test_v32_katalog_driver PROPERTIES LABELS "da_unit;inc_f;measured;w4_gate" TIMEOUT 300)
    set_property(GLOBAL APPEND PROPERTY COMDARE_DA_TEST_TARGETS test_v32_katalog_driver)
    message(STATUS "[messung_driver] INC-F Katalog-Treiber AKTIVIERT (W4-Gate test_v32_katalog_driver)")

    # INC-G (C.2) + INC-H (C.3, 2026-07-14) — Flag-ON-Gate der execute_messreihe-Verdrahtung
    # (v32_messreihe_antrieb.hpp): parse (INC-D) -> validate (INC-D) -> Phasen-Strategy (INC-E) ->
    # INC-F-Katalog-Treiber -> MessreiheReport -> messreihe_report_exporter (CSV/TikZ). Baut FRISCH mit
    # COMDARE_V32_DRIVER_ENABLE + COMDARE_MEASUREMENT_ON (== INC-F). Zusaetzlich zum INC-F-Include-Satz braucht
    # dieser Test die exporter/orchestrator-Include-Roots (${COMDARE_CACHE_ENGINE_DIR}/libs +
    # ${COMDARE_PRT_ART_DIR}/prt_art/include, tests/CMakeLists.txt:86-93) und die comdare::platform-Bruecke
    # (#265-b: messreihe_report_exporter.hpp zieht v32_orchestrator -> auto_permutator -> comdare::platform).
    add_executable(test_v32_messreihe_antrieb tests/test_v32_messreihe_antrieb.cpp)
    target_compile_features(test_v32_messreihe_antrieb PRIVATE cxx_std_23)
    target_include_directories(test_v32_messreihe_antrieb PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}                                    # v32_messreihe_antrieb.hpp + INC-D/E/F-Header
        ${COMDARE_CACHE_ENGINE_DIR}/libs                               # cache_engine/... (v32_orchestrator/op_type)
        ${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine
        ${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine/include
        ${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine/src
        ${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine/profile_facade
        ${COMDARE_CACHE_ENGINE_DIR}/libs/common
        ${COMDARE_CACHE_ENGINE_DIR}/libs/common/serialization
        ${COMDARE_PRT_ART_DIR}/prt_art/include                         # prt_art/... (v32_orchestrator-Struct-Include)
        ${CMAKE_BINARY_DIR}/_cache_engine_external/generated
        ${_ce_axis_gen_dirs})
    target_link_libraries(test_v32_messreihe_antrieb PRIVATE
        Boost::mp11 comdare_builder_xml_config_parser comdare::platform)
    target_compile_definitions(test_v32_messreihe_antrieb PRIVATE
        COMDARE_V32_DRIVER_ENABLE=1
        COMDARE_MEASUREMENT_ON=1 COMDARE_CE_ENABLE_STATISTICS=1 COMDARE_EXPERIMENT_MODE_ON=1
        "COMDARE_V32_ANTRIEB_HDR=\"${CMAKE_CURRENT_SOURCE_DIR}/v32_messreihe_antrieb.hpp\""
        "COMDARE_V32_DRIVER_HDR=\"${CMAKE_CURRENT_SOURCE_DIR}/v32_katalog_driver.hpp\""
        "COMDARE_V32_EXPERIMENT_GOLDEN_XML=\"${CMAKE_CURRENT_SOURCE_DIR}/../test_data_xml/experiment_golden.xml\""
        "COMDARE_GOLDEN_320_IDS=\"${COMDARE_CACHE_ENGINE_DIR}/tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt\"")
    if(COMMAND comdare_set_platform_defines)
        comdare_set_platform_defines(test_v32_messreihe_antrieb)
    endif()
    add_test(NAME test_v32_messreihe_antrieb COMMAND test_v32_messreihe_antrieb)
    set_tests_properties(test_v32_messreihe_antrieb PROPERTIES
        LABELS "da_unit;inc_g;inc_h;measured;w4_gate" TIMEOUT 300)
    set_property(GLOBAL APPEND PROPERTY COMDARE_DA_TEST_TARGETS test_v32_messreihe_antrieb)
    message(STATUS "[messung_driver] INC-G+H execute_messreihe-Antrieb AKTIVIERT (Flag-ON test_v32_messreihe_antrieb)")
else()
    message(STATUS "[messung_driver] INC-F Katalog-Treiber DEAKTIVIERT (Surrogat-Default, INERT)")
endif()

# V36.D (2026-05-23) - Runtime-Check fuer Pre-Build-Permutationen
# Pfade zur generierten Manifests via compile-time defines durchreichen.
target_compile_definitions(messung_driver PRIVATE
    "COMDARE_PERMUTATIONS_MANIFEST_CE=\"${CMAKE_BINARY_DIR}/generated/permutations_manifest.txt\""
    "COMDARE_PERMUTATIONS_MANIFEST_PA=\"${CMAKE_BINARY_DIR}/generated/prt_art_permutations_manifest.txt\"")

# #31 (2026-07-11) — Regressions-Gate der E4-XML-Workload-Drive (messreihen_workload.hpp): reine Host-Logik
# ueber den ce-DOM-Reader auf synthetischem XML-String (gate-frei, kein Treiber-Lauf, kein #156-Messdaten).
add_executable(test_messreihen_workload tests/test_messreihen_workload.cpp)
target_compile_features(test_messreihen_workload PRIVATE cxx_std_23)
target_include_directories(test_messreihen_workload PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${COMDARE_CACHE_ENGINE_DIR}/cache_engine/include
    ${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine/include
    ${COMDARE_CACHE_ENGINE_DIR}/libs/common/serialization
    ${COMDARE_CACHE_ENGINE_DIR}/libs/test_infra/workload_generator/include
)
add_test(NAME test_messreihen_workload COMMAND test_messreihen_workload)
# M-SU-07 (Muster-F, 2026-07-13): #31-Regressions-Gate lief in CI weder gebaut noch ausgefuehrt — bare add_test
# OHNE `LABELS da_unit` (→ `ctest -L da_unit` liess es aus) und OHNE Registry-Eintrag (→ nicht im Sammel-Bau
# comdare_da_unit_tests). Additiv nachgezogen: Label (macht es in test:unit lauffaehig) + COMDARE_DA_TEST_TARGETS
# (root sammelt es in comdare_da_unit_tests; 02_messung_driver wird vor dem Property-Read verarbeitet).
set_tests_properties(test_messreihen_workload PROPERTIES LABELS da_unit TIMEOUT 60)
set_property(GLOBAL APPEND PROPERTY COMDARE_DA_TEST_TARGETS test_messreihen_workload)

# INC-V32-C.parser (2026-07-14) — Unit-Gate der typisierten XML->Struct-Parse-Schicht
# (messreihe_v32_parser.hpp): liest Attribut- UND Element-Werte der gelieferten Beispiel-Instanz
# ueber den ce-DOM-Reader (comdare::common::xml). Gate-frei (reine Host-Logik, kein Treiber-Lauf,
# kein #156-Messdaten) und UNABHAENGIG vom COMDARE_V32_ENABLE-Gate (kein Orchestrator/Katalog).
add_executable(test_messreihe_v32_parser tests/test_messreihe_v32_parser.cpp)
target_compile_features(test_messreihe_v32_parser PRIVATE cxx_std_23)
target_include_directories(test_messreihe_v32_parser PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}                                # messreihe_v32_parser.hpp / _validator.hpp
    ${COMDARE_CACHE_ENGINE_DIR}/libs/common/serialization      # xml_config_parser/xml_reader.hpp (ce-DOM-Reader)
)
# Beispiel-XML deterministisch aus dem Source-Baum (Muster COMDARE_TEST_DATA_XML_DIR_FALLBACK).
target_compile_definitions(test_messreihe_v32_parser PRIVATE
    "COMDARE_V32_EXAMPLE_XML=\"${CMAKE_CURRENT_SOURCE_DIR}/../test_data_xml/messreihe_v32_schema_example.xml\"")
add_test(NAME test_messreihe_v32_parser COMMAND test_messreihe_v32_parser)
set_tests_properties(test_messreihe_v32_parser PROPERTIES LABELS da_unit TIMEOUT 60)
set_property(GLOBAL APPEND PROPERTY COMDARE_DA_TEST_TARGETS test_messreihe_v32_parser)

# INC-E (2026-07-14) — Unit-Gate des Experiment-Phase-Strategy-Pattern
# (experiment_phase_strategy.hpp): header-only, INERT (KEIN Konsument — die
# Orchestrator-Verdrahtung ist Stufe G). Der Test instanziiert die 3 Strategies
# compile-time, prueft select_merge() je Phase, den Concept-Guard (positiv+negativ)
# und kein-vtable — alles Compile-Time-/Host-Logik, gate-frei (kein Treiber-Lauf,
# kein #156-Messdaten) und UNABHAENGIG vom COMDARE_V32_ENABLE-Gate.
# Include-Roots: das 02-Verzeichnis (Strategy-Header) + der ce-Root libs/cache_engine
# (fuer <anatomy/pruefling_merge.hpp>, die MergeStrategy-Single-Source). Boost::mp11
# liefert den boost/mp11.hpp-Include-Dir (INTERFACE, kein Compile) fuer das ce-Header.
add_executable(test_experiment_phase_strategy tests/test_experiment_phase_strategy.cpp)
target_compile_features(test_experiment_phase_strategy PRIVATE cxx_std_23)
target_include_directories(test_experiment_phase_strategy PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}                     # experiment_phase_strategy.hpp
    ${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine   # <anatomy/pruefling_merge.hpp> (MergeStrategy-Single-Source)
)
target_link_libraries(test_experiment_phase_strategy PRIVATE Boost::mp11)
add_test(NAME test_experiment_phase_strategy COMMAND test_experiment_phase_strategy)
set_tests_properties(test_experiment_phase_strategy PROPERTIES LABELS da_unit TIMEOUT 60)
set_property(GLOBAL APPEND PROPERTY COMDARE_DA_TEST_TARGETS test_experiment_phase_strategy)

# Scheibe 2a (2026-07-21, Ledger 61/62) - Unit-Gate der Lane-Fehlrouting-Wache (lane_vendor_guard.hpp):
# reine Host-Logik (check_lane_vendor Match/Mismatch/Skip + Lane-Praefix-Parsing + Laufzeit-CPUID-Vendor).
# Header-only, keine ce/prt-Includes, gate-frei (kein Treiber-Lauf, kein #156-Messdaten), UNABHAENGIG vom
# COMDARE_V32_ENABLE-Gate. Include-Root: nur das 02-Verzeichnis (lane_vendor_guard.hpp).
add_executable(test_lane_vendor_guard tests/test_lane_vendor_guard.cpp)
target_compile_features(test_lane_vendor_guard PRIVATE cxx_std_23)
target_include_directories(test_lane_vendor_guard PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR})                    # lane_vendor_guard.hpp
add_test(NAME test_lane_vendor_guard COMMAND test_lane_vendor_guard)
set_tests_properties(test_lane_vendor_guard PROPERTIES LABELS da_unit TIMEOUT 60)
set_property(GLOBAL APPEND PROPERTY COMDARE_DA_TEST_TARGETS test_lane_vendor_guard)
