# Drawio-Export-Strategie + REV7-Plan

**Stand:** 2026-05-15 (K-C.9)
**Quelle:** `Phase5_UML_Detail/09_drawio_export.md` (162 Z)

---

## §1 Tab-Struktur (REV6 Stand, 32 Tabs)

| # | Tab-Name | Quelle | Hauptklassen |
|---|---|---|---|
| 1 | 01-A Page-Bausteine | 01_uml_search_engine §2 | IPage + alle PAGE_*-Klassen |
| 2 | 01-B Node-Bausteine | 01_uml_search_engine §3 | INode + alle NODE_*-Klassen |
| 3 | 01-C Traversal-Bausteine | 01_uml_search_engine §4 | ITraversalAlgorithm + Traversal-Klassen |
| 4 | 01-D ValueHandle | 01_uml_search_engine §5 | ValueHandle (variant) + DynamicValueHandle |
| 5 | 01-E MemoryLayout | 01_uml_search_engine §6 | IMemoryLayout + Layout-Klassen |
| 6 | 01-F Allocator | 01_uml_search_engine §7 | IAllocator + IPlatformAllocatorFactory |
| 7 | 01-G Prefetch | 01_uml_search_engine §8 | IPrefetchStrategy + Prefetch-Klassen |
| 8 | 02-A CacheEngine Singleton | 02_uml_cache_engine §1 | CacheEngine, ObserverRegistry |
| 9 | 02-B DecisionLambdaTrees | 02_uml_cache_engine §2 | IDecisionLambdaTree + 10+ Tree-Familien |
| 10 | 02-C ConcurrencyManager | 02_uml_cache_engine §3 | IConcurrencyDiscipline + IConcurrencyMechanic + Composition |
| 11 | 02-D TelemetryStrategy NEU 2026-05-09 | 02_uml_cache_engine §4 | ITelemetryStrategy + Kuehn-Klassen |
| 12 | 02-E Event-Hierarchie | 02_uml_cache_engine §5 | Event-Subklassen + ObserverRegistry |
| 13 | 02-F CacheHierarchyManager | 02_uml_cache_engine §6 | F4 Plattform-Adapter |
| 14-32 | (siehe Original Doc 09 fuer Detail) | (UML 03-06) | (Measurement, Hardware/ISA, Engine-Choice, Persistence) |

**REV4 Tab-Layout (Konzept-/UML-Trennung):**
- K01-K06: Konzept-Tabs (Drei-Ebenen-Architektur, Saeule A Hierarchie, Visitor + 4-Ebenen, Hybrid-Command, Saeule B Plattform-Modell, Forschungs-Mission F15)
- U01-U06: UML-Tabs (IExecutingEngine Klassen, Saeule A Page-Familie, Strategy-Familie, Hybrid-Command Klassen, Saeule B Plattform-Probe, Cache + Heuristic)
- MX1: Layer-vs-Matrix Strategie

---

## §2 REV7 drawio-Plan (Phase K-H)

**Strategie:** REV6 als Basis kopieren + 5 existierende Tabs aktualisieren + 4 NEUE Tabs hinzufuegen.

### 2.1 Existierende Tabs aktualisieren (5 Sub-Phasen K-H.2-5)

| K-H Sub-Phase | Tab | V12-V31 Update |
|---|---|---|
| K-H.2 | 01-A bis 01-G + Search Engine Saeule | V12-V13 Container-API + status_t errno-style |
| K-H.3 | K01-K05 Konzepte | REV7-Aktualisierungen (Drei-Repo + Custom Allokation) |
| K-H.4 | MX1 Layer-vs-Matrix | Update fuer V30 libs/-Migration |
| K-H.5 | U01-U06 UML-Klassen | V12-V31 Klassen-Updates |

### 2.2 NEUE Tabs (4 Sub-Phasen K-H.6-9)

| K-H Sub-Phase | NEUER Tab | Inhalt |
|---|---|---|
| K-H.6 | REV7-Master | Drei-Repo-Architektur Uebersicht (cache-engine + prt-art + Diplomarbeit/Code/) |
| K-H.7 | Adapter-Familie | 22 V31-Adapter (12 SOTA + 10 Allokator) mit COMDARE_HAVE-Flag-Pattern |
| K-H.8 | P27-Bundles | hp_soft + HierarchicalBundlePrefetcher (Build-Time-Tool + Runtime L1/L2/L3) |
| K-H.9 | libs/-Layout | V30-Konsolidierung (cache_engine, execution_engine, search_engine, common/{config,...}, test_infra, deprecated) |

### 2.3 JPG-Export pro Tab (K-H.10)

Pro Tab ein .jpg fuer Praesentations-Beilage (analog REV4-jpgs), siehe vorhandene `phase5_uml_detail_REV4-K01..U06.jpg`.

---

## §3 Notations-Konvention

**ASCII-Sicherheit (REV4-Lektion):**
- KEINE deutschen Anfuehrungszeichen `„` `"` in drawio-Strings
- KEINE ASCII-Anfuehrungszeichen `"` mitten in value-Attributen (XML-Parser-Fehler!)

**Edge-Style (REV4 Lektion):**
```
edgeStyle=orthogonalEdgeStyle;
rounded=0;
orthogonalLoop=1;
jettySize=auto;
html=1;
```
mit explizit gesetzten exit/entry-Punkten — Verbindungslinien laufen nur **vertikal/horizontal**, kreuzen keine Klassen quer.

**Farb-Konvention:**
- Konzept-Tabs (K-Praefix): hellblau Hintergrund
- UML-Tabs (U-Praefix): hellgruen Hintergrund
- Matrix-Tabs (MX-Praefix): hellgelb Hintergrund

---

## §4 Tab-Status nach K-H

Geplant fuer REV7-drawio (`phase5_uml_detail_REV7.drawio`):
- 32 existierende Tabs aktualisiert
- 4 NEUE Tabs (REV7-Master, Adapter-Familie, P27-Bundles, libs/-Layout)
- **Total: 36 Tabs**

### §4.1 Stand 2026-05-15 (Session 4700 + Folge)

| K-H Sub-Phase | Status |
|---|---|
| K-H.1 REV6 → REV7 Kopie als Basis | ✅ DONE (`phase5_uml_detail_REV7.drawio`) |
| K-H.2 Tab 01 Search Engine V12-V13 Update | ✅ DONE (Banner + Trace-Tab Eintrag U01/U07) |
| K-H.3 Tabs K01-K05 Konzepte REV7-Update | ✅ DONE (Banner + Trace-Tab Eintraege K01-K05h) |
| K-H.4 Tab MX1 Layer-vs-Matrix Update | ✅ DONE (Banner + Trace-Tab Eintrag K14 Layer-Matrix-Hybrid) |
| K-H.5 Tabs U01-U06 UML-Klassen Update | ✅ DONE (Banner + Trace-Tab Eintraege U01-U10) |
| K-H.6 NEU REV7-Master | ✅ DONE (Drei-Repo-Architektur Snapshot) |
| K-H.7 NEU Adapter-Familie | ✅ DONE (22 V31-Adapter mit COMDARE_HAVE-Pattern) |
| K-H.8 NEU P27 hp-soft + Bundle-Prefetcher | ✅ DONE (Build-Time-Tool + Runtime L1/L2/L3) |
| K-H.9 NEU libs/-Layout V30-Konsolidierung | ✅ DONE (5 Sub-Migrationen V30.D.1-D.5) |
| K-H.X NEU REV7-Konsolidierungs-Trace | ✅ DONE (Pro-Tab Stand vs V31-Aenderungen + K-H Status-Summary) |
| K-H.10 JPG-Export pro Tab | ⏳ pending (drawio CLI noetig, USER-Aktion) |

**Total Tabs:** 45 (40 alt + 4 neu V31-substantiell + 1 Trace).

**Konsolidierungs-Strategie (Memory-Direktive: niemals Doku loeschen):**
- Alle 40 alten Tabs INHALTLICH UNVERAENDERT (Original-XML bleibt)
- Banner `REV7 Stand 2026-05-15 / V31.F / K-H Konsolidierungs-Sprint` in ALLEN 45 Tabs (rechts oben, klein, einheitlich)
- NEUE Tabs (4 substantiell + 1 Trace) bringen V31-Inhalte und Cross-Refs
- Trace-Tab listet pro alten Tab welche V-Sprints relevant + welche konsolidierte Doku

---

## §5 V31-Code-Bezug fuer drawio-Update

Pro NEUER Tab (K-H.6-9):

### REV7-Master Tab (K-H.6)
- Verweis auf `02_aktueller_master_REV7_7.md` §1+§2 (3 Saeulen + Drei-Repo-Layer)
- Boxen: `Diplomarbeit/Code/`, `comdare-prt-art`, `comdare-cache-engine`
- Kanten: Submodule-Pin-Bumps (16176ee → 1a36ab4 → 0f7b4d2)

### Adapter-Familie Tab (K-H.7)
- Verweis auf `02_aktueller_master_REV7_7.md` §8 + `../bausteine/01_bausteine_matrix.md`
- 12 SOTA-Adapter (P01-P30) gruppiert nach Cluster
- 10 Allokator-Adapter (A01-A20) gruppiert nach AA-Achsen
- Adapter-Pattern (Code-Snippet-Box mit COMDARE_HAVE_<X>-Flag)

### P27-Bundles Tab (K-H.8)
- Verweis auf `02_aktueller_master_REV7_7.md` §9
- Build-Time-Tool: `tools/p27_bundle_finder/` (CallGraph + DFS + Threshold-Filter)
- Runtime-Skelett: `prt_art/legacy_reimpl/P27-*/HierarchicalBundlePrefetcher` (L1/L2/L3-Tracking)

### libs/-Layout Tab (K-H.9)
- Verweis auf `02_aktueller_master_REV7_7.md` §10
- ASCII-Tree:
  ```
  libs/
   ├── cache_engine/        (134 .hpp + 7 .cpp + 22 Builder-Subs)
   ├── execution_engine/
   ├── search_engine/        (8 INTERFACE-Subs)
   ├── common/{succinct,serialization,platform,measurement,config}/
   ├── test_infra/
   └── deprecated/prt_art_legacy/
  ```
- Top-Level cache-engine: 8 → 5 Verzeichnisse (libs/, apps/, adapters/, ext/, tools/)

---

## §6 Querverweise

- Original-Quelle (UNVERAENDERT): `../termine/20260508 Termin 7/Phase5_UML_Detail/09_drawio_export.md`
- REV6-drawio (Basis fuer K-H): `../termine/20260508 Termin 7/Phase5_UML_Detail/phase5_uml_detail_REV6.drawio`
- REV4-Tab-JPGs (Vorlage fuer K-H.10): `../termine/20260508 Termin 7/Phase5_UML_Detail/phase5_uml_detail_REV4-*.jpg`
- UML-Klassen Master: `05_uml_klassen.md` (K-C.6)
- REV-Historie: `01_REV_Historie.md` §11 Visualisierungs-Status (K-C.2)
- Aktueller Master REV7.7: `02_aktueller_master_REV7_7.md` (K-C.3)
- TODO-Liste K-H.1-K-H.10: 10 Sub-Tasks #433-#442 in TaskList
