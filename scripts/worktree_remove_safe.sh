#!/bin/sh
# =============================================================================
# WORKTREE-LOESCH-WACHE: prueft VOR jedem 'git worktree remove', ob irgendwo
# ungelandete Arbeit haengt -- und LOESCHT NIE SELBST.               (scripts/)
# =============================================================================
#
# WARUM ES DIESE DATEI GIBT (KON49-02, 12.08.2026)
#   Am 12.08. wurden elf gelandete Worktrees entfernt; geprueft wurde je Worktree
#   NUR "ist der super-HEAD Vorfahr von origin/development?". Falsch: die Bau-
#   Arbeit liegt fast immer im ce-SUBMODUL, nicht im super-Baum -- der super-HEAD
#   kann gelandet sein, waehrend im Submodul ein ungelandeter Branch haengt (so
#   lag Strang D, nur durch Zufall gerettet). Klasse: Stellvertreter (der
#   super-HEAD wurde fuer "Worktree enthaelt nichts Ungelandetes" genommen).
#
# WAS DIESE WACHE MISST (Verfahren aus KON49-02 + ARBEITSWEISE v3.9/A3)
#   Fuer den zu pruefenden Baum, JE STORE (super UND jedes Submodul, Store per
#   'git rev-parse --git-common-dir' bestimmt -- der Verzeichnisname sagt nichts):
#     (1) git worktree list                 -- welche Baeume der Store fuehrt
#     (2) git for-each-ref refs/heads/       -- ALLE Branch-Tips, nicht nur HEAD
#     (3) je Tip: enthaelt der Remote ihn?   -- nach 'fetch --prune' im MESS-Baum,
#         NIE im Worktree (dessen Refs frieren beim Anlegen ein)
#     (4) git status --porcelain             -- Uncommittetes (unwiederbringlich)
#     (5) git stash list                     -- versteckte Aenderungen
#   Bei JEDEM Befund (ungelandeter Tip / Uncommittetes / Stash): STOP mit Liste,
#   exit 3, NICHTS wird geloescht. Nur wenn ALLES sauber ist, druckt die Wache die
#   Gegenprobe-Anleitung (rev-parse <branch> muss nach 'worktree remove' im Store
#   weiter treffen -- benannte Branches ueberleben, nur Uncommittetes stirbt).
#
# AUSDRUECKLICH KEINE LOESCHUNG: dieses Skript fuehrt NIE 'git worktree remove'
#   aus. Es ist die VOR-Wache; die Loeschung bleibt eine bewusste Handhandlung
#   nach gruenem Befund. (Owner-Doktrin: Loeschung erst nach gruen+gemergt.)
#
# AUFRUF
#   sh scripts/worktree_remove_safe.sh <worktree-pfad> [<remote>]
#     <remote> default: origin
# EXIT
#   0 = sauber (Loeschung waere gefahrlos; Skript loescht trotzdem nicht)
#   2 = Bedienung/Umgebung (kein git, Pfad fehlt) -- NIE eine stille Null
#   3 = BEFUND: irgendwo ungelandete Arbeit -- STOP, nichts anfassen
#
# POSIX-sh, kein bash-ismus, kein Python (Buildchain-Kanon). ASCII-only.
# =============================================================================

set -u
LC_ALL=C
export LC_ALL

REMOTE_DEFAULT="origin"

fatal() { echo "WORKTREE-LOESCH-WACHE: ABBRUCH -- $1" >&2; exit 2; }

command -v git >/dev/null 2>&1 || fatal "git ist nicht im PATH."

[ "$#" -ge 1 ] || fatal "AUFRUF: sh scripts/worktree_remove_safe.sh <worktree-pfad> [<remote>]"
WT="$1"
REMOTE="${2:-$REMOTE_DEFAULT}"
[ -d "$WT" ] || fatal "Worktree-Pfad '$WT' ist kein Verzeichnis."

# Absoluter Pfad (kein cd im Compound -- Berechtigungs-Falle vermeiden).
WT_ABS=$(CDPATH= cd -- "$WT" && pwd) || fatal "Worktree-Pfad nicht aufloesbar."

echo "============================================================================="
echo " WORKTREE-LOESCH-WACHE  Baum: $WT_ABS  Remote: $REMOTE"
echo " (misst je Store super UND jedes Submodul; loescht NIE selbst)"
echo "============================================================================="

BEFUND=0

# -- Store-Liste bestimmen: super-Store + je Submodul der eigene Store ---------
# git -C <baum> rev-parse --git-common-dir gibt den super-Store; jedes Submodul
# hat unter .git/modules/... bzw. .git/worktrees/<name>/modules/... einen eigenen.
SUPER_COMMON=$(git -C "$WT_ABS" rev-parse --git-common-dir 2>/dev/null) \
    || fatal "'$WT_ABS' ist kein git-Arbeitsbaum (rev-parse --git-common-dir schlug fehl)."

echo ""
echo "STORE super  (git-common-dir: $SUPER_COMMON)"
pruefe_store() {
    # $1 = Arbeitsbaum-Pfad, der diesen Store bedient; $2 = Etikett
    _p="$1"; _lab="$2"

    echo "  [$_lab] git worktree list:"
    git -C "$_p" worktree list 2>/dev/null | sed 's/^/    /' \
        || echo "    (worktree list nicht verfuegbar)"

    # (3) MESS-Baum: fetch --prune, damit die Remote-Sicht frisch ist. NIE im
    # Worktree selbst (dessen Refs frieren ein) -- wir messen ueber den Store, der
    # git-common-dir traegt die frischen Remotes.
    git -C "$_p" fetch --prune "$REMOTE" >/dev/null 2>&1 \
        || echo "    WARN [$_lab]: fetch --prune $REMOTE fehlgeschlagen -- Remote-Sicht evtl. alt."

    # (2)+(3) jeden lokalen Tip gegen den Remote pruefen.
    _tips=$(git -C "$_p" for-each-ref --format='%(refname:short) %(objectname)' refs/heads/ 2>/dev/null)
    if [ -n "$_tips" ]; then
        echo "  [$_lab] Branch-Tips gegen $REMOTE:"
        # POSIX: Zeilenweise ueber IFS, ohne Pipe-Subshell (rc-Falle K11 vermeiden).
        _oldifs=$IFS
        IFS='
'
        for _line in $_tips; do
            _br=${_line%% *}
            _sha=${_line##* }
            # Enthaelt IRGENDEIN Remote-Branch diesen Commit?
            if git -C "$_p" branch -r --contains "$_sha" 2>/dev/null | grep -q "$REMOTE/"; then
                echo "    OK       $_br ($_sha) -- im Remote enthalten"
            else
                echo "    UNGELANDET $_br ($_sha) -- NICHT im Remote $REMOTE"
                BEFUND=1
            fi
        done
        IFS=$_oldifs
    fi

    # (4) Uncommittetes.
    _dirty=$(git -C "$_p" status --porcelain 2>/dev/null)
    if [ -n "$_dirty" ]; then
        echo "  [$_lab] UNCOMMITTET (status --porcelain):"
        printf '%s\n' "$_dirty" | sed 's/^/    /'
        BEFUND=1
    fi

    # (5) Stash.
    _stash=$(git -C "$_p" stash list 2>/dev/null)
    if [ -n "$_stash" ]; then
        echo "  [$_lab] STASH (stash list):"
        printf '%s\n' "$_stash" | sed 's/^/    /'
        BEFUND=1
    fi
}

pruefe_store "$WT_ABS" "super"

# -- Submodule desselben Worktrees ---------------------------------------------
# 'git submodule status' listet die eingebundenen Submodule; jedes bedient einen
# EIGENEN Store. Wir pruefen jeden als eigenen Arbeitsbaum.
_subs=$(git -C "$WT_ABS" submodule status 2>/dev/null | awk '{print $2}')
if [ -n "$_subs" ]; then
    _oldifs2=$IFS
    IFS='
'
    for _sub in $_subs; do
        _subpath="$WT_ABS/$_sub"
        if [ ! -d "$_subpath" ]; then
            echo ""
            echo "STORE submodul $_sub  -- Pfad fehlt (uninitialisiert?), uebersprungen"
            continue
        fi
        _subcommon=$(git -C "$_subpath" rev-parse --git-common-dir 2>/dev/null) || _subcommon="(unbestimmt)"
        echo ""
        echo "STORE submodul $_sub  (git-common-dir: $_subcommon)"
        pruefe_store "$_subpath" "sub:$_sub"
    done
    IFS=$_oldifs2
else
    echo ""
    echo "(keine Submodule im Worktree gemeldet)"
fi

echo ""
echo "============================================================================="
if [ "$BEFUND" -ne 0 ]; then
    echo " BEFUND: ungelandete Arbeit ODER Uncommittetes ODER Stash gefunden."
    echo " STOP -- es wurde NICHTS geloescht. Erst landen/sichern, dann erneut pruefen."
    echo "============================================================================="
    exit 3
fi

echo " SAUBER: kein ungelandeter Tip, kein Uncommittetes, kein Stash gefunden."
echo " Loeschung waere gefahrlos -- dieses Skript loescht NICHT selbst."
echo " Nach einem manuellen 'git worktree remove' je Store gegenpruefen:"
echo "   git -C <store-baum> rev-parse <branch>   MUSS weiter treffen"
echo "   (benannte Branches ueberleben remove; nur Uncommittetes stirbt)."
echo "============================================================================="
exit 0
