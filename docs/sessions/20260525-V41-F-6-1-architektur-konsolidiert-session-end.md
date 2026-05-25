# V41.F.6.1 Session-Ende-Doku — Architektur-Konsolidierung 2026-05-25 (abendlich)

**Stand:** 2026-05-25 spaeter Abend, Kontext-Ende-Push
**Vorgaenger:** `20260525-V41-session-end-context-exhausted.md` (Morgen-Session) + `20260524-V41-open-todos.md`
**Zweck:** Elaborate Session-Doku gemaess Memory-Direktive (95%-Context-Verbrauch). Substantielle Architektur-Konsolidierung von V41.F.6.0 + V41.F.6.1, alle 15 RQ vom User beantwortet, W1/W2/W3/W4 Web-/Audit-Recherchen abgeschlossen, finale Topic-Hierarchie validiert. NAECHSTE Session kann mit F.6.1.A Pilot-Code starten.

---

## §1 Session-Zusammenfassung 2026-05-25 (abendlicher Block)

Heute fand eine substantielle **Architektur-Konsolidierungs-Session** statt. Drei Architektur-Fehler vom Tag wurden erkannt + korrigiert, drei Web-Recherchen + ein Doku-Audit-Agent liefen parallel, alle 15 User-Rueckfragen wurden beantwortet, die finale 15-Topic-Hierarchie wurde validiert. **Keine Code-Aenderungen in cache-engine oder prt-art** — die Session war reine Architektur-Klaerung VOR Code-Migration.

**Schluessel-Ereignisse chronologisch:**

1. Start mit V41.F.6.0 Audit (43 prt-art Headers klassifiziert: 27 BASIS + 6 SPEZIFISCH + 9 Indikator-Marker + 2 Stubs)
2. Falsche Implementierung von 2 traversal/-Stubs als Monolith mit std::variant + Runtime-Switch
3. **User-Korrektur 1:** "Wir muessen erst nach Cache Engine migrieren und dann davon ableiten" + "statische Metaprogrammierung" + "concept System"
4. Rollback der falschen Stubs auf V32.DD.2-Skelett-Zustand
5. Architektur-Skizze `docs/architektur/11_konzept_achsen_extension_visitor_pattern.md` geschrieben mit 4 Fragen
6. **User-Antworten 1-4:** CRTP+Concept-Mix, ERSETZT-mit-Fallback, KEIN axes/-Verzeichnis (Topics enthalten Achsen), Pilot 3.A
7. **User-Korrektur 2:** "Bitte lies die letzte Dokumentation mit hoechster Praezision: 2-Ebenen-Architektur, Themen + Achsen parallel"
8. **User-Korrektur 3:** RQ-9 — "Es gibt KEINE default_variants/ und KEINE optional_prt_art_impl/ Verzeichnisse. Cache-Engine + prt-art mit identischer Topics-Struktur, prt-art als Namespace-Slot"
9. Konsolidierung Doku §3 + §3.5 + §3.6 mit allen User-Antworten + 9 neue Detail-RQ-1..RQ-9
10. 4 parallele Agents gestartet: W1 (C++23 Modules + cmake), W2 (Buffer-Strategien), W3 (Scheduling pro Topic), W4 (Doku-Audit vergessene Features)
11. UML REV7 + Submodule-Check + bestehende libs/cache_engine-Inspektion parallel
12. Konsolidierung §11 (W1/W2/W3/UML/bestehende Struktur) + §12 (W4 vergessene Features)
13. **User-Antworten RQ-10..RQ-15** beantwortet — finale 15 Topics + Mapping validiert
14. Doku finalisiert mit §11.7 FINALE Topic-Liste + §11.7.C Mapping bestehend→neu
15. 6 V42-Tasks fuer P0/P1 vergessene Features angelegt

## §2 DONE heute (abendlicher Block, nach Morgen-Session)

### V41.F.6.0 Audit-Phase
- **V41.F.6.0** Single-File-Audit aller 43 prt-art Headers (vs urspruenglich behauptete 47)
  - 27 BASIS-Klassifikation (63%) — vollstaendig implementiert, generisch
  - 6 SPEZIFISCH (14%) — identity/ + Registry, sind genuine Pruefling-Adapter
  - 9 Indikator-Marker (21%) — default_lookup/prt_art_*_default.hpp, Existenz signalisiert Auto-Permutation
  - 2 DEPRECATED Stubs (5%) — traversal/{search_algo_traversal,traversal_mapping}.hpp V32.DD.2 leer-Skelett
- **V41.F.6.0b** Open-TODOs-Doc korrigiert: 43 Header statt 47, mit Tabellen-Update + Migration-Klassifikation

### V41.F.6.0 Fehler + Korrektur
- Falsche Implementation traversal/-Stubs als Monolith mit std::variant + Switch (DYNAMISCH)
- Falsche Reihenfolge: direkt in prt-art geschrieben ohne cache-engine-Basis (Vererbungs-Grundlage fehlt)
- **Rollback:** beide Files auf V32.DD.2-Skelett zurueckgesetzt, Tests-File entfernt, CMakeLists revertiert
- Doku-Korrektur §3.3.5 dokumentiert Fehler + korrekte Migrations-Reihenfolge

### V41.F.6.1 Architektur-Skizze
- `docs/architektur/11_konzept_achsen_extension_visitor_pattern.md` erstellt (350+ → 833+ Zeilen)
- 4 initiale Fragen → 4 User-Antworten → 9 neue Detail-RQ → 6 User-Antworten → finale 15-Topic-Hierarchie
- Wechsel von "axes/-Verzeichnis"-Modell zur "Topics enthalten Achsen direkt"-Hierarchie
- 3-Stufen-Pruefung (CE-only / Pruefling-einzeln / Full Join Multi-Pruefling) konkretisiert
- CRTP + Concept-Guard Mix-Pattern dokumentiert
- 7 Scheduling-Sub-Achsen pro Topic (statt monolithische c11 Scheduler-Engine)
- Achse "queuing" neu (13 W2-Strategien × 6 Sizes = 38 valide Permutationen)

### Web-/Audit-Recherchen (4 Agents parallel)
- **W1** (`agentId a095a582ba607046c`): C++23 Modules + cmake — Verdikt: NICHT echte Modules, `configure_file` Master-Header + INTERFACE-Target + `requires`-Concept-Detection
- **W2** (`agentId a7ac4ec1a15ccfdf9`): Buffer-Strategien — 13 Strategien Q-NONE..Q-MPMC mit Cross-Allocator-Constraints
- **W3** (`agentId a976ecdd14ff3c223`): Scheduling pro Topic — 7 Sub-Achsen, Cross-Topic-Constraints, 10 Paper-Referenzen
- **W4** (`agentId ae7f007ebe27b366c`): Doku-Audit vergessene Features — 8 P0/P1 Features identifiziert (H1/H2/H3, V1-V4, IPlatformProbe, comdare-succinct/rcu/hbm, Hybrid-Commands K3.4, Reproduzierbarkeit, D10-D13, Cluster F Habich)

### Doku-Konsolidierung
- §11.1-§11.5 W1/W2/W3 + UML REV7 + Allokator-AA1-AA7
- §11.6 Mapping bestehende libs/cache_engine/* → neue Topics+Achsen
- §11.7 6 RQ-10..RQ-15 beantwortet, finale 15 Topics validiert
- §11.7.A Finale Topic-Liste mit allen Sub-Achsen
- §11.7.B Finale src/-Hilfsfunktionen
- §11.7.C Mapping bestehender Pfade final
- §11.8 F.6.1.A Pilot-Code (Topic allocator/axis_06/sub_61_alloc_lib mit 3 Mechaniken)
- §12 W4-Audit ergebnisse (8 P0/P1 + 9 Optional + 3 Architektur-Patterns + Top-7-Empfehlung)

### Tasks
- 13 neue Tasks angelegt (#636-#648):
  - V41.F.6.0.S1/S2/M/A (4 Sub-Tasks der F.6.0)
  - V41.F.6.1 Voraussetzungs-Task (#640)
  - V41.F.6.1.D1/W1/W2/W3/W4/C1/U1 (7 Recherche/Doku-Tasks)
  - V42.P0.1/P0.2/P0.3 (3 KRITISCHE vergessene Features)
  - V42.P1.1/P1.2/P1.3 (3 WICHTIGE vergessene Features)
- Status: 8 completed, 5 in_progress oder pending

## §3 Wichtige Commits (Diplomarbeit-Container, abendlicher Block)

| Commit | Beschreibung |
|--------|--------------|
| `7817b77` | V41.F.6.1 Doku §11.7: FINALE Topic-Liste + Mapping (alle 15 RQ beantwortet) |
| `5c42917` | V41.F.6.1 Doku §11+§12: W1/W2/W3/W4 Konsolidierung + vergessene Features |
| `339e383` | V41.F.6.1 Skizze: User-Antworten konsolidiert + 9 neue Detail-Rueckfragen |
| `eed0001` | V41.F.6.1 Architektur-Skizze: 2-Ebenen-Achsen + Pruefling-Namespace + Visitor |
| `f8cb9bb` | V41.F.6.0 Audit-Doku: Korrektur Migrations-Reihenfolge + Pattern |
| `459f2cc` | V41.F.6.0 Single-File-Audit aller 43 prt-art Headers + F.6.0b TODO-Korrektur |

**Keine Code-Commits in cache-engine oder prt-art heute** (3 Repo HEADs unveraendert seit Morgen-Session).

## §4 Designentscheidungen heute (User-Direktiven konsolidiert)

### §4.1 Architektur-Vision: cache-engine + prt-art mit gespiegelter Topics-Struktur

```
comdare-cache-engine (Master-Framework, Basis-Implementierungen)
    libs/cache_engine/topics/<topic>/<axis>/      (z.B. allocator/axis_06/)
        cache_engine-Default-Implementierungen
                                |
                                | Compile-Time-Detection
                                v
                         ggf. prt_art-Namespace-Slot
                                ^
                                |
comdare-prt-art (Pruefling, Erweiterungen)
    include/prt_art/extensions/<topic>_<axis>.hpp
        namespace comdare::cache_engine::<topic>::<axis>::prt_art {
            struct PrtArtAccelXxx { ... };
            using PruefingVariants = AxisVariantList<PrtArtAccelXxx>;
        }
```

cache-engine kennt prt-art NICHT direkt. Pruefling injiziert sich via `configure_file` Master-Header + INTERFACE-Target + `COMDARE_CE_PRUEFLINGE` CMake-Liste.

### §4.2 3-Stufen-Pruefungs-Modell (User-Praezisierung)

**WICHTIGE NUANCE:** Pruefling != Pruefling-Binary
- **Pruefling** = ein KOMPLETTES Projekt-Repo (z.B. prt-art) mit eigener Achsen-Permutations-Erweiterung
- **Pruefling-Binary** = ein einzelner Build einer Rekombination als .so/.dll C++23-Modul
- Pro Pruefling entstehen ZEHNTAUSENDE Pruefling-Binaries (default static, dynamic geladen in CacheEngineBuilder)

```
Stufe 1 — cache-engine-only:
    EffectiveVariants = nur cache-engine-Defaults (kein Pruefling)
    Target: comdare_perms_ce
    BUILD: zehntausende CE-Rekombinations-Binaries

Stufe 2 — Pruefling EINZELN (pro Pruefling separater Build):
    fuer prt-art:
        EffectiveVariants pro Achse =
            wenn (prt-art::PruefingVariants in dieser Achse existiert)
                -> PrtArtVariants  (ERSETZT Default komplett)
            sonst
                -> DefaultVariants (Compile-Time-Fallback transparent)
    Target: comdare_perms_pa, comdare_perms_<pruefling2>, ...
    BUILD: zehntausende Pruefling-Rekombinations-Binaries pro Pruefling

Stufe 3 — Full Join Multi-Pruefling:
    EffectiveVariants = DefaultVariants ∪ Pruefling1 ∪ Pruefling2 ∪ ... (non-redundant)
    Target: comdare_perms_full_join (MUSS NEU GEBAUT WERDEN — existierendes comdare_perms_all
            ist heute nur Aggregator, NICHT echtes Kartesisches Produkt!)
    BUILD: zehntausende mal mehr Binaries
```

### §4.3 CRTP + Concept-Guard MIX-Pattern (User-Antwort 1)

```cpp
// Topic-Ebene Concept (breit)
namespace comdare::cache_engine::allocator::concepts {
    template <typename T>
    concept AllocatorComponent = requires(T t) {
        { t.allocate(std::size_t{}) } -> std::same_as<void*>;
        { t.deallocate((void*)nullptr) } -> std::same_as<void>;
    };
}

// Achsen-Ebene Concept (eng, erweitert Topic-Concept)
namespace comdare::cache_engine::allocator::axis_06::concepts {
    template <typename T>
    concept AllocatorStrategy = AllocatorComponent<T> && requires(T t) {
        { t.pool_kind() } -> std::convertible_to<PoolKind>;
        { t.bytes_in_use() } -> std::same_as<std::uint64_t>;
    };
}

// CRTP-Basis-Klasse mit Concept-Guard
namespace comdare::cache_engine::allocator::axis_06 {
    template <typename Derived>
        requires concepts::AllocatorStrategy<Derived>
    class AllocatorStrategyBase {
        void* allocate(std::size_t bytes) {
            return static_cast<Derived*>(this)->allocate_impl(bytes);
        }
        // ... Default-Methoden via CRTP-Inlining
    };
}
```

Jeder Ordner + Unterordner hat **genau EIN File** fuer alle Concepts des Suchraums (User-Direktive).

### §4.4 ERSETZT-mit-Compile-Time-Fallback Override-Logik (User-Antwort 2)

Pro Achse: wenn Pruefling-Sub-Namespace `prt_art` definiert ist und `PruefingVariants` enthaelt, wird die gesamte cache-engine-Default-Variant-Liste durch die Pruefling-Variants ERSETZT. Wenn Pruefling die Achse nicht ueberschreibt, faellt cache-engine-Default als komplette Variant-Liste ein (transparent zur Compile-Time).

### §4.5 KEINE `axes/`-Verzeichnis, KEINE `default_variants/`, KEINE `optional_prt_art_impl/` (User-Antworten 3 + 9)

**Was es NICHT gibt (User-Direktiven):**
- `libs/cache_engine/axes/` als Verzeichnis (Achsen leben IN Topics)
- `default_variants/` als Verzeichnis (Default-Klassen liegen direkt im Achsen-Verzeichnis)
- `optional_prt_art_impl/` als Verzeichnis (Pruefling-Code lebt im prt-art-Repo unter Sub-Namespace `prt_art`)

**Was es GIBT:**
- `libs/cache_engine/topics/<topic>/` mit mind. 1 Achse als Unterordner
- `libs/cache_engine/topics/<topic>/axis_<N>_<name>/` mit Klassen-Files direkt drin
- `libs/cache_engine/src/<hilfsfunktion>/` fuer achsenfreie Hilfsfunktionen
- `comdare-prt-art/include/prt_art/extensions/<topic>_<axis>.hpp` mit Sub-Namespace `prt_art`

### §4.6 Scheduling als 7 Sub-Achsen pro Topic (User + W3)

Statt monolithisches `subsystems/c11_scheduler_engine/`: **pro Topic eine eigene Scheduling-Sub-Achse als Permutationsfaktor.**

| Topic | Scheduling-Sub-Achse | Varianten |
|-------|---------------------|-----------|
| `queuing` | `buffer::flush_policy` | eager_per_op / threshold_watermark / time_window / lazy_on_evict / adaptive_lsm |
| `concurrency` | `concurrency::scheduler_topology` | per_core_pinned / work_stealing_global / work_stealing_numa_neighbor / hybrid_p_e_split / coroutine_stackless / coroutine_stackful / learned_pmoss |
| `io` | `io::dispatch_policy` (= axis selbst) | in_memory_only / sync_spill / async_io_uring_batch / read_ahead_tuned / cooling_classified |
| `prefetch` | `prefetch::interleave_depth` | none / single_lookahead_1 / group_prefetch_8 / coroutine_suspend_resume / amac_async_4 / adaptive_distance |
| `allocator` | `allocator::pool_resize_policy` | eager_preallocate / lazy_first_use / hwm_watermark_75 / oom_reactive / prediction_driven |
| `telemetry` | `telemetry::collection_rhythm` | disabled / push_per_op / pull_5s / pull_60s / adaptive_sampled / hardware_pmu_driven |
| `codegen` (Build-Time, src/) | `codegen::permutation_emit_order` | lexicographic_serial / parallel_per_topic / dependency_dag_topological / hotpath_first_pgo |

### §4.7 Implementations-Mechanik (W1)

Echte C++23 Modules sind NICHT geeignet (Kopplungs-Anforderung). Stattdessen 3-fache Mechanik:

```cmake
# 1. prt-art INTERFACE-Target mit Custom-Property
add_library(comdare_ce_prueflinge_prt_art INTERFACE)
target_include_directories(comdare_ce_prueflinge_prt_art INTERFACE include)
set_property(TARGET comdare_ce_prueflinge_prt_art APPEND PROPERTY
    INTERFACE_COMDARE_CE_PRUEFLING_HEADERS
        "prt_art/extensions/allocator_axis_06.hpp"
        "prt_art/extensions/traversal_axis_03a.hpp")

# 2. cache-engine generiert Master-Header
foreach(tgt IN LISTS COMDARE_CE_PRUEFLINGE)
    get_target_property(h ${tgt} INTERFACE_COMDARE_CE_PRUEFLING_HEADERS)
    foreach(hdr IN LISTS h)
        string(APPEND CE_INCS "#include \"${hdr}\"\n")
    endforeach()
endforeach()
configure_file(prueflinge_includes.hpp.in ${CMAKE_BINARY_DIR}/generated/comdare/ce/prueflinge_includes.hpp @ONLY)
```

```cpp
// 3. cache-engine C++23 concept-Detection
#include <comdare/ce/prueflinge_includes.hpp>  // auto-generiert, evtl. leer

namespace comdare::cache_engine::allocator::axis_06 {
    template <typename = void>
    concept has_prt_art_variants = requires {
        typename prt_art::PrueflingVariants;
    };

    using EffectiveVariants = std::conditional_t<
        has_prt_art_variants<>,
        typename prt_art::PrueflingVariants,
        DefaultVariants>;
}
```

### §4.8 Mess-Praezision (User-Direktive bestaetigt)

- Zielsysteme (HPC ZIH, Bare-Metal mit CPU-Pinning, Intel PMU + Kernel-Mode-Sampling): ±0.1% Praezision
- 5% Allokator-Unterschied = wissenschaftlich publizierbarer Beweis, KEIN Stichprobenrauschen
- Dynamic Loading via dlopen erzeugt Lade-Latenzen → SHARED Permutations-Binaries muessen INTERN STATIC sein (V41.E10)
- Welch's t-Test (V41.B3) ist Pflicht-Tool fuer Signifikanz-Pruefung

## §5 Aktuelle Repo-Stand (3 Hauptprojekte + 6 Submodule-Repos)

| Repo | HEAD | Aenderung heute (abendlicher Block) |
|------|------|-------------------------------------|
| Diplomarbeit | `7817b77` | 6 Doku-Commits, KEINE Code-Aenderungen |
| cache-engine | `2eb21d6` | UNVERAENDERT seit Morgen-Session |
| prt-art | `d1b6140` | UNVERAENDERT seit Morgen-Session |
| comdare-search-engine | `3c9aeeb` | Skelett (V41.E4) |
| comdare-cache-engine-core | `e208115` | Skelett (V41.E4) |
| comdare-measurement | `e2d4b0d` | Skelett (V41.E4) |
| comdare-isa-dispatch | `e26490d` | Skelett (V41.E4) |
| comdare-build-tools | `e18ef8b` | Skelett (V41.E4) |
| comdare-test-system | `ccec769` | Skelett (V41.E4) |

**Tests:** 104 passed, 0 failed (letzte Verifikation Morgen-Session, durch Doku-Aenderungen nicht betroffen)

## §6 Konsistenz-Audit (heute durchgefuehrt)

- ✅ 4 Web-/Audit-Agents fertig (W1/W2/W3/W4)
- ✅ Alle 15 RQ vom User beantwortet (4 initiale + 9 RQ-1..RQ-9 + 6 RQ-10..RQ-15)
- ✅ Doku §11.7.C Mapping bestehende libs/cache_engine/* → 15 Topics + src/ validiert
- ✅ 6 V42-Tasks fuer P0/P1 vergessene Features angelegt
- ✅ 6 Doku-Commits gepushed (kein offener Stand)
- ✅ Cross-Sync prt-art ↔ cache-engine ↔ Diplomarbeit konsistent (3 Repos UNVERAENDERT)
- ⚠ KEINE Code-Aenderungen — naechste Session muss F.6.1.A Pilot-Code beginnen
- ⚠ comdare-cache-engine bestehende Struktur (12 Subsystems + 14 Allocator-Familien + 8 Concurrency-Disziplinen + 22 Builder-Komponenten) ist MASSIV — Migration nach 15 Topics ist 50-100 git mv Operationen
- ⚠ prt-art-Repo braucht eigene Namespace-Restrukturierung (von `comdare::prt_art::*` zu `comdare::cache_engine::<topic>::<axis>::prt_art::*`)
- ⚠ Stufe 3 Full-Join Multi-Pruefling NICHT in V41 — `comdare_perms_all` heute nur Aggregator, muss neu gebaut werden

## §7 Naechste Aufgaben (priorisiert fuer Fortsetzungs-Session)

### Pflicht-Pre-Reads (vor Code-Start)
1. **`docs/architektur/11_konzept_achsen_extension_visitor_pattern.md`** komplett (833+ Zeilen, ist DAS Master-Dokument)
2. **`docs/sessions/20260525-V41-F-6-1-architektur-konsolidiert-session-end.md`** (dieses Dokument)
3. **`docs/sessions/20260525-V41-F-6-0-prt-art-header-audit.md`** (Audit-Klassifikation)
4. **`docs/termine/20260508 Termin 7/Phase5_UML_Detail/24_architektur_skizze_REV7_2026_05_13.md`** §1-§9 (3-Schichten-Hierarchie + Variadic-Template + Fingerprint + AA1-AA7)
5. **`MEMORY.md`** (immer)
6. **Web-Recherchen-Ergebnisse aus §11.1-§11.3 + §12** (W1/W2/W3/W4 in der Doku)

### Quick-Wins (≤30min)
- Memory-Updates: neue `feedback_topic_axis_pruefling_namespace_pattern.md` + `feedback_no_optional_pruefling_impl_directory.md`
- TaskUpdate fuer #628 V41.F.1 in_progress → completed (Audit ist abgeschlossen)

### Mittlere Schritte (1-3h)
- **F.6.1.A Pilot** Topic `allocator/axis_06/sub_61_alloc_lib` mit 3 Mechaniken (configure_file + INTERFACE-Target + concept-detection) - siehe §11.8
- **F.6.1.E** `src/permutations/` mit PermutationVisitor + AxisVariantList + cartesian_product_t (W1-Pattern)

### Substantielle Bloecke (mehrere Sessions)
- **F.6.1.C** 7 Scheduling-Sub-Achsen pro Topic nach W3-Empfehlung
- **F.6.1.B** Q-Achse `queuing/` neu anlegen mit W2-Strategien
- **F.6.1.D** Mapping bestehender libs/* → topics/* per git mv schrittweise (104 Tests gruen halten — kritisch!)
- **F.6.1.G** Rollout auf 14 weitere Topics (15 insgesamt)
- **F.6.2** Migration der 27 BASIS-Files (Klassen, Tests, Includes)
- **F.6.3** prt-art-Namespace-Restrukturierung (von `comdare::prt_art::*` zu `comdare::cache_engine::<topic>::<axis>::prt_art::*`)
- **F.6.4** Tests umbiegen (51 prt-art-Tests + 104 cache-engine-Tests)
- **F.6.5** messung_driver + Codegen anpassen
- **F.6.6** Build-Verifikation + alle Tests gruen
- **F.6.7** Research-Clone aufraeumen

### V42 (nach F.6.x)
- **V42.P0.1** H1/H2/H3 Hypothesen als formale Mess-Achse pro Permutation
- **V42.P0.2** V1-V4 Engine-Choice-Dimension in Codegen (Meta-Achse)
- **V42.P0.3** IPlatformProbe Auto-Discovery + Live-Tuning
- **V42.P1.1** comdare-succinct Modul (SDSL-Lite C++23-Portierung)
- **V42.P1.2** comdare-rcu eigene Implementation
- **V42.P1.3** HBM Abstract Factory + Cache-Hierarchy-Manager

### Blockiert / extern
- V41.B4.1 MinGW Cross-Compiler-Matrix (wartet auf ESET-Bestaetigung)
- V41.C1+C2 Cluster-Tasks (wartet Cluster-Termin)
- V41.D1+D2 Diplomarbeit-Text (User schreibt manuell)

## §8 Wichtige Erkenntnisse (kritisch fuer Fortsetzungs-Session)

### §8.1 Architektur-Patterns die NICHT zu verletzen sind

1. **TODOs NIE loeschen, immer ergaenzen** (User-Direktive 2026-05-25 mehrfach)
2. **Migrations-Reihenfolge:** cache-engine zuerst (Basis), prt-art danach (Ableitung). NICHT umgekehrt!
3. **Statische Metaprogrammierung Pflicht** — KEIN std::variant + Runtime-Switch
4. **3-Schichten Layer-Provider-Rollen** (UML REV7 §4.2(f)):
   - SearchEngine darf NIEMALS direkt CacheEngine-Bausteine konsumieren
   - ExecutionEngine darf KEINE Such-spezifischen Patterns kennen
   - Pruefling-SearchEngine kann eigene Patterns hinzufuegen, faellt aber per Compile-time-Fallback auf ExecutionEngine zurueck
5. **Pro Ordner + Unterordner genau EIN Concept-File** (User-Direktive)
6. **Pruefling != Pruefling-Binary** — Pruefling = Repo, Binary = pre-built Rekombination
7. **Mess-Praezision Zielsystem ±0.1%** — alle Aussagen darauf beziehen

### §8.2 Strukturelle Details die in §11 dokumentiert aber subtil sind

1. **`prt_art` als Sub-Namespace** (NICHT `optional_prt_art_impl`): User-Korrektur RQ-9. Mechanik: `requires { typename Namespace::prt_art::PrueflingVariants; }`
2. **Topic-Concept + Achsen-Concept beide** parallel (User-Antwort RQ-1)
3. **ERSETZT-mit-Fallback (NICHT ERWEITERT)** pro Achse (User-Antwort RQ-2 zu Frage 2)
4. **Mehrere Prueflinge moeglich** (multipler Pruefling = multiple INTERFACE-Targets in `COMDARE_CE_PRUEFLINGE` CMake-Liste)
5. **W1 KRITISCH:** Echte C++23 Modules NICHT geeignet, configure_file + INTERFACE-Target + concept-detection (3-fach)
6. **Achse 13 Scheduling ZERLEGT** in 7 Sub-Achsen pro Topic (User + W3-Recherche)
7. **15 Topics statt 14:** queuing/hardware/search_engine/io/migration/filter sind NEU
8. **default_lookup, identity, measurement gehoeren zu src/** (RQ-4, RQ-5, RQ-6 User-Antworten — sind CacheEngineBuilder-Domaene, KEINE Topics)
9. **internal_search/ wird Sub von traversal/axis_03a/** und KANN GELOESCHT werden (RQ-7)
10. **5 Klassifikationen** im Bausteine-Matrix-Migration-Plan: BASIS / SPEZIFISCH / Indikator-Marker / Deprecated-Stub / Hilfsfunktion

### §8.3 Vergessene Features (W4) die V42 oder spaeter brauchen

**KRITISCH (P0):**
- H1/H2/H3 Hypothesen-Mess-Achse pro Permutation (Diplomarbeit-Resultat)
- V1-V4 Engine-Choice-Multiplikation (F15-Forschungsmission)
- IPlatformProbe Auto-Discovery (K3.2, Plattform-Kalibrierung)

**WICHTIG (P1):**
- comdare-succinct (F3: SDSL-Lite C++23)
- comdare-rcu eigene Impl (F2)
- HBM Abstract Factory (F4)
- Hybrid-Command-Pattern K3.4 (12+ Aufloesungen)
- Reproduzierbarkeits-Slots (Seeds + RunMetadata.config_hash)
- D10-D13 Permutationsdimensionen (Suchtyp-Reihenfolge, Dichte-Schwellen, Fingerprint-Filter, Serialization-Wahl)
- Dataset-Permutations-Achsen (F6/F7/F8 Zipf-Theta/Mixed-Length/Prefix)
- Cluster F TUD-Habich iDMA + Strided (P31/P32)

**KRITISCH FEHLEND (Architektur-Patterns):**
- IExecutingEngine-Wurzel ueber ISearchEngine (K3.1)
- Multi-Pruefling-Faehigkeit (Stufe 3 echtes Kartesisches Produkt)
- ABI-stabiles C++23-Modul-Interface als POD-ABI

## §9 Nuancen-Praezisierungen (kritisch fuer korrekte Implementierung)

### §9.1 Pruefling vs Pruefling-Binary — Build-Workflow-Auswirkung

```
Pruefling (prt-art) als Projekt:
    1 Repo
    N Achsen-Erweiterungen (Header-Files pro Topic/Achse)
    1 INTERFACE-Target `comdare_ce_prueflinge_prt_art`

Pruefling-Binaries (von der CacheEngineBuilder zur Build-Time generiert):
    pro Achs-Permutation eine .so/.dll
    Beispiel: cache-engine 15 Topics × Sub-Achsen × Varianten = zehntausende Permutationen
              × jeder Pruefling = noch mehr
    Default: STATIC interne Linking + SHARED extern (V41.E10)
    Dynamisch geladen via C++23-Modul-Feature in CacheEngineBuilder
```

**Storage-Volumen-Konsequenz:** Medium-Profile (~290 Permutationen × 1-5MB) ~0.3-1.5GB. Full-Profile (zehntausende) GB-Storage-Strategie. ZIH-Cluster ist die Mess-Plattform.

### §9.2 prt-art-Repo Namespace-Restrukturierung (substantielle Migration)

**Heute (vor F.6.3):**
```
comdare-prt-art/
├── prt_art/include/prt_art/identity/          # comdare::prt_art::identity::*
├── prt_art/include/prt_art/allocator/         # comdare::prt_art::allocator::*
├── prt_art/include/prt_art/traversal/         # comdare::prt_art::traversal::*
└── ... 14 Achsen-Verzeichnisse, alle in comdare::prt_art::*
```

**Soll (nach F.6.3):**
```
comdare-prt-art/
├── prt_art/include/prt_art/extensions/        # NEU
│   ├── allocator_axis_06.hpp                  # namespace comdare::cache_engine::allocator::axis_06::prt_art {...}
│   ├── traversal_axis_03a.hpp                 # namespace comdare::cache_engine::traversal::axis_03a::prt_art {...}
│   └── ...
└── prt_art/include/prt_art/identity/          # bleibt comdare::prt_art::identity::* (Pruefling-Adapter)
```

**Auswirkung auf 51 prt-art-Tests + alle prt-art-Header-Includes:** massiv. Schritt-fuer-Schritt-Migration pro Achse, pro Test-Lauf.

### §9.3 Stufe 3 Full-Join existiert nicht in V41 — muss neu gebaut werden

Aktuell `comdare_perms_all` ist NUR ein Aggregator-Target (sammelt comdare_perms_ce + comdare_perms_pa). Das ist NICHT das echte Kartesische Produkt CE × Pruefling × Multi-Pruefling. Konkret:

```cmake
# NEUES Target benoetigt fuer Stufe 3:
add_custom_target(comdare_perms_full_join)
# Iteration: pro CE-Permutation × pro Pruefling-Permutation × pro multi-Pruefling-Kombi
# Resultat: zehntausende × zehntausende = Millionen Permutationen
```

V41.F.5 (Pruefungs-Dreigliedrigkeit) ist die TODO-Verfolgung dieses Punkts.

### §9.4 Cross-Constraint Validation Engine als zentraler Service

Aus W2 + W3: viele Cross-Topic-Constraints (z.B. `buffer::lazy_on_evict + io::sync_spill = INVALID`, `prefetch::adaptive_distance REQUIRES telemetry != disabled`). Diese muessen zur Compile-Time validiert werden, sonst verschwendet das System Binaries fuer ungueltige Permutationen.

**Architektur-Vorschlag (F.6.1.E):**
```cpp
// src/permutations/constraint_validator.hpp
namespace comdare::cache_engine::permutations {

template <typename PermutationTuple>
constexpr bool is_valid_combination() {
    // Static dispatch ueber alle Topic-Achsen-Paare,
    // wendet pro-Achse-Constraint-Predicate an
    return Topic1Validator::check<PermutationTuple>::value
        && Topic2Validator::check<PermutationTuple>::value
        && ...;
}

template <typename PermutationTuple>
    requires is_valid_combination<PermutationTuple>()
struct ValidatedPermutation { ... };

}
```

Codegen iteriert nur ValidatedPermutations, skippt invalide Tuple zur Compile-Time.

### §9.5 TestDataSetAccumulationEngine + Mikrobenchmark-Suite (UML REV7 §7+§8)

**Aus UML REV7 vergessen in §11:**
- TestDataSetAccumulationEngine ist Pflicht-Klasse fuer reproduzierbare Test-Daten-Bereitstellung (Cache-Line-aligned 64B, NUMA-spezifisch, optional Hugepages)
- Mikrobenchmark-Suite mit 2 separaten Custom-Allokationen (#1 Messergebnisse, #2 sparse Byte-State-Trace)
- No-Deprecate-Wrapper aller Testmethoden
- Conversion-Routine im Messmodul (Binary→CSV/JSON/pgfplots) — NIE waehrend Laufzeit

**Diese gehoeren in `src/measurement/` (= comdare-measurement Submodule kuenftig).**

### §9.6 default_lookup als Strategy + Interpreter in src/ (RQ-6 Detail)

User-Direktive: default_lookup ist Vermittler zwischen cache-engine und Prueflingen. Konkret:

```cpp
// src/default_lookup/default_lookup_interpreter.hpp
namespace comdare::cache_engine::default_lookup {

// Liest Pruefling-Config (z.B. XML messreihen)
// Validiert: hat Pruefling fuer angefragte Achse einen Override?
// Liefert: cache-engine-Default oder Pruefling-Variant
template <typename Pruefling, typename Topic, typename Axis>
struct DefaultLookupInterpreter {
    using EffectiveVariants = std::conditional_t<
        has_pruefling_override<Pruefling, Topic, Axis>::value,
        typename PruefingOverride<Pruefling, Topic, Axis>::Variants,
        typename CacheEngineDefault<Topic, Axis>::Variants
    >;
};

}
```

Wird vom CacheEngineBuilder zur Compile-Time ausgewertet (statische Metaprogrammierung).

### §9.7 Migration-Reihenfolge mit Tests-grueun-Pflicht

Heute haben wir 104 Tests gruen. Die Migration darf das NICHT brechen. Konkreter Schritt-fuer-Schritt:

```
Schritt 1: Topic anlegen (libs/cache_engine/topics/allocator/), kopieren NICHT verschieben
Schritt 2: Tests fuer kopierte Klassen schreiben — beide Pfade muessen gruen sein
Schritt 3: Bestehende Tests-Includes aktualisieren auf neuen Pfad
Schritt 4: Build + Tests laufen lassen
Schritt 5: Alten Pfad loeschen (nicht vorher!)
Schritt 6: Build + Tests final
```

Pro Klasse 6 Schritte. 27 BASIS-Klassen + 6 SPEZIFISCH + 14 Allocator-Familien + 12 Subsystems + 22 Builder-Komponenten = ~80 Migrations-Einheiten = 480 Schritte. **Substantieller Aufwand.**

### §9.8 Memory-Updates die in der Fortsetzungs-Session geschrieben werden sollten

```markdown
# feedback_topic_axis_pruefling_namespace_pattern.md
Pruefling-Achsen-Erweiterungen leben unter `comdare::cache_engine::<topic>::<axis>::<pruefling_name>::*`.
KEIN `optional_<pruefling>_impl` Verzeichnis. KEIN axes/ Verzeichnis. Topics enthalten Achsen direkt.
Why: User-Direktive 2026-05-25.

# feedback_crtp_concept_guard_mix_pattern.md
Achsen-Klassen verwenden CRTP + Concept-Guard MIX. Jeder Ordner+Unterordner hat genau EIN Concept-File.
Topic-Concept (breit) + Achsen-Concept (eng, erweitert Topic-Concept).

# feedback_no_runtime_switch.md
KEINE std::variant + Runtime-Switch in Hot-Path. Statische Metaprogrammierung via Template + concept.

# feedback_pruefling_vs_pruefling_binary.md
Pruefling = Repo-Projekt. Pruefling-Binary = pre-built Rekombinations-.so/.dll.
Pro Pruefling entstehen zehntausende Binaries.

# feedback_pruefling_replace_not_extend.md
Pro Achse: wenn Pruefling-Namespace existiert -> ERSETZT die cache-engine-Defaults komplett.
Fallback transparent zur Compile-Time wenn Pruefling die Achse nicht ueberschreibt.

# feedback_3_stufen_pruefung.md
Stufe 1 = comdare_perms_ce (CE-only). Stufe 2 = comdare_perms_<pruefling> (pro Pruefling einzeln).
Stufe 3 = comdare_perms_full_join (echtes Kartesisches Produkt — MUSS NEU GEBAUT WERDEN).

# reference_master_architektur_skizze.md
Master-Doc: docs/architektur/11_konzept_achsen_extension_visitor_pattern.md (V41.F.6.1, 833+ Zeilen)
```

## §10 Cross-Repo-Stand (3 Hauptprojekte)

| Repo | HEAD | Sync mit origin/main |
|------|------|----------------------|
| Diplomarbeit | `7817b77` | ✅ gepushed |
| cache-engine | `2eb21d6` | ✅ keine Aenderungen |
| prt-art | `d1b6140` | ✅ keine Aenderungen |
| 6 Modul-Skelette | je `e208115..ccec769` | ✅ unveraendert |

Alle Submodule-Bumps in Diplomarbeit konsistent mit verschachtelten Repo-HEADs.

## §11 Verifikations-Build

Keine Code-Aenderungen heute Abend → keine Build-Verifikation noetig. Bei Fortsetzungs-Session vor F.6.1.A Pilot-Start:

```bash
cd "C:\Users\benja\OneDrive\Desktop\Diplomarbeit - Datenbanken"
bash Code/tools/run_all_tests.sh --config Release
# Erwartet: 104 passed, 0 failed (Baseline halten)
```

## §12 Gesamt-Tasks-Stand nach Session

```
completed: 13 Tasks (V41.A1, B1, A5, B3, A2, B4, E2, E4, E7, F.6.0.S1+S2, W1-W4, C1, U1)
in_progress: 3 Tasks (V41.F.1 V41.F.6 V41.F.6.1)
pending: 28 Tasks
```

Davon strukturell wichtig:
- **F-Block:** F.1-F.6 + F.6.0.S1/S2/M/A + F.6.1 (substantielle Architektur-Tasks)
- **V42-Block:** P0.1-3 + P1.1-3 (vergessene Features Top-7)
- **E-Block:** E5, E6, E9, E10, E11 (Facade + STATIC/SHARED + nested-cleanup)
- **B-Block:** B2 (YCSB) + B4.1 (MinGW)
- **C/D-Block:** Cluster + Diplomarbeit-Text (extern blockiert / User manuell)

## §13 Session-Bewertung

**Positiv:**
- 4 Web-/Audit-Agents parallel ausgefuehrt, alle 4 erfolgreich, substantielle Inhalte geliefert
- Alle 15 User-RQs in 3 Runden beantwortet → finale Topic-Hierarchie validiert
- 833+ Zeilen Architektur-Skizze gepushed (volle Implementations-Vorlage fuer F.6.1.A)
- W4 lieferte 8 P0/P1 vergessene Features, die ohne Audit verloren gegangen waeren

**Verbesserungspunkte:**
- Falsche Implementierung von 2 traversal/-Stubs (Monolith mit std::variant) zeigt: Architektur-Doku VOR Code ist Pflicht
- 6 Doku-Commits in Folge ohne dazwischen-liegende Verifikation — naechste Session braucht Build-Check vor weiterem Doku-Wachstum

**Lernerfahrungen:**
- Migrations-Reihenfolge: cache-engine zuerst (Basis), prt-art danach (Ableitung)
- Statische Metaprogrammierung vs dynamisches Variant-Pattern: Performance-Auswirkung auf Mess-Praezision ±0.1%
- 3-Schichten Layer-Provider-Rollen sind nicht-trivial — verlangen explizite Architektur-Disziplin

---

**Naechste Session beginnt mit:**
1. MEMORY.md + dieses Doc + `11_konzept_achsen_extension_visitor_pattern.md` lesen
2. Memory-Files aus §9.8 anlegen
3. Build-Verifikation 104 Tests gruen
4. F.6.1.A Pilot-Code starten (Topic allocator/axis_06/sub_61_alloc_lib mit 3 Mechaniken)
