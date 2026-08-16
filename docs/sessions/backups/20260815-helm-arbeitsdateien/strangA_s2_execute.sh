#!/usr/bin/env bash
# STRANG A / S2-AUSFUEHRUNG: Guard (Fenster 0, Primary, healthy) -> Patch 17.11 + serverName v17
set -u
export KUBECONFIG=/root/.kube/config

N=$(kubectl exec -n databases gitlab-pg-2 -c postgres -- psql -U postgres -At -d gitlabhq_production \
    -c "SELECT count(*) FROM p_ci_builds WHERE status IN ('running','pending');")
RCN=$?
echo "GUARD builds_running_pending=$N rc=$RCN"
if [ "$RCN" != "0" ] || [ "$N" != "0" ]; then echo "ABBRUCH: Fenster nicht leer"; exit 91; fi

CP=$(kubectl get cluster gitlab-pg -n databases -o jsonpath='{.status.currentPrimary}')
PH=$(kubectl get cluster gitlab-pg -n databases -o jsonpath='{.status.phase}')
echo "GUARD currentPrimary=$CP phase=$PH"
if [ "$CP" != "gitlab-pg-2" ]; then echo "ABBRUCH: Primary nicht gitlab-pg-2"; exit 92; fi
if [ "$PH" != "Cluster in healthy state" ]; then echo "ABBRUCH: Cluster nicht healthy"; exit 93; fi

echo "=== PATCH: imageName 17.11 + plugin serverName gitlab-pg-v17 (atomar) ==="
kubectl patch cluster gitlab-pg -n databases --type merge -p '{
  "spec": {
    "imageName": "ghcr.io/cloudnative-pg/postgresql:17.11-standard-bookworm",
    "plugins": [
      {
        "enabled": true,
        "isWALArchiver": true,
        "name": "barman-cloud.cloudnative-pg.io",
        "parameters": {
          "barmanObjectName": "gitlab-pg-store",
          "serverName": "gitlab-pg-v17"
        }
      }
    ]
  }
}'
echo "RC_PATCH=$?"
date -u +%Y%m%dT%H%M%SZ
kubectl get cluster gitlab-pg -n databases
