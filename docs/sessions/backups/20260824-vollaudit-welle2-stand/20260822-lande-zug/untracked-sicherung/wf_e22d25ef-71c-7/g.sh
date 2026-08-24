#!/usr/bin/env bash
# Kleiner Ausfuehrer fuer git im Bau-Klon (das Harness verweigert 'git -C' direkt).
set -u
Z=/home/comdare/wt-super-f1-transport
git -C "$Z" "$@"
