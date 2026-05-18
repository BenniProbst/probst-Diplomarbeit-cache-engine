# docs/bausteine/ — Index

**Stand:** 2026-05-15 (K-E.1)
**Phase:** K-E des Master-Plans `../MASTERPLAN_KONSOLIDIERUNG_TERMINE.md`
**Zweck:** Konsolidierte Bausteine-, Allokator-, Cross-Paper- und Architekturentscheidungs-Doku.

---

## Inhalte

| Datei | Inhalt | Quelle (Termin 7) | Anzahl |
|---|---|---|---|
| `01_bausteine_matrix.md` | 85 Bausteine ueber 11 Achsen mit V31-Adapter-Status | `Bausteine_Matrix.txt` (964 Z) | 85 IDs |
| `02_allokator_matrix.md` | 23 Allokator-Quellen (A01-A23) ueber 7 Achsen + 5 Cluster | `Allokator_Matrix.txt` (801 Z) | 23 IDs |
| `03_cross_paper_konzeptmatrix.md` | 18 Cross-Paper-Konzepte aus 33 Papern | `Cross_Paper_Konzeptmatrix.txt` (389 Z) | 18 Konzepte |
| `04_architekturentscheidungen_F1_F15.md` | F1-F15 + 2 Korrekturen K + 8 F-EXTRA = 25 ADRs | `Architekturentscheidungen_F1_F15.txt` (975 Z) | 25 ADRs |
| `05_flag_system.md` | 9-Bank-Flag-System (F10-K Korrektur) | `Flag_System.txt` (370 Z) | 9 Banken |
| `06_eigenschaften_suchalgorithmen.md` | 23 Algorithmen in 4 Hauptkategorien (A-D) | `Eigenschaften_Suchalgorithmen.txt` (669 Z) | 23 Algorithmen |
| **`07_bausteine_matrix_N_erweitert.md`** | **N-Phase Erweiterung: 14 Achsen + Sub-Achsen Detail** (Stand 2026-05-18) | (User-Direktive 2026-05-18) | 14 Achsen + ~30 Sub-Achsen |

**Total:** 7 Konsolidierungs-Doks (6 K-E + 1 N-Phase).

### N-Phase Achsen-Erweiterung (2026-05-18, siehe 07_*.md)

| Aenderung | Was | Task |
|---|---|---|
| Achse 3 TRAVERSAL | gesplittet in 3.A SearchAlgo + 3.B Cache + 3.M Mapping | N.5 (#468) |
| Achse 6 ALLOCATOR | gesplittet in 6.1-6.5 (Allocation/Reclamation/NUMA/HugePage/FreeList) | N.1 (#464) |
| Achse 8 CONCURRENCY | gesplittet in 8.1 Pattern + 8.2 Locking-Mode | N.2 (#465) |
| Achse 11 TELEMETRY | erweitert um Kuehn 11.X1-X4 (Leaf-Only / Sampling / Offline / Anti-Pattern) | N.6 (#469) |
| **NEU Achse 12 HARDWARE** | 5 Sub-Achsen (SIMD/Cache-Level/NUMA/Prefetch-HW/Atomic-Family) | N.3 (#466) |
| **NEU Achse 13 SCHEDULING** | 5 Sub-Achsen (Worker-Pool/SIMD-Limit/Hetero-Core/Co-Routine/Batch) | N.4 (#467) |

---

## Memory-Direktive beachtet

Original-Quellen unter `../termine/20260508 Termin 7/` bleiben **VOLLSTAENDIG**
erhalten (Bausteine_Matrix.txt etc.). Konsolidierte Master-Doks unter
`docs/bausteine/` referenzieren nur (Pfad+Zeile), kopieren nicht voll-Inhalt.

---

## Querverweise

- Master-Plan: `../MASTERPLAN_KONSOLIDIERUNG_TERMINE.md`
- Architektur (REV-Historie + REV7.7-Master): `../architektur/` (K-C, in Arbeit)
- Glossar (Begriffe + Domaenenmodell): `../glossar/` (K-D, fertig)
- Forschungslandkarte (33 Paper Cluster): `../forschungslandkarte/` (K-F, in Arbeit)
- Termine-Konsolidiert: `../termine_konsolidiert/00_INDEX.md` (K-G, geplant)

---

## Status der Adapter-Implementierung (V31, Stand 2026-05-15)

22 Adapter sind als Skelette implementiert (COMDARE_HAVE_<X>=OFF default):

- **12 SOTA-Adapter** (Achse 1+2+3 der Bausteine-Matrix):
  P01-ART, P02-HOT, P03-Masstree, P04-CoCo-trie, P05-START, P06-B2tree, P07-Wormhole, P10-SuRF, P20-leanstore, P25-Mahling, P29-RCU, P30-HazardPointers
- **10 Allokator-Adapter** (Achse 6 der Bausteine-Matrix):
  A01-Hoard, A03-Michael, A04-mimalloc, A05-jemalloc, A06-tcmalloc, A07-snmalloc, A08-scalloc, A10-rpmalloc, A11-LRMalloc, A20-dlmalloc

23/23 Smoke-Tests gruen. ext-Repo-Aktivierung pro Adapter ist Cluster-Aufgabe (F-EXTRA-1).

Lizenz-Audit: `../../Code/external/comdare-cache-engine/LICENSE_AUDIT_EXT.md`.
NOTICE-Datei mit Architekt-Direktive II: `../../Code/external/comdare-cache-engine/NOTICE`.
