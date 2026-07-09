# DOSSIER #279-a — Konfigurierbare Mess-Durchführung + dynamische Tier-Binary-Build-Sichtbarkeit (2026-07-07)

**Board:** #279 (Task #22, VORLETZTE Aufgabe) · **Scope dieser Increment:** der **non-gated Code/Pipeline-Slice** (Hook-Korrektur 07.07.: der Punkt war fälschlich pauschal „cluster-gated" markiert). **NUR super-seitig** (Code/CMakeLists.txt, Code/cmake/, Code/07_tier_binary_report/, Code/02_messung_driver/, Code/tests/, .gitlab-ci.yml) — KEINE ce/prt-art/thesis-Änderung ⇒ kein Cross-Projekt-auto-cancel, super-Welle beweist direkt.

## 0. Untouchables (nur LESEN, nie ändern)
`golden_fullpilot_320` · `permutation_axes.xml` · Conformance-Oracle `std::map<uint64,uint64>` (`conformance_gate.hpp`) · ABI-MAJOR==4 · die Tier-Binary-**Metaprogrammierung** (Boost.MP11-Codegen, `anatomy_codegen.cmake`/`adhoc_emitter.cmake`) bleibt **compile-time** — diese Increment fügt NUR Orchestrierung+Reporting hinzu, degradiert nichts zu runtime.

## 1. Ist-Stand (Explore-Map a2d92e7c + eigene Verifikation)
- **CacheEngineBuilder** = App `comdare-cache-engine-builder` (`COMDARE_BUILD_BUILDER` ON) + Klasse `BuildOrchestrator` mit `BuildStats{total_jobs,succeeded,failed,skipped,built,peak_concurrency}` — **berechnet, aber nie an CI ausgegeben**.
- **Tier-Binaries** = per-Rekombination `.so/.dll` (Codegen). Geplante Menge: `permutations_manifest.txt` (Profil smoke~27/medium~108/full), Wrapper-Libs `perm_<id>.so` unter `${BINARY_DIR}/perm/{cache_engine,prt_art}/`.
- **Mess-Modus-Schalter EXISTIERT ce-seitig** (`COMDARE_RELEASE_MODE`/`COMDARE_MEASUREMENT_MODE`, ce CMakeLists:103-123) — regelt nur, ob Mess-Code *einkompiliert* wird, NICHT ob ein Lauf *ausgeführt* wird. ⇒ Nicht clashen; darauf aufbauen.
- **ABSENT (#279-Lücken):** (1) kein „Mess-Lauf-RELEASE-vor-PDF"-Orchestrierungsschalter super-seitig; (3) keine CI-Sichtbarkeit „welche Rekombinationen bauen / wie viele offen / CacheEngineBuilder gebaut?"; (4) kein nachgelagerter Schritt, der ALLE gebauten Tier-Binaries über ihr generisches Interface prüft und je Binary PASS/FAIL rostert (die ce-Conformance-Gate *droppt* nur, rostert nicht).
- **Plugin-Contract** (`Code/02_messung_driver/plugin_loader.hpp`): `extern "C" comdare_perm_descriptor()` → `PermDescriptor{id,version,axes,run}`, `run(unsigned long,double*)`; `discover_plugin_paths` (perm_*), `load_perm_plugin`, `LoadedPlugin{handle,desc,path}`.

## 2. Soll — Increment #279-a (Default-sicher, testbar, grün-beweisbar)

### (A) Pipeline-Mess-Modus-Schalter — `Code/CMakeLists.txt`
```
set(COMDARE_DA_PIPELINE_MODE "debug_sample" CACHE STRING
    "Mess-Durchfuehrung der Pipeline: debug_sample (synthetische Sample-Daten -> PDF, Default) | release_measure (echter messung_driver-Lauf ueber experiment_config VOR der PDF)")
set_property(CACHE COMDARE_DA_PIPELINE_MODE PROPERTY STRINGS debug_sample release_measure)
```
- `debug_sample` (Default): `comdare_pipeline_e2e` UNVERÄNDERT (synthetisch) ⇒ normale Pipeline unberührt, kein schwerer Lauf.
- `release_measure`: neues Target `comdare_pipeline_release` — DEPENDS `comdare_perms_all` + `messung_driver`; ruft `messung_driver <experiment_config> <out> --messreihen-xml=experiment_config/messreihen.xml` (realer Lauf, forward `-DCOMDARE_RELEASE_MODE=ON`/`-DCOMDARE_MEASUREMENT_MODE=ON` an den ce-Sub-Build dokumentiert), dann 03→04→05→06 mit ECHTEN Records. **Wird in CI NICHT getriggert** (mehrtägiger Lauf #156 bleibt HELD) — der Schalter ist die #279(1)/(2)-Deliverable, der scharfe Lauf bleibt opt-in/lokal.

### (B) Tier-Binary-Build-Sichtbarkeit — neues Modul `Code/07_tier_binary_report/`
Header-only Lib `comdare::tier_binary_report` (`tier_binary_report.hpp`) — PURE, dlopen-frei, testbar:
- `PlannedSet parse_manifest(path)` — `permutations_manifest.txt` lesen, `#`/leer überspringen, perm-ids sammeln.
- `BuiltSet scan_built(perm_root)` — Dateiscan `perm_*.{so,dll,dylib}` unter `{cache_engine,prt_art}` (KEIN dlopen; id = stem ohne „perm_").
- `VisibilityReport compute_visibility(PlannedSet, BuiltSet, bool builder_built)` — planned/built/open (= planned − built) + open_ids.
- `std::string format_visibility(VisibilityReport)` — CI-Summary + `BUILD_VISIBILITY.txt`-Inhalt („CacheEngineBuilder: gebaut/fehlt · Tier-Binaries: B/N gebaut, O offen (Profil P)").
- `InterfaceCheck{id,loaded,descriptor_ok,run_ok; passed()}` + `std::string format_interface_roster(vector<InterfaceCheck>)` — je-Binary PASS/FAIL + Summary; leer ⇒ „0 Tier-Binaries gebaut — nichts zu prüfen" (graceful/grün).

CLI `tier_binary_report_cli` (OUTPUT_NAME `tier-binary-report`, `main.cpp`):
- `--visibility <manifest> <perm_root> [--builder-exe=<path>]` ⇒ compute+format+`BUILD_VISIBILITY.txt`+stdout.
- `--interface-check <perm_root>` ⇒ via `comdare::messung_driver` plugin_loader je Plugin laden→descriptor?→`run(N,&us)`==0? ⇒ Roster+`INTERFACE_TEST_REPORT.txt` (reuse, keine Loader-Duplikation; `-ldl` auf POSIX). #279(4).

### (C) CI-Sichtbarkeit — `.gitlab-ci.yml` Job `visibility:tier-binaries`
`tags:[baremetal]`, `needs:[verify:submodules]`, KEIN allow_failure. Baut `tier-binary-report`, konfiguriert Code mit `-DCOMDARE_BUILD_PERMUTATIONS=ON` (Codegen schreibt `permutations_manifest.txt` bei **configure**, KEIN Lib-Compile ⇒ billig), führt `--visibility <manifest> <perm_root>` ⇒ Log zeigt „planned 27, built 0, open 27, CacheEngineBuilder: <status>". Optional `--interface-check` über 0 Plugins (graceful). Surfacet die Live-Sichtbarkeit ohne schweren Bau.

### (D) Test — `Code/tests/unit/test_279_tier_binary_report.cpp` + `Code/tests/fixtures/tier_binary_report/`
Deterministisch (kein dlopen): parse_manifest (Kommentare/Leerzeilen), scan_built (nur perm_*), compute_visibility (Mathe + open_ids = planned−built), format_visibility (enthält „CacheEngineBuilder" + Zahlen), format_interface_roster (PASS/FAIL + leerer Roster). Registriert via `comdare_da_add_test` (LABELS da_unit) ⇒ läuft im harten `test:unit`.

## 3. Kadenz
Impl (Codex-first falls MCP verfügbar, sonst manuell) → Zeile-für-Zeile-Review → Mojibake-grep `Ã|â€`==0 → clang-format 22.1.8 → doppelt-literal → granularer Commit → Push beide Remotes → super-Welle STRIKT GRÜN (kein allow_failure) → Ledger §12 additiv + §14.9-Übervereinfachung korrigieren.
