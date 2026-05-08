# P09 — Jacobson 1989 (LOUDS Original)

**Voller Titel:** Space-efficient Static Trees and Graphs
**Autor:** Guy Jacobson (Carnegie Mellon University)
**Venue:** FOCS 1989, IEEE CH2806-8/89, pages 549-554
**Volltext:** `_text/P09-Jacobson1989-LOUDS.txt` (6 Seiten — Text NICHT extrahierbar, scanned image PDF)
**Provenienz:** SLUB Dresden via IEEE Xplore, 2026-05-02 (HABICH-Zusatz!)

> **Hinweis:** Volltext-Extraktion via pypdf nicht moeglich (PDF ist gescanntes Bild). Inhalt aus visueller Lektuere der ersten Sitzung + Sekundaerliteratur (insb. SuRF P10 referenziert dieses Paper).

## 1. Konzeptionelle Identitaet

Jacobson 1989 ist die **Originalpublikation der Succinct Tree-Encodings**:
- **LOUDS** (Level-Ordered Unary Degree Sequence)
- Asymptotisch optimaler Speicher: **2n + o(n) bits** fuer einen Binary Tree mit n Knoten
- O(1) Navigation via **rank/select** Operationen ueber Bit-Strings

> "These structures are more space-efficient than conventional pointer-based representations, but (to within a constant factor) they are just as time-efficient for traversal operations." (Jacobson 1989, Abstract)

**Klasse:** Information-theoretical Lower Bound fuer statische Trees + Graphs
**Wichtig:** STATIC ONLY. Updates nicht effizient moeglich.

## 2. Zentrale Konzepte

### 2.1 Repraesentationen fuer Binary Trees (Jacobson Sec.3)

**Level-order binary marked (LOBM)**: Bit-String der Form `1...1 0 0` fuer jeden Knoten:
- `1` Bits = interne Knoten
- `0` Bits = externe (NULL-)Knoten
- Total: 2n+1 Bits fuer Binary Tree mit n Internal Nodes

> "Each such bit string is associated with a unique tree." (Jacobson 1989, S.550)

### 2.2 LOUDS (Level-Ordered Unary Degree Sequence)

Fuer general (non-binary) Trees:
- Pro Knoten: `1^d 0` (d = degree)
- Total: ~2n Bits fuer Tree mit n Knoten

```
Tree:    super-root  →  3 children  →  3 grandchildren each
LOUDS:   1   1110   1110 0 10 110 0 0
         ^   ^      ^   level-order bytes
         super 3 chld of root, etc.
```

(Aus Bild Page 3 der ersten Lektuere, Figure 3 "Level-order unary degree sequence representation")

### 2.3 Navigation via rank/select (Jacobson Sec.2)

> "rank(m) Counts the number of elements in S less than or equal to m."
> "select(m) Finds the mth smallest element in S."

**Beide Operationen O(1)** mit Auxiliary Tables (Tarjan/Yao 1979 Idee, "directories"):
- O(n / log n / log n) Bits Zusatz-Speicher fuer rank/select-Tables
- Total: 2n + o(n) Bits fuer LOUDS Tree

### 2.4 Tree Navigation Operationen (Jacobson Sec.3.1+3.2)

| Operation | Implementierung |
|---|---|
| `parent(m)` | `select1(rank0(m))` |
| `first_child(m)` | `select0(rank1(m)) + 1` |
| `next_sibling(m)` | `m + 1` |
| `null(m)` | `m`-tes Bit ist `0`? |

→ **Alle in O(1)** dank rank/select.

## 3. Plattform-Annahmen

- 1989 — Pre-Cache-Era CPU
- KEIN Cache-Modell, KEINE Cache-Lines
- KEIN SIMD
- Verbal verbundene Konzepte: Tarjan/Yao [7] (rank/select directories)

**Aber:** Die Bit-Compactness ist **inhaerent cache-friendly**, weil 2 Bits/Knoten in moderne Cache-Lines viele Knoten unterbringen.

## 4. PRT-ART-Bezug (HABICH-Zusatz, sehr wichtig!)

| Jacobson-Konzept | PRT-ART-Bezug |
|---|---|
| **LOUDS Bit-String Encoding** | **OPTIONAL fuer PRT-ART Dense-Byte-Page** als succinct Variante |
| **Level-Order Layout** | konzeptionell BFS-aequivalent zu PRT-ART Page-Layout |
| **rank/select** | OPTIONAL als Lookup-Mechanismus innerhalb succinct Pages |
| **Static-only** | **GROSSER UNTERSCHIED zu PRT-ART** — PRT-ART braucht Updates! |
| **2n + o(n) Bits** | Information-theoretische Untergrenze, die PRT-ART als Vergleich nutzen kann |

**Wichtige Konsequenz:** PRT-ART kann LOUDS NICHT direkt uebernehmen, weil LOUDS keine effizienten Updates erlaubt. Aber:
- LOUDS-Encoding kann als **alternative Page-Variante** fuer **statische Subtries** verwendet werden (z.B. read-only "kalte" Pages, die selten modifiziert werden)
- Cache-Engine koennte entscheiden: "Diese Subtrie wurde lange nicht geaendert → konvertiere zu LOUDS-Encoding fuer maximale Cache-Lokalitaet"

**Das ist eine moegliche Zusatz-Optimierung der PRT-ART Cache-Engine, die direkt mit Habich's Hinweis auf LOUDS verbunden ist.**

## 5. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **Jacobson LOUDS ↔ SuRF FST/LOUDS-Sparse (P10)**: SuRF baut DIREKT auf Jacobson auf
- **Jacobson rank/select ↔ Wormhole Bitmap (P07)**: beide nutzen Bit-Operationen fuer O(1) Navigation
- **Jacobson Static Tree ↔ B-Trees Are Back semi-/fully-dense Leaves (P20)**: beide haben Compact-Read-Optimized Layouts
- **Jacobson 2n + o(n) Bits ↔ Information-theoretical Lower Bound** (allgemein)

## 6. Kernanschluss fuer PRT-ART

Jacobson 1989 ist die **theoretische Basis** der gesamten **Succinct Tree-Familie** (CoCo-trie P04, SuRF P10). Die wichtigste Erkenntnis fuer PRT-ART: **Bit-Granularitaet ist optimal cache-friendly**. PRT-ART nutzt aber Byte-Granularitaet (256-Fanout), weil:
- Updates effizienter
- Direkte Adressierung ohne rank/select-Overhead
- Bessere Compiler-Optimierung (kein Bit-Shifting in Hot Loops)

LOUDS bleibt als **Fallback-Page-Variante** in der Cache-Engine-Familie eine Option fuer statisch-bleibende Subtries.

## 7. Naechster Schritt fuer Vertiefung

Falls LOUDS in PRT-ART als optionale succinct Page realisiert wird, brauchen wir:
- SDSL-Library oder eigene rank/select-Implementierung
- Konversionspfad "byte-page → louds-page" in der Cache-Engine
- Erkennungsregel: "wann ist ein Subtree static genug, dass louds sich lohnt?"
