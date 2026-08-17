#!/usr/bin/env bash
# s2_guard_messen_v1.sh -- HELM-10.1.4 S2: Fenster-Guard MESSUNG (READ-ONLY, keine Mutation)
# CI-Builds via gitlab-pg Primary (S2-Praezedenzfall), Pipelines terminal?, Sidekiq-Queues.
set -u
export KUBECONFIG=/root/.kube/config
TS(){ date -u +%FT%TZ; }
echo "== S2-MESSUNG START $(TS) =="
PRIMARY=$(kubectl get cluster gitlab-pg -n databases -o jsonpath='{.status.currentPrimary}')
echo "primary=$PRIMARY"

echo "--1 p_ci_builds/ci_builds running+pending--"
kubectl exec -n databases "$PRIMARY" -c postgres -- psql -U postgres -d gitlabhq_production -tAc \
  "select 'p_ci_builds='||count(*) from p_ci_builds where status in ('running','pending') union all select 'ci_builds_view='||count(*) from ci_builds where status in ('running','pending');"
echo "rc1=$?"

echo "--2 pipeline 15844 + nicht-terminale pipelines der letzten 48h--"
kubectl exec -n databases "$PRIMARY" -c postgres -- psql -U postgres -d gitlabhq_production -tAc \
  "select 'p15844: id='||id||' project='||project_id||' status='||status||' created='||to_char(created_at,'YYYY-MM-DD HH24:MI') from ci_pipelines where id=15844;"
kubectl exec -n databases "$PRIMARY" -c postgres -- psql -U postgres -d gitlabhq_production -tAc \
  "select 'offen: id='||id||' project='||project_id||' status='||status||' created='||to_char(created_at,'YYYY-MM-DD HH24:MI') from ci_pipelines where status in ('created','waiting_for_resource','preparing','pending','running','scheduled') and created_at > now() - interval '48 hours' order by id;"
echo "rc2=$?"

echo "--3 sidekiq queues (rails runner, dauert ~1-2min)--"
TB=$(kubectl get pod -n gitlab -l app=toolbox -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n gitlab "$TB" -c toolbox -- gitlab-rails runner 'require "sidekiq/api"; s=Sidekiq::Stats.new; busy=Sidekiq::ProcessSet.new.sum{|p| p["busy"]}; puts "enqueued=#{s.enqueued} busy=#{busy} retry=#{s.retry_size} scheduled=#{s.scheduled_size} queues=#{Sidekiq::Queue.all.map{|q| [q.name,q.size]}.to_h}"'
echo "rc3=$?"
echo "== S2-MESSUNG ENDE $(TS) =="
