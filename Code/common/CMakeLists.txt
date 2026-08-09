# common -- geteilte, header-only Bausteine der super-Auswertekette.
# D5-2 (2026-08-09): percentile_canon.hpp ist der EINE super-seitige Zugang zum
# Perzentil-KANON der cache-engine (nearest_rank_index aus latency_stats.hpp).
#
# INTERFACE-Bibliothek ohne comdare_da_add_library: das ist keine Pipeline-Stufe
# (01..09), sondern ein geteilter Header -- dasselbe Muster wie
# 07_tier_binary_report (add_library(... INTERFACE) + ALIAS).
#
# Die Include-Wurzel ${COMDARE_CACHE_ENGINE_DIR}/libs ist dieselbe, ueber die
# 02_messung_driver bereits das Schwester-Header welch_t_test.hpp einbindet.
# Reiner Lese-Zugriff auf CE-Header, KEIN Link gegen CE-Code.
add_library(comdare_percentile_canon INTERFACE)
target_include_directories(comdare_percentile_canon INTERFACE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${COMDARE_CACHE_ENGINE_DIR}/libs)
target_compile_features(comdare_percentile_canon INTERFACE cxx_std_23)
add_library(comdare::percentile_canon ALIAS comdare_percentile_canon)

# T-5 Kreuz-Test: der Kanon gegen VON HAND gerechnete Sollwerte auf GERADER Laenge
# (dort und nur dort divergieren Kanon und die verworfene Formel) + Zufallslauf
# gegen ein unabhaengiges Brute-Force-Orakel (T-4 Gegeneingang) mit gedrucktem Seed.
if(COMDARE_DA_BUILD_TESTS)
    include(GoogleTest)
    add_executable(test_common_percentile_canon tests/test_percentile_canon.cpp)
    target_link_libraries(test_common_percentile_canon PRIVATE
        comdare::percentile_canon
        gtest gtest_main)
    target_compile_features(test_common_percentile_canon PRIVATE cxx_std_23)
    gtest_discover_tests(test_common_percentile_canon
        DISCOVERY_TIMEOUT 30
        PROPERTIES
            TIMEOUT 60
            LABELS da_unit)
endif()
