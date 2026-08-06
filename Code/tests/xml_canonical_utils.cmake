# xml_canonical_utils.cmake -- B14-NB3 (2026-08-06): die GEMEINSAME XML-Lesebasis der beiden
# ctest-Wachen fixture_schema_subset_check.cmake und golden_n_consistency_check.cmake.
#
# WARUM ES DIESE DATEI GIBT (Codex-Verdikt BLOCKER auf 953ce412: 4x HOCH, 2x MITTEL). Alle
# gemeldeten Loecher der zwei Wachen hatten EINE Wurzel: beide lasen XML mit CMake-Regex und
# Text-Strippern OHNE echten XML-Lexikalzustand. Am Objekt reproduziert (Praeparate und literale
# Laeufe im Gate-Log nb3-biss-beweise.txt) liefen die alten Wachen GRUEN fuer:
#   (1a) ein '<![CDATA[' im TEXT eines voellig gueltigen Kommentars. Der CDATA-Stripper lief per
#        Konstruktion ZUERST, fand dieses Vorkommen und schnitt von dort bis zum naechsten ']]>'
#        alles weg -- inklusive der echten Elemente dazwischen.
#   (1b) ein '<!--' im Inhalt einer Processing-Instruction und ein '-->' im Inhalt einer zweiten.
#        Der Kommentar-Stripper schnitt alles dazwischen weg. Beides ist wohlgeformtes XML.
#   (2)  per Entity erzeugte Elemente. Fuer einen Regex ist '&x;' nur Text; das Element, das die
#        Entity in den Baum stellt, existiert fuer die Wache nicht.
#   (3)  gueltige XML-Namen mit Nicht-ASCII-Startzeichen. Die Namensgrenze war [A-Za-z_]; ein
#        solches Element wurde als "kein Tag" eingestuft und damit uebersprungen.
#   (4)  Fehlverschachtelung, unquotierte und duplizierte Attribute. Der Truncation-Riegel pruefte
#        nur, ob der Wurzelname textuell irgendwo wieder auftaucht.
# Dazu zwei MITTEL: die XSD-Extraktion verstand nur den Praefix 'xs:' mit Doppel-Quotes und
# name= an erster Attributstelle (jede andere, voellig gueltige XSD-Schreibweise = falsch-positiv),
# und der Vergleich war ein globaler Mengenvergleich OHNE Kontext (ein anderswo deklariertes
# Attribut am falschen Element lief gruen durch).
#
# EIN WEITERES REGEX-PFLASTER HAETTE DIE WURZEL NICHT ANGEFASST. Die Heilung ist deshalb der
# ERSATZLOSE WEGFALL DES SELBSTBAU-PARSERS: beide Wachen lesen ihre Dateien ab sofort
# ausschliesslich ueber xmllint (libxml2). Wohlgeformtheit, Entity-Expansion, Namensraeume,
# CDATA, Kommentar- und PI-Grenzen sowie die XML-Namens-Zeichenklassen macht der echte Parser;
# die Wachen stellen nur noch FRAGEN (XPath) und vergleichen die Antworten. Damit fallen 1a, 1b,
# 2, 3, 4 und die XSD-Praefix-/Quote-Frage nicht einzeln, sondern strukturell auf einmal.
#
# DER PREIS, OFFEN BENANNT (Revision einer Aussage der NB2-Fassung): der alte Kopf-Kommentar warb
# damit, die Wache sei "die dependency-freie ctest-Schicht ... kein xmllint-Zwang auf den
# Runnern". Diese Dependency-Freiheit war genau das, was die sechs Befunde bezahlt haben. Sie
# wird hier aufgegeben: xmllint ist PFLICHT, sein Fehlen ist FATAL und wird NICHT geskippt. Ein
# stiller Skip haette die Wache faktisch abgeschaltet und waere derselbe stumm-gruene Ausgang,
# gegen den die NB2-Fassung die SKIP-DISZIPLIN eingefuehrt hat. Paketname zur Nachinstallation:
# Debian/Ubuntu libxml2-utils, RHEL/Fedora/SUSE libxml2, Alpine libxml2-utils, Arch libxml2.
# ACHTUNG BEIM LANDEN: xmllint ist bis heute in KEINEM CI-Job dieses Repos aufgerufen worden
# (Nachweis: grep xmllint ueber .gitlab-ci.yml + ci/ + Code/ = keine Fundstelle ausser den
# Kommentaren dieser Wachen). Die Praesenz auf den baremetal-Runnern ist damit NICHT belegt,
# sondern eine Annahme -- vor dem Scharfschalten in CI ist sie zu pruefen (Infra-Auflage).
#
# WAS DIESE DATEI BEWUSST NICHT TUT: sie parst kein XML. Es gibt hier weder einen Tag-Scanner
# noch eine Namens-Regex. Der einzige verbliebene Text-Lauf ist comdare_xml_lex_strip_comments,
# und der existiert fuer GENAU EINEN, benannten und sich selbst zurueckziehenden Ausnahmefall
# (s. dort und comdare_xml_open).

find_program(COMDARE_XMLLINT_EXE NAMES xmllint)

# -- B14-NB4 (2026-08-06): DER STDERR-RIEGEL. -----------------------------------------------------------
#
# BEFUND B3 (HOCH, am Objekt reproduziert): xmllint meldet einen durch --nonet BLOCKIERTEN externen
# Entity-Load AUSSCHLIESSLICH ueber stderr und beendet sich trotzdem mit RC 0. Literal gefahren:
#   Datei : <!DOCTYPE r [<!ENTITY x SYSTEM "http://example.invalid/gibt.es.nicht">]> <r>&x;</r>
#   Lauf  : xmllint --noout --nonet --noent  ->  RC=0
#   stderr: "I/O error : Attempt to load network entity http://example.invalid/gibt.es.nicht"
#           "warning: failed to load external entity ..."
# Der Baum wird dann OHNE den Entity-Inhalt weitergereicht. Die NB3-Fassung sah nur den RC und haette
# das gruen durchgelaufen -- damit lebte genau die Entity-Omissionsklasse wieder, die der Wegfall des
# Selbstbau-Parsers strukturell erledigt haben sollte (der Defekt eine Ebene weiter).
#
# WARUM KEINE MUSTERLISTE: die naheliegende Fassung waere "stderr gegen 'entity|I/O error' pruefen".
# Das waere dieselbe Klasse, gegen die diese ganze Datei gebaut wurde -- eine Textheuristik ueber der
# Ausgabe eines Werkzeugs, die jede Meldungsvariante uebersieht, die nicht in der Liste steht. Die
# Regel ist deshalb absolut: bei RC 0 MUSS stderr LEER sein. Am Objekt geprueft: eine wohlgeformte
# Datei erzeugt 0 Byte stderr. Alles andere ist eine Aussage von libxml2 ueber das Dokument, und eine
# Wache, die eine Aussage des Parsers wegwirft, ist keine Wache.
function(comdare_xml_assert_clean_stderr _ctx _label _what _file _err)
    if(NOT "${_err}" STREQUAL "")
        message(FATAL_ERROR
            "${_ctx}: ${_what} auf ${_label} '${_file}' meldete RC=0, hat aber auf stderr "
            "geschrieben. Ein Lauf, der sich beschwert und trotzdem 0 zurueckgibt, ist der klassische "
            "FALSE-GREEN dieser Naht: ein per --nonet blockierter externer Entity-Load meldet sich NUR "
            "hier, und der Baum kaeme ohne den Entity-Inhalt weiter. Fail-closed -- kein Gruen auf "
            "einem Dokument, ueber das der Parser etwas zu sagen hatte.\n"
            "  xmllint (stderr):\n${_err}")
    endif()
endfunction()

# -- xmllint-Pflicht. Kein Skip, kein Fallback, keine zweite Code-Bahn.
function(comdare_xml_require_tool _ctx)
    if(NOT COMDARE_XMLLINT_EXE)
        message(FATAL_ERROR
            "${_ctx}: xmllint (libxml2) wurde im PATH NICHT gefunden. Diese Wache liest XML "
            "ausschliesslich ueber einen echten Parser -- ohne ihn kann sie keine Aussage "
            "treffen. Ein Skip waere hier kein 'fehlender Nachbar-Checkout', sondern das stille "
            "Abschalten der Wache. Nachinstallieren: Debian/Ubuntu 'libxml2-utils', "
            "RHEL/Fedora/SUSE 'libxml2', Alpine 'libxml2-utils', Arch 'libxml2'.")
    endif()
endfunction()

# -- Scratch-Verzeichnis fuer den EINEN Ausnahmefall unten. -DSCRATCH_DIR wird von der
#    add_test-Zeile auf das Build-Verzeichnis gesetzt (raeumt sich mit dem Build ab); fuer den
#    Standalone-Lauf 'cmake -P' faellt es auf TMPDIR/TEMP/'/tmp' zurueck. Das Quellverzeichnis
#    wird NIE beschrieben.
function(comdare_xml_scratch_dir _ctx _out_var)
    if(DEFINED SCRATCH_DIR AND NOT SCRATCH_DIR STREQUAL "")
        set(_d "${SCRATCH_DIR}")
    elseif(DEFINED ENV{TMPDIR} AND NOT "$ENV{TMPDIR}" STREQUAL "")
        set(_d "$ENV{TMPDIR}")
    elseif(DEFINED ENV{TEMP} AND NOT "$ENV{TEMP}" STREQUAL "")
        set(_d "$ENV{TEMP}")
    else()
        set(_d "/tmp")
    endif()
    file(MAKE_DIRECTORY "${_d}")
    if(NOT IS_DIRECTORY "${_d}")
        message(FATAL_ERROR "${_ctx}: Scratch-Verzeichnis '${_d}' ist nicht anlegbar.")
    endif()
    set(${_out_var} "${_d}" PARENT_SCOPE)
endfunction()

# -- Ein Lexer-Schritt: vom aktuellen '<' bis einschliesslich _endtok. Erwartet die Variablen
#    _rest/_ctx/_file aus dem Aufrufer (Makro, kein eigener Scope) und setzt _piece/_rest.
macro(comdare_xml_lex_take _endtok _endlen _what)
    string(FIND "${_rest}" "${_endtok}" _lex_e)
    if(_lex_e EQUAL -1)
        message(FATAL_ERROR
            "${_ctx}: unbeendete(s) ${_what} in '${_file}' (kein '${_endtok}'). Die Datei ist "
            "nicht wohlgeformt oder abgeschnitten. Kein stilles Gruen.")
    endif()
    math(EXPR _lex_n "${_lex_e} + ${_endlen}")
    string(SUBSTRING "${_rest}" 0 ${_lex_n} _piece)
    string(SUBSTRING "${_rest}" ${_lex_n} -1 _rest)
endmacro()

# -- B14-NB4: DIE EINE quote-bewusste Tag-Ende-Suche. Erwartet _rest/_ctx/_file, setzt _piece/_rest.
#    _with_bracket_depth=TRUE zusaetzlich fuer das interne DOCTYPE-Subset '[...]'.
#
# BEFUND B1 (HOCH, am Objekt reproduziert). Bis B14-NB4 endete der Element-Zweig am ERSTEN '>'
# (string(FIND)) -- ohne Quote-Zustand. Begruendet war das mit dem Satz "ein Kommentar kann hier nicht
# beginnen, '<' ist im Attributwert kein legales Zeichen". Der Satz ist fuer WOHLGEFORMTES XML richtig
# und fuer die Eingabe dieser Funktion FALSCH: comdare_xml_lex_strip_comments laeuft ausschliesslich auf
# Dateien, die xmllint bereits ABGELEHNT hat. Genau dort darf alles stehen.
#
# DAS PRAEPARAT, mit dem der Fehler literal gefallen ist (Gate-Log nb4-super-biss-beweise.txt):
#     <?xml version="1.0"?>
#     <r>
#       <a v="x> <!-- ">
#       <ORPHAN>
#       <b v=" --> "/>
#     </r>
#   roh      : RC=1, "Unescaped '<' not allowed in attributes values"  <- NICHT der '--'-Defekt
#   gestrippt: RC=0 -- und <ORPHAN> sowie <b/> sind SPURLOS VERSCHWUNDEN.
# Der Ablauf: das erste '>' liegt IM Attributwert, der Lauf schnitt dort, landete mitten im Wert, fand
# dort ein '<!--' und verwarf alles bis zum '-->' im naechsten Attributwert. Der Flag-Pfad haette danach
# "XML-KOMMENTAR-TEXT-DEFEKT" gemeldet (eine Unwahrheit) und auf einem AMPUTIERTEN Baum weitergefragt.
# Das ist derselbe zustandslose Schnitt, den die xmllint-Migration ueberall sonst beseitigt hat -- der
# Ausnahme-Weg hatte ihn behalten.
#
# WARUM SO UND NICHT ANDERS: es entsteht KEINE neue Regex-Insel. Der DOCTYPE-Zweig lief bereits
# quote-bewusst; diese Fassung macht daraus die EINE Funktion, die BEIDE Zweige benutzen. Damit ist die
# Quote-Behandlung nicht mehr an einer Stelle vorhanden und an der anderen vergessen, sondern es gibt
# nur noch einen Ort, an dem sie richtig oder falsch sein kann.
macro(comdare_xml_lex_take_quoted _with_bracket_depth _what)
    string(LENGTH "${_rest}" _q_len)
    set(_q_i 0)
    set(_q_depth 0)
    set(_q_quote "")
    set(_q_end -1)
    while(_q_i LESS _q_len)
        string(SUBSTRING "${_rest}" ${_q_i} 1 _q_c)
        if(NOT _q_quote STREQUAL "")
            if(_q_c STREQUAL "${_q_quote}")
                set(_q_quote "")
            endif()
        elseif(_q_c STREQUAL "\"" OR _q_c STREQUAL "'")
            set(_q_quote "${_q_c}")
        elseif(${_with_bracket_depth} AND _q_c STREQUAL "[")
            math(EXPR _q_depth "${_q_depth} + 1")
        elseif(${_with_bracket_depth} AND _q_c STREQUAL "]")
            math(EXPR _q_depth "${_q_depth} - 1")
        elseif(_q_c STREQUAL ">" AND _q_depth EQUAL 0)
            set(_q_end ${_q_i})
            break()
        endif()
        math(EXPR _q_i "${_q_i} + 1")
    endwhile()
    if(_q_end EQUAL -1)
        message(FATAL_ERROR
            "${_ctx}: unbeendete(s) ${_what} in '${_file}' (kein schliessendes '>' ausserhalb von "
            "Anfuehrungszeichen). Die Datei ist nicht wohlgeformt oder abgeschnitten. Kein stilles Gruen.")
    endif()
    math(EXPR _q_n "${_q_end} + 1")
    string(SUBSTRING "${_rest}" 0 ${_q_n} _piece)
    string(SUBSTRING "${_rest}" ${_q_n} -1 _rest)
endmacro()

# -- comdare_xml_lex_strip_comments: entfernt AUSSCHLIESSLICH Kommentare, alles andere bleibt
#    zeichengleich stehen.
#
#    WOZU UEBERHAUPT NOCH TEXTARBEIT? Fuer genau einen Fall: ein Traeger, der NUR im TEXT seiner
#    Kommentare defekt ist (XML verbietet '--' innerhalb eines Kommentars; libxml2 lehnt die
#    Datei deshalb komplett ab). Kommentar-TEXT ist fuer beide Wachen per Definition bedeutungslos
#    -- sie fragen nach Markup. Statt die Datei ungeprueft zu lassen ODER sie mit --recover
#    halbgar zu parsen (beides waere stumm-gruen), wird der bedeutungslose Teil entfernt und der
#    REST dem echten Parser vorgelegt. Der Aufrufer muss diesen Weg explizit freischalten und
#    bekommt ihn ausserdem entzogen, sobald er nicht mehr noetig ist (s. comdare_xml_open).
#
#    WARUM EIN LEXER UND NICHT EIN string(REGEX REPLACE): weil ein zustandsloser Strip GENAU der
#    Befund 1a/1b ist. Dieser Lauf haelt echten Lexikalzustand: an jedem '<' entscheidet er,
#    welche der fuenf XML-Konstruktionen beginnt, und ueberspringt CDATA-Sektionen, Processing-
#    Instructions und die DOCTYPE-Deklaration (samt internem Subset mit Quotes und Klammern) am
#    Stueck. Ein '<!--' INNERHALB einer dieser Konstruktionen ist damit kein Kommentar-Anfang.
#    Bekannte, bewusste Grenze: Kommentare INNERHALB eines DOCTYPE-internen Subsets bleiben stehen
#    (dort ist ein '--'-Defekt genauso ungueltig; er wuerde unten am Parser auffallen, nicht
#    stumm durchlaufen).
function(comdare_xml_lex_strip_comments _ctx _file _in _out_var)
    set(_rest "${_in}")
    set(_acc "")
    while(NOT _rest STREQUAL "")
        string(FIND "${_rest}" "<" _lt)
        if(_lt EQUAL -1)
            string(APPEND _acc "${_rest}")
            break()
        endif()
        if(_lt GREATER 0)
            string(SUBSTRING "${_rest}" 0 ${_lt} _head)
            string(APPEND _acc "${_head}")
            string(SUBSTRING "${_rest}" ${_lt} -1 _rest)
        endif()
        # Praefix bestimmen, ohne ueber das Stringende zu laufen ('<!DOCTYPE' = 9 Zeichen).
        string(LENGTH "${_rest}" _rlen)
        set(_plen 9)
        if(_rlen LESS 9)
            set(_plen ${_rlen})
        endif()
        string(SUBSTRING "${_rest}" 0 ${_plen} _pfx)
        if(_pfx MATCHES "^<!--")
            comdare_xml_lex_take("-->" 3 "XML-Kommentar")
            # _piece wird VERWORFEN -- das ist der einzige Zweck dieses Laufs.
        elseif(_pfx MATCHES "^<!\\[CDATA\\[")
            comdare_xml_lex_take("]]>" 3 "CDATA-Sektion")
            string(APPEND _acc "${_piece}")
        elseif(_pfx MATCHES "^<\\?")
            comdare_xml_lex_take("?>" 2 "Processing-Instruction")
            string(APPEND _acc "${_piece}")
        elseif(_pfx MATCHES "^<!DOCTYPE")
            # Ende quote- und klammerbewusst suchen: das interne Subset '[...]' darf '>' enthalten.
            comdare_xml_lex_take_quoted(TRUE "DOCTYPE-Deklaration")
            string(APPEND _acc "${_piece}")
        else()
            # Element-Tag oder Streu-'<': bis einschliesslich des Tag-schliessenden '>' verbatim
            # uebernehmen -- QUOTE-BEWUSST (B14-NB4, Befund B1).
            comdare_xml_lex_take_quoted(FALSE "Element-Tag")
            string(APPEND _acc "${_piece}")
        endif()
    endwhile()
    set(${_out_var} "${_acc}" PARENT_SCOPE)
endfunction()

# -- comdare_xml_open: pruefen, dass die Datei Inhalt hat UND wohlgeformtes XML ist; zurueck kommt
#    der Pfad, den die XPath-Abfragen benutzen sollen.
#
#    Das ist der strukturelle Riegel gegen Befund 4 (Fehlverschachtelung, unquotierte oder
#    duplizierte Attribute, Truncation mitten im Dokument): nicht mehr "kommt der Wurzelname
#    textuell nochmal vor", sondern "libxml2 akzeptiert das Dokument". --noent zwingt zugleich
#    die Entity-Expansion (Befund 2), --nonet verbietet jeden Netzzugriff auf externe DTDs.
#
#    _tolerate_comment_text_defect: der EINE freischaltbare Ausnahmeweg (s.
#    comdare_xml_lex_strip_comments). Er ist in BEIDE Richtungen verriegelt --
#      * die Datei muss roh WIRKLICH scheitern und kommentarfrei WIRKLICH durchlaufen, sonst FATAL;
#      * laeuft sie roh bereits sauber durch, ist die Freischaltung obsolet und ebenfalls FATAL.
#    Die Ausnahme kann sich damit nicht ueberleben und nicht unbemerkt mehr decken, als sie soll.
function(comdare_xml_open _ctx _label _file _tolerate_comment_text_defect _out_var)
    comdare_xml_require_tool("${_ctx}")
    file(SIZE "${_file}" _bytes)
    if(_bytes EQUAL 0)
        message(FATAL_ERROR
            "${_ctx}: '${_file}' (${_label}) ist LEER (0 Byte). Eine leere Datei liefert eine "
            "leere Antwortmenge und waere trivial 'in Ordnung'. Kein Gruen ohne Inhalt.")
    endif()
    file(READ "${_file}" _raw)
    string(STRIP "${_raw}" _stripped)
    if(_stripped STREQUAL "")
        message(FATAL_ERROR
            "${_ctx}: '${_file}' (${_label}) enthaelt nur Leerraum (${_bytes} Byte). "
            "Kein Gruen ohne Inhalt.")
    endif()
    execute_process(
        COMMAND "${COMDARE_XMLLINT_EXE}" --noout --nonet --noent "${_file}"
        RESULT_VARIABLE _rc OUTPUT_QUIET ERROR_VARIABLE _err ERROR_STRIP_TRAILING_WHITESPACE)
    if(_rc EQUAL 0)
        # B14-NB4 / Befund B3: RC 0 ist NICHT gleich "sauber gelesen". Der blockierte Entity-Load
        # meldet sich nur hier.
        comdare_xml_assert_clean_stderr("${_ctx}" "${_label}" "Wohlgeformtheits-Lauf" "${_file}" "${_err}")
        if(_tolerate_comment_text_defect)
            message(FATAL_ERROR
                "${_ctx}: fuer ${_label} '${_file}' ist die Kommentar-Text-Ausnahme freigeschaltet, "
                "die Datei ist aber inzwischen ROH wohlgeformt. Die Ausnahme ist damit erledigt: "
                "die Freischaltung in tests/CMakeLists.txt ist zu ENTFERNEN. Eine Ausnahme, die "
                "sich selbst ueberlebt, deckt irgendwann etwas anderes zu.")
        endif()
        set(${_out_var} "${_file}" PARENT_SCOPE)
        return()
    endif()
    if(NOT _tolerate_comment_text_defect)
        message(FATAL_ERROR
            "${_ctx}: ${_label} '${_file}' ist KEIN wohlgeformtes XML -- libxml2 lehnt es ab. Eine "
            "Datei, die kein Parser lesen kann, darf keine gruene Wache erzeugen.\n"
            "  xmllint (RC=${_rc}):\n${_err}")
    endif()
    # B14-NB4 / Befund B11 (Opus-Review): bis hierher pruefte die Verriegelung NUR "roh scheitert" und
    # "kommentarfrei laeuft" -- NICHT, ob der rohe Fehler ueberhaupt der Doppelbindestrich ist. Ein
    # BELIEBIGER anderer Defekt, der durch das Comment-Stripping zufaellig verschwindet, lief damit
    # ebenfalls durch, wurde als "XML-KOMMENTAR-TEXT-DEFEKT" etikettiert -- und die Ausnahme zoege sich
    # NIE zurueck, weil die Datei roh nie wohlgeformt wuerde. Zusammen mit Befund B1 (der Lexer konnte
    # ECHTE Elemente wegschneiden) war das der vollstaendige False-Green-Pfad: ein amputierter Baum mit
    # einer falschen Diagnose daneben. Der Riegel prueft deshalb die MELDUNG des Parsers.
    # libxml2-Wortlaut, am Objekt erhoben: "parser error : Double hyphen within comment".
    if(NOT _err MATCHES "Double hyphen within comment")
        message(FATAL_ERROR
            "${_ctx}: fuer ${_label} '${_file}' ist die Kommentar-Text-Ausnahme freigeschaltet, der "
            "rohe Fehler ist aber NICHT der Doppelbindestrich im Kommentar-Text. Die Ausnahme deckt "
            "GENAU diesen einen Defekt -- fuer jeden anderen waere sie eine Umgehung: das "
            "Comment-Stripping koennte ihn zufaellig mit entfernen, die Datei liefe gruen durch, und "
            "die Freischaltung zoege sich nie zurueck (roh wird die Datei ja nie wohlgeformt).\n"
            "  xmllint roh (RC=${_rc}):\n${_err}")
    endif()
    comdare_xml_lex_strip_comments("${_ctx}" "${_file}" "${_raw}" _nocmt)
    comdare_xml_scratch_dir("${_ctx}" _scratch)
    string(MD5 _tag "${_file}")
    string(RANDOM LENGTH 8 ALPHABET "0123456789abcdef" _rnd)
    set(_tmp "${_scratch}/comdare-xmlwache-${_tag}-${_rnd}.xml")
    file(WRITE "${_tmp}" "${_nocmt}")
    execute_process(
        COMMAND "${COMDARE_XMLLINT_EXE}" --noout --nonet --noent "${_tmp}"
        RESULT_VARIABLE _rc2 OUTPUT_QUIET ERROR_VARIABLE _err2 ERROR_STRIP_TRAILING_WHITESPACE)
    if(_rc2 EQUAL 0 AND NOT "${_err2}" STREQUAL "")
        file(REMOVE "${_tmp}")
        comdare_xml_assert_clean_stderr("${_ctx}" "${_label}" "Wohlgeformtheits-Lauf (kommentarfrei)"
                                        "${_file}" "${_err2}")
    endif()
    if(NOT _rc2 EQUAL 0)
        file(REMOVE "${_tmp}")
        message(FATAL_ERROR
            "${_ctx}: ${_label} '${_file}' ist auch OHNE jeden Kommentar kein wohlgeformtes XML. "
            "Der Defekt liegt also NICHT nur im Kommentar-Text, und die Ausnahme deckt ihn nicht.\n"
            "  xmllint roh (RC=${_rc}):\n${_err}\n"
            "  xmllint kommentarfrei (RC=${_rc2}):\n${_err2}")
    endif()
    message(STATUS
        "${_ctx}: XML-KOMMENTAR-TEXT-DEFEKT in ${_label} '${_file}' -- die Datei ist roh NICHT "
        "wohlgeformt, kommentarfrei aber einwandfrei. Die Wache liest sie deshalb kommentarfrei "
        "weiter. OFFENE AUFLAGE an den Eigentuemer der Datei: den Kommentar-Text reparieren "
        "(XML verbietet '--' im Kommentar), danach die Freischaltung in tests/CMakeLists.txt "
        "entfernen. Befund von xmllint:\n${_err}")
    set(${_out_var} "${_tmp}" PARENT_SCOPE)
endfunction()

# -- Gegenstueck zu comdare_xml_open: raeumt eine eventuell angelegte Ausnahme-Kopie wieder ab.
function(comdare_xml_close _path _orig)
    if(NOT "${_path}" STREQUAL "${_orig}")
        file(REMOVE "${_path}")
    endif()
endfunction()

# -- Eine XPath-Frage an den echten Parser stellen.
function(comdare_xml_query _ctx _label _file _expr _out_var)
    # B14-NB4 / Befund B10: KEIN OUTPUT_STRIP_TRAILING_WHITESPACE mehr. Es sollte die eine Newline
    # entfernen, die xmllint an --xpath anhaengt -- es entfernte aber JEDEN abschliessenden Leerraum
    # und damit auch den, der zum WERT gehoert. Am Objekt: fuer <v>wert   </v> liefert
    # `xmllint --xpath 'string(/r/v)'` die Bytes "w e r t <sp> <sp> <sp> \n"; nach dem Strip stand
    # "wert" da. Ein Wert MIT und einer OHNE abschliessende Leerzeichen waren fuer jeden Vergleich
    # dieser Wachen identisch -- eine Achsen-Auspraegung "node4 " haette als "node4" gegolten.
    # Entfernt wird deshalb GENAU EIN abschliessender Zeilenumbruch (das Werkzeug-Artefakt), sonst
    # nichts. Wo eine Normalisierung fachlich gewollt ist (der Textinhalt eines <value>-Elements traegt
    # die Einrueckung des Dokuments), macht sie der AUFRUFER sichtbar per string(STRIP).
    execute_process(
        COMMAND "${COMDARE_XMLLINT_EXE}" --noent --nonet --xpath "${_expr}" "${_file}"
        OUTPUT_VARIABLE _out ERROR_VARIABLE _err RESULT_VARIABLE _rc
        ERROR_STRIP_TRAILING_WHITESPACE)
    if(NOT _rc EQUAL 0)
        message(FATAL_ERROR
            "${_ctx}: XPath-Abfrage auf ${_label} '${_file}' fehlgeschlagen (RC=${_rc}).\n"
            "  AUSDRUCK: ${_expr}\n"
            "  xmllint:\n${_err}")
    endif()
    # B14-NB4 / Befund B3: auch die XPath-Abfrage laedt das Dokument -- ein blockierter externer
    # Entity-Load meldet sich hier genauso nur ueber stderr, bei RC 0. Selbst gefahren.
    comdare_xml_assert_clean_stderr("${_ctx}" "${_label}" "XPath-Abfrage '${_expr}'" "${_file}" "${_err}")
    string(REGEX REPLACE "\r?\n$" "" _out "${_out}")
    set(${_out_var} "${_out}" PARENT_SCOPE)
endfunction()

# -- count(): liefert immer eine Zahl, auch fuer die leere Knotenmenge.
function(comdare_xml_count _ctx _label _file _expr _out_var)
    comdare_xml_query("${_ctx}" "${_label}" "${_file}" "count(${_expr})" _n)
    if(NOT _n MATCHES "^[0-9]+$")
        message(FATAL_ERROR
            "${_ctx}: count(${_expr}) auf ${_label} '${_file}' lieferte '${_n}' statt einer Zahl.")
    endif()
    set(${_out_var} "${_n}" PARENT_SCOPE)
endfunction()

# -- string(): liefert den Textwert des ERSTEN Treffers, "" fuer die leere Knotenmenge.
#    Semikolon-Riegel: ein ';' im Wert wuerde jede CMake-Liste, in die er spaeter wandert,
#    unbemerkt zerreissen (genau dieser Effekt hat in der Vorfassung eine Tag-Zaehlung verfaelscht).
#    Statt still falsch zu vergleichen, verweigert die Wache die Aussage.
function(comdare_xml_string _ctx _label _file _expr _out_var)
    comdare_xml_query("${_ctx}" "${_label}" "${_file}" "string(${_expr})" _s)
    if(_s MATCHES ";")
        message(FATAL_ERROR
            "${_ctx}: der Wert von string(${_expr}) in ${_label} '${_file}' enthaelt ein Semikolon "
            "('${_s}'). CMake-Listen wuerden daran zerrissen; die Wache verweigert die Aussage, "
            "statt still falsch zu vergleichen.")
    endif()
    set(${_out_var} "${_s}" PARENT_SCOPE)
endfunction()
