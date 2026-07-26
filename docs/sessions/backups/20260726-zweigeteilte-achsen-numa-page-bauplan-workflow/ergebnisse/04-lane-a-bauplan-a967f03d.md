LANE-A BAUPLAN (SYS-TAX + OWNER-KERN Dual-Natur), bindend, ASCII-only (nur § nicht-ASCII)
Vorbedingung: ORG-18/B-15 gejoint; Lane F HOLD; Impl-G4b (d2) laeuft ausserhalb der Sperrmenge.

== (1) ARBEITSPAKETE IN BINDENDER REIHENFOLGE ==

A1 TYP-FUNDAMENT (Blocker fuer alles)
 Ziel: Schicht-Taxonomie tragfaehig machen: AxisKind um system_meta_meta, NEU CebSubAxis mit
 parent_axis() als TYP (offene Rekursion, Q-D: NICHT auf System-Haupt asserten).
 Dateien: topics/axis.hpp:17-21 (enum, heute 3 Werte) - MEAS/ceb_system_axis.hpp:32-37 (Concept)
 - NEU MEAS/ceb_sub_axis.hpp.
 Gates gruen: test_m_contract_system_axis_wurzel (tests/unit/CMakeLists.txt:3461); ce-all + explizit
 comdare_profile_run_facade (Handover:80).  Byte-neutral: JA (keine Stempel-/Suffix-Beruehrung).
 Sperrmenge: MEAS/ceb_system_axis.hpp, topics/axis.hpp - exklusiv, 1 Agent.

A2 KOMPLEX-WRAPPER + R-D UNTER-ACHSEN-GRUPPE
 Ziel: generischer rekursiver CompoundSystemAxis (kein hartkodiertes Label) + SubAxisGroup
 <compiler,opt_level,atomic128>; compiler verliert Haupt-Status.
 Dateien: NEU MEAS/ceb_complex_system_axis.hpp - 4 parent-Label-static_asserts umhaengen:
 validate_profile.hpp:421-422, :971-972, compiler_atomic_sub_axis.hpp:98,
 optimization_level_sub_axis.hpp:145 (NICHT streichen -> sonst GN-1-Verwaisung wie in
 extension_hardware_family_axis.hpp:1-22 beschrieben).
 Gates: dieselben wie A1 + validate_profile-Unit-Tests.  Byte-neutral: JA.
 Sperrmenge: validate_profile.hpp (kollidiert mit A5!), MEAS/compiler*/optimization*.

A3 R-A/R-B/R-C/R-E/R-F ACHSEN-NEUORDNUNG
 Ziel: OS als 4. Komplex-Glied, scheduling unter target_isa, load_framework = 1. Meta-Meta,
 ext_hw -> external_utils = Meta-Meta-Hub, SIMD/AVX als Meta-Metas darunter.
 Dateien: NEU MEAS/operating_system_system_axis.hpp + 4 statische Unter-Achsen (os_version/
 kernel/build inkl. Update-Zustand) - MEAS/scheduling_system_axis.hpp:58-62 -
 MEAS/load_framework_system_axis.hpp:29 (sub_axis_label()=="workload" UNANGETASTET, Single-Source
 cache_engine_builder_iterator.hpp:789-793) - MEAS/extension_hardware_family_axis.hpp.
 Gates: A1-Gates; test_ap5_simd_extension_coherence (CMakeLists:3098);
 test_m_simd_feature_flag_catalog (:3481).  Byte-neutral: JA (XML erst in A8).
 Sperrmenge: MEAS/*_system_axis.hpp gesamt - seriell nach A2, gleicher Agent.

A4 OWNER-KERN: NUMA + page_type ALS RT-UNTER-ACHSEN UNTER target_isa  [PARALLEL-FAEHIG]
 Ziel: die vom Owner benannte Freigabe-Haelfte herstellen - numa/page_type werden an der CEB
 waehlbar und je Architektur freigegeben, bevor ein Tier-Binary sie CT-statisch einfriert.
 Dateien: NEU MEAS/numa_sub_axis.hpp + MEAS/page_type_sub_axis.hpp (exakte Spiegel von
 simd_sub_axis.hpp:38/:69-88, parent_axis_label()=="target_isa"; Default byte-neutral wie
 SimdNoExtOption:69-74) - Host-Praedikate nach Muster profile_run_entry.hpp:209-217 - D1-Fehlerfall
 nach Muster :759-763. HINWEIS: Traeger ist KEIN -march (page = -D-Makro, numa = Bind-Parameter).
 OFFEN, literal zu pruefen: Fehlerklasse fuer "hugetlbfs/Kernel nicht konfiguriert" in
 MEAS/axis_error.hpp - ich habe dort keine passende Klasse verifiziert und behaupte keine.
 Gates: A1-Gates.  Byte-neutral: JA (nur neue Dateien, kein Aufrufer).
 Sperrmenge: keine (nur Neu-Dateien) -> 2. Agent, ab A1 fertig.

A5 CT-DRAHT + INTERFACE-BRUCH (Bruch zuerst, dann Draht)
 Ziel: die Freigabe erreicht den Bau: CompileFn-Fabrik von (opt_flag, march_flag) auf ein
 Flag-Buendel weiten und numa/page aus der CEB-Freigabe statt aus dem Profil beziehen.
 Dateien: profile_run_entry.hpp:83 + :741-786 - experiment_run_entry.hpp:56 + :259-296 (BEIDE
 Pfade synchron, sonst Divergenz) - profile_run_facade.cpp:522-541 + :999-1016 -
 axes/alloc/alloc_hw_config.hpp:48-52 (if-constexpr-Gate :89-93 bleibt = §37-Durchsetzung) -
 builder/experiment_tree/profile_to_tree.hpp:81-87 (Organ-Level -> System-Pfad, Guard :88-95) -
 validate_profile.hpp:206-209 + :776 (alloc_hw-Bypass entfernen).
 Gates: test_lazy_adhoc_source_gen (CRC64-Anker, :190-202), 320er-Byte-Wache
 (CMakeLists:2649-2650), test_buildvariant_dll (:3016), test_adhoc_buildvariant_dll (:3188).
 PFLICHT-BEWEIS P-1 vor Merge: literal belegen, dass KEIN golden-/320er-Profil alloc_hw-Level
 aktiviert (sonst verlassen Segmente die binary_id -> CRC-Bruch). Byte-neutral: JA nur mit P-1.
 Sperrmenge: profile_run_entry/experiment_run_entry/profile_run_facade/profile_to_tree/
 validate_profile - kollidiert mit A2 und Lane F -> STRENG SERIELL.

A6 ORDNUNGS-SINGLE-SOURCE kSystemAxisOrder (A-II)  [NICHT byte-neutral]
 Ziel: EINE constexpr Kette (Mess-Tooling -> target_isa -> operating_system -> external_utils ->
 Organ) als Quelle fuer Stempel, Suffix, Generator, Levels.
 Dateien: NEU abi/system_axis_order.hpp - abi/system_axis_code_versions.hpp:28 (kSystemAxisCodeCount
 = 5 -> N, static_assert :50-51) + Tabelle :32-38 - abi/anatomy_version_stamp.hpp:71-79
 (system_stamp_line iteriert die neue Ordnung).
 BYTE-FOLGE: system_stamp_line() geht in JEDE generierte Tier-Quelle
 (lazy_adhoc_source_gen.hpp:201) -> die Stempel-ZEILE aendert sich fuer alle Binaries. Die 320er-
 Wache ist ueber binary_ids (CMakeLists:2649), nicht ueber Stempel-Bytes -> sie haelt; der
 Katalog/Lazy-Round-Trip haelt, weil BEIDE Pfade denselben Helfer nutzen (:197-201).
 Gates: test_m_w12_stamp_bausteine (:3501), test_g1_binary_version_stamp (:3521).
 Sperrmenge: abi/* exklusiv; blockiert Lane F vollstaendig.

A7 STEMPEL A-III: KLAMMER-HIERARCHIE EBENE 0-3 + ABI-ARRAY
 Ziel: je-Achsen-Typ-Gliederung mit EINEM gemeinsamen Komplex-Stempel (indirekte Identitaet),
 Unter-Achsen-Klammerung NICHT im Binary (nur xlsx-Metainfo, S2:11-13).
 Dateien: abi/anatomy_module_abi_v1_decl.hpp:188-193 (system_entries = Paar -> nur count/Inhalt
 waechst; kAnatomyVersionLinesLayout=5 :206 BLEIBT) - plan_legend.hpp:102/:20/:144 (Legende [d,e,f]).
 Gates: §57/§58 strukturell - [g,h,i] (17 Organ) unberuehrt, KEIN Uebertritt zwischen Arrays;
 test_m_w12_stamp_bausteine, test_g1_binary_version_stamp.  Byte-neutral: NEIN (mit A6 EIN Commit).
 Sperrmenge: abi/* (mit A6 verschmolzen ausfuehren).

A8 GENERATOR + XML-REGENERAT (A-III)
 Ziel: der Generator produziert die neue Ordnung statt 5 handgeschriebener Bloecke.
 Dateien: tools/system_axis_registry_gen/main.cpp (Bloecke ab :165 compiler, :216
 extension_hardware, weiter target_isa/scheduling/load_framework; Kopf-Literale :155-161, Ende
 :334) -> Iteration ueber kSystemAxisOrder + NEU OS-Block + scheduling als sub_axis unter
 target_isa + numa/page_type sub_axis + external_utils-Rename; danach
 MEAS/system_axis_registry.xml regenerieren (heute :53-71 ext_hw, :98-100 target_isa OHNE
 sub_axis, :102-112 scheduling, :114-116 load_framework).
 Gates: read_axis_registry-Pfad in validate_profile.hpp:188-191; test_axis_registry_roundtrip
 (super-Baum-Byte-Drift = bekannter STRUKT-R-Befund, Handover:81-82 - darf NICHT schlechter werden).
 Byte-neutral: NEIN fuer die XML (gewollt), JA fuer binary_id.  Sperrmenge: tools/ + Registry-XML.

A9 SYSTEM-LEVEL-SCHICHT + SIDECAR + TEST-ANKER
 Ziel: numa als gefuehrte System-Achse sichtbar machen und den Rebuild-Gate-Wert mitfuehren.
 Dateien: builder/experiment_tree/registry_to_axis_levels.hpp:117-121 (5 -> N; page_type steht
 dort BEREITS :117) - tests/unit/test_br1_full22_count.cpp:66 ("5 System-Achsen") im SELBEN Commit
 nachziehen, H-10-Telemetrie-Zusicherung :69-71 erhalten - builder/build_variant_definition.hpp:27
 (hw_numa_capable = Faehigkeit -> GEWAEHLTER Wert), kBuildVariantDefinitionVersion-Bump +
 build_variant_sidecar.hpp:38-56/:65/:92.
 Gates: test_g2_variant_sidecar (:3974), test_buildvariant_dll(_real) (:3016/:3084),
 test_d13_dll_runtime_measure (:3201).  Byte-neutral: JA fuer binary_id; Sidecar-Bruch bewusst.
 Sperrmenge: registry_to_axis_levels/build_variant* + test_br1.

A10 GATE-BAUSTEINE numa/page (INERT)  [PARALLEL-FAEHIG]
 Ziel: das Freigabe-Trio je Achse spiegeln, ohne es scharf zu schalten.
 Dateien: NEU numa/page_organ_requirement + _sensibility (Muster simd_organ_requirement.hpp:40-50
 mit static_assert :88, simd_organ_sensibility.hpp:31-39) + ZWEITES Dock (pruef_dock
 simd_build_gate.hpp:102-147 ist auf SimdFeatureFlag/SimdRoute typisiert; State-Enum :43-48
 wiederverwenden). Hooks bleiben leer -> NotApplicable, null Zusatz-Flags (wie :185-187 heute).
 Gates: A1-Gates.  Byte-neutral: JA.  Sperrmenge: keine (Neu-Dateien).
 SELBST ENTSCHIEDEN: zweites Dock statt Generalisierung (kleinerer Bruch); admit_organ_on_machine
 (:153-159, heute toter Code) bleibt unverdrahtet bis nach dem Trigger.

A-IV PARSER/PODs/XSD: DEFERRED nach Voll-Bau-4 (SELBST ENTSCHIEDEN, Begruendung: nur noetig, wenn
 Profile OS-/scheduling-/numa-WERTE deklarieren; Default-Weglassbarkeit macht den Voll-Bau
 vollstaendig beschreibbar - Bauplan-a67e501b:260).

== (2) GOLDEN-NEUANKER ==
KEINER in Lane A. Der EINE Neuanker ist bereits vollzogen (ORG-18, 2026-07-26):
source_catalog.hpp:189 kNewGolden131072Crc64 = 0x56F1B721C72DC10E, Werkzeug-Output belegt :185-186.
Begruendung: binary_id = ausschliesslich kCompositionAxisNames (18 Namen,
axis_path_serialization.hpp:40-43); numa/page_type/scheduling/OS stehen nicht darin, und der Guard
profile_to_tree.hpp:32-36 + :96 ueberspringt jede Nicht-Komposition-Achse. Praezedenz zweifach:
telemetry (ABI-5) und isa (ABI-6) haben die Komposition VERLASSEN, als sie System-Achsen wurden -
obwohl das isa-Organ CT-statisch im Tier bleibt (registry_to_axis_levels.hpp:113-116). Damit bleibt
FullSourceCatalog (source_catalog.hpp:139) und der static_assert ==131072 (:169-170) unveraendert.
BYTE-NEUTRAL: A1, A2, A3, A4, A5 (unter Beweis P-1), A9 (binary_id-seitig), A10.
NICHT byte-neutral, EIN gemeinsames Bruch-Fenster: A6+A7 (Stempel-Zeile in jeder Tier-Quelle) und
A8 (Registry-XML). GEFAHR, die A6 mittragen MUSS: Quelltext-Stempel aendert sich, aber
dll_is_current (build_orchestrator.hpp:473) prueft nur build_version -> ohne Lane-F-Suffix oder
Voll-Bau-4 bleiben Alt-Binaries mit Alt-Stempel stehen (stale). Deshalb A6/A7 -> Lane F -> Trigger
als eine Kette. Default-Stille als Regel (SELBST ENTSCHIEDEN, Muster +target= profile_run_facade.cpp
:389-391): +numa=/+page= nur emittieren, wenn der Wert vom Default abweicht.

== (3) PARALLEL vs SERIELL ==
SERIELLE KETTE (Agent 1, kritischer Pfad): A1 -> A2 -> A3 -> A5 -> A6+A7 (ein Commit) -> A8 -> A9.
Grund: A2/A5 kollidieren in validate_profile.hpp; A6/A7 teilen abi/*; A8 braucht kSystemAxisOrder;
A9 braucht die Registry aus A8.
PARALLEL ab A1-Merge (Agent 2): A4 (nur neue Header) und A10 (nur neue Header) - null Ueberlappung
mit der Sperrmenge, Verdrahtung erfolgt erst in A5 bzw. nach dem Trigger.
PARALLEL ab A3-Merge (Agent 3, optional): Test-Anker/Doku-Nachzug fuer test_br1_full22_count.cpp
und plan_legend-Legenden-Text, aber Commit erst NACH A9 (gleiche Datei).
NICHT parallelisierbar: alles was profile_run_entry/experiment_run_entry/profile_run_facade
beruehrt - dort liegen 4 gespiegelte Naht-Stellen, jede Divergenz ist ein Mess-Defekt.

== (4) LANE F (W-13) EINORDNUNG ==
Lane F laeuft STRENG SERIELL nach A6/A7/A8 und nach Impl-G4b-1 (Handover:64-66): sie konsumiert
kSystemAxisOrder als Single-Source der Suffix-Ordnung, setzt +ceb als LETZTES Segment und fasst
Suffix + cache_key_prefix in EINEN Commit (Atomaritaet). Reihenfolge innerhalb F unveraendert:
T-c-Golden-String-Wache ZUERST, dann Umordnung. Heute existiert die Ordnung dreifach divergent
(system_axes_version_suffix profile_run_facade.cpp:371-401 mit +ext+cxx[+target][+tel] gegen die
Perm-Reihenfolge :1082/:1096 und die Kommentare :448-449) - genau diese Divergenz darf Lane A NICHT
selbst anfassen, sonst kollidieren A6 und F in derselben Funktion. Lane C (IDENT/external_utils-Hub-
Scharfschaltung) bleibt inert bis nach dem Trigger.

== (5) OWNER-BLOCKER VOR BAUBEGINN (echte Blocker, 5) ==
B1 numa/page_type UND die binary_id: heute erzeugen alloc_hw.numa_node/page STATISCHE ORGAN-Level
 (profile_to_tree.hpp:81-87), sind also binary_id-tragend, sobald ein Profil sie aktiviert. Meine
 Empfehlung nach §54-T3: raus aus der binary_id, Freigabe in den +ext=/+target=-Sidecar, Organ-
 Durchsetzung bleibt als if-constexpr-Gate (alloc_hw_config.hpp:89-93). BESTAETIGUNG NOETIG, weil
 damit alte Profile ihre numa/page-Permutation als binary_id-Segment verlieren.
B2 KANONISCHE ZAHL DER SYSTEM-HAUPT-ACHSEN im Stempel: aus S2:11-13 (Unter-Achsen-Klammerung nicht
 im Binary) folgt, dass compiler/opt_level/atomic128/scheduling/simd/load_framework aus der
 System-Stempel-Zeile VERSCHWINDEN und nur target_isa/operating_system/external_utils (+1 Komplex-
 Klammer) bleiben - das ist ein Sprung von kSystemAxisCodeCount=5
 (system_axis_code_versions.hpp:28, Tabelle :32-38) auf 3+1. Zahl und Klammer-Form muessen fix
 sein, bevor A6 startet; sie bestimmen die Stempel-Bytes JEDER Tier-Quelle.
B3 telemetry: Q-13 sagt Mess-Tooling-Unterachse des Planers, aber build_system_axis_levels fuehrt
 telemetry als System-Achse und test_br1_full22_count.cpp:69-71 macht daraus ein hartes
 Provenienz-Gate (+tel=silent, profile_run_facade.cpp:401). Empfehlung: telemetry bleibt in diesem
 Fenster als System-Level gefuehrt (Provenienz-Sicherung), Umzug erst nach dem Trigger.
B4 BRUCH-FENSTER-FREIGABE: Lane A (A6/A7/A8) + Lane F erzeugen neue Stempel/Suffixe -> alle
 vorhandenen Tier-Binaries sind stale und werden im Voll-Bau-4 neu gebaut; Alt-Mess-Reihen bleiben
 als Archiv byte-unveraendert, sind aber nicht suffix-anschlussfaehig. GO auf genau dieses eine
 Fenster (statt zwei Voll-Baeuten) benoetigt.
B5 MESS-RAUM von numa/page_type: welche Auspraegungen permutiert werden (numa: auto|node0|
 interleave; page: native|4k|2m) - jede zusaetzliche Auspraegung multipliziert die CEB-Zahl im
 Voll-Bau-4. Empfehlung: in diesem Fenster nur Default aktiv (uebrige Auspraegungen deklariert,
 enabled=false), damit die Bau-Kosten des Triggers unveraendert bleiben.

SELBSTCHECK: grep -P '[^\x00-\x7F]' ueber diesen Text = nur '§'; keine Gedankenstriche/Kaestchen;
jede Behauptung mit datei:zeile bzw. Session/Handover-Zeile belegt; die eine unbelegte Stelle
(Fehlerklasse hugetlb in MEAS/axis_error.hpp) ist in A4 ausdruecklich als ungeprueft markiert.
