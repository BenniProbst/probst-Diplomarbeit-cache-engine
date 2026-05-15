# Cluster B — Hybrid + B+-Familie

**Stand:** 2026-05-15 (K-F.4)
**Quelle:** `../termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions/cluster_B_hybrid_bplus.md` (426 Z)
**Inhalt:** 6 Hybrid + B+-Familie-Paper P03, P06, P07, P11, P12, P13

---

## §1 Cluster-Mitglieder

| P-ID | Paper | Autoren / Jahr / Venue | V31-Adapter |
|---|---|---|---|
| **P03** | Masstree — Cache Craftiness for Fast Multicore KV Storage | Mao/Kohler/Morris (2012, EuroSys) | `comdare::adapter::p03_masstree::MasstreeAdapter` ✅ MIT (REV4-Klarstellung: NICHT GPL-2) |
| **P06** | B²-Tree | Schmeisser/Schuele/Leis/Neumann/Kemper (2022) | `comdare::adapter::p06_b2tree::B2TreeAdapter` ✅ no-LICENSE ⚠️ (TUM-DB-Group privat) |
| **P07** | Wormhole | Wu/Ni/Jiang (2019, EuroSys) | `comdare::adapter::p07_wormhole::WormholeAdapter` ✅ GPL-3 ⚠️ |
| **P11** | Cache Conscious Indexing (CSS-Tree) | Rao/Ross (1999, VLDB) | LEGACY_REIMPL |
| **P12** | Making B+-Trees Cache Conscious (CSB+-Tree) | Rao/Ross (2000, SIGMOD) | LEGACY_REIMPL |
| **P13** | Effect of Node Size on B+-Tree Performance | Hankins/Patel (2003) | LEGACY_REIMPL |

---

## §2 Cluster-Kernkonzepte

### 2.1 Hybrid-Strukturen

| Paper | Hybrid-Konstruktion |
|---|---|
| P03 Masstree | Trie-of-B+-Trees (8-Byte-Slices als Trie-Layer, B+-Inner-Knoten als Layer-Inhalt) |
| P07 Wormhole | Trie + Hash + B+ Hybrid (Anchor-Keys via Hash-Lookup zu Trie-Segmenten mit lokalen B+-Strukturen) |
| P06 B²-Tree | Outer-Layer B+-Tree + Inner-Layer Decision/Span-Nodes (embedded byte-decision tree per Page) |

### 2.2 Cache-Awareness via Page-Layout

| Paper | Page-Groesse / Layout |
|---|---|
| P11 CSS-Tree | 1 Knoten = 1 Cache Line (64 Bytes), pointer-FREIE Directory ueber sortiertem Array |
| P12 CSB+-Tree | siblings contiguous, parent stores only one pointer to first child (Node Group) |
| P13 Hankins | "node sizes up to 16 cache lines are best for lookup performance" — widerlegt P11/P12! |
| P03 Masstree | 256-Byte-B+-Nodes (4 Cachelines) |
| P06 B²-Tree | B+-Page mit eingebettetem Decision/Span-Subtree |

### 2.3 Hybrid-Aufloesung in atomare Commands (REV5 K3.4)

P03, P06, P07 sind "Hybrid"-Algorithmen → werden in atomare Strategy-Commands zerlegt:

| Hybrid | Atomare Commands |
|---|---|
| P03 Masstree | Layer-Slice-Cmd + B+-Inner-Cmd + B+-Border-Cmd |
| P07 Wormhole | Anchor-Hash-Cmd + Trie-Segment-Cmd + B+-Local-Cmd |
| P06 B²-Tree | Decision-Cmd + Span-Cmd + Embedded-Tree-Cmd |

(Detail: `../architektur/09_taxonomien.md` §3.2 + `../architektur/03_konzepte_saeule_a.md` §4)

---

## §3 Vollangaben (siehe Original)

Detail-Konzept-Extraktionen pro Paper in:
`../termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions/cluster_B_hybrid_bplus.md`

---

## §4 Bausteine-Matrix-Mapping (Achse 1+2+3, Querschnitt)

| Bausteine-ID | Achse | Paper |
|---|---|---|
| `PAGE_BPLUS_MASSTREE`, `NODE_INTERNAL_MASSTREE`, `NODE_BORDER_MASSTREE`, `TRAVERSAL_LAYER_SLICE` | 1+2+3 | P03 |
| `PAGE_METATRIEHT_WORMHOLE`, `TRAVERSAL_HASH_ANCHOR` | 1+3 | P07 |
| `PAGE_DECISION_B2TREE`, `PAGE_SPAN_B2TREE`, `NODE_DECISION_B2TREE`, `NODE_SPAN_B2TREE`, `TRAVERSAL_EMBEDDED_DEC_TREE`, `MEMORY_EMBEDDED_TREE` | 1+2+3+5 | P06 |
| `PAGE_CSS_NODE`, `MEMORY_POINTER_FREE_CONTIG`, `TRAVERSAL_POINTER_ARITHMETIC` | 1+5+3 | P11 |
| `PAGE_CSB_NODEGROUP`, `MEMORY_SIBLING_CLUSTER`, `TRAVERSAL_OFFSET` | 1+5+3 | P12 |
| `PAGE_WIDER_HANKINS`, `NODE_WIDER_BPLUS_HANKINS` | 1+2 | P13 |

Plus **P06 bart-master Cross-Algorithm-Vergleichsbasis** (received privately 2026-05-08): HAT-Trie + PB-Tree-Static-Varianten:
- `PAGE_BART_HYBRID_P06`, `PAGE_HATTRIE_P06`, `PAGE_PBTREESTATIC_P06`, `PAGE_PBTREESTATIC_OPT_P06`, `PAGE_PBTREESTATIC_TRIE_P06`, `PAGE_PBTREESTATIC_ART_P06`

---

## §5 Querverweise

- Original-Quelle (UNVERAENDERT): `../termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions/cluster_B_hybrid_bplus.md`
- Cluster A (Trie): `02_cluster_A_trie.md`
- Cluster C (Layout): `04_cluster_C_layout_theorie.md`
- Quellen-Gesamtkatalog: `01_quellen_gesamtkatalog.md` §2 A.1+A.2
- Bausteine-Matrix: `../bausteine/01_bausteine_matrix.md` §3+§4+§5+§7
- Cross-Paper-Konzeptmatrix: `../bausteine/03_cross_paper_konzeptmatrix.md`
- LICENSE-Audit: `../../Code/external/comdare-cache-engine/LICENSE_AUDIT_EXT.md`
- NOTICE Architekt-Direktive II: `../../Code/external/comdare-cache-engine/NOTICE`
