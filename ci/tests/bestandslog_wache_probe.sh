#!/bin/sh
# shellcheck shell=sh
# =============================================================================
#  PROBE fuer die BESTANDSLOG-WACHE (ci/bestandslog_wache.sh)      (2026-08-09)
# =============================================================================
#
# SELBSTCHECK -- was diese Datei zusichert, und was NICHT:
#   ZUSICHERT: dass die Wache in den acht unten aufgefuehrten Faellen genau das
#     Verdikt faellt, das sie faellen muss -- insbesondere, dass sie ROT wird,
#     wenn das Wort "bestandslog" zwar vorkommt, die AUSSAGE aber fehlt oder
#     falsch ist. Zusaetzlich (--selbstbiss), dass sie an drei Wegwerf-Mutanten
#     ihrer selbst NICHT mehr gruen bleibt.
#   ZUSICHERT NICHT: dass die CI-Verdrahtung die Wache tatsaechlich aufruft, und
#     nicht, dass ein echter Lauf ein Bestandslog-Dokument erzeugt. Das erste
#     belegt der !reference-Einbau, das zweite nur ein object_stat am Store.
#
# WARUM ES DIESE PROBE GIBT (T-7, am eigenen Haus belegt):
# "Ein Test, der in keinem CI-Job faehrt, ist nicht gebaut." Die Wache selbst
# laeuft nur in gegateten Jobs (planer:delegate / measure:*), die im Alltag gar
# nicht starten. Ohne diese Probe waere sie monatelang ungeprueft -- genau der
# Fehler, der in diesem Repo schon einmal passiert ist: eine Wache wurde gebaut
# und nirgends aufgerufen. Diese Probe laeuft in JEDER Pipeline.
#
# K13 -- DER KOEDER MUSS ERST BEISSEN:
# Alle Koeder werden bei JEDEM Lauf frisch gewuerfelt
# (head -c9 /dev/urandom | base32 | tr A-Z a-z). Kein Wert stammt aus einer
# Doku, aus einem alten Lauf oder aus der Paketbeschreibung -- ein Koeder, der
# irgendwo allowgelistet sein koennte, beweist nichts. Zu jedem Rot-Fall gehoert
# die Gegenprobe: derselbe Koeder korrekt eingesetzt -> wieder gruen. Ein
# Koeder, der IMMER beisst, ist so wertlos wie einer, der nie beisst.
#
# AUFRUF:  sh ci/tests/bestandslog_wache_probe.sh [--selbstbiss]
# EXIT:    0 = alle Faelle wie erwartet | 1 = mindestens ein Fall falsch
#
# POSIX-sh, ASCII-only, kein Python.
# =============================================================================

set -eu

WACHE="${WACHE_UNTER_TEST:-ci/bestandslog_wache.sh}"
SELBSTBISS=0
[ "${1:-}" = "--selbstbiss" ] && SELBSTBISS=1

test -f "$WACHE" || { echo "ABBRUCH: $WACHE nicht gefunden (cwd=$(pwd))" >&2; exit 1; }

ARBEIT=$(mktemp -d) || exit 1
trap 'rm -rf "$ARBEIT"' EXIT INT TERM

FEHLER=0
N_FALL=0

wurf() { head -c9 /dev/urandom | base32 | tr A-Z a-z | tr -d '='; }

# fall <name> <erwarteter_rc> <logdatei> <doc_key> <owner> [<maschine>]
fall() {
    _name="$1"; _erw="$2"; _log="$3"; _key="$4"; _own="$5"; _mas="${6:-}"
    N_FALL=$((N_FALL + 1))
    if sh "$WACHE" "$_log" "$_key" "$_own" "$_mas" > "$ARBEIT/out.$N_FALL" 2>&1; then
        _ist=0
    else
        _ist=$?
    fi
    if [ "$_ist" -eq "$_erw" ]; then
        echo "  OK    [$_name] rc=$_ist (erwartet $_erw)"
    else
        echo "  FALSCH[$_name] rc=$_ist, erwartet $_erw" >&2
        echo "  ----- Ausgabe der Wache -----" >&2
        sed 's/^/    /' "$ARBEIT/out.$N_FALL" >&2
        FEHLER=$((FEHLER + 1))
    fi
}

echo "============================================================================="
echo "PROBE BESTANDSLOG-WACHE   ($WACHE)"
echo "============================================================================="

# --- die frisch gewuerfelten Koeder dieses Laufs ---------------------------
K_KEY="bestandslog/probe-$(wurf).xml"
K_OWN="$(wurf)@$(wurf)"
K_MAS="$(wurf)"
K_FREMD_KEY="bestandslog/probe-$(wurf).xml"
K_FREMD_OWN="$(wurf)@$(wurf)"
echo "KOEDER dieses Laufs (frisch gewuerfelt, nicht aus einer Doku):"
echo "  doc_key      = $K_KEY"
echo "  owner        = $K_OWN"
echo "  maschine     = $K_MAS"
echo "  fremd-key    = $K_FREMD_KEY"
echo "  fremd-owner  = $K_FREMD_OWN"
echo "-----------------------------------------------------------------------------"

# --- (1) der Treiber meldet korrekt -> GRUEN ------------------------------
cat > "$ARBEIT/treiber_gut.log" <<EOF
== Toolchain ==
[bestandslog] aktiv: doc_key=$K_KEY maschine=$K_MAS key_of=.fingerprint-Sidecar (#46b I1/I2) owner=$K_OWN
[E4] Storage: minio=1 drop=0
EOF
fall "treiber-gut" 0 "$ARBEIT/treiber_gut.log" "$K_KEY" "$K_OWN" "$K_MAS"

# --- (2) der Planer meldet korrekt (id=<owner>/planer) -> GRUEN -----------
cat > "$ARBEIT/planer_gut.log" <<EOF
[bestandslog] planer_block aktiv: doc_key=$K_KEY id=$K_OWN/planer maschine=$K_MAS
EOF
fall "planer-gut" 0 "$ARBEIT/planer_gut.log" "$K_KEY" "$K_OWN" "$K_MAS"

# --- (3) gar keine Bestandslog-Zeile -> ROT -------------------------------
cat > "$ARBEIT/stumm.log" <<EOF
== Toolchain ==
cmake version 3.28.3
== W10-B: super delegiert die Anwender-XML an die CE ==
EOF
fall "stumm-kein-marker" 1 "$ARBEIT/stumm.log" "$K_KEY" "$K_OWN" "$K_MAS"

# --- (4) NUR die WARNUNG (Opt-in an, Ebene B fehlt) -> ROT ----------------
# Das ist der teuerste stille Fall: das Wort "bestandslog" steht da, der doc_key
# steht sogar da -- gebunden wurde trotzdem nichts.
cat > "$ARBEIT/nur_warnung.log" <<EOF
[bestandslog] WARNUNG fehlerklasse=lager_ebene_fehlt: COMDARE_BESTANDSLOG=true, aber Ebene B (minio) ist nicht konfiguriert (measure-drop=0) -- Bestandslog bleibt AUS, Bau unveraendert.
EOF
fall "nur-warnung" 1 "$ARBEIT/nur_warnung.log" "$K_KEY" "$K_OWN" "$K_MAS"

# --- (4b) WARNUNG, die die WERTE MITFUEHRT -> ROT -------------------------
# Der Fall, der die Forderung nach dem Feld "aktiv:" ueberhaupt traegt. Heute
# nennt keine WARNUNG ihren doc_key -- aber es ist die naheliegendste
# Verbesserung der Welt, die Diagnose-Zeile um die beabsichtigten Werte zu
# ergaenzen. Genau dann faellt eine Wache um, die nur "Marker + richtige Werte"
# prueft: sie wuerde eine Zeile gruen nennen, die woertlich sagt, dass das
# Lager AUS bleibt. Dieser Fall ist NICHT theoretisch entstanden -- der
# Selbstbiss-Mutant M3 blieb ohne ihn unentdeckt.
cat > "$ARBEIT/warnung_mit_werten.log" <<EOF
[bestandslog] WARNUNG fehlerklasse=lager_ebene_fehlt: doc_key=$K_KEY owner=$K_OWN maschine=$K_MAS -- Ebene B fehlt, Bestandslog bleibt AUS.
EOF
fall "warnung-mit-werten" 1 "$ARBEIT/warnung_mit_werten.log" "$K_KEY" "$K_OWN" "$K_MAS"

# --- (5) das Wort steht NUR in einem Kommentar -> ROT ---------------------
# "Ein Grep auf ein Wort, das auch in einem Kommentar vorkommt, ist keine Wache."
cat > "$ARBEIT/kommentar.log" <<EOF
# COMDARE_BESTANDSLOG aktiv: doc_key=$K_KEY -- so saehe die Zeile aus
echo "bestandslog waere hier scharf: doc_key=$K_KEY owner=$K_OWN"
EOF
fall "nur-kommentar" 1 "$ARBEIT/kommentar.log" "$K_KEY" "$K_OWN" "$K_MAS"

# --- (6) aktiv-Zeile mit FREMDEM doc_key -> ROT ---------------------------
cat > "$ARBEIT/fremd_key.log" <<EOF
[bestandslog] aktiv: doc_key=$K_FREMD_KEY maschine=$K_MAS key_of=.fingerprint-Sidecar (#46b I1/I2) owner=$K_OWN
EOF
fall "fremder-doc-key" 1 "$ARBEIT/fremd_key.log" "$K_KEY" "$K_OWN" "$K_MAS"

# --- (7) aktiv-Zeile mit FREMDEM owner -> ROT -----------------------------
# Der teuerste Drift ueberhaupt: der Lauf reserviert unter einer anderen
# Identitaet, als der Job glaubt -- die Takeover-Regel greift dann ins Leere.
cat > "$ARBEIT/fremd_own.log" <<EOF
[bestandslog] aktiv: doc_key=$K_KEY maschine=$K_MAS key_of=.fingerprint-Sidecar (#46b I1/I2) owner=$K_FREMD_OWN
EOF
fall "fremder-owner" 1 "$ARBEIT/fremd_own.log" "$K_KEY" "$K_OWN" "$K_MAS"

# --- (8) PRAEFIX-KOLLISION: doc_key ist ein echtes Praefix -> ROT ---------
# Ein Teilzeichenketten-Vergleich wuerde hier GRUEN sagen. Genau dafuer
# vergleicht die Wache ganze Felder.
cat > "$ARBEIT/praefix.log" <<EOF
[bestandslog] aktiv: doc_key=$K_KEY.alt maschine=$K_MAS key_of=.fingerprint-Sidecar (#46b I1/I2) owner=$K_OWN
EOF
fall "praefix-kollision" 1 "$ARBEIT/praefix.log" "$K_KEY" "$K_OWN" "$K_MAS"

# --- (9) GEGENPROBE: derselbe Koeder korrekt eingesetzt -> wieder GRUEN ---
# Ohne diesen Fall waere nicht gezeigt, dass die Roten oben am WERT liegen und
# nicht daran, dass die Wache grundsaetzlich beisst.
cat > "$ARBEIT/gegenprobe.log" <<EOF
[bestandslog] aktiv: doc_key=$K_KEY maschine=$K_MAS key_of=.fingerprint-Sidecar (#46b I1/I2) owner=$K_OWN
EOF
fall "gegenprobe-wieder-gruen" 0 "$ARBEIT/gegenprobe.log" "$K_KEY" "$K_OWN" "$K_MAS"

# --- (10) fehlende Datei -> rc 2 (nicht pruefbar ist NICHT gruen) ---------
fall "fehlende-datei" 2 "$ARBEIT/gibt-es-nicht.log" "$K_KEY" "$K_OWN" "$K_MAS"

# =============================================================================
#  TEIL 2 -- die SCHARFSCHALTUNG selbst (ci/comdare_bestandslog_activation.sh).
#  Geprueft wird die owner_uuid-KONVENTION, die bis zum 09.08.2026 nur als
#  Kommentar existierte: CI: CI_JOB_ID@host, lokal: pid@host.
#
#  T-3 (Nenner fremd): der erwartete Hostname wird mit `uname -n` gebildet --
#  das Skript selbst benutzt `hostname`. Die Zahl, gegen die geprueft wird,
#  stammt damit nicht aus demselben Aufruf wie das Geprueft.
#  Uebersprungen im Mutanten-Lauf (dort geht es allein um die Wache).
# =============================================================================
if [ -z "${WACHE_UNTER_TEST:-}" ]; then
    AKT="ci/comdare_bestandslog_activation.sh"
    echo "-----------------------------------------------------------------------------"
    echo "TEIL 2: Scharfschaltung ($AKT)"
    if [ ! -f "$AKT" ]; then
        echo "  FALSCH[aktivierung] $AKT nicht gefunden." >&2
        FEHLER=$((FEHLER + 1))
    else
        HOST_FREMD=$(uname -n)

        # akt_fall <name> <erwartet> <ausdruck> -- <ausdruck> wird in einer frischen
        # Shell mit definierter Umgebung ausgewertet und liefert EINEN Wert.
        akt_fall() {
            _name="$1"; _erw="$2"; _ist="$3"
            N_FALL=$((N_FALL + 1))
            if [ "$_ist" = "$_erw" ]; then
                echo "  OK    [$_name] $_ist"
            else
                echo "  FALSCH[$_name] gelesen=[$_ist] erwartet=[$_erw]" >&2
                FEHLER=$((FEHLER + 1))
            fi
        }

        # (a) ohne Opt-in bleibt ALLES leer -- Byte-Neutralitaet des Vor-Zustands.
        A_LEER=$(env -u COMDARE_BESTANDSLOG -u COMDARE_STORAGE_CACHE -u CI_JOB_ID \
                     -u COMDARE_BESTANDSLOG_DOC_KEY -u COMDARE_BESTANDSLOG_OWNER_UUID \
                     -u COMDARE_BESTANDSLOG_MASCHINE \
                 sh -c ". $AKT >/dev/null 2>&1; printf '%s' \"\${COMDARE_BESTANDSLOG_OWNER_UUID:-LEER}\"")
        akt_fall "inert-setzt-nichts" "LEER" "$A_LEER"

        # (b) CI-Fall: owner = CI_JOB_ID@host. Die Job-Id ist ein frischer Koeder.
        K_JOB=$(head -c4 /dev/urandom | od -An -tu4 | tr -d ' \n')
        A_CI=$(env -u COMDARE_BESTANDSLOG -u COMDARE_BESTANDSLOG_DOC_KEY \
                   -u COMDARE_BESTANDSLOG_OWNER_UUID -u COMDARE_BESTANDSLOG_MASCHINE \
                   COMDARE_STORAGE_CACHE=true CI_JOB_ID="$K_JOB" \
               sh -c ". $AKT >/dev/null 2>&1; printf '%s' \"\$COMDARE_BESTANDSLOG_OWNER_UUID\"")
        akt_fall "ci-owner-ist-jobid-at-host" "${K_JOB}@${HOST_FREMD}" "$A_CI"

        # (c) lokal (kein CI_JOB_ID): owner = pid@host. Die pid ist die der
        #     gequellten Shell -- geprueft wird die FORM, die pid selbst kennt
        #     der Aufrufer nicht im Voraus.
        A_LOK=$(env -u CI_JOB_ID -u COMDARE_BESTANDSLOG_DOC_KEY \
                    -u COMDARE_BESTANDSLOG_OWNER_UUID -u COMDARE_BESTANDSLOG_MASCHINE \
                    COMDARE_BESTANDSLOG=true \
                sh -c ". $AKT >/dev/null 2>&1; printf '%s' \"\$COMDARE_BESTANDSLOG_OWNER_UUID\"" \
                | awk -v h="$HOST_FREMD" '{ n = index($0, "@"); pid = substr($0, 1, n - 1)
                    print (n > 1 && substr($0, n + 1) == h && pid ~ /^[0-9]+$/) ? "FORM-OK" : "FORM-FALSCH" }')
        akt_fall "lokal-owner-ist-pid-at-host" "FORM-OK" "$A_LOK"

        # (d) ein vorgegebener owner wird NIE ueberschrieben.
        K_VORGABE="$(wurf)@$(wurf)"
        A_VOR=$(env -u CI_JOB_ID COMDARE_BESTANDSLOG=true COMDARE_BESTANDSLOG_OWNER_UUID="$K_VORGABE" \
                sh -c ". $AKT >/dev/null 2>&1; printf '%s' \"\$COMDARE_BESTANDSLOG_OWNER_UUID\"")
        akt_fall "vorgabe-nicht-ueberschrieben" "$K_VORGABE" "$A_VOR"

        # (e) COMDARE_BESTANDSLOG=false schlaegt die Storage-Kopplung.
        A_AUS=$(env -u CI_JOB_ID -u COMDARE_BESTANDSLOG_OWNER_UUID \
                    COMDARE_STORAGE_CACHE=true COMDARE_BESTANDSLOG=false \
                sh -c ". $AKT >/dev/null 2>&1; printf '%s' \"\${COMDARE_BESTANDSLOG_OWNER_UUID:-LEER}\"")
        akt_fall "explizites-false-schlaegt-kopplung" "LEER" "$A_AUS"
    fi
fi

echo "-----------------------------------------------------------------------------"
echo "NENNER: $N_FALL Faelle geprueft, $FEHLER falsch."

# =============================================================================
#  --selbstbiss: drei Wegwerf-MUTANTEN der Wache. Die Probe MUSS an jedem rot
#  werden. Eine Probe, die nur am gesunden Objekt gruen ist, koennte immer
#  gruen sein.
# =============================================================================
if [ "$SELBSTBISS" -eq 1 ] && [ "$FEHLER" -eq 0 ]; then
    echo "-----------------------------------------------------------------------------"
    echo "SELBSTBISS: die Probe gegen drei Mutanten der Wache."
    MUT_FEHLER=0

    # M1: owner-Vergleich entfernt -> Fall (7) muesste durchrutschen.
    sed 's/if (g_owner != erw_owner)/if (0)/' "$WACHE" > "$ARBEIT/m1.sh"
    # M2: Feld-Gleichheit durch Teilzeichenketten-Suche ersetzt -> Fall (8) rutscht durch.
    sed 's/if (g_key   != erw_key)/if (index(g_key, erw_key) != 1)/' "$WACHE" > "$ARBEIT/m2.sh"
    # M3: jede [bestandslog]-Zeile gilt als aktiv -> Fall (4) rutscht durch.
    sed 's/if ($i == "aktiv:") { ist_aktiv = 1; break }/{ ist_aktiv = 1; break }/' "$WACHE" > "$ARBEIT/m3.sh"

    for M in m1 m2 m3; do
        if [ ! -s "$ARBEIT/$M.sh" ]; then
            echo "  FALSCH[$M] Mutant ist leer -- sed hat nicht gegriffen." >&2
            MUT_FEHLER=$((MUT_FEHLER + 1)); continue
        fi
        if cmp -s "$WACHE" "$ARBEIT/$M.sh"; then
            echo "  FALSCH[$M] Mutant ist mit dem Original identisch -- sed-Muster veraltet." >&2
            echo "            Ein Mutant, der nichts aendert, beweist nichts." >&2
            MUT_FEHLER=$((MUT_FEHLER + 1)); continue
        fi
        if WACHE_UNTER_TEST="$ARBEIT/$M.sh" sh "$0" > "$ARBEIT/$M.out" 2>&1; then
            echo "  FALSCH[$M] die Probe blieb GRUEN an einem defekten Mutanten." >&2
            echo "            Damit prueft sie die Eigenschaft nicht, die sie zu pruefen behauptet." >&2
            MUT_FEHLER=$((MUT_FEHLER + 1))
        else
            echo "  OK    [$M] Mutant erkannt (Probe wurde rot)."
        fi
    done

    if [ "$MUT_FEHLER" -gt 0 ]; then
        echo "SELBSTBISS FEHLGESCHLAGEN: $MUT_FEHLER von 3 Mutanten nicht erkannt." >&2
        FEHLER=$((FEHLER + MUT_FEHLER))
    else
        echo "SELBSTBISS OK: alle 3 Mutanten erkannt."
    fi
fi

echo "============================================================================="
if [ "$FEHLER" -gt 0 ]; then
    echo "PROBE FEHLGESCHLAGEN ($FEHLER Fehler)." >&2
    exit 1
fi
echo "PROBE OK."
exit 0
