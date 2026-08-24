#!/usr/bin/env bash
set -u
Z=/home/comdare/wt-super-f1-transport
echo "origin/development JETZT = $(git -C "$Z" rev-parse origin/development)"
echo "44b49194 ist Vorfahr?      "
git -C "$Z" merge-base --is-ancestor 44b491941fee4e5a6a28bade91539f6308b77aec origin/development && echo "  JA" || echo "  NEIN"
echo "912466a2 ist Vorfahr?      "
git -C "$Z" merge-base --is-ancestor 912466a262ac459e9a9eb3c20899e3f8a36e2fc2 origin/development && echo "  JA" || echo "  NEIN"
echo
echo "-- Commits seit 44b49194 --"
git -C "$Z" log --oneline 44b491941fee4e5a6a28bade91539f6308b77aec..origin/development
echo
echo "-- beruehren sie ci/anhang* oder .gitlab-ci.yml? --"
git -C "$Z" diff --name-only 44b491941fee4e5a6a28bade91539f6308b77aec origin/development
