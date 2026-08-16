#!/bin/sh
# =============================================================================
#  WORKTREE-REMOVE-WACHE (KON82-02/F4): VOR jedem `git worktree remove` rufen.
#  sh scripts/worktree_remove_wache.sh <repo-root> <worktree-pfad>
#  EXIT 0 = Raeumung erlaubt. EXIT 2 = HARTER ABBRUCH (Befund benannt).
#  Grund (3. Vorfall 16.08., KON79-02): nested Worktrees haengen am
#  Submodul-gitdir unter .git/worktrees/<name>/modules/ und sterben mit.
# =============================================================================
set -u
REPO="${1:?repo-root fehlt}"; WT="${2:?worktree-pfad fehlt}"
NAME=$(basename "$WT")
GITCOMMON=$(git -C "$REPO" rev-parse --git-common-dir 2>/dev/null) || { echo "WACHE ABBRUCH: $REPO kein Repo"; exit 2; }
case "$GITCOMMON" in /*) : ;; *) GITCOMMON="$REPO/$GITCOMMON";; esac
GITDIR="$GITCOMMON/worktrees/$NAME"
[ -d "$GITDIR" ] || { echo "WACHE: $GITDIR fehlt -- Name pruefen"; exit 2; }
# 1) NESTED KINDER: Submodul-gitdirs dieses Worktrees mit eigenen worktrees/
KINDER=$(find "$GITDIR/modules" -type d -name worktrees 2>/dev/null | \
  while read -r d; do find "$d" -mindepth 1 -maxdepth 1 -type d; done)
if [ -n "$KINDER" ]; then
  echo "WACHE ABBRUCH: nested Kind-Worktrees haengen an $NAME:"; echo "$KINDER" | sed 's/^/  /'
  echo "  -> Kinder ZUERST pushen und umhaengen (Hauptklon-Submodul), dann erneut."
  exit 2
fi
# 2) BRANCH DES WORKTREES gelandet? (Tip muss auf einem Remote erreichbar sein)
BR=$(git -C "$WT" branch --show-current 2>/dev/null || true)
TIP=$(git -C "$WT" rev-parse HEAD 2>/dev/null || true)
[ -n "$TIP" ] || { echo "WACHE ABBRUCH: Worktree $WT nicht lesbar"; exit 2; }
GEFUNDEN=0
for R in $(git -C "$WT" remote); do
  if git -C "$WT" branch -r --contains "$TIP" 2>/dev/null | \
    /usr/bin/grep -q "^  $R/"; then GEFUNDEN=1; fi
done
[ "$GEFUNDEN" = 1 ] || { \
  echo "WACHE ABBRUCH: Tip $TIP (Branch '${BR:-detached}') auf KEINEM Remote enthalten -- erst landen/pushen."
  exit 2; }
# 3) SUBMODUL-CHECKOUTS des Worktrees: eigene ungelandete Tips?
git -C "$WT" submodule foreach --quiet \
  'T=$(git rev-parse HEAD); F=0; \
   for R in $(git remote); do \
     git branch -r --contains "$T" 2>/dev/null \
       | /usr/bin/grep -q "^  $R/" && F=1; \
   done; \
   [ "$F" = 1 ] || { echo "WACHE ABBRUCH: Submodul $name Tip $T ungelandet"; exit 2; }' \
  || exit 2
# 4) SCHMUTZ
D=$(git -C "$WT" status --porcelain | wc -l)
[ "$D" = 0 ] || { \
  echo "WACHE ABBRUCH: $D uncommittete/untracked Dateien in $WT -- erst sichern (BU-additiv)."; exit 2; }
echo "WACHE OK: $NAME hat 0 Kinder, Tip remote-enthalten, Submodule gelandet, 0 Schmutz -- Raeumung erlaubt."
exit 0
