#!/usr/bin/env bash
# STRANG A / S3: gitlab-Values-Entwurf fuer Chart 10.1.4 erzeugen (Datei auf Bastion, NICHT anwenden)
set -u
export KUBECONFIG=/root/.kube/config
helm get values gitlab -n gitlab -o yaml > /tmp/strangA_values_ist.yaml
echo "RC_GET=$?"
python3 - <<'PYEOF'
import yaml
v = yaml.safe_load(open("/tmp/strangA_values_ist.yaml"))

# Delta 1: internes Redis-Subchart aus, kompletter Block ersetzt
v["redis"] = {"install": False}

# Delta 2: externes Valkey (deployter Ist-Stand: Service gitlab-valkey.databases, Secret gitlab-valkey-password/password in NS gitlab)
g = v.setdefault("global", {})
g["redis"] = {
    "host": "gitlab-valkey.databases.svc.cluster.local",
    "port": 6379,
    "auth": {
        "enabled": True,
        "secret": "gitlab-valkey-password",
        "key": "password",
    },
}

# Delta 3: VALUES-PFLICHT backups.objectStorage.config -> s3cmd-config (haelt die Toolbox-Heilung ueber helm-Upgrades)
tb = v.setdefault("gitlab", {}).setdefault("toolbox", {}).setdefault("backups", {}).setdefault("objectStorage", {})
tb["config"] = {"secret": "gitlab-object-storage", "key": "s3cmd-config"}

# nginx-ingress-Weiterfuehrung: bereits nginx-ingress.enabled=false + global.ingress.class=nginx im Ist — unveraendert uebernehmen.

header = """# STRANG A / S3 — ENTWURF (NICHT ANGEWENDET) — 2026-08-15
# Ziel: helm upgrade gitlab gitlab/gitlab --version 10.1.4 -n gitlab -f DIESE_DATEI
# Basis: helm get values gitlab -n gitlab (Release-Revision 23, Chart gitlab-9.11.8, App v18.11.7)
# Deltas gegen Ist:
#   1) redis.install=false  (ersetzt internes Sentinel-Replication-Subchart gitlab-redis-node-*)
#   2) global.redis -> externes Valkey 7.2.14 (databases/gitlab-valkey:6379, Auth-Secret gitlab-valkey-password
#      liegt in NS gitlab UND databases; Klartext-Kopie pve1:/root/strangA-backups/valkey-password 0600;
#      Vault-Eintrag Cluster/keys/ ist NACHZUZIEHEN durch Hauptsession — dieser Strang hat keine Repo-Schreibrechte)
#   3) gitlab.toolbox.backups.objectStorage.config.key: connection -> s3cmd-config (OWNER-PFLICHT #52;
#      Secret-Key existiert: gemessen ['artifacts','connection','lfs','packages','registry-storage','s3cmd-config','uploads'])
# Weitergefuehrt unveraendert: nginx-ingress.enabled=false + global.ingress.class=nginx (externer ingress-nginx),
#   postgresql.install=false + global.psql auf gitlab-pg-rw.databases (seit heute PG 17.11), LDAP, MinIO-extern, praefect.
# VORBEDINGUNGEN vor Anwendung: S1+S2 gruen (erfuellt), Pipeline-Fenster p_ci_builds running+pending=0 (messen!),
#   frisches gitlab-backup-utility-Backup literal belegt, GitLab-19-Upgrade-Path 18.11->19.1 belegt (siehe Plan-Datei).
# Umschalt-Hinweis Redis-Wechsel: Beim Upgrade wechseln Cache+Queues auf das leere Valkey — Sidekiq-Queues werden
#   waehrend der helm-Downtime geleert erwartet (Fenster!), Sessions/Cache verfallen (Nutzer neu einloggen).
"""
body = yaml.safe_dump(v, default_flow_style=False, sort_keys=True, width=100)
open("/root/strangA-backups/values_gitlab_chart10_entwurf.yaml","w").write(header + body)
print("ENTWURF GESCHRIEBEN")
PYEOF
echo "RC_PY=$?"
ls -l /root/strangA-backups/values_gitlab_chart10_entwurf.yaml
echo "=== Kontrolle: die drei Deltas im Entwurf (grep) ==="
/usr/bin/grep -n "install: false" /root/strangA-backups/values_gitlab_chart10_entwurf.yaml | head -5
/usr/bin/grep -n -A 7 "^  redis:" /root/strangA-backups/values_gitlab_chart10_entwurf.yaml | head -12
/usr/bin/grep -n "s3cmd-config" /root/strangA-backups/values_gitlab_chart10_entwurf.yaml
echo "RC_GREP=$?"
