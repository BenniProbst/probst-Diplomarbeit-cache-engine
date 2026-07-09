# DOSSIER AP-7b/#262 (Phasen 7b-1 + 7b-2) — SwissTableOrgan Weg-B: echter Mess-Pfad statt SortedBinary-Surrogat (ABI-4, golden-neutral, Flag bleibt OFF)

> **Für Codex** (`--sandbox workspace-write`, gpt-5.5, xhigh). EIN Agent. Repo = `--cd` (comdare-cache-engine, HEAD ~c7204af8).
> **NICHT committen, KEINE git-Operationen.** Basis = fresh-context-Kartierung (Explore ab8a83d2), alle Zeilen belegt.
> SCOPE: NUR 7b-1 (composable-Bausteine, additiv) + 7b-2 (organ_for-Flip + Test-Aufnahme). NICHT: SIMD-Gruppen-Probe (7b-3 deferred), swiss_probe_shape-Achse, isa-Kopplung, supports_simd-Kippen, Wrapper-Umbau.

## 1. Auftrag
SwissTable (S22) bekommt sein FAITHFUL natives Organ (Weg-B), sodass `pool_family_` im ABI-Adapter true wird und S22 — falls je enabled — als echte SwissTable gemessen wird statt durch den SortedBinary-Flach-Spiegel. Skalar zuerst, bit-identisch zum AP-7a-Wrapper.

## 2. VERIFIZIERTER Ist-Zustand (Kartierung — GENAU diese Belege nutzen)
- **AP-7a-Wrapper** `libs/cache_engine/axes/lookup/axis_03a_search_algo_swisstable.hpp`: echte Anatomie im Wrapper — `slots_`+`ctrl_` getrennt (`:255-256`), kGroupWidth=16/kEmpty=0x80/kDeleted=0xFE/H1-H2 (`:64-70`,`:182-192`), skalare Gruppen-Probe lookup/insert_impl/erase (`:80-135`,`:194-229`), Rehash 7/8 (`:76`), Tombstone-Reuse (`:211-217`). family_id=22 (`:48`). **Wrapper NICHT umbauen** (AP-7a done).
- **Fehlstelle:** `organ_for_search_algo.hpp:61-64` Primär-Template `= void` — keine S22-Spezialisierung → `abi_adapter.hpp:1873-1874` `pool_family_=false` → SortedBinary-Spiegel `:1860-1885`.
- **Vorbild-Kette S14-Hash** (alle `libs/cache_engine/axes/lookup/composable/`): `hash_bucket_pool_store.hpp` (`:29-48`, „1:1-Port des Slot-Arrays" `:6-9`) + `hash_probe_traversal_organ.hpp` (statisch `:38-134`) + `composed_hash_search.hpp` (EIGENE 17-Zeilen-Schale, Begründung `:6-10`; std::map-Interface + **for_each_record DEG-1** `:39-57`) + Alias `tier_to_organ_mapping.hpp:48-49` + organ_for-Eintrag `organ_for_search_algo.hpp:93-95`.
- **Test-Gates:** `test_188_4bbV_pool_adapter_flip_compile.cpp` main `:187-195` (9 Familien type-direkt, FLAG-UNABHÄNGIG; generisches `verify_pool_adapter_flip` mit organ!=void-static_assert `:90-99` + DEG-1-Ernte `:158-176`); Schwester `test_188_4bb0_pool_organ_wide_key_conformance.cpp:168-177` (gleiche 9).
- **golden-Mechanik:** S22 END-appendiert in AllStrategies (`registry.hpp:86`), Flag default OFF (`generated flags :58 = 0`) → EnabledStrategies/First-4 byte-identisch; `!StoreTraversableSearchAlgo<SwissTableSearchAlgo>`-Assert bleibt (`registry.hpp:132-133`, Weg-B).
- **Disjunktheits-Asserts:** `organ_for_search_algo.hpp:145-177`.

## 3. Soll — ZWEI PHASEN (getrennt verifizierbar; Claude committet granular)
### Phase 7b-1 (rein additiv, kein Mess-Pfad-Touch)
(a) **`libs/cache_engine/axes/lookup/composable/swiss_group_pool_store.hpp`**: `SwissGroupPoolStore<...>` = 1:1-Port von `slots_`/`ctrl_`/`mask_`/`size_`/`tombstones_` + Rehash-7/8 + Tombstone-Reuse aus dem Wrapper (Header-Kommentar: faithful Port, Quelle swisstable.hpp, CC-Kette wie hash_bucket-Muster). Verantwortungs-Split wie S14: Store = Slot-/Ctrl-Verwaltung + rehash; KEINE Such-Logik. Default-Template-Form analog HashBucketPoolStore.
(b) **`swiss_group_pool_concept.hpp`** (Gegenstück zu hash_bucket_pool_concept.hpp) + static_assert im Store.
(c) **`swiss_group_probe_traversal_organ.hpp`**: `SwissGroupProbeTraversalOrgan` — statische insert_into/lookup_in/erase_from mit H1/H2 + SKALARER 16er-Gruppen-Probe, **bit-identisch** zur Wrapper-Logik (`swisstable.hpp:80-135`,`:194-229`). KEIN SIMD (7b-3).
(d) **`composed_swiss_search.hpp`**: `ComposedSwissSearch<Traversal,Pool>` — eigene schmale Schale (Präzedenz composed_hash_search:6-10), std::map-Interface + `for_each_record` (DEG-1-Vertrag: jeden Record exakt einmal, ctrl_-Scan, kEmpty/kDeleted überspringen, kein Statistik-Effekt).
(e) **Alias** `SwissTableOrgan = ComposedSwissSearch<SwissGroupProbeTraversalOrgan, SwissGroupPoolStore<>>` in `tier_to_organ_mapping.hpp` (neben `:48-49`).
(f) **Test `tests/unit/test_ap7b_swiss_organ.cpp`** (gtest, CMake-Registrierung): std::map-Harness auf dem Organ (uint64; Insert/Lookup/Erase/Tombstone-Refill-Szenario analog test_ap7_swisstable:55-105) + for_each_record-exactly-once + NeutralityGuards-Block (wörtlich test_ap9:68-84).
### Phase 7b-2 (der Flip; type-getrieben, flag-unabhängig, golden-neutral)
(g) `organ_for_search_algo<SwissTableSearchAlgo> = SwissTableOrgan`-Spezialisierung + Disjunktheits-static_asserts erweitern (Muster `:93-95`/`:145-177`).
(h) `test_188_4bbV_pool_adapter_flip_compile.cpp`: 10. Zeile `verify_pool_adapter_flip<lk::SwissTableSearchAlgo>("SwissTable")` (main :187-195); `test_188_4bb0_pool_organ_wide_key_conformance.cpp:168-177`: 10. Familie analog.

## 4. HARTE Auflagen (Verstoß = Abbruch)
1. **golden/Registry TABU:** AllStrategies-Ordnung (S22 bleibt Ende), EnabledStrategies-Filter, First-4, Flag-Default OFF, `source_catalog`, `golden_fullpilot_320_binary_ids.txt` UNVERÄNDERT. `!StoreTraversable`-Assert (`registry.hpp:132`) bleibt.
2. **ABI-4:** kein POD/extern-C/abi-Header-Eingriff. Wrapper `swisstable.hpp` NICHT anfassen. `modules/`-Klone NICHT anfassen. `apps/perm_runner/main.cpp` (user-dirty) NICHT anfassen.
3. **Faithful:** Organ-Logik bit-identisch zum Wrapper (gleiche H1/H2, gleiche Probe-Reihenfolge, gleiche Rehash-Schwelle); KEINE Vereinfachungen/Surrogate. KEIN SIMD in diesem Increment.
4. **clang-format-Konformität** aller neuen/geänderten Dateien (Root-.clang-format; lint:format ist Pflicht-grün): `C:/Users/benja/AppData/Local/Temp/claude/C--WINDOWS-system32/78cf67f8-571e-4fcd-a907-1556dbc5be72/scratchpad/llvm/clang-format.exe --dry-run -Werror <dateien>` = 0.
5. Kein `git`. Kein `$null`.

## 5. Verifikation (PFLICHT, literal, über konfigurierten build/ — falls build/ gesperrt: %TEMP%-Build wie zuletzt, dann sagen)
- Phase-1: `test_ap7b_swiss_organ` bauen+laufen → `[ PASSED ]`.
- Phase-2: `test_188_4bbV_pool_adapter_flip_compile` + `test_188_4bb0_pool_organ_wide_key_conformance` bauen+laufen (jetzt 10 Familien) → literal OK-Zeilen inkl. „SwissTable".
- `test_profile_roundtrip` (golden byte-identisch, Muster letzter Lauf) → mismatch 0.
- clang-format dry-run = 0 über alle angefassten Dateien.
- `git status --short`: NUR die 5 neuen composable-Header + tier_to_organ_mapping.hpp + organ_for_search_algo.hpp + die 2 Test-Dateien (4bbV/4bb0) + neuer test_ap7b + tests/unit/CMakeLists.txt.

## 6. Ausgabe an Claude
(a) Diffs, klar getrennt nach Phase 7b-1 (Dateien a-f) und 7b-2 (g-h) — Claude committet in ZWEI granularen Commits; (b) literal alle Suiten-Ergebnisse + golden-roundtrip mismatch 0 + clang-format 0; (c) Bestätigung: Wrapper unberührt, Registry-Ordnung/Flag unverändert, bit-identische Probe-Logik (kurze Gegenüberstellung der Kern-Schleifen), for_each_record exactly-once; (d) Notizen zu bewussten Absenzen (SIMD 7b-3, shape-Achse offen).
