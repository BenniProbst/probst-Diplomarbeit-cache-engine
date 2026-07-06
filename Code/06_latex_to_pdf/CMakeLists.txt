# latex_to_pdf — Driver-Skript (CMake-only, kein C++)
# Liest LaTeX-Anhang (von csv_to_latex + diagram_generator) → pdflatex 2x + bibtex.
#
# Aufruf direkt via:
#   cmake -DCOMDARE_THESIS_SOURCE=<dir> -DCOMDARE_THESIS_OUTPUT=<dir> \
#         -P latex_toolchain.cmake

# Kopiere die Toolchain-CMake aus cache-engine/tools/latex_toolchain/
# in den Build-Output, damit sie aus Diplomarbeit/Code/build/ erreichbar ist.
configure_file(
    "${COMDARE_CACHE_ENGINE_DIR}/tools/latex_toolchain/latex_toolchain.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/latex_toolchain.cmake"
    COPYONLY)

# Standard-Driver-Skript (Frontend)
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/build_thesis.sh"
    "${CMAKE_CURRENT_BINARY_DIR}/build_thesis.sh"
    COPYONLY)
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/build_thesis.bat"
    "${CMAKE_CURRENT_BINARY_DIR}/build_thesis.bat"
    COPYONLY)

message(STATUS "latex_to_pdf: Toolchain bereit unter ${CMAKE_CURRENT_BINARY_DIR}")

# V35.D.4 (2026-05-22) - Stufen-Test mit gecachten Fixtures
if(COMDARE_DA_BUILD_TESTS)
    include(GoogleTest)
    add_executable(test_06_latex_to_pdf_cached_fixtures
        tests/test_06_latex_to_pdf_cached_fixtures.cpp)
    target_link_libraries(test_06_latex_to_pdf_cached_fixtures PRIVATE
        gtest gtest_main)
    target_compile_features(test_06_latex_to_pdf_cached_fixtures PRIVATE cxx_std_23)
    set(_fix06 "${CMAKE_CURRENT_SOURCE_DIR}/tests/fixtures/cached")
    set(_src06 "${CMAKE_CURRENT_SOURCE_DIR}")
    gtest_discover_tests(test_06_latex_to_pdf_cached_fixtures
        DISCOVERY_TIMEOUT 30
        PROPERTIES
            TIMEOUT 120
            LABELS da_unit
            ENVIRONMENT "COMDARE_FIXTURES_DIR_06=${_fix06};COMDARE_MODULE_SOURCE_DIR_06=${_src06}")
endif()
