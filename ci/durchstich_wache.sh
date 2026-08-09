#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  DURCHSTICH-WACHE -- die zwei Zusicherungen, die der F1-Mini-Lauf selbst
#  nicht geben kann.                                            (2026-08-09)
# =============================================================================
#
# Der Wellenplan (##25, F1 am 14.08.) verlangt einen Mini-Lauf, der die ganze
# Kette traegt: Marker -> Gate -> persist -> anhang:forward -> PDF. Zwei Dinge
# entscheiden dabei, ob der Durchstich etwas BEWEIST oder nur gruen ist. Beide
# sind an dieser Stelle pruefbar, und beide sind es heute nicht.
#
# -----------------------------------------------------------------------------
# (1) frische -- WURDE IN DIESEM LAUF GEMESSEN, ODER NUR ABGESCHRIEBEN?
# -----------------------------------------------------------------------------
# ce profile_run_entry.hpp:1203 setzt woertlich
#
#     res.exit_code = (((res.any_measured > 0 || res.any_resumed > 0)
#                       || provision_ok) && csv_ok) ? 0 : 1;
#
# Ein Lauf, der NICHTS misst und ausschliesslich Alt-Zeilen resumiert, endet
# damit mit Exit 0. Er legt Datenzeilen vor. ci/mess_ausbeute_wache.sh zaehlt
# diese Zeilen und findet sie -- sie ist eine AUSBEUTE-Wache, keine FRISCHE-
# Wache, und das ist kein Mangel, sondern ihre Zustaendigkeit.
#
# Fuer einen Durchstich ist genau das aber der Stellvertreter: die Kette waere
# geprueft, der Gegenstand nicht. Eine vorgefertigte CSV durch die Kette zu
# schieben beweist nichts ueber die Messung -- und ein Voll-Resume ist eine
# vorgefertigte CSV, die sich nur nicht so nennt.
#
# Der Treiber sagt selbst, was er getan hat (profile_run_entry.hpp:1180-1183):
#
#     RUN_PROFILE fertig: basis_rows=.. sota_rows=.. (basis_ids=.. sota_ids=..)
#       measured=<N> resumed=<M> provisioned=<K> csv_ok=<0|1> -> <pfad>
#
# Diese Wache liest measured/resumed aus DIESER Zeile und verlangt, dass N eine
# Mindestzahl erreicht. Optional wird M gedeckelt (der Durchstich faehrt
# resume="false", dort ist M>0 selbst schon ein Befund).
#
# -----------------------------------------------------------------------------
# (2) lastprofile -- SIEHT DAS PRE-FLIGHT DIE LASTPROFILE UEBERHAUPT?
# -----------------------------------------------------------------------------
# AM OBJEKT GEMESSEN, 2026-08-09, mit comdare-experiment-planner (Gegenprobe:
# DIESELBE Datei, nur an einem anderen Ort):
#
#   wdk_fairness_example.profile.xml am Originalort in ce:
#     geprueft: 18 Achsen, 18 Werte, 0 axis_sweeps, 3 sota_series,
#               1 workloads, 3 datasets, 4 measurement_categories
#   dieselbe Datei nach /tmp kopiert:
#     geprueft: 18 Achsen, 18 Werte, 0 axis_sweeps, 3 sota_series,
#               3 datasets, 4 measurement_categories
#
# Der Nenner "1 workloads" FAELLT WEG. Der Planer loest die Lastprofile
# relativ zum PROFILPFAD auf (algorithm_profiles/load_profiles/ als Geschwister
# von thesis_profiles/); liegt das Profil woanders, ist die Menge der bekannten
# Workload-Ids leer und die Pruefung wird uebersprungen -- nicht rot, sondern
# STILL (validate_profile.hpp: "leer = die <workloads>-Pruefung wird
# uebersprungen (rueckwaerts-kompatibel)").
#
# Und der naheliegende Ausweg traegt nicht: COMDARE_LOAD_PROFILE_DIR ist eine
# Variable des TREIBERS (02_messung_driver/main.cpp: pa.load_profile_dir).
# In apps/experiment_planner/main.cpp kommt sie NICHT vor -- gegengeprueft mit
# grep ueber die Datei, 0 Treffer bei nicht-leerer Datei. Das Pre-Flight
# `planner validate` laesst sich also nicht umstimmen.
#
# Folge: ein Profil ausserhalb des ce-Baums hat im Pre-Flight einen blinden
# Fleck genau dort, wo Achse 2 sitzt. Der LAUF selbst faellt hart (die Fassade
# bricht mit Exit 4 ab, wenn sie 0 gueltige Lastprofile findet) -- aber erst
# nach dem Bau, und das ist beim Durchstich die teure Stelle.
#
# Diese Wache schliesst den blinden Fleck VOR dem Lauf: sie zaehlt die im
# Profil deklarierten Workload-Ids und loest jede einzeln gegen das
# Lastprofil-Verzeichnis auf. N von M, und M==0 ist rot.
#
# -----------------------------------------------------------------------------
# AUFRUF
# -----------------------------------------------------------------------------
#   sh ci/durchstich_wache.sh frische     <stdout-log> <mindest-gemessen> [<max-resumiert>]
#   sh ci/durchstich_wache.sh lastprofile <profil.xml> <load-profile-dir>
#
# EXIT: 0 = geprueft und in Ordnung (mit Nenner belegt)
#       1 = geprueft und VERLETZT (zu wenig gemessen / Lastprofil fehlt)
#       2 = konnte nicht pruefen (Datei fehlt, Marker fehlt, Argument fehlt).
#           Ausdruecklich KEIN Gruen: ein stiller Rueckfall waere derselbe
#           Defekt, gegen den diese Wache gebaut ist.
#
# POSIX-sh, ASCII-only, kein Python (Hausdoktrin: kein Python in der Buildchain).
# =============================================================================

set -eu

TRENN="-----------------------------------------------------------------------------"

nutzung() {
    echo "AUFRUF:" >&2
    echo "  sh ci/durchstich_wache.sh frische     <stdout-log> <mindest-gemessen> [<max-resumiert>]" >&2
    echo "  sh ci/durchstich_wache.sh lastprofile <profil.xml> <load-profile-dir>" >&2
}

# Ganzzahl-Pruefung; leere und nicht-numerische Werte sind ein Abbruch, keine 0.
zahl_oder_abbruch() {
    _z="$1"
    _was="$2"
    case "$_z" in
        ''|*[!0-9]*)
            echo "ABBRUCH: '$_was' muss eine nicht-negative Zahl sein, war '$_z'." >&2
            exit 2
            ;;
    esac
}

# --------------------------------------------------------------------------
# frische
# --------------------------------------------------------------------------
wache_frische() {
    LOG="${1:-}"
    MINDEST="${2:-1}"
    MAXRESUM="${3:-}"

    if [ -z "$LOG" ]; then nutzung; exit 2; fi
    if [ ! -f "$LOG" ]; then
        echo "ABBRUCH: '$LOG' ist keine Datei -- die Frische-Wache konnte nicht pruefen." >&2
        echo "         Kein Gruen ohne Pruefung." >&2
        exit 2
    fi
    zahl_oder_abbruch "$MINDEST" "mindest-gemessen"
    [ -n "$MAXRESUM" ] && zahl_oder_abbruch "$MAXRESUM" "max-resumiert"

    # Die Marker-Zeile des Treibers. Ein Lauf kann mehrere schreiben (ein Pass je
    # Aufruf von run_profile); gezaehlt wird die SUMME ueber alle.
    # grep -F: das Muster ist ein Literal, kein Ausdruck (Fallen-Register).
    MARKER=$(grep -F 'RUN_PROFILE fertig:' "$LOG" || true)

    N_MARKER=$(printf '%s' "$MARKER" | awk 'BEGIN{n=0} NF{n++} END{print n+0}')

    echo "$TRENN"
    echo "DURCHSTICH-WACHE / frische   Log=$LOG"
    echo "$TRENN"

    if [ "$N_MARKER" -eq 0 ]; then
        echo "  Marker 'RUN_PROFILE fertig:' im Log NICHT gefunden." >&2
        echo "ABBRUCH: ohne Marker ist nicht entscheidbar, ob gemessen oder resumiert wurde." >&2
        echo "         Das ist kein leerer Lauf, sondern eine unpruefbare Lage -- kein Gruen." >&2
        exit 2
    fi

    # measured=/resumed= aus jeder Marker-Zeile summieren. awk statt sed-Kette:
    # die Felder sind whitespace-getrennte key=value-Token, die Reihenfolge ist
    # nicht zugesichert, und ein Feld darf fehlen ohne die Summe zu verfaelschen.
    SUMMEN=$(printf '%s\n' "$MARKER" | awk '
        BEGIN { m = 0; r = 0; gefunden_m = 0 }
        {
            for (i = 1; i <= NF; i++) {
                if ($i ~ /^measured=[0-9]+$/) { split($i, a, "="); m += a[2]; gefunden_m = 1 }
                if ($i ~ /^resumed=[0-9]+$/)  { split($i, b, "="); r += b[2] }
            }
        }
        END { print m " " r " " gefunden_m }
    ')
    GEMESSEN=$(printf '%s' "$SUMMEN" | awk '{print $1}')
    RESUMIERT=$(printf '%s' "$SUMMEN" | awk '{print $2}')
    HAT_M=$(printf '%s' "$SUMMEN" | awk '{print $3}')

    echo "NENNER (nie eine nackte Null):"
    echo "  $N_MARKER Marker-Zeile(n) 'RUN_PROFILE fertig:' im Log."
    echo "  measured=$GEMESSEN  resumed=$RESUMIERT   (Summe ueber alle Marker-Zeilen)"
    echo "  gefordert: measured >= $MINDEST${MAXRESUM:+, resumed <= $MAXRESUM}"
    echo "$TRENN"

    if [ "$HAT_M" -eq 0 ]; then
        echo "ABBRUCH: die Marker-Zeile(n) tragen kein Feld 'measured=<zahl>'." >&2
        echo "         Der Treiber hat sein Format geaendert oder die Zeile ist abgeschnitten." >&2
        echo "         Unpruefbar ist nicht gruen." >&2
        exit 2
    fi

    if [ "$GEMESSEN" -lt "$MINDEST" ]; then
        echo "FEHLER: in diesem Lauf wurden $GEMESSEN Zelle(n) real gemessen, gefordert waren $MINDEST." >&2
        if [ "$RESUMIERT" -gt 0 ]; then
            echo "        Der Lauf hat $RESUMIERT Zelle(n) RESUMIERT. Diese Zeilen sind aelter als der" >&2
            echo "        Lauf -- sie belegen die Kette, nicht die Messung. Genau daran endet ein" >&2
            echo "        Durchstich, der nichts beweist." >&2
        fi
        exit 1
    fi

    if [ -n "$MAXRESUM" ] && [ "$RESUMIERT" -gt "$MAXRESUM" ]; then
        echo "FEHLER: $RESUMIERT resumierte Zelle(n), erlaubt waren hoechstens $MAXRESUM." >&2
        echo "        Der Durchstich faehrt resume=\"false\"; jede resumierte Zelle heisst, dass" >&2
        echo "        Alt-Bestand in einen Lauf geflossen ist, der frisch sein sollte." >&2
        exit 1
    fi

    if [ "$RESUMIERT" -gt 0 ]; then
        echo "WARNUNG: $RESUMIERT Zelle(n) wurden resumiert, nicht neu gemessen."
        echo "         Das ist zulaessig (kein Deckel gesetzt), aber es ist ein Befund:"
        echo "         so viele Zeilen dieses Laufs sind aelter als der Lauf."
    fi

    echo "DURCHSTICH-WACHE / frische: OK ($GEMESSEN real gemessen, $RESUMIERT resumiert)."
    exit 0
}

# --------------------------------------------------------------------------
# lastprofile
# --------------------------------------------------------------------------
wache_lastprofile() {
    PROFIL="${1:-}"
    LOADDIR="${2:-}"

    if [ -z "$PROFIL" ] || [ -z "$LOADDIR" ]; then nutzung; exit 2; fi
    if [ ! -f "$PROFIL" ]; then
        echo "ABBRUCH: Profil '$PROFIL' ist keine Datei -- konnte nicht pruefen." >&2
        exit 2
    fi
    if [ ! -d "$LOADDIR" ]; then
        echo "ABBRUCH: Lastprofil-Verzeichnis '$LOADDIR' fehlt -- konnte nicht pruefen." >&2
        echo "         Ohne dieses Verzeichnis ist Achse 2 nicht aufloesbar." >&2
        exit 2
    fi

    # <workloads>a b c</workloads> steht in allen Haus-Profilen auf EINER Zeile.
    # Steht es nicht so da, wird hier abgebrochen statt geraten -- ein Parser,
    # der bei unerwarteter Form still 0 Ids liefert, waere wieder eine blinde
    # Wache.
    ZEILE=$(grep -F '<workloads>' "$PROFIL" || true)
    if [ -z "$ZEILE" ]; then
        echo "ABBRUCH: im Profil '$PROFIL' steht kein <workloads>-Element." >&2
        echo "         Ein Messprofil ohne Lastprofil misst nichts -- kein Gruen." >&2
        exit 2
    fi
    case "$ZEILE" in
        *'</workloads>'*) : ;;
        *)
            echo "ABBRUCH: <workloads> im Profil '$PROFIL' ist nicht auf EINER Zeile geschlossen." >&2
            echo "         Diese Wache liest die einzeilige Form; mehrzeilig waere geraten." >&2
            exit 2
            ;;
    esac

    IDS=$(printf '%s\n' "$ZEILE" | sed -e 's/.*<workloads>//' -e 's|</workloads>.*||')

    echo "$TRENN"
    echo "DURCHSTICH-WACHE / lastprofile   Profil=$PROFIL"
    echo "                                 Lastprofile=$LOADDIR"
    echo "$TRENN"

    M=0
    N=0
    FEHLEND=''
    for id in $IDS; do
        M=$((M + 1))
        if [ -f "$LOADDIR/$id.xml" ]; then
            N=$((N + 1))
            echo "  OK      $id  -> $LOADDIR/$id.xml"
        else
            FEHLEND="$FEHLEND $id"
            echo "  FEHLT   $id  -> $LOADDIR/$id.xml existiert nicht"
        fi
    done

    echo "$TRENN"
    echo "NENNER (nie eine nackte Null):"
    echo "  $M Workload-Id(s) im Profil deklariert."
    echo "  $N von $M gegen das Lastprofil-Verzeichnis aufgeloest."
    echo "$TRENN"

    if [ "$M" -eq 0 ]; then
        echo "FEHLER: das <workloads>-Element ist leer (0 Ids)." >&2
        echo "        Achse 2 waere still leer -- genau der Zustand, den two_phase_valid meldet." >&2
        exit 1
    fi
    if [ "$N" -ne "$M" ]; then
        echo "FEHLER: nicht aufloesbare Workload-Id(s):$FEHLEND" >&2
        echo "        Das Pre-Flight 'planner validate' sieht diesen Fehler NICHT, wenn das Profil" >&2
        echo "        ausserhalb des ce-Baums liegt (Gegenprobe im Kopf dieser Datei)." >&2
        exit 1
    fi

    echo "DURCHSTICH-WACHE / lastprofile: OK ($N von $M aufgeloest)."
    exit 0
}

UNTER="${1:-}"
[ "$#" -gt 0 ] && shift

case "$UNTER" in
    frische)     wache_frische "$@" ;;
    lastprofile) wache_lastprofile "$@" ;;
    ''|-h|--help) nutzung; exit 2 ;;
    *)
        echo "ABBRUCH: unbekanntes Unterkommando '$UNTER'." >&2
        nutzung
        exit 2
        ;;
esac
