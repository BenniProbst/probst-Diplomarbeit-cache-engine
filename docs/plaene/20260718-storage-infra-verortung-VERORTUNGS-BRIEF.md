# Verortungs-Brief — Storage #51 Infra (ultracode wf_ee4bd609)
> 2026-07-18, 4 Agenten. Verortung vor Infra-Arbeit (Direktive: vor Infra immer ultracode über Themen-Sessions). Secrets redigiert.

# Verortungs-Brief — Storage #51 (vor Infra-Arbeit)

Stand 2026-07-18 · Deadline 28.07. · Governance: **VOLLES GO** (Ledger §24.A schlägt den GATED-Doc-Kopf; §24.B lockert „Cluster read-only" ausnahmsweise für Caching+Storage-Einrichtung). Bau-Doktrin: VOR-ultracode-Planung → Bau → NACH-Konformitätsprüfung.

---

## 1 · WO STEHE ICH (CE-Design)

**Drei Speicher-Ebenen, klar getrennt:**

| Ebene | Ziel | Status | Kern |
|---|---|---|---|
| **A** Standard-Compiles + CI-ccache | dev-MinIO `buildsystem-cache` via `runners.cache` | **DONE** | Bestehende Infra, KEINE CE-Änderung (`.gitlab-ci.yml:34`) |
| **B** CEB/Tier-Binary-Artefakte | minio dev-V90, eigener Bucket | **PENDING** | Objekt-Key `<build_version>/<stem>/perm.dll(+.version)`, an Algo-Versions-Manifest gekoppelt |
| **C** Messergebnisse (result.csv, measurements.csv, PDF/tex) | NFS prod-longhorn-6TB (V91) | **PENDING** | POSIX-copy an `COMDARE_MEASUREMENT_NFS_ROOT`, additiv/sha256-verify |

**Bereits GELANDET (via caching-impl, byte-neutral):** das Injektions-Muster ist LIVE — `AlgoSigFn` als 4. Ctor-Arg injiziert (`cache_engine_builder_iterator.hpp:708-712`), `algo_sidecar_path()` + `dll_is_current(output,version,algo_sig)` mit Organ-Gate (`build_orchestrator.hpp:~185/~193`), per-Binary Resume-Stamp `|algos=<sig>` (`:731`). Die Ebene-B-Key-Kopplung nutzt exakt dieselbe Signatur, die `dll_is_current` lokal prüft → Pull re-verifiziert → stale ABI (5→6) nie reused.

**Noch zu codieren (CE-Seite, alles No-Op-injiziert):**
- Naht-Felder `CachePushFn` + `MeasurementSinkFn` (Default No-Op) auf Iterator-cfg + `RunProfileArgs`/`ExperimentRunArgs` — Muster wie `CompileFn`/`SourceGenFn`/`AlgoSigFn` (grep = 0 Treffer, existiert nicht).
- `builder/artifact_transport/artifact_cache.hpp` — schmale synchrone C++-Klasse, mc-Shellout (grep = 0, existiert nicht).
- `artifact_cache::from_env` in `messung_driver/main.cpp` auf xa/pa; Durchreichen in `profile_run_facade.cpp`.
- Objekt-Key-Ableitung (aus `build_version`/`stem`); NFS-Sink.

**Naht-Punkte existieren, nur Push/Sink-Aufruf fehlt:** Phase A `provision_all` multithreaded (`cache_engine_builder_iterator.hpp:712`), Phase B 1-Thread for-loop (`:731`), `result.csv` write (`:893`), `.stamp` (`:905`), RAII-DLL-unload = Naht-Ende (`:911`); Whole-run `csv.flush` (`profile_run_entry.hpp:426`). **Push+NFS-copy SYNCHRON an der Naht, VOR RAII-Unload; async/detached VERBOTEN** (I/O-Contention-Messfehler).

**Byte-Neutralität (Anti-Phantom):** alle env-Vars leer → No-Op → golden/CI unverändert.

**Fehlerklassen-Träger vorhanden:** `measurement/axis_error.hpp` (`BuildError = variant<InfraError,CompilerCompilerError>`) → `InfraErrorClass::ArtefaktIo`. Doktrin: Push-/NFS-Fehler loggen, lokale Kopie behalten, **MESSEN WEITER** (nie „measured=0").

---

## 2 · CLUSTER-IST

**VLAN-Isolation:** 15 VLANs strikt isoliert; Cross-VLAN NUR über OPNsense pf + HAProxy (bindet CARP-VIP `.1` je VLAN). Subnetz `10.0.<vlan>.0/24`, VIP `.1`, OPN `.11-.14`. V20=STORAGE (GlusterFS/NFS), V80=BACKUP (Longhorn), **V90=DATABASE (MinIO)**. Split „prod = dev+1": **V90 dev-DB ↔ V91 prod-DB**.

**Cross-VLAN-SNI-Muster:** DB = Service-Produzent, Heimat = OPN-HAProxy-CARP-VIP auf DB-VLAN, Backend = Calico-Self-Announce (BGP). Konsument im Fremd-VLAN via Samba-AD-DNS (Name → Konsumenten-VLAN-`.1`) + `.1`-SNI → OPN-HAProxy (mode tcp Passthrough, echtes comdare-ca-Backend-Cert).

**dev-MinIO EXISTIERT (Ebene-B-Ziel):** NS `databases`, MetalLB `10.0.90.55:9000/9001`, BGP-Backend `10.0.90.224`, 4 Replicas gesund. TLS von comdare-ca, SAN `minio.comdare.de`. Storage = 500 GiB Longhorn-PVC `minio-data` (SC `longhorn-database`, R4). Bestehende Buckets: `buildsystem-artifacts` (~16-17 GiB), `buildsystem-cache`, `gitlab-*`. CI-Access-Key-Name = `bsci-artifacts` (Secret redigiert).

**prod-MinIO:** `minio.prod.comdare.de → 10.0.10.1 → OPN-HAProxy-SNI → 10.32.243.80:9000` (prod-K8s-ClusterIP), LIVE als Cache-Backend (K81-61).

**prod Cold-Storage 6TB LIVE (#140 DONE, Ebene-C-Ziel):** beide prod-Nodes Talos `coldstore` = 6TB SATA-HDD XFS `/var/mnt/coldstore`; Longhorn cold-Disk (Tag `cold`), SC `longhorn-cold` (R2, **Retain**). ALLE PVC = Retain (Löschung nur mit User-OK).

**NFS-Ist:** Longhorn-Backup-NFS `10.0.80.223:/backup/longhorn` (V80). NFS-Ganesha-VIPs `.211-.218`; **Ganesha instabil** (GlusterFS-FSAL SIGSEGV) → VFS-FSAL bevorzugt. Der Ebene-C-Export auf prod-6TB ist **KOMPLETT NEU** — kein Repo-Vorbild (V20-NAS/V80-longhorn-backup sind NICHT prod-6TB).

**OPN-HAProxy:** Config als base64 in `config.xml <haproxy_custom>` (Plugin disabled), ~29 FE/32 BE/32 SRV. Ports 80/443-SNI (~12 Hosts)/2222/6443/5901-04/8822. opn-1=CARP-MASTER, opn-2=BACKUP, beide reboot-fest, active/active (BGP+HAProxy+pf).

**⚠ OFFENES OPN-Risiko #72 (V91-relevant):** beide OPN sind MASTER auf `10.0.91.1` (prod-DB-VLAN-VIP), da VLAN-91-L2 zwischen den OPN fehlt → latentes P0-Trunk-Risiko. Direkt relevant für prod-V91-Provisionierung; User-Direktive = L2-Fix planen (kein Band-Aid).

**Security:** Infra-Docs enthalten Live-Secrets — hier durchweg redigiert, nur Namen/Muster.

---

## 3 · PROVISIONIERUNG (geordnet, Constraint je Schritt)

**0 · Preflight.** Cluster-Ledger #202 (NAS/MinIO-Writeback) + #156 lesen; beide `config.xml` sichern (`cp -n /conf/config.xml /conf/config.xml.bak-<tag>`); Baseline festhalten (GitLab-P0 = 200, CARP-MASTER-Count je OPN, Switch-Mgmt OPEN). — *Constraint: read-only außer Storage-Ausnahme; OPN NUR vom Laptop via `~/.ssh/cluster` (node7 hat den Key nicht); csh → `sh -c "…"`.*

**1 · MinIO-Bucket dev-V90** (z.B. `cache-engine-tier-binaries`) auf bestehender Instanz, getrennt von `buildsystem-cache`; Objekt-Layout versioniert je Organ-Algo. — *Constraint: MetalLB-Heimat-IP bleibt unberührt (Service-HA); KEINE dedizierte Cross-VLAN-Präsentations-VIP im Fremd-VLAN.*

**2 · Minimal-scoped MinIO-Credential-Paar** (`MINIO_ACCESS_KEY`/`MINIO_SECRET_KEY`), Policy nur Tier-Binary-Push/Pull, kein Admin, kein Cross-Bucket. — *Constraint: NIE Klartext lesen/ausgeben; rotierbar ohne Admin-PAT (Vorbild write_repository-Token id=54).*

**3 · Samba-AD-DNS-Record** (z.B. `tier-cache.comdare.de`/`measure-drop.comdare.de`) als A-Record → `10.0.10.1`, via `samba-tool dns add` NUR von Pi5/DC; OPN-Unbound-Split-Horizon-Override name→`.1`. — *Constraint: Name löst auf Konsumenten-`.1`-CARP-VIP, NIE auf Service-Heimat-MetalLB-IP; samba-tool/kubectl NIE auf der OPN.*

**4 · os-haproxy-Objekte für `.1`-SNI-Route** auf opn-1: sequenzielle separate-Prozess `php-model-Add()` in Reihenfolge server → backend → acl(ssl_sni) → action(use_backend) → frontend-`https-in`-Link. — *Constraint: roher ElementTree-Klon rendert NICHT (VALIDATION OK trügt); JEDES Objekt eigener php-Prozess; acl/action haben KEIN enabled-Feld.*

**5 · STAGING rendern + graceful Softreload** auf opn-1: `configctl template reload OPNsense/HAProxy` → validieren `haproxy -c -f …staging` → Live-Backup → `haproxy -sf $(cat /var/run/haproxy.pid)`. — *Constraint: NIE stop+start; opn-1 syshook-gestartet (nicht rc-enabled) → `configctl haproxy reload` scheitert STILL; NIE `service haproxy start` (Legacy-Format clobbert Objekte).*

**6 · Route auf opn-2 spiegeln** (eigene UUIDs). — *Constraint: opn-1 = SPOF ohne Parität; beide OPN handgepflegt (kein XMLRPC-Sync); Hand-Edits ohne config.xml-Objekt löscht ein staging→live-Promote.*

**7 · NFS-Export prod-longhorn-6TB** STRIKT auf Mess-Subpfad (`cache-engine-experiment/`), nie NFS-Root; V80-Filterpod (IPPool `10.0.80.224/27`) einzige Komponente mit Mount. — *Constraint: exakter Volume-/Export-Pfad aus Ledger #202/#156 (nicht raten); Subpath-only; kein V20-/prod-Storage-Vollzugriff (externe Mandanten).*

**8 · Write-only-SNI-Drop** (`measure-drop.comdare.de`) über V80-Filterpod (nginx-dav-ext PUT-only oder MinIO-Gateway write-only), nur aus V60-Runner-Kontext via `10.0.60.1`. — *Constraint: GET/LIST/DELETE → 403/405, nur PUT → 201; direkte V20-/V80-IP aus V60 geblockt (NetworkPolicy-Nachweis).*

**9 · Pfad-Jail + Additiv-Doktrin** am Filterpod: nur unterhalb `cache-engine-experiment/`; Traversal (`..`/absolut/Symlink) → 403; existierende Datei NIE überschreiben → 409. — *Constraint: Rohdaten strikt additiv, nie rm/überschreiben; Fehlversuch sichtbar (Log neben Datei), nicht stumm.*

**10 · Credentials als protected+masked CI-Var in super (288):** `MINIO_ACCESS_KEY`/`MINIO_SECRET_KEY`/`COMDARE_NFS_DROP_TOKEN`. — *Constraint: nur Namen im Log; keine embedded PATs in Remote-URLs/.gitmodules.*

**11 · Consumer-Seite verdrahten, INERT bis Enable-Flag:** `persist:measurements`-Job schreibt bereits nach `measurement/<YYYYMMDD-HHMMSS>/`; Phase 2 = `curl -T` an SNI-Endpoint + Tier-Push/Pull, gated hinter `COMDARE_PERSIST_MEASUREMENTS`. — *Constraint: CI-Grün = Persist/Messung AUS; nur opt-in + Loop-Schutz; gesamte Pipeline hart grün.*

**12 · Abschluss-Verify + Rollback:** nach jeder Mutation GitLab-P0 = 200, SNI-openssl = echtes Backend-CN auf beiden OPN, CARP-MASTER-Count unverändert; aus Runner PUT → 201 / GET/LIST/DELETE → 403/405 / 2. PUT → 409; Rollback = `config.xml.bak-<tag>`. — *Constraint: kein ✓ ohne wörtliche Ausgabe; V10 nie >10s ohne Rollback.*

---

## 4 · HARTE CONSTRAINTS / FALLEN

1. **OPN-HAProxy NIE `stop`+`start`** — löst SO_REUSEPORT-Straggler (#35: mehrere haproxy teilen `*:443`, SNI intermittierend leer, killall erwischt nicht alle) + stale-pidfile-Silent-Fail (Rückgabe OK, kein Prozess) → `:443`-P0 (harbor/`.1`-SNI tot). Sichere Aktivierung: `pkill -9 haproxy` (2-3× bis `pgrep` leer) + `rm -f /var/run/haproxy.pid /var/run/haproxy.socket` + `configctl template reload` + EINE Instanz + pidfile syncen.
2. **Render ≠ Live** — `configctl template reload` rendert nur `…STAGING`; Live-Promote = graceful `haproxy -sf`. opn-1 nicht rc-enabled → `configctl haproxy reload` friert Live-Datei still ein. NIE `service haproxy start` (Legacy-Format clobbert frische Objekte).
3. **`.1`-SNI-Pflicht Cross-VLAN** — JEDER VLAN-übergreifende Zugriff ausschließlich über Konsumenten-`.1`-CARP-VIP + Samba-Split-Horizon-DNS + OPN-HAProxy-SNI (tcp-Passthrough). KEINE Cross-VLAN-Präsentations-VIPs im Fremd-VLAN (V10-Storage-VIPs `.243/.244` sind als falsch markiert); direkte Cross-VLAN-L3-IP = blackholed/isolations-widrig; `:9000`/ClusterIP-direkt = blackhole.
4. **opn-1 = SPOF** solange opn-2 keine Parität hat — jede SNI-Route auf BEIDEN config.xml mit eigenen UUIDs; nur als os-haproxy-Objekt (kein Hand-Edit, sonst staging→live-Promote + Reboot löscht ihn).
5. **os-haproxy nur via php-model-`Add()`** (sequenziell, je Objekt eigener Prozess) — roher ElementTree-Klon rendert nicht (VALIDATION OK trügt); acl/action ohne enabled-Feld.
6. **Cluster strikt read-only, EINZIGE Ausnahme** = bewilligter Storage-Writeback (PUT-only auf gejailten `cache-engine-experiment/` über V80-Filterpod). Jede andere ändernde Infra-Aktion (HAProxy/DNS/NFS-Export/Firewall) = Handover an Infra-Agenten. **WireGuard verboten.**
7. **Write-only-Doktrin** — V60-Runner (mit externen Firmen geteilt) dürfen prod-Storage/Cluster_NFS WEDER sehen NOCH lesen; Rohdaten strikt additiv (409 statt Überschreiben).
8. **#72 vhid-91-Split-Brain** — beide OPN MASTER auf `10.0.91.1` (V91), L2 fehlt → latentes P0; vor scharfer prod-V91-Aktivierung mitdenken.
9. **Secrets** — nie Klartext lesen/ausgeben, nur Namen/Muster; INERT bis `COMDARE_PERSIST_MEASUREMENTS`; keine embedded PATs.
10. **Verify-Zwang** — kein ✓ ohne wörtliche Ausgabe; config.xml-Backup ist der definierte Restore-Punkt.

---

## 5 · OFFENE FRAGEN / ENTSCHEIDUNGEN (vor Infra-Aktivierung)

Unter §24.A VOLLES GO autonom im VOR-ultracode-Workflow aufzulösen, nicht mehr user-blockiert:

1. **minio-Transport:** mc-Shellout (empf.) vs libcurl+SigV4 vs aws-sdk-cpp.
2. **Endpoint-Host-Bestätigung:** Binaries → DEV-V90 (`minio.comdare.de`) und Mess → prod-NFS-V91 — final bestätigen.
3. **NFS-Sink vs Git-Writeback:** ERSETZT `persist:measurements` oder PARALLEL (Doppel-Persistenz)?
4. **minio-Retention:** alte ABI 5→6 behalten oder evicten? („Messdaten nie löschen" gilt Ergebnisse — Bau-Binaries fraglich.)
5. **PULL-Timing:** im 1. Increment oder push-only zuerst?
6. **NFS-Granularität:** per-Binary+whole-run vs nur whole-run+datierter Baum; Timestamp-Besitzer.

**Infra-spezifisch zusätzlich:**
- Exakter Volume-/Export-Pfad des prod-6TB-NFS aus Ledger #202/#156 (nicht raten).
- **#72-L2-Fix** vor scharfer V91-Aktivierung — reihenfolge-kritisch.
- Handover-Doku gegen veraltetes 07-12-V20-NAS-Design aktualisieren (HO-3 #202, HO-7 #209, MinIO-Key-Rotation).

---

## 6 · EMPFOHLENE REIHENFOLGE

**Phase 1 — CE-Seite ZUERST (byte-neutral, kein Infra-Risiko):**
1. VOR-ultracode-Planungssession über Ledger + ALLE Plandocs; die 6 offenen §6-Entscheidungen fällen (mind. Transport=mc, Push-only-first, Doppel-Persistenz-Frage).
2. `CachePushFn`/`MeasurementSinkFn` als No-Op-Injektionsfelder ergänzen (Muster `AlgoSigFn`), Durchreichen bis `profile_run_facade.cpp`.
3. `builder/artifact_transport/artifact_cache.hpp` (mc-Shellout, Retry/Größen-Verify nach Vorbild `scripts/copy_results_to_nas.sh`, `.version` ZULETZT).
4. Objekt-Key-Ableitung + NFS-Sink; `from_env`-Konstruktion in `messung_driver/main.cpp`.
5. Fehlerklasse `InfraErrorClass::ArtefaktIo` in `axis_error.hpp` verdrahten (MESSEN WEITER); Test gegen Naht-Overlap assert-en + Resume-Interplay abdecken.
6. **Verify:** alle env leer → golden/CI byte-identisch; lokaler ce-standalone + super-Sub-Build grün. NACH-Konformitätsprüfung.

**Phase 2 — Infra behutsam (nach Preflight §0):**
7. Ebene B first (kleineres Risiko, bestehende MinIO): Bucket + minimal-scoped Credential → CI-Var (Schritte 1-2, 10).
8. `.1`-SNI-Route für Browse/Drop auf **beiden** OPN (Schritte 3-6) — pro Mutation Verify (GitLab-P0=200, SNI-CN, CARP-Count), config.xml-Backup als Restore-Punkt.
9. Ebene C (NEU, größtes Risiko): erst #72-L2 klären, dann NFS-Export prod-6TB subpath-only + V80-Filterpod + Pfad-Jail/Additiv (Schritte 7-9).
10. Consumer-Seite verdrahten, INERT hinter `COMDARE_PERSIST_MEASUREMENTS` (Schritt 11); Abschluss-Verify + Rollback-Bereitschaft (Schritt 12).

**Leitprinzip:** CE-Bau ist additiv/No-Op und blockiert nichts — er kann komplett vor jeder Infra-Mutation fertig+grün sein. Die scharfe Aktivierung ist erst der letzte Schritt, gated hinter dem Enable-Flag, und jede ändernde OPN/DNS/NFS-Aktion läuft unter §24.B-Ausnahme mit Verify+Rollback je Mutation.