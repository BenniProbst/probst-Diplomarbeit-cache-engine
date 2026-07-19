# STUFEN-DOKUMENT — Registry-ANGEBOT → Anwender-XML → Resolver (.pom-Modell) als Planungs-Stufe des Planer-Bauplans

> 2026-07-19. Stufen-Dokument zum Bauplan `docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md` (dort: Phase-0-Kritik-Blocker + Phasen 1–3 + Forks A–E). Dieses Dokument fuegt die vom User direktivierte **Resolver-Stufe** (Registry als parsbares Angebots-Manifest, Anwender-XML als deklarative Anzeige, Link zur Planungszeit) in den Bauplan ein. GATED auf User-Phasen-Freigabe; Forks in §5.

## 1. Direktive (Ledger §27) + Einordnung

**USER-DIREKTIVE (verbatim-treu):** Die Registries muessen so aufgebaut sein, dass der Experiment-Planer die waehlbaren Optionen je Achse aus dem ANGEBOT parsed als XML-Bibliothek, sodass diese ERST NACH REGISTRIERUNG in der XML des Anwenders erkannt und korrekt verlinkt werden koennen. Die Registry enthaelt ein Format, das die CacheEngine fuer das ANGEBOT des Compiles interpretieren kann; die Anwender-XML ZEIGT AN, welche Experimente, Achsen, Einstellungen, Flags, Unter-Achsen (VOLLER Support) und Ablaeufe+Ranges durchzufuehren sind. Modell: mini-Python-Interpreter auf nativer XML-Basis, viel eher aehnlich zu einer Java .pom (deklaratives Manifest + Dependency-Resolution gegen Repository). Zweck: zusaetzliche Planungs-Stufe, um den Planer endlich zu ueberarbeiten und zu bauen.

**Doktrin-Rahmen (bindend):**
- KEINE Parallelstruktur — andocken an `validate_profile.hpp` + `xml_config_parser.hpp` + die beiden bestehenden Registry-Generatoren; kein zweiter Validator/Parser daneben (`feedback_vor_aufgaben_erst_projektstruktur_analyse`).
- Resolver laeuft Planer-/Configure-Zeit (compile-time-Doktrin, kein Runtime-Switch im Hot-Path, KEIN Python im Buildchain).
- Nur benannte Patterns (GoF/MOF/PoEAA); musterlos verboten.
- 2 Registry-Bibliotheken je Engine: `cache_engine_axis_registry.xml` + `prt_art_axis_registry.xml` (`feedback_unified_experiment_xml_plus_system_registry_xml`); Registry-Pfade per CMake-Interface statisch (`feedback_ceb_config_cmake_interface_static_registry_paths_prt_module`).
- Organ-Achsen → `binary_id`; System-/Mess-Achsen NIE `binary_id` (`feedback_system_axes_measurement_own_abstract_root_blood`, Q2 Option C).
- Unregistriertes Element = harter, klassifizierter Validierungsfehler (Fehlerklassen-Doktrin, kein stilles Verhalten; `feedback_fehlerklassen_pflicht_alle_achsen_unterachsen_algorithmen`).
- Haupt-Achse CT-statisch, Unter-Achse runtime, stufen-relativ (`feedback_haupt_achse_static_unter_achse_runtime_chain_ct_wiring`).
- Golden-Neutralitaet ist je Schritt auszuweisen; alt-golden darf brechen, aber erst additiv + Aufraeumen nur mit GO.

**Einordnung:** Der Bauplan definiert Phase 1 (Planer-Kopf) mit dem Baustein „Interpreter". Dieses Dokument praezisiert: **der Interpreter-Baustein des Bauplans WIRD der Resolver** — die Pipeline Registry-Angebots-Parse → Anwender-Parse → Link → `LinkedExperimentPlan` an den Director. Der Phase-0-v32-Reconcile-Blocker des Bauplans (super `Code/02_messung_driver/v32_messreihe_antrieb.hpp`, `execute_messreihe`-Stub WIEDERVERWENDEN) bleibt davor bestehen. Die 2 ConcreteBuilder (CMakeGraph/CiYaml) konsumieren den GELINKTEN Plan. Details §4.

---

## 2. IST — Registry-Parsing/-Linking heute vs. volles ANGEBOT

### 2.A Heutiges Registry-Schema (beide Bibliotheken identisch, `schema="1"`)

**Wurzel:** `<comdare_axis_registry engine="cache_engine|prt_art" schema="1">`

| Element | Attribute | Bedeutung |
|---|---|---|
| `<axis>` | `id` (Achsen-Name), `slot` (T00.. / axis_NN), `category`, `genus`, `baustein_count` | eine Haupt-Achse |
| `<baustein>` | `name` (= `W::name()`, byte-genauer binary_id-Schluessel), `wrapper` (Kurz-Typ), `type` (FQ-C++-Typ, `::`-praefixiert), `header` (aus `COMDARE_DEFINE_ORGAN_LOCATION`, sonst `""`), `enabled` (immer `"true"`), `golden_wired` (`true|false`) | eine waehlbare Variante |

**ce-Registry** (`libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml`, 131 Z.): committeter Stand = **18 Achsen T00–T17, `category="composition"`**, inkl. `isa` als T11 — **STALE**: XML zuletzt bei Commit `5fe811db` (INC-2c, 18 Slots) regeneriert; der Generator ging danach durch `8a2e1c3e` (INC-2d: isa→System-Achse, 17 Slots, Slot-Nummern verschoben) und `aa25c9a4` (new-golden 2^17). `kCompositionAxisNames` (axis_path_serialization.hpp:34) ist heute `std::array<...,17>` OHNE isa. Der Byte-Diff-Roundtrip-Test `test_axis_registry_roundtrip` (tests/unit/CMakeLists.txt:3486-3497, contract-Label) muss gegen den aktuellen Generator ROT sein.

**prt-Registry** (`prt_art/algorithm_profiles/prt_art_axis_registry.xml`, 26 Z.): 5 Achsen — 4 `category="pruefling_slot"` (je 1 Baustein, golden_wired=false) + 1 `golden_merge_slot` (bare ce-`PatriciaPathCompression`, golden_wired=true). Kategorien/golden-Flag im Generator (`prt_art/registry_gen/main.cpp:174-181`) **hartkodiert je Aufruf** (`make_slot(..., false)` / `make_wrapper(..., true)`).

**Was das Schema NICHT hat:** keine Unter-Achsen, keine Flags, keine Ranges, keine `algo_version`, keine System-/Mess-Achsen (nur via nie-committetes `--with-extra-axes`), keine Abhaengigkeiten/Gatings, keine Ablaeufe.

### 2.B Heutige Link-Punkte (Registry ↔ Anwender-XML)

**Einziger Konsument der Registry-XML im gesamten Bestand** ist `read_axis_registry` (validate_profile.hpp:451-465) — liest NUR Wurzel-`engine`-Attribut + `axis@id` + `baustein@name`. `wrapper`/`type`/`header`/`slot`/`category`/`genus`/`baustein_count`/`enabled`/`golden_wired` werden von NIEMANDEM gelesen.

**Pfad 1 — ThesisProfile (`validate_profile`, validate_profile.hpp:133-345):** loest gegen die **CODE-Reflektion**, nicht gegen die XML: Host baut `build_all_axis_levels()` (registry_to_axis_levels.hpp:137) → `axis_registry_from_levels` (validate_profile.hpp:108) → prueft (1) `<axis ref>` gegen Registry-Keys ∪ `kCompositionAxisNames` (Z.162), (2) `<value>` gegen `name()`-Listen (Z.190-199), (3) `axis_sweep`/`sota_series`-Referenzen (Z.207-258), (4) fairness (Z.239), (5) datasets-Format (Z.262-297), (6) workload-ids (Z.328-342), (7) Mess-Kategorien gegen `kMeasurementAxisRegistry` (Z.303-321). Aufruf: profile_run_facade.cpp:417/430.

**Pfad 2 — ExperimentProfile (`validate_experiment_profile`, validate_profile.hpp:480-730):** liest die Registry-XMLs wirklich: (4) Existenz/Parsbarkeit/engine-Attribut-Abgleich/Doppel-ce (Z.585-657), (5) `<axes_default_lookup>` `allowed_variants` ⊆ ce-`baustein@name` je `axis@ref` (Z.659-685) — **NUR gegen die ce-Registry; die prt-Registry-Inhalte werden ausser dem engine-Attribut nirgends verwendet**. `system_axes` opt_level/simd werden gegen **Code** geprueft (`kAllOptLevelIds`/`kAllSimdIds`, Z.560-583), NICHT gegen ein Registry-Angebot. `op_types` gegen hartkodierte XSD-Spiegel-Tabelle (Z.538).

**Pfad-Injektion:** Fassade baut `engine_registry_paths` per Adapter-Typ/engine-id (profile_run_facade.cpp:451-461); der Super-Treiber backt die statischen Pfade per CMake-Define `COMDARE_CE_AXIS_REGISTRY_PATH`/`COMDARE_PRT_AXIS_REGISTRY_PATH` (Code/02_messung_driver/CMakeLists.txt:33-34; main.cpp:314-316, 655-663) — CMake-Interface-Doktrin erfuellt.

**NICHT geprueft/gelinkt:** ThesisProfile-Werte gegen die XML (nur gegen Code); prt-Bausteine; Unter-Achsen-Werte (cacheline/node_width/alloc_hw = reine WARNUNG, Z.146-160); Phasen→Registry-Baustein-Aufloesung (Phasen tragen bewusst keine Bausteine); keinerlei Nutzung von `type`/`header` fuer Codegen/Compile-Draht.

### 2.C GAP-Liste gegen die §27-Direktive (Angebot als parsbares XML-Bibliotheks-Manifest, .pom-Modell)

1. **Unter-Achsen fehlen KOMPLETT im Angebot:** cacheline (line_sizes/alignments/sw_hints), node_width, alloc_hw (numa/page), opt_level, simd existieren nur als Code-Konstanten (`kAllOptLevelIds`, `kAllSimdIds`) bzw. ThesisAxisSpec-Sonderfelder (xml_config_parser.hpp:100-115). Direktive verlangt VOLLEN Unter-Achsen-Support im Angebot (Haupt=CT-statisch, Unter=runtime, stufen-relativ).
2. **Flags je Variante fehlen:** kein `-DCOMDARE_AXIS_03A_ENABLE_K_ARY_K*`, kein vendor-HAVE, keine `-O<n>`/`-march`-Aufloesung im Angebot; die Flag-Wahrheit lebt in der opt-g-Facade (make_gpp_compile_fn) und CMake. Q2-Ruling (Flags→CompileFn, nie binary_id) braucht die Flag-Deklaration trotzdem im ANGEBOT.
3. **Ranges/Ablaeufe fehlen:** keine numerischen Ranges (N-Sweep, repetitions, thread_counts, prefetch_distances, Budgets), keine Ablauf-/Sequenz-Bausteine. Anwender-XML kann heute nur Whitespace-Token-Listen anzeigen.
4. **System-/Mess-Achsen-Angebot fehlt:** die 6 System-Achsen + 16 Mess-Kategorien sind Code-only (`build_system_axis_levels()`, `kMeasurementAxisRegistry`); `--with-extra-axes` emittierte sie, wird aber nicht committet/konsumiert. System/Mess NIE binary_id — brauchen aber eine eigene Angebots-Kategorie.
5. **`algo_version` fehlt im Angebot:** 209 Wrapper tragen `static constexpr algo_version = "v1"` (z.B. axis_q1_queuing_fifo.hpp:52), die Registry emittiert sie nicht — Voraussetzung fuer den inkrementellen Tier-Binary-Cache (feedback_incremental_tier_binary_caching) fehlt.
6. **Keine Registrierungs-Semantik:** Direktive „erst NACH Registrierung erkannt" — heute ist die Pruefung ein Teilmengen-Check (`allowed_variants`), keine Dependency-Resolution: die Anwender-XML kann keine prt-Bausteine referenzieren (prt-Registry ungenutzt), keine per-Phase-Achsen-Auswahl (axes_default_lookup ist global), keine Registry-Version pinnen, keine Fehlerklassen je Achse/Unter-Achse/Algo deklarieren.
7. **`enabled` ist vestigial** (Reflektion ueber Enabled* ⇒ immer true) — das Angebot kann „vorhanden aber nicht aktiviert" nicht ausdruecken (kein Opt-in-Katalog fuer per-K/vendor).

### 2.D Wo Code-Wahrheit an der Registry VORBEI laeuft (Single-Source-Befund)

1. **EnabledStrategies mp_lists = zweite (eigentlich ERSTE) Wahrheit:** der komplette Thesis-/Bau-Pfad konsumiert `Enabled*` direkt (registry_to_axis_levels.hpp:51-77, build_all_axis_levels:137); die XML ist nur ein generiertes Abbild, das exakt EIN Validator-Check liest. Beweis der Drift-Gefahr: die committete XML ist real STALE (18 Achsen inkl. isa=composition/T11 vs. 17 im Generator/`kCompositionAxisNames`).
2. **KaryPerKCatalog-Bypass** (source_catalog.hpp:513-540): explizite `mp_list<KArySearchAlgoK2/4/8/16>` „bypassen EnabledStrategies/mp_take_c" (Zitat Kopf-Doku) — baubare binary_ids (`k_ary_k*`), die weder in der Registry-XML noch in Enabled* stehen.
3. **golden_wired doppelt hartkodiert:** Generator-K-Werte (tools/axis_registry_gen/main.cpp:207-224: 4,1,1,1,4,5,1,4,…) muessen manuell deckungsgleich zu `golden_320_catalog = CatalogAxes<4,1,1,1,4,5,1,4,...>` (source_catalog.hpp:130) bleiben; prt-seitig ist golden_wired je make_slot-Aufruf literal.
4. **Weitere Neben-Wahrheiten im Validator selbst:** `kValidOpTypes` (validate_profile.hpp:538, Spiegel des super-XSD), `kKnownDatasetLoaderIds` (Z.103, vs. laufzeit-offene DatasetLoaderRegistry), Sonderzweig-Unter-Achsen als Warn-Skip (Z.146-160). Test-Fixture-Kopie der prt-Registry (tests/unit/thesis_tiere/, CMakeLists.txt:2606) statt der realen Datei = Fixture-Drift-Kanal.

**Andock-Konsequenz (keine Parallelstruktur):** Erweiterung = Schema-Bump der beiden Generatoren (Unter-Achsen/Flags/algo_version/System-Kategorie emittieren) + `read_axis_registry`/`RegistryContents` in validate_profile.hpp erweitern + ExperimentProfile-Structs in xml_config_parser.hpp additiv; Resolver zur Planer-/Configure-Zeit; Phase-0-Blocker bleibt der v32-Reconcile (super `02_messung_driver/v32_messreihe_antrieb.hpp` execute_messreihe-Stub wiederverwenden, Bauplan 20260719). Golden-Neutralitaet: alles Gelistete ist Validator-/Manifest-Schicht — binary_id-Pfad (`serialize_composition_path`/kCompositionAxisNames) unberuehrt; einzige offene Golden-Beruehrung ist die faellige Regeneration der stalen ce-Registry-XML (byte-diff-Gate existiert bereits).

**Schluesseldateien IST:** `Code/external/comdare-cache-engine/libs/cache_engine/profile_facade/validate_profile.hpp` (NICHT builder/experiment_tree/), `.../profile_facade/profile_run_facade.cpp`, `.../builder/experiment_tree/registry_to_axis_levels.hpp`, `.../builder/experiment_tree/axis_path_serialization.hpp`, `.../profile_facade/source_catalog.hpp`, `.../tools/axis_registry_gen/main.cpp`, `Code/external/comdare-prt-art/prt_art/registry_gen/main.cpp`, `Code/02_messung_driver/main.cpp` + `CMakeLists.txt`, `Code/test_data_xml/experiment_golden.xml`.

---

## 3. DESIGN — Resolver-Stufe (.pom-Modell): Angebots-Registry v2 → Anwender-XML → Link → `LinkedExperimentPlan`

> Basis: IST (§2) + Bauplan (Phase-0-Blocker: super-Reconcile `Code/02_messung_driver/v32_messreihe_antrieb.hpp` — `execute_messreihe`-Stub WIEDERVERWENDEN, keinen dritten Enumerations-Walk daneben). Doktrin: KEINE Parallelstruktur — alle Erweiterungen docken an `validate_profile.hpp` + `xml_config_parser.hpp` + die beiden bestehenden Registry-Generatoren an. Kein Python, kein Runtime-Switch im Hot-Path, nur benannte Patterns.

### 3.A Angebots-Schema v2 — je Registry-Bibliothek

#### A.1 Prinzip

Die Registry wird vom „Namens-Inventar" (`schema="1"`: axis→baustein-Namen) zum **vollstaendigen ANGEBOTS-MANIFEST** (`schema="2"`): alles, was die CacheEngine compilieren/permutieren KANN, steht deklarativ drin — Varianten mit `algo_version`, Flags je Compiler-Dialekt, Unter-Achsen mit eigenen Wertemengen/Range-Faehigkeit, Gattungs-Zugehoerigkeit, und ein eigener System-/Mess-Achsen-Katalog. Die Anwender-XML darf ausschliesslich referenzieren, was hier registriert ist (.pom: Manifest + Repository; unaufgeloeste Referenz = harter Fehler, §3.C).

**Schema-Bump additiv:** `schema="2"` behaelt alle v1-Attribute byte-kompatibel (`id/slot/category/genus/baustein_count`, `name/wrapper/type/header/enabled/golden_wired`) und fuegt NUR Attribute/Kind-Elemente hinzu. `read_axis_registry` (validate_profile.hpp:451) liest v1 UND v2 (fehlende neue Felder → leer), kein zweiter Parser.

#### A.2 XML-Elemente v2 (beide Bibliotheken, identisches Schema)

```xml
<comdare_axis_registry engine="cache_engine" schema="2" generator="axis_registry_gen">

  <!-- ═══ KATEGORIE 1: Organ-Achsen (composition) — bilden binary_id ═══ -->
  <axis id="search_algo" slot="T00" category="composition" genus="SearchAlgorithm"
        binary_id="organ" baustein_count="4">
    <baustein name="k_ary" wrapper="KArySearchAlgo"
              type="::comdare::cache_engine::lookup::KArySearchAlgo"
              header="axes/lookup/axis_03a_search_algo_k_ary.hpp"
              enabled="true" golden_wired="true"
              algo_version="v1">                          <!-- NEU: aus W::algo_version reflektiert -->
      <flags dialect="gpp">                               <!-- NEU: Flag-DEKLARATION (→ CompileFn, NIE binary_id) -->
        <define name="COMDARE_AXIS_03A_ENABLE_K_ARY"/>
      </flags>
      <sub_axis id="k" stage="runtime" value_type="uint"> <!-- NEU: Unter-Achse mit eigener Wertemenge -->
        <options>2 4 8 16</options>                       <!-- diskretes Werteset (per-K-Katalog!) -->
      </sub_axis>
    </baustein>
    ...
  </axis>

  <!-- Unter-Achsen auf ACHSEN-Ebene (gelten fuer alle Bausteine der Achse): -->
  <axis id="node_type" slot="T04" ... >
    <sub_axis id="node_width" stage="runtime" value_type="uint">
      <options>4 16 48 256</options>
    </sub_axis>
    <baustein .../>...
  </axis>
  <axis id="memory_layout" slot="T05" ...>
    <sub_axis id="cacheline" stage="runtime" value_type="composite">
      <sub_axis id="line_sizes"  value_type="uint"><options>64 128</options></sub_axis>
      <sub_axis id="alignments"  value_type="uint"><options>8 16 32 64</options></sub_axis>
      <sub_axis id="sw_hints"    value_type="token"><options>none prefetch_t0 prefetch_nta</options></sub_axis>
    </sub_axis>
    ...
  </axis>
  <axis id="allocator" slot="T06" ...>
    <sub_axis id="alloc_hw" stage="runtime" value_type="composite">
      <sub_axis id="numa" value_type="token"><options>local interleave</options></sub_axis>
      <sub_axis id="page" value_type="token"><options>base_4k huge_2m</options></sub_axis>
    </sub_axis>
    ...
  </axis>
  <axis id="prefetch" slot="T07" ...>
    <sub_axis id="prefetch_distance" stage="runtime" value_type="uint">
      <range min="1" max="64" scale="pow2"/>              <!-- NEU: RANGE-Faehigkeit statt Aufzaehlung -->
    </sub_axis>
    ...
  </axis>

  <!-- ═══ KATEGORIE 2: System-Achsen (system_config) — NIE binary_id ═══ -->
  <axis id="compiler" slot="S01" category="system_config" genus="" binary_id="never" baustein_count="1">
    <baustein name="gpp" wrapper="CompilerSystemAxis" type="..." algo_version="v1" enabled="true">
      <!-- Compiler-Achse TRAEGT die dynamischen Unter-Achsen (project_compiler_systemachse_...) -->
      <sub_axis id="opt_level" stage="runtime" value_type="token">
        <options>O0 O1 O2 O3 Ofast</options>
        <flag_map option="O0" dialect="gpp" flag="-O0"/> ... <flag_map option="Ofast" dialect="gpp" flag="-Ofast"/>
      </sub_axis>
      <sub_axis id="extra_flags" stage="runtime" value_type="token">
        <options>none march_native lto</options>          <!-- NUR registrierte Tokens, kein Freitext -->
        <flag_map option="lto" dialect="gpp" flag="-flto"/>
      </sub_axis>
    </baustein>
  </axis>
  <axis id="extension_hardware" slot="S02" category="system_config" binary_id="never" ...>
    <baustein name="simd_lane" ...>
      <sub_axis id="simd" stage="runtime" value_type="token">
        <options>no_extension avx2 avx512</options>
        <flag_map option="avx2" dialect="gpp" flag="-mavx2"/>
        <flag_map option="avx512" dialect="gpp" flag="-mavx512f"/>
      </sub_axis>
    </baustein>
  </axis>
  <axis id="target_isa"  slot="S03" category="system_config" binary_id="never" .../>  <!-- x86_64/aarch64-Gate -->
  <axis id="scheduling"  slot="S04" category="system_config" binary_id="never" .../>
  <axis id="load"        slot="S05" category="system_config" binary_id="never" .../>

  <!-- ═══ KATEGORIE 3: Mess-Achsen (system_measurement, „Blut") — NIE binary_id ═══ -->
  <axis id="measurement" slot="M00" category="system_measurement" binary_id="never">
    <baustein name="cache_behavior" .../> <baustein name="branch_behavior" .../>
    <!-- alle 16 Kategorien aus kMeasurementAxisRegistry, reflektiert -->
  </axis>
</comdare_axis_registry>
```

**prt-Registry analog** (`engine="prt_art"`, schema="2"): die 4 `pruefling_slot`- + 1 `golden_merge_slot`-Bausteine bekommen dieselben neuen Attribute (`algo_version` aus den Slot-Wrappern reflektiert, Flags, ggf. Unter-Achsen). Die Kategorien `pruefling_slot`/`golden_merge_slot` bleiben — sie werden im Resolver zur **Sichtbarkeitsregel** (§3.C.3): prt-Bausteine sind nur in Phasen mit `merge=Stufe2_PrueflingReplace|Stufe3_FullJoin` referenzierbar.

Neue Attribute zusammengefasst: `binary_id="organ|never"` (explizite Durchsetzungs-Grundlage der Organ→binary_id / System-nie-binary_id-Doktrin), `algo_version` je Baustein (Voraussetzung inkrementeller Tier-Binary-Cache), `<flags dialect=...>` (Deklaration; Aufloesung bleibt `make_gpp_compile_fn` — Q2-Ruling: Flags→CompileFn, NIE binary_id), `<sub_axis stage="runtime">` mit `<options>` XOR `<range min max scale>`, `<flag_map>` (Option→Flag je Dialekt — loest die heutige Code-only-Wahrheit `-O<n>`/`-march` ins Angebot).

> **[KORREKTUR K2, adversariale Live-Code-Pruefung 2026-07-19 — `stage="runtime"` pauschal ist FALSCH gegen den Live-Code]:** das Beispiel `<sub_axis id="k" stage="runtime">` widerspricht dem Bestand: die per-K-Varianten sind EIGENE CT-Typen `KArySearchAlgoK2/4/8/16` (source_catalog.hpp:513-540) mit EIGENEN binary_ids (`search_algo=k_ary_k*`, „disjunkter binary_id-Raum", per-DLL-Emission + `-DCOMDARE_AXIS_03A_ENABLE_K_ARY_K{2,4,8,16}`) — ein Laufzeit-k waere eine CT→RT-Degradierung (verboten: `feedback_compile_time_only_no_runtime`, `feedback_metaprogrammierung_compile_time_zwingend_durchsetzen`). Ebenso ist `cacheline.line_size` im Live-Baum ein STATISCHES Level (`profile_to_tree.hpp:56`: `AxisLevel{..., true, ...}` = `is_static=true`, experiment_tree.hpp:190-196). KORREKTUR: das `stage`-Attribut wird zu `materialization="ct_variant|runtime_param"` (bzw. `stage="compile|runtime"`) und wird per Generator AUS DEM CODE REFLEKTIERT, nicht pauschal gesetzt: `k`=ct_variant (Expansion → eigene VariantDescriptors/binary_ids in `organ_selection`), `line_sizes`/`alignments`=ct_variant (Define-/alignas-wirksam in der Folgestufe), `prefetch_distance`/`numa`/`page` etc. je nach realem Traeger. Die Doktrin „Haupt=CT, Unter=runtime" ist STUFEN-RELATIV zu lesen (Planer-dynamisch → Folgestufe-CT-Draht) — genau das muss das Manifest je Unter-Achse ausweisen, sonst degradiert der Resolver CT-Unter-Achsen zu Laufzeit-Parametern.

#### A.3 SINGLE-SOURCE-Entscheid (Fork R1, mit Empfehlung)

**EMPFEHLUNG: Option 1 — Code=Wahrheit, Registry GENERIERT (axis_registry_gen/registry_gen ausbauen).**

| | Option 1: Code=Wahrheit (Generator ausbauen) | Option 2: Registry=Hand-Wahrheit + CI-Diff-Guard |
|---|---|---|
| Wahrheitsquelle | `Enabled*`-mp_lists + Wrapper-`static constexpr` (`name()`, `algo_version`, Location, Flag-Makros) | die XML selbst; `EnabledStrategies` muesste ihr folgen |
| Drift-Schutz | bestehender Byte-Diff `test_axis_registry_roundtrip` (contract-Label) — Gate EXISTIERT | neuer Guard noetig; Richtung XML→Code ist bei CT-mp_lists ohne Codegen nicht durchsetzbar |
| Beleg | Generator-Kopfdoku: „Reflektion ueber Enabled* ist Pflicht (Round-Trip-Garantie)" | die committete XML ist REAL stale (18 vs 17 Achsen) — Hand-/Abbild-Pflege driftet nachweislich |
| Doktrin | compile-time-Doktrin: Typen sind CT; XML kann C++-Typen nicht erzeugen, nur abbilden | implizierte XML→C++-Codegen-Stufe = neue Parallelstruktur |

Option 2 wuerde die Wahrheit in ein Artefakt legen, das den Code nicht erzwingen kann — genau der Drift, der heute schon vorliegt. **Aber Teil-Korrektur an Option 1 (verpflichtend):** die heute im Generator HARTKODIERTEN Nebenwahrheiten wandern in die Reflektion: (a) golden-K-Werte `make_axis<...,4>(...)` (tools/axis_registry_gen/main.cpp:207-224) werden aus den `golden_320_catalog`-`CatalogAxes<...>`-Konstanten (source_catalog.hpp:130) via geteiltem `constexpr`-Array bezogen (Doppel-Pflege §2.D.3 stirbt); (b) prt-`make_slot(..., false)`-Literale (prt_art/registry_gen/main.cpp:174-181) analog aus einer `constexpr`-Slot-Tabelle; (c) `--with-extra-axes` wird vom nie-committeten Nebenpfad zum PFLICHT-Emit der Kategorien 2+3 (System/Mess offiziell im committeten Manifest); (d) `algo_version` via `HasAlgoVersion<W>`-Concept reflektiert (209 Wrapper tragen es bereits); (e) per-K: der `KaryPerKCatalog`-Bypass (source_catalog.hpp:513-540) wird als `<sub_axis id="k">` reflektiert — Bypass-mp_list bekommt eine statische Assertion gegen das Options-Set (§3.E.2).

### 3.B Anwender-XML-Schema — die ANZEIGE (.pom-Semantik)

#### B.1 Prinzip

Die Anwender-XML (`<comdare_experiment>`) ist rein **deklarativ** — sie ZEIGT AN, welche Experimente/Achsen/Einstellungen/Flags/Unter-Achsen/Ablaeufe+Ranges durchzufuehren sind, und darf NUR Registriertes referenzieren (Koordinaten-Referenz wie Maven `groupId:artifactId:version`). Erweiterung strikt additiv an `ExperimentProfile` (xml_config_parser.hpp:300) + `parse_experiment_profile` (:337) — kein zweiter Parser.

**Zwei-Schichten-.pom-Semantik** (Andockpunkt statt Neubau): das bestehende `<axes_default_lookup>` (globales LIMIT, xml_config_parser.hpp:307-309) ist das Analogon zu Maven-`<dependencyManagement>` (Default/Deckelung); NEU ist die per-Phase-`<axes>`-Selektion = `<dependencies>` (konkrete Verwendung). Ungenannt in der Phase → Default-Schicht → volle Registry-Liste (heutiges Verhalten, rueckwaertskompatibel).

#### B.2 Neue Elemente (additiv)

```xml
<comdare_experiment version="..." id="...">
  <metadata><name>...</name><mode>defined|full|full_sampled</mode></metadata>

  <!-- NEU: Registry-Pin (.pom <dependencyManagement>-Kopf). Pflicht ab v2-Nutzung. -->
  <uses_registries>
    <registry engine="ee_ce"  schema="2"/>
    <registry engine="ee_prt" schema="2"/>
  </uses_registries>

  <execution_engines>...</execution_engines>   <!-- unveraendert: GENAU 2, ee_ce + ee_prt -->
  <lebewesen>...</lebewesen>                   <!-- unveraendert -->

  <phases>                                     <!-- ABLAUF = geordnete Phasen + MergeStrategy (unveraendert) -->
    <phase name="stufe3" merge="Stufe3_FullJoin" engines="ee_ce ee_prt" pruefling="prt_art_bplus">
      <!-- NEU: per-Phase-Achsen-Selektion mit Koordinaten-Referenzen -->
      <axes>
        <axis ref="ee_ce:search_algo">
          <variant ref="k_ary" algo_version="v1">          <!-- optionaler Versions-Pin (Reproduzierbarkeit) -->
            <sub_axis ref="k"><values>2 8 16</values></sub_axis>
          </variant>
          <variant ref="eytzinger"/>
        </axis>
        <axis ref="ee_ce:prefetch">
          <variant ref="software_prefetch">
            <sub_axis ref="prefetch_distance">
              <range from="1" to="32" scale="pow2"/>       <!-- RANGE-Sweep, nur wenn Angebot range-faehig -->
            </sub_axis>
          </variant>
        </axis>
        <axis ref="ee_prt:path_compression">               <!-- prt-Baustein ENDLICH referenzierbar -->
          <variant ref="path_compression_patricia"/>
        </axis>
      </axes>
      <system_axes>                                        <!-- bestehende Struktur, Werte = Registry-Optionen -->
        <compiler><opt_level><option value="O2"/><option value="O3"/></opt_level>
                  <extra_flags><option value="lto"/></extra_flags></compiler>
        <extension_hardware><simd><option value="no_extension"/><option value="avx2"/></simd></extension_hardware>
      </system_axes>
    </phase>
  </phases>

  <axes_default_lookup enabled="true">...</axes_default_lookup>  <!-- bleibt: Default-/Limit-Schicht -->

  <!-- NEU: Ablauf-Ranges (Workload-Dimensionen des Sweeps; keine Achsen) -->
  <sweeps>
    <sweep id="n_sweep" target="dataset_n"><range from="1024" to="131072" scale="pow2"/></sweep>
    <sweep id="reps"    target="repetitions"><values>5</values></sweep>
    <sweep id="threads" target="thread_count"><values>1</values></sweep>  <!-- Mess=1-Thread-Doktrin -->
  </sweeps>

  <workloads>...</workloads> <datasets>...</datasets>
  <measurement_categories><category name="cache_behavior"/>...</measurement_categories> <!-- jetzt gegen Kat.3-Angebot -->
  <op_types>OP-1 OP-3</op_types>
  <output>...</output>
</comdare_experiment>
```

Regeln (.pom-treu): (1) jede `ref` = Koordinate `engine-id:axis-id` / `variant`-`ref` = `baustein@name`, byte-genau; (2) Freitext-Flags VERBOTEN — nur `<flags>`/`flag_map`-registrierte Tokens waehlbar (auch das Opt-in von `enabled="false"`-Katalog-Eintraegen laeuft ueber Referenz, nie ueber eigene Flag-Strings); (3) `<range>` nur wo das Angebot `<range>`-Faehigkeit deklariert, `<values>` ⊆ `<options>`; (4) `algo_version`-Pin optional — gesetzt ⇒ muss exakt matchen (Repro-Laeufe), ungesetzt ⇒ aktuelles Angebot; (5) Ablauf = Dokumentreihenfolge der `<phases>` (bestehende MergeStrategy-Ordnung Stufe1→2→3), Sweeps sind orthogonale Workload-Dimensionen, KEINE Achsen.

> **[KORREKTUR K5, adversariale Pruefung 2026-07-19 — Luecke gegen §27 „Unter-Achsen VOLLER Support"]:** das B.2-Beispiel selektiert `<sub_axis>` NUR unter `<variant>`; das Angebot §3.A.2 deklariert Unter-Achsen aber auch auf ACHSEN-Ebene (node_width/cacheline/alloc_hw gelten fuer alle Bausteine der Achse). Regel (6) ergaenzt: `<sub_axis ref>` ist auch DIREKT unter `<axis ref>` zulaessig und gilt dann fuer alle in der Phase gewaehlten Varianten dieser Achse (Aufloesung gegen das Achsen-Ebenen-Angebot; Variant-Ebene ueberschreibt Achsen-Ebene bei gleichem `ref` — Maven-analog dependencyManagement→dependency-Naehe). Ohne diese Regel waere der §27-VOLLE Unter-Achsen-Support fuer die drei heutigen Sonderzweig-Unter-Achsen (validate_profile.hpp:146-160) NICHT anzeigbar.

Parser-Andockung: neue Structs `ExperimentAxisSelection { ref, variants: {ref, algo_version, sub_axis_settings: {ref, values|range} } }`, `ExperimentSweep`, `ExperimentRegistryPin` additiv in xml_config_parser.hpp; `ExperimentPhase` erhaelt `std::vector<ExperimentAxisSelection> axes;` — Parser bleibt cache_engine-frei (Rohstrings; Aufloesung = ce-Schicht, exakt wie heute bei opt/simd).

### 3.C Resolve/Link-Phase im Planer — benannte Patterns

#### C.1 Pipeline (Configure-/Planer-Zeit, kein Runtime)

```
Anwender-XML ──[1 INTERPRETER]──► ExperimentProfile (erweitert)
2 Registry-XMLs ──[2 REPOSITORY-Aufbau]──► AxisOfferRepository je Engine (Eintraege = FLYWEIGHTS)
beide ──[3 LINK = Symbol-Resolution]──► LinkedExperimentPlan   ODER   klassifizierte harte Fehler
LinkedExperimentPlan ──► [4] ExperimentPlanDirector::construct(IPlanBuilder&)  (Bauplan Phase 1)
                          bzw. Phase-0: reconciled execute_messreihe (v32_messreihe_antrieb.hpp)
```

#### C.2 Pattern-Zuordnung (musterlos verboten; jedes benannt + begruendet)

| Baustein | Benanntes Pattern | Begruendung |
|---|---|---|
| Anwender-XML → `ExperimentProfile` | **Interpreter** (GoF) | bereits im Bauplan als Interpreter-Kern festgelegt (`parse_experiment_profile` + `project_experiment_to_sota_passes`); v2 erweitert nur die Grammatik (Terminale: Koordinaten-Refs, `<range>`, `<values>`) — dieselbe Interpreter-Instanz, kein zweiter |
| Registry-Bibliothek als Katalog | **Repository** (Fowler, PoEAA — benanntes Lehrbuch-Pattern) | ein Repository vermittelt zwischen Persistenz (Registry-XML) und Domaenen-Objekten mit **kollektionsartiger, abfragbarer** Schnittstelle: `find(engine, axis_id, variant_name) → VariantDescriptor const*`, `offers_range(axis, sub_axis)`, `variants_of(axis)`. Genau das braucht der Link-Schritt: keyed Lookup + Mengen-Queries. Eine (Abstract-)Factory waere FALSCH benannt: der Katalog ERZEUGT zur Resolve-Zeit keine Engine-Objekte (die Typen entstehen CT in der Folgestufe, §3.D) — er liefert unveraenderliche Beschreibungen |
| Katalog-Eintraege | **Flyweight** (GoF); das Repository spielt zugleich die **FlyweightFactory**-Rolle | intrinsischer Zustand = `name/type/header/flags/algo_version/sub_axis-Angebot` (unveraenderlich, geteilt); extrinsischer Zustand = per-Phase-Auswahl/Range-Expansion (liegt im Plan, NICHT im Descriptor). Jede Koordinate existiert genau EINMAL im Speicher; alle `PhaseStep`s halten `VariantDescriptor const*` — deterministische Identitaet (Pointer-Gleichheit = Koordinaten-Gleichheit), keine Kopien |
| Link-Schritt | **Symbol-Resolution nach Dock-Loader-Blaupause** (Spiegel `anatomy_module_loader.cpp:114-145`) | exakt die Analogie der Direktive: der Loader resolved 4 Pflichtsymbole + Magic/Major-Gate, jedes fehlende Symbol = harter Abbruch. Der Resolver behandelt jede XML-Referenz als Symbol gegen die Repository-„Symboltabelle": unaufloesbar = harter, klassifizierter Fehler (wie fehlendes dlopen-Symbol); der `<uses_registries schema>`-Pin = das Major-Gate (`host_compatible_with`-Analog: Profil-Schema ≤ Registry-Schema) |
| Reduktion/Filter der aufgeloesten Kandidaten | **Chain of Responsibility** (GoF) | die vorhandene, unverdrahtete `run_selection_filter_chain`/`ResumeFilter` (selection_filter_chain.hpp:76-101) wird im Resolver eingehaengt (leere Kette = Identitaet) — Bauplan-konform, Kritik-Befund 4 beachtet: der Einhaengepunkt ist NEU zu deklarieren, keine bestehende Naht |
| Plan-Konsum | **Director + Builder + Template-Method** (GoF) | unveraendert Bauplan Phase 1 — der Resolver ist deren INPUT-Stufe, kein Ersatz |

#### C.3 Link-Regeln + Fehlerklassen (Fehlerklassen-Doktrin: je Achse→Unter-Achse→Algo, kein stilles Verhalten)

Klasse **E-RES-V (Validierung — harter Abbruch zur Resolve-Zeit, deterministisch):**

| Code | Bedingung (Symbol-Analogie) |
|---|---|
| V-UNREG-AXIS / V-UNREG-VARIANT / V-UNREG-SUBAXIS / V-UNREG-FLAG | `ref` ohne Repository-Treffer (= fehlendes dlsym-Symbol) |
| V-SCHEMA-PIN | `<uses_registries schema>` > Registry-`schema` (= Major-Gate-Fail) |
| V-VERSION-PIN | `algo_version`-Pin ≠ Angebots-`algo_version` |
| V-RANGE | `<range>` auf nicht-range-faehiger Unter-Achse; `<values>` ⊄ `<options>`; Range ausserhalb min/max |
| V-CATEGORY | Kategorie-Verletzung: `system_config`/`system_measurement`-Ref in Organ-Position (binary_id-Schutz), `pruefling_slot`-Ref in Phase mit `merge=Stufe1_CeOnly`, Mess-Kategorie ausserhalb Kat.-3-Angebot |
| V-DISABLED | Referenz auf `enabled="false"` ohne deklariertes Opt-in |

Klasse **E-RES-I (Infrastruktur — harter Abbruch, andere Behandlung/Meldung):** Registry-Datei fehlt/unparsbar/falsches `engine`-Attribut (heutige Checks (4), validate_profile.hpp:585-657, bleiben und werden dieser Klasse zugeordnet); CMake-Define `COMDARE_*_AXIS_REGISTRY_PATH` fehlt.

Klasse **E-RES-C (Compiler/Hardware — NICHT zur Resolve-Zeit abbrechen):** dialekt-unbekanntes `flag_map`, zur Laufzeit fehlende HW (avx512 auf AMD-ohne), Compile-Fehler eines Perms → gemaess `feedback_measurement_failure_visibility`: CSV-Zelle `"failed"` + `<binary_id>.error.log`, Harness misst weiter. Der Resolver ANNOTIERT nur (z.B. `requires_hw="avx512"` am PhaseStep), entscheidet nicht.

> **[KORREKTUR K3, adversariale Live-Code-Pruefung 2026-07-19 — E-RES-\* MUSS an das BESTEHENDE Fehlerklassen-Framework andocken, sonst Parallel-Taxonomie]:** das Fehlerklassifizierungs-Framework existiert bereits: `libs/cache_engine/include/cache_engine/measurement/axis_error.hpp` (INC-29.0, fuer exakt die Fehlerklassen-Direktive gebaut) mit den 2 disjunkten CT-Taxonomien **D1 `CompilerCompilerErrorClass`** {`KonfigXmlParse` („Experiment-/Registry-XML ungueltig oder unparsbar" — Enum-Kommentar woertlich), `ToolchainFehlt`, `HardwareErweiterungFehlt`, `CompileKombination`} + **D2 `SampleStatus`** {Ok, NotApplicable, SourceUnavailable, Failed} inkl. stabiler Etiketten (`error_class_label`/`sample_status_token`) und Count-Drift-Guards. Dieses Dokument erwaehnte axis_error.hpp bisher NICHT — ein frei stehendes E-RES-\*-System waere die dritte Taxonomie (Verstoss `feedback_vor_aufgaben_erst_projektstruktur_analyse`). BINDENDE Zuordnung: **E-RES-V und E-RES-I ⊂ D1 `KonfigXmlParse`** (die V-\*/I-Codes werden Sub-Codes/Detail-Etiketten UNTER dem bestehenden Etikett `konfig_xml_parse`, additiv; neue D1-Klassen nur additiv mit Count-Bump); **E-RES-C = D1 `HardwareErweiterungFehlt`/`CompileKombination`** (Planer-/Compile-Zeit, Log + weitermessen) **+ D2 `SampleStatus::Failed`** (Harness, CSV-Zelle). I4 implementiert dann KEINE neue Taxonomie, sondern verdrahtet die bestehende (deren eigener Plan: INC-29.1/29.2).

#### C.4 Ausgabe: `LinkedExperimentPlan`

```cpp
struct ResolvedSubAxisSetting { SubAxisDescriptor const* offer; std::vector<std::string> expanded_values; };
struct ResolvedVariantSel     { VariantDescriptor const* fly;   std::vector<ResolvedSubAxisSetting> subs; };
struct ResolvedPhaseStep {
    std::string name; MergeStrategy merge; std::vector<EngineRef> engines; std::string pruefling;
    std::vector<ResolvedVariantSel> organ_selection;      // binary_id-bildend (nur category=composition/…slot)
    SystemMatrix                    system;               // opt×simd×isa×…-Permutation (NIE binary_id)
    std::vector<FlagSet>            per_perm_flags;       // → make_gpp_compile_fn (Q2: CompileFn, nie binary_id)
};
struct LinkedExperimentPlan { RegistryPins pins; std::vector<ResolvedPhaseStep> steps; Sweeps sweeps; /*…*/ };
```

Alle `*Descriptor const*` zeigen in die Flyweight-Arena des Repositories (stabile Lebensdauer ueber den Planer-Lauf). Der Plan ist der Vertrags-Input fuer `ExperimentPlanDirector::construct(IPlanBuilder&)` (CMakeGraphBuilder/CiYamlBuilder) — und in Phase 0 die Fuellung des `execute_messreihe`-Stubs (v32_messreihe_antrieb.hpp:259; dessen `PhaseCompositions<MergeStrategy>`-CT-Dispatch konsumiert `steps[i].merge` — Reconcile statt drittem Walk).

> **[KORREKTUR K4, adversariale Live-Code-Pruefung 2026-07-19 — „Stub" ist FALSCH; nichts ueberschreiben]:** `execute_messreihe` in `Code/02_messung_driver/v32_messreihe_antrieb.hpp:259` ist KEIN Stub, sondern die VOLL implementierte INC-G+H-Kette (parse → `validate_experiment_profile` → `run_experiment_profile` → CSV/TikZ-Export), lediglich INERT (nur unter `COMDARE_V32_DRIVER_ENABLE`+`COMDARE_MEASUREMENT_ON` kompiliert; Opt-in-Aufruf main.cpp:339). Der return-0-Stub ist die ANDERE Funktion gleichen Namens in `v32_orchestrator.hpp:92` („V32.GG.1 Skelett-Kompatibilitaet"). „Fuellung" heisst hier also NICHT Neuschreiben, sondern: die BESTEHENDE Implementierung wiederverwenden und ihren INPUT von rohem `ExperimentProfile` auf den `LinkedExperimentPlan` umstellen — wer den vermeintlichen „Stub" neu implementiert, baut exakt den dritten Enumerations-Walk, den Phase 0 verbietet.

**Verortung im Code (kein Parallel-Validator):** der Resolver ist die AUSBAUSTUFE von `validate_experiment_profile` (validate_profile.hpp:480) — Signatur additiv erweitert um Rueckgabe `std::optional<LinkedExperimentPlan>` neben `ExperimentValidationResult` (bzw. neues `resolve_experiment_profile`, das `validate_experiment_profile` als ersten Schritt AUFRUFT und im selben Header lebt). `read_axis_registry`/`RegistryContents` werden v2-faehig erweitert (§3.C.2-Repository baut auf `RegistryContents` auf), Aufrufkette bleibt `profile_run_facade.cpp:417/430` + super `main.cpp:655-663` mit den statischen CMake-Pfaden.

### 3.D Verhaeltnis zu CT — Resolver=Configure-Zeit, stufen-relative Einfrierung

Doktrin `feedback_haupt_achse_static_unter_achse_runtime_chain_ct_wiring`: „dynamisch-Vorstufe = CT-Draht der Folgestufe". Der Resolver laeuft **strikt Planer-/Configure-Zeit** (2-Pass `experiment_plan.cmake`-Blaupause des Bauplans, `-DCOMDARE_EXPERIMENT_XML=`; kein Runtime-Switch, kein Python, keine vtable im Mess-Hot-Path):

| Stufe | dort DYNAMISCH (enumeriert/interpretiert) | friert in der FOLGESTUFE als CT ein |
|---|---|---|
| Planer (Resolver) | Registry-Angebot, Anwender-Selektion, Ranges, System-Matrix | Organ-Auswahl → Codegen/`CompileFn`-Fanout: je Perm EIN monomorpher Typsatz einkompiliert (kein `std::variant`, `feedback_no_std_variant_static_axes_bloat`); Flags → `make_gpp_compile_fn`; System-Achsen → `build_version`-Suffix (`+cxx=+opt=+ext=`) |
| CEB | die vom Planer je Perm gereichten Werte (`CebSystemAxisDrive`-Buendel, Bauplan Phase 2) | Haupt-Achsen des Tiers = CT-statisch (CRTP+Concept, direkt einkompiliert, `binary_id`) |
| Tier | Unter-Achsen-WERTE (k, prefetch_distance, cacheline-Hints…) als Laufzeit-Parameter der Mess-Zeile | — (Blattstufe; Werte kommen aus `ResolvedSubAxisSetting.expanded_values`, nie als Typ-Switch) |

Gesetz unveraendert: **Organ-Achsen → binary_id; System-/Mess-Achsen NIE binary_id** — im Schema jetzt maschinell erzwungen (`binary_id="organ|never"`-Attribut + Fehlerklasse V-CATEGORY); `serialize_composition_path`/`kCompositionAxisNames` bleiben unberuehrt.

> **[KORREKTUR K2-Folge]:** die Tier-Zeile der Tabelle („Unter-Achsen-WERTE … als Laufzeit-Parameter der Mess-Zeile, nie als Typ-Switch") gilt NUR fuer `materialization="runtime_param"`-Unter-Achsen. `ct_variant`-Unter-Achsen (per-K, line_size, alignments) frieren in der CEB-/Codegen-Stufe als Typ/Define ein (kein Laufzeit-Parameter, KEIN Typ-Switch zur Laufzeit — je Perm ein monomorpher Typsatz, wie in der Planer-Zeile beschrieben); ihre Expansion gehoert in `organ_selection`/`per_perm_flags`, NICHT in `ResolvedSubAxisSetting.expanded_values`-als-Laufzeitwerte.

### 3.E Die heutigen 2 Wahrheiten — Konsolidierung (Andocken, keine Parallelstruktur)

1. **`Enabled*` bleibt ERSTE Wahrheit** (Fork-R1-Empfehlung): die XML ist generiertes Manifest; Byte-Diff-Gate `test_axis_registry_roundtrip` bleibt der Drift-Waechter und wird auf schema="2" mitgezogen. **Faellige Regeneration der stalen ce-XML (18→17 Achsen, isa raus) = die EINZIGE Golden-Beruehrung dieses Designs** — vom bestehenden contract-Test ohnehin erzwungen, als eigener Commit VOR dem v2-Bump.
2. **`KaryPerKCatalog`-Bypass** (source_catalog.hpp:513-540): per-K wird `<sub_axis id="k">` im Angebot; `static_assert` verdrahtet die Bypass-mp_list gegen dieselbe `constexpr`-K-Tabelle, die der Generator emittiert — baubare binary_ids stehen damit erstmals vollstaendig im Manifest.
3. **`golden_wired`-Doppel-Hartkodierung** (Generator-Literale vs `golden_320_catalog`): beide beziehen aus EINER geteilten `constexpr`-Tabelle (§3.A.3); prt-`make_slot`-Literale analog.
4. **Ad-hoc-known-ids-Kanaele im Validator konsolidieren:** `kAllOptLevelIds`/`kAllSimdIds`-Pruefung (validate_profile.hpp:560-583) prueft kuenftig gegen das Kategorie-2-Angebot der v2-Registry (deren Quelle die Code-Konstanten via Generator-Reflektion bleiben — Single-Source erhalten, Code→XML→Check statt Code→Check UND XML ungenutzt); Mess-Kategorien (Z.303-321) gegen Kategorie 3 statt nur `kMeasurementAxisRegistry`-Code; `kValidOpTypes` (Z.538) bleibt XSD-Spiegel (Schema-Ebene, kein Achsen-Angebot); `kKnownDatasetLoaderIds` bleibt Host-injiziert (laufzeit-offene Loader-Registry, korrekt KEIN Registry-Inhalt).
5. **prt-Registry wird echt konsumiert:** per-Phase-`<axes>`-Refs `ee_prt:*` loesen gegen sie auf (heutige Nutzung „nur engine-Attribut" endet); Test-Fixture-Kopie (tests/unit/thesis_tiere/, CMakeLists.txt:2606) wird durch CMake-Define auf die reale Datei ersetzt (Fixture-Drift-Kanal zu).
6. **ThesisProfile-Pfad (Pfad 1) bleibt UNANGETASTET** — golden m3v2 laeuft weiter ueber Code-Reflektion; Konvergenz auf eine Interpreter-Quelle bleibt Fork E des Bauplans (GO-pflichtig, nicht Teil dieses Designs).

### 3.F Golden-Neutralitaet (Ausweis)

- binary_id-Pfad unberuehrt: `serialize_composition_path`/`kCompositionAxisNames` keine Aenderung; `binary_id="organ|never"` ist reine Manifest-/Validator-Schicht.
- Schema v2 additiv; `read_axis_registry` liest v1 weiter; Anwender-XML ohne neue Elemente verhaelt sich byte-identisch (per-Phase-`<axes>` fehlt → `axes_default_lookup`-Default-Schicht = heutiges Verhalten).
- Resolver opt-in/INERT (`-DCOMDARE_EXPERIMENT_XML=`), Planer-OFF ⇒ `measurements.csv` byte-gleich (Bauplan-Verifikation uebernommen).
- Einzige Golden-Beruehrung: Regeneration der stalen ce-Registry-XML (§3.E.1, eigenes Gate existiert).

> **[KORREKTUR K1, adversariale Live-Code-Pruefung 2026-07-19 — „einzige Golden-Beruehrung" ist UNVOLLSTAENDIG; M1 ist nicht selbst-abgeschlossen und zudem AKUT]:** (1) `validate_experiment_profile` Check (5) schlaegt bei unbekanntem `axis@ref` HART fehl („UNBEKANNTE Achse …", validate_profile.hpp:665-670, `r.ok=false`). BEIDE committeten Experiment-Golden-Profile referenzieren aber `<axis ref="isa" allowed_variants="isa_amd64 isa_aarch64"/>`: super `Code/test_data_xml/experiment_golden.xml:57` UND ce-Fixture `tests/unit/thesis_tiere/experiment_golden.xml:62`. `test_experiment_parser` (contract-Label, CI-Job `contract:profile_coverage`) validiert die Fixture GEGEN DIE REALE committete ce-Registry (`COMDARE_CE_AXIS_REGISTRY` = libs/…/cache_engine_axis_registry.xml, tests/unit/CMakeLists.txt:2605). Nach der M1-Regeneration (isa raus) wird dieser Test ROT, wenn nicht BEIDE experiment_golden.xml im SELBEN Schritt um die isa-Zeile bereinigt werden — M1 umfasst also zwingend: Registry-Regen + beide Golden-Profil-XMLs + Fixture, ein Commit-Verbund. (2) STATUS-BEFUND: der Byte-Diff-Test `test_axis_registry_roundtrip` steht im `-R`-Regex desselben CI-Jobs (.gitlab-ci.yml:301) und diffed Generator-Output gegen die committete XML — Generator emittiert seit `8a2e1c3e` 17 Achsen, die XML traegt seit `5fe811db` 18: der Job ist auf aktuellem Stand deterministisch ROT (sofern er seit `8a2e1c3e` lief). M1 ist damit KEINE design-gated Migrationsstufe, sondern eine akute Pipeline-Reparatur nach `feedback_gesamte_pipeline_immer_hart_gruen` — GO-unabhaengig vom Rest dieser Stufe vorzuziehen.

**Schluesseldateien DESIGN (Andockpunkte):** `Code/external/comdare-cache-engine/libs/cache_engine/profile_facade/validate_profile.hpp` (RegistryContents/read_axis_registry/validate_experiment_profile → Resolver), `libs/common/serialization/xml_config_parser/xml_config_parser.hpp` (ExperimentProfile additiv), `tools/axis_registry_gen/main.cpp` + `Code/external/comdare-prt-art/prt_art/registry_gen/main.cpp` (schema="2"-Emit), `libs/cache_engine/profile_facade/source_catalog.hpp` (geteilte constexpr-Golden/K-Tabellen), `Code/02_messung_driver/v32_messreihe_antrieb.hpp` (Plan-Konsument Phase 0), `Code/02_messung_driver/CMakeLists.txt` (statische Registry-Pfad-Defines, unveraendert).

---

## 4. INTEGRATION in den Planer-Bauplan (20260719-planer-ceb-tier-topdown-BAUPLAN.md)

### 4.1 Verortung: die Resolver-Stufe sitzt in Phase 1 als I0 + I1-Verfeinerung

**Kernaussage:** Der Bauplan-Baustein „Interpreter" (Phase 1, Pattern-Tabelle Zeile 1; I1) WIRD der Resolver. Es entsteht KEIN neuer Baustein neben dem Bauplan, sondern der Interpreter wird zur 4-stufigen Resolve-Pipeline praezisiert:

```
Bauplan Phase 0 (unveraendert DAVOR):  super v32-Reconcile — execute_messreihe-Stub (v32_messreihe_antrieb.hpp:259)
                                        wiederverwenden; PhaseCompositions<MergeStrategy>-CT-Dispatch = Plan-Konsument.
NEU  I0  (vor I1):                      Registry-v2-Substrat (Generatoren, Regeneration, read_axis_registry v2).
I1 (verfeinert):                        Interpreter=RESOLVER: [1] Registry-Angebots-Parse (Repository/Flyweight-Arena)
                                        → [2] Anwender-Parse (parse_experiment_profile, Grammatik v2 additiv)
                                        → [3] LINK (Symbol-Resolution, Fehlerklassen E-RES-*)
                                        → [4] LinkedExperimentPlan an ExperimentPlanDirector::construct(IPlanBuilder&).
I2/I3 (Gestalt unveraendert):           die 2 ConcreteBuilder (CMakeGraphBuilder/CiYamlBuilder) konsumieren den
                                        GELINKTEN Plan (Input-Typ LinkedExperimentPlan statt roher Projektion).
```

Begruendungen der Verortung:

1. **Phase-0-Vorrang bleibt:** Der Kritik-Blocker des Bauplans (Befund 1) gilt unveraendert — vor Plan-KONSUM muss das super-Repo reconciled sein (`execute_messreihe` fuellen/wiederverwenden, kein dritter Enumerations-Walk). Der Resolver SELBST ist davon unabhaengig baubar (reine ce-Schicht in validate_profile.hpp/xml_config_parser.hpp); sein Output-Vertrag `LinkedExperimentPlan` ist auf `execute_messreihe` + `PhaseCompositions<MergeStrategy>` (steps[i].merge) zugeschnitten. I0+I1-Resolve koennen also parallel zu Phase 0 entstehen; die VERDRAHTUNG Plan→Konsument ist Phase-0-gated.
2. **I0 ist neu und gehoert VOR I1:** ohne v2-Angebot gibt es nichts zu linken. I0 = (a) Regeneration der stalen ce-Registry-XML @schema=1 (18→17, isa raus) als EIGENER Commit — einzige Golden-Beruehrung, vom bestehenden contract-Test ohnehin erzwungen; (b) geteilte `constexpr`-Tabellen (golden-K aus `golden_320_catalog`, prt-Slot-Tabelle) — toetet die Doppel-Hartkodierung §2.D.3; (c) beide Generatoren emittieren schema="2" inkl. Kategorien 2+3 (der `--with-extra-axes`-Nebenpfad wird PFLICHT-Emit, committet); (d) `read_axis_registry`/`RegistryContents` v2-faehig (v1-tolerant, kein zweiter Parser); (e) `test_axis_registry_roundtrip` auf v2 mitgezogen.
3. **I1 wird verfeinert, nicht ersetzt:** Director + `IPlanBuilder` + `--dump-plan` + Contract-Test bleiben exakt wie im Bauplan; NEU ist, dass der Director-Input der GELINKTE Plan ist. `--dump-plan` dumpt den `LinkedExperimentPlan` (deterministische Textform = Contract-Test-Basis; Fork B des Bauplans — `PlanTextBuilder` vs Director-Methode — bleibt offen). `project_experiment_to_sota_passes`/`ExperimentPhaseProjection` bleiben WIEDERVERWENDET: die Projektion wird aus dem gelinkten Plan gespeist, kein zweiter Walk daneben.
4. **CoR-Einhaengepunkt wird hier NEU deklariert** — das erledigt Kritik-Befund 4 des Bauplans (`resolve_selection` existiert nicht als Naht): die Reduktion der aufgeloesten Kandidaten ist ein deklarierter NEUER Schritt innerhalb des Resolvers (nach [3] LINK, vor [4] Director), der die vorhandene, bisher konsumentenlose `run_selection_filter_chain`/`ResumeFilter` (selection_filter_chain.hpp:76-101) wiederverwendet; leere Kette = Identitaet (Bauplan-R4-Mitigation uebernommen).
5. **Die 2 ConcreteBuilder konsumieren den GELINKTEN Plan:** `CMakeGraphBuilder` (I2) und `CiYamlBuilder` (I3) laufen unveraendert aus EINEM Director-Walk (strukturelle Synchronie), beziehen aber per-Perm-Flags aus `ResolvedPhaseStep.per_perm_flags` (flag_map-aufgeloest → `make_gpp_compile_fn`) und die System-Matrix aus `ResolvedPhaseStep.system` (→ `build_version`-Suffix `+cxx=+opt=+ext=`). Kein Freitext-Flag im Emit — nur Registry-registrierte Tokens.
6. **Phase-2-Bezug:** das `CebSystemAxisDrive`-Buendel (Bauplan Phase 2) wird aus `ResolvedPhaseStep.system` BEFUELLT; das Kategorie-2-Angebot (flag_map) ist die deklarative Quelle, die Aufloesung bleibt `make_gpp_compile_fn` (Q2: Flags→CompileFn, NIE binary_id). Kritik-Befund 5 bleibt gueltig: der Drive-POD selbst kann parallel zu Phase 1 entstehen; nur seine Befuellung aus dem Plan haengt an I1.
7. **Fork-E-Verhaeltnis (Bauplan):** der Resolver haelt sich strikt an Pfad 2 (Experiment-Profil); Pfad 1 (ThesisProfile/m3v2, golden) bleibt unangetastet. Konvergenz beider XML-Interpreter-Quellen bleibt Fork E, GO-pflichtig.
8. **Fork-A-Verhaeltnis (Bauplan):** der Resolver ist Planer-seitig in-Prozess (Configure-Zeit) und von der CEB-.so-Grenzfrage unabhaengig — er liefert denselben `LinkedExperimentPlan`, egal ob die CEB spaeter in-Prozess oder als dlopen-.so angesprochen wird.

### 4.2 Aenderungen/Verfeinerungen bestehender Bauplan-Increments

| Bauplan-Element | Status durch Resolver-Stufe |
|---|---|
| **Phase 0** super-Reconcile (v32_messreihe_antrieb) | UNVERAENDERT davor. Praezisierung: `execute_messreihe` wird der Plan-KONSUMENT des `LinkedExperimentPlan`; `PhaseCompositions<MergeStrategy>`-CT-Dispatch konsumiert `steps[i].merge` (Reconcile statt drittem Walk) |
| **NEU I0** Registry-v2-Substrat | eingefuegt VOR I1 (Inhalt §4.1 Punkt 2). Golden-neutral bis auf die ohnehin faellige Regeneration (eigener Commit, byte-diff-Gate) |
| **I1** Interpreter+Director+`IPlanBuilder`+`--dump-plan`+Contract-Test | VERFEINERT: Interpreter=Resolver (Parse→Repository→Link→Plan); Director-Input = `LinkedExperimentPlan`; Contract-Test um Negativ-Link-Tests (je Fehlerklasse) erweitert; CoR-Einhaengepunkt hier NEU deklariert (Kritik-Befund 4 erledigt); `--dump-plan` dumpt den gelinkten Plan |
| **I2** `CMakeGraphBuilder` + 2-Pass `experiment_plan.cmake` | Gestalt unveraendert; Input = gelinkter Plan; per-Perm-`CompileFn` aus `per_perm_flags` (flag_map-Tokens) statt nur `opt_flag` |
| **I3** `CiYamlBuilder` (Child-Pipeline) | dito; Topologie-Isomorphie-Contract-Test unveraendert |
| **I4** `<measurement mode>` + `failed`-Zelle | uebernimmt die Fehlerklassen-Taxonomie §3.C.3: E-RES-V/I = resolve-zeitig hart; E-RES-C = `"failed"`-CSV-Zelle + `<binary_id>.error.log` zur Mess-Zeit; der Resolver ANNOTIERT (`requires_hw`), I4 implementiert die Laufzeit-Behandlung |
| **I5** Serialisierungs-Emitter | unveraendert; `<sweeps>`/Ranges liefern die Workload-Dimensionen aus `expanded_values` (Systemachsen flach=Ordner, Tier tiefer Baum+CSV — Serialisierungs-Doktrin unberuehrt) |
| **Phase 2** CEB-Wiring (`CebSystemAxisDrive`) | Befuellung aus `ResolvedPhaseStep.system`; Drive-POD-Bau parallelisierbar (Kritik-Befund 5); `system_axes_version_suffix`-Round-Trip-Verifikation unveraendert |
| **Phase 3** Tier ueber bestehendes Dock | UNVERAENDERT (REUSE); Unter-Achsen-WERTE erreichen das Tier als Laufzeit-Parameter der Mess-Zeile (`expanded_values`), nie als Typ-Switch |
| Bauplan-Pattern-Tabelle | +3 Zeilen: Repository (PoEAA), Flyweight (GoF), Symbol-Resolution nach Dock-Loader-Blaupause (§3.C.2) |
| Bauplan-Risiken | R1/R4/R6 gelten fort; NEU R8: Schema-v2-Emit veraendert Registry-Byte-Bild → Roundtrip-Test-Update im SELBEN Commit wie Generator-Aenderung (nie getrennt, sonst rotes contract-Gate) |

### 4.3 Migrations-Pfad Registries + Profile (additiv, golden-neutral)

**Leitplanke:** heutige XMLs bleiben parsebar, bis Schema v2 aktiv ist — kein Flag-Day, v1-Leser bleibt (Doku/Formate werden nie geloescht, nur deprecated).

- **M1 (in I0, eigener Commit):** Regeneration der stalen ce-Registry-XML noch auf `schema="1"` (18→17 Achsen, isa raus, Slot-Shift). EINZIGE Golden-Beruehrung; das byte-diff-Gate `test_axis_registry_roundtrip` erzwingt sie ohnehin. VOR jedem v2-Schritt, damit der v2-Diff sauber lesbar bleibt. **[KORREKTUR K1]:** M1 ist ein COMMIT-VERBUND, nicht nur die Registry-Regen: zusaetzlich MUESSEN im selben Schritt `Code/test_data_xml/experiment_golden.xml:57` + ce `tests/unit/thesis_tiere/experiment_golden.xml:62` (`ref="isa"`-Zeile) bereinigt werden, sonst kippt `test_experiment_parser` (Check (5) hart gegen die reale Registry) von gruen auf rot. Ausserdem AKUT statt design-gated: `contract:profile_coverage` ist wegen des Roundtrip-Diffs (Generator 17 seit `8a2e1c3e` vs. XML 18 seit `5fe811db`) auf HEAD deterministisch rot — M1 GO-unabhaengig sofort ziehen (`feedback_gesamte_pipeline_immer_hart_gruen`).
- **M2 (in I0):** beide Generatoren emittieren `schema="2"` (rein additive Attribute/Kind-Elemente); beide committeten Registries werden auf v2 regeneriert; `read_axis_registry` liest v1 UND v2 (fehlende Felder → leer). prt-Test-Fixture-Kopie → CMake-Define auf reale Datei (§3.E.5).
- **M3 (in I1, Verhalten):** bestehende Anwender-Profile (`Code/test_data_xml/experiment_golden.xml`, all_axes_golden-XML, m3v2-Thesis-Profil) bleiben UNVERAENDERT gueltig: ohne `<uses_registries>` laeuft exakt der heutige Check-Satz (`validate_experiment_profile`-Checks 1–7 bzw. Pfad-1-Code-Reflektion); Verhalten byte-identisch (fehlende per-Phase-`<axes>` → `axes_default_lookup`-Default-Schicht). **[KORREKTUR K1-Einschraenkung]:** „UNVERAENDERT gueltig" gilt NICHT fuer die isa-referenzierenden experiment_golden.xml — die sind bereits in M1 (Commit-Verbund) anzupassen, da Check (5) schon HEUTE gegen die Registry laeuft und nach der Regen die `ref="isa"`-Zeile hart faellt. (all_axes_golden.profile.xml ist isa-frei — verifiziert; `cacheline_study.profile.xml:41` traegt `ref="isa"`, laeuft aber ueber Pfad 1/Code-Reflektion und ist von M1 unberuehrt.)
- **M4 (nach I1, opt-in):** neue/migrierte Profile pinnen `<uses_registries schema="2"/>` und nutzen per-Phase-`<axes>`/`<sweeps>`; erst mit Pin greift die volle V-*-Haerte (Symbol-Resolution, Kategorie-Gates, Range-Pruefung).
- **M5 (Fork R6-gated):** Ende des v1-Lese-Fensters NUR mit eigenem User-GO; bis dahin bleibt v1 lesbar und wird lediglich als deprecated markiert.

### 4.4 Verifikations-Kriterien je Schritt

**Jeder Schritt (invariant):** ce-standalone-Build gruen + super-Sub-Build gruen; GESAMTE Pipeline hart gruen; Planer-OFF ⇒ `measurements.csv` byte-gleich; golden binary_ids-Diff leer (`golden_fullpilot_320_binary_ids_abi6` bzw. all_axes-Referenz unberuehrt).

**M1/I0:**
- `test_axis_registry_roundtrip` GRUEN (erst @v1 nach Regeneration, dann @v2 im Generator-Commit; Test-Update im selben Commit).
- XML-Diff M1 = exakt isa-Entfall + Slot-Shift (kein weiterer Drift); XML-Diff M2 = NUR additive v2-Felder.
- **[KORREKTUR K1]:** `test_experiment_parser` BLEIBT GRUEN im M1-Commit-Verbund (beide `experiment_golden.xml` isa-bereinigt im selben Commit wie die Registry-Regen); Kriterium: `grep -c 'ref="isa"'` == 0 in `Code/test_data_xml/experiment_golden.xml` + ce `tests/unit/thesis_tiere/experiment_golden.xml`; `contract:profile_coverage` GESAMT gruen (Roundtrip + Parser gleichzeitig — nie eines auf Kosten des anderen).
- Abgleich-Test: `kAllOptLevelIds`/`kAllSimdIds`/`kMeasurementAxisRegistry` ⊆ Kategorie-2/3-Emit (Code→XML-Single-Source bewiesen); `KaryPerKCatalog`-K-Werte == `<sub_axis id="k">`-Options (static_assert + Testabgleich).

**I1 (Resolver) — NEGATIV (je Fehlerklasse mindestens ein Test, deterministische Meldung MIT Koordinate, kein stilles Verhalten):**
- unregistrierte Achse / Variante / Unter-Achse / Flag-Token → exakt V-UNREG-AXIS / V-UNREG-VARIANT / V-UNREG-SUBAXIS / V-UNREG-FLAG;
- `<uses_registries schema="3">` gegen v2-Registry → V-SCHEMA-PIN;
- `algo_version="v0"`-Pin gegen v1-Angebot → V-VERSION-PIN;
- `<range>` auf nicht-range-faehiger Unter-Achse, `<values>` ⊄ `<options>`, Range ausserhalb min/max → V-RANGE;
- System-/Mess-Ref in Organ-Position, `pruefling_slot`-Ref in Stufe1-Phase, Mess-Kategorie ausserhalb Kat.-3 → V-CATEGORY;
- `enabled="false"`-Referenz ohne Opt-in → V-DISABLED;
- fehlende/unparsbare Registry, engine-Mismatch → E-RES-I (bestehende Checks, jetzt klassifiziert).

**I1 (Resolver) — POSITIV:**
- `experiment_golden.xml` UND die all_axes_golden-XML (2^17-Referenz) linken sauber → `LinkedExperimentPlan` (alle Refs aufgeloest, Flyweight-Pointer stabil, Doppel-Resolve ⇒ identischer `--dump-plan`-Output = Determinismus-Beweis);
- m3v2 (Pfad 1) validiert byte-identisch weiter — der Resolver beruehrt den ThesisProfile-Pfad nicht;
- prt-Referenz (`ee_prt:path_compression`) loest gegen die REALE prt-Registry auf (erste echte prt-Konsumtion);
- CoR: leere Kette = Identitaet; `ResumeFilter` reduziert korrekt (`two_phase_valid`→Reject) — Bauplan-CoR-Test uebernommen.

**I2/I3:** Contract-Test Topologie-Isomorphie (gleiche `PhaseStep`-Menge, gleiche `build:→measure:`-Kanten) unveraendert; zusaetzlich: jedes emittierte Flag stammt aus einem flag_map-registrierten Token (kein Freitext im Emit-Diff).

**Phase 2 (unveraendert aus Bauplan, hier bestaetigt):** Round-Trip `CebSystemAxisDrive` → `build_version`-Suffix identisch zur bisherigen Montage (`+cxx=+opt=+ext=`); bestehende Tier-DLLs laden weiter (`host_compatible_with`, Major 6); CSV-Spalten regressionsfrei.

---

## 5. FORKS fuer USER-GO (blockieren bis entschieden)

Die drei primaeren Forks dieser Stufe:

- **FORK R1 — Single-Source der Registry:** Option 1 = Code=Wahrheit, Registry GENERIERT (Generatoren ausbauen, Nebenwahrheiten in Reflektion ziehen — golden-K aus `golden_320_catalog`, prt-Slot-Tabelle, `algo_version`-Concept, per-K-Reflektion) — **EMPFEHLUNG**. Option 2 = Registry=Hand-Wahrheit + CI-Diff-Guard — dokumentiert abgelehnt (§3.A.3: XML kann CT-Typen nicht erzwingen; Hand-Pflege driftet nachweislich — die committete XML IST stale). **GO noetig.** **[KORREKTUR K6 — Sequenz-Klarstellung, damit der Fork nicht faktisch vorweg entschieden wird]:** I0/M2 und §3.E sind vollstaendig Option-1-konditioniert (Generator-Ausbau); bei R1=Option 2 entfiele I0 in dieser Form. Deshalb: R1-GO ist VOR I0-Baubeginn einzuholen — AUSNAHME ist nur der akute M1-Commit-Verbund (K1), der unter BEIDEN Optionen identisch noetig ist (Pipeline-Reparatur, kein Options-Vorgriff).
- **FORK R5 — Range-Syntax-Umfang:** (a) MINIMAL: `<values>` (diskret, ⊆ options) + `<range min max scale="pow2|linear"/>` — deckt N-Sweep, prefetch_distance, repetitions ab — **EMPFEHLUNG** (jede Erweiterung bleibt additiv moeglich); (b) ERWEITERT: zusaetzlich `step`-Ausdruecke, arithmetische Ausdruecke, zusammengesetzte/abhaengige Ranges (Interpreter-Grammatik waechst deutlich; Naehe zum „mini-Interpreter"-Bild der Direktive, aber gegen YAGNI/Deadline). **GO noetig.**
- **FORK R6 — Schema-v2-Fenster:** (a) v1 bleibt UNBEFRISTET lesbar, wird nur als deprecated markiert; Abschaltung erst mit eigenem, spaeterem GO — **EMPFEHLUNG** (Doku/Formate-nie-loeschen-Doktrin, kein Flag-Day); (b) hartes Fenster: v1-Leser wird nach vollzogener golden-N-Migration (alle committeten Profile auf v2 gepinnt) entfernt. **GO noetig.**

Weitere Design-Forks (aus §3, ebenfalls GO-pflichtig):

- **FORK R2 — per-Phase-`<axes>` zusaetzlich zur Default-Schicht** (Empfehlung: ja, Zwei-Schichten-.pom = dependencyManagement+dependencies) vs. nur globales `axes_default_lookup` erweitern. **GO noetig.**
- **FORK R3 — prt-Sichtbarkeitsregel:** `pruefling_slot` nur in Stufe2/3-Phasen referenzierbar (Empfehlung, V-CATEGORY-hart) vs. ueberall mit Warnung. **GO noetig.**
- **FORK R4 — Pin-Strenge:** `schema`-Nummer (Empfehlung, Major-Gate-Analog `host_compatible_with`) vs. zusaetzlicher Content-Hash-Pin (Repro-maximal, aber jede Regeneration invalidiert alle Profile). **GO noetig.**

Abhaengig, NICHT Teil dieser Stufe: Bauplan-Forks A–E bleiben eigenstaendig offen (A: CEB-.so-Grenze — Resolver davon unabhaengig; B: dritter `PlanTextBuilder` fuer `--dump-plan`; C: Deadline-Schnittlinie 28.07 — I0+I1-Resolve sind golden-neutral und passen VOR die Schnittlinie, Empfehlung: I0+I1 in den Vor-Deadline-Scope aufnehmen; D: `ceb_contract_version`-Minor; E: XML-Pfad-Konvergenz — dieser Stufe strikt additiv am Experiment-Profil). Phase-0-v32-Reconcile bleibt Vorbedingung des Plan-KONSUMS; der Resolver selbst ist davon unabhaengig baubar.

---

## 6. KORREKTUR-VERMERK (adversariale Live-Code-Pruefung 2026-07-19, additiv)

Harte Gegenpruefung aller Andockpunkte/Behauptungen gegen den Live-Code. Bestandene Pruefpunkte und eingearbeitete Korrekturen (K1–K6 inline an den betroffenen Stellen markiert):

**Verifiziert KORREKT (Andock-/Anker-Pruefung):**
- (a) Kein Parallel-Validator/-Parser im Design: `read_axis_registry` (validate_profile.hpp:452) ist verifiziert der EINZIGE Registry-XML-Leser im ce-Bestand (alle `comdare_axis_registry`-Treffer in validate_profile.hpp); `validate_experiment_profile` (:482), `ExperimentProfile` (xml_config_parser.hpp:300), `parse_experiment_profile` (:338), beide Generatoren, CMake-Pfad-Defines (super main.cpp:314-316/655, CMakeLists.txt:33-34) — alle zitierten Naehte existieren wie beschrieben.
- (d) Kein Konflikt mit dem Phase-0-Blocker: Vorrang + Unabhaengigkeit des Resolvers korrekt dargestellt; Dock-Loader-Blaupause `builder/anatomy_module_loader/anatomy_module_loader.cpp:112-145` (4 Pflichtsymbole, Magic-Gate, Major/Minor-Gate) existiert WOERTLICH wie zitiert.
- (b) Fork-Vorlage ehrlich: R1–R6 als GO-pflichtige Forks mit Empfehlung vorgelegt, keine stille Entscheidung — mit der K6-Sequenz-Klarstellung (R1-GO vor I0).
- IST-Befunde §2 bestaetigt: committete ce-XML = 18 Achsen inkl. `isa`/T11 (STALE), Generator emittiert 17 (INC-2d-Kommentar im Code), `kCompositionAxisNames` = 17 ohne isa; prt-`make_slot`-Literale (registry_gen/main.cpp:175-181); `run_selection_filter_chain`/`ResumeFilter` konsumentenlos; `kValidOpTypes`:538 / opt-simd-Checks :560-583; §27-Ledger-Wortlaut deckungsgleich uebernommen.

**Korrigiert (inline):**
- **K1 (§3.F, §4.3 M1/M3, §4.4):** „einzige Golden-Beruehrung" widerlegt — M1 ist ein Commit-Verbund (Registry-Regen + BEIDE isa-referenzierenden `experiment_golden.xml`), sonst kippt `test_experiment_parser`; `contract:profile_coverage` ist wegen des Roundtrip-Byte-Diffs auf HEAD deterministisch rot → M1 akut, GO-unabhaengig.
- **K2 (§3.A.2, §3.D):** `<sub_axis id="k" stage="runtime">` war eine CT→RT-Degradierung gegen den Live-Code (per-K = eigene CT-Typen/binary_ids; `cacheline.line_size` = `is_static=true` im Baum) → `materialization="ct_variant|runtime_param"` aus Code-Reflektion je Unter-Achse.
- **K3 (§3.C.3):** E-RES-* dockt an das BESTEHENDE `measurement/axis_error.hpp`-Framework an (D1 `CompilerCompilerErrorClass` + D2 `SampleStatus`); V-*-Codes = Sub-Codes unter `konfig_xml_parse`, keine dritte Taxonomie.
- **K4 (§3.C.4):** `execute_messreihe` v32_messreihe_antrieb.hpp:259 ist KEIN Stub (voll implementierte INC-G+H-Kette, INERT); der return-0-Stub liegt in `v32_orchestrator.hpp:92` — Reconcile = Input-Umstellung, kein Neuschreiben.
- **K5 (§3.B.2):** Anwender-Syntax fuer ACHSEN-Ebenen-Unter-Achsen ergaenzt (Regel 6) — ohne sie waere der §27-VOLLE Unter-Achsen-Support fuer node_width/cacheline/alloc_hw nicht anzeigbar.
- **K6 (§5 R1):** I0/M2 sind Option-1-konditioniert; R1-GO vor I0-Baubeginn (Ausnahme: akuter M1-Verbund, options-neutral).
