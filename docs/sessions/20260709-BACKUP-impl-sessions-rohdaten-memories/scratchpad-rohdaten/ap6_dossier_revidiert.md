# DOSSIER AP-6 / #240 (REVIDIERT #170) — 33/33 SOTA (inkl. 3 abstrakte Prüfling-Profile) + 23/23 Allokator + Coverage-Gate

> **Für Codex** (`--sandbox workspace-write`, gpt-5.5, xhigh). Arbeite als EIN Agent — KEINE Sub-Agenten.
> Repo-Wurzel = das aktuelle `--cd` (comdare-cache-engine). **NICHT committen, KEINE git-Operationen.**
> Bei Unerfüllbarkeit eines Punkts: STOPP + melde es in §8 (nicht raten, nicht fabrizieren).

## 1. Auftrag (fünf Teile, ABI-neutral)
(a) **3 abstrakte SOTA-Profile** anlegen: P08 (OLC), P09 (LOUDS), P33 (VAMPIR) — als „abstract"-Prüfling-Marker,
    die auf ihre bereits existierenden Organe zeigen (P08/P09) bzw. ehrlich als konzeptioneller Marker (P33).
(b) **Parser additiv erweitern**: optionales Attribut `pruefling_type="abstract"` am `<comdare_algorithm_profile>`
    lesen (Struct-Feld + parse_profile). Default `""` = full (rückwärtskompatibel).
(c) **13 fehlende Allokator-Profil-XMLs** (A02/A09/A12–A19/A21–A23) anlegen (Allokator-Abdeckung 10→23).
(d) **Coverage-Gate** (rein-lesender Test): `sota/` → 33/33 `paper_ref` (P01..P33); `allocators/` → 23/23
    `family_ref` (A01..A23). Registrierung in `tests/unit/CMakeLists.txt`.
(e) **CI-Job** `contract:profile_coverage` in `.gitlab-ci.yml` (Linux-g++), Spiegel eines bestehenden contract-Jobs.

## 2. WARUM abstrakt (revidierte Architektur-Richtung, verbindlich)
Ein Paper, das nur ein abstraktes Gesamt-„Tier" liefert und sonst nicht auflösbar ist, wird als **eigenes
abstraktes Profil** (Prüfling-Marker) geladen — es zeigt an, WO der Prüfling in der Achsen-Landschaft liegt, und
wird dennoch korrekt seziert (Achsen). P08 (OLC) und P09 (LOUDS) haben ihre Organe bereits im Code — ihr
abstraktes Profil zeigt via `<concurrency>`/`<layout>` darauf. **P33 (VAMPIR/SPP2377) ist ein 1-seitiges
Kickoff-Poster OHNE Algorithmus/Pseudocode/Datenstruktur** (verifiziert gelesen) → ein „haargenauer Nachbau" ist
faktisch unmöglich und würde Fabrikation erfordern (VERBOTEN). P33 wird daher als **ehrlicher abstrakter
Konzept-Marker** geführt (Annotation: „SPP2377-Kickoff-Poster, kein Algorithmus → kein Nachbau möglich").

## 3. HARTE Auflagen (Verstoß = Abbruch + §8)
1. **KEINE FABRIKATION.** Jede Metadatenzeile (name/authors/year/venue/doi/license/repo) MUSS aus einer
   autoritativen Repo-Quelle (§5) stammen. Fehlt ein Feld dort → Feld WEGLASSEN oder leer, NICHT erfinden.
   Kein erfundener Algorithmus/keine erfundene Datenstruktur für P33.
2. **ABI-NEUTRAL.** NICHT anfassen: `COMDARE_ANATOMY_ABI_MAJOR`/POD/extern-C-Signaturen, `permutation_axes.xml`
   (Build-Enum-Namensraum), Registry/`mp_list`, `golden_fullpilot_320_binary_ids.txt`, `source_catalog.hpp`-320,
   `modules/**`, `ext/**` (Original-Code), die `<sota_series pruefling_type>`-Mechanik in `sota_catalog`/
   thesis_profiles (das ist #171, ein ANDERES Element — nicht vermengen). Der Parser-Struct `AlgorithmProfile`
   ist host-seitig (KEIN ABI-POD) → additives Feld ist erlaubt.
3. **SCHEMA-TREUE.** Neue Profile EXAKT im Schema der bestehenden (§5.2 / §5.4). Achsen-VALUES müssen die
   Token-Konvention der Geschwister-Profile treffen (Großbuchstaben-Tokens wie `RCU`/`SLAB`/`CACHE_LINE_ALIGNED`,
   NICHT die permutation_axes-Kleinschreibung). Unbekannten Token NICHT raten → aus einem Geschwister-Profil,
   das dieselbe Achse belegt, ABLESEN; sonst neutralen Baseline-Token + Kommentar.
4. **Nur diese Dateien** anlegen/ändern: `libs/cache_engine/algorithm_profiles/sota/{olc,louds,vampir}.profile.xml`
   (neu); `libs/cache_engine/algorithm_profiles/allocators/*.profile.xml` (13 neu); `libs/common/serialization/
   xml_config_parser/xml_config_parser.{hpp,cpp}` (additiv); `tests/unit/thesis_tiere/test_profile_coverage.cpp`
   (neu); `tests/unit/CMakeLists.txt` (additiv); `.gitlab-ci.yml` (additiv, ein Job). NICHTS anderes.
5. Kein `git`.

## 4. Kartierung (verifiziert — nutze GENAU diese Pfade)
- **SOTA-Dir**: `libs/cache_engine/algorithm_profiles/sota/` — 30 Profile (art=P01 … zhang_fgcs). P08/P09/P33 fehlen.
- **SOTA-Schema-Vorlage** (LIES sie zuerst): `sota/rcu.profile.xml` (Concurrency-Beispiel, ideal für P08) +
  `sota/surf.profile.xml` (LOUDS/succinct-nah, für P09) + `sota/art.profile.xml`. Struktur:
  `<comdare_algorithm_profile id=".." paper_ref="Pxx">` → `<metadata>`(name/authors/year/venue[/doi]) →
  `<axes>`(page/node/traversal/value_handle/concurrency/allocator/prefetch/telemetry/isa/layout/reclamation) →
  `<key_value_signature>`(key_types/value_types) → `<expected_workload>`.
- **Parser**: Struct `AlgorithmProfile` in `libs/common/serialization/xml_config_parser/xml_config_parser.hpp`
  (~Z.49-57, Felder id/paper_ref/axes/key_types/value_types/expected_workload/allocator_override) + `parse_profile`
  in `xml_config_parser.cpp` (~Z.121-176, Regex-Extraktion von id/paper_ref/axes). Verzeichnis-Scanner
  `load_sota_profiles` (hpp ~Z.187, cpp ~Z.100-107; iteriert `*.profile.xml` → parse_profile).
- **P08 Organ**: `libs/cache_engine/axes/concurrency_axis/axis_08_concurrency_olc.hpp` (`struct OlcOptimisticConcurrency`).
  Metadaten aus `docs/architecture/18_achsen_algorithmus_paper_code_map.md:66` (OLC, DaMoN 2016 + DEBULL 2019,
  DOI 10.1145/2933349.2933352, Apache-2.0). Achsen-Token für concurrency: aus rcu.profile.xml (`<concurrency>RCU`)
  ableiten — für OLC den Token wählen, den das concurrency-Enum/Geschwister verwenden (prüfe existierende Profile
  + `axis_08`-Organ-Name; wenn kein OLC-Token in einem Profil existiert, nimm `OLC` und setze einen Kommentar).
- **P09 Organ**: `libs/cache_engine/axes/layout/axis_05_memory_layout_packed_bitmap.hpp` (`struct
  PackedBitmapMemoryLayout`). Metadaten aus `18_…map.md:127` (Jacobson LOUDS, FOCS 1989, DOI
  10.1109/SFCS.1989.63533). Layout-Token: aus einem Profil ableiten, das `<layout>` ≠ CACHE_LINE_ALIGNED nutzt;
  sonst `PACKED_BITMAP` + Kommentar.
- **P33**: Poster `Forschungsarbeiten/hardware/vampir-poster-spp2377-p1-kickoff.pdf` (kein Algorithmus). Metadaten
  (Titel/Autoren/Venue) aus `docs/termine/20260508 Termin 7/_review/papers/P33-VAMPIR-Berthold2023.md` +
  `docs/email/20260508-1800-email_kontakte.md:145-154`. KEINE Organ-Achse (all-baseline) + Annotation.
- **Allokator-Dir/Schema**: `libs/cache_engine/algorithm_profiles/allocators/` (10 vorhanden). Vorlage LIES:
  `allocators/hoard.profile.xml` + `allocators/jemalloc.profile.xml`. Schema: `<comdare_allocator_profile id=".."
  family_ref="Axx">` → `<metadata>`(name/authors/year/venue/license/repo) → `<axes>`(granularity/numa/
  thread_local/fragmentation_strategy/thread_safety) → `<abi>`(`<c_api>` Pflicht [+`<cpp_overload>`]) →
  `<expected_workload>`. Mapping `allocators/README.md:14-27`.
- **Allokator-Metadaten-QUELLE**: `libs/cache_engine/axes/alloc/PAPER_REFERENCES.md §2` (Z.9-36) — je Wrapper
  Algorithmus·Paper·Venue/Jahr·DOI·Lizenz. **A17 Crystalline FEHLT in §2** → Metadaten aus
  `ext/allocator/REPOS_OVERVIEW.md:48` (Penn-State, URL pending); fehlendes ehrlich `unknown`/weglassen.
- **Allokator-Achsen-Werte**: aus den Organ-Headern `libs/cache_engine/axes/alloc/axis_06_allocator_<name>.hpp`
  (buddy/cama/crystalline/hmalloc/numalloc/pim_malloc/pmr_resource/ptmalloc2/slab/starmalloc/tcmalloc_wh/vmem_mag)
  plausibel ableiten; wo unklar → neutraler Default (wie in bestehenden Allokator-XMLs) + Kommentar.
- **13 fehlende A-Nummern ↔ Dateiname (Kurzname wie bestehende)**:
  A02 `slab`, A09 `numalloc`, A12 `cama`, A13 `starmalloc`, A14 `tcmalloc_warehouse`, A15 `hmalloc`,
  A16 `pim_malloc`, A17 `crystalline`, A18 `exgen_malloc`, A19 `buddy`, A21 `ptmalloc2`, A22 `pmr_resource`,
  A23 `vmem_magazines`. (family-Dirs `families/aXX_*` bestätigen die Namen.)
- **Test-Reg**: `tests/unit/CMakeLists.txt` — gtest via `comdare_add_test(<name> SOURCES <file>)` (Beispiel um
  ~Z.791); ODER thesis_tiere-Standalone `add_executable`+`add_test` (Beispiel `test_harness_compile` ~Z.1659-1674).
- **CI-Vorlage**: `.gitlab-ci.yml` Job `contract:harness` (~Z.190-201) — exakt spiegeln (eigener build-Ordner,
  `needs: [lint:secrets]`, `tags:[baremetal]`, `artifacts: paths: []`).

## 5. Soll-Umsetzung
### 5.1 Parser-Erweiterung (zuerst, additiv)
- `AlgorithmProfile`: Feld `std::string pruefling_type;` (default `""`), mit Kommentar `// "" = full / "abstract"
  (AP-6/#240 rev): Prüfling-Marker-Profil (P08/P09/P33), zeigt nur auf Organ-Achse(n) + Host-Fallback`.
- `parse_profile`: das optionale Wurzel-Attribut `pruefling_type="..."` per Regex lesen (analog id/paper_ref),
  fehlt es → `""`. KEINE andere Logik ändern. Auf g++-Portabilität achten (nötige Includes, keine neuen Warnings).
### 5.2 Die 3 abstrakten SOTA-Profile (`pruefling_type="abstract"` am Wurzelelement)
- `sota/olc.profile.xml`: `id="olc" paper_ref="P08" pruefling_type="abstract"`; metadata OLC (§4-Quelle);
  `<axes>` = Baseline eines Geschwister-Profils, ABER `<concurrency>`=OLC-Token; `<key_value_signature>` u64/u64;
  `<expected_workload>` passend (z.B. YCSB_B wie rcu). XML-Kommentar: „abstrakter Prüfling-Marker → axis_08
  OlcOptimisticConcurrency (Code vorhanden); Original-Paper DaMoN2016/DEBULL2019".
- `sota/louds.profile.xml`: `id="louds" paper_ref="P09" pruefling_type="abstract"`; metadata Jacobson LOUDS;
  `<axes>` Baseline, aber `<layout>`=PACKED_BITMAP-Token; Kommentar „→ axis_05 PackedBitmapMemoryLayout".
- `sota/vampir.profile.xml`: `id="vampir" paper_ref="P33" pruefling_type="abstract"`; metadata VAMPIR/SPP2377
  (§4-Quelle, KEINE erfundenen Felder); `<axes>` = reine Baseline (kein auflösbares Organ); prominenter
  XML-Kommentar: „SPP2377-Kickoff-Poster ohne Algorithmus/Pseudocode → kein haargenauer Nachbau möglich;
  abstrakter NFP-Konzept-Marker (Non-Functional Memory Properties)".
### 5.3 Die 13 Allokator-XMLs
- Je fehlendem Allokator eine `allocators/<name>.profile.xml` im §4-Schema; Metadaten aus PAPER_REFERENCES §2
  (A17 aus REPOS_OVERVIEW, Rest ehrlich unknown); `<axes>` aus dem `axis_06_allocator_<name>.hpp`-Header
  ableiten; `<abi><c_api>…` (Pflicht); `<expected_workload>` YCSB_* wie bestehende. Je Datei ein Kommentar mit
  der Metadaten-Quelle (Datei:Zeile).
### 5.4 Coverage-Gate `tests/unit/thesis_tiere/test_profile_coverage.cpp`
- Rein-lesend, kein DLL-Bau. Verzeichnis-Pfad via CMake-Compile-Define (z.B. `COMDARE_ALGORITHM_PROFILES_DIR`
  auf `${CMAKE_SOURCE_DIR}/libs/cache_engine/algorithm_profiles`, konfigurationszeit-absolut) — CWD-robust in
  CI + lokal. Nutze den bestehenden Parser (`load_sota_profiles`) ODER ein einfaches Attribut-Auslesen der
  `*.profile.xml`.
- **SOTA**: scanne `sota/` → Menge der `paper_ref`; ASSERT {P01..P33} vollständig (33/33). Bei Lücke → FAIL mit
  Liste der fehlenden. Optional: zähle `pruefling_type="abstract"` (erwartet ≥3: P08/P09/P33) + gib Info aus.
- **Allokator**: scanne `allocators/` → Menge der `family_ref`; ASSERT {A01..A23} vollständig (23/23).
- Ausgabe bei OK: „SOTA 33/33 (30 full + 3 abstract: P08/P09/P33) · Allokator 23/23". Exit 0 = PASS.
- Registrierung in `tests/unit/CMakeLists.txt` (gtest `comdare_add_test` bevorzugt, damit CI es baut).
### 5.5 CI-Job
- `contract:profile_coverage` in `.gitlab-ci.yml`, exakt nach dem Muster `contract:harness`: eigener build-Ordner,
  `cmake -B build-cov … -DCOMDARE_BUILD_TESTS=ON`, `cmake --build … --target test_profile_coverage`,
  `ctest --test-dir build-cov -R '^test_profile_coverage$' --output-on-failure -V`, `needs:[lint:secrets]`,
  `tags:[baremetal]`, `artifacts: paths: []`.

## 6. Verifikation (PFLICHT — Codex, literal)
- Baue+starte das Coverage-Gate lokal (cl/cmake oder wie die thesis_tiere-Tests) → literal `[ PASSED ]` +
  „SOTA 33/33" + „Allokator 23/23".
- Baue die Parser-Lib (das Target, das `xml_config_parser.cpp` enthält, z.B. `test_experiment_driver_v13` ODER
  ein Contract-Target) → beweist, dass die additive Parser-Änderung kompiliert (idealerweise auch einen der
  bestehenden Parser-Tests laufen lassen → grün, keine Regression).
- `git status --short` zeigt NUR die erlaubten Dateien (§3.4) als neu/modifiziert. KEIN Commit.

## 7. Ausgabe an Claude (strukturiert)
(a) Liste der 3 SOTA- + 13 Allokator-XMLs (je paper_ref/family_ref + Metadaten-Quelle Datei:Zeile);
(b) Bestätigung KEINE Fabrikation (jede Metadatenzeile quellenbelegt; P33 ohne erfundenen Algorithmus;
    A17/unklare Felder ehrlich unknown/weggelassen);
(c) Parser-Diff (Struct-Feld + parse_profile-Regex) + Bestätigung ABI-Neutralität;
(d) Coverage-Gate-Logik + **literales PASSED** (33/33 + 23/23) + Compile-Beweis der Parser-Änderung;
(e) exakte Achsen-Token, die du für OLC/PACKED_BITMAP gewählt hast, + woher (Datei:Zeile) — falls geraten
    werden musste, EXPLIZIT markieren;
(f) etwaige STOPP-Punkte/Unklarheiten (nichts geraten).
