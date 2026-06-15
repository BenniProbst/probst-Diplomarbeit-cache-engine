# Vorbereitung Termin 8 (Prof. Habich)

**Datum:** 2026-05-14 (Stand nach V14)
**Vorgaenger:** `HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md` + 7 Sprint-Iterationen V8-V14

---

## 1. Sprint-Overview seit Termin 7

Seit dem 2026-05-13-Termin wurden 7 vollautonome Implementierungs-
Sprints durchgefuehrt (V8-V14). Jeder Sprint folgte dem KIV-Prinzip:
Anker-Session zuerst, dann Code-Aenderungen, dann Final-Session.

| Sprint | Datum | Schwerpunkt | Commits |
|--------|-------|-------------|---------|
| V8     | 2026-05-13/14 | 8 User-Direktiven aus STRUCTURAL_CORRECTION | 4048638 + 54a7224 + bdd63f9 |
| V9     | 2026-05-14 | 30 SOTA-Profile + Codegen-Pipeline + legacy_reimpl-Migration | ded3221 + fbda49c + eb8ae12 |
| V10    | 2026-05-14 | resolve_baustein operational + Profile Auto-Pickup + Codegen-Tests | e824d30 + fd67e82 + c0147dc |
| V11    | 2026-05-14 | notify_*-Verdrahtung + Workload-Routing + GitLab/GitHub CI | 493db36 + 54f024f + 466fdf4 |
| V12    | 2026-05-14 | Vollstaendige std-Container-API + Naming-Audit | 9208ceb + eaf1234 + 8dfde83 |
| V13    | 2026-05-14 | runtime_codegen + functional_tests + Stage-1/2 + thesis/-Skelett | e31faf6 + 0ad2eab + b4b76c3 |
| V14    | 2026-05-14 | 76 neue Tests + CI-Workaround + Manuskript-Inhalte | 13260c7 + e6b79a3 + 65147c6 |

---

## 2. Was ist heute fertig

### 2.1 Code (alle 3 Repos)

- **cache-engine** (HEAD `13260c7`): 30 SOTA-Profile + ExperimentDriver
  mit 7 + 2 opt-in Phasen + 11 baustein_variants-Achsen + resolve_baustein
  operational + Stage-1/2 CMake + 16 Tests (10 V13 + 6 V10.4)
- **prt-art** (HEAD `e6b79a3`): vollstaendige std::vector + std::map +
  Tuple-API + 3 Adapter-Subklassen + notify_*-Hooks vollstaendig + 14
  legacy_reimpl Pruefling + 66 Tests
- **Diplomarbeit** (HEAD nach V15-Push): messung_driver mit
  --messreihen-xml + EXPERIMENT_MODE-Check + experiment_config/messreihen.xml
  + 4 GoogleTest-Suiten + thesis/-Manuskript-Skelett mit 7 inhaltlich
  ausgefuellten Kapiteln + Naming-Konventionen-Doku

### 2.2 CI

- GitLab `.gitlab-ci.yml` (primaer) + GitHub Actions `.github/workflows/ci.yml`
  (synchron) in alle 3 Repos
- V14.3 Test-Discovery-Workaround: direkte Test-Binary-Ausfuehrung
  (umgeht MSB3073 bei MSVC)

### 2.3 Tests (alle gruen)

| Repo | Test-Datei | Anzahl | Lauf-Resultat |
|---|---|---|---|
| cache-engine | test_codegen_from_profile | 6 | 6/6 (113 ms) |
| cache-engine | test_experiment_driver_v13 | 10 | 10/10 (34 ms) |
| prt-art | test_prt_art_identity | 66 | 66/66 (17 ms) |
| Diplomarbeit | test_messung_driver | 13+ | konfiguriert, ctest steht aus |

### 2.4 Doku (alle 3 Repos)

- 7 Anker-Sessions + 7 Final-Sessions in docs/sessions/
- 3 PROJECT_LAYER_MAPs mit §10 (V8-V11) + §11 (V12-V14) Delta-Sektionen
- thesis/-Skelett mit 7 Kapiteln + literatur.bib + Build-Anleitung
- NAMING_CONVENTIONS.md (V12.5 Audit-Befund)
- HABICH_TERMIN7_ZUSAMMENFASSUNG.md mit V8-V14 NACHTRAG-Sektion

---

## 3. Diskussionspunkte fuer Termin 8

### 3.1 Hardware-Validierung der drei Messreihen
**Status:** vorbereitet, ausstehend.
**Frage:** Welche Hardware-Targets sind fuer die ersten Mess-Laeufe
priorisiert (i7-1270P lokal vs. ZIH-Cluster)?

### 3.2 Manuskript-Schreibphase
**Status:** Skelett + Methodik-Kapitel inhaltlich fertig (Kapitel 01-05);
Auswertung (06) wartet auf erste Mess-Daten; Fazit (07) Skelett.
**Frage:** Welche Tiefe pro Kapitel ist fuer Diplomarbeit erforderlich
(Seitenzahl-Richtwert)?

### 3.3 Workload-Routing-Entscheidungen
**Status:** Mapping `traversal`-Tag → YCSB (V11.2) ist heuristisch.
**Frage:** Sollen wir zusaetzliche Workload-Tags pro Profil einfuehren
(z.B. `expected_workload`-Hint in der Profile-XML)?

### 3.4 Module-Bodies pro Permutation
**Status:** Codegen erzeugt aktuell ABI-konforme Skelett-Module.
**Frage:** Welche SOTA-Algorithmen sind fuer "echte" Module-Bodies
priorisiert? (Vorschlag: erst die 8 Rang-1-Profile + PRT-ART)

### 3.5 Compile-Time-Permutationsexplosion
**Status:** 11 × 8 × 5 × 3 × 6 × 16 × 6 × 5 × 6 × 6 × 5 ≈ 5,5 × 10^9
Permutationen.
**Frage:** Welche Strategie ist fuer Build-Time-Beschraenkung sinnvoll?
(Vorschlag: pro Profile fix konfigurierte Permutationen plus Full-Mode
nur fuer die ZIH-Cluster-Laeufe.)

### 3.6 Habich-Sprechstunde-Zeitplanung
**Frage:** Naechster Termin?

---

## 4. Detaillierte Sprint-Resultate

### 4.1 V8 (8 User-Direktiven)
- Drei-Repo-Architektur klargestellt
- COMDARE_EXPERIMENT_MODE CMake flag
- ResultAggregator in ExecutionEngine
- algorithm_profiles/ Ordner mit 8 Rang-1-Profilen
- defined/full mode in xml_config_parser
- algorithm_baustein.hpp std::variant Pattern
- PrtArtSearchEngineAdapter (Komposition)
- prt-art TestDataSetAccumulationEngine im Constructor

### 4.2 V9 (Vollausbau)
- 22 weitere Rang-2/3-Profile (P11-P32) — total 30 SOTA
- baustein_variants.hpp mit 11 Achsen × Tag-Strukturen
- generate_module_from_profile (Codegen-API)
- legacy_reimpl/ physisch nach prt-art verschoben
- 3 konkrete Adapter-Subklassen (Map/Vector/Tuple)
- messung_driver liest --messreihen-xml=FILE

### 4.3 V10 (Operationalisierung)
- legacy_reimpl in cache-engine geloescht (Migration komplett)
- resolve_baustein operationalisiert (11 Tag-Specializations)
- notify_*-Methoden Skelett mit TODO-Markern
- 6 Codegen-Roundtrip-Tests
- ExperimentDriver Auto-Pickup von Profilen
- MessreihenMode + sota_profile_filter Options

### 4.4 V11 (E2E-Verdrahtung)
- notify_*-Methoden vollstaendig verdrahtet
- Profile-aware Workload-Routing in Phase 5
- messung_driver Spec → ExperimentDriverOptions E2E
- baustein_variants Page-Achse mit description+paper_ref
- experiment_config/messreihen.xml Template
- GitLab CI + GitHub Actions in alle 3 Repos

### 4.5 V12 (User-Feedback std-API + Naming)
- PrtArtSearchEngine Vector-API +5 Methoden
- PrtArtSearchEngine Map-API +8 Methoden
- search_engine ABI Container-Vertraege
- baustein_variants Achsen 2-11 vollstaendige Bodies
- NAMING_CONVENTIONS.md (Audit + Doku)

### 4.6 V13 (Folge-Operationalisierung)
- test_codegen_from_profile 6/6 Tests gruen
- PrtArtSearchEngine merge + extract
- enable_runtime_codegen + enable_functional_tests verdrahtet
- CMake Stage-1/Stage-2-Integration
- thesis/-Skelett mit 9 Kapitel-Files

### 4.7 V14 (Tests + CI + Manuskript)
- 15 neue prt-art Tests + 10 neue cache-engine Tests
- 2 Bug-Fixes (V11.2 Workload-Type, V12.2 storage_t)
- CI Test-Discovery-Workaround
- Manuskript Kapitel 02-04 inhaltlich

### 4.8 V15 (heute)
- Manuskript Kapitel 01+05+06+07 inhaltlich
- 3 PROJECT_LAYER_MAPs §11 V12-V14 Delta
- Habich-Termin-8-Vorbereitung (dieses Dokument)

---

## 5. Querverweise (komplette Pfade)

- Master-Architektur: `20260508 Termin 7/Phase5_UML_Detail/24_architektur_skizze_REV7_2026_05_13.md`
- Termin-7-Zusammenfassung: `20260508 Termin 7/HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md` (mit V8-V14 Nachtrag)
- 6-Tage-Review-Plan: `20260508 Termin 7/REVIEW_PLAN_6_TAGE.md`
- Master-FINDINGS: `FINDINGS_REV7_6_diplomarbeit.md`
- Master-STRUCTURAL_CORRECTION: `STRUCTURAL_CORRECTION_diplomarbeit.md`
- Manuskript-Skelett: `thesis/main.tex` (+ chapters/01-07 + A1/A2 + literatur.bib)
- Naming-Konventionen: `docs/NAMING_CONVENTIONS.md`
- Sessions-Verlauf: `docs/sessions/` (V8-V15 Anker + Final, je 2 pro Sprint)

---

## 6. NACHTRAG (2026-05-15): Sprint V16-V31 (16 weitere Sprints)

Nach V15 wurden weitere 16 Sprints ausgefuehrt. Detail-Snapshot fuer
Termin 8 in den 3 dedizierten Dokumenten unter
`docs/termine/20260515 Termin 8/`:
- `Arbeitsplan_Termin8.md`
- `Arbeitsergebnis_Termin8.md`
- `Praesentation_Termin8.md`

### 6.1 Sprint-Block V16-V18 (Codegen-Templates)
| Sprint | Schwerpunkt |
|---|---|
| V16 | Build-Verifikation aller 3 Repos + thesis/main.tex pdflatex Build + ART (P01) Module-Body Vorlage |
| V17 | Codegen Template-Substitution + 7 weitere Rang-1 SOTA-Module-Body-Templates |
| V18 | Codegen Multi-Template-Path (cache-engine + prt-art) + prtart_body.hpp.template |

### 6.2 Sprint-Block V19-V22 (Profile-Stack + Mess-Pipeline)
| Sprint | Schwerpunkt |
|---|---|
| V19 | algorithm_profiles XML-Schema +`<expected_workload>` (V11.2 ueberschreiben) + Tests |
| V20 | PermutationResult.workload_used Field + ResultAggregator CSV/JSON +Spalte |
| V21 | Sample-Mess-Daten-Generator + thesis chapter 06 Sample-Diagramm |
| V22 | diagram_generator plot_by_workload + End-to-End Sample-Pipeline-Test + thesis pdflatex Re-Build |

### 6.3 Sprint-Block V23-V24 (cache-engine Layout-Refactoring)
| Sprint | Schwerpunkt |
|---|---|
| V23.A | Cleanup (build-Dirs, .gitignore, CMakePresets) |
| V23.B | apps/cache_engine_builder/ extrahieren |
| V23.C | libs/common/{succinct,serialization,platform,measurement} |
| V23.D | libs/domain/ — initial DEFERRED, ueber V30 nachgeholt |
| V23.E | prt_art/-Subsumption (libs/deprecated/prt_art_legacy/) |
| V23.F | test_infra + adapters + Final-Verifikation |
| V24.A-E | prt-art + Diplomarbeit/Code Cleanup + 3 PROJECT_LAYER_MAPs Update |

### 6.4 Sprint-Block V25-V29 (Profile-Stack-Erweiterung + Allokator-Override)
| Sprint | Schwerpunkt |
|---|---|
| V25.B | `<expected_workload>`-Tag fuer alle 30 SOTA-Profile |
| V25.C | adapters/ Skelette in cache-engine (11 SOTA INTERFACE-Libs) |
| V26.A | 10 Allokator-Profile A01-A20 mit Workload-Tag |
| V26.B | 10 Allokator-Adapter-Skelette |
| V26.C | prt-art codegen/templates/ Erweiterung |
| V27 | PROJECT_LAYER_MAP-Updates in 3 Repos (V19-V27 Delta-Kapitel) |
| V28 | thesis chapter 02 +SOTA-Profile-Tabellen (30 SOTA + 10 Allokator) |
| V29 | ExperimentDriver Allokator-Override (`<allocator_override>`-Tag) |

### 6.5 Sprint-Block V30 (libs/-Migration vollstaendig)
**User-Direktive 2026-05-14:** Option C+ = ohne `domain/`-Zwischenebene.

| Sprint | Migration | Tests |
|---|---|---|
| V30.D.1 | `experiment/` → `libs/execution_engine/` | 31/31 |
| V30.D.2 | `search_engine/` → `libs/search_engine/` | configure OK |
| V30.D.3 | `engine_choice/` → `libs/common/config/` + ALIAS comdare::common::config | configure OK |
| V30.D.4+D.5 | `cache_engine/` → `libs/cache_engine/` (134 .hpp + 7 .cpp + 22 Builder-Subs) | 31/31 |

**Top-Level cache-engine:** 8 → 5 Verzeichnisse. **9 hardcodierte Pfade** aktualisiert.

### 6.6 Sprint-Block V31 (Adapter-Inhalte + P27 + NOTICE Architekt-Direktive II)

**User-Direktive 2026-05-14 (in NOTICE verankert):**
> "Da wir alle Algorithmus-Bestandteile zerschneiden, entsteht fuer alle
> Permutations-Achsen ein neues Werk. Das gilt fuer alle Lizenztypen.
> Repos ohne Lizenztypen haben nur ein formales copyright."
→ GPL-3 (P04, P07), LGPL (P29), no-LICENSE (P06, P25, P30, A03) **freigegeben**.

| Sprint | Inhalt | Tests |
|---|---|---|
| V31-PRE | Lizenz-Audit aller 22 ext/-Repos (`LICENSE_AUDIT_EXT.md`) | n/a |
| V31.A | NOTICE +Architekt-Direktive II 2026-05-14 | n/a |
| V31.K1 | P01-ART unodb-Adapter (Pilot, Apache-2.0) | 1 |
| V31.K2 | A04-mimalloc-Adapter (Pilot, MIT) + Bug-Fix Fallback | 2 |
| V31.K3 | 11 SOTA-Adapter (P02-P30) | 11 |
| V31.K4 | 9 Allokator-Adapter (A01-A20) | 9 |
| V31.K5 | P27 hp_soft.py → C++23-Port (`tools/p27_bundle_finder/`) | n/a (CLI) |
| V31.K6 | P27 Runtime-Skelett (im prt-art Repo, schon vorhanden) | 5 (existed) |
| V31.F | Smoke-Test-Suite | **23 gruen** |
| V31.I | thesis chapter 04 +V25-V31 + Habich-Briefing-Refresh | 24 S PDF |

### 6.7 P27-Mail-Antwort hp-soft.zip (2026-05-14)

Boris Grot + Youhui Zhang lieferten **hp-soft.zip** (1981 B):
- `hp_soft.py` (3751 B): Build-Time Call-Graph-Analyse via objdump
- `readme.txt` (436 B): Input-Spec
- **User-Hinweis:** "Mehr kommt nicht" → keine Folge-Mails

Was es leistet: identifiziert Funktionen mit Subtree-Footprint > Threshold (240KB)
als "potential entry points of Bundles" fuer Hierarchical-Bundle-Prefetcher.

### 6.8 Stand-Snapshot 2026-05-15 (Termin 8)

| Repo | HEAD | Push |
|------|------|------|
| comdare-cache-engine | `16176ee` (V31.F) | OK |
| comdare-prt-art | `1a36ab4` (Pin V31.F) | OK |
| Diplomarbeit/Code | `75e92d8` (Master-Plan + V31-Final) | OK |

- ~180 Tests gruen ueber alle 3 Repos
- thesis/main.pdf 24 Seiten
- 22 V31-Adapter mit `COMDARE_HAVE_<X>=OFF` default
- 1800 deklarierte Permutationen (30 × 10 × 6)
- libs/-Layout konsolidiert
- NOTICE Architekt-Direktive II
- Master-Plan `docs/MASTERPLAN_KONSOLIDIERUNG_TERMINE.md` (10 Phasen K-A bis K-J fuer docs/-Konsolidierung)

### 6.9 Querverweis

- Termin-8-Trio: `docs/termine/20260515 Termin 8/`
- Master-Plan: `docs/MASTERPLAN_KONSOLIDIERUNG_TERMINE.md`
- Fortschrittsdoku V30+V31: `docs/sessions/20260514-4600-fortschrittsdokumentation-v30-v31.md`
- Briefing-Refresh V19-V31: `docs/sessions/20260514-4500-habich-termin-8-briefing-refresh-v19-v31.md`
