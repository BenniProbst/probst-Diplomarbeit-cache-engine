#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  PROBE fuer den PERSIST-SAMMLER   (ci/persist_sammler.sh)
#  -- der Beweis wird AM GIT-ZUSTAND gefuehrt, nicht am Log.       (2026-08-08)
# =============================================================================
#
# DER BEFUND, GEGEN DEN SIE GEBAUT IST (D3-3):
# Der Job persist:measurements entschied ueber das VORHANDENSEIN von Dateien,
# nicht ueber deren INHALT. Er zaehlte in `n_csv` kopierte Dateien, setzte
# daraus `persisted`, und uebergab an `git add -- measurement/` + `git commit`.
# Eine measurements.csv mit ausschliesslich der Kopfzeile lief da glatt durch;
# schlimmer noch, PROVENANCE.txt wird IMMER geschrieben, also war der Commit
# selbst dann faellig, wenn ueberhaupt keine CSV vorlag. Das leere Messfenster
# wurde damit additiv nach development zurueckgeschrieben und lag unter
# "Messdaten werden nie geloescht" fuer immer im Baum -- dieselbe Fehlerklasse
# wie D3 (leeres Messfenster als Erfolg), eine Stufe weiter in der Kette.
#
# WARUM DER BEWEIS AM GIT-ZUSTAND GEFUEHRT WIRD UND NICHT AM LOG:
# Ein Log sagt, was ein Skript BEHAUPTET getan zu haben. Der Defekt dieses Tages
# ist durchgaengig, dass Behauptung und Wirkung auseinanderfallen. Die Probe
# fragt deshalb git selbst: `git ls-files`, `git rev-list --count`,
# `git diff --name-only`, `git show <commit>:<pfad>`. Ein Skript, das "kein
# Commit" DRUCKT und trotzdem committet, faellt hier; an einer Log-Probe nicht.
#
# WARUM EIN SANDBOX-KLON MIT file://-REMOTE UND NIEMALS origin:
# Der Sammler ruft `git add` und `git commit`. Eine Probe, die das im Arbeitsbaum
# des Projekts taete, wuerde den Bestand veraendern -- ein Test, der sein
# Messobjekt anfasst, ist kein Test. Es wird deshalb je Lauf ein bare-Repo unter
# mktemp -d angelegt und per `git clone file://...` geklont; gearbeitet wird
# ausschliesslich im Klon. Gepusht wird NIE, auch nicht auf den file://-Remote:
# der Netz-Push-Retry-Pfad ist ausdruecklich UNGEDECKT (siehe TESTKRITIK).
#
# WARUM DIE ECHTE .gitignore IN DEN KLON KOPIERT WIRD:
# `*.csv` ist im super-Repo global ignoriert und nur ueber die Negation
# `!measurement/**/*.csv` wieder trackbar. Diese eine Zeile entscheidet, ob
# `git add -- measurement/` die Mess-CSVs aufnimmt oder still fallenlaesst.
# Eine Probe mit erfundener .gitignore wuerde die wichtigste Bedingung des
# Rueckschriebs nicht pruefen. Der Klon bekommt deshalb die ECHTE Datei.
#
# ORAKEL (T-5) UND KOEDER (K13): Anzahl der Datenzeilen und der Inhalts-Token
# werden je Lauf frisch aus /dev/urandom gezogen, nie aus einer Doku
# abgeschrieben. Die Soll-Zahl stammt damit aus einer Quelle, die der Pruefling
# nicht kennt; die Zahlen im Protokoll wechseln bei jedem Lauf (Absicht).
#
# AUFRUF:
#   sh ci/tests/persist_sammler_probe.sh              # nur die Faelle
#   sh ci/tests/persist_sammler_probe.sh --selbstbiss # Faelle + Mutationsbeweis
#
# ENV:
#   COMDARE_SAMMLER   Pfad zum Pruefling (Default: ../persist_sammler.sh).
#                     Der --selbstbiss-Zweig setzt ihn auf die Mutanten.
#
# EXIT: 0 = alle Faelle gehalten
#       1 = mindestens ein Fall gerissen (Zahlen + literale Ausgabe im Protokoll)
#       2 = die Probe konnte nicht pruefen (Pruefling fehlt, Sandbox scheiterte,
#           Koeder biss nicht) -- ausdruecklich KEIN Gruen.
#
# TESTKRITIK (T-9), was diese Probe NICHT deckt -- ausdruecklich benannt:
#   - DER NETZ-PUSH-RETRY-PFAD IST UNGEDECKT. Die Schleife `for attempt in 1..5`
#     mit `git push -o ci.skip`, non-ff-Erkennung, `git merge --no-edit` und
#     `git merge --abort` braucht einen echten origin, der sich WAEHREND des
#     Laufs bewegt. Das ist ohne echten Remote nicht probefaehig, und ein
#     nachgebauter file://-Remote wuerde eine Deckung vortaeuschen, die es nicht
#     gibt. Der Pfad bleibt bis auf Weiteres nur durch Lesen gedeckt.
#   - Die Credential-Behandlung (`git remote set-url` mit Token) bleibt im
#     YAML und wird hier nicht beruehrt -- absichtlich: eine Probe, die
#     Token-URLs baut, ist ein Leak-Risiko ohne Erkenntnisgewinn.
#   - Die prebackup()-Kollisionslogik (gleicher Name, abweichender sha256 ->
#     Overwrite VERBOTEN) ist nur indirekt beruehrt.
#   - Ob measure_out ueberhaupt befuellt wird, entscheidet der Messlauf; das
#     deckt die Mess-Ausbeute-Wache eine Stufe frueher.
#   - Die Probe prueft die Zaehlweise auf *.csv. Ob der Mess-Treiber die
#     richtigen Spalten schreibt, ist Gegenstand anderer Wachen.
#
# POSIX-sh (die CI ruft `sh`, das ist hier dash), ASCII-only, kein Python.
# Der Pruefling selbst ist bash (Prozess-Substitution im gehobenen Rumpf) und
# wird deshalb ausdruecklich mit `bash` gestartet.
# =============================================================================

set -eu

SELBST_DIR=$(cd "$(dirname "$0")" && pwd)
REPO=$(cd "$SELBST_DIR/../.." && pwd)
SAMMLER="${COMDARE_SAMMLER:-$REPO/ci/persist_sammler.sh}"
CI_YML="$REPO/.gitlab-ci.yml"
IGNORE_QUELLE="$REPO/.gitignore"

MODUS="${1:-}"
case "$MODUS" in
    ''|--selbstbiss) : ;;
    *) echo "AUFRUF: sh ci/tests/persist_sammler_probe.sh [--selbstbiss]" >&2; exit 2 ;;
esac

if [ ! -f "$SAMMLER" ]; then
    echo "ABBRUCH: Pruefling '$SAMMLER' nicht gefunden -- die Probe konnte nicht pruefen." >&2
    exit 2
fi
if [ ! -f "$IGNORE_QUELLE" ]; then
    echo "ABBRUCH: '$IGNORE_QUELLE' fehlt -- ohne die echte .gitignore prueft die Probe nicht," >&2
    echo '         ob "git add" die Mess-CSVs ueberhaupt aufnimmt. Kein Gruen ohne Pruefung.' >&2
    exit 2
fi

WERK=$(mktemp -d) || exit 2
trap 'rm -rf "$WERK"' EXIT INT TERM
OUT="$WERK/_stdout"; ERR="$WERK/_stderr"

N_FALL=0; N_OK=0; N_ROT=0
RC=0

# --- Wuerfel (K13): der Koeder wird erzeugt, nie abgeschrieben ----------------
# od statt `tr < /dev/urandom | head -c`: kein SIGPIPE, kein rc-Ratespiel.
token() { od -An -tx1 -N8 /dev/urandom | tr -d ' \n'; }
wuerfel() {           # Zahl aus [$1..$2]
    _lo="$1"; _hi="$2"; _spanne=$((_hi - _lo + 1))
    _roh=$(od -An -tu1 -N1 /dev/urandom | tr -d ' \n')
    echo $(( _lo + (_roh % _spanne) ))
}

KOPF='permutation,strategie,median_ns,cache_misses_l1,pmc_available'

# --- Sandbox: bare-Repo + file://-Klon, je Fall frisch -----------------------
# Der Klon bekommt EINEN Ausgangs-Commit, damit `git rev-list --count HEAD`
# einen Nenner hat, gegen den ein neuer Commit gezaehlt werden kann.
sandbox() {           # $1 = Fallname (Verzeichnisteil) ; setzt KLON, BASIS_N
    _s="$WERK/$1"
    mkdir -p "$_s"
    git init --bare --quiet "$_s/fern.git"
    git clone --quiet "file://$_s/fern.git" "$_s/klon" 2>/dev/null
    KLON="$_s/klon"
    git -C "$KLON" config user.name  "probe-bot"
    git -C "$KLON" config user.email "probe-bot@test.local"
    git -C "$KLON" config commit.gpgsign false
    cp -- "$IGNORE_QUELLE" "$KLON/.gitignore"
    git -C "$KLON" add -- .gitignore
    git -C "$KLON" commit --quiet -m "Ausgangs-Commit der Sandbox"
    BASIS_N=$(git -C "$KLON" rev-list --count HEAD)
}

nur_kopf() {          # $1 = Zieldatei (relativ zum Klon)
    mkdir -p "$(dirname "$KLON/$1")"
    printf '%s\n' "$KOPF" > "$KLON/$1"
}
mit_daten() {         # $1 = Zieldatei (relativ), $2 = Anzahl Datenzeilen, $3 = Token
    mkdir -p "$(dirname "$KLON/$1")"
    printf '%s\n' "$KOPF" > "$KLON/$1"
    _i=1
    while [ "$_i" -le "$2" ]; do
        printf 'perm-%s,koeder_%s,%s,%s,1\n' "$_i" "$3" "$((1000 + _i))" "$((4000 + _i))" >> "$KLON/$1"
        _i=$((_i + 1))
    done
}

# --- Laeufe ohne Pipe: rc=$? nach einer Pipe misst das LETZTE Glied ----------
sammle() {            # $1 = RUN_TS
    : > "$OUT"; : > "$ERR"
    set +e
    ( cd "$KLON" && CI_PIPELINE_ID="$PIPE_ID" CI_PIPELINE_URL="https://test.invalid/$PIPE_ID" \
        CI_COMMIT_REF_NAME="development" bash "$SAMMLER" sammeln "$1" ) > "$OUT" 2> "$ERR"
    RC=$?
    set -e
}
gate() {              # $1 = RUN_TS
    : > "$OUT"; : > "$ERR"
    set +e
    ( cd "$KLON" && CI_PIPELINE_ID="$PIPE_ID" CI_PIPELINE_URL="https://test.invalid/$PIPE_ID" \
        CI_COMMIT_REF_NAME="development" bash "$SAMMLER" gate "$1" ) > "$OUT" 2> "$ERR"
    RC=$?
    set -e
}

protokoll() {
    echo "        ----- literale Ausgabe des Sammlers (stdout) -----"
    sed 's/^/        | /' "$OUT"
    echo "        ----- literale Ausgabe des Sammlers (stderr) -----"
    sed 's/^/        | /' "$ERR"
    echo "        ----- git status --porcelain measurement/ (Klon) -----"
    if [ -n "${KLON:-}" ] && [ -d "$KLON" ]; then
        git -C "$KLON" status --porcelain -- measurement/ | sed 's/^/        | /'
    fi
    echo "        -------------------------------------------------"
}

# --- Forderungen -------------------------------------------------------------
FALL_OK=1
FALL_NAME=''
FALL_LAUF=0
fall() { N_FALL=$((N_FALL + 1)); FALL_OK=1; FALL_LAUF="${2:-1}"; FALL_NAME="$1"; }
fall_ende() {
    if [ "$FALL_OK" -eq 1 ]; then
        N_OK=$((N_OK + 1)); echo "  [ OK ]  $FALL_NAME"
    else
        N_ROT=$((N_ROT + 1)); echo "  [ROT ]  $FALL_NAME"
        if [ "$FALL_LAUF" -eq 1 ]; then protokoll; fi
    fi
}
reiss() { FALL_OK=0; echo "        RISS: $1"; }

fordere_rc() {
    if [ "$RC" -ne "$1" ]; then reiss "rc=$RC, gefordert war rc=$1"; fi
}
fordere_literal() {   # $1 = Datei, $2 = literaler Text
    if grep -qF -- "$2" "$1"; then :; else
        reiss "Text fehlt in $(basename "$1"): >>$2<<"
    fi
}
fordere_zahl() {      # $1 = Beschreibung, $2 = Ist, $3 = Soll
    if [ "$2" -ne "$3" ]; then reiss "$1: ist=$2, gefordert war $3"; fi
}
fordere_leer() {      # $1 = Beschreibung, $2 = Datei mit der Ausgabe
    _n=$(awk 'END{print NR+0}' "$2")
    if [ "$_n" -ne 0 ]; then
        reiss "$1: $_n Zeile(n), gefordert war LEER -- literal:"
        sed 's/^/          > /' "$2"
    fi
}

# --- Git-Zustand als Orakel (T-5: eine ANDERE Quelle als der Pruefling) ------
g_indexzahl() { git -C "$KLON" ls-files -- measurement/ | awk 'END{print NR+0}'; }
g_commitzahl() { git -C "$KLON" rev-list --count HEAD; }
g_status_ohne_untracked() { git -C "$KLON" status --porcelain --untracked-files=no > "$1"; }
g_neue_dateien() {    # $1 = Zieldatei ; Dateien, die der letzte Commit HINZUFUEGTE
    git -C "$KLON" diff --name-only --diff-filter=A HEAD~1 HEAD > "$1"
}

echo "============================================================================="
echo "PROBE PERSIST-SAMMLER  (Beweis am Git-Zustand)"
echo "  Pruefling : $SAMMLER"
echo "  Werkbank  : $WERK"
echo "  Modus     : ${MODUS:-nur-faelle}"
echo "============================================================================="

# =============================================================================
# P1  LEERES FENSTER: eine measurements.csv mit NUR der Kopfzeile.
#     Die Datei ist da, der Messwert nicht -> KEIN Commit.
#     DER FALL, GEGEN DEN DAS PAKET GEBAUT IST.
# =============================================================================
PIPE_ID=$(wuerfel 10000 65000)
TS1="20260808-000001-p$PIPE_ID"
fall "P1  nur Kopfzeile -> KEIN Commit, Index bleibt leer"
sandbox p1
nur_kopf "Code/measure_out/perm-0001/measurements.csv"
sammle "$TS1"
fordere_rc 0
fordere_literal "$OUT" "datenzeilen_gesamt=0"
fordere_literal "$KLON/measurement/$TS1/PROVENANCE.txt" "datenzeilen_gesamt=0"
gate "$TS1"
fordere_rc 10
fordere_literal "$OUT" "KEIN COMMIT"
# --- der eigentliche Beweis: git selbst befragen -----------------------------
fordere_zahl "Dateien im INDEX unter measurement/" "$(g_indexzahl)" 0
fordere_zahl "Commits (Sandbox-Basis war $BASIS_N)" "$(g_commitzahl)" "$BASIS_N"
g_status_ohne_untracked "$WERK/p1_status"
fordere_leer "git status --porcelain -uno" "$WERK/p1_status"
fall_ende

# =============================================================================
# P2  EIN MESSWERT: Kopf + N gewuerfelte Datenzeilen mit gewuerfeltem Token.
#     -> GENAU EIN Commit, GENAU EINE neue CSV, und der Token steht im
#     COMMITTETEN BLOB (nicht bloss auf der Platte).
# =============================================================================
PIPE_ID=$(wuerfel 10000 65000)
TS2="20260808-000002-p$PIPE_ID"
N2=$(wuerfel 1 7)
K2=$(token)
fall "P2  $N2 Datenzeile(n), Token koeder_$K2 -> 1 Commit, 1 neue CSV, Token im Blob"
sandbox p2
mit_daten "Code/measure_out/perm-0001/measurements.csv" "$N2" "$K2"
sammle "$TS2"
fordere_rc 0
fordere_literal "$OUT" "csv_gesamt=1"
fordere_literal "$OUT" "csv_mit_datenzeile=1"
fordere_literal "$OUT" "datenzeilen_gesamt=$N2"
fordere_literal "$KLON/measurement/$TS2/PROVENANCE.txt" "datenzeilen_gesamt=$N2"
gate "$TS2"
fordere_rc 0
fordere_zahl "Commits (Sandbox-Basis war $BASIS_N)" "$(g_commitzahl)" "$((BASIS_N + 1))"
g_neue_dateien "$WERK/p2_neu"
N_NEU=$(awk 'END{print NR+0}' "$WERK/p2_neu")
N_NEU_CSV=$(grep -cF '.csv' "$WERK/p2_neu" || true)
# Der Commit traegt GENAU zwei neue Dateien: die eine Mess-CSV und die
# PROVENANCE.txt desselben Laufordners. Beide Zahlen werden einzeln gefordert --
# "eine neue Datei" waere hier die bequeme, aber falsche Zahl.
fordere_zahl "neue Dateien im Commit (CSV + PROVENANCE.txt)" "$N_NEU" 2
fordere_zahl "davon *.csv" "$N_NEU_CSV" 1
CSV_PFAD="measurement/$TS2/measure_out/perm-0001/measurements.csv"
if git -C "$KLON" show "HEAD:$CSV_PFAD" > "$WERK/p2_blob" 2>/dev/null; then
    fordere_literal "$WERK/p2_blob" "koeder_$K2"
    fordere_zahl "Zeilen im committeten Blob (Kopf + $N2 Daten)" \
        "$(awk 'END{print NR+0}' "$WERK/p2_blob")" "$((N2 + 1))"
else
    reiss "der committete Baum enthaelt '$CSV_PFAD' nicht"
fi
g_status_ohne_untracked "$WERK/p2_status"
fordere_leer "git status --porcelain -uno nach dem Commit" "$WERK/p2_status"
fall_ende

# =============================================================================
# P3  GEGENEINGANG (T-4): KEINE Mess-CSV, aber ein anderes Artefakt
#     (manifest_out/build_manifest.txt). Der alte Zaehler `persisted` waere
#     hier >0 und haette committet. Das Gate haengt an DATENZEILEN, nicht an
#     Artefakten -> KEIN Commit.
# =============================================================================
PIPE_ID=$(wuerfel 10000 65000)
TS3="20260808-000003-p$PIPE_ID"
K3=$(token)
fall "P3  Artefakt ohne Messwert (build_manifest.txt) -> trotzdem KEIN Commit"
sandbox p3
mkdir -p "$KLON/manifest_out"
printf 'manifest-token=%s\n' "$K3" > "$KLON/manifest_out/build_manifest.txt"
sammle "$TS3"
fordere_rc 0
fordere_literal "$OUT" "csv_gesamt=0"
fordere_literal "$OUT" "datenzeilen_gesamt=0"
# Der Nenner muss trotzdem sichtbar sein: das Artefakt WURDE eingesammelt.
fordere_literal "$OUT" "persisted_artifact_count=1"
gate "$TS3"
fordere_rc 10
fordere_zahl "Dateien im INDEX unter measurement/" "$(g_indexzahl)" 0
fordere_zahl "Commits (Sandbox-Basis war $BASIS_N)" "$(g_commitzahl)" "$BASIS_N"
fall_ende

# =============================================================================
# P4  SUMME UEBER BEIDE QUELLEN: measure_out UND measure_out_smoke.
#     Eine Zaehlung, die nur einen der beiden Baeume sieht, faellt hier.
# =============================================================================
PIPE_ID=$(wuerfel 10000 65000)
TS4="20260808-000004-p$PIPE_ID"
N4A=$(wuerfel 1 5); N4B=$(wuerfel 1 5); N4S=$((N4A + N4B))
K4=$(token)
fall "P4  golden $N4A + smoke $N4B -> datenzeilen_gesamt=$N4S, 1 Commit"
sandbox p4
mit_daten "Code/measure_out/perm-0001/measurements.csv"       "$N4A" "$K4"
mit_daten "Code/measure_out_smoke/perm-0002/measurements.csv" "$N4B" "$K4"
sammle "$TS4"
fordere_rc 0
fordere_literal "$OUT" "csv_gesamt=2"
fordere_literal "$OUT" "csv_mit_datenzeile=2"
fordere_literal "$OUT" "datenzeilen_gesamt=$N4S"
gate "$TS4"
fordere_rc 0
fordere_zahl "Commits (Sandbox-Basis war $BASIS_N)" "$(g_commitzahl)" "$((BASIS_N + 1))"
g_neue_dateien "$WERK/p4_neu"
fordere_zahl "neue Dateien im Commit (2 CSV + PROVENANCE.txt)" \
    "$(awk 'END{print NR+0}' "$WERK/p4_neu")" 3
fall_ende

# =============================================================================
# P5  TEIL-AUSBEUTE: eine leere CSV neben einer vollen. Der Lauf traegt Daten,
#     also wird committet -- aber die leere MUSS als Befund sichtbar sein
#     (csv_gesamt=2, csv_mit_datenzeile=1). Eine Erfolgsmeldung, die den
#     Ausfall verschluckt, ist derselbe Defekt eine Ebene tiefer.
# =============================================================================
PIPE_ID=$(wuerfel 10000 65000)
TS5="20260808-000005-p$PIPE_ID"
N5=$(wuerfel 1 6)
K5=$(token)
fall "P5  1 leere + 1 volle CSV ($N5 Zeilen) -> Commit, aber Ausfall sichtbar"
sandbox p5
nur_kopf  "Code/measure_out/perm-0001/measurements.csv"
mit_daten "Code/measure_out/perm-0002/measurements.csv" "$N5" "$K5"
sammle "$TS5"
fordere_rc 0
fordere_literal "$OUT" "csv_gesamt=2"
fordere_literal "$OUT" "csv_mit_datenzeile=1"
fordere_literal "$OUT" "datenzeilen_gesamt=$N5"
gate "$TS5"
fordere_rc 0
fordere_zahl "Commits (Sandbox-Basis war $BASIS_N)" "$(g_commitzahl)" "$((BASIS_N + 1))"
fall_ende

# =============================================================================
# P6  0-BYTE-CSV: eine voellig leere Datei hat 0 Zeilen und damit 0 Datenzeilen,
#     NICHT -1. Eine Zaehlung `zeilen-1` ohne Sonderfall wuerde hier eine
#     negative Zahl in die Summe tragen und ein leeres Fenster gruen faerben.
# =============================================================================
PIPE_ID=$(wuerfel 10000 65000)
TS6="20260808-000006-p$PIPE_ID"
fall "P6  0-Byte-CSV -> 0 Datenzeilen (nicht -1), KEIN Commit"
sandbox p6
mkdir -p "$KLON/Code/measure_out/perm-0001"
: > "$KLON/Code/measure_out/perm-0001/measurements.csv"
sammle "$TS6"
fordere_rc 0
fordere_literal "$OUT" "csv_gesamt=1"
fordere_literal "$OUT" "datenzeilen_gesamt=0"
gate "$TS6"
fordere_rc 10
fordere_zahl "Commits (Sandbox-Basis war $BASIS_N)" "$(g_commitzahl)" "$BASIS_N"
fall_ende

# =============================================================================
# P7  LETZTE ZEILE OHNE NEWLINE: `wc -l` meldet hier eine Zeile zu wenig, awk
#     nicht. Die Mess-Ausbeute-Wache sagt diese Zaehlweise im Kopf ausdruecklich
#     zu; der Sammler muss DIESELBE Zaehlweise haben, sonst widersprechen sich
#     zwei Gates derselben Kette.
# =============================================================================
PIPE_ID=$(wuerfel 10000 65000)
TS7="20260808-000007-p$PIPE_ID"
K7=$(token)
fall "P7  letzte Datenzeile OHNE Newline -> zaehlt trotzdem (awk statt wc)"
sandbox p7
mkdir -p "$KLON/Code/measure_out/perm-0001"
printf '%s\n' "$KOPF" > "$KLON/Code/measure_out/perm-0001/measurements.csv"
printf 'perm-1,koeder_%s,1001,4001,1' "$K7" >> "$KLON/Code/measure_out/perm-0001/measurements.csv"
sammle "$TS7"
fordere_rc 0
fordere_literal "$OUT" "datenzeilen_gesamt=1"
gate "$TS7"
fordere_rc 0
fordere_zahl "Commits (Sandbox-Basis war $BASIS_N)" "$(g_commitzahl)" "$((BASIS_N + 1))"
fall_ende

# =============================================================================
# P8  PROVENANCE IST ADDITIV: die neue Zahl kommt HINZU, die alten Felder
#     bleiben. Ein Ersatz waere ein stiller Bruch fuer jeden, der die Datei
#     heute liest.
# =============================================================================
PIPE_ID=$(wuerfel 10000 65000)
TS8="20260808-000008-p$PIPE_ID"
N8=$(wuerfel 1 4)
K8=$(token)
fall "P8  PROVENANCE.txt behaelt alle Alt-Felder und traegt die neue Zahl"
sandbox p8
mit_daten "Code/measure_out/perm-0001/measurements.csv" "$N8" "$K8"
sammle "$TS8"
fordere_rc 0
PROV="$KLON/measurement/$TS8/PROVENANCE.txt"
for feld in "run_ts=$TS8" "generated_at_utc=" "ci_pipeline_id=$PIPE_ID" \
            "ci_pipeline_url=" "super_commit_sha=" "super_commit_ref=development" \
            "persisted_artifact_count=1"; do
    fordere_literal "$PROV" "$feld"
done
fordere_literal "$PROV" "csv_gesamt=1"
fordere_literal "$PROV" "csv_mit_datenzeile=1"
fordere_literal "$PROV" "datenzeilen_gesamt=$N8"
fall_ende

# =============================================================================
# P9  ARGUMENT-DISZIPLIN: ohne Modus/RUN_TS und mit unbekanntem Modus muss der
#     Sammler rc=2 melden. Ein stiller Rueckfall auf 0 waere derselbe Defekt
#     wie der geheilte -- "konnte nicht pruefen" ist kein Gruen.
# =============================================================================
fall "P9  ohne Argumente / unbekannter Modus -> rc=2" 0
sandbox p9
: > "$OUT"; : > "$ERR"
set +e
( cd "$KLON" && bash "$SAMMLER" ) > "$OUT" 2> "$ERR"; RC=$?
set -e
fordere_rc 2
fordere_literal "$ERR" "AUFRUF:"
: > "$OUT"; : > "$ERR"
set +e
( cd "$KLON" && bash "$SAMMLER" "quatsch_$(token)" "20260808-000009-p1" ) > "$OUT" 2> "$ERR"; RC=$?
set -e
fordere_rc 2
fordere_literal "$ERR" "unbekannter Modus"
fall_ende

# =============================================================================
# P11 ZWEI LAEUFE IM SELBEN ARBEITSBAUM -- der Fall, der beim ersten Bau dieses
#     Pakets fast durchgerutscht waere und den keine Einzelfall-Sandbox zeigt.
#     persist:measurements laeuft auf einem PERSISTENTEN baremetal-Workspace
#     (tags: [baremetal], GIT_STRATEGY: fetch). Der Laufordner einer
#     ABGELEHNTEN Pipeline bleibt dort auf der Platte liegen. Staged der naechste
#     Lauf `measurement/` als GANZES, nimmt sein Commit das abgelehnte Fenster
#     mit -- das Phantom kommt eine Pipeline spaeter doch in den Baum, und das
#     Gate haette nichts verhindert, sondern nur verzoegert.
#     GEFORDERT: der Commit traegt AUSSCHLIESSLICH den Laufordner DIESES Laufs.
# =============================================================================
PIPE_ID=$(wuerfel 10000 65000)
TS11A="20260808-000011-p$PIPE_ID"      # abgelehnter Lauf (bleibt auf der Platte)
TS11B="20260808-000012-p$PIPE_ID"      # der Lauf danach, mit echtem Messwert
N11=$(wuerfel 1 5)
K11=$(token)
fall "P11 abgelehnter Laufordner der Vor-Pipeline darf NICHT mitcommittet werden"
sandbox p11
nur_kopf "Code/measure_out/perm-0001/measurements.csv"
sammle "$TS11A"; gate "$TS11A"
fordere_rc 10
fordere_zahl "Commits nach dem abgelehnten Lauf" "$(g_commitzahl)" "$BASIS_N"
if [ ! -f "$KLON/measurement/$TS11A/PROVENANCE.txt" ]; then
    reiss "Vorbedingung verfehlt: der abgelehnte Laufordner liegt gar nicht auf der Platte"
fi
mit_daten "Code/measure_out/perm-0001/measurements.csv" "$N11" "$K11"
sammle "$TS11B"
fordere_literal "$OUT" "datenzeilen_gesamt=$N11"
gate "$TS11B"
fordere_rc 0
fordere_zahl "Commits nach dem gueltigen Lauf" "$(g_commitzahl)" "$((BASIS_N + 1))"
g_neue_dateien "$WERK/p11_neu"
N11_A=$(grep -cF "measurement/$TS11A/" "$WERK/p11_neu" || true)
N11_B=$(grep -cF "measurement/$TS11B/" "$WERK/p11_neu" || true)
fordere_zahl "Dateien des ABGELEHNTEN Laufs im Commit" "$N11_A" 0
fordere_zahl "Dateien des gueltigen Laufs im Commit (CSV + PROVENANCE.txt)" "$N11_B" 2
fordere_zahl "Dateien des abgelehnten Laufs im INDEX" \
    "$(git -C "$KLON" ls-files -- "measurement/$TS11A/" | awk 'END{print NR+0}')" 0
fall_ende

# =============================================================================
# P10 ABNAHME + REGISTRIERUNG (T-7): der Job ruft den gehobenen Sammler, und
#     diese Probe hat ihren eigenen CI-Job. Eine Probe, die nur lokal existiert,
#     ist ab dem naechsten Commit unsichtbar.
#     ZUERST DER KOEDER: /usr/bin/grep ist hier ugrep, und eine Null ohne
#     beissenden Koeder kann auch Werkzeug-Versagen sein statt Abwesenheit.
# =============================================================================
fall "P10 Registrierung in .gitlab-ci.yml (mit vorgeschaltetem Koeder)" 0
KOEDER_DATEI="$WERK/koeder_p10"
N_KOEDER=$(wuerfel 2 5)
K10=$(token)
: > "$KOEDER_DATEI"
_i=1
while [ "$_i" -le "$N_KOEDER" ]; do
    printf 'zeile %s: ci/persist_sammler.sh gate marker_%s\n' "$_i" "$K10" >> "$KOEDER_DATEI"
    _i=$((_i + 1))
done
N_GEFUNDEN=$(grep -cF 'ci/persist_sammler.sh' "$KOEDER_DATEI" || true)
if [ "$N_GEFUNDEN" -ne "$N_KOEDER" ]; then
    echo "ABBRUCH: der Koeder biss nicht -- grep fand $N_GEFUNDEN von $N_KOEDER echten Vorkommen." >&2
    echo "         Ohne beissenden Koeder ist jede Zahl an .gitlab-ci.yml wertlos." >&2
    exit 2
fi
echo "        Koeder biss: $N_GEFUNDEN von $N_KOEDER Vorkommen gefunden (grep -cF)."
if [ -f "$CI_YML" ]; then
    N_AUFRUF=$(grep -cF 'ci/persist_sammler.sh' "$CI_YML" || true)
    if [ "$N_AUFRUF" -lt 2 ]; then
        reiss "der persist-Job ruft den Sammler nicht in beiden Modi: $N_AUFRUF Aufruf(e) in .gitlab-ci.yml, gefordert >= 2"
    fi
    N_PROBE=$(grep -cF 'ci/tests/persist_sammler_probe.sh' "$CI_YML" || true)
    if [ "$N_PROBE" -lt 1 ]; then
        reiss "diese Probe ist in .gitlab-ci.yml nicht registriert ($N_PROBE Treffer)"
    fi
    # Der alte, defekte Rumpf darf NICHT mehr im YAML stehen -- sonst laeuft
    # neben dem gehobenen Sammler weiter die ungeheilte Kopie.
    N_ALT=$(grep -cF 'git add -- measurement/' "$CI_YML" || true)
    if [ "$N_ALT" -ne 0 ]; then
        reiss "der alte Rumpf steht noch in .gitlab-ci.yml: $N_ALT x 'git add -- measurement/'"
    fi
else
    reiss ".gitlab-ci.yml nicht gefunden unter $CI_YML"
fi
fall_ende

echo "-----------------------------------------------------------------------------"
echo "NENNER: $N_FALL Fall/Faelle gefahren, $N_OK gehalten, $N_ROT gerissen."
echo "-----------------------------------------------------------------------------"

if [ "$N_ROT" -ne 0 ]; then
    echo "PROBE PERSIST-SAMMLER: $N_ROT von $N_FALL Faellen GERISSEN." >&2
    exit 1
fi
echo "PROBE PERSIST-SAMMLER: OK ($N_OK von $N_FALL Faellen gehalten)."

# =============================================================================
# --selbstbiss (T-1): eine Probe, die nur am gesunden Objekt gruen ist, belegt
# nichts. Es werden Wegwerf-Mutanten des Sammlers gebaut, die Probe gegen jeden
# gefahren, und es wird GEFORDERT, dass sie rot wird.
#   M1  Das Commit-Gate faellt weg  -> das leere Fenster committet wieder.
#   M2  Die Datenzeilen-Zaehlung zaehlt DATEIEN statt ZEILEN (der Originaldefekt).
#   M3  Nur measure_out wird gezaehlt, measure_out_smoke faellt weg.
# =============================================================================
if [ "$MODUS" = --selbstbiss ]; then
    echo
    echo "============================================================================="
    echo "SELBSTBISS: die Probe wird gegen Wegwerf-Mutanten des Sammlers gefahren."
    echo "============================================================================="
    MUT_DIR="$WERK/mutanten"; mkdir -p "$MUT_DIR"
    N_MUT=0; N_GEBISSEN=0

    mutant() {        # $1 = Name, $2 = Beschreibung, $3 = sed-Ausdruck
        N_MUT=$((N_MUT + 1))
        _m="$MUT_DIR/$1.sh"
        sed "$3" "$SAMMLER" > "$_m"
        if cmp -s "$SAMMLER" "$_m"; then
            echo "ABBRUCH: Mutation '$1' hat NICHTS geaendert -- der Beweis waere leer." >&2
            exit 2
        fi
        chmod +x "$_m"
        echo "  -- $1: $2"
        set +e
        COMDARE_SAMMLER="$_m" sh "$0" > "$MUT_DIR/$1.log" 2>&1
        _rc=$?
        set -e
        if [ "$_rc" -eq 0 ]; then
            echo "     [DAUERALARM-FEHLER] die Probe blieb GRUEN am Mutanten '$1'." >&2
            echo "     ----- Protokoll des Mutanten-Laufs -----" >&2
            sed 's/^/     | /' "$MUT_DIR/$1.log" >&2
            exit 1
        fi
        N_GEBISSEN=$((N_GEBISSEN + 1))
        echo "     gebissen: rc=$_rc, gerissene Faelle:"
        grep -F '[ROT ]' "$MUT_DIR/$1.log" | sed 's/^/       /' || true
    }

    mutant m1_gate_weg  "Commit-Gate entfernt" \
        '/GATE-MUTATIONSMARKE/d'
    mutant m2_datei_statt_zeile "jede CSV zaehlt als 1 -- Dateien statt Zeilen (der Originaldefekt)" \
        's/DATENZEILEN_GESAMT + daten/DATENZEILEN_GESAMT + 1/'
    mutant m3_nur_golden "measure_out_smoke faellt aus der Summe" \
        's|^ZAEHL_WURZELN=.*$|ZAEHL_WURZELN="measure_out"|'
    mutant m4_add_ganzer_baum "staged wieder measurement/ als GANZES statt nur \$DEST" \
        's|^git add -- "\$DEST"$|git add -- measurement/|'

    echo "-----------------------------------------------------------------------------"
    echo "SELBSTBISS-NENNER: $N_GEBISSEN von $N_MUT Mutanten haben die Probe rot gemacht."
    echo "-----------------------------------------------------------------------------"
    if [ "$N_GEBISSEN" -ne "$N_MUT" ]; then
        echo "FEHLER: nicht jeder Mutant wurde gefangen." >&2; exit 1
    fi
    echo "SELBSTBISS: OK ($N_GEBISSEN von $N_MUT)."
fi
exit 0
