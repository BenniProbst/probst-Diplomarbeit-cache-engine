# LESER 11 von 12 -- Extraktion Regressions-Gesamtbild (JSON-Batch, Index i%12==10)

## Batch-Dateiliste (Groessen in Bytes, absteigend)
| Index | Datei | Groesse |
|---|---|---|
| 10 | w2sl5tl3q.json | 194469 |
| 22 | wounn9tiw.json | 119343 |
| 34 | wk7d8rkxb.json | 92971 |
| 46 | wzrgiwiew.json | 73275 |
| 58 | we4k74oyk.json | 55961 |
| 70 | w7uqir5wv.json | 41499 |
| 82 | wo2zqnqhb.json | 32452 |
| 94 | wbl8tsmpf.json | 25068 |
| 106 | w7y69czwo.json | 19327 |
| 118 | wmhmvlkyd.json | 13575 |
| 130 | wd626pkat.json | 9155 |
| 142 | w2z8rp4xk.json | 6113 |

Nenner: 12 von 12 Batch-Dateien (Gesamtliste 152 Eintraege). Quellpfad je Datei:
/home/comdare/.claude/jobs/5a19728e/tmp/regressions-gesamtbild/<name>.

---

## Datei 1: w2sl5tl3q.json (6 Lose Explore+Research: Flag-Grammatik/AVX, xlsx-Blatt, Noise, Zielkategorie, Min/Max je Achse, Paper-Metriken; 6 Agenten, 1.028.333 Tokens)

### [w2sl5tl3q.json] 1
GEGENSTAND: AVX-Notation x128/x256/x512 mit '*'-Suffix existiert NIRGENDS im Korpus (Nullbefund mit greifender Gegenprobe: 'avx512' = 913 Zeilen in ce); die Substanz (per-Flag-Signatur, 14 AVX-512-Subsets) ist unter anderem Namen geplant.
ORT: super docs/architektur/20260719-simd-flag-signaturen-REFERENZ.md (Paragraph 1-3, 6); ce simd_feature_flag.hpp, machine_simd_signature.hpp
SOLL/FIX: "Was genau ein '*' bezeichnet (ein Katalog-Flag? eine Registerbreite? eine Anzahl?) sagt keine Quelle" -- Owner-Entscheid noetig, "Nicht erfunden". Owner schreibt selbst "(geplant bitte Explore)".
STATUS LT. QUELLE: offen (Owner-Frage)
ABHAENGIGKEIT/FLAECHE: Blocker G0 der Flag-Grammatik-Bauskizze

### [w2sl5tl3q.json] 2
GEGENSTAND: IST-Grammatik der Versions-Flags (v-UINT.UINT.UINT + GENAU EIN HWFLAG c/g/f/n + optional 'e') gegen Owner-SOLL 07.08. (jedes Zeichen ein FILTER, 'e' ganz vorn hoechste Prioritaet, mehrere Zeichen, zusaetzlich p und x128*/x256*/x512**): SECHS harte Bruchstellen (Kardinalitaet 1->n; 'e' Suffix->Praefix, Negativ-Tests v1.0.0e/ec/e muessen sich exakt umkehren; Alphabet; Mehrzeichen-Token mit Ziffern; ABI-Kapazitaet 2 Bit=4 Werte reicht nicht; Semantik Zielrichtung->Filter-Praedikat ohne Verbindung algo_semver.hpp<->simd_build_gate.hpp).
ORT: ce libs/cache_engine/include/cache_engine/measurement/algo_semver.hpp:26-30,197,304-331,529-544; abi/anatomy_stamp_entries.hpp:107,111-129; thesis anhang/de/D_building_block_matrix.tex:1138
SOLL/FIX: Bau-Skizze 5 Schichten (Parser FilterFlagSet + kanonische Ordnung + Doppelungs-Verbot; Renderer + CONSTEVAL-Zwilling ceb_version_stamp.hpp ceb_flag_len; ABI-Bits 9 Bit in freie 26 Bit ODER eigenes Stempel-Feld = ABI-Major-Bump; Wachen auf Teilmengen-Praedikat; Freigabe-Pruefung/Bruecke). Gates G0-G5; G1 preimage-neutral, G2 = EIN Commit / EIN Byte-Ereignis (Literal-Migration + Renderer + Zwilling + ABI-Bits im SELBEN Commit).
STATUS LT. QUELLE: offen (G0-Blocker: Owner-Entscheide fehlen)
ABHAENGIGKEIT/FLAECHE: Stempel/SHA512/.algos-Sidecar/Lager-Key (Byte-Ereignis); B11-Alias-Doktrin; Task 21 (131.072 vs 524.288 vs 2.097.152)

### [w2sl5tl3q.json] 3
GEGENSTAND: e-KOLLISION: ob das fuehrende 'e' das EXPERIMENTAL-'e' (Owner-E2 02.08.) oder das EFFICIENCY-'e' aus 'cpe' ist, ist im selben Owner-Satz widerspruechlich und nicht aufloesbar; B12-Regel "ce-eigene Registry traegt NIE e" (algo_semver.hpp:415-417) kollidiert direkt mit 'e' im Pflicht-Filter-Set.
ORT: algo_semver.hpp:415-417; super docs/sessions/20260807-OWNER-VORLAGE-cpe-grammatik-und-profil-chart.md:44-57 (Frage 1a)
SOLL/FIX: "ohne Owner-Entscheid zur e-Kollision ist diese Wache nicht widerspruchsfrei formulierbar. HARTER BLOCKER."
STATUS LT. QUELLE: offen (harter Blocker)
ABHAENGIGKEIT/FLAECHE: Flag-Grammatik G0; Wachen-Umbau 4.2

### [w2sl5tl3q.json] 4
GEGENSTAND: Weitere offene Grammatik-Fragen: Trennzeichen ja/nein (v1.0.0c-pe vs v1.0.0c.pe vorgeschlagen, Owner schweigt); Pflicht vs. optional (haengt: 178 Bestands-Literale-Migration = Byte-Ereignis); vollstaendiges Alphabet; Bedeutung 'p' (nur Schlussfolgerung aus cpe); Verhaeltnis x-Filter zu 14 Katalog-Flags (Paragraph 40.a verwirft Grob-Level, x512** liest sich wie Grob-Level+Verfeinerung); Reihenfolge-Akzeptanz (Alias-Identitaeten v1.0.0cp vs v1.0.0pc -> gleicher SHA512/Lager-Key verboten per B11); Literal-Zaehlung differiert (eigene Erhebung 178 'v1.0.0c'-Vorkommen bzw. 124 algo_version-Traeger vs. Owner-Vorlage 138); binary_id-Neutralitaet der neuen x-Filter ungeklaert; Pruef-Zeitpunkt Compile-Time vs. CEB-Laufzeit (Bruecke existiert nicht und ist nicht geplant).
ORT: algo_semver.hpp:31-36,86-95,264-267; LEDGER:2360-2362; OWNER-VORLAGE:65-67
SOLL/FIX: Vor dem Bau Menge per generischem Wachen-grep NEU erheben (algo_semver.hpp:94-95), nie handgepflegt; alle Fragen in Owner-Vorlage G0.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Flag-Grammatik G0/G2

### [w2sl5tl3q.json] 5
GEGENSTAND: SIMD-Stufenleiter ist gebaut aber INERT: alle 9 Organ-Klassen tragen kRequiredNone (static_assert !any_organ_declares_required()); Naht build_orchestrator.hpp:599-610 verdrahtet (status -4); Gate bleibt NotApplicable und emittiert nichts. Es fehlt die MIN/MAX-Trennung (required_min/optional_upto statt nur 'required').
ORT: ce measurement/simd_organ_requirement.hpp:31-34,40-50,88; simd_build_gate.hpp:58-74,147-152; builder/build_orchestrator/build_orchestrator.hpp:599-610
SOLL/FIX: G3: required_min/optional_upto + Bruecke FilterFlagSet->Gate, weiterhin inert; G4: XML-Deklaration nach REFERENZ Paragraph 6 (<isa-signature> je Node, <isa required/optional> mit cpuinfo= UND gcc=) -- im Ledger doppelt als OFFEN gefuehrt (:2736 und :2931); G5: Scharfschalten je Organ NUR mit Owner-GO (aendert Bau-Menge und golden).
STATUS LT. QUELLE: offen (teilgebaut, inert)
ABHAENGIGKEIT/FLAECHE: golden-Bestand; XML-Doktrin "alles per XML konfigurierbar"

### [w2sl5tl3q.json] 6
GEGENSTAND: Hardware-FAMILIEN-Freigabe (c/g/f/n) existiert ueberhaupt nicht -- TargetIsaSystemAxis gibt nur die Ziel-ISA frei; fuer die Familie gibt es nur die globale Politik "wir produzieren nur CPU-Code"; g/f/n laut Code-Kommentar "reserviert, nicht produziert".
ORT: super docs/sessions/20260807-OWNER-VORLAGE-cpe-grammatik-und-profil-chart.md:80-87; algo_semver.hpp:402
SOLL/FIX: "Wenn jeder Buchstabe fuer eine unterstuetzte Hardware-Art steht, die durch die Systemachse freigegeben wurde, dann muss diese Achse erst entstehen ... Das ist ein eigener Bau, nicht Teil der Grammatik." (Schicht 5.5)
STATUS LT. QUELLE: offen (eigener Bau)
ABHAENGIGKEIT/FLAECHE: Flag-Grammatik Schicht 5

### [w2sl5tl3q.json] 7
GEGENSTAND: xlsx-Blattform: als MESSWERT-Tabelle geplant (a9-Akte: ein Sheet je Unter-Achsen-Permutation, SheetSchluessel{mess_unter,system_unter,organ_unter}, INFO-Blatt, S001..Snnn, Writer erfindet KEINE Spalten, konstante Spalten -> Metadaten, CSV-Fallback je Sheet); die ZEITACHSE des Profils ist dort NICHT geplant -- nur die Zeilenform (eine Zeile je Checkpoint, observe_wall_ns) ist geplant und gebaut.
ORT: ce docs/architecture/20260803-a9_xlsx_writer_f3_soll_design.md:185-258; 24_messmodell_korrektur_zwei_dimensionen.md:437,480-486; ce builder/anatomy_commands/tier_observe_trace_abi.hpp:281-283
SOLL/FIX: Bau-Skizze: Stufe 0 Owner-Entscheid (viertes SheetSchluessel-Glied oder Spalte; eigene Mappe oder dieselbe; native Charts ja/nein; Trigger-Modus + Delta-t); Stufe 1 profil_blatt() als zweite Blatt-Sorte an bestehender Mappe (Spalten aus Trace-Header, Sheets P001..Pnnn); Stufe 2 INFO-Blatt-Sektion; Stufe 3 Achsen-Abdeckung ueber kV3AxisCount statt hartkodiert; Stufe 4 Schritt-Checkpoints hinter Metaprogrammierungs-Schalter (HY-B4). KEIN zweiter Writer, KEIN eigenes Format, KEIN Chart-Objekt ohne Stufe-0-Entscheid.
STATUS LT. QUELLE: teilweise (Zeilenform gebaut, Blatt nicht)
ABHAENGIGKEIT/FLAECHE: A13-M3 muss gelandet sein (Fingerprint/INFO-Blatt); Vendoring ext/io/zlib + ext/io/libxlsxwriter vorab

### [w2sl5tl3q.json] 8
GEGENSTAND: Trace-Luecke 1: die Checkpoint-CSV exportiert nur 2 von 18 Achsen -- axis_stats[0] (search_algo) und axis_stats[6] (allocator), hartkodiert.
ORT: super docs/plaene/20260806-PLAN-break-even-und-drei-benchmark-ebenen.md:218; ce tier_observe_trace_abi.hpp
SOLL/FIX: serialize_abi_tier_trace_csv iteriert ueber kV3AxisCount (=18, observable_tier.hpp:50) -- "Grenze ist kV3AxisCount, NIE ein Literal" (A8-S1-Muster); aendert Kopfzeile/Blattbreite, deshalb ZWINGEND nach Stufe 0.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: xlsx-Stufe-0-Entscheid; Spaltenbenennung Owner-offen

### [w2sl5tl3q.json] 9
GEGENSTAND: Trace-Luecke 2: "Schritte INNERHALB einer Funktionsausfuehrung" existieren nicht -- fill_checkpoints{10,100,1000} sind Fuellstands-Stuetzpunkte ZWISCHEN Ops; was ein "Schritt" ist, definiert keine Quelle (V-1-Vorschlag Achsen-Interface-Aufruf-Grenze ist Haus-VORSCHLAG, keine Owner-Entscheidung).
ORT: PLAN-break-even:207,217
SOLL/FIX: Zeitnahme je Achsen-Eintritt hinter demselben Metaprogrammierungs-Schalter wie die Mess-Observer (Paket HY-B4); "Ohne Owner-Definition des Schritt-Begriffs nicht baubar."
STATUS LT. QUELLE: offen (Owner-Definition fehlt)
ABHAENGIGKEIT/FLAECHE: HY-B4; Hot-Path-Kosten

### [w2sl5tl3q.json] 10
GEGENSTAND: Native Excel-Chart-Objekte kommen in KEINER Quelle vor (kein Owner-Wort in 1.442 geprueften Nachrichten); der "Chart" existiert als TikZ/LaTeX-Diagramm der Auswerte-Stufe (super Code/05_diagram_generator). Offen ob xlsx-Ablage den LaTeX-Weg ersetzt oder ergaenzt.
ORT: PLAN-break-even:289; thesis kapitel/de/05_evaluation.tex:203-205
SOLL/FIX: Rueckfrage an Owner (Stufe-0-Punkt c).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: xlsx-Stufe 0

### [w2sl5tl3q.json] 11
GEGENSTAND: Weitere xlsx-Offene: Zeit-Nullpunkt des Profils (observe_wall_ns relativ zum Trace-Start vs. je Funktionsaufruf); Trigger-Modus (Zeitschritt-Sync vs. Zustands-Manipulation, Delta-t); Sheet-Benennung V-A9-6 (S001 vs Klartext, nie beantwortet); Zeilenlimit 1.048.576 -- Checkpoint-Anzahl je Mess-Layer nirgends beziffert, "ob das Limit reicht, ist damit unbekannt, nicht 'unkritisch'".
ORT: a9-Akte:503-506; tier_observe_trace_abi.hpp:53; Doku 24 Paragraph 8.7
SOLL/FIX: Owner-Vorlage (Stufe 0).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: xlsx-Stufe 0

### [w2sl5tl3q.json] 12
GEGENSTAND: Noise-Schwellwert: die Mechanik und Fallback-Semantik SIND geplant (BEFUND 20260709: DBSCAN-noise -> sicherer Common-Denominator-Default), aber KEIN Zahlwert, KEIN Kalibrier-Verfahren, KEINE Einheit/Bezugsraum; der BEFUND beschreibt ZWEI Mechaniken (2.4/2 modifiziertes DBSCAN online mit eps+minPts+Re-Clustering vs. 5.2 Nearest-Centroid + ein Distanz-Radius) ohne Abgrenzung. Gebaut ist 5.2, planKONFORM mit Parameter ohne Default.
ORT: super docs/audits/20260709-workload-cluster-research-BEFUND.md:118-148,239-244,289; ce libs/cache_engine/heuristik/workload_cluster_offline.hpp:21-22,35-36,454,461-479
SOLL/FIX: Rueckfrage N-1..N-4 an Owner (welche Mechanik; Bezugsraum z-normalisiert vs. roh; Kalibrier-Weg -- Uebertragung Break-Even-Kanon: kein universeller Wert, aus Messdaten kalibriert + XML-setzbarer Default; Fallback wirklich Common-Denominator-VERGLEICHSMODUS oder eigene Default-Tier-Binary). KEIN BAU VOR DER OWNER-ANTWORT. Verboten auch danach: hartkodierter Zahlwert im Header (T2/I5, T5/R2).
STATUS LT. QUELLE: offen (Owner-Setzung fehlt; Mechanik behoben/gebaut)
ABHAENGIGKEIT/FLAECHE: O-5 (Hysterese, selbst unbeantwortet, PLAN-break-even:552,756); Owner-Regel "Defaults in XML manuell setzbar" (Frage 4)

### [w2sl5tl3q.json] 13
GEGENSTAND: Nebenbefund Noise: "Common-Denominator" ist in der Thesis ein FAIRNESS-VERGLEICHSMODUS (externe Werte-Handles, keine PRT-ART-Spezialpfade), keine Betriebs-Default-Binary; die BEFUND-Referenz 06:130-133 zeigt heute auf die Ueberschrift statt auf den Satz (Substanz liegt :134-136) -- Zeilen-Drift.
ORT: thesis kapitel/de/06_evaluation_methodology.tex:130-136; BEFUND:244
SOLL/FIX: In die Rueckfrage mitliefern, "sonst entscheidet der Owner ueber einen Begriff, der in der Thesis etwas anderes bezeichnet".
STATUS LT. QUELLE: nur-hinweis (aber in Rueckfrage pflichtig)
ABHAENGIGKEIT/FLAECHE: Noise-Rueckfrage N-4

### [w2sl5tl3q.json] 14
GEGENSTAND: Zielkategorie der Modi: DIREKTER WIDERSPRUCH ungeloest -- Paragraph 47 (Owner-Direktive 20.07.), Paragraph 54-T2, XSD und Code ordnen die Modi ALS Mess-UNTER-Achse "Ablaufmethodik" ein; Owner-Aussage 07.08. ordnet sie als GETRENNTE, PARALLELE Zielkategorie ein. Begriffe "Zielkategorie"/"Zielverhalten" kommen im gesamten Korpus 0-mal vor (Nenner: zielkategorie=1 irrelevant, zielverhalten=0, ablaufmethodik=249).
ORT: LEDGER:2496-2506,2231,2955; ce run_methodology_registry.hpp:2-5,34-37; experiment_schema.xsd:289-291
SOLL/FIX: Owner-Vorlage mit 3 Fragen: (a) ersetzt "getrennte Zielkategorie" die Paragraph-47-Einordnung oder tritt daneben? (b) ist "Wartung" ein FUENFTER Wert oder ist Debug die Wartung? (c) gehoert CUSTOM_COMPILE in dieselbe Kategorie? Vorab: Doku-Nachzug additiv (Ledger-Praezisierung + Kopfkommentar :34-37), Doku nie loeschen nur deprecaten, DE fuehrt.
STATUS LT. QUELLE: offen (Owner-Entscheid)
ABHAENGIGKEIT/FLAECHE: Registry-TODO measurement_axis_registry.xml:58-59 (W2-B) haengt am Entscheid; Paragraph 47/54-T2

### [w2sl5tl3q.json] 15
GEGENSTAND: G-5 ist beantwortet: die RunMethodology-Enum-Reihenfolge {debug, measure, release, compare} bleibt (historische Aufzaehlung, stempel-/ABI-relevant, bewusst NICHT umgestellt); Parallelitaets-Eigenschaften bereits gebaut (binary_id-neutral, nie im Stempel, exactly-one je Call, XML-Pflicht, FAIL-CLOSED).
ORT: ce run_methodology_registry.hpp:19-24,70-71,170-192; LEDGER:3343,3295
SOLL/FIX: Kein Umbau; kein Stempel-/ABI-Ereignis.
STATUS LT. QUELLE: behoben/kein Handlungsbedarf
ABHAENGIGKEIT/FLAECHE: -

### [w2sl5tl3q.json] 16
GEGENSTAND: Paket D2 faellig (eigentlicher Zielverhaltens-Bau): compare ist heute nur ein bau-gleiches ETIKETT zu release; release liest die Messwerte nicht nach und erzeugt keine optimale Binary; "heute verzweigt keine Emissions-Naht auf compare".
ORT: ce run_methodology_registry.hpp:15-17,26-32,88-92,144-148 (static_assert als bewusste Tripwire); LEDGER:7628-7631 (O-A Owner verbatim)
SOLL/FIX: compare bekommt EIGENE Optionen mit LESENDEM Messwertlager-Zugriff; release liest Messwerte nach und erzeugt die OPTIMALE Binary. Falls "Wartung" fuenfter Wert: additiver Registry-Ausbau (kRunMethodologyCount 4->5, Single-Source :61-62 bricht bewusst compile-time, Namens-/Semantik-Anker, XSD-Kommentar), Biss-Nachweis rot->gruen mit literaler Fehlermeldung.
STATUS LT. QUELLE: offen (Paket D2)
ABHAENGIGKEIT/FLAECHE: Owner-Vorlage Zielkategorie; Messwertlager

### [w2sl5tl3q.json] 17
GEGENSTAND: T-NUMMERN-KOLLISION: BEFUND/Katalog fuehrt T17=queuing_q1 (T0..T18), Thesis fuehrt T17=persistence_target (T0..T17), der Auftrag nannte "T19". Welche Nummerierung kuenftig gilt ist nirgends entschieden.
ORT: ce heuristik/axis_optimization_catalog.hpp; thesis kapitel/de/03_messsystem_prtart.tex:133,182; 04_implementierung.tex:169
SOLL/FIX: "Ein Nachtrag am Katalog muss das mitentscheiden, sonst driften Code und Thesis weiter."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Katalog-Nachtrag persistence_target (Posten 18)

### [w2sl5tl3q.json] 18
GEGENSTAND: persistence_target (PT) hat KEINE Katalog-Zeile (honest-empty, consteval-Anker); Owner-Antwort Frage 4 (07.08.): drei MIN-Groessen -- persisted_footprint (Default), persistence_latency, writeback_time; Zuordnung "Frage 4 = G-2/persistence_target" ist ABGELEITET, nicht literal ("Falls die Zuordnung falsch ist, faellt die ganze PT-Zeile").
ORT: ce axis_optimization_catalog.hpp:42-53,421-426; tests/unit/test_heuristik_spline_break_even.cpp:402-413; Live-Transkript 5a19728e.jsonl:13579
SOLL/FIX: Bau-Skizze (1): CatalogAxis::PersistenceTarget=19 ANHAENGEN (nicht einschieben), drei Zeilen in Owner-Reihenfolge (leading_objective=persisted_footprint), Feld `source` mit BEFUND|OWNER|LITERATUR ergaenzen; sechs Zahlen-Anker bewusst mitziehen (kCatalogAxisCount 19->20, kAxisObjectiveCount 45->48, Minimize 28->31, Maximize bleibt 17, axes_with_maximize bleibt 15, pareto 3->4 NUR falls pareto=true entschieden). Test dreht sich um (17->18, honest-empty-Erwartung faellt, Richtungs-Zeuge rein).
STATUS LT. QUELLE: offen (Freigabe + Pareto-Entscheid noetig)
ABHAENGIGKEIT/FLAECHE: Pareto-Einstufung PT offen (RUM-Konjektur: Empfehlung pareto=true, aber Empfehlung, kein Befund); T-Nummern-Kollision (Posten 17)

### [w2sl5tl3q.json] 19
GEGENSTAND: PT-Mess-Seite fehlt: persisted_footprint hat KEINEN Zaehler (bytes_staged ist Staging-Zahl, "darf NIE als Disk-Messung berichtet werden"; device_flushes konstruktiv 0); persistence_latency und writeback_time sind heute DIESELBE gemessene Groesse (gleicher Seg-Timer um persistence_writeback_scan) -- "sonst sind zwei Katalog-Zeilen eine Spalte". PT ist im binary_id-Pfad, permutiert aber nicht (COMDARE_AXIS_PERSISTENCE_ENABLE_DISK_WRITEBACK OFF, Raum bleibt 2^17).
ORT: ce axes/persistence_target/axis_persistence_target_observable.hpp:16-19,35-43; disk_writeback.hpp:10-22,67,102-104; registry.hpp:5-8; CMakeLists.txt:425; observable.hpp:101-107
SOLL/FIX: (i) Zaehler fuer persisted_footprint einfuehren ODER ehrlich n/a solange has_device_writeback_path()==false; (ii) latency und writeback_time messtechnisch trennen. Beides erst nach Owner-Klaerung.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: PT-Katalog-Nachtrag (Posten 18)

### [w2sl5tl3q.json] 20
GEGENSTAND: Katalog-Spalte "Parameter-Art" (RC-Phantom) ist bei drei von vier Achsen ueberholt: pool_budget_bytes (T6) und inline_threshold_bytes (T11) real konsumiert, batch_size (T1) adapter-konsumiert; NUR thread_count (T8) ist heute noch Phantom ("runtime_thread_count() hat repo-weit null wirkende Aufrufer").
ORT: ce anatomy/abi_adapter.hpp:450-497; axis_optimization_catalog.hpp:231-247
SOLL/FIX: Katalog-Spalte nachziehen (implizit); telemetry (T10) und isa (T12) brauchen KEINEN Katalog-Nachtrag -- Richtungen gueltig, nur Sphaere gewechselt (System-Achsen, Kanal <system_axes> existiert); Verbleib der 5 Zielgroessen im Katalog vs. System-Achsen-Katalog offen.
STATUS LT. QUELLE: teilweise (veraltete Doku-Spalte)
ABHAENGIGKEIT/FLAECHE: -

### [w2sl5tl3q.json] 21
GEGENSTAND: Es gibt KEINEN XML-Kanal fuer Optimierungs-Ziele/-Richtungen (XSD 682 Zeilen: 0 Treffer objective|optimi|direction|minimize|maximize; Gegenprobe axes=17). Einziger setzbarer Kanal ist CLI best_binary_selector --objectives; metric_direction() liefert fuer ALLE SECHS Metriken hart Minimize (keine MAX-Spalte moeglich); Bruecke CSV-Spalte -> Katalog-Zielgroessen-Id existiert nur als Fliesstext-Kommentar.
ORT: super Code/test_data_xml/experiment_schema.xsd; ce builder/best_binary_selector/best_binary_selector.hpp:235-256; best_binary_selector_main.cpp:34-35,82-83,157-177
SOLL/FIX: Bau-Skizze (2): XML-Kanal <optimization_targets> (minOccurs=0, WHITELISTING per Owner Frage 5, Gegensatz zu axes_default_lookup MUSS in XSD-Kommentar); direction-Empfehlung (a): NICHT in XML fuehren, hart aus Katalog (keine Drift) -- Owner-Entscheid (a) vs (b) validieren-hart. Validierung in validate_profile.hpp nach target_isa-Muster (:435-445), unbekannt = HARTER Fehler. Bau-Skizze (3): ZUERST constexpr-Bruecke {csv_column, CatalogAxis, objective_id} mit Paritaets-Gate; DANN Selector nimmt Zielgroessen aus dem Profil (CLI bleibt Override), metric_direction() faellt weg.
STATUS LT. QUELLE: offen (Bau-Luecke, deckt sich mit G-3)
ABHAENGIGKEIT/FLAECHE: Owner-Regel "Defaults in XML setzbar, durchziehen, fuer Erstellungsziel durchsetzen"; "Erstellungsziel"-Instanz selbst ungeklaert (run_methodology vs. Zielkategorie)

### [w2sl5tl3q.json] 22
GEGENSTAND: Paper-Metriken: KEIN Repo-Dokument bildet Paper->Metrik ab; die 33 SOTA-Profil-Akten tragen KEIN Metrik-Feld (nur Bau-Konfiguration); Metrik-Tabelle ist NEU aus den Repo-PDFs extrahiert (5 PDFs nicht extrahierbar: P09 LOUDS, P13 Hankins, P14 Samuel, P24 Naderan-Tahan, P33 VAMPIR -- Scan-PDFs).
ORT: ce libs/cache_engine/algorithm_profiles/sota/*.profile.xml (33); super Forschungsarbeiten/
SOLL/FIX: B-2: additiver <paper_metrics>-Block je SOTA-Akte (direction aus derselben Enum wie OptimizationDirection, sonst zweites Vokabular; Scan-PDFs LEER mit source="scan_pdf_no_text"); wohin die Metriken gehoeren (Akte vs. Experiment-XML) ist NICHT entschieden.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Whitelist-Kanal (Posten 21/24)

### [w2sl5tl3q.json] 23
GEGENSTAND: Mess-Ketten-Luecken L-01..L-18 gegen die Paper-Metriken. Kernpunkte: L-01 total_cycles TRAEGT NANOSEKUNDEN, "Der NAME luegt" (measurement_snapshot.hpp:41,112); L-02 Instructions kein Counter/keine Spalte; L-03 IPC_CPI deklariert OHNE Quelle, aber experiment_golden.xml:95 fordert sie an ("eine XML fordert heute eine Groesse an, die keine Quelle hat"); L-04 pmc_branch_misses IMMER 0 (offener Posten M-3a, Zusage explizit zurueckgenommen); L-05 L2 strukturell 0; L-06 L3/LLC auf AMD Zen5 ENOENT (prod1 = AMD!); L-07 STLB fehlt; L-08 FILL_BUFFER_OCCUPANCY deklariert ohne Quelle (Kernmetrik P25); L-09 bytes/bits_per_key keine Spalte + B7 bytes_in_use_peak traegt END-Wert; L-10 Fragmentierung strukturell 0/n-a; L-11 Baumhoehe fehlt; L-12 FPR nicht bestimmbar (T14 Phase-B, keine Grundwahrheit); L-13 thread_count label-only (T8-Phantom-Guard) -- Skalierungskurven nicht erzeugbar; L-14 coherence_invalidations 0; L-15 Bandbreite fehlt; L-16 compression_ratio ohne Referenzgroesse; L-17 Space-Overhead-Prozent fehlt; L-18 RAPL-Energie faellt ohne Leserecht STILL auf 0.
ORT: ce builder/measurement_snapshot.hpp:33-77,41,49-64,112; cache_engine_builder_iterator.hpp:469-580,551-559; linux_perf_pmc_source.hpp:16,209-234,289,298,334; pmc_source.hpp:19-43; mess_interface_testate.hpp:499,558; observable_tier.hpp:69-113
SOLL/FIX: B-3 Stufen: (1) Cycles+Instructions+Branch-Misses ueber portable PERF_COUNT_HW_* oeffnen (schliesst L-01/L-02/L-04, IPC rechnerisch -> L-03; Multiplexing-Skalierung MUSS in CSV sichtbar sein; neue Spalten strikt END-Append); (2) STLB per Vendor-RAW-Tabelle mit source_available-Flag; (3) Fill-Buffer L1D_PEND_MISS.FB_FULL Intel-only; (4) L3 auf AMD per AMD-RAW-Event. B-4 abgeleitete Spalten: bytes_per_key, bits_per_key, tree_height (zwei freie V3-Slots T4, KEIN ABI-Bump), filter_fpr (Grundwahrheit aus coco_p04_neg*-Lastprofilen), compression_ratio (braucht Referenzgroesse, heute nicht da), Peak-Aufloesung B7.
STATUS LT. QUELLE: offen (alle brauchen Owner-Entscheid vorab lt. Quelle)
ABHAENGIGKEIT/FLAECHE: Owner-Wort "ALLE cacheline aware dTLB und Cache Layer PMC Werte" -- Umfang ungeklaert (3 vs 7 vs Paper-Menge); L-13 Widerspruch Doku 32 vs Test-Invariante NICHT aufgeloest, "teuerster Posten", eigener Entscheid

### [w2sl5tl3q.json] 24
GEGENSTAND: WHITELIST vs BLACKLIST: Owner sagt WHITELISTING; Doku UND Schema UND Code sagen heute das Gegenteil ("Abwesenheit = alles messen"), vier Doku-Fundstellen (D-1 LEDGER:2969 autoritative Wurzel Sec.59; D-2 PLAN-V3.2:706; D-3 XSD:321-325 axes_default_lookup; D-4 XSD:87,89,612-615) plus Code (xml_config_parser.hpp:424,455; validate_profile.hpp:578; sota_catalog.hpp:626,657). Richtig-herum existiert bereits: XSD mode="full" (:29,153-154) und das A9b-Attribut `active` ("rein deklarativ, von NIEMANDEM ausgewertet").
ORT: siehe D-1..D-4 oben
SOLL/FIX: B-1 Reihenfolge zwingend von der Wurzel abwaerts: (1) LEDGER:2969 umschreiben, alter Satz als DEPRECATED darunter; (2) Plan-Zeiger nachziehen; (3) XSD-Annotationen umdrehen, minOccurs NICHT auf 1 (braeche jede Bestands-XML) -- Vollzug im Code-Validator; (4) validate_profile lehnt fehlendes/leeres <measurement_categories> kuenftig mit ERROR ab, analog measurement_tooling + axes_default_lookup; (5) `active` deprecaten oder als Feinsteuerung umdeuten (Owner-Entscheid); (6) ADDITIV-WEG EMPFOHLEN wegen golden-CRC: comdare_experiment version="3" mit Whitelist-Semantik, version="2" Legacy (Messdaten-nie-loeschen). Test-Pflicht: Contract-Test mit literalem Error-Text.
STATUS LT. QUELLE: offen (Owner-Entscheid additiv vs. Bruch)
ABHAENGIGKEIT/FLAECHE: golden-CRC-Kardinalitaet; Bestands-golden experiment_golden.xml; Merge-Flaeche zu jedem XML-Gate-Strang

### [w2sl5tl3q.json] 25
GEGENSTAND: Zwei getrennte min/max-Traeger existieren (45er-Zielgroessen-Katalog 17 MAX/28 MIN und 16 MeasurementCategory ohne Richtungsfeld); welcher die XML-Whitelist traegt oder ob vereinigt wird, ist NICHT entschieden. Zudem: Registry-Namen (LATENCY_P99, ...) sind E4-REPORTING-Vokabular, NICHT die Bestands-Spalten; das Mapping gehoert in die E4-Folge-Stufe, die noch nicht existiert (curve_fit.hpp:7-11).
ORT: ce heuristik/axis_optimization_catalog.hpp:101; measurement_category.hpp:10-32; curve_fit.hpp:7-11
SOLL/FIX: Owner-Entscheid; E4-Folge-Stufe bauen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Whitelist-Umbau (Posten 24), XML-Zielkanal (Posten 21)

---

## Datei 2: wounn9tiw.json (Reiche Session 08.08.: 381 Roh-Befunde, 27 bestaetigt / 13 gefallen / 9 ungeprueft, 316 Learnings, 103 Nichtfunde; 50 Agenten, 3.501.442 Tokens)

HINWEIS ZUR QUELLE: Das eingebettete Dokument (44.189 Zeichen) hat eine EIGENE Uebermittlungsluecke --
Abschnitt 4 und der Anfang von 5.1 fehlen (Text springt mitten in Satz "alle oberhalb von 15159...").
Zaehl-Diskrepanzen sind im Dokument selbst ausgewiesen (Learnings 206/316 uebermittelt; gefallene
Widerrufe 4 uebermittelt vs 3 laut Kopf; Nichtfunde 29 vs 24; 6 Quell-Etiketten vs "4 Sammellaeufe").

### [wounn9tiw.json] 26
GEGENSTAND: Fehlbefund "Limits-Entkopplung ungebaut" widerlegt (seit 4 Wochen gebaut: profile_run_entry.hpp:29/:425, CMakeLists DEFER seit ce 0d9725b7 10.07.), ABER offener Rest: apps/adhoc_emitter/main.cpp:141 traegt bis heute die handgetippte PilotEngine (:224 als Default) -- der von Analyse-Paragraph-3 benannte Split-Brain; test-seitig (comdare_run_adhoc_emitter nur aus tests/unit/CMakeLists.txt:1543/1548), ausserhalb Gate-Plan Paragraph 4.
ORT: ce apps/adhoc_emitter/main.cpp:141,224
SOLL/FIX: Split-Brain-Posten bleibt offen (Punkt (c) des Agentenberichts ist wahr).
STATUS LT. QUELLE: offen (Restposten)
ABHAENGIGKEIT/FLAECHE: Gate-Plan Paragraph 4 (bewusst ausserhalb)

### [wounn9tiw.json] 27
GEGENSTAND: Neuer offener Defekt im Ersatz-Paket des allocators-Coverage-Gates: die Begruendung von ce 5adf59ea ("bisher haette das nichts bemerkt") ist am Objekt falsch -- 2 der 7 Bissproben (Akte versteckt; alle Akten weg) waeren auch auf dem alten Stand rot gewesen (test_profile_coverage.cpp lebt seit 02a79daf 04.07., prueft EXPECT_EQ(allocator_refs.size(), 23u)); wirklich neu sind rund 5 von 7.
ORT: ce tests/unit/thesis_tiere/test_profile_coverage.cpp; tests/unit/CMakeLists.txt:3236; Commit 5adf59ea
SOLL/FIX: Commit-Begruendung korrigieren bzw. als falsch dokumentieren.
STATUS LT. QUELLE: offen (Defekt in Begruendung, nicht im Gate)
ABHAENGIGKEIT/FLAECHE: -

### [wounn9tiw.json] 28
GEGENSTAND: gitleaks 1552 Treffer waren ECHT (keine Fehlalarme): 1552 = Vorkommen Praefix GR1348941, 776 Funde, 390 distinkte Runner-Registration-Tokenwerte (RuleID 776/776 gitlab-rrt, 0/1552 Fliesstext); Wiederholungsbefund: Commit 44820451 (02.08., "token-frei, Verify 0") enthielt 386 Klartext-runners_token -- Scrub real (von keinem Zweigkopf erreichbar, Ersatz 5b763179). HEAD-Redaktion haelt (1 distinkter Wert, 0 volle Token, Schnittmenge mit den 390 = 0).
ORT: docs/sessions/backups/20260806-workflow-rohdaten (ce UND super); Quarantaene bnpj776mm.output
SOLL/FIX: OFFEN LT. VII.3: "die 390 Runner-Token sind nicht rotiert" DARF NICHT als Befund weitergegeben werden -- die Rotationsfrage ist ungeklaert.
STATUS LT. QUELLE: teilweise (Scrub behoben; Rotation offen)
ABHAENGIGKEIT/FLAECHE: Owner-Frage Rotation

### [wounn9tiw.json] 29
GEGENSTAND: CI-Klasse "gruen-ohne-Lauf" nur HALB geschlossen: nach Wiederholungsfall 15317 wurden configure.sh und Makefile nur in .code-rules aufgenommen (Z.106-107); build:clang fuehrt weiterhin seine EIGENE rules-Allowlist (.gitlab-ci.yml:188-194, abschliessendes when: never) OHNE beide -- ein Commit, der nur den GNU-Bauweg anfasst, weckt die .code-rules-Jobs, aber nicht build:clang.
ORT: ce .gitlab-ci.yml:183-195 (build:clang-Allowlist); .code-rules:106-107
SOLL/FIX: build:clang-Allowlist um configure.sh + Makefile ergaenzen (implizit aus Befund).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: CI-Pipeline; docs-only-Gate absichtlich (kein Werkzeug-Defekt)

### [wounn9tiw.json] 30
GEGENSTAND: gitleaks-Vakuum "no leaks found bei 0 commits scanned": Worktree/Submodul-.git ist Zeiger-Datei aus dem :ro-Mount heraus; mindestens 7 Vorfaelle ueber 7 Tage (02.-08.08.), wiederholt NACH schriftlicher Dokumentation; Null wurde teils per 2>&1|tail-3 stillgestellt (K11). Kein unbemerkt gepushtes Falsch-Gruen belegt.
ORT: wt-super-landung/.git (105 Byte), wt-ce-fk/.git (140 Byte); 47-1ed96c98.md (Erstfall 02.08.)
SOLL/FIX: Vollfix vierteilig (steht in Ledger + ARBEITSWEISE-GESAMT-DOKTRIN.md): Hauptklon mounten UND --log-opts=<range> setzen UND "N commits scanned" als Abnahmekriterium lesen UND stdout nie durch tail beschneiden.
STATUS LT. QUELLE: behoben (Doktrin dokumentiert), Wiederholungsrisiko explizit
ABHAENGIGKEIT/FLAECHE: jede Push-Wache

### [wounn9tiw.json] 31
GEGENSTAND: A-7 bytes_in_use_peak: Kern-Fakt bestaetigt -- measurement_snapshot.hpp:124 fuellt bytes_in_use_peak aus axis_stats[6][1] = END-Wert unter Peak-Etikett (seit ce 3ef96490, 04.08. selbstdokumentiert). Voll-Lauf-Zelle traegt ehrlich n/a; der fehl-etikettierte Wert entsteht NUR im separaten 16-Spalten-f15_compare-Schema, wird von 3 Lesern geparst (tools/latex_anhang, super 04_csv_to_latex, 05_diagram_generator), von KEINEM gerendert; 02_messung_driver honest-0. Merkzeile: "Nicht null Vorkommen -- null Wirkung."
ORT: ce builder/measurement_snapshot.hpp:124; cache_engine_builder_iterator.hpp:592; test_a8s3_csv_klasse_c.cpp:148
SOLL/FIX: Peak-Etikett-Aufloesung weiter offen (deckt sich mit w2sl5tl3q B7/L-09).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: f15_compare-Schema; B7

### [wounn9tiw.json] 32
GEGENSTAND: CEB/PMU-Praezisierung (Owner-Widerlegung 06.08. 22:02): EINE CEB, EINE Tier-Binary, ZWEI Pinnings (E-Core/P-Core) als Achsen-Permutation auf zustaendiger SYSTEM-Achse; Ablage je PMC getrennt ist FOLGE. Objekt-Beleg: system_axis_registry.xml:10 target_isa binary_id="never"; :38-40 numa_node/page/core_class stage="runtime". WICHTIG: die gueltige Doktrin "eine CEB je MESSSYSTEM/Tooling-Wahl" (BAUPLAN 20260719 Paragraph 30, Punkte 2/3/6) wurde NICHT widerrufen -- ohne diesen Zusatz droht die naechste Session die richtige Regel mitzuentsorgen.
ORT: ce system_axis_registry.xml:10,38-40
SOLL/FIX: Doktrin-Abgrenzung im Gedaechtnis/Design festhalten.
STATUS LT. QUELLE: behoben (Verstaendnis), Warnung aktiv
ABHAENGIGKEIT/FLAECHE: PMC-Meta-Meta-Achse (Owner-Antworten 10.08.)

### [wounn9tiw.json] 33
GEGENSTAND: Dossier 17 deprecatet, aber Deprecation UNVOLLSTAENDIG: "19 Achsen" ueberlebt im Dossier-Rumpf UND in m3v2_study.profile.xml:35 ("DIE 19 SLOTS"), obwohl das Profil real 18 <axis ref>-Elemente traegt. Zudem Korrektur der Korrektur: Anatomy-ABI-Minor steht auf 0 (anatomy_module_abi_v1_decl.hpp:90, Reset in 4f569051); auf 1 steht der GETRENNTE kCebContractCodegenMinor (:459). Ist heute: COMDARE_ANATOMY_ABI_MAJOR 8, kOrganAxisCount=18, golden==320.
ORT: ce docs/architektur/17_E4_XML_VOLLVISION_ROADMAP.md; m3v2_study.profile.xml:35; anatomy_module_abi_v1_decl.hpp:89-90,459
SOLL/FIX: Rest-Deprecation nachziehen ("19 Achsen"-Stellen); Kausal-Aussage abgeschwaecht auf "Irrtums-QUELLE".
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: 18-Achsen-Doktrin (Memory)

### [wounn9tiw.json] 34
GEGENSTAND: pmc:intel ist seit 06.08. INTERMITTIEREND rot auf BEIDEN Refs -- 6 belegte Fehlschlaege (15104, 15110, 15135, 15136 development; 15159, 15349 main) bei vielen gruenen Laeufen; Flakiness-Beweis: 15345 vs 15349, beide main, beide sha 0ef4ef4f, gleicher Runner prod-baremetal-prod2, success 13:55:12 vs failed 13:57:26. NICHT einzuebnen: in 15135/15136 fiel pmc:amd MIT -- vermutlich ECHTE Code-Defekte auf bba4d90f/c4c04315 (dritte Klasse, offen).
ORT: GitLab Pipelines 15104-15349; ce Commits bba4d90f, c4c04315
SOLL/FIX: pmc:amd-Mitfaelle 15135/15136 pruefen (echte Defekte?); Basisraten-Messung nur mit Nenner (jobs?scope=failed hat keinen Nenner; include_retried=true noetig, Pipeline-Status verdeckt Job-Retry).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: m3v2_pmc_smoke-Fensterfix ce 2b5ecd29 (leeres Messfenster war Ursache eines frueheren rot)

### [wounn9tiw.json] 35
GEGENSTAND: PMC-DIAG-Restfrage OFFEN: `available` ist ODER-Aggregat (ready_ = l1d_ok_ || ll_ok_ || dtlb_ok_ || branch_ok_, linux_perf_pmc_source.hpp:250, Kopf :41) -- available=1 beweist EINEN offenen Zaehler, nie vier; am Objekt vorgefuehrt ([PMC-DIAG] errno=2 UND available=1 im GLEICHEN Ausgabeblock). Frage "nicht ausgeloest ODER ausgeloest und nicht eingesammelt" ist unentschieden, bis PRO ZAEHLER und mit gesicherter stderr-Erfassung im CI-Job nachgemessen ist. B-5 (ce 5e163331) schloss die zwei stummen return-0-Pfade in read_scaled().
ORT: ce builder/linux_perf_pmc_source.hpp:41,126,140-165,221,249-251
SOLL/FIX: Pro-Zaehler-Nachmessung im CI-Job mit stderr-Sicherung.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Achtung: ce 2f6f263a Commit-Botschaft nutzt exakt die gefallene ODER-Aggregat-Lesart ("alle vier Zaehler wurden GEOEFFNET") -- vor Weiterverwendung pro Zaehler klaeren

### [wounn9tiw.json] 36
GEGENSTAND: RAPL: /sys/class/powercap/intel-rapl:0/energy_uj ist 0400 root-only; als Messnutzer comdare "Permission denied" -- RAPL ist VERDRAHTET, nicht ERHOBEN (Owner-Commit aa97bff korrekt "best-effort ... bleibt ohne Zonen-Leserecht leer"). V-08-Rest bis heute OFFEN, daten-gated an Phase 6 (Register:424). branch_misses wurde geheilt durch ce aa06f900 (07.08. 15:18) -- NACH dem Alarm ("Reparatur nicht als Ausgangszustand verkaufen").
ORT: ce linux_perf_pmc_source.hpp:178-180,229-240; CMakeLists.txt:81-83 (COMDARE_ENABLE_PMC default OFF)
SOLL/FIX: RAPL-Leserecht-Frage (root-only) offen; V-08 daten-gated.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: KONFLIKT-HINWEIS: w2sl5tl3q L-04 fuehrt pmc_branch_misses als "IMMER 0, offener Posten M-3a" (Quelle Stand ba069e38) -- wounn9tiw meldet Heilung durch aa06f900 07.08.; Designer muss klaeren, welcher Stand gelandet ist

### [wounn9tiw.json] 37
GEGENSTAND: W-6 measure_out_d03: Widerruf ("Alle 8 gesichert ... der Befund war falsch") hat im Ergebnis recht (measurements.csv byte-identisch zu Commit 057ee3e5 vom 26.07.), ABER Beleg am falschen Gegenstand: der Urbefund nannte die VIER Geschwister-Logs Code/measure_out_d03-{bau,mess,pruef,validate}.log (47/50/52/5 = 154 Zeilen, NICHT leer); der Widerruf mass die 8 perm.dll.cxx.log IM Ordner. Pauschalsatz "Nichts davon hielt" damit an einer Stelle falsch. Rest-Begruendung/korrigierte Klasse abgerissen -- als Luecke gefuehrt.
ORT: super Code/measure_out_d03-*.log; Commits 057ee3e5, 2871fabf
SOLL/FIX: Luecke: Schaerfung dieses Falls liegt nicht vor.
STATUS LT. QUELLE: teilweise (Luecke dokumentiert)
ABHAENGIGKEIT/FLAECHE: -

### [wounn9tiw.json] 38
GEGENSTAND: Neun NUR commit-belegte, adversarisch UNGEPRUEFTE Befunde der ce-Reihe 08.08. (Selbstauskunft der Commit-Botschaften): 2f6f263a (PMC-Ursache read_scaled-Rueckfall; VORSICHT ODER-Aggregat), 3910b9e9 (Flags = Lese-Aussage), 39243183 (Koeder-Batterie "so soll es sein" + Unterscheidung Batterie-kaputt/Wache-weg), 52e9f3ba (CMake-Zyklus auch ce-standalone), cc028e1d (<stacktrace> 343 ns/Frame = 373x source_location, bei 38 Checkpoints ~13 us -> Hot-Path untragbar), e347d313 (architektur/ vs architecture/ EN/DE-Kollision, git mv 43 vs 1), b000ccc6 (git diff sieht untracked nicht: U+2500 in container_type_traits.hpp:35 + 8 Dateien clang-format), f09751f4 (424/428: vier Roundtrip-Tests fehlten via EXCLUDE_FROM_ALL; zwei Test-TUs transitiv an genus_binding_traits.hpp), b69e869e (Gegenmodell: Geltungsbereich explizit begrenzt).
ORT: ce Commits wie genannt
SOLL/FIX: Vor Weiterverwendung adversarisch pruefen (ausdruecklich ungeprueft).
STATUS LT. QUELLE: nur-hinweis (ungeprueft)
ABHAENGIGKEIT/FLAECHE: 2f6f263a <-> Posten 35

### [wounn9tiw.json] 39
GEGENSTAND: Vom Checkheft (VII.3) als unbelegt gekennzeichnet -- DUERFEN NICHT als Befunde weitergegeben werden: (a) "die 390 Runner-Token sind nicht rotiert"; (b) "PERF_COUNT_HW_CACHE_LL liefert auf Zen 5 errno=2" (nur strukturelle Haelfte bestaetigt); (c) Herkunft der Zahlen 845/174/18714 nicht reproduzierbar; (d) ob eine der am 08.08. gebauten Wachen je in einer echten Pipeline lief (kein CI-Zugang).
ORT: Checkheft VII.3 (im Dokument)
SOLL/FIX: Als ungeklaert fuehren.
STATUS LT. QUELLE: offen (explizit unbelegt)
ABHAENGIGKEIT/FLAECHE: (b) beruehrt w2sl5tl3q L-06 (L3 auf AMD ENOENT) -- dort als Code-Kommentar-Beleg gefuehrt, hier als nur halb bestaetigt

### [wounn9tiw.json] 40
GEGENSTAND: Offene Rest-Posten aus den Verdikten: zwei angekuendigte "unsaubere Formulierungen" im pmc-intel-rot-Widerruf (Begruendung abgerissen); W-6-Restbegruendung; der 85847715-Halbsatz ("auch auf dem vorherigen main-Stand" ruhte auf leerer API-Antwort -- weder bestaetigt noch widerlegt -- STREICHEN); pmc:amd-Mitfaelle; PMC-DIAG pro Zaehler; RAPL-Leserecht; V-08-Rest.
ORT: Dokument Abschnitt 6.4
SOLL/FIX: wie je Posten genannt; 85847715-Halbsatz streichen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [wounn9tiw.json] 41
GEGENSTAND: Groesster offener Posten (ausserhalb des Dokuments): "Es wurde noch nie eine einzige Binary gemessen." Phase 5 als autonom markiert und nicht begonnen; Phase 6 ist der USER-GO-STOPP; Endtermin 15.09.2026, Lieferung jeden Freitag.
ORT: KONTEXTUEBERGABE:254-256; GESAMT-DOSSIER:47
SOLL/FIX: Ersten Mess-Gegenstand unter Messung bringen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: F1/GOAL v8

### [wounn9tiw.json] 42
GEGENSTAND: Methoden-Learnings mit Regelcharakter (Auswahl mit Traegern): Nenner in die AUSGABE des Werkzeugs zwingen ("NENNER (nie eine nackte Null):", "N commits scanned" als Abnahmekriterium, uebersprungene Dateien namentlich, Bissbeweis als Datei); Zeitrichtungs-Probe (nachtraegliche Reparatur nie als Ausgangszustand rahmen); Widerruf traegt Beweislast wie der Befund (13 von 40 Widerrufen fielen selbst, 32,5 Prozent); auch Fehlerklassen-Etiketten sind Behauptungen; Owner-KERNe mit Regelcharakter: "Stiller Rueckfall geht fuer uns nicht", "alle Behauptungen immer ueberpruefen", "NIE abkuerzen, immer mit deep research fixen", "Endtermin 15.09.2026, JEDEN Freitag liefern", "CSV wird NIE verwendet / SKIP bei gleicher Binary".
ORT: Dokument Abschnitte 2, 5.5, 6.3, 7
SOLL/FIX: Fuer Design-Arbeitsweise uebernehmen (Dedup beim Designer).
STATUS LT. QUELLE: nur-hinweis (Learnings)
ABHAENGIGKEIT/FLAECHE: -

---

## Datei 3: wk7d8rkxb.json (Intel-Hybrid-Plan + PMC-Achsen-Zuordnung; 3 Funde + Zuordnungs-Dokument; 4 Agenten, 793.549 Tokens)

ABGLEICH-HINWEIS FUER DEN DESIGNER: Erhebungsstand dieser Quelle ist 06.08. Die Owner-Antworten
10.08. (Memory: PMC = Meta-Meta-Achse, eigene Permutation, AMD != Intel) liegen ZEITLICH DANACH --
jede Achsen-Zuordnungs-Aussage hier ist gegen den 10.08.-Stand abzugleichen, bevor sie ins Design geht.

### [wk7d8rkxb.json] 43
GEGENSTAND: Hybrid-Intel ist seit Termin 3 (09.04.2026) / Termin 4 Scope-Freeze (12.04.2026) PFLICHTPLATTFORM und Term der Forschungsfrage FF0 ("auf Hybrid-CPUs und Sapphire-Rapids-Systemen"); die Messregel "P- und E-Cores werden nicht zusammenaggregiert ... gruppierte Events ueber beide PMUs werden vermieden" ist seit 09.04. woertlich festgeschrieben; das Risiko "Hybrid-CPU-Zaehler werden falsch aggregiert" ist als Risiko-Tabellenzeile mit Gegenmassnahme ("strikte Trennung cpu_core/cpu_atom; JSON-Ausgabe aus perf") dokumentiert. Der rote pmc:intel ist die exakt vorhergesagte Risikorealisierung bei nicht umgesetzter Gegenmassnahme (Baustein HybridCorePinning entworfen, nie gebaut).
ORT: thesis docs/termine/20260409 Termin 3/*.docx (Absaetze 585-592, 974-981, 3979-3980); 20260412 Termin 4/*.docx (Absatz 955, 150-201); Domaenenmodell_PRT_ART.txt:370,441-447
SOLL/FIX: H-5 (Hybrid-PMU-Wahl cpu_core/cpu_atom hinter hybrid_core_aware) bauen; s. Posten 50-52.
STATUS LT. QUELLE: offen (entworfen, gegattert, nicht gebaut)
ABHAENGIGKEIT/FLAECHE: FF0; G-270a; Owner-Antworten 10.08. (PMC-Meta-Meta-Achse)

### [wk7d8rkxb.json] 44
GEGENSTAND: DREI STALE Doku-Stellen aus derselben Wurzel (LEDGER:865-872): (1) LEDGER:865-878 "pmc:intel ... bis ~September BLOCKIERT" ueberholt durch CPU-Tausch 13.07. (i9-14900KS -> i9-12900K; korrekt an LEDGER:3662 "prod2-HW ist GEKLAERT ... #276:14 ist pre-RMA-stale"); (2) docs/plaene/20260806-PLAN-messkette-ceb-observabletier.md:903 -- ZWEI stale Fakten in einer Zeile ("Raptor Lake" + "bis ~September blockiert"): RAW-Event-Codes fuer CACHE_MISS_L2 wuerden fuer die FALSCHE Mikroarchitektur abgeleitet; (3) docs/audits/20260716-richtungs-verdikt-ledger-vollsicht-VERDIKT.md:39 pre-Tausch.
ORT: wie genannt (super)
SOLL/FIX: Ledger-Nachzug (Owner bestaetigen lassen, "nicht selbst als erledigt buchen"); Plan-messkette:903 vor M-3b-Ableitung korrigieren.
STATUS LT. QUELLE: offen (Nachzug faellig)
ABHAENGIGKEIT/FLAECHE: M-3b (L2-RAW-Events); Ledger-Hygiene

### [wk7d8rkxb.json] 45
GEGENSTAND: Achsen-Heimat der Hybrid-Architektur ENTSCHIEDEN (zwei unabhaengige Owner-Entscheide, gleiche Heimat): FAKTUM ("hat zwei PMU-Domaenen") = dynamische stage=runtime-Unter-Achse an target_isa, geschwisterlich zu numa_node/page (Paragraph 16.3-E17 LEDGER:1576-1578 Status NACHGEHOLT + Paragraph 51-B8 LEDGER:2760); POLICY (Pinning) = scheduling-Unter-Achse (H-1); PMC-Einrichtung selbst = MESS-Achse (Owner-Nachtrag 3 N1/N4, 20260727-PLAN-hw-erkennung:234-263); NICHT die 6. Systemachse Erweiterungshardware (Definitionssatz LEDGER:2765: "ALLES ist eine Hardware-Erweiterung, das kein CPU-Core im herkoemmlichen Sinne ist und speziellen Befehlssatz benoetigt" -- P/E-Cores sind CPU-Cores). KEINE eigene Haupt-Achse (kSystemAxisOrder auf GENAU DREI zementiert).
ORT: LEDGER:1576-1578,2760,2765; ce system_axis_order.hpp:15-16,42-46,102-110
SOLL/FIX: Traeger-Achsen-INFERENZ "Hardware-Systemachse (E17-Wortlaut) = target_isa" vom Owner BESTAETIGEN lassen, bevor gebaut wird (kein Umbenennungs-Vermerk gefunden, Nenner 1111 md-Dateien).
STATUS LT. QUELLE: teilweise (Heimat entschieden, Traeger-Name Inferenz)
ABHAENGIGKEIT/FLAECHE: Owner-Frage 2 der Quelle; Owner-Antworten 10.08.

### [wk7d8rkxb.json] 46
GEGENSTAND: LATENTER WIDERSPRUCH: hetero_core_dispatch steht als CT-Sub-Dimension stage="ct" in der System-Achsen-Registry, hartverdrahtet auf None (scheduling_strategy.hpp:38-39; scheduling_system_axis.hpp:40-42,76-78; system_axis_registry.xml:29,34) -- genau was Owner-KERN "HW-Erkennung nie statisch" und E17 ("statische Compile-Time-Einrichtung ist sinnlos") verbieten. Kein Entscheid gefunden, der CT-Fixierung als POLICY-Seite (legitim CT) von der FAKTUM-Seite (muss RT sein) explizit trennt -- H-1 impliziert es nur.
ORT: ce concepts/scheduling_strategy.hpp:38-39; measurement/scheduling_system_axis.hpp; system_axis_registry.xml:29,34; tools/system_axis_registry_gen/main.cpp:464-465
SOLL/FIX: Trennung FAKTUM/POLICY explizit machen (Owner).
STATUS LT. QUELLE: offen (latenter Widerspruch)
ABHAENGIGKEIT/FLAECHE: E17; H-1

### [wk7d8rkxb.json] 47
GEGENSTAND: Gate G-270a ist ein TEST-Gate, kein Hardware-Gate mehr: HW-Signal faktisch erledigt (prod2-Runner online seit 08.07., cpu_core+cpu_atom verifiziert, LEDGER:785), aber Ledger-Kopf LEDGER:265 "P/E-Core (HW+#215)" fuehrt es weiter -- STALE. Verbleibender Riegel: Owner-Sichtung von DREI verriegelten Test-Zeilen tests/unit/test_cpuid_probe.cpp:62-64 (EXPECT_FALSE(has_hybrid_cores) etc.); Sichtungs-Grund: test:unit matcht [baremetal] beide Runner nicht-deterministisch -- ehrliche Erkennung macht den Test maschinenabhaengig (prod2 rot, prod1 gruen).
ORT: LEDGER:265,720,785,1137,1312; ce tests/unit/test_cpuid_probe.cpp:62-64
SOLL/FIX: Owner-Sichtung G-270a einholen; Ledger-Nachzug HW-Signal (bestaetigen lassen).
STATUS LT. QUELLE: offen (User-Sichtung noetig)
ABHAENGIGKEIT/FLAECHE: #215-Kopplung ungeklaert (ob reine Mess-Pfad-Korrektur golden-neutral/binary_id-frei vom 320-DLL-Neubau-GO beruehrt ist -- kein Entscheid gefunden; Registry fuehrt System-Achsen binary_id="never")

### [wk7d8rkxb.json] 48
GEGENSTAND: Etiketten-Drift: Registry-ID heisst weiterhin prod2_raptor_lake (system_axis_registry.xml:23,179; machine_identity.hpp:444), obwohl das Fabrikations-Tupel GenuineIntel/6/151/2 = Alder Lake ist (Kommentare kennen die Wahrheit, machine_identity.hpp:191,250). Umbenennung = Stempel-/Identitaets-Entscheid (Achsen-Ordnung beruehrt) -- nicht selbst zu treffen. NEBENBEFUND: odroid_gracemont als dritte Maschinen-Signatur (Gracemont IST die E-Core-Mikroarchitektur) -- NICHT geprueft, ob reine E-Core-Maschine die Hybrid-Klasse teilweise abdeckt (relevant fuer Fleet-Frage LEDGER:873).
ORT: ce system_axis_registry.xml:23,179,189; machine_identity.hpp:189-201,250,443-444
SOLL/FIX: Owner-Entscheid Umbenennung; Gracemont-Frage pruefen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Stempel-Identitaet; Mess-Fleet

### [wk7d8rkxb.json] 49
GEGENSTAND: PMC-Mechanik heute: einziger Pfad LinuxPerfPmcSource mit attr.type=PERF_TYPE_HW_CACHE (Konstante), pid=0, cpu=-1 ("jede CPU, auf der der Thread laeuft" -- auf Hybrid-PMU nicht wohldefiniert), keine Counter-Gruppe, KEINE Stelle waehlt eine PMU-Domaene; Factory diskriminiert nur OS x Build-Flag, nicht Vendor/Mikroarchitektur; KEIN Kern-Pinning produktiv (ScopedThreadPin/CorePinPolicy: 7 Treffer, ALLE in test_ap13_thread_pinning.cpp) -- Messung auf prod2 potenziell domaenen-GEMISCHT. Nenner: cpu_atom 0 von 1910 Quelldateien; PERF_TYPE_RAW 0; CPUID-Leaf 0x1A 0 Treffer (nur Leaves 0/1/7/0x8000000x gelesen).
ORT: ce builder/linux_perf_pmc_source.hpp:99-117,208-223,36; builder/pmc_source_factory.hpp:29-37; builder/measurement/thread_pinning.hpp; platform_probe/cpuid_probe.hpp
SOLL/FIX: Ableitung (8.1-8.7, ausdruecklich Ableitung, kein gefundenes Dokument): (1) Domaenen-type aus /sys/bus/event_source/devices/cpu_core|cpu_atom/type statt Konstante (Naht existiert: open(type, config) nimmt type als Parameter); (2) cpu=-1 aufloesen (je Domaene eigener fd ODER Pinning+Domaenenwahl); (3) Erkennung befuellen (0x1A/sysfs, statt AP-13 "bewusst ungesetzt"); (4) Factory-Zellen-Granularitaet auf VENDOR-ERKENNUNGS-KATEGORIE-FAMILIE x OS erweitern (Andockstelle dokumentiert, hardware_probe_factory.hpp:19-24); (5) Domaenen-Spalte in CSV additiv am Ende + n/a-Token statt 0 (Auflage A7); (6) platform-Spalte reparieren; (7) Zuordnung als MESS-Achse.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Owner-KERN "identische Binary -> identische Messdaten" (s. Posten 52)

### [wk7d8rkxb.json] 50
GEGENSTAND: WIDERLEGT: "Der micro-Tooling-Wert steuert die PMC-Einkompilation" -- PMC-Flag (-DCOMDARE_ENABLE_PMC=ON) haengt an "Job baut den Mess-Treiber", NICHT an der Mess-Tooling-Wahl [a,b,c]; "Micro = PMC" ist heute NUR ein Doc-Comment. Vertragsbruch zwischen Achse und Bau.
ORT: ce profile_facade/planner/experiment_plan_director.hpp:273-291; measurement_tooling_registry.hpp:26-31
SOLL/FIX: Bindung PMC an micro-Zelle herstellen ODER Doc-Comment korrigieren (Quelle laesst offen).
STATUS LT. QUELLE: offen (Vertragsbruch benannt)
ABHAENGIGKEIT/FLAECHE: Mess-Tooling-Achse; CEB 3 Modi

### [wk7d8rkxb.json] 51
GEGENSTAND: platform-Spalte der CSV traegt XML-Profil-Literal (z.B. "linux-x86_64"), NICHT die messende Maschine: COMDARE_PLATFORM wird vom Planer exportiert ("MUSS die MESSENDE Maschine tragen", experiment_plan_director.hpp:1418-1421) aber von NIEMANDEM gelesen (0 getenv-Treffer, Gegenprobe 12+ andere COMDARE_-getenv); platform_override wird von keinem Parser gesetzt; reale measurements.csv zeigen uniform "linux-x86_64". Zwei Maschinen mit verschiedener PMU-Semantik erzeugen heute ununterscheidbare Zeilen. Zusatz: provenance_manifest (cpu_vendor/family/model/stepping) hat 0 Produktionskonsumenten.
ORT: ce profile_run_entry.hpp:390-392; cache_engine_builder_iterator.hpp:144,346,474,730; builder/provenance_manifest.hpp:84-88; measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv
SOLL/FIX: "Die platform-Spalte reparieren ... Ohne diesen Fix bleibt jede Domaenen-Spalte wertlos, weil die Zeile die Maschine nicht kennt."
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Paragraph 61/62 Plattform-Provenienz; Domaenen-Spalte (Posten 49)

### [wk7d8rkxb.json] 52
GEGENSTAND: Zuordnungs-Dokument geschrieben: docs/plaene/20260806-PLAN-hybrid-architektur-pmc-achsen-zuordnung.md. Kern: zwei PmcSystemAxis-Sammler statt Singleton (system_axis.hpp:389), zwei CEB-Kompilate auf prod2 (Mess-Tooling-Muster "N Tooling-Konfigs -> N CEB-Pipelines"), drei neue CSV-Spalten -- alles Klasse CEB-ONLY, ~77 s, 0 Tier-Neubauten. Sechs Owner-Fragen O-A..O-F, davon ZWEI heute faellig (Fingerprint-Fenster mit 0 Sidecars noch offen): O-B = PMU-Domaene darf NICHT ins Tier-Preimage (sonst baut M-1b unbemerkt eine Flottenverdopplung ein); O-C (schwerste) = ohne Pflicht-Pinning auf prod2 ist der Owner-KERN "identische Binary -> identische Messdaten" dort STRUKTURELL verletzt (Mess-Treiber-Pfad: 0 Pinning-Aufrufer; einziger Aufrufer apps/f15_compare/main.cpp:225, opt-in). Nebenbefund: Zwei-PMC kostet +33,4 Prozent Mess-Zeilen (151,0 statt 113,2 Mio).
ORT: thesis-Repo docs/plaene/20260806-PLAN-hybrid-architektur-pmc-achsen-zuordnung.md (per Quelle)
SOLL/FIX: O-B und O-C dem Owner vorlegen (VOR Fingerprint-Fenster-Schluss); Rest O-A..O-F je Vorlage.
STATUS LT. QUELLE: offen (Owner-Fragen)
ABHAENGIGKEIT/FLAECHE: M-1b Fingerprint; Owner-Antworten 10.08. (PMC = Meta-Meta-Achse, eigene Permutation, AMD != Intel) -- ABGLEICH PFLICHT, die 10.08.-Antwort kann O-A..O-F teilweise beantwortet haben

### [wk7d8rkxb.json] 53
GEGENSTAND: UNBELEGT (Indiz, kein Dokument): dass prod2 bewusst als Intel gekauft wurde, um die Hybrid-Pflichtplattform zu liefern -- Kauf-Anlass ist dokumentiert als K8s-Production-Cluster (Masterplan-v8:6); Kausalitaet nicht belegt, nur Kohaerenz. Ebenso: 12900K-Wahl wegen "Alder-Lake-P" aus Scope-Freeze -- Begruendung im Beleg ist nur "Alder Lake, nicht betroffen" (Raptor-Lake-Degradation).
ORT: Cluster docs/sessions/20260506-...masterplan-v8...md:6; K90-Memory 2026-07-09
SOLL/FIX: Nicht als Fakt weitergeben.
STATUS LT. QUELLE: nur-hinweis (unbelegt)
ABHAENGIGKEIT/FLAECHE: -

---

## Datei 4: wzrgiwiew.json (Warnungs-/Ausgabe-Plaene bei Messfehlern; Anlassfall Pinning-Ausfall; 3 Explores + Plan-Dokument; 4 Agenten, 720.132 Tokens)

### [wzrgiwiew.json] 54
GEGENSTAND: Doktrin Paragraph 16.2-M4 ("CSV-Zelle failed statt null/0 + neben der CSV aggregierter Log", Owner 16.07., nicht superseded) ist nur TEIL umgesetzt: `failed` erreicht nur 24 von 184 Spalten (13,0 Prozent; nur op_*-Bloecke, 2 Lesestellen cell_failed :632/:787); in einer Failed-Zeile tragen die 9 PMC-Spalten und 14 Observer-Zaehler LITERALE `0` -- "Messung nie als Nullen" im PMC-Block NICHT erfuellt. Zahlen compiliert erhoben (HEADER_COLS=184, Token-Deckung je Zustand literal).
ORT: ce cache_engine_builder_iterator.hpp:576-583,612-633,787-788; axis_error.hpp:76-151; perm_runner.hpp:173-179,346-351; LEDGER:524,1549-1554,2913,3029
SOLL/FIX: `failed` zeilenweit wie `nicht_gebaut` (175/184 als Referenz); PMC-Block ohne stille Nullen.
STATUS LT. QUELLE: teilweise ("VOLL DOKUMENTIERT" LED:1554 = Doku, "TEIL, hoch" LED:2913 = Umsetzung; kein Widerspruch)
ABHAENGIGKEIT/FLAECHE: CSV-Schema (Alt-Zeilen-Lesbarkeit); golden

### [wzrgiwiew.json] 55
GEGENSTAND: Der von der Doktrin geforderte "neben der CSV aggregierte Log" existiert als DATEI NICHT: CSV-Schreiber oeffnet nur die CSV; heutige Naeherung ist stderr des Treiber-Prozesses, vom CI nach $LOGDIR/perm<N>_mess.log umgelenkt -- Prozess-Umleitung, keine der CSV zugeordnete Fehler-Aggregation.
ORT: ce profile_run_entry.hpp:555-560; experiment_run_entry.hpp:244; experiment_plan_director.hpp:1466-1472
SOLL/FIX: Companion-Log neben der CSV bauen (Doktrin-Wortlaut).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Paragraph 16.2-M4

### [wzrgiwiew.json] 56
GEGENSTAND: FEHLENDE SECHSTE SEMANTIK: "gemessen, Zahl vorhanden, Geltung unbestimmt" (Owner-KERN, Anlassfall Pinning-Ausfall) hat in der kanonischen Zell-Taxonomie KEIN Wort -- nicht failed (Messung lief), nicht n/a (Zahl liegt vor), nicht gesperrt/nicht_gebaut (D1). Einziges gebautes Vorbild: RamFrequencyProvenance/RamReadingState (Wert mit mitwandernder Vertrauens-Kennzeichnung), auf RAM-Frequenz beschraenkt. Plan-Dokument liefert ZUSTANDS-LEITER 1-9 als SOLL: mess_geltung={voll|ort_unbestimmt|hochgerechnet|kontext_ungueltig} + mess_vorbehalt; quelle_fehlt als EIGENER Wertzellen-Token (statt 0 bei pmc_available=1); nicht_erhoben eigener Token; two_phase_valid ist das gebaute Vorbild (6c).
ORT: ce axis_error.hpp (4 Zell-Token, 25 Log-Etiketten); ram_frequency_reading.hpp:53-67; thesis 03_messsystem_prtart.tex:1115-1121; Plan: super docs/plaene/20260806-PLAN-warnungen-und-ausgabe-bei-messfehlern.md
SOLL/FIX: Zustands-Leiter umsetzen; drei gefaltete Achsen trennen (A Existenz, B Abwesenheits-Grund, C Geltung eines VORHANDENEN Werts -- C fehlt als System, existiert nur als 3 ad-hoc-Faelle two_phase_valid/quality_flag/scaled_).
STATUS LT. QUELLE: offen (Plan geschrieben, nichts gebaut)
ABHAENGIGKEIT/FLAECHE: "Renderer + Spalten muessen VOR dem ersten zu behaltenden Batch landen -- danach ist 'traegt diese Zahl?' fuer Alt-Zeilen unbeantwortbar"; Klasse CEB-ONLY (kein Tier-Neubau)

### [wzrgiwiew.json] 57
GEGENSTAND: ENOENT-Verwechslung: "Zaehler existiert nicht in dieser Kodierung" (errno=2 auf L3) und "gemessen und exakt 0" erzeugen BYTE-IDENTISCHE CSV-Zellen (pmc_cache_misses_l3=0 bei pmc_available=1), weil PmcCounters EIN available-Bit fuer SIEBEN Zaehlerfelder hat; die Unterscheidung ist an einen Prosa-Anhang delegiert. Zusatz: scaled_ (Multiplexing-Hochrechnung = Schaetzung) wird an 3 Stellen geschrieben und hat NULL Lesezugriffe -- korrekt erhoben, nirgends ausgegeben. Intern 6 Zustaende, 1 erreicht die Ausgabe.
ORT: ce builder/linux_perf_pmc_source.hpp:115-123,282-346; pmc_source.hpp:19-28
SOLL/FIX: per-Metrik-Status statt Ein-Bit-Aggregat; scaled_ in die Ausgabe.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: ODER-Aggregat-Befund wounn9tiw Posten 35 (deckungsgleich); Owner-Entscheid-Vorlage LEDGER:5432-5435

### [wzrgiwiew.json] 58
GEGENSTAND: Pinning-Ist: ScopedThreadPin hat 3 getrennte Fehlerursachen und EINEN stummen return (kein errno, kein Log, keine Klasse), KEINE Rueckpruefung nach sched_setaffinity (Test test_ap13 kann es laengst: Vorab-Pruefung + re-read; nie in den Aktuator gewandert); einziger Produktions-Konsument apps/f15_compare/main.cpp:225-226 OHNE else-Zweig (Fehlschlag = stumm weitermessen); --pin-core nirgends sonst verdrahtet; beide .gitlab-ci.yml 0 Treffer taskset/numactl/pin-core. Ort der Ausfuehrung: ran_on_core_type = 0 Treffer bei Nenner 5501 -- "in 184 von 184 Spalten unbekannt und in 0 von 184 als unbekannt deklariert"; das ist der NORMALFALL aller Messungen, kein Sonderfall.
ORT: ce builder/measurement/thread_pinning.hpp:38,44-64; apps/f15_compare/main.cpp:225-226; tests/unit/test_ap13_thread_pinning.cpp:171-179
SOLL/FIX: Dreistufige Belastbarkeit (durfte ich / rc / re-read) + Warnung sobald eine fehlt; cgroup-cpuset/Hotplug/Virtualisierung-Faelle beachten (Erfolg-rc ohne Wirkung moeglich; Pin kann sich mitten im Lauf loesen); auch bei "alle drei gruen" Restvorbehalt wenn Core-TYP unbekannt.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Paragraph 16.3-E17 (ran_on_core_type woertlich entschieden, unerledigt); Posten 59 (Widerspruch)

### [wzrgiwiew.json] 59
GEGENSTAND: DEKLARIERTER WIDERSPRUCH ZU KLAEREN: Ledger:598 (05.07.) "perm_runner-Pinning vom User live verworfen (Pinning nur f15)" vs. Owner-KERN 06.08. abends (CEB startet dieselbe Tier-Binary einmal E-Core-, einmal P-Core-gepinnt) -- verlangt Pinning GENAU im perm_runner. "Die spaetere Aussage ist die geltende, aber die Umkehr ist ein deklariertes Ereignis und keine stille Korrektur."
ORT: LEDGER:598; Owner-KERN 06.08. (CEB/PMU, vgl. wounn9tiw Posten 32)
SOLL/FIX: Vor dem Bau als Umkehr-Ereignis dokumentieren/bestaetigen lassen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Pinning-Bau (Posten 58); Hybrid-Zuordnung (wk7d8rkxb)

### [wzrgiwiew.json] 60
GEGENSTAND: Platzierungs- und Reihenfolge-Vorgaben fuer den Pinning-/Geltungs-Bau: Pin VOR perm_runner.hpp:206 (pmc->begin) setzen und NACH :214 rueckpruefen (Fenster-Deckung nach dem begin/end-Muster); Traeger PermResult hat bereits 3 host-seitige Geltungs-Felder (two_phase_valid, sample_status, conformance_passed), die NICHT im 175-Feld-Wire-Format reisen -> Pinning-Status-Feld ist ABI- und golden-neutral (dreifacher Praezedenzfall); CSV-Spalte additiv am Ende (Schema elfmal so gewachsen). ABER: die EINE PMC-Quelle wird fuer den GANZEN Treiber-Lauf im Konstruktor geoeffnet -- "Wenn der Pin nach der fd-Oeffnung gesetzt wird, sind die Counter fuer einen anderen Kontext geoeffnet worden als den, in dem gemessen wird" -- eigenstaendige Reihenfolge-Frage.
ORT: ce harness/perm_runner.hpp:113-147,204-214; cache_engine_builder_iterator.hpp:421-527,2032-2038,2428-2463
SOLL/FIX: Reihenfolge-Frage im Bau loesen (fd-Oeffnung vs. Pin).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: golden-Neutralitaet; CSV-END-Append-Regel

### [wzrgiwiew.json] 61
GEGENSTAND: Messwert-Lager ist GUELTIGKEITS-BLIND: Registrierung allein anhand Datei-Existenz (filesystem::exists) -- eine result.csv mit 24x failed wird IDENTISCH registriert wie eine saubere; BestandEintrag (7 Felder) und MesswertOutcome (lager_hit/fresh_register/no_key) haben kein Gueltigkeits-Feld; Knoten-Heuristik-Log zaehlt Anzahl, nie Guete.
ORT: ce cache_engine_builder_iterator.hpp:2561-2571; builder/bestandslog/bestandslog_document.hpp:200-216; messwert_registrierung.hpp:61-65; knoten_heuristik_log.hpp:150-153
SOLL/FIX: Quelle laesst offen (Befund); Design muss entscheiden ob Lager Guete traegt.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Lager/SKIP-Doktrin (xlsx IST DIE AUSGABE / SKIP bei gueltigem Bestand -- "gueltig" ist heute nicht pruefbar)

### [wzrgiwiew.json] 62
GEGENSTAND: KEIN Warn-Traeger existiert: 0 von 184 CSV-Spalten (warn/caveat/vorbehalt); nur 2 echte Laufzeit-Warnzeilen auf stderr (profile_run_facade.cpp:909,929 bestandslog); INFO-/Legenden-Sheet der xlsx ist plan-seitig auf "Sysinfo + Haupt-Achsen" festgelegt, Warnungen dort NICHT vorgesehen; Stempel traegt keine Warnungen; provenance_manifest (16 Felder) ohne PMC-/Pinning-/Core-ID-/Gueltigkeits-Feld; thesis-Limitierungs-Tabelle le_limitierung.tex (15 Zeilen) ist im Generator HARTKODIERT (csv_to_latex.cpp:975-1135), nicht datengetrieben, und hat KEINE Zeile zu Thread-/Core-Pinning oder Hybrid. Einzige explizite Warn-Festlegung im Plan: Planer-Log/CLI-Shell (LEDGER:3310, Paragraph 62-A) + Skip+WARNUNG Fehlerklasse HardwareErweiterungFehlt (LEDGER:2492).
ORT: wie genannt
SOLL/FIX: Warnungs-Kanal designen (neue Limitierungs-Zeile ODER datengetriebener Kanal -- beides ist NICHT geplant, F-3/F-4).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: xlsx-INFO-Sheet-Vertrag (w2sl5tl3q Posten 7); System system_disturbed-Provenienz explizit als Nicht-Spalte deklariert (cache_engine_builder_iterator.hpp:472-473)

### [wzrgiwiew.json] 63
GEGENSTAND: PMC-Wachen beissen nicht (LEDGER:5252-5300): linux_perf_pmc_smoke SMOKE_SKIP mit Exit 0 ("beantwortet eine andere Frage"); m3v2_pmc_smoke wertete pmc_seam_ok = available || counters_all_zero -- "lauter Nullzaehler gelten als Erfolg"; leeres Smoke-Fenster seit ce 2b5ecd29 behoben, ENOENT-Befund bleibt. Owner-Entscheid-Vorlage (LEDGER:5432-5435) VOR Phase 6, DREI Dinge: (1) PMC-Flag in die dynamische Kette als INVARIANTE, nicht Job-Name; (2) Wache drehen: "Quelle nicht gebaut" = Fehler, nicht Skip; (3) Anhangs-Umfang angesichts I-PMC-2/3 (Anhang kann selbst im besten Fall nur L1D + dTLB zeigen).
ORT: LEDGER:5252-5300,5432-5435,5540-5541; ce tests/unit/thesis_tiere/linux_perf_pmc_smoke.cpp:44,52-63,97-104; m3v2_pmc_smoke.cpp:42-43,71
SOLL/FIX: wie Vorlage (Owner-Entscheid).
STATUS LT. QUELLE: offen (Owner-Entscheid vor Phase 6)
ABHAENGIGKEIT/FLAECHE: I-PMC-2 offen; Phase-6-GO

### [wzrgiwiew.json] 64
GEGENSTAND: DIVERGENZ-WARNUNG (Stand 06.08.): errno-Kanal 22e17f57 liegt auf ce/development (wt-landung), aber der zweite Klon Code/external/comdare-cache-engine steht auf 90bca126 OHNE den Kanal; super-Gitlink zeigt b241a272 (noch davor) -- Kanal gelandet, aber nicht im super gebumpt. Commit-Botschaft selbst: Hybrid-PMU-Verdacht "NICHT bewiesen". Kopf haelt fest "Diagnose geht nach stderr, nicht in die Messdaten" -- durch Owner-KERN TEILWEISE ueberholt (Unbestimmtheits-Aussage muss in die Ergebniszeile).
ORT: ce Commits 22e17f57, 90bca126, b241a272
SOLL/FIX: Gitlink-Bump; Geltungs-Feld statt stderr-only (Posten 56).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Submodul-Sync (4-Klone-Regel)

### [wzrgiwiew.json] 65
GEGENSTAND: Tote/CT-widrige Traeger: SystemAxisSample (EINZIGER Typ mit per-Sample SampleStatus, fail-safe Default SourceUnavailable) hat 0 Produktions-Konsumenten und 0 Weg in die CSV; IPinningPolicy/IPinningEngine + CoreClass sind reine abstrakte Interfaces mit 0 Implementierungen UND Runtime-vtable gegen die CT-Doktrin (Schwester scheduling_strategy.hpp dafuer bereits deprecated, LEDGER:516); slurm_launcher (numactl/taskset-Text) DEPRECATED, fuehrt nichts aus.
ORT: ce measurement/system_axis.hpp:136-175; platform/core_layout.hpp:14-54; subsystems/c02_pinning_engine/i_pinning_engine.hpp:18-29; builder/experiment_tree/slurm_launcher.hpp:2-9,66-67
SOLL/FIX: Beim Geltungs-Bau beruecksichtigen (Konsument herstellen oder deprecaten).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: CT-Doktrin (statischer Dispatch)

### [wzrgiwiew.json] 66
GEGENSTAND: Honest-Vokabeln (honest-0/honest-empty/honest-100%) sind VERSTREUT ueber Ledger/Thesis/Session-Docs; KEIN Dokument fuehrt sie und die Enum-Zustaende gemeinsam auf (F-5: die Zell-Zustands-Liste existiert nur als Code axis_error.hpp). n/a faltet zwei Gruende (NotApplicable + SourceUnavailable) in EIN Token -- nur im Log unterschieden.
ORT: ce axis_error.hpp:147-148; LEDGER:205 (honest-0 nur wo genuin 0; falscher Wert schlimmer als honest-0), :555 (honest-100), :6665/6504 (honest-empty Writer)
SOLL/FIX: Kanonische Definitions-Liste anlegen (implizit aus F-5).
STATUS LT. QUELLE: offen (nur-hinweis Richtung Doku)
ABHAENGIGKEIT/FLAECHE: Zustands-Leiter (Posten 56)

---

## Datei 5: we4k74oyk.json (TDD-Designplan erweiterte Testabdeckung ueber alle Wellen, 08.08. abends; 10 Teilgebiete Codex+Meta-Review; 21 Agenten, 3.031.313 Tokens)

ABGLEICH-HINWEIS: Dokument vom 08.08., fuegt sich in Wellenplan v2 (20260808) ein. Der lebende
Stand ist KON58 + Wellenplan Paragraph 18 (13.08.) -- Wellen-Zuordnungen hier sind gegen den
aktuellen Ledger-Stand abzugleichen. Der TDD-Vertrag T-1..T-9 ist im Memory als bindend verlinkt
(reference_goal_v8_und_tdd_vertrag).

### [we4k74oyk.json] 67
GEGENSTAND: TDD-Designplan: 157 Behauptungen aus zwei Kritikstufen -> 117 bestaetigt/geschaerft (386 h), 40 gefallen (rund ein Viertel; darunter 13 Fehler der ersten Schaerfungsstufe selbst); 62 Funde NUR durch die Meta-Stufe. Baender: A = 53 Posten/206 h (landet im Fenster), B = 59/166,5 h (nur bei freiem Slot, geht sonst GEZAEHLT nach W7), C = 5/13 h (W7). ENGPASS W1 (99 h Band-A in einer Woche); haelt nur unter 4 Bedingungen; reisst eine, faellt zuerst MT-L6/L7, dann XL-L1-Stufe-B -- NIE fallen: ST-CTestWache, MT-L4, Statistik-Begleittests, PK-KanonWert, LG-XlsxAlt/LG-CsvAlt (Messdaten nie loeschen), HY-Vertraege (Owner: ALLES PFLICHT). Ab F1 steht "179,5 h in 64 Posten nach W7" als Zaehler in jeder Wellen-Abnahme.
ORT: Designplan-Dokument (im JSON eingebettet); Wellenplan v2 docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md (Abschnitte 3+6 bindend)
SOLL/FIX: Posten-Register K1-K7 je Welle (W-1/W0a/W0b/W1/W2/W3/W4/W5/W7) wie im Dokument; Kapazitaets-Annahme ~118 h ist ANNAHME, keine Messung.
STATUS LT. QUELLE: offen (Plan)
ABHAENGIGKEIT/FLAECHE: Wellenplan v2; KON58/Paragraph-18-Abgleich noetig

### [we4k74oyk.json] 68
GEGENSTAND: DREIMAL WAR DER TEST SELBST DER DEFEKT (Beleg fuer T-9): (1) Abdeckungs-Wache blieb gruen gegen den korrekten 431-Baum (guard431.log); (2) test_commands.cpp:183-190 sichert Welch t=0, p=1 ueber konstanten Gruppen als SOLLVERHALTEN zu; (3) SummarizeEmptyZeroWinRate zementiert win_rate=0.0 ueber leerer Menge. Dazu Selbstbezug als Bauform: das CSV-Schema wird von 47 von 47 Stellen gegen seine EIGENE Quelle geprueft (Schema-Orakel MT-L3 muss VOR D4d und vor jeder End-Append-Spalte kommen).
ORT: ce test_commands.cpp:183-190; guard431.log; MT-L3-Posten
SOLL/FIX: K5-Posten (test-zementiert-defekt, 10 Stueck): jeder Fix schreibt den Alt-Test im SELBEN Commit um; MT-L3 Schema-Orakel VOR D4d.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: D4d (Spaltenaenderung W1); QFlag-Spalte

### [we4k74oyk.json] 69
GEGENSTAND: TDD-Vertrag T-1..T-9 (bindend ab sofort, ergaenzt V-1..V-7 des Wellenplans): T-1 ROT ZUERST (oder Biss per protokollierter Wegwerf-Mutation; Daueralarm-Tests unzulaessig); T-2 AUSSAGE NICHT ANWESENHEIT (find()/Existenz/Exit 0/"wirft nicht" sind keine Zusicherungen); T-3 NENNER FREMD (Grundgesamtheit aus anderer Quelle als dem Pruefling, ASSERT auf die Zahl VOR der Schleife); T-4 GEGENEINGANG; T-5 ORAKEL UNABHAENGIG (nie aus der geprueften Funktion, nie aus Kritik-Material -- "die 184 Spalten sind unverifiziert"); T-6 SCHWESTERPFLICHT (beide Writer/Genera/Backends/Engines/Serialisierer); T-7 REGISTRIERUNG IST TEIL DES TESTS (ctest -N + Bauweg + Registrierungs-Bissprobe; Belegstand: 4 unregistrierte Dateien, 27 unsichtbare Faelle, F15-if-Block); T-8 ATOMARE LANDUNG (Tag-1-Rot im Feature-Branch, development atomar Test+Minimalbau); T-9 TESTKRITIK (neue Tests jeder Welle in der Folgewelle durch Codex-Pass + Objektpruefung).
ORT: Designplan Paragraph 3
SOLL/FIX: verbatim uebernehmen.
STATUS LT. QUELLE: bindend (Vertrag)
ABHAENGIGKEIT/FLAECHE: Memory reference_goal_v8_und_tdd_vertrag

### [we4k74oyk.json] 70
GEGENSTAND: Sequentielle Ketten-Zwaenge (16 Glieder, Auswahl): ST-CTestWache ZUERST (enable_testing()-Wurzelfix + Nach-Build-Wache Soll-Quelltext-Scan gegen ctest -N; ohne sie sind neue Tests unsichtbar); MT-L4/AS-Bewaffnung/HY-Label vor W1; rote Statistik-Suite lokal vor D4-Landung; HY-Gleichstand VOR jedem Router-Code; MT-L3 vor D4d; HY-Reroute-Vertrag -> HY-ModulGrenze (atomar mit HY-A2) -> HY-Ebene4a (nach 4.-Ebenen-Entscheid); LG-HostBinder -> LG-SkipCallback -> LG-E2Exlsx; PM-m3v2Spalten vor PM-Naht; ST-HeurIdentisch vor ST-BreakEvenKreuz; AS-DupReject vor AS-OrganOrdnung; AG-Concepts11 -> AG-IsComposition -> AG-Noexcept. Einfuege-Regeln: Begleit-Test landet mit der Bauwelle seines Gegenstands; W3-MESS blechexklusiv (0 h neue Testarbeit, Gates sind die Instrumente); HY-Vertraege ruecken von W4 nach W1 VOR den Bau (reiner TDD-Fall: null Zeilen Bestand, Test = Spezifikation).
ORT: Designplan Paragraphen 4+5
SOLL/FIX: Reihenfolge hart einhalten.
STATUS LT. QUELLE: offen (Plan)
ABHAENGIGKEIT/FLAECHE: PM-NichtGelesen-HW nach W7 "prod2 per OV-5(b) gestrichen" -- ACHTUNG Memory: OV-Nummern sind KEIN Autoritaetsbeleg, Gegenstand im Roh-Transkript pruefen

### [we4k74oyk.json] 71
GEGENSTAND: OFFENE ZAEHL-DIVERGENZ am Objekt: Material erwartet Testzahl 429->456, Wellenplan Paragraph 1 zaehlt 428 lokal + 27 = 455. W-1 erhebt neu und benennt BEIDE Nenner.
ORT: Designplan W-1-Abschnitt
SOLL/FIX: Neu erheben, nicht glattrechnen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: ST-CTestWache

### [we4k74oyk.json] 72
GEGENSTAND: OFFENER KONFLIKT (dem Owner vorzulegen, nicht glattzurechnen): Reserve-WE 22./23.08. ist im Wellenplan nur fuer HY-A benannt; der TDD-Plan braucht es fuer HY-A SAMT seiner Testvertraege.
ORT: Designplan Paragraph 8 Bedingung (2)
SOLL/FIX: Owner-Vorlage.
STATUS LT. QUELLE: offen (Owner-Frage)
ABHAENGIGKEIT/FLAECHE: W1-Engpass; HY-A

### [we4k74oyk.json] 73
GEGENSTAND: Codex-als-Kritiker-Einsatzregeln (belegte Schwaechen: arbeitete auf Vorfahr-SHA 85847715 gegen HEAD 7bcf353b -- gesamter Drift-Abschnitt durch D4-Heilung ueberholt; Zeilenanker auf Nachbargegenstaende, 3 belegte Faelle in einer Datei; Ganzheits-Behauptungen an Teilmengen; Koeder die nicht beissen): (1) nur auf frisch gepinntem SHA, beide Repos, tests/ gesamt; (2) Output ist Kartierung, nie Zitat -- jede tragende Referenz selbst lesen, keine Codex-Zahl ungeprueft in einen Test (K13); (3) Pflicht-Meta-Stufe; (4) je Welle ein Codex-Pass ueber die NEU gebauten Tests der Vorwelle; (5) NICHT einsetzen fuer Aufwandsschaetzung/Wellen-Zuordnung/Owner-Entscheide.
ORT: Designplan Paragraph 6
SOLL/FIX: Regeln uebernehmen.
STATUS LT. QUELLE: bindend (Regel)
ABHAENGIGKEIT/FLAECHE: Memory codex-lens-klein-schneiden (13.08., zwei Ausfaelle) ergaenzt dies

### [we4k74oyk.json] 74
GEGENSTAND: Ausdruecklich NICHT getestet (mit Kosten): Band C/W7 (MT-L8 Legacy-Pfad, PM-PAPI toter Zweitpfad Owner-Entscheid aussteht, PM-WinPCM kein Windows-Runner, PM-AmdL3 Teile 1-2 CAP_PERFMON-Lane, AG-PunktFixes); Band B 59 Posten/166,5 h als GEZAEHLTE Warteliste; bewusst nie: Holm/Bonferroni bei malformten p-Werten, v32_orchestrator-Stub, alpha=1, HDR-Histogramm (D5-5 entscheidet). SOFORT-Posten darin: PM-AmdL3 Teil 0 = Kommentar-Richtigstellung 0,2 h ("dokumentierter Widerspruch ist Defekt").
ORT: Designplan Paragraph 7
SOLL/FIX: PM-AmdL3 Teil 0 sofort; Rest als Warteliste fuehren.
STATUS LT. QUELLE: teilweise (bewusste Auslassungen dokumentiert)
ABHAENGIGKEIT/FLAECHE: W7-Behaelter

---

## Datei 6: w7uqir5wv.json (pmc:intel-Diagnose, 3 Linsen + Owner-Anweisung; 4 Agenten, 360.799 Tokens)

ZEITFOLGE-HINWEIS: Diese Diagnose (06.08.) ist die URSACHEN-Analyse; der Fensterfix ist laut
wounn9tiw (Posten 34) als ce 2b5ecd29 gelandet (danach intel l1=6.814.572, Pipeline 15115 gruen
19/19). Die Diagnose-Ausgabe-/Sichtbarkeits-Posten hier koennen dennoch offen sein -- am Objekt pruefen.

### [w7uqir5wv.json] 75
GEGENSTAND: AUFTRAGS-PRAEMISSE WIDERLEGT: die intel-Lane HAT volle PMC-Rechte (im SELBEN roten Job liefert Test 329 linux_perf_pmc_smoke auf prod2 delta.cache_misses_l1=6.701.028, l3=4.048.837, dtlb=3.314.004, SMOKE_OK; perf_event_paranoid=1 auf BEIDEN Hosts, shell-Executor baremetal, kein Container, CI-Jobs unterscheiden sich NUR in tags:). Rot ist ausschliesslich m3v2_pmc_smoke (Test 304): er misst ein LEERES Fenster (zwischen begin() und end() steht nichts) -> t_running==0 -> alle read_scaled ok=false -> delta.available=0. Determinismus: 7/7 AMD-Laeufe nonzero (34-53 L1-Misses = reiner Syscall-Overhead -- "die AMD-Lane besteht diesen Test durch Zufall"), 6/6 Intel exakt Null. Eine Cluster-/Rechte-Aenderung waere ein Fehlversuch ohne Ziel.
ORT: ce tests/unit/thesis_tiere/m3v2_pmc_smoke.cpp:41-43; linux_perf_pmc_source.hpp:131-149,219,305; Traces Jobs 365119-365257
SOLL/FIX: Kein Cluster-Eingriff; Fix im Repo (Fenster fuellen oder fail-closed-Verdikt vom Naht-Test nehmen -- "der fail-closed-Gedanke ist richtig, nur an den falschen der beiden Smokes geheftet").
STATUS LT. QUELLE: offen (zum Erhebungszeitpunkt; Fensterfix spaeter als 2b5ecd29 gelandet)
ABHAENGIGKEIT/FLAECHE: wzrgiwiew Posten 63 (Superseded-Vermerk: leeres Fenster behoben, ENOENT-Befund bleibt)

### [w7uqir5wv.json] 76
GEGENSTAND: Die intel-Lane hat m3v2_pmc_smoke NIE bestanden -- sie hat ihn STILLGESCHALTET: Alt-Logik pmc_seam_ok = available || counters_all_zero ergab 0||1=1 -> SMOKE_OK (Jobs 365120/365149/365227 vor 8894d983 zeigen bereits pmc_available=0 counters_all_zero=1). Die fail-closed-Umstellung 8894d983 deckt genau das auf -- insoweit korrekt und funktionierend. Pass/Fail korreliert 1:1 mit der Code-Version (Feld pmc_expected_by_build), nicht flaky.
ORT: ce m3v2_pmc_smoke.cpp:87 (neu 8894d983); Jobs-Tabelle 5 intel/4 amd
SOLL/FIX: -
STATUS LT. QUELLE: behoben (Aufdeckung), Folge-Fix noetig (Posten 75)
ABHAENGIGKEIT/FLAECHE: -

### [w7uqir5wv.json] 77
GEGENSTAND: Diagnose-Luecken der PMC-Quelle: (a) die Fehlermeldung des Tests nennt NUR Rechte-Ursachen (perf_event_paranoid, CAP_PERFMON, Container) als HARTKODIERTE VERMUTUNG und verschweigt den dritten Fall (t_running==0 bei offenem fd) -- hat die Lagebeschreibung in Richtung "kein Zugriff" gelenkt; (b) perf_event_open-Rueckgabewerte/errno je Counter werden verworfen, nie geloggt (Z.111-114, Stand fb9aefdc); (c) t_enabled/t_running werden nicht ausgegeben.
ORT: ce m3v2_pmc_smoke.cpp (Fehlermeldungs-Text); linux_perf_pmc_source.hpp:111-114
SOLL/FIX: t_enabled/t_running in die Diagnose-Ausgabe; errno je Counter loggen; Fehlermeldungs-Text um den dritten Fall ergaenzen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: errno-Kanal 22e17f57 (spaeterer Teil-Fix, wzrgiwiew Posten 64); PMC-DIAG-Restfrage (wounn9tiw Posten 35)

### [w7uqir5wv.json] 78
GEGENSTAND: Hybrid-PMU-Hypothese fuer t_running==0 auf Alder Lake ist UNBELEGT (zwei Mechanismen nicht unterscheidbar: Zeitgranularitaet vs. Hybrid-PMU-Bindung); trennende Probe definiert: /tmp/pmc_probe.c auf prod2 fahren -- t_enabled>0 && t_running==0 => Hybrid-Mechanismus bewiesen; plus ls /sys/bus/event_source/devices/ (zeigt cpu_core/cpu_atom). Beides ce-Repo-/Host-Arbeit, kein Runner-Eingriff. Ebenfalls unbelegt: ob pmc_available=0 auf intel auch im ECHTEN Mess-Pfad (reale Last) auftritt -- kein intel-Beleg fuer den Voll-Mess-Lauf.
ORT: /tmp/pmc_probe.c (Reproduzierer); prod2 (nicht erreichbar, kein ssh)
SOLL/FIX: Probe auf prod2 fahren (Schritt 0 der Anweisung) BEVOR irgendein Rechte-Eingriff.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Hybrid-Zuordnung (wk7d8rkxb)

### [w7uqir5wv.json] 79
GEGENSTAND: Owner-Anweisung geschrieben: docs/plaene/20260806-ANWEISUNG-pmc-intel-perf-rechte.md (622 Zeilen; super-Hauptklon). Kern: "Nichts an den Rechten aendern, bevor Schritt 0 gelaufen ist" (Sonde ohne root). SELBST GEMESSENE Zusatzbefunde (prod1, vorher in keiner Diagnose): (1) bei paranoid=1 liefern CPU-weite Events und die power-PMU errno=13 -- "die kursierende Tabelle 'paranoid=1 erlaubt CPU-weite Events' ist damit widerlegt"; (2) PERF_COUNT_HW_CACHE_LL laesst sich auf Zen5 GAR NICHT oeffnen (errno=2, selbst gemessen) -- erklaert cache_misses_l3=0 auf amd; Spalte pmc_cache_misses_l3 ist damit VENDOR-ASYMMETRISCH (amd strukturell 0, intel echt gemessen) -> gehoert in dieselbe honest-0-Klasse wie cache_misses_l2 im Anhang; (3) /sys/class/powercap/intel-rapl:0/energy_uj ist 0400 root:root -- CAP_PERFMON hilft dort NICHT (DAC).
ORT: super docs/plaene/20260806-ANWEISUNG-pmc-intel-perf-rechte.md
SOLL/FIX: Anweisung befolgen; l3-Asymmetrie im Anhang als honest-0 fuehren.
STATUS LT. QUELLE: offen (Anweisung liegt vor)
ABHAENGIGKEIT/FLAECHE: wounn9tiw Posten 39(b) fuehrte "LL auf Zen5 errno=2" als nur halb bestaetigt -- HIER liegt die Selbst-Messung vor (prod1-Probe literal); Designer kann als bestaetigt einstufen fuer prod1, prod2-Seite weiter offen

### [w7uqir5wv.json] 80
GEGENSTAND: FALLE: der lokale read-only-Checkout /home/comdare/Projekte/Cluster/_infra/ci-templates/base-pipeline.yml ist VERALTET (846 Zeilen lokal vs. 1142 authoritativ auf ref=development; u.a. gcc-15-Praeferenz-Block fehlt lokal). Authoritative Fassung nur per API.
ORT: /home/comdare/Projekte/Cluster/_infra/ci-templates/base-pipeline.yml
SOLL/FIX: Nie auf dem lokalen Checkout greppen; per API holen.
STATUS LT. QUELLE: nur-hinweis (Werkzeug-Falle)
ABHAENGIGKEIT/FLAECHE: Fallen-Register

---

## Datei 7: wo2zqnqhb.json (F3/Weg a, F5-Golden, R4, Aufraeumpass 9+4 Kandidaten, B12/B-Rest; Stand 06.08. abends; 2 Agenten, 416.714 Tokens)

### [wo2zqnqhb.json] 81
GEGENSTAND: F3/Weg a (Fixture-Rename) ist FAELLIG aber ungebaut: Vorbedingung erfuellt (B14 super 1ba29b63 + ce 16a173f2 sind Vorfahren; fixture_schema_subset_check.cmake + golden_n_consistency_check.cmake liegen in development), Rename NICHT vollzogen (ce-Fixture heisst weiter experiment_golden_kern.xml, Code/tests/CMakeLists.txt:170-175 haengt am Alt-Namen). STUMM-WACHEN-RISIKO R1 UNGEMINDERT SCHARF: fixture_schema_subset_check.cmake:98-103 skippt bei fehlender FIXTURE still (message STATUS + return), waehrend SCHEMA/MASTER per B14-NB4 auf FATAL gezogen wurden; die Unterscheidung "Ordner da, Datei weg = FATAL" fehlt.
ORT: super Code/tests/fixture_schema_subset_check.cmake:98-103; ce tests/unit/thesis_tiere/experiment_golden_kern.xml
SOLL/FIX: R1-Haertung MUSS in denselben Commit wie der Rename (Plan Paragraph 2.2 Schritt 2); Owner-GO liegt vor (Ledger Z.5220 "F3: Bitte sauber die fixture nachziehen"); terminiert NACH der Abgabe (~2,5 h + R1). Die Plan-Zahl "12 Naht-Tests" ist UNBELEGT -- im ersten Bauschritt nachzaehlen. F3-Schritt 3 (CI-Heimat) durch R4-Wurzelschnitt gegenstandslos.
STATUS LT. QUELLE: offen (faellig, nach Abgabe)
ABHAENGIGKEIT/FLAECHE: B14; R4

### [wo2zqnqhb.json] 82
GEGENSTAND: SOFORT-POSTEN R4 ERLEDIGT, strenger als verlangt: ce dcb2f08f entfernt den -LE contract|pmc-Ausschluss an der Wurzel (9 Tests liefen in KEINEM Job, u.a. test_experiment_kern_seam); neue Auswahl aus scripts/ci_test_coverage_manifest.sh (nur noch -LE pmc, ueber pmc:amd/intel gedeckt); ci_test_coverage_guard.sh haelt Vereinigung live gegen ctest -N. EINSCHRAENKUNG: die Bilanz "407/407" ist BERICHTET, nicht selbst nachgefahren.
ORT: ce .gitlab-ci.yml:576-593; scripts/ci_test_coverage_manifest.sh:127-128; ci_test_coverage_guard.sh
SOLL/FIX: keine offene Arbeit.
STATUS LT. QUELLE: behoben@dcb2f08f (407/407 mit Restzweifel)
ABHAENGIGKEIT/FLAECHE: -

### [wo2zqnqhb.json] 83
GEGENSTAND: F5-Golden: additiver Kern S0-S5 (G1-G7) BEREITS GELANDET -- nicht als eigene Welle, sondern mitgefahren in B14-NB2 (Beleg: Zeitstempel-Kommentare in experiment_golden_kern.xml; run_options cap="131072", organ_subaxes deklariert aber bewusst ungelesen, EINE combo, Interpreter liest run_options). OFFEN: G8 (ce-Naht-Fixture traegt keine run_options/organ_subaxes-Erwartungen, ~30 min, unkritisch) und S6/A8 = OWNER-ENTSCHEID E-4, TABU-BERUEHREND: scharfgeschalteter organ_subaxes/line_size-Konsum haengt ein 19. Segment (cacheline.line_size=<n>) an die binary_id und BRICHT den Zeilen-Join alt-gegen-neu ueber das Mess-Archiv ("Zwei Tage vor der Abgabe die Join-Faehigkeit ... zu brechen ist kein vertretbares Risiko") -- ausdruecklich NACH dem Abgabe-Schnitt. 5 der 6 TABU-Posten sind GAR NICHT zu oeffnen.
ORT: super Code/test_data_xml/experiment_golden_kern.xml:217-416; ce axis_path_serialization.hpp:40; xml_config_parser.cpp:425-432; docs/plaene/20260806-PLAN-golden-update-fenster.md
SOLL/FIX: G8 klein bauen; S6 nur unter E-4.
STATUS LT. QUELLE: teilweise (S0-S5 behoben, G8+S6 offen)
ABHAENGIGKEIT/FLAECHE: binary_id-Grammatik (TABU-6); Mess-Archiv-Join

### [wo2zqnqhb.json] 84
GEGENSTAND: B12 xlsx-Default-Writer: VOLLSTAENDIG UNGEBAUT (nur SOLL-Design-Akte, grep xlsx ueber ce/libs = 10 Treffer in 3 Dateien, KEIN Writer). GETEILTE TERMINIERUNG ist die Aussage: das GERUEST ist VOR-MESSBEGINN-PFLICHT (Owner verbatim Ledger Z.5688: "CSV laesst sich schlechter auswerten, das muss auch noch mit in die Abgabe vor der Messung ... mach es nach deiner Empfehlung"; Wellenplan-Band P2), nur die FUELLUNG ist P4 -- "Wer B12 pauschal nach P4 schiebt, verletzt eine Owner-Terminierung." Form entschieden: GoF-Strategy, CSV XOR xlsx, xlsx=Default. ~1 Tag Geruest.
ORT: ce docs/architecture/20260803-a9_xlsx_writer_f3_soll_design.md (einzige Fundstelle)
SOLL/FIX: Geruest vor Messbeginn bauen.
STATUS LT. QUELLE: offen (GO liegt vor)
ABHAENGIGKEIT/FLAECHE: Phase 6/Messbeginn; a9-Vertraege (w2sl5tl3q Posten 7)

### [wo2zqnqhb.json] 85
GEGENSTAND: Aufraeum-Kandidatenliste konsolidiert AP-01..AP-13 (Statusstand 06.08.): AP-01 3D-caption ERLEDIGT/STREICHEN (diagram_generator.cpp:1305-1307; "der juengste Wellenplan 19:07 fuehrt ihn noch als offen -- widerlegt"); AP-02 1xN/Nx1-Matrix-Fatal OFFEN (kein Guard, Heimat P4, Bestandsfehler kein toter Code); AP-03 UMWIDMEN (Commit-Botschaft unveraenderlich; erreichbares Objekt axis_03a_search_algo_original_surf.hpp:182); AP-04 cacheline-Default OFFEN, Etikett "0 Aufrufer" FALSCH (node_width_config.hpp:54 hat 1 Konsumenten: static_assert test_ff2:84; nicht vor E-4); AP-05 stale-17er-Kommentare: UMFANG UNTERSCHAETZT -- 77 Fundstellen statt "17 Stellen", GROSSER Teil NICHT stale (source_catalog.hpp:135/:170 korrekt); neu belegt stale: lazy_adhoc_source_gen.hpp:80/:135 ("17-Slot"/"17 Flyweight-Tabellen" gegen 18); AP-06 teilweise (offen exakt: anatomy_version_stamp.hpp:4-5 "aus den 17" widerspricht :39 kOrganAxisCount=18 DERSELBEN Datei); AP-07 M1-M3: Befundtexte stehen in KEINEM Dokument -- BERGUNG vor dem Pass, nicht streichen; AP-08 honest-0 UMWIDMEN (stehende Auflage, kein abschliessbarer Kandidat); AP-09 axis_inventory.tex OFFEN beidseitig belegt (Schreiber appendix_generator.cpp:423; 0 Einbindungs-Treffer; Gate 8 band nur die 23 Graph-Abbildungen ein); AP-10 using SearchAlgo: Anker stale, Zahl zu klein (referenzlos :595/:710/:819; :2406 stark benutzt, KEIN Kandidat).
ORT: docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md:379-394,442,445; Objektbefunde wie genannt
SOLL/FIX: TERMIN-DOKTRIN: vom Aufraeumpass gehoert NICHTS vor die Abgabe; nach Abgabe als EIN Paket, ultracode VOR+NACH; erster Schritt AP-13 (Listen-Zusammenfuehrung), danach AP-07-Bergung; nebenbei fallende Kandidaten duerfen mitlaufen, aber KEIN eigenes Fenster.
STATUS LT. QUELLE: offen (Liste mit Einzelstatus)
ABHAENGIGKEIT/FLAECHE: E-4 (AP-04); F7-(b) (AP-11)

### [wo2zqnqhb.json] 86
GEGENSTAND: AP-12 -- WIDERRUF EINER FALSCHEN ENTLASTUNG: measure:smoke / measure:golden-320 wurden als "0 Treffer, bereits weg" gemeldet (nur in ce gesucht); BEIDE leben im super (.gitlab-ci.yml:651 und :738, selbst-etikettiert "DEPRECATED-Fallback ... NICHT geloescht (Pilot-Historie)") und tragen das EINZIGE -DCOMDARE_ENABLE_PMC=ON des Mess-Pfads (:677, :768) -- der Planer emittiert nur den PMC-Preflight, KEIN Configure-Flag. HARTE SPERRE: erst PMC-Invariante + Wachen-Drehung, dann Entfernung. Nebenbefund: measure:golden-320 traegt die COMDARE_STATIC_SMOKE_FALLBACK-Bedingung NICHT (:760 nur COMDARE_RUN_MEASURE=="true") -- Kommentar falsch ODER Rule unvollstaendig.
ORT: super .gitlab-ci.yml:651,677,738,760,768; ce experiment_plan_director.hpp:1352-1364
SOLL/FIX: Sperr-Reihenfolge einhalten; Kommentar/Rule-Inkonsistenz klaeren.
STATUS LT. QUELLE: offen (harte Sperre)
ABHAENGIGKEIT/FLAECHE: PMC-Invariante (wzrgiwiew Posten 63); dynamische Kette

### [wo2zqnqhb.json] 87
GEGENSTAND: AP-13, "schwerster Befund": die konsolidierte 10er-Liste enthaelt KEINEN der Alt-Sec-75-Kandidaten -- "eine Konsolidierung, die eine Quellenklasse auslaesst, liest deren Schweigen als Abwesenheit" (gleiche Fehlerklasse wie der LB-Paketschnitt). Gegengeprueft: GA-09 SIEBEN Waisen-TUs ALLE offen (br4_emit.cpp, br4_load.cpp, kf16_e2e_real_build.cpp, test_a9b_active_deklaration_inert.cpp, test_c3b_kanal_merge_beleg.cpp, test_d4b_container_dll.cpp, test_rf2_admission_marker_inert.cpp: Datei existiert, 0 Treffer in tests/unit/CMakeLists.txt); (22) Bestands-ASCII = 962 Dateien (die gelandete Wache gilt NUR fuer neue Zeilen); (30) test_s5_artifact_cache_bounded:42 festes user_tmp_dir()/"comdare_s5_bounded" + remove_all; (20)/(23)/(31)/(54) ungeprueft = UNBELEGT.
ORT: Alt-Sec-75; ce tests/unit/
SOLL/FIX: Listen-Zusammenfuehrung als ERSTER Schritt des Aufraeumpasses.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Aufraeumpass; T-7 (Waisen-TUs = Registrierungs-Klasse)

### [wo2zqnqhb.json] 88
GEGENSTAND: B-Rest (B2/B3/B4/B8/B9/B11) vollstaendig unveraendert OFFEN, geplant P4 (nach Trigger): B2 E-04-Vollausbau/A7-Rest + Mess-Marker-v2 + Klaerung zweier ungelandeter rescue-Patches; B3 OS-U4/A14-Rest + Z-04-Tests (OS-U3 hat 0 produktive Konsumenten); B4 A4-12-Perm-Paket + FS1-Testschuld (iterator.hpp:1812, spaetestens vor Messung); B8 D-10/L11-Referenz-Eichung + J-Hygiene L2 + Zitat-Drift; B9 P11-Pre-Flight-Checkliste (pgrep-Exklusivitaet, COMDARE_BESTANDSLOG) + Board-Phasen 3-5; B11 Posten 19 stale build/-Bereinigung (MESS-CSV-FALLE: Messdaten nie loeschen).
ORT: Ledger Z.5590/5775; Register Z.72
SOLL/FIX: P4; keine offenen Owner-Entscheide (B6/B7 separat).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: FS1 vor Messung; B11 CSV-Falle

### [wo2zqnqhb.json] 89
GEGENSTAND: Nebenbefunde/Verfahrens-Fakten: (a) rescue-Refs fdfa68ee (A1) und 5c4cf900 (E18-SNAP-NB2) sind KEINE Vorfahren von ce/development -- "rescue-Ref ist keine Landung" (Klaerungs-Posten in B2); (b) der Ledger wurde WAEHREND der Erhebung von einer Parallel-Linie geschrieben (Anker verschoben sich um 10 Zeilen) -- Dokumente zitieren daher Inhalts-Anker statt Ledger-Zeilennummern; (c) das Plan-Dokument docs/plaene/20260806-PLAN-f3-f5-r4-aufraeumpass.md (890 Z., ASCII-rein) war zum Erhebungszeitpunkt UNTRACKED/NICHT committet -- Verlustrisiko.
ORT: wie genannt
SOLL/FIX: (a) Bergung/Entscheid in B2; (c) committen pruefen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: B2

---

## Datei 8: wbl8tsmpf.json (CI-Rueckschrieb Thesis-Gitlink-Paritaet, Bau+Verify; 2 Agenten, 185.317 Tokens)

### [wbl8tsmpf.json] 90
GEGENSTAND: Befund bestaetigt und geschlossen: die CI erzeugte die Thesis-Submodul-Divergenz SELBST neu -- anhang:forward bumpte nur thesis/diplomarbeit (git update-index nur 1 Pfad), der zweite Gitlink Code/external/20260931-overleaf-diplomarbeit (selbes Repo, 0 CI-Referenzen) hing zurueck; ZUSATZBEFUND: der Fruehausstieg :1155-1158 prueft nur den ersten Zeiger -- exakt der Rueckschrieb-Folgezustand nahm exit 0 und heilte den zweiten Zeiger NIE (Selbstverriegelung). Bau: Commit 18a0bdf3 auf Branch b-ci-rueckschrieb-beide-zeiger (NICHT gepusht, development NICHT angefasst): neues ci/thesis_gitlink_parity.sh (145 Z., ls-tree/ls-files+awk, kein grep, Exit 0/1/2) + anhang:forward bumpt BEIDE via THESIS_GITLINKS + verify:submodules ruft den Pruefkoerper mit test -x-Gate. Voller Biss-Nachweis gefahren (rot bei Divergenz beider Quellen, fail-closed bei fehlendem Gitlink, Alt-Fassung auf Schiefstand reproduziert GRUEN=Beweis der Falle).
ORT: super .gitlab-ci.yml (anhang:forward, verify:submodules); ci/thesis_gitlink_parity.sh; .gitmodules:45-56; Branch b-ci-rueckschrieb-beide-zeiger @ 18a0bdf3
SOLL/FIX: Landung des Branches steht aus (nicht gepusht).
STATUS LT. QUELLE: behoben@18a0bdf3 (ungelandet)
ABHAENGIGKEIT/FLAECHE: Merge-Flaeche super .gitlab-ci.yml (nur 2 von 30 Jobs geaendert, strukturell verifiziert); Ledger-Eintrag NICHT geschrieben (anderer Agent hielt LEDGER.md offen)

### [wbl8tsmpf.json] 91
GEGENSTAND: Die ALTE Wache REV-CI-04 (git submodule status --recursive) ist strukturell BLIND fuer die Gitlink-Divergenz: sie prueft Worktree GEGEN Gitlink, nicht Gitlink GEGEN Gitlink -- auf einem divergenten, aber je-Zeiger-korrekt ausgecheckten Baum GRUEN (literal vorgefuehrt: "REV-CI-04: GRUEN -- 0 Treffer bei Nenner 2").
ORT: super CI REV-CI-04
SOLL/FIX: Arbeitsteilung dokumentiert (neue Paritaets-Wache deckt Gitlink-gegen-Gitlink).
STATUS LT. QUELLE: behoben (durch neue Wache), Erkenntnis dokumentationswuerdig
ABHAENGIGKEIT/FLAECHE: -

### [wbl8tsmpf.json] 92
GEGENSTAND: Verify-Ergebnis: Substanz HAELT (Wache beisst in beide Richtungen, kein halb-bumpender gruener Pfad, kein Job bricht, fail-closed auch bei unborn HEAD/zerstoertem Index, dash-portabel). DREI Ein-Zeilen-Korrekturen, keine blockiert die Landung: LUECKE A = Skript-Kopf-Zusage "git-Fehler sind fatal (Exit 2)" ist FALSCH -- set -eu ohne pipefail, awk schluckt den git-Fehler, Exit 1 statt 2 (Fix: pipefail bzw. dash-Zwischenvariable); LUECKE B = --erwartet mit LEEREM Wert entwaffnet die Nachbedingung STILL (Fix: Format-Gate 40 Hexziffern, sonst Exit 2); LUECKE C = Bericht behauptete "0 ueber 120 Byte" fuer die YAML-Zusatzzeilen -- real 3 von 39 ueber 120 Byte (verstoessig nur gegen die Behauptung, .yml ist ausser Wachen-Scope).
ORT: super ci/thesis_gitlink_parity.sh (Kopf; --erwartet-Zweig); Verify-Protokoll
SOLL/FIX: A+B+C als Ein-Zeilen-Korrekturen VOR/BEI Landung.
STATUS LT. QUELLE: offen (3 Mini-Fixes)
ABHAENGIGKEIT/FLAECHE: Landung des Branches (Posten 90)

### [wbl8tsmpf.json] 93
GEGENSTAND: Scope-Grenzen der neuen Wache (nicht Defekte, aber Vertragslage): (a) Paritaet ist NICHT Aufloesbarkeit -- zwei Gitlinks auf einen NICHT existierenden Commit melden gruen (deckt REV-CI-04 arbeitsteilig, aber die Wache allein ist kein Gueltigkeitsbeweis); (b) verify:submodules extends .code-rules -> AENDERUNGS-GEGATET, keine stehende Invariante: ein docs-only-Commit auf bereits divergentem Baum laeuft gruen, weil der Job nicht startet (fuer Praevention NEUER Divergenz ausreichend); (c) ob GitLabs fnmatch Code/external/* den zweiten Gitlink matcht, ist SCHLUSS, nicht Messung (Ruby fehlt auf der Maschine).
ORT: super .gitlab-ci.yml verify:submodules/.code-rules
SOLL/FIX: Als bekannte Grenzen fuehren; ggf. stehende Invariante erwaegen.
STATUS LT. QUELLE: nur-hinweis (dokumentierte Grenzen)
ABHAENGIGKEIT/FLAECHE: EIN GRUENES GATE deckt nur seinen Gegenstand (Memory-Regel)

### [wbl8tsmpf.json] 94
GEGENSTAND: OWNER-FRAGE (nicht entschieden): darf die Doppel-Einbindung Code/external/20260931-overleaf-diplomarbeit entfallen? Empfehlung JA (0 CI-/CMake-Konsumenten, kein branch/update in .gitmodules, voller zweiter Klon je recursive-Job; "jede Wache, die die Doppelung gleichhaelt, ist Arbeit, die eine korrekte Struktur nicht braeuchte"). Kein Zeitdruck (Paket macht Doppelung sicher). Rueckbau-Weg beschrieben (git rm --cached + .gitmodules-Abschnitt + .git/modules + THESIS_GITLINKS-Zeilen + Skript deprecaten, nicht loeschen); ausdruecklich NICHT vorbereitet. Nebenfrage: trigger:thesis gatet nur auf thesis/diplomarbeit -- Bump NUR des toten Zeigers weckt die 289-Bridge nicht (solange gleichgehalten folgenlos; im Kommentar festgehalten).
ORT: super .gitmodules:51-56; .gitlab-ci.yml:337
SOLL/FIX: Owner-GO einholen; nach GO Rueckbau nach beschriebenem Weg.
STATUS LT. QUELLE: offen (Owner-Frage)
ABHAENGIGKEIT/FLAECHE: anhang:forward bricht nach Entfernung LAUT ab (P2-3, verifiziert) -- kein Resurrektions-Risiko

### [wbl8tsmpf.json] 95
GEGENSTAND: Arbeitsumgebungs-Befunde: (a) fremder Agent committete e36071f9 (Dublette von 1c7cdcb6, gleicher Baum) AUF den fremden Branch -- repariert ohne rebase per git commit-tree + reset --soft (Baum bitgleich verifiziert); Beleg fuer Ein-Schreiber-Regel-Verletzungsrisiko im geteilten Worktree; (b) Biss-Nachweis lief im isolierten Klon /tmp/bissnachweis-thesis-gitlink -- STEHT NOCH, nicht geloescht; (c) im geteilten Baum uncommitted fremd: M Code/external/comdare-cache-engine (b241a272->90bca126), M LEDGER.md, ?? Code/measure_out_d03/.
ORT: wie genannt
SOLL/FIX: Klon /tmp/bissnachweis-thesis-gitlink aufraeumen (nach Bestaetigung); Ein-Schreiber-Regel.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Ein-Schreiber-je-Worktree (Memory)

---

## Datei 9: w7y69czwo.json (T2-A-NB2-Fortsetzung: Plan-Zaehler-Wahrheit, 5 Befunde; 1 Agent, 364.241 Tokens)

### [w7y69czwo.json] 96
GEGENSTAND: T2-A-NB2 fertiggestellt: WIP der abgebrochenen Welle uebernommen ("der Vorgaenger hatte den CODE aller fuenf Befunde bereits geschrieben, aber KEINEN EINZIGEN BISS") und alle 5 Befunde mit literalem Biss geheilt: (1) Bau-Zaehler vor Push-Drain -> AsyncPushPump::drain() als Barriere + push_vollzug(); (2) Mess-Zaehler ECHTE PRAEFIX-Semantik (Option A, begruendet am Owner-KERN "Front"); (3) Plan-Stempel bindet GENAU DIE MENGE DER ERWARTETEN FINGERPRINTS (|bau=-Glied; ohne Provider |bau=ohne-anker) -- fremder Bau-Stand erbt den Zaehler NICHT; (4) stamp_format als drittes Format-Faktum, v5-Stand faellt BENANNT in format_drift (Glied-Grenze: resume-v60 gilt NICHT als resume-v6); (5) Korn-Divergenz: LazyRunConfig::batch_plan_korn + plan_slice_korn als EINE Quelle. Format-Bump batchplan v2->v3 (EIN Bump fuer ZWEI Bedeutungs-Aenderungen).
ORT: /home/comdare/wt-b2-neuanker, Branch b2-neuanker-format3, Commits 3a88eb88 + a9a352bb (HEAD a9a352bb), 9 Dateien +945/-55, NICHT gepusht
SOLL/FIX: Landung ausstehend (Push-Freigabe noetig).
STATUS LT. QUELLE: behoben@a9a352bb (ungelandet, lokal)
ABHAENGIGKEIT/FLAECHE: Merge-Flaeche cache_engine_builder_iterator.hpp/batch_planner/planer_driven_build; Sicherungsrisiko rein lokaler Commits

### [w7y69czwo.json] 97
GEGENSTAND: Gates der NB2-Welle literal: 2-Pass-Configure mit Bau dazwischen (405->409 Tests, Falle literal bestaetigt); ctest-Doppellauf seriell 2x 409/409 gruen; Roundtrip/golden 6/6; Frozen-Beweis (8-Glieder-Fingerprint unberuehrt, 3 Fixtures blob-identisch, Vektor 17148e5a...ce89374 unveraendert); ASCII 0 / >120 0 / TABU 0. ABER: CLANG-FORMAT-GATE STEHT AUS (kein clang-format auf der Maschine, auch kein cf22).
ORT: /home/comdare/wt-b2-neuanker/build/nb2-gate
SOLL/FIX: clang-format-Gate vor Landung nachholen (prod1-cf22-Gap).
STATUS LT. QUELLE: teilweise (ein Gate offen)
ABHAENGIGKEIT/FLAECHE: Landung (Posten 96)

### [w7y69czwo.json] 98
GEGENSTAND: Ehrliche Grenzen der NB2-Welle: (a) Ebene 1 bleibt im produktiven Host INERT (pa.batch_plan_datei unbelegt) -- "diese Welle macht die Mechanik richtig, sie macht sie nicht erreichbar"; (b) Test 11h wartet per yield()-Spin (bei echtem Pump-Defekt erst ctest-Timeout statt eigener Meldung, bewusst); (c) plan_bau_digest kostet ~129 Byte je Index Preimage (2^17 -> ~17 MB, EINMAL je Planbildung; sha512-Primitive nicht inkrementell) -- im Code beziffert; (d) Korn-Kette endet an LazyRunConfig (kein RunProfileArgs-/XML-Feld) -- mit der Host-Belegung von batch_plan_datei "in EINEM Zug fuehren".
ORT: wie Posten 96
SOLL/FIX: (a)+(d) -> Aktivierungskette (Datei 10); F8-Doktrinfrage (Test 6g bleibt ERWARTUNG) auftragsgemaess nicht angefasst.
STATUS LT. QUELLE: offen (benannte Grenzen)
ABHAENGIGKEIT/FLAECHE: wmhmvlkyd (Aktivierungskette)

### [w7y69czwo.json] 99
GEGENSTAND: 5 begruendete Eingriffe gegenueber dem WIP: (a) Kosten-Klammer fuer plan_identitaet_of (Vorgaenger bildete Stempel UNBEDINGT -- voller FingerprintFn-Durchlauf ueber 2^17 fuer eine Zeichenkette, die niemand liest); (b) Glied-Grenze der Versions-Marke ohne viertes Literal; (c) Test 11f auf den PRODUKTIVEN Ist umgestellt (Fall "Bau ohne Anker / Mess mit Anker" existiert produktiv nicht); (d) test_w5_status_reader ergaenzt (NEUNTE Datei, die der Vorgaenger nicht angefasst hatte); (e) DREI Kommentar-Zusagen eingeloest, die der Code nicht hielt. Nichts verworfen.
ORT: wie Posten 96
SOLL/FIX: -
STATUS LT. QUELLE: behoben (Teil des Pakets)
ABHAENGIGKEIT/FLAECHE: -

---

## Datei 10: wmhmvlkyd.json (Trigger-Vorposten: batch_plan_datei-Aktivierungskette; 1 Agent, 250.686 Tokens)

### [wmhmvlkyd.json] 100
GEGENSTAND: ce-Facade-Glied gebaut: batch_plan_datei durch ALLE DREI Schichten der bestandslog-Naht (ProfileRunArgs :115 / Durchreichen .cpp:731 / RunProfileArgs :147 + make_cfg :641), Default leer = inert/byte-neutral; Nachweis-Test test_t2a_f4_facade_plan_durchreichung (409/409 gruen, Mutations-Gegenprobe literal rot); Frozen-Beweis ok; clang-format NICHT verfuegbar (Gate nicht behauptet).
ORT: wt-b2-neuanker Commit 41091cb4 (Branch b2-neuanker-format3, kein Push), 5 Dateien +292/-0
SOLL/FIX: Landung mit Posten 96.
STATUS LT. QUELLE: behoben@41091cb4 (ungelandet)
ABHAENGIGKEIT/FLAECHE: BEFUND A + B (Posten 101/102) MUESSEN vor Wirksamkeit entschieden sein

### [wmhmvlkyd.json] 101
GEGENSTAND: BEFUND A (BLOCKER fuer die Wirksamkeit): EINE Plan-Ablage je LAUF, aber der Plan-Stempel haengt an der Selektion des PASSES -- all_axes_golden.profile.xml:66-84 deklariert 17 axis_sweeps => 18 Paesse je Lauf, jeder ueberschreibt die Ablage; Folgelauf findet fremden Stempel -> read_phasen_zaehler fail-closed -> KEIN Resume, voller Neubau (verloren nur der Anspruch, nie Messwert/Binary). "Die Host-Belegung allein bleibt fuer all_axes_golden wirkungslos, egal wie die Datei benannt wird." Auffaecherung je Pass beruehrt den Owner-KERN ("EIN Batch-Plan je Lauf") -- bewusst nicht vorweggenommen.
ORT: ce profile_run_entry.hpp:139-147 (Grenze dokumentiert); all_axes_golden.profile.xml:66-84; experiment_plan_director.hpp:1247
SOLL/FIX: Lead-/Owner-Entscheid Auffaecherung je Pass vs. Owner-KERN.
STATUS LT. QUELLE: offen (Blocker)
ABHAENGIGKEIT/FLAECHE: Owner-KERN Batch-Plan; Voll-Bau-4

### [wmhmvlkyd.json] 102
GEGENSTAND: BEFUND B: voll plan-resumierter Lauf => exit_code=1 -- die vom Plan-Resume uebersprungenen Faecher erreichen den Slice-Loop nie, niemand bucht ihre Atome (built=0 -> provision_ok=false -> exit 1), waehrend LAGER-Skips sehr wohl gebucht werden (:1196-1198); widerspricht der eigenen built-Definition (:842 "gebaut ODER lokal resumiert ODER als Lager-Bestand uebersprungen"). KONSEQUENZ: "ein vollstaendig resumiertes 4096er-Fenster macht den CI-Job ROT." Im Test als benannter STOLPERDRAHT festgehalten (faellt bei Heilung).
ORT: ce cache_engine_builder_iterator.hpp:842,1109,1123,1196-1198,1477
SOLL/FIX: Minimal-Vorschlag: planner.resume_atome() nach der Schleife wie die Lager-Skips in agg.succeeded/skipped/total_jobs buchen -- ACHTUNG bewusst MIT [BILANZ-TESTAT]-Zeile einbauen.
STATUS LT. QUELLE: offen (Blocker vor Voll-Bau-4-Aktivierung)
ABHAENGIGKEIT/FLAECHE: CI-Job-Gruen; Posten 101

### [wmhmvlkyd.json] 103
GEGENSTAND: SUPER-HOST-BAU-AUFTRAG (fertige Spezifikation, NICHT gebaut): Code/02_messung_driver/main.cpp -- eine Zeile `pa.batch_plan_datei = batch_plan_datei;` nach :1343 (im bestandslog-Block) + Berechnungsblock nach dem golden-range-Block :1293-1298 (Name batch_plan_<start>_<count>.txt im e4_dir); Gate = EIGENE Env COMDARE_BATCH_PLAN (nicht das bestandslog-Doppel-Gate -- wegen BEFUND B muss Plan-Resume EINZELN schaltbar sein); Pfad-Kanon: Lauf-Ordner, NICHT measurement/ (Messdaten-Wurzel; Praezedenz progress.cursor); Log auf cerr, nicht cout (AUF-B6: cout ist YAML-Kanal). Vorbedingungen: BEFUND A und B zuerst entschieden. Abnahme definiert (Doppellauf mit Profil OHNE axis_sweeps, plan-resume-Zeile in Lauf 2, ohne Env keine Dateien). run_experiment_facade (xa-Pfad) bleibt per AUF-B2 OHNE bestandslog-Felder -- NICHT belegen.
ORT: super Code/02_messung_driver/main.cpp:993,1085-1090,1163,1293-1298,1343,1351
SOLL/FIX: wie Spezifikation; erst nach A+B.
STATUS LT. QUELLE: offen (Spezifikation liegt vor)
ABHAENGIGKEIT/FLAECHE: Posten 101/102; Trigger-Vorposten

---

## Datei 11: wd626pkat.json (E18-SNAP-NB2: Snapshot-/Anhang-Forward-Haertung; 1 Agent, 272.229 Tokens)

### [wd626pkat.json] 104
GEGENSTAND: E18-SNAP-NB2 gebaut: die 5 Codex-Mindestanforderungen erfuellt -- (1) runneruebergreifend eindeutige Namen (<TS>-r<RUNNER>-j<JOB>, mkdir-Fehlerart unterschieden statt 99 Kollisions-Runden); (2) Recovery-Identitaet (PENDING-<Kennung>.txt VOR jedem Push, Bot-Historie als zweite Quelle, Klon nachweislich auf Ausgangs-HEAD zurueckgesetzt -- ALT belegte den NEUEN HEAD statt der schuldigen SHA); (3) gemeinsamer Beleg-Validator (ganze Zeile thesis_commit_sha=<40-hex>, sha256-Konsistenz, kein grep-F-Teiltreffer); (4) erzwungene Re-Kompilation (latexmk -gg + Neuheits-Wache; ALT beschriftete die ALTE PDF mit der NEUEN SHA = Codex-HOCH-3-Rest); (5) transaktionales Cleanup (.tmp + atomarer mv, fail-closed Remote). Proben 91/0 + 56/0 mit ALT-Gegenproben. .gitlab-ci.yml NACHWEISLICH unberuehrt (Blob-gleich); Writeback-Delta nur als Patch-Vorschlag (apply-check gruen).
ORT: super ci/anhang_forward_core.sh (873->1489 Z.); Branch b-e18-snap, Commit 5c4cf900 (kein Push); docs/sessions/backups/20260806-e18-snap/ (Fixture+Patch+ANWENDUNG.md)
SOLL/FIX: Landung ausstehend; Patch-Vorschlag gitlab-ci-delta.patch muss separat angewandt werden.
STATUS LT. QUELLE: behoben@5c4cf900 (ungelandet)
ABHAENGIGKEIT/FLAECHE: KREUZ-BEFUND wo2zqnqhb Posten 89: 5c4cf900 ist NICHT Vorfahr von development ("rescue-Ref ist keine Landung") -- Landungs-/Bergungs-Posten

### [wd626pkat.json] 105
GEGENSTAND: MITTEL-Reste alle mit Probe geschlossen (af_sha256 fail-loud; leerer SHA im AF_NO_PUSH-Pfad FATAL; AF_SNAPSHOT_ROOT-Vertrag inkl. Toplevel; zentraler Rollback beim cp-Abbruch; TOCTOU per noclobber; AF_LANGS dedupliziert; FETCH_HEAD sofort aufgeloest; copied=0 beendet nicht mehr vor der Nachhol-Wache). 288-Writeback-Pruefgrenze im Patch nachgezogen (nicht-hex thesis_commit_sha = RC 1; .tmp-Halbstand gemeldet+entfernt statt still mitgestagt).
ORT: wie Posten 104
SOLL/FIX: -
STATUS LT. QUELLE: behoben (im ungelandeten Commit)
ABHAENGIGKEIT/FLAECHE: Posten 104

### [wd626pkat.json] 106
GEGENSTAND: Offene Punkte / bewusste Grenzen der SNAP-Welle: (1) Marker-Reichweite (Lauf ohne 288-Writeback: Marker stirbt mit dem Workspace; zweite Quelle Bot-Historie AF_RECOVER_TIEFE=20); (2) EINE Nachholung je Lauf (AF_RECOVER_MAX=1, bewusst); (3) Marker-Ansammlung PENDING-*.txt nie geloescht -- Aufraeum-Entscheid = Lead; (4) quelle_kind/quelle_ref beschreiben die Quelle DIESES Laufs; (5) mv-Veroeffentlichung gegen fremdes gleichzeitiges Anlegen nicht formal geschuetzt (Kennung macht Namen disjunkt); (6) VERHALTENSAENDERUNG die der Lead kennen muss: Wurzel-Vertrag jetzt auch im Vorwaerts-Pfad VOR dem Push geprueft -- falsch gesetzte AF_SNAPSHOT_ROOT macht den Job ROT statt gruen-ohne-Beleg (Patch setzt sie korrekt); (7) AF_SNAP_LAUF_KENNUNG nur fuer Proben, CI setzt sie nie.
ORT: wie Posten 104
SOLL/FIX: (3) Lead-Entscheid; (6) bei Patch-Anwendung beachten.
STATUS LT. QUELLE: offen (benannte Grenzen)
ABHAENGIGKEIT/FLAECHE: Patch-Anwendung .gitlab-ci.yml

---

## Datei 12: w2z8rp4xk.json (F3-Planungssession Scheibe-6 Weg a, bindender Plan, kein Bau; 1 Agent, 160.731 Tokens)

### [w2z8rp4xk.json] 107
GEGENSTAND: Bindender Plan fuer Weg a (docs/plaene/20260806-PLAN-scheibe6-weg-a-fixture-entflechtung.md, 689 Z., ASCII 0): MASTER bleibt komplett unveraendert (+additiver ABGRENZUNG-Absatz); ce-Fixture per git mv zu tests/unit/thesis_tiere/experiment_kern_seam_fixture.xml, Define COMDARE_EXPERIMENT_GOLDEN_KERN -> COMDARE_EXPERIMENT_KERN_SEAM_FIXTURE, Werte byte-identisch, 6-zeilige Divergenz-Tabelle IN die Datei; Schrittfolge [0] B14 gelandet -> [1] ce-Commit Move + 4 Nachzuege -> [2] super-Commit -DFIXTURE-Pfad + R1/R2-Haertung + Gitlink-Bump im SELBEN Commit -> [3] CI-Heimat (vorziehbar) -> [4] Ledger. Je Schritt Rename-Reinheits-Beweis (1 R / 0 A / 0 D) + 6 Biss-Praeparate.
ORT: super docs/plaene/20260806-PLAN-scheibe6-weg-a-fixture-entflechtung.md
SOLL/FIX: R1: nach Umbenennung feuert SKIP-Zweig -> ctest-SKIPPED zaehlt nicht als Fehler -> einzige Wache lautlos ab; Gegenmassnahme: Verzeichnis existiert + Datei fehlt = FATAL statt SKIP, Haertung VOR dem Rename landen, Biss-Beweis ALT=SKIPPED/RC=0 vs NEU=FATAL/RC=1. Reihenfolge-Empfehlung B14/NB3 -> Weg a -> F5; Reissleine: startet F5 zuerst, wird Weg a Schritt 1 INNERHALB F5 -- nie parallel. ~2,5 h netto, golden-neutral, Rename nach Abgabe.
STATUS LT. QUELLE: offen (Plan bindend, kein Bau)
ABHAENGIGKEIT/FLAECHE: wo2zqnqhb Posten 81 (spaeterer Stand: Vorbedingung inzwischen erfuellt, R1 weiter scharf)

### [w2z8rp4xk.json] 108
GEGENSTAND: DREI Befunde, die von der Vorlage abweichen: (1) "12 hartverdrahtete Tests" ist FALSCH -- test_experiment_kern_seam.cpp hat 15 TEST-Bloecke, davon lesen genau 6 die Fixture (via parse_kern), 9 sind rename-neutral (klaert die in wo2zqnqhb als UNBELEGT gefuehrte 12er-Zahl); (2) "GEBAUT wurde Weg b" -- gebaut ja, GELANDET nein (fixture_schema_subset_check.cmake existierte nur in wt-b14-golden @ 953ce412; development e75db8f9 hatte sie nicht) -- harte Vorbedingung; (3) NEU = R4: test_experiment_kern_seam traegt Label contract, wurde per -LE contract|pmc ausgeschlossen und stand in KEINEM -R-Regex -> die gesamte machines/pruefling/fulljoin/storage-Naht lief in KEINEM CI-Job ("Pipeline gruen ist fuer dieses Paket wertlos").
ORT: ce tests/unit/thesis_tiere/test_experiment_kern_seam.cpp; tests/unit/CMakeLists.txt:3334; alt ce/.gitlab-ci.yml:479
SOLL/FIX: R4 sofort vorziehen (15 min) -- INZWISCHEN ERLEDIGT laut wo2zqnqhb Posten 82 (dcb2f08f, Wurzelschnitt).
STATUS LT. QUELLE: teilweise (R4 behoben; Rename offen)
ABHAENGIGKEIT/FLAECHE: Zeitfolge: dieser Plan (06.08.) ist VOR der B14-Landung erhoben; wo2zqnqhb (06.08. abends) ist der neuere Stand

### [w2z8rp4xk.json] 109
GEGENSTAND: Abgrenzungs-Doktrin des Plans: Trennlinie = NAMEN (Weg a) vs WERTE (F5); der eindeutige Fixture-Name macht F5 sicherer ("F5 ist genau die Welle, in der ein Angleich-Reflex die D3-D6-Beweise loeschen wuerde, waehrend alle Werte legitim in Bewegung sind").
ORT: Plan Abschnitt ABGRENZUNG/REIHENFOLGE
SOLL/FIX: Bei F5-/Weg-a-Design beruecksichtigen.
STATUS LT. QUELLE: nur-hinweis (Doktrin)
ABHAENGIGKEIT/FLAECHE: F5 (wo2zqnqhb Posten 83)

---

## BILANZ LESER 11
- Batch: 12 von 12 Dateien VOLLSTAENDIG gelesen (Index 10,22,34,46,58,70,82,94,106,118,130,142 der 152er-Liste).
- Extrahierte Posten: 109 (fortlaufend nummeriert 1-109 ueber alle 12 Quelldateien).
- Quellen-eigene Luecken (weitergegeben, nicht rekonstruiert): wounn9tiw-Dokument bricht in Abschnitt 4/5.1 ab (Uebermittlungsluecke der Quelle selbst); dort ausgewiesene Zaehl-Diskrepanzen (Learnings 206/316, Widerrufe 4 vs 3, Nichtfunde 29 vs 24); W-6-Restbegruendung abgerissen; 2 "unsaubere Formulierungen" im pmc-intel-Widerruf abgerissen.
- Kreuz-Konflikte fuer den Designer markiert: branch_misses "immer 0/M-3a" (w2sl5tl3q) vs "geheilt durch aa06f900" (wounn9tiw); m3v2-Leerfenster offen (w7uqir5wv) vs "behoben seit 2b5ecd29" (wzrgiwiew/wounn9tiw); measure:smoke-Entlastung widerrufen (wo2zqnqhb AP-12); PMC-Achsen-Zuordnung (wk7d8rkxb, 06.08.) gegen Owner-Antworten 10.08. abgleichen; "12 Naht-Tests" (wo2zqnqhb) durch w2z8rp4xk als 6-von-15 geklaert; 5c4cf900-Landungsstatus (wd626pkat gebaut vs wo2zqnqhb "kein Vorfahr").

SELBSTCHECK: Diese Datei ist ASCII-only; alle 12 Batch-Dateien vollstaendig gelesen; jede Zahl traegt ihren Nenner oder ihre Quelle; keine Platzhalter-Abschnitte.
