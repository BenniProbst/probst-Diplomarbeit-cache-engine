# P17 — Cache-Oblivious B-Trees (Bender/Demaine/Farach-Colton 2005)

**Voller Titel:** Cache-Oblivious B-Trees
**Autoren:** Michael A. Bender, Erik D. Demaine, Martin Farach-Colton (Stony Brook + MIT + Rutgers)
**Venue:** SIAM J. on Computing 2005 (preliminary version FOCS 2000)
**Volltext:** `_text/P17-BenderCacheObliv2005.txt` (18 Seiten, 67 KB)

## 1. Konzeptionelle Identitaet

**Konzeptioneller Gegenpol** zu PRT-ART. Dynamische Suchstruktur mit **Theta(1 + log_{B+1} N)** Memory-Transfers, **OHNE** Kenntnis von Block-Size B oder Memory-Hierarchie-Parametern.

> "The data structures are independent of the parameters of the memory hierarchy, e.g., the number of memory levels, the block-transfer size at each level, and the relative speeds of memory levels." (P17:S.1/9-12)

**Klasse:** Cache-OBLIVIOUS (NICHT cache-aware!) Suchbaum
**Hauptbeitrag:** Erste dynamische Cache-Oblivious-Datenstruktur

## 2. Hauptbausteine

| Konzept | Bedeutung |
|---|---|
| **Ideal-Cache Model** (Frigo/Prokop) | 2-Level-Cache mit unbekanntem B + M, optimal Replacement |
| **van Emde Boas Layout** | Rekursives split: top tree (h/2) + bottom trees (h/2) — recursive linearisiert |
| **Packed-Memory Array** | Ordnete Datenstruktur in Array-Slot mit Luecken; Updates mit O(1 + log²N/B) Transfers |
| **Strongly Weight-Balanced** | Tree-Variant fuer Locality-Erhaltung |

## 3. Performance-Bounds

### Search Tree 1
- Search: O(1 + log_{B+1} N) — optimal
- Update: O(1 + log_{B+1} N) amortized

### Search Tree 2 (mit Scan)
- Search: O(1 + log_{B+1} N)
- Scan(S): O(1 + S/B) — optimal
- Update: O(1 + log_{B+1} N + log²N/B) amortized

## 4. PRT-ART-Bezug (KONZEPTIONELLER GEGENPOL!)

| Bender-Konzept | PRT-ART-Bezug |
|---|---|
| **Cache-OBLIVIOUS** | **EXPLIZITER GEGENPOL zu PRT-ART** (cache-aware) |
| **van Emde Boas Layout** | NICHT in PRT-ART — PRT-ART nutzt Trie-Struktur |
| **Ideal-Cache Model** | NICHT in PRT-ART — PRT-ART misst echte Hardware |
| **Packed-Memory Array** | konzeptionell verwandt zu START Rewired Nodes (P05) |
| **Multi-Level autom. via Recursion** | PRT-ART erreicht das via Cache-Engine-Wahl explizit |

## 5. Kernanschluss fuer PRT-ART (Argumentationsbasis)

Bender et al. ist **die wichtigste Vergleichsbasis fuer die Argumentation "warum cache-aware?"**:

1. **Cache-Oblivious-Vorteil:** Funktioniert auf jedem Memory-Hierarchie-Setup automatisch
2. **Cache-Oblivious-Nachteil:** **Konstanter Faktor schlechter** als optimal cache-aware

PRT-ART argumentiert (Termin 5 explizit):
> "PRT-ART verfolgt explizit nicht diese [cache-oblivious] Linie. Die Arbeit soll gerade zeigen, dass aktive, plattformbewusste Cache-Entscheidungen gegenueber rein hierarchieunabhaengigen Strukturen zusaetzlichen Nutzen bringen koennen."

Bender et al. liefert das **theoretische "Worst-Case-Cache-Oblivious"-Limit**, gegen das PRT-ART seine **gemessene Cache-Awareness-Verbesserung** beweisen muss.

## 6. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **Bender Cache-Oblivious ↔ PRT-ART Cache-Aware**: konzeptionelle Gegensaetze
- **Bender van Emde Boas ↔ Bender Tree Layout greedy (P16)**: gleiche Autoren, anderes Ziel (cache-oblivious vs probability-driven)
- **Bender Packed-Memory Array ↔ START Rewired Nodes (P05) ↔ Saikkonen Multi-Level Layout (P18)**: drei Strategien fuer "Sparse Memory mit Updates"
