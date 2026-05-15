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

## §5 Querverweise

- Original-Quelle (UNVERAENDERT): `../termine/20260508 Termin 7/Cross_Paper_Konzeptmatrix.txt`
- 33 Paper-Notizen (Tier-1/2/3): `../termine/20260508 Termin 7/_review/papers/P01-P33-*.md`
- Bausteine-Matrix (Operationalisierung der Konzepte): `01_bausteine_matrix.md` (K-E.2)
- Begriffsglossar v7 Master: `../glossar/01_begriffsglossar_v7_master.md`
- Forschungslandkarte (33 Paper Vollangaben): `../forschungslandkarte/01_quellen_gesamtkatalog.md` (K-F.2)
- 6 SOTA-Cluster A-F: `../forschungslandkarte/02_cluster_A_trie.md` bis `07_cluster_F_sync_tud_habich.md` (K-F.3-K-F.8)
