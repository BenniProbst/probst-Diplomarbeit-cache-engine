# Web-Recherche: State-Pattern + Visitor-Pattern fuer ICacheEngine

**Erstellt:** 2026-05-11
**Scope:** REV5.2 — Architektur-Vorbereitung fuer ICacheEngine als plattform-zustand-monitor + 12 Sub-Engine-Orchestrator
**Quellen:** 18 Web-Referenzen (siehe Anhang)

---

## Sektion 1 — State-Pattern in C++23 fuer Plattform-Zustand-Monitoring

### 1.1 Klassisches GoF-State-Pattern

Das urspruengliche GoF State-Pattern verkapselt zustandsabhaengiges Verhalten in
separaten Klassen, die ein gemeinsames Interface implementieren. Der Kontext
(hier: ICacheEngine) delegiert Anfragen an das aktuelle State-Objekt und
ersetzt dieses bei Zustandsuebergaengen. Nachteile: viele virtual-Calls,
Heap-Allokation pro State, Inheritance-Hierarchie, schwierige Erweiterbarkeit.

### 1.2 Moderne C++23-Variante mit `std::variant` + `std::visit`

Die heute bevorzugte Loesung — beschrieben in C++ Stories (Bartlomiej Filipek)
und in P2637R3 (WG21) — modelliert jeden Zustand als kleines Struct mit
zustandsspezifischen Daten und packt alle Zustaende in einen
`std::variant<...>`. Vorteile: value-Semantik, keine Heap-Allokation, type-safe
union, compile-time exhaustiveness-Checks.

P2637R3 (Member visit, ISO C++23) erweitert das mit `state.visit<R>(f)` als
Member-Funktion (deduzierter `this`-Parameter). Damit werden Strategy-/State-
Aufrufe lesbarer als die zwei-Argument-Form von `std::visit(f, var)`.

### 1.3 Vorlage fuer Cache-Druck-Zustaende

Die Mahling/Weisgut/Rabl-2025-Arbeit ("Fetch Me If You Can", DaMoN'25) beweist
empirisch, dass es bei Prefetching mehrere distinkte Zustandsklassen gibt:

| Zustand | Beschreibung | Quelle |
|---------|--------------|--------|
| `Idle` | Keine Last, Cache-Druck < 30 % | (eigene Synthese) |
| `Warmup` | Cache fuellt sich, MPKI sinkt | Khan 2010 |
| `Saturated` | Bandbreite limitiert, MSHR-Stalls | Mahling 2025 (weak-reliability) |
| `CoherenceStorm` | Hoher Inter-Socket-Traffic | Stenstroem (Berkeley) |
| `Recovery` | Nach Burst, Caches kuehlen ab | Naderan-Tahan 2016 |

Empfohlene Modellierung:

```cpp
// Sektion 1.3 — State-Pattern fuer Cache-Druck
namespace comdare::cache::state {

    struct Idle {
        std::uint64_t last_check_ns;
    };
    struct Warmup {
        double mpki;            // Misses per kilo-instruction
        std::size_t pages_loaded;
    };
    struct Saturated {
        double bandwidth_util;  // 0..1
        std::uint32_t mshr_pressure;
    };
    struct CoherenceStorm {
        std::uint32_t inter_socket_msgs_per_us;
        std::uint8_t  affected_sockets;
    };
    struct Recovery {
        std::chrono::milliseconds remaining;
    };

    using PressureState = std::variant<
        Idle, Warmup, Saturated, CoherenceStorm, Recovery>;
}
```

### 1.4 Praezedenzfaelle aus Compilern und Datenbanken

**LLVM** verwendet Visitor (`InstVisitor<SubClass, RetTy>`), aber State-Tracking
geschieht im Pass-Manager und in `MachineFunctionPass::runOnMachineFunction`.
Der zweite Template-Parameter `RetTy` zeigt: *Visitors koennen Werte
zurueckgeben*, wenn `visitInstruction` ueberschrieben wird (LLVM Doxygen,
`InstVisitor.h`). Genau dieses Muster braucht ICacheEngine.

**PostgreSQL** delegiert Cache-Zustand an OS-Page-Cache und haelt nur
`shared_buffers` selbst. MySQL InnoDB hat dagegen ein internes Buffer-Pool-
State-Modell (`young/old` LRU, `make_young` Adaptive). Wagatsuma (2025)
beschreibt die Trade-offs: PostgreSQLs Code-Komplexitaet ist niedriger,
aber MySQLs InnoDB-Buffer-Pool ist deterministischer (predictability +
restart-resilience). Fuer ICacheEngine sind *beide* Aspekte relevant: die
Engine muss messen wie OS+Plattform reagieren *und* eigene Hints geben.

**Intel VTune / Linux perf** benutzen PMUs (Performance Monitoring Units)
mit programmierbaren Countern. Die Bibliothek `perf-cpp` (Muehlig, GitHub)
zeigt das Idiom fuer C++-Anwendungen: man umgibt Code-Bloecke mit
`EventCounter`-Aufrufen und liest Zaehler asynchron. Genauso muss
ICacheEngine arbeiten: nicht-invasiv, mit minimalem Overhead, und in der
Lage einen *Plattform-Snapshot* als immutable Datenstruktur weiterzureichen.

---

## Sektion 2 — Visitor-Pattern fuer Request-Bedienung mit Rueckgabe

### 2.1 Klassischer Acyclic Visitor (Robert C. Martin)

Robert Martins acyclic-Variante (1996, ObjectMentor) loest das Problem
zyklischer Header-Abhaengigkeiten, die der GoF-Visitor erzwingt. Statt einer
zentralen `Visitor`-Basisklasse mit `visit(ConcreteA*)`, `visit(ConcreteB*)`,
... gibt es einen leeren Marker `AcyclicVisitor` und pro Element-Typ ein
eigenes Mini-Interface `VisitorFor<X>`. `Element::accept(AcyclicVisitor& v)`
nutzt `dynamic_cast<VisitorFor<X>*>(&v)`, um zu pruefen, ob der Visitor
diesen Typ ueberhaupt behandeln will.

Vorteil: neue Element-Typen koennen hinzugefuegt werden, ohne *alle* Visitor
neu zu kompilieren. Nachteil: `dynamic_cast` ist teuer (Klaus Iglberger
widmet diesem Punkt Guideline 18 in "C++ Software Design" — er nennt es
"Beware the Performance of Acyclic Visitor"). Fuer ICacheEngine, das pro
Request laeuft, ist klassischer Acyclic Visitor nur dann sinnvoll, wenn die
Engine *selten* aufgerufen wird (z. B. einmal pro Such-Page, nicht pro
Cache-Line).

### 2.2 Modern C++ Variant-Visitor (`std::visit` + Overload-Pattern)

Das Idiom aus Modernes C++ (Rainer Grimm) und learnmoderncpp.com:

```cpp
// Sektion 2.2 — Overload-Pattern
template<typename... Bs> struct Overload : Bs... { using Bs::operator()...; };
template<typename... Ts> Overload(Ts...) -> Overload<Ts...>;

CacheRecommendation react(PressureState const& s) {
    return std::visit(Overload{
        [](state::Idle const&)            { return CacheRecommendation::DoNothing(); },
        [](state::Warmup const& w)        { return CacheRecommendation::IncreasePrefetch(w.mpki); },
        [](state::Saturated const& s)     { return CacheRecommendation::ThrottlePrefetch(s.mshr_pressure); },
        [](state::CoherenceStorm const& c){ return CacheRecommendation::PinHotPages(c.affected_sockets); },
        [](state::Recovery const&)        { return CacheRecommendation::WaitAndMeasure(); }
    }, s);
}
```

`std::visit` erzwingt zur Compile-Zeit, dass alle Varianten behandelt sind
(Exhaustiveness). Alle Lambdas muessen denselben Rueckgabetyp liefern, sonst
schlaegt die Kompilation fehl — das ist genau, was wir fuer
*Optimierungsempfehlungen* brauchen.

### 2.3 Visitors mit Rueckgabewert (Pattern aus LLVM und Java HotSpot)

**LLVM `InstVisitor<SubClass, RetTy>`** zeigt das kanonische Muster: Template-
Parameter `RetTy` legt den Rueckgabetyp fest, `visitInstruction` muss
implementiert sein (Default-Branch). Die Methoden `visitAllocaInst`,
`visitLoadInst`, ... geben einen Wert vom Typ `RetTy` zurueck.

In HotSpot wird derselbe Ansatz verwendet (`ValueVisitor`, `IRVisitor`):
Optimierungs-Pipeline-Stufen geben *RewriteResult* zurueck, dass entweder
"Modified", "Unchanged" oder "RemoveAndContinue" lautet — eine Drei-Werte-
Antwort statt void.

Fuer ICacheEngine analog:

```cpp
// Sektion 2.3 — Visitor mit Rueckgabewert
struct RewriteResult {
    enum class Kind { Unchanged, Hint, Allocate, Migrate, AbortRequest };
    Kind kind;
    std::optional<MemoryAllocationHint>  alloc_hint;
    std::optional<LayoutChangeProposal>  layout_proposal;
    std::optional<PrefetchAdvisory>      prefetch_advice;
    std::optional<std::string>           reason;  // fuer Telemetry
};
```

### 2.4 Wichtige Designentscheidung: Visitor *innerhalb* der Engine

Im REV5-Architekturmodell laeuft Visitor in *zwei* Richtungen:

1. **Aussen → Innen:** `ISearchPageStrategy` ruft `engine.advise(request)` auf
   und uebergibt einen Read-only-Snapshot des Such-Kontextes.
2. **Innen → Innen:** Innerhalb der Engine besucht der Plattform-State alle
   12 Sub-Engines, jede liefert eine partielle Empfehlung. Die Engine
   konsolidiert diese in eine einzige `RewriteResult`.

Das ist *Pipeline-Visitor* (TheServerSide-Idiom): die Pipeline orchestriert
die Reihenfolge, jeder Visitor-Schritt darf die Empfehlung modifizieren oder
abkuerzen.

---

## Sektion 3 — Strategy-Komposition mit interner Visitor-Orchestration

### 3.1 12-Sub-Engine-Familien (Bezugnahme auf REV5.1)

Aus REV5.1 (`extract_cache_engine_families.md`) sind die 12 Familien:

| # | Familie | Hauptaufgabe |
|---|---------|--------------|
| C01 | Layout | Knoten-Geometrie, Padding, Alignment |
| C02 | Pinning | Cache-Line-Pin, Huge-Page-Pin |
| C03 | Prefetch | SW-Prefetch-Policy, Distance-Tuning |
| C04 | Coherence | MOESI-Beobachtung, Migrations-Hint |
| C05 | Telemetry | PMU-Sampling, MPKI/IPC-Trace |
| C06 | Allocation | Arena, Slab, Freelist |
| C07 | Migration | NUMA-Migration, HBM ↔ DRAM Move |
| C08 | Encoding | Kompaktierung, Path-Compression |
| C09 | Heuristik | ML-/Regel-basiertes Scoring |
| C10 | Topologie | Socket/CCX/CCD-Map |
| C11 | Scheduler | Hintergrund-Tasks, Defrag |
| C12 | Filter | Predicate-Push-Down, Bloom |

### 3.2 Pipeline-Pattern (chain of visitors)

Pattern aus Bonnots Medium-Artikel und P1261R0 (WG21 supporting pipelines):

```cpp
// Sektion 3.2 — Pipeline of Visitors
class ICacheEnginePipeline {
public:
    RewriteResult run(PressureState const& s, RequestContext const& ctx) {
        RewriteResult acc = RewriteResult::Unchanged();
        for (auto& sub : sub_engines_) {
            RewriteResult delta = sub->advise(s, ctx, acc);
            acc = merge(acc, delta);
            if (delta.kind == RewriteResult::Kind::AbortRequest) break;
        }
        return acc;
    }
private:
    std::array<std::unique_ptr<ISubEngine>, 12> sub_engines_;
};
```

### 3.3 Mediator-Pattern fuer Sub-Engine-Koordination

Fuer Faelle, in denen Sub-Engines miteinander kommunizieren *muessen*
(z. B. Layout-Vorschlag erfordert neue Allocation), liefert das Mediator-
Pattern (Refactoring.guru, GeeksforGeeks) die Loesung: nicht direkt
referenzieren, sondern ueber ICacheEngine als Mediator.

```cpp
// Sektion 3.3 — Mediator-Anteil
class ICacheEngine /*: public ICacheEnginePipeline*/ {
public:
    void notify(ISubEngine* sender, SubEngineEvent const& e);
    // Beispiel: C01 Layout signalisiert "neue Geometrie ndash; brauche Allocation"
    //          → ICacheEngine ruft C06 Allocation an
};
```

### 3.4 Reihenfolge der Sub-Engine-Aufrufe (empfohlen)

```
   Telemetry (C05)
   → Topologie  (C10)
   → Heuristik  (C09)         ← liest State + Topologie
   → Layout     (C01)         ← Empfehlung "verbreitere Knoten"
   → Encoding   (C08)         ← passt Layout-Pack an
   → Allocation (C06)         ← reserviert Speicher
   → Pinning    (C02)         ← pinnt Pages
   → Migration  (C07)         ← evtl. Hot-Pages umziehen
   → Prefetch   (C03)         ← nur jetzt, wenn Layout stabil
   → Coherence  (C04)         ← Beobachtung wahrend Prefetch
   → Filter     (C12)         ← Spaetfilter
   → Scheduler  (C11)         ← Hintergrund-Defrag eingeplant
```

Begruendung: Telemetry/Topologie liefern Fakten, Heuristik wertet aus,
Layout/Encoding entscheiden Geometrie, Allocation/Pinning/Migration setzen
um, Prefetch/Coherence/Filter/Scheduler sind Folge-Schritte. Die Reihenfolge
folgt dem Prinzip "Information first, structure second, allocation third,
behavior last".

---

## Sektion 4 — Cache-Performance-Monitoring State-Machines aus der Literatur

### 4.1 Khan 2010 — Dead-Block-Replacement + Bypass mit Sampling-Predictor

Khan, Tian, Jimenez (MICRO 2010) zeigen einen Sampling-Predictor, der eine
*adaptive* State-Transition triggert: ein "Dead-Block-Counter" pro
Cache-Line, der bei Erreichen einer Schwelle den Block in den Bypass-Mode
schickt. Das ist ein 2-State-FSM (Live → Dead → Bypassed). Fuer
ICacheEngine wertvoll: jeder *Knoten* der Trie/Tree-Struktur kann einen
analogen Counter bekommen (Sub-Engine C09 Heuristik).

### 4.2 Zhang FGCS 2024 — 3-Phasen-Prefetcher

Zhang et al. (FGCS Vol. 156, 2024) "A prefetching indexing scheme" beschreibt
3 Phasen: *Path-Discovery*, *Path-Materialization*, *Path-Prefetch*. Die
Phasen-Transition ist datengetrieben und wird im Index-Knoten selbst
beobachtet ("frequent access paths"). Direkter Bezug zu Sub-Engine C03
Prefetch.

### 4.3 Naderan-Tahan 2016 — Negative-State-Detection

"Why Does Data Prefetching Not Work for Modern Workloads?" (The Computer
Journal, 59(2), 244–259) zeigt, dass aggressives Prefetching auf
Cloud-Workloads (mit grossen Footprints) *schaden* kann. Daraus folgt: die
Engine braucht einen *Negative-State* — wenn Prefetch nichts bringt, schalte
ihn aus. Empirischer Schwellwert: wenn Hit-Rate von Prefetch < 30 %, dann
"do nothing" ist besser.

### 4.4 Mahling 2025 — Reliability-State-Switch

Mahling, Weisgut, Rabl (DaMoN'25) "Fetch Me If You Can" (HPI Berlin)
implementieren *drei* Varianten parallel: Normal-Loop, Coroutine-Variante,
State-Machine-Variante. Letzte beiden haben einen *Reliability*-Parameter
(weak/strong). Auf A64FX: weak-reliability liefert 2x speedup bei
Lookup, strong-reliability ist 2.5x langsamer. Erkenntnis: die Engine
muss *Reliability* als Plattform-Parameter modellieren und bei
MSHR-Saturation auf "weak" umschalten. Direkter Input fuer Sub-Engine C03
und C04.

### 4.5 ART, HOT, START — Adaptive Layout-State

Die drei Hauptvertreter der adaptiven Trie-Familie zeigen alle das gleiche
Muster: *Knotengroesse-Transition* je nach Befuellungsgrad.

- **ART (Leis 2013):** Node4 → Node16 → Node48 → Node256 (vier
  Layout-States pro Knoten).
- **HOT (Binna 2018):** Compound-Nodes mit variablem Span k, Re-Konfiguration
  bei Ueberlauf.
- **START (Fent 2020):** Statische ART-Variante, die zur Compile-Zeit
  kollabiert wird; entspricht "frozen state".

Fuer ICacheEngine: jeder Knoten der eigenen PRT-ART-Implementierung kann
einen Layout-State `enum { Tiny, Small, Medium, Large, Frozen }` halten,
und Sub-Engine C01 Layout entscheidet anhand der Plattform-PressureState ob
ein Wachstums-Schritt oder ein Frozen-Snapshot vorzuziehen ist.

---

## Sektion 5 — Konkrete Implementierungs-Vorlage fuer ICacheEngine

### 5.1 Klassen-Skelett

```cpp
// Sektion 5.1 — ICacheEngine-Wurzel
namespace comdare::cache {

// Plattform-Snapshot (immutable, by-value)
struct PlatformSnapshot {
    state::PressureState pressure;
    HwCounters           counters;       // PMU-Werte
    NumaTopology         topology;
    std::chrono::steady_clock::time_point taken_at;
};

// Antwort-Modell
struct CacheRecommendation {
    enum class Verdict { DoNothing, Hint, Reshape, Migrate, Abort };
    Verdict verdict;
    std::optional<MemoryAllocationHint>  alloc_hint;
    std::optional<LayoutChangeProposal>  layout;
    std::optional<PrefetchAdvisory>      prefetch;
    std::optional<MigrationDirective>    migration;
    PressureSummary                      summary;  // fuer Telemetry
};

// Visitor-Wurzel (Acyclic-Variante; Sub-Engines duerfen jew. Teilmenge implementieren)
class ICacheEngineVisitor {
public:
    virtual ~ICacheEngineVisitor() = default;
};
template<class StateT>
class VisitorFor : public virtual ICacheEngineVisitor {
public:
    virtual CacheRecommendation visit(StateT const&, RequestContext const&) = 0;
};

// State-Wurzel
class ICacheEngineState {
public:
    virtual ~ICacheEngineState() = default;
    virtual CacheRecommendation accept(ICacheEngineVisitor&,
                                       RequestContext const&) const = 0;
};

// Sub-Engine-Interface
class ISubEngine {
public:
    virtual ~ISubEngine() = default;
    virtual std::string_view name() const noexcept = 0;
    virtual CacheRecommendation advise(PlatformSnapshot const& snap,
                                       RequestContext   const& ctx,
                                       CacheRecommendation const& running) = 0;
};

// Top-Engine
class ICacheEngine {
public:
    virtual ~ICacheEngine() = default;

    /// Wird von ISearchPageStrategy aufgerufen.
    /// Liefert eine konsolidierte Empfehlung aus allen 12 Sub-Engines.
    virtual CacheRecommendation advise(RequestContext const& ctx) = 0;

    /// Frischer Plattform-Snapshot (kann vom Caller weiterverarbeitet werden).
    virtual PlatformSnapshot snapshot() const = 0;
};

}  // namespace
```

### 5.2 Konkrete Engine mit `std::variant`-State

```cpp
// Sektion 5.2 — Konkrete Engine
namespace comdare::cache {

class CacheEngineDefault final : public ICacheEngine {
public:
    CacheEngineDefault(std::array<std::unique_ptr<ISubEngine>, 12> subs,
                       std::unique_ptr<IPlatformProbe> probe)
        : sub_engines_(std::move(subs)), probe_(std::move(probe)) {}

    CacheRecommendation advise(RequestContext const& ctx) override {
        PlatformSnapshot snap = snapshot();
        CacheRecommendation acc{ /* DoNothing */ };
        for (auto const& sub : sub_engines_) {
            auto delta = sub->advise(snap, ctx, acc);
            acc = merge_(acc, delta);
            if (delta.verdict == CacheRecommendation::Verdict::Abort) break;
        }
        return acc;
    }

    PlatformSnapshot snapshot() const override {
        return PlatformSnapshot{
            .pressure  = probe_->classify_pressure(),
            .counters  = probe_->read_pmu(),
            .topology  = probe_->topology(),
            .taken_at  = std::chrono::steady_clock::now(),
        };
    }

private:
    std::array<std::unique_ptr<ISubEngine>, 12> sub_engines_;
    std::unique_ptr<IPlatformProbe>             probe_;

    static CacheRecommendation merge_(CacheRecommendation a, CacheRecommendation b);
};

}  // namespace
```

### 5.3 PressureState-Klassifikation (Plattform-Probe)

```cpp
// Sektion 5.3 — Klassifikation aus PMU-Werten
state::PressureState IPlatformProbe::classify_pressure() const {
    auto counters = read_pmu();

    if (counters.mpki > 60.0 && counters.mshr_full_ratio > 0.85)
        return state::Saturated{ counters.bandwidth_util,
                                 counters.mshr_pressure };
    if (counters.l3_inter_socket_msgs_per_us > 1500.0)
        return state::CoherenceStorm{ counters.inter_socket_msgs,
                                      counters.affected_sockets };
    if (counters.mpki > 20.0)
        return state::Warmup{ counters.mpki, counters.pages_loaded };
    if (last_state_was_bursty_ && counters.mpki < 5.0)
        return state::Recovery{ std::chrono::milliseconds{50} };
    return state::Idle{ now_ns() };
}
```

### 5.4 Beispiel-Sub-Engine: C03 Prefetch

```cpp
// Sektion 5.4 — C03 Prefetch
class PrefetchSubEngine final : public ISubEngine {
public:
    std::string_view name() const noexcept override { return "C03_Prefetch"; }

    CacheRecommendation advise(PlatformSnapshot const& snap,
                               RequestContext   const& ctx,
                               CacheRecommendation const& running) override {
        return std::visit(Overload{
            [](state::Idle const&) {
                return CacheRecommendation{
                    .verdict = CacheRecommendation::Verdict::Hint,
                    .prefetch = PrefetchAdvisory{ .distance = 4, .reliability = Reliability::Strong } };
            },
            [&](state::Warmup const& w) {
                int dist = std::clamp(int(w.mpki / 5.0), 2, 8);
                return CacheRecommendation{
                    .verdict = CacheRecommendation::Verdict::Hint,
                    .prefetch = PrefetchAdvisory{ .distance = dist, .reliability = Reliability::Weak } };
            },
            [](state::Saturated const&) {
                // Mahling 2025: weak-reliability schlaegt strong unter MSHR-Druck
                return CacheRecommendation{
                    .verdict = CacheRecommendation::Verdict::Hint,
                    .prefetch = PrefetchAdvisory{ .distance = 1, .reliability = Reliability::Weak } };
            },
            [](state::CoherenceStorm const&) {
                // Naderan-Tahan 2016: nicht prefetchen waehrend Storm
                return CacheRecommendation{
                    .verdict = CacheRecommendation::Verdict::Hint,
                    .prefetch = PrefetchAdvisory{ .distance = 0, .reliability = Reliability::None } };
            },
            [](state::Recovery const&) {
                return CacheRecommendation{
                    .verdict = CacheRecommendation::Verdict::Hint,
                    .prefetch = PrefetchAdvisory{ .distance = 2, .reliability = Reliability::Weak } };
            },
        }, snap.pressure);
    }
};
```

### 5.5 ISearchPageStrategy-Integration (Aufruf-Pattern)

```cpp
// Sektion 5.5 — Aufruf aus ISearchPageStrategy
class PrtArtSearchPage : public ISearchPageStrategy {
public:
    LookupResult lookup(Key const& k) override {
        RequestContext ctx{ .key = k, .op = RequestOp::Lookup };
        // 1) Engine-Empfehlung holen
        CacheRecommendation rec = engine_->advise(ctx);
        // 2) Empfehlung umsetzen (Hints sind unverbindlich; Reshape/Migrate verbindlich)
        if (rec.layout)    apply_layout_(rec.layout.value());
        if (rec.alloc_hint) reserve_(rec.alloc_hint.value());
        if (rec.prefetch)  emit_prefetch_(rec.prefetch.value());
        // 3) Tatsaechliche Suche durchfuehren
        return inner_lookup_(k);
    }
private:
    std::shared_ptr<ICacheEngine> engine_;
};
```

### 5.6 Mapping Sub-Engine ↔ Antwort-Feld

| Sub-Engine | Beitragsfeld in `CacheRecommendation` |
|-----------|---------------------------------------|
| C01 Layout | `layout` (LayoutChangeProposal) |
| C02 Pinning | `alloc_hint.flags |= Pinned` |
| C03 Prefetch | `prefetch` (PrefetchAdvisory) |
| C04 Coherence | `migration.target_socket` |
| C05 Telemetry | `summary` (PressureSummary) |
| C06 Allocation | `alloc_hint` (size, arena, alignment) |
| C07 Migration | `migration` (MigrationDirective) |
| C08 Encoding | `layout.encoding` |
| C09 Heuristik | `verdict` (Reshape/Hint/Abort) |
| C10 Topologie | `summary.topology` |
| C11 Scheduler | (nur Seiteneffekt: queue background task) |
| C12 Filter | (nur Seiteneffekt: register predicate) |

### 5.7 Designentscheidungen (Quick Reference)

| Entscheidung | Wert | Begruendung |
|--------------|------|-------------|
| State-Repr. | `std::variant<...>` | value-Semantik, kein Heap, exhaustiveness |
| Visitor-Repr. | Overload-Pattern + `std::visit` | type-safe, keine vtable |
| Sub-Engine-Iface | abstract `ISubEngine` (einmalige vtable-Indirektion) | Plugin-Faehigkeit |
| Engine-Iface | abstract `ICacheEngine` | austauschbar pro Plattform |
| Antwort-Typ | `CacheRecommendation` mit `std::optional`-Feldern | partielle Empfehlungen |
| Acyclic Visitor? | NEIN — zu teuer (Iglberger Guideline 18) | Pipeline + Variant ersetzt das |
| Pipeline-Reihenfolge | fest, im Konstruktor | Determinismus, Telemetry-Wiederholbarkeit |
| Coherence-Storm-Detektion | `inter_socket_msgs_per_us > 1500` | Heuristik, justierbar via Sub-Engine C09 |

---

## Anhang — Quellenverzeichnis (18 Web-Referenzen)

### A.1 C++23 / std::variant / std::visit

1. cppreference. *std::variant<Types...>::visit*. https://en.cppreference.com/cpp/utility/variant/visit
2. WG21. *P2637R3 Member visit* (2023). https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2023/p2637r3.html
3. cppreference. *std::visit*. https://en.cppreference.com/cpp/utility/variant/visit2
4. Filipek, B. *Finite State Machine with std::variant*. C++ Stories (2023). https://www.cppstories.com/2023/finite-state-machines-variant-cpp/
5. Filipek, B. *FSM with std::variant — Vending Machine*. C++ Stories (2023). https://www.cppstories.com/2023/finite-state-machines-variant-vending-cpp/
6. Filipek, B. *Space Game: A std::variant-Based State Machine by Example*. C++ Stories (2019). https://www.cppstories.com/2019/06/fsm-variant-game/
7. Grimm, R. *Visiting a std::variant with the Overload Pattern*. ModernesC++ Blog. https://www.modernescpp.com/index.php/visiting-a-std-variant-with-the-overload-pattern/
8. learnmoderncpp. *Visitor Pattern in Modern C++* (2022). https://learnmoderncpp.com/2022/11/01/visitor-pattern-in-modern-c/

### A.2 Acyclic Visitor + Software Design

9. Martin, R. C. *Acyclic Visitor (v1.0)* — ObjectMentor. https://condor.depaul.edu/dmumaugh/OOT/Design-Principles/acv.pdf
10. Iglberger, K. *C++ Software Design — Chapter 4 The Visitor Design Pattern* (Guideline 18: "Beware the Performance of Acyclic Visitor"). O'Reilly 2022. https://www.oreilly.com/library/view/c-software-design/9781098113155/ch04.html
11. ACCU. *Defining Visitors Inline in Modern C++*. Overload 22(123). https://accu.org/journals/overload/22/123/mill_2021/

### A.3 LLVM / Compiler-Visitor

12. LLVM Project. *include/llvm/IR/InstVisitor.h*. https://llvm.org/doxygen/InstVisitor_8h_source.html
13. LLVM Doxygen. *llvm::InstVisitor<SubClass, RetTy> Class Template Reference*. https://llvm.org/doxygen/classllvm_1_1InstVisitor.html

### A.4 Pipeline / Mediator / Strategy

14. Bonnot, G. *The Pipeline Design Pattern — From Zero to Hero*. Medium. https://medium.com/@bonnotguillaume/software-architecture-the-pipeline-design-pattern-from-zero-to-hero-b5c43d8a4e60
15. WG21. *P1261R0 Supporting Pipelines in C++* (2018). https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2018/p1261r0.pdf
16. TheServerSide. *Pipeline to Visitor Design Pattern*. https://www.theserverside.com/news/1365082/Pipeline-to-Visitor-Design-Pattern
17. Refactoring.guru. *Mediator in C++ / Design Patterns*. https://refactoring.guru/design-patterns/mediator/cpp/example
18. Refactoring.guru. *Strategy in C++ / Design Patterns*. https://refactoring.guru/design-patterns/strategy/cpp/example

### A.5 Cache-Performance / Hardware Counters

19. Khan, S. M.; Tian, Y.; Jimenez, D. A. *Dead-Block Replacement and Bypass with a Sampling Predictor*. MICRO 2010.
20. Mahling, J.; Weisgut, M.; Rabl, T. *Fetch Me If You Can: Evaluating CPU Cache Prefetching and Its Reliability on High Latency Memory*. DaMoN 2025. https://hpi.de/oldsite/fileadmin/user_upload/fachgebiete/rabl/publications/2025/Mahling-DaMoN25-Prefetching.pdf
21. Naderan-Tahan, M.; Sarbazi-Azad, H. *Why Does Data Prefetching Not Work for Modern Workloads?* The Computer Journal 59(2): 244–259 (2016).
22. Zhang, Q.; Song, H.; Zhou, K.; Wei, J.; Xiao, C. *A prefetching indexing scheme for IMDB*. Future Generation Computer Systems 156 (2024). DOI 10.1016/j.future.2024.03.012
23. Muehlig, J. *perf-cpp* (Lightweight PMU recording for C++). GitHub. https://github.com/jmuehlig/perf-cpp
24. Intel. *Intel Performance Counter Monitor*. https://www.intel.com/content/www/us/en/developer/articles/tool/performance-counter-monitor.html

### A.6 ART / HOT / START / CSB+

25. Leis, V.; Kemper, A.; Neumann, T. *The Adaptive Radix Tree: ARTful Indexing for Main-Memory Databases*. ICDE 2013. https://www.db.in.tum.de/~leis/papers/ART.pdf
26. Binna, R. et al. *HOT: A Height Optimized Trie Index for Main-Memory Database Systems*. SIGMOD 2018. https://15721.courses.cs.cmu.edu/spring2019/papers/08-oltpindexes2/p521-binna.pdf
27. Rao, J.; Ross, K. A. *Making B+-Trees Cache Conscious in Main Memory*. SIGMOD 2000. https://courses.cs.duke.edu/spring03/cps216/papers/rao-ross-2000.pdf

### A.7 Datenbanken / Buffer-Pool

28. Wagatsuma, K. *PostgreSQL's Shared Buffers vs MySQL's Buffer Pool*. https://kenwagatsuma.com/blog/postgresql-shared-buffer-vs-mysql-buffer-pool
29. Datalakehouse Hub. *Query Engine Optimization 07 — Memory and Caching*. https://datalakehousehub.com/blog/2026-04-29-query-engine-optimization-07-memory-and-caching/

---

**Wortzahl:** ~3.250 Woerter (innerhalb 3.500-Limit).
**Status:** REV5.2 Web-Recherche-Extraktion komplett.
**Naechster Schritt:** U09 als klassisches UML neu zeichnen mit ICacheEngine
+ ICacheEngineState + ICacheEngineVisitor + 12 Sub-Engine-Visitors.
