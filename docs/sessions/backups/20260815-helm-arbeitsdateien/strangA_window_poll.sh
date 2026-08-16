#!/usr/bin/env bash
# STRANG A: Fenster-Poll — leer, wenn 0 running+pending Builds
set -u
export KUBECONFIG=/root/.kube/config
for i in $(seq 1 10); do
  N=$(kubectl exec -n databases gitlab-pg-2 -c postgres -- psql -U postgres -At -d gitlabhq_production \
      -c "SELECT count(*) FROM p_ci_builds WHERE status IN ('running','pending');")
  RC=$?
  TSNOW=$(date -u +%H:%M:%SZ)
  echo "[$TSNOW] builds_running_pending=$N rc=$RC"
  if [ "$RC" = "0" ] && [ "$N" = "0" ]; then echo "FENSTER LEER"; exit 0; fi
  sleep 45
done
echo "FENSTER NOCH BELEGT"
exit 3
