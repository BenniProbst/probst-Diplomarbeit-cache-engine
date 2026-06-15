# V41.F.6.1 Zwischen-Doku — P2.D.q.s2 + P2.D.tr.s3 Batch 1 + Organ-Metapher (2026-05-26 lange Session)

**Stand:** 2026-05-26 spaet — Zwischen-Snapshot mitten in laufender Arbeit (User-Direktive)
**Vorgaenger:** `20260526-V41-F-6-1-P2-D-tr-s1-traversal-luecken-pattern-session-end.md`
**Anschluss:** wird direkt mit Task #692 P2.D.tr.R fortgesetzt (Architektur-Refactoring)
**Master-Doks:** `13_paper_legacy_code_architektur.md` (jetzt 9-teilig A-I) + **`14_achsen_komposition_organ_metapher.md` NEU**

---

## §1 Session-Umfang (16 Commits, 9 Architektur-Doks, 1 fundamentale Klarheits-Krise)

### §1.1 Commits chronologisch

| # | Commit | Repo | Kurz-Inhalt |
|:-:|---|---|---|
| 1 | `1ee92c1` | cache-engine | README-Korrektur P05 insertLater (vor s2-Start) |
| 2 | `b6d07d8` | Diplomarbeit | Doku 13 Teil E + Session-End P2.D.tr.s1 |
| 3 | `44b9f11` | cache-engine | **P2.D.tr.s2: 3 NEUE Original-Wrappers (Art/Hot/Start)** |
| 4 | `33fc03f` | Diplomarbeit | Submodule-Bump + Doku 13 Teil F |
| 5 | `76e4a2c` | Diplomarbeit | Doku 13 Teil G — P2.D.q Audit (0 ext-Sources) |
| 6 | `c7713fe` | cache-engine | **ext/-Reorganisation** (22 dirs in topics + Q01-concurrentqueue Submodule) |
| 7 | `725f187` | Diplomarbeit | Submodule-Bump + Doku 13 Teil H |
| 8 | `701a3cc` | cache-engine | **P2.D.q.s2 Pilot**: OriginalLockFreeMpmcConcurrentQueue |
| 9 | `60af8f6` | Diplomarbeit | Submodule-Bump P2.D.q.s2 |
| 10 | `fd127db` | cache-engine | **P2.D.tr.s3 Batch 1**: OriginalWormhole + OriginalSurf (Masstree initial deferred) |
| 11 | `5fcb20b` | Diplomarbeit | Submodule-Bump Batch 1 |
| 12 | `91e6458` | cache-engine | REPOS_OVERVIEW per Topic + Masstree-Skelett wiederhergestellt |
| 13 | `def3020` | Diplomarbeit | **Doku 14 NEU — Achsen-Komposition Organ-Metapher** |
| 14 | `9c6cfbc` | Diplomarbeit | Submodule-Bump auf 91e6458 |

(Zwischen-Commits Diplomarbeit teils Submodule-Bumps, hier konsolidiert.)

### §1.2 Architektur-Doks 13 erweitert (5 Teile heute appendiert)

Doku 13 ist jetzt **9-teilig (A-I)**, ~1900 Zeilen:
- Teile A-D bestanden vorher (mimalloc-Pilot + ext-Linking + Refactoring)
- **Teil E heute:** Lücken-Pattern + Mixin if-constexpr-requires + CLion-Build
- **Teil F heute:** P2.D.tr.s2 (3 NEUE Wrappers + Diamond-Vererbung + TYPED_TEST_SUITE)
- **Teil G heute:** P2.D.q Audit-Sprint (0 ext-Sources im queuing-Topic)
- **Teil H heute:** ext/-Topic-Reorganisation (3 Topics + Pattern A/B/C)
- **Teil I heute:** P2.D.q.s2 Pilot OriginalLockFreeMpmcConcurrentQueue

**Doku 14 NEU:** `14_achsen_komposition_organ_metapher.md` (310 Zeilen, 9 Sektionen, fundamentale Architektur-Klaerung).

---

## §2 Kritischer User-Erkenntnis-Punkt: Achse ist Organ, nicht Lebewesen

### §2.1 User-Direktive verbatim (2026-05-26 spaet)

> "Eine search algo Achse innerhalb der Search Algo Permutation ist Schwachsinn,
> es ist nicht möglich diese Komponente in unserem derzeitigen Bottom Up Ansatz
> später wieder zu verknüpfen."

Plus elaborate Lebewesen-Organ-Metapher: Achse = Organ (Sub-Aufgabe jedes Algorithmus),
Algorithmus = Komposition aller Achsen-Ausprägungen. Permutation = "genetisches
Experiment am Lebewesen".

### §2.2 Architektur-Diagnose

Das was wir heute in P2.D.tr.s2 + P2.D.tr.s3 Batch 1 als monolithische
`OriginalArt/Hot/Wormhole/SuRF`-Wrappers gebaut haben verstoesst gegen die
**bereits seit 2026-05-18** in Doku 07 §1.2 dokumentierte 13-Sub-Bausteine-
Struktur von axis_3.A:

| Sub-Baustein | Quelle | Mein heutiger Wrapper |
|---|---|---|
| TRAVERSAL_3A_BYTEBYBYTE | P01 ART | als OriginalArt fehlplatziert |
| TRAVERSAL_3A_DISCRIMINATIVE_BITS | P02 HOT | als OriginalHot fehlplatziert |
| TRAVERSAL_3A_LAYER_SLICE | P03 Masstree | (Skelett pending) |
| TRAVERSAL_3A_MULTIBYTE_SPAN | P05 START | als OriginalStart fehlplatziert |
| TRAVERSAL_3A_HASH_ANCHOR | P07 Wormhole | als OriginalWormhole fehlplatziert |
| TRAVERSAL_3A_LOUDS_BITPOS | P09/P10 LOUDS/SuRF | als OriginalSurf fehlplatziert |
| **+ 7 weitere** | P04/P06/P09/P11/P12/P22/PRT-ART | noch nicht abgebildet |

### §2.3 Klarheit-Gewinn

Die monolithischen Wrappers sind **bestimmte Permutations-Punkte** (= Lebewesen),
nicht Permutations-Elemente (= Organe). Sie enthalten implicit Node-Type +
Layout + Allocator + Concurrency + Prefetch — Redundanz zu existing Achsen.

**Pflicht-Refactoring** (Task #692 P2.D.tr.R Phasen R1-R4):
- R1 Doku-Recherche **DONE** (Doku 07 §1.2 + Doku 11 §11.7.A gelesen)
- R2 Composition-Templates anlegen (**NEXT**)
- R3 Existing OriginalXxx-Wrappers umstellen
- R4 PermutationEngine erweitern

---

## §3 Endstand cache-engine + Tests

### §3.1 Repo-Stand

| Repo | HEAD | Stand |
|---|---|---|
| cache-engine standalone | `91e6458` | sync mit origin/main ✅ |
| Diplomarbeit | `9c6cfbc` | sync mit origin/main ✅ |
| Diplomarbeit Submodule-Pointer cache-engine | `91e6458` | sync ✅ |
| prt-art | `d1b6140` | unveraendert seit 2026-05-25 (wartet F.6.2+) |

### §3.2 Tests-Bilanz cache-engine

| Test-Target | Start (vor Session) | Endstand | Delta |
|---|:-:|:-:|:-:|
| test_v41_topic_allocator_axis_06 | 252 | 252 | 0 |
| test_v41_topic_queuing | 205 | 216 | +11 (Q15 OriginalLockFreeMpmc) |
| test_v41_topic_traversal | 95 | 155 | +60 (6 NEUE Wrappers in AllStrategies + PropertyFilter-Adjustment) |
| test_v41_paper_legacy_code | 102 | 145 | +43 (FullOriginal+PartialOriginal+FlexibleOriginal+PartialOriginalBuffer) |
| **TOTAL** | **654** | **768** | **+114** |

### §3.3 ext/-Reorganisation Endstand

```
ext/
├── allocator/       (10 Allokatoren A01-A20 — Pattern A lokal)
├── traversal/       (12 SearchAlgo P01-P30 — Pattern A lokal)
├── queuing/         (1 Q01-concurrentqueue — Pattern B Submodule)
└── CMakeLists.txt
```

REPOS_OVERVIEW.md per Topic mit Wrapper-Status + Roll-out-Mapping.

---

## §4 Tasks-Stand (am Session-Punkt)

### §4.1 Heute completed

- ✅ #688 P2.D.tr.s2 (3 Wrappers Art/Hot/Start)
- ✅ #687 P2.D.q Audit (0 ext-Sources)
- ✅ #690 P2.D.q.s2 Pilot (OriginalLockFreeMpmc)
- ✅ #686 P2.D.tr Root abgeschlossen (s1+s2 erledigt)

### §4.2 Heute pausiert/neu pending

- ⏸️ #691 P2.D.tr.s3 Batch 1 grün (Wormhole+SuRF), Rest pausiert
- 📋 **#692 NEU P2.D.tr.R Architektur-Refactoring** (R1 done, R2 NEXT)
- 📋 #685 P2.D.t2 (4 deferred Allocator) — wartet
- 📋 #689 P2.D.tr.s4 (Library-Build Original-Compiler) — wartet

### §4.3 Memory verankert

- `[[achsen-komposition-organ-metapher]]` als KRITISCHE Direktive (Doku 14)
- `[[v41-session-start-pre-read]]` (Pflicht-Pre-Read aller V41-Sessions)
- MEMORY.md Index erweitert

---

## §5 R1 Recherche-Ergebnisse (fuer Anschluss R2)

### §5.1 Doku 07 §1.2 — axis_3.A SearchAlgo-Traversal (13 Sub-Bausteine)

Bereits seit 2026-05-18 dokumentiert. **13 Sub-Bausteine sind die "Organe"**:

```
TRAVERSAL_3A_BYTEBYBYTE        (P01 ART, 1 Byte/Schritt)
TRAVERSAL_3A_DISCRIMINATIVE_BITS (P02 HOT, Bit-Vektor-Sprung)
TRAVERSAL_3A_LAYER_SLICE       (P03 Masstree, Layer-Pop nach 8 Bytes)
TRAVERSAL_3A_MACRO_NODE        (P04 CoCo, Macro-Node-Jump)
TRAVERSAL_3A_MULTIBYTE_SPAN    (P05 START, k-Byte-Span variabel)
TRAVERSAL_3A_EMBEDDED_DEC_TREE (P06 B²-Tree, Embedded Decision Tree)
TRAVERSAL_3A_PATRICIA_SPLIT    (P09 Patricia, Single-Bit-Split)
TRAVERSAL_3A_HASH_ANCHOR       (P07 Wormhole, Hash-Anchor-Lookup)
TRAVERSAL_3A_BPLUS_RANGE       (P11/P12 CSS/CSB+, B+-Range-Walk)
TRAVERSAL_3A_FRACTAL           (P22 Fractal, Recursive Sub-Tree-Jump)
TRAVERSAL_3A_LOUDS_BITPOS      (P09/P10 LOUDS/SuRF, Bit-Position-Encoded)
TRAVERSAL_3A_REDIRECT_CHAIN    (PRT-ART, Redirect-Knoten-Chain)
TRAVERSAL_3A_PRTART_SUBSEARCH  (PRT-ART, Subsearch Typ A/B/C/D)
```

### §5.2 Doku 11 §11.7.A — 15-Topic-Hierarchie (User-validiert 2026-05-25)

```
1  allocator/    axis_06 (Sub 6.1-6.5)
2  concurrency/  axis_08 (Sub 8.1, 8.2, 8.3)
3  traversal/    axis_03a search_algo, 03b cache_traversal, 03m mapping
4  nodes/        axis_02 path_compression, axis_04 node_type
5  memory_layout/ axis_05
6  prefetch/     axis_07
7  telemetry/    axis_11 (Sub 11.X1-X4)
8  serialization/ axis_10 compression
9  value_handle/ axis_14
10 queuing/      axis_Q (13 W2-Strategien)
11 hardware/     axis_09 ISA, axis_12, axis_topologie
12 search_engine/ axis_01 Index-Organization (4 Sub)
13 io/           axis_io dispatch_policy
14 migration/    axis_migration policy
15 filter/       axis_filter
```

### §5.3 Mapping bekannter Algorithmen zu Sub-Achsen (Vorarbeit fuer R2)

| Algorithmus | 3.A SearchAlgo-Traversal | 3.B Cache-Traversal | 3.M Mapping | nodes/04 | memory_layout/05 | allocator/06 | concurrency/08 | prefetch/07 |
|---|---|---|---|---|---|---|---|---|
| **ART** (P01) | BYTEBYBYTE | CACHELINE_WALK | LINEAR_1TO1 | Node256-adaptive | CacheLineAligned64B | typ. Mimalloc | OLC | DistanceEstimator |
| **HOT** (P02) | DISCRIMINATIVE_BITS | CACHELINE_WALK | LINEAR_1TO1 | Patricia-comprimiert | Slot-Array kompakt | typ. Mimalloc | RCU-light | keine |
| **Masstree** (P03) | LAYER_SLICE | CACHELINE_WALK | PERMUTATION_INDEX | B+-Inode + Tries-Layer | Cache-aligned | Custom | OLC + Versioning | keine |
| **Wormhole** (P07) | HASH_ANCHOR | CACHELINE_WALK | HASH_REDIRECT | Hash-Anchor + Chain | AoS strict | Custom-Pool | RW-Latches | HW-Prefetch |
| **SuRF** (P10) | LOUDS_BITPOS | CACHELINE_WALK | LINEAR_1TO1 | (Read-Only LOUDS) | Bitmap kompakt | (Bulk-Loaded) | (single-threaded) | keine |
| **PRT-ART** | REDIRECT_CHAIN + PRTART_SUBSEARCH | HIERARCHICAL_BUNDLE | REDIRECT_OFFSET | PrtArt-BPlus + Redirect | TLB-Offset + cache-aligned | Bucket-Pool 4+2 | OLC + Reserved-Blocks | Distance + Path-Oriented + Bundle |

**Erkenntnis:** Jeder Algorithmus ist eindeutig durch eine **Tupel-Konfiguration aller
Achsen** beschreibbar — genau wie die Organ-Metapher es vorhersagt.

---

## §6 Direkter Anschluss (R2 Composition-Templates)

### §6.1 Was kommt JETZT (nach dieser Zwischen-Doku)

**Phase R2: Composition-Templates anlegen**

Konkret pro bekanntem Algorithmus eine Composition-Template-Datei:
```cpp
// libs/cache_engine/compositions/art_reference.hpp
namespace comdare::cache_engine::compositions {
struct ArtComposition {
    using search_algo_traversal = traversal::axis_03a::ByteByByteTraversal;
    using cache_traversal       = traversal::axis_03b::CacheLineWalk;
    using mapping               = traversal::axis_03m::Linear1to1;
    using node_type             = nodes::axis_04::Node256Adaptive;
    using memory_layout         = memory_layout::axis_05::CacheLineAligned64B;
    using allocator             = allocator::axis_06::MimallocAllocator;
    using concurrency           = concurrency::axis_08::OlcOptimistic;
    using prefetch              = prefetch::axis_07::DistanceEstimator;
    static constexpr std::string_view paper_id = "P01 Leis/Kemper/Neumann ICDE 2013";
};
}  // namespace
```

Analog HotComposition, MasstreeComposition, WormholeComposition, SurfComposition, etc.

### §6.2 Pflicht-Disziplin bei R2

- **KEINE neuen monolithischen Wrappers** mehr in axis_03a (Lebewesen-Anti-Pattern)
- Wenn Sub-Achse fehlt (z.B. axis_03a `ByteByByteTraversal` existiert noch nicht): **NEU anlegen** als 3.A-Variante
- Composition-Templates sind reine **using-Tupel** ohne eigene Methods
- PermutationEngine kann ueber Cartesian der Sub-Achsen iterieren

### §6.3 Realistische Zeit-Schaetzung

- R2 Composition-Templates anlegen pro Algorithmus: ~30min × 6 = 3h
- Vorher: existing axis_03a 8 Wrappers auditieren + entscheiden ob loeschen/umbauen
- R3 + R4 sind eigene Sprints (mehrere Sessions)

### §6.4 Pflicht-Read fuer naechste Session

1. `MEMORY.md` (Index)
2. **Diese Zwischen-Doku**
3. `docs/architektur/14_achsen_komposition_organ_metapher.md` (Master fuer Refactoring)
4. `docs/bausteine/07_bausteine_matrix_N_erweitert.md` §1.2 (13 Sub-Bausteine 3.A)
5. `docs/architektur/11_konzept_achsen_extension_visitor_pattern.md` §11.7.A (15-Topic-Hierarchie)
6. `docs/architektur/13_paper_legacy_code_architektur.md` (9-teilig A-I, ~1900 Zeilen)
7. Memory `[[achsen-komposition-organ-metapher]]`

---

**Ende Zwischen-Doku 2026-05-26 spaet (R1 done, R2 NEXT).**
