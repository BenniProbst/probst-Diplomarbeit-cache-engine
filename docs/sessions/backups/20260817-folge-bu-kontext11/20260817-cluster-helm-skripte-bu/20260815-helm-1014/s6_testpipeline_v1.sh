#!/usr/bin/env bash
# s6_testpipeline_v1.sh -- HELM-10.1.4 S6: Test-Pipeline super (288) auf development, bis TERMINAL pollen
set -u
TS(){ date -u +%FT%TZ; }
H=/root/.gitlab-pat-header
BASE=https://gitlab.comdare.local/api/v4
echo "== TESTPIPELINE START $(TS) =="
R=$(curl -sk --max-time 15 -X POST -H @$H "$BASE/projects/288/pipeline?ref=development")
ID=$(echo "$R" | jq -r '.id // empty')
if [ -z "$ID" ]; then echo "START_FEHLER: $(echo "$R" | head -c 400)"; exit 4; fi
echo "pipeline_id=$ID web_url=$(echo "$R" | jq -r .web_url) status=$(echo "$R" | jq -r .status)"
DEADLINE=$(( $(date +%s) + 1500 ))
while :; do
  S=$(curl -sk --max-time 15 -H @$H "$BASE/projects/288/pipelines/$ID" | jq -r '.status // "api_fehler"')
  echo "$(TS) status=$S"
  case "$S" in
    success|failed|canceled|skipped) echo "TERMINAL=$S"; break ;;
  esac
  [ "$(date +%s)" -ge "$DEADLINE" ] && { echo "TIMEOUT_NICHT_TERMINAL"; break; }
  sleep 30
done
echo "--jobs der pipeline--"
curl -sk --max-time 15 -H @$H "$BASE/projects/288/pipelines/$ID/jobs?per_page=100" | jq -r '.[] | "job: \(.name) status=\(.status) dauer=\(.duration // 0 | floor)s runner=\(.runner.description // "-")"'
echo "== TESTPIPELINE ENDE $(TS) =="
