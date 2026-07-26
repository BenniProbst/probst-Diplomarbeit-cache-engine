ANKER-KARTE golden-System + Folgen des beschlossenen Umbaus (ORG-18-Blaupause)
Repo-Wurzel: /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine
(Pfad-Korrektur: source_catalog.hpp liegt unter libs/cache_engine/profile_facade/, NICHT .../builder/profile_facade/)

(a) IST-ANKER (datei:zeile)
KATALOG-KERN  libs/cache_engine/profile_facade/source_catalog.hpp
  :91-127   CatalogAxes<K00..K17>  = 18 mp_take_c-Slots L00..L17 (L17 = io::StaticAxisVariants_PT)
  :114-120  BELEGTE FALLE: mp_take_c<1-elem-Liste,2> ist ILL-FORMED, kein min()-Schutz -> K17 MUSS 1 sein
  :139      FullSourceCatalog = CatalogAxes<2 x17, 1>            -> 2^17*1 = 131072
  :144      golden_320_catalog = CatalogAxes<4,1,1,1,4,5,1,4,1..1> -> 4*4*5*4 = 320
  :148      SmallSourceCatalog = <..2,2..>                        -> 4 (E2E-Treiber)
  :154-165  catalog_axis_product<> = explosionsfreies PROD mp_size ueber L00..L17
  :169-173  3 static_assert Kardinalitaet 131072 / 320 / 4
  :189      kNewGolden131072Crc64 = 0x56F1B721C72DC10EULL  (ORG-18-Re-Anker, 18 Slots)
  :181-188  Re-Anker-Beleg als LITERALER Werkzeug-Output; Alt-Anker 0xF1C1F26A1232073B (ABI-6, 17 Slots) tot
  :204      kMaxMaterializableCatalogCardinality = 4096 (Anti-Materialisierungs-Grenze)
  :208-211  Guard-des-Guards: 2^17 MUSS > Grenze, 320 MUSS <= Grenze
  :252-275  make_catalog_source_gen<Catalog = golden_320_catalog>: is_same_v<FullSourceCatalog> VERBOTEN +
            Kardinalitaets-Schranke, beide im discarded if-constexpr -> bricht billig statt GB-TU/ICE
  :219-240  catalog_static_levels<>: die 18 Achsen-NAMEN in Reihenfolge (= binary_id-Segmentfolge)
  :347      AxisSweepCatalog-Zweig, eigener L17-Slot   :425-427 B17 = Baseline-Slot der 18. Achse
NAMENS-SINGLE-SOURCE  libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp:40-43
  kCompositionAxisNames = std::array<string_view,18> (search_algo .. persistence_target)  <- HARTE 18
  :53-69 serialize_composition_path<P>  :71-74 serialize_composition_from_slots<C> (18 named slots)
ZWEITE SLOT-TABELLE   libs/cache_engine/profile_facade/lazy_adhoc_source_gen.hpp:134-153 (Kommentar sagt
  noch "17 Flyweight-Tabellen", Zeile 153 traegt bereits Slot 18 = StaticAxisVariants_PT -> Doku-Drift)
KOMPOSITION           libs/cache_engine/anatomy/composition_factory.hpp:67 struct AdHocComposition (named slots)
WERKZEUG              tools/gen_golden_fullpilot/main.cpp
  :48-77  --golden320 <datei> (golden_320_catalog, Frueh-Ausstieg, Kopf-Kommentar wird MITGESCHRIEBEN, exit 4 != 320)
  :79-101 --crc64 (FullSourceCatalog, CRC64-ECMA-182 je id + '\n', MATCH/MISMATCH, exit 4)
  :103-119 <datei> = 131072-Zeilen-Datei, NICHT ins git (62 MB)
FIXTURES  tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt:1-6 (Kopf: "ABI-7 / STRUKT-R ORG-18,
  18 Slots, mit persistence_target; ohne telemetry-/isa-Segment"; Regen NUR ueber --golden320)
  + additive Einfrierung _abi4.txt / _abi5.txt / _abi6.txt (nichts geloescht; abi6 = 17-Slot-Stand)
PROFIL-SPIEGEL  libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml:11
  (deklarative Spiegelung von CatalogAxes<2,...,2>; bewusst NICHT in catalog_codegen.cmake repointet)
REGISTRY  libs/cache_engine/include/cache_engine/measurement/system_axis_registry.xml
  :10 compiler binary_id="never"  :13-39 sub_axis opt_level 5 Optionen O0,O1,O2,O3,Ofast(ieee754_deterministic=false)
  :40-51 atomic128 (no_cx16/cx16)  :53 extension_hardware never (:55-71 simd no_extension/avx2/avx512)
  :98 target_isa never  :102 scheduling never  :114 load_framework never  :8-9 AUSSCHLUSS extension_hardware/hardware_isa
  => ALLE 5 System-Achsen tragen binary_id="never". Organ-only-binary_id-Doktrin ist im Ist HART belegt.

(b) WAS binary_id/Kardinalitaet BERUEHRT - und was nicht
BERUEHRT NICHTS (nur System-Perm-Raum, kein golden-Bruch):
  - opt O0-O3 Permutation: opt_level ist SUB-Achse der System-Achse compiler, binary_id="never" (Registry:10,13).
    Faechert nur den Bau-/Job-Raum auf (x4 DLLs je binary_id, Sidecar/CSV-Spalte). kNewGolden131072Crc64 und die
    320er-Byte-Wache bleiben BYTE-IDENTISCH. Achtung: Registry hat 5 Optionen; "alle verfuegbaren Stufen" muss
    entscheiden ob Ofast (ieee754_deterministic="false") mit-permutiert -> Mess-Vergleichbarkeit, NICHT golden.
  - NUMA/locking ALS System-Haupt-Achse (so beschlossen, ISA-abhaengig): binary_id="never" -> KEIN Segment,
    KEINE Kardinalitaets-Aenderung am Katalog. Sie tritt nur in kSystemAxisOrder + Registry + Sidecar auf.
    ABER: ISA-Abhaengigkeit heisst Kopplung an target_isa -> Perm-Raum-Explosion x|numa| pro Maschine, und die
    bestehende Organ-Achse concurrency (L08) ist der SEMANTISCHE NACHBAR - Doppelbelegung locking(System) vs
    concurrency(Organ) muss vorab entschieden werden, sonst Achsen-Ueberlappung.
  - external_utils-Rename: reiner Pfad-/Target-Rename. Im Ist-Cache-Engine-Baum grept "external_utils" NICHT
    (0 Treffer in libs/tests/cmake) -> beruehrt golden nur, falls Include-Pfade der Katalog-TUs mitwandern.
  - kSystemAxisOrder neu: Symbol existiert im Ist NOCH NICHT (0 Treffer repo-weit) -> Neubau, kein Bruch;
    Reihenfolge-Aenderung wirkt auf System-Achsen, die per binary_id="never" nie in die id serialisieren.
BERUEHRT binary_id + Kardinalitaet (golden-Bruch, GO liegt vor):
  - page_type mit "Cache-Awareness PFLICHT" = Datenstruktur-/Speicher-Eigenschaft, gehoert per Doktrin zu den
    ORGAN-Achsen (Nachbarn: memory_layout L05, allocator L06). Als 19. Kompositions-Achse:
      * kCompositionAxisNames 18 -> 19 (axis_path_serialization.hpp:40)
      * CatalogAxes K00..K18, catalog_axis_product 19 Faktoren, catalog_static_levels 19 push_static_axis
      * jede der 131072 ids bekommt Segment "/page_type=..." -> kNewGolden131072Crc64 MUSS neu
      * jede der 320 ids ebenso -> golden_fullpilot_320_binary_ids.txt MUSS neu (ABI-8)
      * Kardinalitaet: bei GoldenK=2 wird N = 2^18 = 262144 (Bauplan-Beleg ORG-18 N-2: ~448 GB / ~48 h) ->
        entweder K18=1 pinnen (Raum bleibt 131072, wie Q-1 FALL B bei persistence_target) oder Voll-Bau-Budget
        verdoppeln. EMPFEHLUNG: K18=1 pinnen, Aufschaltung spaeter per Bauplan.
      * Falle wiederholt sich: mp_take_c<1-elem,2> ill-formed -> bei 1-elementigem page_type-Inventar MUSS K18=1.
  - Reihenfolge-Frage: page_type NACH persistence_target anhaengen (Slot 18) haelt die 320er-Praefixe stabil;
    Einsortierung zwischen memory_layout und allocator (semantisch sauberer) permutiert ALLE Segmente um.
    Achsen-Neuordnungs-Beschluss (bindende Sortierung) schlaegt hier ggf. die Praefix-Stabilitaet.

(c) KONSUMENTEN-MENGE eines new-golden-Neuankers (alles anfassen/neu erzeugen)
  1 libs/cache_engine/profile_facade/source_catalog.hpp        :91-127,139,144,148,154-173,189,208-211,219-240,347,425-427
  2 libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp:40-43 (18 -> 19)
  3 libs/cache_engine/profile_facade/lazy_adhoc_source_gen.hpp :134-153 (+ Slot-Zahl im Kommentar)
  4 libs/cache_engine/anatomy/composition_factory.hpp:67       AdHocComposition named slot
  5 libs/cache_engine/axes/persistence_target/axis_persistence_target_registry.hpp (Blaupause fuer neue Achse)
  6 tools/gen_golden_fullpilot/main.cpp                        :67-73 + :106-113 (Kopf-Texte ABI-8 + Slot-Zahl)
  7 tests/unit/test_lazy_adhoc_source_gen.cpp                  :135,190-202,411
  8 tests/unit/test_limits_entkopplung_vorstufe.cpp            :78-79,120-140,149,159
  9 tests/unit/test_org18_persistence_target.cpp               :102-113 (Vorbild fuer test_<neu>_page_type.cpp)
 10 tests/unit/CMakeLists.txt                                  :2649,2677,2705,3554,3766 (BYTE_GUARD_IDS-Defines)
 11 tests/unit/thesis_tiere/test_wdk_datasets_fairness.cpp:49-64, test_measurement_categories.cpp:41-55,
    test_smoke_coverage_profile.cpp:47-81  (3 Leser der 320er-Byte-Wache)
 12 Fixtures: golden_fullpilot_320_binary_ids.txt (neu) + _abi7.txt (Einfrierung des Ist-Stands)
 13 Profile: all_axes_golden.profile.xml (je Achse genau 2 <value>), m3v2_study/m3_golden_coverage/
    m3_smoke_coverage.profile.xml (TABU-Vermerke), libs/.../cache_engine_axis_registry.xml
 14 measurement/system_axis_registry.xml + tools/system_axis_registry_gen (NUMA/locking, opt-Stufen; generiert!)

(d) EMPFEHLUNG - new-golden-Prozedur nach ORG-18-Blaupause (5 Schritte, in dieser Ordnung)
 1 EINFRIEREN (additiv, vor jeder Code-Aenderung): cp golden_fullpilot_320_binary_ids.txt -> _abi7.txt;
   Alt-CRC 0x56F1B721C72DC10E als "ABI-7, 18 Slots" ins Kommentar-Archiv von source_catalog.hpp:181ff
   uebernehmen (Muster :181-188). NIE loeschen, Messdaten-Doktrin.
 2 KARDINALITAETS-ENTSCHEID VOR CODE: page_type-GoldenK. Default-Vorschlag K18=1 (Raum bleibt 131072,
   Voll-Bau-4-Budget unveraendert), Aufschaltung auf 2 nur mit Bau-Feasibility-Beleg (2^18 = ~448 GB / ~48 h).
   Gleichzeitig entscheiden: page_type an Slot-Ende (Praefix-stabil) vs. Sortier-Beschluss-konform.
 3 ADDITIV BAUEN: neue Achse als eigenes axes/page_type/-Registry + StaticAxisVariants_PG (Blaupause
   persistence_target); dann in EINEM Commit alle vier Slot-Tabellen (2,3,4 aus (c)) von 18 auf 19 heben.
   NUMA/locking + opt-Permutation LAUFEN GETRENNT (System-Pfad, kein Katalog-Anfassen) -> nicht vermischen.
 4 REGENERIEREN, NICHT RECHNEN: Anker-Wert ausschliesslich als literaler Werkzeug-Output uebernehmen:
     comdare_gen_golden_fullpilot --crc64            -> neuen kNewGolden131072Crc64 setzen (Output ins Kommentar)
     comdare_gen_golden_fullpilot --golden320 tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt
   Zwischen 1. und 2. Lauf steht der Anker bewusst auf MISMATCH - das ist der dokumentierte ORG-18-Ablauf.
   Kopf-Kommentare beider Dateien auf "ABI-8 / 19 Slots" + Historie _abi{4,5,6,7} anheben.
 5 VERIFIZIEREN (2-Pass, lokal-first): test_limits_entkopplung_vorstufe (CRC + static_levels-Zahl),
   test_lazy_adhoc_source_gen, test_org18_persistence_target + neuer test_page_type, die 3 Byte-Wachen-Leser,
   danach --crc64 erneut auf [MATCH] und exit 0. Erst dann Voll-Bau-4.
 RISIKO-HINWEIS: Schritt 3 ohne Schritt 2 fuehrt in die belegte mp_take_c-Falle (ill-formed im TU) bzw. still
 in 2^18; und kMaxMaterializableCatalogCardinality=4096 muss danach weiterhin 320 <= Grenze < N erfuellen.
