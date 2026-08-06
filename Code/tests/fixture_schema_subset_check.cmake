# fixture_schema_subset_check.cmake -- #48-SCHEIBE-6 (B14, 2026-08-06): die Wache des NEU-PAARES
# {super Code/test_data_xml/experiment_golden_kern.xml, ce tests/unit/thesis_tiere/experiment_golden_kern.xml}.
#
# WARUM NICHT DAS BYTE-GATE (fixture_sync_check.cmake): das Neu-Paar ist KEIN Master/Kopie-Paar. Die
# ce-Datei gleichen Namens ist laut ihrem eigenen Kopf-Kommentar eine EIGENSTAENDIGE Parser-/Validator-
# Naht-Fixture ("KEIN Sync-Gate; rein test-lokal") mit ABSICHTLICH abweichenden Werten (merge="fulljoin",
# storage backend="minio", dritter mapping-Override, kleinere lebewesen-Menge). Diese Werte sind in
# tests/unit/thesis_tiere/test_experiment_kern_seam.cpp literal verdrahtet; ein Byte-Vergleich gegen den
# super-Master schoesse die dortigen Tests sofort rot. Ein Byte-Sync setzt daher zwingend eine ce-seitige
# Umbenennung der Fixture voraus (offene Auflage, s.u.) -- er ist NICHT durch Umbiegen einer CMake-Variablen
# zu haben.
#
# AUFLAGE, DIE HIER UMGESETZT WIRD: docs/plaene/20260722-AUDIT-nacht-abweichungen-VERDIKT.md Zeile 58
# (Befund C5) laesst fuer Scheibe 6 ausdruecklich ZWEI Wege zu -- "umbenennen (z.B.
# experiment_kern_seam_fixture.xml) ODER ctest-Wache 'Fixture ist Teilmenge von Master-Schema'". Der Rename ist ein
# ce-Commit und faellt unter die Ein-Schreiber-Regel (ce gehoert in diesem Fenster der Teil-2-Welle); der
# super-seitige Weg ist die Wache. Sie wird hier gebaut, die Umbenennung bleibt als dokumentierte
# ce-Auflage offen. Damit steht das F27/TABU-11-Muster (gleichnamig-divergent OHNE jede Wache) nicht mehr.
#
# MECHANIK (zwei Beine, beide FATAL):
#   (1) MASTER-Bein: die super-golden ist gueltig gegen experiment_schema.xsd.
#   (2) FIXTURE-Bein: dasselbe fuer die ce-Fixture. Faengt "die ce-Fixture uebt eine Naht, die es im
#       Ziel-Schema gar nicht gibt" (Phantom-Fixture) -- das ist die Teilmengen-Aussage.
# Beide Seiten werden gegen DIESELBE Single-Source geprueft (experiment_schema.xsd). Der Sinn ist nicht
# Byte-Gleichheit, sondern EIN Vokabular: eine Schema-Evolution im Master, der die Fixture nicht folgt,
# kann keine unbemerkte zweite Sprache entstehen lassen.
#
# WAS SICH GEGENUEBER DER NB2-FASSUNG GEAENDERT HAT (B14-NB3, Codex-Verdikt BLOCKER). Die NB2-Fassung
# baute die Aussage aus einem SELBSTGEBAUTEN Parser: CDATA-Stripper, Kommentar-Stripper, Tag-Scanner,
# Namens-Regex, Truncation-Heuristik -- alles in CMake-Text. Codex hat daran vier HOCH- und zwei
# MITTEL-Befunde gemeldet, alle sechs sind am Objekt reproduziert worden (Gate-Log nb3-biss-beweise.txt):
# ein '<![CDATA[' im Text eines gueltigen Kommentars, ein '<!--'/'-->' verteilt auf zwei Processing-
# Instructions, per Entity erzeugte Elemente, XML-Namen mit Nicht-ASCII-Startzeichen sowie
# Fehlverschachtelung mit dupliziertem Attribut liefen allesamt GRUEN durch; eine voellig gueltige XSD
# mit Praefix xsd:, Single-Quotes oder anderer Attributreihenfolge lief falsch-positiv ROT.
# DIE HEILUNG IST DER WEGFALL DES SELBSTBAU-PARSERS, nicht sein Flicken: gelesen wird nur noch ueber
# xmllint (s. xml_canonical_utils.cmake). Die Wache stellt keine Textfragen mehr.
#
# ZWEI FOLGEN, EHRLICH BENANNT:
#   * STAERKER ALS DIE AUFLAGE: geprueft wird nicht mehr "jeder benutzte NAME ist irgendwo in der XSD
#     deklariert", sondern "das Dokument ist gueltig gegen die XSD". Das schliesst den Kontext ein und
#     erledigt damit auch den Codex-MITTEL-Befund zum kontextlosen Mengenvergleich: ein Attribut, das
#     die XSD zwar irgendwo deklariert, aber an DIESEM Element nicht erlaubt, lief bisher gruen durch.
#     Die Teilmengen-Aussage aus Auflage C5 ist darin vollstaendig enthalten (wer gueltig ist, benutzt
#     kein undeklariertes Vokabular), zusaetzlich gelten jetzt Kardinalitaeten, Reihenfolge und Typen.
#     Die frueher separate Namens-Extraktion entfaellt ersatzlos -- sie waere reines totes Gewicht.
#   * NEUE PFLICHT-DEPENDENCY: xmllint. Die alte Werbung "dependency-freie ctest-Schicht, kein
#     xmllint-Zwang auf den Runnern" ist damit zurueckgenommen; genau diese Dependency-Freiheit haben
#     die sechs Befunde bezahlt. Fehlt xmllint, ist das FATAL und KEIN Skip (Begruendung und
#     Paketnamen in xml_canonical_utils.cmake).
#
# Erwartete -D Variablen: SCHEMA (die XSD), FIXTURE (die ce-Fixture), MASTER (optional, die super-golden).
#
# SKIP-DISZIPLIN (B14-NB2, Codex-MITTEL "fehlende SCHEMA-/MASTER-Datei = Skip statt Fail"): ein SKIP ist
# NUR fuer den EINEN Fall zulaessig, fuer den er gedacht war -- der ce-NACHBAR-CHECKOUT fehlt (Submodul
# nicht ausgecheckt). SCHEMA und MASTER liegen dagegen im super-Repo SELBST (Code/test_data_xml/); fehlen
# sie, ist das kein fehlender Nachbar, sondern ein kaputtes eigenes Repo bzw. eine falsch verdrahtete
# add_test-Zeile. Ein SKIP haette das stumm verdeckt und die Wache faktisch abgeschaltet -> beides ist
# jetzt FATAL. Nur FIXTURE skippt (Marker FIXTURE-SYNC-SKIP, identisch zu fixture_sync_check.cmake, damit
# dieselbe SKIP_REGULAR_EXPRESSION greift).

include("${CMAKE_CURRENT_LIST_DIR}/xml_canonical_utils.cmake")

set(_ctx "fixture_schema_subset_check")

foreach(_req SCHEMA FIXTURE)
    if(NOT DEFINED ${_req})
        message(FATAL_ERROR "${_ctx}: -D${_req} fehlt.")
    endif()
endforeach()

if(NOT EXISTS "${SCHEMA}")
    message(FATAL_ERROR
        "${_ctx}: SCHEMA '${SCHEMA}' EXISTIERT NICHT. Das ist KEIN fehlender "
        "Nachbar-Checkout (die XSD liegt im super-Repo selbst) -- entweder ist der Pfad in der "
        "add_test-Zeile falsch oder die Single-Source ist verschwunden. Kein SKIP.")
endif()
if(DEFINED MASTER AND NOT EXISTS "${MASTER}")
    message(FATAL_ERROR
        "${_ctx}: MASTER '${MASTER}' EXISTIERT NICHT. Auch der MASTER liegt im "
        "super-Repo selbst (Code/test_data_xml/) -- kein Nachbar-Checkout, also kein SKIP.")
endif()
if(NOT EXISTS "${FIXTURE}")
    message(STATUS "FIXTURE-SYNC-SKIP: Nachbar-Checkout fehlt (FIXTURE='${FIXTURE}').")
    return()
endif()

# -- Die XSD selbst muss lesbar, wohlgeformt und nicht leer sein.
comdare_xml_open("${_ctx}" "SCHEMA" "${SCHEMA}" FALSE _schema_doc)

# -- Deklariertes Vokabular zaehlen. Das ist KEINE Extraktion mehr, sondern nur noch ein Riegel gegen
#    die stumm-gruene Falle "die XSD deklariert gar nichts". Der Ausdruck fragt ueber local-name() und
#    namespace-uri() und ist damit unabhaengig von Praefix (xs:, xsd:, Default-Namensraum), von der
#    Quote-Form und von der Attributreihenfolge -- genau der Codex-MITTEL-Befund zur XSD-Extraktion.
set(_xsd_ns "http://www.w3.org/2001/XMLSchema")
comdare_xml_count("${_ctx}" "SCHEMA" "${_schema_doc}"
    "//*[local-name()='element' and namespace-uri()='${_xsd_ns}' and @name]" _n_se)
comdare_xml_count("${_ctx}" "SCHEMA" "${_schema_doc}"
    "//*[local-name()='attribute' and namespace-uri()='${_xsd_ns}' and @name]" _n_sa)
if(_n_se EQUAL 0 OR _n_sa EQUAL 0)
    message(FATAL_ERROR
        "${_ctx}: SCHEMA '${SCHEMA}' deklariert kein Vokabular (Elemente=${_n_se}, "
        "Attribute=${_n_sa}). Gegen ein leeres Schema ist keine sinnvolle Aussage moeglich -- "
        "Single-Source kaputt, NICHT still gruen.")
endif()
message(STATUS "${_ctx}: '${SCHEMA}' traegt ${_n_se} <element>- und ${_n_sa} <attribute>-Deklarationen "
               "(Deklarationen, nicht verschiedene Namen -- derselbe Name darf in mehreren "
               "complexTypes deklariert sein).")
comdare_xml_close("${_schema_doc}" "${SCHEMA}")

function(comdare_check_instance _ctx _label _file _schema)
    comdare_xml_open("${_ctx}" "${_label}" "${_file}" FALSE _doc)
    execute_process(
        COMMAND "${COMDARE_XMLLINT_EXE}" --noout --nonet --noent --schema "${_schema}" "${_doc}"
        RESULT_VARIABLE _rc OUTPUT_QUIET ERROR_VARIABLE _err ERROR_STRIP_TRAILING_WHITESPACE)
    if(NOT _rc EQUAL 0)
        comdare_xml_close("${_doc}" "${_file}")
        message(FATAL_ERROR
            "${_ctx}: VOKABULAR-/STRUKTUR-DRIFT (${_label}) -- die Datei ist NICHT gueltig gegen "
            "die Single-Source-XSD.\n"
            "  DATEI:  ${_file}\n"
            "  SCHEMA: ${_schema}\n"
            "  BEFUND von xmllint (RC=${_rc}):\n${_err}\n"
            "Fix: entweder das Schema additiv erweitern (Schema-Evolution zuerst in der XSD, s. "
            "test_data_xml/SCHEMA.md) oder die Datei auf das Schema-Vokabular ziehen.")
    endif()
    comdare_xml_count("${_ctx}" "${_label}" "${_doc}" "//*"  _n_e)
    comdare_xml_count("${_ctx}" "${_label}" "${_doc}" "//@*" _n_a)
    comdare_xml_close("${_doc}" "${_file}")
    message(STATUS "${_ctx}: OK (${_label}) -- ${_n_e} Elemente / ${_n_a} Attribute, gueltig gegen "
                   "das Schema.")
endfunction()

if(DEFINED MASTER)
    comdare_check_instance("${_ctx}" "MASTER" "${MASTER}" "${SCHEMA}")
endif()
comdare_check_instance("${_ctx}" "FIXTURE" "${FIXTURE}" "${SCHEMA}")
