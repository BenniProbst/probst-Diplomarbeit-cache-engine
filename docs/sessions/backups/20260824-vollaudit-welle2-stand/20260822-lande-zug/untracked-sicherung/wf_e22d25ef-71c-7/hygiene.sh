#!/usr/bin/env bash
# DIFF-HYGIENE-WACHE selbst gefahren, ueber GENAU meinen Push-Bereich.
# Exit OHNE Pipe gemessen (K11).
set -u
Z=/home/comdare/wt-super-f1-transport
cd "$Z" || exit 2
COMDARE_GUARD_BASIS_REF=origin/development sh scripts/ci_diff_ascii_width_guard.sh --seit-basis \
  > /tmp/hyg.txt 2>&1
RC=$?
echo "RC_OHNE_PIPE=$RC"
cat /tmp/hyg.txt
