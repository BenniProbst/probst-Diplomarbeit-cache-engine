#!/usr/bin/env bash
# Was liest sonst noch die .gitlab-ci.yml? Diese Wachen mitfahren, weil ich
# einen Kommentarblock darin geaendert habe. Exit je Wache OHNE Pipe (K11).
set -u
Z=/home/comdare/wt-super-f1-transport
cd "$Z" || exit 2
echo "== NENNER: super-eigene .sh, die .gitlab-ci.yml lesen =="
/usr/bin/grep -l -F 'gitlab-ci.yml' ci/*.sh ci/tests/*.sh scripts/*.sh 2>/dev/null | sed 's/^/  /'
echo
echo "== 1. YAML parsebar? (python3 yaml, wenn vorhanden) =="
if command -v python3 >/dev/null 2>&1; then
  python3 - <<'PY'
import sys
try:
    import yaml
except Exception as e:
    print("  UEBERSPRUNGEN: kein PyYAML (%s)" % e); sys.exit(0)
d = yaml.safe_load(open("/home/comdare/wt-super-f1-transport/.gitlab-ci.yml"))
print("  OK: %d Top-Level-Schluessel" % len(d))
print("  anhang:forward vorhanden      :", "anhang:forward" in d)
print("  test:anhang-forward-probe da  :", "test:anhang-forward-probe" in d)
PY
else
  echo "  UEBERSPRUNGEN: kein python3"
fi
echo
for w in ci/tests_registrierung_wache.sh ci/plan_zahlen_wache.sh; do
  [ -x "$w" ] || { echo "== $w: nicht ausfuehrbar, uebersprungen =="; continue; }
  echo "== $w =="
  sh "$w" > "/tmp/w_$(basename "$w").log" 2>&1
  rc=$?
  echo "  RC_OHNE_PIPE=$rc"
  tail -6 "/tmp/w_$(basename "$w").log" | sed 's/^/  /'
  echo
done
for p in ci/tests/durchstich_bissprobe.sh; do
  echo "== $p --selbstbiss =="
  sh "$p" --selbstbiss > "/tmp/p_$(basename "$p").log" 2>&1
  rc=$?
  echo "  RC_OHNE_PIPE=$rc"
  /usr/bin/grep -E "NENNER|SELBSTBISS|OK \(|GERISSEN" "/tmp/p_$(basename "$p").log" | sed 's/^/  /'
done
