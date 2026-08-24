#!/bin/bash
# Z12 RAEUMUNG (K14: eigener Schritt NACH gelesener Pruef-Ausgabe der Vorpruefung).
# Reihenfolge: (1) Doppel-Bedingung ERNEUT messen, (2) rm, (3) PFLICHT-Nachkontrolle
# 'git status --short | grep "^ D"' (ce-Falle: frueher force-added Mess-CSV unter build/).
# Selbstcheck: kein merge, kein push, kein Bau; nur die hier benannten Verzeichnisse.
set -u
HK=/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine
WT=/home/comdare/wt-ce-o2std
echo "== Z12 RAEUMUNG $(date -u +%FT%TZ) =="
echo "-- df VOR --"; df -h /
echo "-- (1) Doppel-Bedingung erneut, unmittelbar vor dem rm --"
for d in build build-dbg build-dbg-clang; do
  echo "$d: groesse=$(du -sh "$HK/$d" 2>/dev/null | cut -f1) getrackt=$(git -C "$HK" ls-files -- "$d" | wc -l) csv_xlsx_ausser_deps=$(find "$HK/$d" \( -name '*.csv' -o -name '*.xlsx' \) -not -path '*/_deps/*' 2>/dev/null | wc -l)"
done
echo "getrackte Pfade mit Praefix build (Repo-weit) = $(git -C "$HK" ls-files | grep -cE '^build')"
echo "-- (2) rm --"
for d in build build-dbg build-dbg-clang; do
  rm -rf "${HK:?}/$d"; echo "rm $d rc=$? weg=$([ -d "$HK/$d" ] && echo NEIN || echo JA)"
done
echo "-- (3) PFLICHT-NACHKONTROLLE: geloeschte getrackte Dateien --"
git -C "$HK" status --short > /tmp/z12_st_nach.txt 2>&1
echo "porcelain-zeilen=$(wc -l < /tmp/z12_st_nach.txt)"
echo "Zeilen mit ' D' (geloeschte getrackte Datei) = $(grep -c '^ D' /tmp/z12_st_nach.txt)"
sed 's/^/    | /' /tmp/z12_st_nach.txt | head -20
echo "-- df NACH rm der Bau-Verzeichnisse --"; df -h /
echo "-- (4) WORKTREE-LOESCHUNG wt-ce-o2std --"
echo "Vorbedingungen (erneut): porcelain=$(git -C "$WT" status --porcelain | wc -l) stash=$(git -C "$WT" stash list | wc -l) nested=$(find "$WT" -mindepth 2 -name .git 2>/dev/null | wc -l)"
git -C "$HK" merge-base --is-ancestor "$(git -C "$WT" rev-parse HEAD)" origin/development
echo "is-ancestor(WT-HEAD, origin/development) rc=$?"
git -C "$HK" worktree remove --force "$WT"; echo "worktree-remove-rc=$?"
echo "verzeichnis-weg=$([ -d "$WT" ] && echo NEIN || echo JA)"
echo "-- (5) Nachlage --"
echo "worktree list (ce-Store):"; git -C "$HK" worktree list | sed 's/^/    /'
echo "Branch-Ref bau/o2-standard bleibt STEHEN (keine Branch-Loeschung ohne Lead-GO): $(git -C "$HK" rev-parse bau/o2-standard)"
echo "Hauptklon porcelain=$(git -C "$HK" status --porcelain | wc -l)"
echo "-- df ENDE --"; df -h /
echo "== ENDE RAEUMUNG =="
