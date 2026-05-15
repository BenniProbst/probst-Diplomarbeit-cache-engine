# P03 — Masstree (Trie of B+-Trees)

**Voller Titel:** Cache Craftiness for Fast Multicore Key-Value Storage
**Autoren:** Yandong Mao, Eddie Kohler (Harvard), Robert Morris (MIT CSAIL)
**Venue:** EuroSys 2012
**Volltext:** `_text/P03-Masstree-Mao2012.txt` (15 Seiten, 74 KB)

## 1. Konzeptionelle Identitaet

Masstree ist ein **Trie mit Fanout 2^64**, wobei **jeder Trie-Knoten selbst ein B+-Tree** ist. Indexiert variable-length Keys ueber **8-Byte-Slices**.

> "Our key data structure is Masstree, a shared-memory, concurrent-access data structure combining aspects of B+-trees and tries." (P03:S.4/204-206)

**Klasse:** Trie-of-B+-Trees Hybrid mit OCC-Concurrency
**Drei Designherausforderungen** (P03:S.4/210-217):
1. Variable-length binary keys mit langen common prefixes
2. Fine-grained concurrent access — Get OPS duerfen NIE shared cache lines dirty machen
3. Layout muss Prefetching unterstuetzen + wichtige Info auf wenige Cache-Lines

## 2. Strukturelle Bausteine (Originalterminologie)

### 2.1 Layer-Struktur

> "A Masstree comprises one or more **layers** of B+-trees, where each layer is indexed by a different 8-byte **slice** of key. The trie's single root tree, layer 0, is indexed by the slice comprising key bytes 0–7" (P03:S.4/227-231)

| Layer | Indexiert Bytes |
|---|---|
| Layer 0 | 0-7 |
| Layer 1 | 8-15 |
| Layer 2 | 16-23 |
| ... | ... |

### 2.2 Knoten-Typen

| Typ | Bedeutung |
|---|---|
| **Interior Node** | Internal Node eines B+-Trees, enthaelt nur Slices + Child-Pointer |
| **Border Node** | Leaf-Node-aehnlich: enthaelt Slices + Lengths + Permutation + Values ODER Pointer zu naechster Layer |

### 2.3 Drei Invarianten (P03:S.4/240-245)

1. Keys kuerzer als 8h+8 bytes sind in Layer ≤ h gespeichert
2. Alle Keys in Layer-h Tree haben den gleichen 8h-byte Praefix
3. Wenn 2 Keys einen Praefix teilen, sind sie min. so tief gespeichert wie der Praefix

### 2.4 Border-Node Layout (P03:Fig.2/S.5)

```c
struct border_node {
    uint32_t version;                // siehe 4.1
    uint8_t  nremoved;
    uint8_t  keylen[15];             // Laenge pro Key
    uint64_t permutation;            // ATOMARE Permutation der Slots!
    uint64_t keyslice[15];           // 8-byte Slices als int64 (byte-swapped!)
    link_or_value lv[15];            // Value ODER Pointer zur naechsten Layer
    border_node* next, * prev;       // Doubly-linked fuer Range-Scans
    interior_node* parent;
    keysuffix_t keysuffixes;         // Adaptive Inline/External Allokation
};
```

**Width 15 chosen** weil Knoten = **256 Bytes = 4 Cache-Lines** (P03:S.5/356-359).

## 3. Schluessel-Innovationen

### 3.1 Key Slices als 64-bit integer

> "The keyslice variables store 8-byte key slices as 64-bit integers, byte-swapped if necessary so that native less-than comparisons provide the same results as lexicographic string comparison. This was the most valuable of our coding tricks, improving performance by 13–19%." (P03:S.5/313-317)

### 3.2 Permutation Field — Atomarer Insert (P03:S.6-7/Sec.4.6.2)

64-bit Permutation:
- Lowest 4 bits: nkeys (0-15)
- 15 × 4 bits: keyindex[15] = permutation of indexes

> "Writers expose a new sort order and a new key with a single aligned write. Readers see either the old order, without the new key, or the new order, with the new key in its proper place." (P03:S.6/562-566)

→ **NO key rearrangement, NO version increment** beim normalen Insert!

### 3.3 Adaptive Keysuffix (Inline vs External)

> "Border nodes store the suffixes of their keys in keysuffixes data structures. These are located either inline or in separate memory blocks; **Masstree adaptively decides** how much per-node memory to allocate for suffixes and whether to place that memory inline or externally." (P03:S.5/337-342)

**WICHTIG fuer PRT-ART**: Genau diese Inline-vs-External-Adaptivitaet ist das Konzept, das in PRT-ART als **ValueHandle::Inline** vs **ValueHandle::External** getrennt wird!

### 3.4 Prefetching aller Cache-Lines parallel

> "Masstree prefetches all of a tree node's cache lines in parallel before using the node, so the entire node can be used after a single DRAM latency." (P03:S.5/352-354)

## 4. Concurrency (OCC + Hand-over-Hand)

### 4.1 Version Counter Layout (P03:Fig.3)

| Feld | Bedeutung |
|---|---|
| locked | per-node spinlock |
| inserting | "dirty bit" — set waehrend Insert |
| splitting | "dirty bit" — set waehrend Split |
| vinsert | Counter, inkrementiert nach jedem Insert |
| vsplit | Counter, inkrementiert nach jedem Split |
| isroot | ist Root eines B+-Trees? |
| isborder | ist Border-Node? |

### 4.2 Writer-Reader Protokoll (P03:Sec.4.6)

1. Writer markiert version als "dirty" vor Aenderung
2. Writer aendert
3. Writer clears dirty + inkrementiert version counter
4. Reader snapshots version vorher
5. Reader liest
6. Reader checkt version nachher: wenn != snapshot ODER dirty → Retry

### 4.3 Hand-over-Hand Lock Acquisition

> "Lock ordering prevents deadlock: locks are always acquired up the tree." (P03:S.6/457-458)

## 5. Komplexitaet

| Operation | Komplexitaet |
|---|---|
| Lookup | O(log n) per Layer × O(L) Layers = **O(L log n)** general case |
| Lookup mit shared prefix length P | **O(L + log n)** — sehr gut! |
| Insert | O(log n) per Layer + Layer-Creation Cost |
| Range Scan | O(L) zusaetzliche Cost ueber B+-Tree wegen Layer-Wechsel |

## 6. Performance (P03:S.3/120-125)

> "Masstree achieves six to ten million operations per second on parts A–C of the [YCSB] benchmark, more than 30× as fast as VoltDB or MongoDB." (P03:S.3/121-124)

## 7. PRT-ART-Bezug (geschaerft)

| Masstree-Konzept | PRT-ART-Bezug |
|---|---|
| **Trie-of-B+-Trees** | NICHT direkt in PRT-ART — PRT-ART hat Trie-Huelle + lokale Pages, kein eingebettetes B+-Tree |
| **8-Byte Slices** | NICHT in PRT-ART (PRT-ART nutzt Byte-Granularitaet) |
| **Layer-Struktur** | Konzeptionelles Vorbild fuer **Subbaumgrenzen** in PRT-ART |
| **Border Node + Interior Node** | Verwandt zu PRT-ART **terminalem Knoten** vs interner Page |
| **Permutation Field** | **HIGHLY IMPORTANT** fuer PRT-ART: atomarer Insert in einer 64-bit-Operation. Sollte uebernommen werden |
| **Adaptive Keysuffix Inline vs External** | **DIREKT** = PRT-ART **ValueHandle::Inline / ::External** |
| **Prefetching aller Cache-Lines** | Sollte in PRT-ART Cache-Engine als Default-Policy enthalten sein |
| **Version Counter mit dirty-bits** | **Direkt uebernehmbar** in PRT-ART OCC |
| **Hand-over-Hand Locking** | **Direkt uebernehmbar** in PRT-ART (wenn Updates) |
| **Read-Copy-Update inspired** | Verbindet zu RCU (P29) |
| **Border Node next/prev (doubly linked)** | Vorbild fuer Range-Scan in PRT-ART |

## 8. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **Masstree Border Node ↔ ART Leaf Node ↔ B²-Tree Page Leaf**: Endpunkt der Suche
- **Masstree Permutation Field ↔ HOT Bit-Mask Header**: kompakte Repraesentation der gueltigen Slots
- **Masstree Layer ↔ HOT Compound Node ↔ ART Path Compression**: drei verschiedene Strategien fuer "lange Praefixe effizient handhaben"
- **Masstree Adaptive Keysuffix ↔ ART Combined pointer/value slot ↔ B-Trees Are Back Heads/Hints**: drei verwandte Inline-Optimierungen
- **Masstree OCC mit Version Counter ↔ ART OLC (P08) ↔ HOT ROWEX**: drei OCC-Familien

## 9. Kernanschluss fuer PRT-ART

Masstree ist die direkte **Inspiration fuer adaptive Inline-vs-External Wahl** (PRT-ART ValueHandle). Die **Permutation-Field-Mechanik** sollte als Implementierungsdetail in PRT-ART uebernommen werden, weil sie atomare Inserts ohne Version-Increment ermoeglicht. Die **8-Byte-Slice-Layer-Struktur ist NICHT** Teil von PRT-ART, aber das Konzept "Lange Schluessel mit gemeinsamen Praefix in Layer-Slices aufteilen" ist verwandt zu PRT-ART **Redirect-Page** + Cache-Engine-Wahl der Page-Boundary.
