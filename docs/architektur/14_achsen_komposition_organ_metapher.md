# Achsen-Komposition als Organ-Metapher — Bottom-Up Permutations-Architektur

**Stand:** 2026-05-26 (User-Direktive)
**Auslöser:** User-Kritik an axis_03a_search_algo (monolithische Such-Algorithmen
unzulässig als Permutations-Element)
**Trigger:** "Daher: eine search algo Achse innerhalb der Search Algo Permutation
ist Schwachsinn, es ist nicht möglich diese Komponente in unserem derzeitigen
Bottom Up Ansatz später wieder zu verknüpfen."
**Zweck:** Fundamentales Architektur-Prinzip elaborate dokumentieren für ALLE
zukünftigen Topic+Achsen-Entscheidungen.

---

## §1 Kern-Metapher (User-Direktive verbatim 2026-05-26)

> "Bei Paarhufer-Mägen gibt es den Magen der Kuh, des Rehs, des Schafes, aber alle
> haben einen. Nun gehe ich davon aus, dass jeder Suchalgorithmus dieselben Organe
> (daher Achsen) haben muss, um zu funktionieren, auch wenn die jeweilige Organ-
> Ausprägung einem Anwendungsfall entspricht. Hier ist es also so, dass eine Achse
> einen speziellen Algorithmus für einen Anwendungsfall bereitstellt. Im Anschluss
> ist die Permutation der Achsen gegeneinander nichts anderes, als wenn wir
> genetische Experimente an den Tieren unternehmen und deren Organe testweise
> gegeneinander tauschen. Genauso tauschen wir die Algorithmen aller Achsen
> gegeneinander aus, um neue Gesamt-Suchalgorithmen zu erhalten, die unbekannte
> Eigenschaften besitzen."

### §1.1 Anti-Pattern (das was kritisiert wurde)

> "Ein Reh hat 4 Beine, eine Kuh hat vier Beine, ein Schaf hat vier Beine, also
> sind alle Pflanzenfresser und Paarhufer. Dabei hat jedes Tier dieselben Organe,
> dieselbe Grund DNA in unterschiedlicher Ausprägung."

**Übertragen auf Cache-Engine:** Wenn wir ART, HOT, Wormhole, Masstree als
EINZELNE Wrappers in `axis_03a_search_algo` ablegen — dann sagen wir
"ART hat 4 Functions (insert/lookup/erase/clear), HOT hat 4 Functions,
Wormhole hat 4 Functions" — und folgern fälschlicherweise: alle sind
"Such-Algorithmen", also gehören in EINE Achse. Das ist genauso fehlerhaft
wie "alle haben vier Beine → alle sind Paarhufer". Die Achse beschreibt
nicht das "Tier" (= ganzer Algorithmus), sondern ein einzelnes "Organ".

### §1.2 Bottom-Up-Permutation als genetisches Experiment

> "Genauso tauschen wir die Algorithmen aller Achsen gegeneinander aus, um neue
> Gesamt-Suchalgorithmen zu erhalten, die unbekannte Eigenschaften besitzen."

**Konsequenz:** Eine Permutation ist die kontrollierte Veränderung **eines
einzelnen Organs** bei gleichbleibender Tier-Anatomie. Im Cache-Engine-Kontext:
- Achse X = ein konkretes Organ (z.B. "Node-Layout")
- Permutations-Element der Achse = eine Ausprägung des Organs (z.B. "Node256",
  "Patricia-comprimiert", "PrtArt-BPlus")
- Eine Permutations-Konfiguration = ein konkretes Tier (= konkreter Such-Algorithmus)

---

## §2 Konsequenz für die Achsen-Zerlegung

### §2.1 Pflicht-Prinzip: Vom Detail zum Gesamt-Bild abstrahieren

> "Unsere Aufgabe ist also vom Detail-Bild in das Gesamt-Bild zu abstrahieren:
> Bei Paarhufer-Mägen gibt es den Magen der Kuh, des Rehs, des Schafes, aber alle
> haben einen."

**Bottom-Up-Phase (Stand 2026-05-26):**
> "Wir bereiten gerade bottom up die Interfaces vor, um je Topic-Aufgaben im
> Konzept eines Suchalgorithmus Aufgaben zu finden, die in veränderter Form
> allgemein in jedem Algorithmus auftreten."

Konkret: Pro Topic identifizieren WELCHE Sub-Aufgaben jeder beliebige
Such-Algorithmus ausführen muss. Diese werden als **abstrakte Achsen-Interfaces**
fixiert. Pro Algorithmus werden die spezifischen Ausprägungen dieser Interfaces
hinterlegt.

### §2.2 Beispiele für "Organe" eines Such-Algorithmus

Übertragen auf ART/HOT/Wormhole/Masstree etc., welche Organe (= Achsen) hat
JEDER von ihnen?

| Organ / Achse | Funktion | ART-Ausprägung | HOT-Ausprägung | Wormhole-Ausprägung |
|---|---|---|---|---|
| **Node-Type** | Wie sind interne Knoten strukturiert? | Node4/Node16/Node48/Node256 (adaptiv) | Patricia-comprimiert | Hash-Anchor-Knoten |
| **Traversal-Strategie** | Wie navigiert man von Root zu Leaf? | byte-by-byte path-compressed | k-constrained Path-Skip | Hash-Lookup + Skip |
| **Memory-Layout** | Wie liegen Knoten im Speicher? | Cache-Line-aligned 64B | Slot-Array kompakt | AoS strict |
| **Allocator** | Wer alloziert Knoten-Speicher? | typisch mimalloc | jemalloc | Custom-Pool |
| **Concurrency** | Wie synchronisiert man Read/Write? | OLC (Optimistic Lock-Coupling) | RCU-light | Reader-Writer-Latches |
| **Prefetch** | Welche Cache-Hints werden genutzt? | Distance-Estimator + Path-Oriented | keine | HW-Prefetch only |
| **Telemetry** | Welche Mess-Daten werden erhoben? | Density-Tracker per Node | Insert-Count-only | Lookup-Latenz-Hist |
| **Serialization** | Wie wird auf Disk persistiert? | VarLen-Encoder (Signaling-Bits) | binary array | nicht persistent |

**Erkenntnis:** Jeder Algorithmus hat ALLE diese "Organe" — nur in unterschiedlichen
Ausprägungen. Die Achse beschreibt das Organ-Konzept (z.B. "Node-Type"), nicht das
fertige Tier (z.B. "ART").

### §2.3 Anti-Pattern in heutiger axis_03a_search_algo

Was wir aktuell haben:
- `OriginalArtSearchAlgo` enthält Node-Type + Traversal + Layout + Allocator-Aufrufe + Concurrency + Prefetch + Telemetry — alles in EINEM Wrapper, monolithisch
- `OriginalHotSearchAlgo`, `OriginalWormholeSearchAlgo`, etc. analog

Das ist ein Anti-Pattern, weil:
1. Die Wrapper sind **nicht permutierbar**: Ich kann nicht "ART-Node-Type mit
   Wormhole-Traversal" konstruieren, weil beide Wrappers monolithisch sind
2. Es ist **redundant zu existing Achsen**: axis_06_allocator ist bereits da,
   aber ART-Wrapper benutzt eigenen impliziten Allocator-Call
3. Es widerspricht der **Stufe-1-Pflicht** (Memory `[[3-stufen-pruefung]]`):
   `comdare_perms_ce` soll feingranular permutieren, was bei monolithischen
   Algorithmus-Wrappers nicht geht

---

## §3 Lösungs-Architektur: Algorithm-as-Composition

### §3.1 Konzept

> "Wenn wir jetzt einen Gesamtalgorithmus haben, dann ist dieser konzeptionell
> gleichgestellt mit der Rekombination aller Achsen — steht also außerhalb des
> Systems. Erst wenn wir ihn zerlegt in seine Einzelteile betrachten, dann können
> wir seine Achsen/Organe in das System mit einbringen und es wird dann genau
> eine Permutation geben, die genau diesem zerlegten Original-Algorithmus
> entspricht."

**Klar:** Ein Gesamt-Algorithmus (z.B. ART) ist NICHT ein Permutations-Element,
sondern eine **konkrete Permutations-Konfiguration** aller Achsen.

### §3.2 Composition-Template-Pattern

Statt:
```cpp
class OriginalArtSearchAlgo { /* monolithisch */ };
```

Korrekt:
```cpp
// ART = konkrete Permutations-Konfiguration aller Achsen
struct ArtComposition {
    using node_type        = nodes::axis_02::Node256AdaptiveArt;
    using traversal        = traversal::axis_03b::ByteWisePathCompressed;
    using memory_layout    = memory_layout::axis_05::CacheLineAligned64B;
    using allocator        = allocator::axis_06::MimallocAllocator;
    using concurrency      = concurrency::axis_08::OlcOptimistic;
    using prefetch         = prefetch::axis_07::DistanceEstimator;
    using telemetry        = telemetry::axis_11::DensityTrackerPerNode;
    using serialization    = serialization::axis_10::SignalingBitsVarLen;
};
```

Die Permutations-Engine kann nun:
1. Default-ART bauen: Verwendung von `ArtComposition` direkt
2. ART-mit-jemalloc bauen: `using allocator = JemallocAllocator;`-Override
3. ART-mit-Wormhole-Traversal bauen: `using traversal = HashLookupSkip;`-Override
4. Jede beliebige Permutation bauen: jede Achse darf frei kombiniert werden

### §3.3 Permutations-Äquivalenz-Pflicht

> "Es wird dann genau eine Permutation geben, die genau diesem zerlegten Original-
> Algorithmus entspricht."

**Definition:** Eine Composition C ist **gültig** wenn:
- Es existiert eine Permutation P aus den definierten Achsen, sodass
  `Permutate(P) == Compile(C)` (bit-identisch oder Verhaltens-equivalent)

**Konsequenz:** Jeder Original-Algorithmus (ART, HOT, Wormhole, Masstree etc.)
muss als Composition-Template hinterlegt sein, das genau eine Punkt-Konfiguration
in der Permutations-Matrix darstellt.

### §3.4 Habich-Compliance bleibt erhalten

Die ursprüngliche Habich-Direktive (Original-Code mit Original-Compiler bauen
und linken) gilt weiterhin:
- Die einzelnen Achsen-Klassen (`Node256AdaptiveArt`, `OlcOptimistic` etc.)
  können jeweils Paper-Mixin-Inheritance haben (`get_compiler="gcc-9.5"`)
- Das Original-Linking erfolgt pro Achse (Organ), nicht pro Composition (Tier)

---

## §4 Pflicht-Disziplinen für alle zukünftigen Topic+Achsen

### §4.1 Pflicht: Achse = Organ, nicht Tier

**Vor Anlegen einer neuen Achse Pflicht-Frage:**
> "Ist das eine Sub-Aufgabe die JEDER Such-Algorithmus in irgendeiner Form
> ausführt (= Organ)? Oder ist das ein kompletter Algorithmus (= Tier)?"

Wenn Tier → falsche Achse → Composition-Template.
Wenn Organ → richtige Achse → permutationsfähiges Interface.

### §4.2 Pflicht: Universalität-Check

> "Aufgaben zu finden, die in veränderter Form allgemein in jedem Algorithmus
> auftreten"

Vor Definition eines Achsen-Interfaces: prüfen ob die Aufgabe in MIND. 3
verschiedenen bekannten Algorithmen tatsächlich auftritt. Wenn nur 1 Algorithmus
sie hat → Sub-Achse oder Composition-Spezifikum, nicht Top-Level-Achse.

### §4.3 Pflicht: Rekombinations-Test

Vor Permutations-Engine-Aktivierung: prüfen ob jede konkrete Sub-Permutation
**syntaktisch + semantisch sinnvoll** kompiliert. Sonst Cross-Constraints
definieren (z.B. "Patricia-Compression + Adaptive-Node-Type = INVALID").

### §4.4 Pflicht: Original-Algorithmen als Reference-Compositions

Jeder bekannte Original-Algorithmus (ART, HOT, Wormhole, Masstree, START,
SuRF, BlitzScale, etc.) MUSS als **Reference-Composition-Template** hinterlegt
werden, sodass:
1. Mess-Reihen direkt diese Reference reproduzieren können
2. Die Permutations-Matrix mindestens 1 Punkt enthält der dem Original 1:1
   entspricht
3. Habich-Validation via Paper-Mixin-Inheritance pro Achsen-Organ greift

---

## §5 Stufe-Modell-Mapping ([[3-stufen-pruefung]])

| Stufe | Was passiert? | Aktuelle Wrapper-Rolle |
|:---:|---|---|
| **Stufe 1** `comdare_perms_ce` | feingranulare Achsen-Permutation (Cartesian aller Achsen-Sub-Werte) | OriginalArt/etc. NICHT geeignet (monolithisch) → Composition-Templates nötig |
| **Stufe 2** `comdare_perms_<pruefling>` | pro Pruefling kompletter Algorithmus als Baseline | OriginalArt/etc. **geeignet als Pruefling-Referenz-Adapter** |
| **Stufe 3** `comdare_perms_full_join` | Cartesian aller Stufe-1 × Stufe-2 Kombinationen | beides nutzbar |

**Konsequenz:** Existing `OriginalArt/Hot/Wormhole/SuRF`-Wrapper sind nicht
falsch — sie sind nur **im falschen Topic/Achse einsortiert**. Sie gehören
in eine neue Schicht `comdare_perms_pruefling_references/` ODER als Composition-
Templates die Sub-Achsen orchestrieren.

---

## §6 Refactoring-Plan (Folge-Sprint nach User-Approval)

### §6.1 Pflicht-Vorarbeit (Doku-Recherche)

1. **Doku 11** Master-Architektur-Skizze §11.7 finale 15-Topic-Hierarchie lesen
2. **Doku bausteine/07_bausteine_matrix_N_erweitert.md** (14-Achsen-Matrix) lesen
3. **Doku 11_axes_vs_strategies_disambiguation.md** (4 Konzept-Ebenen) lesen
4. Existing Wrappers in axis_03a auditieren: welche Sub-Aufgaben implementieren sie?

### §6.2 Implementation (nach Plan-Approval)

**Phase R1 — Sub-Achsen identifizieren:**
- ART/HOT/Wormhole/SuRF/Masstree-Source-Audit: welche Achsen-Komponenten?
- Mapping zu existing Achsen (axis_06_allocator vorhanden) + ggf. neue Achsen

**Phase R2 — Composition-Templates anlegen:**
- `compositions/art_reference.hpp` mit using-Aliases pro Achse
- `compositions/hot_reference.hpp`, `wormhole_reference.hpp`, etc.
- Pro Composition: static_assert dass Sub-Achsen-Concepts erfüllt sind

**Phase R3 — Existing Original-Wrappers Umstellung:**
- Option A: Loeschen, Composition-Templates ersetzen sie
- Option B: Belassen als Pruefling-Referenz-Adapter unter eigener Topic-Schicht
- User-Entscheidung pro Wrapper

**Phase R4 — PermutationEngine erweitern:**
- mp_product über alle Achsen statt nur EnabledStrategies
- Cross-Constraints (siehe §4.3 Rekombinations-Test)

### §6.3 Tests-Anpassung

- TYPED_TEST über Composition-Templates statt monolithische Wrappers
- 1 Test pro Reference-Composition (ART-Reproducibility-Test, etc.)
- Cross-Composition-Permutations-Sanity-Tests

---

## §7 Was JETZT bereits stabil ist (kein Refactoring nötig)

| Topic / Achse | Status | Begründung |
|---|---|---|
| `axis_06_allocator` (24 Vendor) | ✅ stabil | Allocator IST ein Organ (jeder Algorithmus alloziert), Wrappers sind Organ-Ausprägungen |
| `axis_q1_queuing` (14 Buffer-Strategien) | ✅ stabil | Buffer-Strategie ist Organ (jede LSM/Bw-Tree-API hat einen) |
| `axis_q2_queuing` (5 Flush-Policies) | ✅ stabil | Flush-Policy ist Organ |
| `axis_03b_cache_traversal` (2 Wrappers) | ✅ stabil | Cache-Traversal ist Organ |
| `axis_03m_mapping` (2 Wrappers) | ✅ stabil | Mapping ist Organ |

| Topic / Achse | Status | Begründung |
|---|---|---|
| **`axis_03a_search_algo`** (8 Wrappers, davon 5 OriginalXxx) | ❌ **REFACTORING-PFLICHT** | Tiere statt Organe — Refactoring per §6 |

---

## §8 Cross-Refs

- Memory `[[3-stufen-pruefung]]` — Stufe-Modell für Permutationen
- Memory `[[topic-axis-pruefling-namespace-pattern]]` — Composition-Pattern via Namespace
- Memory `[[crtp-concept-guard-mix-pattern]]` — Concept-Constraint für Sub-Achsen
- Memory `[[paper-original-code-pattern]]` — Habich-Compliance pro Organ
- Doku 11 `konzept_achsen_extension_visitor_pattern.md` — Master-Visitor + 15-Topic-Hierarchie
- Doku 11 `axes_vs_strategies_disambiguation.md` — 4 Konzept-Ebenen (Achsen vs C-Sub-Engines vs F-Strategien vs S-Familien)
- Doku bausteine/07 `bausteine_matrix_N_erweitert.md` — 14-Achsen-Matrix pro Algorithmus
- User-Memory neu (pending): `[[achsen_komposition_organ_metapher]]` als kritische Direktive

---

## §9 Master-Statement

**Achse ≠ Algorithmus.**

**Achse = Organ.**

**Algorithmus = Permutations-Konfiguration aller Achsen.**

**Permutation = genetisches Experiment am Tier (= Cache-Engine).**

**Bottom-Up-Pflicht:** Abstrahiere vom Detail (Algorithmus) zum Gesamt-Bild (Organ-
Aufgaben). Definiere Achsen NUR für Sub-Aufgaben die in jedem Algorithmus
auftreten. Kompositioniere Algorithmen NUR aus den definierten Achsen-Ausprägungen.

---

**Ende Teil 1 (Stand 2026-05-26 User-Direktive Organ-Metapher).**

---

# Teil 2 — Saeugetier-Anatomie als Forschungs-Ziel der Diplomarbeit

> **Anmerkung [[never-delete-documentation]]:** Teil 1 §1-§9 oben unangetastet.
> Teil 2 dokumentiert die User-Vertiefung 2026-05-26 spaet — aus den statischen
> Compositions wird die **zentrale Anatomie** eines Suchalgorithmus abgeleitet.

---

## §10 User-Direktive verbatim (2026-05-26 spaet, F15-Forschungsmission)

> "Jetzt haben wir statische Algorithmen als Beispiel von Kombinationen von
> Permutationen. Nachdem alle topics und Achsen vollständig ausgebaut sind, können
> wir mithilfe dieser Kompositionen die zentrale Anatomie eines Suchalgorithmus
> finden, was bedeutet, dass wir anhand des Gesamtbildes der Kompositionen und
> der nun fertiggestellten Zerlegung eine Implementierung finden können, welche
> zentral für alle Kompositionen passen wird, und die sich nur anhand der
> Ausprägung der Merkmale jeder Achse/Organe (ähnlich Tier-Metapher) zum finalen
> eindeutigen Komposit-Algorithmus zusammensetzt."

> "Methapher: Alle Säugetiere haben im Kern hauptsächlich dieselben Organe und
> Anatomie, aber alle Knochen, Organe, Bindegewebe haben unterschiedliche
> Ausprägungen."

> "Das finale Ziel der Diplomarbeit ist es, die Anatomie eines Suchalgorithmus
> zu finden und das schnellste 'Tier' bzw. die schnellste Rekombination aller
> Achsen zu finden und ansonsten alle Achsen-Permutationen bis ins Detail über
> ihr Verhalten zu studieren und auszuwerten."

---

## §11 Drei-Schichten-Architektur fuer Suchalgorithmus-Anatomie

Aus User-Vertiefung folgt eine klare 3-Schichten-Architektur:

### §11.1 Schicht 1 — Achsen + Sub-Achsen (15 Topics)

**Was:** Die individuellen "Organe" — Sub-Aufgaben die jeder Algorithmus erfuellt.
**Wer:** `libs/cache_engine/topics/<topic>/axis_<NN>_<name>/` mit Default-Wrappers.
**Stand 2026-05-26:** Fundament-Sprint F1+F2+F3 abgeschlossen (15/15 Topics implementiert).

### §11.2 Schicht 2 — Composition-Templates (statische Beispiele)

**Was:** Konkrete Reference-Konfigurationen — bekannte Such-Algorithmen als Beweis
dass die Achsen-Zerlegung deren Anatomie korrekt abbildet.
**Wer:** `libs/cache_engine/compositions/<algorithm>_reference.hpp` mit 15
`using`-Aliases pro Algorithmus.
**Stand 2026-05-26:** 6 Compositions (Art/Hot/Wormhole/Surf/Start/Masstree) als 15-Achsen-Tupel.

### §11.3 Schicht 3 — Zentrale Anatomie-Implementation (FORSCHUNGS-ZIEL)

**Was:** EINE generische `SearchEngine<Composition>`-Template-Klasse, die durch
Spezialisierung mit jeder Composition zu einem konkreten Algorithmus wird.
**Wer:** `libs/cache_engine/anatomy/search_algorithm_anatomy.hpp` (NEU pending Task #694).
**Stand:** TODO Phase R3.

```cpp
// Konzept-Skelett (R3+R4)
namespace comdare::cache_engine::anatomy {

template <typename Composition>
class SearchAlgorithmAnatomy {
    typename Composition::allocator       allocator_;
    typename Composition::node_type       root_;
    typename Composition::concurrency     concurrency_;
    typename Composition::prefetch        prefetcher_;
    typename Composition::telemetry       telemetry_;
    // ... 15 Organ-Instances ...

public:
    bool insert(Key k, Value v) {
        prefetcher_.prefetch(predicted_path);
        auto lock = concurrency_.acquire_write();
        Composition::search_algo::insert_into(root_, k, v);
        telemetry_.notify_insert();
        return true;
    }
    std::optional<Value> lookup(Key k) const { /* analog */ }
};

// Konkrete Algorithmen = reine Template-Instantiationen:
using Art       = SearchAlgorithmAnatomy<compositions::ArtComposition>;
using Hot       = SearchAlgorithmAnatomy<compositions::HotComposition>;
using Wormhole  = SearchAlgorithmAnatomy<compositions::WormholeComposition>;
using SuRF      = SearchAlgorithmAnatomy<compositions::SurfComposition>;
using Masstree  = SearchAlgorithmAnatomy<compositions::MasstreeComposition>;
using Start     = SearchAlgorithmAnatomy<compositions::StartComposition>;

// Eine NEUE Permutation = neues Tier (z.B. ART-Node mit Wormhole-Hash-Lookup):
struct FrankensteinComposition {
    using search_algo     = traversal::axis_03a::Array256;
    using cache_traversal = traversal::axis_03b::HashLookup;  // ← von Wormhole
    using mapping         = traversal::axis_03m::DirectPlacement;
    // ... 12 weitere Achsen frei kombinierbar ...
};
using Frankenstein = SearchAlgorithmAnatomy<FrankensteinComposition>;
```

---

## §12 F15-Forschungsmission-Verknuepfung

**Diplomarbeit-Forschungsfrage (formal):**

> *Gibt es eine zentrale Anatomie-Implementation eines Suchalgorithmus, die
> durch Template-Parameter-Variation aller orthogonalen Achsen ALLE bekannten
> Such-Algorithmen als Spezialfaelle reproduziert UND eine systematische Suche
> im Permutations-Raum erlaubt um bisher unbekannte performante Algorithmen
> zu finden?*

**Antwort-Plan (Phasen 1-7):**

1. **Bottom-Up Achsen-Zerlegung** (15 Topics) ✅ F1+F2+F3 done
2. **Reference-Compositions** als Punkt-Konfigurationen ✅ R2 done (6 Algorithmen)
3. **Zentrale Anatomie-Implementation** → R3 NEXT
4. **Permutations-Engine** mp_product → R4
5. **CacheEngineBuilder** baut pro Permutation .so/.dll → V41.E11 Skeleton da, Impl pending
6. **Mess-Reihe + Welch-Test** ueber tausende Permutationen → V41.B1+B3 done
7. **F15-Auswertung**: schnellste Permutation in Anatomie-Raum identifizieren → V42

**Wissenschaftlicher Beitrag der Diplomarbeit:**
- Bewies dass Such-Algorithmen eine gemeinsame Anatomie haben (Reduktion auf 15 Achsen)
- Erschloss neuen Permutations-Raum (Cartesian aller Achsen-Sub-Werte)
- Identifizierte schnellstes "Tier" (optimale Komposit-Konfiguration) systematisch

---

## §13 Saeugetier-Anatomie-Tabelle (6 bekannte Algorithmen)

| Aspekt (Organ) | ART | HOT | Wormhole | SuRF | Masstree | START |
|---|---|---|---|---|---|---|
| **Skelett** (search_algo) | BYTEBYBYTE | DISCR_BITS | HASH_ANCHOR | LOUDS_BITPOS | LAYER_SLICE | MULTIBYTE_SPAN |
| **Verdauung** (cache_traversal) | LinearWalk | LinearWalk | **HashLookup** | LinearWalk | LinearWalk | LinearWalk |
| **Nervensystem** (mapping) | Direct | Direct | Direct | **PoolRelative** | Direct | Direct |
| **Atmung** (path_compression) | None | k-constrained | None | None | None | None |
| **Herz** (node_type) | Node4/16/48/256 | Patricia | HashAnchor | LOUDS-Bitmap | B+/Trie | Node4/16/48/256 |
| **Knochen** (memory_layout) | CacheLineAligned | CacheLineAligned | AoS-strict | Bitmap-kompakt | Cache-Craftiness | CacheLineAligned |
| **Blutkreislauf** (allocator) | Mimalloc | Mimalloc | Custom-Pool | Bulk-Loaded | Custom | Mimalloc |
| **Sinne** (prefetch) | DistanceEstimator | None | HW-Prefetch | None | None | None |
| **Immunsystem** (concurrency) | OLC | RCU-light | RW-Latches | (single-thread) | OLC+Versioning | OLC |
| **Fortpflanzung** (serialization) | VarLen | binary | nicht-pers. | succinct | nicht-pers. | binary |
| **Telemetrie** (telemetry) | Density | Insert-Count | Latency-Hist | (no) | (no) | (no) |
| **Wert-Speicherung** (value_handle) | Inline | Inline | External-Pool | Inline | Inline | Inline |
| **Spezialisierung** (isa) | AVX2 | AVX2 | AVX2 | scalar | scalar | scalar |
| **Index-Typ** (index_organization) | sorted_unique | sorted_unique | sorted_unique | range_filter | sorted_unique | sorted_unique |
| **IO-Strategie** (io_dispatch) | InMemory | InMemory | InMemory | InMemory | InMemory | InMemory |
| **Migration** (migration_policy) | None | None | None | None | None | None |
| **Filter** (filter) | None | None | None | **(= Funktion!)** | None | None |

**Beobachtungen:**
- SuRF ist das einzige Tier wo `filter` Composition-konstitutiv ist (SuRF **IST** ein Filter)
- Wormhole als einziges Tier nutzt HashLookup statt LinearWalk fuer cache_traversal
- Viele Organe sind ueber alle 6 Tiere identisch (value_handle Inline, io_dispatch InMemory, migration None) → kleine echte Variation
- 3 Skelett-Gruppen (BYTEBYBYTE/DISCRIMINATIVE_BITS+HASH_ANCHOR/LAYER_SLICE+MULTIBYTE_SPAN+LOUDS_BITPOS) sind die dominanten search_algo-Cluster

**Permutations-Raum-Schaetzung** (heute mit Stufe-A-Defaults):
3 × 2 × 1 × 1 × 1 × 1 × 24 × 1 × 1 × 1 × 1 × 1 × 1 × 4 × 1 × 1 × 1 ≈ **576 minimal-Permutationen**.
Bei Vollausbau aller Achsen (z.B. 10 node_types, 8 concurrency-Patterns, 5 prefetch, 5 telemetry) wird das auf 10⁴-10⁵ wachsen → CacheEngineBuilder muss tausende .so/.dll bauen + messen.

---

## §14 Implementierungs-Plan (Anatomie + Permutation)

### §14.1 Phase R3 (NEXT) — SearchAlgorithmAnatomy Skelett

1. `libs/cache_engine/anatomy/` Verzeichnis anlegen
2. `search_algorithm_anatomy.hpp` mit `SearchAlgorithmAnatomy<Composition>` Template
3. Concept `IsComposition` zur Validierung der 15 Pflicht-Achsen-Aliases
4. Pflicht-API: `insert(K,V) → bool`, `lookup(K) const → optional<V>`, `erase(K) → bool`, `clear()`
5. Tests: alle 6 bekannten Compositions instantiieren via `SearchAlgorithmAnatomy<>` + Smoke

### §14.2 Phase R3.2 — OriginalXxx-Wrappers Promotion (KORRIGIERT 2026-05-26 spät)

> **AUDIT-KORREKTUR:** Diese Sektion wurde zuvor (R3 Initial-Doku) faelschlich als
> "Deprecation zugunsten SearchAlgorithmAnatomy<XxxComposition>" beschrieben.
> Audit beim R3.2-Start zeigte: Die `OriginalXxx`-Wrappers sind im Registry
> `axis_03a_search_algo_registry.hpp` als S04-S08 als **legitime search_algo-
> Achsen-Werte** registriert — neben den CE-Re-Impls S01-S03 (Array256/VectorU8U8/
> VectorU16U16). Sie passen exakt in die Organ-Metapher: alternative Skelett-
> Auspraegungen mit Paper-Bindung statt Re-Impl. Property-Tests (SimdSubset=5/8,
> DenseSubset=2/6) demonstrieren ihre Registry-Integration.

**Korrigierte Strategie: PROMOTION statt Deprecation.**

Fuer jeden OriginalXxx-Wrapper wird eine eigene PaperBinding-Composition
angelegt, identisch zur Re-Impl-Composition AUSSER search_algo. Dadurch:

1. Die Habich-Compliance bleibt erhalten (SHA256-Validation via Paper-Mixin)
2. Beide Varianten (Re-Impl + Paper-Bindung) sind in der zentralen Anatomie austauschbar
3. R4 PermutationEngine wird in mp_product BEIDE Varianten mit-iterieren

**Implementation (R3.2 done):**

5 neue Compositions:
- `ArtPaperBindingComposition`      (search_algo = OriginalArtSearchAlgo S04, P01 ART unodb::db)
- `HotPaperBindingComposition`      (search_algo = OriginalHotSearchAlgo S05, P02 HOT Patricia)
- `StartPaperBindingComposition`    (search_algo = OriginalStartSearchAlgo S06, P05 START Multibyte)
- `WormholePaperBindingComposition` (search_algo = OriginalWormholeSearchAlgo S07, P07 Wormhole wh.c)
- `SurfPaperBindingComposition`     (search_algo = OriginalSurfSearchAlgo S08, P10 SuRF surf.hpp)

5 weitere using-Aliases in `known_algorithms.hpp`:
- `ana::ArtPaperBinding`, `ana::HotPaperBinding`, `ana::StartPaperBinding`,
  `ana::WormholePaperBinding`, `ana::SurfPaperBinding`

10 weitere Tests in `test_v41_anatomy.cpp` (§7+§8), inkl. Beweis dass
`ArtComposition` und `ArtPaperBindingComposition` sich **nur** im `search_algo`
unterscheiden (16 andere Achsen identisch).

**Tests-Snapshot:** 14 (R3) + 10 (R3.2) = **24 Tests grün** in `test_v41_anatomy`.

**KEINE Loeschung** der OriginalXxx-Wrappers — sie bleiben legitime Achsen-Werte.

### §14.3 Phase R4 — PermutationEngine + AdHocComposition + AnatomyPermutationDriver (DONE)

**Implementation (2026-05-26 sehr spät):**

1. **`libs/cache_engine/anatomy/composition_factory.hpp`** — `AdHocComposition<T0...T16>`
   Template-Struct mit 17 named using-Aliases. Topic-Slot-Convention fixiert:
   - T0=search_algo, T1=cache_traversal, T2=mapping (traversal)
   - T3=path_compression, T4=node_type (nodes)
   - T5=memory_layout, T6=allocator, T7=prefetch, T8=concurrency
   - T9=serialization, T10=telemetry, T11=value_handle, T12=isa
   - T13=index_organization, T14=io_dispatch, T15=migration_policy, T16=filter

2. **`CompositionFromPermTuple<PermT>`** — Helper Template (template-template partial
   specialization) das PermTuple<V0...V16> in AdHocComposition<V0...V16> umwandelt.
   `IsPermTuple17` Concept validiert 17-Slot-Arity.

3. **`libs/cache_engine/anatomy/anatomy_permutation_driver.hpp`** —
   `AnatomyPermutationDriver<TopicConfigSets...>` Facade ueber PermutationEngine:
   - `for_each_animal(visitor)` — iteriert alle Permutationen, instantiiert
     SearchAlgorithmAnatomy<AdHoc> + ruft visitor(algo_instance, name)
   - `for_each_composition_type(visitor)` — Compile-Time-Visitor pro Composition-Type
     (fuer CacheEngineBuilder/.so/.dll-Generation in R5)

4. **Tests `tests/unit/test_v41_anatomy_r4_driver.cpp`** — 10 Tests grün:
   - §1 AdHocComposition IsComposition + Instantiation in Anatomie
   - §2 CompositionFromPermTuple Materialization + IsPermTuple17 Concept
   - §3 AnatomyPermutationDriver Arity/Count (Pilot 3×2×1^15 = 6)
   - §4 EachPermutationIsDistinctTier (Set-Diversity-Check)
   - §5 AllSixTiereRoundtripIndependently (insert/lookup/erase/clear pro Tier)
   - §6 NonEmptyAxisCountMatchesArity (PermutationEngine min-1-Constraint)

**Pilot-Demonstration (6 Permutationen):**
```
search_algo:     {Array256, VectorU8U8, VectorU16U16}  (3 Werte)
cache_traversal: {LinearFanout, HashLookup}            (2 Werte)
15 weitere:      {Default}                              (1^15)
→ Cartesian:     3 × 2 × 1^15 = 6 distinkte Tiere
```

**Skalierung-Pfad (R5/V42):**
Bei Vollausbau aller 15 Topics mit ihren Stufe-A-Wrappers:
- search_algo 8, cache_traversal 2, mapping 2, allocator 24+, isa 4, weitere 1-4 → 10⁴-10⁵ Tiere
- Pro Tier wird `for_each_composition_type` zu einem .so/.dll-Build (R5)
- Mess-Treiber loadet .so/.dll und misst Performance (R6/V42)

**Bezug zur PermutationEngine V41.F.6.1.D (existing):**
AnatomyPermutationDriver ist eine Facade ueber `pe::PermutationEngine<TopicConfigSets...>`
(in `libs/cache_engine/src/permutations/permutation_engine.hpp`). Die existing
mp_product + for_each_permutation + iterable_aspect-Mechanik bleibt unveraendert;
R4 fuegt nur Composition-Materialization + Anatomie-Instantiation als bequeme
Visitor-Schicht hinzu.

---

## §15 Pflicht fuer naechste Phasen

| Phase | Was | Wo |
|---|---|---|
| **R3 jetzt** | SearchAlgorithmAnatomy<C> Template-Skelett | `libs/cache_engine/anatomy/` |
| **R3.2 done** | OriginalXxx Promotion (5 PaperBinding-Compositions) | `libs/cache_engine/compositions/*_paper_binding_reference.hpp` |
| **R4 done** | AnatomyPermutationDriver + AdHocComposition + CompositionFromPermTuple | `libs/cache_engine/anatomy/composition_factory.hpp` + `anatomy_permutation_driver.hpp` |
| **R5** | CacheEngineBuilder pro Permutation .so/.dll | `apps/cache_engine_builder/` |
| **R6 (V42)** | Mess-Treiber + Welch-Test ueber tausende Permutationen | `Diplomarbeit/Code/02_messung_driver/` |
| **R7 (V42)** | F15-Auswertung: schnellste Permutation identifizieren | `Diplomarbeit/06_auswertung/` |

---

**Ende Teil 2 (Stand 2026-05-26 spaet — User-Vertiefung Saeugetier-Anatomie + F15-Forschungsmission).**

---

# Teil 3 — Verantwortlichkeits-Trennung + 3 Kompositionale Joins + ABI-Stabilitaet

> **Anmerkung [[never-delete-documentation]]:** Teil 1 + Teil 2 oben unangetastet.
> Teil 3 dokumentiert die User-Direktive 2026-05-26 sehr spaet zur Aufgaben-
> Verteilung zwischen PermutationEngine, SearchAlgorithmAnatomy und
> CacheEngineBuilder + zur Pruefling-Algorithmus-Integration ueber 3 Joins.

---

## §16 User-Direktive verbatim (2026-05-26 sehr spaet, R5.A-Sprint-Start)

> "Bitte den naechsten sinnvollen sprint. Bitte notiere, dass es die Aufgabe der
> Permutations-Engine ist, gesteuert durch die Konfiguration der CacheEngineBuilder
> (die ABI stabil das struct aller Achsen-Statistik-Observer abfragt und ausmisst),
> Suchalgorithmus-Anatomien zu erzeugen, bei der jede Anatomie exakt eine
> Permutation aus den Achsen-Algorithmen ist. Die entstandene Anatomie wird als
> dokumentierter und und registrierter Suchalgorithmus-Binary gespeichert und
> spaeter unter der CacheEngineBulider als Modul ABI stabil ausgefuehrt und
> durchgemessen. Alle Methoden und tools, die nicht direkt Teil der Anatomie
> sind (bis auf die Statistik observer der Achsen) gehoeren in die CacheEngineBuilder.
> Wir muessen uns bewusst sein, dass ein abstract class composition
> Pruefungs-Algorithmus, wie der prt-art einen neuartigen, teilweise
> unvollstaendigen, stack an Achsen-Algorithmus-Erweiterungen anbietet, wodurch
> die Permuation-Engine fuer die Erzeugung der 3 Arten an Kompositionalen joins
> an neuartigen Anatomien, per Metaprogrammierung erweiterbar sein muss. Die
> Regeln fuer den merge eines Pruefungs-Algorithmus gegen die Achsen der
> cache-engine ist umfassend dokumentiert."

---

## §17 Verantwortlichkeits-Trennung — 3 Akteure

### §17.1 PermutationEngine (Anatomie-Generator)

**Einzige Aufgabe:** Aus einer Konfiguration (TopicConfigSets...) Suchalgorithmus-
Anatomien erzeugen, bei der **jede Anatomie exakt EINE Permutation aus den
Achsen-Algorithmen ist**.

- Compile-Time Cartesian via `mp_product` ueber alle Topic-Achsen-Wrapper-Listen
- Pro Permutation: 1 AdHocComposition (17-Achsen-Tupel) + 1 SearchAlgorithmAnatomy<AdHocComposition>
- Compiler emittiert pro Permutation einen distinkten Algorithmus-Binary
- KEIN Runtime-Switch — alles statisch determiniert

**Was nicht zur PermutationEngine gehoert:**
- Insert/Lookup/Erase/Clear-Methoden (gehoeren zum CacheEngineBuilder als Commands)
- Mess-Logik (gehoert zum CacheEngineBuilder)
- Binary-Loading/Module-Dispatch (gehoert zum CacheEngineBuilder)

### §17.2 SearchAlgorithmAnatomy (Organ-Container)

**Einzige Aufgabe:** Pro Permutation die 17 Achsen-Algorithmen statisch
zusammenfuehren UND einen **ABI-stabilen Observer-Aggregat-Struct** exponieren,
der pro Achse den Statistik-Observer liefert.

**Was zur Anatomie gehoert:**
- 17 Achsen-Algorithmen als Template-Member (Composition::search_algo, ::node_type, ...)
- 17 Statistik-Observer pro Achse (composition::xxx::observer())
- **ObserverAggregate-Struct** — ABI-stabiler POD/standard-layout-struct mit
  allen 17 Achsen-Snapshots zu einem Zeitpunkt
- Composition-Inspection (paper_id, composition_name, organ_count)

**Was NICHT zur Anatomie gehoert (R3 hatte das falsch):**
- ❌ `insert/lookup/erase/clear` Container-Methoden — gehoeren in CacheEngineBuilder
- ❌ `std::map` oder anderer interner Container — gehoeren in CacheEngineBuilder
- ❌ Workload-Driver / YCSB-Treiber — gehoeren in CacheEngineBuilder/Mess-Treiber

**R3-Initialer-Stand (zu refactoren in R5.B):**
```cpp
template <IsComposition Composition>
class SearchAlgorithmAnatomy {
    std::map<key_type, value_type> container_;  // ← FALSCH, gehoert in Builder
public:
    bool insert(key_type, value_type);           // ← FALSCH
    std::optional<value_type> lookup(key_type);  // ← FALSCH
    bool erase(key_type);                        // ← FALSCH
    void clear();                                 // ← FALSCH
};
```

**R5.B-Ziel-Stand:**
```cpp
template <IsComposition Composition>
class SearchAlgorithmAnatomy {
public:
    using composition_t = Composition;
    using observer_aggregate_t = ObserverAggregate<Composition>;

    // RICHTIG: nur Achsen-Zugriff + Observer-Aggregate
    [[nodiscard]] observer_aggregate_t observe_all() const noexcept;
    // Composition-Inspection (statisch)
    static constexpr std::string_view composition_name() noexcept { return Composition::name; }
    static constexpr std::string_view paper_id()         noexcept { return Composition::paper_id; }
    static constexpr std::size_t      organ_count()      noexcept { return 17; }
private:
    typename Composition::search_algo  axis_search_algo_;
    typename Composition::cache_traversal  axis_cache_traversal_;
    // ... 15 weitere Achsen ...
};
```

### §17.3 CacheEngineBuilder (Mess-Orchestrierung + ABI-Loader)

**Aufgaben:**
- **Konfiguration:** Welche TopicConfigSets gehen in PermutationEngine?
- **CMake-Treiber:** Pro Permutation `cmake -B build/perm_<hash> -D...` rufen → 1 .so/.dll pro Permutation
- **ABI-Stabilitaet:** Module-Loader (dlopen/LoadLibrary) loadet .so/.dll und ruft fuer Mess-Reihe:
  - `ObserverAggregate snapshot = anatomy.observe_all()`
  - `bool insert(K, V)` als Command
  - `std::optional<V> lookup(K)` als Command
  - `bool erase(K)` als Command
  - `void clear()` als Command
- **Command-Pattern fuer Workload-Driver:** InsertCommand/LookupCommand/EraseCommand/ClearCommand + WorkloadDriverCommand (YCSB)
- **Mess-Aggregation:** Pro Permutation Welch-t-Test + Sample-Statistiken auf ObserverAggregate-Snapshots
- **3-Stufen-Pruefung-Auswahl:** Stufe 1 / Stufe 2 / Stufe 3 als CLI-Flag des CacheEngineBuilder

**ABI-Schnittstelle pro Binary (R5+ Skelett):**
```cpp
// In jedem generierten Permutations-Binary (.so/.dll)
extern "C" {
    // Anatomy-Singleton-Zugriff
    void* comdare_create_anatomy();
    void  comdare_destroy_anatomy(void*);
    // Container-Operationen (Builder-Commands)
    bool  comdare_insert(void* anatomy, std::uint64_t k, std::uint64_t v);
    bool  comdare_lookup(void* anatomy, std::uint64_t k, std::uint64_t* out_v);
    bool  comdare_erase(void* anatomy, std::uint64_t k);
    void  comdare_clear(void* anatomy);
    // Observer-Aggregate-Snapshot (POD, copy-back via Out-Pointer)
    void  comdare_snapshot(void* anatomy, ObserverAggregateSnapshot* out_snapshot);
    // Composition-Identifikation
    const char* comdare_composition_name();
    const char* comdare_paper_id();
}
```

---

## §18 3 Kompositionale Joins (User-Direktive)

Die Pruefling-Algorithmen (z.B. prt-art) sind **abstract class compositions**:
sie bieten einen "neuartigen, teilweise unvollstaendigen Stack an
Achsen-Algorithmus-Erweiterungen" an. PermutationEngine muss per Metaprogrammierung
fuer 3 Arten von Joins erweiterbar sein.

### §18.1 Stufe 1 — `comdare_perms_ce` (Default CE-only)

**Merge-Regel:** Keine Pruefling-Beteiligung. Nur cache-engine DefaultVariants.
```cpp
using Stufe1_Axes_03a = ce::axis_03a::DefaultVariants;  // {Array256, VectorU8U8, VectorU16U16, OriginalArt, ...}
using Stufe1_Axes_06  = ce::axis_06::DefaultVariants;   // {Mimalloc, Jemalloc, ...}
// ... 15 weitere Achsen ...

using Stufe1_Engine = PermutationEngine<
    Stufe1_03a, Stufe1_03b, Stufe1_03m, ..., Stufe1_filter>;
```

**Cartesian:** alle CE-Varianten × alle Permutationen.

### §18.2 Stufe 2 — `comdare_perms_<pruefling>` (ERSETZT-mit-Fallback)

**Merge-Regel (User-Direktive 2026-05 [[pruefling-replace-not-extend]]):**
Pro Achse: ERSETZT komplett wenn Pruefling-Namespace existiert, sonst Compile-
Time-Fallback auf CE-Defaults.

```cpp
namespace prt_art {
    namespace axis_03a {
        // Wenn definiert: Pruefling-Variants ERSETZEN CE-Defaults fuer Stufe 2
        using PrueflingVariants = mp::mp_list<PrtArtRadixVariant, PrtArtCompactVariant>;
    }
    // axis_06: KEINE Namespace-Definition → CE-Defaults bleiben (Fallback)
}

// Compile-Time-Detection
template <class Default, class Pruefling>
using StufeTwoAxis = std::conditional_t<
    has_pruefling_variants_v<Pruefling>,
    typename Pruefling::PrueflingVariants,
    Default
>;

using Stufe2_Axes_03a = StufeTwoAxis<ce::axis_03a::DefaultVariants, prt_art::axis_03a>;
using Stufe2_Axes_06  = StufeTwoAxis<ce::axis_06::DefaultVariants,  prt_art::axis_06>;
// ...
```

**Cartesian:** Mix aus Pruefling-Achsen (wo definiert) + CE-Defaults (wo nicht).

### §18.3 Stufe 3 — `comdare_perms_full_join` (Union-non-redundant)

**Merge-Regel:** Alle Pruefling- und CE-Variants pro Achse vereinigt, dedupliziert.

```cpp
// Existing in permutation_engine.hpp §5
template <class DefaultList, class... PrueflingLists>
using AxisFullJoin = mp::mp_unique<
    mp::mp_append<DefaultList, PrueflingLists...>
>;

using Stufe3_Axes_03a = AxisFullJoin<
    ce::axis_03a::DefaultVariants,
    prt_art::axis_03a::PrueflingVariantsOrEmpty,
    other_pruefling::axis_03a::PrueflingVariantsOrEmpty
>;
```

**Cartesian:** vollstaendiger Permutations-Raum mit allen Variantenquellen.

---

## §19 Pruefling-Namespace-Slot-Pattern (R5.C Pflicht)

Pro Achse ist ein optionaler Pruefling-Namespace-Slot definiert:

```cpp
// libs/cache_engine/topics/<topic>/axis_<NN>/<topic>_pruefling_slot.hpp
namespace comdare::cache_engine::<topic>::axis_<NN>::pruefling_slot {
    // Per Default leer — wird ueberschrieben wenn Pruefling-Repo eingebunden ist
    using PrueflingVariants = mp::mp_list<>;  // empty fallback
    static constexpr bool has_pruefling = false;
}
```

Pruefling-Repos (prt-art etc.) registrieren via Partial-Specialization oder
Namespace-Extension:

```cpp
// In comdare-prt-art/libs/.../axis_03a_search_algo_prt_art_slot.hpp
namespace comdare::cache_engine::traversal::axis_03a_search_algo::pruefling_slot {
    using PrueflingVariants = mp::mp_list<PrtArtRadix512, PrtArtCompactBoolean>;
    static constexpr bool has_pruefling = true;
}
```

PermutationEngine konsumiert ueber Concept-Detection:
```cpp
template <class Slot>
concept HasPruefling = requires { Slot::has_pruefling; } && Slot::has_pruefling;

template <class Default, class Slot>
using StufeTwoMerge = std::conditional_t<
    HasPruefling<Slot>,
    typename Slot::PrueflingVariants,
    Default
>;
```

---

## §20 ObserverAggregate — ABI-stabiler Snapshot-Struct (R5.A Pflicht)

Pro Composition wird ein ABI-stabiler POD-Struct definiert, der 17 Snapshots
(einer pro Achse) sammelt:

```cpp
// libs/cache_engine/anatomy/observer_aggregate.hpp
template <IsComposition Composition>
struct ObserverAggregate {
    // 17 named Snapshot-Members (POD-types pro Achse)
    typename Composition::search_algo::snapshot_t        search_algo_snapshot;
    typename Composition::cache_traversal::snapshot_t    cache_traversal_snapshot;
    typename Composition::mapping::snapshot_t            mapping_snapshot;
    // ... 14 weitere ...

    // ABI-Stabilitaet: standard_layout + trivially_copyable
    // (Achs-Snapshots sind selbst POD → Aggregate ist POD)
};

// SearchAlgorithmAnatomy<C> exponiert eine snapshot-Methode:
template <IsComposition Composition>
class SearchAlgorithmAnatomy {
public:
    using observer_aggregate_t = ObserverAggregate<Composition>;

    [[nodiscard]] observer_aggregate_t observe_all() const noexcept {
        return {
            axis_search_algo_.statistics(),
            axis_cache_traversal_.statistics(),
            // ... 15 weitere ...
        };
    }
};
```

**Pflicht-Concept fuer alle Wrappers:**
```cpp
template <class W>
concept ObservableAxis = requires(W const& w) {
    typename W::snapshot_t;
    { w.statistics() } -> std::same_as<typename W::snapshot_t>;
};
```

Falls eine Achse keinen Snapshot liefert (Stufe-A Default-Wrappers ohne
Statistics-Support): leerer `EmptySnapshot{}` POD.

---

## §21 Implementierungs-Plan R5.A bis R5.C

| Sprint | Was | Wo |
|---|---|---|
| **R5.A jetzt** | Observer-Aggregate ABI-Struct + Anatomie-Methode | `libs/cache_engine/anatomy/observer_aggregate.hpp` |
| **R5.B** | Anatomie-API-Refactor: insert/lookup/erase/clear → Builder-Commands | `libs/cache_engine/builder/anatomy_command/` |
| **R5.C** | PermutationEngine Stufe-2 + Stufe-3 Joins + Pruefling-Slot-Pattern | `libs/cache_engine/anatomy/pruefling_merge.hpp` |
| **R5.D** | CacheEngineBuilder CLI + extern "C" ABI-Interface | `libs/cache_engine/builder/cli/` + `apps/anatomy_binary/` |
| **R5.E** | dlopen/LoadLibrary Module-Loader (Workload-Treiber) | `libs/cache_engine/builder/module_loader/` |

---

## §22 Mapping zu existing Memory-Direktiven (Konsistenz-Check)

| User-Direktive (Teil 3) | Existing Memory-Direktive | Status |
|---|---|---|
| Anatomie nur Achsen + Observer | (NEU R5.A — siehe [[anatomie-nur-achsen-und-observer]]) | wird angelegt |
| 3 Kompositionale Joins | [[3-stufen-pruefung]] | ✅ konsistent |
| Pruefling ERSETZT-mit-Fallback | [[pruefling-replace-not-extend]] | ✅ konsistent |
| Topic-Namespace + Pruefling-Slot | [[topic-axis-pruefling-namespace]] | ✅ konsistent |
| ABI-Stabilitaet via Module-Loader | (NEU R5.D — siehe Doku 10 §0.4) | konsistent |
| PermutationEngine Anatomie-Generator | [[achsen-komposition-organ-metapher]] | ✅ konsistent |

---

## §23 Was R3 + R3.2 + R4 KORREKT war (Bestand bleibt)

- ✅ AdHocComposition 17-Tupel: korrekt
- ✅ CompositionFromPermTuple: korrekt
- ✅ AnatomyPermutationDriver Facade: korrekt
- ✅ 6 CE-Re-Impl-Compositions + 5 PaperBinding-Compositions: korrekt
- ✅ Frankenstein-Demo: korrekt

## §24 Was R3 + R3.2 + R4 zu KORRIGIEREN ist (R5.B Plan)

- ❌ `SearchAlgorithmAnatomy::insert/lookup/erase/clear`: in Builder-Commands verschieben
- ❌ `std::map container_`: in Builder verschieben
- ❌ Tests die direkte Anatomie-Methoden nutzen: auf Commands umstellen
- ✅ `composition_name() / paper_id() / organ_count()`: bleiben in Anatomie
- ✅ NEU `observe_all() → ObserverAggregate<Composition>`: kommt in R5.A

---

**Ende Teil 3 (Stand 2026-05-26 sehr spaet — User-Direktive Verantwortlichkeits-
Trennung + 3-Kompositionale-Joins + ABI-Stabilitaet).**
