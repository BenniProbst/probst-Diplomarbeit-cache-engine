# BUENDEL-15 KARTE, GRUPPE 2: WORK_MODE + ENUM + UMBENENNUNGEN
Erhebung: 2026-08-17 am Objekt, ce development @ 04ac26fa (git log verifiziert). Read-only, keine Edits.
Pfade relativ zu Code/external/comdare-cache-engine. Regel eingehalten: alle Zeilennummern HEUTE gemessen,
nicht aus Karten uebernommen; Karten-/Ledger-Zitate tragen ihr eigenes Erhebungsdatum.

## POSTEN 1: A-05 work_mode-Enum (Debug raus von Ordinal 0, Build rein, kWorkModeCount=4)

### (a) Fundstellen HEUTE
NULLBEFUND mit Gegenprobe: `work_mode`/`WorkMode`/`kWorkModeCount` existieren als Code-Identifier NICHT.
Gegenprobe "wer ruft/inkludiert": repo-weiter grep findet genau 2 Kommentar-Treffer, beide zitieren nur den
Ledger-Entscheid: profile_facade/mess_achsen_naht.hpp:25 und tests/unit/test_anker_marke_statt_ledgerzeile.cpp:20.
Konsistent mit KON29-03 ("Modi sind ein BAU-Posten, 0 Code-Treffer"). Der heutige Traeger der Sache ist
RunMethodology:
- libs/cache_engine/include/cache_engine/measurement/run_methodology_registry.hpp
  :54-59 enum RunMethodology {Debug=0, Measure=1, Release=2, Compare=3} (uint8_t)
  :62 kRunMethodologyCount = 4; :93-98 kRunMethodologyRegistry (4 Zeilen, Index==Ordinal)
  :10-24 O-A-Ordnung measure->compare->release + NICHT-VERWECHSELN-Block ("Enum-Reihenfolge bewusst NICHT
  umgestellt: sie ist stempel-/ABI-relevant"); :168-192 run_methodology_for_ids (leer=>Measure-Default,
  unbekannt=>FAIL-CLOSED); :194-200 for_each_run_methodology
- Konsumenten (10 Dateien, Treffer je Datei gezaehlt): registry selbst 32; tests/unit/thesis_tiere/
  test_experiment_plan_director.cpp 21 (Suite MeasurementModi61: :3582, :3612, :3661, Schleife :3674);
  profile_facade/planner/experiment_plan_director.hpp 9 (:61 include, :2200/:2246 Aufrufe,
  :2292-2308 build_semantic_of_run_methodology); builder/experiment_tree/measure_parallelism.hpp :11/:22-25;
  tests/unit/thesis_tiere/test_experiment_parser.cpp :20 + :725-736 (static_asserts Count==4, compare-Zeile);
  tests/unit/test_45_parallel_measure_loop.cpp :113; profile_facade/validate_profile.hpp :62/:485/:1316;
  builder/experiment_tree/cache_engine_builder_iterator.hpp :285; measurement/hardware_meta_meta_axis.hpp :240
  (Doku); heuristik/axis_optimization_catalog.hpp :56/:429 (Doku)
- Token-Traeger im XML: algorithm_profiles/thesis_profiles/m3_smoke_coverage.profile.xml:172
  <method value="debug"/> ist der EINZIGE debug-Token in XML (repo-weit gemessen); experiment_golden_kern.xml
  traegt KEIN <method> (Abwesenheit = measure-Default, gemessen)
- Ziel-Zeile fuer die neue Unter-Achse: measurement/measurement_axis_registry.xml:59-60 TODO(W2-B) "die 3
  Mess-Modi existieren NICHT als Typen -> nicht emittiert"; Vorbild sub_axis_label: YcsbLoadFrameworkAxis
  ("workload", konsumiert in experiment_run_entry.hpp:224; Muster zitiert in external_utils_family_axis.hpp:25)
- Ledger-Quelle (geltende Fassung 09.08. spaet, Ledger-Datei Kopf "work_mode in geltender Fassung", heute
  ab Z13972): 4 States build/measure/compare/release, Besitzer PLANER (Director), --debug = CLI-Flag der
  Planer-Shell (fuer Anwender GESPERRT), Debug verlaesst das Enum (Ordinal 0), Build tritt ein,
  kWorkModeCount=4, neue Registry-Zeile {Build,"build","Build","Release",false,false}, Bauliste Z14134-14171
- +bt=-Abgrenzung (Auftragsteil): +bt= traegt den CMAKE-TYP, NIE den Modus -- gemessen:
  profile_facade/build_type_stamp.hpp:40-44 (nur bei COMDARE_BUILD_TYPE=="Debug" => "+bt=Debug"),
  system_version_suffix.hpp:58 (Segment-Ordnung), :69, :227 (static_assert Position vorletztes Segment);
  Kopplung heute: die debug-Registry-Zeile baut cmake_build_type "Debug" (registry :94)

### (b) Wachen/Tests/golden-Anker
- static_asserts registry :111-148 (Groesse, Vollstaendigkeit, id-Token-Anker {debug,measure,release,compare},
  4 Build-Semantik-Anker je Modus) -- ALLE brechen beim Umbau laut (gewollt, "Drift bricht compile-time")
- test_experiment_parser.cpp:730 static_assert Count==4 + :731-736 compare-Anker; MeasurementModi61-Suite;
  test_45_parallel_measure_loop.cpp (debug=paralleler Mess-Loop)
- test_smoke_coverage_profile (tests/unit/CMakeLists.txt:3784-3791): gatet m3_smoke_coverage.profile.xml,
  dessen :172 den debug-Token traegt -- bricht, sobald "debug" kein gueltiger Token mehr ist
- measurement_axis_registry.xml-Roundtrip (tests/unit/registry_roundtrip.cmake, Byte-Diff Generator vs.
  committete XML): die neue work_mode-Unter-Achsen-Zeile MUSS durch measurement_axis_registry_gen laufen
  (tools/CMakeLists.txt:14), nie von Hand
- S-14a-Riegel/718: NICHT betroffen -- Gegenprobe: run_methodology_registry.hpp liegt in include/cache_engine/
  measurement/, der Overlay-Schnitt (builder/overlay_source_set.hpp:130-201) fuehrt fuer mess NUR
  mess_axes/measurement_tooling*; 0 Lock-Records fuer die Datei (tools/axis_version_lock/axis_version.lock)
- Floors 495/491/489 (scripts/ci_test_inventory_floor.txt, HEUTE avx512f 495 / avx2 491 / basis 489):
  betroffen NUR, wenn der Bau neue ctest-Registrierungen bringt (Koeder-Tests der Sperre laut Ledger-Abnahme
  sind neue Tests) -- dann alle drei Sprossen im SELBEN Change live nachmessen (#39-Pflicht im Datei-Kopf)
- ABI-Einordnungs-SPANNUNG am Objekt (G-5-Frage): abi/anatomy_version_stamp.hpp:263 und
  abi/anatomy_module_abi_v1_decl.hpp:210 sagen "NIE Stempel-Bestandteil"; registry :21-22 sagt
  "stempel-/ABI-relevant" (Ordinal). Beide Aussagen woertlich am Objekt; der Bruch faehrt ohnehin im Fenster.

### (c) Bau-Reihenfolge INNERHALB des Buendels
1. --debug-CLI-Flag der Planer-Shell + AdmissionStatus-Umhaengung (axis_error.hpp:169-178 lt. Ledger) BAUEN,
   BEVOR Debug das Enum verlaesst -- sonst verliert m3_smoke:172 ersatzlos seinen Traeger (Gate :3784)
2. DANN der eine laute Bruch: Typ/Zaehler auf work_mode-Vokabular, Debug raus / Build auf 0, Registry-Zeilen-
   Ordnung == neue Enum-Ordnung {Build,Measure,Compare,Release} -- Ordinal-Doppelschub (Release 2->3,
   Compare 3->2) im SELBEN Commit wie Layout 6->7 / Format 4->5 (A-01..A-04), nie separat
3. Alle 10 Konsumenten-Dateien im selben Change nachziehen (ERST laute Compile-Fehler, dann verschieben)
4. measurement_axis_registry.xml: TODO :59-60 durch generierte Unter-Achsen-Zeile ersetzen -> Generator-Regen
   + Roundtrip im selben Change (J-1-Rezept: Tools zuerst, RE-CONFIGURE, Vollbau)
5. m3_smoke_coverage.profile.xml:172 migrieren (State + --debug-Flag statt method=debug)

### (d) Offene Entscheide
- AUTONOM (Ledger schreibt es woertlich): Ziel-Enum {Build,Measure,Compare,Release}, Build-Zeile
  {Build,"build","Build","Release",false,false}, kWorkModeCount=4, Unter-Achse unter measurement_category
- G-5-Rest (Enum-Ordnung als Byte-Ereignis, r4 C-7 "vorgelegt, nie beantwortet"): m.E. durch die geltende
  work_mode-Fassung MATERIELL beantwortet (Ziel-Aufzaehlung == Kette); 1-Satz-Owner-Bestaetigung im
  Fenster-Protokoll genuegt -- kein eigener Vorlage-Posten
- DESIGN-DETAIL offen (autonom entscheidbar, dokumentierpflichtig): erzwingt --debug weiterhin
  cmake_build_type Debug (heutige debug-Zeile) oder nur Auspraegung (Threads/Jitter-Pruefer)? +bt= haengt am
  CMAKE-Typ (build_type_stamp.hpp), nicht am Modus -- Kopplung explizit machen

## POSTEN 2: run_methodology_registry.hpp Enum-Ordnung (SUPERSEDED-Nachzug, G-5)

### (a) Fundstellen HEUTE
- Der O-A-Nachzug ce 491fff65 (07.08., verifiziert via git show): exakt 2 Dateien, 4 Stellen -- heute sichtbar
  als registry :10-17 (SUPERSEDED-Vermerk Sec.62-C), :19-24 (NICHT-VERWECHSELN), :88-92 (Kommentar der
  Registry), test_experiment_parser.cpp:720-723 (Wachen-Kommentar O-A)
- Der ENUM selbst bewusst NICHT umgestellt (:21-22); Ablauf-Ordnung lebt als Enthaltungs-Ordnung (:23-24)
- compare-Zeile byte-gleich zu release (:97 vs :96; Anker :144-148) -- Etikett-Stand bis Paket D2
### (b) Wachen: dieselben wie Posten 1 (registry-Anker + Parser-Wache). (c) Reihenfolge: geht vollstaendig im
A-05-Umbau auf -- KEIN eigener Schritt; die 4 Kommentar-Stellen werden dabei neu geschrieben. (d) Entscheid:
siehe Posten 1 (d); separate Ordinal-Umstellung OHNE A-05 waere ein zweiter teurer Bruch -- ausgeschlossen.

## POSTEN 3: A-06 Stufe/Phase-Umbenennung (KON16-09 -> KON25-07: TRENNUNG zweier Konzepte)

### (a) Fundstellen HEUTE
Geltende Regel (Ledger, KON25-07-Praezisierung, heute ab Z7135): STUFE (Traeger-Stufe) = die BINARY
(physisch); PHASE = CacheEngine-MODI (Konzeption). Umbenennungs-Landkarte KON29-03: Klasse A umbenennen,
Modi = Bau-Posten (0 Treffer -- von mir HEUTE bestaetigt, s. Posten 1a), Klasse C (XSD-Merge) = drittes
Konzept, Homonyme bleiben. Am Objekt:
- Klasse A ("Phase" meint die Binary/Traeger-Stufe): builder/bestandslog/batch_planner.hpp:92-110 --
  type_phase_rank/"Phasen-Raenge" fuer planer_block(0)->ceb(1)->tier(2) = Bau-Ordnung physischer Batches
- Gegenrichtung existiert schon korrekt: experiment_plan_director.hpp:375-379 sagt "Traegerstufe(n)"
  (CI-DUAL 14.08.); tests/unit/thesis_tiere/test_experiment_plan_director.cpp:3758 desgleichen
- Klasse C (XSD-Merge, das dritte Konzept -- die eigentliche Kollision "Stufe1..3 unter dem Element phase"):
  xml_config_parser.hpp:415 struct ExperimentPhase; xml_config_parser.cpp:498-509 parst <phases>/<phase>;
  fixture tests/unit/thesis_tiere/experiment_golden_kern.xml:40
  <phase name="Stufe3_FullJoin" merge="Stufe3_FullJoin">; sota_catalog.hpp:616-646 ExperimentPhaseProjection +
  derive_default_experiment_phases (baut p1/p2/p3); validate_profile.hpp:960-975 (phase.merge im Enum),
  :1099-1122 (fulljoin nur mit Phase-3-Bindung); merge_plan.hpp:40-71 -- die Werte selbst sind Posten A-09
- "STUFEN"-Prosa der Modi (Par.61-STUFEN) in Kommentaren (validate_profile.hpp:487, registry :168 u.a.) =
  Modi-Konzept mit Stufen-Wort -- Umbenennungs-Regel: dort "Phase/phasig" bzw. work_mode-Vokabular
### (b) Wachen
- preimage-/ABI-wirksam NUR ueber Klasse C: Fixture-Bytes (golden_kern :40,:43-46), Profil-Bytes (s. Posten
  5b), Kompositions-Namen mit "Stufe3" (sota_tier-Stempel-Keys, s. Posten 5b), pruefling_merge.hpp im
  Overlay-Schnitt (Lock-Record :113). Klasse A (batch_planner) ist NICHT preimage-wirksam (bestandslog-
  intern; BatchTyp-Enumeratoren planer_block/ceb/tier bleiben unberuehrt)
- fixture_schema_subset_check.cmake (tests/unit/, :19 + :96): Fixture-Vokabular als Teilmenge der
  SUPER-XSD Code/test_data_xml/experiment_schema.xsd -- jede Vokabel-Aenderung ist CROSS-REPO.
  NULLBEFUND + Gegenprobe: im ce-Repo existiert KEINE .xsd (find leer); alle 8 XSD-Referenzen zeigen auf
  die Super-Datei (validate_profile.hpp:584/:1012/:1026, target_isa_sub_axes.hpp:7, registry :8,
  xml_config_parser.hpp:352, fixture_schema_subset_check.cmake:19/:96)
### (c) Reihenfolge: Klasse A jederzeit im Fenster (kostenlos, keine Flotte -- Memory); Klasse C ZWINGEND
zusammen mit Posten 5 (ein Wort, ein Zug); Modi-Vokabular faellt mit Posten 1 zusammen.
### (d) Entscheide: Klasse A AUTONOM (KON25-07 ordnet an). Klasse-C-Zielnamen = Owner (s. Posten 5d).
Homonyme (Klasse D) NICHT anfassen -- stehende Anweisung.

## POSTEN 4: A-08 prod2-Umbenennung ("Ja umbenennen", Z15650; Etikett 14900KS vs. real i9-12900K)

### (a) Fundstellen HEUTE
Das Repo kennt die WAHRHEIT bereits, traegt aber das falsche ETIKETT als Identitaets-Token:
- measurement/machine_simd_signature.hpp:90 Kommentar "prod2: Intel Core i9-14900KS (Raptor Lake)";
  :91 struct Prod2RaptorLakeSignature; :92 do_machine_id() == "prod2_raptor_lake"; Wachen :112/:121/:123/:127
- system_axes/target_isa_complex_axis.hpp:134-141 struct Prod2RaptorLakeTargetIsa + do_complex_id()
  "prod2_raptor_lake" (:138); static_asserts :151/:158-159/:167-169/:187-201/:212-218 (Kern-Kennung
  GenuineIntel/6/151/2 = Alder Lake-S, RAM 4800 dmidecode, CAS offen)
- measurement/machine_identity.hpp: kProd2AlderLakeCore (GenuineIntel/6/151/2, brand bewusst leer) mit
  Kommentar :191 "Alder Lake-S, die CPU des Hosts prod2 (i9-12900K)"; :250 "die Registry-Zeile (i9-14900KS)
  NICHT die heutige prod2"; :444 static_assert kDeclaredMachines[1].machine_id == "prod2_raptor_lake"
- Generierte Registry: measurement/system_axis_registry.xml:23 <complex id="prod2_raptor_lake"> und
  :180 <machine id="prod2_raptor_lake" flag_count="9">
- WER ERZEUGT DIE REGISTRY (Auftragsfrage, beantwortet): tools/system_axis_registry_gen/ (CMakeLists :1-12,
  Target comdare_system_axis_registry_gen, EXCLUDE_FROM_ALL) -- C++-Executable, reflektiert die realen
  CebSystemAxis-Typen compile-time; verdrahtet als Byte-Roundtrip in tests/unit/CMakeLists.txt:5738-5746
  ueber tests/unit/registry_roundtrip.cmake (regeneriert nach WORKDIR, Byte-Diff gegen committete XML)
- Tests/Fixtures mit dem Token: tests/unit/test_stempel_vollbestand_registry.cpp:58; Kommentare
  test_meta_meta_halbordnung.cpp:215, test_m_simd_feature_flag_catalog.cpp:64, test_cpuid_probe.cpp:82-84,
  test_o4_machine_identity.cpp:80/:122 (Brand-Praefix i9-12900K -- bleibt RICHTIG)
- Planer-Routing-KOMMENTARE (Logik haengt an simd_id, nicht am Namen): experiment_plan_director.hpp:751
  "prod2=RaptorLake=avx2", :761-762
- NICHT betroffen (Gegenproben): Fixture golden_kern.xml:28 nutzt id="prod2" + cpu_fabrication="intel_avx2"
  (Schluessel, kein Etikett -- bleibt); CI resource_group pmu-prod2 / Tags intel (.gitlab-ci.yml:262-263)
  adressieren den HOST prod2, nicht das Registry-Etikett; bestandslog maschine-Feld "prod2" (hostname)
### (b) Wachen
- S-14a-Riegel/718: target_isa_complex_axis.hpp HAT einen Lock-Record (axis_version.lock:1391, digest-only
  "-") und liegt im Overlay-Schnitt (overlay_source_set.hpp:182, Praefix target_isa unter system_axes/) =>
  Umbenennung = Digest-Drift = contract:axis-version-lock (.gitlab-ci.yml:827, Block :788-798) ROT bis
  --write-Regen im selben Change; Record-Zahl bleibt 718 (kein Datei-Zu-/Abgang; bei Datei-UMBENENNUNG:
  verwaist->Regen, Zahl konstant). Overlay-Glied [7] des Tier-Fingerprints verschiebt sich (gewollt, im
  EINEN Bruch). machine_simd_signature.hpp dagegen: KEIN Lock-Record, nicht im Schnitt (Gegenprobe grep)
- system_axis_registry-Roundtrip (Byte-Gate): Code-Rename OHNE Generator-Regen => FAIL; Regen-Pflicht
- static_asserts oben (:444, :187-188 u.a.) muessen im selben Commit mitziehen
- Floors: unberuehrt, solange keine ctest-Registrierung entsteht/faellt
### (c) Reihenfolge
1. VORHER-Messung sichern (Owner-Auflage A-08): prod2 ist aktuell nicht aufloesbar (r3-Karte, Infra #207);
   es EXISTIERT ein Live-Beleg 09.08. (Ledger Z17243-17247, Job 368969: "12th Gen i9-12900K", Alder Lake)
2. Code-Ids + Struct-Namen + Kommentare umbenennen -> comdare_system_axis_registry_gen laufen lassen ->
   regenerierte XML committen -> Roundtrip gruen -> axis_version_lock --write Regen (J-1: Tools zuerst,
   RE-CONFIGURE, Vollbau)
3. Im SELBEN Fenster wie die uebrigen Brueche (Overlay-Glied verschiebt sich ohnehin)
### (d) Offene Entscheide
- OWNER: Ziel-Token (naheliegend "prod2_alder_lake" -- nirgends festgelegt); Verfahren bei 14900KS-Rueckkehr
  aus RMA im September (r1 C4): Re-Etikettierung oder ADDITIVE neue machine_id (Memory: Hardware-Erweiterung
  ist additiv)? Und: genuegt der 09.08.-lscpu-Beleg als VORHER-Messung, solange Infra #207 den Host sperrt?
- AUTONOM: mechanischer Nachzug aller o.g. Stellen + Generator-/Lock-Regen, sobald der Token feststeht

## POSTEN 5: A-09 FullJoin-Umbenennung (Pruefling-MergeStrategy, golden-byte-wirksam; KON30-02/KON91)

### (a) Fundstellen HEUTE -- das Wort traegt am Objekt MEHR als drei Objekte (29 Dateien, gemessen ohne
ext/build/html); die drei Objekt-KLASSEN des Auftrags plus zwei weitere Code-Traeger:
1. MergeStrategy-Enum: anatomy/pruefling_merge.hpp:131-135 {Stufe1_CeOnly, Stufe2_PrueflingReplace,
   Stufe3_FullJoin}; MergeImpl-Spezialisierung :226-234; StufeThreeAxis :125; MergeAxis :237-239;
   Namens-Kollisions-Wachen (Q2) :203-233
2. XML-Token "fulljoin" (per-Achse-Merge-Modus): validate_profile.hpp:665 kExperimentAxisMergeModes
   {"replace","merge","fulljoin"}; :1099-1122 Bindungs-Check; merge_plan.hpp:70-71 Projektion
   (fulljoin->Stufe3_FullJoin, merge->Stufe2_Hybrid); Fixture golden_kern.xml:9/:43/:46
3. Strategie-String "Stufe3_FullJoin" als XML-Attribut: Fixture :40; Profile m3_smoke_coverage:120-126,
   m3_golden_coverage:102-108, m3v2_study:114-120, all_axes_golden:102-108 (je 7 sota_series-Zeilen),
   cacheline_study:119; m3v2_sota_pilot: 0 Treffer (gemessen); Namens-Funktion validate_profile.hpp:617-627;
   Reihen-Mapping sota_catalog.hpp:92 ("Stufe3_FullJoin"->"B")
4. AxisFullJoin: src/permutations/permutation_engine.hpp:244/:253 (mp_unique<mp_append<...>>; pruefling_
   merge.hpp:122 verweist "identisch zu permutations::AxisFullJoin")
5. Kompositions-NAMEN (stempel-tragend): compositions/prt_art_merge_reference.hpp:161-186 -- 18 Vorkommen
   <Host>PrtStufe3FullJoinComposition (Masstree/Art/Hot/Surf/Start/... je name-String + COMDARE_DEFINE_
   COMPOSITION_LOCATION-FQN); Codegen rendert die Strategie in QUELLTEXT: sota_catalog.hpp:235/:240
   ("pf::MergeStrategy::" + d.strategy) und :344-357 (per-Host-FullJoin-Auswahl)
- Ledger-Rahmen: KON36/WF7 (12.08.): die drei MergeStrategy-Werte SIND die Prueflings-Verbund-Varianten;
  kuenftiger Bezeichner gehoert zur PRUEFLINGS-Familie, Vorschlag beim S-6-Fenster-Bau, golden-byte-wirksam
  (KON30-02). KON91-"FULL JOIN" (Mess-/Auswertungs-Union je Achse ueber alle Paper, r5:219-220) BEHAELT das
  Wort -- deshalb raeumt der Pruefling-Merge es
### (b) Wachen
- S-14a-Riegel/718: pruefling_merge.hpp HAT Lock-Record (axis_version.lock:113, tier_substanz, digest-only);
  anatomy/ ist REKURSIV im Overlay-Schnitt (overlay_source_set.hpp:201) => Digest-Drift => contract:
  axis-version-lock ROT bis Regen; Tier-Fingerprint-Glied [7] verschiebt sich (im EINEN Bruch gewollt).
  Gegenprobe: compositions/ und src/permutations/ stehen NICHT im Schnitt (Kategorien-Liste :130-201) --
  deren Umbenennung drueckt NICHT auf den Riegel, wohl aber auf Stempel-Keys (naechster Punkt)
- Stempel-Key-Anker: tests/unit/thesis_tiere/test_experiment_projection.cpp:63-68 pinnt woertlich
  "sota_tier=sota::B::<Host>PrtStufe3FullJoinComposition" -- Kompositions-Rename == Key-Byte-Aenderung
- Fixture-Konsumenten (Karten sagten "12 Tests"; HEUTE gemessen): 2 Dateien referenzieren golden_kern --
  tests/unit/test_s3_ordnung_freigabe.cpp (6 TESTs) + thesis_tiere/test_experiment_kern_seam.cpp (15 TESTs)
- fixture_schema_subset_check.cmake: merge-Vokabular Teilmenge der SUPER-XSD => CROSS-REPO-Nachzug noetig,
  wenn Tokens/Werte umbenannt werden; daneben besteht fixture_sync_check.cmake (Koexistenz, r3-F3-Kontext)
- validate_profile-Fehlertexte + merge_strategy_name-Switch muessen mitziehen (sonst luegende Diagnostik)
- Floors: nur bei Test-Zu-/Abgang
### (c) Reihenfolge
1. Ersatz-Bezeichner-VORLAGE gehoert in den S-6-Bau (A-09 woertlich "beim S-6-Bau umbenennen"); haengt damit
   HINTER dem S-6-Schnitt-Entscheid (A-10) und der Glied-Folge-Frage (A-04) -- Grammatik zuerst, Namen danach
2. EIN Zug ueber alle 5 Traeger-Klassen: Enum+Impl (pruefling_merge) -> Projektionen (merge_plan, validate,
   sota_catalog) -> Kompositions-Namen -> Profile+Fixture-XML -> Super-XSD; niemals geteilt, sonst zwei
   golden-Brueche. ERST laute Compile-Fehler (Enum zuerst), dann XML-Vokabular
3. Zum Abschluss axis_version_lock --write + Floors-Kontrolle + Diff-Hygiene (120-Spalten, Lock-v3-Format)
### (d) Offene Entscheide
- OWNER: (1) der neue Bezeichner (Prueflings-Familie; KON36 verlangt Vorschlag zur Abnahme);
  (2) Weg a -- Umbenennung der ce-Fixture experiment_golden_kern.xml -- war explizite, unbeantwortete
  Owner-Frage F3 (Z24718, r3-Karte); Weg b (Subset-Wache) ist gebaut und lebt
- AUTONOM: mechanischer Nachzug aller Traeger nach Namens-Entscheid; Fehlertext-/Kommentar-Hygiene

## QUERSCHNITT: BAU-REIHENFOLGE DER GRUPPE IM BUENDEL (Zusammenfassung)
1. prod2-VORHER-Beleg fixieren (bzw. 09.08.-Beleg anerkennen lassen) -- einziger Posten mit Ausser-Repo-Abhaengigkeit
2. --debug-Flag bauen -> A-05-Enum-Bruch (mit A-01..A-04 in EINEM Commit-Fenster) -> Konsumenten-Nachzug
3. S-6-Schnitt/A-10-Entscheid -> A-09+A-06-Klasse-C-Umbenennung in EINEM Zug (inkl. Super-XSD, CROSS-REPO)
4. A-08-Rename + system_axis_registry_gen-Regen + Roundtrip
5. Abschluss-Regen: axis_version_lock --write (Records pruefling_merge + target_isa_complex; 718 konstant),
   measurement_axis_registry_gen (neue work_mode-Zeile), Floors 495/491/489 nur bei Test-Delta nachmessen,
   alles nach J-1..J-4 (Tools -> RE-CONFIGURE -> Vollbau)
Klasse-A-Stufe/Phase (batch_planner) ist ordnungsfrei im Fenster nachziehbar.

## NULLBEFUNDE (alle mit Gegenprobe)
- work_mode/kWorkModeCount als Code: 0 Treffer; Gegenprobe: 2 Kommentar-Zitate, kein Konsument -- Bau-Posten
- .xsd im ce-Repo: 0 Dateien; Gegenprobe: 8 Referenzen zeigen auf super Code/test_data_xml/experiment_schema.xsd
- run_methodology_registry.hpp + machine_simd_signature.hpp im Overlay-Schnitt/Lock: 0 Records; Gegenprobe:
  Schnitt-Definition overlay_source_set.hpp:130-201 fuehrt beide Homes/Praefixe nicht
- m3v2_sota_pilot.profile.xml ohne Stufe3_FullJoin: 0 Treffer trotz run_methodology-Nutzung (direkt gegrept)
- debug-Token in XML ausserhalb m3_smoke_coverage:172: 0 Treffer (repo-weit value="debug" gegrept)
