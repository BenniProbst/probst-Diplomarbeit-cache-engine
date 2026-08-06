# tests/ — Diplomarbeit/Code Tests
# Konsumiert die 5 Pipeline-Module + GoogleTest (von top-level FetchContent).

include(GoogleTest)

function(comdare_da_add_test name)
    cmake_parse_arguments(ARG "" "" "SOURCES;LIBRARIES" ${ARGN})
    add_executable(${name} ${ARG_SOURCES})
    # CI-Registry (User 06.07.: Tests nie manual/auslassen): Root sammelt zu comdare_da_unit_tests.
    set_property(GLOBAL APPEND PROPERTY COMDARE_DA_TEST_TARGETS ${name})
    target_link_libraries(${name} PRIVATE
        gtest gtest_main
        ${ARG_LIBRARIES})
    target_compile_features(${name} PRIVATE cxx_std_23)
    gtest_discover_tests(${name}
        DISCOVERY_TIMEOUT 30
        PROPERTIES TIMEOUT 60 LABELS da_unit)
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
# abweichenden Werten, literal verdrahtet in test_experiment_kern_seam.cpp) -- die Begruendung und die
# offene ce-Umbenennungs-Auflage stehen im Kopf von fixture_schema_subset_check.cmake.
# Geprueft wird deshalb das gemeinsame VOKABULAR gegen die EINE Single-Source experiment_schema.xsd:
# beide Seiten duerfen nur Element-/Attribut-Namen benutzen, die das Ziel-Schema deklariert.
add_test(NAME test_fixture_schema_experiment_golden_kern
    COMMAND "${CMAKE_COMMAND}"
        "-DSCHEMA=${CMAKE_SOURCE_DIR}/test_data_xml/experiment_schema.xsd"
        "-DMASTER=${CMAKE_SOURCE_DIR}/test_data_xml/experiment_golden_kern.xml"
        "-DFIXTURE=${COMDARE_CACHE_ENGINE_DIR}/tests/unit/thesis_tiere/experiment_golden_kern.xml"
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
# B14-NB3 (2026-08-06): PROFILE_ALLOW_COMMENT_TEXT_DEFECT -- die EINE, benannte Ausnahme.
# all_axes_golden.profile.xml ist derzeit kein wohlgeformtes XML: in drei Kommentaren steht ein '--',
# was XML verbietet (libxml2 lehnt die Datei komplett ab; Fundstellen bei Feststellung: Zeilen 62/64/207).
# Der Defekt liegt AUSSCHLIESSLICH im Kommentar-TEXT -- kommentarfrei parst die Datei einwandfrei. Die
# Datei gehoert dem ce-Submodul und steht in diesem Fenster unter der Ein-Schreiber-Regel, wird hier also
# NICHT repariert; die Wache darf sie stattdessen kommentarfrei lesen. Die Freischaltung ist in BEIDE
# Richtungen verriegelt: sie greift nur, wenn die Datei roh WIRKLICH scheitert und kommentarfrei WIRKLICH
# durchlaeuft -- und sie wird FATAL, sobald die ce-Datei roh wohlgeformt ist. Sie zieht sich damit selbst
# zurueck. ce-AUFLAGE: '--' in den drei Kommentaren beseitigen, danach diese Zeile ENTFERNEN.
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
        "-DPROFILE_ALLOW_COMMENT_TEXT_DEFECT=ON"
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
