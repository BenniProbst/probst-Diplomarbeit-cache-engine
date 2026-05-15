# P07 — Wormhole (Hash + Trie + B+-Tree Hybrid)

**Voller Titel:** Wormhole: A Fast Ordered Index for In-memory Data Management
**Autoren:** Xingbo Wu (UIC), Fan Ni, Song Jiang (UT Arlington)
**Venue:** EuroSys 2019, Dresden, Germany
**Volltext:** `_text/P07-Wormhole-Wu2019.txt` (16 Seiten, 84 KB)

## 1. Konzeptionelle Identitaet

Wormhole ist ein **Hybrid aus Hash Table + Trie + B+-Tree** mit **O(log L) Lookup-Kosten** (L = Schluessellaenge), nicht O(log N).

> "Wormhole has a lookup cost of O(log L) memory accesses, where L is the length of search key (actual number of accesses can be (much) smaller than log_2 L). With a reasonably bounded key length (e.g., 1000 bytes), the cost can be considered as O(1)" (P07:S.2/146-150)

**Klasse:** Hybrid Multi-Index Ordered Structure
**Performance:** Bis zu 8.4× schneller als Skip List, 4.9× B+, 4.3× ART, 6.6× Masstree

## 2. Strukturelle Bausteine (Drei-Schichten-Aufbau)

### 2.1 LeafList (untere Schicht)
- Doubly linked Liste aller Leaf-Nodes (sortiert nach Schluessel)
- Jeder Leaf-Node = B+-Tree-aehnlich, dense Array
- Range-Operations via linearen Scan auf LeafList

### 2.2 MetaTrie (mittlere Schicht — konzeptionell)
- Jeder Leaf-Node hat einen **Anchor Key**
- Anchor Key serviert als Borderline zwischen Nodes
- **Anchor Key Bedingungen** (P07:S.3/297-309):
  - **Ordering Condition**: left-key < anchor-key ≤ node-key
  - **Prefix Condition**: Kein Anchor darf Praefix eines anderen Anchors sein
- Anchor Keys werden in MetaTrie eingefuegt (zusammen mit ihren Praefixen als Internal Nodes)

### 2.3 MetaTrieHT (Schluessel-Innovation, P07:S.5/Sec.2.4)

> "We insert all prefixes of each anchor into a hash table." (P07:S.5/521-522)

**Hash Table mit allen Praefixen aller Anchor Keys**.
Lookup-Algorithm: **Binary Search auf Prefix-Laengen** (Algorithm 1, P07:S.5/499-507):

```
function searchLPM(search_key, Lanc, Lkey):
    m, n = 0, min(Lanc, Lkey) + 1
    while m+1 < n:
        prefix_len = (m+n) / 2
        if search_key[0:prefix_len-1] in trie:
            m = prefix_len
        else: n = prefix_len
    return search_key[0:m-1]
```

→ **O(log L)** statt O(L) fuer LPM-Suche.

### 2.4 Hash Item Layout (P07:S.6/542-549)

| Feld | Bedeutung |
|---|---|
| Type | I (Internal) oder L (Leaf) |
| **Bitmap** | Bit pro moegliches Kind im Trie (256 Bits fuer Bytes) |
| **Left-most Leaf Pointer** | Pointer zum linken Leaf des Subtrees |
| **Right-most Leaf Pointer** | Pointer zum rechten Leaf des Subtrees |

→ Bitmap erlaubt **O(1) Sibling-Lookup**!
→ Pointers erlauben **O(1) Subtree-Boundary** ohne Walk!

## 3. Lookup-Algorithmus (zwei Phasen)

### Phase 1: LPM via Hash + Binary Search auf Prefix-Laengen (O(log L))

→ Findet laengsten Praefix der Search-Key in der Trie ist.

### Phase 2: Falls LPM = Anchor → Target Node direkt; sonst Sibling-Walk (O(1))

> "With the bitmap, sibling(s) of an unmatched token can be located in O(1) time." (P07:S.6/549-551)

Subtree-Boundary direkt via Right-most/Left-most Leaf Pointers → O(1).

**Total: O(log L) Memory Accesses** statt O(log N).

## 4. Komplexitaet

| Operation | Komplexitaet | Vergleich |
|---|---|---|
| Lookup | **O(log L)** | B+ O(log N), ART O(L), Trie O(L) |
| Insert | O(log L) + Leaf-Split-Cost | wie Lookup + amortisiert |
| Delete | O(log L) + Leaf-Merge-Cost | wie Insert |
| Range Scan | O(log L) initial + O(R) (linear scan) | wie B+ |

**Space:** Vergleichbar mit B+ (Anchors meist viel kuerzer als Keys).

## 5. PRT-ART-Bezug (geschaerft)

| Wormhole-Konzept | PRT-ART-Bezug |
|---|---|
| **MetaTrie** | konzeptionell verwandt zu PRT-ART **Trie-Huelle** |
| **Anchor Key** | **DIREKT vergleichbar mit PRT-ART Redirect-Key** |
| **MetaTrieHT (Hash + Praefixe)** | NICHT in PRT-ART (PRT-ART hat keinen Hash-Index) |
| **LeafList (B+-aehnlich)** | NICHT in PRT-ART (PRT-ART hat eigene Pages, keine globale Sortierung) |
| **Bitmap pro Internal** | konzeptionell vergleichbar mit PRT-ART **Probability Hints** |
| **Left-most/Right-most Leaf Pointers** | NICHT in PRT-ART direkt — koennten als Cache-Engine-Optimierung uebernommen werden |
| **Binary Search auf Prefix-Laengen** | NICHT in PRT-ART (kostet Hash-Lookups) |
| **O(log L) Lookup** | PRT-ART hat O(L) (wie ART) — Wormhole ist hier deutlich schneller |

## 6. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **Wormhole Anchor Key ↔ CoCo-Trie Macro-Node ↔ ART Path Compression**: drei Strategien fuer "lange Praefixe in einem Sprung"
- **Wormhole MetaTrieHT ↔ Hash-basierte Lookup-Beschleunigung allgemein**: HashTable als Index ueber Index-Strukturen
- **Wormhole Bitmap pro Internal ↔ HOT Bit-Mask Header ↔ SuRF LOUDS-Bitmaps**: drei kompakte Repraesentationen
- **Wormhole LeafList doubly linked ↔ B+-Tree Leaf-Linking ↔ B²-Tree Outer-B+-Layer**: linker Range-Scan-Pattern

## 7. Kernanschluss fuer PRT-ART

Wormhole zeigt, dass **O(log L) Lookup machbar ist** durch geschickten Einsatz von Hash + Binary Search auf Prefix-Laengen. PRT-ART verwendet **NICHT** diesen Hybrid — bleibt bei O(L) Trie-Lookup. Aber: Die **Idee, dass Anchor-Pointers ueber lange Praefixe springen** ist genau die PRT-ART **Redirect-Page**. Die Bitmap-pro-Internal-Knoten ist ein Vorbild fuer Cache-Engine-Telemetrie.

**Wichtig:** Wormhole-Komplexitaet O(log L) ist wegen der HashTable. PRT-ART verzichtet bewusst auf Hash, um:
- Sortierte Reihenfolge zu erhalten
- Prefix Enumeration ohne Hash-Indirection zu erlauben
- Update-Kosten niedrig zu halten (HashTable-Updates sind teurer)
