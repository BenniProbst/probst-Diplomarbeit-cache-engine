# Infra-Task #77 — Cluster-Migration Fortigate-31G + COMDARE-Modules-GitLab-Push

**Stand:** 2026-05-18 (Pre-flight-Spec)
**Trigger:** Task #77 (USER + INFRA)
**Anwender:** User (Cluster-Admin-Zugang erforderlich)
**Erwarteter Aufwand:** 2-4 Stunden Cluster-Arbeit

> Diese Doku ist die Schritt-fuer-Schritt-Anleitung fuer die Cluster-Migration nach Fortigate-31G + GitLab-Push der 200+ COMDARE-Modules. Sie ergaenzt den Cluster-Masterplan unter `C:\Users\benja\OneDrive\Desktop\Projekte\Cluster\sessions\2026-02-03-architektur-migrations-masterplan-session.md`.

---

## §1 Ziel

Migration der 200+ COMDARE-Modules vom alten Repo-Stand (vor Fortigate-31G) auf den neuen GitLab-Server im COMDARE-Cluster (siehe Cluster-Architektur in Memory `cluster_system_architecture`).

**Konkret:**
1. Fortigate-31G konfigurieren (VLAN 40 APPS + VLAN 60 BUILD)
2. GitLab-Server im COMDARE-Cluster bereitstellen (oder bestehenden konfigurieren)
3. 200+ COMDARE-Module systematisch nach GitLab pushen (rc → cd Prefix-Rename)
4. CI-Workflows pro Modul anlegen

---

## §2 Voraussetzungen (Pflicht-Pre-Check)

- [ ] **OPNsense-Cluster operational** (alle 4 OPNsense Running, 15 CARP VIPs aktiv)
- [ ] **VLAN 40 APPS + VLAN 60 BUILD** in OPNsense konfiguriert
- [ ] **HAProxy auf VIP .1** pro VLAN funktioniert (kritischer Pfad)
- [ ] **Samba AD 4 Replicas** mit DNS-Zonen befuellt (`comdare.de`)
- [ ] **GitLab-Server-Container** auf K8s deployt (oder Bare-Metal VM verfuegbar)
- [ ] **SSH-Key fuer Diplomand** in GitLab hinterlegt
- [ ] **redshield WireGuard-Tunnel** zu Fortigate-31G aktiv

Status-Check via Memory `cluster_system_architecture`:
- VLAN 40: Gateway VIP `.1`, OPNsense IPs `.11-.14`
- VLAN 60: ZIH VPN Gateway `51820/udp`, Element NLP API `8443/tcp`

---

## §3 Phase A — Fortigate-31G Konfiguration

### §3.1 Hardware-Pre-Check

- [ ] Fortigate-31G physisch im Rack verbunden
- [ ] Management-IP via DHCP oder Console-Port bekannt
- [ ] Firmware-Stand >= FortiOS 7.4 verifizieren

### §3.2 Konfigurations-Schritte

1. **VLAN-Konfiguration:**
   ```
   config system interface
       edit "vlan40-apps"
           set vdom "root"
           set vlanid 40
           set interface "internal"
           set ip 192.168.40.1 255.255.255.0
           set type vlan
       next
       edit "vlan60-build"
           set vlanid 60
           set interface "internal"
           set ip 192.168.60.1 255.255.255.0
           set type vlan
       next
   end
   ```
2. **Firewall-Policy fuer GitLab-Zugang:**
   - Erlaubt SSH (22) + HTTP/HTTPS (80/443) von VLAN 40 zu GitLab-Server-IP
   - Blockiert WAN → GitLab direkt (nur ueber WireGuard)
3. **WireGuard-Tunnel zu redshield:**
   - Public Key von redshield in Fortigate
   - Allowed-IPs: gesamtes COMDARE-VLAN-Range

### §3.3 Verifikation

- [ ] `ssh root@vlan40-apps.comdare.de` funktioniert (intern)
- [ ] `ssh root@gitlab.comdare.de` funktioniert (intern)
- [ ] `curl https://gitlab.comdare.de` antwortet HTTP/2 200

---

## §4 Phase B — GitLab-Server-Setup

### §4.1 GitLab-Container deployt?

Pruefen:
```bash
kubectl get pods -n gitlab
# Erwartung: gitlab-toolbox, gitlab-webservice, gitlab-sidekiq, gitlab-postgresql, gitlab-redis Running
```

Falls nicht: GitLab-Helm-Chart deployen.

### §4.2 GitLab-LDAP-Anbindung an Samba AD

```yaml
# values.yaml fuer gitlab Helm-Chart
global:
  ldap:
    servers:
      main:
        label: 'COMDARE Samba AD'
        host: 'dc1.comdare.de'
        port: 636
        uid: 'sAMAccountName'
        base: 'ou=users,dc=comdare,dc=de'
        encryption: 'simple_tls'
```

Status: LDAP FUNKTIONIERT seit Session 36 (laut Cluster-Memory).

### §4.3 GitLab-Admin-Account anlegen

- [ ] root-Passwort gesetzt
- [ ] Diplomand-Account `s2631336` (ZIH-Login-Konsistenz) angelegt
- [ ] SSH-Key fuer Diplomand hinterlegt

---

## §5 Phase C — 200+ COMDARE-Module-Push

### §5.1 Module-Inventar

Aktueller Stand der COMDARE-Modules (siehe `C:\Users\benja\OneDrive\Desktop\Projekte\Modules\`):
- `comdare-archiving-all`
- `comdare-binary-analytics-all`
- `comdare-client-all`
- `comdare-config-all`
- `comdare-core-all`
- `comdare-encryption-all`
- `comdare-external-all`
- `comdare-filestorage-all`
- ... (200+ insgesamt)

### §5.2 Push-Skript

```bash
#!/bin/bash
# push_all_comdare_modules.sh — V32 Cluster-Migration

GITLAB_BASE="https://gitlab.comdare.de"
USER="s2631336"
TOKEN="<aus Bitwarden>"

for module in /c/Users/benja/OneDrive/Desktop/Projekte/Modules/comdare-*; do
    name=$(basename "$module")
    # Rename: comdare-X → cd-X (User-Direktive: Projektprefix bleibt rc, beim GitLab-Push wird cd)
    new_name=${name/comdare-/cd-}

    echo "=== Pushing $name → $new_name ==="
    cd "$module"

    # Remote hinzufuegen
    git remote add gitlab "${GITLAB_BASE}/comdare/${new_name}.git" 2>/dev/null
    git remote set-url gitlab "${GITLAB_BASE}/comdare/${new_name}.git"

    # Push aller Branches + Tags
    git push gitlab --all
    git push gitlab --tags

    cd -
done
```

### §5.3 CI-Workflow-Template pro Modul

Pro Modul ein `.gitlab-ci.yml` anlegen mit CI-Pool-Verwendung. Template:

```yaml
stages:
  - build
  - test
  - deploy

build:
  stage: build
  image: comdare/build-toolchain:gcc-13
  script:
    - cmake -B build -DCMAKE_BUILD_TYPE=Release
    - cmake --build build --parallel

test:
  stage: test
  script:
    - ctest --test-dir build --output-on-failure

deploy:
  stage: deploy
  only:
    - main
  script:
    - cmake --install build --prefix /artifacts
```

### §5.4 Verifikation

- [ ] Alle 200+ Module sichtbar in `https://gitlab.comdare.de/comdare/`
- [ ] CI-Pipeline pro Modul erfolgreich (gruene Pipelines im GitLab-UI)
- [ ] LDAP-Login fuer Diplomand funktioniert

---

## §6 Phase D — Diplomarbeit-Repos integrieren

### §6.1 Diplomarbeit-Code (`Diplomarbeit/Code/`)

- Bisher auf GitHub: `BenniProbst/probst-Diplomarbeit-cache-engine`
- Optional: zusaetzlich nach GitLab pushen (Mirror)

### §6.2 comdare-cache-engine + comdare-prt-art

- Bisher auf GitHub: `BenniProbst/probst-comdare-cache-engine` + `probst-comdare-prt-art`
- Optional: zusaetzlich nach GitLab pushen (Mirror, fuer Cluster-CI)

---

## §7 Rollback-Plan (falls etwas schief geht)

- Fortigate-31G-Konfiguration als `.conf` exportiert vor Aenderung
- GitLab-Server hat Daily-Backup auf VLAN 80 BACKUP (Cluster-Architektur Memory)
- COMDARE-Modules sind in OneDrive (lokale Master-Kopie unveraendert)

---

## §8 Post-Migration Health-Check

- [ ] `kubectl get pods -A` zeigt alle Pods Running
- [ ] `gitlab-rake gitlab:check` ohne Fehler
- [ ] Diplomand kann ueber LDAP einloggen + push/pull
- [ ] CI-Pipeline fuer mindestens 5 Sample-Module gruen

---

## §9 Querverweise

- Cluster-Masterplan: `C:\Users\benja\OneDrive\Desktop\Projekte\Cluster\sessions\2026-02-03-architektur-migrations-masterplan-session.md`
- Cluster-Architektur Memory: `cluster_system_architecture`
- VLAN-Liste: in `~/.claude/CLAUDE.md` (COMDARE Cluster - Aktive Konfiguration)
- Element-Automation Cluster-Migration parallel: `C:\Users\benja\OneDrive\Desktop\Projekte\Research\element-automation`

---

**Ende docs/infra/I77_CLUSTER_MIGRATION_FORTIGATE_GITLAB.md (Pre-flight-Spec DONE).**
