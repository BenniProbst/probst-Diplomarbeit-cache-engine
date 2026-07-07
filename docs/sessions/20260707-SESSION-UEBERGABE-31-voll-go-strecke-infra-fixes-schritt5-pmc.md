# SESSION-ÜBERGABE 31 — Voll-GO-Strecke: Struktur-Governance komplett, 2 Infra-Vorfälle behoben, Schritt 5 (comdare-pmc) live (2026-07-07)

**Agent:** Diplomarbeits-IMPL-Agent (comdare@prod1, Fable 5) · **Vorgänger:** Übergabe 30 (gleicher Tag, Vormittag). · **Abschluss-Grund:** User „Der Kontext endet jetzt".
**Aktives Goal (Stop-Hook, User 07.07. abends, bereinigte Fassung):** „Bitte erledige alle sichtbaren TODOs und den Goal-Text V3 im Ledger. Beachte besonders die Direktiven zur Striktheit der Organisationsform der Programmierumgebung, der Modulreferenzierung und der Metaprogrammierung. Stelle zu jeder Zeit sicher, dass alle Memories geladen und alle Direktiven klar sind."

> **PFLICHT-EINSTIEG nächster Zyklus:** (1) ALLE Memories laden (MEMORY.md + Dateien — heute über alle 3 Abteilungen konsolidiert, 76 Dateien identisch; Backups `~/.claude/memory-backups/20260707/`), (2) Ledger §12 neueste Einträge (07.07.) + §13.12 lesen, (3) DIESES Dokument, (4) sichtbare Task-Liste = Arbeitsvorrat.

---

## 1. IN-FLIGHT — HIER SOFORT ANKNÜPFEN

1. **Template-v3-Doppel-Beweis:** ci-templates `2352bcf` (@development+main) = find-Expansion der cppcheck-Ignores. **pmc 8867 = SUCCESS ✓ (v3, keine Regression).** **super 8868 = IN-FLIGHT** beim Kontext-Ende — Ausgang per API prüfen (`/projects/288/pipelines/8868`). Erwartung grün (nested `Code/external`-Ignore wieder wirksam). Falls rot: Trace lesen; die Findings-Klasse wäre dann NICHT die 1775 Vendor-Findings (Fix greift), sondern Neues. Die Welle DIESER Übergabe (Push auf super/main) läuft ebenfalls mit v3 und ist ein gleichwertiger Beweis.
2. **Danach Schritt 6 (HDR additiv in comdare-metrics)** inkl. **#42-Fix** (metrics tests/CMakeLists fehlt — Zelle standalone defekt). Kadenz wie Schritt 5 (unten §4-Muster).

## 2. HEUTE VOLLZOGEN (alles literal bewiesen, Ledger §12 07.07.)

- **#274 Schritt 2 — Fleet-Branch-Konsolidierung:** 297 Projekte → 286 konform · 240 master beweisgeführt entfernt (SUBSET/STALE + Backup-Ref `refs/backup/master-20260707` je Klon + verify-404) · 23 Vereinigungs-MRs konfliktfrei · Fleet **100 % master-frei** (nach #35).
- **#33 Umbrella-Tracking-Bereinigung:** 21 Voll-Zellen als eigenständige Repos gerettet (21/21 remote verifiziert), 19/19 Umbrellas clean (0 Voll/0 Gitlinks/ignore=ja); comdare-db (34 Gitlinks) + cd-buildsystem = Handover (#43).
- **#34 GitLab-Gruppen = Ordner-SOLL:** Tranchen A–H — 66 Baseline-Untergruppen, ~160 Transfers, 8 `*-module`-Renames (Ordnername=SOLL), db-Stufen 7/7 angeglichen, Products im db-Muster (`comdare/products/<x>/<x>`); Verify 15/17 Familien nur-Umbrella, 311 Projekte konstant; **origin-Sync 236/236** + Credential-Store je neuem Pfad.
- **#35:** 6 behaltene master verlustfrei ARCHIVIERT (`archive/redcomponent-initial-20260213` ×4 [caa36511/cb9bef73/e8acff6f/18e894b9], `archive/master-pre-merge-conflict-20260707` ×2 [2139cd5f/45e03898]).
- **Infra-Vorfall 1 (Registry):** Transfer-500 → Wurzelursache dev-CoreDNS-Override `minio.comdare.de→10.0.90.224` (V90-Direkt-IP, isolations-widrig, seit ~28.06. — Registry 9 Tage ohne S3!) → **Fix Override→10.0.16.1** (SNI-Pattern; Backups node7+Scratchpad) + Registry-Rolling-Restart → metrics-Transfer HTTP 200 → **Schritt 3 vollzogen** (Zelle lokal in `comdare-baseline_0-core/`, Aggregatoren umgehängt, measurement 8794 grün).
- **Infra-Vorfall 2 (Object-Store, Folgefehler):** Artefakt-Uploads 500 („SSL wrong version number @10.0.16.1:9000") — der alte :9000-Endpoint lebte nur auf der toten .224 → **gitlab-object-storage-Secret → `https://minio.comdare.de` (SNI-443)** (Backup `objstorage-backup-20260707-190800.yaml` node7+Scratchpad) + Rollout (Anti-Affinity-Stau durch Alt-Pod-Räumung gelöst) → **E2E-Beweis Wellen 8837 + 8841 = SUCCESS**. **dev/prod-MinIO-Beweis:** TLS-SAN `*.databases.svc.cluster.local` = dev (V90); prod separat `minio.prod.comdare.de` (V91).
- **Schritt 4:** Scratch-Kopie `Research/_ce-scratch-split-20260707` **fixiert d6d0744a**, kein Remote, 195 MB.
- **Schritt 5 — comdare-pmc LIVE:** Kadenz komplett (§4); Zelle = Projekt **320** in Untergruppe 430, main `26ee7dc5`, **ctest 4/4 literal**, **Zellen-CI 8854 + 8860 + 8867(v3) = SUCCESS**.
- **Template-Härtungs-Saga .lint-static (3 Fixes, alle @development+main):** `ffd0af3` (-i mit ./-Anker — nackte Namen matchten den ABSOLUTEN Workspace-Pfad: unter `comdare/modules/...` war ALLES ignoriert) → `0755b72` (.citools immer ignorieren — cppcheck scannte sonst seine eigenen Quellen bei LINT_PATHS=".") → `2352bcf` (find-Expansion nackter Namen auf reale Verzeichnisse: nested-Matching für super erhalten UND Root-Falle unmöglich).
- **Memory-Konsolidierung (User):** 3 Abteilungen (`-home-comdare`, `-home-comdare-Projekte`, `-root`) auf identische 76 Dateien vereinigt; 3 Vorher-Tars + Konsolidat unter `~/.claude/memory-backups/20260707/`.
- **Aufschiebe-Audit (User):** 13-Stationen-Kette rekonstruiert, Rest-Fäden = Tasks #41(✓)–#44.
- **Sturm-Lehre operativ:** ~500 Branch-Anlagen triggerten Pipeline-Sturm → Cancel-Sweeps (64 + 4 Zombies) + Runner-Retry-Härtung `acd05ec` (GET_SOURCES/ARTIFACT/CACHE/EXECUTOR je 3).

## 3. OFFENE TASKS (sichtbare Liste = Arbeitsvorrat; Reihenfolge-Empfehlung)

1. **super-8868-Ausgang prüfen** (bzw. Übergabe-Welle) → Template-Saga im Ledger abschließen.
2. **#39 Schritt 6:** HDR-Erweiterung IN comdare-metrics (additiv, A2-Interface-Stabilität) **+ #42** (tests/CMakeLists nach pmc-Muster, 10 metrics-Tests reaktivieren). Quelle: Scratch-Kopie (latency_stats/HDR-Verstreutes; Plan §1-measurement-Zeile: HDR = Erweiterung IN metrics, KEINE eigene Zelle).
3. **#39 Schritt 7:** comdare-workloads (baseline_2-workloads: dataset_loader+workload_generator+workload_driver-Generika aus Scratch).
4. **#26 [KERN-CODE, mehrfach aufgeschoben]:** 234-V-b — Rest-Familien Shaped-Emission, binary_id-Shape-Segment, Baum→Emitter-Verdrahtung (ce-Repo, Goal-V3-Strang).
5. **#43** Handover-DOKUMENT schreiben (Inhaltskatalog in der Task-Description) · **#32** Instanz-Repos + Naming-Sweep redcomponent/bep→Comdare (Marke=Comdare, Firma=„BEP Venture UG" nur juristisch) · **#44** Kleinreste.
6. **#29** comdare::container-Generalisierung · **#27** 7b-3 axis_09b · **#11** #266-Vendoring (Q2=config-all GO) · **#25** Datensatz-Akten · **#13/#20/#28** ce-CI/Plattform-Strecke · **#31** F7-Mess-Matrix (Diplomarbeit vorher lesen) · **#14/#276** ALLERLETZTE.
7. **User/physisch:** **#36 prod2** (hart down seit ~13:00 — „No route", inkl. Windows-Runner; halbe baremetal-Kapazität fehlt!) · **#23/#40 Montag** (Token-Rotation DRINGEND [root-master-token, heute intensiv genutzt], vhid-91-Split-Brain V91, K87b, webservice-Anti-Affinity-Betriebsnotiz).

## 4. KADENZ-MUSTER Schritt 5 (für 6/7 wiederverwenden)

(1) ICH: Kartierung in der Scratch-Kopie + Zellen-Gerüst (metrics-/pmc-Vorbild: INTERFACE `comdare::<ns>`, include/comdare/<ns>/, README mit Herkunft+SHA, LICENSE, .clang-format=ce-Kopie!, kein buildsystem.xml [F1], .gitignore build/) → (2) CODEX (mcp, `sandbox: danger-full-access`, cwd=Zelle, gpt-5.5+xhigh, Dossier-Datei mit Quelle/Ziel/Regeln/Tabus/DoD; Muster `scratchpad/dossier_pmc_migration.md`) → (3) ICH: Voll-Review (normalisierter Diff, Mojibake-grep, clang-format 22.1.8 [~/tools], Metaprogrammierungs-Linse, gtest-Tarball→`prerequisites/`) + frischer cmake+ctest-Beweis → (4) Remote (Untergruppe falls neu + Projekt, main+development+protected, credential approve je Pfad) + Push → (5) Umbrella-Slot-Verify (EXISTS-Zeilen für pmc/workloads existieren schon: CMakeLists:19/22/25) → (6) Zellen-CI GRÜN (frische Pipeline, NIE Job-Retry nach Template-Änderungen [F2]) → (7) Ledger §12 + Tasks.

## 5. NEUE DIREKTIVEN/ENTSCHEIDE HEUTE (alle als Memories verankert)

- **Codex-Erstimplementierung IMMER** (re-bekräftigt) + **Codex-MIGRATION in erster Instanz** (Struktur-Vorbereitung durch mich, elaboriertes Aufgaben+Umgebungs-Dossier, danach manuelle Kontrolle) — `feedback_codex_implements_from_dossier_claude_corrects` (2 neue Absätze).
- **Umbrella-SOLL** (`feedback_umbrella_soll_struktur_trackt_alles_ausser_baseline_zellen`): docs+sessions+comdare_baseline_N+module_test_instantiation+opt. Wrapper/server-client; trackt alles AUSSER Zellen (CMake-Hot-Clone); Products = Umbrella-Äquivalent, Instanziierungs-Name `comdare-<produkt>-<modul>`, kopierte Baselines, multiple Stufen-N flach; **GitLab-Gruppen: Ordnerstruktur = SOLL** (B6 beantwortet, #34 vollzogen).
- **VLAN/SNI-Pattern** (`reference_cluster_vlan_tabelle_sni_standard_pattern`): Cross-VLAN NUR über lokale `.1`-VIP + SNI (12 reboot-feste Regeln); **V90=dev-MinIO (GitLab-Buckets), V91=prod-MinIO (`minio.prod.comdare.de`)**; Lehren: Port-Pfade eines Namens ALLE mitprüfen; Anti-Affinity-N-auf-N-Rollouts stauen.
- **GitHub = flache Out-of-House-Sicherung** (`feedback_github_flache_...`): strukturell belassen, Fokus GitLab.
- **Struktur-/Naming-Regression** (`project_struktur_regression_...`): geteilte Klone→Instanz-Repos (#32); **redcomponent+bep regressiv** (Marke Comdare; „BEP Venture UG" nur in Rechtstexten).
- **GitFlow fleet-weit hergestellt**; neue Repos: main-default+development+protected(40/40).

## 6. ZUGÄNGE/WERKZEUGE (heute erarbeitet — spart Stunden)

- **dev-K8s:** Pi5-Jump `ssh -i <cluster-key CRLF-bereinigt!> node7@10.0.10.207`, dort `sudo kubectl --kubeconfig /root/.kube/config`. GitLab=Helm im ns `gitlab`; MinIO ns `databases`; CoreDNS-Overrides kube-system/cm coredns (gitlab+minio → **10.0.16.1**).
- Backups auf node7:/home/node7/: `coredns-backup-20260707-163808.yaml`, `objstorage-backup-20260707-190800.yaml` (+Scratchpad-Kopien; Scratchpad ist flüchtig — bei Bedarf von node7 holen).
- API-Muster: `git credential fill` (useHttpPath!) → PRIVATE-TOKEN; 5xx/429 = Backoff-Retry; **Fehler ≠ leer** (Lehre); Transfers idempotent, brauchen ggf. 300s; volle SHAs/Pipeline-IDs für Monitore.
- Codex-MCP funktionsverifiziert (CODEX_MCP_OK); prt-art-CI + Runner: nur prod1 trägt baremetal bis prod2 zurück ist.

## 7. ENDSTÄNDE (literal)

- **super main `4378129`+diese Übergabe** (beide Remotes; Grün-Anker 8837/8841; 8797/8830 = erklärte rote Historie [Object-Store]; 8856 rot = Template-v1-Nebenwirkung, durch v3 behoben — Beweis via 8868/Übergabe-Welle ausstehend).
- **ci-templates `2352bcf`** (@development UND main; Kette acd05ec→ffd0af3→0755b72→2352bcf).
- **comdare-pmc (320):** main `26ee7dc5`, CI 8854/8860/**8867(v3)** = success. **metrics (76):** transferiert+platziert, Standalone-Defekt #42.
- **measurement-all:** main=ad8df1f-ff; Slots Schritt 5 ✓ belegt / 6/7 vorbereitet. **Scratch:** `_ce-scratch-split-20260707` @ d6d0744a.
- ce `d6d0744a` · prt-art `faa4e76` · thesis `35b7d54` (unverändert; Research-Track unangetastet).
- GitLab: 312 Projekte (320 neu), ~101 Untergruppen; Owner überall root-direkt; Fleet master-frei.

## 8. NÄCHSTER ZYKLUS STARTET MIT

§1 (8868-Ausgang + ggf. Übergabe-Welle verifizieren, Ledger-Nachtrag Template-Saga) → §3.2 Schritt 6 (HDR+#42, Kadenz §4) → Schritt 7 → **#26**. Goal-Text V3 (§13.12) + Matrix-Referenzen bleiben bindend; Montags-Block für User vorbereiten (#23/#40/#36).
