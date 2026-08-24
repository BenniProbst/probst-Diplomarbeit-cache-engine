#!/usr/bin/env bash
# ZEHN-WOCHEN-EXPLORE: Owner-Worte zum Anhang-Vorwaerts-Kanal aus den Rohtranskripten.
# DREI-PFAD-UNION (promptSource | queued_command | queue-operation), gegen eine
# GEFLACHTE Kopie gesucht. NIE nach Token-WERTEN -- nur nach Begriffen.
set -u
AUS=/tmp/owner_worte.txt
: > "$AUS"
N_DAT=0
for f in /home/comdare/.claude/projects/-home-comdare/*.jsonl; do
  N_DAT=$((N_DAT + 1))
  /usr/bin/grep -a -E '"promptSource"|"queued_command"|queue-operation' "$f" >> "$AUS" || true
done
echo "NENNER: $N_DAT Transkripte durchsucht"
echo "Owner-Eintraege (Zeilen): $(awk 'END{print NR+0}' "$AUS")"
echo "Groesse: $(du -sh "$AUS" | awk '{print $1}')"
tr '\n' ' ' < "$AUS" > /tmp/owner_flach.txt
echo
echo "== BEGRIFFS-ZAEHLUNG (/usr/bin/grep -o -i -F | wc -l, geflachte Kopie) =="
for b in "anhang" "Anhaenge" "Anhänge" "Overleaf" "Thesis-Submodul" "Submodul" \
         "Tabellen" "tabellen" "Diplomarbeit-PDF" "289" "Auswertungsautomatisierung" \
         "result.csv" "appendix" "vorwaerts" "vorwärts" "HAUPT-ZIEL" "Haupt-Ziel"; do
  n=$(/usr/bin/grep -o -i -F "$b" /tmp/owner_flach.txt | wc -l)
  printf '  %-28s %s\n' "$b" "$n"
done
echo
echo "== GEGENPROBE (muss > 0 sein, sonst ist das Kommando kaputt) =="
for b in "messung" "csv" "pipeline"; do
  n=$(/usr/bin/grep -o -i -F "$b" /tmp/owner_flach.txt | wc -l)
  printf '  %-28s %s\n' "$b" "$n"
done
