#!/usr/bin/env bash
# s5_upgrade_v1.sh -- HELM-10.1.4 S5: repo update, Chart-Verifikation, Server-Dry-Run-Wache,
# dann helm upgrade DETACHED (nohup, Log auf pve1) -- Poll erfolgt separat (Kanal-Abriss-fest).
set -u
export KUBECONFIG=/root/.kube/config
TS(){ date -u +%FT%TZ; }
cd /root/strangA-backups
mkdir -p logs
echo "== S5 START $(TS) =="
echo "--repo update--"
helm repo list | grep -i gitlab
helm repo update gitlab 2>&1 | tail -2
echo "--chart 10.1.4 verifizieren--"
helm search repo gitlab/gitlab -l | awk '$2=="10.1.4"'
echo "rc_search=$?"
echo "--dry-run=server als wache--"
helm upgrade gitlab gitlab/gitlab --version 10.1.4 -n gitlab \
  -f VALUES_FINAL_chart-10.1.4_20260815_v1.yaml --dry-run=server > logs/helm_dryrun_1014_v1.log 2>&1
RC=$?
echo "rc_dryrun=$RC ($(wc -l < logs/helm_dryrun_1014_v1.log) Zeilen)"
if [ "$RC" -ne 0 ]; then
  echo "DRY-RUN ROT -- ABBRUCH, kein Upgrade. Letzte Zeilen:"
  tail -25 logs/helm_dryrun_1014_v1.log
  exit 3
fi
echo "--UPGRADE detached T0=$(TS)--"
nohup helm upgrade gitlab gitlab/gitlab --version 10.1.4 -n gitlab \
  -f VALUES_FINAL_chart-10.1.4_20260815_v1.yaml --timeout 30m > logs/helm_upgrade_1014_v1.log 2>&1 &
PID=$!
disown
echo "helm_pid=$PID"
sleep 5
ps -o pid,etime,cmd -p "$PID" | tail -1
tail -3 logs/helm_upgrade_1014_v1.log || true
echo "== S5 GESTARTET $(TS) =="
