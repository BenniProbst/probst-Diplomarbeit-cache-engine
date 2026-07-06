# binary_to_csv — Deserialisiert measurement_record_v1 binary → CSV
# Konsumiert cache-engine ABI (module_abi_v1.hpp).

comdare_da_add_library(comdare_binary_to_csv MODULE M03 SOURCES
    binary_to_csv.cpp
)
target_compile_features(comdare_binary_to_csv PUBLIC cxx_std_23)
target_include_directories(comdare_binary_to_csv PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine/include
)
add_library(comdare::binary_to_csv ALIAS comdare_binary_to_csv)

add_executable(binary_to_csv_cli main_cli.cpp)
target_compile_features(binary_to_csv_cli PRIVATE cxx_std_23)
target_link_libraries(binary_to_csv_cli PRIVATE comdare::binary_to_csv)
set_target_properties(binary_to_csv_cli PROPERTIES
    OUTPUT_NAME "binary-to-csv"
)

# V35.D.1 (2026-05-22) - Stufen-Test mit gecachten Fixtures
if(COMDARE_DA_BUILD_TESTS)
    include(GoogleTest)
    add_executable(test_03_binary_to_csv_cached_fixtures
        tests/test_03_binary_to_csv_cached_fixtures.cpp)
    target_link_libraries(test_03_binary_to_csv_cached_fixtures PRIVATE
        comdare::binary_to_csv
        gtest gtest_main)
    target_compile_features(test_03_binary_to_csv_cached_fixtures PRIVATE cxx_std_23)
    # Pfad zu den gecachten Fixtures via ENV-Variable (CMake setzt sie als TEST_ENVIRONMENT)
    set(_fix03 "${CMAKE_CURRENT_SOURCE_DIR}/tests/fixtures/cached")
    # Deterministischer Source-Dir-Fallback (kein CWD-Stray bei manuellem .exe-Start) — 2026-06-01 gehärtet.
    target_compile_definitions(test_03_binary_to_csv_cached_fixtures PRIVATE
        "COMDARE_FIXTURES_DIR_03_FALLBACK=\"${_fix03}\"")
    gtest_discover_tests(test_03_binary_to_csv_cached_fixtures
        DISCOVERY_TIMEOUT 30
        PROPERTIES
            TIMEOUT 60
            LABELS da_unit
            ENVIRONMENT "COMDARE_FIXTURES_DIR_03=${_fix03}")
endif()
