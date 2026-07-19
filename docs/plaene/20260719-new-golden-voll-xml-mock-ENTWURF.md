# NEW-GOLDEN VOLL-XML-MOCK — ENTWURF (Ziel-XML der ganzen Kette, N = 2^17)

> **Status:** ENTWURFS-DOKUMENT (docs/plaene), 2026-07-19. Das XML unten ist ein **MOCK** — es wird
> **NICHT** als live .xml eingespielt; die Keimzelle
> `Code/external/comdare-cache-engine/libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml`
> bleibt unberuehrt (VERFEINERN dokumentiert hier, nicht dort). Nichts im Live-Pfad geaendert.
>
> **Quellen (verifiziert am Code-Ist, ce HEAD-Stand des Katalogs `5da2caf7`):**
> - Keimzelle `all_axes_golden.profile.xml` (existierend, CRC64-Fixture gelandet)
> - Referenz-Zwilling `m3v2_study.profile.xml` (golden-320, TABU)
> - Katalog `docs/plaene/20260719-xml-featurespace-topdown-KATALOG.md` (A.1-Vorrat, Gaps B1-B22)
> - Bauplan `docs/plaene/20260718-new-golden-all-axes-vor-BAUPLAN-NEW-GOLDEN-ALL-AXES.md` (N-Mathematik, kanonische Reihenfolge-Pflicht)
> - Live verifiziert: `builder/experiment_tree/axis_path_serialization.hpp:34` (kCompositionAxisNames, 17),
>   `libs/common/serialization/xml_config_parser/xml_config_parser.hpp` (ThesisProfile :195-246 traegt `datasets` :233
>   und `measurement_categories` :245 — beide HEUTE parsbar), `Code/test_data_xml/experiment_golden.xml`
>   (Ziel-Syntax system_axes/phases/output), `Code/test_data_xml/*.test_data.xml` (reale Akten).
>
> **Doktrin-Anker:** binary_id = NUR die 17 Organ-Achsen (ABI-6, kV3AxisCount=17); System-/Mess-Achsen = Sidecar,
> NIE binary_id. golden-320 = TABU-Snapshot; golden-N = 2^17 = 131.072 all-vary. Referenz (lazy Count) ≠
> materialisierter Bau-Katalog (bleibt 320). NUR EIN offizielles XML-Programm.

---

## A) Der VOLLE XML-Mock

Konventionen im Mock:
- **LIVE-Sektionen** = heute parsbar im `comdare_thesis_profile`-Kanal (parse_thesis_profile). Die Keimzelle wird
  VERFEINERT: `datasets` + `measurement_categories` kommen ADDITIV hinzu (beide heute parsbar, s. B unten).
- **`<!-- ZUKUNFT: ... -->`-Bloecke** = Ziel-Sektionen, die der ThesisProfile-Parser HEUTE NICHT traegt
  (Gap-Referenzen je Block). Sie zeigen das ZIEL-XML der ganzen Kette (Planer→CEB→Tier→CSV→LaTeX).
- permute_axes: GENAU 2 `<value>` je Achse, Reihenfolge = kanonisch kCompositionAxisNames (Pflicht, sonst
  catalog_codegen-Fehler). Werte = die ERSTEN 2 Enabled-name()-Werte (mp_take_c-deckungsgleich; Fork zur
  Katalog-Spread-Paar-Alternative s. B.2).

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- MOCK / ENTWURF 2026-07-19 - comdare_thesis_profile ZIEL-Bild fuer golden N=2^17=131072.
     NICHT einspielen. Live-Keimzelle: algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml.
     LIVE-Sektionen sind heute parsbar; ZUKUNFT-Bloecke sind Gap-gated (B1/B2/B3/B5/B6, s. Katalog). -->
<comdare_thesis_profile id="all_axes_golden" schema_version="1">

  <!-- (a) BASIS-TIERE [LIVE, wie Keimzelle]: PRT-ART + 6 SOTA-Kompositionen = 7 Lebewesen je Reihe. -->
  <base_tiers>
    <tier id="prt_art"  profile_ref="../sota/art.profile.xml"       paper_ref="PRT"/>
    <tier id="art"      profile_ref="../sota/art.profile.xml"       paper_ref="P01"/>
    <tier id="hot"      profile_ref="../sota/hot.profile.xml"       paper_ref="P02"/>
    <tier id="masstree" profile_ref="../sota/masstree.profile.xml"  paper_ref="P03"/>
    <tier id="surf"     profile_ref="../sota/surf.profile.xml"      paper_ref="P10"/>
    <tier id="start"    profile_ref="../sota/start.profile.xml"     paper_ref="P05"/>
    <tier id="wormhole" profile_ref="../sota/wormhole.profile.xml"  paper_ref="P07"/>
  </base_tiers>

  <!-- (b) ALLE 17 Achsen [LIVE, wie Keimzelle] in kanonischer kCompositionAxisNames-Reihenfolge
       (axis_path_serialization.hpp:34), je GENAU 2 konkrete name()-Werte = die ersten 2 Enabled
       (deckungsgleich mp_take_c<EnabledStrategies,2>; CRC64-Fixture-Anker). Fanout je Achse = 2.
       Kartesisch: 2^17 = 131072. Leere value-Liste VERBOTEN. -->
  <permute_axes>
    <axis ref="search_algo"><value>k_ary</value><value>interpolation</value></axis>
    <axis ref="cache_traversal"><value>linear_fanout</value><value>hash_lookup</value></axis>
    <axis ref="mapping"><value>direct_placement</value><value>pool_relative</value></axis>
    <axis ref="path_compression"><value>path_compression_none</value><value>path_compression_patricia</value></axis>
    <axis ref="node_type"><value>node4</value><value>node16</value></axis>
    <axis ref="memory_layout"><value>memory_layout_cache_line_aligned</value><value>memory_layout_aos_strict</value></axis>
    <axis ref="allocator"><value>std_malloc</value><value>pmr_resource</value></axis>
    <axis ref="prefetch"><value>prefetch_none</value><value>prefetch_distance_estimator</value></axis>
    <axis ref="concurrency"><value>concurrency_none</value><value>concurrency_blocking</value></axis>
    <axis ref="serialization"><value>serialization_raw_binary</value><value>serialization_var_len</value></axis>
    <axis ref="value_handle"><value>value_handle_inline</value><value>value_handle_external_pool</value></axis>
    <axis ref="index_organization"><value>index_org_heap</value><value>index_org_clustered</value></axis>
    <axis ref="io_dispatch"><value>io_in_memory_only</value><value>io_direct</value></axis>
    <axis ref="migration_policy"><value>migration_none</value><value>migration_hot_cold</value></axis>
    <axis ref="filter"><value>filter_bloom</value><value>filter_cuckoo</value></axis>
    <axis ref="queuing_q1"><value>no_buffer</value><value>fifo_queue</value></axis>
    <axis ref="queuing_q2"><value>eager_flush</value><value>watermark_flush</value></axis>
    <!-- ZUKUNFT (User-Fork F-SPREAD, s. B.2): Katalog A.1 "All-Vary-take-2" schlaegt auf 13 von 17 Achsen (KORREKTUR 19.07.: 13, nicht 12 — s. B.2-Zaehlung)
         Max-Kontrast-Paare vor (z.B. node4+node256, cache_line_aligned+packed_bitmap, none+wait_free,
         no_buffer+lockfree_mpmc). Umstellung braucht Index-Selektion statt mp_take_c im Katalog-Mechanismus
         plus CRC64-Fixture-Regeneration. Bis zum Entscheid gilt first-2 (mechanisch, fixture-verankert). -->
  </permute_axes>

  <!-- (b') PER-ACHSEN-SWEEP [LIVE, wie Keimzelle]: alle 17 gegen Baseline index0 (Ganz-System-Coverage). -->
  <axis_sweeps>
    <axis_sweep axis="search_algo"        baseline="index0"/>
    <axis_sweep axis="cache_traversal"    baseline="index0"/>
    <axis_sweep axis="mapping"            baseline="index0"/>
    <axis_sweep axis="path_compression"   baseline="index0"/>
    <axis_sweep axis="node_type"          baseline="index0"/>
    <axis_sweep axis="memory_layout"      baseline="index0"/>
    <axis_sweep axis="allocator"          baseline="index0"/>
    <axis_sweep axis="prefetch"           baseline="index0"/>
    <axis_sweep axis="concurrency"        baseline="index0"/>
    <axis_sweep axis="serialization"      baseline="index0"/>
    <axis_sweep axis="value_handle"       baseline="index0"/>
    <axis_sweep axis="index_organization" baseline="index0"/>
    <axis_sweep axis="io_dispatch"        baseline="index0"/>
    <axis_sweep axis="migration_policy"   baseline="index0"/>
    <axis_sweep axis="filter"             baseline="index0"/>
    <axis_sweep axis="queuing_q1"         baseline="index0"/>
    <axis_sweep axis="queuing_q2"         baseline="index0"/>
  </axis_sweeps>

  <!-- (c) SOTA-REIHEN [LIVE, wie Keimzelle]: 7 Lebewesen x Stufe1 + 7 x Stufe2 (Reihe A) + 7 x Stufe3
       (Reihe B) = 21 Eintraege. Reihe C (Merge/Regression alt-neu) ist build-uebergreifend, kein id="C". -->
  <sota_series_set>
    <sota_series id="A" lebewesen="prt_art"  merge="Stufe1_CeOnly"/>
    <sota_series id="A" lebewesen="art"      merge="Stufe1_CeOnly"/>
    <sota_series id="A" lebewesen="hot"      merge="Stufe1_CeOnly"/>
    <sota_series id="A" lebewesen="masstree" merge="Stufe1_CeOnly"/>
    <sota_series id="A" lebewesen="surf"     merge="Stufe1_CeOnly"/>
    <sota_series id="A" lebewesen="start"    merge="Stufe1_CeOnly"/>
    <sota_series id="A" lebewesen="wormhole" merge="Stufe1_CeOnly"/>
    <sota_series id="A" lebewesen="prt_art"  merge="Stufe2_PrueflingReplace"/>
    <sota_series id="A" lebewesen="art"      merge="Stufe2_PrueflingReplace"/>
    <sota_series id="A" lebewesen="hot"      merge="Stufe2_PrueflingReplace"/>
    <sota_series id="A" lebewesen="masstree" merge="Stufe2_PrueflingReplace"/>
    <sota_series id="A" lebewesen="surf"     merge="Stufe2_PrueflingReplace"/>
    <sota_series id="A" lebewesen="start"    merge="Stufe2_PrueflingReplace"/>
    <sota_series id="A" lebewesen="wormhole" merge="Stufe2_PrueflingReplace"/>
    <sota_series id="B" lebewesen="prt_art"  merge="Stufe3_FullJoin"/>
    <sota_series id="B" lebewesen="art"      merge="Stufe3_FullJoin"/>
    <sota_series id="B" lebewesen="hot"      merge="Stufe3_FullJoin"/>
    <sota_series id="B" lebewesen="masstree" merge="Stufe3_FullJoin"/>
    <sota_series id="B" lebewesen="surf"     merge="Stufe3_FullJoin"/>
    <sota_series id="B" lebewesen="start"    merge="Stufe3_FullJoin"/>
    <sota_series id="B" lebewesen="wormhole" merge="Stufe3_FullJoin"/>
  </sota_series_set>

  <!-- (a-S1) WORKING-SET-SWEEP [LIVE, wie Keimzelle]: {2^14, 2^17, 2^20, 2^23}. -->
  <working_set_sweep>16384 131072 1048576 8388608</working_set_sweep>

  <!-- (d) DATASETS [LIVE, ADDITIV zur Keimzelle]: heute PARSBAR (ThesisDatasetRef id/akte_ref/loader,
       xml_config_parser.hpp:176-233); Mess-KONSUM des Loaders ist B4-gated (deklarativ ok, binary_id-neutral,
       datasets_signature im Resume-Stamp). Reale Akten aus Code/test_data_xml/, beide Loader-Familien. -->
  <datasets>
    <dataset id="url"             akte_ref="test_data_xml/url.test_data.xml"             loader="string_corpus"/>
    <dataset id="sosd_books_200M" akte_ref="test_data_xml/sosd_books_200M.test_data.xml" loader="sosd_uint64"/>
  </datasets>

  <!-- (c-1) MESS-DIMENSIONEN [LIVE, wie Keimzelle]: workloads = autoritative Achse-2-Auswahl (YCSB A-F);
       telemetry = Sidecar H-10, nie binary_id. -->
  <compile_dims>
    <workloads>ycsb_a ycsb_b ycsb_c ycsb_d ycsb_e ycsb_f</workloads>
    <telemetry mode="on" silent="true"/>
  </compile_dims>

  <!-- (c-2) MESS-KATEGORIEN [LIVE, ADDITIV zur Keimzelle]: heute PARSBAR in BEIDEN Kanaelen (Katalog A.3,
       KEIN Gap; ThesisProfile :236-245). Spalten-PROJEKTION, keine Vary-Achse. Fehlend = alle 16; die
       golden-N-Referenz nennt alle 16 EXPLIZIT (Selbst-Doku des Ganz-System-Anspruchs). BRANCH_MISS,
       IPC_CPI, THROUGHPUT sind im 16-Spalten-CSV-Record noch offen (B17, Record-Erweiterung separat). -->
  <measurement_categories>
    <category name="CLU"/>
    <category name="CACHE_MISS_L1"/>
    <category name="CACHE_MISS_L2"/>
    <category name="CACHE_MISS_L3"/>
    <category name="DTLB_MISS"/>
    <category name="MEMORY_FOOTPRINT"/>
    <category name="BRANCH_MISS"/>
    <category name="IPC_CPI"/>
    <category name="LATENCY_MEAN"/>
    <category name="LATENCY_P50"/>
    <category name="LATENCY_P95"/>
    <category name="LATENCY_P99"/>
    <category name="LATENCY_P999"/>
    <category name="THROUGHPUT"/>
    <category name="ENERGY_J"/>
    <category name="FILL_BUFFER_OCCUPANCY"/>
  </measurement_categories>

  <!-- (d-1) DYNAMISCHE OS-LAUFZEIT-DIMENSIONEN [LIVE, wie Keimzelle]: DynamicDims, NIE binary_id.
       thread_count=1 gepinnt (B11 ehrlich: label-only, Mess=1-Thread-Doktrin); hw_prefetcher auf dem
       Cluster real via MSR 0x1A4. -->
  <runtime_dynamic>
    <thread_count>1</thread_count>
    <hw_prefetcher>all_on adjacent_off all_off</hw_prefetcher>
  </runtime_dynamic>

  <!-- (f) WIEDERHOLUNGEN [LIVE, wie Keimzelle]: KF-10 separat, nie interpoliert. -->
  <repetitions count="3" interpolate="false" overlay_in_chart="true"/>

  <!-- (d-S1) RUN-OPTIONS [LIVE, wie Keimzelle]: cap = 131072 = N = 2^17 (Ganz-System-Kartesik).
       Anm. A.8: platform ist ein kopiertes CSV-Tag; Mess-Realitaet = Linux-Cluster (prod1). -->
  <run_options cap="131072" platform="win-x86_64" build_version="all_axes_golden" resume="true"/>

  <!-- (g) MODUS [LIVE, wie Keimzelle]: Stufe-1 ce-only, alle 17 Slots kanonisch. -->
  <modes>
    <mode name="all_axes_golden_base" merge="Stufe1_CeOnly"
          active_axes="search_algo cache_traversal mapping path_compression node_type memory_layout allocator prefetch concurrency serialization value_handle index_organization io_dispatch migration_policy filter queuing_q1 queuing_q2"/>
  </modes>

  <static_axes from="base_tier"/>

  <key_value_signature>
    <key_types>std::uint64_t</key_types>
    <value_types>std::string</value_types>
  </key_value_signature>

  <!-- ================================================================================================
       ZUKUNFT-BLOECKE: Ziel-Sektionen der ganzen Kette, HEUTE NICHT parsbar im ThesisProfile-Kanal.
       Jeder Block nennt seinen Gap (Katalog B.1) und das Increment, das ihn scharf schaltet (Teil C).
       ================================================================================================ -->

  <!-- ZUKUNFT [Gap B1/G3 + B2 + B5/E-4; Increment INC-G1/G2/G3]: SYSTEM-ACHSEN-PERMUTATION.
       ThesisProfile hat KEIN system_axes-Feld (B1); compiler-FAMILIE, target_isa, scheduling haben
       NIRGENDS einen XML-Kanal (B2); der aktive extension_hardware-Familien-Knoten fehlt (B5/E-4).
       Syntax = Haupt-Achse, Unter-Achse, option (deckungsgleich experiment_golden.xml system_axes).
       binary_id-NEUTRAL: multipliziert NUR die BAU-Matrix (Sidecar build_version + .version), NIE N.
       Ziel-Multiplikator: 2 family x 2 opt_level x 2 simd x 2 target_isa = 16 Bau-Varianten je
       Organ-Permutation; simd ist ISA-gegated (avx2 nur x86_64), also effektiv nicht voll-kartesisch.
       Ofast bewusst NICHT (bricht IEEE-754-Determinismus, CRC64-golden). aarch64 = Build-Seite (INC-2d).

  <system_axes>
    <compiler>
      <family>
        <option value="gcc"/>
        <option value="clang"/>
      </family>
      <opt_level>
        <option value="O2"/>
        <option value="O3"/>
      </opt_level>
    </compiler>
    <extension_hardware>
      <simd>
        <option value="no_extension"/>
        <option value="avx2"/>
      </simd>
    </extension_hardware>
    <target_isa>
      <option value="x86_64"/>
      <option value="aarch64"/>
    </target_isa>
  </system_axes>
  -->

  <!-- ZUKUNFT [Gap B3 + B6; Increment INC-G4]: PHASEN / MergeStrategy fuer den PRT-ART-Join.
       Heute lebt der 3-Phasen-Kopf NUR im comdare_experiment-Kanal (experiment_golden.xml); der
       Planer-KOPF (Director/Builder-Executable) fehlt (B6). Ziel: das EINE offizielle Programm faehrt
       das Experiment-XML, das DIESES ThesisProfile als Mess-Detail-Traeger referenziert (B3-Entscheid).
       MergeStrategy-Single-Source = ce anatomy/pruefling_merge.hpp (Stufe1 DefaultList, Stufe2
       Replace-mit-Fallback, Stufe3 mp_unique-Union); op_types ebenfalls nur Experiment-Kanal.

  <phases>
    <phase name="phase2_cache_engine" merge="Stufe1_CeOnly"           engine="ee_ce"/>
    <phase name="phase1_prt_art"      merge="Stufe2_PrueflingReplace" engine="ee_prt"  pruefling="prt_art"/>
    <phase name="phase3_kombiniert"   merge="Stufe3_FullJoin"         engines="ee_ce ee_prt"/>
  </phases>
  -->

  <!-- ZUKUNFT [Gap B3; Increment INC-G4]: OUTPUT / PROVENIENZ-ZIELE.
       output-Element existiert heute nur als ExperimentOutput im Experiment-Kanal. Die Provenienz-
       Artefakte selbst (build_manifest.txt, .version- und .algos-Sidecar, result.csv.stamp) sind
       Pipeline-Artefakte und BEREITS ERLEDIGT (Katalog A.9), keine XML-Felder; das output-Element
       traegt nur die Zielpfade + comparison_metrics.

  <output>
    <binary_path>_runs/${date}/all_axes_golden/results.bin</binary_path>
    <csv_path>_runs/${date}/all_axes_golden/results.csv</csv_path>
    <latex_path>_runs/${date}/all_axes_golden/results.tex</latex_path>
    <comparison_metrics>true</comparison_metrics>
  </output>
  -->

</comdare_thesis_profile>
```

---

## B) Begruendung je Sektion + blockierender Gap

### B.1 LIVE-Sektionen (heute parsbar)

| Sektion | Variante-Wahl / warum diese Werte | Gap heute |
|---|---|---|
| base_tiers | unveraendert Keimzelle: 7 Lebewesen (prt_art + 6 SOTA), Single-Source zu sota/*.profile.xml + sota_lebewesen_names | keiner |
| permute_axes | 17 Achsen kanonisch, je GENAU 2 Werte = **erste 2 Enabled** (mp_take_c<EnabledStrategies,2>-deckungsgleich). Warum first-2: (1) mechanisch eindeutig, kein Kurations-Ermessen; (2) deckungsgleich zum lazy Referenz-Katalog FullSourceCatalog=CatalogAxes<2,...,2> (Bauplan §3-Entkopplung); (3) CRC64-Fixture bereits auf diesen Werten gelandet — Wechsel = Fixture-Invalidierung. Fork F-SPREAD s. B.2 | Parser: keiner. BAU: B12 (Materialisierung + static_assert count==N offen) |
| axis_sweeps | alle 17 (Keimzelle): Ganz-System-Coverage; vertiefte Achsen ueber eigenen Sweep-Baum (reale distinkte DLL je Auspraegung, keine Compile-Explosion) | keiner |
| sota_series_set | 21 Eintraege identisch m3v2/Keimzelle: Reihen A (Stufe1+2) + B (Stufe3); Reihe C build-uebergreifend, bewusst ohne id="C" | keiner (fairness-Attribut existiert, MESS-Abnahme #156/#162-gated) |
| working_set_sweep | {2^14,2^17,2^20,2^23} unveraendert: LLC-ueber-/unterschreitende Spreizung, vergleichbar zu golden-320-Messreihen | keiner |
| **datasets (NEU)** | url (string_corpus) + sosd_books_200M (sosd_uint64): reale Akten aus Code/test_data_xml/, deckt BEIDE DatasetLoaderRegistry-Familien ab; passend zur key_value_signature (uint64-Keys via SOSD, string-Values via Korpus). Genau 2 = minimal-vollstaendige Loader-Abdeckung ohne Lauf-Verlaengerung | Parse+Validate FERTIG (#184 hermetisch); **Loader-MESS-KonsUM offen = B4** (lauf-gated). Deklaration ist binary_id-neutral, geht in datasets_signature/Resume-Stamp |
| **measurement_categories (NEU)** | alle 16 EXPLIZIT statt leer-implizit: die golden-N-Referenz dokumentiert ihren Ganz-System-Anspruch selbst; identisches Verhalten wie leer (alle 16), also golden-neutral | Parser: **KEIN Gap** (Katalog A.3 explizit verifiziert, ThesisProfile :236-245). Downstream: B17 (BRANCH_MISS/IPC_CPI/THROUGHPUT fehlen im 16-Spalten-CSV-Record — separate Record-Erweiterung, ABI darf brechen) |
| compile_dims | YCSB A-F voll (autoritative Achse-2); telemetry on/silent (Sidecar H-10) | keiner |
| runtime_dynamic | thread_count=1 gepinnt (B11: label-only, ehrlich; Mess=1-Thread-Doktrin); hw_prefetcher 3-fach (Cluster-real MSR 0x1A4) | B11 dokumentiert gepinnt (kein Consumer; Fix A #221-Rest nur falls Multi-Thread je gewollt) |
| repetitions | 3, separat, nie interpoliert (KF-10) | keiner |
| run_options | **cap=131072 = N = 2^17** (Kern-Aenderung ggue. m3v2 cap=320); build_version=all_axes_golden trennt Sidecar/Storage-Keys von golden-320; platform-Tag = bekannte A.8-Anmerkung (kopiertes CSV-Tag, Mess-Realitaet Linux) | keiner |
| modes/static_axes/key_value_signature | Stufe-1-Basis-Modus mit allen 17 active_axes kanonisch; Rest unveraendert | keiner |

**Abweichung zur Auftrags-Aufzaehlung (begruendet):** Der Auftrag listete `workloads/datasets` und
`measurement_categories` unter den ZUKUNFT-Bloecken. Live-Verifikation (xml_config_parser.hpp :233/:245 + Katalog
A.3/A.5) zeigt: alle drei sind im ThesisProfile-Kanal HEUTE parsbar. Sie stehen darum als LIVE-Sektionen im Mock
(ehrlich gegen Code-Ist, never guess); nur ihr MESS-Konsum (datasets: B4) bzw. ihre CSV-Spalten (B17) sind gated —
das ist im Mock-Kommentar je Sektion ausgewiesen.

### B.2 Offener Fork F-SPREAD: first-2 vs. Katalog-Spread-Paare (User-Entscheid)

Katalog A.1 Spalte "All-Vary-take-2 (golden-N)" schlaegt auf **13 von 17 Achsen** andere Paare vor
(Max-Kontrast statt first-2) *(KORREKTUR 19.07., Vollstaendigkeits-Kritik: die Tabelle unten traegt 13 NEIN-
und 4 ja-Zeilen — urspruenglich stand hier faelschlich "12")*:

| Achse | Mock (first-2, Keimzelle) | Katalog A.1 (Spread) | gleich? |
|---|---|---|:-:|
| search_algo | k_ary + interpolation | k_ary + linear_scan | NEIN |
| cache_traversal | linear_fanout + hash_lookup | dito | ja |
| mapping | direct_placement + pool_relative | dito (=voll) | ja |
| path_compression | none + patricia | dito | ja |
| node_type | node4 + node16 | node4 + node256 | NEIN |
| memory_layout | cache_line_aligned + aos_strict | cache_line_aligned + packed_bitmap | NEIN |
| allocator | std_malloc + pmr_resource | std_malloc + pool_resource | NEIN |
| prefetch | none + distance_estimator | none + path_oriented | NEIN |
| concurrency | none + blocking | none + wait_free | NEIN |
| serialization | raw_binary + var_len | raw_binary + succinct | NEIN |
| value_handle | inline + external_pool | inline + chain_ref | NEIN |
| index_organization | heap + clustered | heap + index_organized_table | NEIN |
| io_dispatch | in_memory_only + direct | dito | ja |
| migration_policy | none + hot_cold | none + adaptive | NEIN |
| filter | bloom + cuckoo | bloom + range_surf | NEIN |
| queuing_q1 | no_buffer + fifo_queue | no_buffer + lockfree_mpmc | NEIN |
| queuing_q2 | eager_flush + watermark_flush | eager_flush + lazy_flush | NEIN |

Entwurfs-Entscheid im Mock: **first-2** (Keimzelle bestaetigt), weil (a) deckungsgleich zu
mp_take_c<...,2>/CatalogAxes<2,...> — der lazy Referenz-Count zaehlt exakt DIESE Menge; (b) CRC64-Fixture bereits
gelandet; (c) Spread-Paare braeuchten einen generalisierten Katalog-Mechanismus (Index-Listen-Selektion statt
take-Praefix) + Fixture-Regeneration. Der Spread-Vorschlag bleibt als dokumentierter ZUKUNFT-Kommentar im
permute_axes-Block erhalten (Semantik: Min/Max-Kontrast je Achse fuer Heuristik-Kurven,
[[feedback_axes_optimization_semantics_deep_research_observer_strategy]]). **N ist von diesem Fork unabhaengig
(2 Werte sind 2 Werte).**

### B.3 ZUKUNFT-Bloecke (heute NICHT parsbar im ThesisProfile-Kanal)

| Block | Variante-Wahl | blockierender Gap (Katalog) |
|---|---|---|
| system_axes: compiler/family = gcc+clang | die 2 real existierenden CT-CompilerAxis-Varianten (Gcc/ClangCompilerAxis) | **B2** (compiler-FAMILIE ohne jeden XML-Kanal; Legacy-v32 compiler_strategy/family ohne Nachfolger) + **B1/G3** (ThesisProfile ohne system_axes-Feld) |
| system_axes: compiler/opt_level = O2+O3 | deterministische Mess-golden-Baseline (experiment_golden.xml E1b); Ofast bricht IEEE-754 → fuer CRC64-golden gemieden; O0/O1 messen Compiler-Schwaeche, nicht Achsen-Wirkung | **B1/G3** (Kanal existiert NUR im Experiment-XML: CompilerAxisSel, hart validiert) |
| system_axes: extension_hardware/simd = no_extension+avx2 | universell auf prod1(Zen5)+prod2(i9); avx512 nicht universell; Flags→CompileFn, NIE binary_id (Q2 Option C) | **B1/G3** (Kanal) + **B5/E-4** (aktiver Familien-Knoten fehlt → CEB kann simd noch nicht real permutieren) |
| system_axes: target_isa = x86_64+aarch64 | INC-2d Variante A (Code fertig); aarch64 Build-Seite (Cross-Target), advisory arm64-Smoke #276 | **B2** (kein XML-Kanal fuer target_isa) |
| system_axes: scheduling BEWUSST WEGGELASSEN | nur 1 Code-Variante (DefaultSchedulingSystemAxis) → Permutation heute sinnlos; erst bei 2. Variante XML-wuerdig | B2 (dokumentiert, kein Mock-Block) |
| phases/MergeStrategy | exakt die 3 Phasen der Kanon-Instanz experiment_golden.xml (Stufe1/ee_ce, Stufe2/ee_prt pruefling=prt_art, Stufe3/ee_ce+ee_prt); MergeStrategy-Single-Source pruefling_merge.hpp; ThesisProfile-eigene sota_series bleiben LIVE (parsbar), der Phasen-KOPF ist Experiment-Kanal | **B3** (Kanaele nicht feature-deckungsgleich) + **B6** (Planer-Kopf fehlt: run_experiment_profile_facade/PhaseStrategyFor wiederverwenden, kein Parallel-Bau) |
| output/Provenienz | Zielpfade nach experiment_golden.xml-Muster mit all_axes_golden-Stamm; comparison_metrics=true; Provenienz-Artefakte (build_manifest, .version/.algos, result.csv.stamp) = bereits erledigte Pipeline-Artefakte (A.9), im XML NICHT dupliziert | **B3** (output nur ExperimentOutput im Experiment-Kanal) |

Randnotiz Registry-Stand: die committed Registry-XML ist selbst DRIFT (**B7**: 18 Achsen inkl. isa als T11,
index_organization als T12). Alle Mock-Werte sind gegen den Generator-HEAD-Stand (17 Achsen, Katalog A.1)
validiert; vor golden-N-Bau Registry-XML neu generieren+committen (binary_id-neutral).

---

## C) Migrations-Pfad Keimzelle → Voll-Mock (welche Increments schalten die ZUKUNFT-Bloecke scharf)

Reihenfolge folgt dem Bauplan (§4) + Planer-Bauplan 20260719 (Phase-0-Blocker B6). Jeder Schritt: erst
ultracode-Planungssession, Bau nur nach expliziter User-Freigabe je Phase; jeder Schritt weist golden-Neutralitaet
aus; alt-golden-320 bleibt TABU-Snapshot.

| Inc | Inhalt | schaltet scharf | Gap-Refs |
|---|---|---|---|
| **INC-G0** (Vorstufe, binary_id-neutral) | Registry-XML aus Generator-HEAD neu generieren+committen (17 Achsen, isa/telemetry als system_axis); prt-art-Registry Schema-Gleichstand | Wert-Validierungs-Grundlage aller Bloecke | B7 |
| **INC-G1** | `system_axes` ADDITIV in ThesisProfile-Struct+Parser+XSD (Haupt→Unter→option-Muster, deckungsgleich CompilerAxisSel/ExtensionHardwareAxisSel + harte Validierung) — ODER User-Fork: golden-N faehrt komplett ueber den Experiment-Kanal und das ThesisProfile bleibt Mess-Detail-Traeger (EIN offizielles Programm; dann entfaellt INC-G1 zugunsten INC-G4) | ZUKUNFT-Block system_axes (opt_level+simd-Teil) | B1/G3 |
| **INC-G2** | XML-Kanal fuer compiler-FAMILIE + target_isa: XSD additiv + Sel-Analoga + validate (scheduling erst bei 2. Code-Variante) | ZUKUNFT-Block system_axes (family+target_isa-Teil) | B2 |
| **INC-G3** | E-4: aktiver extension_hardware-Familien-Knoten → CEB permutiert opt×simd real; Flags→CompileFn, NIE binary_id | system_axes wird MESS-wirksam (nicht nur parsbar) | B5 |
| **INC-G4** | Planer-KOPF: Director/Builder-Executable auf run_experiment_profile(_facade) + PhaseStrategyFor (WIEDERVERWENDEN, nicht daneben bauen); Experiment-XML referenziert dieses Profil als Mess-Detail-Traeger (loest B3-Paritaet per Referenz statt Duplikation) | ZUKUNFT-Bloecke phases/MergeStrategy + output | B6, B3 |
| **INC-G5** | Dataset-Loader-MESS-Konsum (load_or_generate_ycsb-Pfad), lauf-gated im Mess-Fenster | datasets wird MESS-wirksam (LIVE-Sektion, heute parse-only) | B4 |
| **INC-G6** (der eigentliche golden-N-BAU, Bauplan §4.1-4.8) | CatalogAxes 4→17 Grad generalisieren (golden_320-Alias erhalten), `static_assert(FullSourceCatalog::Engine::count()==131072)`, gen_golden_fullpilot-Guard 320→N, `golden_fullpilot_131072_binary_ids.txt` additiv, Roundtrip-/Diff-Fixtures regenerieren, 2 Grad-Hartkodierungen (source_catalog + axis_registry_gen) synchronisieren; materialisierter Codegen-Katalog bleibt ENTKOPPELT klein (320) — Referenz-Count lazy | permute_axes 17×2 wird als golden-N-Referenz compile+test-verankert (Ganz-System-Regressions-Detektor) | B12 |
| **INC-G7** (optional, User-Fork F-SPREAD) | Spread-Paar-Umstellung (Katalog-A.1-Spalte): Katalog-Mechanismus auf Index-Listen-Selektion generalisieren + CRC64-/id-Fixture-Regeneration | alternative Wertepaare in permute_axes | B.2 (dieses Dok) |
| **INC-G8** (nachgelagert, Mess-/Auswertungs-Strang) | CSV-Record-Erweiterung BRANCH_MISS/IPC/THROUGHPUT (ABI darf brechen, Messdaten additiv) + Heuristik-Writer-Aktivierung | measurement_categories voll CSV-wirksam | B17, B18, B19 |

> **KORREKTUR zu INC-G6 (Vollstaendigkeits-Kritik 2026-07-19, code-verifiziert gegen `profile_facade/source_catalog.hpp` @HEAD):**
> Die INC-G6-Zeile ist gegen den STALE Bauplan-§4-Wortlaut (20260718) formuliert; drei Anteile sind bereits GELANDET bzw. superseded:
> (1) CatalogAxes ist BEREITS 17-parametrig (`FullSourceCatalog = CatalogAxes<2,...,2>`, Roadmap-B2 "Schritte 1/3/4 GELANDET");
> (2) der Compile-Guard EXISTIERT und lautet `static_assert(catalog_axis_product<FullSourceCatalog>() == 131072u)` (`source_catalog.hpp:155-156`) —
> die hier genannte Form `FullSourceCatalog::Engine::count()` ist dort AUSDRUECKLICH VERBOTEN (`:153-154`: "NIE FullSourceCatalog::Engine::count() / mp_product bei 2^17" = exakt das GN-2-Gegenmuster, GB-TU/ICE);
> (3) `golden_fullpilot_131072_binary_ids.txt` wird NICHT "additiv" committet — per Direktive ERSETZT durch den CRC64-Anker `kNewGolden131072Crc64 = 0xF1C1F26A1232073B` (`source_catalog.hpp:161-167`: "die Datei kommt NICHT ins git"; on-demand via `gen_golden_fullpilot <datei>`; deckungsgleich Roadmap-B2-Kopf).
> Verbleibender ECHTER INC-G6-Rest: gen_golden_fullpilot-Guard/Test-Umhaengung (NEW-GOLDEN §4.5/4.7, Roadmap GN-3), 2 Grad-Hartkodierungen-Sync (Roadmap GN-8/O-5), Roundtrip-/Diff-Fixture-Regeneration nur bei F-SPREAD (INC-G7).

Abhaengigkeiten: INC-G0 vor allem anderen (Wert-Validierung). INC-G6 ist von G1-G5 UNABHAENGIG (Referenz-Count ist
reine ThesisProfile-permute_axes-Sache) und kann direkt nach G0 laufen — der Ganz-System-Regressions-Detektor steht
dann, waehrend system_axes/phases/output die KETTE (Planer→CEB) nachziehen. Echter DLL-Messlauf N=2^17 bleibt
opt-in/gestaffelt (~409× golden-320; CI-Gruen = Messung AUS).

---

## D) N-Verifikation

- Achsen im permute_axes-Block: **17** (= kCompositionAxisNames, axis_path_serialization.hpp:34; kV3AxisCount=17).
- Fanout je Achse: **genau 2** `<value>` (keine leere Liste, keine gepinnte Achse).
- Produkt der Fanouts: 2·2·2·2·2·2·2·2·2·2·2·2·2·2·2·2·2 = **2^17 = 131.072** == `run_options cap="131072"` ==
  Bauplan-Option 1 (faithful all-vary). Zwischen 320 und 2^17 existiert keine reine All-Vary-Kartesik.
- System-Achsen (ZUKUNFT-Block) multiplizieren NUR die Bau-Matrix (Sidecar, max 16-fach, ISA-gegated), NIE N —
  binary_id bleibt exakt die 17-Organ-Kartesik.
