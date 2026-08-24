#!/bin/bash
# Z11 Per-Worktree-Frisch-Sweep (read-only) der 8 gelandeten Straenge.
# Selbstcheck: kein rm, kein merge, kein push, kein Bau.
echo "== Z11 SWEEP 8 WORKTREES $(date -u +%FT%TZ) =="
for n in s8kopf s13schema pmcpaket vollzug91 ph89 trigfix skip97 kampvor; do
  WT=/home/comdare/wt-ce-$n
  echo "=== $WT ==="
  echo "HEAD=$(git -C "$WT" rev-parse HEAD 2>&1) BRANCH=$(git -C "$WT" rev-parse --abbrev-ref HEAD 2>&1)"
  git -C "$WT" status --porcelain > /tmp/z11_wt_st.txt 2>&1; rc=$?
  echo "status-rc=$rc zeilen=$(wc -l < /tmp/z11_wt_st.txt)"
  sed 's/^/    | /' /tmp/z11_wt_st.txt
  echo "nested-gits (mindepth2):"
  find "$WT" -mindepth 2 -name .git \( -type d -o -type f \) 2>/dev/null | sed 's/^/    /'
  echo "nested-gits-anzahl=$(find "$WT" -mindepth 2 -name .git \( -type d -o -type f \) 2>/dev/null | wc -l)"
  echo "submodule status:"
  git -C "$WT" submodule status 2>&1 | sed 's/^/    /'
  echo "build-verzeichnisse (maxdepth1):"
  find "$WT" -maxdepth 1 -type d -name "build*" 2>/dev/null | sed 's/^/    /'
  echo "wt-groesse=$(du -sh "$WT" 2>/dev/null | cut -f1)"
done
echo "== skip97 DOPPEL-BEDINGUNG build/ =="
SK=/home/comdare/wt-ce-skip97
if [ -d "$SK/build" ]; then
  echo "build-groesse=$(du -sh "$SK/build" 2>/dev/null | cut -f1)"
  git -C "$SK" ls-files -- build > /tmp/z11_sk_ls.txt 2>&1; rc=$?
  echo "Bedingung-1 git-ls-files-rc=$rc getrackte-dateien-unter-build=$(wc -l < /tmp/z11_sk_ls.txt)"
  sed 's/^/    tracked: /' /tmp/z11_sk_ls.txt | head -20
  find "$SK/build" \( -name '*.csv' -o -name '*.xlsx' \) -not -path '*/_deps/*' > /tmp/z11_sk_csv.txt 2>/dev/null
  echo "Bedingung-2 csv/xlsx-ausserhalb-_deps=$(wc -l < /tmp/z11_sk_csv.txt)"
  sed 's/^/    messdatei: /' /tmp/z11_sk_csv.txt | head -20
  echo "csv/xlsx INNERHALB _deps (nur Info)=$(find "$SK/build" \( -name '*.csv' -o -name '*.xlsx' \) -path '*/_deps/*' 2>/dev/null | wc -l)"
else
  echo "kein build/ in skip97 (Stand jetzt)"
fi
echo "== df vor Raeumung =="
df -h /
echo "== ENDE SWEEP =="
