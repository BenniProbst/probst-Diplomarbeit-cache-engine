#!/bin/bash
# Z12 WORKTREE-VORPRUEFUNG wt-ce-o2std (read-only; KEIN rm, KEIN Bau, KEIN Push).
# Verfahren Z11 + O-6-Doktrin: rekursiv, Tips gegen den ECHTEN Remote im HAUPTKLON.
WT=/home/comdare/wt-ce-o2std
HK=/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine
echo "== Z12 WT-VORPRUEFUNG $(date -u +%FT%TZ) =="
echo "-- 1. Kopf/Status --"
echo "HEAD=$(git -C "$WT" rev-parse HEAD) BRANCH=$(git -C "$WT" rev-parse --abbrev-ref HEAD)"
git -C "$WT" status --porcelain > /tmp/z12_st.txt 2>&1
echo "porcelain-zeilen=$(wc -l < /tmp/z12_st.txt)"; sed 's/^/    | /' /tmp/z12_st.txt
echo "stash-eintraege=$(git -C "$WT" stash list | wc -l)"
echo "-- 2. Nested/Submodule (rekursiv) --"
echo "nested-gits-mindepth2=$(find "$WT" -mindepth 2 -name .git \( -type d -o -type f \) 2>/dev/null | wc -l)"
find "$WT" -mindepth 2 -name .git \( -type d -o -type f \) 2>/dev/null | sed 's/^/    /'
echo "submodule status:"; git -C "$WT" submodule status 2>&1 | sed 's/^/    /'
echo "worktree list (aus dem WT gesehen):"; git -C "$WT" worktree list 2>&1 | sed 's/^/    /'
echo "-- 3. ALLE refs/heads-Tips des Stores gegen den ECHTEN Remote im HAUPTKLON --"
echo "origin/development im HAUPTKLON = $(git -C "$HK" rev-parse origin/development)"
echo "Tip bau/o2-standard = $(git -C "$HK" rev-parse bau/o2-standard)"
git -C "$HK" merge-base --is-ancestor bau/o2-standard origin/development
echo "  is-ancestor(bau/o2-standard, origin/development) rc=$?  (0 = enthalten)"
git -C "$HK" merge-base --is-ancestor "$(git -C "$WT" rev-parse HEAD)" origin/development
echo "  is-ancestor(WT-HEAD, origin/development) rc=$?"
echo "-- 4. Mess-Datei-Scan (Verlust-Kandidaten) --"
find "$WT" \( -name '*.csv' -o -name '*.xlsx' \) -not -path '*/_deps/*' -not -path '*/.git/*' > /tmp/z12_csv.txt 2>/dev/null
echo "csv/xlsx-gesamt-ausser-_deps=$(wc -l < /tmp/z12_csv.txt)"
echo "davon-getrackt=$(git -C "$WT" ls-files -- '*.csv' '*.xlsx' | wc -l)"
> /tmp/z12_csv_un.txt
while IFS= read -r f; do
  rel=${f#"$WT"/}
  git -C "$WT" ls-files --error-unmatch -- "$rel" >/dev/null 2>&1 || echo "$f" >> /tmp/z12_csv_un.txt
done < /tmp/z12_csv.txt
echo "UNGETRACKTE-messdateien=$(wc -l < /tmp/z12_csv_un.txt)"; sed 's/^/    VERLUST-KANDIDAT: /' /tmp/z12_csv_un.txt
echo "-- 5. ignored-Bestand --"
git -C "$WT" status --porcelain --ignored > /tmp/z12_ign.txt 2>&1
echo "ignored-zeilen=$(wc -l < /tmp/z12_ign.txt)"; sed 's/^/    | /' /tmp/z12_ign.txt
echo "-- 6. Doppel-Bedingung build/ im WT --"
if [ -d "$WT/build" ]; then
  echo "build-groesse=$(du -sh "$WT/build" | cut -f1)"
  echo "Bedingung-1 getrackt-unter-build=$(git -C "$WT" ls-files -- build | wc -l)"
  echo "Bedingung-2 csv/xlsx-ausserhalb-_deps=$(find "$WT/build" \( -name '*.csv' -o -name '*.xlsx' \) -not -path '*/_deps/*' 2>/dev/null | wc -l)"
  echo "build-inhalt:"; ls -A "$WT/build" | sed 's/^/    /'
else echo "kein build/"; fi
echo "-- 7. Hauptklon-Build-Verzeichnisse: Doppel-Bedingung --"
for d in build build-dbg build-dbg-clang build-l1 build-l1-clang; do
  [ -d "$HK/$d" ] || continue
  echo "$d groesse=$(du -sh "$HK/$d" | cut -f1) getrackt=$(git -C "$HK" ls-files -- "$d" | wc -l) csv_xlsx_ausser_deps=$(find "$HK/$d" \( -name '*.csv' -o -name '*.xlsx' \) -not -path '*/_deps/*' 2>/dev/null | wc -l)"
done
echo "-- 8. df --"; df -h /
echo "== ENDE VORPRUEFUNG =="
