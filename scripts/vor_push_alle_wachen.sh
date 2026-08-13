#!/bin/sh
# =============================================================================
#  VOR-PUSH-WACHE (INVENTAR-MODUS): alle lokal fahrbaren Gates ueber ALLE
#  beruehrten Dateien -- und ueber die VOLLE Wachen-Menge des Repos.
#  (scripts/vor_push_alle_wachen.sh)
# =============================================================================
#
# VORLAGE UND ABGRENZUNG (13.08.2026, NE-19b): das gleichnamige Skript im
# ce-Repo (Stand 2f8aba58) fuhr DREI fest verdrahtete Gates -- Diff-Hygiene,
# clang-format, cppcheck -- und blieb bei fehlendem cppcheck GRUEN ("Gate
# OFFEN, das Gesamt-Verdikt sagt dazu nichts"). Beides ist hier behoben:
#
#   (1) INVENTAR-MODUS: die Wachen-Menge wird zur LAUFZEIT enumeriert
#       (scripts/ci_*.sh + ci/*.sh, maxdepth 1). Jede enumerierte Datei muss
#       entweder GEFAHREN werden oder auf der AUSSCHLUSS-Liste stehen -- mit
#       Begruendung je Zeile. Eine neue Wache, die niemand eintraegt, macht
#       dieses Gate ROT statt still zu fehlen; eine gelistete Wache, die aus
#       dem Bestand verschwindet, ebenso (beide Richtungen geprueft).
#   (2) FEHLENDES WERKZEUG = ROT. Ein nicht gelaufener Test ist kein
#       bestandener (Vorfall ce 15239/15245: "Werkzeug lokal nicht vorhanden"
#       war falsch UND blieb gruen -- zwei rote Pipelines an einem Tag).
#
# Warum ein SPIEGEL und kein zentraler Bezug auf das ce-Skript: dieselbe
# Spiegel-Doktrin wie im Kopf von scripts/ci_diff_ascii_width_guard.sh
# (Lint-Stufe sieht keine Submodule; Strenge darf nicht am fremden Gitlink
# haengen; der Scope ist nicht derselbe -- die ce-Fassung kennt weder super-ci/
# noch die super-Wachen).
#
# AUFRUF:
#   sh scripts/vor_push_alle_wachen.sh                 # gegen origin/<branch>
#   sh scripts/vor_push_alle_wachen.sh <basis-ref>     # gegen einen eigenen Anker
#
# EXIT: 0 = alle gefahrenen Gates gruen UND Inventar vollstaendig erklaert.
#       1 = mindestens ein Gate rot / Werkzeug fehlt / Inventar unerklaert.
#       2 = ABBRUCH (kein Repo / Bereich unbestimmbar / Arbeitsstand schmutzig)
#       -- ausdruecklich KEIN Gruen: ein nicht gelaufener Test ist kein
#       bestandener.
#
# NE-19a-FORM: dieses Skript zieht KEIN Urteil aus einer Pipe. /bin/sh ist
# dash (kennt weder pipefail noch PIPESTATUS, gemessen 13.08.2026: rc=2);
# jede Beweisbasis entsteht deshalb je Stufe in einer Datei mit eigenem $?.
# POSIX-sh, kein bash-ismus, kein `grep -P` (Runner-Portabilitaet).
# =============================================================================

set -eu

abbruch() {
    echo ""
    echo "VOR-PUSH-WACHE: ABBRUCH -- $1" >&2
    exit 2
}

command -v git >/dev/null 2>&1 || abbruch "git fehlt"
git rev-parse --git-dir >/dev/null 2>&1 || abbruch "kein git-Repository"

REPO_ROOT=$(git rev-parse --show-toplevel) || abbruch "Repo-Wurzel nicht bestimmbar"
cd "$REPO_ROOT" || abbruch "cd in die Repo-Wurzel fehlgeschlagen"

TMP=$(mktemp -d) || abbruch "mktemp -d fehlgeschlagen"
trap 'rm -rf "$TMP"' EXIT INT TERM

echo "============================================================================="
echo " VOR-PUSH-WACHE (INVENTAR-MODUS): alle Gates, voller Wachen-Nenner"
echo "============================================================================="
echo ""

# -- Bereich bestimmen --------------------------------------------------------
# Ohne Argument: gegen den Upstream desselben Branches -- genau die Menge, die
# ein Push uebertragen wuerde. Faellt der Upstream weg, ist das ein ABBRUCH und
# kein stilles "dann halt gegen HEAD" (Nenner-0-Falle).
if [ $# -ge 1 ]; then
    BASIS="$1"
    git rev-parse --verify --quiet "$BASIS" >/dev/null || abbruch "Basis-Ref '$BASIS' existiert nicht"
else
    BRANCH=$(git rev-parse --abbrev-ref HEAD) || abbruch "Branch nicht bestimmbar"
    [ "$BRANCH" = "HEAD" ] && abbruch "detached HEAD -- bitte Basis-Ref als Argument angeben"
    BASIS="origin/$BRANCH"
    git rev-parse --verify --quiet "$BASIS" >/dev/null \
        || abbruch "'$BASIS' existiert nicht (erst 'git fetch origin', oder Basis-Ref als Argument angeben)"
fi

# DREI PUNKTE, NICHT ZWEI: die Drei-Punkt-Form misst ab dem gemeinsamen
# Vorfahren (merge-base) und beantwortet die Frage dieser Wache: WAS HABE ICH
# HINZUGEFUEGT? Die Zwei-Punkt-Form zeigte am 07.08.2026 elf fremde, auf
# development laengst geheilte Dateien als "meine" an und verleitet dazu,
# fremde Zeilen auf den eigenen alten Stand "zurueckzuheilen" (Regression).
BEREICH="$BASIS...HEAD"
_MERGE_BASE=$(git merge-base "$BASIS" HEAD 2>/dev/null) || abbruch "merge-base mit '$BASIS' nicht bestimmbar"
echo "BEREICH: $BEREICH   (Drei-Punkt: ab der Abzweigung, nicht ab dem Endpunkt)"
_K_BASIS=$(git rev-parse --short "$BASIS")
_K_MB=$(git rev-parse --short "$_MERGE_BASE")
_K_HEAD=$(git rev-parse --short HEAD)
echo "  Basis: $_K_BASIS   Abzweigung: $_K_MB   HEAD: $_K_HEAD"
if [ "$_MERGE_BASE" != "$(git rev-parse "$BASIS")" ]; then
    echo "  HINWEIS: '$BASIS' ist seit der Abzweigung weitergezogen. Gemessen wird DEINE Arbeit"
    echo "           ab der Abzweigung -- nicht der Rueckstand. (Vor dem Landen trotzdem mergen.)"
fi
echo ""

# -- SCHMUTZIGER ARBEITSSTAND IST EIN ABBRUCH, KEINE WARNUNG ------------------
# Der Bereich sieht ausschliesslich COMMITTETE Aenderungen; ein uncommitteter
# Fehler waere fuer jede der Wachen unsichtbar und das Gruen wertlos.
# Stufen-Form: der status-Stand ist Beweisbasis der Abbruch-Entscheidung.
git status --porcelain -- . > "$TMP/status.txt" \
    || abbruch "git status fehlgeschlagen (rc=$?) -- der Arbeitsstand ist nicht beurteilbar"
SCHMUTZ=$(awk 'END{print NR+0}' "$TMP/status.txt")
if [ "$SCHMUTZ" -gt 0 ]; then
    echo "ARBEITSSTAND: $SCHMUTZ nicht committete Aenderung(en):"
    sed 's/^/    /' "$TMP/status.txt"
    echo ""
    abbruch "der Arbeitsstand ist schmutzig. Diese Wache prueft NUR Committetes ($BEREICH) -- \
erst committen (oder stashen), dann erneut fahren."
fi
echo "ARBEITSSTAND: sauber (0 uncommittete Aenderungen) -- der Bereich ist vollstaendig."
echo ""

# -- Die Dateiliste: EINMAL bestimmt, von den Datei-Gates benutzt -------------
# Stufen-Form: ein diff-Teiltod hinterliesse sonst eine Teilmenge, die als
# Ganzes durchgeprueft wuerde (NE-19a-Klasse).
git diff --name-only "$BEREICH" > "$TMP/dateien.txt" \
    || abbruch "git diff --name-only '$BEREICH' fehlgeschlagen (rc=$?)"
ANZ_DATEIEN=$(awk 'NF{n++} END{print n+0}' "$TMP/dateien.txt")

echo "-----------------------------------------------------------------------------"
echo "NENNER (nie eine nackte Null):"
echo "  $ANZ_DATEIEN Datei(en) im Bereich beruehrt."
echo "-----------------------------------------------------------------------------"
echo ""

if [ "$ANZ_DATEIEN" -eq 0 ]; then
    abbruch "0 beruehrte Dateien -- pruefe den Bereich. Ein leerer Diff ist KEIN gruenes Gate."
fi

sed 's/^/  /' "$TMP/dateien.txt"
echo ""

ROT=0

# =============================================================================
#  TEIL A: DAS WACHEN-INVENTAR (NE-19b) -- erst zaehlen, dann fahren
# =============================================================================
# Muster: scripts/ci_*.sh + ci/*.sh, maxdepth 1. ci/tests/*.sh sind die
# BISSPROBEN der Wachen (je eigener CI-Job, von ci/tests_registrierung_wache.sh
# vollstaendig bewacht) und darum bewusst NICHT Teil dieses Musters.
find scripts -maxdepth 1 -type f -name 'ci_*.sh' > "$TMP/inv_scripts.txt" \
    || abbruch "find ueber scripts/ fehlgeschlagen (rc=$?) -- das Inventar waere unvollstaendig"
find ci -maxdepth 1 -type f -name '*.sh' > "$TMP/inv_ci.txt" \
    || abbruch "find ueber ci/ fehlgeschlagen (rc=$?) -- das Inventar waere unvollstaendig"
cat "$TMP/inv_scripts.txt" "$TMP/inv_ci.txt" > "$TMP/inv_roh.txt" \
    || abbruch "Inventar-Zusammenfuehrung fehlgeschlagen (rc=$?)"
sort "$TMP/inv_roh.txt" > "$TMP/inventar.txt" || abbruch "sort des Inventars fehlgeschlagen (rc=$?)"
N_INVENTAR=$(awk 'NF{n++} END{print n+0}' "$TMP/inventar.txt")
[ "$N_INVENTAR" -ge 1 ] || abbruch "0 Wachen enumeriert -- das Muster oder der Baum ist kaputt"

# FAHR-LISTE: diese Wachen laufen HIER, mit exakt den Argumenten ihres CI-Jobs
# (Zeilennummern .gitlab-ci.yml, Stand 13.08.2026 -- nur zur Auffindbarkeit).
fahr_liste() {
    cat <<'EOF'
ci/anker_wache.sh
ci/plan_zahlen_wache.sh
ci/tests_registrierung_wache.sh
ci/thesis_gitlink_parity.sh
ci/wachen_paritaet.sh
ci/zellkoordinaten_wache.sh
scripts/ci_abnahme06_bedingungs_tabelle.selbsttest.sh
scripts/ci_abnahme06_bedingungs_tabelle.sh
scripts/ci_diff_ascii_width_guard.sh
scripts/ci_host_klassen_bericht.selbsttest.sh
scripts/ci_host_klassen_bericht.sh
scripts/ci_host_klassen_gegenorakel.selbsttest.sh
scripts/ci_xml_wellformed_guard.sh
EOF
}

# AUSSCHLUSS-LISTE: eine Wache steht hier NUR mit Begruendung. Format je Zeile:
# <pfad><TAB><warum sie lokal nicht faehrt>. Wer eine Wache baut, die lokal
# nicht laufen kann, traegt sie HIER ein -- sonst wird dieses Gate ROT.
ausschluss_liste() {
    cat <<'EOF'
ci/anhang_forward_core.sh	schreibender Vorgang (Forward der Anhang-.tex ins Thesis-Submodul), kein Datei-Gate
ci/anhang_snapshot_einbuchen.sh	schreibender Vorgang (Snapshot-Staging im anhang:forward-Job), kein Datei-Gate
ci/bestandslog_wache.sh	braucht das Lauf-Log eines Mess-Jobs -- Mess-Kontext, lokal nicht vorhanden
ci/comdare_bestandslog_activation.sh	Aktivierungs-Prolog (wird im Mess-Job gesourct, exportiert Env), kein Gate
ci/durchstich_wache.sh	braucht messlauf-stdout.log bzw. lastprofile-Kontext eines realen Laufs
ci/frische_wache.sh	braucht measure_out/ samt Lauf-Markern eines realen Mess-Laufs
ci/lauf_marker.sh	Werkzeug am Mess-Output (schreiben/pruefen je Lauf), kein repo-lokales Gate
ci/mess_ausbeute_wache.sh	braucht measure_out/ eines realen Mess-Laufs
ci/object_stat_abnahme.sh	braucht Lager-/MinIO-Zugang des Mess-Kontexts (Objekt-Roundtrip)
ci/object_stat_wache.sh	braucht Lager-/MinIO-Zugang (Einzelobjekt-Pruefung im Mess-Kontext)
ci/persist_sammler.sh	schreibender Vorgang (Writeback-Sammler nach measurement/), kein Gate
ci/wide_aggregat.sh	Werkzeug mit Pflicht-Argumenten (Quell-Liste, Ziel-CSV) -- vom Mess-Job gerufen
scripts/ci_host_klassen_gegenorakel.sh	konfiguriert den echten Baum (cmake): Bau-Schritt; Selbsttest laeuft oben
EOF
}

wache_args() {
    case "$1" in
        scripts/ci_diff_ascii_width_guard.sh)       printf '%s' "$BEREICH" ;;
        scripts/ci_abnahme06_bedingungs_tabelle.sh)
            printf '%s' "--nur-zusicherung --gegen-vorlage"
            printf '%s' " docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md" ;;
        ci/thesis_gitlink_parity.sh)                printf '%s' "--quelle head" ;;
        ci/zellkoordinaten_wache.sh)                printf '%s' "jobs .gitlab-ci.yml" ;;
        *)                                          printf '%s' "" ;;
    esac
}

fahr_liste > "$TMP/fahren.roh" || abbruch "Fahr-Liste nicht erzeugbar (rc=$?)"
sort "$TMP/fahren.roh" > "$TMP/fahren.txt" || abbruch "sort der Fahr-Liste fehlgeschlagen (rc=$?)"
ausschluss_liste > "$TMP/ausschluss.roh" || abbruch "Ausschluss-Liste nicht erzeugbar (rc=$?)"
cut -f1 "$TMP/ausschluss.roh" > "$TMP/ausschluss_namen.roh" \
    || abbruch "cut der Ausschluss-Namen fehlgeschlagen (rc=$?)"
sort "$TMP/ausschluss_namen.roh" > "$TMP/ausschluss_namen.txt" \
    || abbruch "sort der Ausschluss-Namen fehlgeschlagen (rc=$?)"
cat "$TMP/fahren.txt" "$TMP/ausschluss_namen.txt" > "$TMP/bekannt.roh" \
    || abbruch "Zusammenfuehrung bekannter Wachen fehlgeschlagen (rc=$?)"
sort -u "$TMP/bekannt.roh" > "$TMP/bekannt.txt" || abbruch "sort -u der bekannten Wachen fehlgeschlagen (rc=$?)"

N_FAHREN=$(awk 'NF{n++} END{print n+0}' "$TMP/fahren.txt")
N_AUSSCHLUSS=$(awk 'NF{n++} END{print n+0}' "$TMP/ausschluss_namen.txt")
N_BEKANNT=$(awk 'NF{n++} END{print n+0}' "$TMP/bekannt.txt")

echo "============================================================================="
echo " [A] WACHEN-INVENTAR (Laufzeit-Enumeration: scripts/ci_*.sh + ci/*.sh)"
echo "============================================================================="
echo "  Enumeriert: $N_INVENTAR   deklariert: $N_FAHREN zu fahren + $N_AUSSCHLUSS ausgeschlossen ($N_BEKANNT eindeutig)"

# Doppel-Deklaration (gefahren UND ausgeschlossen) ist ein Pflegefehler.
if [ "$N_BEKANNT" -ne $((N_FAHREN + N_AUSSCHLUSS)) ]; then
    echo "  [ROT] $((N_FAHREN + N_AUSSCHLUSS - N_BEKANNT)) Wache(n) stehen auf BEIDEN Listen."
    ROT=1
fi
# Richtung 1: enumeriert, aber weder gefahren noch begruendet ausgeschlossen.
comm -23 "$TMP/inventar.txt" "$TMP/bekannt.txt" > "$TMP/unbekannt.txt" \
    || abbruch "comm (unbekannte Wachen) fehlgeschlagen (rc=$?)"
N_UNBEKANNT=$(awk 'NF{n++} END{print n+0}' "$TMP/unbekannt.txt")
if [ "$N_UNBEKANNT" -gt 0 ]; then
    echo "  [ROT] $N_UNBEKANNT Wache(n) im Bestand, aber weder gefahren noch begruendet ausgeschlossen:"
    sed 's/^/        /' "$TMP/unbekannt.txt"
    ROT=1
fi
# Richtung 2: deklariert, aber nicht (mehr) im Bestand -- Verschwinden ist laut.
comm -13 "$TMP/inventar.txt" "$TMP/bekannt.txt" > "$TMP/verschwunden.txt" \
    || abbruch "comm (verschwundene Wachen) fehlgeschlagen (rc=$?)"
N_VERSCHWUNDEN=$(awk 'NF{n++} END{print n+0}' "$TMP/verschwunden.txt")
if [ "$N_VERSCHWUNDEN" -gt 0 ]; then
    echo "  [ROT] $N_VERSCHWUNDEN deklarierte Wache(n) fehlen im Bestand (geloescht/umbenannt?):"
    sed 's/^/        /' "$TMP/verschwunden.txt"
    ROT=1
fi
[ "$ROT" -eq 0 ] && echo "  Inventar vollstaendig erklaert (beide Richtungen geprueft)."
echo ""
echo "  AUSGESCHLOSSEN ($N_AUSSCHLUSS, je mit Begruendung):"
awk -F'\t' '{ printf "    * %-42s %s\n", $1, $2 }' "$TMP/ausschluss.roh"
echo ""

# =============================================================================
#  TEIL B: DIE GEFAHRENEN WACHEN -- jede mit literalem rc
# =============================================================================
GEFAHREN=0
WACHEN_ROT=0
while IFS= read -r w; do
    [ -n "$w" ] || continue
    if [ ! -f "$w" ]; then
        # Schon oben als "verschwunden" ROT gemeldet; hier nur nicht abstuerzen.
        continue
    fi
    ARGS=$(wache_args "$w")
    LOG="$TMP/lauf_$(printf '%s' "$w" | tr '/' '_').log"
    echo "-----------------------------------------------------------------------------"
    echo " WACHE: sh $w ${ARGS:-<ohne Argumente>}"
    _rc=0
    # stdin von /dev/null: eine stdin-lesende Wache wuerde sonst die
    # Fahr-Liste dieser while-Schleife leerlesen.
    # shellcheck disable=SC2086 -- ARGS ist bewusst wortgesplittet (feste Literale von oben).
    sh "$w" $ARGS > "$LOG" 2>&1 < /dev/null || _rc=$?
    GEFAHREN=$((GEFAHREN + 1))
    if [ "$_rc" -eq 0 ]; then
        echo "   rc=0 gruen. $(awk 'END{print NR+0}' "$LOG") Log-Zeile(n), letzte:"
        tail -1 "$LOG" | sed 's/^/     /'
    else
        echo "   rc=$_rc ROT -- Log-Ende:"
        tail -15 "$LOG" | sed 's/^/     | /'
        ROT=1
        WACHEN_ROT=$((WACHEN_ROT + 1))
    fi
done < "$TMP/fahren.txt"
echo "-----------------------------------------------------------------------------"
echo "  $GEFAHREN von $N_INVENTAR Wachen gefahren, davon $WACHEN_ROT rot."
echo ""

# =============================================================================
#  TEIL C: WERKZEUG-GATES (Spiegel der CI-Jobs lint:format / lint:static)
# =============================================================================
echo "============================================================================="
echo " [C1] CLANG-FORMAT ueber alle beruehrten C++-Dateien (CI-Job lint:format)"
echo "============================================================================="
CF="${COMDARE_CLANG_FORMAT:-}"
if [ -z "$CF" ]; then
    for kandidat in \
        /home/comdare/tools/cf22/usr/bin/clang-format-22 \
        clang-format-22 clang-format
    do
        if command -v "$kandidat" >/dev/null 2>&1; then CF="$kandidat"; break; fi
    done
fi
CPP_GEPRUEFT=0
CPP_ABWEICHEND=0
if [ -z "$CF" ]; then
    # FEHLENDES WERKZEUG = ROT (NE-19b-Kern): frueher stand hier ein Abbruch bzw.
    # im cppcheck-Zweig ein stilles "Gate OFFEN" -- ein nicht gelaufener Test ist
    # kein bestandener, und ein offenes Gate ist kein gruenes.
    echo "  [ROT] kein clang-format gefunden (COMDARE_CLANG_FORMAT setzen). Gate NICHT gefahren."
    ROT=1
else
    echo "WERKZEUG: $CF ($("$CF" --version 2>/dev/null || echo 'Version unbekannt'))"
    echo "VERSTOESSE (falls vorhanden):"
    while IFS= read -r f; do
        case "$f" in
            *.hpp|*.cpp|*.h|*.cc|*.hh) ;;
            *) continue ;;
        esac
        [ -f "$f" ] || continue
        CPP_GEPRUEFT=$((CPP_GEPRUEFT + 1))
        # Stufen-Form statt '"$CF" ... | diff -q - "$f"': stirbt clang-format,
        # ist das ein WERKZEUGFEHLER und kein Format-Urteil (NE-19a).
        if ! "$CF" --style=file "$f" > "$TMP/format_ist.txt" 2>"$TMP/format_err.txt"; then
            echo "  FORMAT-WERKZEUGFEHLER $f (clang-format rc!=0):"
            sed 's/^/      /' "$TMP/format_err.txt" | head -3
            ROT=1
            continue
        fi
        _drc=0
        diff -q "$TMP/format_ist.txt" "$f" >/dev/null 2>&1 || _drc=$?
        if [ "$_drc" -eq 0 ]; then
            :
        elif [ "$_drc" -eq 1 ]; then
            echo "  FORMAT-ABWEICHUNG   $f"
            CPP_ABWEICHEND=$((CPP_ABWEICHEND + 1))
            ROT=1
        else
            echo "  FORMAT-VERGLEICHSFEHLER $f (diff rc=$_drc)"
            ROT=1
        fi
    done < "$TMP/dateien.txt"
    [ "$CPP_ABWEICHEND" -eq 0 ] && echo "  (keine)"
    echo "-----------------------------------------------------------------------------"
    echo "NENNER: $CPP_GEPRUEFT C++-Datei(en) formatgeprueft, davon $CPP_ABWEICHEND abweichend"
    echo "        (von $ANZ_DATEIEN beruehrten Dateien insgesamt; der Rest ist kein C++)."
    echo "-----------------------------------------------------------------------------"
fi
echo ""

echo "============================================================================="
echo " [C2] CPPCHECK (Spiegel des CI-Jobs lint:static, VOLLER Scope)"
echo "============================================================================="
# VOLLER Scope, nicht Diff-Scope: cppcheck meldet nur den ERSTEN
# preprocessorErrorDirective JE DATEI -- eine Aenderung in A macht Befunde in
# der unberuehrten B sichtbar. Pfade und Ignore-Verzeichnisse kommen aus der
# .gitlab-ci.yml, NICHT aus einer Kopie hier (sonst driften Wache und Job).
CC="${COMDARE_CPPCHECK:-}"
CC_GESUCHT=""
if [ -z "$CC" ]; then
    for kandidat in \
        "${COMDARE_CITOOLS_DIR:-/nonexistent}/bin/cppcheck" \
        /home/comdare/tools/cppcheck-2.21.0/bin/cppcheck \
        cppcheck
    do
        CC_GESUCHT="$CC_GESUCHT $kandidat"
        if command -v "$kandidat" >/dev/null 2>&1; then CC="$kandidat"; break; fi
    done
fi
if [ -z "$CC" ]; then
    # FEHLENDES WERKZEUG = ROT (NE-19b-Kern). Die ce-Vorfassung liess genau
    # diesen Fall GRUEN durch ("CPPCHECK_GEFAHREN=0, das Verdikt sagt dazu
    # nichts") -- die naechste stille Null. Gesucht wurde in:$CC_GESUCHT
    echo "  [ROT] kein cppcheck gefunden. Gesucht in:$CC_GESUCHT"
    echo "        COMDARE_CPPCHECK=<pfad> setzen. Gate NICHT gefahren -> Verdikt ROT."
    ROT=1
else
    echo "WERKZEUG: $CC ($("$CC" --version 2>/dev/null || echo 'Version unbekannt'))"
    CI_YML=".gitlab-ci.yml"
    # Eine yml-Variable lesen: 'NAME: "wert"' auf Zeilenanfang (Kommentare
    # beginnen mit '#' und matchen das Muster nicht).
    yml_var() {
        sed -n 's/^[[:space:]]*'"$1"':[[:space:]]*"\(.*\)"[[:space:]]*$/\1/p' "$CI_YML"
    }
    LINT_PATHS=""
    [ -f "$CI_YML" ] && LINT_PATHS=$(yml_var COMDARE_LINT_PATHS) || true
    if [ -z "$LINT_PATHS" ]; then
        LINT_PATHS="libs apps tests"
        echo "  HINWEIS: COMDARE_LINT_PATHS steht nicht in $CI_YML -> Template-Default '$LINT_PATHS'."
    fi
    IGN_DIRS="${COMDARE_CPPCHECK_IGNORE_DIRS:-}"
    if [ -z "$IGN_DIRS" ] && [ -f "$CI_YML" ]; then
        IGN_DIRS=$(yml_var COMDARE_CPPCHECK_IGNORE_DIRS) || true
    fi
    [ -n "$IGN_DIRS" ] || IGN_DIRS="ext build _archive_code_pre_migration modules"
    IGN="-i ./.citools"
    IGN_ANZ=1
    # POSIX: keine Process Substitution; der for-Loop ueber $(find ...) ist
    # wortsplitting-abhaengig -- unkritisch, weil die Namen aus IGN_DIRS stammen
    # und keine Leerzeichen tragen.
    for d in $IGN_DIRS; do
        case "$d" in
            */*) IGN="$IGN -i ./$d"; IGN_ANZ=$((IGN_ANZ + 1)) ;;
            *)   find . -path ./.citools -prune -o -type d -name "$d" -print > "$TMP/ign_dirs.txt" 2>/dev/null \
                     || abbruch "find der Ignore-Verzeichnisse '$d' fehlgeschlagen (rc=$?)"
                 while IFS= read -r p; do
                     [ -n "$p" ] || continue
                     IGN="$IGN -i $p"; IGN_ANZ=$((IGN_ANZ + 1))
                 done < "$TMP/ign_dirs.txt" ;;
        esac
    done
    CC_RC=0
    # EXAKT der Aufruf aus ci-templates/base-pipeline.yml (.lint-static) -- jede
    # Abweichung macht das Gate zu einer Aussage ueber einen anderen Lauf.
    # shellcheck disable=SC2086 -- LINT_PATHS/IGN sind bewusst wortgesplittet.
    "$CC" --enable=warning,portability --inline-suppr --library=googletest \
          --error-exitcode=2 --std=c++23 --language=c++ -q $LINT_PATHS $IGN \
          > "$TMP/cppcheck.log" 2>&1 || CC_RC=$?
    # Volle Severity-Muster + nie stummer Rueckfall (ce-Lehre 08.08.2026: nur
    # ': error:' zu greppen war selbst eine falsch-gruene Anzeige).
    CC_MUSTER=': (error|warning|style|performance|portability|information):'
    _rc=0; grep -Ec "$CC_MUSTER" "$TMP/cppcheck.log" > "$TMP/cc_anz.txt" || _rc=$?
    [ "$_rc" -le 1 ] || abbruch "grep auf dem cppcheck-Log fehlgeschlagen (rc=$_rc)"
    CC_FEHLER=$(cat "$TMP/cc_anz.txt")
    [ -n "$CC_FEHLER" ] || CC_FEHLER=0
    echo ""
    echo "VERSTOESSE (falls vorhanden):"
    if [ "$CC_RC" -ne 0 ]; then
        if [ "$CC_FEHLER" -gt 0 ]; then
            grep -E "$CC_MUSTER" "$TMP/cppcheck.log" > "$TMP/cc_befunde.txt" || true
            head -30 "$TMP/cc_befunde.txt" | sed 's/^/  /'
        else
            echo "  (kein bekanntes Severity-Muster getroffen -- rohes Log-Ende:)"
            tail -20 "$TMP/cppcheck.log" | sed 's/^/  /'
        fi
        ROT=1
    else
        echo "  (keine)"
    fi
    echo "-----------------------------------------------------------------------------"
    echo "NENNER: Pfade: $LINT_PATHS | $IGN_ANZ Ignore-Eintraege | Exit $CC_RC | $CC_FEHLER Befundzeile(n)."
    echo "        VOLLER Scope wie die CI -- NICHT nur die $ANZ_DATEIEN beruehrten Dateien."
    echo "-----------------------------------------------------------------------------"
fi
echo ""

# -- WAS DIESE WACHE NICHT PRUEFT ---------------------------------------------
echo "============================================================================="
echo " NICHT VON DIESER WACHE GEPRUEFT (die CI faehrt sie trotzdem):"
echo "   * Bau + ctest             -- absichtlich nicht: sie gehoeren in den Bau-Schritt,"
echo "     nicht in eine Datei-Wache. VOR dem Push selbst fahren."
echo "   * ci_host_klassen_gegenorakel.sh -- konfiguriert den echten Baum (s. Ausschluss oben)."
echo "   * gitleaks / lint:secrets -- braucht einen echten Klon (Submodul-Falle), separat."
echo "   * Mess-Kontext-Wachen     -- s. Ausschluss-Liste oben (je Zeile begruendet)."
echo "============================================================================="
echo ""

# -- Verdikt ------------------------------------------------------------------
echo "============================================================================="
echo "BILANZ: $GEFAHREN von $N_INVENTAR Wachen gefahren, $N_AUSSCHLUSS ausgeschlossen (je Zeile begruendet),"
echo "        dazu 2 Werkzeug-Gates (clang-format, cppcheck) ueber $ANZ_DATEIEN beruehrte Datei(en)."
if [ "$ROT" -eq 0 ]; then
    echo "VOR-PUSH-WACHE: GRUEN -- alle gefahrenen Gates gruen, Inventar vollstaendig erklaert."
    echo "============================================================================="
    exit 0
fi
echo "VOR-PUSH-WACHE: ROT -- mindestens ein Gate rot, ein Werkzeug fehlt oder das Inventar"
echo "                ist unerklaert (Details oben)."
echo "============================================================================="
exit 1
