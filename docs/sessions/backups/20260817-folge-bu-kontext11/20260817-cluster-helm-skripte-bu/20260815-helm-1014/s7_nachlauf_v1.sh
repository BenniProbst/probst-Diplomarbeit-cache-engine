#!/usr/bin/env bash
# s7_nachlauf_v1.sh -- HELM-10.1.4 S7: Nachlauf (ScheduledBackup aktiv, Barman-Altpfad unangetastet,
# Toolbox-Backup-Kanal-Smoke via s3cmd Schreibprobe -- additiv, 1 Marker-Datei put+ls, KEIN Loeschen von Bestand)
set -u
export KUBECONFIG=/root/.kube/config
TS(){ date -u +%FT%TZ; }
echo "== S7 START $(TS) =="
echo "--scheduledbackup--"
kubectl get scheduledbackup -n databases
kubectl get scheduledbackup gitlab-pg-daily -n databases -o jsonpath='suspend={.spec.suspend} next={.status.nextScheduleTime}'; echo
echo "--cnpg cluster nach upgrade--"
kubectl get cluster gitlab-pg -n databases
echo "--toolbox backup-kanal smoke unter 19.1 (secret nur via pipe)--"
TB=$(kubectl get pod -n gitlab -l app=toolbox --field-selector=status.phase=Running -o jsonpath='{.items[0].metadata.name}')
echo "toolbox=$TB"
kubectl exec -n gitlab "$TB" -c toolbox -- sh -c 'ls -la /etc/gitlab/objectstorage/ 2>/dev/null | head -6'
kubectl get secret gitlab-object-storage -n gitlab -o jsonpath='{.data.s3cmd-config}' | base64 -d | \
  kubectl exec -i -n gitlab "$TB" -c toolbox -- sh -c 'umask 077; cat >/tmp/.s7cfg; date -u +%FT%TZ > /tmp/.s7marker; s3cmd -c /tmp/.s7cfg put /tmp/.s7marker s3://gitlab-backups/smoke_19_1_20260815.txt 2>&1 | tail -1; s3cmd -c /tmp/.s7cfg ls s3://gitlab-backups/smoke_19_1_20260815.txt; rc=$?; rm -f /tmp/.s7cfg /tmp/.s7marker; echo "smoke_rc=$rc"'
echo "--valkey persistenz-zustand--"
kubectl get pod gitlab-valkey-0 -n databases
echo "--redis-alt-pvc dokumentieren (BLEIBEN stehen)--"
kubectl get pvc -n gitlab | grep -i redis || echo "keine redis-pvc"
echo "== S7 ENDE $(TS) =="
