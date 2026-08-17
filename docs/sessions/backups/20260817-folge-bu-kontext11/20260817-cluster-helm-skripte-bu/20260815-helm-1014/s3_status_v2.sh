#!/usr/bin/env bash
# s3_status_v2.sh -- HELM-10.1.4 S3: Status mit VOLL QUALIFIZIERTER CRD backups.postgresql.cnpg.io
# (v1-Falle: kubectl get backup ohne Gruppe traf eine andere Backup-CRD -> "No resources found")
set -u
export KUBECONFIG=/root/.kube/config
TS(){ date -u +%FT%TZ; }
echo "== S3-STATUS-v2 $(TS) =="
echo "--crds mit kind Backup--"
kubectl get crd | grep -i backup
echo "--cnpg-backups databases--"
kubectl get backups.postgresql.cnpg.io -n databases --sort-by=.metadata.creationTimestamp
echo "--status beider pre1014-CRs--"
for B in $(kubectl get backups.postgresql.cnpg.io -n databases -o name | grep pre1014); do
  echo "### $B"
  kubectl get "$B" -n databases -o jsonpath='phase={.status.phase} backupId={.status.backupId} serverName={.status.serverName} startedAt={.status.startedAt} stoppedAt={.status.stoppedAt} beginLSN={.status.beginLSN} endLSN={.status.endLSN} error={.status.error}'; echo
done
echo "--laufende skript-doppel auf pve1--"
ps aux | grep -E "gitlab-pg-pre1014|get backup" | grep -v grep || echo "kein doppel-prozess"
echo "--kontext: comdare-app-pg (FREMDE Flaeche, nur Beobachtung)--"
kubectl get cluster comdare-app-pg -n comdare-business 2>/dev/null
kubectl get pods -n comdare-business 2>/dev/null | head -8
echo "== S3-STATUS-v2 ENDE $(TS) =="
