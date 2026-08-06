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
#   (1) MASTER-Bein: jedes Element-Tag und jeder Attribut-Name des MASTERS ist im SCHEMA deklariert.
#       Faengt "die golden-XML erfindet Vokabular, das die XSD nicht kennt".
#   (2) FIXTURE-Bein: dasselbe fuer die ce-Fixture. Faengt "die ce-Fixture uebt eine Naht, die es im
#       Ziel-Schema gar nicht gibt" (Phantom-Fixture) -- das ist die Teilmengen-Aussage.
# Beide Seiten werden damit gegen DIESELBE Single-Source geprueft (experiment_schema.xsd). Der Sinn ist
# nicht Byte-Gleichheit, sondern EIN Vokabular: eine Schema-Evolution im Master, der die Fixture nicht
# folgt, kann keine unbemerkte zweite Sprache entstehen lassen.
#
# NICHT-ZIEL (ehrlich benannt, damit die Wache nicht ueberschaetzt wird): sie prueft NAMEN, keine Werte,
# keine Kardinalitaeten und keine Reihenfolge. Die formale Struktur-Pruefung ist xmllint --schema, die
# Registry-/Wert-Pruefung ist der Code-Validator validate_experiment_profile. Diese Wache ist die
# dependency-freie ctest-Schicht dazwischen (reines CMake, kein xmllint-Zwang auf den Runnern).
#
# Erwartete -D Variablen: SCHEMA (die XSD), FIXTURE (die ce-Fixture), MASTER (optional, die super-golden).
# Fehlt ein Nachbar-Checkout, wird sauber GESKIPPT (Marker FIXTURE-SYNC-SKIP, identisch zu
# fixture_sync_check.cmake, damit dieselbe SKIP_REGULAR_EXPRESSION greift) -- NIE stumm-gruen.

foreach(_req SCHEMA FIXTURE)
    if(NOT DEFINED ${_req})
        message(FATAL_ERROR "fixture_schema_subset_check: -D${_req} fehlt.")
    endif()
endforeach()

if(NOT EXISTS "${SCHEMA}" OR NOT EXISTS "${FIXTURE}")
    message(STATUS "FIXTURE-SYNC-SKIP: Nachbar-Checkout fehlt (SCHEMA='${SCHEMA}' FIXTURE='${FIXTURE}').")
    return()
endif()
if(DEFINED MASTER AND NOT EXISTS "${MASTER}")
    message(STATUS "FIXTURE-SYNC-SKIP: Nachbar-Checkout fehlt (MASTER='${MASTER}').")
    return()
endif()

# -- Hilfsfunktion: XML-/XSD-Kommentare entfernen. Ohne das wuerden Tag-Namen AUS Kommentaren
#    (die Dateien zitieren reichlich Elemente im Fliesstext) als "benutzt" gezaehlt werden.
function(comdare_strip_xml_comments _in _out_var)
    set(_s "${_in}")
    while(TRUE)
        string(FIND "${_s}" "<!--" _p)
        if(_p EQUAL -1)
            break()
        endif()
        string(SUBSTRING "${_s}" 0 ${_p} _head)
        string(SUBSTRING "${_s}" ${_p} -1 _rest)
        string(FIND "${_rest}" "-->" _e)
        if(_e EQUAL -1)
            message(FATAL_ERROR "fixture_schema_subset_check: unbeendeter XML-Kommentar (kein '-->').")
        endif()
        math(EXPR _after "${_e} + 3")
        string(SUBSTRING "${_rest}" ${_after} -1 _tail)
        set(_s "${_head}${_tail}")
    endwhile()
    set(${_out_var} "${_s}" PARENT_SCOPE)
endfunction()

# -- Deklariertes Vokabular der XSD einsammeln: <xs:element name=".."> + <xs:attribute name="..">.
function(comdare_collect_schema_names _file _elems_var _attrs_var)
    file(READ "${_file}" _raw)
    comdare_strip_xml_comments("${_raw}" _txt)
    set(_elems "")
    set(_attrs "")
    string(REGEX MATCHALL "<xs:element[ \t\r\n]+name=\"[A-Za-z_][A-Za-z0-9_.:-]*\"" _m "${_txt}")
    foreach(_hit IN LISTS _m)
        string(REGEX REPLACE "^.*name=\"([A-Za-z_][A-Za-z0-9_.:-]*)\"$" "\\1" _n "${_hit}")
        list(APPEND _elems "${_n}")
    endforeach()
    string(REGEX MATCHALL "<xs:attribute[ \t\r\n]+name=\"[A-Za-z_][A-Za-z0-9_.:-]*\"" _m "${_txt}")
    foreach(_hit IN LISTS _m)
        string(REGEX REPLACE "^.*name=\"([A-Za-z_][A-Za-z0-9_.:-]*)\"$" "\\1" _n "${_hit}")
        list(APPEND _attrs "${_n}")
    endforeach()
    list(REMOVE_DUPLICATES _elems)
    list(REMOVE_DUPLICATES _attrs)
    set(${_elems_var} "${_elems}" PARENT_SCOPE)
    set(${_attrs_var} "${_attrs}" PARENT_SCOPE)
endfunction()

# -- Benutztes Vokabular einer XML-Instanz einsammeln. Attribut-WERTE werden vorher geleert, damit ein
#    'wort=' INNERHALB eines Wertes nicht faelschlich als Attribut-Name gilt.
function(comdare_collect_instance_names _file _elems_var _attrs_var)
    file(READ "${_file}" _raw)
    comdare_strip_xml_comments("${_raw}" _txt)
    set(_elems "")
    set(_attrs "")
    # Oeffnende und leere Tags (schliessende beginnen mit '/', die XML-Deklaration mit '?').
    string(REGEX MATCHALL "<[A-Za-z_][^>]*>" _tags "${_txt}")
    foreach(_tag IN LISTS _tags)
        string(REGEX REPLACE "\"[^\"]*\"" "\"\"" _tag_novals "${_tag}")
        string(REGEX REPLACE "^<([A-Za-z_][A-Za-z0-9_.:-]*).*$" "\\1" _name "${_tag_novals}")
        list(APPEND _elems "${_name}")
        string(REGEX MATCHALL "[A-Za-z_][A-Za-z0-9_.:-]*[ \t\r\n]*=" _am "${_tag_novals}")
        foreach(_ahit IN LISTS _am)
            string(REGEX REPLACE "[ \t\r\n]*=$" "" _aname "${_ahit}")
            # Namensraum-Deklarationen sind XML-Infrastruktur, kein Schema-Vokabular.
            if(NOT _aname MATCHES "^xmlns" AND NOT _aname MATCHES "^xsi:")
                list(APPEND _attrs "${_aname}")
            endif()
        endforeach()
    endforeach()
    list(REMOVE_DUPLICATES _elems)
    list(REMOVE_DUPLICATES _attrs)
    set(${_elems_var} "${_elems}" PARENT_SCOPE)
    set(${_attrs_var} "${_attrs}" PARENT_SCOPE)
endfunction()

comdare_collect_schema_names("${SCHEMA}" _schema_elems _schema_attrs)
list(LENGTH _schema_elems _n_se)
list(LENGTH _schema_attrs _n_sa)
if(_n_se EQUAL 0 OR _n_sa EQUAL 0)
    # Ein leeres Vokabular hiesse: die Extraktion hat nichts gefunden und JEDE Instanz waere trivial
    # "sauber" -- genau die stumm-gruene Falle. Lieber laut abbrechen.
    message(FATAL_ERROR "fixture_schema_subset_check: SCHEMA '${SCHEMA}' lieferte kein Vokabular "
                        "(Elemente=${_n_se}, Attribute=${_n_sa}) -- Extraktion kaputt, NICHT still gruen.")
endif()
message(STATUS "fixture_schema_subset_check: Schema-Vokabular ${_n_se} Elemente / ${_n_sa} Attribute "
               "aus '${SCHEMA}'.")

function(comdare_check_instance _label _file _schema_elems _schema_attrs)
    comdare_collect_instance_names("${_file}" _ielems _iattrs)
    set(_bad "")
    foreach(_e IN LISTS _ielems)
        if(NOT "${_e}" IN_LIST _schema_elems)
            list(APPEND _bad "Element <${_e}>")
        endif()
    endforeach()
    foreach(_a IN LISTS _iattrs)
        if(NOT "${_a}" IN_LIST _schema_attrs)
            list(APPEND _bad "Attribut ${_a}=")
        endif()
    endforeach()
    if(_bad)
        string(REPLACE ";" "\n    " _badtxt "${_bad}")
        message(FATAL_ERROR
            "fixture_schema_subset_check: VOKABULAR-DRIFT (${_label}) -- die Datei benutzt Namen, die "
            "experiment_schema.xsd NICHT deklariert.\n"
            "  DATEI:  ${_file}\n"
            "  SCHEMA: ${SCHEMA}\n"
            "  UNGEDECKT:\n    ${_badtxt}\n"
            "Fix: entweder das Schema additiv erweitern (Schema-Evolution zuerst in der XSD, s. "
            "test_data_xml/SCHEMA.md) oder den Namen in der Datei auf das Schema-Vokabular ziehen.")
    endif()
    list(LENGTH _ielems _n_ie)
    list(LENGTH _iattrs _n_ia)
    message(STATUS "fixture_schema_subset_check: OK (${_label}) -- ${_n_ie} Element-Namen / ${_n_ia} "
                   "Attribut-Namen, alle im Schema deklariert.")
endfunction()

if(DEFINED MASTER)
    comdare_check_instance("MASTER" "${MASTER}" "${_schema_elems}" "${_schema_attrs}")
endif()
comdare_check_instance("FIXTURE" "${FIXTURE}" "${_schema_elems}" "${_schema_attrs}")
