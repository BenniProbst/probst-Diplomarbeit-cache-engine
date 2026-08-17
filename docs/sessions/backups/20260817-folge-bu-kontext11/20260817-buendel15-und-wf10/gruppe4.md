# BUENDEL-15 EXPLORE -- GRUPPE 4: VERSIONIERUNGS-INTERFACE + CT-NAMENSFUNKTION + REGISTRY
Erhebung: 17.08.2026 AM OBJEKT, ce development @ 04ac26fa (working tree clean). Alle Datei:Zeile = HEUTE.
Karten-Zitate (r3 A6/A7/D18, Erhebung 16.08. auf Objektstand ~06.-11.08.) wurden NICHT abgeschrieben,
sondern gegen HEAD nachgemessen; Abweichungen sind je Posten benannt.

## G4-1  GESONDERTES VERSIONIERUNGS-INTERFACE (Owner 22.07. LEDGER:3339 + 06.08. Z24489-92; r3 A6)
SOLL: je Stufe Planer/CEB/Tier/Hybrid ein SEPARATES Interface, constexpr SHA512 UEBER DIE STRING-ARRAYS
der Stempel-Zeilen, zur Compile-Zeit; nicht in bestehende Interfaces gemischt.

(a) IST-Fundstellen HEUTE -- die Substanz ist in TEILEN gebaut:
  * CT-SHA512-Primitiv EXISTIERT: libs/cache_engine/src/sha512/ctsha512.hpp (K7b-1; constexpr
    sha512_bytes :99, comdare::cache_engine::sha512::sha512(...) lt. Kopf :14).
  * Tier-Seite EXISTIERT als consteval Fingerprint: abi/anatomy_fingerprint.hpp -- Preimage-Budget
    kAnatomyFingerprintPreimageMax=4096 :68; Format-Literal "fingerprint_format=4" :116;
    kAnatomyFingerprintGliedCount=9 :416; Glied-Folge anatomy_fingerprint_glieder :593-606;
    anatomy_fingerprint_hex :736 (+Sperr-Ueberladung :769). Materialisierung ins Binary via
    COMDARE_ANATOMY_VERSION_STAMP_M, abi/anatomy_module_abi_v1.hpp:162-204 (2-arg-Form :213) in das
    OPTIONALE 5. Symbol (POD, s. G4-5).
  * S-1-Vertrag je Stufe EXISTIERT: abi/stempel_basis.hpp -- 7 Interfaces x 4 Traeger Matrix :100-117
    (28 Zellen, Pins :127-137), StempelVertrag-Concept :588-592, consteval-Kompositum :191-204.
    Das IST der "gesonderte" Traeger-Schnitt (KON7-04/KON8-07): version_xyz NUR Planer, organ_zeile
    CEB-VERBOTEN (KON7-07-Riegel :134), angeschlossene NUR Hybrid.
  * PLANER: PlanerStempel profile_facade/planner/planner_version.hpp:73-90, Vertrag :93-96.
    fingerprint_sha = DEKLARIERTE LUECKE :80-84 (kFingerprintShaBewusstLeer; "Fuellung = eigener
    Posten, Preimage-/Glied-Entscheid nicht in S-1"). CT-SHA512 des Planers FEHLT also.
  * CEB: CebStempel builder/ceb_version_stamp.hpp:622-646, Vertrag :648-651. fingerprint_sha =
    kCebFingerprint (consteval, kCebFingerprintArrayFor :593-599, einkompilierte Wahl :604-612).
    system_zeile = DEKLARIERTE LUECKE :628-637 (KON8-03-Bauauftrag). Querbezug r3 A1 (andere Gruppe):
    kCebFingerprint rendert ANGEBOT statt Wahl.
  * TIER + HYBRID: KEINE Erbin im Produktivbaum. Gegenprobe: grep StempelTraeger::Tier|Hybrid ausserhalb
    stempel_basis.hpp = NUR tests/unit/test_s1_stempel_basis_vertrag.cpp:175 (TierProbe) / :188
    (HybridProbe). libs/cache_engine/hybrid/ traegt 4 heuristik_adapter-Header, KEINEN Stempel-Traeger
    (heuristik_adapter_synthese_matrix.hpp:132-136 verlangt Stufen-IDs "im Stempel ablesbar" = A-07-Bezug).
  * Der Tier-Stempel lebt heute NUR als POD am optionalen 5. Symbol, NICHT als CRTP-Erbin/Interface.
(b) Wachen: stempel_basis-Matrix-Pins :127-137 (jede Interface-Erweiterung aendert kStempelInterfaceAnzahl
    -> 28-Zellen-Pin + Vertragstest T-3 test_s1_stempel_basis_vertrag mitziehen); planner_version.hpp
    :108-132 (Literal-/Roundtrip-Asserts); Byte-Anker test_d4_ceb_schluessel_wahl (kCebFingerprint darf
    sich NUR als deklariertes Byte-Ereignis bewegen); ci_test_inventory_floor (neue Vertragstests ->
    Anker-Nachzug, s. Wachen-Block unten).
(c) Reihenfolge: Interface-Erweiterung NACH G4-2-Heilung (CT-Name braucht name()-faehige reale Typen);
    Planer-SHA + CEB-System-Zeile koennen parallel, MUESSEN aber vor dem Format-5-Pin-Nachzug stehen,
    wenn ihre Glieder ins Preimage einziehen (A-04-Kopplung: Glied-Folge fest 9, :593).
(d) Entscheide: OWNER -- Form des "gesonderten Interfaces" am Tier (Export-Symbol vs. CRTP-Erbin im
    Kompilat vs. beides); Preimage-/Glied-Entscheid des Planer-SHA (planner_version.hpp:80-84 reserviert
    ihn ausdruecklich als eigenen Posten). AUTONOM -- Erbinnen-Bau nach vorhandenem Muster P4/P5.

## G4-2  CT-NAMENSFUNKTION + BLOCKER A7 (reale Achsen-Typen ohne name()/algo_version)
(a) IST HEUTE -- der r3-A7-Satz gilt NUR NOCH FUER EINE TEIL-POPULATION (Karte war pauschaler):
  * organ_stamp_line<Comp>() abi/anatomy_version_stamp.hpp:143-198; verlangt name()+algo_version an
    allen 18 Slots (:150-168); static_asserts :170-173 (ORG-18) + :186-191 (Grammatik-Wache).
    MOCK-ONLY bestaetigt: einziger Aufrufer tests/unit/test_m_w12_stamp_bausteine.cpp:468
    (MockComposition). Gegenprobe Produktiv-Aufrufer = 0; lazy_adhoc_source_gen.hpp:206 nennt ihn
    woertlich "mock-only".
  * Population A -- ADHOC-emittierte Module TRAGEN die Member: Slot-Typen der emittierten Makro-Args
    sind die Registry-W-Typen (lazy_adhoc_source_gen.hpp:111-115/:130 type_name<W>; Exemplar
    Array256SearchAlgo: organ_axes/lookup/axis_03a_search_algo_array256.hpp:132 name(), :142
    algo_version). Durchsetzung: CRTP-Ctor-Guard in 18 Strategy-Basen (Exemplar
    organ_axes/alloc/axis_06_allocator_strategy_base.hpp:186-189) + universelle Tabellen-Wache
    builder/experiment_tree/axis_variant_version_table.hpp (Kopf; mp_for_each ueber W::algo_version).
  * Population B -- Referenz-/Pool-Kompositionen tragen sie NICHT: Slot-Typen sind Observable-/
    Composed-HUELLEN, z.B. compositions/art_reference.hpp:66 (ObservableArtTrieOrgan =
    ObservableComposedContainer<ArtTrieOrgan>, tier_to_organ_mapping.hpp:154). Gegenprobe:
    organ_axes/lookup/composable/observable_composed_container.hpp hat 0 Treffer name()/algo_version;
    65 Dateien unter organ_axes/lookup/composable/.
  * Zwischen-Heilung (seit 11.08., in r3 NOCH NICHT enthalten): Registry-TABELLE + RT-Komposition
    ex::compose_organ_stamp_line (axis_variant_version_table.hpp) traegt Pfad [1] ADHOC
    (lazy_adhoc_source_gen.hpp:207/:368) und [2] PILOT (pilot_source_map); Pfad [3] SOTA traegt NICHT
    (sota_catalog.hpp:134-144: binary_id ohne achse=wert-Paare -> LEERE Organ-Zeile, offener K-3-Rest).
    Das ist RT am Emitter (CEB), NICHT die CT-Namensbildung im Tier-Kompilat.
  * CT-NAMENSFUNKTION FEHLT (Owner: "Name der Funktion aus dieser Rekombination in die binary"):
    Gegenprobe dreifach -- (1) POD AnatomyVersionLines decl.hpp:201ff traegt organ/system/mess/sha512/
    entries, KEIN Namensfeld; (2) AdHocComposition::name ist das GENERISCHE Literal "AdHocComposition"
    (anatomy/composition_factory.hpp, name/paper_id-Zeilen im Struct-Schwanz) -- nicht die Rekombination;
    (3) die Organ-Zeile entsteht als Emitter-LITERAL, kein zweiter CT-Ableitungsweg im Tier-Kompilat.
(b) Wachen: S-14a-Riegel deckt die Huellen (axis_version.lock fuehrt composable-Dateien, z.B.
    observable_composed_container.hpp Lock-Z.959/2009, composed_masstree_search.hpp Z.890/1958) ->
    jede Heilungs-Beruehrung verlangt Lock-Regen (--write) im SELBEN Commit, sonst CI Exit 3
    (contract:axis-version-lock .gitlab-ci.yml:827-848). Overlay-Glied [7]: builder/overlay_source_set.hpp
    (:48-59 deckt organ_axes/ inkl. topics/-Andock) -> JEDE Beruehrung verschiebt ALLE Fingerprints =
    genau der A-13-Grund, den Schnitt NUR im #15-Fenster zu fahren. Emitter-Byte-Wachen:
    test_lazy_adhoc_source_gen (Round-Trip byte-identisch) + CRC-Anker kNewGolden131072Crc64
    (source_catalog.hpp:190) -- eine CT-Namensfunktion darf NUR in der Makro-EXPANSION materialisieren
    (Muster Fingerprint, anatomy_version_stamp.hpp:120-127), sonst brechen die 320er-Wachen.
(c) Kleinster Heilungs-Schnitt (Kartierung, kein Bau): name()/algo_version-DURCHREICHUNG in den
    Huellen-Schalen (ObservableComposedContainer + Composed*-Familie delegieren auf das innere Organ,
    dessen Member existieren) -- beruehrt NUR organ_axes/lookup/composable/ (<=65 Dateien, real weniger:
    nur vom Referenz-/Mapping-Pfad erreichte Huellen). NICHT gangbar als Alternative: Tabellen-Lookup im
    Tier-Kompilat (Tabelle lebt im builder-Layer; abi->builder VERBOTEN, stempel_basis.hpp:6; Registry-
    Includes sind "heap-schwer, NIE in schlanke TU", axis_variant_version_table.hpp Kopf).
(d) Entscheide: OWNER -- ob der Rekombinations-NAME ins POD (dann Layout-Feld im SELBEN 6->7-Bump, s.
    G4-5/A-01) oder als eigenes constexpr-Interface/Symbol; SOTA-K-3-Rest-Form (binary_id-Grammatik
    "sota::" traegt keine Achsen-Paare). AUTONOM -- Huellen-Durchreichung (reine Delegation, keine
    Wert-Aenderung), Lock-/Floor-Nachzug.

## G4-3  A-14-KORREKTUR: KEINE 123 LITERAL-BUMPS (KON58-05; KON9-05 = nur Stempel-UNTERSTUETZUNG)
(a) IST-Zahlen HEUTE: 135 "static constexpr ... algo_version ="-Definitionen unter organ_axes/
    (nicht 123 -- die 123 war ohnehin nie Ledger-gedeckt); Lock-Bestand 718 Records = 640 organ +
    55 tier_substanz + 16 system + 6 heuristik + 1 mess (tools/axis_version_lock/axis_version.lock,
    Zaehlung awk ueber Kopfzeilen). Bump-Disziplin steht im Code: "ein Bump zeigt eine Aenderung AN,
    er ist kein routinemaessiges Hochzaehlen" (axis_06_allocator_strategy_base.hpp:104-106; gelebt:
    24 von 26 alloc-Varianten 1.0.2.c, 2 bewusst 1.0.1.c).
(b) Wachen: S-14a prueft LITERAL-LISTEN je Datei (Tool v2, G3: alle Literale, nicht das erste) und
    verlangt bei jedem Inhalts-Edit Digest-Regen -- der Riegel unterscheidet sauber Digest-Aenderung
    (Pflicht bei G4-2-Durchreichung) von Versions-Bump (NICHT verlangt).
(c) Folge fuer das Buendel: G4-2/G4-1 fuegen DURCHREICHUNGEN und Interfaces hinzu, KEINE Versions-Bumps;
    ein flaechiger Bump waere selbst ein Verstoss (Bump-Disziplin) UND ein unnoetiger algo_sig-Sturm.
(d) Entscheide: keiner offen -- A-14 ist Korrektur-Wissen; autonom einzuhalten.

## G4-4  B1-REGISTRY-FLAECHE (r2 Par.27/28/32-F6; r3 D18)
(a) IST HEUTE:
  * DREI art-spezifische Registries (XML): organ = libs/cache_engine/algorithm_profiles/
    cache_engine_axis_registry.xml; system = libs/cache_engine/include/cache_engine/measurement/
    system_axis_registry.xml; mess = .../measurement/measurement_axis_registry.xml.
    SOLL "JE IM MODUL": system+mess liegen NICHT in system_axes/- bzw. mess_axes/-Homes, organ nicht im
    organ_axes-Home -- der Modul-Umzug ist NICHT vollzogen (kein Treffer der XMLs unter system_axes/,
    mess_axes/, organ_axes/).
  * Generator-Pflicht IST DURCHGESETZT: tools/axis_registry_gen + tools/system_axis_registry_gen +
    tools/measurement_axis_registry_gen; Byte-Roundtrip-Gates: CI .gitlab-ci.yml:778-783
    (comdare_axis_registry_gen, byte-diff==0) + ctest test_system_axis_registry_roundtrip
    (tests/unit/CMakeLists.txt:5740) + test_measurement_axis_registry_roundtrip (:5755).
  * 2er/3er-Partition auf DERSELBEN XML -- heutige Anker (r3-D18-Zeilen :691-709/:780-838/:872-888/
    :1137-1164 sind bei HEAD VERSCHOBEN): profile_facade/validate_profile.hpp -- 3er RegistryTrio
    :728-736 (organ/system/measurement; prt ABWESEND, Begruendung :718-723), read_axis_registry :686,
    Kanon-Block :700-727 inkl. dokumentierter OPTION B (:727ff, "bewusst NICHT gebaut"); Resolver
    resolve_axis_refs_against_trio :820 (+DeclaredAxisRef-Ueberladung :866). 2er ENGINE-Partition:
    validate_experiment_profile :934 (engine_registry_paths; ee_ce/ee_prt-Zwang :941; map_mode
    :1183-1192; Kanon-Kommentar :909-925). Datei gesamt 1360 Z.
  * D18-Definen-Falle, HEUTE NACHGEZAEHLT -- es sind MEHR als "beide": auf dieselbe
    cache_engine_axis_registry.xml zeigen unabhaengig (1) COMDARE_CE_AXIS_REGISTRY
    profile_facade/CMakeLists.txt:188 (3er); (2) COMDARE_CE_AXIS_REGISTRY_PATH super-seitig
    (02_messung_driver/CMakeLists.txt + apps/experiment_planner; ce-Kommentar :175-181 verlangt bei
    Umzug BEIDE); (3) tests/unit/CMakeLists.txt:2385 COMDARE_CE_AXIS_REGISTRY_XML; (4) :3780
    COMDARE_ORG18_AXIS_REGISTRY_XML; (5) :3890/:3998/:4070 weitere COMDARE_CE_AXIS_REGISTRY-Kopien.
    Ein Umzug "je im Modul" muss ALLE ce-Stellen + die super-Stellen nachziehen.
(b) Wachen: die drei Roundtrip-Gates (oben) sind zugleich die "nie XML von Hand"-Durchsetzung;
    Registry-Reihenfolge speist den CRC-Anker kNewGolden131072Crc64 (haengt an Registry-Ordnung, NICHT
    an der XML-Datei) -- ein reiner Datei-UMZUG ist CRC-neutral, eine Enabled-/Ordnungs-Aenderung nicht.
(c) Reihenfolge: XML-Umzug (falls beschlossen) ist vom Fingerprint-Bruch UNABHAENGIG (kein Preimage-
    Glied traegt den Pfad), muss aber VOR F2 nur, wenn der Owner die Modul-Home-Ordnung als
    Identitaetsfrage einstuft; sonst Korb-B-faehig.
(d) Entscheide: OWNER -- Option B (optionales prt-Trio-Feld, ~0.5 Tag, braucht super->ce
    Compile-Interface fuers Baseline-Layering; r3 D18); OWNER -- Registry-Umzug in Modul-Homes vor F2
    ja/nein. AUTONOM -- Define-Konsolidierung auf EINE CMake-Quelle je Datei (reine Infra, kein Byte).

## G4-5  5. ABI-SYMBOL AM LOADER: OPTIONAL -> PFLICHT (A-11, KON7-01)
(a) Fundstellen HEUTE:
  * Loader: libs/cache_engine/builder/anatomy_module_loader/anatomy_module_loader.cpp --
    4 Pflicht-Symbole + Magic/Major-Gate :121-141; 5. Symbol comdare_anatomy_version_lines OPTIONAL
    :68-69 (Doku) + :164-167 (fehlt es, bleibt der Zeiger nullptr, Ladung gilt als ERFOLGREICH).
  * Deklaration: abi/anatomy_module_abi_v1_decl.hpp:322-326 ("OPTIONALES Probe-Symbol", dlsym nullptr
    :324); Makro-Zusage "KEIN Loader-Pflicht-Symbol -> KEIN ABI-Bruch" anatomy_module_abi_v1.hpp:126.
  * Nachgelagerte fail-closed-Stelle (heutige Kompensation): builder/pruef_dock/mess_konsistenz_gate.hpp
    :112 (Status stempel_symbol_fehlt), :210/:234 (nullptr-Klassifikation), :285 (Handle-Ueberladung).
  * POD/Layout: AnatomyVersionLines decl:201ff, kAnatomyVersionLinesLayout = 6 decl:267, sizeof-Pin
    ~:271-276, K-4-Layout-Proben decl:301-307 (6 ja / 5 nein / 7 nein). ABI-Major heute 9 (decl:109) --
    der Buendel-"Layout 6->7" ist der POD-Layout-Bump, NICHT der ABI-Major.
(b) BRUCHWEITE der Pflichtschaltung (gemessen):
  * Emittierte SearchAlgorithm-Module tragen das Symbol IMMER (adhoc_emitter.hpp:124 2-arg / :131
    3-arg -- beide Pfade haengen das Stempel-Makro an) -> Produktiv-Adhoc/Katalog bricht NICHT.
  * ABER: die vier anderen Gattungs-Makros definieren NUR die 4 Pflicht-Symbole -- set_module_abi_v1.hpp,
    sequence_module_abi_v1.hpp, view_module_abi_v1.hpp, adapter_module_abi_v1.hpp (Gegenprobe: 0
    VERSION_STAMP-Treffer in allen vier), und DERSELBE gattungs-agnostische Loader laedt sie
    (sequence_module_abi_v1.hpp:4, adapter_module_abi_v1.hpp:8) -> Pflicht bricht Set/Sequence/View/
    Adapter-DLLs, sofern nicht (i) deren Makros das Symbol bekommen oder (ii) die Pflicht je Gattung
    geschnitten wird.
  * Test-Minimalmodule mit 4 Symbolen brechen: genus_module_major7_neue_magic.cpp:46,
    genus_module_alt_major7.cpp:50 (+weitere Fixture-DLLs) -- als Negativ-Proben umwidmen oder stempeln.
  * Loader-Statusliste braucht einen neuen Code (heute status_ok..status_null_module = 0..8,
    anatomy_module_loader.hpp:35-43); Konsumenten load_all: apps/f15_compare/main.cpp:240-241,
    harness/perm_runner.hpp.
  * Der D2-Gate-Status stempel_symbol_fehlt wird toter Zweig -> Gate + test_d2_mess_konsistenz_gate
    nachziehen (Pruefung wandert vom Dock an den Loader).
  * golden-/binary_id-neutral: reiner RT-Ladepfad, kein Emitter-Byte.
(c) Reihenfolge: Pflichtschaltung ZULETZT im Buendel -- NACH POD-Layout 6->7 (sonst prueft der
    Pflicht-Pfad das alte Layout) und NACH Stempel-Nachzug in den vier Gattungs-Makros bzw.
    Gattungs-Schnitt-Entscheid.
(d) Entscheide: OWNER -- Geltungsbereich der Pflicht (nur SearchAlgorithm-Tier-DLLs vs. alle 5
    Gattungs-Makros; KON7-01 sagt "Pflicht", nennt den Gattungs-Schnitt nicht). AUTONOM -- neuer
    Status-Code, Fixture-Nachzug, D2-Gate-Umbau.

## WACHEN-SAMMELBLOCK (Gruppe-4-Sicht auf die vier genannten Anker)
* S-14a-Riegel: tools/axis_version_lock/axis_version.lock = HEUTE EXAKT 718 Records (640 organ +
  55 tier_substanz + 16 system + 6 heuristik + 1 mess); Tool v2 tools/axis_version_lock/
  axis_version_lock.cpp; CI contract:axis-version-lock .gitlab-ci.yml:788-848 (Job :827); Tripwire
  tests/unit/test_s14_axis_version_lock_tripwire.cpp; Inventar-Spiegel test_t6_wachen_inventar.cpp:244/:303.
  Gruppe 4 zieht ihn bei JEDER organ_axes-Beruehrung (G4-2) -- Digest-Regen, KEIN Versions-Bump (G4-3).
* ci_test_inventory_floor: scripts/ci_test_inventory_floor.txt, Anker EXAKT 495/491/489 (:69-71,
  Kopf: EXAKT-Anker seit #39, Abweichung in BEIDE Richtungen = Exit 4 via scripts/
  ci_test_coverage_guard.sh). Jeder neue ctest der Gruppe (Vertrags-/Abnahme-/Negativtests) =
  Anker-Nachzug im SELBEN Commit, je Host-Klasse.
* axis-version-lock == S-14a (dasselbe Gate; keine zweite Wache).
* static_asserts, die Gruppe 4 mitzieht: decl:301-307 (K-4-Proben 5/6/7 -- beim 6->7-Bump alle drei
  Aussagen + sizeof-Pin umziehen), anatomy_fingerprint.hpp:643 (GliedCount==9) + :647 (Format-4-Pin ->
  5) + :608-613 (Glied-Ordnungs-Beweise), anatomy_version_stamp.hpp:170/:186, stempel_basis.hpp:127-137
  (28-Zellen-Matrix), planner_version.hpp:108-132, composition_concept.hpp:71 (organ_count 18 speist
  ABI -- Namens-/Slot-Aenderungen hier = Major-Bump-Pflicht decl-Kopf).
* golden-Anker: kNewGolden131072Crc64 source_catalog.hpp:190 (Registry-Ordnung, nicht XML);
  320er-Round-Trip (test_lazy_adhoc_source_gen); Byte-Anker test_d4_ceb_schluessel_wahl.

## BAU-REIHENFOLGE-ZWAENGE INNERHALB #15 (Gruppe 4)
1. A7-Huellen-Durchreichung (G4-2) ZUERST und IM Fenster (Overlay-Glied [7] bewegt sich; A-13).
2. CT-Namensfunktion + Matrix-/Interface-Erweiterung (G4-1) DANACH (braucht 1).
3. Tier-/Hybrid-Erbin, Planer-SHA, CEB-System-Zeile (KON8-03) -- konsumieren 2.
4. POD-Layout 6->7 + Format 4->5 in EINEM Bruch mit A-01/A-02/A-04 (Namens-Feld/-Glied, falls Owner
   es ins POD/Preimage legt, gehoert in DENSELBEN Bruch -- sonst steht der teuerste Bruch erneut an).
5. 5.-Symbol-Pflicht (G4-5) ZULETZT (nach 4 + Gattungs-Makro-Nachzug).
Quer: G4-4 (Registry) ist vom Fingerprint-Bruch entkoppelt; nur ein beschlossener XML-Umzug wandert
mit allen Defines in einen eigenen, CRC-neutralen Schritt.

## OFFENE ENTSCHEIDE (gesammelt)
OWNER: (1) Form des Tier-/Hybrid-Versionierungs-Interfaces (Export-Symbol vs. CRTP vs. beides);
(2) Rekombinations-NAME ins POD (Layout-7-Feld) oder eigenes Interface; (3) Geltungsbereich der
5.-Symbol-Pflicht ueber die 5 Gattungs-Makros; (4) Option B prt-Trio-Feld; (5) Registry-Umzug
"je im Modul" vor F2; (6) Planer-SHA-Preimage/Glieder. AUTONOM: Huellen-Durchreichung, Erbinnen nach
P4/P5-Muster, Loader-Status, Fixture-/Gate-/Lock-/Floor-Nachzuege, SOTA-K-3-Rest, Define-Konsolidierung.

## NULLBEFUNDE (je mit Gegenprobe)
* "CT-Namensfunktion existiert nicht": POD ohne Namensfeld (decl:201ff), AdHocComposition::name generisch,
  organ_stamp_line<Comp> ohne Produktiv-Aufrufer (einziger Caller test_m_w12_stamp_bausteine.cpp:468).
* "Tier-/Hybrid-Erbin existiert nicht": einzige Treffer StempelTraeger::Tier/Hybrid = Matrix-Pin +
  Test-Proben (test_s1_stempel_basis_vertrag.cpp:175/:188).
* "5. Symbol wird produktiv nirgends erzwungen": Treffer-Zensus comdare_anatomy_version_lines =
  Loader (optional), Pruefdock-Gate (fail-closed nachgelagert), decl/Makro, Tests, Doku-Kommentare --
  kein Pflicht-Pfad.
* "Gattungs-Makros ohne Stempel": 0 VERSION_STAMP-Treffer in set_/sequence_/view_/adapter_module_abi_v1.hpp.
* "Registry-XMLs nicht in Modul-Homes": kein Fund unter organ_axes/, system_axes/, mess_axes/;
  Ist-Orte algorithm_profiles/ bzw. include/cache_engine/measurement/.
