#!/usr/bin/env bash
# s2_sidekiq_stopp_v1.sh -- HELM-10.1.4 S2b: Sidekiq-Stopp NACH Drain (MUTATION, Fenster aktiv)
# HPA wird VOR scale=0 gesichert+geloescht (min=4 wuerde sonst zurueckskalieren);
# helm upgrade (S5) legt die HPA aus dem Chart neu an.
set -u
export KUBECONFIG=/root/.kube/config
TS(){ date -u +%FT%TZ; }
echo "== S2b START $(TS) =="
echo "--pre--"
kubectl get deploy gitlab-sidekiq-all-in-1-v2 -n gitlab
kubectl get hpa gitlab-sidekiq-all-in-1-v2 -n gitlab -o yaml > /root/strangA-backups/hpa_sidekiq_rev23_sicherung_20260815.yaml \
  && echo "hpa gesichert: /root/strangA-backups/hpa_sidekiq_rev23_sicherung_20260815.yaml ($(wc -l < /root/strangA-backups/hpa_sidekiq_rev23_sicherung_20260815.yaml) Z.)"
echo "--hpa loeschen + scale 0--"
kubectl delete hpa gitlab-sidekiq-all-in-1-v2 -n gitlab
kubectl scale deploy gitlab-sidekiq-all-in-1-v2 -n gitlab --replicas=0
for i in $(seq 1 36); do
  N=$(kubectl get pods -n gitlab -l app=sidekiq --no-headers 2>/dev/null | wc -l)
  echo "$(TS) sidekiq_pods=$N"
  [ "$N" = "0" ] && break
  sleep 5
done
echo "--final queue-messung (rails runner)--"
TB=$(kubectl get pod -n gitlab -l app=toolbox -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n gitlab "$TB" -c toolbox -- gitlab-rails runner 'require "sidekiq/api"; s=Sidekiq::Stats.new; busy=Sidekiq::ProcessSet.new.sum{|p| p["busy"]}; puts "FINAL enqueued=#{s.enqueued} busy=#{busy} retry=#{s.retry_size} scheduled=#{s.scheduled_size} processes=#{Sidekiq::ProcessSet.new.size}"'
echo "--builds-gegenprobe--"
PRIMARY=$(kubectl get cluster gitlab-pg -n databases -o jsonpath='{.status.currentPrimary}')
kubectl exec -n databases "$PRIMARY" -c postgres -- psql -U postgres -d gitlabhq_production -tAc "select 'builds_running_pending='||count(*) from p_ci_builds where status in ('running','pending');"
echo "== S2b ENDE $(TS) =="
