# S-7 UMSETZUNGS-PLAN — Upgradeable-Locking-Achse (axis_08) + Observer-Echtheit aller Gattungen

**Datum:** 2026-07-16 · **Auftrag:** USER S-7 · **Quelle:** 4 Rohdaten-Stränge (`rohdaten/1-papers.md` …
`4-observer-echtheit.md`) + Live-IST-Verifikation gegen `Code/external/comdare-cache-engine/` (development).
**Doktrin:** Vendoring `vendor→faithful→self-contained`; honest-100% (kein Phantom); compile-time-only Hot-Path
(CRTP + Concept, keine vtable, kein Runtime-Switch); nur benannte Lehrbuch-Patterns.
**TABU (nicht anfassen):** golden-320 (`golden_fullpilot_320_binary_ids.txt`, `experiment_golden.xml`),
Observer-POD `ComdareTierObserverSnapshot` sizeof==1416, ABI-Major 4, `genus_binding_traits.hpp`.

Pfad-Wurzel (alle relativen Zitate): `Code/external/comdare-cache-engine/libs/cache_engine/` (= `CE`).

---

## 0. IST-Verankerung (live verifiziert, nicht aus Rohdaten übernommen)

- **9 Organe, kein Upgradeable:** `axes/concurrency_axis/axis_08_concurrency_registry.hpp:23` `AllStrategies`
  = mp_list mit 9 Typen (None…OlcReservedBlocks). `ls axes/concurrency_axis/ | grep -i upgrad` = **leer**.
- **Pattern-Enum 8 Werte:** `axes/concurrency_axis/concepts/axis_08_concurrency_concept.hpp` — `ConcurrencyPattern
  { None=0, Blocking, ReaderWriter, Optimistic, LockFree, WaitFree, RCU, HazardPtr }`. Kein `Upgradeable`.
- **ReaderWriter = nur SHARED-Bahn:** `axis_08_concurrency_reader_writer.hpp:44-46` `lock_shared`/`unlock_shared`
  — kein Upgrade-Pfad.
- **CRTP-Muster:** jedes Organ `: public ConcurrencyStrategyBase<Derived>` (strategy_base.hpp:11), 3× static_assert
  (`ConcurrencyStrategy` + `CacheEnginePermutationStrategy` + `AxisBaseConcept`) → compile-time-only, keine vtable.
- **Observer-POD frei ab r[5]:** `anatomy/observable_tier.hpp:84` — T8-Schema
  `{"acquire","release","contention","validation_fail","pattern_id", nullptr, nullptr, nullptr}` →
  **r[5]/r[6]/r[7] frei.** `kV3FieldCount=8` (:50), `axis_stats[19][8]` (:131). **Layout-Präzedenz** (:73):
  „slot[6] war reserviert (nullptr) → layout-neutral benannt; sizeof bleibt 1416".
- **TABU-Gate existiert real:** `tests/unit/test_ap13_thread_pinning.cpp:107` u. a. ≥10 Tests:
  `EXPECT_EQ(sizeof(ComdareTierObserverSnapshot), 1416u)`. + static_assert standard_layout/trivially_copyable
  (`observable_tier.hpp:148-151`).
- **golden gepinnt:** Registry-XML `algorithm_profiles/cache_engine_axis_registry.xml:53` `genus="SearchAlgorithm"
  baustein_count="9"`, nur `concurrency_none golden_wired="true"`, restliche 8 `false`. Alle 320 IDs tragen
  `concurrency=concurrency_none`; `experiment_golden.xml` variiert nur isa/search_algo/path_compression.
- **CMake-Flags:** `CMakeLists.txt:332-340` 9× `option(COMDARE_AXIS_08_ENABLE_* … ON)`; :1123 foreach → `USE_*`;
  :1130 `configure_file(axis_08_concurrency_flags.hpp.in …)`.
- **Container-PODs ohne Reserve:** `set_tier.hpp:17` / `sequence_tier.hpp:12` / `adapter_tier.hpp:26` /
  `view_tier.hpp:12` — jedes Feld benannt+belegt, **kein Reserve-Slot** → jede Container-Concurrency-Messung
  ist ein per-Genus-POD-Bruch (Versions-Bump) = Fork.
- **ext/-Vendoring-Konvention:** `ext/CMakeLists.txt` „Pro Paper-Verzeichnis wird der ORIGINALCODE EXAKT KOPIERT
  eingebettet"; Präzedenz `ext/allocator/A03-michael-lockfree/` (README mit Provenienz+Lizenz + Sources).

---

## 1. Paper-/Code-Vendoring-Auswahl

### 1.1 Empfehlung (2 Vendor-Kandidaten + 1 Faithful-Reimpl-Kern + 1 Feature-Quelle)

| Rolle | Kandidat | Paper | Lizenz (API-verifiziert) | Verwendung |
|-------|----------|-------|--------------------------|------------|
| **PRIMÄR Achsen-Kern** | **K4 OptiQL** `sfu-dis/optiql` | Shi/Yan/Wang, PACMMOD 2023, DOI 10.1145/3617336 | **KEINE (null)** → **FAITHFUL-REIMPL aus Paper** | upgradeable + optimistic + Contention-robust; an B+Tree UND ART evaluiert = beide Gattungen |
| **VENDOR Suchbaum** | **K1** `flode/ARTSynchronized` | Leis DaMoN'16 (OLC+ROWEX) | **Apache-2.0** | `OptimisticLock`-Klasse + `Epoche` (EBR) als gattungsagnostische Primitive; ART-Bahn |
| **FEATURE-QUELLE Upgrade-State** | **K5** `npgall/concurrent-locks` | Update-Lock / SIX-State-Machine | **Apache-2.0** (Java) | klarste Read/**Update**/Write-Zustandsmaschine; in C++ nachbauen (Direktive: andere Sprachen = Feature-Quellen) |
| optional Reclamation | K3 `rmind/libqsbr` | Fraser 2004 / EBR | **BSD-2** (C) | EBR/QSBR falls Multi-Thread-Treiber echte Reclamation braucht |

**Begründung Primär K4:** OptiQL ist der einzige SOTA-Treffer, der *upgradeable* + *optimistic* + *Contention-
Robustheit* in EINEM 8-Byte-MCS-Queue-Lock vereint und an beiden geforderten Gattungen (B+Tree, ART) evaluiert
wurde. Es ist damit der einzige Kandidat, der die S-7-Achse gattungs-übergreifend inhaltlich trägt.
**ABER Lizenz=null** → Code **nicht faithful vendorbar** (all-rights-reserved). Weg = publizierten Algorithmus
aus dem PACMMOD-Paper reimplementieren (erlaubt; Code nur als Referenz lesen). Dieselbe Lizenz-Sperre gilt für
`wangziqi2016/index-microbench` (BTreeOLC) — deshalb **nicht** genutzt.

**Begründung Vendor K1:** liefert die eine sauber lizenzierte (Apache-2.0), in C++ vorliegende OLC/EBR-Basis; ihre
`OptimisticLockCoupling`-Klasse ist praktisch das Seqlock-Versionswort, das das CE-Organ 4 (`OlcOptimistic`)
bereits konzeptuell nachbildet → als `ext/`-Referenz für den faithful Upgrade-Aufsatz.

**Begründung Feature-Quelle K5:** die deadlock-freie Read→**Update**→Write-Zustandsmaschine (dritter Zustand
„Update": shared ggü. Readern, exklusiv ggü. Updatern, upgradeable-to-write) ist die exakte Semantik, die dem
toten `LockingMode::Upgradeable=2` fehlt. Java → nur Feature-Quelle, in C++ neu.

### 1.2 Vendoring-Schritte (`vendor → faithful → self-contained`)

1. **vendor (read-only in `ext/`):**
   - `ext/concurrency/axis_08_concurrency/paper_optiql/` — OptiQL: **nur Paper-PDF + Algorithmus-Notizen** ablegen
     (Code NICHT kopieren, Lizenz=null); `README` mit DOI 10.1145/3617336, Lizenz-Befund „null → reimpl-only".
   - `ext/concurrency/axis_08_concurrency/paper_p08_artsync/` — `flode/ARTSynchronized` **exakt kopiert**
     (`OptimisticLockCoupling/`, `Epoche.{h,cpp}`), **LICENSE (Apache-2.0) mitkopiert**, `README` mit Upstream-URL
     + Commit-Hash (Provenienz-Präzedenz wie `A03-michael-lockfree/README`).
   - `ext/concurrency/axis_08_concurrency/feature_concurrent_locks/` — nur `ReentrantReadWriteUpdateLock.java`
     als **Referenz** + LICENSE (Apache-2.0); Marker „Feature-Quelle, C++-Reimpl".
   - **KEINE** `add_subdirectory` in `ext/CMakeLists.txt`, solange nichts kompiliert wird (Paper-only bleibt
     out-of-build; nur K1-Header falls direkt konsumiert → dann als INTERFACE-Target opt-in wie mimalloc-Muster).
2. **faithful:** Das neue Organ (§2) implementiert den OptiQL-Upgrade-Pfad **algorithmus-treu aus dem Paper**
   (MCS-Queue-Eintritt unter Contention + optimistischer Reader + deadlock-freies Read→Write-Upgrade). Header-
   Kommentar zitiert DOI + Zeilen-genaue Paper-Semantik (wie `axis_08_concurrency_olc.hpp:19` Leis DaMoN'16).
   Faithfulness = Semantik-Treue zum publizierten Algorithmus, NICHT verbatim-Copy (Lizenz verbietet das).
3. **self-contained:** Organ nutzt nur `<atomic>`/`<shared_mutex>` (Standard), keine externe Runtime-Dep im
   Hot-Path; EBR (K3/K1-Epoche) nur falls Multi-Thread-Treiber (§3.1) sie braucht — dann als opt-in Compile-Flag,
   golden-Build bleibt dep-frei. `PAPER_REFERENCES.md` der Achse um Zeile `UpgradeableConcurrency → OptiQL
   (PACMMOD 2023, DOI 10.1145/3617336, Code null → reimpl)` ergänzen (Habich-Pflicht).

---

## 2. Upgradeable-Locking-Organ-Design (axis_08-Erweiterung, END-Append, golden-neutral)

### 2.1 Neues Organ `UpgradeableConcurrency` (10. Organ, END-Append)

Datei: **`axes/concurrency_axis/axis_08_concurrency_upgradeable.hpp`** — 1:1 Struktur des Sibling
`axis_08_concurrency_reader_writer.hpp` (Goldstandard-Vorlage), mit:
- `class UpgradeableConcurrency : public ConcurrencyStrategyBase<UpgradeableConcurrency>` (CRTP, keine vtable).
- `using topic_tag = ConcurrencyTopicTag; using axis_tag = subaxes::synchronization_pattern_tag;
  using family_id = std::integral_constant<int, 10>;`
- `static constexpr bool enabled = flags::upgradeable_enabled;`
- `concurrency_pattern()` → **neuer Enum-Wert `Upgradeable`** (§2.3).
- `name()` = `"concurrency_upgradeable"`, `flag_suffix()` = `"UPGRADEABLE"`, `family_name()` =
  `"UpgradeableConcurrency (shared→exclusive upgrade, OptiQL-Semantik, PACMMOD 2023)"`.
- `COMDARE_DEFINE_ORGAN_LOCATION(...)` (Codegen-Lokation, wie alle Organe).
- **Treib-API (Pfad-A/B-kompatibel, wie ReaderWriter):**
  - `try_acquire()` → `try_lock_shared()` (optimistischer/geteilter Eintritt).
  - `acquire()` → `lock_shared()` (Reader/Update-Modus-Eintritt).
  - `release()` → `unlock_shared()`.
  - **NEU, achsen-definierend:** `try_upgrade()` → Versuch shared→exclusive (deadlock-frei: nur EIN Update-Halter
    darf eskalieren; scheitert er, echter Upgrade-Konflikt). `downgrade()` → exclusive→shared. Semantik-Quelle
    = OptiQL-Upgrade + K5-Update-State. Basis-Primitiv: `std::shared_mutex` + separater `std::mutex upgrade_gate_`
    (dritter Zustand „Update"), oder faithful MCS-Queue (OptiQL) hinter Compile-Flag.
- 2× `static_assert(concepts::ConcurrencyStrategy<…>)` + `CacheEnginePermutationStrategy<…>` am Dateiende.
- Topics-Forwarder `topics/concurrency/axis_08_concurrency/axis_08_concurrency_upgradeable.hpp` (4-Zeilen
  Re-Export, wie alle Sibling-Forwarder) — kein Parallelbau.

### 2.2 Registry-Andockung (additiv, END-Append)

- `axis_08_concurrency_registry.hpp`: `#include "axis_08_concurrency_upgradeable.hpp"` + `UpgradeableConcurrency`
  als **10. Typ** ans ENDE der `AllStrategies`-mp_list. `EnabledStrategies = mp_filter<is_enabled>` filtert es bei
  `enabled=false` heraus → **golden-Build sieht es nicht** (mp_size-Assert bleibt erfüllt durch die anderen ON).
- `axis_08_concurrency_flags.hpp.in`: `#cmakedefine01 COMDARE_AXIS_08_USE_UPGRADEABLE` + `inline constexpr bool
  upgradeable_enabled = COMDARE_AXIS_08_USE_UPGRADEABLE;` (ans Ende).
- `CMakeLists.txt`: `option(COMDARE_AXIS_08_ENABLE_UPGRADEABLE "…" OFF)` — **Default OFF = golden-neutral**
  (einziges Organ mit Default-OFF; die 9 Bestands-Organe bleiben ON). foreach-Liste :1123 um `UPGRADEABLE`
  erweitern, message-Zeile :1134 additiv.
- Registry-XML `cache_engine_axis_registry.xml`: 10. `<baustein name="concurrency_upgradeable"
  wrapper="UpgradeableConcurrency" … enabled="false" golden_wired="false"/>`, `baustein_count="9"→"10"`.
  **golden_wired="false" + enabled="false" ⇒ kein golden-Bruch** (keine der 320 IDs referenziert es; XML-Zeile
  ist reine Registry-Metadaten). `genus` bleibt `SearchAlgorithm` (Container-Genus = TABU, §6).

### 2.3 Concept-Konformität (Pattern-Enum)

- `axis_08_concurrency_concept.hpp`: Enum `ConcurrencyPattern` um **`Upgradeable`** erweitern — **ans ENDE**
  (`… HazardPtr, Upgradeable`), damit die numerischen Werte 0..7 der Bestands-Patterns stabil bleiben
  (`pattern_id` in axis_stats[8] r[4] behält Bedeutung; golden-None=0 unverändert). Upgradeable = 8.
- Concept `ConcurrencyStrategy` selbst braucht **keine** Änderung (prüft nur `concurrency_pattern()`); die neuen
  `try_upgrade()/downgrade()` sind organ-intern (nicht Concept-Pflicht) → kein Concept-Bruch für die 9 Bestands-
  Organe. Optionaler Sub-Concept `UpgradeableStrategy` (requires `try_upgrade`/`downgrade`) nur als static_assert
  am neuen Organ, nicht als Achsen-Schranke.

**Golden-Neutralitäts-Nachweis:** END-Append (Typ, Enum, Flag, XML-Baustein) + `enabled=false` +
`golden_wired=false` + kein Eintrag in den 320 frozen IDs + keine Änderung an `experiment_golden.xml` ⇒ die
golden-320-Komposition ist bit-identisch. Sichtbar erst in einem opt-in Nicht-golden-Experiment (§3.1/§5).

---

## 3. Echt-Verwendungs-Plan je Gattung

### 3.1 SearchAlgorithm-Gattung — Hot-Path-Konsum im Mess-Loop (KEIN TABU-Bruch, baubar jetzt)

Der Konsum-Mechanismus existiert bereits und ist wiederverwendbar:
- **Organ halten:** `abi_adapter.hpp:2161` `ObservableConcurrency<Composition::concurrency> cc_organ_` bindet
  automatisch das gewählte Organ (also auch `UpgradeableConcurrency`, sobald eine Komposition es bindet).
- **Getrieben:** `observe_critical_section()` in JEDEM `tier_insert` (:963) + `tier_lookup` (:1019-1020) im
  Zwei-Phasen-Loop (`tier_observe_trace_abi.hpp:198`) → acquire/release real exerziert.
- **Neu (Upgrade-Bahn echt treiben):** in `ObservableConcurrency` einen `observe_upgrade_section()` ergänzen
  (acquire→`try_upgrade()`→[erfolg: exclusive-Mini-CS→`downgrade()`] / [fehlschlag: `++upgrade_failure`]→release),
  der bei Strategien mit `try_upgrade()` (nur Upgradeable) in `tier_insert` (Schreib-Op = natürlicher
  Upgrade-Anlass) aufgerufen wird; für die 9 Bestands-Organe `if constexpr (requires{Strategy::try_upgrade();})`
  → no-op, **honest-0** (kein erfundener Upgrade bei Nicht-Upgradeable). So bleibt derselbe eine Store
  `container_algorithm_` der getriebene Apparat (Meta-Lehre-#3 gewahrt).
- **Komposition:** genau EINE Nicht-golden-Referenz-Komposition (z. B. `compositions/upgradeable_reference.hpp`
  analog `art_reference.hpp:80`) bindet `using concurrency = …::UpgradeableConcurrency;` — als **eigenständiges
  Tier außerhalb der 320**, damit die Achse „echt gebunden" ist ohne golden-Berührung.
- **Multi-Thread-Treiber (macht contention/validation/upgrade ≠ 0):** heute strukturell 0 (single-thread,
  `axis_08_concurrency_observable.hpp:15-19`). Ein nebenläufiger Mess-Treiber ist als **deferred Fix A / #221-Rest**
  ausgewiesen (`abi_adapter.hpp:254-262`). S-7-Beitrag: die Upgrade-Zähler (upgrade_success/upgrade_failure) sind
  **schon single-thread ≠ 0** (jede Schreib-Op eskaliert real) → die Achse liefert distinkte Werte OHNE #221;
  contention/validation bleiben ehrlich 0 bis #221 den Multi-Thread-Treiber liefert (data-gated, §4).

### 3.2 Container-Gattung — Locking-Slot-Frage (FORK, GenusBindingTraits=TABU)

**Ist (verifiziert):** Set/Sequence/Adapter tragen den `concurrency`-Slot als **reinen Typ-Deskriptor**
(`set_composition.hpp:26` T7, `sequence_composition.hpp:38` T3, `adapter_anatomy.hpp:122` T5 „(delegated)"); View
per Design ohne Slot (`view_composition.hpp:5/61`). KEINE Container-Anatomie hält ein `ObservableConcurrency`-
Organ; die per-Genus V1-PODs (`set_tier.hpp:17` etc.) haben **keinen Reserve-Slot**.

**„Echt verwendet" hieße** (Muster = SearchAlgorithm-`cc_organ_`, GenusBindingTraits NICHT nötig):
1. Container-Anatomie hält `ObservableConcurrency<Composition::concurrency>` als neues Member (reuse des bereits
   deklarierten Slots — **keine** Änderung an `genus_binding_traits.hpp`).
2. Mutations-Ops klammern real: `SetAnatomy::insert/erase`, `SequenceAnatomy::push_back`, `AdapterAnatomy::push/pop`
   → `cc_organ_.observe_critical_section()` (echte acquire/release auf dem Slot-Primitiv).
3. Werte-Ausgabe = **hier bricht ABI:** die V1-PODs haben keinen freien Slot → entweder (a) per-Genus-POD-Feld
   anhängen + `kSetObserverSnapshotVersion 1→2` (per-Genus-ABI-Bump, eigene Versionierung, NICHT der 1416-POD),
   oder (b) ein net-neuer separater Container-Concurrency-POD/Sub-Interface/Dock (additive Cross-Boundary-Surface).

**⇒ Beide Wege sind ein FORK (§6): sie berühren per-Genus-ABI bzw. legen neue Cross-Boundary-Surface an →
User-GO Pflicht.** GenusBindingTraits selbst bleibt unberührt (Slot ist schon deklariert) = TABU gewahrt.
**Nicht** ungeprüft in golden-Pipeline verdrahten: `observable_axis_count=1` (`set_abi_adapter.hpp:77`) warnt
ehrlich, dass 13/14 Set-Achsen nur Identität tragen — Container-Docks sind bewusst V42-deferred
(`pruef_dock_registry.hpp:4-5`) und dürfen erst mit echten Organ-Pfaden verdrahtet werden.

**View:** non-owning/immutable → „read-only"-Locking per Design N/A; fehlender Slot ist korrekt, KEIN Defizit.

---

## 4. Observer-Echtheits-Roadmap ALLER Gattungen

Prinzip durchgängig: **honest-100%** — jeder Zähler wird in der REALEN Op inkrementiert; Nicht-Werte sind
genuin-0 oder ehrlich-abgeklemmt-deferred, nie erfunden.

| Gattung / Achse | Messwert | Ist | S-7-Increment | honest-Prinzip / data-gated |
|---|---|---|---|---|
| **SA T8 (neu)** | upgrade_success, upgrade_failure | fehlt (kein Organ) | Organ §2 + `observe_upgrade_section` §3.1 → neue Felder in **freie r[5]/r[6]** (Schema nullptr→benannt, 1416-neutral) | single-thread schon ≠0 (jede Schreib-Op eskaliert real) |
| **SA T8** | contention, validation_fail | ehrlich 0 (single-thread) | Multi-Thread-Treiber = **#221-Rest / Fix A deferred** | bleibt honest-0 bis nebenläufiger Treiber (data-gated) |
| **SA T8** | thread_count applied | inert (0 Aufrufer von `runtime_thread_count()`) | echtes Threading-Konsum = **#221 deferred** | ehrlich als Label deklariert, kein Phantom |
| **SA T0–T18 (17 andere)** | siehe Strang 4 | echt / honest-0-berechtigt | **keine Änderung** (kein Phantom, keine Lücke) | T6/T7/T14/T15 honest-0 genuin |
| **Container Set/Seq/View/Adapter** | insert/contains/push/at/read/put… | echt (Code-Ebene) | **keine Änderung** — Mess-Pfad V42-deferred, PHANTOM-frei | nicht in golden verdrahten (§3.2-Warnung) |
| **Container concurrency** | acquire/release/upgrade je Genus | **abwesend** | = **FORK §3.2/§6**, User-GO | erst mit echtem Organ-Pfad, sonst observable_axis_count-Warnung |
| **Virus/Graph** | visited/edges/checksum | echt (BFS, kein Stub) | **keine Änderung** — Gattung bewusst deferred (kein Achsen-System) | PHANTOM-frei |
| Container HYBRID/IPC-Varianten | — | reserviert | **#156-data-gated** (Variante-b) | nicht bauen bis Datenlage |

**Fazit Roadmap:** Die EINZIGE bau-würdige Substanz-Lücke ist SA-T8-Upgradeable (Organ + upgrade-Observer-Felder).
Alles andere ist entweder echt, genuin honest-0, oder ehrlich-deferred (#221 Multi-Thread, V42 Container-Pipeline,
#156 Varianten) — **nicht** im S-7-Scope zu „reparieren", weil kein Phantom vorliegt.

---

## 5. Increment-Schnitt + Verifikations-Gates + TABU-Nachweise

### INC-1 — Organ + Observer-Feld (golden-neutral, baubar sofort, KEIN GO nötig)
Umfang: §1.2 vendor (Paper/K1/K5 read-only in `ext/`), §2 (Organ + Registry + Enum + Flag + XML-Baustein
`enabled=false`/`golden_wired=false`), §4 SA-T8 upgrade_success/upgrade_failure in **freie r[5]/r[6]**
(`observable_tier.hpp:84` nullptr→"upgrade_ok"/"upgrade_fail"; `fill_observer_v3` `abi_adapter.hpp:1287` r[5]/r[6]
schreiben) + `ObservableConcurrency::observe_upgrade_section`. Unit-Test `test_axis08_upgradeable.cpp`
(Concept-Konformität, upgrade-Zähler, no-op-honest-0 für 9 Bestands-Organe).
**Gates:** (1) `ctest` grün (offizieller Standalone-Build, Pflicht-Reihenfolge); (2) `EXPECT_EQ(sizeof(
ComdareTierObserverSnapshot),1416u)` in allen ≥10 Tests grün; (3) static_assert mp_size>0 + Concept-asserts;
(4) `grep -c "concurrency=concurrency_none" golden_fullpilot_320_binary_ids.txt` == 320 unverändert;
(5) `git diff experiment_golden.xml` leer.

### INC-2 — SA echte Verwendung (opt-in, golden-neutral)
Umfang: `compositions/upgradeable_reference.hpp` (bindet Upgradeable), Nicht-golden Opt-in-Experiment-XML das
`-DCOMDARE_AXIS_08_ENABLE_UPGRADEABLE=ON` baut und die Komposition treibt → upgrade_success/fail ≠ 0 demonstriert.
**Gates:** distinkte Observer-Werte (upgrade ≠ 0, pattern_id=8, None-Baseline weiter 0); contention/validation
weiter honest-0 (kein Multi-Thread-Treiber) explizit dokumentiert; golden-320 unberührt.

### INC-3 — Container echte Verwendung (**FORK, User-GO Pflicht**, §6)
Umfang: §3.2 Organ in Container-Anatomie + Mutations-Klammerung + per-Genus-POD-Bump ODER net-neuer Container-
Concurrency-POD. **Erst nach GO.** Gates: GenusBindingTraits-Diff leer (TABU); per-Genus-Versions-Bump reviewed;
Container NICHT in golden-Pipeline verdrahtet.

### TABU-Nachweise (für INC-1/INC-2, die ohne GO laufen)
- **golden-320:** 320 frozen IDs + `experiment_golden.xml` bit-identisch (Gate 4/5); neuer Baustein
  `golden_wired="false"` + `enabled="false"`.
- **POD-1416:** upgrade-Felder gehen in **bereits existierende** freie Slots `axis_stats[8][5]/[6]` (die 8-Feld-
  Breite existiert seit je; nur nullptr→benannt = Präzedenz `observable_tier.hpp:73`) → `sizeof`==1416 unverändert
  (Gate 2). `ConcurrencyStatistics` (DLL-intern) wächst auf 7 uint64, bleibt standard_layout/trivially_copyable,
  mappt in die 8-breite Zeile — **kein** Wire-POD-Bruch.
- **ABI-4:** ABI-Major unverändert; alle Änderungen additiv innerhalb reservierter Slots. Enum-Erweiterung
  END-Append (Werte 0..7 stabil). Container-POD-Bump (INC-3) ist per-Genus-Versionierung (`kSetObserverSnapshot
  Version`), **nicht** der ABI-4-Wire-POD → aber trotzdem GO-gated (Fork).

---

## 6. Echte offene Forks (User-GO erforderlich)

1. **Container-Concurrency-Messung (INC-3):** JEDE echte Container-Verwendung von axis_08 berührt per-Genus-ABI
   (V1-POD ohne Reserve → Feld-Anhang + Versions-Bump) ODER legt net-neue Cross-Boundary-Surface an (separater
   Container-Concurrency-POD/Dock). **→ User-GO.** GenusBindingTraits bleibt dabei unberührt (Slot ist schon
   deklariert), aber der POD/Surface-Eingriff ist forkwürdig. Zusatz-Frage an User: (a) per-Genus-POD-Bump vs.
   (b) separater additiver Container-Concurrency-POD — Empfehlung (b) (additiv, ABI-schonender).
2. **golden-Pipeline-Verdrahtung der Container-Docks:** bewusst V42-deferred (`pruef_dock_registry.hpp:4-5`).
   Verdrahten ohne echte Organ-Pfade macht `observable_axis_count=1` zur Warnung (13/14 Achsen nur Identität).
   **→ NICHT ohne GO + ohne #188-analoges Organ-Pfad-Fundament je Container-Achse.**
3. **Multi-Thread-Mess-Treiber (#221-Rest / Fix A):** macht contention/validation/thread_count ≠ 0 für ALLE
   Concurrency-Organe. Große Änderung am Mess-Loop (Nebenläufigkeit im DRAM-Bench-Pfad) → eigener Auftrag, nicht
   S-7-Kern. **→ deferred, GO/eigener Task.**
4. **`locking_mode.hpp` (tote vtable, Sub-Achse 8.2):** Semantik-Quelle (Upgradeable=2) wird von §2 CRTP-konform
   gehoben; das tote Enum/`ILockingMode` **löschen vs. deprecaten** = Doku-/Doktrin-Entscheid (Direktive „Doku nie
   löschen, nur deprecaten") → als Deprecation-Banner, nicht rm. **→ GO für Deprecation-Text.**
5. **OptiQL-Lizenz einholen:** falls faithful-Direktnutzung (statt Reimpl) gewünscht → Anfrage bei SFU-DIS.
   **→ User-Entscheid** (Default: Reimpl aus Paper, keine Anfrage).

---

*Erhebung: read-only Live-Verifikation aller zitierten Anker (Registry/Concept/Organe/Observable/flags.hpp.in/
CMakeLists/Registry-XML/observable_tier-Schema/Container-PODs/1416-Tests) + 4 Rohdaten-Stränge. Einzige
geschriebene Datei = diese PLAN.md. Keine Code-/Config-/golden-Änderung in dieser Planungs-Session.*
