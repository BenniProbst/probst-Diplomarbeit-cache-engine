#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  PROBE fuer die THESIS-GITLINK-PARITAETS-WACHE (ci/thesis_gitlink_parity.sh)
#  -- die Wache selbst ist ein Pruefling, nicht nur ein Pruefer.     (2026-08-09)
# =============================================================================
#
# SELBSTCHECK -- was diese Datei zusichert, und was NICHT:
#   ZUSICHERT: die Wache faellt bei jedem der 9 Eingaenge, bei denen ihr eigener
#              Kopf-Vertrag "Fehler" verspricht (rc=1 Divergenz/fehlender Pfad,
#              rc=2 Bedienung/Umgebung), und sie schweigt bei den 4 Eingaengen,
#              bei denen sie schweigen muss. Beide LESEPFADE (--quelle head ueber
#              ls-tree, --quelle index ueber ls-files --stage) werden gefahren.
#   NICHT:     sie prueft nicht, ob die .gitmodules-Doppelbindung ueberhaupt
#              bestehen bleiben soll (Owner-Entscheid, Loeschung = GO). Volle
#              Grenzliste unter TESTKRITIK, ganz unten.
#
# DER BEFUND, GEGEN DEN SIE GEBAUT IST:
# ci/thesis_gitlink_parity.sh haelt die beiden Einbindungen DESSELBEN Thesis-
# Repos gleich und wird an ZWEI scharfen Stellen gerufen: in verify:submodules
# als Praevention (--quelle head) und in anhang:forward als NACHBEDINGUNG des
# Rueckschriebs (--quelle index --erwartet <sha>). An der zweiten Stelle ist sie
# das einzige, was beweist, dass der Rueckschrieb WIRKLICH beide Zeiger gesetzt
# hat. Ihr Verschwinden als Datei ist an beiden Aufrufstellen mit `test -x ...
# || exit 1` abgefangen; ihre stille AUFWEICHUNG war es nicht. Faellt ein `exit`
# aus ihr heraus, meldet sie weiterhin "Paritaet OK" -- und die CI erzeugt die
# Divergenz, gegen die sie gebaut wurde, ab da bei jedem Rueckschrieb selbst.
#
# WAS "BISS" HIER HEISST (TDD-Vertrag T-1):
# Die Probe wird zusaetzlich gegen WEGWERF-MUTANTEN gefahren; `--selbstbiss`
# fordert, dass sie an jedem ROT wird. Eine Probe, die am kranken Objekt gruen
# bleibt, ist keine Probe.
#
# -----------------------------------------------------------------------------
# DIE ENTSCHEIDENDE VORPRUEFUNG: IST DER MUTIERTE ZWEIG UEBERHAUPT BEOBACHTBAR?
# -----------------------------------------------------------------------------
# Ein Mutant, der stirbt, weil eine ANDERE Zeile ihn faengt, beweist das
# Gegenteil von dem, was er soll. Jeder Zweig wurde am Objekt gemessen (Original
# gegen Mutant, sieben Eingaenge, rc protokolliert):
#
#   Zweig (Marker im Text)             Eingang, der ihn zeigt    ORIG -> MUTANT
#   ---------------------------------  ------------------------  --------------
#   "fail-closed: ein fehlender ..."   BEIDE Gitlinks fehlen       1 -> 0
#   "beide Zeiger IMMER GEMEINSAM"     divergente SHAs             1 -> 0
#   "erwartet war aber"                --erwartet verfehlt         1 -> 0
#   "--quelle muss 'head' oder ..."    --quelle mit Unsinn         2 -> 0
#   "kein git-Repository"              Aufruf ausserhalb eines     2 -> 1
#                                      git-Baums
#
# DIE FALLE, DIE HIER WIRKLICH ZUSCHNAPPTE -- und warum Fall F6 existiert:
# Der naheliegende Eingang fuer den FEHLT-Zweig ist "ein Gitlink fehlt". Der
# taugt NICHT. Gemessen: fehlt nur EINER, ist a="<sha>" und b="", die beiden
# sind ungleich, und der Mutant faellt eine Handvoll Zeilen spaeter im
# DIVERGENZ-Zweig -- mit demselben rc=1. Die Zeile im Messprotokoll:
#     Eingang "nur der lebende Pfad":   ORIG 1  ->  MUTANT 1   (kein Unterschied)
#     Eingang "BEIDE fehlen":           ORIG 1  ->  MUTANT 0   (Unterschied)
# Nur wenn BEIDE fehlen, sind a und b GLEICH (beide leer), der Divergenz-Zweig
# greift nicht mehr, und der Mutant laeuft bis zum Schluss-echo durch: er meldet
# "Paritaet OK ... beide Zeiger auf " -- mit leerem SHA -- und endet mit 0.
# Fall F6 ist deshalb der EINZIGE Fall, der Mutant M1 toetet. Ohne ihn waere die
# halbe fail-closed-Zusage der Wache ungeprueft, und die Faelle F4/F5 haetten
# eine Deckung nur vorgetaeuscht.
#
# FIXTURES OHNE ECHTE SUBMODULE: ein Gitlink ist ein Index-Eintrag mit Modus
# 160000. Er laesst sich mit `git update-index --add --cacheinfo` direkt setzen,
# ohne dass das Ziel-Repo existieren muss -- die Wache liest ohnehin nur den
# Zeiger, nie den Inhalt. Damit braucht die Probe kein Netz, kein Klonen und
# keine Submodul-Initialisierung. Fuer --quelle head wird zusaetzlich committet;
# die Identitaet kommt per `git -c user.name=... -c user.email=...` NUR fuer
# diesen einen Aufruf, damit weder globale noch Repo-Konfiguration angefasst
# wird.
#
# ORAKEL (T-5): die SHAs sind KEINE abgeschriebenen Konstanten, sondern je Lauf
# frisch aus /dev/urandom gewuerfelt (K13). Eine Wache, die einen festen Wert
# faelscht oder Zeiger verwechselt, faellt daran; die Probe fordert die
# gewuerfelten Werte woertlich in der Ausgabe.
#
# AUFRUF:
#   sh ci/tests/thesis_gitlink_parity_probe.sh              # nur die Faelle
#   sh ci/tests/thesis_gitlink_parity_probe.sh --selbstbiss # + Mutationsbeweis
#
# ENV:
#   COMDARE_WACHE   Pfad zur zu pruefenden Wache
#                   (Default: <repo>/ci/thesis_gitlink_parity.sh).
#                   Der --selbstbiss-Zweig setzt sie auf die Mutanten.
#
# EXIT: 0 = alle Faelle gehalten
#       1 = mindestens ein Fall gerissen (Zahl + literale Ausgabe im Protokoll)
#       2 = die Probe konnte nicht pruefen (Wache fehlt, Fixture liess sich nicht
#           bauen, Mutation griff nicht, Koeder biss nicht) -- KEIN Gruen.
#
# TESTKRITIK (T-9), was diese Probe NICHT deckt:
#   - Die Zweige "git nicht gefunden" und "awk nicht gefunden": beide sind ohne
#     einen PATH ohne git bzw. awk nicht ausloesbar, und ein PATH ohne git
#     nimmt der Probe zugleich das Werkzeug, mit dem sie ihre Fixtures baut.
#     Ehrlich als Luecke benannt statt mit einem Schein-Fall zugedeckt.
#   - Sie prueft die beiden AUFRUFSTELLEN nur auf Vorhandensein (F13 deckt die
#     eigene Registrierung); dass verify:submodules und anhang:forward die
#     richtige --quelle waehlen, bleibt ungedeckt.
#   - Sie prueft keine Nebenlaeufigkeit und keinen echten Rueckschrieb: der
#     Beweis, dass anhang:forward BEIDE Zeiger bumpt, gehoert zu jenem Job.
#   - Der Mutations-Katalog ist nicht vollstaendig: eine Aufweichung, die statt
#     eines `exit` den awk-Feldvergleich verdreht (z.B. 160000 -> 100644), wird
#     von F7 gefangen, aber es gibt keinen erschoepfenden Katalog.
#
# POSIX-sh (die CI ruft `sh`, das ist hier dash), ASCII-only, kein Python.
# =============================================================================

set -eu

SELBST_DIR=$(cd "$(dirname "$0")" && pwd)
SELBST="$SELBST_DIR/$(basename "$0")"
REPO=$(cd "$SELBST_DIR/../.." && pwd)
WACHE="${COMDARE_WACHE:-$REPO/ci/thesis_gitlink_parity.sh}"
CI_YML="$REPO/.gitlab-ci.yml"

# Die Pfade stehen so in der Wache. Sie hier zu WIEDERHOLEN ist Absicht: benennt
# jemand einen um, ohne den anderen mitzuziehen, faellt die Probe -- das ist der
# gewollte Bruch, keine Doppelpflege aus Versehen.
P_LEBEND="thesis/diplomarbeit"
P_TOT="Code/external/20260931-overleaf-diplomarbeit"

# Kein fremdes git-Environment darf die Wegwerf-Repos umbiegen.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_OBJECT_DIRECTORY 2>/dev/null || true

MODUS="${1:-}"
case "$MODUS" in
    ''|--selbstbiss) : ;;
    *) echo "AUFRUF: sh ci/tests/thesis_gitlink_parity_probe.sh [--selbstbiss]" >&2; exit 2 ;;
esac

if [ ! -f "$WACHE" ]; then
    echo "ABBRUCH: Wache '$WACHE' nicht gefunden -- die Probe konnte nicht pruefen." >&2
    exit 2
fi
for _w in git awk od; do
    command -v "$_w" >/dev/null 2>&1 || {
        echo "ABBRUCH: '$_w' fehlt -- die Probe konnte nicht pruefen (kein Gruen ohne Pruefung)." >&2
        exit 2
    }
done

WERK=$(mktemp -d) || exit 2
trap 'rm -rf "$WERK"' EXIT INT TERM
OUT="$WERK/_stdout"; ERR="$WERK/_stderr"; BEIDE="$WERK/_beide"

N_FALL=0; N_OK=0; N_ROT=0
RC=0

# --- Wuerfel (K13): der Koeder wird erzeugt, nie abgeschrieben ----------------
# od statt `tr < /dev/urandom | head -c`: kein SIGPIPE, kein rc-Ratespiel.
sha() { od -An -tx1 -N20 /dev/urandom | tr -d ' \n'; }
token() { od -An -tx1 -N6 /dev/urandom | tr -d ' \n'; }
wuerfel() {           # Zahl aus [$1..$2]
    _lo="$1"; _hi="$2"; _spanne=$((_hi - _lo + 1))
    _roh=$(od -An -tu1 -N1 /dev/urandom | tr -d ' \n')
    echo $(( _lo + (_roh % _spanne) ))
}

# --- Fixtures ----------------------------------------------------------------
# Ein Gitlink ist ein Index-Eintrag mit Modus 160000. `update-index --cacheinfo`
# setzt ihn direkt; das Ziel-Repo muss nicht existieren, weil die Wache nur den
# ZEIGER liest. Kein Netz, kein Klon, keine Submodul-Initialisierung.
mkrepo() {            # $1 = Kurzname -> setzt $D
    D="$WERK/$1"
    mkdir -p "$D"
    ( cd "$D" && git init -q >/dev/null 2>&1 ) || {
        echo "ABBRUCH: 'git init' im Fixture '$1' fehlgeschlagen." >&2; exit 2; }
}
setze_gitlink() {     # $1 = Pfad, $2 = SHA
    ( cd "$D" && git update-index --add --cacheinfo 160000,"$2","$1" >/dev/null 2>&1 ) || {
        echo "ABBRUCH: Gitlink '$1' liess sich nicht setzen -- Fixture untauglich." >&2; exit 2; }
}
friere_ein() {        # Index -> HEAD, damit --quelle head etwas zu lesen hat.
    ( cd "$D" && git -c user.name=probe -c user.email=probe@invalid \
        commit -q -m "fixture" >/dev/null 2>&1 ) || {
        echo "ABBRUCH: Fixture-Commit fehlgeschlagen -- --quelle head nicht pruefbar." >&2; exit 2; }
}
# Gegenprobe: das Fixture muss WIRKLICH tragen, was der Fall behauptet. Ohne sie
# koennte ein stillschweigend leerer Index einen Fall gruen faerben, der nichts
# geprueft hat.
fordere_stage() {     # $1 = erwartete Zahl Gitlinks im Index
    _ist=$( cd "$D" && git ls-files --stage | awk '$1 == "160000" {n++} END{print n+0}' )
    if [ "$_ist" -ne "$1" ]; then
        echo "  [ABBRUCH] Fixture untauglich: $_ist Gitlink(s) im Index, erwartet $1." >&2
        exit 2
    fi
    echo "        Gegenprobe Fixture: $_ist Gitlink(s) mit Modus 160000 im Index."
}

# --- Lauf ohne Pipe: rc=$? nach einer Pipe misst das LETZTE Glied (K11) -------
lauf() {              # $1 = Arbeitsverzeichnis, danach die Argumente der Wache
    : > "$OUT"; : > "$ERR"
    FALL_WACHE=1
    _dir="$1"; shift
    set +e
    ( cd "$_dir" || exit 99; sh "$WACHE" "$@" ) > "$OUT" 2> "$ERR"
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
# FALL_WACHE trennt Faelle, die die Wache WIRKLICH gerufen haben, vom
# Abnahme-Fall F13. Ohne diese Trennung haengt das Protokoll eines gerissenen
# Abnahme-Falls die Ausgabe des LETZTEN Wache-Laufs an und behauptet damit einen
# Zusammenhang, den es nicht gibt.
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
echo "PROBE THESIS-GITLINK-PARITAETS-WACHE"
echo "  Pruefling : $WACHE"
echo "  Werkbank  : $WERK"
echo "  Modus     : ${MODUS:-nur-faelle}"
echo "  git       : $(git --version 2>&1 | head -1)"
echo "============================================================================="

# =============================================================================
# F1  Beide Gitlinks auf DEMSELBEN gewuerfelten SHA, Quelle index -> rc=0, und
#     die Wache muss GENAU diesen SHA nennen (Aussage statt Anwesenheit).
# =============================================================================
SHA_A=$(sha)
fall "F1  beide Zeiger gleich, --quelle index -> rc=0 und nennt den SHA"
mkrepo f1
setze_gitlink "$P_LEBEND" "$SHA_A"
setze_gitlink "$P_TOT"    "$SHA_A"
fordere_stage 2
lauf "$D" --quelle index
fordere_rc 0
fordere_literal "$OUT" "Thesis-Gitlink-Paritaet OK (Quelle 'index'): beide Zeiger auf $SHA_A"
fordere_kein_literal "$BEIDE" "FEHLER"
fall_ende

# =============================================================================
# F2  DERSELBE Bestand ueber den ANDEREN Lesepfad: --quelle head liest per
#     ls-tree aus dem Commit, --quelle index per ls-files --stage. Zwei
#     verschiedene git-Kommandos mit verschiedenen Feldreihenfolgen -- ein
#     Zahlendreher in einem der beiden awk-Ausdruecke waere ohne diesen Fall
#     unsichtbar.
# =============================================================================
SHA_B=$(sha)
fall "F2  beide Zeiger gleich, --quelle head (ls-tree statt ls-files) -> rc=0"
mkrepo f2
setze_gitlink "$P_LEBEND" "$SHA_B"
setze_gitlink "$P_TOT"    "$SHA_B"
friere_ein
lauf "$D" --quelle head
fordere_rc 0
fordere_literal "$OUT" "Thesis-Gitlink-Paritaet OK (Quelle 'head'): beide Zeiger auf $SHA_B"
fall_ende

# =============================================================================
# F3  DIVERGENZ -- der Befund, gegen den die Wache gebaut wurde. rc=1, und die
#     Meldung muss BEIDE Pfade UND BEIDE SHAs nennen: eine Fehlermeldung, die
#     nur "ungleich" sagt, zwingt zum Nachmessen von Hand.
# =============================================================================
SHA_C=$(sha); SHA_D=$(sha)
fall "F3  divergente Zeiger -> rc=1, beide Pfade und beide SHAs genannt"
mkrepo f3
setze_gitlink "$P_LEBEND" "$SHA_C"
setze_gitlink "$P_TOT"    "$SHA_D"
fordere_stage 2
lauf "$D" --quelle index
fordere_rc 1
fordere_literal "$ERR" "die beiden Gitlinks DESSELBEN Repos divergieren:"
fordere_literal "$ERR" "$P_LEBEND = $SHA_C"
fordere_literal "$ERR" "$P_TOT = $SHA_D"
fordere_kein_literal "$OUT" "Paritaet OK"
fall_ende

# =============================================================================
# F4  Nur der LEBENDE Pfad ist da -> rc=1, und die Wache muss den FEHLENDEN
#     namentlich nennen. WICHTIG: sie darf hier NICHT von "divergieren" reden --
#     der Grund ist ein anderer, und eine falsche Diagnose kostet beim Suchen
#     mehr als keine.
# =============================================================================
SHA_E=$(sha)
fall "F4  nur '$P_LEBEND' vorhanden -> rc=1, fehlender Pfad benannt"
mkrepo f4
setze_gitlink "$P_LEBEND" "$SHA_E"
fordere_stage 1
lauf "$D" --quelle index
fordere_rc 1
fordere_literal "$ERR" "Gitlink FEHLT in Quelle 'index': $P_TOT"
fordere_literal "$ERR" "fail-closed: ein fehlender Gitlink-Pfad ist ein FEHLER"
fordere_kein_literal "$ERR" "divergieren"
fall_ende

# =============================================================================
# F5  Spiegelbild von F4: nur der TOTE Pfad ist da. Beide Richtungen, damit die
#     Wache nicht bloss "irgendeinen" der beiden prueft.
# =============================================================================
SHA_F=$(sha)
fall "F5  nur '$P_TOT' vorhanden -> rc=1"
mkrepo f5
setze_gitlink "$P_TOT" "$SHA_F"
fordere_stage 1
lauf "$D" --quelle index
fordere_rc 1
fordere_literal "$ERR" "Gitlink FEHLT in Quelle 'index': $P_LEBEND"
fordere_kein_literal "$ERR" "divergieren"
fall_ende

# =============================================================================
# F6  BEIDE Gitlinks fehlen -> rc=1.
#     DER FALL, DER DEN FEHLT-ZWEIG UEBERHAUPT BEOBACHTBAR MACHT. F4 und F5
#     tun das NICHT: dort sind a und b ungleich, und ein Mutant ohne diesen
#     `exit 1` faellt eine Handvoll Zeilen spaeter im Divergenz-Zweig mit
#     demselben rc=1 (gemessen: ORIG 1 -> MUTANT 1, kein Unterschied). Erst
#     wenn BEIDE leer sind, sind sie GLEICH, der Divergenz-Zweig greift nicht,
#     und der Mutant meldet "Paritaet OK ... beide Zeiger auf " mit LEEREM SHA
#     und rc=0. Ohne diesen Fall waere die halbe fail-closed-Zusage ungeprueft.
# =============================================================================
fall "F6  BEIDE Gitlinks fehlen -> rc=1 (der einzige Fall, der M1 toetet)"
mkrepo f6
printf 'nur Prosa, kein Gitlink: %s\n' "$(token)" > "$D/liesmich.txt"
( cd "$D" && git add -A >/dev/null 2>&1 ) || { echo "ABBRUCH: git add im f6-Fixture." >&2; exit 2; }
fordere_stage 0
lauf "$D" --quelle index
fordere_rc 1
fordere_literal "$ERR" "Gitlink FEHLT in Quelle 'index': $P_LEBEND"
fordere_literal "$ERR" "Gitlink FEHLT in Quelle 'index': $P_TOT"
fordere_kein_literal "$OUT" "Paritaet OK"
fall_ende

# =============================================================================
# F7  Am Pfad steht eine NORMALE DATEI statt eines Gitlinks (Modus 100644 statt
#     160000). Genau so sieht es aus, wenn jemand ein Submodul durch einen
#     Platzhalter ersetzt. Die Wache filtert per awk auf 160000 und MUSS das
#     als "fehlt" behandeln -- fail-closed. Ohne diesen Fall waere der
#     Modus-Vergleich ungedeckt und ein '$1 == "160000"' koennte zu '$1 != ""'
#     verwaessern, ohne dass etwas rot wird.
# =============================================================================
SHA_G=$(sha)
fall "F7  normale Datei statt Gitlink (Modus 100644) -> rc=1, fail-closed"
mkrepo f7
mkdir -p "$D/thesis"
printf 'Platzhalter statt Submodul: %s\n' "$(token)" > "$D/$P_LEBEND"
( cd "$D" && git add -A >/dev/null 2>&1 ) || { echo "ABBRUCH: git add im f7-Fixture." >&2; exit 2; }
setze_gitlink "$P_TOT" "$SHA_G"
_modus=$( cd "$D" && git ls-files --stage -- "$P_LEBEND" | awk '{print $1}' )
if [ "$_modus" != "100644" ]; then
    echo "  [ABBRUCH] Fixture untauglich: Modus an '$P_LEBEND' ist '$_modus', erwartet 100644." >&2
    exit 2
fi
echo "        Gegenprobe Fixture: Modus an '$P_LEBEND' ist $_modus, kein Gitlink."
lauf "$D" --quelle index
fordere_rc 1
fordere_literal "$ERR" "Gitlink FEHLT in Quelle 'index': $P_LEBEND"
fordere_kein_literal "$OUT" "Paritaet OK"
fall_ende

# =============================================================================
# F8  --erwartet trifft -> rc=0. Die Nachbedingung des Rueckschriebs in ihrer
#     gutmuetigen Richtung; ohne sie waere nicht belegt, dass --erwartet
#     ueberhaupt jemals gruen sein kann (eine immer-rote Option waere genauso
#     wertlos wie eine immer-gruene).
# =============================================================================
SHA_H=$(sha)
fall "F8  --erwartet trifft den Zeiger -> rc=0"
mkrepo f8
setze_gitlink "$P_LEBEND" "$SHA_H"
setze_gitlink "$P_TOT"    "$SHA_H"
lauf "$D" --quelle index --erwartet "$SHA_H"
fordere_rc 0
fordere_literal "$OUT" "beide Zeiger auf $SHA_H"
fall_ende

# =============================================================================
# F9  --erwartet VERFEHLT -> rc=1, und die Meldung muss IST und SOLL nennen.
#     Das ist die scharfe Nachbedingung in anhang:forward: beide Zeiger stehen
#     gleich, aber auf dem FALSCHEN Commit -- der Rueckschrieb hat dann etwas
#     anderes gebumpt als behauptet. Ohne diesen Fall waere --erwartet reine
#     Dekoration.
# =============================================================================
SHA_I=$(sha); SHA_SOLL=$(sha)
fall "F9  --erwartet verfehlt -> rc=1, Ist und Soll genannt"
mkrepo f9
setze_gitlink "$P_LEBEND" "$SHA_I"
setze_gitlink "$P_TOT"    "$SHA_I"
lauf "$D" --quelle index --erwartet "$SHA_SOLL"
fordere_rc 1
fordere_literal "$ERR" "beide Gitlinks stehen auf $SHA_I,"
fordere_literal "$ERR" "erwartet war aber $SHA_SOLL"
fordere_kein_literal "$OUT" "Paritaet OK"
fall_ende

# =============================================================================
# F10 --quelle mit Unsinn -> rc=2. Kein stiller Rueckfall auf einen der beiden
#     Lesepfade: die Wache liest sonst per else-Zweig den INDEX, waehrend der
#     Aufrufer HEAD gemeint hat -- eine Wache, die etwas anderes prueft als
#     bestellt, ist schlimmer als keine.
# =============================================================================
fall "F10 --quelle mit Unsinn -> rc=2 (kein stiller Rueckfall auf index)"
mkrepo f10
# BEIDE Zeiger auf DENSELBEN SHA -- mit Absicht. Waeren sie verschieden, endete
# ein Mutant ohne diese Pruefung ueber den index-Rueckfall bei rc=1, also immer
# noch "rot", und der Riss saehe harmloser aus, als er ist. So endet er bei rc=0:
# die Wache meldete GRUEN auf eine Quelle, die der Aufrufer nie bestellt hat.
SHA_J=$(sha)
setze_gitlink "$P_LEBEND" "$SHA_J"
setze_gitlink "$P_TOT"    "$SHA_J"
lauf "$D" --quelle "kaese-$(token)"
fordere_rc 2
fordere_literal "$ERR" "--quelle muss 'head' oder 'index' sein"
fordere_kein_literal "$OUT" "Paritaet OK"
fall_ende

# =============================================================================
# F11 Aufruf ausserhalb eines git-Baums -> rc=2, NICHT rc=0 und nicht rc=1.
#     GEGENPROBE VOR DEM FALL: dass das Verzeichnis wirklich ausserhalb jedes
#     Repos liegt, wird gemessen und nicht angenommen -- liegt TMPDIR selbst in
#     einem git-Baum, pruefte dieser Fall etwas ganz anderes und waere still
#     gruen. Das ist Abbruch, kein bestandener Fall.
# =============================================================================
fall "F11 kein git-Repository -> rc=2"
mkdir -p "$WERK/keinrepo"
_gd=$( cd "$WERK/keinrepo" && git rev-parse --git-dir 2>/dev/null || true )
if [ -n "$_gd" ]; then
    echo "  [ABBRUCH] Gegenprobe fehlgeschlagen: '$WERK/keinrepo' liegt im git-Baum '$_gd'." >&2
    exit 2
fi
echo "        Gegenprobe: 'git rev-parse --git-dir' liefert dort leer -- kein Repo."
lauf "$WERK/keinrepo" --quelle index
fordere_rc 2
fordere_literal "$ERR" "kein git-Repository"
fall_ende

# =============================================================================
# F12 BEDIENFEHLER enden mit 2, nicht mit 0. Ein Tippfehler im CI-Aufruf darf
#     nie als bestandene Pruefung durchgehen -- genau so verschwindet eine
#     Wache unbemerkt aus einer Pipeline. --hilfe dagegen MUSS 0 liefern, sonst
#     waere die Hilfe selbst ein Fehlschlag.
# =============================================================================
fall "F12 --quelle/--erwartet ohne Wert und unbekannte Option -> rc=2, --hilfe -> rc=0"
mkrepo f12
setze_gitlink "$P_LEBEND" "$(sha)"
setze_gitlink "$P_TOT"    "$(sha)"
lauf "$D" --quelle
fordere_rc 2
fordere_literal "$ERR" "--quelle ohne Wert"
lauf "$D" --erwartet
fordere_rc 2
fordere_literal "$ERR" "--erwartet ohne Wert"
lauf "$D" "--nicht-existent-$(token)"
fordere_rc 2
fordere_literal "$ERR" "unbekannte Option"
lauf "$D" --hilfe
fordere_rc 0
fordere_literal "$ERR" "Aufruf: ci/thesis_gitlink_parity.sh"
fall_ende

# =============================================================================
# F13 REGISTRIERUNG IST TEIL DES TESTS (T-7): die Wache muss in .gitlab-ci.yml
#     gerufen werden UND diese Probe ebenfalls, und ihr Job darf KEIN
#     allow_failure tragen. Ein Test, der in keinem Job faehrt, ist nicht
#     gebaut. ZUERST DER KOEDER -- /usr/bin/grep ist hier ugrep; eine Zahl ohne
#     beissenden Koeder ist keine Aussage, sondern ein moegliches
#     Werkzeug-Versagen. Der Koeder wird gewuerfelt (K13), nie abgeschrieben.
# =============================================================================
fall "F13 Registrierung von Wache und Probe in .gitlab-ci.yml, ohne allow_failure"
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
    printf '    - ci/thesis_gitlink_parity.sh --quelle head   # koeder-%s-%s\n' "$KTOK" "$_i" >> "$KOEDER"
    printf '      allow_failure: true   # koeder-%s-%s\n' "$KTOK" "$_i" >> "$KOEDER"
    _i=$((_i + 1))
done
printf '    - harmlose Zeile ohne Muster\n' >> "$KOEDER"
K_IST=$(grep -cF -- 'ci/thesis_gitlink_parity.sh' "$KOEDER" || true)
K_AF=$(grep -cF -- 'allow_failure' "$KOEDER" || true)
if [ "$K_IST" != "$K" ] || [ "$K_AF" != "$K" ]; then
    echo "  [ABBRUCH] Koeder biss NICHT: $K geschrieben, grep -cF meldet $K_IST / $K_AF." >&2
    echo "            Ohne beissenden Koeder ist jede Zahl an .gitlab-ci.yml wertlos." >&2
    exit 2
fi
echo "        Koeder beisst: $K gewuerfelte Vorkommen je Muster geschrieben, $K_IST / $K_AF gefunden."
N_WACHE=$(grep -cF -- 'ci/thesis_gitlink_parity.sh' "$CI_YML" || true)
if [ "$N_WACHE" = "0" ]; then
    reiss "kein Aufruf der Wache in .gitlab-ci.yml -- sie liefe in keinem Job (T-7)"
else
    echo "        .gitlab-ci.yml: $N_WACHE Nennung(en) der Wache (Nenner: $(awk 'END{print NR}' "$CI_YML") Zeilen)."
fi
AUFRUF='ci/tests/thesis_gitlink_parity_probe.sh --selbstbiss'
N_AUFRUF=$(grep -cF -- "$AUFRUF" "$CI_YML" || true)
if [ "$N_AUFRUF" = "0" ]; then
    reiss "kein Aufruf von '$AUFRUF' in .gitlab-ci.yml -- die Probe waere unregistriert"
else
    echo "        $N_AUFRUF Aufruf(e) der Probe in .gitlab-ci.yml."
fi
JOB='test:thesis-gitlink-probe:'
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
# =============================================================================
[ "$MODUS" = "--selbstbiss" ] || exit 0

echo ""
echo "============================================================================="
echo "SELBSTBISS: Wegwerf-Mutanten der Wache -- die Probe MUSS an ihnen rot werden."
echo "============================================================================="

ORIG_ZEILEN=$(awk 'END{print NR}' "$WACHE")
ORIG_E1=$(awk '/^[[:space:]]*exit 1$/{n++} END{print n+0}' "$WACHE")
echo "  Wache: $ORIG_ZEILEN Zeilen, davon $ORIG_E1 freistehende 'exit 1'."
if [ "$ORIG_E1" -ne 3 ]; then
    echo "  ABBRUCH: erwartet waren 3 freistehende 'exit 1', gefunden $ORIG_E1." >&2
    echo "           Die Wache hat sich strukturell geaendert -- die Mutation waere" >&2
    echo "           geraten statt gezielt. Kein Gruen darauf." >&2
    exit 2
fi

# Die Mutanten werden ueber den TEXT ihres Zweiges gewaehlt, nicht ueber eine
# Zeilennummer: Zeilenanker verrutschen bei jeder Bearbeitung der Wache und
# wuerden dann lautlos den falschen Zweig treffen.
mut_exit1_nach() {    # $1 = Zieldatei, $2 = Markertext
    awk -v marker="$2" '
        BEGIN { gesehen = 0; weg = 0 }
        {
            if (!gesehen && index($0, marker) > 0) { gesehen = 1; print; next }
            if (gesehen && !weg && $0 ~ "^[[:space:]]*exit 1$") { weg = 1; next }
            print
        }
        END { if (!gesehen || !weg) exit 3 }
    ' "$WACHE" > "$1"
}
mut_inline() {        # $1 = Zieldatei, $2 = Markertext -- 'exit 2' auf DIESER
    awk -v marker="$2" '                                  # Zeile entschaerfen
        BEGIN { getroffen = 0 }
        {
            if (index($0, marker) > 0 && index($0, "exit 2") > 0) {
                gsub(/exit 2/, ":"); getroffen = 1
            }
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
    if [ "$2" = "inline" ]; then mut_inline "$_m" "$3"; else mut_exit1_nach "$_m" "$3"; fi
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
    # Eine Zeilendifferenz von 0 (inline-Mutation) belegt fuer sich NICHTS --
    # deshalb wird dort zusaetzlich verlangt, dass sich der Text ueberhaupt
    # geaendert hat. Ohne das waere ein ins Leere laufender Ausdruck unauffaellig.
    if cmp -s "$WACHE" "$_m"; then
        echo "  [ABBRUCH] Mutation '$1' hat NICHTS geaendert -- der Beweis waere leer." >&2
        exit 2
    fi
    if sh -n "$_m" 2>/dev/null; then :; else
        echo "  [ABBRUCH] Mutant '$1' ist syntaktisch kaputt -- er wuerde aus dem" >&2
        echo "            falschen Grund sterben und nichts beweisen." >&2
        exit 2
    fi
    chmod +x "$_m"
    echo ""
    echo "  --- Mutant '$1' ($ORIG_ZEILEN -> $_mz Zeilen, Differenz $_diff, sh -n sauber) ---"
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
selbstbiss_fall "M1  ohne 'exit 1' im FEHLT-Zweig      (toetet NUR F6, 1->0)" \
                exit1 "fail-closed: ein fehlender Gitlink-Pfad" 1
selbstbiss_fall "M2  ohne 'exit 1' im DIVERGENZ-Zweig  (toetet F3,     1->0)" \
                exit1 "beide Zeiger IMMER GEMEINSAM setzen" 1
selbstbiss_fall "M3  ohne 'exit 1' im ERWARTET-Zweig   (toetet F9,     1->0)" \
                exit1 "erwartet war aber" 1
selbstbiss_fall "M4  --quelle-Pruefung entschaerft     (toetet F10,    2->0)" \
                inline "quelle muss 'head' oder 'index' sein" 0
selbstbiss_fall "M5  Repo-Pruefung entschaerft         (toetet F11,    2->1)" \
                inline "kein git-Repository" 0

echo ""
echo "============================================================================="
echo "NENNER SELBSTBISS: $N_MUT Mutanten gefahren, $N_MUT_GEBISSEN gefangen."
echo "  NICHT mutiert, weil ohne Selbstbeschaedigung der Probe nicht ausloesbar:"
echo "    - 'git nicht gefunden' und 'awk nicht gefunden' -- ein PATH ohne git"
echo "      nimmt der Probe zugleich das Werkzeug, mit dem sie ihre Fixtures baut."
echo "============================================================================="
if [ "$N_MUT_GEBISSEN" -ne "$N_MUT" ]; then
    echo "SELBSTBISS ROT: $((N_MUT - N_MUT_GEBISSEN)) von $N_MUT Mutanten ueberleben." >&2
    exit 1
fi
echo "SELBSTBISS GRUEN: alle $N_MUT Mutanten gefangen -- die Probe beisst."
exit 0
