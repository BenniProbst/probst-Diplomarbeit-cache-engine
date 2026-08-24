#!/usr/bin/env bash
# Die im CI-Kommentar zitierten Owner-Saetze am ROHTRANSKRIPT gegenlesen.
# Feste Zeichenketten, kein Regex ueber eine 48-MB-Einzelzeile (das war zu langsam).
# NIE nach Token-WERTEN -- nur nach Sachbegriffen.
set -u
D=/home/comdare/.claude/projects/-home-comdare
N=0
for f in "$D"/*.jsonl; do N=$((N+1)); done
echo "NENNER: $N Transkripte"
pruefe() {  # $1 = Zeichenkette
  local n
  n=$(/usr/bin/grep -a -o -i -F -- "$1" "$D"/*.jsonl 2>/dev/null | wc -l)
  printf '  %-46s %s\n' "$1" "$n"
}
echo "== die zwei im CI-Kommentar zitierten Owner-Saetze =="
pruefe "HAUPT-ZIEL des Gesamt-Systems"
pruefe "Auswertungsautomatisierung aus der xml-Kette"
pruefe "auto befuellen"
pruefe "bei jedem CI neu setzen"
echo "== GEGENPROBE (muss > 0 sein) =="
pruefe "anhang:forward"
pruefe "measurements.csv"
echo "== GEGENPROBE NEGATIV (muss 0 sein) =="
pruefe "zzz-diese-zeichenkette-gibt-es-nicht-4711"
