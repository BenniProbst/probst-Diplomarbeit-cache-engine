#!/usr/bin/env bash
# Deckt measurements.csv genau die Vereinigung aller result.csv ab? ASCII-only.
set -u
summe=0
n=0
while IFS= read -r f; do
  [ -n "$f" ] || continue
  z=$(awk 'END{print NR+0}' "$f")
  d=$((z - 1))
  [ "$d" -lt 0 ] && d=0
  summe=$((summe + d))
  n=$((n + 1))
done < /tmp/l_r.txt
echo "NENNER: $n result.csv gelesen"
echo "SUMME Datenzeilen aller result.csv = $summe"
magg=$(head -1 /tmp/l_m.txt)
zagg=$(awk 'END{print NR+0}' "$magg")
echo "measurements.csv Datenzeilen        = $((zagg - 1))"
echo "DIFFERENZ                            = $(( (zagg - 1) - summe ))"
echo
echo "-- Verzeichnis-Layout des lokalen Laufs (erste 6 Pfade) --"
head -3 /tmp/l_r.txt
cat /tmp/l_m.txt
