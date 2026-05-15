# Cluster D — Prefetching 1

**Stand:** 2026-05-15 (K-F.6)
**Quelle:** `../termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions/cluster_D_prefetching_1.md` (410 Z)
**Inhalt:** 4 Prefetching-Paper P20, P21, P22, P23

---

## §1 Cluster-Mitglieder

| P-ID | Paper | Autoren / Jahr / Venue | V31-Adapter |
|---|---|---|---|
| **P20** | B-Trees Are Back | Mueller/Benson/Leis (2025, SIGMOD) | `comdare::adapter::p20_leanstore::LeanStoreAdapter` ✅ MIT |
| **P21** | Improving Index Performance through Prefetching (PB-Trees) | Chen/Gibbons/Mowry (2001) | LEGACY_REIMPL |
| **P22** | Fractal Prefetching B+-Trees | Chen et al. (2002) | LEGACY_REIMPL |
| **P23** | Dynamic Adaptation of Cache Prefetching | Khan (2010) | LEGACY_REIMPL |

---

## §2 Cluster-Kernkonzepte

### 2.1 Prefetch-Strategien

| Paper | Strategie |
|---|---|
| P21 Chen 2001 | PB-Trees: Software-Prefetching mit fester Distanz |
| P22 Chen 2002 | Fractal Prefetching: in-page Tree mit adaptive Width pro Tier (Disk-Tier + Cache-Tier) |
| P23 Khan 2010 | Dynamic Adaptation of Prefetch Distance |
| P20 Mueller 2025 | Adaptive Layout-Selection (6 Layouts + adaptive selection at runtime) |

### 2.2 LeanStore (P20)

P20 "B-Trees Are Back" zeigt, dass B-Trees mit modernem Layout-Engineering wieder kompetitiv sind:
- 6 Layout-Optimierungen
- Adaptive Layout-Selection zur Laufzeit
- Slotted Page Node

Direkter Bezug zu V31-Adapter: `comdare::adapter::p20_leanstore::LeanStoreAdapter`.

### 2.3 Hybrid-Aufloesung (REV5 K3.4)

P22 Fractal Prefetching ist "hybrid" → wird in atomare Commands zerlegt:
- Disk-Tier-Command
- Cache-Tier-Command
- Adaptive-Width-Command

(Detail: `../architektur/09_taxonomien.md` §3.2)

---

## §3 Vollangaben (siehe Original)

Detail-Konzept-Extraktionen pro Paper:
`../termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions/cluster_D_prefetching_1.md`

---

## §4 Bausteine-Matrix-Mapping (Achse 7 Prefetch + Achse 1 Page)

| Bausteine-ID | Achse | Paper |
|---|---|---|
| `PAGE_PREFETCH_CHEN`, `PAGE_FRACTAL_CHEN` | 1 | P21, P22 |
| `PAGE_ADAPTIVE_BTREESAREBACK` | 1 | P20 |
| `PREFETCH_SOFTWARE_FIXED` | 7 | P21 |
| `PREFETCH_ADAPTIVE_DISTANCE` | 7 | P23 |
| `TRAVERSAL_PREFETCH_AHEAD` | 3 | P21 |
| `TRAVERSAL_ADAPTIVE_PREFETCH_DIST` | 3 | P23 |

---

## §5 Architekturentscheidungs-Bezug

| Paper | ADR-Bezug |
|---|---|
| P21 | F5 ISoftwarePrefetchStrategy (Cache-Strategien-Taxonomie F5) |
| P22 | F4 IMultiCacheLineNodeStrategy + F5, F11 IPrefetchHintHeaderStrategy |
| P23 | F6 IAdaptivePrefetchDistanceStrategy |
| P20 | F22 IAdaptiveLayoutStrategy + F-EXTRA-7 (Run-Time-Auswahl) |

---

## §6 Querverweise

- Original-Quelle (UNVERAENDERT): `../termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions/cluster_D_prefetching_1.md`
- Cluster E (Prefetching 2 + Telemetry): `06_cluster_E_prefetching_telemetry.md`
- Quellen-Gesamtkatalog: `01_quellen_gesamtkatalog.md` §2 B (Cache-Engine / Aktives Cache-Management)
- Bausteine-Matrix: `../bausteine/01_bausteine_matrix.md` §3+§9 (Page + Prefetch)
- Cross-Paper-Konzeptmatrix: `../bausteine/03_cross_paper_konzeptmatrix.md` Konzept 13 PREFETCHING
- Eigenschaften pro Algorithmus: `../bausteine/06_eigenschaften_suchalgorithmen.md` §5 Kategorie C
