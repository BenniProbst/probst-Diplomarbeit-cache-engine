#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  REGISTRIERUNGS-WACHE ueber ci/tests/*.sh gegen .gitlab-ci.yml   (2026-08-09)
#  -- die zweite, UNABHAENGIGE Antwort auf eine Zirkularitaet.
# =============================================================================
#
# DIE ZIRKULARITAET, GEGEN DIE SIE GEBAUT IST:
#   Jede Probe dieses Repos prueft ihre eigene Registrierung selbst (Fall A7 der
#   anhang-forward-Probe, Fall F11 der mess-ausbeute-Bissprobe, ...). Das faengt
#   den Fall "Probe gebaut, Job vergessen". Es faengt NICHT den Fall, gegen den
#   T-7 eigentlich gerichtet ist:
#     WIRD DER JOB-BLOCK GELOESCHT, LAEUFT DIE PROBE NICHT MEHR -- UND KANN IHRE
#     EIGENE ABWESENHEIT NICHT MEHR MELDEN.
#   Eine Wache, die nur aus dem Objekt heraus spricht, das sie bewacht, ist bei
#   dessen Entfernung stumm. Genau diese Fehlerklasse -- rc=0 und eine Ausgabe,
#   die wie ein ehrliches "nichts zu tun" aussieht -- ist die des ganzen Pakets.
#
# WIE SIE SIE VERKLEINERT (und wo der Rest bleibt -- ehrlich benannt):
#   Diese Wache spricht von AUSSEN: sie liest den Datei-Bestand unter ci/tests/
#   und die .gitlab-ci.yml und vergleicht beide. Wird der Job-Block einer Probe
#   geloescht, wird SIE rot, nicht die verschwundene Probe.
#   Ihr eigener Job koennte natuerlich ebenso geloescht werden. Deshalb fordert
#   Regel R2, dass SIE SELBST aus MINDESTENS ZWEI VERSCHIEDENEN Job-Bloecken
#   gerufen wird. Faellt einer weg, meldet der andere es (Selbstbiss M3 misst
#   genau diesen Eingang). Was NICHT gedeckt bleibt: werden BEIDE Aufrufstellen
#   im selben Commit entfernt, ist auch sie stumm. Das ist die irreduzible
#   Restzirkularitaet -- sie ist dann aber ein sichtbarer, absichtlicher Griff
#   in genau die Datei, die der Diff zeigt, und keine stille Null mehr.
#
# DIE REGELN, alle mit Nenner:
#   R1  Jede Datei $TESTS_PREFIX/<name>.sh hat MINDESTENS EINE Aufrufstelle
#       'sh $TESTS_PREFIX/<name>.sh' in der .gitlab-ci.yml.
#   R2  Diese Wache selbst wird aus MINDESTENS ZWEI VERSCHIEDENEN Job-Bloecken
#       gerufen. Gezaehlt werden BLOECKE, nicht Zeilen: zwei Aufrufe in EINEM
#       Job ueberleben dessen Loeschung nicht und waeren keine Unabhaengigkeit.
#   R3  Der Bestand ist nicht leer. Eine leere Liste erfuellt R1 zwangslaeufig;
#       eine Null ohne Nenner ist von einem echten Freispruch nicht zu
#       unterscheiden. Leerer Bestand => rc=2, ausdruecklich KEIN Gruen.
#
# WARUM 'sh <pfad>' UND NICHT NUR <pfad>:
#   Der blosse Pfad steht auch in Kommentaren und in Begruendungstexten. Eine
#   Registrierung ist ein AUFRUF. Am Objekt nachgemessen (09.08.2026):
#   ci/tests/persist_sammler_probe.sh kommt zweimal in der Datei vor, aber nur
#   EINMAL als Aufruf -- das zweite Vorkommen ist Prosa. Wer Vorkommen zaehlt
#   statt Aufrufe, zaehlt Kommentare als Deckung.
#
# WAS SIE NICHT PRUEFT -- ausdruecklich, damit niemand mehr hineinliest:
#   * ob der Job JEMALS LAEUFT. Ein Job hinter 'rules: when: never' oder hinter
#     einer nie gesetzten Variablen ist registriert und faehrt trotzdem nie.
#     Das ist eine andere Wache; sie braeuchte die Regel-Auswertung von GitLab.
#   * ob 'allow_failure: true' danebensteht. Eine advisory Probe ist die
#     naechste stille Null -- geprueft wird das heute je Probe im eigenen Fall
#     (mess-ausbeute F11, plan-zahlen K9), nicht hier.
#   * ob die Probe INHALTLICH etwas taugt. Registrierung ist Anwesenheit.
#
# AUFRUF:
#   sh ci/tests_registrierung_wache.sh              # nur die Regeln
#   sh ci/tests_registrierung_wache.sh --selbstbiss # Regeln + Mutationsbeweis
#
# ENV (nur fuer den Selbstbiss; im CI-Betrieb steht alles auf Default):
#   COMDARE_CI_YML       geprueftes YAML        (Default: <repo>/.gitlab-ci.yml)
#   COMDARE_TESTS_DIR    Bestands-Verzeichnis   (Default: <repo>/ci/tests)
#   COMDARE_TESTS_PREFIX repo-relatives Praefix (Default: ci/tests)
#   COMDARE_WACHE_PFAD   eigener Pfad fuer R2   (Default: ci/tests_registrierung_wache.sh)
#
# EXIT: 0 = alle Regeln gehalten
#       1 = mindestens eine Registrierung fehlt (Zahlen + Nenner im Protokoll)
#       2 = konnte nicht pruefen (YAML fehlt, Bestand leer, Koeder biss nicht)
#
# POSIX-sh (die CI ruft 'sh', das ist hier dash), ASCII-only, kein Python.
# Selbstcheck: die Wache prueft ihre EIGENE Registrierung mit (R2) und faellt
# ueber sie, wenn eine der beiden Aufrufstellen verschwindet -- sonst waere sie
# die naechste Wache, deren Abwesenheit niemand meldet.
# =============================================================================

set -eu

SELBST_DIR=$(cd "$(dirname "$0")" && pwd)
REPO=$(cd "$SELBST_DIR/.." && pwd)

CI_YML="${COMDARE_CI_YML:-$REPO/.gitlab-ci.yml}"
TESTS_DIR="${COMDARE_TESTS_DIR:-$REPO/ci/tests}"
TESTS_PREFIX="${COMDARE_TESTS_PREFIX:-ci/tests}"
WACHE_PFAD="${COMDARE_WACHE_PFAD:-ci/tests_registrierung_wache.sh}"

MODUS="${1:-}"
case "$MODUS" in
    ''|--selbstbiss) : ;;
    *) echo "AUFRUF: sh ci/tests_registrierung_wache.sh [--selbstbiss]" >&2; exit 2 ;;
esac

echo "============================================================================="
echo "REGISTRIERUNGS-WACHE ci/tests/*.sh gegen .gitlab-ci.yml"
echo "  YAML     : $CI_YML"
echo "  Bestand  : $TESTS_DIR  (Praefix in der YAML: $TESTS_PREFIX/)"
echo "  Modus    : ${MODUS:-<nur Regeln>}"
echo "============================================================================="

if [ ! -f "$CI_YML" ]; then
    echo "ABBRUCH: '$CI_YML' nicht gefunden -- die Wache konnte nicht pruefen." >&2
    exit 2
fi
if [ ! -d "$TESTS_DIR" ]; then
    echo "ABBRUCH: '$TESTS_DIR' ist kein Verzeichnis -- die Wache konnte nicht pruefen." >&2
    exit 2
fi

WERK=$(mktemp -d) || exit 2
trap 'rm -rf "$WERK"' EXIT INT TERM

# --- Wuerfel (K13): der Koeder wird erzeugt, nie abgeschrieben ----------------
# od statt 'tr < /dev/urandom | head -c': kein SIGPIPE, kein rc-Ratespiel.
token() { od -An -tx1 -N8 /dev/urandom | tr -d ' \n'; }

# --- KOEDER VOR JEDER NULL ----------------------------------------------------
# Eine Null kann Abwesenheit ODER Werkzeug-Versagen sein. Deshalb wird die
# Zaehlweise erst an einer Datei geeicht, deren Inhalt diese Wache selbst
# gewuerfelt hat (K13). BERICHTIGT 13.08.2026 (A2.5-V3): die fruehere Begruendung
# "/usr/bin/grep ist hier ugrep" war am Objekt falsch -- /usr/bin/grep ist
# GNU grep 3.11 (prod1, gemessen 13.08.); ugrep ist die interaktive grep-FUNKTION
# (Fallen-Register-Lehre). Die Eichung bleibt richtig, egal welches grep
# antwortet.
KOEDER_DATEI="$WERK/koeder"
KT=$(token)
N_KOEDER=3
: > "$KOEDER_DATEI"
_i=1
while [ "$_i" -le "$N_KOEDER" ]; do
    printf '    - sh %s/koeder_%s_%s.sh --selbstbiss\n' "$TESTS_PREFIX" "$KT" "$_i" >> "$KOEDER_DATEI"
    _i=$((_i + 1))
done
N_BISS=$(grep -cF "sh $TESTS_PREFIX/koeder_$KT" "$KOEDER_DATEI" || true)
if [ "$N_BISS" -ne "$N_KOEDER" ]; then
    echo "ABBRUCH: der Koeder biss nicht -- grep fand $N_BISS von $N_KOEDER echten Aufrufen." >&2
    echo "         Ohne beissenden Koeder ist jede Zahl an der .gitlab-ci.yml wertlos." >&2
    exit 2
fi
echo "  Koeder biss: $N_BISS von $N_KOEDER gewuerfelten Aufrufzeilen gefunden (grep -cF)."

RC=0
riss() { RC=1; echo "  [RISS] $1"; }

# --- R3: Nenner zuerst --------------------------------------------------------
BESTAND="$WERK/bestand"
# NE-19a (13.08.2026): vorher 'find | sort > BESTAND'. Ein find-TEILTOD (N Zeilen geliefert,
# dann rc!=0) liess sort mit rc=0 enden und einen TEIL-Bestand stehen: R1 prueft dann nur die
# gelieferte Teilmenge, der Rest ist still unbewacht (der Nenner-0-Abbruch unten greift nur
# beim Totalverlust). dash als /bin/sh kennt weder pipefail noch PIPESTATUS (gemessen 13.08.:
# rc=2, dash 0.5.12-6ubuntu5); Hausform: jede Stufe in eine Datei, jede Stufe ihr eigener $?.
find "$TESTS_DIR" -maxdepth 1 -type f -name '*.sh' > "$WERK/bestand_roh" \
    || { echo "ABBRUCH: find ueber '$TESTS_DIR' fehlgeschlagen (rc=$?) -- der Bestand waere" >&2
         echo "         unvollstaendig, und R1 pruefte eine Teilmenge als Ganzes." >&2; exit 2; }
sort "$WERK/bestand_roh" > "$BESTAND" \
    || { echo "ABBRUCH: sort des Proben-Bestands fehlgeschlagen (rc=$?)." >&2; exit 2; }
N_BESTAND=$(awk 'END{print NR+0}' "$BESTAND")
echo "  R3 Bestand: $N_BESTAND Datei(en) unter $TESTS_DIR (Muster '*.sh', maxdepth 1)."
if [ "$N_BESTAND" -lt 1 ]; then
    echo "ABBRUCH: leerer Bestand. R1 waere zwangslaeufig erfuellt, und genau so sieht" >&2
    echo "         eine Wache aus, die nichts mehr bewacht. KEIN stilles Gruen." >&2
    exit 2
fi

# --- R1: jede Probe hat mindestens eine Aufrufstelle --------------------------
N_REG=0
while IFS= read -r _datei; do
    [ -n "$_datei" ] || continue
    _name=$(basename "$_datei")
    _muster="sh $TESTS_PREFIX/$_name"
    _n=$(grep -cF -- "$_muster" "$CI_YML" || true)
    if [ "$_n" -lt 1 ]; then
        riss "R1 $TESTS_PREFIX/$_name ist in keinem Job registriert ($_n Aufrufstellen)."
        echo "         Ein Test, der in keinem Job faehrt, ist NICHT gebaut (T-7)."
    else
        N_REG=$((N_REG + 1))
        echo "  R1 $TESTS_PREFIX/$_name: $_n Aufrufstelle(n)."
    fi
done < "$BESTAND"
echo "  R1 NENNER: $N_REG von $N_BESTAND Proben registriert."

# --- R2: die Wache selbst, aus mindestens ZWEI VERSCHIEDENEN Job-Bloecken -----
# Gezaehlt werden BLOECKE. Der Block beginnt an einem Schluessel in Spalte 1 und
# endet am naechsten -- das ist die YAML-Struktur selbst, kein geratener Anker.
# Kommentarzeilen sind ausgenommen: der blosse Pfad in Prosa ist kein Aufruf.
JOBS="$WERK/eigene_jobs"
awk -v muster="sh $WACHE_PFAD" '
    /^[a-zA-Z_.][a-zA-Z0-9_:.-]*:[ ]*$/ { job = $0; sub(/:[ ]*$/, "", job) }
    {
        zeile = $0
        sub(/^[ \t]+/, "", zeile)
        if (substr(zeile, 1, 1) == "#") next
        if (index($0, muster) > 0 && !(job in gesehen)) { gesehen[job] = 1; print job }
    }' "$CI_YML" > "$JOBS"
N_JOBS=$(awk 'END{print NR+0}' "$JOBS")
if [ "$N_JOBS" -gt 0 ]; then
    while IFS= read -r _j; do echo "  R2 eigener Aufruf im Job-Block: $_j"; done < "$JOBS"
fi
if [ "$N_JOBS" -lt 2 ]; then
    riss "R2 diese Wache wird aus $N_JOBS Job-Block/Bloecken gerufen, gefordert sind 2."
    echo "         Mit nur einer Aufrufstelle nimmt deren Loeschung die Wache mit --"
    echo "         und die Zirkularitaet, gegen die sie gebaut ist, waere zurueck."
else
    echo "  R2 NENNER: $N_JOBS verschiedene Job-Bloecke rufen $WACHE_PFAD (gefordert: 2)."
fi

echo "-----------------------------------------------------------------------------"
if [ "$RC" -eq 0 ]; then
    echo "REGISTRIERUNGS-WACHE: OK ($N_REG von $N_BESTAND Proben, $N_JOBS eigene Job-Bloecke)."
else
    echo "REGISTRIERUNGS-WACHE: ROT -- mindestens eine Registrierung fehlt." >&2
fi
echo "-----------------------------------------------------------------------------"

# =============================================================================
# --selbstbiss (T-1): eine Wache, die nur am gesunden Objekt gruen ist, belegt
# nichts. Es werden Wegwerf-Eingaben gebaut und GEFORDERT, dass sie rot wird.
#   M1  Eine gewuerfelt benannte Probe kommt in den Bestand, ohne Job. -> R1
#   M2  BEIDE eigenen Aufrufstellen fallen aus der YAML.               -> R2 (0)
#   M3  GENAU EINE der beiden faellt aus der YAML.                     -> R2 (1)
#   M4  Die Registrierung EINER echten Probe faellt aus der YAML.      -> R1
#
# WARUM M3 UNVERZICHTBAR IST -- die Prueffrage vor jedem Koeder lautet: gibt es
# einen Eingang, bei dem sich MIT und OHNE der Regel unterscheidet? Fuer die
# Forderung "mindestens ZWEI Bloecke" ist M2 dieser Eingang NICHT: bei null
# Aufrufstellen waere auch ein blosses "mindestens EINER" rot. Nur M3 trennt die
# beiden Fassungen. Ohne ihn waere die 2 eine unbewiesene Zahl -- eine halbe
# Wache, die gruen aussieht.
# WARUM M1 UND M4 BEIDE STEHEN: M1 misst die Richtung "neue Datei, kein Job"
# (der Fall, den die Proben selbst auch faenden), M4 die Richtung "Job geloescht,
# Datei bleibt" -- und GENAU DIESE zweite Richtung ist die Zirkularitaet, denn
# die geloeschte Probe kann sich dazu nicht mehr aeussern.
# =============================================================================
if [ "$MODUS" = --selbstbiss ] && [ "$RC" -ne 0 ]; then
    echo "SELBSTBISS UEBERSPRUNGEN: die Wache ist schon am gesunden Objekt rot." >&2
    echo "Ein Mutationsbeweis waere darauf wertlos." >&2
    exit 1
fi
if [ "$MODUS" = --selbstbiss ]; then
    echo
    echo "============================================================================="
    echo "SELBSTBISS: die Wache wird gegen Wegwerf-Eingaben gefahren."
    echo "============================================================================="
    MUT=$WERK/mutanten; mkdir -p "$MUT"
    N_MUT=0; N_GEBISSEN=0

    biss() {          # $1 = Name, $2 = Beschreibung, $3 = TESTS_DIR, $4 = CI_YML,
                      # $5 = literaler Text, der in der roten Ausgabe stehen MUSS
        N_MUT=$((N_MUT + 1))
        echo "  -- $1: $2"
        set +e
        COMDARE_TESTS_DIR="$3" COMDARE_CI_YML="$4" sh "$0" > "$MUT/$1.log" 2>&1
        _rc=$?
        set -e
        if [ "$_rc" -eq 0 ]; then
            echo "     [DAUERALARM-FEHLER] die Wache blieb GRUEN am Mutanten '$1'." >&2
            sed 's/^/     | /' "$MUT/$1.log" >&2
            exit 1
        fi
        if grep -qF -- "$5" "$MUT/$1.log"; then :; else
            echo "     [SCHEINBISS] '$1' wurde rot, aber nicht ueber die gemeinte Regel." >&2
            echo "     Gefordert war der Text: >>$5<<" >&2
            sed 's/^/     | /' "$MUT/$1.log" >&2
            exit 1
        fi
        N_GEBISSEN=$((N_GEBISSEN + 1))
        echo "     gebissen: rc=$_rc, und die Ausgabe nennt die Regel."
        grep -F '[RISS]' "$MUT/$1.log" | sed 's/^/       /' || true
    }

    # -- M1: gewuerfelt benannte Probe im Bestand, ohne Job ------------------
    KM=$(token)
    M1_DIR="$MUT/bestand_m1"; mkdir -p "$M1_DIR"
    while IFS= read -r _d; do [ -n "$_d" ] && cp "$_d" "$M1_DIR/"; done < "$BESTAND"
    printf '#!/bin/sh\n# Wegwerf-Probe des Selbstbisses.\nexit 0\n' > "$M1_DIR/koeder_${KM}_probe.sh"
    biss m1_unregistrierte_probe "neue Probe im Bestand, kein Job-Block" \
        "$M1_DIR" "$CI_YML" "R1 $TESTS_PREFIX/koeder_${KM}_probe.sh ist in keinem Job registriert"

    # -- M2: BEIDE eigenen Aufrufstellen weg --------------------------------
    M2_YML="$MUT/yml_m2.yml"
    grep -vF -- "sh $WACHE_PFAD" "$CI_YML" > "$M2_YML" || true
    _weg2=$(diff "$CI_YML" "$M2_YML" | awk '/^</{n++} END{print n+0}')
    if [ "$_weg2" -ne "$N_JOBS" ]; then
        echo "ABBRUCH: M2 entfernte $_weg2 Zeile(n), erwartet waren $N_JOBS." >&2
        echo "         Ein still nicht mehr greifender Mutant belegt nichts." >&2
        exit 2
    fi
    echo "     (M2 entfernte $_weg2 eigene Aufrufzeile(n) -- erwartet: $N_JOBS)"
    biss m2_beide_aufrufe_weg "beide eigenen Aufrufstellen aus der YAML" \
        "$TESTS_DIR" "$M2_YML" "R2 diese Wache wird aus 0 Job-Block/Bloecken gerufen"

    # -- M3: GENAU EINE Aufrufstelle weg -- der Eingang, der 2 von 1 trennt --
    M3_YML="$MUT/yml_m3.yml"
    awk -v muster="sh $WACHE_PFAD" '
        index($0, muster) > 0 && weg == 0 { weg = 1; next }
        { print }' "$CI_YML" > "$M3_YML"
    _weg3=$(diff "$CI_YML" "$M3_YML" | awk '/^</{n++} END{print n+0}')
    if [ "$_weg3" -ne 1 ]; then
        echo "ABBRUCH: M3 entfernte $_weg3 Zeile(n), erwartet war genau 1." >&2
        exit 2
    fi
    echo "     (M3 entfernte $_weg3 eigene Aufrufzeile -- die zweite bleibt stehen)"
    biss m3_eine_aufrufstelle_weg "nur EINE eigene Aufrufstelle bleibt -- R2 muss trotzdem reissen" \
        "$TESTS_DIR" "$M3_YML" "R2 diese Wache wird aus 1 Job-Block/Bloecken gerufen"

    # -- M4: Registrierung einer echten Probe weg ---------------------------
    M4_NAME=$(basename "$(head -1 "$BESTAND")")
    M4_YML="$MUT/yml_m4.yml"
    grep -vF -- "sh $TESTS_PREFIX/$M4_NAME" "$CI_YML" > "$M4_YML" || true
    _weg4=$(diff "$CI_YML" "$M4_YML" | awk '/^</{n++} END{print n+0}')
    if [ "$_weg4" -lt 1 ]; then
        echo "ABBRUCH: M4 entfernte $_weg4 Zeile(n), erwartet war mindestens 1." >&2
        exit 2
    fi
    echo "     (M4 entfernte $_weg4 Aufrufzeile(n) von $M4_NAME)"
    biss m4_job_geloescht "der Job-Block einer echten Probe faellt weg" \
        "$TESTS_DIR" "$M4_YML" "R1 $TESTS_PREFIX/$M4_NAME ist in keinem Job registriert"

    echo "-----------------------------------------------------------------------------"
    echo "SELBSTBISS-NENNER: $N_GEBISSEN von $N_MUT Mutanten haben die Wache rot gemacht."
    echo "-----------------------------------------------------------------------------"
    if [ "$N_GEBISSEN" -ne "$N_MUT" ]; then
        echo "FEHLER: nicht jeder Mutant wurde gefangen." >&2; exit 1
    fi
    echo "SELBSTBISS: OK ($N_GEBISSEN von $N_MUT)."
fi

exit "$RC"
