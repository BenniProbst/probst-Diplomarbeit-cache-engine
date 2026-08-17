# BUENDEL-BAUPLAN #15 -- DER EINE BRUCH (Synthese, additiv datiert 17.08.2026)

QUELLEN: 7 Explore-Karten gruppe1..7.md (Erhebung 17.08.2026 an ce development @ 04ac26fa, read-only) +
Wellenplan Sec.19.1 (Z.2235-2277) + LESE-SYNTHESE-kontext10 (17.08.) + Ledger (KON55 verifiziert :3942-3990,
KON98 :48-56; E-A..E-F-Nachtrag :27970-27979). Zeilenangaben = Karten-Messung 17.08.; vor jedem Edit am
Objekt nachmessen (Erhebungsdatum-Doktrin). Pfade repo-relativ zu Code/external/comdare-cache-engine, wenn
nicht anders gesagt. Dieses Dokument ist ADDITIV; es ersetzt keinen Plan, es ordnet den Bau des Buendels.

## 0 KERNSAETZE

1. DER EINE BRUCH = Format 4->5 + Layout 6->7 + GliedCount 9->10 + Budget-Hebung + S-6a-Umstellung
   + work_mode-Ordinalschub + alle Overlay-[7]-/Lock-/golden-wirksamen Posten (A-09, A-08, #70, S-6d-
   Schnitt-Renames, G4-2-Huellen, B3-anatomy-Anteile, E-B, telemetry-silent) in EINEM Lande-Ereignis.
   Frist: VOR F2 (Fr 21.08.). Alles, was Flotte, golden-CRC oder build_version bewegt, faehrt HIER mit --
   jede Nachzuegler-Bewegung waere ein zweiter Flotten-/golden-Bruch nach F2 (C7-Warnung, gruppe7).
2. KOSTENLAGE: .fingerprint-Sidecar-Bestand im Baum = 0 (gemessen 17.08.); F1-Messung 377503 lief extern.
   Massgeblich ist KON41-01/OV-4: Flotten-Neubau ~45,6 h @16W -- der Bruch ist gewollt LAUT und EINMALIG.
3. ANKER-REGEL: Wachen (static_asserts, Gates) ziehen IM jeweiligen Schritt mit (compile-hart);
   Byte-/Hex-/CRC-ANKER werden EINMAL am Ende (B-10) live gemessen und gesetzt -- nie je Schritt, nie
   als Delta addiert (Lande-Regel v4.2/A2.1b).
4. T-1-PFLICHT je Schritt: neuer/gezogener Test ZUERST ROT am Alt-Stand (bzw. CT-Negativ-Probe), dann Edit,
   dann gruen. K13-KOEDER je Gate: die Koeder-KLASSE steht unten je Schritt; der konkrete Wert/Ort wird BEIM
   BAU GEWUERFELT (nicht hier festgelegt); jeder Koeder muss nachweislich BEISSEN (Literal-Output), Koeder-
   Literale in Commit-Texten maskieren (stdin-Wache-Falle 14.08.).
5. A-14-REGEL: KEINE flaechigen algo_version-Bumps. Der Bruch verlangt Digest-REGEN (Lock --write), keinen
   Versions-Sturm. Einzige echte Version-Bumps: #70 (axis_filter_xor, X.Y.Z echt groesser) und
   kCebContractCodegenMinor 1->2 (deklarierte Bucket-Invalidierung, Praezedenz A13-M4/W10-M2/B14-NB4).
6. A-13 EISERNE REGEL gilt BIS zum Bruch-Worktree: nichts unter axes/ topics/ heuristik/ (de facto auch
   anatomy/) anfassen. IM Bruch faellt sie (Format 5 verschiebt ohnehin alles); NACH der Landung gilt sie
   wieder fuer alle Straenge.

## 1 VORLAUF VL-1..VL-6 (vor dem Bruch; identitaets-/golden-neutral, eigene kleine Landungen erlaubt)

### VL-1  S-6b TRANSPOSITIONS-SPERRE (A-10-Teil; Vorzieher explizit erlaubt, KON7-10/4)
DATEIEN  anatomy_fingerprint.hpp (benannte Traeger-Typen fuer organ/system/measurement-Zeile nach
         K-1-Muster :221-288), Nachzug der 47 Aufrufstellen von _hex/_glieder in 12 Dateien
         (lazy_adhoc_source_gen, ceb_version_stamp, bestandslog_index, anatomy_module_abi_v1 + 8 Test-TUs).
WACHEN   keine bewegt; golden-CRC/320er/Riegel/Preimage-Bytes unberuehrt (Beleg gruppe3 Abs.2b: Typen leben
         in der Makro-EXPANSION; Werte unveraendert). Floor NUR bei neuer ctest-Registrierung (dann 3
         Sprossen im selben Change).
ABNAHME  T-1: CT-Negativ-Probe (Zeilen-Vertauschung via is_constructible/requires) erst "kompiliert still"
         dokumentieren, nach Sperre bricht sie laut. ctest Debug+Release gruen.
KOEDER   K13-Klasse: absichtliche Vertauschung zweier Zeilen-Argumente an gewuerfelter Aufrufstelle -->
         MUSS Compile-Fehler geben; Probe committen als Negativ-Test, nicht als Live-Code.

### VL-2  LAUTE POD-VORSTUFE (Regel "erst laute Compile-Fehler, dann verschieben")
DATEIEN  anatomy_module_abi_v1_decl.hpp (Feld-UMBENENNUNG oder Traeger-Typen), designierte Initialisierer
         an den DREI positionalen Literal-Stellen: decl-Probe :293-295, test_d2_mess_konsistenz_gate :82-96,
         test_m_w12_stamp_bausteine :1296-1304.
GRUND    Falle (gruppe1 3b): (i) POD-Append laesst 16er-Aggregat-Inits still value-initialisieren (nullptr
         bricht ""-Doktrin STILL); (ii) S-6a-Tausch gleichtypiger Felder kompiliert still und vertauscht
         Werte. Diese Vorstufe macht B-5 laut.
ABNAHME  T-1: Probe mit absichtlich vertauschten Feldern erst still-gruen (Beleg), nach Umbau laut-rot.
KOEDER   K13-Klasse: ein gewuerfeltes Feld-Paar tauschen -> Compile-Fehler Pflicht.

### VL-3  --debug-CLI-FLAG DER PLANER-SHELL + AdmissionStatus-UMHAENGUNG (A-05-Vorbau)
DATEIEN  Planer-Shell (CLI-Flag, fuer Anwender GESPERRT lt. Ledger), axis_error.hpp:169-178.
GRUND    MUSS existieren, BEVOR Debug das Enum verlaesst -- sonst verliert m3_smoke_coverage:172 seinen
         Traeger ersatzlos (Gate tests/unit/CMakeLists.txt:3784-3791).
ABNAHME  T-1: Shell-/Parser-Test erst rot. Floor bei neuer Registrierung nachziehen.
KOEDER   K13-Klasse: --debug von Anwender-Kontext aus -> muss abgewiesen werden (Sperr-Probe).

### VL-4  prod2-VORHER-BELEG FIXIEREN (A-08-Vorbau, ausser-Repo)
Der 09.08.-Live-Beleg existiert (Ledger Z17243-17247, Job 368969: "12th Gen i9-12900K", Alder Lake);
Host aktuell durch Infra #207 gesperrt. Owner-Anerkennung des Belegs = OWNER-VORAB V-09. Kein Code.

### VL-5  DOKU-BUCHUNGEN OHNE BYTE (super-Repo, docs-only)
(a) golden-Nachposten a (all_axes_golden '--' + Flag): BEIDSEITIG ERLEDIGT seit 08.08. (ce 90a31961,
    super 2983e9ba) -- im Wellenplan-Zusatz als erledigt buchen. (b) Wellenplan Sec.19.1-Zusatz
    praezisieren: VS-A..VS-F ENTSCHIEDEN 07.08. abend-23 (Ledger :27970-27979), Ausfuehrung A/B/C/D offen,
    E/F gebaut; r3 A1/A3/A4 GEHEILT (06.-07.08.); O-2 am Objekt GEHEILT (s. Abs.8). (c) Vorlage
    20260807-OWNER-VORLAGE-stopp-gates als historisch markieren. (d) E-B-golden-Fenster-Zuordnung
    AUSDRUECKLICH buchen: E-B faehrt im #15-golden-Ereignis (gruppe7-Pflicht 1). (e) Wellenplan-
    Vorbestands-Defekt Z.2193 (Sec.18.8-Ueberschrift klebt) als Kleinfix mitnehmen.

### VL-6  RESTE-EXPLORES (ZEHN-WOCHEN-Regel; Ergebnisse VOR B-1 vorlegen)
(a) S-6d-NEUERHEBUNG mit deklarierter Zaehlweise (heute 23 Familien-Dateien; 142er-Zahl unbelegt per
    KON61-05; Owner-GO "explore und schaerfen, behalten" liegt). (b) r3-A15 (F5-Halbsatz XML-Syntax/
    Semantik + Planer-Interpreter): von KEINER Karte vermessen -- Bestands-Explore, erst danach ggf.
    Frage; nach Kartenlage NICHT bruch-gekoppelt. (c) KON60 Wallclock-START-Grenze: Bestands-Explore,
    dann ggf. Owner (nicht B3-blockierend, gruppe5).

## 2 DER BRUCH B-1..B-11 (EIN Worktree, EIN Schreiber, Commit-Serie, am Ende EIN Push je Repo)

Voraussetzung: OWNER-VORAB-15 V-01..V-13 beantwortet (mindestens V-01..V-08, V-10, V-11; s. dort).
decl.hpp + anatomy_fingerprint.hpp werden NUR in B-5 angefasst (Wellenplan-#15-Fessel P3-vor-P5,
ein Schreiber). Zwischen-Commits muessen KOMPILIEREN; Test-Anker duerfen bis B-10 rot stehen
(Gates laufen vor dem Push, nicht je Commit).

### B-1  A-02 BUDGET-HEBUNG (anatomy_fingerprint.hpp, Konstanten-Teil)
DATEIEN  anatomy_fingerprint.hpp :68 (kAnatomyFingerprintPreimageMax), :464-478 (neue Glied-Max-Konstante
         kHybridMap...Max aus der OWNER-Grammatik V-02 gerechnet: 32 Docks x (128-hex-SHA + Key/Trenner)
         >= ~4,6 KB), Budget-Beleg woertlich im Header (:59-67-Muster, KON45-01(5)/KON58-11d).
WACHEN   :480-483 BudgetSum<=Max zieht automatisch; consteval-Puffer :742 folgt der Konstante.
ABNAHME  T-1: static_assert-Probe "neue Konstante traegt Summe+Hybrid" erst rot (alte 4096), dann gruen.
KOEDER   K13-Klasse: Budget-Zeile um 1 Byte zu klein wuerfeln -> BudgetSum-Assert MUSS beissen.
HINWEIS  Wert-Philosophie: Ist-basiert MIT Beleg (Haus-Muster, autonom); Obergrenzen-Rechnung (~33 KB
         Grammatik-Maximum) als Kommentar-Beleg daneben. Spaetere Hebung ist byte-neutral moeglich.

### B-2  A-09 + A-06-KLASSE-C NAMENSZUG (id-/golden-wirksam; Namen aus OWNER-VORAB V-11)
DATEIEN  EIN Zug ueber alle 5 Traeger-Klassen, ERST Enum (laute Compile-Fehler), DANN XML:
         (1) anatomy/pruefling_merge.hpp :131-135 Enum + MergeImpl :226-234 + Q2-Wachen [Lock-Record :113,
         anatomy/ rekursiv im Overlay-Schnitt -> Glied [7]]; (2) Projektionen merge_plan.hpp :40-71,
         validate_profile.hpp :617-627/:665/:960-975/:1099-1122 (+ Fehlertexte!), sota_catalog.hpp :92/
         :235-240/:344-357; (3) 18 Kompositions-Namen prt_art_merge_reference.hpp :161-186 +
         permutation_engine.hpp :244/:253 (AxisFullJoin); (4) Profile-XML: m3_smoke :120-126, m3_golden
         :102-108, m3v2_study :114-120, all_axes_golden :102-108, cacheline_study :119 + Fixture
         golden_kern.xml :9/:40/:43-46; (5) SUPER-XSD Code/test_data_xml/experiment_schema.xsd
         (CROSS-REPO, fixture_schema_subset_check.cmake :19/:96) -- Edit im lokalen super-Baum,
         Landung s. Abs.6. Klasse-C-Traeger: xml_config_parser.hpp:415/.cpp:498-509, sota_catalog
         :616-646. "Weg a" (Fixture-Rename) NUR falls V-11 ihn bejaht.
WACHEN   ziehen mit: test_experiment_projection :63-68 (Stempel-Key-Pin -- Anker-Neusetzung erst B-10),
         test_s3_ordnung_freigabe (6 TESTs) + test_experiment_kern_seam (15 TESTs), Subset-Wache,
         validate-Fehlertexte. golden-id-CRC BEWEGT SICH DEKLARIERT (Re-Anker in B-10).
ABNAHME  T-1: neuer Kollisions-Test "FullJoin-Wort nur noch KON91-Traeger" erst rot am Altstand.
KOEDER   K13-Klasse: ein gewuerfelter Alt-Name-Rest (Enum/XML/XSD) stehen lassen -> Subset-Wache bzw.
         Compile MUSS beissen; erst dann vollstaendig raeumen.

### B-3  A-08 prod2-RENAME + REGISTRY-REGEN (Token aus OWNER-VORAB V-09)
DATEIEN  machine_simd_signature.hpp :90-92 (+Wachen :112-127), target_isa_complex_axis.hpp :134-141 +
         static_asserts :151-218 [Lock-Record axis_version.lock:1391, Overlay-Schnitt system_axes-Praefix
         -> Glied [7]], machine_identity.hpp :191/:250/:444, Planer-Kommentare experiment_plan_director
         :751/:761-762, Tests (test_stempel_vollbestand_registry :58 u.a.).
REGEN    comdare_system_axis_registry_gen laufen lassen -> system_axis_registry.xml :23/:180 committen ->
         Roundtrip (tests/unit/CMakeLists.txt:5738-5746) gruen. J-1: Tools zuerst, RE-CONFIGURE, Vollbau.
WACHEN   Roundtrip-Byte-Gate; Lock-Digest-Drift (Regen erst B-10, bis dahin lokal rot = erwartet).
         NICHT betroffen: golden_kern id="prod2" (Schluessel), CI resource_group/Tags (Host, nicht Etikett).
ABNAHME  T-1: static_assert :444 auf neuen Token erst rot, dann gruen.
KOEDER   K13-Klasse: Registry-XML von Hand um 1 Byte aendern -> Roundtrip MUSS beissen (nie-von-Hand-Regel).

### B-4  OVERLAY-QUELLTEXT-POSTEN (alle Glied-[7]-wirksam; genau deshalb JETZT im Fenster)
(a) #70 XORFILTER OFFLINE-PEELING (KON80-01 V1 = DIREKT, W1-Posten): axis_filter_xor.hpp :39-62/:80-83
    Umbau auf build_from_sorted_keys-Vorbild (exact_prefix :73, louds_sparse :165, surf-Concept :32);
    algo_version "1.0.0.c" -> echt groesser (:118); GEPINNT-Zeile test_s5_02b :276-278 auf ==0 drehen,
    :273-275 um xorf erweitern, Kommentare :266-272 + Header :49-62 nachziehen; topics-Kopie nur bei
    Beruehrung. Mess-golden: deklariertes Ereignis "Filter-Zelle" (Owner-Wort liegt). FN-Ausweisung
    (Owner-Auflage A3) gilt fuer ALT-Messwerte weiter.
    ABNAHME T-1: no-FN-Test (30/256-Repro) erst rot, nach Peeling gruen. KOEDER: Lock-Koeder-Klasse A/B
    (Drift ohne Bump) MUSS Exit 1 geben, gewuerfelte Datei.
(b) G4-2a HUELLEN-DURCHREICHUNG: name()/algo_version-Delegation in organ_axes/lookup/composable/
    (ObservableComposedContainer + Composed*-Familie, <=65 Dateien, real nur vom Referenz-/Mapping-Pfad
    erreichte) -- reine Delegation auf das innere Organ, KEINE Versions-Bumps (A-14!), KEIN Tabellen-
    Lookup im Tier (abi->builder VERBOTEN, stempel_basis.hpp:6).
    ABNAHME T-1: organ_stamp_line<echte Referenz-Komposition> vorher Compile-rot (Member fehlen),
    nachher gruen. KOEDER: eine gewuerfelte Huelle ohne Delegation lassen -> Wache/Compile MUSS beissen.
(c) axis_centric_namespaces.hpp:24 "17"->18(+1) REAL fuehren (fehlend: queuing_q1/q2, persistence_target;
    zu viel: telemetry, isa) -- Glied-[7]-neutral (Ausschluss-Liste D1), aber Fassade muss stimmen
    (r3 A10: keine reine Nachbuchung).

### B-5  KERN-COMMIT (ATOMAR; einziger Schreiber auf abi/; alles compile-gekoppelt)
(a) anatomy_fingerprint.hpp EIN Edit: HybridMap-Traeger-Typ (K-1-Muster; leer==Identitaet, Tier reicht "";
    Nie-Leer-Doktrin :532-535 gilt NUR MessGates -- nicht kopieren) + Glied-FOLGE nach OWNER V-01
    (Empfehlung: Schwanz [9], R-3-Praezedenz) + Count=10 + Format="fingerprint_format=5" + A-07-Felder
    (Tiefe + Stufen-IDs, Form nach OWNER V-04) IN der Hybrid-Zeile + Positions-Beweise :609-627 neu +
    Overlay/MessGates-Positions-Asserts :633-637 NEU FORMULIERT (Kartendissens gruppe1 vs gruppe5, s.
    Abs.8 -- am Objekt beweisen, nicht abschreiben) + Kopplung :643-648 auf 10/5 + K-1-Sperren-Text
    :767-780 (+neuer Schwanz-Slot).
(b) anatomy_module_abi_v1_decl.hpp SELBER Commit: kAnatomyVersionLinesLayout=7 (:267); S-6a-POD-
    Umsortierung MESS,SYSTEM,ORGAN (per OWNER V-01/V-03; SYSTEM bleibt Preimage-Glied [2] -- entschaerft,
    gruppe3 1a); POD-Appends hybrid_map_line/len + (falls V-05=POD) name_line/len -> sizeof-Pin 120->136
    bzw. 152 (:274-277); Gleichheits-Wache ==7 (:286-288, K-4: NIE >=); CT-Proben :301-307 NEU:
    7=true, 6=FALSE (K-4-Lehre: andere Offsets!), 5=false, 8=false; Leser-Doktrin-Text :231-232;
    Probe-Konstruktor :294 (Aritaet); kCebContractCodegenMinor 1->2 (:502, im SELBEN Commit --
    test_v41-Pin :126-128 verlangt es woertlich).
(c) anatomy_module_abi_v1.hpp: Makro-POD-Initializer designiert (nach VL-2), _hex-Aufruf mit HybridMap-
    Glied (2/3-arg-Formen bleiben; CEB reicht NICHT, Glied leer -- R-3-Praezedenz :113-118);
    Makro-SIGNATUR-/Argument-Tausch auf (mess,system,organ) NUR falls OWNER V-03 = ja; dann
    adhoc_emitter.hpp :126-138 im selben Commit (emittierte Reihenfolge = golden-Ereignis, gedeckt
    durch die EINE Buendel-Freigabe).
(d) A-05 work_mode SELBER Commit (gruppe2: "nie separat"): run_methodology_registry.hpp -> work_mode-
    Vokabular, Enum {Build=0,Measure=1,Compare=2,Release=3} (Ordinal-Doppelschub Release 2->3,
    Compare 3->2; OWNER V-12-Bestaetigung), kWorkModeCount=4, Build-Zeile {Build,"build","Build",
    "Release",false,false}, Registry-Zeilen-Ordnung == Enum-Ordnung; 10 Konsumenten-Dateien nachziehen;
    measurement_axis_registry.xml TODO :59-60 -> generierte work_mode-Unter-Achsen-Zeile via
    measurement_axis_registry_gen (J-1-Rezept) + Roundtrip; m3_smoke:172 auf State+--debug migrieren.
(e) [8]-HYBRID-GATE-FELDER (B3-Vorbau): mess_gates_glied.hpp Grammatik um die Hybrid-Gate-Felder
    erweitern (KON37-03 Subset-Modell 2x2; Nenner 32 bleibt PROGRAMM-Deckel, Mengen rechnet S-19 --
    NIE statisch vorlegen); Feld-Zaehl-Wache :393-394 + AUS-Form-Anker :457-460 + Binde-Assert
    :399-405 mitziehen. JEDE TU bekommt neuen Glied-Wert -> gehoert exakt HIERHER, nie danach.
(f) CEB-SEITE: kCebFingerprint bewegt sich durch Format 5 zwingend mit (rechnet ueber _hex :592-598);
    Legenden-KANONISIERUNG (permut. Zwillinge) NUR falls OWNER V-13 = ja: ceb_tooling_list :384-425
    kanonisch sortieren + Kopf :86-101 nachziehen. Kopf-Drift :64-65/:566-567 (Toolchain/bvset)
    autonom heilen (gruppe5 P1d).
(g) D-2-GATE + POD-LESER SELBER Commit: mess_konsistenz_gate.hpp :56/:113/:142/:240-241/:346 auf ==7
    (SONST faellt JEDE Tier-Binary fail-closed = still-rot); anatomy_module_loader.hpp :142 Doku;
    POD-Leser: anatomy_version_stamp, meta_meta_stamp_suffix, bestandslog_factory (:66/:84 folgen Count;
    :87 "Format 3: acht" stale raus), cache_engine_builder_iterator, experiment_run_entry, sota_catalog.
(h) STALE-TEXTE in beruehrten Dateien: mess_achsen_naht :186 ("= 8"), build_orchestrator :339 +
    L14 :332-336/:343 (Overlay-"noch leer" ist falsch), ceb_version_stamp :71,
    bestandslog_document.hpp:22-26 (r1 A28).
WACHEN   ziehen mit (Liste = Pruefliste): fingerprint :116/:416/:480/:609-627/:633-648/:767-780;
         decl :192-194/:267/:274-277/:286-288/:301-307; mess_gates :340-405/:450-460; registry-
         static_asserts :111-148; ceb_version_stamp :232-240/:649-652; test_v41 :126-128;
         test_experiment_parser :725-736; Suite MeasurementModi61; test_45_parallel_measure_loop;
         test_smoke_coverage_profile (CMakeLists :3784-3791); test_d2 (mach_pod designiert);
         test_m_w12 :673-681/:685(offsetof wandert bei S-6a!)/:703-705/:757/:1296-1304/:1394-1424.
ANKER    NOCH NICHT setzen (B-10): frozen kFrozenFingerprintV1, test_d4:194, e24-Leer-Digest-Pins,
         w10-Hex-Pins.
ABNAHME  T-1: neuer Erwartungs-Test (Count==10, Format-5-Literal, Layout==7, Proben 6=false) ZUERST rot
         am Altstand; nach Edit gruen. Kompiliert als EIN Commit; ctest darf bis B-10 an Ankern rot sein.
KOEDER   K13-Klassen: (i) POD-Feld-Tausch-Probe -> muss nach VL-2 laut brechen; (ii) Glied an falscher
         Position einhaengen -> Positions-Beweis MUSS beissen; (iii) Format-Literal 4 lassen ->
         Kopplungs-Assert MUSS beissen. Je 1 gewuerfelt, Ergebnis literal protokollieren.

### B-6  E-A NAMENSFUNKTION + G4-1 INTERFACES (nach B-5: Name ueber dem NEUEN Preimage)
DATEIEN  neue consteval SHA-256/64-Hex-Namensfunktion ueber DASSELBE Preimage (Primitive existieren:
         src/sha256/ctsha.hpp + src/sha512/ctsha512.hpp); Kommentar-Auflage an der Bau-Stelle:
         "EIGENER Hash, KEIN fingerprint[0:64]" (Ledger :27981-27986). Tier-/Hybrid-Erbinnen nach
         P4/P5-Muster (stempel_basis-Matrix :100-117 + 28-Zellen-Pin :127-137 mitziehen; Vertragstest
         T-3 test_s1); Planer-SHA-Fuellung (planner_version.hpp :80-84) NUR nach OWNER V-08;
         CEB-system_zeile-Luecke (ceb_version_stamp :628-637, KON8-03-Bauauftrag) fuellen;
         Name ins POD nur falls OWNER V-05 = POD (dann war das Feld schon in B-5b!).
WACHEN   stempel_basis-Pins, planner_version :108-132, S-1-Tests (GliedCount-neutral, brechen nicht).
ABNAHME  T-1: Namens-Test (64 Hex, != fingerprint-Praefix, deterministisch) erst rot. Floor-relevante
         neue Tests notieren (B-10).
KOEDER   K13-Klasse: Namens-Funktion absichtlich als Praefix des Fingerprints implementieren (Probe) ->
         der Ungleichheits-Test MUSS beissen.

### B-7  E-B EMITTER-NAME + GATTUNGS-MAKROS + A-11 PFLICHTSCHALTUNG (EIN Zug; Owner-Setzung liegt)
VORAB    Ledger-Nachtrag :27970-27979 am Roh-Text NACHLESEN (OV-Doktrin; gruppe6 kannte ihn nicht --
         Konflikt in Abs.8 dokumentiert). E-B = Variante (i), Owner-SETZUNG "Wir brechen golden-CRC!";
         Kommentar-Auflage: "SETZUNG, nicht aus dem Code" (r5 C8) + Lagerhaltungs-Befund (key_sha512
         bleibt Identitaet, 4 Belege).
DATEIEN  Emitter SYMMETRISCH (sonst bricht die 320er-Selbstkonsistenz): lazy_adhoc_source_gen +
         Katalog-Gen + adhoc_emitter; Emissions-Stellen sota_catalog :172/:248, profile_run_entry :579.
         Gattungs-Makro-Stempel-Nachzug per OWNER V-06: set_/sequence_/view_/adapter_module_abi_v1.hpp
         (heute 0 VERSION_STAMP-Treffer). A-11: Loader anatomy_module_loader.cpp :121-141/:164-167 --
         5. Symbol wird PFLICHT; NEUER Status-Code (heute 0..8); Konsumenten f15_compare/main.cpp
         :240-241, perm_runner.hpp; D-2-Status stempel_symbol_fehlt wird toter Zweig -> Gate +
         test_d2 umbauen (Pruefung wandert an den Loader); Test-Minimalmodule genus_module_* als
         Negativ-Proben umwidmen oder stempeln.
WACHEN   320er-Round-Trip (symmetrischer Einbau haelt gruen); golden-id-CRC bewegt sich NICHT durch
         E-B (Name != binary_id) -- Bissprobe in B-11 MUSS [MATCH] geben, [MISMATCH] = Baufehler.
ABNAHME  T-1: Loader-Test "DLL ohne 5. Symbol wird abgewiesen" erst rot (heute erfolgreiche Ladung).
KOEDER   K13-Klasse: gewuerfelte Fixture-DLL ohne Stempel bauen -> Pflicht-Gate MUSS mit neuem
         Status-Code beissen.

### B-8  B3 WURF-UMZUG + B5-STEMPEL-PFLICHT + A-03-RT-SEITE (nach Gate-/Glied-Existenz)
(a) B3 (A-12): H-1-Pflicht-Wurf mess_achsen_naht.hpp :477-517 faellt zugunsten der CEB-Entscheidung
    (KON37-01 Vererbungsregel: CEB baut hoehere Stufen nur nach EIGENEN Messeigenschaften); Ersatz-Wurf
    an der CEB-Konfig-Wache (autonom am Objekt); KEIN physischer Umzug; Tier-Gates BLEIBEN; Tests
    test_m1h_stufen_und_pmc_wache umbauen; w-Sicht-Umbaupunkte g1_binary_version_stamp.hpp +
    CebVersionen-Alias (mess/konfiguration.hpp:40-44). Achtung Karten-Korrektur: der Wurf sitzt in
    mess_achsen_naht, NICHT abi_adapter :476-491 (Datei-Fehlbuchung in KON34/37; gruppe5).
(b) B5: Stempel-Pflicht je Schalter NACH S-5-Rest (Tier-/Hybrid-Komposita aus B-6); PMC-Muster als
    Vorlage (ceb_version_stamp :275-345); Registry-Homes sind Lock-gedeckt (mess_axes = 1 Record).
(c) A-03-RT-SEITE (HY-A2-Anteil): RT-Cache am Dock + Invariante RT<=CT als Wache (Map-VALUE =
    Tier-SHA, KON47-02 = Fakt); CT-Seite (Glied [9]) kam in B-5.
ABNAHME  T-1: (a) Test "CEB ohne wallclock baut, wenn CEB-Menge es traegt" erst rot; (c) RT>CT-Probe
    MUSS abgewiesen werden. KOEDER K13: gewuerfelter Schalter ohne Stempel-Feld -> Feld-Zaehl-Wache
    :393-394 + Spiegel-Test MUESSEN beissen.

### B-9  telemetry-silent-SCHNITT (golden-Nachposten b; build_version-wirksam -> gehoert in den Bruch)
DATEIEN  profile_run_facade.cpp :249-251 (konstant false faellt; liest Profil-Attribut), :549-553
         (Registry-Gate: nur wenn "telemetry" als System-Achse gefuehrt -- Registry-Stand VORHER pruefen,
         sonst emittiert der Schnitt ins Leere); NEUES Parser-Feld fuer silent (heute liest KEIN Code
         das XML-Attribut; 11 Profile tragen silent="true").
WACHEN   +tel=-Token-Ordnung system_version_suffix :58/:68/:227; test_m_w12:1040 (Token-Mechanik).
         golden-id-CRC NICHT betroffen (binary_id Organ-only); build_version/.version-Sidecars wandern.
ABNAHME  T-1: Facade-Test "silent-Profil -> +tel=silent" erst rot. KOEDER: gewuerfeltes Profil ohne
         Registry-Achse -> darf KEIN Token emittieren (Gate-Probe).

### B-10 DER EINE ANKER-ZUG (alle Zaehlwerke EINMAL live; keine Delta-Addition)
REIHENFOLGE (J-1..J-4 vorweg: Werkzeuge adhoc_emitter_cli, anatomy_codegen_cli, alle *_registry_gen
bauen -> RE-CONFIGURE -> Vollbau; VORSICHT: getrackte Mess-CSV im ce-build-Verzeichnis -- nie loeschen):
 1. axis_version_lock --write: Digest-Regen fuer ALLE beruehrten Schnitt-Dateien (B-2/B-3/B-4/B-8);
    Record-Zahl MUSS 718 bleiben (kein Datei-Zu-/Abgang; Umbenennungen: verwaist->Regen, Zahl konstant).
 2. Registry-Roundtrips: system_axis_registry, measurement_axis_registry, cache_engine_axis_registry --
    Byte-Diff == 0.
 3. gen_golden_fullpilot --crc64: neuen id-CRC LITERAL uebernehmen -> source_catalog.hpp:191 +
    Protokoll-Kommentar erweitern (Praezedenz 26.07.); TABU-Pin test_e24_c10_g6 :114 (kCrc64AnkerVorC8)
    + :239 mitheben; die VIER Alt-Wert-Kommentarstellen (source_catalog :184/:188, sota_catalog :183,
    merge_plan :15, anatomy_fingerprint :16) als Historie kennzeichnen. Owner-GO fuer den neuen
    TABU-Wert liegt ueber die Buendel-Freigabe V-03 (literale Vorlage bei der Landungs-Meldung).
 4. Frozen-/Hex-Anker EINMAL messen: kFrozenFingerprintV1 an ALLEN DREI Fundstellen im SELBEN Commit
    (test_g3 :89-96, test_w10, test_m_w12); test_d4:194 CEB-Key (Historie :187 fortschreiben);
    e24-Leer-Digest-Pins; w10-Hex-Pins; test_experiment_projection-Key-Pin (B-2).
 5. Floor: scripts/ci_test_inventory_floor.txt -- ALLE DREI Sprossen (avx512f/avx2/basis; heute
    495/491/489) LIVE je Host-Klasse nachmessen (EXAKT-Anker, Exit 4 in beide Richtungen; das Buendel
    bringt neue Tests, die Sprossen WERDEN sich bewegen).
KOEDER   K13 je Anker-Werkzeug, gewuerfelt: Lock-Drift-Koeder (Exit 1), Floor-Off-by-one (Exit 4),
         CRC-Probe gegen absichtlich alten Anker ([MISMATCH] muss erscheinen, dann echter [MATCH]).

### B-11 BISSPROBEN + KOMBIBAU-ENDABNAHME (KON55, 4 ZELLEN)
 1. axis_version_lock --check Exit 0; Tripwire-Test gruen; 718 Records bestaetigt.
 2. gen_golden_fullpilot --crc64 [MATCH] gegen den NEUEN Anker (prueft zugleich: #70 und E-B haben
    KEINE id bewegt).
 3. 320er-Round-Trip (test_lazy_adhoc_source_gen) gruen; xml-Wache (ci_xml_wellformed_guard) gruen;
    s5_02b in neuer Form gruen; ci_test_coverage_guard Exit 0.
 4. KON55-KOMBIBAU: 4 Zellen = {gcc 15.3, clang 22.1.8} x {Debug, Release}, LOKAL, je Zelle
    "100% tests passed, 0 tests failed out of N" mit N = live gemessene Floor-Sprosse der Host-Klasse
    (Praezedenz KON98: 4x woertlich protokollieren). Google-Tests, keine Shell-Proben.
 5. Warnungs-Review ZWEIMAL: GCC-Lauf -> aufraeumen -> Clang-Bau -> Clang-Lauf.
 6. ASCII-Gate + Selbstcheck-Zeile; ugrep-stille-Null-Falle beachten (Fallen-Register).

## 3 POSTEN->SCHRITT-MATRIX (Vollstaendigkeit Sec.19.1)

  A-01 10. Glied................ B-5a/c        A-08 prod2................... VL-4 + B-3
  A-02 Preimage-Budget.......... B-1 (+V-02)   A-09 FullJoin-Rename......... B-2 (+V-11)
  A-03 Synthese-Key/RT<=CT...... V-02(Grammatik Owner) + B-5a(CT-Glied) + B-8c(RT-Dock)
  A-04 Folge+AxisKind........... OWNER V-01 -> vollzogen in B-5a/b
  A-05 work_mode................ VL-3(Flag) + B-5d                        A-10 S-6-Schnitt komplett:
  A-06 Stufe/Phase.............. Klasse C: B-2 | Modi-Prosa: B-5d |        S-6a B-5b/c | S-6b VL-1 |
       Klasse A (batch_planner). N-3 (ordnungsfrei)                        S-6c N-1 | S-6d/#67 VL-6a+
  A-07 Rekursions-Felder........ OWNER V-04 -> B-5a                        B-4(3 Schnitt-Dateien)+N-2 |
  A-11 5.-Symbol-Pflicht........ OWNER V-06 -> B-7                         Verbotszonen: Dauer-Regel
  A-12 B3 Schalter-Hoheit....... B-5e(Felder) + B-8a                     A-13 Eiserne Regel: Abs.0/6
  A-14 keine Literal-Bumps...... Regel in B-4b/B-10 (einzige Bumps: #70, Codegen-Minor)

  ZUSATZLISTE: kCebFingerprint-Angebot (r3 A1) GEHEILT 06.08. -- Rest = Legenden-Frage V-13 -> B-5f |
  COMDARE_MEASUREMENT_ON (r3 A3) GEHEILT 07.08. (Glied [8]; Mitzug B-5e/g) | O-2 cxx/opt/bt+bvset AM
  OBJEKT GEHEILT (Fakt, s. Abs.8 -- KEINE Owner-Frage mehr) | VS-A..VS-F ENTSCHIEDEN 07.08. (E-A B-6 |
  E-B B-7 | E-C N-4 | E-D F5-Fenster, NICHT Buendel | E-E gebaut, Regel Abs.0/6 | E-F vollzogen) |
  Versionierungs-Interface + CT-Namensfunktion V-05/-07/-08 -> B-6 | run_methodology-Ordnung V-12 ->
  B-5d | all_axes_golden (r3 A12) ERLEDIGT 08.08. -> VL-5-Buchung | F5-Halbsatz (r3 A15) VL-6b-Explore |
  telemetry-silent (r4 A-01) B-9 | bestandslog_document:22-26 (r1 A28) B-5h.

  GOLDEN-NACHPOSTEN: a=VL-5-Buchung (erledigt) | b=B-9 | c=B-7+B-10.3 | XORFILTER-LANDEANTEIL: B-4a.

## 4 WACHEN-/ANKER-NACHZUGSPUNKTE (wann zieht was)

  SOFORT im Schritt (compile-hart): alle static_assert-Cluster der Abs.2-Schritte; D-2-==7 (B-5g!);
  Feld-Zaehl-/Binde-Wachen [8] (B-5e); Registry-Anker (B-5d); Subset-Wache (B-2, cross-repo).
  EINMAL in B-10: Lock (718, --write), Floor (3 Sprossen live), golden-id-CRC + TABU-Pin, frozen-
  Vektor (3 Fundstellen, EIN Commit), CEB-Key d4:194, alle Hex-Pins, Roundtrips.
  IN B-11: --check/--crc64/320er/xml/coverage/KON55-Bissproben.
  NIE anfassen (VERBOTSZONEN, gruppe3 Abs.5): Lager-Kaskaden (BEIDE Welten), kOrganGruppen*,
  kSystemAxisOrder, kCompositionAxisNames, Hash-Mechanik (Separator/Injektivitaet/EINE Preimage-
  Konstruktion/sha512-Primitive), Messwert-2-Tupel. S-6a/S-6c LESEN Ordnungs-Quellen nur.

## 5 LANDE-CHOREOGRAFIE (ein Worktree, ein Schreiber, Gates, EIN Push)

 1. EIN Worktree "buendel15" auf ce development (Nested-Worktree-Regeln: vor remove Submodul-Branches
    + .git/worktrees/<n>/modules-Kinder pruefen); EIN SCHREIBER (git commit nimmt die ganze Staging-
    Area); parallel wird NICHT in diesem Worktree gebaut -- parallel bauen, sequentiell landen gilt,
    aber dieser Bruch ist EIN Strang.
 2. Commit-Serie B-1..B-10 wie oben; Zwischen-Commits kompilieren; Anker-Rot bis B-10 erlaubt.
 3. GATES lokal VOR dem Push: B-11 komplett (KON55 4 Zellen, Bissproben) + Diff-Hygiene PUSH-LOKAL
    ueber den Push-Bereich (nie kumulativ) + gitleaks im Push-Bereich (stdin-Modus MIT --config;
    Koeder MUSS aus einer Config-Regel stammen, glpat-Muster; Nenner "N commits scanned" protokollieren)
    + ASCII-Gate. EIN gruenes Gate deckt nur seinen Gegenstand: geprueft/nicht-geprueft BEIDE nennen.
 4. LANDUNG HARMONISIERT: Ueberschneidungen an Vertrags-/Interface-Flaechen (stempel_basis-Matrix,
    Loader-Vertrag, Registry-XMLs) harmonisieren, nicht nur mergen; Auto-Merge dort = Anfangsverdacht.
 5. EIN Push je Repo, Reihenfolge: (a) ce: EIN Push development -> origin + github (Dual-Remote);
    (b) super DIREKT danach: Gitlink ce (VORHER merge-base-Pruefung -- Gitlink nie rueckwaerts!) +
    Super-XSD-Anteil aus B-2 + VL-5-Doku im SELBEN super-Zug. Nie rebase, immer merge.
 6. Push -> gruen: GitLab-Pipeline beider Repos verifizieren (Pipelines streng sequentiell; die
    286er-Mess-Pipeline NIE pollen). Kein Erfolgs-Haken ohne Literal-Output.
 7. Rescue-Ref vor dem Push setzen (Praezedenz KON98: refs/rescue/...); BACKUP SOFORT nach
    Fertigstellung (~/backups-workflow, additiv); Worktree erst nach gruen+gemergt loeschen.
 8. Bei Stillstand: journal.jsonl ist die Wahrheit; ZUERST df -h (volle Platte legt Hooks lahm).

## 6 NACHLAUF N-1..N-6 (im Fenster nach der Landung; identitaets-neutral)

  N-1 S-6c/S-21 KATEGORIEN-ORDNUNGS-WACHE: NEU bauen (Nullbefund), NACH dem Bruch (zementiert die NEUE
      Ordnung); ZWEI-WELTEN-AUFLAGE zwingend: je Welt eigene Ordnung (Aussen MESS,SYSTEM,ORGAN;
      Lager-Messdaten MESS->SYSTEM->ORGAN; Lager-Binaries SYSTEM->ORGAN->MESS, D-12) -- NIE eine
      kanonische Folge ueber beide Welten; Vorbild lager_baum_writer :420-467; Fehlerklassen nach
      Par.68a R-A..R-F benennbar (Plan-Artefakt). Floor-Nachzug im selben Change.
  N-2 S-6d-REST: 20 Nicht-Schnitt-Familien-Renames + Kanten-Nachzug (Zaehlweise aus VL-6a deklariert);
      abgestimmt mit #29/#88. R-2-Bezeichner-Vorschlaege im Fenster, Owner bestaetigt.
  N-3 A-06 KLASSE A: batch_planner.hpp :92-110 type_phase_rank -> Traeger-Stufen-Vokabular
      (KON25-07; ordnungsfrei, kostenlos).
  N-4 VS-C SIDECAR-PROVENIENZ: Inhalte auf die Stempel-/Namens-Welt ziehen (nach E-A); Auflage: neuen
      kCebContractCodegenMinor(2) + ABI-Major(9) literal ausweisen ('+ceb='-Wert reist ins Glied [5]).
  N-5 VS-D (Ordner/CSV auf Stempel-Namen + Doppelspalte): NICHT im Buendel -- F5-Fenster vor dem
      naechsten produktiven Messlauf; hart hinter E-A; im Buendel nichts bauen, was die Suffix-Kette
      zusaetzlich zementiert. G4-4 Registry-Umzug/Option B: Korb B (CRC-neutral, entkoppelt).
  N-6 KARTEN-/PLAN-NACHZUG: Wellenplan Sec.19.1 auf diesen Bauplan referenzieren; Plan
      20260806-versionierungs-interface gegen Format 5/10 Glieder neu rechnen (kStampKategorieCount
      existiert nirgends -- bei Wiederaufnahme mitziehen, gruppe1 Abs.6).

## 7 ERSTER NACH-BRUCH-GOLDEN-BATCH (Kostenwahrheit)

  Format 5 laesst JEDEN Tier-Bestand mismatchen (fail-closed Neubau, gewollt, EINMALIG). Der erste
  golden-Batch nach der Landung traegt den Flotten-Neubau (~45,6 h @16W, KON41-01/OV-4). VORHER muss
  die golden-MATRIX final sein (OWNER V-10: AVX-512-in-golden + no_extension-Cross-SKIP) -- sonst
  droht eine zweite Neubau-Welle. Batch erst nach Owner-GO zur Matrix anwerfen.

## 8 KARTEN-KONFLIKTE + AM OBJEKT ENTSCHIEDENES (Fakten, KEINE Owner-Fragen)

  F-1 O-2 (r2 A61 "cxx/opt/build_type + bvset fehlen") ist am HEAD GEHEILT: Toolchain-Glied [5] traegt
      cxx/opt/build_type (toolchain_stamp_glied.hpp :249/:292), Bvset-Glied [6] existiert (Budget 1536).
      Die Wellenplan-Zusatzlisten-Owner-Frage "Option A/B" ist GEGENSTANDSLOS -> Buchung VL-5, keine
      Vorlage. (gruppe5 Drift-Protokoll)
  F-2 VS-A..VS-F: gruppe6 ("E-B ohne Owner VERBOTEN") vs gruppe7 (Ledger-Nachtrag 07.08. abend-23,
      :27970-27979: ALLE sechs entschieden; E-B = (i), Setzung "Wir brechen golden-CRC!"). gruppe7
      traegt den spaeter gefundenen Primaer-Beleg; VOR B-7 den Nachtrag am Roh-Text nachlesen
      (OV-Doktrin: Gegenstand pruefen, nie Nummer). KON80-01 (16.08.) deckt V1-V7, widerruft E-B nicht.
  F-3 Positions-Asserts beim Anhaengen: gruppe1 sagt ":633-635 BRICHT beim Anhaengen", gruppe5 sagt
      "haengt es hinten an, bleiben Count-2/-1 wahr" -- arithmetisch unvereinbar. Bau-Auflage: in B-5a
      werden :633-637 am Objekt bewiesen und NEU formuliert, nicht aus Karten uebernommen.
  F-4 B3-Anker "abi_adapter.hpp:476-491" ist Datei-Fehlbuchung (KON34/37/Ledger); der Pflicht-Wurf
      sitzt in mess_achsen_naht.hpp :477-517 (gruppe5, am HEAD verifiziert).
  F-5 r3 A1/A3/A4 GEHEILT (62a5b6f7 / 2e1f9c1d / 246b2793, 06.-07.08.); Hybrid-Gates = Nullbefund mit
      Gegenprobe; ceb_key_sha512 hat 0 Leser; harte Mess-Defines in perm_mess_defines = 0.
  F-6 golden-Anker heute: kNewGolden131072Crc64 = 0x56F1B721C72DC10E @ source_catalog.hpp:191;
      0xF1C1F26A1232073B ist ALT-Wert an vier Kommentar-Stellen; TABU-Pin-Kopie test_e24 :114.
  F-7 #70 entschieden (KON80-01 V1 DIREKT); E-D-Doppelspalte ist seit F1-Messung SUBSTANZ (Alt-CSV
      extern), bleibt aber F5-Fenster; Flag PROFILE_ALLOW_COMMENT_TEXT_DEFECT existierte im ce NIE,
      im super seit 2983e9ba entfernt.
  F-8 S-14a-Riegel-Grundgesamtheit: 718 = 640 organ + 55 tier_substanz + 16 system + 6 heuristik +
      1 mess; abi/ + builder/ + profile_facade/ + measurement/ liegen NICHT im Schnitt; heuristik/ ist
      Riegel-Kategorie, NICHT Glied-[7]-Quelle. A-13-Wortlaut ist bewusst BREITER als die Byte-Wahrheit.
  F-9 KON55-Endabnahme verifiziert am Ledger (:3942-3990, Praezedenz KON98 :52-56): 4 Zellen =
      {gcc 15.3, clang 22.1.8} x {Debug, Release}, lokal, je "100% tests passed".
