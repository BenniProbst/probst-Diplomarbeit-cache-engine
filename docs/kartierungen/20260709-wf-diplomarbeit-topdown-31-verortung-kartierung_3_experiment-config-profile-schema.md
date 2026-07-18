# PROFILE-BEREITSTELLUNG der Diplomarbeit — Kartierung

Basis: `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code` (im Folgenden `<Code>`). Alles read-only kartiert, keine Mutationen.

## Kernbefund: DREI Generationen / ZWEI Verantwortungs-Ebenen

Die Profile-Bereitstellung ist geschichtet. Die Diplomarbeit-XMLs sind **dünne Selektoren/Orchestratoren**, die den **maßgeblichen Katalog der cache-engine** referenzieren. Chronologisch drei Schema-Generationen:

| Gen | Ort | Wurzel-Tag | Konsument | Datum |
|---|---|---|---|---|
| G1 | `<Code>/experiment_config/*.xml` | `comdare_messreihen` / `comdare_experiment` | `02_messung_driver/main.cpp` via `xml_config_parser` | REV 7.6, 2026-05-13/14 |
| G2 | `<Code>/test_data_xml/messreihe_v32_*` | `messreihe version="32"` | `02_messung_driver/v32_orchestrator.hpp` + `messreihe_v32_validator.hpp` | V32/V33, 2026-05-18/21 |
| Kat | `external/comdare-cache-engine/libs/cache_engine/algorithm_profiles/` | `comdare_load_profile`, `comdare_algorithm_profile`, `comdare_permutation_axes` | cache-engine `discover_load_profiles` / builder | User-Direktive 2026-06-08 |
| DS | `<Code>/test_data_xml/*.test_data.xml` | `comdare_test_data` | `messung_driver` (zusätzlich zu CE-Standard-Configs) | V23.X1, 2026-05-14 |

Verifiziert: es gibt **keine** produktiven `messreihe version="32"`-Instanzen — nur das Schema + eine Beispieldatei (`grep -rln 'messreihe version="32"'` → nur `messreihe_v32_schema_example.xml`). G2 ist ein neuerer, noch nicht produktiv befüllter Schema-Strang; `v32_orchestrator`/`v32_validator` sind auch **nicht** in `main.cpp` verdrahtet (Compile-Flag `COMDARE_V32_ENABLE`, opt-in).

---

## Frage 1 — Wie definiert `messreihen.xml` eine Messreihe? Welche Achsen?

`<Code>/experiment_config/messreihen.xml` — Wurzel `<comdare_messreihen version="1">` (Zeile 14). Es ist ein **Treiber-Template** für `comdare-messung-driver <config_dir> <output_dir> --messreihen-xml=messreihen.xml` (Zeile 9); pro Messreihe wird ein eigener `ExperimentDriver`-Lauf gestartet (Zeile 11).

Eine `<messreihe>` besteht hier nur aus wenigen Feldern:
- `id`-Attribut
- `<description>`
- `<mode>` ∈ {`defined`, `full`} — die **Mess-Kategorie „Abdeckung"**
- im `defined`-Mode: Liste `<profile>…</profile>` (handselektiertes SOTA-Subset)

Die 4 Pflicht-Messreihen (`messreihen.xml`):
- **A_defined** (Z. 17–31): `<mode>defined</mode>` + 8 Tier-1-Profile (`art, hot, masstree, coco_trie, start, b2tree, wormhole, surf`)
- **A_full** (Z. 34–40): `<mode>full</mode>`, keine Profil-Liste (= alle 30 SOTA über Kartesisches Produkt)
- **B_CacheEngine_Perms** (Z. 43–50): `<mode>full</mode>`, SOTA-only ohne PRT-ART
- **C_Merge_Alt_Neu** (Z. 53–64): `<mode>defined</mode>` + 4 Profile (`art, hot, b2tree, wormhole`)

```xml
<!-- messreihen.xml:17-31 -->
<messreihe id="A_defined">
  <description>PRT-ART Beitrittspruefung gegen 8 Tier-1-SOTA … (defined Mode).</description>
  <mode>defined</mode>
  <profile>art</profile>
  <profile>hot</profile>
  …
  <profile>surf</profile>
</messreihe>
```

**Achsen/Dimensionen, die `messreihen.xml` selbst ausdrückt, sind dünn:** nur **Messreihe-ID + Mode + Profil-Selektion**. Workload, Dataset und Permutations-Achsen stehen **nicht** hier — die kommen aus (a) den Detail-Configs `config_[abc].xml` und (b) den cache-engine-Katalogen. `messreihen.xml` ist die Klammer, nicht der Achsen-Träger.

Die reicheren Achsen liegen in den **Detail-Configs** (`comdare_experiment`):
- **Workload-Achse**: `<workloads><workload type="ycsb">A…F</workload></workloads>` — `config_a` Z. 72–79 (legacy) + gemeinsam Z. 104–111 (`<shared>`), `config_b` Z. 17–20, `config_c` Z. 38–42.
- **Skala-Parameter** (synthetisch, kein echtes Dataset): `<parameters>` mit `num_keys / num_operations / key_size_bytes / value_size_bytes / zipfian_theta / seed` — `config_a` Z. 112–119.
- **Permutations-Achse (full-Mode)**: `config_a` verweist explizit auf den CE-Katalog:
```xml
<!-- config_a_prt_art_vs_sota.xml:41-43 -->
<mode>full</mode>
<axes_source>cache_engine/algorithm_profiles/permutation_axes.xml</axes_source>
<pruefling_axes_extension>prt_art/algorithm_profiles/permutation_axes_extension.xml</pruefling_axes_extension>
```
- **Merge-Achse (Reihe C)**: `config_c` Z. 14–36 — `<merge_points>` mit `<*_baustein from="prt-art|cache-engine" baustein="…"/>` (z. B. `OlcWithReservedValueBlocks` + `A06_tcmalloc` + `P01_ART_Node`).
- **Pruefling** (Reihe A): `config_a` Z. 25–30 — `<pruefling><name>PRT-ART</name><source>comdare-prt-art</source><profile>prtart_pruefling.profile.xml</profile><api_variant>hybrid_search_engine</api_variant></pruefling>`.

`config_b` nutzt statt SOTA-Liste einen Builder-Verweis: `<use_existing_builder>true</use_existing_builder>` + `<builder_config_dir>../external/comdare-cache-engine/cache_engine/builder/example_configs</builder_config_dir>` (Z. 12–15, „54+ Permutationen").

Jede Detail-Config trägt zusätzlich `<output>` (binary/csv/latex-Pfade + `<diagrams>`), `config_c` zusätzlich `<diff_against>measurements_A.bin</diff_against>` (Z. 57).

---

## Frage 2 — Was ist das v32-Schema (`messreihe_v32_schema.xsd`)?

`<Code>/test_data_xml/messreihe_v32_schema.xsd` (V33.D.1) — formale XSD-Spec der `messreihe_v32_*.xml`-Struktur. Bewusst **code-side validiert** über `02_messung_driver/messreihe_v32_validator.hpp` (header-only, „kein xerces/libxml2 Aufwand", XSD-Kommentar Z. 5–7).

Wurzel `<messreihe version="32">` (fixe `version`, Z. 21), Sequenz (Z. 12–23):

1. **`<metadata>`** (`MetadataType`, Z. 25–39): `name`, `description`, `mode` ∈ {`defined`, `full`, `full_sampled`} — v32 fügt `full_sampled` als dritte Mess-Kategorie hinzu.
2. **`<execution_engines>`** (Z. 41–51): **genau 2** `<engine id type name>` (`minOccurs=2 maxOccurs=2`) — der F15-Vergleich EE-A (CacheEngine-SOTA-Baseline) vs EE-B (PrtArt-Innovationen), parallel registriert.
3. **`<axes_default_lookup enabled="bool">`** (optional, Z. 53–63): Liste `<axis id allowed_variants>` — User-Limit auf die Auto-Permutation fehlender Achsen (CEB-Auto-Permutator).
4. **`<tupel id>`** (`1..unbounded`, `TupelType`, Z. 65–147) — die eigentliche Test-Konfigurations-Zeile:
   - `<workload kind record_count operation_count seed>` (Pflicht, Z. 67–74)
   - `<op_type>` OP-1…OP-6 (optional, Z. 76–87)
   - `<hardware_strategy>` (Z. 89–99): `simd, cache_level, numa, prefetch_distance, atomic_granularity`
   - `<scheduling_strategy>` (Z. 101–111): `worker_pool, simd_workers, heterogeneous_awareness, memory_interleave, batching`
   - `<compiler_strategy>` (Z. 113–132): `family` ∈ {GCC, Clang, AppleClang, MSVC}, `opt_level, lto, pgo, target_arch` (Achse 15)
   - `<axes>` → `<axis id baustein>` (optional, Z. 133–144): explizite Achsen-Spec; fehlt sie → Default-Lookup/Auto-Permutation
5. **`<output>`** (`OutputType`, Z. 149–156): `binary_path, csv_path, latex_path, comparison_metrics:bool` (F15-Verdict + Ratios).

Beispiel (`messreihe_v32_schema_example.xml`) zeigt das Tupel-Prinzip: `<tupel id="t01">` mit `<workload kind="YCSB_C_ReadOnly" record_count="1000000" operation_count="100000" seed="42"/>`, `<op_type>OP-1</op_type>`, Hardware-/Scheduling-Strategie und teil-expliziten `<axes>` (Z. 32–51); `<tupel id="t02">` gänzlich ohne Strategie/Achsen → komplettes Default-Lookup (Z. 53–57).

**v32 fusioniert** also, was in G1 auf `messreihen.xml` + `config_*.xml` verteilt war, in **eine** pro-Tupel-Zeile — und ergänzt die Hardware-/Scheduling-/Compiler-Achsen (12–15) sowie den 2-EE-Parallelvergleich.

---

## Frage 3 — Wie werden Workloads / Mess-Kategorien / Datasets ausgedrückt? Hier definiert oder an die cache-engine gereicht?

Drei unterschiedliche Verortungen:

### WORKLOADS — in der Diplomarbeit nur *benannt/skaliert*, in der cache-engine *definiert*
- Diplomarbeit-Seite: nur Referenz-Namen — G1 `<workload type="ycsb">A</workload>`, v32 `<workload kind="YCSB_C_ReadOnly" …>` + `<op_type>`.
- **Maßgebliche Definition** = cache-engine `algorithm_profiles/load_profiles/*.xml` (`comdare_load_profile`). Diese sind „die **Werte der dynamischen Workload-Achse (Achse 2)**" und werden **zur Laufzeit interpretiert** (`load_profiles/SCHEMA.md` Z. 3–8). Charakteristik (`op_mix`, `key_distribution`, `negative_query_pct`, `scan_length_max`) kommt aus dem XML; die **Skala** (`records`, `num_operations`) setzt der Harness/die Diplomarbeit (`load_profile_parser.hpp` Z. 5–8):
```xml
<!-- load_profiles/ycsb_c.xml:4-19 -->
<comdare_load_profile id="ycsb_c" paper_ref="YCSB" lp_id="LP05" schema_version="1">
  <metadata><name>YCSB-C read-only (point lookup, Zipfian)</name>
    <source>Cooper B.F. … ACM SoCC 2010 …</source></metadata>
  <workload>
    <seed>42</seed><records>10000</records><num_operations>10000</num_operations>
    <op_mix insert="0.0" lookup="1.0" erase="0.0" clear="0.0" scan="0.0" rmw="0.0"/>
    <key_distribution>zipfian</key_distribution><zipfian_theta>0.99</zipfian_theta>
    <negative_query_pct>0</negative_query_pct><scan_length_max>100</scan_length_max>
  </workload>
</comdare_load_profile>
```
- Katalog (22 Dateien): `ycsb_a…f`, `coco_p04_neg{0,25,50,75,100}` (CoCo-Trie Negativ-Query-Sweep, `lp_id=LP06`), `lp_mixed_oltp, lp_range_scan, lp_read_uniform, lp_bulk_insert, lp_delete_heavy, lp_concurrent_rmw, lp_balanced_5050, lp_dynamic_trace, ih, lh`. `id` = Workload-Achsen-Wert (erscheint in CSV-Spalte `workload` + `setting_label`); optionales `lp_id` = Katalog-Tag `LP01–LP14` (`SCHEMA.md` Z. 14–17).
- Harter Validitäts-Gate: fehlendes `<op_mix>` oder Summe ≤ 0 → `parse_load_profile` liefert `nullopt` (kein stilles Default), `load_profile_parser.hpp` Z. 94–107.

### MESS-KATEGORIEN — mehrschichtig, teils Diplomarbeit / teils Katalog
- **Abdeckungs-Kategorie**: `<mode>` defined | full | full_sampled (Diplomarbeit).
- **Vergleichs-Kategorie**: Messreihe-Identität A/B/C (Pruefling-vs-SOTA / SOTA-only / Merge) → wandert als `row_series` ∈ {A,B,C} in die CSV (`cache_engine_builder_iterator.hpp` Z. 93).
- **Operations-Kategorie**: `<op_type>` OP-1…OP-6 (v32).
- **Struktur-Achsen (Design-Space-Kategorien)**: die 11 Permutations-Achsen aus `permutation_axes.xml` (Katalog, s. u.); in v32 als `<axis id baustein>` selektiert.
- **F15-Verdikt**: `comparison_metrics` (v32) bzw. `<diff_against>` (G1 config_c).

### DATASETS — echte Datensätze werden *in der Diplomarbeit selbst* definiert
- `<Code>/test_data_xml/*.test_data.xml` (`comdare_test_data`) ist der **„eigene Konfigurations-Slot der Diplomarbeit"**, den `messung_driver` **zusätzlich** zu den CE-Standard-Configs einliest (`README.md` Z. 1–4, 32–35). Nicht an die CE gereicht — hier definiert.
- G1-Configs nutzen dagegen nur synthetische `<parameters>` (num_keys usw.), kein echtes Dataset.
- Struktur eines Dataset-XML (`url.test_data.xml`, 6er-Kanon `tab:datasets`):
```xml
<!-- url.test_data.xml:6-41 -->
<comdare_test_data id="url" source="LAW it-2004 (via CoCo-trie P04)">
  <metadata><name>it-2004 URLs (no_suffixes_small)</name>
    <license>research use …</license><size_bytes>479213</size_bytes>
    <source_url>https://law.di.unimi.it/webdata/it-2004/</source_url>
    <referenced_in_paper>P04 CoCo-trie (Boffa/Ferragina/Vinciguerra 2022)</referenced_in_paper></metadata>
  <key_value_signature><key_types>std::string</key_types><value_types>std::uint64_t</value_types></key_value_signature>
  <local_path>external/comdare-cache-engine/ext/traversal/P04-CoCo-trie/…/it-2004.urls_no_suffixes_small</local_path>
  <dataset_akte><checksum>0x888786d54c6fd026</checksum><line_count>5000</line_count>
    <preprocessing>coco-trie:no_suffixes_small</preprocessing></dataset_akte>
  <loader><dataset_source>string_corpus</dataset_source>
    <dataset_id>external/…/it-2004.urls_no_suffixes_small</dataset_id></loader>
  <expected_workload>YCSB_C</expected_workload>
</comdare_test_data>
```
Felder: `id/source`, `metadata` (name/license/size/source_url/referenced_in_paper), `key_value_signature`, `local_path`, `dataset_akte` (FNV-1a-64-`checksum`/`line_count`/`preprocessing` — via `compute_dataset_akte`, in CI durch `test_25_kanon_dataset_akten` reproduzierbarkeits-verifiziert), `loader` (`dataset_source` = Registry-loader_id, `dataset_id` = Datei-Pfad; #184-Muster) und `expected_workload`. Binär-Variante (`sosd_books_200M.test_data.xml`) trägt `<loader><dataset_source>sosd_uint64</dataset_source>…` + `<fetch_script>` + „honest-0"-Akten-Politik (keine erfundene Prüfsumme, Datei nicht lokal). Kanon = Thesis-Tabelle `tab:datasets` (6 + 2 Extras, `README.md` Z. 48–63).

---

## Frage 4 — Beziehung `experiment_config` (Diplomarbeit) ↔ `load_profiles`-XML (cache-engine-Katalog)

**Outer (Diplomarbeit) über Inner (cache-engine):** `experiment_config` definiert das **äußere Experiment** (welche Messreihe/Mode/SOTA-Profile/Pruefling, welche Workloads *namentlich*, Output-Pfade). `load_profiles/` ist der **innere, maßgebliche Workload-Katalog** — die tatsächlichen Achse-2-Werte mit voller op-mix-Charakteristik. Die Diplomarbeit **selektiert/skaliert**, die cache-engine **definiert/interpretiert**.

**Verdrahtung (verifiziert an der produktiven Harness `run_lazy_150.cpp`):**
```cpp
// external/…/tests/unit/thesis_tiere/run_lazy_150.cpp:189-206
if (char const* lpd = std::getenv("COMDARE_LOAD_PROFILE_DIR"); lpd && *lpd) {
  for (auto const& idp : wd::discover_load_profiles(lpd)) {          // Achse-2-Discovery
    if (auto lp = wd::parse_load_profile(idp.second)) {
      workload_registry[idp.first] = lp->config;                    // id → WorkloadConfig
      workload_values.push_back(idp.first);
    } }
  … "load_profiles (XML, Achse 2) entdeckt: N" …                    // 0 gültige → Abbruch (Achse 2 darf nicht still entfallen)
}
```
`discover_load_profiles(dir)` (in `load_profile_parser.hpp` Z. 120–133) enumeriert alle gültigen `*.xml`, sortiert nach `id`, und liefert `[(id, pfad)]` = die **Wertemenge der dynamischen Workload-Achse**. Der `CacheEngineBuilder`-Iterator hält sie in `workload_configs{}` (`cache_engine_builder_iterator.hpp` Z. 81–84): „Befüllt von run_lazy_150 via discover_load_profiles(load_profiles/). Die ids sind die Werte der dynamischen Workload-Achse."

**Bias-Bruch-Semantik:** Jedes Tier/jede Permutation wird unter **JEDEM** Lastprofil gemessen — kein Algorithmus nur unter seinem Heim-Workload (`load_profiles/SCHEMA.md` Z. 5–8).

**Skala vs. Charakteristik:** Charakteristik (`op_mix`/dist/neg%/scan) aus dem CE-`load_profiles`-XML; Skala (`records`/`num_operations`) aus der Diplomarbeit-Seite (G1 `<parameters>` / v32 `<workload record_count operation_count>` / Harness-Env). Dasselbe Profil läuft so test-klein und voll-skaliert mit identischer Charakteristik (`load_profile_parser.hpp` Z. 5–8, `SCHEMA.md` Z. 51–62).

**Namens-Mapping:** `config_*.xml` `<workload type="ycsb">A…F</workload>` bildet auf die Katalog-`id`s `ycsb_a…ycsb_f` ab (verifiziert: `ycsb_a.xml` → `id="ycsb_a"`). v32-`<workload kind="YCSB_C_ReadOnly">` referenziert dieselbe Katalogfamilie.

**Analoge Katalog-Beziehung für die anderen Achsen:** `config_a` verweist für die Struktur-Achsen explizit auf `permutation_axes.xml` (`<axes_source>`, Z. 42). Dieser CE-Katalog (`comdare_permutation_axes version="1"`) definiert **11 Achsen × Wertebereiche** (`page, node, traversal, value_handle, concurrency, allocator, prefetch, telemetry, isa, layout, reclamation`), über die im `full`-Mode das Kartesische Produkt gebildet wird. Die benannten SOTA-Punkte liegen als `algorithm_profiles/sota/*.profile.xml` (`comdare_algorithm_profile`, 33 Dateien) — jedes belegt alle 11 Achsen konkret (z. B. `art.profile.xml`: `page=DENSEBYTE_ART256, concurrency=OPTIMISTIC_LOCK_COUPLING, allocator=MIMALLOC, layout=CACHE_LINE_ALIGNED, …` + `<expected_workload>YCSB_C</expected_workload>`).

**Fazit:** Die `experiment_config`-XMLs (und der v32-Nachfolger) sind **dünne Selektor-/Orchestrator-Profile**, die drei maßgebliche cache-engine-Kataloge referenzieren: `load_profiles/*.xml` (Workload-Achse 2, laufzeit-interpretiert), `permutation_axes.xml` (11 Struktur-Achsen), `sota/*.profile.xml` (benannte Baseline-Punkte). Die einzige Kategorie, die die **Diplomarbeit selbst** vollständig definiert und *zusätzlich* hineinreicht, sind die **Datensätze** (`test_data_xml/*.test_data.xml`).

---

## Relevante Pfade (alle absolut)

- Diplomarbeit-Profile G1: `<Code>/experiment_config/{messreihen.xml, config_a_prt_art_vs_sota.xml, config_b_cache_engine_perms.xml, config_c_merge_alt_neu.xml}`
- Diplomarbeit-Profile G2 (Schema+Beispiel, keine Prod-Instanzen): `<Code>/test_data_xml/{messreihe_v32_schema.xsd, messreihe_v32_schema_example.xml}`; Validator `<Code>/02_messung_driver/messreihe_v32_validator.hpp`, Orchestrator `<Code>/02_messung_driver/v32_orchestrator.hpp`
- Dataset-Slot: `<Code>/test_data_xml/*.test_data.xml` + `<Code>/test_data_xml/README.md`
- CE-Workload-Katalog (Achse 2): `<Code>/external/comdare-cache-engine/libs/cache_engine/algorithm_profiles/load_profiles/` (22 XML + `SCHEMA.md`)
- CE-Achsen-Katalog: `…/algorithm_profiles/permutation_axes.xml` + `…/sota/*.profile.xml` (33) + `…/README.md`
- Parser/Discovery: `…/libs/cache_engine/builder/workload_driver/load_profile_parser.hpp` (`discover_load_profiles` Z. 120–133, `parse_load_profile` Z. 74–118)
- Produktive Verdrahtung: `…/tests/unit/thesis_tiere/run_lazy_150.cpp:189-206`; Iterator-Registry `…/builder/experiment_tree/cache_engine_builder_iterator.hpp:81-84`
- G1-Konsument: `<Code>/02_messung_driver/main.cpp` (via `xml_config_parser`)