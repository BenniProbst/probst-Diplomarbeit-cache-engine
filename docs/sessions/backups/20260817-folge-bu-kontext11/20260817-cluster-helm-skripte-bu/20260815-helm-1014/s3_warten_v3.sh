#!/usr/bin/env bash
# s3_warten_v3.sh -- HELM-10.1.4 S3: beide pre1014-Backups terminal abwarten (voll qualifizierte CRD)
set -u
export KUBECONFIG=/root/.kube/config
TS(){ date -u +%FT%TZ; }
DEADLINE=$(( $(date +%s) + 480 ))
while :; do
  LINE=$(kubectl get backups.postgresql.cnpg.io -n databases -o jsonpath='{range .items[*]}{.metadata.name}={.status.phase} {end}' | tr ' ' '\n' | grep pre1014 | tr '\n' ' ')
  echo "$(TS) $LINE"
  case "$LINE" in
    *=started*|*=pending*|*=running*|*=walArchivingFailing*) : ;;
    *) echo "TERMINAL $(TS)"; break ;;
  esac
  [ "$(date +%s)" -ge "$DEADLINE" ] && { echo "TIMEOUT_NOCH_NICHT_TERMINAL $(TS)"; break; }
  sleep 15
done
echo "--status-detail literal--"
for B in $(kubectl get backups.postgresql.cnpg.io -n databases -o name | grep pre1014); do
  echo "### $B"
  kubectl get "$B" -n databases -o jsonpath='phase={.status.phase} backupName={.status.backupName} backupId={.status.backupId} startedAt={.status.startedAt} stoppedAt={.status.stoppedAt} beginLSN={.status.beginLSN} endLSN={.status.endLSN} error={.status.error}'; echo
done
