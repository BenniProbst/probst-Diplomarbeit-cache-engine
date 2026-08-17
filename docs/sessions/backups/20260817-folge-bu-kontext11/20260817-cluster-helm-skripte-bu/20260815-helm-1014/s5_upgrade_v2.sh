#!/usr/bin/env bash
# s5_upgrade_v2.sh -- HELM-10.1.4 S5 v2: gatewayApi-Default messen, VALUES v2 (D4: gatewayApi.configureCertmanager=false),
# Dry-Run-Wache erneut, dann Upgrade DETACHED. v1 bleibt unangetastet (Beweis-Fassung).
set -u
export KUBECONFIG=/root/.kube/config
TS(){ date -u +%FT%TZ; }
cd /root/strangA-backups
echo "== S5v2 START $(TS) =="
echo "--chart-default gatewayApi--"
grep -n -A4 "gatewayApi" chart-10.1.4/gitlab/values.yaml | head -12
echo "--values v2 bauen (v1 + global.gatewayApi.configureCertmanager=false)--"
yq '.global.gatewayApi.configureCertmanager = false' VALUES_FINAL_chart-10.1.4_20260815_v1.yaml > VALUES_FINAL_chart-10.1.4_20260815_v2.yaml
echo "diff v1->v2:"
diff VALUES_FINAL_chart-10.1.4_20260815_v1.yaml VALUES_FINAL_chart-10.1.4_20260815_v2.yaml || true
echo "--dry-run=server wache (v2)--"
helm upgrade gitlab gitlab/gitlab --version 10.1.4 -n gitlab \
  -f VALUES_FINAL_chart-10.1.4_20260815_v2.yaml --dry-run=server > logs/helm_dryrun_1014_v2.log 2>&1
RC=$?
echo "rc_dryrun_v2=$RC ($(wc -l < logs/helm_dryrun_1014_v2.log) Zeilen)"
if [ "$RC" -ne 0 ]; then
  echo "DRY-RUN v2 ROT -- ABBRUCH. Letzte Zeilen:"
  tail -25 logs/helm_dryrun_1014_v2.log
  exit 3
fi
grep -c "^kind:" logs/helm_dryrun_1014_v2.log | sed 's/^/gerenderte_kinds=/' || true
echo "--UPGRADE detached T0=$(TS)--"
nohup helm upgrade gitlab gitlab/gitlab --version 10.1.4 -n gitlab \
  -f VALUES_FINAL_chart-10.1.4_20260815_v2.yaml --timeout 30m > logs/helm_upgrade_1014_v1.log 2>&1 &
PID=$!
disown
echo "helm_pid=$PID"
sleep 5
ps -o pid,etime,cmd -p "$PID" | tail -1
tail -3 logs/helm_upgrade_1014_v1.log || true
echo "== S5v2 GESTARTET $(TS) =="
