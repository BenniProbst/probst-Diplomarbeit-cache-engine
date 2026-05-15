# P04 — CoCo-Trie (COmpressed COllapsed Trie)

**Voller Titel:** CoCo-trie: Data-aware compression and indexing of strings
**Autoren:** Antonio Boffa, Paolo Ferragina, Francesco Tosoni, Giorgio Vinciguerra (U. Pisa)
**Venue:** Information Systems 120 (2024) 102316 (zuvor SPIRE 2022)
**Volltext:** `_text/P04-CoCo-trie-Boffa2024.txt` (16 Seiten, 110 KB)

## 1. Konzeptionelle Identitaet

CoCo-Trie ist ein **succinct Trie** mit **datenabhaengiger Subtrie-Kollabierung** in komprimierte Macro-Nodes mit beliebiger Tiefe.

> "We introduce a new data structure, called the COmpressed COllapsed Trie (CoCo-trie), that hinges on a pool of techniques to compress subtries (of arbitrary depth) into succinctly-encoded and efficiently-searchable trie macro-nodes with a possibly large fan-out." (P04:S.1/31-34)

**Klasse:** Static Compressed Trie (kein In-place Update)
**Operationen:** rank, lookup, access, predecessor, prefix_search, longest_prefix_match

**Annahmen (wichtig!):**
> "In this paper, we assume that the set is static, which allows for considerably more space-time efficient solutions" (P04:S.1/74-77)

## 2. Strukturelle Bausteine

| Begriff | Bedeutung |
|---|---|
| **Macro-Node** v_l | Subtrie kollabiert ueber `l` Ebenen zu einem Knoten |
| **Branching Macro-Character** c_i | i-tes Edge-Label des Macro-Node (length `l`) |
| **`l`** | Anzahl kollabierter Ebenen pro Macro-Node (variable!) |
| **u** | Universe der Macro-Characters: `c_m - c_1 + 1` |
| **C(v_l)** | Space cost zur Encodierung des Macro-Nodes v_l |
| **alpha** | Parameter: relaxiert Space-Cost um groesseres `l` zu erlauben |

### 2.1 int_l Funktion (P04:S.5/596 Gl.1)

Edge-Label `s` der Laenge `l` wird zu Integer:
```
int_l(s) = sum_{i=1..l} s[i] * sigma^{l-i}
```

→ Edge-Label = ein Integer aus Alphabet Σ_l = {0, ..., sigma^l - 1}.

### 2.2 Pool von Encoding-Schemes (mehrere!)

> "We empowering the previous optimisation procedure by defining a pool of compressed encodings, thus driving the choice of the subtries to collapse also in terms of the best compression scheme for each of them" (P04:S.6/572-574)

Verwendete Codes (P04:S.4-5):
- **Gamma-Code (γ)**: Standard succinct integer code
- **Elias-Fano**: Ankerung & schnelle Range
- **Index-Sequence Codes**

## 3. Schluessel-Innovationen

### 3.1 Drei zentrale Fragen (P04:S.5/Q1-Q3)

> Q1: Algorithmischer Tackle der Space/Time Tradeoffs als l waechst → JA, via Pool von Encoding-Schemes
> Q2: Wie haengt die Wahl von l vom Datensatz ab → muss Topologie + Edge-Labelling beruecksichtigen
> **Q3: Soll die Wahl von l GLOBAL (einheitlich) oder LOKAL (per Knoten variierend) sein?**
> → **Antwort: LOKAL via Optimierungsprozedur die Total-Space-Occupancy minimiert!**

### 3.2 6-Schritte-Konstruktion (P04:S.6/562-577)

1. Compressed Encoding fuer Collapsed Subtries (4.1)
2. Optimierungsprozedur waehlt Subtries (4.2)
3. Pool von Encoding-Schemes (4.3)
4. Local Alphabet Compression (4.4)
5. Space/Time-Trade-off Parameter alpha (4.5)
6. Rank-Operation Implementierung (4.6)

### 3.3 Beispiel (P04:S.4-5/Fig.1)

> "We show that there is **no a priori best choice** about which subtrie to collapse" (P04:S.5/516-517)

Trie T_1 mit kleinem Alphabet {A,C,G,T}: Kollabierung **besser**.
Trie T_2 mit grossem Alphabet: Kollabierung **schlechter**.

→ **Per-Node Entscheidung anhand lokaler Datenverteilung.**

## 4. PRT-ART-Bezug (geschaerft)

| CoCo-Trie-Konzept | PRT-ART-Bezug |
|---|---|
| **Macro-Node (kollabiert l Ebenen)** | **= PRT-ART Redirect-Page** (konzeptionell) |
| **Variable l per Knoten** | konzeptionell aequivalent zu Cache-Engine **Page-Type-Selection Rule** |
| **Pool of Encodings** | direktes Vorbild fuer PRT-ART Cache-Engine "Familie von Page-Layouts" |
| **Data-aware Optimierung** | Cache-Engine **Plattform-Kalibrierung** ist analog (statisch zur Build-Zeit vs runtime) |
| **Static-only** (keine in-place updates) | **GROSSER UNTERSCHIED zu PRT-ART**: PRT-ART braucht Updates |
| **Succinct Encoding** | NICHT in PRT-ART Pflichtkern, aber via SuRF-Anschluss (P10) konzeptionell verwandt |
| **Rank-basierte Navigation** | wie Jacobson LOUDS (P09) und SuRF (P10) |
| **Branching Macro-Character int_l(s)** | NICHT in PRT-ART; PRT-ART nutzt Pointer/Offset |

## 5. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **CoCo-Trie Macro-Node ↔ HOT Compound Node ↔ Wormhole Anchor**: drei verschiedene Strategien fuer "viele Trie-Ebenen in einem Knoten kollabieren"
- **CoCo-Trie Pool of Encodings ↔ HOT 9 Layouts ↔ B-Trees Are Back 6 Optimierungen**: Layout-Familien
- **CoCo-Trie data-aware Optimierung ↔ START Cost Model + Optimizer**: beide nutzen Modell + Wahl pro Knoten/Subtrie
- **CoCo-Trie static-only ↔ Jacobson LOUDS ↔ SuRF FST**: alle drei statisch optimiert (vs PRT-ART dynamisch)

## 6. Kernanschluss fuer PRT-ART

CoCo-Trie ist die **konzeptionelle Inspiration fuer PRT-ART Redirect-Page**: lange Praefix-Pfade als Macro-Node kollabieren, mit data-aware Wahl welche Ebenen kollabiert werden sollen. Die **lokale (per-Node) Optimierung** ist konzeptionell genau die Aufgabe der PRT-ART Cache-Engine. Aber: CoCo-Trie ist **statisch** (Build-Zeit-Optimierung), waehrend PRT-ART **runtime-Adaption** durch die Cache-Engine bietet — das ist ein wesentlicher Beitrag von PRT-ART.
