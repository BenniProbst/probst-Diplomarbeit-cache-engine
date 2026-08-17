#!/usr/bin/env bash
# s6_verifikation_v1.sh -- HELM-10.1.4 S6: Verifikation nach Upgrade (READ-ONLY + rails-Info)
set -u
export KUBECONFIG=/root/.kube/config
TS(){ date -u +%FT%TZ; }
echo "== S6 START $(TS) =="
echo "--helm release-stand--"
helm list -n gitlab -a
echo "--rollout webservice/sidekiq--"
kubectl rollout status deploy/gitlab-webservice-default -n gitlab --timeout=300s
kubectl rollout status deploy/gitlab-sidekiq-all-in-1-v2 -n gitlab --timeout=300s
echo "--jobs migrations literal--"
kubectl get jobs -n gitlab --sort-by=.metadata.creationTimestamp | tail -5
echo "--api version extern (PAT-header, erwartet 19.1.x)--"
curl -sk --max-time 10 -H @/root/.gitlab-pat-header https://gitlab.comdare.local/api/v4/version -w '\nversion_http=%{http_code}\n'
echo "--readiness all=1 (in-cluster via toolbox)--"
TB=$(kubectl get pod -n gitlab -l app=toolbox --field-selector=status.phase=Running -o jsonpath='{.items[0].metadata.name}')
echo "toolbox=$TB"
kubectl exec -n gitlab "$TB" -c toolbox -- sh -c 'curl -s -o /dev/null -w "readiness_http=%{http_code}\n" "http://gitlab-webservice-default.gitlab.svc:8181/-/readiness?all=1"; curl -s "http://gitlab-webservice-default.gitlab.svc:8181/-/readiness?all=1"; echo'
echo "--redis zeigt auf valkey (rails runner)--"
kubectl exec -n gitlab "$TB" -c toolbox -- gitlab-rails runner 'Gitlab::Redis::SharedState.with { |r| i=r.info; puts "redis_version=#{i["redis_version"]} valkey_version=#{i["valkey_version"]} run_id=#{i["run_id"][0,8]}" }'
echo "--bundled-redis-reste--"
kubectl get sts -n gitlab | grep -i redis || echo "kein redis-sts mehr"
kubectl get pods -n gitlab | grep -i redis || echo "keine redis-pods mehr"
kubectl get pvc -n gitlab | grep -i redis || echo "keine redis-pvc (unerwartet)"
echo "--hpa wieder da--"
kubectl get hpa -n gitlab
echo "--runner online (erwartet >=2)--"
curl -sk --max-time 10 -H @/root/.gitlab-pat-header "https://gitlab.comdare.local/api/v4/runners/all?status=online&per_page=100" | jq -r 'length as $n | "runner_online=\($n)", (.[] | "runner: id=\(.id) desc=\(.description // "-") online")' 2>/dev/null || echo "runner_api_fehler"
echo "== S6 ENDE $(TS) =="
