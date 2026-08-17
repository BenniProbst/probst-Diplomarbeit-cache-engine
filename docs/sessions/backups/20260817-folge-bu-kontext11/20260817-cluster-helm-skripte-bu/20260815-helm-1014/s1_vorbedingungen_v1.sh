#!/usr/bin/env bash
# s1_vorbedingungen_v1.sh -- HELM-10.1.4 S1: Vorbedingungen messen (READ-ONLY, keine Mutation)
# Laeuft auf pve1 via: ssh root@10.0.10.201 'bash -s' < diese_datei
# Secrets: NIE nach stdout (Valkey-PW + s3cmd-Config nur via Pipe/stdin).
set -u
export KUBECONFIG=/root/.kube/config
TS(){ date -u +%FT%TZ; }
echo "== S1 START $(TS) host=$(hostname) =="

echo "--A helm release--"
helm list -n gitlab
echo "rcA=$?"

echo "--B cnpg--"
kubectl get cluster gitlab-pg -n databases
PRIMARY=$(kubectl get cluster gitlab-pg -n databases -o jsonpath='{.status.currentPrimary}')
echo "primary=$PRIMARY"
kubectl exec -n databases "$PRIMARY" -c postgres -- psql -U postgres -tAc "select version();" | head -1
echo "rcB=$?"

echo "--C valkey--"
kubectl get pod gitlab-valkey-0 -n databases
tr -d '\n' </root/strangA-backups/valkey-password | kubectl exec -i -n databases gitlab-valkey-0 -- sh -c 'read -r REDISCLI_AUTH; export REDISCLI_AUTH; valkey-cli --no-auth-warning ping'
echo "rcC=$?"

echo "--D secret gitlab-object-storage keys--"
kubectl get secret gitlab-object-storage -n gitlab -o go-template='{{range $k,$v := .data}}{{$k}}{{"\n"}}{{end}}'
echo "--D2 secret gitlab-valkey-password keys (ns gitlab / ns databases)--"
kubectl get secret gitlab-valkey-password -n gitlab -o go-template='{{range $k,$v := .data}}{{$k}}{{"\n"}}{{end}}'
kubectl get secret gitlab-valkey-password -n databases -o go-template='{{range $k,$v := .data}}{{$k}}{{"\n"}}{{end}}'

echo "--E S3-Backup heute (toolbox + s3cmd-config aus Secret, Secret nur via Pipe)--"
TB=$(kubectl get pod -n gitlab -l app=toolbox -o jsonpath='{.items[0].metadata.name}')
echo "toolbox=$TB"
kubectl get secret gitlab-object-storage -n gitlab -o jsonpath='{.data.s3cmd-config}' | base64 -d | \
  kubectl exec -i -n gitlab "$TB" -c toolbox -- sh -c 'umask 077; cat >/tmp/.s1_s3cfg; s3cmd -c /tmp/.s1_s3cfg ls s3://gitlab-backups/; rc=$?; rm -f /tmp/.s1_s3cfg; exit $rc'
echo "rcE=$?"

echo "--F werkzeuge bastion--"
for t in helm kubectl jq yq python3 mc s3cmd curl; do command -v $t >/dev/null 2>&1 && echo "tool $t: ja" || echo "tool $t: nein"; done

echo "--G hpa + deploys ns gitlab--"
kubectl get hpa -n gitlab
kubectl get deploy -n gitlab
kubectl get sts -n gitlab

echo "--H scheduledbackup + letzte backups--"
kubectl get scheduledbackup -n databases 2>/dev/null || true
kubectl get backup -n databases --sort-by=.metadata.creationTimestamp 2>/dev/null | tail -5

echo "--I readiness ist (in-cluster via toolbox)--"
kubectl exec -n gitlab "$TB" -c toolbox -- sh -c 'curl -s -o /dev/null -w "readiness_http=%{http_code}\n" "http://gitlab-webservice-default.gitlab.svc:8181/-/readiness?all=1"; curl -s "http://gitlab-webservice-default.gitlab.svc:8181/-/readiness?all=1" | head -c 1500; echo'

echo "== S1 ENDE $(TS) =="
