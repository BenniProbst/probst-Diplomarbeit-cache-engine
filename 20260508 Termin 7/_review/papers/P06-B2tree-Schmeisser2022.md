# P06 — B²-Tree (Page-Based String Indexing)

**Voller Titel:** B2-Tree: Page-Based String Indexing in Concurrent Environments
**Autoren:** Josef Schmeisser, Maximilian Schuele, Viktor Leis (FAU), Thomas Neumann, Alfons Kemper (TUM)
**Venue:** Datenbank Spektrum 22:11-22 (2022)
**Volltext:** `_text/P06-B2tree-Schmeisser2022.txt` (12 Seiten, 57 KB)

## 1. Konzeptionelle Identitaet

B²-Tree ist ein **B+-Tree** mit **eingebetteter trie-aehnlicher Suchstruktur pro Page** ("embedded tree"). Designed fuer **Umbra Buffer Manager** (variable-sized pages, min 64 KiB).

> "B²-tree is composed of multiple trees, each page integrates another trie-based search tree, which is used to determine a small memory region where a sought entry may be found." (P06:S.1/19-22)

**Klasse:** Hybrid B+-Tree (outer) + Trie (inner-per-page)
**Zielsystem:** Umbra (variable-sized pages mit 64 KiB Minimum)

## 2. Strukturelle Bausteine

### 2.1 Outer-Layer (P06:Sec.3.1)

- Standard B+-Tree Struktur
- Page mit dense Array (sortiert nach Schluessel)
- Doubly-linked Leaves (fuer Range-Scans)
- 64 KiB Pages (Umbra-Default)

### 2.2 Inner-Layer pro Page: Embedded Tree (P06:Sec.3.1)

| Knoten-Typ | Bedeutung |
|---|---|
| **Decision Node** | "Acts like a B-tree node by directing incoming queries onto the corresponding child" — operiert auf einem Byte zur Zeit (P06:S.3/250) |
| **Span Node** | "Stores the byte sequence which forms the longest common prefix found in the subtree rooted at the current node" (P06:S.4/284-285) |
| **Virtual Node / Edge** | Implizite Eckknoten fuer "input shorter/greater than span" (P06:S.4/311) |
| **Range Array** | Translation: embedded-tree-Output → physical position auf Page |

### 2.3 Inner-Tree Layout

> "Each node contains a one byte large header. A flag inside the header determines whether a node contains pointers to subtrees or references to search ranges" (P06:Fig.3/S.4)

Decision Node = ~15 Bytes (1 Byte Header + Pointer-Array)
Span Node = variable (mit byte-Sequenz)

### 2.4 Konstruktion (P06:Sec.3.1.1)

> "The construction routine always starts by determining the longest common prefix of the given range of entries beginning at the very first byte of each entry." (P06:S.5/378-381)

Rekursiv: bei longest-common-prefix > 0 → Span Node erzeugen, sonst Decision Node.
Rekursionsabbruch: Subrange < threshold (default ~32 Eintraege).

## 3. Algorithmen

### 3.1 Lookup (P06:Sec.3.2)

1. Embedded Tree liefert (search_range, skip)
2. skip = Laenge des largest common prefix → Suffix-Vergleich reicht
3. Binary Search auf limited subrange in der Page

### 3.2 Insert / Delete (P06:Sec.3.3-3.4)

- Range Array wird angepasst (kein Rebuild des Embedded Trees!)
- Page-Split: kompletter Rebuild des Embedded Trees (auf beiden neuen Pages)

### 3.3 Worst-Case Space Analysis (P06:Sec.3.5)

Aehnlich wie ART: budget b(n) ≤ x fuer alle n.
Konstante x = 15 Bytes (1 Decision Node + 1 Empty Span).
Bei 32 Eintraegen pro Subrange: Embedded Tree < 0.5% der Page-Groesse.

## 4. Concurrency (OLC, P06:Sec.3.6)

> "Optimistic Lock Coupling (OLC)" (P06:S.2/142, Sec.3.6)

**Wichtige B²-Tree-spezifische Sicherheit:**
> "Span nodes can contain arbitrary byte sequences. It is hence possible to construct a key containing a byte sequence that resembles a valid node. Such a node may also contain links pointing to itself." (P06:S.8/696-700)

Schutz:
- Parent < alle Children (Adressordnung)
- Validation: Pointer muss innerhalb der Page liegen
- Search-Range Boundary muss innerhalb der Page liegen

## 5. PRT-ART-Bezug (geschaerft)

| B²-Tree-Konzept | PRT-ART-Bezug |
|---|---|
| **Embedded Tree pro Page** | **DIREKT = PRT-ART Custom Cache Page** (page-lokale Suche!) |
| **Decision Node** | konzeptionell PRT-ART Sparse Patricia Page |
| **Span Node** | **konzeptionell = PRT-ART Redirect-Page** (longest common prefix kondensiert) |
| **Virtual Node/Edge** | NICHT in PRT-ART (PRT-ART macht keine Padded-Comparison) |
| **Range Array** | nicht direkt — PRT-ART hat keine Outer-B+-Layer-Indirektion |
| **OLC Concurrency** | direkt uebernehmbar in PRT-ART |
| **Embedded Tree Rebuild bei Split** | NICHT in PRT-ART — PRT-ART hat per-Knoten-lokale Strukturen |
| **Page-lokale Sucheinengung** | **HAUPT-INSPIRATION** fuer PRT-ART Custom Cache Page |

## 6. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **B²-Tree Decision/Span Node ↔ HOT Compound Node mit BiNodes ↔ ART Node48/256 + Path Compression**: drei Strategien fuer "viele Trie-Ebenen kompakt in einer Cache-Region"
- **B²-Tree Range Array ↔ Masstree Permutation Field**: Indirektion zwischen logischer Ordnung und physischer Position
- **B²-Tree OLC ↔ HOT ROWEX ↔ ART of Practical Sync (P08) OLC**: drei OCC-Familien
- **B²-Tree Span Node ↔ CoCo-Trie Macro-Node ↔ ART Path Compression**: drei Strategien fuer Praefixkollabierung

## 7. Kernanschluss fuer PRT-ART

B²-Tree ist die **direkte Inspiration** fuer PRT-ART **Custom Cache Page**: page-lokale Such-Einengung mit eigener Mini-Trie-Struktur. PRT-ART nimmt die "Embedded Tree pro Page"-Idee, aber:
- Statt Outer-B+-Tree → PRT-ART Trie-Huelle
- Statt fester Decision/Span → PRT-ART konfigurierbare Page-Type-Familie (Cache-Engine)
- Range Array nicht zwingend (PRT-ART hat ValueHandle direkt)
