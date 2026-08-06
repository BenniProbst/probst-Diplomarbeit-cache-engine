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
# WAS SICH GEGENUEBER DER NB2-FASSUNG GEAENDERT HAT (B14-NB3, Codex-Verdikt BLOCKER): die Vorfassung las
# beide Traeger mit CMake-Regex und zwei Text-Strippern. Am Objekt reproduziert (Gate-Log
# nb3-biss-beweise.txt) lief sie GRUEN, obwohl der MASTER eine dritte Achse trug, wenn diese
#   * hinter einem '<![CDATA[' im TEXT eines gueltigen Kommentars stand,
#   * zwischen einem '<!--' in einer und einem '-->' in einer zweiten Processing-Instruction stand,
#   * oder von einer Entity in den Baum gestellt wurde.
# Ausserdem zerriss ein ';' im Tag (z.B. aus einer Entity-Referenz) die CMake-Listenarithmetik der
# Tag-Zaehlung. Geheilt ist das NICHT durch weitere Regex-Pflaster, sondern durch den Wegfall des
# Selbstbau-Parsers: gelesen wird ueber xmllint, gefragt wird per XPath (s. xml_canonical_utils.cmake).
# Die Wohlgeformtheit beider Traeger ist damit selbst Teil der Aussage; --noent erzwingt die
# Entity-Expansion, so dass zwei gleich geschriebene, aber verschieden DEFINIERTE Entities nicht mehr
# faelschlich als derselbe Wert gelten. Preis: xmllint ist Pflicht (Begruendung dort).
#
# OFFENE ce-AUFLAGE (B14-NB3, am Objekt festgestellt): all_axes_golden.profile.xml ist derzeit KEIN
# wohlgeformtes XML -- in drei Kommentaren steht ein '--', was XML verbietet (libxml2 lehnt die Datei
# komplett ab; Fundstellen zum Zeitpunkt der Feststellung: Zeilen 62, 64 und 207). Der Defekt liegt
# AUSSCHLIESSLICH im Kommentar-TEXT: kommentarfrei parst die Datei einwandfrei (nachgewiesen). Weil die
# Datei dem ce-Submodul gehoert und in diesem Fenster unter der Ein-Schreiber-Regel steht, wird sie hier
# NICHT angefasst; die add_test-Zeile schaltet stattdessen fuer GENAU DIESEN Traeger den Kommentar-Text-
# Ausnahmeweg frei. Der ist in beide Richtungen verriegelt und zieht sich selbst zurueck: sobald die
# ce-Datei roh wohlgeformt ist, wird die Freischaltung FATAL und muss entfernt werden.
#
# SKIP-DISZIPLIN (identisch zu fixture_schema_subset_check.cmake): MASTER liegt im super-Repo selbst ->
# fehlt er, ist das FATAL. PROFILE liegt im ce-Submodul -> fehlt der Nachbar-Checkout, wird sauber
# GESKIPPT (Marker FIXTURE-SYNC-SKIP, damit dieselbe SKIP_REGULAR_EXPRESSION greift).

include("${CMAKE_CURRENT_LIST_DIR}/xml_canonical_utils.cmake")

set(_ctx "golden_n_consistency_check")

foreach(_req MASTER PROFILE)
    if(NOT DEFINED ${_req})
        message(FATAL_ERROR "${_ctx}: -D${_req} fehlt.")
    endif()
endforeach()

if(NOT EXISTS "${MASTER}")
    message(FATAL_ERROR
        "${_ctx}: MASTER '${MASTER}' EXISTIERT NICHT. Der kanonische Traeger liegt im "
        "super-Repo selbst (Code/test_data_xml/) -- kein Nachbar-Checkout, also kein SKIP.")
endif()
if(NOT EXISTS "${PROFILE}")
    message(STATUS "FIXTURE-SYNC-SKIP: Nachbar-Checkout fehlt (PROFILE='${PROFILE}').")
    return()
endif()

if(NOT DEFINED PROFILE_ALLOW_COMMENT_TEXT_DEFECT)
    set(PROFILE_ALLOW_COMMENT_TEXT_DEFECT FALSE)
endif()

# -- cap aus <run_options cap=".."/> ziehen. Fehlt der Block oder das Attribut, ist das FATAL: genau
#    dieses Fehlen war der Befund. Mehr als EIN run_options-Block ist ebenfalls FATAL -- sonst
#    entschiede die Dokumentreihenfolge stillschweigend, welches N gilt.
function(comdare_n_cap _ctx _label _file _doc _out_var)
    comdare_xml_count("${_ctx}" "${_label}" "${_doc}" "//run_options" _n_ro)
    if(NOT _n_ro EQUAL 1)
        message(FATAL_ERROR
            "${_ctx}: ${_label} '${_file}' hat ${_n_ro} <run_options>-Bloecke, erwartet ist genau "
            "EINER. Bei 0 traegt die Datei KEIN maschinenlesbares N -- genau das war der Codex-Befund "
            "HOCH, ein Kommentar ist keine Bauanleitung. Bei mehr als einem entschiede die "
            "Dokumentreihenfolge, welches N gilt.")
    endif()
    comdare_xml_count("${_ctx}" "${_label}" "${_doc}" "//run_options/@cap" _n_cap)
    if(NOT _n_cap EQUAL 1)
        message(FATAL_ERROR
            "${_ctx}: ${_label} '${_file}': <run_options> traegt kein cap-Attribut. Wer den Block "
            "schreibt, MUSS N beziffern.")
    endif()
    comdare_xml_string("${_ctx}" "${_label}" "${_doc}" "//run_options/@cap" _cap)
    if(NOT _cap MATCHES "^[0-9]+$")
        message(FATAL_ERROR
            "${_ctx}: ${_label} '${_file}': run_options cap='${_cap}' ist nicht numerisch.")
    endif()
    set(${_out_var} "${_cap}" PARENT_SCOPE)
endfunction()

# -- Achsen des comdare_experiment-Dialekts: <axis ref=".." ... allowed_variants=".."/>.
#    Jede genannte Achse MUSS allowed_variants tragen; eine ungepinnte Achse expandiert zur vollen
#    Registry-Liste und zerstoert damit das deklarierte N.
function(comdare_n_axes_experiment _ctx _file _doc _names_var _vals_prefix)
    comdare_xml_count("${_ctx}" "MASTER" "${_doc}" "//axis" _n_all)
    comdare_xml_count("${_ctx}" "MASTER" "${_doc}" "//axes_default_lookup/axis" _n_in)
    if(NOT _n_all EQUAL _n_in)
        message(FATAL_ERROR
            "${_ctx}: MASTER '${_file}': ${_n_all} <axis>-Elemente insgesamt, aber nur ${_n_in} "
            "davon unter <axes_default_lookup>. Eine Achse ausserhalb des Lookup-Blocks wuerde von "
            "dieser Wache verglichen, vom Planer aber nicht gelesen (oder umgekehrt).")
    endif()
    if(_n_all EQUAL 0)
        message(FATAL_ERROR "${_ctx}: MASTER '${_file}': keine einzige <axis> gefunden.")
    endif()
    set(_names "")
    foreach(_i RANGE 1 ${_n_all})
        comdare_xml_count("${_ctx}" "MASTER" "${_doc}" "(//axis)[${_i}]/@ref" _has_ref)
        if(NOT _has_ref EQUAL 1)
            message(FATAL_ERROR "${_ctx}: MASTER '${_file}': ${_i}. <axis> ohne ref-Attribut.")
        endif()
        comdare_xml_string("${_ctx}" "MASTER" "${_doc}" "(//axis)[${_i}]/@ref" _ref)
        comdare_xml_count("${_ctx}" "MASTER" "${_doc}" "(//axis)[${_i}]/@allowed_variants" _has_av)
        if(NOT _has_av EQUAL 1)
            message(FATAL_ERROR
                "${_ctx}: MASTER '${_file}': Achse '${_ref}' traegt KEINE "
                "allowed_variants. Eine ungenannte/ungepinnte Achse expandiert zur VOLLEN "
                "Registry-Liste und hebt das deklarierte N auf.")
        endif()
        comdare_xml_string("${_ctx}" "MASTER" "${_doc}" "(//axis)[${_i}]/@allowed_variants" _av)
        string(REGEX REPLACE "[ \t\r\n]+" ";" _vals "${_av}")
        list(REMOVE_ITEM _vals "")
        if(NOT _vals)
            message(FATAL_ERROR
                "${_ctx}: MASTER '${_file}': Achse '${_ref}' hat leere allowed_variants.")
        endif()
        list(SORT _vals)
        list(APPEND _names "${_ref}")
        set(${_vals_prefix}_${_ref} "${_vals}" PARENT_SCOPE)
    endforeach()
    list(SORT _names)
    set(${_names_var} "${_names}" PARENT_SCOPE)
endfunction()

# -- Achsen des comdare_thesis_profile-Dialekts: <axis ref=".."><value>..</value>..</axis> in permute_axes.
function(comdare_n_axes_thesis _ctx _file _doc _names_var _vals_prefix)
    comdare_xml_count("${_ctx}" "PROFILE" "${_doc}" "//permute_axes" _n_blocks)
    if(NOT _n_blocks EQUAL 1)
        message(FATAL_ERROR
            "${_ctx}: PROFILE '${_file}': ${_n_blocks} <permute_axes>-Bloecke, erwartet ist genau "
            "EINER.")
    endif()
    comdare_xml_count("${_ctx}" "PROFILE" "${_doc}" "//axis" _n_all)
    comdare_xml_count("${_ctx}" "PROFILE" "${_doc}" "//permute_axes/axis" _n_in)
    if(NOT _n_all EQUAL _n_in)
        message(FATAL_ERROR
            "${_ctx}: PROFILE '${_file}': ${_n_all} <axis>-Elemente insgesamt, aber nur ${_n_in} "
            "davon unter <permute_axes>. Eine Achse ausserhalb des Permutations-Blocks bliebe von "
            "dieser Wache unbemerkt.")
    endif()
    if(_n_all EQUAL 0)
        message(FATAL_ERROR "${_ctx}: PROFILE '${_file}': keine einzige <axis> gefunden.")
    endif()
    set(_names "")
    foreach(_i RANGE 1 ${_n_all})
        comdare_xml_count("${_ctx}" "PROFILE" "${_doc}" "(//permute_axes/axis)[${_i}]/@ref" _has_ref)
        if(NOT _has_ref EQUAL 1)
            message(FATAL_ERROR "${_ctx}: PROFILE '${_file}': ${_i}. <axis> ohne ref-Attribut.")
        endif()
        comdare_xml_string("${_ctx}" "PROFILE" "${_doc}" "(//permute_axes/axis)[${_i}]/@ref" _ref)
        comdare_xml_count("${_ctx}" "PROFILE" "${_doc}" "(//permute_axes/axis)[${_i}]/value" _n_v)
        if(_n_v EQUAL 0)
            message(FATAL_ERROR
                "${_ctx}: PROFILE '${_file}': Achse '${_ref}' hat KEINEN <value> "
                "(leere Liste expandierte zur vollen Registry).")
        endif()
        set(_curvals "")
        foreach(_j RANGE 1 ${_n_v})
            comdare_xml_string("${_ctx}" "PROFILE" "${_doc}"
                "(//permute_axes/axis)[${_i}]/value[${_j}]" _vv)
            string(STRIP "${_vv}" _vv)
            list(APPEND _curvals "${_vv}")
        endforeach()
        list(SORT _curvals)
        list(APPEND _names "${_ref}")
        set(${_vals_prefix}_${_ref} "${_curvals}" PARENT_SCOPE)
    endforeach()
    list(SORT _names)
    set(${_names_var} "${_names}" PARENT_SCOPE)
endfunction()

comdare_xml_open("${_ctx}" "MASTER"  "${MASTER}"  FALSE _m_doc)
comdare_xml_open("${_ctx}" "PROFILE" "${PROFILE}" "${PROFILE_ALLOW_COMMENT_TEXT_DEFECT}" _p_doc)

comdare_n_cap("${_ctx}" "MASTER"  "${MASTER}"  "${_m_doc}" _m_cap)
comdare_n_cap("${_ctx}" "PROFILE" "${PROFILE}" "${_p_doc}" _p_cap)

comdare_n_axes_experiment("${_ctx}" "${MASTER}"  "${_m_doc}" _m_names M)
comdare_n_axes_thesis("${_ctx}"     "${PROFILE}" "${_p_doc}" _p_names P)

comdare_xml_close("${_m_doc}" "${MASTER}")
comdare_xml_close("${_p_doc}" "${PROFILE}")

list(LENGTH _m_names _m_n)
list(LENGTH _p_names _p_n)
if(_m_n EQUAL 0 OR _p_n EQUAL 0)
    message(FATAL_ERROR
        "${_ctx}: Achsen-Extraktion leer (MASTER=${_m_n}, PROFILE=${_p_n}) -- "
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
        "${_ctx}: ACHSEN-DRIFT zwischen den zwei golden-Traegern.\n"
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
            "${_ctx}: Achse '${_a}' hat auf einer Seite NULL Auspraegungen "
            "(MASTER=${_mc}, PROFILE=${_pc}). Eine leere Liste expandiert zur vollen Registry.")
    endif()
    math(EXPR _m_prod "${_m_prod} * ${_mc}")
    math(EXPR _p_prod "${_p_prod} * ${_pc}")
endforeach()
if(_val_drift)
    string(REPLACE ";" "\n    " _drifttxt "${_val_drift}")
    message(FATAL_ERROR
        "${_ctx}: AUSPRAEGUNGS-DRIFT zwischen den zwei golden-Traegern.\n"
        "  MASTER : ${MASTER}\n"
        "  PROFILE: ${PROFILE}\n"
        "  ABWEICHEND:\n    ${_drifttxt}\n"
        "Die zwei Traeger muessen je Achse dieselben Bausteine nennen -- sonst ist das gemeinsame "
        "N eine Behauptung ohne Deckung.")
endif()

# (4) Produkte und caps gegeneinander.
if(NOT _m_prod EQUAL _p_prod)
    message(FATAL_ERROR
        "${_ctx}: N-PRODUKT ungleich (MASTER=${_m_prod}, PROFILE=${_p_prod}).")
endif()
if(NOT _m_cap EQUAL _p_cap)
    message(FATAL_ERROR
        "${_ctx}: cap ungleich (MASTER run_options cap=${_m_cap}, "
        "PROFILE run_options cap=${_p_cap}). Beide Traeger muessen dasselbe N beziffern.")
endif()
if(NOT _m_cap EQUAL _m_prod)
    message(FATAL_ERROR
        "${_ctx}: das bezifferte N deckt sich NICHT mit den Achsen. "
        "run_options cap=${_m_cap}, aber das Produkt der ${_m_n} Achsen-Auspraegungen ist ${_m_prod}. "
        "Ein cap, den die Achsen nicht hergeben, ist eine willkuerliche Kappung, keine Kartesik.")
endif()

message(STATUS "${_ctx}: OK -- ${_m_n} Achsen deckungsgleich, "
               "Produkt = ${_m_prod} = run_options cap beider Traeger (golden N = 2^17).")
