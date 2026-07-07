# tests/ — Diplomarbeit/Code Tests
# Konsumiert die 5 Pipeline-Module + GoogleTest (von top-level FetchContent).

include(GoogleTest)

function(comdare_da_add_test name)
    cmake_parse_arguments(ARG "" "" "SOURCES;LIBRARIES" ${ARGN})
    add_executable(${name} ${ARG_SOURCES})
    # CI-Registry (User 06.07.: Tests nie manual/auslassen): Root sammelt zu comdare_da_unit_tests.
    set_property(GLOBAL APPEND PROPERTY COMDARE_DA_TEST_TARGETS ${name})
    target_link_libraries(${name} PRIVATE
        gtest gtest_main
        ${ARG_LIBRARIES})
    target_compile_features(${name} PRIVATE cxx_std_23)
    gtest_discover_tests(${name}
        DISCOVERY_TIMEOUT 30
        PROPERTIES TIMEOUT 60 LABELS da_unit)
endfunction()

comdare_da_add_test(test_binary_to_csv
    SOURCES unit/test_binary_to_csv.cpp
    LIBRARIES comdare::binary_to_csv)

comdare_da_add_test(test_csv_to_latex
    SOURCES unit/test_csv_to_latex.cpp
    LIBRARIES comdare::csv_to_latex)

comdare_da_add_test(test_diagram_generator
    SOURCES unit/test_diagram_generator.cpp
    LIBRARIES comdare::diagram_generator)

# V41.P1 (2026-05-31) — Cross-Stage-Test: 16-Spalten-Schema-Kohärenz Stufe 03 → 04 → 05
# (deckt den vom E2E-Abnahme-Audit gefundenen CSV-Schema-Bruch ab, der vorher in keinem Test sichtbar war).
comdare_da_add_test(test_pipeline_cross_stage
    SOURCES unit/test_pipeline_cross_stage.cpp
    LIBRARIES comdare::binary_to_csv comdare::csv_to_latex comdare::diagram_generator)

comdare_da_add_test(test_messung_driver
    SOURCES unit/test_messung_driver.cpp
    LIBRARIES
        comdare_builder_experiment_driver
        comdare::workload_generator
        comdare::experiment)
target_include_directories(test_messung_driver PRIVATE
    ${COMDARE_CACHE_ENGINE_DIR}/cache_engine/include)

# V41.G.1 (2026-05-31) - Hierarchischer Achsen-Baum (axis_tree.hpp, pure std → immer gebaut)
comdare_da_add_test(test_axis_tree
    SOURCES unit/test_axis_tree.cpp)
target_include_directories(test_axis_tree PRIVATE
    ${CMAKE_SOURCE_DIR}/02_messung_driver)

# V41.P5 (G10, 2026-05-31) - op_type_filter: wirksame OP-1..OP-6 → WorkloadKind
# (header-only: braucht nur cache-engine workload.hpp + 02_messung_driver → immer gebaut,
#  unabhaengig vom COMDARE_V32_ENABLE-Gate, das die schweren Orchestrator-Tests bedingt).
comdare_da_add_test(test_op_type_filter
    SOURCES unit/test_op_type_filter.cpp)
target_include_directories(test_op_type_filter PRIVATE
    ${CMAKE_SOURCE_DIR}/02_messung_driver
    ${COMDARE_CACHE_ENGINE_DIR}/libs)

# V32.II.3 (2026-05-21) + V33.C.2 (2026-05-21) - V32Orchestrator Tests
# V33.C.2: Include-Pfade fuer cache-engine V32 commands + prt-art default_lookup
if(COMDARE_V32_ENABLE)
    comdare_da_add_test(test_v32_orchestrator
        SOURCES unit/test_v32_orchestrator.cpp)
    target_include_directories(test_v32_orchestrator PRIVATE
        ${CMAKE_SOURCE_DIR}/02_messung_driver
        ${COMDARE_CACHE_ENGINE_DIR}/libs
        ${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine/include
        ${COMDARE_PRT_ART_DIR}/prt_art/include)
    # #265-b: die AP-3-Bruecke (via auto_permutator) konsumiert die vendored foundation-Zelle
    # comdare::platform — MATRIX-WEIT-Regel: super-Konsumenten der ce-Header linken das Target mit.
    target_link_libraries(test_v32_orchestrator PRIVATE comdare::platform)

    # V33.D.3 (2026-05-21) - MessreiheV32Validator-Tests
    comdare_da_add_test(test_messreihe_v32_validator
        SOURCES unit/test_messreihe_v32_validator.cpp)
    # CWD-Stray-Haertung (Fix 2026-07-06, Muster COMDARE_FIXTURES_DIR_03_FALLBACK): Source-Dir-Fallback
    # fuer das gelieferte Beispiel-XML — der fruehere GTEST_SKIP maskierte den Test in CI/ctest komplett.
    target_compile_definitions(test_messreihe_v32_validator PRIVATE
        "COMDARE_TEST_DATA_XML_DIR_FALLBACK=\"${CMAKE_CURRENT_SOURCE_DIR}/../test_data_xml\"")
    target_include_directories(test_messreihe_v32_validator PRIVATE
        ${CMAKE_SOURCE_DIR}/02_messung_driver)

    # V33.E.4 (2026-05-21) - HardwareFilter Tests (Q.1)
    comdare_da_add_test(test_dataset_filter
        SOURCES unit/test_dataset_filter.cpp)
    target_include_directories(test_dataset_filter PRIVATE
        ${CMAKE_SOURCE_DIR}/02_messung_driver)

    # V34.B.2 (2026-05-21) - MessreiheReportExporter Tests
    comdare_da_add_test(test_messreihe_report_exporter
        SOURCES unit/test_messreihe_report_exporter.cpp)
    target_include_directories(test_messreihe_report_exporter PRIVATE
        ${CMAKE_SOURCE_DIR}/02_messung_driver
        ${COMDARE_CACHE_ENGINE_DIR}/libs
        ${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine/include
        ${COMDARE_PRT_ART_DIR}/prt_art/include)
    # #265-b: s.o. — messreihe_report_exporter.hpp zieht v32_orchestrator -> Bruecke -> comdare::platform.
    target_link_libraries(test_messreihe_report_exporter PRIVATE comdare::platform)
endif()
