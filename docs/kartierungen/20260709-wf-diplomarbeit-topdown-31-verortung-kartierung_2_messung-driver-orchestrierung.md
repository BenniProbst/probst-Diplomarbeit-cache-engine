Kartierung abgeschlossen. Alle Dateien in `02_messung_driver/` plus die konsumierte cache-engine-API (vendored unter `Code/external/comdare-cache-engine/`) gelesen. Befund unten; `datei:zeile` durchgehend absolut.

---

## KERNBEFUND: zwei getrennte Orchestrierungs-Pfade

Der `messung_driver` hat **zwei** Orchestrierungs-Wege, die NICHT verbunden sind:

- **AKTIV (main.cpp):** Plugin-Mikrobenchmark über vorkompilierte perm-DLLs + pro Messreihe ein `comdare::builder::ExperimentDriver::run_pipeline_full`. Das ist der einzige Pfad, den `main()` tatsächlich fährt.
- **TEST-ONLY (v32_orchestrator.hpp):** Command-Pattern, parallele EE-A/EE-B via `std::async`, Welch-Vergleich. `main.cpp` referenziert `V32Orchestrator` **nirgends** (grep rc=1). Einziger Aufrufer ist `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/tests/unit/test_v32_orchestrator.cpp`. Die Header `v32_orchestrator.hpp`, `op_type_filter.hpp`, `hardware_filter.hpp`, `messreihe_v32_validator.hpp`, `messreihe_report_exporter.hpp` hängen alle an diesem test-only V32-Pfad und werden vom aktiven `main()` nicht benutzt.

`CMakeLists.txt:22-31` macht V32 nur per Option `COMDARE_V32_ENABLE` (Default OFF) sichtbar; selbst bei ON enthält `main.cpp` keinen `#ifdef COMDARE_V32_ENABLE`-Aufruf. V32 ist also totes/Test-Code aus Sicht des Binaries.

Basis-Pfade:
- MD = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/02_messung_driver/`
- CE = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/`

---

## 1. Wie liest der messung_driver die experiment_config-XMLs?

**Der messung_driver parst selbst NUR `messreihen.xml`** — und zwar per Regex, nicht mit dem cache-engine-Parser:
- `MD/main.cpp:173-204` `load_messreihen()` — Regex `<messreihe id="...">` (`:182`), `<mode>` (`:190`), `<profile>` (`:197`). Getriggert durch CLI-Flag `--messreihen-xml=FILE` (`MD/main.cpp:419-420`, geladen `:450`). Ergebnis: pro Spec ein eigener ExperimentDriver-Lauf (`:461-492`).

**Die 4 Permutations-XMLs liest der messung_driver NICHT** — er reicht nur `config_dir` (argv[1]) opak an die Library durch (`MD/main.cpp:410`, `:467-468`/`:513-514`). Das eigentliche Parsen macht die cache-engine:
- `CE/cache_engine/builder/experiment_driver/experiment_driver.cpp:101-102` — `xml::XmlConfigParser parser; parser.parse(opts_.config_dir)`
- `CE/common/serialization/xml_config_parser/xml_config_parser.cpp:72-75` liest per **fixem Dateinamen**: `cache_engine_permutations.xml`, `search_algorithm_permutations.xml`, `allocator_permutations.xml`, `test_data_sets.xml`; `:82` zusätzlich `messreihen.xml`. Der Parser ist ein minimaler String/find-Reader (kein echtes XML).

**Diskrepanz (wichtig):** Die real vorhandenen Dateien in `Code/experiment_config/` heißen `config_a_prt_art_vs_sota.xml`, `config_b_cache_engine_perms.xml`, `config_c_merge_alt_neu.xml`, `messreihen.xml`. Die `config_a/b/c`-Namen **matchen keinen der Dateinamen**, die der Parser sucht. Grep über den Projektcode (ohne vendored `ext/`): **kein Konsument** von `config_a/b/c`. Diese drei sind beschreibende/Legacy-Deskriptoren (`<mode>`, `<sota_profiles>`, `<pruefling>`, plus `A_legacy`-Block mit `<comparison_baselines>` in `config_a…xml:52-100`) — im Laufzeit-Kontrakt zählen nur die 4 fix benannten XMLs + `messreihen.xml`.

Zusätzlich existiert ein zweiter, ungenutzter Validator: `MD/messreihe_v32_validator.hpp:47-105` validiert ein **anderes** Schema (`<messreihe version="32">`, genau 2 `<engine>`, `<tupel>`/`<workload>`, `<output>/binary_path…`) rein per `std::string::find`. Von `main.cpp` nicht aufgerufen (V32-Pfad).

---

## 2. Wie ruft er die cache-engine? Welche API konkret?

**Library-Konsum** (`MD/CMakeLists.txt:13-16`): `target_link_libraries(… comdare_builder_experiment_driver  comdare::workload_generator)`. Alias `namespace cb = comdare::builder` (`MD/main.cpp:49`).

Konkrete API-Oberfläche im aktiven Pfad:
- `cb::ExperimentDriverOptions` — Felder `config_dir`, `output_dir`, `comdare_root`, `messreihen_mode`, `sota_profile_filter` gesetzt in `MD/main.cpp:467-473` (Spec-Modus) bzw. `:513-516` (A/B/C). Definition: `CE/…/experiment_driver/experiment_driver.hpp:34-68`.
- `cb::WorkloadOptions` (`WorkloadConfig` + `YcsbWorkload`) — `MD/main.cpp:124-149`, `:476-483`. Def: `…experiment_driver.hpp:70-73`.
- `cb::ExperimentDriver driver{opts}` — `MD/main.cpp:475`, `:518`.
- **`driver.run_pipeline_full(w)`** — der eine Einstiegspunkt, `MD/main.cpp:485`, `:521`; Erfolg gegen `cb::status_ok` (`:486`, `:522`).

`run_pipeline_full` = Phasen 1–7 (`…experiment_driver.cpp:534-586`): `phase1_enumerate` (XML→kartesisches Produkt), `phase2_generate` (Codegen pro Permutation + SOTA-Profil-Auto-Pickup), `phase3_compile` (`cmake --build … --target comdare_all_permutations`, `:286`), `phase4_load` (dlopen aller Modul-DLLs), `phase5_run_workload` (create/run/destroy pro Modul → `ResultAggregator`), `phase7_export` (CSV+JSON).

**Kein literales `run_profile`** und **kein direkter `CacheEngineBuilder`-Aufruf** im aktiven Pfad (grep leer). Das „run_profile"-Verhalten steckt implizit in `phase5_run_workload` als **profil-abhängiges Workload-Routing** (`…experiment_driver.cpp:440-484`). Die Diplomarbeit steuert Profile nur über `sota_profile_filter` (defined-Mode) aus `messreihen.xml`.

Der **V32-Pfad** (test-only) nutzt dagegen die Command-Pattern-API der cache-engine direkt: `cmd::AxisLibraryRegistry::lookup` (`MD/v32_orchestrator.hpp:108`), `cmd::ExecuteEngineCommand`/`cmd::CompareEngineCommand` (`:161-176`), Adapter `CacheEngineExecutionEngineAdapter<>` + `PrtArtExecutionEngineAdapter<>` (`:154-158`), Includes `cache_engine/builder/commands/*` + `auto_permutator.hpp` (`:10-18`). Das ist der einzige Ort, wo „CacheEngineBuilder / ExecutionEngine" konkret angesprochen wird — aber eben nicht produktiv verdrahtet.

---

## 3. Was ist axis_tree.hpp — und Verhältnis zur cache-engine experiment_tree?

`MD/axis_tree.hpp` ist die **Diplomarbeit-seitige, nachgelagerte Auswerte-/Mess-Sicht** (pure std, entkoppelt, unit-testbar; `:1-11`). Mechanik:
- Input ist die **flache** Permutationsliste des Plugin-Loaders; der `axes`-String jedes Plugins (z.B. `"simd=avx2,layout=soa,alloc=std (real=mimalloc)"`) stammt aus dem cache-engine-`permutation_codegen` (`:4-6`).
- `parse_axes` (`:43-64`) zerlegt den String, `build_axis_tree`/`build_subtree` (`:105-135`) baut daraus **rückwärts** einen achsen-geschichteten Präfixbaum; `subtree_groups_varying` (`:148-165`) bildet „eine Achse variiert, Rest fix"-Gruppen für restringierte Welch-Tests.
- Konsumiert in `MD/main.cpp:313-404` (Gruppen-Ausgabe, per-Achsen-CSV, Subtree-Welch).

**Verhältnis:** Es ist eine **separate, downstream Rekonstruktion**, kein geteilter Code. Die autoritative Forward-Struktur der cache-engine ist `CE/cache_engine/builder/experiment_tree/experiment_tree.hpp` — ein „achsen-geschichteter Permutations-/Kompositions-Präfixbaum" (`:1-10`), der den Bauraum **erzeugt** und dabei bewusst **nie voll materialisiert** (lazy mixed-radix Odometer, O(Tiefe) Speicher; `binary_count()` rein arithmetisch; `:14-37`). `axis_tree.hpp` materialisiert dagegen einen kleinen Analyse-Baum aus den bereits **gemessenen** Blatt-Labels. Also: cache-engine `experiment_tree` = generativ/forward (Enumeration+Build); Diplomarbeit `axis_tree` = analytisch/backward (Read-back aus dem `axes`-Etikett, nur Statistik). Gleiche konzeptuelle Achsen-Hierarchie, disjunkter Code, keine Materialisierungs-Kopplung.

---

## 4. Workloads, Mess-Kategorien, Datasets — Durchreichung als Profile

- **Workloads (aktiver Pfad):** `default_workload_for(kind)` (`MD/main.cpp:124-149`) setzt pro Reihe A/B/C den `YcsbWorkload` + `WorkloadConfig` (num_keys, num_operations, key/value-Size, zipfian_theta=0.99, seed=42) und übergibt sie als `cb::WorkloadOptions` an `run_pipeline_full`. In der Library routet `phase5_run_workload` je SOTA-Profil weiter: Traversal→YCSB-Heuristik (`…experiment_driver.cpp:408-412`) bzw. `expected_workload`-Override (`:414-424`, `:449-460`). Workloads landen also als profil-abgeleitete YCSB-Kinds bei der cache-engine; `workload_used` (z.B. `YCSB_A`) wird pro Permutation mitgeschrieben (`:498-501`).
- **Datasets:** `test_data_sets.xml` ist einer der 4 kartesischen Faktoren (`xml_config_parser.cpp:75`; Produkt `…experiment_driver.cpp:113-118`). Die realen Dataset-XMLs liegen in `Code/test_data_xml/` (english_words, pizzachili_dna, protein, sosd_books_200M, url, xml, tpcds-id, trec-terms). Der messung_driver **fasst Datasets nicht selbst an** — sie treten nur als Enumerations-Achse in der Library auf.
- **Mess-Kategorien / OP-Typen:** `MD/op_type_filter.hpp:63-100` bildet XSD-`<op_type>` OP-1..OP-6 auf `cmd::WorkloadKind` (+SIMD/Cache/Scheduling/Telemetry-Hints) als constexpr-Tabelle ab. **Aber nur im V32-Pfad verdrahtet** (`MD/v32_orchestrator.hpp:139-144` `run_messreihe_for_op_type`), nicht im aktiven `main()`. Ebenso `MD/hardware_filter.hpp:143-201` (Tupel-Skip gegen Host-SIMD/Compiler via `HostCapabilities::detect_compile_time`, `:50-75`) — V32-seitig, von `main.cpp` nicht aufgerufen.

Fazit: Im aktiven Pfad erreichen „Profile" die cache-engine als (a) `sota_profile_filter`-Liste (defined-Mode aus `messreihen.xml`) und (b) `WorkloadOptions`; Codegen-pro-Profil und Profil→Workload-Routing macht der Driver intern.

---

## 5. Wie schreibt er measurement_record (*.bin, magic 0xC0FFEE02)?

Writer: `MD/measurement_writer.hpp`. Magic `kMeasurementMagic = 0xC0FFEE02u` (`:29`), Container-Version 2 (`:30`).

**Format** (`:5-13`, Ctor `:34-43`, `add` `:49-63`, `finalize` `:66-74`):
```
Header:  uint32 magic(0xC0FFEE02) | uint32 version(2) | uint64 num_records  (num_records am Ende an Offset 8 zurückgepatcht)
Record*: uint32 perm_id_len | char[perm_id] | uint64 fingerprint | uint8 succeeded
         | uint32 workload_len | char[workload]        (v2-Zusatz, z.B. "micro")
         | comdare_measurement_record_v1  (fixed-size POD)
```
- `fingerprint` = FNV-1a-64 über perm_id (`fingerprint_of`, `:110-117`).
- POD `comdare_measurement_record_v1` (`CE/cache_engine/include/cache_engine/abi/module_abi_v1.hpp:29-43`): version, op_count, total_cycles, cache_misses_l1/l2/l3, dtlb_misses, coherence_invalidations, energy_micro_joules, bytes_allocated, bytes_in_use_peak, external/internal_fragmentation.
- Feldbefüllung: `make_record_from_run` (`:88-107`) — total_cycles aus µs/op approximiert (×3000 @3GHz), PMU-Counter=0 (Phase-6-TODO), bytes_allocated=n_ops×64 (Schätzung).

**Wo/wann geschrieben:** NUR der Plugin-Mikrobenchmark-Block in `main.cpp` schreibt die `.bin` — eine Aggregat-Datei `<output_dir>/measurements/all_permutations.bin` (`MD/main.cpp:252-254`), ein Record pro geladener perm-DLL, Workload-Label `"micro"` (`:294-299`), finalisiert `:302`. Der Plugin-Loop selbst: `load_all_perm_plugins` via dlopen/LoadLibrary aller `perm_*.{so,dll,dylib}` mit Entry `comdare_perm_descriptor()` + `run(n,&micros)` (`MD/plugin_loader.hpp:76-138`), 10 Reps (`main.cpp:261`), Stats via `compute_stats` (`MD/stats_aggregator.hpp:66-100`).

**Wichtig:** Der ExperimentDriver-Messreihen-Pfad schreibt **keine** `.bin` — `phase7_export` erzeugt nur `measurements.csv` + `measurements.json` (`…experiment_driver.cpp:513-528`). Die magic-`.bin` kommt also ausschließlich aus dem Mikrobenchmark, nicht aus den A/B/C-Läufen.

**Konsument-Kontrakt:** Stage 03 liest dieselbe Magic: `Code/03_binary_to_csv/binary_to_csv.hpp:43` `kBinaryMagic = 0xC0FFEE02u`. (Die identische Konstante `0xC0FFEE02ull` in `experiment_driver.cpp:197`/`:448` ist unabhängig — dort nur XOR-Seed für Profil-Fingerprints, nicht das Datei-Magic.)

---

## Entry-Sequenz von main() (Orchestrierungs-Mechanik top-down)

1. `assert_permutations_available_or_die()` (`MD/main.cpp:216`) — Fatal Exit 2 wenn beide Manifeste leer (`MD/permutations_runtime_check.hpp:87-102`); Manifest-Pfade als Compile-Defines `COMDARE_PERMUTATIONS_MANIFEST_CE/PA` (`MD/CMakeLists.txt:35-37`).
2. Manifest-Inventar-Ausgabe (`main.cpp:220-226`).
3. Plugin-Mikrobenchmark-Block (`main.cpp:232-408`): perm/-Root heuristisch suchen (`:235-241`), DLLs laden, 10-Rep-Bench, `.bin` schreiben, `permutation_stats.csv` + per-Achsen-CSV + `welch_pairwise.csv` (`stats_aggregator.hpp:115-170`), Achsen-Baum-Auswertung.
4. Compile-Gate-Hinweis `COMDARE_EXPERIMENT_MODE_ON` (`main.cpp:438-444`).
5. ExperimentDriver-Läufe: entweder externe `messreihen.xml`-Specs, je Spec ein `run_pipeline_full` (`main.cpp:451-498`), ODER fest verdrahtete 3 Reihen A/B/C (`:500-529`), Output je Reihe in Unterordner `A_PRT_ART_vs_SOTA/` etc. (`:122`, `:511`).