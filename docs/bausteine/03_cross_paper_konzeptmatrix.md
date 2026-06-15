# Cross-Paper Konzeptmatrix — Master (Konsolidierung)

**Stand:** 2026-05-15 (K-E.4)
**Quelle:** `../termine/20260508 Termin 7/Cross_Paper_Konzeptmatrix.txt` (389 Zeilen)
**Phase:** 3.B.35 (RIGOROSE Tieflektuere ALLER 33 Paper, 2026-05-04)

---

## §1 Zweck

Verdichtung der in 33 Paper-Notizen identifizierten Konzept-Identitaeten in
eine einzige Cross-Reference-Tabelle. Pro Konzept sind die Paper aufgefuehrt,
die das Konzept (mit unterschiedlichen Namen) verwenden.

**Notation:**
- `PRT-ART KANON` Spalte = unsere Bezeichnung in Diplomarbeit
- `Pij` Spalte = Paper-ID (siehe `_review/papers/P*-*.md` im Termin-7-Ordner)
- ✓ = Hauptbeitrag im Paper
- ● = sekundaer/erwaehnt
- - = NICHT im Paper

---

## §2 18 Cross-Paper-Konzepte (Index)

### Domaene 1: Strukturelle Primitive (Such-Algorithmen)

| # | Konzept | Quelle (Z) |
|---|---|---|
| 1 | KNOTEN (Node) | 26 |
| 2 | SEITE / PAGE | 49 |
| 3 | ADAPTIVE KNOTENTYPEN / PAGE-TYPE-FAMILIE | 65 |
| 4 | PRAEFIXKOMPRESSION / PFADKOMPRESSION | 87 |
| 5 | VALUEHANDLE / PAYLOAD-MANAGEMENT | 103 |

### Domaene 2: Operationen + Ordnung

| # | Konzept | Quelle (Z) |
|---|---|---|
| 6 | SUCH-OPERATIONEN | 117 |
| 7 | ORDNUNG / SORTIERUNG | 131 |

### Domaene 3: Encoding-Strategien

| # | Konzept | Quelle (Z) |
|---|---|---|
| 8 | SUCCINCT / SPACE-EFFICIENT ENCODING | 149 |

### Domaene 4: Cache-Engine-Konzepte

| # | Konzept | Quelle (Z) |
|---|---|---|
| 9 | CACHE-AWARENESS-MODI | 168 |
| 10 | COST MODEL / PLATFORM CALIBRATION | 180 |
| 11 | TELEMETRIE / PROBABILITY HINTS | 195 |
| 12 | ONLINE RELOCATION / RE-LAYOUTING | 210 |

### Domaene 5: Performance-Optimierungen

| # | Konzept | Quelle (Z) |
|---|---|---|
| 13 | PREFETCHING | 225 |
| 14 | SYNCHRONIZATION / CONCURRENCY | 244 |
| 15 | ALLOCATOR / MEMORY MANAGEMENT | 262 |

### Domaene 6: Hardware/ISA

| # | Konzept | Quelle (Z) |
|---|---|---|
| 16 | SIMD-INSTRUCTIONS | 281 |
| 17 | HARDWARE PREFETCH | 293 |
| 18 | TLB | 303 |

---

## §3 Beispiel-Verdichtung pro Konzept

### Konzept 1: KNOTEN (Node)

**PRT-ART KANON:** Knoten

| Paper-ID | Begriff im Paper | Quelle | Form |
|---|---|---|---|
| P01 ART | "Inner Node" | Leis 2013 | adaptive 4 Typen |
| P02 HOT | "Compound Node", "BiNode" | Binna 2018 | container, binary Patricia |
| P03 Masstree | "Internal/Border Node" | Mao 2012 | B+ inner/leaf |
| P04 CoCo-trie | "Macro-Node" | Boffa 2024 | kollabierter Subtrie |
| P05 START | "Multilevel Node" | Fent 2020 | mehrbyteig |
| P06 B²-tree | "Decision/Span Node" | Schmeisser 2022 | byte-decision, prefix-span |
| P07 Wormhole | "Anchor", "Internal/Leaf Hash Item" | Wu 2019 | hash + pointers |
| P09 Jacobson | "Tree Node" | Jacobson 1989 | succinct node |
| P10 SuRF | "FST Node" | Zhang 2018 | LOUDS-Dense oder LOUDS-Sparse |
| P12 CSB+ | "Inner Node + Node Group" | Rao/Ross 2000 | contiguous siblings |
| P20 B-Trees Are Back | "Slotted Page Node" | Mueller 2025 | adaptive layout |

**Abgrenzung:** KEIN "Page" (Container), KEIN "Cache Line" (Hardware).

### Konzept 3: ADAPTIVE KNOTENTYPEN / PAGE-TYPE-FAMILIE

**PRT-ART KANON:** Page-Type-Familie (5 Typen)

| Paper-ID | Begriff im Paper | Anzahl Layouts |
|---|---|---|
| P01 ART | adaptive nodes (Node4/16/48/256) | 4 |
| P02 HOT | adaptive node sizes (Single-Mask + Multi-Mask × 8/16/32 bit) | 9 |
| P05 START | multilevel nodes + Rewired64K + Rewired16M + MultiNode4 | 7 |
| P10 SuRF | LOUDS-Dense + LOUDS-Sparse | 2 |
| P20 B-Trees Are Back | 6 Layout-Optimierungen + adaptive selection | 6 + adaptive |
| P04 CoCo-trie | Pool of succinct encodings + macro-node levels | viele |

**PRT-ART KANON Familie:**
- Dense-Byte-Page (analog ART Node256, LOUDS-Dense)
- Sparse Patricia Page (analog HOT, LOUDS-Sparse)
- Multibyte Page (analog START)
- Macro Page (analog CoCo-trie)
- Decision/Span Page (analog B²-tree)

(Voll-Inhalt aller 18 Konzepte: siehe Original-Datei `Cross_Paper_Konzeptmatrix.txt`.)

---

## §4 Volltabelle (33 Paper × 18 Konzepte) — Verweis auf Original

Die kompletten ✓/●/- Markierungen pro Paper × Konzept findest du im Original.
Hier nur das Inhaltsverzeichnis und die wichtigsten Konzept-Beispiele.

---

## §6 N-Phase Erweiterung 2026-05-18 — Hardware + Scheduling Spalten

**Trigger:** N.8 (#471), User-Direktive Achse 12 + Achse 13
**Pflicht-Pre-Read:** `07_bausteine_matrix_N_erweitert.md`

### §6.1 Neue Spalten pro Paper (P01-P33)

Pro Paper sind 2 neue Konzept-Spalten hinzuzufuegen (Achse 12 + 13 aus N-Phase):

| Paper | Hardware-Strategy (Achse 12) | Scheduling-Strategy (Achse 13) | Kommentar |
|---|---|---|---|
| P01 ART | AVX2, L1-aware, none NUMA, CAS | thread-per-core, no-SIMD-limit, hybrid-naive | Leis 2013 keine explizite HW-Wahl |
| P02 HOT | AVX2 (Bit-Vector-Sprung), L1-aware, none, CAS | thread-per-core | Binna 2018 |
| P03 Masstree | scalar, L1-aware, none, CAS | thread-per-core, work-stealing | Mao 2012 |
| P04 CoCo | scalar (succinct-Bit-Tricks), L2-aware, none, none | thread-per-core | Boffa 2024 |
| P05 START | AVX2 (Multi-Byte-Span), L1-aware, none, CAS | thread-per-core | Fent 2020 |
| P06 B²-Tree | scalar, L2-aware (Decision-Tree-cache), none, CAS | thread-per-core | Schmeisser 2022 |
| P07 Wormhole | scalar, L1+L2-aware, none, CAS | thread-per-core | Wu 2019 |
| P08 ART-Sync | scalar, L1-aware, none, OLC-CAS | thread-per-core + OLC | Leis 2016 |
| P09 LOUDS | scalar (Bit-Tricks), L1-aware, none, none | thread-per-core | Jacobson 1989 |
| P10 SuRF | scalar, L1-aware, none, none | thread-per-core | Zhang 2018 |
| P11-P14 CSS/CSB+/Hankins/Samuel | SIMD (NEON-aehnlich), L1-aware, none, CAS | thread-per-core | Rang-2 |
| P15-P19 Layout-Theorie | scalar, Cache-Oblivious, none, none | thread-per-core | Rang-2 |
| P20 LeanStore | AVX2, HBM-aware, NUMA-aware, CAS | work-stealing, hybrid-aware | Mueller 2025 |
| P21+P22 Chen Prefetching | PREFETCH (Stride), L1+L2-aware, none, CAS | thread-per-core + Stride-Worker | Chen 2001/2002 |
| P23 Khan Dynamic | PREFETCH (adaptive), L2-aware, none, CAS | thread-per-core | Khan 2010 |
| P24 Naderan | scalar, L3-aware, none, none | thread-per-core | Naderan 2016 |
| P25 Mahling | PREFETCH (gem5-Simulator), L3-aware, none, none | thread-per-core | Mahling 2025 |
| P26 Zhang FGCS | PREFETCH (indexing), L2-aware, none, CAS | thread-per-core | Q. Zhang 2024 |
| **P27 hp-soft** | **PREFETCH (hierarchical L1/L2/L3 Bundle)**, **L1+L2+L3-aware**, none, CAS | thread-per-core + Co-Routine-interleave | T. Zhang 2025 ASPLOS |
| **P28 Kuehn** | PREFETCH (none, scalar Counter), L1-aware Counter, none, CAS | thread-per-core + Sampling-Worker | Kuehn 2023 DaMoN |
| P29 RCU | CAS (atomic load), L1-aware, none, atomic-load | thread-per-core + Read-Side-Critical | McKenney 2001 |
| P30 Hazard | CAS, L1-aware, none, CAS + LL-SC | thread-per-core + HP-Cleanup | Michael 2004 |
| **P31 Ungethuem** | AVX-512 (HBM), HBM-aware, NUMA-aware, CAS | hybrid-aware (P-cores + E-cores) | Habich Rang-3 |
| **P32 Schmidt** | AVX-512 (SIMD-Stride), HBM-aware, NUMA-aware, CAS | hybrid-aware | Habich Rang-3 |
| **P33 VAMPIR** | AVX-512 (Profiler), all-Cache-Level, NUMA-aware, none | hybrid-aware + Profiler-Worker | Habich Rang-3 |

### §6.2 PRT-ART-Konsequenz

PRT-ART soll auf Achse 12 + 13 eine eigene Spalte fuer den Vergleich erhalten:
- 12: AVX2 + L1-aware (TLB-aligned) + local NUMA + PREFETCH (Distance-Estimator + Redirect-NTA) + CAS (OLC)
- 13: thread-per-core + 2 SIMD-Worker-Limit + hybrid-aware (P-cores Tree-Walk, E-cores Background-Reorder) + Co-Routine-interleave + micro-batch

---

## §5 Querverweise

- Original-Quelle (UNVERAENDERT): `../termine/20260508 Termin 7/Cross_Paper_Konzeptmatrix.txt`
- 33 Paper-Notizen (Rang-1/2/3): `../termine/20260508 Termin 7/_review/papers/P01-P33-*.md`
- Bausteine-Matrix (Operationalisierung der Konzepte): `01_bausteine_matrix.md` (K-E.2)
- Begriffsglossar v7 Master: `../glossar/01_begriffsglossar_v7_master.md`
- Forschungslandkarte (33 Paper Vollangaben): `../forschungslandkarte/01_quellen_gesamtkatalog.md` (K-F.2)
- 6 SOTA-Cluster A-F: `../forschungslandkarte/02_cluster_A_trie.md` bis `07_cluster_F_sync_tud_habich.md` (K-F.3-K-F.8)
