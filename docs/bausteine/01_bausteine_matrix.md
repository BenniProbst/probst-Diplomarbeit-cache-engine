# Bausteine-Matrix — Master (Konsolidierung)

**Stand:** 2026-05-15 (K-E.2)
**Quelle:** `../termine/20260508 Termin 7/Bausteine_Matrix.txt` (964 Zeilen, REV 1 vom 2026-05-08)
**Erweitert um:** Adapter-Status-Spalte (V31 Stand 2026-05-15)

---

## §1 Zweck (Originaltext)

> "Vollstaendige Aufstellung aller Algorithmus-Bausteine pro konzeptioneller
> Achse aus den 33 Papern (P01-P33) + PRT-ART. Jeder Baustein ist:
> - Eine eigene Klassen-Implementation
> - Mit einem definierten Concept-Interface (C++23 requires)
> - Pro Original-Algorithmus mit dessen Original-Compiler kompiliert (F-EXTRA-1)
> - Austauschbar gegen jeden anderen Baustein derselben Achse (F15)"

**85 Bausteine total, ueber 11 Achsen verteilt.**

---

## §2 11 Achsen (Bausteine-Permutations-Dimensionen)

| Achse | Name | Bank (Flag_System) | Anzahl Bausteine | Quelle (Z) |
|---|---|---|---|---|
| 1 | PAGE-TYPE | PageBank | 26 | Bausteine_Matrix:51 |
| 2 | NODE-TYPE | NodeBank | 13 | Bausteine_Matrix:267 |
| 3 | TRAVERSAL | TraversalBank | 14 | Bausteine_Matrix:335 |
| 4 | VALUEHANDLE | ValueHandleBank | 5 | Bausteine_Matrix:411 |
| 5 | MEMORY-LAYOUT | MemoryLayoutBank | 8 | Bausteine_Matrix:436 |
| 6 | ALLOCATOR | AllocatorBank | 7 (+ 23 Allokator-Paper, siehe `02_allokator_matrix.md`) | Bausteine_Matrix:468 |
| 7 | PREFETCH | PrefetchBank | 6 | Bausteine_Matrix:492 |
| 8 | CONCURRENCY | ConcurrencyBank | (siehe Original) | Bausteine_Matrix:516 |
| 9 | ISA | IsaBank | (siehe Flag_System.txt Bank 9) | Bausteine_Matrix:542 |
| 10 | MEASUREMENT | (Mess-Kategorie x Algo-Detail Matrix, F1) | (siehe Original) | Bausteine_Matrix:551 |
| 11 | TELEMETRY-COLLECTION-STRATEGY | (NEU 2026-05-09 Kuehn) | 6 | Bausteine_Matrix:584 |

---

## §3 Achse 1 — PAGE-TYPE (26 Bausteine)

| ID | Quelle | Adapter-Status (V31) | Quelle (Z) |
|---|---|---|---|
| `PAGE_DENSEBYTE_ART256` | P01 ART (Leis 2013) | Skelett (P01-ART/p01_art_adapter.hpp) | 54 |
| `PAGE_SPARSE_NODE4_ART` | P01 ART | Skelett | 62 |
| `PAGE_NODE16_ART / PAGE_NODE48_ART` | P01 ART | Skelett | 69 |
| `PAGE_COMPOUND_HOT` | P02 HOT (Binna 2018) | Skelett (P02-HOT/p02_hot_adapter.hpp) | 75 |
| `PAGE_MULTIBYTE_START` | P05 START (Fent 2020) | Skelett | 83 |
| `PAGE_MACRO_COCO` | P04 CoCo-trie (Boffa 2024) | Skelett (GPL-3 ⚠️) | 90 |
| `PAGE_METATRIEHT_WORMHOLE` | P07 Wormhole (Wu 2019) | Skelett (GPL-3 ⚠️) | 97 |
| `PAGE_LOUDS_DENSE_SURF / PAGE_LOUDS_SPARSE_SURF` | P10 SuRF (Zhang 2018) | Skelett | 104 |
| `PAGE_LOUDS_JACOBSON` | P09 Jacobson 1989 (LOUDS) | LEGACY_REIMPL | 111 |
| `PAGE_BPLUS_MASSTREE` | P03 Masstree (Mao 2012) | Skelett | 118 |
| `PAGE_DECISION_B2TREE / PAGE_SPAN_B2TREE` | P06 B²-Tree (Schmeisser 2022) | Skelett (no-LICENSE ⚠️) | 126 |
| `PAGE_BART_HYBRID_P06` | P06 bart-master (Cross-Algorithm-Vergleichsbasis) | (im bart-master Sub-Repo) | 139 |
| `PAGE_HATTRIE_P06` | P06 HAT-Trie (in bart-master) | (im bart-master) | 149 |
| `PAGE_PBTREESTATIC_P06` | P06 PB-Tree-Static (in bart-master) | (im bart-master) | 159 |
| `PAGE_PBTREESTATIC_OPT_P06` | P06 PB-Tree-Static-Opt | (im bart-master) | 169 |
| `PAGE_PBTREESTATIC_TRIE_P06` | P06 PB-Tree-Static-Trie | (im bart-master) | 179 |
| `PAGE_PBTREESTATIC_ART_P06` | P06 PB-Tree-Static-ART | (im bart-master) | 189 |
| `PAGE_CSS_NODE` | P11 CSS-tree (Rao/Ross 1999) | LEGACY_REIMPL | 200 |
| `PAGE_CSB_NODEGROUP` | P12 CSB+-tree (Rao/Ross 2000) | LEGACY_REIMPL | 207 |
| `PAGE_WIDER_HANKINS` | P13 Hankins 2003 | LEGACY_REIMPL | 214 |
| `PAGE_CONFIGTABLE_SAMUEL` | P14 Samuel 2005 | LEGACY_REIMPL | 221 |
| `PAGE_ADAPTIVE_BTREESAREBACK` | P20 LeanStore (Mueller 2025) | Skelett (P20-BTreesAreBack) | 228 |
| `PAGE_PREFETCH_CHEN / PAGE_FRACTAL_CHEN` | P21+P22 Chen 2001/2002 | LEGACY_REIMPL | 235 |
| `PAGE_LSM_TREE / PAGE_COLA / PAGE_SKIPLIST / PAGE_TTREE` | (Eigene Variantenfamilie) | (Skelett, ext-Repos noch nicht) | 242 |
| `PAGE_TST / PAGE_JUDY / PAGE_VAN_EMDE_BOAS` | (Eigene Variantenfamilie) | (Skelett) | 249 |
| `PAGE_PRTART_DENSEBYTE / PAGE_PRTART_EXTENDEDDENSE / ...` | PRT-ART eigen | (im prt-art Repo) | 256 |

---

## §4 Achse 2 — NODE-TYPE (13 Bausteine)

| ID | Quelle | Quelle (Z) |
|---|---|---|
| `NODE_NODE4 / NODE_NODE16 / NODE_NODE48 / NODE_NODE256` | P01 ART | 270 |
| `NODE_HOT_COMPOUND_K32 / NODE_HOT_BINODE` | P02 HOT | 276 |
| `NODE_INTERNAL_MASSTREE / NODE_BORDER_MASSTREE` | P03 Masstree | 282 |
| `NODE_MACRONODE_COCO` | P04 CoCo | 288 |
| `NODE_MULTIBYTE_START` | P05 START | 293 |
| `NODE_DECISION_B2TREE / NODE_SPAN_B2TREE` | P06 B²-tree | 298 |
| `NODE_HATTRIE_HASHBUCKET_P06` | HAT-Trie Hash-Bucket-Knoten | 303 |
| `NODE_PBTREE_STATIC_NODE_P06` | PB-Tree-Static Knoten | 310 |
| `NODE_BART_HYBRID_P06` | BART-Hybrid Knoten | 317 |
| `NODE_CSS_NODE / NODE_CSB_NODEGROUP / NODE_WIDER_BPLUS_HANKINS` | P11/P12/P13 | 325 |
| `NODE_PRTART_*` | PRT-ART eigen | 330 |

---

## §5 Achse 3 — TRAVERSAL (14 Bausteine)

| ID | Quelle | Quelle (Z) |
|---|---|---|
| `TRAVERSAL_BYTEBYBYTE` | P01 ART | 338 |
| `TRAVERSAL_DISCRIMINATIVE_BITS` | P02 HOT | 343 |
| `TRAVERSAL_LAYER_SLICE` | P03 Masstree | 348 |
| `TRAVERSAL_MACRO_NODE` | P04 CoCo | 352 |
| `TRAVERSAL_MULTIBYTE_SPAN` | P05 START | 356 |
| `TRAVERSAL_EMBEDDED_DEC_TREE` | P06 B²-tree | 359 |
| `TRAVERSAL_HATTRIE_HASH_THEN_TRIE_P06` | HAT-Trie | 363 |
| `TRAVERSAL_PBTREE_STATIC_PREFETCH_P06` | PB-Tree-Static | 369 |
| `TRAVERSAL_BART_HYBRID_DISPATCH_P06` | BART-Hybrid | 375 |
| `TRAVERSAL_HASH_ANCHOR` | P07 Wormhole | 383 |
| `TRAVERSAL_RANK_SELECT` | P09/P10 LOUDS/SuRF | 386 |
| `TRAVERSAL_LOWER_BOUND` | P10 SuRF | 390 |
| `TRAVERSAL_POINTER_ARITHMETIC` | P11 CSS | 393 |
| `TRAVERSAL_OFFSET` | P12 CSB+ | 396 |
| `TRAVERSAL_PREFETCH_AHEAD` | P21 Chen | 399 |
| `TRAVERSAL_ADAPTIVE_PREFETCH_DIST` | P23 Khan | 403 |
| `TRAVERSAL_PRTART_HOT_PATH / TRAVERSAL_PRTART_PREFETCH_AWARE` | PRT-ART eigen | 407 |

---

## §6 Achse 4 — VALUEHANDLE (5 Bausteine)

| ID | Quelle (Z) |
|---|---|
| `VALUEHANDLE_INLINE` | 414 |
| `VALUEHANDLE_POINTER` | 418 |
| `VALUEHANDLE_REDIRECT_TO_NODE` | 422 |
| `VALUEHANDLE_REDIRECT_TO_PAGE` | 426 |
| `VALUEHANDLE_DYNAMIC` | 430 |

---

## §7 Achse 5 — MEMORY-LAYOUT (8 Bausteine)

| ID | Beschreibung | Quelle (Z) |
|---|---|---|
| `MEMORY_CACHELINE_ALIGNED` | default | 439 |
| `MEMORY_HUGEPAGE_2MB_ALIGNED` | P32-Lehre | 443 |
| `MEMORY_HUGEPAGE_1GB_ALIGNED` | (Plattform) | 447 |
| `MEMORY_POINTER_FREE_CONTIG` | P11 CSS | 450 |
| `MEMORY_SIBLING_CLUSTER` | P12 CSB+ | 454 |
| `MEMORY_INLINE_SLOT` | (variant) | 457 |
| `MEMORY_METADATA_HEADER` | (PRT-ART) | 460 |
| `MEMORY_EMBEDDED_TREE` | P06 B²-tree | 464 |

---

## §8 Achse 6 — ALLOCATOR (7 Bausteine)

| ID | Beschreibung | Quelle (Z) |
|---|---|---|
| `ALLOCATOR_POOL_PER_PAGETYPE` | (PRT-ART) | 471 |
| `ALLOCATOR_ARENA_PER_SUBTREE` | (PRT-ART) | 474 |
| `ALLOCATOR_SLAB` | (klassisch) | 477 |
| `ALLOCATOR_HBM` | P32/P33-Plattform | 480 |
| `ALLOCATOR_DEFAULT_MALLOC` | Baseline | 484 |
| `ALLOCATOR_TCMALLOC / ALLOCATOR_MIMALLOC / ALLOCATOR_SNMALLOC` | (Production) | 487 |

**Erweiterung:** 23 Allokator-Paper (A01-A23) in 5 Clustern in `02_allokator_matrix.md` (K-E.3).

---

## §9 Achse 7 — PREFETCH (6 Bausteine)

| ID | Quelle |
|---|---|
| `PREFETCH_NONE` | Baseline |
| `PREFETCH_SOFTWARE_FIXED` | P21 Chen |
| `PREFETCH_ADAPTIVE_DISTANCE` | P23 Khan |
| `PREFETCH_HIERARCHICAL_BUNDLE` | P27 Zhang ASPLOS |
| `PREFETCH_FILL_BUFFER_AWARE` | P25 Mahling |
| `PREFETCH_HOT_PATH` | P26 Zhang FGCS |

---

## §10 Achse 8 — CONCURRENCY

Siehe Original `Bausteine_Matrix.txt:516-547` und ergaenzende Sektion `651-...`
"CACHE-KOHAERENZ-COST" (NEU 2026-05-09).

---

## §11 Achse 9 — ISA

Siehe `Flag_System.txt` Bank 9 + `06_eigenschaften_suchalgorithmen.md` (K-E.7).

---

## §12 Achse 10 — MEASUREMENT (Mess-Kategorie × Algo-Detail Matrix, F1)

Komplette Mess-Kategorien siehe `Bausteine_Matrix.txt:551-583`.

---

## §13 Achse 11 — TELEMETRY-COLLECTION-STRATEGY (NEU 2026-05-09, Kuehn-Erkenntnisse)

| ID | Quelle (Z) | Bedeutung |
|---|---|---|
| `TELEMETRY_PER_NODE_COUNTER` | 597 | Klassisch (Kuehn P28 publiziert) — Cache-Coherence-Anti-Pattern auf Multi-Core |
| `TELEMETRY_LEAFONLY_COUNTER` | 610 | Counter nur in Blatt-Knoten (Kuehn NEU) |
| `TELEMETRY_LEAFONLY_SAMPLED_COUNTER` | 619 | Sampling-Variante (jeder N-te Zugriff zaehlt) |
| `TELEMETRY_RETROACTIVE_AGGREGATION` | 627 | Wurzel-Up-Traversal vor Reordering |
| `TELEMETRY_PATH_READ_COUNTER` | 636 | Pfad-basiert (P26 Zhang FGCS) |
| `TELEMETRY_PROBABILITY_HINTS_HEADER` | 642 | Probability-Hints im Header (P16/P17 Bender) |

---

## §14 V31-Adapter-Mapping zur Bausteine-Matrix

V31 hat 22 Adapter implementiert (Skelette, COMDARE_HAVE_<X>=OFF default). Die Adapter sind eine Brueck zwischen Original-Repo (`ext/`) und der Bausteine-Matrix:

| V31-Adapter | Achse-1-Bausteine (Pages) | Achse-2-Bausteine (Nodes) | Achse-6-Allokator |
|---|---|---|---|
| P01-ART | DenseByte, Sparse, Node16/48 | Node4/16/48/256 | (n/a) |
| P02-HOT | Compound | HOT-Compound K32, BiNode | (n/a) |
| P03-Masstree | BPLUS | Internal/Border | (n/a) |
| P04-CoCo-trie | Macro | MacroNode | (n/a) |
| P05-START | Multibyte | Multibyte | (n/a) |
| P06-B²-Tree | Decision/Span | Decision/Span | (n/a) |
| P07-Wormhole | MetaTrieHT | (Hybrid) | (n/a) |
| P10-SuRF | LOUDS Dense/Sparse | (succinct) | (n/a) |
| P20-LeanStore | Adaptive | (multi-layout) | (n/a) |
| A01-Hoard, A04-mimalloc, A05-jemalloc, A06-tcmalloc, A07-snmalloc, A08-scalloc, A10-rpmalloc, A11-LRMalloc, A20-dlmalloc | (n/a) | (n/a) | TCMALLOC/MIMALLOC/SNMALLOC + 6 weitere |
| A03-Michael Lock-Free | (n/a) | (n/a) | LOCKFREE-Variante |

---

## §15 Querverweise

- Original-Quelle (UNVERAENDERT): `../termine/20260508 Termin 7/Bausteine_Matrix.txt`
- Allokator-Matrix: `02_allokator_matrix.md` (K-E.3)
- Cross-Paper-Konzeptmatrix: `03_cross_paper_konzeptmatrix.md` (K-E.4)
- Architekturentscheidungen F1-F15: `04_architekturentscheidungen_F1_F15.md` (K-E.5)
- Flag-System: `05_flag_system.md` (K-E.6)
- Eigenschaften Suchalgorithmen: `06_eigenschaften_suchalgorithmen.md` (K-E.7)
- Begriffsglossar v7 Master: `../glossar/01_begriffsglossar_v7_master.md`
- Forschungslandkarte 33 Paper: `../forschungslandkarte/01_quellen_gesamtkatalog.md` (K-F.2)
- LICENSE-Audit fuer V31-Adapter: `../../Code/external/comdare-cache-engine/LICENSE_AUDIT_EXT.md`
