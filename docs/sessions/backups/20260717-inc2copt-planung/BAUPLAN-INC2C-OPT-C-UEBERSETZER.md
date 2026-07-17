# Bau-INC-2c.opt-c — Bauplan-Dossier

**Übersetzer `perm_opt_level_cflags()` + Default-Verdrahtung des opt_level an die POSIX-Fassade**

Status: **NEEDS_USER_DECISION_FIRST** — die Naht-Mechanik (Funktion, Include, Provenienz, Aufrufer-Anhang) ist voll code-verankert und baubar; der **Default-Wert** von `active_opt_level()` für den golden-Pfad ist die OF-2-Kernentscheidung (Lesart A vs. B), die opt-c blockiert, weil opt-c genau den Punkt ist, an dem der Ofast-Default erstmals an die golden-320-Mess-Binaries greift und die byte-neutrale −O2-Transition **bewusst zurückgezogen** wird.

Ehrliche Benennung: **opt-c ist KEIN byte-neutraler Schritt mehr.** opt-b hielt via Signatur-Default `-O2` + unveränderte Aufrufer Byte-Identität. Sobald opt-c den 5. Param an :226/:402 setzt und `active_opt_level()` den Achsen-Default (Ofast) liefert, ändert sich das reale Compile-Verhalten der golden-Mess-Binaries. Die persistierten Alt-Reihen bleiben (Messdaten nie löschen); die neue Ofast/O3-Selektion lebt **additiv als +opt=-Sidecar-Reihe**.

---

## 1. `active_opt_level()` — neuer Helper (Spiegel `active_simd_policy()`)

**Zweck:** Liefert die aktive `opt_level_id` (Achsen-Default, env-übersteuerbar). Wert-Quelle in opt-c ist ausschliesslich env-Pilot + Achsen-Default; die XML wird erst in **opt-f** Quelle (Ordering-Grenze: opt-c VOR opt-f, keine Parallelstruktur).

**IST** `profile_run_facade.cpp:109-114` (`active_simd_policy()` — das wörtliche Vorbild):
```
policy = GenericExtensionHardwareAxis::simd_extension_id();  // :111 Achsen-Default
if (getenv("COMDARE_PILOT_SIMD_POLICY")) policy = e;         // :112 env-Override
```
`optimization_level_sub_axis.hpp:121` `using DefaultOptLevelSubAxis = OptOfastSubAxis;` · `:128` static_assert Default==Ofast.

**SOLL (Mini-Schritte):**
1. Direkt hinter `active_simd_policy()` (nach :114) neuen anonymen-Namespace-Helper `active_opt_level() -> std::string_view` einfügen.
2. `policy = DefaultOptLevelSubAxis::opt_level_id();` (Ofast, OF-2) — Single-Source aus der Achse, kein Literal.
3. `if (char const* e = std::getenv("COMDARE_PILOT_OPT_LEVEL"); e && *e) policy = e;` — Wert-Domäne = `opt_level_id` (nicht roher Flag), strikte SIMD-Analogie. **[open: ENV-DOMAENE]**
4. Kommentar-Block spiegeln (:105-108): Smoke-Schalter bis Planer-Strang (opt-f/opt-g); XML hier NICHT.

---

## 2. `perm_opt_level_cflags()` — Übersetzer (Spiegel `perm_extension_hardware_cflags()`)

**Zweck:** Mappt die aktive `opt_level_id` auf den compiler-passenden Flag-String und gibt **EINEN `std::string`** zurück (NICHT vector — der 5. Param `opt_flag` ist `std::string`, `build_orchestrator.hpp:469`). **KEIN Merge in `perm_mess_defines()`** — strukturell anders als extension_hardware (dort push_back in defines-Vektor :156). opt_flag reist als eigener Positions-Param mit eigener .rsp-Zeile (`build_orchestrator.hpp:483`), getrennt von den defines (:490).

**IST** `profile_run_facade.cpp:116-130` (`perm_extension_hardware_cflags()` — if/else über Achsen-IDs, unbekannt → cerr + Fallback). Flag-Quelle: `optimization_level_sub_axis.hpp:45-47` (`gcc_opt_flag()`/`clang_opt_flag()`/`msvc_opt_flag()`); Werte :77-116.

**SOLL (Mini-Schritte):**
1. Neue Funktion `perm_opt_level_cflags() -> std::string` direkt nach `perm_extension_hardware_cflags()` (nach :130).
2. `auto id = active_opt_level();` — Dialekt via `cxx_compiler()` (:160) mit dem etablierten Substring-Gate aus `build_orchestrator.hpp:488`: `cxx_compiler().find("clang") != npos` → clang-Leg, sonst gcc-Leg. `msvc_opt_flag()` bleibt dem MSVC-CompileFn-Pfad vorbehalten (make_gpp ist gcc/clang-only). **[open: MSVC-TIMING]** Architektur-Note: Dialekt-Wahl bevorzugt über die Compiler-Achse als Single-Source (Metaprog-Doktrin); da `gcc_opt_flag()==clang_opt_flag()` für alle Stufen, ist der Branch auf POSIX heute ein semantischer No-op, aber Spiegeltreue Pflicht.
3. if/else-Kette über `OptO{0,1,2,3,Ofast}SubAxis::opt_level_id()` → jeweiliges `gcc_opt_flag()`/`clang_opt_flag()`.
4. Unbekannter env-Wert → `std::cerr`-Warnung + Fallback auf `DefaultOptLevelSubAxis` (Ofast), **NIE leer** (opt_level darf nie still entfallen — Unterschied zu Generic=leer bei SIMD). **[open: FALLBACK-KLASSE]**
5. Include ergänzen: `#include <cache_engine/measurement/optimization_level_sub_axis.hpp>` (fehlt bislang; heute nur `compiler_system_axis.hpp` :12 + `extension_hardware_system_axis.hpp` :13). Neue Zeile bei :14.

---

## 3. Aufrufer-Anhang — 5. Positions-Arg an BEIDEN Stellen

**Zweck:** Speist den Flag an make_gpp_compile_fn ein (Param existiert seit opt-b, Default `-O2` transitional). **HIER wird die Byte-Neutralität bewusst verlassen** — abhängig von [open: OF-2-KERN].

**IST** identisch an zwei Stellen (4 Args, kein 5.):
- `profile_run_facade.cpp:226` (run_profile_facade)
- `profile_run_facade.cpp:402` (run_experiment-Delegation)
```
a.compile = ex::make_gpp_compile_fn(perm_include_dirs(), perm_mess_defines(), cxx_compiler(), perm_link_libs());
```

**SOLL (Mini-Schritte, an :226 UND :402 identisch):**
```
a.compile = ex::make_gpp_compile_fn(perm_include_dirs(), perm_mess_defines(), cxx_compiler(), perm_link_libs(), perm_opt_level_cflags());
```
**GATE:** Dieser Schritt erst nach GO zu [open: OF-2-KERN]/[OF-2-LEVEL] final festschreiben. Bei Lesart B liefert `active_opt_level()` für den golden-Lauf ein deterministisches Level (O2-Anker), nicht Ofast; Ofast permutiert additiv.

---

## 4. Provenienz — `system_axes_version_suffix()` um `+opt=` erweitern

**Zweck:** Unter anderem opt_level gebaute DLLs bekommen ein eigenes `.version`-Sidecar (kein falscher `dll_is_current`-Skip), CSV-Spalte `build_version` trägt die Provenienz. **binary_id bleibt neutral** (opt NIE in `kCompositionAxisNames`, golden==320 unberührt).

**IST** `profile_run_facade.cpp:172-174`: `return "+ext=" + active_simd_policy() + "+cxx=" + cxx_compiler();` — trägt heute nur `+ext=` und `+cxx=`. Header-Forderung `optimization_level_sub_axis.hpp:11-13` nennt `+opt=`.

**SOLL:** `... + "+opt=" + std::string{active_opt_level()}` anhängen. Verbindlich für korrekte Provenienz (Teil des sauberen Wegs, nicht der reinen 5-Param-Naht). Note MSVC: Ofast→/O2-Degradierung — falls MSVC live wird, im Sidecar kenntlich, damit cl-Reihen nicht fälschlich als Ofast gelten.

---

## 5. (Non-blocking Tail) MSVC-Mirror in `make_system_compile_fn`

**Zweck:** Symmetrie make_system ↔ make_gpp; verhindert toten `msvc_opt_flag()`-Accessor + latentes stilles-/Od-Regressionsrisiko. **NICHT golden-/messrelevant, NICHT blockierend** (kein Aufrufer, nur Kommentar `build_orchestrator.hpp:379`; Cluster Linux/POSIX-first). **[open: MSVC-TIMING]**

**IST** `build_orchestrator.hpp:450-461`: Signatur nur `include_dirs`+`std_flag`; Emit :453 `"cl /nologo " + std_flag + " /EHsc /LD /MP" + cores` — kein `/O<n>` (cl-Default still `/Od`).

**SOLL (3 Zeilen, exakter opt-b-Spiegel):**
1. Signatur :450-451: 3. Param `std::string opt_flag = "/O2"` (transitionaler Builder-Fallback analog `-O2`; NICHT Ofast, das auf /O2 abbildet).
2. Capture :452: `, opt_flag = std::move(opt_flag)`.
3. Emit :453: `"cl /nologo " + std_flag + " " + opt_flag + " /EHsc /LD /MP" + std::to_string(job.cores)` (/O vor /EHsc).

---

## Verifikation

1. **.rsp-Vergleich (byte-genau):** Vor/nach Diff einer perm_*.cpp → perm_*.so-Kompilation die generierte `<output>.rsp` vergleichen.
   - **Lesart B / O2-golden:** `.rsp`-Zeile 2 MUSS `-O2` bleiben → **byte-identisch** zum opt-b-Stand, `diff` leer. Beweist Neutralität des golden-Anker-Pfads.
   - **Ofast/O3-Vergleichsreihe (env gesetzt):** `.rsp`-Zeile 2 = `-Ofast`/`-O3`, alle übrigen Zeilen identisch (nur die eine opt-Zeile ändert).
2. **golden==320:** `ctest`-golden-Suite grün, Achsen-Zahl exakt 320 (kV3AxisSchema / kCompositionAxisNames unberührt — opt_level steht NIE drin). Kein neuer Achsen-Eintrag.
3. **cf22 (clang-format):** `~/tools/cf22/usr/bin/clang-format` über die geänderten Dateien, kein Diff (offizieller Weg, keine Behelfe).
4. **ce-standalone-Build:** Pflicht-Reihenfolge (reference_cache_engine_standalone_build_pipeline) hart grün, inkl. der neuen `static_assert`-tragenden TU.
5. **super-Sub-Build:** Einbettung im Super-Repo (Sub-Build) grün — Interface-Include-Pfad `<cache_engine/measurement/optimization_level_sub_axis.hpp>` auflösbar.
6. **Fehlerklasse-Sichtbarkeit:** Test mit unbekanntem `COMDARE_PILOT_OPT_LEVEL` → cerr-Warnung + Ofast-Fallback (nicht leer, kein Absturz, kein Null-Flag).
7. **Provenienz-Roundtrip:** DLL unter env-Ofast gebaut → `.version`-Sidecar trägt `+opt=Ofast`, kein falscher `dll_is_current`-Skip gegen eine `+opt=O2`-DLL.

**Dual-Verifikation (baremetal lokal + CI) gemäss Memory geparkt bis Aufgaben-Abschluss** — hier lokal-first (ce-standalone + super-Sub); CI-Strategie danach gesammelt nachziehen. Kein ✓ ohne wörtliche Ausgabe.

---

## TABU / Risiken

- **TABU:** opt_flag NIE in `binary_id`/`kCompositionAxisNames` — sonst golden!=320. opt_level ist Provenienz (Mess-VALIDITÄT), nicht Achsen-Identität.
- **TABU:** Kein Merge des opt-Flags in `perm_mess_defines()`/defines-Vektor — opt_flag ist separater Positions-Param (Typ `std::string`, nicht vector). Der Rückgabetyp der neuen Funktion ist `std::string`, NICHT wie beim SIMD-Vorbild `vector<string>`.
- **TABU:** Kein Signatur-Default `Ofast` auf `make_gpp_compile_fn`/`make_system_compile_fn` — würde unveränderte Aufrufer sofort ziehen und die opt-b/opt-c-Trennung brechen (`build_orchestrator.hpp:470-475`). Default bleibt `-O2`/`/O2` transitional; Ofast wird am Planer/Fassade erzwungen.
- **TABU:** Keine XML-Quelle in opt-c (Ordering: opt-f). Kein auskommentierter XML-Pfad, der Parallelstruktur andeutet, ausser als klar markierter opt-f-Andockpunkt.
- **TABU:** Keine CT→RT-Degradierung — Flag-Werte kommen constexpr aus den CRTP-Achsen (static-dispatch, keine vtable), nur die env-Piloten-Auswahl ist runtime (Smoke-Schalter, wie SIMD).
- **TABU:** Messdaten nie löschen — Ofast/O3 additiv als +opt=-Sidecar-Reihen; O2-Alt-Korpus unangetastet.
- **RISIKO (KERN):** Ofast bricht IEEE-754 + Run-to-Run-Determinismus (`-fallow-store-data-races` + `-funsafe-math`, optimization_level_sub_axis.hpp:15-16). Bei Kombination mit T08-Concurrency/Data-Race-Achsen ist das Ergebnis **semantisch ungültig** (nicht nur verrauscht). → **[open: OF-2-KERN]** blockiert die Default-Verdrahtung; is_ieee754_deterministic() ist der bereits eingebaute Trenn-Hook (Planer/Warnung bei opt-g).
- **RISIKO:** Dialekt-Erkennung per Substring (`find("clang")`) ist heute No-op auf POSIX (gcc==clang je Stufe), aber MSVC-relevant; Single-Source über die Compiler-Achse ist die sauberere (nicht einfachste) Variante — im Übersetzer als solche umsetzen, nicht per String-Heuristik verewigen wo die Achse verfügbar ist.

---

## Diff-Umfang

- `libs/cache_engine/profile_facade/profile_run_facade.cpp`:
  - +1 Include (~:14).
  - +`active_opt_level()` (~10 Zeilen nach :114).
  - +`perm_opt_level_cflags()` (~14 Zeilen nach :130).
  - :226 + :402: je +1 Arg (5. Positions-Param) — **GO-gated (OF-2)**.
  - :172-174: +`+opt=`-Fragment.
- `libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp` (non-blocking Tail, [open: MSVC-TIMING]):
  - :450-451 Signatur +1 Param, :452 Capture, :453 Emit — 3 Zeilen.

Netto ~40 Zeilen, davon der golden-verhaltensrelevante Kern = die zwei Aufrufer-Zeilen (:226/:402), die unter der offenen OF-2-Entscheidung stehen. Der Rest (Übersetzer, Helper, Provenienz, MSVC-Mirror) ist code-verankert, architekturkonform und ohne golden-Bruch baubar.