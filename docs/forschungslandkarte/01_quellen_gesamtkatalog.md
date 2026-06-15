# Quellen-Gesamtkatalog — Master-Konsolidierung

**Stand:** 2026-05-15 (K-F.2)
**Quelle:** `../termine/20260508 Termin 7/Quellen_Gesamtkatalog.txt` (732 Z, REV4 vom 2026-05-04)
**Erweitert um:** 23 Allokator-Quellen A01-A23 (REV7 §2 vom 2026-05-13)

---

## §1 Status-Uebersicht

**Wissenschaftliche Quellen total:** 33 SOTA + 23 Allokator = 56 Paper

| Kategorie | Anzahl | PDF lokal | Lizenz fuer V31-Adapter |
|---|---|---|---|
| SOTA P01-P33 | 33 | 31 (94%) | siehe LICENSE_AUDIT_EXT.md |
| Allokatoren A01-A23 | 23 | 10 lokal geklont | siehe LICENSE_AUDIT_EXT.md |

---

## §2 SOTA-Paper P01-P33 (Quellen-Katalog Teil A)

### A.1 Klassische cache-aware B-Baum-/Array-Familie (passive Cache-Awareness)

| P-ID | Autoren / Jahr / Venue | Titel | PDF lokal |
|---|---|---|---|
| **P11** | Rao & Ross (1999, VLDB) | Cache Conscious Indexing for Decision-Support in Main Memory (CSS-Tree) | ✓ |
| **P12** | Rao & Ross (2000, SIGMOD) | Making B+-Trees Cache Conscious in Main Memory (CSB+-Tree) | ✓ |
| **P15** | Graefe & Larson (2001) | B-Tree Indexes and CPU Caches | ✓ |
| **P13** | Hankins & Patel (2003) | Effect of Node Size on B+-Tree Performance | ✓ |
| **P14** | Samuel/Pedersen/Bonnet (2005) | Making CSB+-Trees Processor Conscious | ✓ |
| **P16** | Bender/Demaine/Farach-Colton (2002) | Tree Layout in Multilevel Memory | ✓ (Springer LNCS) |
| **P17** | Bender/Demaine/Farach-Colton (2005) | Cache-Oblivious B-Trees | ✓ |
| **P18** | Saikkonen & Soisalon-Soininen (2008, IFIP TCS) | Cache-sensitive Memory Layout for Binary Trees | ✓ |
| **P19** | Saikkonen & Soisalon-Soininen (2016, ComJ) | Cache-Sensitive Memory Layout for Dynamic Binary Trees | ✓ |
| **P20** | Mueller/Benson/Leis (2025, SIGMOD) | B-Trees Are Back | ✓ |

### A.2 Trie-basierte und Trie-Hybride Suchstrukturen

| P-ID | Autoren / Jahr / Venue | Titel | PDF lokal |
|---|---|---|---|
| **P03** | Mao/Kohler/Morris (2012, EuroSys) | Cache Craftiness for Fast Multicore Key-Value Storage (Masstree) | ✓ |
| **P01** | Leis/Kemper/Neumann (2013, ICDE) | The Adaptive Radix Tree (ART) | ✓ |
| **P08** | Leis/Scheibner/Kemper/Neumann (2016) | The ART of Practical Synchronization | ✓ |
| **P02** | Binna/Zangerle/Pichl/Specht/Leis (2018, SIGMOD) | HOT — Height Optimized Trie | ✓ |
| **P07** | Wu/Ni/Jiang (2019, EuroSys) | Wormhole | ✓ |
| **P05** | Fent/Jungmair/Kipf/Neumann (2020, ICDE) | START — Self-Tuning Adaptive Radix Tree | ✓ |
| **P06** | Schmeisser/Schuele/Leis/Neumann/Kemper (2022) | B²-Tree | ✓ |
| **P04** | Boffa/Ferragina/Tosoni/Vinciguerra (2024) | CoCo-trie | ✓ |
| **P09** | Jacobson (1989) — HABICH-Zusatz | LOUDS (Space-Efficient Static Trees) | ✓ |
| **P10** | Zhang/Lim/Leis/Andersen et al. (2018, SIGMOD) — HABICH-Zusatz | SuRF — Practical Range Query Filtering | ✓ |

### A.3 Habich-Dresden-Linie (TUD)

| P-ID | Autoren / Jahr / Venue | Titel | PDF lokal |
|---|---|---|---|
| **P31** | Ungethuem et al. (2017) | Overview of Hardware Optimizations for Database Engines | ✓ |
| **P33** | Berthold/Schmidt + PIs Lehner/Habich (2023, SPP2377 Kickoff) | VAMPIR Poster | ✓ (Endgueltig SPP2377) |
| **P32** | Schmidt/Kuehn/Krause/Teubner (2025, DIMES) | To Stride or Not to Stride | ✓ |

### B Cache-Engine / Aktives Cache-Management

| P-ID | Autoren / Jahr / Venue | Titel | PDF lokal |
|---|---|---|---|
| **P21** | Chen/Gibbons/Mowry (2001) | Improving Index Performance through Prefetching (PB-Trees) | ✓ |
| **P22** | Chen et al. (2002) | Fractal Prefetching B+-Trees | ✓ |
| **P23** | Khan (2010) | Dynamic Adaptation of Cache Prefetching | ✓ |
| **P24** | Naderan-Tahan/Sarbazi-Azad (2016) | Useless Prefetch Study | ✓ |
| **P25** | Mahling/Weisgut/Rabl (2025, DaMoN) | Fetch Me If You Can | ✓ |
| **P26** | Q. Zhang et al. (2024, FGCS) | A prefetching indexing scheme | ✓ |
| **P27** | T. Zhang et al. (2025, ASPLOS) | Hierarchical Prefetching | ✓ + hp-soft.zip Mail-Antwort |
| **P28** | Kuehn et al. (2023, DAMON) | Towards Data-Based Cache Optimization | ✓ + Kuehn-Mailverlauf v7 Glossar |
| **P29** | McKenney et al. (2001, OLS) | Read-Copy-Update | ✓ |
| **P30** | Michael (2004, IEEE TPDS 15(6)) | Hazard Pointers (REV4 ENTFERNT durch F12-K, RCU bevorzugt) | ✓ |

---

## §3 Allokator-Paper A01-A23 (REV7 §2 vom 2026-05-13)

Detail siehe `../bausteine/02_allokator_matrix.md`.

### Rang 1 — Foundational + Production-Grade (10)

| ID | Paper / Allokator | Autoren / Jahr / Venue | V31 Status |
|---|---|---|---|
| **A01** | Hoard | Berger/McKinley/Blumofe/Wilson (2000, ASPLOS) | ✅ Adapter |
| **A02** | Slab Allocator | Bonwick (1994, USENIX Summer) | (nicht geklont) |
| **A03** | Scalable Lock-Free Dynamic Memory Allocation | Maged M. Michael (2004, PLDI) | ✅ Adapter (Re-Impl scotts/michael) |
| **A04** | Mimalloc | Leijen/Zorn/de Moura (2019, MSR-TR-2019-18, APLAS 2019) | ✅ Adapter |
| **A05** | jemalloc | Jason Evans (2006, BSDCan) | ✅ Adapter |
| **A06** | TCMalloc | Ghemawat/Menage (Google 2009; reanalysiert 2024 Zhou ASPLOS) | ✅ Adapter |
| **A07** | snmalloc | Lipp/Bond/Parkinson (2019, ISMM) | ✅ Adapter |
| **A08** | scalloc | Aigner/Kirsch/Lippautz/Sokolova (2015, OOPSLA) | ✅ Adapter |
| **A09** | NUMAlloc | Liu/Berger (2023, ISMM) | (nicht geklont) |
| **A10** | rpmalloc | Mattias Jansson (2017+, kein formales Paper) | ✅ Adapter |

### Rang 2 — Modern + Specialized (3+)

| ID | Paper / Allokator | Autoren / Jahr / Venue | V31 Status |
|---|---|---|---|
| **A11** | LRMalloc | Leite/Rocha (2018, VECPAR) | ✅ Adapter |
| **A12** | CAMA | Herter/Marwedel/Falk (2011, RTAS) | (Forschungsprototyp) |
| **A13** | StarMalloc | Bourgeat/Erbsen et al. (2024, arXiv 2403.09435) | (komplexer F* Build) |

### Rang 3 — Kernel + Standard-Library + Classic (10+)

| ID | Paper / Allokator | Autoren / Jahr / Venue | V31 Status |
|---|---|---|---|
| **A14** | tcmalloc Warehouse-Scale | Zhou et al. (2024, ASPLOS) | (in A06) |
| **A15** | HMalloc | (IEEE 2020+) | (Code unklar) |
| **A16** | PIM-malloc | VIA-Research, UPMEM-Hardware | (UPMEM-only) |
| **A17** | Crystalline | Penn State, Ruslan Nikolaev | (nicht geklont) |
| **A18** | Exgen-Malloc | UT Austin SysML | (nicht geklont) |
| **A19** | Buddy | Linux mm/page_alloc.c als Reference | (Eigene Re-Impl Skelett) |
| **A20** | dlmalloc | Doug Lea (1987-) | ✅ Adapter |
| **A21** | ptmalloc2 | glibc 2.26+ (LGPL) | (System default) |
| **A22** | N3916 PMR | C++17 Standard-Library | (Compiler-included) |
| **A23** | Vmem+Magazines | illumos kmem.c / FreeBSD UMA | (nicht geklont) |

**V31 implementiert: 10 Adapter** (A01, A03, A04, A05, A06, A07, A08, A10, A11, A20).

---

## §4 6 Cluster-Zuordnung (siehe Cluster-Doks K-F.3-K-F.8)

| Cluster | Inhalt | Anzahl | Doku |
|---|---|---|---|
| A | Trie-Familie | 6 (P01, P02, P04, P05, P09, P10) | `02_cluster_A_trie.md` |
| B | Hybrid + B+-Familie | 6 (P03, P06, P07, P11, P12, P13) | `03_cluster_B_hybrid_bplus.md` |
| C | Layout-Theorie | 6 (P14, P15, P16, P17, P18, P19) | `04_cluster_C_layout_theorie.md` |
| D | Prefetching 1 | 4 (P20, P21, P22, P23) | `05_cluster_D_prefetching_1.md` |
| E | Prefetching 2 + Telemetry | 5 (P24, P25, P26, P27, P28) | `06_cluster_E_prefetching_telemetry.md` |
| F | Sync + TUD-Habich | 6 (P08, P29, P30, P31, P32, P33) | `07_cluster_F_sync_tud_habich.md` |

**Total: 33 Paper** (passt nicht ganz: P20 in D statt B/C, weil "B-Trees Are Back" mit Adaptive Layout neu).

---

## §5 5 Allokator-Cluster (AC1-AC5)

| Cluster | Name | A-IDs | Anzahl |
|---|---|---|---|
| AC1 | Foundation Allokatoren | A20 dlmalloc, A21 ptmalloc2 | 2 |
| AC2 | Modern Production | A04 mimalloc, A05 jemalloc, A06 tcmalloc | 3 |
| AC3 | NUMA + Hardware | A09 NUMAlloc, A14 (in A06), A15 HMalloc, A16 PIM-malloc | 4 |
| AC4 | Concurrent + Formal | A03 Michael, A07 snmalloc, A11 LRMalloc, A13 StarMalloc, A17 Crystalline, A22 N3916 PMR | 6 |
| AC5 | Standard + Optimizing | A01 Hoard, A08 scalloc, A10 rpmalloc, A18 Exgen, A19 Buddy, A23 Vmem+Magazines | 6 |

**Detail:** `08_allokator_cluster_AC1_AC5.md` (K-F.9)

---

## §6 Erstquellen pro Paper (T1-T6 + E + Habich)

| T-Nr | Termin | Anzahl Paper, die hier eingefuehrt wurden |
|---|---|---|
| E | Vor-Termin Expose-Phase | 5 (P03, P11, P12, P15) |
| T1 | Termin 1 (2026-03-30) | mehrere (siehe Original) |
| T2 | Termin 2 (2026-03-30, Folge) | mehrere |
| T3 | Termin 3 (2026-04-09) | mehrere |
| T4 | Termin 4 (2026-04-12) | viele (Cache-Engine Forschungslandkarte) |
| T5 | Termin 5 (2026-04-12 Folge) | viele |
| T6 | Termin 6 (2026-04-16) | wenige (Hardware-Plattform) |
| Habich | Habich-Zusatz | 5 (P09 LOUDS, P10 SuRF, P29 RCU, P31 Ungethuem, P33 VAMPIR) |

---

## §7 Korrekturen REV4 vom 2026-05-04 (5 Autoren-Fixes)

| Korrektur | Vorher (falsch) | Nachher (korrekt) |
|---|---|---|
| A1.10 (P20) | Leis/Haubenschild/Kemper/Neumann | Mueller/Benson/Leis |
| A2.3 (P08) | Leis/Haubenschild/Kemper/Neumann | Leis/Scheibner/Kemper/Neumann |
| A2.5 (P07) | Wu/Ni/Jiang (Jin Jiang) | Wu/Ni/Jiang (Song Jiang) |
| A2.7 (P06) | Schmeisser/Schuele/Leis/Neumann | Schmeisser/Schuele/Leis/Neumann/Kemper (5 Autoren) |
| A2.8 (P04) | Belazzougui (T1 Tippfehler) | Boffa/Ferragina/Tosoni/Vinciguerra |

---

## §8 Querverweise

- Original-Quelle (UNVERAENDERT): `../termine/20260508 Termin 7/Quellen_Gesamtkatalog.txt`
- SLUB-Download-Liste: `../termine/20260508 Termin 7/SLUB_Download_Liste.md`
- Diskrepanzbericht Downloads: `../termine/20260508 Termin 7/Diskrepanzbericht_Downloads.txt`
- 6 SOTA-Cluster: `02_cluster_A_trie.md` bis `07_cluster_F_sync_tud_habich.md` (K-F.3-K-F.8)
- Allokator-Cluster: `08_allokator_cluster_AC1_AC5.md` (K-F.9)
- Allokator-Matrix: `../bausteine/02_allokator_matrix.md` (K-E.3)
- Cross-Paper-Konzeptmatrix: `../bausteine/03_cross_paper_konzeptmatrix.md` (K-E.4)
- Eigenschaften Suchalgorithmen: `../bausteine/06_eigenschaften_suchalgorithmen.md` (K-E.7)
- LICENSE-Audit fuer V31-Adapter: `../../Code/external/comdare-cache-engine/LICENSE_AUDIT_EXT.md`
- NOTICE Architekt-Direktive II: `../../Code/external/comdare-cache-engine/NOTICE`
- PDFs: `../../Forschungsarbeiten/`
