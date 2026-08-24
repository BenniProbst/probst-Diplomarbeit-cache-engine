#!/bin/bash
# Z12-NEUFAHRT-FABLE: Gates 6/6 + gitleaks-Zusatzkontrolle ueber den
# Landungs-Bereich 3841d717..943c70ee (origin==HEAD => Basis EXPLIZIT).
# Koeder wird zur LAUFZEIT komponiert, steht NIRGENDS als Literal (Doktrin).
# ASCII-only. Schreibt NUR nach $OUT.
set -u
CE=/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine
OUT=/home/comdare/backups-workflow/20260822-lande-zug/Z12/neufahrt-fable
BASIS=3841d7175086d5141fb28d6a401ae1ab4d137b30
SPITZE=943c70ee52796da8dede7ace1bf3a370a0994d16
cd "$CE" || exit 9
echo "== GATES 6/6 START $(date -u +%FT%TZ) HEAD=$(git rev-parse --short HEAD) =="
COMDARE_PRE_PUSH_BUILD_DIR=build-l1 sh scripts/pre_push_lande_gates.sh "$BASIS" "$SPITZE" > "$OUT/gates-6von6-neufahrt.log" 2>&1
GRC=$?
echo "GATES_RC=$GRC"
grep -E "^\[[0-9]/6\]|PRE-PUSH-LANDE-GATES" "$OUT/gates-6von6-neufahrt.log" | tail -10

echo "== GITLEAKS-ZUSATZ (Owner: Push-Bereich mit -m + Nenner) =="
GL=$(command -v gitleaks || echo "$HOME/.local/bin/gitleaks")
echo "gitleaks-binary: $GL ($($GL version 2>/dev/null | head -1))"
# Koeder zur Laufzeit: Praefix aus Teilen, Rumpf 20 Zeichen
P1=gl; P2=pat; RUMPF=$(printf 'Zx9q%.0s' 1 2 3 4 5)
KOEDER="${P1}${P2}-${RUMPF}"
echo "KOEDER-LAENGE=${#KOEDER} (SOLL 26 = 6 Praefix + 20 Rumpf)"
if [ "${#KOEDER}" -ne 26 ]; then echo "ABBRUCH: Koeder-Laenge falsch"; exit 8; fi
printf 'probe: %s\n' "$KOEDER" | "$GL" stdin --config "$CE/.gitleaks.toml" --no-banner --exit-code 1 > "$OUT/gitleaks-koeder-neufahrt.log" 2>&1
KRC=$?
echo "KOEDER_RC=$KRC (SOLL 1 = beisst)"
if [ "$KRC" -ne 1 ]; then echo "ABBRUCH: Selbstbiss fehlgeschlagen, Echt-Scan wertlos"; exit 8; fi
"$GL" git --log-opts="-m $BASIS..$SPITZE" --config "$CE/.gitleaks.toml" --no-banner "$CE" > "$OUT/gitleaks-git-m-neufahrt.log" 2>&1
ERC=$?
echo "ECHT_RC=$ERC (SOLL 0)"
grep -E "commits scanned|leaks found|no leaks" "$OUT/gitleaks-git-m-neufahrt.log" | tail -3
echo "NENNER: rev-list gesamt=$(git rev-list --count $BASIS..$SPITZE) no-merges=$(git rev-list --count --no-merges $BASIS..$SPITZE)"
echo "== ENDE $(date -u +%FT%TZ) =="
[ "$GRC" -eq 0 ] && [ "$ERC" -eq 0 ] && exit 0 || exit 1
