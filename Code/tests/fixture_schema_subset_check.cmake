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
# VOLLZUGS-NACHZUG (17.08.2026, super-k2-Zug): die ce-Umbenennung IST VOLLZOGEN (Weg a, ce 44a909c1,
# gelandet 7a5ed464/965b121a) -- die ce-Fixture heisst jetzt EINDEUTIG experiment_kern_seam_fixture.xml.
# Diese Wache BLEIBT die richtige Form (kein Byte-Sync: die Werte weichen weiter ABSICHTLICH ab);
# geaendert hat sich nur der FIXTURE-Pfad in add_test UND die Skip-Disziplin unten: ein fehlendes
# FIXTURE bei EXISTIERENDEM ce-Checkout ist seit dem Rename ein VERDRAHTUNGSFEHLER (genau so blieb
# die Wache nach der W1-Landung still gruen, Sweep-Befund B-1) und ist jetzt FATAL.
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
# Erwartete -D Variablen: SCHEMA (die XSD), MASTER (die super-golden), FIXTURE (die ce-Fixture).
# ALLE DREI SIND PFLICHT (B14-NB4/B9): MASTER war "optional", und ein weggelassenes -DMASTER schaltete
# damit ein ganzes Bein der Wache lautlos ab.
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

# B14-NB4 / Befund B8: Werkzeug-Pruefung VOR jedem Skip (Begruendung wortgleich in
# golden_n_consistency_check.cmake). Vorher stand der Nachbar-Skip davor -- fehlten Submoduldatei UND
# xmllint gleichzeitig, schaltete sich die Wache trotz "absoluter FATAL-Pflicht" still ab.
comdare_xml_require_tool("${_ctx}")

# B14-NB4 / Befund B9: MASTER ist PFLICHT. Vorher verlangte diese Schleife nur SCHEMA und FIXTURE, und
# das MASTER-Bein haengte an "if(DEFINED MASTER)". Ein KOMPLETT WEGGELASSENES -DMASTER schaltete das
# Bein damit LAUTLOS ab -- die Wache lief gruen mit der halben Aussage. Der bestehende Biss deckte nur
# den anderen Fall (definiert, aber Datei fehlt). Beide add_test-Zeilen uebergeben MASTER; ein
# Weglassen waere also immer ein Verdrahtungsfehler, nie eine Absicht.
foreach(_req SCHEMA FIXTURE MASTER)
    if(NOT DEFINED ${_req})
        message(FATAL_ERROR
            "${_ctx}: -D${_req} fehlt. Alle drei Wege sind Pflicht: SCHEMA ist die Single-Source, "
            "MASTER und FIXTURE sind die zwei Beine der Aussage. Ein fehlendes -D ist ein Fehler in "
            "der add_test-Zeile -- und wuerde, wenn er toleriert wuerde, ein Bein still abschalten.")
    endif()
endforeach()

if(NOT EXISTS "${SCHEMA}")
    message(FATAL_ERROR
        "${_ctx}: SCHEMA '${SCHEMA}' EXISTIERT NICHT. Das ist KEIN fehlender "
        "Nachbar-Checkout (die XSD liegt im super-Repo selbst) -- entweder ist der Pfad in der "
        "add_test-Zeile falsch oder die Single-Source ist verschwunden. Kein SKIP.")
endif()
if(NOT EXISTS "${MASTER}")
    message(FATAL_ERROR
        "${_ctx}: MASTER '${MASTER}' EXISTIERT NICHT. Auch der MASTER liegt im "
        "super-Repo selbst (Code/test_data_xml/) -- kein Nachbar-Checkout, also kein SKIP.")
endif()
if(NOT EXISTS "${FIXTURE}")
    # B-1-HAERTUNG (17.08.2026): SKIP nur, wenn der ce-NACHBAR-CHECKOUT wirklich fehlt (Submodul
    # nicht ausgecheckt). Existiert das ce-Verzeichnis, aber die Datei nicht, ist das ein
    # VERDRAHTUNGSFEHLER (falscher/veralteter FIXTURE-Pfad) -- der stille Skip hat genau diese
    # Klasse nach dem Weg-a-Rename gruen durchgelassen. Jetzt FATAL mit beiden Pfaden im Text.
    get_filename_component(_fixture_dir "${FIXTURE}" DIRECTORY)
    get_filename_component(_ce_root "${_fixture_dir}" DIRECTORY)
    get_filename_component(_ce_root "${_ce_root}" DIRECTORY)
    if(EXISTS "${_ce_root}")
        message(FATAL_ERROR
            "${_ctx}: FIXTURE '${FIXTURE}' EXISTIERT NICHT, obwohl der ce-Checkout "
            "'${_ce_root}' vorhanden ist -- das ist KEIN fehlender Nachbar, sondern eine "
            "falsch verdrahtete add_test-Zeile (Skip-Klasse B-1, seit Weg-a-Rename FATAL).")
    endif()
    # B14-NB4 / Befund B4: Grund und MARKER auf getrennten Zeilen, der Marker ohne jede Interpolation.
    message(STATUS "Nachbar-Checkout fehlt (FIXTURE='${FIXTURE}') -- diese Wache kann nichts aussagen.")
    message(STATUS "COMDARE-XML-WACHE-SKIP")
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

# -- B14-NB5: xs:include/xs:import-BLINDHEIT geschlossen (fuer die HAEUFIGE Form: das Hauptdokument
#    verweist DIREKT auf 1..n weitere Dateien). Vorher sah die Vokabular-Zaehlung oben nur
#    Deklarationen im HAUPTDOKUMENT; eine ueber <xs:include schemaLocation="../> bzw. <xs:import .../>
#    verteilte Schema-Evolution waere unsichtbar geblieben -- im Extremfall haette ein Hauptdokument
#    OHNE lokale Deklarationen, aber mit vollstaendigem Vokabular in inkludierten Dateien, den Riegel
#    gegen "leeres Schema" (unten) faelschlich ausgeloest.
#    AUSGEWIESENE GRENZE, nicht verschwiegen: nur EINE Ebene. Includet eine inkludierte Datei ihrerseits
#    weiter, zaehlt diese Funktion deren Vokabular NICHT mit -- eine echte, unbegrenzte Rekursion haette
#    in CMake eine fehleranfaellige Listen-Weiterreichung ueber mehrere Funktions-Scopes gebraucht (jede
#    cmake-Funktion oeffnet einen neuen Scope; PARENT_SCOPE reicht genau EINE Ebene). Das Risiko einer
#    subtil falschen Rekursion fuer einen Fall, der in dieser Domaene (zwei kleine, handgeschriebene
#    XSD-Dateien) nicht auftritt, wog schwerer als der Nutzen; die Grenze wird deshalb bewusst gezogen
#    und hier benannt. Heute (per grep verifiziert) nutzt experiment_schema.xsd weder include noch
#    import -- diese Funktion deckt trotzdem den haeufigen, einstufigen Fall ab, statt "heute
#    unerreichbar" als Entlastung zu nehmen.
function(comdare_xml_count_schema_includes _ctx _file _doc _xsd_ns _elems_var _attrs_var)
    set(_incpath
        "//*[(local-name()='include' or local-name()='import') and namespace-uri()='${_xsd_ns}' and @schemaLocation]")
    comdare_xml_count("${_ctx}" "SCHEMA" "${_doc}" "${_incpath}" _n_inc)
    set(_e 0)
    set(_a 0)
    if(_n_inc GREATER 0)
        get_filename_component(_basedir "${_file}" DIRECTORY)
        foreach(_i RANGE 1 ${_n_inc})
            comdare_xml_string("${_ctx}" "SCHEMA" "${_doc}" "(${_incpath})[${_i}]/@schemaLocation" _loc)
            if(NOT IS_ABSOLUTE "${_loc}")
                set(_loc "${_basedir}/${_loc}")
            endif()
            get_filename_component(_loc "${_loc}" ABSOLUTE)
            if(NOT EXISTS "${_loc}")
                message(FATAL_ERROR
                    "${_ctx}: SCHEMA '${_file}' verweist per include/import auf '${_loc}', die NICHT "
                    "existiert.")
            endif()
            comdare_xml_open("${_ctx}" "SCHEMA-INCLUDE" "${_loc}" FALSE _incdoc)
            comdare_xml_count("${_ctx}" "SCHEMA-INCLUDE" "${_incdoc}"
                "//*[local-name()='element' and namespace-uri()='${_xsd_ns}' and @name]" _ie)
            comdare_xml_count("${_ctx}" "SCHEMA-INCLUDE" "${_incdoc}"
                "//*[local-name()='attribute' and namespace-uri()='${_xsd_ns}' and @name]" _ia)
            comdare_xml_close("${_incdoc}" "${_loc}")
            math(EXPR _e "${_e} + ${_ie}")
            math(EXPR _a "${_a} + ${_ia}")
        endforeach()
    endif()
    set(${_elems_var} "${_e}" PARENT_SCOPE)
    set(${_attrs_var} "${_a}" PARENT_SCOPE)
endfunction()
comdare_xml_count_schema_includes("${_ctx}" "${SCHEMA}" "${_schema_doc}" "${_xsd_ns}" _n_se_inc _n_sa_inc)
math(EXPR _n_se "${_n_se} + ${_n_se_inc}")
math(EXPR _n_sa "${_n_sa} + ${_n_sa_inc}")

if(_n_se EQUAL 0 OR _n_sa EQUAL 0)
    message(FATAL_ERROR
        "${_ctx}: SCHEMA '${SCHEMA}' deklariert kein Vokabular (Elemente=${_n_se}, "
        "Attribute=${_n_sa}). Gegen ein leeres Schema ist keine sinnvolle Aussage moeglich -- "
        "Single-Source kaputt, NICHT still gruen.")
endif()
message(STATUS "${_ctx}: '${SCHEMA}' traegt ${_n_se} <element>- und ${_n_sa} <attribute>-Deklarationen "
               "(Deklarationen, nicht verschiedene Namen -- derselbe Name darf in mehreren "
               "complexTypes deklariert sein; ${_n_se_inc}/${_n_sa_inc} davon aus direkt "
               "inkludierten/importierten Dateien, s. comdare_xml_count_schema_includes).")
comdare_xml_close("${_schema_doc}" "${SCHEMA}")

function(comdare_check_instance _ctx _label _file _schema)
    comdare_xml_open("${_ctx}" "${_label}" "${_file}" FALSE _doc)
    # B14-NB5: KEIN --noent mehr -- comdare_xml_open hat "${_doc}" bereits als DOCTYPE-frei bestaetigt
    # (Entity-Sperre, s. xml_canonical_utils.cmake/comdare_xml_has_doctype), --noent waere hier ohnehin
    # wirkungslos, aber auch ueberfluessige Angriffsflaeche, wenn diese Zeile je isoliert kopiert wird.
    execute_process(
        COMMAND "${COMDARE_XMLLINT_EXE}" --noout --nonet --schema "${_schema}" "${_doc}"
        RESULT_VARIABLE _rc OUTPUT_QUIET ERROR_VARIABLE _err ERROR_STRIP_TRAILING_WHITESPACE
        TIMEOUT 10)
    # B14-NB4 / Befund B3: auch der Schema-Lauf laedt das Dokument -- und meldet einen durch --nonet
    # blockierten externen Entity-Load NUR ueber stderr, bei RC 0. Die Validierung liefe dann gegen
    # einen Baum OHNE den Entity-Inhalt und meldete "gueltig". Der Riegel steht deshalb VOR der
    # RC-Auswertung, damit er auch den Erfolgsfall trifft.
    # SONDERFALL, ehrlich benannt: xmllint gibt bei ERFOLGREICHER Validierung "<datei> validates" auf
    # stderr aus. Genau diese eine Zeile ist erlaubt und wird vorher entfernt -- alles andere bleibt
    # ein Grund, NICHT gruen zu sein.
    if(_rc EQUAL 0)
        string(REGEX REPLACE "^[^\n]* validates\r?\n?" "" _err_rest "${_err}")
        string(STRIP "${_err_rest}" _err_rest)
        comdare_xml_assert_clean_stderr("${_ctx}" "${_label}" "Schema-Validierung" "${_file}" "${_err_rest}")
    endif()
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

# B14-NB4 / Befund B9: kein "if(DEFINED MASTER)" mehr -- MASTER ist oben Pflicht, das Bein laeuft IMMER.
comdare_check_instance("${_ctx}" "MASTER" "${MASTER}" "${SCHEMA}")
comdare_check_instance("${_ctx}" "FIXTURE" "${FIXTURE}" "${SCHEMA}")
