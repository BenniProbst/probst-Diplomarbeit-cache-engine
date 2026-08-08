#!/bin/sh
# =============================================================================
#  LEDGER-NACHTRAG: fuegt einen Nachtrag NACH DEM KOPF ein, nicht ans Dateiende
#  (scripts/ledger_nachtrag.sh)
# =============================================================================
#
# WARUM ES DIESES SKRIPT GIBT (08.08.2026):
# Die Doktrin sagt seit dem 06.08. in B.3: "SSOT/Ledger ... (Nachtraege RUECKWAERTS,
# neueste oben)". Am 08.08. wurden SIEBEN Nachtraege per `cat >>` ans DATEIENDE
# gehaengt -- bei 12167 Zeilen findet sie dort niemand. Das Audit gegen die
# GESAMT-DOKTRIN v3 nannte den Grund (Luecke L8): die Regel beschreibt eine
# EIGENSCHAFT ("neueste oben"), aber keinen MECHANISMUS. Eine Eigenschaft muss
# man sich merken, einen Einfuegepunkt nicht.
#
# Das ist dieselbe Klasse wie die uebrigen Befunde des Tages: eine Regel, die
# nur im Kopf existiert, wird unter Takt zuerst fallengelassen. Deshalb steht
# sie jetzt in einem Werkzeug.
#
# AUFRUF:
#   sh scripts/ledger_nachtrag.sh <datei-mit-dem-nachtrag>
#   ... | sh scripts/ledger_nachtrag.sh -          # aus einer Pipe
#
# EXIT: 0 = eingefuegt. 1 = Aufrufsfehler. 2 = ABBRUCH (Kopf nicht bestimmbar,
#       Ledger fehlt, oder die Gegenprobe nach dem Schreiben schlaegt fehl) --
#       ausdruecklich KEIN Gruen: der Ledger bleibt dann unangetastet.
#
# POSIX-sh, kein bash-ismus, kein Python (Hausdoktrin: kein Python in der
# Buildchain). ASCII-only.
# =============================================================================

set -eu

LEDGER="docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md"

if [ $# -ne 1 ]; then
    echo "AUFRUF: sh scripts/ledger_nachtrag.sh <datei|->" >&2
    exit 1
fi

if [ ! -f "$LEDGER" ]; then
    echo "ABBRUCH: $LEDGER nicht gefunden -- im Repo-Wurzelordner aufrufen." >&2
    exit 2
fi

# -- Nachtrag einlesen (Datei oder stdin) -------------------------------------
TMP_NEU=$(mktemp) || exit 2
TMP_OUT=$(mktemp) || exit 2
trap 'rm -f "$TMP_NEU" "$TMP_OUT"' EXIT INT TERM

if [ "$1" = "-" ]; then
    cat > "$TMP_NEU"
else
    [ -f "$1" ] || { echo "ABBRUCH: $1 nicht gefunden." >&2; exit 2; }
    cat "$1" > "$TMP_NEU"
fi

NEU_ZEILEN=$(wc -l < "$TMP_NEU")
if [ "$NEU_ZEILEN" -eq 0 ]; then
    echo "ABBRUCH: der Nachtrag ist LEER -- ein leerer Einschub waere ein stiller No-Op." >&2
    exit 2
fi

# -- DEN EINFUEGEPUNKT BESTIMMEN, NICHT RATEN ---------------------------------
# Der Kopf ist: Zeile 1 (Ueberschrift) + der zusammenhaengende Block aus
# '>'-Zitatzeilen und Leerzeilen. Der Einfuegepunkt ist die erste Zeile danach.
# Wir suchen sie, statt eine feste Zahl zu nehmen -- der Kopf waechst.
EINFUEG=$(awk '
    NR == 1 { next }
    /^>/    { next }
    /^[[:space:]]*$/ { next }
    { print NR; exit }
' "$LEDGER")

if [ -z "$EINFUEG" ]; then
    echo "ABBRUCH: Kopf-Ende nicht bestimmbar -- der Ledger bleibt unangetastet." >&2
    exit 2
fi

GESAMT=$(wc -l < "$LEDGER")

# -- Zusammensetzen: Kopf, Nachtrag, Rest -------------------------------------
VOR=$((EINFUEG - 1))
head -n "$VOR" "$LEDGER"          >  "$TMP_OUT"
cat "$TMP_NEU"                    >> "$TMP_OUT"
tail -n +"$EINFUEG" "$LEDGER"     >> "$TMP_OUT"

# -- GEGENPROBE VOR dem Ersetzen ----------------------------------------------
# Kein Haekchen ohne Messung: die Zeilenzahl muss exakt aufgehen, sonst ist
# unterwegs etwas verlorengegangen und wir fassen den Ledger nicht an.
SOLL=$((GESAMT + NEU_ZEILEN))
IST=$(wc -l < "$TMP_OUT")
if [ "$IST" -ne "$SOLL" ]; then
    echo "ABBRUCH: Zeilenzahl geht nicht auf (ist $IST, soll $SOLL) -- nichts geschrieben." >&2
    exit 2
fi

cat "$TMP_OUT" > "$LEDGER"

# -- NENNER, nie eine nackte Null ---------------------------------------------
echo "-----------------------------------------------------------------------------"
echo "LEDGER-NACHTRAG eingefuegt."
echo "  Datei          : $LEDGER"
echo "  Einfuegepunkt  : Zeile $EINFUEG (erste Zeile nach dem Kopf-Block)"
echo "  Nachtrag       : $NEU_ZEILEN Zeile(n)"
echo "  Ledger         : $GESAMT -> $IST Zeilen"
echo "-----------------------------------------------------------------------------"
echo "Der Nachtrag steht jetzt OBEN, nicht am Dateiende (Doktrin B.3:"
echo "'Nachtraege rueckwaerts, neueste oben')."
