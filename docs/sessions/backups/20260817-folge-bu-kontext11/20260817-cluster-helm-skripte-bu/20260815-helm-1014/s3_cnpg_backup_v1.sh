#!/usr/bin/env bash
# s3_cnpg_backup_v1.sh -- HELM-10.1.4 S3: frisches CNPG-Basisbackup (Rollback-Punkt), Pfad gitlab-pg-v17
# Muster: /root/strangA-backups/backup_post17.yaml (method plugin, barman-cloud). Additiv, loescht nichts.
set -u
export KUBECONFIG=/root/.kube/config
TS(){ date -u +%FT%TZ; }
NAME="gitlab-pg-pre1014-$(date -u +%Y%m%dt%H%M%Sz)"
echo "== S3 START $(TS) name=$NAME =="
cat > "/root/strangA-backups/backup_pre1014_${NAME##*-}.yaml" <<EOF
apiVersion: postgresql.cnpg.io/v1
kind: Backup
metadata:
  name: $NAME
  namespace: databases
spec:
  cluster:
    name: gitlab-pg
  method: plugin
  pluginConfiguration:
    name: barman-cloud.cloudnative-pg.io
EOF
kubectl apply -f "/root/strangA-backups/backup_pre1014_${NAME##*-}.yaml"
echo "rc_apply=$?"
for i in $(seq 1 90); do
  PH=$(kubectl get backup "$NAME" -n databases -o jsonpath='{.status.phase}' 2>/dev/null)
  echo "$(TS) phase=${PH:-<leer>}"
  [ "$PH" = "completed" ] && break
  [ "$PH" = "failed" ] && break
  sleep 10
done
echo "--status-detail--"
kubectl get backup "$NAME" -n databases -o jsonpath='phase={.status.phase} backupId={.status.backupId} serverName={.status.serverName} begunAt={.status.startedAt} stoppedAt={.status.stoppedAt} beginLSN={.status.beginLSN} endLSN={.status.endLSN}'; echo
kubectl get backup -n databases --sort-by=.metadata.creationTimestamp | tail -3
echo "== S3 ENDE $(TS) =="
