# Cluster A — Trie-Familie

**Stand:** 2026-05-15 (K-F.3)
**Quelle:** `../termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions/cluster_A_trie.md` (503 Z)
**Inhalt:** 6 Trie-Familie-Paper P01, P02, P04, P05, P09, P10

---

## §1 Cluster-Mitglieder

| P-ID | Paper | Autoren / Jahr / Venue | V31-Adapter |
|---|---|---|---|
| **P01** | The Adaptive Radix Tree (ART) | Leis/Kemper/Neumann (2013, ICDE) | `comdare::adapter::p01_art::UnodbDbAdapter` ✅ Apache-2.0 |
| **P02** | HOT — Height Optimized Trie | Binna/Zangerle/Pichl/Specht/Leis (2018, SIGMOD) | `comdare::adapter::p02_hot::HotAdapter` ✅ ISC |
| **P04** | CoCo-trie | Boffa/Ferragina/Tosoni/Vinciguerra (2024) | `comdare::adapter::p04_coco_trie::CocoTrieAdapter` ✅ GPL-3 ⚠️ |
| **P05** | START — Self-Tuning Adaptive Radix Tree | Fent/Jungmair/Kipf/Neumann (2020, ICDE) | `comdare::adapter::p05_start::StartAdapter` ✅ MIT |
| **P09** | LOUDS — Space-Efficient Static Trees | Jacobson (1989, FOCS) — HABICH-Zusatz | LEGACY_REIMPL |
| **P10** | SuRF — Practical Range Query Filtering | Zhang/Lim/Leis/Andersen et al. (2018, SIGMOD) — HABICH-Zusatz | `comdare::adapter::p10_surf::SurfAdapter` ✅ Apache-2.0 |

---

## §2 Cluster-Kernkonzepte

Aus 33-Paper-Tieflektuere Phase 3.B (Cluster A — Trie-Familie, 503 Z):

### 2.1 Adaptive Knotentypen (Node-Family-Variation)

| Paper | Anzahl Knotentypen | Charakteristik |
|---|---|---|
| P01 ART | 4 (Node4, Node16, Node48, Node256) | Adaptive Groessen je nach Fanout |
| P02 HOT | 9 (Single-Mask + Multi-Mask × 8/16/32 bit) | Compound Node mit max k=32 |
| P05 START | 7 (4 Standard + 3 multilevel) | Multibyte + Rewired64K + Rewired16M + MultiNode4 |
| P04 CoCo | viele (Pool of succinct encodings + macro-node levels) | Pool aus EF+PA+BV+DE-Encodings |
| P09 LOUDS | 1 (succinct) | Level-Ordered Unary Degree Sequence |
| P10 SuRF | 2 (LOUDS-Dense + LOUDS-Sparse Hybrid) | LOUDS-DS Hybrid |

### 2.2 Praefix-Kompression (Path Compression)

| Paper | Verfahren |
|---|---|
| P01 ART | Path Compression + Lazy Expansion |
| P02 HOT | Discriminative Bits (Patricia-Bits) |
| P05 START | Rewiring (multi-byte transition) |
| P04 CoCo | Macro-Node (kollabierter Subtrie als 1 Knoten) |

### 2.3 Range / Prefix Operations

| Paper | Range-Filter | Prefix Enumeration |
|---|---|---|
| P10 SuRF | ✓ (LOUDS-DS Hybrid mit Range-Filter) | ✓ |
| P01 ART | (Prefix Enumeration) | ✓ |
| P02 HOT | (limitiert) | (limitiert) |

### 2.4 Hardware-Optimierungen (Cluster-A-spezifisch)

| Paper | SIMD | Cache-Awareness |
|---|---|---|
| P02 HOT | BMI2/AVX2 | Compound Node (k=32 fuer 32-byte Cacheline) |
| P05 START | AVX2 | Multibyte fuer Speicher-Reduktion |
| P01 ART | (limitiert) | Adaptive Node Groessen (Cache-Footprint-Awareness) |
| P10 SuRF | (limitiert) | Succinct fuer Cache-Footprint |

---

## §3 Vollangaben (siehe Original)

Detail-Konzept-Extraktionen pro Paper (BED, BEL, ABG, BEZ) in:
`../termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions/cluster_A_trie.md`

Sektionen im Original:
- §1 P01 ART Tieflektuere
- §2 P02 HOT Tieflektuere
- §3 P04 CoCo Tieflektuere
- §4 P05 START Tieflektuere
- §5 P09 LOUDS Tieflektuere
- §6 P10 SuRF Tieflektuere
- §7 Cross-Paper-Synthese Cluster A

---

## §4 Bausteine-Matrix-Mapping (Achse 1+2+3)

Cluster-A-Paper liefern Bausteine fuer Achsen 1 (Page), 2 (Node), 3 (Traversal):

| Bausteine-ID | Achse | Paper |
|---|---|---|
| `PAGE_DENSEBYTE_ART256`, `PAGE_SPARSE_NODE4_ART`, `PAGE_NODE16_ART`, `PAGE_NODE48_ART` | 1 | P01 |
| `PAGE_COMPOUND_HOT` | 1 | P02 |
| `PAGE_MULTIBYTE_START` | 1 | P05 |
| `PAGE_MACRO_COCO` | 1 | P04 |
| `PAGE_LOUDS_DENSE_SURF`, `PAGE_LOUDS_SPARSE_SURF` | 1 | P10 |
| `PAGE_LOUDS_JACOBSON` | 1 | P09 |
| `NODE_NODE4`, `NODE_NODE16`, `NODE_NODE48`, `NODE_NODE256` | 2 | P01 |
| `NODE_HOT_COMPOUND_K32`, `NODE_HOT_BINODE` | 2 | P02 |
| `NODE_MACRONODE_COCO`, `NODE_MULTIBYTE_START` | 2 | P04, P05 |
| `TRAVERSAL_BYTEBYBYTE` | 3 | P01 |
| `TRAVERSAL_DISCRIMINATIVE_BITS` | 3 | P02 |
| `TRAVERSAL_MACRO_NODE`, `TRAVERSAL_MULTIBYTE_SPAN` | 3 | P04, P05 |
| `TRAVERSAL_RANK_SELECT` | 3 | P09, P10 |
| `TRAVERSAL_LOWER_BOUND` | 3 | P10 |

Detail: `../bausteine/01_bausteine_matrix.md` §3+§4+§5.

---

## §5 Querverweise

- Original-Quelle (UNVERAENDERT): `../termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions/cluster_A_trie.md`
- Quellen-Gesamtkatalog: `01_quellen_gesamtkatalog.md` §2 A.2 (K-F.2)
- Bausteine-Matrix: `../bausteine/01_bausteine_matrix.md`
- Cross-Paper-Konzeptmatrix: `../bausteine/03_cross_paper_konzeptmatrix.md`
- Eigenschaften pro Algorithmus: `../bausteine/06_eigenschaften_suchalgorithmen.md` §4 Kategorie B
- Konzepte Saeule A: `../architektur/03_konzepte_saeule_a.md`
- Begriffsglossar v7 Master: `../glossar/01_begriffsglossar_v7_master.md`
- LICENSE-Audit V31-Adapter: `../../Code/external/comdare-cache-engine/LICENSE_AUDIT_EXT.md`
