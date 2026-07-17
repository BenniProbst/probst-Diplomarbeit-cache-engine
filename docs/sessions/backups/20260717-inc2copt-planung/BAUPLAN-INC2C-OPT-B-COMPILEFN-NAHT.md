# BAUPLAN-DOSSIER — Bau-INC-2c.opt-**b**: CompileFn-`opt_flag`-Parameter (die eine Naht)

> **Status:** Planungs-Dossier zur Freigabe. Grounded am IST-Code (2026-07-17, ce `a87d6d5b`); jede Zeile `datei:zeile` verifiziert, nichts geraten. Vorgänger 2c.opt-a (opt_level-Unterachse als CRTP+Concept) ist gelandet (`e8c32ecb`, Block J in `test_striktheit_axis_dach_guard`). **Bau erst nach EXPLIZITER User-Phasen-Freigabe.**

## 1. ZWECK (aus dem Master-Bauplan, opt-b)
Die eine physische Naht, an der die Optimierungsstufe in die Tier-Binary-Kompilation eintritt: der hartkodierte `-O2`-Emit in der POSIX-CompileFn wird durch einen **injizierten `opt_flag`-Parameter** ersetzt (Default `-O2`), sodass der Planer (später, opt-g) je opt-Permutation eine eigene `CompileFn` erzeugen kann. **opt-b ist rein mechanisch + byte-identitätswahrend** — es verdrahtet noch NICHTS an die Unterachse (das ist opt-c), es öffnet nur den Kanal.

## 2. IST (verifiziert, `datei:zeile`)
- **Signatur** `libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp:466-468`:
  ```cpp
  make_gpp_compile_fn(std::vector<std::string> include_dirs = {},
                      std::vector<std::string> defines = {},
                      std::string cxx = "g++-16",
                      std::vector<std::string> link_libs = {})   // 4. Param (INC-0)
  ```
- **Lambda-Capture** `:469-470` (by-value move: `include_dirs, defines, cxx, link_libs`).
- **Der `-O2`-Emit** `:476`: `rf << "-O2\n";` — steht zwischen `-std=c++23\n` (`:475`) und `-fPIC\n` (`:477`).
- **Beide Aufrufer** `libs/cache_engine/profile_facade/profile_run_facade.cpp:226` **und** `:402`, IDENTISCH:
  ```cpp
  a.compile = ex::make_gpp_compile_fn(perm_include_dirs(), perm_mess_defines(), cxx_compiler(), perm_link_libs());
  ```
  (4 positionale Argumente; KEIN 5. Argument.)
- **Unterachsen-Quelle bereits vorhanden** (opt-a): `OptO2SubAxis::gcc_opt_flag() == "-O2"`, `OptO3SubAxis::gcc_opt_flag() == "-O3"` etc. (`test_striktheit_axis_dach_guard.cpp:122`). ⇒ `opt_flag` ist der VOLLE Flag-String (`-O2`/`-O3`/`-Ofast`), konsistent zur Sub-Achse.

## 3. SOLL — minimaler, byte-identitätswahrender Eingriff
- **S1 (Signatur):** 5. Param `std::string opt_flag = "-O2"` **nach** `link_libs` anhängen (NICHT davor — sonst verschieben sich die 4 positionalen Aufrufer-Argumente). Analog zur `link_libs`-Erweiterung aus INC-0.
- **S2 (Capture):** `opt_flag = std::move(opt_flag)` in die Lambda-Capture-Liste `:469-470` aufnehmen.
- **S3 (Emit ERSETZEN, nicht ergänzen):** `:476` `rf << "-O2\n";` → `rf << opt_flag << "\n";`. **Doppel-O-Falle:** die Zeile MUSS ersetzt werden; ein zusätzlicher Emit gäbe zwei `-O`-Flags.
- **S4 (Aufrufer):** **unverändert** lassen (`:226`/`:402`) — sie fallen auf den Default `-O2` zurück ⇒ Byte-Identität hält OHNE Aufrufer-Änderung. Das explizite Verdrahten der Unterachse (`perm_opt_level_cflags()` statt Default) ist **opt-c**, nicht opt-b (saubere Increment-Trennung).

## 4. VERIFIKATION (literal, opt-b-Gate = Byte-Identität)
1. **Byte-Identität (das harte Gate):** eine Default-gebaute `perm_<id>.so` (bzw. deren `.rsp`) **byte-diff gegen den Ist-Stand == identisch** — der `.rsp` trägt weiterhin exakt `-O2\n` an derselben Position. Nachweis: `.rsp`-Inhalt vor/nach `diff`, plus `sha256sum` einer Default-`.so`.
2. **Kompilation:** ce build-conf + super Sub-Build grün; `test_striktheit_axis_dach_guard` unberührt-grün (opt-a-Guards halten).
3. **Kadenz:** ctest-Block grün · golden-Roundtrip==320 (unberührt — opt ist NIE in `binary_id`) · cf22-22.1.8==0 · Mojibake `Ã|â€`==0 · beide Remotes ref-gleich · CI hart-grün.

## 5. TABU / RISIKEN (opt-b-spezifisch)
- **Byte-Identitäts-Falle:** Default MUSS exakt `-O2` an Position `:476` reproduzieren — sonst Rebuild/Hash-Bruch ALLER Tier-Binaries + falsche `dll_is_current`-Skips (der `+opt`-Sidecar kommt erst opt-e).
- **Doppel-O-Falle:** `:476` ersetzen, nicht ergänzen.
- **Kategoriale Falle:** `opt_flag` NIE in `binary_id`/`profile_to_tree`/`kCompositionAxisNames`/AxisLevel-Baum — opt-b berührt AUSSCHLIESSLICH die CompileFn-Signatur + den einen Emit. Kein Schema, kein golden, kein POD/ABI (ABI-neutral, kein 4→5-Bump; der war einmalig in 2b).
- **Kein CT→RT:** reine String-Parametrisierung der Build-Funktion; die opt_level-SEMANTIK bleibt compile-time in der CRTP+Concept-Unterachse (opt-a).
- **Reihenfolge:** opt-b ist Voraussetzung für opt-c (Übersetzer `perm_opt_level_cflags()`), opt-d (`-fno-gnu-unique`-Gate-Single-Source), opt-g (Planer-Permutation). MSVC-Zweig (`make_system_compile_fn`) bleibt opt-k (zurückgestellt, POSIX-first).

## 6. DIFF-UMFANG (Vorschau, 2 Dateien)
- `build_orchestrator.hpp`: +1 Param (`:468`), +1 Capture (`:470`), 1 Zeile geändert (`:476`).
- `profile_run_facade.cpp`: **0 Änderungen** in opt-b (Aufrufer erst opt-c).
⇒ Kleinstmöglicher Eingriff; das Byte-Identitäts-Gate ist der Beweis, dass nichts Bestehendes kippt.
