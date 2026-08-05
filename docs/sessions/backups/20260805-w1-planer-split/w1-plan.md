# W1-PLAN — PLANER-BINARY-SPLIT + W2-MINIMAL (05.08.2026, Planungs-Subagent, READ-ONLY erhoben)

Owner-F1 (HART, mittag-1 verbatim): "Definitiv vor Abgabe, weil sonst die Binaries aller Stufen
nicht korrekt gebaut werden." Owner-KERN: "Der Planer ist ZWINGEND eine eigene Binary mit dem
User-CLI-Interface auf der Shell." Basis: ce = 18fbb950 (Gate 404), super = origin/development.

PFLICHT-VORLAUF VOLLZOGEN: super-Ledger alle 05.08.-Nachtraege (vormittag-4, mittag-1/-2/-4/-6/-7/
-9/-10/-11, nachmittag-1/-2/-3/-4 inkl. DAUER-AUFLAGE FINGERPRINT-NEUTRALITAET nachmittag-2) ·
synthese.md + f2-r2-modulschnitt.md KOMPLETT · ist-planer.md + rufkette.md KOMPLETT · IST am
Objekt: super main.cpp (1700 Z. voll), 02_messung_driver/CMakeLists.txt, Code/CMakeLists.txt
(ce-Einbindung), ce planner/ (director 2008 Z. an den Nahtstellen, planner_version.hpp voll,
experiment_dock_payload/plan_legend), profile_run_facade.hpp voll + .cpp (Fassaden/planer_block/
construct_plan_into), validate_profile-Naht, lazy_adhoc_source_gen.hpp (Stempel-Naht),
profile_facade/CMakeLists.txt, apps/catalog_codegen_tool/CMakeLists.txt (Blaupause),
apps/CMakeLists.txt, test_experiment_plan_director.cpp (Pin-Stellen), super .gitlab-ci.yml
(plan/validate-Aufrufer), COMDARE_MEASUREMENT_COMBO-Vollgrep.

Stufen-Doktrin-Einordnung (mittag-9/-10/-11, bindend): Die MESS-Achsen-STUFE-1-RT-FREIGABE lebt im
PLANER (Traeger-Binary); CEB = Stufe-2-CT-Einbau. W1 stellt genau diese Traeger-Binary her; W2 ist
der minimale Stufe-2-CT-Einbau-Hartzug (Fork-A-Minimalhaerte, Owner-GO mittag-6 R1: "-D-Define wie
empfohlen"; Codegen-Zielform = Nach-Abgabe-TODO per Dauer-Regel).

---

## 0. IST-KERN (verifiziert am Objekt, Stand 18fbb950 / super HEAD)

- Traeger BEIDER Rollen: super Code/02_messung_driver/main.cpp — ":552 'Planer- + CEB-Rolle in
  EINEM Binary'". Subcommand-Dispatcher canonicalize_cli :589-684 kanonisiert auf Alt-Flag-Routen;
  Flag-Schleife :703-858; Planer-Rolle = validate/plan dump|ci|cmake/cache-key/fingerprint
  (planer_block-Gate NUR an plan ci|cmake, :293-364 + :384-408); CEB-Rolle = tier ci|cmake
  (:410-430, ausdruecklich KEIN planer_block) + run (:860-1699).
- Die gesamte SUBSTANZ (Director, 6 Builder, Trio-Resolve, validate, combos, planner_version,
  planer_block-LEBENSZYKLUS run_with_planer_block) liegt BEREITS in ce (header-only planner/ +
  die eine Umbrella-TU profile_run_facade.cpp als STATIC-lib comdare::profile_run_facade).
  Der super-main.cpp-Anteil der Planer-Rolle ist NUR: CLI-Dispatch + Profil-/Env-Aufloesung +
  planer_block-KONTEXT-Erzeugung (Gate) + Fassaden-Aufrufe. => Der "Code-Umzug" ist praezise:
  dieser Host-Anteil wandert in eine neue ce-App-main.cpp; die ce-Substanz wird NICHT dupliziert,
  sie bekommt einen zweiten Konsumenten (dieselbe Static-Lib).
- ce ist im super-Build per add_subdirectory(... EXCLUDE_FROM_ALL) eingebunden (Code/CMakeLists.txt
  :211-213) => ein neues ce-apps-Target ist im super-Build-Tree per --target baubar.
- CI-Aufrufer der Planer-Rolle am Treiber (super .gitlab-ci.yml): :369 `"$DRIVER" plan dump`
  (visibility), :678 + :763 `"$DRIVER" validate` (Pre-Flights), :992 `"$DRIVER" plan ci` (W10-B
  Delegation). KEINE CI-Konsumenten von cache-key/fingerprint-Subkommandos im super-YAML (R8/
  Algo-Sig-Strecken laufen ueber die EMITTIERTE Child-YAML, nicht die Parent-YAML; die emittierten
  Jobs rufen nur `tier ci|cmake` — bleibt Treiber).
- Fork-A-Verstoss-Anatomie (R-G3): ceb:build/ceb:emit (director :769-770/:800-801) und die
  Tier-Batch-Jobs (:1114-1116/:1258-1260) bauen stets den GENERISCHEN comdare-messung-driver;
  die [a,b,c]-Differenzierung reist ab N>1 als Runtime-Env COMDARE_MEASUREMENT_COMBO (:1088,
  :1227, :1571-1574; [all] => Zeile ENTFAELLT). Stempel-Naht = measurement_stamp_from_env()
  (lazy_adhoc_source_gen.hpp:242-246, DIE EINE Env->Mess-Zeile-Uebersetzung; speist Source-Gen
  UND Fingerprint-Fn UND SOTA-Emitter). +mtool-Cache-Key-Segment liest dieselbe Env
  (artifact_cache.hpp:242-246) — das ist die W-11-Flaeche (NICHT anfassen, nur deklarieren).

---

## (a) SCHNITT-LISTE je Funktion/Block (datei:zeile -> Ziel)

Legende: PLANER-APP = neue ce-App apps/experiment_planner/main.cpp · BLEIBT = super main.cpp
unveraendert · GETEILT = ce-Substanz, beide Binaries konsumieren sie (kein Umzug noetig) ·
ENTFAELLT = aus super main.cpp geloescht (Substanz zieht um).

super Code/02_messung_driver/main.cpp:
| Block | Zeilen | Ziel |
|---|---|---|
| PlanerBlockGate + make_planer_block_gate | :314-364 | PLANER-APP (ENTFAELLT in super; identische Gate-Formel/Budget/id-Semantik uebernehmen, Kommentare mitziehen) |
| emission_abgebrochen | :379-382 | GETEILT per Kopie-Split: bleibt in super (tier-Handler nutzen es) UND steht in der App (plan-Handler) — 4 Zeilen Fehler-Renderer, deklariert |
| run_dump_ci_guarded / run_dump_cmake_guarded | :384-408 | PLANER-APP (ENTFAELLT in super) |
| run_emit_tier_ci_guarded / run_emit_tier_cmake_guarded | :410-430 | BLEIBT (CEB-Rolle) |
| GoldenRange + parse_golden_range_env | :437-457 | HOIST -> ce planner/planner_cli_env.hpp (GETEILT: App braucht es fuer `fingerprint`, super-run-Pfad fuer :1526; super wechselt auf den ce-Include, lokale Kopie ENTFAELLT) |
| trim_copy / env_trimmed | :233-242 | HOIST -> ce planner/planner_cli_env.hpp (GETEILT, wie vor) |
| kDeprecatedAliases | :471-485 | SPLIT: Planer-Eintraege (--validate/--check/--dump-plan/--dump-ci/--dump-cmake/--print-cache-key/--chunk-organ-fingerprint) ENTFALLEN aus der Tabelle; Treiber-Tabelle behaelt --emit-tier-ci/--emit-tier-cmake. Die NEUE App traegt KEINE Alt-Flags (neue Binary erbt keine deprecated Aliase — Aufraeumpass-Doktrin) |
| help_for | :488-578 | SPLIT: plan/validate/cache-key/fingerprint-Topics + Uebersicht -> PLANER-APP (angepasster Binary-Name); Treiber-Hilfe schrumpft auf tier/run/version/help; Titelzeile :552 wird "CEB-Rolle (Planer-Rolle: comdare-experiment-planner)" |
| EffectiveArgs + canonicalize_cli | :582-684 | SPLIT: App bekommt eigenen schlanken Dispatcher (nur Planer-Grammatik, KEINE Alt-Flag-Kanonisierung); Treiber-Dispatcher verliert validate/plan/cache-key/fingerprint-Zweige und antwortet dort mit VERWEIS-Fehler (stderr "gewandert nach comdare-experiment-planner ...", rc 1) |
| --validate-Zweig (Root-Sniff beide Wurzeln, 2-Registry-Kanon) | :705-740 | PLANER-APP (ENTFAELLT in super; #ifdef-Registry-Pfad-Muster :726-734 identisch mitnehmen) |
| --dump-plan-Zweig | :746-752 | PLANER-APP (`plan dump`) |
| --chunk-organ-fingerprint-Zweig | :757-775 | PLANER-APP (`fingerprint`) |
| --print-cache-key-Zweig | :781-784 | PLANER-APP (`cache-key`) |
| --version-Zweig | :790-793 | BLEIBT (Treiber-Selbst-Stempel); App bekommt EIGENES `version` (s. (b)) |
| --dump-ci / --dump-cmake-Zweige | :798-817 | PLANER-APP (`plan ci|cmake`, mit planer_block-Gate) |
| --emit-tier-ci/-cmake-Zweige | :824-857 | BLEIBT (CEB-Rolle, `tier ci|cmake`) |
| Lane-Wache, E4-/Legacy-Run, Bestandslog-Host-Verdrahtung, ProgressSink | :860-1699 | BLEIBT KOMPLETT (Mess-Vollzug = CEB) |

ce (KEIN Umzug, nur neuer zweiter Konsument — Beleg der Nicht-Duplikation):
| Baustein | Ort | Rolle nach Split |
|---|---|---|
| ExperimentPlanDirector + walk_perms_ | planner/experiment_plan_director.hpp:1719-2006 | GETEILT (Planer-Walk; Treiber braucht ihn weiter fuer Startgate + tier-Emission) |
| Stufe-1-Builder PlanText/PlanSize/CMakeGraph/CiYaml + plan_legend | director :217-898 + plan_legend.hpp | GETEILT; Aufrufer der Stufe-1-FASSADEN ist kuenftig NUR die Planer-App |
| TierCiYaml/TierCmakeGraph (Stufe 2) | director :928-1716 | GETEILT; Aufrufer bleibt der Treiber |
| RegistryTrio-Resolve + validate-Gate | validate_profile.hpp:663-836/1217-1231 + construct_plan_into (facade .cpp:847-909) | GETEILT (Fassaden-intern) |
| measurement_combos_of / select_measurement_combo | director :1909-1941 | GETEILT |
| planner_version.hpp (kPlannerVersion v1.0.0c, X.Y.Z+ISA/OS, KEINE Achsen-Arrays) | planner/planner_version.hpp | GETEILT; die App rendert planner_version_stamp() in ihrem `version` |
| planer_block-LEBENSZYKLUS run_with_planer_block + mark_done/store | facade .cpp (~:700-838) | GETEILT (Fassaden-intern; Kontext-ERZEUGUNG zieht in die App) |
| Fassaden dump_/emit_/validate_/print_/chunk_/assert_ | profile_run_facade.hpp:206-338 | GETEILT — die Schnitt-Naht IST diese Fassaden-Signatur (= exakte kuenftige #35-.so-Schnittstelle, AUDIT-20.07.:72) |

ZWEI MODULE, KEINE VERERBUNG (PV-2): App und Treiber teilen NUR die Fassaden-lib; keine
gemeinsame Klassenhierarchie, keine neue Basisklasse. Der SlicePlanner 4096, ram_spool,
Pruef-Dock-Gate, run_lazy_static_then_dynamic, BuildOrchestrator, EIN-CSV-Rueckschrieb werden
NICHT beruehrt (CEB-Substanz, bleibt hinter run/tier).

---

## (b) NEUE APP-STRUKTUR (ce, nach catalog_codegen-Blaupause BAUPLAN:32/40)

Ort: ce apps/experiment_planner/ (Branch w1-planer-split ab 18fbb950; Arbeit in /home/comdare/wt-e24,
build-e24 warm, -j MAX 8 nice).

apps/experiment_planner/CMakeLists.txt (Blaupause apps/catalog_codegen_tool/CMakeLists.txt,
schlanker weil die Schwere in der Fassaden-lib liegt):
```cmake
# W1 (F1-HART, Owner-KERN 05.08.): der Experiment-Planer als EIGENE Binary — Stufe-1-Traeger
# der Mess-Achsen-RT-Freigabe (Stufen-Doktrin mittag-9/-10). BAUPLAN Phase 1: comdare_experiment_planner.
add_executable(comdare_experiment_planner main.cpp)
set_target_properties(comdare_experiment_planner PROPERTIES
    OUTPUT_NAME "comdare-experiment-planner")
target_compile_features(comdare_experiment_planner PRIVATE cxx_std_23)
target_include_directories(comdare_experiment_planner PRIVATE
    "${PROJECT_SOURCE_DIR}/libs/common/serialization")   # xml_reader.hpp (Root-Tag-Sniff)
target_link_libraries(comdare_experiment_planner PRIVATE
    comdare::profile_run_facade)                          # PUBLIC-Include liefert <profile_facade/...>
# Default-Profil + validate-Registry-Pfade (Spiegel super 02_messung_driver/CMakeLists.txt:27-37;
# ce-Seite ist PROJECT_SOURCE_DIR-relativ => im super-Sub-Build identische Pfade):
target_compile_definitions(comdare_experiment_planner PRIVATE
    "COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE=\"${PROJECT_SOURCE_DIR}/libs/cache_engine/algorithm_profiles/thesis_profiles/m3v2_study.profile.xml\""
    "COMDARE_CE_AXIS_REGISTRY_PATH=\"${PROJECT_SOURCE_DIR}/libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml\"")
if(DEFINED COMDARE_PRT_ART_DIR)   # super-Sub-Build: Directory-Scope-Vererbung liefert die Variable
    target_compile_definitions(comdare_experiment_planner PRIVATE
        "COMDARE_PRT_AXIS_REGISTRY_PATH=\"${COMDARE_PRT_ART_DIR}/prt_art/algorithm_profiles/prt_art_axis_registry.xml\"")
endif()                            # ce-standalone: #else-Zweig des validate liefert rc 5 (Parity zum heutigen #ifdef)
if(COMMAND comdare_set_platform_defines)
    comdare_set_platform_defines(comdare_experiment_planner)
endif()
```
+ apps/CMakeLists.txt: `add_subdirectory(experiment_planner)` (mit W1-Kommentar).
Makro-Name COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE wird BEIBEHALTEN, damit die umziehenden
Code-Bloecke diff-minimal bleiben (Umbenennung = Nach-Abgabe-Hygiene-Kandidat).

Neuer geteilter Header ce libs/cache_engine/profile_facade/planner/planner_cli_env.hpp:
trim_copy/env_trimmed/GoldenRange/parse_golden_range_env (Substanz-Umzug aus super main.cpp
:233-242/:437-457; header-only, nur stdlib; super inkludiert ihn ab S1 — EINE Quelle statt zwei).

apps/experiment_planner/main.cpp — Aufbau (alle Bloecke = UMZUGSGUT aus super main.cpp, s. (a)):
1. Includes: <profile_facade/profile_run_facade.hpp>, <builder/artifact_transport/artifact_cache.hpp>,
   <builder/bestandslog/fingerprint_key_source.hpp> ENTFAELLT (nur run-Pfad), xml_reader.hpp,
   <profile_facade/planner/planner_cli_env.hpp>, <profile_facade/planner/planner_version.hpp>.
2. anonymer namespace: PlanerBlockGate + make_planer_block_gate (verbatim-Umzug),
   emission_abgebrochen, run_plan_ci_guarded/run_plan_cmake_guarded (umbenannt von run_dump_*,
   Rumpf identisch), help_for (Planer-Grammatik), dispatch (direkt, ohne Alt-Flag-Kanonisierung).
3. Subkommando-Zuordnung + Exit-Grammatik (uebernommen; 7 = Lane-Wache existiert hier NICHT und
   wird in der Hilfe als "nur Treiber (run)" ausgewiesen — die GRAMMATIK 0/1/2/5/6/7 bleibt die
   der Kette):
   - `validate [<profil>]`      -> Root-Sniff + validate_profile_facade / validate_experiment_
                                   profile_facade (2-Registry-Kanon, #ifdef wie heute). rc 0/1/5.
   - `plan dump [<profil>]`     -> dump_experiment_plan_facade. rc 0/5.
   - `plan ci [<profil>]`       -> planer_block-Gate + dump_experiment_ci_facade. rc 0/1/5/6.
   - `plan cmake [<profil>]`    -> planer_block-Gate + dump_experiment_cmake_facade. rc 0/1/5/6.
   - `cache-key`                -> print_cache_key_facade("m3v2"). rc 0.
   - `fingerprint [<profil>]`   -> parse_golden_range_env + chunk_organ_fingerprint_facade. rc 0/2.
   - `version`                  -> planner_version_stamp()-Zeile + build-type-Zeile (§43.b/§64:
                                   der PLANER ist die EINZIGE Binary mit EINEM X.Y.Z; bewusst
                                   NICHT der 4-Zeilen-Treiber-Block — DEKLARIERTE Abweichung,
                                   der Treiber behaelt seine 4 Zeilen).
   - `help [<topic>]` / --help/-h / --version  -> clig.dev-kanonisch.
   - Profil-Aufloesung ueberall: Argument > COMDARE_THESIS_PROFILE > gebackenes Default-Profil.
   - `status` (W5) NICHT in W1 — aber der Dispatcher wird als flache if-Kette gebaut, sodass W5
     das Subkommando additiv einhaengt (Reservierungs-Kommentar im Dispatch).
4. KEINE Alt-Flags in der neuen Binary (deprecated Aliase wandern nicht in neue Oberflaechen;
   Treiber-Aliase fallen im Abschluss-Aufraeumpass, Ledger 75).
5. ASCII-only-Kommentare; 3-Marker-Formen vermeiden; cf22 je Commit.

Doktrin-Gates erfuellt: §42 (CE erhaelt die XML, App lebt in der CE-Welt) · §31-A4 (CI-Cache
kann kuenftig NUR dieses statische Target halten) · §62-A (anspruchslos: keine neuen Pflicht-Envs,
Warnungs-Semantik der Fassaden unveraendert) · §40.b (Tier-Emission bleibt CEB/Treiber).

---

## (c) SUPER-ANTEIL exakt (NIEMALS im Haupt-Tree — worktree /home/comdare/wt-super-w1,
Branch w1-planer-split-super ab origin/development; Lead verbucht parallel im Haupt-Tree)

main.cpp (Details in (a)); Netto-Wirkung:
- ENTFALLEN: :314-364, :384-408, :437-457 (durch ce-Include ersetzt), :471-485-Teilmenge,
  Planer-Topics in help_for, validate/plan/cache-key/fingerprint-Zweige der Flag-Schleife
  (:705-784 ohne :790-793, :798-817). Kein toter Code bleibt stehen (Aufraeumpass-Owner-KERN).
- VERWEIS-FEHLER statt stiller Luecke: canonicalize_cli beantwortet die Woerter validate|plan|
  cache-key|fingerprint und ihre Alt-Flags mit EINER stderr-Zeile
  "'<wort>' ist in die Planer-Binary gewandert: comdare-experiment-planner <wort> ..." + rc 1
  (fail-loud; kein stilles Weiterfallen in den run-Positional-Pfad — das WAERE sonst der Fall,
  weil ein unbekanntes argv[1] heute als <config_dir> gelesen wird!).
- BLEIBEN wortidentisch: tier ci|cmake (inkl. --measurement-combo-Selektor), run (Lane-Wache,
  E4-Block, Bestandslog-Host-Gate d1, ProgressSink, Prune-/Pruef-/Provision-Modi), version, help
  (geschrumpft), Legacy-Pfade.
- 02_messung_driver/CMakeLists.txt: unveraendert bis auf Kommentar (Titel "Planer- + CEB-Rolle in
  EINEM Binary" an :20-21 wird zur CEB-Rolle praezisiert). KEIN neues Target in super (§42).
- .gitlab-ci.yml (4 Aufrufstellen, Umstellung in S2):
  - :340-385 visibility:tier-binaries: baut zusaetzlich `--target comdare_experiment_planner`,
    PLANNER=$(find build -name comdare-experiment-planner ...), `"$PLANNER" plan dump`.
  - :676-678 + :762-763 Pre-Flights: `"$PLANNER" validate` (Bau des Planner-Targets in diesen
    Jobs ergaenzen; der Treiber-Bau bleibt daneben bestehen).
  - :966-992 W10-B: `"$PLANNER" plan ci "$COMDARE_GOLDEN_N_PROFILE" > planer-child-ci.yml`.
  - Kommentarbloecke :940-952 auf die neue Zwei-Binary-Wahrheit nachziehen.
- SUBMODUL-KOPPLUNG: S1/S2 setzen den ce-Submodul-Stand mit C1/C2 voraus. Der Bump ist
  LEAD-SACHE; die super-Branch-Commits werden auf dem lokal gebumpten Submodul-Stand gebaut und
  im Commit-Text als "erfordert ce >= <sha C2>" markiert. S1+S2 muessen als EINE Einheit nach
  development (sonst Fenster: neuer Treiber ohne YAML-Umstellung => rote Pre-Flights).

Emittierte Plaene (ce-Seite, KEINE Aenderung in W1): ceb:build/ceb:emit bauen weiterhin
comdare-messung-driver (der Treiber IST die CEB — korrekt), ceb:emit ruft `"$DRIVER" tier ci`
(CEB-Hoheit — korrekt). Der von ALTEN Pipelines archivierte YAML-Text ruft nie `plan *` => kein
Artefakt-Bruch.

---

## (d) W2-DEFINE-DESIGN (Minimalhaerte in der W1-Emission; Owner-GO "-D-Define wie empfohlen")

NAME:
- CMake-Cache-Variable: `COMDARE_MEASUREMENT_COMBO` (STRING, Default ""), gesetzt per
  `-DCOMDARE_MEASUREMENT_COMBO=<legende>` am Configure der CEB-Kompilation — bewusst der
  Env-Name als CMake-Name (eine Vokabel, zwei Traeger-Welten; der emittierte Job traegt kuenftig
  BEIDE Formen mit demselben Wert).
- Compile-Define am Kompilat: `COMDARE_MEASUREMENT_COMBO_CT="<legende>"` (CT = compile-time;
  klare Abgrenzung zur Env im Code).

ORT (genau gezogen — CEB-Compile, NICHT Tier-Compile):
1. ce profile_facade/CMakeLists.txt (das Fassaden-Target ist die EINZIGE TU der Stempel-Naht im
   Binary — measurement_stamp_from_env kompiliert dort):
   ```cmake
   set(COMDARE_MEASUREMENT_COMBO "" CACHE STRING
       "W2: Mess-Combo-Legende [a,b,c] — kompiliert die CEB messsystem-hart; leer = [all]-Vollmenge (Sect. 64-Default)")
   if(COMDARE_MEASUREMENT_COMBO)
       target_compile_definitions(comdare_profile_run_facade PRIVATE
           "COMDARE_MEASUREMENT_COMBO_CT=\"${COMDARE_MEASUREMENT_COMBO}\"")
   endif()
   ```
   Wirkt in ce-standalone UND super-Sub-Build (Cache-Var global). ODR-Wache im Bau-Gate: Vollgrep
   belegt, dass lazy_adhoc_source_gen.hpp im Treiber-/Planner-Link NUR ueber die Fassaden-TU
   materialisiert (heutiger Include-Satz: main.cpp ist umbrella-frei); Test-TUs sind eigene
   Binaries. Befund anders => Define zusaetzlich auf die betroffene TU-Target-Liste.
2. Stempel-Naht lazy_adhoc_source_gen.hpp:242-246 — CT-VORRANG mit Widerspruchs-Wache:
   ```cpp
   [[nodiscard]] inline std::string measurement_stamp_from_env() {
   #ifdef COMDARE_MEASUREMENT_COMBO_CT
       // W2 (Owner-GO mittag-6 R1): die COMPILE-hart eingebaute Combo ist die Wahrheit
       // (Stufe-2-CT-Einbau der Mess-Achsen, Stufen-Doktrin mittag-9). Eine ABWEICHENDE Env ist
       // ein Konfigurationswiderspruch -> fail-loud (Fehlerklassen-Doktrin), nie still.
       char const* const e = std::getenv("COMDARE_MEASUREMENT_COMBO");
       if (e != nullptr && *e != '\0' && std::string_view{e} != std::string_view{COMDARE_MEASUREMENT_COMBO_CT})
           throw std::runtime_error("fehlerklasse=konfiguration_widerspruch: COMDARE_MEASUREMENT_COMBO ('" +
               std::string{e} + "') != einkompilierte Combo ('" COMDARE_MEASUREMENT_COMBO_CT "')");
       return ::comdare::cache_engine::abi::measurement_stamp_line_from_combo_legend(COMDARE_MEASUREMENT_COMBO_CT);
   #else
       /* bestehender Env-Pfad BYTE-IDENTISCH */
   #endif
   }
   ```
   Es wird NUR diese eine Funktion angefasst (sie ist per A13-M3/C1 bereits die EINE Uebersetzung
   fuer Source-Gen + Fingerprint-Fn + SOTA-Emitter — die CT-Wahl erreicht damit ALLE drei
   Konsumenten konstruktionsbedingt gleich). abi/ wird NICHT beruehrt (der Renderer
   measurement_stamp_line_from_combo_legend wird nur GERUFEN).
3. Emission (director, 4 CEB-Compile-Stellen — das sind die Stellen, an denen der
   comdare-messung-driver=CEB kompiliert wird; die TIER-DLL-Compile-Flags/make_gpp_compile_fn
   bleiben UNANGETASTET):
   - emit_ceb_build_job :769 und emit_ceb_emit_job :800 (Stufe 1),
   - TierCiYamlBuilder emit_batch_build_job :1114 und emit_batch_measure_job :1258 (der
     CEB-NEUBAU im Batch-Job-Kontext — dort ENTSTEHEN die Stempel real, weil die CEB dort die
     DLL-Quellen generiert; ohne den Define hier bliebe die Haerte Fiktion).
   Form (Spiegel des combo_env-Idioms :1087-1088): `[all] => KEIN Zusatz` (byte-identische
   Live-Emission), sonst Configure-Zeile + ` "-DCOMDARE_MEASUREMENT_COMBO=<legende>"`.
   Die Env-Export-Zeilen (:1088/:1227/:1571-1574) BLEIBEN: sie speisen +mtool (Cache-Key) und
   Bestandslog-z.combo — das ist die W-11-Flaeche.
   CMake-Zwilling (CMakeGraphBuilder :390-400): der ceb:build ist dort nur Echo/Stamp (der
   aeussere Configure baut den Treiber) — es wird NUR der emittierte Kommentar-/Echo-Text um den
   Hinweis "-DCOMDARE_MEASUREMENT_COMBO=<legende> am aeusseren Configure" ergaenzt (bei !=[all]);
   Topologie-Isomorphie (perms/steps-Zeuge) unberuehrt.

STEMPEL-WIRKUNG: Bei einkompilierter Combo traegt jede von DIESER CEB generierte Tier-Quelle +
ihr .fingerprint-Sidecar + der SOTA-Emitter die Mess-Zeile aus dem KOMPILAT (CT), nicht mehr aus
der Laufzeit-Umgebung — exakt der Stufe-2-CT-Einbau. Die MESS-ZEILE selbst ist byte-identisch zur
Env-Form, weil DERSELBE Renderer mit DEMSELBEN Legenden-String laeuft (Konstruktion, kein Zufall).

NEUTRALITAETS-BEWEIS-PLAN (DAUER-AUFLAGE nachmittag-2, je Commit-Gate):
1. Kein Define, keine Env (der GESAMTE golden-/CI-Bestand): #else-Pfad byte-identisch =>
   kFrozenFingerprintV1 0fe275bd...822993b unveraendert in 3 TUs (literal grep) · golden-CRC
   0xF1C1F26A1232073B unberuehrt · golden-320 3/3 + Roundtrip · abi/-Diff 0 Zeilen · XML 0 Zeilen
   (Registry-XMLe unangetastet).
2. Emissions-Neutralitaet live: `plan dump|ci|cmake` + `tier ci|cmake` am [all]-Default-Profil
   VOR/NACH C2 byte-diffen => 0 (das [all]=>kein-Zusatz-Idiom; Pin test :2035 bleibt gruen).
3. Mess-Zeilen-Identitaet der N>1-Strecke (heute dormant): neue kleine TU
   test_w2_combo_ct_stamp.cpp, kompiliert MIT -DCOMDARE_MEASUREMENT_COMBO_CT="[wallclock]":
   EXPECT stamp == measurement_stamp_line_from_combo_legend("[wallclock]") (Byte-Gleichheit CT-
   vs-Env-Weg) + Widerspruchs-Wurf bei abweichender Env + Env-gleich => still. Biss am Alt-Stand:
   die TU existiert dort nicht — Biss stattdessen semantisch: Assertion gegen den #else-Pfad
   (Env gesetzt) belegt Gleichheit beider Wege. ctest-N 404 -> 405 (lebendes Gate, im Commit-Text
   deklariert; Doppellauf 2x405 seriell am Commit-Objekt, Basis 404 am FRISCHEN Configure).
4. test_experiment_plan_director additive Assertions: N>1-Fanout-Fall traegt den -D-Zusatz an den
   4 Stellen; [all]-Fall traegt ihn NIRGENDS (Zeilen-Pins :2019-2035 bleiben unveraendert gruen).
5. WENN irgendein Beweis (1)-(4) scheitert und die Mess-Zeile sich bewegen wuerde: STOP +
   Owner-Eskalation O-2 — NIE stillschweigend.

W-11 DEKLARIERT, NICHT ENTSCHIEDEN: Die Cache-Key-Einfaltung (+mtool aus Env via
ArtifactCache::from_env vs. .version-Sidecar) bleibt UNBERUEHRT; die Env bleibt dafuer im
emittierten Job. Nach-Abgabe-TODO (Dauer-Regel mittag-6): Codegen-Zielform BAUPLAN:243 ersetzt
den -D-Interim; dann W-11-Entscheid + Env-Export-Rueckbau. In Ledger-Nachtrag der Welle notieren.

---

## (e) COMMIT-SCHNITT (4 Commits, GATE JE COMMIT)

GATE-FORMEL je ce-Commit (bindend): Voll-Bau (build-e24, frisches Configure am Commit-Objekt) +
2x voll-ctest SERIELL (Basis 404; ab C2 405 — literal "100% tests passed") + golden-320 3/3 +
Roundtrip + TABU-Beweise literal (kFrozenFingerprintV1 3 TUs, golden-CRC, abi/-Diff 0, XML-Diff 0)
+ cf22 echtes Binary /home/comdare/tools/cf22/usr/bin/clang-format-22 mit Datei-Argumenten auf
jede beruehrte Datei + 3-Marker-Zeilenanfangs-Scan 0 + Working-Tree-Freeze + diff-stat im
Commit-Text. Wortgrenzen-Orakel bei allen grep-Beweisen; ninja-Modul-Scan-Falle beachten
(kein -fmodules-Scan-Artefakt anfassen).

- **C1 (ce, w1-planer-split): "feat(planner): comdare_experiment_planner — die Planer-Rolle als
  eigene Binary (W1, F1-HART)"**
  apps/experiment_planner/{CMakeLists.txt,main.cpp} + apps/CMakeLists.txt-Zeile +
  planner/planner_cli_env.hpp (Hoist). KEINE Aenderung an Treiber-sichtbarem ce-Code (Fassade/
  Director byte-unveraendert). Zusatz-Gate: Determinismus-Rauchtest der neuen Binary
  (2x `plan dump|ci|cmake` byte-gleich; `version` non-empty; `validate` rc 0 am Default-Profil;
  `fingerprint`/`cache-key` rc 0; `plan ci` mit COMDARE_BESTANDSLOG ungesetzt => stumm inert).
- **C2 (ce, w1-planer-split): "feat(w2): Mess-Combo als -D-Compile-Define + CT-Stempel-Vorrang
  (Fork-A-Minimalhaerte; Codegen-Zielform Nach-Abgabe-TODO; W-11 deklariert offen)"**
  profile_facade/CMakeLists.txt-Cache-Var + measurement_stamp_from_env-CT-Zweig + 4 Emissions-
  Stellen + test_w2_combo_ct_stamp + additive Director-Test-Assertions. Zusatz-Gate: Beweise
  (1)-(4) aus (d); ctest-N-Wechsel 404->405 im Commit-Text deklariert.
- **S1 (super-Worktree wt-super-w1, w1-planer-split-super): "refactor(driver): Planer-Rolle in
  die ce-Planer-Binary ausgezogen — Treiber = CEB-Rolle (tier|run|version|help)"**
  main.cpp-Schnitt nach (c) + CMakeLists-Kommentar + ce-Submodul lokal auf C2 (Lead re-pinnt nach
  ce-Landung). Gate: super Voll-Bau (Treiber + comdare_experiment_planner-Target aus dem
  Sub-Build) + Rauchtest: `tier ci|cmake` VOR/NACH byte-identisch; `run --help`/help/version ok;
  `plan ci`/`--dump-ci`/`validate` am Treiber => Verweis-Zeile + rc 1; BYTE-AEQUIVALENZ-BEWEIS:
  Alt-Treiber (origin/development-Build) `validate|plan dump|plan ci|plan cmake|cache-key|
  fingerprint` (env-frei, Default-Profil) vs. neue Planer-Binary => diff 0 je Kanal
  (planer_block inert gehalten). 2x voll-ctest falls super-ctest-Bestand beruehrt (Treiber-Tests
  :153-217 bleiben unberuehrt — erwartet 0 Delta).
- **S2 (super-Worktree, w1-planer-split-super): "ci(super): Planer-Aufrufe auf
  comdare-experiment-planner umgestellt (4 Stellen) + Zwei-Binary-Doku"**
  .gitlab-ci.yml nach (c). Gate: YAML-Lint lokal (python-frei, z.B. gitlab-runner-los per yq/
  Treiber-eigenem Parser-Smoke — kein Python in der Buildchain!), Vollgrep 0 verbleibende
  `"$DRIVER" plan`/`"$DRIVER" validate`-Stellen (Wortgrenzen), Kommentar-Wahrheit. Pipeline-Gruen
  am VOLL-SHA verifiziert der Lead nach Push (Push/Merge = Lead-Sache; S1+S2 als EINE Einheit).

KEIN Push/Merge durch die Bauwelle; Lead verbucht, pinnt Submodul, faehrt CI-Wache + main-FF.

---

## (f) RISIKEN + GEGENMITTEL

1. **CI-Jobs erwarten `plan ci`/`validate` vom Treiber** (super YAML :369/:678/:763/:992):
   ENTSCHEID: HARTER SCHNITT + gleich-wellige YAML-Umstellung (S2), KEINE Doppel-Grammatik-Phase —
   eine im Treiber verbleibende plan-Route hielte exakt die R-G1-Regression am Leben, die F1
   verbietet; der Verweis-Fehler (rc 1, fail-loud) faengt jeden Nachzuegler. Atomaritaet: S1+S2
   in EINEM Merge mit dem ce-Bump; alte Pipelines nutzen den alten Submodul-Stand (in-flight-
   Artefakte rufen nie `plan *`). Rest-Risiko: private Skripte/Cron ausserhalb des Repos — Vollgrep
   ueber super scripts/ + docs/anleitung* im S2-Gate; Befunde in den Session-Report.
2. **Emittierte-YAML-Erwartungen von Tests** (test_experiment_plan_director pinnt Job-Struktur):
   W2-Zusatz nur an 4 Zeilen, [all] unveraendert; additive Assertions statt Pin-Bruch; Pins
   :2019-2035 vorab gegengelesen (bleiben gueltig). Restrisiko klein: weitere Byte-Pins in nicht
   gelesenen Testteilen -> faellt im C2-Gate-ctest auf, dann Assertion additiv nachziehen.
3. **ODR/Define-Reichweite COMDARE_MEASUREMENT_COMBO_CT**: inline-Funktion mit #ifdef; Gefahr nur
   bei ZWEI TUs desselben Binaries mit ungleichem Define. Gate-Grep (Include-Graph) in C2; heute
   ist die Fassaden-TU der einzige Traeger im Treiber-/Planner-Link. Befund anders => Define auf
   alle betroffenen Targets spiegeln.
4. **Planner-Binary zieht die volle Fassaden-Schwere** (Katalog/Adapter-Link): +1 heavy Link im
   ce-Default-Bau (apps/ wird standalone default-gebaut). Mitigation: warme build-e24, nice -j<=8;
   im super-Build EXCLUDE_FROM_ALL (nur explizite --target-Baus in den 4 CI-Jobs). Job-Laufzeit
   der 4 umgestellten Jobs steigt um den Planner-Link (ccache-warm ~Minuten) — bei CI-Budget-
   Schmerz: Owner-/Lead-Info, kein stiller Rueckbau.
5. **validate in ce-standalone ohne prt-art**: comdare_experiment-Wurzel liefert rc 5 (heutiges
   #ifdef-Muster gespiegelt). In der super-Welt (einziger validate-CI-Konsument) volle Paritaet.
   Deklariert, kein stiller Funktionsverlust.
6. **R-G2 Registry-Kanon-Divergenz (validate=2er vs plan=3er) wird MITGENOMMEN, nicht
   vereinheitlicht** — bewusste Abweichung von der synthese-Gate-Zeile "beim Umzug
   vereinheitlichen": eine Kanon-Vereinheitlichung aenderte validate-Semantik/Ausgaben unter
   Frist und beruehrte ggf. XML-Erwartungen (XML byte-stabil = Tabu). => eigener benannter
   Folge-Posten + Ledger-Vermerk in der Welle; Owner sieht es im Report (VERBOSE), Einspruch
   moeglich bevor W5 aufsetzt.
7. **planer_block-Verhalten nach Umzug**: Gate-Formel/Budget/id ("owner_uuid + /planer") verbatim
   uebernommen; Beweis: env-frei stumm-inert (Byte-Neutralitaet), COMDARE_BESTANDSLOG=true ohne
   minio => WARNUNG ohne Binden (Rauchtest C1). Der Merge-Schluessel aendert sich NICHT dadurch,
   dass eine andere Binary reserviert (id traegt owner_uuid, nicht argv[0]).
8. **Fingerprint-/golden-Tabus**: W1 beruehrt weder abi/ noch Stempel-Pfade; W2 beruehrt genau
   EINE inline-Funktion ausserhalb abi/ + Emissionstext. Beweisplan (d); Verstoss => STOP + O-2.
9. **Zwei `version`-Wahrheiten** (Treiber 4-Zeilen vs. Planner-Stempel): deklarierte Abweichung
   nach §64-Kanon; Doku in beiden help-Texten. Nach-Abgabe-Hygiene: gemeinsame Stempel-Doku.
10. **Frist/Budget**: C1+C2 = Di nachmittag/abend; S1+S2 = Mi; Puffer fuer W5-Kern bleibt (Roadmap
    mittag-4). Kollisionsfall Phasen-3-5 => Owner-Priorisierung, F1 ist der harte Termin.
11. **wt-super-w1 existiert noch nicht**: vor S1 anlegen wie beauftragt
    (`git -C /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine worktree add
    /home/comdare/wt-super-w1 -b w1-planer-split-super origin/development`); NIE im Haupt-Tree
    arbeiten (Lead verbucht dort parallel).

## OFFEN DEKLARIERT (nicht stillschweigend entschieden)
- W-11 Cache-Key-Einfaltung der Combo: OFFEN, Env-Kanal unveraendert (s. (d)).
- R-G2-Kanon-Vereinheitlichung: Folge-Posten (s. Risiko 6).
- Env-Export-Rueckbau + Codegen-Zielform (BAUPLAN:243): Nach-Abgabe-TODO (Dauer-Regel mittag-6).
- `status`-Subkommando: W5 (naechste Welle, dockt am App-Dispatcher an).
- Treiber-Alt-Flag-Restmenge (--emit-tier-*): faellt im Abschluss-Aufraeumpass (Ledger 75).
