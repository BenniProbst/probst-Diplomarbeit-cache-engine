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
# DER MODUS (D3-1-Resthaelfte, 2026-08-09) -- "rot NUR bei modus=voll und Z==0":
# Die Wache urteilte bis heute modus-BLIND. Das ist an genau einer Stelle falsch:
# ein provision_only-Lauf MISST PER BAUART NICHTS. ce profile_run_entry.hpp
# setzt woertlich "provision_ok = a.provision_only && res.any_provisioned > 0"
# und der Zweig darunter laesst den Lauf damit mit Exit 0 enden, obwohl
# measured==0 und die CSV nur ihre Kopfzeile traegt. Diese Wache haette ihn
# getoetet -- ein richtiges Messgeraet am falschen Gegenstand.
#
# DER DRITTE MODUS (D3-7b, 2026-08-10) -- pruef_only:
# Dieselbe Lage ein zweites Mal, und sie war seit dem 09.08. offen. Der
# S3-Konformitaets-Lauf (ce profile_run_entry.hpp "if (a.pruef_only) { exit =
# any_pruef_ok > 0 && any_pruef_failed == 0 }") BAUT NICHT und MISST NICHT -- er
# laedt jede fertige .so und faehrt nur ihr Gate. Die emittierte
# Kampagnen-Pipeline faehrt ihn je Perm (ce planner/experiment_plan_director.hpp,
# COMDARE_PRUEF_ONLY=true). 0 Datenzeilen sind sein SOLL.
# WARUM DAS HIER STEHT UND NICHT NUR IM MARKER: bis D3-7b kannte die Allowlist
# unten nur voll|provision_only|prune_only. Ein Marker mit modus=pruef_only waere
# in den Zweig "unlesbarer Marker ist keine Erlaubnis" gefallen -- rc=2, JOB ROT.
# Der Marker allein haette den Lauf also nicht gerettet, sondern erst getoetet.
# Der Tippfehler-Zweig bleibt scharf: ein Modus, den niemand vergeben hat, ist
# weiter rc=2 (Probe F15/F19).
#
# WAS SICH AENDERT UND WAS AUSDRUECKLICH NICHT:
#   GEAENDERT ist NUR der Datenzeilen-Zweig (Mindestzahl verfehlt). Er ist rot
#     bei modus=voll und eine sichtbare WARNUNG bei modus=provision_only /
#     pruef_only / prune_only. Die Sichtbarkeit bleibt in allen -- Owner-KERN: "In
#     der Wissenschaft geht nicht immer alles glatt, aber das muss SICHTBAR
#     sein." Herabgestuft wird das URTEIL, nie die AUSGABE.
#   NICHT GEAENDERT ist der Keine-CSV-Zweig (N_CSV==0). Er bleibt in JEDEM Modus
#     rot. Begruendung, nicht Bequemlichkeit: auch der provision_only-Lauf
#     schreibt seine CSV, und der pruef_only-Lauf ebenso -- am Objekt
#     nachgelesen (10.08.): profile_run_entry.hpp oeffnet den Strom
#     ("std::ofstream csv{a.out_csv..., trunc}") und schreibt
#     "csv << ex::lazy_csv_header()" UNBEDINGT, lange vor jedem Modus-Zweig.
#     Beide Modi hinterlassen also eine Datei mit Kopfzeile und 0 Datenzeilen.
#     Ein Lauf, der ueberhaupt keine Datei hinterlaesst,
#     ist in keinem Modus ein gelungener Lauf. Wer diesen Zweig modus-abhaengig
#     macht, baut eine Wache, die im falschen Modus gar nicht mehr beissen kann.
#     AUSDRUECKLICH BENANNT: fuer modus=prune_only ist das zu scharf -- ein
#     Prune-Lauf erzeugt keine CSV. Heute ruft ihn kein CI-Job (COMDARE_PRUNE_ONLY
#     kommt in .gitlab-ci.yml und ci/ null Mal vor, gegengeprueft); wer ihn
#     einfuehrt, ruft diese Wache NICHT, sondern nur ci/lauf_marker.sh.
#
# WOHER DER MODUS KOMMT -- 'auto' liest den Marker, nicht den Aufrufer:
#   Ein Modus, den der CI-Aufrufer danebenlegt, ist eine BEHAUPTUNG ueber den
#   Lauf. Der Marker (ci/lauf_marker.sh, D3-7) ZITIERT stattdessen die
#   Abschluss-Zeile des Treibers. Deshalb ist 'auto' der Modus der Wahl in der
#   CI, und ein fehlender Marker ist dort kein Rueckfall auf einen Default,
#   sondern rc=2 -- kein Gruen ohne Pruefung.
#   WIDERSPRECHEN sich mehrere Marker, gewinnt der SCHAERFSTE (voll). Ein
#   provision_only-Marker neben einem voll-Marker darf das Gate nicht entwaffnen.
#
# AUFRUF:
#   sh ci/mess_ausbeute_wache.sh <verzeichnis> [<mindest-datenzeilen>] [<modus>]
#
#   <verzeichnis>          Wurzel, unter der rekursiv nach measurements.csv gesucht wird.
#   <mindest-datenzeilen>  Optional. Summe der Datenzeilen ueber ALLE gefundenen CSVs,
#                          die mindestens erreicht sein muss. Default 1.
#   <modus>                Optional. voll | provision_only | pruef_only |
#                          prune_only | auto.
#                          Default 'voll' -- der SCHAERFSTE. Ein Aufrufer, der den
#                          Modus nicht nennt, bekommt exakt das Verhalten von vor
#                          diesem Paket; die Heilung kann kein Gate versehentlich
#                          entschaerfen.
#
# EXIT: 0 = es wurden Messwerte erzeugt (mit Nenner belegt), oder der Modus misst
#           per Bauart nicht und die Lage ist als WARNUNG sichtbar
#       1 = keine CSV, oder (bei modus=voll) keine einzige Datenzeile bzw.
#           Mindestzahl verfehlt
#       2 = die Wache konnte nicht pruefen (Verzeichnis fehlt, Argument fehlt,
#           unbekannter Modus, modus=auto ohne Lauf-Marker) --
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
MODUS="${3:-voll}"

if [ -z "$WURZEL" ]; then
    echo "AUFRUF: sh ci/mess_ausbeute_wache.sh <verzeichnis> [<mindest-datenzeilen>] [<modus>]" >&2
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
case "$MODUS" in
    voll|provision_only|pruef_only|prune_only|auto) : ;;
    *)
        echo "ABBRUCH: unbekannter Modus '$MODUS'." >&2
        echo "         Erlaubt: voll | provision_only | pruef_only | prune_only | auto." >&2
        echo "         Ein unbekannter Modus wird NICHT auf einen Default zurueckgesetzt --" >&2
        echo "         ein Tippfehler wuerde sonst still das Gate entschaerfen." >&2
        exit 2
        ;;
esac

TMP=$(mktemp) || exit 2
trap 'rm -f "$TMP"' EXIT INT TERM

find "$WURZEL" -type f -name 'measurements.csv' > "$TMP" 2>/dev/null || true

N_CSV=$(awk 'END{print NR+0}' "$TMP")

# --- modus=auto: den Modus aus den Lauf-Markern LESEN, nicht behaupten -------
# Der Marker zitiert die Abschluss-Zeile des Treibers (ci/lauf_marker.sh, D3-7).
# Kein Marker => rc=2. Ein Rueckfall auf 'voll' waere zwar die scharfe Richtung,
# aber er wuerde die FEHLENDE DECKUNG verschweigen -- und genau das Verschweigen
# ist die Fehlerklasse dieses Pakets.
MODUS_QUELLE="Aufrufer-Argument"
if [ "$MODUS" = auto ]; then
    MTMP=$(mktemp) || exit 2
    trap 'rm -f "$TMP" "$MTMP"' EXIT INT TERM
    find "$WURZEL" -type f -name 'LAUF_MARKER.txt' > "$MTMP" 2>/dev/null || true
    N_MARKER=$(awk 'END{print NR+0}' "$MTMP")
    if [ "$N_MARKER" -eq 0 ]; then
        echo "ABBRUCH: modus=auto, aber unter '$WURZEL' liegt kein LAUF_MARKER.txt." >&2
        echo "         Ohne Marker ist nicht entscheidbar, ob dieser Lauf messen SOLLTE." >&2
        echo "         Zuerst 'sh ci/lauf_marker.sh schreiben <stdout-log> $WURZEL' fahren." >&2
        echo "         Kein Gruen ohne Pruefung." >&2
        exit 2
    fi
    # Der SCHAERFSTE gewinnt: ein einziger voll-Marker haelt das Gate scharf.
    # KEIN `xargs awk` ueber die Liste: xargs zerlegt lange Listen in MEHRERE
    # Aufrufe, und jeder druckt seine eigene Summe -- die Variable truege dann
    # mehrere Zeilen und der Zahlenvergleich braeche. Schleife statt Trick.
    N_VOLL=0
    ERSTER_MODUS=''
    while IFS= read -r MDAT; do
        [ -n "$MDAT" ] || continue
        MWERT=$(awk -F= '/^modus=/{print $2; exit}' "$MDAT" 2>/dev/null || true)
        [ -n "$ERSTER_MODUS" ] || ERSTER_MODUS="$MWERT"
        [ "$MWERT" = voll ] && N_VOLL=$((N_VOLL + 1))
    done < "$MTMP"
    if [ "$N_VOLL" -gt 0 ]; then
        MODUS=voll
    elif [ -n "$ERSTER_MODUS" ]; then
        MODUS="$ERSTER_MODUS"
    else
        MODUS=voll
    fi
    case "$MODUS" in
        voll|provision_only|pruef_only|prune_only) : ;;
        *)
            echo "ABBRUCH: die Lauf-Marker nennen den unbekannten Modus '$MODUS'." >&2
            echo "         Ein unlesbarer Marker ist keine Erlaubnis -- kein Gruen." >&2
            exit 2
            ;;
    esac
    MODUS_QUELLE="$N_MARKER Lauf-Marker, $N_VOLL davon modus=voll (schaerfster gewinnt)"
fi

echo "-----------------------------------------------------------------------------"
echo "MESS-AUSBEUTE-WACHE   Wurzel=$WURZEL   Mindest-Datenzeilen=$MINDEST"
echo "                      Modus=$MODUS   (Quelle: $MODUS_QUELLE)"
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
    # D3-1-Resthaelfte: "rot NUR bei modus=voll und Z==0".
    # Der Zweig ist EIN `exit 1`, nur unter einer Bedingung -- ausdruecklich kein
    # zweiter Ausgang. Die AUSGABE ist in beiden Modi dieselbe Aussage; nur das
    # URTEIL unterscheidet sich, und der Grund dafuer steht daneben.
    echo "BEFUND: der Messlauf hat $SUMME Datenzeile(n) erzeugt, gefordert waren $MINDEST."
    if [ "$MODUS" = voll ]; then
        echo "FEHLER: der Messlauf hat $SUMME Datenzeile(n) erzeugt, gefordert waren $MINDEST." >&2
        echo "        Eine vorhandene Datei ist KEIN Messwert. Der Lauf gilt als gescheitert." >&2
        echo "        (modus=voll -- dieser Lauf SOLLTE messen.)" >&2
        exit 1
    fi
    echo "WARNUNG: modus=$MODUS -- dieser Lauf misst per Bauart nicht."
    # D3-7b: DAS ERFOLGSMASS IST JE MODUS EIN ANDERES, und der Text muss das
    # sagen. Bis hierher nannte er in JEDEM weichen Modus das provision_only-
    # Erfolgsmass -- unter modus=pruef_only oder prune_only war das eine falsche
    # Auskunft mitten in einer gruenen Ausgabe, also genau die zweite Wahrheit,
    # gegen die diese Wache gebaut ist.
    case "$MODUS" in
        provision_only)
            echo "         ce profile_run_entry.hpp ('provision_ok = a.provision_only &&"
            echo "         res.any_provisioned > 0'): im provision_only-Lauf ist 'mindestens"
            echo "         eine DLL bereitgestellt' das Erfolgsmass, nicht die Datenzeile."
            echo "         Ob wirklich bereitgestellt wurde, entscheidet NICHT diese Wache:"
            echo "         das Feld provisioned= steht im Lauf-Marker (ci/lauf_marker.sh)."
            ;;
        pruef_only)
            echo "         ce profile_run_entry.hpp ('if (a.pruef_only) { exit = any_pruef_ok"
            echo "         > 0 && any_pruef_failed == 0 }'): der S3-Konformitaets-Lauf baut"
            echo "         nicht und misst nicht -- er laedt jede fertige .so und faehrt nur"
            echo "         ihr Gate. Erfolgsmass ist das GATE, nicht die Datenzeile."
            echo "         Ob das Gate hielt, entscheidet NICHT diese Wache, sondern der"
            echo "         Exit-Code des Treibers selbst (exit!=0 bei JEDEM Gate-Fail)."
            ;;
        *)
            echo "         In diesem Modus ist die Datenzeile ueberhaupt nicht das"
            echo "         Erfolgsmass. Was der Lauf geleistet hat, entscheidet NICHT diese"
            echo "         Wache -- sie zaehlt nur Datenzeilen und sagt es hier laut."
            ;;
    esac
    echo "         $SUMME Datenzeile(n) sind hier ein BEFUND, kein Fehler."
    echo "MESS-AUSBEUTE-WACHE: OK ($SUMME Datenzeile(n), modus=$MODUS -- Warnung, kein Fehler)."
    exit 0
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
