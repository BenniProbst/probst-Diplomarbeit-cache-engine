# P12 — CSB+-Tree (Cache-Sensitive B+-Tree)

**Voller Titel:** Making B+-Trees Cache Conscious in Main Memory
**Autoren:** Jun Rao, Kenneth A. Ross (Columbia University)
**Venue:** SIGMOD 2000, Dallas TX
**Volltext:** `_text/P12-CSB-RaoRoss2000.txt` (12 Seiten, 54 KB)

## 1. Konzeptionelle Identitaet

CSB+-Tree = updatefaehige Variante des CSS-Tree. **Geschwister kontigous** im Speicher, nur **erster Kindpointer** wird gespeichert; weitere Kinder via Offset.

> "A CSB+-Tree puts all the child nodes for a given node contiguously in an array and stores only the pointer to the first child node. Other child nodes can be found by adding an offset to the first-child pointer." (P12:S.2/142-147)

**Klasse:** Cache-aware updatefaehiger B+-Tree
**Pflicht-Term:** **Node Group** = Set kontiguer Sibling-Nodes

## 2. Strukturelle Bausteine + 3 Varianten

| Variante | Beschreibung |
|---|---|
| **CSB+-Tree (basic)** | Bei Split: deallocate alte Node Group, allocate neue groesere |
| **Segmented CSB+-Tree** | Node Groups in Segmente unterteilt — nur 1 Segment kopieren bei Split |
| **Full CSB+-Tree** | Pre-allocate volle Node Group → einfache Memory-Verwaltung, billige Splits |

| Element | Beschreibung |
|---|---|
| **Node Group** | Container fuer kontigue Sibling-Nodes |
| **First Child Pointer** | NUR 1 Pointer pro Node (statt N) |
| **Offset-Adressierung** | child(node, i) = first_child + i × node_size |
| **Knoten-Groesse** | Cache-Line (z.B. 64 B) — typisch m Schluessel/Cache-Line |

**Cache Line Utilization:** Etwa 2× hoeher als vanilla B+-Tree (weniger Pointer-Speicher).

## 3. Algorithmen

| Operation | Cost |
|---|---|
| **Lookup** | O(log_m N) wie CSS-Tree |
| **Insert** | O(log_m N) + Split-Cost (Segment- oder Group-Copy) |
| **Delete** | O(log_m N) + Merge-Cost |

**Split-Strategien**:
- Basic: realloc + copy ALL Geschwister
- Segmented: nur 1 Segment kopieren
- Full: pre-allocated → kein Reallocate

## 4. PRT-ART-Bezug

| CSB+-Tree-Konzept | PRT-ART-Bezug |
|---|---|
| **Node Group + Offset-Adressierung** | konzeptionell Vorbild fuer PRT-ART **Custom Cache Page Layout** |
| **Cache-Line-grosse Knoten** | nicht direkt — PRT-ART Cache-Engine waehlt Page-Groesse adaptiv |
| **Updatefaehig (im Gegensatz zu CSS-Tree)** | PRT-ART braucht das auch — CSB+-Tree zeigt, wie es geht ohne Pointer-Pflicht |
| **Segmented vs Full Variante** | Cache-Engine-Wahl analog (Pre-Alloc vs On-Demand-Alloc) |

## 5. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **CSB+-Tree Node Group ↔ B²-Tree Outer-B+-Layer (P06)**: kontigue Page-Layouts
- **CSB+-Tree Offset-Arithmetik ↔ CSS-Tree (P11) ↔ SuRF LOUDS-Dense (P10)**: drei pointer-arme Layouts
- **CSB+-Tree Pre-Allocate Full Variant ↔ START Rewired Nodes (P05)**: zwei Strategien fuer "Reserve fuer spaetere Inserts"
- **CSB+-Tree updatefaehig ↔ Saikkonen Online-Relocation (P18)**: zwei Strategien fuer "Cache-aware UND dynamic"

## 6. Kernanschluss fuer PRT-ART

CSB+-Tree ist die **klassische updatefaehige Cache-aware B+-Variante** und damit Pflicht-Vergleichsbasis. PRT-ART beweist gegenueber CSB+-Tree:
1. **Trie-basierte Suche** statt B+-Tree-Suche
2. **Adaptive Page-Familie** statt fester Cache-Line-Knoten
3. **Cache-Engine als getrennte Entscheidungsschicht**
4. **Plattformkalibrierung** (CSB+-Tree fest auf Cache-Line)

CSB+-Tree's Idee "kontigue Geschwister + 1 Pointer + Offset" ist ein direktes Layout-Vorbild fuer PRT-ART **Custom Cache Page**.
