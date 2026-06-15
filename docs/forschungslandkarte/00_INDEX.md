# docs/forschungslandkarte/ — Index

**Stand:** 2026-05-15 (K-F.1)
**Phase:** K-F des Master-Plans `../MASTERPLAN_KONSOLIDIERUNG_TERMINE.md`
**Zweck:** Konsolidierte Forschungslandkarte mit 33 SOTA-Paper P01-P33 + 23 Allokator-Paper A01-A23 in 6+1 Clustern.

---

## Inhalte

| Datei | Inhalt | Quelle (Termin 7) | LOC |
|---|---|---|---|
| `01_quellen_gesamtkatalog.md` | 56 Paper-Master-Katalog mit Vollangaben + V31-Adapter-Status | `Quellen_Gesamtkatalog.txt` (732) + REV7 §2 | 732 |
| `02_cluster_A_trie.md` | Cluster A Trie-Familie (P01, P02, P04, P05, P09, P10) | `_paper_extractions/cluster_A_trie.md` | 503 |
| `03_cluster_B_hybrid_bplus.md` | Cluster B Hybrid + B+ (P03, P06, P07, P11, P12, P13) | `_paper_extractions/cluster_B_hybrid_bplus.md` | 426 |
| `04_cluster_C_layout_theorie.md` | Cluster C Layout-Theorie (P14, P15, P16, P17, P18, P19) | `_paper_extractions/cluster_C_layout_theorie.md` | 626 |
| `05_cluster_D_prefetching_1.md` | Cluster D Prefetching 1 (P20, P21, P22, P23) | `_paper_extractions/cluster_D_prefetching_1.md` | 410 |
| `06_cluster_E_prefetching_telemetry.md` | Cluster E Prefetching 2 + Telemetry (P24, P25, P26, P27, P28) | `_paper_extractions/cluster_E_prefetching_telemetry.md` | 682 |
| `07_cluster_F_sync_tud_habich.md` | Cluster F Sync + TUD-Habich (P08, P29, P30, P31, P32, P33) | `_paper_extractions/cluster_F_sync_tud_habich.md` | 648 |
| `08_allokator_cluster_AC1_AC5.md` | 23 Allokatoren A01-A23 in 5 Clustern + 7 Achsen AA1-AA7 | `Allokator_Matrix.txt` (801) + REV7 §2 | 801 |

**Total:** 9 Konsolidierungs-Doks aus ~5.000 Z Quell-Inhalt.

---

## Memory-Direktive beachtet

Original-Quellen unter `../termine/20260508 Termin 7/` bleiben **VOLLSTAENDIG**
erhalten. Konsolidierte Master-Doks unter `docs/forschungslandkarte/`
referenzieren nur (Pfad+Zeile), kopieren nicht voll-Inhalt.

---

## Statistik

| Kategorie | Anzahl |
|---|---|
| SOTA-Paper P01-P33 | 33 |
| Allokator-Paper A01-A23 | 23 |
| **Total Paper** | **56** |
| SOTA-Cluster (A-F) | 6 |
| Allokator-Cluster (AC1-AC5) | 5 |
| SOTA-Cluster-Tieflektuere-LOC | 3.295 |
| Allokator-Matrix-LOC | 801 |
| Quellen-Gesamtkatalog-LOC | 732 |
| **Total Original-LOC** | **~5.000** |

---

## V31-Adapter-Implementations-Stand

**SOTA-Adapter (12):** P01, P02, P03, P04 (GPL-3 ⚠️), P05, P06 (no-LICENSE ⚠️), P07 (GPL-3 ⚠️), P10, P20, P25 (no-LICENSE ⚠️), P29 (LGPL ⚠️), P30 (no-LICENSE)
**Allokator-Adapter (10):** A01, A03, A04, A05, A06, A07, A08, A10, A11, A20
**Total V31-Adapter:** 22 (alle als Skelette mit COMDARE_HAVE_<X>=OFF default)

⚠️ = freigegeben durch Architekt-Direktive II 2026-05-14 (siehe NOTICE).

---

## Cluster-Statistik (SOTA)

| Cluster | Paper | Inhalt |
|---|---|---|
| A | 6 | Trie-Familie (P01, P02, P04, P05, P09, P10) |
| B | 6 | Hybrid + B+-Familie (P03, P06, P07, P11, P12, P13) |
| C | 6 | Layout-Theorie (P14, P15, P16, P17, P18, P19) |
| D | 4 | Prefetching 1 (P20, P21, P22, P23) |
| E | 5 | Prefetching 2 + Telemetry (P24, P25, P26, P27, P28) |
| F | 6 | Sync + TUD-Habich (P08, P29, P30, P31, P32, P33) |
| **Total** | **33** | (passt — exakt P01-P33 abgedeckt) |

---

## Cluster-Statistik (Allokator)

| Cluster | Paper | Inhalt |
|---|---|---|
| AC1 | 2 | Foundation (A20, A21) |
| AC2 | 3 | Modern Production (A04, A05, A06) |
| AC3 | 4 | NUMA + Hardware (A09, A14, A15, A16) |
| AC4 | 6 | Concurrent + Formal (A03, A07, A11, A13, A17, A22) |
| AC5 | 6 | Standard + Optimizing (A01, A08, A10, A18, A19, A23) |
| (Rang-extra) | 2 | Rang 2 Specialized (A12 CAMA) + nicht-eingegliederte (A02 Bonwick Slab) |
| **Total** | **23** | A01-A23 abgedeckt |

---

## Querverweise

- Master-Plan: `../MASTERPLAN_KONSOLIDIERUNG_TERMINE.md`
- Architektur: `../architektur/` (K-C, fertig)
- Glossar: `../glossar/` (K-D, fertig)
- Bausteine: `../bausteine/` (K-E, fertig)
- Termine-Konsolidiert: `../termine_konsolidiert/00_INDEX.md` (K-G, geplant)
- thesis Kapitel 02 (Stand der Technik) mit SOTA + Allokator-Tabellen: `../../thesis/chapters/02_stand_der_technik.tex`
- LICENSE-Audit: `../../Code/external/comdare-cache-engine/LICENSE_AUDIT_EXT.md`
- NOTICE Architekt-Direktive II: `../../Code/external/comdare-cache-engine/NOTICE`
