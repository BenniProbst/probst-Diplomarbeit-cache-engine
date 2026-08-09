#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  BESTANDSLOG-WACHE -- das Lager gilt erst als scharf, wenn der Lauf es SELBST
#  im Log meldet, mit dem Schluessel und dem Besitzer, die gesetzt wurden.
#                                                                   (2026-08-09)
# =============================================================================
#
# SELBSTCHECK -- was diese Datei zusichert, und was NICHT:
#   ZUSICHERT: dass in einer Log-Datei EINE Zeile steht, die der Bestandslog-
#     Binder selbst geschrieben hat, und dass die WERTE in dieser Zeile
#     (doc_key, owner_uuid, optional maschine) exakt die sind, die der Aufrufer
#     erwartet hat. Gleichheit wird auf ganzen awk-Feldern geprueft, nicht als
#     Teilzeichenkette.
#   ZUSICHERT NICHT: dass das Bestandslog-Dokument im Objekt-Store wirklich
#     entstanden ist. Das ist eine Aussage ueber den Store, nicht ueber das Log,
#     und sie gehoert an ein object_stat -- nicht hierher. Diese Wache belegt
#     ausschliesslich, dass das Gate GEZUENDET hat.
#
# DER BEFUND, GEGEN DEN SIE GEBAUT IST (09.08.2026):
# COMDARE_BESTANDSLOG stand in NULL von zwei aktiven .gitlab-ci.yml (super 0,
# ce 0, selbst gezaehlt). Der Binder war fertig und fail-loud, der Director
# reichte die Variablen an Child-Pipelines durch -- es fehlte allein der
# Schalter. Ein solcher Zustand faellt nicht auf: ohne Opt-in ist der Binder
# ausdruecklich STUMM (Byte-Neutralitaet des Vor-Zustands). Genau deshalb muss
# die Scharfschaltung eine Wache haben, die das Schweigen zum Fehler macht.
#
# WARUM FELD-GLEICHHEIT UND KEIN WORT-GREP:
# Ein grep auf "bestandslog" trifft jeden Kommentar, jede Hilfe-Ausgabe und jede
# WARNUNG -- auch die, die meldet, dass das Lager gerade NICHT bindet. Ein grep
# auf "doc_key=lager/bestand.xml" traefe auch "doc_key=lager/bestand.xml.alt".
# Die Wache zerlegt die Zeile deshalb in Felder und vergleicht die Werte GANZ.
# Das ist der Unterschied zwischen "das Wort kommt vor" und "die Aussage stimmt".
#
# DIE ZWEI ERZEUGER, EINE WACHE:
#   Treiber (super, 02_messung_driver/main.cpp):
#     [bestandslog] aktiv: doc_key=<K> maschine=<M> key_of=... owner=<O>
#   Planer  (ce, apps/experiment_planner/main.cpp):
#     [bestandslog] planer_block aktiv: doc_key=<K> id=<O>/planer maschine=<M>
#   Beide melden dieselbe Tatsache in zwei Formen. Der Besitzer steht beim
#   Treiber als owner=<O>, beim Planer im Schluessel id=<O>/planer -- die Wache
#   liest owner= bevorzugt und faellt sonst auf id= zurueck (letztes /-Segment
#   abgeschnitten). Warum der owner ueberhaupt geprueft wird: an ihm haengt die
#   Takeover-Regel (ETA + 50 % ohne Update -> eine andere Maschine uebernimmt).
#   Ist er nicht eindeutig, uebernimmt eine Maschine sich selbst.
#
# DAS ZWEITE GENUS (Kette D, 09.08.2026) -- eine DRITTE Zeilenform, EIGENER Nenner:
#     [bestandslog] messwert-genus verdrahtet: doc_key=<MK> maschine=<M> gebunden=<0|1> ...
#   Der Treiber schreibt sie an der VERDRAHTUNGS-Stelle und liest doc_key und
#   gebunden aus dem Fassaden-Argument ZURUECK (pa.mess_bestand_*): fehlt die
#   Verdrahtung, meldet die Zeile ein leeres doc_key bzw. gebunden=0 -- oder sie
#   faellt gar nicht. Gefordert wird sie nur, wenn das 5. Argument gesetzt ist
#   (die Jobs, in denen das Genus feuert, fordern sie; der Planer-Job nicht,
#   denn der Planer traegt das Messwert-Genus gar nicht).
#   ZWEI BEFUNDE des Gegenlesens vom 09.08. stecken in dieser Erweiterung:
#   B2: die messwert-genus-Zeile trug frueher das Feld "aktiv:" und fiel damit
#       in den BINARY-Nenner -- im Drift-Fall benannte die Wache die
#       unschuldige Messwert-Zeile als Kronzeugen. Jede Zeile mit dem Feld
#       "messwert-genus" gehoert deshalb NIE in den Binary-Nenner.
#   B1: ohne geforderte Zeile liessen sich die zwei pa.mess_bestand_*-
#       Zuweisungen ersatzlos streichen und jedes Gate blieb gruen.
#
# AUFRUF:
#   sh ci/bestandslog_wache.sh <logdatei> <doc_key> <owner_uuid> [<maschine>] [<mess_doc_key>]
#
# EXIT: 0 = aktiv-Zeile vorhanden UND alle erwarteten Werte stimmen; ist
#           <mess_doc_key> gesetzt, zusaetzlich: messwert-genus-Zeile vorhanden
#           mit exakt diesem doc_key, dieser maschine und gebunden=1
#       1 = keine aktiv-Zeile, ein Wert weicht ab, oder die geforderte
#           messwert-genus-Zeile fehlt/weicht ab (der eigentliche Biss)
#       2 = die Wache konnte nicht pruefen (Datei/Argument fehlt) -- ausdruecklich
#           KEIN Gruen: ein stiller Rueckfall waere derselbe Defekt, gegen den
#           diese Wache gebaut ist.
#
# POSIX-sh, ASCII-only, kein Python (Hausdoktrin: kein Python in der Buildchain).
# Kein grep -P (das /usr/bin/grep dieses Hauses kann ugrep sein -> STILLE 0).
# =============================================================================

set -eu

LOGDATEI="${1:-}"
ERW_DOC_KEY="${2:-}"
ERW_OWNER="${3:-}"
ERW_MASCHINE="${4:-}"
ERW_MESS_DOC_KEY="${5:-}"

if [ -z "$LOGDATEI" ] || [ -z "$ERW_DOC_KEY" ] || [ -z "$ERW_OWNER" ]; then
    echo "AUFRUF: sh ci/bestandslog_wache.sh <logdatei> <doc_key> <owner_uuid> [<maschine>]" >&2
    echo "        Ohne erwartete Werte gibt es nichts zu pruefen -- kein Gruen ohne Pruefung." >&2
    exit 2
fi
if [ ! -f "$LOGDATEI" ]; then
    echo "ABBRUCH: '$LOGDATEI' ist keine Datei -- die Wache konnte nicht pruefen." >&2
    echo "         Kein Gruen ohne Pruefung." >&2
    exit 2
fi

echo "-----------------------------------------------------------------------------"
echo "BESTANDSLOG-WACHE"
echo "  Log      = $LOGDATEI"
echo "  doc_key  = $ERW_DOC_KEY"
echo "  owner    = $ERW_OWNER"
if [ -n "$ERW_MASCHINE" ]; then
    echo "  maschine = $ERW_MASCHINE"
else
    echo "  maschine = (nicht gefordert)"
fi
if [ -n "$ERW_MESS_DOC_KEY" ]; then
    echo "  mess_key = $ERW_MESS_DOC_KEY  (messwert-genus-Zeile GEFORDERT)"
else
    echo "  mess_key = (nicht gefordert)"
fi
echo "-----------------------------------------------------------------------------"

# Die gesamte Auswertung in EINEM awk-Lauf: Feld-Zerlegung, Wert-Vergleich und
# Nenner-Bildung gehoeren zusammen. awk liest Felder whitespace-getrennt, ein
# Vergleich auf $i == "doc_key=" ERW ist damit ein Ganzfeld-Vergleich.
#
# rc-Fallen bewusst umgangen (K11): awk schreibt seinen Befund in eine Datei,
# der Exit-Status wird DANACH gelesen -- keine Pipe zwischen awk und dem Test.
BEFUND=$(mktemp) || exit 2
trap 'rm -f "$BEFUND"' EXIT INT TERM

awk -v erw_key="$ERW_DOC_KEY" -v erw_owner="$ERW_OWNER" -v erw_masch="$ERW_MASCHINE" \
    -v erw_mess="$ERW_MESS_DOC_KEY" '
function wert(feld,   p) { p = index(feld, "="); return (p == 0) ? "" : substr(feld, p + 1) }
BEGIN { zeilen = 0; marker = 0; aktiv = 0; warn = 0; treffer = 0; messz = 0; messtreffer = 0 }
{
    zeilen++
    ist_marker = 0
    for (i = 1; i <= NF; i++) if ($i == "[bestandslog]") { ist_marker = 1; break }
    if (!ist_marker) next
    marker++

    # WARNUNG/FEHLER zaehlen -- sie sind der haeufigste Grund fuer ein stilles Lager
    # und muessen im Nenner sichtbar sein, statt als "keine aktiv-Zeile" zu enden.
    for (i = 1; i <= NF; i++) {
        if ($i == "WARNUNG") { warn++; warnzeile = $0 }
        if ($i == "FEHLER")  { warn++; warnzeile = $0 }
    }

    # GENUS-UNTERSCHEIDUNG (Kette D, B2): eine Zeile mit dem Feld "messwert-genus"
    # gehoert NIE in den Binary-Nenner. Vor dieser Unterscheidung fiel die
    # messwert-genus-Zeile (die frueher das Feld "aktiv:" trug) in den Binary-
    # Zweig und wurde im Drift-Fall als LETZTE ABWEICHENDE ZEILE benannt -- der
    # Kronzeuge zeigte auf die unschuldige Zeile.
    ist_mess = 0
    for (i = 1; i <= NF; i++) if ($i == "messwert-genus") { ist_mess = 1; break }
    if (ist_mess) {
        messz++
        g_mess_key = ""; g_mess_masch = ""; g_gebunden = ""
        for (i = 1; i <= NF; i++) {
            if (index($i, "doc_key=")  == 1) g_mess_key   = wert($i)
            if (index($i, "maschine=") == 1) g_mess_masch = wert($i)
            if (index($i, "gebunden=") == 1) g_gebunden   = wert($i)
        }
        mok = 1
        if (g_mess_key != erw_mess) {
            mok = 0; mabw = mabw sprintf("      mess_doc_key gelesen=[%s] erwartet=[%s]\n", g_mess_key, erw_mess)
        }
        if (erw_masch != "" && g_mess_masch != erw_masch) {
            mok = 0; mabw = mabw sprintf("      maschine     gelesen=[%s] erwartet=[%s]\n", g_mess_masch, erw_masch)
        }
        # gebunden=1 ist Pflicht: die Zeile liest den Binder aus dem Fassaden-
        # Argument zurueck -- gebunden=0 heisst, key_of haengt NICHT an der Fassade.
        if (g_gebunden != "1") {
            mok = 0; mabw = mabw sprintf("      gebunden     gelesen=[%s] erwartet=[1]\n", g_gebunden)
        }
        if (mok) { messtreffer++; messtrefferzeile = $0 } else { messfehlzeile = $0 }
        next
    }

    # aktiv-Zeile: ein Feld ist exakt "aktiv:" (Treiber wie Planer schreiben es so).
    ist_aktiv = 0
    for (i = 1; i <= NF; i++) if ($i == "aktiv:") { ist_aktiv = 1; break }
    if (!ist_aktiv) next
    aktiv++

    g_key = ""; g_owner = ""; g_masch = ""
    for (i = 1; i <= NF; i++) {
        if (index($i, "doc_key=")  == 1) g_key   = wert($i)
        if (index($i, "maschine=") == 1) g_masch = wert($i)
        if (index($i, "owner=")    == 1) g_owner = wert($i)
        # Planer-Form: id=<owner>/planer -- das LETZTE /-Segment ist die Rolle,
        # nicht der Besitzer. Nur setzen, wenn kein explizites owner= kam.
        if (index($i, "id=") == 1 && g_owner == "") {
            roh = wert($i)
            p = 0
            for (k = length(roh); k >= 1; k--) if (substr(roh, k, 1) == "/") { p = k; break }
            g_owner = (p > 0) ? substr(roh, 1, p - 1) : roh
        }
    }

    ok = 1
    if (g_key   != erw_key)   { ok = 0; abw = abw sprintf("      doc_key  gelesen=[%s] erwartet=[%s]\n", g_key, erw_key) }
    if (g_owner != erw_owner) { ok = 0; abw = abw sprintf("      owner    gelesen=[%s] erwartet=[%s]\n", g_owner, erw_owner) }
    if (erw_masch != "" && g_masch != erw_masch) {
        ok = 0; abw = abw sprintf("      maschine gelesen=[%s] erwartet=[%s]\n", g_masch, erw_masch)
    }
    if (ok) { treffer++; trefferzeile = $0 } else { fehlzeile = $0 }
}
END {
    printf "ZEILEN=%d MARKER=%d AKTIV=%d WARN=%d TREFFER=%d", zeilen, marker, aktiv, warn, treffer
    printf " MESSZ=%d MESSTREFFER=%d\n", messz, messtreffer
    printf "TREFFERZEILE=%s\n", trefferzeile
    printf "FEHLZEILE=%s\n", fehlzeile
    printf "WARNZEILE=%s\n", warnzeile
    printf "MESSTREFFERZEILE=%s\n", messtrefferzeile
    printf "MESSFEHLZEILE=%s\n", messfehlzeile
    printf "ABWEICHUNG_BEGIN\n%sABWEICHUNG_ENDE\n", abw
    printf "MESS_ABWEICHUNG_BEGIN\n%sMESS_ABWEICHUNG_ENDE\n", mabw
}
' "$LOGDATEI" > "$BEFUND"
AWK_RC=$?
if [ "$AWK_RC" -ne 0 ]; then
    echo "ABBRUCH: awk endete mit rc=$AWK_RC -- die Wache konnte nicht pruefen." >&2
    exit 2
fi

hole() { awk -v k="$1" 'index($0, k "=") == 1 { print substr($0, length(k) + 2) }' "$BEFUND"; }

ZAHLEN=$(awk '/^ZEILEN=/ { print; exit }' "$BEFUND")
N_ZEILEN=$(printf '%s\n' "$ZAHLEN" | awk '{ sub(/^ZEILEN=/, "", $1); print $1 }')
N_MARKER=$(printf '%s\n' "$ZAHLEN" | awk '{ sub(/^MARKER=/, "", $2); print $2 }')
N_AKTIV=$(printf '%s\n'  "$ZAHLEN" | awk '{ sub(/^AKTIV=/,  "", $3); print $3 }')
N_WARN=$(printf '%s\n'   "$ZAHLEN" | awk '{ sub(/^WARN=/,   "", $4); print $4 }')
N_TREFFER=$(printf '%s\n' "$ZAHLEN" | awk '{ sub(/^TREFFER=/, "", $5); print $5 }')
N_MESSZ=$(printf '%s\n' "$ZAHLEN" | awk '{ sub(/^MESSZ=/, "", $6); print $6 }')
N_MESSTREFFER=$(printf '%s\n' "$ZAHLEN" | awk '{ sub(/^MESSTREFFER=/, "", $7); print $7 }')

echo "NENNER (nie eine nackte Null):"
echo "  $N_ZEILEN Log-Zeile(n) gelesen."
echo "  $N_MARKER davon tragen den Marker [bestandslog]."
echo "  $N_AKTIV davon sind aktiv-Zeilen, $N_MESSZ messwert-genus-Zeilen, $N_WARN WARNUNG/FEHLER."
echo "  $N_TREFFER aktiv-Zeile(n) stimmen in ALLEN geforderten Werten ueberein."
if [ -n "$ERW_MESS_DOC_KEY" ]; then
    echo "  $N_MESSTREFFER messwert-genus-Zeile(n) melden die geforderte Verdrahtung."
fi
echo "-----------------------------------------------------------------------------"

BINARY_OK=0
[ "$N_TREFFER" -ge 1 ] && BINARY_OK=1
MESS_OK=1
if [ -n "$ERW_MESS_DOC_KEY" ]; then
    MESS_OK=0
    [ "$N_MESSTREFFER" -ge 1 ] && MESS_OK=1
fi

if [ "$BINARY_OK" -eq 1 ] && [ "$MESS_OK" -eq 1 ]; then
    echo "BELEG (literal aus dem Log):"
    hole TREFFERZEILE | awk 'NF { print "  " $0 }'
    if [ -n "$ERW_MESS_DOC_KEY" ]; then
        hole MESSTREFFERZEILE | awk 'NF { print "  " $0 }'
        echo "BESTANDSLOG-WACHE: OK (Gate gezuendet, doc_key und owner stimmen; Messwert-Genus verdrahtet)."
    else
        echo "BESTANDSLOG-WACHE: OK (Gate gezuendet, doc_key und owner stimmen)."
    fi
    exit 0
fi

# --- ab hier: der Biss. Die Ursache wird BENANNT, nicht nur der Fehlschlag. ---
if [ "$BINARY_OK" -ne 1 ]; then
    echo "FEHLER: keine aktiv-Zeile mit den erwarteten Werten." >&2
    if [ "$N_MARKER" -eq 0 ]; then
        echo "  URSACHE: das Log traegt KEINE einzige [bestandslog]-Zeile." >&2
        echo "           Das Gate hat nie gezuendet -- COMDARE_BESTANDSLOG ist nicht 'true'," >&2
        echo "           oder die Variable erreicht den Job gar nicht (Forward-Grenze)." >&2
    elif [ "$N_AKTIV" -eq 0 ]; then
        echo "  URSACHE: Marker vorhanden, aber keine aktiv-Zeile -- das Opt-in ist gesetzt," >&2
        echo "           das Lager bindet aber nicht. Typisch: Ebene B (minio) fehlt im Job." >&2
        echo "  LETZTE WARNUNG/FEHLER-ZEILE (literal):" >&2
        hole WARNZEILE | awk 'NF { print "    " $0 }' >&2
    else
        echo "  URSACHE: aktiv-Zeile vorhanden, aber die Werte weichen ab (Drift)." >&2
        echo "  LETZTE ABWEICHENDE ZEILE (literal):" >&2
        hole FEHLZEILE | awk 'NF { print "    " $0 }' >&2
        echo "  ABWEICHUNGEN:" >&2
        awk '/^ABWEICHUNG_BEGIN$/ { an = 1; next } /^ABWEICHUNG_ENDE$/ { an = 0 } an && NF' "$BEFUND" >&2
    fi
fi
if [ -n "$ERW_MESS_DOC_KEY" ] && [ "$MESS_OK" -ne 1 ]; then
    echo "FEHLER: das MESSWERT-Genus meldet die geforderte Verdrahtung nicht." >&2
    if [ "$N_MESSZ" -eq 0 ]; then
        echo "  URSACHE: KEINE messwert-genus-Zeile im Log. Die Host-Belegung hat sich nie" >&2
        echo "           als verdrahtet gemeldet -- exakt der Zustand, in dem die zwei" >&2
        echo "           pa.mess_bestand_*-Zuweisungen fehlen oder das Genus nie feuerte." >&2
    else
        echo "  URSACHE: messwert-genus-Zeile(n) vorhanden, aber die Werte weichen ab." >&2
        echo "  LETZTE ABWEICHENDE MESSWERT-ZEILE (literal):" >&2
        hole MESSFEHLZEILE | awk 'NF { print "    " $0 }' >&2
        echo "  ABWEICHUNGEN:" >&2
        awk '/^MESS_ABWEICHUNG_BEGIN$/ { an = 1; next } /^MESS_ABWEICHUNG_ENDE$/ { an = 0 } an && NF' "$BEFUND" >&2
    fi
fi
echo "        Ein scharfes Lager, das schweigt, ist kein scharfes Lager." >&2
exit 1
