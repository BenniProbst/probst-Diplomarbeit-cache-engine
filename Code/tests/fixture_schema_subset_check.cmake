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
#
# SKIP-DISZIPLIN (B14-NB2, Codex-MITTEL "fehlende SCHEMA-/MASTER-Datei = Skip statt Fail"): ein SKIP ist
# NUR fuer den EINEN Fall zulaessig, fuer den er gedacht war -- der ce-NACHBAR-CHECKOUT fehlt (Submodul
# nicht ausgecheckt). SCHEMA und MASTER liegen dagegen im super-Repo SELBST (Code/test_data_xml/); fehlen
# sie, ist das kein fehlender Nachbar, sondern ein kaputtes eigenes Repo bzw. eine falsch verdrahtete
# add_test-Zeile. Ein SKIP haette das stumm verdeckt und die Wache faktisch abgeschaltet -> beides ist
# jetzt FATAL. Nur FIXTURE skippt (Marker FIXTURE-SYNC-SKIP, identisch zu fixture_sync_check.cmake, damit
# dieselbe SKIP_REGULAR_EXPRESSION greift).

foreach(_req SCHEMA FIXTURE)
    if(NOT DEFINED ${_req})
        message(FATAL_ERROR "fixture_schema_subset_check: -D${_req} fehlt.")
    endif()
endforeach()

if(NOT EXISTS "${SCHEMA}")
    message(FATAL_ERROR
        "fixture_schema_subset_check: SCHEMA '${SCHEMA}' EXISTIERT NICHT. Das ist KEIN fehlender "
        "Nachbar-Checkout (die XSD liegt im super-Repo selbst) -- entweder ist der Pfad in der "
        "add_test-Zeile falsch oder die Single-Source ist verschwunden. Kein SKIP.")
endif()
if(DEFINED MASTER AND NOT EXISTS "${MASTER}")
    message(FATAL_ERROR
        "fixture_schema_subset_check: MASTER '${MASTER}' EXISTIERT NICHT. Auch der MASTER liegt im "
        "super-Repo selbst (Code/test_data_xml/) -- kein Nachbar-Checkout, also kein SKIP.")
endif()
if(NOT EXISTS "${FIXTURE}")
    message(STATUS "FIXTURE-SYNC-SKIP: Nachbar-Checkout fehlt (FIXTURE='${FIXTURE}').")
    return()
endif()

# -- Hilfsfunktion: CDATA-Sektionen entfernen. MUSS VOR dem Kommentar-Strip laufen (B14-NB2,
#    Codex-MITTEL "Kommentar-Strip via CDATA umgehbar"): der Inhalt einer CDATA-Sektion ist per
#    XML-Definition TEXT, kein Markup. Ohne diesen Schritt sind beide Richtungen kaputt:
#      (a) FALSCH-POSITIV: <![CDATA[ <phantom_element/> ]]> haette einen Element-Namen geliefert,
#          den die XSD zu Recht nicht kennt -> die Wache meldet Drift, wo keine ist;
#      (b) FALSCH-NEGATIV (der gefaehrliche Fall): ein '<!--' INNERHALB einer CDATA-Sektion haette
#          den Kommentar-Strip losgetreten und alles bis zum naechsten '-->' WEGGESCHNITTEN --
#          inklusive echter, dazwischen liegender Tags. Vokabular-Drift waere unsichtbar geworden.
#    Nach dem Entfernen bleibt die Sektion als LEERE Stelle stehen (kein Ersatztext), damit keine
#    kuenstlichen Namen entstehen.
function(comdare_strip_cdata _in _out_var)
    set(_s "${_in}")
    while(TRUE)
        string(FIND "${_s}" "<![CDATA[" _p)
        if(_p EQUAL -1)
            break()
        endif()
        string(SUBSTRING "${_s}" 0 ${_p} _head)
        string(SUBSTRING "${_s}" ${_p} -1 _rest)
        string(FIND "${_rest}" "]]>" _e)
        if(_e EQUAL -1)
            message(FATAL_ERROR
                "fixture_schema_subset_check: unbeendete CDATA-Sektion (kein ']]>') -- die Datei ist "
                "nicht wohlgeformt oder abgeschnitten. Kein stilles Gruen.")
        endif()
        math(EXPR _after "${_e} + 3")
        string(SUBSTRING "${_rest}" ${_after} -1 _tail)
        set(_s "${_head}${_tail}")
    endwhile()
    set(${_out_var} "${_s}" PARENT_SCOPE)
endfunction()

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

# -- Hilfsfunktion: Datei einlesen + CDATA + Kommentare entfernen; LEERE/UNLESBARE Datei ist FATAL.
#    (B14-NB2, Codex-HOCH ":138 leere/abgeschnittene XML = stumm-gruen"): eine leere oder auf 0 Bytes
#    truncierte Datei lieferte frueher eine LEERE Namensmenge, und eine leere Menge ist trivial
#    Teilmenge von allem -> die Wache meldete OK fuer eine Datei ohne jeden Inhalt. Genau der Fall,
#    den eine Wache fangen muss.
function(comdare_read_markup _file _out_var)
    file(SIZE "${_file}" _bytes)
    if(_bytes EQUAL 0)
        message(FATAL_ERROR
            "fixture_schema_subset_check: '${_file}' ist LEER (0 Byte). Eine leere Datei ist trivial "
            "'schema-konform' und waere stumm gruen durchgelaufen. Kein Gruen ohne Inhalt.")
    endif()
    file(READ "${_file}" _raw)
    string(STRIP "${_raw}" _stripped)
    if(_stripped STREQUAL "")
        message(FATAL_ERROR
            "fixture_schema_subset_check: '${_file}' enthaelt nur Leerraum (${_bytes} Byte). "
            "Kein Gruen ohne Inhalt.")
    endif()
    comdare_strip_cdata("${_raw}" _nocdata)
    comdare_strip_xml_comments("${_nocdata}" _txt)
    set(${_out_var} "${_txt}" PARENT_SCOPE)
endfunction()

# -- Hilfsfunktion: die Tags einer Markup-Datei QUOTE-BEWUSST einsammeln.
#    (B14-NB2, Codex-MITTEL "Tag-Regex bricht an '>' im Attributwert"): '>' ist im Attributwert
#    LEGALES XML (nur '<' und '&' muessen maskiert werden; xmllint akzeptiert <a b="x>y"/> anstandslos).
#    Das alte MATCHALL "<[A-Za-z_][^>]*>" schnitt genau dort ab: aus <axis ref="a>b" phantom="1"/>
#    wurde der Tag-Rest ' phantom="1"/>' zu freiem Text und das Attribut phantom verschwand aus der
#    Pruefung -- Vokabular-Drift blieb unsichtbar. Diese Funktion sucht das Tag-Ende deshalb, indem sie
#    ueber die Attributwerte HINWEGSPRINGT: sie merkt sich, ob sie gerade in "..." bzw. '...' steht,
#    und akzeptiert nur ein '>' AUSSERHALB der Quotes.
#    Rueckgabe: zwei Listen (Element-Namen, Attribut-Namen). Die Tag-Rohtexte werden bewusst NICHT
#    zurueckgereicht -- sie koennen ';' enthalten und wuerden CMake-Listen zerreissen.
function(comdare_scan_tags _txt _label _file _elems_var _attrs_var)
    set(_elems "")
    set(_attrs "")
    set(_rest "${_txt}")
    while(TRUE)
        string(FIND "${_rest}" "<" _lt)
        if(_lt EQUAL -1)
            break()
        endif()
        string(SUBSTRING "${_rest}" ${_lt} -1 _from)
        # Tag-Ende quote-bewusst suchen (Offsets relativ zu _from).
        set(_scan "${_from}")
        set(_consumed 0)
        set(_end -1)
        while(TRUE)
            string(FIND "${_scan}" ">" _gt)
            string(FIND "${_scan}" "\"" _dq)
            string(FIND "${_scan}" "'" _sq)
            # Der naechste "interessante" Punkt: das erste Quote-Zeichen vor dem '>' gewinnt.
            set(_q -1)
            if(NOT _dq EQUAL -1)
                set(_q ${_dq})
            endif()
            if(NOT _sq EQUAL -1 AND (_q EQUAL -1 OR _sq LESS _q))
                set(_q ${_sq})
            endif()
            if(_gt EQUAL -1)
                break()   # kein '>' mehr -> abgeschnitten, unten behandelt
            endif()
            if(_q EQUAL -1 OR _gt LESS _q)
                math(EXPR _end "${_consumed} + ${_gt}")
                break()
            endif()
            # In einen Attributwert eintreten und ihn ueberspringen.
            string(SUBSTRING "${_scan}" ${_q} 1 _qc)
            math(EXPR _vstart "${_q} + 1")
            string(SUBSTRING "${_scan}" ${_vstart} -1 _afterq)
            string(FIND "${_afterq}" "${_qc}" _vend)
            if(_vend EQUAL -1)
                message(FATAL_ERROR
                    "fixture_schema_subset_check: unbeendeter Attributwert (${_label}) in '${_file}' -- "
                    "oeffnendes ${_qc} ohne schliessendes Gegenstueck. Die Datei ist nicht wohlgeformt "
                    "oder abgeschnitten. Kein stilles Gruen.")
            endif()
            math(EXPR _skip "${_vstart} + ${_vend} + 1")
            math(EXPR _consumed "${_consumed} + ${_skip}")
            string(SUBSTRING "${_scan}" ${_skip} -1 _scan)
        endwhile()
        if(_end EQUAL -1)
            message(FATAL_ERROR
                "fixture_schema_subset_check: ABGESCHNITTENE Datei (${_label}) '${_file}' -- ein '<' "
                "ohne zugehoeriges '>' am Dateiende. Eine truncierte XML darf nicht gruen sein.")
        endif()
        math(EXPR _body_len "${_end} - 1")
        math(EXPR _next "${_end} + 1")
        string(SUBSTRING "${_from}" 1 ${_body_len} _body)
        string(SUBSTRING "${_from}" ${_next} -1 _rest)
        # Nur oeffnende/leere Element-Tags tragen Vokabular: '/' = schliessend, '?' = XML-Deklaration,
        # '!' = DOCTYPE (CDATA/Kommentare sind bereits entfernt).
        if(_body MATCHES "^[A-Za-z_]")
            # Attributwerte leeren, DANN Namen ziehen: ein 'wort=' INNERHALB eines Wertes ist kein
            # Attribut-Name. Beide Quote-Formen.
            string(REGEX REPLACE "\"[^\"]*\"" "\"\"" _nov "${_body}")
            string(REGEX REPLACE "'[^']*'" "''" _nov "${_nov}")
            string(REGEX REPLACE "^([A-Za-z_][A-Za-z0-9_.:-]*).*$" "\\1" _name "${_nov}")
            list(APPEND _elems "${_name}")
            string(REGEX MATCHALL "[A-Za-z_][A-Za-z0-9_.:-]*[ \t\r\n]*=" _am "${_nov}")
            foreach(_ahit IN LISTS _am)
                string(REGEX REPLACE "[ \t\r\n]*=$" "" _aname "${_ahit}")
                # Namensraum-Deklarationen sind XML-Infrastruktur, kein Schema-Vokabular.
                if(NOT _aname MATCHES "^xmlns" AND NOT _aname MATCHES "^xsi:")
                    list(APPEND _attrs "${_aname}")
                endif()
            endforeach()
        endif()
    endwhile()
    list(REMOVE_DUPLICATES _elems)
    list(REMOVE_DUPLICATES _attrs)
    set(${_elems_var} "${_elems}" PARENT_SCOPE)
    set(${_attrs_var} "${_attrs}" PARENT_SCOPE)
endfunction()

# -- Deklariertes Vokabular der XSD einsammeln: <xs:element name=".."> + <xs:attribute name="..">.
#    Liest ueber comdare_read_markup, damit auch die XSD gegen leere Datei / CDATA-Trick / unbeendeten
#    Kommentar abgesichert ist (eine leere XSD lieferte sonst ein leeres Vokabular -- unten ohnehin FATAL,
#    aber die Fehlermeldung soll die WAHRE Ursache nennen).
function(comdare_collect_schema_names _file _elems_var _attrs_var)
    comdare_read_markup("${_file}" _txt)
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

# -- Benutztes Vokabular einer XML-Instanz einsammeln (quote-bewusst, s. comdare_scan_tags).
#    Zusaetzlich die beiden STUMM-GRUEN-Riegel (B14-NB2): 0 Element-Namen ist FATAL, und der Wurzel-Tag
#    muss auch wieder geschlossen werden -- eine mitten im Dokument abgeschnittene Datei kann sonst eine
#    Handvoll gueltiger Tags liefern und "OK" melden, obwohl der Rest fehlt.
function(comdare_collect_instance_names _label _file _elems_var _attrs_var)
    comdare_read_markup("${_file}" _txt)
    comdare_scan_tags("${_txt}" "${_label}" "${_file}" _elems _attrs)
    list(LENGTH _elems _n)
    if(_n EQUAL 0)
        message(FATAL_ERROR
            "fixture_schema_subset_check: '${_file}' (${_label}) enthaelt KEIN einziges Element-Tag. "
            "Eine Namensmenge der Groesse 0 ist trivial Teilmenge des Schemas und waere stumm gruen "
            "durchgelaufen. Kein Gruen ohne Vokabular.")
    endif()
    # Wurzel-Abschluss-Riegel gegen Truncation MITTEN im Dokument.
    list(GET _elems 0 _root)
    string(FIND "${_txt}" "</${_root}>" _close)
    if(_close EQUAL -1)
        # Zulaessige Ausnahme: eine leere Wurzel <root/>. Alles andere ist abgeschnitten.
        if(NOT _txt MATCHES "<${_root}[^>]*/>")
            message(FATAL_ERROR
                "fixture_schema_subset_check: ABGESCHNITTENE Datei (${_label}) '${_file}' -- der "
                "Wurzel-Tag <${_root}> wird nie geschlossen (kein '</${_root}>' und keine Leer-Form "
                "'<${_root}/>'). Eine truncierte XML darf nicht gruen sein.")
        endif()
    endif()
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
    comdare_collect_instance_names("${_label}" "${_file}" _ielems _iattrs)
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
