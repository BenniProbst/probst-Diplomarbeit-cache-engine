#!/usr/bin/env bash
# STRANG A / S2-Vorbereitung: Fenster messen, Plan dokumentieren, frisches Backup (pg_dump + Barman on-demand)
set -u
export KUBECONFIG=/root/.kube/config
TS=$(date -u +%Y%m%dT%H%M%SZ)
echo "TS=$TS"

echo "=== Pipeline-Fenster: ci_builds/ci_pipelines running+pending (DB, autoritativ) ==="
kubectl exec -n databases gitlab-pg-2 -c postgres -- psql -U postgres -At -d gitlabhq_production \
  -c "SELECT status, count(*) FROM ci_builds WHERE status IN ('running','pending') GROUP BY status;"
echo "RC_CI=$?"
kubectl exec -n databases gitlab-pg-2 -c postgres -- psql -U postgres -At -d gitlabhq_production \
  -c "SELECT count(*) AS active_pipelines FROM ci_pipelines WHERE status IN ('running','pending');"
echo "RC_CIP=$?"

echo "=== Frischer pg_dump (S2-Vorbackup) ==="
kubectl exec -n databases gitlab-pg-2 -c postgres -- pg_dump -U postgres -Fc -Z 6 -d gitlabhq_production > /root/strangA-backups/gitlabhq_production_pre17_${TS}.dump
echo "RC_DUMP_MAIN=$?"
kubectl exec -n databases gitlab-pg-2 -c postgres -- pg_dump -U postgres -Fc -Z 6 -d praefect > /root/strangA-backups/praefect_pre17_${TS}.dump
echo "RC_DUMP_PRAEFECT=$?"
ls -l /root/strangA-backups/ | tail -3

echo "=== On-Demand-Barman-Backup (Backup-CR, method plugin) ==="
cat > /root/strangA-backups/backup_pre17.yaml <<EOF
apiVersion: postgresql.cnpg.io/v1
kind: Backup
metadata:
  name: gitlab-pg-pre17-${TS,,}
  namespace: databases
spec:
  cluster:
    name: gitlab-pg
  method: plugin
  pluginConfiguration:
    name: barman-cloud.cloudnative-pg.io
EOF
kubectl apply -f /root/strangA-backups/backup_pre17.yaml
echo "RC_BKCR=$?"
for i in $(seq 1 30); do
  PH=$(kubectl get backup "gitlab-pg-pre17-${TS,,}" -n databases -o jsonpath='{.status.phase}')
  echo "[$i] backup phase=$PH"
  [ "$PH" = "completed" ] && break
  [ "$PH" = "failed" ] && break
  sleep 10
done
kubectl get backup -n databases --sort-by=.metadata.creationTimestamp | tail -3
echo "RC_BKLIST=$?"

echo "=== Plan-Datei S2 auf Bastion ablegen ==="
cat > /root/strangA-backups/PLAN_S2_pg16_zu_17.md <<'EOF'
# STRANG A / S2: PG-Major-Upgrade gitlab-pg 16.11 -> 17.11 (offline in-place, CNPG)
Datum: 2026-08-15 (UTC). Operator: cloudnative-pg 1.29.1 (in-place major upgrade seit 1.26 verfuegbar).
Verfahren (Doku cloudnative-pg.io/docs/1.29/postgres_upgrades/):
1. .spec.imageName -> ghcr.io/cloudnative-pg/postgresql:17.11-standard-bookworm (bookworm->bookworm, gleiche Distribution PFLICHT).
   Manifest-HEAD-Beleg: 17.11 HTTP 200; 17.12..17.16 HTTP 404; 16.11 HTTP 200 (Gegenprobe).
2. Gleichzeitig plugins[0].parameters.serverName=gitlab-pg-v17 (PITR gilt nicht ueber Major-Grenze;
   neues Archiv-Prefix verhindert WAL-Namenskollision nach pg_upgrade-Timeline-Reset; Alt-Archiv bleibt additiv erhalten).
3. Ablauf durch Operator: Cluster-Shutdown (Downtime!) -> Job gitlab-pg-2-major-upgrade (pg_upgrade --link)
   -> Primary startet mit 17 -> Replica-PVCs werden zerstoert und neu geklont.
4. Danach: ANALYZE (vacuumdb --all --analyze-in-stages), Version literal belegen, Replikation belegen,
   On-Demand-Backup in neuen serverName-Pfad, ScheduledBackup wieder aktivieren (suspend=false).
Vorbedingungen (gemessen):
- S1 gruen: 2/2 "Cluster in healthy state", Replikation streaming (gitlab-pg-7, lag ~5ms).
- max_slot_wal_keep_size=80GB: Bug betrifft nur 17.0-17.5, Ziel ist 17.11 -> nicht einschlaegig.
- Extensions: btree_gist 1.7, pg_trgm 1.6, pgcrypto 1.3, plpgsql 1.0 (Standard-Image deckt alle).
- Pipeline-Fenster: Runner-NS 0 Job-Pods; DB-Zaehlung ci_builds running+pending siehe Protokoll.
- Backups: pg_dump 01:54Z (85767194 B, sha256 a0a4f41c...) + frischer pre17-Dump + Barman on-demand pre17.
- ScheduledBackup gitlab-pg-daily suspendiert (03:00Z-Kollision vermieden), Reaktivierung nach Abschluss.
Rollback: Bei Fehlschlag des Upgrade-Jobs Image zurueck auf 16.11-standard-bookworm (Doku: automatischer Rollback,
kein Datenverlust; zusaetzlich pg_dump + Barman-Backup vorhanden). Bei unklarem Zustand: STOPP, Zustand dokumentieren.
EOF
echo "RC_PLAN=$?"
ls -l /root/strangA-backups/PLAN_S2_pg16_zu_17.md
