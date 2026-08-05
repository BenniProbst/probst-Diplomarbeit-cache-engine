# LENS IST-PLANER — Kartierung der realen Planer-Seite (READ-ONLY, Stand ce=b09ebb8a, 2026-08-05)

Objekt: /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine (HEAD b09ebb8a)
plus der Treiber im super-Repo: /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/02_messung_driver/main.cpp (1700 Zeilen).
Alle Pfade absolut ueber die Repo-Wurzel abgekuerzt: `ce/` = external/comdare-cache-engine, `super/` = Code/.

---

## SOLL-Glied (1): Planer = ZWINGEND EIGENE BINARY mit User-CLI

**IST: EXISTIERT NICHT als eigene Binary. Der Planer ist eine ROLLE im `comdare-messung-driver` (Planer+CEB in EINEM Binary). Das CLI existiert vollstaendig.**

- Vollabsuche `add_executable` im ce-Repo (CMakeLists.txt + *.cmake, ohne ext/-vendor): KEIN Target namens planer/planner.
  Klassifikation der Treffer:
  - Test-Executables: ce/tests/unit/CMakeLists.txt (Dutzende, u.a. :2958 `test_tp1_planer_filter_iterator`, :3031 `test_experiment_dock_payload`, :3050 `test_progress_delta`, :4260 `test_progress_heartbeat`) und ce/libs/cache_engine/builder/commands/tests/CMakeLists.txt:17,25.
  - Apps: ce/apps/ = adhoc_emitter, anatomy_codegen_tool, cache_engine_builder, catalog_codegen_tool, f15_compare, h2_score_akte_tool, is_original_validator, perm_runner — kein Planer.
  - Tools: ce/tools/ = Registry-Generatoren (axis_registry_gen, system_axis_registry_gen, measurement_axis_registry_gen), best_binary_selector, ycsb_cli usw. — kein Planer.
  - Vendor: ce/ext/traversal/... (fremde Benchmarks, irrelevant).
- Das Planer-Executable ist real der Mess-Treiber im SUPER-Repo: super/02_messung_driver/CMakeLists.txt:4 `add_executable(messung_driver main.cpp)` (OUTPUT `comdare-messung-driver`). Wortlaut super/02_messung_driver/main.cpp:552: **"comdare-messung-driver -- Planer- + CEB-Rolle in EINEM Binary (Mess-Kette der Diplomarbeit)"**.
- Shell-CLI: JA, voll ausgebaut (clig.dev-Konvention, V-6vi): Subcommand-Dispatcher `canonicalize_cli` main.cpp:589-684; Subkommandos `validate | plan dump/ci/cmake | tier ci/cmake | cache-key | fingerprint | run | version | help` (Hilfe-Uebersicht main.cpp:551-577, Detail-Hilfen 488-550); `--help/-h` und `--version` kanonisch; Alt-Flags (`--dump-ci` etc.) als DEPRECATED-Aliase (main.cpp:475-485). Exit-Code-Grammatik 0/1/2/5/6/7 (main.cpp:570-572).
- Rollentrennung ist NUR UX-/Kommando-sichtbar, nicht Binary-sichtbar: main.cpp:461-463 "W3 (rollen-orientiert): ... die 40.b-Rollentrennung (Planer steuert CEB-Jobs, CEB steuert Tier-Jobs) wird damit auf UX-Ebene sichtbar"; profile_run_facade.cpp:971 sagt woertlich "heute EINE Binary in zwei Rollen".
- R2-Frage (measurement_driver auf Planer+CEB verteilt): IST = Rollen-Split im selben Binary — `plan ci|cmake` = Planer-Rolle (traegt das bestandslog planer_block-Gate, main.cpp:293-368, 384-408), `tier ci|cmake` = CEB-Rolle (explizit KEIN planer_block, main.cpp:410-430). Ein physischer Binary-Split (R2) hat NICHT stattgefunden.
- Alt-CEB als eigenes Binary existiert daneben: ce/apps/cache_engine_builder/CMakeLists.txt:9 `add_executable(cache_engine_builder ...)`, OUTPUT_NAME `comdare-cache-engine-builder` (Zeile 31-33) mit eigenem argv-CLI (ce/apps/cache_engine_builder/main.cpp:92-130; Optionen --enumerate-only/--skip-build/--mode=...). Das ist der REV-7.6-Legacy-Orchestrator (4-XML-Config-Dir-Schema, Header-Doku main.cpp:14-34), NICHT die vom Planer gebaute CEB der Soll-Kette.
- "Planer traegt die MESS-Achsen": ERFUELLT. Die Mess-Kombination ist die AEUSSERSTE Walk-Ebene des Planers (ce/libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:94-107 `PlanMeasurementCombo`, Walk :1969-1998 combo -> opt x simd -> Steps; CiYamlBuilder-Prolog :683 "STUFE 1 = Mess-Achsen-Stufe").
- "User faehrt sie manuell mit der XML-Config": ERFUELLT — Profil-Aufloesung Argument > COMDARE_THESIS_PROFILE > einkompiliertes Default-Profil (main.cpp:568, 494).

## SOLL-Glied (2): Planer INTERPRETIERT die XML (3 Registries + autoritative Anwender-XML, Resolve/Link, .pom)

**IST: Parsing REAL und vollstaendig; Registry-Trio-Lesen REAL; Resolve/Link nur als ANNOTATIONS-Vorstufe im Plan-Pfad — der harte Validierungsfehler fuer Unregistriertes liegt im separaten validate-Pfad; der volle .pom-Link (LinkedExperimentPlan) ist DEFERRED.**

- Anwender-XML: `construct_plan_into` (ce/libs/cache_engine/profile_facade/profile_run_facade.cpp:843-905) macht Root-Tag-Sniff ueber den common-DOM und parsed BEIDE offiziellen Wurzeln: `<comdare_thesis_profile>` via `tlz::load_thesis_profile` (:875), `<comdare_experiment>` via `cx::XmlConfigParser::parse_experiment_profile` (:889-890). Unbekannte Wurzel => rc 5, "KEIN Plan emittiert" (:901-904).
- 3 art-spezifische Registries: REAL gelesen. Pfade kommen als CMake-Interface-Defines herein (ce/libs/cache_engine/profile_facade/CMakeLists.txt:136-138): `COMDARE_CE_AXIS_REGISTRY` = algorithm_profiles/cache_engine_axis_registry.xml (Organ), `COMDARE_SYSTEM_AXIS_REGISTRY` = include/cache_engine/measurement/system_axis_registry.xml, `COMDARE_MEASUREMENT_AXIS_REGISTRY` = .../measurement_axis_registry.xml. Gelesen via `read_axis_registry_trio` (ce/.../validate_profile.hpp:715-722; EIN Parser `read_axis_registry` :663-680 fuer alle drei, gemeinsame Wurzel `<comdare_axis_registry>`); Einspeisung in den Director: profile_run_facade.cpp:859-867 (Full-Trio-Ctor).
- Resolve/Link im PLAN-Pfad: S3 P-RESOLVER `resolve_axis_refs_against_trio` (validate_profile.hpp:783-836) klassifiziert die Achsen-Refs des Profils gegen das 3-Art-Angebot und schreibt einen `ResolverReport` in den Plan-Kopf (director :1749/:1798, PlanHeader :154). ABER ausdruecklich NUR Annotation: "Resolver annotiert, entscheidet nicht — STUFE §3.C.3 E-RES-C" (director :37), "reine Plan-Kopf-Annotation, KEIN Exit!=0 im run/build-Pfad" (facade :856-857); fehlende/unlesbare Registry => graceful INERT-Default statt Fehler (facade :856, director :1835).
- Harter Validierungsfehler fuer Unregistriertes: EXISTIERT, aber im VALIDATE-Gate (nicht im Plan-Walk): validate_profile.hpp:1217-1231 — unbekannte Achse => `r.ok=false` + "UNBEKANNTE Achse ... kein axis-id der ce-Registry (cache_engine_axis_registry.xml)"; ungueltige allowed_variant ebenso. Der Mess-Lauf gated hart darauf: run_experiment_profile_facade ruft das Validat als Pre-Flight VOR jedem Bau (profile_run_facade.cpp:996-999). Der validate-Pfad arbeitet dabei mit dem 2-Registry-Kanon (ce + prt_art: profile_run_facade.hpp:153-154, 212-213), der Plan-Pfad mit dem 3er-Trio — zwei verschiedene Registry-Saetze je Pfad.
- .pom-Voll-Link: NICHT GEBAUT. Der `LinkedExperimentPlan` / 5-tiefe #19-Resolver ist woertlich "Band-C DEFERRED (Task #19)" (experiment_dock_payload.hpp:61-63); Registry-Angebot->Anwahl-Resolver fuer Mess-Tooling ist offene Design-Frage D3 (director :1898-1899).

## SOLL-Glied (3): Planer BAUT die korrekte CEB (Director+Builder, kompiliert HART je Messsystem)

**IST: GoF Director+Builder REAL — aber der Planer kompiliert NICHTS in-process. Er EMITTIERT Text (CI-YAML bzw. CMake), dessen Jobs per `cmake --build` den GENERISCHEN `comdare-messung-driver` erneut bauen und "CEB" nennen. Ein hart-spezialisiertes CEB-Binary je Messsystem EXISTIERT NICHT.**

- Director+Builder-Muster REAL: `ExperimentPlanDirector::construct` (director :1719-1827) + `IPlanBuilder`-Interface (:190) mit 6 ConcreteBuildern: PlanTextBuilder (:217, `plan dump`), PlanSizeBuilder (:308, V-2-Startgate), CMakeGraphBuilder (:351, `plan cmake` -> experiment_plan.cmake), CiYamlBuilder (:679, `plan ci` -> Child-Pipeline-YAML), TierCiYamlBuilder (:928) und TierCmakeGraphBuilder (:1464) (CEB-Rolle, Stufe 2). EIN deterministischer Walk `walk_perms_` (:1950-1998): Mess-Kombination -> System-Perm (opt x simd) -> Steps.
- CEB-"Bau" = Textemission: `plan ci` emittiert je Mess-Kombination die drei Jobs ceb:build/ceb:emit/ceb:trigger (CiYamlBuilder :721-729). Der ceb:build-Job-Body (director :751-782): `cmake -B build -G Ninja -DCOMDARE_V32_ENABLE=ON -DCMAKE_BUILD_TYPE=Release` + `cmake --build build --target comdare-messung-driver` (:769-770) und dann woertlich `"== STUFE 1: CEB <legend> gebaut (Messsystem-Typ) =="` + maschinenlesbares `[CEB-TESTAT] ... status=gebaut` (:776-781). Identische Bau-Zeile auch in ceb:emit (:801) und den Tier-Jobs (:1116, :1260). D.h. die "je Messsystem gebaute CEB" ist stets dasselbe generische Treiber-Target; die Spezialisierung je Mess-Kombination liegt in Job-Legende/Env (COMDARE_GOLDEN_N_PROFILE, --measurement-combo), NICHT im Kompilat.
- ce/apps/cache_engine_builder (comdare-cache-engine-builder) wird von den emittierten Plaenen NICHT gebaut/verwendet — der Job-Text baut ausschliesslich comdare-messung-driver.
- "ccache am director:958-Umfeld": aufgeklaert — :958-960 (und :713-715) sind der `emit_child_ccache_config`-Aufruf (:552-565): CI-Cache-Konfiguration der EMITTIERTEN Jobs (CCACHE_DIR-Export :600), kein In-Process-Compile des Planers.
- "ein Planer kann multiple CEBs bauen": als Fan-out REAL verdrahtet (S6-P1 SCHARF): `measurement_combos_of` (:1909-1927) faechert je `<measurement_tooling><combo>` EINE ceb:build-Strecke auf; heute typisch 1 Kombination => 1 CEB-Strecke (leeres Tooling => `[all]`, :1912-1914). Kollisionsschutz per `--measurement-combo`-Selektor (:1936-1941, emit_ceb_emit_job :816-822).
- System-Achsen-Versionierung: auf PERM-/Tier-Ebene real (`build_version_suffix` "+opt=..+ext=.." aus der EINEN Suffix-Quelle, director :1985-1991) — sie versioniert die Tier-Artefakte, nicht ein CEB-Binary.
- Sequentielle Mess-CEBs (§38.b): per CI-Mitteln erzwungen — `resource_group: "ceb-<slug>"` je Strecke (:761) bzw. `ceb-measurement-exclusive` (Kommentar main.cpp:1393-1394) + `single_thread`-Semantik in `PlanBuildSemantic` (director :113-117, :1839-1866).

## SOLL-Glied (4): Vertrags-Schnittstelle Experiment-Dock (aufgeschluesselter unterer Teilbaum, Ranges je Achse)

**IST: Das Wire-Format EXISTIERT vollstaendig als getestete Referenz-Serialisierung — ist aber per S5-P4-Ruling DEPRECATED/von keiner Live-Call-Site konsumiert. Die LIVE-Uebergabe Planer->CEB ist der emittierte CMake-/YAML-TEXT + Env-Variablen. R1-Notiz (Textemission statt .so-ABI, bewusst deferred) BESTAETIGT.**

- Payload-POD real: ce/libs/cache_engine/profile_facade/planner/experiment_dock_payload.hpp — `AxisRangeEntry` (:46-55) AxisKind-gefaerbt (organ/system_config/system_measurement, :76-100) mit ZWEI Range-Formen: enumerierte Variant-Namen `<values>a b c</values>` oder Index-Fenster `<range start=".." count=".."/>` (:39-42); `ExperimentSubtreePayload` (:67-71) = Liste der Achsen-Ranges (= der aufgeschluesselte untere Teilbaum). Serialisierung `emit_experiment_subtree_xml` (:138-165) / `parse_experiment_subtree_xml` (:170-195) mit Byte-Roundtrip-Gate (Test: ce/tests/unit/CMakeLists.txt:3031 test_experiment_dock_payload).
- DEPRECATED-Ruling woertlich (:58-64): "Die LIVE-Kette Planer -> CEB -> Tier reicht die Achsen-Ranges NICHT ueber dieses in-process POD, sondern ueber den EMITTIERTEN CMake-/YAML-TEXT (... S5-P2 -- COMDARE_GN_OPT/_SIMD/_GOLDEN_N_RANGE + measure_out). Das VOLLE Wire-Format (der 5-tiefe #19-Resolver -> LinkedExperimentPlan mit variant/sub-axis/range) ist Band-C DEFERRED (Task #19). Dieses POD ... wird aber HEUTE von keiner Live-Call-Site konsumiert."
- Live-Uebergabe konkret: ceb:emit-Job ruft `"$DRIVER" tier ci "$COMDARE_GOLDEN_N_PROFILE" [--measurement-combo=<slug>] > tier-child-<slug>.yml` (director :826-828) — d.h. die CEB-Rolle liest die ANWENDER-XML SELBST erneut (Profil-Pfad via Env), statt einen serialisierten Teilbaum zu empfangen. Ranges je Achse live: nur als Index-Fenster `COMDARE_GN_RANGE`/`COMDARE_GOLDEN_N_RANGE` "start:count" (CiYamlBuilder :708-709; Parser main.cpp:441-457) + GN-Zellen-Pins COMDARE_GN_OPT/_SIMD (main.cpp:1481-1485) — KEINE per-Achse-Range-Aufschluesselung im Live-Draht.
- .so-ABI (R1): NICHT vorhanden; kein Dock als ABI-stabile .so — Vertrag ist Textemission (YAML/CMake) + Env. Als bewusst-deferred markiert: JA (Task #19 Band-C, s.o.).

## SOLL-Glied (5): Rueck-Kanal (sparser Fortschritts-Cursor) + Instrumentierung (#54)

**IST: Der §38-Fortschritts-Cursor EXISTIERT und ist live verdrahtet — exakt SOLL-konform sparse (KEINE Messdaten). ABER er ist ein In-Process-Beobachter (stderr + Datei), KEIN Pipe-Eingang eines separaten Planer-Prozesses (den es nicht gibt).**

- Typen + Semantik: ce/libs/cache_engine/builder/experiment_tree/progress_delta.hpp — `ProgressDelta` (cursor + mixed-radix-minimale `ProgressAxisChange`-Liste, done=true GENAU EINMAL am Fensterende = §38.b-Fertig-Signal; Header-Doku: "KEIN Mess-Daten-Rueckfluss"); `ProgressSinkFn` als No-Op-Naht (byte-neutraler Default). Delta-Logik `progress_delta_between`/`compute_progress_deltas`/`reconstruct_configs` real + getestet (tests/unit/CMakeLists.txt:3050, :4260).
- Feuerung: der achsen-blinde Iterator feuert je Binary + am Fensterende (ce/libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:2037 this_progress_cursor); Durchreichung durch die Fassade (profile_run_facade.cpp:610-611, 1127-1128).
- Konsument: der Treiber selbst (main.cpp:1388-1428) — zeit-gedrosselte (30 s) geflushte `[progress]`-Zeilen nach stderr + additiv in `<output_dir>/progress.cursor`. Woertlich: "REINER BEOBACHTER ... der Sink beobachtet den Cursor, er steuert nichts" (:1391-1394). Es gibt KEINEN Code, der progress.cursor zurueck-liest (Vollgrep: einziger Schreiber/Nutzer ist main.cpp; Leser = Mensch/CI-Log).
- Instrumentierung #54 (Planer instrumentiert CEB per XML-Anweisung; CEB piped Status an den Planer): IST = der Planer instrumentiert die CEB ueber den EMITTIERTEN Job-Text (Profil-Pin COMDARE_GOLDEN_N_PROFILE auf das aktive Profil, director :764/:797-799; Range-Fenster, ccache, Storage-Aktivierung :810; Combo-Selektor :816-822). Status-Rueckfluss = `[CEB-TESTAT]`-Zeilen (:781) + `[progress]`-Zeilen im CI-Log — Konsument ist der CI-Log-Aggregator/Mensch, NICHT ein laufender Planer-Prozess. Ein Status-PIPE-EINGANG am Planer EXISTIERT NICHT (Planer- und CEB-Rolle laufen nie gleichzeitig als getrennte Prozesse; die Kopplung ist Pipeline-Trigger + Artefakt tier-child-<slug>.yml, :829-832).

---

## Ehrlichkeits-Bilanz je SOLL-Glied

| SOLL | IST-Status |
|---|---|
| (1) eigene Planer-Binary + CLI | CLI: VOLL DA. Eigene Binary: NEIN — Rolle im comdare-messung-driver (super-Repo), "EINE Binary in zwei Rollen" |
| (2) 3 Registries + Anwender-XML, Resolve/Link, harter Fehler | Parse + Trio-Lesen: DA. Resolver im Plan-Pfad: nur Annotation (bewusst). Harter Fehler: im validate-Gate (2-Registry-Kanon). Voll-Link (.pom/LinkedExperimentPlan): DEFERRED #19 |
| (3) Planer kompiliert HART eine CEB je Messsystem (Director+Builder) | Director+Builder: DA. Harte Kompilation: NEIN — Textemission von CI-/CMake-Jobs, die den generischen Treiber bauen; je Mess-Kombination eine Strecke (Fan-out real, live 1) |
| (4) Dock: serialisierter unterer Teilbaum, Ranges je Achse | Wire-Format DA aber DEPRECATED/ungenutzt (S5-P4); live = Text+Env (nur Index-Fenster-Range); .so-ABI fehlt, deferred markiert (#19) — R1-Notiz bestaetigt |
| (5) sparser Cursor-Rueck-Kanal + #54 | Cursor DA, live, messdaten-frei (SOLL-konform sparse); aber Beobachter-Datei/stderr statt Pipe an einen Planer-Prozess; Instrumentierung via emittierten Job-Text/Env statt XML-Anweisung |
