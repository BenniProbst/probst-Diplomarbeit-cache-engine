# tex_formatter — verlustfreie C++23-Portierung von thesis/diplomarbeit/tools/format_tex.py (#25).
# Satz-neutraler LaTeX-Quelltext-Formatierer: 2-Space-Einrueckung geschachtelter \begin..\end +
# Prosa-Hart-Umbruch auf 100 CODE-POINTS (UTF-8-korrekt). "Kein Python in der Chain" (Direktive):
# cross-platform in-place-Formatierer; loest format_tex.py ab (Python bleibt als Doku bestehen).

comdare_da_add_library(comdare_tex_formatter MODULE M09 SOURCES
    tex_formatter.cpp
)
target_compile_features(comdare_tex_formatter PUBLIC cxx_std_23)
target_include_directories(comdare_tex_formatter PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
add_library(comdare::tex_formatter ALIAS comdare_tex_formatter)

add_executable(tex_formatter_cli main_cli.cpp)
target_compile_features(tex_formatter_cli PRIVATE cxx_std_23)
target_link_libraries(tex_formatter_cli PRIVATE comdare::tex_formatter)
set_target_properties(tex_formatter_cli PROPERTIES OUTPUT_NAME "tex-formatter")

# Regressions-Test: format_text() byte-identisch zu den offline mit format_tex.py erzeugten
# golden-Outputs (KEIN Python im Test) + Idempotenz + Beweis der UTF-8-Code-Point-Zaehlung.
if(COMDARE_DA_BUILD_TESTS)
    include(GoogleTest)
    add_executable(test_09_tex_formatter
        tests/test_09_tex_formatter.cpp)
    target_link_libraries(test_09_tex_formatter PRIVATE
        comdare::tex_formatter
        gtest gtest_main)
    target_compile_features(test_09_tex_formatter PRIVATE cxx_std_23)
    set(_fix09 "${CMAKE_CURRENT_SOURCE_DIR}/tests/fixtures")
    # Deterministischer Source-Dir-Fallback (kein CWD-Stray bei manuellem .exe-Start).
    target_compile_definitions(test_09_tex_formatter PRIVATE
        "COMDARE_FIXTURES_DIR_09_FALLBACK=\"${_fix09}\"")
    gtest_discover_tests(test_09_tex_formatter
        DISCOVERY_TIMEOUT 30
        PROPERTIES
            TIMEOUT 60
            LABELS da_unit
            ENVIRONMENT "COMDARE_FIXTURES_DIR_09=${_fix09}")
endif()
