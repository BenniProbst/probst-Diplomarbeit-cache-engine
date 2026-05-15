# Begriffsglossar v7 — Konsolidierter Master

**Stand:** 2026-05-15 (K-D.2)
**Quelle:** Konsolidierung von `Begriffsglossar_v3_FINAL.txt` bis `Begriffsglossar_v7_FINAL.txt`
(alle in `../termine/20260508 Termin 7/`)
**Aufbau:** Index aller KANON-Begriffe ueber 5 Versionen + Verweis auf Original-Quelle mit Zeilennummer
**Format:** Markdown mit Tabelle pro Domaene; Detail-Definition in Original-Quelle bleiben (Memory-Direktive "niemals Doku loeschen")

---

## §1 Versions-Stack (Konfliktregel: spaetere Version gewinnt)

| Version | Datum | Hauptthema | LOC | Status |
|---|---|---|---|---|
| v1 | (Vorstufe) | Begriffsglossar Domaenenmodell-Vorstufe | 496 | abgeloest |
| v2 | (legacy) | Erste konsolidierte Form | (n/a) | abgeloest |
| v3 | 2026-05-04 | Master mit Paper-Belegen P01-P33 | 1287 | Hauptmasse |
| v4 | (Phase 5) | Architektur-Pattern, Engine-Choice, Concepts, std::map-API | 533 | Delta zu v3 |
| v5 | (F1-F15) | Beschluss-Begriffe: DecisionLambdaTree, In-Memory-Buffer, ABI-Module, F15-Bausteine-Quer-Permutation, ConcurrencyManager | 462 | Delta zu v4 |
| v6 | (F-EXTRA) | Korrekturen + F-EXTRA: Flag-System, Heap-Singleton-im-Builder, Compiler-Layering, Bausteine-Trees, Default-Hooks, Google-Tests | 366 | Delta zu v5 |
| v7 | 2026-05-09 | Kuehn-Erkenntnisse + Production-Plattform + Forschungs-Mission | 284 | Delta zu v6 |

**Total:** ~3.144 Zeilen, ~161 KANON-Begriffe.

---

## §2 Domaene 1 — Such-Algorithmen-Bausteine (v3, Zeilen 56-507)

### 2.1 Strukturelle Primitive — Knotenfamilie

| Begriff | Synonyme (Auszug) | Quelle (Z) |
|---|---|---|
| **KNOTEN (Node)** | Trie Node, Internal/Border Node, Decision Node, Span Node, Macro-Node, Compound Node, Vertex | v3:63 |
| **SEITE / PAGE** | Page, Block, Suchseite, Page-Cluster, Disk Block, Cache-Line-grosser Knoten | v3:82 |
| **SEITENTYP / PAGE TYPE** | Node Family, Node Layout, Encoding, Page Format, Multibyte Node, Adaptive Layout, Macro-Node Encoding | v3:100 |
| **PFAD / SUCHPFAD** | Search Path, Root-to-Leaf Path, Traversal, Lookup Path, Hot Path, Frequent Access Path | v3:125 |
| **PRAEFIXKOMPRESSION** | Path Compression, Lazy Expansion, Patricia Bits, Discriminative Bits, Span, Prefix Truncation, Subtrie Collapse, Compressed Path | v3:142 |
| **REDIRECT** | Macro-Node, Anchor, Shortcut Node, Rewiring/Rewired Node, Jump Pointer, Multi-byte branching | v3:163 |
| **FANOUT** | Branching Factor, Children Count, Degree, Span | v3:183 |
| **HOEHE / TIEFE** | Tree Height, Depth, Tree Levels/BFS-Levels, Layers | v3:195 |

### 2.2 Value-Handles + Operationen

| Begriff | Synonyme (Auszug) | Quelle (Z) |
|---|---|---|
| **VALUEHANDLE** | (zentraler PRT-ART-Begriff) | v3:210 / v4:321 (KORRIGIERT) |
| **INLINE VALUE** | (Value im Knoten) | v3:223 |
| **EXTERNAL VALUE** | (Value extern referenziert) | v3:231 |
| **HOT/COLD-SPLIT** | (Trennung Hot/Cold Values) | v3:237 |
| **CHAINREF** | (vertagt — Termin 2 Designentscheidung) | v3:243 |
| **VALUEHANDLE-KIND** | Enum, je Node konfigurierbar | v4:327 |
| **VALUEHANDLE-SWITCH-ARRAY** | Compile-Time-Wahl | v4:335 |
| **DYNAMIC VALUEHANDLE** | Runtime-Wahl | v4:344 |

### 2.3 Such- und Schreib-Operationen

| Begriff | Synonyme (Auszug) | Quelle (Z) |
|---|---|---|
| **EXACT LOOKUP** | (Punkt-Anfrage) | v3:252 |
| **PREFIX LOOKUP** | (Praefix-Anfrage) | v3:262 |
| **PREFIX ENUMERATION / RANGE SCAN** | (Bereich-Scan) | v3:272 |
| **RANGE-FILTER** | NEU mit SuRF integriert | v3:284 |
| **BULK BUILD** | (Batch-Aufbau) | v3:298 |
| **CRUD-OPERATIONEN** | (Insert/Update/Delete/Query) | v3:305 |

### 2.4 Modi (Sortier-Strategien)

| Begriff | Quelle (Z) |
|---|---|
| **UNSORTED MODE** | v3:316 |
| **LOCAL ORDERING** | v3:324 |
| **LEX MODE** | v3:334 |

### 2.5 Succinct-Familie (P09 LOUDS, P10 SuRF)

| Begriff | Quelle (Z) |
|---|---|
| **SUCCINCT TREE-ENCODING** | v3:347 |
| **LOUDS-ENCODING** (Level-Ordered Unary Degree Sequence) | v3:362 |
| **LOUDS-DENSE** | v3:374 |
| **LOUDS-SPARSE** | v3:384 |
| **LOUDS-DS** (Hybrid) | v3:394 |
| **RANK / SELECT** | v3:408 |

### 2.6 Layout-Strategien (P11/P12/P13/P14/P20)

| Begriff | Quelle (Z) |
|---|---|
| **CACHE-LINE-NODE** (CSS-Knoten, P11) | v3:421 |
| **NODE GROUP / SIBLING-CLUSTERING** (CSB+, P12) | v3:432 |
| **WIDER NODES** (P13 Hankins) | v3:443 |
| **CONFIGURATION TABLE** (P14 Samuel) | v3:456 |
| **ADAPTIVE LAYOUT** (P20 B-Trees Are Back) | v3:466 |

### 2.7 Hybrid-Strukturen

| Begriff | Quelle (Z) |
|---|---|
| **TRIE-OF-B+-TREES** (Masstree) | v3:484 |
| **TRIE-HASH-B+ HYBRID** (Wormhole) | v3:495 |
| **MACRO-NODE** (CoCo-trie) | v3:505 |

---

## §3 Domaene 4 — Hardware/ISA (v3, Zeilen 524-679)

### 3.1 Cache-Hierarchie

| Begriff | Quelle (Z) |
|---|---|
| **CACHE LINE** | v3:524 |
| **CACHE-EBENE** | v3:534 |
| **WORKING SET** | v3:543 |
| **TLB** (Translation Lookaside Buffer) | v3:550 |
| **CACHE-AWARENESS-MODI** (Termin 4 Kategorisierung) | v3:563 |

### 3.2 Cache-Metriken

| Begriff | Quelle (Z) |
|---|---|
| **CACHE LINE UTILIZATION (CLU)** | v3:593 |
| **CACHE MISS** | v3:602 |
| **dTLB-MISS** | v3:609 |
| **MEMORY FOOTPRINT** | v3:617 |
| **BRANCH MISS / BRANCH MISPREDICTION** | v3:624 |
| **CYCLES PER INSTRUCTION (CPI) / IPC** | v3:629 |
| **LATENZ** | v3:635 |
| **DURCHSATZ** | v3:642 |
| **PREFETCH** | v3:652 |

---

## §4 Domaene 2 — Cache-Engine-Bausteine (v4, Zeilen 35-449)

### 4.1 Engines (CACHE / STATIC / WAHL)

| Begriff | Quelle (Z) |
|---|---|
| **CACHE ENGINE** (Top-Level-Definition, KORRIGIERT) | v4:35 |
| **STATIC ENGINE** | v4:55 |
| **ENGINE-CHOICE** | v4:62 |

### 4.2 Design-Pattern

| Begriff | Quelle (Z) |
|---|---|
| **OBSERVER PATTERN** (im Cache-Engine-Kontext) | v4:67 |
| **VISITOR PATTERN** (im Cache-Engine-Kontext) | v4:76 |
| **STRATEGY PATTERN** (Algorithmus-Wahl) | v4:84 |
| **ADAPTER PATTERN** (Originalcode-Anbindung — HABICH-DIREKTIVE) | v4:90 |
| **SINGLETON** (CacheEngineRuntime + ConcurrencyManager) | v4:98 |
| **COMMAND PATTERN** (im Cache-Engine-Kontext) | v5:54 |

### 4.3 Cache-Engine-Builder + Runtime

| Begriff | Quelle (Z) |
|---|---|
| **CACHE ENGINE BUILDER** (Compile-Time-Programm) | v4:110 |
| **CACHE ENGINE RUNTIME** (Runtime-Modul, Heap, global) | v4:120 |
| **LIVE CPU-MODELL** | v4:127 |
| **COMPILE TIME KNOWLEDGE** | v4:133 |
| **RUNTIME MICRO BENCHMARK** | v4:138 |
| **TELEMETRY SPOOL** | v4:144 |
| **ENGINE WRAPPER** | v4:153 |
| **STATIC RUN** | v4:158 |
| **CACHE RUN** | v4:162 |

### 4.4 Familien-Klassifikation (35 Algorithmen)

| Begriff | Quelle (Z) |
|---|---|
| **FAN-OUT ENGINE** | v4:170 |
| **TRIE-FAMILIE** (vollstaendige Recherche) | v4:175 |
| **B-TREE-FAMILIE** (vollstaendige Recherche) | v4:192 |
| **HYBRID-FAMILIE** | v4:210 |
| **SUCCINCT-FAMILIE** | v4:219 |
| **SPEZIAL-FAMILIE** | v4:225 |

### 4.5 std::map-API + Concepts

| Begriff | Quelle (Z) |
|---|---|
| **std::map-API-VERTRAG** | v4:235 |
| **TRANSPARENT COMPARE** | v4:278 |
| **IMPLICIT KEY OVERLAY** | v4:283 |
| **C++23 CONCEPT** | v4:292 |
| **ALGO-MATCH** | v4:311 |

### 4.6 Concurrency Manager + Reclamation

| Begriff | Quelle (Z) |
|---|---|
| **CONCURRENCY MANAGER** (Singleton in CacheEngineRuntime) | v4:353 |
| **RCU-RECLAIM** (BLEIBT — Default fuer Online-Relocation) | v4:373 |
| **HAZARD POINTERS** (ENTFERNT vs v3) | v4:377 |

### 4.7 Permutation Engine

| Begriff | Quelle (Z) |
|---|---|
| **PERMUTATION ENGINE** | v4:386 |
| **PERMUTATION** | v4:392 |
| **CONSTRAINT FILTER** | v4:396 / v5:178 / v5:374 |
| **CONSTEXPR CODEGEN** | v4:401 |
| **COMPILER DRIVER** | v4:405 |
| **BUILDER MEASUREMENT** | v4:409 |
| **MEASUREMENT DB** | v4:414 |
| **LATEX RENDERER** | v4:424 |

### 4.8 Habich-Direktive + Submodule-Ausnahme

| Begriff | Quelle (Z) |
|---|---|
| **HABICH-DIREKTIVE** | v4:432 |
| **COMDARE-MODULES-SUBMODULES** (Ausnahme zur No-Submodules-Regel) | v4:448 |

---

## §5 Beschluss-Begriffe F1-F15 (v5)

### 5.1 DecisionLambdaTree + Command-Pattern

| Begriff | Quelle (Z) |
|---|---|
| **DECISIONLAMBDATREE** | v5:32 |
| **ENTSCHEIDUNGSKLASSE** | v5:60 |
| **EXECUTE / DELAY / SKIP** (DecisionLambdaTree-Outcomes) | v5:64 |
| **KONSOLIDIERUNGSBARRIERE** | v5:74 |
| **IN-MEMORY MEASUREMENT BUFFER** | v5:106 |

### 5.2 ABI-Module + Permutations-Build-Pipeline

| Begriff | Quelle (Z) |
|---|---|
| **ABI-STABILES C++23-MODUL** | v5:131 |
| **MODUL-PERMUTATION** | v5:138 |
| **PERM_ID** | v5:142 |
| **MODULE LOADER** | v5:147 / v5:383 |
| **PERMUTATIONS-BUILD-PIPELINE** | v5:156 |
| **ORIGINAL-COMPILER-PIPELINE** (F7) | v5:165 |

### 5.3 F4 + Pre-Build + AdHoc

| Begriff | Quelle (Z) |
|---|---|
| **CONSTRAINT FILTER** (F4) | v5:178 |
| **PRE-BUILD PHASE** | v5:183 |
| **ADHOC BUILD** | v5:188 |

### 5.4 Cache-Warmup + Reset + Experiment-Loop

| Begriff | Quelle (Z) |
|---|---|
| **CACHE-WARMUP ALS PERMUTATIONSBESTANDTEIL** | v5:197 |
| **CACHEENGINE.RESET()** | v5:204 |
| **EXPERIMENT-LOOP** (CacheEngineBuilder) | v5:210 |

### 5.5 Init-Modi (Compile-Time vs Runtime)

| Begriff | Quelle (Z) |
|---|---|
| **COMPILE-TIME-MODUS** (CacheEngine-Init) | v5:226 |
| **RUNTIME-MODUS** (CacheEngine-Init) | v5:232 |
| **MUTUALLY EXCLUSIVE** | v5:237 |

### 5.6 Mess-Kategorien × Algorithmus-Detail

| Begriff | Quelle (Z) |
|---|---|
| **MESS-KATEGORIE x ALGORITHMUS-DETAIL MATRIX** | v5:245 |
| **MEASUREMENT CATEGORY** (Achse 10 der Bausteine-Matrix) | v5:264 |
| **ALGORITHM DETAIL** (Mess-relevante Granularitaet) | v5:277 |

### 5.7 F15 Bausteine-Quer-Permutation

| Begriff | Quelle (Z) |
|---|---|
| **BAUSTEINE-QUER-PERMUTATION** | v5:290 |
| **BAUSTEINE-MATRIX** | v5:298 |
| **ALGORITHM-DETAIL-MODULE** (eine Bausteine-Implementation = ein Modul) | v5:314 |
| **UNIVERSAL-VERGLEICH** (CacheEngine-Universalitaet) | v5:319 |

### 5.8 Plattform-Workflow + Concurrency Composition

| Begriff | Quelle (Z) |
|---|---|
| **PLATTFORM-WORKFLOW** | v5:328 |
| **SOCKS5-LIEFERUNG** | v5:346 |
| **CROSS-COMPILE-INFRASTRUKTUR** | v5:350 |
| **CONCURRENCY COMPOSITION** (Policy-Template) | v5:358 |
| **POLICY TEMPLATE** | v5:365 |

---

## §6 F-EXTRA Begriffe (v6)

### 6.1 Flag-System + Permutation-Identifier

| Begriff | Quelle (Z) |
|---|---|
| **PERMUTATIONS-FLAG-SYSTEM** | v6:30 |
| **FLAG-BANK** | v6:41 |
| **PERMUTATION-IDENTIFIER** (wohl geordnet) | v6:56 |
| **CONSTRAINTFILTER ALS BIT-MASKIERUNG** | v6:68 |
| **CACHEENGINE-LOKATION** (KORRIGIERT) | v6:84 |
| **RESSOURCEN-INJEKTION** (CacheEngine → Modul) | v6:98 |
| **ENTSCHEIDUNGSZUSTAND-GENERIERUNG** (Observer-Slot) | v6:107 |

### 6.2 Compiler-Layering

| Begriff | Quelle (Z) |
|---|---|
| **HAUPTCOMPILER** (C++23) | v6:123 |
| **ORIGINAL-COMPILER** (Bausteine) | v6:129 |
| **STATIC LINKING** (Bausteine in Modul) | v6:134 |
| **ABI-MULTI-COMPILER-PIPELINE** | v6:142 |
| **COMPILER-PROVISIONING** | v6:151 |

### 6.3 Bausteine-Tree

| Begriff | Quelle (Z) |
|---|---|
| **BAUSTEINE-DECISIONLAMBDATREE** | v6:163 |
| **TREE-KOMPOSITION** (Algorithmus aus Bausteinen) | v6:170 |

### 6.4 Metaprogrammierung + Cross-Build

| Begriff | Quelle (Z) |
|---|---|
| **METAPROGRAMMIERUNG VS BINARY-IDENTITAET** | v6:185 |
| **CROSS-BUILD AUF X86-HOST** | v6:197 |
| **STAGE-2 NATIVE BUILD** (Verifikation) | v6:201 |
| **COMPILER-VERSION-WAHL** (egal) | v6:207 |
| **PERMUTATION-CODEGEN-SKRIPT** | v6:215 |

### 6.5 Default-Mess-Hooks + Tests

| Begriff | Quelle (Z) |
|---|---|
| **DEFAULT-MESS-HOOK** | v6:230 |
| **ALGO-SPEZIFISCHER OVERRIDE** | v6:242 |
| **HASMEASUREMENT-CONCEPT-CONSTRAINT** | v6:255 |
| **GENERISCHE GOOGLE TESTS** (CacheEngineBuilder) | v6:265 |
| **SPEZIFISCHE GOOGLE TESTS** (pro Modul) | v6:272 |
| **ABI-STABILITAETS-TEST** (CI) | v6:280 |
| **HABICH-LOG** (Bei Bit-Abweichung) | v6:290 |

### 6.6 Lieferung + CI

| Begriff | Quelle (Z) |
|---|---|
| **SOCKS5-ZIH-LIEFERUNG** (Default) | v6:307 |
| **GITLAB-CI-PUSH-ERWEITERUNG** | v6:314 |
| **FORTIGATE-31G-EDGE** | v6:321 |

---

## §7 Kuehn-Erkenntnisse + Plattform + Mission (v7, Zeilen 30-249)

### 7.1 Cache-Kohaerenz (P28 Kuehn)

| Begriff | Quelle (Z) |
|---|---|
| **CACHE-COHERENCE-ANTI-PATTERN** (Cache-Kohaerenz-Ping-Pong) | v7:33 |
| **NOT-IN-TOP-LEVELS-CONSTRAINT** | v7:58 |

### 7.2 LeafOnly-Counter-Familie

| Begriff | Quelle (Z) |
|---|---|
| **LEAFONLY-COUNTER** | v7:71 |
| **RETROACTIVE-AGGREGATION** | v7:95 |
| **LEAFONLY-SAMPLED-COUNTER<N>** | v7:117 |
| **SAMPLING-RATE-ADJUSTMENT-TREE** (PRT-ART eigene Erweiterung) | v7:141 |
| **CACHE-COHERENCE-COST** (Cost-Funktion in MemoryAccessConcurrency::Write) | v7:162 |

### 7.3 Production-Plattform (Probst-Antwort an Kuehn 2026-05-08)

| Begriff | Quelle (Z) |
|---|---|
| **PRODUCTION-CLUSTER-SPEZ** (K8s/Talos, 9950X3D + 14900KS) | v7:192 |
| **X3D-V-CACHE-AWARENESS** | v7:207 |

### 7.4 Forschungs-Mission

| Begriff | Quelle (Z) |
|---|---|
| **FORSCHUNGS-MISSION** (heuristisch vs informiert + automatische Anpassung) | v7:224 |

---

## §8 Notations-Konvention (durchgaengig v3-v7)

```
[KANON]    Kanonischer PRT-ART-Begriff (was wir benutzen)
    SYN  ← "Synonym X" [Pxx Quelle]      ← Cross-Paper Aequivalenz mit P-ID
    BED  Funktionale Bedeutung (was tut der Begriff?)
    BEL  Beleg (Zitat-Schnipsel mit Paper-ID + Seite/Abschnitt)
    ABG  Abgrenzung gegen aehnliche, aber NICHT identische Begriffe
    BEZ  PRT-ART-Bezug (warum ist das fuer uns relevant?)
```

---

## §9 Paper-Legende (P-IDs ↔ vollstaendige Quelle)

Identisch zu v3, vollstaendige Vollangaben siehe `../forschungslandkarte/01_quellen_gesamtkatalog.md` (K-F.2 in Arbeit).

| P-ID | Kurzform | Tier |
|---|---|---|
| P01 | ART (Leis 2013) | 1 |
| P02 | HOT (Binna 2018) | 1 |
| P03 | Masstree (Mao 2012) | 1 |
| P04 | CoCo-trie (Boffa 2024) | 1 |
| P05 | START (Fent 2020) | 1 |
| P06 | B²-tree (Schmeisser 2022) | 1 |
| P07 | Wormhole (Wu 2019) | 1 |
| P08 | ARTSync (Leis 2016) | 1 |
| P09 | Jacobson 1989 (LOUDS) | 1 (Habich-Zusatz) |
| P10 | SuRF (Zhang 2018) | 1 (Habich-Zusatz) |
| P11 | CSS-tree (Rao/Ross 1999) | 2 |
| P12 | CSB+-tree (Rao/Ross 2000) | 2 |
| P13 | Hankins 2003 (B-Tree Width) | 2 |
| P14 | Samuel 2005 (Config Table) | 2 |
| P15 | Graefe 2001 (Survey) | 2 |
| P16 | Bender Tree Layout (2002) | 2 |
| P17 | Bender Cache-Oblivious (2005) | 2 |
| P18 | Saikkonen 2008 (Multi-Level Reloc) | 2 |
| P19 | Saikkonen 2016 (Layout-Invariante) | 2 |
| P20 | B-Trees Are Back (Mueller 2025) | 2 |
| P21 | Chen PB-Trees (2001) | 3 |
| P22 | Chen Fractal Prefetching (2002) | 3 |
| P23 | Khan 2010 (Adaptive Prefetch) | 3 |
| P24 | NaderanTahan 2016 (Useless Prefetch) | 3 |
| P25 | Mahling 2025 (Fill Buffer) | 3 |
| P26 | Zhang FGCS 2024 (Read Counter) | 3 |
| P27 | Zhang ASPLOS 2025 (Hierarchical) | 3 |
| P28 | Kuehn DAMON 2023 (Histogram/HotPath) | 3 |
| P29 | RCU (McKenney 2001) | 3 |
| P30 | Hazard Pointers (Michael 2004) | 3 |
| P31 | Ungethuem 2017 (TUD Hardware) | 3 (Habich) |
| P32 | To Stride or Not (TUD 2025) | 3 (Habich) |
| P33 | VAMPIR (TUD/SPP2377 2023) | 3 (Habich) |

---

## §10 Querverweise

- Original-Quellen (UNVERAENDERT, Memory-Direktive "niemals Doku loeschen"):
  - `../termine/20260508 Termin 7/Begriffsglossar_v7_FINAL.txt`
  - `../termine/20260508 Termin 7/Begriffsglossar_v6_FINAL.txt`
  - `../termine/20260508 Termin 7/Begriffsglossar_v5_FINAL.txt`
  - `../termine/20260508 Termin 7/Begriffsglossar_v4_FINAL.txt`
  - `../termine/20260508 Termin 7/Begriffsglossar_v3_FINAL.txt`
  - `../termine/20260508 Termin 7/Begriffsglossar_Domaenenmodell_Vorstufe.txt` (v1)
- Domaenenmodell: `02_domaenenmodell_v4_master.md` (K-D.3)
- Versionshistorie Detail: `03_versionshistorie.md` (K-D.4)
- Cross-Paper-Konzeptmatrix: `../bausteine/03_cross_paper_konzeptmatrix.md` (K-E.4)

---

## §11 Konsolidierungs-Hinweis

Dieses Dokument ist ein **Index der Begriffs-Identitaeten** ueber 5 Versionen.
Die voll-ausgeschriebenen Definitionen mit BED/BEL/ABG/BEZ-Paragraphen bleiben
in den Original-Versionen unter `../termine/20260508 Termin 7/Begriffsglossar_v*.txt`.
Konfliktregel: spaetere Version gewinnt (v7 > v6 > v5 > v4 > v3 > v2 > v1).

Pflicht-Pre-Read fuer alle Sessions: `../MASTERPLAN_KONSOLIDIERUNG_TERMINE.md`.
