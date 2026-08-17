#!/usr/bin/env bash
# s2_build_detail_v1.sh -- HELM-10.1.4 S2: Detail des laufenden Builds (READ-ONLY)
set -u
export KUBECONFIG=/root/.kube/config
PRIMARY=$(kubectl get cluster gitlab-pg -n databases -o jsonpath='{.status.currentPrimary}')
kubectl exec -n databases "$PRIMARY" -c postgres -- psql -U postgres -d gitlabhq_production -tAc \
  "select 'build: id='||id||' pipeline='||commit_id||' name='||coalesce(name,'?')||' stage='||coalesce(stage,'?')||' status='||status||' started='||coalesce(to_char(started_at,'YYYY-MM-DD HH24:MI:SS'),'-')||' runner='||coalesce(runner_id::text,'-') from p_ci_builds where status in ('running','pending');"
kubectl exec -n databases "$PRIMARY" -c postgres -- psql -U postgres -d gitlabhq_production -tAc \
  "select 'dauer_letzte_gleiche: name='||coalesce(b.name,'?')||' status='||b.status||' sek='||coalesce(extract(epoch from (b.finished_at-b.started_at))::int::text,'-') from p_ci_builds b where b.name = (select name from p_ci_builds where status in ('running','pending') limit 1) and b.finished_at is not null order by b.id desc limit 5;"
