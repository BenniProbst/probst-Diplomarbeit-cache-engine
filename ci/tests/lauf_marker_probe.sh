#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  PROBE fuer den LAUF-MARKER   (ci/lauf_marker.sh)                (2026-08-09)
#  -- der Marker ist die Wurzel; faellt er, sind alle D3-Gates blind.
# =============================================================================
#
# WARUM DIESE PROBE EXISTIERT:
# ci/lauf_marker.sh ist die Quelle, aus der ci/mess_ausbeute_wache.sh (modus)
# und ci/frische_wache.sh (lauf_kennung) ihre Entscheidung ziehen. Ein Marker,
# der still falsch oder gar nicht geschrieben wird, entwaffnet BEIDE Gates auf
# einmal -- und zwar geraeuschlos: die Ausbeute-Wache faellt dann auf rc=2
# ("kein Marker") oder, schlimmer, auf einen zu weichen Modus.
#
# DIE PFEIL-FALLE, gegen die Fall L3 gebaut ist -- am Objekt gemessen:
#   Die Bau-Anweisung zu D3-7 nannte den Trenner der Treiber-Bilanzzeile "->".
#   Der Treiber schreibt aber U+2192 (ce profile_run_entry.hpp:1223 und
#   experiment_run_entry.hpp:523, Bytes 342 206 222 im Quelltext nachgewiesen).
#   Ein "->"-Parser findet dort NICHTS und schreibt still keinen Marker. L3
#   faehrt deshalb eine Zeile mit dem ECHTEN Byte-Trenner und verlangt einen
#   Marker am richtigen Ort; Mutant M3 nimmt dem Skript diesen Trenner wieder
#   weg und muss daran sterben.
#
# DER DRITTE MODUS (D3-7b, 2026-08-10) -- Faelle L2b/L2c/L2d, Mutanten M5/M6:
#   Bis heute kannte der Marker aus der RUN_PROFILE-Bilanzzeile nur ZWEI Modi:
#   voll und provision_only. Der S3-Konformitaets-Lauf (ce
#   profile_run_entry.hpp "if (a.pruef_only) { ... }"; die emittierte
#   Kampagnen-Pipeline faehrt ihn je Perm ueber COMDARE_PRUEF_ONLY=true) BAUT
#   NICHT und MISST NICHT -- er laedt jede fertige .so und faehrt nur ihr Gate.
#   Er lief damit als modus=voll durch und waere an der Ausbeute-Wache mit
#   "0 Datenzeilen" gestorben. L2b faehrt den neuen Zusatz mit gewuerfeltem
#   Koeder, L2c die Gegenrichtung (ohne Zusatz bleibt es voll -- sonst waere
#   jeder echte Mess-Lauf entwaffnet), L2d den Fail-closed-Zweig fuer beide
#   Zusaetze in EINER Zeile.
#
# ORAKEL (T-5): measured/resumed/provisioned und die Lauf-Kennungen stammen aus
# /dev/urandom, nicht aus dieser Datei und nicht aus der Doku des Prueflings
# (K13). Die Probe schreibt die Zahl in das Log und verlangt SIE im Marker
# wieder. Ein Marker mit fest verdrahteten Zahlen faellt daran.
#
# AUFRUF:
#   sh ci/tests/lauf_marker_probe.sh              # nur die Faelle
#   sh ci/tests/lauf_marker_probe.sh --selbstbiss # Faelle + Mutationsbeweis
#
# ENV:
#   COMDARE_MARKER  Pfad zum Pruefling (Default: <repo>/ci/lauf_marker.sh).
#                   Der --selbstbiss-Zweig setzt ihn auf die Mutanten.
#
# EXIT: 0 = alle Faelle gehalten
#       1 = mindestens ein Fall gerissen
#       2 = die Probe konnte nicht pruefen (Pruefling fehlt, Mutation griff
#           nicht, Koeder biss nicht) -- ausdruecklich KEIN Gruen.
#
# TESTKRITIK (T-9), was diese Probe NICHT deckt:
#   - Sie prueft den Marker, nicht den Treiber: dass der Treiber seine
#     Bilanz-Zeile ueberhaupt schreibt, entscheidet der Lauf. Die Zeilen sind
#     hier NACHGEBAUT, nicht mitgeschnitten -- aendert der Treiber sein Format,
#     bleibt diese Probe gruen und die CI faellt erst im echten Lauf auf rc=2.
#     Gegen genau das gibt es keine billige Deckung; benannt statt verschwiegen.
#   - Sie prueft nicht, ob der Marker im Artefakt landet (Job-Konfiguration).
#   - Sie faehrt keine Nebenlaeufigkeit: zwei Jobs, die gleichzeitig in dasselbe
#     Verzeichnis schreiben, sind ungedeckt.
#
# POSIX-sh (die CI ruft `sh`, das ist hier dash), ASCII-only, kein Python.
# Selbstcheck: Fall L8 prueft die eigene Registrierung (T-7); ohne sie waere
# diese Probe entfernbar, ohne dass etwas rot wird.
# =============================================================================

set -eu
LC_ALL=C
export LC_ALL

SELBST_DIR=$(cd "$(dirname "$0")" && pwd)
SELBST="$SELBST_DIR/$(basename "$0")"
REPO=$(cd "$SELBST_DIR/../.." && pwd)
MARKER="${COMDARE_MARKER:-$REPO/ci/lauf_marker.sh}"
CI_YML="$REPO/.gitlab-ci.yml"

MODUS="${1:-}"
case "$MODUS" in
    ''|--selbstbiss) : ;;
    *) echo "AUFRUF: sh ci/tests/lauf_marker_probe.sh [--selbstbiss]" >&2; exit 2 ;;
esac

if [ ! -f "$MARKER" ]; then
    echo "ABBRUCH: Pruefling '$MARKER' nicht gefunden." >&2
    exit 2
fi

WERK=$(mktemp -d) || exit 2
trap 'rm -rf "$WERK"' EXIT INT TERM
OUT="$WERK/_stdout"; ERR="$WERK/_stderr"

N_FALL=0; N_OK=0; N_ROT=0
RC=0
FALL_OK=1; FALL_NAME=''; FALL_LAUF=0

PFEIL=$(printf '\342\206\222')

token() { od -An -tx1 -N8 /dev/urandom | tr -d ' \n'; }
wuerfel() {
    _lo="$1"; _hi="$2"; _spanne=$((_hi - _lo + 1))
    _roh=$(od -An -tu2 -N2 /dev/urandom | tr -d ' \n')
    echo $(( _lo + (_roh % _spanne) ))
}

fall() { N_FALL=$((N_FALL + 1)); FALL_OK=1; FALL_LAUF=0; FALL_NAME="$1"; }
reiss() { FALL_OK=0; echo "        RISS: $1"; }
protokoll() {
    echo "        ----- literale Ausgabe (stdout) -----"; sed 's/^/        | /' "$OUT"
    echo "        ----- literale Ausgabe (stderr) -----"; sed 's/^/        | /' "$ERR"
    echo "        -------------------------------------"
}
fall_ende() {
    if [ "$FALL_OK" -eq 1 ]; then
        N_OK=$((N_OK + 1)); echo "  [ OK ]  $FALL_NAME"
    else
        N_ROT=$((N_ROT + 1)); echo "  [ROT ]  $FALL_NAME"
        if [ "$FALL_LAUF" -eq 1 ]; then protokoll; fi
    fi
}
lauf() {   # alle Argumente gehen an den Pruefling
    : > "$OUT"; : > "$ERR"
    FALL_LAUF=1
    set +e
    sh "$MARKER" "$@" > "$OUT" 2> "$ERR"
    RC=$?
    set -e
}
fordere_rc() { if [ "$RC" -ne "$1" ]; then reiss "rc=$RC, gefordert war rc=$1"; fi; }
fordere_literal() {   # $1=Datei $2=Text
    if grep -qF -- "$2" "$1"; then :; else reiss "Text fehlt in $(basename "$1"): >>$2<<"; fi
}
# Die Gegenrichtung. Ohne sie belegt "modus=X steht drin" nur die Anwesenheit
# von X, nicht die ABWESENHEIT des falschen Modus -- und genau der waere der
# stille Schaden: ein pruef_only-Lauf, der als provision_only durchgeht, ist
# gedeckt; einer, der als voll durchgeht, stirbt an der Ausbeute-Wache.
fordere_kein_literal() {   # $1=Datei $2=Text
    if grep -qF -- "$2" "$1"; then reiss "Text steht in $(basename "$1"), durfte NICHT: >>$2<<"; fi
}
fordere_datei() { if [ ! -f "$1" ]; then reiss "Datei fehlt: $1"; fi; }
fordere_keine_datei() { if [ -f "$1" ]; then reiss "Datei existiert, durfte NICHT: $1"; fi; }

# Die Bilanz-Zeilen des Treibers, EINMAL nachgebaut statt an sechs Stellen
# abgeschrieben -- sechs Kopien einer Zeile verjaehren einzeln, und die Form
# ist genau das, was hier geprueft wird. Wortlaut aus
# ce profile_run_entry.hpp:1219-1223 bzw. experiment_run_entry.hpp:522-524,
# Trenner ist der ECHTE U+2192 (nicht ASCII '->').
zeile_run_profile() {   # $1=measured $2=resumed $3=provisioned $4=zusatz $5=pfad
    printf 'RUN_PROFILE fertig: basis_rows=1 sota_rows=1 (basis_ids=1 sota_ids=1)'
    printf ' measured=%s resumed=%s provisioned=%s%s' "$1" "$2" "$3" "$4"
    printf ' csv_ok=1 %s %s\n' "$PFEIL" "$5"
}
zeile_run_experiment() {   # $1=measured $2=pfad
    printf 'RUN_EXPERIMENT fertig: phasen=3 sota_rows=4 sota_ids=2'
    printf ' measured=%s resumed=0 csv_ok=1 %s %s\n' "$1" "$PFEIL" "$2"
}

echo "============================================================================="
echo "PROBE LAUF-MARKER"
echo "  Pruefling : $MARKER"
echo "  Werkbank  : $WERK"
echo "  Modus     : ${MODUS:-nur-faelle}"
echo "============================================================================="

# =============================================================================
# L1  RUN_PROFILE-Zeile mit gewuerfelten Zahlen -> Marker mit GENAU diesen
#     Zahlen, am richtigen Ort. Das Orakel liegt ausserhalb des Prueflings.
# =============================================================================
M1=$(wuerfel 3 900); R1=$(wuerfel 0 40); P1=$(wuerfel 0 60)
PIPE1=$(wuerfel 1000 99999); JOB1=$(wuerfel 1000 99999)
fall "L1  RUN_PROFILE (measured=$M1 resumed=$R1 provisioned=$P1) -> Marker traegt sie"
D="$WERK/l1"; mkdir -p "$D/e4_xml"; printf 'kopf\n' > "$D/e4_xml/measurements.csv"
zeile_run_profile "$M1" "$R1" "$P1" "" "$D/e4_xml/measurements.csv" > "$D/log"
CI_PIPELINE_ID="$PIPE1" CI_JOB_ID="$JOB1" lauf schreiben "$D/log" "$D"
fordere_rc 0
fordere_datei "$D/e4_xml/LAUF_MARKER.txt"
if [ -f "$D/e4_xml/LAUF_MARKER.txt" ]; then
    fordere_literal "$D/e4_xml/LAUF_MARKER.txt" "measured=$M1"
    fordere_literal "$D/e4_xml/LAUF_MARKER.txt" "resumed=$R1"
    fordere_literal "$D/e4_xml/LAUF_MARKER.txt" "provisioned=$P1"
    fordere_literal "$D/e4_xml/LAUF_MARKER.txt" "modus=voll"
    fordere_literal "$D/e4_xml/LAUF_MARKER.txt" "lauf_kennung=$PIPE1-$JOB1"
    fordere_literal "$D/e4_xml/LAUF_MARKER.txt" "quelle=RUN_PROFILE"
fi
fall_ende

# =============================================================================
# L2  (provision-only) in der Zeile -> modus=provision_only. Der Modus kommt aus
#     dem TREIBER, nicht aus dem Aufrufer -- deshalb wird hier KEIN Modus
#     uebergeben und trotzdem der richtige erwartet.
# =============================================================================
P2=$(wuerfel 1 99)
fall "L2  '(provision-only)' in der Bilanz-Zeile -> modus=provision_only"
D="$WERK/l2"; mkdir -p "$D/e4_xml"; printf 'kopf\n' > "$D/e4_xml/measurements.csv"
zeile_run_profile 0 0 "$P2" " (provision-only)" "$D/e4_xml/measurements.csv" > "$D/log"
lauf schreiben "$D/log" "$D"
fordere_rc 0
fordere_datei "$D/e4_xml/LAUF_MARKER.txt"
if [ -f "$D/e4_xml/LAUF_MARKER.txt" ]; then
    fordere_literal "$D/e4_xml/LAUF_MARKER.txt" "modus=provision_only"
    fordere_literal "$D/e4_xml/LAUF_MARKER.txt" "provisioned=$P2"
    fordere_kein_literal "$D/e4_xml/LAUF_MARKER.txt" "modus=pruef_only"
fi
fall_ende

# =============================================================================
# L2b DER DRITTE MODUS (D3-7b). '(pruef-only)' in der Zeile -> modus=pruef_only.
#     WARUM ER EIGENS GEBRAUCHT WIRD: der S3-Konformitaets-Lauf misst NICHT und
#     baut NICHT -- er laedt jede fertige .so und faehrt nur ihr Gate (ce
#     profile_run_entry.hpp: 'if (a.pruef_only) { exit = any_pruef_ok>0 &&
#     any_pruef_failed==0 }'). Die emittierte Kampagnen-Pipeline faehrt ihn je
#     Perm (ce planner/experiment_plan_director.hpp: COMDARE_PRUEF_ONLY=true).
#     Er ist damit in derselben Lage wie provision_only -- 0 Datenzeilen sind
#     sein SOLL, nicht sein Versagen -- und war bis D3-7b als modus=voll
#     markiert: die Ausbeute-Wache haette ihn mit "0 Datenzeilen" rot gefaerbt.
#     ZUERST DER KOEDER: die Probe muss beweisen, dass sie '(pruef-only)' und
#     '(provision-only)' ueberhaupt auseinanderhalten kann. Sonst waere ein
#     gruenes 'modus=pruef_only' auch mit einem blinden Werkzeug zu haben.
# =============================================================================
P2B=$(wuerfel 1 99)
K2B=$(wuerfel 1 4)
fall "L2b '(pruef-only)' in der Bilanz-Zeile -> modus=pruef_only (dritter Modus)"
D="$WERK/l2b"; mkdir -p "$D/e4_xml"; printf 'kopf\n' > "$D/e4_xml/measurements.csv"
KOEDER_PO="$WERK/koeder_pruefonly"
: > "$KOEDER_PO"
_i=1
while [ "$_i" -le "$K2B" ]; do
    zeile_run_profile 0 0 "$P2B" " (pruef-only)" "/x/$(token)/measurements.csv" >> "$KOEDER_PO"
    _i=$((_i + 1))
done
zeile_run_profile 0 0 "$P2B" " (provision-only)" "/x/measurements.csv" >> "$KOEDER_PO"
K2B_IST=$(grep -cF -- '(pruef-only)' "$KOEDER_PO" || true)
K2B_PROV=$(grep -cF -- '(pruef-only)' "$WERK/l2/log" || true)
if [ "$K2B_IST" != "$K2B" ] || [ "$K2B_PROV" != "0" ]; then
    echo "  [ABBRUCH] Koeder biss nicht: '(pruef-only)' im Koeder=$K2B_IST (soll $K2B)," >&2
    echo "            im provision-only-Log von L2=$K2B_PROV (soll 0). Ohne beissenden" >&2
    echo "            Koeder ist die Aussage ueber den dritten Modus wertlos." >&2
    exit 2
fi
echo "        Koeder beisst: $K2B gewuerfelte '(pruef-only)'-Zeilen geschrieben,"
echo "        $K2B_IST gefunden; im provision-only-Log von L2 $K2B_PROV (soll 0)."
zeile_run_profile 0 0 "$P2B" " (pruef-only)" "$D/e4_xml/measurements.csv" > "$D/log"
lauf schreiben "$D/log" "$D"
fordere_rc 0
fordere_datei "$D/e4_xml/LAUF_MARKER.txt"
if [ -f "$D/e4_xml/LAUF_MARKER.txt" ]; then
    fordere_literal "$D/e4_xml/LAUF_MARKER.txt" "modus=pruef_only"
    fordere_literal "$D/e4_xml/LAUF_MARKER.txt" "provisioned=$P2B"
    fordere_kein_literal "$D/e4_xml/LAUF_MARKER.txt" "modus=voll"
    fordere_kein_literal "$D/e4_xml/LAUF_MARKER.txt" "modus=provision_only"
fi
fall_ende

# =============================================================================
# L2c DIE GEGENRICHTUNG ZU L2b (K13, beide Richtungen): eine Bilanz-Zeile OHNE
#     jeden Modus-Zusatz muss weiter modus=voll ergeben. Ohne diesen Fall
#     koennte der neue Zweig den Modus einfach IMMER auf pruef_only stellen und
#     L2b bliebe gruen -- das Gate waere dann in jedem echten Mess-Lauf
#     entwaffnet, und zwar geraeuschlos.
# =============================================================================
M2C=$(wuerfel 3 300)
fall "L2c ohne Modus-Zusatz bleibt modus=voll (sonst entwaffnete L2b jeden Mess-Lauf)"
D="$WERK/l2c"; mkdir -p "$D/e4_xml"; printf 'kopf\n' > "$D/e4_xml/measurements.csv"
zeile_run_profile "$M2C" 0 0 "" "$D/e4_xml/measurements.csv" > "$D/log"
lauf schreiben "$D/log" "$D"
fordere_rc 0
if [ -f "$D/e4_xml/LAUF_MARKER.txt" ]; then
    fordere_literal "$D/e4_xml/LAUF_MARKER.txt" "modus=voll"
    fordere_literal "$D/e4_xml/LAUF_MARKER.txt" "measured=$M2C"
    fordere_kein_literal "$D/e4_xml/LAUF_MARKER.txt" "modus=pruef_only"
else
    reiss "kein Marker geschrieben"
fi
fall_ende

# =============================================================================
# L2d BEIDE Modus-Zusaetze in EINER Zeile -> rc=1, BENANNT, KEIN Marker.
#     Der Treiber kann das heute nicht schreiben (die zwei Schalter sind
#     gegenseitig ausschliessend, ce profile_run_entry.hpp: "Gegenseitig
#     ausschliessend mit provision_only"). Steht es doch da, hat sich das
#     Zeilenformat bewegt -- und dann ist der Modus NICHT bekannt. Ein Marker,
#     der sich in dieser Lage fuer einen der beiden entscheidet, waere genau die
#     stille Behauptung, gegen die dieses Werkzeug gebaut ist. Ohne diesen Fall
#     waere der neue Zweig ein VERDECKTER exit-Zweig: er faerbt den Job rot, und
#     kein Test faehrt ihn je an.
# =============================================================================
fall "L2d '(provision-only)' UND '(pruef-only)' in EINER Zeile -> rc=1, kein Marker"
D="$WERK/l2d"; mkdir -p "$D/e4_xml"; printf 'kopf\n' > "$D/e4_xml/measurements.csv"
zeile_run_profile 0 0 1 " (provision-only) (pruef-only)" "$D/e4_xml/measurements.csv" > "$D/log"
lauf schreiben "$D/log" "$D"
fordere_rc 1
fordere_literal "$OUT" "1 Bilanz-Zeile(n) im Log gefunden."
fordere_literal "$OUT" "0 Marker platziert, 1 ohne Marker geblieben."
fordere_literal "$OUT" "beide Modus-Zusaetze in EINER Zeile"
fordere_literal "$ERR" "blieben ohne Marker"
fordere_keine_datei "$D/e4_xml/LAUF_MARKER.txt"
fall_ende

# =============================================================================
# L3  DER PFEIL-FALL. Dieselbe Zeile einmal mit U+2192 (so schreibt der Treiber)
#     und einmal mit ASCII "->" (so stand es in der Bau-Anweisung). Zuerst der
#     KOEDER: die Probe beweist, dass sie den Unterschied ueberhaupt sieht.
# =============================================================================
fall "L3  Trenner U+2192 wird gelesen (Koeder: '->' kommt in der Zeile 0 mal vor)"
D="$WERK/l3"; mkdir -p "$D/e4_xml"; printf 'kopf\n' > "$D/e4_xml/measurements.csv"
M3=$(wuerfel 5 500)
zeile_run_profile "$M3" 0 0 "" "$D/e4_xml/measurements.csv" > "$D/log"
K_ASCII=$(grep -cF -- '->' "$D/log" || true)
printf 'RUN_PROFILE fertig: measured=1 resumed=0 provisioned=0 csv_ok=1 -> /x/measurements.csv\n' > "$D/gegenprobe"
K_GEGEN=$(grep -cF -- '->' "$D/gegenprobe" || true)
if [ "$K_ASCII" != "0" ] || [ "$K_GEGEN" != "1" ]; then
    echo "  [ABBRUCH] Koeder biss nicht: '->' im U+2192-Log=$K_ASCII (soll 0)," >&2
    echo "            im ASCII-Log=$K_GEGEN (soll 1). Ohne beissenden Koeder ist" >&2
    echo "            die Aussage ueber den Trenner wertlos." >&2
    exit 2
fi
echo "        Koeder beisst: '->' im echten Treiber-Log 0 mal, im ASCII-Log 1 mal."
lauf schreiben "$D/log" "$D"
fordere_rc 0
fordere_datei "$D/e4_xml/LAUF_MARKER.txt"
if [ -f "$D/e4_xml/LAUF_MARKER.txt" ]; then fordere_literal "$D/e4_xml/LAUF_MARKER.txt" "measured=$M3"; fi
fall_ende

# =============================================================================
# L4  RUN_EXPERIMENT (der <comdare_experiment>-Weg) hat KEIN provisioned=-Feld.
#     Der Marker darf daraus keine 0 erfinden -- er schreibt 'unbekannt'.
# =============================================================================
M4=$(wuerfel 2 200)
fall "L4  RUN_EXPERIMENT ohne provisioned= -> provisioned=unbekannt, nicht 0"
D="$WERK/l4"; mkdir -p "$D/e4_xml"; printf 'kopf\n' > "$D/e4_xml/measurements.csv"
zeile_run_experiment "$M4" "$D/e4_xml/measurements.csv" > "$D/log"
lauf schreiben "$D/log" "$D"
fordere_rc 0
if [ -f "$D/e4_xml/LAUF_MARKER.txt" ]; then
    fordere_literal "$D/e4_xml/LAUF_MARKER.txt" "quelle=RUN_EXPERIMENT"
    fordere_literal "$D/e4_xml/LAUF_MARKER.txt" "measured=$M4"
    fordere_literal "$D/e4_xml/LAUF_MARKER.txt" "provisioned=unbekannt"
else
    reiss "kein Marker geschrieben"
fi
fall_ende

# =============================================================================
# L5  Mehrere Bilanz-Zeilen -> mehrere Marker an den JEWEILIGEN Orten.
#     Die Messreihen-Zeile (main.cpp:1561) traegt ASCII '->' und KEINE
#     measured=-Felder; sie darf keine Frische behaupten.
# =============================================================================
fall "L5  drei Bilanz-Zeilen (RUN_PROFILE + 2x Messreihe) -> drei Marker"
D="$WERK/l5"; mkdir -p "$D/e4_xml" "$D/A" "$D/B"
printf 'kopf\n' > "$D/e4_xml/measurements.csv"
printf 'kopf\n' > "$D/A/measurements.csv"
printf 'kopf\n' > "$D/B/measurements.csv"
M5=$(wuerfel 7 700)
{
  zeile_run_profile "$M5" 0 0 "" "$D/e4_xml/measurements.csv"
  printf 'Messreihe A OK -> %s/A/measurements.csv\n' "$D"
  printf 'Messreihe B OK -> %s/B/measurements.csv\n' "$D"
} > "$D/log"
lauf schreiben "$D/log" "$D"
fordere_rc 0
fordere_literal "$OUT" "3 Bilanz-Zeile(n) im Log gefunden."
fordere_literal "$OUT" "3 Marker platziert, 0 ohne Marker geblieben."
fordere_datei "$D/e4_xml/LAUF_MARKER.txt"
fordere_datei "$D/A/LAUF_MARKER.txt"
fordere_datei "$D/B/LAUF_MARKER.txt"
if [ -f "$D/A/LAUF_MARKER.txt" ]; then
    fordere_literal "$D/A/LAUF_MARKER.txt" "quelle=MESSREIHE"
    fordere_literal "$D/A/LAUF_MARKER.txt" "measured=unbekannt"
fi
fall_ende

# =============================================================================
# L6  prune_only: KEINE Bilanz-Zeile, nur [PRUNE-TESTAT] -> EIN Marker an der
#     Wurzel, modus=prune_only. "Auch prune_only schreibt einen."
# =============================================================================
V6=$(wuerfel 1 40)
fall "L6  nur [PRUNE-TESTAT] (verified=$V6) -> Wurzel-Marker modus=prune_only"
D="$WERK/l6"; mkdir -p "$D"
printf '[E4] G5 prune-only: verify-then-prune je Stem unter x (INERT -> nie loeschen)\n' > "$D/log"
printf '[PRUNE-TESTAT] verified=%s pruned=0 behalten=%s skipped=0 dll_dir=x\n' "$V6" "$V6" >> "$D/log"
lauf schreiben "$D/log" "$D"
fordere_rc 0
fordere_datei "$D/LAUF_MARKER.txt"
if [ -f "$D/LAUF_MARKER.txt" ]; then
    fordere_literal "$D/LAUF_MARKER.txt" "modus=prune_only"
    fordere_literal "$D/LAUF_MARKER.txt" "quelle=PRUNE_TESTAT"
fi
fall_ende

# =============================================================================
# L7  Weder Bilanz-Zeile noch PRUNE-TESTAT -> rc=2 und NICHTS geschrieben.
#     Die ABWESENHEIT der Datei ist das Signal; sie wird literal geprueft, nicht
#     nur der Exit-Code (T-2: Exit 0/2 allein ist keine Zusicherung).
# =============================================================================
fall "L7  Log ohne Bilanz-Zeile -> rc=2 UND kein Marker auf der Platte"
D="$WERK/l7"; mkdir -p "$D/e4_xml"; printf 'kopf\n' > "$D/e4_xml/measurements.csv"
printf 'irgendein Bau-Rauschen %s\nnoch eine Zeile\n' "$(token)" > "$D/log"
lauf schreiben "$D/log" "$D"
fordere_rc 2
fordere_keine_datei "$D/LAUF_MARKER.txt"
fordere_keine_datei "$D/e4_xml/LAUF_MARKER.txt"
N_MARKER_DA=$(find "$D" -name 'LAUF_MARKER.txt' | awk 'END{print NR+0}')
if [ "$N_MARKER_DA" != "0" ]; then
    reiss "$N_MARKER_DA Marker-Datei(en) geschrieben, gefordert waren 0"
else
    echo "        Nenner: 0 Marker-Datei(en) unter $D (gefordert 0)."
fi
fall_ende

# =============================================================================
# L7b Bilanz-Zeile, aber der Pfad zeigt ins Leere -> rc=1 und BENANNT.
#     Ein halb gesetzter Marker ist schlimmer als keiner.
# =============================================================================
fall "L7b Bilanz-Zeile mit nicht existierendem Pfad -> rc=1, namentlich benannt"
D="$WERK/l7b"; mkdir -p "$D"
FEHLT="$D/gibt_es_nicht_$(token)/measurements.csv"
zeile_run_profile 1 0 0 "" "$FEHLT" > "$D/log"
lauf schreiben "$D/log" "$D"
fordere_rc 1
fordere_literal "$OUT" "1 Bilanz-Zeile(n) im Log gefunden."
fordere_literal "$OUT" "0 Marker platziert, 1 ohne Marker geblieben."
fordere_literal "$ERR" "blieben ohne Marker"
fall_ende

# =============================================================================
# L7c pruefen: eine CSV ohne Marker -> rc=1. FEHLENDER MARKER IST ROT.
# =============================================================================
fall "L7c pruefen: 1 von 2 CSV ohne Marker -> rc=1 mit Nenner"
D="$WERK/l7c"; mkdir -p "$D/mit" "$D/ohne"
printf 'kopf\n' > "$D/mit/measurements.csv"
printf 'kopf\n' > "$D/ohne/measurements.csv"
zeile_run_profile 1 0 0 "" "$D/mit/measurements.csv" > "$D/log"
lauf schreiben "$D/log" "$D"
lauf pruefen "$D"
fordere_rc 1
fordere_literal "$OUT" "1 von 2 mit Lauf-Marker, 1 ohne."
fordere_literal "$ERR" "Fehlender Marker ist ROT"
fall_ende

fall "L7d pruefen: alle CSV gedeckt -> rc=0 (Gegenrichtung, sonst waere sie konstant rot)"
D="$WERK/l7d"; mkdir -p "$D/mit"
printf 'kopf\n' > "$D/mit/measurements.csv"
zeile_run_profile 1 0 0 "" "$D/mit/measurements.csv" > "$D/log"
lauf schreiben "$D/log" "$D"
lauf pruefen "$D"
fordere_rc 0
fordere_literal "$OUT" "1 von 1 mit Lauf-Marker, 0 ohne."
fall_ende

fall "L7e pruefen: 0 CSV -> rc=2 (unpruefbar, ausdruecklich kein Gruen)"
D="$WERK/l7e"; mkdir -p "$D"
lauf pruefen "$D"
fordere_rc 2
fordere_literal "$ERR" "Kein Gruen ohne Pruefung."
fall_ende

# =============================================================================
# L8  REGISTRIERUNG IST TEIL DES TESTS (T-7) -- mit beissendem Koeder, weil eine
#     Null ohne Gegenprobe auch ein Werkzeug-Versagen sein kann.
# =============================================================================
fall "L8  eigene Registrierung in .gitlab-ci.yml, ohne allow_failure"
if [ ! -f "$CI_YML" ]; then
    echo "ABBRUCH: $CI_YML fehlt -- die Registrierung konnte nicht geprueft werden." >&2
    exit 2
fi
AUFRUF='sh ci/tests/lauf_marker_probe.sh'
K=$(wuerfel 1 4)
KOEDER="$WERK/koeder_ci.yml"
: > "$KOEDER"
_i=1
while [ "$_i" -le "$K" ]; do
    printf '      %s   # %s\n' "$AUFRUF" "$(token)" >> "$KOEDER"
    _i=$((_i + 1))
done
printf '      harmlose Zeile\n' >> "$KOEDER"
K_IST=$(grep -cF -- "$AUFRUF" "$KOEDER" || true)
if [ "$K_IST" != "$K" ]; then
    echo "  [ABBRUCH] Koeder biss NICHT: $K geschrieben, $K_IST gefunden." >&2
    exit 2
fi
echo "        Koeder beisst: $K gewuerfelte Vorkommen geschrieben, $K_IST gefunden."
N_AUFRUF=$(grep -cF -- "$AUFRUF" "$CI_YML" || true)
if [ "$N_AUFRUF" = "0" ]; then
    reiss "kein Aufruf von '$AUFRUF' in .gitlab-ci.yml -- die Probe waere unregistriert"
else
    echo "        $N_AUFRUF Aufruf(e) in .gitlab-ci.yml."
fi
JOB='test:lauf-marker-probe:'
BLOCK="$WERK/_jobblock"
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
# L9  ABNAHME D3-7: beide Mess-Jobs rufen den Marker, und golden-320 hat das
#     stdout-Log, aus dem er ueberhaupt lesen kann.
# =============================================================================
fall "L9  Abnahme: lauf_marker + messlauf-stdout.log in BEIDEN Mess-Jobs"
N_LM=$(grep -cF -- 'ci/lauf_marker.sh schreiben' "$CI_YML" || true)
N_LP=$(grep -cF -- 'ci/lauf_marker.sh pruefen' "$CI_YML" || true)
N_LOG=$(grep -cF -- 'messlauf-stdout.log' "$CI_YML" || true)
echo "        .gitlab-ci.yml: $N_LM x 'lauf_marker.sh schreiben', $N_LP x 'pruefen',"
echo "                        $N_LOG x 'messlauf-stdout.log'  (Nenner: 2 Mess-Jobs)"
if [ "$N_LM" -lt 2 ]; then
    reiss "nur $N_LM von 2 Mess-Jobs rufen 'lauf_marker.sh schreiben'"
fi
if [ "$N_LP" -lt 2 ]; then
    reiss "nur $N_LP von 2 Mess-Jobs rufen 'lauf_marker.sh pruefen'"
fi
# smoke hatte vor D3-7 drei Vorkommen (tee, Wache, Artefakt); golden-320 keines.
if [ "$N_LOG" -lt 6 ]; then
    reiss "nur $N_LOG Vorkommen von messlauf-stdout.log -- golden-320 fehlt sein stdout-Log"
fi
fall_ende

echo "============================================================================="
echo "NENNER: $N_FALL Faelle gefahren, $N_OK gehalten, $N_ROT gerissen."
echo "        Pruefling: $MARKER"
echo "============================================================================="

if [ "$N_ROT" -ne 0 ]; then
    echo "PROBE ROT: $N_ROT von $N_FALL Faellen gerissen." >&2
    exit 1
fi
echo "PROBE GRUEN: $N_OK von $N_FALL Faellen gehalten."

# =============================================================================
# --selbstbiss: der Beweis, dass die Probe ueberhaupt beisst (T-1).
# Die Mutanten sind SEMANTISCH gewaehlt, nicht mechanisch: jeder nimmt genau
# eine Zusicherung weg, die oben behauptet wird.
# =============================================================================
[ "$MODUS" = "--selbstbiss" ] || exit 0

echo ""
echo "============================================================================="
echo "SELBSTBISS: Wegwerf-Mutanten des Markers -- die Probe MUSS an ihnen rot werden."
echo "============================================================================="

ORIG_ZEILEN=$(awk 'END{print NR}' "$MARKER")
echo "  Pruefling: $ORIG_ZEILEN Zeilen (Nenner der Mutation)."

N_MUT=0; N_MUT_GEBISSEN=0
mutant_fahren() {   # $1=Kurzname $2=Mutanten-Datei
    N_MUT=$((N_MUT + 1))
    if cmp -s "$MARKER" "$2"; then
        echo "  [ABBRUCH] Mutation '$1' griff NICHT: Datei ist byte-gleich zum Original." >&2
        exit 2
    fi
    chmod +x "$2"
    _log="$WERK/mutlog_$N_MUT.txt"
    echo ""
    echo "  --- Mutant '$1' ($(awk 'END{print NR}' "$2") Zeilen) ---"
    set +e
    COMDARE_MARKER="$2" sh "$SELBST" > "$_log" 2>&1
    _rc=$?
    set -e
    if [ "$_rc" -eq 0 ]; then
        echo "  [ROT ]  Mutant '$1' UEBERLEBT (rc=0) -- die Probe beisst hier nicht."
        sed 's/^/          | /' "$_log"
    else
        N_MUT_GEBISSEN=$((N_MUT_GEBISSEN + 1))
        echo "  [ OK ]  Mutant '$1' wird gefangen (Probe rc=$_rc). Literale Ausgabe:"
        awk '/^  \[ROT \]|^        RISS:|^NENNER:|^PROBE/' "$_log" | sed 's/^/          | /'
    fi
}

# M1: 'pruefen' verliert sein rot -- fehlender Marker waere dann egal.
MU="$WERK/mut_pruefen.sh"
awk '
    /^        echo "FEHLER: \$N_OHNE von \$N_CSV measurements.csv haben KEINEN Lauf-Marker/ { drin = 1 }
    drin && /^        exit 1$/ { drin = 0; next }
    { print }
' "$MARKER" > "$MU"
mutant_fahren "M1  'pruefen' ohne exit 1 (fehlender Marker nicht mehr rot)" "$MU"

# M2: die (provision-only)-Erkennung faellt weg -> modus immer voll.
MU="$WERK/mut_provonly.sh"
sed 's/if (teile\[i\] == "(provision-only)")    { po = 1 }/if (0) { po = 1 }/' "$MARKER" > "$MU"
mutant_fahren "M2  ohne '(provision-only)'-Erkennung (modus immer voll)" "$MU"

# M3: der U+2192-Trenner faellt weg -> RUN_PROFILE liefert keinen Pfad mehr.
#     GENAU der Defekt, den die Bau-Anweisung eingebaut haette.
MU="$WERK/mut_pfeil.sh"
sed "s|^PFEIL_UTF8=.*|PFEIL_UTF8='->'|" "$MARKER" > "$MU"
mutant_fahren "M3  ASCII-Pfeil statt U+2192 (die Falle der Bau-Anweisung)" "$MU"

# M4: die PRUNE-TESTAT-Rueckfallebene faellt weg.
MU="$WERK/mut_prune.sh"
sed "s|if grep -qF '\[PRUNE-TESTAT\]' \"\$LOG\"; then|if false; then|" "$MARKER" > "$MU"
mutant_fahren "M4  ohne PRUNE-TESTAT-Rueckfall (prune_only ohne Marker)" "$MU"

# M5: die (pruef-only)-Erkennung faellt weg -> der S3-Konformitaets-Lauf laeuft
#     wieder als modus=voll und stirbt an der Ausbeute-Wache (D3-7b).
MU="$WERK/mut_pruefonly.sh"
sed 's/if (teile\[i\] == "(pruef-only)")        { pr = 1 }/if (0) { pr = 1 }/' "$MARKER" > "$MU"
mutant_fahren "M5  ohne '(pruef-only)'-Erkennung (dritter Modus faellt auf voll)" "$MU"

# M6: der Fail-closed-Zweig fuer BEIDE Zusaetze in einer Zeile faellt weg -- der
#     Marker entschiede sich dann still fuer einen der beiden Modi.
MU="$WERK/mut_beide.sh"
sed 's|if \[ "\$PO" = "1" \] \&\& \[ "\$PR" = "1" \]; then|if false; then|' "$MARKER" > "$MU"
mutant_fahren "M6  ohne Fail-closed bei beiden Zusaetzen (stille Modus-Wahl)" "$MU"

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
