#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  HOST-KLASSEN-GEGENORAKEL  --  bestaetigt CMAKE SELBST die Klassen-Leiter
#  des Host-Klassen-Berichts?  (W0b-7-Nachsatz zu D2-G5, 09.08.2026)
#  GOAL v8 Teil VII/VIII, TDD-Vertrag T-4/T-5.
# =============================================================================
#
# DIE LUECKE, DIE ES SCHLIESST (Landungsbericht 3b13bf4a, 08.08., Punkt 3):
# scripts/ci_host_klassen_bericht.sh ist ein QUELLTEXT-Scan. Sein Selbsttest
# beweist, dass der Scanner mit handgezaehlten Fixtures uebereinstimmt -- er
# beweist NICHT, dass CMake genau diese Registrierungen host-abhaengig macht.
# Solange dieser Lauf fehlte, war die Leiter 6/4/2 eine sehr gut gestuetzte
# Regex-Aussage und keine von CMake bestaetigte.
#
# WAS ES TUT. Derselbe Baum wird DREIMAL konfiguriert, die Host-Antworten als
# -D-Preset vorgegeben (check_cxx_source_runs laesst eine VORDEFINIERTE
# Variable stehen -- die Probe laeuft dann gar nicht, es gibt nichts zu raten
# und nichts, das SIGILLen koennte):
#     Klasse avx512f   -DCOMDARE_HOST_RUNS_AVX2=1 -DCOMDARE_HOST_RUNS_AVX512F=1
#     Klasse avx2      -DCOMDARE_HOST_RUNS_AVX2=1 -DCOMDARE_HOST_RUNS_AVX512F=0
#     Klasse basis     -DCOMDARE_HOST_RUNS_AVX2=0 -DCOMDARE_HOST_RUNS_AVX512F=0
# Dann werden die `ctest -N`-NAMENSLISTEN gedifft:
#     avx512f minus avx2  MUSS exakt die avx512f-Stufe der Leiter sein,
#     avx2 minus basis    MUSS exakt die avx2-Stufe sein,
#     die GEGENRICHTUNGEN muessen LEER sein (nichts darf ERSCHEINEN, wenn eine
#     Faehigkeit wegfaellt).
# Wo der Bericht einen Namen 1:1 behauptet, wird der NAME verlangt, nicht nur
# die Zahl. Zum Schluss bekommt der Bericht jede echte Liste als
# --ctest-liste-Gegeneingang (je Klasse passend, muss gruen sein) und EINMAL
# absichtlich GEKREUZT (Klasse basis gegen die avx512f-Liste, muss beissen --
# eine Gegenprobe, die nie beisst, ist keine).
#
# WEIL DIE HOST-ANTWORTEN PRESET SIND, ist dieser Lauf MASCHINENUNABHAENGIG:
# er faellt auf prod1 (Zen 5, avx512f) und prod2 (Raptor Lake, kein AVX-512)
# identisch aus. Die Frage "erkennt die Maschine ihre ISA richtig?" ist NICHT
# sein Gegenstand -- die deckt Fall O1 des Bericht-Selbsttests (cpuinfo gegen
# selbst uebersetzte CPUID-Probe) und zweimaschinig die ce-Sichtbarkeits-Wache
# (461 prod1 / 457 prod2-CI, Differenz exakt die vier Gatter-Eintraege).
#
# AUFRUF:  sh scripts/ci_host_klassen_gegenorakel.sh [OPTIONEN]
#   --quelle PFAD    CMake-Quellbaum, der vermessen wird. OHNE Angabe: das
#                    ce-Submodul dieses Repos -- dann bricht das Orakel ab,
#                    wenn der Arbeitsbaum NICHT auf dem gitlink steht (ein
#                    Configure haette sonst einen anderen Gegenstand vermessen
#                    als das Repo deklariert). In der CI (rekursiver Checkout)
#                    ist gitlink-Gleichstand der Normalzustand.
#   --bericht PFAD   Pfad zum Host-Klassen-Bericht (Vorgabe: Schwesterskript
#                    in diesem scripts/-Verzeichnis).
#
# EXIT:  0 = CMake bestaetigt die Leiter, Stufe fuer Stufe
#        1 = BEFUND: mindestens ein Widerspruch zwischen Quelltext-Leiter und
#            CMake-Verhalten (jede Stelle namentlich)
#        2 = konnte nicht messen (fail-closed, ausdruecklich KEIN Gruen)
#
# POSIX-sh, ASCII-only, kein Python (Hausdoktrin).
# =============================================================================

set -eu
LC_ALL=C
export LC_ALL

QUELLE=""
BERICHT=""

while [ $# -gt 0 ]; do
    case "$1" in
        --quelle)  QUELLE="${2:-}"; shift 2 ;;
        --bericht) BERICHT="${2:-}"; shift 2 ;;
        --help|-h) sed -n '2,60p' "$0"; exit 0 ;;
        *) echo "ABBRUCH: unbekannte Option '$1'. --help zeigt den Aufruf." >&2; exit 2 ;;
    esac
done

# Das Schwesterskript liegt neben diesem hier. $0 dient NUR dazu, das
# scripts/-Verzeichnis zu finden -- die MESS-Wurzel kommt nie aus $0 (das war
# die Falle von ci_diff_ascii_width_guard.sh, die den falschen Baum mass).
SKRIPT_D=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P) || exit 2
REPO=$(git -C "$SKRIPT_D" rev-parse --show-toplevel 2>/dev/null) || {
    echo "ABBRUCH: $SKRIPT_D liegt in keinem git-Baum -- Repo-Wurzel nicht bestimmbar." >&2; exit 2; }
[ -n "$BERICHT" ] || BERICHT="$REPO/scripts/ci_host_klassen_bericht.sh"
[ -r "$BERICHT" ] || { echo "ABBRUCH: Bericht '$BERICHT' nicht lesbar." >&2; exit 2; }

command -v cmake >/dev/null 2>&1 || { echo "ABBRUCH: cmake fehlt." >&2; exit 2; }
command -v ctest >/dev/null 2>&1 || { echo "ABBRUCH: ctest fehlt." >&2; exit 2; }

SUBPFAD="Code/external/comdare-cache-engine"
QUELLE_ART="vorgabe"
if [ -z "$QUELLE" ]; then
    QUELLE_ART="submodul"
    QUELLE="$REPO/$SUBPFAD"
    [ -d "$QUELLE" ] || { echo "ABBRUCH: Submodul '$SUBPFAD' liegt nicht auf Platte." >&2; exit 2; }
    # NICHT nur rev-parse: bei leerem Submodul-Verzeichnis antwortet git fuer
    # das ELTERN-Repo (Falle aus dem Bericht, Abschnitt 2).
    _top=$(git -C "$QUELLE" rev-parse --show-toplevel 2>/dev/null || echo "")
    [ "$_top" = "$QUELLE" ] || {
        echo "ABBRUCH: Submodul '$SUBPFAD' ist nicht ausgecheckt." >&2; exit 2; }
    IST=$(git -C "$QUELLE" rev-parse HEAD 2>/dev/null || echo "?")
    SOLL=$(git -C "$REPO" ls-tree HEAD -- "$SUBPFAD" 2>/dev/null | awk '{print $3}')
    if [ -z "$SOLL" ] || [ "$IST" != "$SOLL" ]; then
        echo "ABBRUCH: Submodul-Arbeitsbaum ($IST) steht NICHT auf dem gitlink ($SOLL)." >&2
        echo "         Ein Configure haette einen anderen Gegenstand vermessen, als dieses" >&2
        echo "         Repo deklariert. Entweder Submodul auf den gitlink bringen oder mit" >&2
        echo "         --quelle auf einen korrekten Checkout zeigen (fail-closed, T-8)." >&2
        exit 2
    fi
else
    [ -d "$QUELLE" ] || { echo "ABBRUCH: --quelle '$QUELLE' ist kein Verzeichnis." >&2; exit 2; }
    QUELLE=$(cd "$QUELLE" && pwd -P) || exit 2
    git -C "$QUELLE" rev-parse --git-dir >/dev/null 2>&1 || {
        echo "ABBRUCH: --quelle '$QUELLE' ist kein git-Baum (der Bericht braucht die git-Dateiliste)." >&2
        exit 2; }
    IST=$(git -C "$QUELLE" rev-parse --short HEAD 2>/dev/null || echo "kein-commit")
fi
[ -f "$QUELLE/CMakeLists.txt" ] || {
    echo "ABBRUCH: '$QUELLE' traegt kein CMakeLists.txt -- nichts zu konfigurieren." >&2; exit 2; }

TMP=$(mktemp -d) || exit 2
trap 'rm -rf "$TMP"' EXIT INT TERM

BEFUND=0

feld() { sed -n "s/.*[[:space:]]$2=\([^[:space:]]*\).*/\1/p" "$1" | head -1; }

echo "============================================================================="
echo " HOST-KLASSEN-GEGENORAKEL   (scripts/ci_host_klassen_gegenorakel.sh)"
echo "============================================================================="
echo "KENNUNG        quelle=$QUELLE ($QUELLE_ART)"
echo "               stand=$IST maschine=$(uname -n) $(cmake --version | head -1)"

# =============================================================================
#  1. DIE BEHAUPTUNG -- die Leiter des Quelltext-Scans (erste Quelle)
# =============================================================================
sh "$BERICHT" --wurzel "$QUELLE" --klasse avx512f > "$TMP/behauptung.txt" 2>&1 && BRC=0 || BRC=$?
if [ "$BRC" != 0 ]; then
    echo "ABBRUCH: der Host-Klassen-Bericht selbst meldet rc=$BRC auf '$QUELLE' --" >&2
    echo "         ohne widerspruchsfreie Leiter gibt es nichts zu bestaetigen. Sein Schluss:" >&2
    tail -5 "$TMP/behauptung.txt" | sed 's/^/         | /' >&2
    exit 2
fi
B_G=$(feld "$TMP/behauptung.txt" registrierungen_gesamt)
B_512=$(feld "$TMP/behauptung.txt" isa_gattiert_avx512f)
B_2=$(feld "$TMP/behauptung.txt" isa_gattiert_avx2)
case "$B_G$B_512$B_2" in *[!0-9]*|"")
    echo "ABBRUCH: Leiter aus dem Bericht nicht parsebar (gesamt='$B_G' avx512f='$B_512' avx2='$B_2')." >&2
    exit 2 ;;
esac

# Namentlich 1:1 behauptete ISA-Registrierungen je Stufe. Nicht-1:1-Stellen
# ('?...'-Namen, '${'-Namen) behaupten nur die ZAHL -- dort verlangt das Orakel
# die Kardinalitaet, nicht den Namen.
awk '/^ISA-GATTIERTE REGISTRIERUNGEN/ { an = 1; next }
     an && /^----/ { an = 0 }
     an && NF >= 2 { print $1 " " $2 }' "$TMP/behauptung.txt" > "$TMP/isa_stellen.txt"
awk '$1 == "avx512f" && $2 !~ /^\?/ && $2 !~ /\$\{/ { print $2 }' "$TMP/isa_stellen.txt" | sort > "$TMP/soll_512.txt"
awk '$1 == "avx2"    && $2 !~ /^\?/ && $2 !~ /\$\{/ { print $2 }' "$TMP/isa_stellen.txt" | sort > "$TMP/soll_2.txt"
N_SOLL512=$(awk 'END{print NR+0}' "$TMP/soll_512.txt")
N_SOLL2=$(awk 'END{print NR+0}' "$TMP/soll_2.txt")

echo "BEHAUPTUNG     (Quelltext-Scan) registrierungen_gesamt=$B_G"
echo "               behauptet_avx512f=$B_512 (davon namentlich 1:1: $N_SOLL512)"
echo "               behauptet_avx2=$B_2 (davon namentlich 1:1: $N_SOLL2)"

# =============================================================================
#  2. DIE MESSUNG -- drei Configures, Host-Antworten als Preset (zweite Quelle)
# =============================================================================
GEN=""
command -v ninja >/dev/null 2>&1 && GEN="-G Ninja"

konfiguriere() {
    _k="$1"; _avx2="$2"; _avx512="$3"
    # $GEN absichtlich UNquotiert: leer oder zwei Worte ("-G" "Ninja").
    # shellcheck disable=SC2086
    cmake -S "$QUELLE" -B "$TMP/bau-$_k" $GEN \
          -DCOMDARE_BUILD_TESTS=ON \
          -DCOMDARE_HOST_RUNS_AVX2="$_avx2" -DCOMDARE_HOST_RUNS_AVX512F="$_avx512" \
          > "$TMP/conf-$_k.log" 2>&1 || {
        echo "ABBRUCH: Configure Klasse $_k gescheitert. Letzte Zeilen:" >&2
        tail -5 "$TMP/conf-$_k.log" | sed 's/^/         | /' >&2
        exit 2
    }
    ctest --test-dir "$TMP/bau-$_k" -N > "$TMP/roh-$_k.txt" 2>&1 || {
        echo "ABBRUCH: ctest -N Klasse $_k gescheitert." >&2; exit 2; }
    # Nur "Test #N:"-Zeilen sind Namen. Das Muster laesst die rechtsbuendige
    # Polsterung zu ("Test  #1:") -- 'Test #' mit genau einem Leerzeichen
    # frisst die Eintraege 1..99 (heute selbst hineingelaufen).
    sed -n 's/^[[:space:]]*Test[[:space:]]*#[0-9]*:[[:space:]]*//p' "$TMP/roh-$_k.txt" \
        | sort > "$TMP/namen-$_k.txt"
}

konfiguriere avx512f 1 1
konfiguriere avx2    1 0
konfiguriere basis   0 0

E512=$(awk 'END{print NR+0}' "$TMP/namen-avx512f.txt")
E2=$(awk 'END{print NR+0}' "$TMP/namen-avx2.txt")
EB=$(awk 'END{print NR+0}' "$TMP/namen-basis.txt")
[ "$E512" -gt 0 ] || {
    echo "ABBRUCH: 0 ctest-Eintraege im avx512f-Baum -- eine leere Gegenprobe ist keine." >&2
    exit 2
}

comm -23 "$TMP/namen-avx512f.txt" "$TMP/namen-avx2.txt" > "$TMP/diff_512.txt"
comm -13 "$TMP/namen-avx512f.txt" "$TMP/namen-avx2.txt" > "$TMP/rueck_512.txt"
comm -23 "$TMP/namen-avx2.txt" "$TMP/namen-basis.txt"   > "$TMP/diff_2.txt"
comm -13 "$TMP/namen-avx2.txt" "$TMP/namen-basis.txt"   > "$TMP/rueck_2.txt"
G512=$(awk 'END{print NR+0}' "$TMP/diff_512.txt")
G2=$(awk 'END{print NR+0}' "$TMP/diff_2.txt")
R512=$(awk 'END{print NR+0}' "$TMP/rueck_512.txt")
R2=$(awk 'END{print NR+0}' "$TMP/rueck_2.txt")

echo "-----------------------------------------------------------------------------"
echo "MESSUNG        (drei Configures desselben Baums, Host-Antworten als Preset)"
echo "ZAHL 1  eintraege_avx512f=$E512 eintraege_avx2=$E2 eintraege_basis=$EB"
echo "        (ctest -N-Namenslisten; Nenner der Messung, je Klasse einzeln)"
echo "ZAHL 2  gemessen_avx512f=$G512 behauptet_avx512f=$B_512"
echo "        gemessen_avx2=$G2 behauptet_avx2=$B_2"
echo "        (gemessen = was CMake beim Wegfall der Stufe verschwinden laesst)"
if [ "$G512" -gt 0 ]; then
    echo "        verschwindet ohne AVX-512F:"
    sed 's/^/          - /' "$TMP/diff_512.txt"
fi
if [ "$G2" -gt 0 ]; then
    echo "        verschwindet ohne AVX2:"
    sed 's/^/          - /' "$TMP/diff_2.txt"
fi

# =============================================================================
#  3. DER VERGLEICH -- Stufe fuer Stufe, Name fuer Name
# =============================================================================
if [ "$G512" != "$B_512" ]; then
    echo "BEFUND: avx512f-Stufe -- CMake laesst $G512 Eintraege verschwinden, der Quelltext"
    echo "        behauptet $B_512. Nicht namentlich behauptete Verschwundene:"
    comm -23 "$TMP/diff_512.txt" "$TMP/soll_512.txt" | sed 's/^/          - /'
    BEFUND=1
fi
if [ "$G2" != "$B_2" ]; then
    echo "BEFUND: avx2-Stufe -- CMake laesst $G2 Eintraege verschwinden, der Quelltext"
    echo "        behauptet $B_2. Nicht namentlich behauptete Verschwundene:"
    comm -23 "$TMP/diff_2.txt" "$TMP/soll_2.txt" | sed 's/^/          - /'
    BEFUND=1
fi
if [ "$R512" -gt 0 ] || [ "$R2" -gt 0 ]; then
    echo "BEFUND: ERSCHEINT BEI WEGFALL einer Faehigkeit -- die Leiter ist monoton, das"
    echo "        hier ist es nicht:"
    sed 's/^/          - /' "$TMP/rueck_512.txt" "$TMP/rueck_2.txt"
    BEFUND=1
fi
while IFS= read -r _n; do
    [ -n "$_n" ] || continue
    grep -qxF "$_n" "$TMP/diff_512.txt" || {
        echo "BEFUND: BEHAUPTET, ABER NICHT VERSCHWUNDEN: $_n (Stufe avx512f) -- der"
        echo "        Quelltext nennt ein Gatter, das CMake nicht vollzieht."
        BEFUND=1
    }
done < "$TMP/soll_512.txt"
while IFS= read -r _n; do
    [ -n "$_n" ] || continue
    grep -qxF "$_n" "$TMP/diff_2.txt" || {
        echo "BEFUND: BEHAUPTET, ABER NICHT VERSCHWUNDEN: $_n (Stufe avx2)"
        BEFUND=1
    }
done < "$TMP/soll_2.txt"

# =============================================================================
#  4. GEGENEINGANG DES BERICHTS mit den ECHTEN Listen -- je Klasse passend
# =============================================================================
echo "-----------------------------------------------------------------------------"
for _k in avx512f avx2 basis; do
    sh "$BERICHT" --wurzel "$QUELLE" --klasse "$_k" --ctest-liste "$TMP/roh-$_k.txt" \
        > "$TMP/gegen-$_k.txt" 2>&1 && _grc=0 || _grc=$?
    if [ "$_grc" = 0 ]; then
        echo "GEGENEINGANG   klasse=$_k gegen eigene ctest-Liste: kein Widerspruch (rc 0)"
    else
        echo "BEFUND: Bericht klasse=$_k gegen die ECHTE ctest-Liste derselben Klasse: rc=$_grc"
        grep -E 'WIDERSPRUCH|ABBRUCH' "$TMP/gegen-$_k.txt" | sed 's/^/        /'
        BEFUND=1
    fi
done

# SELBSTBISS: Klasse basis gegen die avx512f-Liste MUSS beissen, sonst ist der
# Gegeneingang ein Stellvertreter (er wuerde auch am toten Instrument gruen).
if [ $((N_SOLL512 + N_SOLL2)) -gt 0 ]; then
    sh "$BERICHT" --wurzel "$QUELLE" --klasse basis --ctest-liste "$TMP/roh-avx512f.txt" \
        > "$TMP/biss.txt" 2>&1 && _brc=0 || _brc=$?
    _nw=$(grep -c 'WIDERSPRUCH' "$TMP/biss.txt" || true)
    if [ "$_brc" = 1 ] && [ "$_nw" -gt 0 ]; then
        echo "SELBSTBISS     klasse=basis gegen avx512f-Liste beisst: rc=1, $_nw Widerspruch/Widersprueche"
    else
        echo "BEFUND: die GEKREUZTE Gegenprobe beisst NICHT (rc=$_brc, widersprueche=$_nw) --"
        echo "        ein Gegeneingang, der falsche Paarungen schluckt, prueft nichts."
        BEFUND=1
    fi
else
    echo "SELBSTBISS     nicht fahrbar: 0 namentlich 1:1 pruefbare ISA-Registrierungen"
fi

echo "============================================================================="
if [ "$BEFUND" -eq 0 ]; then
    echo "ERGEBNIS: GEGENORAKEL GRUEN -- CMake bestaetigt die Klassen-Leiter."
    echo "          stand=$IST gemessen_avx512f=$G512 gemessen_avx2=$G2"
    echo "          eintraege avx512f/avx2/basis = $E512/$E2/$EB"
else
    echo "ERGEBNIS: BEFUND -- Quelltext-Leiter und CMake-Verhalten widersprechen sich."
    echo "          Nicht die Zahl retten, die Stelle heilen."
fi
echo "============================================================================="

exit "$BEFUND"
