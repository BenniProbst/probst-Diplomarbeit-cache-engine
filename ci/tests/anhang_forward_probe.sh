#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  PROBE fuer den ANHANG-VORWAERTS-KERN  (ci/anhang_forward_core.sh)
#  -- der Beweis wird AM ZIEL-REPO gefuehrt, nicht am Log.          (2026-08-09)
# =============================================================================
#
# WOGEGEN SIE GEBAUT IST -- ZWEI FALLEN HINTEREINANDER, beide still:
#
#   FALLE 1, der Selektor (Fassung vor diesem Paket, :149 :153 :165):
#     Gesucht wurde '-name "*.result.csv"'. Der lebende Messweg schreibt aber
#     'result.csv' OHNE Praefix -- ce
#     libs/cache_engine/profile_facade/planner/planner_status_types.hpp:33
#     'inline constexpr char kResultCsvName[] = "result.csv"'. Der Glob
#     '*.result.csv' verlangt mindestens EIN Zeichen plus Punkt davor und trifft
#     die reale Datei damit NIE. Selbst nachgemessen: ein Verzeichnis mit
#     result.csv UND perm_007.result.csv, dann 'find -name "*.result.csv"'
#     liefert ausschliesslich perm_007.result.csv.
#
#   FALLE 2, die Leerheitspruefung (:166/:167):
#     Geprueft wurde mit 'wc -l'. wc zaehlt ZEILENUMBRUECHE, nicht Zeilen. Eine
#     CSV aus Kopfzeile + EINER Datenzeile OHNE abschliessenden Newline liefert
#     wc -l = 1 und galt damit als leer. Das ist exakt der Mini-Messwert des
#     Durchstichs -- die Falle war auf den Anwendungsfall zugeschnitten, den sie
#     zerstoert.
#
#   FALLE 3, die beim Bau dieser Probe dazukam (Konkatenation, :162-165):
#     Das WIDE-Aggregat entstand aus 'head -1' + 'tail -n +2 >>'. Fehlt der
#     Quelldatei der Schluss-Newline, klebt die naechste Datenzeile an die
#     vorherige. Zwei Messwerte wurden so zu einem einzigen, kaputten. Fall A3
#     haelt das fest.
#
#   FALLE 4, DER HEADER-DIEB (Nachsatz zu P4, :277 der Fassung davor):
#     Der Header wurde von der ERSTEN Datei genommen, die der Schleife
#     unterkam -- ohne zu pruefen, ob die ueberhaupt eine erste Zeile HAT.
#     Eine 0-Byte-result.csv, die im `sort` vor der vollen liegt, lieferte
#     also nichts und setzte trotzdem '_hdr=1'. Die volle Datei danach kam nur
#     noch durch 'tail -n +2' -- ihre Kopfzeile wurde uebersprungen, obwohl
#     nie eine geschrieben worden war. Das WIDE-Aggregat war KOPFLOS.
#     Zwei Auspraegungen, beide still:
#       (a) Nachbardatei mit EINER Datenzeile: WIDE hat 1 Zeile, die
#           Leerheitspruefung '-le 1' haelt das fuer leer -> honest-empty,
#           rc=0, KEIN Commit. Der Messwert ist weg.
#       (b) Nachbardatei mit ZWEI Datenzeilen: WIDE hat 2 kopflose Zeilen,
#           der Commit LANDET -- und jeder NR>1-Konsument (auch der echte
#           appendix-generator) frisst die erste Datenzeile als Kopfzeile.
#           Das ist der teurere Fall: ein gruener Commit, der einen Messwert
#           verschluckt hat.
#     0-Byte-CSVs sind in diesem Projekt kein erfundenes Szenario -- die
#     Sammler-Probe fuehrt sie als eigenen Fall (ci/tests/persist_sammler_probe.sh,
#     Fall P6 "0-Byte-CSV -> 0 Datenzeilen (nicht -1)").
#     Faelle A8 (Auspraegung a) und A9 (Auspraegung b) halten das fest.
#
# ALLE VIER HABEN DIESELBE EIGENSCHAFT: sie verwerfen einen Messwert STILL,
# mit rc=0 und einer Ausgabe, die wie ein ehrliches "nichts zu tun" aussieht
# (Falle 4b sogar mit einem gruenen Commit).
#
# WARUM DER BEWEIS AM ZIEL-REPO GEFUEHRT WIRD:
# Ein Log sagt, was der Kanal BEHAUPTET getan zu haben. Gefragt wird deshalb git
# selbst: 'git rev-list --count HEAD' und 'git show HEAD:<pfad>'. Und geprueft
# wird der WERT: der gewuerfelte Koeder muss im COMMITTETEN BLOB der .tex stehen.
# Damit ist die ganze Strecke belegt -- result.csv -> WIDE -> Generator -> .tex
# -> Commit -- und nicht bloss, dass irgendeine Datei entstanden ist.
#
# WARUM EIN WEGWERF-GENERATOR:
# Der echte appendix-generator ist eine C++-Binary aus dem ce-Bau; ihn hier zu
# bauen hiesse, den Bau zu testen statt den Transport. Der Stub SPIEGELT das
# Aggregat: er schreibt die Zahl der Datenzeilen und jeden Wert der zweiten
# Spalte woertlich in die .tex. Faellt eine Datenzeile unterwegs weg oder
# verkleben zwei, sieht man es in der .tex.
#
# AUFRUF:
#   sh ci/tests/anhang_forward_probe.sh              # nur die Faelle
#   sh ci/tests/anhang_forward_probe.sh --selbstbiss # Faelle + Mutationsbeweis
#
# ENV:
#   COMDARE_ANHANG_KERN  Pfad zum Pruefling (Default: ../anhang_forward_core.sh).
#                        Der --selbstbiss-Zweig setzt ihn auf die Mutanten.
#
# EXIT: 0 = alle Faelle gehalten
#       1 = mindestens ein Fall gerissen (Zahlen + literale Ausgabe im Protokoll)
#       2 = die Probe konnte nicht pruefen (Pruefling fehlt, Sandbox scheiterte,
#           Koeder biss nicht) -- ausdruecklich KEIN Gruen.
#
# TESTKRITIK (T-9), was diese Probe NICHT deckt -- ausdruecklich benannt:
#   - DAS PDF-GATE IST UNGEDECKT. Alle Faelle fahren mit AF_PDF_GATE=off. Ein
#     echter latexmk-Lauf ueber das Thesis-Repo waere kein Fixture mehr, sondern
#     der 289-Bau; und ein nachgebautes Mini-.tex wuerde eine Deckung
#     vortaeuschen, die der echte Anhang nicht hat.
#   - DER PUSH-/MERGE-RETRY-PFAD IST UNGEDECKT (AF_NO_PUSH=true). Er braucht
#     einen origin, der sich WAEHREND des Laufs bewegt.
#   - Der Artefakt-Zweig (1a, AF_ARTIFACT_ROOTS) wird nur insoweit beruehrt, als
#     er in allen Faellen leer laufen MUSS, damit der Korpus-Zweig ueberhaupt
#     drankommt. Seine Reihenfolge-Semantik ist hier nicht Gegenstand.
#   - Der Rollback-Pfad (PDF-Gate rot -> COPIED_LIST zurueckdrehen) haengt am
#     abgeschalteten Gate und ist damit ebenfalls ungedeckt.
#   - Ob der ECHTE appendix-generator aus einer gueltigen WIDE-Matrix richtige
#     Tabellen macht, ist Gegenstand anderer Wachen. Hier zaehlt der TRANSPORT.
#   - A8/A9 STELLEN die Reihenfolge her, sie messen sie nicht. Die Faelle legen
#     die 0-Byte-Datei bewusst so ab, dass sie im `sort` vorne steht
#     (perm0_leer vor perm1_voll), und pruefen das vorher mit demselben `sort`
#     ab. Was sie NICHT zeigen: dass eine 0-Byte-Datei im echten Korpus
#     tatsaechlich vor der vollen einsortiert -- das haengt an den realen
#     Permutationsnamen. Bewiesen ist: WENN sie vorne liegt, ueberlebt der
#     Messwert. Der umgekehrte Fall (volle Datei zuerst) war nie defekt.
#   - DIE ZWILLINGE IN DER .gitlab-ci.yml SIND UNGEDECKT. Dieselbe Header-Logik
#     steht dort ein zweites und drittes Mal (Jobs measure:smoke und measure,
#     :1160 und :1265) -- dort sogar ohne 'awk 1'. Diese Probe fasst nur den
#     Kern an; die Datei gehoert in diesem Paket einem anderen Strang. Solange
#     die Zwillinge leben, gilt die Heilung NUR fuer den Anhang-Kanal.
#
# POSIX-sh (die CI ruft `sh`, das ist hier dash), ASCII-only, kein Python.
# Der Pruefling selbst ist bash (Prozess-Substitution) und wird deshalb
# ausdruecklich mit `bash` gestartet.
# =============================================================================

set -eu

SELBST_DIR=$(cd "$(dirname "$0")" && pwd)
REPO=$(cd "$SELBST_DIR/../.." && pwd)
KERN="${COMDARE_ANHANG_KERN:-$REPO/ci/anhang_forward_core.sh}"
CI_YML="$REPO/.gitlab-ci.yml"

MODUS="${1:-}"
case "$MODUS" in
    ''|--selbstbiss) : ;;
    *) echo "AUFRUF: sh ci/tests/anhang_forward_probe.sh [--selbstbiss]" >&2; exit 2 ;;
esac

if [ ! -f "$KERN" ]; then
    echo "ABBRUCH: Pruefling '$KERN' nicht gefunden -- die Probe konnte nicht pruefen." >&2
    exit 2
fi

WERK=$(mktemp -d) || exit 2
trap 'rm -rf "$WERK"' EXIT INT TERM
OUT="$WERK/_stdout"; ERR="$WERK/_stderr"

N_FALL=0; N_OK=0; N_ROT=0
# N_ROT_FACHLICH zaehlt die roten Faelle OHNE A7 (Registrierung). Der Grund ist
# kein Nachlass, sondern das Gegenteil: A7 ist rot, solange der CI-Job-Block
# fehlt, und wuerde jeden Mutanten-Lauf ohnehin rot faerben. Ein Selbstbiss, der
# sich darauf stuetzt, waere ein SCHEINBISS -- er belegte nur, dass die
# Verdrahtung fehlt, nicht dass die Faelle beissen. Der Selbstbiss fordert
# deshalb je Mutant mindestens einen roten Fall, der NICHT A7 ist. Der
# Gesamt-Exit bleibt trotzdem 1, solange A7 rot ist (T-7).
N_ROT_FACHLICH=0
RC=0

# --- Wuerfel (K13): der Koeder wird erzeugt, nie abgeschrieben ----------------
# od statt `tr < /dev/urandom | head -c`: kein SIGPIPE, kein rc-Ratespiel.
token() { od -An -tx1 -N8 /dev/urandom | tr -d ' \n'; }

KOPF='permutation,wert,median_ns,cache_misses_l1,pmc_available'

# --- Wegwerf-Generator: SPIEGEL des WIDE-Aggregats ---------------------------
GEN="$WERK/probe_generator.sh"
cat > "$GEN" <<'GENERATOR'
#!/bin/sh
# Wegwerf-Generator der Probe. argv wie beim echten appendix-generator:
#   $1 = WIDE-Aggregat (CSV), $2 = Ausgabewurzel, $3 = --langs=de,en
# Er erzeugt je Sprache GENAU EINE .tex, die (a) die Zahl der Datenzeilen nennt
# und (b) jeden Wert der zweiten Spalte woertlich ausgibt. Damit ist die .tex
# ein Spiegel des Aggregats: faellt eine Datenzeile weg oder verkleben zwei,
# steht das in der Datei.
set -eu
WIDE="$1"; OUT="$2"
LANGS=$(printf '%s' "${3#--langs=}" | tr ',' ' ')
N=$(awk 'END{if (NR > 0) print NR - 1; else print 0}' "$WIDE")
for L in $LANGS; do
    mkdir -p "$OUT/$L/tabellen"
    {
        printf '%% probe-generator lang=%s\n' "$L"
        printf '%% datenzeilen=%s\n' "$N"
        awk -F, 'NR > 1 { print "% wert=" $2 }' "$WIDE"
    } > "$OUT/$L/tabellen/A_messwerte.tex"
done
GENERATOR
chmod +x "$GEN"

# --- Sandbox: Arbeitswurzel (Korpus) + Ziel-Repo (bare + file://-Klon) -------
# Gepusht wird NIE, auch nicht auf den file://-Remote (AF_NO_PUSH=true).
sandbox() {           # $1 = Fallname ; setzt ARBEIT, ZIEL, BASIS_N
    _s="$WERK/$1"
    mkdir -p "$_s/arbeit"
    ARBEIT="$_s/arbeit"
    git init --bare --quiet "$_s/fern.git"
    git clone --quiet "file://$_s/fern.git" "$_s/ziel" 2>/dev/null
    ZIEL="$_s/ziel"
    git -C "$ZIEL" config user.name  "probe-bot"
    git -C "$ZIEL" config user.email "probe-bot@test.local"
    git -C "$ZIEL" config commit.gpgsign false
    printf 'Sandbox-Ziel der anhang-forward-Probe\n' > "$ZIEL/LIESMICH.txt"
    git -C "$ZIEL" add -- LIESMICH.txt
    git -C "$ZIEL" commit --quiet -m "Ausgangs-Commit der Sandbox"
    BASIS_N=$(git -C "$ZIEL" rev-list --count HEAD)
}

# --- Fixtures im PRODUKTIONS-LAYOUT ------------------------------------------
# <korpus>/<RUN_TS>/measure_out/<perm>/result.csv  -- so legt der persist-Sammler
# den Laufordner an, und so schreibt ce die Datei (kResultCsvName).
# OHNE Schluss-Newline, weil genau das der Fall des Mini-Messwerts ist.
csv_ohne_newline() {  # $1 = Zielpfad (absolut), $2 = Token
    mkdir -p "$(dirname "$1")"
    printf '%s\n' "$KOPF" > "$1"
    printf 'perm-0,koeder_%s,1234,5678,1' "$2" >> "$1"
}
csv_nur_kopf() {      # $1 = Zielpfad (absolut)
    mkdir -p "$(dirname "$1")"
    printf '%s\n' "$KOPF" > "$1"
}
# 0 Byte: keine Kopfzeile, keine Datenzeile, kein Newline. Das ist die Datei,
# die ein abgebrochener oder nie beschriebener Pruefling hinterlaesst; die
# Sammler-Probe fuehrt denselben Fall als P6.
csv_null_byte() {     # $1 = Zielpfad (absolut)
    mkdir -p "$(dirname "$1")"
    : > "$1"
}
# Kopfzeile + ZWEI Datenzeilen, die letzte ohne Schluss-Newline (so schreibt ce).
csv_zwei_ohne_newline() {   # $1 = Zielpfad, $2 = Token A, $3 = Token B
    mkdir -p "$(dirname "$1")"
    printf '%s\n' "$KOPF" > "$1"
    printf 'perm-1,koeder_%s,1234,5678,1\n' "$2" >> "$1"
    printf 'perm-2,koeder_%s,4321,8765,1' "$3" >> "$1"
}

# --- Lauf ohne Pipe: rc=$? nach einer Pipe misst das LETZTE Glied ------------
kanal() {             # $1 = AF_CORPUS_ROOT (relativ zu ARBEIT)
    : > "$OUT"; : > "$ERR"
    set +e
    AF_DEST_REPO="$ZIEL" \
    AF_WORK_ROOT="$ARBEIT" \
    AF_CORPUS_ROOT="$1" \
    AF_ARTIFACT_ROOTS="artefaktwurzel_gibt_es_in_dieser_probe_nicht" \
    AF_GENERATOR="$GEN" \
    AF_NO_PUSH=true \
    AF_PDF_GATE=off \
    AF_TMP="$WERK/tmp_$N_FALL" \
    bash "$KERN" > "$OUT" 2> "$ERR"
    RC=$?
    set -e
}

protokoll() {
    echo "        ----- literale Ausgabe des Kerns (stdout) -----"
    sed 's/^/        | /' "$OUT"
    echo "        ----- literale Ausgabe des Kerns (stderr) -----"
    sed 's/^/        | /' "$ERR"
    echo "        ----- git log --oneline (Ziel-Repo) -----"
    if [ -n "${ZIEL:-}" ] && [ -d "$ZIEL" ]; then
        git -C "$ZIEL" log --oneline | sed 's/^/        | /'
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
        case "$FALL_NAME" in
            A7*) : ;;
            *)   N_ROT_FACHLICH=$((N_ROT_FACHLICH + 1)) ;;
        esac
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
# VORBEDINGUNG der Faelle A8/A9, nicht deren Behauptung: die 0-Byte-Datei MUSS
# der vollen im `sort` des Kerns VORAUSGEHEN, sonst prueft der Fall gar nichts
# (kaeme die volle Datei zuerst, gaebe es den Header-Dieb ueberhaupt nicht).
# Geprueft wird mit demselben `sort` wie im Pruefling -- gleiche Binary, gleiche
# Locale. Ein Verstoss ist KEIN roter Fall, sondern Abbruch mit 2: die Probe
# konnte dann nicht pruefen, und ein Gruen waere hier eine Luege.
fordere_sortiert_zuerst() {   # $1 = MUSS vorne stehen, $2 = der andere
    _erst=$(printf '%s\n%s\n' "$2" "$1" | sort | head -1)
    if [ "$_erst" != "$1" ]; then
        echo "ABBRUCH: Fixture-Reihenfolge falsch -- '$2' sortiert vor '$1'." >&2
        echo "         Der Fall pruefte dann nicht den Header-Dieb." >&2
        exit 2
    fi
    echo "        Vorbedingung: '$(basename "$(dirname "$1")")' sortiert vor '$(basename "$(dirname "$2")")' (sort)."
}

# --- Ziel-Repo als Orakel (T-5: eine ANDERE Quelle als der Pruefling) --------
z_commitzahl() { git -C "$ZIEL" rev-list --count HEAD; }
z_blob() {            # $1 = Pfad im Ziel-Repo, $2 = Zieldatei ; rc 0 = vorhanden
    git -C "$ZIEL" show "HEAD:$1" > "$2" 2>/dev/null
}
# Prueft die committete .tex EINER Sprache gegen Soll-Zeilenzahl und Koeder.
fordere_tex() {       # $1 = lang, $2 = soll_datenzeilen, $3.. = Koeder-Token
    _l="$1"; _soll="$2"; shift 2
    _p="anhang/$_l/tabellen/A_messwerte.tex"
    if z_blob "$_p" "$WERK/_tex_$_l"; then
        fordere_literal "$WERK/_tex_$_l" "datenzeilen=$_soll"
        _n=$(grep -cF '% wert=' "$WERK/_tex_$_l" || true)
        fordere_zahl "[$_l] Wert-Zeilen in der committeten .tex" "$_n" "$_soll"
        for _k in "$@"; do
            fordere_literal "$WERK/_tex_$_l" "% wert=koeder_$_k"
        done
    else
        reiss "der committete Baum enthaelt '$_p' nicht"
    fi
}

echo "============================================================================="
echo "PROBE ANHANG-VORWAERTS-KERN  (Beweis am Ziel-Repo)"
echo "  Pruefling : $KERN"
echo "  Werkbank  : $WERK"
echo "  Modus     : ${MODUS:-nur-faelle}"
echo "============================================================================="

# =============================================================================
# A1  DER DURCHSTICH-FALL. Produktions-Layout, Datei heisst 'result.csv' (so
#     schreibt ce sie), GENAU EINE Datenzeile, OHNE Schluss-Newline.
#     Beide Fallen zugleich: der alte Glob findet die Datei nicht, und selbst
#     wenn er sie faende, verwuerfe 'wc -l' die eine Datenzeile als leer.
#     GEFORDERT: der gewuerfelte Wert steht am Ende im COMMITTETEN .tex-Blob.
# =============================================================================
K1=$(token)
TS1="20260812-070000-durchstich"
fall "A1  result.csv, 1 Datenzeile ohne Newline -> Wert landet im Commit"
sandbox a1
csv_ohne_newline "$ARBEIT/korpus/$TS1/measure_out/perm0/result.csv" "$K1"
kanal korpus
fordere_rc 0
fordere_literal "$OUT" "laufordner_geprueft=1 mit_material=1"
fordere_literal "$OUT" "WIDE-Aggregat: 2 Zeilen"
fordere_literal "$OUT" "kopiert gesamt: 2 .tex"
fordere_zahl "Commits im Ziel-Repo (Basis war $BASIS_N)" "$(z_commitzahl)" "$((BASIS_N + 1))"
fordere_tex de 1 "$K1"
fordere_tex en 1 "$K1"
fall_ende

# =============================================================================
# A2  ARCHIVFORM '<stem>.result.csv'. Sie existiert real: 8 Dateien unter
#     docs/architektur/measurement/.../per_binary/. Ob sie ein geplanter
#     Umbenenn-Schritt oder ein Archiv-Artefakt ist, ist Owner-Frage OV-17
#     (Ledger:112). Bis zur Antwort akzeptiert der Kanal BEIDE Formen -- das ist
#     die einzige Richtung, die keinen Messwert verwerfen kann.
# =============================================================================
K2=$(token)
TS2="20260812-070001-archivform"
fall "A2  Archivform <stem>.result.csv wird ebenfalls gefunden (OV-17 offen)"
sandbox a2
csv_ohne_newline "$ARBEIT/korpus/$TS2/measure_out/per_binary/perm_$K2.result.csv" "$K2"
kanal korpus
fordere_rc 0
fordere_literal "$OUT" "laufordner_geprueft=1 mit_material=1"
fordere_zahl "Commits im Ziel-Repo (Basis war $BASIS_N)" "$(z_commitzahl)" "$((BASIS_N + 1))"
fordere_tex de 1 "$K2"
fall_ende

# =============================================================================
# A3  ZWEI DATEIEN, BEIDE OHNE SCHLUSS-NEWLINE -- die dritte Falle.
#     Das WIDE-Aggregat entsteht aus 'head -1' + 'tail -n +2 >>'. Fehlt der
#     Schluss-Newline, klebt die naechste Datenzeile an die vorherige: aus zwei
#     Messwerten wird EINE kaputte Zeile, und der Verlust ist still.
#     GEFORDERT: 2 getrennte Wert-Zeilen in der committeten .tex, beide Koeder
#     einzeln auffindbar. Eine Zeile 'koeder_Akoeder_B' faellt hier.
# =============================================================================
K3A=$(token); K3B=$(token)
TS3="20260812-070002-zweizeilen"
fall "A3  2 Dateien ohne Schluss-Newline -> 2 GETRENNTE Datenzeilen"
sandbox a3
csv_ohne_newline "$ARBEIT/korpus/$TS3/measure_out/perm0/result.csv" "$K3A"
csv_ohne_newline "$ARBEIT/korpus/$TS3/measure_out/perm1/result.csv" "$K3B"
kanal korpus
fordere_rc 0
fordere_literal "$OUT" "WIDE-Aggregat: 3 Zeilen"
fordere_zahl "Commits im Ziel-Repo (Basis war $BASIS_N)" "$(z_commitzahl)" "$((BASIS_N + 1))"
fordere_tex de 2 "$K3A" "$K3B"
fall_ende

# =============================================================================
# A4  NO-OP MIT NENNER. Der Korpus EXISTIERT und traegt Laufordner, aber keiner
#     traegt Material. Eine nackte Null ist hier von einem echten Freispruch
#     nicht zu unterscheiden -- deshalb MUSS der Kanal sagen, wieviele Ordner er
#     ueberhaupt angesehen hat.
# =============================================================================
TS4=$(token)
fall "A4  Korpus da, kein Material -> laufordner_geprueft=3 mit_material=0"
sandbox a4
for i in 1 2 3; do
    mkdir -p "$ARBEIT/korpus/20260812-07000$i-leer-$TS4"
    printf 'kein Messwert hier\n' > "$ARBEIT/korpus/20260812-07000$i-leer-$TS4/notiz.txt"
done
kanal korpus
fordere_rc 0
fordere_literal "$OUT" "laufordner_geprueft=3 mit_material=0"
fordere_literal "$OUT" "anhang:forward NO-OP"
fordere_zahl "Commits im Ziel-Repo (Basis war $BASIS_N)" "$(z_commitzahl)" "$BASIS_N"
fall_ende

# =============================================================================
# A5  KORPUS-WURZEL EXISTIERT GAR NICHT. Das ist kein erfundener Fall: der
#     Default AF_CORPUS_ROOT=measurement zeigt am Repo-Root ins Leere (der
#     getrackte Korpus liegt unter docs/architektur/measurement/), und der
#     CI-Job setzt denselben Wert. Ob das zur Laufzeit gefuellt wird, entscheidet
#     ein anderer Job -- der Kanal darf darueber nicht SCHWEIGEN.
#     GEFORDERT: vorhanden=nein plus Nenner, rc=0, kein Commit.
# =============================================================================
K5=$(token)
fall "A5  Korpus-Wurzel fehlt -> vorhanden=nein + Nenner, kein stilles Nichts"
sandbox a5
kanal "gibt_es_nicht_$K5"
fordere_rc 0
fordere_literal "$OUT" "vorhanden=nein"
fordere_literal "$OUT" "laufordner_geprueft=0 mit_material=0"
fordere_zahl "Commits im Ziel-Repo (Basis war $BASIS_N)" "$(z_commitzahl)" "$BASIS_N"
fall_ende

# =============================================================================
# A6  GEGENEINGANG (T-4): eine ECHTE Leere. Die result.csv traegt NUR die
#     Kopfzeile. Der geheilte Kanal muss sie weiterhin verwerfen -- eine Wache,
#     die nach der Heilung alles durchlaesst, ist keine Wache mehr.
# =============================================================================
TS6="20260812-070003-nurkopf"
fall "A6  result.csv nur mit Kopfzeile -> honest-empty, KEIN Commit"
sandbox a6
csv_nur_kopf "$ARBEIT/korpus/$TS6/measure_out/perm0/result.csv"
kanal korpus
fordere_rc 0
fordere_literal "$OUT" "laufordner_geprueft=1 mit_material=1"
fordere_literal "$OUT" "WIDE-Aggregat: 1 Zeilen"
fordere_literal "$OUT" "keine Datenzeile"
fordere_zahl "Commits im Ziel-Repo (Basis war $BASIS_N)" "$(z_commitzahl)" "$BASIS_N"
fall_ende

# =============================================================================
# A8  DER HEADER-DIEB, Auspraegung (a): eine 0-BYTE-result.csv liegt im `sort`
#     VOR der vollen Datei. Sie hat keine erste Zeile -- der Kern nahm von ihr
#     trotzdem "den Header" und merkte sich, er habe einen. Die volle Datei
#     danach kam nur noch durch 'tail -n +2': ihre Kopfzeile wurde als Header
#     uebersprungen, obwohl nie einer geschrieben wurde. Uebrig blieb EINE
#     kopflose Zeile -- die Leerheitspruefung hielt sie fuer den Header und
#     verwarf sie als "keine Datenzeile".
#     GEFORDERT: der gewuerfelte Wert steht im COMMITTETEN .tex-Blob. Die
#     Zeilenzahl 2 (Header + 1 Datenzeile) ist die Gegenprobe dazu: sie zeigt,
#     dass der Header diesmal von der RICHTIGEN Datei kam.
#     A7 (Registrierung) schliesst die Fallliste bewusst ab und bleibt letzter
#     Fall -- die fachlichen Faelle stehen deshalb alle davor.
# =============================================================================
K8=$(token)
TS8="20260812-070004-nullbyte"
fall "A8  0-Byte-result.csv VOR voller Datei -> Wert landet trotzdem im Commit"
sandbox a8
A8_LEER="$ARBEIT/korpus/$TS8/measure_out/perm0_leer/result.csv"
A8_VOLL="$ARBEIT/korpus/$TS8/measure_out/perm1_voll/result.csv"
fordere_sortiert_zuerst "$A8_LEER" "$A8_VOLL"
csv_null_byte "$A8_LEER"
csv_ohne_newline "$A8_VOLL" "$K8"
kanal korpus
fordere_rc 0
fordere_literal "$OUT" "laufordner_geprueft=1 mit_material=1"
fordere_literal "$OUT" "WIDE-Aggregat: 2 Zeilen"
fordere_zahl "Commits im Ziel-Repo (Basis war $BASIS_N)" "$(z_commitzahl)" "$((BASIS_N + 1))"
fordere_tex de 1 "$K8"
fordere_tex en 1 "$K8"
fall_ende

# =============================================================================
# A9  DER HEADER-DIEB, Auspraegung (b) -- die TEURERE. Die Nachbardatei traegt
#     ZWEI Datenzeilen. Das kopflose WIDE hat dann 2 Zeilen, gilt damit als
#     nicht leer, und der Commit LANDET. Nur frisst jeder NR>1-Konsument -- der
#     Wegwerf-Generator hier genau wie der echte appendix-generator -- die erste
#     Datenzeile als Kopfzeile. Ergebnis: ein gruener Commit mit EINEM statt
#     ZWEI Messwerten, ohne eine einzige Fehlerzeile.
#     GEFORDERT: BEIDE Koeder einzeln im committeten Blob, datenzeilen=2.
# =============================================================================
K9A=$(token); K9B=$(token)
TS9="20260812-070005-nullbyte-zweizeilig"
fall "A9  0-Byte vor Datei mit 2 Datenzeilen -> BEIDE Werte, kein Kopf-Frass"
sandbox a9
A9_LEER="$ARBEIT/korpus/$TS9/measure_out/perm0_leer/result.csv"
A9_VOLL="$ARBEIT/korpus/$TS9/measure_out/perm1_voll/result.csv"
fordere_sortiert_zuerst "$A9_LEER" "$A9_VOLL"
csv_null_byte "$A9_LEER"
csv_zwei_ohne_newline "$A9_VOLL" "$K9A" "$K9B"
kanal korpus
fordere_rc 0
fordere_literal "$OUT" "WIDE-Aggregat: 3 Zeilen"
fordere_zahl "Commits im Ziel-Repo (Basis war $BASIS_N)" "$(z_commitzahl)" "$((BASIS_N + 1))"
fordere_tex de 2 "$K9A" "$K9B"
fall_ende

# =============================================================================
# A10 GEGENEINGANG ZUR HEILUNG (T-4): NUR 0-Byte-Dateien, kein einziger Messwert.
#     Eine Wache, die nach der Reparatur alles durchlaesst, ist keine Wache mehr:
#     hier MUSS honest-empty bleiben, was honest-empty ist.
#     Zugleich ist das der einzige Fall, der den Ausgabe-Zweig 'header=nein'
#     betritt. Vor der Heilung stand hier "0 Zeilen (inkl. 1 Header)" -- eine
#     Zahl mit falschem Nenner ueber einer Datei, die keinen Header hatte.
#     Der Fall beisst auch den Header-Dieb: ohne die '-s'-Wache gilt der Header
#     als "genommen", obwohl nichts geschrieben wurde, und die Rechnung
#     Zeilen-minus-Header liefert MINUS EINS -- sichtbar an 'header=ja'.
# =============================================================================
TS10="20260812-070006-alles-nullbyte"
fall "A10 nur 0-Byte-Dateien -> header=nein, honest-empty, KEIN Commit"
sandbox a10
csv_null_byte "$ARBEIT/korpus/$TS10/measure_out/perm0_leer/result.csv"
csv_null_byte "$ARBEIT/korpus/$TS10/measure_out/perm1_leer/result.csv"
kanal korpus
fordere_rc 0
fordere_literal "$OUT" "laufordner_geprueft=1 mit_material=1"
fordere_literal "$OUT" "WIDE-Aggregat: 0 Zeilen (header=nein, davon Datenzeilen=0)"
fordere_literal "$OUT" "keine Datenzeile"
fordere_zahl "Commits im Ziel-Repo (Basis war $BASIS_N)" "$(z_commitzahl)" "$BASIS_N"
fall_ende

# =============================================================================
# A7  REGISTRIERUNG (T-7). Ein Test, der in keinem CI-Job faehrt, ist NICHT
#     gebaut. In diesem Projekt wurde bereits eine Wache gebaut, die nirgends
#     aufgerufen wurde -- deshalb ist das hier ein HARTER Fall und keine
#     Warnung. Er wird von selbst gruen, sobald der Job-Block in .gitlab-ci.yml
#     steht; bis dahin ist er der lauteste Hinweis, dass die Deckung fehlt.
#     ZUERST DER KOEDER: /usr/bin/grep ist hier ugrep, und eine Null ohne
#     beissenden Koeder kann auch Werkzeug-Versagen sein statt Abwesenheit.
# =============================================================================
fall "A7  Registrierung in .gitlab-ci.yml (mit vorgeschaltetem Koeder)" 0
KOEDER_DATEI="$WERK/koeder_a7"
K7=$(token)
N_KOEDER=3
: > "$KOEDER_DATEI"
_i=1
while [ "$_i" -le "$N_KOEDER" ]; do
    printf 'zeile %s: sh ci/tests/anhang_forward_probe.sh marker_%s\n' "$_i" "$K7" >> "$KOEDER_DATEI"
    _i=$((_i + 1))
done
N_GEFUNDEN=$(grep -cF 'ci/tests/anhang_forward_probe.sh' "$KOEDER_DATEI" || true)
if [ "$N_GEFUNDEN" -ne "$N_KOEDER" ]; then
    echo "ABBRUCH: der Koeder biss nicht -- grep fand $N_GEFUNDEN von $N_KOEDER echten Vorkommen." >&2
    echo "         Ohne beissenden Koeder ist jede Zahl an .gitlab-ci.yml wertlos." >&2
    exit 2
fi
echo "        Koeder biss: $N_GEFUNDEN von $N_KOEDER Vorkommen gefunden (grep -cF)."
if [ -f "$CI_YML" ]; then
    N_PROBE=$(grep -cF 'ci/tests/anhang_forward_probe.sh' "$CI_YML" || true)
    if [ "$N_PROBE" -lt 1 ]; then
        reiss "diese Probe ist in .gitlab-ci.yml nicht registriert ($N_PROBE Treffer) --"
        echo "        der Job-Block liegt kopierfertig im Paketbericht (fuer_folgepaket)."
        echo "        Bis zur Verdrahtung ist das Halten des Kanals UNGEDECKT."
    fi
    N_KERN=$(grep -cF 'ci/anhang_forward_core.sh' "$CI_YML" || true)
    if [ "$N_KERN" -lt 1 ]; then
        reiss "der Job anhang:forward ruft den Kern nicht ($N_KERN Treffer)"
    fi
else
    reiss ".gitlab-ci.yml nicht gefunden unter $CI_YML"
fi
fall_ende

echo "-----------------------------------------------------------------------------"
echo "NENNER: $N_FALL Fall/Faelle gefahren, $N_OK gehalten, $N_ROT gerissen"
echo "        (davon fachlich, also ohne die Registrierung A7: $N_ROT_FACHLICH)."
echo "-----------------------------------------------------------------------------"

ROT_EXIT=0
if [ "$N_ROT" -ne 0 ]; then
    echo "PROBE ANHANG-VORWAERTS-KERN: $N_ROT von $N_FALL Faellen GERISSEN." >&2
    ROT_EXIT=1
else
    echo "PROBE ANHANG-VORWAERTS-KERN: OK ($N_OK von $N_FALL Faellen gehalten)."
fi

# =============================================================================
# --selbstbiss (T-1): eine Probe, die nur am gesunden Objekt gruen ist, belegt
# nichts. Es werden Wegwerf-Mutanten des Kerns gebaut, die Probe gegen jeden
# gefahren, und es wird GEFORDERT, dass sie rot wird.
#   N1  Der Selektor faellt auf '*.result.csv' zurueck (Falle 1).
#   N2  Die Aggregation faellt auf den Stand VOR P4 zurueck: 'wc -l' UND kein
#       'awk 1' (Falle 2 + Falle 3 zusammen).
#   N3  Nur die Konkatenation verliert ihr 'awk 1' (Falle 3 allein).
#   N4  Die Nenner-Zeile faellt weg -- die Null steht wieder ohne Nenner da.
#   N5  Die Wache '[ -s "$rcsv" ]' faellt weg -- eine 0-Byte-Datei darf den
#       Header wieder "stellen" (Falle 4, der Header-Dieb).
#   N6  Die Leerheitspruefung laesst alles durch -- der Gegeneingang (A6/A10)
#       muss das fangen, sonst waere die Heilung ein Scheunentor.
#
# JEDER MUTANT FUEHRT SEINE ZAHL MIT: erwartet wird eine exakte Anzahl
# geaenderter Quellzeilen. Ohne sie bliebe ein Mutant unauffaellig, dessen
# sed-Ausdruck nach einer Bewegung im Kern gar nicht mehr greift -- Begruendung
# ausfuehrlich an der Funktion 'mutant' weiter unten.
#
# WARUM N2 BEIDE ZEILEN ZUGLEICH ZURUECKDREHT -- ein Befund, kein Bequemlichkeit:
#   Ein Mutant, der NUR die Zaehlweise auf 'wc -l' zurueckdreht, macht KEINEN
#   einzigen fachlichen Fall rot. Selbst nachgemessen am Objekt: 6 von 6
#   fachlichen Faellen blieben gruen. Der Grund ist die Heilung von Falle 3 --
#   'awk 1' gibt jeden Datensatz mit ORS aus, das WIDE-Aggregat endet dadurch
#   IMMER auf einen Newline, und dann liefern 'wc -l' und 'awk NR' zwangslaeufig
#   dieselbe Zahl.
#   FOLGE, ausdruecklich benannt: die awk-Zaehlung ist an DIESER Stelle heute
#   REDUNDANTE Deckung, nicht die tragende. Tragend fuer den Ein-Zeilen-Fall ist
#   das 'awk 1' der Konkatenation. Die awk-Zaehlung bleibt trotzdem: sie ist die
#   Zusage "wortgleich zu Wache und Sammler", und sie faengt den Fall ab, falls
#   jemand das 'awk 1' spaeter wieder entfernt. Zwei Deckungen desselben Falls
#   sind kein Fehler -- sie unbenannt zu lassen waere einer.
# =============================================================================
if [ "$MODUS" = --selbstbiss ] && [ "$N_ROT_FACHLICH" -ne 0 ]; then
    echo "SELBSTBISS UEBERSPRUNGEN: $N_ROT_FACHLICH fachliche(r) Fall/Faelle sind schon am" >&2
    echo "gesunden Objekt rot. Ein Mutationsbeweis waere darauf wertlos." >&2
    exit 1
fi
if [ "$MODUS" = --selbstbiss ]; then
    echo
    echo "============================================================================="
    echo "SELBSTBISS: die Probe wird gegen Wegwerf-Mutanten des Kerns gefahren."
    echo "============================================================================="
    MUT_DIR="$WERK/mutanten"; mkdir -p "$MUT_DIR"
    N_MUT=0; N_GEBISSEN=0

    mutant() {        # $1 = Name, $2 = Beschreibung, $3 = sed-Ausdruck,
                      # $4 = erwartete Zahl geaenderter QUELLZEILEN
        N_MUT=$((N_MUT + 1))
        _m="$MUT_DIR/$1.sh"
        sed "$3" "$KERN" > "$_m"
        if cmp -s "$KERN" "$_m"; then
            echo "ABBRUCH: Mutation '$1' hat NICHTS geaendert -- der Beweis waere leer." >&2
            exit 2
        fi
        # WARUM DIE ZAHL MITGEFUEHRT WIRD -- am eigenen Bau erlebt (09.08.2026):
        # 'cmp -s' sagt nur, dass IRGENDETWAS anders ist. Ein Mutant aus MEHREREN
        # sed-Ausdruecken bleibt damit unauffaellig, wenn nur EINER davon noch
        # greift. Genau das passierte N2, als seine Ziel-Zeile im Kern von '>' auf
        # '>>' wechselte: zwei Ausdruecke trafen, der dritte lief ins Leere, und der
        # Mutant sah weiter "gebissen" aus -- obwohl er ein Drittel weniger
        # zurueckdrehte, als er behauptete. Ein still nicht mehr greifender
        # sed-Ausdruck ist dieselbe Fehlerklasse wie ein still verworfener Messwert:
        # rc=0 und eine Ausgabe, die nach Deckung aussieht. Deshalb hier die exakte
        # Zahl statt eines "irgendwas hat sich geaendert".
        # Gezaehlt wird die ORIGINAL-Seite des diff ('<'-Zeilen); rc des diff ist
        # egal, weil die Pipe ohnehin den awk-Status liefert (K11).
        _geaendert=$(diff "$KERN" "$_m" | awk '/^</{n++} END{print n+0}')
        if [ "$_geaendert" -ne "$4" ]; then
            echo "ABBRUCH: Mutation '$1' hat $_geaendert Quellzeile(n) geaendert, erwartet waren $4." >&2
            echo "         Entweder greift ein sed-Ausdruck nicht mehr, oder der Kern hat sich" >&2
            echo "         bewegt. Beides macht den Mutationsbeweis wertlos -- kein Gruen darauf." >&2
            exit 2
        fi
        chmod +x "$_m"
        echo "  -- $1: $2"
        echo "     zurueckgedreht: $_geaendert Quellzeile(n) (erwartet: $4)."
        set +e
        COMDARE_ANHANG_KERN="$_m" sh "$0" > "$MUT_DIR/$1.log" 2>&1
        _rc=$?
        set -e
        if [ "$_rc" -eq 0 ]; then
            echo "     [DAUERALARM-FEHLER] die Probe blieb GRUEN am Mutanten '$1'." >&2
            echo "     ----- Protokoll des Mutanten-Laufs -----" >&2
            sed 's/^/     | /' "$MUT_DIR/$1.log" >&2
            exit 1
        fi
        # rc != 0 REICHT HIER NICHT. Solange A7 (Registrierung) rot ist, ist JEDER
        # Lauf rot -- ein Biss waere dann nur die fehlende Verdrahtung, nicht der
        # Mutant. Gefordert wird deshalb mindestens ein roter Fall, der nicht A7 ist.
        _rot_fachlich=$(awk '/\[ROT \]/ && $0 !~ /\[ROT \][ ]+A7/ {n++} END{print n+0}' "$MUT_DIR/$1.log")
        if [ "$_rot_fachlich" -lt 1 ]; then
            echo "     [SCHEINBISS] Mutant '$1' machte die Probe nur ueber A7 rot," >&2
            echo "     also ueber die fehlende Registrierung statt ueber einen Fall." >&2
            sed 's/^/     | /' "$MUT_DIR/$1.log" >&2
            exit 1
        fi
        N_GEBISSEN=$((N_GEBISSEN + 1))
        echo "     gebissen: rc=$_rc, $_rot_fachlich fachliche(r) Riss(e), gerissene Faelle:"
        grep -F '[ROT ]' "$MUT_DIR/$1.log" | sed 's/^/       /' || true
    }

    mutant n1_alter_glob "Selektor faellt auf '*.result.csv' zurueck (Falle 1)" \
        's|^AF_RESULT_NAMEN=.*$|AF_RESULT_NAMEN="*.result.csv"|' 1
    mutant n2_stand_vor_p4 "Aggregation wie VOR P4: wc -l UND kein awk 1 (Falle 2+3)" \
        's@^    WIDE_ZEILEN=.*$@    WIDE_ZEILEN=$(wc -l < "$WIDE")@; s@^      tail -n +2 "$rcsv" .*$@      tail -n +2 "$rcsv" >> "$WIDE"@; s@head -1 "$rcsv" | awk 1 >> "$WIDE"@head -1 "$rcsv" >> "$WIDE"@' 3
    mutant n3_ohne_awk1 "nur die Konkatenation verliert ihr 'awk 1' (Falle 3 allein)" \
        's|^      tail -n +2 "$rcsv" .*$|      tail -n +2 "$rcsv" >> "$WIDE"|' 1
    mutant n4_nenner_weg "die Nenner-Zeile faellt weg -- Null ohne Nenner" \
        '/laufordner_geprueft=/d' 2
    # N5 dreht GENAU die Heilung des Nachsatzes zurueck: die Wache '[ -s "$rcsv" ]'
    # faellt weg, der Header darf wieder von einer 0-Byte-Datei "genommen" werden.
    # Der Rest der Zeile ('>>' und 'awk 1') bleibt stehen -- damit steht fest, dass
    # A8/A9 an DIESER Bedingung haengen und nicht an einer der P4-Heilungen.
    mutant n5_header_dieb "die -s-Wache faellt weg -- 0-Byte-Datei stiehlt den Header (Falle 4)" \
        's@ \[ -s "$rcsv" \] &&@@' 1
    # N6 sperrt den Gegeneingang auf: die Leerheitspruefung laesst alles durch.
    # Er belegt, dass A6 und A10 die WACHE sind und nicht bloss mitlaufen -- eine
    # Heilung, die anschliessend jede Leere durchwinkt, waere keine.
    mutant n6_leerheit_offen "die Leerheitspruefung laesst alles durch (-le 0 -> -lt 0)" \
        's@\[ "$WIDE_DATEN" -le 0 \]@[ "$WIDE_DATEN" -lt 0 ]@' 1

    echo "-----------------------------------------------------------------------------"
    echo "SELBSTBISS-NENNER: $N_GEBISSEN von $N_MUT Mutanten haben die Probe rot gemacht."
    echo "-----------------------------------------------------------------------------"
    if [ "$N_GEBISSEN" -ne "$N_MUT" ]; then
        echo "FEHLER: nicht jeder Mutant wurde gefangen." >&2; exit 1
    fi
    echo "SELBSTBISS: OK ($N_GEBISSEN von $N_MUT)."
fi
exit "$ROT_EXIT"
