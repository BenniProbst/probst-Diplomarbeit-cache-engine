# INFRA-HANDOVER — NAS-Mess-Writeback via V80-Filterpod (SNI) + prod1-Runner-Concurrency

> **Von:** Impl-Agent (super/cache-engine) · **An:** Infra-Agent · **Datum:** 2026-07-12
> **Auftraggeber-Direktive (User, wörtlich sinngemäß):** Die Messergebnisse sollen später ZUSÄTZLICH auf das
> Cluster-NFS zurückschreibbar sein. Der Backup-Pod gibt das Schreiben NUR auf den Ordner
> `cache-engine-experiment` auf `Cluster_NFS` frei und verweigert sonst für VLAN-60-Elemente (Runner) den
> Zugriff. VLAN 20 wäre Vollzugriff — den gewähren wir wegen externer Mandanten NICHT; genau dafür ist die
> Berechtigungsfilterung eines virtuellen **VLAN-80-Filterpods über das VLAN-20-NAS** gedacht. Die Runner werden
> mit externen Firmen geteilt und dürfen `Cluster_NFS` **weder betrachten noch lesen**; dennoch müssen die
> Messergebnisse sauber über eine **SNI-DNS-Methode (strikt Cluster-Seite)** abgelegt werden können.

## 1. Ziel-Architektur (konform zum bindenden SNI-Standard-Pattern)

```
V60-Runner (geteilt mit externen Firmen; DARF Cluster_NFS nie sehen/lesen)
   │  HTTPS + SNI (z. B. measure-drop.comdare.de) an die LOKALE VIP 10.0.60.1
   ▼
OPNsense-HAProxy (https-in :443, TCP-SNI-Passthrough — neue SNI-Regel ergänzen, reboot-fest)
   ▼
V80-FILTERPOD (Backup-VLAN, IPPool 10.0.80.224/27; neu anzulegen)
   │  einziger Ort mit V20-Zugriff für diesen Pfad; WRITE-ONLY-Semantik
   ▼
V20-NAS 10.0.20.101 : Cluster_NFS/cache-engine-experiment/   (NUR dieser Ordner, append/create-only)
```

- **Cross-VLAN IMMER über die lokale `.1`-CARP-VIP + SNI** (bindendes Standard-Pattern, 12 bestehende
  SNI-Regeln; direkte Cross-VLAN-IPs sind isolations-widrig und werden gefiltert).
- Der **Filterpod** ist die EINZIGE Komponente mit NFS-Mount; er mountet idealerweise **nur den Unterordner**
  `Cluster_NFS/cache-engine-experiment` (NFS-Export auf den Subpfad beschränken), nie den NFS-Root.
- **V20-Vollzugriff wird NICHT gewährt** (externe Mandanten auf dem NAS).

## 2. Anforderungen an den Filterpod (DoD-tauglich)

| # | Anforderung | Prüfkriterium |
|---|---|---|
| F-1 | Endpoint per SNI publiziert (Vorschlag `measure-drop.comdare.de`), erreichbar aus V60 NUR über 10.0.60.1 | `curl --resolve` aus einem Runner-Kontext: 200/201; direkte V20-/V80-IP aus V60: geblockt |
| F-2 | **Write-only**: PUT/POST von Dateien in `cache-engine-experiment/<YYYYMMDD-HHMMSS>/…`; **kein** GET/LIST/DELETE (Runner dürfen nichts betrachten/lesen) | LIST/GET/DELETE → 403/405; PUT → 201 |
| F-3 | Pfad-Jail: ausschließlich unterhalb `cache-engine-experiment/`; Traversal (`..`, absolute Pfade, Symlinks) verworfen | PUT auf `../andere-mandanten/x` → 403 |
| F-4 | Additiv-Doktrin: existierende Dateien werden NIE überschrieben (Konflikt → 409), passend zur Rohdaten-Backup-Direktive „strikt additiv" | zweites PUT auf denselben Pfad → 409 |
| F-5 | AuthN: eigenes, minimal-scoped Credential NUR für diesen Endpoint (projekt-lokal rotierbar, analog zum Write-Token-Muster id=54); als **protected** CI-Variable in super (288) hinterlegen (z. B. `COMDARE_NFS_DROP_TOKEN`) | Credential-Rotation ohne Admin-PAT möglich |
| F-6 | Der Pod läuft im Backup-Kontext V80 (IPPool 10.0.80.224/27) und ist der einzige mit V20-Route für diesen Pfad | NetworkPolicy/Firewall-Nachweis |
| F-7 | Technologie-Vorschlag (Infra-Entscheid): kleiner WebDAV-/S3-Gateway-Pod (z. B. nginx-dav-ext PUT-only oder MinIO-Gateway mit write-only-Policy) mit NFS-Subpath-Mount | — |

**Consumer-Seite (bereits vorbereitet, Impl-seitig):** Der `persist:measurements`-Job schreibt die Ergebnisse
bereits nach `measurement/<YYYYMMDD-HHMMSS>/` ins Repo (Phase 1, aktiv). Phase 2 = im selben Job zusätzlich je
Datei ein `curl -T` an den SNI-Endpoint (identische Ordnerstruktur). Diese ~10 Zeilen ergänze ich, sobald
Endpoint + Credential stehen — Ping genügt.

## 3. Zweiter Punkt: prod1-Runner-Concurrency 2 → 3 (User-Freigabe liegt vor)

- **Was:** Auf prod1 in `/etc/gitlab-runner/config.toml` das globale `concurrent = 2` auf **3** setzen +
  `gitlab-runner restart` (bzw. `systemctl restart gitlab-runner`).
- **Warum:** Der mehrtägige golden-320-Messlauf (Runner id=16, Tags `[prod, baremetal, amd]`) belegt 1 Slot;
  mit `concurrent=2` läuft die gesamte super-CI (alle Jobs `tags:[baremetal]` → NUR id=16 matcht) auf einem
  Rest-Slot. `concurrent=3` gibt der CI zwei Slots neben der Messung.
- **Warum Handover:** `/etc/gitlab-runner/config.toml` ist root-only; Impl-Sitz (comdare) hat kein sudo.
- **Kontext:** Der laufende Voll-Lauf ist ein bewusster Proof-of-Concept UNTER Fremdlast (User-Entscheid);
  die echte Messkampagne folgt später auf lastisolierter Maschine.

## 4. Referenzen
- VLAN-Tabelle + SNI-Standard-Pattern: Agent-Memory `reference_cluster_vlan_tabelle_sni_standard_pattern`
  (10.0.x-Welt; V20-NAS 10.0.20.101; V60-VIP 10.0.60.1; V80-IPPool 10.0.80.224/27; HAProxy https-in :443
  TCP-SNI-Passthrough, 12 Regeln, KB-027).
- Write-Token-Sicherheitsmuster (Vorbild für F-5): super-Ledger §11-G G-b (Project Access Token id=54,
  write_repository-only, admin-PAT-unabhängig rotierbar).
- Persist-Mechanik (Phase 1, aktiv): super `.gitlab-ci.yml` `persist:measurements` + Ledger §11-G.
- #202 (NAS/MinIO-Writeback) im Cluster-Ledger = das übergeordnete Infra-Ticket dieses Handovers.
