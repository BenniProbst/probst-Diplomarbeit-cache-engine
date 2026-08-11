#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  FRISCHE-WACHE -- welche Mess-CSV stammt aus DIESEM Lauf, und welche lag
#  schon da?                                                      (2026-08-09)
# =============================================================================
#
# DER BEFUND, GEGEN DEN SIE GEBAUT IST (D3-8):
# Die Mess-Jobs laufen auf einem PERSISTENTEN baremetal-Workspace, und das
# Mess-Ausgabeverzeichnis ist vom Aufraeumen ausdruecklich AUSGENOMMEN. Am
# Objekt nachgelesen (ce experiment_plan_director.hpp:1194-1203,
# emit_gn_out_persistence_variables, Paket G4a P-C):
#     GIT_CLEAN_FLAGS: "-ffdx -e Code/gn_out -e Code/build -e Code/measure_out"
#     GIT_STRATEGY: fetch
# in BEIDE emittierten Batch-Jobs geschrieben. Die Ausnahme ist gewollt (der
# Bau soll nicht jedes Mal neu anfangen) und sie ist richtig -- aber sie hat
# eine Folge, die keine Wache heute sieht:
#
#   Die CSVs eines FRUEHEREN Laufs ueberleben im Verzeichnis. Eine Wache, die
#   nur Datenzeilen zaehlt, findet sie und nennt sie Ausbeute DIESES Laufs.
#   Ein Job, der real NICHTS gemessen hat, ist damit gruen -- mit fremden
#   Zahlen. Das ist kein defektes Messgeraet, sondern ein richtiges am
#   falschen Gegenstand, und es klappert nichts.
#
# WARUM NICHT ueber die DATEI-ZEIT (mtime) -- der naheliegende Weg, verworfen:
#   mtime ist ein STELLVERTRETER fuer "aus diesem Lauf". Er faellt an drei
#   Stellen auseinander: ein `cp -p`/Restore setzt ihn zurueck, ein `touch`
#   setzt ihn vor, und eine Datei, die dieser Lauf nur ANFASST ohne sie zu
#   fuellen, bekommt eine frische Zeit ohne einen frischen Messwert. Ein
#   mtime-Vergleich gegen CI_JOB_STARTED_AT waere billiger zu bauen und haette
#   genau die Eigenschaft, die dieses Projekt teuer bezahlt hat: er misst
#   etwas Benachbartes.
#   STATTDESSEN entscheidet die LAUF-KENNUNG aus dem Lauf-Marker (D3-7,
#   ci/lauf_marker.sh). Sie ist "<CI_PIPELINE_ID>-<CI_JOB_ID>" und wird beim
#   Schreiben des Markers aus der Abschluss-Zeile des Treibers gesetzt. Sie ist
#   RETRY-FEST: ein Retry bekommt eine neue CI_JOB_ID, die CSVs des
#   Vorversuchs werden dadurch korrekt zu Altbestand -- waehrend
#   CI_PIPELINE_ID allein sie faelschlich als "dieser Lauf" durchgehen liesse.
#
# ALTBESTAND WIRD GEMELDET, NIE GELOESCHT:
#   Hausdoktrin, ohne Ausnahme: Messdaten werden nie geloescht. Diese Wache
#   ruft weder rm noch find -delete noch mv -- sie NENNT den Altbestand
#   namentlich, mit seiner fremden Lauf-Kennung, und ueberlaesst jede
#   Entscheidung darueber einem Menschen. Wer sie erweitert, erweitert sie
#   NICHT um eine Loeschung.
#
# DIE DRITTE MENGE, die es geben MUSS: CSV OHNE Marker.
#   Sie darf weder zu "dieser Lauf" noch zu "Altbestand" geschlagen werden --
#   beides waere geraten. Sie bekommt einen eigenen Zaehler und eine eigene
#   Liste. Ob ein fehlender Marker rot ist, entscheidet
#   `sh ci/lauf_marker.sh pruefen` (dort ist er es); hier wird er GEZAEHLT,
#   damit die drei Zahlen zusammen den vollen Nenner ergeben und keine Datei
#   zwischen zwei Wachen hindurchfaellt.
#
# WARUM SIE EIN GATE IST UND KEIN BERICHT:
#   csv_dieser_lauf==0 bei csv_gesamt>0 heisst: in diesem Verzeichnis liegen
#   Messdaten, aber KEINE davon hat dieser Lauf geschrieben. Genau dieser
#   Zustand ist der teure -- er sieht in jeder zeilenzaehlenden Wache wie
#   Erfolg aus. Ein blosser Bericht daneben wuerde ihn sichtbar machen und
#   trotzdem durchlassen; eine advisory Wache ist die naechste stille Null.
#   ABGEGRENZT: der Altbestand allein macht NICHT rot. Ein Lauf, der frisch
#   misst UND alte Zellen liegen laesst, ist zulaessig (Resume ist zulaessig);
#   er wird gemeldet, nicht gestoppt.
#
# DER ZWEITE AUSGANG -- und warum er NACHTRAEGLICH dazukam (ehrlich benannt):
#   Der erste Entwurf dieser Wache zaehlte nur DATEIEN. Der Zwei-Lauf-Koeder hat
#   ihn beim ersten Lauf widerlegt, bevor eine Zeile Doku dazu geschrieben war:
#     Altzelle (fremde Kennung) mit EINER Datenzeile + Neuzelle (eigene Kennung)
#     mit NUR der Kopfzeile
#   ergab csv_dieser_lauf=1 -> Frische-Wache GRUEN, und zugleich
#     "1 Datenzeile(n) insgesamt, gefordert waren mindestens 1" -> Ausbeute-Wache
#     GRUEN.
#   BEIDE gruen, obwohl dieser Lauf keinen einzigen Messwert erzeugt hat: die
#   Ausbeute-Wache summiert ueber ALLE Dateien und liest dabei die FREMDE
#   Datenzeile als Ausbeute dieses Laufs. Das ist der Kern des Befunds, und eine
#   Wache, die nur Dateien zaehlt, sieht ihn nicht.
#   Deshalb zaehlt sie DATENZEILEN je Herkunft und hat einen zweiten Ausgang:
#     datenzeilen_dieser_lauf == 0 UND datenzeilen_altbestand > 0 UND die
#     frischen Marker sagen modus=voll  ->  ROT.
#   Die drei Bedingungen sind bewusst eng. Ohne Altbestand faengt die
#   Ausbeute-Wache den leeren voll-Lauf schon selbst; ohne modus=voll waere es
#   ein provision_only-Lauf, der per Bauart nicht misst. Was diese Wache
#   hinzufuegt, ist ausschliesslich das MASKIEREN durch fremde Zeilen.
#
# ZAEHLWEISE, ausdruecklich benannt -- WORTGLEICH zu ci/mess_ausbeute_wache.sh
# und ci/persist_sammler.sh (dasselbe awk-Programm, Byte fuer Byte):
#   Datenzeilen = alle Zeilen AB DER ZWEITEN, die mindestens ein Zeichen tragen,
#   das kein Leerraum ist. Die erste Zeile ist der CSV-Kopf und zaehlt nie mit.
#   Gezaehlt wird mit awk, NICHT mit `wc -l` (das zaehlt Umbrueche und meldet
#   eine Datei ohne abschliessenden Newline um eine Zeile zu niedrig). Eine
#   leere Datei hat 0 Zeilen und damit 0 Datenzeilen, nicht -1. Drei Gates
#   derselben Kette duerfen sich in der Zaehlweise nicht widersprechen.
#
#   EINE LEERZEILE IST KEIN MESSWERT (D3-3b, 10.08.2026). Vorher galt
#   `Datenzeilen = Zeilen - 1`; damit zaehlte jede leere und jede nur aus
#   Blanks/Tabs bestehende Zeile mit. Fuer DIESE Wache ist das der schwerere
#   Fall: ihr zweiter Ausgang haengt an `datenzeilen_dieser_lauf == 0`. Eine
#   frische Zelle, die nur Kopf und Leerzeilen schrieb, hatte Z_DIESER > 0 --
#   und genau das Maskierungs-Gate, das dafuer gebaut wurde, blieb still. Die
#   Heilung geht nur in die scharfe Richtung: Z_DIESER kann seither nur kleiner
#   werden, das Gate also nur oefter beissen, nie seltener.
#
#   EIN DURCHLAUF, ZWEI ZAHLEN: das awk-Programm gibt "<rohzeilen> <datenzeilen>"
#   aus; die verworfene Menge faellt daraus als eigener NENNER ab
#   (datenzeilen_verworfen), damit "0 Datenzeilen" von "0 Zeilen" unterscheidbar
#   bleibt.
#
# AUFRUF:
#   sh ci/frische_wache.sh pruefen <wurzel> [<lauf-kennung>]
#
#   <wurzel>        Mess-Ausgabeverzeichnis (measure_out / measure_out_smoke).
#   <lauf-kennung>  Optional. Default "${CI_PIPELINE_ID:-NA}-${CI_JOB_ID:-NA}" --
#                   dieselbe Bildung wie in ci/lauf_marker.sh. Ausserhalb der CI
#                   ist sie "NA-NA"; dann sind Marker und Wache konsistent, und
#                   die Wache sagt das auch dazu, statt eine Frische zu
#                   behaupten, die niemand nachpruefen kann.
#
# EXIT: 0 = mindestens eine CSV stammt aus diesem Lauf (mit Nenner belegt)
#       1 = CSVs vorhanden, aber KEINE aus diesem Lauf (Altbestand namentlich)
#       2 = konnte nicht pruefen (Wurzel fehlt, 0 CSV gefunden) --
#           ausdruecklich KEIN Gruen.
#
# POSIX-sh, ASCII-only, kein Python (Hausdoktrin: kein Python in der Buildchain).
# Selbstcheck: diese Wache LOESCHT NICHTS. Sie enthaelt kein rm, kein mv und
# kein -delete; wer das aendert, verletzt "Messdaten nie loeschen".
# =============================================================================

set -eu
LC_ALL=C
export LC_ALL

TRENN="-----------------------------------------------------------------------------"
MARKER_NAME="LAUF_MARKER.txt"

nutzung() {
    echo "AUFRUF: sh ci/frische_wache.sh pruefen <wurzel> [<lauf-kennung>]" >&2
}

wache_pruefen() {
    WURZEL="${1:-}"
    KENNUNG="${2:-${CI_PIPELINE_ID:-NA}-${CI_JOB_ID:-NA}}"

    if [ -z "$WURZEL" ]; then nutzung; exit 2; fi
    if [ ! -d "$WURZEL" ]; then
        echo "ABBRUCH: '$WURZEL' ist kein Verzeichnis -- die Frische-Wache konnte nicht pruefen." >&2
        echo "         Kein Gruen ohne Pruefung." >&2
        exit 2
    fi
    if [ -z "$KENNUNG" ]; then
        echo "ABBRUCH: leere Lauf-Kennung -- ohne sie ist 'dieser Lauf' nicht benennbar." >&2
        exit 2
    fi

    TMP=$(mktemp) || exit 2
    trap 'rm -f "$TMP"' EXIT INT TERM
    find "$WURZEL" -type f -name 'measurements.csv' > "$TMP" 2>/dev/null || true
    N_CSV=$(awk 'END{print NR+0}' "$TMP")

    echo "$TRENN"
    echo "FRISCHE-WACHE   Wurzel=$WURZEL"
    echo "                Lauf-Kennung dieses Laufs: $KENNUNG"
    echo "$TRENN"

    if [ "$N_CSV" -eq 0 ]; then
        echo "  KEINE measurements.csv unter '$WURZEL'." >&2
        echo "ABBRUCH: 0 CSV -- ueber eine leere Menge ist 'frisch oder alt' nicht" >&2
        echo "         aussagbar. Dass ueberhaupt nichts erzeugt wurde, meldet" >&2
        echo "         ci/mess_ausbeute_wache.sh; hier waere jede Antwort geraten." >&2
        echo "         Kein Gruen ohne Pruefung." >&2
        exit 2
    fi

    N_DIESER=0
    N_ALT=0
    N_OHNE=0
    Z_DIESER=0
    Z_ALT=0
    Z_OHNE=0
    N_DIESER_VOLL=0
    Z_VERWORFEN=0
    ALT_LISTE=''
    OHNE_LISTE=''
    while IFS= read -r F; do
        [ -n "$F" ] || continue
        # Ein Lesevorgang, zwei Zahlen: "<rohzeilen> <datenzeilen>". Das
        # awk-Programm steht Byte-gleich in ci/mess_ausbeute_wache.sh und
        # ci/persist_sammler.sh.
        _paar=$(awk 'NR>1 && $0 ~ /[^[:space:]]/ {n++} END{printf "%d %d\n", NR+0, n+0}' "$F")
        _zeilen=${_paar%% *}
        _daten=${_paar##* }
        if [ "$_zeilen" -gt 1 ]; then Z_VERWORFEN=$((Z_VERWORFEN + _zeilen - 1 - _daten)); fi
        _m="$(dirname "$F")/$MARKER_NAME"
        if [ ! -f "$_m" ]; then
            N_OHNE=$((N_OHNE + 1)); Z_OHNE=$((Z_OHNE + _daten))
            OHNE_LISTE="$OHNE_LISTE
    $F  ($_daten Datenzeile(n))"
            echo "  OHNE MARKER   $F  ($_daten Datenzeile(n))"
            continue
        fi
        _k=$(awk -F= '/^lauf_kennung=/{print $2; exit}' "$_m" 2>/dev/null || true)
        if [ -z "$_k" ]; then
            N_OHNE=$((N_OHNE + 1)); Z_OHNE=$((Z_OHNE + _daten))
            OHNE_LISTE="$OHNE_LISTE
    $F  (Marker ohne Feld lauf_kennung=, $_daten Datenzeile(n))"
            echo "  OHNE KENNUNG  $F  (Marker vorhanden, Feld lauf_kennung= fehlt)"
            continue
        fi
        if [ "$_k" = "$KENNUNG" ]; then
            N_DIESER=$((N_DIESER + 1)); Z_DIESER=$((Z_DIESER + _daten))
            _mod=$(awk -F= '/^modus=/{print $2; exit}' "$_m" 2>/dev/null || true)
            [ "$_mod" = voll ] && N_DIESER_VOLL=$((N_DIESER_VOLL + 1))
            echo "  DIESER LAUF   $F  ($_daten Datenzeile(n), modus=${_mod:-?})"
        else
            N_ALT=$((N_ALT + 1)); Z_ALT=$((Z_ALT + _daten))
            ALT_LISTE="$ALT_LISTE
    $F  (lauf_kennung=$_k, $_daten Datenzeile(n))"
            echo "  ALTBESTAND    $F  ($_daten Datenzeile(n), lauf_kennung=$_k)"
        fi
    done < "$TMP"

    echo "$TRENN"
    echo "NENNER (nie eine nackte Null):"
    echo "  csv_gesamt=$N_CSV"
    echo "  csv_dieser_lauf=$N_DIESER          datenzeilen_dieser_lauf=$Z_DIESER"
    echo "  csv_altbestand=$N_ALT           datenzeilen_altbestand=$Z_ALT"
    echo "  csv_ohne_marker=$N_OHNE          datenzeilen_ohne_marker=$Z_OHNE"
    echo "  davon $N_DIESER_VOLL Datei(en) dieses Laufs mit modus=voll (nur die SOLLTEN messen)."
    echo "  datenzeilen_verworfen=$Z_VERWORFEN  (leer oder nur Leerraum -- kein Messwert)"
    echo "  (die drei Teilmengen ergeben zusammen csv_gesamt -- keine Datei faellt"
    echo "   zwischen zwei Wachen hindurch.)"
    echo "$TRENN"

    if [ "$N_ALT" -gt 0 ]; then
        echo "ALTBESTAND, namentlich (GEMELDET, NIE GELOESCHT -- Messdaten bleiben):$ALT_LISTE"
        echo "  Ursache, nicht Verdacht: das Mess-Verzeichnis ist vom Aufraeumen"
        echo "  ausgenommen (GIT_CLEAN_FLAGS '-ffdx -e Code/measure_out', ce"
        echo "  experiment_plan_director.hpp:1194-1203). Diese Dateien SOLLEN"
        echo "  ueberleben; sie duerfen nur nicht als Ausbeute dieses Laufs gelten."
    fi
    if [ "$N_OHNE" -gt 0 ]; then
        echo "OHNE LAUF-MARKER, namentlich:$OHNE_LISTE"
        echo "  Diese Dateien werden WEDER als frisch NOCH als alt gezaehlt -- beides"
        echo "  waere geraten. Ob ein fehlender Marker rot ist, entscheidet"
        echo "  'sh ci/lauf_marker.sh pruefen <wurzel>' (dort ist er es)."
    fi

    if [ "$N_DIESER" -eq 0 ]; then
        echo "FEHLER: KEINE von $N_CSV measurements.csv traegt die Kennung dieses Laufs." >&2
        echo "        csv_dieser_lauf=0 bei csv_gesamt=$N_CSV (altbestand=$N_ALT, ohne_marker=$N_OHNE)." >&2
        echo "        Dieser Lauf hat nichts geschrieben -- was hier liegt, gehoert einem" >&2
        echo "        anderen. Eine zeilenzaehlende Wache haette das als Erfolg gelesen." >&2
        exit 1
    fi

    # Zweiter Ausgang: FREMDE Zeilen maskieren den eigenen Leerlauf.
    # Eng gefasst -- ohne Altbestand faengt die Ausbeute-Wache den leeren
    # voll-Lauf schon selbst, und ohne modus=voll SOLL hier nicht gemessen werden.
    if [ "$Z_DIESER" -eq 0 ] && [ "$Z_ALT" -gt 0 ] && [ "$N_DIESER_VOLL" -gt 0 ]; then
        echo "FEHLER: dieser Lauf hat 0 Datenzeile(n) erzeugt, aber $Z_ALT Datenzeile(n)" >&2
        echo "        aus FREMDEN Laeufen liegen im selben Verzeichnis." >&2
        echo "        datenzeilen_dieser_lauf=0 / datenzeilen_altbestand=$Z_ALT" >&2
        echo "        ($N_DIESER_VOLL Datei(en) dieses Laufs stehen auf modus=voll -- er SOLLTE messen.)" >&2
        echo "        Die Ausbeute-Wache summiert ueber ALLE Dateien und liest die fremden" >&2
        echo "        Zeilen als Ausbeute dieses Laufs. Genau diese Maskierung ist der" >&2
        echo "        Grund fuer diese Wache; ohne sie waeren beide Gates gruen." >&2
        exit 1
    fi

    echo "FRISCHE-WACHE: OK ($N_DIESER von $N_CSV CSV aus diesem Lauf, $Z_DIESER Datenzeile(n) davon)."
    exit 0
}

UNTER="${1:-}"
[ "$#" -gt 0 ] && shift

case "$UNTER" in
    pruefen)      wache_pruefen "$@" ;;
    ''|-h|--help) nutzung; exit 2 ;;
    *)
        echo "ABBRUCH: unbekanntes Unterkommando '$UNTER'." >&2
        nutzung
        exit 2
        ;;
esac
