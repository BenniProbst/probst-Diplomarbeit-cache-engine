#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  PROBE fuer die E-18-SNAP-EINBUCHUNG  (ci/anhang_snapshot_einbuchen.sh)
#  -- sie misst den COMMIT, nicht das Protokoll.               (2026-08-11)
# =============================================================================
#
# WOGEGEN SIE GEBAUT IST (Dual-Review E-18-SNAP, Blocker 1, am Objekt belegt):
#   Der Kanal legte den Compile-Schnappschuss im CI-Workspace ab und der Job
#   stagte den Pfad NICHT. Ausgabe: "Schnappschuss abgelegt". Ergebnis: nichts.
#   Das ist die V-8-Frage in Reinform -- WELCHER ZUSTAND LAESST DIE AUSGABE
#   ERSCHEINEN, OBWOHL DIE SACHE FEHLT? -- und die Antwort war: der Normalfall.
#   Ein Protokoll-Fall haette das NIE gefunden; er haette die Zeile gesehen und
#   gruen gemeldet. Diese Probe fragt deshalb ausschliesslich den Commit:
#       git show HEAD:<pfad>  ->  ist der gewuerfelte Koeder im BLOB?
#   Ein Beleg auf Platte zaehlt hier nicht. Ein Beleg im Log zaehlt hier nicht.
#
# BEIDSEITIGE KOEDER (V-2, jeder frisch aus /dev/urandom je Fall):
#   Jeder Positiv-Fall verlangt den Koeder IM COMMIT. Jeder Negativ-Fall
#   verlangt denselben Koeder NICHT im Commit -- sonst waere "der Koeder ist da"
#   von "die Probe schaut gar nicht hin" nicht zu unterscheiden.
#
# DIE FAELLE:
#   S1  Vollstaendiger Beleg -> eingebucht, Koeder IM COMMIT.
#   S2  GEGENPROBE ZU S1 UND ZUGLEICH DER BLOCKER SELBST: byte-gleiche Fixture,
#       aber der ALTE Job-Weg (nur 'git update-index' auf den Gitlink, dann
#       commit) -- der Koeder ist NICHT im Commit. Das ist der reproduzierte
#       Ist-Zustand vor diesem Paket, kein erfundener Fall.
#   S3  V-8 AM SCHARFEN OBJEKT: eine .gitignore-Regel im 288-Repo schluckt den
#       Beleg. 'git add' bleibt still erfolgreich -> ohne das Index-Orakel waere
#       der Job GRUEN OHNE BELEG. Erwartet: rc=1, Nenner, KEIN Commit.
#   S4  GEGENPROBE ZU S3: dieselbe Fixture ohne die Ignorier-Regel -> gruen.
#       Ohne S4 waere S3 von "die Wache ist immer rot" nicht zu unterscheiden.
#   S5  HALBER BELEG (compile-export.txt fehlt) -> rc=1, NICHTS gestagt, kein
#       Commit. Ein halber Ordner saehe im Repo vollstaendig aus.
#   S6  HALBER BELEG, zweite Achse: QUELLSTAND.txt ohne die verankerte
#       'thesis_commit_sha=<40-hex>'-Zeile -> rc=1. Zwei Achsen, weil eine
#       Wache, die nur die Anwesenheit der Datei prueft, S5 bestuende und S6
#       durchliesse.
#   S7  .tmp-HALBSTAND: wird gemeldet, ENTFERNT und NIE eingebucht; der
#       danebenliegende gueltige Beleg wird trotzdem eingebucht (kein
#       Kollateralschaden).
#   S8  NICHTS AUSSTEHEND -> 'ausstehend' druckt 0, 'stagen' ist gruen und
#       erzeugt keinen Commit. Der ehrliche Leerlauf muss ehrlich bleiben.
#   S9  ZWEITER LAUF auf demselben Stand -> ausstehend=0, der bereits
#       eingebuchte Beleg wird NICHT angefasst (Messdaten-Doktrin, additiv).
#   S10 REGISTRIERUNG: dieser Datei-Pfad wird in .gitlab-ci.yml AUFGERUFEN --
#       mit vorgeschaltetem Koeder, damit ein Zaehler, der nie zaehlt, auffliegt.
#
#   SELBSTBISS (--selbstbiss): drei Mutanten des Prueflings, die die Probe ROT
#   sehen MUSS. Ohne ihn waere unbewiesen, dass die Faelle ueberhaupt beissen.
#     N1  Vollstaendigkeits-Wache entschaerft (jeder Ordner gilt als vollstaendig)
#         -> S5 und S6 muessen reissen.
#     N2  Index-Orakel entfernt (nur 'git add', kein Nachzaehlen)
#         -> S3 muss reissen.
#     N3  'git add' faellt ganz weg (der Blocker selbst als Mutation)
#         -> S1 muss reissen.
#
# AUFRUF:
#   sh ci/tests/anhang_snapshot_einbuchen_probe.sh
#   sh ci/tests/anhang_snapshot_einbuchen_probe.sh --selbstbiss
#
# ENV:
#   COMDARE_SNAP_EINBUCHEN  Pfad zum Pruefling (Default: ../../anhang_snapshot_einbuchen.sh)
#
# EXIT: 0 = alle Faelle gehalten. 1 = mindestens einer gerissen.
#       2 = konnte nicht pruefen (Pruefling fehlt, Koeder biss nicht).
#
# POSIX-sh, ASCII-only, kein Python.
# Selbstcheck: jede Zahl unten steht MIT ihrem Nenner ("N von M"), und der
# Selbstbiss belegt, dass die Faelle beissen -- eine gruene Probe ohne
# Mutationsbeweis ist von einer Probe, die nichts prueft, nicht zu unterscheiden.
# =============================================================================

set -eu

SELBST_DIR=$(cd "$(dirname "$0")" && pwd)
REPO=$(cd "$SELBST_DIR/../.." && pwd)
PRUEFLING="${COMDARE_SNAP_EINBUCHEN:-$REPO/ci/anhang_snapshot_einbuchen.sh}"
CI_YML="$REPO/.gitlab-ci.yml"
SNAP_DIR="measurement/thesis_compiles"

[ -f "$PRUEFLING" ] || { echo "FEHLER: Pruefling fehlt: $PRUEFLING" >&2; exit 2; }

WERK=$(mktemp -d)
trap 'rm -rf "$WERK"' EXIT INT TERM
OUT="$WERK/stdout.txt"
ERR="$WERK/stderr.txt"

N_FALL=0
N_OK=0
N_ROT=0

token() { od -An -tx1 -N8 /dev/urandom | tr -d ' \n'; }

# --- Sandkasten: ein 288-artiges Repo mit measurement/ ------------------------
sandbox() {           # $1 = Fallname ; setzt REPO288, BASIS_N
    _s="$WERK/$1"
    mkdir -p "$_s"
    REPO288="$_s"
    git init --quiet "$REPO288"
    git -C "$REPO288" config user.name  "probe-bot"
    git -C "$REPO288" config user.email "probe-bot@test.local"
    git -C "$REPO288" config commit.gpgsign false
    printf 'Sandkasten-288 der Einbuchungs-Probe\n' > "$REPO288/LIESMICH.txt"
    git -C "$REPO288" add -- LIESMICH.txt
    git -C "$REPO288" commit --quiet -m "Ausgangs-Commit"
    BASIS_N=$(git -C "$REPO288" rev-list --count HEAD)
}

# --- Ein VOLLSTAENDIGER Compile-Beleg, wie ihn der Kern ablegt ----------------
# Der Koeder steht in ALLEN DREI Pflichtstuecken -- sonst koennte ein Fall
# gruen sein, weil zufaellig nur die harmloseste Datei angekommen ist.
beleg() {             # $1 = Ordnername, $2 = Koeder
    _b="$REPO288/$SNAP_DIR/$1"
    mkdir -p "$_b"
    printf '%%PDF-1.7\n%% koeder_%s\n%%%%EOF\n' "$2" > "$_b/diplomarbeit.pdf"
    printf 'latexmk-Lauf, koeder_%s\n' "$2" > "$_b/compile-export.txt"
    {
        printf 'thesis_commit_sha=%s\n' "0123456789abcdef0123456789abcdef01234567"
        printf 'super_commit_sha=%s\n' "NA"
        printf 'kanal_lauf_id=koeder_%s\n' "$2"
        printf 'pdf_datei=diplomarbeit.pdf\n'
        printf 'compile_export=compile-export.txt\n'
    } > "$_b/QUELLSTAND.txt"
}

# --- Lauf ohne Pipe: rc=$? nach einer Pipe misst das LETZTE Glied (K11) ------
einbuchen() {         # $1 = Unterkommando
    : > "$OUT"; : > "$ERR"
    set +e
    ( cd "$REPO288" && sh "$PRUEFLING" "$1" "$SNAP_DIR" ) > "$OUT" 2> "$ERR"
    RC=$?
    set -e
}

# Der Job committet nach dem Einbuchen. Genau dieser Commit ist das Orakel.
commit288() {         # $1 = Botschaft
    # Ein leerer Index ist hier ein ERWARTETER Ausgang (S5/S6/S8: es darf gar kein
    # Commit entstehen). Die Meldung von git waere dann nur Rauschen im Protokoll;
    # das Urteil faellt ohnehin die Commit-ZAHL des Falls, nicht dieser Rueckgabewert.
    git -C "$REPO288" commit --quiet -m "$1" >/dev/null 2>&1 || true
}

# --- Forderungen -------------------------------------------------------------
FALL_OK=1
FALL_NAME=''
fall() { N_FALL=$((N_FALL + 1)); FALL_OK=1; FALL_NAME="$1"; }
fall_ende() {
    if [ "$FALL_OK" -eq 1 ]; then
        N_OK=$((N_OK + 1)); echo "  [ OK ]  $FALL_NAME"
    else
        N_ROT=$((N_ROT + 1)); echo "  [ROT ]  $FALL_NAME"
        protokoll
    fi
}
protokoll() {
    echo "        ----- stdout des Pruefliings -----"
    sed 's/^/        | /' "$OUT"
    echo "        ----- stderr des Pruefliings -----"
    sed 's/^/        | /' "$ERR"
    echo "        ----- git log + Baum des Commits -----"
    git -C "$REPO288" log --oneline | sed 's/^/        | /'
    git -C "$REPO288" ls-tree -r --name-only HEAD | sed 's/^/        | /'
    echo "        ----------------------------------"
}
melde() { FALL_OK=0; echo "        MISS: $1"; }

fordere_rc() {        # $1 = Soll-rc
    [ "$RC" -eq "$1" ] || melde "rc=$RC erwartet $1"
}
fordere_literal() {   # $1 = Datei, $2 = literaler Text
    grep -qF -- "$2" "$1" || melde "fehlender literaler Text: '$2'"
}
fordere_zahl() {      # $1 = Beschreibung, $2 = Ist, $3 = Soll
    if [ "$2" -ne "$3" ]; then melde "$1: ist=$2 soll=$3"; fi
}
# DAS ORAKEL: der Koeder muss im BLOB des Commits stehen -- nicht auf Platte.
fordere_koeder_im_commit() {    # $1 = repo-relativer Pfad, $2 = Koeder
    if ! git -C "$REPO288" show "HEAD:$1" 2>/dev/null | grep -qF "koeder_$2"; then
        melde "Koeder '$2' NICHT im committeten Blob von '$1' (git show HEAD:...)"
    fi
}
fordere_koeder_NICHT_im_commit() {  # $1 = repo-relativer Pfad, $2 = Koeder
    if git -C "$REPO288" show "HEAD:$1" 2>/dev/null | grep -qF "koeder_$2"; then
        melde "Koeder '$2' IST im Commit von '$1' -- erwartet war: gerade NICHT"
    fi
}
z_commitzahl() { git -C "$REPO288" rev-list --count HEAD; }
z_baumdateien() { git -C "$REPO288" ls-tree -r --name-only HEAD -- "$SNAP_DIR" | awk 'END{print NR+0}'; }

echo "============================================================================="
echo " PROBE E-18-SNAP-EINBUCHUNG -- Pruefling: $PRUEFLING"
echo "============================================================================="

# =============================================================================
# S1 DER POSITIVFALL. Vollstaendiger Beleg -> im COMMIT.
# =============================================================================
K1=$(token)
fall "S1  vollstaendiger Beleg -> eingebucht, Koeder IM COMMIT"
sandbox s1
beleg "20260811-120000-r1-j1" "$K1"
einbuchen stagen
fordere_rc 0
fordere_literal "$OUT" "auf_platte=3 im_index=3 nicht_uebernommen=0"
commit288 "thesis(E-18): Compile-Schnappschuss"
fordere_zahl "Commits (Basis war $BASIS_N)" "$(z_commitzahl)" "$((BASIS_N + 1))"
fordere_zahl "Schnappschuss-Dateien IM BAUM des Commits" "$(z_baumdateien)" 3
fordere_koeder_im_commit "$SNAP_DIR/20260811-120000-r1-j1/QUELLSTAND.txt" "$K1"
fordere_koeder_im_commit "$SNAP_DIR/20260811-120000-r1-j1/compile-export.txt" "$K1"
fordere_koeder_im_commit "$SNAP_DIR/20260811-120000-r1-j1/diplomarbeit.pdf" "$K1"
fall_ende

# =============================================================================
# S2 DER BLOCKER SELBST, REPRODUZIERT. Byte-gleiche Fixture, ALTER Job-Weg:
#    der Job stagte nur den Gitlink und committete. Der Beleg lag auf Platte
#    und war trotzdem weg. OHNE diesen Fall waere S1 von "git commit nimmt
#    ohnehin alles" nicht zu unterscheiden -- und genau diese Verwechslung
#    hat das Paket ein Verdikt gekostet.
# =============================================================================
K2=$(token)
fall "S2  ALTER Weg (nur Gitlink gestagt) -> Koeder NICHT im Commit (Blocker 1)"
sandbox s2
beleg "20260811-120000-r1-j1" "$K2"
# kein Einbuchen -- nur eine unabhaengige Aenderung stagen, wie der Gitlink-Bump
printf 'Gitlink-Stellvertreter\n' > "$REPO288/ZEIGER.txt"
git -C "$REPO288" add -- ZEIGER.txt
commit288 "thesis(E-18): nur der Zeiger"
fordere_zahl "Commits (Basis war $BASIS_N)" "$(z_commitzahl)" "$((BASIS_N + 1))"
fordere_zahl "Schnappschuss-Dateien IM BAUM des Commits" "$(z_baumdateien)" 0
fordere_koeder_NICHT_im_commit "$SNAP_DIR/20260811-120000-r1-j1/QUELLSTAND.txt" "$K2"
if [ ! -f "$REPO288/$SNAP_DIR/20260811-120000-r1-j1/QUELLSTAND.txt" ]; then
    melde "Vorbedingung kaputt: der Beleg liegt nicht einmal auf Platte"
fi
fall_ende

# =============================================================================
# S3 V-8 AM SCHARFEN OBJEKT. .gitignore im 288-Repo schluckt den Beleg.
#    'git add' bleibt still erfolgreich. NUR das Index-Orakel sieht es.
# =============================================================================
K3=$(token)
fall "S3  288-.gitignore schluckt den Beleg -> ROT mit Nenner, kein stilles Gruen"
sandbox s3
printf 'measurement/**/*.pdf\n' > "$REPO288/.gitignore"
git -C "$REPO288" add -- .gitignore
git -C "$REPO288" commit --quiet -m "288 ignoriert PDFs unter measurement/"
BASIS_N=$(git -C "$REPO288" rev-list --count HEAD)
beleg "20260811-120000-r1-j1" "$K3"
einbuchen stagen
fordere_rc 1
fordere_literal "$OUT" "auf_platte=3 im_index=2 nicht_uebernommen=1"
fordere_literal "$ERR" "NICHT im Index"
fordere_literal "$ERR" "diplomarbeit.pdf"
commit288 "thesis(E-18): darf gar nicht erst entstehen"
fordere_koeder_NICHT_im_commit "$SNAP_DIR/20260811-120000-r1-j1/diplomarbeit.pdf" "$K3"
fall_ende

# =============================================================================
# S4 GEGENPROBE ZU S3 (PFLICHT, T-4). Dieselbe Fixture OHNE die Ignorier-Regel.
# =============================================================================
K4=$(token)
fall "S4  GEGENPROBE: dieselbe Fixture ohne Ignorier-Regel -> gruen, Koeder im Commit"
sandbox s4
beleg "20260811-120000-r1-j1" "$K4"
einbuchen stagen
fordere_rc 0
fordere_literal "$OUT" "auf_platte=3 im_index=3 nicht_uebernommen=0"
commit288 "thesis(E-18): Compile-Schnappschuss"
fordere_koeder_im_commit "$SNAP_DIR/20260811-120000-r1-j1/diplomarbeit.pdf" "$K4"
fall_ende

# =============================================================================
# S5 HALBER BELEG, ACHSE 1: compile-export.txt fehlt.
# =============================================================================
K5=$(token)
fall "S5  halber Beleg (compile-export.txt fehlt) -> ROT, NICHTS gestagt"
sandbox s5
beleg "20260811-120000-r1-j1" "$K5"
rm -f "$REPO288/$SNAP_DIR/20260811-120000-r1-j1/compile-export.txt"
einbuchen stagen
fordere_rc 1
fordere_literal "$ERR" "unvollstaendiger Compile-Schnappschuss"
fordere_literal "$ERR" "compile-export.txt"
commit288 "thesis(E-18): darf gar nicht erst entstehen"
fordere_zahl "Commits (Basis war $BASIS_N)" "$(z_commitzahl)" "$BASIS_N"
fordere_zahl "Schnappschuss-Dateien IM BAUM" "$(z_baumdateien)" 0
fall_ende

# =============================================================================
# S6 HALBER BELEG, ACHSE 2: QUELLSTAND ohne verankerte thesis_commit_sha.
#    Zwei Achsen, weil eine reine Anwesenheits-Wache S5 bestuende und S6 nicht.
# =============================================================================
K6=$(token)
fall "S6  QUELLSTAND ohne 'thesis_commit_sha=<40-hex>' -> ROT (zweite Achse)"
sandbox s6
beleg "20260811-120000-r1-j1" "$K6"
printf 'thesis_commit_sha=zzz\nkanal_lauf_id=koeder_%s\n' "$K6" \
    > "$REPO288/$SNAP_DIR/20260811-120000-r1-j1/QUELLSTAND.txt"
einbuchen stagen
fordere_rc 1
fordere_literal "$ERR" "thesis_commit_sha=<40-hex>"
commit288 "thesis(E-18): darf gar nicht erst entstehen"
fordere_zahl "Schnappschuss-Dateien IM BAUM" "$(z_baumdateien)" 0
fall_ende

# =============================================================================
# S7 .tmp-HALBSTAND: entfernt, nie eingebucht -- und der gueltige Nachbar
#    kommt trotzdem durch (kein Kollateralschaden, Z3+Z4 zusammen).
# =============================================================================
K7=$(token)
K7T=$(token)
fall "S7  .tmp-Halbstand entfernt + nie gestagt, gueltiger Nachbar kommt durch"
sandbox s7
beleg "20260811-120000-r1-j1" "$K7"
mkdir -p "$REPO288/$SNAP_DIR/.20260811-120001-r1-j2.tmp"
printf 'halb, koeder_%s\n' "$K7T" > "$REPO288/$SNAP_DIR/.20260811-120001-r1-j2.tmp/compile-export.txt"
einbuchen stagen
fordere_rc 0
fordere_literal "$ERR" "abgebrochener Schnappschuss-Halbstand"
if [ -d "$REPO288/$SNAP_DIR/.20260811-120001-r1-j2.tmp" ]; then
    melde ".tmp-Halbstand liegt noch auf Platte"
fi
commit288 "thesis(E-18): Compile-Schnappschuss"
fordere_zahl "Schnappschuss-Dateien IM BAUM" "$(z_baumdateien)" 3
fordere_koeder_im_commit "$SNAP_DIR/20260811-120000-r1-j1/QUELLSTAND.txt" "$K7"
if git -C "$REPO288" ls-tree -r --name-only HEAD | grep -q '\.tmp'; then
    melde "ein .tmp-Pfad ist im Baum des Commits gelandet"
fi
fall_ende

# =============================================================================
# S8 EHRLICHER LEERLAUF. Kein Beleg -> ausstehend=0, stagen gruen, kein Commit.
# =============================================================================
fall "S8  nichts ausstehend -> ausstehend=0, stagen gruen, KEIN Commit"
sandbox s8
einbuchen ausstehend
fordere_rc 0
if [ "$(cat "$OUT")" != "0" ]; then melde "ausstehend druckte '$(cat "$OUT")' statt '0'"; fi
fordere_literal "$ERR" "Einbuch-Nenner"
einbuchen stagen
fordere_rc 0
commit288 "thesis(E-18): darf gar nicht erst entstehen"
fordere_zahl "Commits (Basis war $BASIS_N)" "$(z_commitzahl)" "$BASIS_N"
fall_ende

# =============================================================================
# S9 ADDITIV: zweiter Lauf auf demselben Stand fasst den Bestand NICHT an.
# =============================================================================
K9=$(token)
fall "S9  zweiter Lauf: ausstehend=0, Bestand unangetastet, KEIN zweiter Commit"
sandbox s9
beleg "20260811-120000-r1-j1" "$K9"
einbuchen stagen
fordere_rc 0
commit288 "thesis(E-18): Compile-Schnappschuss"
N_NACH_1=$(z_commitzahl)
einbuchen ausstehend
if [ "$(cat "$OUT")" != "0" ]; then melde "zweiter Lauf: ausstehend='$(cat "$OUT")' statt '0'"; fi
einbuchen stagen
fordere_rc 0
commit288 "thesis(E-18): darf gar nicht erst entstehen"
fordere_zahl "Commits nach Lauf 2" "$(z_commitzahl)" "$N_NACH_1"
fordere_koeder_im_commit "$SNAP_DIR/20260811-120000-r1-j1/QUELLSTAND.txt" "$K9"
fall_ende

# =============================================================================
# S10 REGISTRIERUNG mit vorgeschaltetem Koeder (T-7).
#     Der Koeder belegt, dass der Zaehler ueberhaupt zaehlt -- sonst waere eine
#     Null von "es gibt nichts zu finden" nicht zu unterscheiden.
# =============================================================================
fall "S10 Registrierung in .gitlab-ci.yml (mit vorgeschaltetem Koeder)"
if [ ! -f "$CI_YML" ]; then
    melde ".gitlab-ci.yml nicht gefunden: $CI_YML"
else
    KOEDER_YML="$WERK/koeder.yml"
    {
        cat "$CI_YML"
        printf '    - sh ci/tests/anhang_snapshot_einbuchen_probe.sh # koeder\n'
    } > "$KOEDER_YML"
    K_TREFFER=$(grep -cF 'sh ci/tests/anhang_snapshot_einbuchen_probe.sh' "$KOEDER_YML")
    ECHT=$(grep -cF 'sh ci/tests/anhang_snapshot_einbuchen_probe.sh' "$CI_YML" || true)
    echo "        Koeder-Gegenprobe: $K_TREFFER Treffer mit Koeder, $ECHT ohne (grep -cF)."
    if [ "$K_TREFFER" -ne $((ECHT + 1)) ]; then
        echo "FEHLER: der Koeder biss nicht -- der Zaehler zaehlt nicht, was er soll" >&2
        exit 2
    fi
    if [ "$ECHT" -lt 1 ]; then
        melde "diese Probe wird in .gitlab-ci.yml NICHT aufgerufen (0 Aufrufstellen)"
    fi
    # Und der Pruefling selbst muss im Job anhang:forward gerufen werden --
    # sonst ist die Einbuchung gebaut und trotzdem wirkungslos (Blocker 1).
    P_ECHT=$(grep -cF 'ci/anhang_snapshot_einbuchen.sh stagen' "$CI_YML" || true)
    echo "        Aufrufstellen 'ci/anhang_snapshot_einbuchen.sh stagen': $P_ECHT."
    if [ "$P_ECHT" -lt 1 ]; then
        melde "der Pruefling wird in .gitlab-ci.yml nie mit 'stagen' gerufen -> wirkungslos"
    fi
fi
fall_ende

# =============================================================================
#  SELBSTBISS
# =============================================================================
if [ "${1:-}" = "--selbstbiss" ]; then
    echo "-----------------------------------------------------------------------------"
    echo " SELBSTBISS: drei Mutanten, die die Probe ROT sehen MUSS"
    echo "-----------------------------------------------------------------------------"
    N_MUT=0
    N_MUT_OK=0
    mutant() {        # $1 = Name, $2 = sed-Ausdruck, $3 = Faelle, die reissen muessen
        N_MUT=$((N_MUT + 1))
        _m="$WERK/mutant_$N_MUT.sh"
        sed "$2" "$PRUEFLING" > "$_m"
        chmod +x "$_m"
        if cmp -s "$_m" "$PRUEFLING"; then
            echo "  [FEHL] $1 -- die Mutation hat NICHTS geaendert (Muster passt nicht mehr)"
            return 0
        fi
        set +e
        COMDARE_SNAP_EINBUCHEN="$_m" sh "$0" > "$WERK/mut_$N_MUT.log" 2>&1
        _rc=$?
        set -e
        if [ "$_rc" -ne 0 ]; then
            N_MUT_OK=$((N_MUT_OK + 1))
            echo "  [ OK ]  $1 -> Probe rot (rc=$_rc), erwartet reissend: $3"
        else
            echo "  [FEHL] $1 -> Probe blieb GRUEN. Der Mutant ueberlebt."
        fi
    }
    M1='s/^        n_unvollstaendig=\$((n_unvollstaendig + 1))$/'
    M1="$M1"'        n_unvollstaendig=$((n_unvollstaendig + 0))/'
    M2='s/^            nicht_uebernommen=\$((nicht_uebernommen + 1))$/'
    M2="$M2"'            nicht_uebernommen=$((nicht_uebernommen + 0))/'
    M3='s|^    "\$GIT" add -- "\$SNAP_DIR" .*$|    : ueberspringe das Stagen|'
    mutant "N1 Vollstaendigkeits-Wache entschaerft" "$M1" "S5 S6"
    mutant "N2 Index-Orakel entfernt"               "$M2" "S3"
    mutant "N3 git add faellt weg (der Blocker)"    "$M3" "S1 S4 S7 S9"
    echo "-----------------------------------------------------------------------------"
    echo "SELBSTBISS-NENNER: $N_MUT_OK von $N_MUT Mutanten wurden ROT gesehen."
    if [ "$N_MUT_OK" -ne "$N_MUT" ]; then
        echo "FEHLER: mindestens ein Mutant ueberlebt -> die Probe deckt ihn nicht." >&2
        exit 2
    fi
fi

echo "-----------------------------------------------------------------------------"
echo "NENNER: $N_FALL Fall/Faelle gefahren, $N_OK gehalten, $N_ROT gerissen"
echo "-----------------------------------------------------------------------------"
if [ "$N_ROT" -gt 0 ]; then
    echo "PROBE E-18-SNAP-EINBUCHUNG: $N_ROT von $N_FALL Faellen GERISSEN."
    exit 1
fi
echo "PROBE E-18-SNAP-EINBUCHUNG: $N_FALL von $N_FALL Faellen gehalten."
exit 0
