#!/usr/bin/env bash
# STRANG A: Plan-Datei fuer den finalen helm-Schritt (NICHT ausfuehren)
set -u
cat > /root/strangA-backups/PLAN_HELM_10_1_4.md <<'EOF'
# STRANG A — PRAEZISER REST-PLAN: helm upgrade auf Chart 10.1.4 (GitLab 18.11.7 -> 19.1.4)
Stand 2026-08-15 ~03:40Z. Vorstrecke S1-S3 GRUEN. helm bewusst NICHT gefahren (Major-Sprung + Redis-Umzug
= groesste Aenderungsmasse; Session brauchte GitLab unmittelbar wieder; Auftrag erlaubt Plan-Rueckgabe).

## Belegte Vorbedingungen (heute erbracht)
- S1: gitlab-pg 2/2 "Cluster in healthy state" (Replica-Rebuild gitlab-pg-7, spaeter -8), Ursache pg_rewind-Loop geheilt.
- S2: PostgreSQL 17.11 literal ("17.11 (Debian 17.11-1.pgdg12+2)"), ANALYZE gefahren, Barman serverName=gitlab-pg-v17,
  Post-17-Basisbackup completed 03:25:41Z, ScheduledBackup wieder aktiv. GitLab-Lebendproben HTTP 200.
- S3: Valkey 7.2.14 laeuft (databases/gitlab-valkey, StatefulSet+PVC 5Gi longhorn-database, AOF, Auth,
  Persistenz ueber Pod-Kill bewiesen, NOAUTH-Gegenprobe). Values-Entwurf: /root/strangA-backups/values_gitlab_chart10_entwurf.yaml
  (Deltas: redis.install=false; global.redis -> gitlab-valkey.databases:6379 Secret gitlab-valkey-password/password;
  toolbox.backups.objectStorage.config -> {secret: gitlab-object-storage, key: s3cmd-config}).
- Upgrade-Path: Required Stops 19er = 19.2/19.5/19.8/19.11 -> 18.11.x -> 19.1.4 DIREKT supported (docs.gitlab.com/update/upgrade_paths).
- Version-Mapping: Chart 10.1.4 = GitLab 19.1.4 (docs.gitlab.com/charts/installation/version_mappings).
- Object-Storage-Secret traegt Key s3cmd-config (gemessen).

## Noch zu erfuellende Bedingungen UNMITTELBAR vor dem Upgrade
1. Pipeline-Fenster: SELECT count(*) FROM p_ci_builds WHERE status IN ('running','pending'); == 0
   (via kubectl exec gitlab-pg-2 psql; Sperr-Absprache mit Session-Lead, wie heute praktiziert).
2. Frisches gitlab-backup-utility-Backup literal belegt (Toolbox; Lauf vom 15.08. siehe /tmp/strangA_backup_utility.log
   im Toolbox-Pod bzw. Bucket gitlab-backups; bei >24h Abstand NEU fahren: kubectl exec toolbox -- backup-utility --skip registry).
3. helm repo aktuell: helm repo update; helm search repo gitlab/gitlab --version 10.1.4 (Chart verfuegbar belegen).

## Ausfuehrung (ein Kommando, Werte-Datei ist vollstaendig)
helm upgrade gitlab gitlab/gitlab --version 10.1.4 -n gitlab \
  -f /root/strangA-backups/values_gitlab_chart10_entwurf.yaml \
  --timeout 30m
Beobachtung: kubectl get pods -n gitlab -w; Migrations-Job gitlab-migrations-* muss Completed werden;
webservice/sidekiq rollen auf 19.1-Images; Erwartung 10-30 min eingeschraenkte Verfuegbarkeit.

## Direkt nach dem Upgrade
- /-/readiness?all=1 HTTP 200 alle Checks ok (via Toolbox); /api/v4/version == 19.1.4.
- Sidekiq-Queues laufen auf Valkey: kubectl exec databases/gitlab-valkey-0 -- valkey-cli (Auth) INFO keyspace (Keys > 0).
- Ein Test-Push + eine Test-Pipeline (Push->gruen-Doktrin).
- gitlab-redis-node-* Pods verschwinden (redis.install=false). Deren PVCs NICHT sofort loeschen —
  erst nach 48h stabilem Betrieb, additive Aufbewahrung bis dahin.
- Neues backup-utility-Backup (19.1-Format) + CNPG-Lage unveraendert pruefen.

## Rollback
- VOR Abschluss der 19.1-DB-Migrationen: helm rollback gitlab 23 -n gitlab (zurueck auf Chart 9.11.8/18.11.7).
- NACH Migrationen ist Chart-Rollback NICHT ausreichend (Migrationen irreversibel) -> Wiederherstellung aus
  backup-utility-Backup (+ pg_dumps pve1:/root/strangA-backups/, Barman gitlab-pg-v17). Deshalb Bedingung 2 hart.

## Offene Nebenposten
- Vault-Eintrag fuer valkey-password (Klartext 0600 auf pve1:/root/strangA-backups/valkey-password) durch Hauptsession
  nachziehen (dieser Strang: keine Repo-Schreibrechte).
- comdare-business/comdare-app-pg zeigt dieselbe stale Phase "closed pool" (2/3 ready, comdare-app-pg-3 Status-500):
  gleiches Heilmuster wie S1 pruefen — EIGENER Auftrag, nicht Teil von #52.
- 40 Zombie-Pipelines (Feb-Jul, running/pending ohne aktive Builds) in der GitLab-DB: kosmetisch; optional per
  Rails-Konsole/API aufraeumen.
- DB-Zugangs-User heisst comdare-database (global.psql.username) — unveraendert gelassen.
EOF
echo "RC_PLAN=$?"
ls -l /root/strangA-backups/PLAN_HELM_10_1_4.md
