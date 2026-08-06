# golden_n_consistency_check.cmake -- B14-NB2 (2026-08-06): die Wache der KETTE
# {super Code/test_data_xml/experiment_golden_kern.xml, ce .../thesis_profiles/all_axes_golden.profile.xml}.
#
# WARUM ES SIE GIBT (Codex-Befund HOCH, B14-Verdikt NACHBESSERN): der Owner-Kanon "golden N = 2^17 = 131072"
# lebte maschinenlesbar NUR im ce-Traeger all_axes_golden.profile.xml (<run_options cap="131072"/> + je Achse
# genau 2 <value>). Im KANONISCHEN Traeger experiment_golden_kern.xml stand N ausschliesslich als
# Fliesstext-Kommentar -- und die dort deklarierte Voll-Sweep-Form behauptete rechnerisch ein voellig
# anderes N. Die NB2-Heilung kodiert N in beiden Traegern maschinenlesbar; DIESE Wache haelt sie
# deckungsgleich. Ohne sie waere die Konsistenz eine Momentaufnahme, kein Zustand.
#
# ZWEI DIALEKTE, EINE AUSSAGE. Die Traeger sind bewusst NICHT byte-gleich (verschiedene Wurzeln,
# verschiedene Aufgaben) -- verglichen wird deshalb die SEMANTIK:
#   comdare_experiment  : <axes_default_lookup><axis ref=".." allowed_variants="v1 v2"/>  + <run_options cap=..>
#   comdare_thesis_profile: <permute_axes><axis ref=".."><value>v1</value><value>v2</value></axis> + <run_options cap=..>
#
# GEPRUEFT WIRD (alles FATAL):
#   (1) beide Traeger nennen dieselbe Achsen-MENGE (keine Achse fehlt, keine ist zuviel);
#   (2) je Achse dieselbe Auspraegungs-MENGE (Reihenfolge egal, Namen identisch);
#   (3) das PRODUKT der Auspraegungs-Zahlen ist in beiden Traegern gleich;
#   (4) dieses Produkt ist gleich dem cap BEIDER Traeger. Damit ist "N ist kodiert" nicht nur eine
#       Behauptung, sondern nachgerechnet: cap == prod(|Achse|) == 131072 == 2^17.
# NICHT-ZIEL (ehrlich benannt): die Wache prueft die Namen NICHT gegen die ce-Registry. Das ist Aufgabe
# von validate_experiment_profile Pruefung (5) (Code-Ebene, Single-Source Registry). Diese Wache prueft
# die DECKUNG der beiden golden-Traeger untereinander.
#
# SKIP-DISZIPLIN (identisch zu fixture_schema_subset_check.cmake): MASTER liegt im super-Repo selbst ->
# fehlt er, ist das FATAL. PROFILE liegt im ce-Submodul -> fehlt der Nachbar-Checkout, wird sauber
# GESKIPPT (Marker FIXTURE-SYNC-SKIP, damit dieselbe SKIP_REGULAR_EXPRESSION greift).
#
# DUPLIZIERTE TEXT-HELFER (bewusst, mit Preis): die zwei Strip-Funktionen unten stehen so aehnlich auch in
# fixture_schema_subset_check.cmake. Beide Dateien sind eigenstaendige `cmake -P`-Skripte mit EIGENEM
# FATAL-Vokabular; ein gemeinsames include haette entweder die Fehlertexte verwaschen oder eine
# Include-Pfad-Kopplung zwischen zwei sonst unabhaengigen ctest-Skripten eingefuehrt. Die Zusammenlegung
# in ein xml_text_utils.cmake ist als Kandidat fuer den Sektion-75-Aufraeumpass notiert.

foreach(_req MASTER PROFILE)
    if(NOT DEFINED ${_req})
        message(FATAL_ERROR "golden_n_consistency_check: -D${_req} fehlt.")
    endif()
endforeach()

if(NOT EXISTS "${MASTER}")
    message(FATAL_ERROR
        "golden_n_consistency_check: MASTER '${MASTER}' EXISTIERT NICHT. Der kanonische Traeger liegt im "
        "super-Repo selbst (Code/test_data_xml/) -- kein Nachbar-Checkout, also kein SKIP.")
endif()
if(NOT EXISTS "${PROFILE}")
    message(STATUS "FIXTURE-SYNC-SKIP: Nachbar-Checkout fehlt (PROFILE='${PROFILE}').")
    return()
endif()

# -- CDATA-Sektionen entfernen. VOR dem Kommentar-Strip, sonst kann ein '<!--' im CDATA-Text echtes
#    Markup wegschneiden (dieselbe Falle wie in fixture_schema_subset_check.cmake).
function(comdare_n_strip_cdata _in _out_var)
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
            message(FATAL_ERROR "golden_n_consistency_check: unbeendete CDATA-Sektion (kein ']]>').")
        endif()
        math(EXPR _after "${_e} + 3")
        string(SUBSTRING "${_rest}" ${_after} -1 _tail)
        set(_s "${_head}${_tail}")
    endwhile()
    set(${_out_var} "${_s}" PARENT_SCOPE)
endfunction()

# -- Kommentare entfernen. BEIDE Dateien zitieren im Fliesstext reichlich <axis .../>- und
#    <run_options .../>-Beispiele; ohne diesen Schritt wuerde die Wache Doku als Deklaration lesen.
function(comdare_n_strip_comments _in _out_var)
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
            message(FATAL_ERROR "golden_n_consistency_check: unbeendeter XML-Kommentar (kein '-->').")
        endif()
        math(EXPR _after "${_e} + 3")
        string(SUBSTRING "${_rest}" ${_after} -1 _tail)
        set(_s "${_head}${_tail}")
    endwhile()
    set(${_out_var} "${_s}" PARENT_SCOPE)
endfunction()

function(comdare_n_read _label _file _out_var)
    file(SIZE "${_file}" _bytes)
    if(_bytes EQUAL 0)
        message(FATAL_ERROR
            "golden_n_consistency_check: '${_file}' (${_label}) ist LEER (0 Byte). Eine leere Datei "
            "liefert 0 Achsen und waere trivial 'konsistent'. Kein Gruen ohne Inhalt.")
    endif()
    file(READ "${_file}" _raw)
    comdare_n_strip_cdata("${_raw}" _nocdata)
    comdare_n_strip_comments("${_nocdata}" _txt)
    set(${_out_var} "${_txt}" PARENT_SCOPE)
endfunction()

# -- cap aus <run_options cap=".."/> ziehen. Fehlt der Block oder das Attribut, ist das FATAL: genau
#    dieses Fehlen war der Befund.
function(comdare_n_cap _label _file _txt _out_var)
    if(NOT _txt MATCHES "<run_options[^>]*cap=\"([0-9]+)\"")
        message(FATAL_ERROR
            "golden_n_consistency_check: ${_label} '${_file}' traegt KEIN maschinenlesbares N "
            "(<run_options cap=\"..\"/> fehlt oder hat keinen numerischen cap). Genau das war der "
            "Codex-Befund HOCH -- ein Kommentar ist keine Bauanleitung.")
    endif()
    set(${_out_var} "${CMAKE_MATCH_1}" PARENT_SCOPE)
endfunction()

# -- Achsen des comdare_experiment-Dialekts: <axis ref=".." ... allowed_variants=".."/>.
#    Jede genannte Achse MUSS allowed_variants tragen; eine ungepinnte Achse expandiert zur vollen
#    Registry-Liste und zerstoert damit das deklarierte N.
function(comdare_n_axes_experiment _file _txt _names_var _vals_prefix)
    string(REGEX MATCHALL "<axis [^>]*>" _tags "${_txt}")
    string(REGEX MATCHALL "<axis " _raw_starts "${_txt}")
    list(LENGTH _tags _n_tags)
    list(LENGTH _raw_starts _n_starts)
    if(NOT _n_tags EQUAL _n_starts)
        message(FATAL_ERROR
            "golden_n_consistency_check: MASTER '${_file}': ${_n_starts} <axis-Anfaenge, aber nur "
            "${_n_tags} vollstaendige Tags erkannt -- vermutlich ein '>' in einem Attributwert oder "
            "eine abgeschnittene Datei. Kein stilles Gruen.")
    endif()
    set(_names "")
    foreach(_tag IN LISTS _tags)
        if(NOT _tag MATCHES "ref=\"([^\"]+)\"")
            message(FATAL_ERROR "golden_n_consistency_check: MASTER '${_file}': <axis> ohne ref-Attribut.")
        endif()
        set(_ref "${CMAKE_MATCH_1}")
        if(NOT _tag MATCHES "allowed_variants=\"([^\"]*)\"")
            message(FATAL_ERROR
                "golden_n_consistency_check: MASTER '${_file}': Achse '${_ref}' traegt KEINE "
                "allowed_variants. Eine ungenannte/ungepinnte Achse expandiert zur VOLLEN "
                "Registry-Liste und hebt das deklarierte N auf.")
        endif()
        string(REGEX REPLACE "[ \t\r\n]+" ";" _vals "${CMAKE_MATCH_1}")
        list(REMOVE_ITEM _vals "")
        list(SORT _vals)
        list(APPEND _names "${_ref}")
        set(${_vals_prefix}_${_ref} "${_vals}" PARENT_SCOPE)
    endforeach()
    list(SORT _names)
    set(${_names_var} "${_names}" PARENT_SCOPE)
endfunction()

# -- Achsen des comdare_thesis_profile-Dialekts: <axis ref=".."><value>..</value>..</axis> in permute_axes.
function(comdare_n_axes_thesis _file _txt _names_var _vals_prefix)
    if(NOT _txt MATCHES "<permute_axes>(.*)</permute_axes>")
        message(FATAL_ERROR
            "golden_n_consistency_check: PROFILE '${_file}': kein <permute_axes>-Block gefunden "
            "(fehlend oder abgeschnitten).")
    endif()
    set(_block "${CMAKE_MATCH_1}")
    set(_names "")
    # Zeichenweise ueber die </axis>-Grenzen laufen statt zeilenweise: ein <axis>-Element darf sich
    # ueber mehrere Zeilen erstrecken, und der Chunk-Inhalt darf ';' enthalten (das eine CMake-Liste
    # zerrissen haette).
    set(_rest "${_block}")
    while(TRUE)
        string(FIND "${_rest}" "</axis>" _end)
        if(_end EQUAL -1)
            break()
        endif()
        string(SUBSTRING "${_rest}" 0 ${_end} _chunk)
        math(EXPR _next "${_end} + 7")
        string(SUBSTRING "${_rest}" ${_next} -1 _rest)
        if(NOT _chunk MATCHES "<axis ref=\"([^\"]+)\">")
            continue()
        endif()
        set(_cur "${CMAKE_MATCH_1}")
        set(_curvals "")
        string(REGEX MATCHALL "<value>[^<]*</value>" _vm "${_chunk}")
        foreach(_v IN LISTS _vm)
            string(REGEX REPLACE "^<value>(.*)</value>$" "\\1" _vv "${_v}")
            string(STRIP "${_vv}" _vv)
            list(APPEND _curvals "${_vv}")
        endforeach()
        if(NOT _curvals)
            message(FATAL_ERROR
                "golden_n_consistency_check: PROFILE '${_file}': Achse '${_cur}' hat KEINEN <value> "
                "(leere Liste expandierte zur vollen Registry).")
        endif()
        list(SORT _curvals)
        list(APPEND _names "${_cur}")
        set(${_vals_prefix}_${_cur} "${_curvals}" PARENT_SCOPE)
    endwhile()
    list(SORT _names)
    set(${_names_var} "${_names}" PARENT_SCOPE)
endfunction()

comdare_n_read("MASTER"  "${MASTER}"  _m_txt)
comdare_n_read("PROFILE" "${PROFILE}" _p_txt)

comdare_n_cap("MASTER"  "${MASTER}"  "${_m_txt}" _m_cap)
comdare_n_cap("PROFILE" "${PROFILE}" "${_p_txt}" _p_cap)

comdare_n_axes_experiment("${MASTER}"  "${_m_txt}" _m_names M)
comdare_n_axes_thesis("${PROFILE}" "${_p_txt}" _p_names P)

list(LENGTH _m_names _m_n)
list(LENGTH _p_names _p_n)
if(_m_n EQUAL 0 OR _p_n EQUAL 0)
    message(FATAL_ERROR
        "golden_n_consistency_check: Achsen-Extraktion leer (MASTER=${_m_n}, PROFILE=${_p_n}) -- "
        "eine leere Menge waere trivial deckungsgleich. Extraktion kaputt, NICHT still gruen.")
endif()

# (1) Achsen-Mengen deckungsgleich.
set(_only_master "")
foreach(_a IN LISTS _m_names)
    if(NOT "${_a}" IN_LIST _p_names)
        list(APPEND _only_master "${_a}")
    endif()
endforeach()
set(_only_profile "")
foreach(_a IN LISTS _p_names)
    if(NOT "${_a}" IN_LIST _m_names)
        list(APPEND _only_profile "${_a}")
    endif()
endforeach()
if(_only_master OR _only_profile)
    message(FATAL_ERROR
        "golden_n_consistency_check: ACHSEN-DRIFT zwischen den zwei golden-Traegern.\n"
        "  MASTER : ${MASTER}\n"
        "  PROFILE: ${PROFILE}\n"
        "  nur im MASTER : ${_only_master}\n"
        "  nur im PROFILE: ${_only_profile}\n"
        "Beide Traeger muessen denselben Achsen-Satz nennen, sonst beschreiben sie zwei "
        "verschiedene golden-Raeume.")
endif()

# (2)+(3) je Achse dieselbe Auspraegungs-Menge; Produkte mitrechnen.
set(_m_prod 1)
set(_p_prod 1)
set(_val_drift "")
foreach(_a IN LISTS _m_names)
    set(_mv "${M_${_a}}")
    set(_pv "${P_${_a}}")
    if(NOT "${_mv}" STREQUAL "${_pv}")
        list(APPEND _val_drift "${_a}: MASTER={${_mv}} PROFILE={${_pv}}")
    endif()
    list(LENGTH _mv _mc)
    list(LENGTH _pv _pc)
    if(_mc EQUAL 0 OR _pc EQUAL 0)
        message(FATAL_ERROR
            "golden_n_consistency_check: Achse '${_a}' hat auf einer Seite NULL Auspraegungen "
            "(MASTER=${_mc}, PROFILE=${_pc}). Eine leere Liste expandiert zur vollen Registry.")
    endif()
    math(EXPR _m_prod "${_m_prod} * ${_mc}")
    math(EXPR _p_prod "${_p_prod} * ${_pc}")
endforeach()
if(_val_drift)
    string(REPLACE ";" "\n    " _drifttxt "${_val_drift}")
    message(FATAL_ERROR
        "golden_n_consistency_check: AUSPRAEGUNGS-DRIFT zwischen den zwei golden-Traegern.\n"
        "  MASTER : ${MASTER}\n"
        "  PROFILE: ${PROFILE}\n"
        "  ABWEICHEND:\n    ${_drifttxt}\n"
        "Die zwei Traeger muessen je Achse dieselben Bausteine nennen -- sonst ist das gemeinsame "
        "N eine Behauptung ohne Deckung.")
endif()

# (4) Produkte und caps gegeneinander.
if(NOT _m_prod EQUAL _p_prod)
    message(FATAL_ERROR
        "golden_n_consistency_check: N-PRODUKT ungleich (MASTER=${_m_prod}, PROFILE=${_p_prod}).")
endif()
if(NOT _m_cap EQUAL _p_cap)
    message(FATAL_ERROR
        "golden_n_consistency_check: cap ungleich (MASTER run_options cap=${_m_cap}, "
        "PROFILE run_options cap=${_p_cap}). Beide Traeger muessen dasselbe N beziffern.")
endif()
if(NOT _m_cap EQUAL _m_prod)
    message(FATAL_ERROR
        "golden_n_consistency_check: das bezifferte N deckt sich NICHT mit den Achsen. "
        "run_options cap=${_m_cap}, aber das Produkt der ${_m_n} Achsen-Auspraegungen ist ${_m_prod}. "
        "Ein cap, den die Achsen nicht hergeben, ist eine willkuerliche Kappung, keine Kartesik.")
endif()

message(STATUS "golden_n_consistency_check: OK -- ${_m_n} Achsen deckungsgleich, "
               "Produkt = ${_m_prod} = run_options cap beider Traeger (golden N = 2^17).")
