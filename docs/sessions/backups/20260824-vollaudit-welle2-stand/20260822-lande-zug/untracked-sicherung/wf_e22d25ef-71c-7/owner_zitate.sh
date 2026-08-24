#!/usr/bin/env bash
# Die zwei im CI-Kommentar zitierten Owner-Saetze am ROHTRANSKRIPT gegenlesen.
# OV-Nummern sind kein Autoritaetsbeleg -- der Gegenstand zaehlt.
set -u
F=/tmp/owner_flach.txt
zeige() {   # $1 = Suchbegriff, $2 = Kontextbreite
  local b="$1" w="$2" n
  n=$(/usr/bin/grep -o -i -F "$b" "$F" | wc -l)
  echo "=== '$b' : $n Treffer ==="
  if [ "$n" -gt 0 ]; then
    /usr/bin/grep -o -i -E ".{0,$w}$(printf '%s' "$b" | sed 's/[][\.*^$/]/\\&/g').{0,$w}" "$F" | head -3 | sed 's/^/   .../'
  fi
  echo
}
zeige "HAUPT-ZIEL des Gesamt" 260
zeige "auto befuellen"        200
zeige "auto befüllen"         200
zeige "Latex-Anhaenge"        200
zeige "Latex-Anhänge"         200
zeige "Anhaenge generier"     200
zeige "bei jedem CI neu setzen" 200
