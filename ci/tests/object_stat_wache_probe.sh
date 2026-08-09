#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  PROBE fuer die OBJECT-STAT-WACHE (ci/object_stat_wache.sh)       (2026-08-09)
# =============================================================================
#
# SELBSTCHECK -- was diese Datei zusichert, und was NICHT:
#   ZUSICHERT: dass die Wache in den unten aufgefuehrten Faellen genau das
#     Verdikt faellt, das sie faellen muss -- insbesondere (a) dass sie die
#     ZUFAELLIG gewuerfelte Groesse eines echten Objekts exakt meldet, (b) dass
#     sie einen TOTEN STORE als INFRASTRUKTUR meldet und nicht als fehlendes
#     Objekt, obwohl mc in beiden Faellen rc=1 und eine bedeutungsgleiche
#     LETZTE Zeile liefert, und (c) dass sie bei fehlender Konfiguration ROT
#     wird statt gruen. Zusaetzlich (--selbstbiss), dass sechs Wegwerf-Mutanten
#     ihrer selbst NICHT mehr gruen bleiben.
#   ZUSICHERT NICHT: dass ein echter MinIO-Round-Trip funktioniert. Die Faelle
#     mit echtem mc laufen gegen das DATEISYSTEM (mc kann lokale Pfade statten),
#     die Store-Fehlerfaelle gegen ein Fake-mc. Beides prueft die Wache, nicht
#     MinIO. Der Round-Trip gegen echtes MinIO ist von dieser Maschine aus nicht
#     baubar (keine MinIO-Zugangsdaten vorhanden, 09.08. gemessen) und bleibt
#     ausdruecklich offen -- er ist NICHT stillschweigend mitbehauptet.
#
# WARUM DIE ECHT-mc-FAELLE WICHTIG SIND (Gegenstand statt Stellvertreter):
# Ein Fake-mc beweist nur, dass die Wache das JSON liest, das die Probe selbst
# geschrieben hat -- Orakel und Prueflung waeren dieselbe Quelle (T-5 verletzt).
# Deshalb laufen die Erfolgs-Faelle zusaetzlich gegen die ECHTE mc-Binary: das
# JSON-Format stammt dann von mc, nicht von mir, und die Groesse kommt aus
# "wc -c" des Dateisystems -- also aus einer dritten Quelle.
#
# WARUM DIE FAKE-mc-FAELLE WICHTIG SIND:
# "Store tot", "Anmeldung abgelehnt" und "Objekt fehlt am erreichbaren Store"
# lassen sich mit einem lokalen Pfad nicht herstellen. Die JSON-Formen des
# Fake-mc sind am 09.08. LITERAL von der echten mc-Binary abgenommen worden
# (mc RELEASE.2025-08-13), nicht erfunden und nicht aus einer Doku abgeschrieben.
#
# K13 -- DER KOEDER MUSS ERST BEISSEN:
# Jede Groesse, jedes etag und jedes Schein-Geheimnis wird bei JEDEM Lauf frisch
# gewuerfelt (/dev/urandom). Kein Wert stammt aus einer Doku, aus einem alten
# Lauf oder aus der Paketbeschreibung. Zu jedem Rot-Fall gehoert die Gegenprobe
# mit demselben Wurf: korrekt eingesetzt -> wieder gruen. Ein Koeder, der IMMER
# beisst, ist so wertlos wie einer, der nie beisst.
#
# AUFRUF:  sh ci/tests/object_stat_wache_probe.sh [--selbstbiss]
# EXIT:    0 = alle Faelle wie erwartet | 1 = mindestens ein Fall falsch
#
# POSIX-sh, ASCII-only, kein Python.
# =============================================================================

set -eu

WACHE="${WACHE_UNTER_TEST:-ci/object_stat_wache.sh}"
SELBSTBISS=0
[ "${1:-}" = "--selbstbiss" ] && SELBSTBISS=1

test -f "$WACHE" || { echo "ABBRUCH: $WACHE nicht gefunden (cwd=$(pwd))" >&2; exit 1; }
WACHE_ABS=$(cd "$(dirname "$WACHE")" && pwd)/$(basename "$WACHE")

command -v mc >/dev/null 2>&1 \
    || { echo "ABBRUCH: mc-Binary fehlt -- die Echt-mc-Faelle waeren nicht pruefbar." >&2; exit 1; }

ARBEIT=$(mktemp -d) || exit 1
trap 'rm -rf "$ARBEIT"' EXIT INT TERM

FEHLER=0
N_FALL=0

wurf_zahl() {
    # Groesse zwischen 1 und 65535 Byte, frisch aus /dev/urandom.
    _w=$(od -An -N2 -tu2 < /dev/urandom | tr -d ' \n')
    _w=$((_w % 65535 + 1))
    printf '%s' "$_w"
}
wurf_wort() { head -c9 /dev/urandom | base32 | tr 'A-Z' 'a-z' | tr -d '='; }

# ---------------------------------------------------------------------------
#  Das Fake-mc. Die JSON-Formen sind am 09.08. literal von der echten mc-Binary
#  abgenommen (siehe Kopf). PROBE_MC_MODUS steuert die Antwort.
# ---------------------------------------------------------------------------
FAKE_MC="$ARBEIT/fake-mc"
cat > "$FAKE_MC" <<'FAKEEOF'
#!/bin/sh
# Fake-mc fuer die Probe. Kennt nur "stat --json <ziel>".
set -eu
case "${PROBE_MC_MODUS:-}" in
  ok)
    # Umbruch nur im QUELLTEXT (120-Spalten-Wache); die ausgegebenen Bytes sind
    # unveraendert die am 09.08. literal abgenommene JSON-Form.
    printf '{"status":"success","name":"x.bin","lastModified":"2026-08-09T13:28:27.313753038Z",'
    printf '"size":%s,"etag":"%s","type":"file",' "${PROBE_MC_SIZE:-0}" "${PROBE_MC_ETAG:-}"
    printf '"metadata":{"Content-Type":"application/octet-stream"}}\n'
    exit 0 ;;
  ok_decoy)
    # Parser-Stress: eine ZWEITE "size" liegt in einem VERSCHACHTELTEN Objekt und
    # steht VOR der echten. Ein naiver Griff auf den ersten Treffer liest sie.
    printf '{"metadata":{"Content-Type":"application/octet-stream","size":%s},' "${PROBE_MC_DECOY:-999999}"
    printf '"status":"success","name":"x.bin","size":%s,"etag":"","type":"file"}\n' "${PROBE_MC_SIZE:-0}"
    exit 0 ;;
  fehlt)
    printf '{"status":"error","error":{"message":"Unable to stat `%s`.",' "${3:-ziel}"
    printf '"cause":{"message":"Object does not exist","error":{}},"type":"fatal"}}\n'
    exit 1 ;;
  tot)
    printf '{"status":"error","error":{"message":"Unable to list folder.",'
    printf '"cause":{"message":"Get \\"http://store:9000/b/?location=\\": dial tcp 10.0.0.1:9000:'
    printf ' connect: connection refused","error":{"Op":"Get"}},"type":"error"}}\n'
    printf '{"status":"error","error":{"message":"Unable to stat `%s`.",' "${3:-ziel}"
    printf '"cause":{"message":"Object does not exist","error":{}},"type":"fatal"}}\n'
    exit 1 ;;
  auth)
    printf '{"status":"error","error":{"message":"Unable to stat.","cause":{"message":"Access Denied.",'
    printf '"error":{"Code":"AccessDenied"}},"type":"error"}}\n'
    exit 1 ;;
  unklar)
    printf '{"status":"error","error":{"message":"Etwas voellig anderes ist passiert.",'
    printf '"cause":{"message":"kein bekanntes Muster","error":{}},"type":"error"}}\n'
    exit 1 ;;
  credleak)
    # mc soll Credentials nie ausgeben -- falls doch, muss die Wache redigieren.
    printf '{"status":"error","error":{"message":"Unable to reach https://SCHLUESSEL:%s@store:9000/b/",' \
      "${PROBE_MC_GEHEIMNIS:-geheim}"
    printf '"cause":{"message":"dial tcp 10.0.0.1:9000: connect: connection refused","error":{}},"type":"error"}}\n'
    exit 1 ;;
  haenger)
    sleep 30
    exit 0 ;;
  *)
    echo "Fake-mc: unbekannter PROBE_MC_MODUS" >&2
    exit 99 ;;
esac
FAKEEOF
chmod +x "$FAKE_MC"

# ---------------------------------------------------------------------------
#  Text-Matcher der Faelle: LITERAL (grep -F), nie als Muster gedeutet.
#  Vorher stand hier grep ohne -F: "FEHLER [FACHLICH]" war dann eine
#  BRE-Klammerklasse ("FEHLER " + EIN Zeichen aus F,A,C,H,I,L) und traf den
#  literalen Text NIE -- die darf-nicht-Zusicherung der tot/auth-Faelle war
#  tot (Lens-Befund 09.08.). Mutant M6 haelt den Umbau fest: er faellt nur,
#  wenn DIESER Matcher literal vergleicht, denn sein rc ist korrekt.
# ---------------------------------------------------------------------------
hat_text() { grep -qF -- "$1" "$2"; }

# ---------------------------------------------------------------------------
#  Fall-Runner. Prueft rc UND -- wo gefordert -- den Meldungstext, denn die
#  Unterscheidung INFRASTRUKTUR/FACHLICH lebt in der MELDUNG, nicht nur im rc.
#  fall <name> <erw_rc> <muss_text|-> <darf_nicht_text|-> -- <wache-args...>
# ---------------------------------------------------------------------------
fall() {
    _name="$1"; _erw="$2"; _muss="$3"; _darfnicht="$4"; shift 5
    N_FALL=$((N_FALL + 1))
    _out="$ARBEIT/out.$N_FALL"
    if sh "$WACHE_ABS" "$@" > "$_out" 2>&1; then
        _ist=0
    else
        _ist=$?
    fi
    _ok=1
    _grund=""
    if [ "$_ist" -ne "$_erw" ]; then
        _ok=0; _grund="rc=$_ist, erwartet $_erw"
    fi
    if [ "$_muss" != "-" ] && ! hat_text "$_muss" "$_out"; then
        _ok=0; _grund="$_grund; Text '$_muss' fehlt in der Meldung"
    fi
    if [ "$_darfnicht" != "-" ] && hat_text "$_darfnicht" "$_out"; then
        _ok=0; _grund="$_grund; Text '$_darfnicht' steht in der Meldung, darf aber nicht"
    fi
    if [ "$_ok" -eq 1 ]; then
        echo "  OK    [$_name] rc=$_ist"
    else
        echo "  FALSCH[$_name] $_grund" >&2
        echo "  ----- Ausgabe der Wache -----" >&2
        sed 's/^/    /' "$_out" >&2
        FEHLER=$((FEHLER + 1))
    fi
}

echo "============================================================================="
echo "PROBE: OBJECT-STAT-WACHE"
echo "  Wache = $WACHE_ABS"
echo "============================================================================="

# ===========================================================================
#  TEIL 1 -- ECHTE mc-BINARY gegen das Dateisystem. Zufaellige Groesse.
#  Die Wache baut <alias>/<bucket>/<key>; mit alias=<tmpdir> und bucket=<dir>
#  ergibt das einen echten lokalen Pfad, den die echte mc-Binary statten kann.
# ===========================================================================
echo "-- TEIL 1: echte mc-Binary, zufaellig gewuerfelte Groesse --"
ECHT_DIR="$ARBEIT/echt"
mkdir -p "$ECHT_DIR/bucket"
G1=$(wurf_zahl)
KEY1="objekt-$(wurf_wort).bin"
head -c "$G1" /dev/urandom > "$ECHT_DIR/bucket/$KEY1"
# Gegenorakel: die Groesse NICHT aus meiner Wuerfel-Variablen, sondern noch einmal
# unabhaengig aus dem Dateisystem gelesen. Stimmen beide nicht ueberein, ist die
# Probe selbst kaputt und sagt das, statt die Wache zu beschuldigen.
G1_FS=$(wc -c < "$ECHT_DIR/bucket/$KEY1" | tr -d ' ')
if [ "$G1" != "$G1_FS" ]; then
    echo "ABBRUCH: Probe defekt -- gewuerfelt=$G1, Dateisystem=$G1_FS" >&2
    exit 1
fi
echo "  (Wurf dieses Laufs: $G1 Byte, Schluessel $KEY1)"

COMDARE_MINIO_ENDPOINT="$ECHT_DIR" COMDARE_MINIO_BUCKET="bucket" \
  fall "echt-mc/Groesse stimmt" 0 "OBJECT-STAT-WACHE: OK" "-" -- \
  "$KEY1" --groesse "$G1"

COMDARE_MINIO_ENDPOINT="$ECHT_DIR" COMDARE_MINIO_BUCKET="bucket" \
  fall "echt-mc/Erwartung um 1 daneben (T-4 Gegeneingang)" 1 "FACHLICH" "-" -- \
  "$KEY1" --groesse "$((G1 + 1))"

COMDARE_MINIO_ENDPOINT="$ECHT_DIR" COMDARE_MINIO_BUCKET="bucket" \
  fall "echt-mc/Erwartung aus wc -c der lokalen Datei" 0 "OBJECT-STAT-WACHE: OK" "-" -- \
  "$KEY1" --lokal "$ECHT_DIR/bucket/$KEY1"

# T-4-Gegeneingang zu --lokal (Lens-Befund 09.08.): eine lokale Datei, deren
# Groesse vom Store-Objekt abweicht, MUSS FACHLICH rot werden. Ohne diesen Fall
# war der Kern des T-3-Vertrags unbewacht: eine Wache, die die Erwartung
# heimlich aus der mc-Antwort selbst naehme, bliebe in allen Gruen-Faellen
# gruen und verglich sich mit sich selbst (Stellvertreter; Mutant M5 unten).
# Der Abstand D1 ist frisch gewuerfelt (K13) und per Konstruktion >= 1.
D1=$(wurf_zahl)
LOKAL_ANDERS="$ARBEIT/lokal-anders.bin"
head -c "$((G1 + D1))" /dev/urandom > "$LOKAL_ANDERS"
LOKAL_ANDERS_FS=$(wc -c < "$LOKAL_ANDERS" | tr -d ' ')
if [ "$LOKAL_ANDERS_FS" = "$G1" ] || [ "$LOKAL_ANDERS_FS" != "$((G1 + D1))" ]; then
    echo "ABBRUCH: Probe defekt -- Gegeneingang $LOKAL_ANDERS_FS Byte, Objekt $G1 Byte, Wurf D1=$D1." >&2
    exit 1
fi
COMDARE_MINIO_ENDPOINT="$ECHT_DIR" COMDARE_MINIO_BUCKET="bucket" \
  fall "echt-mc/--lokal weicht ab (T-4 Gegeneingang)" 1 "die Groesse im Store weicht ab" "INFRASTRUKTUR" -- \
  "$KEY1" --lokal "$LOKAL_ANDERS"

COMDARE_MINIO_ENDPOINT="$ECHT_DIR" COMDARE_MINIO_BUCKET="bucket" \
  fall "echt-mc/Objekt fehlt am erreichbaren Ort" 1 "FACHLICH" "INFRASTRUKTUR" -- \
  "gibtesnicht-$(wurf_wort).bin" --groesse "$G1"

# Belegt zusaetzlich, dass die GELESENE Zahl wirklich die gewuerfelte ist und die
# Wache sie nicht bloss "irgendwie" akzeptiert: die Zahl muss literal im Beleg stehen.
N_FALL=$((N_FALL + 1))
if COMDARE_MINIO_ENDPOINT="$ECHT_DIR" COMDARE_MINIO_BUCKET="bucket" \
   sh "$WACHE_ABS" "$KEY1" --groesse "$G1" > "$ARBEIT/beleg.txt" 2>&1 &&
   grep -q "Groesse = $G1 Byte" "$ARBEIT/beleg.txt"; then
    echo "  OK    [echt-mc/gewuerfelte Zahl steht literal im Beleg] $G1"
else
    echo "  FALSCH[echt-mc/gewuerfelte Zahl steht literal im Beleg] $G1 fehlt" >&2
    sed 's/^/    /' "$ARBEIT/beleg.txt" >&2
    FEHLER=$((FEHLER + 1))
fi

# ===========================================================================
#  TEIL 2 -- FAKE-mc: die Store-Fehlerfaelle, die lokal nicht herstellbar sind.
# ===========================================================================
echo "-- TEIL 2: Fake-mc, Store-Fehlerfaelle --"
G2=$(wurf_zahl)
ET2=$(wurf_wort)

COMDARE_MC_BIN="$FAKE_MC" COMDARE_MINIO_ENDPOINT="alias" COMDARE_MINIO_BUCKET="bucket" \
  PROBE_MC_MODUS=ok PROBE_MC_SIZE="$G2" PROBE_MC_ETAG="$ET2" \
  fall "fake/Groesse stimmt" 0 "OBJECT-STAT-WACHE: OK" "-" -- \
  "k.bin" --groesse "$G2"

COMDARE_MC_BIN="$FAKE_MC" COMDARE_MINIO_ENDPOINT="alias" COMDARE_MINIO_BUCKET="bucket" \
  PROBE_MC_MODUS=ok PROBE_MC_SIZE="$G2" PROBE_MC_ETAG="$ET2" \
  fall "fake/Groesse weicht ab -> FACHLICH" 1 "FACHLICH" "INFRASTRUKTUR" -- \
  "k.bin" --groesse "$((G2 + 7))"

COMDARE_MC_BIN="$FAKE_MC" COMDARE_MINIO_ENDPOINT="alias" COMDARE_MINIO_BUCKET="bucket" \
  PROBE_MC_MODUS=ok PROBE_MC_SIZE="$G2" PROBE_MC_ETAG="$ET2" \
  fall "fake/etag stimmt" 0 "OBJECT-STAT-WACHE: OK" "-" -- \
  "k.bin" --groesse "$G2" --etag "$ET2"

COMDARE_MC_BIN="$FAKE_MC" COMDARE_MINIO_ENDPOINT="alias" COMDARE_MINIO_BUCKET="bucket" \
  PROBE_MC_MODUS=ok PROBE_MC_SIZE="$G2" PROBE_MC_ETAG="$ET2" \
  fall "fake/etag weicht ab -> FACHLICH" 1 "etag im Store weicht ab" "-" -- \
  "k.bin" --groesse "$G2" --etag "$(wurf_wort)"

# DER KERNFALL. Toter Store: mc liefert rc=1 und eine LETZTE Zeile, die mit dem
# Fall "Objekt fehlt" bedeutungsgleich ist. Die Wache muss trotzdem INFRASTRUKTUR
# melden und ausdruecklich NICHT FACHLICH.
COMDARE_MC_BIN="$FAKE_MC" COMDARE_MINIO_ENDPOINT="alias" COMDARE_MINIO_BUCKET="bucket" \
  PROBE_MC_MODUS=tot \
  fall "fake/TOTER STORE -> INFRASTRUKTUR, nicht FACHLICH" 3 "INFRASTRUKTUR" "FEHLER [FACHLICH]" -- \
  "k.bin" --groesse "$G2"

COMDARE_MC_BIN="$FAKE_MC" COMDARE_MINIO_ENDPOINT="alias" COMDARE_MINIO_BUCKET="bucket" \
  PROBE_MC_MODUS=fehlt \
  fall "fake/Objekt fehlt -> FACHLICH, nicht INFRASTRUKTUR" 1 "FACHLICH" "INFRASTRUKTUR" -- \
  "k.bin" --groesse "$G2"

COMDARE_MC_BIN="$FAKE_MC" COMDARE_MINIO_ENDPOINT="alias" COMDARE_MINIO_BUCKET="bucket" \
  PROBE_MC_MODUS=auth \
  fall "fake/Anmeldung abgelehnt -> INFRASTRUKTUR" 3 "INFRASTRUKTUR" "FEHLER [FACHLICH]" -- \
  "k.bin" --groesse "$G2"

COMDARE_MC_BIN="$FAKE_MC" COMDARE_MINIO_ENDPOINT="alias" COMDARE_MINIO_BUCKET="bucket" \
  PROBE_MC_MODUS=unklar \
  fall "fake/unklassifiziert -> INFRASTRUKTUR (fail-closed)" 3 "INFRASTRUKTUR" "-" -- \
  "k.bin" --groesse "$G2"

COMDARE_MC_BIN="$FAKE_MC" COMDARE_MINIO_ENDPOINT="alias" COMDARE_MINIO_BUCKET="bucket" \
  PROBE_MC_MODUS=haenger \
  fall "fake/Zeitueberschreitung -> INFRASTRUKTUR" 3 "Zeitschranke" "-" -- \
  "k.bin" --groesse "$G2" --timeout 1

# Parser-Stress: eine verschachtelte "size" steht VOR der echten. Der naive
# Griff auf den ersten Treffer liest den Koeder und meldet ihn als Groesse.
DECOY=$((G2 + 12345))
COMDARE_MC_BIN="$FAKE_MC" COMDARE_MINIO_ENDPOINT="alias" COMDARE_MINIO_BUCKET="bucket" \
  PROBE_MC_MODUS=ok_decoy PROBE_MC_SIZE="$G2" PROBE_MC_DECOY="$DECOY" \
  fall "fake/verschachtelte Koeder-size wird NICHT gelesen" 0 "OBJECT-STAT-WACHE: OK" "-" -- \
  "k.bin" --groesse "$G2"

COMDARE_MC_BIN="$FAKE_MC" COMDARE_MINIO_ENDPOINT="alias" COMDARE_MINIO_BUCKET="bucket" \
  PROBE_MC_MODUS=ok_decoy PROBE_MC_SIZE="$G2" PROBE_MC_DECOY="$DECOY" \
  fall "fake/Gegenprobe: Koeder-size gilt gerade NICHT als Erwartung" 1 "FACHLICH" "-" -- \
  "k.bin" --groesse "$DECOY"

# Credentials duerfen NIE im Log landen -- auch nicht, wenn mc sie ausspuckt.
GEHEIM=$(wurf_wort)
COMDARE_MC_BIN="$FAKE_MC" COMDARE_MINIO_ENDPOINT="alias" COMDARE_MINIO_BUCKET="bucket" \
  PROBE_MC_MODUS=credleak PROBE_MC_GEHEIMNIS="$GEHEIM" \
  fall "fake/Credential in mc-Meldung wird redigiert" 3 "REDIGIERT" "$GEHEIM" -- \
  "k.bin" --groesse "$G2"

# ===========================================================================
#  TEIL 3 -- FAIL-CLOSED und Aufruf-Fehler.
# ===========================================================================
echo "-- TEIL 3: fail-closed und Aufruf-Fehler --"

COMDARE_MINIO_ENDPOINT="" COMDARE_MINIO_BUCKET="" \
  fall "keine Store-Konfiguration -> ROT, niemals gruen" 3 "INFRASTRUKTUR" "-" -- \
  "k.bin" --groesse 1

COMDARE_MC_BIN="$ARBEIT/gibtesnicht-mc" COMDARE_MINIO_ENDPOINT="alias" COMDARE_MINIO_BUCKET="bucket" \
  fall "mc-Binary fehlt -> INFRASTRUKTUR" 3 "INFRASTRUKTUR" "-" -- \
  "k.bin" --groesse 1

fall "kein Objekt-Schluessel -> Aufruffehler" 2 "ABBRUCH" "-" --
fall "keine Erwartung -> Aufruffehler" 2 "keine erwartete Groesse" "-" -- "k.bin"
COMDARE_MINIO_ENDPOINT="$ECHT_DIR" COMDARE_MINIO_BUCKET="bucket" \
  fall "--groesse und --lokal zugleich -> Aufruffehler" 2 "schliessen sich aus" "-" -- \
  "$KEY1" --groesse 1 --lokal "$ECHT_DIR/bucket/$KEY1"
fall "nicht-numerische Groesse -> Aufruffehler" 2 "keine Zahl" "-" -- "k.bin" --groesse "abc"

# ===========================================================================
#  TEIL 3b -- die ABNAHME (ci/object_stat_abnahme.sh), Round-Trip.
#  Sie laeuft hier gegen die ECHTE mc-Binary mit einem lokalen Verzeichnis als
#  Store-Ersatz: cp und stat gehen wirklich durch mc. Was damit NICHT geprueft
#  ist, steht im Nenner am Ende.
# ===========================================================================
ABNAHME="$(dirname "$WACHE_ABS")/object_stat_abnahme.sh"
if [ -f "$ABNAHME" ]; then
    echo "-- TEIL 3b: Abnahme (Round-Trip) --"
    ABN_DIR="$ARBEIT/abn"
    mkdir -p "$ABN_DIR/bucket"

    N_FALL=$((N_FALL + 1))
    if COMDARE_MINIO_ENDPOINT="$ABN_DIR" COMDARE_MINIO_BUCKET="bucket" \
       sh "$ABNAHME" > "$ARBEIT/abn_ok.txt" 2>&1; then
        _a=0
    else
        _a=$?
    fi
    # Nicht nur rc: die Abnahme muss die GEWUERFELTE Zahl im Beleg fuehren, und
    # sie muss zweimal dieselbe sein (Wurf-Zeile und Schluss-Zeile).
    _wurf=$(awk '/Wurf dieses Laufs/ { print $5; exit }' "$ARBEIT/abn_ok.txt")
    if [ "$_a" -eq 0 ] && [ -n "$_wurf" ] && grep -q "Objekt von $_wurf Byte" "$ARBEIT/abn_ok.txt"; then
        echo "  OK    [abnahme/Round-Trip mit echter mc-Binary] rc=0, Wurf $_wurf Byte durchgaengig belegt"
    else
        echo "  FALSCH[abnahme/Round-Trip mit echter mc-Binary] rc=$_a, Wurf='$_wurf'" >&2
        sed 's/^/    /' "$ARBEIT/abn_ok.txt" >&2
        FEHLER=$((FEHLER + 1))
    fi

    N_FALL=$((N_FALL + 1))
    if COMDARE_MINIO_ENDPOINT="" COMDARE_MINIO_BUCKET="" \
       sh "$ABNAHME" > "$ARBEIT/abn_rot.txt" 2>&1; then
        _b=0
    else
        _b=$?
    fi
    if [ "$_b" -eq 3 ] && grep -q "INFRASTRUKTUR" "$ARBEIT/abn_rot.txt"; then
        echo "  OK    [abnahme/ohne Store-Konfiguration ROT] rc=3"
    else
        echo "  FALSCH[abnahme/ohne Store-Konfiguration ROT] rc=$_b, erwartet 3" >&2
        sed 's/^/    /' "$ARBEIT/abn_rot.txt" >&2
        FEHLER=$((FEHLER + 1))
    fi

    # Das Probe-Objekt muss nach dem Lauf wieder weg sein -- eine Abnahme, die
    # den Store zumuellt, ist im Dauerbetrieb nicht tragbar.
    N_FALL=$((N_FALL + 1))
    _reste=$(find "$ABN_DIR" -type f 2>/dev/null | wc -l | tr -d ' ')
    if [ "$_reste" -eq 0 ]; then
        echo "  OK    [abnahme/raeumt ihr Probe-Objekt wieder ab] 0 Reste von 1 abgelegten Objekt"
    else
        echo "  FALSCH[abnahme/raeumt ihr Probe-Objekt wieder ab] $_reste Rest(e) geblieben" >&2
        FEHLER=$((FEHLER + 1))
    fi

    # T-4-Gegeneingang der ABNAHME (Lens-Befund 09.08.): ihr FACHLICH-Pfad
    # (rc=1) wurde bisher nie gefahren, nur 0 und 3. Ein Sabotage-mc reicht
    # alles an das echte mc durch, haengt aber nach ERFOLGREICHEM cp EIN Byte
    # an das abgelegte Objekt an: der Store haelt dann etwas anderes, als
    # eingelagert wurde -- genau der Fall, den der Round-Trip fangen muss.
    # stat und rm laufen unveraendert durch die echte mc-Binary.
    SABO_MC="$ARBEIT/sabotage-mc"
    cat > "$SABO_MC" <<'SABOEOF'
#!/bin/sh
# Sabotage-mc der Probe: cp durchreichen, dann 1 Byte anhaengen. Rest: exec mc.
set -eu
if [ "${1:-}" = "cp" ]; then
    if mc "$@"; then _rc=0; else _rc=$?; fi
    if [ "$_rc" -eq 0 ]; then
        for _letztes in "$@"; do :; done
        printf X >> "$_letztes"
    fi
    exit "$_rc"
fi
exec mc "$@"
SABOEOF
    chmod +x "$SABO_MC"

    N_FALL=$((N_FALL + 1))
    if COMDARE_MC_BIN="$SABO_MC" COMDARE_MINIO_ENDPOINT="$ABN_DIR" COMDARE_MINIO_BUCKET="bucket" \
       sh "$ABNAHME" > "$ARBEIT/abn_fachlich.txt" 2>&1; then
        _c=0
    else
        _c=$?
    fi
    if [ "$_c" -eq 1 ] && hat_text "die Groesse im Store weicht ab" "$ARBEIT/abn_fachlich.txt" \
       && hat_text "ABNAHME FEHLGESCHLAGEN (rc=1)" "$ARBEIT/abn_fachlich.txt"; then
        echo "  OK    [abnahme/T-4: Store haelt anderes Objekt -> FACHLICH] rc=1"
    else
        echo "  FALSCH[abnahme/T-4: Store haelt anderes Objekt -> FACHLICH] rc=$_c, erwartet 1" >&2
        sed 's/^/    /' "$ARBEIT/abn_fachlich.txt" >&2
        FEHLER=$((FEHLER + 1))
    fi
else
    echo "-- TEIL 3b: ABBRUCH -- $ABNAHME fehlt" >&2
    FEHLER=$((FEHLER + 1))
fi

# ===========================================================================
#  TEIL 4 -- SELBSTBISS: Wegwerf-Mutanten der Wache.
# ===========================================================================
N_MUTANT=0
N_ERKANNT=0
if [ "$SELBSTBISS" -eq 1 ]; then
    echo "-- TEIL 4: Selbstbiss, Wegwerf-Mutanten --"

    # M1 -- der Stellvertreter, gegen den diese Wache gebaut ist: Klassifikation
    # in der falschen Reihenfolge. Dann gewinnt die FEHLT-Signatur der letzten
    # Zeile ueber die NETZ-Signatur der ersten, und ein toter Store wird als
    # fehlendes Objekt gemeldet -- die laute Ursache durch die leise ersetzt.
    M1="$ARBEIT/mutant1.sh"
    awk '/else if \(netz\)  klasse = "NETZ"/ { next } { print }' "$WACHE_ABS" > "$M1"
    if cmp -s "$WACHE_ABS" "$M1"; then
        echo "  ABBRUCH: M1-Mutation hat nichts geaendert -- die Probe waere wertlos." >&2
        FEHLER=$((FEHLER + 1))
    fi
    N_MUTANT=$((N_MUTANT + 1))
    if COMDARE_MC_BIN="$FAKE_MC" COMDARE_MINIO_ENDPOINT="alias" COMDARE_MINIO_BUCKET="bucket" \
       PROBE_MC_MODUS=tot sh "$M1" "k.bin" --groesse "$G2" > "$ARBEIT/m1.txt" 2>&1; then
        _m1=0
    else
        _m1=$?
    fi
    if [ "$_m1" -eq 3 ]; then
        echo "  NICHT ERKANNT [M1 NETZ-Zweig gestrichen] Mutant meldet weiterhin rc=3" >&2
        FEHLER=$((FEHLER + 1))
    else
        echo "  ERKANNT [M1 NETZ-Zweig gestrichen] Mutant meldet rc=$_m1 statt 3"
        echo "          -> toter Store waere als fehlendes Objekt durchgegangen"
        N_ERKANNT=$((N_ERKANNT + 1))
    fi

    # M2 -- Groessenvergleich entschaerft: die Wache prueft nur noch Anwesenheit.
    M2="$ARBEIT/mutant2.sh"
    sed 's/^if \[ "\$IST_GROESSE" != "\$ERW_GROESSE" \]; then$/if [ "1" = "0" ]; then/' \
        "$WACHE_ABS" > "$M2"
    if cmp -s "$WACHE_ABS" "$M2"; then
        echo "  ABBRUCH: M2-Mutation hat nichts geaendert -- die Probe waere wertlos." >&2
        FEHLER=$((FEHLER + 1))
    else
        N_MUTANT=$((N_MUTANT + 1))
        if COMDARE_MC_BIN="$FAKE_MC" COMDARE_MINIO_ENDPOINT="alias" COMDARE_MINIO_BUCKET="bucket" \
           PROBE_MC_MODUS=ok PROBE_MC_SIZE="$G2" sh "$M2" "k.bin" --groesse "$((G2 + 7))" > "$ARBEIT/m2.txt" 2>&1; then
            _m2=0
        else
            _m2=$?
        fi
        if [ "$_m2" -eq 0 ]; then
            echo "  ERKANNT [M2 Groessenvergleich entschaerft] Mutant meldet gruen bei falscher Groesse"
            echo "          -> Anwesenheit statt Aussage"
            N_ERKANNT=$((N_ERKANNT + 1))
        else
            echo "  NICHT ERKANNT [M2 Groessenvergleich entschaerft] Mutant faellt weiterhin (rc=$_m2)" >&2
            FEHLER=$((FEHLER + 1))
        fi
    fi

    # M3 -- die verbotene stille Null: fehlende Konfiguration wird uebersprungen.
    M3="$ARBEIT/mutant3.sh"
    awk '{ if ($0 == "    exit 3" && !getan) { print "    exit 0"; getan = 1 } else print }' \
        "$WACHE_ABS" > "$M3"
    if cmp -s "$WACHE_ABS" "$M3"; then
        echo "  ABBRUCH: M3-Mutation hat nichts geaendert -- die Probe waere wertlos." >&2
        FEHLER=$((FEHLER + 1))
    else
        N_MUTANT=$((N_MUTANT + 1))
        if COMDARE_MINIO_ENDPOINT="" COMDARE_MINIO_BUCKET="" \
           sh "$M3" "k.bin" --groesse 1 > "$ARBEIT/m3.txt" 2>&1; then
            _m3=0
        else
            _m3=$?
        fi
        if [ "$_m3" -eq 0 ]; then
            echo "  ERKANNT [M3 fehlende Konfiguration uebersprungen] Mutant meldet gruen ohne Messgegenstand"
            N_ERKANNT=$((N_ERKANNT + 1))
        else
            echo "  NICHT ERKANNT [M3 fehlende Konfiguration uebersprungen] Mutant faellt weiterhin (rc=$_m3)" >&2
            FEHLER=$((FEHLER + 1))
        fi
    fi

    # M4 -- die REIHENFOLGE selbst, nicht bloss die Anwesenheit des Zweiges.
    # M1 streicht den NETZ-Zweig; M4 laesst beide Zweige stehen und vertauscht
    # nur ihre Reihenfolge. Genau diese Reihenfolge ist die Entwurfsaussage:
    # die NETZ-Signatur der ERSTEN mc-Zeile muss die FEHLT-Signatur der letzten
    # schlagen. Ein Mutant, der beide Zweige behaelt und trotzdem falsch
    # klassifiziert, beweist, dass die Aussage an der Reihenfolge haengt.
    M4="$ARBEIT/mutant4.sh"
    awk '
        /else if \(netz\)  klasse = "NETZ"/  { print "    else if (fehlt) klasse = \"FEHLT\""; next }
        /else if \(fehlt\) klasse = "FEHLT"/ { print "    else if (netz)  klasse = \"NETZ\""; next }
        { print }
    ' "$WACHE_ABS" > "$M4"
    if cmp -s "$WACHE_ABS" "$M4"; then
        echo "  ABBRUCH: M4-Mutation hat nichts geaendert -- die Probe waere wertlos." >&2
        FEHLER=$((FEHLER + 1))
    else
        N_MUTANT=$((N_MUTANT + 1))
        if COMDARE_MC_BIN="$FAKE_MC" COMDARE_MINIO_ENDPOINT="alias" COMDARE_MINIO_BUCKET="bucket" \
           PROBE_MC_MODUS=tot sh "$M4" "k.bin" --groesse "$G2" > "$ARBEIT/m4.txt" 2>&1; then
            _m4=0
        else
            _m4=$?
        fi
        if [ "$_m4" -eq 3 ]; then
            echo "  NICHT ERKANNT [M4 Klassifikations-Reihenfolge vertauscht] Mutant meldet weiterhin rc=3" >&2
            FEHLER=$((FEHLER + 1))
        else
            echo "  ERKANNT [M4 Klassifikations-Reihenfolge vertauscht] Mutant meldet rc=$_m4 statt 3"
            echo "          -> die Reihenfolge ist die Aussage, nicht der blosse Zweig"
            N_ERKANNT=$((N_ERKANNT + 1))
        fi
    fi

    # M5 -- der Stellvertreter IN der Wache (Lens-Mutant L2, 09.08.): nach dem
    # Lesen der mc-Antwort wird die Erwartung heimlich durch den IST-Wert
    # ersetzt. Die Herkunftszeile behauptet weiter die fremde Quelle, WAEHREND
    # gegen sich selbst verglichen wird; rc bleibt in allen Gruen-Faellen 0.
    # NUR der T-4-Gegeneingang (--lokal mit abweichender Groesse) faengt ihn.
    M5="$ARBEIT/mutant5.sh"
    awk '{ print }
         /^ERSTFEHLER=\$\(hole ERSTFEHLER\)$/ {
             print "[ -n \"$LOKAL_DATEI\" ] && ERW_GROESSE=\"$IST_GROESSE\""
         }' "$WACHE_ABS" > "$M5"
    if cmp -s "$WACHE_ABS" "$M5"; then
        echo "  ABBRUCH: M5-Mutation hat nichts geaendert -- die Probe waere wertlos." >&2
        FEHLER=$((FEHLER + 1))
    else
        N_MUTANT=$((N_MUTANT + 1))
        if COMDARE_MINIO_ENDPOINT="$ECHT_DIR" COMDARE_MINIO_BUCKET="bucket" \
           sh "$M5" "$KEY1" --lokal "$LOKAL_ANDERS" > "$ARBEIT/m5.txt" 2>&1; then
            _m5=0
        else
            _m5=$?
        fi
        if [ "$_m5" -eq 0 ]; then
            echo "  ERKANNT [M5 Erwartung heimlich aus der mc-Antwort] Mutant meldet gruen"
            echo "          trotz abweichender lokaler Groesse -> Vergleich mit sich selbst"
            N_ERKANNT=$((N_ERKANNT + 1))
        else
            echo "  NICHT ERKANNT [M5 Erwartung heimlich aus der mc-Antwort] Mutant faellt weiterhin (rc=$_m5)" >&2
            FEHLER=$((FEHLER + 1))
        fi
    fi

    # M6 -- die MELDUNG luegt, der rc nicht (Lens-Mutant L4, 09.08.): der
    # NETZ-Zweig behaelt INFRASTRUKTUR und rc=3, gibt aber zusaetzlich eine
    # woertliche FACHLICH-Zeile aus. Ein reiner rc-Pruefer sieht nichts; nur
    # der LITERALE darf-nicht-Matcher (hat_text, grep -F) faengt ihn. Vor dem
    # Umbau auf grep -F war "FEHLER [FACHLICH]" eine BRE-Klammerklasse und
    # traf den literalen Text nie. Erkannt wird ueber DENSELBEN Matcher, den
    # auch fall() benutzt -- faellt der Umbau je zurueck, wird DIESER Mutant
    # nicht mehr erkannt und die Probe rot.
    M6="$ARBEIT/mutant6.sh"
    awk '{ print }
         /der Objekt-Store ist NICHT ERREICHBAR/ {
             print "        echo \"FEHLER [FACHLICH]: Koeder des Mutanten M6\" >&2"
         }' "$WACHE_ABS" > "$M6"
    if cmp -s "$WACHE_ABS" "$M6"; then
        echo "  ABBRUCH: M6-Mutation hat nichts geaendert -- die Probe waere wertlos." >&2
        FEHLER=$((FEHLER + 1))
    else
        N_MUTANT=$((N_MUTANT + 1))
        if COMDARE_MC_BIN="$FAKE_MC" COMDARE_MINIO_ENDPOINT="alias" COMDARE_MINIO_BUCKET="bucket" \
           PROBE_MC_MODUS=tot sh "$M6" "k.bin" --groesse "$G2" > "$ARBEIT/m6.txt" 2>&1; then
            _m6=0
        else
            _m6=$?
        fi
        if [ "$_m6" -eq 3 ] && hat_text "FEHLER [FACHLICH]" "$ARBEIT/m6.txt"; then
            echo "  ERKANNT [M6 FACHLICH-Zeile bei korrektem rc=3] der literale"
            echo "          darf-nicht-Matcher greift auf die Klammer-Zeile"
            N_ERKANNT=$((N_ERKANNT + 1))
        else
            echo "  NICHT ERKANNT [M6 FACHLICH-Zeile bei korrektem rc=3] rc=$_m6, Matcher blind" >&2
            FEHLER=$((FEHLER + 1))
        fi
    fi
fi

# ===========================================================================
echo "============================================================================="
echo "NENNER: $N_FALL Fall/Faelle geprueft, $FEHLER falsch."
echo "  Grundgesamtheit = alle in dieser Datei aufgefuehrten Faelle, je Lauf mit"
echo "  frisch gewuerfelten Groessen/etags (dieser Lauf: $G1 und $G2 Byte)."
if [ "$SELBSTBISS" -eq 1 ]; then
    echo "  SELBSTBISS: $N_ERKANNT von $N_MUTANT Mutanten erkannt."
else
    echo "  SELBSTBISS: nicht gelaufen (mit --selbstbiss aufrufen)."
fi
echo "  NICHT geprueft und ausdruecklich NICHT behauptet: ein Round-Trip gegen"
echo "  echtes MinIO ueber S3. Dafuer fehlen dieser Maschine die Zugangsdaten."
echo "============================================================================="

if [ "$FEHLER" -ne 0 ]; then
    echo "PROBE FEHLGESCHLAGEN: $FEHLER von $N_FALL Fall/Faellen falsch." >&2
    exit 1
fi
if [ "$SELBSTBISS" -eq 1 ] && [ "$N_ERKANNT" -ne "$N_MUTANT" ]; then
    echo "PROBE FEHLGESCHLAGEN: nur $N_ERKANNT von $N_MUTANT Mutanten erkannt." >&2
    exit 1
fi
echo "PROBE OK."
exit 0
