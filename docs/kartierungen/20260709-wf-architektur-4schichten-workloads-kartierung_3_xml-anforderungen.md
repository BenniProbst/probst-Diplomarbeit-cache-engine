Ich habe die vollständige Kartierung. Hier das Ergebnis.

---

# XML-Landschaft der cache-engine — compile-time/runtime-Split

Basis: `libs/cache_engine/algorithm_profiles/` (Profile) + `libs/cache_engine/builder/example_configs/` (Legacy-Config) + Parser unter `libs/common/serialization/xml_config_parser/` und `libs/cache_engine/builder/workload_driver/`.

Ausgeblendet als Rauschen (keine Konfig-Rolle): `ext/traversal/P29-RCU/.../abi/*.xml` (libabigail-ABI-Dumps), `.idea/*.xml` (IDE), `build*/…/*.xml` (Test-/CTest-Output, roundtrip-Fixtures).

## Kern-Antwort vorab

Ja — die Trennung ist exakt so gebaut:
- **`permutation_axes.xml`** = **ACHSEN-Permutation, compile-time** → kartesisches Produkt → je statischer Pfad **eine Tier-Binary (binary_id)**.
- **`load_profiles/*.xml`** = **WORKLOADS/Lastprofile, runtime (Achse 2)** → per `discover_load_profiles` zur Laufzeit entdeckt, als **dynamische** Baumebene (`is_static=false`) injiziert, verändert die `binary_id` **nicht**.

---

## 1. XML-Familien mit Pfad + Rolle + Parse-Pfad + Zuordnung

### A) `permutation_axes.xml` — die Achsen-Permutation (COMPILE-TIME)
- Pfad: `libs/cache_engine/algorithm_profiles/permutation_axes.xml`
- Root `<comdare_permutation_axes>`; deklariert 11 Achsen mit Wertebereichen: `page, node, traversal, value_handle, concurrency, allocator, prefetch, telemetry, isa, layout, reclamation` (Zeilen 8-148). Header 2-5: *"Im 'full'-Mode generiert der CacheEngineBuilder alle Cartesian-Product-Permutationen ueber diese Achsen."*
- **Parse-Pfad: KEIN Datei-Read im Live-Pfad.** Grep-Beleg: `permutation_axes.xml` erscheint nur in Kommentaren (`xml_config_parser.hpp:14,34,93`; `profile_to_tree.hpp:9,21`; `workload_matrix.hpp:26`), nirgends als `ifstream`/`parse_document`. Die live-`AxisRegistry` (`profile_to_tree.hpp:22`, `std::map<string,vector<string>>`) wird aus den **kompilierten `EnabledStrategies`** reflektiert (`run_lazy_150.cpp:143-145`: *"Die gueltigen Achsen-Werte kommen aus den REALEN EnabledStrategies … NICHT aus einer hartkodierten Liste"*). `permutation_axes.xml` ist damit der **deklarative Katalog / die dokumentierte Wertebereichs-Quelle** ("full"-Modus, `xml_config_parser.hpp:34`), nicht der Runtime-Reader.
- Zuordnung: **compile-time / statisch → binary_id**.

Nuance (Ehrlichkeit): Die Achsen-Namen in `permutation_axes.xml` (REV 7.6: `page/node/traversal/…`) unterscheiden sich von den live-m3v2-Achsen im Code (`search_algo/node_type/memory_layout/…`, s. `m3v2_study.profile.xml:38-72`). Der XML-Katalog ist die ältere REV-7.6-Vokabelliste; die operative Achsen-Wertemenge kommt aus `build_all_axis_levels()`.

### B) `load_profiles/*.xml` — die Workloads/Lastprofile (RUNTIME, Achse 2)
- Pfad: `libs/cache_engine/algorithm_profiles/load_profiles/` (20 Dateien: `ycsb_a..f`, `coco_p04_neg{0,25,50,75,100}`, `ih`, `lh`, `lp_balanced_5050`, `lp_bulk_insert`, `lp_concurrent_rmw`, `lp_delete_heavy`, `lp_dynamic_trace`, `lp_mixed_oltp`, `lp_range_scan`, `lp_read_uniform`).
- Root `<comdare_load_profile id="…">`; definiert die Workload-CHARAKTERISTIK: `seed`, `records`, `num_operations`, `op_mix insert/lookup/erase/clear/scan/rmw`, `key_distribution`, `zipfian_theta`, `negative_query_pct`, `scan_length_max` (Beispiel `ycsb_a.xml:9-18`, `coco_p04_neg25.xml:13-17` mit `negative_query_pct=25`, `lp_range_scan.xml:13,17` mit `scan=1.0`/`scan_length_max=1000`).
- **Parse-Pfad:** `parse_load_profile` (`load_profile_parser.hpp:74-118`) über den self-contained DOM `cx::parse_document` (`xml_reader.hpp`); Discovery via `discover_load_profiles` (`load_profile_parser.hpp:122-133`). Ergebnis → `WorkloadConfig`.
- Zuordnung: **runtime / dynamisch (Achse 2)**. `load_profile_parser.hpp:6-8`: *"Die Workload-CHARAKTERISTIK … kommt aus dem XML; die SKALA (records, n_ops) setzt der Aufrufer (Harness) … Die Lastprofile sind die Werte der dynamischen Workload-Achse (Achse 2)."*

### C) `sota/*.profile.xml` — Paper-Originale = statische Achsen-Tupel (COMPILE-TIME)
- Pfad: `libs/cache_engine/algorithm_profiles/sota/` (33 Dateien: `art`, `hot`, `masstree`, `surf`, `coco_trie`, `wormhole`, …).
- Root `<comdare_algorithm_profile id="…" paper_ref="…">`; ein voll gepinntes statisches Achsen-Tupel `<axes>` (`art.profile.xml:10-22`: page/node/traversal/value_handle/concurrency/allocator/prefetch/telemetry/isa/layout/reclamation) + `key_value_signature` + `expected_workload`.
- **Parse-Pfad:** `XmlConfigParser::parse_profile` + `load_sota_profiles` (`xml_config_parser.cpp:100-170`), **regex-basiert** (nicht DOM). Nur der `sota/`-Ordner wird gescannt (`xml_config_parser.cpp:79-81`).
- Zuordnung: **compile-time / statisch** ("defined"-Modus, `xml_config_parser.hpp:33`). Referenziert von Thesis-Profilen als `base_tiers … profile_ref="../sota/*.xml"`.

### D) `allocators/*.profile.xml` — Allokator-Katalog (deskriptiv, COMPILE-TIME-Achse)
- Pfad: `libs/cache_engine/algorithm_profiles/allocators/` (23 Dateien: `jemalloc`, `mimalloc`, `tcmalloc`, `hoard`, …).
- Root `<comdare_allocator_profile id="…" family_ref="…">`; Allokator-Unterachsen `<axes>` (`jemalloc.profile.xml:11-17`: granularity/numa/thread_local/…) + `abi` + `expected_workload`.
- **Parse-Pfad: KEIN Loader im gezeigten Code.** `parse_profile` matcht nur Root `comdare_algorithm_profile` (`xml_config_parser.cpp:120`), `load_sota_profiles` scannt nur `sota/`. Diese Dateien sind **Katalog/Doku** für die Werte der `allocator`-Achse.
- Zuordnung: **compile-time** (allocator ist statische Achse), aber als Beschreibung, nicht als aktiver Parse-Input.

### E) `thesis_profiles/*.profile.xml` — der Diplomarbeit-Konfigurator (MASTER, mischt compile+runtime)
- Pfad: `libs/cache_engine/algorithm_profiles/thesis_profiles/` (5 Dateien: `base_pilot`, `cacheline_study`, `m3v2_smoke`, `m3v2_sota_pilot`, `m3v2_study`).
- Root `<comdare_thesis_profile id="…" schema_version="…">`. Struktur (`m3v2_study.profile.xml`, `cacheline_study.profile.xml`):
  - `<base_tiers>` → statische Tupel via `profile_ref` → `sota/*.xml` (compile-time)
  - `<permute_axes>` → **permutierte = COMPILE-TIME-Achsen** (`m3v2_study:38-72`; `cacheline_study:24-50` inkl. per-Organ `cacheline`-Unterachse)
  - `<compile_dims><workloads>A B C D E F</workloads>` + `<telemetry>` (deklariert als "je Binary gebacken", `cacheline_study:52-56`)
  - `<runtime_dynamic><thread_count/><hw_prefetcher/>` → **RUNTIME-Dimensionen** (`m3v2_study:135-138`)
  - `<axis_sweeps>`, `<sota_series_set>`, `<working_set_sweep>`, `<repetitions>`, `<run_options>`, `<fixed_conditions>`, `<modes>` (3 Merge-Stufen), `<key_value_signature>`
- **Parse-Pfad:** `XmlConfigParser::parse_thesis_profile` (`xml_config_parser.cpp:199-296`) über den **self-contained DOM** `comdare::common::xml::parse_document`.
- Zuordnung: **gemischt** — `permute_axes`→compile-time (binary_id), `runtime_dynamic`→runtime.

Wichtige Ehrlichkeits-Nuance zu `<compile_dims><workloads>`: `tp.workloads` wird zwar geparst (`xml_config_parser.cpp:227-228`), aber **im Live-Bau-/Mess-Pfad nicht in eine Binary gebacken** — der einzige Konsument im Grep ist der Parser-Test (`test_kf1_thesis_profile_parser.cpp:88`, prüft `size==6`). Die operative Workload-Achse ist die **Runtime-`load_profiles`-Achse** (Achse 2, s. B). Das ist die #135/Strang-A-Verdrahtungsrealität: die deklarierte "compile-time"-Workload-Dimension ist heute faktisch runtime.

### F) `example_configs/*.xml` — Legacy-Config-Sätze (REV 7 §5.2 Skelett)
- Pfad: `libs/cache_engine/builder/example_configs/` (4 Dateien: `cache_engine_permutations`, `search_algorithm_permutations`, `allocator_permutations`, `test_data_sets`).
- Root `<comdare>` mit Einträgen `<cache_engine_permutation>` / `<search_algorithm>` / `<allocator_permutation>` / `<test_data_set>`. `test_data_sets.xml:3-15` enthält Workload-Deskriptoren (YCSB A/C, `num_operations`, `key_distribution`).
- **Parse-Pfad:** `XmlConfigParser::parse` / `parse_one` (`xml_config_parser.cpp:70-97`), **regex** `parse_xml_string` (`xml_config_parser.cpp:26-44`). Selbst-beschrieben als *"Skelett … Phase 6.4"* (`xml_config_parser.hpp:9`).
- Zuordnung: **Legacy**. Der alte Config-Set-Pfad (REV 7 §5.2), weitgehend abgelöst durch thesis_profile + load_profile. `test_data_sets.xml` ist runtime-Workload-Deskriptor, aber im Alt-Skelett.

---

## 2. Die drei Parser (Parse-Pfade im Detail)

1. **`xml_reader.hpp`** (`libs/common/serialization/xml_config_parser/xml_reader.hpp`) — minimaler **self-contained XML-DOM** (`comdare::common::xml::parse_document → XmlNode`, Z. 194-200). Bewusst ohne tinyxml2 (Offline-Build, `xml_reader.hpp:4-5`). Basis für die DOM-Parser (load_profile + thesis_profile).
2. **`load_profile_parser.hpp`** (`libs/cache_engine/builder/workload_driver/`) — `parse_load_profile` (Z. 74-118) + `discover_load_profiles` (Z. 122-133) → `LoadProfile{ WorkloadConfig }`. Nutzt DOM.
3. **`xml_config_parser.cpp/.hpp`** (`libs/common/serialization/xml_config_parser/`) — `XmlConfigParser` mit gemischter Technik: **regex** für Legacy-Config-Sätze (`parse_one`), sota-Profile (`parse_profile`) und Messreihen; **DOM** für `parse_thesis_profile`.

Inverse Seite (für "Framework von Workloads"): `load_profile_writer.hpp` (`write_load_profile_xml`, Z. 154) ist die exakte Inverse zu `parse_load_profile` — Schema-treuer Writer + Extraktor (Auto-Erzeugung von Profilen).

---

## 3. Wie XML-Werte in den Experiment-Baum einspeisen (Q2)

Der Baum (`experiment_tree.hpp`) trennt **zwei Knotentypen** (GoF Factory-Method, `experiment_tree.hpp:27-34`):

- **`StaticAxisNode`** (`experiment_tree.hpp:115-128`): `contributes_to_signature()==true`, `is_runtime_loop()==false`. Jeder statische Pfad Wurzel→Blatt = **eine Tier-Binary-DLL**. `binary_count = ∏ statische Ebenengrößen` (rein arithmetisch, nie voll materialisiert, `experiment_tree.hpp:18`). → **binary_id** (compile-time).
- **`DynamicVariableNode`** / `AxisLevel{is_static=false}` (`experiment_tree.hpp:189-194`): *"DYNAMISCHE Variablen sind VIRTUELL ineinander verschachtelte for-Schleifen … zur Laufzeit über EINER Tier-Binary"* (`experiment_tree.hpp:22-25`). Verändert die `binary_id` **nicht**.

**Statischer Einspeisepfad (compile-time → binary_id):** thesis_profile `<permute_axes>` / sota-`<axes>` → `AxisLevel{is_static=true}` → `StaticAxisNode` → `StaticBinaryView[i]` dekodiert genau EINEN Pfad on-demand → `BuildOrchestrator` baut die DLL (`cache_engine_builder_iterator.hpp:8-10`). Live-Wertebereiche aus `build_all_axis_levels()`/`EnabledStrategies`; `permutation_axes.xml` ist der deklarierte Katalog dahinter.

**Dynamischer Einspeisepfad — Workload (runtime for-Schleife):**
- `run_lazy_150.cpp:189-206`: liest `COMDARE_LOAD_PROFILE_DIR` → `discover_load_profiles(lpd)` → je Profil `parse_load_profile` → füllt `workload_registry[id] = lp->config` + `workload_values`. Bei gesetztem Dir aber 0 Profilen: **harter Abbruch** (*"Achse 2 darf nicht still entfallen"*, Z. 201-204).
- `profile_run_entry.hpp:132-134`: injiziert die Workload-Achse als **dynamische Ebene** `AxisLevel{"workload", workload_values, is_static=false, "workload_id", "workload"}`. Kommentar Z. 123-131: *"is_static=false ⇒ veraendert die binary_id NICHT (Round-Trip-Gate unberuehrt)."*
- `perm_runner.hpp:211-233` (`run_workload_perm`): löst `workload_id` **zur Laufzeit** gegen die `registry` (XML-`WorkloadConfig`) auf; Fallback `profile_by_name` (hartcodiert, `workload_profiles.hpp:23-35`). `WorkloadGenerator gen{cfg}` materialisiert die Op-Sequenz (Z. 267-268), gleiche Config+Seed ⇒ bit-identisch über alle Binaries.

**`discover_load_profiles` / `parse_load_profile` konkret:**
- `discover_load_profiles` (`load_profile_parser.hpp:122-133`): iteriert das Verzeichnis, ruft je `.xml` `parse_load_profile`, sammelt `(id, pfad)`, sortiert alphabetisch nach `id`. Das ist die **Werte-Menge der dynamischen Workload-Achse**.
- `parse_load_profile` (`load_profile_parser.hpp:74-118`): Datei lesen → `parse_document` → Root muss `comdare_load_profile` sein (sonst `nullopt`) → `id`/`lp_id`/`paper_ref`/`metadata.name` → `<workload>`: `seed` (Default 42), `records`, `num_operations`, **`op_mix` PFLICHT** (fehlt/leer ⇒ `nullopt`, Z. 94-107 "MAJOR-MESS-05" — kein stilles Default), `key_distribution`, `zipfian_theta`, `negative_query_pct`, `scan_length_max` → `WorkloadConfig`. Skala default (`num_operations→1000`, `key_max→records|1e6`), vom Aufrufer überschreibbar (Z. 113-116).

---

## 4. Ist die Workload-Konfiguration XML-getrieben und zur Runtime geladen? (Q3)

**Ja.** Op-Mix, Seed, Verteilung, Negativ-Query-%, Scan-Länge kommen aus dem XML `<workload>`-Block → `WorkloadConfig` (`load_profile_parser.hpp:89-112`), zur **Laufzeit** via `discover_load_profiles` geladen und in `run_workload_perm`/`WorkloadGenerator` ausgeführt (`perm_runner.hpp:219-268`).

Ehrliche Nuancen:
- **Skala** (`num_operations`, `records`=Dataset-Größe) ist im XML nur Default; der Harness überschreibt sie zur Laufzeit (`perm_runner.hpp:233-239`; `working_set_sweep`).
- Das **Dataset selbst** ist synthetisch: die Load-Phase fügt `records` sequentielle Sätze ein (`perm_runner.hpp:263`: `tier_insert(i, i*7+1)`), Größe/Verteilung XML-getrieben, Keys generiert. Kein externer Datensatz-Import.
- Op-Kinds jenseits der ABI degradieren ehrlich (z.B. `Scan` braucht `IScannableTier`, sonst übersprungen; `workload_config.hpp:247-249`).

---

## 5. Anforderung an die XML-Struktur für ein "Framework von Workloads als runtime" (Q4)

Aus dem bestehenden Design ableitbar — die XML-Struktur muss:

1. **Charakteristik von Skala trennen.** Op-Mix/Verteilung/neg%/scan im XML; `records`/`n_ops` als überschreibbare Skala → dasselbe Profil test- und voll-skaliert (`load_profile_parser.hpp:6-8,29-38`).
2. **Stabile `id` = Achsenwert.** Root-`@id` = `workload_id` = CSV-`profile_name` = Baum-Ebenenwert (`load_profile_parser.hpp:80,87`; `perm_runner.hpp:242`). `discover_load_profiles` sortiert/schlüsselt darauf.
3. **Verzeichnis = Wertemenge (Drop-in ohne Rebuild).** Eine XML-Datei mehr = ein Achsenwert mehr, ohne Neukompilierung, weil die Achse `is_static=false` ist (`discover_load_profiles` scannt Dir; `profile_run_entry.hpp:132-134`). Das ist der Kern von "runtime".
4. **Vollständige, nicht still defaultende Definition.** `op_mix` PFLICHT, leeres op_mix ⇒ `nullopt` (`load_profile_parser.hpp:94-107`) — ein Workload muss sich selbst voll deklarieren oder wird ehrlich abgelehnt (sonst würde ein anderes als das dokumentierte Profil gemessen).
5. **Determinismus/Reproduzierbarkeit.** Fester `seed` im XML; gleiche Config+Seed ⇒ bit-identische Op-Sequenz über **alle** Binaries (Cross-Binary-Vergleichbarkeit = Spalte des kartesischen Kreuzes; `workload_config.hpp:89-98`, `perm_runner.hpp:267`, `cache_engine_builder_iterator.hpp:74-77`).
6. **Runtime-only, nicht in `binary_id`.** Die Workload-Ebene darf die compile-time-Round-Trip-Identität nicht stören (`is_static=false`) und muss über **eine geladene DLL** via ABI-Sub-Interfaces (`IObservableTier`/`IRollbackableTier`/`IScannableTier`) anwendbar sein — Ops müssen auf die Runtime-ABI abbilden, nicht auf Rekompilierung angewiesen sein (`perm_runner.hpp:211-216,267-273`).
7. **Mess-Gültigkeit erzwingbar.** Der Runtime-Workload muss durch den Zwei-Phasen-Warmup (save→warmup→rollback→measure) laufen; ohne exakten Rollback (`IRollbackableTier`) wird `two_phase_valid=false` gesetzt statt still kalt gemessen (`perm_runner.hpp:207-209,248-251`).
8. **Round-trip-fähiges Schema.** `load_profile_writer.hpp` (Inverse zu `parse_load_profile`) erlaubt Auto-Generierung von Profilen aus gemessenen Op-Zählern → das Framework kann Workloads programmatisch erzeugen und wieder konsumieren.

---

## Relevante Pfade (absolut)

- Achsen-Permutation (compile-time): `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/algorithm_profiles/permutation_axes.xml`
- Workloads (runtime, Achse 2): `…/libs/cache_engine/algorithm_profiles/load_profiles/*.xml`
- Paper-Tupel (compile-time static): `…/libs/cache_engine/algorithm_profiles/sota/*.profile.xml`
- Allokator-Katalog: `…/libs/cache_engine/algorithm_profiles/allocators/*.profile.xml`
- Master-Konfigurator (gemischt): `…/libs/cache_engine/algorithm_profiles/thesis_profiles/*.profile.xml`
- Legacy-Config: `…/libs/cache_engine/builder/example_configs/{cache_engine,allocator,search_algorithm}_permutations.xml`, `test_data_sets.xml`
- Parser: `…/libs/common/serialization/xml_config_parser/{xml_reader.hpp, xml_config_parser.cpp, xml_config_parser.hpp}`, `…/libs/cache_engine/builder/workload_driver/{load_profile_parser.hpp, load_profile_writer.hpp, workload_profiles.hpp, workload_config.hpp}`
- Baum/Verdrahtung: `…/libs/cache_engine/builder/experiment_tree/{experiment_tree.hpp, perm_runner.hpp, cache_engine_builder_iterator.hpp, profile_to_tree.hpp}`, `…/tests/unit/thesis_tiere/{run_lazy_150.cpp, profile_run_entry.hpp}`