Verified against source — the mappings are accurate: `:3301`/`:3307`/`:3332`/`:3335` all pass the host-probe variable unquoted; only `:3296`/`:3330` baselines use literal `TRUE`; `allow_failure` appears only at `:124` (arm64-smoke) and `:360` (is_original:relock). Here is the dossier.

---

# Erklärungs-Dossier: Die XML→CI/CMake-Automatisierung + die aktuelle prod2-Rötung

**Zweck:** Lern- und Handlungsdokument für den Haupt-Agenten. Es erklärt (1) den gesamten XML→CI/CMake-Fluss, (2) den CI-Aufbau, (3) die konkrete Rötung von Pipeline 10605, (4) ob die XML→CI-Erzeugung Ist oder Soll ist, und (5) welche Plan-Anforderungen verletzt sind und was zu tun ist — priorisiert.

**Pfad-Konvention:** `ce/` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine`, `super/` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`. Alle `datei:zeile` sind ce-relativ, sofern nicht mit `super/` markiert.

**Kernbotschaft vorweg (falls du nur einen Satz liest):** Die Rötung ist **kein** Versagen einer XML→CI-Generierung (die gibt es noch nicht) und **kein** Infra-Block. Sie ist ein **latenter CMake-Quoting-Fallstrick in handgeschriebenem CMake** (`tests/unit/CMakeLists.txt:3307/:3335`), der seit dem 10.07. schläft und jetzt zum ersten Mal auf einem Intel-Host **ohne** AVX-512 sichtbar wird. Fix = 4 Zeilen quoten. Dein Bau-INC-2c hat den Bug **nicht eingeführt**, aber er ist jetzt **deine Bringschuld**, weil er eine harte Plan-Kadenz bricht.

---

## 1. DAS GROSSE BILD — der XML→CI/CMake-Fluss

Wichtigste Unterscheidung, die man nie verwechseln darf: Es gibt **zwei verschiedene Codegen-Klassen** und **einen dritten, noch nicht gebauten** Soll-Pfad.

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  KLASSE A — XML WIRD GELESEN (Input)          CONFIGURE-/BUILD-ZEIT-CODEGEN       │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                   │
│  permutation_axes.xml ──▶ comdare_permutation_codegen_cli ──▶ generated/          │
│  (libs/.../algorithm_       (cmake/permutations.cmake:5,        permutations.cmake │
│   profiles/, TABU r/o)        144-158)                          + perm_src/*.cpp   │
│                             NUR bei -DCOMDARE_BUILD_             + permutations_    │
│                             PERMUTATIONS=ON (default OFF,         manifest.txt      │
│                             CMakeLists.txt:33) ── in den         (:16-17)          │
│                             roten Jobs NICHT gesetzt ──▶         │                 │
│                             läuft dort GAR NICHT                 └─▶ include()      │
│                                                                     CMakeLists:596 │
│                                                                                   │
│  m3v2_study.profile.xml ──▶ comdare_catalog_codegen_cli ──▶ generated_source_     │
│  (thesis_profiles/)          (cmake/catalog_codegen.cmake:      catalog.hpp        │
│                              27-35, add_custom_command,         (BUILD-Zeit,       │
│                              DEPENDS <xml>)                     DEPENDS xml) ──▶    │
│    ★ das EINZIGE echte XML→Header-Build-Codegen-Vorbild ★      test_limits_...     │
│                                                                                   │
├─────────────────────────────────────────────────────────────────────────────────┤
│  KLASSE B — KEIN XML (Typraum-Enumeration, C++-Kompositions-Typraum)             │
├─────────────────────────────────────────────────────────────────────────────────┤
│  for_each_composition_type ──▶ comdare_run_anatomy_codegen_tool ──▶ anatomy_perm_ │
│  (C++-Typraum)                 (cmake/anatomy_codegen_runner.cmake:39)  *.cpp +    │
│                                comdare_run_adhoc_emitter                .so-Module  │
│                                (cmake/adhoc_emitter.cmake:25)         (=Tier-Bins) │
│                                include tests/unit/CMakeLists:1014/:1440            │
│                                Aufrufe :1017/1063/1095/1124, :1448/1453           │
│    ⚠ per Design NICHT-fatal: WARNING+SKIP, guarded include (:1023/1071/1103/1130) │
├─────────────────────────────────────────────────────────────────────────────────┤
│  KLASSE C — XML IST OUTPUT (invers) + Roundtrip-Gate                              │
├─────────────────────────────────────────────────────────────────────────────────┤
│  Achsen-Registry (compile-time-Reflektion) ──▶ comdare_axis_registry_gen ──▶      │
│                                                (tools/axis_registry_gen/main.cpp:  │
│                                                 184/257/263)                       │
│                                                cache_engine_axis_registry.xml      │
│  Gate: test_axis_registry_roundtrip regeneriert nach WORKDIR + byte-difft gegen   │
│  committete XML (registry_roundtrip.cmake:43-66, verdrahtet tests/unit:3445-3456) │
│  läuft im Job contract:profile_coverage (.gitlab-ci.yml:300-301)                  │
└─────────────────────────────────────────────────────────────────────────────────┘

        ────────── UND DANN, KOMPLETT DANEBEN, DIE CI SELBST: ──────────

  .gitlab-ci.yml (HAND-geschrieben, „REV 10 ... hand-maintained", :1)
        │  jeder prod-Job: cmake -B build-XXX -DCOMDARE_BUILD_TESTS=ON
        │  ──▶ add_subdirectory(tests/unit) ──▶ zieht tests/unit/CMakeLists.txt
        │      KOMPLETT ins Configure: SIMD-Dispatch (:3260-3336) UND
        │      Anatomy/Adhoc-Codegen (:1014-1124, :1440-1453)
        ▼
  Runner-Zuweisung nach tags:  [baremetal]  ──▶  prod1 (AMD) ODER prod2 (Intel)
                               [baremetal,amd] ──▶ prod1     [baremetal,intel] ──▶ prod2
```

**Die entscheidende Einsicht dieses Diagramms:** Es gibt **keinen Pfeil von irgendeiner XML zur `.gitlab-ci.yml`**. Die einzige „XML→CMake"-Automatik, die heute produktiv läuft, ist der **Katalog-Header** (`catalog_codegen.cmake`). Alles andere ist entweder Typraum-Enumeration ohne XML (Klasse B), invers (Klasse C), oder — für die CI-Struktur selbst — reine Handarbeit.

---

## 2. WIE DIE CI STRUKTURIERT IST

### 2.1 Zwei handgeschriebene Pipelines, ein geteiltes Template

- **CE** (`ce/.gitlab-ci.yml`) und **SUPER** (`super/.gitlab-ci.yml`) `include:` beide dasselbe Template-Projekt `comdare/cluster/ci-templates`, ref `development`, file `/base-pipeline.yml` (CE:12-16, SUPER:11-14). Lokaler Klon: `/home/comdare/Projekte/Cluster/_infra/ci-templates/base-pipeline.yml`.
- **SUPER = Orchestrator**: `trigger:cache-engine/prt-art/thesis` als downstream multi-project pipelines mit `strategy:depend` (SUPER:158-187); `measure:smoke`/`measure:golden-320` ISA-fest getaggt `[prod, baremetal, amd]` = prod1, aber rules-gated **INERT** (SUPER:431/505, gegated durch `COMDARE_RUN_MEASURE`/`COMDARE_MEASURE_PROFILE`). Der Normal-Gesamtlauf erzeugt sie also gar nicht — CI-Grün ≠ Messung.

### 2.2 CE-Stages und -Jobs

Stages (CE:26): `lint, build, sanitize, contract, test, chaos`.

| Job | tags | Gate-Status | Anker |
|---|---|---|---|
| `lint:secrets/format/static` | `[baremetal]` | HART | CE:51-59 |
| `build:clang` | `[baremetal]` | opt-in (`COMDARE_CLANG_MATRIX`) | CE:72-80 |
| `pmc:amd` | **`[baremetal, amd]`** | HART | CE:98-100 |
| `pmc:intel` | **`[baremetal, intel]`** | rules-gated INERT (`COMDARE_PROD2_AVAILABLE=='true'`) | CE:102-112 |
| `build:arm64-smoke` | `[arm64]` | **`allow_failure: true`** (advisory, #270b) | CE:120-124 |
| `sanitize:asan-ubsan` | `[baremetal]` | HART | CE:140-149 |
| `sanitize:tsan` | `[baremetal]` | HART (#278, CE:426) | CE:427-435 |
| `contract` (+`:durability/conformance/pool_flip/harness/profile_coverage/experiment_driver/node_shape`) | `[baremetal]` | HART | CE:152-343 |
| `is_original:relock` | `[baremetal]` | **`allow_failure: true`** | CE:353-360 |
| `chaos:drift` | `[baremetal]` | HART | CE:391-402 |
| `test:unit` | `[baremetal]` | HART (#278, CE:409) | CE:411-422 |

**Pflicht-Gates (kein `allow_failure`) = praktisch alles außer zwei Jobs.** Verifiziert per grep: `allow_failure: true` erscheint **nur** bei `build:arm64-smoke` (CE:124) und `is_original:relock` (CE:360). Alles andere ist HART.

### 2.3 Der entscheidende Strukturpunkt: Runner-Roulette

**Nur** `pmc:amd` (`[baremetal, amd]`) und `pmc:intel` (`[baremetal, intel]`) sind ISA-gepinnt. **Alle** anderen baremetal-Jobs — `sanitize:*`, `contract:*`, `chaos:drift`, `test:unit` — tragen **nur** `[baremetal]`, also **keine** ISA-Bindung. Ein reiner `[baremetal]`-Job matcht **beide** Runner. GitLab weist ihn dem gerade freien zu = **prod1 (AMD) ODER prod2 (Intel), nicht-deterministisch**.

Jeder dieser Jobs baut einen **eigenen frischen Build-Baum** mit denselben Basis-Flags `-G Ninja -DCOMDARE_BUILD_TESTS=ON` (build-tsan CE:433, build-san CE:146, build-conf CE:200, build-dur CE:172, build-chaos CE:398 …) und unterscheidet sich **nur** im `--target`-Subset + `ctest -R`-Filter, **nicht** in der Configure-Logik. Das bedeutet: Ein Configure-Defekt trifft **jeden** dieser Jobs identisch — er ist nicht auf die SIMD-Tests beschränkt, weil `add_subdirectory(tests/unit)` immer die ganze Datei zieht.

---

## 3. DIE AKTUELLE RÖTUNG ERKLÄRT — `Function invoked with incorrect arguments`

### 3.1 Die exakte Wurzel (Signatur vs. Aufruf vs. Variable)

Drei Zutaten, alle in `tests/unit/CMakeLists.txt`, alle **wörtlich verifiziert**:

**(1) Die Host-Laufzeit-Probe** (`:3263-3264`):
```cmake
check_cxx_source_runs("int main(){return __builtin_cpu_supports(\"avx2\")?0:1;}"   COMDARE_HOST_RUNS_AVX2)
check_cxx_source_runs("int main(){return __builtin_cpu_supports(\"avx512f\")?0:1;}" COMDARE_HOST_RUNS_AVX512F)
```
`check_cxx_source_runs` kompiliert+linkt+**führt aus**. Bei Exit-Code 0 → Variable = `1`. Bei Exit-Code ≠ 0 (Programm läuft, gibt aber 1 zurück, weil der Host die ISA nicht kann) → Variable = **LEERER String** als `CACHE INTERNAL` (Semantik: `/usr/share/cmake-4.3/Modules/Internal/CheckSourceRuns.cmake:112-121`). **Nicht** `FALSE`, sondern **leer**.

**(2) Die Funktion mit 3 Pflicht-Parametern** (`:3266`, symmetrisch `:3313`):
```cmake
function(comdare_add_simd_dispatch_test suffix flag do_run)
```

**(3) Der ungequotete Aufruf im vom Compiler betretenen Zweig** (`:3305-3307`):
```cmake
check_cxx_compiler_flag("-mavx512f" COMDARE_CXX_HAS_MAVX512F)   # COMPILE-Fähigkeit, kein Host-Test
if(COMDARE_CXX_HAS_MAVX512F)                                    # ← beide Hosts KENNEN -mavx512f → Zweig betreten
    comdare_add_simd_dispatch_test("_avx512" "-mavx512f" ${COMDARE_HOST_RUNS_AVX512F})   # ← UNGEQUOTET
endif()
```

**Die Mechanik:** Ist `COMDARE_HOST_RUNS_AVX512F` leer, kollabiert das ungequotete `${...}` zu **nichts**. Die 3-Parameter-Funktion erhält nur 2 Argumente (`"_avx512"`, `"-mavx512f"`) → exakt `CMake Error ... Function invoked with incorrect arguments`. Der Fehlertext selbst **beweist**, dass die Variable auf diesem Host leer ist.

Identisch bei `:3335` (`comdare_add_simd_add_u64_test`, Signatur `:3313`).

### 3.2 Warum prod2 rot, prod1 grün — **derselbe Quellcode, nur anderer Host**

Es ist **dieselbe CMake-Invocation**, **nicht** andere Flags/Env, **nicht** ein anderer Build-Tree. Der **einzige** Unterschied ist die Host-CPU (Ledger:684, K89c-Handover):

- **prod1 = AMD Ryzen 9 9950X3D (Zen5)** — führt AVX-512F aus → Probe rc=0 → `COMDARE_HOST_RUNS_AVX512F=1` → 3 Args → **Configure grün** → `test:unit(prod1)=SUCCESS`.
- **prod2 = Intel i9-14900KS (Raptor-Lake-Refresh, Consumer)** — AVX-512 in Hardware **fused off** (so wörtlich in `base-pipeline.yml:138`) → Probe rc=1 → Variable **leer** → Arity-Fehler → **alle prod2-Jobs rot** im gemeinsamen Configure, **vor** Build/ctest.

**Warum nur die AVX-512-Zeilen brechen, nicht AVX2 (`:3301`/`:3332`):** Die AVX2-Aufrufe haben **denselben latenten Bug** (auch ungequotet, verifiziert), feuern aber nicht, weil der i9-14900KS AVX2 **ausführt** → `COMDARE_HOST_RUNS_AVX2=1`, nie leer.

**Warum die `if()`-Form derselben Variablen robust ist:** `:2845 if(COMDARE_HOST_RUNS_AVX2 AND COMDARE_HOST_RUNS_AVX512F)` nutzt exakt dieselben Variablen — dort ist Leer = false und harmlos. **Nur** die ungequotete Funktions-**Argument**-Form (`:3301/3307/3332/3335`) bricht. Der Baseline-Aufruf `:3296 comdare_add_simd_dispatch_test("" "" TRUE)` ist immun (Literal `TRUE`).

### 3.3 Ist Bau-INC-2c die Ursache? **Nein — vorbestehend, nicht Infra.**

- Der SIMD-Block stammt aus Commit **8175c802** „feat(axes/simd): Phase 0.1 SIMD-Dispatch" (2026-07-10). Seither **latent**.
- `git show 5fe811db --stat` (= Bau-INC-2c) listet `tests/unit/CMakeLists.txt` **nicht** (nur `test_*.cpp`, `tools/CMakeLists.txt`, `tools/gen_golden_fullpilot/CMakeLists.txt`, `golden_fullpilot_320_binary_ids.txt`). INC-2c ist die **Telemetrie 19→18-Slots**-Änderung — sie hat den Configure-Pfad nur **erstmals wieder auf prod2 sichtbar** gemacht.
- Die **vorige** Pipeline 2b (`86769bc9`) starb an `stuck_or_timeout_failure` = **echter Infra-Block** (MEMORY `reference_ci_runner_ice_cold_cache_instability`) und **erreichte den Configure gar nicht**. Deshalb wurde der Bug bis jetzt nie ausgelöst.

**Fazit:** INC-2c ≠ Ursache. Der Bug ist ein vorbestehender, latenter Quoting-Fallstrick, den jeder Nicht-AVX-512-Host trifft. **Kein** Runner-Block → **kein** Modus-a-Freibrief (dazu §5).

### 3.4 Die „Folgefehler" sind Rauschen, nicht Ursache

Im selben abbrechenden prod2-Configure erscheinen zusätzlich `comdare_run_anatomy_codegen_tool` (`cmake/anatomy_codegen_runner.cmake:39`, Aufrufe `tests/unit:1017/1063/1095/1124`) und `comdare_run_adhoc_emitter` (`cmake/adhoc_emitter.cmake:25`, Aufrufe `:1448/1453`). Diese sind **nicht** ursächlich: `Function invoked with incorrect arguments` ist in CMake **nicht sofort-fatal** — CMake sammelt Fehler und bricht erst am Ende mit `Configuring incomplete` ab. Die Codegen-Runner emittieren ohnehin nur `WARNING` (Tool im Pass-1 noch nicht gebaut) und ihre `include()`s sind guarded (`if(_status STREQUAL "FOUND" AND EXISTS ...)`, `tests/unit:1023/1071/1103/1130`) → sie skippen still. **Nach dem Quoting-Fix verschwinden sie mit.**

**Präzisierung zur gemeldeten `cmake/*.cmake:478 (include)`:** Keine `cmake/*.cmake`-Datei erreicht 478 Zeilen (längste: `anatomy_codegen.cmake=273`). `:478` ist ein **Call-Stack-/Paraphrase-Artefakt** der Fehlermeldung, keine grepbare Zeile; die echten include-Sites sind `:1014` und `:1440`.

### 3.5 Der Fix (offizieller CMake-Weg, kein Behelf)

Das 3. Argument an allen **vier** Stellen quoten — `:3301`, `:3307`, `:3332`, `:3335`:
```cmake
comdare_add_simd_dispatch_test("_avx512" "-mavx512f" "${COMDARE_HOST_RUNS_AVX512F}")
```
Ein leerer String bleibt so **ein** Argument; `if(do_run)` (`:3289`/`:3323`) wertet ihn als falsy → Target wird gebaut (in `COMDARE_TEST_TARGETS`, `:3288`), aber auf Nicht-AVX-512-Hosts nicht via `add_test` registriert. **Exakt die dokumentierte Intention** (`:3255-3259`: „BAUEN immer, AUSFÜHREN nur bei Host-ISA"). Alternativ vor dem Call zu striktem 0/1 normalisieren.

**Eigenschaften des Fixes:** golden-neutral, kein ABI-/Arch-Bruch, **keine CT→RT-Degradierung** (das compile-time-Gate via `check_cxx_compiler_flag` bleibt, die `add_test`-Registrierung bleibt host-abhängig). Sicheres Vorbild ist `:2845`. Reines punktuelles Refactoring an 4 Zeilen.

---

## 4. IST DIE XML→CI-GENERIERUNG IST ODER SOLL?

**Eindeutig SOLL — heute existiert kein XML→`.gitlab-ci.yml`-Generator.** Beide Pipelines sind handgeschrieben (`.gitlab-ci.yml:1`). Die Direktive/DoD-7 „Planer generiert CI/cmake aus XML" (MEMORY `feedback_measurement_modes...planer_generates_ci_cmake`, Ledger:88 F5) ist **Ziel**, nicht Produktivstand.

### Soll-Architektur (F5-Planer-Codegen)

Design-Dossier: `docs/sessions/backups/20260716-experiment-planer-codegen-design/DOSSIER.md` — „Design-VOR-Bau, nichts gebaut". Kette:

```
Experiment-XML (3-Phasen) + 2 Registries (ce + prt-art)
        │
        ▼
comdare_experiment_planner  (NEUES ce-App-Target, Muster catalog_codegen_tool)
        │  Interpreter: XML → ExperimentPlan (geordnete PhaseStep-Liste:
        │  Systemachsen-Kombis × Tier-Binary-Selektion × Lastprofile × Mess-Modus)
        ▼
ExperimentPlanDirector::construct(IPlanBuilder&)   ← EIN Director, EIN Walk
        │  Template Method je PhaseStep:
        │  resolve_selection (CoR selection_filter_chain) → emit_build →
        │  emit_measure → emit_serialize → emit_copy
        ├──────────────────────────┬──────────────────────────────┐
        ▼                          ▼                              (Synchronie
  CMakeGraphBuilder          CiYamlBuilder                        STRUKTURELL
  (--emit-cmake →            (--emit-ci → Child-Pipeline-YAML     garantiert, weil
   generated/experiment_      → trigger:include:artifact:)        BEIDE aus DEMSELBEN
   plan.cmake → include())    ersetzt measure:smoke/golden-320    Walk gespeist)
```

Verifiziert als **nicht gebaut**: grep nach `CiYamlBuilder`/`CMakeGraphBuilder`/`ExperimentPlanDirector`/`IPlanBuilder`/`PhaseStep`/`ExperimentPlan`/`--dump-plan`/`--emit-ci`/`COMDARE_EXPERIMENT_XML` = **0 Treffer** in ce-Quellen. Increment-Fahrplan (alles Soll, DOSSIER:21): I1 Planer-Skelett (`--dump-plan`) → I2 CMakeGraphBuilder + 2-Pass → I3 CiYamlBuilder + Child-Pipeline (INERT-by-default) → I4 Debug/Mess-Schalter (#221) + `failed`-Zelle → I5 Serialisierungs-Emitter.

**Scope-Konsequenz:** F5 ist **Folgearbeit** (Ledger:88/117), **nach** Bau-INC-2, mit **noch nicht erteilter** Bau-Freigabe. **Der Fix aus §3 zieht F5 NICHT vor** — er härtet die handgeschriebene Stelle am offiziellen Ort. Genau diese Klasse Hand-CI-Bruch ist der dokumentierte Grund, warum die Soll-Doktrin das strukturelle Hand-CI später per `--emit-ci` subsumieren will.

---

## 5. PLAN-ANFORDERUNGEN, GAP & HANDLUNG

### 5.1 Welche Anforderungen verletzt sind

| # | Anforderung (Quelle) | Status |
|---|---|---|
| (a) | **honest-100%, kein Schein-Grün** (§0-GOAL-V6.1, Ledger:79; Vorspann Ledger:18). FF0 verlangt Multi-Plattform-Generalität x86 **AMD+Intel** (Ledger:215). | **VERLETZT** — grünes `test:unit(prod1/AMD)` bei rotem prod2(Intel) ist genau das verbotene Schein-Grün: der Intel-Pfad wurde **nie konfiguriert**, die Intel-Hälfte von FF0 ist unbewiesen. |
| (a) | **CI UND standalone messfähig** bis 28.07.2026 (§0-GOAL-V6.6, Ledger:98). | **VERLETZT** — standalone lokal grün (272/273), aber der CI-Pfad ist auf prod2 nicht einmal configure-clean → CI-Hälfte nicht messfähig. |
| (a) | **Verifikations-Kadenz je Increment** inkl. Punkt „CI (Modus a bei baremetal-Block)"; super-Sub-Build PFLICHT (§0-GOAL-V6.7, Ledger:100). | **VERLETZT** — CI rot; Fall ist **kein** baremetal-Block → kein Modus-a-Freibrief. |
| (b) | **Dual-Verifikation, reaktiviert**: „grüne Pipeline braucht immer grüne lokale Tests und umgekehrt" (Bikonditional, MEMORY `feedback_dual_verifikation...:10`). | **VERLETZT** — lokal grün, Pipeline rot → Richtung „lokal-grün ⇒ Pipeline-grün" gebrochen. |
| (c) | **Pflicht-Gates HART** (kein `allow_failure`): `test:unit`, `sanitize:tsan`, `sanitize:asan-ubsan`, `contract:*`, `chaos:drift`, `lint:*` (verifiziert `.gitlab-ci.yml`). | **VERLETZT** — 5 dieser HARTEN Gates (`chaos:drift`, `contract:conformance`, `contract:durability`, `sanitize:tsan`, `sanitize:asan-ubsan`) sind auf prod2 rot. Keiner fällt in die `allow_failure`-Toleranz (nur `arm64-smoke`/`is_original:relock`). |
| Doktrin | **AMD/Intel separat je SIMD** (MEMORY `feedback_build_matrix_8_docker...`). | **NICHT ERFÜLLT für die Gate-Jobs** — nur `[baremetal]`, nicht ISA-gepinnt → host-abhängiger SIMD-Code failt als Roulette statt deterministisch je ISA. Nur `pmc:amd/intel` + SUPER `measure:*` ehren die Doktrin. #276 (3-ISA-CI) ist explizit „allerletzte, infra-gated". |

### 5.2 Der Modus-a-Trennschnitt (kritisch)

Modus a (Ledger:131/154/164) ist der **einzige** legitime Aufweich-Pfad und **nur** bei „baremetal-Runner-Block" (Infra: stuck/timeout). Die **vorige** 2b (`86769bc9`, `stuck_or_timeout`) war Modus-a-berechtigt. Die **aktuelle** 2c ist ein **reproduzierbarer Code-/Configure-Defekt** (jeder Nicht-AVX-512-Host trifft ihn) → **Modus a greift NICHT**. Der Plan fordert **Fix, nicht Deferral**. Der Defekt ist per ce-Commit fixbar und muss vom Infra-Handoff (#207) getrennt behandelt werden.

### 5.3 Was zu tun ist — priorisiert

**Schritt 1 (SOFORT, die Rötung): Quoten.**
`tests/unit/CMakeLists.txt` an `:3307` und `:3335` (symmetrisch `:3301`/`:3332` gleich mit-härten) → `"${COMDARE_HOST_RUNS_AVX512F}"` bzw. `"${COMDARE_HOST_RUNS_AVX2}"`. 4-Zeilen-Härtung, golden-/ABI-neutral, keine CT→RT-Degradierung.

**Schritt 2 (Verifikation — sonst bleibt der Bug unentdeckt): auf einem Nicht-AVX-512-Host beweisen.** Genau die Falle, die „super-Sub-Build PFLICHT" (Ledger:100) adressiert: ein lokal-AMD-Lauf **verbirgt** den Bug (die lokale Vorab-Verifikation lief offenkundig auf einem AVX-512-Host — daher fiel er durch die Ritzen). Beweis auf prod2/Intel **oder** lokal simuliert (z.B. Zweig ohne Host-AVX-512). „Nie ✓ ohne wörtliche Ausgabe" — die grünen/roten Job-Logs literal zeigen.

**Schritt 3 (Struktur-Anforderung, nach der Rötung): die Gate-Jobs ISA-taggen.** Host-abhängiger Code darf nicht als Roulette failen. Die AMD/Intel-Doktrin verlangt separate ISA-Läufe. Ob als sofortiges `[baremetal, amd]`/`[baremetal, intel]`-Pinning der SIMD-berührenden Gates oder erst im Rahmen von #276 — das ist eine **Freigabe-Frage an den User** (Struktur-Änderung an der CI-Topologie, nicht nur Bugfix). **Schritt 1 macht die Pipeline host-invariant grün auch ohne Schritt 3**; Schritt 3 macht sie zusätzlich doktrin-konform deterministisch.

**Schritt 4 (Prozess): NICHT den F5-Planer vorziehen.** Der Bug sitzt im Hand-CMake; der offizielle Pfad ist Härtung, keine Parallelstruktur (MEMORY `feedback_vor_aufgaben_erst_projektstruktur_analyse`, „no quick fixes / cleanest not easiest"). Granular committen, beide Remotes ref-gleich (nie rebase, immer merge), danach den 10605-Nachfolger auf **beiden** Runnern grün bestätigen = honest-100% wiederhergestellt, Dual-Verifikations-Bikonditional erfüllt.

**Merksatz für die Zukunft:** Jede ungequotete `${VAR}` als Positions-Argument einer CMake-Funktion ist eine Zeitbombe, sobald `VAR` aus einer `check_cxx_source_runs`-Probe (Leer-auf-Fehlschlag) stammt — sie explodiert erst auf dem Host, der die Probe reißt. Lokal-first muss ISA-repräsentativ sein **oder** die CMake-Logik host-invariant.