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

# B14-NB4 / Befund B8: die Werkzeug-Pruefung steht VOR jedem Skip. Vorher lag der Nachbar-Skip davor --
# fehlten Submoduldatei UND xmllint gleichzeitig, wurde trotz der ausdruecklichen "xmllint ist PFLICHT,
# sein Fehlen ist FATAL"-Zusage still geskippt. Genau die Konstellation ist auf einem frisch
# aufgesetzten Runner die WAHRSCHEINLICHE: beides fehlt zusammen. Die Wache haette sich dort selbst
# abgeschaltet und dabei gemeldet, sie sei nur uebersprungen worden.
comdare_xml_require_tool("${_ctx}")

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
    # B14-NB4 / Befund B4: der Grund steht in der EINEN Zeile davor (mit Pfad), der MARKER in einer
    # eigenen, vollstaendig interpolationsfreien Zeile darunter. Nur die Marker-Zeile wird von der
    # ctest-Property gematcht -- so kann kein Pfad und keine Werkzeug-Ausgabe den Marker in eine
    # FATAL-Meldung hineintragen.
    message(STATUS "Nachbar-Checkout fehlt (PROFILE='${PROFILE}') -- diese Wache kann nichts aussagen.")
    message(STATUS "COMDARE-XML-WACHE-SKIP")
    return()
endif()

if(NOT DEFINED PROFILE_ALLOW_COMMENT_TEXT_DEFECT)
    set(PROFILE_ALLOW_COMMENT_TEXT_DEFECT FALSE)
endif()

# -- cap aus <run_options cap=".."/> ziehen. Fehlt der Block oder das Attribut, ist das FATAL: genau
#    dieses Fehlen war der Befund. Mehr als EIN run_options-Block ist ebenfalls FATAL -- sonst
#    entschiede die Dokumentreihenfolge stillschweigend, welches N gilt.
function(comdare_n_cap _ctx _label _file _doc _root _out_var)
    # B14-NB4 / Befund B2: an die Wurzel gebunden. Der Parser liest run_options als DIREKTES
    # Wurzelkind; '//run_options' haette einen Block auch dann gefunden, wenn er unter einem
    # zusaetzlichen Wrapper haengt -- wo ihn niemand liest.
    comdare_xml_count("${_ctx}" "${_label}" "${_doc}" "/${_root}/run_options" _n_ro)
    if(NOT _n_ro EQUAL 1)
        message(FATAL_ERROR
            "${_ctx}: ${_label} '${_file}' hat ${_n_ro} <run_options>-Bloecke, erwartet ist genau "
            "EINER. Bei 0 traegt die Datei KEIN maschinenlesbares N -- genau das war der Codex-Befund "
            "HOCH, ein Kommentar ist keine Bauanleitung. Bei mehr als einem entschiede die "
            "Dokumentreihenfolge, welches N gilt.")
    endif()
    comdare_xml_count("${_ctx}" "${_label}" "${_doc}" "/${_root}/run_options/@cap" _n_cap)
    if(NOT _n_cap EQUAL 1)
        message(FATAL_ERROR
            "${_ctx}: ${_label} '${_file}': <run_options> traegt kein cap-Attribut. Wer den Block "
            "schreibt, MUSS N beziffern.")
    endif()
    comdare_xml_string("${_ctx}" "${_label}" "${_doc}" "/${_root}/run_options/@cap" _cap)
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
    # B14-NB4 / Befund B2: VERANKERT an der Dokumentwurzel. Vorher standen hier unverankerte
    # '//'-Suchen. Eine falsche Wurzel oder ein zusaetzlicher Wrapper-Knoten waere damit gruen
    # geblieben, obwohl der reale Parser (xml_config_parser.cpp: root->child("axes_default_lookup"))
    # ausschliesslich das DIREKTE Wurzelkind liest -- die Wache haette eine Struktur bestaetigt, die
    # der Planer gar nicht sieht. Der Pfad unten ist der, den der Parser geht.
    comdare_xml_count("${_ctx}" "MASTER" "${_doc}" "/comdare_experiment" _n_root)
    if(NOT _n_root EQUAL 1)
        message(FATAL_ERROR
            "${_ctx}: MASTER '${_file}': die Dokumentwurzel ist nicht <comdare_experiment> "
            "(gefunden: ${_n_root} an der Wurzel). Der Parser liest seine Bloecke als DIREKTE Kinder "
            "dieser Wurzel; unter einer anderen Wurzel liest er GAR NICHTS -- eine Wache, die sie "
            "per '//' trotzdem faende, bestaetigte einen Baum, den niemand verarbeitet.")
    endif()
    comdare_xml_count("${_ctx}" "MASTER" "${_doc}" "//axis" _n_all)
    comdare_xml_count("${_ctx}" "MASTER" "${_doc}" "/comdare_experiment/axes_default_lookup/axis" _n_in)
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
    set(_axpath "/comdare_experiment/axes_default_lookup/axis")
    foreach(_i RANGE 1 ${_n_all})
        comdare_xml_count("${_ctx}" "MASTER" "${_doc}" "(${_axpath})[${_i}]/@ref" _has_ref)
        if(NOT _has_ref EQUAL 1)
            message(FATAL_ERROR "${_ctx}: MASTER '${_file}': ${_i}. <axis> ohne ref-Attribut.")
        endif()
        comdare_xml_string("${_ctx}" "MASTER" "${_doc}" "(${_axpath})[${_i}]/@ref" _ref)
        comdare_xml_count("${_ctx}" "MASTER" "${_doc}" "(${_axpath})[${_i}]/@allowed_variants" _has_av)
        if(NOT _has_av EQUAL 1)
            message(FATAL_ERROR
                "${_ctx}: MASTER '${_file}': Achse '${_ref}' traegt KEINE "
                "allowed_variants. Eine ungenannte/ungepinnte Achse expandiert zur VOLLEN "
                "Registry-Liste und hebt das deklarierte N auf.")
        endif()
        comdare_xml_string("${_ctx}" "MASTER" "${_doc}" "(${_axpath})[${_i}]/@allowed_variants" _av)
        string(REGEX REPLACE "[ \t\r\n]+" ";" _vals "${_av}")
        list(REMOVE_ITEM _vals "")
        if(NOT _vals)
            message(FATAL_ERROR
                "${_ctx}: MASTER '${_file}': Achse '${_ref}' hat leere allowed_variants.")
        endif()
        list(SORT _vals)
        # B14-NB4 / Befund B5: DUPLIKATE werden abgelehnt, nicht ueberschrieben. Vorher schrieb ein
        # zweiter Eintrag mit demselben ref stillschweigend dieselbe Variable neu, und der
        # Mengen-Vergleich unten (IN_LIST) ist blind fuer Vielfachheit. Ein Duplikat mit EINER
        # Auspraegung veraenderte das Produkt nicht -> alles gruen, obwohl der Traeger eine Achse
        # doppelt deklariert.
        if("${_ref}" IN_LIST _names)
            message(FATAL_ERROR
                "${_ctx}: MASTER '${_file}': die Achse '${_ref}' ist MEHRFACH deklariert. Welcher "
                "Eintrag gilt, entschiede die Dokumentreihenfolge; diese Wache verglich bisher nur "
                "MENGEN und haette das Duplikat nicht gesehen.")
        endif()
        # B14-NB4 / Befund B6 (dialekt-differenziert, am Objekt geprueft): im comdare_experiment-
        # Dialekt ist axis@active heute NICHT raum-wirksam -- die XSD sagt es ausdruecklich ("der
        # Parser LIEST es ... aber NIEMAND wertet es aus"), und am Objekt bestaetigt: der Wert landet
        # nur in ResolverReport::declared_inactive (validate_profile.hpp:884), kein Bau-Pfad liest ihn.
        # Die Achse hier stillschweigend HERAUSZURECHNEN waere deshalb falsch -- sie steht im gebauten
        # Raum. Aber die Wache kann auch nicht so tun, als gaebe es das Attribut nicht: sobald ein
        # Verbraucher es scharfschaltet (die XSD verortet ihn im Lane-F-Fenster), veraendert es die
        # Kardinalitaet und dieses Produkt waere still falsch. Also STOLPERDRAHT statt Annahme.
        comdare_xml_count("${_ctx}" "MASTER" "${_doc}" "(${_axpath})[${_i}]/@active" _has_active)
        if(NOT _has_active EQUAL 0)
            message(FATAL_ERROR
                "${_ctx}: MASTER '${_file}': Achse '${_ref}' traegt ein active-Attribut. Diese Wache "
                "rechnet das Produkt ueber ALLE deklarierten Achsen -- richtig genau so lange, wie "
                "active im comdare_experiment-Dialekt wirkungslos ist (heute: ja, s. XSD und "
                "validate_profile). Wer den Verbraucher scharfschaltet, muss DIESE Stelle mitziehen; "
                "bis dahin verweigert die Wache die Aussage, statt ein Produkt zu behaupten, das den "
                "gebauten Raum vielleicht nicht mehr trifft.")
        endif()
        list(APPEND _names "${_ref}")
        set(${_vals_prefix}_${_ref} "${_vals}" PARENT_SCOPE)
    endforeach()
    list(SORT _names)
    set(${_names_var} "${_names}" PARENT_SCOPE)
endfunction()

# -- Achsen des comdare_thesis_profile-Dialekts: <axis ref=".."><value>..</value>..</axis> in permute_axes.
function(comdare_n_axes_thesis _ctx _file _doc _names_var _vals_prefix)
    # B14-NB4 / Befund B2: verankert (s. comdare_n_axes_experiment).
    comdare_xml_count("${_ctx}" "PROFILE" "${_doc}" "/comdare_thesis_profile" _n_root)
    if(NOT _n_root EQUAL 1)
        message(FATAL_ERROR
            "${_ctx}: PROFILE '${_file}': die Dokumentwurzel ist nicht <comdare_thesis_profile>. "
            "Der Parser liest permute_axes/run_options/modes als DIREKTE Wurzelkinder.")
    endif()
    comdare_xml_count("${_ctx}" "PROFILE" "${_doc}" "/comdare_thesis_profile/permute_axes" _n_blocks)
    if(NOT _n_blocks EQUAL 1)
        message(FATAL_ERROR
            "${_ctx}: PROFILE '${_file}': ${_n_blocks} <permute_axes>-Bloecke, erwartet ist genau "
            "EINER.")
    endif()
    # -- B14-NB4 / Befund B6: DER MODUS-FILTER. Er ist im thesis_profile-Dialekt WIRKSAM, und das ist
    #    am Objekt geprueft, nicht angenommen: profile_to_tree.hpp bildet
    #       is_active(ref) := (kein Modus) ? true : ref in mode.active_axes
    #    und ueberspringt jede nicht freigegebene Achse VOR der Ebenenbildung ("if (!is_active(...)) continue;").
    #    Eine Achse, die permute_axes deklariert und der Modus nicht freigibt, erzeugt also KEINE Ebene
    #    und kein binary_id-Segment -- sie steht im Produkt dieser Wache, aber NICHT im gebauten Raum.
    #    Diese Wache kann nicht wissen, mit welchem Modus ein Lauf startet. Sie verlangt deshalb, dass
    #    JEDER deklarierte Modus GENAU die deklarierten Achsen freigibt; dann ist die Aussage
    #    modus-unabhaengig wahr. Alles andere waere ein Produkt ueber einen Raum, den so vielleicht
    #    niemand baut.
    comdare_xml_count("${_ctx}" "PROFILE" "${_doc}" "/comdare_thesis_profile/modes/mode" _n_modes)
    comdare_xml_count("${_ctx}" "PROFILE" "${_doc}" "//mode" _n_modes_any)
    if(NOT _n_modes EQUAL _n_modes_any)
        message(FATAL_ERROR
            "${_ctx}: PROFILE '${_file}': ${_n_modes_any} <mode>-Elemente insgesamt, aber nur "
            "${_n_modes} unter /comdare_thesis_profile/modes. Ein Modus ausserhalb wird vom Parser "
            "nicht gelesen.")
    endif()
    comdare_xml_count("${_ctx}" "PROFILE" "${_doc}" "/comdare_thesis_profile/axis" _n_axis_all)
    comdare_xml_count("${_ctx}" "PROFILE" "${_doc}" "//axis" _n_all)
    comdare_xml_count("${_ctx}" "PROFILE" "${_doc}" "/comdare_thesis_profile/permute_axes/axis" _n_in)
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
    set(_axpath "/comdare_thesis_profile/permute_axes/axis")
    foreach(_i RANGE 1 ${_n_all})
        comdare_xml_count("${_ctx}" "PROFILE" "${_doc}" "(${_axpath})[${_i}]/@ref" _has_ref)
        if(NOT _has_ref EQUAL 1)
            message(FATAL_ERROR "${_ctx}: PROFILE '${_file}': ${_i}. <axis> ohne ref-Attribut.")
        endif()
        comdare_xml_string("${_ctx}" "PROFILE" "${_doc}" "(${_axpath})[${_i}]/@ref" _ref)
        comdare_xml_count("${_ctx}" "PROFILE" "${_doc}" "(${_axpath})[${_i}]/value" _n_v)
        if(_n_v EQUAL 0)
            message(FATAL_ERROR
                "${_ctx}: PROFILE '${_file}': Achse '${_ref}' hat KEINEN <value> "
                "(leere Liste expandierte zur vollen Registry).")
        endif()
        set(_curvals "")
        foreach(_j RANGE 1 ${_n_v})
            comdare_xml_string("${_ctx}" "PROFILE" "${_doc}"
                "(${_axpath})[${_i}]/value[${_j}]" _vv)
            string(STRIP "${_vv}" _vv)
            list(APPEND _curvals "${_vv}")
        endforeach()
        list(SORT _curvals)
        # B14-NB4 / Befund B5: Duplikate ablehnen (Begruendung s. MASTER-Zweig). Im PROFILE ist der
        # Fall SCHAERFER: das Produkt unten laeuft ueber die MASTER-Namensliste, ein PROFILE-Duplikat
        # veraenderte es also selbst dann nicht, wenn die Achse mehrere Auspraegungen traegt.
        if("${_ref}" IN_LIST _names)
            message(FATAL_ERROR
                "${_ctx}: PROFILE '${_file}': die Achse '${_ref}' ist MEHRFACH unter <permute_axes> "
                "deklariert. Der Bau-Pfad erzeugt je Eintrag eine Ebene -- das waere eine zusaetzliche "
                "Achsenebene, die weder der Mengenvergleich (IN_LIST) noch das Produkt gesehen haette.")
        endif()
        # B14-NB4 / Befund B6, zweite Haelfte: axis@active ist HIER WIRKSAM (anders als im
        # comdare_experiment-Dialekt). Am Objekt: profile_to_tree.hpp fuehrt unmittelbar nach dem
        # Modus-Filter ein "if (!ax.active) continue;" -- benannt als "DER VERBRAUCHER der expliziten
        # Abwahl". Eine abgewaehlte Achse erzeugt keine Ebene und kein binary_id-Segment. Sie im
        # Produkt mitzuzaehlen waere also ein Raum, den niemand baut. Heute traegt kein Profil das
        # Attribut (der Bau-Kommentar nennt 0 Treffer ueber beide Baeume); die Wache verweigert
        # deshalb die Aussage, statt eine Semantik zu implementieren, die sie nicht gegenpruefen kann.
        comdare_xml_count("${_ctx}" "PROFILE" "${_doc}" "(${_axpath})[${_i}]/@active" _has_active)
        if(NOT _has_active EQUAL 0)
            message(FATAL_ERROR
                "${_ctx}: PROFILE '${_file}': Achse '${_ref}' traegt ein active-Attribut. Im "
                "comdare_thesis_profile-Dialekt ist das WIRKSAM (profile_to_tree.hpp: "
                "'if (!ax.active) continue;') -- eine abgewaehlte Achse faellt aus dem gebauten Raum, "
                "und dieses Produkt traefe ihn nicht mehr. Wer eine Achse abwaehlt, zieht diese Wache "
                "mit; bis dahin: keine Aussage statt einer falschen.")
        endif()
        # ... und der Modus MUSS die Achse freigeben, sonst gilt dasselbe.
        foreach(_mi RANGE 1 ${_n_modes})
            comdare_xml_string("${_ctx}" "PROFILE" "${_doc}"
                "(/comdare_thesis_profile/modes/mode)[${_mi}]/@active_axes" _aa)
            string(REGEX REPLACE "[ \t\r\n]+" ";" _aalist "${_aa}")
            list(REMOVE_ITEM _aalist "")
            if(NOT "${_ref}" IN_LIST _aalist)
                comdare_xml_string("${_ctx}" "PROFILE" "${_doc}"
                    "(/comdare_thesis_profile/modes/mode)[${_mi}]/@name" _mname)
                message(FATAL_ERROR
                    "${_ctx}: PROFILE '${_file}': der Modus '${_mname}' gibt die Achse '${_ref}' NICHT "
                    "frei (active_axes). Der Bau-Pfad ueberspringt sie dann (profile_to_tree.hpp: "
                    "'if (!is_active(ax.ref)) continue;'), das Produkt dieser Wache zaehlt sie aber "
                    "mit -- die Wache prueefte einen ANDEREN Raum als den gebauten. Entweder gibt jeder "
                    "Modus alle deklarierten Achsen frei, oder diese Wache muss modus-genau rechnen.")
            endif()
        endforeach()
        list(APPEND _names "${_ref}")
        set(${_vals_prefix}_${_ref} "${_curvals}" PARENT_SCOPE)
    endforeach()
    list(SORT _names)
    set(${_names_var} "${_names}" PARENT_SCOPE)
endfunction()

comdare_xml_open("${_ctx}" "MASTER"  "${MASTER}"  FALSE _m_doc)
comdare_xml_open("${_ctx}" "PROFILE" "${PROFILE}" "${PROFILE_ALLOW_COMMENT_TEXT_DEFECT}" _p_doc)

comdare_n_cap("${_ctx}" "MASTER"  "${MASTER}"  "${_m_doc}" "comdare_experiment"     _m_cap)
comdare_n_cap("${_ctx}" "PROFILE" "${PROFILE}" "${_p_doc}" "comdare_thesis_profile" _p_cap)

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

# (5) B14-NB4 / Befund B7: DER ABSOLUTE KANON.
#
# Bis hierher prueft die Wache ausschliesslich RELATIV: Produkt == cap(MASTER) == cap(PROFILE). Die
# Erfolgsmeldung schloss trotzdem mit "(golden N = 2^17)" -- eine Zusage, die der Code nicht hielt.
# Beide Traeger koennten GEMEINSAM driften (jemand nimmt in beiden dieselbe Achse heraus): alle vier
# Pruefungen oben blieben gruen, und die Wache meldete weiterhin "2^17", waehrend der Raum 2^16 ist.
# Genau die Klasse "Zusage in der Erfolgsmeldung, die der Code nicht haelt".
#
# GEHEILT WIRD SIE, INDEM DER KANON GEPRUEFT WIRD -- nicht, indem die Meldung entschaerft wird: der
# Owner-Kanon "golden N = 2^17 = 131072" ist eine feste Groesse dieses Pakets und gehoert damit an EINE
# sichtbare Stelle. Sie liegt in der add_test-Zeile (-DEXPECTED_N), nicht hier: das super-Repo ist der
# Eigentuemer des Kanons, dieses Skript nur sein Pruefer. Wer N bewusst aendert, aendert die
# add_test-Zeile -- ein sichtbarer Edit statt eines stillen Mitdriftens.
# FEHLT -DEXPECTED_N, ist das FATAL und kein Weiterlaufen: eine Wache, deren Kanon-Bein man durch
# Weglassen einer Variablen abschalten kann, ist genau der Befund B9 der Nachbar-Wache.
if(NOT DEFINED EXPECTED_N OR "${EXPECTED_N}" STREQUAL "")
    message(FATAL_ERROR
        "${_ctx}: -DEXPECTED_N fehlt. Der absolute golden-Kanon (2^17 = 131072) ist das einzige Bein "
        "dieser Wache, das ein GEMEINSAMES Driften beider Traeger noch faengt. Ohne ihn duerfte die "
        "Erfolgsmeldung 2^17 nicht behaupten.")
endif()
if(NOT EXPECTED_N MATCHES "^[0-9]+$")
    message(FATAL_ERROR "${_ctx}: EXPECTED_N='${EXPECTED_N}' ist nicht numerisch.")
endif()
if(NOT _m_prod EQUAL EXPECTED_N)
    message(FATAL_ERROR
        "${_ctx}: GEMEINSAMES DRIFTEN. Die beiden Traeger sind zwar untereinander deckungsgleich "
        "(${_m_n} Achsen, Produkt ${_m_prod} = cap beider Seiten), aber das ist NICHT der Kanon "
        "${EXPECTED_N}. Genau diesen Fall haben die Pruefungen (1)-(4) per Konstruktion nicht sehen "
        "koennen -- sie vergleichen die Traeger nur miteinander.\n"
        "  MASTER : ${MASTER}\n"
        "  PROFILE: ${PROFILE}\n"
        "Wenn N bewusst geaendert wurde, ist -DEXPECTED_N in Code/tests/CMakeLists.txt mitzuziehen.")
endif()

message(STATUS "${_ctx}: OK -- ${_m_n} Achsen deckungsgleich, Produkt = ${_m_prod} = run_options cap "
               "beider Traeger = Kanon ${EXPECTED_N}. (Alle drei Groessen geprueft, keine behauptet.)")
