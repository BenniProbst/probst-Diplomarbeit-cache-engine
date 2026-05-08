# P01 — ART (Adaptive Radix Tree)

**Voller Titel:** The Adaptive Radix Tree: ARTful Indexing for Main-Memory Databases
**Autoren:** Viktor Leis, Alfons Kemper, Thomas Neumann (TU Muenchen)
**Venue:** ICDE 2013
**Pfad:** `./Forschungsarbeiten/The_adaptive_radix_tree_ARTful_indexing_for_main-memory_databases.pdf`
**Volltext:** `./_review/papers/_text/P01-ART-Leis2013.txt` (12 Seiten, 65 KB)

---

## 1. Konzeptionelle Identitaet

ART ist eine **adaptive Radix-Tree-Variante** (Trie-Klasse) mit dynamisch waehlbaren Knotentypen je nach Fanout. Span-Parameter fest auf **8 Bit (1 Byte)**.

**Klasse:** Trie / Radix-Tree / Prefix Tree / Digital Search Tree
**Lese-Anker:** Die Hoehe haengt von der **Schluessellaenge `k`** ab, NICHT von `n` (Anzahl Schluessel).

> "Radix trees consist of two types of nodes: Inner nodes, which map partial keys to other nodes, and leaf nodes, which store the values corresponding to the keys." (P01:S.5/254-256)

---

## 2. Strukturelle Bausteine (Originalterminologie)

### 2.1 Vier Inner-Node-Typen (mit konkreten Layouts und Speicherwerten)

| Typ | Kinder | Layout | Bytes (16B Header + 8B Pointer) |
|---|---|---|---|
| **Node4** | 2-4 | 2 Arrays (key[4] + child[4]), keys sortiert | 16 + 4 + 4·8 = **52** |
| **Node16** | 5-16 | 2 Arrays (key[16] + child[16]), SIMD-search | 16 + 16 + 16·8 = **160** |
| **Node48** | 17-48 | childIndex[256] + child[48], indirekte Adressierung | 16 + 256 + 48·8 = **656** |
| **Node256** | 49-256 | child[256], direkte Byte-Adressierung | 16 + 256·8 = **2064** |

Quelle: P01:S.7/Table I.

### 2.2 Header (alle Inner Nodes, konstante Groesse)

> "At the front of each inner node, a header of constant size (e.g., 16 bytes) stores the node type, the number of children, and the compressed path." (P01:S.5/425-427)

### 2.3 Leaf Storage (drei Optionen)

> "Single-value leaves [...] Multi-value leaves [...] Combined pointer/value slots [...] particularly attractive for secondary database indexes which store tuple identifiers with the same size as pointers." (P01:S.5/452-473)

PRT-ART-Anschluss: **Combined pointer/value slots** ist konzeptionell PRT-ART **ValueHandle::Inline** vs **External**.

---

## 3. Span-Parameter (sehr wichtig fuer PRT-ART)

> "The parameter `s`, which we call **span**, is critical for the performance of radix trees, because it determines the height of the tree for a given key length: A radix tree storing `k` bit keys has `⌈k/s⌉` levels of inner nodes." (P01:S.5/261-264)

ART waehlt s=8 (Bytes). Vergleich:
- s=1: 32 Levels fuer 32-Bit Keys (zu hoch)
- s=8: 4 Levels fuer 32-Bit Keys (gut)
- s=32: 1 Level — Speicherexplosion bei sparse Keys

**PRT-ART-Bezug:** START (P05) variiert genau diesen Span pro Knoten — ART hat ihn fest auf 8.

---

## 4. Tree-Hoehen-Reduktion (zwei Techniken)

### 4.1 Lazy Expansion

> "Inner nodes are only created if they are required to distinguish at least two leaf nodes." (P01:S.6/489-491)

### 4.2 Path Compression (Pfadkompression)

Removes all inner nodes mit nur einem Kind. Zwei Strategien:
- **Pessimistic:** variable length partial key vector am Inner-Node
- **Optimistic:** nur Count, am Leaf voller Schluesselvergleich

**ART-Wahl:** Hybrid — 8 Bytes pessimistisch, dynamischer Switch zu optimistisch.

---

## 5. Algorithmen

### 5.1 findChild (vier Faelle, je Node-Typ)

- **Node4:** simple Loop ueber 4 Eintraege
- **Node16:** **SIMD/SSE** mit `_mm_set1_epi8 + _mm_cmpeq_epi8 + _mm_movemask_epi8 + ctz` (count trailing zero) — 16 Vergleiche in 1 Instruktion!
- **Node48:** zwei Array-Lookups: `child[childIndex[byte]]`
- **Node256:** ein Array-Lookup: `child[byte]`

### 5.2 Insert (rekursiv, drei Sub-Cases)

1. Empty subtree → einfach replace mit Leaf
2. Existing Leaf gefunden (Lazy Exp Conflict) → expandiere zu Node4 mit beiden Leaves
3. Prefix-Mismatch → erzeuge neuen Inner-Node ueber dem aktuellen, splitte Compressed Path

---

## 6. Komplexitaet und Speicher

| Operation | Komplexitaet |
|---|---|
| Search | O(k) mit `k = Schluessellaenge in Bytes` |
| Insert | O(k) amortisiert |
| Delete | O(k) amortisiert |

Worst-case Space: **52 Bytes/Key** (4 Node-Types), **34 Bytes/Key** (6 Node-Types). Best case 8.1 Bytes/Key bei dichten Integers.

---

## 7. Binary-comparable Keys (Sortier-Mechanik)

> "If only binary-comparable keys are used as keys of a radix tree, the data is stored in sorted order and all operations that rely on this order can be supported." (P01:S.7/766-768)

Transformationen pro Datentyp: Unsigned int (Endian-Swap), Signed int (XOR Sign-Bit), IEEE 754 (Klassifikation + Re-Ranking), Strings (ICU UCA), Null (eigener Rank), Compound (Konkatenation).

---

## 8. Concurrency (im Originalpaper NICHT geloest!)

> "In the future, we intend to work on synchronizing concurrent updates. In particular, we plan to develop a latch-free synchronization scheme using atomic primitives like compare-and-swap." (P01:S.12/1274-1277)

→ Geloest in P08 "ART of Practical Synchronization" (2016) mit OLC + ROWEX.

---

## 9. Performance-Beobachtungen

### Single-Threaded Lookup, 65K vs 16M Keys (P01:S.8/909-985)

| Metrik | ART (dense) | ART (sparse) | FAST | Hashtable |
|---|---|---|---|---|
| Cycles/Lookup (65K) | 40 | 105 | 94 | 44 |
| Cycles/Lookup (16M) | 188 | 352 | 461 | 191 |
| Misp. Branches (16M) | **0.0** | 0.84 | 0.0 | 0.25 |
| L3 Misses/Lookup (16M) | **1.2** | 2.6 | 2.4 | 2.4 |

**Wichtig:** ART hat **0 Branch Mispredictions bei dense Keys** — zentraler PRT-ART-Argumentationspunkt fuer "weniger Branch-Kosten".

> "With dense keys, ART causes only half as many cache misses because its compact nodes can be cached effectively." (P01:S.9/962-964)

PRT-ART-Konsequenz: **Dichte vs Sparse ist eine messbare Unterscheidung, die der Cache-Engine-Wahl zugrunde liegen muss.**

---

## 10. Identifizierte gemeinsame Konzepte mit anderen Papern

| Konzept (PRT-ART KANON) | ART-Begriff | Andere Paper |
|---|---|---|
| Knoten / Inner Node | Inner Node | HOT (P02) "Node", Masstree (P03) "Internal Node", B²-tree (P06) "Decision/Span Node" |
| Span (Bits/Knoten) | span `s` | START (P05) variiert es; HOT nutzt diskriminierende Bits |
| Adaptive Knotentypen | adaptive nodes | START multilevel; B-Trees Are Back adaptive layout |
| Pfadkompression | path compression | Patricia (HOT P02), CoCo-trie macro-nodes (P04), Wormhole anchors (P07) |
| Lazy Expansion | lazy expansion | (Eigene ART-Erfindung) |
| Binary-comparable Keys | binary-comparable | (allgemein in DBMS, Graefe Survey P15) |
| Combined pointer/value slot | combined slot | PRT-ART ValueHandle::Inline |

---

## 11. PRT-ART-Bezug (geschaerft nach Volltext-Lektuere)

| ART-Konzept | PRT-ART-Bezug |
|---|---|
| Node256 | **= Dense-Byte-Page** (KANON) |
| Node48 | optionale 4. Variante zwischen Dense und Sparse |
| Node16 mit SSE | optional fuer mittel-sparse, falls SIMD verfuegbar |
| Node4 simple loop | **NICHT** PRT-ART nutzt Sparse Patricia Page (HOT-inspiriert) |
| Path Compression | **= Redirect-Page** (PRT-ART) |
| Lazy Expansion | konzeptionell uebernommen, aber explizit als Cache-Engine-Policy |
| Span = 8 Bit | PRT-ART **fest auf Byte-Niveau** (Termin 1: "256-Fanout") |
| Combined pointer/value slot | **= ValueHandle** (Inline vs External) |
| KEINE Cache-Engine | **PRT-ART Forschungsbeitrag** |
| KEINE Plattform-Kalibrierung | **PRT-ART Forschungsbeitrag** (Cache-Engine Modus 2/3) |

**Kernanschluss:** ART ist die **Pflichtbaseline**. PRT-ART nimmt ART's Knotentypwahl als **eine Achse**, separiert die Wahl in eine **Cache-Engine** (was ART nicht hat).
