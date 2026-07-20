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

> ## KORREKTUR-Banner (korr. 2026-06-03, s. Doc 30 §8.0)
>
> **Begriffs-Schärfung gegenüber dem verbindlichen 3-Ebenen-Modell (Doc 30 §8.0;
> verbatim verankert in Doc 24 §8.8 + diesem Dokument §25).** Dieses Dokument ist
> das Quell-Dokument der Organ-/Lebewesen-Metapher und verwendet den Begriff **„Gattung"**
> historisch DOPPELDEUTIG. Ab sofort gilt die folgende strikte Trennung; die
> Original-Texte/-Tabellen/-Direktiven unten bleiben unangetastet, sind aber im
> Sinne dieses Banners zu lesen:
>
> 1. **GATTUNG = ein INTERFACE für die Außenwelt (= ein Prüf-Dock):**
>    `SearchAlgorithm` / `Container` / `Graph`. (Doc 24 §8.8: „Prüf-Dock je Gattung —
>    für Search Algorithm oder Container oder Graphen"; §8.6 „ABI-Interface der API
>    der Gattung".) NUR dort, wo dieses Dokument „Gattung" im Sinne von
>    *Interface / Prüf-Dock / Außen-API* meint, ist der Begriff KORREKT.
>
> 2. **TIER-UNTERKLASSE = liegt UNTER dem Gattungs-Interface und verwendet einen
>    FESTEN Achsen-Satz.** HIER lebt die feste Achsen-Konfiguration. Alle Stellen
>    unten, die „Gattung" / `AnatomyGenus` für die Ebene mit dem festen Achsen-Satz
>    benutzen — insbesondere die **5 Klassen SearchAlgorithm/Set/Sequence/Adapter/View**
>    (Säugetier/Vogel/Reptil/Wirbelloses/Pflanze) und die std-Familien **„Gattung A–F"**
>    in §26 — bezeichnen in Wahrheit **Lebewesen-UNTERKLASSEN**, NICHT Gattungen.
>    Konkret: Set/Sequence/Adapter/View sind Lebewesen-Unterklassen UNTER dem
>    **Container**-Interface; die 17/19-Achsen-Komposition (std::map-ähnlich) ist die
>    **SearchAlgorithm-Lebewesen-Unterklasse** unter dem **SearchAlgorithm**-Interface.
>
> 3. **ACHSEN = Organe der Lebewesen-Unterklasse. KEINE Achse ist optional.** Die
>    Interfaces ALLER Achsen werden in JEDEM Lebewesen-Binary tatsächlich + uniform
>    getrieben. Ein nicht-pufferndes/nicht-prefetchendes Lebewesen wählt einen KONKRETEN
>    Durchreich-Algorithmus (NoBuffer/NoFlush/NonePrefetch/NoMigration/None), es wird
>    NICHT „eine Achse weggelassen". Wo unten „optionale Achse" / „Teilmenge der
>    Achsen" steht, ist das im Sinne von *Durchreich-Algorithmus* zu lesen (s. die
>    Schärfungs-Notiz an §28/§32).
>
> 4. **queuing q1/q2** sind **Pflicht-ACHSEN der SearchAlgorithm-Lebewesen-Unterklasse**
>    (kein Interface, keine Gattung) — vgl. §7 (dort bereits korrekt als „Organ"
>    geführt) und das parallele Code-Ziel AdHocComposition 17→19.
>
> **Lese-Regel:** Bei Widerspruch zwischen einer „Gattung"-Stelle unten und diesem
> Banner hat das 3-Ebenen-Modell (Doc 30 §8.0) Vorrang. Verbatim-User-Direktiven
> (§1, §10, §16, §25, §33, §41, §43, §53 …) bleiben wörtlich erhalten und werden NUR
> annotiert, nie umgeschrieben.

---

## §1 Kern-Metapher (User-Direktive verbatim 2026-05-26)

> "Bei Paarhufer-Mägen gibt es den Magen der Kuh, des Rehs, des Schafes, aber alle
> haben einen. Nun gehe ich davon aus, dass jeder Suchalgorithmus dieselben Organe
> (daher Achsen) haben muss, um zu funktionieren, auch wenn die jeweilige Organ-
> Ausprägung einem Anwendungsfall entspricht. Hier ist es also so, dass eine Achse
> einen speziellen Algorithmus für einen Anwendungsfall bereitstellt. Im Anschluss
> ist die Permutation der Achsen gegeneinander nichts anderes, als wenn wir
> genetische Experimente an den Lebewesen unternehmen und deren Organe testweise
> gegeneinander tauschen. Genauso tauschen wir die Algorithmen aller Achsen
> gegeneinander aus, um neue Gesamt-Suchalgorithmen zu erhalten, die unbekannte
> Eigenschaften besitzen."

### §1.1 Anti-Pattern (das was kritisiert wurde)

> "Ein Reh hat 4 Beine, eine Kuh hat vier Beine, ein Schaf hat vier Beine, also
> sind alle Pflanzenfresser und Paarhufer. Dabei hat jedes Lebewesen dieselben Organe,
> dieselbe Grund DNA in unterschiedlicher Ausprägung."

**Übertragen auf Cache-Engine:** Wenn wir ART, HOT, Wormhole, Masstree als
EINZELNE Wrappers in `axis_03a_search_algo` ablegen — dann sagen wir
"ART hat 4 Functions (insert/lookup/erase/clear), HOT hat 4 Functions,
Wormhole hat 4 Functions" — und folgern fälschlicherweise: alle sind
"Such-Algorithmen", also gehören in EINE Achse. Das ist genauso fehlerhaft
wie "alle haben vier Beine → alle sind Paarhufer". Die Achse beschreibt
nicht das "Lebewesen" (= ganzer Algorithmus), sondern ein einzelnes "Organ".

### §1.2 Bottom-Up-Permutation als genetisches Experiment

> "Genauso tauschen wir die Algorithmen aller Achsen gegeneinander aus, um neue
> Gesamt-Suchalgorithmen zu erhalten, die unbekannte Eigenschaften besitzen."

**Konsequenz:** Eine Permutation ist die kontrollierte Veränderung **eines
einzelnen Organs** bei gleichbleibender Lebewesen-Anatomie. Im Cache-Engine-Kontext:
- Achse X = ein konkretes Organ (z.B. "Node-Layout")
- Permutations-Element der Achse = eine Ausprägung des Organs (z.B. "Node256",
  "Patricia-comprimiert", "PrtArt-BPlus")
- Eine Permutations-Konfiguration = ein konkretes Lebewesen (= konkreter Such-Algorithmus)

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
fertige Lebewesen (z.B. "ART").

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
- Das Original-Linking erfolgt pro Achse (Organ), nicht pro Composition (Lebewesen)

---

## §4 Pflicht-Disziplinen für alle zukünftigen Topic+Achsen

### §4.1 Pflicht: Achse = Organ, nicht Lebewesen

**Vor Anlegen einer neuen Achse Pflicht-Frage:**
> "Ist das eine Sub-Aufgabe die JEDER Such-Algorithmus in irgendeiner Form
> ausführt (= Organ)? Oder ist das ein kompletter Algorithmus (= Lebewesen)?"

Wenn Lebewesen → falsche Achse → Composition-Template.
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
| **`axis_03a_search_algo`** (8 Wrappers, davon 5 OriginalXxx) | ❌ **REFACTORING-PFLICHT** | Lebewesen statt Organe — Refactoring per §6 |

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

**Permutation = genetisches Experiment am Lebewesen (= Cache-Engine).**

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
> Ausprägung der Merkmale jeder Achse/Organe (ähnlich Lebewesen-Metapher) zum finalen
> eindeutigen Komposit-Algorithmus zusammensetzt."

> "Methapher: Alle Säugetiere haben im Kern hauptsächlich dieselben Organe und
> Anatomie, aber alle Knochen, Organe, Bindegewebe haben unterschiedliche
> Ausprägungen."

> "Das finale Ziel der Diplomarbeit ist es, die Anatomie eines Suchalgorithmus
> zu finden und das schnellste 'Lebewesen' bzw. die schnellste Rekombination aller
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

// Eine NEUE Permutation = neues Lebewesen (z.B. ART-Node mit Wormhole-Hash-Lookup):
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
- Identifizierte schnellstes "Lebewesen" (optimale Komposit-Konfiguration) systematisch

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
- SuRF ist das einzige Lebewesen wo `filter` Composition-konstitutiv ist (SuRF **IST** ein Filter)
- Wormhole als einziges Lebewesen nutzt HashLookup statt LinearWalk fuer cache_traversal
- Viele Organe sind ueber alle 6 Lebewesen identisch (value_handle Inline, io_dispatch InMemory, migration None) → kleine echte Variation
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
   - §5 AllSixTiereRoundtripIndependently (insert/lookup/erase/clear pro Lebewesen)
   - §6 NonEmptyAxisCountMatchesArity (PermutationEngine min-1-Constraint)

**Pilot-Demonstration (6 Permutationen):**
```
search_algo:     {Array256, VectorU8U8, VectorU16U16}  (3 Werte)
cache_traversal: {LinearFanout, HashLookup}            (2 Werte)
15 weitere:      {Default}                              (1^15)
→ Cartesian:     3 × 2 × 1^15 = 6 distinkte Lebewesen
```

**Skalierung-Pfad (R5/V42):**
Bei Vollausbau aller 15 Topics mit ihren Stufe-A-Wrappers:
- search_algo 8, cache_traversal 2, mapping 2, allocator 24+, isa 4, weitere 1-4 → 10⁴-10⁵ Lebewesen
- Pro Lebewesen wird `for_each_composition_type` zu einem .so/.dll-Build (R5)
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

> **Schärfung 2026-06-03 (Doc 30 §8.0):** Die Bezeichnung „Gattung A–F" in diesem
> Abschnitt ist im Sinne des verbindlichen 3-Ebenen-Modells eine **Lebewesen-UNTERKLASSEN**-
> Aufzählung, NICHT eine Gattungs-Aufzählung. Diese std-Container-Familien (Sequence /
> Ordered Associative / Unordered Associative / Adapter / Flat Associative / View) sind
> Lebewesen-Unterklassen, die zum Großteil UNTER dem **Container**-Interface (= Gattung)
> liegen; die K→V-Such-Familien (Ordered/Unordered/Flat Associative, std::map-ähnlich)
> bilden die **SearchAlgorithm-Lebewesen-Unterklasse** unter dem **SearchAlgorithm**-Interface.
> „Gattung" im korrekten Sinn = das Außen-Interface Search/Container/Graph (Prüf-Dock).
> Original-Tabellen bleiben unverändert; nur die Ebenen-Benennung wird geschärft.

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

> **Schärfung 2026-06-03 (Doc 30 §8.0):** Die hier eingeführten 5 Werte des Enums
> `AnatomyGenus` (SearchAlgorithm/Sequence/Set/Adapter/View) sowie die Lebewesen-Metapher-
> Tabelle §27.2 (Säugetier/Vogel/Reptil/Wirbelloses/Pflanze) bezeichnen die Ebene mit
> dem **festen Achsen-Satz** = **Lebewesen-Unterklasse**, NICHT die Gattung. Im verbindlichen
> 3-Ebenen-Modell ist **Gattung = das Außen-Interface (Prüf-Dock) Search/Container/Graph**;
> Set/Sequence/Adapter/View sind Lebewesen-Unterklassen unter dem **Container**-Interface,
> SearchAlgorithm ist die Lebewesen-Unterklasse unter dem **SearchAlgorithm**-Interface.
> Der Code-Identifier `AnatomyGenus` und seine Werte bleiben unverändert (technischer
> Bestands-Bezeichner; Umbenennung wäre ein separater Code-Refactor, vgl. §41/§43
> Cleanup-Sprint) — gemeint ist jedoch durchgehend die Lebewesen-Unterklassen-Ebene.

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

### §27.2 Lebewesen-Metapher-Mapping

| Lebewesen-Klasse | Anatomie-Gattung | std::-Container Beispiele | Stoffwechsel |
|---|---|---|---|
| **Saeugetier** | `SearchAlgorithm` | std::map, std::unordered_map, std::flat_map | Vollstaendige Anatomie mit allen 17 Achsen |
| **Vogel** | `Set` | std::set, std::unordered_set | Reduzierte Anatomie (K-only, kein V-Suchorgan) |
| **Reptil** | `Sequence` | std::vector, std::list, std::deque | Lineare Anatomie (V-only, kein K-Suchorgan) |
| **Wirbelloses** | `Adapter` | std::stack, std::queue, std::priority_queue | Decorator ueber anderem Lebewesen (Inner-Container) |
| **Pflanze** | `View` | std::span, std::mdspan | Sessil + non-owning |

---

## §28 Achsen-Verteilung pro Gattung

> **Schärfung 2026-06-03 (Doc 30 §8.0):** ZWEI Korrekturen zu diesem Abschnitt.
> (1) **„pro Gattung" = pro Lebewesen-Unterklasse** (feste Achsen-Konfiguration liegt auf
> der Lebewesen-Unterklassen-Ebene, nicht auf der Gattungs-/Interface-Ebene).
> (2) Die Formulierung **„Teilmenge der 17 Achsen" bzw. die „—"-Markierungen in der
> Tabelle sind im strengen Modell NICHT als „Achse weggelassen" zu verstehen.** KEINE
> Achse ist optional: jede Lebewesen-Unterklasse treibt die Interfaces ALLER für sie
> definierten Achsen uniform; wo unten „—" steht, wählt das Lebewesen in Wahrheit einen
> KONKRETEN **Durchreich-Algorithmus** (None/NoBuffer/NoFlush/NonePrefetch/NoMigration,
> bei View z.B. non-owning/immutable als konkrete Ausprägung). Die Tabelle beschreibt
> also, welche Achse je Lebewesen-Unterklasse einen aktiven vs. einen Durchreich-Algorithmus
> erhält — nicht, ob eine Achse existiert. (Für die aktuell EINZIG gebaute
> SearchAlgorithm-Lebewesen-Unterklasse sind dies alle 17, im Code-Ziel 19 inkl. queuing
> q1/q2.) Original-Tabelle bleibt unverändert.

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

> **Schärfung 2026-06-03 (Doc 30 §8.0):** „pro Gattung" / „pro Anatomie-Gattung" =
> **pro Lebewesen-Unterklasse** (die feste Achsen-Konfiguration und damit der
> spezialisierte Permutations-Raum hängen an der Lebewesen-Unterklassen-Ebene). Die
> verbatim-User-Direktive unten bleibt wörtlich; sie meint mit „Anatomie-Gattung"
> die Lebewesen-Unterklasse. Gattung im strengen Sinn = das Außen-Interface
> Search/Container/Graph (Prüf-Dock). Die Code-Marker `genus = AnatomyGenus::...`
> in §29.1–§29.3 sind technische Bestands-Bezeichner und bezeichnen die
> Lebewesen-Unterklasse.

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
| **R5.C.0** | AnatomyBase + AnatomyConcept + AnatomyGenus enum + Lebewesen-Metapher-Doku | Doku 14 §27-§29 done |
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
- NEU `[[anatomie-gattungen]]` — 5 Gattungen + Lebewesen-Metapher + AnatomyBase

---

**Ende Teil 4 §25-§31 (Stand 2026-05-26 sehr spaet — User-Direktive Anatomie-Gattungen +
AnatomyBase + Gattungs-spezialisierte PermutationEngines).**

---

## §32 Gattungs-Constraint fuer Pruefling-Merge (User-Direktive 2026-05-26 sehr spaet)

> **Schärfung 2026-06-03 (Doc 30 §8.0):** Die Kern-Invariante dieses Abschnitts —
> *nur Algorithmen mit dem EXAKT selben Achsen-Satz dürfen gekreuzt werden* — bleibt
> uneingeschränkt gültig und richtig. Im 3-Ebenen-Modell ist das aber ein
> **Lebewesen-UNTERKLASSEN**-Constraint, nicht ein Gattungs-Constraint: gekreuzt werden darf
> nur INNERHALB derselben Lebewesen-Unterklasse (gleicher fester Achsen-Satz). Überall unten
> ist „Gattung"/`AnatomyGenus`/„Cross-Genus" daher als **Lebewesen-Unterklasse**/
> „Cross-Lebewesen-Unterklasse" zu lesen. Gattung im strengen Sinn = das Außen-Interface
> Search/Container/Graph. — Zusätzlich (§32.2-Tabelle): die Spalte „Pflicht-Achsen-Set
> (Teilmenge der 17)" und Formulierungen wie „kein search_algo/…" bedeuten NICHT „Achse
> weggelassen"; jede definierte Achse wird getrieben, fehlende Funktion = konkreter
> **Durchreich-Algorithmus** (None/delegated als reale Ausprägung). Original-Direktive
> + Tabelle bleiben unverändert.

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

Mess-Reihen koennen Mammal-Lebewesen vs Reptile-Lebewesen **vergleichen** (Performance-Studie
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

> **Schärfung 2026-06-03 (Doc 30 §8.0):** In der Taxonomie §34.1 ist die Zeile
> „5 Gattungen: SearchAlgorithm/Set/Sequence/Adapter/View" als **5 Lebewesen-UNTERKLASSEN**
> zu lesen (Ebene mit dem festen Achsen-Satz). Im verbindlichen 3-Ebenen-Modell ist
> **Gattung = das Außen-Interface (Prüf-Dock) Search/Container/Graph**; Set/Sequence/
> Adapter/View liegen als Lebewesen-Unterklassen unter dem **Container**-Interface,
> SearchAlgorithm ist die Lebewesen-Unterklasse unter dem **SearchAlgorithm**-Interface.
> Die Wurzel-Hierarchie ExecutionEngine → AnatomyBase → {Lebewesen-Unterklassen} und der
> Lebewesen-vs-Viren-Schnitt bleiben unverändert korrekt — nur die Wortwahl
> „Gattung" für die Lebewesen-Unterklassen-Ebene wird geschärft. Original-Diagramm bleibt.

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
| R7 (V42) | F15-Auswertung schnellstes Lebewesen + Virus-Vergleich | `Diplomarbeit/06_auswertung/` |

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
| **Doku-Kommentare im Code** | beides erlaubt (Doku-Text) | "Saeugetier-Anatomie-Metapher", "Mammal-Gattung in Lebewesen-Metapher" |
| **Architektur-Doku (.md)** | beides erlaubt | siehe Teil 1-5 oben |

**Begruendung:** Code-Identifier sind API-Vertrag → muessen aus dem Anwendungs-
domain (Search-Algorithm) lesbar sein. Kommentare/Doku-Text erlauben die
Lebewesen-Metapher als didaktische Hilfe.

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

User-Direktive: Metaphern (Lebewesen/Saeugetier/Mammal/Bird/Reptile/Invertebrate/
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

---

# Teil 9 — Anatomy Module ABI v1 (R5.D Pilot)

## §44 R5.D — Permutations-Binary ABI + COMDARE_DEFINE_ANATOMY_MODULE Macro

### §44.1 Pilot-Scope (atomare Lieferung)

R5.D ist umfangreich (Codegen + ModuleLoader + .so/.dll-Build). Pilot R5.D liefert
den **minimalen ABI-Layer** + **Convenience-Macro** fuer Permutations-Binary
Authoring. Konkretes Codegen + ModuleLoader-Anbindung folgen in R5.D.2 / R5.E.

### §44.2 Architektur-Entscheidung: minimaler ABI statt PermutationModule-v1

Existing `cache_engine/abi/module_abi_v1.hpp` (REV 7.6) definiert
`comdare_permutation_module_v1` — ein POD-Struct mit 9+ Funktion-Pointern, dass
in jedem Permutations-Binary populiert wird. Das ist fuer die alte Pre-Anatomy-
Architektur.

R5.D nutzt die neue Anatomy-Schicht (`IAnatomyBase` Virtual-Interface) und
reduziert die ABI auf **4 extern "C" Symbole** pro .so/.dll:

| Symbol | Signatur | Zweck |
|---|---|---|
| `comdare_anatomy_abi_version` | `() -> uint64_t` | Major<<32 \| Minor |
| `comdare_anatomy_abi_magic` | `() -> uint64_t` | Compat-Sanity |
| `comdare_create_anatomy` | `() -> IAnatomyBase*` | Factory (heap-alloc) |
| `comdare_destroy_anatomy` | `(IAnatomyBase*) -> void` | RAII-Cleanup |

**Vorteile:**
1. Anatomy-API-Erweiterungen brechen ABI NICHT (neue Virtual-Methoden werden in
   IAnatomyBase ergaenzt, .so/.dll bleibt kompatibel solange Major-Version stabil)
2. Type-Safety: kein void*-Cast erforderlich
3. C++ RAII statt manueller Pointer-Tracking

### §44.3 Lieferung R5.D Pilot

| Datei | Inhalt |
|---|---|
| `libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1.hpp` (NEU) | ABI-Version-Macros, 4 extern "C" Forward-Declarations, COMDARE_DEFINE_ANATOMY_MODULE Macro, AnatomyAbiVersion Helper-Klasse (Pack/Unpack/Compat-Check) |
| `tests/unit/test_v41_anatomy_module_abi.cpp` (NEU) | 10 Tests in 3 Suites |
| `tests/unit/CMakeLists.txt` | Test-Target registriert |

### §44.4 COMDARE_DEFINE_ANATOMY_MODULE Verwendung

Generiertes Permutations-Binary nutzt das Macro:

```cpp
// generated/perm_<hash>.cpp
#define COMDARE_ANATOMY_MODULE_BUILD 1
#include <cache_engine/abi/anatomy_module_abi_v1.hpp>
#include <compositions/art_reference.hpp>

// Eine Zeile expandiert zu 4 extern "C" Symbolen:
COMDARE_DEFINE_ANATOMY_MODULE(::comdare::cache_engine::compositions::ArtComposition)
```

R5.D.2 Codegen wird diese Datei pro AdHocComposition aus dem PermutationEngine-
Cartesian-Product generieren (configure_file mit Composition-Type-String).

### §44.5 AnatomyAbiVersion Compatibility-Regeln

```cpp
struct AnatomyAbiVersion { uint32_t major; uint32_t minor; };

// Host-Compat: Major identisch, Modul-Minor <= Host-Minor
// (Module darf alt sein, aber nicht aus der Zukunft)
```

| Host | Modul | Compat? | Grund |
|---|---|---|---|
| 1.5 | 1.5 | ✅ | gleich |
| 1.5 | 1.3 | ✅ | alt OK |
| 1.5 | 1.6 | ❌ | Modul aus Zukunft (Host kennt neue Features nicht) |
| 1.5 | 2.0 | ❌ | Major-Mismatch |

### §44.6 Tests-Snapshot R5.D (10 Tests, 3 Test-Suites)

| § | Suite | Tests |
|---|---|---|
| §1 | R5D_AnatomyAbi (Version/Magic Compile-Time) | 2 |
| §2-§3 | R5D_AnatomyAbiVersion (pack/unpack + Compat-Rules) | 2 |
| §4-§8 | R5D_AnatomyFactory (Symbole + Lifecycle + Multi-Create) | 6 |

Anatomy-Tests gesamt nach R5.D: **117 grün** (9 Test-Files, +10 vs R5.C.A4).

### §44.7 NEXT R5.D.2 + R5.E

| Sprint | Was |
|---|---|
| R5.D.2 | Codegen-Template + CMake-Codegen-Funktion: pro AdHocComposition `.cpp` generieren + `add_library(perm_<hash> SHARED ...)` |
| R5.E | ModuleLoader::load_anatomy(dll_path) → IAnatomyBase* (dlopen/LoadLibrary + ABI-Version-Check) |

---

**Ende Teil 9 §44 (Stand 2026-05-27 mittag — R5.D Anatomy Module ABI v1 Pilot mit
COMDARE_DEFINE_ANATOMY_MODULE Macro + 10 Tests).**

---

# Teil 10 — Codegen-Template + CMake-Function (R5.D.2)

## §45 R5.D.2 — comdare_codegen_anatomy_module() generiert Permutations-Lib

### §45.1 Lieferung

| Datei | Inhalt |
|---|---|
| `libs/cache_engine/builder/codegen/templates/anatomy_permutation_module.cpp.in` (NEU) | configure_file-Template: erzeugt `.cpp` mit `COMDARE_DEFINE_ANATOMY_MODULE(...)` Expansion |
| `cmake/anatomy_codegen.cmake` (NEU) | `comdare_codegen_anatomy_module()` Function: configure_file + add_library SHARED\|STATIC |
| `tests/unit/CMakeLists.txt` (Pilot) | Ruft Function fuer HotComposition als STATIC-Lib `anatomy_codegen_pilot_hot` |
| `tests/unit/test_v41_anatomy_codegen.cpp` (NEU) | 5 Smoke-Tests gegen Pilot-Lib |
| `libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1.hpp` (erweitert) | + `COMDARE_ANATOMY_ABI_STATIC` Build-Mode, + Includes fuer SearchAlgorithmAnatomy/AbiAdapter (Macro-Resolve-Pflicht) |

### §45.2 CMake-Function Signatur

```cmake
comdare_codegen_anatomy_module(
    TARGET_NAME         <name>                                # z.B. anatomy_codegen_pilot_hot
    COMPOSITION_TYPE    <fully-qualified C++ type>
    COMPOSITION_HEADER  <include-path relative to libs/cache_engine/>
    OUTPUT_DIR          <where to place generated .cpp>
    [LIBRARY_TYPE       SHARED|STATIC]                        # default SHARED
    [FINGERPRINT        <hex>]                                # default = SHA256-Prefix(COMPOSITION_TYPE)
)

# Exports:
#   ${TARGET_NAME}_GENERATED_CPP  — Pfad der erzeugten .cpp
#   ${TARGET_NAME}_FINGERPRINT    — verwendeter Fingerprint
```

### §45.3 Drei ABI-Build-Modi (Cross-Plattform)

| Mode | Compile-Define | Windows-Markierung | Zweck |
|---|---|---|---|
| **STATIC** | `COMDARE_ANATOMY_ABI_STATIC` (PUBLIC) | keine `__declspec` | In-Process Tests, statische Verlinkung |
| **SHARED Author** | `COMDARE_ANATOMY_MODULE_BUILD` (PRIVATE) | `__declspec(dllexport)` | .dll-Author-Side fuer R5.E ModuleLoader |
| **SHARED Consumer** | (default, kein Define) | `__declspec(dllimport)` | Header-Consumer der .dll laedt |

`PUBLIC` bei STATIC propagiert das Define zum Consumer (Test-Exe), `PRIVATE` bei
SHARED bleibt im Author-Object.

### §45.4 Codegen-Template (anatomy_permutation_module.cpp.in)

```cpp
// Auto-generated by comdare_codegen_anatomy_module() — DO NOT EDIT
// Composition Type    : @COMDARE_COMPOSITION_TYPE@
// Composition Header  : @COMDARE_COMPOSITION_HEADER@
// Fingerprint         : @COMDARE_COMPOSITION_FINGERPRINT@
// Generated Timestamp : @COMDARE_CODEGEN_TIMESTAMP@

#define COMDARE_ANATOMY_MODULE_BUILD 1
#include <cache_engine/abi/anatomy_module_abi_v1.hpp>
#include "@COMDARE_COMPOSITION_HEADER@"

COMDARE_DEFINE_ANATOMY_MODULE(@COMDARE_COMPOSITION_TYPE@)
```

### §45.5 Tests-Snapshot R5.D.2 (5 Tests gegen anatomy_codegen_pilot_hot)

| § | Test | Was wird bewiesen |
|---|---|---|
| §1 | AbiVersionFunctionExported | Pilot-Lib exportiert comdare_anatomy_abi_version |
| §2 | AbiMagicFunctionExported | Pilot-Lib exportiert comdare_anatomy_abi_magic |
| §3 | CreateAnatomyReturnsHotComposition | Factory liefert HotComposition (NICHT Art!) — beweist Codegen-Template-Substitution |
| §4 | LifecycleRoundtripViaCodegenFactory | warm_up→run→reset→shutdown via Factory-Pointer |
| §5 | ModuleVersionIsCompatibleWithHost | Modul-Version compat zu Host-Version |

Anatomy-Tests gesamt nach R5.D.2: **122 grün** (10 Test-Files, +5 vs R5.D Pilot).

### §45.6 Kollision-frei zu test_v41_anatomy_module_abi.cpp

`test_v41_anatomy_module_abi` expandiert `COMDARE_DEFINE_ANATOMY_MODULE` mit
ArtComposition. R5.D.2-Pilot nutzt HotComposition. Die 4 extern "C" Symbole
sind pro Test-Exe-Linkage isoliert (separate Test-Targets) — keine Symbol-
Konflikte.

### §45.7 NEXT R5.E + Pilot-Skalierung

| Sprint | Was |
|---|---|
| R5.E | ModuleLoader::load_anatomy(dll_path) → IAnatomyBase* mit dlopen/LoadLibrary + Version-Check |
| R5.D.3 (optional) | Iteration ueber SearchAlgorithmPermutationEngine: pro Permutation `comdare_codegen_anatomy_module()` aufrufen → 6 Pilot-Libs aus PilotEngine |
| R5.D.4 (optional) | CacheEngineBuilder-CLI: parst Composition-List + ruft Codegen-Funktion |

---

**Ende Teil 10 §45 (Stand 2026-05-27 mittag — R5.D.2 anatomy_codegen Function mit
configure_file-Template + STATIC-Pilot + 5 Tests).**

---

# Teil 11 — AnatomyModuleLoader dlopen/LoadLibrary (R5.E)

## §46 R5.E — AnatomyModuleLoader: SHARED-DLL Runtime-Loading

### §46.1 Lieferung

| Datei | Inhalt |
|---|---|
| `libs/cache_engine/builder/anatomy_module_loader/anatomy_module_loader.hpp` (NEU) | `AnatomyModuleHandle` RAII + `AnatomyModuleLoader` Klasse |
| `libs/cache_engine/builder/anatomy_module_loader/anatomy_module_loader.cpp` (NEU) | Plattform-Code (dlopen/LoadLibrary via `#if defined(_WIN32)`) |
| `libs/cache_engine/builder/anatomy_module_loader/CMakeLists.txt` (NEU) | `comdare::anatomy_module_loader` STATIC-Lib + Boost::mp11 + ${CMAKE_DL_LIBS} |
| `libs/cache_engine/builder/CMakeLists.txt` | `add_subdirectory(anatomy_module_loader)` ergaenzt |
| `tests/unit/CMakeLists.txt` | SHARED-Pilot via comdare_codegen_anatomy_module(LIBRARY_TYPE SHARED) fuer WormholeComposition + Test-Target |
| `tests/unit/test_v41_anatomy_module_loader.cpp` (NEU) | 11 Tests in 1 Suite |

### §46.2 AnatomyModuleHandle RAII-Lifecycle

```cpp
class AnatomyModuleHandle {
public:
    AnatomyModuleHandle() = default;  // leere/invalide Handle
    // Move-only (Copy = delete)

    [[nodiscard]] bool valid() const noexcept;
    [[nodiscard]] IAnatomyBase* anatomy() noexcept;
    [[nodiscard]] AnatomyAbiVersion module_version() const noexcept;

    void unload() noexcept;
    ~AnatomyModuleHandle() { unload(); }
};
```

**Cleanup-Reihenfolge in `unload()` (KRITISCH):**
1. `comdare_destroy_anatomy(ptr)` ZUERST — die Instanz muss innerhalb der gleichen
   .so/.dll-Heap-Allokation freigegeben werden (sonst Heap-Mismatch)
2. `dlclose()` / `FreeLibrary()` DANACH — Modul entladen

### §46.3 AnatomyModuleLoader::load() Validierungs-Schritte

```cpp
static int load(std::filesystem::path const& dll_path, AnatomyModuleHandle& out);
```

| Schritt | Check | Failure-Status |
|---|---|---|
| 1 | std::filesystem::exists(path) | `status_file_not_found` |
| 2 | LoadLibrary/dlopen erfolgreich | `status_load_failed` |
| 3 | 4 Pflicht-Symbole resolvable | `status_symbol_not_found` |
| 4 | pfn_magic() == COMDARE_ANATOMY_ABI_MAGIC | `status_magic_mismatch` |
| 5 | module.major == host.major | `status_abi_major_mismatch` |
| 6 | module.minor <= host.minor | `status_abi_minor_too_new` |
| 7 | pfn_create() != nullptr | `status_factory_returned_null` |
| ✅ | alles OK | `status_ok` |

Reihenfolge ist bewusst: Magic-Check vor Version-Check (defensiv: falls fremde
.dll mit zufaelligem Version-Symbol geladen wird, faengt Magic den fehlerhaften
Cast ab).

### §46.4 End-to-End-Flow (R5.D + R5.D.2 + R5.E zusammen)

```
SearchAlgorithmPermutationEngine
  └─ comdare_codegen_anatomy_module(LIBRARY_TYPE SHARED)
       ├─ Template: anatomy_permutation_module.cpp.in
       │    ├─ #include <cache_engine/abi/anatomy_module_abi_v1.hpp>
       │    ├─ #include "@COMDARE_COMPOSITION_HEADER@"
       │    └─ COMDARE_DEFINE_ANATOMY_MODULE(@COMDARE_COMPOSITION_TYPE@)
       │       expandiert zu 4 extern "C" Symbolen
       └─ add_library(comdare_anatomy_perm_<hash> SHARED ...)
            → comdare_anatomy_perm_<hash>.dll
                 ↓
AnatomyModuleLoader::load(path)
  ├─ LoadLibrary (Win) / dlopen (POSIX)
  ├─ 4× GetProcAddress / dlsym
  ├─ Magic + Major + Minor Validation
  └─ comdare_create_anatomy() → IAnatomyBase*
       ↓
AnatomyModuleHandle (RAII)
  ├─ anatomy()->warm_up()
  ├─ anatomy()->run()
  ├─ anatomy()->reset()
  └─ anatomy()->shutdown()
       ↓ (Destruktor)
  comdare_destroy_anatomy(ptr)  +  FreeLibrary/dlclose
```

### §46.5 Tests-Snapshot R5.E (11 Tests, 1 Suite)

| § | Test | Beweis |
|---|---|---|
| §1 | PlatformSuffixIsCorrect | `.dll` / `.so` / `.dylib` per OS |
| §2 | PilotDllExists | SHARED-Codegen produziert echte .dll |
| §3 | LoadNonExistentReturnsNotFound | errno-Style-Fehler-Mapping |
| §4 | LoadPilotDllSucceeds | End-to-End OK, Handle valid() |
| §5 | LoadedAnatomyIsWormholeComposition | DLL-Inhalt = generierte Composition |
| §6 | LifecycleRoundtripViaLoadedHandle | warm_up/run/reset/shutdown via Virtual-Call ueber DLL-Grenze |
| §7 | ModuleVersionMatchesHost | host_compatible_with(module_version) |
| §8 | MoveConstructTransfersOwnership | Move-Only-Semantik |
| §9 | MoveAssignReleasesPreviousAndTakesNew | Move-Assign-Cleanup |
| §10 | MultipleLoadsProduceDistinctInstances | 2× Load → 2× distinkte IAnatomyBase-Heap-Pointer |
| §11 | ExplicitUnloadInvalidatesHandle | manuelles unload() + Idempotenz |

Anatomy-Tests gesamt nach R5.E: **133 grün** (11 Test-Files, +11 vs R5.D.2).

### §46.6 Architektur-Beweis R5.D-R5.E Pipeline ist End-to-End funktional

R5.D ABI + R5.D.2 Codegen + R5.E Loader sind in dieser Reihenfolge gestapelt
und arbeiten zusammen. Die Pilot-Test-Pipeline beweist:

1. CMake `comdare_codegen_anatomy_module` generiert kompilierbares C++ aus
   Template + Composition-Type
2. SHARED-Build mit `dllexport` exportiert die 4 ABI-Symbole als public
3. `LoadLibrary` findet die DLL, `GetProcAddress` resolved alle 4 Symbole
4. Magic + Version-Check verifizieren ABI-Compat
5. Factory liefert `IAnatomyBase*` ueber DLL-Grenze (Virtual-Interface bleibt
   stabil dank ABI-Major-Match)
6. Virtual-Calls (`warm_up/run/reset/shutdown/composition_name`) funktionieren
   ueber Heap-Grenze (DLL-Code-Section + Host-vtable)
7. RAII-Cleanup ohne Heap-Mismatch

### §46.7 NEXT (R6+ V42)

R5.D-R5.E Pipeline ist komplett. Naechste Sprints:

| Sprint | Was |
|---|---|
| R5.D.3 (optional) | Multi-Permutation-Codegen: SearchAlgorithmPermutationEngine iteriert + ruft Function pro Permutation → N Pilot-DLLs aus Cartesian |
| R5.F | CacheEngineBuilder-CLI End-to-End: parst Composition-List + Codegen-Aufruf + Loader-Aufruf + Mess-Loop |
| R6 (V42) | Workload-Driver pro geladenem Modul (YCSB-Insert/Lookup-Sequenz) |
| R7 (V42) | F15-Auswertung: tausende Permutationen messen + schnellste identifizieren |

---

**Ende Teil 11 §46 (Stand 2026-05-27 nachmittag — R5.E AnatomyModuleLoader End-to-End
SHARED-DLL Runtime-Loading + 11 Tests).**

---

# Teil 12 — Multi-Permutation-Codegen + load_all (R5.D.3)

## §47 R5.D.3 — comdare_codegen_anatomy_module_list + load_all End-to-End

### §47.1 Architektur-Entscheidung: deklarative CMake-Liste vs C++-Iteration

`SearchAlgorithmPermutationEngine` ist C++23 Compile-Time-Code. CMake-Codegen
laeuft zur Build-System-Time. Beide Welten direkt zu verbinden braucht ein
Pre-Build-Codegen-Tool (R5.F).

**R5.D.3 wahl als pragmatischen Zwischenschritt:** deklarative CMake-Liste von
Composition-Types, ueber die `comdare_codegen_anatomy_module()` in einer Schleife
aufgerufen wird. Voll-Integration mit PermutationEngine kommt in R5.F.

### §47.2 Lieferung

| Datei | Inhalt |
|---|---|
| `cmake/anatomy_codegen.cmake` (erweitert) | `comdare_codegen_anatomy_module_list()` Function: iteriert ueber `COMPOSITIONS` Liste (Format "type\|header"), ruft Single-Codegen pro Eintrag, sammelt Targets, setzt gemeinsames RUNTIME_OUTPUT_DIRECTORY |
| `tests/unit/CMakeLists.txt` (erweitert) | Pilot mit 3 Compositions (Art/Start/Surf) als SHARED → 3 DLLs in eigenem Output-Verzeichnis |
| `tests/unit/test_v41_anatomy_multi_codegen.cpp` (NEU) | 7 Tests gegen Multi-Pilot |

### §47.3 List-Function Signatur

```cmake
comdare_codegen_anatomy_module_list(
    PILOT_PREFIX  <name>                                 # z.B. "anatomy_multi_pilot"
    OUTPUT_DIR    <dir>                                  # alle DLLs landen hier
    LIBRARY_TYPE  SHARED|STATIC                          # default SHARED
    COMPOSITIONS
        "<fully-qualified type>|<include-path>"          # Pipe-getrennt (Semikolon-Konflikt)
        "<fully-qualified type>|<include-path>"
        ...
    [TARGETS_OUT  <var-name>]                            # erzeugte Target-Namen-Liste
)
```

**Pipe-Separator-Begruendung:** CMake nutzt Semikolon als List-Separator.
Composition-Type-Strings koennten Semikolons enthalten (sie tun es nicht in unserem
Kontext, aber als robustes Pattern). Pipe (`|`) ist ein sicherer alternativer
Separator innerhalb eines Eintrags.

### §47.4 Auto-Generierte Target-Namen + Fingerprints

Pro Listen-Eintrag wird ein Target generiert mit:
- **TARGET_NAME:** `<PILOT_PREFIX>_<index>` (z.B. `anatomy_multi_pilot_0`)
- **FINGERPRINT:** `<PILOT_PREFIX>_<index>` (stabile DLL-Namen statt SHA256-Default)
- **DLL-Name:** `comdare_anatomy_perm_<fingerprint>.dll` — passt zum
  AnatomyModuleLoader::load_all Pattern (`comdare_anatomy_perm_*`)

Lesbare DLL-Namen statt SHA256-Hashes erlauben Debug-Diagnose im Output-Dir.

### §47.5 RUNTIME_OUTPUT_DIRECTORY-Override

Standard ist `CMAKE_BINARY_DIR/tests/unit/Release/` (je nach Generator).
R5.D.3 setzt explicit `RUNTIME_OUTPUT_DIRECTORY` + `LIBRARY_OUTPUT_DIRECTORY`
auf ARG_OUTPUT_DIR damit alle DLLs gemeinsam im Pilot-Verzeichnis landen —
sonst kann `load_all(dir)` sie nicht finden.

Pflicht-Property-Set inklusive `_RELEASE`/`_DEBUG`/`_RELWITHDEBINFO` Suffixe
(Visual Studio multi-config Generator).

### §47.6 Pilot-Verifikation (3 Compositions)

```
generated/anatomy_modules_multi/
├── anatomy_perm_anatomy_multi_pilot_0.cpp        # ArtComposition
├── anatomy_perm_anatomy_multi_pilot_1.cpp        # StartComposition
├── anatomy_perm_anatomy_multi_pilot_2.cpp        # SurfComposition
├── comdare_anatomy_perm_anatomy_multi_pilot_0.dll
├── comdare_anatomy_perm_anatomy_multi_pilot_1.dll
└── comdare_anatomy_perm_anatomy_multi_pilot_2.dll
```

`AnatomyModuleLoader::load_all(generated/anatomy_modules_multi)` laedt alle
3 DLLs (sortiert nach Dateiname) und liefert 3 `AnatomyModuleHandle`-Instanzen.

### §47.7 Tests-Snapshot R5.D.3 (7 Tests, 1 Suite)

| § | Test | Beweis |
|---|---|---|
| §1 | PilotDirectoryExists | Multi-Codegen produziert Verzeichnis |
| §2 | PilotDirectoryContainsExpectedDlls | 3 DLLs mit comdare_anatomy_perm_-Praefix |
| §3 | LoadAllReturnsThreeHandles | load_all erfolgreich + alle valid() |
| §4 | LoadAllProducesCorrectCompositionSet | Set{Art, Start, Surf} aus geladenen Anatomien |
| §5 | AllHandlesHaveSearchAlgorithmGenus | jeder Handle: genus + organ_count + engine_kind |
| §6 | LifecyclePerHandleIsIndependent | warm_up/run/shutdown pro Handle separat |
| §7 | PolymorphicMeasurementLoopOverAllHandles | R5.F-Vorbereitung: pro Permutation Mess-Iteration |

Anatomy-Tests gesamt nach R5.D.3: **140 grün** (12 Test-Files, +7 vs R5.E).

### §47.8 NEXT R5.F (CacheEngineBuilder-CLI End-to-End)

| Sprint | Was |
|---|---|
| R5.F | C++-Tool das SearchAlgorithmPermutationEngine instantiiert + Composition-Type-Liste fuer CMake generiert + CMake-Aufruf orchestriert |
| R6 (V42) | Workload-Driver pro geladenem Modul (YCSB-Sequenz) |
| R7 (V42) | F15-Auswertung tausende Permutationen |

---

**Ende Teil 12 §47 (Stand 2026-05-27 nachmittag — R5.D.3 Multi-Permutation-Codegen
mit comdare_codegen_anatomy_module_list + load_all End-to-End + 7 Tests).**

---

# Teil 13 — anatomy_codegen_tool CLI (R5.F)

## §48 R5.F — C++-Tool generiert CMake-Composition-Snippet

### §48.1 Pilot-Strategie: hardcoded Tabelle statt PermutationEngine-Iteration

`SearchAlgorithmPermutationEngine::for_each_composition_type` iteriert Compile-
Time ueber Composition-Types (`AdHocComposition<...>`-Instanzen). Diese Types
haben aktuell aber kein `cpp_type_name`/`header_path`-Trait — der Cartesian-
Punkt ist nur als C++-Type erreichbar, nicht als Strings fuer CMake-Codegen.

**R5.F Pilot loest das pragmatisch** mit einer hardcoded `CompositionDescriptor`-
Tabelle der 11 known Reference-Compositions (6 CE-Reimpl + 5 PaperBinding).
Voll-Integration mit PermutationEngine kommt in R5.G (Trait-Erweiterung +
Codegen-Tool das `for_each_composition_type` aufruft + Type-Name-Reflektion).

### §48.2 Lieferung

| Datei | Inhalt |
|---|---|
| `libs/cache_engine/builder/anatomy_codegen_tool/{hpp,cpp,CMakeLists.txt}` (NEU) | `comdare::anatomy_codegen_tool` STATIC-Lib mit Tabelle + select/find/write APIs |
| `apps/anatomy_codegen_tool/main.cpp` + `CMakeLists.txt` (NEU) | CLI-Executable `comdare-anatomy-codegen-tool` |
| `tests/unit/test_v41_anatomy_codegen_tool.cpp` (NEU) | 14 Library-Tests |
| `apps/CMakeLists.txt` (erweitert) | `add_subdirectory(anatomy_codegen_tool)` |

### §48.3 CLI-API

```bash
comdare-anatomy-codegen-tool [options]

Options:
  --output FILE        Output CMake-snippet file (required)
  --names LIST         Comma-separated short-names (default: alle 11)
  --library-type T     SHARED | STATIC (default: SHARED)
  --list               Print known compositions and exit
  --help               Show this help and exit
```

11 verfuegbare short-names: `art`, `hot`, `wormhole`, `surf`, `masstree`,
`start`, `art_pb`, `hot_pb`, `start_pb`, `wormhole_pb`, `surf_pb`.

### §48.4 Library-API (zur Test-Linkung)

```cpp
namespace comdare::cache_engine::builder::codegen_tool {

struct CompositionDescriptor {
    std::string_view short_name;       // "art"
    std::string_view cpp_type_name;    // "::comdare::cache_engine::compositions::ArtComposition"
    std::string_view header_include;   // "compositions/art_reference.hpp"
};

std::span<CompositionDescriptor const>        known_compositions() noexcept;
CompositionDescriptor const*                  find_composition(std::string_view) noexcept;
std::vector<CompositionDescriptor const*>     select_compositions(std::string_view csv,
                                                                   std::vector<std::string>* unknown_out);

enum class LibraryType { Shared, Static };
LibraryType const*                            parse_library_type(std::string_view) noexcept;
bool                                          write_cmake_snippet(path, selected, lib_type);

}
```

### §48.5 Generierter CMake-Snippet (Beispiel)

```cmake
# Auto-generated by comdare-anatomy-codegen-tool (V41.F.6.1.R5.F) — DO NOT EDIT
# Selected 2 composition entries.

set(COMDARE_PERMUTATION_LIBRARY_TYPE "SHARED")

set(COMDARE_PERMUTATION_COMPOSITIONS
    "::comdare::cache_engine::compositions::ArtComposition|compositions/art_reference.hpp"
    "::comdare::cache_engine::compositions::HotComposition|compositions/hot_reference.hpp"
)
```

Verwendung im Aufrufer:
```cmake
include("/path/to/generated/perm_list.cmake")
include(anatomy_codegen)
comdare_codegen_anatomy_module_list(
    PILOT_PREFIX  anatomy_perm
    OUTPUT_DIR    "${CMAKE_BINARY_DIR}/generated/anatomy_modules"
    LIBRARY_TYPE  ${COMDARE_PERMUTATION_LIBRARY_TYPE}
    COMPOSITIONS  ${COMDARE_PERMUTATION_COMPOSITIONS})
```

### §48.6 Tests-Snapshot R5.F (14 Tests, 1 Suite)

| Bereich | Tests |
|---|---|
| Tabelle (known_compositions + Lookup) | 4 |
| Selection (CSV, alle, unbekannt) | 3 |
| LibraryType-Parsing | 3 |
| Snippet-Output (LIBRARY_TYPE / Compositions-Liste / STATIC / Auto-Mkdir) | 4 |

Anatomy-Tests gesamt nach R5.F: **154 grün** (13 Test-Files, +14 vs R5.D.3).

### §48.7 Architektur-Konflikt: Target-Naming

Initiale Lieferung hatte Namens-Konflikt: Library `comdare_anatomy_codegen_tool`
+ Executable `comdare_anatomy_codegen_tool` waeren beide CMake-Targets mit
gleichem Namen. Fix: Executable in `comdare_anatomy_codegen_cli` umbenannt
(OUTPUT_NAME bleibt `comdare-anatomy-codegen-tool` fuer User-Sichtbarkeit).

### §48.8 NEXT R5.G + R6/R7

| Sprint | Was |
|---|---|
| R5.G | Trait-Erweiterung (Composition::cpp_type_name + ::header_include) + Tool nutzt PermutationEngine::for_each_composition_type statt hardcoded Tabelle |
| R5.H | 2-Pass-Build: Tool zuerst, CMake-Configure ruft Tool als execute_process, generierter Snippet wird include-t |
| R6 (V42) | Workload-Driver pro geladenem Modul (YCSB-Insert/Lookup) |
| R7 (V42) | F15-Auswertung: tausende Permutationen messen |

---

**Ende Teil 13 §48 (Stand 2026-05-27 spaet — R5.F anatomy_codegen_tool CLI mit
11 known Compositions + 14 Tests).**

---

# Teil 14 — Composition-Location-Traits + descriptor_from_composition<C>() (R5.G)

## §49 R5.G — HasCompositionLocation Concept + Compile-Time-Extraktion

### §49.1 Architektur-Bruecke: Compile-Time ↔ Build-System

R5.F nutzt eine hardcoded Tabelle in `anatomy_codegen_tool.cpp`. Diese muss
manuell synchron gehalten werden wenn neue Compositions hinzukommen.

**R5.G loest das durch Compile-Time-Traits an jeder Reference-Composition:**
jede Composition deklariert `cpp_type_name` + `header_include` als
`static constexpr std::string_view`. Tool kann via Template-Funktion
`descriptor_from_composition<C>()` den `CompositionDescriptor` direkt
aus dem C++-Type extrahieren.

### §49.2 Lieferung

| Datei | Inhalt |
|---|---|
| `anatomy/composition_concept.hpp` (erweitert) | `HasCompositionLocation` Concept + `COMDARE_DEFINE_COMPOSITION_LOCATION` Macro |
| 11 Reference-Composition-Headers (erweitert) | je +2 Includes + +3 Zeilen (Macro-Aufruf nach `name`/`paper_id`) |
| `builder/anatomy_codegen_tool/anatomy_codegen_tool.hpp` (erweitert) | `descriptor_from_composition<C>()` Template |
| `tests/unit/test_v41_anatomy_codegen_tool_traits.cpp` (NEU) | 8 Tests (Concept-Conformance, AdHoc-Negativ, Descriptor-Extraktion, Tabellen-Konsistenz) |

### §49.3 HasCompositionLocation Concept

```cpp
template <typename C>
concept HasCompositionLocation = IsComposition<C> && requires {
    { C::cpp_type_name  } -> std::convertible_to<std::string_view>;
    { C::header_include } -> std::convertible_to<std::string_view>;
};

#define COMDARE_DEFINE_COMPOSITION_LOCATION(TYPE_NAME, HEADER_PATH)               \
    static constexpr std::string_view cpp_type_name  = TYPE_NAME;                 \
    static constexpr std::string_view header_include = HEADER_PATH
```

**Optional vs. Pflicht:** `HasCompositionLocation` ist OPTIONALES Concept zu
`IsComposition`. Reference-Compositions (11 known) erfuellen es; AdHocComposition
NICHT (generisches Cartesian-Element ohne fixe Datei-Lokation).

### §49.4 Composition-Header-Pattern

Vor R5.G:
```cpp
struct ArtComposition {
    using search_algo = ...;
    // ... 16 weitere using-Aliases ...
    static constexpr std::string_view paper_id = "P01 ...";
    static constexpr std::string_view name     = "ArtComposition";
};
```

Nach R5.G:
```cpp
#include "../anatomy/composition_concept.hpp"   // fuer Macro

struct ArtComposition {
    // ... 17 using-Aliases ...
    static constexpr std::string_view paper_id = "P01 ...";
    static constexpr std::string_view name     = "ArtComposition";

    // R5.G CMake-Codegen-Location
    COMDARE_DEFINE_COMPOSITION_LOCATION(
        "::comdare::cache_engine::compositions::ArtComposition",
        "compositions/art_reference.hpp");
};
```

### §49.5 descriptor_from_composition<C>() Template

```cpp
template <HasCompositionLocation C>
[[nodiscard]] constexpr CompositionDescriptor
descriptor_from_composition() noexcept {
    return CompositionDescriptor{
        C::name,              // short_name
        C::cpp_type_name,
        C::header_include
    };
}
```

Verwendung Compile-Time:
```cpp
constexpr auto art_desc = descriptor_from_composition<ArtComposition>();
static_assert(art_desc.cpp_type_name ==
    "::comdare::cache_engine::compositions::ArtComposition");
```

### §49.6 Tabellen-Konsistenz (R5.F hardcoded ↔ R5.G Traits)

Beide Quellen muessen identische Werte liefern. Test verifiziert das fuer alle
11 Compositions paarweise:
```cpp
for_each_composition: descriptor_from_composition<C>() == *find_composition(name)
```

Bei Diskrepanz fehlt's der hardcoded Tabelle (R5.F) → Sync nach Edit der
Reference-Composition pflicht. Spaeter wird Tabelle ganz wegfallen wenn
PermutationEngine direkt iteriert (R5.H).

### §49.7 11 Reference-Compositions ergaenzt

| Composition | cpp_type_name | header_include |
|---|---|---|
| ArtComposition | `::...ArtComposition` | `compositions/art_reference.hpp` |
| HotComposition | `::...HotComposition` | `compositions/hot_reference.hpp` |
| WormholeComposition | `::...WormholeComposition` | `compositions/wormhole_reference.hpp` |
| SurfComposition | `::...SurfComposition` | `compositions/surf_reference.hpp` |
| MasstreeComposition | `::...MasstreeComposition` | `compositions/masstree_reference.hpp` |
| StartComposition | `::...StartComposition` | `compositions/start_reference.hpp` |
| ArtPaperBindingComposition | `::...ArtPaperBindingComposition` | `compositions/art_paper_binding_reference.hpp` |
| HotPaperBindingComposition | `::...HotPaperBindingComposition` | `compositions/hot_paper_binding_reference.hpp` |
| StartPaperBindingComposition | `::...StartPaperBindingComposition` | `compositions/start_paper_binding_reference.hpp` |
| WormholePaperBindingComposition | `::...WormholePaperBindingComposition` | `compositions/wormhole_paper_binding_reference.hpp` |
| SurfPaperBindingComposition | `::...SurfPaperBindingComposition` | `compositions/surf_paper_binding_reference.hpp` |

### §49.8 Tests-Snapshot R5.G (8 Tests, 3 Suites)

| § | Suite | Tests |
|---|---|---|
| §1 | R5G_CompositionLocation (Concept-Conformance 11 Compositions) | 2 |
| §2 | R5G_CompositionLocation (AdHoc-Negativ-Test) | 1 |
| §3 | R5G_DescriptorFromComposition (Art + HotPaperBinding) | 2 |
| §4 | R5G_TableConsistency (R5.F-Tabelle ↔ R5.G-Trait paarweise) | 3 |

Anatomy+Compositions-Tests gesamt nach R5.G: **187 grün** (15 Test-Files, +8 vs R5.F).

### §49.9 NEXT R5.H

| Sprint | Was |
|---|---|
| R5.H | Hardcoded Tabelle in `anatomy_codegen_tool.cpp` entfernen, durch `descriptor_from_composition<C>()` ueber alle 11 known_algorithms.hpp-Aliases ersetzen; Tool bekommt `--from-permutation-engine` Modus |
| R5.I | 2-Pass-Build: Tool via `execute_process` zur CMake-Configure-Time, Output sofort include-t |
| R6 (V42) | Workload-Driver (YCSB) pro geladenem Modul |
| R7 (V42) | F15-Auswertung |

---

**Ende Teil 14 §49 (Stand 2026-05-27 spaet — R5.G HasCompositionLocation Concept
+ 11 Composition-Trait-Erweiterungen + 8 Tests).**

---

# Teil 15 — Trait-driven Tool-Tabelle (R5.H Drift-Eliminierung)

## §50 R5.H — make_desc<C>() ersetzt hardcoded String-Tabelle

### §50.1 Befund vor R5.H

`anatomy_codegen_tool.cpp` enthielt eine hardcoded Tabelle:
```cpp
constexpr std::array<CompositionDescriptor, 11> kKnownCompositionsImpl = {{
    {"art", "::comdare::cache_engine::compositions::ArtComposition", "compositions/art_reference.hpp"},
    // ... 10 weitere ...
}};
```

Problem: bei Aenderung eines `cpp_type_name` oder `header_include` in einer
Composition (z.B. Rename oder Verschiebung) waere die Tool-Tabelle out-of-sync.
R5.G's TableConsistency-Tests faengt das ab — aber erst zur Test-Laufzeit,
nicht zur Compile-Zeit.

### §50.2 Lieferung R5.H

`anatomy_codegen_tool.cpp` nutzt jetzt einen Helper:
```cpp
template <HasCompositionLocation C>
constexpr CompositionDescriptor make_desc(std::string_view short_name) noexcept {
    auto d = descriptor_from_composition<C>();  // R5.G Trait-Extraktion
    d.short_name = short_name;                  // User-friendly CLI-Override
    return d;
}

constexpr std::array<CompositionDescriptor, 11> kKnownCompositionsImpl = {{
    make_desc<comp::ArtComposition>("art"),
    make_desc<comp::HotComposition>("hot"),
    make_desc<comp::WormholeComposition>("wormhole"),
    make_desc<comp::SurfComposition>("surf"),
    make_desc<comp::MasstreeComposition>("masstree"),
    make_desc<comp::StartComposition>("start"),
    make_desc<comp::ArtPaperBindingComposition>("art_pb"),
    make_desc<comp::HotPaperBindingComposition>("hot_pb"),
    make_desc<comp::StartPaperBindingComposition>("start_pb"),
    make_desc<comp::WormholePaperBindingComposition>("wormhole_pb"),
    make_desc<comp::SurfPaperBindingComposition>("surf_pb"),
}};
```

`cpp_type_name` + `header_include` kommen direkt aus den Composition-Traits.
Nur der User-friendly CLI-Short-Name ("art" statt "ArtComposition") bleibt
Tool-spezifisch.

### §50.3 Konsequenzen

**Drift-Eliminierung:** Aenderung eines Composition-Traits propagiert
automatisch in die Tool-Tabelle — Compile-Time-Garantie.

**Build-System-Erweiterungen:** Tool-Lib braucht jetzt:
- Includes fuer alle 11 Composition-Headers
- `${CMAKE_SOURCE_DIR}/libs/cache_engine/src` Include-Pfad (transitiv ueber
  Composition → Concepts → measurement)
- `${CMAKE_BINARY_DIR}/generated` Include-Pfad (configure_file-generierte
  axis_*_flags.hpp Headers)
- `Boost::mp11` Public-Dependency (transitiv ueber observer_aggregate)

**Externes Verhalten unveraendert:** alle 22 Tool-Tests (R5.F 14 + R5.G 8) bleiben
grün ohne Modifikation — Refactor verändert Struktur, nicht API/Output.

### §50.4 Verifikation

CLI-Smoke produziert identisches Output wie R5.F:
```
$ comdare-anatomy-codegen-tool --output /tmp/r5h_smoke.cmake --names art,hot,art_pb
comdare-anatomy-codegen-tool: wrote 3 composition entries (library_type=SHARED)

$ cat /tmp/r5h_smoke.cmake
set(COMDARE_PERMUTATION_LIBRARY_TYPE "SHARED")
set(COMDARE_PERMUTATION_COMPOSITIONS
    "::comdare::cache_engine::compositions::ArtComposition|compositions/art_reference.hpp"
    "::comdare::cache_engine::compositions::HotComposition|compositions/hot_reference.hpp"
    "::comdare::cache_engine::compositions::ArtPaperBindingComposition|compositions/art_paper_binding_reference.hpp"
)
```

### §50.5 Tests-Snapshot R5.H

Kein neuer Test-File — R5.H ist reiner Refactor. R5.G TableConsistency-Tests
bleiben gueltig + relevant (sie testen das Konsistenz-Invariant das R5.H jetzt
strukturell garantiert).

Anatomy+Compositions-Tests gesamt nach R5.H: **187 grün** (15 Test-Files,
identisch zu R5.G).

### §50.6 NEXT R5.I (Tool als Configure-Time-Codegen)

R5.H eliminiert Manual-Drift; R5.I integriert Tool in CMake-Configure-Pass:
- Tool wird via `execute_process()` zur Configure-Time aufgerufen
- Output landet direkt in `${CMAKE_BINARY_DIR}/generated/perm_list.cmake`
- Sofortiges `include()` + `comdare_codegen_anatomy_module_list()`-Aufruf
- 2-Pass-Build: erst Tool gebaut, dann Configure ruft Tool

---

**Ende Teil 15 §50 (Stand 2026-05-27 spaet — R5.H Trait-driven Tool-Tabelle
mit make_desc<C>() Helper, Drift-Eliminierung garantiert).**

---

# Teil 16 — Configure-Time-Codegen via execute_process (R5.I)

## §51 R5.I — comdare_run_anatomy_codegen_tool() + 2-Pass-Build

### §51.1 Architektur-Problem: Chicken-and-Egg

Tool ist eigenes CMake-Target im selben Repo. Bei erstem CMake-Configure
existiert das Tool-Binary noch nicht — `execute_process` koennte es nicht
finden. Klassischer Bootstrap.

**R5.I loest das mit 2-Pass-Build-Pattern:**
```
Pass 1: cmake -B build
  → Function findet Tool nicht, gibt Warning, skipt Codegen
  → Tool-Target wird zur Build-Phase eingehaengt
Build:  cmake --build build --target comdare_anatomy_codegen_cli
Pass 2: cmake -B build  (Re-Configure)
  → Function findet Tool, ruft execute_process
  → Output landet in generated/r5i_perm_list.cmake
  → include() laedt Variablen
  → comdare_codegen_anatomy_module_list() generiert SHARED-DLLs
  → Test-Target wird angelegt
Build:  cmake --build build
  → Test compiliert + linkt gegen Pilot-DLLs
```

### §51.2 Lieferung

| Datei | Inhalt |
|---|---|
| `cmake/anatomy_codegen_runner.cmake` (NEU) | `comdare_run_anatomy_codegen_tool()` Function mit build-tree-search + Idempotenz + STATUS_OUT |
| `tests/unit/CMakeLists.txt` (erweitert) | Optional-Block: ruft Function, bei FOUND wird include + module-list + Test-Target erzeugt |
| `tests/unit/test_v41_anatomy_r5i_configure_codegen.cpp` (NEU) | 4 End-to-End Tests gegen Tool-generierte DLLs |

### §51.3 Function-API

```cmake
comdare_run_anatomy_codegen_tool(
    OUTPUT       <path>                   # Pflicht
    [NAMES       <csv>]                   # default = alle 11
    [LIBRARY_TYPE SHARED|STATIC]          # default = SHARED
    [STATUS_OUT  <var>]                   # "FOUND"/"SKIPPED"/"ERROR"
)
```

**Build-Tree-Search:** Function sucht das Tool in 5 plattform-spezifischen
Pfaden (Release/Debug/RelWithDebInfo/MinSizeRel/Root). Wenn keiner existiert
→ STATUS_OUT="SKIPPED" + Warning.

**Idempotenz:** Wenn Output-File aktueller als Tool-Binary → STATUS_OUT="FOUND"
ohne Re-Run.

**Tool-Aufruf:** `execute_process()` mit `--output --library-type [--names]`.
Stdout/stderr werden bei Fehler in WARNING-Message angezeigt.

### §51.4 Optional-Block-Pattern im Aufrufer

```cmake
include(anatomy_codegen_runner)
comdare_run_anatomy_codegen_tool(
    OUTPUT       "${CMAKE_BINARY_DIR}/generated/r5i_perm_list.cmake"
    NAMES        "art,hot,wormhole"
    LIBRARY_TYPE SHARED
    STATUS_OUT   _r5i_status)

if(_r5i_status STREQUAL "FOUND" AND EXISTS "${_r5i_snippet}")
    include("${_r5i_snippet}")
    comdare_codegen_anatomy_module_list(
        PILOT_PREFIX  "r5i_configure_pilot"
        OUTPUT_DIR    "${_r5i_pilot_dir}"
        LIBRARY_TYPE  ${COMDARE_PERMUTATION_LIBRARY_TYPE}
        COMPOSITIONS  ${COMDARE_PERMUTATION_COMPOSITIONS}
        TARGETS_OUT   _r5i_pilot_targets)
    # ... Test-Target ...
endif()
```

Bei erstem Configure: Block wird uebersprungen ohne Build-Fehler.
Bei zweitem Configure: Block aktiviert + Test-Target wird angelegt.

### §51.5 Voll-Pipeline R5.F → R5.G → R5.H → R5.D → R5.D.2 → R5.D.3 → R5.E → R5.I

```
descriptor_from_composition<C>()           ← R5.G Trait (Compile-Time)
  → make_desc<C>(short_name)               ← R5.H Helper (Drift-frei)
    → kKnownCompositionsImpl Array         ← R5.F Library
      → CLI-Tool comdare-anatomy-codegen-tool  ← R5.F App
        → execute_process zur Configure-Time    ← R5.I NEU
          → r5i_perm_list.cmake Snippet
            → include() + Variable-Set
              → comdare_codegen_anatomy_module_list()  ← R5.D.3
                → configure_file Template         ← R5.D.2
                  → COMDARE_DEFINE_ANATOMY_MODULE ← R5.D
                    → N SHARED-.dll auf Disk
                      → AnatomyModuleLoader::load_all() ← R5.E
                        → N IAnatomyBase via Factory
                          → warm_up / run / reset / shutdown
```

### §51.6 Pilot-Verifikation (3 Tool-erzeugte DLLs)

```
generated/
├── r5i_perm_list.cmake                         (Tool-Output)
└── r5i_anatomy_modules/
    ├── anatomy_perm_r5i_configure_pilot_0.cpp  (ArtComposition, Codegen)
    ├── anatomy_perm_r5i_configure_pilot_1.cpp  (HotComposition)
    ├── anatomy_perm_r5i_configure_pilot_2.cpp  (WormholeComposition)
    ├── comdare_anatomy_perm_r5i_configure_pilot_0.dll
    ├── comdare_anatomy_perm_r5i_configure_pilot_1.dll
    └── comdare_anatomy_perm_r5i_configure_pilot_2.dll
```

Test laedt via `load_all()`, verifiziert Set{Art, Hot, Wormhole}-Composition-Namen,
und fuehrt warm_up→run→shutdown pro Handle aus.

### §51.7 Tests-Snapshot R5.I (4 Tests, 1 Suite)

| § | Test | Beweis |
|---|---|---|
| §1 | PilotDirectoryContainsThreeDlls | Tool-erzeugte DLLs auf Disk |
| §2 | LoadAllReturnsThreeHandles | Loader findet alle 3 |
| §3 | LoadedCompositionsMatchToolSelection | Set{Art, Hot, Wormhole} match Tool --names |
| §4 | LifecyclePerModuleFromToolGeneratedSnippet | warm_up→run→shutdown per DLL |

Anatomy+Compositions-Tests gesamt nach R5.I: **191 grün** (16 Test-Files, +4 vs R5.H).

### §51.8 Build-Fail-Toleranz

Bei erstem Configure (Tool fehlt):
- Function gibt STATUS_OUT="SKIPPED" + Hinweis-Message
- Optional-Block im Aufrufer wird uebersprungen
- Build durchlauft + Tool-Target wird gebaut
- Bei naechstem cmake-Pass ist Tool da → Function liefert FOUND

Damit ist R5.I robust gegen leeren Build-Tree.

### §51.9 NEXT R5.J / V42

R5.D-R5.I Pipeline ist vollstaendig. Naechste Phasen sind in V42-Scope:

| Sprint | Was |
|---|---|
| R5.J (optional) | Tool nutzt `for_each_composition_type` aus SearchAlgorithmPermutationEngine — Trait-driven Tabelle ersetzt durch echte Cartesian-Iteration |
| R6 (V42) | Workload-Driver (YCSB-Insert/Lookup-Sequenz) pro geladenem Modul |
| R7 (V42) | F15-Auswertung: tausende Permutationen messen + schnellste identifizieren |

---

**Ende Teil 16 §51 (Stand 2026-05-27 nacht — R5.I Configure-Time-Codegen via
execute_process + 2-Pass-Build-Pattern + 4 Tests).**

---

# Teil 17 — mp_list-driven Tool-Tabelle (R5.J)

## §52 R5.J — KnownReferenceCompositions mp_list + mp_for_each Iteration

### §52.1 Befund vor R5.J

R5.H hatte hardcoded `std::array<CompositionDescriptor, 11>` mit 11 `make_desc<C>("name")`-
Aufrufen. Drift fuer cpp_type_name + header_include war via R5.G-Traits
eliminiert, aber die *Liste* der bekannten Compositions selbst war noch
manuell hingeschrieben. Eine neue Reference-Composition haette zwei Stellen
gleichzeitig edits gebraucht:

1. neue Composition-Header anlegen + R5.G-Trait setzen
2. Tool-Tabelle erweitern um neuen Eintrag

### §52.2 Lieferung R5.J

| Datei | Inhalt |
|---|---|
| `compositions/known_compositions_list.hpp` (NEU) | 11 Entry-Wrappers + `KnownReferenceCompositions = mp::mp_list<...>` + `kKnownReferenceCompositionsCount static_assert` |
| `builder/anatomy_codegen_tool/anatomy_codegen_tool.cpp` (refactort) | hardcoded array → `mp_for_each<KnownReferenceCompositions>` mit Init-on-first-use Static-Vector |
| `tests/unit/test_v41_anatomy_codegen_tool_mp_list.cpp` (NEU) | 6 Tests: mp_list-Size, Entry-Properties, Iteration, Tool-API-Konsistenz, Descriptor-Match, Duplikat-Check |

### §52.3 Entry-Wrapper-Pattern

Statt einer hardcoded Map oder Auflistung mit redundanten Strings:

```cpp
struct ArtEntry      { using composition = ArtComposition;      static constexpr std::string_view short_name = "art"; };
struct HotEntry      { using composition = HotComposition;      static constexpr std::string_view short_name = "hot"; };
struct WormholeEntry { using composition = WormholeComposition; static constexpr std::string_view short_name = "wormhole"; };
// ... 8 weitere ...

using KnownReferenceCompositions = boost::mp11::mp_list<
    ArtEntry, HotEntry, WormholeEntry, SurfEntry, MasstreeEntry, StartEntry,
    ArtPaperBindingEntry, HotPaperBindingEntry, StartPaperBindingEntry,
    WormholePaperBindingEntry, SurfPaperBindingEntry
>;

inline constexpr std::size_t kKnownReferenceCompositionsCount =
    boost::mp11::mp_size<KnownReferenceCompositions>::value;
static_assert(kKnownReferenceCompositionsCount == 11);
```

**Trennung der Concerns:**
- `composition` Type-Alias → Verbindung zur Composition (R5.G-Traits werden
  via `descriptor_from_composition<C>()` automatisch verwendet)
- `short_name` → Tool-spezifischer CLI-User-friendly Bezeichner

Das verhindert Redundanz: cpp_type_name + header_include stehen NUR in der
Composition selbst (R5.G), short_name stehe NUR im Entry-Wrapper (R5.J).

### §52.4 Tool-Refactor: mp_for_each + Static-Vector

```cpp
namespace {
std::vector<CompositionDescriptor> const& known_compositions_storage() {
    static std::vector<CompositionDescriptor> const tbl = [] {
        std::vector<CompositionDescriptor> v;
        v.reserve(comp::kKnownReferenceCompositionsCount);
        mp::mp_for_each<comp::KnownReferenceCompositions>([&v]<class Entry>(Entry) {
            using C = typename Entry::composition;
            auto d = descriptor_from_composition<C>();  // R5.G Trait
            d.short_name = Entry::short_name;            // R5.J Override
            v.push_back(d);
        });
        return v;
    }();
    return tbl;
}
}  // anonymous
```

**Init-on-first-use:** Bei erstem `known_compositions()`-Call wird die Tabelle
einmalig befuellt + steht danach als const-Span zur Verfuegung. Performance OK
(11 Iterationen × 4 Membervarianten = vernachlaessigbar).

### §52.5 Bridge-Architektur (R5.F → R5.J Endstand)

```
Compile-Time:
  Reference-Compositions (11)
    ↓ HasCompositionLocation Concept + COMDARE_DEFINE_COMPOSITION_LOCATION Macro  (R5.G)
  Composition-Traits (cpp_type_name + header_include)
    ↓ descriptor_from_composition<C>() Template                                    (R5.G)
  CompositionDescriptor (Type-driven)

  Entry-Wrapper (11)
    ↓ KnownReferenceCompositions = mp_list<EntryWrapper...>                        (R5.J NEU)
  Compile-Time-Liste aller bekannten Compositions

Runtime (Tool):
  mp_for_each<KnownReferenceCompositions>
    ↓ Visitor extrahiert descriptor_from_composition<C>() + Entry::short_name      (R5.J NEU)
  std::vector<CompositionDescriptor> (Init-on-first-use)
    ↓
  CLI-Tool: --output --names --library-type ...                                    (R5.F)
    ↓
  CMake-Snippet
    ↓ execute_process zur Configure-Time                                           (R5.I)
  include() + comdare_codegen_anatomy_module_list                                  (R5.D.3)
    ↓
  N SHARED-.dll → AnatomyModuleLoader::load_all → N IAnatomyBase                   (R5.E)
```

### §52.6 Drift-Eliminierung-Beweis

Neue Reference-Composition `FooComposition` registrieren:

1. Composition-Header anlegen mit `COMDARE_DEFINE_COMPOSITION_LOCATION(...)`
   (R5.G Pflicht)
2. Entry-Wrapper `FooEntry { using composition = FooComposition;
   static constexpr short_name = "foo"; }` anlegen
3. `KnownReferenceCompositions` mp_list um `FooEntry` erweitern
4. `static_assert(kKnownReferenceCompositionsCount == 12)` Update

→ Tool sieht `foo` automatisch in `--list`, CLI `--names foo` funktioniert.
KEIN Edit im Tool-cpp noetig. KEIN Edit in find_composition/select_compositions.

### §52.7 Tests-Snapshot R5.J (6 Tests, 1 Suite)

| § | Test | Beweis |
|---|---|---|
| §1 | KnownReferenceCompositionsHasElevenEntries | mp::mp_size + static_assert |
| §2 | EntryWrappersHaveCompositionAndShortName | static_assert composition-Alias + short_name |
| §3 | ForEachIteratesAllElevenEntries | set<short_name> aus mp_for_each = 11 erwartete Namen |
| §4 | ToolApiYieldsSameElevenAsMpList | tool::known_compositions() vs mp_for_each Iteration → identisch |
| §5 | EachEntryDescriptorMatchesToolTable | pro Entry: descriptor_from_composition<C>() == find_composition(short_name) |
| §6 | NoDuplicateCompositionTypesInMpList | set<cpp_type_name>.size() == 11 |

Anatomy+Compositions-Tests gesamt nach R5.J: **197 grün** (17 Test-Files, +6 vs R5.I).

### §52.8 Konsequenzen

**Drift-Eliminierung jetzt VOLLSTAENDIG:**
- R5.H eliminierte Drift fuer cpp_type_name + header_include (via Traits)
- R5.J eliminiert Drift fuer die Composition-LISTE selbst (via mp_list)
- Verbleibendes Edit fuer neue Composition: 4 Stellen (Header + 2× Entry + static_assert)
  — alle in einem `compositions/` Modul, Tool-Code unangefasst

**Pipeline-Endstand R5.D-R5.J:** Voll operativ + drift-frei + Compile-Time-validiert.

### §52.9 NEXT R6/R7 V42

| Sprint | Was |
|---|---|
| R6 (V42) | Workload-Driver pro geladenem Modul (YCSB-Insert/Lookup-Sequenz) |
| R7 (V42) | F15-Auswertung: tausende Permutationen messen + Welch-t-Test + schnellste Komposition identifizieren |

---

**Ende Teil 17 §52 (Stand 2026-05-27 nacht — R5.J mp_list-driven Tool-Tabelle
mit Entry-Wrapper-Pattern + mp_for_each + 6 Tests, Drift-Eliminierung
VOLLSTAENDIG).**

---

# Teil 18 — WorkloadDriver Pilot (R6.A WorkloadConfig + Generator)

## §53 R6.A — WorkloadConfig + deterministischer WorkloadGenerator

### §53.1 User-Direktive verbatim (2026-05-27 nacht, R6-Sprint-Start)

> "Der Workload-Driver wird von der CacheEngineBuilder verwendet, um je
> Permutations-Binary verschiedene Workloads zu testen und zu dokumentieren.
> Die Eigenschaften der zu testenden Workloads werden separat vor dem
> Experiment ueber alle Permutations-Binaries konfiguriert und exakt in
> Reihenfolge und Umfang fuer jede Binary wiederholt."

### §53.2 R6 Sprint-Plan (3 Atomgroessen)

| Sprint | Was |
|---|---|
| **R6.A** (jetzt) | `WorkloadConfig` + deterministischer `WorkloadGenerator` (Pure-Logik, kein DLL/ABI-Integration) |
| R6.B | ABI-Erweiterung um Container-Ops (`comdare_insert/lookup/erase/clear`) + Adapter mit Pilot-`std::map` + `WorkloadDriver` integriert mit `IAnatomyBase` |
| R6.C | Mess-Aggregation + Welch-t-Test + `MeasurementResult` Reporting pro Permutation |

### §53.3 Lieferung R6.A

| Datei | Inhalt |
|---|---|
| `libs/cache_engine/builder/workload_driver/workload_config.hpp` (NEU) | `WorkloadOpKind` enum, `WorkloadOp` POD, `WorkloadConfig` struct, 4 vorgefertigte Profile (insert_heavy/lookup_heavy/mixed_a/mixed_b) |
| `libs/cache_engine/builder/workload_driver/workload_generator.{hpp,cpp}` (NEU) | `WorkloadGenerator` mit xorshift64-PRNG, next/reset/generate_all/remaining API |
| `libs/cache_engine/builder/workload_driver/CMakeLists.txt` (NEU) | `comdare::workload_driver` STATIC-Lib |
| `tests/unit/test_v41_workload_generator.cpp` (NEU) | 21 Tests in 9 Suites |

### §53.4 WorkloadConfig API

```cpp
enum class WorkloadOpKind : std::uint8_t { Insert, Lookup, Erase, Clear };

struct WorkloadOp {
    WorkloadOpKind kind;
    std::uint64_t  key;
    std::uint64_t  value;
};

struct WorkloadConfig {
    std::uint64_t seed = 42;
    std::size_t   num_operations = 1000;
    std::uint64_t key_min = 1;
    std::uint64_t key_max = 1'000'000;
    double pct_insert = 0.50;
    double pct_lookup = 0.40;
    double pct_erase  = 0.09;
    double pct_clear  = 0.01;
    std::string_view name = "DefaultMixedWorkload";

    [[nodiscard]] constexpr bool is_valid() const noexcept;
};
```

### §53.5 Reproduzierbarkeit-Garantie (User-Pflicht)

`WorkloadGenerator` mit identischer `WorkloadConfig` produziert IDENTISCHE
Op-Sequenz. xorshift64-PRNG ist deterministisch ueber alle Plattformen.

Pro Permutations-Binary wird `WorkloadGenerator` neu instantiiert + die
Sequenz wird gegen das jeweilige Binary abgespielt. Resultat: pro Op-Index
laesst sich Latenz/Throughput PRO-Permutation vergleichen (selbe Op an selbem
Index → fairer Vergleich).

### §53.6 PRNG-Wahl: xorshift64

| Aspekt | xorshift64 (gewaehlt) | std::mt19937 |
|---|---|---|
| Period | 2^64 - 1 | 2^19937 - 1 |
| State | uint64_t (8 Byte) | ~2.5 KB |
| Determinismus | ja | ja |
| Cross-Plattform | ja (Standard-Bitops) | ja (Standard) |
| Speed | ~3 cycles/call | ~30-50 cycles/call |
| Cache-Pressure | minimal | hoch (2.5 KB State) |
| Crypto-Sicher | nein (nicht relevant fuer Mess) | nein |

xorshift64 ist die richtige Wahl fuer Mess-Reihen: minimale State + maximale
Speed, period >> num_operations (selbst bei 10^9 Ops nur ~5% des Cycle).

### §53.7 Vorgefertigte Workload-Profile

| Profile | Insert | Lookup | Erase | Clear | YCSB-Analogon |
|---|---|---|---|---|---|
| `make_insert_heavy` | 80% | 20% | 0% | 0% | Bulk-Load-Phase |
| `make_lookup_heavy` | 5% | 95% | 0% | 0% | YCSB-B (read-dominant) |
| `make_mixed_a` | 50% | 50% | 0% | 0% | YCSB-A |
| `make_mixed_b` | 5% | 95% | 0% | 0% | YCSB-B (Variante) |

User kann `WorkloadConfig{}` direkt anpassen oder eigene Helper hinzufuegen.

### §53.8 Tests-Snapshot R6.A (21 Tests, 9 Suites)

| Suite | Tests |
|---|---|
| R6A_Config (is_valid) | 6 |
| R6A_Generator (Konstruktor + Normalisierung) | 3 |
| R6A_Reproducibility (KRITISCH) | 2 |
| R6A_Reset | 1 |
| R6A_BulkApi | 2 |
| R6A_Distribution | 1 |
| R6A_KeyRange | 1 |
| R6A_Profiles | 4 |
| R6A_OpKindName | 1 |

Anatomy+Compositions+Workload-Tests gesamt: **218 grün** (18 Test-Files,
+21 vs R5.J).

### §53.9 Architektur-Bezug: Verantwortlichkeits-Trennung (Doku 14 §17)

Workload-Driver gehoert zur CacheEngineBuilder-Schicht (analog R5.B
AnatomyExecutionContext + 5 Builder-Commands). NICHT zur AnatomyBase.

Die Anatomie liefert nur die Achsen + ObserverAggregate (Doku 14 §17.2);
der Builder dispatched Insert/Lookup/Erase als Commands (Doku 14 §17.3).
R6.A liefert nur den Generator; R6.B verbindet Generator + Commands +
IAnatomyBase ueber die DLL-Grenze.

### §53.10 NEXT R6.B / R6.C

**R6.B (mittlerer Sprint):**
- ABI-Erweiterung in `anatomy_module_abi_v1.hpp`: 4 weitere extern "C" Symbole
  (`comdare_insert/lookup/erase/clear`) als optional-implementiert
- `SearchAlgorithmAbiAdapter` bekommt internen `std::map` (Pilot)
- `WorkloadDriver` Klasse: `run(IAnatomyBase&, WorkloadConfig) → MeasurementResult`
- Integration: WorkloadDriver dispatched Generator-Ops als IAnatomyBase-Methoden-Aufrufe

**R6.C (mittlerer Sprint):**
- `MeasurementResult` POD mit Per-Op-Latenzen
- Welch-t-Test ueber N Permutationen
- Tabular/CSV-Report-Generator

---

**Ende Teil 18 §53 (Stand 2026-05-27 nacht — R6.A WorkloadConfig + deterministischer
WorkloadGenerator + 21 Tests, Pflicht-Reproduzierbarkeit garantiert).**

---

# Teil 19 — Audit-Zwischenstand + Roadmap (2026-05-27 nacht)

## §54 User-Hinweise + 3-Agent-Audit-Resultate

### §54.1 User-Direktive verbatim (2026-05-27 nacht)

> "Wir hatten unter den topics und deren Achsen noch nicht alle Achsen
> implementiert, dort ist vieles noch stubs. Lass uns das zuerst nachholen.
> Danach haben die letzten 10 sessions und die letzten 6 Architektur Dokumente
> noch einen ganzen Stapel an offener Arbeit bezueglich des Aufraeumens der
> Struktur und Einbindung des prt-art als Pruefling gegen die cache-engine."

### §54.2 Audit-Resultat #1: Topics-Stub-Status (20 Achsen, alle PARTIAL)

15 Topics × 20 Achsen × 99 Wrapper-Dateien insgesamt. **0 Achsen voll
ausgebaut**, **20 Achsen PARTIAL** (Skelett vorhanden, Algorithmus-Bodies
fehlen). Alle 11 Reference-Compositions referenzieren konsistent 15 dieser
Achsen — Compositions sind valid, aber dahinterliegende Algorithmen sind
Marker-Klassen.

**Sprint-Plan Achsen-Vollausbau (5 Phasen, ~150-180 SP):**

| Sprint | Achsen | SP |
|---|---|---|
| Sprint 1 Foundation | axis_12_general_hardware (EMPTY), axis_05_memory_layout, axis_02/04_nodes | 5+3+5+5=18 |
| Sprint 2 Traversal | axis_03a_search_algo, axis_03b_cache_traversal, axis_03m_mapping | 21+13+8=42 |
| Sprint 3 Queuing+Concurrency | axis_q1/q2_queuing, axis_08_concurrency | 13+8+8=29 |
| Sprint 4 Allocators | axis_06_allocator (27 Wrapper) | 34 |
| Sprint 5 Optional | filter/io/migration/serialization/telemetry/search_engine/hardware/prefetch/value_handle | 40 |

### §54.3 Audit-Resultat #2: Offene TODOs aus Sessions + Dokus

**Pflicht-Folge-Sprints aus Doku 14:**
- R5.C.2 Pruefling-Namespace-Slot-Pattern fuer prt-art (Stufe 2 + 3 Joins implementieren — pruefling_merge.hpp hat Skelett, prt-art-Slots fehlen)
- R5.C.3 Cross-Constraints fuer queuing (Q-EPOCH+F-EAGER, Q-COW+F-ADAPTIVE etc.)

**Pflicht-Folge-Sprints aus Doku 13:**
- Teil E (Tool-Dokumentation) unvollstaendig — sollte VOR P2.D.t2 komplettiert sein

**Pflicht-Folge-Sprints aus Doku 11:**
- §11.7.E-Q — 13 weitere Topics analog Allocator/Queuing/Traversal vollstaendig spezifizieren

**Pflicht-Folge-Sprints aus Doku 10:**
- §0.4 V32-Implementierungs-Konsequenzen (CEB ICommand-Hierarchie + CacheEngine selbst als ExecutionEngine + drawio Tab CC.1)

**Bausteine-Matrix Konsolidierung:**
- `docs/bausteine/` Komplette Doku erneuern (Organ-Taxonomie statt alte Lebewesen-Matrix)

### §54.4 Audit-Resultat #3: prt-art-Einbindung-Plan

**Befund:** prt-art existiert als eigenes Repo in `Diplomarbeit/Code/external/comdare-prt-art/` mit:
- identity/ (PrtArtIdentity.hpp PermutationFlags-Composer) ✅
- default_lookup/ (9 Achsen-Defaults: 3b, 9, 11, 12, 13, 62, 63, 64, 82) ✅
- internal_search/ (4 Node-Typen: Array256, Array65535, VectorU8U8, VectorU16U16) ✅
- memory_layout/, allocator/, concurrency/, measurement/ ✅
- **FEHLT:** Achsen-Slot-Deklarationen (PrueflingSlot, PrtArtComposition, HasCompositionLocation)

**5-Phasen-Plan (~20h, 2.5 Sprint-Days):**

| Phase | Was | Owner |
|---|---|---|
| 1 (2h) | Audit existing prt-art Axis-Wrapper-Inventar | prt-art |
| 2 (6h) | 9 axis_*_slot.hpp generieren (Slot pro Achse mit PrueflingVariants + has_pruefling + genus=SearchAlgorithm) | prt-art |
| 3 (4h) | PrtArtComposition + HasCompositionLocation-Trait | prt-art |
| 4 (2h) | Entry-Wrapper fuer known_compositions_list.hpp + CMake-Integration | prt-art + cache-engine |
| 5 (3h) | End-to-End: SearchAlgorithmPermutationEngine::assert_pruefling_slot_genus<prt_art::axis_03b::Slot>() + Stufe-2-Codegen + Stufe-3-Union | cache-engine |

**Pflicht-Reihenfolge:**
1. **ZUERST** Topics-Stubs-Vollausbau (User-Direktive, Sprint 1-5 oben)
2. **DANN** prt-art-Einbindung (5-Phasen-Plan)

### §54.5 Priorisierung der naechsten Sprints

| Prio | Sprint | Was | Abhaengigkeit |
|---|---|---|---|
| **1** | **R7.1 Achsen-Vollausbau-Sprint-1** | Foundation (axis_12 + axis_05 + axis_02/04) | keine |
| 2 | R7.2 | Traversal (axis_03a/b/m echte Algorithmus-Bodies) | R7.1 |
| 3 | R7.3 | Queuing+Concurrency Vollausbau | R7.2 |
| 4 | R7.4 | Allocator-Vollausbau (27 Wrapper Body-Erweiterung) | R7.3 |
| 5 | R7.5 | Optional-Topics (filter/io/migration/serialization/telemetry/hardware) | R7.4 |
| **6** | **R8 prt-art-Einbindung** | 5-Phasen-Plan oben | R7.* |
| 7 | R5.C.2 | Stufe-2/3 Pruefling-Merge in cache-engine aktivieren | R8 Phase 2-4 |
| 8 | R6.B/R6.C | Workload-Driver Integration + Mess-Aggregation | R5.D-R5.E (DONE) + R7.* |
| 9 | F15-Auswertung V42 | tausende Permutationen messen + schnellste identifizieren | R6.C |

### §54.6 CMake-Robustness-Fix (CLion-Konfigurations-Problem)

User-Befund 2026-05-27 nacht: CLion-Configure schlug fehl mit
> "The current CMakeCache.txt directory ... is different than the directory ... where CMakeCache.txt was created."

Ursache: Repo wurde von `Research/comdare-cache-engine/` nach
`Modules/comdare-cacheengine-all/comdare-cache-engine/` umgezogen. Stale
FetchContent-Subbuild-Cache zeigte noch auf alten Pfad.

**Fix:**
- NEU `cmake/fetchcontent_stale_cleanup.cmake` mit
  `comdare_clean_stale_fetchcontent_subbuild(<name>)` Function
- Prueft `CMAKE_HOME_DIRECTORY` im subbuild-Cache → bei Mismatch
  `file(REMOVE_RECURSE)` + WARNING
- Pfad-Normalisierung (lowercase + Forward-Slash) fuer Windows
- Sicher: betrifft NUR `_deps/<name>-subbuild/`, nicht User-Code
- In `cmake/gtest_setup.cmake` + `cmake/boost_mp11_setup.cmake` als Pre-Step
  vor `FetchContent_MakeAvailable` aufgerufen

**Konsequenz:** robust gegen Repo-Umzuege; jede neue FetchContent-Dependency
braucht nur einen 1-Liner-Aufruf.

---

**Ende Teil 19 §54 (Stand 2026-05-27 nacht — User-Hinweise + 3-Agent-Audit-
Resultate dokumentiert + Priorisierung der naechsten Sprints + CMake-Robustness-
Fix dokumentiert).**

---

## Nachtraege — E2E-Re-Audit 2026-07-15 (Ausrichtung an §0-GOAL-V5 / erweiterte A-H-Architektur)

> Additive Ausrichtungs-Vermerke; der Originaltext oben bleibt unveraendert (Doku nie loeschen).

- **[R4 · Anker docs/architektur/14_achsen_komposition_organ_metapher.md:744]** Additiv an §17.3 + §21 ein Deprecation-/Korrektur-Banner setzen: Die Strategie `cmake -B build/perm_<hash>` (CMake-Treiber, ein .so/.dll je Permutation) ist durch die kanonische Direktive abgeloest, dass CEB den Tier-Binary-Build zur CEB-Laufzeit C++-seitig orchestriert (NICHT via CMake-per-Permutation, kein Python). Verweis auf `feedback_e4_xml_autoritative_bauanleitung_ceb_orchestriert` + `feedback_no_python_in_buildchain`. Alt-Text (auch die spaeteren CMake-SHARED-Snippets in §48.5/§51.5) bleibt unveraendert erhalten.  
  *(Bezug: §17.3/§21 R5.D `cmake -B build/perm_<hash>` per Permutation vs. R4 CEB-Laufzeit-Orchestrierung des Binary-Builds.)*
- **[R3 · Anker docs/architektur/14_achsen_komposition_organ_metapher.md:743]** Additiv an §17.3 einen Unterabschnitt "CEB-Konfigurationsquelle = Experiment-XML + 2 Registry-XMLs" ergaenzen: Die compile-time `TopicConfigSets` sind das Ziel, in das der XML-Parser (ce-Modul `libs/common/serialization/xml_config_parser`, v32 -> `PhaseStrategyBase<Derived>` CRTP+Concept) uebersetzt; die eine Experiment-XML (3-Phasen) referenziert die zwei Registry-XMLs (ce + prt-art). Verweis auf `feedback_unified_experiment_xml_plus_system_registry_xml`.  
  *(Bezug: §17.3 konfiguriert CEB nur ueber compile-time TopicConfigSets ohne XML-Schicht — R1/R2/R3 fordern die XML-Schicht + Parser als ce-Modul.)*
- **[R9 · Anker docs/architektur/14_achsen_komposition_organ_metapher.md:732]** Additiv an §17.2, §20 und §13 eine Schaerfungs-Notiz anbringen, dass `organ_count()` bzw. die Snapshot-Zahl kanonisch 19 ist (17->19 gemaess Kopf-Banner + AdHocComposition) und den Bezug zu `axis_stats[19][8]` herstellen. Die §28-Notiz (17->19) besteht bereits; §17.2 (732), §20 (891) und die §27.2-Tabelle (1156) fuehren noch "17" und erhalten die additive Notiz. Original-Tabellen/Signaturen werden nicht ueberschrieben.  
  *(Bezug: Body durchgaengig "17 Achsen" (`organ_count(){return 17;}`, §13/§20/§27.2) vs. kanonisch 19 (`axis_stats[19][8]`, golden-320 `mp_take_c<Enabled,4>`).)*
- **[R6 · Anker docs/architektur/14_achsen_komposition_organ_metapher.md:681]** Additiv ein kurzer Traceability-Querverweis, dass §17.1 (compile-time Anatomie, kein Runtime-Switch) zusammen mit §53 (runtime WorkloadDriver/WorkloadConfig) genau die R6-Metaprog-Grenze abbildet: Hot-Path compile-time-only (CRTP+Concepts), W/D (Workload/Dataset) bewusst runtime. Verweis auf `feedback_compile_time_only_no_runtime`. Inhaltlich bestaetigend — keine Korrektur des Bestands noetig.  
  *(Bezug: §17.1 "kein Runtime-Switch" + §53 runtime-Workload == R6; §27.1-vtable ist Cold-Start-ABI-Grenze, nicht Hot-Path — kein Widerspruch.)*

---

### → §59 KERN-Mess-Schema (2026-07-20)

> Additiver Querverweis (kein Duplikat). Die Organ-Metapher/Anatomie dieses Dossiers ist zugleich die **Stempel-Vorlage** der KERN-Mess-Schema-Steuerung (Ledger §59): die Rekombination aller Achsen je Stufe (Planer/CEB/Tier), aus der gestempelt wird. Neu gegenüber §57/§58: je **Prüfling-Merge** ein eigener id-Satz (Tier-Binaries + Mess-Artefakte zusammen) und ein **dritter Tier-Binary-Stempel = die Merge-Kombination** (zusätzlich zu System-Array + Organ-Array). Die 3-Stufen-Merge-Mechanik (`pruefling_merge.hpp` `MergeAxis`) wird von EINEM hart-codierten Prüfling/Slot auf beliebige Prüflinge generalisiert (Umverdrahtung, kein Neubau). Volle Fassung: **Ledger §59**.
