# Architektur-Master REV7.7 — Aktueller Stand (V31, 2026-05-15)

**Stand:** 2026-05-15 (K-C.3)
**Quellen:**
- REV7-Master: `../termine/20260508 Termin 7/Phase5_UML_Detail/24_architektur_skizze_REV7_2026_05_13.md` (872 Z)
- 5 REV7-Deltas: Doks 25-30 (insgesamt ~750 Z)
- V12-V31 Code-Stand: `../sessions/20260514-4600-fortschrittsdokumentation-v30-v31.md`
**Konfliktregel:** REV7.7 > REV7.6 > REV7 > REV6 > REV5 > REV4 > REV3

---

## §1 Drei-Saeulen-Architektur (REV3 → REV7.7 unveraendert)

```
EBENE 1: IExecutingEngine (Wurzel-Abstraktion)
  ├── ISearchEngine       (PRT-ART-Diplomarbeit-Fokus)
  └── IFutureEngine       (Architektur-Slot — z.B. ICompactingEngine, ISortingEngine)
       ▼ konsumiert
EBENE 2: Suchalgorithmus-Datenstruktur (Saeule A)
  IPage, IRootPage, IFanout, INode, ISearchPage, ICachePage,
  ICacheStrategy (Visitor), ISearchPagesStrategy, ..., Iteratoren
       ▼ optimiert via
EBENE 3: CacheEngine + Plattform-Modell (Saeule B)
  IPlatformProbe, IPlatformPropertyClassifier,
  ICacheLevel, ICacheLine, ICacheTopology, ICacheResidency,
  ICpuCore, ICoreLayout, ICoreToThreadMap, IPinningPolicy,
  IHardwareExtension, IIsaFeatureSet,
  IInterconnect, IBusTopology, IMemoryBandwidthModel,
  ILivePlatformModel, ILiveCpuModel,
  IScheduler, IHeuristik, ICacheEngineOptionPublisher,
  DecisionLambdaTrees
```

**Trennungs-Prinzip:**
- Ebene 1 generisch — jede Engine konsumiert CacheEngine als Optimierungs-Service
- Ebene 2 weiss nichts direkt von CPU/Caches — konsumiert nur ICacheStrategy
- Ebene 3 plattform-agnostisch im Code, plattform-konkret im Verhalten via Auto-Discovery

---

## §2 Drei-Repo-Layer (REV7.6, V31 operationalisiert)

> **WICHTIGER VERWEIS (Phase M, 2026-05-18):** Die Drei-Repo-Aufteilung (Diplomarbeit/comdare-prt-art/comdare-cache-engine) ist orthogonal zur **4-Subsystem-Trennung** (Diplomarbeit/Code/messung_driver -> CacheEngineBuilder -> CacheEngine <-> Pruefling). CEB und CE wohnen beide im selben Repo `comdare-cache-engine`, sind aber 2 unabhaengige Subsysteme. Details: siehe `10_schichten_modell_M.md`.


| Repo | Rolle | HEAD V31 (Stand 2026-05-15) |
|---|---|---|
| **`Diplomarbeit/Code/`** | **WAS** + Auswertung | `0f7b4d2` (Master-Plan + Konsolidierung) |
| **`comdare-prt-art`** | **Pruefling** | `1a36ab4` (V31.F Pin) |
| **`comdare-cache-engine`** | **WIE** + Werkzeuge | `16176ee` (V31.F) |

**Drei-Pflicht-Messreihen** (XML-Configs, compile-time):

| Reihe | Datei | Ziel |
|---|---|---|
| A | `config_a_prt_art_vs_sota.xml` | PRT-ART vs ART/HOT/Masstree (SOTA) |
| B | `config_b_cache_engine_perms.xml` | Cache-Engine-Permutationen (Allokator × Layout × Prefetch × ...) |
| C | `config_c_merge_alt_neu.xml` | Regressions-Vergleich alt vs neu |

---

## §3 Custom Allokation als Cache-Engine-Basisdisziplin (REV7 §1)

### 3.1 Zwei parallele Bausteine-Stacks

```
                       CacheEngine (Stand der Technik)
                                |
              +-----------------+-----------------+
              |                                   |
        Such-Algorithmus-Stack          Allokations-Stack
        (33 Paper, REV 1-6)             (21 Paper TBD, REV 7)
        - 11 Bausteine-Achsen (1-11)    - 7 Bausteine-Achsen (AA1-AA7)
        - 6 Pflicht-Seitentypen         - 6 Pflicht-Allokator-Familien
        - 12 Sub-Engines                - eigene Sub-Engines (Slab, Buddy, ...)
        - 29 ICacheStrategy-Familien    - N IAllocationStrategy-Familien
        - 4-Ebenen-Strategien           - 4-Ebenen-Strategien (analog)
```

Beide Stacks werden vom **CacheEngineBuilder** (siehe §6) per Permutation kombiniert.

### 3.2 Anforderungen an Allokator-Bausteine (REV7 §1.4)

| Anf. | Detail |
|---|---|
| A1 Typsicherheit | std::allocator<T>-Standard typsicher erweitern |
| A2 PMR | std::pmr::memory_resource-Konformanz (runtime-polymorph) |
| A3 Concurrency-Default | Single-Writer-Multi-Reader (1-W/N-R) via std::shared_mutex |
| A4 Concurrency-Optional | Cache-Page-Awareness fuer Multi-Write via C++17 (std::scoped_lock, RAII, hierarchical-lock) |
| A5 Container-Tests | Test mit std::vector, std::map, std::unordered_map, std::deque, std::list, std::set |
| A6 Cache-Page-Awareness | Bausteine kennen ICachePage-Topologie + nutzen sie fuer Layout-Entscheidungen |
| A7 Block-AO-Plattform-Test | Verifikation auf 9 Block-AO-Plattformen (analog Suchalgorithmus-Pflicht) |
| A8 Bausteine permutierbar | Slab-Layout × Buddy-Order × Lock-Free-Free-List etc. |

### 3.3 V31 Code-Stand

- 23 Allokator-Quellen A01-A23 dokumentiert in `../bausteine/02_allokator_matrix.md`
- 10 Allokator-Adapter (A01, A03, A04, A05, A06, A07, A08, A10, A11, A20) in `cache-engine/adapters/A*/`
- 7 Achsen AA1-AA7 (5 Cluster AC1-AC5)

---

## §4 ABI-stabiles C++23-Modul-Interface (REV7 §4)

### 4.1 Drei-Schichten-Hierarchie

```
CacheEngine (Basis-Library)
  ↑
execution_engine (erbt CacheEngine)
  ↑
search_engine (Common Search-API)
  ↑
prt_art / weitere konkrete Search-Algorithmen
```

### 4.2 Variadic-Templates (REV7 §4.3)

| Anzahl Template-Params | API-Verhalten |
|---|---|
| 1 | std::vector-API (auto-key) |
| 2 | std::map-API (K, V) |
| N>2 | map<K, tuple<V1..VN>> |

### 4.3 status_t errno-style ABI (REV7.1)

- Schreib-/IO-Ops returnen IMMER `int` errno-style (0=ok, >0=error code)
- Leseoperatoren behalten natuerlichen Returntyp (optional/iterator/size_t)

### 4.4 Compile-time-Fallback (REV7 §6)

PRT-ART → CacheEngine-Bibliothek wenn Bausteine fehlen (im prt_art Repo).

### 4.5 V31 Code-Stand

- `comdare-prt-art/prt_art/include/prt_art/identity/prt_art_search_engine.hpp` — hybride Klasse (V12-V14)
- `comdare-prt-art/prt_art/include/prt_art/identity/status.hpp` — errno-style status_t
- 51+ neue Tests in `test_prt_art_identity.cpp` (MapApi/TupleApi/VectorApi/Status)
- 181/181 ctest gruen

---

## §5 PRT-ART als Pruefling im 3-Stufen-System (REV7 §6)

PRT-ART ist EINE konkrete Algorithmus-Variante im Permutations-Framework.

**REV6-Korrektur 2026-05-12:** Im PRT-ART-Code selbst sind nur **2 Node-Typen** (Redirect + B+) verwendet. Aber im Cache-Engine-Framework sind **6 Pflicht-Seitentypen** weiterhin permutierbar.

### 5.1 PRT-ART-Spezifika (REV6 §5.17 ANGEHAENGT)

- 2 Node-Typen: Redirect + B+
- 4 Suchtypen: Exact, Prefix, Range, Hash-Anchor
- Dichte-Schwellen + virtuelle Adressierung
- Linearer Value-Buffer
- 4+2 Allokator-Pools (A/B/C/D + R/V)
- Signaling-Bits-Serialisierung
- Multi-RW-Concurrency
- Compile-Time-Templates (V12-V13 std-Container-API)

---

## §6 CacheEngineBuilder als eigenstaendiges Programm (REV7 §5)

**XML-Konfiguration zulaessiger CacheEngine-Rekombinationen + abhaengiger Suchalgorithmus-Builds.**

### 6.1 Phasen-Pipeline (V31 Stand)

1. **Phase 1 enumerate** — Profile-Pickup aus algorithm_profiles/
2. **Phase 2 codegen** — Module-Sources via `generate_module_from_profile`
3. **Phase 3 compile** — CMake Stage-1/2 (Stage-1 Codegen, Stage-2 native Build)
4. **Phase 4 load** — ModuleLoader (LoadLibrary/dlopen)
5. **Phase 5 run** — Profile-aware Workload-Routing via `<expected_workload>`
6. **Phase 6 measure** — perf-Counter (falls aktiv)
7. **Phase 7 export** — CSV/JSON via ResultAggregator (mit `workload_used`-Spalte)

### 6.2 V31 Code

- `comdare-cache-engine/libs/cache_engine/builder/` mit 22 Subkomponenten
  - `experiment_driver/`, `experiment_runner/`, `module_loader/`, `permutation_loop/`, `permutation_engine/`, `codegen/`, `disk_serializer/`, `algorithm_visitor/`, `cache_engine_component/`, `compile_time_knowledge/`, `decision_lambda_trees/`, `example_configs/`, `in_memory_measurement_buffer/`, `latex_renderer/`, `live_cpu_model/`, `measurement_matrix/`, `observer_registry/`, `platform_probe/`, `runtime_micro_benchmarks/`, `telemetry_spool/`

---

## §7 NOTICE Architekt-Direktive II (V31.A 2026-05-14)

**User-Direktive 2026-05-14 (in NOTICE verankert):**

> "Da wir alle Algorithmus-Bestandteile zerschneiden, entsteht fuer alle
> Permutations-Achsen ein neues Werk. Das gilt fuer alle Lizenztypen.
> Repos ohne Lizenztypen haben nur ein formales copyright, also muss
> nur der Autor beim zitieren genannt werden."

→ GPL-3 (P04, P07), LGPL (P29), no-LICENSE (P06, P25, P30, A03) **alle freigegeben**.

**Quelle:** `../../Code/external/comdare-cache-engine/NOTICE` (Architekt-Direktive II) + `../../Code/external/comdare-cache-engine/LICENSE_AUDIT_EXT.md`.

---

## §8 22 V31-Adapter (V31.K1-K6 2026-05-14)

### SOTA (12)
- P01-ART, P02-HOT, P03-Masstree, P04-CoCo-trie (GPL-3 ⚠️), P05-START, P06-B2tree (no-LICENSE ⚠️), P07-Wormhole (GPL-3 ⚠️), P10-SuRF, P20-leanstore, P25-Mahling (no-LICENSE ⚠️), P29-RCU (LGPL ⚠️), P30-HazardPointers (no-LICENSE ⚠️)

### Allokator (10)
- A01-Hoard, A03-Michael, A04-mimalloc, A05-jemalloc, A06-tcmalloc, A07-snmalloc, A08-scalloc, A10-rpmalloc, A11-LRMalloc, A20-dlmalloc

### Adapter-Pattern (zentral)

```cpp
#if defined(COMDARE_HAVE_<X>)
#  include "<original>.h"
#endif

namespace comdare::adapter::<x> {
class XxxAdapter {
    bool insert(K k, V v) {
#if defined(COMDARE_HAVE_<X>)
        return original_api(k, v);
#else
        throw std::runtime_error("not enabled");  // SOTA
        // ODER std::malloc(size);                // Allokator
#endif
    }
    static constexpr const char *paper_id() noexcept { return "..."; }
};
}
```

**Build:** 23/23 V31-Adapter-Smoke-Tests gruen (Konstruieren + paper_id() + Allokatoren auch allocate/deallocate).

---

## §9 P27 hp-soft-Integration (V31.K5 2026-05-14)

**Mail-Antwort Boris Grot/Youhui Zhang 2026-05-14:**

`hp-soft.zip` (1981 B) mit:
- `hp_soft.py` (3751 B): Build-Time Call-Graph-Analyse via objdump
- `readme.txt` (436 B): Input-Spec

**Was es leistet:** Identifiziert Funktionen mit Subtree-Footprint > Threshold (240KB) als "potential entry points of Bundles" fuer Hierarchical-Bundle-Prefetcher.

**V31 Integration:**
- C++23-Port: `comdare-cache-engine/tools/p27_bundle_finder/` (Library + CLI)
- Runtime-Skelett: `comdare-prt-art/prt_art/legacy_reimpl/P27-Zhang-ASPLOS-Hierarchical/HierarchicalBundlePrefetcher` (5 Tests gruen)

**User-Hinweis (Memory):** "Mehr kommt nicht" — keine Folge-Mails an Zhang/Grot.

---

## §10 libs/-Migration cache-engine (V30 2026-05-14)

**User-Direktive 2026-05-14:** Option C+ = ohne `domain/`-Zwischenebene, flach `libs/<modul>/`.

### Vorher (Top-Level)
```
cache_engine/, search_engine/, experiment/, engine_choice/
```

### Nachher (libs/-konsolidiert)
```
libs/cache_engine/        (134 .hpp + 7 .cpp + 22 Builder-Subs)
libs/execution_engine/    (V30.D.1 ex-experiment/)
libs/search_engine/       (V30.D.2 ex-search_engine/, 8 INTERFACE-Subs)
libs/common/{succinct,serialization,platform,measurement,config}/
                          (config = V30.D.3 ex-engine_choice/, ALIAS comdare::common::config)
libs/test_infra/{workload_generator,test_data,benchmark_suite}/
libs/deprecated/prt_art_legacy/ (V23.E)
```

**Top-Level cache-engine:** 8 → 5 Verzeichnisse (libs/, apps/, adapters/, ext/, tools/).
**Build:** 31/31 Tests gruen pro Phase.

---

## §11 Profile-Stack (V19-V29)

### 11.1 algorithm_profiles XML-Schema

**V19:** `<expected_workload>`-Tag fuer alle 30 SOTA-Profile (P01-P32). xml_config_parser parst den Tag; ExperimentDriver Phase 5 verwendet ihn als Override fuer die Workload-Heuristik aus V11.2.

**V25.B:** Tag fuer alle 30 SOTA-Profile

**V29:** `<allocator_override>`-Tag — z.B. "ART nutzt mimalloc statt jemalloc" im Profile fixierbar.

**V20:** PermutationResult.workload_used Field + ResultAggregator CSV/JSON +Spalte.

### 11.2 Allokator-Profile (V26.A)

10 Profile A01-A20 mit Workload-Tag + Lizenz-Annotation.

### 11.3 Permutationsraum

30 SOTA × 10 Allokator × 6 Workloads = **1800 deklarierte Permutationen**.

---

## §12 11 Bausteine-Achsen (REV6 + V25.C+V26.B + V31.K-Adapter)

| Achse | Name | V31-Adapter-Status |
|---|---|---|
| 1 | PAGE-TYPE | 12 SOTA-Adapter Skelette |
| 2 | NODE-TYPE | (im SOTA-Adapter) |
| 3 | TRAVERSAL | (im SOTA-Adapter) |
| 4 | VALUEHANDLE | (in PRT-ART Code) |
| 5 | MEMORY-LAYOUT | (in libs/common/measurement) |
| 6 | ALLOCATOR | 10 Allokator-Adapter Skelette |
| 7 | PREFETCH | (in P21/P22/P23/P25/P26/P27 Skelette) |
| 8 | CONCURRENCY | (in libs/cache_engine/concurrency_manager) |
| 9 | ISA | (Flag_System Bank 9) |
| 10 | MEASUREMENT | (in libs/cache_engine/builder/measurement_matrix) |
| 11 | TELEMETRY-COLLECTION-STRATEGY | (NEU 2026-05-09 Kuehn, in libs/cache_engine/concurrency_manager) |

Detail siehe `../bausteine/01_bausteine_matrix.md`.

---

## §13 Mess-Pipeline E2E (V21-V22)

- **Sample-Mess-Daten-Generator** (V21.3) — kein reale Hardware noetig
- **diagram_generator plot_by_workload** (V22.1) — TikZ-Plots A4-aware
- **End-to-End Sample-Pipeline-Test** (V22.2) — gruen
- **thesis chapter 06 Sample-Diagramm** (V21.4)

**Status:** Mess-Pipeline E2E-faehig OHNE reale Hardware (Sample-Daten). Mit reale Hardware (V21.2 User-Aktion) werden echte Mess-Daten generiert.

---

## §14 thesis-Manuskript (V13.7 + V14.4 + V15.1 + V16.2 + V21.4 + V22.3 + V28 + V31.I)

**Stand:** 24 Seiten (V31.I).

| Kapitel | Inhalt | Status |
|---|---|---|
| 01 | Einleitung | DONE V15.1 |
| 02 | Stand der Technik | DONE V14.4 + V28 (SOTA + Allokator-Tabellen) |
| 03 | Architektur | DONE V14.4 |
| 04 | Implementation | DONE V14.4 + V24.D + V31.I (V19-V31 Sections) |
| 05 | Messverfahren | DONE V15.1 |
| 06 | Auswertung | TEILWEISE V15.1 + V21.4 (Sample-Diagramm) — wartet auf echte Mess-Daten |
| 07 | Fazit | Skelett V15.1 |

---

## §15 Was bleibt offen (V31 Stand)

| # | Pending | Status |
|---|---|---|
| V21.2 | HW-E2E Mess-Reihe | OFFEN — User-Aktion (reale Hardware) |
| V21.5 | Habich-Termin~8 | LAEUFT (heute) |
| #74 | Email-Antworten P06, P28, P31, P32, P33 | OFFEN — P27 abgeschlossen via hp-soft |
| #95 | Kuehn-Code-Download P28 DaMoN | OFFEN |
| Cluster | Migration Fortigate-31G + GitLab | LAEUFT — paralleler User-Agent |
| K-C bis K-J | Konsolidierung | LAEUFT — diese Session: K-A, K-B, K-D, K-E, K-J + K-I.1+K-I.4 + K-C in Arbeit |

---

## §16 Querverweise

- REV-Historie: `01_REV_Historie.md` (K-C.2)
- Saeule A Konzepte: `03_konzepte_saeule_a.md` (K-C.4)
- Saeule B Konzepte: `04_konzepte_saeule_b.md` (K-C.5)
- UML-Klassen: `05_uml_klassen.md` (K-C.6)
- ER-Modell: `06_er_modell.md` (K-C.7)
- Cross-Reference: `07_cross_reference.md` (K-C.8)
- Drawio-Export: `08_drawio_export.md` (K-C.9)
- Taxonomien: `09_taxonomien.md` (K-C.10)
- Bausteine-Matrix: `../bausteine/01_bausteine_matrix.md`
- Allokator-Matrix: `../bausteine/02_allokator_matrix.md`
- F1-F15 Architekturentscheidungen: `../bausteine/04_architekturentscheidungen_F1_F15.md`
- Glossar v7 Master: `../glossar/01_begriffsglossar_v7_master.md`
- Domaenenmodell v4: `../glossar/02_domaenenmodell_v4_master.md`
- Forschungslandkarte: `../forschungslandkarte/` (K-F, in Arbeit)
- Fortschrittsdoku V30+V31: `../sessions/20260514-4600-fortschrittsdokumentation-v30-v31.md`
