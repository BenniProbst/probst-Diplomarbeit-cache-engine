#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  ANKER-WACHE -- ein Zeilennummern-Verweis in einem Dokument ist eine Behauptung
#  ueber den Code und verjaehrt mit der naechsten Bearbeitung.      (2026-08-09)
# =============================================================================
#
# SELBSTCHECK -- was diese Wache ZUSICHERT:
#   Jeder mit 'ANKER-SYMBOL' ausgewiesene Verweis <Datei> <Symbol> <Zeile> zeigt
#   heute noch auf eine Zeile, die dieses Symbol traegt. Tut er es nicht, wird
#   der Lauf rot UND nennt die Zeile, auf der das Symbol wirklich steht.
# WAS SIE NICHT ZUSICHERT:
#   Sie sagt nichts darueber, ob der Verweis den RICHTIGEN Gegenstand meint, und
#   nichts ueber Verweise, die nicht als ANKER-SYMBOL ausgewiesen sind. Ein
#   Dokument ohne solche Zeilen ist fuer sie unsichtbar -- deshalb bricht sie ab,
#   wenn sie in den genannten Dateien KEINEN einzigen Anker findet (Nenner 0 ist
#   nie GRUEN, V-1).
#
# DER BEFUND, GEGEN DEN SIE GEBAUT IST (am Objekt gemessen, 09.08.2026):
#   Die WP-5-Disposition fuehrte REV-DATA-12 mit dem Verweis
#   'diagram_generator.cpp:414-420'. Die dort gemeinte Funktion nearest_rank_median
#   steht heute auf 653-659 -- **239 Zeilen** weiter. Der Schwester-Verweis
#   'csv_to_latex.cpp:48-54' stimmt dagegen unveraendert. Beide standen in
#   derselben Tabellenzelle, und nichts unterschied den richtigen vom falschen.
#   Genau das ist die teure Fehlerklasse: D5-2 haette den Median-Kanon gegen eine
#   Stelle vereinheitlicht, an der die Funktion gar nicht mehr steht.
#
#   Die Heilung ist deshalb NICHT "die Zahl nachziehen", sondern die Ankerform
#   wechseln: verankert wird am SYMBOL, die Zeilennummer laeuft nur noch als
#   datierte Bequemlichkeit mit -- und diese Wache haelt sie ehrlich.
#
# FORMAT im Dokument, eine Zeile:
#   ANKER-SYMBOL  <repo-relativer Pfad>  <Symbol>  <Zeile>
#   Trennung durch Leerraum. Fuehrendes '>' (Markdown-Zitat) wird abgestreift.
#
# AUFRUF:  sh ci/anker_wache.sh [<dokument> ...]
#          Ohne Argument: docs/audits/20260716-wp5-rev-mining-DISPOSITION.md
#
# EXIT: 0 = jeder Anker zeigt auf eine Zeile, die sein Symbol traegt
#       1 = mindestens ein Anker ist gedriftet (beide Zeilennummern im Protokoll)
#       2 = konnte nicht pruefen (Dokument/Datei fehlt, kein Anker gefunden)
#           -- ausdruecklich KEIN Gruen.
#
# POSIX-sh, ASCII-only, kein Python (Hausdoktrin).
# =============================================================================

set -eu

SELBST_DIR=$(cd "$(dirname "$0")" && pwd)
REPO=$(cd "$SELBST_DIR/.." && pwd)

if [ $# -gt 0 ]; then
    DOKUMENTE="$*"
else
    DOKUMENTE="$REPO/docs/audits/20260716-wp5-rev-mining-DISPOSITION.md"
fi

TMP=$(mktemp -d) || exit 2
trap 'rm -rf "$TMP"' EXIT INT TERM

N_ANKER=0
N_ROT=0

echo "-----------------------------------------------------------------------------"
echo "ANKER-WACHE   (ci/anker_wache.sh)"
echo "  Repo: $REPO"

: > "$TMP/anker.txt"
for _dok in $DOKUMENTE; do
    [ -f "$_dok" ] || { echo "ABBRUCH: Dokument '$_dok' fehlt." >&2; exit 2; }
    echo "  Dokument: $_dok"
    # '>' am Zeilenanfang abstreifen, damit der Anker auch in einem Markdown-Zitat steht.
    # NE-19a (13.08.2026): vorher stand hier 'sed | awk >> ... || true'. Starb sed fuer EIN
    # Dokument, waehrend ein anderes Anker lieferte, fehlten dessen Anker STILL im Bestand --
    # Teilverlust ohne rote Zeile (der Nenner-0-Abbruch unten greift nur beim Totalverlust).
    # dash als /bin/sh kennt weder pipefail noch PIPESTATUS (gemessen 13.08.: rc=2, dash
    # 0.5.12-6ubuntu5); die Hausform (Kopf ci_diff_ascii_width_guard.sh) ist je Stufe eine
    # Datei und ein EIGENER, LAUTER Abbruch.
    sed 's/^[[:space:]]*>[[:space:]]*//' "$_dok" > "$TMP/dok_flach.txt" \
        || { echo "ABBRUCH: sed konnte '$_dok' nicht verarbeiten (rc=$?) -- Anker-Bestand waere" >&2
             echo "         unvollstaendig, KEIN stilles Weiterlaufen." >&2; exit 2; }
    awk -v d="$_dok" '$1 == "ANKER-SYMBOL" && NF >= 4 { print d "\t" $2 "\t" $3 "\t" $4 }' \
        "$TMP/dok_flach.txt" >> "$TMP/anker.txt" \
        || { echo "ABBRUCH: awk-Anker-Extraktion fuer '$_dok' fehlgeschlagen (rc=$?)." >&2; exit 2; }
done

N_ANKER=$(awk 'END{print NR+0}' "$TMP/anker.txt")
if [ "$N_ANKER" -eq 0 ]; then
    echo "ABBRUCH: 0 Anker gefunden -- eine Wache mit Nenner 0 ist keine Wache." >&2
    exit 2
fi

echo "-----------------------------------------------------------------------------"
while IFS='	' read -r _dok _pfad _sym _soll; do
    [ -n "$_pfad" ] || continue
    _datei="$REPO/$_pfad"
    if [ ! -f "$_datei" ]; then
        echo "  ROT   $_pfad: Datei fehlt -- der Anker zeigt ins Leere." >&2
        N_ROT=$((N_ROT + 1))
        continue
    fi
    # IST: alle Zeilen, die das Symbol tragen. -F, weil das Symbol keine
    # Regex-Absicht hat und /usr/bin/grep hier ugrep ist (-P liefert stille 0).
    # K11: die Ausgabe erst in eine DATEI, dann auswerten -- ein rc hinter dieser
    # Pipe wuerde 'tr' messen, nicht 'grep'.
    grep -nF "$_sym" "$_datei" > "$TMP/treffer.txt" 2>/dev/null || :
    # awk-FALLE, hier am Objekt aufgelaufen (Koeder-Lauf 09.08.): bei LEERER
    # Eingabe laeuft kein einziger Hauptblock, und '{print NF+0}' druckt GAR
    # NICHTS -- die Variable bleibt leer und '[ "" -eq 0 ]' bricht mit
    # "Illegal number" ab, statt den Fall "Symbol fehlt ganz" zu erreichen.
    # Deshalb wird der Wert im Hauptblock gemerkt und erst in END gedruckt.
    _anzahl=$(awk 'END{print NR+0}' "$TMP/treffer.txt")
    _erste=$(awk -F: 'NR==1{v=$1} END{print v+0}' "$TMP/treffer.txt")
    if [ "$_anzahl" -eq 0 ]; then
        echo "  ROT   $_pfad:$_soll  '$_sym' kommt in der Datei UEBERHAUPT NICHT vor." >&2
        N_ROT=$((N_ROT + 1))
        continue
    fi
    # T-2: geprueft wird der WERT (traegt GENAU diese Zeile das Symbol?),
    # nicht die Anwesenheit des Symbols irgendwo in der Datei.
    if sed -n "${_soll}p" "$_datei" | grep -qF "$_sym"; then
        echo "  OK    $_pfad:$_soll traegt '$_sym'.   (Nenner: $_anzahl Vorkommen, erstes auf $_erste)"
    else
        echo "  ROT   $_pfad:$_soll traegt '$_sym' NICHT -- es steht auf $_erste." >&2
        echo "        Differenz: $((_erste - _soll)) Zeilen. Anker im Dokument nachziehen." >&2
        N_ROT=$((N_ROT + 1))
    fi
done < "$TMP/anker.txt"

echo "-----------------------------------------------------------------------------"
echo "NENNER (nie eine nackte Null): $N_ANKER Anker geprueft, $N_ROT gedriftet."
if [ "$N_ROT" -gt 0 ]; then
    echo "FEHLER: $N_ROT von $N_ANKER Ankern zeigen nicht mehr auf ihr Symbol." >&2
    echo "        Doku wird deprecatet, nicht geloescht: die alte Fundstelle bleibt" >&2
    echo "        als Datum stehen, die neue kommt DANEBEN." >&2
    exit 1
fi
echo "ANKER-WACHE: OK ($N_ANKER von $N_ANKER Ankern zeigen auf ihr Symbol)."
exit 0
