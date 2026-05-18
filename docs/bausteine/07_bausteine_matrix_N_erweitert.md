# Bausteine-Matrix N-Phase Erweiterung — 14 Achsen + Sub-Achsen (Detail)

**Stand:** 2026-05-18 (N.1-N.10 Phase, alle gleichzeitig erledigt)
**Vorgaenger:** `01_bausteine_matrix.md` §16 (Erweiterungs-Tabelle Kurzform)
**Trigger:** User-Direktive 2026-05-18 (5 Anmerkungen zur Bausteine-Matrix)
**Konzept-Ebenen-Klarstellung:** `../architektur/11_axes_vs_strategies_disambiguation.md` (Ebene I)
**Pflicht-Pre-Read:** `../architektur/10_schichten_modell_M.md` (M-Modell 4-Subsysteme)

---

## §1 Achse 3 TRAVERSAL — Split in 3.A + 3.B + 3.M

### §1.1 Motivation (User-Direktive 2026-05-18 verbatim)

> "Die Traversal Axe ist nicht feingliedrig getrennt in die Suchalgorithmus-Seite vs die dadurch getriggerte Cache-Seite. **Das Ziel ist immer die Uebersetzung der nicht Cache-Koherenten Konzepte der Entwickler auf dem Suchalgorithmus in die Cache-Mechanik auf der CacheEngine Seite, welche die Realitaet auf den tatsaechlichen Cache-Aware Memory-Seiten abbilden muss; dazwischen gibt es immer eine Mapping Strategie mit Suchalgorithmus-Traversal -> Cache-Memory-Traversal.**"

### §1.2 Sub-Achse 3.A SearchAlgo-Traversal

Wie der **Suchalgorithmus konzeptionell** durch seine Datenstruktur traversiert (Algorithmus-Seite, nicht-Cache-kohaerente Sicht des Entwicklers).

| Sub-Baustein | Quelle | Beschreibung |
|---|---|---|
| `TRAVERSAL_3A_BYTEBYBYTE` | P01 ART | 1 Byte/Schritt |
| `TRAVERSAL_3A_DISCRIMINATIVE_BITS` | P02 HOT | Bit-Vektor-Sprung |
| `TRAVERSAL_3A_LAYER_SLICE` | P03 Masstree | Layer-Pop nach 8 Bytes |
| `TRAVERSAL_3A_MACRO_NODE` | P04 CoCo | Macro-Node-Jump |
| `TRAVERSAL_3A_MULTIBYTE_SPAN` | P05 START | k-Byte-Span variabel |
| `TRAVERSAL_3A_EMBEDDED_DEC_TREE` | P06 B²-Tree | Embedded Decision Tree |
| `TRAVERSAL_3A_PATRICIA_SPLIT` | P09 Patricia | Single-Bit-Split |
| `TRAVERSAL_3A_HASH_ANCHOR` | P07 Wormhole | Hash-Anchor-Lookup |
| `TRAVERSAL_3A_BPLUS_RANGE` | P11/P12 CSS/CSB+ | B+-Range-Walk |
| `TRAVERSAL_3A_FRACTAL` | P22 Fractal | Recursive Sub-Tree-Jump |
| `TRAVERSAL_3A_LOUDS_BITPOS` | P09/P10 LOUDS/SuRF | Bit-Position-Encoded |
| `TRAVERSAL_3A_REDIRECT_CHAIN` | PRT-ART | Redirect-Knoten-Chain |
| `TRAVERSAL_3A_PRTART_SUBSEARCH` | PRT-ART | Subsearch Typ A/B/C/D |

### §1.3 Sub-Achse 3.B Cache-Memory-Traversal

Wie die **CacheEngine die physische Cache-Memory traversiert** (Cache-Seite, hardware-nahe Realitaet).

| Sub-Baustein | Quelle | Beschreibung |
|---|---|---|
| `TRAVERSAL_3B_CACHELINE_WALK` | (Default) | 64 B Cache-Line/Schritt |
| `TRAVERSAL_3B_PREFETCH_STRIDE` | P21 Chen | Stride-Prefetch-Walk |
| `TRAVERSAL_3B_PAGE_JUMP` | (NUMA-aware) | 4 KB Page-Jump |
| `TRAVERSAL_3B_HBM_NEAR` | P32 Schmidt | HBM-Near-Bank-Walk |
| `TRAVERSAL_3B_CACHE_OBLIVIOUS` | P17 Bender | Cache-Oblivious-Recursion |
| `TRAVERSAL_3B_HIERARCHICAL_BUNDLE` | P27 hp-soft | L1/L2/L3 Bundle-Walk |

### §1.4 Sub-Achse 3.M Traversal-Mapping-Strategy

Wie 3.A auf 3.B uebersetzt wird (Mapping zwischen Algorithmus-Konzept und Cache-Realitaet).

| Sub-Baustein | Quelle | Beschreibung |
|---|---|---|
| `TRAVERSAL_3M_LINEAR_1TO1` | (Trivial-Default) | 1 Algo-Step = 1 Cache-Line-Walk |
| `TRAVERSAL_3M_HASH_REDIRECT` | P07 Wormhole | Hash-Map zu Cache-Adresse |
| `TRAVERSAL_3M_HIERARCHICAL_PAGE_FAULT` | (LRU-Cache) | Algo-Step erzeugt evtl. Page-Fault |
| `TRAVERSAL_3M_PERMUTATION_INDEX` | P03 Masstree | permutation_index pro INode |
| `TRAVERSAL_3M_REDIRECT_OFFSET` | PRT-ART | VirtualOffsetCalculator |
| `TRAVERSAL_3M_BUNDLE_HINT` | P27 Bundle | Bundle-Granularity-Hint |

**Mapping-Pflicht:** Pro Algorithmus muss klar sein, welche 3.A-Variante mit welcher 3.B-Variante ueber welche 3.M-Strategie verbunden wird. **Triple (3.A, 3.B, 3.M) pro Permutation.**

---

## §2 Achse 6 ALLOCATOR — Split in 6.1-6.5

### §2.1 Motivation (User-Direktive 2026-05-18 verbatim)

> "Allokations-Strategien in Feingliedrig (Unterkategorien hast du schon genannt aber noch als Hauptstrategien, die eigentlich unter diesen Punkt gehoeren)"

### §2.2 Sub-Achsen 6.1-6.5

| Sub-Achse | Name | Beispiele | Quelle |
|---|---|---|---|
| **6.1 Allocation-Strategy** | Wie wird Speicher allokiert? | slab, buddy, region, pool, object-cache, stack-allocator | Allokator-Matrix AA1 |
| **6.2 Reclamation-Policy** | Wann wird Speicher freigegeben? | epoch, RCU, hazard-pointer, QSBR, mark-sweep | P29/P30 + Allokator-Matrix AA4 |
| **6.3 NUMA-Affinity** | Wo (auf welchem Node)? | local, interleave, preferred, bind, none | P31 Ungethuem + Allokator-Matrix AA5 |
| **6.4 Huge-Page-Policy** | Welche Page-Groesse? | transparent (THP), explicit (madvise), none | (Linux/Talos OS) |
| **6.5 Free-List-Strategy** | Wie wird Free-Liste organisiert? | size-class, best-fit, first-fit, segregated-fit | Allokator-Matrix AA3 |

### §2.3 PRT-ART Konsequenz

PRT-ART 4+2 Pool-Familie (Pool A/B/C/D/R/V-static/V-dynamic, K05e):
- **6.1 = pool** (object-cache pro Suchtyp)
- **6.2 = epoch oder RCU** (TBD — O.1 Audit)
- **6.3 = local** (TBD — O.1 Audit)
- **6.4 = transparent** (TBD — O.1 Audit)
- **6.5 = size-class + bucket-strategy** (Frage 15 GPT, K05e)

---

## §3 Achse 8 CONCURRENCY — Split in 8.1 + 8.2

### §3.1 Motivation (User-Direktive 2026-05-18 verbatim)

> "concurrency patterns+locking read only oder read/write"

### §3.2 Sub-Achse 8.1 Concurrency-Pattern

Wie wird Concurrency strukturiert? (Pattern-Familie)

| Pattern | Quelle | Beispiele |
|---|---|---|
| **OLC** (Optimistic Lock Coupling) | P08 ART-Sync | PRT-ART default |
| **HTM** (Hardware Transactional Memory) | (Intel TSX) | (optional, Hardware-abhaengig) |
| **STM** (Software Transactional Memory) | (akademisch) | (akademisch) |
| **lock-free** | P30 Michael Hazard | Hazard-Pointer-basiert |
| **wait-free** | (Herlihy 1991) | (selten in DB-Engines) |
| **RCU** (Read-Copy-Update) | P29 McKenney | Linux-Kernel-Standard |
| **HP** (Hazard-Pointer) | P30 Michael | siehe lock-free |

### §3.3 Sub-Achse 8.2 Locking-Mode

Wie sind Locks orientiert? (Read-only/Read-write/Optimistic)

| Mode | Beispiele | Anwendung |
|---|---|---|
| **read-only** (shared) | std::shared_mutex | nur Read-Tree (PRT-ART Tree-Pfad) |
| **read-write** (exclusive) | std::mutex | Schreiboperationen (Buffer) |
| **upgradeable** | boost::shared_mutex (upgrade lock) | hybride RW-Sequenzen |
| **optimistic-validation** | OLC, HTM | PRT-ART Hauptmode |

### §3.4 PRT-ART Konsequenz

PRT-ART K05g: OLC + Reserved-Value-Blocks + Lock-Free-Reader
- **8.1 = OLC + lock-free** (kombiniert)
- **8.2 = mixed: read-only (Tree-Pfad) + optimistic-validation (Updates) + read-write (Value-Buffer)**

---

## §4 Achse 11 TELEMETRY-COLLECTION — Kuehn-Erweiterung 2026-05-08

### §4.1 Motivation (Kuehn-Mail 2026-05-08, persistiert via L.1 #452)

Kuehn (P28 DaMoN 2023) hat 3 Telemetry-Varianten + 1 Anti-Pattern beschrieben.

### §4.2 Sub-Strategien 11.X1-X4

| Sub-Strategie | Beschreibung | Kuehn-Status |
|---|---|---|
| **11.X1 Leaf-Only-Counter** | Counter NUR in Blatt-Knoten, vermeidet Cache-Line-Ping-Pong | **Kuehn Hauptvariante** |
| **11.X2 Sampling** | Nur jeder n-te Zugriff im Blatt-Knoten gezaehlt, konfigurierbarer Trade-off | Kuehn Erweiterung |
| **11.X3 Offline-Recompute** | Vor Reordering bottom-up Aufsummierung von Blatt zur Wurzel | Kuehn Standard-Verfahren |
| **11.X4 Inner-Node-Counter** | Counter in ALLEN Knoten (auch inneren) | **ANTI-PATTERN** (Cache-Line-Ping-Pong) |

### §4.3 Kuehn-Quote (verbatim)

> "Insbesondere auf die Knoten in den oberen Ebenen des Baums wird sehr haeufig zugegriffen, sodass diese typischerweise im Caches mehrerer Kerne liegen. Zusaetzliche Schreibzugriffe fuehren dann durch die Cache-Kohaerenzmechanismen schnell zu starkem Cacheline-Ping-Pong zwischen den Kernen, was die Performance entsprechend beeintraechtigt."

---

## §5 Achse 12 HARDWARE-STRATEGY (NEU) — Was nutzt der Algorithmus aktiv?

### §5.1 Motivation (User-Direktive 2026-05-18 verbatim)

> "eine Axe fuer verwendete Hardwarestrategien"

**Wichtige Abgrenzung:** Achse 12 ist **NICHT** identisch mit K09 C8 Cache-Hardware-Probing-Heuristik (siehe `../architektur/11_axes_vs_strategies_disambiguation.md` §4 Verwirrung 2). Achse 12 = was der **Algorithmus AKTIV nutzt**. K09 C8 = wie die **CE die Hardware ENTDECKT**.

### §5.2 Sub-Achsen 12.1-12.5

| Sub-Achse | Beschreibung | Beispiele |
|---|---|---|
| **12.1 SIMD-Family** | Welche Vector-ISA? | AVX2, AVX-512, NEON, SVE2, scalar (none) |
| **12.2 Cache-Level-Targeting** | Welcher Cache-Level wird optimiert? | L1-aware, L2-aware, L3-aware, HBM-aware |
| **12.3 NUMA-Strategy** | NUMA-Topologie-Beruecksichtigung | single-node, multi-node, NUMA-aware-pinning, NUMA-balanced |
| **12.4 Prefetch-Hardware** | Welche HW-Prefetch-Instruktionen? | PREFETCH, PREFETCHNTA, PREFETCHW, none |
| **12.5 Atomic-Instruction-Family** | Welche Atomic-RMW? | CAS, LL-SC, RMW-extended (HTM via XBEGIN/XEND), none |

### §5.3 PRT-ART Konsequenz

PRT-ART bisher nicht explizit dokumentiert auf Achse 12. O.3 (#476) muss `prt_art/hardware/prt_art_hardware_strategy.hpp` anlegen mit:
- 12.1 SIMD-Family = AVX2 (default) oder auto-detected
- 12.2 Cache-Level-Targeting = L1-aware (TLB-Offset + cache-line-aligned aus K05c)
- 12.3 NUMA-Strategy = local (default, ggf. konfigurierbar)
- 12.4 Prefetch-Hardware = PREFETCH (Distance-Estimator) + PREFETCHNTA (Redirect-Path)
- 12.5 Atomic-Family = CAS (OLC) + LL-SC (Reserved-Block-Token)

---

## §6 Achse 13 SCHEDULING-STRATEGY (NEU) — Wie wird Arbeit verteilt?

### §6.1 Motivation (User-Direktive 2026-05-18 verbatim)

> "eine Axe fuer Scheduling Strategien (SIMD Erweiterungen sind limitiert auf die Anzahl der Verfuegbaren SIMD Einheiten die mit CPU Kernen gekoppelt werden koennen - meist nur 2 stueck auf dutzende Kerne, die anderen Kerne muessen normal parallel weiter laufen)"

**Wichtige Beobachtung:** SIMD-Einheiten sind hardware-limitiert (typ. 2 von N Cores haben SIMD). Scheduling muss SIMD-faehige Worker separat zaehlen von normalen Worker-Threads.

### §6.2 Sub-Achsen 13.1-13.5

| Sub-Achse | Beschreibung | Beispiele |
|---|---|---|
| **13.1 Worker-Pool-Layout** | Wie sind Workers organisiert? | thread-per-core, work-stealing, CPU-pinning, free-pool |
| **13.2 SIMD-Worker-Count-Limit** | Wie viele SIMD-Worker max? | typ. 2 von N Cores (Hardware-Limit!), 1, 4, all |
| **13.3 Heterogeneous-Core-Dispatch** | P-cores vs E-cores (Intel Hybrid) | P-only, E-only, hybrid-aware, none |
| **13.4 Co-Routine-Strategy** | Wie werden Co-Routines verschachtelt? | interleave (Stride-Prefetch), dependency-tracking, none |
| **13.5 Batch-Granularity** | Wie gross sind Batches? | single (kein Batch), micro-batch (1-100), macro-batch (1K+) |

### §6.3 PRT-ART Konsequenz

PRT-ART bisher nicht explizit dokumentiert auf Achse 13. O.3 (#476) muss `prt_art/scheduling/prt_art_scheduling_strategy.hpp` anlegen mit:
- 13.1 Worker-Pool-Layout = thread-per-core (default fuer 4+2 Pool-Familie)
- 13.2 SIMD-Worker-Count-Limit = 2 (Hardware-Default, ueber Achse 12.1 SIMD-Family konfigurierbar)
- 13.3 Heterogeneous-Core-Dispatch = hybrid-aware fuer i9 14900KS (P-cores fuer Tree-Walk, E-cores fuer Background-Reorder)
- 13.4 Co-Routine-Strategy = interleave (kann mit Distance-Estimator-Prefetch kombiniert werden)
- 13.5 Batch-Granularity = micro-batch (typ. 16-64 Lookups pro Coro-Iteration)

---

## §7 Konsequenzen fuer abhaengige Doks

### §7.1 02_allokator_matrix.md (N.9 #472)

Allokatoren als Bausteine pro Sub-Achse 6.1-6.5 statt 7 Hauptachsen AA1-AA7. AA1 -> 6.1, AA2 -> 6.4, AA3 -> 6.5, AA4 -> 6.2, AA5 -> 6.3, AA6/AA7 als Sonderfaelle (Concurrent + Special).

### §7.2 03_cross_paper_konzeptmatrix.md (N.8 #471)

2 neue Spalten: "Hardware-Strategy" (welche 12.X-Auspraegung) + "Scheduling-Strategy" (welche 13.X-Auspraegung) pro Paper.

### §7.3 05_flag_system.md (N.10 #473)

Banks 1-9 erweitern auf 14 Banks. Sub-Bank-Encoding fuer 3.A/3.B/3.M, 6.1-6.5, 8.1+8.2, 12.1-12.5, 13.1-13.5. Total: 14 Banks + Sub-Bank-Bitfields.

### §7.4 00_INDEX.md (N.7 #470)

Achsen-Tabelle von 11 auf 14 erweitern.

---

## §8 Konsequenzen fuer PRT-ART (O-Phase Trigger)

PRT-ART Pflicht-Audit (O.1 #474):
- Pro Hauptachse 1-13 + Sub-Achse: existiert eine PrtArt*-Klasse?
- Wenn nicht: anlegen via O.3 (#476)

Pruefling-Neuartigkeits-Qualifikation (O.2 #475): PRT-ART qualifiziert bereits durch:
- Achse 1 (PAGE_PRTART_*)
- Achse 5 (TLB-Offset + cache-line-aligned)
- Achse 6.5 (Bucket-Strategy 4+2 Pools)
- Achse 7 (Distance-Estimator)
- Achse 8.1 (OLC + Reserved-Blocks)

Damit ist "mind. 1 voellig neuartige Implementation in mind. 1 Achse" mehrfach erfuellt.

---

## §9 Cross-Refs

- `01_bausteine_matrix.md` §16 (Erweiterungs-Tabelle Kurzform)
- `02_allokator_matrix.md` (Allokator-Matrix, wird N.9 angepasst)
- `03_cross_paper_konzeptmatrix.md` (Cross-Paper, wird N.8 angepasst)
- `05_flag_system.md` (Flag-System, wird N.10 angepasst)
- `00_INDEX.md` (Index, wird N.7 angepasst)
- `../architektur/10_schichten_modell_M.md` (M-Modell, Pflicht-Pre-Read)
- `../architektur/11_axes_vs_strategies_disambiguation.md` (Anti-Vermischung, Pflicht-Pre-Read)
- `../sessions/20260518-4800-mail-auswertung-drawio-feedback-vermischungen-M-N-O-P-Q-R-phasen.md` (Session 4800)

---

**Ende 07_bausteine_matrix_N_erweitert.md (N-Phase DONE).**
