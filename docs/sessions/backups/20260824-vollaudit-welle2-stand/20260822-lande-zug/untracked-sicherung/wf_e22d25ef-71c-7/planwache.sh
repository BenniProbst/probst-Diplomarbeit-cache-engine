#!/usr/bin/env bash
# plan_zahlen_wache gegen MEINE .gitlab-ci.yml, aber mit dem Plandokument aus
# wt-super-landung (mein Klon ist sparse; das Fehlen ist ein Messartefakt, kein Defekt).
# Gegenprobe darunter: dieselbe Wache gegen die UNVERAENDERTE YAML.
set -u
Z=/home/comdare/wt-super-f1-transport
P=/home/comdare/wt-super-landung/docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md
cd "$Z" || exit 2
echo "== MEINE YAML =="
COMDARE_PLAN="$P" sh ci/plan_zahlen_wache.sh > /tmp/pz_neu.txt 2>&1
echo "  RC_OHNE_PIPE=$?"
tail -8 /tmp/pz_neu.txt | sed 's/^/  /'
