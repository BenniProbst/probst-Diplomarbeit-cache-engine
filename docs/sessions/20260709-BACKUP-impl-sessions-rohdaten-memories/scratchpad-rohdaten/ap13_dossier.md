# DOSSIER AP-13/#247 (IPinningPolicy-Teil, v1 Core-Index) — Mess-Thread-Pinning (host-seitig, opt-in, ABI-4, golden-neutral)

> **Für Codex** (`--sandbox workspace-write`, gpt-5.5, xhigh). EIN Agent. Repo-Wurzel = `--cd` (comdare-cache-engine).
> **NICHT committen, KEINE git-Operationen.** Basis = fresh-context-Kartierung (Explore ae5d3d13), alle Zeilen belegt.
> **SCOPE-GRENZE (kritisch):** NUR host-seitiges Mess-Thread-Pinning v1 (`--pin-core=N`, Core-Index). NICHT anfassen:
> `platform::IPinningPolicy`/`core_layout.hpp` (Modell-Ebene, getrennt!), P/E-Auto-Erkennung (CPUID 0x1A — Follow-up),
> 3-ISA-Build-Matrix (reuse-gated), die verriegelten Plattform-Tests, POD/golden/binary_id/conformance/pipeline16.

## 1. Auftrag
Ein host-seitiger RAII-Mess-Thread-Pinner: opt-in `--pin-core=N` pinnt den (single-threaded) Mess-Thread auf Core N
(Varianz-Reduktion auf Hybrid-CPUs, M3-Relevanz), Default = no-op (Bestandsmessungen unverändert). Muster AP-9/AP-1
(host-seitige Mess-Runtime, additiv, ABI/golden-neutral).

## 2. VERIFIZIERTER Ist-Zustand (nutze GENAU diese Belege)
- **Messung SINGLE-THREADED:** `libs/cache_engine/builder/workload_driver/workload_orchestrator.hpp:65` `run_workload_profile` (Op-Schleife `:75`, rein sequenziell, kein Thread/Pool); `run_measurement_plan` `:182` (ruft `:194`). f15_compare Call-Site `apps/f15_compare/main.cpp:287` (`run_measurement_plan`, geklammert von `pmc->begin()` `:286`/`pmc->end()` `:288`, in der Per-DLL-Schleife ab `:271`). → EIN Thread pinnen genügt.
- **Kein first-party Affinity-Code** (nur in `ext/`). Modell-Ebene existiert (NICHT anfassen): `libs/cache_engine/include/cache_engine/platform/core_layout.hpp:48` `platform::IPinningPolicy` (empfehlend, `pin_for→CoreId`, unimplementiert, subject-under-study) + `subsystems/c02_pinning_engine/i_pinning_engine.hpp` (Modell).
- **CLI-Flag-Muster:** `apps/f15_compare/main.cpp:88-111` (`parse_flag_u64`), Parse-Schleife `:146-174` (`--seed=`/`--ops=` etc.). `--pin-core=N` fügt sich via `parse_flag_u64` genau dort ein.
- **P/E fehlt (v1 aufschieben):** `cpuid_probe.hpp:76` `probe_cpuid()` liest KEIN Leaf 0x1A/has_hybrid; `cpuid_platform_probe.hpp:26-27` nennt AP-13 explizit offen. Verriegelte Tests (NICHT ändern): `tests/unit/test_cpuid_probe.cpp:54-56`, `tests/unit/test_platform_concepts.cpp:38-39`.
- **TABU (via `tests/unit/test_ap9_provenance_manifest.cpp:68-84` verriegelt):** `COMDARE_ANATOMY_ABI_MAJOR==4`, `sizeof(ComdareTierObserverSnapshot)==1416`, `kTierObserverSnapshotVersionUnified==5`, POD trivially_copyable, Voll-CSV==25, pipeline16==16, binary_id/permutation_axes/golden-320/conformance_gate.

## 3. Soll (der Increment) — Defaults gesetzt, NICHT nachfragen
(A) **NEU `libs/cache_engine/builder/measurement/thread_pinning.hpp`** (host-seitig):
  - `class ScopedThreadPin` — RAII: ctor pinnt den **aktuellen** Thread auf `core`, dtor **restauriert** die vorherige Maske. Move-only, kein Copy.
    - Windows (`#ifdef _WIN32`): `SetThreadAffinityMask(GetCurrentThread(), DWORD_PTR{1} << core)` → Rückgabe = vorherige Maske (0 = Fehler); dtor restauriert sie. `<windows.h>` NUR in diesem Header (lokaler Blast-Radius; ggf. `WIN32_LEAN_AND_MEAN` davor).
    - Linux (`#elif __linux__`): `sched_getaffinity(0,…)` speichern, `sched_setaffinity(0, …CPU_SET(core))`, dtor restauriert (`<sched.h>`).
    - sonst (macOS/other): **no-op** (ehrlich; kein Affinity-API) — `active()==false`.
    - `bool active() const` (true nur wenn tatsächlich gepinnt). Fehler (ungültiger Core / Syscall-Fail) → no-op + `active()==false` (NICHT werfen; Messung darf nie an Pinning scheitern).
  - `struct NoPinPolicy { ScopedThreadPin pin() const; }` (Default) → inaktiver Guard (echtes no-op).
  - `struct CorePinPolicy { unsigned core; ScopedThreadPin pin() const; }` → aktiver Guard auf `core`.
  - (Optional, wenn sauber: ein schmales `IPinningPolicy`-Host-Konzept/Variant, das NoPin/CorePin vereint — ABER distinkt von `platform::IPinningPolicy`, im `builder`-Namespace. Wenn es Komplexität bringt: 2 Structs + freie `make_pin_policy(std::optional<unsigned>)` genügen.)
(B) **Anwendung `apps/f15_compare/main.cpp`:** `--pin-core=N` parsen (via `parse_flag_u64`, optional; abwesend → kein Pin). VOR der Per-DLL-Handle-Schleife (`:271`) — damit ALLE DLLs auf demselben Core gemessen werden — einen Guard halten: `auto _pin = pin_core.has_value() ? CorePinPolicy{*pin_core}.pin() : NoPinPolicy{}.pin();` (Lebensdauer über die ganze Mess-Schleife). Bei aktivem Pin eine `std::cout`-Notiz (welcher Core). Ohne Flag → no-op → identisches Verhalten.
(C) **Anwendung `apps/perm_runner/main.cpp`** (falls gleich einfach — Cluster-Einzel-DLL): analog `--pin-core=N` vor `run_observable_perm`. Wenn nicht trivial: weglassen + als Follow-up notieren (nicht erzwingen).
(D) **Test `tests/unit/test_ap13_thread_pinning.cpp`** (gtest): (1) `NeutralityGuardsStayIntact` — den Block aus `test_ap9_provenance_manifest.cpp:68-84` **wörtlich** übernehmen (ABI-4, sizeof 1416, version 5, CSV 25/16); (2) `NoPinPolicy.pin()` → `active()==false`, Thread-Maske unverändert; (3) `CorePinPolicy{0}.pin()` plattform-guarded: `#ifdef _WIN32`/`__linux__` → `active()==true` + nach Scope-Ende ist die Maske restauriert (Round-Trip via `GetProcessAffinityMask`/`sched_getaffinity`), sonst `SUCCEED()`. CMake-Registrierung (`tests/unit/CMakeLists.txt`, Muster `test_ap9`).

## 4. HARTE Auflagen (Verstoß = Abbruch)
1. **Default no-op:** ohne `--pin-core` NULL Verhaltensänderung; Pinning-Fehler → no-op (nie werfen, Messung nie an Pinning scheitern).
2. **Ebenen-Trennung:** `platform::IPinningPolicy`/`core_layout.hpp` + `c02_pinning_engine` (Modell/subject-under-study) UNBERÜHRT; neuer Typ distinkt im `builder`-Namespace.
3. **KEIN P/E-Auto, KEINE 3-ISA-Matrix:** `cpuid_probe`/`cpuid_platform_probe`/`i_platform_probe` + die verriegelten Tests (`test_cpuid_probe.cpp:54-56`, `test_platform_concepts.cpp:38-39`) UNVERÄNDERT.
4. **ABI/golden-neutral:** binary_id/permutation_axes/golden-320/ABI-POD/`COMDARE_ANATOMY_ABI_MAJOR`(4)/conformance_gate/pipeline16(16)/Voll-CSV(25) unberührt.
5. `<windows.h>` NUR im Pinning-Header (WIN32_LEAN_AND_MEAN); kein Leak in heiße/ABI-nahe Header. Kein `git`. Kein `$null` stagen.

## 5. Verifikation (PFLICHT — Codex, literal)
- Baue+laufe `test_ap13_thread_pinning` über den konfigurierten `build/` → literal `[ PASSED ]`; zeige den CorePin-Round-Trip-Beleg (Maske gesetzt→restauriert).
- Baue `comdare_f15_compare_cli` grün (die --pin-core-Verdrahtung kompiliert).
- Bestätige: `COMDARE_ANATOMY_ABI_MAJOR`==4; sizeof(Snapshot)==1416; Voll-CSV==25, pipeline16==16; `platform::IPinningPolicy`/cpuid_probe/verriegelte Tests unverändert; golden/POD/conformance unberührt.
- `git status --short`: NUR `builder/measurement/thread_pinning.hpp` (neu) + `apps/f15_compare/main.cpp` (+ ggf. `apps/perm_runner/main.cpp`) + `tests/unit/test_ap13_thread_pinning.cpp` + `tests/unit/CMakeLists.txt`.

## 6. Ausgabe an Claude
(a) Diffs + neue Dateien; (b) literal `[ PASSED ]` + CorePin-Round-Trip-Beleg + f15_compare-Build grün; (c) Bestätigung Default-no-op, Ebenen-Trennung (platform::IPinningPolicy unberührt), KEIN P/E-Auto/3-ISA, ABI-4/golden/pipeline16-neutral; (d) Notiz an User: P/E-Auto-Erkennung + 3-ISA-Matrix + perm_runner(falls weggelassen) als Follow-ups; Namens-Entscheid (distinkter Host-Typ statt platform::IPinningPolicy) zur Info.
