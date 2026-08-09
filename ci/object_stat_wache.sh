#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  OBJECT-STAT-WACHE -- ein eingelagertes Objekt gilt erst als eingelagert,
#  wenn der STORE seine GROESSE meldet und diese mit der Erwartung
#  uebereinstimmt.                                                  (2026-08-09)
# =============================================================================
#
# SELBSTCHECK -- was diese Datei zusichert, und was NICHT:
#   ZUSICHERT: dass der Objekt-Store zu einem Schluessel eine Groesse meldet und
#     dass diese Groesse EXAKT der erwarteten entspricht (Zahlenvergleich, nicht
#     Anwesenheit). Optional zusaetzlich, dass das etag dem erwarteten gleicht.
#     Ausserdem: dass ein NICHT erreichbarer Store als INFRASTRUKTUR gemeldet
#     wird und ein fehlendes Objekt als FACHLICHER Defekt -- beide rot, aber
#     unterscheidbar.
#   ZUSICHERT NICHT: dass der INHALT des Objekts korrekt ist. Groesse und etag
#     sind Zusicherungen ueber Umfang und Identitaet, nicht ueber Semantik. Wer
#     den Inhalt pruefen will, muss ihn holen und gegen ein Orakel stellen --
#     das ist eine andere Wache.
#
# DIE LUECKE, GEGEN DIE SIE GEBAUT IST:
# ci/bestandslog_wache.sh belegt, dass das Gate GEZUENDET hat -- sie sagt in
# ihrem eigenen Kopf (Zeile 15-18), dass sie NICHT belegt, ob das Dokument im
# Store entstanden ist, und verweist ausdruecklich auf "ein object_stat".
# .gitlab-ci.yml:1078-1082 sagt dasselbe. Diese Datei schliesst genau diese
# Luecke. Der Unterschied ist der zwischen GEGENSTAND und STELLVERTRETER: dass
# ein Schreibaufruf keinen Fehler meldete, ist eine Aussage ueber den AUFRUF.
# Dass der Store die erwartete Groesse zurueckgibt, ist eine Aussage ueber den
# STORE. Nur die zweite ist die gesuchte.
#
# DER GEMESSENE BEFUND, DER DIE BAUART BESTIMMT HAT (09.08.2026, mc RELEASE.
# 2025-08-13, literal nachgemessen -- NICHT aus einer Doku abgeschrieben):
#   Fehlendes Objekt          -> rc=1, EINE Zeile:
#     {"status":"error","error":{"message":"Unable to stat `...`.",
#      "cause":{"message":"Object does not exist","error":{}},"type":"fatal"}}
#   Store tot (conn refused)  -> rc=1, ZWEI Zeilen. Die ZWEITE ist mit der
#     obigen bedeutungsgleich ("Object does not exist", type fatal); der
#     Unterschied steckt AUSSCHLIESSLICH in der ERSTEN Zeile
#     ("dial tcp ...: connect: connection refused").
#
# DARAUS FOLGEN ZWEI ENTWURFS-ENTSCHEIDUNGEN, DIE NICHT VERHANDELBAR SIND:
#   (1) rc VON mc IST KEIN KRITERIUM. Er ist in beiden Faellen 1 und traegt die
#       Unterscheidung nicht. Wer ihn als Kriterium nimmt, hat ein Messgeraet am
#       falschen Gegenstand.
#   (2) ES WERDEN ALLE AUSGABE-ZEILEN GELESEN, NIE NUR DIE LETZTE. Ein
#       tail -1 wuerde einen INFRASTRUKTUR-AUSFALL als "Objekt fehlt" melden --
#       also die laute Ursache durch die leise ersetzen. Die Netz-Signatur der
#       ERSTEN Zeile schlaegt die Fehlt-Signatur der letzten (Reihenfolge in
#       der Klassifikation unten).
#
# FAIL-CLOSED: es gibt in dieser Datei KEINEN Pfad, der 0 zurueckgibt, ohne dass
# eine Groesse gelesen UND verglichen wurde. Fehlende Konfiguration, fehlendes
# mc, Zeitueberschreitung und unklassifizierte Fehler enden ALLE rot. Das
# Opt-in-Gate ("laeuft diese Wache ueberhaupt?") gehoert in den CI-Block, nicht
# hierher -- eine Wache, die sich selbst fuer nicht zustaendig erklaeren kann,
# ist die naechste stille Null.
#
# ZUGANGSDATEN: diese Datei liest MC_HOST_<alias> NIE und gibt es NIE aus. mc
# zieht die Anmeldedaten selbst aus der Umgebung (nie argv, nie Log). Zusaetzlich
# werden alle mc-Meldungen vor der Ausgabe redigiert: jedes "://...@" wird
# ersetzt, damit eine eingebettete Credential-URL auch dann nicht im Job-Log
# landet, wenn mc sie je in eine Fehlermeldung schreiben sollte.
#
# AUFRUF:
#   sh ci/object_stat_wache.sh <objekt-key> --groesse <bytes> [OPTIONEN]
#   sh ci/object_stat_wache.sh <objekt-key> --lokal <datei>   [OPTIONEN]
# OPTIONEN:
#   --etag <wert>     zusaetzlich das etag vergleichen (optional)
#   --timeout <sek>   Zeitschranke fuer den mc-Aufruf (Vorgabe 30)
#
# WOHER DIE ERWARTUNG KOMMT (T-3: Nenner aus FREMDER Quelle):
#   --lokal <datei> nimmt die Groesse aus "wc -c" der lokalen Datei, die
#   hochgeladen wurde. Das ist eine ANDERE Quelle als mc: das Dateisystem gegen
#   den Store. Wuerde die Erwartung aus derselben mc-Antwort stammen, vergliche
#   die Wache die Antwort mit sich selbst und waere immer gruen.
#
# UMGEBUNG (gesetzt von .storage_cache_activation in .gitlab-ci.yml):
#   COMDARE_MINIO_ENDPOINT  mc-ALIAS-Name (nicht die URL -- die Aktivierung
#                           setzt die Variable nach dem MC_HOST-Bau auf 'prodcache' um)
#   COMDARE_MINIO_BUCKET    Bucket
#   COMDARE_MINIO_PREFIX    optionaler Schluessel-Praefix
#   COMDARE_MC_BIN          optionaler Pfad zu mc (Vorgabe: mc aus PATH)
#   MC_HOST_<alias>         Anmeldedaten -- von dieser Datei NIE gelesen
#
# EXIT: 0 = Objekt vorhanden UND Groesse (und ggf. etag) stimmen
#       1 = FACHLICH: Objekt fehlt, oder die Groesse weicht ab
#       2 = die Wache konnte nicht pruefen (Aufruf-/Argumentfehler)
#       3 = INFRASTRUKTUR: Store nicht erreichbar, nicht konfiguriert, mc fehlt,
#           Zeitueberschreitung, Anmeldung/Bucket abgelehnt
#       Alle Werte ausser 0 sind ROT. Der Unterschied liegt in Code UND Meldung.
#
# POSIX-sh, ASCII-only, kein Python (Hausdoktrin: kein Python in der Buildchain).
# Kein grep -P und kein jq: das /usr/bin/grep dieses Hauses kann ugrep sein
# (STILLE 0), und jq ist im Runner-Image nicht zugesichert. awk ist es.
# =============================================================================

set -eu

OBJEKT_KEY="${1:-}"
[ "$#" -gt 0 ] && shift

ERW_GROESSE=""
ERW_QUELLE=""
LOKAL_DATEI=""
ERW_ETAG=""
ZEITSCHRANKE="30"

while [ "$#" -gt 0 ]; do
    case "$1" in
        --groesse)
            [ "$#" -ge 2 ] || { echo "AUFRUF: --groesse braucht einen Wert" >&2; exit 2; }
            ERW_GROESSE="$2"; ERW_QUELLE="Aufrufer-Argument --groesse"; shift 2 ;;
        --lokal)
            [ "$#" -ge 2 ] || { echo "AUFRUF: --lokal braucht einen Pfad" >&2; exit 2; }
            LOKAL_DATEI="$2"; shift 2 ;;
        --etag)
            [ "$#" -ge 2 ] || { echo "AUFRUF: --etag braucht einen Wert" >&2; exit 2; }
            ERW_ETAG="$2"; shift 2 ;;
        --timeout)
            [ "$#" -ge 2 ] || { echo "AUFRUF: --timeout braucht einen Wert" >&2; exit 2; }
            ZEITSCHRANKE="$2"; shift 2 ;;
        *)
            echo "AUFRUF: unbekannte Option '$1'" >&2; exit 2 ;;
    esac
done

hilfe() {
    echo "AUFRUF: sh ci/object_stat_wache.sh <objekt-key> --groesse <bytes> [--etag <w>] [--timeout <s>]" >&2
    echo "        sh ci/object_stat_wache.sh <objekt-key> --lokal <datei>   [--etag <w>] [--timeout <s>]" >&2
    echo "        Ohne erwartete Groesse gibt es nichts zu vergleichen -- und" >&2
    echo "        blosse Anwesenheit ist keine Zusicherung (T-2)." >&2
}

if [ -z "$OBJEKT_KEY" ]; then
    echo "ABBRUCH: kein Objekt-Schluessel angegeben." >&2
    hilfe
    exit 2
fi

# --- die Erwartung bilden. Genau EINE Quelle, und sie wird benannt. ----------
if [ -n "$LOKAL_DATEI" ]; then
    if [ -n "$ERW_GROESSE" ]; then
        echo "ABBRUCH: --groesse und --lokal schliessen sich aus -- zwei Erwartungen" >&2
        echo "         sind keine Erwartung. Genau eine Quelle angeben." >&2
        exit 2
    fi
    if [ ! -f "$LOKAL_DATEI" ]; then
        echo "ABBRUCH: '$LOKAL_DATEI' ist keine Datei -- die Erwartung ist nicht bildbar." >&2
        echo "         Kein Gruen ohne Vergleich." >&2
        exit 2
    fi
    ERW_GROESSE=$(wc -c < "$LOKAL_DATEI" | tr -d ' ')
    ERW_QUELLE="wc -c von $LOKAL_DATEI (Dateisystem, fremde Quelle gegenueber mc)"
fi

if [ -z "$ERW_GROESSE" ]; then
    echo "ABBRUCH: keine erwartete Groesse (weder --groesse noch --lokal)." >&2
    hilfe
    exit 2
fi

case "$ERW_GROESSE" in
    ''|*[!0-9]*)
        echo "ABBRUCH: erwartete Groesse '$ERW_GROESSE' ist keine Zahl." >&2
        exit 2 ;;
esac
case "$ZEITSCHRANKE" in
    ''|*[!0-9]*)
        echo "ABBRUCH: --timeout '$ZEITSCHRANKE' ist keine Zahl." >&2
        exit 2 ;;
esac

# --- ab hier ist jeder Fehlschlag ROT, nie ein stiller Rueckfall. -----------
ALIAS="${COMDARE_MINIO_ENDPOINT:-}"
BUCKET="${COMDARE_MINIO_BUCKET:-}"
PREFIX="${COMDARE_MINIO_PREFIX:-}"
MC="${COMDARE_MC_BIN:-mc}"

echo "-----------------------------------------------------------------------------"
echo "OBJECT-STAT-WACHE"
echo "  Objekt-Key      = $OBJEKT_KEY"
echo "  erwartete Groesse = $ERW_GROESSE Byte"
echo "  Quelle der Erwartung = $ERW_QUELLE"
if [ -n "$ERW_ETAG" ]; then
    echo "  erwartetes etag = $ERW_ETAG"
else
    echo "  erwartetes etag = (nicht gefordert)"
fi
echo "  Alias/Bucket    = ${ALIAS:-<unbelegt>}/${BUCKET:-<unbelegt>}"
echo "-----------------------------------------------------------------------------"

if [ -z "$ALIAS" ] || [ -z "$BUCKET" ]; then
    echo "FEHLER [INFRASTRUKTUR]: der Objekt-Store ist nicht konfiguriert." >&2
    echo "  COMDARE_MINIO_ENDPOINT=${ALIAS:-<unbelegt>} COMDARE_MINIO_BUCKET=${BUCKET:-<unbelegt>}" >&2
    echo "  Diese Wache wurde gerufen, kann aber nichts messen. Das ist ROT und nicht" >&2
    echo "  gruen: eine Wache, die bei fehlendem Messgegenstand gruen meldet, ist genau" >&2
    echo "  der Defekt, gegen den sie gebaut ist. Gehoert das Opt-in nicht gesetzt, darf" >&2
    echo "  der CI-Block sie gar nicht erst rufen." >&2
    exit 3
fi

if ! command -v "$MC" >/dev/null 2>&1; then
    echo "FEHLER [INFRASTRUKTUR]: mc-Binary '$MC' nicht gefunden." >&2
    echo "  Ohne mc ist der Store nicht befragbar -- kein Messgegenstand, also rot." >&2
    exit 3
fi

# Zielpfad: <alias>/<bucket>[/<prefix>]/<key>. Doppelte Schraegstriche vermeiden.
ZIEL="$ALIAS/$BUCKET"
if [ -n "$PREFIX" ]; then
    PREFIX_BEREINIGT=$(printf '%s' "$PREFIX" | sed 's#^/*##; s#/*$##')
    [ -n "$PREFIX_BEREINIGT" ] && ZIEL="$ZIEL/$PREFIX_BEREINIGT"
fi
KEY_BEREINIGT=$(printf '%s' "$OBJEKT_KEY" | sed 's#^/*##')
ZIEL="$ZIEL/$KEY_BEREINIGT"

ROH=$(mktemp) || exit 2
BEFUND=$(mktemp) || { rm -f "$ROH"; exit 2; }
trap 'rm -f "$ROH" "$BEFUND"' EXIT INT TERM

# rc OHNE Pipe gemessen (K11: rc=$? nach einer Pipe misst das letzte Glied).
# timeout, weil ein haengendes mc sonst den Job blockiert statt ihn rot zu machen.
if timeout "$ZEITSCHRANKE" "$MC" stat --json "$ZIEL" > "$ROH" 2>&1; then
    MC_RC=0
else
    MC_RC=$?
fi

if [ "$MC_RC" -eq 124 ]; then
    echo "FEHLER [INFRASTRUKTUR]: mc hat die Zeitschranke von ${ZEITSCHRANKE}s gerissen." >&2
    echo "  Der Store antwortet nicht. Rot als Infrastruktur, nicht als fehlendes Objekt." >&2
    exit 3
fi

# --- Klassifikation in EINEM awk-Lauf. -------------------------------------
# Die Reihenfolge der Zweige ist der Kern dieser Wache: die NETZ-Signatur der
# ersten Zeile schlaegt die FEHLT-Signatur der letzten. Genau umgekehrt waere
# der Stellvertreter (siehe gemessener Befund im Kopf).
awk '
function hat(s, n) { return index(s, n) > 0 }
function redigiere(s) { gsub(/:\/\/[^ "@]*@/, "://***REDIGIERT***@", s); return s }
# Nur die OBERSTE Ebene des JSON behalten -- ein "size" in "metadata" darf die
# Groesse des Objekts nicht ueberschreiben.
function nur_oberste(s,   i, c, tiefe, instr, esc, aus, n) {
    n = length(s); tiefe = 0; instr = 0; esc = 0; aus = ""
    for (i = 1; i <= n; i++) {
        c = substr(s, i, 1)
        if (instr) {
            if (esc) esc = 0
            else if (c == "\\") esc = 1
            else if (c == "\"") instr = 0
            if (tiefe <= 1) aus = aus c
            continue
        }
        if (c == "\"") { instr = 1; if (tiefe <= 1) aus = aus c; continue }
        if (c == "{" || c == "[") { tiefe++; if (tiefe <= 1) aus = aus c; continue }
        if (c == "}" || c == "]") { if (tiefe <= 1) aus = aus c; tiefe--; continue }
        if (tiefe <= 1) aus = aus c
    }
    return aus
}
function zahl_feld(s, k,   p, rest, i, c, aus) {
    p = index(s, "\"" k "\":")
    if (p == 0) return ""
    rest = substr(s, p + length(k) + 3)
    aus = ""
    for (i = 1; i <= length(rest); i++) {
        c = substr(rest, i, 1)
        if (c >= "0" && c <= "9") { aus = aus c; continue }
        if (aus == "" && c == " ") continue
        break
    }
    return aus
}
function text_feld(s, k,   p, rest, i, c, aus, esc) {
    p = index(s, "\"" k "\":\"")
    if (p == 0) return ""
    rest = substr(s, p + length(k) + 4)
    aus = ""; esc = 0
    for (i = 1; i <= length(rest); i++) {
        c = substr(rest, i, 1)
        if (esc) { aus = aus c; esc = 0; continue }
        if (c == "\\") { esc = 1; continue }
        if (c == "\"") break
        aus = aus c
    }
    return aus
}
BEGIN { n_zeilen = 0; n_success = 0; n_error = 0; groesse = ""; etag = ""; alles = "" }
{
    if ($0 ~ /^[ \t]*$/) next
    n_zeilen++
    alles = alles " " $0
    oben = nur_oberste($0)
    st = text_feld(oben, "status")
    if (st == "success") {
        n_success++
        if (groesse == "") { groesse = zahl_feld(oben, "size"); etag = text_feld(oben, "etag") }
    } else if (st == "error") {
        n_error++
        if (erste_fehlerzeile == "") erste_fehlerzeile = redigiere($0)
    } else {
        n_fremd++
        if (erste_fehlerzeile == "") erste_fehlerzeile = redigiere($0)
    }
}
END {
    # Klassifikation. Reihenfolge ist bindend.
    netz = 0; auth = 0; fehlt = 0
    if (hat(alles, "connection refused") || hat(alles, "dial tcp") ||
        hat(alles, "no such host")       || hat(alles, "i/o timeout") ||
        hat(alles, "context deadline exceeded") || hat(alles, "TLS handshake") ||
        hat(alles, "x509")               || hat(alles, "network is unreachable") ||
        hat(alles, "connection reset")   || hat(alles, "unexpected EOF") ||
        hat(alles, "server misbehaving") || hat(alles, "RequestTimeout")) netz = 1
    if (hat(alles, "AccessDenied")       || hat(alles, "Access Denied") ||
        hat(alles, "InvalidAccessKeyId") || hat(alles, "SignatureDoesNotMatch") ||
        hat(alles, "NoSuchBucket")       || hat(alles, "InvalidBucketName") ||
        hat(alles, "Unauthorized")) auth = 1
    if (hat(alles, "Object does not exist") || hat(alles, "NoSuchKey") ||
        hat(alles, "The specified key does not exist")) fehlt = 1

    if (n_success > 0 && groesse != "") klasse = "TREFFER"
    else if (netz)  klasse = "NETZ"
    else if (auth)  klasse = "AUTH"
    else if (fehlt) klasse = "FEHLT"
    else            klasse = "UNKLAR"

    printf "N_ZEILEN=%d\n",   n_zeilen
    printf "N_SUCCESS=%d\n",  n_success
    printf "N_ERROR=%d\n",    n_error + n_fremd
    printf "KLASSE=%s\n",     klasse
    printf "GROESSE=%s\n",    groesse
    printf "ETAG=%s\n",       etag
    printf "ERSTFEHLER=%s\n", erste_fehlerzeile
}
' "$ROH" > "$BEFUND"
AWK_RC=$?
if [ "$AWK_RC" -ne 0 ]; then
    echo "ABBRUCH: awk endete mit rc=$AWK_RC -- die Wache konnte nicht auswerten." >&2
    exit 2
fi

hole() { awk -v k="$1" 'index($0, k "=") == 1 { print substr($0, length(k) + 2); exit }' "$BEFUND"; }

N_ZEILEN=$(hole N_ZEILEN)
N_SUCCESS=$(hole N_SUCCESS)
N_ERROR=$(hole N_ERROR)
KLASSE=$(hole KLASSE)
IST_GROESSE=$(hole GROESSE)
IST_ETAG=$(hole ETAG)
ERSTFEHLER=$(hole ERSTFEHLER)

# Anzahl der tatsaechlich gestellten Zusicherungen -- der Nenner des Vergleichs.
N_ZUSICHERUNG=1
[ -n "$ERW_ETAG" ] && N_ZUSICHERUNG=2

echo "NENNER (nie eine nackte Zahl):"
echo "  $N_ZEILEN mc-JSON-Satz/Saetze gelesen (Grundgesamtheit der Auswertung)."
echo "  $N_SUCCESS davon status=success, $N_ERROR davon status=error/unbekannt."
echo "  mc-Exit=$MC_RC (bewusst KEIN Kriterium: er ist bei fehlendem Objekt und"
echo "    bei totem Store gleichermassen 1 -- gemessen, siehe Kopf dieser Datei)."
echo "  $N_ZUSICHERUNG Zusicherung(en) gestellt ueber 1 Objekt."
echo "  Klassifikation = $KLASSE"
echo "-----------------------------------------------------------------------------"

case "$KLASSE" in
    NETZ)
        echo "FEHLER [INFRASTRUKTUR]: der Objekt-Store ist NICHT ERREICHBAR." >&2
        echo "  Das ist KEIN fehlendes Objekt -- ueber das Objekt ist damit gar nichts" >&2
        echo "  ausgesagt. mc meldet zwar zusaetzlich 'Object does not exist'; diese" >&2
        echo "  Meldung ist die FOLGE des Verbindungsfehlers, nicht sein Inhalt." >&2
        echo "  ERSTE mc-Meldung (literal, Credentials redigiert):" >&2
        printf '    %s\n' "$ERSTFEHLER" >&2
        exit 3 ;;
    AUTH)
        echo "FEHLER [INFRASTRUKTUR]: der Store lehnt Anmeldung oder Bucket ab." >&2
        echo "  Der Store antwortet, akzeptiert aber Schluessel/Bucket nicht. Auch hier" >&2
        echo "  ist ueber die Existenz des Objekts nichts ausgesagt." >&2
        echo "  ERSTE mc-Meldung (literal, Credentials redigiert):" >&2
        printf '    %s\n' "$ERSTFEHLER" >&2
        exit 3 ;;
    UNKLAR)
        echo "FEHLER [INFRASTRUKTUR]: mc-Antwort nicht klassifizierbar." >&2
        echo "  Bewusst als Infrastruktur gewertet und nicht als 'Objekt fehlt': die" >&2
        echo "  optimistische Lesart waere genau der stille Rueckfall, den diese Wache" >&2
        echo "  verhindern soll. Ein unbekannter Fehler ist ein Fehler." >&2
        echo "  ERSTE mc-Meldung (literal, Credentials redigiert):" >&2
        printf '    %s\n' "$ERSTFEHLER" >&2
        exit 3 ;;
    FEHLT)
        echo "FEHLER [FACHLICH]: der Store ist erreichbar, das Objekt existiert NICHT." >&2
        echo "  Ziel  = <alias>/<bucket>/$KEY_BEREINIGT" >&2
        echo "  Es gab also keinen Verbindungs- und keinen Anmeldefehler -- der" >&2
        echo "  Schreibweg hat das Objekt nicht abgelegt, obwohl der Lauf weiterlief." >&2
        echo "  Genau dieser Fall ist der Grund fuer diese Wache: ein Schreibaufruf" >&2
        echo "  ohne Fehlermeldung ist kein eingelagertes Objekt." >&2
        echo "  ERSTE mc-Meldung (literal, Credentials redigiert):" >&2
        printf '    %s\n' "$ERSTFEHLER" >&2
        exit 1 ;;
esac

# --- ab hier: das Objekt ist da. Jetzt die eigentliche Zusicherung. ---------
ABWEICHUNG=0

if [ "$IST_GROESSE" != "$ERW_GROESSE" ]; then
    ABWEICHUNG=$((ABWEICHUNG + 1))
    echo "FEHLER [FACHLICH]: die Groesse im Store weicht ab." >&2
    echo "    gelesen  = $IST_GROESSE Byte (aus mc stat --json)" >&2
    echo "    erwartet = $ERW_GROESSE Byte ($ERW_QUELLE)" >&2
    echo "    Differenz= $((IST_GROESSE - ERW_GROESSE)) Byte" >&2
fi

if [ -n "$ERW_ETAG" ] && [ "$IST_ETAG" != "$ERW_ETAG" ]; then
    ABWEICHUNG=$((ABWEICHUNG + 1))
    echo "FEHLER [FACHLICH]: das etag im Store weicht ab." >&2
    echo "    gelesen  = ${IST_ETAG:-<leer>}" >&2
    echo "    erwartet = $ERW_ETAG" >&2
fi

if [ "$ABWEICHUNG" -gt 0 ]; then
    echo "  $ABWEICHUNG von $N_ZUSICHERUNG Zusicherung(en) gerissen." >&2
    echo "  Das Objekt ist zwar da, aber nicht das erwartete. Anwesenheit ist keine" >&2
    echo "  Zusicherung -- deshalb prueft diese Wache Werte und nicht Existenz." >&2
    exit 1
fi

echo "BELEG (literal aus dem Store):"
echo "  Groesse = $IST_GROESSE Byte, verglichen gegen $ERW_GROESSE Byte aus:"
echo "            $ERW_QUELLE"
if [ -n "$ERW_ETAG" ]; then
    echo "  etag    = $IST_ETAG (stimmt mit der Erwartung ueberein)"
fi
echo "  $N_ZUSICHERUNG von $N_ZUSICHERUNG Zusicherung(en) gehalten, ueber 1 Objekt in $N_ZEILEN mc-Satz/Saetzen."
echo "OBJECT-STAT-WACHE: OK (Objekt im Store, Groesse stimmt)."
exit 0
