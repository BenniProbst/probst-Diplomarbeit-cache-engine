# SYNTHESE — Konformitaets-Verdikt der Planer→CEB-Vertragskette (adversarial)

Datum 2026-08-05 · Objekt ce=b09ebb8a (READ-ONLY) + super/02_messung_driver · Basis: soll.md, ist-planer.md, ist-ceb.md (vollstaendig gelesen) + eigene Stichproben am Objekt.

**Stichproben-Protokoll (alle Lens-Kernbehauptungen am Objekt VERIFIZIERT):**
- super/02_messung_driver/main.cpp:552 verbatim "comdare-messung-driver -- Planer- + CEB-Rolle in EINEM Binary"; Subkommando-Grammatik + Exit-Codes 0/1/2/5/6/7 (main.cpp:551-577). Vollabsuche add_executable in ce/apps+ce/tools: KEIN Planer-Target (18 Treffer, alle klassifiziert).
- experiment_plan_director.hpp:769-781: ceb:build-Job = `cmake --build build --target comdare-messung-driver` + "[CEB-TESTAT] ... status=gebaut" — der "CEB-Bau" ist die Rekompilation des generischen Treibers.
- experiment_dock_payload.hpp:57-64: DEPRECATED-Block S5-P4-Ruling 20.07. verbatim ("Band-C DEFERRED (Task #19)", "von keiner Live-Call-Site konsumiert", never-delete); AxisRangeEntry/ExperimentSubtreePayload (:45-72) exakt der SOLL-Teilbaum als Ranges je Achse.
- director:37 "Resolver annotiert, entscheidet nicht — STUFE §3.C.3 E-RES-C"; profile_run_facade.cpp:852-857 graceful INERT + "KEIN Exit!=0 im run/build-Pfad"; validate_profile.hpp:1218-1220 harter Fehler "UNBEKANNTE Achse ... r.ok=false" (ce-Registry).
- pruef_dock/: grep gtest = 0 Treffer; conformance_gate.hpp:1-9 "Reihenfolge bindend: import → GATE → (nur bei pass) messen", Oracle std::map.
- kGnBatchSlice=4096 (director:542) == kBuildSliceGrain=4096 (planer_driven_build.hpp:46); ram_spool.hpp:21 kMaxSpoolBytes=256MB.
- driver main.cpp:1391-1394 "REINER BEOBACHTER ... der Sink beobachtet den Cursor, er steuert nichts"; progress.cursor nur Schreiber, kein Rueck-Leser.
- NEU (Korrektur zum SOLL-§52-B14-Reststand): resource_group "ceb-measure-<host>" ist am Build-Batch UND am Mess-Batch emittiert (director:1104, :1239, P4-Literal-Reuse) — Restpunkt (3) ist am Objekt GESCHLOSSEN.
- planner_version.hpp existiert (profile_facade/planner/) — Planer-Eigen-Version SOLL-konform vorhanden (1.5).

---

## Verdikt je Kettenglied

### Glied 1 — Planer = eigene Binary mit User-CLI: **REGRESSION** (CLI-Anteil konform)

SOLL (Owner-KERN 05.08., soll.md 1.1 verbatim-treu): "Der Planer ist ZWINGEND eine eigene Binary mit dem User-CLI-Interface auf der Shell" — "R3 damit von Ausrichtungs-Wunsch zu HARTER Struktur-Pflicht"; **Abweichung = Regression** per Owner-Definition.
IST: Es gibt KEINE eigene Planer-Binary. Der Planer ist eine Rolle im comdare-messung-driver — Selbst-Deklaration super/02_messung_driver/main.cpp:552 "Planer- + CEB-Rolle in EINEM Binary"; profile_run_facade.cpp:971 "heute EINE Binary in zwei Rollen"; Vollabsuche ce/apps+tools ohne Planer-Target (eigene Stichprobe).
KONFORM darin: das Shell-CLI selbst ist VOLL da (clig.dev-Subkommandos validate|plan dump/ci/cmake|tier ci/cmake|cache-key|fingerprint|run|version|help, Exit-Grammatik, main.cpp:551-577); Mess-Achsen-Traegerschaft erfuellt (PlanMeasurementCombo = aeusserste Walk-Ebene, director:1969-1998); manuelles Fahren mit XML-Config erfuellt (Profil-Aufloesung Argument > COMDARE_THESIS_PROFILE > Default); Planer-Eigen-Version planner_version.hpp da (1.5); Zustands-/Build-/Mess-Logging existiert als Testat-/Progress-/Heartbeat-Grammatik.
Einordnung: Die Ein-Binary-Gestalt ist im Code EHRLICH dokumentiert (kein stiller Verfall) und war bis zum Owner-KERN 05.08. als W3-Rollentrennung gedeckt — der KERN 05.08. hebt sie aber zur harten Struktur-Pflicht; damit ist der Ist-Stand ab 05.08. formal REGRESSION mit klarem Umbau-Auftrag (physischer Binary-Split, koppelt R2).

### Glied 2 — XML-Interpretation (3 Registries + Anwender-XML, .pom-Resolve): **TEIL-KONFORM**

SOLL (2.1-2.3): Registries = ANGEBOT, Anwender-XML = ANZEIGE, Planer = Resolver/Linker; "Unregistriertes = harter Validierungsfehler statt stillem Verhalten"; 3 art-spezifische Registries.
IST konform: Parse beider offizieller Wurzeln real (Root-Tag-Sniff, facade:843-905; unbekannte Wurzel => rc 5); 3-Registry-Trio real gelesen (read_axis_registry_trio, validate_profile.hpp:715-722, EIN Parser, CMake-Interface-Pfade — SOLL 2.6-konform, kein Python, Configure-/Planer-Zeit); harter Validierungsfehler fuer Unregistriertes EXISTIERT und gated den Mess-Lauf als Pre-Flight VOR jedem Bau (validate_profile.hpp:1218-1231 "UNBEKANNTE Achse ... r.ok=false"; facade:996-999) — verifiziert.
IST abweichend: (a) Der Resolver im PLAN-Pfad ist reine ANNOTATION ("Resolver annotiert, entscheidet nicht", director:37; graceful INERT bei fehlender Registry, facade:852-857) — im Emissions-Pfad ist Unregistriertes NICHT hart; (b) Registry-Satz-DIVERGENZ: validate-Gate = 2-Registry-Kanon (ce+prt), Plan-Pfad = 3er-Trio — zwei Kanons je Pfad; (c) der volle .pom-Link (LinkedExperimentPlan, 5-tiefer #19-Resolver) ist Band-C DEFERRED #19 (im Code markiert).
Verdikt: Kern des Vertrags (Angebot+Anzeige lesen, harter Fehler vor jedem Bau) steht; Voll-Link bewusst deferred; die Pfad-Divergenz (a)+(b) ist der echte Rest.

### Glied 3 — Planer BAUT die CEB (GoF, HART kompiliert je Messsystem): **TEIL-KONFORM** (Kernsatz-Verstoss = benannte Regression)

SOLL (3.1/3.2 verbatim): "kompiliert HART ein effizientes CEB" je Messsystem, "nicht runtime-konfiguriert"; Fork A VERSCHAERFT ENTSCHIEDEN: CEB = GENERIERTE+kompilierte Binary je Messsystem.
IST konform: GoF Director+Builder REAL (ExperimentPlanDirector::construct + IPlanBuilder, 6 ConcreteBuilder, EIN deterministischer Walk — director:1719-1827, 1950-1998); Fan-out multipler CEBs je <measurement_tooling>-Combo real (measurement_combos_of :1909-1927, leer => [all] = vereinter Tooling-Default §64 KONFORM); sequentielle Mess-CEBs §38.b real via resource_group (verifiziert :1104/:1239 + ceb-<slug> :761) + 1-Thread-Messpolitik; zweistufige Steuerung §40.b real (Planer emittiert ceb:*, CEB emittiert tier:*); CEB-Stempel = Mess-Angebot [a,b,c]+SHA512, bewusst zellwertfrei (ceb_version_stamp.hpp W10-C3).
IST-VERSTOSS (verifiziert): Der Planer kompiliert NICHTS hart je Messsystem. Der emittierte ceb:build-Job baut per `cmake --build build --target comdare-messung-driver` stets DENSELBEN generischen Treiber (director:769-770) und testiert ihn als CEB (:776-781); die Messsystem-Differenzierung [a,b,c] kommt zur LAUFZEIT per Env COMDARE_MEASUREMENT_COMBO in dieselbe Binary — exakt die von §30.6 ausgeschlossene Runtime-Konfiguration. Kein im Ledger markierter Deferred-Posten deckt diese Luecke (R1/#19 deckt die ABI-/Payload-Form, nicht die Kompilat-Spezialisierung); im Code nur als "heute EINE Binary in zwei Rollen" ehrlich dokumentiert (director:903-905).

### Glied 4 — Experiment-Dock-Vertrag (serialisierter Teilbaum, Ranges je Achse; R1): **BEWUSST-DEFERRED** (Vertragsform) / TEIL-KONFORM (Rueck-Kanal)

SOLL (4.1): Nutzlast = serialisierter UNTERER TEILBAUM, System+freigegebene Organ-Achsen als RANGES je Achse. SOLL (4.4): R1-Notiz — Textemission als bewusster Ist-Vertrag markiert, .so-ABI deferred mit Pruef-Auftrag.
IST: Das Wire-Format existiert VOLLSTAENDIG und getestet (AxisRangeEntry AxisKind-gefaerbt, enumerated/index_range; ExperimentSubtreePayload; emit/parse + Byte-Roundtrip) — aber per S5-P4-Ruling 20.07. DEPRECATED/inert, verbatim am Objekt verifiziert (experiment_dock_payload.hpp:57-64): Live-Kette reicht die Ranges ueber EMITTIERTEN CMake-/YAML-TEXT + Env; volles Wire-Format "Band-C DEFERRED (Task #19)"; POD bleibt als Referenz-Serialisierung (never-delete). **Damit ist die R1-Forderung der SOLL-Lens ERFUELLT: die Textemission ist im Code selbst als bewusster Entscheid markiert — kein stiller Doktrin-Verlust.**
Live-Uebergabe real: CEB liest die autoritative XML SELBST erneut (COMDARE_THESIS_PROFILE-Pin), System-Achsen als Env-EINZELWERTE (COMDARE_GN_OPT/_SIMD), Organ-Raum als LINEARES Index-Fenster COMDARE_GOLDEN_N_RANGE=start:count — keine per-Achse-Ranges im Draht; das ist durch #19-Deferral gedeckt.
§52-B14-Reststand aktualisiert: (2) Payload — die sanktionierte Option "deprecaten" wurde vollzogen: ERLEDIGT. (3) resource_group am Mess-Job — am Objekt GESCHLOSSEN (director:1239, eigene Stichprobe; der SOLL-Katalog ist hier veralteter als das Objekt). (1) ProgressSink-Konsument/Planer-Sequenzierung — OFFEN (s. Glied 5).
.so-ABI: nicht vorhanden, DEFERRED mit offenem §60-R1-Pruef-Auftrag (Owner-Entscheid).

### Glied 5 — CEB fuehrt aus (Command, lazy, 4096, Pruefstand, Rueckschrieb, #54): **TEIL-KONFORM** (Kern-Maschinerie konform; 3 benannte Abweichungen)

KONFORM (alles verifiziert bzw. von beiden Lenses uebereinstimmend belegt):
- Lazy Permutation: run_lazy_static_then_dynamic, StaticBinaryView O(K), RuntimeVariableLoop ohne Neu-Bauen (iterator:1-27, 1198ff); Legacy-eager-PermutationLoop sauber als Demo-Strecke getrennt.
- Batch CEB-INTERN 4096: zweifach verankert kGnBatchSlice==kBuildSliceGrain==4096 (director:542 / planer_driven_build.hpp:46, verifiziert), SlicePlanner/SlicePlanQueue Producer-Consumer, Fenster-Schleife INNERHALB EINES Batch-Jobs je Host — der Ledger-:3316-IST-VERSTOSS (Einzel-Job je Perm×Chunk) ist BEHOBEN (O(Maschinen)-Emission, director:541).
- RAM-Puffer: ram_spool 256MB/12-Trigger + SpoolWriter-Thread mit io_uring/portablem Backend (ram_spool.hpp:21 verifiziert) — erfuellt §62-B-NACHTRAG-2 fuer Bau-Artefakte; in_memory_measurement_buffer/ ist leerer Platzhalter (unmarkierte Luecke, klein).
- Pruefstand VOR Messung: bindend "import → GATE → (nur bei pass) messen" (conformance_gate.hpp:1-9 verifiziert), gattungs-sequentiell, COMDARE_PRUEF_ONLY-Standalone je Perm nach der Fenster-Schleife ([PRUEF-TESTAT]).
- Rueckschrieb durch die CEB SELBST, NICHT uebers Dock: result.csv+stamp je Binary mit Resume/stale, EIN CSV je Zelle nach measure_out/<slug>/perm<idx> (SOLL §42.b woertlich erfuellt), MeasurementSinkFn→measure-drop, messwert_registrierung→Bestandslog-measurement-XML (MinIO). Praezisierung gegen die IST-CEB-Lens: SOLL 5.5 fordert Rueckschrieb "ans in der XML GENANNTE Ziel", NICHT in die Anwender-XML — die CSV/measurement-Ziele sind die richtige Leserichtung; kein Verstoss.
- Rueck-Kanal §38: sparse, messdatenfrei, done-einmal, mixed-radix (progress_delta.hpp; "KEIN Mess-Daten-Rueckfluss") — SOLL-konform.
- Layer-Trennung: aeussere System-Schleife (Perm je opt×simd) vs inneres Organ-Fenster strukturell getrennt; Tier = [d,e,f][g,h,i]-Schichtung in der Testat-Grammatik.
- Tier-Bau durch die CEB real: BuildOrchestrator, g++-16 @rsp+posix_spawnp, RAM-Admission, .version-Sidecar-Resume, realer Anatomie-Emitter generate_all_real getrennt vom Diagnose-Stub.

ABWEICHUNGEN:
1. **Kein GTest im Pruefstand** — SOLL §62-B verbatim "ueber den Aufruf von GOOGLE-TESTS als PRUEFSTAND"; IST = eigenes std::map-Oracle-Gate (grep gtest in pruef_dock/ = 0, verifiziert). Funktion voll gedeckt (Konformitaet ueber alle Randfaelle, bindende Reihenfolge), Werkzeug weicht ab, KEINE Deferred-Markierung → formale Regression, Owner-Rueckfrage.
2. **#54-Instrumentierung per Env/Job-Text statt "per XML-ANWEISUNG"** — real ist die Instrumentierung (Profil-Pin, Range-Fenster, Combo-Selektor, ccache, Modi-Schalter) im emittierten Shell-Text; keine XML-Anweisungs-Datei. Semantisch nah (die Anweisungen SIND aus der XML abgeleitet und pinnen die XML), Wortlaut nicht erfuellt.
3. **Status-"Pipe" = Trace/stderr/progress.cursor-Datei, kein lebender IPC** — es gibt keinen residenten Planer-Prozess (Folge der Glied-1-Regression); Sequenzierung leistet die resource_group, der Cursor ist "REINER BEOBACHTER" (main.cpp:1391-1394 verifiziert), progress.cursor hat keinen Rueck-Leser. §38.b-Fertig-Signal traegt damit NICHT die Planer-Sequenzierung.
4. Command-Pattern: Laufzeit-GoF-Command nur als eingefrorene V32-Insel (GEPARKT #267, 0-Konsumenten-Beweis); Live-Nachfolger = compile-time AxisCommand — im Licht des CT-Kanons (Statischer Dispatch, CT→RT rueckkorrigieren) architektur-konforme Fortschreibung, dokumentiert, KEIN stiller Verlust → kein Regressions-Eintrag.

---

## Owner-KERN 05.08. hart geprueft: Planer als EIGENE Binary mit Shell-CLI?

**Antwort: TEILWEISE — Shell-CLI JA (voll), eigene Binary NEIN.**
Beweis: (a) Shell-CLI vollstaendig (Subkommando-Dispatcher canonicalize_cli main.cpp:589ff, Hilfe-/Exit-Code-Grammatik :551-577, DEPRECATED-Alt-Flags kanonisch migriert); (b) eigene Binary existiert nicht — main.cpp:552 deklariert selbst "Planer- + CEB-Rolle in EINEM Binary", ce-Repo hat kein Planer-Target (Vollabsuche add_executable, eigene Stichprobe), der physische R2-Split hat nicht stattgefunden (Rollentrennung nur ueber CLI-Modi + planer_block-Gate, main.cpp:293-430). Da der Owner-KERN Abweichung ausdruecklich als Regression definiert, ist dies DIE Kopf-Regression der Kette.

---

## Regressionen (JETZT-Pflicht verletzt) — klar getrennt von deferred/nach-Abgabe

1. **[Glied 1] Planer nicht als eigene Binary** (Owner-KERN 05.08. = harte Struktur-Pflicht; "Planer- + CEB-Rolle in EINEM Binary", super main.cpp:552; kein Planer-Target im ce-Repo). R2-Split unvollzogen.
2. **[Glied 3] Keine harte CEB-Kompilation je Messsystem** (Fork A ENTSCHIEDEN [JETZT]): ceb:build rekompiliert den generischen Treiber (director:769-770), Messsystem-Differenzierung zur Laufzeit per COMDARE_MEASUREMENT_COMBO in dieselbe Binary = die von §30.6 ausgeschlossene Runtime-Konfiguration; durch KEINEN markierten Deferred-Posten gedeckt.
3. **[Glied 5] Pruefstand ohne GTest** (§62-B verbatim "GOOGLE-TESTS"): std::map-Oracle-Gate funktional aequivalent, Werkzeug-Abweichung unmarkiert.
4. **[Glied 5/#54] Instrumentierung per Env im Shell-Text statt per XML-ANWEISUNG** (§62-B-Wortlaut).
5. **[Glied 4/5] §38.b-Fertig-Signal ohne Planer-Konsumenten**: ProgressSink/progress.cursor hat keinen Rueck-Leser; Sequenzierung nur via CI-resource_group (funktional da, aber nicht ueber den dekretierten Rueck-Kanal) — §52-B14-Restpunkt (1) offen.
6. **[Glied 2, klein] Registry-Kanon-Divergenz je Pfad** (validate=2er ce+prt vs plan=3er Trio) + Unregistriertes im Plan-Emissions-Pfad nur Annotation/INERT (im Mess-Lauf hart via Pre-Flight — Kern gewahrt).

## Bewusst-DEFERRED (markiert, kein stiller Verlust) / NACH-ABGABE

- **R1 .so-ABI Planer↔CEB**: Ist-Vertrag = Textemission, im Code als bewusster Entscheid markiert (S5-P4-Ruling + "Band-C DEFERRED (Task #19)", experiment_dock_payload.hpp:57-64, verifiziert); §60-R1-Pruef-Auftrag (Wiedereinfuehrbarkeit) offen → Owner.
- **ExperimentSubtreePayload / per-Achse-Ranges im Draht**: S5-P4 DEPRECATED, never-delete, Referenz-Serialisierung fuer den #19-Resolver; §52-B14(2)-Option "deprecaten" vollzogen.
- **LinkedExperimentPlan / 5-tiefer #19-Resolver (voller .pom-Link)**: Band-C DEFERRED #19 (director D3-Designfrage offen).
- NACH-ABGABE (getrackt): System-/Mess-Achsen-Join PL-21 · COMPARE #47 · #46b-Vollausbau (Claims/Takeover/Tools-Lager) · Cross-Compile §37.3 · Arbeitsmodus/Hot-Tier-Switching.
- Vermerk (unmarkierter Platzhalter, KEIN Deferred-Etikett): builder/in_memory_measurement_buffer/ leer (.gitkeep) — Messwerte laufen ueber result.csv/MeasurementSinkFn; bei Gelegenheit etikettieren oder fuellen.

---

## ATLAS-NACHZUG (L0/L1) — Diagramm-Skizze in Worten

**L0 (eine Kette, ein Bild):** [User + Anwender-XML] → **Planer** (SOLL: eigene Binary; IST: Planer-Rolle im comdare-messung-driver — Doppel-Markierung SOLL/IST zwingend) → **XML/Registry-Resolve** (3-Registry-Trio ANGEBOT + autoritative XML ANZEIGE; validate-Pre-Flight-Gate) → **CEB-Emission** (Director-Walk → ceb:build/emit/trigger je Mess-Combo [a,b,c]) → **Experiment-Dock-Vertrag** (LIVE: Text+Env; gestrichelt daneben: Teilbaum-Payload DEPRECATED + .so-ABI R1-deferred) → **CEB-Befehle** (Batch-Job: SlicePlanner 4096, lazy Iterator, ram_spool 256MB) → **Pruef-Dock** (std::map-Oracle-Gate, import→GATE→messen) → **Tier Bau+Messen** (BuildOrchestrator g++-16 posix_spawnp → .so; 1-Thread-Messung) → **Rueckschrieb** (result.csv je Binary, EIN CSV je Zelle, Bestandslog-XML/MinIO) — plus Rueck-Pfeil **§38-Cursor** (ProgressDelta mixed-radix, messdatenfrei) als gestrichelter Pfeil zum Planer mit Marker "kein Rueck-Leser (offen)".

**L1-Sektionen (je ein Kasten-Cluster):**
1. Planer-CLI: Subkommando-Grammatik (validate | plan dump/ci/cmake | tier ci/cmake | cache-key | fingerprint | run | version | help) + Exit-Codes 0/1/2/5/6/7 + planner_version-Stempel; Anmerkung Owner-KERN 05.08. "eigene Binary PFLICHT" als offene Bau-Kante.
2. Resolve-Doppelpfad: (a) Plan-Pfad = RegistryTrio (Organ/System/Mess via CMake-Interface-Defines) → ResolverReport-ANNOTATION im Plan-Kopf (INERT-graceful); (b) validate-Gate = 2er-Kanon (ce+prt) mit HARTEM Fehler, als Pre-Flight vor jedem Bau — beide Pfade GETRENNT zeichnen (die Divergenz ist ein Befund).
3. CEB-Emission: ExperimentPlanDirector (EIN Walk: Mess-Combo → opt×simd → Steps) + 6 ConcreteBuilder (PlanText/PlanSize/CMakeGraph/CiYaml/TierCiYaml/TierCmakeGraph); Fan-out je <measurement_tooling>-Combo; resource_group ceb-<slug>/ceb-measure-<host> = §38.b-Sequentialisierung.
4. Dock-Vertrag: Live-Draht = COMDARE_GOLDEN_N_PROFILE (XML-Re-Read durch CEB!) + COMDARE_GN_OPT/_SIMD (System-Einzelwerte) + COMDARE_GOLDEN_N_RANGE start:count (lineares Organ-Fenster) + COMDARE_MEASUREMENT_COMBO; daneben ausgegraut: ExperimentSubtreePayload (Ranges je Achse, DEPRECATED S5-P4) und .so-ABI (R1 Post-v3-Pruefstrang).
5. Rueck-Kanal: ProgressDelta (Voll-Konfig → mixed-radix-Deltas → done einmal) → stderr [progress] + progress.cursor + [heartbeat]/[CEB-TESTAT]/[PRUEF-TESTAT]-Testat-Grammatik; Konsument heute = CI-Log/Mensch (gestrichelt: kuenftiger Planer-Rueck-Leser).
6. CEB-intern: SlicePlanner/SlicePlanQueue (4096==kBuildSliceGrain), ram_spool 256MB/12 + SpoolWriter (io_uring/portabel), lazy Kette StaticBinaryView O(K) → AnatomyModuleLoader → RuntimeVariableLoop.
7. Pruef-Dock: je Gattung EIN Dock (IPruefDock keine ABI-Grenze; ABI = gattungs-eigenes Antriebs-Sub-Interface), Conformance-Gate std::map-Oracle, pruef_dock_sequencer gattungs-sequentiell, COMDARE_PRUEF_ONLY-Standalone.
8. Rueckschrieb: result.csv+stamp (Resume/stale) → measure_out/<slug>/perm<idx> (EIN CSV je Zelle) → MeasurementSinkFn/measure-drop → messwert_registrierung → Bestandslog-measurement-XML (MinIO); ausdruecklich NICHT ueber den Dock-Rueck-Kanal.
9. Querschnitts-Legende an den Kanten: [a,b,c]→CEB · [d,e,f] ALLEIN→Tier · [d,e,f]+[g,h,i]+HW→Messwert — nie fusioniert (Testat-/Replay-Schichtung).

---

## OWNER-RUECKFRAGEN (nur Owner entscheidbar)

1. **Glied-1-Umbau vor Abgabe (Fr 08.08.)?** Der Owner-KERN 05.08. macht die eigene Planer-Binary zur harten Pflicht — soll der physische Split (eigenes add_executable, Planer-Subkommandos wandern, CEB-Rolle bleibt im Treiber) noch VOR der Abgabe erfolgen, oder wird er als erster Post-v3-Posten mit explizitem Owner-Segen terminiert? (Koppelt R2.)
2. **R2-Modul-Schnitt**: Wie ist der measurement_driver auf Planer und CEB zu verteilen — zwei Module oder Unter-Klassen derselben Klasse (§60-R2)? Vorbedingung fuer Frage 1.
3. **R1 .so-ABI**: Ergebnis des §60-R1-Pruef-Auftrags (Wiedereinfuehrbarkeit/Sinnhaftigkeit der Dock-.so-Doktrin, ~131k Ergebnisse) — Post-v3-Strang planen oder Textemission dauerhaft kanonisieren?
4. **Fork-A-Haerte interim**: Ist die Env-differenzierte Ein-Binary-CEB ([a,b,c] via COMDARE_MEASUREMENT_COMBO) bis zum Split als Interim akzeptiert, oder muss die Messsystem-Spezialisierung mindestens als Compile-Define (-D) in den emittierten ceb:build-Job, damit "hart kompiliert je Messsystem" formal steht?
5. **GTest-Wortlaut**: Gilt das std::map-Oracle-Konformitaets-Gate als Erfuellung von "GOOGLE-TESTS als PRUEFSTAND" (§62-B), oder ist ein GTest-Harness am Pruef-Dock nachzuziehen?
6. **#54-Wortlaut**: Ist die Env-/Job-Text-Instrumentierung (XML-abgeleitet, Profil-Pin) die akzeptierte Materialisierung von "per XML-ANWEISUNG instrumentieren", oder ist eine eigene XML-Anweisungs-Datei gefordert?
7. **§38.b-Fertig-Signal**: Genuegt die resource_group-Sequentialisierung dauerhaft, oder muss der (kuenftig eigene) Planer den progress.cursor real rueck-lesen und die CEB-Sequenz selbst takten?
