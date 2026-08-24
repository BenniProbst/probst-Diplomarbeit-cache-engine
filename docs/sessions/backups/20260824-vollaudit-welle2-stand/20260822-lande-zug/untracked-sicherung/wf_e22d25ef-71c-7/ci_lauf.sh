#!/usr/bin/env bash
# Die Probe GENAU so fahren, wie der CI-Job sie ruft: cwd = Repo-Wurzel,
# relativer Pfad, POSIX sh. Exit OHNE Pipe (K11).
set -u
cd /home/comdare/wt-super-f1-transport || exit 2
sh ci/tests/anhang_forward_probe.sh --selbstbiss > /tmp/afp_ci.txt 2>&1
RC=$?
echo "RC_OHNE_PIPE=$RC"
/usr/bin/grep -E "^  \[|NENNER|PROBE ANHANG|SELBSTBISS" /tmp/afp_ci.txt
echo
echo "-- Hardlink-Zaehler einer Packdatei (belegt: der Klon kostet fast keine Platte) --"
find /home/comdare/wt-super-f1-transport/.git/objects/pack -name '*.pack' -printf '%n Link(e)  %p\n' 2>/dev/null | head -3
