# P02 — HOT (Height Optimized Trie)

**Voller Titel:** HOT: A Height Optimized Trie Index for Main-Memory Database Systems
**Autoren:** Robert Binna, Eva Zangerle, Martin Pichl, Guenther Specht (U. Innsbruck), Viktor Leis (TUM)
**Venue:** SIGMOD 2018
**Volltext:** `_text/P02-HOT-Binna2018.txt` (14 Seiten, 77 KB)

## 1. Konzeptionelle Identitaet

HOT ist ein **k-constrained Trie** mit **adaptivem Span pro Knoten**. Loest das Sparsity-Problem von Tries mit fixem Span (wie ART s=8) durch dynamische Anpassung der **diskriminierenden Bits** pro Knoten.

> "HOT combines multiple nodes of a binary Patricia trie into compound nodes having a maximum node fanout of a predefined value k such that the height of the resulting structure is optimized." (P02:S.3/228-230)

## 2. Strukturelle Bausteine (Originalterminologie)

| Begriff | Bedeutung |
|---|---|
| **Compound Node** | Container fuer bis zu k-1 BiNodes + bis zu k Leaves/Pointer |
| **BiNode** | Binary Patricia Trie Node innerhalb eines Compound Node |
| **k** | Max Fanout pro Compound Node (Default k=32) |
| **Discriminative Bit** | Bit, an dem sich Schluessel im Subtree unterscheiden |
| **Sparse Partial Key** | Nur die Bits, die zu BiNodes auf dem Pfad gehoeren (sonst 0) |
| **Dense Partial Key** | Alle diskriminierenden Bits konkateniert (Alternative) |

### 9 Physical Node Layouts (P02:Fig.6/S.7)

- **Single-mask (3 Varianten)**: 8-bit offset + 64-bit mask + Partial Keys (8/16/32 bit)
- **Multi-mask 8/16/32 (6 Varianten)**: mehrere Byte-Offsets + 8-bit masks + Partial Keys
- Groessen: 64-472 Bytes je nach Layout

Header pro Node: Hoehe `h`, Bit-Maske der genutzten Eintraege, Lock.

## 3. Algorithmen

### Insertion (4 Faelle, P02:Listing 1/S.8)

| Fall | Wann | Wie |
|---|---|---|
| **Normal Insert** | Affected Node hat < k Eintraege | Lokal neuen BiNode hinzufuegen |
| **Leaf-Node Pushdown** | Mismatching BiNode ist Leaf, Inner-Node h(n) > 1 | Leaf durch neuen Compound-Node ersetzen |
| **Parent Pull-Up** | Overflow + h(n)+1 = h(parent) | Root-BiNode in Parent verschieben (rekursiv!) |
| **Intermediate Node Creation** | Overflow + h(n)+1 < h(parent) | Root-BiNode in neuen Intermediate-Node verschieben |

> "Similar to a B-tree, the overall height of HOT only increases when a new root node is created." (P02:S.5/520)

### Lookup mit PEXT + AVX2

`retrieveResultCandidates` macht 2 Schritte:
1. **PEXT** (BMI2): Extrahiere diskriminierende Bits aus Search-Key (`_pext_u64`)
2. **AVX2-SIMD** parallel-Vergleich aller Partial Keys (`_mm256_*`) — **32 Vergleiche in 1 Instruktion**

### Optimierungen
- **Prefetch first 4 cache lines** beim Knoten-Eintritt
- **Node-Type in least-significant Pointer Bits** (Tagged Pointer)

## 4. Synchronization (ROWEX, P02:Sec.5)

> "Although the combination of copy-on-write and CAS is not enough to synchronize HOT, it is a perfect fit for the **Read-Optimized Write EXclusion (ROWEX)** synchronization strategy" (P02:S.8/1052-1054)

5-Schritt-Protokoll: (1) Affected Nodes sammeln → (2) Lock bottom-up → (3) Validate (Restart bei obsolet) → (4) Insert + alte Knoten als obsolete markieren (Copy-on-Write) → (5) Unlock top-down.

**Memory Reclamation:** Epoch-based (verbindet zu RCU/Hazard Pointers, P29/P30).

## 5. Komplexitaet und Speicher

**Space (Evaluation P02:S.11/Fig.9):** HOT 11.4-14.4 Bytes/Key konstant uber alle Datensaetze (vs ART 8-100+ Bytes/Key). HOT ist 2-3x speicher-effizienter als ART/Masstree bei langen Strings.

## 6. Plattform-Annahmen

- **AVX2** (Intel/AMD) — kritisch fuer SIMD-Search
- **BMI2** (PEXT/PDEP) — kritisch fuer Bit-Extraktion!
- C++14 + GCC 7.2

## 7. PRT-ART-Bezug (geschaerft)

| HOT-Konzept | PRT-ART-Bezug |
|---|---|
| **Compound Node** | Konzeptionell aequivalent zu PRT-ART **Sparse Patricia Page** |
| **BiNode** | Interne Patricia-Subknoten innerhalb einer Sparse Patricia Page |
| **k=32 max Fanout** | PRT-ART nutzt 256-Fanout — Tradeoff anders gewaehlt |
| **Discriminative Bits + variable Span** | NICHT in PRT-ART (PRT-ART nutzt feste Byte-Granularitaet) |
| **Sparse Partial Keys** | Konzeptionell verwandt zu PRT-ART **Probability Hints** im Header |
| **9 Layouts adaptiv** | **Vorbild fuer Page-Type-Selection Rule der Cache-Engine** |
| **PEXT/PDEP/AVX2** | Plattformabhaengig — bei PRT-ART **Cache-Engine entscheidet** ob aktiviert |
| **ROWEX Synchronization** | **Direkt uebernahmebar** in PRT-ART Cache-Engine |
| **Copy-on-Write + Epoch Reclamation** | Verbindet zu RCU (P29) und Hazard Pointers (P30) |

## 8. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **HOT Compound Node ↔ B²-Tree Page mit Decision/Span Nodes**: kapseln interne Such-Struktur als Cache-Einheit
- **HOT ROWEX ↔ ART OLC (P08) ↔ RCU (P29)**: drei verwandte Lock-free/Optimistic-Sync-Strategien
- **HOT 9 adaptive Layouts ↔ B-Trees Are Back (P20) 6 Optimierungen**: beide Layout-Familien zur Runtime-Wahl
- **HOT Sparse Partial Keys ↔ SuRF (P10) LOUDS-Sparse**: minimieren Speicher durch nur diskriminierende Info

## 9. Kernanschluss fuer PRT-ART

PRT-ART **Sparse Patricia Page** ist konzeptionell genau eine HOT Compound Node. Die wichtigste Erkenntnis: **HOT hat 9 Layouts, die Wahl haengt von Datenverteilung ab**. Genau diese Wahl gehoert in PRT-ART NICHT in die Page selbst, sondern in die **Cache-Engine** (= Hauptbeitrag PRT-ART).
