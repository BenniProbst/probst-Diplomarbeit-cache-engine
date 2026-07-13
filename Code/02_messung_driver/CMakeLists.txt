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
