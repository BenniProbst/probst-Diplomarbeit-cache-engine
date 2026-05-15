# Eigenschaften der Such-Algorithmen — Master (Konsolidierung)

**Stand:** 2026-05-15 (K-E.7)
**Quelle:** `../termine/20260508 Termin 7/Eigenschaften_Suchalgorithmen.txt` (669 Zeilen)
**Phase:** 3.B Tieflektuere ALLER 33 Paper (2026-05-04)

---

## §1 Zweck

Pro Such-Algorithmus aus dem Korpus: konzeptionelle Identitaet, strukturelle
Bausteine, Operationen, Komplexitaet, Concurrency-Modell, Cache-Annahmen,
Plattform-Annahmen.

**Grundlage fuer:**
- Begriffsglossar (Phase 3.C, siehe `../glossar/01_begriffsglossar_v7_master.md`)
- Domaenenmodell (Phase 3.D, siehe `../glossar/02_domaenenmodell_v4_master.md`)

**Pro Algorithmus identische Struktur:**
1. Identitaet (was IST der Algorithmus konzeptionell?)
2. Strukturelle Bausteine (welche Knoten-/Seitentypen?)
3. Operationen (Lookup/Insert/Delete/Range?)
4. Komplexitaet
5. Concurrency-Modell
6. Cache-Annahmen
7. Plattform-Annahmen
8. PRT-ART-Bezug

---

## §2 4 Hauptkategorien

| Kat. | Name | Anzahl Algorithmen | Quelle (Z) |
|---|---|---|---|
| A | KLASSISCHE CACHE-AWARE B-BAUM-FAMILIE | 10 | 29 |
| B | TRIE-BASIERTE UND TRIE-HYBRIDE SUCHSTRUKTUREN | (P01-P10) | 309 |
| C | CACHE-ENGINE / PREFETCHING / SYNCHRONISATION | (P21-P28, P29, P30) | 612 |
| D | HABICH-/DRESDEN-LINIE | (P31, P32, P33) | 650 |

---

## §3 Kategorie A — Klassische Cache-aware B-Baum-Familie (Z 29-308)

| ID | Name | Quelle (Z) |
|---|---|---|
| A.1 | CSS-TREE — Cache-Sensitive Search Tree (Rao/Ross 1999, P11) | 33 |
| A.2 | CSB+-TREE — Cache-Sensitive B+-Tree (Rao/Ross 2000, P12) | 72 |
| A.3 | GRAEFE/LARSON — B-Tree Indexes and CPU Caches (2001, P15) | 109 |
| A.4 | HANKINS/PATEL — Effect of Node Size (2003, P13) | 132 |
| A.5 | SAMUEL/PEDERSEN/BONNET — Processor-Conscious CSB+-Tree (2005, P14) | 153 |
| A.6 | BENDER/DEMAINE/FARACH-COLTON — Tree Layout in Multilevel Memory (2002, P16) | 181 |
| A.7 | BENDER/DEMAINE/FARACH-COLTON — Cache-Oblivious B-Trees (2005, P17) | 208 |
| A.8 | SAIKKONEN/SOISALON-SOININEN — Cache-sensitive Memory Layout for Binary Trees (2008 IFIP TCS, P18) | 236 |
| A.9 | SAIKKONEN/SOISALON-SOININEN — Cache-Sensitive Memory Layout for Dynamic Binary Trees (2016 ComJ, P19) | 264 |
| A.10 | MUELLER/BENSON/LEIS — B-Trees Are Back (2025 SIGMOD, P20) | 280 |

---

## §4 Kategorie B — Trie-basierte und Trie-Hybride Suchstrukturen (Z 309-611)

| ID | Name | P-ID | Vermutete Quelle (Z) |
|---|---|---|---|
| B.1 | ART — Adaptive Radix Tree (Leis 2013) | P01 | (siehe Original) |
| B.2 | HOT — Height Optimized Trie (Binna 2018) | P02 | (siehe Original) |
| B.3 | Masstree (Mao 2012) | P03 | (siehe Original) |
| B.4 | CoCo-trie (Boffa 2024) | P04 | (siehe Original) |
| B.5 | START — Self-Tuning Adaptive Radix Tree (Fent 2020) | P05 | (siehe Original) |
| B.6 | B²-Tree (Schmeisser 2022) | P06 | (siehe Original) |
| B.7 | Wormhole (Wu 2019) | P07 | (siehe Original) |
| B.8 | ART of Practical Synchronization (Leis 2016) | P08 | (siehe Original) |
| B.9 | LOUDS (Jacobson 1989) | P09 | (siehe Original) |
| B.10 | SuRF — Succinct Range Filter (Zhang 2018) | P10 | (siehe Original) |

---

## §5 Kategorie C — Cache-Engine / Prefetching / Synchronisation (Z 612-649)

| ID | Name | P-ID |
|---|---|---|
| C.1 | Chen Prefetching B+-Trees (2001) | P21 |
| C.2 | Chen Fractal Prefetching B+-Trees (2002) | P22 |
| C.3 | Khan Adaptive Prefetch (2010) | P23 |
| C.4 | Naderan-Tahan Useless Prefetch (2016) | P24 |
| C.5 | Mahling Fill Buffer (2025) | P25 |
| C.6 | Zhang FGCS Read Counter (2024) | P26 |
| C.7 | Zhang ASPLOS Hierarchical (2025) | P27 |
| C.8 | Kuehn DAMON Histogram/HotPath (2023) | P28 |
| C.9 | RCU (McKenney 2001) | P29 |
| C.10 | Hazard Pointers (Michael 2004) | P30 |

---

## §6 Kategorie D — Habich-/Dresden-Linie (Z 650-666)

| ID | Name | P-ID |
|---|---|---|
| D.1 | Ungethuem 2017 (TUD Hardware Optimizations Survey) | P31 |
| D.2 | Schmidt 2025 (To Stride or Not, TUD DIMES) | P32 |
| D.3 | Berthold 2023 (VAMPIR Poster, TUD/SPP2377) | P33 |

---

## §7 Vorlage-Schema pro Algorithmus

(Aus A.1 CSS-TREE als Beispiel, Z 33-71)

```
A.1 CSS-TREE — Cache-Sensitive Search Tree (Rao/Ross 1999)

IDENTITAET
  Pointer-FREIE Directory-Struktur ueber sortiertem Array.
  Verzeichnisknoten in Cache-Line-Groesse, Kinder ueber Offset-
  Arithmetik adressiert.
  Klasse:    statische cache-line-orientierte Indexstruktur
  Lesbar:    "Sortiertes Array + arithmetisch-navigierter Cache-Line-Header"

STRUKTURELLE BAUSTEINE
  - Cache-Line-Knoten (~64 Bytes)
  - Pointer-freie Adressierung (Offset-Arithmetik)
  - Sortiertes Array als Datenkern
  - Verzeichnis-Header

OPERATIONEN
  - Lookup (binary search innerhalb Cache-Line)
  - Insert/Delete: bulk rebuild (statische Struktur)

KOMPLEXITAET
  Lookup: O(log n / log B), B = Cache-Line-Eintraege
  Memory: 1 Cache Line pro Knoten

CONCURRENCY
  - Read-only (nach Bulk-Build)
  - Updates erfordern Rebuild

CACHE-ANNAHMEN
  - Cache-Line-Groesse fix (typisch 64 Bytes)
  - L1-Cache-Hits primaeres Optimierungsziel

PLATTFORM-ANNAHMEN
  - x86, klassische Cache-Hierarchie
  - Static (kompiliert) Cache-Line-Konstante

PRT-ART-BEZUG
  - PageBank::CSS_NODE Baustein (Achse 1)
  - Cache-Line-Aligned Memory-Layout (Achse 5)
  - LEGACY_REIMPL in prt-art Repo
  - Vergleichsbasis fuer Bausteine-Quer-Permutation (F15)
```

(Voll-Inhalt aller 23 Algorithmen siehe Original-Datei.)

---

## §8 Querverweise

- Original-Quelle (UNVERAENDERT): `../termine/20260508 Termin 7/Eigenschaften_Suchalgorithmen.txt`
- 33 Paper-Notizen (PDFs gelesen): `../termine/20260508 Termin 7/_review/papers/P*-*.md`
- Cross-Paper Konzeptmatrix (Konzepte ueber alle Paper): `03_cross_paper_konzeptmatrix.md` (K-E.4)
- Forschungslandkarte 33 Paper Vollangaben: `../forschungslandkarte/01_quellen_gesamtkatalog.md` (K-F.2)
- Bausteine-Matrix (Algorithmus-Bausteine-Matching): `01_bausteine_matrix.md` (K-E.2)
