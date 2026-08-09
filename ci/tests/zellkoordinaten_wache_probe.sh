#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  PROBE fuer die ZELLKOORDINATEN-WACHE (ci/zellkoordinaten_wache.sh)  (2026-08-09)
# =============================================================================
#
# SELBSTCHECK -- was diese Datei zusichert, und was NICHT:
#   ZUSICHERT: dass die Wache in den unten aufgefuehrten Faellen GENAU das Verdikt
#     faellt, das sie faellen muss -- insbesondere, dass sie ROT wird, wenn eine
#     Koordinate zwar als Attribut DA ist, aber LEER (der reale Vor-Zustand),
#     wenn ein Variablenname zwar im Job VORKOMMT, aber nicht exportiert wird,
#     und (Lens D1-D4) wenn ein Export nur AUSKOMMENTIERT ist, wenn ein Treffer
#     erst HINTER einer Spalte-1-Zeile laege, wenn ein DRITTER stage:measure-Job
#     ohne Exports dazukommt, und wenn die Exports erst NACH dem Treiber-Aufruf
#     stehen. Zusaetzlich (--selbstbiss), dass sie an sieben Wegwerf-Mutanten
#     ihrer selbst NICHT mehr dasselbe Verdikt faellt.
#   ZUSICHERT NICHT: dass ein echter Messlauf ein Bestandslog-Dokument erzeugt,
#     und nicht, dass die gepinnten Werte (O3/no_extension) der real gebauten
#     Zelle entsprechen. Das erste belegt nur ein object_stat am Store, das
#     zweite nur ein Lauf mit Vergleich gegen die Profil-Deklaration. Ebenfalls
#     nicht: Exporte hinter Zeilen-Ende-Kommentaren aktiver Zeilen und per
#     extends geerbtes stage -- im Wache-Kopf als blind benannt.
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
# Wache abgeleitet und nicht aus ihrer Ausgabe gelesen. Der Soll-Nenner des echten
# Dokuments (2 stage:measure-Jobs) ist aus einem FREMDEN Orakel eingefroren: einem
# PyYAML-Parse mit !reference-Konstruktor (Lens-Befund 09.08.2026), nicht aus der
# Wache selbst.
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

# befund_enthaelt <muster> <text-wenn-ok> <text-wenn-falsch>
#   prueft die Ausgabe des ZULETZT gefahrenen Falls (T-2: nicht nur der rc,
#   auch die KLASSE des Befunds muss stimmen -- sonst koennte ein anderer
#   Defekt denselben rc liefern und der Fall pruefte nichts).
befund_enthaelt() {
    _muster="$1"; _ok="$2"; _falsch="$3"
    _idx=$N_FALL
    N_FALL=$((N_FALL + 1))
    if /usr/bin/grep -q "$_muster" "$ARBEIT/out.$_idx"; then
        N_HALT=$((N_HALT + 1))
        echo "  OK    [-] $_ok"
    else
        FEHLER=$((FEHLER + 1))
        echo "  FALSCH[-] $_falsch"
        sed 's/^/          | /' "$ARBEIT/out.$_idx"
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
# Die Gruen-Form MIT Treiber: Existenz-Pruefung (test ...) VOR den Exports --
# sie darf NICHT als Treiber-Aufruf zaehlen -- dann Exports, DANN der Messlauf.
VOLL_MIT_TREIBER=$(printf '      test -n "$DRIVER" -a -x "$DRIVER" || exit 1\n      export COMDARE_GN_OPT="%s"\n      export COMDARE_GN_SIMD="%s"\n      export COMDARE_PLATFORM="amd@$(hostname)"\n      export COMDARE_LANE="amd"\n      "$DRIVER" experiment_config measure_out\n' "$KOEDER_OPT" "$KOEDER_SIMD")

# (10) Beide Jobs vollstaendig -> genommen.
mach_yaml "$ARBEIT/j_voll.yml" "$VOLL" "$VOLL"
fall "beide Jobs vollstaendig -> genommen" 0 jobs "$ARBEIT/j_voll.yml"

# (11) T-4: NUR golden-320 verliert einen Export. Beweist die EINE Richtung der
#      Block-Grenze: der Ausschnitt endet an der naechsten Spalte-1-JOB-Zeile
#      (sonst faende die Wache den Export des Nachbarn und bliebe gruen).
#      Die ANDERE Richtung -- der Kommentar-Kopf des Nachbarn wird nicht
#      mitgelesen -- beweist erst Fall (17); die alte Behauptung hier, dies
#      allein belege die Trennung, war zu breit (Lens D2).
GOLD_OHNE_SIMD=$(printf '      export COMDARE_GN_OPT="%s"\n      export COMDARE_PLATFORM="amd@$(hostname)"\n      export COMDARE_LANE="amd"\n' "$KOEDER_OPT")
mach_yaml "$ARBEIT/j_gold_ohne.yml" "$VOLL" "$GOLD_OHNE_SIMD"
fall "nur golden-320 ohne GN_SIMD -> zurueckgewiesen" 1 jobs "$ARBEIT/j_gold_ohne.yml"
befund_enthaelt "golden-320: export COMDARE_GN_SIMD" \
    "der Befund nennt golden-320 (Ausschnitt endet an der Job-Zeile)" \
    "der Befund nennt golden-320 NICHT -- Block-Grenze unklar"

# (12) Export vorhanden, Wert LEER -> zurueckgewiesen (Anwesenheit ist keine Aussage).
GOLD_LEER=$(printf '      export COMDARE_GN_OPT=""\n      export COMDARE_GN_SIMD="%s"\n      export COMDARE_PLATFORM="amd@$(hostname)"\n      export COMDARE_LANE="amd"\n' "$KOEDER_SIMD")
mach_yaml "$ARBEIT/j_leerwert.yml" "$VOLL" "$GOLD_LEER"
fall "export COMDARE_GN_OPT=\"\" (leerer Wert) -> zurueckgewiesen" 1 jobs "$ARBEIT/j_leerwert.yml"

# (13) Der Name kommt vor, aber nur im KOMMENTAR (ohne das Wort 'export').
#      Eine Wache, die auf das Wort grept statt auf den Export, bliebe hier gruen.
#      SCHWESTERN (Lens: dieser Fall allein war ein Stellvertreter -- er fing
#      die eine Kommentarform, die schon die Marke verfehlt): Fall (16) prueft
#      die Form '# export VAR="..."', Fall (16b) aktiven Text ohne Export.
GOLD_KOMMENTAR=$(printf '      # COMDARE_GN_SIMD="%s" waere hier richtig, steht aber nur im Kommentar\n      export COMDARE_GN_OPT="%s"\n      export COMDARE_PLATFORM="amd@$(hostname)"\n      export COMDARE_LANE="amd"\n' "$KOEDER_SIMD" "$KOEDER_OPT")
mach_yaml "$ARBEIT/j_kommentar.yml" "$VOLL" "$GOLD_KOMMENTAR"
fall "Variable nur im Kommentar, nicht exportiert -> zurueckgewiesen" 1 jobs "$ARBEIT/j_kommentar.yml"

# (14) Umbenannter/fehlender Job darf NICHT still durchrutschen. Explizite Jobs
#      kommen zur abgeleiteten Liste HINZU (sie ersetzen sie nicht).
fall "verlangter Job fehlt in der YAML -> exit 2, nicht gruen" 2 jobs "$ARBEIT/j_voll.yml" "measure:gibt-es-nicht"

# (15) DAS ECHTE DOKUMENT. Der Fall, um dessentwillen alles andere existiert.
#      (15b) Der NENNER muss aus dem Dokument abgeleitet sein und 2 betragen --
#      das Soll ist NICHT aus der Wache, sondern aus dem fremden PyYAML-Orakel
#      des Lens-Befunds eingefroren (Jobs mit stage=measure: 2, 09.08.2026).
if [ -f "$YAML_ECHT" ]; then
    fall "die echte $YAML_ECHT -> genommen" 0 jobs "$YAML_ECHT"
    befund_enthaelt "Jobs: 2 aus dem Dokument abgeleitet" \
        "Nenner am echten Dokument: 2 abgeleitete stage:measure-Jobs (PyYAML-Orakel: 2)" \
        "Nenner am echten Dokument weicht vom fremden Orakel (2) ab oder fehlt"
else
    echo "  UEBERSPRUNGEN: $YAML_ECHT nicht vorhanden (cwd=$(pwd))"
fi

echo "-- Modus jobs: die vier Lens-Gegeneingaenge D1-D4 --"

# (16) D1: der Export existiert NUR AUSKOMMENTIERT -- als syntaktisch VOLLSTAENDIGE
#      Export-Zeile hinter '#'. Auskommentieren ist der wahrscheinlichere Weg,
#      einen Export zu verlieren, als Loeschen. Die erste Wache-Fassung fand die
#      Marke mitten im Kommentar und blieb gruen.
GOLD_EXPORT_IM_KOMMENTAR=$(printf '      # AUSKOMMENTIERT beim Umbau:\n      #      export COMDARE_GN_SIMD="%s"\n      export COMDARE_GN_OPT="%s"\n      export COMDARE_PLATFORM="amd@$(hostname)"\n      export COMDARE_LANE="amd"\n' "$KOEDER_SIMD" "$KOEDER_OPT")
mach_yaml "$ARBEIT/j_export_kommentar.yml" "$VOLL" "$GOLD_EXPORT_IM_KOMMENTAR"
fall "D1: export nur auskommentiert ('# export VAR=...') -> zurueckgewiesen" 1 jobs "$ARBEIT/j_export_kommentar.yml"

# (16b) Der Name samt ="..." steht in einer AKTIVEN Zeile, aber ohne 'export':
#      blosse Anwesenheit ist keine Zusicherung (T-2). Traeger des Mutanten M2.
GOLD_TEXT_STATT_EXPORT=$(printf '      echo Hinweis: COMDARE_GN_SIMD="%s" ist nur Text, keine Umgebung\n      export COMDARE_GN_OPT="%s"\n      export COMDARE_PLATFORM="amd@$(hostname)"\n      export COMDARE_LANE="amd"\n' "$KOEDER_SIMD" "$KOEDER_OPT")
mach_yaml "$ARBEIT/j_text_statt_export.yml" "$VOLL" "$GOLD_TEXT_STATT_EXPORT"
fall "D1/T-2: Name mit =\"...\" in aktiver Zeile ohne export -> zurueckgewiesen" 1 jobs "$ARBEIT/j_text_statt_export.yml"

# (17) D2: eine Spalte-1-KOMMENTARZEILE muss den Block SCHLIESSEN. Hinter ihr
#      liegt ein eingerueckter AKTIVER Export des fehlenden Namens -- gehoerte
#      er noch zum smoke-Block, waere die Wache gruen. Das ist die Richtung,
#      die Fall (11) NICHT beweist.
{ printf 'stages:\n  - measure\n\n'
  printf 'measure:smoke:\n  stage: measure\n  script:\n    - |\n'
  printf '      export COMDARE_GN_OPT="%s"\n      export COMDARE_PLATFORM="amd@$(hostname)"\n      export COMDARE_LANE="amd"\n' "$KOEDER_OPT"
  printf '# Trenn-Kommentar in Spalte 1 -- ab hier gehoert NICHTS mehr zum smoke-Block\n'
  printf '      export COMDARE_GN_SIMD="%s"\n' "$KOEDER_SIMD"
  printf 'measure:golden-320:\n  stage: measure\n  script:\n    - |\n'
  printf '%s' "$VOLL"
  printf '\n'
} > "$ARBEIT/j_spalte1_leck.yml"
fall "D2: Treffer erst HINTER Spalte-1-Kommentar -> zurueckgewiesen" 1 jobs "$ARBEIT/j_spalte1_leck.yml"
befund_enthaelt "measure:smoke: export COMDARE_GN_SIMD" \
    "der Befund haengt am smoke-Block (der Leck-Treffer wurde ihm NICHT gutgeschrieben)" \
    "der Befund nennt smoke/GN_SIMD nicht -- das Leck wurde womoeglich gutgeschrieben"

# (18) D3: ein DRITTER Job mit stage: measure und OHNE Exports. Die Job-Liste
#      muss aus dem DOKUMENT kommen -- eine hart kodierte Liste sieht ihn nie.
{ printf 'stages:\n  - measure\n\n'
  printf 'measure:smoke:\n  stage: measure\n  script:\n    - |\n'
  printf '%s' "$VOLL"
  printf '\n'
  printf 'measure:golden-640:\n  stage: measure\n  script:\n    - |\n'
  printf '      echo dieser Job exportiert nichts\n'
  printf 'measure:golden-320:\n  stage: measure\n  script:\n    - |\n'
  printf '%s' "$VOLL"
  printf '\n'
} > "$ARBEIT/j_dritter_job.yml"
fall "D3: dritter stage:measure-Job ohne Exports -> zurueckgewiesen" 1 jobs "$ARBEIT/j_dritter_job.yml"
befund_enthaelt "golden-640: export COMDARE_GN" \
    "der Befund nennt den abgeleiteten dritten Job golden-640" \
    "der Befund nennt golden-640 NICHT -- die Ableitung hat ihn nicht gesehen"

# (19) D3-Gegenstueck: KEIN stage:measure-Job ableitbar und keiner verlangt ->
#      exit 2, nicht gruen (eine leere Grundgesamtheit belegt nichts).
{ printf 'stages:\n  - build\n\n'
  printf 'build:etwas:\n  stage: build\n  script:\n    - echo hallo\n'
} > "$ARBEIT/j_ohne_measure.yml"
fall "D3: kein stage:measure-Job ableitbar -> exit 2, nicht gruen" 2 jobs "$ARBEIT/j_ohne_measure.yml"

# (20) D4: alle vier Exports vorhanden, aber erst NACH dem messenden
#      "$DRIVER"-Aufruf -- zur Messzeit ist die Env leer. Gemessen werden muss
#      "die Env steht, wenn der Treiber forkt", nicht "der Text steht im Block".
GOLD_NACH_TREIBER=$(printf '      "$DRIVER" experiment_config measure_out\n      export COMDARE_GN_OPT="%s"\n      export COMDARE_GN_SIMD="%s"\n      export COMDARE_PLATFORM="amd@$(hostname)"\n      export COMDARE_LANE="amd"\n' "$KOEDER_OPT" "$KOEDER_SIMD")
mach_yaml "$ARBEIT/j_nach_treiber.yml" "$VOLL_MIT_TREIBER" "$GOLD_NACH_TREIBER"
fall "D4: Exports NACH dem Treiber-Aufruf -> zurueckgewiesen" 1 jobs "$ARBEIT/j_nach_treiber.yml"
befund_enthaelt "SPAET  measure:golden-320" \
    "der Befund ist die Reihenfolge (SPAET), nicht ein fehlender Export" \
    "der Befund nennt SPAET nicht -- rot aus dem falschen Grund"

# (21) D4-Gegenprobe: dieselben Exports VOR dem Treiber, mit einer
#      'test -x \"\$DRIVER\"'-Zeile davor -> genommen. Beweist zugleich, dass
#      die Existenz-Pruefung NICHT als Treiber-Aufruf zaehlt (sonst rot).
mach_yaml "$ARBEIT/j_treiber_ok.yml" "$VOLL_MIT_TREIBER" "$VOLL_MIT_TREIBER"
fall "D4: Exports VOR dem Treiber (test-Zeile zaehlt nicht) -> genommen" 0 jobs "$ARBEIT/j_treiber_ok.yml"

# =============================================================================
#  --selbstbiss: sieben WEGWERF-MUTANTEN der Wache. Jeder entfernt genau eine
#  Zusicherung; jeder MUSS an dem Fall auffliegen, der sie traegt. Ein Mutant,
#  der dasselbe Verdikt faellt, beweist, dass dieser Fall nichts prueft.
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

    # M2: statt des EXPORTS wird nur noch VAR=" gesucht -- Anwesenheit genuegt.
    #     Muss an Fall (16b) auffliegen (aktive Textzeile ohne export). Fall (13)
    #     traegt ihn NICHT mehr: dessen Kommentarzeile verwirft seit D1 schon
    #     der Kommentar-Filter, bevor die Marke gesucht wird.
    mutant "jobs: Anwesenheit statt Export" \
           's/marke = "export " name/marke = name/' \
           1 jobs "$ARBEIT/j_text_statt_export.yml"

    # M3: das leere Dokument faellt still auf gruen statt auf exit 2.
    #     Muss an Fall (8) auffliegen.
    mutant "eintraege: leeres Dokument wird gruen" \
           's/if \[ "$N_GES" -eq 0 \]; then/if false; then/' \
           2 eintraege "$ARBEIT/e_leer.xml"

    # M4 (D1): der Kommentar-Filter faellt weg -- auskommentierte Exports
    #     zaehlen wieder. Muss an Fall (16) auffliegen.
    mutant "jobs: Kommentarzeilen zaehlen wieder" \
           's/kopf_ist_kommentar(\$0) { next }/0 == 1 { next }/' \
           1 jobs "$ARBEIT/j_export_kommentar.yml"

    # M5 (D2): der Block-Ausschnitt schliesst wieder NUR an Nicht-Kommentar-
    #     Spalte-1-Zeilen (die alte Fassung). Muss an Fall (17) auffliegen.
    mutant "jobs: Spalte-1-Kommentar schliesst den Block nicht mehr" \
           's|\[\^ \\t\]/) { drin|[^ \\t#]/) { drin|' \
           1 jobs "$ARBEIT/j_spalte1_leck.yml"

    # M6 (D3): die Ableitung faellt auf die alte hart kodierte Liste zurueck.
    #     Muss an Fall (18) auffliegen (golden-640 wird unsichtbar).
    mutant "jobs: Job-Liste wieder hart kodiert" \
           's|JOBS_ABGELEITET=\$(ableiten_stage_measure "\$ZIEL")|JOBS_ABGELEITET="measure:smoke measure:golden-320"|' \
           1 jobs "$ARBEIT/j_dritter_job.yml"

    # M7 (D4): der Reihenfolge-Vergleich wird unerreichbar. Muss an Fall (20)
    #     auffliegen (Exports nach dem Treiber blieben gruen).
    mutant "jobs: Reihenfolge Export/Treiber ungeprueft" \
           's|-gt "\$POS_DRV"|-gt 999999|' \
           1 jobs "$ARBEIT/j_nach_treiber.yml"
fi

echo "============================================================================="
echo "NENNER (nie eine nackte Zahl):"
echo "  $N_FALL Zusicherung(en) gefahren -- das ist die Grundgesamtheit dieser Probe."
echo "  $N_HALT gehalten, $FEHLER gerissen."
if [ "$SELBSTBISS" -eq 1 ]; then
    echo "  davon 7 Wegwerf-Mutanten (K13: Koeder frisch gewuerfelt, nicht abgeschrieben)."
else
    echo "  ohne --selbstbiss: die 7 Mutanten-Faelle sind NICHT gefahren."
fi
echo "============================================================================="

if [ "$FEHLER" -ne 0 ]; then
    echo "PROBE ROT: $FEHLER von $N_FALL Zusicherung(en) gerissen." >&2
    exit 1
fi
echo "PROBE GRUEN: $N_HALT von $N_FALL Zusicherung(en) gehalten."
exit 0
