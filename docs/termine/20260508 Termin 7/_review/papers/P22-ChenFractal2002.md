# P22 — Chen et al. 2002 (Fractal Prefetching B+-Trees)

**Voller Titel:** Fractal Prefetching B+-Trees: Optimizing Both Cache and Disk Performance
**Autoren:** Shimin Chen, Phillip B. Gibbons (Bell Labs), Todd C. Mowry (CMU), Gary Valentin (IBM Toronto)
**Venue:** SIGMOD 2002, Madison WI
**Volltext:** `_text/P22-ChenFractal2002.txt` (12 Seiten, 192 KB — Encoding-Issues)

> Hinweis: Volltext-Extraktion via pypdf hatte Encoding-Probleme. Konzepte aus Abstract + Termin-4-Hauptdokument abgeleitet.

## 1. Konzeptionelle Identitaet

**fpB+-Trees** kombinieren Cache-optimized und Disk-optimized B+-Trees in einem **fraktalen Layout**: Disk-Page-grosse Knoten (z.B. 4 KB) enthalten **eingebettete Cache-Line-grosse Subtrees**.

> "B+-Trees optimized for disk suffer an excessive number of cache misses to search in a (large) node, wasting time and forcing the eviction of useful data from the cache. [...] Fractal Prefetching B+-Trees ('fractal'), which embed cache-optimized B+-Trees within disk-optimized B+-Trees, in order to optimize both cache and IO performance." (P22:Abstract)

**Klasse:** Hybrid Cache-+Disk-optimierter B+-Tree
**Performance (laut Abstract):** Search 1.1-1.8× schneller, Range Scan 4.2× schneller, Update 20-fold schneller — ggu disk-optimized B+-Trees

## 2. Hauptkonzept (Fraktal-Idee)

- **Outer Layer**: Disk-optimized B+-Tree (4 KB Pages)
- **Inner Layer pro Disk-Page**: Cache-optimized Sub-B+-Tree (Cache-Line-Knoten)
- **Beide Ebenen** profitieren von Prefetching (cache-line + disk-page)

Zwei Ansaetze:
- **disk-first fpB+-Trees**: Outer-Page-Layout ist Disk-optimiert, Inner-Layout ist Cache-optimiert
- **cache-first fpB+-Trees**: Inner-Cache-Layout primaer, Outer-Disk-Layout sekundaer

## 3. PRT-ART-Bezug

| fpB+-Tree-Konzept | PRT-ART-Bezug |
|---|---|
| **Fraktal-Layout (mehrere Granularitaeten)** | konzeptionell aequivalent zu PRT-ART **Multi-Level Cache-Engine Optimierung** |
| **Disk + Cache gemeinsam** | NICHT in PRT-ART (CPU-only) |
| **Embedded Subtree pro Page** | konzeptionell verwandt zu B²-Tree (P06) Embedded Tree pro Page |
| **Prefetching auf zwei Granularitaeten** | DIREKTES Vorbild fuer PRT-ART Cache-Engine Multi-Level-Prefetch |

## 4. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **fpB+-Trees Embedded Cache-Tree pro Disk-Page ↔ B²-Tree Embedded Trie pro B+-Page (P06)**: gleiche Architekturidee fuer 2 verschiedene Hierarchie-Levels
- **fpB+-Trees Multi-Granularitaet ↔ Saikkonen Multi-Level-Layout (P18)**: beide Multi-Level-aware
- **fpB+-Trees Wider Disk-Pages mit Inner-Cache-Optim ↔ Chen 2001 Wider Cache-Nodes (P21)**: gleiches Team, gleiches Prinzip auf anderer Granularitaet

## 5. Kernanschluss fuer PRT-ART

fpB+-Trees zeigen, dass **mehrere Hierarchie-Ebenen gleichzeitig optimiert werden koennen**. PRT-ART hat zwar keinen Disk-Pfad, aber die Idee passt auf:
- **L1/L2/L3/RAM-Hierarchie** (PRT-ART Cache-Engine)
- **Page-Type pro Subtree-Region** (= konzeptionell "fraktales Layout pro Subtree")

PRT-ART **uebertraegt** Chen 2002 von "Cache vs Disk" auf "L1 vs L2 vs L3 vs RAM" — alle modelliert von der Cache-Engine.
