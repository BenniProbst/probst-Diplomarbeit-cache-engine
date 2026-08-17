# GRUPPE 7 -- VS-A..VS-F STOPP-GATES AM HEUTIGEN OBJEKT (#15-Bump-Buendel)

Erhebung: 17.08.2026, ce development @ 04ac26fa (verifiziert: git log). Repo read-only vermessen.
Zitierte Karten (r3/r4/r5/kontext10) tragen Erhebungsstand 05.-07.08.-Segment; Ledger-Zitate eigene Zeilen.

## KERNBEFUND VORAB: KEIN BUCHSTABE IST NOCH EINE OFFENE OWNER-FRAGE

Der Ledger traegt den NACHTRAG "07.08.2026 abend-23 -- OWNER-FREIGABEN: E-A bis E-F entschieden"
(DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:27970-27979, Entscheid-Tabelle :27972-27979):
  E-A SHA-256/64 Hex (Owner verbatim "wir verwenden dann bitte doch der Einfachheit wegen SHA256") --
  E-B (i) Emitter schreibt Namen, "Wir brechen golden-CRC!" (Owner-SETZUNG) -- E-C mitziehen (Owner:
  "wir waren noch gar nicht beim bauen") -- E-D (a) Ordnernamen auf Stempel + Doppelspalte -- E-E
  Konkatenation/feste Ordnung/Schnitt 3 Ordnungen + anatomy/ -- E-F honest-empty (Par.43.b fuer die
  gerenderte Zeile bestaetigt).
FOLGE: Wellenplan Par.19.1-Zusatz "VS-A..VS-F STOPP-Gates offen" (Z2270f) ist als ENTSCHEID-Aussage
FALSCH; richtig ist "AUSFUEHRUNG offen fuer A/B/C/D, E/F gebaut". Die Vorlage (537 Z., 20260807-OWNER-
VORLAGE-stopp-gates-E-A-bis-E-F.md) ist als Frage-Dokument HISTORISCH; Empfehlung b/ii/a/a/a/a wurde
vom Owner in ZWEI Buchstaben ueberstimmt (E-A: SHA-256/64 statt 24-hex-Praefix; E-B: (i) statt (ii)).
Die STOPP-Doktrin-Praezisierung der Vorlage (E-A/E-F stehen nicht unter "ohne Entscheid kein Byte")
bleibt sachlich richtig, ist aber gegenstandslos -- es fehlt kein Entscheid mehr.

## DIE ZWEI KARTEN-BEHAUPTUNGEN, AM HEAD GEPRUEFT (expliziter Auftrag)

(1) E-C ENTLASTET ("dll_is_current :331-338 liest AUSSCHLIESSLICH .fingerprint")? -- STIMMT IM KERN,
    Fundstelle GEWANDERT, eine Praezisierung:
    * dll_is_current heute: build_orchestrator.hpp:435-472 (3-arg) + :477-479 (2-arg-Bestand);
      :331-338 ist heute Kommentar (L14 :332-336). Pfad-Konstante der Datei: libs/cache_engine/
      builder/build_orchestrator/build_orchestrator.hpp (nicht mehr include/...).
    * Gelesen wird AUSSCHLIESSLICH das .fingerprint-Sidecar: read_fingerprint_sidecar (:440) und --
      NEU seit Task #59, 11.08. (NACHGEFUEHRT-Block :389-421) -- auf dem OPT-IN-Teilmengen-Pfad
      read_bvset_glied_sidecar (:455), das ZEILE 2 DESSELBEN .fingerprint liest
      (fingerprint_sidecar.hpp:186-188, via fingerprint_sidecar_path). Ohne Kontext byte-genau der
      A2-Vergleich (:443-444).
    * .version/.algos/.variant: weiter GESCHRIEBEN (Pfade :300/:306/:313; Schreiber ab :480ff),
      "entscheiden aber ueber KEINEN Skip mehr" (:366-367). Lager-Schluessel weiter .fingerprint
      (bestand_key_of-Doktrin :517-520).
    => Das zu buendelnde Invalidierungs-Ereignis existiert weiterhin NICHT. Entlastung HAELT.
(2) E-E FAKTISCH BEJAHT (KON58-05 "Overlay-Glied [7] hasht Quelltext")? -- JA, GEBAUT UND SCHARF:
    * anatomy_fingerprint.hpp:126 verbatim: "E-E (07.08.2026): SCHARFGESCHALTET. DIE DREI OWNER-
      FESTLEGUNGEN LIEGEN VOR"; kOverlaySourceHash = COMDARE_OVERLAY_SOURCE_HASH (:157);
      kAnatomyFingerprintOverlayGlied = 7 (:436); HARTES #include des GENERIERTEN Headers (:22-30,
      "KEIN __has_include" -- Abwesenheit des Codegens bricht den Bau laut).
    * Fuellkette komplett: tools/overlay_source_hash_gen/main.cpp (Pre-Build-Codegen, schreibt
      #define COMDARE_OVERLAY_SOURCE_HASH "<128-hex>", :249-250) -> cmake/overlay_source_hash.cmake
      (Custom-Target VOR jeder Uebersetzung, :37-45; eingebunden CMakeLists.txt:824) -> Naht
      profile_facade/overlay_source_hash_naht.hpp (-D an jede Tier-Uebersetzung, :78-85) ->
      CEB-Laufzeit-Zwilling lazy_adhoc_source_gen.hpp. 26 Dateien verdrahtet (grep-Zaehlung).
    * Gegenprobe "gefuellt": im unkonfigurierten Quellbaum liegt build/generated/... nicht vor --
      das ist BAUZEITLICHE Fuellung, kein Leerstand: der harte Include + cmake-FATAL_ERROR
      (overlay_source_hash.cmake:30-35) machen ein leeres Glied unbaubar. KEIN Format-Bump noetig
      und keiner gemacht (:151-156: Begruendung Bestand=0, fail-closed statt fail-open).
    * Marker gegen Wieder-Vorlage ist GESETZT, im Code selbst (:128-131: "damit die naechste Suche
      nicht wieder auf einer beantworteten Frage landet").

## E-E-UNTERFRAGEN (anatomy_fingerprint.hpp:120-123 der Vorlage) -- AM OBJEKT BEANTWORTET

Die Vorlage-Zeilen 120-123 (OFFEN/nicht geraten) existieren nicht mehr; an ihrer Stelle stehen die
drei Owner-Festlegungen (heute :132-137) und ihre EINE Materialisierung builder/overlay_source_set.hpp:
  (1) KONKATENATION, EINMAL SHA-512 (kein Hash je Datei) -- :132 bzw. Set-Kopf :20-24.
  (2) FESTE ORDNUNG = BESTEHENDE kanonische Ordnungen: Organ kCompositionAxisNames (18), System
      kSystemAxisOrder (3), Mess strukturell EINE Achse -- :133-135; compile-harte Ordnungs-Wachen
      overlay_source_set.hpp:330-361 (Name-fuer-Name-Abgleich gegen beide Quellen).
  (3) VERZEICHNIS-SCHNITT = je Achse die Dateimenge ihrer EIGENEN Implementierung + anatomy/ als
      Tier-Substanz -- :136-137; DER SCHNITT selbst: kOverlaySourceSet (:130-202, Organ je 2 Pfade
      organ_axes/+topics/-Huelle, queuing q1/q2 seit #72/KON72-05 nur ORGAN-Home, System/Mess als
      datei_praefix in system_axes/ bzw. mess_axes/ seit S-18/#16 KON27-01), Endungslisten :206-213
      (fail-loud bei unbekannter Endung), Home-Pin-Wache :379-407.
Der Schnitt ist NACH der Scharfschaltung gepflegt worden (15.08.-Homes drin) -- E-E lebt.

## E-F-KOLLISION planner_version.hpp:4-7 -- AUFGELOEST, NICHT MEHR OFFEN

* planner_version.hpp:4-7 traegt Section43.b unveraendert ("KEINE Achsen-Arrays").
* Der alte Plan-POD (version_stamp_interface.hpp, glieder_len, 8 Positionen) wurde NIE gebaut
  (Gegenprobe: 0 Treffer version_stamp_interface|version_stamp_name|kStampNameHexLen ueber
  libs/apps/adapters/tools/tests; kontext10 A-06: die Plan-Wache kompiliert weder gegen 9 noch 10).
* Der OBJEKT-Nachfolger ist S-1 (12.08., KON38-Strecke): abi/stempel_basis.hpp (604 Z.) --
  LEERE CRTP-Basis (:146-149, kein POD, 0 virtual) + DREIWERTIGE Zulassungsmatrix 7 Interfaces x
  4 Traeger = 28 Zellen (:100-117, KON7-04 x KON8-07). Planer-Zeilen Mess/System/Organ sind dort
  VERBOTEN = ABSENZ-PFLICHT (!requires, :83), NICHT leer-gerendert -- Section43.b und Matrix sagen
  dasselbe; die Kollision der Vorlage besteht nicht mehr.
* "honest-empty" lebt in praezisierter Form weiter: bewusst-leer-MIT-GRUND je Pflicht-Interface
  (:396-412; PlanerStempel::kFingerprintShaBewusstLeer + Grund, planner_version.hpp:81-84 --
  KON6-03-Luecke Planer-SHA LAUT deklariert, Fuellung eigener Posten).
* Gerenderte Zeile byte-identisch: "planner@1.0.0.c isa=x86_64 os=linux" (Kompositum
  planner_version.hpp:66-70, Vertrags-Schluss static_assert(StempelVertrag<...Planer>) :92-95).
* E-F-Restfrage an den Owner: KEINE. Doku-Nachzug (autonom): Vorlage/Plan als historisch markieren.

## JE GATE: (a) FUNDSTELLEN HEUTE / (b) WACHEN / (c) REIHENFOLGE IM BUENDEL / (d) ENTSCHEIDE

### VS-A (E-A) -- Name = SHA-256, 64 Hex, EIGENER Hash ueber dasselbe Preimage
(a) NICHT GEBAUT. Nullbefund mit Gegenprobe: version_stamp_name|kStampNameHexLen|stamp_name -> nur
    meta_meta_stamp_suffix.hpp:76/:106 (meta_meta_stamp_name, andere Sache); KEIN Konsument erwartet
    heute einen Namens-Hex (Ordner/CSV laufen ueber perm_suffix/orch_make_stem). Praezedenzen:
    orch_fnv1a_hex 16-hex (build_orchestrator.hpp:268), kStemMax=120 (:289), orch_make_stem (:290).
    Beide CT-Primitiven liegen im Baum: src/sha256/ctsha.hpp + src/sha512/ctsha512.hpp (Ledger
    :27981-27986: "der Name ist KEIN Praefix des Fingerprints ... eigener Hash ueber dasselbe
    Preimage" -- Kommentar-Pflicht an der Bau-Stelle).
(b) Bricht heute NICHTS (Name geht nie ins Preimage). Bei Bau: neue Unit-Tests => Floor-ANKER-Nachzug
    scripts/ci_test_inventory_floor.txt (avx512f 495 / avx2 491 / basis 489, HEAD-Stand; seit #39
    EXAKT-Anker: Abweichung in BEIDE Richtungen = Nenner-Befund; 3 Sprossen LIVE nachmessen im
    SELBEN Change). S-14a-Riegel und golden unberuehrt (abi/ liegt ausserhalb des Overlay-Schnitts).
(c) NACH A-01/A-02/A-04 (10. Glied + Format 4->5 + Layout 6->7 + Budget) anankern -- sonst haengt das
    Namens-Orakel am Vor-Bruch-Preimage und wird im selben Fenster zweimal geankert. VOR E-B (der
    Emitter braucht den Namen) und VOR E-D (Name in Ordner/CSV = Archiv-Ereignis; Regel der Vorlage
    "E-A vor E-D" traegt weiter).
(d) Owner: KEINER (entschieden :27974). Autonom: Bau + Kommentar-Auflage "kein fingerprint[0:64]".

### VS-B (E-B) -- Variante (i), Emitter schreibt Namen; Owner-SETZUNG "Wir brechen golden-CRC!"
(a) NICHT GEBAUT. Tier-Makro exportiert 5 extern-C-Symbole (anatomy_module_abi_v1.hpp:51-64 Kurzform,
    :99-113 + :163-164 Vollform; fuenftes comdare_anatomy_version_lines OPTIONAL, :119); kein
    Namens-Symbol, kein Emitter-Name. Ledger-Einordnung :27908-27937: Explore fand die Lagerhaltungs-
    Begruendung NICHT (Identitaet = key_sha512 aus dem Sidecar, 4 Belege: bestandslog_index.hpp:6/42,
    fingerprint_key_source.hpp, lager_pfad_grammatik.hpp:15, Ledger :3413); Bau folgt der SETZUNG,
    Kommentar muss BEIDES sagen (r5 C8).
(b) Bricht golden: kNewGolden131072Crc64 = 0x56F1B721C72DC10E (source_catalog.hpp:191 -- im EINEN
    golden-Fenster 90ee6809 B2+#16+organ_axes/F5+#72 NEU geankert; Vorgaenger 0xF1C1F26A1232073B als
    [MISMATCH]-Kommentar :188) + golden-320-Dateien + Emitter-Round-Trip-Byte-Wache. E-B FEHLT im
    gelandeten Fenster (r5 A34/C7 bestaetigt am Objekt: CRC-Neuanker ohne Namens-Emission).
    Verfahren ist geuebt und dokumentiert (26.07.: gen_golden_fullpilot --crc64, zwei Nachtrags-
    Stellen, Bissprobe). Floor-Anker-Nachzug wie bei E-A. S-14a-Riegel unberuehrt (builder/codegen
    und abi/ ausserhalb des Schnitts).
(c) Als golden-NACHPOSTEN dem NAECHSTEN golden-Bruch ZUORDNEN -- das Buendel traegt mit A-09
    (FullJoin-Umbenennung, golden-byte-wirksam) genau einen; Ein-Fenster-Prinzip: E-B(i) faehrt DORT
    mit, sonst droht ein zweiter golden-Bruch nach F2 (C7-Warnung). Reihenfolge: nach E-A (Name),
    im selben Zug wie A-11 (5. Symbol OPTIONAL->PFLICHT, KON7-01 -- derselbe Loader-/Makro-Pfad,
    Landung harmonisiert Vertraege).
(d) Owner: KEINER (Setzung :27975 steht). Autonom-PFLICHT: die Fenster-Zuordnung ausdruecklich
    BUCHEN (heute nirgends gebucht -- Par.19.1 fuehrt E-B nur im vagen Zusatz) + Kommentar-Auflage.

### VS-C (E-C) -- "mitziehen" entschieden; Entlastung haelt (Beleg oben, Behauptung 1)
(a) Sidecars unveraendert: .version/.algos/.variant entstehen build_orchestrator.hpp:300/:306/:313,
    Schreiber ab :480ff; Skip-Pfad :435-472 lieste NUR .fingerprint (+ dessen Zeile 2, s. o.).
    ZIEL-OBJEKT der alten Frage ("auf den POD") EXISTIERT NICHT: der Plan-POD wurde nie gebaut;
    heutige Traeger-Welt = AnatomyVersionLines-POD (decl.hpp) + S-1-Vertrag. Umformulierung noetig:
    "Provenienz-Inhalte auf die Stempel-/Namens-Welt ziehen".
(b) Kostenlos SOLANGE Auflage gilt: kCebContractCodegenMinor + COMDARE_ANATOMY_ABI_MAJOR literal
    unveraendert ausweisen (der +ceb=-Wert reist ueber build_version ins Toolchain-Glied [5] --
    Bucket-Ereignis, wenn angefasst; lebender Wert seit E-24 C8 '+ceb=8.0', Quelle NUR decl.hpp).
    Keine golden-/Riegel-/Frozen-Beruehrung. Floor-Nachzug nur bei neuen Tests.
(c) Frei schwebend im Fenster; sinnvoll NACH E-A (wenn die Sidecar-Inhalte den neuen Namen tragen
    sollen, entsteht sonst ein zweiter Format-Wechsel). Kein Zwang vor/nach A-01.
(d) Owner: KEINER (":27976 mitziehen"). Autonom: Ausfuehrung + Gate-Beleg der Auflage.

### VS-D (E-D) -- (a) Ordner/CSV auf Stempel-Namen, Doppelspalte; NEU: Fenster-Lage verschoben
(a) NICHT GEBAUT, Stellen heute: profile_run_entry.hpp:1400-1405 (perm_suffix -> perm_build_version/
    perm_tag_build_version; Struktur :817-818, Anwendung :878/:896), experiment_run_entry.hpp:389-393
    (symmetrisch, Anwendung :461/:476), orch_make_stem build_orchestrator.hpp:290 (Ordner-/Datei-
    Stem, kStemMax=120 :289).
(b) golden-neutral, Riegel-neutral. ABER: die Vorlage-Aussage "solange kein Messlauf gefahren ist,
    Doppel-Spalte ohne Gegenstand" ist UEBERHOLT -- F1-Messung 377503 geliefert 14.08. (KON63,
    Fenster 0 zu); Alt-CSV-Bestand existiert extern => die Doppelspalte ist jetzt SUBSTANZ
    (Joinbarkeits-Doktrin), nicht Vorsorge. Jeder weitere Lauf vergroessert den Alt-Bestand.
(c) NICHT Teil des #15-Buendels (eigenes Fenster: F5/vor dem naechsten produktiven Messlauf), aber
    HART hinter E-A (Name zuerst). Im Buendel nur: nichts bauen, was die Suffix-Kette zusaetzlich
    zementiert.
(d) Owner: KEINER (":27977 wie empfohlen"). Autonom: Terminierung ins F5-Fenster + Join-Nachweis
    (Gate G-S7-Erbe).

### VS-E (E-E) -- entschieden UND gebaut (Beleg oben, Behauptung 2); im Buendel nur REGEL, kein Bau
(a) Fundstellen: anatomy_fingerprint.hpp:22-30/:126-157/:436; overlay_source_set.hpp komplett;
    overlay_source_hash_naht.hpp:52-110; tools/overlay_source_hash_gen/; cmake/overlay_source_hash
    .cmake; CMakeLists.txt:705/:824.
(b) WACHEN-VERBUND, den jede Schnitt-Bewegung mitzieht: S-14a-Riegel tools/axis_version_lock/
    axis_version.lock -- HEUTE 718 Records (gemessen: 718 Kopfzeilen, Format v3, DREI Zeilen je
    Datei), Grundgesamtheit = GENAU der Overlay-Schnitt (organ/system/mess/tier_substanz) +
    heuristik/ (Lock-Kopf); Test test_s14_axis_version_lock_tripwire.cpp; Doktrin overlay_source_
    set.hpp:403-407: Home-Bewegung = Schnitt + Waechter-Nenner + Tripwire-Anker + Lock-Regen im
    SELBEN Change. Naht-static_asserts (wohlgeformt/transportfaehig/128-hex-oder-leer,
    overlay_source_hash_naht.hpp:92-110). Budget-static_assert-Kette :49-68 (A-02 hebt
    kAnatomyFingerprintPreimageMax=4096 MIT Beleg -- das Overlay-Glied steht mit 128 Zeichen schon
    im Budget-Beleg :54).
(c) A-13 EISERNE REGEL gilt DURCH das Fenster (nichts unter axes/ topics/ heuristik/ -- jede Quell-
    Aenderung im Schnitt verschiebt JEDEN Tier-Fingerprint; im Buendel-Fenster selbst ist das
    egal-teuer, weil Format 4->5 ohnehin alles verschiebt => Schnitt-Wartung, falls faellig, GEHOERT
    in den Bruch). KEIN eigener Bau-Posten der Gruppe.
(d) Owner: KEINER. Autonom: STALE-KOMMENTAR-NACHZUG (Fund dieser Erhebung): build_orchestrator.hpp
    :332-336 (L14: Overlay-Glied "traegt heute nur Separator+Format ... NOCH NICHT") und :343
    ("[7] ... weiter LEER") widersprechen dem scharfen E-E -- lebende Aussagen, heute falsch;
    im Fenster nachfuehren (Doku, kein Byte).

### VS-F (E-F) -- entschieden (honest-empty) UND am Objekt durch S-1 verfeinert-vollzogen
(a) stempel_basis.hpp:76-137 (Matrix, Absenz-Pflicht), :146-154 (leere Basis), :378-412 (bewusst-
    leer-mit-Grund), :424-430 (ORDNUNGSNEUTRAL, S-6-Sperre ausdruecklich); planner_version.hpp:4-7
    (Section43.b unveraendert), :29 (Include stempel_basis), :66-95 (Kompositum + Vertrags-Schluss).
    Tests: test_s1_stempel_basis_vertrag.cpp, test_stempel_zulassung_bruecke.cpp,
    test_stempel_vollbestand_registry.cpp.
(b) S-1 ist GliedCount-NEUTRAL (0 Treffer kAnatomyFingerprintGliedCount in stempel_basis.hpp) und
    ordnungsneutral => der #15-Bruch (9->10, Format 5, Layout 7) bricht die S-1-Tests NICHT.
    Die Bruch-Anker liegen woanders: anatomy_fingerprint.hpp:416 (Count=9), :436/:447 (Positionen),
    :611/:623 (Positions-Proben), stamp_layout_version==6-Gleichheits-Wache decl.hpp:285-287
    (KON45-01/3: "Wache zieht mit"), Frozen-Vektor kFrozenFingerprintV1 d53aebdb...
    (test_g3_sha512_index.cpp:89, gespiegelt in test_w10_system_cell_values.cpp und
    test_m_w12_stamp_bausteine.cpp; haengt an TEST-EIGENEN Gliedern der Laufzeit-Naht, NICHT am
    Live-Overlay-Wert => genau EIN Neu-Anker beim Bruch).
(c) Kein Bau-Posten der Gruppe im Buendel. Beruehrung: A-01 (10. Glied Hybrid-Map-Zeile, Tier "")
    ist ein PREIMAGE-Glied; das Matrix-Interface Angeschlossene (NUR Hybrid, RT-Hook KON47-02)
    bleibt davon getrennt -- Invariante RT<=CT laeuft ueber A-03/HY-A2, nicht ueber die Matrix.
    Praezedenz-Angebot fuer A-01: die bewusst-leer-mit-Grund-Mechanik (Tier traegt "" im 10. Glied).
(d) Owner: KEINER (":27979 honest-empty" + Objekt-Vollzug). Autonom: alten Plan-POD-Abschnitt
    historisieren (kontext10 A-06: "Wache im #15-Bruch mitziehen" = Plan-Doku, nicht Code).

## BAU-REIHENFOLGE INNERHALB DES BUENDELS (nur Gruppe-7-Zwaenge)

  1. A-04-Vorentscheid + A-01/A-02 (Glied-FOLGE, AxisKind-Ordnung, 10. Glied, Format 4->5,
     Layout 6->7, Budget-Hebung) = DER EINE Bruch. Frozen-Vektor + Layout-Wache + Positions-
     static_asserts ziehen GENAU EINMAL mit.
  2. DANACH VS-A: SHA-256/64-Namensfunktion ueber das NEUE Preimage + Tests + Floor-Anker-Nachzug.
  3. DANACH VS-B: Emitter-Name (i) im golden-Bruch des Buendels (mit A-09), Bissprobe + zwei
     Nachtrags-Stellen + CRC/Round-Trip-Neuanker; A-11 (Symbol-Pflicht) im selben Zug.
  4. VS-C frei im Fenster, sinnvoll nach VS-A; Gate-Beleg ceb-Minor/ABI-Major unveraendert.
  5. VS-E: kein Bau; eiserne Regel A-13 haelt bis zum Bruch; faellige Schnitt-Wartung IN den Bruch;
     L14-Stale-Kommentare nachfuehren.
  6. VS-D NICHT im Buendel (F5-Fenster), Abhaengigkeit VS-A -> VS-D notieren.

## OFFENE ENTSCHEIDE (Owner vs. autonom) -- SALDO DER GRUPPE

  OWNER: KEINE. Alle sechs Buchstaben sind seit 07.08. abend-23 gebucht (Ledger :27972-27979);
  E-E/E-F zusaetzlich am Objekt vollzogen (07.08./12.08.).
  AUTONOM-PFLICHTEN (aus dieser Erhebung): (1) E-B-golden-Fenster-Zuordnung ausdruecklich buchen
  (C7: sonst zweiter golden-Bruch nach F2); (2) Wellenplan Par.19.1-Zusatz "VS-A..VS-F offen"
  praezisieren (Entscheid zu / Ausfuehrung A,B,C,D offen); (3) Vorlage 20260807 als historisch
  markieren; (4) L14-Stale-Kommentare build_orchestrator.hpp:332-336/:343 nachfuehren; (5) E-A-
  Kommentar-Auflage "eigener Hash, kein Praefix" an die Bau-Stelle; (6) E-B-Kommentar-Auflage
  "Setzung, nicht aus dem Code" (r5 C8).
  HINWEIS OV-Doktrin: die Ledger-Zeilennummern (:27974 usw.) sind HEUTIGE Messung an der Datei
  (30136 Z.), nicht aus den Karten uebernommen; r5-Anker weichen um wenige Zeilen ab (Drift).

## NULLBEFUNDE MIT GEGENPROBE (Doktrin)

  * "Namensfunktion fehlt": 0 Treffer (Muster oben); Gegenprobe Konsument: niemand ruft einen
    Stempel-Namen -- Ordner/CSV nutzen perm_suffix/orch_make_stem (Fundstellen unter VS-D).
  * "6. Symbol fehlt": 5 extern-C-Definitionen im Makro; Gegenprobe: kein Konsument referenziert
    ein sechstes (Loader-Familie + :119 fuehrt das fuenfte als OPTIONAL).
  * "Plan-POD fehlt": 0 Treffer version_stamp_interface; Gegenprobe: S-1 existiert, wird inkludiert
    (planner_version.hpp:29) und dreifach getestet -- der Plan-POD hat keinen Konsumenten verloren,
    er hatte nie einen.
  * ".fingerprint-Bestand": 0 im GESAMTEN Arbeitsbaum inkl. build/ (find + git ls-files, 17.08.);
    Gegenprobe Fenster-0-These: F1-Messung 377503 lief EXTERN (14.08., KON63) -- die Kostenlage des
    Buendel-Bruchs richtet sich nach KON41-01/OV-4 (~45,6 h @16W Flotten-Neubau), nicht nach der
    34,4-h-Zahl der Vorlage und nicht nach dem lokalen Nullbestand.
