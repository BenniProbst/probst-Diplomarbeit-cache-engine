# STRANG B — Rohdaten: Die 4 Entwurfs-Header vollständig seziert (Spalte „Entwurf")

Datum: 2026-07-16 · Erhebung: read-only, jede Aussage datei:zeile-belegt · Kontext: F4-Systemachsen-Dossier

**Pfad-Wurzel** (alle relativen Angaben unten beziehen sich hierauf):
`/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/`

Kurzform: `CONCEPTS/` = `libs/cache_engine/include/cache_engine/concepts/`, `REGISTRY` = `libs/cache_engine/builder/commands/axis_library_registry.hpp`.

---

## 0. Identifikation der 4 Header + Gesamtstatus

| # | Datei | Achse | Version-Marker | Beleg |
|---|-------|-------|----------------|-------|
| H1 | `CONCEPTS/hardware_strategy.hpp` | Achse 12 HARDWARE-STRATEGY (NEU) | `V32.EE.5 (2026-05-18 spaet)` | hardware_strategy.hpp:2 |
| H2 | `CONCEPTS/locking_mode.hpp` | Achse 8.2 Locking-Mode (Sub-Achse von Achse 8 CONCURRENCY) | `V32.EE.5 (2026-05-18 spaet)` | locking_mode.hpp:2,8 |
| H3 | `CONCEPTS/numa_affinity.hpp` | Achse 6.3 NUMA-Affinity (Sub-Achse von Achse 6 ALLOCATOR) | `V32.EE.5 (2026-05-18 spaet)` | numa_affinity.hpp:2,8 |
| H4 | `CONCEPTS/scheduling_strategy.hpp` | Achse 13 SCHEDULING-STRATEGY (NEU) | `V32.EE.5 (2026-05-18 spaet)` | scheduling_strategy.hpp:2 |

**Verdrahtungsstatus (IST, verifiziert per Repo-weitem grep über \*.hpp/\*.cpp/\*.h/\*.cc/CMake):**
Es existiert **kein einziger `#include`-Konsument** der 4 Header außer H3→H1 (numa_affinity.hpp:10 inkludiert `hardware_strategy.hpp` für das `NumaStrategy`-Enum). Alle übrigen Repo-Treffer sind **reine String-Literale** in den Provenienz-Feldern der `AxisLibraryRegistry` (REGISTRY:122–126, 164–168, 197–219, 239–243). Die 4 Header sind also **reiner Entwurf ohne Codepfad** — bestätigt durch Commit 414ed8c2 (2026-07-13), der sie als „genuin-tote Dead-Code-Header … 4 vtable-Achsen … (grep=0 Konsumenten)" klassifizierte (siehe §7).

Alle Interfaces der 4 Header sind **vtable-basiert** (pure-virtual + virtueller Destruktor: hardware_strategy.hpp:45–51, locking_mode.hpp:34–35, numa_affinity.hpp:24–25, scheduling_strategy.hpp:39–45) — im Widerspruch zur geltenden CRTP+Concept-Doktrin (Commit-Wortlaut 414ed8c2: „vtable statt CRTP"). Deckt USER-Punkt (3) „das Konzept ist Pflicht und kaputt": Pflicht-Systemachsen-Themen existieren nur als toter vtable-Entwurf.

---

## 1. H1 `hardware_strategy.hpp` (74 Zeilen) — Achse 12

### 1.1 Dokumentierte Semantik (Header-Kommentar)
- Tags: `@achse 12`, `@subsystem CE`, `@reuse_status (b)` (hardware_strategy.hpp:4–6).
- „User-Direktive 2026-05-18: NEUE Algorithmus-Permutations-Achse fuer verwendete Hardware-Features." (hardware_strategy.hpp:8–9).
- Abgrenzung — wörtlich: „WICHTIG: NICHT identisch mit K09 C8 Hardware-Probing-Heuristik! K09 C8 = wie ENTDECKT die CE die Hardware (CE-Service); Achse 12 = welche Hardware NUTZT der Algorithmus AKTIV" (hardware_strategy.hpp:11–13). → Der Entwurf selbst trennt bereits **System-Seite (CE-Service, Entdecken)** von **Gattungs-/Algorithmus-Seite (aktives Nutzen)** — Rohbeleg für USER-Punkt (1).
- Interface-Doku: „Algorithmus-aktive Hardware-Strategie. CEB-AutoPermutator iteriert verfuegbare Variants bei fehlender Achsen-Spec im Profil." (hardware_strategy.hpp:40–41). → Entwurfs-Intention: CEB kompiliert/permutiert die Achse in die Tier-Binaries hinein (USER-Punkt 2, Gattungs-Seite).

### 1.2 Enums (vollständig)

| Enum | Basistyp | Enumeratoren (Wert) | Sub-Achse | Beleg |
|------|----------|---------------------|-----------|-------|
| `SimdFamily` | `std::uint8_t` | `Scalar=0, AVX2=1, AVX512=2, NEON=3, SVE2=4` | 12.1 SIMD-Family | hardware_strategy.hpp:19–20 |
| `CacheLevelTarget` | `std::uint8_t` | `L1Aware=0, L2Aware=1, L3Aware=2, HBMAware=3` | 12.2 Cache-Level-Targeting | hardware_strategy.hpp:22–23 |
| `NumaStrategy` | `std::uint8_t` | `Local=0, Interleave=1, Preferred=2, Bind=3` | 12.3 NUMA-Strategy | hardware_strategy.hpp:25–26 |
| `PrefetchHwInstruction` | `std::uint8_t` | `None=0, Prefetch=1, PrefetchNta=2, PrefetchW=3` | 12.4 Prefetch-Hardware | hardware_strategy.hpp:28–29 |
| `AtomicFamily` | `std::uint8_t` | `None=0, CAS=1, LLSC=2, RmwExtended=3` | 12.5 Atomic-Instruction-Family | hardware_strategy.hpp:31–32 |

### 1.3 Interface `IHardwareStrategy` (vtable; `@reuse_status (b)`, hardware_strategy.hpp:35–38)

| Methode | Signatur | Beleg |
|---------|----------|-------|
| `get_simd_family` | `[[nodiscard]] virtual SimdFamily get_simd_family() const noexcept = 0` | hardware_strategy.hpp:45 |
| `get_cache_level_target` | `[[nodiscard]] virtual CacheLevelTarget get_cache_level_target() const noexcept = 0` | hardware_strategy.hpp:46 |
| `get_numa_strategy` | `[[nodiscard]] virtual NumaStrategy get_numa_strategy() const noexcept = 0` | hardware_strategy.hpp:47 |
| `get_prefetch_hw` | `[[nodiscard]] virtual PrefetchHwInstruction get_prefetch_hw() const noexcept = 0` | hardware_strategy.hpp:48 |
| `get_atomic_family` | `[[nodiscard]] virtual AtomicFamily get_atomic_family() const noexcept = 0` | hardware_strategy.hpp:49 |
| (Dtor) | `virtual ~IHardwareStrategy() = default` | hardware_strategy.hpp:51 |

### 1.4 `DefaultHardwareStrategy` — „PRT-ART-Default + Auto-Permutator-Basis", `@reuse_status (a)` (hardware_strategy.hpp:55–57)
Member-Defaults: `simd{AVX2}`, `cache_level{L1Aware}`, `numa{Local}`, `prefetch_hw{Prefetch}`, `atomic{CAS}` (hardware_strategy.hpp:60–64); 5 triviale Getter-Overrides (hardware_strategy.hpp:66–70).

---

## 2. H2 `locking_mode.hpp` (39 Zeilen) — Achse 8.2

### 2.1 Dokumentierte Semantik
- Tags: `@achse 8.2`, `@subsystem CE`, `@reuse_status (b)` (locking_mode.hpp:4–6).
- „Sub-Achse von Achse 8 CONCURRENCY (N-Phase Split). Bestand: implizit in disciplines/memory_\*\_discipline.hpp — V32 explizit." (locking_mode.hpp:8–9). → Entwurf sollte implizit Vorhandenes explizit als Achse heben.

### 2.2 Enum `LockingMode` (vollständig, inkl. Doc-Kommentare je Enumerator)

| Enumerator (Wert) | Doku-Semantik | Beleg |
|-------------------|---------------|-------|
| `ReadOnly = 0` | „std::shared_mutex shared" | locking_mode.hpp:21 |
| `ReadWrite = 1` | „std::mutex exclusive" | locking_mode.hpp:22 |
| `Upgradeable = 2` | „boost::shared_mutex upgrade" | locking_mode.hpp:23 |
| `OptimisticValidation = 3` | „OLC, HTM" | locking_mode.hpp:24 |

Basistyp `std::uint8_t` (locking_mode.hpp:20).

### 2.3 Interface `ILockingMode` — „Concept fuer Algorithmus-spezifische Locking-Wahl" (locking_mode.hpp:28)

| Methode | Signatur | Beleg |
|---------|----------|-------|
| `preferred_mode` | `[[nodiscard]] virtual LockingMode preferred_mode() const noexcept = 0` | locking_mode.hpp:34 |
| (Dtor) | `virtual ~ILockingMode() = default` | locking_mode.hpp:35 |

Kein Default-Struct vorhanden (im Gegensatz zu H1/H4).

---

## 3. H3 `numa_affinity.hpp` (29 Zeilen) — Achse 6.3

### 3.1 Dokumentierte Semantik
- Tags: `@achse 6.3`, `@subsystem CE`, `@reuse_status (b)` (numa_affinity.hpp:4–6); „Sub-Achse von Achse 6 ALLOCATOR (N-Phase Split)." (numa_affinity.hpp:8).
- „Allokator-Sub-Strategy. Konsumiert NumaStrategy aus hardware_strategy.hpp." (numa_affinity.hpp:20); Include: `#include "hardware_strategy.hpp" // NumaStrategy enum` (numa_affinity.hpp:10).

### 3.2 Enums: **KEINE eigenen.** Der Header definiert kein Enum; das Wertespektrum ist H1s `NumaStrategy` (hardware_strategy.hpp:26). → Achse 6.3 und Achse 12.3 teilen sich denselben Wertevorrat (bewusste Kopplung im Entwurf).

### 3.3 Interface `INumaAffinity` — „Sub-Achse 6.3 (Algorithmus-spez. NUMA-Wahl)" (numa_affinity.hpp:16)

| Methode | Signatur | Beleg |
|---------|----------|-------|
| `preferred_strategy` | `[[nodiscard]] virtual NumaStrategy preferred_strategy() const noexcept = 0` | numa_affinity.hpp:24 |
| (Dtor) | `virtual ~INumaAffinity() = default` | numa_affinity.hpp:25 |

Kein Default-Struct vorhanden.

---

## 4. H4 `scheduling_strategy.hpp` (68 Zeilen) — Achse 13 (der „Scheduling-Entwurf")

### 4.1 Dokumentierte Semantik
- Tags: `@achse 13`, `@subsystem CE`, `@reuse_status (b)` (scheduling_strategy.hpp:4–6).
- „User-Direktive: NEUE Achse fuer Scheduling-Strategien. Wichtig: SIMD-Einheiten sind Hardware-limitiert (typ. 2 von N Cores)." (scheduling_strategy.hpp:8–9).
- Interface-Doku: „13.2 SIMD-Worker-Count-Limit ist HARDWARE-limitiert (typ. 2 von N). Andere Worker laufen scalar normal parallel." (scheduling_strategy.hpp:34–35).

### 4.2 Enums (vollständig) — **Anomalie: Sub-Achse 13.2 hat KEIN Enum** (sie ist als `std::size_t`-Methode modelliert, s. 4.3)

| Enum | Basistyp | Enumeratoren (Wert) | Sub-Achse | Beleg |
|------|----------|---------------------|-----------|-------|
| `WorkerPoolLayout` | `std::uint8_t` | `ThreadPerCore=0, WorkStealing=1, CpuPinning=2, FreePool=3` | 13.1 Worker-Pool-Layout | scheduling_strategy.hpp:16–17 |
| `HeteroCoreDispatch` | `std::uint8_t` | `None=0, HybridAware=1, PCoresOnly=2, ECoresOnly=3` | 13.3 Heterogeneous-Core-Dispatch (Intel Hybrid P/E) | scheduling_strategy.hpp:19–20 |
| `CoRoutineStrategy` | `std::uint8_t` | `None=0, Interleave=1, DependencyTracking=2` | 13.4 Co-Routine-Strategy | scheduling_strategy.hpp:22–23 |
| `BatchGranularity` | `std::uint8_t` | `Single=0, MicroBatch=1, MacroBatch=2` | 13.5 Batch-Granularity | scheduling_strategy.hpp:25–26 |

### 4.3 Interface `ISchedulingStrategy` (vtable; scheduling_strategy.hpp:37)

| Methode | Signatur | Sub-Achse | Beleg |
|---------|----------|-----------|-------|
| `get_worker_pool_layout` | `[[nodiscard]] virtual WorkerPoolLayout get_worker_pool_layout() const noexcept = 0` | 13.1 | scheduling_strategy.hpp:39 |
| `get_simd_worker_count_limit` | `[[nodiscard]] virtual std::size_t get_simd_worker_count_limit() const noexcept = 0` | 13.2 | scheduling_strategy.hpp:40 |
| `get_hetero_core_dispatch` | `[[nodiscard]] virtual HeteroCoreDispatch get_hetero_core_dispatch() const noexcept = 0` | 13.3 | scheduling_strategy.hpp:41 |
| `get_co_routine_strategy` | `[[nodiscard]] virtual CoRoutineStrategy get_co_routine_strategy() const noexcept = 0` | 13.4 | scheduling_strategy.hpp:42 |
| `get_batch_granularity` | `[[nodiscard]] virtual BatchGranularity get_batch_granularity() const noexcept = 0` | 13.5 | scheduling_strategy.hpp:43 |
| (Dtor) | `virtual ~ISchedulingStrategy() = default` | — | scheduling_strategy.hpp:45 |

### 4.4 `DefaultSchedulingStrategy` — „Auto-Permutator-Basis", `@reuse_status (a)` (scheduling_strategy.hpp:49–51)
Member-Defaults: `worker_pool{ThreadPerCore}`, `simd_workers{2}` mit Doc „Hardware-Limit, typ. 2 von N Cores", `hetero{HybridAware}`, `co_routine{Interleave}`, `batch{MicroBatch}` (scheduling_strategy.hpp:54–58); 5 triviale Getter-Overrides (scheduling_strategy.hpp:60–64).

### 4.5 Abgrenzung: `C11_Scheduler` (System-Seite) ≠ Achse 13 (Gattungs-Seite)
Das Grep nach `c11_scheduler|scheduling` in `concepts/` + `builder/` liefert genau zwei Fundorte: H4 selbst und `CONCEPTS/i_sub_engine.hpp`:
- `SubEngineSlot::C11_Scheduler = 11` als eine von 12 Sub-Engine-Familien „aus K15" (i_sub_engine.hpp:14–15,26).
- In der deterministischen Pipeline-Reihenfolge „(U09 §3.4): Information first -> Structure second -> Allocation third -> Behavior last" steht `C11_Scheduler` an **letzter** Stelle (i_sub_engine.hpp:30–36).
- `ISubEngine`-Interface (Runtime, vtable): `name()` (i_sub_engine.hpp:54), `family_kind()` (i_sub_engine.hpp:57), `advise(const PlatformSnapshot&, const RequestContext&, const CacheRecommendation&)` (i_sub_engine.hpp:60–61), `on_event(const SubEngineEvent&)` (i_sub_engine.hpp:64).
→ Rohbeleg USER-Punkt (1)/(3): Scheduling existiert doppelt — als **System-Sub-Engine C11** (CE-Runtime-Pipeline) und als **Gattungs-Achse 13** (Entwurf, tot). Keine Verbindung zwischen beiden im Code (kein Include, kein Symbolbezug; grep-Ergebnis oben).

---

## 5. Registry-Provenienz (REGISTRY:122–243, ergänzt 245–313) — Abgleich String ↔ Header-Realität

Kontext: `AxisLibraryRegistry` = „statische Lookup-Tabelle pro Achse 1-14 (+ Sub-Achsen) … Wird vom AutoPermutator.discover_axis_implementations() aufgerufen. Liefert pro Achsen-ID die Liste verfuegbarer SOTA-Bausteine." (REGISTRY:13–17); Versionierung „V32.HH.1: 7 Achsen (11, 12.1-12.3, 13.1-13.2, 6.2). V33.A.4: alle 14 Achsen + relevante Sub-Achsen" (REGISTRY:19–20); Quelle „comdare-Diplomarbeit/docs/bausteine/01_bausteine_matrix.md" (REGISTRY:21); Ablöse-Plan „V34+ Folge: Doxygen-Tag-Extraktion via Custom-Script (BB.1 Konvention) ersetzt diese harte Tabelle." (REGISTRY:23). Provenienz-Feld = `AxisVariant::ce_library_path` („Pfad zur CE-Bibliothek-Klasse", auto_permutator.hpp:26–32; dort auch Filter-Flags `host_compatible` (IPlatformProbe) und `user_allowed` (messreihen.xml), auto_permutator.hpp:30–31). Verdrahtung: `AutoPermutator::discover_axis_implementations()` ruft `AxisLibraryRegistry::lookup(axis_id_)` (REGISTRY:321–323).

### 5.1 Abgleich-Matrix (Registry-String vs. tatsächlicher Header-Inhalt)

| Achse | Registry-Einträge (Belege) | Header-Realität | Befund |
|-------|---------------------------|-----------------|--------|
| 6.3 NUMA Affinity | `numa_affinity.hpp::NumaAffinity::{Local,Interleave,Preferred,Bind}` (REGISTRY:122–126) | `numa_affinity.hpp` enthält **kein** Enum `NumaAffinity` — nur `INumaAffinity` (numa_affinity.hpp:22); Werte leben als `NumaStrategy` in hardware_strategy.hpp:26 | **PHANTOM-SYMBOL** (4×): referenziertes Enum existiert nicht |
| 8.2 Locking-Mode | `locking_mode.hpp::LockingMode::{Optimistic,Pessimistic,LockFree,WaitFree}` (REGISTRY:164–168) | `LockingMode` = `{ReadOnly, ReadWrite, Upgradeable, OptimisticValidation}` (locking_mode.hpp:20–25) | **PHANTOM-ENUMERATOREN** (4/4): kein einziger Registry-Name existiert im Header |
| 12.1 SIMD-Family | `hardware_strategy.hpp::SimdFamily::{Scalar,AVX2,AVX512,NEON,SVE2}` (REGISTRY:197–201) | identisch (hardware_strategy.hpp:20) | MATCH 5/5 |
| 12.2 Cache-Level | `…::CacheLevelTarget::{L1Aware,L2Aware,L3Aware,HBMAware}` (REGISTRY:203–211) | identisch (hardware_strategy.hpp:23) | MATCH 4/4 |
| 12.3 NUMA-Strategy | `…::NumaStrategy::{Local,Interleave,Preferred,Bind}` (REGISTRY:213–219) | identisch (hardware_strategy.hpp:26) | MATCH 4/4 |
| 12.4 | Registry-Titel „Prefetch-Distance": `{NoPrefetch→concepts/hardware/no_prefetch.hpp, PrefetchT0/T1/T2/NTA→_mm_prefetch-Hints}` (REGISTRY:221–227) | Header-Titel „Prefetch-Hardware": `PrefetchHwInstruction{None,Prefetch,PrefetchNta,PrefetchW}` (hardware_strategy.hpp:28–29) | **DIVERGENZ**: anderer Achsen-Name, andere Wertemenge (T0/T1/T2-Hints vs. Instruktionsfamilie); Registry referenziert H1 hier gar nicht |
| 12.5 | Registry-Titel „Atomic-Granularity": `{CAS_64, CAS_128 (cmpxchg16b/casp), LL_SC, Relaxed_Ordering}` (REGISTRY:229–234) | Header: `AtomicFamily{None,CAS,LLSC,RmwExtended}` (hardware_strategy.hpp:31–32) | **DIVERGENZ**: Granularität (64/128 bit, Ordering) vs. Instruktionsfamilie; kein Header-Bezug im String |
| 13.1 Worker-Pool | `scheduling_strategy.hpp::WorkerPoolLayout::{ThreadPerCore,WorkStealing,CpuPinning}` (REGISTRY:237–243) | Header hat zusätzlich `FreePool=3` (scheduling_strategy.hpp:17) | **UNVOLLSTÄNDIG**: Registry kennt 3 von 4 Varianten |
| 13.2 SIMD-Limit | `{Limit_1, Limit_2 (Default, Hardware-Limit), Limit_4}` — reine Beschreibungs-Strings (REGISTRY:245–248) | `get_simd_worker_count_limit()` als `std::size_t` (scheduling_strategy.hpp:40), Default 2 (scheduling_strategy.hpp:55) | konsistent in der Semantik, aber Registry diskretisiert {1,2,4}, Header ist kontinuierlich (`size_t`) |
| 13.3 | Registry-Titel „Heterogeneous-Awareness": `{Homogeneous, HybridAware}` (REGISTRY:250–253) | Header: `HeteroCoreDispatch{None,HybridAware,PCoresOnly,ECoresOnly}` (scheduling_strategy.hpp:20) | **DIVERGENZ**: 2 vs. 4 Varianten, abweichende Namen (`Homogeneous`≠`None`), kein Header-Bezug im String |
| 13.4 | Registry-Titel „**Memory-Interleave**": `{NoInterleave, RoundRobin, FirstTouch}` (REGISTRY:255–259) | Header 13.4 = „**Co-Routine-Strategy**": `CoRoutineStrategy{None,Interleave,DependencyTracking}` (scheduling_strategy.hpp:22–23) | **ACHSEN-ID-KOLLISION**: dieselbe ID 13.4 bezeichnet zwei völlig verschiedene Themen |
| 13.5 Batching | `{Single (no batching), MicroBatch (4-16 ops), MacroBatch (128+ ops)}` (REGISTRY:261–265) | `BatchGranularity{Single,MicroBatch,MacroBatch}` (scheduling_strategy.hpp:26) | MATCH 3/3 der Namen; Registry-Strings sind Beschreibungen, kein Header-Verweis |

Zusatzbefund Registry-intern: Achse 12.3 (REGISTRY:213–219) und Achse 6.3 (REGISTRY:122–126) führen dieselben 4 Variantennamen `{Local,Interleave,Preferred,Bind}` als **getrennte Achsen** — im Entwurf gedeckt durch die H3→H1-Konsum-Beziehung (numa_affinity.hpp:10,20), in der Registry aber mit dem Phantom-Enum `NumaAffinity` statt `NumaStrategy` belegt.

### 5.2 Compiler-Achse 15 (Registry-Kontext für USER-Punkt 4 — neue Compiler-SYSTEMACHSE)
Die Registry enthält bereits eine **Compiler-Achse 15** (V35.B, eingeführt mit Commit 2863b3f1, 2026-05-22, „V35.B.1: Compiler-Achse 15 (15.1-15.5) in AxisLibraryRegistry + 2 Tests"):
- 15.1 Compiler-Family: `GCC, Clang, AppleClang, MSVC` (REGISTRY:274–279)
- 15.2 Optimization-Level: `O0…Ofast, MSVC_Od/O1/O2` (REGISTRY:281–290)
- 15.3 LTO-Mode: `None, ThinLTO, FullLTO, MSVC_LTCG` (REGISTRY:292–297)
- 15.4 PGO-Profile: `None, Generate, Use, SamplePGO` (REGISTRY:299–304)
- 15.5 Target-Arch: `native, x86-64-v3, x86-64-v4, znver4, armv9-a, generic` (REGISTRY:306–313)

Einordnung (Rohbefund, keine Bewertung): Achse 15 liegt in derselben **Algorithmus-Achsen-Lookup-Tabelle** wie die Gattungs-Achsen (Aufrufer: AutoPermutator, REGISTRY:16, 321–323) — d. h. der bisherige Entwurf modelliert „Compiler" als weitere Permutations-Achse der Tier-Binaries, **nicht** als Systemachse des CEB selbst (USER-Punkt 4 verlangt: gcc/clang-Wahl per XML „für den CEB selbst UND je Tier-Binary-Permutation" — die CEB-Selbst-Hälfte hat keinerlei Entsprechung im Bestand; grep-Befund §0: keine weiteren Fundstellen).

### 5.3 Achse 14 ENGINE-CHOICE (Nachbar-Kontext der Stufen-Frage, USER-Punkt 5)
`V1_Manual_Profile / V2_Adaptive_RuntimeDetect / V3_Hybrid_AB / V4_Automatic_FullPermutation` (REGISTRY:267–272), letzteres „CEB enumeriert alle V32-Permutationen" (REGISTRY:272). Rohbefund: Die Registry führt hier eine **4-stufige** Engine-Wahl als Achse — der USER-Punkt (5) setzt dagegen „JE der 3 Stufen (keine 4. Stufe)". (Nur Registrierung des Widerspruchs; Deutung gehört in die Delta-Matrix, nicht in Rohdaten.)

---

## 6. V32.EE.5-Kontext außerhalb der 4 Header

Einzige Doku-Fundstelle von „EE.5" in `docs/`: `docs/architecture/19_f6_prtart_migration_plan.md` (grep-Befund). Dort werden die 4 Header als **CE-seitige Ersatz-Ziele** für leere prt_art-`default_lookup/*`-Namespace-Marker geführt:
- `prt_art_12_hardware_default.hpp` → „`IHardwareStrategy` + SimdFamily/CacheLevelTarget/NumaStrategy/PrefetchHwInstruction/AtomicFamily Enums (`hardware_strategy.hpp`, V32.EE.5)" (19_f6_prtart_migration_plan.md:41, LÖSCHEN-Disposition Z.139)
- `prt_art_13_scheduling_default.hpp` → „`ISchedulingStrategy` + WorkerPoolLayout/HeteroCoreDispatch/CoRoutineStrategy/BatchGranularity (`scheduling_strategy.hpp`, V32.EE.5)" (19_f6_prtart_migration_plan.md:42, Z.140)
- `prt_art_63_numa_default.hpp` → „`INumaAffinity` (Local/Interleave/Preferred/Bind, V32.EE.5)" (19_f6_prtart_migration_plan.md:45, Z.143)
- `prt_art_82_locking_default.hpp` → „`ILockingMode` + LockingMode-Enum (ReadOnly/ReadWrite/Upgradeable/OptimisticValidation), V32.EE.5" (19_f6_prtart_migration_plan.md:47)

→ Der Migrationsplan zitiert die **korrekten** Header-Enumeratoren (ReadOnly/ReadWrite/…), die Registry die **falschen** (Optimistic/Pessimistic/…) — die Registry ist gegenüber beiden Quellen inkonsistent.

---

## 7. Git-Historie der 4 Header (Entstehung; `git log --follow`, identisch für alle 4)

| Commit | Datum | Betreff | Bedeutung |
|--------|-------|---------|-----------|
| `7a6c563f` | 2026-05-18 | „V32.EE.1+EE.2+EE.3+EE.4+EE.5: cache-engine V32.1 Sprint komplett" | **Geburt** aller 4 Header in einem Commit (deckt Header-Marker „V32.EE.5 (2026-05-18 spaet)", z. B. hardware_strategy.hpp:2) |
| `15655b43` | 2026-06-29 | „style(#179/#203): clang-format-Pass ueber libs/apps/tests" | reine Formatierung |
| `414ed8c2` | 2026-07-13 13:52 | „G4-#16: 5 genuin-tote Dead-Code-Header deprecated-in-place (Muster-C, additiv)" | Alle 4 als „**4 vtable-Achsen** (hardware_strategy/scheduling_strategy/locking_mode/numa_affinity, **vtable statt CRTP**)" mit „**grep=0 Konsumenten**" klassifiziert; additive DEPRECATED-Banner (7 Dateien, +49 Zeilen); verifiziert „ctest 265/265" (Commit-Message) |
| `804aa3c2` | 2026-07-13 14:19 | „Revert »G4-#16…«" | Banner nach 27 Minuten **vollständig revertiert** (−49 Zeilen); Revert-Message nennt keinen Grund |

Registry-Historie (REGISTRY): `f2589aaa` 2026-05-18 „V32.HH.1+HH.2+HH.3+II.1+II.2+JJ.1: AutoPermutator Lookup + Workload-Loop + Tests + CMake" (Geburt, 7 Achsen) → `04a2bd1c` 2026-05-21 „V33.A.1-A.4 + V33.B.2 … full Axis-Registry" (Vollausbau inkl. der Phantom-Strings) → `2863b3f1` 2026-05-22 „V35.B.1: Compiler-Achse 15" → `6b3ed0d9` 2026-06-01 (tote Registry-Pfade repointet) → `15655b43` 2026-06-29 (Format).

Zeitliche Rohfolge: Header (18.05.) → Registry-Vollausbau mit abweichenden Strings **3 Tage später** (21.05., `04a2bd1c`) — die Phantome/Divergenzen aus §5.1 entstanden also nicht durch spätere Header-Änderung (Header seit Geburt inhaltlich unverändert, einzige Folge-Commits sind Format/Deprecation/Revert), sondern die Registry wurde von Anfang an **nicht gegen die Header** geschrieben.

---

## 8. Delta-Matrix-Rohmaterial — Spalte „Entwurf" (kondensiert)

| Thema (USER-Pflicht-Systemachse) | Entwurf-Artefakt | Entwurf-Inhalt (kompakt) | Verdrahtung | Konflikte |
|----------------------------------|------------------|--------------------------|-------------|-----------|
| Hardware | `IHardwareStrategy` + 5 Enums (hardware_strategy.hpp:20–52) + `DefaultHardwareStrategy` (:59–71) | 12.1 SIMD {Scalar,AVX2,AVX512,NEON,SVE2}; 12.2 CacheLevel {L1,L2,L3,HBM}; 12.3 NUMA {Local,Interleave,Preferred,Bind}; 12.4 Prefetch {None,Prefetch,PrefetchNta,PrefetchW}; 12.5 Atomic {None,CAS,LLSC,RmwExtended} | TOT (0 Include-Konsumenten; nur Registry-Strings 12.1–12.3) | vtable statt CRTP; Registry 12.4/12.5 semantisch abweichend; als **Algorithmus**-Achse deklariert (hardware_strategy.hpp:8–9), nicht als Systemachse |
| Locking | `ILockingMode` + `LockingMode` (locking_mode.hpp:20–36) | {ReadOnly, ReadWrite, Upgradeable, OptimisticValidation} mit Mutex-/OLC-/HTM-Zuordnung (:21–24) | TOT (nur Registry-Strings 8.2 — und die sind Phantome) | vtable; Registry nennt 4 nichtexistente Enumeratoren; kein Default-Struct |
| NUMA | `INumaAffinity` (numa_affinity.hpp:22–26) | 1 Methode `preferred_strategy()`; Wertevorrat = H1s `NumaStrategy` | TOT (nur Registry-Strings 6.3 — Phantom-Enum `NumaAffinity`) | vtable; Registry-Symbol existiert nicht; Doppel-Führung 6.3/12.3 desselben Wertevorrats |
| Scheduling | `ISchedulingStrategy` + 4 Enums (scheduling_strategy.hpp:17–46) + `DefaultSchedulingStrategy` (:53–65); System-Gegenstück `SubEngineSlot::C11_Scheduler` (i_sub_engine.hpp:26, Pipeline-letzter :36) | 13.1 Pool {ThreadPerCore,WorkStealing,CpuPinning,FreePool}; 13.2 SIMD-Limit (`size_t`, Default 2); 13.3 Hetero {None,HybridAware,PCoresOnly,ECoresOnly}; 13.4 CoRoutine {None,Interleave,DependencyTracking}; 13.5 Batch {Single,MicroBatch,MacroBatch} | TOT (nur Registry-Strings 13.1); C11_Scheduler-Slot separat, ohne Bezug | vtable; Registry 13.1 unvollständig (FreePool fehlt), 13.3 abweichend, **13.4 ID-Kollision** (Memory-Interleave vs. Co-Routine); Scheduling doppelt modelliert (System-Slot C11 vs. Gattungs-Achse 13) ohne Verbindung |
| Compiler (USER-Punkt 4, NEU) | kein Header; nur Registry-Achse 15.1–15.5 (REGISTRY:274–313) | Family/Opt/LTO/PGO/Target-Arch als AutoPermutator-Varianten | Registry-Lookup erreichbar (REGISTRY:321–323), aber als **Tier-Binary-Achse**, nicht als CEB-Selbst-Systemachse | CEB-Selbst-Compilerwahl (XML→gcc/clang für den CEB) hat **keinerlei** Bestand |

Querschnitts-Rohbefund für alle 4 Header: Sie modellieren ihre Themen als **Algorithmus-/Gattungs-Permutations-Achsen** („Algorithmus-aktive …", hardware_strategy.hpp:40; „Algorithmus-spezifische Locking-Wahl", locking_mode.hpp:28; „Algorithmus-spez. NUMA-Wahl", numa_affinity.hpp:16; CEB-AutoPermutator-Bezug hardware_strategy.hpp:40–41, scheduling_strategy.hpp:49). Eine **Systemachsen**-Ausprägung derselben Themen (in der CEB einkompiliert, per Strategie gemessen — USER-Punkte 1–3) existiert im Bestand nirgends; das System-seitige Pendant ist ausschließlich der Runtime-Sub-Engine-Slot C11_Scheduler bzw. K09-C8-Probing (nur als Abgrenzungs-Kommentar erwähnt, hardware_strategy.hpp:11–13).

---
*Erhebungsmethode: Read der 4 Header + i_sub_engine.hpp + REGISTRY (Z.1–100, 100–260, 259–326) + auto_permutator.hpp (AxisVariant); repo-weiter grep auf Header-Basenamen und `c11_scheduler|scheduling`; `git log --follow` je Datei; `git show` 414ed8c2/804aa3c2; `git log -S` für Achse 15. Keine Datei außer dieser Rohdaten-Datei geschrieben.*
