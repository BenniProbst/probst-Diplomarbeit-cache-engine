#!/usr/bin/env bash
# s2_warten_v1.sh -- HELM-10.1.4 S2: warten bis p_ci_builds leer + 15844 terminal (READ-ONLY, max 540s je Lauf)
set -u
export KUBECONFIG=/root/.kube/config
TS(){ date -u +%FT%TZ; }
PRIMARY=$(kubectl get cluster gitlab-pg -n databases -o jsonpath='{.status.currentPrimary}')
PSQL(){ kubectl exec -n databases "$PRIMARY" -c postgres -- psql -U postgres -d gitlabhq_production -tAc "$1"; }
DEADLINE=$(( $(date +%s) + 540 ))
while :; do
  N=$(PSQL "select count(*) from p_ci_builds where status in ('running','pending');")
  P=$(PSQL "select status from p_ci_pipelines where id=15844;")
  echo "$(TS) builds_running_pending=$N p15844=$P"
  if [ "$N" = "0" ] && [ "$P" != "running" ] && [ "$P" != "pending" ] && [ "$P" != "created" ]; then
    echo "FENSTER_FREI $(TS)"; exit 0
  fi
  if [ "$(date +%s)" -ge "$DEADLINE" ]; then echo "NOCH_NICHT_FREI $(TS)"; exit 2; fi
  sleep 30
done
