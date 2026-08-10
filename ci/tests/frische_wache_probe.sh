#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  PROBE fuer die FRISCHE-WACHE   (ci/frische_wache.sh)             (2026-08-09)
#  -- der Zwei-Lauf-Koeder: fremde Zeilen duerfen den eigenen Leerlauf nicht
#     maskieren.
# =============================================================================
#
# DER BEFUND, GEGEN DEN DIE WACHE GEBAUT IST -- und den diese Probe festnagelt:
# Code/measure_out ist vom Aufraeumen ausgenommen (ce
# experiment_plan_director.hpp:1194-1203 emittiert woertlich
# GIT_CLEAN_FLAGS: "-ffdx -e Code/gn_out -e Code/build -e Code/measure_out").
# CSVs frueherer Laeufe ueberleben dort. Die Ausbeute-Wache summiert ueber ALLE
# Dateien -- sie liest eine fremde Datenzeile also als Ausbeute dieses Laufs.
#
# AM OBJEKT NACHGEMESSEN, bevor die Wache ihren zweiten Ausgang bekam:
#   Altzelle (fremde Kennung, 1 Datenzeile) + Neuzelle (eigene Kennung, nur Kopf)
#     -> ci/frische_wache.sh (nur Dateien zaehlend): csv_dieser_lauf=1, rc=0
#     -> ci/mess_ausbeute_wache.sh: "1 Datenzeile(n) insgesamt", rc=0
#   BEIDE gruen, obwohl dieser Lauf keinen Messwert erzeugt hat. Genau diese
#   Maskierung ist der Gegenstand; F6 haelt sie fest.
#
# BEIDE RICHTUNGEN (K13): der manipulierte Lauf MUSS rot werden (F6) und der
# unmanipulierte MUSS gruen bleiben (F5, F7). Ohne die Gegenrichtung koennte
# die Wache konstant rot sein und niemand wuesste es.
#
# ORAKEL (T-5): Lauf-Kennungen, Datenzeilen-Zahlen und Token stammen aus
# /dev/urandom. Die Probe schreibt sie in Marker und CSV und verlangt SIE in der
# Ausgabe wieder -- nichts davon steht in der Wache oder in dieser Doku.
#
# AUFRUF:
#   sh ci/tests/frische_wache_probe.sh              # nur die Faelle
#   sh ci/tests/frische_wache_probe.sh --selbstbiss # Faelle + Mutationsbeweis
#
# ENV:
#   COMDARE_FRISCHE  Pfad zum Pruefling (Default: <repo>/ci/frische_wache.sh).
#
# EXIT: 0 = alle Faelle gehalten
#       1 = mindestens ein Fall gerissen
#       2 = die Probe konnte nicht pruefen -- ausdruecklich KEIN Gruen.
#
# TESTKRITIK (T-9), was diese Probe NICHT deckt:
#   - Sie legt die Marker SELBST an, statt sie von ci/lauf_marker.sh schreiben zu
#     lassen. Das ist Absicht (die Faelle sollen unabhaengig vom Marker-Skript
#     beissen), hat aber den Preis, dass ein FORMAT-Bruch zwischen beiden
#     Skripten hier nicht auffaellt: schriebe lauf_marker.sh sein Feld kuenftig
#     "run_id=" statt "lauf_kennung=", blieben BEIDE Proben gruen. Fall F9 deckt
#     genau diese Naht ab, indem er EINEN Marker vom echten Skript erzeugen
#     laesst -- alles andere an der Naht bleibt ungedeckt und ist hier benannt.
#   - Sie prueft keine Nebenlaeufigkeit und keine Sonderrechte.
#   - Sie prueft nicht, ob der Runner-Workspace wirklich persistent ist; das ist
#     eine Eigenschaft der Runner-Konfiguration, nicht dieses Skripts.
#
# POSIX-sh (die CI ruft `sh`, das ist hier dash), ASCII-only, kein Python.
# Selbstcheck: Fall F10 prueft die eigene Registrierung (T-7).
# =============================================================================

set -eu
LC_ALL=C
export LC_ALL

SELBST_DIR=$(cd "$(dirname "$0")" && pwd)
SELBST="$SELBST_DIR/$(basename "$0")"
REPO=$(cd "$SELBST_DIR/../.." && pwd)
WACHE="${COMDARE_FRISCHE:-$REPO/ci/frische_wache.sh}"
MARKER_SKRIPT="$REPO/ci/lauf_marker.sh"
CI_YML="$REPO/.gitlab-ci.yml"

MODUS="${1:-}"
case "$MODUS" in
    ''|--selbstbiss) : ;;
    *) echo "AUFRUF: sh ci/tests/frische_wache_probe.sh [--selbstbiss]" >&2; exit 2 ;;
esac

if [ ! -f "$WACHE" ]; then
    echo "ABBRUCH: Pruefling '$WACHE' nicht gefunden." >&2
    exit 2
fi

WERK=$(mktemp -d) || exit 2
trap 'rm -rf "$WERK"' EXIT INT TERM
OUT="$WERK/_stdout"; ERR="$WERK/_stderr"

N_FALL=0; N_OK=0; N_ROT=0
RC=0
FALL_OK=1; FALL_NAME=''; FALL_LAUF=0

KOPF='permutation,strategie,median_ns,cache_misses_l1,pmc_available'
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
lauf() {   # $@ = Argumente an die Wache
    : > "$OUT"; : > "$ERR"
    FALL_LAUF=1
    set +e
    sh "$WACHE" "$@" > "$OUT" 2> "$ERR"
    RC=$?
    set -e
}
fordere_rc() { if [ "$RC" -ne "$1" ]; then reiss "rc=$RC, gefordert war rc=$1"; fi; }
fordere_literal() {
    if grep -qF -- "$2" "$1"; then :; else reiss "Text fehlt in $(basename "$1"): >>$2<<"; fi
}
fordere_kein_literal() {
    if grep -qF -- "$2" "$1"; then reiss "Text steht in $(basename "$1"), durfte NICHT: >>$2<<"; fi
}

# --- Fixtures: die Probe legt Marker SELBST an (Begruendung s. TESTKRITIK) ----
zelle() {   # $1=verzeichnis $2=lauf_kennung $3=modus $4=anzahl-datenzeilen
    mkdir -p "$1"
    printf '%s\n' "$KOPF" > "$1/measurements.csv"
    _i=1
    while [ "$_i" -le "$4" ]; do
        printf 'perm-%s,%s,%s,%s,1\n' "$_i" "$(token)" "$((1000 + _i))" "$((4000 + _i))" \
            >> "$1/measurements.csv"
        _i=$((_i + 1))
    done
    {
        echo "quelle=RUN_PROFILE"
        echo "modus=$3"
        echo "measured=$4"
        echo "resumed=0"
        echo "provisioned=0"
        echo "csv_ok=1"
        echo "lauf_kennung=$2"
    } > "$1/LAUF_MARKER.txt"
}
zelle_ohne_marker() {   # $1=verzeichnis $2=anzahl-datenzeilen
    mkdir -p "$1"
    printf '%s\n' "$KOPF" > "$1/measurements.csv"
    _i=1
    while [ "$_i" -le "$2" ]; do
        printf 'perm-%s,%s,1,1,1\n' "$_i" "$(token)" >> "$1/measurements.csv"
        _i=$((_i + 1))
    done
}
# D3-3b: eine Zelle, die NUR Kopfzeile und Leerzeilen geschrieben hat. Die drei
# Leerzeilen sind bewusst VERSCHIEDEN (voellig leer / nur Blanks / Tab+Blank) --
# eine Heilung, die nur `^$` verwirft, faellt an den letzten beiden.
zelle_leerzeilen() {   # $1=verzeichnis $2=lauf_kennung $3=modus
    mkdir -p "$1"
    printf '%s\n' "$KOPF" > "$1/measurements.csv"
    printf '\n'    >> "$1/measurements.csv"
    printf '   \n' >> "$1/measurements.csv"
    printf '\t \n' >> "$1/measurements.csv"
    {
        echo "quelle=RUN_PROFILE"
        echo "modus=$3"
        echo "measured=0"
        echo "resumed=0"
        echo "provisioned=0"
        echo "csv_ok=1"
        echo "lauf_kennung=$2"
    } > "$1/LAUF_MARKER.txt"
}

echo "============================================================================="
echo "PROBE FRISCHE-WACHE"
echo "  Pruefling : $WACHE"
echo "  Werkbank  : $WERK"
echo "  Modus     : ${MODUS:-nur-faelle}"
echo "============================================================================="

# =============================================================================
# F1  Ein Lauf, alles frisch -> rc=0, und die Zahlen muessen stimmen.
# =============================================================================
K1="$(wuerfel 1000 99999)-$(wuerfel 1000 99999)"
Z1=$(wuerfel 1 9)
fall "F1  1 Zelle dieses Laufs mit $Z1 Datenzeile(n) -> rc=0 mit Nenner"
D="$WERK/f1"; zelle "$D/a" "$K1" voll "$Z1"
lauf pruefen "$D" "$K1"
fordere_rc 0
fordere_literal "$OUT" "csv_gesamt=1"
fordere_literal "$OUT" "csv_dieser_lauf=1"
fordere_literal "$OUT" "datenzeilen_dieser_lauf=$Z1"
fordere_literal "$OUT" "csv_altbestand=0"
fordere_literal "$OUT" "FRISCHE-WACHE: OK"
fall_ende

# =============================================================================
# F2  ALLES Altbestand -> rc=1, csv_dieser_lauf=0, Altbestand NAMENTLICH.
# =============================================================================
KALT="$(wuerfel 1000 99999)-$(wuerfel 1000 99999)"
KNEU="$(wuerfel 100000 199999)-$(wuerfel 100000 199999)"
Z2=$(wuerfel 1 9)
fall "F2  nur Altbestand (fremde Kennung $KALT) -> rc=1, csv_dieser_lauf=0"
D="$WERK/f2"; zelle "$D/alt" "$KALT" voll "$Z2"
lauf pruefen "$D" "$KNEU"
fordere_rc 1
fordere_literal "$OUT" "csv_dieser_lauf=0"
fordere_literal "$OUT" "csv_altbestand=1"
fordere_literal "$OUT" "$D/alt/measurements.csv"
fordere_literal "$OUT" "lauf_kennung=$KALT"
fordere_literal "$OUT" "GEMELDET, NIE GELOESCHT"
fordere_literal "$ERR" "csv_dieser_lauf=0 bei csv_gesamt=1"
fall_ende

# =============================================================================
# F3  RETRY-FESTIGKEIT: gleiche Pipeline, andere Job-Id -> der Vorversuch ist
#     Altbestand. Waere die Kennung nur die Pipeline-Id, waere er "dieser Lauf".
#     DER KOEDER: die Probe prueft ZUERST, dass beide Kennungen dieselbe
#     Pipeline-Id tragen -- sonst waere der Fall trivial.
# =============================================================================
PIPE=$(wuerfel 1000 99999); JOBA=$(wuerfel 1 4000); JOBB=$((JOBA + 1 + $(wuerfel 1 50)))
fall "F3  Retry: Pipeline $PIPE, Job $JOBA -> $JOBB -> Vorversuch ist Altbestand"
if [ "${PIPE}-${JOBA}" = "${PIPE}-${JOBB}" ]; then
    echo "  [ABBRUCH] Koeder untauglich: beide Kennungen identisch." >&2; exit 2
fi
echo "        Koeder: gleiche Pipeline-Id ($PIPE), verschiedene Job-Ids ($JOBA vs $JOBB)."
D="$WERK/f3"; zelle "$D/versuch1" "${PIPE}-${JOBA}" voll "$(wuerfel 1 5)"
lauf pruefen "$D" "${PIPE}-${JOBB}"
fordere_rc 1
fordere_literal "$OUT" "csv_altbestand=1"
fordere_literal "$OUT" "lauf_kennung=${PIPE}-${JOBA}"
fall_ende

# =============================================================================
# F4  CSV OHNE Marker -> eigene Menge, weder frisch noch alt.
# =============================================================================
K4="$(wuerfel 1000 99999)-$(wuerfel 1000 99999)"
fall "F4  1 CSV ohne Marker neben 1 frischen -> csv_ohne_marker=1, rc=0"
D="$WERK/f4"; zelle "$D/frisch" "$K4" voll "$(wuerfel 1 5)"
zelle_ohne_marker "$D/nackt" "$(wuerfel 1 5)"
lauf pruefen "$D" "$K4"
fordere_rc 0
fordere_literal "$OUT" "csv_gesamt=2"
fordere_literal "$OUT" "csv_dieser_lauf=1"
fordere_literal "$OUT" "csv_ohne_marker=1"
fordere_literal "$OUT" "csv_altbestand=0"
fordere_literal "$OUT" "$D/nackt/measurements.csv"
fall_ende

# =============================================================================
# F5  ZWEI-LAUF-KOEDER, Gegenrichtung: Altzelle mit Zeilen + Neuzelle MIT
#     Zeilen -> GRUEN. Ohne diesen Fall koennte die Wache konstant rot sein.
# =============================================================================
KA="$(wuerfel 1000 49999)-$(wuerfel 1000 49999)"
KN="$(wuerfel 50000 99999)-$(wuerfel 50000 99999)"
ZA=$(wuerfel 1 6); ZN=$(wuerfel 1 6)
fall "F5  Koeder Richtung A: Alt($ZA Zeilen) + Neu($ZN Zeilen) -> rc=0"
D="$WERK/f5"; zelle "$D/altzelle" "$KA" voll "$ZA"; zelle "$D/neuzelle" "$KN" voll "$ZN"
lauf pruefen "$D" "$KN"
fordere_rc 0
fordere_literal "$OUT" "datenzeilen_dieser_lauf=$ZN"
fordere_literal "$OUT" "datenzeilen_altbestand=$ZA"
fordere_literal "$OUT" "FRISCHE-WACHE: OK"
fall_ende

# =============================================================================
# F6  ZWEI-LAUF-KOEDER, DER FALL DES PAKETS: Altzelle MIT Datenzeile,
#     Neuzelle NUR Kopfzeile -> ROT. Die fremde Zeile maskiert den Leerlauf.
#     Zum Beweis, dass die Maskierung real ist, faehrt der Fall zusaetzlich die
#     AUSBEUTE-Wache ueber denselben Baum und verlangt, dass SIE gruen ist --
#     die Frische-Wache sagt hier also etwas, das die andere nicht sagen kann.
# =============================================================================
KA="$(wuerfel 1000 49999)-$(wuerfel 1000 49999)"
KN="$(wuerfel 50000 99999)-$(wuerfel 50000 99999)"
ZA=$(wuerfel 1 6)
fall "F6  Koeder Richtung B: Alt($ZA Zeilen) + Neu(0 Zeilen, modus=voll) -> rc=1"
D="$WERK/f6"; zelle "$D/altzelle" "$KA" voll "$ZA"; zelle "$D/neuzelle" "$KN" voll 0
AUSBEUTE="$REPO/ci/mess_ausbeute_wache.sh"
if [ -f "$AUSBEUTE" ]; then
    set +e
    sh "$AUSBEUTE" "$D" 1 voll > "$WERK/f6_ausbeute" 2>&1
    RC_AUS=$?
    set -e
    echo "        Gegenstueck: ci/mess_ausbeute_wache.sh auf demselben Baum -> rc=$RC_AUS"
    if [ "$RC_AUS" -ne 0 ]; then
        reiss "die Ausbeute-Wache ist hier rot (rc=$RC_AUS) -- dann belegt F6 keine Maskierung"
    fi
    grep -F 'Datenzeile(n) insgesamt' "$WERK/f6_ausbeute" | sed 's/^/        | /'
else
    reiss "ci/mess_ausbeute_wache.sh fehlt -- die Maskierung ist nicht belegbar"
fi
lauf pruefen "$D" "$KN"
fordere_rc 1
fordere_literal "$OUT" "csv_dieser_lauf=1"
fordere_literal "$OUT" "datenzeilen_dieser_lauf=0"
fordere_literal "$OUT" "datenzeilen_altbestand=$ZA"
fordere_literal "$ERR" "aus FREMDEN Laeufen liegen im selben Verzeichnis"
fall_ende

# =============================================================================
# F6b D3-3b -- DIESELBE MASKIERUNG, ABER DURCH EIGENE LEERZEILEN.
#     F6 oben deckt nur die Neuzelle mit NUR Kopfzeile ab. Schreibt dieselbe
#     Zelle Kopfzeile PLUS Leerzeilen, war der Befund bis 10.08.2026 unsichtbar:
#     `Datenzeilen = Zeilen - 1` ergab datenzeilen_dieser_lauf=3, das
#     Maskierungs-Gate haengt an `== 0` -- und blieb still. Am Objekt gemessen,
#     nicht vermutet: gegen die HEAD-Fassung vor der Heilung meldet dieser Fall
#     rc=0 statt rc=1.
#     Der Fall ist damit die Naht zwischen D3-8 (Maskierung) und D3-3b
#     (Leerzeile ist kein Messwert): keins der beiden Gates faengt ihn allein.
# =============================================================================
KA="$(wuerfel 1000 49999)-$(wuerfel 1000 49999)"
KN="$(wuerfel 50000 99999)-$(wuerfel 50000 99999)"
ZA=$(wuerfel 1 6)
fall "F6b Alt($ZA Zeilen) + Neu(nur Kopf + 3 LEERZEILEN, modus=voll) -> rc=1"
D="$WERK/f6b"; zelle "$D/altzelle" "$KA" voll "$ZA"
zelle_leerzeilen "$D/neuzelle" "$KN" voll
lauf pruefen "$D" "$KN"
fordere_rc 1
fordere_literal "$OUT" "csv_dieser_lauf=1"
fordere_literal "$OUT" "datenzeilen_dieser_lauf=0"
fordere_literal "$OUT" "datenzeilen_altbestand=$ZA"
fordere_literal "$OUT" "datenzeilen_verworfen=3"
fordere_literal "$ERR" "aus FREMDEN Laeufen liegen im selben Verzeichnis"
fall_ende

# =============================================================================
# F7  Derselbe Zustand, aber der frische Marker sagt provision_only -> GRUEN.
#     Ein Lauf, der per Bauart nicht misst, darf an diesem Gate nicht sterben.
# =============================================================================
KA="$(wuerfel 1000 49999)-$(wuerfel 1000 49999)"
KN="$(wuerfel 50000 99999)-$(wuerfel 50000 99999)"
ZA=$(wuerfel 1 6)
fall "F7  wie F6, aber modus=provision_only -> rc=0 (misst per Bauart nicht)"
D="$WERK/f7"; zelle "$D/altzelle" "$KA" voll "$ZA"
zelle "$D/neuzelle" "$KN" provision_only 0
lauf pruefen "$D" "$KN"
fordere_rc 0
fordere_literal "$OUT" "davon 0 Datei(en) dieses Laufs mit modus=voll"
fordere_literal "$OUT" "FRISCHE-WACHE: OK"
fall_ende

# =============================================================================
# F8  ALTBESTAND WIRD NIE GELOESCHT -- am Datei-Bestand geprueft, nicht am Text.
#     Zusaetzlich der statische Nachweis: die Wache enthaelt keine Loeschung
#     ausser dem mktemp-trap.
# =============================================================================
KA="$(wuerfel 1000 49999)-$(wuerfel 1000 49999)"
KN="$(wuerfel 50000 99999)-$(wuerfel 50000 99999)"
ALT_TOK=$(token)
fall "F8  Altbestand ueberlebt den Lauf der Wache (Datei UND Inhalt unveraendert)"
D="$WERK/f8"; mkdir -p "$D/altzelle"
printf '%s\nperm-1,%s,1,1,1\n' "$KOPF" "$ALT_TOK" > "$D/altzelle/measurements.csv"
printf 'quelle=RUN_PROFILE\nmodus=voll\nlauf_kennung=%s\n' "$KA" > "$D/altzelle/LAUF_MARKER.txt"
SUM_VOR=$(sha256sum "$D/altzelle/measurements.csv" | cut -d' ' -f1)
set +e; sh "$WACHE" pruefen "$D" "$KN" > /dev/null 2>&1; set -e
if [ ! -f "$D/altzelle/measurements.csv" ]; then
    reiss "die Altbestands-CSV wurde GELOESCHT -- Messdaten bleiben, ausnahmslos"
else
    SUM_NACH=$(sha256sum "$D/altzelle/measurements.csv" | cut -d' ' -f1)
    if [ "$SUM_VOR" != "$SUM_NACH" ]; then
        reiss "die Altbestands-CSV wurde VERAENDERT (sha256 $SUM_VOR -> $SUM_NACH)"
    else
        echo "        Altbestand unveraendert (sha256 $SUM_VOR), Koeder-Token $ALT_TOK noch drin."
    fi
    grep -qF "$ALT_TOK" "$D/altzelle/measurements.csv" || reiss "Koeder-Token verschwunden"
fi
# ZAEHLWEISE, ausdruecklich: NUR Nicht-Kommentarzeilen. Der erste Versuch zaehlte
# `grep -cE '(rm|mv|unlink) '` ueber die ganze Datei und meldete 3 statt 1 -- die
# zwei Zusatztreffer waren PROSA ("ruft weder rm noch find -delete noch mv").
# Genau die Fehlerklasse dieses Projekts: das Messgeraet war richtig, der
# Gegenstand war der Kommentartext. awk schneidet die Kommentare vorher weg.
KEIN_KOMMENTAR="$WERK/_wache_ohne_kommentar"
awk '{ zeile = $0; sub(/^[ \t]+/, "", zeile); if (substr(zeile, 1, 1) != "#") print }' \
    "$WACHE" > "$KEIN_KOMMENTAR"
N_CODE=$(awk 'END{print NR+0}' "$KEIN_KOMMENTAR")
N_RM=$(grep -cE '(^|[^[:alnum:]_])(rm|mv|unlink|-delete)([^[:alnum:]_]|$)' "$KEIN_KOMMENTAR" || true)
N_RM_TMP=$(grep -cF 'rm -f "$TMP"' "$KEIN_KOMMENTAR" || true)
echo "        statisch: $N_RM von $N_CODE Code-Zeilen mit rm/mv/unlink/-delete,"
echo "                  davon $N_RM_TMP der mktemp-trap. (Kommentare ausgeschnitten.)"
if [ "$N_RM" != "$N_RM_TMP" ]; then
    reiss "die Wache enthaelt eine Loeschung ausserhalb des mktemp-traps"
fi
# Koeder: das Zaehlwerk muss eine eingeschmuggelte Loeschung auch FINDEN.
KOEDER_RM="$WERK/_koeder_rm.sh"
printf 'echo harmlos\nrm -rf "$ALT"\n' > "$KOEDER_RM"
K_RM=$(grep -cE '(^|[^[:alnum:]_])(rm|mv|unlink|-delete)([^[:alnum:]_]|$)' "$KOEDER_RM" || true)
if [ "$K_RM" != "1" ]; then
    echo "  [ABBRUCH] Koeder biss nicht: 1 Loeschung geschrieben, $K_RM gefunden." >&2
    exit 2
fi
echo "        Koeder beisst: eingeschmuggeltes 'rm -rf' wird gefunden ($K_RM von 1)."
fall_ende

# =============================================================================
# F9  DIE NAHT zum Marker-Skript: EIN Marker wird vom ECHTEN ci/lauf_marker.sh
#     erzeugt und muss von dieser Wache gelesen werden. Ohne diesen Fall koennte
#     ein Feld-Umbenennen beide Proben gruen lassen (s. TESTKRITIK).
# =============================================================================
fall "F9  Naht: Marker vom echten ci/lauf_marker.sh -> wird als 'dieser Lauf' erkannt"
if [ ! -f "$MARKER_SKRIPT" ]; then
    reiss "ci/lauf_marker.sh fehlt -- die Naht ist nicht pruefbar"
else
    D="$WERK/f9"; mkdir -p "$D/e4"
    ZN9=$(wuerfel 1 5)
    printf '%s\n' "$KOPF" > "$D/e4/measurements.csv"
    _i=1
    while [ "$_i" -le "$ZN9" ]; do
        printf 'perm-%s,%s,1,1,1\n' "$_i" "$(token)" >> "$D/e4/measurements.csv"
        _i=$((_i + 1))
    done
    P9=$(wuerfel 1000 99999); J9=$(wuerfel 1000 99999)
    printf 'RUN_PROFILE fertig: measured=%s resumed=0 provisioned=0 csv_ok=1 %s %s\n' \
        "$ZN9" "$PFEIL" "$D/e4/measurements.csv" > "$D/log"
    set +e
    CI_PIPELINE_ID="$P9" CI_JOB_ID="$J9" sh "$MARKER_SKRIPT" schreiben "$D/log" "$D" > /dev/null 2>&1
    RC_M=$?
    set -e
    if [ "$RC_M" -ne 0 ]; then
        reiss "ci/lauf_marker.sh schreiben scheiterte (rc=$RC_M) -- Naht nicht pruefbar"
    else
        lauf pruefen "$D" "${P9}-${J9}"
        fordere_rc 0
        fordere_literal "$OUT" "csv_dieser_lauf=1"
        fordere_literal "$OUT" "datenzeilen_dieser_lauf=$ZN9"
        fordere_kein_literal "$OUT" "csv_ohne_marker=1"
    fi
fi
fall_ende

# =============================================================================
# F9b 0 CSV -> rc=2. Unpruefbar ist nicht gruen.
# =============================================================================
fall "F9b 0 CSV unter der Wurzel -> rc=2 (kein Gruen ohne Pruefung)"
D="$WERK/f9b"; mkdir -p "$D"
lauf pruefen "$D" "egal-$(token)"
fordere_rc 2
fordere_literal "$ERR" "Kein Gruen ohne Pruefung."
fall_ende

fall "F9c Wurzel existiert nicht -> rc=2"
lauf pruefen "$WERK/gibt_es_nicht_$(token)" "egal"
fordere_rc 2
fordere_literal "$ERR" "Kein Gruen ohne Pruefung."
fall_ende

# =============================================================================
# F10 REGISTRIERUNG IST TEIL DES TESTS (T-7), mit beissendem Koeder.
# =============================================================================
fall "F10 eigene Registrierung in .gitlab-ci.yml, ohne allow_failure"
if [ ! -f "$CI_YML" ]; then
    echo "ABBRUCH: $CI_YML fehlt." >&2; exit 2
fi
AUFRUF='sh ci/tests/frische_wache_probe.sh'
K=$(wuerfel 1 4)
KOEDER="$WERK/koeder_ci.yml"
: > "$KOEDER"
_i=1
while [ "$_i" -le "$K" ]; do
    printf '      %s   # %s\n' "$AUFRUF" "$(token)" >> "$KOEDER"
    _i=$((_i + 1))
done
K_IST=$(grep -cF -- "$AUFRUF" "$KOEDER" || true)
if [ "$K_IST" != "$K" ]; then
    echo "  [ABBRUCH] Koeder biss NICHT: $K geschrieben, $K_IST gefunden." >&2; exit 2
fi
echo "        Koeder beisst: $K gewuerfelte Vorkommen geschrieben, $K_IST gefunden."
N_AUFRUF=$(grep -cF -- "$AUFRUF" "$CI_YML" || true)
if [ "$N_AUFRUF" = "0" ]; then
    reiss "kein Aufruf von '$AUFRUF' in .gitlab-ci.yml"
else
    echo "        $N_AUFRUF Aufruf(e) in .gitlab-ci.yml."
fi
JOB='test:frische-wache-probe:'
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
    if [ "$N_AF" != "0" ]; then reiss "der Job traegt allow_failure"; fi
fi
fall_ende

# =============================================================================
# F11 ABNAHME D3-8: beide Mess-Jobs rufen die Frische-Wache.
# =============================================================================
fall "F11 Abnahme: 'frische_wache.sh pruefen' in BEIDEN Mess-Jobs"
N_FW=$(grep -cF -- 'ci/frische_wache.sh pruefen' "$CI_YML" || true)
echo "        .gitlab-ci.yml: $N_FW Aufruf(e) (Nenner: 2 Mess-Jobs -- smoke + golden-320)."
if [ "$N_FW" -lt 2 ]; then
    reiss "nur $N_FW von 2 Mess-Jobs rufen die Frische-Wache"
fi
fall_ende

echo "============================================================================="
echo "NENNER: $N_FALL Faelle gefahren, $N_OK gehalten, $N_ROT gerissen."
echo "        Pruefling: $WACHE"
echo "============================================================================="

if [ "$N_ROT" -ne 0 ]; then
    echo "PROBE ROT: $N_ROT von $N_FALL Faellen gerissen." >&2
    exit 1
fi
echo "PROBE GRUEN: $N_OK von $N_FALL Faellen gehalten."

# =============================================================================
# --selbstbiss (T-1)
# =============================================================================
[ "$MODUS" = "--selbstbiss" ] || exit 0

echo ""
echo "============================================================================="
echo "SELBSTBISS: Wegwerf-Mutanten der Wache -- die Probe MUSS an ihnen rot werden."
echo "============================================================================="

ORIG_ZEILEN=$(awk 'END{print NR}' "$WACHE")
echo "  Pruefling: $ORIG_ZEILEN Zeilen (Nenner der Mutation)."

N_MUT=0; N_MUT_GEBISSEN=0
mutant_fahren() {   # $1=Kurzname $2=Mutant
    N_MUT=$((N_MUT + 1))
    if cmp -s "$WACHE" "$2"; then
        echo "  [ABBRUCH] Mutation '$1' griff NICHT: byte-gleich zum Original." >&2
        exit 2
    fi
    chmod +x "$2"
    _log="$WERK/mutlog_$N_MUT.txt"
    echo ""
    echo "  --- Mutant '$1' ($(awk 'END{print NR}' "$2") Zeilen) ---"
    set +e
    COMDARE_FRISCHE="$2" sh "$SELBST" > "$_log" 2>&1
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

# M1: das Altbestands-Gate verliert sein rot.
MU="$WERK/mut_altgate.sh"
awk '
    /^        echo "FEHLER: KEINE von \$N_CSV measurements.csv traegt die Kennung/ { drin = 1 }
    drin && /^        exit 1$/ { drin = 0; next }
    { print }
' "$WACHE" > "$MU"
mutant_fahren "M1  ohne exit 1 im Altbestands-Gate (F2/F3 muessen beissen)" "$MU"

# M2: das Maskierungs-Gate verliert sein rot -- der eigentliche Befund.
MU="$WERK/mut_maskierung.sh"
awk '
    /^        echo "FEHLER: dieser Lauf hat 0 Datenzeile\(n\) erzeugt/ { drin = 1 }
    drin && /^        exit 1$/ { drin = 0; next }
    { print }
' "$WACHE" > "$MU"
mutant_fahren "M2  ohne exit 1 im Maskierungs-Gate (nur F6 toetet ihn)" "$MU"

# M3: die Kennung wird nicht mehr verglichen -- alles gilt als "dieser Lauf".
MU="$WERK/mut_kennung.sh"
sed 's|if \[ "\$_k" = "\$KENNUNG" \]; then|if [ -n "$_k" ]; then|' "$WACHE" > "$MU"
mutant_fahren "M3  ohne Kennungs-Vergleich (jede CSV gilt als frisch)" "$MU"

# M4: die Datenzeilen werden nicht mehr gezaehlt -- der zweite Ausgang verhungert.
# Die Zieladresse ist seit D3-3b (10.08.2026) die Zuweisung aus dem awk-Paar und
# nicht mehr der alte `-le 1`-Zweig; die alte Adresse traf nichts mehr. Dass die
# neue trifft, ist nicht behauptet, sondern erzwungen: mutant_fahren bricht mit
# rc=2 ab, wenn der Mutant byte-gleich zum Original bleibt.
MU="$WERK/mut_zeilen.sh"
sed 's|^        _daten=${_paar##\* }$|        _daten=1|' "$WACHE" > "$MU"
mutant_fahren "M4  Datenzeilen konstant 1 (Maskierung wird unsichtbar)" "$MU"

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
