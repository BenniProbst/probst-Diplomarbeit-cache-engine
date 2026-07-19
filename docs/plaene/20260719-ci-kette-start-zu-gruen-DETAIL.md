# CI-DETAIL-KETTE — START → GRÜN (vollständige innere Abläufe, top-down verfolgt)

> 2026-07-19. Quellen: `.gitlab-ci.yml` (voll, 746 Zeilen) · `docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md` · `docs/plaene/20260719-gesamt-roadmap-ledger-diff-ROADMAP.md`. Alle datei:zeile-Anker LIVE gegen den Baum verifiziert (Stand ce HEAD 5da2caf7 / super HEAD 1a8b95e, Pipeline 11278 grün).
> Pfad-Konvention: `CE/` = `Code/external/comdare-cache-engine/`. Status je Stufe/Schritt: **[FERTIG]** / **[TEILWEISE]** / **[FEHLT→Roadmap-Ref]** (Refs = ROADMAP-B-Tabellen PL-*/GN-*/ST-*/K-*/M-*).
> Zwei Lauf-Modi derselben Pipeline: **Gesamtlauf** (Default, CI-Grün = Messung AUS — Stufen 0+1-Preflight+4-Selbsttests) und **Messlauf** (opt-in `COMDARE_MEASURE_PROFILE=smoke` bzw. `COMDARE_RUN_MEASURE=true` — Stufen 0→1→2→3→4 komplett).

---

## Stufe 0 — Pipeline-Start / Lint / Orchestrate / verify:submodules / Build-Fläche — **[TEILWEISE]**

### 0.1 Workflow-Gate + Stage-Topologie — [FERTIG]
- `.gitlab-ci.yml:16-23`: workflow.rules — Tags nie; MR/web/pipeline/branch ja.
- `:25-35`: 10 Stages in Ordnung `lint → orchestrate → submodules → analyse → test → integration → manifest → thesis-pdf → measure → persist`. **Beachte: `thesis-pdf` liegt VOR `measure`** — Konsequenz siehe 4.7/M-6.

### 0.2 Submodul-Beschaffung (REV 17, default:before_script) — [FERTIG]
- `:62-81`: Guard (`.gitmodules` + inside-work-tree) → für die 3 Submodule (ce, prt-art, thesis) Deploy-Token-URLs (`CE_SUBMODULE_USER/TOKEN`, read_repository) DIREKT in `.gitmodules` schreiben (`:74-77`) → `git submodule sync --recursive` + `update --init --recursive` (`:78-79`) → `.gitmodules` restaurieren (`:80`). `GIT_SUBMODULE_STRATEGY: none` (`:93`) schaltet das failende Runner-Auto-Fetch ab. Lint-Jobs erben den Block NICHT (eigenes before_script), `persist:measurements` überschreibt ihn (`:629`).
- Input: CI-Vars CE_SUBMODULE_USER/TOKEN (masked). Output: recursive Checkout. Fehlerklasse: Klon-Fehler = Job rot (Infra-Auth).

### 0.3 Cache + globale Variablen — [FERTIG]
- `:85-91` ccache projektlokal (`.ccache`, 3G, dev-MinIO runners.cache); `:95` `CMAKE_BUILD_PARALLEL_LEVEL=6`; `:96-100` Lint-Pfade/Excludes.

### 0.4 Stage lint — [FERTIG]
- `toolchain:probe` `:105-107` (Compiler-Inventar, #273); `lint:secrets`/`lint:format`/`lint:static` `:123-137` (je `GIT_SUBMODULE_STRATEGY:none`, nur super-Code). Gate: `lint:secrets` ist das harte Vor-Gate für orchestrate + submodules (needs `:160/:170/:180/:193`).

### 0.5 Stage orchestrate — die 3 Modul-Pipelines als Gate — [FERTIG]
- `trigger:cache-engine` `:158-167`, `trigger:prt-art` `:168-177`, `trigger:thesis` `:178-187`: downstream multi-project Pipelines mit `strategy: depend` (Bridge spiegelt Kind-Status → super wird ROT wenn ein Modul rot). `forward: yaml/pipeline_variables:false` (Module laufen im eigenen Kontext). GRÜN-Kriterium: alle 3 Kind-Pipelines grün.
- **[FEHLT→K-16]**: ce-Pipeline trägt noch `allow_failure`-Jobs (ce `.gitlab-ci.yml:124/:360` u.a.) — Drift gegen „gesamte Pipeline hart grün".

### 0.6 verify:submodules — [FERTIG]
- `:190-208`: `git submodule status` + Existenz-Gates (ce/prt-art CMakeLists, thesis-.tex) + **REV-CI-04-Gitlink-Determinismus** `:203-208`: jedes `-`/`+`/`U`-Präfix (nicht initialisiert / abweichender Commit / Merge-Konflikt) → `exit 1`. GRÜN-Kriterium: alle Submodule exakt auf ihrem Gitlink-Commit.

### 0.7 Build-Fläche (analyse/test/integration) — [TEILWEISE]
- `analyse:thesis-data` `:211-225`: optionaler ce-Artefakt-Fetch (`:217`) → `cmake -B build -G Ninja -DCOMDARE_V32_ENABLE=ON -DCMAKE_BUILD_TYPE=Release` (`:222`) → baut die 4 Werkzeuge `comdare-messung-driver comdare_binary_to_csv comdare_csv_to_latex comdare_diagram_generator` (`:224`). Kein Artefakt (Beleg = Log).
- `build:clang` `:113-121` (#273 neueste-clang-Pflicht, Target `comdare_da_tools`).
- `visibility:tier-binaries` `:233-254`: Configure triggert den ce-Permutations-Codegen → `build-visibility/generated/permutations_manifest.txt` (`:248-249`, Gate: nicht-leer sonst exit 1) → `tier-binary-report --visibility` (`:251`) surfaced geplante/gebaute/offene Tier-Binary-Rekombinationen im Log. Hart, kein allow_failure.
- `test:unit` `:144-152`: Target `comdare_da_unit_tests` + `ctest -L da_unit` (volle super-Unit-Suite, hart).
- `integration:smoke` `:262-292`: baut 01/03/04/05-Tools → reale Kette Fixture `record.bin → CSV → LaTeX-Tabelle` + `CSV → TikZ` (`:282-285`), Leere-Datei-Gates `:286-288`.
- **[FEHLT→K-4/L5]**: 3 build-i2-Tests (smoke/measurement/wdk) stale-rot + falscher generated-Include-Root im super-Sub-Build — läuft NICHT in dieser Pipeline; aktiver hart-grün-Direktiv-Bruch.

### 0.8 manifest + prebackup — [FERTIG]
- `manifest:provenance` `:299-344`: EINE Datei `manifest_out/build_manifest.txt` — super-SHA, alle Submodul-SHAs (recursive), Toolchain, OS/ISA, Profil-XML-Hash der ce (`:327-336`). Artefakt 12 Wochen.
- `prebackup:measurements` `:350-393`: reiner Mechanismus-SELBSTTEST (additiv + sha256 + Overwrite-Schutz rc=3, `:363-386`), bewusst in `prebackup_selftest_store/` (Anti-Phantom, nie im measurement/-Baum).

### 0.9 CI-YAML-Herkunft — **[FEHLT→PL-1/I3]**
Die gesamte Pipeline ist HAND-maintained; der geplante `CiYamlBuilder` (Planer-I3, Child-Pipeline via `trigger:include:artifact:`) existiert nicht — der Planer emittiert heute weder CI noch CMake-Graph. Ebenso **[FEHLT→M13/#276]**: die 3-ISA-/8-Distro-Voll-Matrix ist bewusst ALLERLETZT.

**GRÜN-Kriterium Stufe 0:** Lint grün + 3 Modul-Pipelines grün + Gitlink exakt + 4 Tools bauen + Manifest nicht-leer + Unit-Suite grün + Smoke-Kette E2E belegt.

---

## Stufe 1 — PLANER (comdare-messung-driver: XML-Parse → Validierung → Projektion → Baum) — **[TEILWEISE]**

Programm: `comdare-messung-driver` (super `Code/02_messung_driver/main.cpp`), gebaut in `measure:smoke`/`measure:golden-320` mit `-DCOMDARE_V32_ENABLE=ON -DCOMDARE_ENABLE_PMC=ON -DCMAKE_BUILD_TYPE=Release` (`.gitlab-ci.yml:491-493` / `:572-574`).

### 1.1 --validate-Preflight — [FERTIG]
- CI-Gate: `"$DRIVER" --validate || exit 1` (`.gitlab-ci.yml:501` Smoke / `:581` golden) — VOR jedem (mehrtägigen) Lauf.
- `main.cpp:291-296`: Profil-Pfad = argv > `COMDARE_THESIS_PROFILE` > gebackenes `COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE`. (Smoke-Job pinnt `COMDARE_THESIS_PROFILE` auf `m3_smoke_coverage.profile.xml`, CI `:477`.)
- `main.cpp:305-310`: Root-Tag-Sniff rein-lesend über common-DOM (`xml_reader.hpp`, Include `:39`).
- `<comdare_thesis_profile>` → `validate_profile_facade` (`main.cpp:312` → `CE/libs/cache_engine/profile_facade/profile_run_facade.cpp:408`).
- `<comdare_experiment>` → `validate_experiment_profile_facade` (`main.cpp:313-316` → `profile_run_facade.cpp:436`) mit den per CMake einkompilierten STATISCHEN Registry-Pfaden `COMDARE_CE_AXIS_REGISTRY_PATH`/`COMDARE_PRT_AXIS_REGISTRY_PATH` (2-Registry-Kanon); fehlen die Defines → rc 5 (`:317-322`).
- Unbekannte/unlesbare Wurzel → rc 5, KEIN Bau (`:324-327`). Fehlerklasse: Profil-Fehler bricht VOR dem Lauf ab (CI-Echo „Abbruch vor mehrtaegigem Lauf").

### 1.2 XML-Parse (Interpreter-Kern) — [FERTIG]
- `CE/libs/common/serialization/xml_config_parser/xml_config_parser.hpp`: `struct ThesisProfile` `:195`, `struct ExperimentProfile` `:300`, `parse_thesis_profile` `:332`, `parse_experiment_profile` `:338`. Beide liefern `nullopt` bei Fremd-Tag (macht den Root-Sniff gefahrlos).
- E4-Run-Block `main.cpp:594-737`: Profilwahl `:599-601` → `ArtifactCache::from_env()` `:625` (Storage #51, INERT-Default) + `cache_push`/`measurement_sink`-Lambdas `:628-638` → Root-Tag-Dispatch `:647-654`:
  - `<comdare_experiment>` → `ExperimentRunArgs` befüllen `:656-675` (out_csv = `e4_xml/measurements.csv` E8 `:658`, Registry-Pfade `:661-663`, build_version `m3v2` `:664`, Platform/Load-Dir/Caps/Overrides `:665-673`, Storage-Fns `:674-675`) → `run_experiment_profile_facade` `:679`; exit≠0 → e4_overall_rc (`:683-686`), Lauf-Fazit geloggt `:680-682`.
  - sonst (Thesis-Weg) → `ProfileRunArgs` `:694-718` → `run_profile_facade` `:722`.
- **[FEHLT→PL-4]**: `<metadata><mode>` wird nie konsumiert (env-Bypass `COMDARE_*`); **[FEHLT→PL-5/PL-6]**: Kanal-Konvergenz Experiment- vs ThesisProfile (nur Experiment-Kanal hat opt/simd-XML; 4 von 6 System-Achsen ganz ohne XML-Kanal); **[FEHLT→GN-3]**: `all_axes_golden.profile.xml` nicht an den Lauf-Pfad gedockt.

### 1.3 Registry-Validierung — [FERTIG]
- `CE/libs/cache_engine/profile_facade/validate_profile.hpp`: `axis_registry_from_levels` `:105-108` formt `build_all_axis_levels()` (reflect_names über die EnabledStrategies, `registry_to_axis_levels.hpp`) in die AxisRegistry; `validate_profile` `:126-140` prüft jede `<axis ref>` gegen bekannte Achsen+Werte (`:174-175`); Mess-Kategorien single-source aus `kMeasurementAxisRegistry` (`:55/:300`). `validate_experiment_profile` `:372ff` prüft zusätzlich: ≥1 Phase, je-engine-Registry-Dateien existieren UND als `comdare_axis_registry` lesbar (F28-Härtung `:382-385`).
- **[FEHLT→PL-7]**: Phasen-Kardinalität >3 / Serien-Envelope / Reihe-C-Design; **[FEHLT→PL-9]**: n_repeats≥3-Pflicht-Validierung fehlt.

### 1.4 Projektion — [FERTIG]
- `CE/libs/cache_engine/profile_facade/experiment_run_entry.hpp:144` `run_experiment_profile` (DIE EINE deklarative comdare_experiment-Lauf-API, Brücke-I4): `parse_experiment_profile` `:149` (nullopt → Abbruch `:151-153`) → **`project_experiment_to_sota_passes(ep)`** `:160` (sota_catalog.hpp, REINER Enumerations-/Render-Schritt, je `<phase>` die (merge×lebewesen)-Pässe → `ExperimentPhaseProjection`) → `${date}`-Auflösung der `<output>`-Pfade NUR als Lauf-Provenienz-Log `:163-169` (autoritativ bleibt `a.out_csv`) → `make_union_source_gen(generated_make_catalog_source_gen(), fused_sota_map)` `:186` = EINE SourceGenFn.
- **[FEHLT→PL-12]**: „CEB schreibt SELBST ans XML-Ziel" nicht erfüllt — `<output>` bleibt Provenienz-Log.
- v32-Alternativstrecke (NICHT der Live-Pfad): `PhaseStrategyFor` (`Code/02_messung_driver/experiment_phase_strategy.hpp:166`) + `execute_messreihe` (`v32_messreihe_antrieb.hpp:259`, VOLL implementiert) — DEPRECATED-BY-DESIGN (`:2`) + doppelt gegatet `COMDARE_V32_DRIVER_ENABLE && COMDARE_MEASUREMENT_ON` (`main.cpp:335-341`), Stub in `v32_orchestrator.hpp:92`. **[FEHLT→PL-0]**: Phase-0-Reconcile (Skelett wiederverwenden statt 3. Engine).

### 1.5 Baum-Bau — [FERTIG]
- `CE/libs/cache_engine/builder/experiment_tree/profile_to_tree.hpp:27` `build_axis_levels(tp, …)` (Thesis-Pfad; emittiert seit `:87` auch die dynamischen Dimensionen selbst — keine Doppelquelle) → `ExperimentTree` (`experiment_tree.hpp:327`, Factory-basiert `:329`).
- `StaticBinaryView` `experiment_tree.hpp:236-315`: mixed-radix-Bijektion Index↔Achsen-Pfad, `operator[](i)` dekodiert genau EINEN Pfad on-demand (`:21` — der Orchestrator hält nie alle ∏); `static_binary_view()` `:459`.
- Selektion: `select_explicit({…})` (`coverage_selection.hpp:66`) — im Experiment-Pfad je Pass `select_explicit({0})` (EIN Lebewesen je Reihe, `experiment_run_entry.hpp:316`).
- **[FEHLT→K-1]**: `profile_to_tree.hpp:70-82` pusht JEDEN `<axis ref>` als statisches Level — struktureller Organ-only-Guard fehlt (`is_organ_axis_label` ungenutzt). **[FEHLT→PL-3]**: CoR `run_selection_filter_chain` (`selection_filter_chain.hpp:87`) hat nur den Test als Konsument; Andockpunkt `resolve_selection` ist NEU. **[FEHLT→PL-13]**: System-Achsen flach im selben Vektor statt umschließender Baum-Schicht (nach 28.07., nicht golden-neutral).

### 1.6 Planer-Kopf (Director/Builder/Vertragsgrenze) — **[FEHLT→PL-1]**
Es existiert KEIN Director-Typ, kein `IPlanBuilder`, kein `comdare_experiment_planner`-Executable, keine Planer↔CEB-Vertragsgrenze (`IExperimentDock`/Registry) — der „Planer" ist heute der musterlose 5-tiefe Schleifennest `experiment_run_entry.hpp:257-365` (Bauplan Phase 1, Forks A–E User-GO offen).

**GRÜN-Kriterium Stufe 1:** `--validate` rc 0 (beide Wurzeln) + Parse/Projektion liefern ≥1 Pass + Baum-Bijektion konsistent (Roundtrip-Tests grün).

---

## Stufe 2 — CEB (System-Achsen-Bestückung → provision_all → Storage-B-Push) — **[TEILWEISE]** (Kern FERTIG, Vertrag+Infra offen)

### 2.1 System-Achsen-Bestückung (WAS/WIE-Injektion) — [FERTIG als Closure]
- `profile_run_facade.cpp:494` `run_experiment_profile_facade`: (1) `validate_experiment_profile_facade` `:500` (Preflight in-Prozess wiederholt) → (2) Experiment-XML für `<workloads>` parsen `:508-517` (0 gültige Lastprofile ⇒ Abbruch exit 4, Achse 2 nie still leer) → (4) der EINE Compile-Injektionspunkt: `compile_for_perm`-Fabrik `:560-568` (Closure über include_dirs/defines/cxx/link_libs/fno_gnu_unique → je Perm `make_gpp_compile_fn(…, opt_flag, march)`), `algo_sig` aus `compose_algo_signature` + Achsen-Versions-Tabelle `:574-576`, Fallback-Einzel-CompileFn (CEB-Default **O3**, Ruling 2026-07-18, `:254/:579`).
- Thesis-Weg analog: `run_profile_facade` `:317` — EIN `make_gpp_compile_fn` `:365` + `system_axes_version_suffix()` `:293` (`+cxx=+opt=+ext=`) in `build_version` `:381`.
- **[FEHLT→PL-2]**: `CebSystemAxisDrive`-Vertrags-POD (Spiegel `SearchAlgorithmDrive`) statt host-vorgebackener `std::function`-Closure — parallel zu Phase 1 machbar. **[FEHLT→GN-1]**: aktiver `extension_hardware`-Familien-Knoten (einzige Klasse mit Label ist DEPRECATED). **[FEHLT→Fork A]**: CEB als echte dlopen-.so (heute in-Prozess).

### 2.2 opt×simd-Permutations-Schleife — [FERTIG]
- `experiment_run_entry.hpp:263-267`: `opt_perms × simd_options` (leer → `{"default"}`); je Perm eigene CompileFn (`a.compile_for_perm(opt,simd)`) + `perm_suffix` → `perm_build_version = a.build_version + perm_suffix` `:289` (Sidecar) und `perm_tag_build_version` `:290` → CSV-Provenienz-Spalte `cfg.row_build_version` `:337`.
- Invariante belegt: opt/simd fließen NIE in `binary_id` (`:254ff` „binary_id BLEIBT Organ-only, Q2 Option C") — nur die MESS-Matrix wächst.
- Je (Phase×Pass×Perm): `select_explicit({0})` `:316` → `cfg.build_version = perm_build_version` `:329` → `run_lazy_static_then_dynamic(sota_tree, sel, perm_compile, …)` `:352`.

### 2.3 provision_all — paralleler Tier-Binary-Bau — [FERTIG]
`CE/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp` (ctor `:227-228` injiziert `CompileFn :126` / `SourceGenFn :127` / `FreeRamFn` / `AlgoSigFn :133`; achsen-blind, registry-frei):
1. Einstieg `provision_all(view[, selection], stats)` `:236/:243` → `provision_core` (O(K)-Results, nie O(∏), `:256ff`), jthread-Worker-Pool `:407-410`.
2. Je Binary: `spec = view[i]` on-demand dekodiert; per-Binary-Ordner `output_dir/<stem>/perm.{cpp,dll}` `:304-318` (MAX_PATH-sicher, Dateien kurz).
3. Organ-Signatur `algos = algo_sig_(spec.axes)` `:323-325` (leer ⇒ Organ-Gate aus, byte-neutral).
4. **(A) Inkrementeller Skip**: `dll_is_current(output, build_version, algos)` `:332-337` → `:192`: DLL existiert ∧ `.version`-Sidecar == System-Version (`:179`) ∧ (falls gefordert) `.algos`-Sidecar == Organ-Signatur (`:185`) ⇒ `skipped` (Resume nach Absturz; #50-Cache).
5. **(B) RAM-Admission** `:340-357`: (active+1)×Budget ≤ Start-Baseline + dynamischer free_ram-Check; mind. 1 Build läuft immer.
6. **(C) Codegen+Compile** `:359-370`: `gen_(spec.binary_id)` schreibt `perm.cpp` (SourceGenFn = `make_union_source_gen(generated_make_catalog_source_gen(), fused_sota_map)` aus 1.4 — der Katalog-Codegen selbst läuft Configure-Zeit über `cmake/catalog_codegen.cmake` + `apps/adhoc_emitter`/`cmake/adhoc_emitter.cmake`); dann `compile_(job)` (POSIX: `make_gpp_compile_fn` `:546` — realer g++-Subprozess `perm.cpp → perm.so/dll`).
7. **Fehlerklassen-Übersetzung** `:371-392` (D1-Carrier + INC-29.2): exit 0 → ok; 127 → `InfraErrorClass::ProzessStart`; 125 → `ArtefaktIo`; <0/≥128 → `ProzessAbbruch` (137=OOM-Kill, 139=SEGV — NIE Compiler-Urteil); sonst → `CompilerCompilerErrorClass::CompileKombination` (D1). Harness misst weiter, kein Abbruch.
8. Bei Erfolg: `write_version_sidecar` (System-Provenienz) + `write_algos_sidecar` (Organ-Provenienz) `:394-396` — die zwei getrennten Sidecars `perm.dll.version`/`perm.dll.algos`.
- Inputs: StaticBinaryView, BuildConfig(build_version, per_binary_subdirs, RAM-Budget). Outputs: `<stem>/perm.dll` + 2 Sidecars + BuildStats (built/skipped/failed, peak_concurrency, min_free_ram `:412-425`).
- **[FEHLT→K-9]**: `ToolchainFehlt` (D1) definiert, aber kein Emitter — fehlender Compiler landet als ProzessStart/127. **[FEHLT→GN-2]**: negativer Instanziierungs-Guard gegen 2¹⁷-Voll-Materialisierung. **[FEHLT→GN-5]**: `reflect_versions<alle 17>`-Instanziierungstest im Default-ctest (Stale-Green-Wurzel).

### 2.4 Storage-Ebene-B-Push (minio, Tier-Binary-Cache) — [FERTIG CE-seitig, INERT; Infra offen]
- Naht: `cache_engine_builder_iterator.hpp:931-946` — SYNCHRON, per-Binary, im 1-Thread-Mess-Loop, NACH `result.csv`+Stamp, VOR RAII-DLL-Unload: `cfg.cache_push(bin_dir, cfg.build_version)` `:939` → `ArtifactCache::push_tier_binary` (`artifact_transport/artifact_cache.hpp:102`): mc-Client, `perm.dll` ZUERST, `perm.dll.version` ZULETZT (Key-Ableitung). `from_env()` `:76` = No-Op ohne Env (golden byte-identisch).
- CI-Scharfschaltung: `.storage_cache_activation` `.gitlab-ci.yml:439-469` — nur bei `COMDARE_STORAGE_CACHE=true`; mc-Alias `prodcache` aus `MINIO_ACCESS_KEY/SECRET_KEY/COMDARE_MINIO_ENDPOINT/_BUCKET` (Creds via `MC_HOST_<alias>`, nie argv). Fehlerklasse: mc fehlt / Vars unvollständig ⇒ Ebene inert + `[Infra-Fehler]`-Log, **Messung läuft weiter**.
- **[FEHLT→ST-2]**: Infra-Handout P1–P6 (prod-MinIO V91, Bucket, mc im Runner-Image, CI-Vars Projekt 288). **[FEHLT→ST-3]**: E2E-Probe `COMDARE_STORAGE_CACHE=true` literal belegen. **[FEHLT→ST-4]**: V60/V80-Verortung.

**GRÜN-Kriterium Stufe 2:** alle selektierten Binaries `ok∨skipped` (BuildStats.failed nur als ehrliche D1-Zellen weitergetragen), Sidecar-Paare konsistent; im Gesamtlauf: `visibility:tier-binaries` belegt den Codegen ohne schweren Bau.

---

## Stufe 3 — TIER (dlopen → Dock → Zwei-Phasen-Messung → result.csv+Stamp) — **[FERTIG]** (additive Reste offen)

Host-Treiber: `run_lazy_static_then_dynamic` (`CE/libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:694`) — verdrahtet die volle Lazy-Kette.

### 3.1 Vorbereitung + Mess-RESUME — [FERTIG]
- `:699` `dyn_dims = tree.dynamic_filter()` (der dynamische Sub-Filterbaum); `:720-725` BuildConfig inkl. `per_binary_subdirs`; `:732` `orch.provision_all(view, sel.indices, …)` (= Stufe 2).
- Resume (#139): `lazy_resume_stamp_prefix(cfg, dyn_dims)` `:749`; je Binary `binary_resume_stamp = prefix [+ "|algos=" + b.algo_sig]` `:759-760`; `lazy_try_resume_binary(dir, stamp, …)` `:644-676` prüft `result.csv.stamp` (Config-Stempel-Match + Format + Zeilenzahl) UND Header-Identität gegen `lazy_csv_header()` `:232` → vollständige+aktuelle Binaries werden übersprungen (`resumed`), Organ-Änderung (algos-Diff) erzwingt ehrliche Neu-Messung.

### 3.2 Laden über die ABI-Grenze (AnatomyModuleLoader) — [FERTIG]
- `:801-803` `AnatomyModuleLoader::load(b.output, handle)` → `anatomy_module_loader.cpp`:
  - `:40` `dlopen(path, RTLD_NOW | RTLD_LOCAL)` (Windows: LoadLibrary-Zweig).
  - `:114-117` Resolve der 4 Pflicht-Symbole `comdare_anatomy_abi_version` / `…_abi_magic` / `comdare_create_anatomy` / `comdare_destroy_anatomy`; fehlt eines → `status_symbol_missing` (`:119`).
  - `:130-132` Magic-Gate (`COMDARE_ANATOMY_ABI_MAGIC`, kodiert Major „.A6.") → `status_magic_mismatch`.
  - `:138-146` Major/Minor-Gate (Host = `COMDARE_ANATOMY_ABI_MAJOR 6`, `anatomy_module_abi_v1_decl.hpp:54`; Vertrag `host_compatible_with` `:124-127`).
  - `:148` `pfn_create()` → `IAnatomyBase*`; RAII destroy-vor-unload `:77-79`.
- Fehlerklasse: Gate-Fehler ⇒ Binary geloggt übersprungen, Lauf läuft weiter (Fehlerklassen-Doktrin).
- **[FEHLT→K-6]**: Loader reimplementiert das Gate inline statt `host_compatible_with()` zu rufen (QW). **[FEHLT→K-5]**: `best_binary_selector`-ABI-Spiegel stale (5/„.A5.") → schreibt falsche Manifest-Provenienz.

### 3.3 Dock-Vertrag — [FERTIG für SearchAlgorithm]
- `:809-812` `pruef_dock::acquire_search_algorithm_drive(handle, drive)` (statt roher dynamic_casts): Bündel obs=Pflicht / ctrl / rbk / scn (`search_algorithm_dock.hpp:63-86`); `!= dock_status_ok` ⇒ Binary übersprungen.
- **[FEHLT→PL-14]**: Multi-Gattungs-Dispatch (`PruefDockRegistry::select_for`) — heute hartkodiert SearchAlgorithm; V42-Docks (Set/Sequence/Container/Graph) additiv nach 28.07.

### 3.4 Dynamische Dimensionen (Runtime-Loop) — [FERTIG]
- `:894-903`: mit `ctrl != nullptr && !dyn_dims.empty()` → `RuntimeVariableLoop::run(*ctrl, dyn_dims, measure_under_setting)` (`runtime_variable_loop.hpp:43` — FOR-Schleife kartesisch auf der EINEN geladenen Binary, Doc 26 §2; Dims = `<runtime_dynamic>`-Knoten inkl. workload-/repetition-Dim, `LazyRunConfig :76-77`); sonst EIN Mess-Punkt „as built" (leeres Setting-Label ⇒ setting_id == binary_id).
- **[FEHLT→PL-8]**: `<measurement mode="debug|mess" threads>`-Kanal — `runtime_thread_count()` LABEL-ONLY, ehrlich auf 1 gepinnt (Mess=1-Thread-Doktrin).

### 3.5 Zwei-Phasen-Messung (save→warmup→rollback→measure) — [FERTIG]
- `CE/libs/cache_engine/harness/perm_runner.hpp:231` `run_workload_perm(tier, rollback, …)`: treibt EIN Lastprofil über `workload_driver::run_workload_profile`; Zwei-Phasen-Cache-Warmup ist PFLICHT für Gültigkeit (`:227-229`, [[feedback_two_phase_warmup_mandatory_validity]]):
  - `:281` `rb_exact = rollback_is_empirically_exact(tier, rollback)` (IRollbackableTier: save→warmup→rollback empirisch exakt?);
  - `:296` `tier_reset_statistics()` (daten-erhaltender Reset nach Load — alle Achsen-Statistiken warmup-frei);
  - `:304` `run_workload_profile(tier, rb_exact ? rollback : nullptr, ops, …)` = gemessene Phase;
  - unbekanntes Profil → Fallback `run_observable_perm` `:251` (alter fixer Workload, `two_phase_valid=false`).
- Ergebnis-Gültigkeit: `two_phase_valid` je Zeile (`cache_engine_builder_iterator.hpp:169`, CSV-Spalte `:457`).
- Fehlerklasse: Algo-Exception → `SampleStatus::Failed` (`perm_runner.hpp:334`) → CSV-Zelle **„failed"** (nie Null, INC-29.1) + Log-Zeile `:338`.
- **[FEHLT→PL-11]**: `<binary_id>.error.log`-Sidecar + aggregierter Lauf-Log neben der CSV (Teil 2 der Fehler-Sichtbarkeit). **[FEHLT→K-10]**: voller SampleStatus-Split + n/a-Renderer. **[FEHLT→K-17]**: A07-snmalloc-Laufzeit-Segfault unadressiert (bis dahin ehrliche failed-Zelle).

### 3.6 Observer-Pull (POD über die ABI-Grenze) — [FERTIG]
- `IObservableTier::tier_observe(ComdareTierObserverSnapshot*)` (`CE/libs/cache_engine/anatomy/observable_tier.hpp:179`; POD `:128-149`: standard_layout + trivially_copyable, sizeof==1272 nach INC-2d `:125`, memcpy-Semantik) → 175 Felder in die Mess-Zeile (`perm_runner.hpp:49`).
- **[FEHLT→K-2]**: `static_assert(sizeof==1272)` fehlt (nur Laufzeit-EXPECT; QW ~10 min).

### 3.7 PMC — [FERTIG, Flag-gated]
- `CE/libs/cache_engine/builder/pmc_source_factory.hpp:19/:32`: `COMDARE_ENABLE_PMC && __linux__` → `LinuxPerfPmcSource` (`linux_perf_pmc_source.hpp`: `perf_event_open(2)` als Kernel-Syscall, kein glibc-Wrapper `:26/:39`); ohne Flag → NullPmcSource ⇒ `pmc_available=0`/honest-0. Die Mess-Jobs bauen mit `-DCOMDARE_ENABLE_PMC=ON` (CI `:491/:572`; prod1-Rechte bewiesen, Job 189916).
- **[FEHLT→M-12]**: branch_misses/IPC fehlen im Record-Schema (FF3-Metriken; I-PMC-2/3).

### 3.8 result.csv + Stamp je Binary — [FERTIG]
- `:906-918`: per-Binary `result.csv` = `lazy_csv_header()` + alle Zeilen DIESER Binary (`format_csv_row` `:335`), stream-verifiziert.
- `:920-928` (GOAL-M1.4): `result.csv.stamp` (= `binary_resume_stamp|rows=N`) NUR wenn (a) Write verifiziert, (b) vollständig (rows == settings), (c) JEDE Zeile `two_phase_valid` — sonst Stamp entfernt (`:926`, stale nie stehen lassen; ungültige Messungen nie als „fertig" eingefroren).
- Danach Storage-Naht (2.4) und RAII-DLL-Unload.

**GRÜN-Kriterium Stufe 3:** jede selektierte Binary geladen∨(ehrlich geloggt übersprungen/failed); `two_phase_valid`-Quote 100% für Stamp; CSV-Zeilen für alle (Binary×Setting)-Punkte, „failed" statt Lücke.

---

## Stufe 4 — AUSWERTUNG (CSV → WIDE → Anhang-.tex → persist → PDF) — **[TEILWEISE]**

### 4.1 Die EINE offizielle CSV — [FERTIG]
- `experiment_run_entry.hpp:230` öffnet `a.out_csv` (= `measure_out*/e4_xml/measurements.csv`) trunc, Header genau EINMAL, alle Phasen darunter; `:376` whole-run `measurement_sink(out_csv, "measurements.csv")` (Ebene C, No-Op-Default).
- CI-Beleg-Gates: `find … measurements.csv` + Abbruch wenn keine erzeugt (`.gitlab-ci.yml:505-506` Smoke / `:585-586` golden).

### 4.2 WIDE-Aggregat — [FERTIG, shell-seitig]
- CI `:512-517` (Smoke) / `:594-599` (golden): alle per-Binary `result.csv` sortiert konkat后enieren — Header einmal + alle Datenzeilen → `wide_aggregate.csv` (Intermediate, wird nach Anhang-Regen gelöscht `:521/:603` — per-Perm-Rohmaterial bleibt).

### 4.3 Anhang-Regenerierung (#24) — [FERTIG; Zähl-Kommentar-Drift]
- CI baut `appendix_generator_cli` `:509/:591`; Aufruf `"$APP" WIDE out/appendix --langs=de,en` `:519/:601` — Fehlschlag = „honest-empty/Teil-Output — kein Fehler".
- `Code/08_appendix_generator/appendix_generator.cpp`: je Sprache (de+en, `appendix_generator.hpp:50`) **12 Kern-.tex** (`:50-93`: bias_matrix 1 + lc_surface 6 + ld_exchange 4 + le_limitierung 1) + **5 Darstellungs-.tex** (`:108` seg_attribution, `:116` latency_range, `:122` latency_ecdf, `:129` exchange_forest, `:140` observer_detail) — honest-empty: `status_empty_input` ⇒ Datei ausgelassen, KEIN Facade-Fehler (`:139-147`).
- **[DRIFT→K-12]**: CI-Kommentare „16 Darstellungs-.tex" (`.gitlab-ci.yml:530/:588/:612`) stale — real 12+5 je Sprache.
- **[FEHLT→M-4]**: 17-Achsen-Nachzug super-Stufen 04/05/08 — `kSegmentCount=20` hartkodiert MIT seg_isa/seg_telemetry (`05_diagram_generator/diagram_generator.hpp:182`) ⇒ bei 17-Achsen-WIDE `has_seg_ns=false` ⇒ **seg_attribution.tex wird NIE erzeugt**; VOR der Lauf-Auswertung fixen. **[FEHLT→M-8/M-9/M-15]**: Sensitivitäts-Writer, 4 Heuristik-Kurven-Writer (parametrisch übersprungen), Welch-Stufe.

### 4.4 measure-drop-C-Sink — [FERTIG CE-seitig, INERT; Infra offen]
- Per-Binary: `cfg.measurement_sink(result.csv, "<stem>/result.csv")` (`cache_engine_builder_iterator.hpp:940-944`); whole-run: `experiment_run_entry.hpp:376` → `ArtifactCache::sink_measurement` (`artifact_cache.hpp:133`, HTTPS-PUT, Token nur via 0600-curl-config). CI-Aktivierung `:461-466`; Vars fehlen ⇒ Ebene C inert (Git-Writeback bleibt Persistenz-Pfad). **[FEHLT→ST-2/ST-3/ST-5]**.

### 4.5 Job-Artefakte — [FERTIG]
- `measure:smoke` `:527-532` / `measure:golden-320` `:609-614`: NUR `**/*.csv` + `appendix/**/*.tex` (nie DLLs), when: always, 12 Wochen.

### 4.6 persist:measurements (#22) — [FERTIG-INERT; Erstbeweis offen]
- `:626-746`, Stage persist. Rules `:651-654`: bot-Login nie; nur `COMDARE_PERSIST_MEASUREMENTS==true && branch==development`. needs: thesis:pdf (optional), manifest:provenance, measure:golden-320/smoke (optional, mit Artefakten). Kein Submodul-Klon (`before_script: []` `:629`), voller Klon `GIT_DEPTH:0` `:634` (merge-base).
- Ablauf: (0) INERT-Guards + Credential-Pflicht `:658-664` → (1) Laufordner `measurement/<YYYYMMDD-HHMMSS-p<pipeline>>/` `:666-667` → (2) `prebackup()` additiv+sha256+nie-überschreiben `:670-681` → (3) einsammeln: PDFs, build_manifest.txt, `measure_out*/`-CSV+.tex strukturerhaltend (`.gitignore`-Negation macht sie trackbar) `:682-712`; Anti-Phantom: Selbsttest-Store NIE dabei `:686-691` → PROVENANCE.txt `:713-720` → (4) Writeback `:723-745`: origin auf Write-Token, checkout origin-Tip, `git add measurement/`, Commit `[skip ci]`, `push -o ci.skip`; non-ff ⇒ fetch+**MERGE** (nie rebase)+Retry ×5; Merge-Konflikt ⇒ echter Bug, Abbruch ohne --force. Loop-Schutz DREIFACH (ci.skip + [skip ci] + bot-rule).
- **[FEHLT→M-3]**: erster realer `measurement/<ts>/`-Ordner (DoD-6-Beweis) steht aus.

### 4.7 thesis:pdf — **[TEILWEISE→M-5/M-6]**
- `:396-413`: gated `COMDARE_TEXLIVE_AVAILABLE=="true"` (Infra P1c); Toolchain-Gate `:405`; main-tex per `\documentclass`-Grep; `latexmk -pdf -halt-on-error` `:408`; PDF-Artefakt 4 Wochen.
- **[FEHLT→M-5]**: baut nur EIN PDF (Default de) statt bilingual DE+EN; TeXLive-Gate = Infra.
- **[FEHLT→M-6]**: Kettenende NICHT geschlossen — `needs: ["analyse:thesis-data"]` und Stage `thesis-pdf` liegt VOR `measure` ⇒ das PDF eines Mess-Laufs enthält NIE die frisch regenerierten Anhang-.tex; kein Copy-Back der .tex ins Thesis-Submodul (INC-7/F10 Overleaf-Sync). **[FEHLT→M-7/M-10/M-11]**: Haupt-Text-\inputs auskommentiert, FF-Antworten „steht aus".

**GRÜN-Kriterium Stufe 4:** Gesamtlauf: manifest+prebackup grün, persist/measure existieren nicht (INERT). Messlauf: measurements.csv nicht-leer + Anhang-Regen gelaufen (honest-empty erlaubt) + Artefakte hochgeladen + (bei PERSIST-Opt-in) Push nach development mit ci.skip erfolgreich.

---

## GRÜN-Kriterien-Kette (Gesamtbild)

| Stufe | Job(s) | GRÜN heißt | Status |
|---|---|---|---|
| 0 | lint:* · trigger:* (depend) · verify:submodules · analyse/test/integration/visibility · manifest/prebackup | keine Secrets/Format/Static-Findings; 3 Modul-Pipelines grün; Gitlinks exakt; Tools+Unit-Suite+E2E-Smoke grün; Manifest belegt | [TEILWEISE] (K-16, K-4/L5) |
| 1 | measure:*-Preflight (`--validate`) | rc 0 für die aktive Profil-Wurzel; Registry-Validat sauber | [TEILWEISE] (Planer-Kopf PL-1, PL-0/K-1/PL-3..7) |
| 2 | Driver in-Prozess (Facade→provision_all) | alle selektierten Binaries ok∨skipped; Sidecars konsistent; D1/Infra sauber klassifiziert | [TEILWEISE] (PL-2, GN-1/2/5, K-9; Storage ST-2/3) |
| 3 | Driver in-Prozess (Loader→Dock→Messung) | Gates halten; two_phase_valid; result.csv+Stamp je Binary; failed statt Lücke | [FERTIG] (additiv: PL-11/14, K-2/5/6/10/17, M-12, PL-8) |
| 4 | measure:*-Nachlauf · persist:measurements · thesis:pdf | CSV-Beleg + Anhang-Regen + Artefakte; persist gepusht (opt-in); PDF grün | [TEILWEISE] (M-3..M-11, ST-3) |

---

## FEHLT-Liste (Stufe → Roadmap-Ref, dedupliziert)

**Stufe 0:** K-16 (ce allow_failure vs hart-grün) · K-4/L5 (build-i2 stale + Include-Root, läuft nicht in CI) · PL-1/I3 (CI hand-maintained, kein CiYamlBuilder) · M13/#276 (ISA-/Distro-Matrix, bewusst zuletzt).
**Stufe 1:** PL-1 (Planer-Kopf: Director + 2 ConcreteBuilder + Executable + Vertragsgrenze — größtes Einzel-Loch der Kette) · PL-0 (v32-Skelett-Reconcile) · K-1 (Organ-only-Guard in profile_to_tree) · PL-3 (CoR unverdrahtet, resolve_selection=NEU) · PL-4 (`<metadata><mode>` nie konsumiert) · PL-5/PL-6 (XML-Kanal-Konvergenz; 4/6 System-Achsen ohne Kanal) · PL-7/PL-9 (Schema/repeats-Gate) · GN-3 (golden-N-XML nicht gedockt).
**Stufe 2:** PL-2 (CebSystemAxisDrive statt Closure) · GN-1 (extension_hardware-Knoten) · GN-2 (Instanziierungs-Guard) · GN-5 (reflect_versions-Test) · K-9 (ToolchainFehlt-Emitter) · Fork A (CEB-.so-Grenze, GO offen) · ST-2/ST-3/ST-4 (Storage-Infra P1–P6 + Scharfschaltung + VLAN-Klärung).
**Stufe 3:** PL-11 (error.log-Sidecar) · PL-14 (Multi-Gattungs-Dispatch/V42) · PL-8 (mode/threads-Kanal) · K-2 (sizeof-static_assert) · K-5 (ABI-Spiegel 5→6, Daten-korrektheitsrelevant) · K-6 (host_compatible_with nutzen) · K-10 (SampleStatus-Vollsplit) · K-17 (A07-Segfault) · M-12 (PMC branch/IPC).
**Stufe 4:** M-3 (erster persist-Beweis) · M-4 (17-Achsen-Nachzug 04/05/08 — blockiert seg_attribution, VOR Lauf-Auswertung) · M-5 (bilinguales PDF + TeXLive-Gate) · M-6 (Kettenende: Copy-Back + thesis:pdf hinter measure) · M-7..M-11 (Haupt-Text-Einbindung, Sensitivität, Kurven-Writer, FF-Antworten) · M-15 (Welch-Stufe) · K-12 (CI-„16 .tex"-Kommentar) · ST-5 (Persistenz-Politik).

*Additiv; ersetzt weder Bauplan noch Roadmap — es materialisiert deren CI-Sicht als eine Start→Grün-Kette.*
