#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  OBJECT-STAT-ABNAHME -- der Round-Trip: ein frisch gewuerfeltes Objekt wird
#  EINGELAGERT und muss vom Store mit GENAU seiner Groesse zurueckgemeldet
#  werden.                                                          (2026-08-09)
# =============================================================================
#
# SELBSTCHECK -- was diese Datei zusichert, und was NICHT:
#   ZUSICHERT: dass der konfigurierte Objekt-Store ein Objekt WIRKLICH aufnimmt
#     und es danach mit exakt der Groesse zurueckmeldet, die es beim Ablegen
#     hatte. Die Groesse wird bei JEDEM Lauf frisch gewuerfelt, der Schluessel
#     ebenso. Der Sollwert stammt aus "wc -c" des lokalen Dateisystems, also aus
#     einer ANDEREN Quelle als der Antwort des Stores (T-3/T-5).
#   ZUSICHERT NICHT: dass irgendein FACHLICHES Dokument (etwa das Bestandslog)
#     im Store liegt. Diese Abnahme prueft den WEG, nicht die Fracht. Fuer ein
#     bestimmtes Dokument ist ci/object_stat_wache.sh direkt aufzurufen -- mit
#     einer erwarteten Groesse aus einer fremden Quelle.
#
# WARUM ES DIESE ABNAHME GIBT:
# Die bestehende Kette belegt bis hierher nur AUFRUFE: der Treiber meldet
# "[bestandslog] aktiv:", und ci/bestandslog_wache.sh prueft, dass diese Zeile
# die richtigen Werte traegt. Beides sind Aussagen ueber den LAUF. Am 09.08.
# ist genau daran ein Fall aufgefallen (Ledger, NACHTRAG Lager-Scharfschaltung):
# die aktiv-Zeile stand da, der Schreibweg scheiterte DANACH, und die Emission
# lief weiter. Ein Schreibaufruf, der nicht meckert, ist kein eingelagertes
# Objekt. Diese Abnahme stellt deshalb die einzige Frage, die der Stellvertreter
# nicht beantworten kann: liegt danach etwas im Store, und ist es das Richtige?
#
# DER KOEDER WIRD FRISCH GEWUERFELT (K13):
# Groesse und Schluessel kommen aus /dev/urandom, bei jedem Lauf neu. Eine aus
# einer Doku abgeschriebene Zahl beweist nichts: sie koennte zufaellig stimmen,
# irgendwo allowgelistet sein oder aus einem alten Lauf stammen. Nur ein Wert,
# den vor diesem Lauf niemand kennen konnte, belegt, dass wirklich dieses Objekt
# gemessen wurde.
#
# FAIL-CLOSED: jeder Fehlschlag ist rot. Store nicht erreichbar / nicht
# konfiguriert / nicht beschreibbar -> INFRASTRUKTUR (rc 3). Objekt nach dem
# Ablegen nicht auffindbar oder mit falscher Groesse -> FACHLICH (rc 1). Es gibt
# keinen Pfad, der ueberspringt.
#
# ZUGANGSDATEN werden nicht gelesen und nicht ausgegeben; mc zieht sie aus
# MC_HOST_<alias>. Meldungen laufen ueber die Wache, die redigiert.
#
# AUFRUF:  sh ci/object_stat_abnahme.sh [--timeout <sek>] [--behalten]
#   --behalten  das Probe-Objekt NICHT wieder loeschen (fuer Nachschau)
#
# UMGEBUNG: wie ci/object_stat_wache.sh (COMDARE_MINIO_ENDPOINT = mc-Alias,
#   COMDARE_MINIO_BUCKET, optional COMDARE_MINIO_PREFIX, COMDARE_MC_BIN).
#
# EXIT: 0 = Round-Trip belegt | 1 = FACHLICH | 2 = Aufruffehler | 3 = INFRASTRUKTUR
#
# POSIX-sh, ASCII-only, kein Python.
# =============================================================================

set -eu

ZEITSCHRANKE="30"
BEHALTEN=0
while [ "$#" -gt 0 ]; do
    case "$1" in
        --timeout)
            [ "$#" -ge 2 ] || { echo "AUFRUF: --timeout braucht einen Wert" >&2; exit 2; }
            ZEITSCHRANKE="$2"; shift 2 ;;
        --behalten) BEHALTEN=1; shift ;;
        *) echo "AUFRUF: sh ci/object_stat_abnahme.sh [--timeout <sek>] [--behalten]" >&2; exit 2 ;;
    esac
done
case "$ZEITSCHRANKE" in
    ''|*[!0-9]*) echo "ABBRUCH: --timeout '$ZEITSCHRANKE' ist keine Zahl." >&2; exit 2 ;;
esac

HIER=$(cd "$(dirname "$0")" && pwd)
WACHE="$HIER/object_stat_wache.sh"
[ -f "$WACHE" ] || { echo "ABBRUCH: $WACHE nicht gefunden." >&2; exit 2; }

ALIAS="${COMDARE_MINIO_ENDPOINT:-}"
BUCKET="${COMDARE_MINIO_BUCKET:-}"
PREFIX="${COMDARE_MINIO_PREFIX:-}"
MC="${COMDARE_MC_BIN:-mc}"

echo "============================================================================="
echo "OBJECT-STAT-ABNAHME (Round-Trip gegen den Objekt-Store)"
echo "============================================================================="

if [ -z "$ALIAS" ] || [ -z "$BUCKET" ]; then
    echo "FEHLER [INFRASTRUKTUR]: Objekt-Store nicht konfiguriert" >&2
    echo "  (COMDARE_MINIO_ENDPOINT / COMDARE_MINIO_BUCKET unbelegt)." >&2
    echo "  Diese Abnahme wurde gerufen und kann nichts messen -> rot, nicht gruen." >&2
    exit 3
fi
if ! command -v "$MC" >/dev/null 2>&1; then
    echo "FEHLER [INFRASTRUKTUR]: mc-Binary '$MC' nicht gefunden." >&2
    exit 3
fi

# --- der Wurf. Vor diesem Lauf kann niemand diese Werte gekannt haben. ------
GROESSE=$(od -An -N3 -tu4 < /dev/urandom | tr -d ' \n')
GROESSE=$((GROESSE % 262144 + 1))
MARKE=$(head -c9 /dev/urandom | base32 | tr 'A-Z' 'a-z' | tr -d '=')
KEY="abnahme/object-stat-$MARKE.bin"

ARBEIT=$(mktemp -d) || exit 2
QUELLE="$ARBEIT/koeder.bin"
head -c "$GROESSE" /dev/urandom > "$QUELLE"

# Gegenorakel: die Groesse noch einmal unabhaengig aus dem Dateisystem lesen.
# Weicht sie vom Wurf ab, ist die ABNAHME kaputt -- das muss sie sagen, statt
# den Store zu beschuldigen.
GROESSE_FS=$(wc -c < "$QUELLE" | tr -d ' ')
if [ "$GROESSE" != "$GROESSE_FS" ]; then
    echo "ABBRUCH: Abnahme defekt -- gewuerfelt=$GROESSE, Dateisystem=$GROESSE_FS." >&2
    rm -rf "$ARBEIT"
    exit 2
fi

echo "  Wurf dieses Laufs : $GROESSE Byte (frisch aus /dev/urandom, K13)"
echo "  Probe-Schluessel  : $KEY"
echo "  Alias/Bucket      : $ALIAS/$BUCKET"
echo "-----------------------------------------------------------------------------"

ZIEL="$ALIAS/$BUCKET"
if [ -n "$PREFIX" ]; then
    PREFIX_BEREINIGT=$(printf '%s' "$PREFIX" | sed 's#^/*##; s#/*$##')
    [ -n "$PREFIX_BEREINIGT" ] && ZIEL="$ZIEL/$PREFIX_BEREINIGT"
fi
ZIEL="$ZIEL/$KEY"

# --- Schritt 1: einlagern. rc OHNE Pipe gemessen (K11). --------------------
CP_AUS="$ARBEIT/cp.json"
if timeout "$ZEITSCHRANKE" "$MC" cp --json "$QUELLE" "$ZIEL" > "$CP_AUS" 2>&1; then
    CP_RC=0
else
    CP_RC=$?
fi

if [ "$CP_RC" -ne 0 ]; then
    echo "FEHLER [INFRASTRUKTUR]: das Einlagern selbst ist fehlgeschlagen (mc cp rc=$CP_RC)." >&2
    echo "  Damit ist ueber die Lese-Seite nichts ausgesagt -- der Store nimmt schon" >&2
    echo "  nichts an. Meldung von mc (Credentials redigiert):" >&2
    sed 's#://[^ "@]*@#://***REDIGIERT***@#g' "$CP_AUS" | sed 's/^/    /' >&2
    rm -rf "$ARBEIT"
    exit 3
fi
echo "  Schritt 1 (einlagern) : mc cp rc=0"

# --- Schritt 2: die Wache befragen. Sollwert aus wc -c, nicht aus mc. ------
echo "  Schritt 2 (nachmessen): ci/object_stat_wache.sh --lokal <koeder>"
echo "-----------------------------------------------------------------------------"
if sh "$WACHE" "$KEY" --lokal "$QUELLE" --timeout "$ZEITSCHRANKE"; then
    VERDIKT=0
else
    VERDIKT=$?
fi

# --- Schritt 3: aufraeumen. Aendert das Verdikt NICHT. ---------------------
if [ "$BEHALTEN" -eq 0 ]; then
    if timeout "$ZEITSCHRANKE" "$MC" rm --json "$ZIEL" > "$ARBEIT/rm.json" 2>&1; then
        echo "  Schritt 3 (aufraeumen): Probe-Objekt geloescht."
    else
        echo "  WARNUNG: das Probe-Objekt '$KEY' konnte nicht geloescht werden." >&2
        echo "           Das aendert das Verdikt NICHT -- es ist eine Aussage ueber das" >&2
        echo "           Aufraeumen, nicht ueber den Round-Trip. Aber es bleibt Muell im" >&2
        echo "           Store, und das gehoert benannt." >&2
    fi
else
    echo "  Schritt 3 (aufraeumen): uebersprungen (--behalten), Objekt bleibt: $KEY"
fi
rm -rf "$ARBEIT"

echo "============================================================================="
if [ "$VERDIKT" -eq 0 ]; then
    echo "ABNAHME OK: ein frisch gewuerfeltes Objekt von $GROESSE Byte wurde eingelagert"
    echo "  und vom Store mit exakt dieser Groesse zurueckgemeldet."
    echo "  NENNER: 1 Objekt, 1 Round-Trip, 1 Groessen-Zusicherung; Sollwert aus"
    echo "  'wc -c' des Dateisystems, Istwert aus 'mc stat --json' des Stores."
else
    echo "ABNAHME FEHLGESCHLAGEN (rc=$VERDIKT): das Objekt wurde abgelegt, aber die" >&2
    echo "  Nachmessung haelt nicht. Die Klasse steht in der Meldung der Wache oben" >&2
    echo "  (INFRASTRUKTUR = Store weg, FACHLICH = Objekt fehlt oder falsche Groesse)." >&2
fi
echo "============================================================================="
exit "$VERDIKT"
