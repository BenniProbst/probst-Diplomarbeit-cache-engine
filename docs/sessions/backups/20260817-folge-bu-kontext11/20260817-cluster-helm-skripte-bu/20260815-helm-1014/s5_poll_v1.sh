#!/usr/bin/env bash
# s5_poll_v1.sh -- HELM-10.1.4 S5: Poll-Fassung (READ-ONLY, beliebig oft aufrufbar)
set -u
export KUBECONFIG=/root/.kube/config
TS(){ date -u +%FT%TZ; }
echo "== POLL $(TS) =="
echo "--helm prozess--"
pgrep -af "helm upgrade gitlab" || echo "helm-prozess beendet"
echo "--helm log tail--"
tail -4 /root/strangA-backups/logs/helm_upgrade_1014_v1.log 2>/dev/null
echo "--helm release--"
helm list -n gitlab
echo "--jobs (neueste 6)--"
kubectl get jobs -n gitlab --sort-by=.metadata.creationTimestamp | tail -6
echo "--pods kurzlage--"
kubectl get pods -n gitlab --no-headers | awk '{split($2,a,"/"); st[$3]++; if ($3!="Running" || a[1]!=a[2]) nr++} END {for (s in st) printf "%s=%d ", s, st[s]; printf "nicht_ready=%d\n", nr+0}'
kubectl get pods -n gitlab --no-headers | grep -E "webservice|sidekiq|migrations|toolbox|redis" | head -12
echo "--extern von pve1--"
curl -sk -o /dev/null -w 'signin_http=%{http_code}\n' --max-time 8 https://gitlab.comdare.local/users/sign_in || echo "extern_tot"
curl -sk --max-time 8 -H @/root/.gitlab-pat-header https://gitlab.comdare.local/api/v4/version -o /tmp/.ver -w 'version_http=%{http_code}\n' && cat /tmp/.ver && echo
rm -f /tmp/.ver
echo "== POLL ENDE $(TS) =="
