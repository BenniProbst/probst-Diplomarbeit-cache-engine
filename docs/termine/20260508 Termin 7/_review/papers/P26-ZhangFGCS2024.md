# P26 — Zhang et al. FGCS 2024 (Prefetching Indexing Scheme for IMDBs)

**Voller Titel:** A prefetching indexing scheme for in-memory database systems
**Autoren:** Qian Zhang, Haoyun Song, Kaiyan Zhou, Jianhao Wei, Chuqiao Xiao (East China Normal University, Shanghai)
**Venue:** Future Generation Computer Systems 156 (2024) 179-190
**DOI:** 10.1016/j.future.2024.03.012
**Volltext:** `_text/P26-ZhangFGCS2024.txt` (12 Seiten, 77 KB)

## 1. Konzeptionelle Identitaet

**Kombiniert Path-Prefetcher mit Jump-Pointer-Prefetcher** fuer **MVCC In-Memory Databases** mit Versionsketten. Adressiert Pointer-Chasing in Indizes + Indirection-Layer + Version-Chains.

> "We combine a path prefetcher with a jump pointer prefetcher and propose the prefetching indexing scheme for hiding the memory latency induced by version searches." (P26:S.1/131-133)

**Klasse:** Prefetching-Schema fuer MVCC-IMDB
**Performance:** **20-70%** schneller als state-of-the-art Indexing Schemes auf YCSB

## 2. Hauptbeobachtung (P26:S.1-2/Fig.1)

> "DBx1000 spends a significant fraction of its total execution time (75% and 82%, respectively) on **pointer chasing**, causing dependent cache misses." (P26:S.2/114-117)

3 Pointer-Chasing-Bereiche:
1. Root-to-Leaf Trie/B+-Traversal
2. Indirection-Layer Lookup (Tuple-ID → Version-Chain HEAD)
3. Version-Chain-Traversierung (linked list)

## 3. Hauptkonzepte

### 3.1 Path Prefetcher
- **Read Counter pro Block** (Tracking welche Pfade haeufig genutzt)
- Update der Counter in Search-Key-Pfaden
- **Continuously evolve frequent access paths** durch Pattern-Analyse

### 3.2 Jump Pointer Prefetcher
- Pro Tuple in Leaf Node: **Jump Pointer** zur Head der Version-Chain
- **Jump Pointer Queue** fuer linear version traversal
- Vermeidet seriellen Pointer-Chase in Versionskette

### 3.3 Workload-Anpassung
- Pro Block ein Read-Counter, in Hot Paths inkrementiert
- Hot Paths werden zu Prefetch-Candidates

## 4. PRT-ART-Bezug (HOECHST RELEVANT)

| Zhang-FGCS-Konzept | PRT-ART-Bezug |
|---|---|
| **Read Counter pro Block** | **DIREKT = PRT-ART Probability Hints / Telemetrie in Page-Header** |
| **Path Prefetcher mit Hot Paths** | **DIREKTE Vorlage fuer PRT-ART Cache-Engine "Hot Path"-Detektion** |
| **Continuously evolve frequent access paths** | konzeptionell aequivalent zu PRT-ART Cache-Engine Modus 3 (online adaptiv) |
| **Jump Pointer Queue** | konzeptionell verwandt zu PRT-ART **Redirect-Page** + Cache-Engine-Prefetch |
| **MVCC Version-Chain** | NICHT direkt in PRT-ART (PRT-ART hat Single-Version) |
| **Pointer-Chasing als Hauptproblem** | **Klassisches Argument** fuer cache-aware Optimierung |

## 5. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **Zhang FGCS Read Counter ↔ Dortmund Hot-Path Histograms (P28)**: zwei Strategien fuer Path-Frequency-Tracking
- **Zhang FGCS Jump Pointer ↔ Wormhole Anchor (P07) ↔ CoCo-trie Macro-Node (P04)**: drei Konzepte fuer "Sprung ueber Pointer-Kette"
- **Zhang FGCS Path Prefetcher ↔ Chen 2001 Wider Nodes Prefetch (P21)**: zwei Prefetch-Strategien
- **Zhang FGCS evolves access paths ↔ START Self-Tuning + Optimizer (P05)**: zwei adaptive Mechanismen

## 6. Kernanschluss fuer PRT-ART

Zhang FGCS 2024 ist **eine wichtige direkte Inspiration** fuer PRT-ART Cache-Engine Telemetrie:

1. **Read Counter pro Block** = PRT-ART **Probability Hints im Page-Header** (Termin 4)
2. **Hot Path-Tracking + Evolution** = PRT-ART **Cache-Engine Modus 3 online adaptive**
3. **Jump Pointer Prefetcher** = PRT-ART **Redirect-Page + Cache-Engine-Prefetch** kombiniert

Termin 4 Designmuster "Probability Hints / Histogramme im Header als Telemetrie-API" (Referenz [20]) ist genau dieser Zhang FGCS 2024.

PRT-ART verallgemeinert Zhang FGCS:
- Zhang FGCS: **MVCC-spezifisch** (Versionsketten)
- PRT-ART: **Allgemein** (jede Trie-basierte Suche)
