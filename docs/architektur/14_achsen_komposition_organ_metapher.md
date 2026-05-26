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

### §14.2 Phase R3.2 — OriginalXxx-Wrappers-Entscheidung

**Empfehlung Option D (NEU):** `OriginalXxx`-Wrappers werden DEPRECATED zugunsten
`SearchAlgorithmAnatomy<XxxComposition>` Template-Instantiation. Loeschung in R3.3
nach Anatomie-Pilot verifiziert.

### §14.3 Phase R4 — PermutationEngine + Cartesian

1. `src/permutations/permutation_engine.hpp` mit `mp_product` ueber alle 15 Achsen-Listen
2. Pro Permutation: `using AdHocComposition = make_composition_from_tuple<...>::type;`
3. PermutationEngine instantiiert `SearchAlgorithmAnatomy<AdHocComposition>` ueber alle Punkte
4. CacheEngineBuilder linkt pro Permutation .so/.dll
5. Mess-Treiber loadet .so/.dll und misst Performance

---

## §15 Pflicht fuer naechste Phasen

| Phase | Was | Wo |
|---|---|---|
| **R3 jetzt** | SearchAlgorithmAnatomy<C> Template-Skelett | `libs/cache_engine/anatomy/` |
| **R3.2** | OriginalXxx Deprecation-Plan | Doku 13 Teil J |
| **R4** | PermutationEngine mp_product 15 Achsen | `src/permutations/` |
| **R5** | CacheEngineBuilder pro Permutation .so/.dll | `apps/cache_engine_builder/` |
| **R6 (V42)** | Mess-Treiber + Welch-Test ueber tausende Permutationen | `Diplomarbeit/Code/02_messung_driver/` |
| **R7 (V42)** | F15-Auswertung: schnellste Permutation identifizieren | `Diplomarbeit/06_auswertung/` |

---

**Ende Teil 2 (Stand 2026-05-26 spaet — User-Vertiefung Saeugetier-Anatomie + F15-Forschungsmission).**
