#!/usr/bin/env bash
# STRANG A / S2-Nachweise + Nacharbeiten
set -u
export KUBECONFIG=/root/.kube/config
TS=$(date -u +%Y%m%dT%H%M%SZ)

echo "=== server_version literal ==="
kubectl exec -n databases gitlab-pg-2 -c postgres -- psql -U postgres -At -c "SHOW server_version;"
echo "RC_VER=$?"

echo "=== Replikation ==="
kubectl exec -n databases gitlab-pg-2 -c postgres -- psql -U postgres -At -c "SELECT application_name, state, sync_state, replay_lag FROM pg_stat_replication;"
echo "RC_REPL=$?"

echo "=== ANALYZE (vacuumdb --all --analyze-in-stages) ==="
kubectl exec -n databases gitlab-pg-2 -c postgres -- vacuumdb -U postgres --all --analyze-in-stages > /tmp/strangA_analyze.log 2>&1
echo "RC_ANALYZE=$?"
tail -4 /tmp/strangA_analyze.log

echo "=== Conditions (ContinuousArchiving, LastBackup) ==="
kubectl get cluster gitlab-pg -n databases -o jsonpath='{range .status.conditions[*]}{.type}={.status} reason={.reason}{"\n"}{end}'
echo "RC_COND=$?"

echo "=== Post-17-Basisbackup (neuer serverName-Pfad) ==="
cat > /root/strangA-backups/backup_post17.yaml <<EOF
apiVersion: postgresql.cnpg.io/v1
kind: Backup
metadata:
  name: gitlab-pg-post17-${TS,,}
  namespace: databases
spec:
  cluster:
    name: gitlab-pg
  method: plugin
  pluginConfiguration:
    name: barman-cloud.cloudnative-pg.io
EOF
kubectl apply -f /root/strangA-backups/backup_post17.yaml
echo "RC_BKCR=$?"
for i in $(seq 1 40); do
  PHB=$(kubectl get backups.postgresql.cnpg.io "gitlab-pg-post17-${TS,,}" -n databases -o jsonpath='{.status.phase}')
  echo "[$i] backup phase=$PHB"
  [ "$PHB" = "completed" ] && break
  [ "$PHB" = "failed" ] && break
  sleep 10
done

echo "=== ObjectStore serverRecoveryWindow (neuer Key?) ==="
kubectl get objectstores.barmancloud.cnpg.io gitlab-pg-store -n databases -o jsonpath='{.status.serverRecoveryWindow}'
echo
echo "RC_OSW=$?"

echo "=== ScheduledBackup reaktivieren ==="
kubectl patch scheduledbackup gitlab-pg-daily -n databases --type merge -p '{"spec":{"suspend":false}}'
echo "RC_UNSUSP=$?"
kubectl get scheduledbackup gitlab-pg-daily -n databases -o jsonpath='{.spec.suspend}'
echo

echo "=== GitLab-Readiness-Probe (workhorse /-/readiness) ==="
TB=$(kubectl get pods -n gitlab -l app=toolbox -o jsonpath='{.items[0].metadata.name}')
echo "toolbox=$TB"
kubectl exec -n gitlab "$TB" -c toolbox -- curl -s -o /tmp/ready.json -w "HTTP=%{http_code}\n" "http://gitlab-webservice-default.gitlab.svc:8181/-/readiness?all=1"
echo "RC_CURL=$?"
kubectl exec -n gitlab "$TB" -c toolbox -- cat /tmp/ready.json
echo
echo "=== GitLab webservice/sidekiq Pods ==="
kubectl get pods -n gitlab --no-headers | tr -s ' '
echo "RC_GLPODS=$?"
