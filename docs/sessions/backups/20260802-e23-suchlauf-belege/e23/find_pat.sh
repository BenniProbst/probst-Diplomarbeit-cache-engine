#!/usr/bin/env bash
# E-23 PAT-Doktrin: Blind-Extraktion + Rueckwaerts-Test bis HTTP 200.
# Token wird NIE ausgegeben/geloggt. Nur 0600-curl-config (-K).
set -u
WD=/tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad/e23
CA=/home/comdare/Projekte/Cluster/keys/gitlab-ca-ROOTCA-20260621.crt
API=https://gitlab.comdare.local/api/v4

mapfile -t CANDS < <(grep -hoE 'glpat-[A-Za-z0-9._-]{15,}' \
  /home/comdare/Projekte/Cluster/keys/CREDENTIALS-VAULT-DEV.md \
  /home/comdare/Projekte/Cluster/keys/CREDENTIALS-VAULT-PROD.md | awk '!seen[$0]++')

N=${#CANDS[@]}
echo "KANDIDATEN_GESAMT=$N"
[ "$N" -eq 0 ] && { echo "KEINE_KANDIDATEN"; exit 2; }

CFG="$WD/curlrc"
for ((i=N-1; i>=0; i--)); do
  pos_from_end=$((N-i))
  umask 077
  printf 'header = "PRIVATE-TOKEN: %s"\n' "${CANDS[$i]}" > "$CFG"
  chmod 600 "$CFG"
  code=$(curl -s -o "$WD/user.json" -w '%{http_code}' --max-time 25 \
    --cacert "$CA" -K "$CFG" "$API/user")
  echo "TEST pos_from_end=$pos_from_end HTTP=$code"
  if [ "$code" = "200" ]; then
    echo "TREFFER_POSITION_VON_HINTEN=$pos_from_end"
    exit 0
  fi
done
rm -f "$CFG"
echo "KEIN_TREFFER"
exit 3
