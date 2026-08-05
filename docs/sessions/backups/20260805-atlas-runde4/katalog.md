# LENS achsen-arten-vollkatalog — Vollstaendiger Achsen-Arten-Katalog fuer die Atlas-Runde-4-Klammer-Sektion (READ-ONLY-Erhebung)

Datum: 2026-08-05 · Auftrag: Owner mittag-5 (Klammer fehlt) + mittag-8 (beide Freigabe-Richtungen) — LEDGER:4094-4098 / :4089 / :4092.
Quellen-Kuerzel: LEDGER = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (Zeile) · ce = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine`.

WICHTIGE VORAB-KORREKTUR: Die mittag-8-Lesart ist durch **mittag-9 (LEDGER:4076-4081)** und **mittag-10 (LEDGER:4083-4087)** praezisiert/korrigiert worden — die Klammer-Sektion MUSS die korrigierte Stufen-Doktrin zeigen, nicht die rohe mittag-8-Form (Abschnitt 5).

---

## 1. Die Trichotomie (die drei Klammern) — kanonische Definition

**LEDGER:89 (V7.2, Owner-verbindlich):** "Drei Achsen-TYPEN, je eigene Stufe: **Mess → Planer** · **System → CEB** (steuert nur Kompilation, System, Scheduling der Binary-Basics; die alte 'System steuert die Mess-Auspraegung'-Relation ist OBSOLET) · **Organ → Tier** (binary_id Organ-only, §54-T3)."

**LEDGER:2262 (§30):** "die DREI Achsen-Art-Registries speisen exakt die drei Binary-Stufen — **Mess-Registry→Planer · System-Registry→CEB · Organ-Registry(+prt)→Tier**."

**LEDGER:2257 (§30 Punkt 4):** EIN Gesamtbaum, Nodes je Achsen-Art GEFAERBT und filterbar; "Faerbungs-Traeger existiert: `AxisKind{organ, system_measurement, system_config}`, `topics/axis.hpp:17-20`". Die drei XML-Registries tragen exakt diese Kinds als `axis_kind`-Attribut (belegt in beiden Mess-/System-XMLs, s.u.).

**Drei-Registry-Gesetz (LEDGER:2225, §28, User-Direktive verbatim-treu):** "Bezueglich der Achsen-Registries traegt **immer eine Haupt-Achse (statisch im Ziel-Binary) auch optionale Unter-Achsen-Einstellungen (meist dynamisch im Ziel-Binary)**. **Jede der 3 Achsen-Arten braucht ihre EIGENE Registry in IHREM Modul per XML**, um die Funktionalitaeten im Compile anbieten zu koennen."

Die drei realen Registry-XMLs (alle generiert, "NICHT von Hand editieren"):
1. Organ: `ce/libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml` (+ Pruefling: `.../comdare-prt-art/prt_art/algorithm_profiles/prt_art_axis_registry.xml`)
2. System: `ce/libs/cache_engine/include/cache_engine/measurement/system_axis_registry.xml`
3. Mess: `ce/libs/cache_engine/include/cache_engine/measurement/measurement_axis_registry.xml`

---

## 2. ORGAN-Achsen (Klammer 3, Tier-Ebene) — 18 Haupt-Achsen + Unter-Achsen-Lage

### 2.1 Die 18 Haupt-Achsen (kanonisch; real registriert, `cache_engine_axis_registry.xml:9-127`)

Registry-Kopf: `engine="cache_engine" schema="1"`; "GENERIERT von tools/axis_registry_gen (INC-A) per compile-time-Reflektion der Enabled*/StaticAxisVariants*-Listen"; "Baustein-Zahlen = ENABLED-Inventar dieser Build-Konfiguration ..., NICHT die All*-Registry-Zahlen" (XML:2-5). Alle 18 mit `category="composition" genus="SearchAlgorithm"`.

| Slot | axis id | Bausteine (enabled) | davon golden_wired |
|---|---|---|---|
| T00 | search_algo | 4 (k_ary, interpolation, eytzinger, linear_scan) | 4 |
| T01 | cache_traversal | 3 (linear_fanout, hash_lookup, binary_search_fanout) | 1 |
| T02 | mapping | 2 (direct_placement, pool_relative) | 1 |
| T03 | path_compression | 3 (none, patricia, byte_wise) | 1 |
| T04 | node_type | 4 (node4/16/48/256, ObservableNodeType) | 4 |
| T05 | memory_layout | 5 (cache_line_aligned, aos_strict, soa, packed_bitmap, aosoa) | 5 |
| T06 | allocator | 3 (std_malloc, pmr_resource, pool_resource) | 1 |
| T07 | prefetch | 4 (none, distance_estimator, hardware, path_oriented) | 4 |
| T08 | concurrency | 9 (none, blocking, reader_writer, olc_optimistic, lock_free, wait_free, rcu, hazard_ptr, olc_reserved_blocks) | 1 |
| T09 | serialization | 4 (raw_binary, var_len, succinct, compressed) | 1 |
| T10 | value_handle | 5 (inline, external_pool, immutable_shared_ref, versioned_pointer, chain_ref) | 1 |
| T11 | index_organization | 4 (heap, clustered, non_clustered, index_organized_table) | 1 |
| T12 | io_dispatch | 4 (in_memory_only, direct, buffered, mmap) | 1 |
| T13 | migration_policy | 4 (none, hot_cold, tier_based, adaptive) | 1 |
| T14 | filter | 4 (bloom, cuckoo, range_surf, xor) | 1 |
| T15 | queuing_q1 | 15 (no_buffer ... original_concurrentqueue) | 1 |
| T16 | queuing_q2 | 5 (eager, watermark, lazy, timed, adaptive_lsm) | 1 |
| T17 | persistence_target | 1 (memory_only) | 1 |
| **Summe** | **18 Achsen** | **83 Bausteine** | **31** |

Kanon-Bestaetigung: LEDGER:86 (V7.1) "**18 Organ-Achsen** (T0–T17, T17 = `persistence_target`, binary_id Organ-only)". (Historisch: "19 SA-Achsen T0–T18" mit telemetry/isa als Organ-Slots = ce docs/architecture/34 §8 — SUPERSEDED durch die STRUKT-R-Welle; telemetry ist heute zweigeteilt, s. §69.3, isa ist Codegen-Traeger unter TargetIsa.)

### 2.2 Organ-UNTER-Achsen: wo sie real leben

**Antwort auf die Auftrags-Frage "wie viele Unter-Achsen je Haupt-Achse real registriert?": in `cache_engine_axis_registry.xml` sind NULL `<sub_axis>`-Elemente registriert** — die Organ-Registry manifestiert ausschliesslich Haupt-Achsen + Bausteine (Algorithmus-Auspraegungen). Die Organ-Unter-Achsen leben an zwei anderen Orten:

1. **Als Code (CT-Anker):** 23 eindeutige `*_subaxes_*.hpp`-Header unter `ce/libs/cache_engine/axes/` + `topics/` mit **~75 benannten Sub-Achsen** (Suffix-Zaehlung der Header): sa1-sa3, ct1-ct2, mp1-mp2, pc1-pc3, nt1-nt3, hm1-hm4, aa1-aa7, pf1-pf3, cc1-cc2, sr1-sr3, vh1-vh3, io1-io3 (index_org), io1-io3 (io_dispatch), mg1-mg3, ft1-ft3, pt1-pt2, qs1-qs6 (q1), fs1-fs4 (q2) + die Build-/Dual-Achsen pg1-pg3 (page_type), se1-se3 (simd_extension 09b), is1-is3 (isa), hw1-hw4 (general_hardware), tm1-tm3 (telemetry). Beispiel-Pfad: `ce/libs/cache_engine/axes/alloc/axis_06_allocator_subaxes_aa1_to_aa7.hpp`.
2. **Als dynamische Laufzeit-Dimensionen (RT):** die RC-POD-DynamicDims der MESS-Registry (`measurement_axis_registry.xml:52-56`): `thread_count`, `prefetch_distance`, `pool_budget_bytes`, `batch_size`, `inline_threshold_bytes` (`source="resource_control_pod"`, `stage="runtime"`) — das ist die §28-Form "Unter-Achsen-Einstellungen = meist dynamisch im Ziel-Binary (RC-POD/DynamicDims/Runtime-Werte)" (LEDGER:2227).

### 2.3 Die "~279" — wo dokumentiert (Auftrags-Frage)

- `docs/architektur/16_E1_E4_KONSOLIDIERUNG_DOSSIER.md:30` (super): Ebenen-Tabelle "| **4 Sub-Achse** | Organ-Bestandteil | **~279** | — |".
- `docs/architektur/TIER-AUFLOESUNG-AUDIT-UND-MAPPING-PLAN.md:114/146/163` (super): "Sub-Achse = Organ-Bestandteil ... **~57–279**"; "**~279 Organ-Bestandteile** (Goldstandard `axis_06_allocator`: 7 Tags + 6 Concepts + 25 Wrapper)"; "Achse = Organ (19) · Sub-Achse = Organ-Bestandteil (~279)".
- **ABER — pruefender Kanon:** `docs/architektur/20260717-achsen-nachschlagewerk-ACHSEN-NACHSCHLAGEWERK.md:340` Falle (K): "**Richtwert '~279 Sub-Achsen' nicht belegt.** Weder 127 Strategien noch 94 Observer-Felder noch 164 Organ-Auspraegungen treffen ihn — vermutlich dimensionsuebergreifende Gesamtschaetzung (System+Mess+Organ+Gattung+Build). Hier nur die belegten Zahlen gefuehrt." (Status GEPRUEFT-UNVERAENDERT im INC2D-DELTA-NACHTRAG:152.)
- NB: die Auftrags-Angabe "laut CE/34" trifft nicht — ce `docs/architecture/34_KONSOLIDIERTER_MASTER_IST_STAND.md` enthaelt die Zahl 279 NICHT (grep-verifiziert); Quelle ist das E1-E4-Dossier (architektur/16) bzw. der TIER-AUFLOESUNGs-Plan.
- **Empfehlung fuer die Klammer-Sektion:** belegte Zahlen zeigen (18 Haupt / 83 enabled Bausteine / 23 subaxes-Header mit ~75 benannten Sub-Achsen / 5 RC-POD-DynDims), "~279" nur als unbelegten historischen Richtwert mit (K)-Vermerk fuehren.

### 2.4 Pruefling-Beitrag (Organ-Registry 2)

`prt_art_axis_registry.xml` (engine="prt_art", gleiches Schema): 5 Achsen-Slots mit je 1 Baustein — 4x `category="pruefling_slot"` (page_type/prtart_bplus_page, prefetch/prtart_redirect_prefetch, telemetry/prtart_per_node_counter, value_handle/prtart_chain_ref_handle, alle golden_wired=false) + 1x `category="golden_merge_slot"` (path_compression/path_compression_patricia, golden_wired=true). Join-Modi: MergeStrategy `Stufe1_CeOnly`/`Stufe2_PrueflingReplace`/`Stufe3_FullJoin` (LEDGER:2254, §30 Punkt 1); System-/Mess-Achsen-Join deprioritisiert nach hinten (LEDGER:2255/2266).

---

## 3. SYSTEM-Achsen (Klammer 2, CEB-Ebene) — GENAU DREI Glieder + Komplex-Wrapper

### 3.1 Kanon (Ledger V7.2)

**LEDGER:90:** "**System-Haupt-Achsen = die Glieder der EINEN Komplex-Haupt-Achse:** `target_isa`, `operating_system` (NEU), `external_utils` (Rename von extension_hardware). **`external_utils` = HUB/Kopf aller Meta-Meta-Achsen** ... `compiler` ist KEINE Haupt-Achse, sondern die untrennbare Unter-Achsen-GRUPPE `compiler+opt_level+atomic128`; `scheduling` ist Unter-Achse von `target_isa`. Meta-Metas sind volle CT-Haupt-Achsen-TYPEN mit eigenen RT-Unter-Achsen (variadisches Array, KEIN `std::variant`), Identitaet nur AUFWAERTS kompatibel ab Basis CPU-only."
- **LEDGER:91 (§69.1/R-G):** `load_framework` = **META-META-HAUPT-ACHSE der MESS-ACHSEN (Planer-Stufe)** — NICHT mehr unterm external_utils-Hub; der Hub traegt NUR System-Meta-Metas (SIMD/AVX, externe HW). Original-Ruling LEDGER:3556 (§69.1, Owner verbatim).
- **LEDGER:3558 (§69.2, Owner verbatim):** target_isa = KOMPLEX-ACHSE IN SICH — feste statische Glieder RAM-Frequenz + CAS + CPU-Fabrikation; die Unter-System-Achsen scheduling/numa_node/page haengen am target_isa-Komplex-Wrapper.
- **LEDGER:3560 (§69.3):** telemetry ZWEIGETEILT — runtime-Unter-Achse im Mess-Tooling UND Haupt-System-Achse (Dual-Natur-Register).
- **LEDGER:93:** "**opt permutiert O0/O1/O2/O3 × simd {no_extension, avx2, avx512} = 12 System-Perms**; avx512 nur wo die Maschine es freigibt (prod1_zen5 ja, prod2 fused-off → Skip+WARNUNG, §62-A) ... System-Config binary_id="never" → alles im Suffix/Sidecar, golden-neutral."
- Historische Stufen (fuer die Klammer als superseded kennzeichnen): "6/7 CEB-System-Achsen + Unter-Achsen opt_level/Flags/Commands/simd/march/target" (LEDGER:2227, §28 v. 19.07.) und die "SECHS CEB-System-Achsen" inkl. Q2-Erweiterungshardware als 6. Systemachse (Memory `feedback_q2_option_c_erweiterungshardware_sechste_systemachse.md`; Owner-GO 17.07.) — **beide per LEDGER:2229-Vermerk auf die DREI Glieder konsolidiert**; die Q2-Substanz (CEB permutiert simd selbst; Flags an der CompileFn-Naht, NIE binary_id) lebt als simd-Meta-Meta unter external_utils fort. §68-Hinweis LEDGER:3355: RAM-Frequenz+CAS / CPU-Fabrikation (#49, LEDGER:3354) sind KEINE neuen Haupt-Glieder, sondern per §69.2 feste Glieder der target_isa-Komplex-Identitaet.
- Compiler-Dynamik-Kanon: Memory `project_compiler_systemachse_traegt_dynamische_xml_unterachsen.md` (User-Ruling 17.07. + OF-1/2/3): Compiler-Achse = TRAEGERIN paralleler dynamischer XML-Unterachsen (`opt_level` voll {O0..Ofast}, `flags`/`cflags`, `commands`, SIMD/AVX-Fold-in); "in einem dynamischen XML-System existiert 'global' NICHT". (Ofast inzwischen AUS fuer Messlaeufe, LEDGER:93 — IEEE-754/CRC-Determinismus.)

### 3.2 Real registriert (`system_axis_registry.xml`, 202 Zeilen, generator="system_axis_registry_gen" PAKET W2-B)

Kopf-Doktrin (XML:5-9): "Haupt-Achse=CT-statisch (stage=ct, in die CEB/Tier-Binary einkompiliert); Unter-Achse=dynamisch (stage=runtime, vom Planer permutiert). Q2/K2: opt_level/simd/atomic128 materialisieren als CompileFn-Flags (build_version-Suffix), NIE als Laufzeit-Typ-Switch und NIE in der binary_id." — "AUSSCHLUSS: extension_hardware_system_axis.hpp = DEPRECATED-Insel; hardware_isa_system_axis.hpp = HOST-Deskriptor (treibt NICHT den Bau)."

**3 Haupt-Achsen** (alle `category="system_config" axis_kind="system_config" binary_id="never" stage="ct"`) **+ 1 Komplex-Wrapper**, zusammen **11 registrierte `<sub_axis>`-Elemente**:

| Haupt-Achse | Bausteine (CT) | registrierte Unter-Achsen |
|---|---|---|
| `target_isa` (XML:10-40) | 2: x86_64, aarch64 (cross: `-target aarch64-linux-gnu -march=armv8-a`) | 4: `target_isa_complex` (ct, fixed_enum_tuple; 2 complexes prod1_zen5/prod2_raptor_lake mit je 3 sub_dims ram_frequency_mhz/cas_latency_cl/cpu_fabrication — die §69.2-Glieder!) · `scheduling` (ct; 5 sub_dims: worker_pool_layout, simd_worker_count_limit, hetero_core_dispatch, co_routine_strategy, batch_granularity) · `numa_node` (runtime, machine_resolved) · `page` (runtime, machine_resolved) |
| `operating_system` (XML:41-48) | 3: linux, windows, macos | 3: `os_version` · `kernel` · `build` (alle runtime, machine_resolved) |
| `external_utils` (XML:49-93) | 1: simd (SimdExternalUtilsFamily, family_id="simd") | 1: `simd` (runtime; 3 Optionen no_extension/avx2/avx512 mit je gpp/clang/msvc-Flags) + `simd_feature_catalog` count=23 (avx512f...popcnt, je Compiler-Flag + Tier avx512/avx256/companion/scalar) |
| `build_target_complex` (`system_complex_axis`, XML:94-153) | member_count=3 (target_isa, operating_system, external_utils) — "Command-Pattern-Wrapper der Rekombination der DREI Haupt-Achsen (O-1r). Er ist KEINE vierte Haupt-Achse: kSystemAxisOrder bleibt bei dreien. load_framework ist KEIN Glied (es lebt seit A3 im Mess-Realm)" (XML:95-97) | `sub_axis_group build_toolchain` (sub_axis_count=3): `compiler` (ct; 2 Bausteine gcc/g++-16, clang/clang++-22) und daran haengend `opt_level` (runtime; 5 Optionen O0/O1/O2/O3/Ofast, Ofast `ieee754_deterministic="false"`) + `atomic128` (runtime; no_cx16/cx16) — "compiler + opt_level + atomic128 haengen HIER und nicht an target_isa: die Gruppe beschreibt den BAU aus der Rekombination aller drei Achsen (O-1r)" (XML:102-105) |

Zusatz: `machine_signatures count=3` (prod1_zen5 22 Flags inkl. avx512-Familie; prod2_raptor_lake 9; odroid_gracemont 9) = die maschinenseitige Freigabe-Grundlage (avx512-Skip prod2, LEDGER:93).

---

## 4. MESS-Achsen (Klammer 1, Planer-Ebene) — Tooling=Haupt, Rest=Unter

### 4.1 Kanon

- **LEDGER:2227 (§28):** Mess-Registry "im Mess-Modul — 16 Kategorien, Kollektoren, DynamicDims, Workload-Achse".
- **LEDGER:2231 (§54-T2/§47-Nachtrag A10, PRAEZISIERT §28):** "**HAUPT-Achse = Mess-Tooling {nur Wallclock · Makro-Benchmarks · Micro-Benchmarks ueber die Observer}** (statisch/CT, je Wahl eine eigene CEB-Strecke `ceb:build:[a,b,c]`, Stempel §43); **UNTER-Achsen (Planer-gesteuert, delegiert) = Ablaufmethodik {Debug/Messen/Release} · Workloads/Datasets · die 16 measurement_categories · Rueckschrieb-Methoden** — sie manifestieren sich als CSV-Spalten, sind aber ein echtes Registry-Angebot, keine passiven Spalten." Die "16 Kategorien, Kollektoren, DynamicDims, Workload-Achse" gehoeren in die UNTER-Ebene; Auffaecherungs-HAUPT-Achse ist das Tooling.
- **§64 (LEDGER:3377-3400), die 3 Verfahren + Vereinigungs-Default:** "STEHT DAZU NICHTS IN DER XML: alle 3 Verfahren in der CEB GEMEINSAM abgebildet per METAPROGRAMMIERUNG, und das PRUEF-DOCK nimmt alle 3 Features vom Tier-Binary GEMISCHT ab" (:3381); Tooling-Auspraegung einer CEB = MENGE {wallclock, macro, micro}, Default = Vollmenge, EINE CEB (:3383; Vorwaerts-Zeiger LEDGER:2498/3079). **Schichten-Zuordnung (:3397-3399):** Wallclock = CEB-Seite; Makro+Micro = CEB UND Tier-Binary einkompiliert ueber das PRUEFDOCK (beidseitig: CEB traegt Prueftools, Tier die Observer).
- Mess-Achsen = "Blut": stehen NIE in der binary_id (XML:5-6 "binary_id=never; Werte = CSV-Spalten/setting_label"); Wurzel-Kanon Memory `feedback_system_axes_measurement_own_abstract_root_blood`.
- `load_framework` = Meta-Meta-HAUPT-Achse der Mess-Achsen (§69.1, LEDGER:3556); Owner verbatim: "load_framework wird rein den Mess-Achsen-Typen als weitere Meta-Meta-Hauptachse zugeordnet."

### 4.2 Real registriert (`measurement_axis_registry.xml`, 62 Zeilen, generator="measurement_axis_registry_gen" PAKET W2-B)

| Achse | Inhalt |
|---|---|
| `measurement_category` (ct, axis_kind="system_measurement", binary_id="never") | **16 Bausteine:** CLU, CACHE_MISS_L1/L2/L3, DTLB_MISS, MEMORY_FOOTPRINT, BRANCH_MISS, IPC_CPI, LATENCY_MEAN/P50/P95/P99/P999, THROUGHPUT, ENERGY_J, FILL_BUFFER_OCCUPANCY — je `regime_ordinal` 0=TimeObserver / 1=PmcCounter |
| `collector` (ct) | **3 Bausteine (Kollektoren):** WallClockSystemAxis (→ LATENCY_MEAN, THROUGHPUT) · ObserverSnapshotSystemAxis (→ CLU) · PmcSystemAxis (→ CACHE_MISS_L1/L2/L3, DTLB_MISS, BRANCH_MISS, IPC_CPI, ENERGY_J) |
| `load_framework` (ct, `category="measurement_meta_meta"`) | 1 Baustein: **ycsb**, `sub_axis_label="workload"` — "Angebots-Eigner ist seit dem K1-Umzug (O-8 Schritt 4) die load_framework-Achse DIESER Registry, nicht mehr die System-Registry" (XML:47-49) |
| `dynamic_dims` (resource_control_version=1) | **6 Dims (runtime):** `workload` (source=measurement:load_framework) + 5 RC-POD-Dims `thread_count`, `prefetch_distance`, `pool_budget_bytes`, `batch_size`, `inline_threshold_bytes` (source=resource_control_pod; setting_label axis.var=value) |

Ehrliche Luecken (XML:57-60, TODO W2-B): `repetition` = reine setting_label-DynDim OHNE CT-Anker → nicht emittiert; die **3 Mess-Modi Debug/Mess/Release existieren NICHT als Typen** (§32-F1/F7) → erst nach Typisierung als Mess-Unter-Achse reflektierbar. → Die Klammer-Sektion sollte Ablaufmethodik {Debug/Messen/Release} als KANON-Unter-Achse zeigen, mit Ist-Vermerk "im Registry-XML noch nicht typisiert".

---

## 5. FREIGABE-RICHTUNGEN (mittag-8-Praezisierung) + KORREKTUR mittag-9/10 — exakte Fundstellen

### 5.1 Stufe M (Mess → CEB-Mess-Design → Compile-Durchsetzung in Tiers + Pruefdock-Konfig)

- **Owner verbatim (mittag-8, LEDGER:4089):** "Ja, aber die Mess-Achsen geben auch CEB Mess-design frei und die CEB setzt das bei compile durch, auch gegen die Tier-Binaries IN den Tier-Binaries und sich selbst in der Konfiguration des Pruefdocks, die info fehlte, das ist auch praezise im Plan"
- **Lesart (LEDGER:4092):** "(Stufe M) MESS-Achsen [Planer] GEBEN das CEB-MESS-DESIGN FREI → die CEB SETZT es beim COMPILE DURCH: (a) IN den Tier-Binaries (Mess-Ausstattung/Observer der Tiers) und (b) IN SICH SELBST via Konfiguration des PRUEFDOCKS (einkompilierte Prueftools der CEB bestimmen die Pflicht-Ausstattung des Tier-Binaries — Tooling-Konsistenz §62-B; Kompile-Reihenfolge 'System-Konfiguration → Mess-Achsen-heuristische-Konfiguration' 17.07.; CEB VORHER auf Gattungs-Observer+Module kompiliert)."
- **Tooling-Konsistenz-Beleg (LEDGER:3400, §64-AUSRICHTUNGS-MECHANIK):** "Die CEB richtet die Mess-Einrichtung ihres Tier-Binary-Prueflings aufgrund IHRER statischen compile-time Mess-Achsen-Ausrichtung (die der PLANER-Mess-Achse folgt) AUCH AUF DEM TIER-BINARY aus — indem dort macro- und micro-Benchmarks FUER DIE OBSERVER einkompiliert werden. [= die konkrete Gestalt der Tooling-Konsistenz CEB↔Tier aus **§62-B** ...; die Kette Planer-Mess-Achse → CEB-Mess-Ausrichtung → Tier-Observer-Einkompilierung ist EIN durchgereichter statischer Draht (§24-Ketten-Statik); die gemischte Pruef-Dock-Abnahme nimmt dann wallclock (CEB-Schicht) + macro/micro (Tier-Observer-Schicht) in einem Rutsch ab.]"
- **Kompile-Reihenfolge 17.07. (Original-Quelle):** super `docs/ledger-sections/20260717-voll-konsolidierung-LEDGER-SECTION-18.md:23`: "Die CEB wird UNTER ihren System-Achsen gebaut; das bestimmt, wie die Tier-Binaries untergeordnet ebenfalls STATISCH gebaut werden. Kompile-Reihenfolge: die CEB kann verschiedene Gattungen bauen+durchmessen, muss aber VORHER auf deren Observer+Module kompiliert werden — **System-Konfiguration → Mess-Achsen-heuristische-Konfiguration**."
- §62-B-Tooling-Konsistenz-Kontext (Planer→CEB-Vertrag): W2-Stempel-Wirkung + W3-Pruefdock-Testate (LEDGER:4092 Konsequenz; W-Spezifikationen LEDGER:4056).

### 5.2 Stufe S (System → HW-Freigabe → Organ-Durchsetzung, G7-Gate)

- **§37 (LEDGER:2340-2352):** Freigabe-Prinzip GENERALISIERT — ALLE System-Achsen koppeln gegen Organ-Achsen; SIMD = Pilot; Dual-Aufnahme + **State-Pattern-Freischaltung** durchs Pruef-Dock (:2350/2352: "die CEB versetzt die Freigabe-System-Organ-Achse ueber das Pruef-Dock in den freigeschalteten Zustand; die Organ-Repraesentation permutiert dann bis zur freigegebenen Maximal-Faehigkeitsstufe").
- **§37.b (LEDGER:2354-2358):** "die CEB bestimmt zur Laufzeit aus ihren System-Achsen-Freigaben, was gebaut werden darf, und delegiert eine Kompilation der Organ-Achsen" — Zulaessigkeits-Filter an der CEB-Bau-Delegations-Naht (provision_all/CompileFn).
- **G7-Gate:** LEDGER:2332 (§36 Punkt 4: "Audit-G7-constexpr-Gate wird damit Bau-relevant") · LEDGER:2338 (W4-B-Emitter-Kopplung: "SIMD-Organ-Varianten nur in Zellen bauen, deren System-simd-Freigabe sie erlaubt ... G7-Gate wird Bau-Gate") · LEDGER:2862 (Task-Form: "Organ ≤ Zulassung ... G7-constexpr-Gate wird Bau-Gate") · LEDGER:4070 (mittag-7-FREIGABE-HIERARCHIE, konsolidiert).
- Grundsatz-Memory: `feedback_systemachsen_freigabe_organachsen_durchsetzung_ressourcen.md` (User-Ruling 18.07.): "System-Achsen = Freigabe der Existenz zu testender Hardware-Eigenschaften; Organ-Achsen = Durchsetzung ... **Organ-Nutzung <= System-Freigabe**."
- Voll-Erhebung mit allen Ebenen (Achsen/Cluster/Batch/Thread): `docs/sessions/backups/20260805-ressourcen-freigabe-explore/freigabe.md` (+ `rufkette.md`).

### 5.3 KORREKTUR mittag-9 (LEDGER:4076-4081) — MUSS die Klammer-Darstellung praegen

Owner verbatim (:4078): "Die Mess-Achsen sind DREISTUFIG Symmetrisch, die Sytem-Achsen sind ZWEISTUFIG symmetrisch und die Organ-Achsen sind ZWEISTUFIG symmetrisch, wobei die erste stufe immer Runtime Freigabe und die nachfolgenden Stufen compile time Einbau sind Planer->CEB-TierBinaries ..."
Kanonische Form (:4079): **MESS = DREISTUFIG** (1 Planer: RT-Freigabe → 2 CEB: CT-Einbau [Mess-Design inkl. Pruefdock-Konfiguration] → 3 Tier: CT-Einbau [Mess-Ausstattung/Observer]) · **SYSTEM = ZWEISTUFIG** (1 CEB: RT-Freigabe [HW-Ressourcen] → 2 Tier: CT-Einbau) · **ORGAN = ZWEISTUFIG** (1 CEB: RT-Freigabe [lazy Permutations-Wahl] → 2 Tier: CT-Einbau). GESETZ: erste Stufe IMMER Runtime-Freigabe, alle Folgestufen Compile-Time-EINBAU entlang Planer→CEB→Tier.

### 5.4 PRAEZISIERUNG mittag-10 (LEDGER:4083-4087) — Hybrid-Einschub

Kanonische GESAMT-Form (:4086): **MESS:** Planer(RT) → CEB(CT) → [Hybrid(CT)] → Tier(CT) — DEHNBAR. **SYSTEM:** CEB(RT) → [Hybrid(CT): gibt sich SELBST und seinen Tier-Binaries die System-Achsen-Config per Compile-Time mit] → Tier(CT) — DEHNBAR exakt wie Mess. **ORGAN:** NUR in den Tier-Binaries VERBAUT; beruehren die Hybriden NICHT direkt — **Hybride sind ein Factory-Pattern-Facade-ADAPTER** (organ-frei, delegieren per Command an die echten Organ-tragenden Tiers). Hybrid-Vererbungs-Gesetz (:4080): Hybride als 4. Stufe ERBEN ALLE Eigenschaften vorausgegangener Stufen. Stempel-Konsequenz (:4087c): Hybrid traegt Mess- UND System-Stempel-Zeilen, KEINE Organ-Permutations-Identitaet (binary_id bleibt Organ-only bei echten Tiers).

---

## 6. Haupt=CT / Unter=RT — die Klammer-Semantik (stufen-relativ)

- **§28 (LEDGER:2225/2227):** "immer eine Haupt-Achse (statisch im Ziel-Binary) auch optionale Unter-Achsen-Einstellungen (meist dynamisch im Ziel-Binary)"; "Haupt-Achse = CT-statisch einkompiliert (binary_id bei Organ; build_version/Sidecar bei System); ihre Unter-Achsen-Einstellungen = meist dynamisch im Ziel-Binary (RC-POD/DynamicDims/Runtime-Werte)".
- **Memory `feedback_haupt_achse_static_unter_achse_runtime_chain_ct_wiring.md` (User-Direktive 18.07., §24):** Haupt-Achsen = i.d.R. statisch/CT fest verdrahtet, Unter-Achsen = i.d.R. Runtime-Eigenschaften — **ABER stufen-relativ:** "die dynamischen (Runtime-)Einstellungen der VORHERGEHENDEN Stufe sind oft die zu uebernehmenden compile-time-Draehte der gebauten NACHFOLGENDEN Stufe" (Kette Planer→CEB→Tier; jede Stufe friert die dynamischen Entscheidungen der Vorstufe zu eigenen Compile-Konstanten ein; kein std::variant in der erzeugten Binary).
- **Dual-Natur-Register (LEDGER:92, V7.2/§24-C):** zweigeteilte Achsen (RT-Unter an der Vorstufe + CT-Haupt an der Folgestufe): Mess-Tooling/`load_framework` (Planer→CEB) · `compiler`-Gruppe (CEB→Tier) · NUMA/locking + page_type (CEB unter ISA → Tier) · SIMD/AVX (external_utils gibt frei → Tier) · telemetry (§69.3). CT-Haupt am Tier = einkompiliert+gestempelt (System-Array), NICHT binary_id → golden-neutral.
- OD-5 VOLLES GO (LEDGER:3562): "Unter-Achsen-Freigabe der Vorstufe = Haupt-Achsen-Annahme der Folgestufe, Planer→CEB→Tier."
- Bindende Achsen-SORTIERUNG fuer jede Darstellung (LEDGER:3546, §68a): "**Mess-Tooling (measurement_category = Unter-Achse) → `target_isa` → `operating_system` → `external_utils` → Organ T00–T17**; innerhalb jeder Ebene: Haupt-Blatt → Mess-Unter → System-Unter → Organ-Unter." (Ordnungs-Single-Source `kSystemAxisOrder`, ce `abi/system_axis_order.hpp`.)

---

## 7. Kompakte Klammer-Vorlage fuer den Atlas (Ergebnis-Synthese)

```
KLAMMER 1 — MESS-ACHSEN (Planer-Stufe; AxisKind system_measurement; "Blut", nie binary_id)
  HAUPT (CT): measurement_tooling {wallclock | macro | micro}   [Default: alle 3 VEREINT in EINER CEB, §64]
    UNTER (RT, Planer-delegiert): Ablaufmethodik {Debug/Messen/Release}* · Workloads/Datasets ·
      16 measurement_categories · Rueckschrieb-Methoden · DynamicDims (workload + 5 RC-POD)
  HAUPT (CT, Meta-Meta): load_framework {ycsb} → UNTER (RT): workload           [§69.1: Mess-Realm]
  (Kollektoren-Angebot: WallClock/ObserverSnapshot/Pmc → Kategorien-Zuordnung)
  Stufen: Planer(RT-Freigabe) → CEB(CT: Mess-Design + PRUEFDOCK-KonFIG) → [Hybrid(CT)] → Tier(CT: Observer)

KLAMMER 2 — SYSTEM-ACHSEN (CEB-Stufe; AxisKind system_config; binary_id=never, Suffix/Sidecar, golden-neutral)
  EINE Komplex-Haupt-Achse (build_target_complex, Command-Pattern) mit GENAU DREI Gliedern:
  HAUPT (CT): target_isa {x86_64, aarch64}  [selbst Komplex: RAM-Freq+CAS+CPU-Fabrikation, §69.2]
    UNTER: scheduling(CT,5 Dims) · numa_node(RT) · page(RT)
  HAUPT (CT): operating_system {linux, windows, macos} → UNTER (RT): os_version · kernel · build
  HAUPT (CT): external_utils = HUB der System-Meta-Metas {simd-Familie} → UNTER (RT): simd {no_extension, avx2, avx512}
  UNTER-GRUPPE (untrennbar, am Komplex): compiler {gcc, clang} → opt_level {O0..O3(,Ofast aus)} · atomic128 {no_cx16, cx16}
  12 System-Perms = opt(4) x simd(3); avx512 nur bei Maschinen-Freigabe
  Stufen: CEB(RT-Freigabe HW) → [Hybrid(CT): reicht System-Config an sich+Tiers weiter] → Tier(CT)

KLAMMER 3 — ORGAN-ACHSEN (Tier-Stufe; AxisKind organ; binary_id Organ-only)
  18 HAUPT-Achsen T00-T17 (CT, je 1 Baustein einkompiliert): search_algo · cache_traversal · mapping ·
  path_compression · node_type · memory_layout · allocator · prefetch · concurrency · serialization ·
  value_handle · index_organization · io_dispatch · migration_policy · filter · queuing_q1 · queuing_q2 ·
  persistence_target  (83 enabled Bausteine; Pruefling +5 Slots via prt_art-Registry, 3 Join-Modi)
    UNTER: benannte Sub-Achsen im Code (23 subaxes-Header, ~75; z.B. aa1-aa7 am Allokator) +
    RT-Durchreich-Dims via RC-POD (thread_count, prefetch_distance, pool_budget_bytes, batch_size, inline_threshold_bytes)
  Stufen: CEB(RT-Freigabe lazy Permutations-Wahl, Organ <= System-Freigabe, G7-Bau-Gate) → Tier(CT)
  Hybride werden von Organ-Achsen NICHT beruehrt (Factory-Facade-Adapter, organ-frei)

BEIDE FREIGABE-RICHTUNGEN (Pfeile ueber den Klammern):
  Stufe M: Mess[Planer] ─Freigabe→ CEB-Mess-Design ─CT-Durchsetzung→ (a) IN Tier-Binaries (Observer)
           + (b) CEB selbst (Pruefdock-Konfig)  [§62-B-Tooling-Konsistenz; Reihenfolge System→Mess 17.07.]
  Stufe S: System[CEB] ─HW-Freigabe→ Organ setzt durch (Organ <= Freigabe; G7-constexpr = Bau-Gate;
           State-Pattern-Freischaltung durchs Pruef-Dock)
* Ablaufmethodik/repetition: Kanon-Unter-Achsen, im Registry-XML noch ohne CT-Anker (W2-B-TODO, ehrlich vermerken)
```

Anbindungs-Regel fuer die losen UML-Knoten (Owner-Hinweis B): jede Organ-Klasse mindestens ueber ihre ACHSEN-Zugehoerigkeit anbinden (subgraph je Haupt-Achse, Kante Klasse→Achsen-Anker), Mess-/System-Traeger analog — mechanisch aus den drei Registry-XMLs ableitbar (axis id → Baustein-wrapper/type).
