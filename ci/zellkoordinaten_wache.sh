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
#     Grundgesamtheit aller gefundenen Eintraege. (Modus jobs) dass die STATISCHEN
#     Mess-Jobs einer .gitlab-ci.yml die vier Koordinaten-Variablen exportieren.
#   ZUSICHERT NICHT: dass die Werte RICHTIG sind (dass also opt="O3" der real
#     gebauten Optimierungsstufe entspricht). Das kann diese Wache nicht sehen --
#     sie prueft Anwesenheit UND Nicht-Leere der Koordinate, nicht ihre Wahrheit.
#     Die Wahrheit der platform/lane-Koordinate erzwingt zur Laufzeit die
#     Lane-Wache des Treibers (Code/02_messung_driver/main.cpp:635-657, exit 7);
#     fuer opt/simd gibt es heute KEINE solche Laufzeit-Gegenprobe (s. RESTRISIKO).
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
#
# EXIT: 0 = geprueft und gehalten (mit Nenner belegt)
#       1 = mindestens eine Koordinate fehlt -- der eigentliche Biss
#       2 = die Wache konnte nicht pruefen (Datei/Argument/Job fehlt, keine
#           Eintraege). AUSDRUECKLICH KEIN GRUEN: ein stiller Rueckfall auf 0
#           waere dieselbe Fehlerklasse, gegen die sie gebaut ist.
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
    if [ "$#" -gt 0 ]; then
        JOBS="$*"
    else
        JOBS="measure:smoke measure:golden-320"
    fi

    # Die vier Pflicht-Variablen. COMDARE_MEASUREMENT_COMBO steht bewusst NICHT
    # in dieser Liste (Begruendung im Kopf: leer == [all] == Vollmenge).
    PFLICHT="COMDARE_GN_OPT COMDARE_GN_SIMD COMDARE_PLATFORM COMDARE_LANE"

    N_JOB=0
    N_JOB_OK=0
    N_FEHLT=0
    N_PRUEF=0
    NICHT_GEFUNDEN=0

    for J in $JOBS; do
        N_JOB=$((N_JOB + 1))

        # Job-Block ausschneiden: von '^<job>:' bis zur naechsten Zeile, die in
        # Spalte 1 beginnt und nicht Kommentar/leer ist.
        BLOCK=$(awk -v job="$J" '
            BEGIN { drin = 0 }
            {
                if (drin == 0) {
                    if ($0 == job ":") { drin = 1; next }
                    next
                }
                if ($0 ~ /^[^ \t#]/) { drin = 0; next }
                print
            }
        ' "$ZIEL")

        if [ -z "$BLOCK" ]; then
            echo "  FEHLT  Job '$J' nicht in '$ZIEL' gefunden (oder leerer Block)."
            NICHT_GEFUNDEN=$((NICHT_GEFUNDEN + 1))
            continue
        fi

        JOB_FEHLT=0
        for V in $PFLICHT; do
            N_PRUEF=$((N_PRUEF + 1))
            # Gefordert ist ein EXPORT mit nicht-leerem Wert: 'export VAR="..."'.
            # Ein blosses Vorkommen des Namens (Kommentar!) zaehlt nicht.
            TREFFER=$(printf '%s\n' "$BLOCK" | awk -v v="$V" '
                function attr_wert(zeile, name,   marke, p, rest, q) {
                    marke = "export " name "=\""
                    p = index(zeile, marke)
                    if (p == 0) return "\001"
                    rest = substr(zeile, p + length(marke))
                    q = index(rest, "\"")
                    if (q == 0) return "\001"
                    return substr(rest, 1, q - 1)
                }
                { w = attr_wert($0, v); if (w != "\001" && w != "") { print w; exit } }
            ')
            if [ -z "$TREFFER" ]; then
                echo "  OHNE   $J: export $V=\"...\" fehlt oder ist leer."
                JOB_FEHLT=$((JOB_FEHLT + 1))
                N_FEHLT=$((N_FEHLT + 1))
            else
                echo "  MIT    $J: export $V=\"$TREFFER\""
            fi
        done
        [ "$JOB_FEHLT" -eq 0 ] && N_JOB_OK=$((N_JOB_OK + 1))
    done

    echo "-----------------------------------------------------------------------------"
    echo "NENNER (nie eine nackte Zahl):"
    echo "  $N_JOB Job(s) verlangt, davon $NICHT_GEFUNDEN in '$ZIEL' nicht gefunden."
    echo "  4 Pflicht-Variablen je gefundenem Job -> $N_PRUEF Einzelpruefung(en) gefahren."
    echo "  $N_JOB_OK von $N_JOB Job(s) vollstaendig, $N_FEHLT Einzelpruefung(en) gerissen."
    echo "  Grundgesamtheit der Pflicht-Variablen: $PFLICHT"
    echo "-----------------------------------------------------------------------------"

    if [ "$NICHT_GEFUNDEN" -gt 0 ]; then
        echo "ABBRUCH: $NICHT_GEFUNDEN von $N_JOB Job(s) nicht auffindbar -- nicht pruefbar." >&2
        echo "         Kein Gruen ohne Pruefung (ein umbenannter Job darf nicht still durchrutschen)." >&2
        exit 2
    fi
    if [ "$N_FEHLT" -gt 0 ]; then
        echo "FEHLER: $N_FEHLT von $N_PRUEF Pflicht-Export(en) fehlen." >&2
        echo "        Ein statischer Mess-Job ohne diese Exports schreibt seine Ergebnisse" >&2
        echo "        ohne Zell-Koordinaten -- der Verlust ist aus der Zeile nicht heilbar." >&2
        exit 1
    fi
    echo "ZELLKOORDINATEN-WACHE: OK ($N_PRUEF Pflicht-Export(e) in $N_JOB_OK Job(s) belegt)."
    exit 0
fi

echo "ABBRUCH: unbekannter Modus '$MODUS' (erlaubt: eintraege | jobs)." >&2
exit 2
