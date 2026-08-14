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
#           Mindestzahl verfehlt, oder (bei modus=voll, ##26 M==N) mindestens
#           eine gefundene CSV ganz ohne Datenzeile neben vollen
#       2 = die Wache konnte nicht pruefen (Verzeichnis fehlt, Argument fehlt,
#           unbekannter Modus, modus=auto ohne Lauf-Marker) --
#           ausdruecklich KEIN Gruen: ein stiller Rueckfall waere derselbe Defekt.
#
# ZAEHLWEISE, ausdruecklich benannt -- WORTGLEICH zu ci/persist_sammler.sh und
# ci/frische_wache.sh (dasselbe awk-Programm, Byte fuer Byte):
#   Datenzeilen = alle Zeilen AB DER ZWEITEN, die mindestens ein Zeichen tragen,
#   das kein Leerraum ist. Die erste Zeile ist der CSV-Kopf und zaehlt nie mit.
#   Gezaehlt wird mit awk, NICHT mit `wc -l`: wc zaehlt Zeilenumbrueche, eine
#   Datei ohne abschliessenden Newline wuerde eine Zeile zu wenig melden. Eine
#   voellig leere Datei hat 0 Zeilen und damit 0 Datenzeilen (nicht -1).
#
#   EINE LEERZEILE IST KEIN MESSWERT (D3-3b). Bis 10.08.2026 rechnete die Wache
#   `Datenzeilen = Zeilen - 1` und zaehlte damit jede leere und jede nur aus
#   Blanks/Tabs bestehende Zeile als Messwert mit: eine CSV aus Kopf + drei
#   Leerzeilen + EINER echten Zeile meldete 4. Genau die Zahl entscheidet ueber
#   `<mindest-datenzeilen>`, ueber das Commit-Gate des Sammlers und ueber das
#   Maskierungs-Gate der Frische-Wache -- ein Messlauf konnte die Mindestzahl
#   also mit Leerzeilen erreichen. Die Heilung geht nur in die scharfe Richtung:
#   die Zahl kann seither nur kleiner werden, nie groesser, und keine Wache wird
#   dadurch weicher.
#
#   EIN DURCHLAUF, ZWEI ZAHLEN: das awk-Programm gibt "<rohzeilen> <datenzeilen>"
#   aus. Der Rohwert bleibt damit als NENNER in der Ausgabe stehen -- sonst waere
#   nach dieser Heilung nicht mehr sichtbar, ob eine Datei leer war oder ob ihre
#   Zeilen verworfen wurden. Ein zweiter Lesevorgang je Datei waere der falsche
#   Preis dafuer.
#
#   EINE n/a-ZEILE IST KEIN MESSWERT (KON44-02 / D4d, 12.08.2026). Der Anlassfall
#   am Objekt (WF9-Beleg, MANUAL_RUN.md Abschnitt 8b): der F1-Durchstich-Lauf
#   hinterliess GENAU EINE Datenzeile -- mit n_ops=n/a, total_ns=n/a,
#   ns_per_op=n/a (eine PROVISIONIERTE Zeile, provisioned=1, kein Messwert).
#   Diese Wache meldete OK (1 Datenzeile); nur durchstich_wache frische fing den
#   Lauf. Eine n/a-Zeile ist aber keine Daten-AUSSAGE -- sie sagt "hier fehlt der
#   Wert", nicht "hier ist einer". Deshalb je CSV eine ZWEITE awk-Zaehlung
#   (FS=';'): eine n/a-Zeile ist eine Datenzeile, deren Felder 4/5/6
#   (n_ops/total_ns/ns_per_op laut Kopf, ce cache_engine_builder_iterator.hpp:550)
#   alle drei woertlich "n/a" sind. Das geteilte PAAR-awk bleibt dabei BYTE-GLEICH
#   zu ci/persist_sammler.sh und ci/frische_wache.sh -- die n/a-Zaehlung ist ein
#   EIGENES, zweites Programm, kein Umbau des geteilten.
#   URTEIL: modus=voll wird NEU rot, wenn die ECHTEN Zeilen (Datenzeilen minus
#   n/a) die Mindestzahl verfehlen; die weichen Modi bleiben WARNUNG. Die alten
#   Zweige (keine CSV / Datenzeilen-Summe) sind unveraendert -- die Heilung geht
#   nur in die scharfe Richtung.
#
# DER VIERTE ROTE ZWEIG (##26 M==N, KON60-05, 2026-08-14) -- Teil-Ausbeute:
#   Bis heute war "eine leere CSV neben vollen" in JEDEM Modus nur eine WARNUNG
#   am gruenen Ende. Im Voll-Messlauf ist das dieselbe Fehlerklasse wie die vom
#   08.08.: ein Pruefling ohne einen einzigen Messwert bestand den Lauf, weil
#   die ANDEREN geliefert haben. Owner-Zuweisung KON60-05 (Fix-Form Komplex-Fix):
#   modus=voll fordert M==N -- jede der N gefundenen measurements.csv traegt
#   mindestens eine Datenzeile (M = Dateien mit Datenzeilen); sonst exit 1.
#   Die weichen Modi bleiben WARNUNG: dort ist die Datenzeile per Bauart nicht
#   das Erfolgsmass, M==N also unerfuellbar und kein Urteilsgrund. Die AUSGABE
#   ist in allen Modi dieselbe (BEFUND-Zeile, wortgleich); herabgestuft wird
#   nur das URTEIL -- nie die AUSGABE (Owner-KERN, s.o.). Die Heilung geht
#   auch hier nur in die scharfe Richtung.
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
LEERZEILEN=0
NA_SUMME=0
while IFS= read -r F; do
    [ -n "$F" ] || continue
    # Ein Lesevorgang, zwei Zahlen: "<rohzeilen> <datenzeilen>". Das awk-Programm
    # steht Byte-gleich in ci/persist_sammler.sh und ci/frische_wache.sh.
    PAAR=$(awk 'NR>1 && $0 ~ /[^[:space:]]/ {n++} END{printf "%d %d\n", NR+0, n+0}' "$F")
    ZEILEN=${PAAR%% *}
    DATEN=${PAAR##* }
    # KON44-02 / D4d: ZWEITE Zaehlung, EIGENES Programm (das geteilte PAAR-awk oben bleibt byte-gleich).
    # n/a-Zeile := Datenzeile, deren Felder 4/5/6 (n_ops/total_ns/ns_per_op laut Kopfzeile,
    # ce cache_engine_builder_iterator.hpp:550) alle drei woertlich "n/a" sind -- eine provisionierte
    # Zeile, keine Daten-Aussage.
    NA=$(awk -F';' \
        'NR>1 && $0 ~ /[^[:space:]]/ && $4=="n/a" && $5=="n/a" && $6=="n/a" {n++} END{printf "%d\n", n+0}' "$F")
    if [ "$ZEILEN" -gt 1 ]; then
        LEERZEILEN=$((LEERZEILEN + ZEILEN - 1 - DATEN))
    fi
    if [ "$DATEN" -eq 0 ]; then
        N_LEER=$((N_LEER + 1))
        echo "  LEER   $F  ($ZEILEN Rohzeile(n), 0 Datenzeile(n) = Kopf, nichts oder nur Leerzeilen)"
    else
        N_MIT=$((N_MIT + 1))
        echo "  DATEN  $F  ($DATEN Datenzeile(n) aus $ZEILEN Rohzeile(n), davon $NA n/a)"
    fi
    SUMME=$((SUMME + DATEN))
    NA_SUMME=$((NA_SUMME + NA))
done < "$TMP"
# KON44-02: ECHT = Datenzeilen ohne die n/a-/provisionierten -- nur sie sind eine Daten-Aussage.
ECHT=$((SUMME - NA_SUMME))

echo "-----------------------------------------------------------------------------"
echo "NENNER (nie eine nackte Null):"
echo "  $N_CSV measurements.csv gefunden."
echo "  davon $N_MIT mit Datenzeilen, $N_LEER ohne (nur Kopfzeile oder leer)."
echo "  $SUMME Datenzeile(n) insgesamt, gefordert waren mindestens $MINDEST."
echo "  $ECHT echte, $NA_SUMME n/a-/provisionierte Zeile(n) (n_ops/total_ns/ns_per_op == n/a; KON44-02/D4d)."
echo "  $LEERZEILEN Leerzeile(n) verworfen (leer oder nur Leerraum -- kein Messwert)."
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
            echo "         > 0 && any_pruef_failed == 0 }'): der S3-Konformitaets-Lauf MISST"
            echo "         NICHT und gatet nur -- er faehrt je fertiger .so ihr Gate."
            echo "         Erfolgsmass ist das GATE, nicht die Datenzeile."
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

# KON44-02 / D4d (12.08.2026): die Datenzeilen-Summe reicht, aber die ECHTEN Zeilen nicht --
# der n/a-Phantom-Fall. Eine n/a-Zeile ist keine Daten-Aussage; ein Lauf, der die Mindestzahl
# nur mit provisionierten Zeilen erreicht, hat nicht gemessen. EIGENE Meldung (nicht die des
# Summen-Zweigs): wer hier landet, hat Dateien UND Zeilen -- nur keine Werte. modus=voll ist
# rot; die weichen Modi bleiben WARNUNG (sie messen per Bauart nicht, s. oben).
if [ "$ECHT" -lt "$MINDEST" ]; then
    echo "BEFUND: von $SUMME Datenzeile(n) sind nur $ECHT echte Messzeile(n); $NA_SUMME n/a-/provisionierte Zeile(n)."
    if [ "$MODUS" = voll ]; then
        echo "FEHLER: nur $ECHT echte Messzeile(n), gefordert waren mindestens $MINDEST --" >&2
        echo "        $NA_SUMME n/a-/provisionierte Zeile(n) zaehlen NICHT (D4d: n/a ist keine Daten-Aussage)." >&2
        echo "        Eine provisionierte Zeile ist KEIN Messwert. Der Lauf gilt als gescheitert." >&2
        echo "        (modus=voll -- dieser Lauf SOLLTE messen.)" >&2
        exit 1
    fi
    echo "WARNUNG: modus=$MODUS -- $ECHT echte Messzeile(n), $NA_SUMME n/a-/provisionierte."
    echo "         In diesem Modus ist die echte Messzeile nicht das Erfolgsmass; der Befund bleibt sichtbar."
fi

# ##26 M==N (KON60-05, 2026-08-14): Teil-Ausbeute ist bei modus=voll ein ABBRUCH.
# Eine leere CSV neben vollen heisst: ein Pruefling hat nichts geliefert -- im
# Voll-Messlauf ist das kein Randbefund, sondern ein gescheiterter Teil des
# Laufs (M von N Dateien tragen Daten, gefordert ist M==N). Die weichen Modi
# bleiben WARNUNG: dort ist die Datenzeile per Bauart nicht das Erfolgsmass
# (s. Modus-Zweige oben), M==N also unerfuellbar. Der Owner-KERN gilt in beiden
# Richtungen: "In der Wissenschaft geht nicht immer alles glatt, aber das muss
# SICHTBAR sein." Herabgestuft wird das URTEIL, nie die AUSGABE: die
# BEFUND-Zeile steht in jedem Modus wortgleich da.
if [ "$N_LEER" -gt 0 ]; then
    echo "BEFUND: $N_LEER von $N_CSV CSV-Dateien tragen KEINE Datenzeile."
    if [ "$MODUS" = voll ]; then
        echo "FEHLER: $N_LEER von $N_CSV CSV-Dateien tragen KEINE Datenzeile." >&2
        echo "        Gefordert ist M==N: jede der $N_CSV gefundenen Dateien traegt mindestens" >&2
        echo "        eine Datenzeile; hier liefern nur $N_MIT von $N_CSV." >&2
        echo "        Ein Pruefling ohne Datenzeile ist im Voll-Messlauf gescheitert, keine Fussnote." >&2
        echo "        (modus=voll -- dieser Lauf SOLLTE messen.)" >&2
        exit 1
    fi
    echo "WARNUNG: $N_LEER von $N_CSV CSV-Dateien tragen KEINE Datenzeile."
    echo "         Der Lauf gilt als gelungen, aber diese Pruefling(e) haben nichts geliefert."
    echo "         Das ist ein Befund, kein Rauschen -- er gehoert in die Auswertung."
fi

echo "MESS-AUSBEUTE-WACHE: OK ($ECHT echte, $NA_SUMME n/a-/provisionierte" \
    "Datenzeile(n) aus $N_MIT von $N_CSV Datei(en))."
exit 0
