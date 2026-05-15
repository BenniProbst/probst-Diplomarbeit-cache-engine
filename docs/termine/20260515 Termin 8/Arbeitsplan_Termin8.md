# Arbeitsplan Termin 8 — PRT-ART Diplomarbeit (2026-05-15)

**Stand:** 2026-05-15 (Termin 8)
**Vorgaenger:** `../20260508 Termin 7/HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md`
**Sprint-Anzahl seit Termin 7:** 20 (V12 bis V31, alle DONE)
**ChatGPT-Vorab-Versuch:** in `_archive_chatgpt/` archiviert (war inhaltlich falsch)

---

## §1 Drei-Repo-Architektur (Bestaetigung Stand Termin 7)

| Repo | Rolle | HEAD (gepusht) |
|------|-------|---------------|
| `comdare-cache-engine` | **WIE** + Werkzeuge | `16176ee` (V31.F) |
| `comdare-prt-art` | **Pruefling** | `1a36ab4` (Pin auf V31.F) |
| `Diplomarbeit/Code/` | **WAS** + Auswertung | `75e92d8` (Master-Plan + V31-Final) |

Alle 3 Repos gepusht auf GitHub (BenniProbst-Account, privat).

---

## §2 Was seit Termin 7 (2026-05-13) bearbeitet wurde

### 2.1 Sprint-Block V12-V14 (User-Feedback std-API + Naming + Folge-Operations)

| Sprint | Schwerpunkt | Status |
|---|---|---|
| V12 | PrtArtSearchEngine Vector-API +5 / Map-API +8 / Container-Vertraege / Naming-Audit / baustein_variants Achsen 2-11 | DONE |
| V13 | runtime_codegen + functional_tests + CMake Stage-1/2 + thesis/-Skelett (9 Kapitel) | DONE |
| V14 | 76 neue Tests + CI Test-Discovery-Workaround + Manuskript Kapitel 02-04 | DONE |

### 2.2 Sprint-Block V15-V18 (Manuskript + CI + Codegen-Templates)

| Sprint | Schwerpunkt | Status |
|---|---|---|
| V15 | Manuskript Kapitel 01+05+06+07 + PROJECT_LAYER_MAPs §11 V12-V14 Delta | DONE |
| V16 | Build-Verifikation + thesis/main.tex pdflatex Build + ART (P01) Module-Body Vorlage | DONE |
| V17 | Codegen Template-Substitution + 7 Tier-1 SOTA-Module-Body-Templates | DONE |
| V18 | Codegen Multi-Template-Path (cache-engine + prt-art) | DONE |

### 2.3 Sprint-Block V19-V22 (Profile-Stack + Mess-Pipeline)

| Sprint | Schwerpunkt | Status |
|---|---|---|
| V19 | algorithm_profiles XML-Schema +`<expected_workload>` (V11.2 ueberschreiben) | DONE |
| V20 | PermutationResult.workload_used Field + ResultAggregator CSV/JSON | DONE |
| V21 | art_body Template ext/-Verdrahtung + Sample-Mess-Daten + thesis chapter 06 Sample-Diagramm | DONE |
| V22 | diagram_generator plot_by_workload + End-to-End Sample-Pipeline-Test + thesis pdflatex Re-Build | DONE |

### 2.4 Sprint-Block V23-V24 (Layout-Refactoring cache-engine)

| Sprint | Schwerpunkt | Status |
|---|---|---|
| V23.A | Cleanup (build-Dirs, .gitignore, CMakePresets) | DONE |
| V23.B | apps/cache_engine_builder/ extrahieren | DONE |
| V23.C | libs/common/{succinct,serialization,platform,measurement} | DONE |
| V23.D | libs/domain/ — initial DEFERRED (ueber V30 nachgeholt) | DONE via V30 |
| V23.E | prt_art/-Subsumption (libs/deprecated/prt_art_legacy/) | DONE |
| V23.F | test_infra + adapters + Final-Verifikation | DONE |
| V24.A-E | prt-art Cleanup + Diplomarbeit/Code Cleanup + 3 PROJECT_LAYER_MAPs Update | DONE |

### 2.5 Sprint-Block V25-V29 (Profile-Stack-Erweiterung + Allokator-Override)

| Sprint | Schwerpunkt | Status |
|---|---|---|
| V25.B | `<expected_workload>`-Tag fuer alle 30 SOTA-Profile | DONE |
| V25.C | adapters/ Skelette in cache-engine (11 SOTA) | DONE |
| V26.A | Allokator-Profile A01-A20 (10 Profile) | DONE |
| V26.B | Allokator-Adapter-Skelette (10 Stueck) | DONE |
| V26.C | prt-art codegen/templates/ Erweiterung | DONE |
| V27 | PROJECT_LAYER_MAP-Updates in 3 Repos | DONE |
| V28 | thesis chapter 02 +SOTA-Profile-Tabellen (30 SOTA + 10 Allokator) | DONE |
| V29 | ExperimentDriver Allokator-Override (`<allocator_override>`-Tag) | DONE |

### 2.6 Sprint-Block V30 (libs/-Migration vollstaendig)

User-Direktive 2026-05-14: **Option C+** = ohne `domain/`-Zwischenebene, flach `libs/<modul>/`.

| Sprint | Migration | Tests |
|---|---|---|
| V30.D.1 | `experiment/` → `libs/execution_engine/` | 31/31 |
| V30.D.2 | `search_engine/` → `libs/search_engine/` | configure OK |
| V30.D.3 | `engine_choice/` → `libs/common/config/` + ALIAS | configure OK |
| V30.D.4+D.5 | `cache_engine/` → `libs/cache_engine/` (134 .hpp + 7 .cpp + 22 Builder-Subs) | 31/31 |

**Ergebnis:** Top-Level cache-engine bereinigt (8 → 5 Verzeichnisse: libs/, apps/, adapters/, ext/, tools/). 9 hardcodierte Pfade aktualisiert.

### 2.7 Sprint-Block V31 (Adapter-Inhalte + P27 hp-soft + NOTICE Architekt-Direktive II)

**Architekt-Direktive II (User 2026-05-14, in NOTICE verankert):**

> "Da wir alle Algorithmus-Bestandteile zerschneiden, entsteht fuer alle
> Permutations-Achsen ein neues Werk. Das gilt fuer alle Lizenztypen.
> Repos ohne Lizenztypen haben nur ein formales copyright, also muss
> nur der Autor beim zitieren genannt werden."

→ Damit GPL-3 (P04, P07), LGPL (P29), no-LICENSE (P06, P25, P30, A03) **alle freigegeben** fuer Adapter-Aktivierung.

| Sprint | Inhalt | Files | Tests |
|---|---|---|---|
| V31-PRE | Lizenz-Audit aller 22 ext/-Repos (`LICENSE_AUDIT_EXT.md`) | 1 | n/a |
| V31.A | NOTICE +Architekt-Direktive II 2026-05-14 | 2 | n/a |
| V31.K1 | P01-ART unodb-Adapter (Pilot, Apache-2.0) | 2 | 1 |
| V31.K2 | A04-mimalloc-Adapter (Pilot, MIT) + Bug-Fix Fallback | 2 | 2 |
| V31.K3 | 11 SOTA-Adapter (P02-P30) | 22 | 11 |
| V31.K4 | 9 Allokator-Adapter (A01-A20) | 18 | 9 |
| V31.K5 | P27 hp_soft.py → C++23-Port (`tools/p27_bundle_finder/`) | 3 | n/a (CLI) |
| V31.K6 | P27 Runtime-Skelett (im prt-art Repo, schon vorhanden) | 0 | 5 (existed) |
| V31.F | Smoke-Test-Suite | 2 | 23 gruen |
| V31.I | thesis chapter 04 +V25-V31 + Habich-Briefing-Refresh | 3 | 24 S PDF |

### 2.8 P27-Mail-Antwort hp-soft.zip (2026-05-14)

Boris Grot + Youhui Zhang lieferten `hp-soft.zip` (1981 B):
- `hp_soft.py` (3751 B): Build-Time Call-Graph-Analyse via objdump
- `readme.txt` (436 B): Input-Spec
- **Charakter-Hinweis:** "Mehr kommt nicht" (User) — keine Folge-Mails

Was es leistet: identifiziert Funktionen mit Subtree-Footprint > Threshold (240KB) als "potential entry points of Bundles" fuer Hierarchical-Bundle-Prefetcher.

---

## §3 Wo wir JETZT stehen (Stand-Snapshot 2026-05-15)

### Code (3 Repos)
- **22 V31-Adapter** mit `COMDARE_HAVE_<X>=OFF` default + std::malloc-Fallback
- **30 SOTA-Profile** + **10 Allokator-Profile** mit `<expected_workload>` + optional `<allocator_override>`
- **libs/-Layout konsolidiert** (V30): cache_engine, execution_engine, search_engine, common/{succinct,serialization,platform,measurement,config}, test_infra, deprecated
- **P27 Bundle Finder Tool** (`tools/p27_bundle_finder/`)
- **PrtArtSearchEngine hybrid** (Vector/Map/Tuple-API + status_t)
- **Diplomarbeit/Code/** mit messung_driver, binary_to_csv, csv_to_latex, diagram_generator, latex_to_pdf
- **23/23 V31-Adapter-Smoke-Tests** + **5 P27-Runtime-Tests** + **31/31 Codegen-Tests** alle gruen

### Doku
- **NOTICE** mit Architekt-Direktive II 2026-05-14
- **LICENSE_AUDIT_EXT.md** mit allen 22 ext-Repos
- **thesis/main.pdf** 24 Seiten (V28: SOTA-Tabellen, V31.I: chapter 04 V19-V31)
- **3 PROJECT_LAYER_MAPs** mit V12-V31 Delta
- **Master-Plan** `docs/MASTERPLAN_KONSOLIDIERUNG_TERMINE.md` (10-Phasen-Plan)
- **V31-Final-Anker** + **Habich-Termin-8-Briefing-Refresh** in `docs/sessions/`
- **Fortschrittsdokumentation V30+V31** (371 Zeilen, konsolidiert)

### CI / Push
- GitLab + GitHub Actions in alle 3 Repos
- Alle Commits gepusht (DNS war kurz aus, jetzt OK)

---

## §4 Was steht NACH Termin 8 an

### Prio 1 (kurzfristig)
- **HW-E2E Mess-Reihe (V21.2)**: User-Aktion, braucht reale Hardware
  - i7-1270P lokal als erste Mess-Targets
  - Spaeter ZIH-Cluster (Barnard CPU, Capella GPU)
- **Cluster-Migration**: paralleler User-Agent (system32 macht NUR Implementation, KEINE Infrastruktur)

### Prio 2 (mittelfristig)
- **Master-Plan Phasen K-B bis K-J** (siehe `docs/MASTERPLAN_KONSOLIDIERUNG_TERMINE.md`)
  - K-B: docs/termine/INDEX-Refresh
  - K-C: docs/architektur/ aus Phase5_UML_Detail (24 Quelldokumente)
  - K-D: docs/glossar/ aus Begriffsglossar v2-v7
  - K-E: docs/bausteine/ aus Bausteine_Matrix etc.
  - K-F: docs/forschungslandkarte/ aus 33-Paper-Cluster + Allokatoren
  - K-G: docs/termine_konsolidiert/ vollstaendige Tieflektuere ALLER 7 Termine
  - K-H: drawio REV7 (REV6 erweitern + Master-Tab)
  - K-I: docs/INDEX.md + Cross-Refs
  - K-J: Termin-7-Doks fortgefuehrt auf V31-Stand
- **Geschaetzt:** ~11 Tage ueber mehrere Sessions

### Prio 3 (laengerfristig)
- **ext-Repo-Aktivierung** pro Adapter (Original-Compiler-Setup, Cluster-Aufgabe)
- **Manuskript-Vollausbau** Kapitel 06 mit echten Mess-Daten
- **Email-Antworten** auf P06 (B²-Tree-Lizenz), P28 (Kuehn-Code), P31/P32/P33 (TUD-Habich-Folge)

---

## §5 Diskussionspunkte fuer Termin 8

### 5.1 Architekt-Direktive II OK?
GPL-3-Adapter (P04-CoCo-trie, P07-Wormhole) + LGPL (P29-RCU) + no-LICENSE
(P06, P25, P30, A03) sind durch User-Direktive freigegeben — Habich sollte
das informationshalber kennen.

### 5.2 libs/-Layout ohne `domain/`-Zwischenebene OK?
Wurde in V30 ohne Habich-Konsultation entschieden — User-Direktive
"Option C+" (Zwischenebene unnoetig). Habich sollte das absegnen.

### 5.3 P27 hp_soft Sammelsurium akzeptabel?
Build-Time-Tool da, Runtime ist `HierarchicalBundlePrefetcher`-Skelett.
Was fehlt aus Habich-Sicht fuer wissenschaftliche Akzeptanz?

### 5.4 HW-E2E Mess-Reihe — konkretes Setup?
Aktuell nur Sample-Daten + Diagramm-Generator. Welche Hardware-Targets
sind fuer Diplomarbeit-Mess-Reihen priorisiert?
- i7-1270P lokal (Cache + DRAM, kein NUMA)
- ZIH-Cluster Barnard (CPU, NUMA)
- ZIH-Cluster Capella (GPU NVIDIA A100)
- HBM-Hardware (welche?)

### 5.5 Manuskript-Tiefe pro Kapitel
thesis/main.pdf 24 Seiten Skelett — Habich-Richtwert fuer Diplomarbeit?
Welche Kapitel brauchen Vertiefung?

### 5.6 Permutationsexplosion (5,5 × 10^9)
Strategie: Profile-Filter + MessreihenMode::Defined fuer Manuskript-Plots,
Full-Mode nur fuer ZIH-Cluster-Laeufe. Habich-Bestaetigung?

### 5.7 Naechster Habich-Termin?

---

## §6 USER-pending (kein Auto-Erledigen moeglich)

| # | Pending | Status |
|---|---|---|
| #74 | Email-Antworten P06, P28, P31, P32, P33 | offen, P27 abgeschlossen |
| #77 | Cluster-Migration Fortigate-31G + GitLab | User-Agent parallel |
| #95 | Kuehn-Code-Download P28 DaMoN | offen |
| #109 | Debian-Pod als YCSB-Provider | INFRA, offen |
| #111 | Talos OS Java-Runtime-Provisioning | INFRA, offen |
| V21.2 | HW-E2E Mess-Reihe | DIESER TERMIN diskutieren |
| V21.5 | Habich-Termin~8 | DIESER TERMIN |

---

## §7 Querverweis

- Vorgaenger: `../20260508 Termin 7/HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md`
- Vorbereitung (V14 Stand): `../20260508 Termin 7/HABICH_TERMIN8_VORBEREITUNG_2026_05_14.md`
- Briefing-Refresh (V31 Stand): `../../sessions/20260514-4500-habich-termin-8-briefing-refresh-v19-v31.md`
- Fortschritt V30+V31: `../../sessions/20260514-4600-fortschrittsdokumentation-v30-v31.md`
- Master-Plan: `../../MASTERPLAN_KONSOLIDIERUNG_TERMINE.md`
- thesis main.pdf: `../../../thesis/main.pdf` (24 Seiten)
