I now have a complete picture. Let me compile the structured mapping. No further file reads are needed.

---

# E4-XML-Kartierung: Messreihen-Struktur + messung_driver-Parser + #31-Andockpunkte

Alle Pfade relativ zu `…/probst-diplomarbeit-cache-engine/Code/`. Strikt read-only — keine mutierenden Befehle ausgeführt.

## Kernbefund vorab (für #31-Planung)

Es gibt **zwei parallele E4-XML-Welten** und **eine dritte, compile-time-Welt**, die bisher NICHT verbunden sind:

| Welt | Schema/Root | Status | Ort |
|---|---|---|---|
| **G1 produktiv** | `<comdare_messreihen>` / `<comdare_experiment>` | AKTIV (regex-Reader in `main.cpp`) | `experiment_config/*.xml` |
| **G2 v32 opt-in** | `<messreihe version="32">` | NUR Tests, `COMDARE_V32_ENABLE=OFF` | `test_data_xml/messreihe_v32_schema.xsd` |
| **#31 compile-time** | `enum WorkloadKind × CanonicalDataset` | NUR Test, nicht verdrahtet | `external/…/workload_driver/workload_matrix.hpp` |

Die #31-2D-Matrix existiert bereits **compile-time in C++** (`workload_matrix.hpp`, heute 09.07. modifiziert), aber es fehlt die **E4-XML-Brücke**, die sie aus der Messreihen-Definition heraus ansteuert.

---

## Frage 1 — Wie definiert `messreihen.xml` + `config_a` heute eine Messreihe?

### `experiment_config/messreihen.xml` (produktiv, `--messreihen-xml=…`)
Root `<comdare_messreihen version="1">` (Zeile 14). Je Messreihe NUR drei wirksame Elemente:
- `<messreihe id="…">` (z.B. Z.17 `A_defined`)
- `<description>` (Z.18-21) — vom Parser ignoriert
- `<mode>` (Z.22) — `defined` | `full`
- `<profile>`-Liste (Z.23-30) — nur im `defined`-Mode

Vier Reihen: `A_defined` (8 Profile), `A_full` (Z.34, keine Profile → full), `B_CacheEngine_Perms` (Z.43), `C_Merge_Alt_Neu` (Z.53, 4 Profile).

**Wichtig:** `messreihen.xml` trägt **keine** `<workloads>`, `<parameters>`, `<datasets>`, `<output>`. Nur `id`/`mode`/`profile`.

### `experiment_config/config_a_prt_art_vs_sota.xml` (reicheres Legacy-Format)
Root `<comdare_experiment>` (Z.6). Enthält drei aktive + ein Legacy-Muster:
- `A_defined` (Z.7): `<mode>` + `<sota_profiles>/<profile>` (Z.14-23) + `<pruefling>` (Z.25-30: name/source/profile/api_variant)
- `A_full` (Z.33): `<mode>full` + **`<axes_source>`** (Z.42 → `cache_engine/algorithm_profiles/permutation_axes.xml`) + `<pruefling_axes_extension>` (Z.43)
- `A_legacy` (Z.52): das reichste Muster, aber „NICHT mehr aktiv ab V8.13":
  - `<test_algorithm>` (Z.55-59)
  - `<comparison_baselines>/<baseline id adapter>` (Z.61-70)
  - **`<workloads>/<workload type="ycsb">A…F`** (Z.72-79)
  - **`<parameters>`** (Z.81-88: `num_keys`, `num_operations`, `key_size_bytes`, `value_size_bytes`, `zipfian_theta`, `seed`)
  - **`<output>`** (Z.90-99: `binary_path`, `csv_path`, `latex_path`, `<diagrams>/<diagram type plot>`) — inkl. **`<diagram type="heatmap" plot="workload_vs_permutation_throughput"/>`** (Z.97)
- `<shared>` (Z.103-120): gemeinsame `<workloads>` + `<parameters>` für A_defined/A_full

`config_b` (`<use_existing_builder>`, `<builder_config_dir>` Z.13, `<workloads>`, `<parameters>`, `<output>` mit Heatmap Z.37) und `config_c` (`<merge_points>/<merge_point>` mit `<*_baustein from baustein>` Z.14-36, `<output>/<diff_against>` Z.57, Heatmap Z.61) folgen demselben `<comdare_experiment>`-Schema.

---

## Frage 2 — Das v32-Schema (`messreihe_v32_schema.xsd`)

Root `<messreihe version="32">` (XSD Z.12, `fixed="32"` Z.21). Struktur (XSD Z.12-23):
`<metadata>` → `<execution_engines>` → `<axes_default_lookup>?` → `<tupel>+` → `<output>`.

Das **Tupel** (`TupelType`, XSD Z.65-147) ist die feingliedrige Zelle **Workload × op_type × Strategie**:
- `<workload kind record_count operation_count seed>` (Z.67-74)
- `<op_type>` OP-1..OP-6 (Z.76-87)
- `<hardware_strategy>` (simd/cache_level/numa/prefetch_distance/atomic_granularity, Z.89-99)
- `<scheduling_strategy>` (worker_pool/simd_workers/heterogeneous_awareness/memory_interleave/batching, Z.101-111)
- `<compiler_strategy>` (family/opt_level/lto/pgo/target_arch, Z.113-132)
- `<axes>/<axis id baustein>` (Z.133-144)

`<execution_engines>` verlangt **genau 2** `<engine>` (Z.43, EE-A CacheEngine vs. EE-B PrtArt — Beispiel `messreihe_v32_schema_example.xml` Z.18-21). `<output>` trägt zusätzlich `<comparison_metrics>` (Z.154, F15-Verdict).

### Ist es aktiv?
**NEIN — opt-in, per Default AUS.** Belege:
- `02_messung_driver/CMakeLists.txt:22` → `option(COMDARE_V32_ENABLE … OFF)`; nur bei ON wird `v32_orchestrator.hpp` überhaupt inkludierbar (Z.23-27).
- `main.cpp` inkludiert **weder** `v32_orchestrator.hpp` **noch** `messreihe_v32_validator.hpp` (Includes: `main.cpp:28-34`).
- `V32Orchestrator` + `MessreiheV32Validator` werden AUSSCHLIESSLICH in `tests/unit/test_v32_orchestrator.cpp` / `test_messreihe_v32_validator.cpp` referenziert.
- Der cache-engine-Gegenpart ist ebenfalls OFF: `external/…/builder/commands/CMakeLists.txt:14` `COMDARE_V32_ENABLE … OFF`.

### Welches Schema ist produktiv?
**G1** (`comdare_messreihen`/`comdare_experiment`). Der produktive Reader ist die regex-basierte `load_messreihen()` in `main.cpp:173-204` (liest nur id/mode/profile) plus der cache-engine-Parser `XmlConfigParser::load_messreihen` (`external/…/xml_config_parser/xml_config_parser.cpp:172-196`). G2/v32 ist das reichere Ziel-Schema, aber test-only.

---

## Frage 3 — Wie liest der messung_driver die XML und reicht sie an die cache-engine?

**Schritt A — driver-eigener Reader** (`main.cpp:173-204`, `load_messreihen`):
- Regex `<messreihe\s+id\s*=\s*"([^"]+)"[^>]*>…</messreihe>` (Z.182) — beachte `[^>]*>` (erlaubt Extra-Attribute wie `name=`).
- Extrahiert NUR `id` (Z.187), `<mode>` (Z.190-195), `<profile>`-Liste (Z.197-200). `MessreihenSpec` (Z.167-171) hat genau diese 3 Felder. **Workloads/Parameters/Output/Datasets werden komplett ignoriert.**

**Schritt B — Übergabe an cache-engine** (`main.cpp:461-492`): pro Spec ein `cb::ExperimentDriverOptions` (Z.467-473):
```
opts.config_dir          = config_dir;
opts.output_dir          = output_dir / spec.id;
opts.messreihen_mode     = (spec.mode=="full") ? Full : Defined;   // Z.471-472
opts.sota_profile_filter = spec.sota_profiles;                     // Z.473
```
Danach `cb::ExperimentDriver driver{opts}; driver.run_pipeline_full(w);` (Z.475-485) mit **hartkodiertem** Default-Workload (YCSB_C, seed 42, 1M keys, 5M ops — Z.476-483). Der Workload aus der XML wird also gar nicht durchgereicht.

**Schritt C — cache-engine-Parser** (`external/…/xml_config_parser/xml_config_parser.cpp`). `XmlConfigParser::parse(config_dir)` liest **vier feste Dateinamen** (Z.72-75):
- `cache_engine_permutations.xml`
- `search_algorithm_permutations.xml`
- `allocator_permutations.xml`
- **`test_data_sets.xml`** (Z.75, Tag `test_data_set` — parse_one Z.92)

plus optional `algorithm_profiles/sota/*.profile.xml` (Z.78-81) und `messreihen.xml` (Z.82-83). Diese Erwartung ist auch in der Usage dokumentiert: `main.cpp:155-159`.

**Subtile Falle für #31:** Der cache-engine-Reader nutzt die **striktere** Regex `<messreihe\s+id\s*=\s*"([^"]+)"\s*>` (`xml_config_parser.cpp:177`, `\s*>` = kein Extra-Attribut erlaubt). `config_a`s `<messreihe id="A_defined" name="…">` würde hier NICHT matchen — nur das attributfreie `messreihen.xml`-Format. Der driver-eigene Reader (`[^>]*>`) ist lockerer. Eine #31-Erweiterung muss beide Regex-Stellen konsistent halten.

**`test_data_sets.xml` existiert nirgends** (find: 0 Treffer) → die Dataset-Achse ist parserseitig aktuell leer.

---

## Frage 4 — Wo genau würde #31 andocken?

### (a) `<datasets>` — Achse D (Verweis auf `test_data_xml/*.test_data.xml`)
**Existiert NICHT** in den Messreihen-XMLs. Aktueller Zustand:
- Datasets leben in `test_data_xml/<name>.test_data.xml`, Root `<comdare_test_data id source>` mit `<metadata>`, `<key_value_signature>`, `<local_path>`, `<loader>/<dataset_source>` (z.B. `sosd_books_200M.test_data.xml:25-28`, `protein.test_data.xml:29-32`), `<dataset_akte>` (Prüfsumme), `<expected_workload>`.
- Der 6er-Kanon (url/dna/protein/xml/tpcds-id/trec-terms) ist in `test_data_xml/README.md:54-63` fixiert und **compile-time hartkodiert** als `enum class CanonicalDataset` in `workload_matrix.hpp:80-101`.
- **Bruch:** cache-engine erwartet `test_data_sets.xml` (Tag `test_data_set`); die Diplomarbeit liefert `*.test_data.xml` (Tag `comdare_test_data`). Kein Parser liest die `test_data_xml/`-Dateien in den Mess-Lauf ein.

**Fehlendes XML-Element** (Vorschlag) in `<messreihe>`:
```xml
<datasets>
  <dataset ref="test_data_xml/url.test_data.xml"/>
  <dataset ref="test_data_xml/protein.test_data.xml"/>
</datasets>
```
**Parser-Stellen zum Erweitern:**
- `main.cpp:167-171` (`struct MessreihenSpec` → Feld `std::vector<std::string> datasets`)
- `main.cpp:197-200` (neue `<dataset>`-Regex-Schleife analog `<profile>`)
- `main.cpp:473` (neues `opts.dataset_filter = spec.datasets;` — Feld in `ExperimentDriverOptions` fehlt noch, aktuell nur `sota_profile_filter`)
- `external/…/xml_config_parser.cpp:172-196` (cache-engine `load_messreihen` spiegeln) + Anschluss an `CanonicalDataset` in `workload_matrix.hpp:80`

### (b) `<measurement_categories>` — Achse M (Output-Spalten-Projektion)
**Existiert NICHT.** Nächste vorhandene Konzepte:
- **Mess-Framework-Identifier** = `telemetry_hint` in `op_type_filter.hpp:57,64-75` (`LeafOnlyCounter (11.X1)`, `RetroactiveAggregator (11.X3)`, `PathReadCounter (11.X3b)`) — das sind die „Mess-Frameworks". Konkrete Implementierungen in `external/comdare-prt-art/…/telemetry/leaf_only_counter.hpp` u.a.
- **Output-Spalten** = die Felder von `comdare_measurement_record_v1` in `measurement_writer.hpp:88-107` (total_cycles, cache_misses_l1/l2/l3, dtlb_misses, coherence_invalidations, energy_micro_joules, bytes_allocated, fragmentation).

**Fehlendes XML-Element** (Vorschlag):
```xml
<measurement_categories>
  <category>cycles_per_op</category>
  <category>cache_misses_l1</category>
  <category telemetry="LeafOnlyCounter">leaf_visits</category>
</measurement_categories>
```
**Parser-Stellen:** `measurement_writer.hpp:49-63` (add-Signatur / Spaltenauswahl), `stats_aggregator.hpp` (CSV-Projektion, via `main.cpp:308-311` `write_stats_csv`), sowie `op_type_filter.hpp:51-59` (`OpTypeRecommendation.telemetry_hint` als autoritative Framework-Quelle).

### (c) 2D-Matrix „Mess-Frameworks × Workloads"
**Existiert als solche NICHT.** Die einzige echte 2D-Matrix ist compile-time **Workloads × Datasets** (`workload_matrix.hpp:105` `matrix_cells = mp_product<…, ycsb_profile_list, dataset_list>`, 36 Zellen). Achse „Mess-Frameworks" ist eine **dritte, neue Achse** und müsste als eigenes XML-Element deklariert und mit `<workloads>` gekreuzt werden — z.B. in einem `<matrix>`-Block:
```xml
<matrix>
  <axis name="workload" ref="workloads"/>
  <axis name="framework" ref="measurement_categories"/>
</matrix>
```
Andockpunkt compile-time: das Muster von `matrix_cells` (`workload_matrix.hpp:103-110`) auf eine dritte `mp_list` erweitern; XML-seitig neuer Parser in `load_messreihen` (`main.cpp:173-204`).

---

## Frage 5 — Gibt es bereits eine 2D-Matrix (Mess-Frameworks × Workloads) oder Heatmap-Output in der XML?

- **Mess-Frameworks × Workloads: NEIN.** Nirgends.
- **Compile-time 2D-Matrix (Workloads × Datasets): JA, aber nicht in XML** — `workload_matrix.hpp` (`matrix_cell_count == 36`, Z.106/110), verifiziert nur durch `external/…/tests/unit/test_31_workload_matrix.cpp` (`TwoDMatrixIsWorkloadTimesDataset`, Z.48-57). **Nicht** in `messung_driver`/`experiment_driver` verdrahtet (grep: 0 Nicht-Test-Treffer).
- **Heatmap-Output in XML: JA, aber im toten Legacy-Zweig** — `config_a:97` (`workload_vs_permutation_throughput`), `config_b:37` (`allocator_vs_concurrency_throughput`), `config_c:61` (`merge_point_vs_workload_speedup`). Diese `<diagram>`/`<output>`-Blöcke liegen im `<comdare_experiment>`-Legacy-Format und werden vom produktiven `load_messreihen`-Reader (`main.cpp`) **nicht gelesen** (nur id/mode/profile).

---

## Frage 6 — measurement-all-Bezug (Doc 15 Option A) vs. rein E4-XML?

**Beides greift ineinander — #31 ist NICHT rein E4-XML.** Belege:

- `workload_matrix.hpp` IST die „2D-Matrix als compile-time-Parametrisierung": Header-Kommentar Z.2-20 rahmt es als **Hybrid** (compile-time `WorkloadKind`/`ycsb_profile_list` als Achse W „wie eine DynamicVariableNode-Wertmenge des experiment_tree", runtime `profile_by_name` unverändert) und **golden/ABI-neutral** (Z.19-20: „Workload ist Mess-INPUT, orthogonal zur Anatomie-Permutation"). Das entspricht exakt Doc 15 **Option A** (2D-Matrix in den Baseline-Zellen, compile-time).
- Damit hat #31 **Schritt-1 bereits als compile-time-Trait** gelandet (in der cache-engine-Baseline, E2-nah). Die `test_31_workload_matrix.cpp`-Kommentare (Z.1-4) betonen „WorkloadKind-Reuse, kein neuer Enum, golden-neutral".
- Für die #229-Zielinvariante „**die Diplomarbeit ändert NUR die XML**" (Dossier §14, Z.399; §13 Ebenen-Tabelle Z.385-390) fehlt die **E4→compile-time-Brücke**: die E4-XML (`<messreihe>`-Tupel bzw. v32-`<tupel>`) müsste eine `<workloads>×<datasets>`/`<measurement_categories>`-Matrix deklarieren, die der Treiber in `matrix_cells` expandiert. Aktuell endet die XML-Seite bei id/mode/profile; die Matrix ist rein in C++.

**Konsequenz für die Planung:** #31 = (1) E4-XML-Erweiterung (`<datasets>`, `<measurement_categories>`, `<matrix>`) in `messreihen.xml`/v32-Schema + Parser (`main.cpp:167-204`, `xml_config_parser.cpp:172-196`) **und** (2) Anschluss an das bestehende compile-time `workload_matrix.hpp` (Option A). Der Dossier-Kontext ordnet #31 zwar E4 zu (§15 Z.450 nennt #25/#156/#162/#184 als E4), aber die Mess-Framework/Dataset-Achsen konsumieren E2-Artefakte (Telemetrie-Slots, `CanonicalDataset`) — der XML-only-Anspruch ist erst erfüllt, wenn die Brücke existiert.

---

## Datei:Zeile-Index (die load-bearing Stellen für die Erweiterung)

- Produktiver Reader: `02_messung_driver/main.cpp:167-204` (`MessreihenSpec` + `load_messreihen`), Übergabe `main.cpp:461-485`
- cache-engine Parser: `external/comdare-cache-engine/libs/common/serialization/xml_config_parser/xml_config_parser.cpp:70-97` (4 Dateinamen), `:172-196` (`load_messreihen`, strikte Regex Z.177)
- v32-Schema: `test_data_xml/messreihe_v32_schema.xsd:65-147` (Tupel), Beispiel `messreihe_v32_schema_example.xml`
- v32-Gate (OFF): `02_messung_driver/CMakeLists.txt:22-31`
- Compile-time-Matrix (#31 Option A): `external/…/builder/workload_driver/workload_matrix.hpp:57-110`, Test `external/…/tests/unit/test_31_workload_matrix.cpp:48-57`
- Mess-Framework-Hints: `02_messung_driver/op_type_filter.hpp:51-76`
- Output-Spalten: `02_messung_driver/measurement_writer.hpp:88-107`
- Dataset-XMLs (Achse D): `test_data_xml/*.test_data.xml` (Root `comdare_test_data`), Kanon-Tabelle `test_data_xml/README.md:54-63`
- E4-Kontext: Dossier §13 Z.385-395, §14 Z.399/412/421-422, §15 Z.449-450

Möchtest du, dass ich als Nächstes einen konkreten XML-Schema-Diff-Entwurf (neue Elemente + genaue Regex-/Struct-Änderungen) für #31 ausarbeite?