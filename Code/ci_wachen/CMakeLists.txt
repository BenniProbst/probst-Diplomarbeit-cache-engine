# ci_wachen -- die CI-Wachen als C++-Bibliothek + zwei duenne Binaries. (2026-08-09)
#
# WARUM DIESES MODUL EXISTIERT (Owner-KERN 09.08.):
#   "Ich sehe einen Haufen shells statt vernuenftiger google tests, was soll das? Es
#    waere SAUBERER IM CMAKE-DEBUG MODUS STANDARD GOOGLE TESTS ZU FAHREN UND DIESE IN
#    RELEASE ZU WIEDERHOLEN AUFGRUND VON COMPILE REGRESSIONEN. SKRIPTE SAGEN GAR NICHTS."
# und der Rahmen dazu: "es war ja auch nur C++ und cmake erlaubt, es gibt ja keine skripte."
#
# WARUM ER RECHT HAT, AM OBJEKT GEMESSEN: die richtige Form ist im Haus laengst die
# Regel -- ce tests/unit haelt 98 Testziele und 223 gtest-Dateien. Dagegen standen
# 5 Shell-Proben in super/ci/tests. Die Shell-Form ist der AUSREISSER, und sie hat am
# 09.08. messbar versagt (Begruendung im Kopf von prozess.hpp: rc=127 galt als Biss).
#
# PLATZIERUNG: Code/ci_wachen/ steht bewusst OHNE Nummern-Praefix. Die Nummern 01..09
# sind die Stufen der Mess-Pipeline (PROJECT_LAYER_MAP Abschnitt 6.5); eine CI-Wache ist
# keine Pipeline-Stufe. Das Muster gibt es hier bereits: Code/cmake/, Code/tests/,
# Code/experiment_config/, Code/external/ tragen ebenfalls keine Stufen-Nummer.
#
# VIER-BINARY-TYPEN-DOKTRIN: die zwei Wrapper sind CI-Infrastruktur wie die 98
# ce-Testziele, NICHT Teil des Mess-Systems (Planer/CEB/Tier/Hybrid). Sie loesen 2 der
# 42 Skripte ab und tragen keine Mess-Funktionalitaet -- die Substanz liegt in der
# Bibliothek, main() ist argv -> lib -> Exit-Mapping.
#
# ASCII-only, Zeilen <= 120 Byte.

comdare_da_add_library(comdare_ci_wachen MODULE M10 SOURCES
    src/prozess.cpp
    src/xml_parser.cpp
    src/git_quelle.cpp
    src/xml_wellformed.cpp
    src/gitlink_parity.cpp
    src/ci_yml_scanner.cpp
)
target_compile_features(comdare_ci_wachen PUBLIC cxx_std_23)
target_include_directories(comdare_ci_wachen PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)
add_library(comdare::ci_wachen ALIAS comdare_ci_wachen)

# -Werror=return-type / -Werror=switch sind die STUFE-1-HAERTUNG des Mutations-Beweises
# (Begruendung im Kopf von test_ci_wache_xml_wellformed.cpp): der Shell-Mutant "ein exit
# faellt heraus -> Fall-through" hat hier kein Analogon, weil jede Verzweigung ein
# Ergebnis RETURNT und ein fehlendes return bereits den BAU bricht. Bewusst nur auf
# diesem Target: es ist eine Zusicherung dieses Moduls, keine hausweite Umstellung.
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(comdare_ci_wachen PRIVATE
        -Werror=return-type
        -Werror=switch)
endif()

# -- Die zwei Produktions-Binaries ----------------------------------------------------
# AUSSERHALB des COMDARE_DA_BUILD_TESTS-Gates: sie sind Produktionswerkzeug der CI und
# muessen auch dann gebaut werden, wenn die Tests abgeschaltet sind. Die Tests liegen
# INNERHALB des Gates (Code/tests/CMakeLists.txt).
add_executable(ci_xml_wellformed_wache tools/xml_wellformed_main.cpp)
target_compile_features(ci_xml_wellformed_wache PRIVATE cxx_std_23)
target_link_libraries(ci_xml_wellformed_wache PRIVATE comdare::ci_wachen)
set_target_properties(ci_xml_wellformed_wache PROPERTIES OUTPUT_NAME "ci-xml-wellformed-wache")

add_executable(ci_thesis_gitlink_wache tools/gitlink_parity_main.cpp)
target_compile_features(ci_thesis_gitlink_wache PRIVATE cxx_std_23)
target_link_libraries(ci_thesis_gitlink_wache PRIVATE comdare::ci_wachen)
set_target_properties(ci_thesis_gitlink_wache PROPERTIES OUTPUT_NAME "ci-thesis-gitlink-wache")

install(TARGETS ci_xml_wellformed_wache ci_thesis_gitlink_wache
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

# -- Die Werkbank der Tests -----------------------------------------------------------
# Sie linkt gtest (AssertionResult ist ihr Rueckgabetyp, damit ein misslungenes
# Arrangement als ROTER Test mit Fixture-Diagnose endet und nicht als "gefangen").
# Deshalb liegt sie INNERHALB des Test-Gates und nicht in der Produktions-Bibliothek.
if(COMDARE_DA_BUILD_TESTS)
    add_library(comdare_ci_wachen_werkbank STATIC testwerkbank/werkbank.cpp)
    target_compile_features(comdare_ci_wachen_werkbank PUBLIC cxx_std_23)
    target_include_directories(comdare_ci_wachen_werkbank PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/testwerkbank)
    target_link_libraries(comdare_ci_wachen_werkbank PUBLIC comdare::ci_wachen gtest)
    add_library(comdare::ci_wachen_werkbank ALIAS comdare_ci_wachen_werkbank)
endif()
