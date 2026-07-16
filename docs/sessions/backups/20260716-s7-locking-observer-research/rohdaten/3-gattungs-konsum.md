# STRANG 3 — Gattungs-Verwendung der Concurrency-/Locking-Achse (axis_08)

**Auftrag S-7 (2026-07-16):** Kartiere, wie die **SearchAlgorithm-Gattung** und die **Container-Gattung**
(Adapter/Set/Sequence/View) die Concurrency-/Locking-Achse (axis_08) heute konsumieren. Getrieben oder
Deskriptor? Was hieße „echt verwendet" (Hot-Path unter Last, messbar via Observer) je Gattung? Belege
`datei:zeile`. **READ-ONLY** (nur diese Rohdaten-Datei geschrieben).

Wurzelpfad aller Code-Zitate:
`Code/external/comdare-cache-engine/libs/cache_engine/` (relativ zum Repo `probst-diplomarbeit-cache-engine`).

---

## 0. Der Achsen-Bestand (Kontext Dossier 23)

9 Concurrency-**Organe** (= Strategien), registriert in
`axes/concurrency_axis/axis_08_concurrency_registry.hpp:23-25`:
`NoneConcurrency, BlockingConcurrency, ReaderWriterConcurrency, OlcOptimisticConcurrency,
LockFreeConcurrency, WaitFreeConcurrency, RcuConcurrency, HazardPointerConcurrency,
OlcReservedBlocksConcurrency`.

**Dossier-23-Befund bestätigt:** Das Locking-Mode-Vokabular der Achse nennt *vier* Modi
`read-only, read-write, upgradeable, optimistic-validation`
(`topics/concurrency/concepts/topic_concurrency_concept.hpp:10`), aber es existiert **kein Upgradeable-Organ**
unter den 9 Strategien. `ReaderWriterConcurrency` realisiert nur die **SHARED-(Reader-)Bahn**
(`axis_08_concurrency_reader_writer.hpp:40-42`: `try_lock_shared`/`lock_shared`/`unlock_shared`) — die
Exklusiv-Write- bzw. Upgrade-Bahn fehlt. „Upgradeable-Locking" ist also im Vokabular deklariert, aber ohne
Organ. (Dieser Strang kartiert die *Gattungs-Verwendung*; der Organ-Bau selbst ist Sache eines anderen Strangs.)

---

## 1. SearchAlgorithm-Gattung (Säugetier)

### 1.1 AdHocComposition-Slot — reiner Typ-Deskriptor
`anatomy/composition_factory.hpp:60` → `using concurrency = T8;` (in `struct AdHocComposition<T0..T18>`,
:51/:60). Der Slot ist ein **Typ-Alias** auf eine der 9 Strategien — Kompositions-Identität, kein Antrieb.
Er wird beim Codegen nur *als Name* ausgelesen (`builder/codegen/adhoc_emitter.hpp:65`
`add(type_name<typename C::concurrency>())`).

### 1.2 Reine Anatomie (`SearchAlgorithmAnatomy`) — HÄLT das Organ NICHT
`anatomy/search_algorithm_anatomy.hpp`. `observe_all()` (:62-106) hält+treibt **9** Organe als echte Member
(:177-200): `search_algo, telemetry, memory_layout, serialization, node_type, cache_traversal, mapping,
queuing_q1, queuing_q2`. **`concurrency` ist NICHT dabei** — kein `axis_concurrency_`-Member, kein
`concurrency_organ()`-Accessor, keine `agg.concurrency = …`-Zeile. → In der reinen Anatomie ist die
Concurrency-Achse **Deskriptor** (bleibt `EmptyAxisSnapshot`).

Der aggregierte POD `ObserverAggregate<Composition>` trägt zwar einen `concurrency`-Snapshot-Slot
(`anatomy/observer_aggregate.hpp:103`) und `observable_count()` würde ihn zählen (:128) — aber weil die
Anatomie ihn nie befüllt, bleibt er in diesem Pfad leer.

### 1.3 ABI-Laufzeit-Sicht (`SearchAlgorithmAbiAdapter`, Thesis „SearchEngine") — HÄLT + TREIBT das Organ
Der Adapter hält ein **eigenes** Concurrency-Mess-Organ (getrennt von der Anatomie):
`anatomy/abi_adapter.hpp:2161` →
`mutable …concurrency_axis::ObservableConcurrency<typename Composition::concurrency> cc_organ_{};`.
Die Hülle `ObservableConcurrency<S>` (`axes/concurrency_axis/axis_08_concurrency_observable.hpp:52-136`)
treibt das **echte statische Sync-Primitiv** `Strategy::try_acquire/acquire/release` und zählt.

Es gibt **zwei** Treibe-Pfade:

- **Pfad A (per-Achsen-ns, `run_workload_segmented_v2`):** T8-Segment
  `anatomy/abi_adapter.hpp:770-787`. `if constexpr` auf `Concurrency::acquire()/release()`, dann
  `ops_per_batch`-fach acquire→Mini-Critical-Section→release, **einzel-thread**, mit eigenem steady_clock-Timer
  → `seg_concurrency_ns` (echte CPU-Zeit des Primitivs; None = ehrliche 0-Overhead-Baseline).
- **Pfad B (Observer):** `cc_organ_.observe_critical_section()` (= acquire+release, Hülle :118-121) wird in
  **JEDEM** `tier_insert` (`abi_adapter.hpp:963`) **UND** `tier_lookup` (`:1019-1020`) aufgerufen. Die
  Statistik fließt via `fill_observer_v3` (`:1280-1288`) in `axis_stats[8]`:
  `acquire_count, release_count, contention_count, validation_failure_count, pattern_id`.

**Zwei-Phasen-Loop:** `drive_two_phase_tier_trace_abi`
(`builder/anatomy_commands/tier_observe_trace_abi.hpp:198 ff`; Phase 1 = Warmup verworfen :114, Phase 2 =
gemessen :117) treibt genau diese `tier_insert`/`tier_lookup` an Füllstands-Checkpoints unter Last und ruft
danach `tier_observe` → damit wird die Concurrency-Achse im **Mess-Pfad WIRKLICH exerziert** (nicht bloß
deklariert). Über den ABI-Adapter ist die SearchAlgorithm-Gattung also **AKTIV getrieben, nicht Deskriptor**.

### 1.4 ABER: die achsen-DEFINIERENDEN Observer-Werte sind strukturell 0
- `contention_count` + `validation_failure_count` sind im Einzel-Thread-Pfad **ehrlich 0**
  (`axis_08_concurrency_observable.hpp:15-19` + Felder :40-41; Adapter-Kommentar `abi_adapter.hpp:1279`).
  Das CAS gelingt im 1. Versuch, OLC-Validate ist stets gültig → keine Contention beobachtbar.
- `thread_count` (axis_08) wird via `tier_apply_resource_control` geklammert und als **Label** an
  `cc_organ_.set_runtime_thread_count(...)` durchgereicht (`abi_adapter.hpp:260-261`), aber **NIE konsumiert**:
  `runtime_thread_count()` hat **repo-weit null wirkende Aufrufer** (verifiziert: der einzige Treffer ist der
  Doc-Kommentar `abi_adapter.hpp:255` selbst). Der Setter zählt **nie** als `applied` (:254-259). Echter
  Threading-Konsum ist als **deferred Fix A (#221-Rest)** ausgewiesen (:258-259).

**Fazit SearchAlgorithm:** Getrieben ja (Pfad A ns + Pfad B Observer, im Zwei-Phasen-Loop unter Last), aber nur
die „billigen" Zähler (acquire/release/pattern_id) + die reine Primitiv-CPU-Zeit sind echt. Die eigentlich
achsen-charakterisierenden Messwerte (Contention, Validation-Failures, Multicore-Durchsatz-vs-Contention;
Min/Max-Semantik lt. `axis_08_concurrency_observable.hpp:80-81`) sind **mangels nebenläufigem Treiber
strukturell 0**. Zudem hält nur der ABI-Adapter das Organ — die reine `SearchAlgorithmAnatomy` (die die
anderen 9 Achsen als Organe hält) tut es **nicht**.

---

## 2. Container-Gattung (Adapter/Set/Sequence/View)

Ebene-1-Außen-Interface „Container" = die 4 Tier-Unterklassen (`anatomy/container_framework.hpp:37-45`,
`type_count == 4` :77). Jede behält ihren eigenen Achsen-Satz (Adapter 13 / Set 15 / Sequence 11 / View 7,
:85-88). **`SearchAlgorithm` ist explizit KEIN Container-Typ** (:82-83).

Terminologie-Hinweis: Die im Auftrag genannten Namen *ContainerComposition, ContainerDock,
container_abi_adapter, Q1/Q2* sind **Architektur-Doku-Begriffe**; im Code heißen sie **pro Tier-Unterklasse**:
Kompositionen `{Set,Sequence,Adapter}Composition` + `AdapterComposition` (in `anatomy/*`), Docks
`builder/pruef_dock/{set,sequence,adapter,view}_dock.hpp`, ABI-Adapter
`anatomy/{set,adapter,sequence,view}_abi_adapter.hpp`. **„Q1/Q2" (queuing) sind SearchAlgorithm-Achsen**
(Doc 30 §8.0) und existieren in **keiner** Container-Komposition (verifiziert: kein `queuing`-Alias in
set/sequence/adapter-Komposition).

### 2.1 Gibt es überhaupt einen Locking-Slot?
| Genus | Locking-Slot | Beleg |
|---|---|---|
| **Set** | JA (Deskriptor) | `anatomy/set_composition.hpp:26` `using concurrency = T7; // axis_08` (+ Concept :50) |
| **Sequence** | JA (Deskriptor) | `anatomy/sequence_composition.hpp:38` `using concurrency = T3; // axis_08` (+ Concept :58) |
| **Adapter** | JA (Deskriptor, „delegated") | `anatomy/adapter_anatomy.hpp:122` `using concurrency = T5; // axis_08 (delegated)` (+ Concept :144) |
| **View** | **NEIN** | `anatomy/view_composition.hpp:5` + `:61`: „non-owning → KEIN allocator/concurrency/insert" |

### 2.2 Wird der Slot getrieben/gemessen? — NEIN, reiner Deskriptor
- **Set:** `SetAnatomy` (`anatomy/set_anatomy.hpp`) hält **nur** `set_organ_t organ_{}` (= `Composition::search_algo`,
  :83). **Kein Concurrency-Organ.** `observe_all()` → `SetObserverSnapshot` (:21-29: insert/contains/
  hit/miss/erase/size/peak) — keine acquire/contention-Felder. `SetAbiAdapter::tier_observe_set` meldet
  `observable_axis_count = 1` (`anatomy/set_abi_adapter.hpp:77`, Kommentar „real getrieben = search_algo-Kern-Organ").
- **Sequence:** `SequenceAnatomy` (`anatomy/sequence_anatomy.hpp:69-73`) hält nur `data_/growth_/capacity_`.
  Treibt real die **growth_policy**-Achse (`growth_events`, :46), **nicht** concurrency. `observe_all()` →
  `SequenceObserverSnapshot` (:18-25: push/at/oob/size/growth_events).
- **Adapter:** `AdapterAnatomy` (`anatomy/adapter_anatomy.hpp:147-149`) hält nur `inner_/obs_`. Treibt nur die
  **inner_container**-Achse. `observe_all()` → `AdapterObserverSnapshot` (:102-110: push/pop/front/back/
  occupancy). `concurrency` ist in der Komposition ausdrücklich als **„(delegated)"** markiert (:122).
- **View:** trägt den Slot gar nicht (non-owning/immutable, per Design kein Locking).
- **Kein** container-seitiges `cc_organ_`: Grep nach `concurrency|lock|acquire|release` in
  `set_/adapter_/sequence_/view_abi_adapter.hpp` = **keine** Treffer (außer Datei-Kopf-Kommentar).
- **Kein** Dock treibt concurrency: Grep in `set_/sequence_/adapter_/view_dock.hpp` = **null** Treffer.

**Fazit Container:** In **allen vier** Genus ist der Locking-Slot — wo überhaupt vorhanden (Set/Sequence/
Adapter) — ein **reiner Typ-Deskriptor** (Kompositions-Identität): nie instanziiert, nie getrieben, nie via
Observer gemessen. View trägt ihn per Design nicht. Anders als beim SearchAlgorithm-ABI-Adapter existiert auf
der Container-Seite **kein Mess-Organ und kein Hot-Path-Antrieb** für axis_08.

---

## 3. Was hieße „echt verwendet" (Hot-Path unter Last, messbar via Observer) je Gattung?

### SearchAlgorithm
Das Organ wird bereits gehalten (ABI-Adapter `cc_organ_`) und im Zwei-Phasen-Loop getrieben — aber „echt
verwendet" im Sinne der **achsen-definierenden Semantik** verlangt einen **nebenläufigen (Multi-Thread-)
Treiber**, damit `contention_count`, `validation_failure_count` und die Min/Max-Kurve
„Multicore-Durchsatz vs. Contention" (`axis_08_concurrency_observable.hpp:80-81`) **≠ 0** werden. Heute
deferred (Fix A / #221-Rest). Zusätzlich für Anatomie-Ehrlichkeit: `concurrency` müsste das N-te *in der
`SearchAlgorithmAnatomy` gehaltene* Organ werden (analog den bereits 9 gehaltenen Achsen), statt nur im
ABI-Adapter zu leben — sonst liefert `observe_all()` der reinen Anatomie weiter `EmptyAxisSnapshot`.

### Container (Set/Sequence/Adapter — die *besitzenden* Genus)
„Echt verwendet" hieße: die mutierende Gattungs-Op jeder besitzenden Container-Anatomie
(`SetAnatomy::insert/erase`, `SequenceAnatomy::push_back`, `AdapterAnatomy::push/pop`) müsste die
`Composition::concurrency`-Bahn (acquire→Critical-Section→release) real umklammern **und** ein
`ObservableConcurrency<Composition::concurrency>`-Organ halten, dessen `statistics()` in den jeweiligen
Gattungs-Observer-Snapshot (`SetObserverSnapshotV1`/`SequenceObserverSnapshotV1`/`AdapterObserverSnapshotV1`)
einfließt — exakt das Muster, das der SearchAlgorithm-ABI-Adapter mit `cc_organ_`/`observe_critical_section`
bereits vormacht. Dieser Pfad ist heute **vollständig abwesend** (Slot = Metadaten).

### Container (View — nicht-besitzend)
View ist non-owning/immutable; „read-only"-Locking ist per Design N/A. „Echt verwendet" ist hier **nicht**
sinnvoll erzwingbar — der fehlende Slot ist korrekt, kein Defizit.

---

## 4. Ehrlichkeits-/Doktrin-Anmerkung
Der **Ist-Zustand ist ehrlich, kein Phantom**: der Container-Concurrency-Slot ist wahrhaftig als Deskriptor
deklariert (nicht als getriebenes Organ getarnt), und die SearchAlgorithm-`contention_count = 0` ist explizit
als Einzel-Thread-Ehrlichkeit dokumentiert. Die **Lücke** gegenüber dem S-7-Ziel „alle Gattungen ermitteln
ihre wichtigen Observer-Messwerte echt" ist:
1. SearchAlgorithm: Contention/Validation/Thread-Skalierung strukturell 0 (kein nebenläufiger Treiber; Organ
   nur im ABI-Adapter, nicht in der Anatomie).
2. Container (Set/Sequence/Adapter): Locking-Slot ist reiner Deskriptor — kein Organ, kein Antrieb, kein
   Observer.
3. Upgradeable-Locking-Modus im Vokabular ohne Organ (nur ReaderWriter-SHARED-Bahn realisiert).

---

### Beleg-Register (Datei:Zeile)
- Organ-Registry (9 Strategien): `axes/concurrency_axis/axis_08_concurrency_registry.hpp:23-25`
- Upgradeable im Vokabular ohne Organ: `topics/concurrency/concepts/topic_concurrency_concept.hpp:10`;
  ReaderWriter nur SHARED: `axes/concurrency_axis/axis_08_concurrency_reader_writer.hpp:40-42`
- SA AdHoc-Slot: `anatomy/composition_factory.hpp:60`
- SA Anatomie hält concurrency NICHT: `anatomy/search_algorithm_anatomy.hpp:62-106` + `:177-200`
- ObserverAggregate-Slot (leer bleibend): `anatomy/observer_aggregate.hpp:103`, `:128`
- SA ABI-Organ `cc_organ_`: `anatomy/abi_adapter.hpp:2161`
- ObservableConcurrency-Hülle: `axes/concurrency_axis/axis_08_concurrency_observable.hpp:52-136`
  (Contention/Validation ehrlich 0: :15-19, :40-41; Min/Max-Semantik: :80-81)
- Pfad A (T8-Segment ns, einzel-thread): `anatomy/abi_adapter.hpp:770-787`
- Pfad B (Kopplung insert/lookup): `anatomy/abi_adapter.hpp:963`, `:1019-1020`; Observer-Fill: `:1280-1288`
- thread_count inert / runtime_thread_count() null Aufrufer: `anatomy/abi_adapter.hpp:254-262`
- Zwei-Phasen-Loop: `builder/anatomy_commands/tier_observe_trace_abi.hpp:198 ff` (Phasen :114/:117)
- Container Ebene-1 (4 Typen, SA≠Container): `anatomy/container_framework.hpp:37-45`, `:77`, `:82-83`
- Set-Slot Deskriptor: `anatomy/set_composition.hpp:26`; Set-Anatomie ohne Organ: `anatomy/set_anatomy.hpp:78-85`;
  observable_axis_count=1: `anatomy/set_abi_adapter.hpp:77`
- Sequence-Slot Deskriptor: `anatomy/sequence_composition.hpp:38`; Anatomie ohne Organ: `anatomy/sequence_anatomy.hpp:67-73`
- Adapter-Slot „(delegated)": `anatomy/adapter_anatomy.hpp:122`; Anatomie ohne Organ: `:147-149`; Observer: `:102-110`
- View ohne Slot: `anatomy/view_composition.hpp:5`, `:61`
