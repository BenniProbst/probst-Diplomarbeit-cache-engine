# P21 — Chen/Gibbons/Mowry 2001 (Prefetching B+-Trees)

**Voller Titel:** Improving Index Performance through Prefetching
**Autoren:** Shimin Chen (CMU), Phillip B. Gibbons (Bell Labs), Todd C. Mowry (CMU)
**Venue:** SIGMOD 2001, Santa Barbara CA
**Volltext:** `_text/P21-ChenPB2001.txt` (12 Seiten, 91 KB)

## 1. Konzeptionelle Identitaet

**Prefetching B+-Trees (pB+-Trees)**: Nutzen Prefetching, um effektiv **breitere Knoten** zu erlauben (z.B. 8 Cache-Lines statt 1), die die Tree-Hoehe reduzieren — ohne die Kosten fuer einzelne Knotenzugriffe stark zu erhoehen.

> "pB+-Trees use prefetching to effectively create wider nodes than the natural data transfer size: e.g., eight vs. one cache lines or disk pages. These wider nodes reduce the height of the B+-Tree, thereby decreasing the number of expensive misses when going from parent to child" (P21:S.1/27-41)

**Klasse:** Cache-aware B+-Tree mit Software-Prefetch
**Performance:** Search/Update **1.2-1.5× schneller** als CSB+-Tree, Range Scans **6× schneller**!

## 2. Hauptkonzepte

### 2.1 Wider Nodes via Prefetching

> "Wider nodes reduce the height of the B+-Tree [...] without significantly increasing the cost of fetching a given node." (P21:S.1/39-42)

Idee: Knoten = N Cache-Lines. Beim Knoten-Eintritt **prefetch alle N Lines parallel**. Latenz wird durch Memory-Level-Parallelism versteckt.

### 2.2 Leaf-Pointer-Arrays fuer Range Scan

> "These [leaf-pointer-arrays] allow the pB+-Tree to prefetch arbitrarily far ahead, even for non-clustered indices, thereby hiding the normally expensive cache misses associated with traversing the leaves within the range." (P21:S.1/52-58)

Pro Leaf: Pointer-Array zu **kommenden** Leafs. Range Scan kann **mehrere Leafs voraus** prefetchen.

## 3. PRT-ART-Bezug

| Chen-2001-Konzept | PRT-ART-Bezug |
|---|---|
| **Wider Nodes via Prefetching** | **DIREKT relevant**: PRT-ART Cache-Engine Page-Type-Wahl kann groessere Pages durch Prefetch ermoeglichen |
| **Leaf-Pointer-Arrays** | NICHT direkt — PRT-ART hat keine Leaf-Liste, aber Cache-Engine kann analoge "next-page-prefetch" Hints geben |
| **Software Prefetch (`__builtin_prefetch`)** | DIREKT als PRT-ART Cache-Engine Tool |
| **Memory-Level-Parallelism** | wichtig: PRT-ART Cache-Engine misst Fill-Buffer-Auslastung (vgl. P25 Mahling) |

## 4. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **Chen 2001 Wider Nodes Prefetch ↔ Hankins/Patel "groesser-als-CL ist besser" (P13)**: gleiche Erkenntnis aus 2 Quellen
- **Chen 2001 Leaf-Pointer-Arrays ↔ Path-Prefetching FGCS Jump-Pointer-Queue (P26)**: zwei "ahead-prefetch"-Strategien
- **Chen 2001 Memory-Level-Parallelism ↔ Mahling Fill-Buffer-Modell (P25)**: gleiche Mechanik (24 Jahre auseinander)

## 5. Kernanschluss fuer PRT-ART

Chen 2001 ist die **klassische Vorlage** fuer Software-Prefetch in Index-Strukturen. PRT-ART Cache-Engine sollte:
- **Knotengroesse + Prefetch-Distanz** als gekoppelte Wahl behandeln (Termin 4 Designmuster)
- **Software-Prefetch via `__builtin_prefetch`** als Mechanismus nutzen
- **Range-Scan-Prefetch** ueber benachbarte Pages (analog Leaf-Pointer-Arrays)

Chen 2001 bestaetigt: Prefetch + groessere Knoten ist die **kombinierte Strategie**, die PRT-ART Cache-Engine adaptiv waehlen muss.
