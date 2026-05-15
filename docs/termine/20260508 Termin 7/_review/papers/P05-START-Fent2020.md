# P05 — START (Self-Tuning Adaptive Radix Tree)

**Voller Titel:** START - Self-Tuning Adaptive Radix Tree
**Autoren:** Philipp Fent, Michael Jungmair, Andreas Kipf, Thomas Neumann (TUM)
**Venue:** ICDEW 2020
**Volltext:** `_text/P05-START-Fent2020.txt` (7 Seiten, 34 KB)

## 1. Konzeptionelle Identitaet

START ist eine **ART-Variante mit multilevel Nodes** (mehrere Bytes pro Knoten), kostenmodellbasiert optimiert fuer **read-heavy workloads**.

> "We introduce START, a self-tuning variant of ART that uses nodes spanning multiple key-bytes. To determine where to introduce these new node types, we propose a cost model and an optimizer." (P05:S.1/13-16)

**Klasse:** Adaptive Radix Tree mit hardware-spezifischer Optimierung
**Performance:** 85% schneller als ART bei read-only, 45% bei read-mostly

## 2. Strukturelle Bausteine

### 2.1 Standard ART Nodes + 3 NEUE START Node-Typen

| Typ | Levels | Beschreibung |
|---|---|---|
| Node4 | 1 | Standard ART (P01) |
| Node16 | 1 | Standard ART |
| Node48 | 1 | Standard ART |
| Node256 | 1 | Standard ART |
| **MultiNode4** | 2-4 | NEU: 4 Keys mit je 1-4 Bytes, in 1 Cache-Line (64B) |
| **Rewired64K** | 2 | NEU: 256² = 64K Eintraege via Memory Rewiring |
| **Rewired16M** | 3 | NEU: 256³ = 16M Eintraege via Memory Rewiring |

### 2.2 Rewired Nodes (Schluesselinnovation)

> "Multiple compatible and sparsely populated virtual pages can share one physical page. Additionally, empty pages do not consume any physical memory." (P05:S.2/213-216)

Implementierung (P05:S.2/189-203):
1. `memfd_create` — main-memory file
2. Multiple `mmap` calls — virtual-zu-physical Mapping
3. **Pointer-Tagging** in den Slots — unterscheidet welche virtual page der Eintrag gehoert
4. Empty pages mappen auf `∅` (zero page) — kein RAM-Verbrauch

**Effizienz:** Rewired16M (16M Pointer / 215 virtual pages) lohnt sich ab 200K Eintraegen (1% Fuellrate, 22.5 Bytes/Entry).

**Limitations:**
> "Inserts may even cause new collisions, which we handle with explicit unsharing operations during insertion." (P05:S.3/253-254)

### 2.3 MultiNode4

> "We use the 12 unused Bytes of a regular Node4 (with respect to its representing cache line) to add multilevel support." (P05:S.3/263-265)

→ **Spannt 2-4 Radix-Levels** in einer einzigen Cache-Line!

## 3. Cost Model (Schluessel-Beitrag fuer PRT-ART!)

### 3.1 Lookup-Kosten messen

> "To obtain the cost for a lookup in a node, we measure the cost CL(n) to traverse a node n in an isolated experiment. As baseline CL(∅), we take the time to traverse two consecutive Node4." (P05:S.4/293-296)

CL(n) = C'L(n) - CL(∅) wobei:
- C'L(n) = Zeit fuer 2× Node4 + Node n dazwischen
- CL(∅) = Zeit fuer 2× Node4 alleine
- LFENCE als Speculation-Barrier
- Median ueber multiple Runs

### 3.2 Cache-Level-spezifische Costs

> "Caches are transparent, costs can only be measured reliably for nodes residing in L1 cache or in main memory: CL,L1(n) and CL,RAM(n)." (P05:S.4/308-310)

Extrapolation auf L2/L3 (P05:S.4/Gl.):
```
CL,Li(n) = CL,L1(n) + ⌊CL,RAM(n)/LRAM⌋ × (LLi - LL1)
```

→ **Haengt von Cache-Latenzen LL1, LL2, LRAM ab → Hardware-spezifisch!**

### 3.3 Cost-Funktion C(n)

```
C(n) = CL(n) × #k(n) + sum_{x in child+(n,1)} C(x)
```

Mit Multilevel-Replacement:
```
C_Replaced(o, i) = CL(o) × #k(o) + sum_{x in child+(o,i)} C(x)
```

Benefit: `b(n, o, i) = C(n) - C_Replaced(o, i)`

## 4. Dynamic Programming Optimizer (P05:S.4-5/Sec.IV-B)

> "We propose a dynamic programming algorithm that considers the cost of optimal lower-level nodes." (P05:S.5/367-368)

Bottom-up Traversal mit Cost-Table pro Knoten:
- Erste Zeile: #Keys im Subtree
- Zweite Zeile: Liste optimaler Costs der Descendants

→ **O(n) Algorithmus** (n = Knotenzahl), liefert optimale Multilevel-Platzierung.

**Self-Tuning Phase:**
> "It only runs when more than 10% of the data was changed, or it runs as part of regular index maintenance (e.g., during VACUUM jobs)." (P05:S.4/284-286)

## 5. Performance-Tabelle (P05:S.4/Table I)

| Node | Cached (ns) | Header Cached (ns) | Uncached (ns) |
|---|---|---|---|
| Node4 | 7 | 7 | 68 |
| Node16 | 5 | 77 | 162 |
| Node48 | 2 | 165 | 168 |
| Node256 | 2 | 88 | 92 |
| **Rewired64K** | 6 | 87 | 162 |
| **Rewired16M** | 6 | 88 | 165 |
| **MultiNode4** | 6 | 6 | 68 |

**Wichtige Erkenntnis:**
> "Three layers of Node256 by one Rewired16M node where one single header can still fit into the cache: 88 + 2·92 = 272 > 88 Rewired16M" (P05:S.5/520-522)

→ Multilevel **spart 3× Cache-Misses bei kalten Subtrees**.

## 6. Plattform-Annahmen
- Intel i9-7900X CPU mit 13.8 MB LLC
- C++17 mit GCC
- LFENCE / CLFLUSH fuer kontrollierte Messung

## 7. PRT-ART-Bezug (HIGHLY IMPORTANT!)

START ist der **direkteste Vorgaenger** fuer PRT-ART Cache-Engine. Genauer:

| START-Konzept | PRT-ART-Bezug |
|---|---|
| **Cost Model** | **= PRT-ART Cache-Engine Plattform-Kalibrierung Modus 2** |
| **Multilevel Nodes als Page-Type** | **= PRT-ART Extended Dense Page** |
| **Rewired Nodes mit virtuellen Pages** | OPTIONAL Vorbild fuer PRT-ART Allocator-Strategie |
| **Optimizer als getrenntes Modul** | **konzeptionell = PRT-ART Cache-Engine Page-Type-Selection!** |
| **OFFLINE-Tuning (VACUUM-Phase)** | PRT-ART **Cache-Engine Modus 2 (Warm-up)** |
| **Workload-agnostisches Cost Model** | PRT-ART aehnlich (kein Workload-Tracking im Pflichtkern) |
| **MultiNode4 (4 Bytes in 1 Cache-Line)** | direktes Vorbild fuer PRT-ART Custom Cache Page |
| **CL,Li(n) Extrapolation** | PRT-ART Cache-Engine kann diese Methodik direkt uebernehmen |

**Aber wichtig:** START's Cost Model und Optimizer sind **innerhalb** der ART-Implementierung. PRT-ART macht es **als getrenntes Modul** (Cache-Engine), das pro Knoten/Page individuell entscheidet.

> "Online concept": "the concept can also be applied online" (P05:S.1/55) — START erlaubt es im Prinzip, fokussiert aber auf Offline-Tuning. **PRT-ART macht den Online-Fall zur Default-Wahl** (Cache-Engine Modus 3 adaptiv).

## 8. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **START Cost Model ↔ Bender/Demaine Probability-driven Layout (P16) ↔ Dortmund Hot-Path Histograms (P28)**: drei Strategien fuer "messen-dann-optimieren"
- **START MultiNode4 ↔ B-Trees Are Back Heads/Hints (P20)**: kompakte Inline-Erweiterungen
- **START Rewired Nodes ↔ Linux Hugepages**: virtual-physical decoupling
- **START Optimizer (Dynamic Programming) ↔ CoCo-Trie Optimizer (per-node)**: beide minimieren globale Kosten
- **START LFENCE-isolierter Cost-Test ↔ TUD VAMPIR (P33) virtualisierte NFP-Messung**: Methodik fuer reproduzierbare Plattformmessung

## 9. Kernanschluss fuer PRT-ART

START liefert die **wichtigste konzeptionelle Vorlage** fuer PRT-ART Cache-Engine:
- Cost Model
- Hardware-spezifische Kalibrierung
- Optimizer als getrenntes Modul

PRT-ART verallgemeinert START's Ansatz von "ART-spezifisch + offline" zu "**Domaenenmodell-getrennt + online adaptiv**" — das ist der **Hauptbeitrag** von PRT-ART gegenueber START.
