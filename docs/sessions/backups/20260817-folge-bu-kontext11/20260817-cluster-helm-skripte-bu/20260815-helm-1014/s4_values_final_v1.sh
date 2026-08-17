#!/usr/bin/env bash
# s4_values_final_v1.sh -- HELM-10.1.4 S4: Values finalisieren (Entwurf==Ist+D1/D2/D3 beweisen)
# Keine Secrets im Output (Values tragen nur Secret-NAMEN). Additiv: neue Dateien, nichts ueberschreiben.
set -u
export KUBECONFIG=/root/.kube/config
TS(){ date -u +%FT%TZ; }
cd /root/strangA-backups
echo "== S4 START $(TS) =="
echo "--revision-stand--"
helm list -n gitlab
echo "--ist live ziehen + gegen gespeicherte ist-fassung diffen--"
helm get values gitlab -n gitlab > gitlab_values_ist_live_20260815T0834Z.yaml
if diff -q gitlab_values_ist_20260815.yaml gitlab_values_ist_live_20260815T0834Z.yaml >/dev/null; then
  echo "IST_UNVERAENDERT (live == gespeicherte Rev.23-Fassung)"
else
  echo "IST_ABWEICHUNG:"; diff gitlab_values_ist_20260815.yaml gitlab_values_ist_live_20260815T0834Z.yaml
fi
echo "--final-datei erzeugen (inhaltsgleich zum Entwurf, neuer Kopf)--"
{ echo "# FINAL $(TS) -- wird fuer helm upgrade gitlab/gitlab 10.1.4 angewandt."
  echo "# Inhaltsgleich zu VALUES_ENTWURF_chart-10.1.4_extern-valkey_s3cmd.yaml (Kopf ersetzt)."
  grep -v '^#' VALUES_ENTWURF_chart-10.1.4_extern-valkey_s3cmd.yaml
} > VALUES_FINAL_chart-10.1.4_20260815_v1.yaml
wc -l VALUES_FINAL_chart-10.1.4_20260815_v1.yaml
echo "--STRUKTUR-DIFF Entwurf(final) vs Ist(live) -- erwartet NUR D1 redis/valkey + D3 s3cmd-config--"
diff <(grep -v '^#' VALUES_FINAL_chart-10.1.4_20260815_v1.yaml) <(grep -v '^USER-SUPPLIED' gitlab_values_ist_live_20260815T0834Z.yaml) || true
echo "--pflicht-delta-gegenprobe im final--"
grep -n "s3cmd-config" VALUES_FINAL_chart-10.1.4_20260815_v1.yaml
grep -n "install: false" VALUES_FINAL_chart-10.1.4_20260815_v1.yaml
grep -n "gitlab-valkey.databases.svc.cluster.local" VALUES_FINAL_chart-10.1.4_20260815_v1.yaml
grep -n "class: nginx" VALUES_FINAL_chart-10.1.4_20260815_v1.yaml
echo "--externe erreichbarkeit von pve1 (fuer S6)--"
curl -sk -o /dev/null -w 'signin_http=%{http_code}\n' --max-time 10 https://gitlab.comdare.local/users/sign_in || echo "extern_nicht_erreichbar"
echo "== S4 ENDE $(TS) =="
