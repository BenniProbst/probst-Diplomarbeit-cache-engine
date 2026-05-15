# P16 — Bender/Demaine/Farach-Colton (Tree Layout in Multilevel Memory)

**Voller Titel:** Efficient Tree Layout in a Multilevel Memory Hierarchy
**Autoren:** Michael A. Bender (Stony Brook), Erik D. Demaine (MIT), Martin Farach-Colton (Google + Rutgers)
**Venue:** ESA 2002 (Springer LNCS 2461)
**Volltext:** `_text/P16-BenderTreeLayout2002.txt` (8 Seiten — schlanke Direkt-PDF, REV4 ersetzt 10 MB Band)

## 1. Konzeptionelle Identitaet

Theoretisches Modell + 3 Algorithmen fuer **Tree-Layout-Optimierung** in Multi-Level-Hierarchie, gegeben **Wahrscheinlichkeitsverteilung auf Leaves**.

> "We consider the problem of laying out a tree or trie in a hierarchical memory, where the tree/trie has a fixed parent/child structure. The goal is to minimize the expected number of block transfers performed during a search operation, subject to a given probability distribution on the leaves." (P16:S.1/16-21)

**Klasse:** Theoretisches Layout-Optimierungs-Modell + Greedy-Algorithmus
**Hauptbeitrag:** Greedy O(N log B), 1-additive Approximation; Cache-oblivious Variante mit konstantem Approximationsfaktor

## 2. Drei Algorithmen

### 2.1 Greedy (P16:Sec.2.1)

> "The greedy algorithm chooses the root block that maximizes the sum of the probabilities of the nodes within the block." (P16:S.4/148-150)

- Start mit Root-Knoten
- Iterativ: fuege max-probability Knoten adjacent zu Root-Block hinzu, bis Block-Size B erreicht
- Recurse auf Sub-Trees
- **Approximation:** Optimal + (B-1)/B < 1 additive Konstante
- **Komplexitaet:** O(N log B)

### 2.2 Relaxed Greedy (P16:Sec.2.2)

Lockerer: jeder Knoten mit Probability ≥ ε × max ist erlaubt.
- **Approximation:** 1/ε × Optimal + Konstante
- Mehr Flexibilitaet bei groesserer ε-Toleranz

### 2.3 Cache-Oblivious Layout (P16:Sec.3)

**Block-Size B unbekannt** zur Algorithmus-Zeit.
- Greedy ohne fixe B → recursive: Root-Block ~ erwartete Sub-Tree-Groesse
- **Approximation:** 4× Optimal + 4
- Funktioniert auf jedem Level der Memory-Hierarchie automatisch!

## 3. Strukturelle Bausteine + Definition

| Begriff | Bedeutung |
|---|---|
| **Probability of internal node** | Summe der Probabilities aller Leaves im Subtree |
| **Root block** | Block mit Root des Trees |
| **Root-block tree** | Maximal connected sub-tree innerhalb Root-Block |
| **Smooth cost model** | Cost = j/B fuer Block mit j Eintraegen (kontinuierlich) |
| **B** | Block-Transfer-Size (Cache-Line oder Page) |

### Lemma 1 (P16:S.3/119-122)
> "There exists an optimal layout of a tree T such that within the block containing the root of T (the root block) the nodes form a connected subtree."

→ Reduziert Suche auf "wie packe ich Knoten in Bloecke optimal".

## 4. PRT-ART-Bezug (HIGHLY RELEVANT!)

| Bender-Konzept | PRT-ART-Bezug |
|---|---|
| **Probability-driven Layout** | **DIREKT relevant fuer PRT-ART Cache-Engine "Probability Hints"** (Termin 4 Designmuster) |
| **Greedy Block-Packing** | konzeptionell aequivalent zu PRT-ART **Page-Type-Selection mit Density-Threshold** |
| **Multi-Level-Modell** | PRT-ART Cache-Engine modelliert L1/L2/L3/TLB als Block-Ebenen |
| **Cache-Oblivious Variante** | **GEGENPOL** zu PRT-ART (PRT-ART ist explizit cache-AWARE) |
| **Greedy-Approximation** | METHODISCH: PRT-ART Cache-Engine kann Greedy als Heuristik fuer Page-Type-Wahl nutzen |
| **Smooth Cost Model** | konzeptionell verwandt zu START Cost Model (P05) |

## 5. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **Bender Probability Layout ↔ Dortmund Hot-Path Histogramme (P28) ↔ Path-Prefetching FGCS Read Counters (P26) ↔ START Cost Model (P05)**: vier Strategien fuer "messen-dann-layouten"
- **Bender Multi-Level Block-Hierarchy ↔ Saikkonen 2008 (P18) Multi-Level inkl. TLB**: zwei Layout-Modelle fuer mehrstufige Hierarchien
- **Bender Cache-Oblivious ↔ Bender Cache-Oblivious B-Trees (P17)**: gleiche Autorengruppe, konzeptioneller Gegenpol zu PRT-ART
- **Bender Greedy-Approximation ↔ START Dynamic Programming Optimizer (P05)**: zwei Optimizer-Strategien

## 6. Kernanschluss fuer PRT-ART

Bender/Demaine/Farach-Colton 2002 ist der **theoretische Hintergrund** fuer:
1. **Probability Hints in Page-Headers** (PRT-ART Termin 4)
2. **Layout-Optimierung mit gegebener Verteilung** (Cache-Engine Aufgabe)
3. **Multi-Level-Modellierung** (PRT-ART Cache-Engine misst alle Cache-Levels)

PRT-ART unterscheidet sich von Bender et al. wie folgt:
- Bender: **statische Verteilung gegeben + statisches Layout berechnen**
- PRT-ART: **dynamische Verteilung gemessen via Telemetrie + Online-Relocation der Cache-Engine**

Das ist der **forschungsbeitragende Schritt von PRT-ART**: Was Bender als statisches Optimierungsproblem formuliert, loest PRT-ART als **adaptive Online-Heuristik**.

Wichtig: Cache-Oblivious Variante (Sec.3) ist der **Gegenpol** zu PRT-ART. PRT-ART **lehnt cache-oblivious bewusst ab** und argumentiert: gemessene cache-aware Layouts sind besser als algorithm-agnostic Cache-Oblivious-Eleganz.
