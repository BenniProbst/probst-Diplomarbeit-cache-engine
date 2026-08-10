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
#        dasselbe Zaehl-WERKZEUG wie in ci/mess_ausbeute_wache.sh und
#        ci/persist_sammler.sh.
#
# ABGRENZUNG ZU D3-3b (10.08.2026) -- ABSICHTLICH NICHT WORTGLEICH:
#   Die drei Gates (mess_ausbeute_wache / persist_sammler / frische_wache) zaehlen
#   seit D3-3b nur noch Zeilen mit nicht-leerem Inhalt: eine LEERZEILE ist dort
#   kein Messwert. DIESE Datei zaehlt weiter 'NR - 1' und tut das mit Absicht.
#   Sie beantwortet eine ANDERE Frage: nicht "wie viele Messwerte gibt es", sondern
#   "sind beim Zusammenkleben Zeilen verlorengegangen oder verklebt". Ihr Mass muss
#   deshalb genau das abbilden, was 'tail -n +2 | awk 1' TATSAECHLICH angehaengt hat
#   -- und das sind auch die Leerzeilen. Selbstcheck 2 unten rechnet die Summe der
#   Einzelbeitraege gegen die Zeilen des Aggregats; wuerde hier gefiltert und dort
#   nicht, faellt er sofort. Wer den Filter hierher traegt, muss ihn in BEIDE Zahlen
#   UND in die Konkatenation tragen -- sonst tauscht er eine echte Wache gegen einen
#   Abbruch. Das ist ein eigenes Paket, keine Randnotiz dieses hier.
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
#     tragend ist das 'awk 1'. Sie bleibt: sie haelt die Zusage "dasselbe
#     Zaehl-WERKZEUG wie Wache und Sammler" (nicht mehr dieselbe Zaehl-REGEL,
#     s. Abgrenzung zu D3-3b oben) und greift, falls 'awk 1' spaeter verschwindet.
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
#                         -- DER NENNER (P29, 10.08.2026), additiv angehaengt:
#                           WIDE_QUELLEN=<n>     gelistete Quellen = Grundgesamtheit
#                           WIDE_MIT_DATEN=<n>   davon mit >= 1 Datenzeile
#                           WIDE_OHNE_DATEN=<n>  davon lesbar, aber ohne Datenzeile
#                           WIDE_FEHLEND=<n>     davon nicht lesbar (-> Exit 2)
#                         Es gilt WIDE_QUELLEN = MIT_DATEN + OHNE_DATEN + FEHLEND;
#                         die Identitaet wird geprueft, nicht behauptet.
#
# WARUM EINE KENNZAHLEN-DATEI UND KEIN 'eval "$(...)"':
#   Bei 'eval "$(cmd)"' ist der Exit-Code des eval der der EINGELESENEN Zeilen,
#   nicht der von cmd -- ein abgestuerzter Aggregator kaeme als rc=0 zurueck.
#   Das ist dieselbe Fehlerklasse wie K11 ('rc=$?' nach einer Pipe misst das
#   letzte Glied). Mit einer Datei wird der rc direkt gemessen und DANN gelesen.
#
# EXIT: 0 = aggregiert (auch wenn das Ergebnis leer ist -- das ist kein Fehler,
#           sondern eine Zahl, ueber die der Aufrufer urteilt)
#       2 = konnte nicht aggregieren -- KEIN Gruen. Vier Gruende:
#             Argumente fehlen | Liste fehlt | eine gelistete Quelle ist nicht
#             lesbar (F5) | ein Selbstcheck der Zahlen ist gefallen
#
# DER VIERTE GEHEILTE DEFEKT (F5, 10.08.2026, am Objekt gemessen mit gewuerfeltem
# Koeder je Aufrufweg):
#   Eine Datei, die in der Liste stand und zwischen 'find' und 'read' verschwunden
#   war, lief in 'tail -n +2 "$rcsv" | awk 1'. tail schrieb EINE Zeile nach stderr,
#   die Pipe endete mit dem Status des LETZTEN Glieds (awk, immer 0), 'set -e' sah
#   nichts, und der Lauf meldete rc=0. Gemessen wurde:
#       Liste mit 4 Eintraegen (1 leer, 2 voll, 1 verschwunden)
#       -> WIDE_ZEILEN=3 WIDE_DATEN=2 WIDE_HEADER=ja   rc=0
#   Von "es gab wirklich nur zwei Datenzeilen" war das nicht zu unterscheiden --
#   dieselbe Fehlerklasse wie K11, und sie sass IN der Heilung. Jetzt: gezaehlt,
#   in der Ausgabe genannt, und fail-closed.
#
# DIE C++-FASSUNG DERSELBEN LOGIK steht in Code/ci_wachen/src/wide_aggregat.cpp
# (Owner-KERN "die C++ Implementierung dazu"). Sie ist der FREMDE NENNER dieser
# Datei: Code/tests/unit/test_ci_wache_wide_aggregat.cpp faehrt beide ueber
# dieselbe gewuerfelte Population und fordert Byte-Gleichheit von Aggregat,
# Kennzahlen und Exit-Code. Wer HIER etwas aendert, ohne DORT nachzuziehen, macht
# WideFall.ParitaetShellUndCppUeberEineGewuerfeltePopulation rot.
#
# POSIX-sh (die CI ruft 'sh', das ist hier dash), ASCII-only, kein Python.
# Selbstcheck: diese Datei enthaelt die 'awk 1'-Konkatenation und die
# 'awk END{NR+0}'-Zaehlung GENAU EINMAL; jede weitere Kopie im Repo ist die
# Regression, gegen die sie gebaut ist (Fall A11 der anhang-forward-Probe und
# WideFall.DieKonkatenationStehtImBaumGenauEinmal).
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
_quellen=0; _mit=0; _ohne=0; _fehlend=0; _summe=0; _erste_fehlende=''
while IFS= read -r rcsv; do
  [ -n "$rcsv" ] || continue
  _quellen=$((_quellen + 1))
  # (F5) EINE GELISTETE, NICHT LESBARE QUELLE IST EIN ABBRUCH -- KEIN STILLES UEBERGEHEN.
  # Vorher lief sie in 'tail', das eine Zeile nach stderr schrieb und die Pipe trotzdem
  # mit dem awk-Status (immer 0) beendete: K11 in Reinform. 'set -e' sah nichts, rc blieb
  # 0, und das Aggregat bildete die Liste nicht mehr ab -- ununterscheidbar davon, dass
  # es die Datei nie gab. Hier wird sie GEZAEHLT und der Lauf faellt unten hart.
  if [ ! -f "$rcsv" ] || [ ! -r "$rcsv" ]; then
    _fehlend=$((_fehlend + 1))
    [ -n "$_erste_fehlende" ] || _erste_fehlende="$rcsv"
    continue
  fi
  [ "$_hdr" = "0" ] && [ -s "$rcsv" ] && { head -1 "$rcsv" | awk 1 >> "$WIDE"; _hdr=1; }
  tail -n +2 "$rcsv" | awk 1 >> "$WIDE"
  # Beitrag DIESER Quelle, in derselben Zaehlweise (awk NR) wie alles andere: 'tail -n +2'
  # gibt die Saetze 2..NR aus, es sind also NR-1, und eine Datei mit NR<=1 traegt nichts bei.
  _n=$(awk 'END{ if (NR > 1) print NR - 1; else print 0 }' "$rcsv")
  if [ "$_n" -gt 0 ]; then _mit=$((_mit + 1)); else _ohne=$((_ohne + 1)); fi
  _summe=$((_summe + _n))
done < "$LISTE"
WIDE_ZEILEN=$(awk 'END{print NR+0}' "$WIDE")

if [ "$_hdr" = "1" ]; then
    WIDE_HEADER=ja;   WIDE_DATEN=$((WIDE_ZEILEN - 1))
else
    WIDE_HEADER=nein; WIDE_DATEN=0
fi

# SELBSTCHECK 1 -- DIE NENNER-IDENTITAET. Sie wird nicht behauptet, sie wird gerechnet.
if [ "$_quellen" -ne $((_mit + _ohne + _fehlend)) ]; then
    echo "ABBRUCH: Nenner verletzt -- $_quellen Quellen, aber $_mit + $_ohne + $_fehlend." >&2
    exit 2
fi
# SELBSTCHECK 2 -- die Summe der Einzelbeitraege muss die Datenzeilen des Aggregats
# ergeben. Diese beiden Zahlen entstehen auf VERSCHIEDENEN Wegen (je Quelle gezaehlt
# gegen im Aggregat gezaehlt); dass sie gleich sind, ist deshalb eine Aussage und keine
# Tautologie. Sie faellt genau dann, wenn die Konkatenation Zeilen verklebt oder
# verschluckt -- also bei der Fehlerklasse F3.
if [ "$WIDE_DATEN" -ne "$_summe" ]; then
    echo "ABBRUCH: $WIDE_DATEN Datenzeilen im Aggregat, aber $_summe je Quelle gezaehlt." >&2
    echo "         Die Konkatenation hat Zeilen verklebt oder verschluckt. Kein Gruen." >&2
    exit 2
fi

# DER NENNER GEHOERT IN DIE AUSGABE (V-1). Die drei ALTEN Schluessel stehen zuerst und
# unveraendert -- ein Aufrufer, der nur sie liest, merkt vom Umbau nichts.
{
    printf 'WIDE_ZEILEN=%s\n'  "$WIDE_ZEILEN"
    printf 'WIDE_DATEN=%s\n'   "$WIDE_DATEN"
    printf 'WIDE_HEADER=%s\n'  "$WIDE_HEADER"
    printf 'WIDE_QUELLEN=%s\n' "$_quellen"
    printf 'WIDE_MIT_DATEN=%s\n'  "$_mit"
    printf 'WIDE_OHNE_DATEN=%s\n' "$_ohne"
    printf 'WIDE_FEHLEND=%s\n'    "$_fehlend"
} > "$KENNZAHLEN"

if [ "$_fehlend" -gt 0 ]; then
    echo "ABBRUCH: $_fehlend von $_quellen gelisteten Quellen sind nicht lesbar," >&2
    echo "         zuerst '$_erste_fehlende'. Das Aggregat bildet die Liste damit" >&2
    echo "         NICHT ab, und ein unvollstaendiges Aggregat ist von einem" >&2
    echo "         vollstaendigen nicht zu unterscheiden. Kein stilles Gruen." >&2
    exit 2
fi

exit 0
