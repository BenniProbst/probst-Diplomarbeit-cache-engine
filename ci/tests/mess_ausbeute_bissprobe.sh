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

# ;-Schema-Fixtures (KON44-02 / D4d, F27/F28): der ECHTE measurements.csv-Kopf traegt ';' als
# Trenner, n_ops/total_ns/ns_per_op sind die Felder 4/5/6 (ce cache_engine_builder_iterator.hpp:550).
KOPF_SEMI='binary_id;setting;repetition;n_ops;total_ns;ns_per_op;quality_flag'

mit_na_zeilen() {     # $1 = Zieldatei, $2 = Anzahl REINER n/a-Zeilen ; gibt 1. Token aus
    mkdir -p "$(dirname "$1")"
    printf '%s\n' "$KOPF_SEMI" > "$1"
    _erster=''
    _i=1
    while [ "$_i" -le "$2" ]; do
        _t=$(token)
        [ -n "$_erster" ] || _erster="$_t"
        printf 'perm-%s;lauf;%s;n/a;n/a;n/a;n/a\n' "$_t" "$_i" >> "$1"
        _i=$((_i + 1))
    done
    echo "$_erster"
}

mit_echten_semi() {   # $1 = Zieldatei, $2 = Anzahl ECHTER ;-Zeilen ; gibt 1. Token aus
    mkdir -p "$(dirname "$1")"
    printf '%s\n' "$KOPF_SEMI" > "$1"
    _erster=''
    _i=1
    while [ "$_i" -le "$2" ]; do
        _t=$(token)
        [ -n "$_erster" ] || _erster="$_t"
        printf 'perm-%s;lauf;%s;%s;%s;12\n' "$_t" "$_i" "$((100 + _i))" "$((9000 + _i))" >> "$1"
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
# F5  ##26 M==N (KON60-05, 2026-08-14): eine leere neben einer vollen CSV ist
#     bei modus=voll (hier: Default-Aufruf ohne drittes Argument) ein FEHLER --
#     ein Pruefling, der keine einzige Datenzeile geliefert hat, darf einen
#     Voll-Messlauf nicht bestehen, nur weil die ANDEREN geliefert haben.
#     BIS ##26 galt hier rc=0 mit blosser WARNUNG; die Sichtbarkeits-Zusage
#     (Owner-KERN: nicht alles geht glatt, aber es muss sichtbar sein) lebt
#     unveraendert weiter -- im BEFUND (jeder Modus) und in den weichen Modi
#     als WARNUNG (F5b). Gegenprobe ohne leere CSV: F5c.
# =============================================================================
N5=$(wuerfel 2 9)
fall "F5  1 leere + 1 CSV mit $N5 Zeile(n), modus=voll -> rc=1 (##26 M==N)"
D="$WERK/f5"
nur_kopf "$D/perm-0001/measurements.csv"
T5=$(mit_daten "$D/perm-0002/measurements.csv" "$N5")
fordere_literal "$D/perm-0002/measurements.csv" "$T5"
lauf "$D" 1
fordere_rc 1
fordere_literal "$OUT" "2 measurements.csv gefunden."
fordere_literal "$OUT" "$N5 Datenzeile(n) insgesamt"
fordere_literal "$OUT" "davon 1 mit Datenzeilen, 1 ohne"
fordere_literal "$OUT" "BEFUND: 1 von 2 CSV-Dateien tragen KEINE Datenzeile."
fordere_literal "$ERR" "FEHLER: 1 von 2 CSV-Dateien tragen KEINE Datenzeile."
fordere_literal "$ERR" "(modus=voll -- dieser Lauf SOLLTE messen.)"
fall_ende

fall "F5b dieselbe Lage, modus=pruef_only -> rc=0 MIT sichtbarer WARNUNG (##26 weich)"
N5B=$(wuerfel 2 9)
D="$WERK/f5b"
nur_kopf "$D/perm-0001/measurements.csv"
T5B=$(mit_daten "$D/perm-0002/measurements.csv" "$N5B")
fordere_literal "$D/perm-0002/measurements.csv" "$T5B"
lauf "$D" 1 pruef_only
fordere_rc 0
fordere_literal "$OUT" "davon 1 mit Datenzeilen, 1 ohne"
fordere_literal "$OUT" "BEFUND: 1 von 2 CSV-Dateien tragen KEINE Datenzeile."
fordere_literal "$OUT" "WARNUNG: 1 von 2 CSV-Dateien tragen KEINE Datenzeile."
fordere_literal "$OUT" "MESS-AUSBEUTE-WACHE: OK"
fordere_kein_literal "$ERR" "FEHLER"
fall_ende

fall "F5c Gegenprobe ##26: 2 volle CSVs, modus=voll -> rc=0, KEIN M-von-N-Befund"
N5C=$(wuerfel 2 9)
D="$WERK/f5c"
T5C=$(mit_daten "$D/perm-0001/measurements.csv" "$N5C")
T5D=$(mit_daten "$D/perm-0002/measurements.csv" "$N5C")
fordere_literal "$D/perm-0001/measurements.csv" "$T5C"
fordere_literal "$D/perm-0002/measurements.csv" "$T5D"
lauf "$D" 1 voll
fordere_rc 0
fordere_literal "$OUT" "davon 2 mit Datenzeilen, 0 ohne"
fordere_kein_literal "$BEIDE" "tragen KEINE Datenzeile"
fordere_literal "$OUT" "MESS-AUSBEUTE-WACHE: OK"
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
# D3-7b: die BEGRUENDUNG muss zum Modus passen. Bis D3-7b stand in JEDEM weichen
# Modus das provision_only-Erfolgsmass -- eine falsche Auskunft mitten in einer
# gruenen Ausgabe. Ohne diese zwei Zeilen waere ein Vertauschen der Texte nicht
# zu bemerken (die case-Zweige waeren stille Zweige).
fordere_literal "$OUT" "eine DLL bereitgestellt' das Erfolgsmass"
fordere_kein_literal "$OUT" "S3-Konformitaets-Lauf"
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

# F23..F25 DER DRITTE MODUS (D3-7b): pruef_only.
#     Der S3-Konformitaets-Lauf (ce planner/experiment_plan_director.hpp,
#     COMDARE_PRUEF_ONLY=true; ce profile_run_entry.hpp 'if (a.pruef_only)')
#     MISST NICHT und BAUT NICHT -- er laedt jede fertige .so und faehrt nur ihr
#     Gate. 0 Datenzeilen sind sein SOLL, genau wie bei provision_only.
#     WARUM DAS HIER STEHEN MUSS UND NICHT NUR IM MARKER: die Allowlist dieser
#     Wache kannte bis D3-7b nur voll|provision_only|prune_only|auto. Ein Marker
#     mit modus=pruef_only waere in den Zweig "unlesbarer Marker ist keine
#     Erlaubnis" gefallen -- rc=2, JOB ROT. Der Marker allein haette den Lauf
#     also nicht gerettet, sondern erst getoetet; die zwei Seiten gehoeren
#     zusammen. (F19 bleibt daneben stehen und deckt weiterhin den ECHTEN
#     Tippfehler-Fall: ein Modus, den niemand vergeben hat, ist weiter rc=2.)
# =============================================================================
fall "F23 leeres Fenster, modus=pruef_only -> rc=0 MIT sichtbarer WARNUNG"
D="$WERK/f23"; nur_kopf "$D/perm-0001/measurements.csv"
lauf "$D" 1 pruef_only
fordere_rc 0
fordere_literal "$OUT" "Modus=pruef_only"
fordere_literal "$OUT" "0 Datenzeile(n) insgesamt"
fordere_literal "$OUT" "WARNUNG: modus=pruef_only"
fordere_literal "$OUT" "MESS-AUSBEUTE-WACHE: OK"
# Die Gegenrichtung zu F12: hier MUSS die S3-Begruendung stehen und die
# provision_only-Begruendung fehlen.
fordere_literal "$OUT" "der S3-Konformitaets-Lauf MISST"
fordere_kein_literal "$OUT" "eine DLL bereitgestellt' das Erfolgsmass"
fall_ende

fall "F23b leeres Fenster, modus=prune_only -> rc=0, WEDER die eine NOCH die andere Begruendung"
D="$WERK/f23b"; nur_kopf "$D/perm-0001/measurements.csv"
lauf "$D" 1 prune_only
fordere_rc 0
fordere_literal "$OUT" "WARNUNG: modus=prune_only"
fordere_literal "$OUT" "In diesem Modus ist die Datenzeile ueberhaupt nicht das"
fordere_kein_literal "$OUT" "eine DLL bereitgestellt' das Erfolgsmass"
fordere_kein_literal "$OUT" "der S3-Konformitaets-Lauf MISST"
fall_ende

fall "F24 modus=auto mit pruef_only-Marker -> Modus wird GELESEN, rc=0"
D="$WERK/f24"; nur_kopf "$D/perm-0001/measurements.csv"
marker "$D/perm-0001" pruef_only
lauf "$D" 1 auto
fordere_rc 0
fordere_literal "$OUT" "Modus=pruef_only"
fordere_literal "$OUT" "1 Lauf-Marker, 0 davon modus=voll"
fall_ende

fall "F25 modus=auto, 1 voll + 1 pruef_only -> schaerfster gewinnt, rc=1"
D="$WERK/f25"
nur_kopf "$D/perm-0001/measurements.csv"; marker "$D/perm-0001" pruef_only
nur_kopf "$D/perm-0002/measurements.csv"; marker "$D/perm-0002" voll
lauf "$D" 1 auto
fordere_rc 1
fordere_literal "$OUT" "Modus=voll"
fordere_literal "$OUT" "2 Lauf-Marker, 1 davon modus=voll"
fall_ende

fall "F26 keine CSV, modus=pruef_only -> trotzdem rc=1 (Zweig unveraendert)"
D="$WERK/f26"; mkdir -p "$D/leerer_lauf"
lauf "$D" 1 pruef_only
fordere_rc 1
fordere_literal "$ERR" "0 CSV-Dateien"
fall_ende

# =============================================================================
# F27/F28  KON44-02 / D4d (12.08.2026): EINE n/a-ZEILE IST KEIN MESSWERT.
#     (Nummern F27/F28, NICHT F20/F21: F20/F21 sind seit D3-3b/D3-7b vergeben --
#     Umbenennung statt UNION, exakt die Fall-Namen-Kollision, die der
#     EINDEUTIGKEITS-RIEGEL unten dokumentiert.)
#     Anlassfall am Objekt: der F1-Durchstich-Lauf (WF9-Beleg, MANUAL_RUN.md
#     Abschnitt 8b) bestand diese Wache mit GENAU EINER Datenzeile aus
#     n_ops=n/a;total_ns=n/a;ns_per_op=n/a (provisioniert, kein Messwert).
# =============================================================================
N_NA=$(wuerfel 1 4)
fall "F27 ;-Kopf + $N_NA reine n/a-Zeile(n), modus=voll -> rc=1, Ausgabe nennt exakt $N_NA"
D="$WERK/f27"; T27=$(mit_na_zeilen "$D/perm-0001/measurements.csv" "$N_NA")
fordere_literal "$D/perm-0001/measurements.csv" "$T27"          # Koeder liegt wirklich in der Fixture
fordere_literal "$D/perm-0001/measurements.csv" ";n/a;n/a;n/a"  # und ist wirklich eine n/a-Zeile
lauf "$D" 1 voll
fordere_rc 1
fordere_literal "$OUT" "$N_NA n/a-/provisionierte Zeile(n)"
fordere_literal "$OUT" "0 echte,"
fordere_literal "$ERR" "n/a ist keine Daten-Aussage"
fall_ende

N_ECHT=$(wuerfel 1 4)
fall "F28 Gegenprobe: $N_ECHT echte ;-Zeile(n), modus=voll -> rc=0 UND '0 n/a'"
D="$WERK/f28"; T28=$(mit_echten_semi "$D/perm-0001/measurements.csv" "$N_ECHT")
fordere_literal "$D/perm-0001/measurements.csv" "$T28"          # Koeder liegt wirklich in der Fixture
lauf "$D" 1 voll
fordere_rc 0
fordere_literal "$OUT" "$N_ECHT echte, 0 n/a"
fordere_literal "$OUT" "MESS-AUSBEUTE-WACHE: OK"
fordere_kein_literal "$ERR" "FEHLER"
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

# -----------------------------------------------------------------------------
# EINDEUTIGKEITS-RIEGEL (11.08.2026) -- er faengt die UNION-AUFLOESUNG.
#
# ANLASS, am Objekt: beim Landen von D3-7b kollidierten die Fall-Namen F21/F22
# dieses Zweigs mit den gleichnamigen Faellen, die D3-3b vorher auf development
# gebracht hatte. Loest man so einen Konflikt als reine UNION auf, stehen beide
# Bloecke danach im Baum: die Probe laeuft durch, meldet eine hoehere Fallzahl --
# und NIEMAND sieht, dass ein Name zweimal vergeben ist. Der Verdikt-Zweig unten
# haengt allein an N_ROT und kann das nicht bemerken.
#
# WARUM DIE FALLZAHL ALLEIN NICHT GENUEGT: eine UNION erhoeht Quelltext- UND
# Laufzeit-Zaehlung gleichermassen; beide blieben stimmig. Was NICHT stimmig
# bleibt, ist die EINDEUTIGKEIT der Namen -- deshalb prueft der Riegel sie.
#
# FREMDER NENNER (T-3): gezaehlt wird im QUELLTEXT dieser Datei, nicht in den
# Laufzeit-Zaehlern -- zwei Quellen, wie es der Verifikationsvertrag verlangt.
# -----------------------------------------------------------------------------
_fall_namen=$(/usr/bin/grep -oE '^fall "F[0-9]+[a-z]?' "$0" | sed 's/^fall "//')
_fall_gesamt=$(printf '%s\n' "$_fall_namen" | /usr/bin/grep -c .)
_fall_distinkt=$(printf '%s\n' "$_fall_namen" | sort -u | /usr/bin/grep -c .)
echo "        Fall-Namen im Quelltext: $_fall_gesamt, davon distinkt: $_fall_distinkt."
if [ "$_fall_gesamt" -ne "$_fall_distinkt" ]; then
    echo "============================================================================="
    echo "BISSPROBE ROT (NAMENS-DUBLETTE): $_fall_gesamt Fall-Namen, nur $_fall_distinkt" >&2
    echo "        distinkt. Doppelt vergeben:" >&2
    printf '%s\n' "$_fall_namen" | sort | uniq -d | sed 's/^/          /' >&2
    echo "        Das ist die Signatur einer UNION-Konfliktaufloesung: zwei Bloecke" >&2
    echo "        mit demselben Namen stehen nebeneinander im Baum. Loese den" >&2
    echo "        Konflikt per UMBENENNUNG auf, nicht per UNION." >&2
    exit 1
fi
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
# KON44-02 (12.08.2026): DREI rote Zweige -- (1) keine CSV, (2) Datenzeilen-Summe verfehlt,
# (3) NEU: echte Zeilen verfehlt (n/a-/provisionierte zaehlen nicht, D4d). Der Nenner ist
# mitgezogen; Zweig (3) wird von F27 getoetet (Mutant M3 unten).
# ##26 M==N (KON60-05, 2026-08-14): VIER rote Zweige -- (4) NEU: leere CSV neben
# vollen bei modus=voll. Der Nenner ist mitgezogen; Zweig (4) wird von F5 getoetet
# (Mutant M4 unten -- der fruehere Alle-Zweige-Mutant heisst seither M5).
if [ "$ORIG_EXITS" -ne 4 ]; then
    echo "  ABBRUCH: erwartet wurden 4 'exit 1'-Zweige, gefunden $ORIG_EXITS." >&2
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

# Zweig-Reihenfolge im Pruefling (Datei-Ordnung der 'exit 1'):
#   1 = Keine-CSV        -- toetbar NUR durch F4 (Mindest=0; bei Mindest>=1 faengt Zweig 2 mit)
#   2 = Datenzeilen-Summe -- toetbar durch F1/F6/F13
#   3 = D4d echte Zeilen  -- KON44-02, toetbar NUR durch F27 (Summe reicht, echte nicht)
#   4 = ##26 M==N         -- KON60-05, toetbar NUR durch F5 (Summe und ECHT reichen, N_LEER>0)
selbstbiss_fall "M1  ohne 'exit 1' im Keine-CSV-Zweig"                1     1
selbstbiss_fall "M2  ohne 'exit 1' im Summen-Zweig"                   2     1
selbstbiss_fall "M3  ohne 'exit 1' im D4d-Echte-Zweig (KON44-02)"     3     1
selbstbiss_fall "M4  ohne 'exit 1' im M==N-Zweig (##26/KON60-05)"     4     1
selbstbiss_fall "M5  ohne alle vier 'exit 1'"                         beide 4

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
