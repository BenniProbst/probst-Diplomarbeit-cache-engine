#!/usr/bin/env bash
# Nenner-Messung: Spaltenzahl und Zeilenzahl je CSV-Form. ASCII-only.
set -u
zeige() {
  local f="$1" etikett="$2"
  [ -f "$f" ] || { echo "FEHLT: $etikett -> $f"; return; }
  local n z
  n=$(awk -F, 'NR==1{print NF; exit}' "$f")
  z=$(awk 'END{print NR+0}' "$f")
  echo "$etikett  SPALTEN=$n  ZEILEN=$z"
  echo "   erste 160 Zeichen der Kopfzeile:"
  awk 'NR==1{print substr($0,1,160); exit}' "$f" | sed 's/^/     /'
}
zeige "$(head -1 /tmp/l_m.txt)"  "LAUF-AGGREGAT   measurements.csv (lokaler 320er-Lauf)"
zeige "$(head -1 /tmp/l_r.txt)"  "PRODUKTION      result.csv       (lokaler 320er-Lauf)"
zeige "$(head -1 /tmp/l_a.txt)"  "ARCHIV          <stem>.result.csv (Erstbeleg im Repo)"
zeige "$(head -1 /tmp/l_km.txt)" "KORPUS-AGGREGAT measurements.csv (Erstbeleg im Repo)"
