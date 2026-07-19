# INC-G6 -- Materialisierungs-Architektur + Chunk-Bau-Mechanik (der ~8h-N-Bau)

Paket W3-A. Owner: super `.gitlab-ci.yml`, ce `build_orchestrator`-Umfeld + `cmake/`, dieses Plan-Dokument.
Ledger-Bezug: §32-F2 (System gegen die CI mit dem new-golden-Satz aufbauen), §33 (golden-320 kein
Systembeweis), §34 (F9 = JA INC-G6). ce HEAD `1cbc5b58` (Welle 2). Stand 2026-07-19.

Dies ist ein REINES BAU-/KARTIERUNGS-Dokument. Kein Code in diesem Paket wurde golden-brechend geaendert;
alle vorgeschlagenen ce-Nahtstellen sind GO-pflichtig und werden hier NUR dokumentiert (Regel 8: GO-pflichtig
-> nicht bauen, melden). Die einzige ausgefuehrte Aenderung im W3-A-Owner-Bereich ist der super
`.gitlab-ci.yml` (Abschnitt 7).

---

## 0. Kern-These und Ergebnis (LIVE verifiziert, mit datei:zeile)

> Kern-These (Auftrag): "Baut der all_axes_golden-Lauf-Pfad die DLL-Quellen je Binary via
> `make_union_source_gen`/adhoc ODER braucht er `generated_source_catalog` (dann waere G6 der Codegen-Umbau)?"

**ERGEBNIS: Der Pfad KANN die 131072 DLL-Quellen HEUTE NICHT je Binary erzeugen.** Er loest Quellen ueber
eine MATERIALISIERTE Map (`union_gen`) auf, die bewusst auf 320 (m3v2) + ~72 Achsen-Sweeps + SOTA begrenzt
ist und durch den GN-2-Guard hart bei `kMaxMaterializableCatalogCardinality = 4096` gedeckelt ist. Fuer die
~131k golden-N-`binary_id`s ausserhalb dieser Maps liefert `union_gen` eine LEERE Quelle.

**Damit ist INC-G6 der CODEGEN-UMBAU** (Hypothese B des Auftrags), NICHT nur eine Chunk-Naht: es fehlt ein
PER-BINARY (per-Index) LAZY-Quell-Emitter ueber den golden-N-Indexraum, der zu JEDER golden-N-`binary_id`
das `perm_<id>.cpp` erzeugt, OHNE das `mp_product`-Monolith zu materialisieren. Die Chunk-Fensterung ueber
den Indexraum ist demgegenueber bereits heute (lazy `StaticBinaryView` + `select_explicit`) moeglich, aber
ohne den Emitter WIRKUNGSLOS (leere Quellen).

### 0.1 Der reale Lauf-Pfad (Aufruf-Kette, datei:zeile)

1. CI `build:golden-n` (`.gitlab-ci.yml:638`) bzw. `measure:golden-320` (`:546`) baut
   `comdare-messung-driver` und ruft ihn (`--validate` bzw. `experiment_config measure_out`).
2. Treiber `Code/02_messung_driver/main.cpp:696-724`: liest `COMDARE_THESIS_PROFILE`, fuellt
   `pf::ProfileRunArgs pa`, Cap aus `COMDARE_E4_CAP` (`:712`), ruft `pf::run_profile_facade(pa)` (`:724`).
3. `run_profile_facade` (`libs/cache_engine/profile_facade/profile_run_facade.cpp:324`): montiert die
   `compile`/`compile_for_perm`-CompileFns (`make_gpp_compile_fn`, `:379`/`:412`), die `algo_sig` aus
   `build_axis_variant_version_table` (`:388`, Organ-Gate fuer `dll_is_current`), ruft `tlz::run_profile`
   (`:432`).
4. `run_profile` (`libs/cache_engine/profile_facade/profile_run_entry.hpp:159`):
   - `basis_levels = build_profile_basis_levels(tp, ...)` (`:177`) -> aus all_axes_golden.profile.xml
     entstehen die 17 statischen Achsen je 2 Werte.
   - `basis_view = basis_tree.static_binary_view()` (`:191`) -> **LAZY**: `view[i]` dekodiert Index `i`
     on-demand (Mixed-Radix), es wird KEIN `mp_product` materialisiert. `basis_tree.binary_count()` = 131072.
   - Cap `N = profile_effective_cap(ro.cap, a.max_binaries, basis_tree.binary_count())` (`:198`). Fuer
     all_axes_golden (`cap="0"`) = alle Basis-Zellen = **131072**.
   - **union_gen** = `make_union_source_gen(generated_make_catalog_source_gen(), fused)` (`:216`), mit
     `fused = make_all_axis_sweeps_source_map()` (~72) + SOTA-View-Map.
   - Basis-Pass: `profile_make_basis(view, N)` (`profile_runner.hpp:232`) -> Indizes `0..N-1` ->
     `run_lazy_static_then_dynamic(basis_tree, sel, perm_compile, union_gen, ram, cfg, algo_sig)` (`:414`).
5. Der `BuildOrchestrator` baut NUR die selektierten Indizes: `provision_all(view, sel.indices, &stats)`
   (`build_orchestrator.hpp:243`, Kern `provision_core` O(K), `:256`). Je Binary:
   `f << gen_(spec.binary_id)` (`:366`) -> `union_gen(binary_id)`.

### 0.2 Warum `union_gen` fuer golden-N leer liefert (die Materialisierungs-Grenze)

- `generated_make_catalog_source_gen()` stammt aus `generated_source_catalog.hpp` -- einer GENERIERTEN
  Datei (nicht im Baum), erzeugt zur ce-Bau-Zeit vom `apps/catalog_codegen_tool` (`main.cpp:302` schreibt
  `generated_make_catalog_source_gen()`), aus dem **320er `m3v2_study.profile.xml`** (`cmake/catalog_codegen.cmake:24`,
  `:34` add_custom_command). Es ist eine **MATERIALISIERTE 320-Eintrag-Map** via
  `make_catalog_source_gen<GeneratedFullSourceCatalog>()` -> `build_pilot_source_map<Engine>()`.
- `build_pilot_source_map<Engine>` (`pilot_source_map.hpp:36`) iteriert `Engine::for_each_permutation` ueber
  das VOLLE `mp_product` der Katalog-Form und legt je Permutation `serialize_composition_path<P>() ->
  render_adhoc_module_source(...)` ab. Das ist der MATERIALISIERENDE Pfad. Fuer 131072 = GB-TU / g++-ICE.
- `make_source_gen_from_map` (`pilot_source_map.hpp:51`) liefert fuer eine unbekannte `binary_id` eine LEERE
  Quelle.
- GN-2-Guard (`source_catalog.hpp:230-253`): `make_catalog_source_gen<Catalog>()` steht in einem
  discarded-faehigen `if constexpr (!is_forbidden_full_form && within_materialization_bound)`; sonst
  `static_assert`. Grenze `kMaxMaterializableCatalogCardinality = 4096` (`:183`). Guard-des-Guards
  (`:187-190`): die Grenze MUSS die 2^17-Vollform ausschliessen und die 320-Basis zulassen.
- Die golden-N-`binary_id`s variieren VIELE Achsen gleichzeitig; die Sweep-Maps
  (`make_all_axis_sweeps_source_map`, `source_catalog.hpp:532`) variieren je Eintrag NUR EINE Achse von der
  Baseline. Der Schnitt (320-Map geschnitten mit golden-N) ist winzig (nur die Zellen, in denen search_algo/node_type/
  memory_layout/prefetch je in {0,1} liegen und die uebrigen 13 Slots auf Index 0 stehen = 2*2*2*2 = 16),
  plus die wenigen Sweep-Eintraege, deren einzelne Nicht-Baseline-Achse in {0,1} faellt. Fuer den GANZ
  ueberwiegenden Rest der 131072 -> LEERE Quelle -> keine reale Tier-DLL (der Orchestrator schreibt ein
  leeres `perm.cpp`; das ist ehrlich sichtbar, aber KEIN Systembeweis-DLL).

### 0.3 Live-Beleg (Scratch, literale Ausgabe)

Der GN-2-Guard-Mechanismus (discarded-branch `static_assert` fuer die Vollform) wurde als standalone-Replik
(`scratchpad/gn2_guard_replica.cpp`, ohne Umbrella/`mp_product`) gegen beide Roots geprueft (Regel 2):

```
[1] g++-16  -std=c++23 -fsyntax-only            -> GREEN (320-form materializes, FullSourceCatalog excluded)
[2] clang++ -std=c++23 -fsyntax-only            -> GREEN (same)
[3] g++-16  -std=c++23 -fsyntax-only -DTRIGGER_FORBIDDEN ->
    error: static assertion failed: GN-2: FullSourceCatalog materialization is FORBIDDEN
```

Der committete Systembeweis-ANKER bleibt kompilezeitlich in der ce-Test-Suite verankert (TABU, nicht
angefasst): `static_assert(catalog_axis_product<FullSourceCatalog>() == 131072)` (`source_catalog.hpp:156`),
`kNewGolden131072Crc64 = 0xF1C1F26A1232073B` (`:168`), `test_limits_entkopplung_vorstufe.cpp:116` (CRC64
ON-DEMAND ueber die lazy View, nicht ueber die 62-MB-Datei).

---

## 1. Was INC-G6 bauen muss (der Codegen-Umbau; GO-pflichtig)

Ziel: zu JEDER golden-N-`binary_id` (bzw. View-Index `i`) die REALE `perm_<id>.cpp`-Quelle erzeugen, OHNE
das `mp_product` zu materialisieren. Muster: **Lazy Per-Index-Emitter als Spiegel der lazy `StaticBinaryView`**.

### 1.1 Beobachtung: die Bausteine existieren bereits (nur nicht lazy verdrahtet)

- `catalog_codegen_tool` berechnet je Slot `variants_for_list<List>()` -> `std::vector<VariantEntry>{name,
  cpp_type}` (`main.cpp:103`), d.h. je Achse die kleine Tabelle (`W::name()`, FQ-`cpp_type`). 17 Slots x je
  ~2..30 Varianten = winzig, KEIN Produkt.
- `adhoc_emitter.hpp:52` `adhoc_macro_args<C>()` fuegt die 17 FQ-Typ-Namen einer Composition `C` zusammen;
  `render_adhoc_module_source(idx, macro_args)` (`:83`) wickelt sie in Umbrella-Include +
  `COMDARE_DEFINE_ANATOMY_MODULE_ADHOC`. Der Macro-Argument-Block ist REINER TEXT (die 17 Typ-Namen) -- er
  braucht NICHT die materialisierte Composition, wenn man die 17 Namen direkt aus den Slot-Tabellen zieht.
- Die lazy `StaticBinaryView` dekodiert bereits Index `i` -> 17 Slot-Indizes (Mixed-Radix) -> `binary_id`.
  Genau diese Dekodierung ist die Quelle-Seite: Index `i` -> (s0..s16) -> die 17 `cpp_type`-Strings ->
  `render_adhoc_module_source`.

### 1.2 Vorgeschlagene Naht (benannte Muster: Builder + Flyweight-Tabellen; CT-Doktrin, kein std::variant)

Neuer Header (Vorschlag) `libs/cache_engine/profile_facade/lazy_adhoc_source_gen.hpp` (Materialisierungs-
Domaene, umbrella-schwer -> gehoert NEBEN `source_catalog.hpp`, nicht in den agnostischen Treiber):

1. `lazy_slot_type_tables()` -> `std::array<std::vector<std::string>, 17>`: je Slot die FQ-`cpp_type`-Liste
   ueber die VOLLEN Enabled-Listen (Single-Source = die `TopicConfigSet::StaticAxisVariants_*`, dieselben
   Listen wie `CatalogAxes`/`catalog_static_levels`). Compile-time-Reflexion je Slot (`variants_for_list`),
   host-seitig EINMAL, O(sum Slot-Groessen). KEIN `mp_product`.
2. `lazy_adhoc_source_for(std::vector<std::pair<std::string,std::string>> const& axes)` bzw.
   `..._for_view_index(StaticBinaryView const&, std::size_t i)`: dekodiert die 17 (achse,wert)-Paare
   (`spec.axes`, die die View ohnehin liefert) auf die 17 Slot-Positionen, waehlt je Slot den
   `cpp_type`-String aus der Flyweight-Tabelle (Match ueber `W::name()`), joint -> `render_adhoc_module_source`.
3. `make_lazy_adhoc_source_gen()` -> `ex::SourceGenFn`: die Naht, die `run_profile` statt/zusaetzlich zu
   `generated_make_catalog_source_gen()` in `make_union_source_gen` einsetzt. Fuer eine `binary_id`, deren
   Slot-Werte alle in den Enabled-Tabellen liegen, liefert sie eine REALE Quelle; sonst leer (ehrlich).

Kosten pro Binary: O(17) String-Lookups. KEIN Produkt, kein GB-TU. Der GN-2-Guard bleibt UNBERUEHRT: er
sperrt nur den map-materialisierenden `make_catalog_source_gen`; der lazy Emitter geht gar nicht durch
`build_pilot_source_map`.

### 1.3 Warum das GO-pflichtig ist (Regel 8)

- Es ist eine NEUE Codegen-Naht in der Materialisierungs-Domaene neben `source_catalog.hpp` (GN-2-Umfeld).
- Sie erweitert den golden-N-Lauf vom Pre-Flight (`--validate`) zum echten DLL-Bau -- das ist der §32-F2
  "System aufbauen", ausdruecklich als GO-pflichtig/gestaffelt markiert (bestehendes FIXME
  `.gitlab-ci.yml:629`).
- Round-Trip-Risiko: die erzeugten Quell-`binary_id`s MUESSEN byte-identisch zur lazy-View-`binary_id` sein
  (sonst leerer Lookup). Ein Gate (`test_lazy_adhoc_source_gen`, W3-B/Codegen-Wave) muss das gegen den
  CRC64-Anker + eine Stichprobe belegen, BEVOR ein Voll-Lauf laeuft.

Bis zum GO bleibt der Systembeweis-Anker der Compile-Time-Guard + CRC64 (Abschnitt 0.3).

---

## 2. Chunk-Strategie (Fenster ueber den 131072-Indexraum)

Die Fensterung ist an der Selektions-Schicht bereits heute darstellbar (lazy View + `select_explicit`,
`provision_core` O(K)) -- sie wird durch den Emitter (Abschnitt 1) erst WIRKSAM.

- Env `COMDARE_GOLDEN_N_RANGE="start:count"` -> ein Fenster `[start, start+count)` ueber die 131072 Indizes.
- In `run_profile` (Basis-Pass): statt `profile_make_basis(view, N)` (Indizes `0..N-1`) ein gefenstertes
  `select_explicit(iota(start, start+count))` (geklemmt auf `view.size()`). Alle anderen Passes (Sweeps,
  SOTA) bleiben unveraendert bzw. werden im reinen N-Bau abgeschaltet.
- `provision-only` (Bau ohne Messung): der golden-N-Materialisierungslauf baut NUR DLLs (+ `.version`/
  `.algos`-Sidecars), MISST NICHT. Das entkoppelt den ~8h-Bau vom mehrtaegigen Messlauf und macht ihn
  Storage-cachebar. Naht: ein `run_options`/Args-Flag `provision_only`, das nach `provision_all` (die DLLs
  liegen versions-aktuell vor) VOR der dynamischen Mess-Phase in `run_lazy_static_then_dynamic` zurueckkehrt.

### 2.1 Warum Chunks (Fenster) statt Ein-Schuss

1. **Resume**: `dll_is_current` (`build_orchestrator.hpp:192`) + `.version` (System-Provenienz:
   ext/cxx/opt/target/ceb) + `.algos` (Organ-Provenienz) UEBERSPRINGT versions-aktuelle DLLs
   (`:332`). Ein abgebrochener Chunk wird bei Wiederholung nur um die fehlenden Binaries fortgesetzt -- der
   Voll-N-Bau ist damit inhaerent resumierbar (ueber Chunks UND innerhalb eines Chunks).
2. **RAM/Disk-Budget je Fenster**: der Orchestrator hat RAM-Admission (`:340`), aber die DISK-Summe
   (131k DLLs) muss je Chunk gemessen + (Storage) abgeflossen werden (GN-9, Abschnitt 5).
3. **CI-Zeitfenster**: ein Chunk passt in ein CI-Job-Timeout; der Voll-N-Bau wird als Chunk-Matrix
   (`start` = k*count) gefahren, jeder Chunk ein eigener Job/Lauf, Storage als gemeinsame Ebene B.

### 2.2 Chunk-Ableitung (deterministisch)

- Indexraum `[0, 131072)`. Fenstergroesse `count` (z.B. 4096) -> 32 Chunks. `start = chunk_id * count`.
- Die `binary_id` je Index ist deterministisch (lazy View, Mixed-Radix, CRC64-verankert). Zwei Laeufe mit
  demselben `start:count` bauen dieselben Binaries -> Resume ueber Storage/Disk trifft.

---

## 3. Persistenz (output_dir + prod-MinIO Ebene B via COMDARE_STORAGE_CACHE)

- **Lokal**: `cfg.per_binary_subdirs = true` (`run_profile` setzt es, `profile_run_entry.hpp:305`) ->
  `output_dir/<stem>/perm.dll` + `perm.dll.version` + `perm.dll.algos` + `perm.cpp` + `.cxx.log`. Der Stem
  ist MAX_PATH-sicher (`orch_make_stem`, `build_orchestrator.hpp:169`).
- **Ebene B (MinIO)**: `cache_push` (No-Op-Default) -> `ArtifactCache::push_tier_binary(bin_dir,
  build_version)` (`artifact_cache.hpp:57`), scharf nur bei `COMDARE_STORAGE_CACHE=="true"` +
  vollstaendigen minio-CI-Vars (`.storage_cache_activation`, `.gitlab-ci.yml:439`). Der Objekt-Key koppelt an
  die `build_version`-Signatur (System-Provenienz) -> ein Chunk, der auf einem anderen Runner erneut laeuft,
  kann versions-aktuelle DLLs aus dem Store PULLEN statt neu bauen (Storage-gated Resume).
  HINWEIS: der PULL-Pfad (Store -> lokal vor `dll_is_current`) ist im heutigen `cache_push` nur als PUSH
  belegt; der symmetrische Pull ist Teil des G6-Storage-Increments (GO-pflichtig, hier dokumentiert).
- **Ebene C (measure-drop)**: irrelevant fuer provision-only (kein Messlauf) -> bleibt inert.

Der Storage-Kanal ist byte-neutral INERT ohne `COMDARE_STORAGE_CACHE` (Anti-Phantom): `from_env()` -> No-Op
(`artifact_cache.hpp:14`), `run_profile` ruft die leeren Nahtstellen nie.

---

## 4. Zeit-Schaetzung (mit expliziten Annahmen, NICHT geraten)

Der "~8h-N-Bau" ist eine PARALLELITAETS-Annahme, keine Konstante. Rechnung:

```
T_gesamt ~= N * t_TU / P
  N        = 131072 DLLs
  t_TU     = Wandzeit je perm.cpp-Kompilat (g++ -std=c++23 -shared, Umbrella-schwer)
  P        = parallele Bau-Jobs = total_cores / cores_per_build  (build_orchestrator.hpp:81)
```

- Bei `cores_per_build=1` und einem 64-Kern-Runner: P=64. Mit t_TU ~= 15 s -> 131072*15/64 ~= 8,5 h.
- Bei `cores_per_build=4` (KF-16b-Default): P=16 -> ~34 h. -> **Fuer den ~8h-Zielkorridor MUSS der
  N-Bau `cores_per_build=1` (max Bau-Job-Parallelitaet) fahren** (die Mess-Ein-Thread-Doktrin gilt fuer die
  MESSUNG, nicht fuer den Bau; provision-only misst nicht -> Bau darf voll parallelisieren). Das ist die
  Debug/parallel-vs-Mess/1-Thread-Doktrin (Memory: measurement_modes_debug_parallel_measure_singlethread).
- t_TU ist NICHT gemessen (der Umbrella + ADHOC-Instanz ist schwer; realistisch 8..30 s). **Offene Messgroesse
  (GN-9-Chunk-0-Kalibrierung, Abschnitt 5)**: der erste Chunk (count=4096) misst t_TU real -> extrapoliert
  T_gesamt ehrlich, statt zu raten.
- Resume drueckt die EFFEKTIVE Zeit bei Fortsetzung gegen 0 (nur fehlende Binaries).

---

## 5. Risiken + GN-9-Bloat-Messung je Chunk

| Risiko | Ursache | Gegenmassnahme |
|---|---|---|
| **RAM** | Umbrella-schwere TUs, P parallele Builds | RAM-Admission (`build_orchestrator.hpp:340`), `min_free_gb` je Build; P ueber `cores_per_build` steuerbar |
| **ICE / GB-TU** | Versehentliches Materialisieren der Vollform | GN-2-Guard (`source_catalog.hpp:187/243`) bricht compile-time; der lazy Emitter (Abs. 1) geht NIE durch `build_pilot_source_map` |
| **Disk-Bloat** | 131k `.so` + `.obj` + Logs | GN-9 (unten); per-Binary-Subdir; `.obj`/Logs NICHT persistieren; Storage-Offload Ebene B |
| **Cold-ICE-Runner** | Kalter Runner-Cache (Infra) | 1x Retry-Doktrin (Memory: ci_runner_ice_cold_cache_instability), NICHT als D1 fehletikettieren |
| **Round-Trip-Drift** | Emitter-`binary_id` != View-`binary_id` | CRC64-Anker + Emitter-Gate (W3-B/Codegen-Wave) VOR Voll-Lauf |

**GN-9-Bloat-Messung je Chunk (Pflicht, in den CI-Job eingebaut, Abschnitt 7)**: nach dem Chunk-Bau die
Groessen-Summe + Median je DLL messen und LITERAL loggen, damit die 131k-Extrapolation belegt ist statt
geraten:

```
# je Chunk (provision-only, nach dem Bau):
count=$(find "$DLL_DIR" -name 'perm.dll' | wc -l)         # gebaute DLLs im Fenster
bytes=$(find "$DLL_DIR" -name 'perm.dll' -printf '%s\n' | awk '{s+=$1} END{print s+0}')
echo "GN-9 chunk[$START:$CNT]: dlls=$count bytes=$bytes  extrapolation_131072=$(( bytes / (count>0?count:1) * 131072 )) B"
```

Grobkalibrierung (Annahme 0,5 MB/`.so`): 131072 * 0,5 MB ~= **65 GB** -> Disk ist der harte Deckel; der
Storage-Offload (Ebene B) + `.obj`/Log-Nicht-Persistenz sind NICHT optional fuer den Voll-N-Bau.

---

## 6. ce-Naht-Patches (GO-pflichtig; als Report-Text, NICHT gebaut -- Owner profile_facade = W3-B)

Diese Nahtstellen liegen im `profile_facade` (Owner W3-B) bzw. sind der GO-pflichtige Codegen-Umbau. W3-A
baut sie NICHT (Regeln 8 + 9). Sie sind hier als Bau-Vorlage dokumentiert.

### 6.1 Chunk-Fenster + provision-only in `run_profile` (profile_run_entry.hpp)

- Neue `RunProfileArgs`-Felder (additiv, Default = Ist-Verhalten): `std::size_t golden_range_start = 0;`,
  `std::size_t golden_range_count = 0;` (0 = kein Fenster), `bool provision_only = false;`.
- Im Basis-Pass (`run_selection_pass`, non-deep Zweig ~`:391`): wenn `golden_range_count > 0`, die
  Selektion ersetzen durch `select_explicit(iota(start, min(start+count, view.size())))` statt
  `profile_make_basis`. Byte-identisch fuer `count==0`.
- provision-only: ein `LazyRunConfig::provision_only`-Flag, das `run_lazy_static_then_dynamic` nach
  `provision_all` (DLLs stehen) VOR der Mess-Phase zurueckkehren laesst (nur Bau, kein Messen, keine CSV-
  Mess-Zeilen). Byte-identisch fuer `provision_only==false`.

### 6.2 Treiber-Verdrahtung (Code/02_messung_driver/main.cpp, ce-build_orchestrator-Umfeld)

- `pa.golden_range_start/count` aus `COMDARE_GOLDEN_N_RANGE="start:count"` parsen (analog
  `COMDARE_E4_CAP`, `main.cpp:712`); `pa.provision_only` aus `COMDARE_GOLDEN_N_PROVISION_ONLY=="true"`.
- Inert-by-default: ohne die Vars byte-identisch zum Ist-Lauf.

### 6.3 Lazy-Per-Index-Emitter (der Codegen-Umbau, Abschnitt 1)

- Neuer Header `lazy_adhoc_source_gen.hpp` (Materialisierungs-Domaene), `make_lazy_adhoc_source_gen()` als
  zusaetzliche `SourceGenFn` in `make_union_source_gen` (`profile_run_entry.hpp:216`). Gate:
  `test_lazy_adhoc_source_gen` (Round-Trip gegen CRC64 + Stichprobe). Owner der Test-Registrierung = W3-B
  (`tests/unit/CMakeLists.txt`); W3-A/C reichen die Registrierung als Report-Text.

---

## 7. CI-Job (super .gitlab-ci.yml -- Owner W3-A; AUSGEFUEHRT)

Die einzige in diesem Paket ausgefuehrte Code-Aenderung. Alles opt-in/inert-by-default (Anti-Phantom).

1. **`build:golden-n` Stufe 1 (`--validate`) UNVERAENDERT** -- der §33-Pre-Flight-Beweis bleibt der
   ausfuehrbare Anker.
2. **Stufe 2 (opt-in, `COMDARE_BUILD_GOLDEN_N_RANGE="start:count"`)**: solange der ce-Emitter + die
   Chunk-Naht (Abschnitt 6) NICHT gebaut sind (GO-pflichtig), ist Stufe 2 ein INERTER, EHRLICHER Scaffold:
   sie prueft die Vars, druckt das INTENDIERTE Verhalten (Fenster, provision-only, GN-9-Report-Form,
   Storage-Push-Bedingung) und meldet HART, dass der Chunk-Bau die INC-G6-ce-Naht braucht (kein Fake-Bau,
   kein Erfolgs-Haken ohne reale DLLs). Sobald die ce-Naht landet, wird der `echo`-Block durch den realen
   Aufruf ersetzt (`comdare-messung-driver experiment_config <out>` mit `COMDARE_GOLDEN_N_RANGE` +
   `COMDARE_GOLDEN_N_PROVISION_ONLY=true` + GN-9-Report + `cache_push` bei `COMDARE_STORAGE_CACHE`).
3. **`interruptible: false`** auf `measure:smoke`, `measure:golden-320`, `build:golden-n` (Belt-and-
   Suspenders zu projekt-seitigem `auto_cancel=disabled`): ein mehrtaegiger Mess-/Bau-Lauf darf NIE durch
   einen Folge-Commit auto-gecancelt werden (Memory: prod_ci_measurement_multiday_experiment).

---

## 8. TABU / Anti-Phantom-Konformitaet

- CRC64-Anker `kNewGolden131072Crc64` + `static_assert(...==131072)` + `golden_fullpilot_320` UNBERUEHRT.
- GN-2-Guard (`kMaxMaterializableCatalogCardinality=4096`) UNBERUEHRT -- INC-G6 umgeht ihn NICHT, sondern
  baut den lazy Per-Index-Emitter DANEBEN (geht nie durch `build_pilot_source_map`).
- Alle neuen Nahtstellen opt-in/inert-by-default; ohne die Env-Vars byte-identisch zum Ist-Lauf.
- Benannte Muster (Builder, Flyweight-Tabellen, Lazy View-Spiegel), CT-Doktrin, kein `std::variant` fuer
  statische Achsen (F8-Hybrid-Ausnahme SPAETER), kein Python.
- Regel 8: der Codegen-Umbau + die Chunk-/provision-only-Naht sind GO-pflichtig -> gemeldet, NICHT gebaut.
