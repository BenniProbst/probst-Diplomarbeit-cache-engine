#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  SELBSTTEST DER BEDINGUNGS-TABELLE ##06  (D2-G4 Nachsatz, 2026-08-09)
#  GOAL v8 / TDD-Vertrag T-1..T-9. POSIX-sh, ASCII-only, kein Python.
# =============================================================================
#
# SELBSTCHECK -- was diese Datei ZUSICHERT:
#   scripts/ci_abnahme06_bedingungs_tabelle.sh haelt die Formel ##06 nicht nur
#   fuer BEDINGUNGEN, sondern fuer STELLEN. Eine neue bedingte Registrierung,
#   die unter eine BEREITS allowgelistete Bedingung geschoben wird, muss ROT
#   werden und namentlich dastehen.
# WAS SIE NICHT ZUSICHERT:
#   Nichts ueber den Inhalt der echten Allowlist-Begruendungen (Prosa ist nicht
#   maschinell pruefbar), und nichts darueber, ob ein registrierter Test etwas
#   Sinnvolles prueft. Gezaehlt werden Registrierungs-STELLEN.
#
# -----------------------------------------------------------------------------
# DER BEFUND, GEGEN DEN DIESE DATEI GESCHRIEBEN IST (Kritikstufe 09.08.2026,
# am Objekt mit gewuerfeltem Koeder nachgestellt, BEVOR eine Zeile Code entstand)
# -----------------------------------------------------------------------------
# Die Allowlist deckte BEDINGUNGEN, nicht STELLEN. Ein Koeder
#     if(COMDARE_PRT_ART_LEGACY_AVAILABLE)
#         add_test(NAME test_schleich_<gewuerfelt> COMMAND foo)
#     endif()
# an das echte tests/unit/CMakeLists.txt angehaengt lief mit EXIT 0 durch:
# allowlist_mit_begruendung stieg still 6 -> 7, obwohl der Allowlist-Eintrag
# woertlich "Deckt 4 Registrierungen" zusichert. Das ist exakt die Fehlerklasse
# "stille Ausnahme", gegen die die Wache laut ihrem eigenen Kopf gebaut ist.
# Der Wellenplan verlangt fuer W0a woertlich: "19. Koeder-Registrierung hebt den
# Zaehler maschinell auf 19 und wird NAMENTLICH ROT" -- fuer diesen Fall hielt
# die gebaute Wache diese Zusicherung nicht.
#
# T-1 (ROT ZUERST): diese Datei wurde geschrieben und gefahren, BEVOR die
#     Zusicherungs-Pruefung im Pruefling existierte. Erster Lauf: Faelle K1, K3,
#     K4, K5 ROT (der Pruefling kannte weder stellen=N noch --nur-zusicherung).
# T-2 (AUSSAGE NICHT ANWESENHEIT): geprueft werden WERTE (Zaehler, Exit-Code,
#     genannte Namen), nicht die Anwesenheit einer Option.
# T-3 (NENNER FREMD): die Soll-Zahlen der Fixture stehen hier als Konstanten
#     NEBEN der Fixture und sind von Hand abgezaehlt -- sie stammen NICHT aus
#     dem Pruefling. Wer die Fixture aendert, muss die Zahl mit aendern.
# T-4 (GEGENEINGANG): jeder Koeder hat einen Gegenkoeder am unmanipulierten
#     Baum (Fall P1/P2), sonst waere ein Dauer-Rot ununterscheidbar von einem Biss.
# T-9 (TESTKRITIK): was hier NICHT gedeckt ist, steht am Ende unter NICHT GEDECKT.
#
# KOEDER-DOKTRIN (K13): jeder Koeder-Name wird bei JEDEM Lauf frisch aus
# /dev/urandom gewuerfelt. Ein abgeschriebener Koeder beweist nichts -- er
# koennte im Pruefling oder in einer Allowlist als Sonderfall stehen.
#
# AUFRUF:  sh scripts/ci_abnahme06_bedingungs_tabelle.selbsttest.sh
# EXIT:    0 = alle Faelle bestanden      1 = mindestens ein Fall gescheitert
#          2 = der Test konnte nicht pruefen (fail-closed, ausdruecklich KEIN Gruen)
# =============================================================================

set -eu

WURZEL=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "ABBRUCH: kein git-Arbeitsbaum -- die Repo-Wurzel ist nicht bestimmbar." >&2
    exit 2
}
cd "$WURZEL"

PRUEFLING="scripts/ci_abnahme06_bedingungs_tabelle.sh"

TMP=$(mktemp -d) || exit 2
trap 'rm -rf "$TMP"' EXIT INT TERM

FAELLE=0
ROT=0

wuerfel() {
    LC_ALL=C tr -dc 'a-z0-9' < /dev/urandom 2>/dev/null | dd bs=1 count=15 2>/dev/null
}

fall()  { FAELLE=$((FAELLE + 1)); printf '%-6s %-62s ' "[$1]" "$2"; }
gruen() { printf 'OK\n'; }
rot()   { printf 'ROT -- %s\n' "$1"; ROT=$((ROT + 1)); }

# Feld aus der Ausgabe holen: "schluessel=wert" -> wert
feld() { sed -n "s/.*[[:space:]]$2=\([^[:space:]]*\).*/\1/p" "$1" | head -1; }

# -----------------------------------------------------------------------------
# DIE FIXTURE -- und ihr von Hand abgezaehltes INVENTAR (T-3, zweite Quelle)
# -----------------------------------------------------------------------------
#   depth 0 (zaehlt NICHT -- Gegenkoeder gegen eine zu gierige Zaehlung):
#     -  add_test(NAME fix_unbedingt_a ...)
#     -  eine auskommentierte add_test-Zeile im ALPHA-Block
#   if(FIX_GATTER_ALPHA):
#     1  add_test(NAME fix_alpha_1 ...)          einzeilig
#     2  add_test(\n NAME fix_alpha_2 \n ...)    NAME auf der FOLGEZEILE
#   if(FIX_GATTER_BETA):
#     3  add_test(NAME fix_beta_1 ...)
#   if(FIX_GATTER_GAMMA):
#     4  add_test(NAME fix_gamma_1 ...)
#   => bedingte_registrierungen = 4 , bedingungs_klassen = 3
FIX_SOLL_REG=4
FIX_SOLL_KLASSEN=3
# IST-Nenner der Fixture: nur fix_gamma_1 steht in der ctest-Liste.
FIX_SOLL_ERFUELLT=1
# Allowlist der Fixture deckt ALPHA (2 Stellen) und BETA (1 Stelle) = 3.
FIX_SOLL_ALLOW=3

fixture_bauen() {
    cat > "$TMP/CMakeLists.txt" <<'EOF'
cmake_minimum_required(VERSION 3.20)
project(fixture_abnahme06)
enable_testing()

add_test(NAME fix_unbedingt_a COMMAND fix_unbedingt_a)

if(FIX_GATTER_ALPHA)
    add_test(NAME fix_alpha_1 COMMAND fix_alpha_1)
    # add_test(NAME fix_kommentar_zaehlt_nicht COMMAND nichts)
    add_test(
        NAME fix_alpha_2
        COMMAND fix_alpha_2)
endif()

if(FIX_GATTER_BETA)
    add_test(NAME fix_beta_1 COMMAND fix_beta_1)
endif()

if(FIX_GATTER_GAMMA)
    add_test(NAME fix_gamma_1 COMMAND fix_gamma_1)
endif()
EOF
    # ctest -N-Form: nur fix_gamma_1 ist im gebauten Baum angekommen.
    cat > "$TMP/ctest.txt" <<'EOF'
Test project /tmp/fixture-abnahme06
  Test #1: fix_unbedingt_a
  Test #2: fix_gamma_1

Total Tests: 2
EOF
    # Allowlist im GELTENDEN Format: Bedingung TAB stellen=N TAB Begruendung.
    printf 'FIX_GATTER_ALPHA\tstellen=2\tFixture-Begruendung ALPHA: zwei Stellen.\n' \
        > "$TMP/allow.txt"
    printf 'FIX_GATTER_BETA\tstellen=1\tFixture-Begruendung BETA: eine Stelle.\n' \
        >> "$TMP/allow.txt"
}

# Pruefling fahren. $1 = Quelle, $2 = Allowlist, Rest = weitere Optionen.
# K11: erst in eine Datei, dann rc -- nach einer Pipe misst $? das letzte Glied.
fahren() {
    _q="$1"; _a="$2"; shift 2
    sh "$PRUEFLING" --ohne-host --quelle "$_q" --allowlist "$_a" "$@" \
        > "$TMP/lauf.txt" 2>&1 && RC=0 || RC=$?
}

echo "============================================================================="
echo " SELBSTTEST BEDINGUNGS-TABELLE ##06   ($PRUEFLING)"
echo "============================================================================="

fall E1 "Pruefling existiert und ist lesbar"
if [ -f "$PRUEFLING" ] && [ -r "$PRUEFLING" ]; then
    gruen
else
    rot "FEHLT: $PRUEFLING"
    echo
    echo "ERGEBNIS: $ROT von $FAELLE Faellen ROT (der Pruefling fehlt -- alles Weitere waere sinnlos)."
    exit 1
fi

fixture_bauen

# -- Fall P1 (GEGENKOEDER): der unmanipulierte Baum ist GRUEN -----------------
# Ohne diesen Fall beweist kein Koeder etwas: eine Wache, die immer rot ist,
# ist so wertlos wie eine, die immer gruen ist.
fall P1 "Gegenkoeder: unmanipulierte Fixture ist gruen, Zahlen stimmen"
fahren "$TMP/CMakeLists.txt" "$TMP/allow.txt" --ctest-liste "$TMP/ctest.txt"
_r=$(feld "$TMP/lauf.txt" bedingte_registrierungen)
_k=$(feld "$TMP/lauf.txt" bedingungs_klassen)
_e=$(feld "$TMP/lauf.txt" erfuellt)
_al=$(feld "$TMP/lauf.txt" allowlist_mit_begruendung)
if [ "$RC" = 0 ] && [ "$_r" = "$FIX_SOLL_REG" ] && [ "$_k" = "$FIX_SOLL_KLASSEN" ] &&
   [ "$_e" = "$FIX_SOLL_ERFUELLT" ] && [ "$_al" = "$FIX_SOLL_ALLOW" ]; then
    gruen
else
    rot "rc=$RC reg=$_r/$FIX_SOLL_REG klassen=$_k/$FIX_SOLL_KLASSEN \
erfuellt=$_e/$FIX_SOLL_ERFUELLT allow=$_al/$FIX_SOLL_ALLOW (ist/soll)"
fi

# -- Fall P2 (GEGENKOEDER): der Zusicherungs-Modus ist am sauberen Baum gruen -
# Dieser Modus muss OHNE gebauten Baum gruen werden koennen, sonst ist er im
# super-CI nicht fahrbar (dort gibt es heute keinen IST-Nenner, s. Fussnote).
fall P2 "Gegenkoeder: --nur-zusicherung ohne ctest-Liste ist gruen"
fahren "$TMP/CMakeLists.txt" "$TMP/allow.txt" --nur-zusicherung
_v=$(feld "$TMP/lauf.txt" allowlist_zusicherung_verletzt)
if [ "$RC" = 0 ] && [ "$_v" = "0" ]; then
    gruen
else
    rot "rc=$RC (soll 0) allowlist_zusicherung_verletzt='$_v' (soll 0)"
fi

# -- Fall K1 (KOEDER, gewuerfelt): DER BEFUND ---------------------------------
# Eine neue Registrierung unter einer BEREITS allowgelisteten Bedingung. Sie
# darf NICHT stillschweigend als "allowgelistet" durchrutschen: die Zusicherung
# lautet stellen=2, am Objekt sind es dann 3.
K1=$(wuerfel)
[ -n "$K1" ] || { echo "ABBRUCH: /dev/urandom lieferte keinen Koeder." >&2; exit 2; }
fall K1 "Koeder unter ALLOWGELISTETER Bedingung -> ROT, Zahlen + Name genannt"
cp "$TMP/CMakeLists.txt" "$TMP/k1.cmake"
{
    printf 'if(FIX_GATTER_ALPHA)\n'
    printf '    add_test(NAME koeder_%s COMMAND koeder_%s)\n' "$K1" "$K1"
    printf 'endif()\n'
} >> "$TMP/k1.cmake"
fahren "$TMP/k1.cmake" "$TMP/allow.txt" --ctest-liste "$TMP/ctest.txt"
_v=$(feld "$TMP/lauf.txt" allowlist_zusicherung_verletzt)
_hat_soll=$(grep -cF 'soll=2 ist=3' "$TMP/lauf.txt" || true)
_hat_name=$(grep -cF "koeder_$K1" "$TMP/lauf.txt" || true)
if [ "$RC" != 0 ] && [ "$_v" = "1" ] && [ "$_hat_soll" -ge 1 ] && [ "$_hat_name" -ge 1 ]; then
    gruen
else
    rot "rc=$RC (soll !=0) verletzt='$_v' (soll 1) 'soll=2 ist=3'=$_hat_soll name_genannt=$_hat_name"
fi

# -- Fall K2 (KOEDER, gewuerfelt): unter einer NEUEN Bedingung ----------------
# Der Fall, den die Wache schon vorher fing. Er steht hier als Regressionsschutz:
# die neue Pruefung darf den alten Biss nicht verdraengen.
K2=$(wuerfel)
fall K2 "Koeder unter NEUER Bedingung -> ROT und namentlich (Regressionsschutz)"
cp "$TMP/CMakeLists.txt" "$TMP/k2.cmake"
{
    printf 'if(FIX_GATTER_%s)\n' "$K2"
    printf '    add_test(NAME koeder_%s COMMAND koeder_%s)\n' "$K2" "$K2"
    printf 'endif()\n'
} >> "$TMP/k2.cmake"
fahren "$TMP/k2.cmake" "$TMP/allow.txt" --ctest-liste "$TMP/ctest.txt"
_o=$(feld "$TMP/lauf.txt" ohne_allowlist_eintrag)
_hat_name=$(grep -cF "koeder_$K2" "$TMP/lauf.txt" || true)
if [ "$RC" != 0 ] && [ "$_o" = "1" ] && [ "$_hat_name" -ge 1 ]; then
    gruen
else
    rot "rc=$RC (soll !=0) ohne_allowlist_eintrag='$_o' (soll 1) name_genannt=$_hat_name"
fi

# -- Fall K3 (KOEDER): die Zusicherung wird ZU GROSS -------------------------
# Gegenrichtung zu K1. Faellt eine Registrierung unter einer allowgelisteten
# Bedingung weg, ist die Begruendung ("Deckt N Registrierungen") ab sofort
# falsch -- eine Ausnahme, die mehr verspricht als existiert, ist eine tote
# Ausnahme und muss laut werden, nicht still schrumpfen.
fall K3 "Zusicherung zu gross (Stelle entfaellt) -> ROT mit beiden Zahlen"
awk '!/fix_beta_1/' "$TMP/CMakeLists.txt" > "$TMP/k3.cmake"
fahren "$TMP/k3.cmake" "$TMP/allow.txt" --ctest-liste "$TMP/ctest.txt"
_v=$(feld "$TMP/lauf.txt" allowlist_zusicherung_verletzt)
_hat=$(grep -cF 'soll=1 ist=0' "$TMP/lauf.txt" || true)
if [ "$RC" != 0 ] && [ "$_v" = "1" ] && [ "$_hat" -ge 1 ]; then
    gruen
else
    rot "rc=$RC (soll !=0) verletzt='$_v' (soll 1) 'soll=1 ist=0'=$_hat"
fi

# -- Fall K4 (KOEDER, gewuerfelt): Allowlist-Zeile OHNE Zusicherung ----------
# Das ALTE Format (Bedingung TAB Begruendung) darf nicht stillschweigend weiter
# gelten -- sonst waere der Bruch nicht laut, sondern bequem.
K4=$(wuerfel)
fall K4 "Allowlist im ALTEN Format (ohne stellen=N) -> ROT, fail-closed"
printf 'FIX_GATTER_ALPHA\tBegruendung ohne Zusicherung, Koeder %s\n' "$K4" > "$TMP/k4.allow"
printf 'FIX_GATTER_BETA\tstellen=1\tFixture-Begruendung BETA.\n' >> "$TMP/k4.allow"
fahren "$TMP/CMakeLists.txt" "$TMP/k4.allow" --ctest-liste "$TMP/ctest.txt"
_hat=$(grep -cF 'FIX_GATTER_ALPHA' "$TMP/lauf.txt" || true)
if [ "$RC" != 0 ] && [ "$_hat" -ge 1 ]; then
    gruen
else
    rot "rc=$RC (soll !=0) Zeile benannt=$_hat"
fi

# -- Fall K5 (KOEDER, gewuerfelt): Allowlist-Eintrag ohne jede Stelle --------
# Eine Ausnahme fuer eine Bedingung, die es im Quelltext gar nicht (mehr) gibt.
# Sie war bisher unsichtbar: die Wache lief nur ueber die Stellen, nie ueber die
# Allowlist. Eine tote Ausnahme ist eine Zusicherung ohne Gegenstand.
K5=$(wuerfel)
fall K5 "Allowlist-Eintrag ohne jede Stelle im Quelltext -> ROT"
cp "$TMP/allow.txt" "$TMP/k5.allow"
printf 'FIX_GATTER_%s\tstellen=1\tKoeder: diese Bedingung steht nirgends.\n' "$K5" >> "$TMP/k5.allow"
fahren "$TMP/CMakeLists.txt" "$TMP/k5.allow" --ctest-liste "$TMP/ctest.txt"
_v=$(feld "$TMP/lauf.txt" allowlist_zusicherung_verletzt)
_hat=$(grep -cF "FIX_GATTER_$K5" "$TMP/lauf.txt" || true)
if [ "$RC" != 0 ] && [ "$_v" = "1" ] && [ "$_hat" -ge 1 ]; then
    gruen
else
    rot "rc=$RC (soll !=0) verletzt='$_v' (soll 1) benannt=$_hat"
fi

# -- Fall K6 (KOEDER): Markerbump legalisiert den Schleichweg NICHT ----------
# Die Kritik nannte den Restweg ausdruecklich: wer im selben Change die
# Plan-Markerzeile von 18 auf 19 hebt, brachte den --gegen-vorlage-Abgleich
# frueher wieder zur Deckung -- und damit den Schleichweg durch. Die
# Zusicherung haengt NICHT am Marker und muss ihn ueberstimmen.
fall K6 "Markerbump auf die Koeder-Zahl macht den Schleichweg NICHT gruen"
printf '<!-- ABNAHME06-ZAHLEN bedingte_registrierungen=5 bedingungs_klassen=3 -->\n' \
    > "$TMP/k6.vorlage.md"
fahren "$TMP/k1.cmake" "$TMP/allow.txt" --ctest-liste "$TMP/ctest.txt" \
    --gegen-vorlage "$TMP/k6.vorlage.md"
_deckung=$(grep -cF 'Deckung: ja.' "$TMP/lauf.txt" || true)
_v=$(feld "$TMP/lauf.txt" allowlist_zusicherung_verletzt)
if [ "$RC" != 0 ] && [ "$_deckung" -ge 1 ] && [ "$_v" = "1" ]; then
    gruen
else
    rot "rc=$RC (soll !=0) Vorlage_deckt=$_deckung (soll >=1) verletzt='$_v' (soll 1)"
fi

# -- Fall R1: das ECHTE Objekt -- die echte Allowlist haelt ihre Zusicherung --
# Kein Bauverzeichnis, kein IST-Nenner noetig: die Stellenzahl je Bedingung
# kommt allein aus dem CMake-Quelltext. Genau deshalb ist dieser Modus im
# super-CI fahrbar, obwohl ##06 dort (noch) keinen IST-Nenner hat.
fall R1 "echtes Objekt: Vorgabe-Quelle + echte Allowlist, --nur-zusicherung"
sh "$PRUEFLING" --ohne-host --nur-zusicherung > "$TMP/r1.txt" 2>&1 && R1RC=0 || R1RC=$?
_v=$(feld "$TMP/r1.txt" allowlist_zusicherung_verletzt)
_s=$(feld "$TMP/r1.txt" allowlist_stellen_soll)
_i=$(feld "$TMP/r1.txt" allowlist_stellen_ist)
if [ "$R1RC" = 0 ] && [ "$_v" = "0" ] && [ -n "$_s" ] && [ "$_s" = "$_i" ]; then
    gruen
else
    rot "rc=$R1RC verletzt='$_v' (soll 0) stellen_soll='$_s' stellen_ist='$_i'"
fi

# -- Fall R2: T-7 -- die REGISTRIERUNG ist Teil des Tests ---------------------
# Ein Skript, das in keinem Job aufgerufen wird, ist kein Werkzeug, sondern eine
# Datei. Geprueft wird am CI-Text: Job vorhanden, BEIDE Aufrufe drin, kein
# allow_failure. Der Block endet an der ersten Zeile in Spalte 1 NACH dem
# Job-Kopf -- Kommentar ODER naechster Schluessel (die Falle, die den
# Schwester-Selbsttest schon einmal falsch rot machte).
fall R2 "T-7: CI-Job ruft Selbsttest UND Wache, ohne allow_failure"
_ci=".gitlab-ci.yml"
if [ ! -r "$_ci" ]; then
    rot "$_ci nicht lesbar"
else
    _blk=$(awk '
        /^test:abnahme06-zusicherung:/ { an = 1; print; next }
        an && /^[^ \t]/ { an = 0 }
        an' "$_ci")
    _hat_s=$(printf '%s\n' "$_blk" | grep -cF 'ci_abnahme06_bedingungs_tabelle.selbsttest.sh' || true)
    _hat_w=$(printf '%s\n' "$_blk" | grep -cF -- '--nur-zusicherung' || true)
    _hat_a=$(printf '%s\n' "$_blk" | grep -c '^[[:space:]]*allow_failure:' || true)
    if [ -n "$_blk" ] && [ "$_hat_s" -ge 1 ] && [ "$_hat_w" -ge 1 ] && [ "$_hat_a" -eq 0 ]; then
        gruen
    else
        _jg=nein; [ -n "$_blk" ] && _jg=ja
        rot "job_gefunden=$_jg selbsttest=$_hat_s wache=$_hat_w allow_failure=$_hat_a"
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
echo " * Der TEXT einer Begruendung wird nicht geprueft. Steht dort 'Deckt 4',"
echo "   waehrend stellen=7 zugesichert ist, faellt das keinem Zaehler auf --"
echo "   maschinell gebunden ist nur die ZAHL, nicht die Prosa daneben."
echo " * Registrierungen aus foreach-Schleifen oder aus Hausfunktionen zaehlen"
echo "   als EINE Stelle. Wer Durchlaeufe aufloesen will, braucht cmake --trace;"
echo "   die Aufrufstellen loest scripts/ci_host_klassen_bericht.sh auf."
echo " * Ob die zugesicherte Zahl SACHLICH richtig ist, entscheidet weiterhin ein"
echo "   Mensch beim Eintragen. Diese Wache haelt nur fest, dass sie ab dann"
echo "   stimmen MUSS -- und laut wird, sobald sie nicht mehr stimmt."
echo " * Der IST-Nenner (ctest -N eines gebauten Baums) bleibt hier Fixture. Der"
echo "   echte Nenner fehlt der super-CI noch (Posten D2, Artefakt-Auftrag)."
echo "-----------------------------------------------------------------------------"

[ "$ROT" -eq 0 ] || exit 1
exit 0
