#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  MESS-AUSBEUTE-WACHE -- ein Messlauf gilt erst als gelungen, wenn er MESSWERTE
#  erzeugt hat, nicht schon, wenn er eine Datei erzeugt hat.   (2026-08-08)
# =============================================================================
#
# DER BEFUND, GEGEN DEN SIE GEBAUT IST (Gesamtstand-Workflow 08.08.2026, D3):
# Der Voll-Messlauf prueft als Erfolgsbedingung ausschliesslich, dass IRGENDEINE
# Datei namens measurements.csv existiert:
#
#     echo "== Mess-CSVs (Beleg) =="; find measure_out -name 'measurements.csv' \
#         -exec sh -c 'echo "  $1: $(wc -l < "$1") Zeilen"' _ {} \;
#     test -n "$(find measure_out -name 'measurements.csv' | head -1)" || { ... exit 1; }
#
# Die Zeilenzahl wird EINE ZEILE DARUEBER ausgegeben -- und nirgends geprueft.
# Eine measurements.csv mit ausschliesslich der Kopfzeile, oder mit null Zeilen,
# besteht dieses Gate. Der Job endet mit "OK (golden-320 gemessen)", ohne einen
# einzigen Messwert erzeugt zu haben; der nachgelagerte persist:measurements
# schreibt die leeren CSVs additiv zurueck.
#
# Das ist genau die Fehlerklasse dieses Tages, an der teuersten Stelle: eine
# Wache, deren Nenner nicht das misst, was sie zusichert. Verwandte Faelle vom
# selben Tag: die cppcheck-Anzeige (rotes Verdikt, leere Liste), der nie
# gelaufene build:clang-Job, das Drift-Gate bei median==0.
#
# WARUM EIN SKRIPT UND NICHT ZWEI GEHEILTE ZEILEN:
# Die Stelle existiert ZWEIMAL (measure:smoke und measure:golden-320) und war
# beide Male gleich falsch -- kopierter Code kopiert den Defekt mit. Eine Regel,
# die nur im Kopf existiert, wird unter Takt zuerst fallengelassen; deshalb steht
# sie jetzt in einem Werkzeug, das beide Jobs aufrufen.
#
# AUFRUF:
#   sh ci/mess_ausbeute_wache.sh <verzeichnis> [<mindest-datenzeilen>]
#
#   <verzeichnis>          Wurzel, unter der rekursiv nach measurements.csv gesucht wird.
#   <mindest-datenzeilen>  Optional. Summe der Datenzeilen ueber ALLE gefundenen CSVs,
#                          die mindestens erreicht sein muss. Default 1.
#
# EXIT: 0 = es wurden Messwerte erzeugt (mit Nenner belegt)
#       1 = keine CSV, oder keine einzige Datenzeile, oder Mindestzahl verfehlt
#       2 = die Wache konnte nicht pruefen (Verzeichnis fehlt, Argument fehlt) --
#           ausdruecklich KEIN Gruen: ein stiller Rueckfall waere derselbe Defekt.
#
# ZAEHLWEISE, ausdruecklich benannt:
#   Datenzeilen = (Zeilen der Datei) - 1, weil die erste Zeile der CSV-Kopf ist.
#   Gezaehlt wird mit awk 'END{print NR}', NICHT mit `wc -l`: wc zaehlt
#   Zeilenumbrueche, eine Datei ohne abschliessenden Newline wuerde eine Zeile zu
#   wenig melden. Eine voellig leere Datei hat 0 Zeilen und damit 0 Datenzeilen
#   (nicht -1) -- der Sonderfall ist unten ausdruecklich behandelt.
#
# POSIX-sh, ASCII-only, kein Python (Hausdoktrin: kein Python in der Buildchain).
# =============================================================================

set -eu

WURZEL="${1:-}"
MINDEST="${2:-1}"

if [ -z "$WURZEL" ]; then
    echo "AUFRUF: sh ci/mess_ausbeute_wache.sh <verzeichnis> [<mindest-datenzeilen>]" >&2
    exit 2
fi
if [ ! -d "$WURZEL" ]; then
    echo "ABBRUCH: '$WURZEL' ist kein Verzeichnis -- die Wache konnte nicht pruefen." >&2
    echo "         Kein Gruen ohne Pruefung." >&2
    exit 2
fi
case "$MINDEST" in
    ''|*[!0-9]*) echo "ABBRUCH: '<mindest-datenzeilen>' muss eine Zahl sein, war '$MINDEST'." >&2; exit 2 ;;
esac

TMP=$(mktemp) || exit 2
trap 'rm -f "$TMP"' EXIT INT TERM

find "$WURZEL" -type f -name 'measurements.csv' > "$TMP" 2>/dev/null || true

N_CSV=$(awk 'END{print NR+0}' "$TMP")

echo "-----------------------------------------------------------------------------"
echo "MESS-AUSBEUTE-WACHE   Wurzel=$WURZEL   Mindest-Datenzeilen=$MINDEST"
echo "-----------------------------------------------------------------------------"

if [ "$N_CSV" -eq 0 ]; then
    echo "  KEINE measurements.csv unter '$WURZEL' gefunden." >&2
    echo "FEHLER: der Messlauf hat nichts erzeugt (0 CSV-Dateien)." >&2
    exit 1
fi

SUMME=0
N_LEER=0
N_MIT=0
while IFS= read -r F; do
    [ -n "$F" ] || continue
    ZEILEN=$(awk 'END{print NR+0}' "$F")
    if [ "$ZEILEN" -le 1 ]; then
        DATEN=0
        N_LEER=$((N_LEER + 1))
        echo "  LEER   $F  ($ZEILEN Zeile(n) = nur Kopf oder gar nichts)"
    else
        DATEN=$((ZEILEN - 1))
        N_MIT=$((N_MIT + 1))
        echo "  DATEN  $F  ($DATEN Datenzeile(n))"
    fi
    SUMME=$((SUMME + DATEN))
done < "$TMP"

echo "-----------------------------------------------------------------------------"
echo "NENNER (nie eine nackte Null):"
echo "  $N_CSV measurements.csv gefunden."
echo "  davon $N_MIT mit Datenzeilen, $N_LEER ohne (nur Kopfzeile oder leer)."
echo "  $SUMME Datenzeile(n) insgesamt, gefordert waren mindestens $MINDEST."
echo "-----------------------------------------------------------------------------"

if [ "$SUMME" -lt "$MINDEST" ]; then
    echo "FEHLER: der Messlauf hat $SUMME Datenzeile(n) erzeugt, gefordert waren $MINDEST." >&2
    echo "        Eine vorhandene Datei ist KEIN Messwert. Der Lauf gilt als gescheitert." >&2
    exit 1
fi

# Teil-Ausbeute ist kein Abbruch, aber sie muss SICHTBAR sein: eine leere CSV
# neben vollen ist ein echter Befund (ein Pruefling hat nichts geliefert) und
# darf nicht in einer Erfolgsmeldung verschwinden. Der Owner-KERN dazu lautet:
# "In der Wissenschaft geht nicht immer alles glatt, aber das muss SICHTBAR sein."
if [ "$N_LEER" -gt 0 ]; then
    echo "WARNUNG: $N_LEER von $N_CSV CSV-Dateien tragen KEINE Datenzeile."
    echo "         Der Lauf gilt als gelungen, aber diese Pruefling(e) haben nichts geliefert."
    echo "         Das ist ein Befund, kein Rauschen -- er gehoert in die Auswertung."
fi

echo "MESS-AUSBEUTE-WACHE: OK ($SUMME Datenzeile(n) aus $N_MIT von $N_CSV Datei(en))."
exit 0
