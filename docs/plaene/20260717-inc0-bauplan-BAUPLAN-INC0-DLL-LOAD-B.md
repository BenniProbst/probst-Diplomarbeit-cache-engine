# BAUPLAN INC-0 — DLL-Load Option B (Vendor-Archiv-Link-Kanal)

Datei: `docs/plaene/20260717-inc0-bauplan-BAUPLAN-INC0-DLL-LOAD-B.md`
Stand: 2026-07-17 · Basis: Erfassungs-Reports C (Ist-Code), D (Plandokumente), E (Verifikation) + eigene Live-Verifikation der load-bearing Code-Stellen.
Pfad-Konventionen: `SUPER=/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`, `CE=$SUPER/Code/external/comdare-cache-engine`. Code-Zeilen relativ zu `CE/libs/cache_engine/` sofern nicht ausgeschrieben.

---

## (0) KOPF

### Zweck
INC-0 schließt die Laufzeit-DLL-Load-Lücke §17.E (LED:1544-1548): 7 SOTA-Kompositionen (`built=1 loaded=0 load_failed=1 → measured=0`), weil laufzeit-gebaute Tier-`.so` die mimalloc-Symbole `::mi_*` referenzieren (`axes/alloc/axis_06_allocator_mimalloc.hpp:128,150,189,212,246,258`), aber der Out-of-CMake-g++-Subprozess (`make_gpp_compile_fn`, build_orchestrator.hpp:466-489) das mimalloc-Archiv NICHT anlinkt → `dlopen(RTLD_NOW)` (anatomy_module_loader.cpp:40,110-111) gibt `nullptr` → `status_load_failed(=2)`. INC-0 entsperrt `measured>0` und damit den echten Mess-Lauf. **Deadline-kritisch: echter Mess-Lauf muss vor 28.07. starten (V2, LED:1817/1546).**

### Root-Cause in EINEM Satz
Der In-Process-CMake-Pfad löst `mi_*` über den directory-scope `link_libraries(comdare::vendor_mimalloc)` (Top-Level `CMakeLists.txt:576-577`), der auf ALLE CMake-Targets vererbt; der g++-Subprozess erbt NICHTS aus diesem Scope → das Archiv muss ihm explizit gebacken + auf die Link-Zeile gegeben werden.

### Scope-Grenze (hart)
- **ABI-4-kompatibel:** Änderung ist rein host-seitig (Build-Orchestrierung + Fassade). Die Anatomy-ABI (Magic `.A4.`, Major=4, 4 Pflicht-Symbole, module_loader.hpp) bleibt unberührt; die perm-`.so` exportiert dieselben Symbole mit demselben Major. Kein Version-Bump.
- **golden==320 UNVERÄNDERT:** Der Golden-Vertrag (`test_profile_roundtrip`, 320=4·4·5·4) prüft AUSSCHLIESSLICH die XML→binary_id-Projektion (test:94/134-147), NICHT die kompilierten `.so`-Bytes. Link-Flag-Änderungen können den Golden-Vertrag technisch nicht berühren. Golden-Datei `golden_fullpilot_320_binary_ids.txt` = TABU, nur gelesen.
- **TABU unberührt:** Kein Anfassen der eingefrorenen Golden-Liste; kein Major-Bump (der ist für 4→5/INC-2 reserviert, §19.F TABU-GO).
- **Rein additiv:** neuer optionaler 4. Compile-Fn-Parameter (Default `{}`), neues Compile-Def-Makro, neuer Reader — kein Umschreiben bestehender Signaturen/Verträge.

### User-Freigabe-Status
**ERSTELLT ZUR FREIGABE.** Dieser Bauplan ist die Vorlage; der Bau erfolgt erst nach explizitem User-GO der Bau-Phase. Hinweis zur Doktrin: §19.A gibt VERBATIM „volles GO für DLL-Load Option B" — die Design-Entscheidungen sind damit autorisiert; dieser Plan dokumentiert sie freigabefähig, damit der Bau ohne weitere Rückfrage laufen kann. Es gibt für INC-0 KEINE blockierenden offenen Fragen (siehe §7).

---

## (1) IST-KARTIERUNG (datei:zeile — aus Report C übernommen, load-bearing Stellen selbst live verifiziert am 2026-07-17)

| # | Belang | Datei:Zeile | Ist-Zustand (verifiziert) |
|---|---|---|---|
| I1 | `BuildJob`-Struct | `builder/build_orchestrator/build_orchestrator.hpp:86-92` | Felder `index/binary_id/source/output/cores` — KEIN `link_libs`. |
| I2 | perm-Output-Name | build_orchestrator.hpp:270,273 | `job.output = <dir>/<id>/perm.dll` (per_binary_subdirs) bzw. `perm_<id>.dll` — `.so`-ELF unter `.dll`-Namen. |
| I3 | `CompileFn`-Alias | build_orchestrator.hpp:115 | `std::function<int(BuildJob const&)>`. |
| I4 | `make_gpp_compile_fn` Signatur | build_orchestrator.hpp:466-467 | 3 Capture-Params: `include_dirs`, `defines`, `cxx="g++-16"`. KEIN link-Param. |
| I5 | RSP-Aufbau | build_orchestrator.hpp:470-484 | `-std=c++23`(474) `-O2`(475) `-fPIC`(476) `-shared`(477) `-fno-gnu-unique`(478) `-fdiagnostics-color=never`(479); defines(480); `-I"…"`(481); **Source `"<job.source>"`(482)**; **`-o "<job.output>"`(483)**. Aufruf `posix_spawnp({cxx,"@"+rsp})`(487). |
| I6 | Injektion A (thesis) | `profile_facade/profile_run_facade.cpp:154` | `a.compile = ex::make_gpp_compile_fn(perm_include_dirs(), perm_mess_defines(), cxx_compiler());` |
| I7 | Injektion B (experiment) | profile_run_facade.cpp:330 | byte-gleich zu I6 (Kommentar :323 „der EINE Compile-Injektionspunkt"). |
| I8 | Baked-Include-Reader | profile_run_facade.cpp:57-63 | `baked_perm_include_dirs()` → `split_on(COMDARE_FACADE_PERM_INCLUDES,'\|')`. `split_on` @35-48. |
| I9 | Include-Konsum + env-Override | profile_run_facade.cpp:65-73 | `perm_include_dirs()`: env `COMDARE_PILOT_INCLUDES` (Sep `;`) hat Vorrang wenn ≥1 Dir existiert, sonst baked. |
| I10 | Mess-Defines | profile_run_facade.cpp:75-97 | `perm_mess_defines()` liefert `-D…` fix im Code (kein Compile-Def). |
| I11 | Bake-Setter (Includes) | `profile_facade/CMakeLists.txt:131-138` | Compile-Def `COMDARE_FACADE_PERM_INCLUDES` via `$<JOIN:$<REMOVE_DUPLICATES:…>,\|>` aus `_facade_heavy_includes` + mp11 + `_facade_adapter_targets`-INTERFACE_INCLUDE_DIRECTORIES. |
| I12 | Adapter-Target-Liste | profile_facade/CMakeLists.txt:58-80 | enthält `comdare::adapter::a04_mimalloc`(73), `a05_jemalloc`(74), `a07_snmalloc`(76) — deren Include-Dirs sind gebacken; **Archive NICHT.** |
| I13 | Cross-Dir-Genex in Facade-CMake | profile_facade/CMakeLists.txt:132,134 | `$<TARGET_PROPERTY:…>` cross-directory bereits genutzt → `$<TARGET_FILE:…>` funktioniert im selben File analog (generate-time). |
| I14 | mimalloc-Vendor-Target | `CE/ext/CMakeLists.txt:29-50` | `add_library(comdare_vendor_mimalloc STATIC allocator/A04-mimalloc/src/static.c)`(29-30); **`POSITION_INDEPENDENT_CODE ON`(37) ✓**; `MI_STATIC_LIB=1`(34); Alias `comdare::vendor_mimalloc`(43-44); `COMDARE_HAVE_MIMALLOC ON CACHE FORCE`(48). |
| I15 | jemalloc-Vendor-Target | ext/CMakeLists.txt:65-103 | INTERFACE (system) ODER STATIC (source-Build, PIC ON @99). Real meist Stufe-3-Fallback (real=std) → oft INTERFACE. |
| I16 | snmalloc-Vendor-Target | ext/CMakeLists.txt:132-148 | **INTERFACE header-only, KEIN Archiv**; INTERFACE-Defs `SNMALLOC_HEADER_ONLY_LIBRARY=1` etc.(134-141) + `-mcx16` INTERFACE nur x86_64(144-146). |
| I17 | Referenz-Muster (In-Process) | `tools/permutation_codegen/codegen.cmake:606-649` | pro Allokator `target_link_libraries(perm_… PRIVATE comdare::vendor_<x>)` + `COMDARE_PERM_HAVE_<X>=1`. Kanonisches Muster für Option B. |
| I18 | directory-scope-Vererbung | Top-Level `CMakeLists.txt:576-577,593-594` | `link_libraries(comdare::vendor_mimalloc)` erbt Archiv NUR auf CMake-Targets → g++-Subprozess erbt NICHTS = Kern der Lücke. |
| I19 | Symbol-Bedarf | axis_06_allocator_mimalloc.hpp:128,150,189,212,246,258 | `::mi_malloc_aligned/mi_free/mi_calloc/mi_realloc_aligned/mi_usable_size/mi_collect` bei USE_MIMALLOC=1. |
| I20 | SOTA-Fixierung | `compositions/{art:76,hot:49,masstree:53,prt_art:68,start:47,surf:49,wormhole:51}_reference.hpp` | alle `using allocator = axis_06_allocator::MimallocAllocator;` — KEINE fixiert je/sn. → **nur mimalloc-`.a` ist harter Link-Bedarf für golden/SOTA.** |
| I21 | Loader `load()` (Single-File) | anatomy_module_loader.cpp:106-157 | `filesystem::exists(path)`(108) → `native_load(path)`(110) → `!native`→`status_load_failed`(111). **KEIN Extension-Filter.** |
| I22 | Loader-Aufruf im Mess-Pfad | `builder/experiment_tree/cache_engine_builder_iterator.hpp:744` | `AnatomyModuleLoader::load(b.output, handle)` — **PFAD-EXPLIZIT** mit `b.output` (`…/perm.dll`). `load_all()` wird auf dem Mess-Pfad NICHT genutzt (grep=0 in profile_facade + experiment_tree). |
| I23 | Loader-Log (measured-Beleg) | `profile_facade/experiment_run_entry.hpp:252-255` | `[pass] selected=.. loaded=.. load_failed=.. measured=.. resumed=..`. |
| I24 | make_gpp_compile_fn-Callerschaft | grep CE/libs,tests,tools | GENAU 2 Aufrufe (profile_run_facade.cpp:154,330). Keine Test-Aufrufe → 4. Default-Param bricht nichts. |

**Konsequenz-Befund (eigene Verifikation, gegenüber Report C-A14 präzisiert):** Die Extension-Dissonanz `.dll` vs `.so` ist für INC-0 KEIN Blocker. Der Mess-Pfad lädt via `load(b.output,…)` mit dem exakten Pfad aus `job.output`; `load()` filtert NICHT auf Extension. Der `.so`-Filter existiert nur in `load_all()`, das auf dem Mess-Pfad nicht aufgerufen wird. → **INC-0 braucht KEINEN Extension-Fix.** (A14 ist damit de-skopiert; falls später ein `load_all`-basierter Discovery-Pfad hinzukäme, wäre Extension-Harmonisierung ein separater Increment.)

---

## (2) DESIGN

### 2.1 `link_libs`-Feld/Parameter — Entscheidung: Compile-Fn-PARAMETER (kein BuildJob-Feld)
Die anzuhängenden Archive sind **lauf-global** (die enabled-Vendor-Menge ist für ALLE Jobs eines Laufs identisch), nicht per-Binary. Genau wie `include_dirs`/`defines` gehören sie damit in die **Closure der Compile-Fn**, nicht in den per-Job-`BuildJob`. Ein BuildJob-Feld würde jede Job-Erzeugungs-Stelle zur Befüllung zwingen (mehr Fläche, per-Job-Redundanz) und die MSVC-Job-Struct unnötig aufblähen.

- **Feldname/Typ:** `std::vector<std::string> link_libs = {}` — 4. Parameter von `make_gpp_compile_fn`, NACH `cxx`. Default `{}` → alle 3-Arg-Aufrufe (falls je welche) bleiben gültig; nur die 2 Facade-Aufrufe reichen das 4. Argument durch.
- **rsp-Position (ZWINGEND):** Archive kommen NACH der Quelldatei auf die Link-Zeile. Konkret: neue Schleife zwischen `build_orchestrator.hpp:482` (Source-Emit) und `:483` (`-o`). Begründung ld-Semantik: statische Archive werden left-to-right on-demand gescannt; ein Archiv VOR der referenzierenden Quelle findet keine offenen undefined-Refs → zieht keine Member → `mi_*` blieben unaufgelöst (identischer dlopen-Fehler). `-shared` erlaubt undefined-Symbole beim Bau, aber `dlopen(RTLD_NOW)` scheitert dann → genau I21. Quelle-vor-Archiv ist daher Pflicht.

### 2.2 Bake-Mechanismus — neues Compile-Def analog `COMDARE_FACADE_PERM_INCLUDES`
Neuer Setter in `profile_facade/CMakeLists.txt`, unmittelbar NACH Z.138. Symmetrisch zu I11: CMake-`;`-Liste von `$<TARGET_FILE:…>`-Genexes → `$<REMOVE_DUPLICATES>` → `$<JOIN:…,|>` in ein `"…"`-String-Literal-Makro `COMDARE_FACADE_PERM_LINK_LIBS`.

**Exakter CMake-Vorschlag (an CMakeLists.txt nach Z.138 anhängen):**
```cmake
# ── INC-0 (DLL-Load Option B): Vendor-Allokator-Archive für den Out-of-CMake-g++-Perm-Link baken. ──
#    Analog COMDARE_FACADE_PERM_INCLUDES (Z.131-138): der Laufzeit-g++-Subprozess (make_gpp_compile_fn)
#    erbt NICHTS vom directory-scope link_libraries() (Top-Level CMakeLists.txt:576-595) → Archiv-Pfade
#    explizit baken. Archiv-Pull ist symbolgetrieben (on-demand): nicht referenzierte Archive ziehen
#    keine Member → deterministisch, fair, KEIN whole-archive nötig.
set(_facade_perm_link_libs "")
if(COMDARE_HAVE_MIMALLOC AND TARGET comdare_vendor_mimalloc)
    list(APPEND _facade_perm_link_libs "$<TARGET_FILE:comdare_vendor_mimalloc>")
endif()
# jemalloc nur wenn als STATIC-Archiv gebaut (source-Build); INTERFACE-Fallback (real=std) hat kein TARGET_FILE.
if(COMDARE_HAVE_JEMALLOC AND TARGET comdare_vendor_jemalloc)
    get_target_property(_je_type comdare_vendor_jemalloc TYPE)
    if(_je_type STREQUAL "STATIC_LIBRARY")
        list(APPEND _facade_perm_link_libs "$<TARGET_FILE:comdare_vendor_jemalloc>")
    endif()
endif()
if(_facade_perm_link_libs)
    list(JOIN _facade_perm_link_libs ";" _facade_perm_link_expr)
    target_compile_definitions(comdare_profile_run_facade PRIVATE
        "COMDARE_FACADE_PERM_LINK_LIBS=\"$<JOIN:$<REMOVE_DUPLICATES:${_facade_perm_link_expr}>,|>\"")
endif()
```
Anmerkungen: `COMDARE_HAVE_MIMALLOC` (Cache-Var, `ext/CMakeLists.txt:48`) ist Ordering-unabhängig verfügbar; der `if(TARGET …)`-Guard schützt `$<TARGET_FILE>` und `get_target_property`. `$<TARGET_FILE:comdare_vendor_mimalloc>` liefert generate-time den absoluten `.a`-Pfad im Build-Baum (z.B. `…/build-i2/…/ext/libcomdare_vendor_mimalloc.a`). Cross-Directory-Genex ist im selben File bereits Praxis (I13).

### 2.3 Einlese-Code-Stelle in `profile_run_facade.cpp`
Neuer Reader unmittelbar NACH `baked_perm_include_dirs()` (nach Z.63), plus optionaler env-Override symmetrisch zu `perm_include_dirs()`:
```cpp
[[nodiscard]] std::vector<std::string> baked_perm_link_libs() {
#ifdef COMDARE_FACADE_PERM_LINK_LIBS
    return split_on(COMDARE_FACADE_PERM_LINK_LIBS, '|');
#else
    return {};
#endif
}

[[nodiscard]] std::vector<std::string> perm_link_libs() {
    if (char const* e = std::getenv("COMDARE_PILOT_LINK_LIBS"); e != nullptr && *e != '\0') {
        std::vector<std::string> env_libs = split_on(e, ';');
        std::erase_if(env_libs, [](std::string const& p) { return !std::filesystem::exists(p); });
        if (!env_libs.empty()) return env_libs;
        std::cerr << "[profile_facade] COMDARE_PILOT_LINK_LIBS gesetzt, aber keine Datei existiert; "
                     "nutze gebackene Link-Lib-Liste.\n";
    }
    return baked_perm_link_libs();
}
```
Durchreichen an BEIDEN Injektionsstellen (I6/I7), 4. Argument:
```cpp
a.compile = ex::make_gpp_compile_fn(perm_include_dirs(), perm_mess_defines(), cxx_compiler(), perm_link_libs());
```
(Der env-Override ist optional/Debug-Komfort; kann bei Minimal-Fläche entfallen — dann nur `baked_perm_link_libs()`. Empfehlung: behalten, wegen Symmetrie zu `COMDARE_PILOT_INCLUDES` und lokaler Reproduzierbarkeit.)

### 2.4 Vendor-Abdeckung
- **mimalloc:** echtes STATIC-`.a`, PIC ON (I14) → auf die g++-Link-Zeile via `$<TARGET_FILE:comdare_vendor_mimalloc>`. **Einziger harter Bedarf für golden/SOTA** (I20). Verifiziert.
- **jemalloc:** nur wenn als STATIC gebaut (source-Build, PIC ON @99); im üblichen Stufe-3-Fallback INTERFACE → kein Archiv, kein Link nötig, kein Symbol-Bedarf in golden. Der CMake-Block linkt es NUR bei `TYPE==STATIC_LIBRARY` → automatisch korrekt, keine golden-Wirkung.
- **snmalloc — Sonderfall:** header-only INTERFACE (I16), erzeugt KEIN Objektcode-Archiv → braucht **KEINE Link-Behandlung**. Sein Bedarf ist eine **Compile-Flag-**Sache: die INTERFACE-Defs `SNMALLOC_HEADER_ONLY_LIBRARY=1`/`SNMALLOC_USE_CXX17=0`/… + `-mcx16` (x86_64) müssten in die g++-`defines` der perm-Kompilierung, WENN eine snmalloc-Komposition gebaut wird. In golden/SOTA fixiert KEINE Komposition snmalloc (I20) → **snmalloc ist für INC-0 out-of-scope.** Mechanismus für später dokumentiert: analog zu `perm_mess_defines()` ein gebackenes `COMDARE_FACADE_PERM_EXTRA_CFLAGS` (mit `-mcx16` + `SNMALLOC_*`), das in die defines-Schleife (build_orchestrator.hpp:480) einfließt. Nicht Teil von INC-0.

### 2.5 Entscheidung Link-Strategie — ALLE enabled STATIC-Vendor-Archive immer anhängen (append-all)
**Empfehlung: append-all-enabled (nicht selektiv je Komposition).** Begründung:
1. **Symbolgetrieben & deterministisch:** ld zieht aus einem `.a` NUR die Member, die eine offene undefined-Ref befriedigen. Da jede perm-`.cpp` genau EINE `EnabledVendors`-Wahl statisch fixiert (I20) und nur deren `::mi_*`/`::je_*` referenziert, zieht ein nicht-referenziertes Archiv NULL Member → keine Größen-/Symbol-Wirkung, keine Multiple-Definition (kein zweites Archiv trägt bei). Fairness bleibt gewahrt: jede perm-`.so` bekommt genau die Allokator-Instanz ihrer Komposition, isoliert unter `RTLD_LOCAL`.
2. **Keine per-Komposition-Logik in der Compile-Fn nötig** → das Mapping „Allokator-Wahl → Archiv" entfällt; die Fassade backt die enabled-Menge EINMAL, die Compile-Fn hängt sie unbesehen an. Löst DF-mapping (Report D 1.6): **Mapping wohnt in der Fassade (backt alle enabled), NICHT in der Compile-Fn (keine Selektion).**
3. **Minimal-Realität:** In golden/SOTA ist die enabled-relevante Archiv-Menge de facto = {mimalloc} (jemalloc meist INTERFACE, snmalloc header-only). Append-all reduziert sich hier automatisch auf mimalloc.

**Konservative Rückfall-Variante (nur falls in INC-0c ein Multiple-Definition-/Interpositions-Fehler auftritt):** selektiv nur `$<TARGET_FILE:comdare_vendor_mimalloc>` baken (das genügt für golden/SOTA nachweislich, I20). Beide Varianten liefern für golden/SOTA identische Bytes.

### 2.6 PIC-Voraussetzung
Verifiziert: mimalloc `POSITION_INDEPENDENT_CODE ON` (I14, ext/CMakeLists.txt:37); jemalloc source-Build PIC ON (Z.99). Beide Archive sind PIC → einlinkbar in `-fPIC -shared`-perm-`.so` (build_orchestrator.hpp:476-477). **Trotzdem als Prüf-Schritt 0** in die Schrittfolge aufgenommen (readelf-Kontrolle), damit ein nicht-PIC-Archiv sofort auffällt statt als kryptischer Relokations-Fehler.

### 2.7 whole-archive — NEIN (begründet)
Kein `--whole-archive`. Die `mi_*`-Symbole werden direkt/odr-genutzt (die Wrapper-Calls kompilieren in perm_<id>.o) → on-demand-Pull genügt. `--whole-archive` würde ALLE mimalloc-Member erzwingen (Bloat) und Interpositions-/Multiple-Def-Risiken öffnen. Kein Init-Seiteneffekt erkennbar: mimalloc `static.c` (MI_STATIC_LIB, KEIN MI_OVERRIDE) interponiert weder globales `operator new` noch `malloc`; die Wrapper rufen ausschließlich explizite `mi_*`-APIs → keine „verwaisten" globalen Ctors, die nur via whole-archive gezogen würden. Deckt sich mit KL §9 („i.d.R. UNNÖTIG"). DF-whole-archive damit aufgelöst: **nein.** (W5 aus Report D: der „whole-archive"-Kontext im DOSSIER bezog sich auf Option A, kein echter Widerspruch.)

---

## (3) SCHRITTFOLGE — Mini-Increments

### Prüf-Schritt 0 (Precondition, rein lesend, KEIN Edit)
- **Datei/Aktion:** super-Sub-Build-Baum konfiguriert vorliegen lassen (`$SUPER/Code/build-i2`, Ninja, jüngster funktionsfähiger Baum — Report E (2)). Archiv-Existenz + PIC prüfen.
- **Eigene literale Verifikation:**
  ```
  cmake -S $SUPER/Code -B $SUPER/Code/build-i2 -G Ninja -DCOMDARE_V32_ENABLE=ON -DCMAKE_BUILD_TYPE=Release
  find $SUPER/Code/build-i2 -name 'libcomdare_vendor_mimalloc.a'
  # ERW: genau 1 Treffer (Archiv existiert im Build-Baum)
  readelf -h <archiv> 2>/dev/null | head -1 ; ar t <archiv> | head
  # ERW: gültiges Archiv; Member vorhanden
  ```
  PIC ist per Config garantiert (I14); der eigentliche PIC-Nachweis erfolgt implizit dadurch, dass der `-shared`-Link in INC-0c ohne Relokations-Fehler durchläuft.

### INC-0a — Feld (Compile-Fn-Param + RSP-Emit) + Bake (Compile-Def)
- **Dateien:**
  1. `builder/build_orchestrator/build_orchestrator.hpp:466-489`
  2. `profile_facade/CMakeLists.txt` (nach Z.138)
- **Änderungsskizze:**
  - `make_gpp_compile_fn`: 4. Param `std::vector<std::string> link_libs = {}` (nach `cxx`), in die Lambda-Capture aufnehmen; neue Schleife `for (auto const& l : link_libs) rf << "\"" << l << "\"\n";` **zwischen Z.482 (Source) und Z.483 (`-o`)**.
  - CMakeLists: der Bake-Block aus §2.2 (Setter `COMDARE_FACADE_PERM_LINK_LIBS`).
- **Eigene literale Verifikation:**
  ```
  ~/tools/cf22/usr/bin/clang-format-22 --dry-run --Werror \
      $CE/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp
  cmake -S $SUPER/Code -B $SUPER/Code/build-i2 -G Ninja -DCOMDARE_V32_ENABLE=ON -DCMAKE_BUILD_TYPE=Release
  cmake --build $SUPER/Code/build-i2 --target comdare-messung-driver
  # ERW: build grün; Makro gesetzt — Nachweis via compile_commands / defines-Dump:
  grep -r 'COMDARE_FACADE_PERM_LINK_LIBS' $SUPER/Code/build-i2 --include=*.ninja --include=compile_commands.json | head
  # ERW: mind. 1 Treffer mit dem absoluten libcomdare_vendor_mimalloc.a-Pfad
  ```

### INC-0b — Einlesen + Durchreichen
- **Dateien:** `profile_facade/profile_run_facade.cpp` (Reader nach Z.63; Aufruf-Erweiterung Z.154 + Z.330).
- **Änderungsskizze:** `baked_perm_link_libs()` + `perm_link_libs()` aus §2.3; beide `make_gpp_compile_fn(...)`-Aufrufe um `, perm_link_libs()` erweitern.
- **Eigene literale Verifikation:**
  ```
  ~/tools/cf22/usr/bin/clang-format-22 --dry-run --Werror \
      $CE/libs/cache_engine/profile_facade/profile_run_facade.cpp
  cmake --build $SUPER/Code/build-i2 --target comdare-messung-driver
  DRIVER=$SUPER/Code/build-i2/02_messung_driver/comdare-messung-driver
  rm -rf /tmp/inc0_out && COMDARE_E4_CAP=2 "$DRIVER" experiment_config /tmp/inc0_out
  # Sofort-Nachweis: die generierte perm-RSP enthält die Archiv-Zeile NACH der Source-Zeile:
  find /tmp/inc0_out -name 'perm.dll.rsp' | head -1 | xargs grep -n 'libcomdare_vendor_mimalloc.a'
  # ERW: 1 Treffer; im RSP steht "…/perm.cpp" VOR "…/libcomdare_vendor_mimalloc.a" VOR "-o …/perm.dll"
  ```

### INC-0c — Verifikations-Läufe (siehe §4 für die volle Sequenz)
- **Dateien:** keine (nur Läufe/Belege).
- **Änderungsskizze:** —
- **Eigene literale Verifikation:** die S0–S5-Sequenz aus §4; Kern-Gate: Loader-Zeile `loaded>0 load_failed=0 measured>0` (I23) + echte CSV-Datenzeilen.

---

## (4) VERIFIKATIONS-PLAN (aus Report E — Kommandosequenz mit Erwartungswerten)

Vorbedingung: Linux/Ninja-Pfad (NICHT der MSVC-Weg der Standalone-Memory — Report E WARNUNG). Frischester Baum `build-i2`.

```
# S0 — clang-format-Konformität (prod1-Ersatz, CI-identisch cf22 22.1.8)
~/tools/cf22/usr/bin/clang-format-22 --dry-run --Werror \
    $CE/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp \
    $CE/libs/cache_engine/profile_facade/profile_run_facade.cpp
# ERW: rc 0, keine Ausgabe

# S1 — super-Sub-Build (Lücke-1-Doktrin: NICHT nur Standalone-ce) + driver
cmake -S $SUPER/Code -B $SUPER/Code/build-i2 -G Ninja -DCOMDARE_V32_ENABLE=ON -DCMAKE_BUILD_TYPE=Release
cmake --build $SUPER/Code/build-i2 --target comdare-messung-driver
# ERW: STATUS "[messung_driver] E4-XML-Fassade angedockt"; Binary build-i2/02_messung_driver/comdare-messung-driver

# S2 — golden-320-Roundtrip-Gate (Profil-Projektion, gate-frei, KEIN DLL-Run)
cmake -S $CE -B $CE/build-cov -G Ninja -DCOMDARE_BUILD_TESTS=ON
cmake --build $CE/build-cov --target test_profile_roundtrip
ctest --test-dir $CE/build-cov -R '^test_profile_roundtrip$' --output-on-failure -V
# ERW: "golden binary_count == 320" PASS; profile binary_count==320; Diff leer; static_levels==19; ctest 1/1 Passed

# S3 — Pre-Flight (rein lesend, m3v2_study.profile.xml, Root=comdare_thesis_profile)
$SUPER/Code/build-i2/02_messung_driver/comdare-messung-driver --validate
# ERW: validate_profile_facade druckt Achsen-/Werte-Gate OK, exit 0

# S4 — DLL-Load-B-Smoke mit Kappung (echter Laufzeit-DLL-Pfad, cap>1 damit mimalloc-SOTA zuerst dran ist)
rm -rf /tmp/inc0_out
COMDARE_E4_CAP=2 $SUPER/Code/build-i2/02_messung_driver/comdare-messung-driver experiment_config /tmp/inc0_out
# ERW: Loader-Zeile "  [pass] selected=.. loaded=>0 load_failed=0 .. measured=>0 resumed=.."  (KEIN load_failed>0)
#      driver-Zeile "[E4] fertig: exit=0 .. measured=>0 .." ; /tmp/inc0_out/e4_xml/measurements.csv existiert

# S5 — CSV-Belege
head -1 /tmp/inc0_out/e4_xml/measurements.csv     # ERW: "binary_id;setting;repetition;n_ops;total_ns;ns_per_op;..." (lazy_csv_header)
wc -l /tmp/inc0_out/e4_xml/measurements.csv        # ERW: > 1 (Header + >=1 echte Messzeile)
grep -c 'failed' /tmp/inc0_out/e4_xml/measurements.csv  # ERW: 0 (keine Algo-Fehlerzellen)
```

### Volle Kadenz (§19.F / V3, LED:1824) — nach dem Smoke
```
# ctest-Targets die INC-0 berühren (super da_unit + ce profile_facade-Umfeld)
ctest --test-dir $SUPER/Code/build-i2 -L da_unit --output-on-failure
ctest --test-dir $CE/build-cov -R '^(test_builder_codegen|test_experiment_driver_v13|test_profile_coverage|test_experiment_parser|test_validate_profile|test_profile_roundtrip)$' --output-on-failure
# ERW: alle Passed

# cf22-Konformität gesamt-Diff (rc 0)   — Erwartung cf22-22.1.8==0
# Mojibake-Check auf berührte Dateien:
grep -rIl $'Ã\|â¬' \
    $CE/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp \
    $CE/libs/cache_engine/profile_facade/profile_run_facade.cpp \
    $CE/libs/cache_engine/profile_facade/CMakeLists.txt
# ERW: KEINE Treffer (Mojibake 'Ã|â€' == 0)
```

### Golden-Vertrag & Roundtrip
- `test_profile_roundtrip == 320` unverändert (S2). Weitere Gate-Werte (Report E (4)): `base_tiers==7`, `working_set_sweep==4`, `axis_sweeps==8`, `sota_series==21`, `run_options.cap==320`, `profile static_levels==19`.

### Beide Remotes / CI-Verhalten
- Nach GO+Bau: beide Remotes ref-gleich (origin=gitlab, github=github), granular committen — ABER: **KEINE Commits/Pushes im Rahmen dieses Bauplans** (Doktrin (4)); erst in der Bau-Phase nach User-GO.
- **CI-Verhalten:** Der DLL-Laufzeit-Pfad lebt AUSSCHLIESSLICH im super-Repo (`.gitlab-ci.yml`, Stage `measure`). `measure:smoke`/`measure:golden-320` bauen denselben `make_gpp_compile_fn`-Pfad → sie profitieren automatisch vom gebackenen `COMDARE_FACADE_PERM_LINK_LIBS` (Compile-Def am Facade-Static-Lib). Beide Jobs sind INERT (nur bei `COMDARE_RUN_MEASURE=="true"` bzw. `COMDARE_MEASURE_PROFILE=="smoke"`, Report E (7)). CI-Grün = Messung AUS bleibt gewahrt; der Fix ändert NICHTS am Gating. CI-Modus a (lokal-doppelt-verifiziert) bei baremetal-Block.

---

## (5) RISIKEN + ROLLBACK

| # | Risiko | Wirkung | Mitigation / Rollback |
|---|---|---|---|
| R1 | Kern-Compile-Fn betrifft ALLE Messungen (DOSS:16) | breite Wirkung | additiver Default-Param `{}` → 3-Arg-Verhalten unverändert; nur die 2 Facade-Aufrufe aktivieren den Kanal. Rollback = 4. Arg entfernen. |
| R2 | nicht-PIC-Archiv | `-shared`-Link scheitert (Relokation) | mimalloc/jemalloc PIC verifiziert (I14, Z.99); Prüf-Schritt 0 + INC-0a-Link-Lauf fangen es literal. |
| R3 | snmalloc `-mcx16`/Defs | falsch, wenn snmalloc-Komposition gebaut würde | out-of-scope für golden/SOTA (I20); dokumentierter Compile-Flag-Zweig (`COMDARE_FACADE_PERM_EXTRA_CFLAGS`) für späteren Increment. INC-0 unberührt. |
| R4 | Link-Reihenfolge (Archiv vor Source) | `mi_*` bleiben undefined → dlopen scheitert weiter | RSP-Emit zwingend NACH Source (§2.1, INC-0a); INC-0b verifiziert die RSP-Zeilenfolge literal. |
| R5 | Multiple-Definition/Interposition bei append-all | Link-Fehler | on-demand-Pull zieht nur referenzierte Member (§2.5); mimalloc interponiert kein globales new/malloc (§2.7). Rückfall: selektiv nur mimalloc baken (§2.5 konservativ). |
| R6 | rsp-Quoting von Pfaden mit Sonderzeichen | Argument-Bruch | Archiv-Pfade sind Build-Baum-Pfade (kein Space/`\|` üblich); RSP wrappt in `"…"` (identisch zur bestehenden Source-/`-o`-Zeile); `\|`-Separator-Kollision nur bei `\|` im Pfad (praktisch ausgeschlossen). Gleiches Präzedenz-Risiko wie `COMDARE_FACADE_PERM_INCLUDES`. |
| R7 | Baked absoluter Build-Baum-Pfad | bricht, wenn driver ohne Build-Baum verschoben/kopiert wird | identische Constraint wie bestehendes `COMDARE_FACADE_PERM_INCLUDES` (bäckt build-tree-absolute Include-Dirs) → akzeptiertes Präzedenz-Modell; CI baut+läuft im selben Baum. |
| R8 | CI-Runner ohne vendor-Artefakt | perm-Compile findet `.a` nicht | `measure:*`-Jobs bauen `comdare-messung-driver` im selben Baum, der `comdare_vendor_mimalloc` mit erzeugt (add_subdirectory(ext)) → Archiv liegt im Baum. `if(TARGET …)`-Guard verhindert Bake ohne Archiv (dann kein Kanal, alter Zustand). |
| R9 | Wechselwirkung mit CI-Mess-Job | Mess-Job könnte weiter measured=0 liefern | Fix greift auf demselben Pfad → Mess-Job wird durch S4 lokal + optional `measure:smoke` (opt-in) mitverifiziert (Risk2 Report D). |
| R10 | golden==320 verändert sich | Vertragsbruch | technisch ausgeschlossen: Roundtrip prüft Projektion, nicht `.so`-Bytes (Scope-Grenze §0); S2 belegt 320 unverändert. |

**Globaler Rollback:** alle drei Edits (build_orchestrator.hpp 4. Param + RSP-Zeile; profile_run_facade.cpp Reader + 2 Aufrufe; CMakeLists Bake-Block) sind isoliert additiv und einzeln revertierbar; ohne Bake-Makro fällt `baked_perm_link_libs()` auf `{}` zurück → exakter Vor-INC-0-Zustand.

---

## (6) PLANUNGS-INDEX FOLGE-INCREMENTS (aus Report D Teil 3 — Pflicht-Lektüre für eigene ultracode-Planungssessions)

### INC-1 — CEB-System-Achsen-Schichtung (§19.E-3, DELTA = fehlende Schichtung §19.D)
**Muss-Lektüre vor der Planungssession:**
- `docs/DIPLOMARBEIT-…-LEDGER.md` §19.C/§19.D/§19.E-3 (bindendes Architektur-Modell; CEB-System-Achsen ⊃ Tier-Achsen) + §18 Vorrang-Regel.
- `docs/architektur/20260717-konstruktionslogik-durchdringung-KONSTRUKTIONSLOGIK.md` **§6/§8** (Schichtung = INC-1-Kern).
- `docs/ledger-sections/20260717-voll-konsolidierung-LEDGER-SECTION-18.md` (§18.5.1 Roadmap, Q1-Q5, Vorrang S18:5) — Pflicht-Einstieg.
- `docs/sessions/backups/20260716-f4-systemachsen-dossier/` (F4: 4 CEB-System-Achsen-Design) — Pflicht.
- `docs/sessions/backups/20260716-e18-ebene1-und-h1-hardware-design/` (H-1/H-6..H-10 Hardware-System-Achse) — Pflicht.
- `docs/sessions/backups/20260710-phase01-simd-dispatch/` (H-7 `-march`/`-mavx`/AVX-Kopplung) — Pflicht.
- `docs/sessions/backups/20260710-phase02-general-hardware-design/` (general_hardware-Achse) — Pflicht.
- Ergänzend: `20260716-s7-locking-observer-research/` (Observer-Schichtung), `20260716-e17-e18-deep-research/` (H-1/P-E-Core 0x1A), `20260711-e4prime-messkurven-typsystem-wurzel/` (Heuristik-Messkurven).
**Kritischste vorab bekannte Design-Punkte:**
1. **Strikte E4→E0-Trennung:** Organ-(Tier-)Achsen vs. System-(CEB-)Achsen NIE mischen; System-Achsen umschließen die Tier-Achsen (eigene abstrakte Wurzel/„Blut", MEMORY: system_axes_measurement_own_abstract_root).
2. **Q2 Scheduling = compile-time CRTP+Concept-System-Achse** (kein Runtime-Switch, `no_runtime_switch`/`compile_time_only`).
3. **Q5 H-7 `-march`/`-mavx` koppelt an neue Metadaten-Version** → Koordinations-Naht zu INC-2 (Version-Bump gehört in den 4→5-Bump; INC-1 darf nur den compile-time-Achsen-Rahmen legen, nicht den Major bumpen).

### INC-2 — koordinierter 4→5-Bump (§19.E-4, Design = F12III; EINER reservierter Major-Bump, TABU-GO §19.F)
**Muss-Lektüre vor der Planungssession:**
- `docs/architektur/20260717-konstruktionslogik-durchdringung-F12III-DESIGN-VORLAGE.md` **komplett** (4→5-Bruch, Grenz-Landkarte, Golden-Umbau, Increment-Schnitt §7) + `KONSTRUKTIONSLOGIK.md` **§3/§4/§7**.
- `LEDGER-SECTION-18.md` (§18.5.1, §18.1.6/§18.3.3-F2, §18.1.8 2-Registry-Kanon, Q1-Q5) — Pflicht-Einstieg.
- Ledger §19.E-4 (faltet Golden-Neubau in den 4→5-Bump) + §19.F (TABU-GO reservierter Major).
- `docs/sessions/backups/20260716-e18-ebene1-und-h1-hardware-design/` (F1b Set-Promotion auf Ebene-1/Gattung=4) — Pflicht.
- `docs/sessions/backups/20260716-experiment-planer-codegen-design/` (Planer-Dock, F5-Codegen, EIN-Director/ZWEI-Builder) — Pflicht.
- Ergänzend: `20260716-gesamtkonzept-experiment-ausfuehrung/` (Planer→CEB→Tier-Fluss), `20260716-fork-a-bruecken-dossier/` (I4-Naht `experiment_run_entry.hpp`), `20260713-achsen-gattungen-metaprog/` (Gattungs-Kopf-Frameworks CRTP+Concept), `20260713-design-zwei-registry-experiment-strategy/` (Planer-Dock/2-Registry), `20260711-e4prime-cor-filter-chain/` (Heuristik-CoR/Command Tier-Binary), `20260710-phase6-vorbau-impl/` (Telemetrie Phase-6, F12iii), `20260716-e11-phasen-e13-kontext/` (#37 3-Achsen-Scheduling).
- WARNUNG-Kontext (verworfen, nicht bauen): `20260716-wp1-parallel-engine-gestoppt-fork-a/`, `20260710-axis-binding-registry-VERWORFEN/`.
**Kritischste vorab bekannte Design-Punkte:**
1. **Golden ZERLEGT+UMGEBAUT ist autoritativ** (§18-Vorrang, W2: F2/LED:368-370 kehrt „golden unverändert" um) — ABER **W3 offen**: Golden-Neu-Materialisierung als EIGENES INC-3 (F12III §7 / S18:102) vs. in den 4→5-Increment gefaltet (§19.E-4). → Struktur-Entscheidung für INC-2 (siehe §7).
2. **W4 Set-Genus-Scope:** `ISetTier`/`SetObserverSnapshotV1`/`GenusBindingTraits<Set>` slot_count=15 existieren teils (F1a, S18:194), aber `SetDock` + native Set-ABI-V2-POD sind der NEUE Teil (F2). Scope präzise schneiden.
3. **Der 4→5 ist der EINE reservierte Major-Bump** (TABU-GO): F1b (Set-Gattung), F2 (SetDock), #37 (3-Achsen-Scheduling), Q5 (Metadaten-Version) MÜSSEN in diesen einen Bump koordiniert werden; Magic `.A4.`→`.A5.`.

---

## (7) OFFENE DETAILFRAGEN AN DEN USER

**Doktrin-Check vorangestellt:** Alle DFs aus Report D 1.6 wurden gegen Ledger/Plandocs + Design geprüft und sind AUFGELÖST (nicht offen):
- DF-whole-archive → **nein** (§2.7, KL §9).
- DF-PIC → **alle relevanten Archive PIC** (§2.6, I14).
- DF-link-order → **Source zuerst, Archive danach; Archiv↔Archiv-Reihenfolge irrelevant** (unabhängige Archive) (§2.1).
- DF-bake-format → **`COMDARE_FACADE_PERM_LINK_LIBS`, `|`-separiert, `$<JOIN:…,|>`** (§2.2).
- DF-mapping-Allokator→Archiv → **Fassade backt alle enabled; Compile-Fn selektiert nicht** (§2.5).
- DF-Bau-Ort (BuildJob-Feld vs. Param) → **Compile-Fn-Parameter** (§2.1).
- DF-snmalloc → **out-of-scope für golden/SOTA; Compile-Flag-Zweig dokumentiert** (§2.4).
- DF-jemalloc → **append-all deckt jemalloc automatisch, aber nur wenn STATIC gebaut; in golden meist INTERFACE → kein Link** (§2.4). „volles GO für Option B (voll)" (§19.A) autorisiert append-all.

**→ INC-0 hat KEINE blockierenden offenen Fragen.** Der Bau kann nach GO der Bau-Phase ohne weitere Rückfrage laufen.

Die folgenden Punkte sind NICHT INC-0-blockierend, aber echte Entscheidungen, die der User zur Kenntnis nehmen / entscheiden sollte:

1. **[INC-2, echt offen — W3]** Golden-Neu-Materialisierung als **eigenes INC-3** (so F12III §7 + S18:102/§18.5.1) ODER **in den 4→5-Bump gefaltet** (so Ledger §19.E-4)? Zwei autoritative Quellen divergieren strukturell. Nicht für INC-0 nötig, aber vor INC-2-Planung zu klären.
2. **[Repo-Hygiene, minor — W1]** I4-super-Commit-SHA-Diskrepanz `c78359d` (§12/LED:371) vs. `a92f362` (§17.E/LED:1544), von S18:195 selbst markiert. §19.G (super `8488d1d`) ist der maßgebliche aktuelle Stand; die alten SHAs sind historisch. Nur beim Repo-Stand-Abgleich zu quittieren, nicht blockierend.
3. **[INC-0, Bestätigung/Default — optional]** Link-Strategie-Default = **append-all-enabled** (empfohlen, §2.5). Falls der User bewusst „nur mimalloc baken" (minimal) will, ist das die konservative Variante mit identischen golden/SOTA-Bytes. Default steht; nur bei ausdrücklichem Gegenwunsch ändern.
