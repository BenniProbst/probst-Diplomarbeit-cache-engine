#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  BISSPROBE fuer die BASIS-WAHL DER DIFF-HYGIENE-WACHE                (2026-08-11)
#  (scripts/ci_diff_ascii_width_guard.sh, Modus --seit-basis)
# =============================================================================
#
# WARUM ES SIE GIBT -- DIE LUECKE, DIE SIE SCHLIESST:
# Zum Fix "COMDARE_GUARD_BASIS_REF steht literal" gehoeren drei Teile:
#   (a) das Literal in der .gitlab-ci.yml,
#   (b) der fail-closed-Vorspann, der den Zweig holt,
#   (c) die Wache bricht ab, wenn eine GENANNTE Basis nicht aufloest.
# Fuer (a) und (b) gibt es sechs GoogleTest-Faelle (GuardBasis.*). Die LESEN
# aber nur den YAML-TEXT. Teil (c) ist VERHALTEN eines Shell-Skripts, und
# genau dieses Verhalten war ungedeckt: die Mutationsprobe vom 10.08. entfernte
# den elif-Zweig und ALLE VIER damals gefahrenen Gates blieben gruen (rc=0).
# Ein Text-Scanner mehr haette daran nichts geaendert -- er sieht kein Verhalten.
# Diese Probe RUFT die Wache und misst ihren Exit-Code.
#
# DER FEHLMODUS, GEGEN DEN SIE STEHT (am Objekt gemessen, 10.08.):
#   Vorher trug die Wache $COMDARE_GUARD_BASIS_REF nur als ERSTEN KANDIDATEN
#   einer Kette. Loeste er nicht auf, rutschte sie STILL weiter -- in diesem
#   Repo auf origin/development. Auf einer development-Pipeline ist
#   merge-base(origin/development, HEAD) = HEAD, also 0 Commit(s) im Bereich,
#   0 Zeilen geprueft, GRUEN. Die Wache sah nichts an und meldete Erfolg.
#   Gleicher Baum, gleicher Koeder, einziger Unterschied "gibt es origin/main":
#       vorhanden -> Basis origin/main,        Koeder im Bereich, rc=1 ROT
#       fehlt     -> Basis origin/development, 0 Commit(s),       rc=0 GRUEN
#   ARM B unten baut genau diese Lage nach.
#
# WAS "BISS" HEISST (TDD-Vertrag T-1):
#   --selbstbiss baut WEGWERF-MUTANTEN der Wache und fordert, dass die Probe an
#   ihnen ROT wird. M1 ist exakt die W0B-Mutation (elif-Zweig entfernt), die
#   4 von 4 Gates blind liess. Eine Probe, die am kranken Objekt gruen bleibt,
#   ist keine Probe.
#
# DIE DREI LAGEN (Hausregel, wie durchstich_bissprobe.sh):
#   rc=0  alle Arme gehalten
#   rc=1  RISS -- die Wache urteilt falsch (oder ein Mutant ueberlebt)
#   rc=2  die Probe konnte nicht pruefen (Wache fehlt, Koeder biss nicht,
#         git/awk kaputt, Mutation griff nicht). Ausdruecklich KEIN Gruen.
#
# ORAKEL (T-5), gewuerfelt statt abgeschrieben (K13):
#   * Der Nicht-ASCII-Koeder ist ein je Lauf frisch aus /dev/urandom gezogenes
#     Byte-Paar (gueltiges UTF-8 aus dem Latin-1-Supplement), eingebettet in
#     eine .sh-Datei -- also IM Scope der Wache.
#   * Der unaufloesbare Basisname ist 'origin/koeder_<hex8>' aus /dev/urandom.
#     Eine Wache, die einen festen Namen sonderbehandelt, faellt daran.
#   Die Zahlen im Protokoll wechseln deshalb je Lauf. Das ist Absicht.
#
# JEDER ARM PRUEFT DEN GEGENSTAND, NICHT NUR DEN EXIT-CODE (V-8):
#   Ein rc=2 kann auch "git fehlt im PATH" heissen. Deshalb fordert jeder Arm
#   zusaetzlich einen LITERALEN Text in der Ausgabe der Wache. Und ARM C/D
#   fordern BEREICHSBREITE >= 1: ein Gruen ueber einem leeren Bereich ist
#   dieselbe stille Null, gegen die diese Probe gebaut ist.
#
# AUFRUF:
#   sh ci/tests/guard_basis_bissprobe.sh              # nur die Arme
#   sh ci/tests/guard_basis_bissprobe.sh --selbstbiss # Arme + Mutationsbeweis
#
# ENV:
#   COMDARE_WACHE  Pfad zur zu pruefenden Wache
#                  (Default: <repo>/scripts/ci_diff_ascii_width_guard.sh).
#                  Der --selbstbiss-Zweig setzt sie auf die Mutanten; der
#                  Rot-Lauf gegen einen alten Stand setzt sie von aussen.
#
# TESTKRITIK (T-9), was diese Probe NICHT deckt:
#   - Sie prueft die WACHE, nicht den CI-Job. Ob der Vorspann in der
#     .gitlab-ci.yml den Zweig wirklich holt, haelt der GoogleTest-Fall
#     GuardBasis.HoltDenBasisZweigSelbstUndZwarVORDemAufruf am YAML-Text fest --
#     ausgefuehrt wird der Vorspann hier nicht.
#   - Sie sagt NICHTS darueber, ob origin/main die inhaltlich richtige Basis
#     ist. Das ist eine Gitflow-Entscheidung, kein Verhalten.
#   - Die Fixtures sind kleine Wegwerf-Repos. Sie decken nicht den flachen Klon
#     (GIT_DEPTH) und nicht die Entflachung; dafuer steht der Vorspann im Job.
#   - Der Scope-Entscheid der Wache (welche Endungen zaehlen) wird hier nur
#     ueber .sh benutzt, nicht erschoepfend geprueft.
#
# POSIX sh (die CI ruft 'sh', das ist hier dash). ASCII-only, kein Python.
# Selbstcheck: die Probe prueft ihre EIGENE Registrierung in der .gitlab-ci.yml
# mit (Arm T7) -- eine Probe, die in keinem Job faehrt, ist nicht gebaut (T-7).
# =============================================================================

set -eu
export LC_ALL=C

MODUS="${1:-}"
case "$MODUS" in
    ''|--selbstbiss) : ;;
    *) echo "AUFRUF: sh ci/tests/guard_basis_bissprobe.sh [--selbstbiss]" >&2; exit 2 ;;
esac

SELBST=$(cd "$(dirname "$0")" && pwd)/$(basename "$0")
HIER=$(cd "$(dirname "$0")" && pwd)
REPO=$(cd "$HIER/../.." && pwd)
WACHE="${COMDARE_WACHE:-$REPO/scripts/ci_diff_ascii_width_guard.sh}"
YAML="$REPO/.gitlab-ci.yml"

command -v git >/dev/null 2>&1    || { echo "ABBRUCH: git fehlt im PATH." >&2; exit 2; }
command -v od >/dev/null 2>&1     || { echo "ABBRUCH: od fehlt im PATH." >&2; exit 2; }
command -v mktemp >/dev/null 2>&1 || { echo "ABBRUCH: mktemp fehlt im PATH." >&2; exit 2; }

if [ ! -f "$WACHE" ]; then
    echo "ABBRUCH: Wache '$WACHE' nicht gefunden -- die Probe konnte nicht pruefen." >&2
    exit 2
fi

WERK=$(mktemp -d) || exit 2
trap 'rm -rf "$WERK"' EXIT INT TERM

N_ARME=0
N_RISSE=0

# --------------------------------------------------------------------------
# Wuerfel. od statt 'tr < /dev/urandom | head -c': kein SIGPIPE, kein
# rc-Ratespiel nach einer Pipe (K11).
# --------------------------------------------------------------------------
token8() {
    _t=$(od -An -tx1 -N4 /dev/urandom | tr -d ' \n')
    [ -n "$_t" ] || { echo "ABBRUCH: /dev/urandom lieferte nichts." >&2; exit 2; }
    echo "$_t"
}

# Ein gewuerfeltes Nicht-ASCII-Zeichen als gueltiges UTF-8-Byte-Paar:
# 0xC3 gefolgt von 0xA0..0xBF (Latin-1-Supplement). Gueltiges UTF-8 -- git
# haelt die Datei damit sicher fuer Text und liefert echte Diff-Zeilen.
koeder_escape() {
    _r=$(od -An -N1 -tu1 /dev/urandom | tr -d ' \n')
    [ -n "$_r" ] || { echo "ABBRUCH: /dev/urandom lieferte nichts." >&2; exit 2; }
    _lo=$(( (_r % 32) + 160 ))
    printf '\\303\\%o' "$_lo"
}

# --------------------------------------------------------------------------
# baue_fixture <zielverzeichnis> <mit_koeder|ohne_koeder>
#
# Drei Commits, Inhalt je Lauf gewuerfelt:
#   C1  = die gedachte main-Spitze (sauber)
#   C2  = traegt im Fall mit_koeder das Nicht-ASCII-Byte in einer .sh-Datei
#   C3  = HEAD (sauber)
# refs/remotes/origin/development wird auf C3 gesetzt: der Bereich
# development..HEAD ist damit LEER -- genau der 0-Commit-Bereich, auf den der
# stille Kettenrueckfall fuehrt. refs/remotes/origin/main bleibt ABWESEND und
# wird nur dort gesetzt, wo der Arm es ausdruecklich braucht.
#
# Die Wache leitet ihre Repo-Wurzel aus dem eigenen Skript-Verzeichnis ab
# (<dir>/..), deshalb liegt die Kopie unter <fixture>/scripts/.
# Schreibt C1 nach <zielverzeichnis>.c1 und den Koedernamen nach .koeder.
# --------------------------------------------------------------------------
baue_fixture() {
    _fx="$1"
    _art="$2"
    mkdir -p "$_fx/scripts"
    cp "$WACHE" "$_fx/scripts/ci_diff_ascii_width_guard.sh"
    chmod +x "$_fx/scripts/ci_diff_ascii_width_guard.sh"

    git init -q -b development "$_fx"
    git -C "$_fx" config user.email "bissprobe@invalid"
    git -C "$_fx" config user.name  "bissprobe"
    git -C "$_fx" config commit.gpgsign false

    _tok=$(token8)
    printf '#!/bin/sh\n# sauber %s\necho ok\n' "$_tok" > "$_fx/werkzeug.sh"
    git -C "$_fx" add -A
    git -C "$_fx" commit -q -m "C1 gedachte main-Spitze $_tok"
    git -C "$_fx" rev-parse HEAD > "$_fx.c1"

    if [ "$_art" = mit_koeder ]; then
        _kn="koeder_$(token8).sh"
        _esc=$(koeder_escape)
        printf '#!/bin/sh\n# koeder ' > "$_fx/$_kn"
        # Die Escape-Folge steht im FORMAT, damit printf sie in Bytes umsetzt.
        # shellcheck disable=SC2059
        printf "$_esc" >> "$_fx/$_kn"
        printf '\necho ok\n' >> "$_fx/$_kn"
        echo "$_kn" > "$_fx.koeder"
        git -C "$_fx" add -A
        git -C "$_fx" commit -q -m "C2 traegt den Koeder"
    else
        printf '#!/bin/sh\n# auch sauber %s\necho ok\n' "$(token8)" > "$_fx/zwischen.sh"
        : > "$_fx.koeder"
        git -C "$_fx" add -A
        git -C "$_fx" commit -q -m "C2 ohne Koeder"
    fi

    printf '#!/bin/sh\n# spaeter %s\necho ok\n' "$(token8)" > "$_fx/spaeter.sh"
    git -C "$_fx" add -A
    git -C "$_fx" commit -q -m "C3 HEAD"

    git -C "$_fx" update-ref refs/remotes/origin/development "$(git -C "$_fx" rev-parse HEAD)"
}

# --------------------------------------------------------------------------
# arm <name> <erwarteter-rc> <geforderter-text> <fixture> [<basis-ref-wert>]
#
# Ohne fuenften Parameter laeuft die Wache mit AUSDRUECKLICH ENTFERNTER
# Variable (env -u), das ist Arm D. Der rc wird OHNE Pipe erfasst (K11).
# --------------------------------------------------------------------------
arm() {
    _name="$1"
    _erw="$2"
    _soll_text="$3"
    _fx="$4"
    _basis="${5:-__UNGESETZT__}"
    N_ARME=$((N_ARME + 1))
    _log="$WERK/arm_$N_ARME.log"

    set +e
    if [ "$_basis" = __UNGESETZT__ ]; then
        ( cd "$_fx" && env -u COMDARE_GUARD_BASIS_REF \
              sh scripts/ci_diff_ascii_width_guard.sh --seit-basis ) > "$_log" 2>&1
    else
        ( cd "$_fx" && COMDARE_GUARD_BASIS_REF="$_basis" \
              sh scripts/ci_diff_ascii_width_guard.sh --seit-basis ) > "$_log" 2>&1
    fi
    _rc=$?
    set -e

    if [ "$_rc" -ne "$_erw" ]; then
        N_RISSE=$((N_RISSE + 1))
        echo "  [ROT ]  $_name"
        echo "        RISS: Wache lieferte rc=$_rc, gefordert war rc=$_erw."
        echo "        Literale Ausgabe der Wache:"
        sed 's/^/          | /' "$_log"
        return 0
    fi
    if ! grep -qF -- "$_soll_text" "$_log"; then
        N_RISSE=$((N_RISSE + 1))
        echo "  [ROT ]  $_name"
        echo "        SCHEINTREFFER: rc=$_rc stimmt, aber die Ausgabe nennt den"
        echo "        geforderten Gegenstand nicht. Gefordert war: >>$_soll_text<<"
        echo "        Literale Ausgabe der Wache:"
        sed 's/^/          | /' "$_log"
        return 0
    fi
    echo "  [ OK ]  $_name  (rc=$_rc, und die Ausgabe nennt >>$_soll_text<<)"
}

# bereichsbreite <logdatei> -- die von der Wache selbst gemeldete Commit-Zahl.
bereichsbreite() {
    awk '/BEREICHSBREITE/ { for (i = 1; i <= NF; i++) if ($i ~ /^[0-9]+$/) { print $i; exit } }' "$1"
}

echo "============================================================================="
echo "BISSPROBE BASIS-WAHL DER DIFF-HYGIENE-WACHE"
echo "  Wache : $WACHE"
echo "  Modus : ${MODUS:-<nur Arme>}"
echo "============================================================================="

# --------------------------------------------------------------------------
# WERKZEUG-GEGENPROBE VOR JEDER NULL: beisst der Koeder ueberhaupt, und
# findet grep ihn? Ein "0 Nicht-ASCII" ist sonst nicht unterscheidbar von
# "das Werkzeug sucht nicht" -- dieselbe Falle, an der am 08.08. eine Null
# wertlos war.
# --------------------------------------------------------------------------
PRUEF="$WERK/koeder_eichung.sh"
E_ESC=$(koeder_escape)
printf '#!/bin/sh\n# eichung ' > "$PRUEF"
# shellcheck disable=SC2059
printf "$E_ESC" >> "$PRUEF"
printf '\necho ok\n' >> "$PRUEF"
N_NA=$(grep -c '[^ -~	]' "$PRUEF" || true)
N_ZEILEN=$(awk 'END{print NR+0}' "$PRUEF")
echo ""
echo "WERKZEUG-GEGENPROBE: Eichdatei mit $N_ZEILEN Zeilen, davon $N_NA mit Nicht-ASCII"
# printf '%s' statt echo: die Escape-Folge soll als TEXT im Protokoll stehen. Das
# echo von dash setzt Backslash-Folgen um und schriebe das rohe Byte ins CI-Log.
printf '  (gewuerfelte Byte-Folge: %s, gefordert: genau 1 Zeile).\n' "$E_ESC"
if [ "$N_NA" -ne 1 ]; then
    echo "ABBRUCH: der Koeder biss nicht -- $N_NA von 1 erwarteten Nicht-ASCII-Zeilen." >&2
    echo "         Ohne beissenden Koeder ist jede Zahl dieser Probe wertlos." >&2
    exit 2
fi
echo "  Der Koeder beisst; die Arme sind belastbar."

# ==========================================================================
# ARM A -- die Basis IST da, der Koeder liegt im Bereich: die Wache MUSS rot
# werden. Ohne diesen Arm waere ein Dauer-Gruen der Wache nicht auffindbar.
# ==========================================================================
echo ""
echo "--- ARM A  Basis vorhanden, Koeder im Bereich -> ROT (rc=1) ----------------"
FX_A="$WERK/fx_a"
baue_fixture "$FX_A" mit_koeder
git -C "$FX_A" update-ref refs/remotes/origin/main "$(cat "$FX_A.c1")"
echo "  (gewuerfelter Koeder: $(cat "$FX_A.koeder"), Basis-Ref origin/main gesetzt)"
arm "A  Koeder im Bereich wird gefunden" 1 "DIFF-HYGIENE-WACHE: ROT." "$FX_A" "origin/main"

# ==========================================================================
# ARM B -- DER KERN. Die GENANNTE Basis loest nicht auf, waehrend
# origin/development auf HEAD steht. Die alte Kette rutschte still dorthin und
# meldete GRUEN ueber einem 0-Commit-Bereich. Gefordert ist ABBRUCH (rc=2).
# ==========================================================================
echo ""
echo "--- ARM B  genannte Basis unaufloesbar -> ABBRUCH (rc=2), nie gruen --------"
FX_B="$WERK/fx_b"
baue_fixture "$FX_B" mit_koeder
BASIS_KOEDER="origin/koeder_$(token8)"
echo "  (gewuerfelter Basisname: $BASIS_KOEDER; origin/main bleibt ABWESEND)"

# GEGENPROBE ZUM ARM SELBST (V-8): ist die Lage wirklich die gemeinte?
# 1. Der gewuerfelte Name darf NICHT aufloesen -- sonst prueft der Arm nichts.
if git -C "$FX_B" rev-parse --verify --quiet "${BASIS_KOEDER}^{commit}" >/dev/null 2>&1; then
    echo "ABBRUCH: der gewuerfelte Basisname loest im Fixture doch auf." >&2
    exit 2
fi
# 2. origin/development MUSS aufloesen -- sonst gaebe es kein Rueckfallziel und
#    der Arm koennte auch ohne den Fix nicht gruen werden.
git -C "$FX_B" rev-parse --verify --quiet 'refs/remotes/origin/development^{commit}' >/dev/null 2>&1 \
    || { echo "ABBRUCH: origin/development fehlt im Fixture -- Arm B waere gegenstandslos." >&2; exit 2; }
# 3. Der Rueckfall MUSS auf einen 0-Commit-Bereich fuehren. Genau das macht das
#    stille Gruen aus; ohne diese Zahl waere Arm B nicht der gemeinte Eingang.
MB_DEV=$(git -C "$FX_B" merge-base refs/remotes/origin/development HEAD)
N_DEV=$(git -C "$FX_B" rev-list --count "${MB_DEV}..HEAD")
MB_C1=$(git -C "$FX_B" merge-base "$(cat "$FX_B.c1")" HEAD)
N_C1=$(git -C "$FX_B" rev-list --count "${MB_C1}..HEAD")
echo "  NENNER des Rueckfalls: origin/development..HEAD = $N_DEV Commit(s),"
echo "  gedachte main-Spitze..HEAD = $N_C1 Commit(s). Gefordert: 0 und >0."
if [ "$N_DEV" -ne 0 ] || [ "$N_C1" -lt 1 ]; then
    echo "ABBRUCH: das Fixture bildet die Lage nicht ab ($N_DEV / $N_C1)." >&2
    exit 2
fi
arm "B  unaufloesbare Basis bricht ab, statt still zurueckzufallen" \
    2 "ist in diesem Klon NICHT aufloesbar" "$FX_B" "$BASIS_KOEDER"

# ==========================================================================
# ARM C -- GEGENKOEDER gegen Dauer-Rot: gesunder Baum, Basis vorhanden, kein
# Koeder. Die Wache MUSS gruen sein -- aber ueber einem NICHT leeren Bereich.
# ==========================================================================
echo ""
echo "--- ARM C  gesunder Baum, Basis vorhanden -> GRUEN (rc=0) ------------------"
FX_C="$WERK/fx_c"
baue_fixture "$FX_C" ohne_koeder
git -C "$FX_C" update-ref refs/remotes/origin/main "$(cat "$FX_C.c1")"
arm "C  gesunder Baum bleibt gruen (Gegenkoeder)" 0 "DIFF-HYGIENE-WACHE: GRUEN." \
    "$FX_C" "origin/main"
BB_C=$(bereichsbreite "$WERK/arm_$N_ARME.log")
echo "  NENNER: die Wache meldet BEREICHSBREITE ${BB_C:-<keine>} Commit(s) (gefordert: >= 1)."
if [ -z "$BB_C" ] || [ "$BB_C" -lt 1 ]; then
    N_RISSE=$((N_RISSE + 1))
    echo "  [ROT ]  C  Gruen ueber leerem Bereich -- das ist die stille Null selbst."
fi

# ==========================================================================
# ARM D -- RUECKWAERTSVERTRAEGLICH: die Variable ist NICHT gesetzt, also greift
# die Kandidaten-Kette wie dokumentiert. Auch das ist ein Gegenkoeder: der Fix
# darf den manuellen Aufruf nicht kaputt machen.
# ==========================================================================
echo ""
echo "--- ARM D  Variable ungesetzt -> Kandidaten-Kette, GRUEN (rc=0) ------------"
FX_D="$WERK/fx_d"
baue_fixture "$FX_D" ohne_koeder
git -C "$FX_D" update-ref refs/remotes/origin/main "$(cat "$FX_D.c1")"
arm "D  ungesetzte Variable nutzt die Kette (erster Kandidat origin/main)" \
    0 "Basis-Referenz : origin/main" "$FX_D"
BB_D=$(bereichsbreite "$WERK/arm_$N_ARME.log")
echo "  NENNER: die Wache meldet BEREICHSBREITE ${BB_D:-<keine>} Commit(s) (gefordert: >= 1)."
if [ -z "$BB_D" ] || [ "$BB_D" -lt 1 ]; then
    N_RISSE=$((N_RISSE + 1))
    echo "  [ROT ]  D  Gruen ueber leerem Bereich -- das ist die stille Null selbst."
fi

# ==========================================================================
# ARM T7 -- REGISTRIERUNG. Eine Probe, die in keinem Job faehrt, ist nicht
# gebaut. Geprueft wird der AUFRUF, nicht das blosse Vorkommen des Pfades:
# der Pfad steht auch in Prosa.
# ==========================================================================
echo ""
echo "--- ARM T7  ist diese Probe im CI registriert? ----------------------------"
N_ARME=$((N_ARME + 1))
if [ ! -f "$YAML" ]; then
    N_RISSE=$((N_RISSE + 1))
    echo "  [ROT ]  T7 .gitlab-ci.yml nicht gefunden unter $YAML"
else
    N_AUFRUFE=$(grep -cF 'sh ci/tests/guard_basis_bissprobe.sh' "$YAML" || true)
    N_YAML=$(awk 'END{print NR+0}' "$YAML")
    echo "  NENNER: $N_AUFRUFE Aufrufstelle(n) in $N_YAML Zeilen .gitlab-ci.yml (gefordert: >= 1)."
    if [ "$N_AUFRUFE" -lt 1 ]; then
        N_RISSE=$((N_RISSE + 1))
        echo "  [ROT ]  T7 diese Probe wird von keinem Job gerufen -- sie ist Dekoration."
    else
        echo "  [ OK ]  T7 die Probe ist registriert."
    fi
fi

# ==========================================================================
echo ""
echo "============================================================================="
echo "NENNER: $N_ARME Arme gefahren, $N_RISSE gerissen."
echo "============================================================================="
if [ "$N_RISSE" -ne 0 ]; then
    echo "BISSPROBE ROT: $N_RISSE von $N_ARME Armen gerissen." >&2
    exit 1
fi
echo "BISSPROBE GRUEN: $N_ARME von $N_ARME Armen gehalten."

# --------------------------------------------------------------------------
# --selbstbiss (T-1): der Beweis, dass die Probe ueberhaupt beisst.
# --------------------------------------------------------------------------
[ "$MODUS" = "--selbstbiss" ] || exit 0

echo ""
echo "============================================================================="
echo "SELBSTBISS: Wegwerf-Mutanten der Wache -- die Probe MUSS an ihnen rot werden."
echo "============================================================================="

ORIG_ZEILEN=$(awk 'END{print NR}' "$WACHE")
N_MUT=0
N_MUT_GEBISSEN=0

# M1: der elif-Zweig faellt heraus -- EXAKT die Mutation vom 10.08., die 4 von 4
# damals gefahrenen Gates gruen liess. Ohne ihn ist eine gesetzte, nicht
# aufloesbare Basis wieder nur der erste Kandidat einer Kette.
mutiere_ohne_elif() {
    awk '
        index($0, "elif [ -n \"${COMDARE_GUARD_BASIS_REF:-}\" ]; then") > 0 { weg = 1; next }
        weg == 1 && $0 ~ /^[ \t]*else[ \t]*$/ { weg = 0 }
        weg == 0 { print }
    ' "$WACHE" > "$1"
}

# M2: das abschliessende 'exit 1' faellt heraus -- ein gefundener Verstoss
# meldet dann rc=0. Zweite, UNABHAENGIGE Richtung: sie zeigt, dass die Probe
# nicht nur auf Arm B reagiert, sondern auch auf ein Dauer-Gruen in Arm A.
mutiere_ohne_exit1() {
    awk '
        /^    exit 1$/ { n++; if (n == 1) next }
        { print }
    ' "$WACHE" > "$1"
}

selbstbiss_fall() {   # $1 = Name, $2 = Baufunktion, $3 = Mindest-Zeilendifferenz,
                      # $4 = Text, der in der roten Ausgabe stehen MUSS
    N_MUT=$((N_MUT + 1))
    _m="$WERK/mutant_$N_MUT.sh"
    "$2" "$_m"
    _mz=$(awk 'END{print NR}' "$_m")
    _diff=$((ORIG_ZEILEN - _mz))
    echo ""
    echo "  --- Mutant '$1' ($ORIG_ZEILEN -> $_mz Zeilen, $_diff entfernt) ---"
    if [ "$_diff" -lt "$3" ]; then
        echo "  [ABBRUCH] Mutation griff NICHT: $_diff Zeile(n) entfernt, gefordert >= $3." >&2
        echo "            Ein still nicht mehr greifender Mutant belegt nichts." >&2
        exit 2
    fi
    if ! sh -n "$_m" 2>/dev/null; then
        echo "  [ABBRUCH] der Mutant ist syntaktisch kaputt -- das waere kein Mutant," >&2
        echo "            sondern ein Trivialfehler, und der Biss waere wertlos." >&2
        exit 2
    fi
    _log="$WERK/mutlog_$N_MUT.txt"
    set +e
    COMDARE_WACHE="$_m" sh "$SELBST" > "$_log" 2>&1
    _rc=$?
    set -e
    if [ "$_rc" -eq 0 ]; then
        echo "  [ROT ]  Mutant '$1' UEBERLEBT die Probe (rc=0) -- die Probe beisst hier nicht."
        sed 's/^/          | /' "$_log"
        return 0
    fi
    if ! grep -qF -- "$4" "$_log"; then
        echo "  [SCHEINBISS] '$1' wurde rot (rc=$_rc), aber nicht ueber den gemeinten Arm." >&2
        echo "               Gefordert war der Text: >>$4<<" >&2
        sed 's/^/               | /' "$_log" >&2
        exit 1
    fi
    N_MUT_GEBISSEN=$((N_MUT_GEBISSEN + 1))
    echo "  [ OK ]  Mutant '$1' wird gefangen (Probe rc=$_rc). Literale Ausgabe:"
    awk '/^  \[ROT \]|^        RISS:|^NENNER:|^BISSPROBE/' "$_log" | sed 's/^/          | /'
}

selbstbiss_fall "M1  ohne den elif-Zweig (die W0B-Mutation)" \
    mutiere_ohne_elif 1 "B  unaufloesbare Basis bricht ab"
selbstbiss_fall "M2  ohne das abschliessende 'exit 1'" \
    mutiere_ohne_exit1 1 "A  Koeder im Bereich wird gefunden"

echo ""
echo "============================================================================="
echo "NENNER SELBSTBISS: $N_MUT Mutanten gefahren, $N_MUT_GEBISSEN gefangen."
echo "============================================================================="
if [ "$N_MUT_GEBISSEN" -ne "$N_MUT" ]; then
    echo "SELBSTBISS ROT: $((N_MUT - N_MUT_GEBISSEN)) von $N_MUT Mutanten ueberleben." >&2
    exit 1
fi
echo "SELBSTBISS GRUEN: alle $N_MUT Mutanten gefangen -- die Probe beisst."
exit 0
