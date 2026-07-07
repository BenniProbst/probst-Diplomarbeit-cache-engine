# #34 — GitLab-Gruppenstruktur-Spiegelplan (Ordnerstruktur = SOLL)

**Stand:** 2026-07-07 · **Autor:** Diplomarbeits-IMPL-Agent · **Status:** ZUR USER-SICHTUNG (keine Transfers vor GO)
**Grundlagen:** User-Konvention 07.07. (lokales Layout = SOLL; Umbrella trackt alles außer Baseline-Zellen; Products = Umbrella-Äquivalent, Instanziierungs-Benennung `comdare-<produkt>-<modul>`, multiple Stufen-N-Baselines verschiedener Familien flach) · Memory `feedback_umbrella_soll_struktur_trackt_alles_ausser_baseline_zellen` · Diff-Doc `20260707-gitlab-gruppen-vs-ordner-DIFF.md` · Ist-Erhebung 17:5x (311 Projekte, 44 Untergruppen).

## 1. SOLL-Abbildungsregel (Ordner → GitLab)

| Lokal | GitLab |
|---|---|
| `Projekte/Modules/comdare-X-all/` (Umbrella-Repo) | Projekt `comdare/modules/comdare-X/comdare-X-all` (in der Familien-**Gruppe**) |
| `…/comdare-X-all/comdare-baseline_N-<name>/` (Stufe) | **Untergruppe** `comdare/modules/comdare-X/comdare-baseline_N-<name>` |
| `…/comdare-baseline_N-<name>/<zelle>/` (Modul-Repo) | Projekt in der Baseline-Untergruppe |
| Sub-Strukturen (`client/`, `server/`, Mehrzellen-Module) | weitere Untergruppen-Ebene (exakt wie Ordner) |
| `Projekte/Products/<produkt>/` | Gruppe `comdare/products/<produkt>` + Umbrella-Projekt darin + Baseline-Untergruppen wie oben |

Namen EXAKT wie Ordner (inkl. `comdare-baseline_N`-Präfix mit Unterstrich). GitLab kann Projekte nicht unter Projekten nesten — Umbrella-Projekt und Baseline-Untergruppen liegen daher nebeneinander in der Familien-Gruppe (bekannter technischer Spiegel-Constraint, Standardprozess §1b).

## 2. Ist-Abweichungen (Erhebung 07.07.)

1. **Modules (17 Familien-Gruppen existieren):** Zellen liegen FLACH in der Familien-Gruppe (z.B. encryption 17, network-protocols 68, foundation 15) — **keine Baseline-Untergruppen**. → Kern der Arbeit.
2. **Products/comdare-db:** hat bereits Baseline-Untergruppen + Mehrzellen-Sub-Gruppen, aber mit **Namens-Drift** (`baseline-2-core` statt `comdare-baseline_2-core`). → Gruppen-Renames = **db-Hoheit, eigene Abstimmung** (Tranche H).
3. **cd-buildsystem-construct:** eigenes layer0–4-Schema (lowercase vs. lokal `Layer1-Foundation`) — **Buildsystem-Hoheit** (Tranche H).
4. **steuerrater-a/b, comdare-web:** Umbrella-Projekte flach in `comdare/products` — brauchen je Produkt-Gruppe + Baseline-Untergruppen (je 1 core-Zelle aus #33).
5. **Research:** flach + `archive` — **UNANGETASTET** bis Studienabschluss (Forschungs-Track 286/287/288/289; Trennung ist explizit deferred, Memory `project_cache_engine_research_vs_cacheengine_all_split_todo`).
6. **mirrors:** unangetastet (Upstream-Spiegel).

## 3. Mechanik je Familie (idempotent, verlustfrei)

1. Baseline-Untergruppen anlegen (`POST /groups`, parent = Familien-Gruppe; Name/Pfad = Ordnername).
2. Zellen-Projekte per `PUT /projects/:id/transfer` in ihre Baseline-Untergruppe (Redirects entstehen automatisch; git-Zugriffe über Alt-Pfade funktionieren weiter).
3. Umbrella-Projekt liegt bereits in der Familien-Gruppe (nur Verifikation).
4. Verify je Familie: Projektliste der Untergruppen == lokale Ordner-Zellen (Skript-Diff).
5. **Drossel:** 2 s zwischen Transfers, Tranche = eine Familie, 500er → Backoff-Retry (Transfer-Mechanik heute am metrics-Fall bewiesen, inkl. Registry-Abhängigkeit — die ist seit dem CoreDNS-Fix gesund).
6. **Lokaler Nachzug (gebündelt am Ende):** origin-URLs der Klone + Credential-Store-Einträge (useHttpPath) auf neue Pfade; Redirects überbrücken bis dahin.
7. Transfers triggern KEINE Pipelines (kein Sturm-Risiko); Sidekiq-Last über Drossel begrenzt.

## 4. Tranchen

| Tranche | Inhalt | Umfang (Gruppen+Transfers) | Gate |
|---|---|---|---|
| **A (Muster)** | comdare-encryption | ~5 Untergruppen, ~16 Transfers | GO dieses Plans |
| B | foundation, client, storage, core, filestorage, treecore, archiving, binary-analytics, config, organization, external, measurement, wrappers, licensing (inkl. client/server-Ebene), cacheengine | ~60 Untergruppen, ~140 Transfers | A verifiziert |
| C | network-protocols (größte Familie, 68) | ~8 Untergruppen, ~67 Transfers | B verifiziert |
| D | Products: steuerrater-a/b, comdare-web | 3 Gruppen + ~8 Untergruppen, ~6 Transfers | C fertig |
| **H (Hoheit)** | comdare-db-Namens-Angleichung, cd-buildsystem-Layer-Case | Gruppen-RENAMES | **eigene Abstimmung User/System-Agenten** |
| — | Research, mirrors, cluster, infrastructure | KEINE Änderung | — |

## 5. Risiken/Absicherung

- **Gruppen-Renames (Tranche H) ändern Pfade OHNE Projekt-Redirect-Garantie für Untergruppen-Ketten** → nur mit Hoheits-GO und lokalem Nachzug in einem Zug.
- Credential-Store ist pfadgebunden → Nachzug-Schritt Pflicht (sonst erster Push auf neuen Pfad interaktiv-blockiert; `GIT_TERMINAL_PROMPT=0` schützt Skripte).
- Alt-CIs einzelner Zellen können nach Transfers manuell getriggerte Läufe zeigen — Transfers selbst erzeugen keine; Zombie-Sweep-Muster steht bereit.
- Rollback: Transfer zurück = derselbe API-Call in Gegenrichtung; Gruppen sind leer löschbar. Nichts wird gelöscht.

**Nach GO:** Tranche A sofort, Verify-Report, dann B→C→D in einem Lauf mit Zwischenberichten; H als separater Abstimmungs-Punkt.
