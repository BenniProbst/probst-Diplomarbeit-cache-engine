#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  ZELLKOORDINATEN-WACHE -- ein Mess-Ergebnis gilt erst als verwertbar, wenn es
#  sagt, WELCHE Zelle des Experimentraums es gemessen hat.          (2026-08-09)
# =============================================================================
#
# SELBSTCHECK -- was diese Datei zusichert, und was NICHT:
#   ZUSICHERT: (Modus eintraege) dass JEDER <eintrag> eines Bestandslog-Dokuments
#     eine nicht-leere opt- UND simd-Koordinate traegt, mit Nenner ueber der
#     Grundgesamtheit aller gefundenen Eintraege. (Modus jobs) dass JEDER Job mit
#     stage: measure einer .gitlab-ci.yml die vier Koordinaten-Variablen AKTIV
#     (nicht auskommentiert) exportiert, und zwar VOR dem ersten messenden
#     "$DRIVER"-Aufruf seines Blocks. Die Job-Liste wird aus dem DOKUMENT
#     abgeleitet (alle Spalte-1-Schluessel mit stage: measure), nicht behauptet.
#   ZUSICHERT NICHT: dass die Werte RICHTIG sind (dass also opt="O3" der real
#     gebauten Optimierungsstufe entspricht). Das kann diese Wache nicht sehen --
#     sie prueft Anwesenheit UND Nicht-Leere der Koordinate, nicht ihre Wahrheit.
#     Die Wahrheit der platform/lane-Koordinate erzwingt zur Laufzeit die
#     Lane-Wache des Treibers (Code/02_messung_driver/main.cpp:635-657, exit 7);
#     fuer opt/simd gibt es heute KEINE solche Laufzeit-Gegenprobe (s. RESTRISIKO).
#
# NACHTRAG (Lens-Befund D1-D4, 2026-08-09) -- vier Gegeneingaenge, an denen die
# erste Fassung dieser Wache FALSCH-GRUEN war, jetzt gedeckt:
#   D1  Ein AUSKOMMENTIERTER Export ('#  export VAR="..."') zaehlte als Treffer.
#       Jetzt: Zeilen, deren erstes Nicht-Leerzeichen '#' ist, werden VOR der
#       Suche verworfen (kopf_ist_kommentar).
#   D2  Der Block-Ausschnitt endete nur an Spalte-1-Zeilen, die KEIN Kommentar
#       sind -- der Kommentar-Kopf des NAECHSTEN Jobs wurde mitgelesen. Jetzt:
#       JEDE nicht-leere Spalte-1-Zeile schliesst den Block.
#   D3  Die Job-Liste war hart kodiert; ein dritter stage:measure-Job war
#       unsichtbar. Jetzt: die Grundgesamtheit wird aus dem Dokument abgeleitet
#       (ableiten_stage_measure); explizite Argumente kommen HINZU, sie ersetzen
#       die Ableitung nicht. Null ableitbare und null verlangte Jobs -> exit 2.
#   D4  Die REIHENFOLGE war unbewacht: Exports NACH dem Treiber-Aufruf waren
#       gruen, zur Messzeit aber ungesetzt. Jetzt: enthaelt ein Block einen
#       "$DRIVER"-Aufruf (Zeilen, deren Rumpf mit 'test ' beginnt, sind
#       Existenz-Pruefungen und zaehlen nicht), muss jeder Pflicht-Export auf
#       einer FRUEHEREN Block-Zeile stehen.
#   BLIND BLEIBT (benannt statt verschwiegen): ein Export hinter einem
#   Zeilen-Ende-Kommentar auf einer aktiven Zeile; ein per extends/YAML-Anker
#   geerbtes stage: measure (die Ableitung liest Text, keinen YAML-Graphen);
#   ein Treiber-Aufruf ohne das woertliche "$DRIVER" (Wrapper, unquoted $DRIVER).
#   Die Ableitung irrt dabei in die SICHERE Richtung: ein zu viel erkannter Job
#   macht rot/unpruefbar, nie still gruen.
#
# DER BEFUND, GEGEN DEN SIE GEBAUT IST (am Objekt erhoben, 09.08.2026):
# Die beiden STATISCHEN Mess-Jobs (measure:smoke, measure:golden-320) setzten
# KEINE der drei Zell-Koordinaten-Variablen, aus denen ce die ZellKoordinaten
# eines Bestands-Eintrags speist:
#     z.combo = COMDARE_MEASUREMENT_COMBO
#     z.opt   = COMDARE_GN_OPT
#     z.simd  = COMDARE_GN_SIMD
#   (ce libs/cache_engine/profile_facade/profile_run_entry.hpp:514-524)
# Jeder Eintrag, den sie schrieben, hatte damit ZellKoordinaten{"","",""} --
# .empty() == true. Die EMITTIERTEN Jobs setzen sie dagegen je Perm
# (ce .../planner/experiment_plan_director.hpp:1530/1534/1560).
#
# WARUM DAS TEUER IST (nicht: "unschoen"):
# Die Lager-Identitaet eines Eintrags ist das TUPEL (key_sha512, zelle) --
# same_eintrag_identity, ce bestandslog_document.hpp:225-227. Ein statisch
# erzeugter Eintrag (zelle leer) und ein emittierter Eintrag DESSELBEN Artefakts
# (zelle gefuellt) sind damit ZWEI verschiedene Identitaeten. Dasselbe Binary
# steht zweimal im Lager und wird nicht wiederverwendet. Der Code benennt den
# Schadensfall selbst (bestandslog_document.hpp:22-32).
#
# DIE FALLE, DERENTWEGEN DIESE WACHE NICHT AM LOG ANSETZT:
# Der Log-Marker zelle= ist KEIN Zeuge dieses Verlusts. Er substituiert die
# Defaults still:
#     opt  = bestand_zelle.opt.empty()  ? "O3"           : bestand_zelle.opt;
#     simd = bestand_zelle.simd.empty() ? "no_extension" : bestand_zelle.simd;
#   (ce profile_run_entry.hpp:540-542)
# Das Log zeigt also eine plausible zelle= AUCH DANN, wenn die gespeicherte
# Koordinate leer ist. Eine Wache auf den Log-Marker waere in BEIDEN Faellen
# gruen -- ein Messgeraet am falschen Gegenstand. Deshalb prueft diese Wache das
# SERIALISIERTE <eintrag>-Attribut (ce bestandslog_document.hpp:344-352), also
# genau das Feld, an dem die Lager-Identitaet haengt.
#
# WARUM combo LEER SEIN DARF (und keine Luecke ist):
# Die emittierende Seite laesst COMDARE_MEASUREMENT_COMBO bei der Vollmenge
# AUSDRUECKLICH ungesetzt:
#     combo_legend_ == "[all]" ? std::string{} : "COMDARE_MEASUREMENT_COMBO=..."
#   (ce experiment_plan_director.hpp:1269 und :1429)
# und ceb_combo_is_full_set() definiert leer == "[all]" == Vollmenge
#   (ce experiment_plan_director.hpp:275-277).
# Leeres combo IST also die kanonische Schreibweise der Vollmenge -- kein
# fehlender Wert. Diese Wache fordert combo deshalb NICHT. Ein eigener Literal-Tag
# fuer die statischen Jobs waere ein ZWEITES Schema fuer dieselbe Aussage.
#
# AUFRUF:
#   sh ci/zellkoordinaten_wache.sh eintraege <bestandslog.xml>
#   sh ci/zellkoordinaten_wache.sh jobs      <gitlab-ci.yml> [<job> ...]
#     (jobs: die Liste der Pflicht-Jobs wird IMMER aus dem Dokument abgeleitet;
#      zusaetzlich genannte Jobs werden MIT geprueft, nie an ihrer Stelle.)
#
# EXIT: 0 = geprueft und gehalten (mit Nenner belegt)
#       1 = mindestens eine Koordinate fehlt, ist leer, ist nur auskommentiert
#           ODER steht erst NACH dem Treiber-Aufruf -- der eigentliche Biss
#       2 = die Wache konnte nicht pruefen (Datei/Argument/Job fehlt, keine
#           Eintraege, kein einziger stage:measure-Job ableitbar). AUSDRUECKLICH
#           KEIN GRUEN: ein stiller Rueckfall auf 0 waere dieselbe Fehlerklasse,
#           gegen die sie gebaut ist.
#
# RESTRISIKO, ausdruecklich benannt statt verschwiegen:
# Der Modus jobs prueft, DASS die vier Variablen exportiert werden, nicht, dass
# der gepinnte Wert (O3/no_extension) die einzige Zelle des Profils ist. Deklariert
# jemand spaeter <system_axes> im Profil der statischen Jobs, wuerde der Pin ueber
# den GN-Zellen-Filter die Mess-Matrix STILL verengen. Diese Wache faengt das NICHT.
# Der Hinweis steht als Kommentar an der Pin-Stelle in .gitlab-ci.yml -- ein
# Kommentar ist keine Deckung, und das wird hier nicht als eine ausgegeben.
#
# Kein grep -P und kein grep -o: das /usr/bin/grep dieses Hauses kann ugrep sein.
# Geparst wird mit awk (index/substr), POSIX-sh, ASCII-only, kein Python.
# =============================================================================

set -eu

MODUS="${1:-}"
ZIEL="${2:-}"

if [ -z "$MODUS" ] || [ -z "$ZIEL" ]; then
    echo "AUFRUF: sh ci/zellkoordinaten_wache.sh eintraege <bestandslog.xml>" >&2
    echo "        sh ci/zellkoordinaten_wache.sh jobs      <gitlab-ci.yml> [<job> ...]" >&2
    exit 2
fi
if [ ! -f "$ZIEL" ]; then
    echo "ABBRUCH: '$ZIEL' ist keine Datei -- die Wache konnte nicht pruefen." >&2
    echo "         Kein Gruen ohne Pruefung." >&2
    exit 2
fi

echo "-----------------------------------------------------------------------------"
echo "ZELLKOORDINATEN-WACHE   Modus=$MODUS   Ziel=$ZIEL"
echo "-----------------------------------------------------------------------------"

# =============================================================================
#  MODUS eintraege -- die ERGEBNISZEILE (ein <eintrag> des Bestandslogs)
# =============================================================================
if [ "$MODUS" = "eintraege" ]; then
    # Attribut-Extraktion ueber index/substr statt Regex: das Attribut wird mit
    # fuehrendem Leerzeichen gesucht (' opt="'), damit kein Attribut, das auf
    # denselben Namen ENDET, faelschlich trifft.
    AUS=$(awk '
        function attr(zeile, name,   marke, p, rest, q) {
            marke = " " name "=\""
            p = index(zeile, marke)
            if (p == 0) return "\001"          # Attribut FEHLT (von leer unterschieden)
            rest = substr(zeile, p + length(marke))
            q = index(rest, "\"")
            if (q == 0) return "\001"          # unabgeschlossen = nicht lesbar
            return substr(rest, 1, q - 1)
        }
        BEGIN { n = 0; ok = 0; fehl_opt = 0; fehl_simd = 0 }
        index($0, "<eintrag ") == 0 { next }
        {
            n++
            o = attr($0, "opt")
            s = attr($0, "simd")
            c = attr($0, "combo")
            bad = 0
            if (o == "\001" || o == "") { fehl_opt++;  bad = 1 }
            if (s == "\001" || s == "") { fehl_simd++; bad = 1 }
            if (bad) {
                printf "  OHNE   Eintrag %d: opt=%s simd=%s combo=%s\n", n,
                       (o == "\001" ? "<fehlt>" : "\"" o "\""),
                       (s == "\001" ? "<fehlt>" : "\"" s "\""),
                       (c == "\001" ? "<fehlt>" : "\"" c "\"")
            } else {
                ok++
                printf "  MIT    Eintrag %d: opt=\"%s\" simd=\"%s\" combo=\"%s\"\n", n, o, s,
                       (c == "\001" ? "<fehlt>" : c)
            }
        }
        END { printf "SUMMEN %d %d %d %d\n", n, ok, fehl_opt, fehl_simd }
    ' "$ZIEL")

    echo "$AUS" | while IFS= read -r Z; do
        case "$Z" in SUMMEN\ *) : ;; *) [ -n "$Z" ] && echo "$Z" ;; esac
    done

    # K11: die Summenzeile wird OHNE Pipe in Variablen geholt (ein rc=$? nach
    # einer Pipe misst das letzte Glied, nicht awk).
    SUMMEN=$(printf '%s\n' "$AUS" | awk '/^SUMMEN /{print $2, $3, $4, $5}')
    N_GES=$(printf '%s\n' "$SUMMEN" | awk '{print $1+0}')
    N_OK=$(printf '%s\n'  "$SUMMEN" | awk '{print $2+0}')
    N_FO=$(printf '%s\n'  "$SUMMEN" | awk '{print $3+0}')
    N_FS=$(printf '%s\n'  "$SUMMEN" | awk '{print $4+0}')

    echo "-----------------------------------------------------------------------------"
    echo "NENNER (nie eine nackte Zahl):"
    echo "  $N_GES <eintrag>-Zeile(n) in '$ZIEL' gefunden -- das ist die Grundgesamtheit."
    echo "  $N_OK davon tragen opt UND simd nicht-leer."
    echo "  $N_FO ohne opt, $N_FS ohne simd (Mehrfachnennung moeglich: ein Eintrag kann beides fehlen)."
    echo "  combo wird NICHT gefordert: leer == \"[all]\" == Vollmenge (ce ceb_combo_is_full_set)."
    echo "-----------------------------------------------------------------------------"

    if [ "$N_GES" -eq 0 ]; then
        echo "ABBRUCH: kein einziger <eintrag> in '$ZIEL' -- die Wache hatte nichts zu pruefen." >&2
        echo "         Ein Dokument ohne Eintraege belegt KEINE Provenienz. Kein Gruen ohne Pruefung." >&2
        exit 2
    fi
    if [ "$N_OK" -ne "$N_GES" ]; then
        echo "FEHLER: $((N_GES - N_OK)) von $N_GES Eintrag/Eintraegen ohne Zell-Koordinaten." >&2
        echo "        Ein Eintrag ohne opt/simd ist im Lager eine EIGENE Identitaet" >&2
        echo "        (key_sha512, zelle) und dedupliziert nicht gegen den emittierten Lauf." >&2
        exit 1
    fi
    echo "ZELLKOORDINATEN-WACHE: OK ($N_OK von $N_GES Eintrag/Eintraegen mit opt+simd)."
    exit 0
fi

# =============================================================================
#  MODUS jobs -- die EMITTIERENDE SEITE (die statischen Mess-Jobs der YAML)
# =============================================================================
if [ "$MODUS" = "jobs" ]; then
    shift 2

    # D3: die Grundgesamtheit der Pflicht-Jobs wird aus dem DOKUMENT abgeleitet,
    # nicht behauptet: jeder Spalte-1-Schluessel (nicht versteckt, kein '.'-Prefix),
    # in dessen Block eine AKTIVE (nicht auskommentierte) Zeile 'stage: measure'
    # steht. Die Ableitung liest Text, keinen YAML-Graphen -- ein per extends
    # geerbtes stage sieht sie nicht (im Kopf als blind benannt). Sie irrt in die
    # sichere Richtung: ein zu viel erkannter Schluessel macht rot, nie gruen.
    ableiten_stage_measure() {
        awk '
            /^[ \t]/ || $0 == "" {
                if (cur == "") next
                m = $0; sub(/^[ \t]+/, "", m)
                if (index(m, "#") == 1) next       # auskommentiertes stage: zaehlt nicht
                if (m ~ /^stage:/) {
                    v = substr(m, 7)
                    sub(/[ \t]*#.*$/, "", v)
                    gsub(/[ \t"]/, "", v)
                    if (v == "measure" && !seen[cur]++) print cur
                }
                next
            }
            {
                cur = ""
                z = $0
                sub(/[ \t]*#.*$/, "", z)
                sub(/[ \t]+$/, "", z)
                if (z ~ /:$/ && z !~ /^[.#]/ && z !~ /[ \t]/) cur = substr(z, 1, length(z) - 1)
            }
        ' "$1"
    }

    JOBS_ABGELEITET=$(ableiten_stage_measure "$ZIEL")

    JOBS=" "
    N_ABGELEITET=0
    for J in $JOBS_ABGELEITET; do
        JOBS="$JOBS$J "
        N_ABGELEITET=$((N_ABGELEITET + 1))
    done
    N_EXPLIZIT=0
    for J in "$@"; do
        N_EXPLIZIT=$((N_EXPLIZIT + 1))
        case "$JOBS" in
            *" $J "*) : ;;
            *) JOBS="$JOBS$J " ;;
        esac
    done

    if [ "$JOBS" = " " ]; then
        echo "ABBRUCH: kein Job mit stage: measure in '$ZIEL' ableitbar und keiner explizit" >&2
        echo "         verlangt -- die Wache hatte keinen Gegenstand. Kein Gruen ohne Pruefung." >&2
        exit 2
    fi

    # Die vier Pflicht-Variablen. COMDARE_MEASUREMENT_COMBO steht bewusst NICHT
    # in dieser Liste (Begruendung im Kopf: leer == [all] == Vollmenge).
    PFLICHT="COMDARE_GN_OPT COMDARE_GN_SIMD COMDARE_PLATFORM COMDARE_LANE"

    N_JOB=0
    N_JOB_OK=0
    N_FEHLT=0
    N_SPAET=0
    N_PRUEF=0
    N_DRV=0
    NICHT_GEFUNDEN=0

    for J in $JOBS; do
        N_JOB=$((N_JOB + 1))

        # Job-Block ausschneiden: von '^<job>:' bis zur naechsten nicht-leeren
        # Spalte-1-Zeile. D2: AUCH eine Spalte-1-Kommentarzeile schliesst den
        # Block -- sonst laese die Wache den Kommentar-Kopf des NAECHSTEN Jobs
        # mit und faende dort Treffer, die dem geprueften Job nicht gehoeren.
        BLOCK=$(awk -v job="$J" '
            BEGIN { drin = 0 }
            {
                if (drin == 0) {
                    if ($0 == job ":") { drin = 1; next }
                    next
                }
                if ($0 ~ /^[^ \t]/) { drin = 0; next }
                print
            }
        ' "$ZIEL")

        if [ -z "$BLOCK" ]; then
            echo "  FEHLT  Job '$J' nicht in '$ZIEL' gefunden (oder leerer Block)."
            NICHT_GEFUNDEN=$((NICHT_GEFUNDEN + 1))
            continue
        fi

        # D4: die Block-Zeile des ersten MESSENDEN Treiber-Aufrufs. Zeilen, deren
        # Rumpf mit 'test ' beginnt, sind Existenz-Pruefungen ('test -x "$DRIVER"'),
        # kein Messlauf. Kommentare zaehlen nicht (D1). Kein Treffer = kein
        # Treiber-Aufruf im Block = keine Reihenfolge zu pruefen.
        POS_DRV=$(printf '%s\n' "$BLOCK" | awk '
            function kopf_ist_kommentar(zeile,   t) { t = zeile; sub(/^[ \t]+/, "", t); return index(t, "#") == 1 }
            kopf_ist_kommentar($0) { next }
            {
                m = $0; sub(/^[ \t]+/, "", m)
                if (index(m, "test ") == 1) next
                if (index($0, "\"$DRIVER\"") > 0) { print NR; exit }
            }
        ')
        if [ -n "$POS_DRV" ]; then
            N_DRV=$((N_DRV + 1))
        fi

        JOB_FEHLT=0
        JOB_SPAET=0
        for V in $PFLICHT; do
            N_PRUEF=$((N_PRUEF + 1))
            # Gefordert ist ein AKTIVER EXPORT mit nicht-leerem Wert:
            # 'export VAR="..."'. Ein blosses Vorkommen des Namens zaehlt nicht,
            # und eine Zeile, deren erstes Nicht-Leerzeichen '#' ist, zaehlt
            # NICHT (D1: Auskommentieren ist der wahrscheinlichere Weg, einen
            # Export zu verlieren, als Loeschen). Ausgegeben wird 'Zeile Wert'.
            TREFFER=$(printf '%s\n' "$BLOCK" | awk -v v="$V" '
                function kopf_ist_kommentar(zeile,   t) { t = zeile; sub(/^[ \t]+/, "", t); return index(t, "#") == 1 }
                function attr_wert(zeile, name,   marke, p, rest, q) {
                    marke = "export " name "=\""
                    p = index(zeile, marke)
                    if (p == 0) return "\001"
                    rest = substr(zeile, p + length(marke))
                    q = index(rest, "\"")
                    if (q == 0) return "\001"
                    return substr(rest, 1, q - 1)
                }
                kopf_ist_kommentar($0) { next }
                { w = attr_wert($0, v); if (w != "\001" && w != "") { print NR " " w; exit } }
            ')
            if [ -z "$TREFFER" ]; then
                echo "  OHNE   $J: export $V=\"...\" fehlt, ist leer oder nur auskommentiert."
                JOB_FEHLT=$((JOB_FEHLT + 1))
                N_FEHLT=$((N_FEHLT + 1))
            else
                POS_EXP="${TREFFER%% *}"
                WERT="${TREFFER#* }"
                if [ -n "$POS_DRV" ] && [ "$POS_EXP" -gt "$POS_DRV" ]; then
                    echo "  SPAET  $J: export $V=\"$WERT\" erst auf Block-Zeile $POS_EXP, der Treiber-Aufruf steht auf Block-Zeile $POS_DRV -- zur Messzeit ungesetzt."
                    JOB_SPAET=$((JOB_SPAET + 1))
                    N_SPAET=$((N_SPAET + 1))
                else
                    echo "  MIT    $J: export $V=\"$WERT\""
                fi
            fi
        done
        if [ "$JOB_FEHLT" -eq 0 ] && [ "$JOB_SPAET" -eq 0 ]; then
            N_JOB_OK=$((N_JOB_OK + 1))
        fi
    done

    N_JOB_GEF=$((N_JOB - NICHT_GEFUNDEN))

    echo "-----------------------------------------------------------------------------"
    echo "NENNER (nie eine nackte Zahl):"
    echo "  Grundgesamtheit der Jobs: $N_ABGELEITET aus dem Dokument abgeleitet (stage: measure),"
    echo "  $N_EXPLIZIT explizit verlangt, $N_JOB in der Vereinigung, davon $NICHT_GEFUNDEN nicht gefunden."
    echo "  4 Pflicht-Variablen je gefundenem Job -> $N_PRUEF Einzelpruefung(en) gefahren."
    echo "  Reihenfolge (Export VOR Treiber) prueffbar in $N_DRV von $N_JOB_GEF gefundenen Job-Block(s) mit \"\$DRIVER\"-Aufruf."
    echo "  $N_JOB_OK von $N_JOB Job(s) vollstaendig, $N_FEHLT Export(s) fehlend/leer/auskommentiert, $N_SPAET nach dem Treiber."
    echo "  Grundgesamtheit der Pflicht-Variablen: $PFLICHT"
    echo "-----------------------------------------------------------------------------"

    if [ "$NICHT_GEFUNDEN" -gt 0 ]; then
        echo "ABBRUCH: $NICHT_GEFUNDEN von $N_JOB Job(s) nicht auffindbar -- nicht pruefbar." >&2
        echo "         Kein Gruen ohne Pruefung (ein umbenannter Job darf nicht still durchrutschen)." >&2
        exit 2
    fi
    if [ "$N_FEHLT" -gt 0 ] || [ "$N_SPAET" -gt 0 ]; then
        echo "FEHLER: $N_FEHLT von $N_PRUEF Pflicht-Export(en) fehlen/leer/auskommentiert, $N_SPAET stehen NACH dem Treiber-Aufruf." >&2
        echo "        Ein statischer Mess-Job ohne diese Exports (oder mit Exports nach dem" >&2
        echo "        Treiber) schreibt seine Ergebnisse ohne Zell-Koordinaten -- der Verlust" >&2
        echo "        ist aus der Zeile nicht heilbar." >&2
        exit 1
    fi
    echo "ZELLKOORDINATEN-WACHE: OK ($N_PRUEF Pflicht-Export(e) in $N_JOB_OK Job(s) belegt; Job-Liste aus dem Dokument abgeleitet)."
    exit 0
fi

echo "ABBRUCH: unbekannter Modus '$MODUS' (erlaubt: eintraege | jobs)." >&2
exit 2
