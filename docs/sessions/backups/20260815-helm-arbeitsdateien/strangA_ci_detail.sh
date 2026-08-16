#!/usr/bin/env bash
# STRANG A: Detail der 4 running-Builds — echte Jobs oder Zombies?
set -u
export KUBECONFIG=/root/.kube/config
kubectl exec -n databases gitlab-pg-2 -c postgres -- psql -U postgres -d gitlabhq_production -At -F '|' \
  -c "SELECT b.id, b.project_id, b.runner_id, b.name, b.started_at, b.updated_at, now()-b.updated_at AS age_updated FROM p_ci_builds b WHERE b.status='running' ORDER BY b.updated_at;"
echo "RC_DETAIL=$?"
kubectl exec -n databases gitlab-pg-2 -c postgres -- psql -U postgres -d gitlabhq_production -At -F '|' \
  -c "SELECT id, description, contacted_at, now()-contacted_at FROM ci_runners ORDER BY id;"
echo "RC_RUNNERS=$?"
kubectl exec -n databases gitlab-pg-2 -c postgres -- psql -U postgres -d gitlabhq_production -At -F '|' \
  -c "SELECT p.id, p.project_id, p.status, p.created_at, p.updated_at FROM p_ci_pipelines p WHERE p.status IN ('running','pending') ORDER BY p.updated_at;"
echo "RC_PIPE=$?"
