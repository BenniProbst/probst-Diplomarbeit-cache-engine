# 07_tier_binary_report (#279-a) — nachgelagerte Ueberwachungs-Stufe:
# dynamische Build-Sichtbarkeit der Tier-Binary-Rekombinationen +
# Interface-Roster je Tier-Binary. Reine std-Logik (header-only), der
# dlopen-Teil der CLI nutzt den Loader aus 02_messung_driver wieder.

# Header-only Bibliothek (INTERFACE) — dlopen-frei, damit der Unit-Test
# ohne Plattform-Deps linkt.
add_library(comdare_tier_binary_report INTERFACE)
target_include_directories(comdare_tier_binary_report INTERFACE
    ${CMAKE_CURRENT_SOURCE_DIR})
target_compile_features(comdare_tier_binary_report INTERFACE cxx_std_23)
add_library(comdare::tier_binary_report ALIAS comdare_tier_binary_report)

# CLI: --visibility (rein) + --interface-check (dlopen via 02_messung_driver).
add_executable(tier_binary_report_cli main.cpp)
target_compile_features(tier_binary_report_cli PRIVATE cxx_std_23)
target_link_libraries(tier_binary_report_cli PRIVATE comdare::tier_binary_report)
target_include_directories(tier_binary_report_cli PRIVATE
    ${CMAKE_SOURCE_DIR}/02_messung_driver)   # plugin_loader.hpp wiederverwenden
if(NOT WIN32)
    target_link_libraries(tier_binary_report_cli PRIVATE ${CMAKE_DL_LIBS})
endif()
set_target_properties(tier_binary_report_cli PROPERTIES
    OUTPUT_NAME "tier-binary-report")
