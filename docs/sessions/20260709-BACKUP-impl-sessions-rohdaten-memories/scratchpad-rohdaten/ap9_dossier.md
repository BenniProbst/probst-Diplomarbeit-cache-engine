# DOSSIER AP-9/#243 — Provenance-Logging im Mess-Export: Pro-Lauf-Manifest (CMake-Header + probe_cpuid), host-seitig, ABI-4, golden-neutral

> **Für Codex** (`--sandbox workspace-write`, gpt-5.5, xhigh). EIN Agent. Repo-Wurzel = `--cd` (comdare-cache-engine).
> **NICHT committen, KEINE git-Operationen.** Basis = fresh-context-Kartierung (Explore a5fac6e6), alle Zeilen belegt.
> Rein HOST-seitig, Export-Metadaten. NICHT anfassen: ABI-POD, binary_id, permutation_axes, golden-320, pipeline16.

## 1. Auftrag
Ein **Pro-Lauf-Provenance-Manifest** (Reproduzierbarkeit): Compiler+Version · Build-Flags · ISA (built-for + ran-on) ·
build-aktivierte Allokatoren · Commit-Hashes der 4 Repos. Als **Sidecar-String** neben der CSV — KEINE CSV-Spalten, KEINE
POD-Felder (POD bleibt trivial-kopierbar). Muster: exakt wie `cmake/isa_features.cmake` + `*_flags.hpp.in` (`@VAR@`/`#cmakedefine01`).

## 2. VERIFIZIERTER Ist-Zustand (nutze GENAU diese Belege)
- **Andockpunkt:** `libs/cache_engine/builder/measurement_snapshot.hpp` — POD `ComdareMeasurementSnapshotV1` (`:34-66`, NUR numerisch; Kommentar `:32-33` „String-Identität wird bei Serialisierung beigestellt, POD bleibt trivial-kopierbar"); `serialize_measurements_csv` (volle 25-Sicht `:139-167`) NUR im Test aufgerufen; `serialize_measurements_pipeline16_csv` (`:171-192`, **exakt 16 — TABU**).
- **CMake-configure_file-Muster:** `cmake/anatomy_codegen.cmake:74` (`string(TIMESTAMP)`) + `:88` (`configure_file(... @ONLY)`); `*_flags.hpp.in`-Muster (z.B. `axis_09_isa_flags.hpp.in`). Plattform-Defines `cmake/compiler_flags.cmake:54-77` (`COMDARE_set_platform_defines`). ISA-Feature-Erkennung `cmake/isa_features.cmake:82-100` (`COMDARE_HAS_AVX2/AVX512/...`, `COMDARE_ISA_SUMMARY` — aktuell nur STATUS `CMakeLists.txt:462`).
- **Runtime-CPUID (offline, deterministisch):** `libs/cache_engine/include/cache_engine/platform_probe/cpuid_probe.hpp:76-151` `probe_cpuid()` → `CpuidProbeResults` (`:25-52`: vendor/brand_string/ISA-Bools/family/model/stepping/cache_line_bytes). (= AP-3-Bridge.)
- **Allokator build-aktiviert:** `axis_06_allocator_flags.hpp` (`<vendor>_enabled`, generiert aus `.hpp.in`).
- **4 Repos (offline erreichbar vom cache-engine-Source-Dir):** super-git-dir `../../../.git` (HEAD `87bb7f2`); Schwester prt-art `../comdare-prt-art`; thesis `../../../thesis/diplomarbeit`; cache-engine selbst `.`. `git rev-parse HEAD` je Repo = rein lokal.
- **ABI-POD (TABU):** `libs/cache_engine/anatomy/observable_tier.hpp:127-144` (`ComdareTierObserverSnapshot`, sizeof==1416, static_asserts `:145/:147`, `kTierObserverSnapshotVersionUnified :152`).
- **Test-Vorlage:** `tests/unit/test_v5_measurement_snapshot.cpp` (25-Spalten-Assert `:71`, pipeline16==16 `:95`).

## 3. Soll (der Increment) — Defaults gesetzt, NICHT nachfragen
(a) **NEU `cmake/provenance.cmake`** (Muster `isa_features.cmake`): `find_package(Git QUIET)`; je Repo `execute_process(COMMAND ${GIT_EXECUTABLE} -C <pfad> rev-parse HEAD OUTPUT_VARIABLE ...)` mit **`"unknown"`-Fallback** bei Fehler/fehlendem Verzeichnis (Offline-/Teil-Checkout-sicher, KEINE Fabrikation) für: super(`${CMAKE_CURRENT_SOURCE_DIR}/../../..`), cache-engine(`.`), prt-art(`../comdare-prt-art`), thesis(`../../../thesis/diplomarbeit`). Erfasse `CMAKE_CXX_COMPILER_ID`, `CMAKE_CXX_COMPILER_VERSION`, **globale** `CMAKE_CXX_FLAGS` + `CMAKE_CXX_FLAGS_${CMAKE_BUILD_TYPE}`, `COMDARE_ISA_SUMMARY` (built-for). `configure_file(build_provenance.hpp.in ${CMAKE_BINARY_DIR}/generated/provenance/build_provenance.hpp @ONLY)` + generiertes Verzeichnis auf den Include-Pfad. Root-`CMakeLists.txt`: `include(cmake/provenance.cmake)` (bei den anderen configure_file-Includes).
(b) **NEU `cmake/build_provenance.hpp.in`** (Muster `*_flags.hpp.in`): `#pragma once`, namespace `comdare::cache_engine::provenance` (o. builder-konsistent), `inline constexpr std::string_view` je Feld: `compiler_id`, `compiler_version`, `cxx_flags`, `isa_built_for`, `git_sha_super`, `git_sha_cache_engine`, `git_sha_prt_art`, `git_sha_thesis` (`@VAR@`-substituiert).
(c) **NEU freie Funktion `serialize_provenance_manifest()` → std::string** (im `builder/`-Namespace, eigener Header `builder/provenance_manifest.hpp` ODER additiv in measurement_snapshot.hpp): zieht `build_provenance.hpp` (compiler/flags/isa-built-for/4×git-sha) + `probe_cpuid()` (isa-**ran-on**: vendor/brand/AVX2/AVX512-Bools + family/model + cache_line) + build-aktivierte Allokatoren (aus `axis_06_allocator_flags.hpp` `<vendor>_enabled`, als kommaseparierte Liste) zu einem lesbaren Manifest (Key-Value-Zeilen `key=value`, deterministisch geordnet; ISA **getrennt** `isa_built_for=` und `isa_ran_on=`). KEINE Messwerte, kein POD.
(d) **Sidecar-Write** (optional-schlank): eine Helper `write_provenance_manifest(path)` die das Manifest-String schreibt (analog dem bestehenden Manifest-Muster in `best_binary_selector` `ShippedArtifact.manifest_path`). App-Verdrahtung (f15_compare) NICHT zwingend jetzt — der Test genügt als Beleg.
(e) **Test** (`tests/unit/test_ap9_provenance_manifest.cpp` ODER additiv in test_v5_measurement_snapshot.cpp): (i) `serialize_provenance_manifest()` enthält alle Schlüssel (compiler_id/compiler_version/cxx_flags/isa_built_for/isa_ran_on/allocators/git_sha_super/…cache_engine/…prt_art/…thesis); (ii) git-sha-Felder = 40-hex ODER "unknown" (kein Fabrikat); (iii) **Neutralitäts-Guards:** volle CSV bleibt 25 Spalten, pipeline16 bleibt 16, `sizeof(ComdareTierObserverSnapshot)` unverändert. CMake-Registrierung.

## 4. HARTE Auflagen (Verstoß = Abbruch)
1. **KEIN POD-/ABI-Eingriff:** `ComdareMeasurementSnapshotV1` + `ComdareTierObserverSnapshot` + `kTierObserverSnapshotVersionUnified` + extern-C + `COMDARE_ANATOMY_ABI_MAJOR`(4) unverändert. Provenance-Strings NIE in einen POD.
2. **golden-neutral:** NICHT in `binary_id`/`permutation_axes`/`golden_fullpilot_320`/`source_catalog` schreiben. Provenance = messender Host/Build, NICHT Kompositions-Identität.
3. **pipeline16 bleibt EXAKT 16** (`serialize_measurements_pipeline16_csv` unberührt) — die LaTeX/PDF-Zuleitung.
4. **KEINE Fabrikation:** fehlender git-SHA/Repo → `"unknown"` (nie erfunden); Offline-Bau (kein Netz) muss durchlaufen.
5. Kein `git`. Kein `$null` stagen.

## 5. Verifikation (PFLICHT — Codex, literal)
- CMake konfigurieren (generiert `build_provenance.hpp`) + Test bauen+laufen → literal `[ PASSED ]`; zeige das erzeugte Manifest (mit realen Werten: compiler, flags, isa, 4 git-SHAs — cache-engine sollte `92b6f536` o. HEAD sein, super `87bb7f2`).
- Bestätige: `COMDARE_ANATOMY_ABI_MAJOR`==4; `sizeof(ComdareTierObserverSnapshot)` unverändert; volle CSV==25, pipeline16==16; golden/permutation_axes/POD unberührt.
- `git status --short`: NUR `cmake/provenance.cmake` (neu) + `cmake/build_provenance.hpp.in` (neu) + `CMakeLists.txt` (include) + `builder/provenance_manifest.hpp` (neu, o. measurement_snapshot.hpp) + der Test (+ tests/unit/CMakeLists.txt).

## 6. Ausgabe an Claude
(a) Diffs + neue Dateien; (b) das erzeugte Manifest (literal, reale Werte); (c) literal `[ PASSED ]`; (d) Bestätigung ABI-4/golden-neutral/pipeline16==16/POD-sizeof-unverändert/keine-Fabrikation(unknown-Fallback); (e) offene Design-Punkte, die ich dem User zur Info gebe (per-Target-Flags, App-Verdrahtung f15_compare als Follow-up).
