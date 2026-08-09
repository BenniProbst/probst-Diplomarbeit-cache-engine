#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  SELBSTTEST DES HOST-KLASSEN-GEGENORAKELS  (W0b-7-Nachsatz zu D2-G5, 09.08.)
#  GOAL v8 / TDD-Vertrag T-1..T-9. POSIX-sh, ASCII-only, kein Python.
# =============================================================================
#
# WOZU. scripts/ci_host_klassen_bericht.sh ist ein QUELLTEXT-Scan. Sein eigener
# Selbsttest beweist, dass der Scanner mit von Hand abgezaehlten Fixtures
# uebereinstimmt -- er beweist NICHT, dass CMake dieselben Registrierungen
# wirklich host-abhaengig macht. Genau diese Luecke benennt der Landungsbericht
# vom 08.08. als die tragende. scripts/ci_host_klassen_gegenorakel.sh schliesst
# sie: derselbe Baum wird DREIMAL konfiguriert (Host-Antworten als -D-Preset;
# check_cxx_source_runs laesst vordefinierte Variablen stehen), und die
# ctest -N-Namenslisten werden gedifft. Die Differenzen MUESSEN die Leiter des
# Berichts sein -- Stufe fuer Stufe, und wo der Name 1:1 pruefbar ist, Name
# fuer Name.
#
# WAS DIESE DATEI PRUEFT -- das GEGENORAKEL selbst:
#   T-1  ROT ZUERST: Fall E1 lief, BEVOR das Gegenorakel existierte
#        (Protokoll der Landung; ein Daueralarm waere ebenso unzulaessig,
#        deshalb Gegenkoeder G1).
#   T-3  NENNER FREMD: die Soll-Zahlen kommen aus der HANDGEZAEHLTEN Fixture
#        unten, nicht aus dem Pruefling.
#   T-4  KOEDER IN BEIDE RICHTUNGEN:
#          B1  im Quelltext BEHAUPTETES Gatter ohne CMake-Wirkung
#          B2  CMake-Wirkung, die der Quelltext-Scan NICHT sieht
#          B3  Registrierung, die bei WEGFALL der Faehigkeit ERSCHEINT
#        plus Gegenkoeder G1 am unmanipulierten Baum.
#   T-7  Fall R1: der CI-Job ruft Gegenorakel UND diesen Selbsttest, ohne
#        allow_failure.
#   T-9  NICHT GEDECKT steht ausdruecklich am Ende.
#
# KOEDER-DOKTRIN (K13): jeder Koeder-Name wird bei JEDEM Lauf frisch aus
# /dev/urandom gewuerfelt. Ein abgeschriebener Koeder beweist nichts.
#
# AUFRUF:  sh scripts/ci_host_klassen_gegenorakel.selbsttest.sh
# EXIT:    0 = alle Faelle bestanden      1 = mindestens ein Fall gescheitert
#          2 = konnte nicht pruefen (fail-closed, ausdruecklich KEIN Gruen)
# =============================================================================

set -eu

WURZEL=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "ABBRUCH: kein git-Arbeitsbaum -- die Repo-Wurzel ist nicht bestimmbar." >&2
    exit 2
}
cd "$WURZEL"

ORAKEL="scripts/ci_host_klassen_gegenorakel.sh"

command -v cmake >/dev/null 2>&1 || { echo "ABBRUCH: cmake fehlt -- ohne Configure kein Gegenorakel." >&2; exit 2; }
command -v ctest >/dev/null 2>&1 || { echo "ABBRUCH: ctest fehlt." >&2; exit 2; }

TMP=$(mktemp -d) || exit 2
trap 'rm -rf "$TMP"' EXIT INT TERM

FAELLE=0
ROT=0

wuerfel() {
    LC_ALL=C tr -dc 'a-z0-9' < /dev/urandom 2>/dev/null | dd bs=1 count=15 2>/dev/null
}

fall() {
    FAELLE=$((FAELLE + 1))
    printf '%-6s %-58s ' "[$1]" "$2"
}
gruen() { printf 'OK\n'; }
rot()   { printf 'ROT -- %s\n' "$1"; ROT=$((ROT + 1)); }

feld() { sed -n "s/.*[[:space:]]$2=\([^[:space:]]*\).*/\1/p" "$1" | head -1; }

# =============================================================================
#  FIXTURE -- die zweite Quelle (T-3), von Hand gezaehlt
# =============================================================================
# INVENTAR (jede Zeile eine Registrierung; die Leiter zaehlt disjunkt, jede
# Registrierung bei ihrer HOECHSTEN geforderten Stufe):
#   1  fix_basis_a  add_test, unbedingt
#   2  fix_avx2_a   add_test in if(COMDARE_HOST_RUNS_AVX2)
#   3  fix_avx2_b   haus_registriert_gattiert(... "${COMDARE_HOST_RUNS_AVX2}")
#   4  fix_512_a    add_test in if(COMDARE_HOST_RUNS_AVX2 AND ..._AVX512F)
#   5  fix_512_b    derselbe Block, add_test MEHRZEILIG geschrieben
#   6  fix_512_c    haus_registriert_gattiert(... "${COMDARE_HOST_RUNS_AVX512F}")
#
# LEITER-SOLL:      avx512f-Stufe 3, avx2-Stufe 2, unbedingt 1, gesamt 6
# EINTRAEGE-SOLL je Klasse (was CMake registriert): avx512f 6, avx2 3, basis 1
# DIFF-SOLL:        avx512f-Stufe {fix_512_a fix_512_b fix_512_c},
#                   avx2-Stufe {fix_avx2_a fix_avx2_b}
# project(... NONE): die Fixture braucht keinen Compiler -- die Host-Antworten
# kommen im Gegenorakel IMMER als -D-Preset, nie aus einer Probe.
FIX_SOLL_D512=3
FIX_SOLL_D2=2
FIX_SOLL_E512=6
FIX_SOLL_E2=3
FIX_SOLL_EBASIS=1

fixture_bauen() {
    _z="$1"
    mkdir -p "$_z"
    cat > "$_z/CMakeLists.txt" <<'EOF'
cmake_minimum_required(VERSION 3.20)
project(fixture_gegenorakel NONE)
enable_testing()

function(haus_registriert_gattiert name do_run)
    if(do_run)
        add_test(NAME ${name} COMMAND ${name})
    endif()
endfunction()

add_test(NAME fix_basis_a COMMAND fix_basis_a)

if(COMDARE_HOST_RUNS_AVX2)
    add_test(NAME fix_avx2_a COMMAND fix_avx2_a)
endif()

haus_registriert_gattiert("fix_avx2_b" "${COMDARE_HOST_RUNS_AVX2}")

if(COMDARE_HOST_RUNS_AVX2 AND COMDARE_HOST_RUNS_AVX512F)
    add_test(NAME fix_512_a COMMAND fix_512_a)
    add_test(
        NAME fix_512_b
        COMMAND fix_512_b)
endif()

haus_registriert_gattiert("fix_512_c" "${COMDARE_HOST_RUNS_AVX512F}")
EOF
    git -C "$_z" init -q 2>/dev/null || return 1
    git -C "$_z" add -A 2>/dev/null || return 1
    return 0
}

echo "============================================================================="
echo " SELBSTTEST HOST-KLASSEN-GEGENORAKEL   ($ORAKEL)"
echo "============================================================================="

# -- Fall E1: der Pruefling muss ueberhaupt da sein ---------------------------
fall E1 "Gegenorakel existiert und ist lesbar"
if [ -f "$ORAKEL" ] && [ -r "$ORAKEL" ]; then
    gruen
else
    rot "FEHLT: $ORAKEL"
    echo
    echo "ERGEBNIS: $ROT von $FAELLE Faellen ROT (der Pruefling fehlt -- alles Weitere waere sinnlos)."
    exit 1
fi

FIX="$TMP/fixture"
fixture_bauen "$FIX" || { echo "ABBRUCH: Fixture nicht baubar (git fehlt?)" >&2; exit 2; }

# -- Fall P1: POSITIV -- Fixture, Leiter und CMake stimmen ueberein -----------
# Ohne diesen Fall beweist kein Koeder etwas: ein Orakel, das am gesunden Baum
# nie gruen wird, ist ein Daueralarm (T-1, zweite Haelfte).
fall P1 "Positiv: Diffs 3/2, Eintraege 6/3/1, rc 0"
sh "$ORAKEL" --quelle "$FIX" > "$TMP/p1.txt" 2>&1 && P1RC=0 || P1RC=$?
_d5=$(feld "$TMP/p1.txt" gemessen_avx512f)
_d2=$(feld "$TMP/p1.txt" gemessen_avx2)
_e5=$(feld "$TMP/p1.txt" eintraege_avx512f)
_e2=$(feld "$TMP/p1.txt" eintraege_avx2)
_eb=$(feld "$TMP/p1.txt" eintraege_basis)
if [ "$P1RC" = 0 ] && [ "$_d5" = "$FIX_SOLL_D512" ] && [ "$_d2" = "$FIX_SOLL_D2" ] &&
   [ "$_e5" = "$FIX_SOLL_E512" ] && [ "$_e2" = "$FIX_SOLL_E2" ] && [ "$_eb" = "$FIX_SOLL_EBASIS" ]; then
    gruen
else
    rot "rc=$P1RC d512=$_d5/$FIX_SOLL_D512 d2=$_d2/$FIX_SOLL_D2 \
e=$_e5/$_e2/$_eb (soll $FIX_SOLL_E512/$FIX_SOLL_E2/$FIX_SOLL_EBASIS)"
fi

# -- Fall B1 (KOEDER, gewuerfelt): BEHAUPTET, aber ohne CMake-Wirkung ---------
# Ein set() VOR dem if() beschattet das -D-Preset: der Scan sieht ein
# avx512f-Gatter, CMake registriert IMMER. Genau die Klasse Fehler, fuer die
# das Gegenorakel gebaut ist -- der Bericht allein bliebe gruen.
B1=$(wuerfel)
[ -n "$B1" ] || { echo "ABBRUCH: /dev/urandom lieferte keinen Koeder." >&2; exit 2; }
fall B1 "Koeder: behauptetes Gatter ohne Wirkung -> rc 1, benannt"
FIXB1="$TMP/fix_b1"
fixture_bauen "$FIXB1" || exit 2
{
    printf 'set(COMDARE_HOST_RUNS_AVX512F 1)\n'
    printf 'if(COMDARE_HOST_RUNS_AVX512F)\n'
    printf '    add_test(NAME koeder_%s COMMAND koeder_%s)\n' "$B1" "$B1"
    printf 'endif()\n'
} >> "$FIXB1/CMakeLists.txt"
sh "$ORAKEL" --quelle "$FIXB1" > "$TMP/b1.txt" 2>&1 && B1RC=0 || B1RC=$?
if [ "$B1RC" = 1 ] && grep -q "koeder_$B1" "$TMP/b1.txt"; then
    gruen
else
    _n=$(grep -c "koeder_$B1" "$TMP/b1.txt" || true)
    rot "rc=$B1RC (soll 1) koeder_genannt=$_n"
fi

# -- Fall B2 (KOEDER, gewuerfelt): CMake-Wirkung, die der Scan NICHT sieht ----
# Das Gatter steckt in einer Zwischvariablen -- die if()-Zeile traegt kein
# COMDARE_HOST_RUNS_-Token, der Scan zaehlt die Stelle als unbedingt. CMake
# laesst sie bei AVX512F=0 verschwinden. Der Diff ist um einen Namen zu gross.
B2=$(wuerfel)
fall B2 "Koeder: Wirkung ohne Behauptung -> rc 1, benannt"
FIXB2="$TMP/fix_b2"
fixture_bauen "$FIXB2" || exit 2
{
    printf 'set(koeder_gatter "${COMDARE_HOST_RUNS_AVX512F}")\n'
    printf 'if(koeder_gatter)\n'
    printf '    add_test(NAME koeder_%s COMMAND koeder_%s)\n' "$B2" "$B2"
    printf 'endif()\n'
} >> "$FIXB2/CMakeLists.txt"
sh "$ORAKEL" --quelle "$FIXB2" > "$TMP/b2.txt" 2>&1 && B2RC=0 || B2RC=$?
if [ "$B2RC" = 1 ] && grep -q "koeder_$B2" "$TMP/b2.txt"; then
    gruen
else
    _n=$(grep -c "koeder_$B2" "$TMP/b2.txt" || true)
    rot "rc=$B2RC (soll 1) koeder_genannt=$_n"
fi

# -- Fall B3 (KOEDER, gewuerfelt): erscheint bei WEGFALL der Faehigkeit -------
# Die Leiter ist monoton -- was bei weniger Faehigkeit ERSCHEINT, macht jede
# Untergrenze falsch und muss auffallen (Gegenrichtung des Diffs).
B3=$(wuerfel)
fall B3 "Koeder: erscheint bei Wegfall -> rc 1, benannt"
FIXB3="$TMP/fix_b3"
fixture_bauen "$FIXB3" || exit 2
{
    printf 'set(koeder_gatter "${COMDARE_HOST_RUNS_AVX512F}")\n'
    printf 'if(NOT koeder_gatter)\n'
    printf '    add_test(NAME koeder_%s COMMAND koeder_%s)\n' "$B3" "$B3"
    printf 'endif()\n'
} >> "$FIXB3/CMakeLists.txt"
sh "$ORAKEL" --quelle "$FIXB3" > "$TMP/b3.txt" 2>&1 && B3RC=0 || B3RC=$?
if [ "$B3RC" = 1 ] && grep -q "koeder_$B3" "$TMP/b3.txt"; then
    gruen
else
    _n=$(grep -c "koeder_$B3" "$TMP/b3.txt" || true)
    rot "rc=$B3RC (soll 1) koeder_genannt=$_n"
fi

# -- Fall G1 (GEGENKOEDER): unmanipulierter Baum bleibt gruen -----------------
# Ohne diesen Lauf waere ein Dauer-Rot von einem Biss nicht zu unterscheiden.
fall G1 "Gegenkoeder: unmanipulierte Fixture wieder rc 0"
FIXG="$TMP/fix_g1"
fixture_bauen "$FIXG" || exit 2
if sh "$ORAKEL" --quelle "$FIXG" >/dev/null 2>&1; then
    gruen
else
    rot "der unmanipulierte Baum ist rot -- das Orakel waere ein Daueralarm"
fi

# -- Fall F1 (fail-closed): Quelle existiert nicht -> rc 2 --------------------
fall F1 "fail-closed: --quelle fehlt auf Platte -> rc 2"
sh "$ORAKEL" --quelle "$TMP/gibt_es_nicht" > "$TMP/f1.txt" 2>&1 && F1RC=0 || F1RC=$?
if [ "$F1RC" = 2 ]; then
    gruen
else
    rot "rc=$F1RC (soll 2)"
fi

# -- Fall F2 (fail-closed): Baum ohne Registrierungen -> rc 2 -----------------
# Der Bericht bricht bei 0 Registrierungen ab (stille Null); das Gegenorakel
# muss diesen Abbruch WEITERGEBEN statt eine leere Leiter gruen zu nennen.
fall F2 "fail-closed: 0 Registrierungen -> rc 2, kein Gruen"
FIXF2="$TMP/fix_f2"
mkdir -p "$FIXF2"
printf 'cmake_minimum_required(VERSION 3.20)\nproject(leer NONE)\nenable_testing()\n' > "$FIXF2/CMakeLists.txt"
git -C "$FIXF2" init -q && git -C "$FIXF2" add -A
sh "$ORAKEL" --quelle "$FIXF2" > "$TMP/f2.txt" 2>&1 && F2RC=0 || F2RC=$?
if [ "$F2RC" = 2 ]; then
    gruen
else
    rot "rc=$F2RC (soll 2)"
fi

# -- Fall R1: T-7 -- die REGISTRIERUNG ist Teil des Tests ---------------------
# Der Block endet an der ERSTEN Zeile in Spalte 1 -- Kommentar ODER naechster
# Schluessel (Lehre aus dem ersten R3-Anlauf des Bericht-Selbsttests: wer den
# Nachbarjob mitliest, misst den falschen Gegenstand).
fall R1 "T-7: CI-Job ruft Gegenorakel UND Selbsttest, ohne allow_failure"
_ci=".gitlab-ci.yml"
if [ ! -r "$_ci" ]; then
    rot "$_ci nicht lesbar"
else
    _blk=$(awk '
        /^test:host-klassen-bericht:/ { an = 1; print; next }
        an && /^[^ \t]/ { an = 0 }
        an' "$_ci")
    _hat_o=$(printf '%s\n' "$_blk" | grep -cF 'ci_host_klassen_gegenorakel.sh' || true)
    _hat_s=$(printf '%s\n' "$_blk" | grep -cF 'ci_host_klassen_gegenorakel.selbsttest.sh' || true)
    _hat_a=$(printf '%s\n' "$_blk" | grep -c '^[[:space:]]*allow_failure:' || true)
    if [ -n "$_blk" ] && [ "$_hat_o" -ge 1 ] && [ "$_hat_s" -ge 1 ] && [ "$_hat_a" -eq 0 ]; then
        gruen
    else
        _jg=nein; [ -n "$_blk" ] && _jg=ja
        rot "job_gefunden=$_jg orakel=$_hat_o selbsttest=$_hat_s allow_failure=$_hat_a"
    fi
fi

echo "-----------------------------------------------------------------------------"
if [ "$ROT" -eq 0 ]; then
    echo "ERGEBNIS: $FAELLE von $FAELLE Faellen GRUEN."
else
    echo "ERGEBNIS: $ROT von $FAELLE Faellen ROT."
fi
echo
echo "NICHT GEDECKT (T-9, ausdruecklich benannt statt verschwiegen):"
echo " * Das Gegenorakel KONFIGURIERT, es BAUT nicht: gtest_discover_tests-"
echo "   Expansionen (POST_BUILD) sieht es nicht. Am ce-Stand 25fe4fbf entstehen"
echo "   0 solche Platzhalter (gemessen 09.08.); wo sie entstehen, kuerzen sie"
echo "   sich im Diff weg, solange sie nicht selbst ISA-gattiert sind."
echo " * Dieser Selbsttest faehrt das Orakel gegen die FIXTURE. Den ECHTEN Baum"
echo "   faehrt der CI-Job (Fall R1 erzwingt die Registrierung) -- lokal bricht"
echo "   das Orakel fail-closed ab, wenn das Submodul nicht auf dem gitlink"
echo "   steht, statt einen anderen Gegenstand zu vermessen."
echo " * Ob ein registrierter Test auf schwacher Hardware auch LAEUFT (SIGILL-"
echo "   Schutz do_run), ist Ausfuehrungs-Ebene, nicht Registrierungs-Ebene."
echo "-----------------------------------------------------------------------------"

[ "$ROT" -eq 0 ] || exit 1
exit 0
