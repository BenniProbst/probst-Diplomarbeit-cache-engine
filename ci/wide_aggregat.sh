#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  wide_aggregat.sh -- DIE EINE WIDE-Konkatenation der Mess-Kette.   (2026-08-09)
# =============================================================================
#
# WARUM DIESE DATEI EXISTIERT:
#   Bis heute stand dieselbe Aggregations-Logik DREIMAL im Bestand:
#     (1) ci/anhang_forward_core.sh   -- gedeckt durch ci/tests/anhang_forward_probe.sh
#     (2) .gitlab-ci.yml, Job measure:smoke        -- UNGEDECKT
#     (3) .gitlab-ci.yml, Job measure:golden-320   -- UNGEDECKT
#   Der Bauer der Heilung hat die Luecke selbst benannt: "Ein Mutant, der '| awk 1'
#   in .gitlab-ci.yml wieder entfernt, wuerde heute von nichts gefangen."
#   AM OBJEKT NACHGEMESSEN (09.08.2026), bevor diese Datei entstand: ein Mutant,
#   der die vier Aggregations-Zeilen der .gitlab-ci.yml um ihr 'awk 1' kuerzt,
#   liess SIEBEN von SIEBEN gefahrenen Wachen unveraendert -- sechs blieben gruen
#   (anhang-forward-Probe, mess-ausbeute-Bissprobe, bestandslog-Probe,
#   persist-sammler-Probe, Diff-Hygiene-Wache, XML-Wohlgeformtheits-Wache), und
#   die siebte (plan-zahlen-Probe) war MIT und OHNE Mutation gleich rot, taugt
#   also nicht als Unterscheider. Null von sieben haben den Unterschied gesehen.
#
#   Deshalb gibt es die Stelle jetzt EINMAL. Die drei Aufrufer rufen sie, und die
#   BESTEHENDE Probe (ci/tests/anhang_forward_probe.sh, Mutanten N2/N3/N5) deckt
#   damit alle drei. Die Deckung entsteht durch die Vereinigung selbst, nicht
#   durch eine zusaetzliche Behauptung ueber die YAML-Datei.
#
# WAS SIE TUT -- und nur das:
#   Sie klebt die in <listendatei> genannten CSV zu EINEM WIDE-Aggregat zusammen
#   (Kopfzeile genau einmal, danach alle Datenzeilen) und ZAEHLT das Ergebnis.
#   Sie ENTSCHEIDET NICHT, ob "leer" ein Fehler ist -- das bleibt beim Aufrufer:
#   der Anhang-Kern nennt es honest-empty, die measure-Jobs ueberspringen die
#   Anhang-Regenerierung. Zwei verschiedene Urteile ueber dieselbe Zahl; nur die
#   Zahl ist gemeinsam.
#
# DIE DREI GEHEILTEN DEFEKTE, DIE HIER WOHNEN (alle am Objekt reproduziert,
# alle still mit rc=0 -- ausfuehrlich begruendet in ci/anhang_forward_core.sh):
#   (F2) 'wc -l' zaehlt ZEILENUMBRUECHE, nicht Zeilen. Kopfzeile + EINE Datenzeile
#        ohne Schluss-Newline ergab 1 und galt als leer. Deshalb 'awk END{NR+0}' --
#        wortgleich zu ci/mess_ausbeute_wache.sh und ci/persist_sammler.sh.
#   (F3) Die Konkatenation ohne 'awk 1' klebte die erste Datenzeile der naechsten
#        Datei an die letzte der vorigen, sobald der Schluss-Newline fehlte. Und
#        genau das ist der Regelfall: ce schreibt die letzte Zeile ohne Newline.
#        'awk 1' gibt jeden Datensatz mit ORS aus und heilt das.
#   (F4) DER HEADER-DIEB: eine 0-Byte-CSV, die im 'sort' VOR der vollen liegt,
#        lieferte nichts und setzte trotzdem '_hdr=1'; die volle Datei danach kam
#        nur noch durch 'tail -n +2' und verlor ihre Kopfzeile. Deshalb steht
#        '[ -s "$rcsv" ]' in der Bedingung: eine Datei mit Groesse 0 hat 0
#        awk-Datensaetze, jede mit Groesse > 0 hat mindestens einen. '_hdr=1'
#        heisst damit "es steht wirklich eine Kopfzeile in $WIDE".
#
# ZWEI STELLEN SIND HEUTE UNGEDECKT -- am Objekt nachgemessen, nicht behauptet.
# Die beiden Saetze standen vor dem Umzug in ci/anhang_forward_core.sh und waeren
# beim Verschieben fast verlorengegangen; die Zahlen sind hier NEU gemessen
# (11 Faelle, nicht mehr 10 wie in der Fassung davor):
#   * '>>' STATT '>' in der Header-Zeile. Ein Mutant, der NUR das zurueckdreht,
#     laesst ALLE 11 Faelle der Probe gruen -- kein Test unterscheidet die beiden
#     Fassungen. Es kann heute auch nichts kaputtmachen: der Header wird genau
#     einmal geschrieben, und vor ihm koennen nur 0-Byte-Dateien gelaufen sein,
#     die nichts beitragen. Es steht als Vorsorge gegen eine kuenftige
#     Umstellung, nicht als heutige Wache -- wer die Zeile bewegt, liest das mit.
#   * 'awk END{NR+0}' STATT 'wc -l'. Ein Mutant, der NUR die Zaehlung
#     zurueckdreht, laesst ebenfalls alle 11 Faelle gruen. Der Grund ist die
#     Heilung von F3: seit 'awk 1' endet das Aggregat immer auf einen Newline,
#     und dann liefern beide Zaehlweisen zwangslaeufig dieselbe Zahl. Die
#     awk-Zaehlung ist hier also REDUNDANTE Deckung, nicht die tragende --
#     tragend ist das 'awk 1'. Sie bleibt: sie haelt die Zusage "wortgleich zu
#     Wache und Sammler" und greift, falls das 'awk 1' spaeter verschwindet.
#   Der Mutant N2 der Probe dreht beide Zeilen ZUSAMMEN mit der Konkatenation
#   zurueck und beisst dann -- er belegt also den Stand vor P4 als Ganzes, nicht
#   diese beiden Zeilen einzeln. Zwei Deckungen desselben Falls sind kein Fehler;
#   sie unbenannt zu lassen waere einer.
#
# NICHT ZUGESICHERT -- ausdruecklich benannt, damit niemand mehr hineinliest:
#   * dass die Kopfzeilen aller Dateien GLEICH sind. Der Header wird EINMAL von
#     der ersten Datei mit Inhalt genommen; abweichende Spalten einer spaeteren
#     Datei faenden hier niemand. Das ist eine andere Wache.
#   * dass eine Datei mit Groesse > 0 eine BRAUCHBARE Kopfzeile hat. Eine Datei
#     aus einem einzelnen Newline liefert eine leere. Geprueft wird die HERKUNFT,
#     nicht der Inhalt.
#   * die REIHENFOLGE. Sortiert wird vom AUFRUFER, bevor er die Liste schreibt --
#     sonst haetten Kern und CI zwei verschiedene 'sort'-Aufrufe, und die Frage
#     "welche Datei stellt den Header" haette zwei Antworten.
#   * die AUSWAHL der Dateien. Welcher Glob welche CSV findet, bleibt beim
#     Aufrufer (im Kern: AF_RESULT_NAMEN, in der CI: find -name 'result.csv').
#
# AUFRUF:
#   sh ci/wide_aggregat.sh <listendatei> <ziel-wide-csv> <kennzahlen-datei>
#     <listendatei>       eine CSV je Zeile, VOM AUFRUFER SORTIERT
#     <ziel-wide-csv>     wird angelegt/geleert und beschrieben
#     <kennzahlen-datei>  wird geschrieben und ist per '.' einlesbar:
#                           WIDE_ZEILEN=<n>   Gesamtzeilen (awk NR)
#                           WIDE_DATEN=<n>    Datenzeilen ohne Kopfzeile
#                           WIDE_HEADER=ja|nein
#
# WARUM EINE KENNZAHLEN-DATEI UND KEIN 'eval "$(...)"':
#   Bei 'eval "$(cmd)"' ist der Exit-Code des eval der der EINGELESENEN Zeilen,
#   nicht der von cmd -- ein abgestuerzter Aggregator kaeme als rc=0 zurueck.
#   Das ist dieselbe Fehlerklasse wie K11 ('rc=$?' nach einer Pipe misst das
#   letzte Glied). Mit einer Datei wird der rc direkt gemessen und DANN gelesen.
#
# EXIT: 0 = aggregiert (auch wenn das Ergebnis leer ist -- das ist kein Fehler,
#           sondern eine Zahl, ueber die der Aufrufer urteilt)
#       2 = konnte nicht aggregieren (Argumente fehlen, Liste fehlt) -- KEIN Gruen
#
# POSIX-sh (die CI ruft 'sh', das ist hier dash), ASCII-only, kein Python.
# Selbstcheck: diese Datei enthaelt die 'awk 1'-Konkatenation und die
# 'awk END{NR+0}'-Zaehlung GENAU EINMAL; jede weitere Kopie im Repo ist die
# Regression, gegen die sie gebaut ist (Fall A11 der anhang-forward-Probe).
# =============================================================================

set -eu

LISTE="${1:-}"
WIDE="${2:-}"
KENNZAHLEN="${3:-}"

if [ -z "$LISTE" ] || [ -z "$WIDE" ] || [ -z "$KENNZAHLEN" ]; then
    echo "AUFRUF: sh ci/wide_aggregat.sh <listendatei> <ziel-wide-csv> <kennzahlen-datei>" >&2
    exit 2
fi
if [ ! -f "$LISTE" ]; then
    echo "ABBRUCH: Listendatei '$LISTE' fehlt -- es gibt nichts zu aggregieren, und" >&2
    echo "         ein leeres Aggregat waere von einem echten Freispruch nicht zu" >&2
    echo "         unterscheiden. KEIN stilles Gruen." >&2
    exit 2
fi

: > "$WIDE"; _hdr=0
while IFS= read -r rcsv; do
  [ -n "$rcsv" ] || continue
  [ "$_hdr" = "0" ] && [ -s "$rcsv" ] && { head -1 "$rcsv" | awk 1 >> "$WIDE"; _hdr=1; }
  tail -n +2 "$rcsv" | awk 1 >> "$WIDE"
done < "$LISTE"
WIDE_ZEILEN=$(awk 'END{print NR+0}' "$WIDE")

if [ "$_hdr" = "1" ]; then
    WIDE_HEADER=ja;   WIDE_DATEN=$((WIDE_ZEILEN - 1))
else
    WIDE_HEADER=nein; WIDE_DATEN=0
fi

{
    printf 'WIDE_ZEILEN=%s\n'  "$WIDE_ZEILEN"
    printf 'WIDE_DATEN=%s\n'   "$WIDE_DATEN"
    printf 'WIDE_HEADER=%s\n'  "$WIDE_HEADER"
} > "$KENNZAHLEN"

exit 0
