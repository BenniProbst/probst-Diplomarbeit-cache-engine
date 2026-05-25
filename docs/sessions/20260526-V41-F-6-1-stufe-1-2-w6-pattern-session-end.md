# V41.F.6.1 Stufe 1+2 W6-Pattern + Concept-Vollausbau — Session-Ende 2026-05-26

**Stand:** 2026-05-26 spaeter Nachmittag, Kontext-Ende-Push
**Vorgaenger:** `20260525-V41-F-6-1-architektur-konsolidiert-session-end.md` (gestrige Session)
**Master-Doc:** `docs/architektur/11_konzept_achsen_extension_visitor_pattern.md` (jetzt 1500+ Zeilen, §1-§15.10)
**Zweck:** Elaborate Session-Doku gemaess Memory-Direktive `[[session-at-95-percent-context]]`. Stufe 1+2 Vendor-Wrapper-Refactoring nach W6-Pattern komplett abgeschlossen, Stufe 3 angefangen + bewusst zurueck-revertiert (Concept observer_t TODO-Marker bis Wrapper-Updates), 5 ergaenzende User-Direktiven elaborate dokumentiert, Diplomarbeit-Repo public.

---

## §1 Session-Zusammenfassung 2026-05-26

Heute fand eine substantielle **Code-Implementations-Session** statt. Schwerpunkt war
das Umsetzen des in der gestrigen Session-Doku (HEAD `2153471`) konsolidierten
W6-Patterns (zentralisierte CMake-Topic-Registrierung mit Boost.MP11) als
Refactoring-Iteration des V41.F.6.1.A Pilot-Topics `allocator/axis_06_allocator`.

Schluessel-Ereignisse chronologisch:

1. **Pre-Read der bestehenden Allocator-Familien**: `libs/cache_engine/include/cache_engine/allocators/families/a01-a23` als Referenz fuer die geplante Vendor-Wrapper-Migration
2. **Concept-Vollausbau** Topic+Achsen-Concept-Hierarchie (zuerst noch mit `#ifdef COMDARE_HAVE_<VENDOR>`-Pattern): AllocatorStrategy + CacheEnginePermutationStrategy parallel + 6 Sub-Concepts (Zeroing/OverAllocating/Introspectable/Reclaimable/PoolResettable/Reallocating) + AllocationStatistics
3. **3 Vendor-Wrapper V1 (Batch 1)** geschrieben: StdMalloc, MimallocAllocator, SnmallocAllocator, PmrResourceAllocator mit `#ifdef`-Pattern + Concept-Beweisen via static_assert
4. **Doku §13 Pilot-Status** in Master-Doc dokumentiert (NEU 2026-05-26)
5. **Roadmap §14 (8 Punkte)** elaborate hinzugefuegt: Migration bestehender libs/cache_engine-Struktur, apps/cache_engine_builder als Submodule, adapters+ext mergen, tools+modules-Konsolidierung, Mess-Strategien CMake-Flag, reclamation richtig positionieren, concurrency_manager/* zu axis_08/sub_*, hybride Concurrency-Variant-Strategie
6. **Diplomarbeit-Repo public** gesetzt fuer Prof. Habich-Mitlesen (vorher private)
7. **Roadmap §15.1-§15.7** ergaenzt (benchmarks → Mess-Modul-Facade + Compile-Flag-Strategie revidieren + Statistics-Observer-Pflicht + PermutationEngine + iterable_aspect_t + Concurrency-Sonderfall-Bezug + TopicConfigSet + CacheEngineBuilder als C++-App)
8. **W5 Web-Recherche** (static compile variant Pattern): Boost.MP11 empfohlen (mp_list/mp_product/mp_filter/mp_for_each + FNV-1a Compile-Time-Hash + CMake foreach per Hash)
9. **W6 Web-Recherche** (zentralisierte CMake-Topic-Registrierung mit MP11): 5-Schichten-Pattern (CMake-Optionen + configure_file + Wrapper ohne #ifdef + Registry + Vendor-Include-Shims), DCE via `-ffunction-sections -fdata-sections -Wl,--gc-sections`
10. **Stufe 1 Infrastruktur** angelegt: `axis_06_allocator_flags.hpp.in` (configure_file mit `#cmakedefine01`), 3 vendor_includes/-Shims (mimalloc/snmalloc/pmr), `axis_06_allocator_registry.hpp` mit mp_list+mp_filter, 4 Registry-Smoke-Tests
11. **Stufe 2 Wrapper-Refactoring**: 4 Wrapper umgebaut — `#ifdef COMDARE_HAVE_*` raus, `static constexpr bool enabled = flags::<vendor>_enabled` + `if constexpr (enabled)` rein. Vendor-Header-Includes via vendor_includes/-Shim. Registry-`is_enabled` Dummy ersetzt durch `mp_bool<T::enabled>`.
12. **Build-Fix** wegen `USE_<VENDOR>` vs `ENABLE_<VENDOR>` Naming-Inkonsistenz: configure_file ans Ende verschoben (nach ext/CMakeLists.txt), USE = ENABLE && HAVE berechnet
13. **Stufe 3 angefangen** mit Concept-Constraint `typename observer_t + observer()` Pflicht-Erweiterung in CacheEnginePermutationStrategy, dann **zurueck-revertiert** mit TODO-Marker (Wrapper haben observer_t noch nicht — Build wuerde brechen)
14. **User-Klarstellung 2026-05-26**: Observer-Konzept BLEIBT Pflicht-Architektur, nur Aktivierung verschoben bis Wrapper-API nachgezogen
15. **5 ergaenzende Doku-Sektionen §15.8-§15.10** + 3 neue Tasks angelegt (#659 min-1-Algo-Pflicht, #660 Wrapper-Update Observer, #661 CLI-Build-Flags)
16. **Reihenfolge-Klarstellung User 2026-05-26**: Stufe 3+4 (F.6.1.I + F.6.1.D + F.6.1.E) sind Haupt-Phasen, F.6.1.H + F.6.1.G sind ERGAENZUNGEN danach

## §2 DONE heute (chronologisch nach Bloecken)

### Block A — Concept-Vollausbau (vormittags)
- Concept-File `axis_06_allocator_concept.hpp` von 1-Concept auf parallele 2-Concept-Hierarchie erweitert (AllocatorStrategy + CacheEnginePermutationStrategy)
- 6 Sub-Concept-Files (Zeroing/OverAllocating/Introspectable/Reclaimable/PoolResettable/Reallocating)
- AllocationStatistics Struct + Pflicht-API-Liste (3 Gruppen)
- CRTP-Basis AllocatorStrategyBase + concept-Constraint
- 7 Pflicht-Concept-Files + 1 CRTP-Basis-File

### Block B — Batch 1 Vendor-Wrapper V1 (mittags)
- MimallocAllocator (A04 Free-List-Sharding, Leijen MSR-TR-2019-18)
- SnmallocAllocator (A07 Message-Passing, Lipp/Bond ISMM 2019)
- PmrResourceAllocator (A22 std::pmr::memory_resource, Halpern N3916 C++17)
- Test-Erweiterung 11 → 29 Tests (4+3+5 Vendor-Tests pro Wrapper)
- `#ifdef COMDARE_HAVE_<VENDOR>` Pattern (V1) mit portable_aligned_alloc-Fallback

### Block C — Doku §13 + §14 (nachmittags)
- §13 Pilot-Status (Stand cache-engine 20dd0fa) mit 6 Sub-Sektionen (Files, Naming, Architektur, Concepts, CMake-Flag, Roadmap)
- §14 Roadmap-Erweiterung (8 strukturelle Konsolidierungs-Punkte aus User-Direktive 2026-05-25 spaet)
- Diplomarbeit-Repo PUBLIC gesetzt via `gh repo edit --visibility public`

### Block D — Doku §15.1-§15.7 (nachmittags)
- §15.1 benchmarks/ → modules/comdare-measurement Facade-Pattern
- §15.2 Compile-Flag-Strategie revidieren (verweist auf W6-Recherche)
- §15.3 Statistics-Observer-Pflicht in CacheEnginePermutationStrategy
- §15.4 PermutationEngine-Verknuepfung
- §15.5 Hybride Laufzeit-Permutation pro Achse (iterable_aspect_t)
- §15.6 Bezug zu §14.8 Concurrency-Sonderfall
- §15.7 TopicConfigSet + CacheEngineBuilder als C++-App (NICHT CMake-Script) + Statisch-vs-Dynamisch Tabelle

### Block E — W5+W6 Web-Recherchen
- W5: static compile variant Pattern → Boost.MP11 empfohlen (mp_list/mp_product/mp_filter/mp_for_each + FNV-1a Hash)
- W6: zentralisierte CMake-Topic-Registrierung mit MP11 → 5-Schichten-Pattern (CMake-Optionen + configure_file + Wrapper ohne #ifdef + Registry + Vendor-Shims)

### Block F — Stufe 1 Infrastruktur (spaeter nachmittags)
- `cmake/boost_mp11_setup.cmake` (FetchContent boost-1.86.0)
- `axis_06_allocator_flags.hpp.in` Template mit `#cmakedefine01`
- 3 vendor_includes/{mimalloc,snmalloc,pmr_resource}_include.hpp Shims (einzige #if-Stelle pro Vendor)
- `axis_06_allocator_registry.hpp` mit AllVendors (mp_list) + EnabledVendors (mp_filter)
- 4 Registry-Smoke-Tests im Test-File (FlagsHeaderIsTypedConstexpr/AllVendorsCount/EnabledVendorsNonEmpty/MpForEachIteration)

### Block G — Stufe 2 Wrapper-Refactoring
- StdMalloc: + `static constexpr bool enabled = flags::std_enabled`
- MimallocAllocator: alle 5+ `#ifdef COMDARE_HAVE_MIMALLOC`-Bloecke → `if constexpr (enabled)`, Include via vendor_includes/-Shim
- SnmallocAllocator: analog
- PmrResourceAllocator: + enabled-Konstante (kein Vendor-Switch noetig)
- Registry: `is_enabled<T> = mp_bool<true>` (Dummy) → `mp_bool<T::enabled>` (LIVE)
- CMakeLists.txt: USE_<VENDOR> = ENABLE && HAVE Berechnung am Ende, configure_file nach ext/CMakeLists.txt
- Build-Fixes: USE vs ENABLE Naming-Konsistenz im shim, Test-Include-Pfad-Korrektur

### Block H — Stufe 3 angefangen + revertiert (Session-Uebergabe)
- Concept-Constraint `typename observer_t + observer()` Pflicht-Erweiterung in CacheEnginePermutationStrategy (Block H1)
- REVERTIERT zu TODO-Marker (Block H2) weil Wrapper das nicht implementieren → Build wuerde brechen
- User-Klarstellung: Observer-Konzept bleibt Pflicht, nur Aktivierung verschoben

### Block I — Ergaenzende Doku §15.8-§15.10 + 3 neue Tasks
- §15.8 Stufe 1+2 LIVE + Stufe 3+ offene Aufgaben
- §15.9 min-1-Algorithmus pro Achse via mp11 (User-Direktive 2026-05-26: vermeidet CacheEngineBuilder-Crash bei 0-Achsen-Permutationen)
- §15.10 USE-Flags via CacheEngineBuilder CLI (User-Direktive 2026-05-26)
- Tasks #659 (min-1-Algo), #660 (Wrapper-Update Observer), #661 (CacheEngineBuilder CLI-Flags)

## §3 Wichtige Commits (chronologisch heute)

### comdare-cache-engine (standalone)
| Commit | Inhalt |
|--------|--------|
| `9ed9daa` | V41.F.6.1.A Topic+Achsen-Concept Allocator (Pilot, 1. Pilot-Commit gestern war 459f2cc) |
| `84ee063` | AA1-AA7 Sub-Achsen-Tags |
| `797785a` | CRTP-Basis AllocatorStrategyBase + Concept-Guard |
| `b4009bc` | StdMalloc Concept-Beweis-Klasse |
| `77a4761` | Concept-Beweis-Test 10/10 + 2 Build-Fixes (CRTP Henne-Ei, std::aligned_alloc MSVC) |
| `2eda74b` | Standard-AllocatorStrategy + 6 Sub-Concepts + CE-Permutation-Concept (W1 revidiert) |
| `20dd0fa` | reset()=Statistik-Reset (User-Klarstellung) + CMake-Flag + src-Skelette |
| `8257c15` | Concepts ausgebaut (W1+User-Feedback): Permutation+Statistics mit Observer + Boost.MP11 + CMake-Flag |
| `7dff726` | Batch 1: Mimalloc + Snmalloc + PMR-Resource Vendor-Wrapper (V1 mit #ifdef) |
| `2b57e03` | Stufe 1 Infrastruktur (Flags + configure_file + Registry + Vendor-Shims) |
| `2d55de3` | Stufe 2 Wrapper-Refactoring W6-Pattern (if constexpr statt #ifdef) |
| `5f76072` | Stufe 3 START: Concept observer_t TODO-Marker (Aktivierung mit Wrapper-Updates in F.6.1.I) |

### probst-Diplomarbeit-cache-engine
| Commit | Inhalt |
|--------|--------|
| `459f2cc` | V41.F.6.0 Single-File-Audit aller 43 prt-art Headers + F.6.0b TODO-Korrektur (gestern) |
| `f8cb9bb` | V41.F.6.0 Audit-Doku Korrektur Migrations-Reihenfolge (gestern) |
| `eed0001` | V41.F.6.1 Architektur-Skizze 2-Ebenen-Achsen + Pruefling-Namespace + Visitor (gestern) |
| `339e383` | V41.F.6.1 User-Antworten konsolidiert + 9 neue Detail-Rueckfragen (gestern) |
| `5c42917` | V41.F.6.1 Doku §11+§12 W1/W2/W3/W4 Konsolidierung + vergessene Features (gestern) |
| `7817b77` | V41.F.6.1 Doku §11.7 FINALE Topic-Liste + Mapping (alle 15 RQ beantwortet) (gestern) |
| `2153471` | V41.F.6.1 Session-End-Doku 2026-05-25 (gestern) |
| `4393ade` | V41.F.6.1 Session-End-Doku 2026-05-26 (Stufe 1+2 W6-Pattern, 104 Zeilen) (heute) |
| `e94d53e` | V41.F.6.1 Session-End-Doku §6 Reihenfolge-Klarstellung (heute) |

(Submodule-Bumps zwischen den Concept-Iterationen + Doku-Updates §13/§14/§15.7/§15.8 nicht alle einzeln aufgelistet, ~10 zusaetzliche Diplomarbeit-Commits heute)

## §4 Designentscheidungen heute (User-Direktiven konsolidiert)

### §4.1 W6-Pattern als Ablöesung des #ifdef-Patterns

User-Kritik 2026-05-26 vormittags (nach Batch 1 V1-Veroeffentlichung mit #ifdef):

> "Hm, also jetzt hast du einfach ein compile flag gesetzt, welches etwa Mimalloc und so weiter enabled. Das ist aber nicht notwendig, wenn wir per variadischer Programmierung und mp11 mit variadischen Listen in einer topic Registrierung mit cmake flags einfach bestimmte Axen-Algorithmen true oder false setzen und diese in einer meta-programmierten if-else Kette zu einem set existierender Axen-Klassen akkumulieren."

**Konsequenz:** Wrapper-Code wird `#ifdef`-frei, zentrale Topic-Registry akkumuliert via mp_filter alle aktivierten Vendor zur Compile-Time. Compiler entfernt unbenutzte Wrapper-Klassen automatisch aus Binary via DCE.

### §4.2 USE = ENABLE && HAVE (effektive Aktivierung)

Berechnung am Ende von CMakeLists.txt (nach `add_subdirectory(ext)` Auswertung):
- `COMDARE_AXIS_06_USE_<VENDOR>` = `COMDARE_AXIS_06_ENABLE_<VENDOR>` (User-Wunsch) `AND` `COMDARE_HAVE_<VENDOR>` (Vendor-Detection)
- STD + PMR: immer `HAVE=true` (libc/C++17 Standard)
- MIMALLOC + SNMALLOC: `HAVE` aus `ext/CMakeLists.txt` Detection

### §4.3 reset() = Statistik-Reset (NICHT Pool-Reset)

User-Klarstellung gestern: `reset()` in `CacheEnginePermutationStrategy` Pflicht-API (wenn STATISTICS=ON) ist die Statistik-Reset-Funktion zwischen Mess-Permutationen — NICHT ein Pool-Reset (das ist `PoolResettableStrategy::release_all()` Sub-Concept).

### §4.4 Observer-Konzept bleibt Pflicht-Architektur

User-Klarstellung 2026-05-26 abends: "das observer Konzept ist NICHT gestrichen, nur ERGÄNZENDER Kommentar"

**Konsequenz:** Concept-Constraint `typename observer_t + observer()` Pflicht-Erweiterung steht weiter als TODO im Concept-File. Aktivierung in F.6.1.I zusammen mit Wrapper-Updates (observer_t Alias + observer_ Member + observer() Methode + notify in alloc/dealloc/realloc/zero_alloc + Concept-Reaktivierung + Tests).

### §4.5 min-1-Algorithmus pro Achse Pflicht via mp11

User-Direktive 2026-05-26: "Wir definieren, dass wir je Achse mindestens einen Algorithmus fuer Permutationen anbieten muessen, dazu verwenden wir ebenfalls mp11."

**Konsequenz:** PermutationEngine bekommt `static_assert((mp_size<TopicAxisLists::variants>::value > 0 && ...))` achsen-uebergreifend. Frueher Compile-Fail mit klarer Diagnostik statt spaeterer Linker-/Runtime-Crash. Verhindert dass CacheEngineBuilder versehentlich eine 0-Achsen-Permutation startet.

### §4.6 USE-Flags via CacheEngineBuilder CLI

User-Direktive 2026-05-26: "Die CacheEngineBuilder Anwendung wird die Kompilation mit Build-Flags fuer die Permutation-Binary aufrufen und daher direkt auf der Kommandozeile setzen."

**Konsequenz:** CacheEngineBuilder ruft pro Permutation:
```bash
cmake -B build/perm_<hash> -DCOMDARE_AXIS_06_ENABLE_STD=OFF -DCOMDARE_AXIS_06_ENABLE_<V>=ON ...
cmake --build build/perm_<hash> --config Release
```
Isolierte Build-Verzeichnisse + Binaries je Permutation, keine separate Config-Datei noetig.

### §4.7 Reihenfolge-Klarstellung (Haupt-Phasen vor Ergaenzungen)

User-Klarstellung 2026-05-26 spaet:
- Haupt-Phasen: F.6.1.I (Stufe 3 Wrapper-Observer) → F.6.1.D (Stufe 4 PermutationEngine) → F.6.1.E (iterable_aspect_t)
- ERGAENZUNGEN: F.6.1.H (min-1-Algo) + F.6.1.G (CLI-Flags) kommen danach

## §5 Aktueller Repo-Stand (3 Hauptprojekte + 6 Submodule-Repos)

| Repo | HEAD | Aenderung heute | Status |
|------|------|------------------|--------|
| Diplomarbeit (PUBLIC) | `e94d53e` | 18+ Doku-Commits + Submodule-Bumps | ✅ gepushed |
| cache-engine standalone | `5f76072` | 12 Code-Commits (Concept-Vollausbau + Vendor + Stufe 1+2 + Stufe 3 TODO) | ✅ gepushed |
| prt-art | `d1b6140` | UNVERAENDERT seit 2026-05-25 | ✅ in sync |
| comdare-search-engine | `3c9aeeb` | UNVERAENDERT (Skelett) | — |
| comdare-cache-engine-core | `e208115` | UNVERAENDERT (Skelett) | — |
| comdare-measurement | `e2d4b0d` | UNVERAENDERT (Skelett) | — |
| comdare-isa-dispatch | `e26490d` | UNVERAENDERT (Skelett) | — |
| comdare-build-tools | `e18ef8b` | UNVERAENDERT (Skelett) | — |
| comdare-test-system | `ccec769` | UNVERAENDERT (Skelett) | — |

**Tests:** 33/33 Standalone-Tests + 104/104 Diplomarbeit-Tests grün (stabil bestaetigt nach Stufe 2 Refactoring + Stufe 3 Revert).

## §6 Konsistenz-Audit (heute durchgefuehrt)

- ✅ 5-Schichten W6-Pattern voll umgesetzt (CMake-Optionen + configure_file + Wrapper-Refactor + Registry + Vendor-Shims)
- ✅ 4 Vendor-Wrapper konsequent ohne `#ifdef COMDARE_HAVE_*` (StdMalloc/Mimalloc/Snmalloc/PMR)
- ✅ `is_enabled<T> = mp_bool<T::enabled>` LIVE (vorher Dummy)
- ✅ USE = ENABLE && HAVE Berechnung am Ende von CMakeLists.txt
- ✅ configure_file generiert `axis_06_allocator_flags.hpp` in `${BUILD}/generated/topics/allocator/axis_06_allocator/`
- ✅ Standalone-Test-Build verifiziert beide Pfade: STATISTICS=ON (33 Tests) + STATISTICS=OFF (frueher verifiziert: 32 Tests, Statistik-Tests #ifdef'd raus)
- ✅ Boost.MP11 via FetchContent funktional (FetchContent_MakeAvailable, INTERFACE-Target Boost::mp11)
- ✅ Concept-Constraint TODO-Marker im Concept-File (Stufe 3 Aktivierung dokumentiert)
- ✅ Diplomarbeit-Repo PUBLIC (Prof. Habich-Mitlesen aktiv)
- ✅ 3 neue Tasks angelegt (#659/#660/#661) fuer Stufe 3+ + ERGAENZUNGEN
- ✅ Session-End-Doku §6 Reihenfolge-Klarstellung gepushed
- ⚠ Stufe 3 (Observer-Wrapper-Update) NICHT abgeschlossen — fortgesetzt in naechster Session
- ⚠ §14 + §15.1 Roadmap-Punkte NICHT in Code umgesetzt — Doku-Roadmap fuer V41.F.6.2+
- ⚠ Batch 2-8 Vendor-Vollausbau (A05-A23, ~20 weitere Wrapper) NICHT angefangen — User-Direktive Vendor-Vollausbau

## §7 Naechste Aufgaben (priorisierte Reihenfolge)

### HAUPT-PHASEN (Stufe 3 + 4 wie urspruenglich geplant)

| # | Task | Aufwand | Beschreibung |
|---|------|---------|--------------|
| 1 | **F.6.1.I Stufe 3** | mittel | Wrapper observer_t + observer_ Member + observer() Methode + notify-Calls in allocate/deallocate/reallocate/zero_allocate + Concept-Reaktivierung im axis_06_allocator_cache_engine_permutation_concept.hpp + Tests fuer Observer-Notify-Pattern (Callback-Registrierung + Empfang) |
| 2 | **F.6.1.D Stufe 4** | substantiell | NEU `src/permutations/permutation_engine.hpp` mit `PermutationEngine<TopicAxisLists...>` Klasse: EnabledVendors-Konsum + Visitor-Pattern + `enumerate_all_permutations()` + `select_for_pruefling<Pruefling>()` Filterung |
| 3 | **F.6.1.E** | mittel | Hybride Laufzeit-Permutation: Achs-Variant darf optional `typename iterable_aspect_t` + `static constexpr std::span<aspect_t const> iterable_values()` definieren. PermutationEngine erkennt zur Compile-Time + generiert Hybrid (1 Binary + Runtime-Loop) |

### ERGAENZUNGEN (User-Reviews 2026-05-26, kommen DANACH)

| # | Task | Aufwand | Beschreibung |
|---|------|---------|--------------|
| 4 | **F.6.1.H ERGAENZUNG** | klein | mp11-Constraint `static_assert((mp_size<TopicAxisLists::variants>::value > 0 && ...))` in PermutationEngine — frueher Compile-Fail bei 0-Achsen-Permutationen, Diagnose-Message verweist auf COMDARE_AXIS_<NN>_ENABLE_* Flags |
| 5 | **F.6.1.G ERGAENZUNG** | substantiell | `apps/cache_engine_builder/main.cpp` Refactor: pro Permutation `cmake -B build/perm_<hash> -DCOMDARE_AXIS_<NN>_ENABLE_<V>=ON|OFF` CLI-Call + `cmake --build`. Isolierte Build-Verzeichnisse + Binaries pro Permutation |

### VENDOR-VOLLAUSBAU (parallel oder danach, Batches a 3 mit Review-Pause)

| Batch | Vendor | Begründung |
|-------|--------|-----------|
| Batch 2 | A05 Jemalloc + A06 TCMalloc + A20 dlmalloc | klassische malloc-Familien |
| Batch 3 | A01 Hoard + A02 Slab + A03 Michael LockFree | early-90s + Lock-Free-Pioneer |
| Batch 4 | A08 Scalloc + A09 NUMAlloc + A10 RPMalloc | NUMA + Performance-modern |
| Batch 5 | A11 LRMalloc + A12 CAMA + A13 StarMalloc | Lock-Free-modern + Cache-Aware + Formal-Verified |
| Batch 6 | A14 TCMalloc-Warehouse + A15 HMalloc + A16 PIM-Malloc | Google-Hyperscale + Hybrid + Processing-In-Memory |
| Batch 7 | A17 Crystalline + A18 Exgen-Malloc + A19 Buddy | Wait-Free-Reclamation + Single-Threaded-Spez + Knuth-Klassik |
| Batch 8 | A21 ptmalloc2 + A23 Vmem-Magazines + (1 weiterer) | glibc + Bonwick-Magazines |

### V42 (P0/P1 vergessene Features aus W4-Audit)

- V42.P0.1 H1/H2/H3 Hypothesen als Mess-Achse pro Permutation
- V42.P0.2 V1-V4 Engine-Choice-Multiplikation
- V42.P0.3 IPlatformProbe Auto-Discovery + Live-Tuning
- V42.P1.1 comdare-succinct (SDSL-Lite C++23-Portierung)
- V42.P1.2 comdare-rcu eigene Implementation
- V42.P1.3 HBM Abstract Factory + Cache-Hierarchy-Manager

### V41.F.6 Migration (NACH F.6.1 Vollausbau)

- F.6.2 BASIS-Migration der 27 prt-art Headers nach cache-engine
- F.6.3 prt-art Namespace-Restrukturierung
- F.6.4 Tests umbiegen
- F.6.5 messung_driver + Codegen anpassen
- F.6.6 Build-Verifikation + Tests grün
- F.6.7 Research-Clone aufraeumen

### Blockiert / extern

- V41.B4.1 MinGW Cross-Compiler-Matrix (wartet auf ESET-Bestaetigung)
- V41.C1+C2 Cluster-Tasks (wartet Cluster-Termin)
- V41.D1+D2 Diplomarbeit-Text (User schreibt manuell)

## §8 Wichtige Erkenntnisse für Fortsetzungs-Session

### §8.1 Architektur-Patterns die NICHT zu verletzen sind

1. **Observer-Konzept bleibt Pflicht-Architektur** (User-Klarstellung 2026-05-26) — nur Aktivierung verschoben bis Wrapper bereit
2. **W6-Pattern strikt:** kein `#ifdef COMDARE_HAVE_*` in Wrapper, alles via `static constexpr bool enabled = flags::<vendor>_enabled` + `if constexpr` + Vendor-Include-Shim
3. **CacheEngineBuilder ist C++-App, NICHT CMake-Script** (§15.7)
4. **Statisch vs Dynamisch klar trennen** (§15.7): cache-engine-Achsen statisch via CacheEngineBuilder, Aspekt-Iterationen dynamisch via iterable_values() innerhalb Binary
5. **Pro Achse min. 1 Algorithmus Pflicht** (User-Direktive 2026-05-26) — sonst Build-Crash
6. **TODOs NIE loeschen, immer ergaenzen** (User-Direktive 2026-05-25 mehrfach)
7. **Vendor-Vollausbau-Disziplin** ([[achsen-vendor-vollausbau]]): pro Achse ALLE Paper-Algorithmen als reale Wrapper mit Original-Code-Bodies (keine Stubs)

### §8.2 Strukturelle Details die heute LIVE sind

1. **5-Schichten W6-Pattern** (`axis_06_allocator/`):
   - `axis_06_allocator_flags.hpp.in` (CMake-Template)
   - `vendor_includes/*_include.hpp` (Shims mit Forward-Stubs)
   - `axis_06_allocator_registry.hpp` (mp_list + mp_filter)
   - Wrapper-Klassen mit `static constexpr bool enabled`
   - Concept-System (Topic + Achse + 6 Sub-Concepts + CE-Permutation)
2. **CMake-Berechnung USE = ENABLE && HAVE** am Ende von CMakeLists.txt
3. **Boost.MP11 via FetchContent** (boost-1.86.0, header-only INTERFACE-Target)
4. **CMake-Flag `COMDARE_CE_ENABLE_STATISTICS=ON|OFF`** schaltet stats/reset komplett aus Production-Binary
5. **`#cmakedefine01` statt `#cmakedefine`** (deterministisch 0/1)
6. **Vendor-Header-Shims** mit Forward-Stubs garantieren dass `if constexpr (false)`-Zweig syntaktisch valide bleibt

### §8.3 Offene Strukturprobleme (Doku §14 + §15, Code spaeter)

§14 (8 Punkte):
1. Migration der bestehenden libs/cache_engine/-Struktur nach topics/+src/ kleinschrittig
2. apps/cache_engine_builder als kompilierbares Tool/Submodule
3. adapters/+ext/ mergen → topics/<topic>/axis_<NN>/vendors/<vendor>/ (Achsen-zentriert)
4. ALLE tools/ als wiederverwendbare Submodules
5. Mess-Strategien als statisch CMake-einstellbare src-Komponenten
6. reclamation/ falsch positioniert → sub_62_reclamation
7. concurrency_manager/* (8 Sub-Verzeichnisse) → topics/concurrency/axis_08/sub_*
8. Sonderfall concurrency: hybrider statisch (SIMD) + dynamisch (Thresholds) Variant-Ansatz

§15 (10 Sektionen):
1. benchmarks/ gehoert ins Mess-Modul + Facade-Pattern
2. Compile-Flag-Strategie revidieren (W6 done — Refactoring done)
3. Statistics-Observer-Pflicht (Stufe 3 angefangen)
4. PermutationEngine-Verknuepfung (F.6.1.D pending)
5. Hybride Laufzeit-Permutation iterable_aspect_t (F.6.1.E pending)
6. Bezug §14.8 Concurrency-Sonderfall
7. TopicConfigSet + CacheEngineBuilder als C++-App
8. Stufe 1+2 LIVE + Stufe 3+ offen
9. min-1-Algorithmus pro Achse Pflicht (F.6.1.H pending)
10. CacheEngineBuilder CLI-Build-Flags (F.6.1.G pending)

## §9 Nuancen-Praezisierungen (kritisch fuer korrekte Implementierung naechste Session)

### §9.1 Stufe 3 Wrapper-Update (F.6.1.I) — 6 konkrete Schritte

Bevor Concept-Constraint im axis_06_allocator_cache_engine_permutation_concept.hpp reaktiviert wird, muessen ALLE 4 Wrapper-Klassen (StdMalloc/Mimalloc/Snmalloc/PMR) updated werden:

```cpp
// Pflicht in jedem Wrapper (wenn STATISTICS=ON):
class <Vendor>Allocator : public AllocatorStrategyBase<<Vendor>Allocator> {
public:
    // ... bestehende Members + Methods ...

#ifdef COMDARE_CE_ENABLE_STATISTICS
    using snapshot_t = concepts::AllocationStatistics;
    using observer_t = ::comdare::cache_engine::measurement::MeasurableObserver<snapshot_t>;

    [[nodiscard]] observer_t const& observer() const noexcept { return observer_; }

    // notify-Calls ergaenzen NACH stats-Update in:
    //   - allocate(): stats_.allocation_count++ ... observer_.notify(stats_);
    //   - deallocate(): stats_.deallocation_count++ ... observer_.notify(stats_);
    //   - zero_allocate(): analog
    //   - reallocate(): analog
private:
    observer_t observer_{};
#endif
};
```

Dann Concept-Reaktivierung im Concept-File: TODO-Block durch echte requires-Klausel ersetzen:
```cpp
#ifdef COMDARE_CE_ENABLE_STATISTICS
    && requires(A a, A const& ac) {
        { ac.statistics() } noexcept;
        { a.reset() }      noexcept;
    }
    && requires {
        typename A::snapshot_t;
        typename A::observer_t;
    }
    && std::same_as<typename A::observer_t,
                    ::comdare::cache_engine::measurement::MeasurableObserver<typename A::snapshot_t>>
    && requires(A const& ac) {
        { ac.observer() } -> std::same_as<typename A::observer_t const&>;
    }
#endif
```

Tests fuer Observer-Notify-Pattern (Callback-Registrierung + Empfang):
```cpp
TEST(V41_TopicAllocatorAxis06, ObserverReceivesNotifyOnAllocate) {
    axis_06::StdMalloc m{};
    auto& obs = m.observer();
    int events = 0;
    obs.on_event([&events](auto const& snap) { ++events; });
    void* p = m.allocate(64, 8);
    EXPECT_EQ(events, 1);
    m.deallocate(p, 64, 8);
    EXPECT_EQ(events, 2);
}
```

### §9.2 PermutationEngine (F.6.1.D) — Skelett-Vorschlag

`src/permutations/permutation_engine.hpp` (NEU):

```cpp
template <class... TopicAxisLists>
class PermutationEngine {
public:
    // F.6.1.H Pflicht (ERGAENZUNG): min-1-Algorithmus pro Achse
    static_assert(
        (boost::mp11::mp_size<typename TopicAxisLists::variants>::value > 0 && ...),
        "PermutationEngine: jede Topic-Achse muss min. 1 enabled Vendor haben. "
        "Pruefe COMDARE_AXIS_<NN>_ENABLE_<VENDOR> CMake-Flags pro Achse."
    );

    // Cartesian Product aller Topic-Achsen-Listen
    using AllPermutations = boost::mp11::mp_product<
        Permutation, typename TopicAxisLists::variants...>;

    // Compile-Time-Visitor-Iteration
    template <typename Visitor>
    constexpr void for_each_permutation(Visitor&& v) const {
        boost::mp11::mp_for_each<AllPermutations>(std::forward<Visitor>(v));
    }

    // Pruefling-spezifische Filterung (V41.F.6.3 Pattern)
    template <typename Pruefling, typename Visitor>
    constexpr void for_each_permutation_for_pruefling(Visitor&& v) const {
        // ... mp_filter ueber Pruefling-spezifische Predicate ...
    }
};
```

### §9.3 iterable_aspect_t (F.6.1.E) — Vendor-Klasse Erweiterung

Wrapper darf optional definieren:
```cpp
struct LockFreeConcurrency {
    // Standard-Pflicht-API ...

    // Optional: Aspekt-Iteration (Hybride Laufzeit-Permutation)
    using iterable_aspect_t = std::size_t;  // threshold N
    static constexpr std::array values{16u, 64u, 256u, 1024u, 4096u};
    static constexpr std::span<std::size_t const> iterable_values() noexcept {
        return values;
    }

    void set_threshold(std::size_t t) noexcept { threshold_ = t; }
private:
    std::size_t threshold_ = 16;
};
```

PermutationEngine erkennt via SFINAE/concept-check ob `iterable_aspect_t != void` → generiert Hybrid (1 Binary statisch, intern Runtime-Loop ueber `iterable_values()`).

### §9.4 CacheEngineBuilder CLI (F.6.1.G) — Workflow-Pattern

```cpp
// apps/cache_engine_builder/main.cpp (Refactor-Skelett)
int main(int argc, char** argv) {
    auto meta_cfg = load_meta_config(argv[1]);  // YAML/JSON Experiment-Strategy + Testdaten-Pfad

    mp_for_each<allocator::AllPermutations>([&]<class P>(P){
        constexpr auto hash = P::hash();
        std::string build_dir = "build/perm_" + to_hex(hash);

        // Construct cmake-Command mit dynamischen Flags pro Permutation
        std::string cmake_cmd = "cmake -B " + build_dir;
        cmake_cmd += " -DCOMDARE_AXIS_06_ENABLE_STD=" + bool_to_onoff(uses<P, StdMalloc>);
        cmake_cmd += " -DCOMDARE_AXIS_06_ENABLE_MIMALLOC=" + bool_to_onoff(uses<P, MimallocAllocator>);
        cmake_cmd += " -DCOMDARE_AXIS_06_ENABLE_SNMALLOC=" + bool_to_onoff(uses<P, SnmallocAllocator>);
        cmake_cmd += " -DCOMDARE_AXIS_06_ENABLE_PMR=" + bool_to_onoff(uses<P, PmrResourceAllocator>);
        // ... weitere Achsen-Flags ...
        std::system(cmake_cmd.c_str());

        // Build pro Permutation
        std::system(("cmake --build " + build_dir + " --config Release").c_str());

        // Permutation-Binary in perm_<hash>.so/.dll → vom Mess-Driver geladen
    });
}
```

### §9.5 USE-Flag-Berechnung am Ende von CMakeLists.txt (heute LIVE)

```cmake
# am Ende von CMakeLists.txt (NACH add_subdirectory(ext))
if(COMDARE_AXIS_06_ENABLE_MIMALLOC AND COMDARE_HAVE_MIMALLOC)
    set(COMDARE_AXIS_06_USE_MIMALLOC 1)
else()
    set(COMDARE_AXIS_06_USE_MIMALLOC 0)
endif()
# ... analog fuer alle Vendor ...
configure_file(... axis_06_allocator_flags.hpp.in ... axis_06_allocator_flags.hpp ...)
```

Im build-pilot (ohne `-DCOMDARE_BUILD_PERMUTATIONS=ON`): `HAVE=0` fuer Mimalloc+Snmalloc, daher `USE=0`, daher `EnabledVendors = mp_list<StdMalloc, PmrResourceAllocator>` (2 statt 4).

### §9.6 Memory-Updates die in der Fortsetzungs-Session geschrieben werden sollten

```markdown
# feedback_min_1_algorithm_per_axis.md
Pro Achse muss min. 1 Algorithmus enabled sein (mp_size<EnabledVendors>::value > 0).
Sonst kann CacheEngineBuilder versehentlich 0-Achsen-Permutationen starten → Build-Crash.
Static_assert achsen-uebergreifend in PermutationEngine.

# feedback_cache_engine_builder_cli_flags.md
CacheEngineBuilder ruft pro Permutation cmake mit dynamischen Build-Flags auf der Kommandozeile:
cmake -B build/perm_<hash> -DCOMDARE_AXIS_<NN>_ENABLE_<V>=ON|OFF
Isolierte Build-Verzeichnisse + Binaries je Permutation, keine separate Config-Datei noetig.

# feedback_observer_konzept_bleibt_pflicht.md
Observer-Konzept ist und bleibt Pflicht-Architektur (User-Klarstellung 2026-05-26).
Concept-Constraint nur temporaer TODO-Marker bis Wrapper-API nachgezogen.
Aktivierung in F.6.1.I: observer_t typedef + observer_ Member + observer() Methode + notify in alloc/dealloc/realloc/zero_alloc.
```

## §10 Cross-Repo-Stand (3 Hauptprojekte)

| Repo | HEAD | Sync mit origin/main |
|------|------|----------------------|
| Diplomarbeit (PUBLIC seit 2026-05-25) | `e94d53e` | ✅ gepushed |
| cache-engine standalone | `5f76072` | ✅ gepushed |
| prt-art | `d1b6140` | ✅ keine Aenderungen seit 2026-05-25 |
| 6 Modul-Skelette | je `e208115..ccec769` | ✅ unveraendert |

Alle Submodule-Bumps in Diplomarbeit konsistent mit verschachtelten Repo-HEADs.

## §11 Verifikations-Build (heute)

```bash
# Standalone cache-engine
cd "C:/Users/benja/OneDrive/Desktop/Projekte/Modules/comdare-cacheengine-all/comdare-cache-engine"
cmake -B build-pilot
cmake --build build-pilot --config Release --target test_v41_topic_allocator_axis_06 -j8
build-pilot/tests/unit/Release/test_v41_topic_allocator_axis_06.exe
# -> [PASSED] 33 tests (Concept-Conformance + Sub-Concepts + Runtime + CRTP-Delegate + Registry-Smoke)

# Diplomarbeit-Container
cd "C:/Users/benja/OneDrive/Desktop/Diplomarbeit - Datenbanken"
bash Code/tools/run_all_tests.sh --config Release
# -> passed: 104, failed: 0
```

## §12 Gesamt-Tasks-Stand nach Session

```
completed: 15 Tasks  (alle V41.A1-A5, B1-B4, E2/E4/E7, F.6.1.D1, W1-W6, F.6.1.C1, F.6.1.U1, F.6.1.C.R1)
in_progress: 3 Tasks (V41.F.1, V41.F.6, V41.F.6.1)
pending: 25 Tasks
```

Davon strukturell wichtig:
- **F-Block:** F.1-F.6 + F.6.0.S1/S2/M/A + F.6.1 (substantielle Architektur-Tasks)
- **F.6.1.D/E/G/H/I:** naechste Code-Tasks (Stufe 3+4 + 3 Ergaenzungen)
- **V42-Block:** P0.1-3 + P1.1-3 (vergessene Features Top-7)
- **E-Block:** E5, E6, E9, E10, E11 (Facade + STATIC/SHARED + nested-cleanup)
- **B-Block:** B2 (YCSB) + B4.1 (MinGW)
- **C/D-Block:** Cluster + Diplomarbeit-Text (extern blockiert / User manuell)

## §13 Session-Bewertung

**Positiv:**
- 12 Code-Commits in cache-engine standalone (substantieller Architektur-Aufbau)
- W6-Pattern komplett umgesetzt (Stufe 1+2), Wrapper-Code wartungsfreundlicher (Wartungskosten O(N) → O(1))
- 2 substantielle Web-Recherchen (W5 + W6) mit konkreten Code-Skeletten
- Doku Master §11_*.md von ~1200 Zeilen auf 1500+ Zeilen erweitert (§13-§15.10 NEU)
- Diplomarbeit-Repo PUBLIC fuer Prof. Habich
- 3 ergaenzende Tasks (#659/#660/#661) sauber dokumentiert + verbunden mit Doku-Sektionen
- 104 Diplomarbeit-Tests durchgehend grün (kein Bruch durch substantielles Refactoring)

**Verbesserungspunkte:**
- Stufe 3 Concept-Erweiterung wurde voreilig ergaenzt (Wrapper noch nicht bereit) → musste zurueck-revertiert werden. Naechste Session: Concept-Aenderungen IMMER ERST mit Wrapper-Updates zusammen pushen
- Test-Bilanz-Off-by-One (103 vs 104) hat eine kurze Sorge ausgeloest — war Mess-Fehler der Test-Runner-Bilanz, NICHT echter Test-Verlust
- Mehrere Build-Fixes (USE vs ENABLE, Include-Pfade, std::aligned_alloc MSVC) haetten frueher antizipiert werden koennen

**Lernerfahrungen:**
- `if constexpr` discarded-statement: Branch ist syntaktisch geprueft, aber Funktionsaufrufe NICHT instantiiert in non-template Funktion — Stubs in vendor_includes/-Shim sind PFLICHT
- `#cmakedefine01` ist deterministisch (0/1), `#cmakedefine` laesst undefined → bricht `inline constexpr bool`
- configure_file MUSS NACH ext/CMakeLists.txt aufgerufen werden wenn ENABLE && HAVE Berechnung gewuenscht ist
- CRTP + Concept-Constraint im Template-Parameter ist Henne-Ei (gestern gelernt, heute weiterhin via static_assert im Konstruktor geloest)

---

**Naechste Session beginnt mit:**
1. MEMORY.md + dieses Doc + `11_konzept_achsen_extension_visitor_pattern.md` lesen
2. Build-Verifikation 33 standalone + 104 Diplomarbeit Tests grün
3. **F.6.1.I Stufe 3** (Wrapper observer_t/observer_/observer() + notify in alloc/dealloc/realloc/zero_alloc + Concept-Reaktivierung + Tests) — HAUPT-PHASE 1
4. **F.6.1.D Stufe 4** (PermutationEngine + EnabledVendors-Konsum + Visitor + Pruefling-Filter) — HAUPT-PHASE 2
5. **F.6.1.E** (iterable_aspect_t Hybride Laufzeit-Permutation Pattern) — HAUPT-PHASE 3
6. **F.6.1.H ERGAENZUNG** (min-1-Algorithmus mp11-Constraint)
7. **F.6.1.G ERGAENZUNG** (CacheEngineBuilder CLI-Build-Flags)
8. Batch 2 Vendor (A05 Jemalloc + A06 TCMalloc + A20 dlmalloc)
