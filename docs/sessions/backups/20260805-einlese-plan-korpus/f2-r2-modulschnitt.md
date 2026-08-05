# LENS f2-r2-modulschnitt — Einlese-Bericht (05.08.2026)

Auftrag: FRAGE 2 / §60-R2 (measurement_driver-Verteilung Planer/CEB: zwei Module vs. Unter-Klassen derselben Klasse) + Frage-1-Vollzugs-Spezifikation (WIE der Planer-Binary-Schnitt: welcher Code wandert wohin, CLI-Grammatik, was bleibt in der CEB). READ-ONLY am Korpus.

Abkuerzungen: LEDGER = docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md · AUDIT-20.07. = docs/sessions/2026-07-20-SESSION-DEPRECATED-AUDIT-kuratierte-wiederverwendung.md · BAUPLAN = docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md · KETTE-AUDIT = docs/sessions/backups/20260805-planer-ceb-kette-audit/ (soll.md / ist-planer.md / synthese.md). Alle Pfade relativ zu /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/.

---

## A. R2 — DIE ANTWORT LIEGT IM KORPUS (analyse-beantwortet seit 20.07., Status im Ledger fixiert)

### A.1 Verdikt (kanonisch)

**R2 ist im Ledger ausdruecklich als ANALYSE-BEANTWORTET gefuehrt** — LEDGER:3252 (§60-SCHLUSS, 20.07. nacht):

> "**PV-2** Driver-Split = ANALYSE-BEANTWORTET (R2-Verdikt: Haupt/Unter-DELEGATION zweier Rollen, keine Vererbung; Konsolidierung NICHT geboten — konstruktiver Schritt IST der .so-Schnitt) -> kein eigener Bau-Task, feeds #35; Status von OFFEN auf ANALYSE-BEANTWORTET praezisiert."

Langfassung AUDIT-20.07.:35 (identisch Anhang B :85):

> "**R2 (Driver-Split): Hypothese zur Haelfte korrekt.** RICHTIG: Mess-Achsen des Planers bestimmen den CEB-TYP/die Ausstattung (je Tooling-Kombination ein ceb:build-Job, director Z.86-99), und der eigentliche Mess-Vollzug liegt vollstaendig in der CEB (run_profile/run_experiment_profile → run_lazy_static_then_dynamic → Zwei-Phasen-Loop → Observer-Pull → CSV). FALSCH: 'Unter-Klassen derselben Klasseninstanz' — es gibt keine Vererbung zwischen Planer und CEB; Vererbung existiert nur planer-intern (IPlanBuilder-Familie, GoF Director+Builder). **Richtiges Modell:** Ledger-§24-Haupt/Unter-DELEGATION zweier ROLLEN derselben Binary ('kein Schein-Split', director Z.469-472) ueber das eindimensionale Planer-Dock; Isomorphie via geteilte Single-Source-Naehte (system_axis_opt_flag_of/march_of) + Contract-Test, nicht via geteiltes Objekt; Rueckkanal nur beobachtender §38-ProgressSink. Konsolidierung zu einer Klassenhierarchie ist NICHT geboten — geboten ist der umgekehrte Schritt: **die Rollen-Naht per Fork-A-.so physisch zu trennen (dann sind es wirklich zwei Module, mit dem Dock als Vertrag).**"

**Also: R2-Antwort = ZWEI MODULE (physische Trennung an der Rollen-Naht), NIEMALS Unter-Klassen/Vererbung.** Die User-Hypothese ist in der Verantwortungs-Haelfte korrekt (Planer-Mess-Achsen steuern die CEB-AUSSTATTUNG; die CEB traegt den eigentlichen Mess-Vollzug/measurement_driver), im Klassenmodell falsch. Der Owner-KERN 05.08. ("Planer ZWINGEND eigene Binary") ist exakt die Vollzugs-Anweisung dieses seit 20.07. feststehenden Verdikts.

### A.2 Verantwortungs-Kartierung des measurement_driver (AUDIT-20.07. Anhang B :81-83, code-verankert)

- **PLANER-Anteil (rein lesend/enumerierend/emittierend, KEIN Bau, KEINE Messung):** `ce/libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp` — ExperimentPlanDirector, EIN dreistufiger Walk Mess-Kombination → System-Perm (opt×simd) → Steps; `measurement_combos_of` ("Sie bestimmt den CEB-TYP"); PlanBuildSemantic (CMAKE_BUILD_TYPE, measurement_on, 1-Thread); IPlanBuilder-Familie: PlanTextBuilder/CMakeGraphBuilder/CiYamlBuilder (Stufe 1) + TierCiYamlBuilder/TierCmakeGraphBuilder (Stufe 2 = CEB-ROLLE derselben Binary). Fassaden: `profile_run_facade.cpp` construct_plan_into (RegistryTrio) + dump-/emit-Fassaden.
- **CEB-Anteil (der eigentliche Mess-VOLLZUG):** run_profile (`profile_run_entry.hpp:190`) und run_experiment_profile (`experiment_run_entry.hpp:136`) → der EINE Treiber `run_lazy_static_then_dynamic` (`builder/experiment_tree/cache_engine_builder_iterator.hpp:740`): Bau-Iterator, Zwei-Phasen-Op-Schleife/Mess-Visitor measure_under_setting, run_observable_perm/run_workload_perm (harness/perm_runner.hpp), CSV-Schreiber.
- **Vertrag zwischen beiden:** das EINDIMENSIONALE Planer-Dock hinab + beobachtender §38-ProgressSink hinauf (sparse, messdatenfrei); Isomorphie ueber geteilte Single-Source-Naehte + Contract-Test.

### A.3 Stufen-/Rollen-Gesetz dahinter (Ledger, verbatim)

- LEDGER:2258 (§30.5, User-Entscheid 19.07.): "Die **Mess-Achsen-Permutation wandert von der CEB in den PLANER** — der Planer kompiliert den CEB gleich nach dem gewuenschten Messsystem. **Stufen-Zuordnung: Planer = Mess-Achsen · CEB = System-Achsen · Tier-Binaries = Organ-Achsen** + Hybrid-Einschub."
- LEDGER:2259 (§30.6): "Der **Planer bestimmt das Messsystem und kompiliert HART ein effizientes CEB** fuer dieses Messsystem → der **CEB kompiliert Tier-Binaries** … → Heuristik-Hybrid (rekursive Delegation)."
- LEDGER:2251 (§30 V7.2-Zusatz 26.07.): "die **CEB-Rolle = NUR Kompilation + System + Scheduling** der Binary-Basics; die alte Relation 'System steuert die Mess-Auspraegung' ist **OBSOLET**."
- LEDGER:2403 (§40.b, User verbatim): "Der **Experiment-Planer steuert die Bau-Jobs von CEBs** und die **CEBs steuern Bau-Jobs von Tier-Binaries**." — keine Stufe ueberspringt die andere; Tier-Job-Emission = CEB-Hoheit.
- LEDGER:3315 (§62-B, User verbatim — der #54-Kern, koppelt R2): "Die CEB PIPED die Shell-/Status-Ausgaben an den PLANER weiter — der Planer ruft die emittete CEB auf und STEUERT sie: **der Planer wird aufgerufen, die CEB per XML-ANWEISUNG zu INSTRUMENTIEREN**, um mit ihr Batches von Tier-Binaries zu bauen und auf Mess-Tauglichkeit zu pruefen. (… koppelt an §38-Rueck-Kanal, R2-Driver-Split [#35-Naehe] …)"
- KETTE-AUDIT soll.md:12 (§24.C-Statik, User 18.07. woertlich): "Weil wir aber eine Kette Experiment-Planer -> CEB -> Tier-Binary laufen, sind die dynamischen Einstellungen der vorhergehenden Stufe, oft die zu uebernehmenden compile Time Draehte der gebauten nachfolgenden Stufe." (= die Haupt/Unter-DELEGATIONS-Statik, auf die das R2-Verdikt verweist.)

### A.4 R2 x Owner-KERN 05.08. (Supersession-Kette sauber)

Memory `project_post_v3_anforderungen_so_abi_driver_split_cli.md` (OWNER-KERN-VERSCHAERFUNG 05.08., verbatim-treu): "**Der Planer ist ZWINGEND eine eigene Binary mit dem User-CLI-Interface auf der Shell**" — R3 von Wunsch zu HARTER Struktur-Pflicht; NACHTRAG mittag-1: "F1 HARTES GO Planer-Binary-Split VOR ABGABE ('sonst werden die Binaries aller Stufen nicht korrekt gebaut')" (LEDGER:4031-4032 verbatim). Damit ist der seit 20.07. benannte "konstruktive Schritt" (physische Modul-Trennung) vom Post-v3-Strang in die Vor-Abgabe-Pflicht gehoben. KEIN Widerspruch: PV-2 sagte schon "Konsolidierung NICHT geboten, sondern physisch trennen"; 05.08. terminiert nur den Vollzug.

Wichtig fuer die Bauwelle: Der volle Fork-A-.so-Schnitt (dlopen-CEB, R1) ist davon TRENNBAR — R1 bleibt eigener Pruef-/Post-Strang (KETTE-AUDIT synthese.md:86: Textemission "im Code als bewusster Entscheid markiert", S5-P4/#19). Der Binary-Split des PLANERS (F1) verlangt den .so-Schnitt NICHT als Voraussetzung: die Live-Uebergabe Planer→CEB ist heute emittierter CMake-/YAML-Text + Env und bleibt es bis zum R1-Entscheid.

---

## B. FRAGE-1-VOLLZUGS-SPEZIFIKATION — WIE der Planer als eigene Binary zu schneiden ist (aus dem Korpus)

### B.1 Schnitt-Linie (wo getrennt wird)

- **Die Rollen-Naht ist im Code bereits benannt und CLI-sichtbar:** ist-planer.md:22: "`plan ci|cmake` = Planer-Rolle (traegt das bestandslog planer_block-Gate, main.cpp:293-368, 384-408), `tier ci|cmake` = CEB-Rolle (explizit KEIN planer_block, main.cpp:410-430)." · synthese.md:71: Rollentrennung heute "nur ueber CLI-Modi + planer_block-Gate".
- **Vollzugs-Form (Audit-Rueckfrage 1, praezise formuliert):** synthese.md:113: "physischer Split (**eigenes add_executable, Planer-Subkommandos wandern, CEB-Rolle bleibt im Treiber**)".
- AUDIT-20.07.:72 (Anhang A, Vorleistung e): "Der geteilte Director-Walk (`experiment_plan_director.hpp`) haelt Planer- und CEB-Rolle bereits strukturell synchron — ein Schnitt koennte **exakt an dieser Rollen-Naht** trennen."

### B.2 Was in die Planer-Binary wandert

Aus AUDIT-20.07.:81 + BAUPLAN + soll.md Glied 1/2/3:
1. **Director + Stufe-1-Builder:** ExperimentPlanDirector, IPlanBuilder-Interface, PlanTextBuilder (`plan dump`), PlanSizeBuilder, CMakeGraphBuilder, CiYamlBuilder (ceb:build/emit/trigger-Emission) + plan_legend.
2. **XML-Interpretation/Resolve:** RegistryTrio-Lesen (read_axis_registry_trio, EIN Parser, CMake-Interface-Pfade), validate-Pre-Flight-Gate (validate_profile.hpp-Linie), Root-Tag-Sniff beider Wurzeln, kuenftig #19-Resolver (deferred Band-C).
3. **Mess-Achsen-Traegerschaft:** measurement_combos_of/select_measurement_combo — die Mess-Kombination bleibt aeusserste Walk-Ebene ("STUFE 1 = Mess-Achsen-Stufe", director:683).
4. **Planer-Eigen-Stempel:** planner_version.hpp (X.Y.Z + ISA/OS; LEDGER §43.b:3444 "nur ueber die eigene statische Versionierung und unter welcher ISA/OS er passt"; §64: "PLANER = EINZIGE Binary mit EINEM X.Y.Z"). KEINE Achsen-Arrays ("der Planer permutiert, er ist keine Permutation").
5. **Bestandslog-Planer-Block:** LEDGER:3323 (§62-B): "ein Planer blockt einen Compile einer CEB DIREKT im Log ohne ETA mit einer Reservierung von 30 Minuten fuer diese Version" (heute planer_block-Gate an `plan ci|cmake`).
6. **NEU per F7 (Owner 05.08., LEDGER:4031 verbatim):** Rueck-Leser — "Ja klar, er ist eine eigene Binary und die CEB laeuft eigenstaendig, wie soll sonst der Planer dem User feedback ueber die zurueckgeschriebenen Messwerte und durch CEB kompilierten Tier-Binaries geben?" → der Planer liest progress.cursor/result.csv-Stamps/Bestandslog RUECK und traegt den `--status`-Aggregator (schliesst Regression R-G4/5: "progress.cursor konsumentenlos, ProgressSink 'REINER BEOBACHTER'", synthese.md Abweichung 3).

### B.3 Was in der CEB bleibt (NICHT wandert)

- **Stufe-2-Emission = CEB-Hoheit (§40.b):** TierCiYamlBuilder/TierCmakeGraphBuilder (`tier ci|cmake`) bleiben bei der CEB-Rolle/dem Treiber — "die Tier-Job-Emission ist CEB-Hoheit (§37.b-Delegation), nicht Planer-Hoheit" (LEDGER:2403).
- **Der eigentliche measurement_driver/Mess-Vollzug:** run_profile/run_experiment_profile → run_lazy_static_then_dynamic (lazy O(K), StaticBinaryView, RuntimeVariableLoop), SlicePlanner/SlicePlanQueue (kGnBatchSlice==kBuildSliceGrain==4096), ram_spool 256MB + SpoolWriter, Pruef-Dock/Conformance-Gate ("import → GATE → messen"), Tier-Bau (BuildOrchestrator g++ @rsp+posix_spawnp), Selbst-Rueckschrieb (EIN CSV je Zelle, MeasurementSinkFn, messwert_registrierung → Bestandslog-XML/MinIO; §42.b: CEB schreibt SELBST, NICHT uebers Dock), ProgressSink-Feuerung.
- **Freigabe-Auswertung = CEB-Laufzeit-Logik** (LEDGER:2358): Zulaessigkeits-Filter (Organ ≤ System-Freigabe) sitzt an der CEB-Bau-Delegations-Naht, "nicht im Tier und nicht im Planer".

### B.4 Wo die Binary lebt (Repo-Zuordnung)

- LEDGER:2421 (§42, User verbatim): "Nur die **Delegation an den XML-Planer gehoert in die Diplomarbeit** und das **Holen der Messergebnisse** … **Eigentlich erhaelt die Cache Engine die XML und uebernimmt die gesamte Arbeit (delegiert von Diplomarbeit). Die CI ist falsch und das Konzept der lokalen Compile damit auch.**" → Planer-Binary-Target gehoert in die CE-lib-Welt; super/02_messung_driver bleibt duenner Delegations-Aufrufer (LEDGER:2426: "super-CI enthaelt NUR (a) Delegation der Anwender-XML an die CE-Framework-lib und (b) Ergebnis-Holen").
- BAUPLAN:32 (Phase 1): "ein `comdare_experiment_planner`-App-Target schaffen"; Blaupause BAUPLAN:40: "cmake/catalog_codegen.cmake:27-37 (add_custom_command + COMMAND $<TARGET_FILE:...>); App-Muster apps/catalog_codegen_tool".
- ABER Bau-Doktrin soll.md 1.7 (BAUPLAN Kritik-Blocker :4 + Befund :222): "PHASE 0 noetig: super-Repo reconcilen (execute_messreihe fuellen/wiederverwenden) **STATT neuen Director daneben bauen**" — kein dritter Parallel-Engine-Bau; am offiziellen Einstieg andocken/umziehen, nicht duplizieren. (Der Director existiert inzwischen; die Doktrin heisst fuer den Split: bestehenden Code UMZIEHEN, keinen zweiten Walk anlegen.)
- Storage-Konsequenz LEDGER:2273 (§31-A4, User verbatim): "**Der CI-Cache haelt NUR den Experiment-Planer als statisch gebaute Binary.**" — prod-MinIO Ebene B traegt alle GENERIERTEN Folge-Stufen (CEB je Messsystem + Tier + Hybrid + Sidecars).
- Universalitaet LEDGER:3306 (§62-A): "Der PLANER ist ANSPRUCHSLOS: er muss auf JEDER Maschine bauen koennen … schreibt der Planer WARNUNGEN ins Log bzw. auf die spaetere CLI-Shell (R3/#34) — kein Vorfilter, keine stille Auslassung."

### B.5 CLI-Grammatik (ist beschlossen UND grossteils gebaut)

- **Subkommando-Umbau ist Owner-entschieden:** LEDGER:3589 (73.6): "**Q7: CLI-Subcommand-Umbau (clig.dev) JETZT in V-6.**" — gelandet: ist-planer.md:20: "Subcommand-Dispatcher canonicalize_cli main.cpp:589-684; Subkommandos **`validate | plan dump/ci/cmake | tier ci/cmake | cache-key | fingerprint | run | version | help`** (Hilfe main.cpp:551-577), `--help/-h`/`--version` kanonisch; Alt-Flags als DEPRECATED-Aliase; **Exit-Code-Grammatik 0/1/2/5/6/7**." Audit-Verdikt: "das Shell-CLI selbst VOLL konform" (synthese.md:24).
- **R3-Ausbau-Reihenfolge (Owner-GO 20.07., LEDGER:3247):** "1. CLI-Haertung (R3: **run <xml>/--profile + --help-offizieller-Weg + --print-env -> --status-Aggregator -> %/ETA/JSON-Marker -> lokales Stufe-1->2-Kommando**) …" — soll.md:92 fuehrt als offen: "--print-env, --status-Aggregator, %/ETA/JSON-Marker".
- **R3-Kernsatz (LEDGER:3243, §60-R3):** "soll der **Planer als CLI** ausgerichtet sein, auf der Shell mit umgaenglichem User-Interface steuerbar; der Planer soll **Zustand/Builds/Messungen der CEB und der Tier-Binaries LOGGEN**, damit der Nutzer den Stand kennt. Der User will das Programm spaeter **manuell mit der XML-Config fahren** koennen."
- **Verteilung nach dem Split:** Planer-Binary traegt validate/plan */cache-key/fingerprint/version/help + kuenftig run/status (User-Interface); `tier ci|cmake` (CEB-Rolle) verbleibt beim Treiber/der CEB — deckungsgleich mit der Schnitt-Linie B.1.

### B.6 Kopplungen, die der Split MIT erfuellen muss (Regressions-Register des Kette-Audits)

synthese.md:75-82: R-G1 (Planer-Binary fehlt — KOPF, "koppelt R2-Modul-Schnitt") · R-G3 (keine harte CEB-Kompilation je Messsystem: ceb:build baut generischen Treiber, [a,b,c] zur Laufzeit per COMDARE_MEASUREMENT_COMBO = von §30.6 ausgeschlossene Runtime-Konfiguration, durch KEINEN Deferred-Posten gedeckt) · R-G4/5 (§38.b-Fertig-Signal ohne Rueck-Leser → per F7 jetzt Planer-Pflicht) · R-G2 (Registry-Kanon-Divergenz validate=2er vs plan=3er — beim Umzug vereinheitlichen). §38.b (LEDGER:2371ff): messende CEBs SEQUENTIELL; der §38-Rueck-Kanal ist das Fertig-Signal der Planer-Sequenzierung.

---

## C. EHRLICHE TRENNUNG

### BEANTWORTET (im Korpus, mit Fundstelle)
1. R2 zwei Module vs. Unter-Klassen → **ZWEI MODULE, keine Vererbung; Konsolidierung zu Klassenhierarchie NICHT geboten; physische Trennung an der Rollen-Naht ist der beschlossene Schritt** (LEDGER:3252 PV-2; AUDIT-20.07.:35/:85).
2. Was misst wer → Planer = Mess-Achsen/Ausstattung/Emission, KEIN Bau/KEINE Messung; CEB = eigentlicher measurement_driver/Mess-Vollzug + Tier-Bau + Rueckschrieb (AUDIT-20.07.:81-83; LEDGER:2251/:2258/:2403).
3. Schnitt-Linie → Rollen-Naht am Director; Planer-Subkommandos wandern, CEB-Rolle (`tier ci|cmake` + Lauf-Pfade) bleibt (synthese.md:113; ist-planer.md:22; AUDIT-20.07.:72).
4. Repo/Target → CE-Welt traegt die Arbeit (App-Target nach catalog_codegen-Blaupause, BAUPLAN:32/40), super nur Delegation+Ergebnis-Holen (LEDGER:2421/2426); CI-Cache haelt NUR den statischen Planer (LEDGER:2273); Planer anspruchslos/universal (LEDGER:3306).
5. CLI-Grammatik → clig.dev-Subkommandos (Q7 "JETZT", LEDGER:3589), Bestand validate|plan|tier|cache-key|fingerprint|run|version|help + Exit 0/1/2/5/6/7 (ist-planer.md:20); Ausbau-Reihenfolge R3 (LEDGER:3247).
6. Rueck-Leser → JA, Planer-Pflicht (Owner F7 verbatim, LEDGER:4031); CEB laeuft eigenstaendig; Kanal = §38-Cursor (sparse, messdatenfrei) + result.csv/Bestandslog.
7. Timing → Split VOR Abgabe Fr 08.08. (Owner F1 verbatim, LEDGER:4031-4032).

### WIRKLICH OFFEN (kein Korpus-Beleg als Entscheid gefunden)
1. **Fork-A-Interim-Haerte (Audit-Rueckfrage 4):** Ob bis zur echten CEB-Generierung je Messsystem die Env-Differenzierung (COMDARE_MEASUREMENT_COMBO) interim geduldet ist oder mindestens ein -D-Compile-Define in den ceb:build-Job muss. Der PLAN sagt nur das Ziel (§30.6 HART kompiliert, "nicht runtime-konfiguriert"); eine Interim-Duldung ist NIRGENDS dekretiert — nach F6 ("sauberster Weg NACH PLAN, NIE RATEN") spricht der Korpus fuer mindestens die Compile-Define-Haerte im Split, ein expliziter Owner-Entscheid fehlt.
2. **R1-.so-Entscheid (Audit-Rueckfrage 3):** Textemission dauerhaft kanonisieren vs. Fork-A-.so-Strang — Korpus-Stand: bewusst DEFERRED, Pruef-Auftrag §60-R1 offen; die 20.07.-Analyse EMPFIEHLT Wiedereinfuehrung fuer die Steuerung (nicht Daten) — aber das GO ist nicht erteilt. (Der Planer-Binary-Split haengt daran NICHT.)
3. **Exakter Zielort/Name des neuen Targets:** `comdare_experiment_planner` (BAUPLAN Phase 1) vs. Umbau des super-Treibers zu zwei Binaries — die Doktrin-Lage (CE traegt die Arbeit + kein Parallel-Bau + super=Delegation) grenzt es ein, ein woertlicher Owner-Satz "Target X liegt in Repo Y" existiert nicht.
4. **Traeger-Mechanik des §38.b-Fertig-Signals nach dem Split (Audit-Rueckfrage 7, Rest):** F7 bejaht den Rueck-Leser; ob die resource_group-Sequentialisierung daneben bestehen bleibt oder der Planer die CEB-Sequenz selbst taktet, ist nicht woertlich entschieden (Korpus-Richtung: §38.b nennt den Rueck-Kanal "das Fertig-Signal der Planer-Sequenzierung").

---

## D. Chronologie/Supersessions (aufgeloest)
19.07. §30 (Stufen-Zuordnung + HART-Kompilation, Fork A verschaerft) → 20.07. §60-R1/R2/R3 + deprecated-Audit (R2 analyse-beantwortet: Delegation, physisch trennen) → 20.07. nacht §60-SCHLUSS PV-2 (Status fixiert) → 21.07. §62 (Planer universal, #54 XML-Instrumentierung, Bestandslog) → 26.07. V7.2 (CEB-Rolle=NUR Kompilation+System+Scheduling) → 27.07. 73.6 Q7 (clig.dev JETZT; gelandet f5cf3954-Linie) → 05.08. Owner-KERN (eigene Binary PFLICHT) + Kette-Audit (R-G1 KOPF-Regression) → 05.08. mittag-1 F1 HARTES GO vor Abgabe + F7 Rueck-Leser JA. Keine Supersession kehrt eine aeltere R2-Aussage um; die Kette verschaerft monoton in Richtung physischer Zwei-Modul-Schnitt.
