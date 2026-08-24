#!/bin/bash
# Z11 PRUEF-2 (read-only): ignored-Bestand + Mess-Datei-Scan je Strang-Worktree,
# ph89: Doppel-Bedingung fuer build/. Kein rm in diesem Script.
echo "== Z11 PRUEF-2 $(date -u +%FT%TZ) =="
for n in s8kopf s13schema pmcpaket vollzug91 ph89 trigfix skip97 kampvor; do
  WT=/home/comdare/wt-ce-$n
  echo "=== $WT ==="
  git -C "$WT" status --porcelain --ignored > /tmp/z11_ign.txt 2>&1; rc=$?
  echo "status--ignored-rc=$rc zeilen=$(wc -l < /tmp/z11_ign.txt)"
  sed 's/^/    | /' /tmp/z11_ign.txt | head -25
  find "$WT" \( -name '*.csv' -o -name '*.xlsx' \) -not -path '*/_deps/*' -not -path '*/.git/*' > /tmp/z11_csv.txt 2>/dev/null
  echo "csv/xlsx-ganzer-baum-ausser-_deps: getrackte+untracked gesamt=$(wc -l < /tmp/z11_csv.txt)"
  # davon getrackt (gehen mit dem Worktree verlustfrei, Inhalt liegt im Repo):
  git -C "$WT" ls-files -- '*.csv' '*.xlsx' > /tmp/z11_csv_tracked.txt 2>/dev/null
  echo "davon-getrackt-im-index=$(wc -l < /tmp/z11_csv_tracked.txt)"
  # NICHT getrackte Mess-Dateien waeren Verlust -> muessen 0 sein oder gesichert werden:
  > /tmp/z11_csv_untracked.txt
  while IFS= read -r f; do
    rel=${f#"$WT"/}
    git -C "$WT" ls-files --error-unmatch -- "$rel" >/dev/null 2>&1 || echo "$f" >> /tmp/z11_csv_untracked.txt
  done < /tmp/z11_csv.txt
  echo "UNGETRACKTE-messdateien=$(wc -l < /tmp/z11_csv_untracked.txt)"
  sed 's/^/    VERLUST-KANDIDAT: /' /tmp/z11_csv_untracked.txt
done
echo "== ph89 DOPPEL-BEDINGUNG build/ =="
PH=/home/comdare/wt-ce-ph89
if [ -d "$PH/build" ]; then
  echo "build-groesse=$(du -sh "$PH/build" 2>/dev/null | cut -f1)"
  git -C "$PH" ls-files -- build > /tmp/z11_ph_ls.txt 2>&1; rc=$?
  echo "Bedingung-1 git-ls-files-rc=$rc getrackte-dateien-unter-build=$(wc -l < /tmp/z11_ph_ls.txt)"
  sed 's/^/    tracked: /' /tmp/z11_ph_ls.txt | head -20
  find "$PH/build" \( -name '*.csv' -o -name '*.xlsx' \) -not -path '*/_deps/*' > /tmp/z11_ph_csv.txt 2>/dev/null
  echo "Bedingung-2 csv/xlsx-ausserhalb-_deps=$(wc -l < /tmp/z11_ph_csv.txt)"
  sed 's/^/    messdatei: /' /tmp/z11_ph_csv.txt | head -20
  echo "csv/xlsx INNERHALB _deps (nur Info)=$(find "$PH/build" \( -name '*.csv' -o -name '*.xlsx' \) -path '*/_deps/*' 2>/dev/null | wc -l)"
  echo "build-inhalt (top-level):"
  ls "$PH/build" 2>/dev/null | sed 's/^/    /'
else
  echo "kein build/ in ph89 (Stand jetzt)"
fi
echo "== ENDE PRUEF-2 =="
