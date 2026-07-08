# HANDOVER an foundation-/comdare-db-/buildsystem-Owner — Struktur- & Alt-CI-Befunde (2026-07-08)

**Absender:** Diplomarbeits-IMPL-Agent (comdare@prod1). **Rolle-Grenze:** Ich bearbeite die 4 Diplomarbeit-Repos
(super/ce/prt-art/thesis) + die measurement-all-Migration; die hier gelisteten Systeme (foundation-all,
comdare-db, cd-buildsystem, licensing-all) haben **eigene Owner + eigene Ledger** ([[feedback_comdare_db_and_buildsystem_separate_ledgers]])
und werden von mir NICHT mutiert. Dieses Dokument bündelt die im Zuge von #33/#34/#35/#274 und dem
Dirty-Sweep 08.07. **read-only erhobenen** Befunde, damit die zuständigen Owner sie strukturell auflösen.
Alle Befunde sind literal belegt; nichts davon ist „quick-fixbar" — die Auflösung ist je System strukturell.

---

## HO-A — Alt-Matrix-CI strukturell defekt (Task #38, KONKRETE FLEET-EVIDENZ)

**Befund:** Zahlreiche Modules-Umbrellas tragen noch die **alte „COMDARE Multi-Platform CI/CD Template v7.0.x"**
(66-Job-Matrix: `build-docker-riscv` × ~18 OS, `build-macos-arm/x86`, `build-docker-windows-*`,
`build-linux-riscv`, `build-linux-arm64`, `audit:layering`, aggregate/upload). Diese Matrix zielt auf
**Runner-Tags, die im aktuellen Cluster nicht existieren** (RISC-V, macOS, Windows-Docker) bzw. auf
halbe Baremetal-Kapazität (prod2 down) → die Pipelines gehen **nie grün**.

**Literale Evidenz (Dirty-Sweep 08.07., je ein `.gitignore`-Edit triggerte die Matrix):**
- `comdare-network-protocols-all` (Projekt 159) Pipeline 8892/8893: `build-docker-riscv:[…]`/`build-macos-*`/
  `build-docker-windows-*` = `pending` mit **`queued≈6719 s` (~1,9 h)** auf nicht-existenten Runnern;
  `build-linux-arm64` = `failed` (node7-rpi5, 8,5 s); mehrere `build-docker-riscv:[alpine/fedora]` = `failed`.
- `comdare-organization-all` (299) 8894/8895: `audit:layering` = **`failed`** (pve1-debian, 7,5 s) + Rest `pending`.
- `comdare-wrappers-all` (22) 8896/8897: `audit:layering` = **`failed`** (node3-ubuntu, 7,7 s) + Rest `pending`.
- `comdare-foundation-all`: `.gitlab-ci.yml` = v7.0.2, **18 Exoten-Job-Zeilen** (gleiche Klasse).

**Empfehlung (strukturell, NICHT ad-hoc je Repo):** Die Alt-Matrix fleet-weit durch eine passende CI ersetzen.
Muster liegt vor = die **schlanke Zellen-CI** der measurement-Familie (metrics/pmc/workloads:
`include ci-templates ref development /base-pipeline.yml`, `stages:[lint]`, `lint:secrets/format/static`
`tags:[baremetal]`, `COMDARE_LINT_PATHS:"."`). Für **Umbrellas** (statt Zellen) ist statt lint-only die
`module_test_instantiation`-Suite der passende CI-Inhalt (Umbrella-SOLL, [[feedback_umbrella_soll_struktur_trackt_alles_ausser_baseline_zellen]]),
NICHT die Exoten-Plattform-Matrix. Die Voll-Plattform-Matrix (Arch×OS×Docker×Compiler) ist in der Diplomarbeit
als bewusst LETZTE Aufgabe #276 geplant und nur dort testweise als Pflicht — sie gehört nicht als
Dauer-Default in jedes Modul.

---

## HO-B — `comdare-licensing-all` client/server-Generik-Module (KORREKTUR einer früheren Fehlannahme)

**Klarstellung (User 2026-07-08 — meine frühere Notiz war FALSCH und wird hiermit zurückgezogen):** Eine
frühere #38-Notiz bezeichnete die `comdare-db-client-*` in licensing-all als „fehlplatziert" — das ist
**NICHT korrekt**. Die Struktur ist **BY DESIGN**: Es gibt in der Matrix **generische client- UND
server-Module**, und licensing-all implementiert genau dieses Umbrella-SOLL-Muster
([[feedback_umbrella_soll_struktur_trackt_alles_ausser_baseline_zellen]] nennt licensing ausdrücklich als das
Beispiel `client/` + `server/`-Sub-Baselines).

**Ist-Struktur (read-only, korrekt):** `comdare-licensing-all` hat einen `client/`-Zweig
(`cd-buildsystem-licensing`) + `server/`-Zweig (`cd-buildsystem-licensing-server`) + den Baseline-Stack.
Der licensing-README dokumentiert `comdare-db-client-{ftp,hadoop,iscsi,kafka,nfs,sftp,smb,sql,webdav}`
EXPLIZIT als **„Base client modules"** = generische CLIENT-seitige DB-Zugriffs-Module, die der Client-Stack
(`comdare-licensing` = Client-B+-Lizenzbaum, `***CRED-NAME-REF:***CRED-NAME-REF:comdare-registry******`, `comdare-keybridge`) konsumiert; server-seitig
steht `comdare-licensing-server` (baseline_2-server). → **KEINE thematische Fehlplatzierung, KEIN Transfer nötig.**

**Einzige generische (system-übergreifende, NICHT licensing-spezifische) Umbrella-Frage:** ob solche
generischen client/server-Module als self-tracked externe Zellen (`Modules/<x>`) oder eingebettet geführt
werden — das ist die allgemeine Umbrella-Tracking-/#274-Frage (das Tracking je Umbrella wurde in #33 bereits
bereinigt), kein Defekt der licensing-Familie.

---

## HO-C — `comdare-db` Gitlinks + un-gebumpte Pins (Owner-Rollout-Grenze)

**Befund:** `Products/comdare-db` ist ein separates System (eigener Ledger). Zwei Teilbefunde:
- **34 Gitlinks** im comdare-db-Umbrella (aus #33-Audit) — noch als Voll-Gitlinks getrackt statt CMake-Hot-Clone;
  Bereinigung = Owner-Sache nach Umbrella-SOLL.
- **3 un-gebumpte Submodul-PINS** (Dirty-Sweep 08.07.): `baseline_3-database_blocks/comdare-dataprogramming`
  (d635e5d→d250acf), `comdare-dedup-strategies` (eeb8bcb→15b75ea), `comdare-objectstore` (000c022→fa8f12a).
  Die drei **Leaf-Repos sind sauber + gepusht** (`ahead=0`, Commits „ci: deploy v7.0.3 — L1/L2 module rewrites
  + COMDARE variable migration (S2671)") — d.h. der Buildsystem-/db-Rollout v7.0.3/S2671 ist auf Leaf-Ebene
  fertig; der Umbrella-Pin-Bump ist der **nächste koordinierte Owner-Schritt**. Ich habe die Pins BEWUSST nicht
  gebumpt (Kollisions-Vermeidung mit der v7.0.3-Sequenz + Handover-Grenze).

---

## HO-D — Naming-Regression `redcomponent`/`bep` (Task #32, buildsystem-nah)

**Befund:** Reste des Alt-Namings existieren fleet-weit (u.a. `include/redcomponent/...` in den 4 archivierten
foundation-master-Zweigen, tote `BEPBuildSystem`-cmakePackage-Referenz, `BEP-EULA`-Produktlabel, verwaiste
ignore-Muster `/redcomponent-protocol-*/`). **Marke = Comdare** (alle Produkt-/Modul-/Namespace-/Repo-Namen);
**Firma = „BEP Venture UG"** — NUR juristisch, in LICENSE-/EULA-/Rechtstexten korrekt und zu ERHALTEN
([[project_struktur_regression_geteilte_klone_statt_instanz_repos]]). Der Sweep muss den Firmennamen aussparen.
buildsystem.xml bleibt Owner-Hoheit ([[feedback_buildsystem_xml_hands_off_parallel_ci_cmake]]) — der
Namens-Sweep dort erfolgt durch den Buildsystem-Agenten.

---

## HO-E — Archiv-Material (verlustfrei, aus #35)

Bei der Fleet-Branch-Konsolidierung (#274 Schritt 2) wurden 6 nicht-mergebare `master`-Zweige **verlustfrei
archiviert** statt gelöscht (Backup-Refs + Verify): `archive/redcomponent-initial-20260213` ×4
(caa36511/cb9bef73/e8acff6f/18e894b9) + `archive/master-pre-merge-conflict-20260707` ×2 (2139cd5f/45e03898).
Diese Archiv-Branches sind Owner-Material — bei der Struktur-Auflösung berücksichtigen, nie löschen
([[feedback_never_delete_documentation]]).

---

## HO-F — Dirty-Sweep-Bereinigungen 08.07. (bereits von mir vollzogen, zur Kenntnis)

Diese `.gitignore`-/Gitlink-Korrekturen habe ich im Sweep committet+gepusht (main+development), damit die
Umbrella-Bäume wieder clean sind (Umbrella-SOLL: nur Zellen-INHALTE ignoriert, nicht getrackt):
- `network-protocols` (159) `4079995`: `comdare-protocol-webdav`-Gitlink ent-trackt (self-tracked Repo,
  remote-verifiziert) + verwaistes ignore `/redcomponent-protocol-*/` → `/comdare-protocol-*/` nachgezogen.
  **REST**: 6 weitere `comdare-protocol-*`-Gitlinks (ftp/iscsi/nfs/sftp/smb/sshfs) gleich behandeln nach
  Owner-Entscheid (Unter-Repos vorher remote-verifizieren).
- `organization-all` (299) `588609c`: erfüllte `comdare-tax`-Ausnahme-Negation entfernt (`comdare-tax` ist
  seit #33 self-tracked) → `/comdare-*/` deckt die Stufe wieder.
- `wrappers-all` (22) `2bb715a`: ignore-Muster für die 6 self-tracked `*-wrapper`-Zellen (ohne comdare-Präfix)
  ergänzt.
**Achtung Owner:** die CI dieser Pushes ist die kaputte Alt-Matrix (HO-A) — die Commits sind korrekt und
gelandet, die roten/hängenden Pipelines sind der HO-A-Defekt, nicht diese Edits.

---

## Zusammenfassung für die Owner
| # | Befund | System-Owner | Auflösung |
|---|---|---|---|
| HO-A | v7.0.x-Alt-Matrix hängt/failt auf offline-Runnern | foundation/buildsystem-CI | fleet-weit durch schlanke/Umbrella-CI ersetzen (metrics-Muster) |
| HO-B | KORREKTUR: `comdare-db-client-*` = generische CLIENT-Module, KORREKT platziert (client/server-SOLL) | — | kein Transfer; nur generische Umbrella-Tracking-Frage (#274) |
| HO-C | comdare-db 34 Gitlinks + 3 un-gebumpte Pins | comdare-db | Umbrella-SOLL-Bereinigung + Pin-Bump im v7.0.3-Rollout |
| HO-D | redcomponent/bep-Naming | buildsystem/#32 | Sweep→Comdare, „BEP Venture UG" juristisch erhalten |
| HO-E | 6 Archiv-Branches | alle | erhalten, bei Auflösung berücksichtigen |
| HO-F | Dirty-Sweep-Bereinigungen (erledigt) | — | nur Kenntnis + Rest-Protocol-Gitlinks |
