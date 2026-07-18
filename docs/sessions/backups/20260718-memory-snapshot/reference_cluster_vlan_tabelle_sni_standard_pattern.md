---
name: reference_cluster_vlan_tabelle_sni_standard_pattern
description: "Cluster-VLAN-Tabelle (aktuelle 10.0.x-Welt) + SNI-Standard-Pattern: Cross-VLAN IMMER ueber die lokale .1-CARP-VIP (OPN-HAProxy, TCP-SNI-Passthrough, 12 SNI-Regeln); V16->SNI->V90 = Soll-Pfad fuer gitlab->dev-MinIO; V90=dev-MinIO (GitLab-Buckets), V91=prod-MinIO (User 07.07.)"
metadata:
  node_type: memory
  type: reference
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**VLAN-Tabelle (aktuelle 10.0.x-Welt; konsolidiert aus Cluster-Ledger + ZIELARCHITEKTUR-v9.2 + LIVE-STATE/KB, 2026-07-07):**

| VLAN | Zweck | Schluessel-Adressen |
|---|---|---|
| V1 | OUTSIDE/Vorraum (VPN-Schicht 1) | FGT-Edge |
| V10 | MGMT | VIP 10.0.10.1 (globale Host-Overrides gitlab/registry/minio/... fuer Hosts); OPN .11/.12; Pi5-Jump .207; prod-BM .211/.212; Switches .241+ |
| V15 | alt prod-CP (VERALTET fuer Nodes) | K8s-API-VIP 10.0.15.250 |
| **V16** | **prod-K8s-Node-VLAN (nach System-Umkehr V15->V16)** + Service-VIP-Ebene fuer Pods | **VIP 10.0.16.1** (CoreDNS-Overrides gitlab+minio zeigen hierauf) |
| V20 | NAS/DMZ-Storage | NAS 10.0.20.101 |
| V30 | Services/Identity | Samba-AD 10.0.30.5, cert-manager .6 |
| V40 | Apps/Ingress (dev-K8s IPPool apps-vlan40) | ingress-nginx 10.0.40.6, gitlab-shell .5, stalwart .7 |
| V50 | DMZ (virtuell auf OPN) | |
| V60 | Build/Runner | VIP 10.0.60.1 (Runner-DNS gitlab/registry/kas) |
| V70/V75 | Sonder/Voice | FritzBox V75 |
| V80 | Backup | longhorn-backup 10.0.80.214-222, IPPool 10.0.80.224/27 |
| **V90** | **dev-Datenbanken + dev-MinIO (hostet die GitLab-Buckets: registry/artifacts/backups/runner-cache dev)** | DB-LBs 10.0.90.51-57, minio-lb 10.0.90.224 (alt .55) |
| **V91** | **prod-DB + prod-MinIO** (longhorn-cold HDD, Replica-2 prod1<->prod2, gitlab-runner-cache prod) | VIP 10.0.91.1 (CARP vhid 91; Split-Brain-Task #72 offen) |
| V99 | VPN (IKEv2) | |
| V100 | BGP-Transit dev (Calico eBGP <-> OPN) | OPN .1-.4, VIP .10 |
| V110/V111 | prod-BGP/ClusterIP-Announce | |
| V120/V121 | (Reorg-Ziel von V110/V130) | |
| V130 | dev-Pod-CIDR-Ebene (pod-vlan130 10.130.0.0/16) | |

**SNI-STANDARD-PATTERN (bindend, User 07.07. bestaetigt):** Cross-VLAN-Zugriffe laufen IMMER ueber die **lokale `.1`-CARP-VIP** des Quell-VLANs (OPNsense-HAProxy, **https-in :443 = TCP-SNI-Passthrough, 12 SNI-Regeln**: www/comdare.de, gitlab, registry, kas, minio, grafana, prometheus, alertmanager, longhorn, dmz-website, mail, monitoring — reboot-fest validiert, KB-027-Saga). Jedes VLAN erreicht so jeden per SNI publizierten Dienst; direkte Cross-VLAN-IPs (z.B. Pod->10.0.90.224) sind isolations-widrig und werden geblackholt/gefiltert. **Konkret: V16 -> SNI -> V90 ist der SOLL-Pfad fuer gitlab-Pods -> dev-MinIO** (das dev-MinIO hostet GitLabs S3; prod-MinIO auf V91 ist strikt getrennt).

**Vorfall 07.07. (Warum dieses Memory):** Ein MinIO-Umbau (~28.06.) setzte den dev-CoreDNS-Override `minio.comdare.de -> 10.0.90.224` (direkte V90-LB-IP) statt auf die VIP -> gitlab-Pods erreichten S3 nicht -> Registry 9 Tage ohne Storage -> Projekt-Transfer-500 (Faraday::TimeoutError beim Registry-Tag-Check). **Fix: Override -> 10.0.16.1** (wie gitlab-Eintrag; CoreDNS-Backups auf node7 + Session-Scratchpad) + Registry-Rolling-Restart -> Transfer OK. Diagnose-Zugang: Pi5-Jump `node7@10.0.10.207` (cluster-Key, CRLF-bereinigen!) + `sudo kubectl --kubeconfig /root/.kube/config` (dev).

**How to apply:** Bei JEDER Dienst-Anbindung aus Pods/Hosts: NIE direkte Cross-VLAN-Service-IPs eintragen — immer die lokale `.1`-VIP + SNI-Hostname. Bei neuen SNI-Diensten: HAProxy-SNI-Regel (Plugin-config, reboot-fest) ergaenzen. dev-MinIO (V90) vs prod-MinIO (V91) nie verwechseln ([[feedback_infra_cleanest_not_easiest]], VLAN-Isolations-Doktrin).
