# P10 — SuRF (Succinct Range Filter mit Fast Succinct Trie)

**Voller Titel:** SuRF: Practical Range Query Filtering with Fast Succinct Tries
**Autoren:** Huanchen Zhang, Hyeontaek Lim, **Viktor Leis (TUM)**, David G. Andersen, Michael Kaminsky, Kimberly Keeton, Andrew Pavlo (CMU + TUM + Intel + HPE)
**Venue:** SIGMOD 2018, Houston TX
**DOI:** 10.1145/3183713.3196931
**Volltext:** `_text/P10-SuRF-Zhang2018.txt` (14 Seiten, 89 KB)
**Provenienz:** HABICH-Zusatz!

## 1. Konzeptionelle Identitaet

SuRF kombiniert **succinct trie (FST)** mit **range filter approximate membership**. Bietet:
- ExactKeySearch (point query)
- LowerBound (range query lower bound)
- MoveToNext (range scan iterator)
- Optionale **suffix bits** fuer false-positive-tunable approximate filtering (Bloom-Filter-Ersatz)

> "FST is 4-15× faster than earlier succinct tries... achieving performance comparable to or better than the state-of-the-art pointer-based indexes." (P10:S.2/149-152)

**Klasse:** Static Succinct Trie + tunable Range Filter
**Annahme:** Trie hat **fanout 256** (1 Byte pro Level)

## 2. FST: Fast Succinct Trie (Hauptbeitrag)

### 2.1 Schluessel-Insight

> "FST's design is based on the observation that the upper levels of a trie comprise few nodes but incur many accesses. The lower levels comprise the majority of nodes, but are relatively 'colder'." (P10:S.2/153-156)

→ **Hybrid-Encoding LOUDS-DS**:
- **Upper levels** in **LOUDS-Dense** (cache-friendly, 1 array lookup pro child)
- **Lower levels** in **LOUDS-Sparse** (space-efficient)

### 2.2 LOUDS-Dense (P10:S.2-3/Sec.2.2)

**3 Bitmaps** + 1 Byte-Sequence pro Trie-Node, jedes 256 Bits gross:

| Bitmap | Bedeutung |
|---|---|
| **D-Labels** | i-tes Bit gesetzt ↔ Branch mit Label i existiert |
| **D-HasChild** | i-tes Bit ↔ Branch fuehrt zu Subtrie (1) oder Wert (0) |
| **D-IsPrefixKey** | 1 Bit pro Node — ist der prefix selbst auch ein gueltiger Key? |
| **D-Values** | Byte-Sequence der Werte (level-order) |

Navigation:
- `D-ChildNodePos(pos) = 256 × rank_1(D-HasChild, pos)` — first child node's bit position
- `D-ParentNodePos(pos) = 256 × select_1(D-HasChild, ⌊pos/256⌋)` — parent
- `D-ValuePos(pos) = rank_1(D-Labels, pos) - rank_1(D-HasChild, pos) + rank_1(D-IsPrefixKey, ⌊pos/256⌋) - 1`

### 2.3 LOUDS-Sparse (P10:S.3/Sec.2.3)

**4 Sequenzen** pro Trie-Node:

| Sequenz | Bedeutung |
|---|---|
| **S-Labels** | Byte-Sequenz aller Branching Labels |
| **S-HasChild** | 1 Bit pro Label — child ist Subtrie oder Value |
| **S-LOUDS** | 1 Bit pro Label — markiert Node-Boundaries (1 = first label of node) |
| **S-Values** | Byte-Sequenz der Werte |

**Special Byte 0xFF** am Beginn eines Nodes = "Praefix ist auch gueltiger Key" (Aequivalent zu D-IsPrefixKey).

Navigation:
- `S-ChildNodePos(pos) = select_1(S-LOUDS, rank_1(S-HasChild, pos) + 1)`
- `S-ParentNodePos(pos) = select_1(S-HasChild, rank_1(S-LOUDS, pos) - 1)`
- `S-ValuePos(pos) = pos - rank_1(S-HasChild, pos) - 1`

### 2.4 LOUDS-DS Hybrid (P10:Sec.2.4)

> "We maintain a size ratio R between LOUDS-Sparse and LOUDS-Dense to determine the dividing point among levels. [...] We use R=64 as the default." (P10:S.3/342-349)

**Cutoff Level**: groesstes l mit `LOUDS-Dense-Size(l) × R ≤ LOUDS-Sparse-Size(l)`.

Reducing R → mehr Dense-Levels → Speed > Space.

## 3. Optimierungen (P10:Sec.2.6)

### 3.1 Rank Structure (1-level LUT)
- Bit-vector aufgeteilt in Basic Blocks von B Bits
- Rank-LUT mit 32-bit Eintrag pro Block (precomputed rank am Block-Start)
- `rank_1(i) = LUT[⌊i/B⌋] + popcount(bits ⌊i/B⌋·B bis i)` (1 Hardware-popcount)
- B = 64 fuer LOUDS-Dense, B = 512 fuer LOUDS-Sparse

### 3.2 Select Structure (sampled LUT)
- Speichert precomputed Antworten alle S Set-Bits
- `select_1(i) = LUT[i/S] + (count remaining bits)`
- Default S = 64

### 3.3 Label Search via SIMD
> "We use 128-bit SIMD instructions to perform the label search in LOUDS-Sparse." (P10:S.4/486-487)
- 128-bit chunks → 16 labels parallel
- Max 16 SIMD equality checks pro label search
- > 90% der Trie-Nodes haben size < 8 → 1 SIMD check reicht!

### 3.4 Prefetching
> "When the search position in one sequence is determined, relevant addresses in other sequences can be computed and prefetched for later use." (P10:S.4/498-502)

## 4. SuRF Variations (P10:Sec.3)

| Variante | Was wird zusaetzlich gespeichert | False Positive Rate |
|---|---|---|
| **SuRF-Base** | Nur shared prefix + 1 Byte | 4% (int), 25% (email) |
| **SuRF-Hash** | + n hash bits per key (least-sig of H(K)) | < 2^-n |
| **SuRF-Real** | + n real key suffix bits | tunable |
| **SuRF-Mixed** | + Hash + Real bits kombiniert | best of both |

## 5. Space- + Performance-Analyse

### 5.1 Space (P10:Sec.2.5)
- LOUDS-Sparse: **10n bits** (8n labels + 1n HasChild + 1n LOUDS)
- Lower bound (Information-theoretic): ~9.44n bits
- → SuRF ist **compact, nicht echt succinct** (O(n) statt n+o(n))
- Aber: schneller als alle bekannten echten succinct tries

### 5.2 Performance (P10:Tab.1/S.4-5)
- **4-15× schneller als andere succinct tries**
- **Vergleichbar oder besser als ART/B+** bei Range Queries
- 10 Bits/Knoten

## 6. PRT-ART-Bezug (HOECHST IMPORTANT - HABICH-Zusatz!)

| SuRF/FST-Konzept | PRT-ART-Bezug |
|---|---|
| **LOUDS-Dense** | **Direkte konzeptionelle Aequivalenz zu PRT-ART Dense-Byte-Page** (256 Bitmaps + Werte) |
| **LOUDS-Sparse** | **Direkte konzeptionelle Aequivalenz zu PRT-ART Sparse Patricia Page** |
| **LOUDS-DS Hybrid mit R=64** | **DIREKTES Vorbild fuer PRT-ART Cache-Engine Page-Type-Selection Rule!** |
| **Cutoff Level** | konzeptionell = PRT-ART Cache-Engine "wo wechselt die Seitentyp-Wahl?" |
| **rank/select Hardware-Popcount** | OPTIONAL fuer succinct Pages in PRT-ART |
| **SIMD Label Search (16 parallel)** | wie HOT (P02) — direkt uebernehmbar |
| **Prefetching across sequences** | OPTIONAL — Cache-Engine kann das aktivieren |
| **Static-only** | **GROSSER UNTERSCHIED** — PRT-ART braucht Updates |
| **D-IsPrefixKey / 0xFF Marker** | konzeptionell = PRT-ART Terminale Knoten mit ValueHandle |
| **3 Bitmaps fuer Dense Pages** | Sehr eleganter Layout — PRT-ART Dense-Byte-Page koennte das uebernehmen |
| **SuRF Filter Variants** | NICHT in PRT-ART (PRT-ART ist exact, nicht approximate) |

## 7. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **SuRF FST ↔ Jacobson 1989 LOUDS (P09)**: SuRF baut DIREKT auf Jacobson auf, mit Hybrid-Encoding
- **SuRF LOUDS-DS Hybrid ↔ HOT 9 Layouts (P02) ↔ B-Trees Are Back 6 Optimierungen (P20) ↔ START Multilevel Choice (P05)**: vier verschiedene "data-aware Layout-Selection"-Strategien
- **SuRF SIMD Label Search ↔ HOT AVX2 Search (P02) ↔ ART Node16 SSE (P01)**: drei SIMD-basierte Trie-Search-Implementierungen
- **SuRF Prefetching across sequences ↔ Masstree Cache-Line Prefetch (P03)**: zwei Prefetch-Strategien
- **SuRF static-only ↔ CoCo-trie static-only (P04) ↔ Jacobson static (P09)**: alle drei sind statisch
- **SuRF D-IsPrefixKey 0xFF ↔ ART Combined slot (P01)**: beide markieren "Prefix ist auch Wert"

## 8. Kernanschluss fuer PRT-ART (Habich-Hauptmotivation!)

SuRF/FST ist **das wichtigste Vorbild** fuer PRT-ART **Page-Type-Familie + Cache-Engine**:

1. **LOUDS-Dense ↔ PRT-ART Dense-Byte-Page**: 3-Bitmap-Layout ist eleganter als ART Node256
2. **LOUDS-Sparse ↔ PRT-ART Sparse Patricia Page**: succinct sparse encoding mit SIMD-Search
3. **LOUDS-DS Hybrid mit Cutoff R ↔ PRT-ART Cache-Engine**: SuRF macht statisch, PRT-ART **dynamisch zur Runtime**!

**Das ist der Kern-Forschungsbeitrag von PRT-ART**: Was SuRF beim Build statisch entscheidet (Cutoff R = 64 fuer alle Subtries einheitlich), entscheidet PRT-ART **per-Subtrie online**, basierend auf Cache-Engine-Telemetrie.

**SuRF ist der direkte Vergleich**, gegen den PRT-ART sich beweisen muss:
- PRT-ART braucht UPDATES (SuRF nicht)
- PRT-ART braucht ADAPTIVE Cutoffs (SuRF static R=64)
- PRT-ART nutzt mehr Page-Typen (Dense/Extended/Sparse/Redirect/Custom) — SuRF nur 2

Habich's Zusatz von SuRF + Jacobson zeigt klar, dass er **die Succinct-Familie als wichtige Vergleichsbasis** sieht. PRT-ART positioniert sich gegenueber SuRF als "succinct PLUS dynamisch PLUS update-faehig".
