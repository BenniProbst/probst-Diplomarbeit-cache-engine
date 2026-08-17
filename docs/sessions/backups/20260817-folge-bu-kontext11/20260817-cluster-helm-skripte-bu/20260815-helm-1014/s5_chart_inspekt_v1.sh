#!/usr/bin/env bash
# s5_chart_inspekt_v1.sh -- HELM-10.1.4 S5: Chart 10.1.4 ziehen und certmanager-issuer-Bedingung nachlesen (READ-ONLY)
set -u
TS(){ date -u +%FT%TZ; }
cd /root/strangA-backups
mkdir -p chart-10.1.4 && cd chart-10.1.4
[ -f gitlab-10.1.4.tgz ] || helm pull gitlab/gitlab --version 10.1.4
ls -la gitlab-10.1.4.tgz
tar -xzf gitlab-10.1.4.tgz gitlab/Chart.yaml gitlab/charts/certmanager-issuer/templates/configmap.yaml gitlab/charts/certmanager-issuer/Chart.yaml gitlab/charts/certmanager-issuer/values.yaml 2>/dev/null
echo "--dependencies certmanager* in Chart.yaml--"
grep -B2 -A4 -i "certmanager" gitlab/Chart.yaml
echo "--issuer configmap.yaml (kopf + zeile 15-30)--"
sed -n '1,30p' gitlab/charts/certmanager-issuer/templates/configmap.yaml
echo "--issuer values.yaml--"
cat gitlab/charts/certmanager-issuer/Chart.yaml 2>/dev/null | head -8
cat gitlab/charts/certmanager-issuer/values.yaml 2>/dev/null | head -20
echo "--upgrade-doku im chart zu certmanager (falls vorhanden)--"
tar -xzf gitlab-10.1.4.tgz gitlab/values.yaml
grep -n -A6 "certmanager" gitlab/values.yaml | head -40
