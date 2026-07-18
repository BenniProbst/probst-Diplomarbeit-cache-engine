# Voll-Review-Bericht Diplomarbeit — konsolidiert

**Stand:** 2026-07-12
**Scope:** 4 Repos (probst-diplomarbeit-cache-engine / super, comdare-cache-engine / ce, comdare-prt-art / prt-art, thesis/diplomarbeit)
**Methodik:** Zeile-für-Zeile-Review je Partition durch dedizierte Reviewer, jedes Finding adversarial gegen den Code gegengeprüft (`why`-Feld = wörtliche Code-/Grep-Verifikation). Nur bestätigte (`CONFIRMED`) Findings sind hier aufgeführt. Es wurde **kein Finding erfunden** — der Bericht ist eine reine Aggregation der Reviewer-Daten.
**TABU-Kontext** (golden-320-IDs, `permutation_axes.xml`, POD-`sizeof`==1416, ABI-MAJOR 4) wurde von allen Reviewern bewusst nicht angetastet und ist nicht Gegenstand von Findings.

---

## 1. Executive Summary

**368 bestätigte Findings** über 4 Repos. Kein Finding trägt die Schwere `critical`; die höchste vergebene Schwere ist `major` (40 Findings). Der Gesamtbefund: das System ist **messfähig und im Kern grün** — die Findings sind Härtungs-/Korrektheits-Kanten, keine Neubau-Anlässe. Dominierend ist **Doku-Drift** (114) — Kommentare/READMEs/Zählungen, die dem Code-Ist hinterherhängen — gefolgt von punktuellen **Correctness**-Kanten (100), toter Vorleistung (**dead-code** 66) und **Aufräum-Artefakten** (cleanup 43).

### Findings je Schwere

| Schwere | Anzahl |
|---|---:|
| critical | 0 |
| major | 40 |
| medium | 7 |
| minor | 260 |
| low | 2 |
| info | 59 |
| **Summe** | **368** |

### Findings je Kategorie

| Kategorie | Anzahl | Anteil |
|---|---:|---:|
| doc-drift | 114 | 31 % |
| correctness | 100 | 27 % |
| dead-code | 66 | 18 % |
| cleanup (Artefakte) | 44 | 12 % |
| test-gap | 26 | 7 % |
| architecture | 18 | 5 % |
| **Summe** | **368** | 100 % |

### Findings je Repo (grob, nach Pfad-Zuordnung)

| Repo | Schwerpunkt der Findings |
|---|---|
| comdare-cache-engine (ce) | Kern der Findings-Masse: Achsen, Anatomy/ABI-Adapter, Builder/experiment_tree, profile_facade, CMake-Codegen, tests/unit-Registrierung, PAPER_REFERENCES-Drift, ce-eigenes `.gitlab-ci.yml` |
| probst-diplomarbeit-cache-engine (super) | Pipeline-Stufen `Code/01`–`Code/09`, `Code/CMakeLists.txt`, super-`.gitlab-ci.yml` (Orchestrierung/Persist), `experiment_config/`, `test_data_xml/`, `docs/architektur/` |
| comdare-prt-art | Suchstrukturen/OLC/Density, Permutations-Codegen, prt-art-CI, prt-art-Doku |
| thesis/diplomarbeit | Aufgabenstellung DE/EN-Divergenz, Kapitel-/Anhang-Zahlen-Drift, Alt-Struktur-Koexistenz, `format_tex.py` |

### Reviewer / Coverage (Kurzform, Detail in §6)

Reviewer arbeiteten partitionsweise. Coverage-Nachweis für die Achsen-/Builder-Partitionen liegt vollständig vor (jede Zeile gelesen); die restlichen Bereiche (anatomy, include/, profile_facade, common, tools, apps, cmake, tests, CI, super-Pipeline, prt-art, thesis, docs) sind durch die Findings selbst belegt. Die im Auftrag übergebene COVERAGE-Liste ist am 6. Reviewer abgeschnitten und wird in §6 so wiedergegeben, wie sie vorliegt.

---

## 2. CRITICAL + MAJOR Findings je Repo

Es existiert **keine** `critical`-Schwere. Nachfolgend die **40 `major`-Findings**, gruppiert nach Repo. Format: `datei:zeile` — Summary — Evidence — empfohlener Fix.

### 2.1 comdare-cache-engine (28 major)

**M-CE-01 — `libs/cache_engine/axes/alloc/axis_06_allocator_scalloc.hpp:167` (correctness)**
`ScallocAllocator::reallocate` repliziert die alignment-Weiche von allocate/deallocate nicht: bei `enabled=true` und `alignment > alignof(max_align_t)` stammt `p` aus `portable_aligned_alloc`, wird aber an `::scalloc_realloc` übergeben → Fremd-Heap-Pointer, Heap-Korruption.
*Evidence:* allocate Z.82–91 / deallocate Z.109–117 branchen; reallocate Z.169–171 ruft bedingungslos `::scalloc_realloc(p, …); (void)align`.
*Fix:* In `reallocate` denselben alignment-Branch spiegeln (großes Alignment → `portable_aligned_alloc` + manueller Copy/Free), oder reallocate für den aligned-Pfad verbieten.

**M-CE-02 — `libs/cache_engine/axes/alloc/PAPER_REFERENCES.md:51` (doc-drift)**
`CrystallineAllocator` (A17) fehlt komplett in §2-Tabelle UND in der autoritativen Map (docs/architecture/18), obwohl §3 „alle 25 Wrapper haben Referenz oder Baseline" behauptet; Code-Attribution „Solodkyy/Bunkov PLDI 2021" ist unverifiziert (bekannt: Nikolaev/Ravindran 2021).
*Evidence:* Registry führt CrystallineAllocator (registry:92, „26 Vendor KOMPLETT"); PAPER_REFERENCES §2 hat 25 Zeilen; grep `crystalline|A17` in Doc 18 = 0.
*Fix:* Zeile in §2-Tabelle + Map §4 ergänzen, Attribution gegen Primärquelle korrigieren (deprecaten, nicht löschen).

**M-CE-03 — `libs/cache_engine/axes/cache_traversal/axis_03b_cache_traversal_hash_lookup.hpp:150` (correctness)**
`HashLookup::unregister` löscht per `buckets_[pos].reset()` ohne Tombstone/Backward-Shift → Probe-Kette zerbricht (Knuth 6.4 Algorithm R fehlt): Keys hinter dem gelöschten Slot werden als Miss gemeldet; Re-Insert erzeugt Duplikate. HashLookup ist ausgeliefert (`compositions/wormhole_reference.hpp:44`).
*Evidence:* unregister reset() vs. resolve stoppt am ersten leeren Bucket (Z.94/119/148).
*Fix:* Tombstone-Marker oder Backward-Shift-Deletion (Algorithm R) implementieren.

**M-CE-04 — `libs/cache_engine/axes/filter_axis/axis_filter_cuckoo.hpp:67` (correctness)**
`CuckooFilter::insert_key` überschreibt bei zwei vollen Kandidaten-Buckets sticky `table_[i1*kSlotsPerBucket]` → verdrängt Fingerprint eines früheren Keys → **echte False Negatives**, verletzt die Filter-Gattungs-Garantie (may-contain). Kommentar „Membership-Erhalt" gilt nur für den NEUEN Key. `test_filter_real_from_keys` deckt es nicht ab.
*Evidence:* Overwrite Z.67; XorFilter (Z.44) deklariert dieselbe Schwäche ehrlich als „mögliche FN".
*Fix:* Eviction-Kette (Fan CoNEXT 2014 §3) implementieren oder Property/Doku ehrlich als „kann FN" markieren.

**M-CE-05 — `libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:617` (test-gap)**
`lazy_try_resume_binary` + der #139-Resume-Block (Z.727–734) entscheiden über Überspringen von Messungen / Übernahme alter CSV-Zeilen — repo-weit **kein einziger Test** (0 Treffer in `tests/`). Fehler verliert still Messzeilen oder übernimmt stale Daten.
*Evidence:* grep `lazy_try_resume_binary` nur Def Z.617 + Aufruf Z.729; 0 tests/.
*Fix:* Resume-Roundtrip-Test (Stamp-Match, Skip-Entscheidung, Zeilen-Übernahme) registrieren.

**M-CE-06 — `libs/cache_engine/anatomy/abi_adapter.hpp:390` (correctness)**
`run_workload/_segmented/_v2` prüfen `alloc.allocate()` nie auf `nullptr` — Alloc-Achsen liefern bei Fehlschlag nullptr (kein throw), der folgende Fill-Write ist UB/SIGSEGV und wird vom `catch(...)` NICHT gefangen; bricht den `noexcept`-Vertrag „interne Störung → Rückgabe 0".
*Evidence:* Z.390/478/602 lbuf-Fill ohne Check; Churn-Loops Z.413/495/694; z.B. numalloc liefert nullptr bei OOM.
*Fix:* nullptr-Check nach jeder allocate() → sauberer 0-Return statt Write.

**M-CE-07 — `libs/cache_engine/anatomy/abi_adapter.hpp:250` (correctness / Anti-Phantom)**
`tier_apply_resource_control` zählt `prefetch_distance` und `pool_budget_bytes` statisch als „real angewandt" (`counts=true`), obwohl der konsumierende Hook nur konditional existiert: `set_runtime_distance` gibt es nur für `prefetch_family_v==1`; `ObservableComposedContainer` hat kein `set_runtime_pool_budget`. Host bekommt `applied>0` für Achsen, die den Wert ignorierten. Zudem `tier_query_resource_caps` meldet hart `controllable_axis_count=5`.
*Evidence:* apply1(..., counts=true) Z.251–252 vs. konditionaler Setter Z.259–263.
*Fix:* `counts` an `requires{…}`-Detektion koppeln; caps je Komposition berechnen (0 = nicht steuerbar).

**M-CE-08 — `libs/cache_engine/include/cache_engine/platform_probe/cpuid_probe.hpp:103` (correctness)**
AVX/AVX2/AVX-512 werden direkt aus CPUID übernommen ohne OSXSAVE-Bit (ECX[27]) + XGETBV/XCR0-Prüfung und ohne Max-Leaf-Check vor Leaf 7 → `usable_simd_width_bytes` kann 64 melden, wo das OS keinen ZMM-State aktiviert → **SIGILL** bei Dispatch.
*Evidence:* Z.103/123/126 rein aus Bits; kein `leaf1.ecx[27]`/xgetbv, kein Vergleich gegen `leaf0.eax`.
*Fix:* OSXSAVE+XGETBV(XCR0)-Kette und Max-Leaf-Guard ergänzen.

**M-CE-09 — `libs/cache_engine/topics/queuing/axis_q1_queuing/axis_q1_queuing_lockfree_mpmc.hpp:58` (test-gap)**
9 von 15 Q1-Strategien + 2 von 5 Q2-Policies haben keinen verhaltensspezifischen Test; insbesondere existiert für die beiden als thread-safe deklarierten Lock-Free-Queues **kein einziger nebenläufiger Test**. version_id()-Monotonie, bulk_insert, Epoch-Advance, Drop-on-Full, set_iterable_aspect ungetestet.
*Evidence:* grep tests/ = je 0 Testdateien für DeltaChain/Skiplist/Tombstone/CoW/Epoch/BatchedInsert/SPSC/MPMC/OriginalCQ.
*Fix:* Verhaltens- + Concurrency-Tests (TSan) je Strategie nachziehen.

**M-CE-10 — `libs/cache_engine/profile_facade/sota_catalog.hpp:159` (correctness / Anti-Phantom)**
`Stufe2_PrueflingReplace` ignoriert das `lebewesen`-Argument: jede St2-Reihe materialisiert dieselbe `HotPrtStufe2ReplaceComposition` (identische `binary_id`) → 7 Pässe auf EINEM Binary schreiben dieselben Messzeilen 7× in EINE CSV; `res.sota_binary_ids` zählt 21 statt real 14; `h2_score_for` hängt den H2-Score des FALSCHEN Lebewesens an. „21 SOTA-DLLs" real = 20 Pässe / 14 distinkte DLLs.
*Evidence:* Z.157–163 `binary_id` aus reihe+Composition::name ohne lebewesen.
*Fix:* `lebewesen` in Typ/binary_id einbeziehen (oder St2 konzeptionell als 1 Binary dokumentieren + Zähler/H2-Attribution korrigieren).

**M-CE-11 — `libs/cache_engine/algorithm_profiles/thesis_profiles/ff2_node_width_study.profile.xml:48` (correctness)**
Legacy-`<workloads>`-Tokens `A B C D E F` matchen keine Lastprofil-id (`ycsb_a`..`ycsb_f`) → E4-Lauf bricht in der Fassade hart mit `exit 4` ab („0 gültige Lastprofile"). Gleiches Muster in `fb_numa_page_study.xml:60`, `cacheline_study.xml:75` (+ tote `m3v2_smoke:65`, `m3v2_sota_pilot:74`). Die Kanonisierung 2026-07-12 zog Achsen nach, nicht die Workload-ids.
*Evidence:* `profile_run_facade.cpp:117–141` exakter `std::find` gegen `ycsb_*`-ids; 0 Treffer → exit 4.
*Fix:* Tokens auf `ycsb_a`… umstellen (wie `m3_smoke/m3_golden_coverage`).

**M-CE-12 — `libs/cache_engine/profile_facade/validate_profile.hpp:102` (test-gap)**
`validate_profile` prüft `<workloads>` gar nicht gegen existierende Lastprofil-ids — exakt die „stille Fehlerklasse", die das Validat sichtbar machen soll; ff2/fb/cacheline passieren `--validate` mit OK und brechen erst im teuren Lauf mit exit 4 ab. Der in `SCHEMA.md:73` benannte `test_validate_profile.cpp` existiert nicht mehr; Negativ-Pfade ungetestet.
*Evidence:* kein `workloads`-Vorkommen in der Prüf-Logik Z.102–268.
*Fix:* `<workloads>`-Check gegen discover-ids ergänzen + Negativ-Tests.

**M-CE-13 — `libs/cache_engine/reclamation/rcu_reclaim/rcu.hpp:66` (correctness)**
Kein Nesting-Zähler: Destruktor eines inneren `RcuReadGuard` setzt `active=false` für den GANZEN Thread, während der äußere Guard noch im kritischen Abschnitt ist → Writer kann Grace-Period vorzeitig beenden (UAF). Test prüft nur Nicht-Crash.
*Evidence:* read_unlock() `active.store(false)` ohne Zähler; McKenney-RCU nestet.
*Fix:* Per-Thread-Nesting-Counter; `active=false` erst bei Counter==0.

**M-CE-14 — `libs/cache_engine/reclamation/rcu_reclaim/rcu.hpp:61` (correctness)**
Store-Load-Race: `read_lock` lädt `global_epoch` VOR dem `active`-Store (nur `release`, kein `seq_cst`/Fence). Writer kann Reader als inaktiv übersehen, während dieser mit alter Epoch den alten Pointer liest → `flush()` gibt frei (auch auf x86 möglich).
*Evidence:* zwei release-Stores, kein Full-Fence; synchronize `fetch_add(acq_rel)` + Scan.
*Fix:* `seq_cst` bzw. `atomic_thread_fence(seq_cst)` zwischen active-Store und geschützter Load.

**M-CE-15 — `libs/cache_engine/compositions/wormhole_paper_binding_reference.hpp:39` (correctness / Methodik)**
`WormholePaperBindingComposition` trägt `cache_traversal=LinearFanout`, während `WormholeComposition` `HashLookup` trägt — verletzt die dokumentierte Invariante „PaperBinding identisch zur Re-Impl AUSSER search_algo" und macht den PB↔Re-Impl-Vergleich zweivariablig (methodischer Messfehler). Einzige der 5 PaperBindings mit dieser Abweichung.
*Evidence:* PB Z.39 LinearFanout vs. Re-Impl `wormhole_reference.hpp:44` HashLookup; art/hot/start/surf stimmen je überein.
*Fix:* `cache_traversal` im PB auf HashLookup angleichen.

**M-CE-16 — `libs/common/platform/vendor/comdare-simd/include/comdare/simd/SIMDOps.hpp:180` (correctness)**
`avx2::add_u64` liest im Carry-Pass nicht-initialisierte `result[j]` des Tails (UB) und verliert den Carry des vektorisierten Präfix in die Tail-Limbs → empirisch `r[4]=12` statt 13. avx512-/neon-Varianten haben den korrekten else-Zweig; nur AVX2 ist kaputt.
*Evidence:* Loop 2 iteriert `j` über full `count`, liest bei `j>=i` uninit; Repro g++ -mavx2.
*Fix:* Guard `if(j<i)` bzw. korrekte Carry-Propagation wie in der avx512/neon-Fassung.

**M-CE-17 — `libs/common/measurement/hdr_histogram_wrapper/vendor/hdr_histogram.c:41` (doc-drift / Doktrin)**
Vendored `hdr_histogram.c` ist NICHT das als „ORIGINAL/byte-treu/is_original/offiziell" deklarierte Upstream — es enthält comdare-Modifikationen (AVX2-**Runtime**-Dispatch, Prefetch-/Likely-Makros), die Upstream nicht hat → Provenienz-Behauptung falsch + Runtime-ISA-Switch gegen die compile-time-ISA-Doktrin (im Auswertepfad `hdr_value_at_percentile`).
*Evidence:* `HDR_HAS_AVX2_DISPATCH 1` (Z.41), `__attribute__((target("avx2")))` (Z.724ff), `__builtin_cpu_supports("avx2")` (Z.765).
*Fix:* Provenienz ehrlich als „modifiziert" deklarieren + Runtime-Dispatch entfernen/compile-time gaten.

**M-CE-18 — `tools/latex_anhang/main.cpp:78` (correctness)**
`latex_anhang` parst ein veraltetes 15-Spalten-CSV ohne `workload_used` → gegen JEDEN aktuellen `measurements.csv` (16 Spalten seit V20.3) kaputt: `cols[3]` ist heute `workload_used`-String, `stoull` wirft, Tool endet immer mit `status_parse_error=11`.
*Evidence:* Guard `cols.size() < 15`, `stoull(cols[3])`; alle Produzenten schreiben 16-Spalten-Schema (`result_aggregator.cpp:63`).
*Fix:* Parser auf 16-Spalten-Schema (mit `workload_used`) umstellen.

**M-CE-19 — `apps/f15_compare/main.cpp:454` (architecture / Anti-Phantom)**
Pfad-A `--pipeline-csv` schreibt erfundene `bytes_allocated`/`bytes_in_use_peak` als `ops*64`-Schätzung in Mess-Spalten (statt honest-0), während die Erfolgsmeldung „reale Mess-Zahlen" behauptet.
*Evidence:* Z.454 `bytes = ops*64ULL // Schätzung (PMC-frei)` → Z.456–457; PMU-Spalten im selben Pfad korrekt honest-0.
*Fix:* Bytes-Felder honest-0/n/a setzen, Erfolgsmeldung entschärfen.

**M-CE-20 — `tools/latex_toolchain/build_thesis.bat:15` (correctness)**
Windows-Frontend ignoriert die dokumentierte unquotierte Aufrufform still: cmd tokenisiert `=` als Trenner, kein `--key=`-Branch matcht, kein Unknown-Arg-Fehler (anders als `.sh`), Build läuft stumm mit Default-Pfaden.
*Evidence:* `if "!ARG:~0,9!"=="--source="` scheitert bei `--source=path` (cmd liefert `%1=--source`); `.sh` wirft dagegen Unknown-arg.
*Fix:* cmd-Argparsing an `.sh` angleichen (Wert nach `=` explizit einlesen / Fehler bei Unknown).

**M-CE-21 — `ext/CMakeLists.txt:121` (correctness)**
snmalloc-Detection prüft `ext/A07-snmalloc` statt `ext/allocator/A07-snmalloc` → `COMDARE_HAVE_SNMALLOC` bleibt IMMER OFF, obwohl der header-only-Code vollständig vorliegt; A07 degradiert still auf std-Fallback (exakt die V41.A1-Bugklasse #19 für mimalloc).
*Evidence:* Z.121/122 falscher `_sn_root`; `ext/A07-snmalloc` existiert nicht, `ext/allocator/A07-snmalloc/src/snmalloc/snmalloc.h` existiert.
*Fix:* Pfad auf `ext/allocator/A07-snmalloc` korrigieren.

**M-CE-22 — `tests/unit/test_obs_phaseA.cpp:13` (test-gap)**
6 git-getrackte Standalone-Verifikationstests (test_obs_phaseA, _phaseB_t11_t12, _iso, _t14_t16, test_pathb_segment_timer, test_segment_timer_differentiation) sind in KEINEM CMake-Target/`add_test` und ihr dokumentierter Build-Weg (`scratch_compile-*.ps1`) wurde gelöscht → ihre Prüfungen laufen nie.
*Evidence:* je 0 Treffer in `tests/unit/CMakeLists.txt`; keine GLOB-Discovery.
*Fix:* Als reguläre ctest-Targets registrieren oder mit GO entfernen (Behelfsweg-Doktrin).

**M-CE-23 — `tests/unit/thesis_tiere/README.md:5` (doc-drift)** und **`…README.md:3`**
README dokumentiert als Reproduktionsweg committete PowerShell-Skripte + Treiberquellen (`run_lazy_150.cpp`, `tier150_axis_grid.cpp`, `test_validate_profile`, `measure_adapter_tiere.cpp`, `gen_golden_fullpilot.cpp` …), die seit der Behelfsweg-Bereinigung (2026-07-11) nicht mehr existieren, und behauptet, Verzeichnis-Tests seien „bewusst NICHT via CMake/ctest" gebaut — obwohl 9 von 11 inzwischen reguläre CMake-Targets sind.
*Evidence:* `find *.ps1` = 0; `test_profile_roundtrip`/`test_axis_sweep_pilot` sind CMake-Targets (`CMakeLists.txt:2986/2989`).
*Fix:* README auf CMake/ctest-Ist umschreiben (deprecaten, nicht löschen).

**M-CE-24 — `tests/unit/CMakeLists.txt:1` (test-gap)**
38 git-getrackte Test-Quellen in `tests/unit/` sind in KEINEM CMakeLists/ctest registriert (0 Build-Konsumenten): br4_emit/br4_load, kf16_e2e_real_build, test_all19_segment_timer, test_br1..3, test_kf1..16b, test_m8_storetrav_segment, test_obs_phase*, test_pathb/segment_timer u.a. Nur `test_d4b_*` ist als Ausnahme dokumentiert.
*Evidence:* Abgleich jedes Stamms gegen CMakeLists (inkl. foreach-Listen) = 0; grep findet nur Docs-Erwähnungen.
*Fix:* Systematisch registrieren (ggf. label-gegatet) oder mit GO entfernen; Liste siehe §4.

**M-CE-25 — `.gitlab-ci.yml:385` (test-gap)** *(ce-CI)*
19 registrierte ctest-Tests sind CI-tot: Label `contract`/`pmc`, `test:unit` läuft mit `-LE 'contract|pmc'`, KEIN dedizierter Job matcht sie per `ctest -R`. Betroffen u.a. `test_s7_1..10` (alle 10 Pool-Alloc-DEG-Gates), `test_ap15_2/3`, `test_234_va/vb`, `test_29_container_framework`, `test_smoke_coverage_profile`, `test_wdk_datasets_fairness`, `test_h2_score_akte`, `m3v2_pmc_smoke`.
*Evidence:* `-LE contract|pmc` (Z.385); dedizierte `-R`-Regexe matchen keinen der 19.
*Fix:* Dedizierte Jobs mit `-R`-Liste oder Label-Neuvergabe; CI-Kommentar korrigieren.

**M-CE-26 — `tests/unit/test_parser_konsolidierung.cpp:35` (correctness)**
Registrierter CI-Test schreibt fünf FIXE Dateinamen direkt unter `temp_directory_path()` ohne Fehlerprüfung — exakt die dokumentierte `/tmp`-Kollisionsklasse (#278/#24: Owner-Mismatch+Sticky-Bit → ofstream scheitert still, Test liest Fremd-/Altinhalte). `comdare_test_tmp.hpp` existiert als verbindliche Lösung, wird hier nicht genutzt.
*Evidence:* Z.34–38 fixe Namen `comdare_p7_*.xml` ohne Stream-Check.
*Fix:* `comdare_test_tmp.hpp` (uid-suffixiert) verwenden + ofstream-Check.

**M-CE-27 — `tests/unit/CMakeLists.txt:2985` (test-gap)**
`test_profile_roundtrip` — das volle golden-320-Roundtrip-Gate des PROFIL-Pfads (m3v2_study → 320 binary_ids positionsidentisch zur Golden-Liste), von Golden-Header + Doku als Resume-#139-Schutz benannt — wird nur als `EXCLUDE_FROM_ALL` gebaut, hat kein `add_test`, ist in keinem CI-Job. Automatisiert geprüft ist nur golden[0].
*Evidence:* `comdare_thesis_adhoc_executable(… EXCLUDE_FROM_ALL …)` ohne add_test; der begründende Blocker ist laut Kommentar „AUFGELOEST".
*Fix:* Als ctest registrieren (Blocker ist laut eigenem Kommentar weg).

**M-CE-28 — `algorithm_profiles/thesis_profiles/ff2_node_width_study.profile.xml` — siehe M-CE-11** (Sammel-Finding; identisches Muster auch `fb_numa_page_study`, `cacheline_study`).

### 2.2 probst-diplomarbeit-cache-engine / super (7 major)

**M-SU-01 — `Code/02_messung_driver/measurement_writer.hpp:102` (architecture / Anti-Phantom)**
`make_record_from_run` ERFINDET `bytes_allocated` (`n_ops*64` „Schätzung"), `bytes_in_use_peak` (=bytes_allocated) und `total_cycles` aus fixer 3-GHz-Annahme; diese Werte fließen via `all_permutations.bin` → Stage 03 → CSV und sind von echten Messwerten nicht unterscheidbar. Die Cache-Miss-Felder derselben Funktion sind korrekt honest-0 — inkonsistent.
*Evidence:* Z.90ff `total_cycles = total_us*3000.0`, `bytes_allocated = n_ops*64`; LIVE via `main.cpp:371`.
*Fix:* Bytes-/Cycles-Felder honest-0/n/a bis PMU-Werte real vorliegen.

**M-SU-02 — `Code/test_data_xml/protein.test_data.xml:5` (correctness)**
Nicht wohlgeformtes XML: rohes `&` in „Pizza&Chili" (Z.5/7/8) → `xmllint: EntityRef: expecting ;`. Autoritative Kanon-Akte lädt heute nur, weil der ce-DOM-Reader lenient ist; jede strikte Verarbeitung (XSD, xmllint-CI, Fremdtools) bricht. Schwester `pizzachili_dna.test_data.xml` escaped korrekt.
*Evidence:* `xmllint --noout` exit 1 an Z.5.
*Fix:* `&` → `&amp;` in protein + `xml.test_data.xml` (siehe minor-Pendant Z.8).

**M-SU-03 — `Code/04_csv_to_latex/csv_to_latex.cpp:474` (correctness / Anti-Phantom)**
`aggregate_exchange` verwässert `median_abs_delta_ns` mit 0-0-Pseudo-Diffs nicht-ausgeübter Interface-Funktionen; die ausgewiesene Stichprobenzahl `n` bezieht sich auf eine ANDERE Population (nur rel-Samples).
*Evidence:* Z.474 pusht `d` unbedingt in `abs_` VOR dem `base>0`-Gate (Z.475); Header definiert `0 = nicht ausgeübt`.
*Fix:* `abs_`-Push ebenfalls hinter `base>0` (bzw. „ausgeübt")-Gate; `n` konsistent zählen.

**M-SU-04 — `Code/05_diagram_generator/tests/test_05_diagram_generator_cached_fixtures.cpp:83` (correctness)**
05-Tests schreiben ~24 feste Dateinamen direkt ins host-weit geteilte `/tmp` — exakt die Cross-User-Kollision (comdare vs. gitlab-runner, Incident 8081/213626), die in den 04-Tests bereits gefixt ist, hier nicht nachgezogen.
*Evidence:* `temp_directory_path() / "v35d3_bar.tex"` u.v.m.; 04-Test dokumentiert user-eindeutige tmp-Basis.
*Fix:* uid-Namespacing analog 04.

**M-SU-05 — `Code/CMakeLists.txt:458` (test-gap)**
`test_08_appendix_generator` und `test_09_tex_formatter` fehlen im CI-Sammel-Target `comdare_da_unit_tests` → ihre `da_unit`-Suites laufen in CI nie (silent skip); `tex_formatter` wird in keinem CI-Job kompiliert.
*Evidence:* foreach-Liste Z.458–462 enthält nur test_03..06; Registry erfasst nur Code/tests-Targets.
*Fix:* test_08/09 in die Registry/foreach aufnehmen.

**M-SU-06 — `Code/CMakeLists.txt:422` (correctness)**
`if(TARGET comdare-cache-engine-builder)` prüft einen nie existierenden Target-Namen — der `--builder-exe`-Zweig ist toter Code, `comdare_tier_binary_visibility` meldet den Builder-Status IMMER als „fehlt" (#279(3) wirkungslos). Echtes Target = `cache_engine_builder` (Bindestrich-Name ist nur `OUTPUT_NAME`).
*Fix:* Auf `cache_engine_builder` prüfen (oder ALIAS anlegen).

**M-SU-07 — `Code/02_messung_driver/CMakeLists.txt:65` (test-gap)**
Das #31-Regressions-Gate `test_messreihen_workload` wird in CI weder gebaut noch ausgeführt: bare `add_test` ohne `LABELS da_unit` und ohne Registry-Eintrag → `test:unit` lässt es still aus, entgegen „VOLLE super-Unit-Suite, Tests NIE auslassen".
*Fix:* `comdare_da_add_test` verwenden (Label + Registry).

### 2.3 comdare-prt-art (3 major)

**M-PA-01 — `prt_art/include/prt_art/internal_search/array_65535.hpp:21` (correctness)**
Off-by-one: `uint16_t`-Diskriminator 65535 indiziert einen Vektor mit nur 65535 Elementen (gültig 0..65534) → OOB-Schreiben/-Lesen (UB) in `noexcept`-Pfad ohne Bounds-Check. Kapazität muss 65536 sein.
*Evidence:* `kCapacity=65535`; `insert(65535,x)` schreibt hinter Vektorende; Tests decken nur `lookup(65534)`.
*Fix:* `kCapacity = 65536`.

**M-PA-02 — `prt_art/include/prt_art/identity/prt_art_search_engine.hpp:93` (correctness)**
Inkonsistente Locking-Disziplin: `size()/empty()/capacity()/max_size()/data()/begin()/end()` lesen `data_/storage_` völlig ungesperrt, während `at()/front()/count()` `shared_lock` nehmen → Data Race (UB) gegen jeden Writer der als thread-safe beworbenen Klasse. Map-Spezialisierung identisch.
*Fix:* Alle lesenden Zugriffe unter `shared_lock` bringen (oder Container atomar/immutable snapshotten).

**M-PA-03 — `prt_art/permutations_codegen/codegen.cmake:207` (architecture / Anti-Phantom)**
Phantom-Achsen im Codegen: `lookup=simd` degradiert still zu `linear`, `telem`-Achse im linear-Zweig wirkungslos, `pc`-Achse im binary-Zweig wirkungslos → mehrere unterschiedlich gelabelte Permutations-DLLs mit byte-identischem Messcode (Messwert-Label ohne echte Code-Quelle).
*Evidence:* generierter Body nur `#if COMDARE_PA_LOOKUP_IS_BINARY … #else //LINEAR` (kein SIMD-Zweig); Telemetrie-Zählung nur binary, PC-Sort nur linear.
*Fix:* Echte SIMD-Codebahn erzeugen bzw. wirkungslose Achsen-Kombis aus dem Profil entfernen (nicht labeln).

### 2.4 thesis/diplomarbeit (2 major)

**M-TH-01 — `kapitel/de/03_messsystem_prtart.tex:308` (doc-drift)**
Zahlen-Drift SOTA-Profile: Thesis behauptet, P08/P09/P33 besäßen bewusst kein Profil-XML und unter `algorithm_profiles/sota` lägen 30 Profile — im Repo liegen **33** XMLs (inkl. `olc/louds/vampir.profile.xml`, `pruefling_type="abstract"`, alle 33 mit `<expected_workload>`). Kap. 2 (Z.92–94) widerspricht zusätzlich Kap. 3.
*Evidence:* `ls …/sota` = 33; `04_implementierung.tex:15`+`06_fazit.tex:20` nennen 30.
*Fix:* Zahlen auf 33 korrigieren, P08/P09/P33-Aussage streichen/anpassen.

**M-TH-02 — `aufgabenstellung/en.tex:62` (doc-drift)**
Die EN-Aufgabenstellung (Header: „translation of de.tex, German master") weicht inhaltlich vom DE-Master ab → im EN-PDF gilt eine schwächere/andere Aufgabenstellung: TA4 nur „YCSB workload routing" statt „aller Workload-Frameworks"; das Zielsetzungs-Kernstück „dynamische Zusammensetzung der verteilten Algorithmus-Konzepte" fehlt; TA1 zweiter Satz, TA2 „Original Compiler Binary linking", TA5 „Test-Teilbereiche/vergleichbare Frameworks" fehlen; Methodik: std::map/std::vector-Interface-Klausel und „um den Originalcode zweifelsfrei nachzuweisen" fehlen.
*Evidence:* 6 Einzelabweichungen wörtlich verifiziert (de.tex:73–74/42–43 etc.).
*Fix:* EN-Aufgabenstellung 1:1 aus dem DE-Master nachziehen.

### 2.5 Medium-Findings (7, zur Vollständigkeit)

- `axes/alloc/concepts/axis_06_allocator_zeroing_strategy_concept.hpp:37` (ce, correctness) — ZeroingStrategy ohne Freigabe-Vertrag → Heap-Crossover je enabled-Flag (`zero_allocate` vendor-calloc vs. `deallocate` portable_aligned_free/`_aligned_free`).
- `topics/queuing/…/axis_q1_queuing_tombstone_buffer.hpp:86` (ce, correctness/dead-code) — TombstoneBuffer kann strukturell nie einen Tombstone haben (keine delete-API) → Skip-Schleife toter Code, degeneriert zu Append-FIFO.
- `topics/queuing/…/axis_q1_queuing_original_concurrentqueue.hpp:134` (ce, architecture) — Anti-Phantom: meldet `is_original`+`gcc-9.5`, ist aber hauseigene Vyukov-Re-Impl; `concurrentqueue.h` nirgends inkludiert.
- `reclamation/rcu_reclaim/rcu.hpp:76` (ce, correctness) — `readers_` hält rohe Pointer auf thread_local State ohne Deregistrierung bei Thread-Ende → dangling in `synchronize()`.
- `tests/unit/thesis_tiere/README.md:5` (ce, doc-drift, medium-Pendant zu M-CE-23).
- `Code/03_binary_to_csv/tests/test_03_binary_to_csv_cached_fixtures.cpp:39` (super, correctness) — Fixture-Writer stempelt Container-v2, schreibt aber v1-Layout ohne `workload_used` → korrupte Fixtures bei Regeneration.
- `anhang/de/A_measurements.tex:4` (thesis, doc-drift) — Kopf erklärt gelöschten `generate_measurement_appendix.ps1` zum Erzeuger, widerspricht derselben Datei (Z.66–72: C++23-Generator) und der Ein-Programm-Doktrin.

---

## 3. Architektur-Synthese-Befund

Über die 4 Repos zeichnen sich **sechs systemische Muster** ab, die einzeln als je viele Findings, in der Summe aber als Architektur-Kanten zu lesen sind:

**A. Anti-Phantom-Verstöße (fabrizierte Messwerte / Labels ohne Code-Quelle).** Wiederkehrend und über alle Repos verteilt: `abi_adapter:250` (RC applied-Zähler), `abi_adapter:989` (tier_erase entkoppelt Organe nicht), `f15_compare:454` + `measurement_writer:102` (ops*64 / 3-GHz-Fabrikation), `sota_catalog:159` (lebewesen ignoriert → 7× identische Zeilen), `codegen.cmake:207` + `hot_body.hpp.template:35` (byte-identische DLLs mit verschiedenen cycles_per_op-Konstanten), `execute_engine_command:139` (hartkodierte H1/H2/H3 → immer `validated=true`), prt-art `update_density:559` (synthetische Node-IDs aus Pointer-Bits), `index_organization observable:102` (predicate_evals für NonClustered ohne Predicate), `.gitlab-ci.yml:617` (synthetische Selbsttest-CSVs im additiven measurement-Baum), `fb_numa_page_study.xml:50` (numa_node-Sweep ohne Konsument → 12 Labels für 3 Verhalten). **Empfehlung:** Die Anti-Phantom-Linie ist im Kern eingehalten (Cache-Miss-Felder korrekt honest-0), aber die **Bytes-/Cycles-/Density-/RC-/Codegen-Pfade** brauchen eine konsequente Durchsetzung „honest-0 statt Schätzung" + „counts nur bei nachweisbarem Konsumenten".

**B. `noexcept`-auf-allozierenden-Pfaden (bad_alloc → std::terminate).** Systemisch, gegen die eigene `[[allocation-failure-exception]]`-Doktrin: Pool-Stores (`tree_node_pool_store:148` + 6 Geschwister, `real_trie.hpp:133`), Queuing (`copy_on_write:113`, `priority_heap:117`), Prefetch (`path_oriented:62`, `observable:129`), value_handle (`real_slot:75/149`), Allocator-Adapter (`pmr_resource_adapter:41`), Telemetry (`path_read_counter:20`). **Empfehlung:** `noexcept` auf den allozierenden Bodies entfernen (Concept-Verträge nachziehen) oder Allokation aus dem `noexcept`-Pfad heben.

**C. Null-Consumer-Trap (committete Vorleistung ohne Produktions-Konsument).** 66 dead-code-Findings; besonders spannungsreich: `measurement_axis_registry.hpp`, `i_measurement_source.hpp` (SystemAxis-Wurzel „Blut"), `curve_fit.hpp`, `selection_filter_chain.hpp` (CoR Slice 1) sind test-only, während Doc 20 exakt mit dem Null-Consumer-Argument den `tree<axis>`-Wurzelbau verwirft (`measurement_axis_registry:1`). Ebenso: 12 Subsystem-Interfaces `i_c01..i_c12`, REV-7.6-Baustein-Subsystem (`algorithm_baustein/baustein_variants/resolve_baustein`), `AbiV1ToV2Mapper` (latent kaputt), 4 V32.EE.5-Achsen (`hardware/scheduling/locking/numa` als vtable-Interfaces gegen die CRTP+Concept-Doktrin), `cache_engine.hpp`-Aggregations-Header (0 Includer). **Empfehlung:** Entweder verdrahten (echter Konsument + Contract-Test, wie Doc 20 §I fordert) oder als geparkt/deprecatet markieren — Doktrin-Spannung „verworfen vs. committet" sichtbar machen.

**D. Super-Sub-Build-Pfad-Divergenz.** Im `add_subdirectory`-Embed (super zieht ce mit Binary-Dir `_cache_engine_external`) divergieren `CMAKE_SOURCE_DIR`/`CMAKE_BINARY_DIR` gegen `CMAKE_CURRENT_*`: `anatomy_codegen.cmake:128/136`, Tool-Suche unter `${CMAKE_BINARY_DIR}/apps/...` (permutations/adhoc_emitter/anatomy_codegen_runner), `CMakeLists.txt:442/661` (`COMDARE_BUILDER_CONFIG_DIR`/`--comdare-root`). Analog prt-art `CMakeLists.txt:62` (`CMAKE_SOURCE_DIR` statt `CURRENT`). Latent, da AUTO_RUN/tests im Embed abgeschaltet, aber beim ersten Embed-Lauf brechend. **Empfehlung:** Durchgängig `CMAKE_CURRENT_*`/`PROJECT_*` (die Fixes existieren bereits punktuell in `boost_mp11_setup/compiler_cache/tools_cache`).

**E. Doku-Drift-Epidemie (114 Findings, 31 %).** Drei Cluster: (1) **PAPER_REFERENCES-Attribution** — Wrapper korrigiert, Shims/family_name-Strings/Profile nicht nachgezogen (scalloc/michael/numalloc/starmalloc; lrmalloc BSD-3 statt MIT; snmalloc-Autoren; Kuehn-DaMoN/Wormhole/Fent-Venues). (2) **Zähl-Drift** — 15/17/21/22 Search-Algos, 8/9 Concurrency, 4/5 value_handle, 25/26 Allocatoren, 17/19 Anatomy-Slots, „3 Achsen" vs. 7 nodes-Achsen. (3) **Gelöschte-Behelfswege-Verweise** — `run_lazy_150.cpp`, `*.ps1`, `test_validate_profile.cpp` in READMEs/SCHEMA/ERWEITERUNGS-LEITFADEN/MANUAL_RUN + docs/architektur-Dossiers. **Empfehlung:** Zähler an Registry-Konstanten binden (compile-time-`static_assert` als Doku-Anker) und einen einmaligen Drift-Sweep der READMEs/Kommentare fahren; Doku nur ergänzen/deprecaten, nie löschen.

**F. Test-Registrierungs-/Ausführungslücken.** 26 test-gaps, davon strukturell: 38 unregistrierte Test-Quellen (M-CE-24), 19 CI-tote contract/pmc-Tests (M-CE-25), `test_profile_roundtrip` EXCLUDE_FROM_ALL (M-CE-27), super test_08/09 + test_messreihen_workload nicht im Sammel-Target. Zusätzlich: NDEBUG-No-Op-Tests (`test_d_v42_*` nur `assert()` + `return 0`), invertiertes PMC-Smoke-Verdikt (`m3v2_pmc_smoke:63` rot bei ehrlich-live-PMC), Scratch-CSV-Pfad im gitignorten build/ (`CMakeLists:2651`). **Empfehlung:** Ein Registrierungs-Audit + Label-Politik; NDEBUG-Tests auf harte Checks umstellen.

---

## 4. AUFRÄUM-LISTE (dead-code + Artefakte)

66 dead-code + 44 cleanup-Findings. Empfehlung folgt der Doktrin: **Doku/Messdaten nie löschen (deprecaten/markieren), Code-/Build-Artefakte löschen nur mit je-Repo-User-GO.** Nachfolgend kuratiert; je mit Grep-Beleg.

### 4.1 Toter Code (löschen/verdrahten — mit GO)

| Ort | Grep-Beleg | Empfehlung |
|---|---|---|
| `include/cache_engine/abi/abi_v1_to_v2_mapper.hpp:56` | 0 Konsumenten; `migrate()` liest `v31.measurement_bank` (existiert nicht) → Build bricht bei echtem V31 | Löschen mit GO (latent kaputt) |
| `include/cache_engine/abi/module_loader.hpp:36` (`PermutationModule`) + `experiment_runner.cpp` | einziger Nutzer `ExperimentRunner`, der 0 Aufrufer hat; Dublette zu `builder::loader::ModuleLoader` | Löschen mit GO / auf lebenden Loader konsolidieren |
| `include/cache_engine/abi/algorithm_baustein.hpp` + `baustein_variants.hpp` + `resolve_baustein.hpp` | `eleven_axes_permutation/DefaultElevenAxes/full_join` = 0 Nutzer; zudem `algorithm_axis<>`→`variant<>` bricht Build | Löschen mit GO (19-Slot-Anatomy ist der lebende Pfad) |
| `src/sha256/comdare_is_original_macro.hpp:50` | 0 Includer; redefiniert `from_hex/to_hex` aus `ctsha.hpp` → kompiliert nicht | Löschen mit GO |
| `include/cache_engine/concepts/{hardware_strategy,scheduling_strategy,locking_mode,numa_affinity}.hpp` | 0 Konsumenten; vtable-Interfaces gegen CRTP+Concept-Doktrin | Löschen mit GO (Produktiv-Achsen in `axes/`/`topics/`) |
| `include/cache_engine/concepts/concurrency_manager.hpp:43` (`IConcurrencyManager`) | 0 Impl/Konsumenten; virtual dispatch im Hot-Path | Löschen mit GO |
| `include/cache_engine/cache_engine.hpp` + `api/i_cache_engine.hpp` | 0 Includer; `get_cache_engine()` deklariert, nie definiert (`src/facade/` existiert nicht) | Löschen/als geplant markieren mit GO |
| `subsystems/c01..c12/CMakeLists.txt` + `i_c01..i_c12` | 15 Kind-CMakeLists von keinem `add_subdirectory` verarbeitet; Interfaces nur `test_sub_engines.cpp` | Löschen mit GO / als Skelett markieren |
| `builder/experiment_tree/`: `perm_runner:312 drive_segment_latencies`, `iterator:70/72 n_repeats/seg_*`, `experiment_tree:85 sum_total_cycles`, `:408 binary_count_traversed`, `coverage_selection:76 select_by_pinned_signature` | je 0 Konsumenten repo-weit | Felder/Funktionen entfernen mit GO (Pfad-A durch tier_observe-POD ersetzt) |
| `builder/experiment_driver.cpp:339` (`phase3_hot_compile_missing`, `phase4b_functional_tests`) | 0 Aufrufer; Flags `enable_runtime_codegen/enable_functional_tests` wirkungslos | Entfernen/verdrahten mit GO |
| `axes/alloc/axis_06_allocator_numalloc.hpp:211` `set_numa_node` / `pim_malloc.hpp:197` `set_dpu_id` | 0 Aufrufer; Runtime-Mutatoren gegen Compile-Time-Doktrin | Entfernen mit GO |
| prt-art `include/prt_art/default_lookup/CMakeLists.txt` + `density_tracker.hpp:29` (`note_observation/adapt_locality`) | Target nirgends erzeugt; APIs 0 Konsumenten (Adapter gelöscht) | Löschen mit GO |
| ce `_copy_ext_repos.py` / `_generate_legacy_reimpl.py` / `_generate_stubs.py` / `_analyze_licenses.py` | hartkodierte Windows-Pfade, Zielverzeichnisse existieren nicht mehr | Löschen mit GO (One-Shot-Scaffolding) |
| ce `benchmarks/{ycsb,microbenchmarks,platform_calibration}` | nur `.gitkeep` + Ein-Kommentar-CMakeLists, 0 Targets; via Root:628 mitkonfiguriert | Als geplant markieren oder Subtree entfernen mit GO |
| super `experiment_config/sample_data/v22_throughput_by_workload.tikz` | 0 Konsumenten (nur Session-Archive) | Löschen mit GO / nach docs/ als Beispiel |
| super `Code/experiment_config/config_a/b/c_*.xml` | Root-Tag `comdare_experiment` nirgends geparst (nur CMake-Namenskollision) | Klären/entfernen mit GO (Legacy-Pfad opt-in) |
| ce `cmake/{compiler_cache,paper_binary,tools_cache,isa_features:103}.cmake` P2.A-Trio | 0 Aufrufer; `paper_binary.cmake:80` zudem defekt (`-c … -o` mehrere Sources) | Entfernen mit GO |

### 4.2 Artefakte / Behelfswege (Aufräumen — mit GO)

| Ort | Grep-Beleg | Empfehlung |
|---|---|---|
| ce `ext/A05-jemalloc/` (40K, nur `msvc/`) neben echtem `ext/allocator/A05-jemalloc/` (5.4M) | `diff -qr` = nur „Only in allocator/…" | Orphan-Fragment löschen mit GO |
| ce `ext/A05-jemalloc/msvc/…/*.tlog`, `*.lastbuildstate`, `unsuccessfulbuild` | `git ls-files 'ext/A05-jemalloc*'` = 3 Build-Log-Artefakte (eins 0 Byte) | `git rm` mit GO (Build-Logs, keine Messdaten) |
| ce `build*/`-Trees (~9,1 GB): build-cmd1a/b, build-conf, build-go2/-pre, build-perms-fix, build; super `Code/build`, prt-art `build` | alle gitignored/untracked | Lokal aufräumbar mit GO — **Achtung** ce `build/` enthält getrackte `tier150_measurements.csv` (git restauriert; Fixture-Kopie existiert) |
| ce `build/thesis_tiere/tier150_measurements.csv` | `cmp` IDENTISCH zur Fixture-Kopie; `.gitignore`-Negation deckt nur `tests/unit/fixtures/`, nicht `thesis_tiere/` | Force-Add-Redundanz mit GO entfernen; `.gitignore`-Negation korrigieren (Messdaten-Doktrin: additiv) |
| ce `.gitmodules.template.obsolete` | Dateiname trägt `.obsolete`; nie realisierte modules/-Topologie | Löschen mit GO (Historie bleibt) |
| ce `cmake/check_submodules.cmake:13/27` | verlangt 6 `modules/comdare-*`-Skelette; `ls modules/` = nur README → Warnung feuert falsch bei jedem Configure | Prüfung auf neue SOLL-Struktur umstellen/deprecaten |
| ce `libs/cache_engine/builder/best_binary_selector/build_and_run.bat` | Behelfsweg (`/std:c++17`) durch offizielles CMake-Target abgelöst | Löschen mit GO (Toolchain-Drift) |
| ce `tools/permutation_codegen/codegen.sh` / `.bat` | DEPRECATED-Header (Skelett/Platzhalter); Configure endet bei Backend sh/bat in FATAL (`--profile`/`--mode` unbekannt) | Deprecaten/entfernen mit GO; `permutations.cmake:8`-„synchron gepflegt"-Behauptung korrigieren |
| thesis `generate_wide_appendix.ps1` + `generate_measurement_appendix.ps1` | durch `Code/08_appendix_generator` ersetzt; **kein** DEPRECATED-Header (grep=0) | DEPRECATED-Header ergänzen (Doku-nie-löschen) |
| super `tools/format_tex.py` | No-Python-Doktrin; Depth-Leak-Bug (Z.94) nie gefixt; 0 Tests; nicht abgelöst | Deprecaten + Nachfolger (`Code/09_tex_formatter`) verlinken |
| ce `tools/socks5_zih_delivery/README.md:25` | committet ZIH-Login `s2631336`, VPN-Cert-Pfad, OneDrive-Pfade | Infra-Daten aus dem Repo nehmen mit GO |
| ce `tools/abi_stability_test/README.md:14` | plant `*.py` (No-Python-Verstoß); Dateien existieren nicht | README auf No-Python-Plan umschreiben |
| prt-art `GPT questions to prt art.txt` (Repo-Wurzel) | Primärquelle (User-Design, Frage 4 Density-Semantik) mit Scratch-Namen | **Nicht löschen** — nach `docs/` verschieben + datieren |
| super `docs/HANDOVER-ANHANG-MEMORIES-20260705/` (59 Dateien) | 58/59 byte-identisch im späteren Voll-Export enthalten | **Nur markieren** (additive-Backup-Doktrin) — im BACKUP-INDEX als ersetzt vermerken |
| ce `src/sha256/ctsha.hpp:191` | funktionsloses `#include <string_view>` nach namespace-Ende | Scratch-Rest entfernen |
| super `docs/architektur/`: doppelte `11_`-Prefixe + unnummeriertes `TIER-AUFLOESUNG-…md`; `00_INDEX:3` SUPERSEDED-Banner für 25 lebende Dateien | `grep -c SUPERSEDED` inkonsistent (01/08/11/12/13 = 0) | Banner konsolidieren, Nummernschema reparieren (deprecaten, nicht löschen) |

**Nicht-Löschen-Vorbehalt:** Alle Messdaten-CSVs (`adapter_measurements.csv`, `tier150_measurements.csv`) und Doku bleiben bestehen; hier ist ausschließlich **Provenienz-Reparatur** (gelöschte Erzeuger-Verweise) und **De-Redundanz mit GO** empfohlen.

---

## 5. Ist/Soll/Diff-Befund (Freigaben-Session GO1–GO5, Stand 2026-07-12)

Die Freigaben-Session (GO1–GO5 / §11-I) hat Behauptungen (**Soll**) fixiert, die an mehreren Stellen vom **Ist** (Code am 2026-07-12) abweichen. Diff-Liste:

| GO / Soll-Behauptung | Ist (Code) | Diff / Handlung |
|---|---|---|
| **GO-5-Fork-2**: „`test_data_sets.xml` existiert NIRGENDS (0×); Slot wird NICHT befüllt" (`xml_config_parser.hpp:10`, `.cpp:94–99`) | Datei existiert git-tracked im Default-Preset (`builder/example_configs/test_data_sets.xml`, 3 Einträge), `XmlConfigParser::parse` befüllt `cfg.test_data_sets` daraus | **Falschbehauptung** → per R2 verbotene Doppelquelle real vorhanden; Kommentar + Doppelquelle bereinigen |
| **Kanonisierung 2026-07-12**: Achsen-Namen/-Werte nachgezogen | Workload-**ids** nicht nachgezogen → `ff2/fb/cacheline_study.xml` brechen mit exit 4 (M-CE-11); `validate_profile` fängt es nicht (M-CE-12) | **Unvollständige Freigabe** → Tokens `ycsb_*` + validate-Check |
| **GO-2 (cpp = Default-Backend)** | `permutations.cmake:22` Default = `cpp` (Ist korrekt), aber `permutation_codegen_tool.hpp:9–11` sagt weiter „Default bleibt cmake UNVERAENDERT"; `permutations.cmake:8` behauptet sh/bat „synchron gepflegt" (real DEPRECATED-Skelett) | **Doku-Drift** → .hpp + Kopf-Kommentar nachziehen |
| **GO-5 (B.4.1-a): alle 19 Achsen deepened, eigene Sweep-Kataloge** | `m3_smoke_coverage` korrekt; `m3_golden_coverage.profile.xml:10` sagt weiter „4 Basis via Basis-320-View" | **Doku-Drift** im Golden-Profil-Kopf |
| **GO 3 (Doc 21 bindender Bauplan)**: batch_size/thread_count = NO-OP, Phase 4 macht sie „echt" | Schicht E1/#221 hat sie geliefert (`abi_adapter:253` apply1 batch_size; thread_count honest-not-counted) | **Superseded ohne Vermerk** (Doc 21 §C/Phase 4) → additive Korrektur-Notiz |
| **Dossier 22 (CI-Anhang-Automation)**: `Code/06_appendix_generator`, `Code/06_tex_formatter` | implementiert als `Code/08_appendix_generator`, `Code/09_tex_formatter` (06 kollidiert mit `06_latex_to_pdf`) | **Falsche Ist-Pfade** → additiver Pfad-Vermerk im Dossier |
| **Mess-Ergebnis-Rückschreibung (§0-Erweiterung)**: `persist:measurements` sichert Mess-CSVs additiv | `.gitlab-ci.yml:617` committet die synthetischen Selbsttest-CSVs des `prebackup`-Jobs („messung v1/v2") in den autoritativen measurement-Baum → Fake-Material akkumuliert unter Nie-löschen-Doktrin | **Anti-Phantom im Persist-Pfad** → prebackup-Selbsttest von der Persistierung trennen |
| **Dossier 16 (autoritativ)** vs. **Dossier 17** | 16 I.4: „config_a/b/c ist toter Code" vs. 17 B.1: `ExperimentDriver` als Konsument (Legacy-opt-in real vorhanden); 16 A.4: „ABI-Major 3" vs. 16 F: „ABI-MAJOR==4 TABU" | **Interne Dossier-Widersprüche** → additive Klarstellungen |
| **CE/34 (IST-SSoT via Ledger §10.1)** | trägt Juni-Stand ohne Stale-Banner: POD „sizeof 1400", „ABI-Major 2→3"; Code = 1416 / Major 4 | **Fehlende Aktualitäts-Marke** → additiver Banner |

**Kern-Diff:** Die Freigaben sind **funktional wirksam** (Backend cpp, 19-Achsen-Deepening, E1-RC), aber die **Doku-/Kommentar-/Profil-Schicht** ist an den GO-Nahtstellen nicht durchgehend nachgezogen; die einzige **funktionale** Freigaben-Lücke ist die Workload-id-Kanonisierung (M-CE-11/12), die ff2/fb/cacheline im echten Lauf mit exit 4 kippen lässt.

---

## 6. Coverage-Nachweis

Die folgenden Partitionen wurden **vollständig (jede Zeile)** gelesen; die Angaben sind aus den Reviewer-Coverage-Daten übernommen. Die übergebene COVERAGE-Liste ist **am 6. Reviewer abgeschnitten** (`…builder (ohne experiment_tree): 12 T…`) und wird hier so wiedergegeben, wie sie vorliegt; die nicht separat gelisteten Bereiche (anatomy, include/, profile_facade, compositions, subsystems, reclamation, virus, common, tools, apps, cmake, tests, ce-/super-CI, super-Pipeline 01–09, prt-art, thesis, docs) sind durch die zugehörigen Findings belegt.

| # | Partition | Dateien (jede Zeile gelesen) |
|---|---|---:|
| 1 | `axes/alloc` (31 Wrapper/Basis/Registry/Flags inkl. `.in`, 10 concepts, 23 vendor_includes, PAPER_REFERENCES.md) + `axes/cacheline` (2) + `axes/layout` (10+2 concepts+PAPER_REF) + `axes/node` (13+2 concepts+PAPER_REF) | 96 |
| 2 | `axes/lookup` (23 inkl. PAPER_REF) + `lookup/concepts` (7) + `lookup/composable` (63) + `mapping` (12) + `path_compression` (13) + `simd` (13). Hinweis: das im Auftrag genannte `axes/composable` existiert nicht separat — die composable-Schicht liegt unter `lookup/composable` und wurde vollständig gelesen. | 131 |
| 3 | `axes/filter_axis` (19) + `serialization_axis` (13) + `telemetry_axis` (12) + `value_handle_axis` (15) + `topics/filter` (19 Alias-Wrapper) + `topics/queuing` (46). `serialization/telemetry/value_handle`-topics-Pendants sind inhaltsgleiche using-Weiterleitungen (Stichprobe bestätigt). | 124 |
| 4 | axes-Root `axis_centric_namespaces.hpp` + `cache_traversal` (14) + `concurrency_axis` (17) + `filter_axis` (19) + `index_organization` (12) + `io_dispatch` (12) + `migration_policy` (12) + `prefetch_axis` (15) + `serialization_axis` (13) + `telemetry_axis` (12) + `value_handle_axis` (14) inkl. PAPER_REF + `.hpp.in` | 141 |
| 5 | `libs/cache_engine/builder/experiment_tree` (3847 Zeilen; `cache_engine_builder_iterator.hpp` in 2 Seiten) — keine Datei übersprungen | 28 |
| 6 | `libs/cache_engine/builder` (ohne experiment_tree) — *(Coverage-Angabe im Auftrag abgeschnitten)* | 134 |

**Zusätzliche gezielte Verifikations-Reads (außerhalb der jeweiligen Partition, als Beleg für Dead-Code-/Erreichbarkeits-/Konsumenten-Claims):** `abi_adapter.hpp`, `anatomy_execution_context.hpp`, `observable_composed_search.hpp`, `tree_node_pool_store.hpp`, `CMakeLists.txt`, `ext/CMakeLists.txt`, `adapters/A01-hoard`, `ext/A07-snmalloc/libc.h`, `portable_aligned_alloc.hpp`, diverse `tests/unit`-Dateien; topics/nodes- und topics/traversal-Namespace-Shims; Konsumenten-Grep inkl. Nachbar-Repo `comdare-prt-art` (exkl. `build*/`, `ext/`).

**Adversariale Gegenprüfung (Beispiel-Entkräftung):** Der snmalloc-`free_aligned_sized`-Verdacht (gerundete vs. ungerundete Größe) wurde geprüft und **entkräftet** (snmalloc rundet intern identisch) — daher **nicht** gemeldet. Der Legacy-Runtime-`arity_`-Kanal von `KArySearchAlgo` (S10) wurde als dokumentiert-transitional (Inc-2-gated, golden-320-Pin) bewusst **nicht** als Doktrin-Verstoß gemeldet.

---

*Ende des konsolidierten Voll-Review-Berichts. 368 bestätigte Findings; 40 major, 0 critical. Kern-System messfähig; Handlungsschwerpunkte: Anti-Phantom-Durchsetzung in Bytes-/Cycles-/RC-/Codegen-Pfaden, `noexcept`-auf-Alloc-Härtung, Workload-id-Kanonisierung (funktionale Freigaben-Lücke), Doku-Drift-Sweep, Test-Registrierungs-Audit.*
