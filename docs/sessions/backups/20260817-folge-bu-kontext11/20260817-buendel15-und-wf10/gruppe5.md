# GRUPPE 5 -- MESS-GLIED + SCHALTER-HOHEIT (#15-Bump-Buendel, Karte am Objekt)

Erhebung: 2026-08-17, ce development @ 04ac26fa (verifiziert: git rev-parse). Repo read-only vermessen.
Referenzkarten mit IHREN Erhebungsdaten: rest_karte_r3 (Ledger-Stand 30076, Nachtraege 05.-06.08.),
KON34/KON37-Anker (11.-12.08.), WF6-SYNTHESE r1 (12.08.). Regel angewandt: Karten-Anker sind Erhebungs-
daten, jede Fundstelle unten ist HEUTE am HEAD nachgemessen.

## KERNBEFUND VORAB (aendert den Schnitt der Gruppe)

Drei der fuenf Posten sind am HEAD BEREITS GEHEILT -- die r3-Karte wurde aus Ledger-Nachtraegen
05.-06.08. erhoben, die Heilungs-Commits desselben Fensters (06.-07.08.) lagen dahinter:
  r3 A1 -> geheilt 62a5b6f7 (06.08., M-1/D-4)   "Schluessel rendert die WAHL"
  r3 A3 -> geheilt 2e1f9c1d (07.08., R-3)       neuntes Preimage-Glied mess-gates
  r3 A4 -> geheilt 246b2793 (06.08., M-1/D-2)   Mess-Konsistenz-Gate am Pruefdock
  (Nebenbefund r3 A5 Welt-Split -> geheilt, M-1/H-A-Wachen stehen am Objekt)
Die Wellenplan-Zusatzliste 19.1 (Z2267-2276) fuehrt A1/A3 noch als offen -- das ist Karten-Stand,
nicht HEAD-Stand. OFFEN aus Gruppe 5 bleiben: B3 (Schalter-Hoheit, Owner-Datum vor F2), B5
(Stempel-Pflicht je Schalter), plus die MITZIEH-PFLICHTEN der geheilten Posten im 6->7/4->5-Bruch.

--------------------------------------------------------------------------------------------------------

## POSTEN 1 -- kCebFingerprint: ANGEBOT statt WAHL (r3 A1)

(a) FUNDSTELLEN HEUTE (libs/cache_engine/builder/ceb_version_stamp.hpp):
  :2-5      Kopf sagt heute "EINKOMPILIERTE Mess-WAHL" (Karten-Anker :3-5 "Angebot" ist ueberholt;
            :159-161 traegt heute PMC-Additivitaets-Text, nicht mehr die consteval-Registry-Schleife)
  :8-29     M-1/D-4-Protokoll: der Karten-Befund selbst (4 Combos, 1 Schluessel 004251f4...) steht als
            VORHER-Messung (Stand b9fd81ff) im Kopf; Plan-Soll Paragraf 58-V zitiert
  :457-465  kCebCtLegend: die EINE Lesung von COMDARE_MEASUREMENT_COMBO_CT; no-define == "[all]"
  :384-425  detail::ceb_tooling_list -- DIE EINE Zerlegung (wirft bei unbekanntem Tooling/leerer Wahl)
  :472-529  ceb_measurement_stamp_array_for<L> rendert ueber die LEGENDE (nicht die Registry);
            [all]-Zweig :392-393 = Registry-Vollmenge -> Alt-Bestand byte-stabil
  :591-598  kCebFingerprintArrayFor: anatomy_fingerprint_hex("", "", mess, Toolchain=REAL, Bvset=REAL,
            Overlay=""), d.h. der CEB-Key traegt HEUTE Toolchain- und bvset-Glied, KEIN Overlay
  :600-608  die vier oeffentlichen Konstanten sind Spezialisierungen an kCebCtLegend (kein 2. Weg)
  :232-240  Verdrahtungs-Wache: #error ohne COMDARE_MEASUREMENT_COMBO_CT_WIRED (ODR-Riegel)
  Injektivitaet bewiesen: tests/unit/test_d4_ceb_schluessel_wahl.cpp:108 (Verschiedene Combos ->
  verschiedene Schluessel), :177 (Vollmengen-Byte-Stabilitaet), Byte-Anker :194 = 9f880251...
(b) WACHEN, die der #15-Bruch mitziehen MUSS:
  - test_d4_ceb_schluessel_wahl.cpp:194: der [all]-Key-Literal-Anker bewegt sich bei Format 4->5
    ZWINGEND (Praezedenz R-3: :187 Historie 004251f4 -> db7bac00 -> 9f880251). Re-Pin im SELBEN Bruch.
  - anatomy_fingerprint.hpp:116 ("fingerprint_format=4"), :416/:643 (GliedCount==9), :647 (Format-Pin):
    alle drei static_asserts fallen im Bruch und werden auf 5/10 gezogen.
  - Drift-Guard test_m_w12_stamp_bausteine.cpp:1424 (A5CebVersionStamp...: CEB-Zeile == abi-Renderer an
    der einkompilierten Legende, ueber alle 7 nicht-leeren Teilmengen) -- bleibt gueltig, muss gruen mit.
  - KEIN golden-CRC-Effekt: CEB-Key ist Provenienz, ceb_key_sha512 hat 0 Lese-Stellen (Kopf :81-84).
(c) REIHENFOLGE: Re-Pin ist reiner Folge-Edit des Format-Bumps; im Bruch-Commit selbst (ein Schreiber
    auf anatomy_fingerprint.hpp; das 10. Glied erreicht die CEB als leerer Default der 3-arg-Form,
    Praezedenz R-3 :113-118 -- KEIN CEB-seitiger Code-Edit noetig, nur der Test-Anker).
(d) ENTSCHEIDE:
  - OFFEN (Owner): Ueberunterscheidung permutierter Legenden ("[wallclock,micro]" != "[micro,wallclock]",
    gemessen 250be8b2 vs a30fe495, Kopf :86-101). Kanonisierung erfasst BEIDE Zwillinge = Byte-Ereignis
    am TIER-Preimage -> "eigene Scheibe mit Owner-Entscheid" (Kopf :100-101). Das #15-Fenster ist das
    LETZTE kostenlose -- Owner-Frage "in #15 falten oder dauerhaft tragen?" gehoert VOR den Bruch.
  - AUTONOM (Kommentar-Drift, Luecke=Pflicht): Kopfaussagen :64-65 (W10-C3 "traegt Toolchain/bvset
    NICHT") und :566-567 (O-2/C-2 "als DEFAULT (leer)") widersprechen dem realen Aufruf :594-595
    (ToolchainGlied/BvsetGlied mit ECHTEN Werten seit E-E). Kopf im #15-Fenster nachziehen.

--------------------------------------------------------------------------------------------------------

## POSTEN 2 -- COMDARE_MEASUREMENT_ON ABI-wirksam ohne Preimage-Glied (r3 A3)

(a) FUNDSTELLEN HEUTE:
  - perm_mess_defines: profile_facade/profile_run_facade.cpp:308-333. Der Karten-Anker ":273-275 setzt
    hart -DCOMDARE_MEASUREMENT_ON=1" ist UEBERHOLT: :273-275 ist heute Kommentar der T2-B-Naht; die
    Mess-Defines kommen aus live_mess_achsen_defines() (:310, M-1/D-1). Hart bleiben NUR
    -DCOMDARE_ANATOMY_MODULE_BUILD=1 (:309, Modul-Marker, keine Mess-Aussage) und
    -DCOMDARE_EXPERIMENT_MODE_ON=1 (:311 -- steht als Feld <x> IM Glied, s.u.).
  - Das neunte Glied: abi/mess_gates_glied.hpp -- Grammatik :54-61 ("mg=<m>;<s>;<st>;<x>;<tw>;<tm>;<tmi>",
    m == COMDARE_MEASUREMENT_ON wertbasiert), TU-Konstante :331-334 (interne Bindung, ODR-Absatz :38-49),
    W3-Selbstbeweis-static_asserts :340-394, Binde-Assert Komponist==Praeprozessor :399-405,
    Puffer-/Feld-Wachen :450-460. B2 (15.08.) hat Feld <st> (SEGMENT_TIMING) eingezogen.
  - Verdrahtung ins Preimage: abi/anatomy_module_abi_v1.hpp:176 reicht MessGatesGlied{kMessGatesTuGlied}
    am Makro-Expansionsort; anatomy_fingerprint.hpp:636 pinnt MessGates == Glied Count-1 ([8]),
    :492/:528-533 Format-/Laengen-Wachen des Glieds.
  - Release-Szenario der Karte ("Release-Nachmessung = andere Binary, identischer Fingerprint") ist
    DOPPELT gedeckt: Glied [8] (Gates) + Glied [5] traegt cxx/opt/bt (toolchain_stamp_glied.hpp:249
    Schluessel-Liste, :292 build_type) -- der r2-A61-Satz "cxx/opt/build_type fehlen" ist am HEAD falsch.
  - Biss-Beweise: tests/unit/r3_mess_gate_stamp_module.cpp (2 .so, 1 Quelltext), test_r3_mess_gate_
    fingerprint_biss.cpp:143-144, test_r3_mess_gates_spiegel.cpp (Host-Vorhersage == TU-Wahrheit),
    test_b2_mess_gate_trennung.cpp / test_b2_gate_zustand_g2an_g3aus.cpp (B2-Gates).
(b) WACHEN im Bruch:
  - GliedCount 9->10 verschiebt die Positions-Pins: anatomy_fingerprint.hpp:633 (Overlay==Count-2),
    :636 (MessGates==Count-1) -- A-01 muss entscheiden, WO das 10. Glied einsortiert (A-04-Entscheid
    Glied-FOLGE!); haengt das 10. hinten an, wandern Overlay/MessGates-Pins NICHT relativ (Count-2/-1
    bleiben wahr), steht es davor, fallen beide Asserts laut. Preimage-Budget: :68 Max=4096, :478-483
    BudgetSum-Assert rechnet ueber Count-1 Separatoren -- A-02 hebt MIT Beleg.
  - mess_gates-Grammatik bei B3: JEDES neue Gate (Hybrid) braucht ein Feld; Feld-Zaehl-Wache
    mess_gates_glied.hpp:393-394 ("EIN Feld mehr gibt es nicht") + AUS-Form-Anker :457-460
    ("mg=m0;s0;st0;x0;tw0;tm0;tmi0" ist textlich verankert) fallen dann MIT -- und JEDE TU bekommt
    einen neuen Glied-Wert => flottenweiter Fingerprint-Wanderer => gehoert in DENSELBEN Bruch.
(c) REIHENFOLGE: Glied-Folge-Entscheid (A-04) VOR dem Bruch; Grammatik-Erweiterung fuer Hybrid-Gates
    (falls B3 sie im Fenster baut) IM Bruch-Commit, nie danach (zweiter Flotten-Neubau).
(d) ENTSCHEIDE: keine Owner-Frage zur Sache offen; A-04 (Glied-Folge) ist der uebergeordnete
    Buendel-Entscheid, Traeger Gruppe des A-04-Postens. NOTIZ->Pflicht: keiner.

--------------------------------------------------------------------------------------------------------

## POSTEN 3 -- measurement_line / measurement_entries ohne produktive Leser (r3 A4)

(a) FUNDSTELLEN HEUTE -- der Leser EXISTIERT (Karte ueberholt durch M-1/D-2, 246b2793, 06.08.):
  - builder/pruef_dock/mess_konsistenz_gate.hpp: liest measurement_entries (:249, haupt_entry_count)
    und measurement_line (:250-251) des GELADENEN Moduls und vergleicht gegen die SOLL-Zeile der CEB;
    Kopf :13 dokumentiert den Zensus, :70-71 die Feld-Doppel-Pruefung, :246 die Offset-Bestaetigung.
  - PRODUKTIVER Rufer: builder/experiment_tree/cache_engine_builder_iterator.hpp:2966
    (pruefe_mess_konsistenz VOR acquire_search_algorithm_drive, fail-closed -> SourceUnavailable-Zeile,
    Begruendungsblock :2949-2964); Zweitnutzung :2555 (Meldung), :143-144 (Bau-Seite).
  - Deklarations-leer-Zweig dokumentiert: profile_facade/experiment_run_entry.hpp:171,
    sota_catalog.hpp:667 ("measurement_line == '' -> am fail-closed-Gate deklaration_leer").
  - Test: tests/unit/test_d2_mess_konsistenz_gate.cpp.
  - Memory-Notiz "measurement_line leer: Perm-Pfad trifft 2-arg-Zweig" bleibt der SYMPTOM-Zweig
    (anatomy_version_stamp.hpp:269/:290, anatomy_module_abi_v1.hpp:207) -- unveraendert wahr.
(b) WACHEN im Bruch (Layout 6->7): das Gate haengt an der GLEICHHEITS-Wache Layout==6:
  - anatomy_module_abi_v1_decl.hpp:267 (kAnatomyVersionLinesLayout=6), :274-276 (sizeof==120),
    :286-288 (stamp_pod_has_entries == 6; K-4: NIE >=), :293-299 (CT-Negativ-Probe).
  - test_m_w12_stamp_bausteine.cpp:685 (offsetof measurement_line == 40) + AnatomyStampEntryV1-Pins
    decl.hpp:192-194 (sizeof 48).
  WIRD ==6 nicht im SELBEN Bruch auf ==7 gezogen, faellt JEDE Tier-Binary am D-2-Gate fail-closed
  durch (SourceUnavailable) -- der Bruch waere still-rot statt gruen. Mitzieh-Liste: Konstante :267,
  sizeof-Pin :274, Gleichheits-Wache :287, Negativ-Probe, Test-Offsets, plus A-01-Feldzugang
  (Hybrid-Map-Zeile ans POD-Ende = Append -> measurement_line-Offset 40 bleibt, sizeof waechst).
(c) REIHENFOLGE: EIN Schreiber auf decl.hpp (Wellenplan-Fessel P3-vor-P5); D-2-Gate-Nachzug im
    selben Commit wie der Layout-Bump.
(d) ENTSCHEIDE: keine. Der Posten ist als DEFEKT zu; er lebt im Buendel nur als Mitzieh-Pflicht.

--------------------------------------------------------------------------------------------------------

## POSTEN 4 -- B3: UMZUG DER SCHALTER-HOHEIT ZUR CEB (A-12; KON37-01, KON34-04 VOR F2)

(a) FUNDSTELLEN HEUTE -- KARTEN-ANKER-KORREKTUR (tragend):
  Der ueberall zitierte Anker "abi_adapter.hpp:476-491 faellt" trifft am HEAD (und schon am 06.08.,
  git show b9fd81ff/7d4dd809) den RC-Block tier_apply_resource_control (apply1-Klammern) -- NICHT den
  Pflicht-Wurf. Der GEMEINTE Tier-Pflicht-Wurf sitzt in profile_facade/mess_achsen_naht.hpp:
    :477-517  M-1/H-1 "DEKLARATIONS-PFLICHT FUER G1": Combo ohne wallclock baut G1 trotzdem ein ->
              WURF :509-516; G1-Emission :518 ("-DCOMDARE_MEASUREMENT_ON=1" fuer jede nicht-leere Menge)
  Der Zeilen-BEREICH der Karten passt auf die NAHT-Datei (Block beginnt :476/477) -- die DATEI war in
  KON34/KON37/Ledger (Z2913, Z5264, Z6237) falsch verbucht. Befund-Datum dieser Korrektur: 17.08., HEAD.
  DER SCHNITT HEUTE (Hoheits-Lage je Instrument, alles nachgemessen):
    - CT-Hoheit der CEB steht: resolve_live_measurement_combo_legend (:301-335) = CT-Legende vor Env,
      drei Wuerfe (Env fehlt bei CT-spezifisch :308-313; Env != CT :314-316; spezifische Env ohne CT
      :325-333, M-1/H-A) -- der r3-A5-Welt-Split ist zu, der wt-w2fix-Ausgang ist gelandet.
    - G3 entscheidet bereits aus der EIGENEN CEB-Menge (KON37-01 woertlich im Code): :524-533
      ("=1 wenn micro in der EIGENEN Menge dieser CEB ist (KON37-01), =0 sonst").
    - Wallclock ist die LETZTE Tier-Pflicht: der H-1-Wurf verbietet jede CEB ohne wallclock -> von
      2x2x2x2x2=32 Belegungen sind heute nur die 2^3=8 Tier-seitigen adressierbar, wallclock-frei = 0.
    - HYBRID-GATES: NULLBEFUND. grep COMDARE_HYBRID|hybrid_gate|HybridGate ueber libs+apps+tests = 0
      Treffer. GEGENPROBE: dieselbe Suche nach "hybrid" findet die Stufen-Doktrin-Kommentare
      (mess_achsen_naht.hpp:164-165) und die Hybrid-Plan-Seite -- das Verfahren sieht, es gibt nur
      keine Gates. Der KON34-Anker "naht:159-160 Platzhalter" ist stale (:159-160 = PMC-Text).
    - System-B-Wallclock-Traeger existiert dormant: mess/konfiguration.hpp:106-111
      (struct Wallclock, MessEbene::Compare, 'WCLK') -- deckt KON60: Wallclock = CEB-seitiger
      checkpoint-measure-Wrapper der VERGLEICHS-Ebene.
  SOLL (KON37-01, Ledger 5250-5264, Merge kein Widerruf): Freigabe PLANER, ENTSCHEIDUNG (Schalter-
  Hoheit) CEB, DURCHFUEHRUNG im Vertrag CEB<->Tier/Hybrid; Vererbungsregel "CEB baut hoehere Stufen
  nur nach EIGENEN Messeigenschaften, ruft nur selbstgebaute Messfuehler"; Tier-Gates BLEIBEN; der
  Pflicht-Wurf FAELLT zugunsten der CEB-Entscheidung; w erscheint im Tier-Stempel genau dann, wenn
  die erzeugende CEB w traegt und einbaut.
(b) WACHEN/GOLDEN:
  - Byte-Bilanz Wurf-Fall: fuer den [all]-Bestand feuert der Wurf NIE (wallclock in der Menge) -> 0
    Byte Bestand; erste Wirkung am ersten nicht-wallclock-Batch (neue Keys, additiv).
  - ABER: liegt ein B3-Byte in anatomy/ (z.B. Gate-Bloecke im abi_adapter), dann (i) wandert Overlay-
    Glied [7] fuer JEDE Tier-TU (anatomy/ ist tier_substanz im Overlay-Schnitt,
    builder/overlay_source_set.hpp:32-37) und (ii) driftet der S-14a-Riegel: anatomy/ = 55 der 718
    Lock-Records (tools/axis_version_lock/axis_version_lock.cpp:75-76, :244; ctest-Registrierung
    tests/unit/CMakeLists.txt:1920-1957, TIMEOUT 900). Riegel-Protokoll: Drift ohne Bump Exit 1,
    Bump ohne Regen Exit 3, Regen per --write im SELBEN Change. => B3-Tier-Seite ist flotten-bewegend
    und gehoert ins EINE #15-Fenster (EISERNE REGEL A-13 gilt de facto auch fuer anatomy/).
  - Neue Hybrid-Gate-Defines => neue Felder im mess-gates-Glied [8] (s. Posten 2b) => selber Bruch.
  - H-1-Wurf-Tests: test_m1h_stufen_und_pmc_wache.cpp (Stufen-Wache), mess_achsen_naht-Zuordnung
    :102/:122 (wallclock: G1) -- fallen/wandeln beim Wurf-Umzug auf CEB-Ebene; Test-Umbau einplanen.
  - ci_test_inventory_floor.txt (Anker avx512f 495 / avx2 491 / basis 489, Stand HEAD 04ac26fa):
    jede neue/entfallende ctest-Registrierung aus B3 zieht ALLE DREI Zeilen im SELBEN Change nach
    (Exit-4-Doktrin, Nachmess-Rezept im Dateikopf).
(c) REIHENFOLGE INNERHALB DES BUENDELS:
  1. B2 ist GELANDET (15.08., Merge 90ee6809; Gate-Trennung G2/G3 + Feld <st>) -- B3 ist entfesselt.
  2. Hybrid-Gate-FELDER + 10. Glied + Format 4->5 + Layout 6->7 in EINEM Identitaets-Bruch (jede
     Grammatik-Erweiterung von [8] wandert sonst als ZWEITER Flotten-Neubau hinterher).
  3. Wurf-Umzug (H-1 faellt, CEB-Ebene erzwingt per Vererbung) NACH der Gate-Existenz, VOR F2.
  4. Stempel-Seite (w-Fuehrung im Tier-Stempel folgt CEB) beruehrt G-1-Vorlage
     (profile_facade/g1_binary_version_stamp.hpp, reine Ausgabe) und CebVersionen-Alias
     (mess/konfiguration.hpp:40-44) = benannter Umbaupunkt der w-Sicht.
(d) ENTSCHEIDE:
  - OWNER-DATUM steht: KON34-04 "VOR F2 (heute kostenlos, ab 26.08. teuer)" -- Frist Fr 21.08.,
    keine neue Owner-Frage zur Semantik (KON37-01 verbatim, Merge-Entscheid dokumentiert).
  - AUTONOM am Objekt: Ersatzform des Wurfs auf CEB-Ebene (wo wirft kuenftig wer: die CEB-Konfig-
    Wache statt der Tier-Define-Naht), Hybrid-Gate-Zuschnitt 2x2 (KON37-03: Subset-Modell, Nenner 32
    bleibt; WIE VIELE Belegungen gefahren werden, rechnet S-19 -- NIE statisch vorlegen).
  - OFFENE Definitionsluecke (KON60, NICHT B3-blockierend): START-Grenze der Wallclock-Klammer
    ("vom Aufruf" -- liegt Pruefdock-Laden drin?) -- erst Bestands-Explore, dann ggf. Owner-Frage.

--------------------------------------------------------------------------------------------------------

## POSTEN 5 -- B5: STEMPEL-PFLICHT JE SCHALTER (KON34-04-B5; #24/B5)

(a) FUNDSTELLEN HEUTE (SOLL ist praezise, Substanz-Anker existieren alle):
  - Die EINE Aufloesung, durch die JEDER neue Stufen-Schalter laufen muss:
    mess_achsen_naht.hpp:301 (resolve_live_measurement_combo_legend); ihr Glied-[3]-Anschluss
    lazy_adhoc_source_gen.hpp:288-298; ihre Glied-[8]-Vorhersage mess_achsen_naht.hpp:549-596.
  - CEB-seitiges VORBILD (WF6-r1-Anker ":268-334", heute verschoben): ceb_version_stamp.hpp
    :275-280 (Doppel-Vendor-#error), :286-290 (das EINE Praedikat COMDARE_CEB_HAT_PMC_GLIED),
    :292-305 (Registry-Lesung, kein Literal), :335-345 (Segment-Laenge inkl. Trenner),
    :511-524 (Render als ';'-Geschwister hinter load_framework).
  - X.Y.Z-Pflicht-Mechanik: mess_axes/measurement_tooling_registry.hpp (1 Datei im Home; seit
    cd047297 15.08. dort) + measurement/pmc_vendor_registry.hpp; "Aenderung ohne X.Y.Z-Bump =>
    schneller UND falsch" (KON34-04-B5, Ledger 6311-6314).
(b) WACHEN:
  - S-14a-Riegel deckt die Registry-Homes: mess_axes/ = 1 Lock-Record der 718; jeder Schalter-Bump
    ohne Lock-Regen = Exit 3, jede Drift ohne Bump = Exit 1 (der Riegel IST die B5-Durchsetzung auf
    Datei-Ebene; die STEMPEL-Durchsetzung ist der B5-Bau).
  - Feld-Zaehl-Wache mess_gates_glied.hpp:393-394 + Binde-Assert :399-405 + Spiegel-Test
    test_r3_mess_gates_spiegel erzwingen, dass ein neuer Schalter BEIDE Bildungen (TU+Host) erreicht.
  - CEB-Stempel-Vertrag: ceb_version_stamp.hpp:649-652 (static_assert StempelVertrag<CebStempel>),
    Organ-Absenz-Riegel :644-647 (KON7-07).
  - PMC-Asymmetrie-Wache: test_m_w12_stamp_bausteine.cpp:1585 (TierSeiteFuehrtNiemalsEinPmcGlied),
    :1537 (PmcGlied im CEB-Stempel + Byte-Identitaet ohne PMC).
(c) REIHENFOLGE: #24/B5 haengt an S-5 (Stempel-Factory je Kategorie + Composite je Traeger,
  Wellenplan Z1613/Z2138). S-5-BESTAND am HEAD: TEILGEBAUT -- S-1-Vertrag steht
  (abi/stempel_basis.hpp; stempel_kompositum :188-192) mit GENAU ZWEI Traeger-Komposita:
  planner/planner_version.hpp:69 (Planer) und ceb_version_stamp.hpp:618 (CEB). GEGENPROBE: grep
  stempel_kompositum ueber libs = genau diese 2 Nutzer + Definition; Tier-/Hybrid-Composite + Karte
  FEHLEN. => B5 baut NACH S-5-Vervollstaendigung (oder S-5-Rest im selben Strang); Lande-Slot ggf.
  A (21b) laut Wellenplan Z2138.
(d) ENTSCHEIDE: Substanz entschieden (KON34-04-B5); "Fable max, KON38" ist die MODELL-Regel der
  Stempel-Strecke (alle Workflow-Teile), keine Sachfrage. Keine Owner-Frage offen; autonome
  Designfrage: ob der Hybrid-Schalter-Stempel als weiteres ';'-Geschwister im Meta-Meta-Anhang
  (PMC-Muster) oder als 10.-Glied-Zeile (A-01 Hybrid-Map) faehrt -- A-01-Gruppe fuehrt, B5 folgt.

--------------------------------------------------------------------------------------------------------

## KONSOLIDIERTE (b)-MATRIX -- was Gruppe 5 im EINEN Bruch mitzieht

  S-14a-Riegel (718):  tests/unit/CMakeLists.txt:1920-1957 + tools/axis_version_lock. Betroffen nur,
                       wenn B3/B5 Bytes unter anatomy/ (55), mess_axes/ (1), organ_axes/topics (640),
                       system_axes/ (16), heuristik/ (6) bewegen -> Bump+Regen im SELBEN Change.
  Floor 495/491/489:   scripts/ci_test_inventory_floor.txt (Anker-Form, Exit 4 bei Abweichung in
                       BEIDE Richtungen); jeder neue B3-/B5-ctest zieht alle drei Zeilen live nach.
  axis-version-lock:   == S-14a-Werkzeug (test_s14_axis_version_lock_tripwire, Koeder A..S).
  static_asserts:      anatomy_fingerprint.hpp :116/:416/:480/:633/:636/:643/:647;
                       anatomy_module_abi_v1_decl.hpp :192/:267/:274/:286-299;
                       mess_gates_glied.hpp :340-405/:450-460; ceb_version_stamp.hpp :232-240/:649-652;
                       test_m_w12_stamp_bausteine.cpp :685 (offsetof) + :1394/:1414 (Zeilen-Formen).
  Byte-/golden-Anker:  test_d4_ceb_schluessel_wahl.cpp:194 (CEB-Key, bewegt sich deklariert);
                       golden-CRC bleibt von P1-P5 unberuehrt, SOLANGE kein Emitter-Quelltext-Byte
                       faellt; Overlay-[7]-Wanderung (anatomy/-Edits) ist Sidecar-/Flotten-, kein
                       golden-Ereignis (Praezedenz B2-Byte-Bilanz mess_achsen_naht.hpp:455-460).

## KONSOLIDIERTE (c)-REIHENFOLGE (Gruppe-5-Sicht auf das Buendel)

  1. A-04-Entscheid (Glied-FOLGE + AxisKind-Ordnung) -- VOR jedem Byte.
  2. Owner-Frage P1(d) permutierte Legenden stellen (Fenster-Kopplung).
  3. EIN Bruch-Commit: Layout 6->7 + Format 4->5 + GliedCount 9->10 + Budget (A-02) + ==7-Nachzug
     (D-2-Gate!) + Hybrid-Gate-FELDER in [8] + Test-Re-Pins (d4:194, m_w12-Offsets).
  4. B3-Wurf-Umzug + CEB-Hoheits-Wache (nach Gate-Existenz, vor F2-Freeze).
  5. B5 nach S-5-Rest (Tier-/Hybrid-Komposita), PMC-Muster als Vorlage.
  6. Floor-/Riegel-Nachzuege jeweils IM Change, nie nachgelagert.

## NULLBEFUNDE (mit Gegenprobe, Doktrin)

  - Hybrid-Gates: 0 Treffer (COMDARE_HYBRID|hybrid_gate|HybridGate, libs+apps+tests); Gegenprobe:
    dieselbe Pipeline findet "hybrid" in Doktrin-Kommentaren und Plan-Dateien -> Suchweg sehend.
  - Harte Mess-Defines in perm_mess_defines: 0 (COMDARE_MEASUREMENT_ON-Literal dort nicht mehr);
    Gegenprobe: grep findet :311 EXPERIMENT_MODE_ON-Literal in derselben Funktion.
  - ceb_key_sha512-Leser: 0 Vergleichs-Stellen (Kopf-Zusage :81-84 unveraendert); Gegenprobe: die
    Schreibstelle profile_run_facade.cpp und bestandslog_document.hpp werden gefunden.
  - Pflicht-Wurf in abi_adapter.hpp: 0 throw-Treffer in der Datei (einziger Treffer :660 = Kommentar);
    Gegenprobe: der Wurf existiert, in mess_achsen_naht.hpp:509 -- Datei-Fehlbuchung der Karten.

## KARTEN-DRIFT-PROTOKOLL (Erhebungsdatum je Anker)

  r3 A1 :3-5/:159-161 (05.-06.08.)  -> HEAD: geheilt; Zeilen tragen heute anderen Inhalt.
  r3 A3 profile_run_facade.cpp:273-275 (05.-06.08.) -> HEAD: :308-333, Naht statt Literal.
  r3 A4 "0 produktive Leser" (05.-06.08.) -> HEAD: Gate + Rufer :2966.
  KON34-02 "naht:159-160 Platzhalter" (11.08.) -> HEAD: PMC-Text; Hybrid-Platzhalter existiert nicht mehr.
  KON34/37/Ledger "abi_adapter.hpp:476-491" (11.-12.08.) -> HEAD: RC-Block; gemeint mess_achsen_naht :477-517.
  WF6-r1 "ceb_version_stamp.hpp:268-334" (12.08.) -> HEAD: :275-345 (PMC-Block).
  r2 A61 "cxx/opt/build_type fehlen" -> HEAD: in Glied [5] vorhanden (toolchain_stamp_glied.hpp:249,:292).
