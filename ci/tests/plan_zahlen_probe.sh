#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  BISSPROBE fuer die PLAN-ZAHLEN-WACHE   (ci/plan_zahlen_wache.sh)
#  -- eine Wache ueber Zahlen, deren eigene Zahl niemand nachrechnet, ist nur
#     eine weitere Zahl ohne Nenner.                              (2026-08-08)
# =============================================================================
#
# DER BEFUND, GEGEN DEN SIE GEBAUT IST:
# Die Plan-Zahlen-Wache vergleicht Anker im TDD-Designplan mit Messungen am
# Code. Sie kann auf zwei Arten wertlos werden, und beide sind an genau diesem
# Tag real vorgekommen:
#   (a) Sie zaehlt nicht wirklich, sondern druckt aus, was im Plan steht -- dann
#       ist sie immer gruen. Das ist die Klasse "selbstreferenzielles Orakel",
#       die der Plan selbst auf 10 Posten fuehrt.
#   (b) Ihr Suchmuster findet nichts, weil das Werkzeug nicht sucht -- die
#       stille Null. Am 08.08. literal gemessen: `grep -c 'test -n "$(find'`
#       meldet auf einer Datei mit 5 echten Vorkommen eine 0 mit rc=1, waehrend
#       `grep -cF` korrekt 5 mit rc=0 meldet.
# Gegen (a) hilft nur ein Objekt mit BEKANNTER, aber nicht abgeschriebener Zahl;
# gegen (b) nur ein Koeder, der nachweislich beisst, BEVOR eine Null gilt.
#
# BEIDE RICHTUNGEN, und der Positiv-Fall ist der NENNER:
# Fall N faehrt die Wache gegen den echten Plan und das echte Objekt und
# verlangt Gruen. Ohne ihn beweist kein einziger Koeder etwas -- eine Wache, die
# IMMER rot ist, faellt an jedem Koeder und taugt trotzdem nichts.
#
# DER SCHAERFSTE FALL IST K7/K8: die Probe baut sich ein WEGWERF-ce-Repo mit
# einer GEWUERFELTEN Zahl von Test-Dateien und Aufruf-Stellen (samt Kommentar-
# zeilen, die NICHT mitzaehlen duerfen), schreibt genau diese gewuerfelten Zahlen
# in einen Plan-Klon und verlangt Gruen (K7); danach verschiebt sie EINE Zahl um
# +/-1 und verlangt Rot (K8). Eine Wache, die die Plan-Zahl nur zurueckspiegelt,
# ist in K8 gruen und faellt hier auf. Die Zahlen wechseln bei jedem Lauf; das
# ist Absicht (K13: der Koeder wird erzeugt, nie abgeschrieben).
#
# AUFRUF:
#   sh ci/tests/plan_zahlen_probe.sh
#
# ENV:
#   COMDARE_WACHE      Pfad zur zu pruefenden Wache (Default: ../plan_zahlen_wache.sh).
#   COMDARE_CE_QUELLE  wird an die Wache durchgereicht (lokaler Notfall, wenn das
#                      Submodul den Gitlink-SHA nicht fuehrt).
#
# EXIT: 0 = alle Faelle gehalten
#       1 = mindestens ein Fall gerissen (Zahl + literale Ausgabe im Protokoll)
#       2 = die Probe konnte nicht pruefen (Wache fehlt, Koeder biss nicht,
#           Wegwerf-Repo nicht baubar) -- ausdruecklich KEIN Gruen.
#
# TESTKRITIK (T-9), was diese Probe NICHT deckt:
#   - Sie prueft die Wache, nicht die Richtigkeit der Fussnoten-PROSA. Ob die
#     Zaehlweise im Plan die sinnvolle ist, entscheidet ein Mensch.
#   - K7/K8 fahren ein synthetisches ce-Repo. Dass die Wache am ECHTEN ce-Baum
#     dieselbe Zahl liefert, deckt Fall N -- aber nur fuer den heutigen Bestand.
#   - Die Kommentar-Erkennung wird nur zeilenweise geprueft; ein Aufruf in einem
#     mehrzeiligen /* ... */-Block bleibt ungedeckt (steht so in der Wache).
#   - Sie prueft nicht, ob der Plan-Anker semantisch zur Fussnote passt: wer
#     Anker und Fussnote GEMEINSAM faelscht, kommt durch. Dagegen hilft nur der
#     Codex-Pass der Folgewelle (T-9).
#
# POSIX-sh (die CI ruft `sh`, das ist hier dash), ASCII-only, kein Python.
# =============================================================================

set -eu

SELBST_DIR=$(cd "$(dirname "$0")" && pwd)
REPO=$(cd "$SELBST_DIR/../.." && pwd)
WACHE="${COMDARE_WACHE:-$REPO/ci/plan_zahlen_wache.sh}"
PLAN_ECHT="$REPO/docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md"
CI_ECHT="$REPO/.gitlab-ci.yml"

if [ ! -f "$WACHE" ]; then
    echo "ABBRUCH: Wache '$WACHE' nicht gefunden -- die Probe konnte nicht pruefen." >&2
    exit 2
fi
if [ ! -f "$PLAN_ECHT" ] || [ ! -f "$CI_ECHT" ]; then
    echo "ABBRUCH: Plan oder .gitlab-ci.yml fehlt -- die Probe konnte nicht pruefen." >&2
    exit 2
fi

WERK=$(mktemp -d) || exit 2
trap 'rm -rf "$WERK"' EXIT INT TERM
OUT="$WERK/_out"; ERR="$WERK/_err"; BEIDE="$WERK/_beide"

N_FALL=0; N_OK=0; N_ROT=0; RC=0

# --- Wuerfel (K13): der Koeder wird erzeugt, nie abgeschrieben ----------------
# od statt `tr < /dev/urandom | head -c`: kein SIGPIPE, kein rc-Ratespiel.
token() { od -An -tx1 -N8 /dev/urandom | tr -d ' \n'; }
wuerfel() {
    _lo="$1"; _hi="$2"; _spanne=$((_hi - _lo + 1))
    _roh=$(od -An -tu1 -N1 /dev/urandom | tr -d ' \n')
    echo $(( _lo + (_roh % _spanne) ))
}

TRENNER='-----------------------------------------------------------------------------'
fall()      { N_FALL=$((N_FALL + 1)); echo "$TRENNER"; echo "FALL $N_FALL: $1"; }
fall_ende() { echo ""; }
reiss()     { N_ROT=$((N_ROT + 1)); RC=1; echo "  [RISS] $1" >&2; }
halt()      { N_OK=$((N_OK + 1)); echo "  [OK]   $1"; }

lauf() {                       # $1 = plan, $2 = ci-yml, weitere: env-Zuweisungen
    _plan="$1"; _ci="$2"; shift 2
    set +e
    env COMDARE_PLAN="$_plan" COMDARE_CI_YML="$_ci" \
        COMDARE_CE_QUELLE="${COMDARE_CE_QUELLE:-}" "$@" \
        sh "$WACHE" > "$OUT" 2> "$ERR"
    LAUF_RC=$?
    set -e
    cat "$OUT" "$ERR" > "$BEIDE"
}

fordere_rc() {
    if [ "$LAUF_RC" = "$1" ]; then
        halt "rc=$LAUF_RC wie gefordert"
    else
        reiss "rc=$LAUF_RC, gefordert war $1"
        sed 's/^/        | /' "$BEIDE" | head -25 >&2
    fi
}

fordere_literal() {            # $1 = erwarteter Text (literal, -F)
    if /usr/bin/grep -q -F -- "$1" "$BEIDE"; then
        halt "Ausgabe enthaelt literal: $1"
    else
        reiss "Ausgabe enthaelt NICHT: $1"
        sed 's/^/        | /' "$BEIDE" | head -25 >&2
    fi
}

# --- Plan-Klon mit veraenderbaren Ankern -------------------------------------
plan_klon() {                  # $1 = ziel, $2 = anker-name, $3 = neuer wert
    awk -v n="PZW-$2" -v w="$3" '
        $1 == n && $2 == "=" { printf "%-18s = %s\n", n, w; next }
        { print }
    ' "$PLAN_ECHT" > "$1"
}

anker_lesen() {                # $1 = anker-name -> wert aus dem ECHTEN Plan
    awk -v n="PZW-$1" '$1 == n && $2 == "=" { print $3; exit }' "$PLAN_ECHT"
}

# =============================================================================
# N  DER NENNER: die Wache gegen das echte Objekt. Ohne Gruen hier beweist kein
#    Koeder etwas -- eine immer rote Wache faellt an jedem Koeder.
# =============================================================================
fall "N  Positiv-Fall (NENNER): echter Plan gegen echtes Objekt"
lauf "$PLAN_ECHT" "$CI_ECHT"
fordere_rc 0
fordere_literal "5 von 5 Ankern"
SHA_ECHT=$(anker_lesen CE-SHA)
fordere_literal "$SHA_ECHT"
fall_ende

# =============================================================================
# K1 EINE ANKER-ZAHL VERWUERFELT. Der Anker wird zufaellig gezogen, der falsche
#    Wert gewuerfelt -- damit ist ausgeschlossen, dass die Probe eine bestimmte
#    Stelle "kennt" und die Wache nur dort prueft.
# =============================================================================
NAMEN='SCHEMA-STELLEN SCHEMA-DATEIEN SCHEMA-LITERAL CI-AUFRUFE CI-ALTMUSTER'
IDX=$(wuerfel 1 5)
ZIEL=$(echo "$NAMEN" | cut -d' ' -f"$IDX")
ECHT=$(anker_lesen "$ZIEL")
FALSCH=$((ECHT + $(wuerfel 1 90)))
fall "K1 Anker '$ZIEL' auf gewuerfelten Falschwert $FALSCH gesetzt (echt: $ECHT)"
plan_klon "$WERK/plan_k1.md" "$ZIEL" "$FALSCH"
lauf "$WERK/plan_k1.md" "$CI_ECHT"
fordere_rc 1
fordere_literal "Plan sagt $FALSCH, Objekt liefert $ECHT"
fall_ende

# =============================================================================
# K2 ALTMUSTER EINGESCHLEUST. Zuerst muss der Koeder BEISSEN: die Probe schreibt
#    eine gewuerfelte Zahl echter Vorkommen und verlangt, dass die Wache GENAU
#    diese Zahl meldet. Erst danach ist die Null am echten .gitlab-ci.yml eine
#    Aussage und nicht ein moegliches Werkzeug-Versagen (`$(` ohne -F).
# =============================================================================
K=$(wuerfel 1 4)
fall "K2 $K gewuerfelte Altmuster-Zeilen in eine .gitlab-ci.yml-Kopie geschleust"
cp "$CI_ECHT" "$WERK/ci_k2.yml"
_i=1
while [ "$_i" -le "$K" ]; do
    printf '      test -n "$(find measure_out_%s -name %s | head -1)" || exit 1\n' \
           "$(token)" "'measurements.csv'" >> "$WERK/ci_k2.yml"
    _i=$((_i + 1))
done
lauf "$PLAN_ECHT" "$WERK/ci_k2.yml"
fordere_rc 1
fordere_literal "CI-ALTMUSTER   : Plan sagt 0, Objekt liefert $K"
fall_ende

# =============================================================================
# K3 DIE AUFRUFE DER MESS-AUSBEUTE-WACHE ENTFERNT. Das ist der Rueckbau, gegen
#    den D3-2 gebaut ist: wer die beiden Zeilen still herausnimmt, hat wieder
#    ein Gate, das nur die Anwesenheit einer Datei prueft.
# =============================================================================
fall "K3 beide Ausfuehrungszeilen der Mess-Ausbeute-Wache aus der Kopie entfernt"
/usr/bin/grep -v -F 'sh ../ci/mess_ausbeute_wache.sh' "$CI_ECHT" > "$WERK/ci_k3.yml" || true
VORHER=$(/usr/bin/grep -c -F 'sh ../ci/mess_ausbeute_wache.sh' "$CI_ECHT" || true)
NACHHER=$(/usr/bin/grep -c -F 'sh ../ci/mess_ausbeute_wache.sh' "$WERK/ci_k3.yml" || true)
if [ "$VORHER" = "0" ] || [ "$NACHHER" != "0" ]; then
    echo "  [ABBRUCH] Koeder biss nicht: vorher=$VORHER nachher=$NACHHER (erwartet: >0 und 0)." >&2
    exit 2
fi
echo "        Koeder beisst: $VORHER Ausfuehrungszeilen entfernt, $NACHHER uebrig."
lauf "$PLAN_ECHT" "$WERK/ci_k3.yml"
fordere_rc 1
fordere_literal "CI-AUFRUFE     : Plan sagt $VORHER, Objekt liefert 0"
fall_ende

# =============================================================================
# K4 ZEITRICHTUNG: der Plan nennt einen anderen ce-Zustand als HEAD fuehrt.
#    Das ist die Falle, die beim Bau dieser Wache zuerst zuschlug (Submodul-
#    Arbeitskopie auf a1d0c201, Gitlink 25fe4fbf) -- sie MUSS abbrechen, nicht
#    "irgendwo" messen.
# =============================================================================
SHA_FALSCH=$(token)$(token)$(token)$(token)$(token)
SHA_FALSCH=$(printf '%s' "$SHA_FALSCH" | cut -c1-40)
fall "K4 Plan nennt ce-SHA $SHA_FALSCH, HEAD fuehrt $SHA_ECHT"
plan_klon "$WERK/plan_k4.md" CE-SHA "$SHA_FALSCH"
lauf "$WERK/plan_k4.md" "$CI_ECHT"
fordere_rc 2
fordere_literal "einen ANDEREN ce-Zustand"
fall_ende

# =============================================================================
# K5 KEIN LESBARER ce-BAUM: die Wache darf dann NICHT gruen sagen. "Nicht
#    gefunden" ist kein "in Ordnung" -- genau der Satz, der heute an D3-1/D3-2
#    zum Fehlbefund fuehrte.
# =============================================================================
fall "K5 Gitlink zeigt auf einen Commit, den kein Klon fuehrt"
plan_klon "$WERK/plan_k5.md" CE-SHA "$SHA_FALSCH"
set +e
env COMDARE_PLAN="$WERK/plan_k5.md" COMDARE_CI_YML="$CI_ECHT" \
    COMDARE_GITLINK_SHA="$SHA_FALSCH" COMDARE_CE_QUELLE="" \
    sh "$WACHE" > "$OUT" 2> "$ERR"
LAUF_RC=$?
set -e
cat "$OUT" "$ERR" > "$BEIDE"
fordere_rc 2
fordere_literal "KEIN Gruen ohne Messung"
fall_ende

# =============================================================================
# K6 ANKER ENTFERNT: ohne SOLL kein Gruen. Der haeufigste stille Rueckbau an
#    einer Doku-Wache ist nicht die falsche Zahl, sondern die geloeschte Zeile.
# =============================================================================
fall "K6 Anker-Block aus dem Plan entfernt"
/usr/bin/grep -v -F 'PZW-' "$PLAN_ECHT" > "$WERK/plan_k6.md" || true
lauf "$WERK/plan_k6.md" "$CI_ECHT"
fordere_rc 2
fordere_literal "Ohne Anker gibt es kein SOLL"
fall_ende

# =============================================================================
# K7 DIE WACHE MUSS ZAEHLEN, NICHT SPIEGELN. Wegwerf-ce-Repo mit gewuerfelter
#    Datei- und Stellenzahl; zusaetzlich Kommentarzeilen mit demselben Aufruf,
#    die NICHT mitzaehlen duerfen, und eine Datei mit dem Voll-Header-Literal.
# =============================================================================
D=$(wuerfel 2 5)               # Test-Dateien mit Aufruf
S=$(wuerfel 1 3)               # Code-Aufrufe je Datei
KOM=$(wuerfel 1 2)             # Kommentar-Aufrufe je Datei (duerfen nicht zaehlen)
SOLL_STELLEN=$((D * S))
SOLL_DATEIEN=$D

FAKE="$WERK/fake_ce"
mkdir -p "$FAKE/tests/unit"
git -C "$FAKE" init -q 2>/dev/null || { echo "  [ABBRUCH] git init im Wegwerf-Repo scheiterte." >&2; exit 2; }
_d=1
while [ "$_d" -le "$D" ]; do
    F="$FAKE/tests/unit/test_wegwerf_${_d}_$(token).cpp"
    {
        echo "// Wegwerf-Pruefling der Bissprobe -- $(token)"
        _k=1; while [ "$_k" -le "$KOM" ]; do
            echo "// hier steht lazy_csv_header() nur im Kommentar"
            _k=$((_k + 1))
        done
        _s=1; while [ "$_s" -le "$S" ]; do
            echo "    auto h${_s} = ex::lazy_csv_header();"
            _s=$((_s + 1))
        done
    } > "$F"
    _d=$((_d + 1))
done
# genau EINE Datei mit dem Voll-Header-Literal, wie im echten Bestand
echo 'const char* alt = "binary_id;setting;repetition;n_ops";' > "$FAKE/tests/unit/test_wegwerf_literal.cpp"
# und eine Datei OHNE alles, damit der Nenner groesser ist als der Zaehler
echo 'int leer() { return 0; }' > "$FAKE/tests/unit/test_wegwerf_leer.cpp"
git -C "$FAKE" add -A >/dev/null 2>&1
git -C "$FAKE" -c user.email=probe@invalid -c user.name=Probe commit -q -m "wegwerf" >/dev/null 2>&1 \
    || { echo "  [ABBRUCH] commit im Wegwerf-Repo scheiterte." >&2; exit 2; }
FAKE_SHA=$(git -C "$FAKE" rev-parse HEAD)

fall "K7 Wegwerf-ce: $SOLL_STELLEN gewuerfelte Aufruf-Stellen in $SOLL_DATEIEN Dateien (+ je $KOM Kommentar-Aufrufe)"
plan_klon "$WERK/p7a.md" CE-SHA "$FAKE_SHA"
awk -v a="$SOLL_STELLEN" -v b="$SOLL_DATEIEN" '
    $1 == "PZW-SCHEMA-STELLEN" && $2 == "=" { printf "%-18s = %s\n", $1, a; next }
    $1 == "PZW-SCHEMA-DATEIEN" && $2 == "=" { printf "%-18s = %s\n", $1, b; next }
    { print }
' "$WERK/p7a.md" > "$WERK/plan_k7.md"
set +e
env COMDARE_PLAN="$WERK/plan_k7.md" COMDARE_CI_YML="$CI_ECHT" \
    COMDARE_GITLINK_SHA="$FAKE_SHA" COMDARE_CE_QUELLE="$FAKE" \
    sh "$WACHE" > "$OUT" 2> "$ERR"
LAUF_RC=$?
set -e
cat "$OUT" "$ERR" > "$BEIDE"
fordere_rc 0
fordere_literal "SCHEMA-STELLEN : Plan sagt $SOLL_STELLEN, Objekt liefert $SOLL_STELLEN"
fordere_literal "SCHEMA-DATEIEN : Plan sagt $SOLL_DATEIEN, Objekt liefert $SOLL_DATEIEN"
fall_ende

# =============================================================================
# K8 DIESELBE LAGE, EINE ZAHL UM 1 VERSCHOBEN. Eine Wache, die die Plan-Zahl nur
#    zurueckspiegelt, ist hier gruen -- und damit entlarvt.
# =============================================================================
SCHIEF=$((SOLL_STELLEN + 1))
fall "K8 dieselbe Wegwerf-Lage, Anker um +1 verschoben ($SCHIEF statt $SOLL_STELLEN)"
awk -v a="$SCHIEF" '
    $1 == "PZW-SCHEMA-STELLEN" && $2 == "=" { printf "%-18s = %s\n", $1, a; next }
    { print }
' "$WERK/plan_k7.md" > "$WERK/plan_k8.md"
set +e
env COMDARE_PLAN="$WERK/plan_k8.md" COMDARE_CI_YML="$CI_ECHT" \
    COMDARE_GITLINK_SHA="$FAKE_SHA" COMDARE_CE_QUELLE="$FAKE" \
    sh "$WACHE" > "$OUT" 2> "$ERR"
LAUF_RC=$?
set -e
cat "$OUT" "$ERR" > "$BEIDE"
fordere_rc 1
fordere_literal "Plan sagt $SCHIEF, Objekt liefert $SOLL_STELLEN"
fall_ende

# =============================================================================
# K9 REGISTRIERUNG IST TEIL DES TESTS (T-7): Wache und Probe muessen in
#    .gitlab-ci.yml gerufen werden, und ihr Job darf kein allow_failure tragen.
#    Der Treffer ist zugleich der zweite Koeder-Beweis: er zeigt, dass die
#    literale Suche in DIESER Datei ueberhaupt findet.
# =============================================================================
fall "K9 eigene Registrierung in .gitlab-ci.yml, ohne allow_failure"
A_WACHE=$(/usr/bin/grep -c -F 'ci/plan_zahlen_wache.sh' "$CI_ECHT" || true)
A_PROBE=$(/usr/bin/grep -c -F 'ci/tests/plan_zahlen_probe.sh' "$CI_ECHT" || true)
echo "        Nenner: $(awk 'END{print NR}' "$CI_ECHT") Zeilen in .gitlab-ci.yml."
if [ "$A_PROBE" -lt 1 ]; then
    reiss "diese Probe wird in .gitlab-ci.yml nicht gerufen ($A_PROBE Treffer) -- ein nie gelaufener Test ist keiner"
else
    halt "Probe wird gerufen ($A_PROBE Treffer), Wache erwaehnt ($A_WACHE Treffer)"
fi
# Der Job endet bei der ersten Zeile, die NICHT eingerueckt und nicht leer ist.
# Nur den naechsten Job-Schluessel als Ende zu nehmen war falsch: der Kommentar-
# block DAVOR gehoerte dann noch zum Job, und das Wort "allow_failure" in seiner
# Begruendung ("WARUM KEIN allow_failure") loeste einen Fehlalarm aus -- ein
# Werkzeug, das seine eigene Begruendung fuer einen Befund haelt.
JOB_ALLOW=$(awk '
    /^docs:plan-zahlen-wache:/ { in_job = 1; next }
    in_job && /^[^ ]/ && NF > 0 { in_job = 0 }
    in_job && /allow_failure/ { n++ }
    END { print n+0 }
' "$CI_ECHT")
if [ "$JOB_ALLOW" -gt 0 ]; then
    reiss "der Job docs:plan-zahlen-wache traegt allow_failure ($JOB_ALLOW Zeilen) -- das ist die naechste stille Null"
else
    halt "kein allow_failure im Job docs:plan-zahlen-wache"
fi
fall_ende

# =============================================================================
echo "-----------------------------------------------------------------------------"
echo "NENNER (nie eine nackte Null):"
echo "  $N_FALL Faelle gefahren, $N_OK Zusicherungen gehalten, $N_ROT gerissen."
echo "  Gewuerfelt in diesem Lauf: Anker='$ZIEL' Falschwert=$FALSCH, Altmuster=$K,"
echo "  Wegwerf-ce=$SOLL_STELLEN Stellen in $SOLL_DATEIEN Dateien (+ $KOM Kommentar-Aufrufe je Datei)."
echo "-----------------------------------------------------------------------------"
if [ "$RC" != "0" ]; then
    echo "FEHLER: $N_ROT Zusicherung(en) gerissen." >&2
    exit 1
fi
echo "PLAN-ZAHLEN-PROBE: OK ($N_FALL Faelle, $N_OK Zusicherungen, beide Richtungen gefahren)."
exit 0
