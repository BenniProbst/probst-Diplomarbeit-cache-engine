# tests/ — Diplomarbeit/Code Tests
# Konsumiert die 5 Pipeline-Module + GoogleTest (von top-level FetchContent).

include(GoogleTest)

function(comdare_da_add_test name)
    cmake_parse_arguments(ARG "" "" "SOURCES;LIBRARIES;LABELS" ${ARGN})
    add_executable(${name} ${ARG_SOURCES})
    # CI-Registry (User 06.07.: Tests nie manual/auslassen): Root sammelt zu comdare_da_unit_tests.
    set_property(GLOBAL APPEND PROPERTY COMDARE_DA_TEST_TARGETS ${name})
    target_link_libraries(${name} PRIVATE
        gtest gtest_main
        ${ARG_LIBRARIES})
    target_compile_features(${name} PRIVATE cxx_std_23)
    # D3-4 (2026-08-09): optionales ZUSATZ-Label. da_unit bleibt IMMER gesetzt -- die
    # Test-Auswahl der CI (ctest -L da_unit, Makefile:137) darf sich durch ein zweites
    # Label nicht verschieben. Ohne LABELS-Argument ist das Verhalten byte-identisch zu
    # vorher; die 11 bestehenden Aufrufe bleiben unberuehrt.
    # Das Semikolon wird MASKIERT weitergereicht. Am Objekt gemessen (09.08., CMake
    # 4.3.4): gtest_discover_tests schreibt PROPERTIES woertlich in sein generiertes
    # set_tests_properties. Eine unmaskierte Liste landet dort als
    # `LABELS da_unit ci_wachen` -- CMake liest dann NUR da_unit als Label und deutet
    # ci_wachen als naechsten Property-NAMEN. Ergebnis war `ctest -N -L ci_wachen` ->
    # "Total Tests: 0", also ein still verlorenes Label. Mit `\;` steht dort
    # `LABELS da_unit\;ci_wachen` und CMake liest EIN Argument mit ZWEI Labels.
    set(_comdare_labels "da_unit")
    foreach(_comdare_label IN LISTS ARG_LABELS)
        set(_comdare_labels "${_comdare_labels}\\;${_comdare_label}")
    endforeach()
    # TIMEOUT bleibt bei 60 wie bisher: die neuen Wachen-Faelle brauchen es nicht.
    # Gemessen (09.08., alle 103 Faelle): 0,25 s GESAMT, kein Einzelfall ueber 0,01 s --
    # auch die, die ein Wegwerf-Repo bauen und rund zwanzig git-Kindprozesse fahren.
    # Eine Anhebung haette 11 bestehende Ziele stillschweigend mit verschoben.
    gtest_discover_tests(${name}
        DISCOVERY_TIMEOUT 30
        PROPERTIES TIMEOUT 60 LABELS "${_comdare_labels}")
endfunction()

comdare_da_add_test(test_binary_to_csv
    SOURCES unit/test_binary_to_csv.cpp
    LIBRARIES comdare::binary_to_csv)

comdare_da_add_test(test_csv_to_latex
    SOURCES unit/test_csv_to_latex.cpp
    LIBRARIES comdare::csv_to_latex)

comdare_da_add_test(test_diagram_generator
    SOURCES unit/test_diagram_generator.cpp
    LIBRARIES comdare::diagram_generator)

# V41.P1 (2026-05-31) — Cross-Stage-Test: 16-Spalten-Schema-Kohärenz Stufe 03 → 04 → 05
# (deckt den vom E2E-Abnahme-Audit gefundenen CSV-Schema-Bruch ab, der vorher in keinem Test sichtbar war).
comdare_da_add_test(test_pipeline_cross_stage
    SOURCES unit/test_pipeline_cross_stage.cpp
    LIBRARIES comdare::binary_to_csv comdare::csv_to_latex comdare::diagram_generator)

comdare_da_add_test(test_messung_driver
    SOURCES unit/test_messung_driver.cpp
    LIBRARIES
        comdare_builder_experiment_driver
        comdare::workload_generator
        comdare::experiment)
target_include_directories(test_messung_driver PRIVATE
    ${COMDARE_CACHE_ENGINE_DIR}/cache_engine/include)

# V41.G.1 (2026-05-31) - Hierarchischer Achsen-Baum (axis_tree.hpp, pure std → immer gebaut)
comdare_da_add_test(test_axis_tree
    SOURCES unit/test_axis_tree.cpp)
target_include_directories(test_axis_tree PRIVATE
    ${CMAKE_SOURCE_DIR}/02_messung_driver)

# V41.P5 (G10, 2026-05-31) - op_type_filter: wirksame OP-1..OP-6 → WorkloadKind
# (header-only: braucht nur cache-engine workload.hpp + 02_messung_driver → immer gebaut,
#  unabhaengig vom COMDARE_V32_ENABLE-Gate, das die schweren Orchestrator-Tests bedingt).
comdare_da_add_test(test_op_type_filter
    SOURCES unit/test_op_type_filter.cpp)
target_include_directories(test_op_type_filter PRIVATE
    ${CMAKE_SOURCE_DIR}/02_messung_driver
    ${COMDARE_CACHE_ENGINE_DIR}/libs)

# #279-a (2026-07-07) - Tier-Binary-Build-Sichtbarkeit + Interface-Roster
# (reine std-Logik: parse_plan_dump/scan_built/compute_visibility/format_* ->
#  immer gebaut, unabhaengig vom V32-Gate). Fixtures via Source-Dir-Fallback.
comdare_da_add_test(test_279_tier_binary_report
    SOURCES unit/test_279_tier_binary_report.cpp
    LIBRARIES comdare::tier_binary_report)
# Die plan-dump-Fixtures (.txt, 2c/OP-8) liegen committet im Source-Baum. Die "gebauten"
# Tier-Binary-Dateien (.so) sind Build-Artefakte (.gitignore ignoriert *.so bewusst) -> sie
# werden bei configure synthetisch im Build-Baum erzeugt statt committet.
# Die beiden .so-Stems sind die REAL sanitisierten binary_ids der Experiment-Fixture
# (ce orch_sanitize: Nicht-alnum -> '_'); nur so prueft der Test die echte Id-Raum-Bruecke
# zwischen geplanter (plan dump) und gebauter (Dateiscan) Menge statt eines Kunstnamens.
set(_fix279_src  "${CMAKE_CURRENT_SOURCE_DIR}/fixtures/tier_binary_report")
set(_fix279_perm "${CMAKE_CURRENT_BINARY_DIR}/fixtures_279_perm")
# Erst leeren, dann schreiben: die synthetisierte Menge ist die AUTORITATIVE Erwartung des
# Tests. Ohne das bleiben .so-Stems frueherer Configure-Laeufe im Build-Baum liegen und der
# Dateiscan zaehlt sie mit (real aufgetreten bei der 2c-Umbenennung in einem Bestandsbaum).
file(REMOVE_RECURSE "${_fix279_perm}")
file(MAKE_DIRECTORY "${_fix279_perm}/cache_engine" "${_fix279_perm}/prt_art")
file(WRITE "${_fix279_perm}/cache_engine/perm_sota_tier_sota__A__PrtArtComposition.so"
    "fixture perm lib (nur Dateiscan)\n")
file(WRITE "${_fix279_perm}/cache_engine/perm_sota_tier_sota__A__ArtComposition.so"
    "fixture perm lib (nur Dateiscan)\n")
file(WRITE "${_fix279_perm}/cache_engine/notperm.so" "decoy ohne perm_-Praefix (muss ignoriert werden)\n")
# Fremde, aber EXISTIERENDE Datei fuer die Formatwache: ohne Kopf-Anker darf sie nicht als
# leerer, gueltiger Plan durchgehen. Liegt bewusst neben (nicht in) den Subsystem-Ordnern.
file(WRITE "${_fix279_perm}/not_a_plan_dump.txt" "kein Kopf-Anker - dies ist keine plan-dump-Ausgabe\n")
target_compile_definitions(test_279_tier_binary_report PRIVATE
    "COMDARE_FIXTURE_DIR_279=\"${_fix279_src}\""
    "COMDARE_FIXTURE_PERM_DIR_279=\"${_fix279_perm}\"")

# ---------------------------------------------------------------------------
# D3-4/D3-5 (2026-08-09) -- DIE CI-WACHEN ALS GOOGLE TESTS (Owner-KERN: "SKRIPTE SAGEN
# GAR NICHTS"). Sie loesen ci/tests/xml_wellformed_probe.sh (732 Z.) und
# ci/tests/thesis_gitlink_parity_probe.sh (698 Z.) ab; beide Dateien bleiben im Baum
# und tragen einen Verweis hierher (Bestand wird nie geloescht, nur abgeloest).
#
# REGISTRIERUNG UEBER DIE BESTEHENDE HAUSFORM comdare_da_add_test: gtest_discover_tests,
# Label da_unit, Sammel-Target comdare_da_unit_tests, gtest 1.15.2 aus dem vendored
# Tarball. KEIN neuer Mechanismus -- und damit laufen sie in test:unit (ctest -L da_unit)
# und, neu, in test:unit:debug, also in BEIDEN Optimierungsstufen (Owner-KERN
# "AUFGRUND VON COMPILE REGRESSIONEN"; die Klasse ist gemessen: test_ms1 war lokal unter
# -O0 gruen und fiel in Pipeline 15437 unter -O3).
#
# Das Zusatz-Label ci_wachen erlaubt einen gezielten Lauf: ctest -L ci_wachen.
# Die E2E-Faelle spawnen die ECHTEN Binaries; $<TARGET_FILE:...> wird als Define
# durchgereicht und die Abhaengigkeit gesetzt, damit sie vor dem Test gebaut sind.
# ---------------------------------------------------------------------------
comdare_da_add_test(test_ci_wache_xml_wellformed
    SOURCES unit/test_ci_wache_xml_wellformed.cpp
    LIBRARIES comdare::ci_wachen comdare::ci_wachen_werkbank gmock
    LABELS ci_wachen)
target_compile_definitions(test_ci_wache_xml_wellformed PRIVATE
    "COMDARE_CI_WACHE_XML_BINARY=\"$<TARGET_FILE:ci_xml_wellformed_wache>\"")
add_dependencies(test_ci_wache_xml_wellformed ci_xml_wellformed_wache)

comdare_da_add_test(test_ci_wache_gitlink_parity
    SOURCES unit/test_ci_wache_gitlink_parity.cpp
    LIBRARIES comdare::ci_wachen comdare::ci_wachen_werkbank gmock
    LABELS ci_wachen)
target_compile_definitions(test_ci_wache_gitlink_parity PRIVATE
    "COMDARE_CI_WACHE_PARITY_BINARY=\"$<TARGET_FILE:ci_thesis_gitlink_wache>\"")
add_dependencies(test_ci_wache_gitlink_parity ci_thesis_gitlink_wache)

# P29 (2026-08-10) -- DIE WIDE-KONKATENATION. Sie prueft ZWEI Gegenstaende in einem Ziel:
# die C++-Fassung (Stufe 1 des Owner-KERN-Umbaus) UND, ueber die Prozess-Naht, die heute
# in der CI laufende Produktions-Shell ci/wide_aggregat.sh. Der Pfad kommt als Define,
# nicht aus dem Arbeitsverzeichnis -- dieselbe Haertung wie bei test_279 und
# test_ci_wache_registrierung (eine CWD-Annahme ist keine Zusicherung).
comdare_da_add_test(test_ci_wache_wide_aggregat
    SOURCES unit/test_ci_wache_wide_aggregat.cpp
    LIBRARIES comdare::ci_wachen comdare::ci_wachen_werkbank gmock
    LABELS ci_wachen)
target_compile_definitions(test_ci_wache_wide_aggregat PRIVATE
    "COMDARE_WIDE_AGGREGAT_SH=\"${CMAKE_SOURCE_DIR}/../ci/wide_aggregat.sh\""
    "COMDARE_REPO_WURZEL_W29=\"${CMAKE_SOURCE_DIR}/..\""
    "COMDARE_CI_WIDE_AGGREGAT_BINARY=\"$<TARGET_FILE:ci_wide_aggregat>\"")
add_dependencies(test_ci_wache_wide_aggregat ci_wide_aggregat)

# T-7: die Abnahme der .gitlab-ci.yml. CMAKE_SOURCE_DIR ist Code/ (configure.sh setzt
# cmake_unterverzeichnis="Code"), die Datei liegt also eine Ebene darueber. Dasselbe
# Fixture-Muster wie bei test_279_tier_binary_report (Define statt CWD-Annahme).
comdare_da_add_test(test_ci_wache_registrierung
    SOURCES unit/test_ci_wache_registrierung.cpp
    LIBRARIES comdare::ci_wachen gmock
    LABELS ci_wachen)
target_compile_definitions(test_ci_wache_registrierung PRIVATE
    "COMDARE_CI_YML_PFAD=\"${CMAKE_SOURCE_DIR}/../.gitlab-ci.yml\""
    "COMDARE_REPO_WURZEL=\"${CMAKE_SOURCE_DIR}/..\"")

# CI-INV (2026-08-10) -- DIE ZWEI ABSCHALT-KLASSEN. Owner 10.08.: "Gebaut wird immer,
# skip ist VERBOTEN." Ein Job kann aber auch aufhoeren zu existieren, ohne dass jemand
# ihn abschaltet: ein doppelter Top-Level-Schluessel loescht den ersten wortlos, und ein
# rules-Gate auf eine nirgends gesetzte Variable ist von einem toten Job nicht zu
# unterscheiden. Beides ist im Haus belegt (contract:axis-version-lock, drei Wochen in
# keinem Lauf bei gruener Pipeline) und war bis heute durch nichts gedeckt.
#
# Der Pfad kommt als Define, NICHT aus dem Arbeitsverzeichnis -- dieselbe Haertung wie
# bei test_ci_wache_registrierung (eine CWD-Annahme ist keine Zusicherung).
comdare_da_add_test(test_ci_wache_invarianten
    SOURCES unit/test_ci_wache_invarianten.cpp
    LIBRARIES comdare::ci_wachen comdare::ci_wachen_werkbank gmock
    LABELS ci_wachen)
target_compile_definitions(test_ci_wache_invarianten PRIVATE
    "COMDARE_CI_YML_PFAD=\"${CMAKE_SOURCE_DIR}/../.gitlab-ci.yml\""
    "COMDARE_REPO_WURZEL=\"${CMAKE_SOURCE_DIR}/..\"")

# MUT (2026-08-10) -- DER MUTATIONS-HARNESS UNTER TEST. Begruendung im Kopf von
# Code/ci_wachen/include/comdare/ci_wachen/mutations_lauf.hpp.
#
# WARUM DER TEST DEN ECHTEN BAUM BRAUCHT (COMDARE_REPO_WURZEL_MUT): der Katalog des
# Harness traegt Quelltext-ANKER aus vier Produktionsdateien. Steht ein Anker dort nicht
# mehr GENAU so oft, liefe der Mutant ins Leere -- und der Harness meldete "alle Mutanten
# getoetet", ohne je eine Datei veraendert zu haben. Genau diese stille Null faengt der
# Fall MutationsKatalog.JederAnkerStehtGENAUSooftInDerECHTENProduktionsdatei ab. Der Pfad
# kommt als Define, NICHT aus dem Arbeitsverzeichnis (dieselbe Haertung wie test_279).
#
# Der Test startet KEIN cmake und KEIN ctest: die Bau-/Suite-/git-Naht wird durch eine
# Fake-Naht ersetzt (Muster FakeGitQuelle/FakeXmlParser). Der Beleg, dass die ECHTE Naht
# baut und faehrt, ist der protokollierte Lauf des Binaries ci-mutations-lauf.
comdare_da_add_test(test_ci_wache_mutations_lauf
    SOURCES unit/test_ci_wache_mutations_lauf.cpp
    LIBRARIES comdare::ci_wachen comdare::ci_wachen_werkbank gmock
    LABELS ci_wachen)
add_dependencies(test_ci_wache_mutations_lauf ci_mutations_lauf)

# -- DAS ZWEITE ZIEL: die Katalog-Faelle, ABGEWAEHLT vom Mess-Lauf --------------------
# Sie lesen die Produktionsdateien von der Platte und sind deshalb unter JEDEM Mutanten
# rot -- unabhaengig davon, ob die Suite den Fehler wirklich faengt. Am Objekt gemessen
# (erster Harness-Lauf 10.08.): sie toeteten alle fuenf Mutanten, waehrend die
# vorhergesagten Deckungstests bei M4 und M5 gruen blieben. Die Rate "0 von 5" war eine
# Konstante des Aufbaus, keine Messung.
#
# Das ZUSATZ-LABEL mut_selbstbezug ist der Mechanismus: der Harness faehrt die Suite mit
# `-LE mut_selbstbezug`. Es steht hier -- die Zeichenkette selbst kommt aus
# comdare::ci_wachen::SELBSTBEZUG_LABEL, und der Fall
# MutationsKatalog.DIE_ABWAHL_StehtPOSITIONSGEBUNDENInDerCMakeDatei haelt beide
# zusammen: er liest DIESE Datei und verlangt das Label GENAU in diesem Ziel-Block.
comdare_da_add_test(test_ci_wache_mutations_katalog
    SOURCES unit/test_ci_wache_mutations_katalog.cpp
    LIBRARIES comdare::ci_wachen gmock
    LABELS ci_wachen mut_selbstbezug)
target_compile_definitions(test_ci_wache_mutations_katalog PRIVATE
    "COMDARE_REPO_WURZEL_MUT=\"${CMAKE_SOURCE_DIR}/..\"")
# Owner-Auftrag 10.08.2026 ("mal schauen, ob nicht dort speicher eingespart sein kann"):
# das Bau-Parallelitaets-Budget. Dieselben zwei Defines wie oben -- die Wache liest die
# .gitlab-ci.yml BEIDER Repositories (super direkt, ce ueber die Repo-Wurzel), weil beide
# Pipelines sich denselben Runner und damit denselben Arbeitsspeicher teilen.
comdare_da_add_test(test_ci_wache_speicherbudget
    SOURCES unit/test_ci_wache_speicherbudget.cpp
    LIBRARIES comdare::ci_wachen gmock
    LABELS ci_wachen)
target_compile_definitions(test_ci_wache_speicherbudget PRIVATE
    "COMDARE_CI_YML_PFAD=\"${CMAKE_SOURCE_DIR}/../.gitlab-ci.yml\""
    "COMDARE_REPO_WURZEL=\"${CMAKE_SOURCE_DIR}/..\"")

# P3 (2026-08-10) -- DIE BASIS DER DIFF-HYGIENE-WACHE. Bis heute stand sie als
# "origin/$CI_DEFAULT_BRANCH" in der .gitlab-ci.yml, also in einer GitLab-Web-Einstellung
# statt im versionierten Text. Gemessen: mit dem daraus folgenden 'development' war die
# Wache auf jeder development-Pipeline ein NO-OP (0 Commit(s) im Bereich, 0 Zeilen
# geprueft, GRUEN); mit origin/main sind es am selben Stand 52 Commit(s) und 7007 Zeilen
# im Scope. Nur COMDARE_CI_YML_PFAD noetig -- die Wache liest ausschliesslich den super.
comdare_da_add_test(test_ci_wache_guard_basis
    SOURCES unit/test_ci_wache_guard_basis.cpp
    LIBRARIES comdare::ci_wachen gmock
    LABELS ci_wachen)
target_compile_definitions(test_ci_wache_guard_basis PRIVATE
    "COMDARE_CI_YML_PFAD=\"${CMAKE_SOURCE_DIR}/../.gitlab-ci.yml\"")

# P-LIZENZ (2026-08-11) -- SAGEN NOTICE, LICENSE UND DER ARBEITSBAUM DASSELBE?
# Bis heute gab es an der Wurzel KEINE NOTICE -- in keinem Commit irgendeines
# Branches (git log --all -- NOTICE leer; Gegenprobe -- LICENSE = 1 Commit).
# Dabei zieht das Repo 4 Submodul-Einbindungen und 1544 getrackte Dateien
# vendorten Forschungscode ein, darunter GPL-3.0 und LGPL-2.1-or-later.
# Die Wache paart .gitmodules gegen NOTICE in BEIDEN Richtungen, misst jeden
# behaupteten Lizenz-Marker am Text der genannten Lizenzdatei und haelt die
# SPDX-Koepfe unter Code/ (ohne Code/external/) auf Apache-2.0.
# COMDARE_REPO_WURZEL_LIZENZ: derselbe Define-statt-CWD-Griff wie bei test_279
# und test_ci_wache_registrierung -- eine CWD-Annahme ist keine Zusicherung.
comdare_da_add_test(test_ci_wache_lizenz_konsistenz
    SOURCES unit/test_ci_wache_lizenz_konsistenz.cpp
    LIBRARIES comdare::ci_wachen gmock
    LABELS ci_wachen)
target_compile_definitions(test_ci_wache_lizenz_konsistenz PRIVATE
    "COMDARE_REPO_WURZEL_LIZENZ=\"${CMAKE_SOURCE_DIR}/..\"")

# V32.II.3 (2026-05-21) + V33.C.2 (2026-05-21) - V32Orchestrator Tests
# V33.C.2: Include-Pfade fuer cache-engine V32 commands + prt-art default_lookup
if(COMDARE_V32_ENABLE)
    comdare_da_add_test(test_v32_orchestrator
        SOURCES unit/test_v32_orchestrator.cpp)
    target_include_directories(test_v32_orchestrator PRIVATE
        ${CMAKE_SOURCE_DIR}/02_messung_driver
        ${COMDARE_CACHE_ENGINE_DIR}/libs
        ${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine/include
        ${COMDARE_PRT_ART_DIR}/prt_art/include)
    # #265-b: die AP-3-Bruecke (via auto_permutator) konsumiert die vendored foundation-Zelle
    # comdare::platform — MATRIX-WEIT-Regel: super-Konsumenten der ce-Header linken das Target mit.
    target_link_libraries(test_v32_orchestrator PRIVATE comdare::platform)

    # V33.D.3 (2026-05-21) - MessreiheV32Validator-Tests
    comdare_da_add_test(test_messreihe_v32_validator
        SOURCES unit/test_messreihe_v32_validator.cpp)
    # CWD-Stray-Haertung (Fix 2026-07-06, Muster COMDARE_FIXTURES_DIR_03_FALLBACK): Source-Dir-Fallback
    # fuer das gelieferte Beispiel-XML — der fruehere GTEST_SKIP maskierte den Test in CI/ctest komplett.
    target_compile_definitions(test_messreihe_v32_validator PRIVATE
        "COMDARE_TEST_DATA_XML_DIR_FALLBACK=\"${CMAKE_CURRENT_SOURCE_DIR}/../test_data_xml\"")
    target_include_directories(test_messreihe_v32_validator PRIVATE
        ${CMAKE_SOURCE_DIR}/02_messung_driver)

    # V33.E.4 (2026-05-21) - HardwareFilter Tests (Q.1)
    comdare_da_add_test(test_dataset_filter
        SOURCES unit/test_dataset_filter.cpp)
    target_include_directories(test_dataset_filter PRIVATE
        ${CMAKE_SOURCE_DIR}/02_messung_driver)

    # V34.B.2 (2026-05-21) - MessreiheReportExporter Tests
    comdare_da_add_test(test_messreihe_report_exporter
        SOURCES unit/test_messreihe_report_exporter.cpp)
    target_include_directories(test_messreihe_report_exporter PRIVATE
        ${CMAKE_SOURCE_DIR}/02_messung_driver
        ${COMDARE_CACHE_ENGINE_DIR}/libs
        ${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine/include
        ${COMDARE_PRT_ART_DIR}/prt_art/include)
    # #265-b: s.o. — messreihe_report_exporter.hpp zieht v32_orchestrator -> Bruecke -> comdare::platform.
    target_link_libraries(test_messreihe_report_exporter PRIVATE comdare::platform)
endif()

# ─────────────────────────────────────────────────────────────────────────────
# WP-4/F33+F66 (Voll-Audit 2026-07-16) — Fixture-Sync-Gates (Script-Tests, KEIN gtest/Build):
# die ce-Fixture-KOPIEN tests/unit/thesis_tiere/{experiment_golden.xml, prt_art_axis_registry.xml}
# muessen byte-identisch zu ihren Mastern bleiben (super Code/test_data_xml/experiment_golden.xml
# bzw. prt-art prt_art/algorithm_profiles/prt_art_axis_registry.xml) — sonst testet ce still gegen
# einen stalen Stand. Das super-Repo konsumiert BEIDE Submodule -> layering-sauberer Pruef-Ort.
# Der markierte FIXTURE-PROVENIENZ-Kommentar-Block der Kopien wird vor dem Vergleich ausgeblendet
# (fixture_sync_check.cmake). Fehlt ein Nachbar-Checkout, SKIP sauber (SKIP_REGULAR_EXPRESSION).
# UEBERGANG bis E7-Single-Source (Bruecke I7) — danach durch die Single-Source-Struktur abloesbar.
# Label da_unit: laeuft im test:unit-Gate (ctest -L da_unit); braucht kein Build-Target.
# STAND-NACHZUG 2026-08-06 (B14/Scheibe 6): die KANONISCHE golden ist seit dem 27.07. NICHT mehr
# experiment_golden.xml, sondern experiment_golden_kern.xml. Deren Wache steht weiter unten
# (fixture_schema_subset_check.cmake); dieser Block hier bewacht das WEITER PRODUKTIVE Alt-Paar.
# ─────────────────────────────────────────────────────────────────────────────
add_test(NAME test_fixture_sync_experiment_golden
    COMMAND "${CMAKE_COMMAND}"
        "-DMASTER=${CMAKE_SOURCE_DIR}/test_data_xml/experiment_golden.xml"
        "-DKOPIE=${COMDARE_CACHE_ENGINE_DIR}/tests/unit/thesis_tiere/experiment_golden.xml"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/fixture_sync_check.cmake")
add_test(NAME test_fixture_sync_prt_registry
    COMMAND "${CMAKE_COMMAND}"
        "-DMASTER=${COMDARE_PRT_ART_DIR}/prt_art/algorithm_profiles/prt_art_axis_registry.xml"
        "-DKOPIE=${COMDARE_CACHE_ENGINE_DIR}/tests/unit/thesis_tiere/prt_art_axis_registry.xml"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/fixture_sync_check.cmake")

# #48-SCHEIBE-6 (B14, 2026-08-06) -- die Wache des NEU-PAARES experiment_golden_kern.xml.
# Die zwei add_test oben bleiben UNVERAENDERT: das Alt-Paar experiment_golden.xml ist zwar seit dem
# 27.07. inhaltlich deprecated, treibt aber weiterhin real den Antriebs-Test (02_messung_driver/
# CMakeLists.txt setzt COMDARE_V32_EXPERIMENT_GOLDEN_XML darauf). Seine Wache abzuschalten waere ein
# Wach-Verlust ohne Gegenwert -- Scheibe 6 ist deshalb ein HINZUFUEGEN, kein Umbiegen.
# Das Neu-Paar ist KEIN Byte-Paar (die ce-Datei ist eine eigenstaendige Naht-Fixture mit absichtlich
# abweichenden Werten, literal verdrahtet in test_experiment_kern_seam.cpp) -- die Begruendung steht im
# Kopf von fixture_schema_subset_check.cmake. Die ce-Umbenennungs-Auflage ist VOLLZOGEN (Weg a,
# 17.08.2026, ce 44a909c1/7a5ed464: eindeutiger Name experiment_kern_seam_fixture.xml).
# Geprueft wird deshalb das gemeinsame VOKABULAR gegen die EINE Single-Source experiment_schema.xsd:
# beide Seiten duerfen nur Element-/Attribut-Namen benutzen, die das Ziel-Schema deklariert.
add_test(NAME test_fixture_schema_experiment_golden_kern
    COMMAND "${CMAKE_COMMAND}"
        "-DSCHEMA=${CMAKE_SOURCE_DIR}/test_data_xml/experiment_schema.xsd"
        "-DMASTER=${CMAKE_SOURCE_DIR}/test_data_xml/experiment_golden_kern.xml"
        "-DFIXTURE=${COMDARE_CACHE_ENGINE_DIR}/tests/unit/thesis_tiere/experiment_kern_seam_fixture.xml"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/fixture_schema_subset_check.cmake")
# Zweites Bein derselben Wache auf dem ALT-Paar: es kostet nichts und haelt die v1-Instanz + ihre
# ce-Kopie ebenfalls am EINEN Schema-Vokabular (das Byte-Gate oben sagt nur "gleich", nicht "gueltig").
add_test(NAME test_fixture_schema_experiment_golden
    COMMAND "${CMAKE_COMMAND}"
        "-DSCHEMA=${CMAKE_SOURCE_DIR}/test_data_xml/experiment_schema.xsd"
        "-DMASTER=${CMAKE_SOURCE_DIR}/test_data_xml/experiment_golden.xml"
        "-DFIXTURE=${COMDARE_CACHE_ENGINE_DIR}/tests/unit/thesis_tiere/experiment_golden.xml"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/fixture_schema_subset_check.cmake")
# B14-NB2 (2026-08-06) -- die Wache der KETTE der zwei golden-Traeger.
# Die zwei Wachen oben pruefen je EINE Datei gegen EIN Schema (Byte bzw. Vokabular). Keine von ihnen
# haette gemerkt, dass die kanonische experiment_golden_kern.xml das Owner-N (2^17 = 131072) ueberhaupt
# nicht maschinenlesbar trug und rechnerisch einen voellig anderen Raum deklarierte als ihr ce-Schwester-
# Traeger all_axes_golden.profile.xml (Codex-Befund HOCH). Diese Wache vergleicht die beiden Traeger
# SEMANTISCH ueber die Dialekt-Grenze hinweg: gleiche Achsen-Menge, je Achse gleiche Auspraegungen,
# gleiches Produkt, und dieses Produkt == run_options cap BEIDER Seiten.
# all_axes_golden.profile.xml wird ausschliesslich GELESEN (sie bleibt unangetastet, s. ihr Kopf-Block).
# B14-NB3 (2026-08-06) -- DIE AUSNAHME IST GEZOGEN (2026-08-08). Historie, damit nachvollziehbar
# bleibt, warum hier einmal eine Freischaltung stand:
# all_axes_golden.profile.xml war kein wohlgeformtes XML -- in drei Kommentaren stand ein '--', was
# XML ausnahmslos verbietet (libxml2 lehnte die Datei komplett ab; Fundstellen damals: 62/64/207).
# Der Defekt lag AUSSCHLIESSLICH im Kommentar-TEXT; kommentarfrei parste die Datei einwandfrei. Weil
# die Datei dem ce-Submodul gehoert und in jenem Fenster unter der Ein-Schreiber-Regel stand, wurde
# sie hier nicht repariert, sondern die Wache durfte sie kommentarfrei lesen -- unter der ausdruecklichen
# Auflage, die Freischaltung nach der ce-seitigen Heilung wieder zu entfernen.
# DIE AUFLAGE IST ERFUELLT: ce hat die drei '--' beseitigt und dabei zwei Befunde mehr gefunden, als
# der Auftrag vorsah -- die Datei war nicht die einzige (fuenf XML in zwei Repos), und zwei der fuenf
# werden MASCHINELL erzeugt, die Generatoren schrieben den Defekt also mit (h2_score_akte.hpp:129,
# tools/system_axis_registry_gen/main.cpp:654). Eine reine Handkorrektur waere beim naechsten
# Regenerieren zurueckgefallen. Seither wacht in beiden Repos scripts/ci_xml_wellformed_guard.sh
# ueber JEDE getrackte *.xml (Job lint:xml-wellformed; Nenner ce 160/0, super 66/0).
# Die Freischaltung war in beide Richtungen verriegelt und haette sich selbst zurueckgezogen: sie
# wird FATAL, sobald die ce-Datei roh wohlgeformt ist. Genau das ist mit diesem Gitlink der Fall --
# deshalb faellt die Zeile im SELBEN Commit, in dem der Gitlink gehoben wird, und keinen frueher.
# SCRATCH_DIR: Ablage der kommentarfreien Arbeitskopie -- Build-Verzeichnis, nie der Quellbaum.
# >120-Spalten-Wache (scripts/ci_diff_ascii_width_guard.sh): der PROFILE-Pfad unten wuerde als eine
# einzelne "-DPROFILE=..."-Zeile 128 Byte tragen. In eine Zwischenvariable gezogen, damit CMakes
# eigene Zeilenumbruch-Regeln (Backslash-Fortsetzung wuerde fuehrende Leerzeichen der Folgezeile IN
# den Wert einbacken, empirisch geprueft) nicht angetastet werden muessen -- der resultierende
# Kommandozeilen-Wert ist byte-identisch zur vorherigen einzeiligen Fassung.
set(_golden_profile_path
    "${COMDARE_CACHE_ENGINE_DIR}/libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml")
add_test(NAME test_golden_n_consistency
    COMMAND "${CMAKE_COMMAND}"
        "-DMASTER=${CMAKE_SOURCE_DIR}/test_data_xml/experiment_golden_kern.xml"
        "-DPROFILE=${_golden_profile_path}"
        "-DSCRATCH_DIR=${CMAKE_CURRENT_BINARY_DIR}"
        # B14-NB4 / Befund B7: der ABSOLUTE golden-Kanon. Die Wache prueft bis dahin nur RELATIV
        # (Produkt == cap == cap) und BEHAUPTETE in der Erfolgsmeldung trotzdem "golden N = 2^17".
        # Driften beide Traeger GEMEINSAM (dieselbe Achse in beiden herausgenommen), bleiben alle
        # relativen Pruefungen gruen und die Meldung wird zur Unwahrheit. Der Kanon steht deshalb
        # HIER -- das super-Repo ist sein Eigentuemer, das Skript nur sein Pruefer. 2^17 = 131072.
        # Wer N bewusst aendert, aendert diese Zeile: ein sichtbarer Edit statt eines stillen Drifts.
        "-DEXPECTED_N=131072"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/golden_n_consistency_check.cmake")
# B14-NB4 / Befund B4: DER SKIP-MARKER IST VERANKERT.
# Vorher: SKIP_REGULAR_EXPRESSION "FIXTURE-SYNC-SKIP" -- ein UNVERANKERTES Teilwort, geprueft gegen die
# GESAMTE Testausgabe, und das fuer alle fuenf Tests. Jeder Nonzero-/FATAL-Ausgang, dessen Text die
# Zeichenfolge irgendwo mitfuehrt, waere damit als SKIP statt als FAIL klassifiziert worden -- und die
# Wachen echoen Dateiinhalte und xmllint-Ausgaben in ihre FATAL-Meldungen. Ein struktureller
# Fehlklassifikations-Pfad quer durch alle fuenf Tests.
# JETZT: die Skripte drucken den Marker als EIGENE, interpolationsfreie Zeile, und der Ausdruck bindet
# ihn an Zeilenanfang UND Zeilenende samt CMake-STATUS-Praefix. Ein Vorkommen mitten in einer Zeile --
# der einzige Weg, auf dem fremder Text ihn einschleusen kann -- matcht nicht mehr.
# Die Property bleibt auf allen fuenf Tests: bei jedem von ihnen ist der Skip legitim moeglich (alle
# fuenf haengen an einem Nachbar-Checkout, COMDARE_CACHE_ENGINE_DIR bzw. COMDARE_PRT_ART_DIR).
set_tests_properties(test_fixture_sync_experiment_golden test_fixture_sync_prt_registry
                     test_fixture_schema_experiment_golden_kern test_fixture_schema_experiment_golden
                     test_golden_n_consistency
    PROPERTIES LABELS "da_unit;fixture_sync" TIMEOUT 60
    SKIP_REGULAR_EXPRESSION "(^|\n)-- COMDARE-XML-WACHE-SKIP\r?(\n|$)")
