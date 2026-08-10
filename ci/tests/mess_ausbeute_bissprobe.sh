#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  BISSPROBE fuer die MESS-AUSBEUTE-WACHE   (ci/mess_ausbeute_wache.sh)
#  -- die Wache selbst ist ein Pruefling, nicht nur ein Pruefer.   (2026-08-08)
# =============================================================================
#
# DER BEFUND, GEGEN DEN SIE GEBAUT IST:
# Die Mess-Ausbeute-Wache ist am 08.08.2026 gelandet (7444d8c0) und wird seither
# von BEIDEN Mess-Jobs als Erfolgsbedingung gerufen (.gitlab-ci.yml:827 und :919).
# Damit haengt der teuerste Lauf des Projekts -- der mehrtaegige golden-320 -- an
# ihrem Urteil. Sie selbst war ungedeckt: nichts haette gemeldet, wenn ein
# `exit 1` in ihr verschwindet. Ihr Verschwinden als DATEI ist an beiden
# Aufrufstellen abgefangen (`test -x ... || exit 1`); ihre stille AUFWEICHUNG
# war es nicht. Genau diese Fehlerklasse -- ein Gate, das gruen sagt, ohne zu
# pruefen -- hat die Wache selbst geheilt; sie darf ihr nicht zum Opfer fallen.
#
# WAS "BISS" HIER HEISST (TDD-Vertrag T-1):
# Die Probe wird nicht nur gegen die gesunde Wache gefahren (dort ist sie gruen),
# sondern zusaetzlich gegen WEGWERF-MUTANTEN der Wache, aus denen je ein `exit 1`
# entfernt ist. Der Lauf `--selbstbiss` fordert, dass die Probe an jedem Mutanten
# ROT wird, und protokolliert, WELCHER Fall gebissen hat. Eine Probe, die am
# kranken Objekt gruen bleibt, ist keine Probe.
#
# ZWEI EXIT-1-ZWEIGE, ZWEI MUTANTEN -- und warum Fall F4 existiert:
# Die Wache hat zwei `exit 1` (Zeile 87: keine CSV gefunden; Zeile 118: Summe
# unter der Mindestzahl). Der Zweig in Zeile 87 ist mit MINDEST>=1 NICHT
# beobachtbar: faellt er weg, laeuft die Wache durch und scheitert eine Zeile
# spaeter am Mindest-Vergleich, mit demselben rc=1. Er wird erst sichtbar bei
# MINDEST=0 -- dort sagt der dokumentierte Vertrag der Wache trotzdem "Fehler"
# ("EXIT 1 = keine CSV, oder keine einzige Datenzeile, oder Mindestzahl
# verfehlt"). Deshalb gibt es Fall F4. Er ist der EINZIGE Fall, der Mutant M2
# toetet; ohne ihn waere die Haelfte der Wache unpruefbar.
#
# ORAKEL (T-5): die erwartete Datenzeilen-Zahl stammt NICHT aus der Wache und
# nicht aus einer Doku, sondern aus einem Wuerfel: die Probe zieht je Lauf frisch
# aus /dev/urandom, wie viele Datenzeilen sie schreibt und welchen Token jede
# Zeile traegt (K13: der Koeder wird erzeugt, nie abgeschrieben). Eine Wache, die
# eine feste Zahl faelscht, faellt daran. Die Zahlen im Protokoll wechseln
# deshalb bei jedem Lauf -- das ist Absicht, kein Rauschen.
#
# ABNAHME-TEIL (Fall F10/F11): die Probe traegt zusaetzlich die Abnahme des
# D3-Pakets -- das alte, defekte Praesenz-Muster `test -n "$(find ...)"` ist aus
# .gitlab-ci.yml verschwunden -- und ihre eigene Registrierung (T-7).
# WARUM DORT EIN KOEDER STEHT: der `grep` der Agenten-Shell ist eine Funktion
# auf ugrep 7.5.0, und ein Muster mit `$(` ist ihm ohne -F eine stille
# Anker-Falle -- stumm im Wortsinn: 0 Bytes auf stderr.
# RICHTIGSTELLUNG 09.08.2026 (die urspruengliche Fassung dieses Kopfes behauptete
# "/usr/bin/grep ist auf dieser Maschine ugrep"; das ist am Objekt FALSCH):
# /usr/bin/grep ist GNU grep 3.11, und GNU grep findet das Muster auch OHNE -F.
# Die Falle haengt am AUFRUFER, nicht am Pfad. Dieses Skript laeuft als /bin/sh
# und sieht damit GNU grep. Der Koeder bleibt trotzdem Pflicht: er ist die
# einzige Deckung, die haelt, ohne zu wissen, welche Engine den Lauf faehrt.
# Am selben Tag literal nachgemessen, auf EINER Datei mit zwei echten Vorkommen:
#   ugrep 7.5.0:  grep -cF 'test -n "$(find' <datei> -> 2  (rc=0)  [richtig]
#   ugrep 7.5.0:  grep -c  'test -n "$(find' <datei> -> 0  (rc=1)  [STILL FALSCH]
#   GNU grep 3.11: grep -c 'test -n "$(find' <datei> -> 2  (rc=0)  [richtig]
# Ein "== 0" ohne Gegenprobe ist damit wertlos: es kann bedeuten, dass das
# Muster weg ist, oder dass das Werkzeug nicht sucht. Die Probe schreibt sich
# deshalb zuerst eine Koeder-Datei mit einer GEWUERFELTEN Anzahl echter
# Vorkommen und verlangt, dass genau diese Anzahl gefunden wird. Erst wenn der
# Koeder beisst, gilt die Null an .gitlab-ci.yml.
#
# AUFRUF:
#   sh ci/tests/mess_ausbeute_bissprobe.sh              # nur die Faelle
#   sh ci/tests/mess_ausbeute_bissprobe.sh --selbstbiss # Faelle + Mutationsbeweis
#
# ENV:
#   COMDARE_WACHE   Pfad zur zu pruefenden Wache (Default: ../mess_ausbeute_wache.sh).
#                   Der --selbstbiss-Zweig setzt sie auf die Mutanten.
#
# EXIT: 0 = alle Faelle gehalten
#       1 = mindestens ein Fall gerissen (Zahl + literale Ausgabe im Protokoll)
#       2 = die Probe konnte nicht pruefen (Wache fehlt, Mutation griff nicht,
#           Koeder biss nicht) -- ausdruecklich KEIN Gruen.
#
# TESTKRITIK (T-9), was diese Probe NICHT deckt:
#   - Sie prueft die Wache, nicht den Mess-Treiber: dass measure_out ueberhaupt
#     befuellt wird, entscheidet weiterhin der Lauf selbst.
#   - Sie prueft die BEIDEN Aufrufstellen nur auf Vorhandensein des Aufrufs
#     (F11 deckt die eigene Registrierung, nicht die der Wache).
#   - Sie prueft keine Nebenlaeufigkeit und keine Sonderrechte (find auf
#     unlesbaren Unterbaeumen); die Wache schluckt find-Fehler bewusst.
#   - Der Mutant entfernt nur `exit 1`-Zeilen. Eine Aufweichung, die stattdessen
#     die Zaehlweise verdreht (z.B. `-le 1` zu `-le 0`), wird von F1 gefangen,
#     eine Aufweichung des Mindest-Vergleichs von F6 -- aber es gibt keinen
#     vollstaendigen Mutations-Katalog.
#
# POSIX-sh (die CI ruft `sh`, das ist hier dash), ASCII-only, kein Python.
# =============================================================================

set -eu

SELBST_DIR=$(cd "$(dirname "$0")" && pwd)
SELBST="$SELBST_DIR/$(basename "$0")"
REPO=$(cd "$SELBST_DIR/../.." && pwd)
WACHE="${COMDARE_WACHE:-$REPO/ci/mess_ausbeute_wache.sh}"
CI_YML="$REPO/.gitlab-ci.yml"

MODUS="${1:-}"
case "$MODUS" in
    ''|--selbstbiss) : ;;
    *) echo "AUFRUF: sh ci/tests/mess_ausbeute_bissprobe.sh [--selbstbiss]" >&2; exit 2 ;;
esac

if [ ! -f "$WACHE" ]; then
    echo "ABBRUCH: Wache '$WACHE' nicht gefunden -- die Probe konnte nicht pruefen." >&2
    exit 2
fi

WERK=$(mktemp -d) || exit 2
trap 'rm -rf "$WERK"' EXIT INT TERM
OUT="$WERK/_stdout"; ERR="$WERK/_stderr"; BEIDE="$WERK/_beide"

N_FALL=0; N_OK=0; N_ROT=0
RC=0

# --- Wuerfel (K13): der Koeder wird erzeugt, nie abgeschrieben ----------------
# od statt `tr < /dev/urandom | head -c`: kein SIGPIPE, kein rc-Ratespiel.
token() { od -An -tx1 -N8 /dev/urandom | tr -d ' \n'; }
# Zahl aus [$1..$2] (kleine Spannen, Modulo-Schiefe hier ohne Belang).
wuerfel() {
    _lo="$1"; _hi="$2"; _spanne=$((_hi - _lo + 1))
    _roh=$(od -An -tu1 -N1 /dev/urandom | tr -d ' \n')
    echo $(( _lo + (_roh % _spanne) ))
}

# --- Fixtures ----------------------------------------------------------------
KOPF='permutation,strategie,median_ns,cache_misses_l1,pmc_available'

nur_kopf() {          # $1 = Zieldatei
    mkdir -p "$(dirname "$1")"
    printf '%s\n' "$KOPF" > "$1"
}
mit_daten() {         # $1 = Zieldatei, $2 = Anzahl Datenzeilen ; gibt 1. Token aus
    mkdir -p "$(dirname "$1")"
    printf '%s\n' "$KOPF" > "$1"
    _erster=''
    _i=1
    while [ "$_i" -le "$2" ]; do
        _t=$(token)
        [ -n "$_erster" ] || _erster="$_t"
        printf 'perm-%s,%s,%s,%s,1\n' "$_i" "$_t" "$((1000 + _i))" "$((4000 + _i))" >> "$1"
        _i=$((_i + 1))
    done
    echo "$_erster"
}

# --- Lauf ohne Pipe: rc=$? nach einer Pipe misst das LETZTE Glied -------------
lauf() {              # $1 = Wurzel (oder __KEIN_ARG__), $2 = Mindest, $3 = Modus
    : > "$OUT"; : > "$ERR"
    FALL_WACHE=1
    set +e
    if [ "$1" = "__KEIN_ARG__" ]; then
        sh "$WACHE" > "$OUT" 2> "$ERR"
    elif [ "$#" -ge 3 ]; then
        sh "$WACHE" "$1" "$2" "$3" > "$OUT" 2> "$ERR"
    elif [ "$#" -ge 2 ]; then
        sh "$WACHE" "$1" "$2" > "$OUT" 2> "$ERR"
    else
        sh "$WACHE" "$1" > "$OUT" 2> "$ERR"
    fi
    RC=$?
    set -e
    cat "$OUT" "$ERR" > "$BEIDE"
}

# Legt einen Lauf-Marker (D3-7) neben eine CSV. Die Probe schreibt ihn SELBST --
# sie prueft hier die Wache, nicht ci/lauf_marker.sh (das hat seine eigene Probe).
marker() {            # $1 = Verzeichnis, $2 = Modus
    mkdir -p "$1"
    {
        echo "quelle=RUN_PROFILE"
        echo "modus=$2"
        echo "lauf_kennung=probe-$(token)"
    } > "$1/LAUF_MARKER.txt"
}

protokoll() {         # literale Ausgabe der Wache -- nur im Fehlerfall
    echo "        ----- literale Ausgabe der Wache (stdout) -----"
    sed 's/^/        | /' "$OUT"
    echo "        ----- literale Ausgabe der Wache (stderr) -----"
    sed 's/^/        | /' "$ERR"
    echo "        ----------------------------------------------"
}

# --- Forderungen -------------------------------------------------------------
FALL_OK=1
FALL_NAME=''
FALL_WACHE=0
# FALL_WACHE trennt Faelle, die die Wache WIRKLICH gerufen haben, von den
# Abnahme-Faellen F10/F11. Ohne diese Trennung haengt das Protokoll eines
# gerissenen Abnahme-Falls die Ausgabe des LETZTEN Wache-Laufs an und
# behauptet damit einen Zusammenhang, den es nicht gibt -- genau die
# Fehlerklasse, gegen die dieses Paket gebaut ist.
fall() { N_FALL=$((N_FALL + 1)); FALL_OK=1; FALL_WACHE=0; FALL_NAME="$1"; }
fall_ende() {
    if [ "$FALL_OK" -eq 1 ]; then
        N_OK=$((N_OK + 1)); echo "  [ OK ]  $FALL_NAME"
    else
        N_ROT=$((N_ROT + 1)); echo "  [ROT ]  $FALL_NAME"
        # KEIN '[ ... ] && protokoll' -- als letzte Anweisung der Funktion waere
        # sein rc=1 unter 'set -eu' der Abbruch der ganzen Probe.
        if [ "$FALL_WACHE" -eq 1 ]; then protokoll; fi
    fi
}
reiss() { FALL_OK=0; echo "        RISS: $1"; }

fordere_rc() {        # $1 = Soll
    if [ "$RC" -ne "$1" ]; then reiss "rc=$RC, gefordert war rc=$1"; fi
}
fordere_literal() {   # $1 = Datei, $2 = literaler Text
    if grep -qF -- "$2" "$1"; then :; else
        reiss "Text fehlt in $(basename "$1"): >>$2<<"
    fi
}
fordere_kein_literal() {
    if grep -qF -- "$2" "$1"; then
        reiss "Text steht in $(basename "$1"), durfte NICHT: >>$2<<"
    fi
}

echo "============================================================================="
echo "BISSPROBE MESS-AUSBEUTE-WACHE"
echo "  Pruefling : $WACHE"
echo "  Werkbank  : $WERK"
echo "  Modus     : ${MODUS:-nur-faelle}"
echo "============================================================================="

# =============================================================================
# F1  Nur Kopfzeile -> die Datei ist da, der Messwert nicht. rc=1.
#     Das ist der Fall, gegen den die Wache gebaut wurde.
# =============================================================================
fall "F1  measurements.csv mit NUR der Kopfzeile -> rc=1"
D="$WERK/f1"; nur_kopf "$D/perm-0001/measurements.csv"
lauf "$D" 1
fordere_rc 1
fordere_literal "$OUT" "1 measurements.csv gefunden."
fordere_literal "$OUT" "0 Datenzeile(n) insgesamt"
fordere_literal "$OUT" "davon 0 mit Datenzeilen, 1 ohne"
fordere_literal "$ERR" "Eine vorhandene Datei ist KEIN Messwert."
fall_ende

# =============================================================================
# F2  Kopf + N gewuerfelte Datenzeilen -> rc=0, und die Wache muss GENAU N
#     melden. N und die Token stammen aus /dev/urandom (T-5: fremdes Orakel).
# =============================================================================
N2=$(wuerfel 1 7)
fall "F2  Kopf + $N2 gewuerfelte Datenzeile(n) -> rc=0, Nenner nennt $N2"
D="$WERK/f2"; T2=$(mit_daten "$D/perm-0001/measurements.csv" "$N2")
fordere_literal "$D/perm-0001/measurements.csv" "$T2"   # Koeder liegt wirklich in der Fixture
lauf "$D" 1
fordere_rc 0
fordere_literal "$OUT" "1 measurements.csv gefunden."
fordere_literal "$OUT" "$N2 Datenzeile(n) insgesamt"
fordere_literal "$OUT" "davon 1 mit Datenzeilen, 0 ohne"
fordere_literal "$OUT" "MESS-AUSBEUTE-WACHE: OK"
fordere_kein_literal "$OUT" "WARNUNG:"
fall_ende

# =============================================================================
# F3  Gar keine CSV, Mindest=1 -> rc=1 mit eigener Begruendung.
# =============================================================================
fall "F3  keine measurements.csv, Mindest=1 -> rc=1"
D="$WERK/f3"; mkdir -p "$D/leerer_lauf"
lauf "$D" 1
fordere_rc 1
fordere_literal "$ERR" "0 CSV-Dateien"
fall_ende

# =============================================================================
# F4  Gar keine CSV, Mindest=0 -> trotzdem rc=1.
#     DER FALL, DER DEN ERSTEN EXIT-ZWEIG UEBERHAUPT BEOBACHTBAR MACHT.
#     Vertrag der Wache, Kopf: "EXIT 1 = keine CSV, oder keine einzige
#     Datenzeile, oder Mindestzahl verfehlt" -- "keine CSV" ist ein EIGENER
#     Fehlergrund, nicht bloss ein Sonderfall der Mindestzahl.
# =============================================================================
fall "F4  keine measurements.csv, Mindest=0 -> rc=1 (eigener Fehlergrund)"
D="$WERK/f4"; mkdir -p "$D/leerer_lauf"
lauf "$D" 0
fordere_rc 1
fordere_literal "$ERR" "0 CSV-Dateien"
fall_ende

# =============================================================================
# F5  Teil-Ausbeute: eine leere neben einer vollen CSV -> rc=0, aber die leere
#     MUSS als Befund sichtbar sein (Owner-KERN: nicht alles geht glatt, aber
#     es muss sichtbar sein).
# =============================================================================
N5=$(wuerfel 2 9)
fall "F5  1 leere + 1 CSV mit $N5 Zeile(n) -> rc=0 MIT sichtbarer WARNUNG"
D="$WERK/f5"
nur_kopf "$D/perm-0001/measurements.csv"
T5=$(mit_daten "$D/perm-0002/measurements.csv" "$N5")
fordere_literal "$D/perm-0002/measurements.csv" "$T5"
lauf "$D" 1
fordere_rc 0
fordere_literal "$OUT" "2 measurements.csv gefunden."
fordere_literal "$OUT" "$N5 Datenzeile(n) insgesamt"
fordere_literal "$OUT" "davon 1 mit Datenzeilen, 1 ohne"
fordere_literal "$OUT" "WARNUNG: 1 von 2 CSV-Dateien tragen KEINE Datenzeile."
fall_ende

# =============================================================================
# F6  Mindestzahl verfehlt: N Zeilen da, N+1 gefordert -> rc=1, und die
#     Fehlermeldung muss BEIDE Zahlen nennen (Aussage statt Anwesenheit).
# =============================================================================
N6=$(wuerfel 1 5); N6P=$((N6 + 1))
fall "F6  $N6 Datenzeile(n), gefordert $N6P -> rc=1 und beide Zahlen genannt"
D="$WERK/f6"; T6=$(mit_daten "$D/perm-0001/measurements.csv" "$N6")
fordere_literal "$D/perm-0001/measurements.csv" "$T6"
lauf "$D" "$N6P"
fordere_rc 1
fordere_literal "$OUT" "$N6 Datenzeile(n) insgesamt, gefordert waren mindestens $N6P"
fordere_literal "$ERR" "der Messlauf hat $N6 Datenzeile(n) erzeugt, gefordert waren $N6P"
fall_ende

# =============================================================================
# F7/F8  Die Wache konnte nicht pruefen -> rc=2, ausdruecklich KEIN Gruen.
#        (Ein stiller Rueckfall auf 0 waere derselbe Defekt wie der geheilte.)
# =============================================================================
fall "F7  Wurzel existiert nicht -> rc=2 (kein Gruen ohne Pruefung)"
lauf "$WERK/gibt_es_nicht_$(token)" 1
fordere_rc 2
fordere_literal "$ERR" "Kein Gruen ohne Pruefung."
fall_ende

fall "F8  ohne Argument -> rc=2"
lauf "__KEIN_ARG__"
fordere_rc 2
fordere_literal "$ERR" "AUFRUF:"
fall_ende

fall "F8b Mindest ist keine Zahl -> rc=2"
D="$WERK/f8b"; T8=$(token); mit_daten "$D/perm-0001/measurements.csv" 1 > /dev/null
lauf "$D" "x${T8}"
fordere_rc 2
fordere_literal "$ERR" "muss eine Zahl sein"
fall_ende

# =============================================================================
# F9  Datei OHNE abschliessenden Newline. Die Wache verspricht im Kopf
#     ausdruecklich, DESHALB mit awk statt wc zu zaehlen ("wc wuerde eine Zeile
#     zu wenig melden"). Das ist eine pruefbare Zusage, kein Kommentar.
# =============================================================================
fall "F9  letzte Datenzeile OHNE Newline -> zaehlt trotzdem (awk statt wc)"
D="$WERK/f9"; mkdir -p "$D/perm-0001"
T9=$(token)
printf '%s\n' "$KOPF" >  "$D/perm-0001/measurements.csv"
printf 'perm-1,%s,1001,4001,1' "$T9" >> "$D/perm-0001/measurements.csv"   # bewusst OHNE \n
lauf "$D" 1
fordere_rc 0
fordere_literal "$OUT" "1 Datenzeile(n) insgesamt"
fall_ende

# =============================================================================
# F12 D3-1-RESTHAELFTE: "rot NUR bei modus=voll und Z==0".
#     VORHER (am Objekt gemessen, 09.08.2026, VOR diesem Paket): das dritte
#     Argument wurde IGNORIERT -- stdout und stderr des Laufs mit
#     'provision_only' waren BYTE-GLEICH zu denen mit 'voll', beide rc=1.
#     Ein provision_only-Lauf misst per Bauart nichts (ce
#     profile_run_entry.hpp:1234/:1241) und starb an dieser Wache.
# =============================================================================
fall "F12 leeres Fenster, modus=provision_only -> rc=0 MIT sichtbarer WARNUNG"
D="$WERK/f12"; nur_kopf "$D/perm-0001/measurements.csv"
lauf "$D" 1 provision_only
fordere_rc 0
fordere_literal "$OUT" "Modus=provision_only"
fordere_literal "$OUT" "0 Datenzeile(n) insgesamt"
fordere_literal "$OUT" "WARNUNG: modus=provision_only"
fordere_literal "$OUT" "MESS-AUSBEUTE-WACHE: OK"
fall_ende

fall "F13 dasselbe Fenster, modus=voll -> rc=1 (die Gegenrichtung)"
D="$WERK/f13"; nur_kopf "$D/perm-0001/measurements.csv"
lauf "$D" 1 voll
fordere_rc 1
fordere_literal "$OUT" "Modus=voll"
fordere_literal "$ERR" "(modus=voll -- dieser Lauf SOLLTE messen.)"
fall_ende

fall "F14 dasselbe Fenster OHNE drittes Argument -> rc=1 (Rueckwaerts-Vertrag)"
D="$WERK/f14"; nur_kopf "$D/perm-0001/measurements.csv"
lauf "$D" 1
fordere_rc 1
fordere_literal "$OUT" "Modus=voll"
fordere_literal "$OUT" "Quelle: Aufrufer-Argument"
fall_ende

fall "F15 unbekannter Modus -> rc=2, KEIN stiller Rueckfall auf einen Default"
D="$WERK/f15"; nur_kopf "$D/perm-0001/measurements.csv"
lauf "$D" 1 "voll$(token)"
fordere_rc 2
fordere_literal "$ERR" "unbekannter Modus"
fordere_literal "$ERR" "wird NICHT auf einen Default zurueckgesetzt"
fall_ende

# =============================================================================
# F16 modus=auto OHNE Lauf-Marker -> rc=2. Ein Rueckfall auf 'voll' waere zwar
#     die scharfe Richtung, wuerde aber die FEHLENDE DECKUNG verschweigen.
# =============================================================================
fall "F16 modus=auto ohne LAUF_MARKER.txt -> rc=2 (kein Gruen ohne Pruefung)"
D="$WERK/f16"; nur_kopf "$D/perm-0001/measurements.csv"
lauf "$D" 1 auto
fordere_rc 2
fordere_literal "$ERR" "kein LAUF_MARKER.txt"
fordere_literal "$ERR" "Kein Gruen ohne Pruefung."
fall_ende

fall "F17 modus=auto mit provision_only-Marker -> Modus wird GELESEN, rc=0"
D="$WERK/f17"; nur_kopf "$D/perm-0001/measurements.csv"
marker "$D/perm-0001" provision_only
lauf "$D" 1 auto
fordere_rc 0
fordere_literal "$OUT" "Modus=provision_only"
fordere_literal "$OUT" "1 Lauf-Marker, 0 davon modus=voll"
fall_ende

# =============================================================================
# F18 DER SCHAERFSTE GEWINNT: ein voll-Marker neben einem provision_only-Marker
#     haelt das Gate scharf. Sonst entwaffnete eine einzige weiche Zelle den
#     ganzen Lauf.
# =============================================================================
fall "F18 modus=auto, 1 voll + 1 provision_only -> schaerfster gewinnt, rc=1"
D="$WERK/f18"
nur_kopf "$D/perm-0001/measurements.csv"; marker "$D/perm-0001" provision_only
nur_kopf "$D/perm-0002/measurements.csv"; marker "$D/perm-0002" voll
lauf "$D" 1 auto
fordere_rc 1
fordere_literal "$OUT" "Modus=voll"
fordere_literal "$OUT" "2 Lauf-Marker, 1 davon modus=voll"
fall_ende

fall "F19 modus=auto, Marker mit unlesbarem Modus -> rc=2 statt Erlaubnis"
D="$WERK/f19"; nur_kopf "$D/perm-0001/measurements.csv"
marker "$D/perm-0001" "kaputt$(token)"
lauf "$D" 1 auto
fordere_rc 2
fordere_literal "$ERR" "unlesbarer Marker ist keine Erlaubnis"
fall_ende

# =============================================================================
# F20 N_CSV==0 bleibt in JEDEM Modus rot -- die Heilung darf den zweiten
#     Exit-Zweig nicht mit entschaerft haben.
# =============================================================================
fall "F20 keine CSV, modus=provision_only -> trotzdem rc=1 (Zweig unveraendert)"
D="$WERK/f20"; mkdir -p "$D/leerer_lauf"
lauf "$D" 1 provision_only
fordere_rc 1
fordere_literal "$ERR" "0 CSV-Dateien"
fall_ende

# =============================================================================
# F21/F22  D3-3b: EINE LEERZEILE IST KEIN MESSWERT.
#     VORHER am Objekt gemessen (10.08.2026, vor dem Paket): eine CSV aus
#     Kopfzeile + 3 Leerzeilen + 1 echter Datenzeile meldete "4 Datenzeile(n)
#     insgesamt", rc=0 -- die Wache rechnete `Zeilen - 1`. Damit war
#     <mindest-datenzeilen> mit Leerzeilen erreichbar.
#     Die drei Leerzeilen sind bewusst VERSCHIEDEN: voellig leer, nur Blanks,
#     Tab+Blank. Eine Heilung, die nur `^$` verwirft, faellt an den letzten
#     beiden -- deshalb steht [^[:space:]] in der Zaehlweise und nicht `NF`.
# =============================================================================
leerzeilen_koeder() {   # $1 = Zieldatei, $2 = Anzahl echter Datenzeilen
    mkdir -p "$(dirname "$1")"
    printf '%s\n' "$KOPF" > "$1"
    printf '\n'      >> "$1"          # leer
    printf '   \n'   >> "$1"          # nur Blanks
    printf '\t \n'   >> "$1"          # Tab + Blank
    _i=1
    while [ "$_i" -le "$2" ]; do
        printf 'perm-%s,%s,%s,%s,1\n' "$_i" "$(token)" "$((1000 + _i))" "$((4000 + _i))" >> "$1"
        _i=$((_i + 1))
    done
}

N21=$(wuerfel 1 4)
fall "F21 Kopf + 3 Leerzeilen + $N21 echte Zeile(n) -> GENAU $N21, nicht $((N21 + 3))"
D="$WERK/f21"
leerzeilen_koeder "$D/perm-0001/measurements.csv" "$N21"
lauf "$D" 1 voll
fordere_rc 0
fordere_literal "$OUT" "$N21 Datenzeile(n) insgesamt"
fordere_literal "$OUT" "3 Leerzeile(n) verworfen"
fordere_literal "$OUT" "davon 1 mit Datenzeilen, 0 ohne"
fall_ende

# Die scharfe Gegenrichtung: NUR Leerzeilen. Vor der Heilung meldete dieselbe
# Datei "3 Datenzeile(n) insgesamt" und rc=0 -- ein Messlauf ohne einen einzigen
# Messwert galt als gelungen. Das ist der eigentliche Befund des Pakets.
fall "F22 Kopf + NUR 3 Leerzeilen, modus=voll -> rc=1, 0 Datenzeilen"
D="$WERK/f22"
leerzeilen_koeder "$D/perm-0001/measurements.csv" 0
lauf "$D" 1 voll
fordere_rc 1
fordere_literal "$OUT" "0 Datenzeile(n) insgesamt"
fordere_literal "$OUT" "3 Leerzeile(n) verworfen"
fordere_literal "$OUT" "davon 0 mit Datenzeilen, 1 ohne"
fordere_literal "$ERR" "der Messlauf hat 0 Datenzeile(n) erzeugt"
fall_ende

# =============================================================================
# F10 ABNAHME D3: das alte Praesenz-Muster ist aus .gitlab-ci.yml verschwunden.
#     ZUERST der Koeder -- eine Null ohne beissenden Koeder ist keine Aussage,
#     sondern ein moegliches Werkzeug-Versagen (ugrep + `$(` ohne -F).
# =============================================================================
MUSTER='test -n "$(find'
fall "F10 Abnahme: '$MUSTER' == 0 in .gitlab-ci.yml (nach beissendem Koeder)"
if [ ! -f "$CI_YML" ]; then
    echo "ABBRUCH: $CI_YML fehlt -- die Abnahme konnte nicht pruefen." >&2
    exit 2
fi
K=$(wuerfel 1 4)
KOEDER="$WERK/koeder_ci.yml"
: > "$KOEDER"
_i=1
while [ "$_i" -le "$K" ]; do
    printf '      test -n "$(find measure_out_%s -name %s | head -1)" || exit 1\n' \
           "$(token)" "'measurements.csv'" >> "$KOEDER"
    _i=$((_i + 1))
done
printf '      harmlose Zeile ohne das Muster\n' >> "$KOEDER"
K_IST=$(grep -cF -- "$MUSTER" "$KOEDER" || true)
if [ "$K_IST" != "$K" ]; then
    echo "  [ABBRUCH] Koeder biss NICHT: $K Vorkommen geschrieben, grep -cF meldet $K_IST." >&2
    echo "            Ohne beissenden Koeder ist die Null an .gitlab-ci.yml wertlos." >&2
    exit 2
fi
echo "        Koeder beisst: $K gewuerfelte Vorkommen geschrieben, $K_IST gefunden."
IST=$(grep -cF -- "$MUSTER" "$CI_YML" || true)
if [ "$IST" != "0" ]; then
    reiss "das alte defekte Muster steht noch $IST mal in .gitlab-ci.yml"
else
    echo "        .gitlab-ci.yml: $IST Vorkommen (Nenner: $(awk 'END{print NR}' "$CI_YML") Zeilen geprueft)."
fi
fall_ende

# =============================================================================
# F11 REGISTRIERUNG IST TEIL DES TESTS (T-7): diese Probe muss in .gitlab-ci.yml
#     gerufen werden, und ihr Job darf KEIN allow_failure tragen. Sonst laesst
#     sich die Deckung entfernen, ohne dass etwas rot wird.
#     Der Treffer dient zugleich als zweiter Koeder: er beweist, dass grep -F
#     in DIESER Datei ueberhaupt findet.
# =============================================================================
fall "F11 eigene Registrierung in .gitlab-ci.yml, ohne allow_failure"
AUFRUF='ci/tests/mess_ausbeute_bissprobe.sh'
N_AUFRUF=$(grep -cF -- "$AUFRUF" "$CI_YML" || true)
if [ "$N_AUFRUF" = "0" ]; then
    reiss "kein Aufruf von $AUFRUF in .gitlab-ci.yml -- die Probe waere unregistriert"
else
    echo "        $N_AUFRUF Aufruf(e) in .gitlab-ci.yml (zugleich Gegenprobe: grep -F findet hier)."
fi
JOB='test:mess-ausbeute-bissprobe:'
BLOCK="$WERK/_jobblock"
# Blockende = die naechste Zeile in SPALTE 0, Kommentarzeilen AUSDRUECKLICH
# eingeschlossen. Ein frueherer Versuch nahm '#' vom Blockende aus (um Kommentare
# im Job zu erlauben) -- der Block lief dadurch ueber das Job-Ende hinaus in den
# Kommentarkopf des NAECHSTEN Jobs, und dort steht "kein allow_failure". Die
# Probe meldete daraufhin einen allow_failure, den es nie gab. In diesem File
# stehen Job-interne Kommentare stets eingerueckt; Spalte 0 trennt die Jobs.
awk -v job="$JOB" '
    $0 == job { drin = 1; print; next }
    drin && /^[^[:space:]]/ { drin = 0 }
    drin { print }
' "$CI_YML" > "$BLOCK"
N_BLOCK=$(awk 'END{print NR+0}' "$BLOCK")
if [ "$N_BLOCK" -eq 0 ]; then
    reiss "Job-Block '$JOB' nicht in .gitlab-ci.yml gefunden"
else
    N_AF=$(grep -cF -- 'allow_failure' "$BLOCK" || true)
    echo "        Job-Block '$JOB': $N_BLOCK Zeilen, davon $N_AF mit allow_failure."
    if [ "$N_AF" != "0" ]; then
        reiss "der Job traegt allow_failure -- eine advisory Wache ist die naechste stille Null"
    fi
fi
fall_ende

# =============================================================================
# NENNER -- nie eine nackte Null.
# =============================================================================
echo "============================================================================="
echo "NENNER: $N_FALL Faelle gefahren, $N_OK gehalten, $N_ROT gerissen."
echo "        Pruefling: $WACHE"
echo "============================================================================="

if [ "$N_ROT" -ne 0 ]; then
    echo "BISSPROBE ROT: $N_ROT von $N_FALL Faellen gerissen." >&2
    exit 1
fi
echo "BISSPROBE GRUEN: $N_OK von $N_FALL Faellen gehalten."

# =============================================================================
# --selbstbiss: der Beweis, dass die Probe ueberhaupt beisst (T-1).
# Ohne diesen Zweig waere oben nur belegt, dass sie am GESUNDEN Objekt gruen
# ist -- was eine Probe, die immer gruen ist, auch waere.
# =============================================================================
[ "$MODUS" = "--selbstbiss" ] || exit 0

echo ""
echo "============================================================================="
echo "SELBSTBISS: Wegwerf-Mutanten der Wache -- die Probe MUSS an ihnen rot werden."
echo "============================================================================="

ORIG_ZEILEN=$(awk 'END{print NR}' "$WACHE")
ORIG_EXITS=$(awk '/^[[:space:]]*exit 1$/{n++} END{print n+0}' "$WACHE")
echo "  Wache: $ORIG_ZEILEN Zeilen, davon $ORIG_EXITS mit 'exit 1' (Nenner der Mutation)."
if [ "$ORIG_EXITS" -ne 2 ]; then
    echo "  ABBRUCH: erwartet wurden 2 'exit 1'-Zweige, gefunden $ORIG_EXITS." >&2
    echo "           Die Wache hat sich strukturell geaendert -- die Mutation waere geraten." >&2
    exit 2
fi

mutiere() {           # $1 = Zieldatei, $2 = welcher Zweig (1|2|beide)
    awk -v w="$2" '
        /^[[:space:]]*exit 1$/ { n++; if (w == "beide" || w == n) next }
        { print }
    ' "$WACHE" > "$1"
    chmod +x "$1"
}

N_MUT=0; N_MUT_GEBISSEN=0
selbstbiss_fall() {   # $1 = Kurzname, $2 = Zweig, $3 = erwartete Zeilen-Differenz
    N_MUT=$((N_MUT + 1))
    _m="$WERK/mutant_$2.sh"
    mutiere "$_m" "$2"
    _mz=$(awk 'END{print NR}' "$_m")
    _diff=$((ORIG_ZEILEN - _mz))
    if [ "$_diff" -ne "$3" ]; then
        echo "  [ABBRUCH] Mutation '$1' griff NICHT: Zeilendifferenz $_diff, erwartet $3." >&2
        exit 2
    fi
    echo ""
    echo "  --- Mutant '$1' ($ORIG_ZEILEN -> $_mz Zeilen, $_diff entfernt) ---"
    _log="$WERK/mutlog_$2.txt"
    set +e
    COMDARE_WACHE="$_m" sh "$SELBST" > "$_log" 2>&1
    _rc=$?
    set -e
    if [ "$_rc" -eq 0 ]; then
        echo "  [ROT ]  Mutant '$1' UEBERLEBT die Probe (rc=0) -- die Probe beisst hier nicht."
        sed 's/^/          | /' "$_log"
    else
        N_MUT_GEBISSEN=$((N_MUT_GEBISSEN + 1))
        echo "  [ OK ]  Mutant '$1' wird gefangen (Probe rc=$_rc). Literale Ausgabe:"
        awk '/^  \[ROT \]|^        RISS:|^NENNER:|^BISSPROBE/' "$_log" | sed 's/^/          | /'
    fi
}

# M1 toetbar durch F1/F6 (Ausbeute-Zweig), M2 NUR durch F4 (Keine-CSV-Zweig).
selbstbiss_fall "M1  ohne 'exit 1' im Keine-CSV-Zweig  (Zeile 87)"    1     1
selbstbiss_fall "M2  ohne 'exit 1' im Ausbeute-Zweig   (Zeile 118)"   2     1
selbstbiss_fall "M3  ohne beide 'exit 1'"                             beide 2

echo ""
echo "============================================================================="
echo "NENNER SELBSTBISS: $N_MUT Mutanten gefahren, $N_MUT_GEBISSEN gefangen."
echo "============================================================================="
if [ "$N_MUT_GEBISSEN" -ne "$N_MUT" ]; then
    echo "SELBSTBISS ROT: $((N_MUT - N_MUT_GEBISSEN)) von $N_MUT Mutanten ueberleben." >&2
    exit 1
fi
echo "SELBSTBISS GRUEN: alle $N_MUT Mutanten gefangen -- die Probe beisst."
exit 0
