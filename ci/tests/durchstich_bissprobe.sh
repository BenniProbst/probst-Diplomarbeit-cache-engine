#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  BISSPROBE fuer die DURCHSTICH-WACHE   (ci/durchstich_wache.sh)
#  -- die Wache selbst ist ein Pruefling, nicht nur ein Pruefer.  (2026-08-09)
# =============================================================================
#
# WARUM ES SIE GIBT:
# Die Durchstich-Wache entscheidet am 14.08. (F1), ob der Mini-Lauf etwas
# BEWIESEN hat oder nur gruen war. Sie ist damit genau die Sorte Werkzeug, die
# im Haus schon einmal still nachgegeben hat: ein Gate, das gruen sagt, ohne zu
# pruefen. Vier von fuenf CI-gerufenen Wachen hatten am 09.08. keinen
# Selbsttest; diese startet mit einem.
#
# WAS "BISS" HEISST (TDD-Vertrag T-1):
# Die Probe laeuft nicht nur gegen die gesunde Wache (dort ist sie gruen),
# sondern zusaetzlich gegen WEGWERF-MUTANTEN, aus denen je ein `exit 1`
# entfernt ist. `--selbstbiss` fordert, dass die Probe an JEDEM Mutanten rot
# wird. Eine Probe, die am kranken Objekt gruen bleibt, ist keine Probe.
#
# DIE DREI LAGEN, DIE UNTERSCHIEDEN WERDEN (Hausregel):
#   rc=0  alle Faelle gehalten
#   rc=1  RISS -- die Wache urteilt falsch (oder ein Mutant ueberlebt)
#   rc=2  die Probe konnte nicht pruefen (Wache fehlt, Mutation griff nicht,
#         Koeder biss nicht, Werkzeug kaputt). Ausdruecklich KEIN Gruen.
#
# ORAKEL (T-5), gewuerfelt statt abgeschrieben (K13):
# Die erwarteten Zahlen stammen NICHT aus der Wache und nicht aus einer Doku,
# sondern je Lauf frisch aus /dev/urandom: wie viele Zellen der erfundene
# Treiber-Marker als gemessen/resumiert meldet, wie viele Workload-Ids das
# erfundene Profil deklariert und welche davon fehlt. Eine Wache, die eine feste
# Zahl faelscht, faellt daran. Die Zahlen im Protokoll wechseln deshalb bei
# jedem Lauf -- das ist Absicht, kein Rauschen.
#
# AUFRUF:
#   sh ci/tests/durchstich_bissprobe.sh              # nur die Faelle
#   sh ci/tests/durchstich_bissprobe.sh --selbstbiss # Faelle + Mutationsbeweis
#
# ENV:
#   COMDARE_WACHE   Pfad zur zu pruefenden Wache (Default: ../durchstich_wache.sh).
#                   Der --selbstbiss-Zweig setzt sie auf die Mutanten.
#
# TESTKRITIK (T-9), was diese Probe NICHT deckt:
#   - Sie prueft die Wache, nicht den Treiber. Dass der Treiber die Zeile
#     "RUN_PROFILE fertig: ... measured=N resumed=M" ueberhaupt und in dieser
#     Form schreibt, ist hier ANGENOMMEN (belegt am ce-Quelltext
#     profile_run_entry.hpp:1180-1183, nicht an einem Lauf). Aendert der Treiber
#     das Format, wird die Wache rc=2 melden -- unpruefbar, nicht gruen; das ist
#     der gewollte Ausgang, aber diese Probe merkt es nicht vorher.
#   - Sie prueft nicht, ob der CI-Job die Wache ueberhaupt ruft. Dafuer steht
#     Fall F9 (Registrierung), und der prueft nur die Anwesenheit des Aufrufs
#     im YAML, nicht seine Ausfuehrung.
#   - Sie sagt nichts ueber die Laufzeit des Mini-Laufs.
# =============================================================================

set -eu

MODUS="${1:-}"
case "$MODUS" in
    ''|--selbstbiss) : ;;
    *) echo "AUFRUF: sh ci/tests/durchstich_bissprobe.sh [--selbstbiss]" >&2; exit 2 ;;
esac

SELBST=$(cd "$(dirname "$0")" && pwd)/$(basename "$0")
HIER=$(cd "$(dirname "$0")" && pwd)
WACHE="${COMDARE_WACHE:-$HIER/../durchstich_wache.sh}"
YAML="$HIER/../../.gitlab-ci.yml"

if [ ! -f "$WACHE" ]; then
    echo "ABBRUCH: Wache '$WACHE' nicht gefunden -- die Probe konnte nicht pruefen." >&2
    exit 2
fi

WERK=$(mktemp -d) || exit 2
trap 'rm -rf "$WERK"' EXIT INT TERM

N_FAELLE=0
N_RISSE=0

# --------------------------------------------------------------------------
# Wuerfel: 1..$1, gleichverteilt genug fuer einen Koeder.
# --------------------------------------------------------------------------
wuerfel() {
    _max="$1"
    _r=$(od -An -N2 -tu2 < /dev/urandom | tr -d ' ')
    [ -n "$_r" ] || { echo "ABBRUCH: /dev/urandom lieferte nichts -- Koeder unmoeglich." >&2; exit 2; }
    echo $(( (_r % _max) + 1 ))
}

# --------------------------------------------------------------------------
# fall <name> <erwarteter-rc> -- Kommando kommt ueber $CMD_* Variablen,
# ausgefuehrt in einer Subshell, damit set -e den Fall nicht abbricht.
# --------------------------------------------------------------------------
fall() {
    _name="$1"
    _erw="$2"
    shift 2
    N_FAELLE=$((N_FAELLE + 1))
    _log="$WERK/fall_$N_FAELLE.log"
    set +e
    sh "$WACHE" "$@" > "$_log" 2>&1
    _rc=$?
    set -e
    if [ "$_rc" -eq "$_erw" ]; then
        echo "  [ OK ]  $_name  (rc=$_rc, erwartet $_erw)"
    else
        N_RISSE=$((N_RISSE + 1))
        echo "  [ROT ]  $_name"
        echo "        RISS: rc=$_rc, erwartet $_erw. Literale Ausgabe der Wache:"
        sed 's/^/          | /' "$_log"
    fi
}

echo "============================================================================="
echo "BISSPROBE DURCHSTICH-WACHE   Wache=$WACHE"
echo "============================================================================="

# --------------------------------------------------------------------------
# WERKZEUG-GEGENPROBE (vor allen Faellen): sucht grep -F auf dieser Maschine
# ueberhaupt? Ein "0 Treffer" ist sonst nicht unterscheidbar von "Werkzeug
# sucht nicht" -- dieselbe Falle, an der am 08.08. eine Null wertlos war.
# --------------------------------------------------------------------------
KOEDER_N=$(wuerfel 5)
: > "$WERK/werkzeug_koeder.txt"
_i=1
while [ "$_i" -le "$KOEDER_N" ]; do
    echo "RUN_PROFILE fertig: measured=$_i resumed=0" >> "$WERK/werkzeug_koeder.txt"
    _i=$((_i + 1))
done
GEFUNDEN=$(grep -cF 'RUN_PROFILE fertig:' "$WERK/werkzeug_koeder.txt" || true)
echo ""
echo "WERKZEUG-GEGENPROBE: $KOEDER_N Koeder-Zeilen geschrieben, grep -F findet $GEFUNDEN."
if [ "$GEFUNDEN" -ne "$KOEDER_N" ]; then
    echo "ABBRUCH: grep -F findet $GEFUNDEN von $KOEDER_N gewuerfelten Vorkommen." >&2
    echo "         Das Werkzeug sucht nicht wie erwartet -- jede Null waere wertlos." >&2
    exit 2
fi
echo "  Der Koeder beisst; Zaehlungen dieser Probe sind belastbar."

# ==========================================================================
# TEIL A -- frische
# ==========================================================================
echo ""
echo "--- frische ---------------------------------------------------------------"

# Gewuerfelter gesunder Lauf: M gemessen, 0 resumiert.
# Die Marker-Zeile ist der echten nachgebildet (ce profile_run_entry.hpp:1180-1183); die Klammer-Gruppe
# "(basis_ids=.. sota_ids=..)" der Original-Zeile ist hier weggelassen, weil die Wache token-weise liest
# (measured=/resumed= als eigenstaendige Felder) und die Zeile sonst ueber die 120-Byte-Grenze liefe.
M_OK=$(wuerfel 9)
cat > "$WERK/log_frisch.txt" <<EOF
[E4] irgendeine Zeile davor
RUN_PROFILE fertig: basis_rows=$M_OK sota_rows=0 measured=$M_OK resumed=0 provisioned=1 csv_ok=1
=== fertig ===
EOF
echo "  (gewuerfelt: measured=$M_OK, resumed=0)"
fall "F1  frischer Lauf haelt (measured=$M_OK >= 1)"            0 frische "$WERK/log_frisch.txt" 1
fall "F2  frischer Lauf mit Deckel resumed<=0"                  0 frische "$WERK/log_frisch.txt" 1 0

# Der KERNFALL: nichts gemessen, alles resumiert -- der Treiber sagt trotzdem
# Exit 0 (profile_run_entry.hpp:1203). Die Wache MUSS hier rot werden.
R_OK=$(wuerfel 9)
cat > "$WERK/log_resume.txt" <<EOF
RUN_PROFILE fertig: basis_rows=$R_OK sota_rows=0 measured=0 resumed=$R_OK provisioned=0 csv_ok=1
EOF
echo "  (gewuerfelt: measured=0, resumed=$R_OK -- der Stellvertreter-Fall)"
fall "F3  NUR resumiert (measured=0, resumed=$R_OK) ist ROT"    1 frische "$WERK/log_resume.txt" 1

# Gemessen, aber ueber dem Resume-Deckel.
cat > "$WERK/log_mix.txt" <<EOF
RUN_PROFILE fertig: measured=$M_OK resumed=$R_OK provisioned=1 csv_ok=1
EOF
fall "F4  measured ok, aber resumed=$R_OK > Deckel 0 ist ROT"   1 frische "$WERK/log_mix.txt" 1 0
fall "F5  dieselbe Lage OHNE Deckel haelt"                      0 frische "$WERK/log_mix.txt" 1

# Zu wenig gemessen gegen eine hoehere Mindestzahl.
fall "F6  measured=$M_OK unter Mindestzahl $((M_OK + 1)) ist ROT" 1 frische "$WERK/log_frisch.txt" $((M_OK + 1))

# Unpruefbare Lagen -- rc=2, ausdruecklich nicht rc=0 und nicht rc=1.
echo "kein marker hier" > "$WERK/log_leer.txt"
fall "F7  Log ohne Marker ist UNPRUEFBAR (rc=2)"                2 frische "$WERK/log_leer.txt" 1
echo "RUN_PROFILE fertig: basis_rows=1 resumed=0 csv_ok=1" > "$WERK/log_ohne_m.txt"
fall "F8  Marker ohne Feld measured= ist UNPRUEFBAR (rc=2)"     2 frische "$WERK/log_ohne_m.txt" 1
fall "F9  fehlende Log-Datei ist UNPRUEFBAR (rc=2)"             2 frische "$WERK/gibtsnicht.txt" 1

# ==========================================================================
# TEIL B -- lastprofile
# ==========================================================================
echo ""
echo "--- lastprofile -----------------------------------------------------------"

LOADDIR="$WERK/load_profiles"
mkdir -p "$LOADDIR"
W_N=$(wuerfel 6)
IDS=''
_i=1
while [ "$_i" -le "$W_N" ]; do
    IDS="$IDS lp_koeder_$_i"
    : > "$LOADDIR/lp_koeder_$_i.xml"
    _i=$((_i + 1))
done
echo "  (gewuerfelt: $W_N Workload-Id(s) deklariert und als Datei angelegt)"

schreibe_profil() {   # $1 = Zieldatei, $2 = Inhalt des <workloads>-Elements
    cat > "$1" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<comdare_thesis_profile id="koeder" schema_version="1">
  <compile_dims>
    <workloads>$2</workloads>
  </compile_dims>
</comdare_thesis_profile>
EOF
}

schreibe_profil "$WERK/prof_voll.xml" "$IDS"
fall "F10 alle $W_N Ids aufloesbar haelt"                       0 lastprofile "$WERK/prof_voll.xml" "$LOADDIR"

# EINE gewuerfelte Id fehlt im Verzeichnis.
FEHLT=$(wuerfel "$W_N")
mv "$LOADDIR/lp_koeder_$FEHLT.xml" "$WERK/beiseite.xml"
echo "  (gewuerfelt: lp_koeder_$FEHLT wird aus dem Verzeichnis entfernt)"
fall "F11 fehlende Id lp_koeder_$FEHLT ist ROT"                 1 lastprofile "$WERK/prof_voll.xml" "$LOADDIR"
mv "$WERK/beiseite.xml" "$LOADDIR/lp_koeder_$FEHLT.xml"

schreibe_profil "$WERK/prof_leer.xml" ""
fall "F12 leeres <workloads> ist ROT (Achse 2 still leer)"      1 lastprofile "$WERK/prof_leer.xml" "$LOADDIR"

cat > "$WERK/prof_ohne.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<comdare_thesis_profile id="koeder" schema_version="1">
</comdare_thesis_profile>
EOF
fall "F13 Profil ohne <workloads> ist UNPRUEFBAR (rc=2)"        2 lastprofile "$WERK/prof_ohne.xml" "$LOADDIR"

cat > "$WERK/prof_mehrzeilig.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<comdare_thesis_profile id="koeder" schema_version="1">
  <compile_dims>
    <workloads>
      lp_koeder_1
    </workloads>
  </compile_dims>
</comdare_thesis_profile>
EOF
fall "F14 mehrzeiliges <workloads> ist UNPRUEFBAR (rc=2)"       2 lastprofile "$WERK/prof_mehrzeilig.xml" "$LOADDIR"
fall "F15 fehlendes Lastprofil-Verzeichnis ist UNPRUEFBAR"      2 lastprofile "$WERK/prof_voll.xml" "$WERK/gibtsnicht"

# ==========================================================================
# TEIL C -- Registrierung (T-7): wird die Wache ueberhaupt gerufen?
# ==========================================================================
echo ""
echo "--- Registrierung ---------------------------------------------------------"
N_FAELLE=$((N_FAELLE + 1))
if [ ! -f "$YAML" ]; then
    echo "  [ROT ]  F16 .gitlab-ci.yml nicht gefunden unter $YAML"
    N_RISSE=$((N_RISSE + 1))
else
    N_AUFRUFE=$(grep -cF 'ci/durchstich_wache.sh' "$YAML" || true)
    echo "  Aufrufe von ci/durchstich_wache.sh in .gitlab-ci.yml: $N_AUFRUFE"
    if [ "$N_AUFRUFE" -ge 2 ]; then
        echo "  [ OK ]  F16 die Wache ist im CI registriert ($N_AUFRUFE Aufrufe, mindestens 2 erwartet)"
    else
        echo "  [ROT ]  F16 die Wache ist NICHT ausreichend registriert ($N_AUFRUFE von mindestens 2)"
        echo "        Eine Wache, die niemand ruft, ist Dekoration."
        N_RISSE=$((N_RISSE + 1))
    fi
fi

# ==========================================================================
echo ""
echo "============================================================================="
echo "NENNER: $N_FAELLE Faelle gefahren, $N_RISSE gerissen."
echo "============================================================================="
if [ "$N_RISSE" -ne 0 ]; then
    echo "BISSPROBE ROT: $N_RISSE von $N_FAELLE Faellen gerissen." >&2
    exit 1
fi
echo "BISSPROBE GRUEN: alle $N_FAELLE Faelle gehalten."

# --------------------------------------------------------------------------
# --selbstbiss: der Beweis, dass die Probe ueberhaupt beisst (T-1).
# --------------------------------------------------------------------------
[ "$MODUS" = "--selbstbiss" ] || exit 0

echo ""
echo "============================================================================="
echo "SELBSTBISS: Wegwerf-Mutanten der Wache -- die Probe MUSS an ihnen rot werden."
echo "============================================================================="

ORIG_ZEILEN=$(awk 'END{print NR}' "$WACHE")
N_MUT=0
N_MUT_GEBISSEN=0

# Entfernt das k-te Vorkommen einer Zeile, die exakt aus Blanks + 'exit 1'
# besteht. k wird als awk-Variable uebergeben (kein eingebetteter Shell-Wert).
mutiere() {   # $1 = Ziel, $2 = k
    awk -v k="$2" '
        /^[ \t]*exit 1$/ { n++; if (n == k) next }
        { print }
    ' "$WACHE" > "$1"
}

selbstbiss_fall() {   # $1 = Kurzname, $2 = k
    N_MUT=$((N_MUT + 1))
    _m="$WERK/mutant_$2.sh"
    mutiere "$_m" "$2"
    _mz=$(awk 'END{print NR}' "$_m")
    _diff=$((ORIG_ZEILEN - _mz))
    if [ "$_diff" -ne 1 ]; then
        echo "  [ABBRUCH] Mutation '$1' griff NICHT: Zeilendifferenz $_diff, erwartet 1." >&2
        exit 2
    fi
    echo ""
    echo "  --- Mutant '$1' ($ORIG_ZEILEN -> $_mz Zeilen, 1 entfernt) ---"
    _log="$WERK/mutlog_$2.txt"
    set +e
    COMDARE_WACHE="$_m" sh "$SELBST" > "$_log" 2>&1
    _rc=$?
    set -e
    if [ "$_rc" -eq 0 ]; then
        echo "  [ROT ]  Mutant '$1' UEBERLEBT die Probe (rc=0) -- die Probe beisst hier nicht."
        sed 's/^/          | /' "$_log"
    else
        N_MUT_GEBISSEN=$((N_MUT_GEBISSEN + 1))
        echo "  [ OK ]  Mutant '$1' wird gefangen (Probe rc=$_rc). Literale Ausgabe:"
        awk '/^  \[ROT \]|^        RISS:|^NENNER:|^BISSPROBE/' "$_log" | sed 's/^/          | /'
    fi
}

# Die vier exit-1-Zweige der Wache, jeder einzeln beobachtbar gemacht:
#   k=1 frische / measured unter Mindestzahl   -> toetbar durch F3 und F6
#   k=2 frische / resumed ueber Deckel         -> toetbar NUR durch F4
#   k=3 lastprofile / leeres <workloads>       -> toetbar NUR durch F12
#   k=4 lastprofile / Id nicht aufloesbar      -> toetbar NUR durch F11
selbstbiss_fall "M1  ohne 'exit 1' im Mindest-Zweig    (frische)"     1
selbstbiss_fall "M2  ohne 'exit 1' im Resume-Deckel    (frische)"     2
selbstbiss_fall "M3  ohne 'exit 1' im Leer-Zweig       (lastprofile)" 3
selbstbiss_fall "M4  ohne 'exit 1' im Fehlend-Zweig    (lastprofile)" 4

echo ""
echo "============================================================================="
echo "NENNER SELBSTBISS: $N_MUT Mutanten gefahren, $N_MUT_GEBISSEN gefangen."
echo "============================================================================="
if [ "$N_MUT_GEBISSEN" -ne "$N_MUT" ]; then
    echo "SELBSTBISS ROT: $((N_MUT - N_MUT_GEBISSEN)) von $N_MUT Mutanten ueberleben." >&2
    exit 1
fi
echo "SELBSTBISS GRUEN: alle $N_MUT Mutanten gefangen -- die Probe beisst."
exit 0
