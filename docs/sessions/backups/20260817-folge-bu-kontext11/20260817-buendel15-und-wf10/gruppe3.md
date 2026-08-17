# GRUPPE 3 -- S-6-SCHNITT + VERBOTSZONEN + ORDNUNG (Bump-Buendel #15)

Erhebung: 17.08.2026 am Objekt, ce development @ 04ac26fa (read-only). Jede Zeilenangabe ist HEUTE
nachgemessen; Karten-/Planzeilen sind als Erhebungsdaten markiert. Pfade relativ zu
Code/external/comdare-cache-engine/. NULLBEFUNDE tragen ihre Gegenprobe.

## 1. S-6a -- Umstellung MESS,SYSTEM,ORGAN an den drei Aussen-Ebenen

(a) Fundstellen HEUTE (alle drei Ebenen stehen auf ORGAN,SYSTEM,MESS):
  MAKRO  libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1.hpp
         :162 COMDARE_ANATOMY_VERSION_STAMP_M(organ_lit, system_lit, measurement_lit)
         :213 2-arg-Form (organ_lit, system_lit) -> _M(organ, system, "")
         :186-202 POD-Aggregat-Init kL{layout,0,kO,kSC,kM,kFP,kOE,kSE,kME} folgt der POD-Ordnung
         EMISSION: builder/codegen/adhoc_emitter.hpp:126-130 (2-arg) / :131-138 (3-arg) emittiert
         die Argument-REIHENFOLGE organ,system,mess als QUELLTEXT (golden-gebunden, s. (b)).
  POD    include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp
         :204-205 organ_line/len -> :206-207 system_line/len -> :214-215 measurement_line/len
         :225-226 sha512_line/len -> :233-234 organ_entries -> :240-241 system_entries ->
         :242-243 measurement_entries. kAnatomyVersionLinesLayout = 6 (:267). sizeof==120 (:274-276).
  PREIMAGE include/cache_engine/abi/anatomy_fingerprint.hpp
         :593-605 anatomy_fingerprint_glieder = DIE EINE Quelle; Folge [0]format [1]organ [2]system
         [3]mess [4]valueset [5]toolchain [6]bvset [7]overlay [8]messgates (Karten-Anker ":601" =
         Erhebungsstand; heute return :603-604). kAnatomyFingerprintFormat="fingerprint_format=4"
         (:116). GliedCount==9 (:416, static_assert :643-646). Kopplung Format<->Zahl :647-648.
  Layout-Bump-Konflikt (Wellenplan "decl.hpp:293"): heute Gleichheits-Wache stamp_pod_has_entries
  ==6 bei :286-288; CT-Probe stamp_pod_layout_probe :293-295; K-4-VERBOT von Layout 7 :306-307
  ("ein kuenftiges Layout 7 ist ebenfalls unbekannt"). KON45-01/3-Design: Layout 6->7 + Format
  4->5 + Budget in EINEN Bruch, Wache zieht mit.
  WICHTIG (entschaerft S-6a-Teilrisiko): bei MESS,SYSTEM,ORGAN bleibt SYSTEM auf Position [2] --
  kAnatomyFingerprintSystemGlied=2 (:425), W10-C3-Beweis :609-611 und bestandslog_factory-Bezug
  (:613-615) halten; getauscht wird nur [1]<->[3].

(b) Wachen/Tests/golden, die S-6a bricht oder mitziehen muss:
  static_asserts: decl :274-276 (sizeof 120; bleibt bei reiner Umsortierung, waechst auf 136 falls
    A-01 ein POD-Feldpaar anlegt), :286-288 ==6 -> ==7, :301-307 K-4-Proben neu (7==true, 6==false,
    8==false); fingerprint :633-637 (Overlay=Count-2/MessGates=Count-1: bricht mit Glied 10),
    :638-642 Positions-Monotonie, :643-648 Count+Format. Budget-Kette :464-478 (Teilbudgets+Summe)
    + kAnatomyFingerprintPreimageMax=4096 (:68) = A-02 (Heben MIT Budget-Beleg, 32 Docks > 4,5KB).
  golden: Makro-SIGNATUR-Tausch aendert emittierten Quelltext (adhoc_emitter :126-138) -> 320er-
    Round-Trip-Byte-Wachen + test_lazy_adhoc_source_gen.cpp brechen. Der Katalog-CRC
    kNewGolden131072Crc64=0x56F1B721C72DC10E (profile_facade/source_catalog.hpp:191) haengt an
    binary_id (Organ-only) und bewegt sich durch Stempel-Umbau NICHT (Stempel != binary_id).
  POD-Leser (recompilieren im Bruch, keine Alt-Kompat noetig -- ==7-Gate faellt fremdes Layout):
    abi/anatomy_version_stamp.hpp, abi/meta_meta_stamp_suffix.hpp, builder/bestandslog/
    bestandslog_factory.hpp, builder/pruef_dock/mess_konsistenz_gate.hpp, builder/experiment_tree/
    cache_engine_builder_iterator.hpp, profile_facade/experiment_run_entry.hpp, sota_catalog.hpp;
    Tests test_m_w12_stamp_bausteine, test_w10_system_cell_values, test_r3_*, test_d2_*,
    test_v41_anatomy_module_abi (Pin-Liste decl :496-501).
  S-14a-Riegel 718: NICHT beruehrt -- abi/ + builder/ liegen nicht in der Riegel-Grundgesamtheit
    (Gegenprobe: kOverlaySourceSet-Eintraege overlay_source_set.hpp:132-201 nennen nur organ_axes/,
    topics-Achs-Verzeichnisse, system_axes-Praefixe, mess_axes, anatomy/).
  floor 495/491/489 (scripts/ci_test_inventory_floor.txt:499-501): nur beruehrt, wenn ctest-
    Registrierungen entstehen/fallen; reine Test-ANPASSUNG bewegt den Anker nicht.
  Invalidierungswelle: .fingerprint-Sidecar-Bestand HEUTE 0 (git ls-files + find, nachgemessen
    17.08.) -> Flotten-Mismatch weiterhin kostenlos, solange vor dem ersten golden-Batch.

(c) Reihenfolge-Zwaenge: S-6b VOR S-6a (macht den Tausch compile-laut, s. 2). A-04-Entscheid VOR
  dem Bruch. decl.hpp hat im Buendel EINEN Schreiber (Wellenplan #15-Zeile: P3-vor-P5) -- S-6a-POD,
  A-01-Feld, A-02-Budget, Layout-7-Wache = EIN Commit-Strang. Preimage-Umbau und POD-Umbau
  MUESSEN im selben Bruch wie Format 4->5 landen (F7: sonst stille Kollisionsflaeche).

(d) Entscheide: OWNER A-04 (endgueltige Glied-FOLGE bei Count 10 + AxisKind-Enum-Ordnung im selben
  Bruch? KON5-04(3)/KON5-05 "VOR dem Bruch entscheiden"). OWNER Makro-Signatur: Tausch bewegt
  golden-Round-Trip-Anker (zweites golden-Ereignis nach 90ee6809) -- Wellenplan verlangt alle drei
  Aussen-Ebenen, die golden-Folge ist nirgends ausgewiesen; Alternative (Signatur stehen lassen,
  nur POD+Preimage tauschen) waere golden-neutral, erfuellt aber den S-6a-Wortlaut nicht.
  AxisKind heute: topics/axis.hpp:17 Ordnung organ, system_measurement, system_config,
  system_meta_meta, measurement_meta_meta, organ_meta_meta -- NICHT MESS,SYSTEM,ORGAN; alle
  Anhaenge bewusst ANS ENDE (Kommentar), eine Umordnung ist ABI-/Serialisierungs-Frage des Bruchs.

## 2. S-6b -- Transpositions-Sperre (sofort baubar, aendert kein Byte?)

(a) NULLBEFUND mit Gegenprobe: grep "Transposition" in libs/tools/tests/apps = 0 Treffer. Die
  Sperre existiert HEUTE nur fuer die SCHWANZ-Glieder: benannte Typen ToolchainGlied/BvsetGlied/
  OverlayHash/MessGatesGlied (anatomy_fingerprint.hpp:221-288, K-1-Muster "reist als BENANNTER
  TYP, nicht als vierter string_view"; M3b-Praezedenz decl :397-398). Die DREI ZEILEN organ/
  system/measurement reisen als rohe string_view positional (:593-598) -- Vertauschung kompiliert
  still. Wer wuerde die Sperre rufen: 47 Aufrufstellen von anatomy_fingerprint_hex/_glieder in 12
  Dateien (lazy_adhoc_source_gen.hpp, ceb_version_stamp.hpp, bestandslog_index.hpp,
  anatomy_module_abi_v1.hpp + 8 Test-TUs) -- der Bestand ist da, der Schutz fehlt.
(b) "aendert kein Byte" -- am Objekt BESTAETIGT mit zwei Belegen: (i) der emittierte Quelltext
  traegt nur den Makro-CALL (adhoc_emitter :126-138); Typen leben in der Makro-EXPANSION ->
  320er-Byte-Wachen + golden-CRC unberuehrt. (ii) Preimage-Bytes unveraendert (gleiche
  Glied-WERTE, nur Traeger-Typen) -> kein Fingerprint bewegt sich. Einschraenkung: gilt NUR,
  solange die Zeilen-POSITIONEN nicht mitgetauscht werden (das ist S-6a, nicht S-6b).
  Riegel/floor/golden: alle unberuehrt; die 47 Stellen werden compile-hart nachgezogen (gewollt,
  ERST-LAUTE-COMPILE-FEHLER-Doktrin).
(c) Reihenfolge: UNABHAENGIG sofort baubar, Vorzieher ins WE explizit erlaubt (Wellenplan #15,
  KON7-10/4). VOR S-6a einbauen: dann bricht jede Umsortierung der Signatur laut statt still.
(d) Entscheid: AUTONOM (Owner-GO liegt im Plan; Typnamen-Vorschlag im Fenster = R-2-Vorlage).

## 3. S-6c -- S-21 Kategorien-Ordnungs-Wache

(a) NULLBEFUND mit Gegenprobe: grep "S-21|kategorien_ordnung|KategorienOrdnung" in libs/tools/
  tests/scripts = 0; tools/ enthaelt kein solches Werkzeug (18 Eintraege, davon einschlaegig nur
  axis_version_lock, overlay_source_hash_gen). Kein Konsument, kein Test -- S-21 ist NEU zu bauen.
  VORBILD existiert CT-bewiesen: organ_gruppen_decken_die_komposition
  builder/bestandslog/lager_baum_writer.hpp:420-441, static_assert :464-467 (+ Grammatik-Wachen
  :448-460, asserts :468-471).
(b) Wachen: neue ctest-Registrierung(en) -> floor-Anker 495/491/489 im SELBEN Change live
  nachziehen (Kopf-Rezept der Datei, #39 NACHZUG-PFLICHT, alle drei Sprossen). Kein golden-, kein
  Preimage-, kein Riegel-Effekt (Wache liest, hasht nicht).
(c) Reihenfolge: NACH oder MIT S-6a -- niemals vorher (sie wuerde die ALTE Ordnung zementieren).
(d) Entscheide: Owner-GO liegt vor (KON21-03 "neu, Owner-GO"); Design AUTONOM mit Explore-Pflicht.
  DESIGN-AUFLAGE aus MEMORY (ZWEI WELTEN, "S-6 ist falsch herum war zu einfach"): die Wache muss
  JE WELT eine eigene Ordnung zementieren -- Aussen-Ebenen MESS,SYSTEM,ORGAN; Lager-Messdaten
  MESS->SYSTEM->ORGAN; Lager-Binaries SYSTEM->ORGAN->MESS (D-12) -- und darf NIE eine einzige
  "kanonische" Folge ueber beide Welten behaupten. Vorschlag: Fehlerklassen nach Par.68a-Register
  R-A..R-F benennen (heute nur Plan-Artefakt, s. 6).

## 4. S-6d / #67 -- Benennung + Include-Wanderungen

(a) Zahlen-Lage: die Alt-Zahlen "4 Familien, 142 Include-Kanten, 29 Wanderungen" (Wellenplan
  :1416/:1614) sind per Ledger KON61-05 (LEDGER.md:2570-2576) UNBELEGT: eine 142er-Definition
  EXISTIERT NICHT (0 Belegstellen); die 29er-Definition gilt (Familien-Header = basename enthaelt
  version|stamp|semver|fingerprint). Owner (LEDGER.md:7621): "Bitte explore und schaerfen,
  behalten" -> Zahlen NEU erheben. Frische Basis: docs/plaene/20260813-DESIGN-zielstruktur-vier-
  traeger-unterprojekte.md par.3a (Kanten-Matrix) + par.3c (K1 Planer->CEB 49+2, K2 Zyklus
  builder<->mess 3, K3 Querschnitt->CEB 6, K4 Planer->Tier 1); planner-vs-planer ENTSCHIEDEN
  (Owner B3 13.08.: englisch "planner").
  HEUTE-Messung an HEAD: 23 Familien-Dateien (13.08. waren es 24 -- Drift 1, Erhebungsdatum-
  Regel); eingehende Include-Zeilen naiv gezaehlt libs 78 / tests 90 / apps 3 -- weicht von der
  KON61-05-Zaehlung (29/9/1) ab => die Zaehlweise war enger (vermutlich Kanten in die
  UMZUBENENNENDEN Koepfe, ohne familien-interne Includes); die S-6d-Neuerhebung MUSS ihre
  Zaehlweise deklarieren (A2.5-Muster des Design-Docs).
(b) Wachen: S-14a-Riegel beisst ZWEIFACH: (i) Renames unter Schnitt-Pfaden -> Lock-Eintrag
  verwaist = ROT, Regen noetig (Exit 3, --write; CI erzwingt Byte-Identitaet des Registers);
  (ii) Digest-Drift ohne Bump = ROT. Lock: tools/axis_version_lock/axis_version.lock (v3,
  dreizeilige Records, laengste Zeile 106B). Glied-[7]-WIRKUNG: von den 23 Familien-Dateien
  liegen GENAU DREI im Overlay-Schnitt: organ_axes/axis_q1_queuing/concepts/
  axis_q1_queuing_versioned_strategy_concept.hpp, organ_axes/value_handle_axis/
  axis_14_value_handle_versioned_pointer.hpp, topics/value_handle/axis_14_value_handle/
  axis_14_value_handle_versioned_pointer.hpp -- deren Rename/Move verschiebt das Overlay-Glied
  [7] => Preimage => gehoert ZWINGEND in den #15-Bruch. Alle uebrigen 20 (abi/, builder/,
  profile_facade/, measurement/) sind Glied-[7]-neutral, brechen aber Include-Zeilen (Kanten laut
  Neuerhebung) -- identitaets-neutral nachziehbar. floor: unberuehrt, solange keine ctest-
  Registrierung wandert (Header-Renames aendern Registrierungen nicht).
(c) Reihenfolge: Schnitt-beruehrte Renames IM Bruch (ein Invalidierungs-Ereignis); Nicht-Schnitt-
  Renames danach moeglich; Abstimmung mit #29 Zielstruktur-SCHNITT (Wellenplan :2152 nennt die
  Abhaengigkeit ausdruecklich) und #88 (K1-K4-Aufloesung "beim Aufraeumen").
(d) Entscheide: Owner-GO "behalten+schaerfen" liegt vor; Neuerhebung AUTONOM (Explore-Pflicht);
  Bezeichner-VORSCHLAEGE (R-2) durch uns im S-6-Fenster, Owner bestaetigt.

## 5. VERBOTSZONEN -- am Objekt verifiziert (Stand HEUTE)

  Lager-Kaskaden      lager_baum_writer.hpp:655-665 MessdatenBaumSpec (wurzel 1-2, realm 3, mess 4,
                      system 5 +meta_metas hinten, organ 6-10, haupt_blatt 11, mess_unter 12,
                      system_unter 13, organ_unter 14) und :667-673 BinariesBaumSpec (system 4,
                      organ 5-9, mess_typ 10 = TIEFSTER Haupt-Achsen-Typ, D-12); Policies :693-760.
                      ZWEI Welten bestaetigt -- BEIDE bleiben unberuehrt.
  kOrganGruppen*      lager_baum_writer.hpp:391-403 (Count=5, Namen 01_read_path..05_write_path_io,
                      Gruppen 2/5/5/2/4=18), organ_gruppen_achsen :407-416, Deckungs-Wache
                      :420-441/:464-467.
  kSystemAxisOrder    abi/system_axis_order.hpp:42-46 {target_isa, operating_system,
                      external_utils}; Drift-Wachen :85-110 (Ordnung==CodeVersions, Unikate,
                      Index-Selbsttest, DREI Abgangs-Wachen compiler/scheduling/load_framework).
  kCompositionAxisNames experiment_tree/axis_path_serialization.hpp:40-43 (18 Namen, T00-T17,
                      persistence_target als T17-Anhang).
  Hash-Mechanik       anatomy_fingerprint.hpp: Separator '\n' (:82), Injektivitaets-Wachen
                      (:185-219, :520-535), EINE Preimage-Konstruktion NB2-2 (:650ff), sha512-
                      Primitive ext sha512/ctsha512.hpp (50KB-Budget, fingerprint.hpp:55-57).
  Messwert-2-Tupel    builder/bestandslog/messwert_registrierung.hpp:21 (MesswertKeyPolicy =
                      Mess-Zeilen + Hardware-Identitaet; messwert_key_hex :55 = DIE EINE
                      Ableitung), messwert_key_source.hpp:86-90 (hardware leer -> nullopt,
                      fail-closed), bestandslog_factory.hpp:60. Der Messwert-Schluessel ist NICHT
                      der Binary-Fingerprint -- Positions-Wachen des Fingerprints duerfen dort
                      nie generisch uebertragen werden (fingerprint.hpp:568-573 benennt das).
  Befund zur Zonen-Treue: KEIN Posten meiner Gruppe schreibt in eine der sechs Zonen; S-6a/S-6c
  LESEN kSystemAxisOrder/kCompositionAxisNames als Ordnungs-Quellen (genau so gedacht).

## 6. Par.68a BINDENDE SORTIERUNG -- Objekt-Abgleich

  Mess-Tooling -> target_isa -> operating_system -> external_utils -> T00-T17: am Objekt EXAKT die
  Messdaten-Kaskade (Ebene 4 mess -> Ebene 5 system in bindender Ordnung via pruefe_system_ordnung
  lager_baum_writer.hpp:494-505, liest system_axis_order_index -> kSystemAxisOrder-Reihenfolge
  target_isa,operating_system,external_utils -> Ebenen 6-10 die 18 Organ-Achsen). "je Ebene
  Haupt-Blatt -> Mess-U -> System-U -> Organ-U" = Ebenen 11-14 (:661-664, Kaskade :720-727).
  kSystemAxisOrder als Single-Source BELEGT: Konsumenten u.a. lager_baum_writer (:498),
  overlay_source_set.hpp (:83, Ordnungs-Wachen :308-366), abi/system_cell_values.hpp,
  system_axes/operating_system_axis.hpp + external_utils_family_axis.hpp, measurement/
  ceb_complex_system_axis.hpp + load_framework_measurement_axis.hpp + measurement_meta_meta_axis,
  tools/system_axis_registry_gen/main.cpp, tests/unit/test_w10_system_cell_values.cpp.
  ACHTUNG ZWEI WELTEN: Par.68a beschreibt die MESSDATEN-Welt; die Binaries-Kaskade ist
  SYSTEM->ORGAN->MESS (D-12) -- Par.68a NIE auf das Binaries-Lager anwenden (MEMORY-Warnung).
  Register R-A..R-F: NULLBEFUND im Code (0 Treffer; Gegenprobe: kein Konsument, kein Test);
  Quelle ist r2-Karte A30/Par.68a Z.21406 (Regressions-Register), Ziel GOAL v8 Ordnungs-Kanon --
  Plan-Artefakt, kein Bau-Blocker; Kandidat als Fehlerklassen-Schema der S-21-Wache.

## 7. axis_centric_namespaces.hpp:24 (17 vs 18+1)

  BEFUND AN HEAD BESTAETIGT: libs/cache_engine/organ_axes/axis_centric_namespaces.hpp:24 sagt
  woertlich "Concept-Header ALLER 17 Achsen"; die Include-Liste :27-43 zaehlt 17 Koepfe, darunter
  telemetry (:37) und isa (:39), die die Komposition verlassen haben; es FEHLEN queuing_q1,
  queuing_q2, persistence_target. Kanonisch: 18 (+1 optionale Meta-Meta, KON80-V10/ORG-19).
  Einordnung: die Datei liegt NICHT im Overlay-Schnitt und NICHT im Riegel-Lock (Lock-Kopf D1,
  axis_version_lock.cpp:78-83: eine der 26 Ausschluss-Dateien, 0 gelockt) -> die Korrektur ist
  Glied-[7]-neutral und Riegel-neutral; reine Kopf-/Fassaden-Arbeit, im #15-Fenster als
  Task-Karte (r3 A10: "keine reine Nachbuchung" -- die Fassade muss die 18+1 real fuehren).

## 8. EISERNE REGEL (A-13) -- welche Posten beruehren die Hash-Pfade ZWANGSLAEUFIG?

  Objekt-Praezisierung: Glied [7] hasht kOverlaySourceSet (builder/overlay_source_set.hpp:132-201)
  = organ_axes-Achs-Verzeichnisse + topics-Achs-Verzeichnisse + system_axes-Praefixdateien +
  mess_axes/measurement_tooling + anatomy/ (tier_substanz). heuristik/ ist NICHT im Hash-Schnitt
  (Gegenprobe: kein Kategorie-Eintrag; 718 = 712 Schnitt + 6 heuristik NUR als Riegel-Kategorie,
  axis_version_lock.cpp:74-76) -- der A-13-Wortlaut "axes/ topics/ heuristik/" ist als
  ARBEITSREGEL breiter als die Byte-Wahrheit; das ist Verteidigungstiefe, KEIN Freibrief.
  ZWANGSLAEUFIG im Bruch (Glied-[7]-wirksam), aus meiner Gruppe: S-6d/#67-Renames der DREI
  Schnitt-Familien-Dateien (s. 4b) und jede weitere #67-Wanderung unter Schnitt-Pfaden.
  NICHT hash-wirksam (Gegenprobe je Ort): S-6a (abi/ + builder/codegen), S-6b (abi/), S-6c
  (neues Werkzeug + lager_baum_writer liegt in builder/bestandslog), AxisKind (topics/axis.hpp =
  topics-WURZEL, kein Schnitt-Eintrag), axis_centric_namespaces.hpp (Ausschluss-Liste D1).
  Aus dem Gesamt-Buendel beruehren die Hash-Pfade ausserdem zwangslaeufig: A-07 (heuristik/ ->
  Riegel-Kategorie, nicht Glied [7]) und jeder A-05/A-01-Anteil, der Registry-Traeger unter
  organ_axes/topics anfasst -- Zustaendigkeit anderer Gruppen, hier nur als Fenster-Kopplung.

## 9. BAU-REIHENFOLGE INNERHALB DES BUENDELS (Gruppe-3-Sicht)

  1. S-6b SOFORT/WE-Vorzieher (byte-neutral belegt, s. 2b) -- haertet alle 47 Aufrufstellen.
  2. A-04-OWNER-Entscheid (Glied-Folge Count 10 + AxisKind-Ordnung) VOR dem Bruch.
  3. DER EINE BRUCH (Layout 6->7 + Format 4->5 + Budget + A-01-Glied + S-6a-Umstellung + A-09-
     FullJoin-Rename + S-6d-Schnitt-Renames + Riegel-Regen + ggf. golden-Round-Trip-Neuanker):
     EIN Schreiber auf decl.hpp (P3-vor-P5); Wachen ziehen im SELBEN Commit (==7, K-4-Proben,
     Count/Format-Kopplung, Budget-Summe, Positions-Asserts, Lock-Regen, floor-Nachzug falls
     Registrierungen wandern).
  4. S-6c NACH/MIT dem Bruch (zementiert die NEUE Ordnung, je Welt getrennt) + floor-Nachzug.
  5. S-6d-Rest (Nicht-Schnitt-Renames, Kanten-Nachzug) nach dem Bruch, abgestimmt mit #29/#88.

## 10. OFFENE ENTSCHEIDE (Owner vs. autonom)

  OWNER  A-04: Glied-FOLGE (fest 10) endgueltig + AxisKind-Enum-Ordnung im SELBEN Bruch ja/nein
         (KON5-04(3)/KON5-05; sonst steht der teuerste Bruch erneut an).
  OWNER  Makro-Signatur-Tausch vs. golden: S-6a-Makro-Ebene bewegt emittierten Quelltext ->
         zweites golden-Ereignis nach dem gelandeten EINEN golden-Fenster (90ee6809); nirgends
         ausgewiesen, A-09 impliziert ohnehin golden-Bewegung im #15 -- Buendel-Freigabe noetig.
  OFFEN  R-2 (S-6-Fenster): Bezeichner-VORSCHLAG durch uns (FullJoin-Ersatz + #67-Namen),
         Owner bestaetigt (KON30-02/KON36-02/F; Wellenplan :2059/:2067 "weiter offen").
  AUTONOM S-6b-Vorzieher (explizit erlaubt) - S-6c-Design mit ZWEI-WELTEN-Auflage (Owner-GO
         KON21-03 liegt vor) - S-6d-Neuerhebung mit deklarierter Zaehlweise (Owner-GO "explore
         und schaerfen, behalten" liegt vor; HEUTE 23 statt 24 Familien-Dateien) -
         axis_centric_namespaces-Korrektur (Glied-[7]-neutral, Task-Karte im Fenster).
