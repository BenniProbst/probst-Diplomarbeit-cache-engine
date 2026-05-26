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

---

# Teil 4 — Anatomie-Gattungen + AnatomyBase + Gattungs-spezialisierte PermutationEngines

> **Anmerkung [[never-delete-documentation]]:** Teil 1+2+3 oben unangetastet.
> Teil 4 dokumentiert die User-Direktive 2026-05-26 sehr spaet zur Gattungs-
> Klassifikation der Anatomien (Saeugetier vs Reptil-Metapher) und der
> daraus folgenden PermutationEngine-Spezialisierung.

---

## §25 User-Direktive verbatim (2026-05-26 sehr spaet, R5.C-Sprint-Start)

> "Hinweis: Fuer die Anatomie eines Suchalgorithmus gibt es unter einer AnatomyBase
> verschiedene spezielle Suchalgorithmen oder Anatomie-Varianten, die vielleicht
> auch nur container darstellen. Bitte recherchiere dazu die std container von C++
> im web. Es gibt hier auch eine std::map<key,value> als Suchalgorithmus oder eine
> std::multi_map<key,value>. Es gibt daneben std::vector<>, std::list und so
> weiter. Das sind im Grunde alles Auspraegungen von Anatomien. Dabei gehoeren
> Suchalgorithmen und algemeine Container jedoch zu unterschiedlichen Gattungen
> bezueglich ihrer Metaprogrammierten template Variablen. Sie verwenden daher
> jeweils passend unterschiedliche Auspraegungen der Achsen. Dies kann man sich
> vorstellen wie Gattungen in der Tierwelt wie Saeugetiere vs. Reptilien. Bitte
> dokumentiere das. Trotzdem sind alle Gattungen am Ende Lebewesen, also alle
> Anatomie-Gattungen fallen unter die abstrakte Klasse der AnatomyBase. Wir
> beginnen bei den Suchalgorithmen, also std::map<key,value> aehnlichen Anatomie
> Permutationen. Die Permutation Engine muss fuer die anatomischen Moeglichkeiten
> jeder Anatomie-Gattungen durch Unterklassen spezifiziert werden, die von der
> Haupt-Permutation-Engine erben und diese fuer jede Anatomie-Gattung spezifizieren,
> um korrekt gesteuert durch die CacheEngineBuilder Anatomien und damit
> Experiment-Algorithmus-Binaries ausliefern zu koennen."

---

## §26 Web-Recherche Ergebnis — std::-Container-Hierarchie

5 std-Container-Familien identifiziert (siehe cppreference.com Container library):

### §26.1 Gattung A — Sequence Containers (V-only indexed)
| Container | Template-Signatur |
|---|---|
| `std::array<T, N>` | Fixed-size, kein Allocator |
| `std::vector<T>` | Dynamic, contiguous |
| `std::deque<T>` | Double-ended, chunked |
| `std::list<T>` | Doubly-linked |
| `std::forward_list<T>` | Singly-linked |

Pflicht-API: `push_back(V)/operator[](i)/at(i)/begin()/end()/value_type/size_type/allocator_type`.

### §26.2 Gattung B — Ordered Associative (K-V Search, Tree-basiert)
| Container | Template-Signatur |
|---|---|
| `std::set<K>` | Set, Key-only |
| `std::multiset<K>` | Multi-Key Set |
| `std::map<K, V>` | Map, K → V (one) |
| `std::multimap<K, V>` | Multi-Map, K → {V1...Vn} |

Pflicht-API: `find(K)/contains(K)/insert(K,V)/erase(K)/key_compare/key_type/mapped_type`.

### §26.3 Gattung C — Unordered Associative (K-V Search, Hash-basiert)
| Container | Template-Signatur |
|---|---|
| `std::unordered_set<K>` | Hash-Set |
| `std::unordered_map<K, V>` | Hash-Map |
| `std::unordered_multi{set,map}` | Multi-Variants |

Pflicht-API: identisch zu Gattung B + zusaetzlich `hasher/key_equal/bucket_count()`.

### §26.4 Gattung D — Container Adapters (Wrapper)
| Container | Inner-Container-Default |
|---|---|
| `std::stack<T>` | `std::deque<T>` |
| `std::queue<T>` | `std::deque<T>` |
| `std::priority_queue<T>` | `std::vector<T>` + Compare |

Pflicht-API: `push(V)/pop()/top()/front()/back()` — KEIN `begin()/end()`.

### §26.5 Gattung E — Flat Associative (C++23 NEU)
| Container | Inner-Container |
|---|---|
| `std::flat_set<K>` | Default `std::vector<K>` |
| `std::flat_map<K, V>` | Default `std::vector<K>` + `std::vector<V>` |
| `std::flat_multi{set,map}` | Multi-Variants |

Pflicht-API: identisch zu Gattung B, aber Inner-Container ist Composition-Achse.

### §26.6 Gattung F — Views/Spans (non-owning)
| View | Pflicht-Template |
|---|---|
| `std::span<T, Extent>` | `T, std::size_t Extent` |
| `std::mdspan<T, Extents, Layout, Accessor>` | Multidimensional |
| `std::string_view` | Spezialfall fuer `CharT, Traits` |

Pflicht-API: `operator[]/data()/size()` — KEIN insert/erase, non-owning.

---

## §27 AnatomyBase — die abstrakte Wurzel aller Lebewesen

User-Direktive: "Alle Anatomie-Gattungen fallen unter die abstrakte Klasse der
AnatomyBase."

### §27.1 Two-Phase-Architektur: Concept (Compile-Time) + Interface (Runtime/ABI)

| Schicht | Was | Wann verwendet |
|---|---|---|
| **AnatomyConcept** | C++23 Concept (Compile-Time) | Static Dispatch, Concept-Guards, Template-Constraints |
| **IAnatomyBase** | Virtual Interface | Module-Loader (R5.D), ABI ueber .so/.dll, dlopen Polymorphismus |

Beide gelten gleichzeitig — konkrete Anatomien implementieren **beide**:

```cpp
// libs/cache_engine/anatomy/anatomy_base.hpp (R5.C.0 Pflicht)
namespace comdare::cache_engine::anatomy {

// Compile-Time Wurzel-Concept (statische Klassifizierung)
template <class A>
concept AnatomyConcept = requires {
    typename A::composition_t;
    { A::composition_name() } -> std::convertible_to<std::string_view>;
    { A::paper_id() }         -> std::convertible_to<std::string_view>;
    { A::organ_count() }      -> std::convertible_to<std::size_t>;
    { A::genus() }            -> std::convertible_to<AnatomyGenus>;  // Pflicht in Teil 4
};

// Compile-Time Gattungs-Enum
enum class AnatomyGenus {
    SearchAlgorithm,  // std::map / multimap / unordered_map / flat_map
    Sequence,         // std::vector / list / deque / array
    Set,              // std::set / unordered_set / flat_set
    Adapter,          // std::stack / queue / priority_queue
    View              // std::span / mdspan / string_view
};

// Runtime ABI-Interface (R5.D fuer Module-Loader)
class IAnatomyBase {
public:
    virtual ~IAnatomyBase() = default;
    [[nodiscard]] virtual std::string_view composition_name() const noexcept = 0;
    [[nodiscard]] virtual std::string_view paper_id() const noexcept = 0;
    [[nodiscard]] virtual AnatomyGenus     genus() const noexcept = 0;
    [[nodiscard]] virtual std::size_t      organ_count() const noexcept = 0;
};

}  // namespace
```

### §27.2 Tier-Metapher-Mapping

| Tierwelt-Gattung | Anatomie-Gattung | std::-Container Beispiele | Stoffwechsel |
|---|---|---|---|
| **Saeugetier** | `SearchAlgorithm` | std::map, std::unordered_map, std::flat_map | Vollstaendige Anatomie mit allen 17 Achsen |
| **Vogel** | `Set` | std::set, std::unordered_set | Reduzierte Anatomie (K-only, kein V-Suchorgan) |
| **Reptil** | `Sequence` | std::vector, std::list, std::deque | Lineare Anatomie (V-only, kein K-Suchorgan) |
| **Wirbelloses** | `Adapter` | std::stack, std::queue, std::priority_queue | Decorator ueber anderem Lebewesen (Inner-Container) |
| **Pflanze** | `View` | std::span, std::mdspan | Sessil + non-owning |

---

## §28 Achsen-Verteilung pro Gattung

Jede Gattung verwendet eine **Teilmenge** der 17 Achsen:

| Achse | Mammal (Search) | Bird (Set) | Reptile (Sequence) | Invertebrate (Adapter) | Plant (View) |
|---|:---:|:---:|:---:|:---:|:---:|
| **search_algo** (axis_03a) | ✓ | ✓ | — | (delegated) | — |
| **cache_traversal** (axis_03b) | ✓ | ✓ | — | (delegated) | — |
| **mapping** (axis_03m) | ✓ | — | — | — | — |
| **path_compression** (axis_02) | ✓ | ✓ | — | — | — |
| **node_type** (axis_04) | ✓ | ✓ | — | — | — |
| **memory_layout** (axis_05) | ✓ | ✓ | ✓ | (delegated) | ✓ |
| **allocator** (axis_06) | ✓ | ✓ | ✓ | (delegated) | — (non-owning) |
| **prefetch** (axis_07) | ✓ | ✓ | ✓ | (delegated) | — |
| **concurrency** (axis_08) | ✓ | ✓ | ✓ | (delegated) | — (immutable) |
| **serialization** (axis_10) | ✓ | ✓ | ✓ | ✓ | — |
| **telemetry** (axis_11) | ✓ | ✓ | ✓ | ✓ | ✓ |
| **value_handle** (axis_14) | ✓ | — (K=V) | ✓ | ✓ | ✓ |
| **isa** (axis_09) | ✓ | ✓ | ✓ | (delegated) | ✓ |
| **index_organization** (axis_01) | ✓ | ✓ | — | — | — |
| **io_dispatch** (axis_io) | ✓ | ✓ | ✓ | (delegated) | — |
| **migration_policy** (axis_migration) | ✓ | ✓ | ✓ | (delegated) | — |
| **filter** (axis_filter) | ✓ | ✓ | — | — | — |
| **inner_container** (NEU axis_inner fuer Adapter) | — | — | — | ✓ | — |
| **growth_policy** (NEU axis_growth fuer Sequence) | — | — | ✓ | — | — |
| **extent_policy** (NEU axis_extent fuer View) | — | — | — | — | ✓ |
| **layout_policy** (NEU axis_layout fuer mdspan-View) | — | — | — | — | ✓ |
| **accessor_policy** (NEU axis_accessor fuer mdspan-View) | — | — | — | — | ✓ |

**Konsequenz:** Die 17 Achsen sind **fuer Mammal/Search** das Komplettpaket. Andere
Gattungen nutzen Teilmengen + ggf. eigene Achsen (NEU axis_inner/axis_growth/etc.).

---

## §29 PermutationEngine-Spezialisierung pro Gattung

User-Direktive: "Die Permutation Engine muss fuer die anatomischen Moeglichkeiten
jeder Anatomie-Gattungen durch Unterklassen spezifiziert werden, die von der
Haupt-Permutation-Engine erben und diese fuer jede Anatomie-Gattung spezifizieren."

### §29.1 Generische Wurzel (V41.F.6.1.D existing)

```cpp
template <class... TopicConfigSets>
class PermutationEngine {
    using AllPermutations = mp::mp_product<PermTuple, typename TopicConfigSets::StaticAxisVariants...>;
public:
    template <class Visitor> static void for_each_permutation(Visitor&&);
};
```

Generisch — ohne Wissen ueber Gattung.

### §29.2 Gattungs-Spezialisierung (R5.C+ Pflicht)

```cpp
// libs/cache_engine/anatomy/search_algorithm_permutation_engine.hpp
template <class... TopicConfigSets>
class SearchAlgorithmPermutationEngine : public PermutationEngine<TopicConfigSets...> {
public:
    static constexpr AnatomyGenus genus = AnatomyGenus::SearchAlgorithm;

    // Spezialisierte Composition-Materialization mit K=uint64_t, V=uint64_t Defaults
    template <class Visitor>
    static constexpr void for_each_search_algorithm(Visitor&& v) {
        Base::for_each_permutation([&]<class P>(){
            using AdHoc = CompositionFromPermTuple<P>;
            // Gattungs-spezifische Anatomie-Instantiation
            SearchAlgorithmAnatomy<AdHoc> anatomy;
            std::forward<Visitor>(v)(anatomy, AdHoc::name);
        });
    }
};

// libs/cache_engine/anatomy/sequence_permutation_engine.hpp
template <class... TopicConfigSets>
class SequencePermutationEngine : public PermutationEngine<TopicConfigSets...> {
public:
    static constexpr AnatomyGenus genus = AnatomyGenus::Sequence;
    // KEINE search_algo/cache_traversal/mapping Achsen — nur V-only-Achsen
    // SequenceAnatomy<AdHoc> hat reduzierten Achsen-Satz
};

// Analog: SetPermutationEngine, AdapterPermutationEngine, ViewPermutationEngine
```

### §29.3 CacheEngineBuilder waehlt Gattung pro Sprint

```cpp
// Pseudocode CacheEngineBuilder
int main(int argc, char** argv) {
    std::string genus = argv[1];  // "search" / "sequence" / "set" / ...
    if (genus == "search") {
        SearchAlgorithmPermutationEngine<...>::for_each_search_algorithm(...);
    } else if (genus == "sequence") {
        SequencePermutationEngine<...>::for_each_sequence(...);
    }
    // ...
}
```

Jede Gattung produziert eigene **Experiment-Algorithmus-Binaries** (.so/.dll)
mit eigenem Permutations-Raum.

---

## §30 Phasen-Plan: Wir beginnen bei Suchalgorithmen (Saeugetier)

User-Direktive: "Wir beginnen bei den Suchalgorithmen, also std::map<key,value>
aehnlichen Anatomie Permutationen."

| Sprint | Was | Status |
|---|---|---|
| **R5.C.0** | AnatomyBase + AnatomyConcept + AnatomyGenus enum + Tier-Metapher-Doku | Doku 14 §27-§29 done |
| **R5.C.A** | SearchAlgorithmAnatomy explizit als Gattung markieren (genus() = SearchAlgorithm) | NEXT |
| **R5.C.B** | SearchAlgorithmPermutationEngine als Spezialisierung anlegen | folgt |
| **R5.C.C** | Pruefling-Merge Stufe 2 + 3 (war urspruenglich R5.C-Plan) | folgt |
| **R5.D** | CacheEngineBuilder CLI + extern "C" ABI fuer Search-Algorithm-Anatomien | spaeter |
| **R5.E** | dlopen/LoadLibrary Module-Loader (IAnatomyBase virtual Interface) | spaeter |
| **R6 (V42)** | Andere Gattungen ergaenzen (Sequence/Set/Adapter/View) | optional V42 |

---

## §31 Konsistenz-Check mit existing Code (R3+R3.2+R4+R5.A+R5.B)

Bestehendes muss um Gattungs-Marker ergaenzt werden:

| Stand R5.B | Ergaenzung Teil 4 |
|---|---|
| `SearchAlgorithmAnatomy<C>` | `+ static constexpr AnatomyGenus genus() = SearchAlgorithm` |
| `AdHocComposition<T0...T16>` | unveraendert (Search-Achsen-Set) |
| `ObserverAggregate<C>` | unveraendert (POD-Snapshot pro Achse) |
| `AnatomyPermutationDriver<TopicConfigSets...>` | wird zu `SearchAlgorithmPermutationEngine<TopicConfigSets...>` umbenannt (Folge-Sprint) |
| `AnatomyExecutionContext<C>` | unveraendert (Builder-Wrapper) |
| `5 Builder-Commands` | unveraendert (Search-spezifisch ok fuer jetzt) |

**Memory-Updates:**
- NEU `[[anatomie-gattungen]]` — 5 Gattungen + Tier-Metapher + AnatomyBase

---

**Ende Teil 4 §25-§31 (Stand 2026-05-26 sehr spaet — User-Direktive Anatomie-Gattungen +
AnatomyBase + Gattungs-spezialisierte PermutationEngines).**

---

## §32 Gattungs-Constraint fuer Pruefling-Merge (User-Direktive 2026-05-26 sehr spaet)

### §32.1 User-Direktive verbatim

> "Wir stellen fest, dass wir nur gleiche Gattungen an Algorithmen miteinander
> kreuzen koennen, weil Gattungen die exakt selben permutativen Achsen verwenden.
> Dies ist eine Einschraenkung fuer die experimentelle Mischung mit einem
> Pruefungs-Algorithmus-Permutations-Stack gegen die cache-engine."

### §32.2 Formale Konsequenz fuer 3 Kompositionale Joins (Teil 3 §18)

Die 3 Joins in `pruefling_merge.hpp` (Stufe 1/2/3) sind nur **innerhalb derselben
Gattung** valide. Cross-Genus-Joins sind type-system-mathematisch unmoeglich, weil:

| Gattung | Pflicht-Achsen-Set (Teilmenge der 17) | Eigene Achsen (NEU) |
|---|---|---|
| **Mammal (SearchAlgorithm)** | 17 (komplett) | keine |
| **Bird (Set)** | 14 (kein mapping/value_handle/inner) | keine |
| **Reptile (Sequence)** | 9 (kein search_algo/cache_traversal/mapping/path_compression/node_type/index/filter) | `axis_growth` |
| **Invertebrate (Adapter)** | meiste delegated | `axis_inner` |
| **Plant (View)** | 7 | `axis_extent`, `axis_layout`, `axis_accessor` |

Da Achsen-Sets disjunkt sind, ist `mp_product<F, Set_A, Set_B>` mit Set_A != Set_B
**nicht typkompatibel** — die Wrapper-Klassen jeder Gattung haben
inkompatible Concept-Constraints (z.B. `SearchAlgoConcept` vs `SequenceConcept`).

### §32.3 Pflicht-Regel: Gattung-Match in Pruefling-Slot

Jeder Pruefling-Slot **MUSS** seine Gattung explizit deklarieren — die
PermutationEngine prueft Gattung-Match zur Compile-Zeit:

```cpp
namespace prt_art::axis_03a {
    struct Slot {
        using PrueflingVariants = mp::mp_list<PrtArtRadix512>;
        static constexpr bool has_pruefling = true;

        // R5.C.B Pflicht-Erweiterung: Gattungs-Marker fuer Slot-Validierung
        static constexpr AnatomyGenus genus = AnatomyGenus::SearchAlgorithm;
    };
}

// In SearchAlgorithmPermutationEngine: Compile-Time Genus-Check
template <class Default, class... Slots>
class SearchAlgorithmPermutationEngine : public PermutationEngine<...> {
    static_assert((Slots::genus == AnatomyGenus::SearchAlgorithm && ...),
        "ALLE Pruefling-Slots in SearchAlgorithmPermutationEngine muessen "
        "Mammal-Gattung sein. Cross-Genus-Merge ist unmoeglich (Doku 14 §32).");
};
```

### §32.4 Implikation fuer prt-art als experimenteller Pruefling

prt-art ist ein Adaptive-Radix-Tree Pruefling — passt zur **Mammal-Gattung** (K→V Map):
- Kompatibel: kann mit ArtComposition / HotComposition / WormholeComposition etc. gemischt werden
- Inkompatibel: KANN NICHT mit hypothetischer `VectorReptileComposition` (Sequence-Gattung) gemischt werden

### §32.5 Cross-Genus-Vergleich: nur als Wissenschaftliche Mess-Ebene (NICHT als Permutation)

Mess-Reihen koennen Mammal-Tier vs Reptile-Tier **vergleichen** (Performance-Studie
"std::map vs std::vector"), aber NICHT als gemischte Permutationen kombinieren.
Diese Cross-Genus-Mess-Reihen liegen in `CacheEngineBuilder` Ebene (R6/V42), NICHT
in der PermutationEngine.

### §32.6 Spezialisierte PermutationEngine pro Gattung (Recap Teil 4 §29)

Aus Gattungs-Constraint folgt zwingend: **eine PermutationEngine pro Gattung**.
Nicht eine generische `PermutationEngine<MixedGenus>`. Dies bestaetigt User-Direktive
aus Teil 4 §25 ("durch Unterklassen pro Anatomie-Gattung spezifiziert").

| PermutationEngine | Gattungs-Set | Status (R5.C.A) |
|---|---|---|
| `SearchAlgorithmPermutationEngine<...>` | nur Mammal-Slots | TODO R5.C.B |
| `SequencePermutationEngine<...>` | nur Reptile-Slots | TODO V42 |
| `SetPermutationEngine<...>` | nur Bird-Slots | TODO V42 |
| `AdapterPermutationEngine<...>` | nur Invertebrate-Slots | TODO V42 |
| `ViewPermutationEngine<...>` | nur Plant-Slots | TODO V42 |

### §32.7 Build-System-Konsequenz

CacheEngineBuilder muss bei `cmake -DCOMDARE_GENUS=mammal` nur Mammal-Compositions
generieren. Bei `--genus=reptile` nur Sequence-Compositions. Cross-Genus-Builds
sind ungueltig und werden mit `static_assert` blockiert.

### §32.8 Update Memory-Direktive

Neue Direktive `[[gattungs-constraint-pruefling-merge]]` markiert die Pflicht:
- Pruefling-Slots deklarieren Gattung
- PermutationEngine validiert Gattung-Match zur Compile-Zeit
- Cross-Genus-Joins sind Architektur-Verstoss

---

**Ende Teil 4 §32 (Stand 2026-05-26 sehr spaet — User-Direktive Gattungs-Constraint
fuer Pruefling-Merge, R5.C.A-Sprint-Ende-Vertiefung).**

---

# Teil 5 — ExecutionEngine als Wurzel ueber AnatomyBase (Lebewesen vs Viren)

> **Anmerkung [[never-delete-documentation]]:** Teil 1+2+3+4 oben unangetastet.
> Teil 5 dokumentiert die User-Direktive 2026-05-27 frueh zur fundamentalen
> Wurzel-Strukturierung: ExecutionEngine ist die generischere Mess-Wurzel ueber
> AnatomyBase. Anatomien (Lebewesen) sind eine SPEZIALISIERUNG; "Viren" (Nicht-
> Lebewesen wie Graphen-Algorithmen) sind eine andere Spezialisierung — beide
> ausmessbar via gemeinsamer ExecutionEngine-Mess-Schnittstelle.

---

## §33 User-Direktive verbatim (R5.C.A-Sprint-Ende-Erweiterung)

> "Hinweis: weiter vorne in der Dokumentation hatten wir weiterhin beschrieben,
> dass die Wurzel, der mit der aktuelleren ueberholten SearchEngine (jetzt
> Anatomie mit Gattungen), des Konstruktes eine Execution Engine sein sollte,
> welche noch ueber der AnatomyBase steht. Diese verhaelt sich zur Anatomie eines
> Lebewesens, wie der Unterschied zwischen Lebewesen und Viren: Die Viren sind
> nicht lebendig und haben wiederum ein eigenes System, moeglicherweise keine
> Topics und Achsen, aber sie koennen auch ausgemessen werden (Beispielhaft waeren
> das etwa Graphen-Algorithmen, die eine eigene ganz andere Anatomie beherbergen)
> -> Wir trennen das allgemeine Mess-Interface auf die ExecutionEngine auf, von
> der die AnatomyBase mit ihrer Spezifikation ueber Topics und Achsen erbt."

---

## §34 Biologische Klassifikation der Wurzel-Hierarchie

### §34.1 Drei-Ebenen-Taxonomie (analog Biologie)

```
                  ExecutionEngine (ALLES Ausmessbare)
                       │
        ┌──────────────┴──────────────────┐
        │                                 │
   AnatomyBase                    VirusExecutionEngine
   (Lebewesen, Kingdom=Animalia)  (Nicht-Lebewesen, kein Stoffwechsel)
        │                                 │
   5 Gattungen:                      Beispiele:
   - SearchAlgorithm (Mammal)       - Graphen-Algorithmen (BFS/DFS/Dijkstra)
   - Set (Bird)                     - Funktionale Pipelines
   - Sequence (Reptile)             - Stream-Processor
   - Adapter (Invertebrate)         - Pure-Math Algorithmen (FFT/Matrix-Multiply)
   - View (Plant)                   - Crypto-Hashes
```

### §34.2 Biologische Metapher-Schaerfung

**Lebewesen (Anatomie):** haben Organe (Achsen), erben von AnatomyBase, sind in
17 (Mammal) bzw. weniger Achsen zerlegbar. Permutierbar via PermutationEngine.

**Viren (VirusExecutionEngine):** haben KEINEN Stoffwechsel (keine
Topics/Achsen), sind aber MESSBAR (Latenz/Throughput/Cache-Misses). Sie sind
"Kapseln" mit eigenem Inneren — keine Achsen-Permutation moeglich, aber
Algorithm-internes Tuning ist denkbar (z.B. Graphen-BFS mit unterschiedlichen
Adjacency-Representations).

**Gemeinsame Wurzel ExecutionEngine:** Mess-Interface (Latenz, Throughput,
Cache-Misses, Speicher-Verbrauch) ist allgemein und gilt fuer beide.

---

## §35 ExecutionEngine — Compile-Time-Concept + Virtual-Interface

### §35.1 ExecutionEngineConcept (Compile-Time Wurzel)

```cpp
// libs/cache_engine/execution_engine/execution_engine_base.hpp

enum class ExecutionEngineKind : std::uint8_t {
    Anatomy = 0,         ///< Lebewesen — erbt AnatomyBase, hat Topics/Achsen
    Virus   = 1,         ///< Nicht-Lebewesen — kein Anatomie-Stoffwechsel, eigenes Mess-System
    Hybrid  = 2          ///< experimentell: kombiniert beide (V42+)
};

/// ExecutionEngineConcept — Wurzel-Concept aller ausmessbaren Algorithmen.
template <class E>
concept ExecutionEngineConcept = requires {
    typename E::measurement_snapshot_t;          // Pflicht: eigener Snapshot-POD
    { E::engine_name() } -> std::convertible_to<std::string_view>;
    { E::engine_kind() } -> std::convertible_to<ExecutionEngineKind>;
};
```

### §35.2 IExecutionEngine (Virtual Interface)

```cpp
/// IExecutionEngine — abstract base fuer Runtime-ABI (Module-Loader).
class IExecutionEngine {
public:
    virtual ~IExecutionEngine() = default;
    [[nodiscard]] virtual std::string_view      engine_name() const noexcept = 0;
    [[nodiscard]] virtual ExecutionEngineKind   engine_kind() const noexcept = 0;

    // Mess-Schnittstelle (Pflicht — wie das gemessen wird, ist Engine-spezifisch)
    // Snapshot-Type ist Engine-spezifisch via measurement_snapshot_t
    // Hier nur abstrakte Trigger-Schnittstelle:
    virtual void warm_up()  = 0;  ///< Engine vor Mess-Reihe vorwaermen
    virtual void reset()    = 0;  ///< Statistik-Reset (NICHT Container-Clear!)
    virtual void shutdown() = 0;  ///< Engine sauber herunterfahren
};
```

### §35.3 AnatomyBase erbt von IExecutionEngine

```cpp
// libs/cache_engine/anatomy/anatomy_base.hpp (Update R5.C.A2)

class IAnatomyBase : public IExecutionEngine {
public:
    // engine_kind() liefert immer Anatomy (Pflicht-Override)
    [[nodiscard]] ExecutionEngineKind engine_kind() const noexcept final {
        return ExecutionEngineKind::Anatomy;
    }

    // Zusaetzliche Anatomie-spezifische Pflicht-API:
    [[nodiscard]] virtual std::string_view composition_name() const noexcept = 0;
    [[nodiscard]] virtual std::string_view paper_id() const noexcept = 0;
    [[nodiscard]] virtual AnatomyGenus     genus() const noexcept = 0;
    [[nodiscard]] virtual std::size_t      organ_count() const noexcept = 0;
};
```

### §35.4 IVirusExecutionEngine (parallel zu IAnatomyBase)

```cpp
// libs/cache_engine/execution_engine/virus_execution_engine.hpp (R6 NEU pending)

class IVirusExecutionEngine : public IExecutionEngine {
public:
    [[nodiscard]] ExecutionEngineKind engine_kind() const noexcept final {
        return ExecutionEngineKind::Virus;
    }

    // Virus-spezifische Pflicht-API:
    [[nodiscard]] virtual std::string_view algorithm_family() const noexcept = 0;  // z.B. "GraphBFS"
    [[nodiscard]] virtual std::string_view algorithm_paper()  const noexcept = 0;  // Paper-Referenz

    // KEINE Achsen, KEINE Composition — Virus ist intern undurchsichtig
};
```

---

## §36 Beispiele fuer Viren (V42+ Erweiterung)

### §36.1 Graphen-Algorithmen
- BFS / DFS / Dijkstra / A*
- Min-Cut / Max-Flow
- PageRank / HITS
- Strongly-Connected-Components

**Charakteristik:** kein K-V-Mapping, keine 17 Achsen — interne Graph-
Representation ist Implementation-Detail (Adjacency-Matrix vs Adjacency-List).
Mess-Snapshot ist Latenz + Speicher pro Graph-Operation.

### §36.2 Funktionale Pipelines
- Map/Reduce-Pipelines
- Filter-Cascades
- Stream-Processor (Kafka-Style)

**Charakteristik:** stateless oder mit minimaler State — Mess-Snapshot ist
Throughput + Latenz pro Datensatz.

### §36.3 Pure-Math Algorithmen
- FFT / Matrix-Multiply
- Convex Optimization (SGD/Adam)
- Crypto-Hashes (SHA256/BLAKE3)

**Charakteristik:** Input → Output Transformation ohne Container — Mess-Snapshot
ist Throughput + FLOPs pro Sekunde.

---

## §37 Verantwortlichkeits-Update (Erweiterung Teil 3 §17)

| Akteur | Stand R5.C.A | Update Teil 5 |
|---|---|---|
| **PermutationEngine** | Anatomie-Generator | nur fuer ExecutionEngineKind::Anatomy |
| **VirusExecutionEngineFactory** (NEU R6) | n.v. | erzeugt Virus-Instanzen ohne Permutation |
| **AnatomyBase** | nur Organ-Container | erbt von IExecutionEngine |
| **CacheEngineBuilder** | Mess-Orchestrierung fuer Anatomien | Mess-Orchestrierung fuer **alle** ExecutionEngines (Anatomy + Virus) |

### §37.1 CacheEngineBuilder als Mess-Plattform fuer beide

```cpp
// Pseudocode CacheEngineBuilder R5.D
class CacheEngineBuilder {
public:
    // Hauptmess-Schleife fuer ExecutionEngine (Anatomy ODER Virus)
    template <ExecutionEngineConcept E>
    void measure_engine(E& engine, Workload const& wl);

    // Spezialisiert fuer Anatomien (mit Composition-Iteration)
    template <ana::AnatomyConcept A>
    void measure_anatomy_permutations(/* PermutationEngine + Anatomy */);

    // Spezialisiert fuer Viren (ohne Composition-Iteration)
    template <ExecutionEngineConcept V>
        requires (V::engine_kind() == ExecutionEngineKind::Virus)
    void measure_virus(V& virus, Workload const& wl);
};
```

---

## §38 Konsistenz-Check mit existing Code

### §38.1 Existing IExecutingEngine (legacy/deprecated)

In `libs/deprecated/prt_art_legacy/include/prt_art/concepts/i_executing_engine.hpp`
existiert eine alte IExecutingEngine (REV 5, 2026-05-18) mit `warm_up/reset/shutdown`
+ `bind_cache_engine()`. **Diese ist die Vorlage** fuer die neue Wurzel-Schicht.

**Migration-Pfad (R5.C.A2 Sprint):**
1. NEUE Datei `libs/cache_engine/execution_engine/execution_engine_base.hpp` mit
   `IExecutionEngine` (ohne `bind_cache_engine` — das war prt-art-spezifisch)
2. AnatomyBase (R5.C.A) wird ergaenzt um Inheritance von IExecutionEngine
3. Existing `i_executing_engine.hpp` im prt_art_legacy bleibt unveraendert
   (Kompatibilitaet zu alten prt-art Modulen) — wird in V42 deprecated

### §38.2 Mess-Saeule (M-Modell-Verbindung)

Doku 10 `10_schichten_modell_M.md` §0.4 zeigt: CacheEngineBuilder orchestriert
ExecutionEngine A + ExecutionEngine B parallel via Command-Pattern. Diese
"ExecutionEngine A/B" Notation ist konsistent mit der neuen Wurzel.

**Pre-Read-Pflicht-Update:** Doku 10 §0-§4 ist Wurzel-Modell, wird in jeder
zukuenftigen Architektur-Iteration referenziert.

---

## §39 Phasen-Plan-Update fuer R5.C.A2 (NEU)

| Sprint | Was | Wo |
|---|---|---|
| **R5.C.A2 NEXT** | ExecutionEngineConcept + IExecutionEngine + ExecutionEngineKind enum | `libs/cache_engine/execution_engine/` |
| R5.C.A3 | AnatomyBase als Spezialisierung von IExecutionEngine (Inheritance + final-Override) | Update `anatomy_base.hpp` |
| R5.C.B | SearchAlgorithmPermutationEngine genus-aware | `anatomy/search_algorithm_permutation_engine.hpp` |
| R5.D | CacheEngineBuilder CLI + extern "C" ABI (ExecutionEngine-Factory) | `apps/anatomy_binary/` |
| R5.E | dlopen/LoadLibrary Module-Loader (IExecutionEngine Factory) | `builder/module_loader/` |
| R6 (V42) | VirusExecutionEngine fuer Graphen-Algorithmen (erste Virus-Implementation) | `libs/cache_engine/virus/` |
| R7 (V42) | F15-Auswertung schnellstes Tier + Virus-Vergleich | `Diplomarbeit/06_auswertung/` |

---

## §40 Memory-Update

NEU `[[execution-engine-als-wurzel]]` markiert die Pflicht:
- ExecutionEngine ist die wahre Wurzel ueber AnatomyBase
- AnatomyBase erbt von IExecutionEngine
- Viren (Graphen etc.) erben direkt von IExecutionEngine (keine Anatomie)
- Mess-Schnittstelle (warm_up/reset/shutdown) ist auf IExecutionEngine-Ebene

---

**Ende Teil 5 §33-§40 (Stand 2026-05-27 sehr frueh — User-Direktive ExecutionEngine
als Wurzel ueber AnatomyBase + Virus-Analogie fuer Nicht-Lebewesen).**

---

# Teil 6 — SearchAlgorithmAbiAdapter Production-Header (R5.C.A3)

> **Anmerkung [[never-delete-documentation]]:** Teil 1+2+3+4+5 oben unangetastet.
> Teil 6 dokumentiert die R5.C.A3-Lieferung — Promotion des bisher in Tests
> dupliziert lokal definierten ABI-Adapters zu einem Production-Header sowie die
> Naming-Korrektur `MammalAbiAdapter` → `SearchAlgorithmAbiAdapter` per User-Direktive
> 2026-05-27 (technische Symbole statt metaphorischer Klassen-Namen).

---

## §41 R5.C.A3 — Lieferung + Hintergrund

### §41.1 User-Direktive verbatim (2026-05-27 vormittag)

> "Wir nennen den MammalAbiAdapter besser SearchAlgorithmAbiAdapter. Wir nehmen
> sicherlich die Tierwelt als Metapher, muessen aber bei der aktuellen Aufgabe
> bleiben. Bitte pruefe, ob wir noch irgendwo statt der technischen Benennung
> versehentlich die metaphorische Benennung als Uebersetzung verwendet haben."

### §41.2 Konvention: technische Symbole vs metaphorische Doku

| Schicht | Erlaubte Sprache | Beispiele |
|---|---|---|
| **Code-Identifier** (Klassen/Funktionen/Variablen) | NUR technisch | `SearchAlgorithmAbiAdapter`, `AnatomyGenus::SearchAlgorithm` |
| **Doku-Kommentare im Code** | beides erlaubt (Doku-Text) | "Saeugetier-Anatomie-Metapher", "Mammal-Gattung in Tier-Metapher" |
| **Architektur-Doku (.md)** | beides erlaubt | siehe Teil 1-5 oben |

**Begruendung:** Code-Identifier sind API-Vertrag → muessen aus dem Anwendungs-
domain (Search-Algorithm) lesbar sein. Kommentare/Doku-Text erlauben die
Tier-Metapher als didaktische Hilfe.

### §41.3 Pre-existing Befund: test_v41_anatomy_base.cpp war seit R5.C.A2 broken

Vor R5.C.A3-Start zeigte ein Audit-Build:

```
test_v41_anatomy_base.cpp(119,33): error C2259:
"AnatomyAbiAdapter<comdare::cache_engine::anatomy::Art>":
Abstrakte Klasse kann nicht erstellt werden.
```

Ursache: `AnatomyAbiAdapter` (lokal in `test_v41_anatomy_base.cpp:110`) hat nur
`composition_name/paper_id/genus/organ_count` ueberschrieben. Nach R5.C.A2 erbt
`IAnatomyBase` aber von `IExecutionEngine` — zusaetzliche Pflicht-Overrides
`engine_name/lifecycle_state/warm_up/reset/shutdown` waren in der Test-Adapter-
Klasse nicht implementiert.

Die Session-Doku Teil II §16 listete "12 Tests grün" — das stimmte fuer den
Stand vor dem R5.C.A2-Build (R5.C.A war zuletzt grün). R5.C.A3 ist also
gleichzeitig Cleanup UND Bug-Fix.

### §41.4 Production-Header `libs/cache_engine/anatomy/abi_adapter.hpp`

```cpp
template <AnatomyConcept A>
class SearchAlgorithmAbiAdapter final : public IAnatomyBase {
    static_assert(A::genus() == AnatomyGenus::SearchAlgorithm,
                  "SearchAlgorithmAbiAdapter erwartet eine SearchAlgorithm-Gattung-"
                  "Anatomie (AnatomyGenus::SearchAlgorithm). Cross-Genus-Adapter "
                  "sind type-system-mathematisch unmoeglich — Doku 14 §32.");
public:
    // IExecutionEngine Override (5 Methoden, Lifecycle-State maschinell)
    [[nodiscard]] std::string_view engine_name() const noexcept override;
    [[nodiscard]] EngineLifecycleState lifecycle_state() const noexcept override;
    void warm_up()  override;
    void reset()    override;
    void shutdown() override;
    // IAnatomyBase Override (4 Methoden, statisch delegiert an A::xxx())
    [[nodiscard]] std::string_view composition_name() const noexcept override;
    [[nodiscard]] std::string_view paper_id() const noexcept override;
    [[nodiscard]] AnatomyGenus     genus() const noexcept override;
    [[nodiscard]] std::size_t      organ_count() const noexcept override;
private:
    EngineLifecycleState state_{EngineLifecycleState::Uninitialized};
};
```

**Wichtig:** `static_assert` validiert Gattungs-Constraint (Doku 14 §32) bereits
beim Adapter-Bau zur Compile-Zeit. Eine ggf. zukuenftige `SequenceAnatomy<C>`-
Instantiation wuerde nicht in den `SearchAlgorithmAbiAdapter` passen — der Build
schlaegt mit klarer Diagnostik fehl.

### §41.5 Verwendung in R5.E Module-Factory-Pattern

```cpp
// In generiertem Permutations-Binary (.so/.dll):
extern "C" comdare::cache_engine::anatomy::IAnatomyBase*
comdare_create_anatomy() {
    using A = comdare::cache_engine::anatomy::SearchAlgorithmAnatomy<MyComposition>;
    return new comdare::cache_engine::anatomy::SearchAlgorithmAbiAdapter<A>{};
}
```

Der CacheEngineBuilder (R5.D) wird pro Permutation ein .so/.dll mit dieser
Factory generieren. R5.E loadet via `dlopen`/`LoadLibrary` und ruft
`comdare_create_anatomy` → bekommt `IAnatomyBase*`-Pointer mit korrektem
Lifecycle-Tracking.

### §41.6 Test-Refactor (Konsolidierung 2 → 0 lokale Adapter)

| File | Vorher | Nachher |
|---|---|---|
| `test_v41_anatomy_base.cpp` | lokale `AnatomyAbiAdapter` (broken) | `ana::SearchAlgorithmAbiAdapter<A>` |
| `test_v41_execution_engine.cpp` | lokale `MammalAbiAdapter` (lauffaehig) | `ana::SearchAlgorithmAbiAdapter<A>` |

Test-Endstand R5.C.A3: alle 7 Anatomy-Tests gruen (13+10+12+21+13+12+11 = 92).

### §41.7 Identifier-Audit (Metapher-Code-Bezeichner)

Grep nach `\b(Mammal|Bird|Reptile|Invertebrate|Plant|Frankenstein|Saeugetier|
Vogel|Reptil|Wirbelloses|Pflanze|Tier)\b` in `libs/`+`tests/`:

| Befund | Kategorie | Aktion |
|---|---|---|
| `MammalAbiAdapter` (abi_adapter.hpp) | Code-Identifier | umbenannt zu `SearchAlgorithmAbiAdapter` |
| `MammalAbiAdapter` (test_v41_execution_engine.cpp) | Code-Identifier | entfernt, Production-Adapter nutzen |
| Test-Macros `R5CA_GenusMarker.AllElevenAnatomiesAreMammal` etc. | Test-Beschreibung | OK (test-internal, Reasoning-Text) |
| `Frankenstein` / `FrankensteinComposition` (test_v41_anatomy.cpp) | Test-Demo-Helper | OK (interner Test-Helper, kein API) |
| Kommentare "Saeugetier-Anatomie-Metapher" | Doku-Text in Code | OK (didaktischer Doku-Text) |
| Doku 14 Sektions-Texte | Architektur-Doku | OK (Metapher etabliert) |

**Konsequenz:** Architektur-Doku + Doku-Text-Kommentare bleiben unveraendert.
Nur API-Identifier wurden uebersetzt.

### §41.8 Memory-Update (`feedback_technical_identifiers_over_metaphor`)

Neue Direktive: `[[technical-identifiers-over-metaphor]]`
- **Rule:** Code-Identifier (Klassen-Namen, Funktionen, Variablen, Konstanten)
  MUESSEN technische Bezeichner aus der Anwendungs-Domain verwenden.
- **Erlaubt:** metaphorische Sprache in Doku-Kommentaren UND in Architektur-`.md`
- **Why:** API-Vertrag muss aus dem Anwendungs-Domain lesbar sein. Metaphern
  helfen beim Verstaendnis, gehoeren aber nicht in den Klassen-Namen.
- **How to apply:** vor jedem Code-Commit grep `\b(Mammal|Bird|Reptile|...)\b`
  auf neue Code-Identifier.

---

**Ende Teil 6 §41 (Stand 2026-05-27 vormittag — R5.C.A3 SearchAlgorithmAbiAdapter
Production-Header + technische-Identifier-Konvention).**

---

# Teil 7 — SearchAlgorithmPermutationEngine (R5.C.B Genus-Specialization)

> **Anmerkung [[never-delete-documentation]]:** Teil 1-6 oben unangetastet.
> Teil 7 dokumentiert die R5.C.B-Lieferung — die erste Gattungs-spezialisierte
> PermutationEngine fuer die SearchAlgorithm-Gattung mit Compile-Time-Validierung
> von Pruefling-Slot-Gattungs-Constraint (Doku 14 §32).

---

## §42 R5.C.B — SearchAlgorithmPermutationEngine + Slot-Genus-Detection

### §42.1 User-Direktive-Referenz

Aus Doku 14 §29.2 (User-Direktive 2026-05-26 sehr spaet):

> "Die Permutation Engine muss fuer die anatomischen Moeglichkeiten jeder
>  Anatomie-Gattungen durch Unterklassen spezifiziert werden, die von der
>  Haupt-Permutation-Engine erben und diese fuer jede Anatomie-Gattung
>  spezifizieren, um korrekt gesteuert durch die CacheEngineBuilder Anatomien
>  und damit Experiment-Algorithmus-Binaries ausliefern zu koennen."

Aus Doku 14 §32 (User-Direktive 2026-05-26 sehr spaet, R5.C.A-Sprint-Ende):

> "Wir koennen nur gleiche Gattungen an Algorithmen miteinander kreuzen, weil
>  Gattungen die exakt selben permutativen Achsen verwenden."

### §42.2 Lieferung R5.C.B

| Datei | Aktion |
|---|---|
| `libs/cache_engine/anatomy/pruefling_merge.hpp` | Erweitert: `HasExplicitGenus<Slot>` Concept, `slot_genus_v<Slot>` Helper (Default = SearchAlgorithm), `IsSlotOfGenus_v<Slot,G>` Predicate, `IsSearchAlgorithmSlot` Concept |
| `libs/cache_engine/anatomy/search_algorithm_permutation_engine.hpp` | NEU — `SearchAlgorithmPermutationEngine<TopicConfigSets...>` Klasse |
| `tests/unit/test_v41_search_algorithm_permutation_engine.cpp` | NEU — 15 Tests |
| `tests/unit/CMakeLists.txt` | Test-Target hinzugefuegt |

### §42.3 SearchAlgorithmPermutationEngine API

```cpp
template <class... TopicConfigSets>
class SearchAlgorithmPermutationEngine {
public:
    // Gattungs-Marker (Doku 14 §27.2 + §29.2)
    static constexpr AnatomyGenus genus = AnatomyGenus::SearchAlgorithm;

    // Inspection (delegiert an PermutationEngine)
    using all_permutations = ...;
    static constexpr std::size_t count() noexcept;
    static constexpr std::size_t arity() noexcept;

    // R5.C.B Pruefling-Slot-Validierung (Doku 14 §32.3)
    template <class Slot>
    static constexpr void assert_pruefling_slot_genus() noexcept;
    template <class... Slots>
    static constexpr void assert_all_pruefling_slots_genus() noexcept;

    // Compile-Time Genus-Match-Predicate
    template <class... Slots>
    static constexpr bool slots_match_genus_v = ...;

    // Technisch benannte Iteration (Doku 14 §41 [[technical-identifiers-over-metaphor]])
    template <class Visitor>
    static constexpr void for_each_search_algorithm(Visitor&& v);     // ≈ for_each_animal
    template <class Visitor>
    static constexpr void for_each_composition_type(Visitor&& v);

    // R5.E Module-Loader-Vorbereitung — produziert IAnatomyBase pro Permutation
    template <class Visitor>
    static constexpr void for_each_abi_adapter(Visitor&& v);
};
```

### §42.4 Pruefling-Slot Gattung-Deklaration

Pruefling-Slots koennen ihre Gattung jetzt explizit deklarieren (Doku 14 §32.3):

```cpp
// In prt-art/include/prt_art/axis_03a_slot.hpp:
namespace prt_art::axis_03a {
    struct Slot {
        using PrueflingVariants = mp::mp_list<PrtArtRadix512>;
        static constexpr bool has_pruefling = true;
        static constexpr AnatomyGenus genus = AnatomyGenus::SearchAlgorithm;  // R5.C.B PFLICHT
    };
}

// Validierung (frueh im Pruefling-Header empfohlen):
SearchAlgorithmPermutationEngine<...>::assert_pruefling_slot_genus<prt_art::axis_03a::Slot>();
```

**Optional bei Implicit-Default:** wenn `Slot::genus` nicht deklariert ist, gilt
Default `SearchAlgorithm` (via `slot_genus_v<Slot>` Helper). Backward-kompatibel
zu existing Slots aus R5.C.

**Cross-Genus-Slot (illegal):**
```cpp
struct SequenceSlot {
    using PrueflingVariants = mp::mp_list<>;
    static constexpr bool has_pruefling = false;
    static constexpr AnatomyGenus genus = AnatomyGenus::Sequence;  // FALSCH fuer SearchAlgorithm-Engine
};
// SearchAlgorithmPermutationEngine<...>::assert_pruefling_slot_genus<SequenceSlot>();
// → static_assert mit klarer Diagnostik:
//   "Slot gehoert nicht zur SearchAlgorithm-Gattung. Cross-Genus-Joins sind
//    type-system-mathematisch unmoeglich (Doku 14 §32)."
```

### §42.5 Tests-Snapshot R5.C.B

15 neue Tests in `test_v41_search_algorithm_permutation_engine.cpp`:

| § | Test-Gruppe | Tests |
|---|---|---|
| §1 | Genus-Marker | 1 (GenusIsSearchAlgorithm) |
| §2 | count/arity-Delegation | 1 |
| §3-§5 | Slot-Genus-Detection (Implicit/Explicit/Sequence/Set) | 4 |
| §6 | IsSearchAlgorithmSlot Concept (positiv + negativ) | 2 |
| §7 | assert_pruefling_slot_genus Compile-Time-Check | 2 |
| §8 | slots_match_genus_v Predicate | 2 |
| §9 | for_each_search_algorithm/for_each_composition_type | 2 |
| §10 | for_each_abi_adapter (R5.E-Vorbereitung) | 1 |

Anatomy-Tests gesamt: **107 grün** (8 Test-Files, +15 vs R5.C.A3).

### §42.6 Bezug zu AnatomyPermutationDriver (R4)

`SearchAlgorithmPermutationEngine` ist eine zusaetzliche Schicht ueber dem
existing `AnatomyPermutationDriver`. Der Driver bleibt als technische Facade
verfuegbar und wird intern delegiert. Zukuenftige Gattungs-Engines
(SequencePermutationEngine, SetPermutationEngine etc. fuer V42) folgen demselben
Pattern.

| Schicht | Aufgabe |
|---|---|
| `pe::PermutationEngine<TopicConfigSets...>` | Cartesian-Product generisch (kein Anatomie-Wissen) |
| `ana::AnatomyPermutationDriver<TopicConfigSets...>` | Anatomie-Instantiation pro Permutation (R4) |
| `ana::SearchAlgorithmPermutationEngine<TopicConfigSets...>` | Genus-Spezialisierung mit Constraint-Validation (R5.C.B) |

### §42.7 NEXT-Phase Vorbereitung

R5.D CacheEngineBuilder CLI kann jetzt:
- Pro Permutation `SearchAlgorithmAbiAdapter<...>` materialisieren (R5.C.A3)
- Genus-Constraint auf Pruefling-Slots erzwingen (R5.C.B)
- `for_each_abi_adapter` als Mess-Loop-Iterator nutzen

R5.E Module-Loader (dlopen/LoadLibrary) Factory-Pattern:
```cpp
// Generiertes Permutations-Binary (.so/.dll)
extern "C" comdare::cache_engine::anatomy::IAnatomyBase*
comdare_create_anatomy() {
    using A = comdare::cache_engine::anatomy::SearchAlgorithmAnatomy<MyComposition>;
    return new comdare::cache_engine::anatomy::SearchAlgorithmAbiAdapter<A>{};
}
```

---

**Ende Teil 7 §42 (Stand 2026-05-27 vormittag — R5.C.B SearchAlgorithmPermutationEngine
Genus-Specialization + Slot-Genus-Detection + 15 Tests).**

---

# Teil 8 — IExecutionEngine.run() Lifecycle-Vervollstaendigung (R5.C.A4)

## §43 R5.C.A4 — Lifecycle-Hook run() ergaenzt

### §43.1 User-Bemerkung 2026-05-27 mittag

> "Das folgende war schon richtig fehlte noch run(). Ansonsten waren die uebrigen
> geloeschten Funktions-Features auch richtig — muessen nur in technische
> Aequivalente uebersetzt werden bezueglich des Kontextes, das gilt global fuer
> alle Benennungen → bitte Umbenennungsaufgabe ans Ende aller Aufgaben in der
> TODO Liste planen, wenn wir passendere technische Begriffe als Uebersetzung
> der Methaphern gefunden haben, wir behalten fuer das Verstaendnis die
> Methaphern noch fuer die Zeit der Entwicklung bei, weil es die
> Abstraktions-Hierarchien klarer hervorhebt."

### §43.2 Befund vor Fix

`IExecutionEngine` hatte `EngineLifecycleState::Running` als Enum-Wert, aber keine
`run()`-Methode zum Aktivieren. Lifecycle-Sequenz war nur teilweise dispatcht:
`warm_up() → ??? → reset()/shutdown()`. Der Uebergang `Warming → Running` war
nicht aufrufbar — Mess-Schicht haette `state_ = Running` nur durch direkten
Member-Zugriff setzen koennen (Verstoss gegen Polymorphie-Pattern).

### §43.3 Lieferung R5.C.A4

| Datei | Aenderung |
|---|---|
| `execution_engine_base.hpp` | `virtual void run() = 0` ergaenzt + Doku-Kommentar (Pflicht aller ExecutionEngines) |
| `abi_adapter.hpp` | `SearchAlgorithmAbiAdapter::run()` setzt `state_ = Running` |
| `test_v41_execution_engine.cpp` | `GraphBfsVirusStub::run()` + 3 Tests erweitert (full Lifecycle-Roundtrip warm_up→run→reset→shutdown) |
| `test_v41_anatomy_base.cpp` | Adapter-Lifecycle-Test um run() erweitert |
| `test_v41_search_algorithm_permutation_engine.cpp` | `for_each_abi_adapter` Mess-Loop nutzt run() vor Workload |

### §43.4 Vollstaendige Lifecycle-Sequenz (Pflicht-Pattern fuer R5.D Mess-Treiber)

```cpp
IExecutionEngine& engine = ...;
engine.warm_up();   // Uninitialized → Warming    (Cache-Preheat, Bulk-Load)
engine.run();       // Warming → Running          (R5.C.A4 NEU, Workload-Driver dispatched)
// ... Workload-Phase (Insert/Lookup/Erase Commands) ...
engine.reset();     // Running → Idle             (Statistik-Reset zwischen Mess-Reihen)
engine.shutdown();  // Idle → Shutdown            (Resources freigeben)
```

CacheEngineBuilder (R5.D) wird `warm_up()→run()→reset()→shutdown()` als Pflicht-
Sequenz fuer jeden Mess-Pass enforcen.

### §43.5 ExecutionEngineConcept bleibt unveraendert

`ExecutionEngineConcept` definiert nur die Compile-Time-Pflicht-Members
(`measurement_snapshot_t`, `engine_name()`, `engine_kind()`). Die Lifecycle-API
(`warm_up/run/reset/shutdown`) liegt ausschliesslich im Virtual-Interface
`IExecutionEngine` — Compile-Time-Concepts pruefen statische Konstanten,
Runtime-Polymorphie regelt Lifecycle-Hooks.

### §43.6 Cleanup-Sprint-Planung (User-Direktive R5.C.A4 + Task #704)

User-Direktive: Metaphern (Tier/Saeugetier/Mammal/Bird/Reptile/Invertebrate/
Plant/Frankenstein) **bleiben waehrend der Entwicklung erhalten** weil sie die
Abstraktion-Hierarchien klarer hervorheben. **Cleanup-Sprint am Ende aller
Implementierungs-Aufgaben** (Task #704 V41.Z.1, vor finaler Release):
- grep-Audit nach Metapher-Code-Identifiern in libs/+tests/+apps/
- Pro Treffer technische Uebersetzung suchen (vom Anwendungs-Domain)
- Kommentare + Architektur-Doku behalten Metaphern als didaktische Bruecke

R5.C.A3 SearchAlgorithmAbiAdapter-Umbenennung war einzelner Vorgriff (zentraler
Adapter-Klassen-Name). Restliche Metapher-Identifier bleiben bis V41.Z.1.

---

**Ende Teil 8 §43 (Stand 2026-05-27 mittag — R5.C.A4 run() Lifecycle-Hook ergaenzt +
Cleanup-Sprint V41.Z.1 fuer Endphase geplant).**
