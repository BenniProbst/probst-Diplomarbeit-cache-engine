#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  LAUF-MARKER -- neben jeder Mess-CSV steht, WELCHER LAUF sie geschrieben hat
#  und in WELCHEM MODUS.                                          (2026-08-09)
# =============================================================================
#
# DER BEFUND, GEGEN DEN ER GEBAUT IST (D3-7):
# Eine measurements.csv im Arbeitsbaum sagt NICHT, aus welchem Lauf sie stammt.
# Damit ist jedes Inhalts-Gate entweder zu scharf oder zu stumpf:
#   * zu scharf -- ein provision_only-Lauf misst per Bauart NICHTS (ce
#     profile_run_entry.hpp, "provision_ok = a.provision_only &&
#     res.any_provisioned > 0"; der Zweig darunter laesst ihn mit Exit 0 enden).
#     Eine Ausbeute-Wache, die immer "0 Datenzeilen = rot" sagt, toetet ihn.
#     DASSELBE GILT FUER EINEN ZWEITEN LAUF (D3-7b, 2026-08-10): der
#     S3-Konformitaets-Lauf, ce profile_run_entry.hpp "if (a.pruef_only)
#     { exit = any_pruef_ok > 0 && any_pruef_failed == 0 }". Er baut NICHT und
#     misst NICHT -- er laedt jede fertige .so und faehrt nur ihr Gate. Die
#     emittierte Kampagnen-Pipeline faehrt ihn je Perm (ce planner/
#     experiment_plan_director.hpp, COMDARE_PRUEF_ONLY=true). Bis D3-7b trug
#     seine Bilanz-Zeile KEINEN Zusatz -- der Marker schrieb modus=voll, und die
#     Ausbeute-Wache haette ihn mit "0 Datenzeilen" rot gefaerbt. Der Modus muss
#     deshalb VOM TREIBER kommen (siehe naechster Absatz), nicht vom Aufrufer.
#   * zu stumpf -- die Mess-Jobs laufen auf einem PERSISTENTEN baremetal-
#     Workspace, und die dynamisch emittierte Kampagnen-Pipeline nimmt
#     Code/measure_out ausdruecklich vom Aufraeumen aus (ce
#     experiment_plan_director.hpp:1194-1203, GIT_CLEAN_FLAGS "-ffdx -e
#     Code/measure_out"). CSVs eines FRUEHEREN Laufs ueberleben also. Eine
#     Wache, die nur Zeilen zaehlt, nimmt sie als Ausbeute DIESES Laufs.
# Beides ist dieselbe Fehlerklasse: das Messgeraet ist richtig, der Gegenstand
# ist ein anderer. Der Marker macht den Gegenstand erst benennbar.
#
# WOHER DIE FELDER STAMMEN -- aus dem TREIBER, nicht aus dem Aufrufer:
# Der Treiber sagt selbst, was er getan hat. Ein Modus, den die CI danebenlegt,
# waere eine Behauptung ueber den Lauf; hier wird der Lauf ZITIERT. Es gibt
# DREI Abschluss-Zeilen, alle am Objekt nachgelesen (2026-08-09):
#
#   (1) ce profile_run_entry.hpp, run_profile()  -- der Thesis-Profil-Weg
#       RUN_PROFILE fertig: basis_rows=.. sota_rows=.. (basis_ids=.. sota_ids=..)
#         measured=<N> resumed=<M> provisioned=<K> [(provision-only)] [(pruef-only)]
#         csv_ok=<0|1> <PFEIL> <pfad>
#       DIE ZEILENNUMMERN SIND HIER ABSICHTLICH WEG. Sie standen bis D3-7b als
#       ":1219-1223" da und waren am 10.08. auf BEIDEN ce-Koepfen falsch (auf
#       development liegt die Zeile bei :1181, im w0a-Arbeitsbaum bei :1265) --
#       eine Fundstelle, die mit jedem Nachbar-Commit verjaehrt, ist keine
#       Quelle, sondern eine Behauptung mit Verfallsdatum. Gesucht wird ab jetzt
#       nach dem SYMBOL ("RUN_PROFILE fertig"), das ist stabil und greppbar.
#   (2) ce experiment_run_entry.hpp:522-524  -- der <comdare_experiment>-Weg
#       RUN_EXPERIMENT fertig: phasen=.. sota_rows=.. sota_ids=..
#         measured=<N> resumed=<M> csv_ok=<0|1> <PFEIL> <pfad>
#       KEIN provisioned=-Feld. Wer es voraussetzt, liest hier still 0.
#   (3) Code/02_messung_driver/main.cpp:1561 -- die klassischen Messreihen A/B/C
#       Messreihe <X> OK -> <pfad>/measurements.csv
#       KEINE measured=/resumed=-Felder. Diese Zeile ist eine ANWESENHEITS-
#       aussage, keine Frische-Aussage -- der Marker schreibt dafuer
#       measured=unbekannt und behauptet nichts, was er nicht weiss.
#
# DIE PFEIL-FALLE, am Objekt gemessen und der Grund fuer diesen Absatz:
#   Die Bau-Anweisung zu diesem Paket nannte den Trenner "->" (ASCII). Das ist
#   FALSCH. Die Zeilen (1) und (2) trennen mit U+2192 (Bytes 342 206 222),
#   Zeile (3) mit ASCII "->". Literal nachgemessen an einem nachgebauten
#   Treiber-Log mit EINER RUN_PROFILE-Zeile:
#     grep -cF -- '->' <log mit U+2192>  ->  0   (Nenner: 1 Bilanz-Zeile)
#     grep -cF -- '->' <log mit ASCII>   ->  1   (Gegenprobe: das Werkzeug lebt)
#   Ein Parser nach "->" haette also still nichts gefunden und keinen Marker
#   geschrieben -- rc=0, leere Ausgabe, kein Klappern. Deshalb kennt dieses
#   Skript BEIDE Trenner und prueft die Ausbeute gegen ihren eigenen Nenner.
#
# WARUM LC_ALL=C GESETZT WIRD (und nicht "geht schon"):
#   Der Pfad wird per index()/length() hinter dem Trenner abgeschnitten. In
#   einer UTF-8-Locale zaehlt gawk length("<U+2192>") als 1 ZEICHEN, in der
#   C-Locale als 3 BYTES. Ohne LC_ALL=C schnitte der Pfad je nach Runner-Locale
#   zwei Bytes zu frueh ab -- und zwar STILL, mit einem Pfad, der fast richtig
#   aussieht. Die Locale ist hier Teil der Zusicherung, nicht Umgebung.
#
# WAS DER MARKER NICHT IST: er ersetzt keine Wache. Er ist die GRUNDLAGE, auf
# der ci/mess_ausbeute_wache.sh (Modus) und ci/frische_wache.sh (Lauf-Kennung)
# ueberhaupt erst etwas entscheiden koennen.
#
# AUFRUF:
#   sh ci/lauf_marker.sh schreiben <stdout-log> <wurzel>
#   sh ci/lauf_marker.sh pruefen   <wurzel>
#
#   <stdout-log>  Mitschnitt des Treiber-STDOUT (die Bilanz-Zeilen stehen dort).
#   <wurzel>      Mess-Ausgabeverzeichnis (measure_out / measure_out_smoke).
#                 'schreiben' legt den prune_only-Marker dort ab und loest
#                 relative Pfade der Bilanz-Zeilen gegen das ARBEITSVERZEICHNIS
#                 auf -- so, wie der Treiber sie geschrieben hat.
#
# EXIT (schreiben): 0 = fuer JEDE Bilanz-Zeile wurde ein Marker platziert
#                   1 = mindestens eine Bilanz-Zeile blieb ohne Marker -- benannt,
#                       nie still. Zwei Gruende: der Pfad war nicht aufloesbar,
#                       ODER die Zeile trug BEIDE Modus-Zusaetze zugleich (dann
#                       ist der Modus nicht bekannt und wird nicht geraten).
#                   2 = keine Bilanz-Zeile und kein PRUNE-TESTAT im Log; es
#                       wurde NICHTS geschrieben. Die ABWESENHEIT der Datei ist
#                       das Signal fuer jeden Abnehmer.
# EXIT (pruefen):   0 = jede measurements.csv hat ihren Marker
#                   1 = mindestens eine ohne Marker (namentlich genannt) -- ROT
#                   2 = konnte nicht pruefen (Wurzel fehlt, 0 CSV gefunden)
#
# POSIX-sh, ASCII-only (der Trenner wird per printf aus Bytes gebaut, er darf in
# dieser Datei nicht stehen -- scripts/ci_diff_ascii_width_guard.sh), kein Python.
# Selbstcheck: dieses Skript behauptet nie, einen Marker geschrieben zu haben,
# ohne die Datei danach zu lesen (siehe marker_schreiben) -- eine Erfolgsmeldung
# ohne Gegenlesen waere genau die Klasse, gegen die es gebaut ist.
# =============================================================================

set -eu
LC_ALL=C
export LC_ALL

TRENN="-----------------------------------------------------------------------------"
MARKER_NAME="LAUF_MARKER.txt"

# U+2192 aus Bytes -- ein literales Zeichen waere ein ASCII-Verstoss.
PFEIL_UTF8=$(printf '\342\206\222')

nutzung() {
    echo "AUFRUF:" >&2
    echo "  sh ci/lauf_marker.sh schreiben <stdout-log> <wurzel>" >&2
    echo "  sh ci/lauf_marker.sh pruefen   <wurzel>" >&2
}

lauf_kennung() {
    echo "${CI_PIPELINE_ID:-NA}-${CI_JOB_ID:-NA}"
}

# --------------------------------------------------------------------------
# schreiben
# --------------------------------------------------------------------------
# Schreibt EINEN Marker. Liest ihn danach zurueck und meldet nur dann Erfolg.
marker_schreiben() {   # $1=zieldatei $2=quelle $3=modus $4=measured $5=resumed
                       # $6=provisioned $7=csv_ok $8=csv_pfad
    _ziel="$1"
    {
        echo "# Lauf-Marker (D3-7) -- aus der Abschluss-Zeile des Treibers, nicht vom Aufrufer"
        echo "quelle=$2"
        echo "modus=$3"
        echo "measured=$4"
        echo "resumed=$5"
        echo "provisioned=$6"
        echo "csv_ok=$7"
        echo "csv_pfad=$8"
        echo "lauf_kennung=$(lauf_kennung)"
        echo "ci_pipeline_id=${CI_PIPELINE_ID:-NA}"
        echo "ci_job_id=${CI_JOB_ID:-NA}"
        echo "geschrieben_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    } > "$_ziel" 2>/dev/null || return 1
    [ -s "$_ziel" ] || return 1
    grep -qF "modus=$3" "$_ziel" || return 1
    return 0
}

marker_schreiben_lauf() {
    LOG="${1:-}"
    WURZEL="${2:-}"

    if [ -z "$LOG" ] || [ -z "$WURZEL" ]; then nutzung; exit 2; fi
    if [ ! -f "$LOG" ]; then
        echo "ABBRUCH: '$LOG' ist keine Datei -- ohne Treiber-Log gibt es nichts zu zitieren." >&2
        echo "         Es wird KEIN Marker geschrieben; die Abwesenheit ist das Signal." >&2
        exit 2
    fi
    if [ ! -d "$WURZEL" ]; then
        echo "ABBRUCH: '$WURZEL' ist kein Verzeichnis -- kein Ort fuer einen Marker." >&2
        exit 2
    fi

    TMP=$(mktemp) || exit 2
    trap 'rm -f "$TMP"' EXIT INT TERM

    # EIN Datensatz je Bilanz-Zeile, TAB-getrennt:
    #   quelle modus measured resumed provisioned csv_ok pfad
    # awk statt sed-Kette: die Felder sind whitespace-getrennte key=value-Token,
    # ihre Reihenfolge ist nicht zugesichert, und ein fehlendes Feld darf die
    # uebrigen nicht verschieben.
    awk -v pfeil="$PFEIL_UTF8" '
        function pfad_nach(s, trenner,   p, out) {
            p = index(s, trenner)
            if (p == 0) return ""
            out = substr(s, p + length(trenner))
            sub(/^[ \t]+/, "", out)
            sub(/[ \t\r]+$/, "", out)
            return out
        }
        function felder(s,   i, n, teile, m, r, pv, ok, po, pr, res) {
            m = "unbekannt"; r = "unbekannt"; pv = "unbekannt"; ok = "unbekannt"; po = 0; pr = 0
            n = split(s, teile, /[ \t]+/)
            for (i = 1; i <= n; i++) {
                if (teile[i] ~ /^measured=[0-9]+$/)    { m  = substr(teile[i], 10) }
                if (teile[i] ~ /^resumed=[0-9]+$/)     { r  = substr(teile[i], 9)  }
                if (teile[i] ~ /^provisioned=[0-9]+$/) { pv = substr(teile[i], 13) }
                if (teile[i] ~ /^csv_ok=[0-9]+$/)      { ok = substr(teile[i], 8)  }
                if (teile[i] == "(provision-only)")    { po = 1 }
                if (teile[i] == "(pruef-only)")        { pr = 1 }
            }
            res = m "\t" r "\t" pv "\t" ok "\t" po "\t" pr
            return res
        }
        {
            quelle = ""
            trenner = ""
            if (index($0, "RUN_PROFILE fertig:")    > 0) { quelle = "RUN_PROFILE";    trenner = pfeil }
            if (index($0, "RUN_EXPERIMENT fertig:") > 0) { quelle = "RUN_EXPERIMENT"; trenner = pfeil }
            if (index($0, "Messreihe ") > 0 && index($0, " OK -> ") > 0) {
                quelle = "MESSREIHE"; trenner = " -> "
            }
            if (quelle == "") next
            pfad = pfad_nach($0, trenner)
            if (quelle == "MESSREIHE") {
                print quelle "\tunbekannt\tunbekannt\tunbekannt\tunbekannt\t0\t0\t" pfad
                next
            }
            split(felder($0), f, "\t")
            print quelle "\t" f[1] "\t" f[2] "\t" f[3] "\t" f[4] "\t" f[5] "\t" f[6] "\t" pfad
        }
    ' "$LOG" > "$TMP"

    N_ZEILEN=$(awk 'END{print NR+0}' "$TMP")

    echo "$TRENN"
    echo "LAUF-MARKER / schreiben   Log=$LOG   Wurzel=$WURZEL"
    echo "                          Lauf-Kennung=$(lauf_kennung)"
    echo "$TRENN"

    if [ "$N_ZEILEN" -eq 0 ]; then
        # prune_only ist der EINE Lauf, der planmaessig keine Bilanz-Zeile hat:
        # Code/02_messung_driver/main.cpp:940-970 kehrt VOR der E4-Fassade zurueck.
        # Er bekommt trotzdem einen Marker -- ein Lauf ohne Marker ist sonst von
        # einem abgestuerzten Lauf nicht zu unterscheiden.
        if grep -qF '[PRUNE-TESTAT]' "$LOG"; then
            _z="$WURZEL/$MARKER_NAME"
            if marker_schreiben "$_z" PRUNE_TESTAT prune_only 0 0 0 "n/a" "$WURZEL"; then
                echo "  MARKER  $_z  (modus=prune_only, Quelle [PRUNE-TESTAT])"
                echo "$TRENN"
                echo "NENNER (nie eine nackte Null):"
                echo "  0 Bilanz-Zeile(n) im Log, 1 PRUNE-TESTAT-Zeile -> 1 Marker geschrieben."
                echo "LAUF-MARKER: OK (1 Marker, modus=prune_only)."
                exit 0
            fi
            echo "FEHLER: der prune_only-Marker '$_z' liess sich nicht schreiben." >&2
            exit 1
        fi
        echo "  Keine Bilanz-Zeile und kein [PRUNE-TESTAT] im Log gefunden." >&2
        echo "NENNER: 0 von $(awk 'END{print NR+0}' "$LOG") Log-Zeilen sind eine Bilanz-Zeile." >&2
        echo "ABBRUCH: es wurde KEIN Marker geschrieben. Das ist kein leerer Lauf, sondern" >&2
        echo "         eine unpruefbare Lage -- die Abwesenheit der Datei IST das Signal." >&2
        exit 2
    fi

    N_PLATZIERT=0
    N_OFFEN=0
    OFFEN_LISTE=''
    while IFS="$(printf '\t')" read -r Q M R P OK PO PR PFAD; do
        [ -n "$Q" ] || continue
        MODUS=voll
        [ "$PO" = "1" ] && MODUS=provision_only
        # D3-7b: der DRITTE Modus. Der S3-Konformitaets-Lauf misst NICHT und baut
        # NICHT -- er laedt jede fertige .so und faehrt nur ihr Gate. 0 Datenzeilen
        # sind sein SOLL. Bis hierher lief er als modus=voll durch und starb an der
        # Ausbeute-Wache.
        [ "$PR" = "1" ] && MODUS=pruef_only
        # BEIDE Zusaetze in EINER Zeile kann der Treiber nicht schreiben (die zwei
        # Schalter sind gegenseitig ausschliessend). Steht es doch da, hat sich das
        # Zeilenformat bewegt -- dann wird hier NICHT geraten. Fail-closed und
        # benannt: die Zeile bleibt OFFEN, der Lauf endet rot statt mit einem
        # Marker, der einen Modus behauptet, den er nicht wissen kann.
        if [ "$PO" = "1" ] && [ "$PR" = "1" ]; then
            N_OFFEN=$((N_OFFEN + 1))
            OFFEN_LISTE="$OFFEN_LISTE
    $Q: '(provision-only)' UND '(pruef-only)' in derselben Bilanz-Zeile"
            echo "  OFFEN   $Q -- beide Modus-Zusaetze in EINER Zeile (Format geaendert?)"
            continue
        fi
        if [ -z "$PFAD" ]; then
            N_OFFEN=$((N_OFFEN + 1))
            OFFEN_LISTE="$OFFEN_LISTE
    $Q: kein Pfad hinter dem Trenner"
            echo "  OFFEN   $Q -- kein Pfad hinter dem Trenner (Zeilenformat geaendert?)"
            continue
        fi
        case "$PFAD" in
            *.csv) : ;;
            *)
                # Selbstpruefung des Parses: was hier steht, MUSS eine CSV sein.
                N_OFFEN=$((N_OFFEN + 1))
                OFFEN_LISTE="$OFFEN_LISTE
    $Q: '$PFAD' endet nicht auf .csv"
                echo "  OFFEN   $Q -- '$PFAD' endet nicht auf .csv (Parse verdaechtig)"
                continue
                ;;
        esac
        if [ ! -f "$PFAD" ]; then
            N_OFFEN=$((N_OFFEN + 1))
            OFFEN_LISTE="$OFFEN_LISTE
    $Q: '$PFAD' existiert nicht"
            echo "  OFFEN   $Q -- '$PFAD' existiert nicht (relativ zu $(pwd))"
            continue
        fi
        _dir=$(dirname "$PFAD")
        _z="$_dir/$MARKER_NAME"
        if marker_schreiben "$_z" "$Q" "$MODUS" "$M" "$R" "$P" "$OK" "$PFAD"; then
            N_PLATZIERT=$((N_PLATZIERT + 1))
            echo "  MARKER  $_z  (modus=$MODUS measured=$M resumed=$R csv_ok=$OK)"
        else
            N_OFFEN=$((N_OFFEN + 1))
            OFFEN_LISTE="$OFFEN_LISTE
    $Q: Marker '$_z' liess sich nicht schreiben/gegenlesen"
            echo "  OFFEN   $Q -- Marker '$_z' liess sich nicht schreiben"
        fi
    done < "$TMP"

    echo "$TRENN"
    echo "NENNER (nie eine nackte Null):"
    echo "  $N_ZEILEN Bilanz-Zeile(n) im Log gefunden."
    echo "  $N_PLATZIERT Marker platziert, $N_OFFEN ohne Marker geblieben."
    echo "$TRENN"

    if [ "$N_OFFEN" -gt 0 ]; then
        echo "FEHLER: $N_OFFEN von $N_ZEILEN Bilanz-Zeile(n) blieben ohne Marker:$OFFEN_LISTE" >&2
        echo "        Ein halb gesetzter Marker ist schlimmer als keiner -- die Abnehmer" >&2
        echo "        wuerden die ungedeckten CSVs still fuer frisch halten." >&2
        exit 1
    fi
    echo "LAUF-MARKER: OK ($N_PLATZIERT Marker aus $N_ZEILEN Bilanz-Zeile(n))."
    exit 0
}

# --------------------------------------------------------------------------
# pruefen -- FEHLENDER MARKER = ROT
# --------------------------------------------------------------------------
marker_pruefen() {
    WURZEL="${1:-}"
    if [ -z "$WURZEL" ]; then nutzung; exit 2; fi
    if [ ! -d "$WURZEL" ]; then
        echo "ABBRUCH: '$WURZEL' ist kein Verzeichnis -- die Marker-Wache konnte nicht pruefen." >&2
        echo "         Kein Gruen ohne Pruefung." >&2
        exit 2
    fi

    TMP=$(mktemp) || exit 2
    trap 'rm -f "$TMP"' EXIT INT TERM
    find "$WURZEL" -type f -name 'measurements.csv' > "$TMP" 2>/dev/null || true
    N_CSV=$(awk 'END{print NR+0}' "$TMP")

    echo "$TRENN"
    echo "LAUF-MARKER / pruefen   Wurzel=$WURZEL"
    echo "$TRENN"

    if [ "$N_CSV" -eq 0 ]; then
        echo "  KEINE measurements.csv unter '$WURZEL'." >&2
        echo "ABBRUCH: 0 CSV -- ueber eine leere Menge ist die Marker-Deckung nicht" >&2
        echo "         aussagbar. Ob der Lauf ueberhaupt etwas erzeugt hat, entscheidet" >&2
        echo "         ci/mess_ausbeute_wache.sh; hier waere jede Antwort geraten." >&2
        echo "         Kein Gruen ohne Pruefung." >&2
        exit 2
    fi

    N_MIT=0
    N_OHNE=0
    OHNE_LISTE=''
    while IFS= read -r F; do
        [ -n "$F" ] || continue
        _m="$(dirname "$F")/$MARKER_NAME"
        if [ -f "$_m" ]; then
            N_MIT=$((N_MIT + 1))
            _mod=$(awk -F= '/^modus=/{print $2; exit}' "$_m" 2>/dev/null || true)
            _k=$(awk -F= '/^lauf_kennung=/{print $2; exit}' "$_m" 2>/dev/null || true)
            echo "  MARKER  $F  (modus=${_mod:-?} lauf_kennung=${_k:-?})"
        else
            N_OHNE=$((N_OHNE + 1))
            OHNE_LISTE="$OHNE_LISTE
    $F"
            echo "  FEHLT   $F  -- kein $MARKER_NAME daneben"
        fi
    done < "$TMP"

    echo "$TRENN"
    echo "NENNER (nie eine nackte Null):"
    echo "  $N_CSV measurements.csv gefunden."
    echo "  $N_MIT von $N_CSV mit Lauf-Marker, $N_OHNE ohne."
    echo "$TRENN"

    if [ "$N_OHNE" -gt 0 ]; then
        echo "FEHLER: $N_OHNE von $N_CSV measurements.csv haben KEINEN Lauf-Marker:$OHNE_LISTE" >&2
        echo "        Ohne Marker ist nicht entscheidbar, aus welchem Lauf und aus welchem" >&2
        echo "        Modus diese Datei stammt. Fehlender Marker ist ROT, nicht 'egal'." >&2
        exit 1
    fi
    echo "LAUF-MARKER / pruefen: OK ($N_MIT von $N_CSV CSV gedeckt)."
    exit 0
}

UNTER="${1:-}"
[ "$#" -gt 0 ] && shift

case "$UNTER" in
    schreiben) marker_schreiben_lauf "$@" ;;
    pruefen)   marker_pruefen "$@" ;;
    ''|-h|--help) nutzung; exit 2 ;;
    *)
        echo "ABBRUCH: unbekanntes Unterkommando '$UNTER'." >&2
        nutzung
        exit 2
        ;;
esac
