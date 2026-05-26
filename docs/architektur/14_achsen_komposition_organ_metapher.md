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

**Ende docs/architektur/14_achsen_komposition_organ_metapher.md (Stand 2026-05-26 User-Direktive).**
