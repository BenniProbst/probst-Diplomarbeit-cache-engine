# csv_to_latex — CSV + Algorithmus-Baustein-Beschreibungen → LaTeX
# Konsumiert binary_to_csv-Output + bausteine_descriptions JSON/XML.

comdare_da_add_library(comdare_csv_to_latex MODULE M04 SOURCES
    csv_to_latex.cpp
)
target_compile_features(comdare_csv_to_latex PUBLIC cxx_std_23)
target_include_directories(comdare_csv_to_latex PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
add_library(comdare::csv_to_latex ALIAS comdare_csv_to_latex)

add_executable(csv_to_latex_cli main_cli.cpp)
target_compile_features(csv_to_latex_cli PRIVATE cxx_std_23)
target_link_libraries(csv_to_latex_cli PRIVATE comdare::csv_to_latex)
set_target_properties(csv_to_latex_cli PROPERTIES OUTPUT_NAME "csv-to-latex")

# V35.D.2 (2026-05-22) - Stufen-Test mit gecachten Fixtures
if(COMDARE_DA_BUILD_TESTS)
    include(GoogleTest)
    add_executable(test_04_csv_to_latex_cached_fixtures
        tests/test_04_csv_to_latex_cached_fixtures.cpp)
    target_link_libraries(test_04_csv_to_latex_cached_fixtures PRIVATE
        comdare::csv_to_latex
        gtest gtest_main)
    target_compile_features(test_04_csv_to_latex_cached_fixtures PRIVATE cxx_std_23)
    set(_fix04 "${CMAKE_CURRENT_SOURCE_DIR}/tests/fixtures/cached")
    # Deterministischer Source-Dir-Fallback (kein CWD-Stray bei manuellem .exe-Start) — 2026-06-01 gehärtet.
    target_compile_definitions(test_04_csv_to_latex_cached_fixtures PRIVATE
        "COMDARE_FIXTURES_DIR_04_FALLBACK=\"${_fix04}\"")
    gtest_discover_tests(test_04_csv_to_latex_cached_fixtures
        DISCOVERY_TIMEOUT 30
        PROPERTIES
            TIMEOUT 60
            LABELS da_unit
            ENVIRONMENT "COMDARE_FIXTURES_DIR_04=${_fix04}")
endif()
