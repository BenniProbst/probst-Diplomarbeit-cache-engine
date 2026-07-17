# BAUPLAN-DOSSIER — Bau-INC-2c.opt-f: XML-Schema + Parser für die opt_level-Unter-Achse

> **Status:** Design-Vorlage zur Freigabe (2026-07-17, decision-unabhängig von OF-2-KERN + opt-d/Layering). Grounded am IST-Code; jede Zeile `datei:zeile`. **Baut nichts ohne EXPLIZITE User-Phasen-Freigabe.** opt-f ist „der genuine Neubau" der opt-Arc: er hebt den `opt_level` von der env-piloten opt-c-Fassade (`COMDARE_PILOT_OPT_LEVEL`) auf die **XML-Definition** (super=Definition) + den **Parser** (ce=Framework).

## 1. ZWECK
opt-c machte `opt_level` env-permutierbar (Smoke). opt-f macht die **XML zur Quelle** (OF-2 „per XML überschreibbar"): das Experiment-XML deklariert die zu permutierenden Optimierungsstufen; der Parser liest sie (roh); der Planer (opt-g) permutiert sie. Bis opt-g bleibt der Wert inert (nur geparst, nicht getrieben) → golden==320 unberührt, byte-neutral.

## 2. IST (verifiziert, `datei:zeile`)
- **XSD** `Code/test_data_xml/experiment_schema.xsd:22-34` — Root `comdare_experiment` = Sequence {metadata, execution_engines, lebewesen, phases, axes_default_lookup?, workloads, datasets, measurement_categories, op_types, output}. **KEIN `<system_axes>`/`<compiler>`** heute.
- **golden.xml (2 Kopien, fixture-sync-gated):** `Code/test_data_xml/experiment_golden.xml` (super=Definition) + `Code/external/comdare-cache-engine/tests/unit/thesis_tiere/experiment_golden.xml` (ce-Test-Fixture). Beide spiegeln die XSD-Struktur; **KEIN system_axes-Tag** heute.
- **Parser** `libs/common/serialization/xml_config_parser/xml_config_parser.hpp` — `ExperimentProfile` mit `cache_engine_permutations`/`search_algorithm_permutations`/`allocator_permutations`/`test_data_sets`/`sota_profiles` (`PermutationEntry`-Vektoren, roh-String-Attribute). **LAYERING-TREU: `libs/common` referenziert NIE `cache_engine`** (nur std-Strings).
- **Enum-/Gültigkeits-Auflösung** gehört in `validate_profile.hpp` (ce, DARF `cache_engine`/`OptO*SubAxis` referenzieren) — NICHT in den common-Parser.
- **fixture-sync:** `tests/unit/thesis_tiere/` prüft, dass die 2 golden.xml byte-/struktur-gleich sind (Drift-Gate).
- **Sub-Achse (opt-a/c):** `OptO0..OfastSubAxis::opt_level_id()` = "O0".."Ofast" (die allowed-value-Enumeration).

## 3. SOLL — Mini-Schritte (additiv, golden-neutral, layering-treu)
- **f1 (XSD):** neuer `<xs:complexType name="SystemAxesType">` mit `<compiler>` → `<opt_level>` als allowed-value-Liste (xs:enumeration O0/O1/O2/O3/Ofast, mirror der `opt_level_id()`). Neues Element `<xs:element name="system_axes" type="SystemAxesType" minOccurs="0"/>` **optional** in die Root-Sequence (`:24-34`) einfügen → **bestehende XMLs ohne system_axes validieren weiter** (additiv). (OF-3: `<flags>`/`<commands>` als parallele Sub-Elemente vorsehen, aber erst später befüllen — flags+cflags zuerst, commands danach.)
- **f2 (golden.xml ×2):** in BEIDE Kopien identisch ein `<system_axes><compiler><opt_level>O2</opt_level></compiler></system_axes>` (golden-Anker O2, konsistent zur opt-c-golden-sicheren Default-Wahl) einfügen. **fixture-sync bleibt grün** (beide gleich).
- **f3 (Parser):** `ExperimentProfile` um `std::string system_opt_level` (oder `std::vector<std::string> system_opt_levels` für Ranges) erweitern + Parse-Logik (roh-String, KEIN cache_engine-Include). Layering-Guard hält (`libs/common`).
- **f4 (validate_profile.hpp):** die roh-Strings gegen `OptO*SubAxis::opt_level_id()` validieren (Enum-Auflösung ce-seitig); unbekannter Wert → Fehlerklasse `KonfigXmlParse` (INC-29.0, geloggt, kein Absturz).
- **f5 (inert bis opt-g):** der geparste Wert wird NOCH NICHT an den Planer/CompileFn getrieben (das ist opt-g) → Verhalten byte-identisch, golden==320.

## 4. VERIFIKATION (literal)
- `xmllint --schema experiment_schema.xsd experiment_golden.xml` (beide Kopien) == valid.
- `test_fixture_sync_experiment_golden` grün (2 golden.xml in sync).
- Parse-Round-Trip-Test: XML mit `<system_axes><compiler><opt_level>O3` → `ExperimentProfile.system_opt_level=="O3"`; ohne system_axes → Default/leer (kein Bruch).
- Kadenz: ctest CI-äquiv + golden-Roundtrip==320 (unberührt, opt binary_id-neutral) + cf22=0 + Mojibake=0 + super-Sub-Build + beide Remotes + CI hart-grün.

## 5. TABU / Risiken
- **golden_fullpilot_320 / binary_id UNBERÜHRT** — opt ist binary_id-neutral (nur experiment_golden.xml, NICHT die 320-id-Liste).
- **Layering:** Parser in `libs/common` bleibt cache_engine-frei (roh-Strings); Enum-Auflösung NUR in `validate_profile.hpp` (ce). Kein `libs/common → cache_engine`.
- **fixture-sync-Falle:** BEIDE golden.xml identisch ändern (sonst Drift-Gate rot).
- **Additiv:** `system_axes` `minOccurs=0` → kein Bruch bestehender XMLs / kein v32-Schema-Wiederbelebung (`messreihe_v32_parser` bleibt deprecated-orphan).
- **Inert bis opt-g:** kein Treiben des Werts in f-Schritten → golden-neutral; die Permutation kommt opt-g (dann golden-Regenerierungs-Checkpoint messdaten-erhaltend).

## 6. OFFENE FRAGE (zur Vorlage, nicht eigenmächtig)
- **OF-f-1 (Wertform):** `<opt_level>` als EIN Wert (`O2`) oder als Liste/Range (`<opt_level>O2</opt_level><opt_level>O3</opt_level>`, für Permutation)? Empfehlung: von Anfang **Liste** (`maxOccurs="unbounded"`) → der Planer (opt-g) permutiert direkt; Default 1 Wert = O2 (golden-Anker). Hängt leicht an der OF-2-KERN-Default-Entscheidung (welcher Wert im golden-Lauf permutiert wird).
