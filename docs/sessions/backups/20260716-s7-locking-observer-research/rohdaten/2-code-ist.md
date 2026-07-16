# STRANG 2 — Code-IST der Locking-/Concurrency-Achse (axis_08) für Auftrag S-7

Datum: 2026-07-16 · Erhebung: read-only, jede Aussage datei:zeile-belegt · Kontext: S-7 (deep research +
Gattungs-Verwendung + Observer-Echtheit) · Delta-Matrix Dossier 23 fand „Upgradeable-Locking ohne Organ".

**Pfad-Wurzeln** (alle relativen Pfade unten):
- `CE` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/`
- `PRT` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-prt-art/`

---

## 0. Kernbefund vorab (die S-7-Lücke präzise)

Es gibt **zwei unabhängige Locking-/Concurrency-Artefakte** im Bestand, die NICHT verbunden sind:

1. **LEBENDE Achse `axis_08_concurrency`** — CRTP+Concept, 9 Organe, echt gemessen (ObservableConcurrency),
   im Registry-XML und in den SearchAlgorithm-Kompositionen verdrahtet. **Enthält KEIN Upgradeable-Organ.**
2. **TOTER Entwurf `locking_mode.hpp`** (Sub-Achse 8.2) — vtable-Interface `ILockingMode` + Enum `LockingMode`
   mit `Upgradeable = 2`, **0 Include-Konsumenten** (F4-Dossier B, §2/§7). Genau HIER lebt „Upgradeable" — als
   totes Enum, ohne Organ, ohne Codepfad, gegen die CRTP-Doktrin (vtable).

**S-7-Lücke = zwei Teile:**
- **(A) Upgradeable-Organ fehlt:** Die 9 Organe der lebenden Achse decken None/Blocking/ReaderWriter/OLC/
  LockFree/WaitFree/RCU/HazardPtr/OLC-ReservedBlocks — aber KEIN Upgradeable-Lock (shared→exclusive-Upgrade,
  `boost::upgrade_mutex` / `std::shared_mutex`+Upgrade-Protokoll). ReaderWriter ist NUR shared-read
  (`lock_shared`/`unlock_shared`, CE `axis_08_concurrency_reader_writer.hpp:40-42`) — kein Upgrade-Pfad.
- **(B) Container-Gattung misst Concurrency nicht echt:** Die Achse ist in den Container-Gattungs-Traits
  (Adapter/Set/Sequence) als Slot deklariert und als Typ delegiert (`adapter_anatomy.hpp:122`), aber KEINE
  ObservableConcurrency-Treiber-Kopplung auf dem Container-Pfad — der Concurrency-Observer wird derzeit
  ausschließlich auf dem SearchAlgorithm-Pfad (`abi_adapter.hpp`) echt getrieben/ausgelesen.

---

## 1. Topologie: zwei Header-Bäume — axes/ (physisch) vs. topics/ (Forwarder)

Die Achse existiert an zwei Orten, die aber KEINE Parallelstruktur sind:

| Baum | Pfad | Namespace | Rolle |
|------|------|-----------|-------|
| **axes/** (kanonisch) | `CE libs/cache_engine/axes/concurrency_axis/` | `comdare::cache_engine::concurrency_axis` | ECHTER physischer Namespace (belegt `axis_centric_namespaces.hpp:78`: „concurrency_axis = ECHTER physischer Namespace, KEIN Alias/Forwarder") |
| **topics/** (Forwarder) | `CE libs/cache_engine/topics/concurrency/axis_08_concurrency/` | `comdare::cache_engine::concurrency::axis_08_concurrency` | dünner Re-Export: `#include <axes/concurrency_axis/…>` + `using namespace …concurrency_axis;` (verifiziert: `topics/.../axis_08_concurrency_olc.hpp` = 5 Zeilen Forwarder) |

Konsequenz: Die **Kompositionen** binden über den topics-Namespace (`art_reference.hpp:23,80`:
`using concurrency = concurrency::axis_08_concurrency::OlcOptimisticConcurrency;`), das **Registry-XML** und die
**abi_adapter-Observer-Hülle** über den axes-Namespace (`concurrency_axis::ObservableConcurrency<…>`). Beide
zeigen auf denselben physischen Typ (Forwarder). Kein Datendrift.

---

## 2. Die 9 Organe der lebenden Achse (Registry `axis_08_concurrency_registry.hpp:23-25`)

`AllStrategies = mp_list<…>` (boost::mp11), gefiltert auf `T::enabled` → `EnabledStrategies`
(compile-time, `static_assert(mp_size > 0)`). Alle 9 Organe erben `ConcurrencyStrategyBase<Derived>`
(CRTP, `axis_08_concurrency_strategy_base.hpp:11-19`) mit dreifachem `static_assert` (ConcurrencyStrategy +
CacheEnginePermutationStrategy + AxisBaseConcept) — **compile-time-only, keine vtable**.

| # | Organ-Klasse | `name()` | Pattern-Enum | `family_id` | flag_suffix / Compile-Flag | Primitiv (acquire/release) |
|---|--------------|----------|--------------|-------------|----------------------------|----------------------------|
| 1 | `NoneConcurrency` | `concurrency_none` | None | (0) | NONE / `USE_NONE` | no-op |
| 2 | `BlockingConcurrency` | `concurrency_blocking` | Blocking | — | BLOCKING / `USE_BLOCKING` | `std::mutex` lock/unlock |
| 3 | `ReaderWriterConcurrency` | `concurrency_reader_writer` | ReaderWriter | 3 | READER_WRITER / `USE_READER_WRITER` | `std::shared_mutex` `lock_shared`/`unlock_shared` (NUR shared, **kein Upgrade**) |
| 4 | `OlcOptimisticConcurrency` | `olc_optimistic` | Optimistic | 4 | OPTIMISTIC / `USE_OPTIMISTIC` | atomic version-load(acq) + re-read/validate (Leis DaMoN'16) |
| 5 | `LockFreeConcurrency` | `concurrency_lock_free` | LockFree | — | LOCK_FREE / `USE_LOCK_FREE` | CAS-Schleife |
| 6 | `WaitFreeConcurrency` | `concurrency_wait_free` | WaitFree | — | WAIT_FREE / `USE_WAIT_FREE` | wait-free fetch-op |
| 7 | `RcuConcurrency` | `concurrency_rcu` | RCU | — | RCU / `USE_RCU` | RCU read-side |
| 8 | `HazardPointerConcurrency` | `concurrency_hazard_ptr` | HazardPtr | — | HAZARD_PTR / `USE_HAZARD_PTR` | Hazard-Pointer publish/scan |
| 9 | `OlcReservedBlocksConcurrency` | `olc_reserved_blocks` | Optimistic | 9 | OLC_RESERVED_BLOCKS / `USE_OLC_RESERVED_BLOCKS` | version-load(acq) + `fetch_add` block-id (anti-coherence-storm; vendored aus prt-art) |

**Compile-time-Gating**: `axis_08_concurrency_flags.hpp.in` — CMake-generiert, 9× `#cmakedefine01
COMDARE_AXIS_08_USE_*` + 9 `inline constexpr bool *_enabled`. **Kein `USE_UPGRADEABLE`-Flag vorhanden.**

**Pattern-Enum** (`concepts/axis_08_concurrency_concept.hpp:9-18`): `ConcurrencyPattern { None=0, Blocking,
ReaderWriter, Optimistic, LockFree, WaitFree, RCU, HazardPtr }` — **8 Patterns, KEIN „Upgradeable"**. Organ 9
(ReservedBlocks) mappt ebenfalls auf `Optimistic` (`axis_08_concurrency_olc_reserved_blocks.hpp:33`) → 9 Organe
auf 8 Patterns.

---

## 3. Concept `ConcurrencyStrategy` (die Gattungs-Schranke)

`concepts/axis_08_concurrency_concept.hpp:20-24`:
```
template <typename C>
concept ConcurrencyStrategy = ConcurrencyComponent<C> && requires {
    { C::concurrency_pattern() } noexcept -> std::convertible_to<ConcurrencyPattern>;
};
```
- `ConcurrencyComponent<C>` (`topics/concurrency/concepts/topic_concurrency_concept.hpp:19-20`): verlangt
  `typename C::topic_tag == ConcurrencyTopicTag`.
- Der Topic-Marker-Kommentar `topic_concurrency_concept.hpp:8-10` nennt die Sub-Achsen ausdrücklich:
  „axis_08_concurrency (Sub 8.1 Pattern, **8.2 Locking-Mode**, 8.3 Coherence)" mit Locking-Mode-Werten
  „read-only, read-write, **upgradeable**, optimistic-validation". → Upgradeable ist in der Konzept-Doku
  vorgesehen, aber im Concept selbst NICHT als Pflicht-API modelliert (das Concept prüft nur
  `concurrency_pattern()`).
- Zweiter Concept (Permutation): `CacheEnginePermutationStrategy` (jedes Organ hat zusätzlich
  `static_assert(CacheEnginePermutationStrategy<…>)`, z. B. `axis_08_concurrency_olc.hpp:70`).

---

## 4. Observer-Echtheit — ObservableConcurrency (Säule-2 Per-Achsen-Mess-Mechanik)

Datei `axes/concurrency_axis/axis_08_concurrency_observable.hpp` (138 Z.). Kernpunkte:

- **POD** `ConcurrencyStatistics` (:37-45): 5× `uint64` → `acquire_count`, `release_count`, `contention_count`,
  `validation_failure_count`, `pattern_id`. `static_assert(standard_layout && trivially_copyable)` (:47-48) →
  mappbar in den Cross-ABI-Observer-POD `axis_stats[8][…]`.
- **Hülle** `ObservableConcurrency<Strategy>` (:52-136), `requires ConcurrencyStrategy<Strategy>`. Treibt das
  ECHTE statische Primitiv der Strategie:
  - `acquire()` (:91-106): `Strategy::try_acquire()`→sonst `Strategy::acquire()`; unter
    `COMDARE_CE_ENABLE_STATISTICS`: `++acquire_count`, bei Fehlschlag `try_acquire` → `++contention_count`,
    `pattern_id = concurrency_pattern()`.
  - `release()` (:109-114): `Strategy::release()` + `++release_count`.
  - `observe_critical_section()` (:118-121): ein acquire→release-Paar (Komfort-Driver).
- **Ehrlichkeits-Kommentar (:14-19)**: `contention_count`/`validation_failure_count` bleiben im
  Single-Thread-Pfad **ehrlich 0** (CAS gelingt im 1. Versuch, OLC-Re-Read stets gültig) — „KEIN erfundener
  Wert" (honest-100%-Doktrin erfüllt).
- **Gating**: gesamte Statistik unter `#ifdef COMDARE_CE_ENABLE_STATISTICS`; bei OFF reine Delegation, 0
  Footprint, `ObservableAxis<…> = false` (Release-DLL).
- **`set_runtime_thread_count()`** (:82-87): Observer-Strategy-Setter (Min/Max-Semantik Durchsatz↔Contention),
  clamped auf ≤64. **Ehrlich als Label deklariert**: `abi_adapter.hpp:254-257` — „zählt NIE als applied", nur
  durchgereichtes Label, kein gemessener Wert.

### Verdrahtung im Treiber (SearchAlgorithm-Pfad, `anatomy/abi_adapter.hpp`)
- Member: `mutable concurrency_axis::ObservableConcurrency<typename Composition::concurrency> cc_organ_{};`
  (:2161-2162).
- Getrieben pro Op: `cc_organ_.observe_critical_section()` in `tier_insert`/`tier_lookup` (:963, :1020, :1587).
- Ausgelesen: `if constexpr (ObservableAxis<decltype(cc_organ_)>)` → `axis_stats[8]`: `r[0]=acquire_count`,
  `r[1]=release_count`, `r[2]=contention_count`, `r[3]=validation_failure_count`, `r[4]=pattern_id`
  (:1280-1288). → **Auf dem SearchAlgorithm-Pfad wird der Concurrency-Observer echt ermittelt.**

---

## 5. Registry-XML (golden-320-Verdrahtung) — `CE libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml`

Zeile 53: `<axis id="concurrency" slot="T08" category="composition" genus="SearchAlgorithm" baustein_count="9">`
→ **genus = ausschließlich „SearchAlgorithm"** (ALLE 19 Achsen T00-T18 tragen `genus="SearchAlgorithm"`; es
gibt im XML KEINE `genus="Container"`-Zeile).

9 `<baustein>`-Einträge (:54-62), Namen = die 9 Organe. **golden_wired-Flag:**

| baustein | wrapper | golden_wired |
|----------|---------|--------------|
| `concurrency_none` | NoneConcurrency | **true** |
| `concurrency_blocking` | BlockingConcurrency | false |
| `concurrency_reader_writer` | ReaderWriterConcurrency | false |
| `olc_optimistic` | OlcOptimisticConcurrency | false |
| `concurrency_lock_free` | LockFreeConcurrency | false |
| `concurrency_wait_free` | WaitFreeConcurrency | false |
| `concurrency_rcu` | RcuConcurrency | false |
| `concurrency_hazard_ptr` | HazardPointerConcurrency | false |
| `olc_reserved_blocks` | OlcReservedBlocksConcurrency | false |

→ **Nur 1 von 9 Organen ist golden-verdrahtet (None).** Kein `upgradeable`-Baustein. Alle Header-Pfade
verweisen auf `axes/concurrency_axis/…`, alle Typen auf `::comdare::cache_engine::concurrency_axis::…`.

---

## 6. golden-320-Status der Achse — **GEPINNT auf None (NICHT variiert)**

- `tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt`: 320 IDs, „FullSourceCatalog (4*4*5*4) …
  EINGEFROREN" (:1-2). **Jede** der 320 Zeilen trägt `…/concurrency=concurrency_none/…` (grep bestätigt: 320
  Treffer). Variiert werden 4 Achsen (4·4·5·4); Concurrency gehört NICHT dazu → in allen 320 Binaries auf
  `concurrency_none` fixiert.
- `tests/unit/thesis_tiere/experiment_golden.xml`: `<axes_default_lookup>` variiert nur `isa`, `search_algo`,
  `path_compression` (:62-64); Concurrency wird nicht genannt und nicht gemessen (0 Treffer im XML).
- Konsequenz für Observer: Im golden-Lauf liefert `axis_stats[8]` zwar echte `acquire_count`/`release_count`
  (die None-Hülle zählt die getriebenen no-op-Paare), aber **strategie-distinkte** Werte (pattern_id≠0,
  contention, OLC-validation) werden mangels Variation NICHT exerziert. Die „wichtigen Observer-Messwerte je
  Strategie" (S-7) sind im golden-Lauf also nur für None real.

---

## 7. Gattungs-Verwendung — SearchAlgorithm (echt) vs. Container (deklariert, nicht gemessen)

### 7.1 SearchAlgorithm-Gattung (Suchalgorithmen) — ECHT verwendet + gemessen
- Kompositionen binden ein Concurrency-Organ als `using concurrency = …`:
  - `art_reference.hpp:80`, `prt_art_reference.hpp:70`: `OlcOptimisticConcurrency`.
  - weitere: `surf_reference`, `wormhole_reference`, `hot_reference`, `masstree_reference`, `start_reference`
    (grep: 15 Kompositions-Header referenzieren die Achse).
- `SearchAlgorithmAnatomy` → `abi_adapter` treibt `cc_organ_` echt (§4) → Observer in `axis_stats[8]` real.
- `GenusBindingTraits<SearchAlgorithm>` = „der VERIFIZIERTE Spezialfall" (`genus_binding_traits.hpp:34-46`),
  19-Slot-Komposition inkl. „concurrency".

### 7.2 Container-Gattung — Achse DEKLARIERT, aber Observer NICHT echt getrieben
- `genus_binding_traits.hpp` bindet 5 Gattungen; die Container-Tier-Unterklassen führen „concurrency" im
  Slot-Namensvektor:
  - `Adapter` (Gattung=Container, `genus_binding_traits.hpp:60-77`): 13 Achsen inkl. `"concurrency"` (:76).
  - `Set` (:86-101): inkl. `"concurrency"` (:101).
  - `Sequence` (:111-125): inkl. `"concurrency"` (:125).
- `adapter_anatomy.hpp:122`: `using concurrency = T5; // axis_08 (delegated)` + `requires { typename
  C::concurrency; }` (:144) → Container-Komposition trägt den Concurrency-TYP, aber es gibt **keine
  ObservableConcurrency-Kopplung** in der Adapter-Anatomie (grep: 0 `ObservableConcurrency` in
  `adapter_anatomy.hpp`).
- `builder/experiment_tree/container_attribution.hpp:2-14,42-49`: Die aktuelle „Container-in-SearchAlgorithm"-
  Attribution ist rein HOST-seitig — sie re-labelt den bestehenden SA-Observer-POD (`axis_stats[0][0]+[0][3]+
  [0][4]`), erklärt ausdrücklich „KEINE neue DLL-Messung, KEIN ContainerObserver-Kategorie-Eintrag (… bleibt
  der ECHTEN Container-Gattung Variante b reserviert)". → **Die echte Container-Gattung misst ihre
  Concurrency-Observer noch nicht selbst.**

---

## 8. prt-art OLC (CXX-02-Fix, OLC-Versionierung) + Vendoring-Kette

### 8.1 prt-art-Quelle: `PRT prt_art/include/prt_art/concurrency/olc_with_reserved_blocks.hpp` (103 Z.)
Klasse `comdare::prt_art::concurrency::OlcWithReservedValueBlocks`:
- Versions-Vertrag: `Version = uint64`, `kWriteMarker=1` (niedrigstes Bit = write-in-progress),
  `kIncrementStep=2` → **Odd/Even-Paritäts-Invariante** (ungerade = Writer aktiv).
- `read_version()` (acquire), `validate(captured)` (:32-35) = OLC-Reader (re-read + kein-write-in-progress).
- **CXX-02-Fix (`:38-57`, wörtlich „REV-CXX-02, WP-5 2026-07-16")**: `begin_write()` nutzt jetzt eine
  **CAS-Schleife** (`compare_exchange_weak` gerade→ungerade + spin/`yield` bei aktivem Writer) statt des
  früheren blinden `fetch_add`. Bug vorher: zwei gleichzeitige `fetch_add`-Writer kippten die Version von
  ungerade zurück auf gerade → optimistischer Leser sah scheinbar „kein Write" und akzeptierte inkonsistente
  Daten (Odd/Even-Vertrag verletzt). Fix garantiert: solange IRGENDEIN Writer aktiv → Version ungerade;
  zweiter Writer wartet.
- `end_write()` (:59-62): `fetch_add(kIncrementStep - kWriteMarker)` → +2 & Marker löschen (monoton, +2/Write).
- `reserve_value_block()` (:65-67): `next_block_id_.fetch_add(1)` → exklusiver cache-line-Block je Writer
  (anti-coherence-storm). RAII `WriteGuard` (:84-100).
- Test: `PRT tests/unit/test_olc_with_reserved_blocks.cpp`.

### 8.2 CE-Organ 9 (Vendoring): `axis_08_concurrency_olc_reserved_blocks.hpp`
- Kommentar (:2-8): „F.6 Migration (Doku 19): prt-art OlcWithReservedValueBlocks als 9. Concurrency-STRATEGIE …
  Die konkrete atomare Laufzeit-Impl (version_ + next_block_id_ + WriteGuard) bleibt prt-art-Detail
  (optional_prt_art_impl)."
- **ABER**: Das CE-Organ vendored die prt-art-Klasse NICHT direkt — `acquire()`/`release()` (:49-58)
  **reimplementieren** einen vereinfachten Single-Thread-Pfad (thread_local `version_`/`next_block_id_`,
  `fetch_add` block-id, re-read-validate). D. h. der messbare CE-Pfad ist eine leichte Nachbildung, nicht der
  echte CXX-02-CAS-Schleifen-Writer der prt-art-Quelle. (Vendoring-Doktrin vendor→faithful→self-contained:
  hier „self-contained-Nachbildung", nicht „faithful"-Direktnutzung.)
- prt-art-Registry `PRT prt_art/algorithm_profiles/prt_art_axis_registry.xml`: **kein** concurrency/olc/
  locking-Eintrag (grep 0 Treffer) — die Concurrency-Achse ist rein CE-seitig registriert.

---

## 9. locking_mode.hpp-Entwurf (Sub-Achse 8.2) — der Ort des Upgradeable-Enums

`CE libs/cache_engine/include/cache_engine/concepts/locking_mode.hpp` (38 Z., Marker `V32.EE.5 2026-05-18`,
`@achse 8.2`, `@reuse_status (b)`):
```
enum class LockingMode : std::uint8_t {
    ReadOnly             = 0, // std::shared_mutex shared
    ReadWrite            = 1, // std::mutex exclusive
    Upgradeable          = 2, // boost::shared_mutex upgrade   ← der S-7-Kern
    OptimisticValidation = 3  // OLC, HTM
};
class ILockingMode { virtual LockingMode preferred_mode() const noexcept = 0; virtual ~ILockingMode()=default; };
```
Status (aus F4-Dossier B, `…/20260716-f4-systemachsen-dossier/rohdaten/B-header-seziert.md` §2,§5.1,§7,§8):
- **TOT**: 0 Include-Konsumenten (nur String-Literale in `AxisLibraryRegistry`).
- **vtable statt CRTP** → Doktrin-Verstoß (compile-time-only). Kein Default-Struct.
- Registry-Provenienz für Achse 8.2 nennt PHANTOM-Enumeratoren `{Optimistic, Pessimistic, LockFree, WaitFree}`
  (REGISTRY:164-168) — 4/4 existieren im Header NICHT; der Migrationsplan `docs/architecture/
  19_f6_prtart_migration_plan.md:47` zitiert dagegen die korrekten `{ReadOnly,ReadWrite,Upgradeable,
  OptimisticValidation}` für `prt_art_82_locking_default.hpp`.
- Git: geboren `7a6c563f` (18.05.), Deprecation-Banner `414ed8c2` (13.07.) nach 27 min revertiert `804aa3c2`.
- **Übernehmbarkeit für S-7**: Der Enumerator `Upgradeable = 2` („boost::shared_mutex upgrade") ist der einzige
  Bestands-Beleg des Upgradeable-Konzepts und kann als Semantik-Quelle (shared→exclusive-Upgrade) für ein neu
  zu bauendes CRTP-Organ `UpgradeableConcurrency` übernommen werden.

---

## 10. Zusammenfassung: Wo Upgradeable NICHT abgedeckt ist (S-7-Andockpunkte)

Damit ein echtes Upgradeable-Organ entsteht + in beiden Gattungen echt gemessen wird, sind folgende Stellen
IST-leer und müssten (im offiziellen Pfad, keine Parallelstruktur) angedockt werden:

| Andockpunkt (Datei) | IST | Fehlt für Upgradeable |
|---------------------|-----|-----------------------|
| `axes/concurrency_axis/axis_08_concurrency_*.hpp` | 9 Organ-Header | Organ `axis_08_concurrency_upgradeable.hpp` (CRTP, `shared_mutex`/`upgrade_mutex` shared→exclusive) |
| `axis_08_concurrency_registry.hpp:23-25` | `AllStrategies` = 9 Typen | `UpgradeableConcurrency` als 10. Typ |
| `concepts/axis_08_concurrency_concept.hpp:9-18` | `ConcurrencyPattern` 8 Werte | Pattern `Upgradeable` (oder Zuordnung ReaderWriter+Upgrade-Sub) |
| `axis_08_concurrency_flags.hpp.in` | 9 `USE_*`-Flags | `COMDARE_AXIS_08_USE_UPGRADEABLE` + `upgradeable_enabled` |
| `algorithm_profiles/cache_engine_axis_registry.xml:53-62` | `baustein_count="9"`, 9 Bausteine | 10. Baustein `upgradeable`, count→10 |
| `axis_08_concurrency_observable.hpp` | acquire/release/contention/validation | ggf. `upgrade()`-Zähler (Upgrade-Erfolg/Fehlschlag) für echten Upgradeable-Observer |
| SearchAlgorithm-Kompositionen | binden None/OLC | eine Komposition, die Upgradeable bindet (echte Verwendung) |
| Container-Gattung (`adapter_anatomy.hpp` / Adapter-Observer) | Typ delegiert, kein Observer-Treiber | ObservableConcurrency-Kopplung im Container-Pfad → echte Container-Messung |
| golden-Verdrahtung (`golden_wired`) | nur None true | Upgradeable (und übrige 8) variieren, damit Observer-Werte je Strategie real werden |
| Doktrin | `locking_mode.hpp` = tote vtable | Upgradeable-Semantik CRTP-konform aus dem toten Enum heben |

---

*Erhebungsmethode: Read von locking_mode.hpp, allen 9 Organ-Headern + strategy_base/registry/observable/
concept/flags, art_reference/prt_art_reference/adapter_anatomy/abi_adapter, genus_binding_traits/
container_attribution, cache_engine_axis_registry.xml, experiment_golden.xml, golden_fullpilot_320_binary_ids.txt,
prt-art olc_with_reserved_blocks.hpp + prt_art_axis_registry.xml; repo-weiter grep (concurrency/olc/upgrad/
genus/golden_wired); Querbeleg F4-Dossier-B. Keine Datei außer dieser Rohdaten-Datei geschrieben.*
