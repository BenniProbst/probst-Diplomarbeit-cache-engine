# diagram_generator — C++ Bildgenerator (TikZ-Output, A4-aware)
# Liest CSV → schreibt TikZ-Code → wird in LaTeX-Manuskript eingebunden.

comdare_da_add_library(comdare_diagram_generator MODULE M05 SOURCES
    diagram_generator.cpp
)
target_compile_features(comdare_diagram_generator PUBLIC cxx_std_23)
# M-4/B16 (2026-07-19): Segment-Zaehlung + -Spaltennamen kommen aus der CE-Single-Source
# (anatomy/observable_tier.hpp kV3AxisCount + builder/experiment_tree/axis_path_serialization.hpp
# kCompositionAxisNames) statt aus lokalen 19/20-Literalen. PUBLIC, weil diagram_generator.hpp die
# CE-Header einbindet (Konsumenten 08/Tests erben die Pfade transitiv; Muster wie Stufe 03 mit
# COMDARE_CACHE_ENGINE_DIR). Lese-Zugriff auf CE-Header, KEIN Link gegen CE-Code.
target_include_directories(comdare_diagram_generator PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine
)
# INC-4 (2026-07-13): write_axis_observer_detail_table konsumiert c2l::WideFullRow (stat_<achse>_<feld>-Block)
# → PUBLIC-Link auf csv_to_latex (Typ steht im öffentlichen Header diagram_generator.hpp). 04 wird vor 05 als
# add_subdirectory eingebunden (Code/CMakeLists.txt:315-316) → das Alias-Target existiert.
# Boost::mp11: header-only Interface-Target des eingebetteten CE-Subprojekts (boost_mp11_setup.cmake) —
# axis_path_serialization.hpp inkludiert <boost/mp11.hpp>; PUBLIC wegen Header-Transitivitaet.
target_link_libraries(comdare_diagram_generator PUBLIC comdare::csv_to_latex Boost::mp11)
add_library(comdare::diagram_generator ALIAS comdare_diagram_generator)

add_executable(diagram_generator_cli main_cli.cpp)
target_compile_features(diagram_generator_cli PRIVATE cxx_std_23)
target_link_libraries(diagram_generator_cli PRIVATE comdare::diagram_generator)
set_target_properties(diagram_generator_cli PROPERTIES
    OUTPUT_NAME "diagram-generator"
)

# V35.D.3 (2026-05-22) - Stufen-Test mit gecachten Fixtures
if(COMDARE_DA_BUILD_TESTS)
    include(GoogleTest)
    add_executable(test_05_diagram_generator_cached_fixtures
        tests/test_05_diagram_generator_cached_fixtures.cpp)
    target_link_libraries(test_05_diagram_generator_cached_fixtures PRIVATE
        comdare::diagram_generator
        gtest gtest_main)
    target_compile_features(test_05_diagram_generator_cached_fixtures PRIVATE cxx_std_23)
    set(_fix05 "${CMAKE_CURRENT_SOURCE_DIR}/tests/fixtures/cached")
    # Deterministischer Source-Dir-Fallback (kein CWD-Stray bei manuellem .exe-Start) — 2026-06-01 gehärtet.
    target_compile_definitions(test_05_diagram_generator_cached_fixtures PRIVATE
        "COMDARE_FIXTURES_DIR_05_FALLBACK=\"${_fix05}\"")
    gtest_discover_tests(test_05_diagram_generator_cached_fixtures
        DISCOVERY_TIMEOUT 30
        PROPERTIES
            TIMEOUT 60
            LABELS da_unit
            ENVIRONMENT "COMDARE_FIXTURES_DIR_05=${_fix05}")
endif()
