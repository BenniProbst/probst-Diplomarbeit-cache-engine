=== NEW-GOLDEN-DOKTRIN (ultracode-Zusammentrag, 26.07.2026) ===
Quellen: LEDGER §32-F1/§33/§34/§41/§51-B1/§66 · Memory feedback_new_golden_all_axes_xml_gt320 ·
docs/sessions/20260726-{DOSSIER-session-gesamtstand-kompaktierungs-anker,SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen,SESSION-wahrheits-anker-voll-abgleich-982-E01-E26}.md ·
Klartext-Verlauf docs/sessions/backups/20260726-session-plaintext-verlauf/ · Code source_catalog.hpp.
Hinweis: Owner-Zitate mit transliterierten Umlauten (ASCII-Auflage), Wortlaut sonst unveraendert.

(a) NEW-GOLDEN-DEFINITION (wortgenau, LEDGER:2222-2229 = §33 "BEWEIS-DOKTRIN")
Owner-Direktive verbatim: "Der golden-320-Test deckt viel zu wenig ab, nur der new-golden-Test
unter Voll-Konfiguration ist laut Plan ein legitimer Beweis, dass das System funktioniert."
Ledger-Definition verbatim: "Der legitime Systembeweis = der new-golden-Test unter VOLL-
KONFIGURATION (F1/§32): alle 17 Achsen mit >=2 permutierenden Algorithmen, N=2^17=131072
(compile-static_assert + CRC64-Referenz + test_reflect_versions_all17), Bau-Faehigkeit gegen die
CI mit dem N-Satz + Debug-Messlauf-Faehigkeit (parallelisiert, ohne Korrektheits-Garantie).
Baseline = gesamtes System kompromisslos breit (§32-F1)."
Code-Verankerung (Code/external/comdare-cache-engine/libs/cache_engine/profile_facade/source_catalog.hpp):
  :139 using FullSourceCatalog = CatalogAxes<2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1>;  // 2^17*1 = 131072
  :169 static_assert(... == 131072, "NEW-GOLDEN-ALL-AXES: FullSourceCatalog muss 17 Achsen je 2
       x persistence_target je 1 = 131072 abdecken (Q-1 FALL B).")
  :189 inline constexpr std::uint64_t kNewGolden131072Crc64 = 0x56F1B721C72DC10EULL;
  Konsumenten des N-Ankers: tests/unit/test_limits_entkopplung_vorstufe.cpp:139 (lazy Regeneration
  der 131072 ids + CRC64-Vergleich, KEINE 62-MB-Datei im git) · test_lazy_adhoc_source_gen.cpp:202
  · test_reflect_versions_all17.cpp (L2-stale-skip-Guard, GN-5).
  F-SPREAD (LEDGER:2696): welche 2 Werte je Achse ins new-golden gehen = first-2 (mp_take_c) ist
  als HAUPT-Lauf ENTSCHIEDEN; Max-Kontrast/Spread = optionaler INC-G7, GO-pflichtig, nach Abgabe.
320er-BYTE-WACHE (was sie ist und was sie NICHT ist), §33 verbatim:
  "golden-320 bleibt als Alias/Snapshot eine notwendige Byte-Regressions-Wache (Fixture-Identitaet,
  TABU-Schutz) - aber sie ist NICHT hinreichend: 13 von 17 Achsen sind dort gepinnt, sie beweist
  das System nicht." Berichts-Regel verbatim: "'golden-Roundtrip==320 gruen' wird in Berichten nur
  noch als Byte-Neutralitaets-Beleg gefuehrt, NIE als Funktions-/Systembeweis."
  Code: source_catalog.hpp:144 golden_320_catalog = CatalogAxes<4,1,1,1,4,5,1,4,1,1,1,1,1,1,1,1,1,1>
  (4*4*5*4=320); :171 static_assert(==320, "messdaten-erhaltend"); GN-2-Klammer :203-210
  kMaxMaterializableCatalogCardinality=4096 muss 2^17 IMMER ausschliessen und 320 IMMER zulassen.
  CMake-Makro (tests/unit/CMakeLists.txt:2649/2677/2705): COMDARE_GOLDEN_320_BYTE_GUARD_IDS,
  Kommentar literal "GN-8 (§33): _IDS = DEPRECATED-Alias -> _BYTE_GUARD_IDS; 320 = Byte-Wache
  (byte-identischer Gate-Waechter), NICHT der Systembeweis (= new-golden-Voll-Konfig)".
Arbeits-Regime (§41 + §51-B1): Bau = new-golden VOLL (Pflicht), Messung fuer die ABGABE = 320er
(nur Zwischenergebnis), new-golden-VOLL-MESSUNG erst ab 01.08.

(b) ANKER-HISTORIE (Byte-Wache-Datei + N-CRC), alle additiv, nie geloescht
  ids-Datei (tests/unit/thesis_tiere/, live verifiziert):
    _abi4.txt  171848 B  17.07. 19:26  ABI-4, 19 Slots
    _abi5.txt  159872 B  18.07. 16:24  ABI-5, telemetry aus binary_id heraus (INC-2c)
    _abi6.txt  155604 B  26.07.        ABI-6, 17 Slots, isa heraus (INC-2d) - byte-treue Kopie
    golden_fullpilot_320_binary_ids.txt 169226 B 26.07. AKTIV: Kopf sagt literal "ABI-7 /
      STRUKT-R ORG-18 (18 Slots, mit persistence_target-Segment; ohne telemetry-/isa-Segment)"
  N-CRC64-Anker: 0xF1C1F26A1232073B (ce aa25c9a4, 18.07., ABI-6/17 Slots, golden-N-CRC64-Fixture)
    -> 0x56F1B721C72DC10E (26.07., STRUKT-R ORG-18 / ABI-7 / 18 Slots).
  Grund des Neuankers (source_catalog.hpp:180-188, literal): "Jede der 131072 ids traegt jetzt das
  18. Segment '/persistence_target=persistence_memory_only' -> der Alt-Anker 0xF1C1F26A1232073B
  (ABI-6, 17 Slots) ist nicht mehr reproduzierbar. Der neue Wert ist NICHT gerechnet, sondern
  LITERALER Werkzeug-Output: $ comdare_gen_golden_fullpilot --crc64 / gen_golden_fullpilot:
  N=131072 ids CRC64-ECMA-182 = 0x56F1B721C72DC10E". Kardinalitaet UNVERAENDERT 131072 - "der
  Bruch ist reine Segment-Verlaengerung, keine Raum-Aenderung (Q-1 FALL B: persistence_target K17=1)".
  Mitgebrochen: POD sizeof 1272->1344, POD-Version 7->8, ABI-Major 6->7, Magic .A6.->.A7.,
  CSV-Spalten 160->169, Registry 18/83 (FALL-B). Landung: ce 774a5d5f (ORG-18 T17) + fcd95a44
  (B-16/B-17, alle 17->18-Konsumenten, 314/314 gruen). B-15-Auflage erfuellt: ZUERST _abi6.txt
  additiv einfrieren (kein rm), DANN regenerieren, DANN CRC neu ankern.

(c) OWNER-AUSSAGEN ZUR GOLDEN-ZUKUNFT, chronologisch (Ref = Chunk:Zeile bzw. jsonl-Zeile)
 1. 11.07. 11:06 (jsonl:29278) URSPRUNG: "Bitte plane als eine weitere Aufgabe nach dem aktuellen
    Strang, den 320er Lauf so zu erweitern, dass er je Achse eine Konfiguration beruehrt und auch
    sonst alle Features, Frameworks und Lastprofile fordern, damit haben wir einen goldenen Test.
    die Anzahl der steuerbaren achsen hatte sich zuletzt auch erweitert. Dadurch wird zwar das
    Standard Messen wesentlich umfangreicher, aber wir haben alle Funktionen abgedeckt"
 2. 17.07. (verlauf-17:874) BRUCH-ERLAUBNIS mit Additiv-Vorrang: "ich bin ok damit, wenn wir die
    alt golden 320 fuer die Implementierung einer leichteren Wartbarkeit und allgemeingueltigeren
    Metaprogrammierung brechen. Also erst Additiv handeln und dann koennen wir gerne auch mal
    aufraeumen ohne Funktionalitaet zu verlieren und ohne unnoetig Funktionalitaet von der compile
    time fuer die Laufzeit-teure runtime umzubauen (nur unter Absprache)"
 3. 18.07. 16:26 (jsonl:54957): "Ansonsten A2-Neben auch volles GO fuer den golden Umbau"
 4. 18.07. 18:43 (jsonl:55260) GRUNDLAGEN-AUFTRAG: "Bitte erstelle durch einen ultracode workflow
    eine neue Grundlage fuer ein XML welches alle Achsen abdeckt und daher ein new golden 320 baut,
    aber es werden laut Permutations-Mathematik mehr als 320 Rekombinationen werden, nimm diese neu
    ermittelte Zahl mit compile und test als neues golden Ziel, sobald dieser fix hier laeuft,
    merke dir das, dann weiter"
 5. 18.07. 19:17 (jsonl:55452): "Das ist die Voraussetzung fuer das neue golden N"
 6. 19.07. (verlauf-19:740) BRUCH-FREIGABE + LOESCH-GO: "weiterhin ist laut ledger auch die 320er
    zwar eine Grundlage aber ueberholt und darf mit allen Erweiterungen gebrochen werden, weil sich
    die Achsenstruktur und die Anzahl der Achsen vergroessert und geaendert hat. [...] Aber ja, wir
    bauen neu und brechen es fuer etwas neues besseres, additiv ist aufgehoben, bitte so sauber wie
    moeglich nach Plan. Wir loeschen die golden und die Messwerte und beginnen von vorn mit einer
    neuen golden Version. Bruch Freigabe."
 7. 19.07. (verlauf-20:966) EINSCHUB-ORDNUNG: "Bitte vergiss aber den Hauptstrang vor dem Einschub
    der neuen golden Direktive nicht, sie wird weiterhin ausgefuehrt, sobald der Standard der neuen
    golden ueber alle Achsen angehoben wurde um echte Regressionen ueber das gesamte System zu
    erkennen"
 8. 19.07. (verlauf-20:1388): "Und golden==320 ist falsch und laengst ueberholt"
 9. 19.07. (verlauf-22:61 = §32-F1) VOLL-KONFIG-DEFINITION: "F1: Das new golden soll fuer den Build
    mit mindestens 2 zu permutierenden Algorithmen auf jeder verfuegbaren Achse bauen und einen
    Debug Messlauf (parallelisiert nach Ledger) ohne Garantie auf Korrektheit der Messergebnisse
    durchfuehren koennen. Der Debug vs Messmodus ist eine Unter-Achse auf der Mess-Achse fuer die
    Einstellung des Gesamtexperiments (weitere Einstellung auf der XML). Daher (c) ist das
    tatsaechliche Ziel mit dem vollen golden N. Die Baseline ist tatsaechlich das gesamte System
    mit allen Features kompromisslos breit zur Verfuegung zu stellen."
10. 19.07. (verlauf-22:63 = §32-F2) REGIME: "F2: Wir bauen das System gegen die CI mit dem new
    golden Satz auf, dann konfigurieren wir wieder die golden 320 in die XML und Testen tatsaechlich
    damit. Dadurch geht bauen etwa auf 8 Stunden compile und Messen auf 4 Stunden. Das ist
    vertretbar. Im Kern wie du es empfohlen hast. Fokussiert aber nicht schnell, sondern sauber und
    ohne Umwege."
11. 19.07. (verlauf-22:185 = §33) BEWEIS-DOKTRIN: "Hinweis: der golden 320 Test deckt viel zu wenig
    ab, nur der new golden Test unter Voll-Konfiguration ist laut Plan ein legitimer Beweis, dass
    das System funktioniert."
12. 19.07. (verlauf-22:1522 = §41) TERMIN-SCHNITT: "Wir bauen alles new golden und messen alles mit
    der 320er. Wir messen new golden ab dem 01.08. . Bis Freitag muessen wir nur nachweisen, dass
    wir alles bauen und das Meiste CI und lokal messen koennen"
13. 20.07. 09:05 (jsonl:63243 / verlauf-23:1769 = §51-B1) VERBINDLICH: "B1: new golden ist die neue
    Pflicht. Nur fuer das Zwischenergebnis akzeptieren wir die Messung der 320er, aber bauen bereits
    new golden auf. Also wie bereits entschieden und empfohlen. Bitte halte die Entscheidung
    verbindlich fest."
14. 20.07. (verlauf-25:1102) golden-Relevanz der Pruefling-Merges: "Ja das ist korrekt, das sind
    dann die Tier-Binaries mit allen Mess-Artefakten zusammen, die dem jeweiligen Pruefling
    zugefuehrt und gespeichert werden (in einem Unterordner unter root lokal (default) oder per XML
    auch in der cache unter minio"
15. 26.07. 13:18 (jsonl:79891, Q-0/Q-1) SCHNITT+ACHSE: "Q-0: Dann ist das so. Wir benoetigen die
    perfekt saubere Version. Es dauert eben so lange es dauert. Ich akzeptiere V2 Byte-Schnitt,
    volles GO. Ich wuensche mir dennoch V3 direkt mit rein [...] Q-1: Wie empfohlen, korrekt. Die
    Achse wird per XML deaktiviert und das muss unterstuetzt sein."
16. 26.07. (Achsen-Neuordnungs-Doc, Owner-GO) 18. ORGAN-HAUPT-ACHSE persistence_target: "KONSEQUENZ:
    binary_id 17->18 (kCompositionAxisNames, AdHocComposition-static_assert, Observer-POD
    axis_stats[17], golden-CRC) = bewusster golden-/ABI-Bruch im OFFENEN §66-G2-Bruch-Fenster -
    Einbau VOR Voll-Bau-4, damit der neue golden die 18. Achse von Geburt an traegt."
17. 26.07. (DOSSIER:222) B-15-GO: "ZUERST golden_fullpilot_320_binary_ids.txt additiv als _abi6.txt
    einfrieren (kein rm), DANN regenerieren (Kopf 18 Slots), DANN CRC neu ankern."
18. 26.07. (dieser Auftrag, woertlich): "Golden Bruch, wir bauen es nach Plan, das alte golden ist
    verweest und ueberholt, new golden ist angesagt, bitte suche new golden per ultracode."
    (nicht mehr im 16:18-Backup enthalten - Backup endet 15:05, jsonl:81082.)

(d) WAS "DAS ALTE GOLDEN IST VERWEEST" FUER DIE BESTEHENDEN WACHEN HEISST
 1. 320er-Datei: keine Byte-Ewigkeit, sondern eine je ABI-Generation NEU zu materialisierende
    Wache. Sie ist bereits verweest+erneuert: die aktive golden_fullpilot_320_binary_ids.txt tragt
    heute ABI-7/18 Slots; ABI-4/5/6 liegen als _abi{4,5,6}.txt additiv daneben (Messdaten-Doktrin
    "nie loeschen"). Konsequenz fuer die naechsten Brueche (E-08: 7. System-Achse NUMA/locking,
    page_type, je-HW-Typ-Achse, Meta-Meta-Definition - im Wahrheits-Anker-Doc explizit "ACHTUNG
    golden-brechend"): dasselbe Verfahren erneut, ZUERST _abi7.txt einfrieren, dann regenerieren,
    dann CRC neu ankern - kein rm, kein stilles Ueberschreiben.
 2. CatalogAxes<4,4,5,4> = 320 (golden_320_catalog) bleibt als STRUKTUR bestehen und ist NICHT
    aufgehoben: der static_assert :171 "messdaten-erhaltend" haelt die alte 4*4*5*4-Semantik fest,
    weil die 320er der ABGABE-Messdatensatz ist (§41/§51-B1). Verweest ist ihr BEWEIS-ANSPRUCH,
    nicht ihre Existenz. Achtung: nach ORG-18 ist die Achsen-Liste 18-stellig - der Katalog steht
    live als CatalogAxes<4,1,1,1,4,5,1,4,1,1,1,1,1,1,1,1,1,1>, das TABU-Kuerzel "<4,4,5,4>" ist nur
    noch Produkt-Kurzschrift (Kommentar :300 fuehrt die alte Schreibweise noch als G5-Audit-Text).
 3. Roundtrip-Gates behalten ihre Gueltigkeit, verlieren aber ihren Rang: test_profile_roundtrip
    (CMakeLists :3752-3766, Profil-Pfad gegen die 320er-Liste, Resume-#139-Schutz) und
    test_limits_entkopplung_vorstufe (:3554, 320er-Datei als argv + N-CRC64) sind ab §33 nur
    BYTE-NEUTRALITAETS-Belege. Ein Bericht darf "golden-Roundtrip==320 gruen" nie als Funktions-
    oder Systembeweis fuehren; der Systembeweis je Increment = N-Referenz-Guards gruen
    (static_assert 131072 + kNewGolden131072Crc64 + test_reflect_versions_all17) plus der N-Voll-
    Konfigurations-Bau/Debug-Lauf in der CI.
 4. Praktische Folge fuer den jetzigen Bruch-Zyklus: ein 320er-Roundtrip-Rot nach einem Achsen-
    Zuwachs ist ERWARTET und kein Defekt - er ist das Signal, die Wache im koordinierten Fenster
    neu zu materialisieren (Reihenfolge: Alt einfrieren -> regenerieren -> CRC ankern -> alle
    17/18-Konsumenten ziehen, Muster ce 774a5d5f + fcd95a44). Ein GRUENES 320er-Gate nach einem
    Achsen-Zuwachs waere umgekehrt der Verdachtsfall (Wache haengt an einer stale Datei).
 5. Ledger-Rest-Offenheit: LEDGER:2435/2570/2760 fuehren den §33-Systembeweis weiterhin als OFFEN/
    TEIL, kritisch ("CE-seitig NICHT gebaut, kein Stale-Green"); die N-CRC-Fixture allein schliesst
    #49/GN-3 NICHT. Der Neuanker 0x56F1B721C72DC10E aendert daran nichts - er macht die Wache nur
    wieder wahr; der Beweis entsteht erst mit dem Voll-Bau-4-Lauf ueber die neue Kette.
