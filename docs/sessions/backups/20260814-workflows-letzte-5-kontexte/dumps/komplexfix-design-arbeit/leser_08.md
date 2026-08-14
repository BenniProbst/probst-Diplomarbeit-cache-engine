# LESER 8 von 12 -- Extraktion JSON-Batch (Index i % 12 == 7)

BATCH-DATEILISTE (Groessen in Bytes, Quelle: ls -la .../regressions-gesamtbild):
- w1buo8hac.json  217494  (Gesamtbild-Workflow 08.08.: SOLL 369 / IST 211 / 39 Regressionen / Wellenplan-Endfassung, 23 Agenten)
- wjpdo2ukt.json  132319
- wo0oghvqu.json   94592
- wfr31gpjz.json   76159
- w8zswfsku.json   59105
- w1pdr52b0.json   42775
- wfjg4a9k0.json   33120
- w83v9wfv4.json   28116
- w71fb33yz.json   20595
- woqntqdz1.json   14263
- wzkd6pl5h.json    9856
- wp3t5aa4z.json    8143
- w6m5i2vnw.json    1577

HINWEIS ZUM STAND: w1buo8hac ist vom 08.08. (vor den Landungen 10.-13.08.). Einige Befunde
sind laut Datei selbst bereits widerlegt/geheilt (Abschnitt ENTLASTUNGEN E-1..E-6). Der
Designer muss jeden Befund gegen die heutigen landereifen Staende abgleichen.

## Datei w1buo8hac.json (Gesamtbild 08.08., result: soll=369, ist_geprueft=211, defekte_gesamt=39, davon 5 blockierend im JSON; 20 tragende Einwaende; Endfassung Wellenplan W-1..W7)

### [w1buo8hac] 1
GEGENSTAND: cache_engine --check-size "FILE" (Experimentgroesse/Dauer auf Zielmaschine) fehlt komplett: kein Planer-Verb, kein Vertrag Planer->CEB, keine Hardware-Erkennung.
ORT: Planer-CLI; OWNER-KERN 08.08., LEDGER:10928-10938
SOLL/FIX: --check-size bauen; Rechnung AUF der CEB; Hardware-Erkennung eines vorsorglich gebauten CEB; Ausgabe zwei Zahlenreihen (je working_set-Stufe UND je Combo-Fanout) plus kalibrierter Messpunkt bei working_set 8.388.608 (Endfassung Paket 10/10b).
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: W1-S-D; Frist-Rechnung OV-4; Owner-KERN D-3 "Bau-Menge folgt der Mess-Menge"

### [w1buo8hac] 2
GEGENSTAND: HYBRID-Adapter-Stufe (B-10, 4. Kettenglied) zu 0%% gebaut: alle 9 README-Katalog-Dateien, Break-Even-Router, Verdraengung, Dock-Array, <hybrid_tier>-XML-Parser fehlen.
ORT: libs/cache_engine/hybrid/ (nur README.md); A17 / LEDGER:4591-4620, 4714; Abgabe-Pflicht LEDGER:2340-2348 Par.31-A2
SOLL/FIX: Hybrid-Binary als 4. Kettenglied bauen; Endfassung schiebt nach W7 (OV-3), Thesis formuliert Hybrid bereits im Futur (05_evaluation.tex:153-154) -> keine Falschaussage, nur fehlende Leistung.
STATUS LT. QUELLE: offen (nur-spezifiziert)
ABHAENGIGKEIT/FLAECHE: OV-3 / W7; Streich-Kaskade Stufe 2

### [w1buo8hac] 3
GEGENSTAND: CMakeGraphBuilder SCHARF / Bare-Metal-Pflicht: CEB-BAU der Stufe 1 ist im bare-metal-Plan nur Echo mit Stempel; Bediener muss aeusseren Configure (inkl. -DCOMDARE_MEASUREMENT_COMBO=...) selbst parametrieren.
ORT: emittierter Plan :512-515; LEDGER:2469,2474 Par.40.c; Wellenplan W7-B
SOLL/FIX: identischer Bau ohne GitLab-CI; Endfassung: W7-B wird Abnahme-Bedingung von V-5 (je Welle ein baremetal-Bau ohne CI, literal protokolliert).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: V-5 Dual-Weg; W-1.4

### [w1buo8hac] 4
GEGENSTAND: EIN Storage-Tree, ZWEI Wurzeln binaries/measurements: MESSDATEN-Wurzel wird im Live-Lauf nie beschrieben; mess_bestand_doc_key/key_of/versions werden gelesen aber repo-weit NIRGENDS zugewiesen -> mess_bestandslog_active immer false.
ORT: libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:316/317/320 (Felder), :1939-1941 (Gate), Leser :1941/:1943/:2145/:2882/:2888; grep "mess_bestand_*=" = 0 Schreib-Stellen (ce UND super Code/02_messung_driver/)
SOLL/FIX: G-E3 Host-Binder bauen (Endfassung W1-S-B Paket 21).
STATUS LT. QUELLE: teilweise (gebaut, nie scharf)
ABHAENGIGKEIT/FLAECHE: T-03; Plan-Befund K-2 (docs/plaene/20260806-PLAN-katalogposten-p2p8-und-trigger-reste.md:134-165) am Objekt bestaetigt

### [w1buo8hac] 5
GEGENSTAND: Konformitaets-Gate gegen std::map-/Genus-Orakel laeuft im MESS-Lauf NICHT in-process; Gating nur ueber BAU-REIHENFOLGE (separater COMDARE_PRUEF_ONLY-Lauf); Handstart des Treibers misst ungeprueft.
ORT: cache_engine_builder_iterator.hpp:2694 (pruefe_mess_konsistenz), :2708 (acquire_search_algorithm_drive), :2255-2290 (PRUEF_ONLY)
SOLL/FIX: Orakel-Gate in-process bzw. Gate-Kopplung an den Mess-Lauf.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: befunde-83 F01; W-07/OV-11

### [w1buo8hac] 6
GEGENSTAND: B+-Baum-Teilbaum-Serialisierung Planer->CEB: Live-Kette reicht Achsen-Ranges ueber emittierten CMake-/YAML-TEXT (COMDARE_GN_OPT/GN_SIMD/GOLDEN_N_RANGE), volles Wire-Format Band-C-deferred; getestete Referenz-Serialisierung ohne Konsumenten.
ORT: experiment_plan_director.hpp:1763 ff.; LEDGER:2434-2443 Par.38
SOLL/FIX: Wire-Format-Konsument (5-tiefer #19-Resolver -> LinkedExperimentPlan) -- Band C.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -

### [w1buo8hac] 7
GEGENSTAND: SECHS CEBs / 3!-Permutationen ein-/ausgebauter Messgeraete: Kern faltet je deklarierter <combo> EINE CEB-Strecke, keine Permutation; Design-Luecken D1/D3/D4 offen im Header.
ORT: measurement_combos_of :2065-2078; Header :2042-2054; OWNER-KERN 08.08., LEDGER:10964-10990, 11129-11139
SOLL/FIX: 6 CEB-Varianten; ABER Einwand 15/OV-10: Gate-Kette G1<-G2<-G3 gibt maximal 4 Teilmengen her -- Owner-Entscheid Permutation vs. Teilmenge noetig; W2-Abnahme in Endfassung auf "vier + belegte Begruendung" gesetzt.
STATUS LT. QUELLE: teilweise; Definitionsluecke OFFEN (OV-10)
ABHAENGIGKEIT/FLAECHE: braucht G3-Split (S-01); mess_achsen_naht.hpp:74-77; W2-S-A

### [w1buo8hac] 8
GEGENSTAND: Modi Debug/Messung/Release/Compare: COMPARE hat ausser Registry-Zeile keinen Konsumenten (5 Treffer, alle in run_methodology_registry); PlanBuildSemantic::measurement_on hat NULL produktive Leser; Emitter verzweigen nur auf cmake_build_type=="Debug".
ORT: run_methodology_registry (:97/:120/:144/:146); build_semantic :116/:2015; LEDGER:3350-3374 Par.61-STUFEN, 11305-11320
SOLL/FIX: compare-Stufe D2 bauen (measure c= compare c= release, lesender Lager-Zugriff); Endfassung: F-08 nach W2-S-E vorgezogen (modusberuehrend).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W2-S-E; Namenskollision mit checkpoint_measure-Ebene "compare" (Eintrag 17)

### [w1buo8hac] 9
GEGENSTAND: PV-1 .so-ABI-Vertrag Planer<->CEB statt Textemission fehlt komplett.
ORT: LEDGER:3311-3327 Par.60-R1, Task #35; Fahrplan-Nachtrag L18
SOLL/FIX: Nach-Abgabe-Posten (W7), kein Abgabe-Blocker.
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: W7

### [w1buo8hac] 10
GEGENSTAND: Experiment-"B+-Baum" ist real PRAEFIXBAUM (Code korrigiert Ledger-Sprache selbst); Geschwister-Vergleichs-Semantik als Ordnung da, aber kein benannter Vergleichs-Operator (grep Geschwister|sibling = 0).
ORT: experiment_tree.hpp:5-7; OWNER-KERN LEDGER:11009-11036
SOLL/FIX: benannten Zugriff fuer "zwei Binaries mit genau EINEM Knoten Unterschied" bauen; Begriffsdrift Ledger/Code klaeren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -

### [w1buo8hac] 11
GEGENSTAND: "Messung ohne Bau-Material = Warnung + vorbehaltloser Nachbau (fail-open)" nirgends umgesetzt (keine Stelle nimmt nicht bau-freigegebene Mess-Anfrage mit CLI-Warnung an und baut trotzdem).
ORT: OWNER-KERN 08.08., LEDGER:11056-11062; Befund aus Synonym-Suche (schwaecher belegt)
SOLL/FIX: Gegenpruefung Mess-Anfrage gegen Bau-Freigabe + CLI-Warnung + vorbehaltloser Nachbau.
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: XML-Trennung Bau-Material/Messungen (measure_selection F-01b)

### [w1buo8hac] 12
GEGENSTAND: G3 aus dem STATISTICS-Gate in eigenes Makro loesen -- komplettes Paket ungebaut: (a) Makro+CMake-Option, (b) Block abi_adapter.hpp:1784-2057 umhaengen, (c) 7. Feld im mess_gates_glied (Preimage-Byte), (d) A8-S4-Praeprozessor-Wache erweitern, (e) neuer Zweig mess_achsen_defines().
ORT: abi_adapter.hpp:1784-2057; OWNER-KERN LEDGER:11276-11289
SOLL/FIX: G3-Split (S-01, W1-S-C Paket 13); Vorbedingung fuer die 6 CEBs.
STATUS LT. QUELLE: offen (nur-spezifiziert)
ABHAENGIGKEIT/FLAECHE: Bump-Buendel (beruehrt abi_adapter Hot-Path); W2-S-A braucht es

### [w1buo8hac] 13
GEGENSTAND: wallclock=G1/macro=G1+G2/micro=G1+G2+G3: [wallclock]-Binary ist KEINE fuehlerfreie Referenz -- 18 per-Achsen-Segment-Timer (Pfad A) bleiben einkompiliert; Nullpunkt "Lauf OHNE Fuehler" existiert nicht.
ORT: mess_achsen_naht.hpp:74-78
SOLL/FIX: Pfad-A-Timer unter das neue G3-Gate ziehen (Endfassung W1-S-C); gehoert in die Beschreibung des G3-Folgepakets.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: S-01/G3-Split; 6-CEB-Elektrotechnik-Begruendung des Owners

### [w1buo8hac] 14
GEGENSTAND: Fuenf Mess-Ebenen: (a) Ebene 2 im Profil-Pfad per Konstruktion identisch Summe Ebene 3 (Invariante kollabiert, entdeckt nichts); (b) Ebenen nicht einzeln schaltbar -- perm_runner.hpp enthaelt 0 Praeprozessor-Direktiven, Host-Ebenen 2/3 immer einkompiliert.
ORT: perm_runner.hpp (grep '#if|#ifdef' = 0); LEDGER:11064-11083
SOLL/FIX: Ebenen einzeln schaltbar machen; A8/F2-Invariante Summe(E1)<=E2<=E3 tragfaehig machen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: checkpoint_measure-Design; Mess-Permutation kann nur Tier-Seite variieren (2 Zustaende)

### [w1buo8hac] 15
GEGENSTAND: Separater Messpunkt Gattungs-Interface-Ebene (Klebe-Zeit): vorhandene Zelle ist DIFFERENZ und misst falschen Gegenstand (Loop-/Instrumentierungs-Overhead statt Interface-Zeit zwischen Achsen-Aufrufen).
ORT: measurable_workload.hpp:106; OWNER-KERN LEDGER:11526-11529; checkpoint_measure Design-Doc :259-262 Offener Punkt 3
SOLL/FIX: echten Messpunkt an der Gattungs-Interface-Ebene bauen (Macro-Benchmarking separat); Frage "vierte Ebene oder Sonderfall von macro?" offen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: checkpoint_measure Offener Punkt 3

### [w1buo8hac] 16
GEGENSTAND: checkpoint_measure als EINE uniforme Funktion mit compile-time IN/OUT-Tag: nichts existiert (keine Funktion, kein Header, kein Typ, kein Test, kein CMake-Flag).
ORT: OWNER-KERN 08.08., LEDGER:11739-11765; Design docs/architecture/20260808-checkpoint_measure_soll_design.md (cc028e1d)
SOLL/FIX: OV-2: (a) in W2 bauen NUR mit B-8-Konsument im selben Paket und innerhalb Bump-Buendel; (b) spezifiziert lassen -> W7. Empfehlung (b) falls B-8 nicht mitgebaut.
STATUS LT. QUELLE: offen (nur-spezifiziert)
ABHAENGIGKEIT/FLAECHE: OV-2; Bump-Buendel; B-8 laut LEDGER:4747 "nach Abgabe"

### [w1buo8hac] 17
GEGENSTAND: checkpoint_measure-Bausteine (eigener Stacktrace, virtuelle Thread-Slots, Mess-Ebene als CMake-Flag, thread-lokale Puffer, O(n)-Rekonstruktion, Ueberlauf-Zaehler) komplett ungebaut; NAMENSKOLLISION: Design nutzt 'compare' als oberste MESS-EBENE, Code belegt RunMethodology::Compare als ABLAUF-METHODIK mit measurement_on=false.
ORT: Design-Doc :125-128; libs/cache_engine/include/cache_engine/measurement/run_methodology_registry.hpp:58/:97
SOLL/FIX: Kollision VOR dem Bau klaeren; ein CMake-Flag "compare" traefe auf Begriff mit Gegenteil-Bedeutung.
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: OV-2; F-08/D2

### [w1buo8hac] 18
GEGENSTAND: Verhaeltnis Ebenen-Flags zu CEB-Gates: Entscheid "EIN Mechanismus, nicht zwei" muss VOR checkpoint_measure-Bau fallen; Andockstelle mess_gates_glied.hpp Erweiterungspflicht deklariert und mit static_asserts gesichert.
ORT: mess_gates_glied.hpp:64-66, static_asserts :246-265; Design-Doc Offener Punkt 6
SOLL/FIX: ENTSCHEID Ebenen-Flags == CEB-Gates (Endfassung W1-S-C); Flag ohne Glied-Erweiterung waere zweiter unsichtbarer Kanal.
STATUS LT. QUELLE: offen (nur-spezifiziert)
ABHAENGIGKEIT/FLAECHE: OV-2; S-01

### [w1buo8hac] 19
GEGENSTAND: Record-and-Replay als Mess-Vertrag zwischen den 3 Mess-Ebenen: kompletter Snapshot-/Replay-Apparat fehlt.
ORT: OWNER-KERN LEDGER:11291-11303
SOLL/FIX: W7 (F-11); Voraussetzung fuer Nicht-Stoerung der Ebenen -- selbe Frage wie 6 CEBs, beide Wege ungebaut.
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: W7

### [w1buo8hac] 20
GEGENSTAND: 83 Achsen-Bausteine ENABLED / 121 Varianten-Header: 52 von 83 tragen golden_wired="false"; persistence_target (T17) hat GENAU EINEN Baustein -- traegt keinen Vergleich, faellt als Vergleichsdimension aus dem Baum.
ORT: Registry-XML (grep -c 'golden_wired="false"' = 52)
SOLL/FIX: golden_wired-Luecken schliessen bzw. T17-Achse bewerten.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -

### [w1buo8hac] 21
GEGENSTAND: target_isa als Komplex-Achse: Ledger Par.69.2 nennt RAM-Frequenz+CAS+CPU-Fabrikation als FESTE Rekombination; Registry-XML traegt stattdessen ISAxOS (complex_count=2); RAM lebt separat als Provenienz-Kette.
ORT: measurement/ram_probe_chain.hpp + ram_frequency_reading.hpp; Registry-XML
SOLL/FIX: Abgleich Ledger-Wortlaut vs. Registry; CAS als Glied nicht gebaut (grep cas_latency = 0); Unterachsen in Golden-XML BEWUSST NICHT deklariert (experiment_golden_kern.xml:355-362) -> Faktor 1.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: O-2-Unterachsen; Eintrag 45

### [w1buo8hac] 22
GEGENSTAND: FK-3 Fehlerklassen: (1) Vollstaendigkeit ist Handliste von 20 im Test-TU (Handlisten-Regressionsklasse); (2) CompoundSystemAxis (Registry build_target_complex) hat 0 Treffer in axis_error_traits.hpp -- registrierte Achse OHNE Fehlerraum; (3) assert_axis_error_traits<> ohne Aufrufer ausserhalb Test-TU.
ORT: test_a15_fk3_axis_error_traits.cpp:196-221; ceb_complex_system_axis.hpp:77; system_axis_registry.xml:95; axis_error_traits.hpp
SOLL/FIX: Handliste -> Walk (Endfassung W2-S-E, T-13); CompoundSystemAxis-Traits deklarieren; Produktions-Instanziierung erzwingen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W2-S-E

### [w1buo8hac] 23
GEGENSTAND: Fehlerklassen fuer UNTERACHSEN (A15 Ebene 3): KEINE Organ-Unterachse deklariert einen Fehlerraum; nur die 5 System-Unterachsen tragen FK-3 Traits.
ORT: OptimizationLevelSubAxis/SimdSubAxis/CompilerAtomicSubAxis/TargetIsaSubAxis/OperatingSystemSubAxis (haben Traits); Organ-Seite 0
SOLL/FIX: A15 Ebene 3 Organ-Seite bauen (Owner-Direktive "Achsen -> Unterachsen -> Algorithmen Pflicht").
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: T-14, W2-S-E

### [w1buo8hac] 24
GEGENSTAND: Fehlerklassen je ALGORITHMUS (A15 Ebene 4): 0 von 121 Algorithmen deklarieren eigenen Satz; FK-5-Header deklariert die Luecke selbst -- ehrliche Luecke, aber Konstellation "Wache gruen bei leerem Gegenstand".
ORT: topics/organ_axis_error_classes.hpp:82-84
SOLL/FIX: per-Varianten-Verfeinerung bauen.
STATUS LT. QUELLE: offen (nur-spezifiziert)
ABHAENGIGKEIT/FLAECHE: T-14, W2-S-E

### [w1buo8hac] 25
GEGENSTAND: telemetry zweigeteilt (Runtime-Unterachse Mess-Tooling UND Haupt-System-Achse, Par.69.3/RF-8): Achse axis_11 existiert, gehoert aber zu KEINER registrierten Achsen-Ordnung; dasselbe Muster bei axes/simd (axis_09_isa).
ORT: libs/cache_engine/axes/telemetry_axis/ (9 Header); axes/simd/ (INC-2d)
SOLL/FIX: Sweep-Unterachse im Planer + Compile-Hauptachse in der CEB bauen; RF-8 ist identitaetsberuehrend (neue Haupt-Achse multipliziert --check-size-Menge) -> gehoert in Fingerprint-Sperrliste.
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: W1-S-G Sperrliste; LEDGER:3682

### [w1buo8hac] 26
GEGENSTAND: MAP traegt Key- UND Value-Filter-Achse (A5); Sortierungen als KEY-FILTER: weder Key- noch Value-Filter-Achse existiert; Posten 60 (Wanderung search_algo-Wrapper -> Filter-Familie) am Code nicht sichtbar.
ORT: unbekannt (Negativbefund)
SOLL/FIX: A5-Filter-Achsen bauen; A5-Value-Filter: LEDGER:7269 vier Optionen UNBEWERTET beim Owner (OV-14).
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: OV-14 (echter offener Owner-Entscheid)

### [w1buo8hac] 27
GEGENSTAND: KF-6 line_sizes: Durchbindung fehlt -- alle Strategie-Basen instanziieren Default-CacheLineConfig{} (line_size=B64); cacheline in KEINER Registry-XML -> nicht permutierbar; real erreichbar 1 von 60 Konfigurationen.
ORT: cacheline_line_bytes.hpp:16-20; axis_06_allocator_strategy_base.hpp:174-175; axis_04_node_type_strategy_base.hpp:21-22; axis_03a_search_algo_base.hpp:27; axis_01_page_type_strategy_base.hpp:13-14
SOLL/FIX: per-Organ-Config als NTTP emittieren (Posten 62, KF-6-NAHT); Endfassung T-06 -> W2-S-E.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Codegen; W2-S-E

### [w1buo8hac] 28
GEGENSTAND: Vier Container-Genera + Cross-Genus-Organe: Cross-Genus OPT-IN, NICHT im gemessenen Achsenraum (0 Treffer FromSequence/FromAdapter/FromSet in Registry-XML); nur eigene StaticAxisVariants-Listen.
ORT: builder/experiment_tree/cross_genus_composition.hpp:124/129/134
SOLL/FIX: Cross-Genus in die Registry (Endfassung T-12 -> W2-S-E).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W2-S-E

### [w1buo8hac] 29
GEGENSTAND: T6/Posten-68 Option B verletzt: SortedArrayKeySet ist lebender search_algo-foermiger Organ-Algorithmus (benutzt in cross_genus_organ.hpp:77, cross_genus_composition.hpp:101/108/169, 3 Test-TUs) mit 0 Treffern in cache_engine_axis_registry.xml -- "Organ-Algorithmus ohne Achsen-Zuordnung = Regression".
ORT: anatomy/set_default_organ.hpp:18 (:8 Selbstauskunft R5.B separat)
SOLL/FIX: R5.B-Operativitaets-Erweiterung verbauen bzw. Achsen-Zuordnung herstellen.
STATUS LT. QUELLE: teilweise (Regressions-Definition verletzt)
ABHAENGIGKEIT/FLAECHE: W2-S-E

### [w1buo8hac] 30
GEGENSTAND: A14 OsIdentityProbe: die zwei Design-Fehlerklassen OsIdentitaetUnerhebbar/OsDeklarationsAbweichung existieren NICHT (grep = 0); generische BetriebssystemFeatureFehlt macht Faelle ununterscheidbar; Cross-Check "Deklaration weicht ab" (Warnung, misst weiter) ohne Traeger.
ORT: libs/ tests/ (grep 0); ram_frequency_reading.hpp:80 (declared_not_measured nur fuer RAM)
SOLL/FIX: beide Fehlerklassen + Cross-Check-Traeger bauen (A14/OS-U4, Endfassung W2-S-E).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W2-S-E

### [w1buo8hac] 31
GEGENSTAND: Registry-Round-Trip in CI: (1) ce-Gate mit Labels contract;registry;roundtrip aus Default-Sweep test:unit ausgeschlossen; (2) W2-B-Gates haengen an EXISTS-Guard -- fehlt die committete XML, wird der Test STILL NICHT REGISTRIERT, Pipeline bleibt gruen.
ORT: CMakeLists.txt:5010-5012 (dokumentiert den Guard)
SOLL/FIX: Wache-mit-unvollstaendigem-Nenner-Konstellation beheben (Loeschen der XML wuerde Wache lautlos abschalten).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Wachen-Register V-1

### [w1buo8hac] 32
GEGENSTAND: Schema ce vs. prt-art-Registry: Gegenseite lag nicht in freigegebenen Arbeitskopien; in der ce-XML ist genus eigenes Attribut und auf ALLEN 18 Achsen "SearchAlgorithm", obwohl vier Container-Genera existieren.
ORT: cache_engine_axis_registry.xml
SOLL/FIX: Slot-Mapping T03 <-> axis_02 als additives Attribut dokumentieren; genus aus Slot reflektieren statt separat pflegen -- beidseitig pruefen.
STATUS LT. QUELLE: teilweise (nicht beidseitig pruefbar)
ABHAENGIGKEIT/FLAECHE: comdare-prt-art ausserhalb des Auftrags-Scopes

### [w1buo8hac] 33
GEGENSTAND: Break-Even-Funktion als String serialisierbar/parsbar: Kurve lebt nur als C++-Objekt im Prozess; kein Persistieren, kein Lager, kein Wiedereinlesen, keine Thesis-Ausleitung.
ORT: unbekannt (Negativbefund; AxisSpline ohne to_string/from_string)
SOLL/FIX: Serialisierung als String bauen (F-04, W1-S-A Paket 17); Naht fuer Auswertung/xlsx/LaTeX.
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: W1-S-A; OV-1

### [w1buo8hac] 34
GEGENSTAND: Break-Even-Basis "erster Parameter-Messwert bildet bei 0 die Basis": kein Code-Konstrukt; Lesart (x-Verankerung oder y-Normierung) am Code nicht entscheidbar.
ORT: unbekannt
SOLL/FIX: VOR dem Bau Lesart klaeren.
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: OV-1-Umfeld

### [w1buo8hac] 35
GEGENSTAND: Break-Even DREIMAL querschneidend (Micro/Macro/combined je Baum-Knoten-Tiefe): existiert weder als Signatur noch Schleife; Ebenen-Typen im Schreiber, Break-Even-Mathematik in der Heuristik, 0 gegenseitige Includes.
ORT: unbekannt (Negativbefund)
SOLL/FIX: F-05, datenabhaengig -> W5 (Endfassung Paket 57).
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: W5; braucht W4-Messdaten

### [w1buo8hac] 36
GEGENSTAND: Auswertungskette Messwerte -> Funktions-Synthese -> Schnitt-Kurven -> optimale Konfiguration: an KEINER Stelle verdrahtet; kein Aufrufer laedt CSV, baut Splines, rechnet Schnittpunkte, schreibt Artefakt; 2 von 3 Traegern tragen SKELETON im Kopf.
ORT: decision_lambda_trees.hpp:2; best_binary_selector.hpp:353
SOLL/FIX: Treiber (CLI oder CEB-Naht) + Ausgabe-Artefakt + Gruppierung je Achsen-Permutation bauen (B-9-Rahmen).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W1-S-A; drei divergierende Kurven-Modelle vorher zusammenfuehren (W-02)

### [w1buo8hac] 37
GEGENSTAND: compare-Stufe D2: kein lesender Lager-Zugriff, keine compare-Optionen, kein Vergleichs-Algorithmus, keine Ausgabe; Planer-CLI kennt nur validate|plan|cache-key|fingerprint|version.
ORT: /home/comdare/wt-ce-fk/apps/experiment_planner/main.cpp:401-436 (Hilfe), :507-561 (Dispatch)
SOLL/FIX: D2 bauen; Endfassung F-08 -> W2-S-E (vorgezogen aus W5, modusberuehrend).
STATUS LT. QUELLE: offen (nur-spezifiziert)
ABHAENGIGKEIT/FLAECHE: W2-S-E; measure c= compare c= release

### [w1buo8hac] 38
GEGENSTAND: Flattern des Schalters als Signal (Bereichs-Erkennung, KEINE Hysterese) -- PLAN-WIDERSPRUCH: Owner-KERN sagt Bereichs-Erkennung, GESAMTBILD D-5 fordert Hysterese-Band als Pflicht.
ORT: super docs/plaene/20260808-GESAMTBILD-*:395-397
SOLL/FIX: OV-12: bis zum Owner-Entscheid KEINE der beiden Varianten verdrahten; D-5 wird NICHT stillschweigend uebernommen. Ledger: Frage 11 nie beantwortet.
STATUS LT. QUELLE: offen (fehlt) + offener Owner-Entscheid
ABHAENGIGKEIT/FLAECHE: OV-12; Hybrid-Zahlen der Thesis haengen daran

### [w1buo8hac] 39
GEGENSTAND: B-9 Funktions-Synthese + Break-Even als Bau-Paket: Rahmen fehlt (kein Aufrufer, keine Gruppierung, keine Persistenz, kein Uebergang zur Binary-Wahl); drei divergierende Modelle muessen vorher zusammen.
ORT: s. Eintraege 33/35/36
SOLL/FIX: Break-Even-KANON: 3 Kurven-Modelle -> 1 Modul, 2 BreakEvenPoint-Typen -> 1 (W1-S-A Paket 16); sonst entscheidet Include-Pfad-Zufall die Thesis-Zahl.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W1-S-A; OV-1

### [w1buo8hac] 40
GEGENSTAND: XML-Dialekte: 9 von 11 ohne formale Schema-Datei; Struktur nur im handgeschriebenen Reader (xml_reader.hpp, 216 Z.) + Prosa; Tippfehler in comdare_thesis_profile/comdare_load_profile/comdare_axis_registry faengt keine Schema-Instanz.
ORT: xml_reader.hpp; algorithm_profiles/SCHEMA.md
SOLL/FIX: Schema-Abdeckung erhoehen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W1-S-D (W-10 Umfeld)

### [w1buo8hac] 41
GEGENSTAND: Zwei-Registry-Kanon ce+prt_art: Slot-Vokabular divergiert -- DIESELBE Achse path_compression heisst ce slot="T03", prt_art slot="axis_02"; Cross-Referenz-Join scheitert; Mapping-Attribut existiert nicht.
ORT: beide Registry-XMLs
SOLL/FIX: Mapping-Attribut einfuehren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Eintrag 32

### [w1buo8hac] 42
GEGENSTAND: Golden-XML als Trigger-Input-Basis: ZWEI Bloecke im comdare_experiment-Dialekt tot -- organ_subaxes 0 Fundstellen im ce-Code; run_options wird in parse_experiment_profile NICHT gelesen (nur Thesis-Dialekt). Owner-N 2^17 und KF-6-line_sizes stehen maschinenlesbar in der Trigger-XML und werden vom Parser verworfen.
ORT: xml_config_parser.cpp:449-574 (kein run_options); :431-440 (Thesis-Dialekt liest); Ersatzwache test_golden_n_consistency (haelt N nur gegen Schwesterprofil + CMake-Literal EXPECTED_N=131072)
SOLL/FIX: Parser-Naht fuer run_options/organ_subaxes bauen oder Bloecke entfernen; Ersatzwache ist kein Ersatz.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W1-S-D; XSD-Abdeckung (Eintrag 47)

### [w1buo8hac] 43
GEGENSTAND: --check-size (Doppel-Erfassung zu Eintrag 1): alle drei Owner-Zusagen fehlen -- (a) CLI-Flag, (b) DAUER-Schaetzung, (c) Rechnung AUF der CEB mit Hardware-Erkennung; PlanSizeBuilder rechnet host-lokal ohne CEB und ohne Hardware.
ORT: PlanSizeBuilder
SOLL/FIX: wie Eintrag 1.
STATUS LT. QUELLE: teilweise (PlanSizeBuilder existiert host-lokal)
ABHAENGIGKEIT/FLAECHE: W1-S-D

### [w1buo8hac] 44
GEGENSTAND: Enum-Pruefung Experiment-XML: (1) <metadata><mode> nie gegen {defined,full,full_sampled} geprueft (nur LEGACY-v32-Zweig); (2) ep.version ungeprueft; (3) ep.datasets ohne die 5 Format-Checks die tp.datasets bekommt.
ORT: super Code/02_messung_driver/messreihe_v32_validator.hpp:147-149; validate_profile.hpp:312-345, kKnownDatasetLoaderIds:117
SOLL/FIX: Enum-/Format-Pruefungen im comdare_experiment-Validator nachziehen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W1-S-D

### [w1buo8hac] 45
GEGENSTAND: <metadata><mode> stiller Env-Override: parse_enumeration_mode faellt bei UNBEKANNTEM Token still auf EnumerationMode::Defined zurueck; <mode>fulll</mode> laeuft klaglos als 'defined' -- verbotene stille-Rueckfall-Klasse.
ORT: v32_messreihe_antrieb.hpp:96-100
SOLL/FIX: optional/Abbruch/eigener Return-Code statt stillem Default; validate prueft mode.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W2-Regressionsliste (metadata.mode)

### [w1buo8hac] 46
GEGENSTAND: sota_series merge-Attribut ungeprueft: getipptes merge= passiert validate; sota_module_for liefert nullopt, build_sota_passes ueberspringt Reihe LAUTLOS -- Reihe verschwindet aus der Messung ohne Rot.
ORT: sota_catalog.hpp:299, Dispatch :394/:477
SOLL/FIX: merge gegen MergeStrategy-Namen validieren.
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: W2

### [w1buo8hac] 47
GEGENSTAND: WorkloadKind/OP-Typen: OP-1..OP-6 sind Phantom-Etiketten auf identischen Messungen; je-Kind-Dispatches fehlen (YCSB_C prefill+lookup-only, OP-2 insert-only, YCSB_A 50/50); kein lautes 'nicht unterstuetzt' fuer Scan/RangeDelete.
ORT: Katalog-Treiber; operator()(size_t, WorkloadKind /*kind*/, uint64_t) Parameter unbenannt (W-08)
SOLL/FIX: echte Dispatches + lautes Unsupported bis IScannableTier-Anbindung (W2-S-E, W-08).
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: W2-S-E

### [w1buo8hac] 48
GEGENSTAND: Workloads/Datasets aus XML statt hartkodiert: ep.workloads und ep.op_types haben im ce-Lauf-Pfad 0 Fundstellen; Validator prueft, Lauf konsumiert nicht; op_types nur vom LEGACY-super-Antrieb als Label-Liste.
ORT: libs/cache_engine/profile_facade/*.hpp; validate_profile.hpp:1319-1330; v32_messreihe_antrieb.hpp:156-168
SOLL/FIX: Lauf-Konsum der XML-Deklarationen bauen (hartkodiert 2000/2000/42 abloesen).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W2

### [w1buo8hac] 49
GEGENSTAND: <lebewesen>/phase.engine/pruefling steuern Host-Dispatch NICHT: auf super-Antriebspfad bestimmt allein phase.merge die Komposition; sieben <lebewesen>-Eintraege wirkungslos; compile-time-Dispatch (mp_for_each) existiert dort nicht.
ORT: super-Antriebspfad
SOLL/FIX: realen Dispatch bauen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: OV-11 (welcher Treiber faehrt Voll-Lauf)

### [w1buo8hac] 50
GEGENSTAND: Verankerung relativer <output>-Pfade fehlt: landen wo der Prozess zufaellig steht; offene Flanke fuer Lagerhaltung (zwei Realm-Wurzeln).
ORT: unbekannt
SOLL/FIX: Verankerung definieren.
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: W2-Regressionsliste (<output> gegen CWD)

### [w1buo8hac] 51
GEGENSTAND: fail-open-Nachbau (Doppel zu Eintrag 11): kompletter Owner-KERN LEDGER:11056-11062 unumgesetzt.
ORT: LEDGER:11056-11062
SOLL/FIX: wie Eintrag 11.
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: -

### [w1buo8hac] 52
GEGENSTAND: Paper-Research (ein Paper = ein wiederverwendbares Experiment-XML, <template ref=..>): kein Template-Profil, keine Registry, kein ref-Konsument.
ORT: unbekannt (Negativbefund)
SOLL/FIX: OV-13: (a) eigene W2-Spur (Design+Template-Referenz, Bau W2/W3, Auswertung W5) oder (b) nach W7 MIT Klartext-Konsequenz "Arbeit vergleicht dann Kompositionen, nicht Paper-Algorithmen je Achse". Owner LEDGER:11128: "Ja unter sorgfaeltiger Design Planung bitte bauen, Ruecksprache mit mir im Detail" -- Ruecksprache fand nie statt.
STATUS LT. QUELLE: offen (nur-spezifiziert); Owner-Entscheid OV-13 offen
ABHAENGIGKEIT/FLAECHE: OV-13; PV-4; Regel der abstrakt-leeren Achse; wissenschaftliche Kernfrage LEDGER:11117-11124

### [w1buo8hac] 53
GEGENSTAND: Ein-Hauptkanal-Doktrin verletzt: zwei Lauf-Pfade fuer denselben Dialekt = zwei Wahrheiten (einer kennt Datasets/opt/simd/run_methodology, der andere op_types + wirkungsloses Konformitaets-Gate); offizieller Pfad entscheidet der Aufrufer, nicht die XML.
ORT: ce-Pfad vs. super-Antrieb
SOLL/FIX: OV-11 entscheiden; Katalog-Treiber ans scharfe perm_runner-Gate angleichen (W2-S-E Paket 39).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: OV-11

### [w1buo8hac] 54
GEGENSTAND: XSD-Abdeckung comdare_experiment: run_options und organ_subaxes stehen im XSD und in der kanonischen Trigger-XML, haben aber KEINE Parser-Naht; <hybrid_tier> nur Kommentar-Reserve ohne Typ/Parser/Instanz.
ORT: xml_config_parser.cpp:449-574; experiment_schema.xsd:102-124
SOLL/FIX: Parser-Naehte bzw. Schema-Bereinigung.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Eintrag 42

### [w1buo8hac] 55
GEGENSTAND: XML-Reader DOCTYPE/Entities (XXE): klassischer XXE-Lesepfad zu, aber DOCTYPE mit internem Subset kann Parser still in falschen Zustand versetzen; Bissbeweis T-i-1 (zwei Fixtures rot-ohne/gruen-mit-Sperre) existiert nicht als Test.
ORT: xml_reader
SOLL/FIX: DOCTYPE-Sperre + T-i-1-Fixtures.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -

### [w1buo8hac] 56
GEGENSTAND: Zwei Filesystem-Wurzeln lazy: NULL Produktions-Konsumenten fuer make_binaries_baum_writer/make_messdaten_baum_writer (nur Definition lager_baum_writer.hpp:600/:605 + Tests); Wurzel ist Konstruktor-Argument ohne Default und ohne Belegung; "zweiter Durchlauf" hat keinen Schreiber.
ORT: lager_baum_writer.hpp:538/:600/:605; tests/unit/test_lb0_lager_pfad_grammatik.cpp (einzige Aufrufer)
SOLL/FIX: Produktions-Konsument bauen (T-02, W1-S-B).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W1-S-B; W1-S-H Naht

### [w1buo8hac] 57
GEGENSTAND: Realm-Wurzeln auf /mnt/comdare-buildsystem (GESAMTBILD A-4): nur in Plandokumenten; im Code KEINE Zeile setzt eine Wurzel; es gibt ueberhaupt keinen Setz-Ort.
ORT: docs/plaene/20260808-GESAMTBILD-...:293
SOLL/FIX: Wurzeln zeigen lassen (W1-S-B Paket 21).
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: Eintrag 56

### [w1buo8hac] 58
GEGENSTAND: SKIP auch fuer Binaries / Factory-Pattern: Storage-Tree und Skip-Mechanik sind ZWEI unverbundene Welten (Skip via Sidecars neben DLL bzw. Bestandslog-XML in minio, NICHT via Baum-Writer); von drei Skip-Quellen nur dll_is_current ohne Env aktiv.
ORT: output_dir-Sidecars; minio-Bestandslog
SOLL/FIX: Verbindung bauen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W1-S-B

### [w1buo8hac] 59
GEGENSTAND: Zaehler-Resume (Batch-Plan persistent VOR dem Lauf): HOST belegt batch_plan_datei nie (grep main.cpp = 0); alle Belegungen in tests/unit; im Voll-Lauf PlanPersistenz::aktiv()==false -> kein Plan abgelegt, kein Zaehler-Resume. Gebaut, aber nicht scharf.
ORT: /home/comdare/wt-super-landung/Code/02_messung_driver/main.cpp; tests test_tp1_planer_filter_iterator.cpp:957/:1206/:1453/:1664/:1774, test_t2a_f4_facade_plan_durchreichung.cpp:154
SOLL/FIX: Host-Belegung bauen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Owner-KERN A1; Mess-Resume F-16

### [w1buo8hac] 60
GEGENSTAND: Zwei Bestandssysteme Factory (binary|measurement) + SHA512-Stempel: ZWEITES Genus wird nie gefuellt; grep mess_bestand in ce = 12 Treffer alle in cache_engine_builder_iterator.hpp, 0 Zuweisungen; super main.cpp = 0. G-E3-Host-Binder fehlt vollstaendig.
ORT: cache_engine_builder_iterator.hpp:316/:317/:1940-1943
SOLL/FIX: G-E3 Host-Binder (W1-S-B).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: T-03; Doppel zu Eintrag 4

### [w1buo8hac] 61
GEGENSTAND: Cache-Log-Koordination (lockbare Sync-Datei minio + Lease/Timeout): haengt am nirgends gesetzten COMDARE_BESTANDSLOG; dazu unaufgeloester Konflikt LockRecord.ttl_s=30 gegen kritische Sektion mit ~49 min Retry-Budget (Faktor ~100).
ORT: super docs/sessions/backups/20260726-session-plaintext-verlauf/verlauf-31.txt:853ff
SOLL/FIX: COMDARE_BESTANDSLOG in beiden CI setzen (Paket 21); TTL-Konflikt aufloesen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: T-04

### [w1buo8hac] 62
GEGENSTAND: Storage-Forecast-Doktrin (Bau-Maschine gegen NULL, Binaries->minio, Messergebnisse->NFS): Pruning-Wache G5 nicht auffindbar; Ebene B nur hinter COMDARE_STORAGE_CACHE=='true' (kein Default) -> ohne Opt-in bleibt jede Binary lokal, Gegenteil der Doktrin.
ORT: super .gitlab-ci.yml:695
SOLL/FIX: Push-Aktivierung + Pruning-Wache (Par.66 G4/G5, W3-S-C Vorposten).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Par.66 G1-G5 Checkliste (Paket 48)

### [w1buo8hac] 63
GEGENSTAND: Tools-Lagerhaltung (Toolchain-/Treiber-/Planer-/CEB-Werkzeuge via minio wiederverwenden): vollstaendig ungebaut.
ORT: nur Par.65-USER-KERN-b im Ledger
SOLL/FIX: bauen (keine Welle in Endfassung explizit).
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: -

### [w1buo8hac] 64
GEGENSTAND: RAM-Sammelpuffer 256 MB + Writer-Thread (SpoolWriter): NULL Konsumenten (nur 2 Kommentar-Erwaehnungen); Rueckschreib-Pfad nutzt ihn nicht; Windows-IoRing-Backend fehlt (nur io_uring + portabel).
ORT: artifact_transport/spool_writer.hpp; lager_ziel_strategie.hpp:11; ram_spool.hpp:7/:31
SOLL/FIX: verdrahten (T-07, W2-S-E).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W2-S-E

### [w1buo8hac] 65
GEGENSTAND: LB-1 Knoten-Heuristik-Log: kein Produktions-Aufrufer; knoten_heuristik_log nur in registrierungs_sidecar.hpp:36, das selbst NULL Konsumenten hat; gesamte LB-1/N8-Kette haengt an keinem Lauf.
ORT: registrierungs_sidecar.hpp:36; tests/unit/test_ge1_claim_check_und_sidecar.cpp:15
SOLL/FIX: verdrahten (T-09, W2-S-E).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W2-S-E

### [w1buo8hac] 66
GEGENSTAND: Symmetrie-Prinzip (beide Maschinen bauen alles, gleiche XML, Koordination via Cache-Sync): kein Nachweis realer Parallel-Koordination; Koordination liegt im nirgends aktivierten Bestandslog; Cluster read-only nicht pruefbar.
ORT: unbekannt
SOLL/FIX: haengt an OV-9 (prod2 existiert nicht) und T-04.
STATUS LT. QUELLE: offen (nur-spezifiziert)
ABHAENGIGKEIT/FLAECHE: OV-9; R-4

### [w1buo8hac] 67
GEGENSTAND: Test-Skip-Gesetz (zwei Ebenen): KEIN Konsument verlangt vor Skip ein gruenes Test-Log; realer Arbiter ist dll_is_current (.fingerprint) bzw. Lager-Bestand (key_sha512+Zelle) -- beide fragen nie nach Test-Log; zweite Ebene unverdrahtet.
ORT: grep test_log_neben libs apps = nur Definition + Kopf-Kommentar
SOLL/FIX: Skip nur bei vorhandenem gruenem Test-Log NEBEN der Binary; fehlendes Log = Neubau (W3-S-C; Abnahme Paket 50: skip_ohne_testlog == 0).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W3-S-C

### [w1buo8hac] 68
GEGENSTAND: CEB-interner Build+Pruef-Batch (bauen -> Pruefdock-Google-Test -> DANN messen): Gate blockiert nichts (befunde-83 F01 weiterhin offen); kein 'nur bei pass'-Zweig mit eigenem Exit-Code fuer execute_messreihe auffindbar.
ORT: execute_messreihe
SOLL/FIX: harten Gate-Zweig bauen; Audit-Vorschlag: eigener Exit-Code 6 fuer Konformitaets-Fail.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W-07/OV-11; Eintrag 5

### [w1buo8hac] 69
GEGENSTAND: LB-6 Dummy-Strategien Stempel-Erkennung: Stufe 2 (echt kompilierte, sonst leere Tier-Binary NUR mit statischem Stempel-Interface) nicht auffindbar -- kein Target, kein Fixture, kein Test.
ORT: unbekannt (Negativbefund)
SOLL/FIX: Stufe-2-Fixture bauen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -

### [w1buo8hac] 70
GEGENSTAND: A9 xlsx im zweigeteilten Lager-Baum: kein Code verbindet Writer und Baum; ergebnis_mappe.hpp inkludiert lager_baum_writer.hpp nicht; kein Aufruf knoten_pfad()/einlagern() aus dem xlsx-Weg; Resolver-Aufruf existiert nirgends.
ORT: ergebnis_mappe.hpp
SOLL/FIX: Naht bauen (W1-S-H: echte Mess-CSV -> xlsx im Realm-Baum, eigener Besitzer).
STATUS LT. QUELLE: offen (nur-spezifiziert)
ABHAENGIGKEIT/FLAECHE: W1-S-H; T-01+T-02

### [w1buo8hac] 71
GEGENSTAND: A9-S4/S5 CLI comdare_mess_report (render|plan|version) als xlsx-Hauptkonsument: laut 08.08.-Stand ungebaut; Endfassung [OD]: existiert auf bau/a9-s4-mess-report (6 Commits, 17 Dateien), nicht auf origin/development -> W-1-Landung.
ORT: bau/a9-s4-mess-report: tools/mess_report/{main.cpp, mess_report_render.hpp, realm_scan.hpp, skip_manifest.hpp, dynamic_axis_filter.hpp} + 4 Testdateien
SOLL/FIX: Branch landen (W-1.2); Abnahme ctest-Zahl + gruene Pipeline auf development (An-4: Zahl verifiziert, Bau nicht).
STATUS LT. QUELLE: teilweise (auf Branch vorhanden, Landung offen)
ABHAENGIGKEIT/FLAECHE: W-1; F-06/F-14

### [w1buo8hac] 72
GEGENSTAND: xlsx-SKIP bei gueltigem Bestand: Messdaten-Seite nicht implementiert (Binaries via dll_is_current ja); Endfassung: skip_manifest.hpp (91 Z.) auf bau/a9-s4-mess-report vorhanden -> W-1.
ORT: bau/a9-s4-mess-report skip_manifest.hpp
SOLL/FIX: landen + Abnahme Paket 23b: Erstlauf geschrieben>=1, Zweitlauf uebersprungen==N und geschrieben==0; bei neuer Binary-Version neuer Datensatz NEBEN dem alten (Owner-KERN 3).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W-1; F-14

### [w1buo8hac] 73
GEGENSTAND: E-18 LaTeX-Anhang-Vorwaerts-Kanal: zweiter Teil (datierter Snapshot measurement/thesis_compiles/JJJJMMTT-HHMMSS/ mit PDF+Compile-Log+Quellstand-SHA) NICHT gelandet; existiert nur als WIP-Patch e18snap-proben.sh.
ORT: grep thesis_compiles|SNAP_DIR|QUELLSTAND in .gitlab-ci.yml ci/*.sh = 0; docs/sessions/backups/20260806-workflows-abschluss-abbruchsicher/wip-patches/e18snap-proben.sh
SOLL/FIX: Snapshot-Teil landen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: U-03 anhang:forward (Eintrag 82)

### [w1buo8hac] 74
GEGENSTAND: Schwere-Leiter "Lager-Inkonsistenz ist FATAL": kein Code-Gegenstueck; keine Stelle bricht bei Lager-Inkonsistenz ab.
ORT: unbekannt (Negativbefund)
SOLL/FIX: F-15 Schwere-Stufe an Lager-Fehlerklassen (W1-S-B Paket 22).
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: W1-S-B

### [w1buo8hac] 75
GEGENSTAND: Cluster-parallele System-Achsen-Builds "genau einmal cluster-weit": braucht Locking/Reservierung = Bestandslog = nicht aktiv; ohne Opt-in doppelte Builds; realer Zwei-Maschinen-Beweis fehlt.
ORT: unbekannt
SOLL/FIX: Bestandslog aktivieren; Zwei-Maschinen-Beweis (haengt an OV-9).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: T-04; OV-9; U-07

### [w1buo8hac] 76
GEGENSTAND: Pool-Modell (genau ein Runner je Permutation unter Locking): kein aktiver Locking-Mechanismus im naechsten Voll-Lauf; Mess-Exklusivitaet (Par.38.b/Par.61) unbewacht.
ORT: unbekannt
SOLL/FIX: OV-5 (Mess-Exklusivitaet global vs. je Maschine) vor W3 entscheiden; Empfehlung je Maschine (Par.61 juenger).
STATUS LT. QUELLE: offen (nur-spezifiziert)
ABHAENGIGKEIT/FLAECHE: OV-5; W-05 (super .gitlab-ci.yml:753/:840 haelt globale Gruppe)

### [w1buo8hac] 77
GEGENSTAND: NFS-Export/Lagerhaltung: Sync laeuft ueber minio-Objekte, nicht NFS-Mounts; kein Code kennt einen der drei Mount-Pfade; V60-Runner-Mounts nicht pruefbar (Cluster read-only).
ORT: unbekannt
SOLL/FIX: klaeren/dokumentieren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -

### [w1buo8hac] 78
GEGENSTAND: Lager-Gate G1-G5 als Voll-Build-Vorbedingung: G4 (Ebene-B-Push) und G5 (Pruning lokal->0) nicht am Objekt nachweisbar; Push haengt an COMDARE_STORAGE_CACHE; prunable_artifacts (artifact_cache.hpp:86) ohne Aufrufer im Bau-/Mess-Pfad.
ORT: artifact_cache.hpp:86; super .gitlab-ci.yml:695
SOLL/FIX: Par.66-Vorposten G1-G5 als Checkliste mit ausgegebenem Nenner (W3-S-C Paket 48; Abnahme G1..G5: 5/5).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W3-S-C

### [w1buo8hac] 79
GEGENSTAND: pmc_cache_misses_l3 via amd_l3-PMU-Typ: dynamische PMU-Typ-Aufloesung fehlt (amd_l3 Typ 17 lesen, RAW-config aus /sys/devices/amd_l3/format: event/umask/coreid/sliceid/threadmask/enallcores/enallslices; KEIN events/-Verzeichnis -> RAW zwingend). Ohne sie L3 auf prod1 nicht messbar.
ORT: PMC-Oeffner
SOLL/FIX: W1-S-E Paket 09 (L3-PMU-Typ dynamisch).
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: W1-S-E

### [w1buo8hac] 80
GEGENSTAND: B-6 RAW-PMC-Events je Mikroarchitektur (Zen 3/4/5, Alder/Raptor Lake): komplett -- keine uArch-Erkennung, keine RAW-Event-Tabelle, keine Auswahl je CPU-Familie.
ORT: PMC-Pfad
SOLL/FIX: Deep-Research + Tabelle bauen.
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: Eintrag 81 (cache_misses_l2/coherence haengen am selben RAW-Pfad)

### [w1buo8hac] 81
GEGENSTAND: PMC je P-/E-Core-Domaene (cpu_core/cpu_atom): Oeffner waehlt keine PMU-Domaene; auf hybrider Intel-CPU existiert generischer PMU-Typ nicht mehr -> alle vier open() scheitern = Code-Erklaerung der roten pmc:intel-Lane. cache_misses_l2/coherence_invalidations ehrlich n/a, nie erhoben.
ORT: PMC-Oeffner; U-06
SOLL/FIX: Hybrid-Pfad (Typ aus cpu_core/type bzw. cpu_atom/type) bauen (W1-S-E Paket 09); ABER Hardware fehlt (OV-9: i9-12900K existiert nicht im Netz).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: OV-9; U-06; B-6

### [w1buo8hac] 82
GEGENSTAND: B-2 Pinning-Konsument im Mess-Loop: alles ausser dem Aktuator fehlt (keine Planer-Freigabe, kein CEB-Compile-Einbau, keine core_class-Bindung, kein Pinnen); Header deklariert Grenze selbst ("ANGEBOT, nicht sein Konsument ... Folge-Paket OD-11-RT-K").
ORT: numa_cpu_pin_process_probe.hpp:110-118
SOLL/FIX: F-10 in W2-S-E (LEDGER:4740 stuft CEB-ONLY, VOR der Voll-Messung = vor Freeze) + T-11 B-4 Warntext "warn: no pinned locality on hybrid architecture" (wird nie ausgegeben, Header Z.76, Konsument existiert nicht).
STATUS LT. QUELLE: offen (nur-spezifiziert)
ABHAENGIGKEIT/FLAECHE: W2-S-E Paket 37; L3-Asymmetrie (W4-S-C) setzt es voraus

### [w1buo8hac] 83
GEGENSTAND: B-3 getrennte Ablage je PMU-Domaene im CSV-/Lager-Schema: komplette Spalte/Dimension fehlt; E-Core-Lauf nicht von P-Core-Lauf derselben Binary unterscheidbar.
ORT: CSV-Kopf (0 Spalte pmu_domain|core_class)
SOLL/FIX: PMU-Domaenen-Spalte in lazy_csv_header -- ZUERST und EINMALIG in W1 (bindende Reihenfolge: S-E aendert lazy_csv_header:470/format_csv_row:623 Mo/Di, S-A/S-B bauen ab Mi gegen neuen Header; keine zweite Spaltenaenderung in der Welle).
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: W1 Paket 08; Resume-Schluessel :1146 expected_header

### [w1buo8hac] 84
GEGENSTAND: Schwere-Leiter WARN/ERROR/FATAL als benannte Stufen: kein expliziter dreistufiger Typ; WARN existiert nur als Einzelfall-Praedikat kNoPinnedLocalityWarning ("KEINE Fehlerklasse").
ORT: numa_cpu_pin_process_probe.hpp:73-78
SOLL/FIX: benannte Stufen bauen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: F-15

### [w1buo8hac] 85
GEGENSTAND: L3-Asymmetrie-Messung PFLICHT (8 Kerne je Domaene, 96 vs. 32 MB): gesamte Mess-Seite fehlt (keine XML-Deklaration core_class, kein Pinning auf Domaene, keine getrennte Ablage); Erkennung gebaut, prod1 bestaetigt 128 MiB in 2 Instanzen.
ORT: golden-XML (core_class nicht deklariert)
SOLL/FIX: S-04: W1-S-E + W4-C.
STATUS LT. QUELLE: offen (nur-spezifiziert)
ABHAENGIGKEIT/FLAECHE: B-2/B-3 (Eintraege 82/83)

### [w1buo8hac] 86
GEGENSTAND: EINE CEB traegt beide Messfuehler, Ablage je PMC getrennt (Permutation statt zweiter Binary): Ausfuehrungs- und Ablage-Haelfte fehlen vollstaendig; nur Nicht-Verdopplungs-Garantie steht (ABI-Vorbedingung CT-erzwungen).
ORT: unbekannt
SOLL/FIX: OV-9-abhaengig (Hybrid-CPU fehlt physisch).
STATUS LT. QUELLE: offen (nur-spezifiziert)
ABHAENGIGKEIT/FLAECHE: OV-9; S-05

### [w1buo8hac] 87
GEGENSTAND: Stiller-Rueckfall-Regel (OWNER-KERN LEDGER:4524-4540): in ce vier Mal gebaut, in super genau an der einen Stelle nicht, an der sie faellt.
ORT: super (Stelle: s. Eintrag 45 metadata mode)
SOLL/FIX: super-Stelle heilen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Eintrag 45

### [w1buo8hac] 88
GEGENSTAND: YAML-Schluessel-Wache (Top-Level-Schluessel genau einmal): super traegt die Wache nicht; Selbst-benannte Grenze offen (rufender Job dupliziert + von inerter Fassung ueberschrieben -> Wache faehrt nicht mehr).
ORT: Skript :50-55
SOLL/FIX: super-Wache nachziehen; Grenze aufloesen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Wachen-Register

### [w1buo8hac] 89
GEGENSTAND: super hat KEINE Abdeckungs-Wache: alle super-eigenen Registrierungspunkte tragen HEUTE das Label da_unit (vollstaendig), aber nichts haelt sie so; 424 Rest-Tests sind ce-Sub-Build-Tests, deren Deckung nirgends nachgewiesen.
ORT: super tests/CMakeLists.txt:17+:237; 02_messung_driver:100/139/172/189/209/221; 03/04/05/06/08/09 je eine gtest_discover_tests-Zeile
SOLL/FIX: F-13 super-Abdeckungs-Wache bauen (W0b.7).
STATUS LT. QUELLE: offen (fehlt)
ABHAENGIGKEIT/FLAECHE: W0b

### [w1buo8hac] 90
GEGENSTAND: super Sammel-Target comdare_da_unit_tests: 6 Subdirs (03/04/05/06/08/09) rufen gtest_discover_tests OHNE set_property(GLOBAL APPEND COMDARE_DA_TEST_TARGETS ...) -- anders als 02_messung_driver (korrekt); GNU-Weg maskiert den Defekt heute; Falle scharf sobald jemand nur das Sammel-Target baut.
ORT: super 03/04/05/06/08/09 CMakeLists.txt; Vorbild 02_messung_driver:101/:140/:173/:190/:210/:222
SOLL/FIX: set_property-Zeilen nachziehen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: F-13

### [w1buo8hac] 91
GEGENSTAND: CI-5 -j/RAM-Politik je Runner-Tag: keine Politik JE TAG (prod2 -j2 < prod-amd), nur globaler Wert + zwei handgesetzte Ausnahmen; Gate-Vorbedingung nicht erfuellt.
ORT: CI-Konfiguration
SOLL/FIX: Politik je Runner-Tag.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -

### [w1buo8hac] 92
GEGENSTAND: Abdeckungs-Wache 'declared:VAR ungesetzt' fail-open: Wache unterscheidet nicht "ausserhalb CI" von "Variable in CI verschwunden"; fragt weder $CI noch $CI_JOB_ID (grep 0).
ORT: Abdeckungs-Wache
SOLL/FIX: in CI-Umgebung ungesetzt == keine Deckung; ausserhalb Annahme + Vermerk. Exposition heute 2 pmc-Tests.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W1 quer

### [w1buo8hac] 93
GEGENSTAND: E-07-Gate Stufe 2 (literale E07_*-Zeilen K1-K5, N1-N3): vollstaendig ungebaut -- acht Kriterien, zehn Ausgabezeilen, kein Traeger.
ORT: 0 Treffer ausserhalb docs/
SOLL/FIX: F-12 in W2-S-D (Paket 41: zehn Zeilen MIT Nenner, Negativproben N1-N3 muessen anschlagen).
STATUS LT. QUELLE: offen (nur-spezifiziert)
ABHAENGIGKEIT/FLAECHE: W2-S-D

### [w1buo8hac] 94
GEGENSTAND: Eigener Exit-Code fuer Konformitaets-Fail in execute_messreihe (Audit-Vorschlag 6): nicht belegt; Unterscheidung nur auf Zell-Ebene.
ORT: execute_messreihe
SOLL/FIX: dokumentierten Prozess-Exit-Code einfuehren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Eintrag 68

### [w1buo8hac] 95
GEGENSTAND: Registry-Round-Trip-Gate: fuer prt_art_axis_registry.xml KEIN Round-Trip-Gate (nur gelesene Fixture); Soll nannte BEIDE XMLs.
ORT: ce tests/unit/CMakeLists.txt:3393, :3414
SOLL/FIX: zweites Gate bauen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Eintrag 31

### [w1buo8hac] 96
GEGENSTAND: visibility:tier-binaries: prueft nur PRAESENZ des Feldes binary_id=, nicht Wert != '-' (THESIS-Profile emittieren durchgaengig binary_id=-); strengere Pruefung als OP-4 offen.
ORT: Job :484-487 (dokumentiert Abschwaechung selbst)
SOLL/FIX: OP-4 umsetzen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -

### [w1buo8hac] 97
GEGENSTAND: Test-Skip-Gesetz (zweite Erfassung): Test-Log NEBEN der Binary als Lager-Skip-Bedingung nicht belegt; Skip-Entscheidung haengt am Bestands-/Fingerprint-Pfad.
ORT: s. Eintrag 67
SOLL/FIX: wie Eintrag 67.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: W3-S-C

### [w1buo8hac] 98 (BLOCKIEREND B0)
GEGENSTAND: 'make check' (ce) laesst das Reconfigure weg -> unvollstaendige Suite als gruene Vollstaendigkeitsaussage: Tests werden erst nach Bau der Codegen-Werkzeuge + ZWEITEM CMake-Lauf registriert; gemessen 427 statt 431 Tests (4 codegen-abhaengige Tests unsichtbar). CI-Job test:coverage-guard macht den 2-Pass, der offizielle Anwenderweg nicht.
ORT: /home/comdare/wt-ce-fk/Makefile:83-86; Gegenstueck /home/comdare/wt-super-landung/Makefile:107-108+:117; Ursache ce tests/unit/CMakeLists.txt:1070-1103 (R5.I) und :1177-1207 (F15); anatomy_codegen_runner.cmake ohne CMAKE_CONFIGURE_DEPENDS; ce .gitlab-ci.yml:294-301
SOLL/FIX: Reconfigure in check-Ziel; Endfassung: auf origin/development BEREITS GEHEILT (check: inventar; inventar: all mit $(CMAKE) -S -B, Makefile Z.91/124-126) -> nur noch Gegenprobe (W-1.5/Paket 05: ctest -N vor/nach Reconfigure, zwei Zahlen + Differenz; Koeder: Test der NUR nach 2. Configure existiert).
STATUS LT. QUELLE: laut Endfassung behoben auf origin/development; Gegenprobe offen
ABHAENGIGKEIT/FLAECHE: W-1.5

### [w1buo8hac] 99 (BLOCKIEREND B1)
GEGENSTAND: Abdeckungs-Wache rechnet ueber zu kleinem Nenner: Ground-Truth ist 'ctest -N' auf build-covguard mit nur EINEM 2-Pass (Codegen-CLI); R5.G-Familie haengt an comdare_adhoc_emitter_cli -- grep adhoc_emitter .gitlab-ci.yml = 0, kein Job baut es, kein Job baut 'all' -> _r5g_ae_status nie FOUND, Block uebersprungen, Tests test_v41_anatomy_adhoc_autobuilt_load und f15_compare_cli_smoke existieren in der Inventur nicht. Jeder neue Test im R5.G-Block ist ab Geburt unsichtbar fuer CI UND Wache.
ORT: /home/comdare/wt-ce-fk/scripts/ci_test_coverage_guard.sh:41-45, :85-89; .gitlab-ci.yml:294-301; ungesehener Block tests/unit/CMakeLists.txt:1542-1592
SOLL/FIX: W0a.1: Nenner ausserhalb der eigenen Inventur verankern -- STATUS_OUT-Bloecke aus der CMake-QUELLE erheben (LIVE FUENF: :1070 _r5i_status, :1118 _pa_status, :1150 _fj_status, :1177 _f15_status, :1545 _r5g_ae_status, an ZWEI Werkzeugen), je Block FOUND im Configure-Log verlangen; jede SKIPPED-Zeile = rot (heute grep SKIPPED ueber ce CI/scripts/Makefile = 0). Koeder: Block scheitern lassen -> rot; sechsten Block einfuegen -> Zaehler 6.
STATUS LT. QUELLE: offen (blockiert-abgabe)
ABHAENGIGKEIT/FLAECHE: W0a; alle W1-Abnahmen zitieren die Wache

### [w1buo8hac] 100 (BLOCKIEREND B2)
GEGENSTAND: Voll-Messlauf akzeptiert leeres Messfenster: Erfolgsbedingung nur Existenz IRGENDEINER measurements.csv; Zeilenzahl ausgegeben, nirgends geprueft; Kopfzeilen-CSV besteht; persist:measurements schreibt leere CSVs additiv zurueck, Kette bleibt gruen.
ORT: /home/comdare/wt-super-landung/.gitlab-ci.yml:885-886 (measure:golden-320), :796-797 (measure:smoke)
SOLL/FIX: W0b.1/Paket 26: ueber ALLE CSVs iterieren, zwei Zahlen (gesamt / mit >= 2 Zeilen), Differenz != 0 = rot; awk 'END{print NR}' statt wc -l (Datei ohne Schluss-Umbruch sonst falsch rot).
STATUS LT. QUELLE: offen (blockiert-messung)
ABHAENGIGKEIT/FLAECHE: W0b; teuerstes Objekt (bis 10 Tage Lauf)

### [w1buo8hac] 101 (BLOCKIEREND B3)
GEGENSTAND: Drift-Gate erklaert DEGENERIERTE Messung fuer STABIL: assess_drift rechnet relative_drift nur bei median_ns>0; Median 0 -> drift=0, unstable=false, run_with_drift_gate kehrt mit stable=true/reruns=0 zurueck; DriftVerdict hat keinen Zustand 'unbestimmbar' (reps==0-Fall dagegen behandelt). GRUEN MIT NENNER 0.
ORT: /home/comdare/wt-ce-fk/libs/cache_engine/builder/commands/drift_detector.hpp:42-50, :53-56, :69-72, :128-134
SOLL/FIX: WICHTIG Einwand 12/25: das Gate ist NIRGENDS VERDRAHTET (DriftVerdict/assess_drift/run_with_drift_gate nur im Header selbst + test_chaos_drift_gate.cpp, NULL Produktions-Aufrufer) -- "es laesst nichts durch, es laeuft nicht". Endfassung: T-15 nach W2-S-C = VERDRAHTEN (run_with_drift_gate in perm_runner/parallel_measure_pool), nicht erweitern; Abnahme Paket 36: reruns:n / abgebrochene Zellen:m echte Wirkung; bleibt es nur im Test -> Paket nicht abgenommen.
STATUS LT. QUELLE: offen (Einstufung "blockiert-messung" von der Endfassung zu "unverdrahtet" korrigiert)
ABHAENGIGKEIT/FLAECHE: W2-S-C

### [w1buo8hac] 102 (BLOCKIEREND B4)
GEGENSTAND: ZWEI numerisch verschiedene Perzentil-Verfahren unter demselben Namen 'Nearest-Rank': (A) stats::percentile_ns k=min(n-1,floor(q*n)); (B) detail::nearest_rank_p rank=round(p*(n-1)); nachgerechnet 1..100: p95 A=96/B=95, p99 A=100/B=99. Dazu DRITTER 'Median' (best_binary_selector untere Mitte vals[(n-1)/2]) und vierter (eta_kalibrierung mittelt bei geradem n). Widersprueche: tier_observe_trace.hpp:11 behauptet "kein neuer Perzentil-Code", drift_detector.hpp:16-18 behauptet "KEINE Methoden-Drift".
ORT: latency_stats.hpp:12,23-31; tier_observe_trace_abi.hpp:68-75 (Aufrufe :307-314); genus_tier_observe_trace_abi.hpp:327-333; tier_observe_trace.hpp:11,47; best_binary_selector.cpp:185-188; eta_kalibrierung.hpp:183-194 (alle unter /home/comdare/wt-ce-fk/libs/cache_engine/builder/)
SOLL/FIX: W-06/Paket 18: EINE Methode, Rang-Formel korrigieren (Formel 1 Rang zu hoch -> p99 == max fuer n <= 100); sonst kann die Thesis keine eine Methode dokumentieren ohne Selbstwiderspruch.
STATUS LT. QUELLE: offen (blockiert-abgabe)
ABHAENGIGKEIT/FLAECHE: W1-S-A

### [w1buo8hac] 103 (EINWAND 1, tragend)
GEGENSTAND: W4-Vor-Gate "E.0 Kern-Mess-Schema PFLICHT" ist Name mit falschem Zeiger (E.0 ist das WACHEN-REGISTER); Par.59-Kette (SCHEMA/EMITTER/MERGE-STEMPEL/STORAGE/TEMPLATE, alle "OFFEN, kritisch") kam in keiner Welle vor; Par.59 traegt DRITTEN Tier-Binary-Stempel (Merge-Kombination, POD 56->72, layout 2->3) = Identitaets-Aenderung vor W3-Freeze.
ORT: LEDGER:3073, :3242, :3285-3289
SOLL/FIX: Endfassung F-17: Par.59-SCHEMA/EMITTER/TEMPLATE -> W1-S-F; MERGE-STEMPEL/STORAGE -> W2-S-B; W4-Vor-Gate zeigt auf Par.59-SCHEMA.
STATUS LT. QUELLE: eingearbeitet in Endfassung; Bau offen
ABHAENGIGKEIT/FLAECHE: Bump-Buendel (POD 56->72); W1-S-F/W2-S-B

### [w1buo8hac] 104 (EINWAND 2, tragend)
GEGENSTAND: Fingerprint-Preimage-Sperrliste mit unvollstaendigem Nenner; sechs identitaetsberuehrende Posten fehlten: RF-8 telemetry, RF-2 (D1-gesperrte Permutationen mit eigenem CSV-Datensatz+D1-Token), RF-7 Stempel-Klammerung, Par.70.9 C-3a (Gate-Beitraege bei Scharfschaltung in Identitaet sichtbar), bindende Achsen-Sortierung (LEDGER:11106-11113 selbst Preimage), Flag-Grammatik-v2 (laeuft noch, mmx-Deklaration offen).
ORT: LEDGER:3682, :8347ff, :11106-11113
SOLL/FIX: Sperrliste MASCHINELL ABLEITEN aus kAnatomyFingerprintGliedCount = 9 (anatomy_fingerprint.hpp:416, Indizes System 2, Toolchain 5, Bvset 6, Overlay 7, MessGates 8); Wache rot wenn Preimage auf 10 waechst; je Glied Welle oder "bewusst offen" (W1-S-G Paket 14).
STATUS LT. QUELLE: eingearbeitet; Bau offen
ABHAENGIGKEIT/FLAECHE: R-2; W3-Freeze-Freigabe

### [w1buo8hac] 105 (EINWAND 3+OV-13, tragend)
GEGENSTAND: Paper-Research/Paper-Kopplung = wissenschaftliche Frage der Arbeit hatte keine Welle; Plan schob nach W7 hinter die Abgabe ohne Owner-Vorlage; W5-Break-Even beantwortet die Frage, die der Owner NICHT gestellt hat.
ORT: LEDGER:11117-11128
SOLL/FIX: OV-13 explizit dem Owner vorlegen (a: eigene W2-Spur; b: W7 mit Klartext-Konsequenz); nicht implizit durch Einsortierung.
STATUS LT. QUELLE: offener Owner-Entscheid
ABHAENGIGKEIT/FLAECHE: OV-13; PV-4

### [w1buo8hac] 106 (EINWAND 4, tragend)
GEGENSTAND: Klasse "GEBAUT ABER UNVERIFIZIERT" (U-01..U-08) war ungeplant; 5 von 8 in keiner Welle: U-01 dynamische Planer-CI, U-02 measure:golden-320, U-03 anhang:forward, U-07 Tier-Binary-Caching cluster-weit, U-08 build:clang.
ORT: s. Einzelposten
SOLL/FIX: Zielwellen vergeben: U-01 W2-D (gefahrene Kaskade mit Job-IDs Parent/Child/Grandchild), U-02 W3-B (Kalibrierlauf = Vollzug), U-03 W1-A, U-04 W1-B, U-05 W-1 neu erheben, U-06 W1-E, U-07 OV-9, U-08 W-1 neu erheben (274e4ed2 IST auf origin/development).
STATUS LT. QUELLE: eingearbeitet; Vollzuege offen
ABHAENGIGKEIT/FLAECHE: V-3 GATE-VOLLZUG (Job-ID + Log-Zeile)

### [w1buo8hac] 107 (EINWAND 4-Detail: anhang:forward-Defekt)
GEGENSTAND: anhang:forward ist der EINZIGE Vorwaerts-Kanal Messwerte -> Thesis-Submodul; AF_GENERATOR per Default LEER (anhang_forward_core.sh:95 AF_GENERATOR="${AF_GENERATOR:-}"); ungeplanter Defekt: git add mit 2>/dev/null || true, danach Meldung "anhang:forward IDEMPOTENT: 0 Aenderungen" und Exit 0.
ORT: ci/anhang_forward_core.sh:95; super .gitlab-ci.yml:1128ff
SOLL/FIX: U-03 scharf in W1-S-A (Paket 20): AF_GENERATOR belegen; das geschluckte "|| true" beim git add faellt; Abnahme: Job-ID + geaenderte Dateien; leeres AF_GENERATOR -> rot statt "IDEMPOTENT/Exit 0".
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: R-1 (hoechstes Risiko: Ausgabe-Kette an beiden Enden offen)

### [w1buo8hac] 108 (EINWAND 5/E.2-W5-W6, tragend)
GEGENSTAND: Abgabe-Seite prueft nie "Arbeit beantwortet ihre Fragen": FF0-FF4 ("mit realen, CI-verifizierten Messwerten beantwortet") und DoD 1-7 kamen im Plan nicht vor; Diagramm-Emitter (2D/3D statt Heatmap, SOTA-Visualisierung) fehlt; Thesis-Repo traegt .ps1/.py auf dem Lieferpfad (build.ps1, build_all.ps1, generate_measurement_appendix.ps1, generate_wide_appendix.ps1, tools/format_tex.py; anhang/de/A_measurements.tex:4 nennt .ps1 als Erzeuger).
ORT: LEDGER:128/:238/:345; thesis-Repo
SOLL/FIX: F-19 FF0-FF4-Abnahmematrix (W2-S-F anlegen, W5 ausfuellen, Nenner 5, leer beantwortete Frage = rot); F-07b Diagramm-Emitter (W2-F); F-18 .ps1/.py-Abloesung + Verdrahtung measure -> 08_appendix_generator -> anhang/tabellen -> PDF (W2, nicht W5).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: W2-S-F; Doktrin "kein Python in der Buildchain"

### [w1buo8hac] 109 (EINWAENDE 6/13/14/35 -- Erhebungs-Basis, teils widerlegt)
GEGENSTAND: Gesamter Entwurfs-Diff war ueber Arbeitsbaum b2daf9a6 (bau/doktrin-aufraeumung) erhoben, 29 Commits hinter origin/development; zwei Einwaende gegen lokale development-Referenz (80 Commits alt) gemessen und WIDERLEGT: development:Makefile EXISTIERT auf origin/development; A9-S4 = 6 Commits/17 Dateien (nicht 82/386); alle 13 heutigen ce-Commits SIND auf origin/development.
ORT: git-Messungen in der Endfassung (Abschnitt 0)
SOLL/FIX: Konsequenz bindend: W-1 (landen + A.1-A.5 NEU ERHEBEN, Erhebungs-SHA in JEDE Zeile); kein Paket gegen den Arbeitsbaum-Stand bauen.
STATUS LT. QUELLE: Einwaende teilweise widerlegt; W-1-Auflage offen
ABHAENGIGKEIT/FLAECHE: W-1; Fall "Nullbefund ueber zu kleinem Nenner"

### [w1buo8hac] 110 (EINWAND 15/OV-10, tragend)
GEGENSTAND: "Sechs CEB-Varianten" mit G3 allein arithmetisch unerreichbar: Gate-Bedarfe sind KETTE (wallclock G1, macro G1+G2, micro G1+G2+G3) -> maximal 4 Teilmengen-Zustaende; SOLL nennt 3!-PERMUTATION (Reihenfolge). Definitionsluecke nirgends aufgeloest, war aber harte binaere W2-Abnahme.
ORT: mess_achsen_naht.hpp:74-77
SOLL/FIX: OV-10 Owner-Entscheid: (a) Teilmenge -> Abnahme "vier + belegte Begruendung" (Empfehlung); (b) Permutation -> Gate-Kette aufbrechen (Umbau im Identitaets-Fenster, Bump-Folge). Abnahme-Werkzeug Paket 13: nm-Diff auf BENANNTE micro-Symbole, Stempel-Region kFP/kL AUSNEHMEN (Byte-/Hash-Vergleich wertlos: COMDARE_ANATOMY_VERSION_STAMP_M anatomy_module_abi_v1.hpp:162-204 bettet kFP ein; MessGatesGlied rein praeprozessoral).
STATUS LT. QUELLE: offener Owner-Entscheid
ABHAENGIGKEIT/FLAECHE: OV-10; W2-S-A

### [w1buo8hac] 111 (EINWAND 16, tragend)
GEGENSTAND: --check-size rechnet vor der eigenen Multiplikation (golden-XML traegt genau EINE combo, W2 stellt auf N zurueck); W2-S-A und W2-S-C arbeiten gegenlaeufig an DERSELBEN XML-Sektion; A9-S5-Archiv-Verifikation traegt nicht (Archiv-CSV 5.761 Zeilen/134 Spalten, 0 op_-Spalten; |F| = 0 gegen Blattform Fassung 3).
ORT: experiment_golden_kern.xml:405-417; experiment_plan_director.hpp:1891-1895; docs/archiv/messdaten/20260606-fullpilot-320/tier150_measurements.csv; kOpKindNames cache_engine_builder_iterator.hpp:470-487
SOLL/FIX: --check-size gibt je Combo-Fanout UND je working_set-Stufe aus; W2-S-A+S-C zusammengelegt; A9-S5 zweiteilig (a: Archiv INFO+|A|-Achsenblaetter mit n/a; b: frischer Mini-Lauf 1 Binary/1 Perm fuer Funktionsblaetter).
STATUS LT. QUELLE: eingearbeitet; Bau offen
ABHAENGIGKEIT/FLAECHE: W1/W2; OV-4

### [w1buo8hac] 112 (EINWAENDE 17-22, tragend, Sammel)
GEGENSTAND: (17) F-10 B-2 Pinning als Vorbedingung genannt aber ohne Welle -> W2-S-E vor Freeze. (18) LEDGER:4750-4752 Gegen-Reihenfolge B-10<-B-9<-B-7/8<-Messung<-B-3/5 -- Aufloesung: Ledger-Zeile gilt fuer FORM der Kurve, W1-A baut nur Datenunabhaengiges, F-05 datenabhaengig W5. (19) checkpoint_measure ohne Konsument im Fenster -> OV-2(a) nur mit B-8 im selben Paket. (20) W1-Spuren nicht dateidisjunkt (cache_engine_builder_iterator.hpp 3.035 Z.; S-E :470/:623, S-B :1200/:2865-2871, S-A :1146) -> bindend: S-E aendert lazy_csv_header ZUERST+EINMALIG. (21) Bump-Buendel: LEDGER:135/:408 "nach 3->4 genau EIN weiterer Bump 4->5" (Risiko B4); mind. 6 Anspruchsteller (G3-Split, Par.59-MERGE-STEMPEL, RF-7, IDriveableTier-Split, checkpoint_measure, A16 E-24) -> genau EIN Magic-Wechsel im Fenster, Abnahme Paket 34 (git log -p Filter ABI-Magic). (22) W0 gesplittet: W0a hart vor W1 (0,5 Tage), W0b als Spur in W1 mit Abnahme vor W3.
ORT: s.o. je Einwand
SOLL/FIX: verbatim wie aufgefuehrt.
STATUS LT. QUELLE: eingearbeitet; Bau offen
ABHAENGIGKEIT/FLAECHE: Bump-Buendel; W1-Reihenfolge

### [w1buo8hac] 113 (EINWAND 23, tragend)
GEGENSTAND: Schluss-Gate strukturell blind: A_measurements.tex bindet jede Messtabelle als \InputIfFileExists{...}{}{Ersatztext} (28 Eintraege; Z.73 "kompiliert auch VOR dem ersten Messlauf sauber"); Par.7-Hard-Gate (thesis/.gitlab-ci.yml:80-83) prueft latexmk -halt-on-error, Warnings <= 1, .blg -- KEINES zaehlt Tabellen; PDF ohne einzige Messtabelle baut gruen. Verschaerft: appendix_generator honest-empty (appendix_generator.cpp:185) und Mess-Job faengt Scheitern mit "$APP" ... || echo ab.
ORT: thesis anhang/de/A_measurements.tex; thesis/.gitlab-ci.yml:80-83; Code/08_appendix_generator/appendix_generator.cpp:185; super .gitlab-ci.yml (|| echo Zeile)
SOLL/FIX: Paket 58: Soll-Liste der 28 InputIfFileExists-Ziele gegen wirklich gefundene Dateien, beide Zahlen, Differenz != 0 = rot; Paket 58b: \thesisfinal-Schalter macht Ersatztext-Zweig zum LaTeX-Fehler; das '|| echo "honest-empty ... kein Fehler"' hinter dem appendix-generator faellt ersatzlos.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: W5/W6-Abnahmen

### [w1buo8hac] 114 (EINWAND 24, tragend)
GEGENSTAND: W4-Abnahme "je Zelle Zeilenzahl > 0" ist bei VOLLSTAENDIG gescheitertem Bau erfuellt: Bau-Fehler-Zweig schreibt nicht_gebaut-Marker-Zeile als NEUE result.csv (:2421) und in die globale CSV (:2424ff) -- jede Zelle >0 Zeilen, Zellzahl stimmt exakt.
ORT: cache_engine_builder_iterator.hpp:2421, :2424ff; Token-Liste measurement_curve_loader.hpp:72 (n/a, failed, gesperrt, nicht_gebaut, -, "")
SOLL/FIX: Paket 53: Mess-Nenner zellen_mit_echtem_messwert/zellen_gesamt + Haeufigkeit jedes Ersatz-Tokens (Single-Source measurement_curve_loader.hpp:72), alles gedruckt UND im Exit-Code; Schwelle: nicht_gebaut > 0 = Abbruch vor Auswertung.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: W4-Abnahme

### [w1buo8hac] 115 (EINWAND 26, tragend)
GEGENSTAND: WACHEN-REGISTER erbt den Defekt, gegen den es gebaut wird: (a) Nenner aus sich selbst (nicht eingetragene Wache macht Job nur kleiner); (b) Koeder-Felder als Markdown-Text (abgeschriebener und echter Koeder identisch, K13 nicht durchsetzbar); (c) Sanktion ohne Vollzieher.
ORT: E.0/W0.6 des Entwurfs
SOLL/FIX: 7.0 neu: Nenner ausserhalb (Grundmenge = alle ci/+scripts/-Dateien beider Repos + verdiktdruckende Jobs; heute ce scripts/ = 8 .sh, super scripts/+ci/ = 5 .sh, 28 ce + 30 super Top-Level-CI-Schluessel); Abgleich BEIDSEITIG rot; Koeder wird GEFAHREN (Job erzeugt zufaellige Verletzung, erwartet rc != 0); Felder nenner_ausdruck/abbruch_bei_null/koeder_rot/koeder_gruen/gate_vollzug -- fehlt eines: Job rot.
STATUS LT. QUELLE: offen (W0b.6/Paket 31)
ABHAENGIGKEIT/FLAECHE: alle Wachen; V-1..V-6

### [w1buo8hac] 116 (EINWAENDE 29/31/32/33/34/36, wichtig, Sammel)
GEGENSTAND: (29) ETA und --check-size nicht unabhaengig: projiziere_kampagne (eta_kalibrierung.hpp:294-296) kalibriert nur Zeit je Binary, Stueckzahl = --check-size-Wert -> zweiter Zaehler muss MENGE unabhaengig erheben (Teilbaum-Probelauf, Auszaehlung realer Blaetter); W3 nur freigeben wenn projiziere_kampagne Produktions-Aufrufer hat (T-16). (31) V-6 PLAN-NENNER: Abnahme-Nenner = Paketzahl; Paket ohne Abnahmezeile -> Welle nicht abgenommen. (32) xlsx-Abnahme: Zeilenzahl je Blatt gegen Eingangs-CSV (unabhaengiger Nenner), nicht unzip -l allein; SKIP druckt geschrieben/uebersprungen. (33) Naht S-A/S-B = eigenes Paket W1-S-H mit Besitzer+Termin; OV-8 symmetrisch. (34) measure-Gate awk statt wc -l. (36) super taugt NICHT als Reconfigure-Vorbild: Code/CMakeLists.txt:213/245 EXCLUDE_FROM_ALL -- "610 Tests vor wie nach Reconfigure" ist Folge des Ausschlusses, keine Messung.
ORT: s.o.
SOLL/FIX: verbatim wie aufgefuehrt.
STATUS LT. QUELLE: eingearbeitet; Bau offen
ABHAENGIGKEIT/FLAECHE: divers

### [w1buo8hac] 117 (EINWAND 40/frist)
GEGENSTAND: Entwurf verplante 27/27 Werktage (100,0 %), kein Puffer-Budget; W0 verbrauchte bereits ein Wochenende unausgewiesen; W5 einzige Welle mit inhaltlicher Vorbedingung (Messdaten aus W4) -- W4-Verzug von 2 Tagen halbiert W5.
ORT: Abschnitt C des Entwurfs
SOLL/FIX: Reserve benannt: 1 Werktag + 11 Wochenendtage; Entnahme-Stand je Welle; W5 auf 3 Arbeitstage, Do/Fr Fangnetz.
STATUS LT. QUELLE: eingearbeitet
ABHAENGIGKEIT/FLAECHE: Zeitraster W-1..W6

### [w1buo8hac] 118 (EINWAND 41/OV-4)
GEGENSTAND: Mess-Mengen-Deckelung hat kein Ausdrucksmittel: measure_selection|measurement_selection = 0 Treffer in BEIDEN Repos (*.hpp/*.cpp/*.xml/*.xsd); drei Auswege verschlossen (Ein-Thread im Praesens gebunden 05_evaluation.tex:133-134; zweite Lane fehlt; 0,1094 s Untergrenze); separate XML = Prinzipverstoss (GESAMTDOSSIER:2591-2594). OV-4 ist kein Entscheid sondern BAU-PAKET, beruehrt Fingerprint, muss vor W3-Freeze landen.
ORT: beide Repos (Negativbefund); golden-XML :410-414
SOLL/FIX: F-01b <measure_selection> bauen: Schema + XSD + Validator + strukturelle Teilmengen-Garantie (W1-S-D Paket 11; Koeder: Mess-Eintrag auf nicht deklarierte Permutation -> Fehlerklasse, nicht Warnung).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: W1-S-D; W3-Freeze; Owner-Entscheid D-3

### [w1buo8hac] 119 (EINWAND 42/R-4/OV-9)
GEGENSTAND: prod2 existiert nicht (getent hosts prod2 rc=2; hostname=prod1, AMD 9950X3D 32 Threads); Thesis sagt Zwei-Maschinen-Betrieb/zwei Vendor-Lanes/P-E-Core-Trennung im PRAESENS zu (05_evaluation.tex:76-82); 9950X3D hat keine E-Cores, Hybrid-CPU i9-12900K fehlt. Bau passt trotzdem auf prod1 (~41,4 h). prod1 traegt GitLab-Runner auf derselben Platte; / LIVE 80 % voll, 35/60 GB RAM belegt.
ORT: kapitel/de/05_evaluation.tex:76-82; LIVE-Messungen
SOLL/FIX: OV-9 Entscheid VOR W3: (a) prod2 bis Fr 21.08. (L2) herstellen ODER (b) 05_evaluation.tex:70-82 auf Ein-Maschinen-Betrieb zurueckziehen, fehlende Vendor-Lane als Methodikgrenze ausweisen. Kein dritter Weg.
STATUS LT. QUELLE: offener Owner-Entscheid
ABHAENGIGKEIT/FLAECHE: OV-9; S-05/U-06/U-07; D-3 bindet Bau-Menge an Maschinenzahl

### [w1buo8hac] 120 (EINWAND 43/F-16)
GEGENSTAND: W4 hat kein Wiederaufnahme-Korn: MESS-Batch faehrt volles Fenster in EINEM Treiber-Aufruf je Perm; Thesis behauptet im Praesens 4096er-Batches + Verteilung + inventarisierte Wiederaufnahme (05_evaluation.tex:139-142) -- drei Zusagen, die die Mess-Seite nicht haelt.
ORT: GESAMTDOSSIER:2589 (R-2 Zweitbefund); 05_evaluation.tex:139-142
SOLL/FIX: F-16 Mess-Resume auf 4096er-Korn in W2-S-C (Paket 35; Abnahme: Lauf nach 2 Batches hart abbrechen, neu starten, measured_new ueberspringt gemessene Zellen); falls nicht gebaut: Textstelle korrekturpflichtig (R-3-Sperrliste).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: W2-S-C; R-3 Praesens-Zusagen

### [w1buo8hac] 121 (EINWAND 47/R-3)
GEGENSTAND: DREI Praesens-Zusagen der Thesis, die der Code nicht haelt: (1) Zwei-Maschinen-/Zwei-Vendor-/P-E-Core-Betrieb (:76-82); (2) 4096er-Mess-Batches mit Verteilung+Wiederaufnahme (:139-142); (3) "vor jeder Messung Konformitaetspruefung am Pruef-Dock" (:137-138, wahr fuer ce perm_runner.hpp:196/:289, unwahr fuer super v32_katalog_driver.hpp:128/:152/:154 -- schreibt nur, 0 Leser).
ORT: kapitel/de/05_evaluation.tex
SOLL/FIX: SPERRLISTE DER PRAESENS-ZUSAGEN, Nenner 3: jede bis L4 erfuellt ODER bis L5 im Text korrigiert; Wache Paket P-1 (geprueft: 3 / erfuellt-oder-korrigiert: 3, Abbruch bei 0). STREICH-KASKADE bei globalem Zeitriss: 1. checkpoint_measure, 2. Hybrid, 3. COMPARE/D2, 4. Break-Even-Neubau B=3 (dann Hermite ratifizieren + begruenden), 5. F-07b Diagramme; NICHT STREICHBAR: die drei Praesens-Zusagen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: W5/W6; OV-9/OV-11

### [w1buo8hac] 122 (Endfassung: OWNER-ENTSCHEIDE OV-1..OV-14, Sammel)
GEGENSTAND: Offene Owner-Vorlagen laut Endfassung: OV-1 Break-Even-Kurve (a B=3 B-Spline Neubau [Empfehlung, Owner-KERN Gesetz] vs. b Hermite ratifizieren; Code baut Hermite, 0 Treffer bspline); OV-2 checkpoint_measure (a W2 nur mit B-8 + im Bump-Buendel / b W7 [Empfehlung falls B-8 fehlt]); OV-4 Mess-Mengen-Deckelung (Entscheid an W1-Abnahme mit beiden Zahlenreihen, NACH OV-10); OV-5 Mess-Exklusivitaet global vs. je Maschine (Empfehlung je Maschine, vor W3; nachrangig solange OV-9 offen); OV-6 PMC-Anhangs-Umfang (nach W1-S-E; haengt an OV-9); OV-8 CSV-Notlinie (nur als benannte Regression+TODO, nie still; symmetrisch S-A/S-B); OV-9 prod2 (s. Eintrag 119); OV-10 6 CEBs Permutation/Teilmenge (s. Eintrag 110); OV-11 Voll-Lauf-Treiber (a perm_runner scharf [Empfehlung] / b Katalog-Treiber erst nach Angleichung); OV-12 Hysterese vs. Flatter-Bereich (bis Entscheid KEINE Variante verdrahten); OV-13 Paper-Kopplung (s. Eintrag 105); OV-14 RF-5 V36.B-Codegen-CMake + A5-Value-Filter (beide echte offene Owner-Entscheide, Ledger markiert selbst als offen).
ORT: Endfassung Abschnitt 10
SOLL/FIX: je OV wie angegeben; OV-7 (fuenfte Mess-Ebene) GESTRICHEN -- im Ledger beantwortet (LEDGER:11098/:11104 "Also 5.").
STATUS LT. QUELLE: offen (Owner)
ABHAENGIGKEIT/FLAECHE: quer

### [w1buo8hac] 123 (Endfassung: ENTLASTUNGEN E-1..E-6)
GEGENSTAND: Vom Entwurf zu duester gesehene Befunde: E-1 make check auf origin/development geheilt; E-2 A9-S4 real 6 Commits/17 Dateien; E-3 alle 13 heutigen ce-Commits gelandet; E-4 Thesis-Anhaenge B/E heute gefuellt (257/157 Zeilen) -- kein offener Posten; E-5 fuenfte Mess-Ebene im Ledger beantwortet; E-6 Hybrid im Futur formuliert -- keine Falschaussage.
ORT: Endfassung Abschnitt 2.6
SOLL/FIX: Designer: diese Befunde NICHT als offen fuehren.
STATUS LT. QUELLE: erledigt/entlastet
ABHAENGIGKEIT/FLAECHE: Dedup gegen andere Quellen

### [w1buo8hac] 124 (Endfassung: W0b-Wachenpakete, Sammel)
GEGENSTAND: W0b-Wachen (blockieren Messung, Abnahme vor W3): W0b.2 Diff-Wache --seit-basis ncommits==0 = ABBRUCH + .sh in Scope (is_scoped() scripts/ci_diff_ascii_width_guard.sh:218-231 kennt kein .sh -- Wachen selbst unbewacht); W0b.3 changes-Allowlist um ci/** und scripts/**, ce GNU-Bauweg unter CI-Wache, COMDARE_LINT_PATHS zeigt ins Leere + tools/ fehlt; W0b.4 scripts/lint_flags_includes.sh endet bei leerer Tabelle mit WARN+Exit 0 und einziger Aufrufer ist .github/workflows/ci.yml (in ce-.gitlab-ci.yml null Mal) -> in die GitLab-Strecke, Nenner 0 = rot; W0b.5 ci/thesis_gitlink_parity.sh: git-Aufruf links einer Pipe ohne pipefail (K11-Hausfalle).
ORT: s. je Paket
SOLL/FIX: Pakete 26-31 der Endfassung.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: W0b; Wachen-Register

### [w1buo8hac] 125 (Endfassung: W1-Regressionsliste Zusatzposten)
GEGENSTAND: Weitere W1-Defekte auf ohnehin angefassten Flaechen: parse_u64_cell nicht streng (Phantom-Punkt x~1,8e19 zieht den Spline); REV-DATA-12 zeigt auf zwei geloeschte Werkzeuge; A9-Design Abschnitt 1 invertiert (A9-S4 baut GEGEN dieses Dokument -- abgabekritisch, An-6-Ausnahme); file_size ohne ec-Pruefung (2^64 in ETA und Lager-Eintrag); xlsx INFO-Blatt Zahlenzelle statt Text (10.0 -> 10); WritebackMethod-Kommentar ohne xlsx; cppcheck-Ignore als Handliste; distclean-Wache greift nicht; Partitions-Beleg vergleicht nicht sondern druckt ==; 5 nicht wohlgeformte committete XMLs (2 GENERIERT, brechen jeden normkonformen Parser, W-10); --enable-X=no erzeugt -DX=NO=ON -> CMake liest wahr (W-09).
ORT: s. je Posten (W1-Tabelle Abschnitt 6)
SOLL/FIX: in W1-Spuren heilen (Verteilungsregel: Defekt in der Welle, in der die Flaeche ohnehin angefasst wird; nie eigene Aufraeum-Welle).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: W1

### [w1buo8hac] 126 (Endfassung: W2/W3-Regressionsposten + Dauerspur)
GEGENSTAND: W2-Mess-Vertrags-Defekte: conformance_passed 0 Leser im super-Katalog-Treiber; WorkloadKind-Phantome; Workloads/Datasets hartkodiert (2000/2000/42); sota_series merge ungeprueft; metadata.mode stiller Rueckfall; <output> gegen CWD; <lebewesen>/phase.engine steuern nichts; ledger_nachtrag.sh-Gegenprobe blind fuer den einen Fehler; drift_detector unverdrahtet; projiziere_kampagne unverdrahtet; appendix_generator fail-open (|| echo faellt ersatzlos). W3: Mess-Exklusivitaet zwei Doktrin-Staende (OV-5) vor dem Bau entscheiden. Dauerspur: 13 Doku-Drift-Befunde (Anker-Drift 60/125 = 48 % in docs/architecture; READMEs; INDEX.md; PROJECT_LAYER_MAP; Achsenzahl 22 vs. 18 in 5 Dokumenten; Par.75-Kandidatenliste mit verfallenen Ledger-Zeilen); Anker-Wache (Bezeichner statt Zeile) in W0b.6 mitbauen.
ORT: s. je Posten
SOLL/FIX: wie zugeordnet; Par.75-Aufraeumpass (133 Kandidaten, 104 offen) NACH der Abgabe (W7).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: W2/W3/W7

## Datei wjpdo2ukt.json (OD-11-RT numa_process_probe Workflow: 3x Explore + Bau + 3 Verify; 7 Agenten)

### [wjpdo2ukt] 1
GEGENSTAND: Fehlende Unter-Achse "Prozess-/Ausfuehrungs-Lokalitaet": vier Namen in vier Schichten (Core-Modus [Betreuer Termin 3], HybridCorePinning [Domaenenmodell T7], PeCorePolicySubAxis [Dossier 16.07.], core_class-Geschwister [Plan 06.08.]); keine gebaut; Name numa_process_probe existierte nirgends (0 Treffer, Gegenprobe numa_page_probe 76).
ORT: docs/termine/20260409 Termin 3/...Termin3_final.docx (extrahiert ...docx.txt:92); Domaenenmodell_PRT_ART.txt:441-448; docs/plaene/20260716-e17-e18-deep-research-DOSSIER.md:11,13; docs/plaene/20260806-PLAN-hybrid-architektur-pmc-achsen-zuordnung.md:376-382; 20260806-PLAN-hybrid-pmc-numa-core-permutation.md:294-310,407-410
SOLL/FIX: Kern-Topologie-Probe nach numa/page-Muster; core_class-Geschwister neben numa_node/page (keine Struktur-Aenderung noetig).
STATUS LT. QUELLE: durch Bau-Phase dieses Workflows adressiert (s. Eintrag 5)
ABHAENGIGKEIT/FLAECHE: F-3-Konflikt (Eintrag 3); OD-11-RT-K Verdrahtung offen

### [wjpdo2ukt] 2
GEGENSTAND: Offene Punkte des Explore, nicht aufloesbar: D-1 Auspraegungs-Mengen der vier Schichten NICHT deckungsgleich (Termin-3 traegt Kardinalitaets-Dimension Single/All, in keiner spaeteren Fassung; kein Entscheid gefunden); D-2 "Barnard homogeneous" vermischt Plattform- und Kern-Dimension (kein Entscheid); D-3 offen ob prod1 einelementig bleibt (F-4).
ORT: s. Eintrag 1; 20260806-PLAN-hybrid-pmc-numa-core-permutation.md:944-955 (F-4)
SOLL/FIX: Abgleich der Mengen dokumentieren; Entscheide nachziehen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Betreuer-Plan vs. Design vs. Code-Enum vs. Owner-KERN 06.08.

### [wjpdo2ukt] 3
GEGENSTAND: F-3-Konflikt: SSOT-Entscheid E-17 vom 16.07. (LEDGER:1577: FAKTUM->Hardware, POLICY->Scheduling) vs. Owner-KERN 06.08. (beides unter NUMA/target_isa); Bau folgte dem KERN; Abweichung ist "in der Arbeit zu benennen", kein Freibrief; F-3 bleibt OFFEN UND UNENTSCHIEDEN.
ORT: docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:1577; 20260806-PLAN-hybrid-pmc-numa-core-permutation.md:913-935
SOLL/FIX: dem KERN folgen + Abweichung in der Thesis benennen (Empfehlung des Plans); Doppel-Modellierung vermeiden.
STATUS LT. QUELLE: offen (dokumentierter Konflikt zweier Entscheide)
ABHAENGIGKEIT/FLAECHE: scheduling-Unterachse (stage=ct, hetero_core_dispatch=None, kein XSD-Kanal, kein Erheber)

### [wjpdo2ukt] 4
GEGENSTAND: Pinning-Aktuator ScopedThreadPin: gebaut (Linux+Windows, RAII, restore), aber Zielkern-Vorpruefung (CPU_ISSET vor setaffinity) FEHLT, Rueckprobe nach pin() FEHLT, Nachprobe vor restore() FEHLT (still verlorener Pin durch cpuset-Migration = gefaehrlichster Fall, unerkannt), Fehlerklassen (EINVAL/EPERM/cpuset/virt) FEHLEN (nur bool active()); WARN-Ausgabe fehlt; Verdrahtung Planer->CEB->Tier fehlt (einziger Konsument f15_compare --pin-core=N; 0 in CI/XML/Skripten); Ledger: "perm_runner-Pinning vom User live verworfen (Pinning nur f15)".
ORT: /home/comdare/wt-landung/libs/cache_engine/builder/measurement/thread_pinning.hpp:52-67,:70-78; apps/f15_compare/main.cpp:225; LEDGER:265 (G7-Gate P/E-Core HW+#215), :598
SOLL/FIX: korrekte Naht = Nr. 2: ScopedThreadPin als aeusserster Scope von run_workload_perm (perm_runner.hpp:243), Warmup MIT einschliessen; Rueckprobe nach pin(), Nachprobe vor restore(), beide als Feld in PermResult neben sample_status (perm_runner.hpp:141-142) -> Datensatz-Eigenschaft in CSV statt Konsolenzeile. taskset/numactl-Praefix greift lokal NICHT (Tier ist dlopen-.so im selben Prozess/Thread; experiment_driver.cpp:487).
STATUS LT. QUELLE: offen (Paket-Grenze OD-11-RT deklariert das ausdruecklich als NICHT getan)
ABHAENGIGKEIT/FLAECHE: OD-11-RT-K Folge-Paket; B-2/F-10 aus w1buo8hac; G-270a-Gate (test_cpuid_probe.cpp:63, test_platform_concepts.cpp:38 EXPECT_FALSE kippen wenn Probe Wahrheit sagt)

### [wjpdo2ukt] 5
GEGENSTAND: BAU OD-11-RT numa_process_probe: gebaut, gruen, committet auf Branch b-numa-process-probe, Commit b4cebdc4ebda3be71e3a8a5d9dbf9922feffd159 (Worktree /home/comdare/wt-numa-process, Basis ce development 2b5ecd29) -- NICHT GEPUSHT. 18 Dateien (4 neue Header + 1 Test mit 24 Tests + Aenderungen an target_isa_sub_axes/hardware_probe_factory/Registry-Generator/system_axis_registry.xml [generiert, 11->12 sub_axis]/system_cell_values [7->8]/algo_semver/axis_error/xml_config_parser/CMakeLists/test_w10).
ORT: /home/comdare/wt-numa-process; Commit b4cebdc4
SOLL/FIX: Landung dieses Branches steht aus; ZUSAETZLICH: XSD-Aenderung liegt UNCOMMITTED ausserhalb des ce-Repos als Patch /tmp/od11-xsd-core-class.patch (super Code/test_data_xml/experiment_schema.xsd +24 Z. additiv) -- super-Arbeitsbaum stand auf fremdem Branch b-ci-rueckschrieb-beide-zeiger, dort bewusst nicht committet. Patch darf nicht verloren gehen.
STATUS LT. QUELLE: gebaut@b4cebdc4, nicht gepusht/nicht gelandet; XSD-Patch offen
ABHAENGIGKEIT/FLAECHE: Landung ce; super-XSD-Naht; Merge-Flaeche mit anderen target_isa-/Registry-Aenderungen

### [wjpdo2ukt] 6
GEGENSTAND: Bau-Entscheidungen (im Design nachvollziehbar zu halten): (1) EINE neue sub_axis core_class; Pinning-Faehigkeit als zweites unabhaengiges expected (Brauchbarkeits-Aussage, nicht permutierbar); (2) WARN als Praedikat warns_no_pinned_locality() + kNoPinnedLocalityWarning (Owner-Text woertlich), KEINE K4-Fehlerklasse; feuert nur bei >1 Klasse UND nicht durchgesetztem Pin; (3) eine mutierende Stelle (4 Syscalls, erprobe_pinning abschaltbar, maske_wiederhergestellt als Feld). Detektions-Kette bewusst OHNE acpi_cppc/cpu_capacity (Raenge, keine Klassen; Schwellwert waere geraten); >2 L3-Groessen -> FormatUnbekannt.
ORT: numa_process_probe.hpp; Bau-Bericht
SOLL/FIX: Nebenbefund mitbehoben: drei signaturgleiche error_domain-Ueberladungen (os_probe/numa_page/neu) -> Summe EINMAL in axis_error.hpp als ProbeErrorSum (haette jedes Folge-Paket getroffen, das zwei Erhebungen nebeneinander liest).
STATUS LT. QUELLE: gebaut
ABHAENGIGKEIT/FLAECHE: OD-10-RT-K/OD-11-RT-K

### [wjpdo2ukt] 7 (VERDIKT stempel-neutralitaet: HAELT)
GEGENSTAND: A-15-Stempel-Neutralitaet strukturell erzwungen: einzige Abweichung im 23-Zeilen-Stempel-Diff = FORBIDDEN_KEY_COUNT 7->8 (consteval-Waechter, nicht stempelwirksam, 3 Verwender alle consteval); Fingerprints identisch auf beiden Kern-Klassen; Include-Huelle 294 Header, 0 Stempel-Header; binary_ids enthalten 0 System-Achsen-Segmente von 326; Waechter scharf (Injektions-Angriff -> static assertion failed W10/A-15).
ORT: Verify-Lauf am Worktree b4cebdc4 vs. 2b5ecd29
SOLL/FIX: Praezisierungen am Bau-Bericht: (a) Include-Huelle ist der haertere Beleg als Text-grep; (b) binary_id="never" ist Bestaetigung, nicht Ursache. UNGEPRUEFT GEBLIEBEN (fuer den Naechsten): ob der Planer die neue stage="runtime"-Registry-Zeile in die Permutation zieht und die Plan-Groesse aendert (Plan-Ereignis, kein Stempel-Ereignis); ob wirklich niemand TargetIsaAxisSel::core_class liest.
STATUS LT. QUELLE: HAELT; zwei Restpruefungen offen
ABHAENGIGKEIT/FLAECHE: Planer-Permutationsmenge; OD-11-RT-K

### [wjpdo2ukt] 8 (VERDIKT muster-treue: LUECKE 1)
GEGENSTAND: CoreTopologySource-Provenienz LUEGT auf 2 von 3 Familien: Windows (aus GetLogicalProcessorInformationEx EfficiencyClass) und macOS (aus hw.nperflevels) stempeln beide CoreTopologySource::HybridPmu -- drei verschiedene Quellen, ein Etikett; exakt der Schaden, gegen den das Enum eingefuehrt wurde; keine CT-Wache, kein Test (Tests treffen nur Linux-Pfade).
ORT: /home/comdare/wt-numa-process/.../numa_process_probe_windows.hpp:197-198; numa_process_probe_macos.hpp:82; Begruendung numa_process_probe.hpp:179-186; Vorbild-Kontrast numa_page_probe_windows.hpp:118-121
SOLL/FIX: vierter/fuenfter Enum-Wert (WindowsEfficiencyClass, DarwinPerflevel); Vokabular traegt es ohne Strukturaenderung. Fix billig.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Branch b-numa-process-probe vor Landung

### [wjpdo2ukt] 9 (VERDIKT muster-treue: LUECKE 2)
GEGENSTAND: Kopfkommentar behauptet fuer macOS das Gegenteil des Blatts: "macos: keine prozessfreie Kern-Klassen-Schnittstelle -- benannter L6-Befund" -- das Blatt erhebt sie via hw.perflevel-sysctls und liefert volle CoreClassMap; Satz aus numa_page_probe.hpp:14-15 mitkopiert, nicht nachgezogen.
ORT: numa_process_probe.hpp:16-17 vs. numa_process_probe_macos.hpp:4-8
SOLL/FIX: WAS-Zeile korrigieren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Branch b-numa-process-probe

### [wjpdo2ukt] 10 (VERDIKT muster-treue: LUECKE 3)
GEGENSTAND: L3-Stufe laesst Kreuz-Disjunktheits-Pruefung weg: adjacent_find prueft nur Dubletten INNERHALB je Liste; eine CPU in grosser UND kleiner L3-Domaene landet in beiden Gruppen und passiert -- fuer eine Achse zum getrennten P/E-Auswerten der teuerste stille Fehler. PMU-Stufe direkt darueber prueft mit set_intersection korrekt.
ORT: numa_process_probe_linux.hpp:360-362 (fehlerhaft) vs. :318-321 (Vorbild)
SOLL/FIX: set_intersection-Pruefung auch fuer die L3-Stufe.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Branch b-numa-process-probe

### [wjpdo2ukt] 11 (VERDIKT muster-treue: LUECKE 4)
GEGENSTAND: Owner-WARN feuert familienabhaengig: warns_no_pinned_locality gibt bei !topology.pinning.has_value() false; macOS liefert "kein Pinning" als WERT (KeineSchnittstelle -> Warn feuert), Linux/Windows dieselbe Aussage als FEHLER (BetriebssystemFeatureFehlt -> Warn schweigt). Derselbe Maschinen-Zustand, zwei Ausgaben.
ORT: numa_process_probe.hpp:316-320
SOLL/FIX: WARN-Praedikat familienuniform machen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Branch b-numa-process-probe; kNoPinnedLocalityWarning-Konsument (B-4)

### [wjpdo2ukt] 12 (VERDIKT muster-treue: Beleg-Mismatch)
GEGENSTAND: Bau-Bericht zitiert "410/410 passed"; realer Baum hat 414 Tests; alle zitierten Testnummern um 4 zu niedrig -> zitierte ctest-Ausgabe stammt aus Baubaum mit 4 unregistrierten Tests ("Gruen an einem Baum gemessen, der weniger Gates fuehrt als der echte"). Zudem fiel test_system_axis_registry_roundtrip in 1 von 6 Voll-Laeufen unter Last (entlastet: 200 Generator-Laeufe 0 Abweichungen, isoliert gruen; dieselben Laeufe kippten test_s5_artifact_cache_bounded und test_cache_mc_timeout als Last-Flakes).
ORT: Verify-Laeufe am Worktree
SOLL/FIX: Berichts-Zahl nachziehen; Gate-Flakiness unter Last benennen statt "alle gruen".
STATUS LT. QUELLE: nur-hinweis (Doku-Korrektur) + Beobachtung Last-Flakes
ABHAENGIGKEIT/FLAECHE: ctest-Lastverhalten auf prod1

### [wjpdo2ukt] 13 (VERDIKT muster-treue: Kleinigkeiten)
GEGENSTAND: operator==(CoreClassGroup) ist inline statt constexpr (Vorbild PageSizeCapability constexpr); fuer CoreClassMap/PinningCapability fehlt operator== ganz; numa_process_probe_windows.hpp laesst den eigenen 'N/A STATT NULL'-Kopfblock weg (nur inline bei :171).
ORT: numa_process_probe.hpp / numa_process_probe_windows.hpp
SOLL/FIX: angleichen.
STATUS LT. QUELLE: offen (klein)
ABHAENGIGKEIT/FLAECHE: Branch b-numa-process-probe

### [wjpdo2ukt] 14 (VERDIKT registry-und-generator: HAELT + Nebenbefund)
GEGENSTAND: Registry-XML nachweislich GENERIERT (Generator ohne Typ reproduziert Eltern-XML byte-genau; mit Typ exakt +1 Zeile); Byte-Gate scharf (Hand-Edit -> BYTE-DRIFT-Fehler, kein Skip, FATAL bei fehlendem Tool/XML); alle 5 Compile-Wachen-Verletzungen rot (falscher Elternknoten, falsche Tiefe, Zahl, Verbots-Label, Dublette). NEBENBEFUND (Bestand, nicht vom Paket): note_name/Namens-Guard des Generators prueft nur name_is_clean, NICHT Eindeutigkeit ueber alle Ids -- eine repo-weite Id-Kollision faenge heute niemand (target_isa-lokal gedeckt via labels_are_distinct).
ORT: /home/comdare/wt-numa-process/tools/system_axis_registry_gen/main.cpp; ceb_sub_axis.hpp:97-98; tests/unit/registry_roundtrip.cmake; tests/unit/CMakeLists.txt:4762
SOLL/FIX: repo-weite Id-Eindeutigkeits-Wache als Folgeposten.
STATUS LT. QUELLE: HAELT; Nebenbefund offen
ABHAENGIGKEIT/FLAECHE: Registry-Generator

### [wjpdo2ukt] 15
GEGENSTAND: Deklarierte Paket-Grenzen von OD-11-RT (bewusst NICHT getan, muessen als Folgeposten gefuehrt werden): (a) keine Verdrahtung in Planer/CEB/Permutation/Mess-Ausgabe -- Parser fuellt TargetIsaAxisSel::core_class, NIEMAND liest es; Resolver-Pruefung folgt (OD-11-RT-K); (b) kein Pinnen der Mess-Naht (Vorpruefung/Rueckprobe/Nachprobe fehlen dem Aktuator weiterhin); (c) keine Hybrid-PMU-Wahl (cpu_core/cpu_atom-PMC), kein hetero_core_dispatch-Umzug ct->rt; (d) F-3 offen.
ORT: numa_process_probe.hpp Kopfkommentar
SOLL/FIX: Folge-Pakete OD-11-RT-K etc.
STATUS LT. QUELLE: offen (deklarierte Grenze)
ABHAENGIGKEIT/FLAECHE: B-2/B-3/B-4; pmc:intel; OV-9-Hardware

### [wjpdo2ukt] 16
GEGENSTAND: prod1-Realitaet fuer Kern-Klassen: P/E hat auf prod1 KEINEN Referenten; echte Asymmetrie ist V-Cache-CCD (0-7,16-23, 96MB L3) vs. Frequenz-CCD (8-15,24-31, 32MB L3); prod2 (GenuineIntel/6/151/2 Raptor Lake) ist die hybride Maschine der Flotte -- alle cpu_core/cpu_atom-Aussagen sind Fachwissen, NICHT auf prod2 gemessen; "Kern-Klassen-Erhebung muss auf prod2 gegengeprueft werden, bevor sie als erhoben gilt". Windows-Pfad ungeprueft (keine Windows-Maschine).
ORT: system_axis_registry.xml:18/:23; hardware_probe_factory.hpp:203; Live-Messung 2026-08-06
SOLL/FIX: prod2-Gegenpruefung; Virtualisierungs-Fall als WARN fuer Docker-Matrix/ZIH-Cluster fuehren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: OV-9 (prod2 existiert nicht im Netz -- Konflikt mit diesem Pruefauftrag!)

## Datei wo0oghvqu.json (4 Explore-Straenge Do-13.08.-Strecke: golden Version, S-14a Bump-Wache, MinIO #10, #22-Paket; 4 Fable-Agenten)

### [wo0oghvqu] 1 (GOLDEN)
GEGENSTAND: "Golden Version" = Versions-Baseline VOR den Homes; Traeger existiert (axis_version_lock, 6 Eintraege -> Ziel 158); die "9 Eintraege" im Ledger waren wc-l-Artefakt (3 Kommentarzeilen), die "7" zaehlte einen Prosa-Fehltreffer (csv_cell_reader.hpp:16) mit; real 6 Marker = 6 Lock-Eintraege = 6 CI-Argumente KONSISTENT.
ORT: ce tools/axis_version_lock/axis_version.lock; axis_version_lock.cpp; ce .gitlab-ci.yml:788-807 (contract:axis-version-lock, unbedingt seit 06.08.); Owner-Wort KON27-01 (Ledger Z.3049-3093), KON17-03 (Z.4362), KON16-08 (Z.4568)
SOLL/FIX: Bau-Anweisung STRANG B (verbatim-Kern): ce-Worktree von 7d65eb6c abzweigen (bau/golden-baseline), EIN Schreiber; Dateiliste deterministisch sortiert = 6 heuristik + 130 axes-algo_version-Traeger + 22 topics/queuing = 158 Dateien (Zahlen 6/130/22/158 im Commit-Text protokollieren); queuing im HEUTIGEN Pfad festschreiben (golden VOR Umgliederung; #16-Umzug fuehrt Lock-Pfade spaeter digest-stabil nach); Tool wie CI-Job bauen und Baseline IN DIE BESTEHENDE Datei schreiben (KON17-03: EINE Wache, kein zweites Lockfile); Erwartung: fuer die 152 Nicht-heuristik meldet Tool sichtbar 'Marker fehlt, N=0'; K13-KOEDER = T-i-2-Mutationsbeweis (1 Kommentar-Byte in einer axes-Variante aendern -> --check MUSS Exit 1 mit genau dieser Datei; zuruecknehmen -> Exit 0; beide Ausgaben woertlich ins Protokoll; Koeder der nicht beisst stoppt die Landung); --check mit voller 158er-Liste gruen, DANN committen (Lock + Koeder-Protokoll + Ledger-Nachtrag mit 9-vs-7-vs-6-Aufklaerung); Landung Merge-Doktrin auf ce development, beide Remotes, Gitlink-Bump als eigener Zug. GRENZE zu S-14a: CI-Argumentliste bleibt in DIESEM Posten bei den 6; golden und S-14a fassen dieselbe Flaeche an (Lock+CI) => seriell, NIE parallel.
STATUS LT. QUELLE: offen (Bau-Anweisung fertig, Bau nicht erfolgt)
ABHAENGIGKEIT/FLAECHE: Voraussetzung fuer #16 (Homes MESS/SYSTEM); seriell vor/nach S-14a; KON57-05-Landesequenz (bau/s1-codex-haertung + Gitlink 671d7f6a davor)

### [wo0oghvqu] 2 (GOLDEN offene Punkte)
GEGENSTAND: (a) Materielle Form der golden Version vom Owner-Wort NICHT spezifiziert (Lock-Digest vs. Member-Versionen vs. Registry-Dump) -- als Bau-Entscheid aufgeloest; praezise Owner-Frage formuliert falls Bestaetigung gewollt: 'Golden Version = SHA-256-Baseline aller 158 heutigen Achsen-Traeger in der bestehenden axis_version.lock (Digest-Tripwire), Member-Versions-Pruefung folgt mit S-14a -- so bauen?'. (b) Zugehoerigkeit der 11 algo_version-Traeger ausserhalb axes+queuing+heuristik (abi 3, measurement 2, experiment_tree 2, topics-Wurzel 1, profile_facade 1, anatomy 1) nicht gedeckt -- additiv nachruestbar. (c) OF-1 (17-vs-18 Kompositions-Achsen, Owner-Frist Mi 19.08.) betrifft Zaehl-Semantik, nicht Digest-Baseline. (d) Owner-Nachrichten vor 18.07. zu 'golden Version' im 25-Datei-Korpus nicht vorhanden; rotierte Sessions nicht pruefbar. (e) k*Version-Vokabel (9x lt. KON2-19) nicht neu vermessen.
ORT: s. Eintrag 1
SOLL/FIX: wie angegeben.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: S-14-Vokabel-Vereinigung; OF-1

### [wo0oghvqu] 3 (S-14A)
GEGENSTAND: S-14a Teil 1 = Riegel modular + Autodiscovery; IST 6/152 gedeckt (Wache deckt nur 6 heuristik-Dateien, Schnitt mit axes/ = 0); hartkodierte 6-Pfad-Liste in der CI war Mitursache des Drei-Wochen-Ausfalls (YAML-Doppelschluessel, INERT-Fassung gewann; 06.08. auf strengere unbedingte Fassung vereinigt, Fix-Commits 597ecffe+557d8023); Mutationsbeweis T-i-2 fehlt (0 Tests referenzieren axis_version_lock); LUECKE im Tool: do_check iteriert nur ueber argv, NIE ueber Lock-Eintraege -> geloeschte/umbenannte gelockte Datei bleibt STILL.
ORT: ce tools/axis_version_lock/axis_version_lock.cpp:145-190; .gitlab-ci.yml:788-807; Owner: KON17-03 (EINE Wache modular + Detail-Klassen-Split), KON16-08 ("hoch."), KON38 (Fable 5 max), KON55 (Kombibau gcc+clang x Debug+Release), Build-Blocker-Einstufung Owner 10.08. (Transkript Z.34976: Planer 1.0.0.c vs. voellig anderes Versionierungssystem -> "sonst ist der Build ... unmoeglich")
SOLL/FIX: Bau-Anweisung (verbatim-Kern): (1) T-1 ROT ZUERST + K13 beidseitig: neuer ctest test_s14_axis_version_lock_tripwire (2-Pass, Tool als Fixture-Dependency, nur Kopien); Koeder A (Byte ohne Bump -> Exit 1), B (mit Bump -> Exit 0), C (Datei nicht im Lock -> unlocked rot), D (Lock-Eintrag ohne Datei -> MUSS rot, heute STILL = designierte Rot-zuerst-Stelle). (2) Modularisierung: Kategorie-Detail-Interface {discover_home(), declared_version(bytes), bump_ok(alt,neu)}; HeuristikDetail = heutiger Mechanismus; OrganDetail NEU = Discovery ueber axes/ UND topics/queuing/ (Traeger = algo_version-String-Literal-Zuweisung, 103+20 Dateien), bump_ok via Bestands-Parser measurement/algo_semver.hpp; Sentinel => rot; SYSTEM/MESS-Detail-Klassen NICHT anlegen (Homes existieren nicht; benannte Leerstelle). (2b) Riegel-Schaerfungen: Lock-Eintrag ohne Datei => rot; je Kategorie discovered-Zaehler MIT Nenner in der Ausgabe (Anker heuristik==6, organ>=120); kAllRegisteredOrganVariantCount (126) nur LOGGEN, nie gleichsetzen (Datei != Variante). (3) Lock regenerieren -> Format v2 (Formatwahl = Bau-Entscheid, im Lock-Kopf dokumentieren). (4) CI: EIN unbedingter Job; Script auf 'build + tool --check <lock>' verkuerzen -- hartkodierte 6-Pfad-Liste FAELLT aus der YAML. (5) Verify J-1..J-4 + KON55-Kombibau. (6) Landung: Merge nie rebase, Diff-Hygiene push-lokal, beide Remotes, Gitlink-Bump hinter KON57-05-Rest.
STATUS LT. QUELLE: offen (Bau-Anweisung fertig)
ABHAENGIGKEIT/FLAECHE: seriell hinter golden (Posten 10) laut nacht-9-Sequenz (technisch keine harte Abhaengigkeit gefunden); dieselbe Flaeche Lock+CI wie golden; Betriebsfolge: ab Landung braucht JEDE Aenderung an ~123 Organ-Traegern Bump ODER Lock-Regen-Commit -- trifft W1-Straenge S-6/S-7 SOFORT (Friktions-Aufwand ungeplant)

### [wo0oghvqu] 4 (S-14A offene Punkte)
GEGENSTAND: (a) ce-Stand-Spannung: KON56 meldet 'F1-LANDUNG DURCH -- ce 671d7f6a, GITLINK GEBUMPT', vermessener Baum f8cff2c8 traegt aber Gitlink 7d65eb6c, KON57-05 fuehrt den Bump als AUSSTEHENDEN sechsten Zug (+ laufender 2x2-Kombibau ueber 6f537245) -- vor Bau-Beginn fetch + Branch-Lage pruefen, Zahlen am neuen Stand nachmessen. (b) Teil-1-Abgrenzung nirgends ausbuchstabiert (nur Wellenplan #90 'Teil 1: der Riegel' + Wellenkonsolidierung :183/:224); Minimal-Lesart (nur Modular-Umbau ohne Scope) waere wortlaut-vereinbar, #90-Begruendung spricht dagegen. (c) Lock-v2-Format (Integer vs. X.Y.Z-String) = Bau-Entscheid ohne Owner-Wort. (d) Phasigkeits-Drift: KON27-01 sagt MESS=DREIPHASIG, Memory fuehrt 'MESS 3->4' -- vor #16-Bau klaeren. (e) 136er-Nenner der aelteren '6 von 136' nirgends aufgeschluesselt; massgeblich ist 152 (130+22) seit KON14-04.
ORT: s. Eintrag 3
SOLL/FIX: wie angegeben.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: #16 (Sa 15./16.); Trigger-Kriterium Mi 26.08. 06:00 (S-14-Vollausrollung)

### [wo0oghvqu] 5 (MINIO #10 -- Befund)
GEGENSTAND: MinIO/Secrets-Zustand: von den 7 kompromittierten Scrub-Variablen existieren heute als CI-Variable nur 2 (MINIO_ACCESS_KEY+SECRET_KEY in Projekt 288, Wert-Gueltigkeit UNGEPRUEFT) + 1 neu in 289; FEHLEND in 288 (aber konsumiert): COMDARE_NFS_DROP_TOKEN (Ebene C inert), CE_SUBMODULE_TOKEN (Planer-Emission experiment_plan_director.hpp:858 braeche), COMDARE_THESIS_WRITEBACK_TOKEN (super-YAML Z.2446-2477 konsumiert im 288-Kontext -> harter Fehler-Ast); Gruppe-3 MINIO_SECRET_KEY+GITLAB_DEPLOY_TOKEN existieren nicht mehr (0 Konsumenten). MinIO-Instanz LEBT (health 200; zwei Endpunkte minio.comdare.de=10.0.60.1 und minio.comdare.local=10.0.10.1). 24 Runner sichtbar/15 online; kein Job test:secrets (heisst lint:secrets); ce lint:secrets OHNE timeout-Deckel (super hat 10m-Deckel).
ORT: GitLab-API Projekte 288/286/289 + Gruppe 3; super .gitlab-ci.yml:1620-1680 (.storage_cache_activation), :1729-1742 (Bestandslog-Kette), Z.289-318 (lint:secrets); ce .gitlab-ci.yml:87-89; artifact_cache.hpp:232-279
SOLL/FIX: Bau-Anweisung (Kern): Schritt 0 Vault NIE greppen (blind mapfile, Werte = Behauptung bis 200/Exit-0-Probe); Schritt 1 ERST Funktions-Smoke ob gesetzte Keys tragen (MC_HOST_probe, mc ls; K13-Koeder mit verstuemmeltem Secret ZUERST -- erst wenn Koeder beisst, zaehlt Gruen; CI-Alternative: 288-Pipeline measure:smoke mit COMDARE_STORAGE_CACHE=true, Beweiszeile 'Ebene B aktiv', Gegenkoeder HART-ROT-Ast Z.1662); Schritt 2 nur wenn rot: Werte blind einsetzen (PUT API, masked, nie argv); OWNER-ENTSCHEID falls Vault nur ALTE kompromittierte Keys traegt: MinIO-seitig neue erzeugen (Infra-Handout) -- Alt-Werte einsetzen waere "schneller UND falsch". Schritt 3 Schwester-Luecken einzeln: (a) NFS_DROP_TOKEN beschaffen/setzen + Ebene-C-Smoke; (b) CE_SUBMODULE_TOKEN neu erzeugen (gldt-, Mutation=Lead) + Checkout-Einzeiler-Smoke; (c) THESIS_WRITEBACK_TOKEN: in 288 zusaetzlich setzen ODER Konsument umbauen -- WELCHER Weg ist Owner-Entscheid; (d) Gruppe-3-Reste NICHT neu einsetzen ohne Konsumenten. Schritt 4 776 Runner-Token: Owner-Entscheid VOR Bau (je Projekt reset_registration_token ODER instanzweit allow_runner_registration_token=false; heute true auf GitLab 18.11.7 -> Alt-Tokens weiter gueltig). Schritt 5 D-1: ce-lint:secrets-timeout-Deckel nachziehen (bauen ohne Rueckfrage moeglich); Tag-Pinnung [baremetal, amd] wartet auf Ein-Satz-Bestaetigung V1 (Owner). Schritt 6 UNGEBUCHTES DELTA SOFORT VORLEGEN, KEINE EIGENMASSNAHME: refs/backup/pre-secret-scrub-20260802 ist von BEIDEN origins UND lokal VERSCHWUNDEN, kein Bundle gefunden -- entgegen gestufter O-5-Doktrin weder Bundle-Ueberfuehrung noch Loeschungs-GO verbucht; Owner fragen: geplante Vollziehung? wo liegt das Bundle? Abschluss-Smoke #10: measure:smoke gruen MIT 'Ebene B aktiv'-Zeile UND frisch geschriebenem Objekt (mc stat), nachdem Z.-1662-Koeder ROT bewiesen hat.
STATUS LT. QUELLE: offen; Rotation der 7 Variablen vollzogen (Task #70), Neu-Einsetzen/Smoke UNGEPRUEFT
ABHAENGIGKEIT/FLAECHE: S-13/Storage-Ebene B; S-3-Aktivierung (Fr); Owner-Entscheide (Alt-Keys, 776, Writeback-Weg, Tag-Pinnung); Backup-Ref-Delta

### [wo0oghvqu] 6 (MINIO offene Punkte)
GEGENSTAND: (a) Gueltigkeit der heutigen 288-MinIO-Werte nicht pruefbar ohne Smoke; (b) Setz-Zeitpunkt der 288-Variablen unbestimmbar (API ohne Zeitstempel, kein Ledger-Nachtrag); (c) ob Task-#70-Rotation die Gruppe-3-Eintraege bewusst geloescht/konsolidiert hat = AGENT-BEHAUPTUNG ohne Transkript-Beleg; (d) 776-Rotations-STATUS nicht verifizierbar ohne Secret-Vergleich; (e) Verbleib Backup-Ref (Bundle? autorisierte Loeschung?) -- Audit-Events nicht abgefragt; (f) runners.cache-S3-Zugaenge der Runner-config.toml nur auf Runner-Hosts pruefbar (kein SSH, read-only) -- ob der Scrub DIESE Familie traf, offen; (g) welcher der zwei MinIO-Endpunkte in COMDARE_MINIO_ENDPOINT steht, nicht erhoben; (h) Konsument von COMDARE_WRITEBACK_USER/TOKEN (288) nicht kartiert.
ORT: s. Eintrag 5
SOLL/FIX: wie angegeben.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Infra-Hoheit; Vault-Doktrin

### [wo0oghvqu] 7 (#22-PAKET)
GEGENSTAND: #22-Paket am Objekt: Q6-32 steht SCHON im Code (kHybridNodeObergrenzeDefault=32, heuristik_adapter_synthese_matrix.hpp:83 + static_asserts :187-189; Datei heisst NICHT synthese_matrix.hpp) -- Posten ist reiner KOMMENTAR-NACHZUG an 4 Stellen; runner-mode.sh:43 traegt noch HEAVY_J=24 (Owner 12.08. KON28-01: "Er wird auf 16 heruntergestuft, es gab Probleme... --debug ... bis zur Abgabe"); zwei unkorrigierte Ledger-Alt-Zitate (heute Z.17446 + Z.17511: 'prod1: 32 Threads/24 Kerne' bzw. Werte vertauscht); Par.69.6 (heute Z.17745) braucht UEBERHOLT-Vermerk (HEAVY-prod1 24->16); N-3/N-4 mit 16W nachgerechnet: zweilanig Engpass bleibt intel ~34,4 h (Umstufung aendert Voll-Bau-Wanduhr NICHT); einlanig 41,4h@24W -> ~45,6h@16W (ANNAHME-Faktor 1,1008 intel-uebertragen; amd@16W NIRGENDS gemessen); N-4 unveraendert 524.288.
ORT: ce libs/cache_engine/hybrid/heuristik_adapter_synthese_matrix.hpp; hybrid/README.md:33; ce docs/architecture/20260802-hybrid_tier_stufe_soll_design.md:237/:446; /home/comdare/Projekte/Cluster/scripts/runner-mode.sh:43 (deployed /usr/local/sbin/ auf prod1+prod2, SIGHUP-only); Ledger Z.17446/17511/17745; Owner-Worte KON28-01/KON28-03/KON42-01/KON37-04
SOLL/FIX: Bau-Anweisung (Kern): TEIL (a) Q6-Kommentar-Nachzug 4 Stellen ('NACHZUG 13.08.2026 -- ENTSCHIEDEN (KON28-03/KON41-03/KON42-01)': 32 loest die 8 ab; 32 = PROGRAMM-DECKEL, kein Fach-Nenner; Docks != Mess-Permutationen; Default einkompiliert, XML ueberschreibt; Doku deprecaten nie loeschen); ABGRENZUNG: XML-Override-MECHANISMUS (max_docks-Parser) ist HY-A3/Posten 26, NICHT #22; KOEDER: temporaer static_assert(nodes == 8) -> Vollbau MUSS ROT -> entfernen -> J-1..J-4 Debug+Release, GCC+clang. TEIL (b) Ledger-Nachtrag via scripts/ledger_nachtrag.sh (nur Lead): Zitat-Korrektur-Marker DANEBEN (Original bleibt; Praezedenz :1398/:1806/:2796; VOR dem Edit neu ankern per grep, Zeilennummern wandern!); Par.69.6-UEBERHOLT-Vermerk; N-3-Nachrechnung verbuchen. TEIL (c) Infra-Handout /home/comdare/Projekte/Cluster/docs/sessions/20260813-HANDOUT-od7-heavy-worker-24-auf-16.md nach 1d7b5d0-Vorbild (nur prod1-Zeile :43 HEAVY_J=24->16; :44 prod2=$(nproc) NICHT anfassen; SIGHUP-only; Rueckmelde-Kriterium Commit-SHA + literaler grep-Beleg). TEIL (d) N-3-Saetze 1-4 eintragen + PFLICHT-ANHANG Nachkalibrierung beim ersten realen 4096er-Batch @16W. REIHENFOLGE (a)->(c)->(b)->Landung.
STATUS LT. QUELLE: offen (Bau-Anweisung fertig; KON42-02: 'Offene Owner-Fragen: NULL -- nichts blockiert #22')
ABHAENGIGKEIT/FLAECHE: OF-5 (KON40-03: innerer Widerspruch der KON37-04-Antwort T-3 vs. 'wie empfohlen', beim Owner; Rechnung unter Lesart a, robust gegen b); W7-Anpassung des willkuerlichen 32er-Werts; Cluster-Repo traegt Submodul-Drift ' M _infra/ci-templates' (vor Handout-Commit wuerdigen)

### [wo0oghvqu] 8 (#22 offene Punkte / Fallen)
GEGENSTAND: (a) amd/prod1 je-Slice-Zeit @16W NIRGENDS gemessen -- 45,5h/45,6h beruht auf uebertragenem intel-Faktor (ANNAHME); heilt nur der erste reale 4096er-Batch @16W. (b) nacht-9-Marker :16968/:17202/:8048 waren SCHON BEI NIEDERSCHRIFT stale (Konsolidierung IV + KON36 fuegten mitten im Dokument ein; Inhalte via KON28-01-Liste eindeutig lokalisiert) -- LEHRE: Ledger-Zeilennummern wandern, vor jedem Edit neu ankern. (c) Form des Vermerks (In-Place-Marker daneben vs. nur Nachtrag oben) = Form-Entscheid des Leads; kein Praezedenzfall OHNE In-Place-Marker gefunden.
ORT: s. Eintrag 7
SOLL/FIX: wie angegeben.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Ledger-Editier-Praxis

## Datei wfr31gpjz.json (Code-Review-Analyse S-14a Bump-Pflicht-Wache in Owner-Besetzung: Opus 5 max ERHEBT [41 Pfade, 22 Wahrheitstafel-Zellen, 40 Zustaende, 13 Vertraege], Fable 5 max BEWERTET; Objekt: Worktree /home/comdare/wt-ce-golden-s14a, Tool axis_version_lock.cpp, Register 158 Records v2, ctest test_s14_axis_version_lock_tripwire; URTEIL: TRAEGT_MIT_FIXES)

### [wfr31gpjz] 1 (ERNST)
GEGENSTAND: organ-Grundgesamtheit ist Substring-Filter, kein Datei-Filter: 235 von 387 *.hpp unter den bewachten Homes (61 %) sind NICHT discovered und vollstaendig ausserhalb der Wache -- darunter die gesamte Implementierungsschicht axes/lookup/composable/ (~70 Dateien), ALLE *_registry.hpp, subaxes_*.hpp, concepts/, vendor_includes/, Config-Header. Aenderung dort = exakt die Fehlerklasse "kein Neubau, schneller UND falsch" -- GEFAHREN: Kommentarzeile an k_ary_traversal_organ.hpp/axis_06_allocator_registry.hpp/cacheline_config.hpp -> --check Exit 0 GRUEN 158, null Meldungen.
ORT: tools/axis_version_lock/axis_version_lock.cpp:219 ('if (text.find("algo_version") == npos) continue;') im Worktree /home/comdare/wt-ce-golden-s14a
SOLL/FIX (verbatim): organ-Discovery auf ALLE *.hpp unter den zwei Homes ausweiten (Gleichstellung mit heuristik); Dateien ohne algo_version-Literal als version='-' digest-only (Mechanik existiert: 30 forwarder_prosa-Records); Register waechst 158 -> 393, einmaliger Regen-Commit; golden-158-Kompatibilitaet als ZAEHL-SICHT (BESTAND-Zeile 'substring_traeger=152' zusaetzlich), nicht als Discovery-Grenze.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: golden-Baseline (158) muesste mitwachsen; S-14a-Branch wt-ce-golden-s14a vor Landung

### [wfr31gpjz] 2 (ERNST)
GEGENSTAND: Bump-Pflicht gilt nur fuer die ERSTE Aenderung nach --write: gruener Bump-Pfad laesst Register veralten (HINWEIS nur stdout, CI misst nur Exit-Code); solange Datei-Version > Lock-Version bleiben beliebig viele bumplose Folge-Aenderungen GRUEN; OK-Zeile ist Stellvertreter-Meldung ("MIT Version-Bump" fuer Commits ohne Bump); bricht die eigene Deklaration :59-61 ab der zweiten Aenderung. GEFAHREN: 3 Commits an axis_06_allocator_cama.hpp, alle Exit 0.
ORT: axis_version_lock.cpp:563-567; .gitlab-ci.yml:795-808
SOLL/FIX (verbatim): Registeraktualitaet im CI erzwingen: Job faehrt nach --check zusaetzlich '--write <tmpfile> --root .' + 'diff -u <lock> <tmpfile>' -- jede Veraltung (auch verbogene Versions-/Kategorie-Spalten bei gleichem Digest = Fund 7 gleich mit) wird Job-rot. Alternativ/zusaetzlich: --check-Modus in dem der Bump-Zweig red=1 setzt ('Bump erkannt, Register veraltet -- Regen-Commit fehlt', CI-Default); gruene OK-Zeile bleibt der lokalen Vor-Commit-Pruefung.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: CI-Job contract:axis-version-lock

### [wfr31gpjz] 3 (ERNST)
GEGENSTAND: Traeger-AUSTRITT ist vom Werkzeug selbst angeleiteter Einweg: verliert eine gelockte Datei den Substring 'algo_version', wird sie einmalig verwaist-ROT, der HINWEIS weist den --write-Regen an -- danach DAUERHAFT unbewacht; BESTAND sinkt kommentarlos (152->151), KEIN Ort prueft gegen SOLL (CI nur Exit-Code; ctest-Anker >=120 mit 32 Dateien Luft, laeuft nur auf Kopien). GEFAHREN: buddy.hpp algo_version umbenannt -> ROT -> --write -> GRUEN 157; Folge-Aenderung GRUEN.
ORT: axis_version_lock.cpp:588-590 + :219; test_s14_axis_version_lock_tripwire.cpp:220
SOLL/FIX (verbatim): Primaer Fix 1 (Mitgliedschaft am Dateisystem statt Inhalt). Zusaetzlich BESTAND-SOLL ankern: ctest-Anker exakt (heuristik==6 UND organ==152 statt >=120; Zu-/Abgang bumpt Anker bewusst im selben Commit); CI-Job prueft BESTAND-Zeile gegen Record-Zahl des committeten Registers (der --write-Diff aus Fix 2 prueft das automatisch mit).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Fixe 1+2

### [wfr31gpjz] 4 (ERNST)
GEGENSTAND: Kein einziger ctest-Koeder faehrt heuristik-Digest-Drift oder heuristik-Bump -- die gesamte v1-Bump-Mechanik (HeuristikDetail::version_of :148-167, bump_ok :170-178) ist ohne Rot-Koeder; Mutation 'bump_ok { return true; }' liesse ctest UND contract-Job gruen -- Bump-Pflicht fuer die 6 heuristik-Header lautlos abschaltbar.
ORT: test_s14_axis_version_lock_tripwire.cpp:233 (Koeder-A-Ziel waehlt explizit category == "organ")
SOLL/FIX (verbatim): Zwei Koeder ergaenzen (Muster Schritt 7/8): A2 = 1-Byte-Drift an heuristik-Kopie ohne Marker-Aenderung -> Exit 1 + 'OHNE' + Dateiname, Ruecknahme -> Exit 0; B2 = Drift + Marker-Bump N->N+1 -> Exit 0 + 'MIT Version-Bump'. Ziel aus dem Lock waehlen (category == "heuristik"), nie hartkodiert.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: ctest

### [wfr31gpjz] 5 (HINWEIS)
GEGENSTAND: --write meldet Erfolg ohne Schreib-Beleg: nach erfolgreichem open wird der ofstream nie geprueft; GEFAHREN: '--write /dev/full' -> Exit 0 mit 160 stdout-Zeilen bei null angekommenen Bytes (Klasse volle Platte/Quota beim Regen-Commit).
ORT: axis_version_lock.cpp:412-445
SOLL/FIX (verbatim): Vor dem return in do_write: out.flush(); if (!out) { FEHLER-Meldung; return 2; }.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [wfr31gpjz] 6 (HINWEIS)
GEGENSTAND: Nicht durchsuchbares Unterverzeichnis unter einem Home terminiert per unbehandelter filesystem_error: SIGABRT Exit 134 (ausserhalb des deklarierten 0/1/2-Kontrakts :56-57), stderr ohne Werkzeug-Praefix/Verzeichnisname/BESTAND; betrifft --check UND --write. Im CI fail-closed, aber Diagnose nennt den Ort nicht.
ORT: axis_version_lock.cpp:138 und :201 (recursive_directory_iterator ohne error_code, keine Fassung)
SOLL/FIX (verbatim): Iterator mit std::error_code fuehren bzw. try/catch je Home; bei Fehler 'FEHLER Verzeichnis nicht durchsuchbar: <pfad>' + Exit 2.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [wfr31gpjz] 7 (HINWEIS)
GEGENSTAND: Versions- UND Kategorie-Spalte des Registers werden bei gleichem Digest NIE gelesen (toter Registerinhalt); verbogener Record 'WURST 9.9.9.z ...' prueft bei gleichem Digest kommentarlos gruen (GEFAHREN). Im Drift-Fall fail-closed, ERNST wird die Zelle erst durch die Ruhelage-Blindheit.
ORT: axis_version_lock.cpp:557 (continue vor jedem Spalten-Blick), :559/:569 (Dispatch nur auf ist.category)
SOLL/FIX (verbatim): Im Digest-gleich-Zweig vor dem continue: soll.category != ist.category ODER soll.version != ist.version -> ROT 'Register-Spalte widerspricht Bestand'.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: deckt sich mit Fix 2 (--write-Diff)

### [wfr31gpjz] 8 (Erhebungs-Fakten mit Design-Gewicht, Sammel)
GEGENSTAND: Weitere gefahrene Objekt-Fakten der Erhebung: (a) Exit-Code-Abweichungen vom Kontrakt: fehlendes/unlesbares Register liefert 1 statt 2 (:452-453); (b) Reihenfolge bindend: kaputtes Register (Exit 1) verdeckt kaputten Baum (:541 vor :545); (c) leere Grundgesamtheit gegen leeres Register = Exit 0 'GRUEN 0 Dateien' -- Nenner gedruckt aber nicht geprueft (V-1-Zelle!); heuristik-Nenner konstruktiv tautologisch (traeger==discovered, :398); (d) Symlink-Anomalien: Ziel ausserhalb --root wird als '../aussen.hpp' gelockt; doppelt sichtbare Datei -> Zaehler zaehlen doppelt bei 1 Record (BESTAND 2+3 != 4 in derselben Zeile); Symlink ins Leere/auf Verzeichnis still uebergangen; (e) Leerzeichen-Pfad: --write schreibt anstandslos (Exit 0), eigenes Register wird fuer --check unlesbar (einseitige Grenze); (f) heuristik-Marker-Suche ist roher Byte-Substring: 'OLD_AXIS_ALGO_VERSION: 99' gewinnt, Marker im String-Literal gewinnt, '007'->7, '12abc'->12, erster von zwei Markern gewinnt; (g) organ-Scanner erkennt u8"..." und Brace-Init NICHT (im echten Baum 0 Vorkommen); (h) Mehrfach-Literale: genau 1 Datei (axis_03a_search_algo_k_ary.hpp:141+:573) -- declared_version = ERSTES Literal, Bump des ersten deckt Rest der Datei; (i) BESTAND-Zeilen erscheinen bei Exit 0/1, NICHT bei Exit 2/134 (kein gedruckter Nenner auf Umgebungsfehler-Pfaden); (j) CI-Job ohne --root -> cwd-abhaengig (GitLab-Konvention, nicht belegt); (k) ctest ist hermetisch (Kopien) -> prueft NIE das committete Register, dessen Gueltigkeit haengt allein am CI-Job; (l) Flag-Politik ('mindestens c') wird von bump_ok nicht geprueft (1.0.0.c -> 2.0.0 akzeptiert), hat aber CT-Zweitdeckung (axis_variant_version_table.hpp:108 u.a.) -- Vollstaendigkeit dieser Zweitdeckung ueber alle 122 Traeger NICHT durchgezaehlt; (m) '-'-Versionen (30 Forwarder/Prosa) haben keinen Bump-Pfad: jede Aenderung verlangt --write.
ORT: s. Einzelstellen in axis_version_lock.cpp
SOLL/FIX: als Design-Input; keine Einzel-Fixes von der Analyse gefordert (ausser via Fixe 1-7).
STATUS LT. QUELLE: nur-hinweis / gemessen
ABHAENGIGKEIT/FLAECHE: S-14a-Landung

### [wfr31gpjz] 9 (NICHT GEPRUEFT der Analyse)
GEGENSTAND: Offene Pruefluecken: _WIN32-Verhalten (Koeder F/F2 uebersprungen); echte GitLab-Pipeline dieses Branch-Stands (workflow:rules nicht vollstaendig geprueft); TOCTOU-Fenster Discovery vs. Digest; ob die 235 nicht-discovered *.hpp ausnahmslos in gebaute Artefakte einfliessen (Include-Graph nicht erhoben); ctest im gebauten Zustand des Worktrees (Tool fuer Experimente mit g++ -O0 im Job-tmp gebaut, anderer Compiler als CI); Zusammenspiel Register/Diff-Hygiene-ASCII (laengste Zeile 108, 0 Nicht-ASCII); fachliche Berechtigung der 30 '-'-Dateien; Vollstaendigkeit der static_assert-Zweitdeckung.
ORT: s. Eintrag 8
SOLL/FIX: bei Landung beruecksichtigen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

## Datei w8zswfsku.json (Explore Modi-Staffelung measure/compare/release + Kette XML->Messung->Auswertung->Binary/Messwert/PDF + Auswertung-in-CEB; 3 Agenten)

### [w8zswfsku] 1
GEGENSTAND: Staffelung measure c= compare c= release: Prinzip mehrfach datiert belegt (Ledger Par.61-STUFEN 21.07. LEDGER:3287-3291 woertlich measure c= release; Thesis 03_messsystem_prtart.tex:1428-1432 vier aufeinander aufbauende Betriebsmodi; Owner-Verbatim 05.08. Atlas-Runde-5). ABER: der formale run_methodology-Wert 'compare' wird in JEDER schriftlichen Quelle GENAU UMGEKEHRT sequenziert (NACH Release: Par.62-C LEDGER:3343, Atlas-CMP-Knoten, run_methodology_registry.hpp:7-8). Zwei geplante Vergleichs-Konzepte (intra-Maschine Kurven-Vergleich VOR Release vs. Cross-Maschinen-Replay-Vergleich NACH Release) wurden NIRGENDS zu einer Enthaltungskette vereinigt -- die 07.08.-Owner-Korrektur verschmilzt sie erstmals; als offene Spannung dem Owner zurueckzumelden.
ORT: LEDGER:3287-3291, :3343; thesis 03_messsystem_prtart.tex:1428-1477; ce docs/architecture/05b_uml_klassenatlas_20260805.html:712-733; run_methodology_registry.hpp:1-14
SOLL/FIX: Spannung Owner vorlegen; beide Vergleichs-Konzepte explizit trennen oder vereinigen.
STATUS LT. QUELLE: TEILWEISE_GEPLANT / offene Spannung
ABHAENGIGKEIT/FLAECHE: D2-Paket; F-08 (w1buo8hac)

### [w8zswfsku] 2
GEGENSTAND: single_thread-Semantik: Registry-Konstanten koennen die Owner-Bedingtheit ('WENN Messung noetig -> 1-Thread, Normalfall Replay-Abfrage') strukturell nicht ausdruecken; einziger Konsument measure_parallelism.hpp:23-25 steuert nur Parallelitaetsgrad, nicht OB gemessen wird; PlanBuildSemantic::measurement_on hat NULL Konsumenten (geschrieben, nie gelesen, gated NICHTS); der noetige Mechanismus 'suchen -> Replay ODER materialisieren' = Par.58-REPLAY ist Ledger-explizit OFFEN (LEDGER:2968/:3133, 'OFFEN, hoch', kein GEBAUT-Vermerk in 10 Treffern).
ORT: run_methodology_registry.hpp:74-79; measure_parallelism.hpp:23-25; experiment_plan_director.hpp:115/:1994
SOLL/FIX: Par.58-REPLAY bauen (dritte Verhaltensform: bedingtes Messen mit Bestandslog-Existenzpruefung).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Bestandslog (T-04); D2

### [w8zswfsku] 3
GEGENSTAND: Publikationspfad existiert real (best_binary_selector: RankingCriterion/TiereDllRepository/ShippedArtifactBuilder, Task #172), aber Modus-Bindung fehlt VOLLSTAENDIG: 0 Treffer RunMethodology im ganzen best_binary_selector-Baum; --csv freies CLI-Argument ohne Herkunfts-Pruefung; 0 CI-Einbindung; konsumiert die Splines NICHT (Synthese-Bruecke hybrid_router.hpp = SOLL HY-B2, existiert nicht); Thesis stuft es selbst als Teil-Inkrement ein; erster Auswertungs-Treiber-Lauf der es mit break_even_table verbindet fuer 12.09. geplant, 'vollstaendige' Fassung erst nach 15.09.
ORT: ce libs/cache_engine/builder/best_binary_selector/ (hpp 372 Z., cpp 584 Z., main 148 Z.); tools/best_binary_selector/CMakeLists.txt; thesis 03_messsystem_prtart.tex:1401-1403
SOLL/FIX: Verkettung Modus -> Auswertung -> Publikation als EIN Codepfad; hybrid_router.hpp-Bruecke.
STATUS LT. QUELLE: teilweise (Baustein da, Bruecke fehlt)
ABHAENGIGKEIT/FLAECHE: B-9/W1-S-A; HY-B2

### [w8zswfsku] 4
GEGENSTAND: KEINE Wache verhindert compare/release OHNE vorausgegangene Messung: beide Emissions-Pfade (CI-YAML :1102-1108 UND CMake :1662-1670) emittieren unbedingt Build- UND Mess-Job ohne Modus-Verzweigung; run_methodology verzweigt nur die exactly-one-Formpruefung; provision_only/pruef_only laufen nur ueber Env-Variablen; Gegenprobe: die Suchmethode findet echte Guards anderswo (Registry-throw; CMakeLists FATAL_ERROR) -- Nichtfund ist echter Befund.
ORT: experiment_plan_director.hpp:1102-1108, :1662-1670; profile_run_facade.hpp:60-66
SOLL/FIX: Praeflug-Pruefung 'schon gemessen?' (Par.58-REPLAY) bauen; Modus-Skip fuer den Mess-Job.
STATUS LT. QUELLE: offen (Negativbefund mit Nenner + Gegenprobe)
ABHAENGIGKEIT/FLAECHE: Par.58-REPLAY; D2

### [w8zswfsku] 5
GEGENSTAND: Kette XML->Messung->Auswertung->Ergebnis in vier datierten Schichten verankert (09.07. Dossier 19 Teil G [bindend, E4-Kette CSV->LaTeX->PDF auf alle 4 Phasen ausdehnen]; 16.07. Synthese; 05.08. Owner-Verbatim; 06.08. Owner-Trias 'binary compile und Messwert-Lager ... PDF auswertung zum Schluss' LEDGER:7095). EINSCHRAENKUNG: die woertliche GLEICHUNG measure=Messung/compare=Auswertung/release=Ergebnis der run_methodology-Werte auf diese Kette existierte VOR dem 07.08. nirgends -- neue Owner-Synthese.
ORT: docs/architektur/19_SCHICHTEN...md:62-73,:90; docs/audits/20260716-e11...SYNTHESE.md:15-51; LEDGER:4176,:7095; thesis 04_implementierung.tex:302-386
SOLL/FIX: Vokabular-Vereinigung dokumentieren.
STATUS LT. QUELLE: GEPLANT_UND_BEANTWORTET (mit Einschraenkung)
ABHAENGIGKEIT/FLAECHE: -

### [w8zswfsku] 6
GEGENSTAND: Fuenf Ergebnis-Arten mit Erzeuger/Zielort: (1) BINARY: Planer baut NUR CEB, CEB baut Tier + spaeter Hybrid; CI-Cache dev = Planer-Binary, prod-MinIO = alle Folge-Stufen (Par.31-A4); (2) MESSWERT: CEB schreibt SELBST an XML-Ziel; measurement/<ts>/ im Root, auto-committet (Par.11-G); Phase 2 NAS offen; IST: genau EIN Archiv (20260726-164259-d03-strukt-r-erstbeleg); (3) PDF: dritter Akteur (csv_to_latex/diagram_generator/latex_to_pdf via .ps1-Skripte); E-18-Kanal LANDEBEREIT aber INERT; E18-SNAP nur angefragt; (4) LATEX via <output><latex_path>; (5) XLSX: Owner-Kanon 'CSV XOR xlsx, xlsx DEFAULT' (Strategy-Pattern) -- Ledger traegt ZWEI WIDERSPRECHENDE Status-Zeilen (aeltere ~7016 'keine Aenderung noetig' vs. juengere bindende ~7195/7202 B12-Pflicht) -- aeltere durch 0-Treffer-Befund nachweislich falsch.
ORT: LEDGER:2261,:2275,:1724,:846,:810,:4165-4166,:7014-7016,:7194-7202; experiment_schema.xsd:439-447
SOLL/FIX: B12/A9 xlsx-Writer bauen (0 Zeilen Implementierung bei 1587 libs-Dateien; Gegenprobe csv=103); Ledger-Widerspruch aufloesen.
STATUS LT. QUELLE: xlsx offen (0 Code); E-18 inert
ABHAENGIGKEIT/FLAECHE: A9-S3/S4-Straenge (inzwischen auf bau/a9-s4-mess-report -- Designer: gegen Landestand abgleichen!)

### [w8zswfsku] 7
GEGENSTAND: XSD-Steuerung + Modus-Eingriff: 4 XSD-Elemente (run_methodology exactly-one; output mit 3 Pflicht-Zielpfaden + storage backend local|minio; writeback_methods 'KEIN pdf'; measurement_tooling); XSD-KOMMENTAR beim compare-Wert STALE (datiert 20.07. 'KEIN Registry-Eintrag', Code fuehrt compare seit 26.07.) = dokumentierter Drift Kommentar vs. Code; Modus greift NUR an cmake_build_type + Mess-Parallelitaet an, NICHT an output/writeback (orthogonal).
ORT: experiment_schema.xsd:86-88,:93-101,:126-128,:289-319,:662-679; experiment_golden_kern.xml:415-447; run_methodology_registry.hpp:36-79; measurement_axis_registry.xml:59 (TODO + Zeilen-Drift)
SOLL/FIX: XSD-Kommentar nachziehen.
STATUS LT. QUELLE: nur-hinweis (Drift) 
ABHAENGIGKEIT/FLAECHE: -

### [w8zswfsku] 8
GEGENSTAND: Bau-Stand der Kette je Glied (Stand 06.08. abend): XML-Eingang GEBAUT; Messung TEILWEISE (7-Phasen-Pipeline golden-320-getestet; Voll-Lauf USER-GO-STOPP; IST 1 Mess-Archiv gegen 131072/524288 geplante); Auswertung TEILWEISE mit bekanntem Defekt (diagram_generator liefert 0.0000 statt 'keine Daten' fuer nie ausgefuehrte Operationen -- honest-empty-Defekt seit 06.08. identifiziert, Fix-Plan 3 Aenderungsorte, 0 umgesetzt); Ergebnis/PDF code-fertig aber NICHT SCHARF (E-18 landebereit/ungelandet, CI-Job inert, 0 von 2 Haelften scharf); Modus-Ebene: 4/4 typisiert, nur 2/4 verhaltensdifferenziert (release/compare byte-gleiche Etiketten; 'Vollzug D2' -- fuer D2 existiert KEINE eigene Definition im Korpus ausser dem einen Registry-Kommentar).
ORT: LEDGER:7075-7076 (honest-empty-Defekt), :7096, :7112/:7121/:7137-7139; run_methodology_registry.hpp:7-13,121-129
SOLL/FIX: honest-empty-Fix (3 Orte); E-18 scharf; D2 spezifizieren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: W2/W5; U-03

### [w8zswfsku] 9
GEGENSTAND: Auswertung/Break-Even in der CEB: Sequenz 'erst voll messen, dann auswerten' Owner-verbatim; Komponenten liegen in libs/cache_engine/builder/ bzw. heuristik/; InMemoryMeasurementBuffer existiert (F5, getestet) hat aber 0 Includer ausser eigenem Test; best_binary_selector ist SEPARATES CMake-Target unter tools/ (NICHT in CEB einkompiliert), liest CSV von Platte; 'im RAM ohne Platten-Umweg' fuer Break-Even NICHT verdrahtet; A9-Design plant Writer als CSV-Leser nach der Messung.
ORT: best_binary_selector.cpp:455,:520; in_memory_measurement_buffer.hpp:38-77; ist-ceb.md:176-182,238-255
SOLL/FIX: Verdrahtung der RAM-Auswertung offen (Lesart klaeren).
STATUS LT. QUELLE: TEILWEISE_GEPLANT
ABHAENGIGKEIT/FLAECHE: B-9

### [w8zswfsku] 10
GEGENSTAND: Vollstaendigkeits-Pflicht vs. Sampling: KEIN Widerspruch in der Auswertung gefunden -- Verwerf-Mechanismen sind Qualitaets-Gates (na_tokens; Disqualifikation bei unvollstaendiger Zell-Abdeckung REV-DATA-07; --top N nur Anzeige); einzige echte Sampling-Funktionalitaet (--mode=full-sampled) sitzt in der ALTEN REV-7.6-Demo-Pipeline (nicht Live-CEB-Rolle, Default aus); O-5: nur Binaries+Sidecars werden verworfen, NICHT Messwerte (CSV additiv).
ORT: best_binary_selector.hpp:200-215; measurement_curve_loader.hpp:1-34; permutation_sampling.hpp:44-49; 20260806-PLAN-messkette-ceb-observabletier.md:951-971
SOLL/FIX: kein Fix noetig (Entlastungsbefund).
STATUS LT. QUELLE: geprueft, kein Widerspruch
ABHAENGIGKEIT/FLAECHE: -

### [w8zswfsku] 11
GEGENSTAND: Anforderungskanal Planer->CEB eindimensional / CEB<->Tier bidirektional: durchgaengig belegt (Ledger:517/:1722-1724/:1985; 06.08.-Dokumente); Praezisierung: real 'bidirektional mit ASYMMETRISCHER Nutzlast' (ProgressDelta-Cursor CEB->Planer, KEIN Mess-Daten-Rueckfluss) -- und selbst dieser duenne Kanal hat heute KEINEN Rueck-Leser beim Planer (ist-ceb.md:268-277).
ORT: LEDGER:517,:1722-1724,:1881,:1985,:2373; 20260719-FINALES-DESIGN-ABSTRACT:52,:114; ist-ceb.md:268-277
SOLL/FIX: ProgressDelta-Rueck-Leser (offener Posten).
STATUS LT. QUELLE: GEPLANT_UND_BEANTWORTET; Cursor ohne Leser offen
ABHAENGIGKEIT/FLAECHE: -

## Datei w1pdr52b0.json (Workflow "vergessene Arbeit" 07.08. ~00:20 UTC: Wellen-Journale + ungelandete Arbeit + unbehandelte Owner-Nachrichten + Bilanz; 4 Opus-Agenten. ACHTUNG: Stand 07.08. -- viele Posten inzwischen vermutlich gelandet; Designer MUSS gegen 13.08.-Stand abgleichen)

### [w1pdr52b0] 1 (V-1, damals ROT-ROT)
GEGENSTAND: numa/core_class-Paket lag auf NULL Remotes: ce-Zweige b-numa-cpu-pin-process-probe (b1753926, Rename-Commit) + b-numa-process-probe (b4cebdc4), 18 Dateien +2800/-33; for-each-ref refs/remotes --contains b1753926 = 0 (Nenner 231 Refs / 40 rescue); kein Patch in backups-workflow. Review-Verdikt der Pruefwelle wf_f94d1373: "LUECKE" (nicht LANDEBEREIT) -- unbehandelt. Rescue-Ref zeigte nur auf b4cebdc4 (vor dem Rename).
ORT: /home/comdare/wt-numa-cpu-pin; Branches s.o.
SOLL/FIX: SOFORT beide Zweige pushen; LUECKE aus wf_f94d1373 schliessen (= die 4 Muster-Treue-Luecken aus wjpdo2ukt 8-11); mergen. Owner-Umbenennung numa_process_probe -> numa_cpu_pin_process_probe war zeitweise NUR gestaged (inzwischen committet als b1753926).
STATUS LT. QUELLE: offen@07.08. (Landestatus am 13.08. VERIFIZIEREN)
ABHAENGIGKEIT/FLAECHE: A-3 P-/E-Core-PMC setzt Landung voraus; V-3 XSD-Haelfte

### [w1pdr52b0] 2 (V-2)
GEGENSTAND: 3 Plandokumente, 2433 Zeilen, auf 0 von 47 super-Refs (nur Desktop-Plain-Backup): 20260806-PLAN-hybrid-architektur-pmc-achsen-zuordnung.md (1043), 20260806-PLAN-messkurven-synthese-und-hybrid-binary.md (768), 20260806-ANWEISUNG-pmc-intel-perf-rechte.md (622; enthaelt errno-Sonde: widerlegt paranoid=1-Tabelle, erklaert cache_misses_l3=0 auf Zen5 per errno=2, energy_micro_joules=0 per DAC 0400 root:root). git clean -fd im Hauptcheckout vernichtet sie.
ORT: super-Hauptklon docs/plaene/ (untracked)
SOLL/FIX: committen vor jedem git clean.
STATUS LT. QUELLE: offen@07.08. (am 13.08. verifizieren -- wjpdo2ukt-Explore zitiert diese Plaene bereits, vermutlich gelandet)
ABHAENGIGKEIT/FLAECHE: PMC-Ursachenfrage; OD-11-Namensquelle

### [w1pdr52b0] 3 (V-3)
GEGENSTAND: experiment_schema.xsd +24 Z. core_class uncommittet im super-Hauptklon (Blob f3b31257 auf 0 von 47 Refs) -- die super-Haelfte des OD-11-Pakets; landet nur die ce-Haelfte, kann kein XML die Achse ausdruecken. (Deckt sich mit wjpdo2ukt Eintrag 5: Patch /tmp/od11-xsd-core-class.patch.)
ORT: /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/test_data_xml/experiment_schema.xsd
SOLL/FIX: als EIN Paket mit V-1 landen.
STATUS LT. QUELLE: offen@07.08.
ABHAENGIGKEIT/FLAECHE: V-1

### [w1pdr52b0] 4 (V-4)
GEGENSTAND: Code/measure_out_d03/ 66 Dateien / 3,7 MB Rohmessdaten untracked (progress.cursor, e4_xml/measurements.csv, 8 DLL-Permutationsordner mit result.csv/.stamp/.version/.rsp; mtime 26.07.); check-ignore rc=1 = nicht ignoriert; die vier d03-Logs sind der einzige Zugang zur offenen PMC-Ursachenfrage; Doktrin "Messdaten nie loeschen".
ORT: super Code/measure_out_d03/
SOLL/FIX: additiv sichern vor jedem git clean.
STATUS LT. QUELLE: offen@07.08.
ABHAENGIGKEIT/FLAECHE: Messdaten-Doktrin

### [w1pdr52b0] 5 (V-5)
GEGENSTAND: super-Gitlink 10 Commits / 2 Landungen hinter ce (2b5ecd29 vs. c4c04315; fehlend komplette M-1-Serie + pmc-l3-honest); ce main haengt 2 Landungen hinter development; super-Pipeline triggert fest auf branch main -> misst nicht den gefahrenen Code.
ORT: super development Gitlink
SOLL/FIX: Gitlink-Bump + ce main nachziehen (Bridge triggert auf main).
STATUS LT. QUELLE: offen@07.08. (13.08. laengst weiter -- verifizieren)
ABHAENGIGKEIT/FLAECHE: Landereihenfolge

### [w1pdr52b0] 6 (V-6/A-4 + FALSCHE ERLEDIGT-MELDUNGEN)
GEGENSTAND: B12 xlsx-Default-Writer existierte nicht (0 Writer-Symbole in 1583 libs-Dateien, csv=102); Owner DREIMAL verlangt (#005 "Es gibt erstmal xlsx", #036 "Es existiert kein CSV Lager. xlsx ist default.", #068-F2 Ledger:7194 "muss auch noch mit in die Abgabe vor der Messung"); ZWEI falsche Ledger-Entlastungen: Ledger:7016 "xlsx-Writer braucht KEINE Aenderung; B12 keine Voraussetzung" (entlastet nicht existenten Code) und :7096 Rueckstufung auf "P4 waehrend/nach Messung" gegen :7195/:7202 + Owner-Wort. Sonst KEINE falschen Erledigt-Meldungen gefunden (Buchfuehrung ehrlich).
ORT: LEDGER:7016/:7096/:7195/:7202; libs/ (Nenner 1583)
SOLL/FIX: B12 bauen vor Messbeginn + in die Abgabe; falsche Ledger-Zeilen korrigieren/markieren.
STATUS LT. QUELLE: offen@07.08. (A9-S3/S4 inzwischen auf bau/a9-s4-mess-report -- Landestand pruefen)
ABHAENGIGKEIT/FLAECHE: A9; Phase 6 faehrt sonst auf CSV

### [w1pdr52b0] 7 (V-7/V-8)
GEGENSTAND: (a) b-e18-snap 3 Commits ahead (+2673/-37), 6 rescue-Refs auf beiden Remotes, CODEX-VETO "NICHT-LANDEN" steht (docs/sessions/backups/20260806-e18-snap-welle/CODEX-VERDIKT-NB2-5c4cf900-NICHT-LANDEN.md); gitlab-ci-delta.patch UNANGEWANDT (ohne ihn persistiert der Job nichts); terminiert auf "nach der Abgabe" -- nicht nachholen, nicht vergessen. (b) Tag w2b-E04-P1-prefold-daf5190e: 2 verwaiste Patches (92ad8357 Emissions-Seite Slice-Kanal, 63406ce3 Director-Test-Migration, beide '+'); Ledger sagt "E-04-P1 gelandet" -- Widerspruch besteht -> entscheiden (landen oder als ueberholt buchen).
ORT: b-e18-snap (5c4cf900); Tag w2b-E04-P1-prefold-daf5190e
SOLL/FIX: wie angegeben.
STATUS LT. QUELLE: offen@07.08.
ABHAENGIGKEIT/FLAECHE: E-18/U-03; E-04-P1

### [w1pdr52b0] 8 (V-9/V-10 + Fallen)
GEGENSTAND: (a) Thesis-Research-Klon 20260931-overleaf-diplomarbeit kennt 19e1592 nicht als Objekt (nie gefetcht) -> fetch+FF (Owner #009-Klon-Teil; Memory 4-Klone-Sync). (b) Beide Hauptcheckouts standen auf Feature-Zweigen (super b-ci-rueckschrieb-beide-zeiger 12 Commits hinter development; ce b-m2-pmc-invariante); ' M Code/external/...' im super-Status war Gitlink-Drift, NICHT landen; lokale main-Refs stale (super main 425 Commits hinter origin/main) -- Ursache aller Fehldiagnosen der Runde ("wer git log main misst, misst den 27.07."). (c) W-7: zwei Wellen-Agenten starben mit API-Serverfehler mitten in der Lieferung (0 Write-Aufrufe); unbelegt ob ihr Anteil in den Sammeldokumenten (KANON-termine-plan-soll-gegen-ist.md, DIFF-thesis-soll-gegen-ledger-und-code.md) steht -- kein Neustart der Teil-Scopes.
ORT: s. je Posten
SOLL/FIX: wie angegeben; W-7-Scopes ggf. nacherheben.
STATUS LT. QUELLE: offen@07.08.
ABHAENGIGKEIT/FLAECHE: Mess-Hygiene-Doktrin (Erhebungen nur gegen benannten Ref)

### [w1pdr52b0] 9 (Offene Owner-Interaktionen B-a/B-b)
GEGENSTAND: (a) Owner #099 80-Seiten-Gesamt-Dossier: gestartet, kein Artefakt zum Erhebungszeitpunkt. (b) Owner #100: sechs Planungs-Rueckfragen GESTELLT (Ebene-1-Timing, Pruefdock-Wanderung, Break-Even je Ebene, Lager-Orchestrierung, CT vs. RT Schaltlogik, Mehrdimensionalitaet) -- vom Owner UNBEANTWORTET, blockiert.
ORT: Transkript Z.7907/7949-8053
SOLL/FIX: Antworten einholen bzw. Verbleib pruefen.
STATUS LT. QUELLE: offen@07.08.
ABHAENGIGKEIT/FLAECHE: Owner-Fragen-Stack

### [w1pdr52b0] 10 (Entlastungen/Nenner)
GEGENSTAND: Entlastet am 07.08.: 40/43 Wellen-Dokumente committet; 23/25 Bau-Zweige gelandet; alle 6 0-Ergebnis-Wellen mit gelieferter Nachfolge; git cherry entlastete 26 von 27 Alarm-Commits (reiner SHA-Vergleich haette 9-fach falschen Alarm gegeben -- LEHRE fuer jede Landungs-Pruefung: cherry gegen merge-base, nie SHA-Vergleich); b-pmc-l3-honest/b-m2/b-m3v2/b-pmc-errno-diag/Gate 8/w2-*-Branches alle gelandet; Dossier 2486 Z. + Ledger blob-identisch mit development.
ORT: s. Datei
SOLL/FIX: Dedup-Basis fuer den Designer; Methode (cherry) uebernehmen.
STATUS LT. QUELLE: erledigt
ABHAENGIGKEIT/FLAECHE: -

## Datei wfjg4a9k0.json (F1-Baustein texlive-gate-haertung 13.08.: Bau + Codex-Lens + Fable-Lens + Fix; Branch bau/texlive-gate-haertung im Worktree /home/comdare/wt-super-texgate; LANDEREIF laut Auftrag)

### [wfjg4a9k0] 1
GEGENSTAND: AF_PDF_GATE-Haertung gebaut: anhang:forward setzte AF_PDF_GATE bisher aus COMDARE_TEXLIVE_AVAILABLE (unset -> auto; auto prueft ohne TeX auf dem Job-PATH NICHTS, rc=0, Kanal committet+pusht ungeprueft -- V-8); jetzt hart AF_PDF_GATE=on am Job (fail-closed II.7: kein TeX im Job-Env => ROT VOR Commit/Push). VIER Commits auf bau/texlive-gate-haertung (Basis origin/development a103e518): bb03d53b (Haertung, .gitlab-ci.yml +17/-9), 2cea7287 (Review-Fix: 12.08.-Kontrafaktual entschaerft -- /usr/local/bin/latexmk+pdflatex sind seit 03.07. root-Symlinks = ZWEITE PATH-Quelle; Kommentar auf belegte Aussage umformuliert), 6bd5b263 (Enum-Wache AF_PDF_GATE case on/off/auto, Nicht-Enum-Wert stirbt laut; + Zaehl-Wache: >1 Top-Level-Hauptdokument macht on ROT statt Teil-Pruefung -- V-8-Rest FALL E geschlossen), 5363eebb (10 stale Zeilen-Anker im YAML-Kopf nachgemessen, Drift +41..+123). Worktree ahead 4, KEIN PUSH, Arbeitsbaum sauber.
ORT: /home/comdare/wt-super-texgate; super .gitlab-ci.yml anhang:forward-Block; ci/anhang_forward_core.sh (run_pdf_gate :1301-1316 alt / :1629 neu)
SOLL/FIX: Landung ueber die Lande-Stufe (parallel bauen, sequentiell landen); Worktree erst nach gruen+Merge+Submodul-Branch-Pruefung loeschen.
STATUS LT. QUELLE: gebaut+verifiziert (Lenses: Codex TRAEGT_MIT_FIXES, Fable BESTANDEN; Fix-Stufe: 18 Quittungen, 4x BEHOBEN, Rest ENTLASTET; Suite ci/tests/anhang_forward_probe.sh 18/18); LANDUNG OFFEN
ABHAENGIGKEIT/FLAECHE: Merge-Flaeche .gitlab-ci.yml (Zeilen-Anker verschieben sich beim Merge ERNEUT -- die 11 CI-INV-Kopfzahlen am GEMERGTEN Stand nachmessen, Werkzeug unter /tmp/texgate_fix); U-03/E-18

### [wfjg4a9k0] 2
GEGENSTAND: Infra-Posten VOR dem Scharfschalten (COMDARE_ANHANG_FORWARD-Flip): TeX muss in den Job-PATH des gitlab-runner-Users (TeX Live 2026 installiert; /usr/local/bin-Symlinks vorhanden -- ob der Runner-Job-PATH /usr/local/bin sieht, ist ohne root/Testlauf unentscheidbar, config.toml root-only); mit der Haertung wird der Lebend-Check ohne diesen Posten ROT (gewollt), aber der Posten muss vorher stehen. Ist-Zustand der Projekt-Variablen COMDARE_TEXLIVE_AVAILABLE/COMDARE_ANHANG_FORWARD nicht abgefragt (kein API-Zugriff in der Session).
ORT: prod1 Runner-Umgebung; GitLab-Projekt-Variablen
SOLL/FIX: erster scharfer Lauf beantwortet PATH-Frage empirisch; beide Ausgaenge tragen (baut wirklich ODER laut rot).
STATUS LT. QUELLE: offen (Infra/Betrieb)
ABHAENGIGKEIT/FLAECHE: U-03-Scharfschaltung; thesis:pdf bleibt an COMDARE_TEXLIVE_AVAILABLE gegatet (unveraendert)

### [wfjg4a9k0] 3
GEGENSTAND: Deklarierte Grenzen/Folgeposten: (a) Kern-Semantik auto/off unveraendert -- ein kuenftiger zweiter CI-Aufrufer des Kerns laege in derselben auto-Falle (dann dort hart on setzen oder Kern-Default fail-closed drehen = groesserer Schnitt, 6 Doku-Bloecke + Probe betroffen); (b) Listen-Erweiterung des PDF-Gates bei Einfuehrung eines zweiten Hauptdokuments (EN) ist eigener Design+Bau+Verify-Zug (kaskadiert in den E-18-SNAP-Ernte-Vertrag AF_GATE_MAIN/AF_GATE_TOOL/AF_GATE_PDF, zweiphasige Ernte, compile_snapshot_refixieren) -- seit 6bd5b263 erzwingt das Objekt ihn LAUT; (c) ANKER-DRIFT IST SYSTEMISCH (CI-INV-Kopfzahlen zum zweiten Mal grossflaechig daneben; 10 von 11 stale) -- Kopf deklariert sie als Orientierung, CiInvarianten als verbindliche Wache; (d) Stufen-Versatz-Lehre: Standort-Angaben (ahead N) je Stufe frisch messen statt uebernehmen.
ORT: ci/anhang_forward_core.sh; .gitlab-ci.yml-Kopf
SOLL/FIX: als Folgeposten fuehren.
STATUS LT. QUELLE: offen (deklarierte Grenzen)
ABHAENGIGKEIT/FLAECHE: E-18-SNAP; EN-Hauptdokument

## Datei w83v9wfv4.json (##25 DURCHSTICH-Workflow = F1-Lieferung Fr 14.08.: Kern-Explore -> Bau-Schnitt -> Bau im Worktree -> Verify; 5 Agenten; Verify-Urteil: LANDEFAEHIG_MIT_FIXES)

### [w83v9wfv4] 1 (KERNBEFUND: Durchstich faehrt heute NICHT)
GEGENSTAND: Der F1-Durchstich stirbt am Objekt: Mess-Stempel-Konflikt -- KON5-01 ("leerer Mess-Stempel = Soll") gilt fuer den EMITTER, die Pruefseite verlangt die Vollmengen-Zeile; emittierte perm.cpp der Basis-320-Zelle traegt die 2-arg-Form (lazy_gen steht per INC-G6 HINTER base_union; f1_durchstich faehrt label=basis-320 -> Katalog bedient die id, lazy Gen mit der Mess-Zeile wird NIE konsultiert). Lauf: fehlerklasse=mess_konsistenz status=deklaration_leer (haupt_ist=0, haupt_soll=3), measured=0, exit=1. CI trifft es identisch (measure:smoke setzt dieselbe Env, YAML:1908) -> Job rot VOR dem Marker.
ORT: adhoc_emitter; mess_achsen_naht.hpp:242ff; anatomy_version_stamp.hpp:376-378; measure_out_mini-Beweislauf auf ce 670483c0
SOLL/FIX: ENTSCHEIDUNG (Owner/Lead): entweder S-6-Vorziehen fuer den Stempel-Befund (S-6-Fenster Mo 17.-Mi 19. NACH F1, preimage-wirksam, TABU im Bau) ODER F1-Lieferung neu schneiden. Der Bau dokumentiert bewusst nur, behebt nicht.
STATUS LT. QUELLE: offen (F1-BLOCKER)
ABHAENGIGKEIT/FLAECHE: S-6 (Glieder-Reihenfolge, Explore-Pflicht laut Memory); F1-Schnitt; Anmerkung Auftrag: super bau/f1-1x1-honest-empty ist landereif -- Designer muss pruefen ob dieser den Befund adressiert

### [w83v9wfv4] 2 (STILLE FALLE)
GEGENSTAND: Die eine "Datenzeile" des Laufs ist KEIN Messwert -- n_ops=n/a total_ns=n/a ns_per_op=n/a workload=n/a quality_flag=n/a (provisioned=1, 180x n/a); mess_ausbeute_wache sagt OK, frische_wache sagt OK; NUR durchstich_wache frische faengt es (measured>=1-Forderung). Ohne dieses EINE Gate liefe eine n/a-Zeile bis in die Thesis-PDF.
ORT: ci/mess_ausbeute_wache.sh; ci/frische_wache.sh; ci/durchstich_wache.sh
SOLL/FIX: Gate-Abdeckung beachten: die frische-Pruefung ist der einzige Fang; im Design als tragendes Gate fuehren (nicht optional).
STATUS LT. QUELLE: offen (Warnung; wichtiger als der rote Lauf laut Quelle)
ABHAENGIGKEIT/FLAECHE: W4-Mess-Nenner-Klasse (vgl. w1buo8hac Eintrag 114)

### [w83v9wfv4] 3 (BAU-ERGEBNISSE, ungelandet)
GEGENSTAND: Drei Commits im Workflow-Worktree wf_1fb6bc6f-719-4, KEIN PUSH: super worktree-Branch worktree-wf_1fb6bc6f-719-4 mit ac2afddd (MANUAL_RUN.md Block "8b. F1-Durchstich", 75 Z.: Startzeile Pipeline auf development mit COMDARE_DURCHSTICH=true + COMDARE_PERSIST_MEASUREMENTS=true + COMDARE_ANHANG_FORWARD=true; Warnung COMDARE_RUN_MEASURE NICHT setzen [haengt golden-320/10d an denselben resource_group-Slot, YAML:1831-1834]; Voraussetzung 4 Writeback-Variablen 288/289) + 8c611825 (Ledger/Sessions KON40-Zwischenstand); ce-Branch wf-p2p3-messnaht-korrektur mit 516c05a0 auf 670483c0 (P2/P3: stale '[all] => LEER/""'-Kommentare korrigiert, NUR Kommentare, 52+/5- alle //; Abweichung vom Schnitt: Anker adhoc_emitter.hpp 3-arg-Behauptung NICHT eingebaut weil am Objekt WIDERLEGT -- gemessener Befund steht im Kommentar). Gitlink BEWUSST NICHT gestaged. ce-Commit fetchbar aus .git/worktrees/wf_1fb6bc6f-719-4/modules/Code/external/comdare-cache-engine.
ORT: /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/.claude/worktrees/wf_1fb6bc6f-719-4
SOLL/FIX: Lande-Reihenfolge (verbatim): (1) Kompilier-Beweis fuer 516c05a0 nachholen (Neubau beider Targets auf dem Branch-Stand ODER CI-Bau als Nenner deklarieren, BEIDE Mengen nennen); (2) ce SEQUENTIELL: erst landung/r5-ce-r7 (traegt 670483c0; 670483c0 ist NICHT auf ce origin/development 346b6da9!) nach development, DANN 516c05a0 mergen -- nie rebase; (3) super worktree-Branch per MERGE auf development (origin 3 Ledger-Commits voraus, disjunkt, konfliktfrei, kein FF); Gitlink NICHT bumpen (F1 faehrt gepinnten Stand 670483c0; Bump NACH F1); (4) Diff-Hygiene push-lokal, dann Push + Pipeline gruen; (5) F1-Entscheidung (Eintrag 1); (6) 4 Writeback-Projektvariablen (288/289, protected+masked) im GitLab pruefen -- aus FS unpruefbar, ohne sie brechen persist/anhang hart (HTTP-500 vom 09.08. unbelegt behoben); (7) Worktree erst nach gruen+gemergt loeschen; Belege (Code/measure_out_mini, messlauf-stdout.log, .p4_*.log) vorher additiv ins Workflow-Backup.
STATUS LT. QUELLE: gebaut, ungelandet; LANDEFAEHIG_MIT_FIXES
ABHAENGIGKEIT/FLAECHE: landung/r5-ce-r7-Vorlandung; super development (3 Commits voraus); Writeback-Variablen

### [w83v9wfv4] 4 (Verify-Funde)
GEGENSTAND: (a) P2/P3-Schnitt-Nenner "Neubau gruen" NICHT auf dem editierten Baum erfuellt (Risiko ~0, alle Zeilen //-Kommentare, aber unbewiesen); (b) 670483c0 nur auf origin/landung/r5-ce-r7 -- P2/P3-Landung setzt r5-ce-r7-Landung voraus; (c) .abnahme-Zaehler-Kosmetik; (d) Verbots-Checks alle gruen (Preimage-Diff leer, keine Golden/TABU-Pfade, kein Push, Messdaten erhalten); (e) Kernfrage-Befund am Objekt NACHGEFAHREN und bestaetigt. Nebenbefund: Tier-Treiber meldet g++-16/16.0.1 gegen CEB gcc 15.3.0 (T2-C, lokal, unschaedlich). ZUSATZFUND P1: $GITLAB_USER_LOGIN =~ /_bot_/ -> when: never (:2268, :2436) schaltet BEIDE Schreib-Jobs STILL ab -- Bot-Trigger schreibt weder nach 288 noch 289, OHNE roten Job.
ORT: s. je Fund
SOLL/FIX: vor Landung Punkte 1-7 (Eintrag 3); Bot-Ausschluss-Stille als Wissensposten.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [w83v9wfv4] 5 (bewusst NICHT gebaut -- Abgrenzliste)
GEGENSTAND: Nicht Teil des ##25-Schnitts (je eigener Posten): (1) 2-/3-arg-Umbau + Stempel-Reihenfolge = S-6-Fenster NACH F1 (preimage-wirksam, TABU); (2) D3-4+D3-5 (Batch-Inhalts-Gate + Testat-XOR am lebenden CEB-Weg) = eigener W0b-Posten (Job planer:delegate, disjunkt); (3) D3-1-Marker-Haelfte/pruef_only-Bilanz = anderer Modus; (4) ##20-B git add --pathspec-from-file gegenstandslos (gelandeter Fix ist Datei-Schleife + git ls-files, KON4-06/-08); (5) ##26 korrigierte Formel + ##21 object_stat = eigene W0b-Posten; (6) thesis:pdf-Kopplung an frischen Gitlink im selben Lauf: kein Fix noetig, nur Lese-Hinweis; (7) OD-7 HEAVY_J = Task #22 unberuehrt; (8) keine neuen Wachen/Profile/Tests (Neubau waere zweite Wahrheit); (9) kein Golden/TABU/Preimage-Eingriff.
ORT: Design-Abschnitt nicht_gebaut
SOLL/FIX: Zuordnung der Posten beibehalten (Dedup-Hilfe).
STATUS LT. QUELLE: abgegrenzt
ABHAENGIGKEIT/FLAECHE: W0b-Posten ##20/##21/##26; S-6; #22

## Datei w71fb33yz.json (BAU-START KON47-05, 13.08.: Strang C F1-Planer-Fix [Katalog-Emitter->Vollmenge] + Strang D ce gruenen [#83/#84/#80] + Strang A S-1 Stempel-Basisklasse; 12 Agenten; ALLE DREI BAU-AGENTEN STARBEN MIT API 529 Overloaded; dazu stummer Tod durch volle Platte)

### [w71fb33yz] 1 (STRANG C: NICHT_LANDEFAEHIG -- Bau nie erfolgt)
GEGENSTAND: F1-Planer-Fix (Katalog-Emitter -> Vollmengen-Stempel, P1-P10): Bau-Agent starb (API 529); Verify bestaetigt: KEIN P1-P8-Artefakt existiert (super HEAD 4ca12b56, ce HEAD 9bb664d6 clean; alle Branches/Worktrees geprueft). Explore-Wissen liegt vor: Renderer-Weiche adhoc_emitter.hpp:86-141 (leerer measurement_stamp -> 2-arg; nicht-leer -> 3-arg _M; 2-arg == _M(o,s,"") anatomy_module_abi_v1.hpp:213); ALT: build_pilot_source_map() parameterlos (pilot_source_map.hpp:41), render_adhoc_module_source 4-arg (:54-56).
ORT: ce 9bb664d6; Schnitt P1-P10 im Design-Agent (desC)
SOLL/FIX (verbatim vor_landung/C): kompletter Schnitt P1-P10 NEU bauen. (1) ZUERST Platte raeumen (2,9G frei, Schwelle 5G; Kandidat ~/.cache/uv/builds-v0) -- vorher ist P9-Vollbau regelwidrig, jeder Bau-Strang stirbt womoeglich wieder stumm. (2) Plan korrigieren: P8-Faelle als F27/F28 (F20/F21 belegt, hoechste Nummer F26); P4-Zeilen am Objekt schneiden (Block :528-532; SOTA-Schleife :533-534 konsumiert sota_measurement_stamp, gehoert zur fused-Befuellung, NICHT in den hochgezogenen Block). (3) Lead-Serialisierung: Strang A beruehrt evtl. profile_run_entry.hpp; Strang D #83 lint:format darf die 6 ce-Dateien nicht mitformatieren. (4) Submodule-Pointer-Nachzug 670483c0->9bb664d6 nicht separat landen (wandert mit dem kuenftigen P1-P6-ce-Commit; Entscheidung Lead).
STATUS LT. QUELLE: offen (NEU ZU BAUEN)
ABHAENGIGKEIT/FLAECHE: F1-Blocker (Stempel-Befund aus w83v9wfv4 Eintrag 1 -- DIES ist der Fix-Strang dafuer); Platten-Notstand

### [w71fb33yz] 2 (STRANG D: LANDEFAEHIG_MIT_FIXES -- Arbeit existiert, lag versteckt)
GEGENSTAND: Strang D (ce gruenen: #83 lint:format-Paritaet, #84 Testdateien, #80): Bau-Report "null" war STUMMER TOD (Platte 99%/2.9G), NICHT fehlender Bau -- komplette Arbeit liegt in .claude/worktrees/wf_d826aca8-6ce-8/Code/external/comdare-cache-engine, Branch bau/strang-d-f1-f2-wachen, Head d61c10d0 auf Schnitt 9bb664d6. Im Landungs-Worktree existiert der Stand NICHT.
ORT: /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/.claude/worktrees/wf_d826aca8-6ce-8/...; Branch bau/strang-d-f1-f2-wachen (d61c10d0)
SOLL/FIX (verbatim vor_landung/D): (1) Landung AUS wf_d826aca8-6ce-8 fahren -- im Landungs-Worktree landen hiesse Leeres landen. (2) Untracked strang_d_bau.sh NICHT mitnehmen (Kopf "NICHT committen"); kein git add -A. (3) Nach Push Pipeline beobachten: when:always am Guard-Job + Host-Probe-Zeile "F1b: ... 7 Zeilen" in test:unit; bei Nebenwirkungen Ausweichform eigener Job (Dualreview W2). (4) Die 3 #84-Testdateien erst NACH Landung am Pipeline-Ergebnis neu erheben. (5) Bisektions-Vermerk in den Landungsbogen: Zwischenstaende 3353171e/a432106c einzeln CI-rot am Guard (P3a+P6 gemeinsam in c6a3e991) -- gewollt erklaerbar, kein Defekt des Heads. (6) Platte knapp (6.3G): vor jedem CI-nahen Vollbau df -h.
STATUS LT. QUELLE: gebaut@d61c10d0, ungelandet; LANDEFAEHIG_MIT_FIXES
ABHAENGIGKEIT/FLAECHE: test:coverage-guard Fremd-Inventur (comm mengen-exakt, Exit-Klasse 4, ci_test_coverage_guard.sh:818-831); Merge-Flaeche mit anderen ce-Straengen

### [w71fb33yz] 3 (STRANG A: NICHT_LANDEFAEHIG -- Bau nie erfolgt)
GEGENSTAND: S-1 Stempel-Basisklasse (abi/stempel_basis.hpp, KON43-Zielform: abi/ = Stufe-0-Fundament): Bau-Agent starb (529); Verify: KEIN P1-P9-Artefakt, ce byte-identisch zu 9bb664d6; Bezeichner StempelBasis/stempel_basis/StempelVertrag/ist_stempel_baustein 0 Treffer in allen 8 wt-Worktrees. Explore-Wissen: DIE FUENF Stempel-Typen ohne Basis (KON6-03-Liste am Objekt bestaetigt; u.a. StampSegment abi/anatomy_stamp_entries.hpp:205).
ORT: ce abi/; Schnitt im desA-Agent (P1->P9 strikt sequentiell, ein Schreiber; Namespace comdare::cache_engine::abi)
SOLL/FIX (verbatim vor_landung/A): Landung ABSAGEN -- nichts zu landen; Lead muss Bau NEU starten (Fable 5 max, Stempel-Strecke), Schnitt unveraendert gueltig. VORHER Platte raeumen: Kandidaten wt-super-landung/Code/build-test 2.7G, build-baseline 237M, build-krit 237M, build 126M -- VOR jedem rm die CSV-Belegpruefung (git ls-files + find csv/xlsx beide 0; build-dir kann getrackte Mess-CSV tragen); ernte-20260812-nacht7c (1.3G) ist BU-additiv, NIE loeschen. Hinweise Neuanlauf: P4/P5-Erbinnen = planner/planner_version.hpp + builder/ceb_version_stamp.hpp (Schnitt nennt nur Basenamen); P1-Zielordner include/cache_engine/abi/ existiert. Erst bauen wenn df -h >5G.
STATUS LT. QUELLE: offen (NEU ZU BAUEN)
ABHAENGIGKEIT/FLAECHE: Stempel-Strecke S-1 (Basis fuer S-7?); serialisiert gegen Strang C (profile_run_entry.hpp) und D (lint:format)

### [w71fb33yz] 4 (Betriebs-Lehren)
GEGENSTAND: Drei parallele Bau-Agenten starben am selben 529-Overloaded-Ereignis; einer davon hatte trotzdem committet (stummer Tod durch Platte 99% -- Arbeit im Workflow-Worktree gefunden). Lehren: (a) bei "Bau=null" IMMER die Workflow-Worktrees nach Branches absuchen, bevor neu gebaut wird; (b) df-h-Regel (<5G melden statt bauen) gilt vor jedem Vollbau; (c) Verify-Staffel hat die Wahrheit hergestellt, nicht die Bau-Reports.
ORT: Journal/Verify-Ergebnisse
SOLL/FIX: als Arbeitsregel in den Komplex-Fix uebernehmen.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Platten-Management prod1

## Datei woqntqdz1.json (R-1-Kartierung KON30-01: Messeinrichtungen je Traeger-Stufe, 32-vs-6-Aufloesung; 3 Agenten, Schnitt 2 fiel aus [StructuredOutput retry cap], Synthese nur aus Schnitt 1)

### [woqntqdz1] 1
GEGENSTAND: ZWEI einander unbekannte Mess-Architekturen: System A (LIVE: #ifdef-Gates in anatomy/abi_adapter.hpp via mess_achsen_naht.hpp) vs. System B (DORMANT: mess::Konfiguration<Is...> + CheckpointMeasure/SteuerDock, 0 Produktions-Aufrufer, 17 Dateien; nur test_ck1_messkette_koeder.cpp + ck1_naht_koerper.hpp). Karte: Wallclock/G1 im Tier (30x Gate; Pflicht-Wurf :476-491, nie abwaehlbar; CI setzt Combo NIRGENDS -- "leer == [all] == Vollmenge"); Macro/G2 + Micro/G3 teilen sich EIN Gate COMDARE_CE_ENABLE_STATISTICS ("EHRLICHE GRENZE" naht:106-124, nicht einzeln schaltbar; COMDARE_MEASUREMENT_TOOLING_MICRO=1 existiert OHNE Leser); PMC in CEB/Host (aktiv in CI, aber ohne Vendor = Uebergangszustand WARNING); Hybrid-Micro/Macro NUR Platzhalter (naht:159-160), GAR NICHT GEBAUT. XML <measurement_tooling> in 7 Profilen geparst, aber Plan-Director konsumiert es NICHT (=> 1 Voll-Konfig [all]).
ORT: ce anatomy/abi_adapter.hpp:591-2072; mess_achsen_naht.hpp; steuer_dock.hpp:229-241; konfiguration.hpp:106-130; super/.gitlab-ci.yml:1908/:2092
SOLL/FIX: s. Eintrag 3 (B1-B5).
STATUS LT. QUELLE: kartiert; Bau offen
ABHAENGIGKEIT/FLAECHE: Memory-Eintrag "ZWEI MESS-ARCHITEKTUREN" (KON34) deckt sich

### [woqntqdz1] 2
GEGENSTAND: 32-vs-6-AUFLOESUNG: die 6 (static_assert anzahl==6) zaehlt 3! REIHENFOLGEN der EINEN ortsfesten Kette Konfiguration<Wallclock,Makro,Mikro>; die 32 (KON25-03) zaehlt BELEGUNGEN von 5 unabhaengigen Schaltern (Tier Micro+Macro, Hybrid Micro+Macro, CEB Wallclock) = 2^5. Da die Instrumente NICHT an einem Ort wohnen (Wallclock->CEB, Micro/Macro->Tier, eigene->Hybrid; PMC schon heute CEB/Host), faellt die Voraussetzung der 6er-Zaehlung: Ordnungs- wird zur Auswahlfrage. 6 und 32 sind Antworten auf verschiedene Fragen; im [all]-Betrieb sehen beide Modelle gleich aus (deshalb blieb der Widerspruch unsichtbar). OFFENE GRENZEN: (a) Owner-Haken fehlt (Ledger fuehrt "32 Docks = 32 Mess-System-Permutationen" als Beobachtung, keine Festlegung; E-F3b laeuft); (b) Reihenfolge INNERHALB einer Stufe als Mess-Gegenstand unentschieden (selbe Frage wie Hybrid "4! = 24 oder 48"); (c) "gerade Anzahl"-Invariante = letzter offener F11-Teil (KON28-03); (d) 17-vs-18-Dateizaehlung des Doppelbaus unaufgeklaert.
ORT: steuer_dock.hpp:229-241; KON25-03/KON28-03
SOLL/FIX: Herleitung dem Owner zur Bestaetigung vorlegen (Haken fehlt).
STATUS LT. QUELLE: hergeleitet, Owner-Haken offen
ABHAENGIGKEIT/FLAECHE: E-F3b; F11-Rest; Hybrid-Rekombinations-Frage

### [woqntqdz1] 3
GEGENSTAND: BAU-PAKETE aus der Kartierung: B1 XML-Konsum (Plan-Director konsumiert <measurement_tooling> end-zu-end; Element um STUFEN-Dimension erweitern [heute nur tools, nicht tier/hybrid/ceb]; Dock-Anzahl dynamisch, Obergrenze 32; KEINE YAML -- Planer emittiert Prozess ueber zentrales Baumodul); B2 Gate-Trennung G2/G3 (eigenes Micro-Gate; COMDARE_MEASUREMENT_TOOLING_MACRO/MICRO=1 bekommen Leser; ohne B2 ist "Tier je an/aus" unerfuellbar); B3 Hybrid-Gates (von Platzhalter zu echt; vorher nur 2^3=8 Belegungen adressierbar; Wallclock-Umzug Tier->CEB hebt Pflicht-Wurf auf CEB-Ebene; Umbauten heute kostenlos, ab 26.08. teuer -- vor F2 ordnen); B4 System B umstellen+anschliessen (static_assert anzahl==6 faellt zugunsten Belegungs-Zaehlung <=32; Instanziierung durch den Builder = fehlender Baustein "Steuerung -> Compile"); B5 Stempel-Pflicht (jeder neue Stufen-Schalter durch die EINE Aufloesung resolve_live_measurement_combo_legend ins Tier-Preimage-Glied [3]; CEB-Vorbild pmc-Vendor-Glied ceb_version_stamp.hpp:268-334; Aenderung ohne X.Y.Z-Bump = schneller UND falsch). --debug streng disjunkt (wirkt auf Auspraegung, nie Umleitung; Kette faehrt per KON28-01 bis Abgabe mit --debug -> Mess-Schaltung MUSS davon unabhaengig bleiben; Debug verifiziert Schalter, bewertet nicht).
ORT: s. Eintrag 1
SOLL/FIX: B1-B5 bauen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: F2-Frist 26.08.; Selbstkompilation-Baustein "Steuerung -> Compile" (Memory); Bump-Pflicht/S-14

### [woqntqdz1] 4
GEGENSTAND: Ausfall Schnitt 2 (soll-und-ordnung): Agent erreichte StructuredOutput retry cap (5) -- 269k Tokens Arbeit ohne verwertbaren Output; letzte Zwischenmeldung: "Die Zuordnung driftet chronologisch. Der heute gebau..." -- Synthese lag Schnitt 2 NICHT vor.
ORT: Workflow-Journal
SOLL/FIX: SOLL-Chronologie-Schnitt ggf. nacherheben, falls die Synthese-Herleitung angefochten wird.
STATUS LT. QUELLE: Ausfall (Teil-Scope unbelegt)
ABHAENGIGKEIT/FLAECHE: Eintrag 2 (Owner-Haken)

## Datei wzkd6pl5h.json (Pflicht-Fixup S-14a-Riegel: zwei Verify-Luecken geschlossen; 1 Fable-Agent; Worktree /home/comdare/wt-ce-golden-s14a, Branch bau/golden-s14a-riegel)

### [wzkd6pl5h] 1
GEGENSTAND: Zwei Fix-Commits auf bau/golden-s14a-riegel: 3cba6ade (organ-Discovery fail-closed -- unlesbarer Neuzugang macht ROT statt still zu verschwinden; vorher: --check exit=0 GRUEN 158 und --write liess die Datei still aus dem Register fallen; Koeder F rot-zuerst + F2-Bestands-Pin) und 8257e517 (Lock-Parser streng: Zusatz-Token/Nicht-Hex-Digest [auch UPPERCASE]/Doppel-Record = ROT; Koeder G1-G4 rot-zuerst; G3 vorher exit=1 mit IRREFUEHRENDER Diagnose ueber die Datei statt des Registers). Golden Baseline unberuehrt (--check echt vor+nach = GRUEN 158, Lock-Diff 0). KON55-Kombibau 4/4 (gcc/clang x Debug/Release, je volle J-Kette, 486/486 Tests, s14-Tripwire #169 je Kombo Passed, jetzt 22 Tool-Laeufe Koeder A-G). LANDEFAEHIG=JA, Push/Merge NICHT Teil des Auftrags (Tip 8257e517, lokal gruen).
ORT: /home/comdare/wt-ce-golden-s14a tools/axis_version_lock/; tests/unit/test_s14_axis_version_lock_tripwire.cpp
SOLL/FIX: CI-Verifikation nach Push steht aus; Landung des Branches offen.
STATUS LT. QUELLE: behoben@3cba6ade+8257e517; Landung offen
ABHAENGIGKEIT/FLAECHE: entspricht wfr31gpjz-Vorbefunden (Parser-Strenge); Dedup: die wfr31gpjz-ERNST-Funde 1-4 (Substring-Discovery, Bump-Veraltung, Traeger-Austritt, heuristik-Koeder) sind durch DIESE zwei Commits NICHT abgedeckt -- Designer pruefen, welcher Stand juenger ist

### [wzkd6pl5h] 2
GEGENSTAND: Offene Punkte des Fixups: (a) Befund-Korrektur: 'in BEIDEN discover()' traf nur Organ-Zweig; HeuristikDetail liest keine Bytes, dort lag NIE fail-open (per Koeder F2 als Pin eingefroren); (b) Kategorie-Spalte des Locks beim Check weiterhin NICHT gegen IST-Kategorie abgeglichen (totes Datum, gemeldet, nicht behoben -- deckt sich mit wfr31gpjz Fund 7); (c) Koeder F setzt POSIX chmod 000 voraus (root/CAP_DAC_OVERRIDE -> Test scheitert LAUT; _WIN32 benannt uebersprungen); (d) zwei vorbestehende Fremd-Warnungen im Vollbau (gcc-15 -Wstringop-overflow false-positive stl_algobase via test_v41; clang-22 -Wcharacter-conversion in vendored gtest-printers.h); (e) Kommentar '~14 Tool-Laeufe' in tests/unit/CMakeLists.txt:1948 veraltet (jetzt 22) -- Kommentar-Kosmetik fuer spaeteren Strang.
ORT: s.o.
SOLL/FIX: (b) als offener Riegel-Punkt; (d)/(e) Aufraeum-Posten.
STATUS LT. QUELLE: offen (gemeldet)
ABHAENGIGKEIT/FLAECHE: Warnungs-Review-Doktrin

## Datei wp3t5aa4z.json (numa-Gap-Fixes a73fecbe: Bau+Test+adversarialer Review vor Landung; 2 Agenten; Worktree /home/comdare/wt-numa-luecken, Branch b-numa-luecken-schliessen)

### [wp3t5aa4z] 1
GEGENSTAND: Die drei OD-11-Review-Luecken (L-1 CoreTopologySource-Provenienz [= wjpdo2ukt Eintrag 8: neue Enum-Werte DarwinPerflevel/WindowsEfficiencyClass, Bestands-Nummern 0/1/2 per static_assert festgenagelt, 3/4 additiv, Token-Disjunktheit beidseitig, FK-8-konforme Count-Wache], L-2 macOS-Kopfkommentar [= wjpdo2ukt Eintrag 9: engere wahre Luecke benannt, Alt-Text als markierte Deprecation], L-3 L3-Kreuz-Disjunktheit [= wjpdo2ukt Eintrag 10: Test-Input {98304K,{0,1}},{65536K,{1,2}} gegen Eltern b1753926 AKZEPTIERT/gegen a73fecbe ABGELEHNT QuelleKorrupt -- echter ROT->GRUEN-Bissbeweis durch Ausfuehrung]) sind durch Commit a73fecbe GESCHLOSSEN; Merge f138ec41 = development 54106bc9 + numa-Paket + Gap-Fixes; Build gruen (gcc 15.3.0, 25/25 Tests, 0 DISABLED/SKIPPED), keine Regressionen (target_isa_sub_axes-Labelliste byte-identisch, factory nur static_assert-Reflows); landebereit=True im Sinne der drei Review-Gates.
ORT: /home/comdare/wt-numa-luecken; Commits a73fecbe (Fix), f138ec41 (Merge), b1753926 (Eltern)
SOLL/FIX: Im Commit selbst benannter Vorbehalt bleibt: VOLLER BAU + DUAL-REVIEW vor Landung als Prozess-Schritt. Provenienz-Achtung: f138ec41 ist der Merge NACH a73fecbe, wahrer Vor-Zustand ist b1753926.
STATUS LT. QUELLE: behoben@a73fecbe; Landung offen (Voll-Bau + Dual-Review ausstehend)
ABHAENGIGKEIT/FLAECHE: Dedup zu wjpdo2ukt 8-10 (dort als offen gefuehrt -- HIER geschlossen; Luecke 4 WARN-familienabhaengig [wjpdo2ukt 11] wird in diesem Workflow NICHT erwaehnt -- Designer pruefen ob offen!); Landekette numa-Paket (w1pdr52b0 V-1)

## Datei w6m5i2vnw.json (T2-A Zaehler-Resume + K2/H1/H2 Neuanker P0; 1 Opus-Agent; AUSFALL)

### [w6m5i2vnw] 1
GEGENSTAND: Bau-Welle T2-A (Zaehler-Resume + K2/H1/H2, Neuanker-Fingerprint-Format-3, P0 = kritischer Pfad vor dem Voll-Bau-Trigger) in Worktree /home/comdare/wt-b2-neuanker (Branch b2-neuanker-format3): Agent starb nach 278k Tokens / 109 Tool-Calls am Spend-Limit ("You've hit your monthly spend limit"); result/bau = null. Letzte Aktion: /tmp/t2a-gate gate.sh t2a-k2 61a95bae -- moeglicherweise Teilarbeit im Worktree/Branch vorhanden (Muster w71fb33yz: bei "Bau=null" IMMER Worktree/Branch absuchen).
ORT: /home/comdare/wt-b2-neuanker, Branch b2-neuanker-format3
SOLL/FIX: Verbleib pruefen (git -C wt-b2-neuanker status/log; /tmp/t2a-gate); T2-A-Scope ggf. neu bauen. Hinweis: w1pdr52b0 fuehrt wf_fd7950a4 -> wf_6069f4fc "T2-A gelandet" als Nachfolge -- Designer muss klaeren, ob DIESE Welle die ersetzte oder eine spaetere ist.
STATUS LT. QUELLE: Ausfall; Verbleib unklar
ABHAENGIGKEIT/FLAECHE: Neuanker/Fingerprint-Format-3 (P0 kritischer Pfad)

## BILANZ LESER 8
Dateien gelesen: 13 von 13 (Batch i % 12 == 7 aus 152 Listeneintraegen).
Extraktions-Eintraege: 200.
Groesste Quellen: w1buo8hac (Gesamtbild 08.08., 126 Eintraege), wjpdo2ukt (OD-11 numa_process_probe, 16), wo0oghvqu (golden/S-14a/MinIO/#22, 8).
Querverweise fuer den Designer (Dedup-Hinweise):
- OD-11-Kette: wjpdo2ukt (Bau b4cebdc4 + 4 Luecken) -> w1pdr52b0 (V-1/V-3 Sicherungslage 07.08.) -> wp3t5aa4z (L-1..L-3 geschlossen@a73fecbe; Luecke 4 WARN-familienabhaengig dort NICHT erwaehnt) -- Landestatus am 13./14.08. verifizieren.
- S-14a-Kette: wo0oghvqu (Explore golden+S-14a) -> wfr31gpjz (Review des gebauten Riegels, 4x ERNST + 3x HINWEIS) -> wzkd6pl5h (Fixup 2 Luecken@3cba6ade+8257e517) -- die wfr31gpjz-ERNST-Funde 1-4 sind vom Fixup NICHT abgedeckt.
- F1-Kette: w83v9wfv4 (##25 Durchstich BLOCKIERT durch Stempel-Befund; Commits ac2afddd/8c611825/516c05a0 ungelandet) -> w71fb33yz (Strang C = Fix-Strang, Bau 529-tot, NEU ZU BAUEN; Strang D d61c10d0 landefaehig aus wf_d826aca8-6ce-8; Strang A NEU ZU BAUEN) -> wfjg4a9k0 (texlive-gate bau/texlive-gate-haertung ahead 4, landereif).
- Stand-Vorsicht: w1buo8hac (08.08.) und w1pdr52b0 (07.08.) enthalten viele inzwischen ueberholte Posten (eigene Entlastungslisten beachten); w8zswfsku Stand 06./07.08.
Selbstcheck: Datei ASCII-only geprueft (grep -P '[^\x00-\x7F]' = 0 Treffer), 200 Eintraege im Format GEGENSTAND/ORT/SOLL-FIX/STATUS/ABHAENGIGKEIT, keine Platzhalter, alle 13 Batch-Dateien vollstaendig gelesen (flat-Renderings unter komplexfix_design_arbeit/pp/).
