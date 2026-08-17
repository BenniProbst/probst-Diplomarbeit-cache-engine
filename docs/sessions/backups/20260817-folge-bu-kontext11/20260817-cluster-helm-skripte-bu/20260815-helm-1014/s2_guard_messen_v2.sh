#!/usr/bin/env bash
# s2_guard_messen_v2.sh -- HELM-10.1.4 S2: Fenster-Guard MESSUNG v2 (READ-ONLY)
# v2: Relations-Discovery (ci_builds/ci_pipelines existieren in 18.11 nicht mehr als View),
#     Zaehlung auf p_ci_builds/p_ci_pipelines, Sidekiq-ScheduledSet-Detail (Klassen+Zeiten).
set -u
export KUBECONFIG=/root/.kube/config
TS(){ date -u +%FT%TZ; }
echo "== S2-MESSUNG-v2 START $(TS) =="
PRIMARY=$(kubectl get cluster gitlab-pg -n databases -o jsonpath='{.status.currentPrimary}')
echo "primary=$PRIMARY"
PSQL(){ kubectl exec -n databases "$PRIMARY" -c postgres -- psql -U postgres -d gitlabhq_production -tAc "$1"; }

echo "--0 relations-discovery--"
PSQL "select relname||' kind='||relkind from pg_class where relname in ('ci_builds','p_ci_builds','ci_pipelines','p_ci_pipelines') and relkind in ('r','v','p') order by relname;"

echo "--1 p_ci_builds running+pending--"
PSQL "select 'p_ci_builds_running_pending='||count(*) from p_ci_builds where status in ('running','pending');"
echo "rc1=$?"

echo "--2 pipeline 15844 + nicht-terminale pipelines 48h (p_ci_pipelines)--"
PSQL "select 'p15844: id='||id||' project='||project_id||' status='||status||' created='||to_char(created_at,'YYYY-MM-DD HH24:MI') from p_ci_pipelines where id=15844;"
PSQL "select 'offen: id='||id||' project='||project_id||' status='||status||' created='||to_char(created_at,'YYYY-MM-DD HH24:MI') from p_ci_pipelines where status in ('created','waiting_for_resource','preparing','pending','running','scheduled') and created_at > now() - interval '48 hours' order by id;"
echo "rc2=$?"

echo "--3 sidekiq scheduled-set detail (klassen+zeiten, kein payload)--"
TB=$(kubectl get pod -n gitlab -l app=toolbox -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n gitlab "$TB" -c toolbox -- gitlab-rails runner 'require "sidekiq/api"; Sidekiq::ScheduledSet.new.each{|j| puts "sched: #{j.klass} at=#{Time.at(j.at).utc.strftime("%FT%TZ")}"}; s=Sidekiq::Stats.new; busy=Sidekiq::ProcessSet.new.sum{|p| p["busy"]}; puts "enqueued=#{s.enqueued} busy=#{busy} retry=#{s.retry_size} scheduled=#{s.scheduled_size}"'
echo "rc3=$?"
echo "== S2-MESSUNG-v2 ENDE $(TS) =="
