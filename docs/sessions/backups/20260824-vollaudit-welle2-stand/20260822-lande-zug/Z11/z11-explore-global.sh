#!/bin/bash
# Z11 EXPLORE global (read-only): ce-Hauptklon Refs + Ancestor-Beweise + CI 286
# Selbstcheck: kein rm, kein merge, kein push, kein Bau. rc je Messung explizit.
CE=/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine
EV=/home/comdare/backups-workflow/20260822-lande-zug/Z11
echo "== Z11 EXPLORE GLOBAL $(date -u +%FT%TZ) =="
echo "-- fetch origin --prune --"
git -C "$CE" fetch origin --prune 2>&1; echo "fetch-origin-rc=$?"
echo "-- fetch github --prune --"
git -C "$CE" fetch github --prune 2>&1; echo "fetch-github-rc=$?"
echo "-- refs --"
for r in development origin/development github/development lande/w2-s1s2; do
  s=$(git -C "$CE" rev-parse "$r" 2>&1); echo "ref $r = $s"
done
echo "-- status Hauptklon-Checkout --"
git -C "$CE" status --porcelain > /tmp/z11_st.txt 2>&1; echo "status-rc=$? zeilen=$(wc -l < /tmp/z11_st.txt)"
echo "-- stash (repo-global) --"
git -C "$CE" stash list 2>&1; echo "stash-rc=$?"
echo "-- worktree list --"
git -C "$CE" worktree list 2>&1
echo "-- 8 Strang-Tips: Branch-Ref + is-ancestor gegen origin/development --"
DEV=$(git -C "$CE" rev-parse origin/development)
echo "origin/development voll = $DEV"
declare -A T=( [s8kopf]=41ee8780 [s13schema]=c76d3116 [pmcpaket]=1d38263b [vollzug91]=6713156b [ph89]=2809e4d4 [trigfix]=0f900dcf [skip97]=1c9f58a5 [kampvor]=1e1bc199 )
for n in s8kopf s13schema pmcpaket vollzug91 ph89 trigfix skip97 kampvor; do
  ref=$(git -C "$CE" rev-parse "refs/heads/bau/$n" 2>&1); rc1=$?
  git -C "$CE" merge-base --is-ancestor "${T[$n]}" origin/development; rc2=$?
  echo "strang bau/$n: head=$ref (rc=$rc1) erwartet=${T[$n]} ancestor-of-origin/dev-rc=$rc2"
done
echo "-- CI 286: Pipelines am dev-Tip --"
curl -sk -K /home/comdare/.claude/jobs/5a19728e/tmp/glhdr.curlrc \
  "https://gitlab.comdare.local/api/v4/projects/286/pipelines?sha=$DEV&per_page=10" \
  -o "$EV/ci-pipelines-am-devtip.json"; echo "curl-pipelines-rc=$?"
if command -v jq >/dev/null; then
  jq -r '.[] | "pipeline id=\(.id) status=\(.status) sha=\(.sha) created=\(.created_at)"' "$EV/ci-pipelines-am-devtip.json"
  PID=$(jq -r '.[0].id' "$EV/ci-pipelines-am-devtip.json")
  curl -sk -K /home/comdare/.claude/jobs/5a19728e/tmp/glhdr.curlrc \
    "https://gitlab.comdare.local/api/v4/projects/286/pipelines/$PID/jobs?per_page=100" \
    -o "$EV/ci-jobs-$PID.json"; echo "curl-jobs-rc=$?"
  curl -sk -K /home/comdare/.claude/jobs/5a19728e/tmp/glhdr.curlrc \
    "https://gitlab.comdare.local/api/v4/projects/286/pipelines/$PID/bridges?per_page=100" \
    -o "$EV/ci-bridges-$PID.json"; echo "curl-bridges-rc=$?"
  echo "jobs-nenner=$(jq length "$EV/ci-jobs-$PID.json") bridges-nenner=$(jq length "$EV/ci-bridges-$PID.json")"
  jq -r 'group_by(.status) | .[] | "\(.[0].status): \(length)"' "$EV/ci-jobs-$PID.json"
else
  echo "jq FEHLT - JSON liegt als Kopie in $EV"
fi
echo "== ENDE EXPLORE GLOBAL =="
