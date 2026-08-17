# OWNER-VORAB #15 -- ENTSCHEIDE VOR DEM EINEN BRUCH (additiv datiert 17.08.2026)

Grundlage: 7 Explore-Karten 17.08. @ ce development 04ac26fa + Wellenplan Sec.19.1 + Ledger. Diese Liste
traegt NUR Entscheide, die das Owner-Wort VOR dem Bruch (bzw. V-10: vor dem ersten Nach-Bruch-golden-
Batch) brauchen. Alles am Objekt Entschiedene steht als FAKT im BUENDEL-BAUPLAN-15.md (Abs.8), nicht hier.
Namensraeume: Owner-Fragen hier = V-01..V-13 (zweistellig); Bauplan-Schritte = VL-x (Vorlauf),
B-x (Bruch), N-x (Nachlauf). Zeilenangaben = Messung 17.08.

## V-01  A-04: GLIED-FOLGE (Count 10) + AxisKind-ORDNUNG IM SELBEN BRUCH?

FRAGE      Welche endgueltige Preimage-Glied-FOLGE gilt bei Count 10 (inkl. ob [1]organ<->[3]mess nach
           S-6a tauschen), und dreht die AxisKind-Enum-Ordnung im SELBEN Bruch mit?
KONTEXT    KON5-04(3)/KON5-05 verlangen den Entscheid VOR dem Bruch, sonst steht der teuerste Bruch
           erneut an (Wellenplan A-04). Heute: Folge [0]format..[8]messgates (anatomy_fingerprint.hpp
           :593-605); AxisKind (topics/axis.hpp:17-50) ist organ,system_measurement,...,organ_meta_meta
           mit bewusster Anhaenge-ans-Ende-Doktrin; bei MESS,SYSTEM,ORGAN bleibt SYSTEM auf Glied [2]
           (gruppe3 1a, entschaerft).
EMPFEHLUNG (a) Preimage: [1]<->[3] auf MESS,SYSTEM,ORGAN drehen (S-6a-Wortlaut), Hybrid-Map als Schwanz
           [9] (R-3-Praezedenz Anhaengen); (b) AxisKind NICHT umordnen, sondern im selben Bruch per
           Kommentar + S-21-Wache als "append-only, KEINE Ordnungs-Quelle" festschreiben -- Ordnung
           lebt in kSystemAxisOrder/Glied-Folge; eine Enum-Rotation waere ein Serialisierungs-Ereignis
           ohne gemessenen Nutzen.
WIRKUNG    Ohne Antwort kann B-5 nicht starten (Folge unklar = jedes Byte provisorisch); eine spaetere
           Umordnung waere ein zweiter Flotten-Neubau (~45,6 h @16W).

## V-02  A-03: BYTE-GRAMMATIK DER HYBRID-MAP-ZEILE (10. GLIED)

FRAGE      Welche Byte-Grammatik traegt die Hybrid-Map-Zeile (Feld-Ordnung, Trenner, Dock-Adressierung)?
KONTEXT    Ein Synthese-Key existiert nicht; KON47-02 setzt Map-VALUE = Tier-SHA (nicht Voll-Stempel);
           32 Docks x (128-hex-SHA + Key/Trenner ~17) >= ~4,6 KB sprengt die 4096 (gruppe1 Abs.1/2).
           Ohne Grammatik ist das Glied-Budget (A-02) nur schaetzbar und das Glied nicht baubar.
EMPFEHLUNG R-2-Vorschlag zur Abnahme: "hy=" + je Dock "<stufen_id>:<tier-sha512-128hex>" in fester
           stufen_id-Ordnung (Formel Layer*Nodes+Node, heuristik_adapter_synthese_matrix.hpp:139),
           ';'-getrennt, leere Zeile == Identitaet (Tier traegt "") -- volle 128 hex nach KON47-02,
           NICHT der 64-hex-E-A-Name (anderes Objekt).
WIRKUNG    Ohne Antwort bleibt A-02 Schaetzung und A-01 unbaubar; ein Nachschieben der Grammatik nach
           dem Bruch waere Format 5->6 = zweiter Flottenbruch.

## V-03  S-6a-MAKRO-EBENE + GOLDEN-BUENDEL-FREIGABE (inkl. TABU-CRC-VERFAHREN)

FRAGE      Dreht S-6a auch die MAKRO-Signatur/Argument-Reihenfolge (organ,system,mess -> mess,system,
           organ; golden-bewegend), und gilt die EINE golden-Freigabe des Buendels (A-09 + E-B + ggf.
           Makro-Tausch, Re-Anker literal am Ende, neuer TABU-Wert zur Bestaetigung)?
KONTEXT    Der Wellenplan verlangt S-6a an allen DREI Aussen-Ebenen; nur die Makro-Ebene bewegt den
           emittierten Quelltext (adhoc_emitter :126-138) und damit 320er-/golden-Anker -- POD+Preimage
           allein sind golden-neutral, erfuellen den Wortlaut aber nicht (gruppe1 3d, gruppe3 Abs.10).
           Das Buendel traegt mit A-09 und E-B ("Wir brechen golden-CRC!", Ledger :27975) ohnehin ein
           deklariertes golden-Ereignis; neuer TABU-Wert braucht Owner-GO (Praezedenz 26.07.,
           source_catalog :183-190).
EMPFEHLUNG JA zum Makro-Tausch im Buendel: ein spaeterer Tausch waere ein EIGENES golden-Ereignis nach
           F2 (C7-Warnung); die Freigabe als EIN Paket erteilen, neuer TABU-CRC wird bei der Landungs-
           Meldung literal vorgelegt (gen_golden_fullpilot --crc64) und mit dem F2-GO bestaetigt.
WIRKUNG    Ohne Antwort bleibt S-6a halb (Ebenen divergieren) oder der Bruch wartet; ein Nachzug nach
           F2 kostet ein zweites golden-Fenster plus Flotten-Neubau.

## V-04  A-07: FELD-FORM DER E-1-REKURSIONS-STEMPEL-FELDER

FRAGE      Fahren Tiefe + Stufen-IDs als Felder IN der Hybrid-Map-Zeile, als eigenes Glied oder als
           POD-Felder?
KONTEXT    Owner-Anker Z15504 sagt nur "als Stempel-Felder"; im Preimage/POD existiert heute kein
           Rekursions-/Stufen-Feld (Nullbefund mit Gegenprobe, gruppe1 Abs.4); die CT-Mechanik lebt in
           heuristik_adapter_synthese_matrix.hpp (:99 Tiefe=1, :139 stufen_id, :220-238 Formel-Pins).
           Die Felder MUESSEN in den EINEN 4->5-Bruch, sonst folgt Format 5->6.
EMPFEHLUNG Felder IN der Hybrid-Map-Zeile (V-02-Grammatik um "d=<tiefe>" + IDs erweitern): sachlich
           gehoeren sie zur Hybrid-Synthese, kein 11. Glied noetig, keine POD-Verbreiterung; Tiefe
           heute konstant 1 -> ein Feld je Stufe nach 32er-Formel reicht.
WIRKUNG    Ohne Antwort fehlen die Felder im Bruch (zweiter Flottenbruch bei Nachruestung) oder der
           Bau raet gegen ein Owner-Wort.

## V-05  REKOMBINATIONS-NAME: INS POD (LAYOUT-7-FELD) ODER EIGENES INTERFACE?

FRAGE      Faehrt der Rekombinations-/Stempel-NAME (E-A, SHA-256/64 hex) als POD-Feld name_line/len im
           selben 6->7-Bump oder nur als eigenes constexpr-Interface/Export?
KONTEXT    Owner-KERN "Name der Funktion aus dieser Rekombination in die Binary" (22.07., LEDGER:3339);
           das POD traegt heute KEIN Namensfeld (decl :201ff, Nullbefund gruppe4); ein spaeterer
           POD-Anbau waere Layout 7->8 = erneuter teuerster Bruch (gruppe4 Zwang 4, gruppe6 c4).
EMPFEHLUNG INS POD im selben Bump (sizeof 120->152 mit Hybrid-Zeile): RT-Leser (Loader/Pruefdock/Lager)
           bekommen den Namen ohne zweiten dlsym-Weg; ZUSAETZLICH die CT-Namensfunktion als Interface
           (beides, POD = RT-Transport, Interface = CT-Vertrag).
WIRKUNG    Ohne Antwort bumpt Layout 7 ohne Namensfeld; jede Nachruestung ist Layout 7->8 samt
           Flotten-Invalidierung.

## V-06  A-11: GELTUNGSBEREICH DER 5.-SYMBOL-PFLICHT

FRAGE      Gilt die Pflicht des 5. ABI-Symbols nur fuer SearchAlgorithm-Tier-DLLs oder fuer alle 5
           Gattungs-Makros (Set/Sequence/View/Adapter erhalten dann das Stempel-Makro im Fenster)?
KONTEXT    KON7-01 sagt "Pflicht", nennt den Gattungs-Schnitt nicht; die vier anderen Gattungs-Makros
           definieren heute NUR die 4 Pflicht-Symbole (0 VERSION_STAMP-Treffer, gruppe4 G4-5), und
           DERSELBE gattungs-agnostische Loader laedt sie -- Pflichtschaltung braeche deren DLLs.
EMPFEHLUNG Pflicht fuer ALLE 5 Gattungs-Makros, Stempel-Makro in die vier nachziehen (ein Loader, EINE
           Regel; ein Gattungs-Schnitt am Loader waere eine zweite Wahrheit); Test-Minimalmodule als
           Negativ-Proben umwidmen.
WIRKUNG    Ohne Antwort bleibt A-11 (SOLL: Pflicht) unbaubar oder bricht Set/Sequence/View/Adapter-
           Ladungen unentschieden; das Buendel landet mit optionalem Stempel-Symbol.

## V-07  FORM DES GESONDERTEN VERSIONIERUNGS-INTERFACES (TIER/HYBRID)

FRAGE      Ist das "gesonderte Interface" je Stufe am Tier/Hybrid ein Export-Symbol, eine CRTP-Erbin im
           Kompilat oder beides?
KONTEXT    Owner 22.07./06.08. (LEDGER:3339, Z24489-92): je Stufe separates Interface, constexpr SHA512
           ueber die Stempel-String-Arrays; heute existiert der Tier-Stempel NUR als POD am optionalen
           5. Symbol, Tier-/Hybrid-Erbin fehlt (einzige Treffer = Matrix-Pin + Testproben, gruppe4).
EMPFEHLUNG BEIDES: CRTP-Erbin nach P4/P5-Muster (CT-Vertrag, stempel_basis-Matrix waechst kontrolliert,
           28-Zellen-Pin zieht mit) + Export ueber das nun pflichtige 5. Symbol/POD (V-05/V-06) --
           kein neues sechstes Symbol.
WIRKUNG    Ohne Antwort bleibt G4-1 (Owner-KERN) liegen; B5-Stempel-Pflicht je Schalter (haengt an den
           Tier-/Hybrid-Komposita) verschiebt sich mit.

## V-08  PLANER-SHA: PREIMAGE-/GLIED-ENTSCHEID

FRAGE      Bekommt der Planer-Stempel seinen fingerprint_sha jetzt (und falls ja: mit eigenen Preimage-
           Gliedern im selben Format-5-Bruch) oder bleibt kFingerprintShaBewusstLeer bis zu einem
           eigenen Posten?
KONTEXT    planner_version.hpp :80-84 deklariert die Luecke LAUT und reserviert "Preimage-/Glied-
           Entscheid" ausdruecklich als eigenen Posten (gruppe4 G4-1); zoegen Planer-Glieder ins
           Tier-Preimage, muessten sie in DIESEN Bruch (A-04-Kopplung).
EMPFEHLUNG Planer-SHA im Fenster fuellen (CT-SHA512 ueber die EIGENEN Planer-Zeilen), aber KEINE
           Planer-Glieder ins Tier-Preimage: Planer-Identitaet ist Planer-Stempel-Sache; das
           Tier-Preimage bleibt Traeger der Tier-Identitaet -- damit ist kein Format-Bezug da.
WIRKUNG    Ohne Antwort bleibt die deklarierte Luecke offen (vertretbar), ABER falls der Owner Glieder
           im Tier-Preimage will, waere das nach dem Bruch Format 5->6.

## V-09  A-08: prod2-ZIELTOKEN + RMA-VERFAHREN + VORHER-BELEG

FRAGE      Wie heisst der neue prod2-Identitaets-Token (Vorschlag "prod2_alder_lake"), gilt bei
           14900KS-Rueckkehr aus RMA eine ADDITIVE neue machine_id, und genuegt der 09.08.-lscpu-Beleg
           (Job 368969) als VORHER-Messung solange Infra #207 den Host sperrt?
KONTEXT    Owner "Ja umbenennen" (Z15650) mit Auflage VORHER messen; das Repo kennt die Wahrheit
           (Alder Lake i9-12900K, machine_identity :191/:250), traegt aber "prod2_raptor_lake" als
           Token (gruppe2 Posten 4); der Host ist aktuell nicht aufloesbar (#207), der Live-Beleg
           09.08. liegt im Ledger (Z17243-17247).
EMPFEHLUNG Token "prod2_alder_lake"; RMA-Rueckkehr = ADDITIVE neue machine_id (Memory-Regel: Hardware-
           Erweiterung ist additiv, Umbau nur bei Funktionseinschraenkung); 09.08.-Beleg anerkennen
           (frischer lscpu unmoeglich, Beleg ist juenger als jede Registry-Zeile).
WIRKUNG    Ohne Antwort faellt A-08 aus dem Bruch; das falsche Etikett wandert ueber Overlay-Glied [7]
           in die naechste Flotten-Generation und die Umbenennung wird nach F2 teuer.

## V-10  AVX-512-IN-GOLDEN + no_extension-CROSS-SKIP (vor dem ERSTEN Nach-Bruch-golden-Batch)

FRAGE      Kommt AVX-512 in die golden-Matrix (bewusste UMKEHR eines 2x deklarierten Owner-Worts),
           und darf no_extension cross-geSKIPpt werden (Bau ja -- aber gilt das auch fuer Messung)?
KONTEXT    r1 A-12 (Dossier-Owner-Buendel): (a) waere eine Umkehr, die nur der Owner aussprechen kann;
           (b) Bau-Cross-SKIP plausibel, MESS-PROVENIENZ heikel. Der Bruch invalidiert die gesamte
           Flotte; der erste golden-Batch danach traegt den Neubau (~45,6 h @16W, KON41-01/OV-4).
EMPFEHLUNG (a) Beim deklarierten Owner-Wort bleiben (kein AVX-512 in golden), bis der Owner die Umkehr
           ausdruecklich setzt; (b) Cross-SKIP nur fuer den BAU, Messung bleibt host-echt (Provenienz-
           Doktrin). Entscheid zusammen mit dem Buendel-GO, damit der Neubau gegen die FINALE Matrix
           laeuft.
WIRKUNG    Ohne Antwort laeuft die Neubau-Welle gegen eine womoeglich sofort veraltete Matrix -- eine
           zweite ~45-h-Welle droht.

## V-11  A-09/A-06-C: ERSATZ-BEZEICHNER (PRUEFLING-FAMILIE) + WEG a (FIXTURE-RENAME, F3)

FRAGE      Welche Zielnamen ersetzen Stufe1_CeOnly/Stufe2_PrueflingReplace/Stufe3_FullJoin (+ XML-Token
           "fulljoin" + Kompositions-Namen + Klasse-C-"Stufe" im phase-Element), und wird Weg a
           (Umbenennung der ce-Fixture experiment_golden_kern.xml) gegangen?
KONTEXT    KON36/WF7: kuenftiger Bezeichner gehoert zur PRUEFLINGS-Familie, Vorschlag zur Abnahme beim
           S-6-Fenster; KON91 behaelt "FULL JOIN" fuer die Mess-Union (deshalb raeumt der Merge das
           Wort); golden-byte-wirksam (KON30-02). Weg a war explizite, unbeantwortete Owner-Frage F3
           (Z24718); Weg b (Subset-Wache) ist gebaut und lebt. 29 Dateien tragen das Wort (gruppe2).
EMPFEHLUNG Familie "PrueflingVerbund": Verbund1_CeOnly / Verbund2_Replace / Verbund3_Union, XML-Token
           "union" statt "fulljoin" (raeumt die KON91-Kollision hoerbar); Weg a NICHT gehen -- die
           Fixture ist ABSICHTLICH divergente Naht-Fixture (r4 B-12), Weg b traegt; Rename waere
           Cross-Repo-Bewegung ohne Zusatznutzen.
WIRKUNG    Ohne Antwort kann A-09 nicht im golden-Ereignis des Buendels mitfahren; die Wort-Kollision
           bleibt, und eine spaetere Umbenennung ist ein EIGENES golden-Ereignis nach F2.

## V-12  G-5: EIN-SATZ-BESTAETIGUNG DER ENUM-ORDNUNG (BYTE-EREIGNIS)

FRAGE      Bestaetigt der Owner, dass die work_mode-/RunMethodology-Enum-Ordnung im Bruch auf
           {Build=0, Measure=1, Compare=2, Release=3} dreht (Ordinal-Doppelschub Release 2->3,
           Compare 3->2)?
KONTEXT    G-5 wurde vorgelegt und nie beantwortet (r1 A13, r4 C-7: "bleibt beim Owner, ins
           #15-Fenster"); die geltende work_mode-Fassung (09.08., Kette build->measure->compare->
           release, kWorkModeCount=4) beantwortet die Sache MATERIELL; die Registry vermerkt heute
           ausdruecklich "Enum-Reihenfolge bewusst NICHT umgestellt: stempel-/ABI-relevant" (:19-24).
EMPFEHLUNG Bestaetigen (ein Satz genuegt, gruppe2): Ziel-Aufzaehlung == Ketten-Ordnung; der Vollzug
           faehrt im selben Bruch wie Layout/Format -- ein separater Ordinal-Bruch waere ein zweites
           Byte-Ereignis.
WIRKUNG    Ohne Bestaetigung wuerde der Bau ein ausdruecklich Owner-reserviertes Byte-Ereignis aus
           Ableitung vollziehen -- oder es unterbleibt und die Ist-Ordnung widerspricht der Kette
           dauerhaft.

## V-13  kCebFingerprint: PERMUTIERTE LEGENDEN-ZWILLINGE IN #15 KANONISIEREN?

FRAGE      Wird die Ueberunterscheidung permutierter Legenden ("[wallclock,micro]" != "[micro,
           wallclock]", zwei Schluessel fuer dieselbe Menge) im #15-Bruch kanonisiert oder dauerhaft
           getragen?
KONTEXT    Am Objekt gemessen (250be8b2 vs a30fe495, ceb_version_stamp Kopf :86-101); der Kopf nennt
           die Kanonisierung ausdruecklich "eigene Scheibe mit Owner-Entscheid"; sie ist ein Byte-
           Ereignis am Tier-Preimage (Glied [3]) -- #15 ist das LETZTE kostenlose Fenster (gruppe5).
EMPFEHLUNG In #15 falten: kanonische Sortierung in der EINEN Zerlegung (ceb_tooling_list); der
           Format-Bump verschiebt ohnehin jeden Schluessel, danach kostet dieselbe Heilung einen
           eigenen Flottenbruch.
WIRKUNG    Ohne Antwort bleiben Zwillings-Schluessel dauerhaft (Lager/Skip sehen zwei Identitaeten je
           Menge) oder eine spaetere Kanonisierung wird ein eigener Bruch.

## GEPRUEFT UND NICHT VORGELEGT (mit Grund; Details BUENDEL-BAUPLAN-15.md Abs.8)

  O-2 (cxx/opt/build_type + bvset, "Option A/B"): AM OBJEKT GEHEILT -- Glied [5] traegt cxx/opt/bt
    (toolchain_stamp_glied :249/:292), Glied [6] = bvset. Frage gegenstandslos; nur Buchung.
  VS-A..VS-F: ALLE SECHS entschieden 07.08. abend-23 (Ledger :27970-27979; E-B = Setzung "Wir brechen
    golden-CRC!"); E-E/E-F zusaetzlich gebaut/vollzogen. Keine Restfrage; der TABU-CRC-Teil steckt in
    V-03. Wellenplan-Zusatz "offen" ist Karten-Stand, wird per VL-5 gebucht.
  r3 A1/A3/A4 (CEB-Wahl, Mess-Glied, Gate-Leser): GEHEILT 06.-07.08. -- Fakten im Bauplan.
  all_axes_golden '--' + Flag (r3 A12): beidseitig erledigt seit 08.08. -- Buchung.
  #70 XorFilter: KON80-01 V1 = DIREKT (b) -- entschieden, Bau-Posten.
  A-02-WERT-Philosophie (Ist vs. Grammatik-Obergrenze): autonomer Haus-Muster-Default traegt
    (Ist-Budget MIT Beleg); eine spaetere Hebung der Konstante ist byte-neutral -- nicht vorab noetig.
  G4-4 Registry-Umzug "je im Modul" + Option B (prt-Trio): vom Bruch entkoppelt (CRC-neutraler
    Datei-Umzug), Korb-B-faehig -- nur auf Owner-Wunsch vor F2 einplanen.
  KON60 Wallclock-START-Grenze: erst Bestands-Explore (Zehn-Wochen-Regel), dann ggf. Frage.
  r3 A15 (F5-Halbsatz XML/Planer-Interpreter): von keiner Karte vermessen -- Explore VL-6b zuerst,
    unexplorierte Fragen werden nicht vorgelegt.
  B3/B5-Semantik (KON37-01/KON34-04): entschieden, Owner-Datum steht (vor F2) -- reiner Bau.
