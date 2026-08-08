#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  PLAN-ZAHLEN-WACHE -- eine Zahl in einem Plan ist eine Behauptung ueber das
#  Objekt und verjaehrt genauso wie jede andere.                  (2026-08-08)
# =============================================================================
#
# DER BEFUND, GEGEN DEN SIE GEBAUT IST:
# Der TDD-Designplan (docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-
# wellen.md) traegt Zahlen ueber den Code. Eine davon -- "das CSV-Schema wird von
# 47 von 47 Stellen gegen seine eigene Quelle geprueft" -- war am Objekt mit
# KEINER benannten Zaehlweise reproduzierbar (sechs Zaehlweisen probiert, s.
# Abschnitt 9 des Plans). Der Plan hat die Zahl nie nachgemessen, weil nichts sie
# nachmass: sie stand in Prosa, und Prosa wird nicht rot.
#
# Genau dieselbe Klasse, die der Plan auf 117 Posten im Testbestand beschreibt --
# "kein-nenner", "anwesenheit-statt-bedingung" -- traf den Plan selbst. Deshalb
# steht die Berichtigung nicht allein als Fussnote da: die Zahlen der Fussnoten
# liegen als maschinenlesbare Anker IM Plan, und diese Wache leitet sie bei jedem
# Lauf neu aus dem Code ab und vergleicht.
#
# WAS "ZWEI QUELLEN" HIER HEISST (TDD-Vertrag T-3, NENNER FREMD):
# SOLL kommt aus dem Plandokument (Anker-Block "PZW-*"), IST kommt aus dem Code
# (ce-Baum + .gitlab-ci.yml). Kein Wert wird aus dem jeweils anderen abgeleitet.
# Die Wache RECHNET nichts weich: sie meldet beide Zahlen mit ihrem Nenner.
#
# DIE ZEITRICHTUNGS-FALLE, DIE DIESE WACHE ERZWINGT (Pruefung 3 aus GOAL v8):
# Der ce-Baum ist ein Submodul. Beim Bau dieser Wache lag die Arbeitskopie des
# Submoduls auf a1d0c201 (03.06.), waehrend super HEAD den Gitlink 25fe4fbf
# fuehrt -- eine erste Messung lieferte deshalb 28/16 statt 29/17. Ein Submodul-
# "M" kann RUECKWAERTS zeigen. Die Wache misst deshalb NIE die Arbeitskopie,
# sondern immer den Baum am Gitlink-SHA (git ls-tree HEAD), und sie verlangt,
# dass der im Plan vermerkte SHA derselbe ist. Ist er es nicht, ist die Fussnote
# stale -- das ist ein Befund, kein Rauschen.
#
# AUFRUF:
#   sh ci/plan_zahlen_wache.sh [<plan.md>]
#
# ENV:
#   COMDARE_PLAN        Plandokument (ueberschreibt das Argument).
#   COMDARE_CI_YML      .gitlab-ci.yml, gegen die gemessen wird.
#   COMDARE_CE_QUELLE   Git-Verzeichnis, aus dem der ce-Baum gelesen wird, falls
#                       das Submodul den Gitlink-SHA nicht hat (lokaler Notfall;
#                       in der CI ist das Submodul auf dem Gitlink ausgecheckt).
#   COMDARE_GITLINK_SHA ueberschreibt den aus git ls-tree gelesenen Gitlink-SHA
#                       (nur fuer die Bissprobe; im Betrieb nie setzen).
#
# EXIT: 0 = jede Anker-Zahl deckt sich mit der Messung am Objekt
#       1 = mindestens eine Zahl weicht ab (beide Zahlen + Quelle im Protokoll)
#       2 = die Wache konnte nicht pruefen (Plan fehlt, Anker fehlt, ce-Baum am
#           Gitlink-SHA nicht lesbar) -- ausdruecklich KEIN Gruen. Ein stiller
#           Rueckfall auf "nichts gefunden, also in Ordnung" waere derselbe
#           Defekt, gegen den die Wache gebaut ist.
#
# ZAEHLWEISEN, ausdruecklich benannt (sie stehen wortgleich im Plan, Abschnitt 9):
#   SCHEMA-STELLEN  Zeilen im ce-Baum unter tests/ mit Endung .cpp, die den Text
#                   "lazy_csv_header()" tragen und KEINE Kommentarzeile sind
#                   (Zeile beginnt nach Einrueckung nicht mit // oder * oder /*).
#                   Gemessen mit `git grep -F` GEGEN DEN BAUM <sha>, nicht gegen
#                   die Arbeitskopie.
#   SCHEMA-DATEIEN  Zahl der .cpp-Uebersetzungseinheiten, in denen mindestens
#                   eine SCHEMA-STELLE liegt.
#   SCHEMA-LITERAL  Dateien unter tests/*.cpp, die den Voll-Header als Literal
#                   fuehren ("binary_id;setting;repetition"). Das ist die Zahl,
#                   die MT-L3 bewegen MUSS: heute 1, und dieses eine ist ein
#                   absichtlich VERALTETES Schema (Resume-Koeder), kein Orakel.
#   CI-AUFRUFE      Zeilen in .gitlab-ci.yml, die die Mess-Ausbeute-Wache
#                   AUSFUEHREN ("sh ../ci/mess_ausbeute_wache.sh").
#   CI-ALTMUSTER    Vorkommen des alten Praesenz-Musters `test -n "$(find` in
#                   .gitlab-ci.yml. IMMER mit -F gemessen: ohne -F liefert die
#                   Haus-Engine (ugrep) auf diesem Muster eine STILLE NULL --
#                   am 08.08. literal nachgemessen, 5 echte Vorkommen, `grep -c`
#                   meldete 0 mit rc=1, `grep -cF` meldete 5 mit rc=0.
#
# TESTKRITIK (T-9), was diese Wache NICHT deckt:
#   - Sie prueft Zahlen, keine Saetze. Eine falsche Behauptung ohne Zahl faengt
#     sie nicht.
#   - Die vier ctest-Zustaende der W-1-Berichtigung (429/431/456/460) sind NICHT
#     gedeckt: sie brauchen einen Configure bzw. einen gebauten Baum und sind
#     nicht in Sekunden ableitbar. Benannt ungedeckte Stelle, s. Plan Abschnitt 9.
#   - SCHEMA-STELLEN zaehlt Aufrufe, nicht Orakel-Qualitaet. Ob eine Stelle ihr
#     Soll wirklich aus dem Pruefling zieht, entscheidet MT-L3, nicht diese Wache.
#   - Kommentar-Erkennung ist zeilenweise: ein Aufruf innerhalb eines mehrzeiligen
#     /* ... */-Blocks wird als Code gezaehlt. Im Bestand kommt das nicht vor
#     (alle 35 Rohzeilen einzeln geprueft), aber es ist eine echte Grenze.
#
# POSIX-sh, ASCII-only, kein Python (Hausdoktrin: kein Python in der Buildchain).
# =============================================================================

set -eu

# Werkzeug-Vorspann, fail-closed: gemessen wird ausdruecklich mit /usr/bin/grep
# (GNU grep 3.11 auf prod1) und NICHT mit dem blanken `grep`. In einer Agenten-
# Shell ist `grep` eine FUNKTION, die nach ugrep umleitet, und dort ist ein
# Muster mit `$(` ohne -F eine stille Anker-Falle. Fehlt das Werkzeug, bricht die
# Wache mit 2 ab statt mit einem nackten 127 aus set -e.
if [ ! -x /usr/bin/grep ]; then
    echo "ABBRUCH: /usr/bin/grep fehlt -- die Wache konnte nicht messen." >&2
    exit 2
fi

SELBST_DIR=$(cd "$(dirname "$0")" && pwd)
REPO=$(cd "$SELBST_DIR/.." && pwd)

PLAN="${COMDARE_PLAN:-${1:-$REPO/docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md}}"
CI_YML="${COMDARE_CI_YML:-$REPO/.gitlab-ci.yml}"
SUBMODUL="$REPO/Code/external/comdare-cache-engine"
ALTMUSTER='test -n "$(find'
AUSFUEHRUNG='sh ../ci/mess_ausbeute_wache.sh'
LITERAL='binary_id;setting;repetition'

N_PRUEF=0
N_ROT=0

echo "-----------------------------------------------------------------------------"
echo "PLAN-ZAHLEN-WACHE"
echo "  Plan   : $PLAN"
echo "  CI-YML : $CI_YML"
echo "-----------------------------------------------------------------------------"

if [ ! -f "$PLAN" ]; then
    echo "ABBRUCH: Plandokument '$PLAN' fehlt -- die Wache konnte nicht pruefen." >&2
    exit 2
fi
if [ ! -f "$CI_YML" ]; then
    echo "ABBRUCH: '$CI_YML' fehlt -- die Wache konnte nicht pruefen." >&2
    exit 2
fi

# --- Anker aus dem Plan lesen (SOLL-Quelle) ----------------------------------
# Format je Zeile:  PZW-<NAME><spaces>= <wert>
anker() {
    _name="$1"
    _wert=$(awk -v n="PZW-$_name" '
        $1 == n && $2 == "=" { print $3; found=1; exit }
        END { if (!found) exit 0 }
    ' "$PLAN")
    if [ -z "$_wert" ]; then
        echo "ABBRUCH: Anker 'PZW-$_name' steht nicht im Plan '$PLAN'." >&2
        echo "         Ohne Anker gibt es kein SOLL -- und ohne SOLL kein Gruen." >&2
        exit 2
    fi
    echo "$_wert"
}

pruefe() {                   # $1 = Posten, $2 = SOLL, $3 = IST, $4 = Nennertext
    N_PRUEF=$((N_PRUEF + 1))
    if [ "$2" = "$3" ]; then
        echo "  OK    $1: Plan sagt $2, Objekt liefert $3.   ($4)"
    else
        N_ROT=$((N_ROT + 1))
        echo "  ROT   $1: Plan sagt $2, Objekt liefert $3.   ($4)" >&2
        echo "        Die Fussnote im Plan ist gegen das Objekt falsch geworden." >&2
    fi
}

# --- Gitlink-SHA: der Zustand, in dem gemessen wird --------------------------
GITLINK="${COMDARE_GITLINK_SHA:-}"
if [ -z "$GITLINK" ]; then
    GITLINK=$(git -C "$REPO" ls-tree HEAD Code/external/comdare-cache-engine 2>/dev/null \
              | awk '$2 == "commit" { print $3; exit }')
fi
if [ -z "$GITLINK" ]; then
    echo "ABBRUCH: kein Gitlink-SHA fuer Code/external/comdare-cache-engine ermittelbar." >&2
    exit 2
fi

SHA_PLAN=$(anker CE-SHA)
echo "  ce-Gitlink an super HEAD : $GITLINK"
echo "  ce-SHA laut Plan-Anker   : $SHA_PLAN"
if [ "$SHA_PLAN" != "$GITLINK" ]; then
    echo "ABBRUCH: der Plan nennt einen ANDEREN ce-Zustand als super HEAD fuehrt." >&2
    echo "         Plan=$SHA_PLAN  Gitlink=$GITLINK" >&2
    echo "         Zwei Zahlen aus zwei Zustaenden sind kein Vergleich (Pruefung 3)." >&2
    echo "         Neu erheben, Fussnote nachziehen -- alte Fussnote deprecaten, nicht loeschen." >&2
    exit 2
fi

# --- ce-Quelle waehlen: die den Gitlink-SHA WIRKLICH hat ---------------------
CE=""
if git -C "$SUBMODUL" cat-file -e "$GITLINK^{commit}" 2>/dev/null; then
    CE="$SUBMODUL"
    CE_HERKUNFT="Submodul"
elif [ -n "${COMDARE_CE_QUELLE:-}" ] && git -C "$COMDARE_CE_QUELLE" cat-file -e "$GITLINK^{commit}" 2>/dev/null; then
    CE="$COMDARE_CE_QUELLE"
    CE_HERKUNFT="COMDARE_CE_QUELLE"
else
    echo "ABBRUCH: der ce-Baum am Gitlink-SHA $GITLINK ist nirgends lesbar." >&2
    echo "         Weder das Submodul ($SUBMODUL) noch COMDARE_CE_QUELLE" >&2
    echo "         (${COMDARE_CE_QUELLE:-nicht gesetzt}) fuehren dieses Objekt." >&2
    echo "         KEIN Gruen ohne Messung: 'nicht gefunden' ist kein 'in Ordnung'." >&2
    exit 2
fi
echo "  ce-Quelle                : $CE  ($CE_HERKUNFT)"
echo "-----------------------------------------------------------------------------"

# --- IST 1/2: Schema-Orakel-Stellen im ce-Baum AM GITLINK-SHA ----------------
ROH=$(git -C "$CE" grep -F -n 'lazy_csv_header()' "$GITLINK" -- 'tests/*.cpp' 2>/dev/null || true)
IST_STELLEN=$(printf '%s\n' "$ROH" | awk '
    NF == 0 { next }
    { s = $0; sub(/^[^:]*:[^:]*:[0-9]+:/, "", s); sub(/^[ \t]+/, "", s)
      if (s !~ /^\/\// && s !~ /^\*/ && s !~ /^\/\*/) c++ }
    END { print c+0 }')
IST_DATEIEN=$(printf '%s\n' "$ROH" | awk -F: '
    NF == 0 { next }
    { s = $0; sub(/^[^:]*:[^:]*:[0-9]+:/, "", s); sub(/^[ \t]+/, "", s)
      if (s !~ /^\/\// && s !~ /^\*/ && s !~ /^\/\*/) d[$2] = 1 }
    END { n = 0; for (k in d) n++; print n+0 }')
N_ROH=$(printf '%s\n' "$ROH" | awk 'NF > 0 { n++ } END { print n+0 }')
N_TESTCPP=$(git -C "$CE" ls-tree -r --name-only "$GITLINK" -- tests 2>/dev/null \
            | awk '/\.cpp$/ { n++ } END { print n+0 }')

# --- IST 3: eingefrorene Voll-Header-Literale unter tests/ -------------------
IST_LITERAL=$(git -C "$CE" grep -F -l "$LITERAL" "$GITLINK" -- 'tests/*.cpp' 2>/dev/null \
              | awk 'NF > 0 { n++ } END { print n+0 }')

# --- IST 4/5: die beiden super-eigenen Zahlen -------------------------------
IST_AUFRUFE=$(/usr/bin/grep -c -F -- "$AUSFUEHRUNG" "$CI_YML" || true)
IST_ALTMUSTER=$(/usr/bin/grep -c -F -- "$ALTMUSTER" "$CI_YML" || true)
N_YML=$(awk 'END { print NR+0 }' "$CI_YML")

pruefe "SCHEMA-STELLEN " "$(anker SCHEMA-STELLEN)" "$IST_STELLEN" \
       "Nenner: $N_TESTCPP Test-.cpp im Baum, $N_ROH Rohzeilen, davon Kommentar abgezogen"
pruefe "SCHEMA-DATEIEN " "$(anker SCHEMA-DATEIEN)" "$IST_DATEIEN" \
       "Nenner: $N_TESTCPP Test-.cpp im Baum $GITLINK"
pruefe "SCHEMA-LITERAL " "$(anker SCHEMA-LITERAL)" "$IST_LITERAL" \
       "Nenner: $N_TESTCPP Test-.cpp; steigt, sobald MT-L3 ein echtes Orakel einfriert"
pruefe "CI-AUFRUFE     " "$(anker CI-AUFRUFE)" "$IST_AUFRUFE" \
       "Nenner: $N_YML Zeilen in .gitlab-ci.yml, Muster '$AUSFUEHRUNG'"
pruefe "CI-ALTMUSTER   " "$(anker CI-ALTMUSTER)" "$IST_ALTMUSTER" \
       "Nenner: $N_YML Zeilen, Muster '$ALTMUSTER', gemessen MIT -F"

echo "-----------------------------------------------------------------------------"
echo "NENNER (nie eine nackte Null): $N_PRUEF Anker geprueft, $N_ROT abweichend."
echo "  Gemessener ce-Zustand: $GITLINK  (Quelle: $CE_HERKUNFT)"
echo "-----------------------------------------------------------------------------"

if [ "$N_ROT" -gt 0 ]; then
    echo "FEHLER: $N_ROT von $N_PRUEF Plan-Zahlen decken sich nicht mit dem Objekt." >&2
    echo "        Doku wird deprecatet, nicht geloescht: die alte Fussnote bleibt" >&2
    echo "        stehen, die neue Zahl kommt DANEBEN, mit Zaehlweise und Zustand." >&2
    exit 1
fi

echo "PLAN-ZAHLEN-WACHE: OK ($N_PRUEF von $N_PRUEF Ankern decken sich mit dem Objekt)."
exit 0
