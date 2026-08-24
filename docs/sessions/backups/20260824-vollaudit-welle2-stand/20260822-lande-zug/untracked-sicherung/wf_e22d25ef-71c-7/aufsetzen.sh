#!/usr/bin/env bash
# Baustelle aufsetzen: sparse auf ci/ + docs/plaene, Zweig f1/20-d3-6-transport.
set -eu
Z=/home/comdare/wt-super-f1-transport
git -C "$Z" sparse-checkout init --cone
git -C "$Z" sparse-checkout set ci
git -C "$Z" checkout -q -b f1/20-d3-6-transport origin/development
echo "HEAD      = $(git -C "$Z" rev-parse HEAD)"
echo "Zweig     = $(git -C "$Z" rev-parse --abbrev-ref HEAD)"
echo "Basis     = origin/development = $(git -C "$Z" rev-parse origin/development)"
echo "materialisiert:"
ls "$Z"
echo "Groesse Arbeitsbaum ohne .git:"
du -sh --exclude=.git "$Z" | tail -1
echo "-- Byte-Gleichheit mit wt-super-landung --"
for f in ci/anhang_forward_core.sh ci/tests/anhang_forward_probe.sh ci/wide_aggregat.sh; do
  if cmp -s "$Z/$f" "/home/comdare/wt-super-landung/$f"; then
    echo "  GLEICH  $f"
  else
    echo "  ABWEICHEND  $f"
  fi
done
