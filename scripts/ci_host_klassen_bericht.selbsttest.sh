#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  SELBSTTEST DES HOST-KLASSEN-BERICHTS  (D2-G5, 2026-08-08)
#  GOAL v8 / TDD-Vertrag T-1..T-9. POSIX-sh, ASCII-only, kein Python.
# =============================================================================
#
# WOZU. scripts/ci_host_klassen_bericht.sh beantwortet EINE Frage: wie viele
# ctest-Registrierungen dieses Bauwegs haengen an einer Host-ISA, und wie hoch
# ist die Untergrenze der Registrierungen fuer DIE Host-Klasse, auf der gerade
# gebaut wird. Diese Datei prueft, dass er sie richtig beantwortet.
#
# T-1 (ROT ZUERST): geschrieben und gefahren, BEVOR der Bericht existierte.
#     Erster Lauf: "FEHLT: scripts/ci_host_klassen_bericht.sh" -> rc 1.
# T-3 (NENNER FREMD): die Soll-Zahlen kommen NICHT aus dem Pruefling, sondern
#     aus HANDGEBAUTEN Fixture-Baeumen, deren Registrierungen hier im Skript
#     einzeln abgezaehlt und als Konstante NEBEN der Fixture stehen. Wer die
#     Fixture aendert, muss die Zahl mit aendern -- sie ist die zweite Quelle.
# T-4 (GEGENEINGANG): jeder Positiv-Fall hat einen Koeder-Zwilling, jeder
#     Koeder einen Gegenkoeder am unmanipulierten Baum.
# T-5 (ORAKEL UNABHAENGIG): die Host-Klasse wird im Bericht aus /proc/cpuinfo
#     bestimmt; dieser Test vergleicht sie zusaetzlich gegen eine SELBST
#     uebersetzte __builtin_cpu_supports-Probe (Fall O1).
# T-9 (TESTKRITIK): was dieser Test NICHT deckt, steht am Ende in NICHT GEDECKT.
#
# KOEDER-DOKTRIN (K13): jeder Koeder-Name wird bei JEDEM Lauf frisch aus
# /dev/urandom gewuerfelt. Ein aus einer Doku abgeschriebener Koeder beweist
# nichts -- er koennte im Pruefling als Sonderfall stehen.
#
# AUFRUF:  sh scripts/ci_host_klassen_bericht.selbsttest.sh
# EXIT:    0 = alle Faelle bestanden      1 = mindestens ein Fall gescheitert
#          2 = der Test konnte nicht pruefen (fail-closed, ausdruecklich KEIN Gruen)
# =============================================================================

set -eu

WURZEL=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "ABBRUCH: kein git-Arbeitsbaum -- die Repo-Wurzel ist nicht bestimmbar." >&2
    exit 2
}
cd "$WURZEL"

BERICHT="scripts/ci_host_klassen_bericht.sh"

TMP=$(mktemp -d) || exit 2
trap 'rm -rf "$TMP"' EXIT INT TERM

FAELLE=0
ROT=0

# -- Hilfsmittel --------------------------------------------------------------
# Zufalls-Token: 15 Zeichen aus [a-z0-9], aus /dev/urandom. Nie abgeschrieben.
wuerfel() {
    LC_ALL=C tr -dc 'a-z0-9' < /dev/urandom 2>/dev/null | dd bs=1 count=15 2>/dev/null
}

fall() {
    FAELLE=$((FAELLE + 1))
    printf '%-6s %-58s ' "[$1]" "$2"
}
gruen() { printf 'OK\n'; }
rot()   { printf 'ROT -- %s\n' "$1"; ROT=$((ROT + 1)); }

# Fixture-Baum bauen. $1 = Zielverzeichnis.
#
# INVENTAR DIESER FIXTURE -- die zweite Quelle (T-3), von Hand gezaehlt:
#   unbedingt (keine ISA-Bedingung):
#     1  add_test(NAME fix_basis_a ...)              CMakeLists.txt
#     2  gtest_discover_tests(fix_basis_b)           CMakeLists.txt
#     3  haus_registriert(fix_basis_c)               CMakeLists.txt  (Rumpf: 1 add_test)
#     4  add_test(NAME fix_basis_d ... ) MEHRZEILIG  sub/CMakeLists.txt
#   avx2-gattiert:
#     5  add_test(NAME fix_avx2_a ...)               sub/CMakeLists.txt  if(COMDARE_HOST_RUNS_AVX2)
#     6  haus_registriert_gattiert("fix_avx2_b" "${COMDARE_HOST_RUNS_AVX2}")  Argument-Gatter
#   avx512f-gattiert:
#     7  add_test(NAME fix_512_a ...) MEHRZEILIG     sub/CMakeLists.txt  if(... AND ...AVX512F)
#     8  add_test(NAME fix_512_b ...)                sub/CMakeLists.txt  gleicher Block
#     9  haus_registriert_gattiert("fix_512_c" "${COMDARE_HOST_RUNS_AVX512F}") Argument-Gatter
#   NICHT zaehlbar (Koeder gegen Falschzaehlung):
#     -  eine auskommentierte add_test-Zeile
#     -  ein add_test im RUMPF von haus_registriert (gehoert zur Aufrufstelle 3)
#
#   => SOLL, nach der LEITER (disjunkte Stufen, jede Registrierung genau einmal):
#      gesamt 9, unbedingt 4, isa_gattiert 5, davon avx512f-Stufe 3, avx2-Stufe 2
#      Der AND-Block (Faelle 7+8) haengt an AVX2 UND AVX512F -- seine HOECHSTE
#      geforderte Stufe ist avx512f, er zaehlt also dort und NICHT zusaetzlich
#      bei avx2. Genau diese Doppelzaehlung war der erste Rechenfehler beim
#      Aufstellen dieser Fixture: von Hand kam "avx2 = 3" heraus, der Positiv-
#      Fall P1 hat ihn gefangen. Er steht hier als Notiz, weil ein Nenner, den
#      niemand nachrechnet, genau so entsteht.
#      Untergrenzen: avx512f = 9, avx2 = 9-3 = 6, basis = 9-3-2 = 4
FIX_SOLL_GESAMT=9
FIX_SOLL_ISA=5
FIX_SOLL_AVX512=3
FIX_SOLL_AVX2=2
FIX_SOLL_U_AVX512=9
FIX_SOLL_U_AVX2=6
FIX_SOLL_U_BASIS=4
# Koeder-Soll: ein Koeder fuegt GENAU EINE avx512-gattierte Registrierung hinzu.
_soll_g=$((FIX_SOLL_GESAMT + 1))
_soll_a=$((FIX_SOLL_AVX512 + 1))

fixture_bauen() {
    _z="$1"
    mkdir -p "$_z/sub" "$_z/cmake"
    cat > "$_z/CMakeLists.txt" <<'EOF'
cmake_minimum_required(VERSION 3.20)
project(fixture_host_klassen)
enable_testing()

function(haus_registriert name)
    add_test(NAME ${name} COMMAND ${name})
endfunction()

function(haus_registriert_gattiert name do_run)
    if(do_run)
        add_test(NAME ${name} COMMAND ${name})
    endif()
endfunction()

add_test(NAME fix_basis_a COMMAND fix_basis_a)
gtest_discover_tests(fix_basis_b)
haus_registriert(fix_basis_c)
# add_test(NAME fix_kommentar_darf_nicht_zaehlen COMMAND nichts)
add_subdirectory(sub)
EOF
    cat > "$_z/sub/CMakeLists.txt" <<'EOF'
include(CheckCXXSourceRuns)
check_cxx_source_runs("int main(){return __builtin_cpu_supports(\"avx2\")?0:1;}" COMDARE_HOST_RUNS_AVX2)
check_cxx_source_runs("int main(){return __builtin_cpu_supports(\"avx512f\")?0:1;}" COMDARE_HOST_RUNS_AVX512F)

add_test(
    NAME fix_basis_d
    COMMAND fix_basis_d)

if(COMDARE_HOST_RUNS_AVX2)
    add_test(NAME fix_avx2_a COMMAND fix_avx2_a)
endif()

haus_registriert_gattiert("fix_avx2_b" "${COMDARE_HOST_RUNS_AVX2}")

if(COMDARE_HOST_RUNS_AVX2 AND COMDARE_HOST_RUNS_AVX512F)
    add_test(
        NAME fix_512_a
        COMMAND fix_512_a)
    add_test(NAME fix_512_b COMMAND fix_512_b)
else()
    message(STATUS "ohne AVX2+AVX512F nicht registriert")
endif()

haus_registriert_gattiert("fix_512_c" "${COMDARE_HOST_RUNS_AVX512F}")
EOF
    git -C "$_z" init -q 2>/dev/null || return 1
    git -C "$_z" add -A 2>/dev/null || return 1
    return 0
}

# Feld aus der Berichtsausgabe holen: "schluessel=wert" -> wert
feld() { sed -n "s/.*[[:space:]]$2=\([^[:space:]]*\).*/\1/p" "$1" | head -1; }

echo "============================================================================="
echo " SELBSTTEST HOST-KLASSEN-BERICHT   ($BERICHT)"
echo "============================================================================="

# -- Fall E1: der Pruefling muss ueberhaupt da und ausfuehrbar sein -----------
fall E1 "Bericht existiert und ist ausfuehrbar"
if [ -f "$BERICHT" ] && [ -r "$BERICHT" ]; then
    gruen
else
    rot "FEHLT: $BERICHT"
    echo
    echo "ERGEBNIS: $ROT von $FAELLE Faellen ROT (der Pruefling fehlt -- alles Weitere waere sinnlos)."
    exit 1
fi

FIX="$TMP/fixture"
fixture_bauen "$FIX" || { echo "ABBRUCH: Fixture nicht baubar (git fehlt?)" >&2; exit 2; }

# -- Fall P1: der NENNER am unmanipulierten Fixture-Baum ----------------------
# Das ist der Positiv-Fall. Ohne ihn beweist kein Koeder etwas.
fall P1 "Nenner: gesamt/avx512f/avx2 am Fixture-Baum"
sh "$BERICHT" --wurzel "$FIX" --klasse avx512f > "$TMP/p1.txt" 2>&1 && P1RC=0 || P1RC=$?
_g=$(feld "$TMP/p1.txt" registrierungen_gesamt)
_i=$(feld "$TMP/p1.txt" isa_gattiert_gesamt)
_a5=$(feld "$TMP/p1.txt" isa_gattiert_avx512f)
_a2=$(feld "$TMP/p1.txt" isa_gattiert_avx2)
if [ "$P1RC" = 0 ] && [ "$_g" = "$FIX_SOLL_GESAMT" ] && [ "$_i" = "$FIX_SOLL_ISA" ] &&
   [ "$_a5" = "$FIX_SOLL_AVX512" ] && [ "$_a2" = "$FIX_SOLL_AVX2" ]; then
    gruen
else
    rot "rc=$P1RC gesamt=$_g/$FIX_SOLL_GESAMT isa=$_i/$FIX_SOLL_ISA \
avx512f=$_a5/$FIX_SOLL_AVX512 avx2=$_a2/$FIX_SOLL_AVX2 (ist/soll)"
fi

# -- Fall P2: die ZWEISTUFIGE Untergrenze ueber alle drei Klassen -------------
fall P2 "zweistufige Untergrenze avx512f/avx2/basis"
untergrenze_von() {
    sh "$BERICHT" --wurzel "$FIX" --klasse "$1" > "$TMP/u_$1.txt" 2>&1 || true
    feld "$TMP/u_$1.txt" untergrenze_registrierungen
}
_u5=$(untergrenze_von avx512f)
_u2=$(untergrenze_von avx2)
_ub=$(untergrenze_von basis)
if [ "$_u5" = "$FIX_SOLL_U_AVX512" ] && [ "$_u2" = "$FIX_SOLL_U_AVX2" ] && [ "$_ub" = "$FIX_SOLL_U_BASIS" ]; then
    gruen
else
    rot "avx512f=$_u5 (soll $FIX_SOLL_U_AVX512) avx2=$_u2 (soll $FIX_SOLL_U_AVX2) basis=$_ub (soll $FIX_SOLL_U_BASIS)"
fi

# -- Fall P3 (GEGENKOEDER): der unmanipulierte Baum bleibt GRUEN --------------
# Ohne diesen Fall waere ein Dauer-Rot ununterscheidbar von einem Biss (T-1).
fall P3 "Gegenkoeder: unmanipulierter Baum ist gruen (kein Daueralarm)"
if sh "$BERICHT" --wurzel "$FIX" --klasse avx512f >/dev/null 2>&1; then
    gruen
else
    rot "der unmanipulierte Fixture-Baum ist rot -- die Wache waere ein Daueralarm"
fi

# -- Fall K1 (KOEDER, gewuerfelt): eine NEUE avx512-gattierte Registrierung ---
# Der Zaehler MUSS sich um genau 1 bewegen UND den Namen nennen.
K1=$(wuerfel)
[ -n "$K1" ] || { echo "ABBRUCH: /dev/urandom lieferte keinen Koeder." >&2; exit 2; }
fall K1 "Koeder avx512f (+1) wird gezaehlt und NAMENTLICH genannt"
FIXK="$TMP/fix_k1"
cp -r "$FIX" "$FIXK"
rm -rf "$FIXK/.git"
{
    printf 'if(COMDARE_HOST_RUNS_AVX512F)\n'
    printf '    add_test(NAME koeder_%s COMMAND koeder_%s)\n' "$K1" "$K1"
    printf 'endif()\n'
} >> "$FIXK/sub/CMakeLists.txt"
git -C "$FIXK" init -q && git -C "$FIXK" add -A
sh "$BERICHT" --wurzel "$FIXK" --klasse avx512f > "$TMP/k1.txt" 2>&1 || true
_kg=$(feld "$TMP/k1.txt" registrierungen_gesamt)
_ka=$(feld "$TMP/k1.txt" isa_gattiert_avx512f)
if [ "$_kg" = "$_soll_g" ] && [ "$_ka" = "$_soll_a" ] && grep -q "koeder_$K1" "$TMP/k1.txt"; then
    gruen
else
    _nen=$(grep -c "koeder_$K1" "$TMP/k1.txt" || true)
    rot "gesamt=$_kg/$_soll_g avx512f=$_ka/$_soll_a (ist/soll) name_genannt=$_nen"
fi

# -- Fall K2 (KOEDER, gewuerfelt): ein UNBEKANNTES ISA-Gatter -----------------
# Kern der Wache: eine neue Host-Faehigkeit, die die Klassen-Leiter nicht kennt,
# macht jede Untergrenze falsch. Das MUSS rot werden und benannt sein.
K2=$(LC_ALL=C tr -dc 'A-Z0-9' < /dev/urandom 2>/dev/null | dd bs=1 count=10 2>/dev/null)
[ -n "$K2" ] || { echo "ABBRUCH: /dev/urandom lieferte keinen Koeder." >&2; exit 2; }
fall K2 "Koeder unbekanntes ISA-Gatter -> ROT und benannt"
FIXK2="$TMP/fix_k2"
cp -r "$FIX" "$FIXK2"
rm -rf "$FIXK2/.git"
{
    printf 'if(COMDARE_HOST_RUNS_%s)\n' "$K2"
    printf '    add_test(NAME koeder_unbekannt COMMAND koeder_unbekannt)\n'
    printf 'endif()\n'
} >> "$FIXK2/sub/CMakeLists.txt"
git -C "$FIXK2" init -q && git -C "$FIXK2" add -A
sh "$BERICHT" --wurzel "$FIXK2" --klasse avx512f > "$TMP/k2.txt" 2>&1 && K2RC=0 || K2RC=$?
if [ "$K2RC" != 0 ] && grep -q "COMDARE_HOST_RUNS_$K2" "$TMP/k2.txt"; then
    gruen
else
    rot "rc=$K2RC (soll !=0), Gatter genannt=$(grep -c "COMDARE_HOST_RUNS_$K2" "$TMP/k2.txt" || true)"
fi

# -- Fall K3 (KOEDER, gewuerfelt): auskommentierte Registrierung zaehlt NICHT -
# Gegenrichtung zu K1: der Zaehler darf sich NICHT bewegen. Faengt eine zu
# gierige Regex, die den Nenner nach oben faelscht.
K3=$(wuerfel)
fall K3 "Koeder Kommentarzeile bewegt den Zaehler NICHT"
FIXK3="$TMP/fix_k3"
cp -r "$FIX" "$FIXK3"
rm -rf "$FIXK3/.git"
printf '# add_test(NAME koeder_%s COMMAND koeder_%s)\n' "$K3" "$K3" >> "$FIXK3/sub/CMakeLists.txt"
git -C "$FIXK3" init -q && git -C "$FIXK3" add -A
sh "$BERICHT" --wurzel "$FIXK3" --klasse avx512f > "$TMP/k3.txt" 2>&1 || true
_k3g=$(feld "$TMP/k3.txt" registrierungen_gesamt)
if [ "$_k3g" = "$FIX_SOLL_GESAMT" ]; then
    gruen
else
    rot "gesamt=$_k3g (soll unveraendert $FIX_SOLL_GESAMT)"
fi

# -- Fall K4 (KOEDER, gewuerfelt): MEHRZEILIGES add_test im ISA-Block ---------
# Die Falle, die heute real drei Tests im SOLL verschwinden liess: eine
# Zeilen-Regex ist blind fuer add_test(\n NAME x \n COMMAND ...).
K4=$(wuerfel)
fall K4 "Koeder MEHRZEILIGES add_test im avx512-Block wird gezaehlt"
FIXK4="$TMP/fix_k4"
cp -r "$FIX" "$FIXK4"
rm -rf "$FIXK4/.git"
{
    printf 'if(COMDARE_HOST_RUNS_AVX512F)\n'
    printf '    add_test(\n'
    printf '        NAME koeder_%s\n' "$K4"
    printf '        COMMAND koeder_%s)\n' "$K4"
    printf 'endif()\n'
} >> "$FIXK4/sub/CMakeLists.txt"
git -C "$FIXK4" init -q && git -C "$FIXK4" add -A
sh "$BERICHT" --wurzel "$FIXK4" --klasse avx512f > "$TMP/k4.txt" 2>&1 || true
_k4a=$(feld "$TMP/k4.txt" isa_gattiert_avx512f)
if [ "$_k4a" = "$_soll_a" ] && grep -q "koeder_$K4" "$TMP/k4.txt"; then
    gruen
else
    rot "avx512f=$_k4a (soll $_soll_a) name_genannt=$(grep -c "koeder_$K4" "$TMP/k4.txt" || true)"
fi

# -- Fall O1: ORAKEL UNABHAENGIG ---------------------------------------------
# Der Bericht liest /proc/cpuinfo. Dieser Test uebersetzt eine EIGENE
# __builtin_cpu_supports-Probe -- ein anderer Weg zu derselben Wahrheit (CPUID
# ueber den Compiler statt Kernel-Flagliste). Weichen sie ab, ist die
# Host-Kennung des Berichts wertlos, egal wie huebsch sie gedruckt ist.
fall O1 "Host-Klasse: /proc/cpuinfo == selbst uebersetzte CPUID-Probe"
_cxx=""
for _c in g++-15 g++ c++ clang++; do
    if command -v "$_c" >/dev/null 2>&1; then _cxx="$_c"; break; fi
done
if [ -z "$_cxx" ]; then
    rot "kein C++-Compiler gefunden -- das Gegenorakel ist nicht fahrbar (fail-closed)"
else
    cat > "$TMP/probe.cpp" <<'EOF'
#include <cstdio>
int main() {
    __builtin_cpu_init();
    std::printf("%s\n", __builtin_cpu_supports("avx512f") ? "avx512f"
                      : (__builtin_cpu_supports("avx2") ? "avx2" : "basis"));
    return 0;
}
EOF
    if "$_cxx" -O0 -o "$TMP/probe" "$TMP/probe.cpp" 2>"$TMP/probe.err"; then
        _orakel=$("$TMP/probe")
        _bericht=$(sh "$BERICHT" --wurzel "$FIX" 2>&1 | sed -n 's/.*host_klasse=\([a-z0-9]*\).*/\1/p' | head -1)
        if [ "$_orakel" = "$_bericht" ]; then
            gruen
        else
            rot "Gegenorakel sagt '$_orakel', der Bericht sagt '$_bericht'"
        fi
    else
        rot "Probe nicht uebersetzbar ($_cxx): $(head -1 "$TMP/probe.err")"
    fi
fi

# -- Fall R1: der ECHTE Baum -- drei Zahlen, IMMER gedruckt ------------------
# Der Bericht muss auch am realen Repo alle drei Zahlen und die Host-Kennung
# drucken, sonst ist er im CI wertlos. Geprueft wird die ANWESENHEIT der Zahlen
# und ihre innere Stimmigkeit (untergrenze = gesamt - abwesend), NICHT ihr Wert
# -- der haengt am Submodul-Stand und ist keine Konstante (T-2).
fall R1 "echter Baum: drei Zahlen + Host-Kennung, innere Stimmigkeit"
sh "$BERICHT" > "$TMP/r1.txt" 2>&1 && R1RC=0 || R1RC=$?
_rg=$(feld "$TMP/r1.txt" registrierungen_gesamt)
_ru=$(feld "$TMP/r1.txt" untergrenze_registrierungen)
_rf=$(feld "$TMP/r1.txt" abwesend_diese_klasse)
_rk=$(feld "$TMP/r1.txt" host_klasse)
if [ -n "$_rg" ] && [ -n "$_ru" ] && [ -n "$_rf" ] && [ -n "$_rk" ] &&
   [ "$_ru" -eq $((_rg - _rf)) ] 2>/dev/null; then
    gruen
else
    rot "rc=$R1RC gesamt='$_rg' untergrenze='$_ru' abwesend='$_rf' klasse='$_rk'"
fi

# -- Fall R2: Fehlbefund-Wache gegen die Design-Zahl -------------------------
# Der Wellenplan sagt "6 von 428 Tests registrieren sich nur auf AVX-512-Hosts".
# Am Objekt gemessen sind es SECHS ISA-gattierte Registrierungen, davon VIER an
# AVX-512F -- zwei verschiedene Zahlen fuer zwei verschiedene Host-Klassen. Der
# Test haelt nur fest, dass der Bericht die beiden UNTERSCHEIDET, statt eine
# Zahl fuer beides zu drucken. Er prueft KEINEN festen Wert (der Bestand darf
# wachsen), sondern dass avx512f-Gattierung eine ECHTE TEILMENGE der ISA-
# Gattierung ist, sobald es ueberhaupt avx2-Gattierung gibt.
fall R2 "avx512f-Zahl und ISA-Zahl sind getrennt ausgewiesen"
_ig=$(feld "$TMP/r1.txt" isa_gattiert_gesamt)
_i5=$(feld "$TMP/r1.txt" isa_gattiert_avx512f)
_i2=$(feld "$TMP/r1.txt" isa_gattiert_avx2)
if [ -n "$_ig" ] && [ -n "$_i5" ] && [ -n "$_i2" ] && [ "$_i5" -le "$_ig" ] 2>/dev/null; then
    gruen
else
    rot "isa_gesamt='$_ig' avx512f='$_i5' avx2='$_i2'"
fi

# -- Fall R3: T-7 -- die REGISTRIERUNG ist Teil des Tests ---------------------
# Ein Skript, das in keinem Job aufgerufen wird, ist kein Werkzeug, sondern eine
# Datei. Genau diese Luecke hat run_all_tests.sh 13x [NOT FOUND] drucken und
# trotzdem 0 zurueckgeben lassen. Geprueft wird am CI-Text: Job vorhanden,
# BEIDE Skripte aufgerufen, kein allow_failure.
fall R3 "T-7: CI-Job ruft Bericht UND Selbsttest, ohne allow_failure"
_ci=".gitlab-ci.yml"
if [ ! -r "$_ci" ]; then
    rot "$_ci nicht lesbar"
else
    # Der Block endet an der ERSTEN Zeile in Spalte 1, die nicht der Job-Kopf
    # ist -- Kommentar ODER naechster Schluessel. Beim ersten Anlauf endete er
    # nur am naechsten Schluessel; der Kommentarblock dahinter enthaelt die
    # Worte "kein allow_failure", und der Fall wurde ROT, obwohl der Job sauber
    # war. Ein Orakel, das den Nachbarn mitliest, misst den falschen Gegenstand.
    _blk=$(awk '
        /^test:host-klassen-bericht:/ { an = 1; print; next }
        an && /^[^ \t]/ { an = 0 }
        an' "$_ci")
    _hat_b=$(printf '%s\n' "$_blk" | grep -cF 'ci_host_klassen_bericht.sh' || true)
    _hat_s=$(printf '%s\n' "$_blk" | grep -cF 'ci_host_klassen_bericht.selbsttest.sh' || true)
    _hat_a=$(printf '%s\n' "$_blk" | grep -c '^[[:space:]]*allow_failure:' || true)
    if [ -n "$_blk" ] && [ "$_hat_b" -ge 1 ] && [ "$_hat_s" -ge 1 ] && [ "$_hat_a" -eq 0 ]; then
        gruen
    else
        _jg=nein; [ -n "$_blk" ] && _jg=ja
        rot "job_gefunden=$_jg bericht=$_hat_b selbsttest=$_hat_s allow_failure=$_hat_a"
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
echo " * Registrierungen in foreach-Schleifen ueber Ziel-Listen: der Bericht"
echo "   zaehlt die AUFRUFSTELLE, nicht die Schleifendurchlaeufe. Er weist die"
echo "   Zahl solcher Stellen getrennt aus; dieser Test prueft die Ausweisung,"
echo "   nicht die Aufloesung. Wer sie aufloesen will, braucht cmake --trace."
echo " * Ob eine ISA-gattierte Registrierung im GEBAUTEN Baum wirklich fehlt,"
echo "   prueft nur der optionale --ctest-liste-Gegeneingang; hier ohne Bau."
echo " * Der Bericht liest den ARBEITSBAUM des Submoduls. Steht dort ein anderer"
echo "   Stand als im gitlink, sagt er das -- dieser Test erzwingt es nicht."
echo "-----------------------------------------------------------------------------"

[ "$ROT" -eq 0 ] || exit 1
exit 0
