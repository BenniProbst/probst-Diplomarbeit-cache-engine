#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  PROBE fuer die XML-WOHLGEFORMTHEITS-WACHE (scripts/ci_xml_wellformed_guard.sh)
#  -- die Wache selbst ist ein Pruefling, nicht nur ein Pruefer.     (2026-08-09)
# =============================================================================
# ABGELOEST am 2026-08-09, NOCH AM TAG IHRER LANDUNG, durch
#   Code/tests/unit/test_ci_wache_xml_wellformed.cpp   (Google Test)
#
# WARUM -- der Defekt ist in dieser Datei, Zeilen 688-701 (heutige Zaehlung):
# das Selbstbiss-Orakel zaehlte JEDEN Rueckgabewert ausser 0 und 2 als Biss.
#     if   rc = 0 -> ROT   elif rc = 2 -> ROT   else -> "wird gefangen"
# Am Objekt gemessen: ein `tr`-Shim, der schlicht mit 127 endet, liess ALLE FUENF
# Mutanten als "gefangen (Probe rc=127)" durchgehen, GESAMT rc=0, "SELBSTBISS GRUEN" --
# und kein einziger Mutant war angesehen worden. Die "Literale Ausgabe:"-Zeilen der
# fuenf Faenge waren LEER, weil das Orakel die Riss-Literale gar nicht forderte.
# Weitere gemessene Defekte: F11 misst TEXT statt Ausfuehrung (grep -cF ohne
# Kommentarfilter); die allow_failure-Wache (F12) sieht NUR den eigenen Proben-Job,
# nie lint:xml-wellformed; das Orakel ist nicht fail-closed (od-Shim mit leerer Ausgabe
# -> 12/12 GRUEN); F11/F12 zaehlen fail-open (`N=$(grep -cF ... || true)`).
#
# Im Nachfolger ist ein Werkzeug-Ausfall eine EIGENE Prozess-Art (ExecFehlgeschlagen)
# und exit_code() liefert dafuer std::nullopt -- er kann keinem Soll-Code mehr gleichen.
#
# DIESE DATEI BLEIBT IM BAUM (Doku wird nie geloescht, sie zieht um). Ihre Mess-Befunde
# sind in die C++-Koepfe abgeschrieben. Ob ihr Job test:xml-wellformed-probe weiterlaeuft,
# entscheidet der Lead nach der Abnahme.
# =============================================================================
#
# SELBSTCHECK -- was diese Datei zusichert, und was NICHT:
#   ZUSICHERT: die Wache faellt bei jedem der 7 Eingaenge, bei denen ihr eigener
#              Kopf-Vertrag "Fehler" verspricht, und sie faellt NICHT bei den
#              3 Eingaengen, bei denen sie schweigen muss. Der Biss wird bei
#              JEDEM Lauf an Wegwerf-Mutanten neu bewiesen (--selbstbiss).
#   NICHT:     sie prueft weder xmllint selbst noch den XML-Bestand des ce
#              (das ce lintet seinen in SEINER Pipeline). Volle Grenzliste
#              unter TESTKRITIK, ganz unten.
#
# DER BEFUND, GEGEN DEN SIE GEBAUT IST:
# scripts/ci_xml_wellformed_guard.sh ist am 08.08.2026 gelandet (49114430) und
# wird seither von genau EINEM Job gerufen (.gitlab-ci.yml, Job lint:xml-
# wellformed). Ihr VERSCHWINDEN als Datei ist dort fail-closed abgefangen: `sh`
# auf eine fehlende Datei endet mit rc=127, der Job wird rot. Ungedeckt war
# ausschliesslich ihre AUFWEICHUNG -- faellt ein `exit` aus ihr heraus, sagt sie
# weiter "OK", und niemand merkt es. Das ist dieselbe Fehlerklasse, gegen die
# die Wache selbst gebaut wurde (fuenf XML-Dateien lagen ueber Wochen kaputt im
# Baum, weil keine Wache sie ansah), eine Ebene hoeher.
#
# WAS "BISS" HIER HEISST (TDD-Vertrag T-1):
# Die Probe wird nicht nur gegen die gesunde Wache gefahren, sondern zusaetzlich
# gegen WEGWERF-MUTANTEN, aus denen je ein Zweig entfernt ist. `--selbstbiss`
# fordert, dass die Probe an jedem Mutanten ROT wird. Eine Probe, die am kranken
# Objekt gruen bleibt, ist keine Probe.
#
# -----------------------------------------------------------------------------
# DIE ENTSCHEIDENDE VORPRUEFUNG: IST DER MUTIERTE ZWEIG UEBERHAUPT BEOBACHTBAR?
# -----------------------------------------------------------------------------
# Ein Mutant, der stirbt, weil eine ANDERE Zeile ihn faengt, beweist das
# Gegenteil von dem, was er soll. Die Wache hat 7 Ausstiege; jeder wurde am
# Objekt gemessen (Original gegen Mutant, sechs Eingaenge, rc protokolliert):
#
#   Ausstieg (Marker im Text)          Eingang, der ihn zeigt   ORIG -> MUTANT
#   ---------------------------------  -----------------------  --------------
#   "kein git-Arbeitsbaum"             Verzeichnis ohne .git      2 -> 128
#   "wurde im PATH NICHT gefunden"     PATH ohne xmllint          2 ->   1
#   "NULL getrackte *.xml gefunden"    Repo ohne jede *.xml       2 ->   0
#   "FAILED --"                        kaputte *.xml              1 ->   0
#   stderr-Riegel (elif-Zweig)         Namensraum-Fehler          1 ->   0
#   "Nenner nicht vertrauenswuerdig"   KEINER  -- s.u.            unveraendert
#   "$GREP fehlt"                      KEINER ohne root
#
# ZWEI ZWEIGE HABEN DESHALB BEWUSST KEINEN MUTANTEN:
#
#  (a) DER NENNER-MISMATCH-ZWEIG IST TOT -- gemessen, nicht vermutet.
#      Er soll feuern, wenn ein Dateiname ein Zeilenende enthaelt und der
#      zeilenweise Nenner deshalb kleiner waere als der NUL-getrennte. Genau
#      dieser Fall wurde gebaut: eine getrackte Datei mit \n im Namen. Gegenprobe
#      am Objekt, git 2.43.0:
#          git -c core.quotePath=off ls-files '*.xml'  ->  "a\nb.xml"   (1 Zeile)
#          ... | tr -dc '\0' | wc -c                   ->  1
#      git C-quotet Steuerzeichen im NICHT-`-z`-Ausgabeweg IMMER; core.quotePath
#      regelt nur Bytes >= 0x80. Beide Zaehler koennen daher nicht auseinander-
#      laufen. Ein Mutant, der diesen `exit 2` entfernt, bleibt an ALLEN sechs
#      Eingaengen gruen -- er waere ein Beweis fuer nichts. Der Zweig ist
#      harmlos, aber er ist keine Deckung. So gemeldet, nicht stillgeschwiegen.
#
#  (b) DER GREP-ZWEIG ist ohne root nicht ausloesbar: die Wache haelt den Pfad
#      /usr/bin/grep fest verdrahtet, kein ENV kann ihn umbiegen. Ehrlich als
#      Luecke benannt statt mit einem Schein-Fall zugedeckt.
#
# -----------------------------------------------------------------------------
# EIN ZWEITER BEFUND AM OBJEKT: DER STDERR-RIEGEL FEUERT AUS EINEM ANDEREN GRUND
# ALS SEIN KOMMENTAR BEHAUPTET
# -----------------------------------------------------------------------------
# Der Kopf der Wache begruendet den Riegel (rc=0, aber stderr NICHT leer) mit dem
# per --nonet blockierten Laden einer externen Entity. Nachgemessen mit dem
# xmllint dieser Maschine (libxml2 20914) ist genau das NICHT der Fall -- vier
# Bauarten wurden probiert, alle liefern rc=0 UND 0 Byte stderr:
#     externe DTD ueber http:, externe DTD lokal, externe Entity im Inhalt,
#     externer Parameter-Entity im internen Subset.
# Der Riegel ist trotzdem NICHT tot: ein undefiniertes Namensraum-Praefix liefert
#     xmllint --noout --nonet  ->  rc=0, stderr 95 Byte
#         "namespace error : Namespace prefix a on b is not defined"
# Das ist eine echte, im Alltag erreichbare Fehlerklasse -- und der einzige hier
# gefundene Weg in den Zweig. Fall F7 faehrt deshalb den Namensraum-Fehler, nicht
# die externe Entity. Waere die Probe der Doku gefolgt statt der Messung, haette
# sie einen gruenen Fall gebaut und den Riegel ungedeckt gelassen.
#
# ORAKEL (T-5): die erwarteten Zahlen stammen NICHT aus der Wache und nicht aus
# einer Doku, sondern aus einem Wuerfel: die Probe zieht je Lauf frisch aus
# /dev/urandom, wie viele gute und wie viele kaputte XML sie anlegt, und welchen
# Token jede traegt (K13: der Koeder wird erzeugt, nie abgeschrieben). Eine
# Wache, die eine feste Zahl faelscht, faellt daran. Die Zahlen im Protokoll
# wechseln deshalb bei jedem Lauf -- das ist Absicht, kein Rauschen.
#
# WERKBANK: jeder Fall bekommt ein eigenes Wegwerf-git-Repo unter mktemp -d. Der
# Bestand wird nie angefasst, es wird nie committet (nur `git add`, also keine
# user.name/user.email noetig). GIT_DIR und Verwandte werden ausdruecklich
# entfernt, damit kein CI-Environment die Fixtures in ein fremdes Repo umbiegt.
#
# AUFRUF:
#   sh ci/tests/xml_wellformed_probe.sh              # nur die Faelle
#   sh ci/tests/xml_wellformed_probe.sh --selbstbiss # Faelle + Mutationsbeweis
#
# ENV:
#   COMDARE_WACHE   Pfad zur zu pruefenden Wache
#                   (Default: <repo>/scripts/ci_xml_wellformed_guard.sh).
#                   Der --selbstbiss-Zweig setzt sie auf die Mutanten.
#
# EXIT: 0 = alle Faelle gehalten
#       1 = mindestens ein Fall gerissen (Zahl + literale Ausgabe im Protokoll)
#       2 = die Probe konnte nicht pruefen (Wache fehlt, Werkzeug fehlt, Fixture
#           liess sich nicht bauen, Mutation griff nicht, Koeder biss nicht)
#           -- ausdruecklich KEIN Gruen.
#
# TESTKRITIK (T-9), was diese Probe NICHT deckt:
#   - Den Nenner-Mismatch- und den grep-Zweig: beide nicht ausloesbar, s.o.
#   - Den cd-Fehlschlag-Zweig (Zeile "Wechsel in die Repo-Wurzel"): das Ziel
#     kommt aus `git rev-parse --show-toplevel` und existiert damit immer.
#   - Submodule: die Wache steigt bewusst nicht hinein. Die Probe baut kein
#     Submodul-Fixture; sie belegt diese Zusage NICHT.
#   - xmllint selbst: die Probe traut seinem Urteil. Faellt libxml2 auf eine
#     Fassung zurueck, die "--" im Kommentar durchlaesst, faellt F2 auf --
#     als Fehler der Wache, obwohl das Werkzeug schuld waere.
#   - EIN BEFUND, DER HIER NUR FESTGEHALTEN UND NICHT GEHEILT WIRD (F9): eine
#     Datei, die im Index steht, im Arbeitsbaum aber fehlt (sparse checkout),
#     wird im Nenner MITGEZAEHLT, aber nie geoeffnet. Die Wache meldet dann
#     "1 XML-Dateien geprueft, alle wohlgeformt", obwohl sie null gelesen hat.
#     F9 friert dieses Verhalten ein, damit eine spaetere Heilung sichtbar
#     bricht; die Entscheidung darueber gehoert nicht in die Probe.
#
# POSIX-sh (die CI ruft `sh`, das ist hier dash), ASCII-only, kein Python.
# =============================================================================

set -eu

SELBST_DIR=$(cd "$(dirname "$0")" && pwd)
SELBST="$SELBST_DIR/$(basename "$0")"
REPO=$(cd "$SELBST_DIR/../.." && pwd)
WACHE="${COMDARE_WACHE:-$REPO/scripts/ci_xml_wellformed_guard.sh}"
CI_YML="$REPO/.gitlab-ci.yml"

# Kein fremdes git-Environment darf die Wegwerf-Repos umbiegen.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_OBJECT_DIRECTORY 2>/dev/null || true

MODUS="${1:-}"
case "$MODUS" in
    ''|--selbstbiss) : ;;
    *) echo "AUFRUF: sh ci/tests/xml_wellformed_probe.sh [--selbstbiss]" >&2; exit 2 ;;
esac

if [ ! -f "$WACHE" ]; then
    echo "ABBRUCH: Wache '$WACHE' nicht gefunden -- die Probe konnte nicht pruefen." >&2
    exit 2
fi
for _w in git xmllint; do
    command -v "$_w" >/dev/null 2>&1 || {
        echo "ABBRUCH: '$_w' fehlt -- die Probe konnte nicht pruefen (kein Gruen ohne Pruefung)." >&2
        exit 2
    }
done

WERK=$(mktemp -d) || exit 2
trap 'rm -rf "$WERK"' EXIT INT TERM
OUT="$WERK/_stdout"; ERR="$WERK/_stderr"; BEIDE="$WERK/_beide"
PATH_ECHT="$PATH"

N_FALL=0; N_OK=0; N_ROT=0
RC=0

# --- Wuerfel (K13): der Koeder wird erzeugt, nie abgeschrieben ----------------
# od statt `tr < /dev/urandom | head -c`: kein SIGPIPE, kein rc-Ratespiel.
token() { od -An -tx1 -N6 /dev/urandom | tr -d ' \n'; }
wuerfel() {           # Zahl aus [$1..$2]; kleine Spannen, Modulo-Schiefe egal
    _lo="$1"; _hi="$2"; _spanne=$((_hi - _lo + 1))
    _roh=$(od -An -tu1 -N1 /dev/urandom | tr -d ' \n')
    echo $(( _lo + (_roh % _spanne) ))
}

# --- Fixtures ----------------------------------------------------------------
# Ein Wegwerf-Repo je Fall. `git add` ohne Commit reicht: die Wache liest den
# INDEX (git ls-files), nicht die Historie -- deshalb braucht es hier keine
# git-Identitaet, was die Probe in einem nackten CI-Container lauffaehig haelt.
mkrepo() {            # $1 = Kurzname -> setzt $D
    D="$WERK/$1"
    mkdir -p "$D"
    ( cd "$D" && git init -q >/dev/null 2>&1 ) || {
        echo "ABBRUCH: 'git init' im Fixture '$1' fehlgeschlagen." >&2; exit 2; }
}
addiere() {           # alles im Fixture in den Index
    ( cd "$D" && git add -A >/dev/null 2>&1 ) || {
        echo "ABBRUCH: 'git add' im Fixture fehlgeschlagen." >&2; exit 2; }
}
gute_xml() {          # $1 = Pfad relativ zu $D ; gibt den Token aus
    _t=$(token)
    mkdir -p "$(dirname "$D/$1")"
    printf '<?xml version="1.0"?>\n<wurzel token="%s"><kind/></wurzel>\n' "$_t" > "$D/$1"
    echo "$_t"
}
kaputte_xml() {       # $1 = Pfad relativ zu $D ; die HISTORISCHE Fehlerklasse:
    _t=$(token)       # "--" INNERHALB eines XML-Kommentars (XML 1.0, 2.5)
    mkdir -p "$(dirname "$D/$1")"
    printf '<?xml version="1.0"?>\n<wurzel><!-- Aufruf: prog --flag %s --></wurzel>\n' "$_t" > "$D/$1"
    echo "$_t"
}

# --- Lauf ohne Pipe: rc=$? nach einer Pipe misst das LETZTE Glied (K11) -------
lauf() {              # $1 = Arbeitsverzeichnis, $2 = PATH (optional)
    : > "$OUT"; : > "$ERR"
    FALL_WACHE=1
    _dir="$1"; _pfad="${2:-$PATH_ECHT}"
    set +e
    (
        cd "$_dir" || exit 99
        PATH="$_pfad"
        export PATH
        sh "$WACHE"
    ) > "$OUT" 2> "$ERR"
    RC=$?
    set -e
    cat "$OUT" "$ERR" > "$BEIDE"
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
# Abnahme-Faellen F11/F12. Ohne diese Trennung haengt das Protokoll eines
# gerissenen Abnahme-Falls die Ausgabe des LETZTEN Wache-Laufs an und behauptet
# damit einen Zusammenhang, den es nicht gibt.
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
echo "PROBE XML-WOHLGEFORMTHEITS-WACHE"
echo "  Pruefling : $WACHE"
echo "  Werkbank  : $WERK"
echo "  Modus     : ${MODUS:-nur-faelle}"
echo "  xmllint   : $(xmllint --version 2>&1 | head -1)"
echo "============================================================================="

# =============================================================================
# F1  G gewuerfelte wohlgeformte XML -> rc=0, und der Nenner muss GENAU G nennen.
#     G und die Token stammen aus /dev/urandom (T-5: fremdes Orakel).
# =============================================================================
G1=$(wuerfel 1 6)
fall "F1  $G1 gewuerfelte wohlgeformte *.xml -> rc=0, Nenner nennt $G1"
mkrepo f1
_i=1
while [ "$_i" -le "$G1" ]; do T=$(gute_xml "gut_$_i.xml"); _i=$((_i + 1)); done
fordere_literal "$D/gut_$G1.xml" "$T"     # der Koeder liegt wirklich in der Fixture
addiere
lauf "$D"
fordere_rc 0
fordere_literal "$OUT" "pruefe $G1 getrackte *.xml"
fordere_literal "$OUT" "  $G1 XML-Dateien geprueft, 0 nicht wohlgeformt."
fordere_literal "$OUT" "  (keine)"
fordere_literal "$OUT" "OK ($G1 XML-Dateien geprueft, alle wohlgeformt)."
fall_ende

# =============================================================================
# F2  DIE HISTORISCHE FEHLERKLASSE: "--" innerhalb eines XML-Kommentars. Genau
#     dieser Defekt lag ueber Wochen in fuenf getrackten Dateien im Baum. rc=1,
#     und die Wache MUSS die Datei namentlich nennen (Aussage statt Anwesenheit).
# =============================================================================
fall "F2  '--' im XML-Kommentar -> rc=1, Datei namentlich genannt"
mkrepo f2
T2=$(kaputte_xml "messreihen_nachbau.xml")
addiere
lauf "$D"
fordere_rc 1
fordere_literal "$OUT" "  messreihen_nachbau.xml  (xmllint rc=1)"
fordere_literal "$OUT" "Double hyphen within comment"
fordere_literal "$OUT" "  1 XML-Dateien geprueft, 1 nicht wohlgeformt."
fordere_literal "$OUT" "FAILED -- 1 von 1 getrackten XML-Dateien"
fordere_kein_literal "$OUT" "alle wohlgeformt"
fall_ende

# =============================================================================
# F3  Gemischter Bestand: G gute + B kaputte, beide gewuerfelt. Die Wache darf
#     nicht bei der ersten kaputten Datei stehenbleiben -- der Nenner muss BEIDE
#     Zahlen richtig tragen. Zugleich der Beleg, dass '*.xml' als git-Pathspec
#     auch in Unterverzeichnisse greift (die kaputten liegen tief).
# =============================================================================
G3=$(wuerfel 1 4); B3=$(wuerfel 2 4); S3=$((G3 + B3))
fall "F3  $G3 gute + $B3 kaputte (tief verschachtelt) -> rc=1, Nenner $S3/$B3"
mkrepo f3
_i=1
while [ "$_i" -le "$G3" ]; do gute_xml "flach_$_i.xml" > /dev/null; _i=$((_i + 1)); done
_i=1
while [ "$_i" -le "$B3" ]; do kaputte_xml "a/b/c/tief_$_i.xml" > /dev/null; _i=$((_i + 1)); done
addiere
lauf "$D"
fordere_rc 1
fordere_literal "$OUT" "pruefe $S3 getrackte *.xml"
fordere_literal "$OUT" "  a/b/c/tief_1.xml  (xmllint rc=1)"
fordere_literal "$OUT" "  $S3 XML-Dateien geprueft, $B3 nicht wohlgeformt."
fordere_literal "$OUT" "FAILED -- $B3 von $S3 getrackten XML-Dateien"
fall_ende

# =============================================================================
# F4  NULL getrackte *.xml -> rc=2, NICHT rc=0. Ein leerer Nenner ist kein
#     bestandener Lauf. DIESER FALL MACHT DEN ZWEIG UEBERHAUPT BEOBACHTBAR:
#     ohne ihn liefe ein Mutant ohne diesen `exit 2` auf rc=0 durch und bliebe
#     gruen (gemessen: 2 -> 0).
# =============================================================================
fall "F4  Repo ohne jede *.xml -> rc=2 (leerer Nenner ist kein Gruen)"
mkrepo f4
printf 'kein xml hier, nur Prosa: %s\n' "$(token)" > "$D/liesmich.txt"
addiere
lauf "$D"
fordere_rc 2
fordere_literal "$OUT" "ABBRUCH -- NULL getrackte *.xml gefunden."
fordere_kein_literal "$OUT" "alle wohlgeformt"
fall_ende

# =============================================================================
# F5  Kein git-Arbeitsbaum -> rc=2. Die Wache holt Wurzel UND Nenner aus git;
#     ohne git gibt es keine belastbare Aussage.
#     GEGENPROBE VOR DEM FALL: dass das Fixture WIRKLICH ausserhalb jedes
#     Repos liegt, wird gemessen und nicht angenommen -- liegt TMPDIR selbst in
#     einem git-Baum, pruefte dieser Fall etwas ganz anderes und waere still
#     gruen. Das ist Abbruch (rc=2), kein bestandener Fall.
# =============================================================================
fall "F5  Verzeichnis ohne git-Baum -> rc=2"
mkdir -p "$WERK/keingit"
_top=$( cd "$WERK/keingit" && git rev-parse --show-toplevel 2>/dev/null || true )
if [ -n "$_top" ]; then
    echo "  [ABBRUCH] Gegenprobe fehlgeschlagen: '$WERK/keingit' liegt im git-Baum '$_top'." >&2
    echo "            Der Fall koennte nicht pruefen, was er behauptet." >&2
    exit 2
fi
echo "        Gegenprobe: 'git rev-parse --show-toplevel' liefert dort leer -- kein Repo."
lauf "$WERK/keingit"
fordere_rc 2
fordere_literal "$OUT" "ABBRUCH -- kein git-Arbeitsbaum"
# Der entscheidende Riegel: OHNE diese Forderung ueberlebt der Mutant. Faellt
# der `exit 2` weg, laeuft die Wache weiter, `cd ""` gelingt in dash klaglos
# (gemessen: rc=0, Verzeichnis unveraendert), und erst `git ls-files` bricht ab
# -- mit rc=128 statt 2. Die rc-Forderung faengt ihn; dieser Text belegt, dass
# der Abbruch aus dem RICHTIGEN Zweig kam und nicht aus dem cd-Zweig dahinter.
fordere_kein_literal "$OUT" "Wechsel in die Repo-Wurzel"
fall_ende

# =============================================================================
# F6  xmllint fehlt -> rc=2 mit Nachinstallations-Hinweis, NICHT stiller Skip.
#     Ein Skip waere das Abschalten der Wache, nicht ihr Bestehen.
#     Der PATH-Klon spiegelt /usr/bin und /bin vollstaendig und entfernt daraus
#     NUR xmllint -- kein handverlesenes Werkzeug-Set, das spaeter still zu
#     klein waere, wenn die Wache ein weiteres Programm benutzt.
# =============================================================================
fall "F6  PATH ohne xmllint -> rc=2 (kein stiller Skip)"
PBIN="$WERK/bin_ohne_xmllint"
mkdir -p "$PBIN"
for _d in /usr/bin /bin; do
    [ -d "$_d" ] || continue
    ( cd "$_d" && ls ) 2>/dev/null | while IFS= read -r _f; do
        [ -e "$PBIN/$_f" ] || ln -s "$_d/$_f" "$PBIN/$_f" 2>/dev/null || true
    done
done
rm -f "$PBIN/xmllint"
# Gegenprobe: der Klon muss alles Noetige tragen und xmllint eben NICHT.
_fehlt=''
for _w in sh git tr wc sed; do
    [ -e "$PBIN/$_w" ] || _fehlt="$_fehlt $_w"
done
if [ -e "$PBIN/xmllint" ]; then _noch_da='JA'; else _noch_da='nein'; fi
if [ -n "$_fehlt" ] || [ "$_noch_da" = 'JA' ]; then
    echo "  [ABBRUCH] PATH-Klon untauglich: fehlend ->$_fehlt<- ; xmllint noch da? $_noch_da" >&2
    exit 2
fi
echo "        Gegenprobe: Klon traegt sh/git/tr/wc/sed, xmllint entfernt."
mkrepo f6
gute_xml "ok.xml" > /dev/null
addiere
lauf "$D" "$PBIN"
fordere_rc 2
fordere_literal "$OUT" "ABBRUCH -- xmllint (libxml2) wurde im PATH NICHT gefunden."
fordere_literal "$OUT" "libxml2-utils"
fordere_kein_literal "$OUT" "alle wohlgeformt"
fall_ende

# =============================================================================
# F7  DER STDERR-RIEGEL: xmllint sagt rc=0 UND schreibt trotzdem auf stderr.
#     Wer nur den Rueckgabewert liest, laesst diese Klasse gruen durch -- genau
#     die Fehlerklasse, gegen die die Wache gebaut ist. Traeger ist hier ein
#     undefiniertes Namensraum-Praefix; die im Wach-Kopf genannte externe Entity
#     liefert auf dieser libxml2 0 Byte und taugt NICHT als Traeger (s. Kopf
#     dieser Probe). Die genaue Byte-Zahl haengt am Fixture-Text und wird
#     deshalb nicht festgeschrieben, sondern zur Laufzeit gemessen und gedruckt.
# =============================================================================
fall "F7  rc=0 mit nicht-leerem stderr (Namensraum) -> FALSE-GREEN, rc=1"
mkrepo f7
T7=$(token)
printf '<?xml version="1.0"?>\n<wurzel token="%s"><nsx:kind/></wurzel>\n' "$T7" > "$D/falsegreen.xml"
addiere
# Gegenprobe: der Traeger muss WIRKLICH rc=0 mit nicht-leerem stderr liefern.
set +e
_a=$(xmllint --noout --nonet "$D/falsegreen.xml" 2>&1); _r=$?
set -e
_n=$(printf '%s' "$_a" | wc -c | tr -d ' ')
if [ "$_r" -ne 0 ] || [ "$_n" -eq 0 ]; then
    echo "  [ABBRUCH] Traeger untauglich: xmllint rc=$_r, stderr $_n Byte." >&2
    echo "            Erwartet war rc=0 MIT Ausgabe; ohne das prueft F7 den Riegel nicht." >&2
    exit 2
fi
echo "        Gegenprobe: xmllint rc=$_r, stderr $_n Byte -- der Riegel wird wirklich betreten."
lauf "$D"
fordere_rc 1
fordere_literal "$OUT" "(rc=0, aber stderr NICHT leer -- FALSE-GREEN"
fordere_literal "$OUT" "  1 XML-Dateien geprueft, 1 nicht wohlgeformt."
fordere_kein_literal "$OUT" "alle wohlgeformt"
fall_ende

# =============================================================================
# F8  Der Bestand kommt aus git, NICHT aus dem Arbeitsbaum. Eine kaputte, aber
#     UNGETRACKTE Datei darf die Wache nicht rot faerben -- sonst waere jeder
#     lokale Kladde-Entwurf ein CI-Ausfall. Zugleich die Gegenrichtung zu F2:
#     die Probe belegt, dass F2 nicht einfach "irgendeine kaputte Datei im
#     Verzeichnis" gefunden hat.
# =============================================================================
fall "F8  kaputte, aber UNGETRACKTE *.xml -> rc=0 (Bestand kommt aus git)"
mkrepo f8
gute_xml "getrackt.xml" > /dev/null
addiere
kaputte_xml "nur_im_baum.xml" > /dev/null    # bewusst NACH dem add: bleibt ungetrackt
_ungetrackt=$( cd "$D" && git ls-files --others --exclude-standard )
if [ "$_ungetrackt" != "nur_im_baum.xml" ]; then
    echo "  [ABBRUCH] Fixture untauglich: ungetrackt ist >>$_ungetrackt<<, erwartet nur_im_baum.xml" >&2
    exit 2
fi
echo "        Gegenprobe: git sieht 'nur_im_baum.xml' als ungetrackt."
lauf "$D"
fordere_rc 0
fordere_literal "$OUT" "pruefe 1 getrackte *.xml"
fordere_literal "$OUT" "  1 XML-Dateien geprueft, 0 nicht wohlgeformt."
fordere_kein_literal "$OUT" "nur_im_baum.xml"
fall_ende

# =============================================================================
# F9  Im Index, im Arbeitsbaum NICHT da (sparse checkout). Die Wache ueberspringt
#     sie (`[ -f ] || continue`) -- zaehlt sie aber im Nenner MIT. Der Fall
#     friert dieses Verhalten ein und benennt es: gemeldet wird "1 geprueft,
#     alle wohlgeformt", geoeffnet wurde null. Das ist eine UEBERZEICHNUNG des
#     Nenners, kein Absturz; sie steht in der TESTKRITIK oben. Wird sie
#     geheilt, bricht dieser Fall SICHTBAR -- genau dafuer ist er da.
# =============================================================================
fall "F9  im Index, im Baum fehlend -> rc=0, Nenner zaehlt sie MIT (eingefroren)"
mkrepo f9
gute_xml "verschwunden.xml" > /dev/null
addiere
rm -f "$D/verschwunden.xml"
_idx=$( cd "$D" && git ls-files '*.xml' )
if [ "$_idx" != "verschwunden.xml" ]; then
    echo "  [ABBRUCH] Fixture untauglich: Index meldet >>$_idx<<" >&2
    exit 2
fi
echo "        Gegenprobe: git ls-files fuehrt sie weiter, die Datei ist geloescht."
lauf "$D"
fordere_rc 0
fordere_literal "$OUT" "  1 XML-Dateien geprueft, 0 nicht wohlgeformt."
fall_ende

# =============================================================================
# F10 Wohlgeformt trotz internem DOCTYPE und trotz eines Kommentars, der NUR
#     EINEN Bindestrich traegt. Die Wache darf nicht auf "Bindestrich im
#     Kommentar" anschlagen, sondern nur auf die DOPPELUNG -- sonst waere sie
#     ein Fehlalarm-Generator und wuerde bei der ersten Welle abgeschaltet.
# =============================================================================
fall "F10 interner DOCTYPE + einzelner Bindestrich im Kommentar -> rc=0"
mkrepo f10
T10=$(token)
{
    printf '<?xml version="1.0" encoding="UTF-8"?>\n'
    printf '<!DOCTYPE messreihen [ <!ELEMENT messreihen EMPTY> ]>\n'
    printf '<!-- Aufruf mit einem Bindestrich: prog -flag token=%s -->\n' "$T10"
    printf '<messreihen/>\n'
} > "$D/mit_doctype.xml"
addiere
lauf "$D"
fordere_rc 0
fordere_literal "$OUT" "  1 XML-Dateien geprueft, 0 nicht wohlgeformt."
fordere_literal "$OUT" "OK (1 XML-Dateien geprueft, alle wohlgeformt)."
fall_ende

# =============================================================================
# F11 ABNAHME: die Wache selbst ist in .gitlab-ci.yml registriert.
#     ZUERST DER KOEDER -- eine Zahl aus grep ohne beissenden Koeder ist keine
#     Aussage, sondern ein moegliches Werkzeug-Versagen. /usr/bin/grep ist auf
#     dieser Maschine ugrep; ein Muster mit '$(' ist ihm ohne -F eine stille
#     Anker-Falle. Der Koeder wird gewuerfelt (K13), nie abgeschrieben.
# =============================================================================
fall "F11 Abnahme: Aufruf der Wache in .gitlab-ci.yml (nach beissendem Koeder)"
if [ ! -f "$CI_YML" ]; then
    echo "ABBRUCH: $CI_YML fehlt -- die Abnahme konnte nicht pruefen." >&2
    exit 2
fi
K=$(wuerfel 2 5)
KTOK=$(token)
KOEDER="$WERK/koeder_ci.yml"
: > "$KOEDER"
_i=1
while [ "$_i" -le "$K" ]; do
    printf '    - sh scripts/ci_xml_wellformed_guard.sh   # koeder-%s-%s\n' "$KTOK" "$_i" >> "$KOEDER"
    printf '      allow_failure: true   # koeder-%s-%s\n' "$KTOK" "$_i" >> "$KOEDER"
    _i=$((_i + 1))
done
printf '    - harmlose Zeile ohne Muster\n' >> "$KOEDER"
K_IST=$(grep -cF -- 'sh scripts/ci_xml_wellformed_guard.sh' "$KOEDER" || true)
K_AF=$(grep -cF -- 'allow_failure' "$KOEDER" || true)
if [ "$K_IST" != "$K" ] || [ "$K_AF" != "$K" ]; then
    echo "  [ABBRUCH] Koeder biss NICHT: $K geschrieben, grep -cF meldet $K_IST (Aufruf) / $K_AF (allow_failure)." >&2
    echo "            Ohne beissenden Koeder ist jede Zahl an .gitlab-ci.yml wertlos." >&2
    exit 2
fi
echo "        Koeder beisst: $K gewuerfelte Vorkommen je Muster geschrieben, $K_IST / $K_AF gefunden."
N_WACHE=$(grep -cF -- 'sh scripts/ci_xml_wellformed_guard.sh' "$CI_YML" || true)
if [ "$N_WACHE" = "0" ]; then
    reiss "kein Aufruf der Wache in .gitlab-ci.yml -- sie liefe in keinem Job (T-7)"
else
    echo "        .gitlab-ci.yml: $N_WACHE Aufruf(e) der Wache (Nenner: $(awk 'END{print NR}' "$CI_YML") Zeilen)."
fi
fall_ende

# =============================================================================
# F12 REGISTRIERUNG IST TEIL DES TESTS (T-7): diese Probe muss selbst in
#     .gitlab-ci.yml gerufen werden, mit --selbstbiss, und ihr Job darf KEIN
#     allow_failure tragen. Sonst laesst sich die Deckung entfernen, ohne dass
#     etwas rot wird. Ein Test, der in keinem Job faehrt, ist nicht gebaut.
# =============================================================================
fall "F12 eigene Registrierung mit --selbstbiss, ohne allow_failure"
AUFRUF='ci/tests/xml_wellformed_probe.sh --selbstbiss'
N_AUFRUF=$(grep -cF -- "$AUFRUF" "$CI_YML" || true)
if [ "$N_AUFRUF" = "0" ]; then
    reiss "kein Aufruf von '$AUFRUF' in .gitlab-ci.yml -- die Probe waere unregistriert"
else
    echo "        $N_AUFRUF Aufruf(e) in .gitlab-ci.yml (zugleich Gegenprobe: grep -F findet hier)."
fi
JOB='test:xml-wellformed-probe:'
BLOCK="$WERK/_jobblock"
# Blockende = die naechste Zeile in SPALTE 0, Kommentarzeilen AUSDRUECKLICH
# eingeschlossen. Nimmt man '#' vom Blockende aus, laeuft der Block in den
# Kommentarkopf des NAECHSTEN Jobs -- und meldet dort ein allow_failure, das es
# im Job nie gab. In dieser Datei stehen Job-interne Kommentare stets
# eingerueckt; Spalte 0 trennt die Jobs.
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
        reiss "der Job traegt allow_failure -- eine advisory Probe ist die naechste stille Null"
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
    echo "PROBE ROT: $N_ROT von $N_FALL Faellen gerissen." >&2
    exit 1
fi
echo "PROBE GRUEN: $N_OK von $N_FALL Faellen gehalten."

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
ORIG_E2=$(awk '/^[[:space:]]*exit 2$/{n++} END{print n+0}' "$WACHE")
ORIG_E1=$(awk '/^[[:space:]]*exit 1$/{n++} END{print n+0}' "$WACHE")
echo "  Wache: $ORIG_ZEILEN Zeilen, davon $ORIG_E2 freistehende 'exit 2' und $ORIG_E1 'exit 1'."
if [ "$ORIG_E2" -ne 4 ] || [ "$ORIG_E1" -ne 1 ]; then
    echo "  ABBRUCH: erwartet waren 4 freistehende 'exit 2' und 1 'exit 1'," >&2
    echo "           gefunden $ORIG_E2 / $ORIG_E1. Die Wache hat sich strukturell" >&2
    echo "           geaendert -- die Mutation waere geraten statt gezielt." >&2
    exit 2
fi

# Die Mutanten werden ueber den TEXT ihres Zweiges gewaehlt, nicht ueber eine
# Zeilennummer: Zeilenanker verrutschen bei jeder Bearbeitung der Wache und
# wuerden dann lautlos den falschen Zweig treffen.
mut_exit_nach() {     # $1 = Zieldatei, $2 = Markertext, $3 = exit-Code
    awk -v marker="$2" -v code="$3" '
        BEGIN { gesehen = 0; weg = 0 }
        {
            if (!gesehen && index($0, marker) > 0) { gesehen = 1; print; next }
            if (gesehen && !weg && $0 ~ ("^[[:space:]]*exit " code "$")) { weg = 1; next }
            print
        }
        END { if (!gesehen || !weg) exit 3 }
    ' "$WACHE" > "$1"
}
mut_riegel() {        # $1 = Zieldatei -- entfernt den ganzen stderr-elif-Zweig
    awk -v start='elif [ -n "$AUSGABE" ]; then' '
        BEGIN { s = 0; getroffen = 0 }
        {
            if (s == 0 && index($0, start) > 0) { s = 1; getroffen = 1; next }
            if (s == 1) { if (index($0, "|| true") > 0) { s = 0 } ; next }
            print
        }
        END { if (!getroffen) exit 3 }
    ' "$WACHE" > "$1"
}

N_MUT=0; N_MUT_GEBISSEN=0
selbstbiss_fall() {   # $1 = Kurzname, $2 = Bauart, $3 = Marker, $4 = Soll-Differenz
    N_MUT=$((N_MUT + 1))
    _m="$WERK/mutant_$N_MUT.sh"
    set +e
    if [ "$2" = "riegel" ]; then mut_riegel "$_m"; else mut_exit_nach "$_m" "$3" "$2"; fi
    _mrc=$?
    set -e
    if [ "$_mrc" -ne 0 ]; then
        echo "  [ABBRUCH] Mutation '$1' fand ihren Zweig NICHT (awk rc=$_mrc)." >&2
        echo "            Marker >>$3<< steht nicht mehr in der Wache." >&2
        exit 2
    fi
    _mz=$(awk 'END{print NR}' "$_m")
    _diff=$((ORIG_ZEILEN - _mz))
    if [ "$_diff" -ne "$4" ]; then
        echo "  [ABBRUCH] Mutation '$1' griff NICHT: Zeilendifferenz $_diff, erwartet $4." >&2
        exit 2
    fi
    if sh -n "$_m" 2>/dev/null; then :; else
        echo "  [ABBRUCH] Mutant '$1' ist syntaktisch kaputt -- er wuerde aus dem" >&2
        echo "            falschen Grund sterben und nichts beweisen." >&2
        exit 2
    fi
    chmod +x "$_m"
    echo ""
    echo "  --- Mutant '$1' ($ORIG_ZEILEN -> $_mz Zeilen, $_diff entfernt, sh -n sauber) ---"
    _log="$WERK/mutlog_$N_MUT.txt"
    set +e
    COMDARE_WACHE="$_m" sh "$SELBST" > "$_log" 2>&1
    _rc=$?
    set -e
    if [ "$_rc" -eq 0 ]; then
        echo "  [ROT ]  Mutant '$1' UEBERLEBT die Probe (rc=0) -- die Probe beisst hier nicht."
        sed 's/^/          | /' "$_log"
    elif [ "$_rc" -eq 2 ]; then
        echo "  [ROT ]  Mutant '$1' liess die Probe ABBRECHEN (rc=2) statt sie zu reissen."
        echo "          Ein Abbruch ist kein Biss: er belegt nur, dass die Probe nicht pruefen"
        echo "          konnte. Literale Ausgabe:"
        sed 's/^/          | /' "$_log"
    else
        N_MUT_GEBISSEN=$((N_MUT_GEBISSEN + 1))
        echo "  [ OK ]  Mutant '$1' wird gefangen (Probe rc=$_rc). Literale Ausgabe:"
        awk '/^  \[ROT \]|^        RISS:|^NENNER:|^PROBE /' "$_log" | sed 's/^/          | /'
    fi
}

# Jeder Mutant traegt den Eingang, der ihn ueberhaupt sichtbar macht -- gemessen,
# nicht angenommen (Matrix im Kopf dieser Datei).
selbstbiss_fall "M1  ohne 'exit 2' im Keine-git-Zweig    (toetet F5,  2->128)" \
                2 "kein git-Arbeitsbaum" 1
selbstbiss_fall "M2  ohne 'exit 2' im Kein-xmllint-Zweig (toetet F6,  2->1)" \
                2 "wurde im PATH NICHT gefunden" 1
selbstbiss_fall "M3  ohne 'exit 2' im NULL-XML-Zweig     (toetet F4,  2->0)" \
                2 "NULL getrackte *.xml gefunden" 1
selbstbiss_fall "M4  ohne 'exit 1' im FAILED-Zweig       (toetet F2/F3/F7, 1->0)" \
                1 "FAILED --" 1
selbstbiss_fall "M5  ohne den stderr-Riegel (elif-Zweig) (toetet F7,  1->0)" \
                riegel "" 4

echo ""
echo "============================================================================="
echo "NENNER SELBSTBISS: $N_MUT Mutanten gefahren, $N_MUT_GEBISSEN gefangen."
echo "  NICHT mutiert, weil nachweislich UNBEOBACHTBAR (s. Kopf dieser Datei):"
echo "    - der Nenner-Mismatch-Zweig ('Nenner nicht vertrauenswuerdig'): git"
echo "      C-quotet Zeilenenden in Dateinamen, beide Zaehler koennen nicht"
echo "      auseinanderlaufen. Ein Mutant davon bliebe an ALLEN Eingaengen gruen."
echo "    - der grep-Zweig: /usr/bin/grep ist fest verdrahtet, ohne root nicht"
echo "      entfernbar."
echo "============================================================================="
if [ "$N_MUT_GEBISSEN" -ne "$N_MUT" ]; then
    echo "SELBSTBISS ROT: $((N_MUT - N_MUT_GEBISSEN)) von $N_MUT Mutanten ueberleben." >&2
    exit 1
fi
echo "SELBSTBISS GRUEN: alle $N_MUT Mutanten gefangen -- die Probe beisst."
exit 0
