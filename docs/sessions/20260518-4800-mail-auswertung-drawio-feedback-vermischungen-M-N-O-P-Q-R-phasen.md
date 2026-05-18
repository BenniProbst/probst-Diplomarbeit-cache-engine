# Session 4800 — Mail-Auswertung 2026-05-18 + drawio-Feedback + Vermischungs-Analyse + M-N-O-P-Q-R Phasen

**Datum:** 2026-05-18 (Tag 3 nach Termin 8 Vorbereitung)
**Vorgaenger:** `20260515-4700-K-A-bis-K-G-konsolidierungssprint-finale-bilanz.md`
**Nachfolger:** (zu schreiben nach M-Phase Abschluss)
**Hauptauftraege heute:**
1. 3 E-Mail-Verlaeufe auswerten (Kuehn P28, Schuele P06, Zhang P27)
2. 44 drawio-JPGs transkribieren + Ist-vs-Soll-Diskrepanz pruefen
3. Schichten-Klarstellung Diplomarbeit -> CacheEngineBuilder + CacheEngine -> Pruefling
4. Bausteine-Matrix-Achsen-Erweiterung (5 User-Anmerkungen)
5. PRT-ART als Bausteine-Spiegel zur CacheEngine pruefen
6. Zurueckgestellte Aufgaben freigeben

---

## §0 EXECUTIVE SUMMARY

| Block | Inhalt | Status |
|---|---|---|
| **L** Email-Integration | 3 Mails (Kuehn/Schuele/Zhang) ausgewertet + Code-Drops im Code/-Verzeichnis dokumentieren | 6 Tasks angelegt (#452-457) |
| **M** Schichten-Klarstellung | Diplomarbeit -> CEB (autonom) -> CE (Werkzeug) <-> Pruefling | 6 Tasks angelegt (#458-463) |
| **N** Bausteine-Matrix-Erweiterung | 11 -> 14 Achsen + Sub-Achsen | 10 Tasks angelegt (#464-473) |
| **O** PRT-ART Spiegel | Achsen-Audit + Reuse-Matrix + Template-Erweiterung | 6 Tasks angelegt (#474-479) |
| **P** drawio REV8 | Schichten-Korrektur + Bausteine-Matrix + PRT-ART Spiegel | 6 Tasks angelegt (#480-485) |
| **Q** Freigaben | Datasets + F-EXTRA freigegeben | 4 Tasks angelegt (#486-489) |
| **R** Vermischungs-Analyse | 12 weitere Diskrepanzen aus tiefer K-Bild-Analyse | 12 Tasks angelegt (#490-501) |
| **Closed in dieser Session** | #74 (E-Mails da) + #442 (drawio-JPGs exportiert) | 2 Tasks done |

**Total neue Pending-Tasks:** 50 (40 + 10 R) — verteilt ueber 7 Phasen L bis R.

---

## §1 EMAIL-AUSWERTUNG (3 Verlaeufe, alle abgeschlossen)

### §1.1 Roland Kuehn (P28 DaMoN 2023) — Code-Anfrage

**Verschickt vom User:** 2026-05-07 02:45, Re-Mail 2026-05-08 17:48
**Kuehn-Antwort:** 2026-05-08 10:35:47

**Kuehn-Zusage:**
- Code wird grundsaetzlich zur Verfuegung gestellt
- "experimenteller Evaluationscode, kein sauber gekapseltes Framework"
- Kuehn raeumt vorher auf + dokumentiert
- Code-Link noch nicht da, aber zugesagt

**Wichtigste Erkenntnisse fuer PRT-ART:**

> "Insbesondere auf die Knoten in den oberen Ebenen des Baums wird sehr haeufig zugegriffen, sodass diese typischerweise im Caches mehrerer Kerne liegen. Zusaetzliche Schreibzugriffe fuehren dann durch die Cache-Kohaerenzmechanismen schnell zu starkem Cacheline-Ping-Pong zwischen den Kernen, was die Performance entsprechend beeintraechtigt."

**Loesungs-Variante (Kuehn aktuell verwendet):**
1. **Leaf-Only-Counter**: Zugriffsinformationen NUR in Blatt-Knoten (nicht in oberen Ebenen)
2. **Offline-Recompute**: Vor Reordering werden alle Blaetter bottom-up zur Wurzel traversiert + Counter aufsummiert
3. **Sampling-Variante**: Nur jeder n-te Zugriff im Blatt-Knoten gezaehlt, konfigurierbarer Genauigkeit-vs-Overhead-Tradeoff
4. **NAIVE Variante** (Counter in allen Knoten) hatte Ping-Pong-Problem — explizit als Anti-Pattern dokumentieren

**Plattform-Info vom User mitgeteilt:**
- K8s Cluster auf Talos OS
- Ryzen 9 9950X3D + i9 14900KS
- 64GB RAM bei 5600 MIT DDR5, Latenz 36 Zyklen

**Soll-Persistierung:**
- `docs/forschungslandkarte/06_cluster_E_prefetching_telemetry.md` (P28-Sektion)
- `docs/bausteine/01_bausteine_matrix.md` (Achse 11 TELEMETRY-COLLECTION-STRATEGY, NEU 11.X1-11.X4)

**Task:** L.1 (#452) — Persistieren der Kuehn-Erkenntnisse

### §1.2 Maximilian E. Schuele (P06 B²-Tree + bart-master) — Code-Drop

**Verschickt vom User:** 2026-05-07 10:32 + 2026-05-08 01:09 (Folgemail Postfach-voll-Problem)
**Schuele-Antwort:** 2026-05-08 23:37:22 (Nextcloud-Links)

**Schuele-Zusage erfuellt:**
- Link 1: `https://nextcloud.in.tum.de/index.php/s/xXEw2SGfGeWNfjA`
- Link 2: `https://nextcloud.in.tum.de/index.php/s/63M9YqazFQDS2TR`

**User-Quote 2026-05-13 23:35:** "Dankeschoen, das hat geklappt"

**Vorgeschichte:**
- B²-Tree-Code lag urspruenglich in https://gitlab.db.in.tum.de/MaxEmanuel/bart (privat)
- bart-master basiert auf Viktors B-ART (private)
- Schuele bot github-Hinzufuegung an, dann Nextcloud-Transfer

**Task:** L.2 (#453) — bart-master + B²-Tree in `adapters/P06-B2tree/` einsortieren

### §1.3 Tingji Zhang + Boris Grot (P27 ASPLOS '25 hp-soft) — Demo-Paket

**Verschickt vom User:** 2026-05-08 18:59 (an zyh02@tsinghua + Boris.Grot@ed.ac.uk + CC Habich)
**Boris Grot Weiterleitung:** 2026-05-10 21:36 (an Tingji)
**Tingji Zhang Antwort:** 2026-05-11 14:16:38

**Zhang-Zusage erfuellt:**
- Small demo package mit Python-Script + README
- "captures core bundle-selection logic"
- "useful reference for adapting the idea to your PRT-ART implementation"
- Inhalt: example processing script + call graph analysis process

**License-Kontext:**
- Paper: ASPLOS '25 (DOI 10.1145/3676641.3716260)
- License: **CC-BY (open access via Edinburgh Research Explorer)**
- CRAFT-THU/gem5-hp Repo war schon lokal (BSD-3)

**Task:** L.3 (#454) — hp-soft Demo-Paket-Verifikation + Integration in V31.K5-Port pruefen

### §1.4 Status-Audit der 5 ehemals offenen Anfragen

| Paper | Empfaenger | Status |
|---|---|---|
| P06 Schuele | Maximilian Schuele (Uni Bamberg) | ✅ Code via Nextcloud (Mail 2026-05-08) |
| P27 Zhang/Grot | Tingji Zhang (Tsinghua) | ✅ hp-soft Demo (Mail 2026-05-11) |
| P28 Kuehn | Roland Kuehn (TU Dortmund DBIS) | ✅ Code zugesagt, sendet noch |
| P31 Ungethuem | Habich-Team | ⏸ keine Antwort, User-Direktive 2026-05-18: keine Folge-Mails |
| P32 Schmidt | Habich-Team | ⏸ analog |
| P33 VAMPIR | Habich-Team | ⏸ analog |

User-Direktive 2026-05-18: **"Mehr Nachrichten werden wir nicht erhalten."** Damit ist #74 (5 Anfragen warten) abgeschlossen.

---

## §2 DRAWIO REV7 ANALYSE — 44 Tabs transkribiert (Stichproben)

### §2.1 Kernkritik des Users (verbatim)

> "Probleme sehe ich besonders in der Uebersicht zur Darstellung der Schichten Diplomarbeit -> CacheEngineBuilder/CacheEngine -> Algorithmuspruefling (wie PRT-ART), weil CacheEngineBuilder und CacheEngine formal 2 getrennte Systeme sind, die dennoch zum selben Projekt gehoeren. Der CacheEngineBuilder ist ein autonomes System zum Ausmessen einer Plattform, waehrend die CacheEngine dabei als Werkzeug verwendet wird. Die CacheEngine kann einen registrierten Pruefling (PRT-ART) als Struktur ueber alle Permutationen mit einbinden und dessen Konfigurationen gegenpruefen, waehrend dieser die CacheEngine mit benutzt, um die eigene Performance auszumessen und zu optimieren."

### §2.2 Soll-Modell (User-Direktive 2026-05-18)

```
┌──────────────────────────────┐
│ Diplomarbeit/Code/           │
│ messung_driver               │  Auswertung-Orchestrator
│ (Outer Loop)                 │  + XML-Configs (Messreihen A/B/C)
└──────────────┬───────────────┘
               │ konfiguriert/triggert
               ▼
┌──────────────────────────────┐
│ CacheEngineBuilder           │  AUTONOMES Subsystem
│ (Plattform-Ausmess-System)   │  PIKA-aehnlich
│                              │  enumeriert Permutationen
└──────────────┬───────────────┘
               │ verwendet als Werkzeug
               ▼
┌──────────────────────────────┐         ┌────────────────────┐
│ CacheEngine                  │ <-----> │ Pruefling (PRT-ART)│
│ (Werkzeug-Bibliothek)        │ (bidi)  │ registriert als    │
│ - 12 Sub-Engines C1-C12      │         │ ExecutionEngine    │
│ - 29 Cache-Strategien F1-F29 │         │                    │
│ - ~85 Heuristiken            │         │ nutzt CE als       │
│                              │         │ Optimierungs-      │
│ verwendet PRT-ART als        │         │ Service            │
│ Permutations-Struktur        │         │                    │
└──────────────────────────────┘         └────────────────────┘
```

### §2.3 Diskrepanz pro kritischem Tab (Stand REV7, 2026-05-18)

| Tab | Aktuell (IST) | Korrektur-Soll | Task |
|---|---|---|---|
| **REV7-Master** | 3 Spalten cache-engine/prt-art/Diplomarbeit (Repos) | 4-Box-Schema mit Subsystemen + bidirektionalem CE<->PRT-ART | M.3 (#460) |
| **K01** Drei-Ebenen | IExecutingEngine / SaeuleA / SaeuleB | CacheEngineBuilder als META-Ebene + bidirektionale CE<->Pruefling | M.4 (#461) |
| **K03** ICacheStrategy V1-V4 | V1-V4 als Permutations-Builds | V1-V4 = ENGINE-CHOICE-DIMENSION; CEB orchestriert Enumeration | R.9 (#498) |
| **K05** PRT-ART Bausteinkombination | 7-Quellen-Hybrid + 4-Schichten-Freeze | Pro Achse 1-14 eine PRT-ART-Klasse + Reuse-Status | O.4 (#477) |
| **K05b** 4 Suchtypen | PRT-ART internal A/B/C/D | Sub-Achse von Achse 2 oder D10 Permutationsdimension | R.5 (#494) |
| **K05e** 4+2 Pools | Per-Suchtyp + Per-Value Pool | Achse 6 Sub-Achse "Per-Type-Pool-Multiplicity" | R.6 (#495) |
| **K05g** Multi-Reader-Writer | OLC + Reserved-Blocks | Klaeren ob CE-Disziplin Reuse oder PRT-ART eigen | R.7 (#496) |
| **K06** S1-S30 Such-Familien | 30 Such-Engine-Strategien | Strikt von K10/F1-F29 trennen | R.4 (#493) |
| **K09** Hardware-Probing C8 | CE-INTERNAL Heuristik | NICHT mit Algorithmus-Achse 12 verwechseln | R.3 (#492) |
| **K10** 29 Cache-Familien | F1-F29 Cache-INTERNAL-Strategien | Klar: keine Algorithmus-Achsen; Beschriftung | R.1 (#490) |
| **K11** Phase 1-7 Pipeline | Monolithisch | CEB-Spalte vs CE-Spalte trennen | P.5 (#484) |
| **K12** F15-Forschungsmission | F15-Familie + Forschungs-Cross | F15-Familie (K10) vs F15-Mission strikt trennen | R.10 (#499) |
| **K15** ICacheEngine C1-C12 | 12 Sub-Engines | Klar: CE-Services NICHT Algorithmus-Achsen | R.2 (#491) |
| **U10** prt_art-UML | CEB "steuert" IPermutationEngine | bidirektional CE<->PRT-ART | M.5 (#462) |

### §2.4 Identifizierte 4-Konzept-Ebenen (Anti-Vermischung)

Aus den K-Bildern wird klar dass es **4 verschiedene Konzept-Ebenen** gibt, die haeufig vermischt werden:

1. **Bausteine-Achsen 1-13** = Algorithmus-Permutations-Dimensionen
   - Was variiert pro Algorithmus? (PAGE/NODE/TRAVERSAL/VALUE/LAYOUT/ALLOC/PREFETCH/CONCURRENCY/ISA/TELEMETRY/HARDWARE/SCHEDULING)
2. **CE-Sub-Engines C1-C12** = CE-INTERNAL Services
   - Was bietet die CacheEngine als Dienstleistung?
3. **Cache-Strategien F1-F29** = konkrete Implementationen der CE-Sub-Engines
   - Welche Strategien hat C3 Cache-Prefetch-Engine? (F9-F14)
4. **Such-Engine-Familien S1-S30** = konkrete Implementationen der Algorithmus-Permutationen
   - Welche Such-Strategien hat ein Algorithmus auf Achse 1 PAGE-TYPE?

**Pflicht:** docs/architektur/11_axes_vs_strategies_disambiguation.md (R.11 #500) schreiben + drawio-Tab visualisieren (R.12 #501).

---

## §3 BAUSTEINE-MATRIX — User-Erweiterungs-Anmerkungen

### §3.1 Aktueller Stand (11 Achsen, V31 2026-05-15)

```
Achse 1  PAGE-TYPE       (26 Bausteine)
Achse 2  NODE-TYPE       (13 Bausteine)
Achse 3  TRAVERSAL       (14 Bausteine)
Achse 4  VALUEHANDLE     (5 Bausteine)
Achse 5  MEMORY-LAYOUT   (8 Bausteine)
Achse 6  ALLOCATOR       (7 Bausteine + 23 Allokator-Paper extern)
Achse 7  PREFETCH        (6 Bausteine)
Achse 8  CONCURRENCY     (8 Disziplinen + 3 Mechaniken)
Achse 9  ISA             (Bank 9)
Achse 10 MEASUREMENT     (F1 Matrix)
Achse 11 TELEMETRY-COLL  (6 Bausteine, Kuehn 2026-05-09)
```

### §3.2 User-Anmerkungen 2026-05-18 (verbatim)

| Anmerkung | Konsequenz | Task |
|---|---|---|
| "Allokations-Strategien in Feingliedrig (Unterkategorien hast du schon genannt aber noch als Hauptstrategien, die eigentlich unter diesen Punkt gehoeren)" | Achse 6 ALLOCATOR splitten in 6.1-6.5 (Allocation/Reclamation/NUMA/HugePage/FreeList) | N.1 (#464) |
| "concurrency patterns+locking read only oder read/write" | Achse 8 splitten: 8.1 Pattern + 8.2 Locking-Mode | N.2 (#465) |
| "eine Axe fuer verwendete Hardwarestrategien" | **NEU Achse 12 HARDWARE-STRATEGY** | N.3 (#466) |
| "eine Axe fuer Scheduling Strategien (SIMD Erweiterungen sind limitiert auf die Anzahl der Verfuegbaren SIMD Einheiten die mit CPU Kernen gekoppelt werden koennen - meist nur 2 stueck auf dutzende Kerne, die anderen Kerne muessen normal parallel weiter laufen)" | **NEU Achse 13 SCHEDULING-STRATEGY** mit SIMD-Limit-Bewusstsein | N.4 (#467) |
| "Traversal Axe ist nicht feingliedrig getrennt in die Suchalgorithmus-Seite vs die dadurch getriggerte Cache-Seite" + "Mapping Strategie mit Suchalgorithmus-Traversal -> Cache-Memory-Traversal" | Achse 3 splitten: 3.A Algo-Traversal + 3.B Cache-Traversal + 3.M Mapping | N.5 (#468) |

### §3.3 Neue 14-Achsen-Struktur (Soll)

```
Achse 1   PAGE-TYPE               (26)
Achse 2   NODE-TYPE               (13)
Achse 3.A SearchAlgo-Traversal    (14)
Achse 3.B Cache-Memory-Traversal  (NEU)
Achse 3.M Traversal-Mapping       (NEU)
Achse 4   VALUEHANDLE             (5)
Achse 5   MEMORY-LAYOUT           (8)
Achse 6.1 Allocation-Strategy     (slab/buddy/region/pool/...)
Achse 6.2 Reclamation-Policy      (epoch/RCU/HP/QSBR)
Achse 6.3 NUMA-Affinity           (local/interleave/preferred)
Achse 6.4 Huge-Page-Policy        (transparent/explicit/none)
Achse 6.5 Free-List-Strategy      (size-class/best-fit/first-fit)
Achse 7   PREFETCH                (6)
Achse 8.1 Concurrency-Pattern     (OLC/HTM/STM/lock-free/wait-free/RCU/HP)
Achse 8.2 Locking-Mode            (read-only/read-write/optimistic)
Achse 9   ISA                     (Bank 9)
Achse 10  MEASUREMENT             (F1 Matrix)
Achse 11  TELEMETRY-COLL          (6, mit Kuehn-Erweiterung)
Achse 12  HARDWARE-STRATEGY       (NEU: SIMD/Cache-Level/NUMA/Prefetch-HW/Atomic-Family)
Achse 13  SCHEDULING-STRATEGY     (NEU: Worker-Pool/SIMD-Limit/Hetero-Core-Dispatch/Co-Routine/Batch)
```

**Total geschaetzt:** 85 -> ca. 120 Bausteine nach Verfeinerung.

---

## §4 PRT-ART ALS BAUSTEINE-SPIEGEL (User-Direktive 2026-05-18)

### §4.1 Direktive (verbatim)

> "Aus meiner Sicht verhaelt sich das Pruefling-Modul noch nicht wie der Baustein-Axen Turm der CacheEngine in der alle bereits dem Stand der Technik zugeordneten Bestandteile aufgelistet sind. Wenn der PRT-ART nicht ebenfalls alle diese Axen detailliert benennen und konstruieren kann, dann ist der PRT-ART nicht nach den Standards der CacheEngine konstruierbar. Das bedeutet es muss immer mindestens eine PRT-ART Klasse fuer jede Baustein Axe geben, welche durch ihre Modul-Implementierung entweder den Stand der Technik erweitert oder diesen bestehenden Stand aus der CacheEngine in einer Permutations-Konfiguration wiederverwendet. Ein neuartiger Algorithmus hat mindestens eine voellig neuartige Implementierung in mindestens einem Detail einer Axe."

### §4.2 Soll-Audit pro PRT-ART-Achse

| Achse | Aktueller PRT-ART | Reuse/Neu-Status |
|---|---|---|
| 1 PAGE-TYPE | PAGE_PRTART_DENSEBYTE / EXTENDEDDENSE / ... | (b) Neu-Impl |
| 2 NODE-TYPE | NODE_PRTART_REDIRECT + NODE_PRTART_BPLUS | (b) Neu-Impl |
| 3.A Algo-Traversal | byte-by-byte mit Density-Schwellen | (b) Neu-Impl Sub-Idee |
| 3.B Cache-Traversal | (Default Cache-Line-Walk reuse?) | (?) AUDIT pending |
| 3.M Mapping | VirtualOffsetCalculator | (b) Neu-Impl |
| 4 VALUEHANDLE | Inline/External/ChainRef | (a) Reuse aus K05 Konzept |
| 5 MEMORY-LAYOUT | TLB-Offset + Cache-Line-Aligned | (b) Neu-Impl |
| 6.1 Allocation | 4+2 Pool-Familie (per Suchtyp) | (b) Neu-Impl |
| 6.2 Reclamation | (Default? RCU? Epoch?) | (?) AUDIT pending |
| 6.3 NUMA | (Default local?) | (?) AUDIT pending |
| 6.4 HugePage | (Default transparent?) | (?) AUDIT pending |
| 6.5 Free-List | Bucket-Strategy (Frage 15 GPT) | (b) Neu-Impl |
| 7 PREFETCH | Distance-Estimator + Path-Oriented + Redirect | (b) Neu-Impl + HierarchicalBundlePrefetcher (P27 Reuse) |
| 8.1 Pattern | OLC + reservierte Value-Bloecke + Lock-free-Reader | (b) Neu-Impl Kombination |
| 8.2 Locking | mixed (read-only Tree + write-only Buffer) | (b) Neu-Impl |
| 9 ISA | (Default AVX2?) | (?) AUDIT pending |
| 10 MEASUREMENT | Density-Tracker + H1/H2/H3-Metriken | (b) Neu-Impl |
| 11 TELEMETRY | (Default Path-Counter?) | (?) AUDIT pending |
| **12 HARDWARE (NEU)** | (?) FEHLT | (?) Achse anlegen + entscheiden |
| **13 SCHEDULING (NEU)** | (?) FEHLT | (?) Achse anlegen + entscheiden |

**Beobachtung:** PRT-ART hat in 12/14 Achsen klare Neu-Impl/Reuse. Fuer 12 HARDWARE und 13 SCHEDULING fehlt aktuell die explizite PrtArt*-Klasse — muss angelegt werden (O.3 #476).

**Neuartigkeits-Qualifikation:** PRT-ART hat in Achse 1, 2, 3.A, 3.M, 5, 6.1, 6.5, 7, 8.1, 10 jeweils Neu-Implementationen — qualifiziert als "neuartiger Algorithmus" (mind. 1 voellig neuartiges Detail in einer Achse erfuellt).

### §4.3 PrtArtSearchEngine Template-Parameter-Erweiterung

Aktuell **12 Template-Parameter** (K05/U10):
```cpp
template <Key, Value,
          SerializationStrategy, AllocA, AllocB, AllocC, AllocD, AllocR, AllocV,
          TypeTransitionPolicy, FingerprintFilter, ConcurrencyStrategy>
class comdare::prt_art;
```

**Soll: 14 Template-Parameter** (analog Achsen 1-13 + Sub-Achsen):
```cpp
template <Key, Value,
          // Achse 1+2
          PageStrategy, NodeStrategy,
          // Achse 3 (gesplittet)
          AlgoTraversal, CacheTraversal, TraversalMapping,
          // Achse 4+5
          ValueHandle, MemoryLayout,
          // Achse 6 (gesplittet)
          AllocStrategy, ReclamationPolicy, NumaAffinity, HugePagePolicy, FreeListStrategy,
          // Achse 7
          PrefetchStrategy,
          // Achse 8 (gesplittet)
          ConcurrencyPattern, LockingMode,
          // Achse 9+10+11
          IsaTarget, MeasurementStrategy, TelemetryStrategy,
          // Achse 12+13 NEU
          HardwareStrategy, SchedulingStrategy>
class comdare::prt_art;
```

**Default-Variants** pro Parameter so dass alte Aufrufe weiterhin funktionieren. Tests in Phase O.6 (#479).

---

## §5 ANTI-VERMISCHUNG (R-Phase, 12 zusaetzliche Diskrepanzen)

| R-Task | Vermischung | Klarstellung |
|---|---|---|
| R.1 #490 | K10/F1-F29 vs Bausteine-Achsen | F = CE-INTERNAL, nicht Algo-Achse |
| R.2 #491 | K15/C1-C12 vs Algo-Achsen 6/7/12/13 | C = CE-Services, von Algo KONSUMIERT |
| R.3 #492 | K09 Hardware-Probing C8 vs Achse 12 HARDWARE | C8 = was probet CE, Achse 12 = was nutzt Algo |
| R.4 #493 | K06/S vs K10/F Hybrid-Aufloesungen | S = Algo-Such-Strategie, F = CE-Cache-Strategie |
| R.5 #494 | K05b 4 Suchtypen A/B/C/D | Sub-Achse von Achse 2 oder D10 Permutationsdimension |
| R.6 #495 | K05e 4+2 Pools vs Allokator-Matrix | 7 Pool-INSTANZEN, nicht 7 verschiedene Allokatoren |
| R.7 #496 | K05g Concurrency vs Achse 8 | Klaeren ob Reuse CE-Disziplin oder PRT-ART eigen |
| R.8 #497 | K04 4-Ebenen vs Achsen | K04 = Implementations-Tiefe, Achsen = Permutations-Dimensionen |
| R.9 #498 | K03 V1-V4 Builds vs CEB-Autonomie | CEB orchestriert V1-V4, CE instantiiert |
| R.10 #499 | K12 F15-Familie vs F15-Mission | F15-Familie = Baustein (K10), F15-Mission = Forschungsziel |
| R.11 #500 | docs/architektur/11_disambiguation.md | Master-Anti-Vermischung schreiben |
| R.12 #501 | drawio REV8: Anti-Vermischung Tab | 4-Schichten-Visualisierung |

---

## §6 CODE-AUDIT — "loose im Code-Verzeichnis" (User-Hinweis 2026-05-18)

User-Quote: **"Der code dafuer wurde schon loose in das code verzeichnis eingefuegt."**

**Wo:** vermutlich
- `Diplomarbeit - Datenbanken/_archive_code_pre_migration/` (existiert seit 2026-05-11)
- `Diplomarbeit - Datenbanken/Code/external/comdare-cache-engine/adapters/` (P06-B2tree, P28-DaMoN noch nicht da?)
- `Diplomarbeit - Datenbanken/Forschungsarbeiten/` (vermutlich)

**Task L.4 (#455):** Audit pruefen welche Schuele/Kuehn/Zhang-Code-Drops loose liegen + in `comdare-cache-engine/adapters/<id>/` einsortieren. Adapter-Skelette mit Original-Code fuellen.

**Erwartung:**
- P06 B²-Tree code aus Nextcloud-Links -> `adapters/P06-B2tree/ext/`
- P28 Kuehn code (sobald da) -> `adapters/P28-DaMoN-LeafCounter/ext/`
- P27 hp-soft (schon V31.K5 portiert) -> Verify ob neue Mail-ZIP weiter geht als die alte hp-soft.zip

---

## §7 OFFENE PENDING-TASKS NACH DIESER SESSION

### §7.1 Pending pro Phase (Stand 2026-05-18 nach Task-Anlage)

| Phase | Tasks | Anzahl |
|---|---|---|
| Infra (alte) | #77, #95, #109, #111 | 4 |
| L Email-Integration | #452-457 | 6 |
| M Schichten-Klarstellung | #458-463 | 6 |
| N Bausteine-Matrix-Erweiterung | #464-473 | 10 |
| O PRT-ART Spiegel | #474-479 | 6 |
| P drawio REV8 | #480-485 | 6 |
| Q Freigaben zurueckgestellt | #486-489 | 4 |
| R Vermischungs-Analyse | #490-501 | 12 |
| **TOTAL** | | **54** |

### §7.2 Empfohlene Reihenfolge

1. **M-Phase zuerst** (#458-463): Schichten-Modell klar definieren — fundamentalste Korrektur
2. **R.11 + R.12** (#500-501): Anti-Vermischungs-Doku — Basis fuer alle weiteren Korrekturen
3. **N-Phase** (#464-473): Bausteine-Matrix auf 14 Achsen
4. **O-Phase** (#474-479): PRT-ART als Bausteine-Spiegel
5. **R.1-R.10** (#490-499): Konkrete Vermischungen je Tab klarstellen
6. **P-Phase** (#480-485): drawio REV8 mit allen Korrekturen
7. **L-Phase** (#452-457): Email-Code-Integration (parallel zu M moeglich)
8. **Q-Phase** (#486-489): Datasets + F-EXTRA Detail

---

## §8 GESCHWEIGT NICHT-WIDERLEGTE BEOBACHTUNGEN

### §8.1 Pruefling-Kreislauf-Logik (User-Quote 2026-05-18)

> "Die CacheEngine kann einen registrierten Pruefling (PRT-ART) als Struktur ueber alle Permutationen mit einbinden und dessen Konfigurationen gegenpruefen, **waehrend dieser die CacheEngine mit benutzt, um die eigene Performance auszumessen und zu optimieren.**"

Das ist eine zentral wichtige Symmetrie:
- **CE -> PRT-ART** (Pruefling-Verwendung): CE instantiiert PRT-ART als ExecutionEngine pro Permutations-Config
- **PRT-ART -> CE** (Werkzeug-Verwendung): PRT-ART ruft CE-Services (Telemetry, Prefetch, Heuristik) waehrend Lookup

Beide Richtungen MUESSEN im UML (M.5 #462) + drawio (P.2 #481) explizit sein.

### §8.2 PRT-ART Pflicht: "alle Achsen detailliert benennen und konstruieren"

Wenn PRT-ART eine Achse 1-14 nicht abdeckt -> ist nicht nach CE-Standards konstruierbar. Aktuell fehlt:
- Achse 12 HARDWARE-STRATEGY (NEU)
- Achse 13 SCHEDULING-STRATEGY (NEU)
- Achse 3.B Cache-Memory-Traversal (Sub-NEU)

O.3 (#476): Spiegel-Module fuer diese 3 Achsen anlegen.

---

## §9 NAECHSTE SESSION

**Empfohlen Start:** M.1 (#458) — Schichten-Modell klar definieren in `docs/architektur/02_aktueller_master_REV7_7.md`. Dann M.2 (#459) das neue Master-Doku `docs/architektur/10_schichten_modell_M.md`.

**Parallel moeglich:** L.4 (#455) Code-Audit (kann von Subagent gemacht werden).

**Pflicht-Pre-Read fuer naechste Session:**
- Diese Session-Doku (`20260518-4800-...`)
- `docs/architektur/02_aktueller_master_REV7_7.md` (REV7.7-Stand)
- `docs/bausteine/01_bausteine_matrix.md` (aktuelle 11 Achsen)
- `docs/MASTERPLAN_KONSOLIDIERUNG_TERMINE.md` (Master-Plan-Strategie)
- Die 3 Email-PDFs am Top-Level (Kuehn/Schuele/Zhang)

---

**Ende Session 4800.**
