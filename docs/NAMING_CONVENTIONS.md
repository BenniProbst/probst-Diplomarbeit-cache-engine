# Naming-Konventionen (REV 7.6 V12.5 Audit)

**Anlass:** User-Direktive 2026-05-14:
*"Pruefe nochmal, ob die Benennung aller namespaces und variablen kanonisch
genug ist, um von einem Entwickler verstanden zu werden."*

**Stand:** 2026-05-14 nach Audit ueber alle 3 Repos
(comdare-cache-engine, comdare-prt-art, probst-Diplomarbeit-cache-engine).

---

## §1 Befund — Zwei legitime Konventionen koexistieren

Der Codebase verwendet bewusst **zwei verschiedene Naming-Stile**, die je
nach Schicht passend gewaehlt sind:

### §1.1 ABI / Standard-Library-konformes Interface
**Stil:** snake_case fuer Klassen + Methoden (analog `std::*`)

Anwendungsbereich: alles unter `cache_engine/include/cache_engine/abi/*`.
Begruendung: Diese Klassen erweitern bzw. spiegeln die C++ Standard
Library wider — `std::variant`, `std::optional`, `std::execution_policy`
sind ebenfalls snake_case. Eine Mischung waere fuer Konsumenten verwirrend.

Beispiele:
- `comdare::execution_engine<Strategy>`
- `comdare::search_engine<Collection, Config>`
- `comdare::processing_strategy<...>`
- `comdare::cache_engine::baustein::algorithm_axis<...>`
- `comdare::cache_engine::baustein::PageStandardHeap` (Tag-Strukturen sind PascalCase als rein-deklarative Marker)

### §1.2 Domain-Klassen + Anwender-Code
**Stil:** PascalCase fuer Klassen, snake_case fuer Methoden + Variablen

Anwendungsbereich:
- `prt_art/include/prt_art/**/*.hpp` (Algorithmus-Domain)
- `cache_engine/builder/**/*.{hpp,cpp}` (Builder-Subsystem)
- `Diplomarbeit/Code/**/*.{hpp,cpp}` (Anwender-Schicht)

Begruendung: Diese Klassen sind **Domain-Konzepte**, keine std-Container-
Erweiterungen. PascalCase macht sie deutlich von std-Konformitaet
abgrenzbar (Reader-Cue: "das ist ein PRT-ART-Konstrukt, kein
std-aequivalentes Interface").

Beispiele:
- `comdare::prt_art::identity::PrtArtSearchEngine<Ts...>` (PascalCase Domain-Klasse)
- `comdare::prt_art::identity::PrtArtComponents`
- `comdare::prt_art::measurement::DensityTracker`
- `comdare::builder::ExperimentDriver` (Builder-Subsystem-Klasse)
- `comdare::builder::xml::AlgorithmProfile`

### §1.3 Funktionen / Methoden / Variablen
**Pflicht-Stil ueberall:** snake_case

Beispiele:
- `note_observation`, `note_hot_path_bytes`, `adapt_locality`
- `phase1_enumerate`, `phase2_generate`, `run_pipeline_full`
- `lookup`, `insert`, `erase`, `count`, `contains`

### §1.4 Private Member-Variablen
**Pflicht:** Trailing-Underscore-Suffix (`name_`)

Beispiele (verifiziert):
- `data_`, `storage_`, `components_`, `impl_`
- `inserts_`, `erases_`, `const_hits_`, `const_misses_`
- `rw_lock_`, `last_external_sample_`
- `dataset_engine_ptr_`

### §1.5 constexpr Konstanten
**Pflicht:** `kCamelCase` (Google-Style)

Beispiele:
- `kMaxTrackedSlots = 16` (path_oriented_prefetch.hpp)
- `kBinaryMagic = 0xC0FFEE02` (binary_to_csv.hpp)
- `kFingerprintBytes = 16` (fingerprint.hpp)
- `kValueArity = 1 + sizeof...(Rest)`

---

## §2 Namespace-Hierarchie (kanonisch)

```
comdare                                  ← Top-Level-Marke
├── cache_engine                          ← Werkzeug-Repo
│   ├── allocator                         ← 23 Allokator-Familien
│   │   ├── families                      ← konkret: a01_hoard, a02_slab, ...
│   │   ├── locking                       ← Lock-Disziplinen
│   │   └── concurrency                   ← Concurrency-Wrapper
│   ├── baustein                          ← Variants + Achsen (V9.2/V11.4)
│   ├── concurrency_manager               ← REV 6 INK-3
│   ├── reclamation                       ← REV 6 INK-3 (RCU + HazardPointers)
│   ├── subsystems                        ← C01-C12 Sub-Engines
│   ├── platform                          ← Multi-OS-Detection
│   └── (weitere)
├── prt_art                               ← Pruefling-Repo
│   ├── identity                          ← PrtArtSearchEngine + Adapter
│   ├── allocator                         ← 4+2-Pools
│   ├── concurrency                       ← OLC + Reserved Blocks
│   ├── memory_layout                     ← MultiLevel + ByteP + CacheLineAligned
│   ├── nodes                             ← BPlus + Redirect
│   ├── prefetch                          ← Distance + PathOriented + Redirect
│   ├── value_handle                      ← Inline + External + ChainRef
│   ├── measurement                       ← Density + Hypothesis-Metrics
│   ├── serialization                     ← Signaling-Bits
│   └── value_buffer                      ← Linear-Value-Buffer
├── builder                               ← CacheEngineBuilder-Subsystem
│   ├── xml                                ← XML-Config-Parser
│   ├── codegen                            ← Module-Source-Generation
│   ├── loop                               ← Permutation-Loop
│   └── loader                             ← ModuleLoader (LoadLibrary/dlopen)
├── experiment                             ← ResultAggregator
├── workload_generator                     ← YCSB-A..F
├── test_data_accumulation                 ← TestDataSetAccumulationEngine
├── benchmark_suite                        ← Mikrobenchmarks
├── fingerprint                            ← FixedLengthFingerprint
└── abi                                    ← ABI-spezifische Helpers
```

**Konsistenz-Regel:** Jeder Sub-Namespace entspricht 1:1 einem
Verzeichnis. Pfad → Namespace ist eindeutig ableitbar.

---

## §3 Anti-Patterns (zu vermeiden)

| Anti-Pattern | Beispiel | Korrektur |
|---|---|---|
| Klassen-Name in snake_case ausserhalb ABI | `class my_handler` | `class MyHandler` |
| Variablen ohne `_` bei privaten Members | `int counter;` | `int counter_;` |
| Magic Numbers | `if (x > 16) ...` | `constexpr std::size_t kMaxItems = 16;` |
| Kryptische Abkuerzungen | `int tbl_idx;` | `int table_index;` |
| Camelcase Methoden | `void doSomething()` | `void do_something()` |
| Globale Konstanten ohne k-Prefix | `static constexpr int MaxRetries` | `static constexpr int kMaxRetries` |
| Encoding-Regel-Verstoss | `int Index_;` | `int index_;` |

---

## §4 Verifikations-Befund (V12.5 Audit 2026-05-14)

### §4.1 Bestaetigt korrekt
- Namespace-Hierarchie ist konsistent (alle 3 Repos folgen §2-Schema)
- Trailing-Underscore-Member wird durchgaengig eingehalten
- ABI-Klassen sind snake_case (legitim, std-konform)
- Domain-Klassen sind PascalCase (PrtArt*, ExperimentDriver, AlgorithmProfile, etc.)
- constexpr-Konstanten haben k-Prefix (kMaxTrackedSlots, kBinaryMagic, kValueArity)

### §4.2 Mini-Issues (nicht-blockierend, fuer V13+)
- Tag-Strukturen in `baustein_variants.hpp` (PageStandardHeap, NodeBPlus, ...)
  sind PascalCase, sitzen aber im snake_case-Namespace `comdare::cache_engine::baustein`.
  → konsistent, da sie *deklarative Marker* sind, keine std-Library-Spiegel.
- Kein Anti-Pattern gefunden (kein camelCase-Methode, keine Magic Numbers
  in Pruefling-Code, kein verbotener Variablen-Stil).

---

## §5 Querverweise
- V11-Anker: `Diplomarbeit/docs/sessions/20260514-1430-v11-anker-mit-delta.md`
- V12-Anker: `Diplomarbeit/docs/sessions/20260514-1600-v12-anker-vollstaendige-std-api-und-naming.md`
- Memory: `feedback_session_at_95_percent_context.md`
