# appendix_generator — In-Process-Orchestrator (Facade) für den WIDE-Mess-Appendix.
# Ersetzt thesis/diplomarbeit/generate_wide_appendix.ps1 (Windows-only PowerShell-Behelfsweg)
# durch eine cross-platform C++23-Teil-Anwendung: linkt comdare::csv_to_latex +
# comdare::diagram_generator und ruft deren Writer IN-PROCESS (kein .exe-Spawn).

comdare_da_add_library(comdare_appendix_generator MODULE M08 SOURCES
    appendix_generator.cpp
)
target_compile_features(comdare_appendix_generator PUBLIC cxx_std_23)
target_include_directories(comdare_appendix_generator PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
# Fassade über die zwei Subsystem-Bibliotheken (PUBLIC → transitive Nutzung durch CLI/Test).
target_link_libraries(comdare_appendix_generator PUBLIC
    comdare::csv_to_latex
    comdare::diagram_generator)
add_library(comdare::appendix_generator ALIAS comdare_appendix_generator)

add_executable(appendix_generator_cli main_cli.cpp)
target_compile_features(appendix_generator_cli PRIVATE cxx_std_23)
target_link_libraries(appendix_generator_cli PRIVATE comdare::appendix_generator)
set_target_properties(appendix_generator_cli PROPERTIES OUTPUT_NAME "appendix-generator")

# Regressions-Test (Increment 1): In-Process-Orchestrator ≡ die bisherigen .exe-Spawns
# (bias/6×surface/exchange/limitierung) — byte-identische .tex je Sprache.
if(COMDARE_DA_BUILD_TESTS)
    include(GoogleTest)
    add_executable(test_08_appendix_generator
        tests/test_08_appendix_generator.cpp)
    target_link_libraries(test_08_appendix_generator PRIVATE
        comdare::appendix_generator
        comdare::csv_to_latex
        comdare::diagram_generator
        gtest gtest_main)
    target_compile_features(test_08_appendix_generator PRIVATE cxx_std_23)
    set(_fix08 "${CMAKE_CURRENT_SOURCE_DIR}/tests/fixtures/cached")
    # Deterministischer Source-Dir-Fallback (kein CWD-Stray bei manuellem .exe-Start).
    target_compile_definitions(test_08_appendix_generator PRIVATE
        "COMDARE_FIXTURES_DIR_08_FALLBACK=\"${_fix08}\"")
    gtest_discover_tests(test_08_appendix_generator
        DISCOVERY_TIMEOUT 30
        PROPERTIES
            TIMEOUT 120
            LABELS da_unit
            ENVIRONMENT "COMDARE_FIXTURES_DIR_08=${_fix08}")
endif()
