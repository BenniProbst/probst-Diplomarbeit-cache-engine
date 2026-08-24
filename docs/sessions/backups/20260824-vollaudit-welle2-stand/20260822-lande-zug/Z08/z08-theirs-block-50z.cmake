
# =============================================================================
# #97/E-12 SKIP-OEKONOMIE (C-13 + C-14, 2026-08-21): eigener Block am DATEIENDE
# (Kollisionsschutz gegen die Bloecke anderer Straenge).
#
# C-14: die Bestandslog-SKIP-Wache an der Presence-Naht (lager_presence.hpp).
# SKIP nur bei BELEGTEM Eintrag je binary_id; der KON3-06-Koeder (kollabierter
# Leer-Zellen-Bestand + leere Lauf-Zelle) wird ROT. Include-/Link-Satz wie
# test_g3_lager_presence (ctsha512 via Index + Threads fuer den Zustands-Mutex).
comdare_add_test(test_c14_lager_presence_wache
    SOURCES test_c14_lager_presence_wache.cpp)
target_include_directories(test_c14_lager_presence_wache PRIVATE
    "${PROJECT_SOURCE_DIR}/libs/cache_engine/builder"
    "${PROJECT_SOURCE_DIR}/libs/cache_engine/include"
    "${PROJECT_SOURCE_DIR}/libs/cache_engine/src"
    "${PROJECT_SOURCE_DIR}/libs/common")
target_link_libraries(test_c14_lager_presence_wache PRIVATE Threads::Threads)
set_tests_properties(test_c14_lager_presence_wache PROPERTIES
    LABELS "c14;skip;bestandslog;wachen;koeder")

# C-13: das wiederhergestellte Entscheidungs-/Ausweis-Modul der Skip-Oekonomie
# (selektiver_rebuild.hpp; Nachfolger der mit 813c3232 entfernten V36.E-Maschinerie
# auf dem heutigen Stempel-Stand). Include-/Link-Satz identisch zum A2-Block:
# der Prueflig delegiert an dll_is_current (build_orchestrator.hpp), das zieht
# denselben Header-Satz wie test_a2_sha512_skip_gate/test_bvset_teilmenge.
add_executable(test_c13_selektiver_rebuild "test_c13_selektiver_rebuild.cpp")
target_compile_features(test_c13_selektiver_rebuild PRIVATE cxx_std_23)
target_include_directories(test_c13_selektiver_rebuild PRIVATE ${COMDARE_MCE24_INCLUDES})
target_link_libraries(test_c13_selektiver_rebuild PRIVATE gtest gtest_main Boost::mp11 comdare_builder_xml_config_parser)
comdare_set_platform_defines(test_c13_selektiver_rebuild)
add_test(NAME test_c13_selektiver_rebuild COMMAND test_c13_selektiver_rebuild)
set_property(GLOBAL APPEND PROPERTY COMDARE_TEST_TARGETS test_c13_selektiver_rebuild)
set_tests_properties(test_c13_selektiver_rebuild PROPERTIES
    LABELS "c13;skip;wachen;koeder")

# C-14-SCHWESTER (T-6 "beide Genera", Audit-Fund S97-F1, 2026-08-22): dieselbe
# SKIP-Wache im MEASUREMENT-Genus. MesswertRunState::lager_contains ist laut
# eigenem Docstring die Mess-Presence-Naht; der KON3-06-Koeder (kollabierter
# Leer-Zellen-Bestand + leere Lauf-Zelle) wird auch dort ROT. Include-/Link-Satz
# wie test_c14_lager_presence_wache (Zustands-Mutex braucht Threads).
comdare_add_test(test_c14_messwert_presence_wache
    SOURCES test_c14_messwert_presence_wache.cpp)
target_include_directories(test_c14_messwert_presence_wache PRIVATE
    "${PROJECT_SOURCE_DIR}/libs/cache_engine/builder"
    "${PROJECT_SOURCE_DIR}/libs/cache_engine/include"
    "${PROJECT_SOURCE_DIR}/libs/cache_engine/src"
    "${PROJECT_SOURCE_DIR}/libs/common")
target_link_libraries(test_c14_messwert_presence_wache PRIVATE Threads::Threads)
set_tests_properties(test_c14_messwert_presence_wache PROPERTIES
    LABELS "c14;skip;bestandslog;messwert;wachen;koeder")
