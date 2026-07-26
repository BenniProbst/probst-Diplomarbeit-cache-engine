# 20260726-lane-a-grundlagen-workflow / lane-bauplaene (agent ae03eeee)

runId: wf_17636316-4e6
agentId: ae03eeee9535a532b
label-Zuordnung: lane-bauplaene (Prompt-Marker-Deckung 25%)

---

ASCII-REPORT STRUKT-R BAUPLAN (Lane A / C / F) + OWNER-KORREKTUREN + RISIKO
Gelesen VOLLSTAENDIG: backups/20260726-strukt-r-planung-workflow/ (journal-final.jsonl = 4 started/4 result,
inhaltsgleich mit ergebnisse/) + ergebnisse/{00-bauplan-a67e501b, 01-system-welt-a51c70a7,
02-organ-18-welt-abb62d96, 03-modus-suffix-welt-a288b88b}.md
Ergaenzend: backups/20260726-layer-modell-erhebung-workflow/ergebnisse/{00-layer-modell-a728ca2b,
03-plandocs-architektur-a992ad07}.md + docs/sessions/20260726-SESSION-layer-modell-antworten-QA-QF-stempel-doktrin.md
+ Memories project_achsen_neuordnung_* / project_bestandslog_abnahmen_*.
CE/ = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine
SUP/ = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine

== (a) LANE A "SYS-TAX" IM DETAIL (Bauplan Sec.3, 32-36 Ah, EINZIGER kritischer Pfad-Lane in P0) ==
VERTRAGS-SYNC (0,5 Ah, VOR P0, Integrator+A+C; Gate: ohne V3 darf A-II nicht starten):
 V1 ext_hw-HUB-API (A emittiert dagegen, C implementiert) - ALT: span<MetaMetaDescriptor const> meta_metas()
    + constexpr subsumes(A,B); V2 Ordnungs-Single-Source (Datei/Name/Form kSystemAxisOrder) friert A ein,
    B/E/G konsumieren read-only; V3 Stempel-End-Form (war Owner-Frage Q-3).
Arbeitspakete in Reihenfolge (Ah):
 A-I.1 Schicht-Taxonomie (Riss 1, BLOCKER) 3: topics/axis.hpp:17-21 AxisKind + system_meta_meta;
       NEU include/cache_engine/measurement/ceb_sub_axis.hpp CebSubAxis<Derived,ParentAxis> (parent_axis() als
       TYP, parent_axis_label() nur abgeleitet); ceb_system_axis.hpp:32-37 Concept um Schicht-Praedikate.
 A-I.2 R-A 3: NEU operating_system_system_axis.hpp (CRTP-Vorbild machine_simd_signature.hpp:31-48)
       + 4 Unter-Achsen os_version/kernel/build/update_zustand (Vorbild optimization_level_sub_axis.hpp).
 A-I.3 R-B 2: scheduling_system_axis.hpp -> CebSubAxis<...,TargetIsaSystemAxis>; Form = fixed_enum_tuple (Q-7).
 A-I.4 R-D 5: NEU ceb_complex_system_axis.hpp (Command-Pattern, Vorbild builder/commands/axis_library_registry.hpp)
       CompoundSystemAxis<TargetIsa,ExtHw,MetaMetas...> + SubAxisGroup<compiler,opt_level,atomic128>;
       compiler verliert Haupt-Status; 4 static_asserts (validate_profile.hpp:421-422,971-972,
       compiler_atomic_sub_axis.hpp:98, optimization_level_sub_axis.hpp:145) auf Gruppen-Label umhaengen
       (NICHT streichen -> sonst GN-1-Verwaisung).
 A-I.5 R-C 2: load_framework -> AxisKind::system_meta_meta (1. Meta-Meta); sub_axis_label()=="workload"
       (load_framework_system_axis.hpp:29) UNANGETASTET (Single-Source cache_engine_builder_iterator.hpp:789-793).
 A-II  Ordnungs-Single-Source (Riss 2) 3: NEU abi/system_axis_order.hpp kSystemAxisOrder; Umstellung
       abi/system_axis_code_versions.hpp:28,32-38,49-50; abi/anatomy_version_stamp.hpp:64-79 iteriert neu.
 A-III Generator 4: tools/system_axis_registry_gen/main.cpp - 5 Handbloecke (:164,215,244,258,284) -> Iteration
       ueber kSystemAxisOrder, scheduling als sub_axis unter target_isa, compiler-Gruppe, OS-Block NEU,
       stdout-Literal :334; system_axis_registry.xml im SELBEN Commit regenerieren.
 A-IV  Parser/PODs/XSD (Riss 7) 4 - DEFERRABLE (nach Trigger; Q-0=V2): xml_config_parser.cpp:98-116
       3-Param-Signatur -> Gruppen-PODs + OperatingSystemAxisSel; XSD SystemAxesType xs:sequence -> xs:all.
 A-V   Validat (Riss 4) 4: validate_profile.hpp:373-448 + :929-993, RegistryTrio::system_axis_count():698,
       Resolver resolve_axis_refs_against_trio:748-799 muss Unter-Achsen-Namen mit-aufloesen (sonst kippt
       V-CATEGORY auf V-UNREG-AXIS = harter Reject bestehender Profile).
 A-VI  Test-Re-Anker 4 (siehe Gates).
 A-VII NEU profile_facade/system_version_suffix.hpp 2: reine Segment-Funktion in neuer Ordnung, jedes Segment
       weglassbar-bei-Default, NICHT verdrahtet (F verdrahtet) + unregistrierter Unit-Test.
GATES/WACHEN Lane A (bewusst gebrochen, neu ankern):
 G-A1 test_system_axis_registry_roundtrip (Byte-Diff==0; registry_roundtrip.cmake:55-66,
      tests/unit/CMakeLists.txt:3822-3831) -> XML-Regen im selben Commit ist Prozess-Auflage.
 G-A2 Stempel-BYTES test_m_w12_stamp_bausteine.cpp:105-109,261,267-269,338 literal neu.
 G-A3 5er-Zahl thesis_tiere/test_validate_profile.cpp:289 + test_experiment_plan_director.cpp:112-113,308.
 G-A4 Label-/parent-Pins test_striktheit_axis_dach_guard.cpp:70,102-103,117,120,125,138-139,153-154,166,171
      (DEPRECATED-Insel :87-88 NICHT anfassen).
 G-A5 MUSS GRUEN BLEIBEN: test_br1_full22_count.cpp:60-65 (5 System-Levels) - operating_system gehoert in die
      CebSystemAxis-Menge, NICHT in registry_to_axis_levels.hpp:113-122 (Riss 5, zwei disjunkte "5er"-Mengen).
 Datei-Disjunktheit: A beruehrt KEINE der 8 G4b-1-Sperr-Dateien; anatomy_version_stamp.hpp = Besitz A
 (B liefert Organ-Zeile :42-62 als Patch an J1); neue Test-.cpp werden von A NICHT in CMakeLists registriert
 (Integrator sammelt am Join) -> verhindert 3-Wege-Konflikt.

== (b) LANE C und LANE F ==
LANE C "IDENT-GEN + R-E-HUB" (12,5 Ah, P0 parallel, byte-neutral, INERT):
 C-1 3 Meta-Meta-Typ-Familie als variadisches Template-Pack (KEIN std::variant), Vorbild
     machine_simd_signature.hpp:30-47,79-87 (span ueber static constexpr array), Fold-Vorbild
     run_methodology_registry.hpp:130-135.
 C-2 3 Halbordnung generalisieren: admit_organ_on_machine (simd_build_gate.hpp:153-159, ist bereits T subset S)
     von SimdFeatureFlag auf Meta-Meta-Saetze heben; constexpr subsumes(A,B); Freigabe-Maximum
     S geschnitten meaningful geschnitten route (:141-146) beibehalten.
 C-3 3 R-E HUB: extension_hardware_family_axis.hpp:40-53 wird Command-Pattern-Hub (Vertrag V1);
     GN-1-static_asserts :84-93 erhalten.
 C-4 1,5 machine_signatures-Reflexion um Meta-Meta-Satz (Patch an A's Generator main.cpp:298-316, count="3").
 C-5 2 Tests neu/unregistriert; test_m_simd_feature_flag_catalog.cpp bleibt gruen (additiv).
 Dateien: include/cache_engine/measurement/{machine_simd_signature, simd_build_gate, simd_organ_requirement,
 simd_organ_sensibility, simd_feature_flag, extension_hardware_family_axis, simd_sub_axis}.hpp
 + NEU {hardware_meta_meta_axis, meta_meta_identity}.hpp; builder/bestandslog/bestandslog_document.hpp additiv.
 GATES C: (i) active_machine_signature() (simd_build_gate.hpp:187) bleibt Stub {} -> Gate inert, keine
 Flag-/Byte-Aenderung vor Voll-Bau-4 (Scharfschaltung = P2/C2', 4 Ah); (ii) +ext=<simd> byte-identisch fuer
 Ein-Familien-CPU; (iii) HARTE AUFLAGE C-3: ZellKoordinaten (bestandslog_document.hpp:147-157) nur additiv
 am ENDE mit Default-Init - test_g3_artifact_cache_transport.cpp:202 nutzt designated init {.combo,.opt,.simd}
 und ist G4b-1-gesperrt. C bricht absichtlich KEINE Wache.
LANE F "SUFFIX/KEY W-13" (12,5 Ah, SERIELL, NICHT parallelisierbar):
 Voraussetzungen (Gate): G4b-1 gemergt (Sperr-Menge frei: fingerprint_sidecar.hpp, build_orchestrator.hpp,
 fingerprint_key_source.hpp, profile_run_facade.{hpp,cpp}, profile_run_entry.hpp,
 test_g3_artifact_cache_transport.cpp, SUP/Code/02_messung_driver/main.cpp) UND A vollstaendig
 (F konsumiert system_version_suffix.hpp + kSystemAxisOrder; ohne A waere die Ordnung ein 5. Mal dupliziert).
 Umfang: A-VII als EINZIGE Quelle verdrahten; Form P (P1 profile_run_entry.hpp:754-757,
 P2 experiment_run_entry.hpp:293-297, P3 profile_run_facade.cpp:951-953 faellt weg) und Form S
 (profile_run_facade.cpp:364-400 wird duenne Resolver-Huelle) zusammenfuehren; +ceb aus cache_key_prefix
 (artifact_transport/artifact_cache.hpp:215-217) entfernen und als LETZTES Suffix-Segment falten
 (behebt Doppel-+ceb); +os/+a128/+sched/+lf weglassbar-bei-Default; SUP/.gitlab-ci.yml:877-880 GN_PREFIX
 + Fallback :896 hart fehlschlagen; Kommentar-Nachzug in den freigewordenen Sperr-Dateien.
 Ziel-Ordnung: +target < [+sched] < +os < +ext < +cxx < +opt < [+a128] < [+lf] < [+tel] < [+bt] < +ceb
 || danach nur in cache_key_prefix: +mtool < +mrg.
 GATES F: Re-Anker test_s1_cache_key_prefix.cpp:36,44,53,61,70; test_g3_prune.cpp:148,171-173,206;
 test_g1_binary_version_stamp.cpp:64,98; test_s2_pull_tier_binary.cpp:94,116,161;
 test_s5_artifact_cache_bounded.cpp:84; test_w11_async_push_pump.cpp:57,65,174,232.
 NEUE Wachen: (T-a) Perm-Suffix == Facade-Suffix; (T-b) count("+ceb=")==1; (T-c) Ordnungs-Wache.
 Remote-Folge: +ext=avx2/avx512-Objekte verwaisen, Kosten additiv NULL (ABI 6->7 invalidiert ohnehin,
 Beleg N-1), additiv liegen lassen, kein Loesch-GO.

== (c) DURCH OWNER-KORREKTUREN UEBERHOLTE PUNKTE + KORRIGIERTE FASSUNG ==
1 UEBERHOLT (Q-2): Bauplan A-I.2 baut OS als FLACHE Einzel-Haupt-Achse (Bauplan:100, kein Layer/Command).
  KORRIGIERT: OS ist Komplex-Haupt-Achse und laut Q-B Variante (i) 4. GLIED DER EINEN Komplex-Achse:
  target_isa x os x external_utils x MetaMetas. Signatur CompoundSystemAxis<TargetIsa,ExtHw,MetaMetas...>
  ist damit Regression -> Os-Parameter zwingend (loest auch D7 zugunsten von SYSWELT:139).
  Q-C: die 4 OS-Unter-Achsen bleiben ERSTMAL STATISCH/deklarativ (RT vorbereitet) -> Variante D bleibt gueltig,
  Q-2b (update_zustand) ist erledigt; Spalten-Sparregel im Writer (nie-aendernde Spalte weglassen -> Metadaten).
2 UEBERHOLT: Meta-Metas als DATEN. Vertrag V1 span<MetaMetaDescriptor const> (Bauplan:54/:163, SYSWELT:191)
  ist tot - ein Descriptor kann keine Unter-Achsen tragen, nicht CT-existenz-permutiert werden, keinen Stempel.
  KORRIGIERT: Meta-Metas = VOLLE CT-Haupt-Achsen-TYPEN mit eigenen RT-Unter-Achsen; V1 wird
  meta_metas() als variadisches Typ-Pack (Manager-Schicht 1 = Existenz an/aus CT, Schicht 2 = Werte).
  Lane-A/C-Vertrag ist neu zu schneiden (A-I.5 + C-1/C-3 betroffen).
3 UEBERHOLT (Q-D): A-I.1 CebSubAxis<Derived,ParentAxis> mit static_assert(CebSystemAxisConcept<ParentAxis>)
  + genau EIN neuer AxisKind-Wert = festes 3. Level. KORRIGIERT: Rekursion FORMAL UNBEGRENZT
  (GPU-Cluster@PCIe = Meta-Meta selbst Manager) -> Parent-Praedikat NICHT auf System-Haupt fest-asserten;
  EIN Concept fuer alle Achsen, Unter-Achse = VOLL-Achse (kann selbst Unter-Achsen tragen).
4 UEBERHOLT (Q-A/Q-E/Q-F): erfundenes Sammel-Label "build_target_complex" (SYSWELT:190, Bauplan:102).
  KORRIGIERT: generischer rekursiver WRAPPER ohne hartkodiertes Label; Identitaet NUR INDIREKT ueber die
  gewrappten Glieder (Command-Pattern), EIN gemeinsamer komplexer Stempel; Komplexbildung ist Eigenschaft
  jeder Haupt-Achse (oberste Ebene, dann rekursiv je Layer), auch Mess-/Organ-Realm zulaessig.
5 UEBERHOLT (Q-3-Nachwirkung + Stempel-Doktrin): Q-3-Optionen S1/S2/S3 gingen von 4 flachen Haupt-Zeilen aus.
  KORRIGIERT: S2 angenommen, aber als REKURSIVE Klammer-Notation zu lesen. Verbindliche Stempel-Form:
  Ebene 0 Binary-Klammer ([[d,e,f],[g,h,i]]Tier, [[a,b,c]]CEB, Mess = 3 Typ-Klammern) - Ebene 1 Typ-Klammern
  strikt getrennt - Ebene 2 Komplex-Klammer rekursiv NUR innerhalb ihrer Typ-Klammer - Ebene 3 je Haupt-Achse
  Algo@X.Y.Z. RT-Unter-Achsen NIE im Binary-Stempel (nur xlsx-Meta). ZUSATZ: Binary hat KEINE eigene Version
  (nur der Planner); SHA512-Fingerprint ueber Achsen-Strings+Versionen+Overlay-Source-Hashes als EIGENE
  Stempel-Zeile (Pre-Build-Codegen, nie zur Laufzeit) -> zusaetzliche A-II/A-VI-Arbeit, im Bauplan nicht erfasst.
6 UEBERHOLT (Q-4): Bauplan Lane D + A-I.5 + Bauplan:227 bauen CUSTOM_COMPILE als 5. (bzw. 4.) MODUS.
  KORRIGIERT: CUSTOM_COMPILE ist KEIN Modus, sondern CLI-FEATURE, das alle 4 Modi ueberschreibt.
  Es bleiben 4 Modi: Debug/Messung/Release/COMPARE (COMPARE als 4. Registry-Eintrag mitbauen).
  Folge: Lane D schrumpft auf COMPARE-Zeile + Anker (~1-1,5 Ah); Q-5 (Sentinel "Custom") und der teure
  Teil (PlanBuildSemantic 4. Feld emits_measure_job, Mess-Job-Entfall an experiment_plan_director.hpp:
  1070-1119,1475, provision_only/pruef_only-Kopplung) wandern in das CLI-Paket hinter
  SUP/Code/02_messung_driver/main.cpp:315-470,473 = seriell NACH G4b-1, nach dem Trigger (P2/D2).
7 UEBERHOLT (R-F + Q-B): simd als Unter-Achse von extension_hardware (simd_sub_axis.hpp:34/:38,
  GN-1-Anker extension_hardware_family_axis.hpp:84-93) und der Name extension_hardware.
  KORRIGIERT: SIMD/AVX sind META-META-ACHSEN (volle CT-Haupt-Achsen), nicht Unter-Achse des Hubs;
  ext_hw wird zu external_utils = Plug+Manager aller Meta-Metas (externe HW, AVX, UND Mess-Framework als
  ERSTER Einbaukandidat). Folgen, im Bauplan nicht enthalten: Umbenennung trifft Label/Registry-XML/
  parent-Strings/test_striktheit_axis_dach_guard, Suffix-Segment +ext=<hub-konfiguration> statt <simd>
  (I-7), und der "load_framework = 1. Meta-Meta"-Wortlaut kollidiert mit "Mess-Framework als erster
  Meta-Meta-Kandidat" -> muss beim Neuschnitt eindeutig entschieden werden (offene Frage, nicht geraten).
8 UEBERHOLT (Q-13): Bauplan-Empfehlung "telemetry bleibt Sonderfall". KORRIGIERT: telemetry ist
  MESS-TOOLING-UNTERACHSE DES PLANERS -> wandert in die Mess-Achsen-Welt; Achtung G-A5
  (test_br1_full22_count.cpp:60-65) und Suffix-Token +tel=silent (profile_run_facade.cpp:390-395).
9 UEBERHOLT (Q-1): Nachtrag "disk_writeback sofort enabled=true" (2^18/262144) ist REVIDIERT auf
  enabled=false; Raum bleibt 2^17=131072. Auflage FullSourceCatalog K17=1 (mp_take_c<L,2> auf
  1-elementiger Liste ist ill-formed, boost_mp11 algorithm.hpp:430,447) bleibt tragend.
  NEU-AUFLAGE ausserhalb des Bauplans: Achsen-Deaktivierung muss PER XML unterstuetzt sein (nicht nur option()).
10 BESTAETIGT/UNVERAENDERT: Q-0=V2 Byte-Schnitt (VOLLES GO, "dauert so lange es dauert"),
  Q-6 xs:all, Q-7 fixed_enum_tuple, Q-8 nur SearchAlgorithm, Q-9 Reader 160+169, Q-10 T-Anhang hinter
  queuing_q2 + Q-10b goldenK=1, Q-11 Scharfschaltung nach Trigger, Q-14 Modus nie im Stempel,
  Q-12 Bestandslog waehrend Voll-Bau-4 AUS. Lane B (ORG-18, 31 Ah, 17 Bruch-Stationen) ist von den
  Korrekturen NICHT betroffen und bleibt wie geplant.

== (d) AUFWAND/RISIKO KRITISCHER PFAD A -> J1 -> F -> J2 -> TRIGGER ==
Alt-Rechnung (Bauplan): A 32-36 + J1 6 + F 12,5 + J2 4 = ~55 Wanduhr-h bei 3 Agenten (~2-2,5 Kalendertage),
Gesamtarbeit vor Trigger ~100 Ah (V2-Schnitt: ~76 Ah, A-IV 4 Ah verschoben).
Korrektur-Aufschlag auf Lane A (Punkte 1-5,7,8 aus (c)): Komplex-Wrapper generisch + OS als 4. Glied
+ Meta-Meta-Typen statt Descriptor + offene Rekursion + 3-stufige Klammer-Notation + SHA512-Overlay-Stempel-Zeile
+ external_utils-Umbenennung + telemetry-Wanderung. Ehrliche Schaetzung: A 32-36 -> 46-56 Ah,
C 12,5 -> 16-18 Ah (Typ-Pack statt Descriptor-Span, Vertrag V1 neu), Vertrags-Sync 0,5 -> 1,5-2 Ah
(V1 ist neu zu definieren, V3 ist durch die Stempel-Doktrin materiell vorgegeben statt offen).
Neue Wanduhr-Schaetzung kritischer Pfad: A(46-56) + J1(6-8) + F(12,5-15) + J2(4-5) = ~70-84 h,
also ~3-3,5 Kalendertage bei 3 parallelen Agenten - gegen die Frist Mo 27.07. (2T Bau + 2T Messen) ist das
der harte Konflikt und der einzige Punkt, der eine Owner-Entscheidung braucht (Termin vs. Ordentlichkeit).
Risiken, nach Schwere:
 R1 HOCH - Serialisierung F: F ueberlappt die G4b-1-Sperr-Menge VOLLSTAENDIG (system_axes_version_suffix
    facade.cpp:364-400, Perm-Anker profile_run_entry.hpp:754-757, Identitaets-Durchsetzung
    build_orchestrator.hpp:457-468, Zell-Befuellung profile_run_entry.hpp:331-347, Planer-CLI). Jede
    G4b-1-Verzoegerung verschiebt den Trigger 1:1. Keine Parallelisierung moeglich, kein Puffer.
 R2 HOCH - A ist nach den Korrekturen kein reines Typ-Refactoring mehr, sondern ein Modell-Neubau
    (offene Rekursion + generischer Wrapper). Riss 1 (keine CebSubAxis-Wurzel, Haupt/Unter nur
    Konventions-String) bleibt der BLOCKER fuer R-B/R-C/R-D/R-E; Fehlschnitt hier zieht F, E und G nach.
 R3 MITTEL-HOCH - Byte-Wachen-Kaskade: Stempel geht in generierten AdHoc-Quelltext
    (lazy_adhoc_source_gen.hpp:199-201, adhoc_emitter.hpp:94, pilot_source_map.hpp:52-56) -> jede
    spaetere Stempel-Aenderung = ZWEITER Voll-Bau (~24 h, ~224 GB). Deshalb muessen A, B und F im
    SELBEN Bruch-Fenster vor dem Trigger liegen; die SHA512-Overlay-Stempel-Zeile gehoert
    zwingend mit hinein, sonst ist der Voll-Bau bereits beim Bauen veraltet.
 R4 MITTEL - J1 ist der einzige serielle Sammelpunkt (Patch anatomy_version_stamp Organ-Zeile,
    Test-Target-Registrierung, BEIDE Registry-XMLs regenerieren, golden neu ankern kNewGolden131072Crc64
    + golden_fullpilot_320_binary_ids.txt, voller lokaler ctest Mode A). Zwei Byte-Roundtrip-Gates
    (System- und Organ-Registry) sind hier gleichzeitig scharf; ein Fehler = roter Bau in fremdem Lane-Gebiet.
 R5 MITTEL - lokale Voll-Bau-Luecken (ce-all ohne Fassaden-TU, super-all ohne ce-Unit-Tests) machen
    "gruen" bei J2 potenziell falsch -> 2-Pass-Werkzeugpflicht ist Gate, nicht Option.
 R6 NIEDRIG - Remote-Verwaisung der +ext=avx2/avx512-Objekte: additiv NULL (ABI 6->7), kein Loesch-GO.
 R7 OFFEN, nicht schaetzbar - Kollision "load_framework = 1. Meta-Meta" gegen "Mess-Framework als erster
    Meta-Meta-Einbaukandidat unter external_utils": beruehrt A-I.5, C-3, Suffix-Segment +lf/+ext und die
    Mess-/System-Realm-Grenze. Muss VOR A-I.5 entschieden werden, sonst Nachbau in einem gesperrten Bereich.

SELBSTCHECK: read-only, keine Datei geaendert (nur Read/Bash-ls/du/python-json). ASCII-only, 0 Nicht-ASCII
(kein Paragraph-Zeichen, keine Gedankenstriche). Alle Zeilennummern/Zahlen stammen aus den gelesenen
Backup-Reports bzw. den Owner-Memories; nichts geraten. Aufwands-Aufschlaege in (d) sind als Schaetzung
gekennzeichnet, nicht als belegte Zahl.
