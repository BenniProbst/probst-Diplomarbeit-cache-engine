#!/bin/sh
# Z23: PZW-Anker-Zaehlung am neuen Gitlink-Baum -- Formeln LITERAL aus
# ci/plan_zahlen_wache.sh (super), gefahren VOR dem Anker-Nachzug.
# Aufruf: sh z23_pzw_zaehlung.sh <ce-baum-sha>
set -eu
SHA="$1"
REPO=/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine
CE="$REPO/Code/external/comdare-cache-engine"
CI_YML="$REPO/.gitlab-ci.yml"
ALTMUSTER='test -n "$(find'
AUSFUEHRUNG='sh ../ci/mess_ausbeute_wache.sh'
LITERAL='binary_id;setting;repetition'

ROH=$(git -C "$CE" grep -F -n 'lazy_csv_header()' "$SHA" -- 'tests/*.cpp' 2>/dev/null || true)
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
N_TESTCPP=$(git -C "$CE" ls-tree -r --name-only "$SHA" -- tests 2>/dev/null \
            | awk '/\.cpp$/ { n++ } END { print n+0 }')
IST_LITERAL=$(git -C "$CE" grep -F -l "$LITERAL" "$SHA" -- 'tests/*.cpp' 2>/dev/null \
              | awk 'NF > 0 { n++ } END { print n+0 }')
IST_AUFRUFE=$(/usr/bin/grep -c -F -- "$AUSFUEHRUNG" "$CI_YML" || true)
IST_ALTMUSTER=$(/usr/bin/grep -c -F -- "$ALTMUSTER" "$CI_YML" || true)
N_YML=$(awk 'END { print NR+0 }' "$CI_YML")

echo "Z23-PZW-ZAEHLUNG am ce-Baum $SHA (Formeln der Wache selbst):"
echo "  SCHEMA-STELLEN = $IST_STELLEN   (Rohzeilen $N_ROH, Kommentar abgezogen)"
echo "  SCHEMA-DATEIEN = $IST_DATEIEN"
echo "  SCHEMA-LITERAL = $IST_LITERAL"
echo "  CI-AUFRUFE     = $IST_AUFRUFE"
echo "  CI-ALTMUSTER   = $IST_ALTMUSTER"
echo "  Nenner: $N_TESTCPP Test-.cpp am Baum, $N_YML Zeilen .gitlab-ci.yml"
