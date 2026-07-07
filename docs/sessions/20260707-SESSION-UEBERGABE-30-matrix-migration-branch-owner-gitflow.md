# SESSION-ÜBERGABE 30 — Matrix-Migration gestartet + GitFlow-Branch-Doktrin + Owner-Sauberung (2026-07-07)

**Agent:** Diplomarbeits-IMPL-Agent (comdare@prod1, Fable 5) · **Modus:** interaktiv + Goal-driven · **Abschluss-Grund:** User-Auftrag „Kontext endet jetzt". · **Vorgänger:** Übergabe 29 (Goal-V3-Strecke). Diese Session hat die #274-Matrix-Migration real GESTARTET und die Branch-/Owner-Governance der GESAMTEN GitLab-Flotte etabliert.

> **WICHTIGSTE NEUE NORMATIVE QUELLEN (zuerst laden):**
> - Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` §13.12 **GOAL-V3-ERGÄNZUNG** (Voll-Pfad-Referenzen aller Matrix-Docs) + §12-Einträge 07.07.
> - `docs/STANDARDPROZESS-RESEARCH-ZU-PRODUCT.md` (3D-Matrix-Doktrin + Research→Product-Prozess)
> - `docs/sessions/20260705-matrix-grundlagen-goalv2/MATRIX-GRUNDLAGEN-GOALV2.md` (kanonische Regeln INV-1..4 — lag Tiefe 5, jetzt gefunden)
> - `docs/sessions/20260706-274-MATRIX-MIGRATIONSPLAN-ENTWURF.md` (+ADDENDUM 1/2 + Ausführungs-Protokoll)
> - `docs/sessions/20260707-gitlab-gruppen-vs-ordner-DIFF.md` · `docs/sessions/20260707-G12-pat-credential-helper-migration.md`

---

## 1. VERSTÄNDNIS-KORREKTUR (der Kern dieser Session)

Nach einem Wortwahl-bedingten Missverständnis („294 Repos migriert" = NUR G12-Credentials, NICHT Struktur) hat der User die Matrix-Taxonomie präzisiert (bindend, §12 verankert):

- **Matrix ist DREIDIMENSIONAL: Familien × Baseline-Stufen × MODULE.** Familien = `comdare-<x>-all`-Umbrellas; Stufen = `comdare-baseline_N-<name>/`-Ordner; Module = die Zellen (je Zelle ein eigenes Repo).
- **Generische Module = metaprogrammierungs-offen, NUR Source-Code** (Templates, keine Binaries).
- **Jedes Product/Research organisiert beim Modul-Konsum eine EIGENE Matrix** (Familien×Stufen×Module) aus separaten Repos, die die Template-Module **als echte Interface-Binaries** instanziieren. **Research = Products mit gelockerten Eigenschaften.**
- **Product-Familien heißen `comdare-<x>-product`** (NICHT -all), tragen nur ein **Subset** der relevanten Module; **leere Baseline ⇒ Ordner wird NICHT angelegt.**
- **Taxonomie-Anker:** cache-engine = **Framework-MODUL** (eigene Familie); Diplomarbeit = dessen **PRODUCT + Außeninterface**; **prt-art = Achsen-erweiterndes Metaprogrammierungs-Modul IN der cache-engine-Familie**; Overleaf/Thesis = **Product ohne Baseline-Struktur** (kein Programmiersprachen-Projekt).
- **F6-Doktrin:** jedes Achsen-THEMA = Modul-Framework mit Metaprogrammierungs-Interface (Kopf-Framework, keine Produkte); compile-time heuristisch optimale Auswahl in die Tier-Binary.
- **F4-Vision:** ce + Diplomarbeit = Piloten der automatischen Buildsystem-Optimierung; Buildsystem = Product mit eigener Interface-Ebene, bestückt Programme automatisch mit Beschleuniger-Code.
- **F1:** Buildsystem halbfertig → parallele Direktentwicklung mit CI+CMake; **buildsystem.xml NICHT anfassen** (eigener Buildsystem-Agent).
- **„Migration" bedeutet: FUNKTIONS-Zerteilung des Research-Monolithen IN die bestehende Matrix — NIE Umbau der bestehenden Matrix.**

## 2. BRANCH-DOKTRIN (GitFlow, User 07.07. — jetzt fleet-weite Governance)

- **main** = Default/stabile Basis, trägt den NEUESTEN Stand (Vereinigung aller Branches).
- **development ≥ main** (development stets auf main-Stand ODER voraus; aktive Arbeit läuft auf development). Wenn main je voraus → development hochziehen.
- **master** wird gelöscht **NUR wenn `master ⊆ main`** (main hat master-Stand oder voraus). Sonst zuerst master→main mergen (neuester Stand). **Merge-Konflikt ⇒ master BLEIBT + Meldung** („nichts löschen, was wir nicht verantworten können").
- **Grundsatz: immer auf den neuesten Stand syncen.**

## 3. ERLEDIGT (alles CI-/API-belegt)

**Diplomarbeit-Code (V3-Strecke, Fortsetzung):**
- **#279-a** (Mess-Modus-Schalter + Tier-Binary-Build-Sichtbarkeit): super 8316/009ada3 grün. Modul `Code/07_tier_binary_report/`.
- **Architektur-Audit migrierter libs/common/-Zellen** (wf_b770955b, 9 Agenten): Migration architektur-konform; 1 MAJOR-Fix `test_cpuid_probe` aarch64 (ce 655c0314, Pipeline 8328 grün); beantwortet F12.
- **234-V-a** (Shaped-Emission Mechanik, Option A, default-OFF): ce 02e4df36 (Pipeline 8337 grün), super-Bump d08b83b. Neu: `organ_for_search_algo_shaped.hpp`, `adhoc_emitter_shaped.hpp`, ADHOC_SHAPED-Makro, `test_234_va_shaped_adapter` (6/6). 2 Review-Findings gefixt (shape_include-Emission + struktureller live_nodes-Beweis). **REST = 234-V-b** (Rest-Familien, binary_id-Shape-Segment, Baum→Emitter-Verdrahtung).
- **F14-Web-Recherche** Mess-Schichten: Empfehlung vorgesehene leere `baseline_3-analysis` (Migrationsplan ADDENDUM 2).

**Matrix-Migration #274 (REAL GESTARTET):**
- **G12** (PAT→Credential-Helper): 294 Repos, 296 Remotes tokenlos, `credential.helper store` + `credential.useHttpPath true`; 0 Rest-Tokens in `.git`-Configs. Muster ab jetzt: `git credential fill`.
- **Schritt 0** (measurement-all anlegen): GitLab-Gruppe **`comdare/modules/comdare-measurement` (id 353)** + Umbrella-Projekt **`comdare-measurement-all` (id 300)** + Skelett (Codex-Erstimpl., 3 Review-Fixes, kein buildsystem.xml). meas-Pipeline 8355 grün (mit neuem ci-templates-**Leer-Guard 1b392a3** — cppcheck leer-OK NUR bei 0 Quellen, sonst hart). Lokaler Klon `Modules/comdare-measurement-all` (default jetzt main).
- **Schritt 1** (Doku-Fixierung): ce `modules/README` V41.E4 additiv SUPERSEDIERT (d6d0744a, Pipeline 8361 grün), super-Bump 083b2b3. D-5-Nachtrag = Handover an db-Agenten.

**Fleet-Governance (User-Aufträge):**
- **Owner-Sauberung:** root (id 1) als **direkter Owner (50)** in ALLE 297 Projekte (291 neu + 6 schon) + 46 Gruppen. Verifiziert. (Vorher nur vererbt.)
- **GitFlow-Pilot (3 Repos):** measurement-all (300), comdare-metrics (76), comdare-foundation-all (17) → alle default=main, development erhalten, master gelöscht. **Lehre:** foundation-all master war trotz „+1 Commit" inhaltlich ÄLTER (stale „Merge development into master") — Content-Diff-Prüfung ist Pflicht, kein Regress-Merge.

## 4. IN-FLIGHT / SOFORT WEITER (nächste Session HIER anknüpfen)

**Fleet-Branch-Konsolidierung — Klassifikation läuft:**
- Dry-Run (read-only, 293 Repos) ergab: **15 konform · 35 nur-development · 82 master⊆development (sicher löschbar) · 1 nur-master · 160 master-AHEAD** (master hat Commits, die development fehlen — Content-Prüfung nötig).
- **Content-Klassifikator LÄUFT** (Task war `bv0plekuy`): `scratchpad/master_content_classify.py` → Ergebnis nach **`scratchpad/master_classify.out`** (trennt „stale-älter → verlustfrei" von „Unique-Inhalt → main muss master mergen"). Worst-Cases zu prüfen: `comdare-db/comdare-filestorage` +25, `comdare-db/comdare-storage` +20, diverse client-protocols/licensing +7. **ZUERST dieses Ergebnis lesen**, dann:
  1. **Sichere ~118 Repos** (35 nur-dev + 82 master⊆dev + 1 nur-master) + die als „stale" klassifizierten AHEAD-Fälle ausführen: main aus development anlegen (bei nur-master: master→main), default=main, master löschen (VORHER `compare from=master to=main` == 0 verifizieren).
  2. **„Unique-Inhalt"-AHEAD-Fälle:** master→main mergen (main = neuester Stand), development := main, dann master löschen. **Merge-Konflikt ⇒ master behalten + im Ledger listen.**
- Ausführungs-Muster steht (Pilot bewiesen): API `POST /repository/branches?branch=main&ref=development`, `PUT /projects/:id default_branch=main`, `DELETE /protected_branches/master` (204) dann `DELETE /repository/branches/master`.

**Migrationsplan-Fortgang (nach Branch-Konsolidierung ODER parallel):**
- **Schritt 2** = die Branch-Konsolidierung selbst (A5) — läuft gerade.
- **Schritt 3** = comdare-metrics **Gruppen-Transfer** foundation→measurement (remote-mutierend, GitLab-Transfer mit Redirects; danach foundation-all-Aggregator + Dependents re-verdrahten — nur CMake/CI, F1). **Sensibel — beim User rückversichern vor Ausführung.**
- **Schritt 4** = Scratch-Kopie des Monolithen (lokal, sicher) → **Schritt 5-7** = comdare-pmc/workloads-Zellen befüllen (NEUE Zellen in measurement-Familie, additiv).

## 5. OFFENE USER-GATES / ENTSCHEIDUNGEN (alle bisherigen sind GO)

- **Alle §14.1-Gates + Feinfragen F1–F14 + A–E BEANTWORTET** (GESAMT-GO 07.07.). Nichts offen außer punktuell:
- **cache-engine-Familien-NAME** (beim Anlage-Schritt zu bestätigen; „comdare-cacheengine-all" per A7 VERBOTEN — neue Taxonomie klären).
- **Real-Content-master-Fälle** (aus dem Klassifikator) — je Konflikt-Fall User-Sichtung.

## 6. SICHERHEIT (dringlich, Montag)

- **Der Token in ~/.git-credentials (oauth2 + GitHub-PAT) ist der root `master-token`** (Scopes api/admin_mode/sudo, gültig bis 2027-06-27) — lag bis G12 in ~300 Remote-URLs. **ROTATION dringend** (K88 §2.4 / §13.11). credential-fill-Muster nutzt ihn pfad-genau.
- Alt-System-Rest: `dedup-lab` (Reporter, access 20) vererbt in Projekten — User-Sichtung ob gewollt.

## 7. WERKZEUG-LEKTIONEN (Kadenz)

- **Codex-MCP WIEDER NUTZBAR** via `sandbox: "danger-full-access"` (bwrap-userns durch AppArmor blockiert, `kernel.apparmor_restrict_unprivileged_userns=1`; sudo-Fix im Memory `reference_codex_mcp_prod1_bwrap_shell_broken`). Erstimpl-Kadenz aktiv: cwd-pinnen + Tabus im Prompt + Voll-Review Zeile-für-Zeile.
- **Monitor-Kadenz:** Pipelines-API matcht `?sha=` NICHT als Präfix → Monitore auf **Pipeline-IDs** oder vollen rev-parse-SHA (7-Zeichen-Kurz-SHA machte Welle 8351 unsichtbar).
- **GitHub-Push:** gelegentlich transienter „Invalid username" → Retry (rc=0).

## 8. PIPELINE-/REPO-ENDSTAND (literal)

- **super HEAD `083b2b3`** (main, sauber) — Welle 8362 = success. · **ce `d6d0744a`** (main, Pipeline 8361 success). · **prt-art `faa4e76`** · **thesis `35b7d54`**.
- **measurement-all** (300): main (default) + development, Skelett-Commit `62cbd48`.
- **ci-templates** (269@development): `1b392a3` (Leer-Guard). Klon: `Cluster/_infra/ci-templates-cluster`.
- 3 Pilot-Repos (300/76/17): default=main, master gelöscht.
- Working Trees sauber; keine offenen Monitore außer dem Klassifikator-Hintergrundlauf.

## 9. TASK-BOARD (user-sichtbare TODO)

Offen: #5 (#274-Migration, LÄUFT — Schritt 2 Branch-Konsolidierung) · #11 (#266-P1 config-Vendoring, Q2=config-all GO) · #13/#14/#20/#21/#23 (Montag-Infra) · #25 (#269-Rest 6er-Kanon) · #26-Rest (234-V-b) · #27 (7b-3) · #28 (#270a) · #29 (AP-15 comdare::container) · #31 (F7 Mess-Matrix). Erledigt diese Session: #30 (F14), #26-a (234-V-a), Owner-Sauberung, G12, Schritt 0/1.

## 10. NÄCHSTER ZYKLUS STARTET MIT
`scratchpad/master_classify.out` lesen → sichere Branch-Fälle + stale-AHEAD ausführen → Real-Content/Konflikt-Fälle dem User vorlegen → dann Migrationsplan Schritt 3 (metrics-Transfer, User-Rückversicherung). Branch-Doktrin + Matrix-Taxonomie (§1/§2 oben) sind bindend.
