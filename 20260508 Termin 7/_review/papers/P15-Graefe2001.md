# P15 — Graefe/Larson (B-Tree Indexes and CPU Caches)

**Voller Titel:** B-tree Indexes and CPU Caches
**Autoren:** Goetz Graefe, Per-Ake Larson (Microsoft)
**Venue:** ICDE 2001 (17th IEEE Intl. Conf. on Data Engineering)
**Volltext:** `_text/P15-Graefe2001.txt` (10 Seiten, 58 KB)

## 1. Konzeptionelle Identitaet

**Survey-Paper** ueber CPU-Cache-Techniken fuer B-Trees. KEIN neuer Algorithmus — eine Sammlung folkloric-Techniken, die in der Industrie bekannt sind.

> "This brief paper is a summary of knowledge, much of it folkloric, about how to adapt database indexing software, in particular B-tree code, to memory hierarchies with multiple levels of caches." (P15:S.1/29-32)

**Klasse:** Survey/Folklore-Sammlung
**Fokus:** Exact Match Index Searches (OLTP, materialized views, OLAP semi-joins)

## 2. Vier Hauptquellen-Prinzipien

> "Anything that reduces code complexity and code size is good [...] Anything helps that compresses or shortens B-tree entries [...] Many of the techniques to deal with the delay between memory and disk can be re-applied to CPU caches [...] Many of the techniques that make sorting more cache-efficient can be re-applied to B-tree indexes." (P15:S.1/43-62)

| Prinzip | Wirkung |
|---|---|
| **Code-Complexity reduzieren** | Weniger I-Cache-Misses, weniger Branch-Mispredictions |
| **Eintraege komprimieren** | Mehr Eintraege/Cache-Line → weniger Cache-Misses |
| **Disk→Cache-Techniken adaptieren** | Bewaehrte Strategien wiederverwenden |
| **Sort-Techniken adaptieren** | Cache-effizientes Vergleichen + Layout |

## 3. Survey-Inhalt (Auswahl wichtigster Techniken)

### Sec.4: Adapting disk-based techniques
- Alignment with cache lines
- Prefetching
- Pinning records (avoiding eviction)
- Read-ahead

### Sec.5: Internal node organization
- Binary vs Linear search
- Interpolation search
- Order-preserving compression
- Poor man's normalized keys (prefix shortening)

### Sec.6: Inter-node organization
- Cache-line-aligned splits
- Adjacent pages contiguously (= CSB+-Tree concept!)
- Vertical partitioning (Boncz Manegold Kersten — column store)

### Sec.7: Compaction
- Order-preserving Huffman
- Prefix truncation
- Suffix truncation

## 4. PRT-ART-Bezug

| Graefe-Konzept | PRT-ART-Bezug |
|---|---|
| Code-Complexity Reduktion | konzeptionell: PRT-ART Cache-Engine soll **nicht zu komplex** sein (vermeidet I-Cache-Issues) |
| Compaction | nicht direkt — PRT-ART nutzt feste Byte-Granularitaet |
| Cache-Line-Alignment | DIREKT: PRT-ART Page-Layout muss alignment beruecksichtigen |
| Linear vs Binary Search | wie Samuel/Pedersen/Bonnet (P14) — PRT-ART Cache-Engine waehlt |
| Prefix Truncation | konzeptionell verwandt zu PRT-ART **Redirect-Page** |
| Multi-Level Caching | PRT-ART Cache-Engine misst alle Cache-Levels (L1/L2/L3, TLB) |

## 5. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **Graefe Survey ↔ Ungethuem TUD Survey 2017 (P31)**: zwei Surveys, 16 Jahre auseinander, gleiches Thema
- **Graefe Code-Complexity → I-Cache ↔ Zhang ASPLOS 2025 Hierarchical Prefetcher (P27)**: beide adressieren Instruction-Cache-Pfad
- **Graefe Order-preserving Compression ↔ ART Binary-comparable Keys (P01)**: beide normalisieren Keys
- **Graefe Cache-Line-Alignment ↔ CSB+-Tree Node-Group (P12)**: beide nutzen contiguous layout

## 6. Kernanschluss fuer PRT-ART

Graefe/Larson ist **konzeptionell wichtig**, aber kein direkter Algorithmus-Vorlaeufer. Es liefert die **Sprache fuer "cache-conscious B-tree"** und sammelt das Wissen, das ART und CSB+-Tree spaeter formalisieren.

Fuer PRT-ART relevant:
- **"Survey-Charakter"** = Stuetze fuer PRT-ART These "Bewusste Wahl der richtigen Technik pro Plattform"
- **Multi-Level-Cache-Modell** = PRT-ART Cache-Engine muss Multi-Level beruecksichtigen
- **Tradeoffs** zwischen Code-Complexity, Cache-Compression, Plattform = PRT-ART Cache-Engine ist genau die System-Logik, die diese Tradeoffs adaptiv loest

Graefe schliesst mit: "There is plenty of room for future experimental research" (P15:S.1/93). PRT-ART ist genau diese Forschung — 25 Jahre spaeter.
