#!/usr/bin/env bash
# plan_zahlen_wache VOLLSTAENDIG: Plandokument + ce-Quelle von aussen beigestellt.
# Dann die GEGENPROBE gegen die UNVERAENDERTE .gitlab-ci.yml -- nur so ist belegt,
# dass ein etwaiger Riss von meiner Aenderung kommt (oder eben nicht).
set -u
Z=/home/comdare/wt-super-f1-transport
P=/home/comdare/wt-super-landung/docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md
CEQ=/home/comdare/wt-ce-w0a
cd "$Z" || exit 2
lauf() {   # $1 = Etikett
  COMDARE_PLAN="$P" COMDARE_CE_QUELLE="$CEQ" sh ci/plan_zahlen_wache.sh > "/tmp/pz_$1.txt" 2>&1
  echo "  RC_OHNE_PIPE=$?"
  tail -7 "/tmp/pz_$1.txt" | sed 's/^/  /'
}
echo "== A) MEINE .gitlab-ci.yml (HEAD) =="
lauf neu
echo
echo "== B) GEGENPROBE: die YAML von origin/development =="
git -C "$Z" show origin/development:.gitlab-ci.yml > /tmp/yml_basis.yml
cp .gitlab-ci.yml /tmp/yml_meins.yml
cp /tmp/yml_basis.yml .gitlab-ci.yml
lauf alt
cp /tmp/yml_meins.yml .gitlab-ci.yml
echo
echo "== Arbeitsbaum wiederhergestellt? (muss 'sauber' sein) =="
if git -C "$Z" diff --quiet; then echo "  sauber (HEAD == Arbeitsbaum)"; else echo "  ABWEICHUNG:"; git -C "$Z" diff --stat; fi
rm -f /tmp/yml_basis.yml /tmp/yml_meins.yml
