#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  PROBE fuer die ZELLKOORDINATEN-WACHE (ci/zellkoordinaten_wache.sh)  (2026-08-09)
# =============================================================================
#
# SELBSTCHECK -- was diese Datei zusichert, und was NICHT:
#   ZUSICHERT: dass die Wache in den unten aufgefuehrten Faellen GENAU das Verdikt
#     faellt, das sie faellen muss -- insbesondere, dass sie ROT wird, wenn eine
#     Koordinate zwar als Attribut DA ist, aber LEER (der reale Vor-Zustand), und
#     wenn ein Variablenname zwar im Job VORKOMMT, aber nicht exportiert wird.
#     Zusaetzlich (--selbstbiss), dass sie an drei Wegwerf-Mutanten ihrer selbst
#     NICHT mehr gruen bleibt.
#   ZUSICHERT NICHT: dass ein echter Messlauf ein Bestandslog-Dokument erzeugt,
#     und nicht, dass die gepinnten Werte (O3/no_extension) der real gebauten
#     Zelle entsprechen. Das erste belegt nur ein object_stat am Store, das
#     zweite nur ein Lauf mit Vergleich gegen die Profil-Deklaration.
#
# T-4 -- DER GEGENEINGANG IST DER GANZE PUNKT:
# Zu JEDER Zusicherung steht hier ein Eingang, bei dem sie NICHT gilt. Eine Wache,
# die nur den guten Fall sieht, ist Dekoration. Die Faelle sind paarweise gebaut:
# dieselbe Zeile einmal vollstaendig (gruen) und einmal verstuemmelt (rot).
#
# K13 -- DER KOEDER MUSS ERST BEISSEN, UND ER WIRD FRISCH GEWUERFELT:
# Die opt/simd-Werte der synthetischen Eintraege sind bei JEDEM Lauf neu gewuerfelt
# (head -c9 /dev/urandom | base32). Kein Wert ist aus der Doku, aus dem Paket-Text
# oder aus einem alten Lauf abgeschrieben. Damit kann die Wache nicht dadurch gruen
# sein, dass sie "O3" oder "no_extension" WIEDERERKENNT -- sie muss die Struktur
# pruefen. Zu jedem Rot-Fall gehoert die Gegenprobe mit DEMSELBEN Koeder korrekt
# eingesetzt: ein Koeder, der immer beisst, ist so wertlos wie einer, der nie beisst.
#
# T-5 -- DAS ORAKEL IST UNABHAENGIG:
# Die Soll-Verdikte stehen als Literal am Fall (0/1/2). Sie werden NICHT aus der
# Wache abgeleitet und nicht aus ihrer Ausgabe gelesen.
#
# AUFRUF:  sh ci/tests/zellkoordinaten_wache_probe.sh [--selbstbiss]
# EXIT:    0 = alle Faelle wie erwartet | 1 = mindestens ein Fall falsch
#
# POSIX-sh, ASCII-only, kein Python.
# =============================================================================

set -eu

WACHE="${WACHE_UNTER_TEST:-ci/zellkoordinaten_wache.sh}"
YAML_ECHT="${YAML_UNTER_TEST:-.gitlab-ci.yml}"
SELBSTBISS=0
[ "${1:-}" = "--selbstbiss" ] && SELBSTBISS=1

test -f "$WACHE" || { echo "ABBRUCH: $WACHE nicht gefunden (cwd=$(pwd))" >&2; exit 1; }

ARBEIT=$(mktemp -d) || exit 1
trap 'rm -rf "$ARBEIT"' EXIT INT TERM

FEHLER=0
N_FALL=0
N_HALT=0

wurf() { head -c9 /dev/urandom | base32 | tr A-Z a-z | tr -d '='; }

# Frisch gewuerfelte Koeder -- EINMAL je Lauf, damit Gruen- und Rot-Fall
# nachweislich denselben Wert benutzen (sonst waere die Gegenprobe keine).
KOEDER_OPT=$(wurf)
KOEDER_SIMD=$(wurf)
KOEDER_COMBO=$(wurf)

# fall <name> <erwarteter_rc> <modus> <datei> [zusatzargumente...]
fall() {
    _name="$1"; _erw="$2"; _modus="$3"; _datei="$4"
    shift 4
    N_FALL=$((N_FALL + 1))
    _ist=0
    # K11: kein rc=$? nach einer Pipe -- der Aufruf steht ohne Pipe.
    if sh "$WACHE" "$_modus" "$_datei" "$@" > "$ARBEIT/out.$N_FALL" 2>&1; then
        _ist=0
    else
        _ist=$?
    fi
    if [ "$_ist" -eq "$_erw" ]; then
        N_HALT=$((N_HALT + 1))
        echo "  OK    [$_erw] $_name"
    else
        FEHLER=$((FEHLER + 1))
        echo "  FALSCH[erwartet $_erw, war $_ist] $_name"
        sed 's/^/          | /' "$ARBEIT/out.$N_FALL"
    fi
}

# --- Bausteine fuer synthetische Bestandslog-Dokumente -----------------------
# Die Attribut-REIHENFOLGE folgt woertlich dem ce-Serialisierer
# (bestandslog_document.hpp:344-352) -- nicht der Doku-Grammatik im Kopf.
eintrag() { # eintrag <opt> <simd> <combo>
    printf '    <eintrag key_sha512="%s" combo="%s" opt="%s" simd="%s" pfad="p/%s.so" bytes="17" stempel="[x]" done_utc="2026-08-09T00:00:00Z"/>\n' \
        "$(wurf)" "$3" "$1" "$2" "$(wurf)"
}
dok() { # dok <datei> ; liest Eintraege von stdin
    { printf '<bestandslog syntax_version="4" semantics_version="1" genus="binary" doc_revision="1" created_utc="2026-08-09T00:00:00Z">\n'
      printf '  <bestand>\n'
      cat
      printf '  </bestand>\n'
      printf '  <reservierungen>\n  </reservierungen>\n'
      printf '</bestandslog>\n'
    } > "$1"
}

echo "============================================================================="
echo "PROBE ZELLKOORDINATEN-WACHE   Wache=$WACHE"
echo "  Koeder dieses Laufs (frisch gewuerfelt): opt=$KOEDER_OPT simd=$KOEDER_SIMD combo=$KOEDER_COMBO"
echo "============================================================================="
echo "-- Modus eintraege: die Ergebniszeile --"

# (1) Vollstaendig, combo LEER. Das ist die kanonische Vollmengen-Form der
#     emittierten Seite (ceb_combo_is_full_set: leer == "[all]") -> muss GRUEN sein.
eintrag "$KOEDER_OPT" "$KOEDER_SIMD" "" | dok "$ARBEIT/e_voll_combo_leer.xml"
fall "vollstaendig, combo leer (== [all]) -> genommen" 0 eintraege "$ARBEIT/e_voll_combo_leer.xml"

# (2) Gegenprobe zum Koeder: DERSELBE opt/simd, zusaetzlich combo gefuellt.
eintrag "$KOEDER_OPT" "$KOEDER_SIMD" "$KOEDER_COMBO" | dok "$ARBEIT/e_voll_combo_voll.xml"
fall "vollstaendig, combo gefuellt -> genommen" 0 eintraege "$ARBEIT/e_voll_combo_voll.xml"

# (3) T-4: opt LEER, simd mit demselben Koeder wie im Gruen-Fall -> zurueckgewiesen.
eintrag "" "$KOEDER_SIMD" "" | dok "$ARBEIT/e_opt_leer.xml"
fall "opt=\"\" (Attribut da, Wert leer) -> zurueckgewiesen" 1 eintraege "$ARBEIT/e_opt_leer.xml"

# (4) T-4: simd LEER, opt mit demselben Koeder -> zurueckgewiesen.
eintrag "$KOEDER_OPT" "" "" | dok "$ARBEIT/e_simd_leer.xml"
fall "simd=\"\" (Attribut da, Wert leer) -> zurueckgewiesen" 1 eintraege "$ARBEIT/e_simd_leer.xml"

# (5) DER REALE VOR-ZUSTAND: beide leer, genau was die statischen Jobs schrieben.
eintrag "" "" "" | dok "$ARBEIT/e_beide_leer.xml"
fall "opt+simd leer (der reale Vor-Zustand) -> zurueckgewiesen" 1 eintraege "$ARBEIT/e_beide_leer.xml"

# (6) Attribut ganz FEHLEND ist nicht dasselbe wie leer -- beides muss beissen.
printf '    <eintrag key_sha512="%s" combo="" simd="%s" pfad="p/x.so" bytes="17" stempel="[x]" done_utc="2026-08-09T00:00:00Z"/>\n' \
    "$(wurf)" "$KOEDER_SIMD" | dok "$ARBEIT/e_opt_fehlt.xml"
fall "opt-Attribut fehlt ganz -> zurueckgewiesen" 1 eintraege "$ARBEIT/e_opt_fehlt.xml"

# (7) EIN schlechter Eintrag unter guten vergiftet das Verdikt (kein Mehrheitsentscheid).
{ eintrag "$KOEDER_OPT" "$KOEDER_SIMD" ""
  eintrag "$KOEDER_OPT" "$KOEDER_SIMD" ""
  eintrag "" "" ""
} | dok "$ARBEIT/e_gemischt.xml"
fall "2 gute + 1 verstuemmelter Eintrag -> zurueckgewiesen" 1 eintraege "$ARBEIT/e_gemischt.xml"

# (8) Null Eintraege ist KEIN Gruen -- eine Wache ohne Gegenstand hat nichts belegt.
printf '' | dok "$ARBEIT/e_leer.xml"
fall "Dokument ohne <eintrag> -> exit 2, nicht gruen" 2 eintraege "$ARBEIT/e_leer.xml"

# (9) Fehlende Datei ebenso: nicht pruefbar ist nicht bestanden.
fall "Datei existiert nicht -> exit 2, nicht gruen" 2 eintraege "$ARBEIT/gibt_es_nicht.xml"

echo "-- Modus jobs: die emittierende Seite --"

# Minimal-YAML-Fabrik. Die Job-Zeile steht in Spalte 1 wie im echten Dokument.
mach_yaml() { # mach_yaml <datei> <smoke-exports> <golden-exports>
    { printf 'stages:\n  - measure\n\n'
      printf 'measure:smoke:\n  stage: measure\n  script:\n    - |\n'
      printf '%s' "$2"
      printf '\n'
      printf 'measure:golden-320:\n  stage: measure\n  script:\n    - |\n'
      printf '%s' "$3"
      printf '\n'
    } > "$1"
}
VOLL=$(printf '      export COMDARE_GN_OPT="%s"\n      export COMDARE_GN_SIMD="%s"\n      export COMDARE_PLATFORM="amd@$(hostname)"\n      export COMDARE_LANE="amd"\n' "$KOEDER_OPT" "$KOEDER_SIMD")

# (10) Beide Jobs vollstaendig -> genommen.
mach_yaml "$ARBEIT/j_voll.yml" "$VOLL" "$VOLL"
fall "beide Jobs vollstaendig -> genommen" 0 jobs "$ARBEIT/j_voll.yml"

# (11) T-4 + Block-Grenze: NUR golden-320 verliert einen Export. Beweist zugleich,
#      dass der Block-Ausschnitt die Jobs wirklich TRENNT (sonst faende die Wache
#      den Export des Nachbarn und bliebe faelschlich gruen).
GOLD_OHNE_SIMD=$(printf '      export COMDARE_GN_OPT="%s"\n      export COMDARE_PLATFORM="amd@$(hostname)"\n      export COMDARE_LANE="amd"\n' "$KOEDER_OPT")
mach_yaml "$ARBEIT/j_gold_ohne.yml" "$VOLL" "$GOLD_OHNE_SIMD"
fall "nur golden-320 ohne GN_SIMD -> zurueckgewiesen" 1 jobs "$ARBEIT/j_gold_ohne.yml"
if /usr/bin/grep -q "golden-320: export COMDARE_GN_SIMD" "$ARBEIT/out.$N_FALL"; then
    N_FALL=$((N_FALL + 1)); N_HALT=$((N_HALT + 1))
    echo "  OK    [-] der Befund nennt golden-320 (Job-Blocks sind getrennt)"
else
    N_FALL=$((N_FALL + 1)); FEHLER=$((FEHLER + 1))
    echo "  FALSCH[-] der Befund nennt golden-320 NICHT -- Block-Grenze unklar"
fi

# (12) Export vorhanden, Wert LEER -> zurueckgewiesen (Anwesenheit ist keine Aussage).
GOLD_LEER=$(printf '      export COMDARE_GN_OPT=""\n      export COMDARE_GN_SIMD="%s"\n      export COMDARE_PLATFORM="amd@$(hostname)"\n      export COMDARE_LANE="amd"\n' "$KOEDER_SIMD")
mach_yaml "$ARBEIT/j_leerwert.yml" "$VOLL" "$GOLD_LEER"
fall "export COMDARE_GN_OPT=\"\" (leerer Wert) -> zurueckgewiesen" 1 jobs "$ARBEIT/j_leerwert.yml"

# (13) DER STELLVERTRETER-FALL: der Name kommt vor, aber nur im KOMMENTAR.
#      Eine Wache, die auf das Wort grept statt auf den Export, bliebe hier gruen.
GOLD_KOMMENTAR=$(printf '      # COMDARE_GN_SIMD="%s" waere hier richtig, steht aber nur im Kommentar\n      export COMDARE_GN_OPT="%s"\n      export COMDARE_PLATFORM="amd@$(hostname)"\n      export COMDARE_LANE="amd"\n' "$KOEDER_SIMD" "$KOEDER_OPT")
mach_yaml "$ARBEIT/j_kommentar.yml" "$VOLL" "$GOLD_KOMMENTAR"
fall "Variable nur im Kommentar, nicht exportiert -> zurueckgewiesen" 1 jobs "$ARBEIT/j_kommentar.yml"

# (14) Umbenannter/fehlender Job darf NICHT still durchrutschen.
fall "verlangter Job fehlt in der YAML -> exit 2, nicht gruen" 2 jobs "$ARBEIT/j_voll.yml" "measure:gibt-es-nicht"

# (15) DAS ECHTE DOKUMENT. Der Fall, um dessentwillen alles andere existiert.
if [ -f "$YAML_ECHT" ]; then
    fall "die echte $YAML_ECHT -> genommen" 0 jobs "$YAML_ECHT"
else
    echo "  UEBERSPRUNGEN: $YAML_ECHT nicht vorhanden (cwd=$(pwd))"
fi

# =============================================================================
#  --selbstbiss: drei WEGWERF-MUTANTEN der Wache. Jeder entfernt genau eine
#  Zusicherung; jeder MUSS an dem Fall auffliegen, der sie traegt. Ein Mutant,
#  der gruen bleibt, beweist, dass dieser Fall nichts pruefte.
# =============================================================================
if [ "$SELBSTBISS" -eq 1 ]; then
    echo "-- Selbstbiss: Wegwerf-Mutanten der Wache --"

    # mutant <name> <sed-ausdruck> <erwartet-vorher> <modus> <datei>
    #   Vorher-Verdikt ist das SOLL der unmutierten Wache; der Mutant muss davon ABWEICHEN.
    mutant() {
        _mname="$1"; _sed="$2"; _erw="$3"; _mmodus="$4"; _mdatei="$5"
        N_FALL=$((N_FALL + 1))
        _mut="$ARBEIT/mutant.sh"
        sed "$_sed" "$WACHE" > "$_mut"
        if cmp -s "$WACHE" "$_mut"; then
            FEHLER=$((FEHLER + 1))
            echo "  FALSCH[-] Mutation '$_mname' hat NICHTS geaendert (Anker verfehlt) -- der Biss waere wertlos"
            return 0
        fi
        _mist=0
        if sh "$_mut" "$_mmodus" "$_mdatei" > "$ARBEIT/mut.out" 2>&1; then _mist=0; else _mist=$?; fi
        if [ "$_mist" -eq "$_erw" ]; then
            FEHLER=$((FEHLER + 1))
            echo "  FALSCH[-] Mutant '$_mname' faellt weiter dasselbe Verdikt ($_mist) -- der Fall prueft nichts"
        else
            N_HALT=$((N_HALT + 1))
            echo "  OK    [-] Mutant '$_mname' beisst: $_erw -> $_mist"
        fi
    }

    # M1: die LEER-Pruefung faellt weg -- nur noch fehlende Attribute beissen.
    #     Muss an Fall (5) auffliegen (opt+simd leer, der reale Vor-Zustand).
    mutant "eintraege: leerer Wert gilt als gueltig" \
           's/ || o == "") { fehl_opt/) { fehl_opt/; s/ || s == "") { fehl_simd/) { fehl_simd/' \
           1 eintraege "$ARBEIT/e_beide_leer.xml"

    # M2: statt des EXPORTS wird nur noch VAR=" gesucht -- ein Kommentar genuegt.
    #     Muss an Fall (13) auffliegen.
    mutant "jobs: Anwesenheit statt Export" \
           's/marke = "export " name/marke = name/' \
           1 jobs "$ARBEIT/j_kommentar.yml"

    # M3: das leere Dokument faellt still auf gruen statt auf exit 2.
    #     Muss an Fall (8) auffliegen.
    mutant "eintraege: leeres Dokument wird gruen" \
           's/if \[ "$N_GES" -eq 0 \]; then/if false; then/' \
           2 eintraege "$ARBEIT/e_leer.xml"
fi

echo "============================================================================="
echo "NENNER (nie eine nackte Zahl):"
echo "  $N_FALL Zusicherung(en) gefahren -- das ist die Grundgesamtheit dieser Probe."
echo "  $N_HALT gehalten, $FEHLER gerissen."
if [ "$SELBSTBISS" -eq 1 ]; then
    echo "  davon 3 Wegwerf-Mutanten (K13: Koeder frisch gewuerfelt, nicht abgeschrieben)."
else
    echo "  ohne --selbstbiss: die 3 Mutanten-Faelle sind NICHT gefahren."
fi
echo "============================================================================="

if [ "$FEHLER" -ne 0 ]; then
    echo "PROBE ROT: $FEHLER von $N_FALL Zusicherung(en) gerissen." >&2
    exit 1
fi
echo "PROBE GRUEN: $N_HALT von $N_FALL Zusicherung(en) gehalten."
exit 0
