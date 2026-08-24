#!/usr/bin/env bash
set -u
Z=/home/comdare/wt-super-f1-transport
echo "== BAUSTELLE =="
echo "  Pfad   : $Z   (KLON, kein git-worktree -- das Harness verweigert worktree add)"
echo "  Zweig  : $(git -C "$Z" rev-parse --abbrev-ref HEAD)"
echo "  HEAD   : $(git -C "$Z" rev-parse HEAD)"
echo "  Basis  : origin/development = $(git -C "$Z" rev-parse origin/development)"
echo "  Bereich: $(git -C "$Z" rev-list --count origin/development..HEAD) Commit(s)"
echo "  status : $(git -C "$Z" status --porcelain | wc -l) geaenderte Pfade (0 = sauber)"
echo "  sparse : $(git -C "$Z" sparse-checkout list | tr '\n' ' ')"
echo "  Groesse: $(du -sh "$Z" | awk '{print $1}') gesamt, davon .git $(du -sh "$Z/.git" | awk '{print $1}')"
echo
echo "  SO HOLT DER LEAD DEN ZWEIG:"
echo "    git -C <super-worktree> fetch $Z f1/20-d3-6-transport:f1/20-d3-6-transport"
echo
echo "== DIFF =="
git -C "$Z" diff --stat origin/development..HEAD
echo
echo "== PLATTE =="
df -h / | tail -1
