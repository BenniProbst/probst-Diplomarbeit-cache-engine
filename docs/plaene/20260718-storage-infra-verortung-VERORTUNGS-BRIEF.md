# Verortungs-Brief — Storage #51 Infra (FRISCH, ultracode wf_64c5aeb6)
> 2026-07-18, 4 Agenten, auf AKTUELLEM Cluster-Stand (081ebc4, nach gitlab-Pull). ERSETZT den ersten Lauf (wf_ee4bd609), der 36 Commits stale war. Secrets redigiert.

# Verortungs-Brief — Storage #51 (Cache-Engine Storage-Layering, vor Infra-Aktivierung)

Stand: 2026-07-18 · Scope: 3-Ebenen-Storage A/B/C · CE-Code byte-neutral bis Env gesetzt · Infra = Handover an Infra-Agent (Cluster read-only, Ausnahme nur Caching/Storage-Einrichtung, Ledger §24.B)

---

## 1 — WO STEHE ICH (CE-Design entschieden, codiert vs. pending)

**Entschieden: 3 sauber getrennte Storage-Ebenen, je eigener Endpoint**

| Ebene | Inhalt | Ziel | CE-Arbeit |
|---|---|---|---|
| **A** | Standard-Compiles + CI-Daten (CEB-Host-.o, 9 Pipeline-Executables) | GitLab-Cache dev, Bucket `buildsystem-cache` (V90) | **KEINE** — leben schon im CMake-Build-Tree außerhalb `e4_dir`, unverändert |
| **B** | CEB/Tier-Binary-Artefakte: `perm.dll` + `perm.dll.version` + `result.csv` | MinIO **dev V90** NEU, Bucket getrennt von `buildsystem-cache`; Key = `<build_version>/<stem>/perm.dll(+.version)`, an Algo-Versions-Manifest gekoppelt (gleiche `build_version`-Signatur wie `dll_is_current` lokal), Pull re-verifiziert → stale ABI (5→6) nie reused | **pending** |
| **C** | Messergebnisse: per-Binary `result.csv` + globale `measurements.csv` + PDF/tex | NFS **prod-longhorn-6TB** NEU (V91), POSIX `std::filesystem::copy` an `COMDARE_MEASUREMENT_NFS_ROOT`, additiv/sha256-verify | **pending** |

**Bereits codiert (im Code verifiziert vorhanden — die Einhänge-Naht existiert):**
- `cache_engine_builder_iterator.hpp:714` — `provision_all` = Phase A (BAU, multithreaded)
- `:734` — Mess-For-Loop (Phase B, 1-Thread)
- `:893-897` — `result.csv`-Write (`csv_write_ok`)
- `:904-908` — `result.csv.stamp` nach verifiziertem Write
- `:911` — RAII-DLL-Unload-Kommentar → **die Einhänge-Stelle** liegt zwischen Stamp-Write und Unload
- `profile_run_entry.hpp:426` — `csv.flush` = Whole-run-Sink-Punkt (plan-425)
- `build_orchestrator.hpp:332` — `dll_is_current(job.output, build_version, algos)` = Pull-Punkt (Warm-Cache in Phase A, parallel-unbedenklich)
- `build_orchestrator.hpp:126-127, :227` — `CompileFn`/`SourceGenFn` (`std::function`, injiziert) = **Muster-Präzedenz** für die No-Op-Injektion

**Pending (grep = 0 Treffer in `Code/external/comdare-cache-engine`; nichts gebaut):**
- `builder/artifact_transport/artifact_cache.hpp` — schmale C++-Klasse, synchron `mc cp`, Retry/Größen-Verify nach Muster `scripts/copy_results_to_nas.sh:24-40`; Vollständigkeits-Marke: `perm.dll` ZUERST, `.version` ZULETZT (halb-gepusht = kein Sidecar = kein Pull); Fehler → `InfraErrorClass::ArtefaktIo` loggen, lokale Kopie behalten, **MESSEN WEITER** (`grep artifact_cache = 0`)
- `CachePushFn` + `MeasurementSinkFn` (Default No-Op) auf Iterator-cfg + `RunProfileArgs`/`ExperimentRunArgs`, durchgereicht über `profile_run_facade.cpp` (Spiegel `out_csv`-Passthrough) (`grep = 0`)
- Push/Sink-Call an der Naht (`:900`) + Whole-run-Sink an `:426` — Injektion outstanding
- Env-Wiring `COMDARE_MINIO_ENDPOINT/_BUCKET/_PREFIX` (B) + `COMDARE_MEASUREMENT_NFS_ROOT` (C), getrennt von `COMDARE_CACHE_ROOT` (A/ccache); `artifact_cache::from_env` in `messung_driver/main.cpp` auf `xa`/`pa` (`grep COMDARE_MINIO/NFS = 0`)

**Schreib-Naht-Doktrin (entschieden):** Push (B→minio) + Sink (C→NFS) beide **synchron/blockierend** zwischen zwei Messungen, NIE parallel/async/detached (I/O-Contention = Messfehler). Whole-run-CSV → NFS nach `csv.flush`. **Anti-Phantom:** ALLE Env-Vars leer → No-Op → golden/CI byte-neutral.

---

## 2 — CLUSTER-IST (autoritativ, LIVE)

> **WARNUNG:** `/docs/02_NETZWERK_VLAN_PLAN.txt` ist ein **veraltetes v5-PLAN**-Dokument (10.10.x.x, V40=STORAGE). Der LIVE-Cluster nutzt **10.0.x.x**. Für Storage-Provisionierung NICHT die `.txt` verwenden. Autoritativ: `agent-memories-infra/INFRA-AGENT-MEMORIES-KONSOLIDIERT-20260708.md`.

**VLANs (LIVE, strikt isoliert; Gateway = `.1` CARP-VIP auf OPN, OPN-IPs `.11–.14`):**
- V10 MGMT `10.0.10.0/24` · V15 K8S-API · V20 STORAGE (GlusterFS/NFS) · V60 BUILD/CI (extern geteilt) · V80 BACKUP (Longhorn/Offsite) · V90 DATABASE (PostgreSQL/Redis/**MinIO**/Kafka) · **V100 SYNC — TABU** · V110/V120/V130 Calico dev · V111/V121/V131 = prod-Spiegel
- Spiegel-Doktrin VN0↔VN1: V90↔V91 (DB), gleiche V10-Rechte je Pendant

**dev-MinIO (Ziel Ebene B):**
- ns `databases`, Deployment replicas=1 (Recreate) auf Longhorn-PVC `minio-data` 500Gi, SC `longhorn-database` (Rep4/Retain)
- MetalLB-LB **`10.0.90.224:9000`** (Console 9001), HAProxy-Backend `be-minio-v90`
- DNS: `minio.comdare.de` → `minio.comdare.local` (Realm-Split 2026-07-12), Views V40/V60 → `.1`; :443-SNI → `be-minio-v90`
- Runner-Cache: `minio-s3-FE` bind `10.0.60.1:9000`, Bucket `buildsystem-cache` (= Ebene A, unangetastet)
- Buckets dev (K46-Audit): `buildsystem-artifacts` (16 GiB), `gitlab-artifacts`, `buildsystem-cache` (17 GiB/7778 Obj), Rest leer; **alle `policy=private` (S3v4-Auth Pflicht)**

**prod-MinIO (nicht Ziel für B):** separater Stack `minio.prod.comdare.de`, Backend `be-minio-prod` via Calico-ClusterIP `10.32.243.80:9000` über V111-BGP (KEIN V91-LB), Bucket `gitlab-runner-cache`. **#141 prod-MinIO-Separation OFFEN/gated** (an PROD-Cutover Phase 6-7 gebunden).

**Longhorn:**
- dev: 4 Talos-Nodes, ~1.6–1.7 TiB/Node NVMe; **Over-Provisioning gehärtet 300%→100%, `storageReserved` 350G/Node** (#234-Incident) → usable ~1394–1448 G/Node
- prod-6TB (Ziel Ebene C): Hotstore `/var/mnt/hotstore` (NVMe p5) + **Coldstore `/var/mnt/coldstore` = 6TB-WD-HDD via vfio (diskType=sat)**, RAID1/**Replica-2 über prod1+prod2**

**NFS-Landschaft:**
- Ganesha bare-metal auf V20 (Gruppen A/B/C `10.0.20.211-.213`, Keepalived) — **instabil (GLUSTER-FSAL SEGV)** → R/O-Pods nutzen **FSAL VFS + Graceless=true**
- Longhorn-Backup-NFS auf V80 (`10.0.80.214`, MetalLB, K8s-only)
- NAS `backup1` (PR4100, `/Cluster_NFS`) = Haupt-Backup-Ziel, V10-CARP-VIP `10.0.10.243`; **Cluster-Backups NIE auf Knoten**
- **Bestehender Mess-Rückschreibpfad:** V60-Runner dürfen `Cluster_NFS` NIE lesen → write-only über **Filterpod ns `measure-drop`, VIP `10.0.80.226`**, `PUT https://measure-drop.comdare.local/<ts>/<datei>`, NFS nfsvers=3

**prod-Storage-Gate:** **prod2-Recovery (etcd 3/3 + 2-Node-Longhorn) = Universal-Gate für ALLE prod-Mutationen**, vor UND nach jedem Schritt. Off-Cluster-DR (#208/#209) ready-not-done.

**VLAN-Routing-Doktrin:** DB = Heimat auf DB-VLAN (dev V90/prod V91); Cross-VLAN-Konsum **ausschließlich via Samba-AD-DNS (FQDN → Konsumenten-`.1`) + `.1`-SNI-HAProxy über OPN**. KEINE dedizierten internen VIPs (einzige Ausnahme: DMZ V40). Direkt `:9000`/ClusterIP/Cross-VLAN-Direkt-IP = **blackholed**.

**OPN-HAProxy:** beide OPN (opn-1 MASTER/opn-2 BACKUP) os-haproxy-gerendert, reboot-fest; **`config.xml` = Single Source of Truth**; ein zentrales SNI-Frontend `https-in` bind `*:443` mode tcp/SNI-Passthrough trägt gitlab/registry/kas/harbor/minio.comdare.de/minio.prod/backup1/2/monitoring. **Offener OPN-Bug #72:** CARP vhid-91 Split-Brain (beide MASTER für `10.0.91.1`, V91-L2-Trunk fehlt) — latent (V91 ungenutzt, prod-MinIO läuft via V10/`.1`-SNI), Fix P0-riskant/geplant.

**Zugang:** OPN nur vom Laptop via `ssh -i ~/.ssh/cluster root@10.0.10.11` (opn-1) / `.12` (opn-2), csh-Wrapping. node7 (root, dev+prod-kubectl+prod-talosctl) hat den OPN-Key NICHT. P0-Gate = `gitlab.comdare.de/users/sign_in` = 200.

---

## 3 — PROVISIONIERUNG (geordnet, Constraint je Schritt)

**0 · Pre-flight** — `config.xml` auf BEIDEN OPN sichern (`cp -n .../config-<tag>-preprov.xml`); GitLab-P0=200 + CARP-MASTER-count als Baseline. *Constraint:* OPN-Zugang nur Laptop-cluster-Key + python3-ElementTree (idempotent, `.new` validieren, `os.replace` atomar); node7 scheidet aus.

**A — Ebene B / MinIO dev-V90**
- **1 · Bucket** für Tier-Binaries anlegen (analog `buildsystem-artifacts`), Versioning/immutability additiv. *Constraint:* Heimat bleibt V90; KEINE Bucket-VIP im Fremd-VLAN; Additiv-Doktrin (nie löschen/überschreiben); getrennt von `buildsystem-cache`.
- **2 · Service-Account** minimal-scoped, Policy strikt auf diesen Bucket (kein globaler Zugriff), projekt-lokal rotierbar (Muster Write-Token id=54). *Constraint:* Secret-WERTE nie im Klartext — nur Namen (`MINIO_ACCESS_KEY`/`MINIO_SECRET_KEY`).

**B — Ebene C / NFS prod-longhorn-6TB (GATED: prod2-Recovery)**
- **3 · Volume + K8s-NFS-Provisioner-Pod** (`registry.k8s.io/sig-storage/nfs-provisioner`, FSAL VFS + Graceless=true, MNT_Port 20048), Export-Service an **V80-BACKUP** (fußt auf V20). *Constraint:* Longhorn kontaktiert NIE Bare-Metal-Ganesha; kein roher V16→V20:2049-Direktpass.
- **4 · Export auf Subpfad jailen** `cache-engine-experiment/`, append/create-only, Pfad-Jail (`..`/abs/Symlink), Consumer-Mount → `measurement/<YYYYMMDD-HHMMSS>/`. *Constraint:* MetalLB-L2-Falle — nur `mount -t nfs -o vers=4,port=2049` beweist Erreichbarkeit (ping/showmount täuschen); additiv (Konflikt → kein Overwrite).

**C — SNI-Browse-Route (Cross-VLAN Sicht aus V10)**
- **5 · os-haproxy-Objektkette** auf beiden OPN per `php-Model->Add()` (separate php-Prozesse): server → backend(linkedServers) → acl(ssl_sni) → action(use_backend) → `https-in`.linkedActions; Frontend bind `*:443` mode tcp passthrough auf `10.0.10.1`, Backend = Browse-ClusterIP (OPN routet 10.32/16 via Calico-BGP). *Constraint:* `.1`-SNI-Pflicht, keine dedizierte VIP; Objekte MÜSSEN in `config.xml` (roher ElementTree-Klon rendert nicht).
- **6 · Split-Horizon-DNS** — Samba-AD-Record (nur Pi5/DC) + OPN-Unbound-Override FQDN → `10.0.10.1`; `checkconf` vor `configctl unbound restart`. *Constraint:* DNS nur vom Pi5/DC, nie samba-tool/kubectl auf OPN; Browse-UI nur auf V10.
- **7 · HAProxy-Deploy** — `configctl template reload OPNsense/HAProxy` (→ `haproxy.conf.staging`, NICHT live) → `haproxy -c -f ...staging` → Live-Backup → graceful `haproxy -q -f ...conf -p /var/run/haproxy.pid -sf $(cat pid)`. *Constraint:* opn-1 `configctl haproxy reload` scheitert STILL → manueller `-sf`; NIE `service haproxy start`/`setup.sh deploy`.
- **8 · Beide OPN separat** (eigene UUIDs, kein XMLRPC-HAProxy-Sync), name/ssl_sni-getrieben. *Constraint:* opn-1 = SPOF-nähe (fronted P0 GitLab/LDAP); beide reboot-fest.

**D — Credentials**
- **9 · protected + masked CI-Vars** in super (Projekt 288): `MINIO_ACCESS_KEY`, `MINIO_SECRET_KEY`, `COMDARE_NFS_DROP_TOKEN`, minimal-scoped, rotierbar; Consumer-Job `persist:measurements` inert bis Feature-Flag. *Constraint:* nur Namen, nie Werte; protected → nur protected-Branches; Runner braucht `ref_protected`.

**E — Verifikation**
- **10 · E2E + Cleanup** — aus echtem V10-Host: `openssl s_client -servername <fqdn> -connect 10.0.10.1:443` zeigt echtes Backend-Cert (Fake „Kubernetes Ingress" = default_backend); MinIO-PUT/GET ok; NFS schreibt `measurement/<ts>/`; aus V60-Kontext GET/LIST/DELETE → 403/405, PUT neu → 201, PUT dup → 409. *Constraint:* kein Erfolgs-Haken ohne wörtliche Ausgabe; am Zyklusende alle Hilfs-Shells/Monitore beenden.

---

## 4 — HARTE CONSTRAINTS / FALLEN

1. **HAProxy NIE `stop`/`start`** — löst SO_REUSEPORT-Straggler (#35) + stale-pidfile-silent-fail → `:443`-P0 (harbor/`.1`-SNI intermittierend tot). Sichere Aktivierung: `pkill -9 haproxy` (2-3× bis `pgrep` leer) + `rm -f /var/run/haproxy.pid /var/run/haproxy.socket` + `configctl template reload` + EINE direkte Instanz + pidfile syncen.
2. **Render ≠ Live** — `template reload` schreibt nur `haproxy.conf.staging`; Promote nur graceful `-sf`. opn-1 (syshook, nicht rc-enabled) friert Live STILL ein. NIE `service haproxy start`/`setup.sh deploy` (Legacy-Template-Clobber).
3. **Hand-Edits an Live-`haproxy.conf`** ohne `config.xml`-Objekt werden beim nächsten Promote + Reboot gelöscht. Immer `php-Model->Add()`.
4. **opn-1 = SPOF-nähe** (fronted P0 GitLab/LDAP), kein XMLRPC-Sync → beide OPN separat pflegen.
5. **`.1`-SNI-Pflicht Cross-VLAN** — jede VLAN-Grenze = OPN-HAProxy-SNI auf Konsumenten-`.1` (mode tcp passthrough) + Firewall-Pass; KEINE internen Per-Service-VIPs (Ausnahme DMZ V40); kein roher Cross-VLAN-Direkt-IP-Pass; `:9000`/ClusterIP direkt = blackhole.
6. **Storage-Service-Kette** — V70/V80 fußen auf V20 und greifen via `.1`-SNI; Backup an V80-BACKUP-NFS-Service, NICHT direkt an V20-NAS-IP `10.0.20.101`; kein V16→V20:2049-Direktpass.
7. **Mgmt-/Browse-UIs nur auf V10**; Speicherprotokolle (SMB/NFS/iSCSI) nur V20+V80.
8. **Cluster read-only — Ausnahme nur Caching/Storage-Einrichtung** (Ledger §24.B). Impl-Agent hat kein sudo → ALLE Infra-Mutationen (config.toml, OPN, K8s, NAS) = Handover an Infra-Agent.
9. **Write-only-Semantik** — V60-Runner (extern geteilt) sehen/lesen `Cluster_NFS` nie; nur PUT unter `cache-engine-experiment/<ts>/`; GET/LIST/DELETE → 403/405; dup → 409; Pfad-Jail gegen Traversal.
10. **Additiv-Doktrin** — Mess-/Rohdaten strikt additiv, nie `rm`/overwrite.
11. **Secrets** — nie Klartext in Report/Repo/Log; nur Variablen-NAMEN; protected + masked, minimal-scoped, rotierbar (Muster id=54).
12. **NAS nur lesend/Switch-Port-seitig** — kein NAS-UI-Eingriff (IP-Renumber = User-Sache).
13. **MetalLB-L2-Falle** — ping/showmount täuschen auf L2-VIPs; nur `mount -t nfs -o vers=4,port=2049`.
14. **Ganesha instabil** (GLUSTER-FSAL SEGV) → FSAL VFS + Graceless; Longhorn kontaktiert Bare-Metal-Ganesha NIEMALS (nur K8s-Pod).
15. **OPN-Config nur Laptop-cluster-Key** + csh-Wrap + python3-ElementTree, `config.xml` zuvor sichern; DNS nur Pi5/DC.
16. **Nach JEDER Mutation** harte Verifikation mit wörtlicher Ausgabe: GitLab-P0 → 200, CARP-MASTER-count unverändert, echtes Backend-Cert via `openssl s_client -servername`.

---

## 5 — OFFENE FRAGEN / ENTSCHEIDUNGEN (vor Infra-Aktivierung)

1. **Transport-Wahl B** — `mc`-Shellout (empfohlen, Template `scripts/copy_results_to_nas.sh`, kein Python) vs. libcurl+SigV4 vs. aws-sdk-cpp (plan §6). **Blockiert `artifact_cache.hpp` — zuerst entscheiden.**
2. **Transport-Modell C — Konflikt im Design:** DESIGN sagt „POSIX `std::filesystem::copy` an `COMDARE_MEASUREMENT_NFS_ROOT` (kein Client, Mount=Infra)", die bestehende Write-back-Infra (Schritt 9, `measure-drop`) nutzt aber `curl -T` HTTPS-PUT. **Zwei unvereinbare Modelle — festlegen: POSIX-Mount-Copy (neuer Export) ODER Wiederverwendung des existierenden `measure-drop`-Write-only-Pfads (V80 Filterpod).**
3. **Ziel-VLAN C — prod V91 gated + #72-blockiert:** DESIGN will C auf prod-longhorn-6TB/**V91**, aber (a) prod-Mutationen sind hinter dem prod2-Recovery-Universal-Gate, (b) **OPN-Bug #72 (vhid-91 Split-Brain) macht V91 latent-unbrauchbar**, (c) es existiert bereits der `measure-drop`-Pfad über V80. **Entscheiden: Neu-Export auf V91 (gated, #72-abhängig) vs. bestehender V80-`measure-drop` als C-Sink.**
4. **Routing-Bestätigung** (plan §6): Binaries → **DEV-V90**-MinIO UND Messergebnisse → **prod-NFS-V91** explizit bestätigen — Kreuzung dev/prod ist ungewöhnlich.
5. **Bucket-Immutability-/Versioning-Policy** exakt = Infra-Konvention, nicht raten (plan §7-GAP).
6. **NFS-Export-Konvention + VLAN10-Browse-SNI-FQDN** = Infra-Handover, nicht raten (plan §7-GAP).
7. **prod-MinIO #141** bleibt OFFEN — für Ebene B irrelevant (B → dev-V90), aber falls je prod-MinIO nötig: gated.

---

## 6 — EMPFOHLENE REIHENFOLGE

**Phase I — CE-Seite zuerst, byte-neutral (keine Infra nötig, golden/CI bleiben grün):**
1. **Transport-Entscheid** (Offene Frage 1) → `builder/artifact_transport/artifact_cache.hpp` bauen (synchron `mc cp`, Retry/Größen-Verify, `.version` ZULETZT, Fehler → `InfraErrorClass::ArtefaktIo` + weitermessen).
2. `CachePushFn` + `MeasurementSinkFn` (Default No-Op) auf Iterator-cfg + `RunProfileArgs`/`ExperimentRunArgs` — 1:1 nach `CompileFn`/`SourceGenFn` (`build_orchestrator.hpp:126-127,227`), durchgereicht über `profile_run_facade.cpp`.
3. Naht-Calls injizieren: Push+Sink synchron an `cache_engine_builder_iterator.hpp:~900` (nach `stamp`-Write `:904-908`, vor RAII-Unload `:911`); Whole-run-Sink an `profile_run_entry.hpp:426` (nach `csv.flush`); Pull an `build_orchestrator.hpp:332` (`dll_is_current`, Phase A).
4. `artifact_cache::from_env` in `messung_driver/main.cpp` (`xa`/`pa`); Env-Namen `COMDARE_MINIO_ENDPOINT/_BUCKET/_PREFIX` + `COMDARE_MEASUREMENT_NFS_ROOT`, getrennt von `COMDARE_CACHE_ROOT`.
5. **Byte-Neutralität beweisen:** ALLE Env leer → No-Op; golden-Lauf + CI unverändert grün (Anti-Phantom). Review + Backup. → Diese Phase braucht KEINEN Cluster-Zugriff.

**Phase II — Infra behutsam (Handover an Infra-Agent, gated-Reihenfolge):**
6. Offene Fragen 2–6 auflösen (Transport-Modell C, Ziel-VLAN C, Routing-Bestätigung, Policies/Konventionen) — nicht raten.
7. Provisionierung Schritt 0 (Pre-flight/Backup/P0-Baseline) → **A/MinIO-B zuerst** (Schritt 1-2, dev-V90, ungegated) → **C/NFS** (Schritt 3-4, prod-gated: erst prod2-Recovery-Gate prüfen ODER `measure-drop`-Weg wählen) → **SNI-Browse-Route** (Schritt 5-8, beide OPN separat, php-Add, staging→graceful `-sf`) → **DNS** (Schritt 6) → **Credentials** (Schritt 9, super 288, inert) → **E2E-Verifikation + Cleanup** (Schritt 10).
8. Nach jedem Infra-Schritt: GitLab-P0=200 + CARP-MASTER-count + echtes Backend-Cert wörtlich verifizieren.

**Kern:** Phase I ist vollständig ohne Cluster-Berührung machbar und liefert einen messbaren, byte-neutralen Zustand; erst danach die gegated/`.1`-SNI-empfindliche Infra aktivieren.