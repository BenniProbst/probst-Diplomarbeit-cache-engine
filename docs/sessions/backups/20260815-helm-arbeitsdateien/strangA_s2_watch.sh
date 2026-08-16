#!/usr/bin/env bash
# STRANG A / S2-Beobachtung: bis Cluster healthy mit Major 17
set -u
export KUBECONFIG=/root/.kube/config
for i in $(seq 1 32); do
  TSNOW=$(date -u +%H:%M:%SZ)
  PH=$(kubectl get cluster gitlab-pg -n databases -o jsonpath='{.status.phase}' 2>/dev/null)
  IMG=$(kubectl get cluster gitlab-pg -n databases -o jsonpath='{.status.pgDataImageInfo.image}' 2>/dev/null)
  MAJ=$(kubectl get cluster gitlab-pg -n databases -o jsonpath='{.status.pgDataImageInfo.majorVersion}' 2>/dev/null)
  RD=$(kubectl get cluster gitlab-pg -n databases -o jsonpath='{.status.readyInstances}' 2>/dev/null)
  PODS=$(kubectl get pods -n databases -l cnpg.io/cluster=gitlab-pg --no-headers 2>/dev/null | tr '\n' ';')
  JOBS=$(kubectl get jobs -n databases --no-headers 2>/dev/null | tr '\n' ';')
  echo "[$TSNOW] ready=$RD major=$MAJ phase=$PH"
  echo "        pods=$PODS jobs=$JOBS"
  if [ "$PH" = "Cluster in healthy state" ] && [ "$MAJ" = "17" ] && [ "$RD" = "2" ]; then
    echo "S2-SOLL ERREICHT"
    break
  fi
  sleep 15
done
echo "=== Endstand ==="
kubectl get cluster gitlab-pg -n databases
echo "IMG_STATUS=$IMG"
