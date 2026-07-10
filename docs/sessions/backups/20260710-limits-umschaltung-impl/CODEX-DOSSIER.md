# CODEX-DOSSIER — Limits-Entkopplung PRODUKTIVUMSCHALTUNG (Gate-Stufen 4-6)

> GO-Increment 1b (User-Freigabe „alle GO increments" 10.07.). Vorstufe (Gates 1-3) = VOLLZOGEN
> (ce `fb67caa0`, CI grün): `apps/catalog_codegen_tool` + `test_limits_entkopplung_vorstufe`.
> Spezifikation = `../20260710-schicht-e3-impl/LIMITS-ENTKOPPLUNG-ANALYSE.md` §4 (Stufen 4-6 wörtlich):
> *„4. Profil-Gate: test_profile_roundtrip bleibt gruen; dynamische Levels duerfen die statische Zaehlung
> nicht beeinflussen. 5. Union-/Sweep-Gate: test_run_profile_union und die vertieften Sweep-Pfade bleiben
> disjunkt und liefern weiterhin reale Quellen. 6. Erst danach Produktivumschaltung: FullSourceCatalog wird
> durch den generierten Default-Katalog ersetzt oder als Fallback behalten. Die Umschaltung ist build-time,
> nicht runtime."*
> Wurzeln: super = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`,
> ce = `super/Code/external/comdare-cache-engine` (main `fb67caa0`).

## 0. HARTE VERBOTE

Wie alle Schicht-Dossiers §0 (golden/permutation_axes/m3v2/PODs/ABI-MAJOR==4/GenusBindingTraits/modules/ext/thesis
TABU; kein git; deutsche Kommentare ue/ae/oe; kein Python). ZUSÄTZLICH increment-spezifisch:
- **(a) Golden-Zirkularitäts-Verbot:** `tests/unit/thesis_tiere/gen_golden_fullpilot.cpp` bleibt BYTE-UNBERÜHRT
  auf `catalog_static_levels<FullSourceCatalog>()` (:36) — der Golden-Ursprung wird NIEMALS auf den generierten
  Pfad umgestellt, sonst verliert das Gate seinen Wert (Analyse §3).
- **(b) `FullSourceCatalog` bleibt BESTEHEN** (Analyse §4-6 „oder als Fallback behalten"): `source_catalog.hpp`
  wird NICHT gelöscht/entkernt — er bleibt handgeschriebene Referenz, Golden-Ursprung und Gegenpol des
  Vorstufe-Äquivalenz-Gates (Stufe 1). Umgeschaltet werden nur die PRODUKTIV-Konsumenten.
- **(c) build-time only:** kein Runtime-Switch, kein `#ifdef`-Doppelpfad in den Konsumenten — der Konsument
  inkludiert den generierten Header direkt; die Auswahl ist eine CMake-/Include-Entscheidung.
- **(d) Generierte Header NUR in Build-Verzeichnissen**, nie in Source-Bäume oder `super/Code/**`.
- **(e) `tests/unit/thesis_tiere/README.md`-Doktrin unangetastet:** Roundtrip/Union/Sweep bleiben ADHOC
  (bewusst nicht ctest, :75-81) — NICHT in ctest registrieren.
- **(f) Kanonische Slot-/Werte-Reihenfolge nie sortieren/normalisieren** (Vorstufe-Review-Lehre wf_fce92d2c).

## 1. AUSGANGSLAGE (verifizierte Kartierung, alles datei:zeile)

Konsum-Kanten von `source_catalog.hpp`/`FullSourceCatalog`:
- `tests/unit/thesis_tiere/profile_run_entry.hpp:23` (Include) + `:156-159` — baut `union_gen` aus
  `make_catalog_source_gen<FullSourceCatalog>()` (+ Sweep-/SOTA-Maps); Aufrufer `run_lazy_static_then_dynamic`
  `:241-275`/`:284-310`. **= DER Produktiv-Konsument** (transitiv: Facade `profile_run_facade.cpp:6`→`:142`,
  `run_lazy_150.cpp:24`→`:282`, `test_run_profile_union.cpp:18`).
- `tests/unit/thesis_tiere/test_run_profile_union.cpp:110-111,130` — eigener `union_gen`/`basis_only` aus
  `make_catalog_source_gen<FullSourceCatalog>()` (Gate-5-Prüfstein).
- `tests/unit/thesis_tiere/gen_golden_fullpilot.cpp:15,36` — Golden-Ursprung (TABU, §0a).
- `tests/unit/test_limits_entkopplung_vorstufe.cpp:113` — Referenzseite des Äquivalenz-Gates (bleibt).
- `tests/unit/thesis_tiere/test_axis_sweep_pilot.cpp:21,135,220,238` — nutzt `axis_sweep_source_map`/
  `kary_perk_source_map`, NICHT `FullSourceCatalog` → von der Umschaltung NICHT betroffen (nur Gate-5-Regression).
- `apps/adhoc_emitter/main.cpp:24-26,139-140,185-219` — EIGENER `PilotEngine` (Split-Brain, §3-Scope).

Neuer generierter Pfad (Vorstufe):
- `apps/catalog_codegen_tool/main.cpp` — emittiert `GeneratedFullSourceCatalog` +
  `generated_catalog_static_levels()` + `generated_make_catalog_source_gen()` (`:287-305`), Header inkludiert
  selbst `thesis_tiere/source_catalog.hpp` (`:280`) für die generischen Templates.
- Codegen-CMake aktuell NUR in `tests/unit/CMakeLists.txt:2534-2547` (custom_command + custom-target
  `comdare_limits_generated_source_catalog`), Konsument nur `test_limits_entkopplung_vorstufe` (`:2565`).

**Verifizierte Struktur-Lage (Bestands-Konvention übernehmen):** Der BESTANDS-Codegen schreibt durchgehend
nach `${CMAKE_BINARY_DIR}/generated/...` (`cmake/anatomy_codegen.cmake:128,136`; der Vorstufe-Codegen
`tests/unit/CMakeLists.txt:2534` folgt ihr bereits). Der `${PROJECT_BINARY_DIR}/generated`-Include der Facade
(`libs/cache_engine/profile_facade/CMakeLists.txt` `_facade_heavy_includes`) ist im super-Sub-Build wirkungslos
(divergiert dort von CMAKE_BINARY_DIR); die echten Axis-Header erreichen die Facade über
`_facade_axis_generated_dirs` (CMAKE_BINARY_DIR-basiert). ⇒ **Output-Konvention `${CMAKE_BINARY_DIR}/generated`
BEIBEHALTEN** (Bestands-Mechanik wiederverwenden), Konsumenten-Anbindung über EINE zentrale Funktion.
`COMDARE_BUILD_TESTS` ist auch im super-Sub-Build ON (ce `CMakeLists.txt:32`, super setzt es nicht ab) und
`add_subdirectory(apps)` ist unbedingt (ce Root `:600`) — Tool + Codegen existieren in beiden Einbettungen.
Beachte: `add_custom_command(OUTPUT)` ist directory-scoped — Konsumenten in anderen Verzeichnissen (Facade)
brauchen `add_dependencies` auf das custom-target.

## 2. PAKET A — Codegen-Verdrahtung zentralisieren (CMake-Refactor, eigener Code der Vorstufe)

1. NEU `cmake/catalog_codegen.cmake` (Namens-Konvention der Geschwister `anatomy_codegen.cmake`/
   `adhoc_emitter.cmake`): definiert EINMAL (a) das custom_command mit Output
   `${CMAKE_BINARY_DIR}/generated/generated_source_catalog.hpp` (Bestands-Konvention), (b) das custom-target
   `comdare_limits_generated_source_catalog`, (c) eine Funktion `comdare_attach_generated_catalog(<target>)`
   = `add_dependencies(<target> comdare_limits_generated_source_catalog)` +
   `target_include_directories(<target> PRIVATE "${CMAKE_BINARY_DIR}/generated")`. Include des Moduls im
   ce-Root-`CMakeLists.txt` NACH `add_subdirectory(apps)` (`:600`, Tool-Target `comdare_catalog_codegen_cli`
   muss existieren) und VOR `add_subdirectory(tests)` (`:608`) sowie VOR der Facade-Konfiguration —
   Konfigurations-Reihenfolge kartieren (libs/ kommt VOR apps/? Dann Funktion/Target-Definition so legen,
   dass die Facade sie sieht: notfalls Modul-include direkt nach apps/ und Facade-Anbindung via
   `cmake_language(DEFER)` nach Bestands-Muster der Facade selbst — Muster in
   `libs/cache_engine/profile_facade/CMakeLists.txt` bereits vorhanden, wiederverwenden).
2. `tests/unit/CMakeLists.txt:2534-2547` — den lokalen custom_command/custom-target-Block ERSETZEN durch
   `comdare_attach_generated_catalog(test_limits_entkopplung_vorstufe)`; Duplikat entfernen (eigener Code
   dieses Increments, ebenen-richtiges Aufräumen). Der explizite
   `${CMAKE_BINARY_DIR}/generated`-Include-Eintrag des Tests entfällt zugunsten der Funktion.
3. `apps/catalog_codegen_tool/CMakeLists.txt` bleibt unverändert (`:14,22,31` sind Bestands-Konvention).

## 3. PAKET B — Produktivumschaltung Stufe 6 (Konsumenten-Wechsel)

1. `tests/unit/thesis_tiere/profile_run_entry.hpp`: Include `generated_source_catalog.hpp` (statt direktem
   FullSourceCatalog-Konsum für den union_gen); `:156-159` → `union_gen` aus
   `generated_make_catalog_source_gen()` + statische Levels aus `generated_catalog_static_levels()` wo der
   Header sie produktiv zieht. Sweep-/SOTA-Map-Anteile UNVERÄNDERT. Der Header wird von Facade,
   run_lazy_150 und test_run_profile_union konsumiert — ALLE brauchen die Codegen-Anbindung (Paket A-3-Funktion):
   - `libs/cache_engine/profile_facade/CMakeLists.txt`: `comdare_attach_generated_catalog(comdare_profile_run_facade)`
     (Include-Pfad hat sie schon via `_facade_heavy_includes` — auf zentralen Pfad angleichen + add_dependencies NEU).
   - CMake-Targets von `run_lazy_150` + `test_run_profile_union` ebenso anbinden.
     (`test_profile_roundtrip` inkludiert WEDER profile_run_entry NOCH source_catalog — verifiziert per grep;
     Gate 4 läuft unabhängig und braucht KEINE Anbindung.)
2. `test_run_profile_union.cpp:110-111,130`: eigener `union_gen`/`basis_only` ebenfalls auf
   `generated_make_catalog_source_gen()` — der Test prüft danach den PRODUKTIV-Pfad (Gate 5 echt).
3. `gen_golden_fullpilot.cpp` + `test_limits_entkopplung_vorstufe.cpp` + `source_catalog.hpp`: UNBERÜHRT (§0a/b).
4. `apps/adhoc_emitter`: NICHT umstellen (eigener PilotEngine = anderer, kleinerer Katalog; Split-Brain-Risiko
   wird als dokumentierte Scope-Grenze im Abschlussbericht benannt — Angleich wäre eigener Increment).

## 4. PAKET C — Beweis-Gates 4-5 (ADHOC-Läufe, literal — KEINE neuen ctest-Einträge)

Nach der Umschaltung im frischen Build-Verzeichnis `build-codex-limits2/` (am Ende löschen):
1. **Gate 4:** `test_profile_roundtrip` bauen + laufen (ADHOC-Aufruf laut `thesis_tiere/README.md:40-49`) —
   grün, 320 Golden-IDs positionsidentisch, dynamische Levels ändern die statische Zählung nicht.
2. **Gate 5:** `test_run_profile_union` bauen + laufen — Union disjunkt, reale (nicht-leere) Quellen;
   `test_axis_sweep_pilot` bauen + laufen — unverändert grün.
3. **Regression:** kompletter ctest (alle registrierten Tests inkl. `test_limits_entkopplung_vorstufe`,
   Contract-/Striktheits-Suiten) — 100%.
4. **Facade-Beweis:** super-Sub-Build konfigurieren + `messung_driver`-Target bauen (facade-verify-Muster,
   `Code/02_messung_driver/CMakeLists.txt:22-27`) — beweist, dass der generierte Header im super-Sub-Build
   am richtigen Ort entsteht und die Facade linkt.

## 5. DoD / SELBST-VERIFIKATION

Alle Paket-C-Läufe LITERAL zeigen (Kommando + Ausgabe). clang-format-22 (~/tools/cf22) dry-run==0 auf allen
angefassten Dateien; Mojibake==0; `git status`: NUR die geplanten Dateien — golden/m3v2/source_catalog/
gen_golden_fullpilot/adhoc_emitter byte-unberührt (git diff --stat als Beleg). NICHTS committen.
Abschlussbericht: VOLLSTÄNDIGES Manifest + LITERALE Ausgaben + dokumentierte Scope-Grenzen (adhoc_emitter-
Split-Brain) + offene Punkte.
