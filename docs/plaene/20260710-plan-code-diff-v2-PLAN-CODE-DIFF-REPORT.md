# Plan↔Code-Diff — Finaler Report

**Stand:** ce HEAD `c022ce05` (2026-07-10 16:49), working tree clean · super `probst-diplomarbeit-cache-engine` · Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`
**Methode:** 50 gegengeprüfte Befunde (status_bestaetigt/gate_bestaetigt), jeder mit datei:zeile- oder grep-Beleg. Keine Vermutungen.

---

## 1. Kurz-Bilanz — was diese Session DONE wurde

15-Commit-Range `03691aa8..c022ce05`, alle CI-grün (ctest 199/199).

| Increment | Beleg (Commit / datei:zeile) |
|---|---|
| **E4→E1-Schicht-Sequenz komplett** | Contract-Tests `test_e1/e2/e3/e4_contract_*`; E1-RC-Freeze `3ddbb0d6`: `batch_size`/`batch_visited` = `kV3AxisSchema[1][6/7]` (`observable_tier.hpp:69-70`), `budget_reject` = `[6][5]` + static_assert (`abi_adapter.hpp:1158`, Schreibpfad `:1164`) |
| **GO-1 Limits-Entkopplung (#229-Kern)** | KK-2-Guard `binary_count()==Π mp_size(Enabled_i)` im Katalog-Codegen-Pfad; #229-Kern in Ledger §12 als KOMPLETT (golden-320-Produktivpfad) |
| **NON_GATED-2 Parser-/Gating-Phase 7** | `02eba686`: `xml_config_parser.cpp:108-112` — stille `{}`-Falle → `std::cerr`-R2-Diagnose |
| **Phase-6-Vorbau (Mess-System) — Interfaces DONE** | `9ad53059`: `i_measurement_source.hpp` (186 Z.: `IMeasurementSource:72`, `WallClockSource:100`, `PmcSourceAdapter:136`, `MeasuredDelta:61` honest `valid[]`); `measurement_axis_registry.hpp` (16 Kat., `static_assert(registry_is_complete):61`); `curve_fit.hpp` Skeleton (`fit_log_linear:62`, `parse_wide_csv_column:165`) — ctest 199/199 |
| **M-Wurzel „Blut" + CMD-1-b** | `2a231cf5`: `system_axis.hpp:148` SystemAxis-CRTP + 3 Lese-Strategies (`:192/:238/:283`); `axis_command_base.hpp:30` concept `MeasurementVisitable` |
| **Datensatz-6er-Kanon** | `1f2ad991`(#25)/`029a3e71`(#45)/`4d8aedce`(#31-1b): `CanonicalDataset` 6er, `matrix_cells=mp_product 6×6=36`; verifiziert `test_25_kanon_dataset_akten.cpp:36` gegen echte CoCo-trie-Dateien; sosd_uint64-Loader |
| **#184 Loader-Verdrahtung** | `dataset_loader.hpp:106/:65` + 3 Loader registriert (sosd/string_corpus/example_uint64); `test_184_dataset_loader_wiring.cpp:44` |
| **AR-4 / #266 config-Owner aufgelöst** *(Status-Flip OPEN→DONE bei Verifikation)* | User-Gate G-Q2 = config-all (LEDGER:320); #266-P1 NICHT-vendorn evidenzbasiert (LEDGER:362, Task #11). Code bestätigt Soll-Endlage: `find libs/common -iname *config* -path *vendor*` = **0**; nur `comdare-platform`/`comdare-simd` gevendort |

**Sauber revertiert (kein Fehlbau gelandet):** `axis_binding_registry` gebaut→reviewt (wf_0f5a1d9c)→VERWORFEN (`git status` clean, 0 Live-Treffer, nur Backup); `workload_matrix` compile-time-Insel revertiert (`8c73ef7c`).

---

## 2. OFFENE Punkte nach Gate

### 🟢 NONE — baubar, sofort (kein Fork, keine Daten, keine HW)

| id | Anspruch | Code-ist | Grund |
|---|---|---|---|
| **NON_GATED-1c** | adhoc_emitter-PilotEngine aus XML-Achsenliste statt hartkodiert | `apps/adhoc_emitter/main.cpp:139` `SearchAlgorithmPermutationEngine<C0..C18>` hand-hardcoded; `:219` `emit_with<PilotEngine>`; grep XML in adhoc_emitter = 0 | Reine Configure-Time-Codegen; Werkzeug `catalog_codegen_tool` (`c10c4c70`) existiert baubar. Wertigkeit SUPERSEDED, nicht Baubarkeit |
| **DOC20-C** | Chain-of-Responsibility als Generierungs-Filter im CacheEngineBuilder | `ChainOfResponsibility/FilterChain/next_handler/handle_request` = 0 in libs/tests/tools; Bausteine da (`best_binary_selector`=Strategy+Builder, `build_orchestrator.hpp:2`), aber keiner verkettet | Umbau Auswertung→Filter→gebaut/verworfen über vorhandene Builder-Bausteine; Doc 20 gibt Vorgehen vor |
| **DOC20-D-3varianten** | Observer-Bau-Varianten (alle+Hybrid / nur Heuristik-Tier / Wall-Clock) als E4-XML-Messdimension; Messfehler=Varianten-Differenz | `observer_variant/variant_matrix/no_observer/wall_clock_only` = 0; Fundament da: `COMDARE_CE_ENABLE_STATISTICS` als globaler Dual-Build-Schalter (`CMakeLists.txt:133/137`), aber keine je-Messreihe-Matrix | Dual-Build-Fundament existiert; fehlende CEB/E4-XML-Varianten-Dimension + Diff-Rechnung baubar/fixture-testbar |
| **DOC20-D-schritt4** | Messinstrumentloser Komplementär-Neubau + Paper-Vergleich-Vorrang-Ordnung | `best_binary_selector.hpp:147 rank_binaries` = reine Einzel-Metrik-Rangbildung, KEINE Paper-First-Ordnung; `paper.?first/vorrang` = 0 | Verhalten design-fest (Doc 20 §D), kein Fork; kodieren wie best_binary_selector fixture-testbar |
| **Roadmap-Phase6-M (Struktur-Rest)** | `<measurement_categories>`-XML-Element in Parser + Pruef-Dock→POD-Verdrahtung | `<measurement_categories>` = 0 repo-weit; einziger Konsument der 3 neuen Header = `test_phase6_vorbau.cpp` | Struktur-Verdrahtung = baubarer C++ ohne HW. **Achtung:** nur die *Struktur* ist none — die *Abnahme/Befüllung* ist data (#156), s. DATA-Gruppe |

### 🔵 USER — Fork/Entscheidung (echter Autor-Entscheid, nicht baubar ohne Antwort)

**Die 7 Doc-20 §H-Forks** (blockieren die `map<>`-Ebenen des Mess-Typsystems — Ledger:430, `20_...FILTERKETTE.md:109`):

| id | Fork | Code-ist |
|---|---|---|
| **DOC20-H1** | workload-type-Kanon (3 konkurrierende Mengen) | `workload_matrix`=0 (revertiert `8c73ef7c`); unversöhnt: `WorkloadKind` 9 Keys (`workload.hpp:18`), `YcsbWorkload` 6 Keys (`workload_generator.hpp:22`), runtime A-F+IH/LH |
| **DOC20-H2** | „Beschaffenheit" eigene Map-Ebene vs. in workload-type kodiert | `beschaffenheit`=0 in libs/tests; `KeyDistribution`(`workload_config.hpp:46`) ist YCSB-Gen-Setting, keine Typsystem-Ebene |
| **DOC20-H3** | workload-size: absolute N vs. maschinenrelative Cache-Regime-Klassen | 4-Sweep {2^14,17,20,23} absolut (`profile_runner.hpp:156`, `m3v2_study.profile.xml:125`); `cache_regime/size_regime`=0 |
| **DOC20-H4** | operation_type-Kanon Runner-6 vs. XSD-6 | Runner `perm_runner.hpp:93` {insert,lookup,erase,clear,scan,rmw}; XSD `messreihe_v32_schema.xsd:76` OP-1..6 opak; kein Mapping (=0) |
| **DOC20-H5** | framework-Ebene {YCSB,LP}(2) vs. 13-Framework-Registry | nur YCSB verdrahtet (`workload.hpp:19` + `ycsb_*.xml`); `framework_registry/13-framework`=0 |
| **DOC20-H6** | Blatt `tuple<property,time>` single vs. Pareto-Front-Menge | 2 Objectives (`ScanOptimizing:141`/`LatencyOptimizing:180` GoF Strategy, Einzelauswahl); `ParetoFront/non_dominated`=0 |
| **DOC20-H7** | Sonderstatus T2/T10/T1 im tree<axis> (berührt `kV3AxisCount=19`-ABI-Verträge) | `kV3AxisCount=19` (`observable_tier.hpp:47`); T2/T10 reguläre Slots; `abi_adapter.hpp:1665` iteriert alle 19 gleichförmig; `MetaAxis/special_status`=0 |

**Weitere User-Forks:**

| id | Anspruch | Code-ist / Grund |
|---|---|---|
| **Doc-20-Typsystem (Dach)** | Messkurven-Typsystem + CoR + 3-Varianten + Binding-Registry | CoR=0 (Engine), `axis_binding_registry`=0 (revertiert); Ledger:430-431 „7 Forks blockieren map<>-Ebenen" |
| **DOC20-B / DOC20-E** | 6-fach verschachtelte Custom-Mess-DB / Typsystem↔CSV-Mapping | `tree<axis/map<framework/observer_type/tuple<property,time>`=0; existent nur flache `MeasurementCurve` (1 Achse, `curve_fit.hpp:36`) + WIDE-CSV-Vorstufe (`cache_engine_builder_iterator.hpp:188`). Struktur zuerst fork-gated (§H), Befüllung sekundär data |
| **DOC20-G KK-Klassen** | KK-1/2/3 Kardinalitäts-Klassen aus Deep-Research-Bestand | Doc-Konstrukt (`20_...md:98`) + BEFUND (71); KK-1-Anker partiell (`measurement_axis_registry`, `kV3AxisCount=19`); `KK-2/KK-3/CardinalityClass`=0. map<>-Ebenen §H-blockiert |
| **229-wdk / W-D-K-XML-Strecke** *(dedupe: EXTERN_GATED W/D/K = 229-wdk-xml)* | XML-only Experiment über Workload×Dataset×Mess-Kategorie; MessreihenSpec erweitern | `struct Messreihe` nur id/mode/sota_profile_refs (`xml_config_parser.hpp:62`); `<datasets>`=0, `measurement_categories`=0 (nur C++-Enum-Include), 0 XSD; YcsbWorkload default-hardcoded (`experiment_driver.hpp:72`). R1/R2-Fork, 10.07.-GO deckt ihn NICHT |
| **dataset-wahrheitsquelle** *(dedupe: EXTERN_GATED-test_data_sets + dossier17-B.2)* | test_data_sets.xml (Legacy-Slot) vs. 6-Kanon-Akten festlegen (R2) | `xml_config_parser.cpp:108` „R2-Entscheid steht aus", `:112 return {}`; test_data_sets.xml existiert **1×** (`builder/example_configs/`, NICHT im root_dir/Kanon); 8 Kanon-`*.test_data.xml` = 0 C++-Konsumenten |
| **Framework×Workload-Bib** *(dedupe: #31/F7 + dossier16-17-06 + c1-ce-konsumiert)* | 13-Framework-Registry + LP01-14 + Loader in comdare-workloads; ce konsumiert measurement-all zur Laufzeit | Fremdmodul `comdare-measurement-all` (HEAD ad8df1f, 07.07., unberührt): LP01-14=0, FrameworkRegistry=0, TPC/SPEC/CloudSuite=0; ce: 0 Refs auf measurement-all, `build_axis_levels` emittiert keine workload-Ebene, `tp.workloads` dead parse. Struktur-Fork A/B/C (Ledger:379) + Modul-Split-Schritt-13 |
| **V32-Altlast (ce)** *(EXTERN_GATED V32-ExecutionEngine)* | V32-execute(workload) vollenden oder tilgen | `cache_engine_execution_engine_adapter.hpp:88` toter execute(), 0 Aufrufer; `AbiV1ToV2Mapper` 0 externe Nutzer; V34.A.1 hat ihn abgelöst. Vollenden-vs-tilgen = AA.2-Architektur-Fork |
| **V32-Altlast (Treiber)** *(v32-orchestrator)* | `v32_orchestrator.hpp` vollenden (Opt.A) oder superseded markieren (Opt.B) | `Code/02_messung_driver/v32_orchestrator.hpp:81` `return 0`-Stub; nicht in main.cpp verdrahtet; `config_*.xml` ohne superseded-Marker (=0). XSD existiert, ~200-LOC-Parser fehlt |
| **CMD-2-Bump** | Mess-Visitor-Erweiterung mit ABI-Bump 4→5 | `ContainerObserver` nur reservierter Enum (`axis_observer_classification.hpp:12`, Tests erzwingen ==0); ABI-MAJOR weiter **4** (`anatomy_module_abi_v1_decl.hpp:43`) → einziger Bump-Kandidat unangetastet. Braucht explizite User-Freigabe (Ledger:85/92) |
| **#256 Modul-Extrakt** | Diplomarbeits-Impl → Matrix-Module | verbotener Name `*cacheengine-all*`=0; Extrakt-Quelle unverändert im Monolith; kein externes Matrix-Modul konsumiert. Gated #274-GO + Research/all-Split (deferred) |
| **#274 Matrix-Migration** *(TEILWEISE)* | 6 Module→funktionale Kategorien, main/master→main | GitLab-Schritte 0/2/3/5/6/7 DONE (LEDGER:326-354); offen: Skelett-Transfers T2-T9 (`modules/README.md:43` Alt-Namen als Tombstone). Rest = per-Repo-User-GO |
| **#270a P/E-Core-Auto** | CPUID-Leaf 0x1A Hybrid-Detektion als eigener Increment | 0x1A nicht aufgerufen (`cpuid_probe.hpp:76-131` nur Leaves 0/1/7/0x8000000x); `has_hybrid_cores` bewusst ungesetzt (`cpuid_platform_probe.hpp:38`); verriegelte Tests `EXPECT_FALSE` (`test_cpuid_probe.cpp:62`). HW da (prod2) → nicht infra; User-Sichtung der Test-Kontrakte nötig |

### 🟡 DATA — #156/#215-Messdaten (Code baubar/gebaut, Punkt schließt erst mit realen Daten)

| id | Anspruch | Code-ist | Grund |
|---|---|---|---|
| **Phase-6-Vorbau (Abnahme)** *(dedupe: DATEN_GATED Mess-System + phase6-mess-system-vorbau + DOC20-F)* | Paralleles Mess-System inkl. Pruef-Dock→POD + `<measurement_categories>`-XML-Abnahme | Vorbau gebaut (s. §1), aber 0 Produktions-Konsumenten; `<measurement_categories>`=0. `i_measurement_source.hpp:6` „Dock-Verdrahtung=E1-Folge"; Ledger:428 gated #156 | Struktur-Rest baubar (→NONE), Punkt-Schluss braucht #156/#215 |
| **E4'-Kurven-Fit** *(dedupe: DATEN_GATED E4′ + e4prime-kurven-fit)* | CSV→mehrdim. Kurven→Schätzer | `curve_fit.hpp` 1-dim `fit_log_linear` (`:62`, log2-LSQ), honest-empty `FitStatus::InvalidData:47`; nur test-konsumiert; Mapping „gehört in E4'-Folge" (`:11`) | `curve_fit.hpp:5` „realer Fit datengetrieben, auf #156 gated" |
| **Arbeitsmodus/Hybrid-Systemachse** *(dedupe: E4prime-Arbeitsmodus + arbeitsmodus-hybrid)* | Hot-Tier-Switching + Hybrid-Heuristik-Tier als Systemachse mit Arbeits-Dock (Diplomarbeits-ZIEL) | `arbeitsmodus/arbeits_dock/hot-switch/preload`=0; `system_axis.hpp` nur 3 LESENDE Strategies, kein Arbeits-Dock; `clustering/kmeans`=0; nur mess-getriebener Ein-Binary-Load (`cache_engine_builder_iterator.hpp:680`) | Downstream E4'; optimiert auf gemessenen Kurven (#156/#215) |
| **Pareto-Objectives** | Benannte GoF-Strategy-Familie (Throughput/Footprint/TailLatency…) + Persist-Objective am Profil | `ThroughputOptimizing/…`=0; nur Scan+Latency; `ThesisProfile` ohne Objective-Feld | Objective wählt entlang GEMESSENER Front → ohne #156 nur erfindbar (verboten) |
| **Roadmap-Phase8 / #215/#156-Konsumenten** *(dedupe: Roadmap-Phase8 + Danach-#156-#162)* | 320-DLL-Voll-Messlauf-Ergebnis → A/B/C-CSV → Thesis-Tabellen | Code+Tooling DONE (`csv_to_latex.hpp:64`, `diagram_generator.hpp:151`, `generate_wide_appendix.ps1`); neue Spalten im Schema (`abi_adapter.hpp:1092/1158`); **fehlend:** CSVs mit neuen Headern (`grep budget_reject *.csv`=0, neueste Mess-CSV 2026-07-05, pre-#215) | Reine Datenabwesenheit |

### 🟠 INFRA — Cluster/HW (prod2-Hang, node7-Freeze, Toolchain)

| id | Anspruch | Code-ist | Grund |
|---|---|---|---|
| **AR-7 / #270b arm64-Grün** | 3-ISA-Matrix arm64 Grün-Beweis | `.gitlab-ci.yml:116` `build:arm64-smoke` instanziiert, `allow_failure:true`, rules-gated `COMDARE_ISA_MATRIX`; grün-Evidenz=0 | Braucht physischen node7-rpi5-arm64-Runner (Freeze, Task #23) |
| **#264 CI-5** *(TEILWEISE)* | Per-Runner-Tag -j/RAM-Politik | CI-2/CI-4/allow_failure-raus+TSan DONE (`CMakeLists.txt:1483 comdare_tests`, `.gitlab-ci.yml:374/136/390` KEIN allow_failure via #278); nur globales `CMAKE_BUILD_PARALLEL_LEVEL=6` | Braucht prod2-Node-Fix + RAM-Stabilitäts-Beleg auf echter HW |
| **#273 T2** *(TEILWEISE)* | gcc-15.3-Pin im Haupt-Template | T1 `.toolchain-probe` + T3 `build:clang` (clang-22.1.8) DONE (`base-pipeline.yml:784/801`, ce `:72`, prt-art); T2 fehlt — Template bevorzugt gcc-13, PIN-GAP-Warnung (`:796`) | gcc-15.3 auf Runnern NICHT installiert (HO-11); prod1 nur g++-13/16 |
| **#276 Multi-Plattform** | 3-ISA-Teilmatrix als HARTE CI-Pflicht (ausdrücklich LETZTE Aufgabe) | `build:arm64-smoke` advisory/opt-in, keine `parallel:matrix` scharf; Kommentar `:111` „HARTE Scharfschaltung ist #276" | amd64/intel-baremetal (prod2) deaktiviert (Node-Hang); arm64=node7. Braucht stabil-grüne ISA-HW |

### 🔴 HELD — Mehrfach-Blocker / Vorbedingungs-Kette

| id | Anspruch | Code-ist | Grund |
|---|---|---|---|
| **DOC20-I tree-axis-Wurzel** *(TEILWEISE)* | compile/dynamic-Achsen-Wurzel; standalone consteval-Registry VERWORFEN | `is_static` Single-Source DONE (`profile_to_tree.hpp:65-87`, pre-Session); compile-time-enumerierbare Organ-Wurzel HELD | Mehrfach-Blocker: 7 Forks (Doc 20 §H) + echter Konsument + Producer-Contract; nicht greenfield (Ledger:431) |
| **215-156-Voll-Messlauf** *(Producer)* | 320-DLL-Neubau (#215) → Voll-Messlauf (#156/#162) mit E1-Schema-Spalten | Code-Schema DONE (`observable_tier.hpp:69`, `abi_adapter.hpp:1158`); ABI weiter MAJOR **4** (der 4→5-Bump/#215 fand NICHT statt); kein DLL-Bestand nach `3ddbb0d6`, keine CSV mit neuen Headern | Ganze Vorbedingungs-Kette: 4→5-Bump + AP-2/#236-Hart-Gate + mehrtägiges User-Fenster + MinIO-Fix + prod2-I/O #207 |

---

## 3. Deduplizierung (Überlappungen der 5 Cluster)

Die 50 Befunde verdichten sich auf **~24 distinkte offene Themen**:

- **Phase-6 Mess-System** — 3 Befunde (DATEN_GATED-Mess-System / phase6-mess-system-vorbau / Roadmap-Phase6-M) = **1 Thema**, gespalten: Interface-Vorbau DONE, Struktur-Rest NONE, Abnahme DATA.
- **E4'-Kurven-Fit** — 3 Befunde (DATEN_GATED-E4′ / e4prime-kurven-fit / E4prime-Arbeitsmodus) → Skeleton-Teil = **1**, Arbeitsmodus/Hybrid separat (data).
- **Doc-20-Typsystem** — 4 Befunde (Dach / DOC20-B / DOC20-E / DOC20-I) = **1 Struktur-Thema** + die 7 §H-Forks als dessen Blocker; CoR (§C) und 3-Varianten (§D) sind separat NONE-baubar.
- **Framework×Workload-Bib** — 4 Befunde (EXTERN Framework×Workload / #31-F7 / dossier16-17-06 / c1-ce-konsumiert) = **1 Thema** (13-Registry in measurement-all, user-Fork A/B/C).
- **W/D/K-XML + Dataset-Wahrheitsquelle** — 5 Befunde (EXTERN-W/D/K / 229-wdk / EXTERN-test_data_sets / dataset-wahrheitsquelle / DOC20-F) = **2 Themen**: XML-Strecke (user, R1/R2) + measurement_categories-Abnahme (data). AR-6/DD-D (Loader-Verdrahtung) hängen daran.
- **#215/#156-Voll-Messlauf** — 3 Befunde (Roadmap-Phase8 / Danach-#156-#162 / 215-156-Voll-Messlauf) = **1 Thema**: Producer=held, Konsumenten=data.
- **V32-Altlast** — 2 distinkte Orte (ce-Adapter + Treiber-Orchestrator), beide user.
- **Modul-Migration** — #256 (ce-Extrakt) + #274 (Repo-Fleet), verwandt, beide user.
- **Pareto** — pareto-objectives-heuristik (data) ⊂ DOC20-H6 (user-Fork). Der Fork ist der bindende Erst-Blocker; die derive()-Kurven danach data.

Korrigierte STALE-Behauptungen aus dem alten BACKLOG: `test_data_sets.xml` existiert **1×** (nicht 0×, `builder/example_configs/`); der stille `{}`-Slot ist seit Phase 7 diagnostiziert; „6-Kanon" sind faktisch 8 Dateien; AR-4/#266 ist DONE (nicht offen).

---

## 4. Die EINE empfohlene nächste Aktion

**Es gibt einen non-gated baubaren Rest — aber der Löwenanteil (~20 der 24 Themen) ist transitiv user-fork-gated, angeführt von den 7 Doc-20-§H-Forks.**

**Empfehlung (kritischer Pfad):** Die **7 §H-Forks als EIN Entscheidungs-Batch dem User vorlegen.** Sie blockieren das gesamte Mess-Typsystem (DOC20-B/E/I, KK-Klassen), die W/D/K-XML-Strecke (R1/R2), die Framework-Bib (A/B/C) und die Dataset-Wahrheitsquelle — nichts davon ist ohne diese Entscheidungen sauber baubar (das „no-quick-fixes"- und „nie erfinden"-Prinzip verbietet autonomes Raten der Kardinalitäten).

**Falls ein baubarer Increment PARALLEL gewünscht ist**, ist der einzige non-gated, fork-unabhängige, nicht-spekulative Kandidat die **Doc-20-§C+§D-Hybrid-Strecke**: Chain-of-Responsibility-Generierungsfilter (§C) + 3-Varianten-Observer-Matrix (§D) als E4-XML-Messdimension. Begründung: (a) Gate=none code-verifiziert, (b) Verhalten in Doc 20 §C/§D design-fest (kein Fork), (c) Fundament vorhanden (`build_orchestrator`, `COMDARE_CE_ENABLE_STATISTICS`-Dual-Build), (d) fixture-testbar ohne #156-Daten und ohne Cluster-HW, (e) liefert die „Messfehler-Erkennung durch Messinstanzen" — einen echten Thesis-Beitrag — ohne den user-gated Typsystem-Baum vorwegzunehmen.

Kleinere Alternative: `NON_GATED-1c` (adhoc_emitter XML-Ableitung) — trivial baubar, aber Wertigkeit SUPERSEDED (Pilot-Pfad, nicht Produktivpfad).

**Alles Übrige wartet:** DATA auf den #215→#156-Cluster-Lauf (mehrtägig, nie aktiv pollen), INFRA auf prod2-Node-Fix/node7-arm64/gcc-15.3, USER auf die Fork-Batch-Antwort.