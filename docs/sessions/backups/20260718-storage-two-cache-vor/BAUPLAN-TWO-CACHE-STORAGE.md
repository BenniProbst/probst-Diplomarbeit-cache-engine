# BAUPLAN-DOSSIER — Zwei-Cache-Storage (minio-Bau-Artefakte / NFS-Messergebnisse)

> **Status:** VOR-Deep-Research (Workflow `wf_60dd3eff`, 4 Agenten, ~456k tokens), fertig 2026-07-18. Verdikt KONFORM.
> GATED auf User-GO. ce = `Code/external/comdare-cache-engine`. Verwandt: der inkrementelle Rebuild-Cache
> (`20260718-incremental-caching-vor/`, wf_911c8162) — die minio-gecachten Binaries + Sidecars persistieren zwischen Läufen.

## 0. Auftrag (User-FINAL, nach 2 Korrekturen)
> CEB-Compiles + Tier-Binary-Compiles → **minio.comdare.de** (Object-Store-Bucket). Messergebnisse → **NFS auf prod-6TB-
> longhorn**, durchsuchbar via **DNS-`.1`-SNI/HA-Proxy von VLAN 10**. Standard-Compiles (Planer, ce-Library, CI-Tests) +
> alle CI-Daten → GitLab-Cache cluster dev. **Schreiben SEQUENTIELL zur Messung, NIE parallel** (I/O-Contention = Messfehler).

## 1. Drei Storage-Ebenen (sauber getrennt, je eigener Endpoint)
- **A — Standard-Compiles + CI-Daten → GitLab-Cache dev (UNVERÄNDERT):** Runner-ccache auf `minio.comdare.de:9000/
  buildsystem-cache` (config.toml, Infra). CEB-Host-.o + 9 Pipeline-Executables leben im CMake-Build-Tree, physisch schon
  außerhalb `e4_dir`. **Keine CE-Änderung.**
- **B — CEB/Tier-Binary-Bau-Artefakte → minio.comdare.de-Bucket (NEU, dev V90):** je Binary `output_dir/<stem>/perm.dll +
  perm.dll.version + result.csv`; Objekt-Key = `<build_version>/<stem>/perm.dll(+.version)`. **Key-Ableitung KOPPELT ans
  Algo-Versions-Manifest** (dieselbe build_version-Signatur, die `dll_is_current` lokal prüft) → Pull re-verifiziert →
  stale ABI (5→6) wird NIE reused. Zugang via `.1`-VIP+SNI (:443, nie :9000/ClusterIP-direkt = geblackholed). Bucket
  getrennt vom buildsystem-cache.
- **C — Messergebnisse → NFS prod-longhorn-6TB (NEU, V91), browsable VLAN10:** NFS-Export am Schreibpfad GEMOUNTET → CE
  schreibt per POSIX `std::filesystem::copy` an `COMDARE_MEASUREMENT_NFS_ROOT` (kein Client nötig, Mount = Infra). Kandidaten:
  per-Binary `result.csv` + die EINE globale `measurements.csv` + PDF/tex. Browse-Route `.1`-SNI-HAProxy VLAN10 = reine Infra.

**Ist-Delta (verifiziert):** minio.comdare.local = 0 Treffer; kein Tier-Binary-Push existiert; Mess-Rückschrieb heute nur
ins Git (persist:measurements, inert bis `COMDARE_PERSIST_MEASUREMENTS`); `.version`-Sidecar = vorhandener Resume-/Versions-
Träger; `.algos`-Emit existiert noch nicht (= die Caching-VOR).

## 2. Sequentielle Schreib-Naht (verifiziert, cache_engine_builder_iterator.hpp)
Zwei-Phasen-Ordnung: **Phase A (BAU, multithreaded)** `orch.provision_all(:710-711)` baut alle DLLs parallel; endet
VOLLSTÄNDIG bei :711. **Phase B (MESS, 1-THREAD)** `for(BuildResult b : builds)(:731)` — reine For-Schleife, KEINE Threads.
**Einhänge-Naht = per-Binary im Mess-Loop, NACH :899 (result.csv+stamp geschrieben), VOR :900 (RAII-DLL-Unload):**
- Binary-Push (B→minio): perm.dll + Sidecar + result.csv, **SYNCHRON/blockierend**.
- Ergebnis-Schreib (C→NFS): result.csv POSIX-copy an NFS-Mount, **SYNCHRON**.
1-Thread ⇒ beides läuft ZWISCHEN zwei Messungen; die nächste Messung startet erst nach Rückkehr → **NIE parallel**. PULL
(minio→local, Warm-Cache) gehört in Phase A um `dll_is_current(:288)` (pre-Messung, parallel-unbedenklich). Whole-run-CSV
→ NFS an `profile_run_entry.hpp:425` (nach csv.flush, alle Pässe fertig). **VERBOTEN: async/detached Push** (I/O-Contention).

## 3. CE-Seite (Code) — Injektions-Muster (zero-cost, No-Op-Default)
Wie CompileFn/SourceGenFn (build_orchestrator.hpp:121-123). **Alle env-Vars leer → No-Op → golden/CI byte-neutral (Anti-Phantom).**
- **Endpoints (env, getrennt):** `COMDARE_MINIO_ENDPOINT/_BUCKET/_PREFIX` (B); `COMDARE_MEASUREMENT_NFS_ROOT` (C); Credentials
  als protected CI-Var (NIE im Code/Log). Getrennt vom `COMDARE_CACHE_ROOT` (ccache, A).
- **MinIO-Push-Client:** NEU `builder/artifact_transport/artifact_cache.hpp` — schmale C++-Klasse, synchron `mc cp` (MinIO-
  Client, vendored; Retry/Größen-Verify wie `scripts/copy_results_to_nas.sh`; KEIN Python). **Vollständigkeits-Marke: perm.dll
  ZUERST, perm.dll.version ZULETZT** → halb-gepusht = kein Sidecar = kein Pull. Fehler → `InfraErrorClass::ArtefaktIo` loggen,
  lokale Kopie behalten, **MESSEN WEITER** (nie abbrechen).
- **NFS-Rückschrieb:** POSIX `std::filesystem::copy` an `COMDARE_MEASUREMENT_NFS_ROOT`, additiv/nie-überschreibend (sha256-Verify).
- **Naht-Felder:** `CachePushFn` + `MeasurementSinkFn` (Default No-Op) auf Iterator-cfg + RunProfileArgs/ExperimentRunArgs;
  Durchreichen `profile_run_facade.cpp` (Spiegel out_csv-Passthrough); `messung_driver/main.cpp` konstruiert sie aus env
  (`artifact_cache::from_env`) auf xa/pa.

## 4. Infra-Handover (NICHT von mir — Cluster read-only)
- **minio.comdare.de-Bucket** (Ebene B) auf dev-MinIO V90, GETRENNT vom buildsystem-cache; Zugang `.1`-VIP+SNI:443; minimal-
  scoped Access-Key als protected CI-Var (super 288).
- **NFS-Export prod-longhorn-6TB + Mount** (Ebene C, V91), beschränkt auf den Messergebnis-Unterordner (append/create-only);
  KOMPLETT NEU (kein Repo-Vorbild; existierendes NAS = V20 backup1 SMB / V80 longhorn-backup, NICHT prod-6TB).
- **HAProxy-`.1`-SNI-Route VLAN10 → prod-NFS-Browse** (neue reboot-feste SNI-Regel, https-in:443 TCP-SNI-Passthrough beide OPN;
  Browse-Hostname von Infra zu vergeben). NEU (nicht in den 12 SNI-Regeln; alter measure-drop war V60 write-only).
- **Credentials** minimal-scoped, projekt-lokal rotierbar (Muster write_repository-Token id=54), protected CI-Vars super 288.
- **Handover-Doku** aktualisieren gegen das veraltete 07-12-V20-NAS-Design (V80-Filterpod-write-only-Muster gilt, Speicherziel
  V20-NAS → prod-longhorn-NFS). Referenz: HO-3 (#202), HO-7 (#209).
- **Routing:** V90=dev-MinIO minio.comdare.de; V91=prod-MinIO minio.prod.comdare.de; je-VLAN `.1`-VIP; Cross-VLAN direkt=blackhole.

## 5. Konformitäts-Verdikt: KONFORM
CE/Infra getrennt (ich baue nur die CE-Seite, Endpoints aus env) · Cluster read-only (kein Bucket/Mount/Route) · kein Python
(C++-Klasse + mc-Shellout + POSIX-copy + CMake) · sequentiell (SYNCHRON an :900/:425, PULL pre-Messung, kein async) · additiv
(No-Op-Default, golden/CI-neutral) · offizieller Weg (Injektions-Muster) · Manifest-gekoppelt (build_version/.version, ABI-sicher)
· Fehler klassifiziert + Messung weiter.

## 6. Offene Entscheidungen (dem User vorzulegen)
- **minio-Transport:** `mc`-Shellout (empf., einfachste vendorbar) vs libcurl+SigV4 (self-contained) vs aws-sdk-cpp (schwer).
- **Endpoint-Host bestätigen:** Binaries → DEV-minio.comdare.de (V90) UND Messergebnisse → prod-longhorn-NFS (V91)? (nicht prod-MinIO für Binaries).
- **NFS-Sink vs Git-Writeback:** ERSETZT der NFS-Sink den persist:measurements-Git-Writeback oder PARALLEL (Doppel-Persistenz)?
- **minio-Retention:** alte ABI-Versionen (5→6) im Bucket behalten oder evicten? (Messdaten-nie-löschen gilt für Ergebnisse; für Bau-Binaries?)
- **PULL im 1. Increment** oder push-only zuerst? (Pull = größere ABI-Reuse-Fläche, spart Rebuilds).
- **NFS-Granularität:** per-Binary result.csv + whole-run, oder nur whole-run + datierter Baum? Timestamp-Besitzer (Aufrufer vs NFS-Sink)?

## 7. Risiken
- **I/O-Contention-Messfehler (KERN):** nur SYNCHRON an :900/:425; PULL pre-Messung; KEIN detached — im Test hart gegen Overlap assert-en.
- minio-Push-Fehler im mehrtägigen Lauf darf NICHT abbrechen: loggen (ArtefaktIo), lokale Kopie, weiter; nicht-gecachte Binary im Folgelauf neu.
- Partieller Upload → falscher Reuse: mc-atomic-put + Größen-Verify; .version ZULETZT.
- Manifest-Drift (Key ohne Signatur → stale ABI): Key=build_version+Signatur; Pull re-verifiziert dll_is_current.
- NFS-Mount stale: loggen, lokale Kopie + Git-Fallback, weiter; additiv/sha256.
- Resume-Interplay: resumte Binaries (continue :746) umgehen die Push-Naht → müssen im erzeugenden Lauf gepusht sein / Pull hydriert; im Test abdecken.
- **GAPs (Infra, nicht raten):** minio-Config (Bucket/Key/mc-alias), NFS-Konvention (Export-Pfad/Mount/Layout), VLAN10-Browse-SNI-Hostname — blockieren die scharfe Aktivierung, NICHT den additiven No-Op-CE-Bau.
