# INFRA-HANDOUT (PRIORITÄT HOCH) — prod-MinIO korrekt nach V91 + #72-Fix → Tier-Binary-Compile-Cache

> **Von:** Impl-Agent (Diplomarbeit/Cache-Engine, node1) · **An:** Infra-Agent · **Datum:** 2026-07-18
> **User-GO (wörtlich):** „wir geben ein priorisiertes handout an den infra Agenten das cluster prod minio korrekt nach V91 zu verlegen, sodass wir es wie beschrieben als compile cache nutzen." · Storage-Verortung: `docs/plaene/20260718-storage-infra-verortung-VERORTUNGS-BRIEF.md` (wf_64c5aeb6, aktueller Cluster-Stand 081ebc4).

## 0. Warum (Zweck für die Diplomarbeit)
Der Cache-Engine-Storage hat 3 Ebenen. **Ebene B = die kompilierten Tier-Binaries (`perm.dll` + `perm.dll.version` + `result.csv`) sollen in einen Objekt-Store als Compile-Cache** (Voraussetzung für das golden N=2^17=131.072 — nur so wird der inkrementelle Rebuild feasible). **Ziel-Store = prod-MinIO auf V91.** Die CE-Seite (Push/Pull) ist gebaut, byte-neutral, env-gated inert — sie aktiviert, sobald der prod-MinIO-V91-Endpoint + Credentials stehen. **(Ebene C = Messergebnisse geht separat auf den bestehenden V80-`measure-drop`-Pfad — NICHT Teil dieses Handouts.)**

## 1. Ist-Stand (aus der Verortung, bitte gegen Live prüfen)
- **prod-MinIO läuft heute via V10/`.1`-SNI**, NICHT auf V91: `minio.prod.comdare.de → 10.0.10.1 → OPN-HAProxy-SNI-Passthrough → 10.32.243.80:9000` (prod-K8s-Calico-ClusterIP über V111-BGP; Bucket `gitlab-runner-cache`). **Kein V91-LB.**
- **OPN-Bug #72 (der Blocker):** CARP **vhid-91 Split-Brain** — beide OPN sind MASTER für `10.0.91.1`, weil der **V91-L2-Trunk zwischen opn-1/opn-2 fehlt**. Solange das so ist, ist V91 latent-unbrauchbar (Fix ist P0-riskant, laut Verortung geplant).
- **prod2-Recovery = Universal-Gate:** etcd 3/3 + 2-Node-Longhorn müssen VOR und NACH jeder prod-Mutation grün sein.

## 2. Auftrag (geordnet, priorisiert)
1. **#72 auflösen (Voraussetzung):** V91-L2-Trunk zwischen opn-1/opn-2 sauber etablieren, sodass vhid-91 genau EINEN CARP-MASTER + einen BACKUP hat (kein Split-Brain). **Kein Band-Aid — sauber planen** (User-Direktive Infra „cleanest not easiest"). P0-riskant → prod2-Recovery-Gate + config.xml-Backup je OPN + Rollback-Punkt.
2. **prod-MinIO korrekt auf V91 präsentieren:** MetalLB-/Service-Heimat auf V91 (`10.0.91.x`) bzw. `.1`-SNI-Routing über V91 gemäß VLAN-Doktrin (DB-Heimat auf DB-VLAN; Cross-VLAN nur via Samba-AD-DNS-FQDN → Konsumenten-`.1` + `.1`-SNI-HAProxy). `minio.prod.comdare.de` weiter erreichbar.
3. **Tier-Binary-Bucket** auf prod-MinIO-V91 anlegen (z. B. `cache-engine-tier-binaries`), **getrennt** von `gitlab-runner-cache`; Versioning/Immutability additiv (Additiv-Doktrin: nie löschen/überschreiben). Objekt-Key-Konvention (vom Impl vorgegeben): `<build_version>/<stem>/perm.dll(+.version)`.
4. **Minimal-scoped Service-Account** (Policy strikt nur auf diesen Bucket, kein globaler/Cross-Bucket-Zugriff), projekt-lokal rotierbar (Muster Write-Token id=54) → als **protected + masked CI-Vars in super (Projekt 288):** `MINIO_ACCESS_KEY`, `MINIO_SECRET_KEY`, plus `COMDARE_MINIO_ENDPOINT`/`COMDARE_MINIO_BUCKET`. Nur Namen — Werte nie in Doku/Log.
5. **`.1`-SNI-Route** für den Bucket-Endpoint auf **beiden** OPN (eigene UUIDs, kein XMLRPC-Sync): `php-Model->Add()` sequenziell server→backend→acl(ssl_sni)→action→`https-in`-Link; STAGING rendern → `haproxy -c` → graceful `-sf` (NIE stop/start; opn-1 `configctl haproxy reload` scheitert still → manueller `-sf`).

## 3. Harte Constraints (aus der Verortung)
- **HAProxy NIE `stop`/`start`** (SO_REUSEPORT-Straggler #35 → `:443`-P0); nur `pkill -9` bis leer + `rm pid/socket` + template reload + EINE Instanz + graceful `-sf`. Render ≠ Live. `config.xml` = Single Source of Truth (kein Hand-Edit an Live-conf).
- **`.1`-SNI-Pflicht Cross-VLAN**, keine dedizierten internen VIPs (außer DMZ V40); direkt `:9000`/ClusterIP/Cross-VLAN-IP = blackhole.
- **prod2-Recovery-Gate** vor/nach jeder prod-Mutation; **nach JEDER Mutation** hart verifizieren (wörtliche Ausgabe): GitLab-P0 `sign_in`=200, CARP-MASTER-count unverändert, echtes Backend-Cert via `openssl s_client -servername <fqdn> -connect 10.0.10.1:443`.
- **OPN-Zugang:** Laptop-cluster-Key (`Cluster/keys/cluster`) via `ssh root@10.0.10.11`(opn-1)/`.12`(opn-2), csh-Wrap; Secrets nie im Klartext.

## 4. Definition of Done (was der Impl-Agent zum Aktivieren braucht)
- prod-MinIO auf V91 erreichbar (`.1`-SNI), #72 aufgelöst (vhid-91 sauber), prod2-Recovery grün.
- Bucket `cache-engine-tier-binaries` existiert (leer, versioniert).
- CI-Vars `MINIO_ACCESS_KEY`/`MINIO_SECRET_KEY`/`COMDARE_MINIO_ENDPOINT`/`COMDARE_MINIO_BUCKET` in super 288 (protected+masked).
- Kurzer Ping an den Impl-Agenten → dieser schaltet die (bereits gebaute, byte-neutrale) CachePushFn/Pull-Naht via Env scharf, gated hinter dem Enable-Flag.

**Referenzen:** Verortungs-Brief (oben) · Cluster-Ledger #202 (NAS/MinIO-Writeback) / #141 (prod-MinIO-Separation) / #72 (vhid-91) · Storage-Dossier `docs/plaene/20260718-storage-two-cache-vor-BAUPLAN-TWO-CACHE-STORAGE.md`.
