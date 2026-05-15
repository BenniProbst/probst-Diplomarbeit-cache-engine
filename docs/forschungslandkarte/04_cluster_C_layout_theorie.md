# Cluster C — Layout-Theorie

**Stand:** 2026-05-15 (K-F.5)
**Quelle:** `../termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions/cluster_C_layout_theorie.md` (626 Z)
**Inhalt:** 6 Layout-Theorie-Paper P14, P15, P16, P17, P18, P19

---

## §1 Cluster-Mitglieder

| P-ID | Paper | Autoren / Jahr / Venue | V31-Adapter |
|---|---|---|---|
| **P14** | Making CSB+-Trees Processor Conscious | Samuel/Pedersen/Bonnet (2005) | LEGACY_REIMPL |
| **P15** | B-Tree Indexes and CPU Caches (Survey) | Graefe/Larson (2001) | (Survey, kein Adapter) |
| **P16** | Tree Layout in Multilevel Memory | Bender/Demaine/Farach-Colton (2002) | LEGACY_REIMPL |
| **P17** | Cache-Oblivious B-Trees | Bender/Demaine/Farach-Colton (2005) | LEGACY_REIMPL (vEB-Recursion echt!) |
| **P18** | Cache-sensitive Memory Layout for Binary Trees | Saikkonen/Soisalon-Soininen (2008, IFIP TCS) | LEGACY_REIMPL |
| **P19** | Cache-Sensitive Memory Layout for Dynamic Binary Trees | Saikkonen/Soisalon-Soininen (2016, ComJ) | LEGACY_REIMPL |

---

## §2 Cluster-Kernkonzepte

### 2.1 Theoretische Modelle

| Paper | Modell |
|---|---|
| P15 Graefe | Survey: B-Tree Indexes und CPU Caches |
| P16 Bender 2002 | Probability-driven Tree Layout in Multilevel Memory |
| P17 Bender 2005 | Cache-Oblivious B-Trees — vEB-Recursion (NICHT BFS-Approximation!) |
| P18 Saikkonen 2008 | Multi-Level Block Reorganization fuer Binary Trees |
| P19 Saikkonen 2016 | Layout-Invariante mit Constant-Time Updates |

### 2.2 Memory-Hierarchie

| Paper | Annahmen ueber Cache |
|---|---|
| P16 Bender | Multilevel-Memory-Model (Cache + Memory + Disk) |
| P17 Bender | Cache-Oblivious — kein explizites Wissen ueber Cache-Groesse |
| P18 Saikkonen | Cache-Block-Layout, explizit |
| P19 Saikkonen | Layout-Invariante (Updates aendern Layout NICHT) |

### 2.3 P14 Configuration Table

P14 Samuel fuegt eine Configuration Table zum CSB+-Tree, die zur Compile-Time konfiguriert wird (siehe Architekturentscheidung F-EXTRA-7). Das ist die direkte Vorlage fuer das **PRT-ART Flag-System** (F10-K Bit-basierte Permutation-Identifier).

### 2.4 P17 vEB-Recursion (Memory-Direktive!)

Cache-Oblivious B-Trees (P17) verwenden vEB-Recursion. **WICHTIG (Memory-Direktive `feedback_algorithm_correctness_when_named`):**

> Wenn `VebLayout`/`ARTNode`/`BPlusTree` etc. — MUSS echter Algorithmus sein
> KEIN BFS-Approximation, KEIN "ungefaehr", KEIN "Skelett"; sonst UMBENENNEN

vEB-Ordering ist NICHT BFS — vEB ist eine rekursive halbiere-und-fuege-zusammen-Struktur, die die Recursion-Tiefe mit log log n erreicht.

---

## §3 Vollangaben (siehe Original)

Detail-Konzept-Extraktionen pro Paper:
`../termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions/cluster_C_layout_theorie.md`

---

## §4 Bausteine-Matrix-Mapping (Achse 5 Memory-Layout primaer)

| Bausteine-ID | Achse | Paper |
|---|---|---|
| `PAGE_CONFIGTABLE_SAMUEL` | 1 | P14 |
| `MEMORY_HUGEPAGE_2MB_ALIGNED`, `MEMORY_HUGEPAGE_1GB_ALIGNED` | 5 | P32 (siehe auch Cluster F) |
| (vEB-Layout) | 5 | P17 |
| (Multi-Level Reloc) | 5+8 | P18 |
| (Layout-Invariante) | 5 | P19 |

---

## §5 Architekturentscheidungs-Bezug

| Paper | ADR-Bezug |
|---|---|
| P14 | F-EXTRA-7 (Mess-Kategorien × Algorithmus-Details Vollstaendigkeits-Matrix), F10-K (Configuration Table als Vorbild fuer Flag-System) |
| P16 | F-EXTRA-7, F29 IAuxiliaryProbabilityHintStrategy |
| P17 | F-EXTRA-7 (vEB-Recursion korrekt implementiert) |
| P18 | F2 Observer-Mechanik + Konsolidierungs-Barriere (Multi-Level-Reloc-Vorbild fuer Reorg) |
| P19 | F-EXTRA-6 DecisionLambdaTrees (Layout-Invariante mit Update-Trees) |

---

## §6 Querverweise

- Original-Quelle (UNVERAENDERT): `../termine/20260508 Termin 7/Phase5_UML_Detail/_paper_extractions/cluster_C_layout_theorie.md`
- Cluster B (Hybrid+B+): `03_cluster_B_hybrid_bplus.md`
- Cluster D (Prefetching 1): `05_cluster_D_prefetching_1.md`
- Quellen-Gesamtkatalog: `01_quellen_gesamtkatalog.md` §2 A.1 (klassisch B-Baum-Familie)
- Bausteine-Matrix: `../bausteine/01_bausteine_matrix.md` §7 Memory-Layout
- Eigenschaften pro Algorithmus: `../bausteine/06_eigenschaften_suchalgorithmen.md` §3 Kategorie A
- Memory-Direktive vEB-Korrektheit: `~/.claude/.../memory/feedback_algorithm_correctness_when_named.md`
