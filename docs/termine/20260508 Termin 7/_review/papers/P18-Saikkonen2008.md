# P18 — Saikkonen/Soisalon-Soininen 2008 (Cache-sensitive Memory Layout for Binary Trees)

**Voller Titel:** Cache-sensitive Memory Layout for Binary Trees
**Autoren:** Riku Saikkonen, Eljas Soisalon-Soininen (Helsinki University of Technology)
**Venue:** IFIP TCS 2008 (Springer LNCS)
**Volltext:** `_text/P18-Saikkonen2008.txt` (15 Seiten, 42 KB)

## 1. Konzeptionelle Identitaet

**Multi-Level Cache-Sensitive Memory-Layout** mit **Online-Relocation** fuer dynamische Binary Trees (AVL/Red-Black). Inkl. **TLB als oberste Block-Ebene**.

> "We give an algorithm that preserves cache-sensitivity in binary trees in the dynamic case, i.e., during insertions and deletions. Our algorithm retains single-level cache-sensitivity using small worst-case constant-time operations executed when the tree changes." (P18:S.2/68-71)

**Klasse:** Multi-Level Cache-Sensitive Layout-Algorithmus
**Hauptbeitrag:** Globale Relocation + lokal konstante Update-Operationen, beides multi-level

## 2. Multi-Level Cache Model (P18:Sec.2)

> "We have a k-level cache hierarchy with block sizes B_1, ..., B_k at each level. We also define B_0 = node size in bytes, B_{k+1} = ∞." (P18:S.2/82-85)

| Level i | Bedeutung |
|---|---|
| B_0 | Node size in Bytes |
| B_1 | L1 Cache-Block-Size (z.B. 64 B) |
| B_2 | L2 Cache-Block-Size (oder TLB Page-Size, z.B. 4096 B) |
| ... | ... |
| B_k | Hoechstes Level (z.B. TLB Page) |
| B_{k+1} | ∞ |

**Pi**: B_i-block search path length = #separate B_i-cache-blocks von Root zu Leaf

> "A typical modern computer employs two levels of caches: a relatively small and fast level 1 ('L1') cache, and a larger and slower level 2 ('L2') cache. In addition, the mapping of virtual addresses to physical addresses... employs a third hardware cache: the **Translation Lookaside Buffer or TLB cache**." (P18:S.3/104-108)

## 3. Globale Relocation (P18:Sec.3)

**Algorithmus:** BFS-Fuellung pro Block-Level + Rekursion.
- Erste Lowest-Level-Block (l=1) mit BFS gefuellt
- Border-Knoten werden Roots eigener Sub-Bloecke
- Rekursiv: l > 1 Bloecke = Container fuer l-1 Bloecke
- **Optionaler Half-Full-Threshold** (Lines 17-20): Bloecke mind. halb voll

**Theorem 1:** Worst-Case Path-Length P_i = ⌈h/h_i⌉ mit:
- h_i = h_{i-1} × ⌊log_{d_{i-1}}(B_i/B_{i-1} + 1)⌋
- h_0 = 1

**Theorem 2:** Algorithmus-Zeit: **O(nk)** mit n Knoten, k Cache-Levels.

## 4. PRT-ART-Bezug (DIREKT relevant fuer Cache-Engine!)

| Saikkonen-Konzept | PRT-ART-Bezug |
|---|---|
| **Multi-Level Cache Model inkl. TLB** | **PRT-ART Cache-Engine MUSS Multi-Level inkl. TLB modellieren** |
| **Globale Relocation Algorithmus** | **DIREKTE BLAUPAUSE** fuer PRT-ART Online-Relocation der Cache-Engine |
| **BFS-basierte Block-Fuellung** | konkrete Strategie fuer PRT-ART Page-Reorganisation |
| **Half-Full-Threshold (mind. 50%)** | direkt uebernahmbar als PRT-ART Compaction-Schwelle |
| **Konstant-Zeit Worst-Case Updates** | wichtige Eigenschaft fuer PRT-ART Update-Pfade |
| **B_0 (node) als parametrisierbar** | PRT-ART: Cache-Engine waehlt Node-Size adaptiv |

## 5. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **Saikkonen Multi-Level inkl. TLB ↔ Hankins/Patel TLB-Mit-Modellierung (P13)**: beide TLB-aware
- **Saikkonen Globale Relocation ↔ Bender Tree Layout greedy (P16)**: zwei Layout-Algorithmen, Saikkonen mit Updates, Bender mit Probabilities
- **Saikkonen BFS-Fuellung ↔ HOT Compound-Node-Konstruktion (P02)**: zwei BFS-basierte Layouts
- **Saikkonen Cache-Sensitive vs Cache-Oblivious ↔ Bender Cache-Oblivious B-Trees (P17)**: gleiche Frage, andere Antwort

## 6. Kernanschluss fuer PRT-ART

Saikkonen 2008 ist die **algorithmische Blaupause** fuer:
- **PRT-ART Cache-Engine Multi-Level Profil** (L1/L2/L3/TLB als Block-Ebenen)
- **PRT-ART Cache-Engine Online-Relocation** (BFS-Fuellung + Half-Full-Threshold)

PRT-ART verallgemeinert:
- Saikkonen: **fixed binary tree** (AVL/RB) → PRT-ART: **adaptive Page-Familie**
- Saikkonen: **rebalancing-getrieben** → PRT-ART: **Cache-Engine-getrieben**
- Saikkonen: **konstanter Worst-Case** → PRT-ART: **amortisiert + adaptiv**

Der Algorithmus aus Fig.1 (`reloc-block`) kann fast 1:1 in PRT-ART Cache-Engine als Default-Reorganisationsstrategie uebernommen werden.
