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
