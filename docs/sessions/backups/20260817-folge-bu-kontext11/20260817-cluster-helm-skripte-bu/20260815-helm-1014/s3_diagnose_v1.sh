#!/usr/bin/env bash
# s3_diagnose_v1.sh -- HELM-10.1.4 S3: Diagnose leere Backup-Phase (READ-ONLY)
set -u
export KUBECONFIG=/root/.kube/config
TS(){ date -u +%FT%TZ; }
echo "== S3-DIAG $(TS) =="
echo "--alle backups (neueste zuletzt)--"
kubectl get backup -n databases --sort-by=.metadata.creationTimestamp | tail -6
echo "--mein backup yaml status--"
B=$(kubectl get backup -n databases --sort-by=.metadata.creationTimestamp -o name | tail -1)
echo "cr=$B"
kubectl get "$B" -n databases -o yaml | sed -n '/^status:/,$p'
echo "--events databases (letzte 15)--"
kubectl get events -n databases --sort-by=.lastTimestamp | tail -15
echo "--operator pod + letzte logzeilen zu backup--"
kubectl get pods -n cnpg-system 2>/dev/null || kubectl get pods -A | grep -i cnpg | head -5
OP=$(kubectl get pods -A -l app.kubernetes.io/name=cloudnative-pg -o jsonpath='{.items[0].metadata.namespace}/{.items[0].metadata.name}' 2>/dev/null)
echo "operator=$OP"
if [ -n "${OP:-}" ]; then kubectl logs -n "${OP%%/*}" "${OP##*/}" --since=10m 2>/dev/null | grep -iE "backup|error" | tail -20; fi
echo "== S3-DIAG ENDE $(TS) =="
