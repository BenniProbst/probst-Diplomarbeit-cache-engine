# SYNTHESE — max-Effort code-review Phase 1 (#230), 2026-07-09

> Workflow `wf_12f63d54-8b2` (28 Agenten, 6 Finder + 19 Verifier). Scope = ce `698977fe` + super `5b5dc9c` (die Phase-1-Andockung, seither revertiert ce `fc6f2e45`/super `fac49e66`). Rohdaten: `rohdaten/ERGEBNIS-wf_12f63d54.json` (61 KB) + `rohdaten/journal.jsonl` (56 Zeilen). Stats: 25 Kandidaten → 25 verifiziert → 23 kept / 2 refuted → 15 reported. **Alle Findings sind PFLICHT für den Phase-1-Abschluss (#69).**

## Kernbotschaft
Die GoF-Facade (Umbrella-Isolation) war **architektonisch korrekt**. Zwei Klassen echter Defekte:
1. **CI-Blocker** (bekannt, = der Revert-Grund): die Fassade kompiliert im super-Sub-Build nicht.
2. **Der E4-Dock ist ein VIEL dünnerer Wrapper als der `run_lazy_150`-Harness, den er beerbt** — er lässt top-level exception handling, den „0-Profile"-Hard-Abort, RAM-Admission, Platform-/Build-CSV-Tagging, Cap-Validierung, SOTA-Opt-out und den C1083-Retry weg. Folge: ein opt-in **mehrtägiger Thesis-Lauf** kann still **wissenschaftlich ungültige oder plattform-fehletikettierte Daten** emittieren, das Build-Cap überschreiten, OOMen oder past dem versprochenen Fallback abbrechen.

## A — CI-Blocker (der Revert-Grund)
| # | Datei:Zeile | Verdikt | Befund |
|---|---|---|---|
| A1 | `profile_facade/CMakeLists.txt:72` | CONFIRMED | Link-/Include-Set lässt die ~15 vendored Adapter-Targets weg (`comdare::adapter::{a04_mimalloc..a11, p07..p30}`), deren usage-requirement-Include-Dirs `<mimalloc.h>` + die anderen vendored Header liefern, die `all_axes_umbrella` transitiv zieht → im super-Sub-Build `fatal error: mimalloc.h`. Fix = das `test_v31_adapters`/`m3v2_pmc_smoke`-Target spiegeln (`tests/unit/CMakeLists.txt:277-301`). **Refuted-Nachtrag** (CMakeLists:89): der Fix muss ZUSÄTZLICH die Adapter-Include-Dirs in die gebackene `COMDARE_FACADE_PERM_INCLUDES` schreiben (der perm-`@rsp`-Sub-Compile braucht sie auch, sonst zweiter unabhängiger `mimalloc.h`-Bruch). |

## B — Wissenschaftliche Datenintegrität (KRITISCH, mehrtägiger Lauf)
| # | Datei:Zeile | Verdikt | Befund |
|---|---|---|---|
| B1 | `profile_run_facade.cpp:138` (+132) | CONFIRMED | „`COMDARE_LOAD_PROFILE_DIR` gesetzt aber 0 gültige Profile → Hard-Abort exit 4" (`run_lazy_150.cpp:201-205`, „Achse 2 darf nicht still entfallen") **weggelassen**, obwohl `:129` Parität behauptet. Falsches Dir → leeres `workload_registry` → `run_profile` skippt die Workload-Achsen-Injektion (`profile_run_entry.hpp:132`) → jede CSV-Zeile via fixed-workload-Fallback `two_phase_valid=0` → **gesamter Lauf wissenschaftlich ungültig**. |
| B2 | `main.cpp:502` (+508) | CONFIRMED | `platform_override` nie gesetzt → `run_profile` stempelt jede CSV-Zeile mit `platform="win-x86_64"` (aus `m3v2_study.profile.xml:145`), obwohl auf Linux/g++-16 gebaut+gemessen → **Plattform-Dimension korrupt** (Linux-Daten als Windows fehletikettiert). |
| B3 | `main.cpp:502` | CONFIRMED | `min_free_gb` nie gesetzt, kein env für RAM-Admission → auf memory-constrained Node laufen ~4 parallele Umbrella-Compiles (multi-GB) mit Admission OFF → OOM-Kill von g++/messung_driver → Lauf abgebrochen/korrupt. |
| B4 | `main.cpp:508` | CONFIRMED | `strtoull(COMDARE_E4_CAP)` ohne endptr/errno → malformed (`'auto'`, `'1k'`) → 0 → `max_binaries=0` = „Profil-Cap voll" = **unbounded multi-day build**; out-of-range → `ULLONG_MAX`/Truncation (32-bit-size_t RISC-V-Matrix). |
| B5 | `main.cpp:497` | CONFIRMED | `run_sota_series` nie gesetzt, kein `COMDARE_RUN_SOTA=0`-Opt-out (`run_lazy_150.cpp:269-270`) → Dock baut+misst IMMER alle `<sota_series>`-Tiere → unrequested multi-day compute für einen reinen Basis-320-Lauf. |

## C — Robustheit / Fallback-Invariante
| # | Datei:Zeile | Verdikt | Befund |
|---|---|---|---|
| C1 | `main.cpp:496` (+490/512) | CONFIRMED | Uncaught exception im opt-in-Block: `create_directories(e4_dir)` (throwing overload) + ungeguardetes `run_profile_facade(pa)` (nicht noexcept) + kein top-level try/catch in `main` → `std::terminate`, der klassische ExperimentDriver-A/B/C-Fallback („laeuft dennoch weiter (additiv)") läuft NIE → **verletzt die additiv-Invariante**. |
| C2 | `profile_run_facade.cpp:119` | CONFIRMED | `std::system`-Rückgabe = kodierter wait-status, nicht exit-code, wird roh als CompileFn-Ergebnis zurückgegeben → `BuildResult.status`/Log zeigt „compile-exit 256" statt 1 (ICE-SIGSEGV ~35584); Erfolgs-Test (`==0`) bleibt korrekt, aber Triage/Tooling irren. |
| C3 | `main.cpp:484` | PLAUSIBLE | `COMDARE_RUN_E4_XML == "1"` exakt → `'true'`/`'yes'`/`'1\n'`/`'1 '` (aus Datei gesourct) lassen opt-in still inaktiv. |

## D — Include-Robustheit (PLAUSIBLE, config-abhängig)
| # | Datei:Zeile | Verdikt | Befund |
|---|---|---|---|
| D1 | `CMakeLists.txt:91` | PLAUSIBLE | `COMDARE_FACADE_PERM_INCLUDES` nimmt mp11 nur bei vendored-Existenz → FetchContent-mp11 (`${boost_mp11_SOURCE_DIR}/include`) fällt weg → perm-`@rsp`-Compile: `boost/mp11.hpp: No such file` → 0 DLLs, header-only CSV. |
| D2 | `profile_run_facade.cpp:57` | PLAUSIBLE | `perm_include_dirs()` bevorzugt env `COMDARE_PILOT_INCLUDES` vor der gebackenen Liste → stale/foreign env (Windows-`;`-Pfade) überschreibt korrekte includes → alle perm-Compiles scheitern. |
| D3 | `profile_run_facade.cpp:118` | PLAUSIBLE | g++-Command per String-Concat, nur double-quote um rsp/log-Pfad → `$`/backtick/`"` im Output-Pfad → Mis-Tokenisierung durch `/bin/sh` oder `$(...)`-Injektion während der Messung. |

## E — Cleanup
| # | Datei:Zeile | Verdikt | Befund |
|---|---|---|---|
| E1 | `profile_run_facade.cpp:103` | CONFIRMED | `make_gpp_compile_fn` dupliziert das `@rsp`+`std::system`+`.log`-Muster von `build_orchestrator.hpp:353 make_system_compile_fn` + 2 Pilot-Kopien = 4. Kopie. SOLL: geteilte `make_gpp_compile_fn`-Factory in `build_orchestrator`. |
| E2 | `CMakeLists.txt:42` | CONFIRMED | Produktive Fassade greift in den Test-Tree (`tests/unit/thesis_tiere`) — Lib→Test-Abhängigkeits-Richtung (acknowledged Phase-1-debt; SOLL: Naht-Header in Produktiv-Lage heben). |
| E3 | `workload_driver/CMakeLists.txt:11` | PLAUSIBLE | Der `CMAKE_SOURCE_DIR→PROJECT_SOURCE_DIR`-Fix nur an 2 Instanzen; `pruef_dock`/`anatomy_codegen_tool` tragen denselben latenten Bug → SOLL: geteilte ce-Include-Root-Variable statt 2 Symptom-Fixes. |

## REFUTED (2, nicht fixen)
- `main.cpp:512` „kein E4-only-mode (fall-through in klassischen Pfad)" — **by-design additiv** (der klassische Pfad SOLL zusätzlich laufen).
- `CMakeLists.txt:89` „COMDARE_FACADE_PERM_INCLUDES = zweiter unabhängiger Bruch" — als eigenständig refuted, aber als **Teil des A1-Fixes** mitzunehmen (s. A1-Nachtrag).

## Konsequenz für den Phase-1-Neuaufbau (frische Session, clang-format-22 nun verfügbar)
Bei der Wiederherstellung der Fassade sind A1 + B1-B5 + C1-C2 **Pflicht-Fixes** (nicht optional — sie betreffen die wissenschaftliche Gültigkeit des #156-Voll-Laufs). Sauberste Lösung für B/C: der E4-Dock reicht die weggelassenen Harness-Parameter (`platform_override`, `min_free_gb`, `run_sota_series`, validiertes `max_binaries`, `workload`-0-Abort) durch + top-level try/catch; E1 löst B/C teils mit (geteilte Factory). D1-D3 + E3 als Härtung mitnehmen.
