# V41.F.6.1 Stufe 1+2 W6-Pattern — Session-Ende 2026-05-26

**Vorgaenger:** `20260525-V41-F-6-1-architektur-konsolidiert-session-end.md`
**Master-Doc:** `docs/architektur/11_konzept_achsen_extension_visitor_pattern.md` (1500+ Zeilen)

## §1 Was DONE heute (Stufe 1+2 Vendor-Wrapper-Refactoring + W6-Pattern)

| Stufe | HEAD cache-engine | HEAD Diplomarbeit | Tests |
|-------|-------------------|-------------------|-------|
| Batch 1 V1 (mit #ifdef) | 7dff726 | 1aa75a6 | 29/29 + 104/104 |
| Doku §13 (Pilot-Status) | — | 09c4502 | 104/104 |
| W6 Recherche done | — | — | — |
| Doku §14 + §15 (Roadmap) | — | 28300eb + 9da1c60 | 104/104 |
| Doku §15.7 TopicConfigSet+CacheEngineBuilder C++-App | — | 3dcad4b | 104/104 |
| Stufe 1 Infrastruktur (Flags+Registry+Shims) | 2b57e03 | 9b7b5fe | 33/33 + 104/104 |
| Stufe 2 Wrapper-Refactor (if constexpr statt #ifdef) | 2d55de3 | e576f61 | 33/33 + 104/104 |
| Stufe 3 Concept observer_t TODO-Marker | 5f76072 | 8dfe171 | 33/33 + 104/104 |

**Diplomarbeit-Repo public** seit 2026-05-25 fuer Prof. Habich-Mitlesen.

## §2 W6-Pattern (zentralisierte CMake-Topic-Registrierung mit MP11) — LIVE

**5 Schichten umgesetzt:**

1. **CMake-Optionen** `option(COMDARE_AXIS_06_ENABLE_<VENDOR>)` (Default ON, vom User+CacheEngineBuilder ueberschreibbar via CLI)
2. **`axis_06_allocator_flags.hpp.in` configure_file** mit `#cmakedefine01` → `inline constexpr bool <vendor>_enabled = USE_<VENDOR>` (USE = ENABLE && HAVE, am Ende von CMakeLists.txt berechnet nach ext/CMakeLists.txt-Auswertung)
3. **`vendor_includes/<vendor>_include.hpp` Shims** mit Forward-Stubs (einzige #if-Stelle pro Vendor)
4. **`axis_06_allocator_registry.hpp`** mit `AllVendors = mp_list<...>` + `is_enabled<T> = mp_bool<T::enabled>` + `EnabledVendors = mp_filter<is_enabled, AllVendors>`
5. **Wrapper-Klassen** mit `static constexpr bool enabled = flags::<vendor>_enabled` + `if constexpr (enabled)` (KEINE `#ifdef COMDARE_HAVE_*` mehr im Wrapper)

**Wartungskosten pro neuem Vendor:**
- 1 CMake-Option + 1 USE-Berechnung + 1 flag-Eintrag (CMakeLists.txt + flags.hpp.in)
- 1 Vendor-Include-Shim mit Forward-Stubs
- 1 Wrapper-Klasse mit static constexpr enabled
- 1 Registry-Eintrag in `AllVendors` mp_list

## §3 Offene Aufgaben (Naechste Session)

**Tasks (pending, in Reihenfolge):**

| # | Task | Beschreibung |
|---|------|--------------|
| 657 | F.6.1.D PermutationEngine mit Topic-System | `src/permutations/permutation_engine.hpp`: EnabledVendors-Konsum + Visitor + Pruefling-Filter |
| 658 | F.6.1.E iterable_aspect_t | Hybride Laufzeit-Permutation (Concurrency-Thresholds als Span im Wrapper, Runtime-Loop) |
| 659 | F.6.1.H min-1-Algorithmus pro Achse | mp11 static_assert achsen-uebergreifend (vermeidet Build-Crash bei 0-Variants) |
| 660 | F.6.1.I Wrapper-Observer + Concept-Reaktivierung | observer_t typedef + observer_ Member + observer() Methode + notify in alloc/dealloc/realloc/zero_alloc + Concept-Reaktivierung + Tests |
| 661 | F.6.1.G CacheEngineBuilder CLI | apps/cache_engine_builder Refactor: `cmake -B build/perm_<hash> -DCOMDARE_AXIS_<NN>_ENABLE_<V>=...` pro Permutation |

**Batch 2+ Vendor-Vollausbau (PENDING):**
- Batch 2: A05 Jemalloc + A06 TCMalloc + A20 dlmalloc
- Batch 3-8: A01/A02/A03 + A08-A21/A23 (User-Direktive: alle 23 Vendor in Batches a 3 mit Review-Pause)

**Roadmap §14 + §15 (Doku-only, Code spaeter):**
- §14.1-§14.8: Migration der bestehenden libs/cache_engine/-Struktur nach topics/+src/, apps/cache_engine_builder als Submodule, adapters/+ext/ mergen, modules/tools/-Konsolidierung, Mess-Strategien-CMake-Flag, reclamation/ richtig positionieren, concurrency_manager/* → topics/concurrency/, hybride concurrency Variant-Strategie
- §15.1-§15.10: benchmarks/ → Mess-Modul-Facade, Compile-Flag-Strategie (W6 done), Statistics-Observer-Pflicht (Stufe 3 angefangen), PermutationEngine-Verknuepfung, iterable_aspect_t, §14.8-Bezug, TopicConfigSet+CacheEngineBuilder, Stufe 1+2 live + Stufe 3+ offen, min-1-Algorithmus-Pflicht, CLI-Build-Flags

## §4 Wichtige User-Direktiven (Memory-relevant)

- **Observer-Konzept BLEIBT Pflicht-Architektur** (User-Klarstellung 2026-05-26) — Aktivierung in F.6.1.I, nicht gestrichen
- **Pro Achse min. 1 Algorithmus Pflicht** (User-Direktive 2026-05-26) — sonst Build-Crash via CacheEngineBuilder
- **USE-Flags via CacheEngineBuilder CLI** (User-Direktive 2026-05-26) — `cmake -B build/perm_<hash> -DCOMDARE_AXIS_<NN>_ENABLE_<V>=ON|OFF`
- **CacheEngineBuilder ist C++-App, NICHT CMake-Script** (§15.7) — Meta-Konfiguration + Experiment-Strategy + Testdaten getrennt von Binary-Implementation
- **Statisch vs Dynamisch klar getrennt** (§15.7) — statische Permutationen via CacheEngineBuilder, dynamische Permutationen via iterable_aspect_t innerhalb Binary
- **Achsen-Vendor-Vollausbau** ([[achsen-vendor-vollausbau]]) — pro Achse ALLE Paper-Algorithmen als reale Wrapper mit Original-Code-Bodies
- **Naming-Konvention Achsen-Files** ([[naming-convention-axis-files]]) — `axis_<NN>_<topic>_<inhalt>.hpp` Schema, grep-findbar

## §5 Pflicht-Pre-Reads naechste Session

1. **`docs/architektur/11_konzept_achsen_extension_visitor_pattern.md`** (Master, 1500+ Zeilen)
2. **`docs/sessions/20260526-V41-F-6-1-stufe-1-2-w6-pattern-session-end.md`** (dieses Dokument)
3. **`docs/sessions/20260525-V41-F-6-1-architektur-konsolidiert-session-end.md`** (gestrige Session)
4. **`MEMORY.md`** (immer)
5. **Tasks #657-#661** als naechste Code-Schritte

## §6 Naechste-Session Erste Schritte

1. Build-Verifikation (33 standalone + 104 Diplomarbeit Tests gruen)
2. F.6.1.I Stufe 3 fertigstellen: Wrapper observer_t + observer() + notify + Concept-Reaktivierung
3. F.6.1.H min-1-Algorithmus mp11-Constraint in PermutationEngine
4. F.6.1.D PermutationEngine + EnabledVendors-Konsum
5. F.6.1.E iterable_aspect_t Pattern
6. Batch 2 Vendor (A05/A06/A20)

## §7 Cross-Repo-Stand

| Repo | HEAD | Status |
|------|------|--------|
| comdare-cache-engine | `5f76072` | Stufe 3 Concept-TODO, ready fuer F.6.1.I |
| probst-Diplomarbeit-cache-engine | `8dfe171` | Submodule-Bump + Doku, PUBLIC |
| comdare-prt-art | `d1b6140` | UNVERAENDERT seit 2026-05-25 |

Alle 3 Haupt-Repos in sync mit origin/main.

## §8 Tests-Bilanz

```bash
# cache-engine standalone (build-pilot)
build-pilot/tests/unit/Release/test_v41_topic_allocator_axis_06.exe
# -> 33/33 PASSED (Concept + Sub-Concepts + Runtime + CRTP + Registry-Smoke)

# Diplomarbeit-Container
bash Code/tools/run_all_tests.sh --config Release
# -> passed: 104, failed: 0
```
