# tests/ — Diplomarbeit/Code Tests
# Konsumiert die 5 Pipeline-Module + GoogleTest (von top-level FetchContent).

include(GoogleTest)

function(comdare_da_add_test name)
    cmake_parse_arguments(ARG "" "" "SOURCES;LIBRARIES" ${ARGN})
    add_executable(${name} ${ARG_SOURCES})
    target_link_libraries(${name} PRIVATE
        gtest gtest_main
        ${ARG_LIBRARIES})
    target_compile_features(${name} PRIVATE cxx_std_23)
    gtest_discover_tests(${name}
        DISCOVERY_TIMEOUT 30
        PROPERTIES TIMEOUT 60)
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

comdare_da_add_test(test_messung_driver
    SOURCES unit/test_messung_driver.cpp
    LIBRARIES
        comdare_builder_experiment_driver
        comdare::workload_generator
        comdare::experiment)
target_include_directories(test_messung_driver PRIVATE
    ${COMDARE_CACHE_ENGINE_DIR}/cache_engine/include)

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

    # V33.D.3 (2026-05-21) - MessreiheV32Validator-Tests
    comdare_da_add_test(test_messreihe_v32_validator
        SOURCES unit/test_messreihe_v32_validator.cpp)
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
endif()
