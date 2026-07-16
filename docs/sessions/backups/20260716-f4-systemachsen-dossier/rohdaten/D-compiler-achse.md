# STRANG D — CEB-Compile-Architektur + Compiler-Systemachsen-Andockpunkte (Rohdaten, 2026-07-16)

Auftrag: Kartierung der Compile-Architektur des CacheEngineBuilder (CEB) im ce
(`Code/external/comdare-cache-engine/`) + Analyse, wie eine NEUE Compiler-SYSTEMACHSE (gcc|clang,
XML-gewählt) (a) je Tier-Binary-Permutation und (b) für den CEB selbst modelliert werden kann —
golden-320-neutral (Default gcc; clang additiv, Default-OFF). Alle Aussagen datei:zeile-belegt;
Pfad-Präfix `ce/` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/`.
Reiner Lese-Befund; einzige Schreiboperation dieses Strangs = diese Datei.

USER-KONZEPT (bindend, 2026-07-16, wörtlich übernommen aus dem Auftrag):
(1) Systemachsen ≠ Algorithmus-Gattungs-Achsen; beide mit compile-time-HAUPTACHSEN + dynamischen
runtime-UNTER-ACHSEN. (2) Systemachsen liegen IN der CEB (hineinkompiliert); Gattungs-Achsen werden
VON der CEB IN die Tier-Binaries EINKOMPILIERT; Messung der Systemachsen „nach einer Strategie".
(3) Scheduling/Hardware/NUMA/Locking = PFLICHT-SYSTEMACHSEN neben den Mess-System-Achsen — TODO,
keine Duplikate. (4) NEUE Compiler-SYSTEMACHSE: XML wählt gcc ODER clang für den CEB selbst UND je
Tier-Binary-Permutation. (5) Voll-Vergleich jede-gegen-alle unter Datenlasten × Compiler × ISA × OS;
„alt gegen neu" = Stand der Technik vs Prüfling JE der 3 Stufen (keine 4. Stufe). (6) Experiment-B+-Baum
hat Filter für die CEB-Stufe; Experiment-Planer mit XML-Interpreter = NEUE DRITTE ANWENDUNG.

---

## 1 IST-Kartierung

### 1.1 BuildOrchestrator + CompileFn-Abstraktion (der zentrale Andockpunkt)

- `ce/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp:15` — Architektur-Kommentar:
  „Compiler-Aufruf + RAM-Abfrage sind INJIZIERBAR (CompileFn / FreeRamFn) → deterministisch testbar."
- `build_orchestrator.hpp:115-117` — die drei injizierten Funktions-Typen:
  `using CompileFn = std::function<int(BuildJob const&)>;` (115),
  `SourceGenFn` = binary_id → perm-Source (116), `FreeRamFn` (117).
- `build_orchestrator.hpp:184-185` — Konstruktor nimmt `CompileFn compile, SourceGenFn gen` entgegen;
  EIN CompileFn gilt für ALLE Jobs eines Laufs (kein per-Job-Compiler-Feld heute).
- `build_orchestrator.hpp:86-92` — `BuildJob` (index, binary_id, source, output, cores) — KEIN
  Toolchain-Feld (Erweiterungspunkt, s. §2.1).
- `build_orchestrator.hpp:466-489` — **`make_gpp_compile_fn(include_dirs, defines, cxx = "g++-16")`**:
  der POSIX-CompileFn. Compiler-Binary ist bereits ein **String-Parameter `cxx`** (467); Flags fest im
  @rsp-File: `-std=c++23 -O2 -fPIC -shared -fno-gnu-unique -fdiagnostics-color=never` (474-479) +
  injizierte `defines`/`include_dirs` (480-481); Log je Binary `<output>.cxx.log` (486); Ausführung via
  `detail::run_argv_redirected({cxx, "@rsp"}, log)` (487) → `posix_spawnp` ohne Shell (405-443).
  ⇒ Ein clang-Aufruf ist heute schon per `cxx="clang++-22"` DENKBAR — einziger harter Prüfpunkt: die
  festen Flags (insb. `-fno-gnu-unique`) müssen für clang verifiziert werden (VERIFY, §4 Risiko R2).
- `build_orchestrator.hpp:450-461` — Windows-Pendant `make_system_compile_fn` (MSVC `cl /LD /MP<cores>`),
  shell-basiert; ein Nicht-MSVC-Compiler auf Windows ist dort NICHT abstrahiert.
- `build_orchestrator.hpp:152-159` — `orch_make_stem`: MAX_PATH-sichere Stem-Kappung
  (Präfix + `_<index>_<fnv1a-hex>`, kStemMax=120); Stem hängt NUR am binary_id (+index) — compiler-frei.
- `build_orchestrator.hpp:265-274` — per-Binary-Unterordner `output_dir/<stem>/` mit kurzen Namen
  `perm.cpp`/`perm.dll` (opt-in `per_binary_subdirs`, 63-65).

### 1.2 Versions-Sidecar (`.version`) + Resume-Mechanik

- `build_orchestrator.hpp:161-179` — Sidecar-Trio: `version_sidecar_path(output)` = `<output>.version`
  (162-164); `dll_is_current(output, version)` = DLL existiert UND Sidecar-Inhalt == geforderte
  `build_version` (166-174; leere Version ⇒ nie überspringen, 167); `write_version_sidecar` (175-179).
- `build_orchestrator.hpp:282-287` — Skip-Pfad im Worker: versions-aktuelle DLL ⇒ `skipped=true`,
  „übersprungen (Version aktuell)"; `build_orchestrator.hpp:322` — Sidecar wird NACH Compile-Erfolg
  geschrieben (Resume-Marke).
- `build_orchestrator.hpp:62` — `BuildConfig::build_version`: „Versions-/Anforderungs-Signatur;
  leer = nie überspringen" — ein FREIER String ⇒ hier kann eine Compiler-Kennung hineinkomponiert
  werden, ohne die Sidecar-Mechanik anzufassen (§2.1, Option „Sidecar").
- Mess-Resume (getrennt vom Build-Resume): `ce/libs/cache_engine/builder/experiment_tree/`
  `cache_engine_builder_iterator.hpp:559-613` — `lazy_resume_stamp_prefix` „resume-v5|build=…|plat=…|bv=…"
  (580-584) kodiert u.a. `row_platform`/`row_build_version`; Format-Bump-Disziplin v4→v5 dokumentiert
  (573-579): JEDER neue Lauf-Konfigurations-Freiheitsgrad MUSS in den Stamp (sonst stale-Resume) —
  gilt auch für eine Compiler-Achse (⇒ resume-v6). `lazy_try_resume_binary` (618-660) prüft
  Stamp+Header+Zeilenzahl; Einstieg im Treiber :728-734.

### 1.3 COMDARE_CXX — der heutige (einzige) Compiler-Wahlpunkt der Tier-Binaries

- `ce/libs/cache_engine/profile_facade/profile_run_facade.cpp:95-98` — `cxx_compiler()`:
  `getenv("COMDARE_CXX")`, sonst Default `"g++-16"`.
- `profile_run_facade.cpp:150` — Injektion:
  `a.compile = ex::make_gpp_compile_fn(perm_include_dirs(), perm_mess_defines(), cxx_compiler());`
  ⇒ Compiler-Wahl ist heute ein ENV-Override, NICHT XML-getrieben und NICHT je Binary differenzierbar.
- `profile_run_facade.cpp:71-93` — `perm_mess_defines()`: je Tier-DLL werden host-seitige compile-time-
  Konstanten als `-D` durchgereicht (COMDARE_ANATOMY_MODULE_BUILD/MEASUREMENT_ON/OS/ARCH/
  COMDARE_CACHE_LINE_SIZE) — PRÄZEDENZ dafür, dass der Host per CompileFn compile-time-Parameter je
  DLL setzt (dieselbe Naht trüge z.B. eine Compiler-/Varianten-Kennung als `-D`).
- E4-Kette (Host-App → Fassade): `Code/02_messung_driver/main.cpp:561-625` — E4-XML ist DEFAULT-/
  ALLEINWEG (571-574); `COMDARE_THESIS_PROFILE` (566-568), `pa.build_version="m3v2"` (590),
  `COMDARE_PLATFORM`-Override sonst `compile_time_platform_tag()` (592-593, Tag-Tabelle 233-251),
  `COMDARE_BUILD_VERSION` → `build_version_tag_override` (605-606).
- Tag-Weiterleitung: `ce/libs/cache_engine/profile_facade/profile_run_entry.hpp:74-75` (Overrides),
  :152-157 (leer ⇒ `<run_options>`-Werte aus der XML), :243-244 (`cfg.row_platform`/`row_build_version`).
- XML-Quelle: `ce/libs/cache_engine/algorithm_profiles/thesis_profiles/m3v2_study.profile.xml:152` —
  `<run_options cap="320" platform="win-x86_64" build_version="m3v2" resume="true"/>` ⇒ die
  `<run_options>` sind der natürliche XML-Ort, an dem heute Lauf-weite Bau-/Tag-Parameter leben.

### 1.4 Die 3 Build-Varianten-Achsen page_type/09b/12 — die ARCHITEKTUR-ANALOGIE

Doktrin (`ce/docs/architecture/27_experiment_baum_registry_bindung_4_bruecken.md`):
- :79-83 — „5 Achsen außerhalb dieser 17 Slots (page_type, 09b, 12, q1, q2) … page_type/09b/12 = 3
  Build-Achsen (Codegen-/Build-Varianten DERSELBEN …)".
- :102 — Tabellenzeile: die 3 Build-Achsen „modifizieren DIESELBE SearchAlgorithm-Binary … KEINE
  eigene Gattung"; :161 — „Build-/Codegen-Varianten derselben SearchAlgorithm-Binary".
- :202-225 — „3 DefinitionOnly … Build-Konstanten → read-only Definition statt Observer";
  Hardware-Achsen (09b/12/09) sind „reine Build-Time-Konstanten".

Mechanik (Code):
- `ce/libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1.hpp:73-82` —
  `COMDARE_DEFINE_ANATOMY_MODULE_ADHOC_BUILDVARIANT(PT, SE, HW, <19 Achsen>)`: EINE DLL trägt die
  19-Slot-Anatomie (4 ABI-Symbole) UND die Build-Identität der 3 Build-Achsen als zusätzliches
  extern-"C"-Symbol `comdare_build_variant_inspect` — „Build-Parameter DERSELBEN Binary … NICHT eine
  eigene Gattung" (77).
- `ce/libs/cache_engine/include/cache_engine/abi/build_variant_inspection.hpp:18-22` — das
  Inspection-Makro (Host zieht die Identität via dlsym); :2-6 — „additive ABI-Erweiterung (eigenes
  Symbol; alte Loader ignorieren es)"; :32-37 — `…_CHECKED`-Variante mit consteval-Kohärenz-Guard
  (deklarierte simd_extension == reale Build-ISA-Stufe; „Etikett != Maschinencode" bricht den Build).
- `ce/libs/cache_engine/anatomy/build_variant_definition.hpp:17-34` — ABI-fester uint64-POD
  `BuildVariantDefinitionV1` (page_kind/simd_width_bits/hw_cache_line/hw_numa_capable/present_mask);
  :60-72 — compile-time-Reader `build_variant_definition<PT,SE,HW>()` („KEIN Treiben — reine Definition").
- Flag-Kopplung (Deklarations-Wahrheit): `ce/cmake/isa_features.cmake:126-184` —
  `comdare_apply_simd_extension_flags(<target> <EXT>)` bildet GENAU EINE 09b-Extension auf echte
  Compiler-Flags ab (AVX2→`-mavx2`/`/arch:AVX2` 147-152, AVX512→`-mavx512f` 153-160; FATAL_ERROR bei
  unwahren Etiketten 140-143/163-179). Real angewandt je Test-Target:
  `ce/tests/unit/CMakeLists.txt:2787-2788`.
- Beweis-Test: `ce/tests/unit/genus_adhoc_buildvariant.cpp:1-7` („EINE DLL trägt SOWOHL … ALS AUCH
  die Build-Identität … Beweist Doc 27 §0.1") + :19-23 (Build-Achsen ZUERST, named PT/SE/HW).

**Kern-Eigenschaft für Strang D:** Die 3 Build-Achsen sind NICHT Teil des binary_id und NICHT Teil
der Composition (keine `AdHocComposition<20>`, build_variant_inspection.hpp:8-9). Ihre Identität
reist (a) im Build-Artefakt (Inspection-Symbol) und (b) in der Build-/CMake-Konfiguration — genau
das Muster, das eine Compiler-Achse braucht (Compiler ändert die Binary, nicht die Komposition).

### 1.5 binary_id — was golden-320-neutral bedeutet (harte Schranke)

- `ce/libs/cache_engine/builder/experiment_tree/experiment_tree.hpp:266-288` — `StaticBinaryView::
  operator[]` serialisiert binary_id als `axis=value/axis=value/…` über ALLE statischen Ebenen; auch
  gepinnte Ebenen (values.size()==1) emittieren ihr Segment (270-284). ⇒ **Eine zusätzliche
  Achsen-Ebene — selbst gepinnt auf 1 Wert — ändert JEDEN binary_id.**
- `ce/tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt:1-4` — „EINGEFROREN … NICHT neu
  generieren"; Beispiel-id Zeile 4 enthält exakt die 19 Slots (search_algo…queuing_q2), KEIN
  page_type/simd/hw, KEIN Compiler.
- Gate: `ce/tests/unit/thesis_tiere/test_profile_roundtrip.cpp:5-10,87-94` — Profil-Pfad ==
  Golden-Liste POSITIONSIDENTISCH, 320 (4·4·5·4); CI-Job `contract:profile_coverage`
  (`ce/.gitlab-ci.yml:281-293`).
- Tag-Doktrin: `cache_engine_builder_iterator.hpp:89-94` — Lauf-Tags (series/sweep_axis/working_set_n/
  platform/build_version) reisen „NICHT in die binary_id (… keine Tag-Verschmutzung der
  Round-Trip-Identität)"; CSV-Spalten :267, Emission :442.
⇒ **Option „Compiler als binary_id-Segment" ist damit ausgeschlossen** (bricht golden-320 und den
Roundtrip-Gate) — Begründung in §2.1.

### 1.6 3-ISA-Matrix / COMDARE_ISA_MATRIX + build:clang-CI (Vorbilder für Gating)

- `ce/.gitlab-ci.yml:114-135` — `build:arm64-smoke`: „3-ISA-Teilmatrix-INSTANZIIERUNG" (#270b),
  OPT-IN + advisory, `rules: if $COMDARE_ISA_MATRIX == "true"` (126), Compiler-Wahl auf dem Runner
  `g++-13`-Fallback `c++` (130-131), explizite `-DCMAKE_C_COMPILER/-DCMAKE_CXX_COMPILER` (131).
- 3-ISA-Kanon = amd64 + arm64 + riscv64 (Pflicht), macOS „nicht Teil der 3-ISA-Pflicht":
  `docs/sessions/20260706-276-VOLL-PLATTFORM-MATRIX.md:54` (+ Stufenplan §2 dort; Compiler-Dimension
  „mindestens g++ 15.3 UND neuester clang" ebd. :3 — Vorläufer des User-Konzepts (4)).
- `ce/.gitlab-ci.yml:68-80` — `build:clang`: „OPT-IN + advisory (COMDARE_CLANG_MATRIX==\"1\") …
  destabilisiert die Hauptpipeline NICHT" (69); baut Voll-Suite `comdare_tests` unter neuestem clang.
- Template `.build-clang-latest` (Cluster-Repo, lokaler Klon):
  `/home/comdare/Projekte/Cluster/_infra/ci-templates/base-pipeline.yml:832-846` — Gate
  `$COMDARE_CLANG_MATRIX == "1"` (835), clang-Suche 22→16 + Fallback `clang++` (839-842), eigener
  Build-Dir-Suffix `-clang` (845) ⇒ gcc- und clang-HOST-Artefakte koexistieren nebeneinander.
- Host-Presets: `ce/CMakePresets.json:37-55` — `gcc-release` (CMAKE_CXX_COMPILER g++) und
  `clang-release` (clang++) existieren bereits als offizielle Configure-Presets.

### 1.7 Host-Toolchain-Provenienz — der CEB weiß bereits, womit ER gebaut wurde

- `ce/cmake/provenance.cmake:42-67` + `ce/cmake/build_provenance.hpp.in:8-11` — configure-time
  eingebacken: `compiler_id`, `compiler_version`, `cxx_flags`, `isa_built_for` (+ 4 git-SHAs).
- `ce/libs/cache_engine/builder/provenance_manifest.hpp:73-96` — `serialize_provenance_manifest()`
  emittiert `compiler_id/compiler_version/cxx_flags/isa_built_for` + runtime-`isa_ran_on` (cpuid,
  :58-69) als Mess-Sidecar-Manifest. ⇒ Die compile-time-HAUPTACHSEN-Identität des CEB (Toolchain)
  ist als „Definition statt Observer" bereits realisiert — nur noch nicht als Systemachse benannt.

### 1.8 Systemachsen-IST (Mess-Systemachsen „Blut") + die Pflicht-Lücke

- `ce/libs/cache_engine/include/cache_engine/measurement/system_axis.hpp:143-190` — SystemAxis-Wurzel:
  CRTP `SystemAxis<Derived>` + `SystemAxisConcept` (kein vtable), host-seitig, „bei eingeschalteter
  Messung immer präsent (Blut-Direktive), … keine Organ-Taxonomie und kein austauschbarer Achsen-Slot"
  (143-145). 16 MeasurementCategories (25-34), Regime-Split TimeObserver/PmcCounter via `regime_of`
  (54-80), 3 konkrete Achsen: WallClock/ObserverSnapshot/Pmc (192-336).
- `ce/libs/cache_engine/include/cache_engine/measurement/measurement_axis_registry.hpp:32-49` —
  compile-time-Registry (16 Einträge, Index==Kategorie, static_assert :61-62) + Metaprogrammier-
  Iteration `for_each_measurement_axis` (70-75). ⇒ Systemachsen liegen IN der CEB-Host-Schicht
  (User-Konzept (2) bestätigt); die Gattungs-Achsen (19 Slots) werden dagegen VOM CEB in die DLLs
  einkompiliert (adhoc_emitter.hpp:83-108, Emission `COMDARE_DEFINE_ANATOMY_MODULE_ADHOC`).
- „Messung nach einer Strategie": PMC-Quelle als Strategy+Factory EINMAL je Lauf —
  `cache_engine_builder_iterator.hpp:707-712` (`make_pmc_source()`, „Strategy+Factory; build-/OS-abhängig").
- **Lücke (User (3)):** Scheduling/Hardware/NUMA/Locking existieren NICHT als Systemachsen. Repo-weiter
  Treffer für SystemAxis: nur `system_axis.hpp`, `measurement_axis_registry.hpp`,
  `validate_profile.hpp` (grep 2026-07-16). Verwandte, NICHT zu duplizierende Bestände:
  - Locking als ORGAN-Achse axis_08 concurrency (Registry
    `ce/libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml`, axis id="concurrency"
    slot="T08", 9 Bausteine none/blocking/reader_writer/olc/lock_free/wait_free/rcu/…).
  - NUMA als Build-Achsen-Property: `build_variant_definition.hpp:26-27` (`hw_numa_capable` aus
    axis_12 general_hardware).
  - Scheduling/Threads als RUNTIME-Steuerung: `ce/libs/cache_engine/anatomy/
    resource_controllable_tier.hpp:34-43` (`ComdareResourceControlV1.thread_count` u.a., ABI-POD) —
    getrieben durch `RuntimeVariableLoop` + `env_limits`-Clamp
    (`cache_engine_builder_iterator.hpp:87-88`).
  ⇒ Diese drei Bestände sind die „dynamischen runtime-UNTER-ACHSEN"-Bausteine, an die die neuen
  Pflicht-Systemachsen andocken müssen, statt sie zu duplizieren (Detail §2.3).

### 1.9 Experiment-Planer / XML-Interpreter (User (6)) — Parser-Fundament existiert

- `ce/tests/unit/thesis_tiere/test_experiment_parser.cpp:1-16` — INC-D: `parse_experiment_profile`
  (common-Schicht) + `validate_experiment_profile` (cache_engine-Schicht); Golden-Instanz mit
  „2 engines (mit registry), 3 phases (mit merge/engine/engines/pruefling)" gegen die REALEN
  Registries (`cache_engine_axis_registry.xml` + `prt_art_axis_registry.xml`).
- Die „3 Stufen" (User (5), keine 4. Stufe): `Code/02_messung_driver/experiment_phase_strategy.hpp:
  53-57` — MergeStrategy-Alias auf die ce-Single-Source `anatomy/pruefling_merge.hpp:130-134`:
  `Stufe1_CeOnly / Stufe2_PrueflingReplace / Stufe3_FullJoin`.
- Bestehende Anwendungen im Framework: `ce/apps/CMakeLists.txt:6-31` (9 App-Targets; Haupt-Hosts:
  (1) `cache_engine_builder` = Demo-/Builder-Driver, apps/cache_engine_builder/main.cpp:2-12;
  (2) `Code/02_messung_driver` = der E4-Mess-Host, main.cpp:561-625). Der Experiment-Planer mit
  XML-Interpreter wäre die dritte Host-Anwendung; sein Parser-/Validierungs-Kern (INC-D) und der
  Baum-Filter-Unterbau (`experiment_tree.hpp:235-288` StaticBinaryView; BuildSelection
  `coverage_selection.hpp`, konsumiert via `provision_all(view, selection, …)`
  build_orchestrator.hpp:198-202) existieren bereits als ce-Module — Andockpunkt, KEINE Parallelstruktur
  (Direktive feedback_vor_aufgaben_erst_projektstruktur_analyse).

---

## 2 ANALYSE — Modellierung der Compiler-Systemachse (compile-Haupt + runtime-Unter-Ebene)

### 2.1 (a) gcc/clang je Tier-Binary-Permutation

Drei im Auftrag genannte Kandidaten, bewertet gegen die IST-Anker:

1. **binary_id-Segment — ABGELEHNT.** Jede zusätzliche statische Ebene emittiert ihr Segment in JEDEN
   binary_id, auch gepinnt (experiment_tree.hpp:270-284) ⇒ alle 320 golden ids ändern sich ⇒
   test_profile_roundtrip (POSITIONSIDENTISCH, test_profile_roundtrip.cpp:87-94) und die eingefrorene
   Liste (golden_fullpilot_320_binary_ids.txt:2 „NICHT neu generieren") brechen. Zudem verletzt es die
   dokumentierte Tag-Doktrin „Identität ≠ Lauf-Konfiguration" (cache_engine_builder_iterator.hpp:89-94).

2. **Nur Sidecar — UNZUREICHEND, aber notwendiger Bestandteil.** `build_version` ist ein freier String
   (build_orchestrator.hpp:62); eine Compiler-Kennung darin (z.B. `m3v2+clang22`) macht die
   `.version`-Resume-Unterscheidung gcc-Artefakt vs clang-Artefakt SOFORT korrekt (dll_is_current
   :166-174) — liefert aber weder Host-abfragbare Identität noch CSV-Trennung noch Koexistenz beider
   Artefakte (gleicher Output-Pfad würde überschrieben).

3. **Build-Varianten-Muster (EMPFOHLEN) — Compiler als 4. Build-Achse analog page_type/09b/12.**
   Exakt die Doc-27-Doktrin „Build-Parameter DERSELBEN Binary, keine eigene Gattung/kein 20. Slot"
   (Doc 27:102; build_variant_inspection.hpp:8-9). Konkrete Andockpunkte:
   - **compile-time-HAUPTACHSE (Wert gcc|clang je Permutation):** XML-gewählt. Natürlicher Ort:
     Registry-/Experiment-XML als eigener `<toolchains>`-Block (Bausteine je Engine, analog
     `cache_engine_axis_registry.xml`-Bausteinen) + Auswahl im Experiment-/Thesis-Profil; Lauf-weiter
     Default in `<run_options>` (m3v2_study.profile.xml:152 trägt heute schon platform/build_version).
     Semantik: multiplikative BUILD-Dimension (Pass je Toolchain), NICHT Composition-Slot.
   - **CompileFn-Familie:** `make_gpp_compile_fn` ist bereits compiler-parametrisiert (cxx-String,
     build_orchestrator.hpp:466-467). Minimal-Erweiterung: Factory `make_toolchain_compile_fn(toolchain)`
     die je Wert gcc|clang das cxx-Binary (+ ggf. flag-Deltas) setzt; ODER per-Job-Dispatch (BuildJob
     erhält ein Toolchain-Feld — heute nicht vorhanden, :86-92 — und die Closure wählt). Der
     Zwei-Pass-Weg (je Toolchain ein `provision_all`-Pass mit eigenem CompileFn/output_dir) braucht
     KEINE Orchestrator-Änderung und spiegelt die bestehende Pass-Struktur der Sweep-/SOTA-Läufe
     (profile_run_entry.hpp:243-244 setzt Tags je Pass).
   - **Artefakt-Koexistenz:** je Toolchain ein Unterbaum `dll_dir/<toolchain>/<stem>/perm.dll`
     (per_binary_subdirs-Layout :265-274 unverändert je Baum) — der Voll-Vergleich (User (5)) braucht
     gcc- UND clang-Artefakt derselben Permutation GLEICHZEITIG.
   - **Resume:** (i) Build-Resume: eigene Unterbäume + compiler-augmentierte `build_version` im
     `.version`-Sidecar (s.o. Kandidat 2 als Bestandteil); (ii) Mess-Resume: neuer Stamp-Freiheitsgrad
     ⇒ Format-Bump resume-v5→v6 mit `|cxx=<id>` (Disziplin dokumentiert
     cache_engine_builder_iterator.hpp:573-579 — Prefix-Mismatch ⇒ ehrliche Neu-Messung).
   - **Identität im Artefakt (Analogie Inspection-Symbol):** additives extern-"C"-Symbol
     `comdare_toolchain_inspect` im generierten perm.cpp (Emission an EINER Stelle:
     `render_adhoc_module_source`, adhoc_emitter.hpp:83-89), befüllt aus Prädefinitions-Makros
     (`__clang__`/`__clang_major__` vs `__GNUC__`) — selbst-beweisend statt etikettiert, additive
     ABI-Erweiterung nach dem Muster build_variant_inspection.hpp:6 („alte Loader ignorieren es").
     Das ist zugleich der Kohärenz-Guard-Ersatz: die DLL SAGT, womit sie WIRKLICH gebaut wurde
     (Deklarations-Wahrheit wie GO-3 A1, build_variant_inspection.hpp:24-31).
   - **CSV/Auswertung:** neue Tag-Spalte (z.B. `toolchain`) nach dem Muster platform/build_version
     (NICHT in binary_id; Spalten-Erweiterung ADDITIV ans Ende wie die PMC-Spalten,
     cache_engine_builder_iterator.hpp:178-182; Header-Identität invalidiert Alt-Resumes ohnehin sauber).
   - **runtime-UNTER-ACHSEN der Compiler-Achse:** die Haupt-Achse ist strikt compile-time (kein
     Runtime-Switch — Direktiven feedback_no_runtime_switch / feedback_compile_time_only_no_runtime).
     Die dynamische Unter-Ebene entsteht als Kreuz mit den BESTEHENDEN dynamischen Dimensionen
     (RuntimeVariableLoop über tree.dynamic_filter(), cache_engine_builder_iterator.hpp:13-16;
     Workload-Achse 2 ids als dyn. Werte :82-86) — d.h. „welcher Compiler unter WELCHER Datenlast"
     (User (5)) ist bereits die Multiplikation Compiler-Pass × dynamischer Filterbaum, ohne neuen
     Mechanismus. Compiler-SPEZIFISCHE Runtime-Knöpfe (z.B. glibc-Tunables/LD-Optionen) wären eine
     denkbare echte Unter-Achse — HEUTE OHNE Code-Anker, als Deep-Research-TODO markiert (Direktive
     feedback_axes_optimization_semantics_deep_research: Min/Max je Achse erforschen).

   **Golden-320-Neutralität des empfohlenen Musters:** Default = genau 1 Toolchain-Wert `gcc`
   (cxx="g++-16" wie heute, profile_run_facade.cpp:97) ⇒ 1 Pass, identische binary_ids/Stems/Pfade/
   Sidecars/CSV-Kernspalten wie heute; clang = zusätzlicher Wert, Default-OFF, additiv gated (CI-Muster:
   COMDARE_CLANG_MATRIX „1" opt-in advisory, .gitlab-ci.yml:69 + base-pipeline.yml:834-835; XML-Muster:
   enabled-Flags wie in der Registry `enabled="true"`-Attribute, cache_engine_axis_registry.xml:10-13).

### 2.2 (b) gcc/clang für den CEB selbst (Host-Toolchain als Systemachse)

- Die Host-Toolchain ist eine CONFIGURE-TIME-Entscheidung des offiziellen Wegs (CMake):
  Presets `gcc-release`/`clang-release` (CMakePresets.json:37-55), CI-Template setzt
  `-DCMAKE_CXX_COMPILER` explizit (base-pipeline.yml:845; arm64-Job .gitlab-ci.yml:131). Ein
  „XML wählt die CEB-Toolchain" kann daher NICHT der laufende CEB selbst vollziehen (er müsste sich
  selbst neu bauen) — sauberer Andockpunkt ist die Orchestrierungs-Ebene DARÜBER: der
  Experiment-Planer (dritte Anwendung, §1.9) interpretiert die Experiment-XML und wählt/startet das
  passende CEB-HOST-Artefakt (gcc-CEB oder clang-CEB), die als getrennte Build-Trees bereits
  koexistieren können (`${BUILD_DIR}-clang`, base-pipeline.yml:845). Das entspricht dem E4-Prinzip
  „XML steuert den Versuchsaufbau; CEB orchestriert" (Direktive
  feedback_e4_xml_autoritative_bauanleitung_ceb_orchestriert).
- **Systemachsen-Modellierung:** compile-time-HAUPTACHSE = Host-Toolchain-Identität, bereits
  hineinkompiliert via Provenienz (`build_provenance.hpp.in:8-11`; Doc-27-Muster „Definition statt
  Observer", Doc 27:202-212). Eine `HostToolchainSystemAxis` nach der bestehenden CRTP-Wurzel
  (SystemAxis<Derived>, system_axis.hpp:147-180) wäre eine reine Definitions-/Provenienz-Achse:
  `collect` liest die constexpr-Provenienz (compiler_id/version/cxx_flags) statt Countern —
  konsistent damit, dass Systemachsen „immer präsent" sind (system_axis.hpp:143-145). Export-Naht
  existiert: provenance_manifest.hpp:73-96 (Manifest-Sidecar je Mess-Lauf) + CSV-Tag-Spalte
  (host_compiler) nach dem platform-Muster.
- **runtime-UNTER-ACHSE des Host-Compilers:** `isa_ran_on` (cpuid zur Laufzeit,
  provenance_manifest.hpp:58-69,83) zeigt das Muster: compile-time-Identität (isa_built_for) +
  runtime-Faktum (isa_ran_on) im selben Manifest. Analog trägt die Host-Toolchain-Achse als
  Runtime-Unterebene die Ausführungsumgebung (Host-CPU/OS des konkreten Laufs) — vorhandene Quellen,
  keine Duplikate.
- **Voll-Vergleich (User (5)):** Matrix = Host-Toolchain (2) × Tier-Toolchain (2, je Permutation) ×
  ISA (3-ISA-Kanon amd64/arm64/riscv64, §1.6) × OS (#276-Matrix als Träger,
  docs/sessions/20260706-276-VOLL-PLATTFORM-MATRIX.md §1-2) × Datenlast (Achse-2-Lastprofile,
  profile_run_facade.cpp:105-143) — „alt gegen neu" bleibt der MergeStrategy-Diskriminator je der
  3 Stufen (pruefling_merge.hpp:130-134 via experiment_phase_strategy.hpp:53-57), orthogonal zur
  Compiler-Achse (KEINE 4. Stufe nötig oder erlaubt).

### 2.3 Pflicht-Systemachsen Scheduling/Hardware/NUMA/Locking (User (3)) — Lücken-Befund

Konzept ist als Wurzel vorhanden (SystemAxis-CRTP + Registry, §1.8), aber nur mit 3 Mess-Achsen
instanziiert — die 4 Pflicht-Systemachsen FEHLEN (grep-Befund §1.8). Andock-Regeln (keine Duplikate):
- Scheduling: Runtime-Steuerseite existiert als `thread_count` im Resource-Control-POD
  (resource_controllable_tier.hpp:35) — die Systemachse muss diese als runtime-UNTER-ACHSE
  referenzieren, nicht neu erfinden.
- Locking: axis_08 concurrency ist ORGAN-Achse (T08, cache_engine_axis_registry.xml) — die
  Locking-SYSTEMachse ist davon strikt zu trennen (Organ- vs System-Achsen nie mischen; eigener
  abstrakter Wurzel-Stamm — Direktive feedback_system_axes_measurement_own_abstract_root_blood,
  bestätigt durch system_axis.hpp:144 „keine Organ-Taxonomie").
- NUMA/Hardware: compile-time-Definitionsseite existiert als axis_12-POD-Felder
  (`hw_numa_capable`/`hw_cache_line`, build_variant_definition.hpp:26-27) + cpuid-Probe
  (provenance_manifest.hpp:59-69) — Systemachse = Host-seitige Definition+Runtime-Fakten, wieder
  „Definition statt Observer" wo konstant.
Die Compiler-Systemachse (dieser Strang) ist strukturell die fünfte in dieser Pflicht-Familie und
folgt demselben Bauplan: compile-time-Haupt (Toolchain-Identität, Definition/Provenienz) +
runtime-Unter (Ausführungskontext/dynamische Dims).

---

## 3 Andockpunkt-Liste (kompakt)

| # | Andockpunkt | Beleg |
|---|---|---|
| 1 | CompileFn-Injektion (EIN Fn je Lauf) | build_orchestrator.hpp:115,184-185 |
| 2 | cxx-String-Parameter (Compiler austauschbar) | build_orchestrator.hpp:466-467 |
| 3 | COMDARE_CXX-Env (heutige Wahl, Default g++-16) | profile_run_facade.cpp:95-98,150 |
| 4 | per-DLL-Defines vom Host (Präzedenz) | profile_run_facade.cpp:71-93 |
| 5 | Build-Achsen-Doktrin „gleiche Binary, kein Slot" | Doc 27:79-102,161,202-225 |
| 6 | Inspection-Symbol-Muster (additiv, dlsym) | build_variant_inspection.hpp:6,18-22 |
| 7 | Kohärenz-Guard-Muster (Etikett==Maschinencode) | build_variant_inspection.hpp:24-37; isa_features.cmake:126-184 |
| 8 | Emitter-Single-Source für Zusatz-Symbol | adhoc_emitter.hpp:83-89 |
| 9 | .version-Sidecar / build_version freier String | build_orchestrator.hpp:62,161-179,282-287,322 |
| 10 | Mess-Resume-Stamp-Bump-Disziplin (v5→v6) | cache_engine_builder_iterator.hpp:573-584 |
| 11 | Tag-Spalten statt binary_id (platform/bv-Muster) | cache_engine_builder_iterator.hpp:89-94,267 |
| 12 | Pass-Struktur mit per-Pass-Tags (Sweep/SOTA) | profile_run_entry.hpp:74-75,152-157,243-244 |
| 13 | XML-Ort für Lauf-Bau-Parameter | m3v2_study.profile.xml:152 (`<run_options>`) |
| 14 | Golden-Schranke (binary_id unantastbar) | experiment_tree.hpp:270-284; golden_…320….txt:2; test_profile_roundtrip.cpp:87-94 |
| 15 | CI-Gating-Vorbilder (opt-in additiv) | .gitlab-ci.yml:69,126; base-pipeline.yml:834-835 |
| 16 | Host-Toolchain-Presets + -clang-Koexistenz | CMakePresets.json:37-55; base-pipeline.yml:845 |
| 17 | Host-Provenienz (compiler_id kompiliert-ein) | build_provenance.hpp.in:8-11; provenance_manifest.hpp:73-96 |
| 18 | SystemAxis-Wurzel für neue Achsen | system_axis.hpp:143-190; measurement_axis_registry.hpp:32-49 |
| 19 | Parser-Fundament dritte Anwendung | test_experiment_parser.cpp:1-16; experiment_phase_strategy.hpp:53-57 |
| 20 | Baum-Filter für die CEB-Stufe | experiment_tree.hpp:235-288; build_orchestrator.hpp:198-202 |

Zeilenangaben Stand Arbeitskopie 2026-07-16.

---

## 4 Risiken / Offene Verifikationen (ehrlich markiert, KEIN Raten)

- **R1 golden-320:** Jede Variante, die binary_id/Stems/Default-Pfade ändert, bricht
  test_profile_roundtrip + Resume (#139). Das empfohlene Muster (§2.1.3) lässt den Default-Pfad
  byte-identisch (1 Toolchain gcc = heutiges Verhalten).
- **R2 clang-Flag-Kompatibilität (VERIFY):** Die festen rsp-Flags von make_gpp_compile_fn
  (build_orchestrator.hpp:474-479), insbesondere `-fno-gnu-unique`, sind gegen das konkrete
  clang-Release zu verifizieren, BEVOR ein clang-CompileFn definiert wird (Direktive
  feedback_never_guess_always_lookup_state_of_art_and_docs). Positiv-Indiz, kein Beweis: CI baut die
  Voll-Suite unter clang-22.1.8 grün (.gitlab-ci.yml:70) — das ist der HOST-Build, nicht der
  rsp-DLL-Pfad.
- **R3 Windows:** make_system_compile_fn ist MSVC-fest (build_orchestrator.hpp:450-461); eine
  gcc|clang-Achse ist dort heute nicht abbildbar (clang-cl wäre eigener, späterer Baustein).
- **R4 ABI-Mischbetrieb:** gcc-Host lädt clang-DLL (und umgekehrt) — die ABI-Grenze ist bewusst auf
  extern-"C" + uint64-PODs beschränkt (build_variant_definition.hpp:9,16; anatomy_module_abi_v1.hpp:15),
  was Cross-Compiler-Laden trägt; trotzdem gehört ein explizites Smoke-Gate (gcc-Host×clang-DLL) in
  die CI, Muster contract:-Jobs (.gitlab-ci.yml:188-213).
- **R5 Kein Runtime-Switch:** Compiler-Wahl bleibt strikt compile-/build-time (Haupt-Achse);
  dynamisches Laden nur cold-start-artig über die ohnehin bestehende DLL-Lade-Naht
  (Direktiven feedback_no_runtime_switch, feedback_compile_time_only_no_runtime).
- **R6 Duplikat-Verbot Pflicht-Systemachsen:** Locking-Systemachse ≠ axis_08-Organ-Achse;
  NUMA-Systemachse ≠ axis_12-Build-POD; Scheduling-Systemachse referenziert thread_count statt es zu
  doppeln (§2.3).
