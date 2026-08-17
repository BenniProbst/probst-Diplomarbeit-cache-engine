#!/usr/bin/env bash
# s5_upgrade_v3.sh -- HELM-10.1.4 S5 v3: VALUES v3 = v1 + D4 global.gatewayApi {enabled:false, configureCertmanager:false}
# (Chart-10-Default gatewayApi.enabled=true rendert Gateway/Envoy-CRD-Ressourcen; Cluster hat keine Gateway-API-CRDs;
#  Owner-Linie D2 = nginx-Weiterfuehrung.) Dry-Run-Wache + Ingress-Gegenprobe, dann Upgrade DETACHED.
set -u
export KUBECONFIG=/root/.kube/config
TS(){ date -u +%FT%TZ; }
cd /root/strangA-backups
echo "== S5v3 START $(TS) =="
{ echo "# FINAL v3 $(TS) -- helm upgrade gitlab/gitlab 10.1.4."
  echo "# = Entwurf (D1 Valkey, D2 nginx, D3 s3cmd-config) + D4 gatewayApi AUS (Chart-10-Default true, keine CRDs, nginx bleibt)."
  yq -y '.global.gatewayApi = {"enabled": false, "configureCertmanager": false}' VALUES_FINAL_chart-10.1.4_20260815_v1.yaml
} > VALUES_FINAL_chart-10.1.4_20260815_v3.yaml
echo "--diff v1->v3 (nur gatewayApi-Block erwartet)--"
diff <(grep -v '^#' VALUES_FINAL_chart-10.1.4_20260815_v1.yaml) <(grep -v '^#' VALUES_FINAL_chart-10.1.4_20260815_v3.yaml) || true
echo "--dry-run=server wache (v3)--"
helm upgrade gitlab gitlab/gitlab --version 10.1.4 -n gitlab \
  -f VALUES_FINAL_chart-10.1.4_20260815_v3.yaml --dry-run=server > logs/helm_dryrun_1014_v3.log 2>&1
RC=$?
echo "rc_dryrun_v3=$RC ($(wc -l < logs/helm_dryrun_1014_v3.log) Zeilen)"
if [ "$RC" -ne 0 ]; then
  echo "DRY-RUN v3 ROT -- ABBRUCH. Letzte Zeilen:"
  tail -25 logs/helm_dryrun_1014_v3.log
  exit 3
fi
echo "--gegenprobe gerenderte kinds--"
grep -c "^kind: Ingress$" logs/helm_dryrun_1014_v3.log | sed 's/^/ingress_objekte=/'
grep -cE "^kind: (Gateway|HTTPRoute|TCPRoute|EnvoyProxy|GatewayClass|BackendTrafficPolicy|ClientTrafficPolicy)$" logs/helm_dryrun_1014_v3.log | sed 's/^/gateway_objekte=/'
grep -c "^kind: HorizontalPodAutoscaler$" logs/helm_dryrun_1014_v3.log | sed 's/^/hpa_objekte=/'
echo "--UPGRADE detached T0=$(TS)--"
nohup helm upgrade gitlab gitlab/gitlab --version 10.1.4 -n gitlab \
  -f VALUES_FINAL_chart-10.1.4_20260815_v3.yaml --timeout 30m > logs/helm_upgrade_1014_v1.log 2>&1 &
PID=$!
disown
echo "helm_pid=$PID"
sleep 5
ps -o pid,etime,cmd -p "$PID" | tail -1
tail -3 logs/helm_upgrade_1014_v1.log || true
echo "== S5v3 GESTARTET $(TS) =="
