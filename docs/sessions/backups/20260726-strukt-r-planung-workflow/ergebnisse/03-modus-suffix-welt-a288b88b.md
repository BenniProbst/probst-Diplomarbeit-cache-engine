KARTIERUNG MODUS- + SUFFIX-WELT + IDENTITAETS-HALBORDNUNG. NICHTS geaendert (nur Read/grep/sed/find). Session-Doc `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md` komplett gelesen (119 Zeilen).

CE-Wurzel unten "CE/" = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine`. Stand: `COMDARE_ANATOMY_ABI_MAJOR=6`, `kCebContractCodegenMinor=0` -> `+ceb=6.0`.

---

# (1) MODUS-WELT

## 1.1 Ist-Anatomie der Registry (EINE Datei, header-only, constexpr)

`CE/libs/cache_engine/include/cache_engine/measurement/run_methodology_registry.hpp` (137 Zeilen)

| Element | Zeile | Inhalt |
|---|---|---|
| `enum class RunMethodology : uint8_t` | :27-31 | `Debug, Measure, Release` — GENAU 3 |
| `kRunMethodologyCount = 3` | :34 | Anzahl-Anker ("Drift einer 4. Methode bricht hier compile-time") |
| `struct RunMethodologyInfo` | :36-54 | 6 Felder: `methodology, id, name, cmake_build_type, measurement_on, single_thread` |
| `kRunMethodologyRegistry` | :60-64 | `{Debug,"debug","Debug","Debug",true,false}` / `{Measure,"measure","Measure","Release",true,true}` / `{Release,"release","Release","Release",false,false}` |
| `run_methodology_registry_is_complete()` consteval | :67-75 | Index==Enum, id/name/cmake_build_type nie leer |
| static_assert Groesse+Vollstaendigkeit | :77-80 | |
| static_assert **Namen-Anker** | :82-86 | haelt `{debug,measure,release}` LITERAL |
| static_assert Build-Semantik-Anker measure | :90-94 | `{Release, misst, 1-Thread}` |
| static_assert Build-Semantik-Anker debug | :95-99 | `{Debug, misst, parallel}` |
| static_assert Build-Semantik-Anker release | :100-104 | `{Release, misst NICHT, parallel}` |
| `run_methodology_info(m)` | :107-109 | Index-Lookup |
| `run_methodology_for_ids(ids)` | :115-127 | **exactly-one HART**: `ids.size()>1` -> `throw std::invalid_argument`; leer/unbekannt -> measure-Default |
| `for_each_run_methodology` | :130-135 | `index_sequence`-Fold (Metaprog-Interface) |

**COMPARE existiert NICHT als Modus.** Belege:
- `Code/test_data_xml/experiment_schema.xsd:60-61` (Kommentar): *"Der vierte Methoden-Wert 'compare' (Replay-Sichten-Vergleich) ist die Reserve fuer #47 - in #48 KEIN Registry-Eintrag, nur diese Kommentar-Reserve."*
- `CE/libs/cache_engine/builder/commands/compare_engine_command.hpp:10` `@phase_owner CEB (Phase 7 COMPARE)` — das ist die F15-Command-Rolle (EE-A CacheEngine vs EE-B PrtArt, Welch-t), NICHT eine Ablauf-Methodik. Keine Verbindung zur Registry.
- `grep -rn "COMPARE|kCompare|\"compare\"" libs/ tools/ apps/ tests/` -> 0 Treffer im Modus-Sinn.

Folge: der Owner-KERN "**FUENFTE Modus CUSTOM_COMPILE**" impliziert, dass COMPARE als 4. Modus mit-eingebaut werden muss (heute nur XSD-Kommentar-Reserve), sonst ist CUSTOM_COMPILE der 4.

## 1.2 exactly-one-Validator-Pfade (Hinweis: die im Auftrag genannte Stelle `validate_profile:321-334` ist tatsaechlich der `<datasets>`-id-Check; die Modus-Gates liegen anders)

| Pfad | Ort | Wirkung |
|---|---|---|
| Registry-id-Check (generisch) | `CE/libs/cache_engine/profile_facade/validate_profile.hpp:160-174` `check_measurement_sub_axis` | Single-Source gegen `kRunMethodologyRegistry`; unbekannter Token -> `ok=false` |
| **tp-Kanal exactly-one** | `validate_profile.hpp:475-485` | `check_measurement_sub_axis(tp.run_methodology, ...)` + `if (tp.run_methodology.size() > 1) ok=false` |
| **ep-Kanal exactly-one** | `validate_profile.hpp:1214-1223` | deckungsgleich fuer `ep.run_methodology` |
| Report-Zeile | `validate_profile.hpp:529` | `", N run_methodology"` nur wenn `>0` (Byte-Gate) |
| Laufzeit-Backstop 1 | `run_methodology_registry.hpp:119-122` | `throw` bei `>1` |
| Laufzeit-Backstop 2 | `CE/libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:1669-1672` | `throw` in `build_semantic_of_run_methodology` |
| METHODIK-Profil-Selektor | `CE/libs/cache_engine/profile_facade/profile_run_facade.cpp:78-83` | exactly-one HART auf dem Override-Profil (`COMDARE_METHODIK_PROFILE`-Klasse) |
| Pre-Flight-Gate vor jedem Bau | `profile_run_facade.cpp:408-417` (tp), analog ep-Pfad | Validat-rc != 0 -> Abbruch VOR Bau/Messen |

Tests, die die 3er-Menge/exactly-one literal festnageln: `CE/tests/unit/thesis_tiere/test_validate_profile.cpp:393-430` (`{debug,measure}` = Fehler; `"profiling"` = Fehler, Meldungstext `{debug,measure,release}`), `CE/tests/unit/thesis_tiere/test_experiment_parser.cpp:664-713`, `CE/tests/unit/thesis_tiere/test_experiment_plan_director.cpp:1954-1955`.

## 1.3 XSD-/Schema-Stellen

| Ort | Zeile | Befund |
|---|---|---|
| `Code/test_data_xml/experiment_schema.xsd` | :62 | `<xs:element name="run_methodology" type="RunMethodologyType" minOccurs="0"/>` |
| dito | :52-61 | Doktrin-Kommentar: XSD ist **nur strukturell**, Single-Source im Code; enthaelt die `compare`-Reserve-Notiz |
| `RunMethodologyType` | :191-199 | `<method value="xs:string" use="required">`, `minOccurs=0 maxOccurs=unbounded` — **`xs:string`, KEINE Enumeration** |
| `messreihe_v32_schema.xsd` | — | 0 Treffer (kein Modus-Bezug) |

**Kosten-Konsequenz:** die XSD kostet fuer einen 5. Modus **NULL** (offener `xs:string`, unbounded). Der Parser (`CE/libs/common/serialization/xml_config_parser/xml_config_parser.cpp:393-395` tp, `:494-496` ep) pusht Token roh und prueft nichts -> ebenfalls NULL.

## 1.4 Emissions-/Driver-Pfade, die auf den Modus verzweigen

Der Modus reist als `PlanBuildSemantic{cmake_build_type, measurement_on, single_thread}` (`experiment_plan_director.hpp:108-111`), erzeugt in `build_semantic_of_run_methodology` (`:1661-1682`), gesetzt in `construct(tp,...)` (`:1561`, `:1582-1584`) und `construct(ep,...)` (`:1605`, `:1623-1625`), in den Plan-Header gelegt (`:1770`, `:1779`).

**Alle Emissions-Verzweigungen pruefen ausschliesslich `cmake_build_type == "Debug"` — nie die Methodik-id:**

| Naht | Ort | verzweigt auf |
|---|---|---|
| CI Build-Batch: `COMDARE_BUILD_TYPE`-Env | `experiment_plan_director.hpp:955` | `=="Debug"` |
| CI Build-Batch: `-DCMAKE_BUILD_TYPE=` | `:979-980` | Wert direkt |
| CI Mess-Batch: `COMDARE_BUILD_TYPE`-Env | `:1079` | `=="Debug"` |
| CI Mess-Batch: `-DCMAKE_BUILD_TYPE=` | `:1108-1109` | Wert direkt |
| **(j3) Dual-Compile CI** (Release-provision-only + Debug-Bau/Mess) | `:1156` ff. | `=="Debug"` |
| CMake-Batch-Targets: `COMDARE_BUILD_TYPE` / `COMDARE_ARTEFAKT_TRIES=1` | `:1406-1409` | `=="Debug"` |
| **(j3) Dual-Compile CMake** | `:1481` ff. | `=="Debug"` |
| Kommentar-Anker "(j2) statisch aus dem Profil, KEIN Env-Schalter" | `:1321` | — |

**Zweite, unabhaengige Modus-Naht (liest die Methodik direkt, nicht `PlanBuildSemantic`):**
- `CE/libs/cache_engine/builder/experiment_tree/measure_parallelism.hpp:23-41` `resolve_measure_parallelism`: `if (!m.measurement_on || m.single_thread) return 0;` -> das ist der **EINZIGE** Konsument von `measurement_on` im Repo (verifiziert: `grep -rn measurement_on` -> nur Registry, POD-Deklaration, dieser Ausdruck).
- Aufrufer: `CE/libs/cache_engine/profile_facade/profile_run_entry.hpp:470-476` (tp, mit METHODIK-Override `a.methodik_run_methodology`), `CE/libs/cache_engine/profile_facade/experiment_run_entry.hpp:361-363` (ep). Konsum in `cache_engine_builder_iterator.hpp:204`.

**Deklariert modus-NEUTRAL (Section 43-Invariante):** `CE/libs/cache_engine/include/cache_engine/abi/anatomy_version_stamp.hpp:89` und `anatomy_module_abi_v1_decl.hpp:154` — die Ablaufmethodik geht NIE in den Achsen-Versions-Stempel/die binary_id.

## 1.5 Was kostet ein 5. Modus CUSTOM_COMPILE?

**BILLIG (mechanisch, ~1 Datei + 2 Test-Dateien):**
1. `run_methodology_registry.hpp`: Enum-Wert (:27-31), `kRunMethodologyCount 3 -> 4/5` (:34), Registry-Zeile (:60-64), **neuer Namen-Anker-static_assert** (:82-86 erweitern), **neuer Build-Semantik-Anker** (Muster :90-104). `run_methodology_for_ids` (:115-127), `for_each_run_methodology` (:130-135), `validate_profile` (:475/:1214), Parser, XSD: **NULL Aenderung** (alle registry-getrieben bzw. offen).
2. Test-Meldungstexte `{debug,measure,release}` in `test_validate_profile.cpp:418-430` / `test_experiment_parser.cpp:703-713` sind Kommentare; die Assertions pruefen nur "Fehler enthaelt 'run_methodology'" -> bleiben gruen. `preview_values(...)`-Ausgabe waechst (kein Test bindet sie literal).

**TEUER (die eigentliche Kosten-Stelle) — es gibt heute KEINE "Mess-Pflicht"-Schiene zum Abschalten:**
- `measurement_on` gatet **nicht**, OB gemessen wird, sondern nur die Mess-Parallelitaet (`measure_parallelism.hpp:25`). Beleg: `release` traegt `measurement_on=false`, und trotzdem emittiert der Director fuer `release` einen vollen `measure`-Batch-Job (`:1070` ff.) — es existiert keine Verzweigung, die den Mess-Job weglaesst.
- Die faktische "bauen ohne messen"-Schiene ist **env-getrieben und ausserhalb der Registry**: `provision_only` (`profile_run_facade.hpp:56-60`, `profile_run_entry.hpp:125-135`, `:373`, `:462`, `:788`; Env `COMDARE_GOLDEN_N_PROVISION_ONLY`) und `pruef_only` (`profile_run_facade.hpp:61-63`, Env `COMDARE_PRUEF_ONLY`, §62-B S3). Beide sind gegenseitig ausschliessend, beide **nicht** aus dem Profil-XML typisiert.
- CUSTOM_COMPILE = die XML-/Registry-Typisierung genau dieser Schiene. Aufwand:
  - `PlanBuildSemantic` braucht ein **4. Feld** (z.B. `emits_measure_job`), sonst kann der Director den Mess-Job nicht auslassen -> 5 Emissions-Nahtstellen (`:1070-1119` Job-Kopf/Rules/needs, `:1475` ff. CMake-Target) muessen erstmals modus-abhaengig **entfallen** statt nur `Debug`/`Release` zu tauschen. Das ist die einzige echte Struktur-Aenderung.
  - `profile_run_facade.cpp:552-553` muesste `provision_only`/`pruef_only` **auch** aus der Methodik speisen duerfen (heute nur `args.*` aus Env). Ohne das bleibt CUSTOM_COMPILE ein Etikett ohne Vollzug.
  - Planer-CLI (§60-R3): `Code/02_messung_driver/main.cpp:315-470` — die Pre-Flight-Flags (`--validate/--dump-plan/--dump-ci/--dump-cmake/--emit-tier-ci/--emit-tier-cmake/--print-cache-key/--version`) sind der vorhandene CLI-Rahmen; ein `--custom-compile`/Modus-Flag docket hier an, muss aber durch die **Lane-Fehlrouting-Wache** `main.cpp:473` hindurch.
- **Semantik-Konflikt, der eine Owner-Entscheidung braucht:** `cmake_build_type` darf laut Registry-Vollstaendigkeits-consteval (`:72`) **nie leer** sein. CUSTOM_COMPILE ist aber gerade der Modus, dessen Build-Typ der Anwender frei setzt. -> entweder Sentinel-Wert (`"Custom"`, dann muss `:955/:1079/:1156/:1406/:1481` ihn wie Release behandeln) oder `cmake_build_type` wird optional und der consteval-Anker weicht auf.

**Fazit (1):** mechanisch ~30 Zeilen in 1 Header. Architektonisch: der 5. Modus ist der **erste** Modus, der eine Verzweigung braucht, die es noch nicht gibt (Mess-Job-Entfall). `measurement_on` ist der halb-fertige Traeger dafuer.

---

# (2) SUFFIX-WELT im Licht der NEUEN bindenden Sortierung

## 2.1 Ist-Stand (verifiziert, Zeilen live)

**FORM P** (perm-loop, 4 Kopien): `<base> +cxx=<tag> +opt=<opt> [+ext=<simd> nur wenn != no_extension] [+bt=Debug]`
- P1 `CE/libs/cache_engine/profile_facade/profile_run_entry.hpp:754-757` (-> `:758` `.version`-Sidecar, `:759` CSV-Spalte)
- P2 `CE/libs/cache_engine/profile_facade/experiment_run_entry.hpp:293-297` (byte-gleiche Zweitkopie, ep)
- P3 `CE/libs/cache_engine/profile_facade/profile_run_facade.cpp:951-953` (`--print-cache-key`, env-getrieben)
- P4 `.gitlab-ci.yml:877-880` (bash `GN_PREFIX`; weicht ab: KEIN `+bt`, `+cxx` aus `COMDARE_GN_COMPILER_TAG`)
- Planer-Legenden-Variante ohne `+cxx`: `experiment_plan_director.hpp:1795-1796` (`"+opt="+opt [+"+ext="+simd]`)

**FORM S** `system_axes_version_suffix` (`profile_run_facade.cpp:364-400`): `+ext=<simd IMMER> +cxx= +opt=` (:371-373), `+ceb=` (:378-379), `[+target=]` (:382-384), `[+tel=silent]` (:390-395), `[+bt=Debug]` (:398). Angewendet `:538` (Einzel-Pfad) und `:965` (`--version`).

**Key-Montage** `CE/libs/cache_engine/builder/artifact_transport/artifact_cache.hpp:214-218`: `build_version + "+ceb=M.m" + "+mtool=" + combo + "+mrg=none"`.

**Live-Ist:** 320 lokale `perm.dll.version` (`Code/build/...`), alle Form S: `m3v2+ext=no_extension+cxx=g++-16+opt=O3+ceb=6.0` (verifiziert per `cat`).
**Kein `+atomic128`-Segment existiert** (verifiziert): `atomic128` flieht in die Compile-Flags (`profile_run_facade.cpp:248`, `:283`, `:289` `-mcx16`) und in `validate_profile.hpp:416-430`/`:963-976`, aber in **KEINE** build_version/keinen Key. -> latente Key-Kollision `no_cx16` vs `cx16` (dieselbe F5-Klasse wie `+ext`-Asymmetrie).
**Kein `+os`-Segment, kein `+sched`-Segment** (verifiziert: `grep -rn "operating_system|os_version|update_zustand|persistence_target"` -> **0 Treffer im gesamten Code/**).
**Deklarierte Zukunfts-Pflicht:** `.gitlab-ci.yml:881-883` — *"Bei >1 Messsystem MUSS GN_MSYS in die Binary-Identitaet (GN_PREFIX/build_version) einfliessen"*.

## 2.2 Segment-Reihenfolge nach der NEUEN bindenden Sortierung

Owner-Kette (§1 Session-Doc): (1) MESS-TOOLING -> (2) target_isa -> (3) operating_system -> (4) extension_hardware -> (5) ORGAN.
R-B: `scheduling` = Unter-Achse von `target_isa`. R-D: `compiler+opt_level+atomic128` = Unter-Achsen-GRUPPE der Komplex-Haupt-Achse `target_isa x ext_hw x MetaMetas`. R-C: `load_framework` = 1. Meta-Meta (hinter allem, vor dem variadischen HW-Meta-Meta-Array).

Daraus folgt fuer `build_version_suffix()` (System-Achsen-Teil, Organ bleibt binary_id):

```
+target=<isa>              (2) target_isa           weglassbar wenn == x86_64
  [+sched=<...>]           (2.x) scheduling         Unter-Achse von target_isa  -- HEUTE NICHT EXISTENT
+os=<...>                  (3) operating_system     NEU, weglassbar wenn nicht deklariert
  [+osv= +kern= +bld= +upd=]  (3.x) Unter-Achsen    NEU
+ext=<simd>                (4) extension_hardware   weglassbar wenn == no_extension
+cxx=<tag> +opt=<lvl> [+a128=<...>]   (R-D Unter-Achsen-GRUPPE, untrennbar, in dieser Folge
                                       weil compiler die Handles fuer opt/atomic128 stellt)
[+lf=<framework>]          (R-C) load_framework = 1. Meta-Meta
[+tel=silent]              (Rest-System, Registry-gegated)
[+bt=Debug]                Build-Typ-Stempel
+ceb=<MAJOR>.<minor>       LETZTES Segment der Suffix-Funktion  (W-13-R1-Invariante)
--- ab hier cache_key_prefix, NICHT build_version ---
+mtool=<combo>             (1) MESS-TOOLING
+mrg=none                  Merge-Stempel-Reserve (#37/K6a)
```

## 2.3 KONFLIKT-ANALYSE

**K-1 — Scheinkonflikt "Tooling ist (1), steht aber HINTEN". AUFGELOEST, kein Verstoss.**
Die neue Sortierung (§1) ordnet den **Verzeichnisbaum**. Der Suffix/Cache-Key ist der **Binaries**-Realm, und dafuer sagt der Owner in §4 selbst: *"Binaries-Lager: Wurzel = SYSTEM-Achse direkt; Mess-Achsen-Typ folgt (nicht ganz intuitiv) HINTER System- und Organ-Achse als LETZTER/tiefster Haupt-Achsen-Typ."* -> `+mtool` **muss** hinten stehen. Die W-13-Positions-Invariante (`+ceb` letztes Segment der Suffix-Funktion, `+mtool/+mrg` danach in `cache_key_prefix`) ist damit **konform zur neuen Sortierung**, nicht im Widerspruch. Der Messdaten-Baum (§4 erster Punkt, Tooling x load_framework als Wurzel) ist ein **anderer** Baum und beruehrt den Suffix nicht.

**K-2 — HARTER Konflikt: `+ext` VOR `+cxx/+opt` invalidiert bestehende Form-P-Remote-Objekte.**
Heute Form P: `...+cxx=g++-16+opt=O3+ext=avx2+ceb=6.0+mtool=+mrg=none`.
Neue Ordnung: `...+ext=avx2+cxx=g++-16+opt=O3+ceb=6.0+mtool=+mrg=none`. **Anderer String -> anderer Objekt-Key.**
Betroffene Menge ist NICHT leer, sondern genau die golden-Reihe:
- `all_axes_golden.profile.xml:178-191` deklariert `<system_axes>` mit `simd = {no_extension, avx2}` -> Form-P-Pfad (`profile_run_facade.cpp:444-445`, `:505`).
- CI-Matrix `.gitlab-ci.yml:1048/1053/1073` faehrt `GN_SIMD` in `{no_extension, avx2, avx512}` x `GN_OPT {O2,O3}`.
- -> im Bucket liegen Form-P-Chunk-DLLs + `_gn_chunk_markers` (`.gitlab-ci.yml:1032`) mit `+ext=avx2` / `+ext=avx512` **vor** `+cxx/+opt`. Diese werden durch die Umsortierung **verwaist**.
- Die `no_extension`-Zellen (`+ext` weggelassen) bleiben byte-identisch — genau die Haelfte der Matrix bricht.

**Bewertung:** Bau-Artefakte, keine Messdaten -> Messdaten-Doktrin unberuehrt; additiv liegen lassen, nie loeschen (kein Remote-Loesch-GO erforderlich). Kosten = ein einmaliger Neubau der `avx2`/`avx512`-Chunks. Da §7 des Session-Docs STRUKT-R ohnehin ins **offene §66-G2-Bruch-Fenster** legt und die 18. Organ-Achse `persistence_target` die binary_id 17->18 bricht (also **alle** Binaries neu), fallen die Kosten von K-2 mit dem persistence_target-Neubau **zusammen** und sind faktisch NULL zusaetzlich. **Empfehlung: die Umsortierung MUSS im selben Bruch-Fenster wie persistence_target landen, sonst zwei getrennte Voll-Neubauten.**

**K-3 — `+ceb` muss LETZTES Segment der Suffix-Funktion bleiben (W-13-R1). Vereinbar.**
`+ceb` ist ein CEB-Contract-/Framework-Stempel, keine Achse der Sortierung -> die Sortierung sagt nichts ueber seine Position, R1 darf gelten. `+bt` steht in beiden Formen VOR `+ceb` -> bleibt.
**ABER:** heute entsteht `+ceb` **doppelt** unabhaengig (Form S `:378-379` UND `cache_key_prefix:215-216`) -> der belegte Doppel-`+ceb`-Key der 9 Form-S-Profile (W-13/F1). Der Schnitt bleibt derselbe: `+ceb` aus `cache_key_prefix` **entfernen** und in `build_version_suffix()` an letzter Position falten.

**K-4 — Neue Segmente `+target`/`+os` stehen VOR `+ext`. Kein Konflikt fuer bestehende Keys, ABER nur weil sie weglassbar sind.**
`+target` wird heute nur emittiert wenn `!= x86_64` (`:382-384`); im Perm-Pfad **gar nicht** (W-13/F4: `+target`/`+tel` verschwinden in Form P — real bereits ein Bug, `cacheline_study` deklariert `<target_isa>`). `+os` ist neu und muss **weglassbar-bei-Nichtdeklaration** sein, sonst brechen ALLE Keys (auch die `no_extension`-Haelfte). **Auflage: `+os` NUR emittieren, wenn die OS-Achse im Profil deklariert ist** (Muster von `+tel=silent`, Registry-gegated `:390-395`).

**K-5 — `+a128` fehlt heute und muss NEU dazu. Kein Key-Bruch (weglassbar bei Default `no_cx16`), heilt eine latente Kollision.**

**K-6 — `xs:sequence` in der XSD ist ORDER-BINDING und stimmt nicht mit der neuen Sortierung.**
`experiment_schema.xsd:253-366` `SystemAxesType`: Reihenfolge `compiler` -> `extension_hardware` -> `target_isa` (verifiziert). Neue Sortierung will `target_isa` -> `operating_system` -> `extension_hardware` -> `compiler`. Alle bestehenden Profil-XMLs (`all_axes_golden.profile.xml:178-191`: `<compiler>` dann `<extension_hardware>`) wuerden bei Umsortierung des `xs:sequence` **schema-invalid**.
**Entschaerfung:** der **Parser ist ordnungs-agnostisch** (`xml_config_parser.cpp:98-117` `parse_system_axes` nutzt `sa.child("<name>")`-Lookups). Optionen: (a) `xs:sequence` -> `xs:all` (alle `maxOccurs=1`, XSD-1.0-konform hier), Doku-Kommentar traegt die Sortierung; (b) `xs:sequence` umsortieren **und** alle 11 Profil-XMLs mit-umsortieren. (a) ist sauberer und bruchfrei.

**K-7 — Der Registry-Generator emittiert die Achsen in hartkodierter Alt-Ordnung.**
`CE/tools/system_axis_registry_gen/main.cpp`: `1) compiler` (:164), `2) extension_hardware` (:215), `3) target_isa` (:244), `4) scheduling` (:258), `5) load_framework` (:284) -> die generierte `system_axis_registry.xml` (`<axis id=` :10/:53/:98/:102/:114) hat exakt diese Alt-Ordnung. Muss auf die neue Sortierung umgestellt werden (inkl. `scheduling` als `sub_axis` unter `target_isa` = R-B, `compiler/opt_level/atomic128` als Gruppe = R-D). Das ist reine Generator-Arbeit, kein Key-Bruch.

**K-8 — Zwei parallele "System-Achsen"-Begriffe. Fallstrick fuer R-A.**
(i) `CebSystemAxis`-Familie = die 5 echten Bau-treibenden Achsen (`compiler_system_axis.hpp`, `extension_hardware_family_axis.hpp:40/:66`, `target_isa_system_axis.hpp:33/:64/:73`, `scheduling_system_axis.hpp:23/:60`, `load_framework_system_axis.hpp:21/:44`).
(ii) `build_system_axis_levels()` = `CE/libs/cache_engine/builder/experiment_tree/registry_to_axis_levels.hpp:113-122` -> `{page_type, simd_extension, general_hardware, telemetry, isa}` (Organ-Registry-Aliase T17/T18/T19/T10/T12), festgenagelt auf **5** durch `CE/tests/unit/test_br1_full22_count.cpp:60-65`.
Eine neue `operating_system`-Achse muss in (i) entstehen; (ii) ist ein anderer Namensraum und darf nicht "auch mal" 6 werden, sonst bricht `test_br1_full22_count`.

## 2.4 Empfohlene Single-Source-Signatur (Fortschreibung des W-13-Schnitts)

Neu: `CE/libs/cache_engine/profile_facade/system_version_suffix.hpp` (header-only, env-frei, nur std) — Nachbar von `build_type_stamp.hpp` (dort `build_type_version_suffix()` :18-24).

```
build_version_suffix(target_isa_id, os_id, simd_id, cxx_tag, opt_id, atomic128_id,
                     load_framework_id, telemetry_silent)
```
Segment-Emission strikt in der Ordnung aus 2.2; jedes Segment **weglassbar bei Default**. Umstellungs-Punkte unveraendert gegenueber dem W-13-Verdikt: P1 `profile_run_entry.hpp:754-757`, P2 `experiment_run_entry.hpp:293-297`, S1 `profile_run_facade.cpp:364-400` (wird duenne Resolver-Huelle), P3 `profile_run_facade.cpp:951-953` (faellt weg), `artifact_cache.hpp:214-218` (verliert `+ceb`), `.gitlab-ci.yml:877-880` (GN_PREFIX als rein lokaler Bau-Pfadname; Fallback `:896` sollte HART fehlschlagen).
Anzupassende Tests: `CE/tests/unit/test_s1_cache_key_prefix.cpp:36,44,53,61,70`, `CE/tests/unit/test_g3_prune.cpp:148,171-173,206`, `CE/tests/unit/test_g1_binary_version_stamp.cpp:64,98`, `CE/tests/unit/test_s2_pull_tier_binary.cpp:94,116,161`, `test_s5_artifact_cache_bounded.cpp:84`, `test_w11_async_push_pump.cpp:57,65,174,232`.
NEUE Wachen: (T-a) Perm-Suffix == Facade-Suffix; (T-b) `count("+ceb=") == 1`; (T-c) Ordnungs-Wache — `+target` vor `+os` vor `+ext` vor `+cxx` vor `+opt` vor `+a128` vor `+bt` vor `+ceb`, und `+mtool/+mrg` NUR in `cache_key_prefix` und NUR hinter `+ceb`.

---

# (3) IDENTITAETS-HALBORDNUNG (Aufwaerts-Kompatibilitaet)

## 3.1 Wo Hardware-Identitaet HEUTE lebt (3 Orte, disjunkte Begriffe)

**(A) Deklarative Maschinen-Signatur (CT, CRTP+Concept).** `CE/libs/cache_engine/include/cache_engine/measurement/machine_simd_signature.hpp`
- `MachineSimdSignature<Derived>` :31-48: `machine_id()` :33, `host_isa()` :34, `signature()` :35-37, **`has_flag(cpuinfo)` :40-44** (die Grundoperation).
- Concept :50-58. 3 Instanzen: `Prod1Zen5Signature` :77-88 (22 Flags, 13 avx512), `Prod2RaptorLakeSignature` :91-98 (9 Flags), `OdroidGracemontSignature` :101-108 (9 Flags).
- Wohlgeformtheit :111-128 (`count_avx512_flags` :61-66, `signature_within_catalog` :69-73).
- Reflektiert in `system_axis_registry.xml` `<machine_signatures count="3">` (generiert von `tools/system_axis_registry_gen/main.cpp:298-315`).

**(B) Das Pruef-Dock (Zulassungs-Logik).** `CE/libs/cache_engine/include/cache_engine/measurement/simd_build_gate.hpp`
- `pruef_dock(organ_required, organ_meaningful, machine_signature, route, dialect)` :102-147 — Zustandsmaschine `Ungeprueft -> {NotApplicable | Freigegeben | Abgelehnt}`, alles constexpr.
- **`admit_organ_on_machine(T, S)` :153-159 — DAS IST BEREITS die Teilmengen-Pruefung "T subset S"**: `for (f : organ_required) if (!span_contains(machine_signature, f)) return HardwareErweiterungFehlt;`
- Effektive Flags = `Signatur ∩ Sinnhaftigkeit ∩ Route` :141-146 (kumulativ) -> `effective_march_flags` :163-170.
- **DIE LUECKE:** `active_machine_signature()` :187 `{ return {}; }` — **Stub, gibt LEER zurueck**; ebenso `active_organ_required()` :185 / `active_organ_meaningful()` :186. Kommentar :181-184 nennt sie explizit "die drei Hooks ... die die per-Organ-/per-Binary-Aktivierung spaeter befuellt".
- Einziger Produktions-Aufrufer: `CE/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp:457-468` — `aggregate_required_for_axes(spec.axes)` -> `admit_organ_on_machine(gate_req, active_machine_signature())`; da beide Seiten leer sind, ist das Gate **inert** (`status=-4` feuert nie).

**(C) §62-D-Schluessel im Bestandslog (RT, Objekt-Store-Identitaet).**
- `LagerKey{Sha512Key key_sha512, ZellKoordinaten zelle}` — `CE/libs/cache_engine/builder/bestandslog/bestandslog_index.hpp:92-120` (`lager_key_from_entry` :105-108, `lager_key_from_hex` :113-116, `LagerIndex = std::map<LagerKey,BestandEintrag>` :120).
- `ZellKoordinaten{combo, opt, simd}` — `CE/libs/cache_engine/builder/bestandslog/bestandslog_document.hpp:147-157`; `BestandEintrag` :159-170 (`stempel` = `"[d,e,f][g,h,i]+bt=Release"`).
- Key-Policies (CT, Concept-Guard statt vtable): `CE/libs/cache_engine/builder/bestandslog/bestandslog_factory.hpp:36-72` — `BestandKeyPolicy` :37-41, `BinaryKeyPolicy` :44-54, **`MesswertKeyPolicy` :59-71** (Doc-Kommentar :56-58: *"der Aufrufer reicht die voll-permutativen Mess-Zeilen + **Hardware-Identitaet** (fixe Reihenfolge)"* — der einzige Ort, an dem "Hardware-Identitaet" als Key-Bestandteil ueberhaupt benannt ist, und zwar als **Aufrufer-Pflicht**, nicht als Typ).
- Befuellung der Zelle: **aus Env, nicht aus der Achsen-Registry** — `CE/libs/cache_engine/profile_facade/profile_run_entry.hpp:331-347`: `combo = COMDARE_MEASUREMENT_COMBO`, `opt = COMDARE_GN_OPT`, `simd = COMDARE_GN_SIMD`; Lauf-Konstante.

## 3.2 Wo die Teil-Identitaets-Pruefung (T subset S) ansetzen MUSS

| # | Naht | Ort | Was zu tun ist |
|---|---|---|---|
| I-1 | **Signatur-Typ generalisieren** | `machine_simd_signature.hpp:31-58` | `MachineSimdSignature` ist SIMD-only (`SimdFeatureFlag`). Fuer R-E (variadisches Meta-Meta-Array: SIMD/GPU/FPGA/NPU) braucht es einen Familien-Typ ueber **Meta-Meta-Auspraegungen**, nicht ueber cpuinfo-Flags. Der CRTP+Concept-Rahmen und `has_flag` :40-44 sind das Vorbild; **kein `std::variant`** (Owner-KERN + `feedback_no_std_variant_static_axes_bloat`) -> variadisches Template-Pack (Muster `for_each_run_methodology` :130-135). |
| I-2 | **Die Halbordnungs-Relation selbst** | `simd_build_gate.hpp:153-159` `admit_organ_on_machine` | Bereits die richtige Form (`T subset S` -> `HardwareErweiterungFehlt`). **Zu verallgemeinern** auf Meta-Meta-Saetze; die Aufwaerts-Kompatibilitaet des Owners = genau `T subset S`, und "GPU ausbauen -> GPU-CPU-Programme gehen nicht" = `T not-subset S`. Basis-Identitaet CPU-only = `T = {}` -> `NotApplicable` (:109-112) -> laeuft immer. **Die Semantik stimmt schon; nur die Domaene fehlt.** |
| I-3 | **Die Stub-Hooks scharfschalten** | `simd_build_gate.hpp:185-187` | `active_machine_signature()` muss die reale Host-/Profil-Wahl liefern statt `{}`. **Das ist die eine Zeile, die die ganze Halbordnung heute inert haelt.** |
| I-4 | **Bau-Delegations-Gate (Durchsetzung)** | `build_orchestrator.hpp:457-468` | Aufrufer existiert und ist korrekt verdrahtet (`status=-4`, `BuildError`, "Log + weiter"). Wird mit I-3 automatisch scharf. **Hier gehoert die Anforderungs-Satz-vs-Maschinen-Satz-Pruefung hin** (per-Binary, VOR der Kompilation). |
| I-5 | **Freigabe-Kopplungs-Naht System->Organ** | `profile_run_entry.hpp:734-752` (`system_axis_host_supports_simd`, `system_axis_march_of`, `perm_compile`) | Der Kommentar :749-750 benennt es selbst: *"Kuenftige System-Consumer-Achsen (NUMA/NPU/GPU/FPGA) + ein constexpr requires_simd()-Bau-Gate (Audit-G7) ... docken GENAU HIER an (State-Pattern durchs Pruef-Dock)"*. Zweite, grobe Wache (Route-Ebene). |
| I-6 | **Objekt-Store-Identitaet** | `bestandslog_document.hpp:147-157`, `bestandslog_factory.hpp:59-71` | `ZellKoordinaten` traegt **nur** `{combo,opt,simd}` — **kein** `target_isa`, **kein** `os`, **kein** `cxx`, **kein** `bt`, **kein** `ceb`, **kein** Meta-Meta-Satz. -> W-13/F6: Bestandslog und Objekt-Store haben verschiedene Identitaetsbegriffe. Der Meta-Meta-Satz (R-E: "feste Bestandteile der Maschinen-Identitaet") **muss** hier hinein, sonst kollidieren eine GPU- und eine CPU-only-Binary derselben Perm auf EINEM `LagerKey`. |
| I-7 | **Suffix/Key-Seite** | 2.2 | Der Meta-Meta-Satz braucht ein weglassbares Segment im Suffix (Position: **innerhalb `+ext=`**, weil R-E `extension_hardware` zum Command-Pattern-HUB der HW-Meta-Metas macht und *"seine Identitaet IST exakt deren Konfiguration"*). Also `+ext=<hub-konfiguration>` statt `+ext=<simd>` — heutiges `+ext=avx2` ist der Ein-Familien-Spezialfall. |
| I-8 | **Registry-Reflexion** | `system_axis_registry.xml` `<machine_signatures>`, `tools/system_axis_registry_gen/main.cpp:298-315,336` | Die 3 Maschinen-Signaturen sind heute reine SIMD-Flag-Listen mit `count="3"` hartkodiert (`:302`, `:336`). Muss den Meta-Meta-Satz je Maschine mit-reflektieren, damit der Planer die Halbordnung ohne Raten aufloesen kann (Registry = ANGEBOT). |

**Wichtige Feststellung zur Halbordnung:** `pruef_dock` prueft `T subset S` **konjunktiv gegen drei** Mengen (Signatur, Sinnhaftigkeit, Route) und liefert bei Freigabe `S ∩ meaningful ∩ route` — also **nicht** `T`, sondern das **Maximum** des Zulaessigen (:141-146). Das ist genau die Owner-Semantik *"Identitaet = valide unter der Basis-Identitaet in Permutation zu allen Hardware-spezifischen Meta-Meta-Achsen; ALLE Teil-Identitaeten mit kleinerer Hardware-Verwendung sind gueltig"*. Die Halbordnung ist im Code **korrekt vorgedacht** und nur (a) SIMD-eng und (b) durch `:187` inert. Es ist kein Neubau, sondern eine Generalisierung + Scharfschaltung.

---

# NAHT-LISTE (kompakt, Datei:Zeile)

**Modus (R-C / CUSTOM_COMPILE)**
```
CE/libs/cache_engine/include/cache_engine/measurement/run_methodology_registry.hpp  :27-31,:34,:36-54,:60-64,:67-75,:77-104,:107-109,:115-127,:130-135
CE/libs/cache_engine/profile_facade/validate_profile.hpp                            :160-174,:475-485,:529,:1214-1223
CE/libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp            :108-111,:955,:979-980,:1079,:1108-1109,:1156,:1321,:1406-1409,:1481,:1561,:1582-1584,:1605,:1623-1625,:1661-1682,:1770,:1779
CE/libs/cache_engine/builder/experiment_tree/measure_parallelism.hpp                :23-41
CE/libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp      :204
CE/libs/cache_engine/profile_facade/profile_run_entry.hpp                           :92-96,:470-476
CE/libs/cache_engine/profile_facade/experiment_run_entry.hpp                        :361-363
CE/libs/cache_engine/profile_facade/profile_run_facade.cpp                          :55-83,:408-417,:483,:552-553,:697,:712,:725
CE/libs/common/serialization/xml_config_parser/xml_config_parser.cpp                :98-117,:393-395,:494-496
Code/test_data_xml/experiment_schema.xsd                                            :52-64,:191-199,:253-366
Code/02_messung_driver/main.cpp                                                     :315-470,:473
CE/libs/cache_engine/include/cache_engine/abi/anatomy_version_stamp.hpp             :89   (Modus NIE im Stempel)
CE/libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp        :154,:266-272
Tests: CE/tests/unit/thesis_tiere/test_validate_profile.cpp:365-430,:474-479
       CE/tests/unit/thesis_tiere/test_experiment_parser.cpp:656-756
       CE/tests/unit/thesis_tiere/test_experiment_plan_director.cpp:1954-1955
```

**Suffix (W-13 + neue Sortierung)**
```
CE/libs/cache_engine/profile_facade/profile_run_entry.hpp                :754-757 (P1) ->:758,:759
CE/libs/cache_engine/profile_facade/experiment_run_entry.hpp             :293-297 (P2)
CE/libs/cache_engine/profile_facade/profile_run_facade.cpp               :364-400 (S1: :371-373,:378-379,:382-384,:390-395,:398), :444-445,:505,:538,:951-953 (P3),:965
CE/libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp :146-147,:1795-1796 (Legenden-Variante ohne +cxx)
CE/libs/cache_engine/profile_facade/build_type_stamp.hpp                 :18-24 (+bt)
CE/libs/cache_engine/builder/artifact_transport/artifact_cache.hpp       :198-218 (cache_key_prefix),:228-263 push,:266-308 pull,:316-338 pull_prefix,:358-364 prune_key_base,:373-411 verify_then_prune,:423-430 marker
CE/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp   :250-274 dll_is_current,:276 write_version_sidecar,:472,:539
/home/comdare/.../probst-diplomarbeit-cache-engine/.gitlab-ci.yml        :842-847,:877-880 (P4),:881-883 (GN_MSYS-Pflicht),:889-898,:912,:917,:942,:955,:1032,:1048-1076,:1250
Code/02_messung_driver/main.cpp                                          :777-779 (Prune-Fallback nackte Basis)
Achsen-Header: extension_hardware_family_axis.hpp:40,:66,:79-80 | simd_sub_axis.hpp | compiler_atomic_sub_axis.hpp
               optimization_level_sub_axis.hpp:13,:125 | target_isa_system_axis.hpp:33,:64,:73,:85-97
               scheduling_system_axis.hpp:23,:60 | load_framework_system_axis.hpp:21,:29,:44
Generator/Registry: CE/tools/system_axis_registry_gen/main.cpp:126,:164,:215,:244,:258,:284,:298-315,:336
                    CE/libs/cache_engine/include/cache_engine/measurement/system_axis_registry.xml:10,:53,:98,:102,:114,:machine_signatures
Profil-XML: CE/libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml:169-191
```

**Identitaet**
```
CE/libs/cache_engine/include/cache_engine/measurement/machine_simd_signature.hpp   :31-48,:33,:34,:35-37,:40-44,:50-58,:61-73,:77-108,:111-128
CE/libs/cache_engine/include/cache_engine/measurement/simd_build_gate.hpp          :89-94,:102-147,:141-146,:153-159 (T subset S),:163-170,:175-179,:181-187 (STUBS),:191-196
CE/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp             :457-468 (Durchsetzung, inert)
CE/libs/cache_engine/profile_facade/profile_run_entry.hpp                          :331-347 (Zelle aus Env),:734-752 (Freigabe-Kopplung)
CE/libs/cache_engine/builder/bestandslog/bestandslog_index.hpp                     :92-120
CE/libs/cache_engine/builder/bestandslog/bestandslog_document.hpp                  :147-157,:159-170
CE/libs/cache_engine/builder/bestandslog/bestandslog_factory.hpp                   :36-72 (MesswertKeyPolicy :56-71)
CE/libs/cache_engine/include/cache_engine/measurement/simd_organ_requirement.hpp / simd_organ_sensibility.hpp / simd_feature_flag.hpp
Test-Anker: CE/tests/unit/test_m_simd_feature_flag_catalog.cpp:3-5 | CE/tests/unit/test_br1_full22_count.cpp:60-68 (haelt 5 System-Levels + telemetry)
```

---

# VERDIKT (5 Saetze)

1. **Modi:** heute exakt 3 (`debug/measure/release`), COMPARE ist NUR ein XSD-Kommentar (`experiment_schema.xsd:60-61`) und ein unbeteiligter CEB-Command; ein 5. Modus kostet mechanisch ~30 Zeilen in EINEM Header (XSD/Parser/Validator sind registry-getrieben und kosten nichts), **aber** CUSTOM_COMPILE ist der erste Modus, der eine Verzweigung braucht, die es nicht gibt — `measurement_on` hat genau EINEN Konsumenten (`measure_parallelism.hpp:25`) und gatet nur die Mess-Parallelitaet, nie den Mess-Job-Entfall; die faktische "bauen ohne messen"-Schiene (`provision_only`/`pruef_only`) ist env-getrieben und ausserhalb der Registry.
2. **Positions-Invariante:** kein Konflikt — `+mtool/+mrg` hinten und `+ceb` als letztes Suffix-Segment sind **konform** zur neuen Sortierung, weil §4 des Session-Docs fuer den Binaries-Realm ausdruecklich "Mess-Achsen-Typ als LETZTER/tiefster Haupt-Achsen-Typ" festlegt.
3. **Realer Bruch:** `+ext` VOR `+cxx/+opt` invalidiert genau die Form-P-Remote-Objekte mit `+ext=avx2`/`+ext=avx512` (golden-Reihe, `all_axes_golden.profile.xml:178-191` x CI-Matrix `.gitlab-ci.yml:1048-1076`); Bau-Artefakte, additiv liegen lassen, kein Loesch-GO noetig — und die Kosten fallen mit dem `persistence_target`-17->18-Neubau zusammen, **wenn** beide im selben §66-G2-Fenster landen.
4. **Zweitrangige Konflikte:** `xs:sequence` in `SystemAxesType` (`experiment_schema.xsd:253-366`) ist order-binding und muss auf `xs:all` weichen (Parser `xml_config_parser.cpp:98-117` ist schon ordnungs-agnostisch); der Generator (`system_axis_registry_gen/main.cpp:164-292`) traegt die Alt-Ordnung hartkodiert; `+os` und `+a128` MUESSEN weglassbar-bei-Default sein, sonst brechen auch die `no_extension`-Keys.
5. **Halbordnung:** die Relation `T subset S` existiert bereits korrekt als `admit_organ_on_machine` (`simd_build_gate.hpp:153-159`) mit dem richtigen Freigabe-Maximum `S ∩ meaningful ∩ route` (`:141-146`) und dem richtigen Durchsetzungspunkt (`build_orchestrator.hpp:457-468`) — sie ist nur (a) auf `SimdFeatureFlag` verengt und (b) durch den Stub `active_machine_signature() { return {}; }` (`:187`) vollstaendig inert; der Meta-Meta-Satz fehlt zusaetzlich in `ZellKoordinaten` (`bestandslog_document.hpp:147-157`, nur `{combo,opt,simd}`), womit Bestandslog und Objekt-Store heute verschiedene Identitaetsbegriffe fuehren.

Selbstcheck: `grep -P '[^\x00-\x7F]'` auf diesen Bericht -> 0 Treffer ausser `§` (erlaubt). Keine Datei im Repo geaendert (nur Read/grep/sed/find/cat/wc). Alle Zeilennummern am Ist-Stand live verifiziert.