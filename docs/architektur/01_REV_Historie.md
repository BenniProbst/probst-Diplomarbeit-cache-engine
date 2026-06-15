# Architektur REV-Historie — REV3 → REV7.7

**Stand:** 2026-05-15 (K-C.2)
**Quellen:** Phase5_UML_Detail Doks 20-30 (alle in `../termine/20260508 Termin 7/Phase5_UML_Detail/`)
**Konsolidierung:** Versions-Diff-Tabelle ueber 7 Architektur-Iterationen (REV3 → REV7.7) mit Datum, Aenderungs-Schwerpunkt, drawio-Status.

---

## §1 Versions-Stack (Konfliktregel: spaeter > frueher)

| REV | Datum | Doc-Nr | LOC | Drawio-Status | Hauptaenderung |
|---|---|---|---|---|---|
| REV3 | 2026-05-10 | 20 | 506 | `phase5_uml_detail_REV3.drawio` (12 Tabs) | Erste vollstaendige integrierte Skizze; 3 Saeulen-Architektur (IExecutingEngine + Saeule A + Saeule B) |
| REV4 | 2026-05-10 | 21 | 383 | `phase5_uml_detail_REV4.drawio` (10 Tabs: 6 K + 6 U + 1 MX) | XML-Fix REV3 (ASCII-Anfuehrungszeichen), orthogonale Edges, Konzept/UML-Trennung, Layer-Matrix-Hybrid |
| REV5 | 2026-05-11 | 22 | 1102 | `phase5_uml_detail_REV5.drawio` (12 K + 8 U + 2 MX = 22 Tabs) | Termin 1+2+3+4 Doks integriert; 33-Paper-Matching pro Saeule; Review-Korrekturen K02-K12 |
| REV5.1 | (intern, 2026-05-12) | (in REV6) | (in REV5) | (kein neues drawio) | Web-Recherche Cache Lines + Facade Pattern + Masstree INode/Fanout-Korrektur K02 |
| REV5.2 | (intern, 2026-05-12) | (in REV6) | (in REV5) | (kein neues drawio) | State-Pattern + Visitor-Pattern Web-Recherche; U09 als klassisches UML |
| REV5.3 | (intern, 2026-05-12) | (in REV6) | (in REV5) | (kein neues drawio) | K07 / K08 Splitting in K07a-d / K08a-d |
| REV6 | 2026-05-11 (korr. 2026-05-12) | 23 | 805 | `phase5_uml_detail_REV6.drawio` (32 Tabs) | KORREKTUR-VERMERK 2026-05-12: PRT-ART als ADDITIVE Erweiterung, 6 Seitentypen aus Termin 4 BLEIBEN; PRT-ART-Spezifika nur als Anhang ab §5.17 |
| REV7 | 2026-05-13 | 24 | 872 | (kein neues drawio — geplant K-H) | Custom Allokation als Cache-Engine-Basisdisziplin (21 Allokator-Paper); ABI-stabiles C++23-Modul-Interface mit Drei-Schichten-Hierarchie |
| REV7.1 | 2026-05-13 | 25 | 174 | (kein drawio) | Hybride PrtArtSearchEngine (Vector/Map/Tuple-API + status_t errno-style) |
| REV7.2 | 2026-05-13 | 26 | 108 | (kein drawio) | legacy_reimpl-Migration |
| REV7.3 | 2026-05-13 | 27 | 122 | (kein drawio) | YCSB-CLI Konzept |
| REV7.4 | 2026-05-13 | 28 | 134 | (kein drawio) | CMake-Pipeline Konzept |
| REV7.5 | 2026-05-13 | 29 | 204 | (kein drawio) | Phase 4-7 Loader Konzept |
| REV7.6 | 2026-05-13 | 30 | 216 | (kein drawio) | Drei-Repo-Layer (Diplomarbeit Code/ als Anwender-Schicht) |
| REV7.7 | 2026-05-15 | (in `02_aktueller_master_REV7_7.md`) | (Konsolidierung) | (geplant K-H als REV7-drawio) | V12-V31 Code-Stand integriert: libs/-Migration ohne `domain/`, 22 V31-Adapter mit `COMDARE_HAVE_<X>`-Flags, NOTICE Architekt-Direktive II 2026-05-14, P27 hp-soft-Integration |

---

## §2 REV3 — Erste Vollstandige Architektur-Skizze (2026-05-10)

**Quelle:** `Phase5_UML_Detail/20_architektur_skizze_REV3_2026_05_10.md`

### Drei-Ebenen-Architektur (Wurzel-Sicht)

```
EBENE 1: IExecutingEngine
  ├── ISearchEngine  (PRT-ART-Diplomarbeit-Fokus)
  └── IFutureEngine  (Architektur-Slot — z.B. ICompactingEngine, ISortingEngine, IDeduplicationEngine)
       ▼ konsumiert
EBENE 2: Suchalgorithmus-Datenstruktur (Saeule A)
  IPage / IRootPage / IFanout / INode / ISearchPage / ICachePage /
  ICacheStrategy (Visitor) / ISearchPagesStrategy / ... / Iteratoren-Familie
       ▼ optimiert via
EBENE 3: CacheEngine + Plattform-Modell (Saeule B)
  IPlatformProbe (Auto-Discovery) / IPlatformPropertyClassifier /
  ICacheLevel / ICacheLine / ICacheTopology / ICacheResidency /
  ICpuCore / ICoreLayout / ICoreToThreadMap / IPinningPolicy /
  IHardwareExtension / IIsaFeatureSet /
  IInterconnect / IBusTopology / IMemoryBandwidthModel /
  ILivePlatformModel / ILiveCpuModel /
  IScheduler / IHeuristik / ICacheEngineOptionPublisher /
  DecisionLambdaTrees
```

**Trennungs-Prinzip:**
- Ebene 1 generisch — jede Engine kann CacheEngine als Optimierungs-Service nutzen
- Ebene 2 weiss nichts direkt von CPU/Caches/Bandbreiten — konsumiert nur ICacheStrategy
- Ebene 3 plattform-agnostisch im Code, plattform-konkret im Verhalten via Auto-Discovery

---

## §3 REV4 — XML-Fix + Layer-Matrix-Hybrid (2026-05-10)

**Quelle:** `Phase5_UML_Detail/21_architektur_skizze_REV4_2026_05_10.md`

**Behobene Fehler aus REV3:**
- ASCII-Anfuehrungszeichen `"` mitten in drawio-Strings → XML-Parser-Fehler. Fix: alle `"` aus value-Attributen entfernt
- Edges nicht orthogonal → Verbindungslinien laufen quer durch Klassen. Fix: `edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;` mit explizit gesetzten exit/entry-Punkten
- Tabs vermischten Konzept und UML → unleserlich. Fix: explizite Trennung in 6 Konzept-Tabs (K01-K06) + 6 UML-Tabs (U01-U06) + 1 Layer-Matrix-Konzept-Tab (MX1)

**NEUE Tabs:**
- K01-K06: Drei-Ebenen-Architektur, Saeule A Hierarchie, Visitor + 4-Ebenen, Hybrid-Command-Pattern, Saeule B Plattform-Modell, Forschungs-Mission F15
- MX1: Layer-vs-Matrix Strategie

---

## §4 REV5 — Termin 1-4 Doks integriert (2026-05-11)

**Quelle:** `Phase5_UML_Detail/22_architektur_skizze_REV5_2026_05_11.md`

**12 Review-Korrekturen K02-K12** (siehe Original Z 5-22 fuer Detail):

| Tab | Review-Befund | REV5 Korrektur |
|---|---|---|
| K02 | Hierarchie unvollstaendig (ISearchPageStructure + Interpreter fehlen) | NEU §2.1+§2.2: jede ISearchPage besitzt eine ISearchPageStructure; Interpreter dekodiert variable lokale Codierung (Invariante I4 aus Termin 2) |
| K03 | CacheEngineBuilder-Permutationsdimension fehlt | NEU §3.3: User waehlt Compile-Time **oder** CacheEngineBuilder erzeugt Permutationsdimension |
| K04 | korrekt | unveraendert |
| K05 | PRT-ART-Bausteinkombination unvollstaendig | NEU §5.2: 7-Quellen-Hybrid (CoCo+ART+START+HOT+Masstree+CSS/CSB+ B²-Tree), 6 Seitentypen, 3 Iteratoren, ValueHandle::{Inline, External, ChainRef} |
| K06 | Hybrid-Command falsch | NEU K13/K14: ISearchEngine-Familien-Taxonomie analog 11_md fuer ICacheEngine |
| K07 | unvollstaendig vs Termin-Inhalt | NEU §7.2: 28 fehlende Saeule-B-Concept-Klassen (IRankSelectPrimitive, IBranchPredictorModel, IBitManipulationFeatureGate, IStorageMedium, IPageCacheModel, IConcurrencyProtocol, IRebuildScheduler, IRebuildCostModel, IWorkloadModel, ICellProbeModel vs IWordProbeModel, ...) |
| K08 | unvollstaendig vs 33-Paper-Code | NEU §8.2: Plattform-Modell verfeinert (NUMA-Awareness, TLB-Modell, Hardware-Counter-Feedback, NVRAM/Persistent-Memory, 6-Flavor-RCU-Klassifikation) |
| K09 | gemeinsam mit K08 | §9: ~80 Heuristiken aus 13_md §9 + 12_md §4 vereint |
| K10 | Layout-Familien enthalten nicht-zerlegte Hybride | NEU §10.2: 8 Hybrid-Aufloesungen (F8 PathCollapse, F11 P11/P22/P26, F13 P17 vEB, F14 P18, F22 P12+P23, F25 P07/P08, F27 P33, F28 P31) |
| K11 | Pfeil Phase 5 → Phase 7 (Darstellungsfehler) | drawio-Korrektur: Phase 5 → Phase 6 → Phase 7 (sequentiell) |
| K12 | Cache+Search-Permutationen-Cross fehlt | NEU §12.2: F15 = vollstaendige Cross-Matrix mit beiden Permutations-Achsen |

---

## §5 REV5.1-5.3 (intern 2026-05-12, in REV6 integriert)

**Quelle:** Sessions 129-137 (REV5.1-5.3 Sub-Iterationen)

- **REV5.1**: Web-Recherche Cache Lines + Cache Layout + Facade Pattern; Masstree INode/Fanout Tieflesen + Korrektur K02
- **REV5.2**: 33 Paper Caching-Eigenschaften tieflesen fuer State-Pattern; State-Pattern + Visitor-Pattern Web-Recherche; U09 komplett neu als klassisches UML; md-Datei 11.1 EXECUTE-Korrektur
- **REV5.3**: K07 in K07a-d feiner splitten; K08 in K08a-d feiner splitten

---

## §6 REV6 — PRT-ART als ADDITIVE Erweiterung (2026-05-11, korrigiert 2026-05-12)

**Quelle:** `Phase5_UML_Detail/23_architektur_skizze_REV6_2026_05_11.md`

**Korrektur-Vermerk 2026-05-12 (User-Direktive):**

Die urspruengliche REV6-Version hatte faelschlicherweise die "6 Seitentypen" aus Termin 4 durch "2 PRT-ART-Node-Typen" ERSETZT. Das war im Cache-Engine-Sinne FALSCH.

**Korrekte Sicht:**

| Perspektive | Aussage |
|---|---|
| Cache-Engine (universell) | Cache-Engine permutiert ALLE Seitentypen aus 33 Papern als Baseline-Familie. **Die 6 Seitentypen aus Termin 4 BLEIBEN** permutierbar. |
| PRT-ART (spezifisch) | PRT-ART ist EINE konkrete Algorithmus-Variante, die je Baustein-Familie ZUSAETZLICHE Permutations-Optionen liefert. Im PRT-ART-Code selbst sind nur 2 Node-Typen (Redirect + B+) verwendet. |

**REV6-Erweiterungen (REIN ADDITIVE):**
- §5.17 NEU PRT-ART-Spezifika (2 Node-Typen + 4 Suchtypen + Dichte-Schwellen + virtuelle Adressierung + linearer Value-Buffer + 4+2 Allokator-Pools + Signaling-Bits-Serialisierung + Multi-RW-Concurrency + Compile-Time-Templates)
- 35 GPT-Antworten + 3 Fallbeispiele aus `comdare-prt-art/GPT questions to prt art.txt` integriert

---

## §7 REV7 — Custom Allokation + ABI (2026-05-13)

**Quelle:** `Phase5_UML_Detail/24_architektur_skizze_REV7_2026_05_13.md`

**Anlass (User-Direktive 2026-05-13):**
1. Custom Allokation wurde als zentrale Cache-Engine-Basisdisziplin **vergessen** und muss umfassend nachgezogen werden (analog 33-Paper-Recherche fuer Suchalgorithmen).
2. Praezise Definition des ABI-stabilen C++23-Modul-Interface mit Drei-Schichten-Hierarchie, Variadic-Templates und compile-time-Fallback-Logik.

**REV7-Erweiterungen:**
- §1 Allokator-Basisdisziplin: Cache-Engine hat zwei parallele Bausteine-Stacks (Such-Algorithmen + Allokationsmethoden)
- §2 Allokator-Paper-Rang-1-Liste: 21 Paper-Quellen + 14 produktive Allokatoren (A01-A23)
- §3 C++ std-Container-Kompatibilitaet (typsicher std::allocator, std::pmr, Concurrency-Modelle)
- §4 ABI-stabiles C++23-Modul-Interface (Drei-Schichten-Hierarchie: execution_engine → search_engine → konkrete Suchalgorithmen wie prt_art)
- §5 CacheEngineBuilder als eigenstaendiges Programm (XML-Konfiguration zulaessiger CacheEngine-Rekombinationen)
- §6 PRT-ART als Pruefling im 3-Stufen-System (Compile-time-Fallback auf CacheEngine-Bibliothek)
- §7 TestDataSetAccumulationEngine
- §8 Mikrobenchmark-Suite
- §9 Plan + Reihenfolge (Phase 6.2 → 6.3 → 7)

---

## §8 REV7.1-7.5 — 5 Deltas (2026-05-13)

| REV | Doc | Inhalt |
|---|---|---|
| REV7.1 | 25 | Hybride PrtArtSearchEngine: 1 Param = std::vector-API, 2 Params = std::map-API, N>2 = map<K, tuple<V...>>; status_t errno-style (0=ok, >0=error code); Schreib-/IO-Ops returnen IMMER int |
| REV7.2 | 26 | legacy_reimpl-Migration: cache-engine `prt_art/legacy_reimpl/` physisch nach prt-art Repo |
| REV7.3 | 27 | YCSB-CLI als Datasets-Tool |
| REV7.4 | 28 | echte cmake-Module-Build-Pipeline (Stage-1 + Stage-2) |
| REV7.5 | 29 | Phase 4-7 ModuleLoader (LoadLibrary/dlopen) |

---

## §9 REV7.6 — Drei-Repo-Layer (2026-05-13)

**Quelle:** `Phase5_UML_Detail/30_architektur_delta_REV7_6_drei_repo_layer_2026_05_13.md`

| Repo | Rolle | Verantwortlichkeit |
|---|---|---|
| `Diplomarbeit/Code/` | WAS + Auswertung | 3 Messreihen, XML-Configs, Driver-Loop, Binary→CSV→LaTeX→PDF |
| `comdare-prt-art` | Pruefling | Hybride PrtArtSearchEngine, 8 Schichten Bausteine |
| `comdare-cache-engine` | WIE + Werkzeuge | Pipeline-Mechanik Phase 1-7, Demo-Workloads, ModuleLoader, Aggregator |

**Drei-Repo-Architektur** wird in REV7.7 (V31 Stand) operationalisiert mit:
- libs/-Layout in cache-engine (V30)
- 22 V31-Adapter (V31.K1-K6)
- Submodule-Pin-Bumps (siehe Pin-Kette in `../sessions/...`)

---

## §10 REV7.7 — V12-V31 Code-Stand integriert (2026-05-15, K-C)

**Quelle:** `02_aktueller_master_REV7_7.md` (K-C.3) + `../sessions/20260514-4600-fortschrittsdokumentation-v30-v31.md`

**Inkremente seit Termin 7:**
- V12-V14: PrtArtSearchEngine std-Container-API + Naming-Audit + thesis-Skelett
- V15-V18: Manuskript Kapitel 01-07 + Codegen-Templates
- V19-V22: Profile-Stack `<expected_workload>` + Mess-Pipeline E2E
- V23-V24: cache-engine Layout-Refactoring (libs/common, libs/test_infra, libs/deprecated)
- V25-V29: Profile-Stack-Erweiterung + Allokator-Override
- V30: libs/-Migration vollstaendig (ohne `domain/`-Zwischenebene)
- V31: 22 Adapter-Inhalte + P27 hp-soft + NOTICE Architekt-Direktive II

**Total: 20 Sprints, alle DONE.** ~180 Tests gruen ueber alle 3 Repos. thesis main.pdf 24 Seiten.

---

## §11 Visualisierung-Status (drawio)

| REV | drawio-Datei | Tabs | Status |
|---|---|---|---|
| REV3 | `phase5_uml_detail_REV3.drawio` | 12 | OK (mit XML-Fehler in REV3-NACHARBEITUNG behoben) |
| REV4 | `phase5_uml_detail_REV4.drawio` | 13 (6 K + 6 U + 1 MX) | OK |
| REV5 | `phase5_uml_detail_REV5.drawio` | 22 (12 K + 8 U + 2 MX) | OK |
| REV6 | `phase5_uml_detail_REV6.drawio` | 32 | OK |
| REV7 | (geplant `phase5_uml_detail_REV7.drawio`) | 32 + 4 NEU = 36 | **GEPLANT** in Phase K-H |
| REV7.1-7.5 | (Deltas, kein drawio) | n/a | n/a |
| REV7.6 | (Delta, kein drawio) | n/a | n/a |
| REV7.7 | (geplant in REV7-drawio) | n/a | **GEPLANT** in Phase K-H |

**Phase K-H-Plan:**
- REV6 als Basis kopieren → REV7
- 5 existierende Tabs aktualisieren (Search Engine, K01-K05, MX1, U01-U06)
- 4 NEUE Tabs (REV7-Master, Adapter-Familie, P27-Bundles, libs/-Layout)
- JPG-Export pro Tab fuer Praesentations-Beilage

---

## §12 Querverweise

- Original-Quellen (UNVERAENDERT, Memory-Direktive "niemals Doku loeschen"):
  - `../termine/20260508 Termin 7/Phase5_UML_Detail/20_architektur_skizze_REV3_2026_05_10.md`
  - `../termine/20260508 Termin 7/Phase5_UML_Detail/21_architektur_skizze_REV4_2026_05_10.md`
  - `../termine/20260508 Termin 7/Phase5_UML_Detail/22_architektur_skizze_REV5_2026_05_11.md`
  - `../termine/20260508 Termin 7/Phase5_UML_Detail/23_architektur_skizze_REV6_2026_05_11.md`
  - `../termine/20260508 Termin 7/Phase5_UML_Detail/24_architektur_skizze_REV7_2026_05_13.md`
  - `../termine/20260508 Termin 7/Phase5_UML_Detail/25-30_*.md` (5 REV7-Deltas)
- Aktueller Master REV7.7: `02_aktueller_master_REV7_7.md` (K-C.3)
- V12-V31-Stand-Doku: `../sessions/20260514-4600-fortschrittsdokumentation-v30-v31.md`
- thesis-Manuskript Kapitel 03+04: `../../thesis/chapters/03_architektur.tex` + `04_implementation.tex`
- Bausteine-Matrix (operationalisiert REV7-Permutationen): `../bausteine/01_bausteine_matrix.md`
- Allokator-Matrix (REV7 §2 Allokator-Paper-Rang-1-Liste): `../bausteine/02_allokator_matrix.md`
- Architekturentscheidungen F1-F15 + F-EXTRA: `../bausteine/04_architekturentscheidungen_F1_F15.md`
