# DOSSIER AP-10/#244 (MECHANIK-Teil) — Dataset-Akte-Manifest + String→uint64-Loader (Option A), host-seitig, ABI-4, golden-neutral

> **Für Codex** (`--sandbox workspace-write`, gpt-5.5, xhigh). EIN Agent. Repo-Wurzel = `--cd` (comdare-cache-engine).
> **NICHT committen, KEINE git-Operationen.** Basis = fresh-context-Kartierung (Explore aac3384f), alle Zeilen belegt.
> **SCOPE-GRENZE (kritisch):** NUR die **Mechanik** — KEINE Erfindung der „8 Datensätze" (die sind user-gated, extern in `Termin 7/Datasets_Spezifikation.txt`, NICHT im Repo). KEINE String-*Keys* (Option B = ABI-Bruch, out-of-scope Doc 32:66). NUR **Option A** (String→uint64-Hash-Loader) + Dataset-Akte-Manifest.

## 1. Auftrag (2 additive, ABI/golden-neutrale Header + Test)
(A) Ein **String→uint64-Dataset-Loader** in den bestehenden AP-CE2-Slot (deterministisch, self-registering).
(B) Ein **Dataset-Akte-Manifest** (checksum + line_count + preprocessing) host-seitig, Muster AP-9 `provenance_manifest.hpp`.
Rein host-seitig; `tier_insert(uint64,uint64)`/POD/golden-320/conformance_gate/pipeline16 UNBERÜHRT.

## 2. VERIFIZIERTER Ist-Zustand (nutze GENAU diese Belege)
- **AP-CE2-Loader-Slot (existiert, ungenutzt):** `libs/common/measurement/dataset_loader/include/comdare/measurement/dataset_loader/dataset_loader.hpp` — `DatasetLoaderStrategy` (abstrakt, `load(dataset_id, seed) → std::optional<std::vector<wg::Operation>>` `:46-47`), `DatasetLoaderRegistry` (Meyers-Singleton, `register_loader`/`try_load` `:58-84`). **Vorlage-Loader:** `…/loaders/example_uint64_keyfile_loader.hpp` (liest uint64/Zeile → Read-Ops `:26-42`; Self-Registration `:45-49`).
- **Op-Modell:** `wg::Operation{ op; std::uint64_t key_id; … }` (`workload_generator.hpp:57-61`). Loader MÜSSEN uint64-Ops emittieren (das ist der ganze Punkt von Option A).
- **AP-9-Manifest-Muster (Vorlage für die Akte):** `libs/cache_engine/builder/provenance_manifest.hpp` — `serialize_provenance_manifest() → std::string` (key=value\n) + `write_provenance_manifest(path)` (`:74-104`).
- **Test-Vorlagen:** `tests/unit/test_ap9_provenance_manifest.cpp` (Struktur + NeutralityGuards `:68-85`); `tests/unit/test_a1_load_profile_opmix.cpp:21-27` (self-contained Temp-Datei schreiben→parsen→prüfen).
- **CMake-Registrierung:** `tests/unit/CMakeLists.txt:1166-1173` (`comdare_add_test(...) + target_include_directories(... ${CMAKE_BINARY_DIR}/generated) + target_link_libraries(...)`).
- **TABU (golden/ABI, via AP-9-Test belegt):** `COMDARE_ANATOMY_ABI_MAJOR==4`, `sizeof(ComdareTierObserverSnapshot)==1416`, `kTierObserverSnapshotVersionUnified==5`, Voll-CSV==25, pipeline16==16, `conformance_gate.hpp` bleibt `std::map<uint64,uint64>`, `golden_fullpilot_320_binary_ids.txt` unberührt.

## 3. Soll (der Increment) — Defaults gesetzt, NICHT nachfragen
(A) **NEU `…/dataset_loader/loaders/string_corpus_loader.hpp`** (Muster `example_uint64_keyfile_loader.hpp`): liest eine Text-Korpus-Datei (ein String je Zeile), bildet jeden String **deterministisch** auf `uint64` ab via **self-contained stabilem Hash** (FNV-1a 64-bit — KEINE externe Dependency; im Header implementiert), emittiert `std::vector<wg::Operation>` (Read-Ops, key_id = hash). Dedup optional (gleicher String → gleicher Key = korrekt). `DatasetLoaderStrategy`-Implementierung + Self-Registration im Registry (analog `:45-49`). Deterministisch (kein Zeit/Random).
(B) **NEU `libs/common/measurement/dataset_loader/include/comdare/measurement/dataset_loader/dataset_akte.hpp`** (Muster `provenance_manifest.hpp`): `DatasetAkte{ std::string id, source_path, preprocessing; std::uint64_t checksum; std::uint64_t line_count; }` + `compute_dataset_akte(id, path, preprocessing) → DatasetAkte` (checksum = FNV-1a 64 über die Datei-Bytes; line_count = Newline-Zählung; preprocessing = caller-Deskriptor, Default `"none"`) + `serialize_dataset_akte(const DatasetAkte&) → std::string` (key=value\n: id/source_path/checksum(hex)/line_count/preprocessing) + `write_dataset_akte(path, akte)`. Rein lesend/host-seitig.
(C) **NEU `libs/common/measurement/dataset_loader/DATASETS_SCHEMA.md`** (o. im dataset_loader/): dokumentiert das Akte-Format (checksum/line_count/preprocessing) + den String→uint64-Loader (Option A) + **explizit**: die konkreten „8 Datensätze" sind extern spezifiziert (`Termin 7/Datasets_Spezifikation.txt`) und werden vom User registriert — hier NUR die Mechanik. Option B (String-Keys) = bewusst out-of-scope (Doc 32:66, ABI-Bruch).
(D) **Test `tests/unit/test_ap10_dataset_akte.cpp`** (gtest, Muster AP-9 + A1, self-contained Temp-Korpus): (1) `string_corpus_loader` mappt einen Temp-Korpus (z.B. 5 Zeilen) **deterministisch** auf uint64-Ops (gleicher Input→gleiche Keys, verschiedene Strings→verschiedene Keys mit hoher W'keit); (2) `compute_dataset_akte` liefert korrekte line_count + stabile checksum (zweiter Aufruf == erster) + preprocessing-Deskriptor; (3) `serialize_dataset_akte` enthält alle Keys; (4) **`NeutralityGuardsStayIntact`** — die AP-9-static_asserts + CSV-25/pipeline16-16 **wörtlich** übernehmen. CMake-Registrierung.

## 4. HARTE Auflagen (Verstoß = Abbruch)
1. **KEINE erfundenen „8 Datensätze":** keine konkreten Dataset-Dateien/-Einträge/-Checksums hardcoden. NUR die Mechanik + der self-contained Test-Temp-Korpus.
2. **Option A only, KEINE String-Keys:** `tier_insert(uint64,uint64)`, `IDriveableTier`, `conformance_gate.hpp` (`std::map<uint64,uint64>`), Snapshot-POD UNVERÄNDERT. Loader emittiert uint64-Ops.
3. **ABI/golden-neutral:** NICHT in binary_id/permutation_axes/golden_fullpilot_320/ABI-POD/`COMDARE_ANATOMY_ABI_MAJOR`(4) schreiben; Voll-CSV==25, pipeline16==16.
4. **Self-contained:** FNV-1a im Header (keine externe Hash-Lib); Test schreibt Temp-Korpus selbst (kein Fremd-Dataset).
5. Kein `git`. Kein `$null` stagen.

## 5. Verifikation (PFLICHT — Codex, literal)
- Baue+laufe `test_ap10_dataset_akte` (über den konfigurierten `build/`) → literal `[ PASSED ]`; zeige eine Beispiel-Akte (id/checksum(hex)/line_count/preprocessing) + Loader-Determinismus-Beleg.
- Bestätige: `COMDARE_ANATOMY_ABI_MAJOR`==4; `sizeof(ComdareTierObserverSnapshot)`==1416; Voll-CSV==25, pipeline16==16; conformance_gate/POD/golden unberührt.
- `git status --short`: NUR die 3 neuen Header/Doc (loaders/string_corpus_loader.hpp, dataset_akte.hpp, DATASETS_SCHEMA.md) + der Test + tests/unit/CMakeLists.txt (+ ggf. dataset_loader-CMake, falls Header dort registriert werden müssen).

## 6. Ausgabe an Claude
(a) Diffs + neue Dateien; (b) literal `[ PASSED ]` + Beispiel-Akte + Loader-Determinismus; (c) Bestätigung KEINE erfundenen 8 Datensätze, Option-A-only, ABI-4/golden/pipeline16-neutral; (d) klare Notiz der User-Gates (welche 8 Datensätze + Soll-Werte; Option A vs B), die ich dem User weitergebe.
