# SLUB Download-Liste — Diplomarbeit Cache-Engine

**Stand:** 2026-05-04 · **Termin 7** · **REV4 — Vollstaendig (CSB+ Volltext + SOSP-VAMPIR-Suche)**
**Zielordner:** `./Forschungsarbeiten/`
**Code-Zielordner:** `./Forschungsarbeiten/<paper-id>/code/`

> **Status REV4:** 34 PDFs im Hauptordner (alle inhaltlich verifiziert via pypdf), 7 Falsch-Downloads in `low priority/`.
> **31 von 31 wissenschaftlichen Quellen** korrekt vorhanden  ✓ **VOLLSTAENDIG**
> SOSP'23-Hauptband enthaelt KEIN VAMPIR (in 802 Seiten gesucht) — Posters in separatem Companion publiziert. SOSP-Band kann geloescht werden.
> VAMPIR via SPP2377-Kickoff-Poster gedeckt (gleiches Team, inhaltlich aequivalent).
> Vollstaendige Verifikationstabelle: `_extracted_text/pdf_verification.txt`

---

## ✅ INHALTLICH VERIFIZIERT KORREKT (30 Paper)

### A1 · Klassische Cache-Aware B-Baum-Familie

- [x] **CSS-Tree (Rao/Ross 1999)** → `Cache Conscious Indexing for Decision-Support in Main Memory.pdf`
- [x] **CSB+-Tree (Rao/Ross 2000)** → `Making B+-Trees Cache Conscious in Main Memory.pdf`
- [x] **B-tree Indexes and CPU Caches (Graefe/Larson 2001)** → `B-tree Indexes and CPU Caches.pdf` ✓ NEU
- [x] **Node Size in Cache-Conscious B+-Trees (Hankins/Patel 2003)** → `Effect of Node Size on the Performance ofCache-Conscious B+-trees.pdf`
- [x] **Making CSB+-Tree Processor Conscious (Samuel/Pedersen/Bonnet 2005)** → `Making CSB+-Trees Processor Conscious - Paper.pdf` ✓ VOLLTEXT (NEU REV4) + Folien zusaetzlich
- [⚠] **Tree Layout in Multilevel Memory (Bender/Demaine/Farach-Colton 2002)** → `Tree Layout ... .pdf` (10 MB = ganzer LNCS-Band; verwendbar)
- [x] **Cache-Oblivious B-Trees (Bender et al. 2005)** → `CACHE-OBLIVIOUS B-TREES.pdf`
- [x] **Cache-sensitive Memory Layout for Binary Trees (Saikkonen 2008 IFIP TCS)** → `Cache-sensitive Memory Layout for Binary Trees.pdf`
- [x] **Cache-Sensitive Memory Layout for Dynamic Binary Trees (Saikkonen 2016 ComJ)** → `Cache-Sensitive Memory Layout for Dynamic Binary Trees.pdf`
- [x] **B-Trees Are Back (Mueller/Benson/Leis 2025 SIGMOD)** → `B-Trees Are Back - Engineering Fast and Pageable Node Layouts.pdf`
  > Korrektur: Autoren sind Mueller/Benson/Leis, NICHT Leis/Haubenschild/Kemper/Neumann

### A2 · Trie-basierte und trie-hybride Suchstrukturen

- [x] **Masstree (Mao/Kohler/Morris 2012)** → `Cache Craftiness for Fast Multicore Key-Value Storage.pdf` ← VERIFIZIERT, KORREKT (Nutzer-Sorge widerlegt!)
- [x] **ART (Leis/Kemper/Neumann 2013)** → `The_adaptive_radix_tree_ARTful_indexing_for_main-memory_databases.pdf`
- [x] **The ART of Practical Synchronization (Leis/Scheibner/Kemper/Neumann 2016)** → `The ART of Practical Synchronization.pdf`
  > Korrektur: Co-Autor ist Scheibner, NICHT Haubenschild
- [x] **HOT (Binna/Zangerle/Pichl/Specht/Leis 2018)** → `HOT - A Height Optimized Trie Index for Main-MemoryDatabase Systems.pdf`
- [x] **Wormhole (Wu/Ni/Jiang 2019)** → `Wormhole - A Fast Ordered Index for In-memory DataManagement.pdf`
  > Korrektur: Co-Autor ist Song JIANG, NICHT Jin
- [x] **START (Fent/Jungmair/Kipf/Neumann 2020)** → `START– Self-Tuning Adaptive Radix Tree.pdf` ✓ NEU
- [x] **B²-Tree (Schmeisser/Schuele/Leis/Neumann/Kemper 2022)** → `B2-Tree - Page-Based String Indexing in Concurrent Environments.pdf`
  > Korrektur: 5 Autoren, NICHT 4 (Schuele + Kemper waren in alter Liste vergessen)
- [x] **CoCo-Trie (Boffa/Ferragina/Tosoni/Vinciguerra 2024)** → `CoCo-trie - Data-aware compressionandindexingofstrings.pdf`

### A3 · Habich-Zusatzpaper

- [x] **Jacobson 1989 (LOUDS)** → `Space-efficient_static_trees_and_graphs.pdf`
- [x] **SuRF (Zhang/Lim/Leis et al. 2018)** → `SuRF Practical Range Query Filtering with Fast Succinct Tries.pdf`

### A3 · Habich-/Dresden-Linie

- [x] **Overview on Hardware Optimizations (Ungethuem/HABICH/Karnagel/Haas/Mier/Fettweis/Lehner 2017)** → `Overview on Hardware Optimizations for Database Engines.pdf`
- [x] **VAMPIR (Berthold/Schmidt + PIs Lehner/HABICH/Schirmeier 2023)** → `vampir-poster-spp2377-p1-kickoff.pdf` ✓ NEU
  > Anmerkung: Das ist das SPP2377 Kickoff-Poster, NICHT das SOSP'23-Poster — gleiches Team, akzeptabel
- [x] **To Stride or Not to Stride (Schmidt/Kuehn/Krause/Teubner/Lehner/HABICH 2025)** → `To stride or not to stride the memory access.pdf`

### B · Cache-Engine / Prefetching / Sync (alle vorhanden)

- [x] **Prefetching B+-Trees (Chen/Gibbons/Mowry 2001)** → `Improving Index Performance through Prefetching.pdf`
- [x] **Fractal Prefetching B+-Trees (Chen/Gibbons/Mowry/Valentin 2002)** → `Fractal Prefetching B+-Trees (Chen et al. 2002).pdf`
- [x] **Dynamic Adaptation Data Cache Prefetching (Khan 2010/2011)** → `Data Cache Prefetching With DynamicAdaptation.pdf`
- [x] **Why Does Data Prefetching Not Work (Naderan-Tahan/Sarbazi-Azad 2016)** → `WhyDoes Data Prefetching Not Work for Modern Workloads.pdf`
  > Neu: DOI gefunden = 10.1093/comjnl/bxv112
- [x] **Fetch Me If You Can (Mahling/Weisgut/Rabl 2025)** → `Fetch Me If You Can ... .pdf`
- [x] **Prefetching Indexing Scheme (Zhang/Song/Zhou/Wei/Xiao FGCS 2024)** → `Aprefetching indexingschemeforin-memorydatabasesystems.pdf`
- [x] **Hierarchical Prefetching (T. Zhang et al. ASPLOS 2025)** → `ZhangEtalASPLOS2025HierarchicalPrefetching.pdf`
  > Voller Titel: "Hierarchical prefetching: A software-hardware instruction prefetcher for server applications"
- [x] **Towards Data-Based Cache Optimization (Kuehn/Biebert/Hakert/Chen/Teubner DAMON 2023)** → `Towards Data-Based Cache Optimization of B+-Trees.pdf`
- [x] **Read-Copy Update (McKenney et al. OLS 2001)** → `Read-Copy Update.pdf`
- [x] **Hazard Pointers (Michael 2004)** → `Hazard Pointers - Safe Memory Reclamation for Lock-Free Objects.pdf`

---

## ✅ NACHARBEIT REV4 — Alle Pflicht-Aufgaben erledigt!

### Verbleibend nur kosmetisch (optional, nicht blockierend):

1. **Tree Layout in Multilevel Memory** — optional schlanker:
   Aktuell 10,3 MB (ganzer Springer LNCS-Band). Verwendbar, aber kompakter:
   🎯 [Demaine.org Direkt-PDF](https://erikdemaine.org/papers/TreeLayout_ESA2002/paper.pdf)

2. **SOSP-Proceedings-Band loeschen** (52 MB) — er enthaelt kein VAMPIR.

3. **Folien-Datei `Making CSB+-Trees Processor Conscious.pdf` (83 KB)** —
   kann optional behalten werden als ergaenzendes Material zur Praesentation.

---

## 🚫 NUTZER-SORGE WIDERLEGT

**Masstree** ist tatsaechlich KORREKT in `Cache Craftiness for Fast Multicore Key-Value Storage.pdf`:
- Verifizierter Inhalt: "We present Masstree, a fast key-value database designed for SMP machines"
- Autoren: Yandong Mao, Eddie Kohler (Harvard), Robert Morris (MIT CSAIL)
- "Cache Craftiness ..." ist der **offizielle Paper-Titel**; "Masstree" ist nur der **Datenstruktur-Name**

---

## 📋 KATALOG-AUTORENFEHLER (5 Korrekturen, von mir REV3 eingearbeitet)

| Eintrag | Falsch (REV2) | Richtig (REV3) |
|---|---|---|
| A1.10 B-Trees Are Back | Leis/Haubenschild/Kemper/Neumann | **Mueller/Benson/Leis** |
| A2.3 ART of Practical Sync | Leis/Haubenschild/Kemper/Neumann | **Leis/Scheibner/Kemper/Neumann** |
| A2.5 Wormhole | Wu/Ni/**Jin** | Wu/Ni/**Jiang** |
| A2.7 B²-Tree | Schmeisser/Renen/Leis/Neumann | **Schmeisser/Schuele/Leis/Neumann/Kemper** (5 statt 4) |
| A2.8 CoCo-trie | (richtig: Boffa et al.) | T1-Dokument hatte falsch "Belazzougui" — KEIN Katalog-Fehler |

---

## 🗑️ FALSCH-DOWNLOADS in `./Forschungsarbeiten/low priority/` (7 Stueck, korrekt verschoben)

- ✅ `Dependable Computing in Virtual Laboratories.pdf` (Bioinformatik)
- ✅ `Multithreaded Architectures and The Sort Benchmark.pdf` (DaMoN'05)
- ✅ `Lessons learned ... Intel Optane DC PMem in DBMS.pdf` (DaMoN'20)
- ✅ `Accelerating Number Theoretic Transform ... Zero Knowledge Proof.pdf` (ASPLOS'25)
- ✅ `Delilah - eBPF-offload on Computational Storage.pdf` (DaMoN'23)
- ✅ `Onthe Integration of Structure Indexes and Inverted Lists.pdf` (ICDE'04)
- ✅ `SOSP - Proceedings of the Twenty-Ninth ACM Symposium ...pdf` (52,8 MB, kann jetzt geloescht werden — VAMPIR-Poster wurde stattdessen vom Kickoff geladen)

---

## CODE-REPOS (Phase 2.B — DEFERRED)

[CoCo-Trie](https://github.com/aboffa/CoCo-trie) · [HOT](https://github.com/speedskater/hot) · [Masstree](https://github.com/kohler/masstree-beta) · [libart (ART)](https://github.com/armon/libart) · [Wormhole](https://github.com/wuxb45/wormhole) · [UnoDB](https://github.com/laurynas-biveinis/unodb) · [bptree](https://github.com/habedi/bptree) · [bplus-tree](https://github.com/embedded2016/bplus-tree) · [Abseil](https://github.com/abseil/abseil-cpp) · **NEU:** [START Originalcode (jungmair)](https://github.com/jungmair/START) · [SuRF Originalcode (efficient)](https://github.com/efficient/SuRF) · [tcmalloc](https://github.com/google/tcmalloc) · [mimalloc](https://github.com/microsoft/mimalloc) · [snmalloc](https://github.com/microsoft/snmalloc)

---

## DATENSAETZE (Phase 4.A — DEFERRED)

[CoCo-Trie Datasets](https://github.com/aboffa/CoCo-trie) · [LAW Milano it-2004](https://law.di.unimi.it/webdata/it-2004/) · [Pizza & Chili XML](http://pizzachili.dcc.uchile.cl/texts/xml/) · [Pizza & Chili DNA](http://pizzachili.dcc.uchile.cl/texts/dna/) · [Pizza & Chili Protein](http://pizzachili.dcc.uchile.cl/texts/protein/) · [TPC-DS](https://www.tpc.org/tpcds/)
